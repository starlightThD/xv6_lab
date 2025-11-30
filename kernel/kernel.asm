
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_entry>:
.section .text # 设置代码段，基于内存的段式管理
.global _entry # 设置全局入口点，告知连接器入口地址

_entry: # 定义入口点标签
		la sp, stack0
    80200000:	0003c117          	auipc	sp,0x3c
    80200004:	00010113          	mv	sp,sp
        li a0,4096*4 # 表示4096个字节单位
    80200008:	6511                	lui	a0,0x4
        add sp,sp,a0 # 初始化栈指针
    8020000a:	912a                	add	sp,sp,a0

        la a0,_bss_start
    8020000c:	0003d517          	auipc	a0,0x3d
    80200010:	0a450513          	addi	a0,a0,164 # 8023d0b0 <kernel_pagetable>
        la a1,_bss_end
    80200014:	00049597          	auipc	a1,0x49
    80200018:	91c58593          	addi	a1,a1,-1764 # 80248930 <_bss_end>

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
    80200032:	1101                	addi	sp,sp,-32 # 8023bfe0 <user_test_table+0x5b0>
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
    8020009c:	29c080e7          	jalr	668(ra) # 80203334 <pmm_init>
	kvminit();
    802000a0:	00003097          	auipc	ra,0x3
    802000a4:	860080e7          	jalr	-1952(ra) # 80202900 <kvminit>
	trap_init();
    802000a8:	00004097          	auipc	ra,0x4
    802000ac:	8b0080e7          	jalr	-1872(ra) # 80203958 <trap_init>
	uart_init();
    802000b0:	00000097          	auipc	ra,0x0
    802000b4:	5ae080e7          	jalr	1454(ra) # 8020065e <uart_init>
	intr_on();
    802000b8:	00000097          	auipc	ra,0x0
    802000bc:	fae080e7          	jalr	-82(ra) # 80200066 <intr_on>
    printf("===============================================\n");
    802000c0:	0000f517          	auipc	a0,0xf
    802000c4:	26050513          	addi	a0,a0,608 # 8020f320 <user_test_table+0x138>
    802000c8:	00001097          	auipc	ra,0x1
    802000cc:	1bc080e7          	jalr	444(ra) # 80201284 <printf>
    printf("        RISC-V Operating System v1.0         \n");
    802000d0:	0000f517          	auipc	a0,0xf
    802000d4:	28850513          	addi	a0,a0,648 # 8020f358 <user_test_table+0x170>
    802000d8:	00001097          	auipc	ra,0x1
    802000dc:	1ac080e7          	jalr	428(ra) # 80201284 <printf>
    printf("===============================================\n\n");
    802000e0:	0000f517          	auipc	a0,0xf
    802000e4:	2a850513          	addi	a0,a0,680 # 8020f388 <user_test_table+0x1a0>
    802000e8:	00001097          	auipc	ra,0x1
    802000ec:	19c080e7          	jalr	412(ra) # 80201284 <printf>
	init_proc(); // 初始化进程管理子系统
    802000f0:	00005097          	auipc	ra,0x5
    802000f4:	194080e7          	jalr	404(ra) # 80205284 <init_proc>
	int main_pid = create_kernel_proc(kernel_main);
    802000f8:	00000517          	auipc	a0,0x0
    802000fc:	46050513          	addi	a0,a0,1120 # 80200558 <kernel_main>
    80200100:	00005097          	auipc	ra,0x5
    80200104:	5c6080e7          	jalr	1478(ra) # 802056c6 <create_kernel_proc>
    80200108:	87aa                	mv	a5,a0
    8020010a:	fef42623          	sw	a5,-20(s0)
	if (main_pid < 0){
    8020010e:	fec42783          	lw	a5,-20(s0)
    80200112:	2781                	sext.w	a5,a5
    80200114:	0007da63          	bgez	a5,80200128 <start+0x98>
		panic("START: create main process failed!\n");
    80200118:	0000f517          	auipc	a0,0xf
    8020011c:	2a850513          	addi	a0,a0,680 # 8020f3c0 <user_test_table+0x1d8>
    80200120:	00001097          	auipc	ra,0x1
    80200124:	6e6080e7          	jalr	1766(ra) # 80201806 <panic>
	schedule();
    80200128:	00006097          	auipc	ra,0x6
    8020012c:	b00080e7          	jalr	-1280(ra) # 80205c28 <schedule>
    panic("START: main() exit unexpectedly!!!\n");
    80200130:	0000f517          	auipc	a0,0xf
    80200134:	2b850513          	addi	a0,a0,696 # 8020f3e8 <user_test_table+0x200>
    80200138:	00001097          	auipc	ra,0x1
    8020013c:	6ce080e7          	jalr	1742(ra) # 80201806 <panic>
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
    80200152:	0000f517          	auipc	a0,0xf
    80200156:	2be50513          	addi	a0,a0,702 # 8020f410 <user_test_table+0x228>
    8020015a:	00001097          	auipc	ra,0x1
    8020015e:	12a080e7          	jalr	298(ra) # 80201284 <printf>
    for (int i = 0; i < KERNEL_TEST_COUNT; i++) {
    80200162:	fe042623          	sw	zero,-20(s0)
    80200166:	a835                	j	802001a2 <print_menu+0x58>
        printf("  k%d. %s\n", i+1, kernel_test_table[i].name);
    80200168:	fec42783          	lw	a5,-20(s0)
    8020016c:	2785                	addiw	a5,a5,1
    8020016e:	0007869b          	sext.w	a3,a5
    80200172:	0003d717          	auipc	a4,0x3d
    80200176:	e8e70713          	addi	a4,a4,-370 # 8023d000 <kernel_test_table>
    8020017a:	fec42783          	lw	a5,-20(s0)
    8020017e:	0792                	slli	a5,a5,0x4
    80200180:	97ba                	add	a5,a5,a4
    80200182:	639c                	ld	a5,0(a5)
    80200184:	863e                	mv	a2,a5
    80200186:	85b6                	mv	a1,a3
    80200188:	0000f517          	auipc	a0,0xf
    8020018c:	2a050513          	addi	a0,a0,672 # 8020f428 <user_test_table+0x240>
    80200190:	00001097          	auipc	ra,0x1
    80200194:	0f4080e7          	jalr	244(ra) # 80201284 <printf>
    for (int i = 0; i < KERNEL_TEST_COUNT; i++) {
    80200198:	fec42783          	lw	a5,-20(s0)
    8020019c:	2785                	addiw	a5,a5,1
    8020019e:	fef42623          	sw	a5,-20(s0)
    802001a2:	fec42783          	lw	a5,-20(s0)
    802001a6:	873e                	mv	a4,a5
    802001a8:	47a1                	li	a5,8
    802001aa:	fae7ffe3          	bgeu	a5,a4,80200168 <print_menu+0x1e>
    printf("\n=== 用户测试 ===\n");
    802001ae:	0000f517          	auipc	a0,0xf
    802001b2:	28a50513          	addi	a0,a0,650 # 8020f438 <user_test_table+0x250>
    802001b6:	00001097          	auipc	ra,0x1
    802001ba:	0ce080e7          	jalr	206(ra) # 80201284 <printf>
    for (int i = 0; i < USER_TEST_COUNT; i++) {
    802001be:	fe042423          	sw	zero,-24(s0)
    802001c2:	a081                	j	80200202 <print_menu+0xb8>
        printf("  u%d. %s\n", i+1, user_test_table[i].name);
    802001c4:	fe842783          	lw	a5,-24(s0)
    802001c8:	2785                	addiw	a5,a5,1
    802001ca:	0007859b          	sext.w	a1,a5
    802001ce:	0000f697          	auipc	a3,0xf
    802001d2:	01a68693          	addi	a3,a3,26 # 8020f1e8 <user_test_table>
    802001d6:	fe842703          	lw	a4,-24(s0)
    802001da:	87ba                	mv	a5,a4
    802001dc:	0786                	slli	a5,a5,0x1
    802001de:	97ba                	add	a5,a5,a4
    802001e0:	078e                	slli	a5,a5,0x3
    802001e2:	97b6                	add	a5,a5,a3
    802001e4:	639c                	ld	a5,0(a5)
    802001e6:	863e                	mv	a2,a5
    802001e8:	0000f517          	auipc	a0,0xf
    802001ec:	26850513          	addi	a0,a0,616 # 8020f450 <user_test_table+0x268>
    802001f0:	00001097          	auipc	ra,0x1
    802001f4:	094080e7          	jalr	148(ra) # 80201284 <printf>
    for (int i = 0; i < USER_TEST_COUNT; i++) {
    802001f8:	fe842783          	lw	a5,-24(s0)
    802001fc:	2785                	addiw	a5,a5,1
    802001fe:	fef42423          	sw	a5,-24(s0)
    80200202:	fe842783          	lw	a5,-24(s0)
    80200206:	873e                	mv	a4,a5
    80200208:	4791                	li	a5,4
    8020020a:	fae7fde3          	bgeu	a5,a4,802001c4 <print_menu+0x7a>
    printf("\n=== 基础命令 ===\n");
    8020020e:	0000f517          	auipc	a0,0xf
    80200212:	25250513          	addi	a0,a0,594 # 8020f460 <user_test_table+0x278>
    80200216:	00001097          	auipc	ra,0x1
    8020021a:	06e080e7          	jalr	110(ra) # 80201284 <printf>
    printf("  h. help          - 显示此帮助\n");
    8020021e:	0000f517          	auipc	a0,0xf
    80200222:	25a50513          	addi	a0,a0,602 # 8020f478 <user_test_table+0x290>
    80200226:	00001097          	auipc	ra,0x1
    8020022a:	05e080e7          	jalr	94(ra) # 80201284 <printf>
    printf("  e. exit          - 退出控制台\n");
    8020022e:	0000f517          	auipc	a0,0xf
    80200232:	27250513          	addi	a0,a0,626 # 8020f4a0 <user_test_table+0x2b8>
    80200236:	00001097          	auipc	ra,0x1
    8020023a:	04e080e7          	jalr	78(ra) # 80201284 <printf>
    printf("  p. ps            - 显示进程状态\n");
    8020023e:	0000f517          	auipc	a0,0xf
    80200242:	28a50513          	addi	a0,a0,650 # 8020f4c8 <user_test_table+0x2e0>
    80200246:	00001097          	auipc	ra,0x1
    8020024a:	03e080e7          	jalr	62(ra) # 80201284 <printf>
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
    8020026e:	0000f517          	auipc	a0,0xf
    80200272:	28a50513          	addi	a0,a0,650 # 8020f4f8 <user_test_table+0x310>
    80200276:	00001097          	auipc	ra,0x1
    8020027a:	00e080e7          	jalr	14(ra) # 80201284 <printf>
        readline(input_buffer, sizeof(input_buffer));
    8020027e:	ed840793          	addi	a5,s0,-296
    80200282:	10000593          	li	a1,256
    80200286:	853e                	mv	a0,a5
    80200288:	00000097          	auipc	ra,0x0
    8020028c:	7f8080e7          	jalr	2040(ra) # 80200a80 <readline>
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
    802002be:	0000f717          	auipc	a4,0xf
    802002c2:	49a70713          	addi	a4,a4,1178 # 8020f758 <user_test_table+0x570>
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
    80200312:	e62080e7          	jalr	-414(ra) # 80206170 <print_proc_table>
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
    80200340:	1d2080e7          	jalr	466(ra) # 8020650e <atoi>
    80200344:	87aa                	mv	a5,a0
    80200346:	37fd                	addiw	a5,a5,-1
    80200348:	fef42023          	sw	a5,-32(s0)
            if (index >= 0 && index < KERNEL_TEST_COUNT) {
    8020034c:	fe042783          	lw	a5,-32(s0)
    80200350:	2781                	sext.w	a5,a5
    80200352:	0807cc63          	bltz	a5,802003ea <console+0x192>
    80200356:	fe042783          	lw	a5,-32(s0)
    8020035a:	873e                	mv	a4,a5
    8020035c:	47a1                	li	a5,8
    8020035e:	08e7e663          	bltu	a5,a4,802003ea <console+0x192>
                printf("\n----- 执行内核测试: %s -----\n", 
    80200362:	0003d717          	auipc	a4,0x3d
    80200366:	c9e70713          	addi	a4,a4,-866 # 8023d000 <kernel_test_table>
    8020036a:	fe042783          	lw	a5,-32(s0)
    8020036e:	0792                	slli	a5,a5,0x4
    80200370:	97ba                	add	a5,a5,a4
    80200372:	639c                	ld	a5,0(a5)
    80200374:	85be                	mv	a1,a5
    80200376:	0000f517          	auipc	a0,0xf
    8020037a:	19250513          	addi	a0,a0,402 # 8020f508 <user_test_table+0x320>
    8020037e:	00001097          	auipc	ra,0x1
    80200382:	f06080e7          	jalr	-250(ra) # 80201284 <printf>
                int pid = create_kernel_proc(kernel_test_table[index].func);
    80200386:	0003d717          	auipc	a4,0x3d
    8020038a:	c7a70713          	addi	a4,a4,-902 # 8023d000 <kernel_test_table>
    8020038e:	fe042783          	lw	a5,-32(s0)
    80200392:	0792                	slli	a5,a5,0x4
    80200394:	97ba                	add	a5,a5,a4
    80200396:	679c                	ld	a5,8(a5)
    80200398:	853e                	mv	a0,a5
    8020039a:	00005097          	auipc	ra,0x5
    8020039e:	32c080e7          	jalr	812(ra) # 802056c6 <create_kernel_proc>
    802003a2:	87aa                	mv	a5,a0
    802003a4:	fcf42e23          	sw	a5,-36(s0)
                if (pid < 0) {
    802003a8:	fdc42783          	lw	a5,-36(s0)
    802003ac:	2781                	sext.w	a5,a5
    802003ae:	0007db63          	bgez	a5,802003c4 <console+0x16c>
                    printf("创建内核测试进程失败\n");
    802003b2:	0000f517          	auipc	a0,0xf
    802003b6:	17e50513          	addi	a0,a0,382 # 8020f530 <user_test_table+0x348>
    802003ba:	00001097          	auipc	ra,0x1
    802003be:	eca080e7          	jalr	-310(ra) # 80201284 <printf>
            if (index >= 0 && index < KERNEL_TEST_COUNT) {
    802003c2:	a82d                	j	802003fc <console+0x1a4>
                    printf("创建内核测试进程成功，PID: %d\n", pid);
    802003c4:	fdc42783          	lw	a5,-36(s0)
    802003c8:	85be                	mv	a1,a5
    802003ca:	0000f517          	auipc	a0,0xf
    802003ce:	18650513          	addi	a0,a0,390 # 8020f550 <user_test_table+0x368>
    802003d2:	00001097          	auipc	ra,0x1
    802003d6:	eb2080e7          	jalr	-334(ra) # 80201284 <printf>
                    wait_proc(&status);
    802003da:	ed440793          	addi	a5,s0,-300
    802003de:	853e                	mv	a0,a5
    802003e0:	00006097          	auipc	ra,0x6
    802003e4:	c06080e7          	jalr	-1018(ra) # 80205fe6 <wait_proc>
            if (index >= 0 && index < KERNEL_TEST_COUNT) {
    802003e8:	a811                	j	802003fc <console+0x1a4>
                printf("无效的内核测试序号\n");
    802003ea:	0000f517          	auipc	a0,0xf
    802003ee:	19650513          	addi	a0,a0,406 # 8020f580 <user_test_table+0x398>
    802003f2:	00001097          	auipc	ra,0x1
    802003f6:	e92080e7          	jalr	-366(ra) # 80201284 <printf>
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
    80200426:	0ec080e7          	jalr	236(ra) # 8020650e <atoi>
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
    80200448:	0000f697          	auipc	a3,0xf
    8020044c:	da068693          	addi	a3,a3,-608 # 8020f1e8 <user_test_table>
    80200450:	fe842703          	lw	a4,-24(s0)
    80200454:	87ba                	mv	a5,a4
    80200456:	0786                	slli	a5,a5,0x1
    80200458:	97ba                	add	a5,a5,a4
    8020045a:	078e                	slli	a5,a5,0x3
    8020045c:	97b6                	add	a5,a5,a3
    8020045e:	639c                	ld	a5,0(a5)
                printf("\n----- 执行用户测试: %s -----\n", 
    80200460:	85be                	mv	a1,a5
    80200462:	0000f517          	auipc	a0,0xf
    80200466:	13e50513          	addi	a0,a0,318 # 8020f5a0 <user_test_table+0x3b8>
    8020046a:	00001097          	auipc	ra,0x1
    8020046e:	e1a080e7          	jalr	-486(ra) # 80201284 <printf>
                int pid = create_user_proc(user_test_table[index].binary,
    80200472:	0000f697          	auipc	a3,0xf
    80200476:	d7668693          	addi	a3,a3,-650 # 8020f1e8 <user_test_table>
    8020047a:	fe842703          	lw	a4,-24(s0)
    8020047e:	87ba                	mv	a5,a4
    80200480:	0786                	slli	a5,a5,0x1
    80200482:	97ba                	add	a5,a5,a4
    80200484:	078e                	slli	a5,a5,0x3
    80200486:	97b6                	add	a5,a5,a3
    80200488:	6790                	ld	a2,8(a5)
                                         user_test_table[index].size);
    8020048a:	0000f697          	auipc	a3,0xf
    8020048e:	d5e68693          	addi	a3,a3,-674 # 8020f1e8 <user_test_table>
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
    802004aa:	36c080e7          	jalr	876(ra) # 80205812 <create_user_proc>
    802004ae:	87aa                	mv	a5,a0
    802004b0:	fef42223          	sw	a5,-28(s0)
                if (pid < 0) {
    802004b4:	fe442783          	lw	a5,-28(s0)
    802004b8:	2781                	sext.w	a5,a5
    802004ba:	0007db63          	bgez	a5,802004d0 <console+0x278>
                    printf("创建用户测试进程失败\n");
    802004be:	0000f517          	auipc	a0,0xf
    802004c2:	10a50513          	addi	a0,a0,266 # 8020f5c8 <user_test_table+0x3e0>
    802004c6:	00001097          	auipc	ra,0x1
    802004ca:	dbe080e7          	jalr	-578(ra) # 80201284 <printf>
            if (index >= 0 && index < USER_TEST_COUNT) {
    802004ce:	a82d                	j	80200508 <console+0x2b0>
                    printf("创建用户测试进程成功，PID: %d\n", pid);
    802004d0:	fe442783          	lw	a5,-28(s0)
    802004d4:	85be                	mv	a1,a5
    802004d6:	0000f517          	auipc	a0,0xf
    802004da:	11250513          	addi	a0,a0,274 # 8020f5e8 <user_test_table+0x400>
    802004de:	00001097          	auipc	ra,0x1
    802004e2:	da6080e7          	jalr	-602(ra) # 80201284 <printf>
                    wait_proc(&status);
    802004e6:	ed040793          	addi	a5,s0,-304
    802004ea:	853e                	mv	a0,a5
    802004ec:	00006097          	auipc	ra,0x6
    802004f0:	afa080e7          	jalr	-1286(ra) # 80205fe6 <wait_proc>
            if (index >= 0 && index < USER_TEST_COUNT) {
    802004f4:	a811                	j	80200508 <console+0x2b0>
                printf("无效的用户测试序号\n");
    802004f6:	0000f517          	auipc	a0,0xf
    802004fa:	12250513          	addi	a0,a0,290 # 8020f618 <user_test_table+0x430>
    802004fe:	00001097          	auipc	ra,0x1
    80200502:	d86080e7          	jalr	-634(ra) # 80201284 <printf>
        } else if (input_buffer[0] == 'u' || input_buffer[0] == 'U') {
    80200506:	a03d                	j	80200534 <console+0x2dc>
    80200508:	a035                	j	80200534 <console+0x2dc>
            printf("无效命令: %s\n", input_buffer);
    8020050a:	ed840793          	addi	a5,s0,-296
    8020050e:	85be                	mv	a1,a5
    80200510:	0000f517          	auipc	a0,0xf
    80200514:	12850513          	addi	a0,a0,296 # 8020f638 <user_test_table+0x450>
    80200518:	00001097          	auipc	ra,0x1
    8020051c:	d6c080e7          	jalr	-660(ra) # 80201284 <printf>
            printf("输入 'h' 查看帮助\n");
    80200520:	0000f517          	auipc	a0,0xf
    80200524:	13050513          	addi	a0,a0,304 # 8020f650 <user_test_table+0x468>
    80200528:	00001097          	auipc	ra,0x1
    8020052c:	d5c080e7          	jalr	-676(ra) # 80201284 <printf>
    80200530:	a011                	j	80200534 <console+0x2dc>
        if (input_buffer[0] == '\0') continue;
    80200532:	0001                	nop
    while (!exit_requested) {
    80200534:	fec42783          	lw	a5,-20(s0)
    80200538:	2781                	sext.w	a5,a5
    8020053a:	d2078ae3          	beqz	a5,8020026e <console+0x16>
    printf("控制台进程退出\n");
    8020053e:	0000f517          	auipc	a0,0xf
    80200542:	13250513          	addi	a0,a0,306 # 8020f670 <user_test_table+0x488>
    80200546:	00001097          	auipc	ra,0x1
    8020054a:	d3e080e7          	jalr	-706(ra) # 80201284 <printf>
}
    8020054e:	0001                	nop
    80200550:	70b2                	ld	ra,296(sp)
    80200552:	7412                	ld	s0,288(sp)
    80200554:	6155                	addi	sp,sp,304
    80200556:	8082                	ret

0000000080200558 <kernel_main>:
void kernel_main(void){
    80200558:	7179                	addi	sp,sp,-48
    8020055a:	f406                	sd	ra,40(sp)
    8020055c:	f022                	sd	s0,32(sp)
    8020055e:	1800                	addi	s0,sp,48
    struct inode *rootip = iget(ROOTDEV, ROOTINO);
    80200560:	4585                	li	a1,1
    80200562:	4505                	li	a0,1
    80200564:	0000a097          	auipc	ra,0xa
    80200568:	72a080e7          	jalr	1834(ra) # 8020ac8e <iget>
    8020056c:	fea43423          	sd	a0,-24(s0)
    if (rootip == 0) {
    80200570:	fe843783          	ld	a5,-24(s0)
    80200574:	eb89                	bnez	a5,80200586 <kernel_main+0x2e>
        panic("KERNEL_MAIN: cannot get root inode!\n");
    80200576:	0000f517          	auipc	a0,0xf
    8020057a:	11250513          	addi	a0,a0,274 # 8020f688 <user_test_table+0x4a0>
    8020057e:	00001097          	auipc	ra,0x1
    80200582:	288080e7          	jalr	648(ra) # 80201806 <panic>
    myproc()->cwd = rootip;
    80200586:	00005097          	auipc	ra,0x5
    8020058a:	ada080e7          	jalr	-1318(ra) # 80205060 <myproc>
    8020058e:	872a                	mv	a4,a0
    80200590:	fe843783          	ld	a5,-24(s0)
    80200594:	e77c                	sd	a5,200(a4)
	virtio_disk_init();   // 1. 初始化磁盘驱动
    80200596:	00008097          	auipc	ra,0x8
    8020059a:	d58080e7          	jalr	-680(ra) # 802082ee <virtio_disk_init>
    binit();              // 2. 初始化块缓冲区
    8020059e:	00008097          	auipc	ra,0x8
    802005a2:	7f0080e7          	jalr	2032(ra) # 80208d8e <binit>
    fileinit();           // 3. 初始化文件表
    802005a6:	00009097          	auipc	ra,0x9
    802005aa:	46e080e7          	jalr	1134(ra) # 80209a14 <fileinit>
    iinit();              // 4. 初始化 inode 表
    802005ae:	0000a097          	auipc	ra,0xa
    802005b2:	474080e7          	jalr	1140(ra) # 8020aa22 <iinit>
    fsinit(ROOTDEV);      // 5. 初始化文件系统（会自动调用 initlog）
    802005b6:	4505                	li	a0,1
    802005b8:	0000a097          	auipc	ra,0xa
    802005bc:	0ba080e7          	jalr	186(ra) # 8020a672 <fsinit>
	clear_screen();
    802005c0:	00001097          	auipc	ra,0x1
    802005c4:	d12080e7          	jalr	-750(ra) # 802012d2 <clear_screen>
	int console_pid = create_kernel_proc(console);
    802005c8:	00000517          	auipc	a0,0x0
    802005cc:	c9050513          	addi	a0,a0,-880 # 80200258 <console>
    802005d0:	00005097          	auipc	ra,0x5
    802005d4:	0f6080e7          	jalr	246(ra) # 802056c6 <create_kernel_proc>
    802005d8:	87aa                	mv	a5,a0
    802005da:	fef42223          	sw	a5,-28(s0)
	if (console_pid < 0){
    802005de:	fe442783          	lw	a5,-28(s0)
    802005e2:	2781                	sext.w	a5,a5
    802005e4:	0007db63          	bgez	a5,802005fa <kernel_main+0xa2>
		panic("KERNEL_MAIN: create console process failed!\n");
    802005e8:	0000f517          	auipc	a0,0xf
    802005ec:	0c850513          	addi	a0,a0,200 # 8020f6b0 <user_test_table+0x4c8>
    802005f0:	00001097          	auipc	ra,0x1
    802005f4:	216080e7          	jalr	534(ra) # 80201806 <panic>
    802005f8:	a821                	j	80200610 <kernel_main+0xb8>
		printf("KERNEL_MAIN: console process created with PID %d\n", console_pid);
    802005fa:	fe442783          	lw	a5,-28(s0)
    802005fe:	85be                	mv	a1,a5
    80200600:	0000f517          	auipc	a0,0xf
    80200604:	0e050513          	addi	a0,a0,224 # 8020f6e0 <user_test_table+0x4f8>
    80200608:	00001097          	auipc	ra,0x1
    8020060c:	c7c080e7          	jalr	-900(ra) # 80201284 <printf>
	int pid = wait_proc(&status);
    80200610:	fdc40793          	addi	a5,s0,-36
    80200614:	853e                	mv	a0,a5
    80200616:	00006097          	auipc	ra,0x6
    8020061a:	9d0080e7          	jalr	-1584(ra) # 80205fe6 <wait_proc>
    8020061e:	87aa                	mv	a5,a0
    80200620:	fef42023          	sw	a5,-32(s0)
	if(pid != console_pid){
    80200624:	fe042783          	lw	a5,-32(s0)
    80200628:	873e                	mv	a4,a5
    8020062a:	fe442783          	lw	a5,-28(s0)
    8020062e:	2701                	sext.w	a4,a4
    80200630:	2781                	sext.w	a5,a5
    80200632:	02f70163          	beq	a4,a5,80200654 <kernel_main+0xfc>
		printf("KERNEL_MAIN: unexpected process %d exited with status %d\n", pid, status);
    80200636:	fdc42703          	lw	a4,-36(s0)
    8020063a:	fe042783          	lw	a5,-32(s0)
    8020063e:	863a                	mv	a2,a4
    80200640:	85be                	mv	a1,a5
    80200642:	0000f517          	auipc	a0,0xf
    80200646:	0d650513          	addi	a0,a0,214 # 8020f718 <user_test_table+0x530>
    8020064a:	00001097          	auipc	ra,0x1
    8020064e:	c3a080e7          	jalr	-966(ra) # 80201284 <printf>
	return;
    80200652:	0001                	nop
    80200654:	0001                	nop
    80200656:	70a2                	ld	ra,40(sp)
    80200658:	7402                	ld	s0,32(sp)
    8020065a:	6145                	addi	sp,sp,48
    8020065c:	8082                	ret

000000008020065e <uart_init>:
#include "defs.h"
#define LINE_BUF_SIZE 128
struct uart_input_buf_t uart_input_buf;
// UART初始化函数
void uart_init(void) {
    8020065e:	1141                	addi	sp,sp,-16
    80200660:	e406                	sd	ra,8(sp)
    80200662:	e022                	sd	s0,0(sp)
    80200664:	0800                	addi	s0,sp,16

    WriteReg(IER, 0x00);
    80200666:	100007b7          	lui	a5,0x10000
    8020066a:	0785                	addi	a5,a5,1 # 10000001 <_entry-0x701fffff>
    8020066c:	00078023          	sb	zero,0(a5)
    WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80200670:	100007b7          	lui	a5,0x10000
    80200674:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x701ffffe>
    80200676:	471d                	li	a4,7
    80200678:	00e78023          	sb	a4,0(a5)
    WriteReg(IER, IER_RX_ENABLE);
    8020067c:	100007b7          	lui	a5,0x10000
    80200680:	0785                	addi	a5,a5,1 # 10000001 <_entry-0x701fffff>
    80200682:	4705                	li	a4,1
    80200684:	00e78023          	sb	a4,0(a5)
    register_interrupt(UART0_IRQ, uart_intr);//注册键盘输入的中断处理函数
    80200688:	00000597          	auipc	a1,0x0
    8020068c:	12858593          	addi	a1,a1,296 # 802007b0 <uart_intr>
    80200690:	4529                	li	a0,10
    80200692:	00003097          	auipc	ra,0x3
    80200696:	142080e7          	jalr	322(ra) # 802037d4 <register_interrupt>
    enable_interrupts(UART0_IRQ);
    8020069a:	4529                	li	a0,10
    8020069c:	00003097          	auipc	ra,0x3
    802006a0:	1c2080e7          	jalr	450(ra) # 8020385e <enable_interrupts>
    printf("UART initialized with input support\n");
    802006a4:	00011517          	auipc	a0,0x11
    802006a8:	16c50513          	addi	a0,a0,364 # 80211810 <user_test_table+0x78>
    802006ac:	00001097          	auipc	ra,0x1
    802006b0:	bd8080e7          	jalr	-1064(ra) # 80201284 <printf>
}
    802006b4:	0001                	nop
    802006b6:	60a2                	ld	ra,8(sp)
    802006b8:	6402                	ld	s0,0(sp)
    802006ba:	0141                	addi	sp,sp,16
    802006bc:	8082                	ret

00000000802006be <uart_putc>:

// 发送单个字符
void uart_putc(char c) {
    802006be:	1101                	addi	sp,sp,-32
    802006c0:	ec22                	sd	s0,24(sp)
    802006c2:	1000                	addi	s0,sp,32
    802006c4:	87aa                	mv	a5,a0
    802006c6:	fef407a3          	sb	a5,-17(s0)
    // 等待发送缓冲区空闲
    while((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    802006ca:	0001                	nop
    802006cc:	100007b7          	lui	a5,0x10000
    802006d0:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    802006d2:	0007c783          	lbu	a5,0(a5)
    802006d6:	0ff7f793          	zext.b	a5,a5
    802006da:	2781                	sext.w	a5,a5
    802006dc:	0207f793          	andi	a5,a5,32
    802006e0:	2781                	sext.w	a5,a5
    802006e2:	d7ed                	beqz	a5,802006cc <uart_putc+0xe>
    WriteReg(THR, c);
    802006e4:	100007b7          	lui	a5,0x10000
    802006e8:	fef44703          	lbu	a4,-17(s0)
    802006ec:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70200000>
}
    802006f0:	0001                	nop
    802006f2:	6462                	ld	s0,24(sp)
    802006f4:	6105                	addi	sp,sp,32
    802006f6:	8082                	ret

00000000802006f8 <uart_puts>:

void uart_puts(char *s) {
    802006f8:	7179                	addi	sp,sp,-48
    802006fa:	f422                	sd	s0,40(sp)
    802006fc:	1800                	addi	s0,sp,48
    802006fe:	fca43c23          	sd	a0,-40(s0)
    if (!s) return;
    80200702:	fd843783          	ld	a5,-40(s0)
    80200706:	c7b5                	beqz	a5,80200772 <uart_puts+0x7a>
    
    while (*s) {
    80200708:	a8b9                	j	80200766 <uart_puts+0x6e>
        while ((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    8020070a:	0001                	nop
    8020070c:	100007b7          	lui	a5,0x10000
    80200710:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    80200712:	0007c783          	lbu	a5,0(a5)
    80200716:	0ff7f793          	zext.b	a5,a5
    8020071a:	2781                	sext.w	a5,a5
    8020071c:	0207f793          	andi	a5,a5,32
    80200720:	2781                	sext.w	a5,a5
    80200722:	d7ed                	beqz	a5,8020070c <uart_puts+0x14>
        int sent_count = 0;
    80200724:	fe042623          	sw	zero,-20(s0)
        while (*s && sent_count < 4) { 
    80200728:	a01d                	j	8020074e <uart_puts+0x56>
            WriteReg(THR, *s);
    8020072a:	100007b7          	lui	a5,0x10000
    8020072e:	fd843703          	ld	a4,-40(s0)
    80200732:	00074703          	lbu	a4,0(a4)
    80200736:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70200000>
            s++;
    8020073a:	fd843783          	ld	a5,-40(s0)
    8020073e:	0785                	addi	a5,a5,1
    80200740:	fcf43c23          	sd	a5,-40(s0)
            sent_count++;
    80200744:	fec42783          	lw	a5,-20(s0)
    80200748:	2785                	addiw	a5,a5,1
    8020074a:	fef42623          	sw	a5,-20(s0)
        while (*s && sent_count < 4) { 
    8020074e:	fd843783          	ld	a5,-40(s0)
    80200752:	0007c783          	lbu	a5,0(a5)
    80200756:	cb81                	beqz	a5,80200766 <uart_puts+0x6e>
    80200758:	fec42783          	lw	a5,-20(s0)
    8020075c:	0007871b          	sext.w	a4,a5
    80200760:	478d                	li	a5,3
    80200762:	fce7d4e3          	bge	a5,a4,8020072a <uart_puts+0x32>
    while (*s) {
    80200766:	fd843783          	ld	a5,-40(s0)
    8020076a:	0007c783          	lbu	a5,0(a5)
    8020076e:	ffd1                	bnez	a5,8020070a <uart_puts+0x12>
    80200770:	a011                	j	80200774 <uart_puts+0x7c>
    if (!s) return;
    80200772:	0001                	nop
        }
    }
}
    80200774:	7422                	ld	s0,40(sp)
    80200776:	6145                	addi	sp,sp,48
    80200778:	8082                	ret

000000008020077a <uart_getc>:

int uart_getc(void) {
    8020077a:	1141                	addi	sp,sp,-16
    8020077c:	e422                	sd	s0,8(sp)
    8020077e:	0800                	addi	s0,sp,16
    if ((ReadReg(LSR) & LSR_RX_READY) == 0)
    80200780:	100007b7          	lui	a5,0x10000
    80200784:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    80200786:	0007c783          	lbu	a5,0(a5)
    8020078a:	0ff7f793          	zext.b	a5,a5
    8020078e:	2781                	sext.w	a5,a5
    80200790:	8b85                	andi	a5,a5,1
    80200792:	2781                	sext.w	a5,a5
    80200794:	e399                	bnez	a5,8020079a <uart_getc+0x20>
        return -1; 
    80200796:	57fd                	li	a5,-1
    80200798:	a801                	j	802007a8 <uart_getc+0x2e>
    return ReadReg(RHR); 
    8020079a:	100007b7          	lui	a5,0x10000
    8020079e:	0007c783          	lbu	a5,0(a5) # 10000000 <_entry-0x70200000>
    802007a2:	0ff7f793          	zext.b	a5,a5
    802007a6:	2781                	sext.w	a5,a5
}
    802007a8:	853e                	mv	a0,a5
    802007aa:	6422                	ld	s0,8(sp)
    802007ac:	0141                	addi	sp,sp,16
    802007ae:	8082                	ret

00000000802007b0 <uart_intr>:

void uart_intr(void) {
    802007b0:	1101                	addi	sp,sp,-32
    802007b2:	ec06                	sd	ra,24(sp)
    802007b4:	e822                	sd	s0,16(sp)
    802007b6:	1000                	addi	s0,sp,32
    static char linebuf[LINE_BUF_SIZE];
    static int line_len = 0;

    while (ReadReg(LSR) & LSR_RX_READY) {
    802007b8:	a435                	j	802009e4 <uart_intr+0x234>
        char c = ReadReg(RHR);
    802007ba:	100007b7          	lui	a5,0x10000
    802007be:	0007c783          	lbu	a5,0(a5) # 10000000 <_entry-0x70200000>
    802007c2:	fef405a3          	sb	a5,-21(s0)
		if (c == 0x0c) { // 是'L'与 0x1f按位与的结果
    802007c6:	feb44783          	lbu	a5,-21(s0)
    802007ca:	0ff7f713          	zext.b	a4,a5
    802007ce:	47b1                	li	a5,12
    802007d0:	02f71963          	bne	a4,a5,80200802 <uart_intr+0x52>
            clear_screen();
    802007d4:	00001097          	auipc	ra,0x1
    802007d8:	afe080e7          	jalr	-1282(ra) # 802012d2 <clear_screen>
			if (myproc()->pid == 1){ // 检查当前进程是否为控制台进程
    802007dc:	00005097          	auipc	ra,0x5
    802007e0:	884080e7          	jalr	-1916(ra) # 80205060 <myproc>
    802007e4:	87aa                	mv	a5,a0
    802007e6:	43dc                	lw	a5,4(a5)
    802007e8:	873e                	mv	a4,a5
    802007ea:	4785                	li	a5,1
    802007ec:	1ef71b63          	bne	a4,a5,802009e2 <uart_intr+0x232>
				printf("Console >>> ");
    802007f0:	00011517          	auipc	a0,0x11
    802007f4:	04850513          	addi	a0,a0,72 # 80211838 <user_test_table+0xa0>
    802007f8:	00001097          	auipc	ra,0x1
    802007fc:	a8c080e7          	jalr	-1396(ra) # 80201284 <printf>
			}
            continue;
    80200800:	a2cd                	j	802009e2 <uart_intr+0x232>
        }
        if (c == '\r' || c == '\n') {
    80200802:	feb44783          	lbu	a5,-21(s0)
    80200806:	0ff7f713          	zext.b	a4,a5
    8020080a:	47b5                	li	a5,13
    8020080c:	00f70963          	beq	a4,a5,8020081e <uart_intr+0x6e>
    80200810:	feb44783          	lbu	a5,-21(s0)
    80200814:	0ff7f713          	zext.b	a4,a5
    80200818:	47a9                	li	a5,10
    8020081a:	10f71763          	bne	a4,a5,80200928 <uart_intr+0x178>
            uart_putc('\n');
    8020081e:	4529                	li	a0,10
    80200820:	00000097          	auipc	ra,0x0
    80200824:	e9e080e7          	jalr	-354(ra) # 802006be <uart_putc>
            // 将编辑好的整行写入全局缓冲区
            for (int i = 0; i < line_len; i++) {
    80200828:	fe042623          	sw	zero,-20(s0)
    8020082c:	a8b5                	j	802008a8 <uart_intr+0xf8>
                int next = (uart_input_buf.w + 1) % INPUT_BUF_SIZE;
    8020082e:	0003d797          	auipc	a5,0x3d
    80200832:	8b278793          	addi	a5,a5,-1870 # 8023d0e0 <uart_input_buf>
    80200836:	0847a783          	lw	a5,132(a5)
    8020083a:	2785                	addiw	a5,a5,1
    8020083c:	2781                	sext.w	a5,a5
    8020083e:	2781                	sext.w	a5,a5
    80200840:	07f7f793          	andi	a5,a5,127
    80200844:	fef42023          	sw	a5,-32(s0)
                if (next != uart_input_buf.r) {
    80200848:	0003d797          	auipc	a5,0x3d
    8020084c:	89878793          	addi	a5,a5,-1896 # 8023d0e0 <uart_input_buf>
    80200850:	0807a703          	lw	a4,128(a5)
    80200854:	fe042783          	lw	a5,-32(s0)
    80200858:	04f70363          	beq	a4,a5,8020089e <uart_intr+0xee>
                    uart_input_buf.buf[uart_input_buf.w] = linebuf[i];
    8020085c:	0003d797          	auipc	a5,0x3d
    80200860:	88478793          	addi	a5,a5,-1916 # 8023d0e0 <uart_input_buf>
    80200864:	0847a603          	lw	a2,132(a5)
    80200868:	0003d717          	auipc	a4,0x3d
    8020086c:	90870713          	addi	a4,a4,-1784 # 8023d170 <linebuf.1>
    80200870:	fec42783          	lw	a5,-20(s0)
    80200874:	97ba                	add	a5,a5,a4
    80200876:	0007c703          	lbu	a4,0(a5)
    8020087a:	0003d697          	auipc	a3,0x3d
    8020087e:	86668693          	addi	a3,a3,-1946 # 8023d0e0 <uart_input_buf>
    80200882:	02061793          	slli	a5,a2,0x20
    80200886:	9381                	srli	a5,a5,0x20
    80200888:	97b6                	add	a5,a5,a3
    8020088a:	00e78023          	sb	a4,0(a5)
                    uart_input_buf.w = next;
    8020088e:	fe042703          	lw	a4,-32(s0)
    80200892:	0003d797          	auipc	a5,0x3d
    80200896:	84e78793          	addi	a5,a5,-1970 # 8023d0e0 <uart_input_buf>
    8020089a:	08e7a223          	sw	a4,132(a5)
            for (int i = 0; i < line_len; i++) {
    8020089e:	fec42783          	lw	a5,-20(s0)
    802008a2:	2785                	addiw	a5,a5,1
    802008a4:	fef42623          	sw	a5,-20(s0)
    802008a8:	0003d797          	auipc	a5,0x3d
    802008ac:	94878793          	addi	a5,a5,-1720 # 8023d1f0 <line_len.0>
    802008b0:	4398                	lw	a4,0(a5)
    802008b2:	fec42783          	lw	a5,-20(s0)
    802008b6:	2781                	sext.w	a5,a5
    802008b8:	f6e7cbe3          	blt	a5,a4,8020082e <uart_intr+0x7e>
                }
            }
            // 写入换行符
            int next = (uart_input_buf.w + 1) % INPUT_BUF_SIZE;
    802008bc:	0003d797          	auipc	a5,0x3d
    802008c0:	82478793          	addi	a5,a5,-2012 # 8023d0e0 <uart_input_buf>
    802008c4:	0847a783          	lw	a5,132(a5)
    802008c8:	2785                	addiw	a5,a5,1
    802008ca:	2781                	sext.w	a5,a5
    802008cc:	2781                	sext.w	a5,a5
    802008ce:	07f7f793          	andi	a5,a5,127
    802008d2:	fef42223          	sw	a5,-28(s0)
            if (next != uart_input_buf.r) {
    802008d6:	0003d797          	auipc	a5,0x3d
    802008da:	80a78793          	addi	a5,a5,-2038 # 8023d0e0 <uart_input_buf>
    802008de:	0807a703          	lw	a4,128(a5)
    802008e2:	fe442783          	lw	a5,-28(s0)
    802008e6:	02f70a63          	beq	a4,a5,8020091a <uart_intr+0x16a>
                uart_input_buf.buf[uart_input_buf.w] = '\n';
    802008ea:	0003c797          	auipc	a5,0x3c
    802008ee:	7f678793          	addi	a5,a5,2038 # 8023d0e0 <uart_input_buf>
    802008f2:	0847a783          	lw	a5,132(a5)
    802008f6:	0003c717          	auipc	a4,0x3c
    802008fa:	7ea70713          	addi	a4,a4,2026 # 8023d0e0 <uart_input_buf>
    802008fe:	1782                	slli	a5,a5,0x20
    80200900:	9381                	srli	a5,a5,0x20
    80200902:	97ba                	add	a5,a5,a4
    80200904:	4729                	li	a4,10
    80200906:	00e78023          	sb	a4,0(a5)
                uart_input_buf.w = next;
    8020090a:	fe442703          	lw	a4,-28(s0)
    8020090e:	0003c797          	auipc	a5,0x3c
    80200912:	7d278793          	addi	a5,a5,2002 # 8023d0e0 <uart_input_buf>
    80200916:	08e7a223          	sw	a4,132(a5)
            }
            line_len = 0;
    8020091a:	0003d797          	auipc	a5,0x3d
    8020091e:	8d678793          	addi	a5,a5,-1834 # 8023d1f0 <line_len.0>
    80200922:	0007a023          	sw	zero,0(a5)
        if (c == '\r' || c == '\n') {
    80200926:	a87d                	j	802009e4 <uart_intr+0x234>
        } else if (c == 0x7f || c == 0x08) { // 退格
    80200928:	feb44783          	lbu	a5,-21(s0)
    8020092c:	0ff7f713          	zext.b	a4,a5
    80200930:	07f00793          	li	a5,127
    80200934:	00f70963          	beq	a4,a5,80200946 <uart_intr+0x196>
    80200938:	feb44783          	lbu	a5,-21(s0)
    8020093c:	0ff7f713          	zext.b	a4,a5
    80200940:	47a1                	li	a5,8
    80200942:	04f71763          	bne	a4,a5,80200990 <uart_intr+0x1e0>
            if (line_len > 0) {
    80200946:	0003d797          	auipc	a5,0x3d
    8020094a:	8aa78793          	addi	a5,a5,-1878 # 8023d1f0 <line_len.0>
    8020094e:	439c                	lw	a5,0(a5)
    80200950:	08f05a63          	blez	a5,802009e4 <uart_intr+0x234>
                uart_putc('\b');
    80200954:	4521                	li	a0,8
    80200956:	00000097          	auipc	ra,0x0
    8020095a:	d68080e7          	jalr	-664(ra) # 802006be <uart_putc>
                uart_putc(' ');
    8020095e:	02000513          	li	a0,32
    80200962:	00000097          	auipc	ra,0x0
    80200966:	d5c080e7          	jalr	-676(ra) # 802006be <uart_putc>
                uart_putc('\b');
    8020096a:	4521                	li	a0,8
    8020096c:	00000097          	auipc	ra,0x0
    80200970:	d52080e7          	jalr	-686(ra) # 802006be <uart_putc>
                line_len--;
    80200974:	0003d797          	auipc	a5,0x3d
    80200978:	87c78793          	addi	a5,a5,-1924 # 8023d1f0 <line_len.0>
    8020097c:	439c                	lw	a5,0(a5)
    8020097e:	37fd                	addiw	a5,a5,-1
    80200980:	0007871b          	sext.w	a4,a5
    80200984:	0003d797          	auipc	a5,0x3d
    80200988:	86c78793          	addi	a5,a5,-1940 # 8023d1f0 <line_len.0>
    8020098c:	c398                	sw	a4,0(a5)
            if (line_len > 0) {
    8020098e:	a899                	j	802009e4 <uart_intr+0x234>
            }
        } else if (line_len < LINE_BUF_SIZE - 1) {
    80200990:	0003d797          	auipc	a5,0x3d
    80200994:	86078793          	addi	a5,a5,-1952 # 8023d1f0 <line_len.0>
    80200998:	439c                	lw	a5,0(a5)
    8020099a:	873e                	mv	a4,a5
    8020099c:	07e00793          	li	a5,126
    802009a0:	04e7c263          	blt	a5,a4,802009e4 <uart_intr+0x234>
            uart_putc(c);
    802009a4:	feb44783          	lbu	a5,-21(s0)
    802009a8:	853e                	mv	a0,a5
    802009aa:	00000097          	auipc	ra,0x0
    802009ae:	d14080e7          	jalr	-748(ra) # 802006be <uart_putc>
            linebuf[line_len++] = c;
    802009b2:	0003d797          	auipc	a5,0x3d
    802009b6:	83e78793          	addi	a5,a5,-1986 # 8023d1f0 <line_len.0>
    802009ba:	439c                	lw	a5,0(a5)
    802009bc:	0017871b          	addiw	a4,a5,1
    802009c0:	0007069b          	sext.w	a3,a4
    802009c4:	0003d717          	auipc	a4,0x3d
    802009c8:	82c70713          	addi	a4,a4,-2004 # 8023d1f0 <line_len.0>
    802009cc:	c314                	sw	a3,0(a4)
    802009ce:	0003c717          	auipc	a4,0x3c
    802009d2:	7a270713          	addi	a4,a4,1954 # 8023d170 <linebuf.1>
    802009d6:	97ba                	add	a5,a5,a4
    802009d8:	feb44703          	lbu	a4,-21(s0)
    802009dc:	00e78023          	sb	a4,0(a5)
    802009e0:	a011                	j	802009e4 <uart_intr+0x234>
            continue;
    802009e2:	0001                	nop
    while (ReadReg(LSR) & LSR_RX_READY) {
    802009e4:	100007b7          	lui	a5,0x10000
    802009e8:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    802009ea:	0007c783          	lbu	a5,0(a5)
    802009ee:	0ff7f793          	zext.b	a5,a5
    802009f2:	2781                	sext.w	a5,a5
    802009f4:	8b85                	andi	a5,a5,1
    802009f6:	2781                	sext.w	a5,a5
    802009f8:	dc0791e3          	bnez	a5,802007ba <uart_intr+0xa>
        }
    }
}
    802009fc:	0001                	nop
    802009fe:	0001                	nop
    80200a00:	60e2                	ld	ra,24(sp)
    80200a02:	6442                	ld	s0,16(sp)
    80200a04:	6105                	addi	sp,sp,32
    80200a06:	8082                	ret

0000000080200a08 <uart_getc_blocking>:
// 阻塞式读取一个字符
char uart_getc_blocking(void) {
    80200a08:	1101                	addi	sp,sp,-32
    80200a0a:	ec22                	sd	s0,24(sp)
    80200a0c:	1000                	addi	s0,sp,32
    // 等待直到有字符可读
    while (uart_input_buf.r == uart_input_buf.w) {
    80200a0e:	a011                	j	80200a12 <uart_getc_blocking+0xa>
        // 在实际系统中，这里可能需要让进程睡眠
        // 但目前我们使用简单的轮询
        asm volatile("nop");
    80200a10:	0001                	nop
    while (uart_input_buf.r == uart_input_buf.w) {
    80200a12:	0003c797          	auipc	a5,0x3c
    80200a16:	6ce78793          	addi	a5,a5,1742 # 8023d0e0 <uart_input_buf>
    80200a1a:	0807a703          	lw	a4,128(a5)
    80200a1e:	0003c797          	auipc	a5,0x3c
    80200a22:	6c278793          	addi	a5,a5,1730 # 8023d0e0 <uart_input_buf>
    80200a26:	0847a783          	lw	a5,132(a5)
    80200a2a:	fef703e3          	beq	a4,a5,80200a10 <uart_getc_blocking+0x8>
    }
    
    // 读取字符
    char c = uart_input_buf.buf[uart_input_buf.r];
    80200a2e:	0003c797          	auipc	a5,0x3c
    80200a32:	6b278793          	addi	a5,a5,1714 # 8023d0e0 <uart_input_buf>
    80200a36:	0807a783          	lw	a5,128(a5)
    80200a3a:	0003c717          	auipc	a4,0x3c
    80200a3e:	6a670713          	addi	a4,a4,1702 # 8023d0e0 <uart_input_buf>
    80200a42:	1782                	slli	a5,a5,0x20
    80200a44:	9381                	srli	a5,a5,0x20
    80200a46:	97ba                	add	a5,a5,a4
    80200a48:	0007c783          	lbu	a5,0(a5)
    80200a4c:	fef407a3          	sb	a5,-17(s0)
    uart_input_buf.r = (uart_input_buf.r + 1) % INPUT_BUF_SIZE;
    80200a50:	0003c797          	auipc	a5,0x3c
    80200a54:	69078793          	addi	a5,a5,1680 # 8023d0e0 <uart_input_buf>
    80200a58:	0807a783          	lw	a5,128(a5)
    80200a5c:	2785                	addiw	a5,a5,1
    80200a5e:	2781                	sext.w	a5,a5
    80200a60:	07f7f793          	andi	a5,a5,127
    80200a64:	0007871b          	sext.w	a4,a5
    80200a68:	0003c797          	auipc	a5,0x3c
    80200a6c:	67878793          	addi	a5,a5,1656 # 8023d0e0 <uart_input_buf>
    80200a70:	08e7a023          	sw	a4,128(a5)
    return c;
    80200a74:	fef44783          	lbu	a5,-17(s0)
}
    80200a78:	853e                	mv	a0,a5
    80200a7a:	6462                	ld	s0,24(sp)
    80200a7c:	6105                	addi	sp,sp,32
    80200a7e:	8082                	ret

0000000080200a80 <readline>:
// 读取一行输入，最多读取max-1个字符，并在末尾添加\0
int readline(char *buf, int max) {
    80200a80:	7179                	addi	sp,sp,-48
    80200a82:	f406                	sd	ra,40(sp)
    80200a84:	f022                	sd	s0,32(sp)
    80200a86:	1800                	addi	s0,sp,48
    80200a88:	fca43c23          	sd	a0,-40(s0)
    80200a8c:	87ae                	mv	a5,a1
    80200a8e:	fcf42a23          	sw	a5,-44(s0)
    int i = 0;
    80200a92:	fe042623          	sw	zero,-20(s0)
    char c;
    
    while (i < max - 1) {
    80200a96:	a0b9                	j	80200ae4 <readline+0x64>
        c = uart_getc_blocking();
    80200a98:	00000097          	auipc	ra,0x0
    80200a9c:	f70080e7          	jalr	-144(ra) # 80200a08 <uart_getc_blocking>
    80200aa0:	87aa                	mv	a5,a0
    80200aa2:	fef405a3          	sb	a5,-21(s0)
        
        if (c == '\n') {
    80200aa6:	feb44783          	lbu	a5,-21(s0)
    80200aaa:	0ff7f713          	zext.b	a4,a5
    80200aae:	47a9                	li	a5,10
    80200ab0:	00f71c63          	bne	a4,a5,80200ac8 <readline+0x48>
            buf[i] = '\0';
    80200ab4:	fec42783          	lw	a5,-20(s0)
    80200ab8:	fd843703          	ld	a4,-40(s0)
    80200abc:	97ba                	add	a5,a5,a4
    80200abe:	00078023          	sb	zero,0(a5)
            return i;
    80200ac2:	fec42783          	lw	a5,-20(s0)
    80200ac6:	a0a9                	j	80200b10 <readline+0x90>
        } else {
            buf[i++] = c;
    80200ac8:	fec42783          	lw	a5,-20(s0)
    80200acc:	0017871b          	addiw	a4,a5,1
    80200ad0:	fee42623          	sw	a4,-20(s0)
    80200ad4:	873e                	mv	a4,a5
    80200ad6:	fd843783          	ld	a5,-40(s0)
    80200ada:	97ba                	add	a5,a5,a4
    80200adc:	feb44703          	lbu	a4,-21(s0)
    80200ae0:	00e78023          	sb	a4,0(a5)
    while (i < max - 1) {
    80200ae4:	fd442783          	lw	a5,-44(s0)
    80200ae8:	37fd                	addiw	a5,a5,-1
    80200aea:	0007871b          	sext.w	a4,a5
    80200aee:	fec42783          	lw	a5,-20(s0)
    80200af2:	2781                	sext.w	a5,a5
    80200af4:	fae7c2e3          	blt	a5,a4,80200a98 <readline+0x18>
        }
    }
    
    // 缓冲区满，添加\0并返回
    buf[max-1] = '\0';
    80200af8:	fd442783          	lw	a5,-44(s0)
    80200afc:	17fd                	addi	a5,a5,-1
    80200afe:	fd843703          	ld	a4,-40(s0)
    80200b02:	97ba                	add	a5,a5,a4
    80200b04:	00078023          	sb	zero,0(a5)
    return max-1;
    80200b08:	fd442783          	lw	a5,-44(s0)
    80200b0c:	37fd                	addiw	a5,a5,-1
    80200b0e:	2781                	sext.w	a5,a5
    80200b10:	853e                	mv	a0,a5
    80200b12:	70a2                	ld	ra,40(sp)
    80200b14:	7402                	ld	s0,32(sp)
    80200b16:	6145                	addi	sp,sp,48
    80200b18:	8082                	ret

0000000080200b1a <flush_printf_buffer>:

extern void uart_putc(char c);

static char printf_buffer[PRINTF_BUFFER_SIZE];
static int printf_buf_pos = 0;
static void flush_printf_buffer(void) {
    80200b1a:	1141                	addi	sp,sp,-16
    80200b1c:	e406                	sd	ra,8(sp)
    80200b1e:	e022                	sd	s0,0(sp)
    80200b20:	0800                	addi	s0,sp,16
	if (printf_buf_pos > 0) {
    80200b22:	0003c797          	auipc	a5,0x3c
    80200b26:	75678793          	addi	a5,a5,1878 # 8023d278 <printf_buf_pos>
    80200b2a:	439c                	lw	a5,0(a5)
    80200b2c:	02f05c63          	blez	a5,80200b64 <flush_printf_buffer+0x4a>
		printf_buffer[printf_buf_pos] = '\0'; // Null-terminate the string
    80200b30:	0003c797          	auipc	a5,0x3c
    80200b34:	74878793          	addi	a5,a5,1864 # 8023d278 <printf_buf_pos>
    80200b38:	439c                	lw	a5,0(a5)
    80200b3a:	0003c717          	auipc	a4,0x3c
    80200b3e:	6be70713          	addi	a4,a4,1726 # 8023d1f8 <printf_buffer>
    80200b42:	97ba                	add	a5,a5,a4
    80200b44:	00078023          	sb	zero,0(a5)
		uart_puts(printf_buffer); // Send the buffer to UART
    80200b48:	0003c517          	auipc	a0,0x3c
    80200b4c:	6b050513          	addi	a0,a0,1712 # 8023d1f8 <printf_buffer>
    80200b50:	00000097          	auipc	ra,0x0
    80200b54:	ba8080e7          	jalr	-1112(ra) # 802006f8 <uart_puts>
		printf_buf_pos = 0; // Reset buffer position
    80200b58:	0003c797          	auipc	a5,0x3c
    80200b5c:	72078793          	addi	a5,a5,1824 # 8023d278 <printf_buf_pos>
    80200b60:	0007a023          	sw	zero,0(a5)
	}
}
    80200b64:	0001                	nop
    80200b66:	60a2                	ld	ra,8(sp)
    80200b68:	6402                	ld	s0,0(sp)
    80200b6a:	0141                	addi	sp,sp,16
    80200b6c:	8082                	ret

0000000080200b6e <buffer_char>:
static void buffer_char(char c) {
    80200b6e:	1101                	addi	sp,sp,-32
    80200b70:	ec06                	sd	ra,24(sp)
    80200b72:	e822                	sd	s0,16(sp)
    80200b74:	1000                	addi	s0,sp,32
    80200b76:	87aa                	mv	a5,a0
    80200b78:	fef407a3          	sb	a5,-17(s0)
	if (printf_buf_pos < PRINTF_BUFFER_SIZE - 1) { // Leave space for null terminator
    80200b7c:	0003c797          	auipc	a5,0x3c
    80200b80:	6fc78793          	addi	a5,a5,1788 # 8023d278 <printf_buf_pos>
    80200b84:	439c                	lw	a5,0(a5)
    80200b86:	873e                	mv	a4,a5
    80200b88:	07e00793          	li	a5,126
    80200b8c:	02e7ca63          	blt	a5,a4,80200bc0 <buffer_char+0x52>
		printf_buffer[printf_buf_pos++] = c;
    80200b90:	0003c797          	auipc	a5,0x3c
    80200b94:	6e878793          	addi	a5,a5,1768 # 8023d278 <printf_buf_pos>
    80200b98:	439c                	lw	a5,0(a5)
    80200b9a:	0017871b          	addiw	a4,a5,1
    80200b9e:	0007069b          	sext.w	a3,a4
    80200ba2:	0003c717          	auipc	a4,0x3c
    80200ba6:	6d670713          	addi	a4,a4,1750 # 8023d278 <printf_buf_pos>
    80200baa:	c314                	sw	a3,0(a4)
    80200bac:	0003c717          	auipc	a4,0x3c
    80200bb0:	64c70713          	addi	a4,a4,1612 # 8023d1f8 <printf_buffer>
    80200bb4:	97ba                	add	a5,a5,a4
    80200bb6:	fef44703          	lbu	a4,-17(s0)
    80200bba:	00e78023          	sb	a4,0(a5)
	} else {
		flush_printf_buffer(); // Buffer full, flush it
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
	}
}
    80200bbe:	a825                	j	80200bf6 <buffer_char+0x88>
		flush_printf_buffer(); // Buffer full, flush it
    80200bc0:	00000097          	auipc	ra,0x0
    80200bc4:	f5a080e7          	jalr	-166(ra) # 80200b1a <flush_printf_buffer>
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
    80200bc8:	0003c797          	auipc	a5,0x3c
    80200bcc:	6b078793          	addi	a5,a5,1712 # 8023d278 <printf_buf_pos>
    80200bd0:	439c                	lw	a5,0(a5)
    80200bd2:	0017871b          	addiw	a4,a5,1
    80200bd6:	0007069b          	sext.w	a3,a4
    80200bda:	0003c717          	auipc	a4,0x3c
    80200bde:	69e70713          	addi	a4,a4,1694 # 8023d278 <printf_buf_pos>
    80200be2:	c314                	sw	a3,0(a4)
    80200be4:	0003c717          	auipc	a4,0x3c
    80200be8:	61470713          	addi	a4,a4,1556 # 8023d1f8 <printf_buffer>
    80200bec:	97ba                	add	a5,a5,a4
    80200bee:	fef44703          	lbu	a4,-17(s0)
    80200bf2:	00e78023          	sb	a4,0(a5)
}
    80200bf6:	0001                	nop
    80200bf8:	60e2                	ld	ra,24(sp)
    80200bfa:	6442                	ld	s0,16(sp)
    80200bfc:	6105                	addi	sp,sp,32
    80200bfe:	8082                	ret

0000000080200c00 <consputc>:

static void consputc(int c){
    80200c00:	1101                	addi	sp,sp,-32
    80200c02:	ec06                	sd	ra,24(sp)
    80200c04:	e822                	sd	s0,16(sp)
    80200c06:	1000                	addi	s0,sp,32
    80200c08:	87aa                	mv	a5,a0
    80200c0a:	fef42623          	sw	a5,-20(s0)
	// 实现到多个输出的处理，目前只有串口输出
	uart_putc(c);
    80200c0e:	fec42783          	lw	a5,-20(s0)
    80200c12:	0ff7f793          	zext.b	a5,a5
    80200c16:	853e                	mv	a0,a5
    80200c18:	00000097          	auipc	ra,0x0
    80200c1c:	aa6080e7          	jalr	-1370(ra) # 802006be <uart_putc>
}
    80200c20:	0001                	nop
    80200c22:	60e2                	ld	ra,24(sp)
    80200c24:	6442                	ld	s0,16(sp)
    80200c26:	6105                	addi	sp,sp,32
    80200c28:	8082                	ret

0000000080200c2a <consputs>:
static void consputs(const char *s){
    80200c2a:	7179                	addi	sp,sp,-48
    80200c2c:	f406                	sd	ra,40(sp)
    80200c2e:	f022                	sd	s0,32(sp)
    80200c30:	1800                	addi	s0,sp,48
    80200c32:	fca43c23          	sd	a0,-40(s0)
	char *str = (char *)s;
    80200c36:	fd843783          	ld	a5,-40(s0)
    80200c3a:	fef43423          	sd	a5,-24(s0)
	// 直接调用uart_puts输出字符串
	uart_puts(str);
    80200c3e:	fe843503          	ld	a0,-24(s0)
    80200c42:	00000097          	auipc	ra,0x0
    80200c46:	ab6080e7          	jalr	-1354(ra) # 802006f8 <uart_puts>
}
    80200c4a:	0001                	nop
    80200c4c:	70a2                	ld	ra,40(sp)
    80200c4e:	7402                	ld	s0,32(sp)
    80200c50:	6145                	addi	sp,sp,48
    80200c52:	8082                	ret

0000000080200c54 <printint>:
static void printint(long long xx, int base, int sign, int width, int padzero){
    80200c54:	7159                	addi	sp,sp,-112
    80200c56:	f486                	sd	ra,104(sp)
    80200c58:	f0a2                	sd	s0,96(sp)
    80200c5a:	1880                	addi	s0,sp,112
    80200c5c:	faa43423          	sd	a0,-88(s0)
    80200c60:	87ae                	mv	a5,a1
    80200c62:	faf42223          	sw	a5,-92(s0)
    80200c66:	87b2                	mv	a5,a2
    80200c68:	faf42023          	sw	a5,-96(s0)
    80200c6c:	87b6                	mv	a5,a3
    80200c6e:	f8f42e23          	sw	a5,-100(s0)
    80200c72:	87ba                	mv	a5,a4
    80200c74:	f8f42c23          	sw	a5,-104(s0)
    static char digits[] = "0123456789abcdef";
    char buf[32];
    int i = 0;
    80200c78:	fe042623          	sw	zero,-20(s0)
    unsigned long long x;

    if (sign && (sign = xx < 0))
    80200c7c:	fa042783          	lw	a5,-96(s0)
    80200c80:	2781                	sext.w	a5,a5
    80200c82:	c39d                	beqz	a5,80200ca8 <printint+0x54>
    80200c84:	fa843783          	ld	a5,-88(s0)
    80200c88:	93fd                	srli	a5,a5,0x3f
    80200c8a:	0ff7f793          	zext.b	a5,a5
    80200c8e:	faf42023          	sw	a5,-96(s0)
    80200c92:	fa042783          	lw	a5,-96(s0)
    80200c96:	2781                	sext.w	a5,a5
    80200c98:	cb81                	beqz	a5,80200ca8 <printint+0x54>
        x = -(unsigned long long)xx;
    80200c9a:	fa843783          	ld	a5,-88(s0)
    80200c9e:	40f007b3          	neg	a5,a5
    80200ca2:	fef43023          	sd	a5,-32(s0)
    80200ca6:	a029                	j	80200cb0 <printint+0x5c>
    else
        x = xx;
    80200ca8:	fa843783          	ld	a5,-88(s0)
    80200cac:	fef43023          	sd	a5,-32(s0)

    do {
        buf[i++] = digits[x % base];
    80200cb0:	fa442783          	lw	a5,-92(s0)
    80200cb4:	fe043703          	ld	a4,-32(s0)
    80200cb8:	02f77733          	remu	a4,a4,a5
    80200cbc:	fec42783          	lw	a5,-20(s0)
    80200cc0:	0017869b          	addiw	a3,a5,1
    80200cc4:	fed42623          	sw	a3,-20(s0)
    80200cc8:	0003c697          	auipc	a3,0x3c
    80200ccc:	3c868693          	addi	a3,a3,968 # 8023d090 <digits.0>
    80200cd0:	9736                	add	a4,a4,a3
    80200cd2:	00074703          	lbu	a4,0(a4)
    80200cd6:	17c1                	addi	a5,a5,-16
    80200cd8:	97a2                	add	a5,a5,s0
    80200cda:	fce78423          	sb	a4,-56(a5)
    } while ((x /= base) != 0);
    80200cde:	fa442783          	lw	a5,-92(s0)
    80200ce2:	fe043703          	ld	a4,-32(s0)
    80200ce6:	02f757b3          	divu	a5,a4,a5
    80200cea:	fef43023          	sd	a5,-32(s0)
    80200cee:	fe043783          	ld	a5,-32(s0)
    80200cf2:	ffdd                	bnez	a5,80200cb0 <printint+0x5c>

    if (sign)
    80200cf4:	fa042783          	lw	a5,-96(s0)
    80200cf8:	2781                	sext.w	a5,a5
    80200cfa:	cf89                	beqz	a5,80200d14 <printint+0xc0>
        buf[i++] = '-';
    80200cfc:	fec42783          	lw	a5,-20(s0)
    80200d00:	0017871b          	addiw	a4,a5,1
    80200d04:	fee42623          	sw	a4,-20(s0)
    80200d08:	17c1                	addi	a5,a5,-16
    80200d0a:	97a2                	add	a5,a5,s0
    80200d0c:	02d00713          	li	a4,45
    80200d10:	fce78423          	sb	a4,-56(a5)

    // 计算需要补的填充字符数
    int pad = width - i;
    80200d14:	f9c42783          	lw	a5,-100(s0)
    80200d18:	873e                	mv	a4,a5
    80200d1a:	fec42783          	lw	a5,-20(s0)
    80200d1e:	40f707bb          	subw	a5,a4,a5
    80200d22:	fcf42e23          	sw	a5,-36(s0)
    while (pad-- > 0) {
    80200d26:	a839                	j	80200d44 <printint+0xf0>
        consputc(padzero ? '0' : ' ');
    80200d28:	f9842783          	lw	a5,-104(s0)
    80200d2c:	2781                	sext.w	a5,a5
    80200d2e:	c781                	beqz	a5,80200d36 <printint+0xe2>
    80200d30:	03000793          	li	a5,48
    80200d34:	a019                	j	80200d3a <printint+0xe6>
    80200d36:	02000793          	li	a5,32
    80200d3a:	853e                	mv	a0,a5
    80200d3c:	00000097          	auipc	ra,0x0
    80200d40:	ec4080e7          	jalr	-316(ra) # 80200c00 <consputc>
    while (pad-- > 0) {
    80200d44:	fdc42783          	lw	a5,-36(s0)
    80200d48:	fff7871b          	addiw	a4,a5,-1
    80200d4c:	fce42e23          	sw	a4,-36(s0)
    80200d50:	fcf04ce3          	bgtz	a5,80200d28 <printint+0xd4>
    }

    while (--i >= 0)
    80200d54:	a829                	j	80200d6e <printint+0x11a>
        consputc(buf[i]);
    80200d56:	fec42783          	lw	a5,-20(s0)
    80200d5a:	17c1                	addi	a5,a5,-16
    80200d5c:	97a2                	add	a5,a5,s0
    80200d5e:	fc87c783          	lbu	a5,-56(a5)
    80200d62:	2781                	sext.w	a5,a5
    80200d64:	853e                	mv	a0,a5
    80200d66:	00000097          	auipc	ra,0x0
    80200d6a:	e9a080e7          	jalr	-358(ra) # 80200c00 <consputc>
    while (--i >= 0)
    80200d6e:	fec42783          	lw	a5,-20(s0)
    80200d72:	37fd                	addiw	a5,a5,-1
    80200d74:	fef42623          	sw	a5,-20(s0)
    80200d78:	fec42783          	lw	a5,-20(s0)
    80200d7c:	2781                	sext.w	a5,a5
    80200d7e:	fc07dce3          	bgez	a5,80200d56 <printint+0x102>
}
    80200d82:	0001                	nop
    80200d84:	0001                	nop
    80200d86:	70a6                	ld	ra,104(sp)
    80200d88:	7406                	ld	s0,96(sp)
    80200d8a:	6165                	addi	sp,sp,112
    80200d8c:	8082                	ret

0000000080200d8e <vprintf>:
void vprintf(const char *fmt, va_list ap) {
    80200d8e:	711d                	addi	sp,sp,-96
    80200d90:	ec86                	sd	ra,88(sp)
    80200d92:	e8a2                	sd	s0,80(sp)
    80200d94:	1080                	addi	s0,sp,96
    80200d96:	faa43423          	sd	a0,-88(s0)
    80200d9a:	fab43023          	sd	a1,-96(s0)
    int i, c;
    char *s;

    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80200d9e:	fe042623          	sw	zero,-20(s0)
    80200da2:	a945                	j	80201252 <vprintf+0x4c4>
        if(c != '%'){
    80200da4:	fe842783          	lw	a5,-24(s0)
    80200da8:	0007871b          	sext.w	a4,a5
    80200dac:	02500793          	li	a5,37
    80200db0:	00f70c63          	beq	a4,a5,80200dc8 <vprintf+0x3a>
            buffer_char(c);
    80200db4:	fe842783          	lw	a5,-24(s0)
    80200db8:	0ff7f793          	zext.b	a5,a5
    80200dbc:	853e                	mv	a0,a5
    80200dbe:	00000097          	auipc	ra,0x0
    80200dc2:	db0080e7          	jalr	-592(ra) # 80200b6e <buffer_char>
            continue;
    80200dc6:	a149                	j	80201248 <vprintf+0x4ba>
        }
        flush_printf_buffer();
    80200dc8:	00000097          	auipc	ra,0x0
    80200dcc:	d52080e7          	jalr	-686(ra) # 80200b1a <flush_printf_buffer>
        int padzero = 0, width = 0;
    80200dd0:	fc042e23          	sw	zero,-36(s0)
    80200dd4:	fc042c23          	sw	zero,-40(s0)
        c = fmt[++i] & 0xff;
    80200dd8:	fec42783          	lw	a5,-20(s0)
    80200ddc:	2785                	addiw	a5,a5,1
    80200dde:	fef42623          	sw	a5,-20(s0)
    80200de2:	fec42783          	lw	a5,-20(s0)
    80200de6:	fa843703          	ld	a4,-88(s0)
    80200dea:	97ba                	add	a5,a5,a4
    80200dec:	0007c783          	lbu	a5,0(a5)
    80200df0:	fef42423          	sw	a5,-24(s0)
        if (c == '0') {
    80200df4:	fe842783          	lw	a5,-24(s0)
    80200df8:	0007871b          	sext.w	a4,a5
    80200dfc:	03000793          	li	a5,48
    80200e00:	06f71563          	bne	a4,a5,80200e6a <vprintf+0xdc>
            padzero = 1;
    80200e04:	4785                	li	a5,1
    80200e06:	fcf42e23          	sw	a5,-36(s0)
            c = fmt[++i] & 0xff;
    80200e0a:	fec42783          	lw	a5,-20(s0)
    80200e0e:	2785                	addiw	a5,a5,1
    80200e10:	fef42623          	sw	a5,-20(s0)
    80200e14:	fec42783          	lw	a5,-20(s0)
    80200e18:	fa843703          	ld	a4,-88(s0)
    80200e1c:	97ba                	add	a5,a5,a4
    80200e1e:	0007c783          	lbu	a5,0(a5)
    80200e22:	fef42423          	sw	a5,-24(s0)
        }
        while (c >= '0' && c <= '9') {
    80200e26:	a091                	j	80200e6a <vprintf+0xdc>
            width = width * 10 + (c - '0');
    80200e28:	fd842783          	lw	a5,-40(s0)
    80200e2c:	873e                	mv	a4,a5
    80200e2e:	87ba                	mv	a5,a4
    80200e30:	0027979b          	slliw	a5,a5,0x2
    80200e34:	9fb9                	addw	a5,a5,a4
    80200e36:	0017979b          	slliw	a5,a5,0x1
    80200e3a:	0007871b          	sext.w	a4,a5
    80200e3e:	fe842783          	lw	a5,-24(s0)
    80200e42:	fd07879b          	addiw	a5,a5,-48
    80200e46:	2781                	sext.w	a5,a5
    80200e48:	9fb9                	addw	a5,a5,a4
    80200e4a:	fcf42c23          	sw	a5,-40(s0)
            c = fmt[++i] & 0xff;
    80200e4e:	fec42783          	lw	a5,-20(s0)
    80200e52:	2785                	addiw	a5,a5,1
    80200e54:	fef42623          	sw	a5,-20(s0)
    80200e58:	fec42783          	lw	a5,-20(s0)
    80200e5c:	fa843703          	ld	a4,-88(s0)
    80200e60:	97ba                	add	a5,a5,a4
    80200e62:	0007c783          	lbu	a5,0(a5)
    80200e66:	fef42423          	sw	a5,-24(s0)
        while (c >= '0' && c <= '9') {
    80200e6a:	fe842783          	lw	a5,-24(s0)
    80200e6e:	0007871b          	sext.w	a4,a5
    80200e72:	02f00793          	li	a5,47
    80200e76:	00e7da63          	bge	a5,a4,80200e8a <vprintf+0xfc>
    80200e7a:	fe842783          	lw	a5,-24(s0)
    80200e7e:	0007871b          	sext.w	a4,a5
    80200e82:	03900793          	li	a5,57
    80200e86:	fae7d1e3          	bge	a5,a4,80200e28 <vprintf+0x9a>
        }
        int is_long = 0;
    80200e8a:	fc042a23          	sw	zero,-44(s0)
        if(c == 'l') {
    80200e8e:	fe842783          	lw	a5,-24(s0)
    80200e92:	0007871b          	sext.w	a4,a5
    80200e96:	06c00793          	li	a5,108
    80200e9a:	02f71863          	bne	a4,a5,80200eca <vprintf+0x13c>
            is_long = 1;
    80200e9e:	4785                	li	a5,1
    80200ea0:	fcf42a23          	sw	a5,-44(s0)
            c = fmt[++i] & 0xff;
    80200ea4:	fec42783          	lw	a5,-20(s0)
    80200ea8:	2785                	addiw	a5,a5,1
    80200eaa:	fef42623          	sw	a5,-20(s0)
    80200eae:	fec42783          	lw	a5,-20(s0)
    80200eb2:	fa843703          	ld	a4,-88(s0)
    80200eb6:	97ba                	add	a5,a5,a4
    80200eb8:	0007c783          	lbu	a5,0(a5)
    80200ebc:	fef42423          	sw	a5,-24(s0)
            if(c == 0)
    80200ec0:	fe842783          	lw	a5,-24(s0)
    80200ec4:	2781                	sext.w	a5,a5
    80200ec6:	3a078563          	beqz	a5,80201270 <vprintf+0x4e2>
                break;
        }
        switch(c){
    80200eca:	fe842783          	lw	a5,-24(s0)
    80200ece:	0007871b          	sext.w	a4,a5
    80200ed2:	02500793          	li	a5,37
    80200ed6:	2ef70d63          	beq	a4,a5,802011d0 <vprintf+0x442>
    80200eda:	fe842783          	lw	a5,-24(s0)
    80200ede:	0007871b          	sext.w	a4,a5
    80200ee2:	02500793          	li	a5,37
    80200ee6:	2ef74c63          	blt	a4,a5,802011de <vprintf+0x450>
    80200eea:	fe842783          	lw	a5,-24(s0)
    80200eee:	0007871b          	sext.w	a4,a5
    80200ef2:	07800793          	li	a5,120
    80200ef6:	2ee7c463          	blt	a5,a4,802011de <vprintf+0x450>
    80200efa:	fe842783          	lw	a5,-24(s0)
    80200efe:	0007871b          	sext.w	a4,a5
    80200f02:	06200793          	li	a5,98
    80200f06:	2cf74c63          	blt	a4,a5,802011de <vprintf+0x450>
    80200f0a:	fe842783          	lw	a5,-24(s0)
    80200f0e:	f9e7869b          	addiw	a3,a5,-98
    80200f12:	0006871b          	sext.w	a4,a3
    80200f16:	47d9                	li	a5,22
    80200f18:	2ce7e363          	bltu	a5,a4,802011de <vprintf+0x450>
    80200f1c:	02069793          	slli	a5,a3,0x20
    80200f20:	9381                	srli	a5,a5,0x20
    80200f22:	00279713          	slli	a4,a5,0x2
    80200f26:	00013797          	auipc	a5,0x13
    80200f2a:	9f678793          	addi	a5,a5,-1546 # 8021391c <user_test_table+0x9c>
    80200f2e:	97ba                	add	a5,a5,a4
    80200f30:	439c                	lw	a5,0(a5)
    80200f32:	0007871b          	sext.w	a4,a5
    80200f36:	00013797          	auipc	a5,0x13
    80200f3a:	9e678793          	addi	a5,a5,-1562 # 8021391c <user_test_table+0x9c>
    80200f3e:	97ba                	add	a5,a5,a4
    80200f40:	8782                	jr	a5
        case 'd':
            if(is_long)
    80200f42:	fd442783          	lw	a5,-44(s0)
    80200f46:	2781                	sext.w	a5,a5
    80200f48:	c785                	beqz	a5,80200f70 <vprintf+0x1e2>
                printint(va_arg(ap, long long), 10, 1, width, padzero);
    80200f4a:	fa043783          	ld	a5,-96(s0)
    80200f4e:	00878713          	addi	a4,a5,8
    80200f52:	fae43023          	sd	a4,-96(s0)
    80200f56:	639c                	ld	a5,0(a5)
    80200f58:	fdc42703          	lw	a4,-36(s0)
    80200f5c:	fd842683          	lw	a3,-40(s0)
    80200f60:	4605                	li	a2,1
    80200f62:	45a9                	li	a1,10
    80200f64:	853e                	mv	a0,a5
    80200f66:	00000097          	auipc	ra,0x0
    80200f6a:	cee080e7          	jalr	-786(ra) # 80200c54 <printint>
            else
                printint(va_arg(ap, int), 10, 1, width, padzero);
            break;
    80200f6e:	ace9                	j	80201248 <vprintf+0x4ba>
                printint(va_arg(ap, int), 10, 1, width, padzero);
    80200f70:	fa043783          	ld	a5,-96(s0)
    80200f74:	00878713          	addi	a4,a5,8
    80200f78:	fae43023          	sd	a4,-96(s0)
    80200f7c:	439c                	lw	a5,0(a5)
    80200f7e:	853e                	mv	a0,a5
    80200f80:	fdc42703          	lw	a4,-36(s0)
    80200f84:	fd842783          	lw	a5,-40(s0)
    80200f88:	86be                	mv	a3,a5
    80200f8a:	4605                	li	a2,1
    80200f8c:	45a9                	li	a1,10
    80200f8e:	00000097          	auipc	ra,0x0
    80200f92:	cc6080e7          	jalr	-826(ra) # 80200c54 <printint>
            break;
    80200f96:	ac4d                	j	80201248 <vprintf+0x4ba>
        case 'x':
            if(is_long)
    80200f98:	fd442783          	lw	a5,-44(s0)
    80200f9c:	2781                	sext.w	a5,a5
    80200f9e:	c785                	beqz	a5,80200fc6 <vprintf+0x238>
                printint(va_arg(ap, long long), 16, 0, width, padzero);
    80200fa0:	fa043783          	ld	a5,-96(s0)
    80200fa4:	00878713          	addi	a4,a5,8
    80200fa8:	fae43023          	sd	a4,-96(s0)
    80200fac:	639c                	ld	a5,0(a5)
    80200fae:	fdc42703          	lw	a4,-36(s0)
    80200fb2:	fd842683          	lw	a3,-40(s0)
    80200fb6:	4601                	li	a2,0
    80200fb8:	45c1                	li	a1,16
    80200fba:	853e                	mv	a0,a5
    80200fbc:	00000097          	auipc	ra,0x0
    80200fc0:	c98080e7          	jalr	-872(ra) # 80200c54 <printint>
            else
                printint(va_arg(ap, int), 16, 0, width, padzero);
            break;
    80200fc4:	a451                	j	80201248 <vprintf+0x4ba>
                printint(va_arg(ap, int), 16, 0, width, padzero);
    80200fc6:	fa043783          	ld	a5,-96(s0)
    80200fca:	00878713          	addi	a4,a5,8
    80200fce:	fae43023          	sd	a4,-96(s0)
    80200fd2:	439c                	lw	a5,0(a5)
    80200fd4:	853e                	mv	a0,a5
    80200fd6:	fdc42703          	lw	a4,-36(s0)
    80200fda:	fd842783          	lw	a5,-40(s0)
    80200fde:	86be                	mv	a3,a5
    80200fe0:	4601                	li	a2,0
    80200fe2:	45c1                	li	a1,16
    80200fe4:	00000097          	auipc	ra,0x0
    80200fe8:	c70080e7          	jalr	-912(ra) # 80200c54 <printint>
            break;
    80200fec:	acb1                	j	80201248 <vprintf+0x4ba>
        case 'u':
            if(is_long)
    80200fee:	fd442783          	lw	a5,-44(s0)
    80200ff2:	2781                	sext.w	a5,a5
    80200ff4:	c78d                	beqz	a5,8020101e <vprintf+0x290>
                printint(va_arg(ap, unsigned long long), 10, 0, width, padzero);
    80200ff6:	fa043783          	ld	a5,-96(s0)
    80200ffa:	00878713          	addi	a4,a5,8
    80200ffe:	fae43023          	sd	a4,-96(s0)
    80201002:	639c                	ld	a5,0(a5)
    80201004:	853e                	mv	a0,a5
    80201006:	fdc42703          	lw	a4,-36(s0)
    8020100a:	fd842783          	lw	a5,-40(s0)
    8020100e:	86be                	mv	a3,a5
    80201010:	4601                	li	a2,0
    80201012:	45a9                	li	a1,10
    80201014:	00000097          	auipc	ra,0x0
    80201018:	c40080e7          	jalr	-960(ra) # 80200c54 <printint>
            else
                printint(va_arg(ap, unsigned int), 10, 0, width, padzero);
            break;
    8020101c:	a435                	j	80201248 <vprintf+0x4ba>
                printint(va_arg(ap, unsigned int), 10, 0, width, padzero);
    8020101e:	fa043783          	ld	a5,-96(s0)
    80201022:	00878713          	addi	a4,a5,8
    80201026:	fae43023          	sd	a4,-96(s0)
    8020102a:	439c                	lw	a5,0(a5)
    8020102c:	1782                	slli	a5,a5,0x20
    8020102e:	9381                	srli	a5,a5,0x20
    80201030:	fdc42703          	lw	a4,-36(s0)
    80201034:	fd842683          	lw	a3,-40(s0)
    80201038:	4601                	li	a2,0
    8020103a:	45a9                	li	a1,10
    8020103c:	853e                	mv	a0,a5
    8020103e:	00000097          	auipc	ra,0x0
    80201042:	c16080e7          	jalr	-1002(ra) # 80200c54 <printint>
            break;
    80201046:	a409                	j	80201248 <vprintf+0x4ba>
        case 'c':
            consputc(va_arg(ap, int));
    80201048:	fa043783          	ld	a5,-96(s0)
    8020104c:	00878713          	addi	a4,a5,8
    80201050:	fae43023          	sd	a4,-96(s0)
    80201054:	439c                	lw	a5,0(a5)
    80201056:	853e                	mv	a0,a5
    80201058:	00000097          	auipc	ra,0x0
    8020105c:	ba8080e7          	jalr	-1112(ra) # 80200c00 <consputc>
            break;
    80201060:	a2e5                	j	80201248 <vprintf+0x4ba>
        case 's':
            if((s = va_arg(ap, char*)) == 0)
    80201062:	fa043783          	ld	a5,-96(s0)
    80201066:	00878713          	addi	a4,a5,8
    8020106a:	fae43023          	sd	a4,-96(s0)
    8020106e:	639c                	ld	a5,0(a5)
    80201070:	fef43023          	sd	a5,-32(s0)
    80201074:	fe043783          	ld	a5,-32(s0)
    80201078:	e799                	bnez	a5,80201086 <vprintf+0x2f8>
                s = "(null)";
    8020107a:	00013797          	auipc	a5,0x13
    8020107e:	87e78793          	addi	a5,a5,-1922 # 802138f8 <user_test_table+0x78>
    80201082:	fef43023          	sd	a5,-32(s0)
            consputs(s);
    80201086:	fe043503          	ld	a0,-32(s0)
    8020108a:	00000097          	auipc	ra,0x0
    8020108e:	ba0080e7          	jalr	-1120(ra) # 80200c2a <consputs>
            break;
    80201092:	aa5d                	j	80201248 <vprintf+0x4ba>
        case 'p': {
            unsigned long ptr = (unsigned long)va_arg(ap, void*);
    80201094:	fa043783          	ld	a5,-96(s0)
    80201098:	00878713          	addi	a4,a5,8
    8020109c:	fae43023          	sd	a4,-96(s0)
    802010a0:	639c                	ld	a5,0(a5)
    802010a2:	fcf43423          	sd	a5,-56(s0)
            consputs("0x");
    802010a6:	00013517          	auipc	a0,0x13
    802010aa:	85a50513          	addi	a0,a0,-1958 # 80213900 <user_test_table+0x80>
    802010ae:	00000097          	auipc	ra,0x0
    802010b2:	b7c080e7          	jalr	-1156(ra) # 80200c2a <consputs>
            char buf[17];
            int i;
            for (i = 0; i < 16; i++) {
    802010b6:	fc042823          	sw	zero,-48(s0)
    802010ba:	a0a1                	j	80201102 <vprintf+0x374>
                int shift = (15 - i) * 4;
    802010bc:	47bd                	li	a5,15
    802010be:	fd042703          	lw	a4,-48(s0)
    802010c2:	9f99                	subw	a5,a5,a4
    802010c4:	2781                	sext.w	a5,a5
    802010c6:	0027979b          	slliw	a5,a5,0x2
    802010ca:	fcf42223          	sw	a5,-60(s0)
                buf[i] = "0123456789abcdef"[(ptr >> shift) & 0xf];
    802010ce:	fc442783          	lw	a5,-60(s0)
    802010d2:	873e                	mv	a4,a5
    802010d4:	fc843783          	ld	a5,-56(s0)
    802010d8:	00e7d7b3          	srl	a5,a5,a4
    802010dc:	8bbd                	andi	a5,a5,15
    802010de:	00013717          	auipc	a4,0x13
    802010e2:	82a70713          	addi	a4,a4,-2006 # 80213908 <user_test_table+0x88>
    802010e6:	97ba                	add	a5,a5,a4
    802010e8:	0007c703          	lbu	a4,0(a5)
    802010ec:	fd042783          	lw	a5,-48(s0)
    802010f0:	17c1                	addi	a5,a5,-16
    802010f2:	97a2                	add	a5,a5,s0
    802010f4:	fce78023          	sb	a4,-64(a5)
            for (i = 0; i < 16; i++) {
    802010f8:	fd042783          	lw	a5,-48(s0)
    802010fc:	2785                	addiw	a5,a5,1
    802010fe:	fcf42823          	sw	a5,-48(s0)
    80201102:	fd042783          	lw	a5,-48(s0)
    80201106:	0007871b          	sext.w	a4,a5
    8020110a:	47bd                	li	a5,15
    8020110c:	fae7d8e3          	bge	a5,a4,802010bc <vprintf+0x32e>
            }
            buf[16] = '\0';
    80201110:	fc040023          	sb	zero,-64(s0)
            consputs(buf);
    80201114:	fb040793          	addi	a5,s0,-80
    80201118:	853e                	mv	a0,a5
    8020111a:	00000097          	auipc	ra,0x0
    8020111e:	b10080e7          	jalr	-1264(ra) # 80200c2a <consputs>
            break;
    80201122:	a21d                	j	80201248 <vprintf+0x4ba>
        }
        case 'b':
            if(is_long)
    80201124:	fd442783          	lw	a5,-44(s0)
    80201128:	2781                	sext.w	a5,a5
    8020112a:	c785                	beqz	a5,80201152 <vprintf+0x3c4>
                printint(va_arg(ap, long long), 2, 0, width, padzero);
    8020112c:	fa043783          	ld	a5,-96(s0)
    80201130:	00878713          	addi	a4,a5,8
    80201134:	fae43023          	sd	a4,-96(s0)
    80201138:	639c                	ld	a5,0(a5)
    8020113a:	fdc42703          	lw	a4,-36(s0)
    8020113e:	fd842683          	lw	a3,-40(s0)
    80201142:	4601                	li	a2,0
    80201144:	4589                	li	a1,2
    80201146:	853e                	mv	a0,a5
    80201148:	00000097          	auipc	ra,0x0
    8020114c:	b0c080e7          	jalr	-1268(ra) # 80200c54 <printint>
            else
                printint(va_arg(ap, int), 2, 0, width, padzero);
            break;
    80201150:	a8e5                	j	80201248 <vprintf+0x4ba>
                printint(va_arg(ap, int), 2, 0, width, padzero);
    80201152:	fa043783          	ld	a5,-96(s0)
    80201156:	00878713          	addi	a4,a5,8
    8020115a:	fae43023          	sd	a4,-96(s0)
    8020115e:	439c                	lw	a5,0(a5)
    80201160:	853e                	mv	a0,a5
    80201162:	fdc42703          	lw	a4,-36(s0)
    80201166:	fd842783          	lw	a5,-40(s0)
    8020116a:	86be                	mv	a3,a5
    8020116c:	4601                	li	a2,0
    8020116e:	4589                	li	a1,2
    80201170:	00000097          	auipc	ra,0x0
    80201174:	ae4080e7          	jalr	-1308(ra) # 80200c54 <printint>
            break;
    80201178:	a8c1                	j	80201248 <vprintf+0x4ba>
        case 'o':
            if(is_long)
    8020117a:	fd442783          	lw	a5,-44(s0)
    8020117e:	2781                	sext.w	a5,a5
    80201180:	c785                	beqz	a5,802011a8 <vprintf+0x41a>
                printint(va_arg(ap, long long), 8, 0, width, padzero);
    80201182:	fa043783          	ld	a5,-96(s0)
    80201186:	00878713          	addi	a4,a5,8
    8020118a:	fae43023          	sd	a4,-96(s0)
    8020118e:	639c                	ld	a5,0(a5)
    80201190:	fdc42703          	lw	a4,-36(s0)
    80201194:	fd842683          	lw	a3,-40(s0)
    80201198:	4601                	li	a2,0
    8020119a:	45a1                	li	a1,8
    8020119c:	853e                	mv	a0,a5
    8020119e:	00000097          	auipc	ra,0x0
    802011a2:	ab6080e7          	jalr	-1354(ra) # 80200c54 <printint>
            else
                printint(va_arg(ap, int), 8, 0, width, padzero);
            break;
    802011a6:	a04d                	j	80201248 <vprintf+0x4ba>
                printint(va_arg(ap, int), 8, 0, width, padzero);
    802011a8:	fa043783          	ld	a5,-96(s0)
    802011ac:	00878713          	addi	a4,a5,8
    802011b0:	fae43023          	sd	a4,-96(s0)
    802011b4:	439c                	lw	a5,0(a5)
    802011b6:	853e                	mv	a0,a5
    802011b8:	fdc42703          	lw	a4,-36(s0)
    802011bc:	fd842783          	lw	a5,-40(s0)
    802011c0:	86be                	mv	a3,a5
    802011c2:	4601                	li	a2,0
    802011c4:	45a1                	li	a1,8
    802011c6:	00000097          	auipc	ra,0x0
    802011ca:	a8e080e7          	jalr	-1394(ra) # 80200c54 <printint>
            break;
    802011ce:	a8ad                	j	80201248 <vprintf+0x4ba>
        case '%':
            buffer_char('%');
    802011d0:	02500513          	li	a0,37
    802011d4:	00000097          	auipc	ra,0x0
    802011d8:	99a080e7          	jalr	-1638(ra) # 80200b6e <buffer_char>
            break;
    802011dc:	a0b5                	j	80201248 <vprintf+0x4ba>
        default:
            buffer_char('%');
    802011de:	02500513          	li	a0,37
    802011e2:	00000097          	auipc	ra,0x0
    802011e6:	98c080e7          	jalr	-1652(ra) # 80200b6e <buffer_char>
            if(padzero) buffer_char('0');
    802011ea:	fdc42783          	lw	a5,-36(s0)
    802011ee:	2781                	sext.w	a5,a5
    802011f0:	c799                	beqz	a5,802011fe <vprintf+0x470>
    802011f2:	03000513          	li	a0,48
    802011f6:	00000097          	auipc	ra,0x0
    802011fa:	978080e7          	jalr	-1672(ra) # 80200b6e <buffer_char>
            if(width) buffer_char('0' + width);
    802011fe:	fd842783          	lw	a5,-40(s0)
    80201202:	2781                	sext.w	a5,a5
    80201204:	cf91                	beqz	a5,80201220 <vprintf+0x492>
    80201206:	fd842783          	lw	a5,-40(s0)
    8020120a:	0ff7f793          	zext.b	a5,a5
    8020120e:	0307879b          	addiw	a5,a5,48
    80201212:	0ff7f793          	zext.b	a5,a5
    80201216:	853e                	mv	a0,a5
    80201218:	00000097          	auipc	ra,0x0
    8020121c:	956080e7          	jalr	-1706(ra) # 80200b6e <buffer_char>
            if(is_long) buffer_char('l');
    80201220:	fd442783          	lw	a5,-44(s0)
    80201224:	2781                	sext.w	a5,a5
    80201226:	c799                	beqz	a5,80201234 <vprintf+0x4a6>
    80201228:	06c00513          	li	a0,108
    8020122c:	00000097          	auipc	ra,0x0
    80201230:	942080e7          	jalr	-1726(ra) # 80200b6e <buffer_char>
            buffer_char(c);
    80201234:	fe842783          	lw	a5,-24(s0)
    80201238:	0ff7f793          	zext.b	a5,a5
    8020123c:	853e                	mv	a0,a5
    8020123e:	00000097          	auipc	ra,0x0
    80201242:	930080e7          	jalr	-1744(ra) # 80200b6e <buffer_char>
            break;
    80201246:	0001                	nop
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80201248:	fec42783          	lw	a5,-20(s0)
    8020124c:	2785                	addiw	a5,a5,1
    8020124e:	fef42623          	sw	a5,-20(s0)
    80201252:	fec42783          	lw	a5,-20(s0)
    80201256:	fa843703          	ld	a4,-88(s0)
    8020125a:	97ba                	add	a5,a5,a4
    8020125c:	0007c783          	lbu	a5,0(a5)
    80201260:	fef42423          	sw	a5,-24(s0)
    80201264:	fe842783          	lw	a5,-24(s0)
    80201268:	2781                	sext.w	a5,a5
    8020126a:	b2079de3          	bnez	a5,80200da4 <vprintf+0x16>
    8020126e:	a011                	j	80201272 <vprintf+0x4e4>
                break;
    80201270:	0001                	nop
        }
    }
    flush_printf_buffer();
    80201272:	00000097          	auipc	ra,0x0
    80201276:	8a8080e7          	jalr	-1880(ra) # 80200b1a <flush_printf_buffer>
}
    8020127a:	0001                	nop
    8020127c:	60e6                	ld	ra,88(sp)
    8020127e:	6446                	ld	s0,80(sp)
    80201280:	6125                	addi	sp,sp,96
    80201282:	8082                	ret

0000000080201284 <printf>:
void printf(const char *fmt, ...) {
    80201284:	7159                	addi	sp,sp,-112
    80201286:	f406                	sd	ra,40(sp)
    80201288:	f022                	sd	s0,32(sp)
    8020128a:	1800                	addi	s0,sp,48
    8020128c:	fca43c23          	sd	a0,-40(s0)
    80201290:	e40c                	sd	a1,8(s0)
    80201292:	e810                	sd	a2,16(s0)
    80201294:	ec14                	sd	a3,24(s0)
    80201296:	f018                	sd	a4,32(s0)
    80201298:	f41c                	sd	a5,40(s0)
    8020129a:	03043823          	sd	a6,48(s0)
    8020129e:	03143c23          	sd	a7,56(s0)
    va_list ap;
    va_start(ap, fmt);
    802012a2:	04040793          	addi	a5,s0,64
    802012a6:	fcf43823          	sd	a5,-48(s0)
    802012aa:	fd043783          	ld	a5,-48(s0)
    802012ae:	fc878793          	addi	a5,a5,-56
    802012b2:	fef43423          	sd	a5,-24(s0)
    vprintf(fmt, ap);
    802012b6:	fe843783          	ld	a5,-24(s0)
    802012ba:	85be                	mv	a1,a5
    802012bc:	fd843503          	ld	a0,-40(s0)
    802012c0:	00000097          	auipc	ra,0x0
    802012c4:	ace080e7          	jalr	-1330(ra) # 80200d8e <vprintf>
    va_end(ap);
}
    802012c8:	0001                	nop
    802012ca:	70a2                	ld	ra,40(sp)
    802012cc:	7402                	ld	s0,32(sp)
    802012ce:	6165                	addi	sp,sp,112
    802012d0:	8082                	ret

00000000802012d2 <clear_screen>:
// 清屏功能
void clear_screen(void) {
    802012d2:	1141                	addi	sp,sp,-16
    802012d4:	e406                	sd	ra,8(sp)
    802012d6:	e022                	sd	s0,0(sp)
    802012d8:	0800                	addi	s0,sp,16
    uart_puts(CLEAR_SCREEN);
    802012da:	00012517          	auipc	a0,0x12
    802012de:	69e50513          	addi	a0,a0,1694 # 80213978 <user_test_table+0xf8>
    802012e2:	fffff097          	auipc	ra,0xfffff
    802012e6:	416080e7          	jalr	1046(ra) # 802006f8 <uart_puts>
	uart_puts(CURSOR_HOME);
    802012ea:	00012517          	auipc	a0,0x12
    802012ee:	69650513          	addi	a0,a0,1686 # 80213980 <user_test_table+0x100>
    802012f2:	fffff097          	auipc	ra,0xfffff
    802012f6:	406080e7          	jalr	1030(ra) # 802006f8 <uart_puts>
}
    802012fa:	0001                	nop
    802012fc:	60a2                	ld	ra,8(sp)
    802012fe:	6402                	ld	s0,0(sp)
    80201300:	0141                	addi	sp,sp,16
    80201302:	8082                	ret

0000000080201304 <cursor_up>:

// 光标上移
void cursor_up(int lines) {
    80201304:	1101                	addi	sp,sp,-32
    80201306:	ec06                	sd	ra,24(sp)
    80201308:	e822                	sd	s0,16(sp)
    8020130a:	1000                	addi	s0,sp,32
    8020130c:	87aa                	mv	a5,a0
    8020130e:	fef42623          	sw	a5,-20(s0)
    if (lines <= 0) return;
    80201312:	fec42783          	lw	a5,-20(s0)
    80201316:	2781                	sext.w	a5,a5
    80201318:	02f05f63          	blez	a5,80201356 <cursor_up+0x52>
    consputc('\033');
    8020131c:	456d                	li	a0,27
    8020131e:	00000097          	auipc	ra,0x0
    80201322:	8e2080e7          	jalr	-1822(ra) # 80200c00 <consputc>
    consputc('[');
    80201326:	05b00513          	li	a0,91
    8020132a:	00000097          	auipc	ra,0x0
    8020132e:	8d6080e7          	jalr	-1834(ra) # 80200c00 <consputc>
    printint(lines, 10, 0, 0,0);
    80201332:	fec42783          	lw	a5,-20(s0)
    80201336:	4701                	li	a4,0
    80201338:	4681                	li	a3,0
    8020133a:	4601                	li	a2,0
    8020133c:	45a9                	li	a1,10
    8020133e:	853e                	mv	a0,a5
    80201340:	00000097          	auipc	ra,0x0
    80201344:	914080e7          	jalr	-1772(ra) # 80200c54 <printint>
    consputc('A');
    80201348:	04100513          	li	a0,65
    8020134c:	00000097          	auipc	ra,0x0
    80201350:	8b4080e7          	jalr	-1868(ra) # 80200c00 <consputc>
    80201354:	a011                	j	80201358 <cursor_up+0x54>
    if (lines <= 0) return;
    80201356:	0001                	nop
}
    80201358:	60e2                	ld	ra,24(sp)
    8020135a:	6442                	ld	s0,16(sp)
    8020135c:	6105                	addi	sp,sp,32
    8020135e:	8082                	ret

0000000080201360 <cursor_down>:

// 光标下移
void cursor_down(int lines) {
    80201360:	1101                	addi	sp,sp,-32
    80201362:	ec06                	sd	ra,24(sp)
    80201364:	e822                	sd	s0,16(sp)
    80201366:	1000                	addi	s0,sp,32
    80201368:	87aa                	mv	a5,a0
    8020136a:	fef42623          	sw	a5,-20(s0)
    if (lines <= 0) return;
    8020136e:	fec42783          	lw	a5,-20(s0)
    80201372:	2781                	sext.w	a5,a5
    80201374:	02f05f63          	blez	a5,802013b2 <cursor_down+0x52>
    consputc('\033');
    80201378:	456d                	li	a0,27
    8020137a:	00000097          	auipc	ra,0x0
    8020137e:	886080e7          	jalr	-1914(ra) # 80200c00 <consputc>
    consputc('[');
    80201382:	05b00513          	li	a0,91
    80201386:	00000097          	auipc	ra,0x0
    8020138a:	87a080e7          	jalr	-1926(ra) # 80200c00 <consputc>
    printint(lines, 10, 0, 0,0);
    8020138e:	fec42783          	lw	a5,-20(s0)
    80201392:	4701                	li	a4,0
    80201394:	4681                	li	a3,0
    80201396:	4601                	li	a2,0
    80201398:	45a9                	li	a1,10
    8020139a:	853e                	mv	a0,a5
    8020139c:	00000097          	auipc	ra,0x0
    802013a0:	8b8080e7          	jalr	-1864(ra) # 80200c54 <printint>
    consputc('B');
    802013a4:	04200513          	li	a0,66
    802013a8:	00000097          	auipc	ra,0x0
    802013ac:	858080e7          	jalr	-1960(ra) # 80200c00 <consputc>
    802013b0:	a011                	j	802013b4 <cursor_down+0x54>
    if (lines <= 0) return;
    802013b2:	0001                	nop
}
    802013b4:	60e2                	ld	ra,24(sp)
    802013b6:	6442                	ld	s0,16(sp)
    802013b8:	6105                	addi	sp,sp,32
    802013ba:	8082                	ret

00000000802013bc <cursor_right>:

// 光标右移
void cursor_right(int cols) {
    802013bc:	1101                	addi	sp,sp,-32
    802013be:	ec06                	sd	ra,24(sp)
    802013c0:	e822                	sd	s0,16(sp)
    802013c2:	1000                	addi	s0,sp,32
    802013c4:	87aa                	mv	a5,a0
    802013c6:	fef42623          	sw	a5,-20(s0)
    if (cols <= 0) return;
    802013ca:	fec42783          	lw	a5,-20(s0)
    802013ce:	2781                	sext.w	a5,a5
    802013d0:	02f05f63          	blez	a5,8020140e <cursor_right+0x52>
    consputc('\033');
    802013d4:	456d                	li	a0,27
    802013d6:	00000097          	auipc	ra,0x0
    802013da:	82a080e7          	jalr	-2006(ra) # 80200c00 <consputc>
    consputc('[');
    802013de:	05b00513          	li	a0,91
    802013e2:	00000097          	auipc	ra,0x0
    802013e6:	81e080e7          	jalr	-2018(ra) # 80200c00 <consputc>
    printint(cols, 10, 0,0,0);
    802013ea:	fec42783          	lw	a5,-20(s0)
    802013ee:	4701                	li	a4,0
    802013f0:	4681                	li	a3,0
    802013f2:	4601                	li	a2,0
    802013f4:	45a9                	li	a1,10
    802013f6:	853e                	mv	a0,a5
    802013f8:	00000097          	auipc	ra,0x0
    802013fc:	85c080e7          	jalr	-1956(ra) # 80200c54 <printint>
    consputc('C');
    80201400:	04300513          	li	a0,67
    80201404:	fffff097          	auipc	ra,0xfffff
    80201408:	7fc080e7          	jalr	2044(ra) # 80200c00 <consputc>
    8020140c:	a011                	j	80201410 <cursor_right+0x54>
    if (cols <= 0) return;
    8020140e:	0001                	nop
}
    80201410:	60e2                	ld	ra,24(sp)
    80201412:	6442                	ld	s0,16(sp)
    80201414:	6105                	addi	sp,sp,32
    80201416:	8082                	ret

0000000080201418 <cursor_left>:

// 光标左移
void cursor_left(int cols) {
    80201418:	1101                	addi	sp,sp,-32
    8020141a:	ec06                	sd	ra,24(sp)
    8020141c:	e822                	sd	s0,16(sp)
    8020141e:	1000                	addi	s0,sp,32
    80201420:	87aa                	mv	a5,a0
    80201422:	fef42623          	sw	a5,-20(s0)
    if (cols <= 0) return;
    80201426:	fec42783          	lw	a5,-20(s0)
    8020142a:	2781                	sext.w	a5,a5
    8020142c:	02f05f63          	blez	a5,8020146a <cursor_left+0x52>
    consputc('\033');
    80201430:	456d                	li	a0,27
    80201432:	fffff097          	auipc	ra,0xfffff
    80201436:	7ce080e7          	jalr	1998(ra) # 80200c00 <consputc>
    consputc('[');
    8020143a:	05b00513          	li	a0,91
    8020143e:	fffff097          	auipc	ra,0xfffff
    80201442:	7c2080e7          	jalr	1986(ra) # 80200c00 <consputc>
    printint(cols, 10, 0,0,0);
    80201446:	fec42783          	lw	a5,-20(s0)
    8020144a:	4701                	li	a4,0
    8020144c:	4681                	li	a3,0
    8020144e:	4601                	li	a2,0
    80201450:	45a9                	li	a1,10
    80201452:	853e                	mv	a0,a5
    80201454:	00000097          	auipc	ra,0x0
    80201458:	800080e7          	jalr	-2048(ra) # 80200c54 <printint>
    consputc('D');
    8020145c:	04400513          	li	a0,68
    80201460:	fffff097          	auipc	ra,0xfffff
    80201464:	7a0080e7          	jalr	1952(ra) # 80200c00 <consputc>
    80201468:	a011                	j	8020146c <cursor_left+0x54>
    if (cols <= 0) return;
    8020146a:	0001                	nop
}
    8020146c:	60e2                	ld	ra,24(sp)
    8020146e:	6442                	ld	s0,16(sp)
    80201470:	6105                	addi	sp,sp,32
    80201472:	8082                	ret

0000000080201474 <save_cursor>:
// 保存光标位置
void save_cursor(void) {
    80201474:	1141                	addi	sp,sp,-16
    80201476:	e406                	sd	ra,8(sp)
    80201478:	e022                	sd	s0,0(sp)
    8020147a:	0800                	addi	s0,sp,16
    consputc('\033');
    8020147c:	456d                	li	a0,27
    8020147e:	fffff097          	auipc	ra,0xfffff
    80201482:	782080e7          	jalr	1922(ra) # 80200c00 <consputc>
    consputc('[');
    80201486:	05b00513          	li	a0,91
    8020148a:	fffff097          	auipc	ra,0xfffff
    8020148e:	776080e7          	jalr	1910(ra) # 80200c00 <consputc>
    consputc('s');
    80201492:	07300513          	li	a0,115
    80201496:	fffff097          	auipc	ra,0xfffff
    8020149a:	76a080e7          	jalr	1898(ra) # 80200c00 <consputc>
}
    8020149e:	0001                	nop
    802014a0:	60a2                	ld	ra,8(sp)
    802014a2:	6402                	ld	s0,0(sp)
    802014a4:	0141                	addi	sp,sp,16
    802014a6:	8082                	ret

00000000802014a8 <restore_cursor>:

// 恢复光标位置
void restore_cursor(void) {
    802014a8:	1141                	addi	sp,sp,-16
    802014aa:	e406                	sd	ra,8(sp)
    802014ac:	e022                	sd	s0,0(sp)
    802014ae:	0800                	addi	s0,sp,16
    consputc('\033');
    802014b0:	456d                	li	a0,27
    802014b2:	fffff097          	auipc	ra,0xfffff
    802014b6:	74e080e7          	jalr	1870(ra) # 80200c00 <consputc>
    consputc('[');
    802014ba:	05b00513          	li	a0,91
    802014be:	fffff097          	auipc	ra,0xfffff
    802014c2:	742080e7          	jalr	1858(ra) # 80200c00 <consputc>
    consputc('u');
    802014c6:	07500513          	li	a0,117
    802014ca:	fffff097          	auipc	ra,0xfffff
    802014ce:	736080e7          	jalr	1846(ra) # 80200c00 <consputc>
}
    802014d2:	0001                	nop
    802014d4:	60a2                	ld	ra,8(sp)
    802014d6:	6402                	ld	s0,0(sp)
    802014d8:	0141                	addi	sp,sp,16
    802014da:	8082                	ret

00000000802014dc <cursor_to_column>:

// 移动到行首
void cursor_to_column(int col) {
    802014dc:	1101                	addi	sp,sp,-32
    802014de:	ec06                	sd	ra,24(sp)
    802014e0:	e822                	sd	s0,16(sp)
    802014e2:	1000                	addi	s0,sp,32
    802014e4:	87aa                	mv	a5,a0
    802014e6:	fef42623          	sw	a5,-20(s0)
    if (col <= 0) col = 1;
    802014ea:	fec42783          	lw	a5,-20(s0)
    802014ee:	2781                	sext.w	a5,a5
    802014f0:	00f04563          	bgtz	a5,802014fa <cursor_to_column+0x1e>
    802014f4:	4785                	li	a5,1
    802014f6:	fef42623          	sw	a5,-20(s0)
    consputc('\033');
    802014fa:	456d                	li	a0,27
    802014fc:	fffff097          	auipc	ra,0xfffff
    80201500:	704080e7          	jalr	1796(ra) # 80200c00 <consputc>
    consputc('[');
    80201504:	05b00513          	li	a0,91
    80201508:	fffff097          	auipc	ra,0xfffff
    8020150c:	6f8080e7          	jalr	1784(ra) # 80200c00 <consputc>
    printint(col, 10, 0,0,0);
    80201510:	fec42783          	lw	a5,-20(s0)
    80201514:	4701                	li	a4,0
    80201516:	4681                	li	a3,0
    80201518:	4601                	li	a2,0
    8020151a:	45a9                	li	a1,10
    8020151c:	853e                	mv	a0,a5
    8020151e:	fffff097          	auipc	ra,0xfffff
    80201522:	736080e7          	jalr	1846(ra) # 80200c54 <printint>
    consputc('G');
    80201526:	04700513          	li	a0,71
    8020152a:	fffff097          	auipc	ra,0xfffff
    8020152e:	6d6080e7          	jalr	1750(ra) # 80200c00 <consputc>
}
    80201532:	0001                	nop
    80201534:	60e2                	ld	ra,24(sp)
    80201536:	6442                	ld	s0,16(sp)
    80201538:	6105                	addi	sp,sp,32
    8020153a:	8082                	ret

000000008020153c <goto_rc>:
// 光标定位到指定行列
void goto_rc(int row, int col) {
    8020153c:	1101                	addi	sp,sp,-32
    8020153e:	ec06                	sd	ra,24(sp)
    80201540:	e822                	sd	s0,16(sp)
    80201542:	1000                	addi	s0,sp,32
    80201544:	87aa                	mv	a5,a0
    80201546:	872e                	mv	a4,a1
    80201548:	fef42623          	sw	a5,-20(s0)
    8020154c:	87ba                	mv	a5,a4
    8020154e:	fef42423          	sw	a5,-24(s0)
    consputc('\033');
    80201552:	456d                	li	a0,27
    80201554:	fffff097          	auipc	ra,0xfffff
    80201558:	6ac080e7          	jalr	1708(ra) # 80200c00 <consputc>
    consputc('[');
    8020155c:	05b00513          	li	a0,91
    80201560:	fffff097          	auipc	ra,0xfffff
    80201564:	6a0080e7          	jalr	1696(ra) # 80200c00 <consputc>
    printint(row, 10, 0,0,0);
    80201568:	fec42783          	lw	a5,-20(s0)
    8020156c:	4701                	li	a4,0
    8020156e:	4681                	li	a3,0
    80201570:	4601                	li	a2,0
    80201572:	45a9                	li	a1,10
    80201574:	853e                	mv	a0,a5
    80201576:	fffff097          	auipc	ra,0xfffff
    8020157a:	6de080e7          	jalr	1758(ra) # 80200c54 <printint>
    consputc(';');
    8020157e:	03b00513          	li	a0,59
    80201582:	fffff097          	auipc	ra,0xfffff
    80201586:	67e080e7          	jalr	1662(ra) # 80200c00 <consputc>
    printint(col, 10, 0,0,0);
    8020158a:	fe842783          	lw	a5,-24(s0)
    8020158e:	4701                	li	a4,0
    80201590:	4681                	li	a3,0
    80201592:	4601                	li	a2,0
    80201594:	45a9                	li	a1,10
    80201596:	853e                	mv	a0,a5
    80201598:	fffff097          	auipc	ra,0xfffff
    8020159c:	6bc080e7          	jalr	1724(ra) # 80200c54 <printint>
    consputc('H');
    802015a0:	04800513          	li	a0,72
    802015a4:	fffff097          	auipc	ra,0xfffff
    802015a8:	65c080e7          	jalr	1628(ra) # 80200c00 <consputc>
}
    802015ac:	0001                	nop
    802015ae:	60e2                	ld	ra,24(sp)
    802015b0:	6442                	ld	s0,16(sp)
    802015b2:	6105                	addi	sp,sp,32
    802015b4:	8082                	ret

00000000802015b6 <reset_color>:
// 颜色控制
void reset_color(void) {
    802015b6:	1141                	addi	sp,sp,-16
    802015b8:	e406                	sd	ra,8(sp)
    802015ba:	e022                	sd	s0,0(sp)
    802015bc:	0800                	addi	s0,sp,16
	uart_puts(ESC "[0m");
    802015be:	00012517          	auipc	a0,0x12
    802015c2:	3ca50513          	addi	a0,a0,970 # 80213988 <user_test_table+0x108>
    802015c6:	fffff097          	auipc	ra,0xfffff
    802015ca:	132080e7          	jalr	306(ra) # 802006f8 <uart_puts>
}
    802015ce:	0001                	nop
    802015d0:	60a2                	ld	ra,8(sp)
    802015d2:	6402                	ld	s0,0(sp)
    802015d4:	0141                	addi	sp,sp,16
    802015d6:	8082                	ret

00000000802015d8 <set_fg_color>:
// 设置前景色
void set_fg_color(int color) {
    802015d8:	1101                	addi	sp,sp,-32
    802015da:	ec06                	sd	ra,24(sp)
    802015dc:	e822                	sd	s0,16(sp)
    802015de:	1000                	addi	s0,sp,32
    802015e0:	87aa                	mv	a5,a0
    802015e2:	fef42623          	sw	a5,-20(s0)
	if (color < 30 || color > 37) return; // 支持30-37
    802015e6:	fec42783          	lw	a5,-20(s0)
    802015ea:	0007871b          	sext.w	a4,a5
    802015ee:	47f5                	li	a5,29
    802015f0:	04e7d763          	bge	a5,a4,8020163e <set_fg_color+0x66>
    802015f4:	fec42783          	lw	a5,-20(s0)
    802015f8:	0007871b          	sext.w	a4,a5
    802015fc:	02500793          	li	a5,37
    80201600:	02e7cf63          	blt	a5,a4,8020163e <set_fg_color+0x66>
	consputc('\033');
    80201604:	456d                	li	a0,27
    80201606:	fffff097          	auipc	ra,0xfffff
    8020160a:	5fa080e7          	jalr	1530(ra) # 80200c00 <consputc>
	consputc('[');
    8020160e:	05b00513          	li	a0,91
    80201612:	fffff097          	auipc	ra,0xfffff
    80201616:	5ee080e7          	jalr	1518(ra) # 80200c00 <consputc>
	printint(color, 10, 0,0,0);
    8020161a:	fec42783          	lw	a5,-20(s0)
    8020161e:	4701                	li	a4,0
    80201620:	4681                	li	a3,0
    80201622:	4601                	li	a2,0
    80201624:	45a9                	li	a1,10
    80201626:	853e                	mv	a0,a5
    80201628:	fffff097          	auipc	ra,0xfffff
    8020162c:	62c080e7          	jalr	1580(ra) # 80200c54 <printint>
	consputc('m');
    80201630:	06d00513          	li	a0,109
    80201634:	fffff097          	auipc	ra,0xfffff
    80201638:	5cc080e7          	jalr	1484(ra) # 80200c00 <consputc>
    8020163c:	a011                	j	80201640 <set_fg_color+0x68>
	if (color < 30 || color > 37) return; // 支持30-37
    8020163e:	0001                	nop
}
    80201640:	60e2                	ld	ra,24(sp)
    80201642:	6442                	ld	s0,16(sp)
    80201644:	6105                	addi	sp,sp,32
    80201646:	8082                	ret

0000000080201648 <set_bg_color>:
// 设置背景色
void set_bg_color(int color) {
    80201648:	1101                	addi	sp,sp,-32
    8020164a:	ec06                	sd	ra,24(sp)
    8020164c:	e822                	sd	s0,16(sp)
    8020164e:	1000                	addi	s0,sp,32
    80201650:	87aa                	mv	a5,a0
    80201652:	fef42623          	sw	a5,-20(s0)
	if (color < 40 || color > 47) return; // 支持40-47
    80201656:	fec42783          	lw	a5,-20(s0)
    8020165a:	0007871b          	sext.w	a4,a5
    8020165e:	02700793          	li	a5,39
    80201662:	04e7d763          	bge	a5,a4,802016b0 <set_bg_color+0x68>
    80201666:	fec42783          	lw	a5,-20(s0)
    8020166a:	0007871b          	sext.w	a4,a5
    8020166e:	02f00793          	li	a5,47
    80201672:	02e7cf63          	blt	a5,a4,802016b0 <set_bg_color+0x68>
	consputc('\033');
    80201676:	456d                	li	a0,27
    80201678:	fffff097          	auipc	ra,0xfffff
    8020167c:	588080e7          	jalr	1416(ra) # 80200c00 <consputc>
	consputc('[');
    80201680:	05b00513          	li	a0,91
    80201684:	fffff097          	auipc	ra,0xfffff
    80201688:	57c080e7          	jalr	1404(ra) # 80200c00 <consputc>
	printint(color, 10, 0,0,0);
    8020168c:	fec42783          	lw	a5,-20(s0)
    80201690:	4701                	li	a4,0
    80201692:	4681                	li	a3,0
    80201694:	4601                	li	a2,0
    80201696:	45a9                	li	a1,10
    80201698:	853e                	mv	a0,a5
    8020169a:	fffff097          	auipc	ra,0xfffff
    8020169e:	5ba080e7          	jalr	1466(ra) # 80200c54 <printint>
	consputc('m');
    802016a2:	06d00513          	li	a0,109
    802016a6:	fffff097          	auipc	ra,0xfffff
    802016aa:	55a080e7          	jalr	1370(ra) # 80200c00 <consputc>
    802016ae:	a011                	j	802016b2 <set_bg_color+0x6a>
	if (color < 40 || color > 47) return; // 支持40-47
    802016b0:	0001                	nop
}
    802016b2:	60e2                	ld	ra,24(sp)
    802016b4:	6442                	ld	s0,16(sp)
    802016b6:	6105                	addi	sp,sp,32
    802016b8:	8082                	ret

00000000802016ba <color_red>:
// 简易文字颜色
void color_red(void) {
    802016ba:	1141                	addi	sp,sp,-16
    802016bc:	e406                	sd	ra,8(sp)
    802016be:	e022                	sd	s0,0(sp)
    802016c0:	0800                	addi	s0,sp,16
	set_fg_color(31); // 红色
    802016c2:	457d                	li	a0,31
    802016c4:	00000097          	auipc	ra,0x0
    802016c8:	f14080e7          	jalr	-236(ra) # 802015d8 <set_fg_color>
}
    802016cc:	0001                	nop
    802016ce:	60a2                	ld	ra,8(sp)
    802016d0:	6402                	ld	s0,0(sp)
    802016d2:	0141                	addi	sp,sp,16
    802016d4:	8082                	ret

00000000802016d6 <color_green>:
void color_green(void) {
    802016d6:	1141                	addi	sp,sp,-16
    802016d8:	e406                	sd	ra,8(sp)
    802016da:	e022                	sd	s0,0(sp)
    802016dc:	0800                	addi	s0,sp,16
	set_fg_color(32); // 绿色
    802016de:	02000513          	li	a0,32
    802016e2:	00000097          	auipc	ra,0x0
    802016e6:	ef6080e7          	jalr	-266(ra) # 802015d8 <set_fg_color>
}
    802016ea:	0001                	nop
    802016ec:	60a2                	ld	ra,8(sp)
    802016ee:	6402                	ld	s0,0(sp)
    802016f0:	0141                	addi	sp,sp,16
    802016f2:	8082                	ret

00000000802016f4 <color_yellow>:
void color_yellow(void) {
    802016f4:	1141                	addi	sp,sp,-16
    802016f6:	e406                	sd	ra,8(sp)
    802016f8:	e022                	sd	s0,0(sp)
    802016fa:	0800                	addi	s0,sp,16
	set_fg_color(33); // 黄色
    802016fc:	02100513          	li	a0,33
    80201700:	00000097          	auipc	ra,0x0
    80201704:	ed8080e7          	jalr	-296(ra) # 802015d8 <set_fg_color>
}
    80201708:	0001                	nop
    8020170a:	60a2                	ld	ra,8(sp)
    8020170c:	6402                	ld	s0,0(sp)
    8020170e:	0141                	addi	sp,sp,16
    80201710:	8082                	ret

0000000080201712 <color_blue>:
void color_blue(void) {
    80201712:	1141                	addi	sp,sp,-16
    80201714:	e406                	sd	ra,8(sp)
    80201716:	e022                	sd	s0,0(sp)
    80201718:	0800                	addi	s0,sp,16
	set_fg_color(34); // 蓝色
    8020171a:	02200513          	li	a0,34
    8020171e:	00000097          	auipc	ra,0x0
    80201722:	eba080e7          	jalr	-326(ra) # 802015d8 <set_fg_color>
}
    80201726:	0001                	nop
    80201728:	60a2                	ld	ra,8(sp)
    8020172a:	6402                	ld	s0,0(sp)
    8020172c:	0141                	addi	sp,sp,16
    8020172e:	8082                	ret

0000000080201730 <color_purple>:
void color_purple(void) {
    80201730:	1141                	addi	sp,sp,-16
    80201732:	e406                	sd	ra,8(sp)
    80201734:	e022                	sd	s0,0(sp)
    80201736:	0800                	addi	s0,sp,16
	set_fg_color(35); // 紫色
    80201738:	02300513          	li	a0,35
    8020173c:	00000097          	auipc	ra,0x0
    80201740:	e9c080e7          	jalr	-356(ra) # 802015d8 <set_fg_color>
}
    80201744:	0001                	nop
    80201746:	60a2                	ld	ra,8(sp)
    80201748:	6402                	ld	s0,0(sp)
    8020174a:	0141                	addi	sp,sp,16
    8020174c:	8082                	ret

000000008020174e <color_cyan>:
void color_cyan(void) {
    8020174e:	1141                	addi	sp,sp,-16
    80201750:	e406                	sd	ra,8(sp)
    80201752:	e022                	sd	s0,0(sp)
    80201754:	0800                	addi	s0,sp,16
	set_fg_color(36); // 青色
    80201756:	02400513          	li	a0,36
    8020175a:	00000097          	auipc	ra,0x0
    8020175e:	e7e080e7          	jalr	-386(ra) # 802015d8 <set_fg_color>
}
    80201762:	0001                	nop
    80201764:	60a2                	ld	ra,8(sp)
    80201766:	6402                	ld	s0,0(sp)
    80201768:	0141                	addi	sp,sp,16
    8020176a:	8082                	ret

000000008020176c <color_reverse>:
void color_reverse(void){
    8020176c:	1141                	addi	sp,sp,-16
    8020176e:	e406                	sd	ra,8(sp)
    80201770:	e022                	sd	s0,0(sp)
    80201772:	0800                	addi	s0,sp,16
	set_fg_color(37); // 反色
    80201774:	02500513          	li	a0,37
    80201778:	00000097          	auipc	ra,0x0
    8020177c:	e60080e7          	jalr	-416(ra) # 802015d8 <set_fg_color>
}
    80201780:	0001                	nop
    80201782:	60a2                	ld	ra,8(sp)
    80201784:	6402                	ld	s0,0(sp)
    80201786:	0141                	addi	sp,sp,16
    80201788:	8082                	ret

000000008020178a <set_color>:
void set_color(int fg, int bg) {
    8020178a:	1101                	addi	sp,sp,-32
    8020178c:	ec06                	sd	ra,24(sp)
    8020178e:	e822                	sd	s0,16(sp)
    80201790:	1000                	addi	s0,sp,32
    80201792:	87aa                	mv	a5,a0
    80201794:	872e                	mv	a4,a1
    80201796:	fef42623          	sw	a5,-20(s0)
    8020179a:	87ba                	mv	a5,a4
    8020179c:	fef42423          	sw	a5,-24(s0)
	set_bg_color(bg);
    802017a0:	fe842783          	lw	a5,-24(s0)
    802017a4:	853e                	mv	a0,a5
    802017a6:	00000097          	auipc	ra,0x0
    802017aa:	ea2080e7          	jalr	-350(ra) # 80201648 <set_bg_color>
	set_fg_color(fg);
    802017ae:	fec42783          	lw	a5,-20(s0)
    802017b2:	853e                	mv	a0,a5
    802017b4:	00000097          	auipc	ra,0x0
    802017b8:	e24080e7          	jalr	-476(ra) # 802015d8 <set_fg_color>
}
    802017bc:	0001                	nop
    802017be:	60e2                	ld	ra,24(sp)
    802017c0:	6442                	ld	s0,16(sp)
    802017c2:	6105                	addi	sp,sp,32
    802017c4:	8082                	ret

00000000802017c6 <clear_line>:
void clear_line(){
    802017c6:	1141                	addi	sp,sp,-16
    802017c8:	e406                	sd	ra,8(sp)
    802017ca:	e022                	sd	s0,0(sp)
    802017cc:	0800                	addi	s0,sp,16
	consputc('\033');
    802017ce:	456d                	li	a0,27
    802017d0:	fffff097          	auipc	ra,0xfffff
    802017d4:	430080e7          	jalr	1072(ra) # 80200c00 <consputc>
	consputc('[');
    802017d8:	05b00513          	li	a0,91
    802017dc:	fffff097          	auipc	ra,0xfffff
    802017e0:	424080e7          	jalr	1060(ra) # 80200c00 <consputc>
	consputc('2');
    802017e4:	03200513          	li	a0,50
    802017e8:	fffff097          	auipc	ra,0xfffff
    802017ec:	418080e7          	jalr	1048(ra) # 80200c00 <consputc>
	consputc('K');
    802017f0:	04b00513          	li	a0,75
    802017f4:	fffff097          	auipc	ra,0xfffff
    802017f8:	40c080e7          	jalr	1036(ra) # 80200c00 <consputc>
}
    802017fc:	0001                	nop
    802017fe:	60a2                	ld	ra,8(sp)
    80201800:	6402                	ld	s0,0(sp)
    80201802:	0141                	addi	sp,sp,16
    80201804:	8082                	ret

0000000080201806 <panic>:

void panic(const char *msg) {
    80201806:	1101                	addi	sp,sp,-32
    80201808:	ec06                	sd	ra,24(sp)
    8020180a:	e822                	sd	s0,16(sp)
    8020180c:	1000                	addi	s0,sp,32
    8020180e:	fea43423          	sd	a0,-24(s0)
	color_red(); // 可选：红色显示
    80201812:	00000097          	auipc	ra,0x0
    80201816:	ea8080e7          	jalr	-344(ra) # 802016ba <color_red>
	printf("panic: %s\n", msg);
    8020181a:	fe843583          	ld	a1,-24(s0)
    8020181e:	00012517          	auipc	a0,0x12
    80201822:	17250513          	addi	a0,a0,370 # 80213990 <user_test_table+0x110>
    80201826:	00000097          	auipc	ra,0x0
    8020182a:	a5e080e7          	jalr	-1442(ra) # 80201284 <printf>
	reset_color();
    8020182e:	00000097          	auipc	ra,0x0
    80201832:	d88080e7          	jalr	-632(ra) # 802015b6 <reset_color>
	while (1) { /* 死循环，防止继续执行 */ }
    80201836:	0001                	nop
    80201838:	bffd                	j	80201836 <panic+0x30>

000000008020183a <warning>:
}
void warning(const char *fmt, ...) {
    8020183a:	7159                	addi	sp,sp,-112
    8020183c:	f406                	sd	ra,40(sp)
    8020183e:	f022                	sd	s0,32(sp)
    80201840:	1800                	addi	s0,sp,48
    80201842:	fca43c23          	sd	a0,-40(s0)
    80201846:	e40c                	sd	a1,8(s0)
    80201848:	e810                	sd	a2,16(s0)
    8020184a:	ec14                	sd	a3,24(s0)
    8020184c:	f018                	sd	a4,32(s0)
    8020184e:	f41c                	sd	a5,40(s0)
    80201850:	03043823          	sd	a6,48(s0)
    80201854:	03143c23          	sd	a7,56(s0)
    va_list ap;
    color_purple(); // 设置紫色
    80201858:	00000097          	auipc	ra,0x0
    8020185c:	ed8080e7          	jalr	-296(ra) # 80201730 <color_purple>
    printf("[WARNING] ");
    80201860:	00012517          	auipc	a0,0x12
    80201864:	14050513          	addi	a0,a0,320 # 802139a0 <user_test_table+0x120>
    80201868:	00000097          	auipc	ra,0x0
    8020186c:	a1c080e7          	jalr	-1508(ra) # 80201284 <printf>
    va_start(ap, fmt);
    80201870:	04040793          	addi	a5,s0,64
    80201874:	fcf43823          	sd	a5,-48(s0)
    80201878:	fd043783          	ld	a5,-48(s0)
    8020187c:	fc878793          	addi	a5,a5,-56
    80201880:	fef43423          	sd	a5,-24(s0)
    vprintf(fmt, ap);
    80201884:	fe843783          	ld	a5,-24(s0)
    80201888:	85be                	mv	a1,a5
    8020188a:	fd843503          	ld	a0,-40(s0)
    8020188e:	fffff097          	auipc	ra,0xfffff
    80201892:	500080e7          	jalr	1280(ra) # 80200d8e <vprintf>
    va_end(ap);
    reset_color(); // 恢复默认颜色
    80201896:	00000097          	auipc	ra,0x0
    8020189a:	d20080e7          	jalr	-736(ra) # 802015b6 <reset_color>
}
    8020189e:	0001                	nop
    802018a0:	70a2                	ld	ra,40(sp)
    802018a2:	7402                	ld	s0,32(sp)
    802018a4:	6165                	addi	sp,sp,112
    802018a6:	8082                	ret

00000000802018a8 <test_printf_precision>:
void test_printf_precision(void) {
    802018a8:	1101                	addi	sp,sp,-32
    802018aa:	ec06                	sd	ra,24(sp)
    802018ac:	e822                	sd	s0,16(sp)
    802018ae:	1000                	addi	s0,sp,32
	clear_screen();
    802018b0:	00000097          	auipc	ra,0x0
    802018b4:	a22080e7          	jalr	-1502(ra) # 802012d2 <clear_screen>
    printf("=== 详细的printf测试 ===\n");
    802018b8:	00012517          	auipc	a0,0x12
    802018bc:	0f850513          	addi	a0,a0,248 # 802139b0 <user_test_table+0x130>
    802018c0:	00000097          	auipc	ra,0x0
    802018c4:	9c4080e7          	jalr	-1596(ra) # 80201284 <printf>
    
    // 测试十六进制格式
    printf("十六进制测试:\n");
    802018c8:	00012517          	auipc	a0,0x12
    802018cc:	10850513          	addi	a0,a0,264 # 802139d0 <user_test_table+0x150>
    802018d0:	00000097          	auipc	ra,0x0
    802018d4:	9b4080e7          	jalr	-1612(ra) # 80201284 <printf>
    printf("  255 = 0x%x (expected: ff)\n", 255);
    802018d8:	0ff00593          	li	a1,255
    802018dc:	00012517          	auipc	a0,0x12
    802018e0:	10c50513          	addi	a0,a0,268 # 802139e8 <user_test_table+0x168>
    802018e4:	00000097          	auipc	ra,0x0
    802018e8:	9a0080e7          	jalr	-1632(ra) # 80201284 <printf>
    printf("  4096 = 0x%x (expected: 1000)\n", 4096);
    802018ec:	6585                	lui	a1,0x1
    802018ee:	00012517          	auipc	a0,0x12
    802018f2:	11a50513          	addi	a0,a0,282 # 80213a08 <user_test_table+0x188>
    802018f6:	00000097          	auipc	ra,0x0
    802018fa:	98e080e7          	jalr	-1650(ra) # 80201284 <printf>
    printf("  0x1234abcd = 0x%x\n", 0x1234abcd);
    802018fe:	1234b7b7          	lui	a5,0x1234b
    80201902:	bcd78593          	addi	a1,a5,-1075 # 1234abcd <_entry-0x6deb5433>
    80201906:	00012517          	auipc	a0,0x12
    8020190a:	12250513          	addi	a0,a0,290 # 80213a28 <user_test_table+0x1a8>
    8020190e:	00000097          	auipc	ra,0x0
    80201912:	976080e7          	jalr	-1674(ra) # 80201284 <printf>
    
    // 测试十进制格式  
    printf("十进制测试:\n");
    80201916:	00012517          	auipc	a0,0x12
    8020191a:	12a50513          	addi	a0,a0,298 # 80213a40 <user_test_table+0x1c0>
    8020191e:	00000097          	auipc	ra,0x0
    80201922:	966080e7          	jalr	-1690(ra) # 80201284 <printf>
    printf("  正数: %d\n", 42);
    80201926:	02a00593          	li	a1,42
    8020192a:	00012517          	auipc	a0,0x12
    8020192e:	12e50513          	addi	a0,a0,302 # 80213a58 <user_test_table+0x1d8>
    80201932:	00000097          	auipc	ra,0x0
    80201936:	952080e7          	jalr	-1710(ra) # 80201284 <printf>
    printf("  负数: %d\n", -42);
    8020193a:	fd600593          	li	a1,-42
    8020193e:	00012517          	auipc	a0,0x12
    80201942:	12a50513          	addi	a0,a0,298 # 80213a68 <user_test_table+0x1e8>
    80201946:	00000097          	auipc	ra,0x0
    8020194a:	93e080e7          	jalr	-1730(ra) # 80201284 <printf>
    printf("  零: %d\n", 0);
    8020194e:	4581                	li	a1,0
    80201950:	00012517          	auipc	a0,0x12
    80201954:	12850513          	addi	a0,a0,296 # 80213a78 <user_test_table+0x1f8>
    80201958:	00000097          	auipc	ra,0x0
    8020195c:	92c080e7          	jalr	-1748(ra) # 80201284 <printf>
    printf("  大数: %d\n", 123456789);
    80201960:	075bd7b7          	lui	a5,0x75bd
    80201964:	d1578593          	addi	a1,a5,-747 # 75bcd15 <_entry-0x78c432eb>
    80201968:	00012517          	auipc	a0,0x12
    8020196c:	12050513          	addi	a0,a0,288 # 80213a88 <user_test_table+0x208>
    80201970:	00000097          	auipc	ra,0x0
    80201974:	914080e7          	jalr	-1772(ra) # 80201284 <printf>
    
    // 测试无符号格式
    printf("无符号测试:\n");
    80201978:	00012517          	auipc	a0,0x12
    8020197c:	12050513          	addi	a0,a0,288 # 80213a98 <user_test_table+0x218>
    80201980:	00000097          	auipc	ra,0x0
    80201984:	904080e7          	jalr	-1788(ra) # 80201284 <printf>
    printf("  大无符号数：%u\n", 4294967295U);
    80201988:	55fd                	li	a1,-1
    8020198a:	00012517          	auipc	a0,0x12
    8020198e:	12650513          	addi	a0,a0,294 # 80213ab0 <user_test_table+0x230>
    80201992:	00000097          	auipc	ra,0x0
    80201996:	8f2080e7          	jalr	-1806(ra) # 80201284 <printf>
    printf("  零：%u\n", 0U);
    8020199a:	4581                	li	a1,0
    8020199c:	00012517          	auipc	a0,0x12
    802019a0:	12c50513          	addi	a0,a0,300 # 80213ac8 <user_test_table+0x248>
    802019a4:	00000097          	auipc	ra,0x0
    802019a8:	8e0080e7          	jalr	-1824(ra) # 80201284 <printf>
	printf("  小无符号数：%u\n", 12345U);
    802019ac:	678d                	lui	a5,0x3
    802019ae:	03978593          	addi	a1,a5,57 # 3039 <_entry-0x801fcfc7>
    802019b2:	00012517          	auipc	a0,0x12
    802019b6:	12650513          	addi	a0,a0,294 # 80213ad8 <user_test_table+0x258>
    802019ba:	00000097          	auipc	ra,0x0
    802019be:	8ca080e7          	jalr	-1846(ra) # 80201284 <printf>

	// 测试边界
	printf("边界测试:\n");
    802019c2:	00012517          	auipc	a0,0x12
    802019c6:	12e50513          	addi	a0,a0,302 # 80213af0 <user_test_table+0x270>
    802019ca:	00000097          	auipc	ra,0x0
    802019ce:	8ba080e7          	jalr	-1862(ra) # 80201284 <printf>
	printf("  INT_MAX: %d\n", 2147483647);
    802019d2:	800007b7          	lui	a5,0x80000
    802019d6:	fff7c593          	not	a1,a5
    802019da:	00012517          	auipc	a0,0x12
    802019de:	12650513          	addi	a0,a0,294 # 80213b00 <user_test_table+0x280>
    802019e2:	00000097          	auipc	ra,0x0
    802019e6:	8a2080e7          	jalr	-1886(ra) # 80201284 <printf>
	printf("  INT_MIN: %d\n", -2147483648);
    802019ea:	800005b7          	lui	a1,0x80000
    802019ee:	00012517          	auipc	a0,0x12
    802019f2:	12250513          	addi	a0,a0,290 # 80213b10 <user_test_table+0x290>
    802019f6:	00000097          	auipc	ra,0x0
    802019fa:	88e080e7          	jalr	-1906(ra) # 80201284 <printf>
	printf("  UINT_MAX: %u\n", 4294967295U);
    802019fe:	55fd                	li	a1,-1
    80201a00:	00012517          	auipc	a0,0x12
    80201a04:	12050513          	addi	a0,a0,288 # 80213b20 <user_test_table+0x2a0>
    80201a08:	00000097          	auipc	ra,0x0
    80201a0c:	87c080e7          	jalr	-1924(ra) # 80201284 <printf>
	printf(" -1 as unsigned: %u\n", (unsigned int)-1);
    80201a10:	55fd                	li	a1,-1
    80201a12:	00012517          	auipc	a0,0x12
    80201a16:	11e50513          	addi	a0,a0,286 # 80213b30 <user_test_table+0x2b0>
    80201a1a:	00000097          	auipc	ra,0x0
    80201a1e:	86a080e7          	jalr	-1942(ra) # 80201284 <printf>
    
    // 测试字符串边界情况
    printf("字符串测试:\n");
    80201a22:	00012517          	auipc	a0,0x12
    80201a26:	12650513          	addi	a0,a0,294 # 80213b48 <user_test_table+0x2c8>
    80201a2a:	00000097          	auipc	ra,0x0
    80201a2e:	85a080e7          	jalr	-1958(ra) # 80201284 <printf>
    printf("  空字符串: '%s'\n", "");
    80201a32:	00012597          	auipc	a1,0x12
    80201a36:	12e58593          	addi	a1,a1,302 # 80213b60 <user_test_table+0x2e0>
    80201a3a:	00012517          	auipc	a0,0x12
    80201a3e:	12e50513          	addi	a0,a0,302 # 80213b68 <user_test_table+0x2e8>
    80201a42:	00000097          	auipc	ra,0x0
    80201a46:	842080e7          	jalr	-1982(ra) # 80201284 <printf>
    printf("  单字符: '%s'\n", "X");
    80201a4a:	00012597          	auipc	a1,0x12
    80201a4e:	13658593          	addi	a1,a1,310 # 80213b80 <user_test_table+0x300>
    80201a52:	00012517          	auipc	a0,0x12
    80201a56:	13650513          	addi	a0,a0,310 # 80213b88 <user_test_table+0x308>
    80201a5a:	00000097          	auipc	ra,0x0
    80201a5e:	82a080e7          	jalr	-2006(ra) # 80201284 <printf>
    printf("  长字符串: '%s'\n", "This is a longer test string");
    80201a62:	00012597          	auipc	a1,0x12
    80201a66:	13e58593          	addi	a1,a1,318 # 80213ba0 <user_test_table+0x320>
    80201a6a:	00012517          	auipc	a0,0x12
    80201a6e:	15650513          	addi	a0,a0,342 # 80213bc0 <user_test_table+0x340>
    80201a72:	00000097          	auipc	ra,0x0
    80201a76:	812080e7          	jalr	-2030(ra) # 80201284 <printf>
	printf("  非常长字符串： '%s'\n", "Formal version: Entities should not be multiplied beyond necessity.\nPlain English: If two or more explanations fit the facts equally well, choose the simplest one.\nScientific phrasing: When multiple hypotheses explain the same observation, the simplest hypothesis that requires the fewest assumptions is most likely to be correct.");
    80201a7a:	00012597          	auipc	a1,0x12
    80201a7e:	15e58593          	addi	a1,a1,350 # 80213bd8 <user_test_table+0x358>
    80201a82:	00012517          	auipc	a0,0x12
    80201a86:	2a650513          	addi	a0,a0,678 # 80213d28 <user_test_table+0x4a8>
    80201a8a:	fffff097          	auipc	ra,0xfffff
    80201a8e:	7fa080e7          	jalr	2042(ra) # 80201284 <printf>
	
	// 测试混合格式
	printf("混合格式测试:\n");
    80201a92:	00012517          	auipc	a0,0x12
    80201a96:	2b650513          	addi	a0,a0,694 # 80213d48 <user_test_table+0x4c8>
    80201a9a:	fffff097          	auipc	ra,0xfffff
    80201a9e:	7ea080e7          	jalr	2026(ra) # 80201284 <printf>
	printf("  Hex: 0x%x, Dec: %d, Unsigned: %u\n", 255, -255, 255U);
    80201aa2:	0ff00693          	li	a3,255
    80201aa6:	f0100613          	li	a2,-255
    80201aaa:	0ff00593          	li	a1,255
    80201aae:	00012517          	auipc	a0,0x12
    80201ab2:	2b250513          	addi	a0,a0,690 # 80213d60 <user_test_table+0x4e0>
    80201ab6:	fffff097          	auipc	ra,0xfffff
    80201aba:	7ce080e7          	jalr	1998(ra) # 80201284 <printf>
	
	// 测试百分号输出
	printf("百分号输出测试:\n");
    80201abe:	00012517          	auipc	a0,0x12
    80201ac2:	2ca50513          	addi	a0,a0,714 # 80213d88 <user_test_table+0x508>
    80201ac6:	fffff097          	auipc	ra,0xfffff
    80201aca:	7be080e7          	jalr	1982(ra) # 80201284 <printf>
	printf("  100%% 完成!\n");
    80201ace:	00012517          	auipc	a0,0x12
    80201ad2:	2d250513          	addi	a0,a0,722 # 80213da0 <user_test_table+0x520>
    80201ad6:	fffff097          	auipc	ra,0xfffff
    80201ada:	7ae080e7          	jalr	1966(ra) # 80201284 <printf>
	
	// 测试NULL字符串
	char *null_str = 0;
    80201ade:	fe043423          	sd	zero,-24(s0)
	printf("NULL字符串测试:\n");
    80201ae2:	00012517          	auipc	a0,0x12
    80201ae6:	2d650513          	addi	a0,a0,726 # 80213db8 <user_test_table+0x538>
    80201aea:	fffff097          	auipc	ra,0xfffff
    80201aee:	79a080e7          	jalr	1946(ra) # 80201284 <printf>
	printf("  NULL as string: '%s'\n", null_str);
    80201af2:	fe843583          	ld	a1,-24(s0)
    80201af6:	00012517          	auipc	a0,0x12
    80201afa:	2da50513          	addi	a0,a0,730 # 80213dd0 <user_test_table+0x550>
    80201afe:	fffff097          	auipc	ra,0xfffff
    80201b02:	786080e7          	jalr	1926(ra) # 80201284 <printf>
	
	// 测试指针格式
	int var = 42;
    80201b06:	02a00793          	li	a5,42
    80201b0a:	fef42223          	sw	a5,-28(s0)
	printf("指针测试:\n");
    80201b0e:	00012517          	auipc	a0,0x12
    80201b12:	2da50513          	addi	a0,a0,730 # 80213de8 <user_test_table+0x568>
    80201b16:	fffff097          	auipc	ra,0xfffff
    80201b1a:	76e080e7          	jalr	1902(ra) # 80201284 <printf>
	printf("  Address of var: %p\n", &var);
    80201b1e:	fe440793          	addi	a5,s0,-28
    80201b22:	85be                	mv	a1,a5
    80201b24:	00012517          	auipc	a0,0x12
    80201b28:	2d450513          	addi	a0,a0,724 # 80213df8 <user_test_table+0x578>
    80201b2c:	fffff097          	auipc	ra,0xfffff
    80201b30:	758080e7          	jalr	1880(ra) # 80201284 <printf>
	
	// 测试负数的无符号输出
	printf("负数无符号输出测试:\n");
    80201b34:	00012517          	auipc	a0,0x12
    80201b38:	2dc50513          	addi	a0,a0,732 # 80213e10 <user_test_table+0x590>
    80201b3c:	fffff097          	auipc	ra,0xfffff
    80201b40:	748080e7          	jalr	1864(ra) # 80201284 <printf>
	printf("  -1 as unsigned: %u\n", (unsigned int)-1);
    80201b44:	55fd                	li	a1,-1
    80201b46:	00012517          	auipc	a0,0x12
    80201b4a:	2ea50513          	addi	a0,a0,746 # 80213e30 <user_test_table+0x5b0>
    80201b4e:	fffff097          	auipc	ra,0xfffff
    80201b52:	736080e7          	jalr	1846(ra) # 80201284 <printf>
	
	// 测试不同进制的数字
	printf("不同进制测试:\n");
    80201b56:	00012517          	auipc	a0,0x12
    80201b5a:	2f250513          	addi	a0,a0,754 # 80213e48 <user_test_table+0x5c8>
    80201b5e:	fffff097          	auipc	ra,0xfffff
    80201b62:	726080e7          	jalr	1830(ra) # 80201284 <printf>
	printf("  Binary of 5: %b\n", 5);
    80201b66:	4595                	li	a1,5
    80201b68:	00012517          	auipc	a0,0x12
    80201b6c:	2f850513          	addi	a0,a0,760 # 80213e60 <user_test_table+0x5e0>
    80201b70:	fffff097          	auipc	ra,0xfffff
    80201b74:	714080e7          	jalr	1812(ra) # 80201284 <printf>
	printf("  Octal of 8 : %o\n", 8); 
    80201b78:	45a1                	li	a1,8
    80201b7a:	00012517          	auipc	a0,0x12
    80201b7e:	2fe50513          	addi	a0,a0,766 # 80213e78 <user_test_table+0x5f8>
    80201b82:	fffff097          	auipc	ra,0xfffff
    80201b86:	702080e7          	jalr	1794(ra) # 80201284 <printf>
	printf("=== printf测试结束 ===\n");
    80201b8a:	00012517          	auipc	a0,0x12
    80201b8e:	30650513          	addi	a0,a0,774 # 80213e90 <user_test_table+0x610>
    80201b92:	fffff097          	auipc	ra,0xfffff
    80201b96:	6f2080e7          	jalr	1778(ra) # 80201284 <printf>
}
    80201b9a:	0001                	nop
    80201b9c:	60e2                	ld	ra,24(sp)
    80201b9e:	6442                	ld	s0,16(sp)
    80201ba0:	6105                	addi	sp,sp,32
    80201ba2:	8082                	ret

0000000080201ba4 <test_curse_move>:
void test_curse_move(){
    80201ba4:	1101                	addi	sp,sp,-32
    80201ba6:	ec06                	sd	ra,24(sp)
    80201ba8:	e822                	sd	s0,16(sp)
    80201baa:	1000                	addi	s0,sp,32
	clear_screen(); // 清屏
    80201bac:	fffff097          	auipc	ra,0xfffff
    80201bb0:	726080e7          	jalr	1830(ra) # 802012d2 <clear_screen>
	printf("=== 光标移动测试 ===\n");
    80201bb4:	00012517          	auipc	a0,0x12
    80201bb8:	2fc50513          	addi	a0,a0,764 # 80213eb0 <user_test_table+0x630>
    80201bbc:	fffff097          	auipc	ra,0xfffff
    80201bc0:	6c8080e7          	jalr	1736(ra) # 80201284 <printf>
	for (int i = 3; i <= 7; i++) {
    80201bc4:	478d                	li	a5,3
    80201bc6:	fef42623          	sw	a5,-20(s0)
    80201bca:	a881                	j	80201c1a <test_curse_move+0x76>
		for (int j = 1; j <= 10; j++) {
    80201bcc:	4785                	li	a5,1
    80201bce:	fef42423          	sw	a5,-24(s0)
    80201bd2:	a805                	j	80201c02 <test_curse_move+0x5e>
			goto_rc(i, j);
    80201bd4:	fe842703          	lw	a4,-24(s0)
    80201bd8:	fec42783          	lw	a5,-20(s0)
    80201bdc:	85ba                	mv	a1,a4
    80201bde:	853e                	mv	a0,a5
    80201be0:	00000097          	auipc	ra,0x0
    80201be4:	95c080e7          	jalr	-1700(ra) # 8020153c <goto_rc>
			printf("*");
    80201be8:	00012517          	auipc	a0,0x12
    80201bec:	2e850513          	addi	a0,a0,744 # 80213ed0 <user_test_table+0x650>
    80201bf0:	fffff097          	auipc	ra,0xfffff
    80201bf4:	694080e7          	jalr	1684(ra) # 80201284 <printf>
		for (int j = 1; j <= 10; j++) {
    80201bf8:	fe842783          	lw	a5,-24(s0)
    80201bfc:	2785                	addiw	a5,a5,1 # ffffffff80000001 <_bss_end+0xfffffffeffdb76d1>
    80201bfe:	fef42423          	sw	a5,-24(s0)
    80201c02:	fe842783          	lw	a5,-24(s0)
    80201c06:	0007871b          	sext.w	a4,a5
    80201c0a:	47a9                	li	a5,10
    80201c0c:	fce7d4e3          	bge	a5,a4,80201bd4 <test_curse_move+0x30>
	for (int i = 3; i <= 7; i++) {
    80201c10:	fec42783          	lw	a5,-20(s0)
    80201c14:	2785                	addiw	a5,a5,1
    80201c16:	fef42623          	sw	a5,-20(s0)
    80201c1a:	fec42783          	lw	a5,-20(s0)
    80201c1e:	0007871b          	sext.w	a4,a5
    80201c22:	479d                	li	a5,7
    80201c24:	fae7d4e3          	bge	a5,a4,80201bcc <test_curse_move+0x28>
		}
	}
	goto_rc(9, 1);
    80201c28:	4585                	li	a1,1
    80201c2a:	4525                	li	a0,9
    80201c2c:	00000097          	auipc	ra,0x0
    80201c30:	910080e7          	jalr	-1776(ra) # 8020153c <goto_rc>
	save_cursor();
    80201c34:	00000097          	auipc	ra,0x0
    80201c38:	840080e7          	jalr	-1984(ra) # 80201474 <save_cursor>
	// 光标移动测试
	cursor_up(5);
    80201c3c:	4515                	li	a0,5
    80201c3e:	fffff097          	auipc	ra,0xfffff
    80201c42:	6c6080e7          	jalr	1734(ra) # 80201304 <cursor_up>
	cursor_right(2);
    80201c46:	4509                	li	a0,2
    80201c48:	fffff097          	auipc	ra,0xfffff
    80201c4c:	774080e7          	jalr	1908(ra) # 802013bc <cursor_right>
	printf("+++++");
    80201c50:	00012517          	auipc	a0,0x12
    80201c54:	28850513          	addi	a0,a0,648 # 80213ed8 <user_test_table+0x658>
    80201c58:	fffff097          	auipc	ra,0xfffff
    80201c5c:	62c080e7          	jalr	1580(ra) # 80201284 <printf>
	cursor_down(2);
    80201c60:	4509                	li	a0,2
    80201c62:	fffff097          	auipc	ra,0xfffff
    80201c66:	6fe080e7          	jalr	1790(ra) # 80201360 <cursor_down>
	cursor_left(5);
    80201c6a:	4515                	li	a0,5
    80201c6c:	fffff097          	auipc	ra,0xfffff
    80201c70:	7ac080e7          	jalr	1964(ra) # 80201418 <cursor_left>
	printf("-----");
    80201c74:	00012517          	auipc	a0,0x12
    80201c78:	26c50513          	addi	a0,a0,620 # 80213ee0 <user_test_table+0x660>
    80201c7c:	fffff097          	auipc	ra,0xfffff
    80201c80:	608080e7          	jalr	1544(ra) # 80201284 <printf>
	restore_cursor();
    80201c84:	00000097          	auipc	ra,0x0
    80201c88:	824080e7          	jalr	-2012(ra) # 802014a8 <restore_cursor>
	printf("=== 光标移动测试结束 ===\n");
    80201c8c:	00012517          	auipc	a0,0x12
    80201c90:	25c50513          	addi	a0,a0,604 # 80213ee8 <user_test_table+0x668>
    80201c94:	fffff097          	auipc	ra,0xfffff
    80201c98:	5f0080e7          	jalr	1520(ra) # 80201284 <printf>
}
    80201c9c:	0001                	nop
    80201c9e:	60e2                	ld	ra,24(sp)
    80201ca0:	6442                	ld	s0,16(sp)
    80201ca2:	6105                	addi	sp,sp,32
    80201ca4:	8082                	ret

0000000080201ca6 <test_basic_colors>:

void test_basic_colors(void) {
    80201ca6:	1141                	addi	sp,sp,-16
    80201ca8:	e406                	sd	ra,8(sp)
    80201caa:	e022                	sd	s0,0(sp)
    80201cac:	0800                	addi	s0,sp,16
    clear_screen();
    80201cae:	fffff097          	auipc	ra,0xfffff
    80201cb2:	624080e7          	jalr	1572(ra) # 802012d2 <clear_screen>
    printf("=== 基本颜色测试 ===\n\n");
    80201cb6:	00012517          	auipc	a0,0x12
    80201cba:	25a50513          	addi	a0,a0,602 # 80213f10 <user_test_table+0x690>
    80201cbe:	fffff097          	auipc	ra,0xfffff
    80201cc2:	5c6080e7          	jalr	1478(ra) # 80201284 <printf>
    
    // 测试基本前景色
    printf("前景色测试:\n");
    80201cc6:	00012517          	auipc	a0,0x12
    80201cca:	26a50513          	addi	a0,a0,618 # 80213f30 <user_test_table+0x6b0>
    80201cce:	fffff097          	auipc	ra,0xfffff
    80201cd2:	5b6080e7          	jalr	1462(ra) # 80201284 <printf>
    color_red();    printf("红色文字 ");
    80201cd6:	00000097          	auipc	ra,0x0
    80201cda:	9e4080e7          	jalr	-1564(ra) # 802016ba <color_red>
    80201cde:	00012517          	auipc	a0,0x12
    80201ce2:	26a50513          	addi	a0,a0,618 # 80213f48 <user_test_table+0x6c8>
    80201ce6:	fffff097          	auipc	ra,0xfffff
    80201cea:	59e080e7          	jalr	1438(ra) # 80201284 <printf>
    color_green();  printf("绿色文字 ");
    80201cee:	00000097          	auipc	ra,0x0
    80201cf2:	9e8080e7          	jalr	-1560(ra) # 802016d6 <color_green>
    80201cf6:	00012517          	auipc	a0,0x12
    80201cfa:	26250513          	addi	a0,a0,610 # 80213f58 <user_test_table+0x6d8>
    80201cfe:	fffff097          	auipc	ra,0xfffff
    80201d02:	586080e7          	jalr	1414(ra) # 80201284 <printf>
    color_yellow(); printf("黄色文字 ");
    80201d06:	00000097          	auipc	ra,0x0
    80201d0a:	9ee080e7          	jalr	-1554(ra) # 802016f4 <color_yellow>
    80201d0e:	00012517          	auipc	a0,0x12
    80201d12:	25a50513          	addi	a0,a0,602 # 80213f68 <user_test_table+0x6e8>
    80201d16:	fffff097          	auipc	ra,0xfffff
    80201d1a:	56e080e7          	jalr	1390(ra) # 80201284 <printf>
    color_blue();   printf("蓝色文字 ");
    80201d1e:	00000097          	auipc	ra,0x0
    80201d22:	9f4080e7          	jalr	-1548(ra) # 80201712 <color_blue>
    80201d26:	00012517          	auipc	a0,0x12
    80201d2a:	25250513          	addi	a0,a0,594 # 80213f78 <user_test_table+0x6f8>
    80201d2e:	fffff097          	auipc	ra,0xfffff
    80201d32:	556080e7          	jalr	1366(ra) # 80201284 <printf>
    color_purple(); printf("紫色文字 ");
    80201d36:	00000097          	auipc	ra,0x0
    80201d3a:	9fa080e7          	jalr	-1542(ra) # 80201730 <color_purple>
    80201d3e:	00012517          	auipc	a0,0x12
    80201d42:	24a50513          	addi	a0,a0,586 # 80213f88 <user_test_table+0x708>
    80201d46:	fffff097          	auipc	ra,0xfffff
    80201d4a:	53e080e7          	jalr	1342(ra) # 80201284 <printf>
    color_cyan();   printf("青色文字 ");
    80201d4e:	00000097          	auipc	ra,0x0
    80201d52:	a00080e7          	jalr	-1536(ra) # 8020174e <color_cyan>
    80201d56:	00012517          	auipc	a0,0x12
    80201d5a:	24250513          	addi	a0,a0,578 # 80213f98 <user_test_table+0x718>
    80201d5e:	fffff097          	auipc	ra,0xfffff
    80201d62:	526080e7          	jalr	1318(ra) # 80201284 <printf>
    color_reverse();  printf("反色文字");
    80201d66:	00000097          	auipc	ra,0x0
    80201d6a:	a06080e7          	jalr	-1530(ra) # 8020176c <color_reverse>
    80201d6e:	00012517          	auipc	a0,0x12
    80201d72:	23a50513          	addi	a0,a0,570 # 80213fa8 <user_test_table+0x728>
    80201d76:	fffff097          	auipc	ra,0xfffff
    80201d7a:	50e080e7          	jalr	1294(ra) # 80201284 <printf>
    reset_color();
    80201d7e:	00000097          	auipc	ra,0x0
    80201d82:	838080e7          	jalr	-1992(ra) # 802015b6 <reset_color>
    printf("\n\n");
    80201d86:	00012517          	auipc	a0,0x12
    80201d8a:	23250513          	addi	a0,a0,562 # 80213fb8 <user_test_table+0x738>
    80201d8e:	fffff097          	auipc	ra,0xfffff
    80201d92:	4f6080e7          	jalr	1270(ra) # 80201284 <printf>
    
    // 测试背景色
    printf("背景色测试:\n");
    80201d96:	00012517          	auipc	a0,0x12
    80201d9a:	22a50513          	addi	a0,a0,554 # 80213fc0 <user_test_table+0x740>
    80201d9e:	fffff097          	auipc	ra,0xfffff
    80201da2:	4e6080e7          	jalr	1254(ra) # 80201284 <printf>
    set_bg_color(41); printf(" 红色背景 "); reset_color();
    80201da6:	02900513          	li	a0,41
    80201daa:	00000097          	auipc	ra,0x0
    80201dae:	89e080e7          	jalr	-1890(ra) # 80201648 <set_bg_color>
    80201db2:	00012517          	auipc	a0,0x12
    80201db6:	22650513          	addi	a0,a0,550 # 80213fd8 <user_test_table+0x758>
    80201dba:	fffff097          	auipc	ra,0xfffff
    80201dbe:	4ca080e7          	jalr	1226(ra) # 80201284 <printf>
    80201dc2:	fffff097          	auipc	ra,0xfffff
    80201dc6:	7f4080e7          	jalr	2036(ra) # 802015b6 <reset_color>
    set_bg_color(42); printf(" 绿色背景 "); reset_color();
    80201dca:	02a00513          	li	a0,42
    80201dce:	00000097          	auipc	ra,0x0
    80201dd2:	87a080e7          	jalr	-1926(ra) # 80201648 <set_bg_color>
    80201dd6:	00012517          	auipc	a0,0x12
    80201dda:	21250513          	addi	a0,a0,530 # 80213fe8 <user_test_table+0x768>
    80201dde:	fffff097          	auipc	ra,0xfffff
    80201de2:	4a6080e7          	jalr	1190(ra) # 80201284 <printf>
    80201de6:	fffff097          	auipc	ra,0xfffff
    80201dea:	7d0080e7          	jalr	2000(ra) # 802015b6 <reset_color>
    set_bg_color(43); printf(" 黄色背景 "); reset_color();
    80201dee:	02b00513          	li	a0,43
    80201df2:	00000097          	auipc	ra,0x0
    80201df6:	856080e7          	jalr	-1962(ra) # 80201648 <set_bg_color>
    80201dfa:	00012517          	auipc	a0,0x12
    80201dfe:	1fe50513          	addi	a0,a0,510 # 80213ff8 <user_test_table+0x778>
    80201e02:	fffff097          	auipc	ra,0xfffff
    80201e06:	482080e7          	jalr	1154(ra) # 80201284 <printf>
    80201e0a:	fffff097          	auipc	ra,0xfffff
    80201e0e:	7ac080e7          	jalr	1964(ra) # 802015b6 <reset_color>
    set_bg_color(44); printf(" 蓝色背景 "); reset_color();
    80201e12:	02c00513          	li	a0,44
    80201e16:	00000097          	auipc	ra,0x0
    80201e1a:	832080e7          	jalr	-1998(ra) # 80201648 <set_bg_color>
    80201e1e:	00012517          	auipc	a0,0x12
    80201e22:	1ea50513          	addi	a0,a0,490 # 80214008 <user_test_table+0x788>
    80201e26:	fffff097          	auipc	ra,0xfffff
    80201e2a:	45e080e7          	jalr	1118(ra) # 80201284 <printf>
    80201e2e:	fffff097          	auipc	ra,0xfffff
    80201e32:	788080e7          	jalr	1928(ra) # 802015b6 <reset_color>
	set_bg_color(47); printf(" 反色背景 "); reset_color();
    80201e36:	02f00513          	li	a0,47
    80201e3a:	00000097          	auipc	ra,0x0
    80201e3e:	80e080e7          	jalr	-2034(ra) # 80201648 <set_bg_color>
    80201e42:	00012517          	auipc	a0,0x12
    80201e46:	1d650513          	addi	a0,a0,470 # 80214018 <user_test_table+0x798>
    80201e4a:	fffff097          	auipc	ra,0xfffff
    80201e4e:	43a080e7          	jalr	1082(ra) # 80201284 <printf>
    80201e52:	fffff097          	auipc	ra,0xfffff
    80201e56:	764080e7          	jalr	1892(ra) # 802015b6 <reset_color>
    printf("\n\n");
    80201e5a:	00012517          	auipc	a0,0x12
    80201e5e:	15e50513          	addi	a0,a0,350 # 80213fb8 <user_test_table+0x738>
    80201e62:	fffff097          	auipc	ra,0xfffff
    80201e66:	422080e7          	jalr	1058(ra) # 80201284 <printf>
    
    // 测试组合效果
    printf("组合效果测试:\n");
    80201e6a:	00012517          	auipc	a0,0x12
    80201e6e:	1be50513          	addi	a0,a0,446 # 80214028 <user_test_table+0x7a8>
    80201e72:	fffff097          	auipc	ra,0xfffff
    80201e76:	412080e7          	jalr	1042(ra) # 80201284 <printf>
    set_color(31, 44); printf(" 红字蓝底 "); reset_color();
    80201e7a:	02c00593          	li	a1,44
    80201e7e:	457d                	li	a0,31
    80201e80:	00000097          	auipc	ra,0x0
    80201e84:	90a080e7          	jalr	-1782(ra) # 8020178a <set_color>
    80201e88:	00012517          	auipc	a0,0x12
    80201e8c:	1b850513          	addi	a0,a0,440 # 80214040 <user_test_table+0x7c0>
    80201e90:	fffff097          	auipc	ra,0xfffff
    80201e94:	3f4080e7          	jalr	1012(ra) # 80201284 <printf>
    80201e98:	fffff097          	auipc	ra,0xfffff
    80201e9c:	71e080e7          	jalr	1822(ra) # 802015b6 <reset_color>
    set_color(33, 45); printf(" 黄字紫底 "); reset_color();
    80201ea0:	02d00593          	li	a1,45
    80201ea4:	02100513          	li	a0,33
    80201ea8:	00000097          	auipc	ra,0x0
    80201eac:	8e2080e7          	jalr	-1822(ra) # 8020178a <set_color>
    80201eb0:	00012517          	auipc	a0,0x12
    80201eb4:	1a050513          	addi	a0,a0,416 # 80214050 <user_test_table+0x7d0>
    80201eb8:	fffff097          	auipc	ra,0xfffff
    80201ebc:	3cc080e7          	jalr	972(ra) # 80201284 <printf>
    80201ec0:	fffff097          	auipc	ra,0xfffff
    80201ec4:	6f6080e7          	jalr	1782(ra) # 802015b6 <reset_color>
    set_color(32, 47); printf(" 绿字反底 "); reset_color();
    80201ec8:	02f00593          	li	a1,47
    80201ecc:	02000513          	li	a0,32
    80201ed0:	00000097          	auipc	ra,0x0
    80201ed4:	8ba080e7          	jalr	-1862(ra) # 8020178a <set_color>
    80201ed8:	00012517          	auipc	a0,0x12
    80201edc:	18850513          	addi	a0,a0,392 # 80214060 <user_test_table+0x7e0>
    80201ee0:	fffff097          	auipc	ra,0xfffff
    80201ee4:	3a4080e7          	jalr	932(ra) # 80201284 <printf>
    80201ee8:	fffff097          	auipc	ra,0xfffff
    80201eec:	6ce080e7          	jalr	1742(ra) # 802015b6 <reset_color>
    printf("\n\n");
    80201ef0:	00012517          	auipc	a0,0x12
    80201ef4:	0c850513          	addi	a0,a0,200 # 80213fb8 <user_test_table+0x738>
    80201ef8:	fffff097          	auipc	ra,0xfffff
    80201efc:	38c080e7          	jalr	908(ra) # 80201284 <printf>
	reset_color();
    80201f00:	fffff097          	auipc	ra,0xfffff
    80201f04:	6b6080e7          	jalr	1718(ra) # 802015b6 <reset_color>
	printf("重置为默认颜色，本行文字会被清除\n"); 
    80201f08:	00012517          	auipc	a0,0x12
    80201f0c:	16850513          	addi	a0,a0,360 # 80214070 <user_test_table+0x7f0>
    80201f10:	fffff097          	auipc	ra,0xfffff
    80201f14:	374080e7          	jalr	884(ra) # 80201284 <printf>
	cursor_up(1); // 光标上移一行
    80201f18:	4505                	li	a0,1
    80201f1a:	fffff097          	auipc	ra,0xfffff
    80201f1e:	3ea080e7          	jalr	1002(ra) # 80201304 <cursor_up>
	clear_line();
    80201f22:	00000097          	auipc	ra,0x0
    80201f26:	8a4080e7          	jalr	-1884(ra) # 802017c6 <clear_line>

	printf("=== 颜色测试结束 ===\n");
    80201f2a:	00012517          	auipc	a0,0x12
    80201f2e:	17e50513          	addi	a0,a0,382 # 802140a8 <user_test_table+0x828>
    80201f32:	fffff097          	auipc	ra,0xfffff
    80201f36:	352080e7          	jalr	850(ra) # 80201284 <printf>
    80201f3a:	0001                	nop
    80201f3c:	60a2                	ld	ra,8(sp)
    80201f3e:	6402                	ld	s0,0(sp)
    80201f40:	0141                	addi	sp,sp,16
    80201f42:	8082                	ret

0000000080201f44 <memset>:
#include "defs.h"
// 自行实现memset
void *memset(void *dst, int c, unsigned long n) {
    80201f44:	7139                	addi	sp,sp,-64
    80201f46:	fc22                	sd	s0,56(sp)
    80201f48:	0080                	addi	s0,sp,64
    80201f4a:	fca43c23          	sd	a0,-40(s0)
    80201f4e:	87ae                	mv	a5,a1
    80201f50:	fcc43423          	sd	a2,-56(s0)
    80201f54:	fcf42a23          	sw	a5,-44(s0)
    unsigned char *p = dst;
    80201f58:	fd843783          	ld	a5,-40(s0)
    80201f5c:	fef43423          	sd	a5,-24(s0)
    while (n-- > 0)
    80201f60:	a829                	j	80201f7a <memset+0x36>
        *p++ = (unsigned char)c;
    80201f62:	fe843783          	ld	a5,-24(s0)
    80201f66:	00178713          	addi	a4,a5,1
    80201f6a:	fee43423          	sd	a4,-24(s0)
    80201f6e:	fd442703          	lw	a4,-44(s0)
    80201f72:	0ff77713          	zext.b	a4,a4
    80201f76:	00e78023          	sb	a4,0(a5)
    while (n-- > 0)
    80201f7a:	fc843783          	ld	a5,-56(s0)
    80201f7e:	fff78713          	addi	a4,a5,-1
    80201f82:	fce43423          	sd	a4,-56(s0)
    80201f86:	fff1                	bnez	a5,80201f62 <memset+0x1e>
    return dst;
    80201f88:	fd843783          	ld	a5,-40(s0)
}
    80201f8c:	853e                	mv	a0,a5
    80201f8e:	7462                	ld	s0,56(sp)
    80201f90:	6121                	addi	sp,sp,64
    80201f92:	8082                	ret

0000000080201f94 <memmove>:
void *memmove(void *dst, const void *src, unsigned long n) {
    80201f94:	7139                	addi	sp,sp,-64
    80201f96:	fc22                	sd	s0,56(sp)
    80201f98:	0080                	addi	s0,sp,64
    80201f9a:	fca43c23          	sd	a0,-40(s0)
    80201f9e:	fcb43823          	sd	a1,-48(s0)
    80201fa2:	fcc43423          	sd	a2,-56(s0)
	unsigned char *d = dst;
    80201fa6:	fd843783          	ld	a5,-40(s0)
    80201faa:	fef43423          	sd	a5,-24(s0)
	const unsigned char *s = src;
    80201fae:	fd043783          	ld	a5,-48(s0)
    80201fb2:	fef43023          	sd	a5,-32(s0)
	if (d < s) {
    80201fb6:	fe843703          	ld	a4,-24(s0)
    80201fba:	fe043783          	ld	a5,-32(s0)
    80201fbe:	02f77b63          	bgeu	a4,a5,80201ff4 <memmove+0x60>
		while (n-- > 0)
    80201fc2:	a00d                	j	80201fe4 <memmove+0x50>
			*d++ = *s++;
    80201fc4:	fe043703          	ld	a4,-32(s0)
    80201fc8:	00170793          	addi	a5,a4,1
    80201fcc:	fef43023          	sd	a5,-32(s0)
    80201fd0:	fe843783          	ld	a5,-24(s0)
    80201fd4:	00178693          	addi	a3,a5,1
    80201fd8:	fed43423          	sd	a3,-24(s0)
    80201fdc:	00074703          	lbu	a4,0(a4)
    80201fe0:	00e78023          	sb	a4,0(a5)
		while (n-- > 0)
    80201fe4:	fc843783          	ld	a5,-56(s0)
    80201fe8:	fff78713          	addi	a4,a5,-1
    80201fec:	fce43423          	sd	a4,-56(s0)
    80201ff0:	fbf1                	bnez	a5,80201fc4 <memmove+0x30>
    80201ff2:	a889                	j	80202044 <memmove+0xb0>
	} else {
		d += n;
    80201ff4:	fe843703          	ld	a4,-24(s0)
    80201ff8:	fc843783          	ld	a5,-56(s0)
    80201ffc:	97ba                	add	a5,a5,a4
    80201ffe:	fef43423          	sd	a5,-24(s0)
		s += n;
    80202002:	fe043703          	ld	a4,-32(s0)
    80202006:	fc843783          	ld	a5,-56(s0)
    8020200a:	97ba                	add	a5,a5,a4
    8020200c:	fef43023          	sd	a5,-32(s0)
		while (n-- > 0)
    80202010:	a01d                	j	80202036 <memmove+0xa2>
			*(--d) = *(--s);
    80202012:	fe043783          	ld	a5,-32(s0)
    80202016:	17fd                	addi	a5,a5,-1
    80202018:	fef43023          	sd	a5,-32(s0)
    8020201c:	fe843783          	ld	a5,-24(s0)
    80202020:	17fd                	addi	a5,a5,-1
    80202022:	fef43423          	sd	a5,-24(s0)
    80202026:	fe043783          	ld	a5,-32(s0)
    8020202a:	0007c703          	lbu	a4,0(a5)
    8020202e:	fe843783          	ld	a5,-24(s0)
    80202032:	00e78023          	sb	a4,0(a5)
		while (n-- > 0)
    80202036:	fc843783          	ld	a5,-56(s0)
    8020203a:	fff78713          	addi	a4,a5,-1
    8020203e:	fce43423          	sd	a4,-56(s0)
    80202042:	fbe1                	bnez	a5,80202012 <memmove+0x7e>
	}
	return dst;
    80202044:	fd843783          	ld	a5,-40(s0)
}
    80202048:	853e                	mv	a0,a5
    8020204a:	7462                	ld	s0,56(sp)
    8020204c:	6121                	addi	sp,sp,64
    8020204e:	8082                	ret

0000000080202050 <memcpy>:
void *memcpy(void *dst, const void *src, size_t n) {
    80202050:	715d                	addi	sp,sp,-80
    80202052:	e4a2                	sd	s0,72(sp)
    80202054:	0880                	addi	s0,sp,80
    80202056:	fca43423          	sd	a0,-56(s0)
    8020205a:	fcb43023          	sd	a1,-64(s0)
    8020205e:	fac43c23          	sd	a2,-72(s0)
    char *d = dst;
    80202062:	fc843783          	ld	a5,-56(s0)
    80202066:	fef43023          	sd	a5,-32(s0)
    const char *s = src;
    8020206a:	fc043783          	ld	a5,-64(s0)
    8020206e:	fcf43c23          	sd	a5,-40(s0)
    for (size_t i = 0; i < n; i++) {
    80202072:	fe043423          	sd	zero,-24(s0)
    80202076:	a025                	j	8020209e <memcpy+0x4e>
        d[i] = s[i];
    80202078:	fd843703          	ld	a4,-40(s0)
    8020207c:	fe843783          	ld	a5,-24(s0)
    80202080:	973e                	add	a4,a4,a5
    80202082:	fe043683          	ld	a3,-32(s0)
    80202086:	fe843783          	ld	a5,-24(s0)
    8020208a:	97b6                	add	a5,a5,a3
    8020208c:	00074703          	lbu	a4,0(a4)
    80202090:	00e78023          	sb	a4,0(a5)
    for (size_t i = 0; i < n; i++) {
    80202094:	fe843783          	ld	a5,-24(s0)
    80202098:	0785                	addi	a5,a5,1
    8020209a:	fef43423          	sd	a5,-24(s0)
    8020209e:	fe843703          	ld	a4,-24(s0)
    802020a2:	fb843783          	ld	a5,-72(s0)
    802020a6:	fcf769e3          	bltu	a4,a5,80202078 <memcpy+0x28>
    }
    return dst;
    802020aa:	fc843783          	ld	a5,-56(s0)
    802020ae:	853e                	mv	a0,a5
    802020b0:	6426                	ld	s0,72(sp)
    802020b2:	6161                	addi	sp,sp,80
    802020b4:	8082                	ret

00000000802020b6 <assert>:
    802020b6:	1101                	addi	sp,sp,-32
    802020b8:	ec06                	sd	ra,24(sp)
    802020ba:	e822                	sd	s0,16(sp)
    802020bc:	1000                	addi	s0,sp,32
    802020be:	87aa                	mv	a5,a0
    802020c0:	fef42623          	sw	a5,-20(s0)
    802020c4:	fec42783          	lw	a5,-20(s0)
    802020c8:	2781                	sext.w	a5,a5
    802020ca:	e79d                	bnez	a5,802020f8 <assert+0x42>
    802020cc:	33c00613          	li	a2,828
    802020d0:	00016597          	auipc	a1,0x16
    802020d4:	15858593          	addi	a1,a1,344 # 80218228 <user_test_table+0x78>
    802020d8:	00016517          	auipc	a0,0x16
    802020dc:	16050513          	addi	a0,a0,352 # 80218238 <user_test_table+0x88>
    802020e0:	fffff097          	auipc	ra,0xfffff
    802020e4:	1a4080e7          	jalr	420(ra) # 80201284 <printf>
    802020e8:	00016517          	auipc	a0,0x16
    802020ec:	17850513          	addi	a0,a0,376 # 80218260 <user_test_table+0xb0>
    802020f0:	fffff097          	auipc	ra,0xfffff
    802020f4:	716080e7          	jalr	1814(ra) # 80201806 <panic>
    802020f8:	0001                	nop
    802020fa:	60e2                	ld	ra,24(sp)
    802020fc:	6442                	ld	s0,16(sp)
    802020fe:	6105                	addi	sp,sp,32
    80202100:	8082                	ret

0000000080202102 <sv39_sign_extend>:
    80202102:	1101                	addi	sp,sp,-32
    80202104:	ec22                	sd	s0,24(sp)
    80202106:	1000                	addi	s0,sp,32
    80202108:	fea43423          	sd	a0,-24(s0)
    8020210c:	fe843703          	ld	a4,-24(s0)
    80202110:	4785                	li	a5,1
    80202112:	179a                	slli	a5,a5,0x26
    80202114:	8ff9                	and	a5,a5,a4
    80202116:	c799                	beqz	a5,80202124 <sv39_sign_extend+0x22>
    80202118:	fe843703          	ld	a4,-24(s0)
    8020211c:	57fd                	li	a5,-1
    8020211e:	179e                	slli	a5,a5,0x27
    80202120:	8fd9                	or	a5,a5,a4
    80202122:	a031                	j	8020212e <sv39_sign_extend+0x2c>
    80202124:	fe843703          	ld	a4,-24(s0)
    80202128:	57fd                	li	a5,-1
    8020212a:	83e5                	srli	a5,a5,0x19
    8020212c:	8ff9                	and	a5,a5,a4
    8020212e:	853e                	mv	a0,a5
    80202130:	6462                	ld	s0,24(sp)
    80202132:	6105                	addi	sp,sp,32
    80202134:	8082                	ret

0000000080202136 <sv39_check_valid>:
    80202136:	1101                	addi	sp,sp,-32
    80202138:	ec22                	sd	s0,24(sp)
    8020213a:	1000                	addi	s0,sp,32
    8020213c:	fea43423          	sd	a0,-24(s0)
    80202140:	fe843703          	ld	a4,-24(s0)
    80202144:	57fd                	li	a5,-1
    80202146:	83e5                	srli	a5,a5,0x19
    80202148:	00e7f863          	bgeu	a5,a4,80202158 <sv39_check_valid+0x22>
    8020214c:	fe843703          	ld	a4,-24(s0)
    80202150:	57fd                	li	a5,-1
    80202152:	179e                	slli	a5,a5,0x27
    80202154:	00f76463          	bltu	a4,a5,8020215c <sv39_check_valid+0x26>
    80202158:	4785                	li	a5,1
    8020215a:	a011                	j	8020215e <sv39_check_valid+0x28>
    8020215c:	4781                	li	a5,0
    8020215e:	853e                	mv	a0,a5
    80202160:	6462                	ld	s0,24(sp)
    80202162:	6105                	addi	sp,sp,32
    80202164:	8082                	ret

0000000080202166 <px>:
static inline uint64 px(int level, uint64 va) {
    80202166:	1101                	addi	sp,sp,-32
    80202168:	ec22                	sd	s0,24(sp)
    8020216a:	1000                	addi	s0,sp,32
    8020216c:	87aa                	mv	a5,a0
    8020216e:	feb43023          	sd	a1,-32(s0)
    80202172:	fef42623          	sw	a5,-20(s0)
    return VPN_MASK(va, level);
    80202176:	fec42783          	lw	a5,-20(s0)
    8020217a:	873e                	mv	a4,a5
    8020217c:	87ba                	mv	a5,a4
    8020217e:	0037979b          	slliw	a5,a5,0x3
    80202182:	9fb9                	addw	a5,a5,a4
    80202184:	2781                	sext.w	a5,a5
    80202186:	27b1                	addiw	a5,a5,12
    80202188:	2781                	sext.w	a5,a5
    8020218a:	873e                	mv	a4,a5
    8020218c:	fe043783          	ld	a5,-32(s0)
    80202190:	00e7d7b3          	srl	a5,a5,a4
    80202194:	1ff7f793          	andi	a5,a5,511
}
    80202198:	853e                	mv	a0,a5
    8020219a:	6462                	ld	s0,24(sp)
    8020219c:	6105                	addi	sp,sp,32
    8020219e:	8082                	ret

00000000802021a0 <create_pagetable>:
pagetable_t create_pagetable(void) {
    802021a0:	1101                	addi	sp,sp,-32
    802021a2:	ec06                	sd	ra,24(sp)
    802021a4:	e822                	sd	s0,16(sp)
    802021a6:	1000                	addi	s0,sp,32
    pagetable_t pt = (pagetable_t)alloc_page();
    802021a8:	00001097          	auipc	ra,0x1
    802021ac:	1b4080e7          	jalr	436(ra) # 8020335c <alloc_page>
    802021b0:	fea43423          	sd	a0,-24(s0)
    if (!pt)
    802021b4:	fe843783          	ld	a5,-24(s0)
    802021b8:	e399                	bnez	a5,802021be <create_pagetable+0x1e>
        return 0;
    802021ba:	4781                	li	a5,0
    802021bc:	a819                	j	802021d2 <create_pagetable+0x32>
    memset(pt, 0, PGSIZE);
    802021be:	6605                	lui	a2,0x1
    802021c0:	4581                	li	a1,0
    802021c2:	fe843503          	ld	a0,-24(s0)
    802021c6:	00000097          	auipc	ra,0x0
    802021ca:	d7e080e7          	jalr	-642(ra) # 80201f44 <memset>
    return pt;
    802021ce:	fe843783          	ld	a5,-24(s0)
}
    802021d2:	853e                	mv	a0,a5
    802021d4:	60e2                	ld	ra,24(sp)
    802021d6:	6442                	ld	s0,16(sp)
    802021d8:	6105                	addi	sp,sp,32
    802021da:	8082                	ret

00000000802021dc <walk_lookup>:
pte_t* walk_lookup(pagetable_t pt, uint64 va) {
    802021dc:	7139                	addi	sp,sp,-64
    802021de:	fc06                	sd	ra,56(sp)
    802021e0:	f822                	sd	s0,48(sp)
    802021e2:	0080                	addi	s0,sp,64
    802021e4:	fca43423          	sd	a0,-56(s0)
    802021e8:	fcb43023          	sd	a1,-64(s0)
	va = sv39_sign_extend(va);
    802021ec:	fc043503          	ld	a0,-64(s0)
    802021f0:	00000097          	auipc	ra,0x0
    802021f4:	f12080e7          	jalr	-238(ra) # 80202102 <sv39_sign_extend>
    802021f8:	fca43023          	sd	a0,-64(s0)
	if (!sv39_check_valid(va))
    802021fc:	fc043503          	ld	a0,-64(s0)
    80202200:	00000097          	auipc	ra,0x0
    80202204:	f36080e7          	jalr	-202(ra) # 80202136 <sv39_check_valid>
    80202208:	87aa                	mv	a5,a0
    8020220a:	eb89                	bnez	a5,8020221c <walk_lookup+0x40>
		panic("va out of sv39 range");
    8020220c:	00016517          	auipc	a0,0x16
    80202210:	05c50513          	addi	a0,a0,92 # 80218268 <user_test_table+0xb8>
    80202214:	fffff097          	auipc	ra,0xfffff
    80202218:	5f2080e7          	jalr	1522(ra) # 80201806 <panic>
    for (int level = 2; level > 0; level--) {
    8020221c:	4789                	li	a5,2
    8020221e:	fef42623          	sw	a5,-20(s0)
    80202222:	a0e9                	j	802022ec <walk_lookup+0x110>
        pte_t *pte = &pt[px(level, va)];
    80202224:	fec42783          	lw	a5,-20(s0)
    80202228:	fc043583          	ld	a1,-64(s0)
    8020222c:	853e                	mv	a0,a5
    8020222e:	00000097          	auipc	ra,0x0
    80202232:	f38080e7          	jalr	-200(ra) # 80202166 <px>
    80202236:	87aa                	mv	a5,a0
    80202238:	078e                	slli	a5,a5,0x3
    8020223a:	fc843703          	ld	a4,-56(s0)
    8020223e:	97ba                	add	a5,a5,a4
    80202240:	fef43023          	sd	a5,-32(s0)
        if (!pte) {
    80202244:	fe043783          	ld	a5,-32(s0)
    80202248:	ef91                	bnez	a5,80202264 <walk_lookup+0x88>
            printf("[WALK_LOOKUP] pte is NULL at level %d\n", level);
    8020224a:	fec42783          	lw	a5,-20(s0)
    8020224e:	85be                	mv	a1,a5
    80202250:	00016517          	auipc	a0,0x16
    80202254:	03050513          	addi	a0,a0,48 # 80218280 <user_test_table+0xd0>
    80202258:	fffff097          	auipc	ra,0xfffff
    8020225c:	02c080e7          	jalr	44(ra) # 80201284 <printf>
            return 0;
    80202260:	4781                	li	a5,0
    80202262:	a075                	j	8020230e <walk_lookup+0x132>
        if (*pte & PTE_V) {
    80202264:	fe043783          	ld	a5,-32(s0)
    80202268:	639c                	ld	a5,0(a5)
    8020226a:	8b85                	andi	a5,a5,1
    8020226c:	cfa1                	beqz	a5,802022c4 <walk_lookup+0xe8>
            uint64 pa = PTE2PA(*pte);
    8020226e:	fe043783          	ld	a5,-32(s0)
    80202272:	639c                	ld	a5,0(a5)
    80202274:	83a9                	srli	a5,a5,0xa
    80202276:	07b2                	slli	a5,a5,0xc
    80202278:	fcf43c23          	sd	a5,-40(s0)
            if (pa < KERNBASE || pa >= PHYSTOP) {
    8020227c:	fd843703          	ld	a4,-40(s0)
    80202280:	800007b7          	lui	a5,0x80000
    80202284:	fff7c793          	not	a5,a5
    80202288:	00e7f863          	bgeu	a5,a4,80202298 <walk_lookup+0xbc>
    8020228c:	fd843703          	ld	a4,-40(s0)
    80202290:	47c5                	li	a5,17
    80202292:	07ee                	slli	a5,a5,0x1b
    80202294:	02f76363          	bltu	a4,a5,802022ba <walk_lookup+0xde>
                printf("[WALK_LOOKUP] 非法页表物理地址: 0x%lx (level %d, va=0x%lx)\n", pa, level, va);
    80202298:	fec42783          	lw	a5,-20(s0)
    8020229c:	fc043683          	ld	a3,-64(s0)
    802022a0:	863e                	mv	a2,a5
    802022a2:	fd843583          	ld	a1,-40(s0)
    802022a6:	00016517          	auipc	a0,0x16
    802022aa:	00250513          	addi	a0,a0,2 # 802182a8 <user_test_table+0xf8>
    802022ae:	fffff097          	auipc	ra,0xfffff
    802022b2:	fd6080e7          	jalr	-42(ra) # 80201284 <printf>
                return 0;
    802022b6:	4781                	li	a5,0
    802022b8:	a899                	j	8020230e <walk_lookup+0x132>
            pt = (pagetable_t)pa;
    802022ba:	fd843783          	ld	a5,-40(s0)
    802022be:	fcf43423          	sd	a5,-56(s0)
    802022c2:	a005                	j	802022e2 <walk_lookup+0x106>
            printf("[WALK_LOOKUP] 页表项无效: level=%d va=0x%lx\n", level, va);
    802022c4:	fec42783          	lw	a5,-20(s0)
    802022c8:	fc043603          	ld	a2,-64(s0)
    802022cc:	85be                	mv	a1,a5
    802022ce:	00016517          	auipc	a0,0x16
    802022d2:	02250513          	addi	a0,a0,34 # 802182f0 <user_test_table+0x140>
    802022d6:	fffff097          	auipc	ra,0xfffff
    802022da:	fae080e7          	jalr	-82(ra) # 80201284 <printf>
            return 0;
    802022de:	4781                	li	a5,0
    802022e0:	a03d                	j	8020230e <walk_lookup+0x132>
    for (int level = 2; level > 0; level--) {
    802022e2:	fec42783          	lw	a5,-20(s0)
    802022e6:	37fd                	addiw	a5,a5,-1 # 7fffffff <_entry-0x200001>
    802022e8:	fef42623          	sw	a5,-20(s0)
    802022ec:	fec42783          	lw	a5,-20(s0)
    802022f0:	2781                	sext.w	a5,a5
    802022f2:	f2f049e3          	bgtz	a5,80202224 <walk_lookup+0x48>
    return &pt[px(0, va)];
    802022f6:	fc043583          	ld	a1,-64(s0)
    802022fa:	4501                	li	a0,0
    802022fc:	00000097          	auipc	ra,0x0
    80202300:	e6a080e7          	jalr	-406(ra) # 80202166 <px>
    80202304:	87aa                	mv	a5,a0
    80202306:	078e                	slli	a5,a5,0x3
    80202308:	fc843703          	ld	a4,-56(s0)
    8020230c:	97ba                	add	a5,a5,a4
}
    8020230e:	853e                	mv	a0,a5
    80202310:	70e2                	ld	ra,56(sp)
    80202312:	7442                	ld	s0,48(sp)
    80202314:	6121                	addi	sp,sp,64
    80202316:	8082                	ret

0000000080202318 <walk_create>:
static pte_t* walk_create(pagetable_t pt, uint64 va) {
    80202318:	7139                	addi	sp,sp,-64
    8020231a:	fc06                	sd	ra,56(sp)
    8020231c:	f822                	sd	s0,48(sp)
    8020231e:	0080                	addi	s0,sp,64
    80202320:	fca43423          	sd	a0,-56(s0)
    80202324:	fcb43023          	sd	a1,-64(s0)
	va = sv39_sign_extend(va);
    80202328:	fc043503          	ld	a0,-64(s0)
    8020232c:	00000097          	auipc	ra,0x0
    80202330:	dd6080e7          	jalr	-554(ra) # 80202102 <sv39_sign_extend>
    80202334:	fca43023          	sd	a0,-64(s0)
	if (!sv39_check_valid(va))
    80202338:	fc043503          	ld	a0,-64(s0)
    8020233c:	00000097          	auipc	ra,0x0
    80202340:	dfa080e7          	jalr	-518(ra) # 80202136 <sv39_check_valid>
    80202344:	87aa                	mv	a5,a0
    80202346:	eb89                	bnez	a5,80202358 <walk_create+0x40>
		panic("va out of sv39 range");
    80202348:	00016517          	auipc	a0,0x16
    8020234c:	f2050513          	addi	a0,a0,-224 # 80218268 <user_test_table+0xb8>
    80202350:	fffff097          	auipc	ra,0xfffff
    80202354:	4b6080e7          	jalr	1206(ra) # 80201806 <panic>
    for (int level = 2; level > 0; level--) {
    80202358:	4789                	li	a5,2
    8020235a:	fef42623          	sw	a5,-20(s0)
    8020235e:	a059                	j	802023e4 <walk_create+0xcc>
        pte_t *pte = &pt[px(level, va)];
    80202360:	fec42783          	lw	a5,-20(s0)
    80202364:	fc043583          	ld	a1,-64(s0)
    80202368:	853e                	mv	a0,a5
    8020236a:	00000097          	auipc	ra,0x0
    8020236e:	dfc080e7          	jalr	-516(ra) # 80202166 <px>
    80202372:	87aa                	mv	a5,a0
    80202374:	078e                	slli	a5,a5,0x3
    80202376:	fc843703          	ld	a4,-56(s0)
    8020237a:	97ba                	add	a5,a5,a4
    8020237c:	fef43023          	sd	a5,-32(s0)
        if (*pte & PTE_V) {
    80202380:	fe043783          	ld	a5,-32(s0)
    80202384:	639c                	ld	a5,0(a5)
    80202386:	8b85                	andi	a5,a5,1
    80202388:	cb89                	beqz	a5,8020239a <walk_create+0x82>
            pt = (pagetable_t)PTE2PA(*pte);
    8020238a:	fe043783          	ld	a5,-32(s0)
    8020238e:	639c                	ld	a5,0(a5)
    80202390:	83a9                	srli	a5,a5,0xa
    80202392:	07b2                	slli	a5,a5,0xc
    80202394:	fcf43423          	sd	a5,-56(s0)
    80202398:	a089                	j	802023da <walk_create+0xc2>
            pagetable_t new_pt = (pagetable_t)alloc_page();
    8020239a:	00001097          	auipc	ra,0x1
    8020239e:	fc2080e7          	jalr	-62(ra) # 8020335c <alloc_page>
    802023a2:	fca43c23          	sd	a0,-40(s0)
            if (!new_pt)
    802023a6:	fd843783          	ld	a5,-40(s0)
    802023aa:	e399                	bnez	a5,802023b0 <walk_create+0x98>
                return 0;
    802023ac:	4781                	li	a5,0
    802023ae:	a8a1                	j	80202406 <walk_create+0xee>
            memset(new_pt, 0, PGSIZE);
    802023b0:	6605                	lui	a2,0x1
    802023b2:	4581                	li	a1,0
    802023b4:	fd843503          	ld	a0,-40(s0)
    802023b8:	00000097          	auipc	ra,0x0
    802023bc:	b8c080e7          	jalr	-1140(ra) # 80201f44 <memset>
            *pte = PA2PTE(new_pt) | PTE_V;
    802023c0:	fd843783          	ld	a5,-40(s0)
    802023c4:	83b1                	srli	a5,a5,0xc
    802023c6:	07aa                	slli	a5,a5,0xa
    802023c8:	0017e713          	ori	a4,a5,1
    802023cc:	fe043783          	ld	a5,-32(s0)
    802023d0:	e398                	sd	a4,0(a5)
            pt = new_pt;
    802023d2:	fd843783          	ld	a5,-40(s0)
    802023d6:	fcf43423          	sd	a5,-56(s0)
    for (int level = 2; level > 0; level--) {
    802023da:	fec42783          	lw	a5,-20(s0)
    802023de:	37fd                	addiw	a5,a5,-1
    802023e0:	fef42623          	sw	a5,-20(s0)
    802023e4:	fec42783          	lw	a5,-20(s0)
    802023e8:	2781                	sext.w	a5,a5
    802023ea:	f6f04be3          	bgtz	a5,80202360 <walk_create+0x48>
    return &pt[px(0, va)];
    802023ee:	fc043583          	ld	a1,-64(s0)
    802023f2:	4501                	li	a0,0
    802023f4:	00000097          	auipc	ra,0x0
    802023f8:	d72080e7          	jalr	-654(ra) # 80202166 <px>
    802023fc:	87aa                	mv	a5,a0
    802023fe:	078e                	slli	a5,a5,0x3
    80202400:	fc843703          	ld	a4,-56(s0)
    80202404:	97ba                	add	a5,a5,a4
}
    80202406:	853e                	mv	a0,a5
    80202408:	70e2                	ld	ra,56(sp)
    8020240a:	7442                	ld	s0,48(sp)
    8020240c:	6121                	addi	sp,sp,64
    8020240e:	8082                	ret

0000000080202410 <map_page>:
int map_page(pagetable_t pt, uint64 va, uint64 pa, int perm) {
    80202410:	715d                	addi	sp,sp,-80
    80202412:	e486                	sd	ra,72(sp)
    80202414:	e0a2                	sd	s0,64(sp)
    80202416:	0880                	addi	s0,sp,80
    80202418:	fca43423          	sd	a0,-56(s0)
    8020241c:	fcb43023          	sd	a1,-64(s0)
    80202420:	fac43c23          	sd	a2,-72(s0)
    80202424:	87b6                	mv	a5,a3
    80202426:	faf42a23          	sw	a5,-76(s0)
    struct proc *p = myproc();
    8020242a:	00003097          	auipc	ra,0x3
    8020242e:	c36080e7          	jalr	-970(ra) # 80205060 <myproc>
    80202432:	fea43023          	sd	a0,-32(s0)
	if (p && p->is_user && va >= 0x80000000
    80202436:	fe043783          	ld	a5,-32(s0)
    8020243a:	c7a9                	beqz	a5,80202484 <map_page+0x74>
    8020243c:	fe043783          	ld	a5,-32(s0)
    80202440:	0a87a783          	lw	a5,168(a5)
    80202444:	c3a1                	beqz	a5,80202484 <map_page+0x74>
    80202446:	fc043703          	ld	a4,-64(s0)
    8020244a:	800007b7          	lui	a5,0x80000
    8020244e:	fff7c793          	not	a5,a5
    80202452:	02e7f963          	bgeu	a5,a4,80202484 <map_page+0x74>
		&& va != TRAMPOLINE
    80202456:	fc043703          	ld	a4,-64(s0)
    8020245a:	77fd                	lui	a5,0xfffff
    8020245c:	02f70463          	beq	a4,a5,80202484 <map_page+0x74>
		&& va != TRAPFRAME) {
    80202460:	fc043703          	ld	a4,-64(s0)
    80202464:	77f9                	lui	a5,0xffffe
    80202466:	00f70f63          	beq	a4,a5,80202484 <map_page+0x74>
		warning("map_page: 用户进程禁止映射内核空间");
    8020246a:	00016517          	auipc	a0,0x16
    8020246e:	ebe50513          	addi	a0,a0,-322 # 80218328 <user_test_table+0x178>
    80202472:	fffff097          	auipc	ra,0xfffff
    80202476:	3c8080e7          	jalr	968(ra) # 8020183a <warning>
		exit_proc(-1);
    8020247a:	557d                	li	a0,-1
    8020247c:	00004097          	auipc	ra,0x4
    80202480:	aa0080e7          	jalr	-1376(ra) # 80205f1c <exit_proc>
    if ((va % PGSIZE) != 0)
    80202484:	fc043703          	ld	a4,-64(s0)
    80202488:	6785                	lui	a5,0x1
    8020248a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    8020248c:	8ff9                	and	a5,a5,a4
    8020248e:	cb89                	beqz	a5,802024a0 <map_page+0x90>
        panic("map_page: va not aligned");
    80202490:	00016517          	auipc	a0,0x16
    80202494:	ec850513          	addi	a0,a0,-312 # 80218358 <user_test_table+0x1a8>
    80202498:	fffff097          	auipc	ra,0xfffff
    8020249c:	36e080e7          	jalr	878(ra) # 80201806 <panic>
    pte_t *pte = walk_create(pt, va);
    802024a0:	fc043583          	ld	a1,-64(s0)
    802024a4:	fc843503          	ld	a0,-56(s0)
    802024a8:	00000097          	auipc	ra,0x0
    802024ac:	e70080e7          	jalr	-400(ra) # 80202318 <walk_create>
    802024b0:	fca43c23          	sd	a0,-40(s0)
    if (!pte)
    802024b4:	fd843783          	ld	a5,-40(s0)
    802024b8:	e399                	bnez	a5,802024be <map_page+0xae>
        return -1;
    802024ba:	57fd                	li	a5,-1
    802024bc:	a87d                	j	8020257a <map_page+0x16a>
    if (va >= 0x80000000)
    802024be:	fc043703          	ld	a4,-64(s0)
    802024c2:	800007b7          	lui	a5,0x80000
    802024c6:	fff7c793          	not	a5,a5
    802024ca:	00e7f763          	bgeu	a5,a4,802024d8 <map_page+0xc8>
        perm &= ~PTE_U;
    802024ce:	fb442783          	lw	a5,-76(s0)
    802024d2:	9bbd                	andi	a5,a5,-17
    802024d4:	faf42a23          	sw	a5,-76(s0)
    if (*pte & PTE_V) {
    802024d8:	fd843783          	ld	a5,-40(s0)
    802024dc:	639c                	ld	a5,0(a5)
    802024de:	8b85                	andi	a5,a5,1
    802024e0:	cfbd                	beqz	a5,8020255e <map_page+0x14e>
        if (PTE2PA(*pte) == pa) {
    802024e2:	fd843783          	ld	a5,-40(s0)
    802024e6:	639c                	ld	a5,0(a5)
    802024e8:	83a9                	srli	a5,a5,0xa
    802024ea:	07b2                	slli	a5,a5,0xc
    802024ec:	fb843703          	ld	a4,-72(s0)
    802024f0:	04f71f63          	bne	a4,a5,8020254e <map_page+0x13e>
            int new_perm = (PTE_FLAGS(*pte) | perm) & 0x3FF;
    802024f4:	fd843783          	ld	a5,-40(s0)
    802024f8:	639c                	ld	a5,0(a5)
    802024fa:	2781                	sext.w	a5,a5
    802024fc:	3ff7f793          	andi	a5,a5,1023
    80202500:	0007871b          	sext.w	a4,a5
    80202504:	fb442783          	lw	a5,-76(s0)
    80202508:	8fd9                	or	a5,a5,a4
    8020250a:	2781                	sext.w	a5,a5
    8020250c:	2781                	sext.w	a5,a5
    8020250e:	3ff7f793          	andi	a5,a5,1023
    80202512:	fef42623          	sw	a5,-20(s0)
            if (va >= 0x80000000)
    80202516:	fc043703          	ld	a4,-64(s0)
    8020251a:	800007b7          	lui	a5,0x80000
    8020251e:	fff7c793          	not	a5,a5
    80202522:	00e7f763          	bgeu	a5,a4,80202530 <map_page+0x120>
                new_perm &= ~PTE_U;
    80202526:	fec42783          	lw	a5,-20(s0)
    8020252a:	9bbd                	andi	a5,a5,-17
    8020252c:	fef42623          	sw	a5,-20(s0)
            *pte = PA2PTE(pa) | new_perm | PTE_V;
    80202530:	fb843783          	ld	a5,-72(s0)
    80202534:	83b1                	srli	a5,a5,0xc
    80202536:	00a79713          	slli	a4,a5,0xa
    8020253a:	fec42783          	lw	a5,-20(s0)
    8020253e:	8fd9                	or	a5,a5,a4
    80202540:	0017e713          	ori	a4,a5,1
    80202544:	fd843783          	ld	a5,-40(s0)
    80202548:	e398                	sd	a4,0(a5)
            return 0;
    8020254a:	4781                	li	a5,0
    8020254c:	a03d                	j	8020257a <map_page+0x16a>
            panic("map_page: remap to different physical address");
    8020254e:	00016517          	auipc	a0,0x16
    80202552:	e2a50513          	addi	a0,a0,-470 # 80218378 <user_test_table+0x1c8>
    80202556:	fffff097          	auipc	ra,0xfffff
    8020255a:	2b0080e7          	jalr	688(ra) # 80201806 <panic>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8020255e:	fb843783          	ld	a5,-72(s0)
    80202562:	83b1                	srli	a5,a5,0xc
    80202564:	00a79713          	slli	a4,a5,0xa
    80202568:	fb442783          	lw	a5,-76(s0)
    8020256c:	8fd9                	or	a5,a5,a4
    8020256e:	0017e713          	ori	a4,a5,1
    80202572:	fd843783          	ld	a5,-40(s0)
    80202576:	e398                	sd	a4,0(a5)
    return 0;
    80202578:	4781                	li	a5,0
}
    8020257a:	853e                	mv	a0,a5
    8020257c:	60a6                	ld	ra,72(sp)
    8020257e:	6406                	ld	s0,64(sp)
    80202580:	6161                	addi	sp,sp,80
    80202582:	8082                	ret

0000000080202584 <free_pagetable>:
void free_pagetable(pagetable_t pt) {
    80202584:	7139                	addi	sp,sp,-64
    80202586:	fc06                	sd	ra,56(sp)
    80202588:	f822                	sd	s0,48(sp)
    8020258a:	0080                	addi	s0,sp,64
    8020258c:	fca43423          	sd	a0,-56(s0)
    for (int i = 0; i < 512; i++) {
    80202590:	fe042623          	sw	zero,-20(s0)
    80202594:	a8a5                	j	8020260c <free_pagetable+0x88>
        pte_t pte = pt[i];
    80202596:	fec42783          	lw	a5,-20(s0)
    8020259a:	078e                	slli	a5,a5,0x3
    8020259c:	fc843703          	ld	a4,-56(s0)
    802025a0:	97ba                	add	a5,a5,a4
    802025a2:	639c                	ld	a5,0(a5)
    802025a4:	fef43023          	sd	a5,-32(s0)
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    802025a8:	fe043783          	ld	a5,-32(s0)
    802025ac:	8b85                	andi	a5,a5,1
    802025ae:	cb95                	beqz	a5,802025e2 <free_pagetable+0x5e>
    802025b0:	fe043783          	ld	a5,-32(s0)
    802025b4:	8bb9                	andi	a5,a5,14
    802025b6:	e795                	bnez	a5,802025e2 <free_pagetable+0x5e>
            pagetable_t child = (pagetable_t)PTE2PA(pte);
    802025b8:	fe043783          	ld	a5,-32(s0)
    802025bc:	83a9                	srli	a5,a5,0xa
    802025be:	07b2                	slli	a5,a5,0xc
    802025c0:	fcf43c23          	sd	a5,-40(s0)
            free_pagetable(child);
    802025c4:	fd843503          	ld	a0,-40(s0)
    802025c8:	00000097          	auipc	ra,0x0
    802025cc:	fbc080e7          	jalr	-68(ra) # 80202584 <free_pagetable>
            pt[i] = 0;
    802025d0:	fec42783          	lw	a5,-20(s0)
    802025d4:	078e                	slli	a5,a5,0x3
    802025d6:	fc843703          	ld	a4,-56(s0)
    802025da:	97ba                	add	a5,a5,a4
    802025dc:	0007b023          	sd	zero,0(a5) # ffffffff80000000 <_bss_end+0xfffffffeffdb76d0>
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    802025e0:	a00d                	j	80202602 <free_pagetable+0x7e>
        } else if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X))) {
    802025e2:	fe043783          	ld	a5,-32(s0)
    802025e6:	8b85                	andi	a5,a5,1
    802025e8:	cf89                	beqz	a5,80202602 <free_pagetable+0x7e>
    802025ea:	fe043783          	ld	a5,-32(s0)
    802025ee:	8bb9                	andi	a5,a5,14
    802025f0:	cb89                	beqz	a5,80202602 <free_pagetable+0x7e>
            pt[i] = 0;
    802025f2:	fec42783          	lw	a5,-20(s0)
    802025f6:	078e                	slli	a5,a5,0x3
    802025f8:	fc843703          	ld	a4,-56(s0)
    802025fc:	97ba                	add	a5,a5,a4
    802025fe:	0007b023          	sd	zero,0(a5)
    for (int i = 0; i < 512; i++) {
    80202602:	fec42783          	lw	a5,-20(s0)
    80202606:	2785                	addiw	a5,a5,1
    80202608:	fef42623          	sw	a5,-20(s0)
    8020260c:	fec42783          	lw	a5,-20(s0)
    80202610:	0007871b          	sext.w	a4,a5
    80202614:	1ff00793          	li	a5,511
    80202618:	f6e7dfe3          	bge	a5,a4,80202596 <free_pagetable+0x12>
    free_page(pt);
    8020261c:	fc843503          	ld	a0,-56(s0)
    80202620:	00001097          	auipc	ra,0x1
    80202624:	da8080e7          	jalr	-600(ra) # 802033c8 <free_page>
}
    80202628:	0001                	nop
    8020262a:	70e2                	ld	ra,56(sp)
    8020262c:	7442                	ld	s0,48(sp)
    8020262e:	6121                	addi	sp,sp,64
    80202630:	8082                	ret

0000000080202632 <kvmmake>:
static pagetable_t kvmmake(void) {
    80202632:	715d                	addi	sp,sp,-80
    80202634:	e486                	sd	ra,72(sp)
    80202636:	e0a2                	sd	s0,64(sp)
    80202638:	0880                	addi	s0,sp,80
    pagetable_t kpgtbl = create_pagetable();
    8020263a:	00000097          	auipc	ra,0x0
    8020263e:	b66080e7          	jalr	-1178(ra) # 802021a0 <create_pagetable>
    80202642:	fca43423          	sd	a0,-56(s0)
    if (!kpgtbl){
    80202646:	fc843783          	ld	a5,-56(s0)
    8020264a:	eb89                	bnez	a5,8020265c <kvmmake+0x2a>
        panic("kvmmake: alloc failed");
    8020264c:	00016517          	auipc	a0,0x16
    80202650:	d5c50513          	addi	a0,a0,-676 # 802183a8 <user_test_table+0x1f8>
    80202654:	fffff097          	auipc	ra,0xfffff
    80202658:	1b2080e7          	jalr	434(ra) # 80201806 <panic>
	for (uint64 pa = KERNBASE; pa < PHYSTOP; pa += PGSIZE) {
    8020265c:	4785                	li	a5,1
    8020265e:	07fe                	slli	a5,a5,0x1f
    80202660:	fef43423          	sd	a5,-24(s0)
    80202664:	a8a1                	j	802026bc <kvmmake+0x8a>
        int perm = PTE_R | PTE_W;
    80202666:	4799                	li	a5,6
    80202668:	fef42223          	sw	a5,-28(s0)
        if (pa < (uint64)etext)
    8020266c:	0000b797          	auipc	a5,0xb
    80202670:	99478793          	addi	a5,a5,-1644 # 8020d000 <etext>
    80202674:	fe843703          	ld	a4,-24(s0)
    80202678:	00f77563          	bgeu	a4,a5,80202682 <kvmmake+0x50>
            perm = PTE_R | PTE_X;
    8020267c:	47a9                	li	a5,10
    8020267e:	fef42223          	sw	a5,-28(s0)
        if (map_page(kpgtbl, pa, pa, perm) != 0)
    80202682:	fe442783          	lw	a5,-28(s0)
    80202686:	86be                	mv	a3,a5
    80202688:	fe843603          	ld	a2,-24(s0)
    8020268c:	fe843583          	ld	a1,-24(s0)
    80202690:	fc843503          	ld	a0,-56(s0)
    80202694:	00000097          	auipc	ra,0x0
    80202698:	d7c080e7          	jalr	-644(ra) # 80202410 <map_page>
    8020269c:	87aa                	mv	a5,a0
    8020269e:	cb89                	beqz	a5,802026b0 <kvmmake+0x7e>
            panic("kvmmake: heap map failed");
    802026a0:	00016517          	auipc	a0,0x16
    802026a4:	d2050513          	addi	a0,a0,-736 # 802183c0 <user_test_table+0x210>
    802026a8:	fffff097          	auipc	ra,0xfffff
    802026ac:	15e080e7          	jalr	350(ra) # 80201806 <panic>
	for (uint64 pa = KERNBASE; pa < PHYSTOP; pa += PGSIZE) {
    802026b0:	fe843703          	ld	a4,-24(s0)
    802026b4:	6785                	lui	a5,0x1
    802026b6:	97ba                	add	a5,a5,a4
    802026b8:	fef43423          	sd	a5,-24(s0)
    802026bc:	fe843703          	ld	a4,-24(s0)
    802026c0:	47c5                	li	a5,17
    802026c2:	07ee                	slli	a5,a5,0x1b
    802026c4:	faf761e3          	bltu	a4,a5,80202666 <kvmmake+0x34>
    if (map_page(kpgtbl, UART0, UART0, PTE_R | PTE_W) != 0)
    802026c8:	4699                	li	a3,6
    802026ca:	10000637          	lui	a2,0x10000
    802026ce:	100005b7          	lui	a1,0x10000
    802026d2:	fc843503          	ld	a0,-56(s0)
    802026d6:	00000097          	auipc	ra,0x0
    802026da:	d3a080e7          	jalr	-710(ra) # 80202410 <map_page>
    802026de:	87aa                	mv	a5,a0
    802026e0:	cb89                	beqz	a5,802026f2 <kvmmake+0xc0>
        panic("kvmmake: uart map failed");
    802026e2:	00016517          	auipc	a0,0x16
    802026e6:	cfe50513          	addi	a0,a0,-770 # 802183e0 <user_test_table+0x230>
    802026ea:	fffff097          	auipc	ra,0xfffff
    802026ee:	11c080e7          	jalr	284(ra) # 80201806 <panic>
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    802026f2:	0c0007b7          	lui	a5,0xc000
    802026f6:	fcf43c23          	sd	a5,-40(s0)
    802026fa:	a825                	j	80202732 <kvmmake+0x100>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    802026fc:	4699                	li	a3,6
    802026fe:	fd843603          	ld	a2,-40(s0)
    80202702:	fd843583          	ld	a1,-40(s0)
    80202706:	fc843503          	ld	a0,-56(s0)
    8020270a:	00000097          	auipc	ra,0x0
    8020270e:	d06080e7          	jalr	-762(ra) # 80202410 <map_page>
    80202712:	87aa                	mv	a5,a0
    80202714:	cb89                	beqz	a5,80202726 <kvmmake+0xf4>
            panic("kvmmake: plic map failed");
    80202716:	00016517          	auipc	a0,0x16
    8020271a:	cea50513          	addi	a0,a0,-790 # 80218400 <user_test_table+0x250>
    8020271e:	fffff097          	auipc	ra,0xfffff
    80202722:	0e8080e7          	jalr	232(ra) # 80201806 <panic>
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    80202726:	fd843703          	ld	a4,-40(s0)
    8020272a:	6785                	lui	a5,0x1
    8020272c:	97ba                	add	a5,a5,a4
    8020272e:	fcf43c23          	sd	a5,-40(s0)
    80202732:	fd843703          	ld	a4,-40(s0)
    80202736:	0c4007b7          	lui	a5,0xc400
    8020273a:	fcf761e3          	bltu	a4,a5,802026fc <kvmmake+0xca>
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    8020273e:	020007b7          	lui	a5,0x2000
    80202742:	fcf43823          	sd	a5,-48(s0)
    80202746:	a825                	j	8020277e <kvmmake+0x14c>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80202748:	4699                	li	a3,6
    8020274a:	fd043603          	ld	a2,-48(s0)
    8020274e:	fd043583          	ld	a1,-48(s0)
    80202752:	fc843503          	ld	a0,-56(s0)
    80202756:	00000097          	auipc	ra,0x0
    8020275a:	cba080e7          	jalr	-838(ra) # 80202410 <map_page>
    8020275e:	87aa                	mv	a5,a0
    80202760:	cb89                	beqz	a5,80202772 <kvmmake+0x140>
            panic("kvmmake: clint map failed");
    80202762:	00016517          	auipc	a0,0x16
    80202766:	cbe50513          	addi	a0,a0,-834 # 80218420 <user_test_table+0x270>
    8020276a:	fffff097          	auipc	ra,0xfffff
    8020276e:	09c080e7          	jalr	156(ra) # 80201806 <panic>
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    80202772:	fd043703          	ld	a4,-48(s0)
    80202776:	6785                	lui	a5,0x1
    80202778:	97ba                	add	a5,a5,a4
    8020277a:	fcf43823          	sd	a5,-48(s0)
    8020277e:	fd043703          	ld	a4,-48(s0)
    80202782:	020107b7          	lui	a5,0x2010
    80202786:	fcf761e3          	bltu	a4,a5,80202748 <kvmmake+0x116>
    if (map_page(kpgtbl, VIRTIO0, VIRTIO0, PTE_R | PTE_W) != 0)
    8020278a:	4699                	li	a3,6
    8020278c:	10001637          	lui	a2,0x10001
    80202790:	100015b7          	lui	a1,0x10001
    80202794:	fc843503          	ld	a0,-56(s0)
    80202798:	00000097          	auipc	ra,0x0
    8020279c:	c78080e7          	jalr	-904(ra) # 80202410 <map_page>
    802027a0:	87aa                	mv	a5,a0
    802027a2:	cb89                	beqz	a5,802027b4 <kvmmake+0x182>
        panic("kvmmake: virtio map failed");
    802027a4:	00016517          	auipc	a0,0x16
    802027a8:	c9c50513          	addi	a0,a0,-868 # 80218440 <user_test_table+0x290>
    802027ac:	fffff097          	auipc	ra,0xfffff
    802027b0:	05a080e7          	jalr	90(ra) # 80201806 <panic>
	void *tramp_phys = alloc_page();
    802027b4:	00001097          	auipc	ra,0x1
    802027b8:	ba8080e7          	jalr	-1112(ra) # 8020335c <alloc_page>
    802027bc:	fca43023          	sd	a0,-64(s0)
	if (!tramp_phys)
    802027c0:	fc043783          	ld	a5,-64(s0)
    802027c4:	eb89                	bnez	a5,802027d6 <kvmmake+0x1a4>
		panic("kvmmake: alloc trampoline page failed");
    802027c6:	00016517          	auipc	a0,0x16
    802027ca:	c9a50513          	addi	a0,a0,-870 # 80218460 <user_test_table+0x2b0>
    802027ce:	fffff097          	auipc	ra,0xfffff
    802027d2:	038080e7          	jalr	56(ra) # 80201806 <panic>
	memcpy(tramp_phys, trampoline, PGSIZE);
    802027d6:	6605                	lui	a2,0x1
    802027d8:	00002597          	auipc	a1,0x2
    802027dc:	5c858593          	addi	a1,a1,1480 # 80204da0 <trampoline>
    802027e0:	fc043503          	ld	a0,-64(s0)
    802027e4:	00000097          	auipc	ra,0x0
    802027e8:	86c080e7          	jalr	-1940(ra) # 80202050 <memcpy>
	void *trapframe_phys = alloc_page();
    802027ec:	00001097          	auipc	ra,0x1
    802027f0:	b70080e7          	jalr	-1168(ra) # 8020335c <alloc_page>
    802027f4:	faa43c23          	sd	a0,-72(s0)
	if (!trapframe_phys)
    802027f8:	fb843783          	ld	a5,-72(s0)
    802027fc:	eb89                	bnez	a5,8020280e <kvmmake+0x1dc>
		panic("kvmmake: alloc trapframe page failed");
    802027fe:	00016517          	auipc	a0,0x16
    80202802:	c8a50513          	addi	a0,a0,-886 # 80218488 <user_test_table+0x2d8>
    80202806:	fffff097          	auipc	ra,0xfffff
    8020280a:	000080e7          	jalr	ra # 80201806 <panic>
	memset(trapframe_phys, 0, PGSIZE);
    8020280e:	6605                	lui	a2,0x1
    80202810:	4581                	li	a1,0
    80202812:	fb843503          	ld	a0,-72(s0)
    80202816:	fffff097          	auipc	ra,0xfffff
    8020281a:	72e080e7          	jalr	1838(ra) # 80201f44 <memset>
	if (map_page(kpgtbl, TRAMPOLINE, (uint64)tramp_phys, PTE_R | PTE_X) != 0){
    8020281e:	fc043783          	ld	a5,-64(s0)
    80202822:	46a9                	li	a3,10
    80202824:	863e                	mv	a2,a5
    80202826:	75fd                	lui	a1,0xfffff
    80202828:	fc843503          	ld	a0,-56(s0)
    8020282c:	00000097          	auipc	ra,0x0
    80202830:	be4080e7          	jalr	-1052(ra) # 80202410 <map_page>
    80202834:	87aa                	mv	a5,a0
    80202836:	cb89                	beqz	a5,80202848 <kvmmake+0x216>
		panic("kvmmake: trampoline map failed");
    80202838:	00016517          	auipc	a0,0x16
    8020283c:	c7850513          	addi	a0,a0,-904 # 802184b0 <user_test_table+0x300>
    80202840:	fffff097          	auipc	ra,0xfffff
    80202844:	fc6080e7          	jalr	-58(ra) # 80201806 <panic>
	if (map_page(kpgtbl, TRAPFRAME, (uint64)trapframe_phys, PTE_R | PTE_W) != 0){
    80202848:	fb843783          	ld	a5,-72(s0)
    8020284c:	4699                	li	a3,6
    8020284e:	863e                	mv	a2,a5
    80202850:	75f9                	lui	a1,0xffffe
    80202852:	fc843503          	ld	a0,-56(s0)
    80202856:	00000097          	auipc	ra,0x0
    8020285a:	bba080e7          	jalr	-1094(ra) # 80202410 <map_page>
    8020285e:	87aa                	mv	a5,a0
    80202860:	cb89                	beqz	a5,80202872 <kvmmake+0x240>
		panic("kvmmake: trapframe map failed");
    80202862:	00016517          	auipc	a0,0x16
    80202866:	c6e50513          	addi	a0,a0,-914 # 802184d0 <user_test_table+0x320>
    8020286a:	fffff097          	auipc	ra,0xfffff
    8020286e:	f9c080e7          	jalr	-100(ra) # 80201806 <panic>
	trampoline_phys_addr = (uint64)tramp_phys;
    80202872:	fc043703          	ld	a4,-64(s0)
    80202876:	0003b797          	auipc	a5,0x3b
    8020287a:	84278793          	addi	a5,a5,-1982 # 8023d0b8 <trampoline_phys_addr>
    8020287e:	e398                	sd	a4,0(a5)
	trapframe_phys_addr = (uint64)trapframe_phys;
    80202880:	fb843703          	ld	a4,-72(s0)
    80202884:	0003b797          	auipc	a5,0x3b
    80202888:	83c78793          	addi	a5,a5,-1988 # 8023d0c0 <trapframe_phys_addr>
    8020288c:	e398                	sd	a4,0(a5)
	printf("trampoline_phy_addr = %lx\n",trampoline_phys_addr);
    8020288e:	0003b797          	auipc	a5,0x3b
    80202892:	82a78793          	addi	a5,a5,-2006 # 8023d0b8 <trampoline_phys_addr>
    80202896:	639c                	ld	a5,0(a5)
    80202898:	85be                	mv	a1,a5
    8020289a:	00016517          	auipc	a0,0x16
    8020289e:	c5650513          	addi	a0,a0,-938 # 802184f0 <user_test_table+0x340>
    802028a2:	fffff097          	auipc	ra,0xfffff
    802028a6:	9e2080e7          	jalr	-1566(ra) # 80201284 <printf>
	printf("trapframe_phys_addr = %lx\n",trapframe_phys_addr);
    802028aa:	0003b797          	auipc	a5,0x3b
    802028ae:	81678793          	addi	a5,a5,-2026 # 8023d0c0 <trapframe_phys_addr>
    802028b2:	639c                	ld	a5,0(a5)
    802028b4:	85be                	mv	a1,a5
    802028b6:	00016517          	auipc	a0,0x16
    802028ba:	c5a50513          	addi	a0,a0,-934 # 80218510 <user_test_table+0x360>
    802028be:	fffff097          	auipc	ra,0xfffff
    802028c2:	9c6080e7          	jalr	-1594(ra) # 80201284 <printf>
    return kpgtbl;
    802028c6:	fc843783          	ld	a5,-56(s0)
}
    802028ca:	853e                	mv	a0,a5
    802028cc:	60a6                	ld	ra,72(sp)
    802028ce:	6406                	ld	s0,64(sp)
    802028d0:	6161                	addi	sp,sp,80
    802028d2:	8082                	ret

00000000802028d4 <w_satp>:
static inline void w_satp(uint64 x) {
    802028d4:	1101                	addi	sp,sp,-32
    802028d6:	ec22                	sd	s0,24(sp)
    802028d8:	1000                	addi	s0,sp,32
    802028da:	fea43423          	sd	a0,-24(s0)
    asm volatile("csrw satp, %0" : : "r"(x));
    802028de:	fe843783          	ld	a5,-24(s0)
    802028e2:	18079073          	csrw	satp,a5
}
    802028e6:	0001                	nop
    802028e8:	6462                	ld	s0,24(sp)
    802028ea:	6105                	addi	sp,sp,32
    802028ec:	8082                	ret

00000000802028ee <sfence_vma>:
inline void sfence_vma(void) {
    802028ee:	1141                	addi	sp,sp,-16
    802028f0:	e422                	sd	s0,8(sp)
    802028f2:	0800                	addi	s0,sp,16
    asm volatile("sfence.vma zero, zero");
    802028f4:	12000073          	sfence.vma
}
    802028f8:	0001                	nop
    802028fa:	6422                	ld	s0,8(sp)
    802028fc:	0141                	addi	sp,sp,16
    802028fe:	8082                	ret

0000000080202900 <kvminit>:
void kvminit(void) {
    80202900:	1141                	addi	sp,sp,-16
    80202902:	e406                	sd	ra,8(sp)
    80202904:	e022                	sd	s0,0(sp)
    80202906:	0800                	addi	s0,sp,16
    kernel_pagetable = kvmmake();
    80202908:	00000097          	auipc	ra,0x0
    8020290c:	d2a080e7          	jalr	-726(ra) # 80202632 <kvmmake>
    80202910:	872a                	mv	a4,a0
    80202912:	0003a797          	auipc	a5,0x3a
    80202916:	79e78793          	addi	a5,a5,1950 # 8023d0b0 <kernel_pagetable>
    8020291a:	e398                	sd	a4,0(a5)
    sfence_vma();
    8020291c:	00000097          	auipc	ra,0x0
    80202920:	fd2080e7          	jalr	-46(ra) # 802028ee <sfence_vma>
    w_satp(MAKE_SATP(kernel_pagetable));
    80202924:	0003a797          	auipc	a5,0x3a
    80202928:	78c78793          	addi	a5,a5,1932 # 8023d0b0 <kernel_pagetable>
    8020292c:	639c                	ld	a5,0(a5)
    8020292e:	00c7d713          	srli	a4,a5,0xc
    80202932:	57fd                	li	a5,-1
    80202934:	17fe                	slli	a5,a5,0x3f
    80202936:	8fd9                	or	a5,a5,a4
    80202938:	853e                	mv	a0,a5
    8020293a:	00000097          	auipc	ra,0x0
    8020293e:	f9a080e7          	jalr	-102(ra) # 802028d4 <w_satp>
    sfence_vma();
    80202942:	00000097          	auipc	ra,0x0
    80202946:	fac080e7          	jalr	-84(ra) # 802028ee <sfence_vma>
    printf("[KVM] 内核分页已启用，satp=0x%lx\n", MAKE_SATP(kernel_pagetable));
    8020294a:	0003a797          	auipc	a5,0x3a
    8020294e:	76678793          	addi	a5,a5,1894 # 8023d0b0 <kernel_pagetable>
    80202952:	639c                	ld	a5,0(a5)
    80202954:	00c7d713          	srli	a4,a5,0xc
    80202958:	57fd                	li	a5,-1
    8020295a:	17fe                	slli	a5,a5,0x3f
    8020295c:	8fd9                	or	a5,a5,a4
    8020295e:	85be                	mv	a1,a5
    80202960:	00016517          	auipc	a0,0x16
    80202964:	bd050513          	addi	a0,a0,-1072 # 80218530 <user_test_table+0x380>
    80202968:	fffff097          	auipc	ra,0xfffff
    8020296c:	91c080e7          	jalr	-1764(ra) # 80201284 <printf>
}
    80202970:	0001                	nop
    80202972:	60a2                	ld	ra,8(sp)
    80202974:	6402                	ld	s0,0(sp)
    80202976:	0141                	addi	sp,sp,16
    80202978:	8082                	ret

000000008020297a <get_current_pagetable>:
pagetable_t get_current_pagetable(void) {
    8020297a:	1141                	addi	sp,sp,-16
    8020297c:	e422                	sd	s0,8(sp)
    8020297e:	0800                	addi	s0,sp,16
    return kernel_pagetable;  // 在没有进程时返回内核页表
    80202980:	0003a797          	auipc	a5,0x3a
    80202984:	73078793          	addi	a5,a5,1840 # 8023d0b0 <kernel_pagetable>
    80202988:	639c                	ld	a5,0(a5)
}
    8020298a:	853e                	mv	a0,a5
    8020298c:	6422                	ld	s0,8(sp)
    8020298e:	0141                	addi	sp,sp,16
    80202990:	8082                	ret

0000000080202992 <print_pagetable>:
void print_pagetable(pagetable_t pagetable, int level, uint64 va_base) {
    80202992:	715d                	addi	sp,sp,-80
    80202994:	e486                	sd	ra,72(sp)
    80202996:	e0a2                	sd	s0,64(sp)
    80202998:	0880                	addi	s0,sp,80
    8020299a:	fca43423          	sd	a0,-56(s0)
    8020299e:	87ae                	mv	a5,a1
    802029a0:	fac43c23          	sd	a2,-72(s0)
    802029a4:	fcf42223          	sw	a5,-60(s0)
    for (int i = 0; i < 512; i++) {
    802029a8:	fe042623          	sw	zero,-20(s0)
    802029ac:	a0c5                	j	80202a8c <print_pagetable+0xfa>
        pte_t pte = pagetable[i];
    802029ae:	fec42783          	lw	a5,-20(s0)
    802029b2:	078e                	slli	a5,a5,0x3
    802029b4:	fc843703          	ld	a4,-56(s0)
    802029b8:	97ba                	add	a5,a5,a4
    802029ba:	639c                	ld	a5,0(a5)
    802029bc:	fef43023          	sd	a5,-32(s0)
        if (pte & PTE_V) {
    802029c0:	fe043783          	ld	a5,-32(s0)
    802029c4:	8b85                	andi	a5,a5,1
    802029c6:	cfd5                	beqz	a5,80202a82 <print_pagetable+0xf0>
            uint64 pa = PTE2PA(pte);
    802029c8:	fe043783          	ld	a5,-32(s0)
    802029cc:	83a9                	srli	a5,a5,0xa
    802029ce:	07b2                	slli	a5,a5,0xc
    802029d0:	fcf43c23          	sd	a5,-40(s0)
            uint64 va = va_base + (i << (12 + 9 * (2 - level)));
    802029d4:	4789                	li	a5,2
    802029d6:	fc442703          	lw	a4,-60(s0)
    802029da:	9f99                	subw	a5,a5,a4
    802029dc:	2781                	sext.w	a5,a5
    802029de:	873e                	mv	a4,a5
    802029e0:	87ba                	mv	a5,a4
    802029e2:	0037979b          	slliw	a5,a5,0x3
    802029e6:	9fb9                	addw	a5,a5,a4
    802029e8:	2781                	sext.w	a5,a5
    802029ea:	27b1                	addiw	a5,a5,12
    802029ec:	2781                	sext.w	a5,a5
    802029ee:	fec42703          	lw	a4,-20(s0)
    802029f2:	00f717bb          	sllw	a5,a4,a5
    802029f6:	2781                	sext.w	a5,a5
    802029f8:	873e                	mv	a4,a5
    802029fa:	fb843783          	ld	a5,-72(s0)
    802029fe:	97ba                	add	a5,a5,a4
    80202a00:	fcf43823          	sd	a5,-48(s0)
            for (int l = 0; l < level; l++) printf("  "); // 缩进
    80202a04:	fe042423          	sw	zero,-24(s0)
    80202a08:	a831                	j	80202a24 <print_pagetable+0x92>
    80202a0a:	00016517          	auipc	a0,0x16
    80202a0e:	b5650513          	addi	a0,a0,-1194 # 80218560 <user_test_table+0x3b0>
    80202a12:	fffff097          	auipc	ra,0xfffff
    80202a16:	872080e7          	jalr	-1934(ra) # 80201284 <printf>
    80202a1a:	fe842783          	lw	a5,-24(s0)
    80202a1e:	2785                	addiw	a5,a5,1
    80202a20:	fef42423          	sw	a5,-24(s0)
    80202a24:	fe842783          	lw	a5,-24(s0)
    80202a28:	873e                	mv	a4,a5
    80202a2a:	fc442783          	lw	a5,-60(s0)
    80202a2e:	2701                	sext.w	a4,a4
    80202a30:	2781                	sext.w	a5,a5
    80202a32:	fcf74ce3          	blt	a4,a5,80202a0a <print_pagetable+0x78>
            printf("L%d[%3d] VA:0x%lx -> PA:0x%lx flags:0x%lx\n", level, i, va, pa, pte & 0x3FF);
    80202a36:	fe043783          	ld	a5,-32(s0)
    80202a3a:	3ff7f793          	andi	a5,a5,1023
    80202a3e:	fec42603          	lw	a2,-20(s0)
    80202a42:	fc442583          	lw	a1,-60(s0)
    80202a46:	fd843703          	ld	a4,-40(s0)
    80202a4a:	fd043683          	ld	a3,-48(s0)
    80202a4e:	00016517          	auipc	a0,0x16
    80202a52:	b1a50513          	addi	a0,a0,-1254 # 80218568 <user_test_table+0x3b8>
    80202a56:	fffff097          	auipc	ra,0xfffff
    80202a5a:	82e080e7          	jalr	-2002(ra) # 80201284 <printf>
            if ((pte & (PTE_R | PTE_W | PTE_X)) == 0) { // 不是叶子
    80202a5e:	fe043783          	ld	a5,-32(s0)
    80202a62:	8bb9                	andi	a5,a5,14
    80202a64:	ef99                	bnez	a5,80202a82 <print_pagetable+0xf0>
                print_pagetable((pagetable_t)pa, level + 1, va);
    80202a66:	fd843783          	ld	a5,-40(s0)
    80202a6a:	fc442703          	lw	a4,-60(s0)
    80202a6e:	2705                	addiw	a4,a4,1
    80202a70:	2701                	sext.w	a4,a4
    80202a72:	fd043603          	ld	a2,-48(s0)
    80202a76:	85ba                	mv	a1,a4
    80202a78:	853e                	mv	a0,a5
    80202a7a:	00000097          	auipc	ra,0x0
    80202a7e:	f18080e7          	jalr	-232(ra) # 80202992 <print_pagetable>
    for (int i = 0; i < 512; i++) {
    80202a82:	fec42783          	lw	a5,-20(s0)
    80202a86:	2785                	addiw	a5,a5,1
    80202a88:	fef42623          	sw	a5,-20(s0)
    80202a8c:	fec42783          	lw	a5,-20(s0)
    80202a90:	0007871b          	sext.w	a4,a5
    80202a94:	1ff00793          	li	a5,511
    80202a98:	f0e7dbe3          	bge	a5,a4,802029ae <print_pagetable+0x1c>
}
    80202a9c:	0001                	nop
    80202a9e:	0001                	nop
    80202aa0:	60a6                	ld	ra,72(sp)
    80202aa2:	6406                	ld	s0,64(sp)
    80202aa4:	6161                	addi	sp,sp,80
    80202aa6:	8082                	ret

0000000080202aa8 <handle_page_fault>:
int handle_page_fault(uint64 va, int type) {
    80202aa8:	715d                	addi	sp,sp,-80
    80202aaa:	e486                	sd	ra,72(sp)
    80202aac:	e0a2                	sd	s0,64(sp)
    80202aae:	0880                	addi	s0,sp,80
    80202ab0:	faa43c23          	sd	a0,-72(s0)
    80202ab4:	87ae                	mv	a5,a1
    80202ab6:	faf42a23          	sw	a5,-76(s0)
    printf("[PAGE FAULT] 处理地址 0x%lx, 类型 %d\n", va, type);
    80202aba:	fb442783          	lw	a5,-76(s0)
    80202abe:	863e                	mv	a2,a5
    80202ac0:	fb843583          	ld	a1,-72(s0)
    80202ac4:	00016517          	auipc	a0,0x16
    80202ac8:	ad450513          	addi	a0,a0,-1324 # 80218598 <user_test_table+0x3e8>
    80202acc:	ffffe097          	auipc	ra,0xffffe
    80202ad0:	7b8080e7          	jalr	1976(ra) # 80201284 <printf>
    uint64 page_va = (va / PGSIZE) * PGSIZE;
    80202ad4:	fb843703          	ld	a4,-72(s0)
    80202ad8:	77fd                	lui	a5,0xfffff
    80202ada:	8ff9                	and	a5,a5,a4
    80202adc:	fcf43c23          	sd	a5,-40(s0)
    if (page_va >= MAXVA) {
    80202ae0:	fd843703          	ld	a4,-40(s0)
    80202ae4:	57fd                	li	a5,-1
    80202ae6:	83e5                	srli	a5,a5,0x19
    80202ae8:	00e7fc63          	bgeu	a5,a4,80202b00 <handle_page_fault+0x58>
        printf("[PAGE FAULT] 虚拟地址超出范围\n");
    80202aec:	00016517          	auipc	a0,0x16
    80202af0:	adc50513          	addi	a0,a0,-1316 # 802185c8 <user_test_table+0x418>
    80202af4:	ffffe097          	auipc	ra,0xffffe
    80202af8:	790080e7          	jalr	1936(ra) # 80201284 <printf>
        return 0;
    80202afc:	4781                	li	a5,0
    80202afe:	a2ed                	j	80202ce8 <handle_page_fault+0x240>
    struct proc *p = myproc();
    80202b00:	00002097          	auipc	ra,0x2
    80202b04:	560080e7          	jalr	1376(ra) # 80205060 <myproc>
    80202b08:	fca43823          	sd	a0,-48(s0)
    pagetable_t pt = kernel_pagetable;
    80202b0c:	0003a797          	auipc	a5,0x3a
    80202b10:	5a478793          	addi	a5,a5,1444 # 8023d0b0 <kernel_pagetable>
    80202b14:	639c                	ld	a5,0(a5)
    80202b16:	fef43423          	sd	a5,-24(s0)
    if (p && p->pagetable && p->is_user) {
    80202b1a:	fd043783          	ld	a5,-48(s0)
    80202b1e:	cf99                	beqz	a5,80202b3c <handle_page_fault+0x94>
    80202b20:	fd043783          	ld	a5,-48(s0)
    80202b24:	7fdc                	ld	a5,184(a5)
    80202b26:	cb99                	beqz	a5,80202b3c <handle_page_fault+0x94>
    80202b28:	fd043783          	ld	a5,-48(s0)
    80202b2c:	0a87a783          	lw	a5,168(a5)
    80202b30:	c791                	beqz	a5,80202b3c <handle_page_fault+0x94>
        pt = p->pagetable;
    80202b32:	fd043783          	ld	a5,-48(s0)
    80202b36:	7fdc                	ld	a5,184(a5)
    80202b38:	fef43423          	sd	a5,-24(s0)
    pte_t *pte = walk_lookup(pt, page_va);
    80202b3c:	fd843583          	ld	a1,-40(s0)
    80202b40:	fe843503          	ld	a0,-24(s0)
    80202b44:	fffff097          	auipc	ra,0xfffff
    80202b48:	698080e7          	jalr	1688(ra) # 802021dc <walk_lookup>
    80202b4c:	fca43423          	sd	a0,-56(s0)
    if (pte && (*pte & PTE_V)) {
    80202b50:	fc843783          	ld	a5,-56(s0)
    80202b54:	cbdd                	beqz	a5,80202c0a <handle_page_fault+0x162>
    80202b56:	fc843783          	ld	a5,-56(s0)
    80202b5a:	639c                	ld	a5,0(a5)
    80202b5c:	8b85                	andi	a5,a5,1
    80202b5e:	c7d5                	beqz	a5,80202c0a <handle_page_fault+0x162>
        int need_perm = 0;
    80202b60:	fe042223          	sw	zero,-28(s0)
        if (type == 1) need_perm = PTE_X;
    80202b64:	fb442783          	lw	a5,-76(s0)
    80202b68:	0007871b          	sext.w	a4,a5
    80202b6c:	4785                	li	a5,1
    80202b6e:	00f71663          	bne	a4,a5,80202b7a <handle_page_fault+0xd2>
    80202b72:	47a1                	li	a5,8
    80202b74:	fef42223          	sw	a5,-28(s0)
    80202b78:	a035                	j	80202ba4 <handle_page_fault+0xfc>
        else if (type == 2) need_perm = PTE_R;
    80202b7a:	fb442783          	lw	a5,-76(s0)
    80202b7e:	0007871b          	sext.w	a4,a5
    80202b82:	4789                	li	a5,2
    80202b84:	00f71663          	bne	a4,a5,80202b90 <handle_page_fault+0xe8>
    80202b88:	4789                	li	a5,2
    80202b8a:	fef42223          	sw	a5,-28(s0)
    80202b8e:	a819                	j	80202ba4 <handle_page_fault+0xfc>
        else if (type == 3) need_perm = PTE_R | PTE_W;
    80202b90:	fb442783          	lw	a5,-76(s0)
    80202b94:	0007871b          	sext.w	a4,a5
    80202b98:	478d                	li	a5,3
    80202b9a:	00f71563          	bne	a4,a5,80202ba4 <handle_page_fault+0xfc>
    80202b9e:	4799                	li	a5,6
    80202ba0:	fef42223          	sw	a5,-28(s0)
        if ((*pte & need_perm) != need_perm) {
    80202ba4:	fc843783          	ld	a5,-56(s0)
    80202ba8:	6398                	ld	a4,0(a5)
    80202baa:	fe442783          	lw	a5,-28(s0)
    80202bae:	8f7d                	and	a4,a4,a5
    80202bb0:	fe442783          	lw	a5,-28(s0)
    80202bb4:	02f70963          	beq	a4,a5,80202be6 <handle_page_fault+0x13e>
            *pte |= need_perm;
    80202bb8:	fc843783          	ld	a5,-56(s0)
    80202bbc:	6398                	ld	a4,0(a5)
    80202bbe:	fe442783          	lw	a5,-28(s0)
    80202bc2:	8f5d                	or	a4,a4,a5
    80202bc4:	fc843783          	ld	a5,-56(s0)
    80202bc8:	e398                	sd	a4,0(a5)
            sfence_vma();
    80202bca:	00000097          	auipc	ra,0x0
    80202bce:	d24080e7          	jalr	-732(ra) # 802028ee <sfence_vma>
            printf("[PAGE FAULT] 已更新页面权限\n");
    80202bd2:	00016517          	auipc	a0,0x16
    80202bd6:	a1e50513          	addi	a0,a0,-1506 # 802185f0 <user_test_table+0x440>
    80202bda:	ffffe097          	auipc	ra,0xffffe
    80202bde:	6aa080e7          	jalr	1706(ra) # 80201284 <printf>
            return 1;
    80202be2:	4785                	li	a5,1
    80202be4:	a211                	j	80202ce8 <handle_page_fault+0x240>
        printf("[PAGE FAULT] 页面已映射且权限正确\n");
    80202be6:	00016517          	auipc	a0,0x16
    80202bea:	a3250513          	addi	a0,a0,-1486 # 80218618 <user_test_table+0x468>
    80202bee:	ffffe097          	auipc	ra,0xffffe
    80202bf2:	696080e7          	jalr	1686(ra) # 80201284 <printf>
		panic("debug");
    80202bf6:	00016517          	auipc	a0,0x16
    80202bfa:	a5250513          	addi	a0,a0,-1454 # 80218648 <user_test_table+0x498>
    80202bfe:	fffff097          	auipc	ra,0xfffff
    80202c02:	c08080e7          	jalr	-1016(ra) # 80201806 <panic>
        return 1;
    80202c06:	4785                	li	a5,1
    80202c08:	a0c5                	j	80202ce8 <handle_page_fault+0x240>
    void* page = alloc_page();
    80202c0a:	00000097          	auipc	ra,0x0
    80202c0e:	752080e7          	jalr	1874(ra) # 8020335c <alloc_page>
    80202c12:	fca43023          	sd	a0,-64(s0)
    if (page == 0) {
    80202c16:	fc043783          	ld	a5,-64(s0)
    80202c1a:	eb99                	bnez	a5,80202c30 <handle_page_fault+0x188>
        printf("[PAGE FAULT] 内存不足，无法分配页面\n");
    80202c1c:	00016517          	auipc	a0,0x16
    80202c20:	a3450513          	addi	a0,a0,-1484 # 80218650 <user_test_table+0x4a0>
    80202c24:	ffffe097          	auipc	ra,0xffffe
    80202c28:	660080e7          	jalr	1632(ra) # 80201284 <printf>
        return 0;
    80202c2c:	4781                	li	a5,0
    80202c2e:	a86d                	j	80202ce8 <handle_page_fault+0x240>
    memset(page, 0, PGSIZE);
    80202c30:	6605                	lui	a2,0x1
    80202c32:	4581                	li	a1,0
    80202c34:	fc043503          	ld	a0,-64(s0)
    80202c38:	fffff097          	auipc	ra,0xfffff
    80202c3c:	30c080e7          	jalr	780(ra) # 80201f44 <memset>
    int perm = 0;
    80202c40:	fe042023          	sw	zero,-32(s0)
    if (type == 1) perm = PTE_X | PTE_R | PTE_U;
    80202c44:	fb442783          	lw	a5,-76(s0)
    80202c48:	0007871b          	sext.w	a4,a5
    80202c4c:	4785                	li	a5,1
    80202c4e:	00f71663          	bne	a4,a5,80202c5a <handle_page_fault+0x1b2>
    80202c52:	47e9                	li	a5,26
    80202c54:	fef42023          	sw	a5,-32(s0)
    80202c58:	a035                	j	80202c84 <handle_page_fault+0x1dc>
    else if (type == 2) perm = PTE_R | PTE_U;
    80202c5a:	fb442783          	lw	a5,-76(s0)
    80202c5e:	0007871b          	sext.w	a4,a5
    80202c62:	4789                	li	a5,2
    80202c64:	00f71663          	bne	a4,a5,80202c70 <handle_page_fault+0x1c8>
    80202c68:	47c9                	li	a5,18
    80202c6a:	fef42023          	sw	a5,-32(s0)
    80202c6e:	a819                	j	80202c84 <handle_page_fault+0x1dc>
    else if (type == 3) perm = PTE_R | PTE_W | PTE_U;
    80202c70:	fb442783          	lw	a5,-76(s0)
    80202c74:	0007871b          	sext.w	a4,a5
    80202c78:	478d                	li	a5,3
    80202c7a:	00f71563          	bne	a4,a5,80202c84 <handle_page_fault+0x1dc>
    80202c7e:	47d9                	li	a5,22
    80202c80:	fef42023          	sw	a5,-32(s0)
    if (map_page(pt, page_va, (uint64)page, perm) != 0) {
    80202c84:	fc043783          	ld	a5,-64(s0)
    80202c88:	fe042703          	lw	a4,-32(s0)
    80202c8c:	86ba                	mv	a3,a4
    80202c8e:	863e                	mv	a2,a5
    80202c90:	fd843583          	ld	a1,-40(s0)
    80202c94:	fe843503          	ld	a0,-24(s0)
    80202c98:	fffff097          	auipc	ra,0xfffff
    80202c9c:	778080e7          	jalr	1912(ra) # 80202410 <map_page>
    80202ca0:	87aa                	mv	a5,a0
    80202ca2:	c38d                	beqz	a5,80202cc4 <handle_page_fault+0x21c>
        free_page(page);
    80202ca4:	fc043503          	ld	a0,-64(s0)
    80202ca8:	00000097          	auipc	ra,0x0
    80202cac:	720080e7          	jalr	1824(ra) # 802033c8 <free_page>
        printf("[PAGE FAULT] 页面映射失败\n");
    80202cb0:	00016517          	auipc	a0,0x16
    80202cb4:	9d050513          	addi	a0,a0,-1584 # 80218680 <user_test_table+0x4d0>
    80202cb8:	ffffe097          	auipc	ra,0xffffe
    80202cbc:	5cc080e7          	jalr	1484(ra) # 80201284 <printf>
        return 0;
    80202cc0:	4781                	li	a5,0
    80202cc2:	a01d                	j	80202ce8 <handle_page_fault+0x240>
    sfence_vma();
    80202cc4:	00000097          	auipc	ra,0x0
    80202cc8:	c2a080e7          	jalr	-982(ra) # 802028ee <sfence_vma>
    printf("[PAGE FAULT] 成功分配并映射页面 0x%lx -> 0x%lx\n", page_va, (uint64)page);
    80202ccc:	fc043783          	ld	a5,-64(s0)
    80202cd0:	863e                	mv	a2,a5
    80202cd2:	fd843583          	ld	a1,-40(s0)
    80202cd6:	00016517          	auipc	a0,0x16
    80202cda:	9d250513          	addi	a0,a0,-1582 # 802186a8 <user_test_table+0x4f8>
    80202cde:	ffffe097          	auipc	ra,0xffffe
    80202ce2:	5a6080e7          	jalr	1446(ra) # 80201284 <printf>
    return 1;
    80202ce6:	4785                	li	a5,1
}
    80202ce8:	853e                	mv	a0,a5
    80202cea:	60a6                	ld	ra,72(sp)
    80202cec:	6406                	ld	s0,64(sp)
    80202cee:	6161                	addi	sp,sp,80
    80202cf0:	8082                	ret

0000000080202cf2 <test_pagetable>:
void test_pagetable(void) {
    80202cf2:	7155                	addi	sp,sp,-208
    80202cf4:	e586                	sd	ra,200(sp)
    80202cf6:	e1a2                	sd	s0,192(sp)
    80202cf8:	fd26                	sd	s1,184(sp)
    80202cfa:	f94a                	sd	s2,176(sp)
    80202cfc:	f54e                	sd	s3,168(sp)
    80202cfe:	f152                	sd	s4,160(sp)
    80202d00:	ed56                	sd	s5,152(sp)
    80202d02:	e95a                	sd	s6,144(sp)
    80202d04:	e55e                	sd	s7,136(sp)
    80202d06:	e162                	sd	s8,128(sp)
    80202d08:	fce6                	sd	s9,120(sp)
    80202d0a:	0980                	addi	s0,sp,208
    80202d0c:	878a                	mv	a5,sp
    80202d0e:	84be                	mv	s1,a5
    printf("[PT TEST] 创建页表...\n");
    80202d10:	00016517          	auipc	a0,0x16
    80202d14:	9d850513          	addi	a0,a0,-1576 # 802186e8 <user_test_table+0x538>
    80202d18:	ffffe097          	auipc	ra,0xffffe
    80202d1c:	56c080e7          	jalr	1388(ra) # 80201284 <printf>
    pagetable_t pt = create_pagetable();
    80202d20:	fffff097          	auipc	ra,0xfffff
    80202d24:	480080e7          	jalr	1152(ra) # 802021a0 <create_pagetable>
    80202d28:	f8a43423          	sd	a0,-120(s0)
    assert(pt != 0);
    80202d2c:	f8843783          	ld	a5,-120(s0)
    80202d30:	00f037b3          	snez	a5,a5
    80202d34:	0ff7f793          	zext.b	a5,a5
    80202d38:	2781                	sext.w	a5,a5
    80202d3a:	853e                	mv	a0,a5
    80202d3c:	fffff097          	auipc	ra,0xfffff
    80202d40:	37a080e7          	jalr	890(ra) # 802020b6 <assert>
    printf("[PT TEST] 页表创建通过\n");
    80202d44:	00016517          	auipc	a0,0x16
    80202d48:	9c450513          	addi	a0,a0,-1596 # 80218708 <user_test_table+0x558>
    80202d4c:	ffffe097          	auipc	ra,0xffffe
    80202d50:	538080e7          	jalr	1336(ra) # 80201284 <printf>
    uint64 va[] = {
    80202d54:	00016797          	auipc	a5,0x16
    80202d58:	b7478793          	addi	a5,a5,-1164 # 802188c8 <user_test_table+0x718>
    80202d5c:	638c                	ld	a1,0(a5)
    80202d5e:	6790                	ld	a2,8(a5)
    80202d60:	6b94                	ld	a3,16(a5)
    80202d62:	6f98                	ld	a4,24(a5)
    80202d64:	739c                	ld	a5,32(a5)
    80202d66:	f2b43c23          	sd	a1,-200(s0)
    80202d6a:	f4c43023          	sd	a2,-192(s0)
    80202d6e:	f4d43423          	sd	a3,-184(s0)
    80202d72:	f4e43823          	sd	a4,-176(s0)
    80202d76:	f4f43c23          	sd	a5,-168(s0)
    int n = sizeof(va) / sizeof(va[0]);
    80202d7a:	4795                	li	a5,5
    80202d7c:	f8f42223          	sw	a5,-124(s0)
    uint64 pa[n];
    80202d80:	f8442783          	lw	a5,-124(s0)
    80202d84:	873e                	mv	a4,a5
    80202d86:	177d                	addi	a4,a4,-1
    80202d88:	f6e43c23          	sd	a4,-136(s0)
    80202d8c:	873e                	mv	a4,a5
    80202d8e:	8c3a                	mv	s8,a4
    80202d90:	4c81                	li	s9,0
    80202d92:	03ac5713          	srli	a4,s8,0x3a
    80202d96:	006c9a93          	slli	s5,s9,0x6
    80202d9a:	01576ab3          	or	s5,a4,s5
    80202d9e:	006c1a13          	slli	s4,s8,0x6
    80202da2:	873e                	mv	a4,a5
    80202da4:	8b3a                	mv	s6,a4
    80202da6:	4b81                	li	s7,0
    80202da8:	03ab5713          	srli	a4,s6,0x3a
    80202dac:	006b9993          	slli	s3,s7,0x6
    80202db0:	013769b3          	or	s3,a4,s3
    80202db4:	006b1913          	slli	s2,s6,0x6
    80202db8:	078e                	slli	a5,a5,0x3
    80202dba:	07bd                	addi	a5,a5,15
    80202dbc:	8391                	srli	a5,a5,0x4
    80202dbe:	0792                	slli	a5,a5,0x4
    80202dc0:	40f10133          	sub	sp,sp,a5
    80202dc4:	878a                	mv	a5,sp
    80202dc6:	079d                	addi	a5,a5,7
    80202dc8:	838d                	srli	a5,a5,0x3
    80202dca:	078e                	slli	a5,a5,0x3
    80202dcc:	f6f43823          	sd	a5,-144(s0)
    for (int i = 0; i < n; i++) {
    80202dd0:	f8042e23          	sw	zero,-100(s0)
    80202dd4:	a201                	j	80202ed4 <test_pagetable+0x1e2>
        pa[i] = (uint64)alloc_page();
    80202dd6:	00000097          	auipc	ra,0x0
    80202dda:	586080e7          	jalr	1414(ra) # 8020335c <alloc_page>
    80202dde:	87aa                	mv	a5,a0
    80202de0:	86be                	mv	a3,a5
    80202de2:	f7043703          	ld	a4,-144(s0)
    80202de6:	f9c42783          	lw	a5,-100(s0)
    80202dea:	078e                	slli	a5,a5,0x3
    80202dec:	97ba                	add	a5,a5,a4
    80202dee:	e394                	sd	a3,0(a5)
        assert(pa[i]);
    80202df0:	f7043703          	ld	a4,-144(s0)
    80202df4:	f9c42783          	lw	a5,-100(s0)
    80202df8:	078e                	slli	a5,a5,0x3
    80202dfa:	97ba                	add	a5,a5,a4
    80202dfc:	639c                	ld	a5,0(a5)
    80202dfe:	2781                	sext.w	a5,a5
    80202e00:	853e                	mv	a0,a5
    80202e02:	fffff097          	auipc	ra,0xfffff
    80202e06:	2b4080e7          	jalr	692(ra) # 802020b6 <assert>
        printf("[PT TEST] 分配物理页 pa[%d]=0x%lx\n", i, pa[i]);
    80202e0a:	f7043703          	ld	a4,-144(s0)
    80202e0e:	f9c42783          	lw	a5,-100(s0)
    80202e12:	078e                	slli	a5,a5,0x3
    80202e14:	97ba                	add	a5,a5,a4
    80202e16:	6398                	ld	a4,0(a5)
    80202e18:	f9c42783          	lw	a5,-100(s0)
    80202e1c:	863a                	mv	a2,a4
    80202e1e:	85be                	mv	a1,a5
    80202e20:	00016517          	auipc	a0,0x16
    80202e24:	90850513          	addi	a0,a0,-1784 # 80218728 <user_test_table+0x578>
    80202e28:	ffffe097          	auipc	ra,0xffffe
    80202e2c:	45c080e7          	jalr	1116(ra) # 80201284 <printf>
        int ret = map_page(pt, va[i], pa[i], PTE_R | PTE_W);
    80202e30:	f9c42783          	lw	a5,-100(s0)
    80202e34:	078e                	slli	a5,a5,0x3
    80202e36:	fa078793          	addi	a5,a5,-96
    80202e3a:	97a2                	add	a5,a5,s0
    80202e3c:	f987b583          	ld	a1,-104(a5)
    80202e40:	f7043703          	ld	a4,-144(s0)
    80202e44:	f9c42783          	lw	a5,-100(s0)
    80202e48:	078e                	slli	a5,a5,0x3
    80202e4a:	97ba                	add	a5,a5,a4
    80202e4c:	639c                	ld	a5,0(a5)
    80202e4e:	4699                	li	a3,6
    80202e50:	863e                	mv	a2,a5
    80202e52:	f8843503          	ld	a0,-120(s0)
    80202e56:	fffff097          	auipc	ra,0xfffff
    80202e5a:	5ba080e7          	jalr	1466(ra) # 80202410 <map_page>
    80202e5e:	87aa                	mv	a5,a0
    80202e60:	f6f42223          	sw	a5,-156(s0)
        printf("[PT TEST] 映射 va=0x%lx -> pa=0x%lx %s\n", va[i], pa[i], ret == 0 ? "成功" : "失败");
    80202e64:	f9c42783          	lw	a5,-100(s0)
    80202e68:	078e                	slli	a5,a5,0x3
    80202e6a:	fa078793          	addi	a5,a5,-96
    80202e6e:	97a2                	add	a5,a5,s0
    80202e70:	f987b583          	ld	a1,-104(a5)
    80202e74:	f7043703          	ld	a4,-144(s0)
    80202e78:	f9c42783          	lw	a5,-100(s0)
    80202e7c:	078e                	slli	a5,a5,0x3
    80202e7e:	97ba                	add	a5,a5,a4
    80202e80:	6398                	ld	a4,0(a5)
    80202e82:	f6442783          	lw	a5,-156(s0)
    80202e86:	2781                	sext.w	a5,a5
    80202e88:	e791                	bnez	a5,80202e94 <test_pagetable+0x1a2>
    80202e8a:	00016797          	auipc	a5,0x16
    80202e8e:	8c678793          	addi	a5,a5,-1850 # 80218750 <user_test_table+0x5a0>
    80202e92:	a029                	j	80202e9c <test_pagetable+0x1aa>
    80202e94:	00016797          	auipc	a5,0x16
    80202e98:	8c478793          	addi	a5,a5,-1852 # 80218758 <user_test_table+0x5a8>
    80202e9c:	86be                	mv	a3,a5
    80202e9e:	863a                	mv	a2,a4
    80202ea0:	00016517          	auipc	a0,0x16
    80202ea4:	8c050513          	addi	a0,a0,-1856 # 80218760 <user_test_table+0x5b0>
    80202ea8:	ffffe097          	auipc	ra,0xffffe
    80202eac:	3dc080e7          	jalr	988(ra) # 80201284 <printf>
        assert(ret == 0);
    80202eb0:	f6442783          	lw	a5,-156(s0)
    80202eb4:	2781                	sext.w	a5,a5
    80202eb6:	0017b793          	seqz	a5,a5
    80202eba:	0ff7f793          	zext.b	a5,a5
    80202ebe:	2781                	sext.w	a5,a5
    80202ec0:	853e                	mv	a0,a5
    80202ec2:	fffff097          	auipc	ra,0xfffff
    80202ec6:	1f4080e7          	jalr	500(ra) # 802020b6 <assert>
    for (int i = 0; i < n; i++) {
    80202eca:	f9c42783          	lw	a5,-100(s0)
    80202ece:	2785                	addiw	a5,a5,1
    80202ed0:	f8f42e23          	sw	a5,-100(s0)
    80202ed4:	f9c42783          	lw	a5,-100(s0)
    80202ed8:	873e                	mv	a4,a5
    80202eda:	f8442783          	lw	a5,-124(s0)
    80202ede:	2701                	sext.w	a4,a4
    80202ee0:	2781                	sext.w	a5,a5
    80202ee2:	eef74ae3          	blt	a4,a5,80202dd6 <test_pagetable+0xe4>
    printf("[PT TEST] 多级映射测试通过\n");
    80202ee6:	00016517          	auipc	a0,0x16
    80202eea:	8aa50513          	addi	a0,a0,-1878 # 80218790 <user_test_table+0x5e0>
    80202eee:	ffffe097          	auipc	ra,0xffffe
    80202ef2:	396080e7          	jalr	918(ra) # 80201284 <printf>
    for (int i = 0; i < n; i++) {
    80202ef6:	f8042c23          	sw	zero,-104(s0)
    80202efa:	a861                	j	80202f92 <test_pagetable+0x2a0>
        pte_t *pte = walk_lookup(pt, va[i]);
    80202efc:	f9842783          	lw	a5,-104(s0)
    80202f00:	078e                	slli	a5,a5,0x3
    80202f02:	fa078793          	addi	a5,a5,-96
    80202f06:	97a2                	add	a5,a5,s0
    80202f08:	f987b783          	ld	a5,-104(a5)
    80202f0c:	85be                	mv	a1,a5
    80202f0e:	f8843503          	ld	a0,-120(s0)
    80202f12:	fffff097          	auipc	ra,0xfffff
    80202f16:	2ca080e7          	jalr	714(ra) # 802021dc <walk_lookup>
    80202f1a:	f6a43423          	sd	a0,-152(s0)
        if (pte && (*pte & PTE_V)) {
    80202f1e:	f6843783          	ld	a5,-152(s0)
    80202f22:	c3b1                	beqz	a5,80202f66 <test_pagetable+0x274>
    80202f24:	f6843783          	ld	a5,-152(s0)
    80202f28:	639c                	ld	a5,0(a5)
    80202f2a:	8b85                	andi	a5,a5,1
    80202f2c:	cf8d                	beqz	a5,80202f66 <test_pagetable+0x274>
            printf("[PT TEST] 检查映射: va=0x%lx -> pa=0x%lx, pte=0x%lx\n", va[i], PTE2PA(*pte), *pte);
    80202f2e:	f9842783          	lw	a5,-104(s0)
    80202f32:	078e                	slli	a5,a5,0x3
    80202f34:	fa078793          	addi	a5,a5,-96
    80202f38:	97a2                	add	a5,a5,s0
    80202f3a:	f987b703          	ld	a4,-104(a5)
    80202f3e:	f6843783          	ld	a5,-152(s0)
    80202f42:	639c                	ld	a5,0(a5)
    80202f44:	83a9                	srli	a5,a5,0xa
    80202f46:	00c79613          	slli	a2,a5,0xc
    80202f4a:	f6843783          	ld	a5,-152(s0)
    80202f4e:	639c                	ld	a5,0(a5)
    80202f50:	86be                	mv	a3,a5
    80202f52:	85ba                	mv	a1,a4
    80202f54:	00016517          	auipc	a0,0x16
    80202f58:	86450513          	addi	a0,a0,-1948 # 802187b8 <user_test_table+0x608>
    80202f5c:	ffffe097          	auipc	ra,0xffffe
    80202f60:	328080e7          	jalr	808(ra) # 80201284 <printf>
    80202f64:	a015                	j	80202f88 <test_pagetable+0x296>
            printf("[PT TEST] 检查映射: va=0x%lx 未映射\n", va[i]);
    80202f66:	f9842783          	lw	a5,-104(s0)
    80202f6a:	078e                	slli	a5,a5,0x3
    80202f6c:	fa078793          	addi	a5,a5,-96
    80202f70:	97a2                	add	a5,a5,s0
    80202f72:	f987b783          	ld	a5,-104(a5)
    80202f76:	85be                	mv	a1,a5
    80202f78:	00016517          	auipc	a0,0x16
    80202f7c:	88050513          	addi	a0,a0,-1920 # 802187f8 <user_test_table+0x648>
    80202f80:	ffffe097          	auipc	ra,0xffffe
    80202f84:	304080e7          	jalr	772(ra) # 80201284 <printf>
    for (int i = 0; i < n; i++) {
    80202f88:	f9842783          	lw	a5,-104(s0)
    80202f8c:	2785                	addiw	a5,a5,1
    80202f8e:	f8f42c23          	sw	a5,-104(s0)
    80202f92:	f9842783          	lw	a5,-104(s0)
    80202f96:	873e                	mv	a4,a5
    80202f98:	f8442783          	lw	a5,-124(s0)
    80202f9c:	2701                	sext.w	a4,a4
    80202f9e:	2781                	sext.w	a5,a5
    80202fa0:	f4f74ee3          	blt	a4,a5,80202efc <test_pagetable+0x20a>
    printf("[PT TEST] 打印页表结构（递归）\n");
    80202fa4:	00016517          	auipc	a0,0x16
    80202fa8:	88450513          	addi	a0,a0,-1916 # 80218828 <user_test_table+0x678>
    80202fac:	ffffe097          	auipc	ra,0xffffe
    80202fb0:	2d8080e7          	jalr	728(ra) # 80201284 <printf>
    print_pagetable(pt, 0, 0);
    80202fb4:	4601                	li	a2,0
    80202fb6:	4581                	li	a1,0
    80202fb8:	f8843503          	ld	a0,-120(s0)
    80202fbc:	00000097          	auipc	ra,0x0
    80202fc0:	9d6080e7          	jalr	-1578(ra) # 80202992 <print_pagetable>
    for (int i = 0; i < n; i++) {
    80202fc4:	f8042a23          	sw	zero,-108(s0)
    80202fc8:	a0a9                	j	80203012 <test_pagetable+0x320>
        free_page((void*)pa[i]);
    80202fca:	f7043703          	ld	a4,-144(s0)
    80202fce:	f9442783          	lw	a5,-108(s0)
    80202fd2:	078e                	slli	a5,a5,0x3
    80202fd4:	97ba                	add	a5,a5,a4
    80202fd6:	639c                	ld	a5,0(a5)
    80202fd8:	853e                	mv	a0,a5
    80202fda:	00000097          	auipc	ra,0x0
    80202fde:	3ee080e7          	jalr	1006(ra) # 802033c8 <free_page>
        printf("[PT TEST] 释放物理页 pa[%d]=0x%lx\n", i, pa[i]);
    80202fe2:	f7043703          	ld	a4,-144(s0)
    80202fe6:	f9442783          	lw	a5,-108(s0)
    80202fea:	078e                	slli	a5,a5,0x3
    80202fec:	97ba                	add	a5,a5,a4
    80202fee:	6398                	ld	a4,0(a5)
    80202ff0:	f9442783          	lw	a5,-108(s0)
    80202ff4:	863a                	mv	a2,a4
    80202ff6:	85be                	mv	a1,a5
    80202ff8:	00016517          	auipc	a0,0x16
    80202ffc:	86050513          	addi	a0,a0,-1952 # 80218858 <user_test_table+0x6a8>
    80203000:	ffffe097          	auipc	ra,0xffffe
    80203004:	284080e7          	jalr	644(ra) # 80201284 <printf>
    for (int i = 0; i < n; i++) {
    80203008:	f9442783          	lw	a5,-108(s0)
    8020300c:	2785                	addiw	a5,a5,1
    8020300e:	f8f42a23          	sw	a5,-108(s0)
    80203012:	f9442783          	lw	a5,-108(s0)
    80203016:	873e                	mv	a4,a5
    80203018:	f8442783          	lw	a5,-124(s0)
    8020301c:	2701                	sext.w	a4,a4
    8020301e:	2781                	sext.w	a5,a5
    80203020:	faf745e3          	blt	a4,a5,80202fca <test_pagetable+0x2d8>
    free_pagetable(pt);
    80203024:	f8843503          	ld	a0,-120(s0)
    80203028:	fffff097          	auipc	ra,0xfffff
    8020302c:	55c080e7          	jalr	1372(ra) # 80202584 <free_pagetable>
    printf("[PT TEST] 释放页表完成\n");
    80203030:	00016517          	auipc	a0,0x16
    80203034:	85050513          	addi	a0,a0,-1968 # 80218880 <user_test_table+0x6d0>
    80203038:	ffffe097          	auipc	ra,0xffffe
    8020303c:	24c080e7          	jalr	588(ra) # 80201284 <printf>
    printf("[PT TEST] 所有页表测试通过\n");
    80203040:	00016517          	auipc	a0,0x16
    80203044:	86050513          	addi	a0,a0,-1952 # 802188a0 <user_test_table+0x6f0>
    80203048:	ffffe097          	auipc	ra,0xffffe
    8020304c:	23c080e7          	jalr	572(ra) # 80201284 <printf>
    80203050:	8126                	mv	sp,s1
}
    80203052:	0001                	nop
    80203054:	f3040113          	addi	sp,s0,-208
    80203058:	60ae                	ld	ra,200(sp)
    8020305a:	640e                	ld	s0,192(sp)
    8020305c:	74ea                	ld	s1,184(sp)
    8020305e:	794a                	ld	s2,176(sp)
    80203060:	79aa                	ld	s3,168(sp)
    80203062:	7a0a                	ld	s4,160(sp)
    80203064:	6aea                	ld	s5,152(sp)
    80203066:	6b4a                	ld	s6,144(sp)
    80203068:	6baa                	ld	s7,136(sp)
    8020306a:	6c0a                	ld	s8,128(sp)
    8020306c:	7ce6                	ld	s9,120(sp)
    8020306e:	6169                	addi	sp,sp,208
    80203070:	8082                	ret

0000000080203072 <check_mapping>:
void check_mapping(uint64 va) {
    80203072:	7179                	addi	sp,sp,-48
    80203074:	f406                	sd	ra,40(sp)
    80203076:	f022                	sd	s0,32(sp)
    80203078:	1800                	addi	s0,sp,48
    8020307a:	fca43c23          	sd	a0,-40(s0)
    pte_t *pte = walk_lookup(kernel_pagetable, va);
    8020307e:	0003a797          	auipc	a5,0x3a
    80203082:	03278793          	addi	a5,a5,50 # 8023d0b0 <kernel_pagetable>
    80203086:	639c                	ld	a5,0(a5)
    80203088:	fd843583          	ld	a1,-40(s0)
    8020308c:	853e                	mv	a0,a5
    8020308e:	fffff097          	auipc	ra,0xfffff
    80203092:	14e080e7          	jalr	334(ra) # 802021dc <walk_lookup>
    80203096:	fea43423          	sd	a0,-24(s0)
    if(pte && (*pte & PTE_V)) {
    8020309a:	fe843783          	ld	a5,-24(s0)
    8020309e:	cbb9                	beqz	a5,802030f4 <check_mapping+0x82>
    802030a0:	fe843783          	ld	a5,-24(s0)
    802030a4:	639c                	ld	a5,0(a5)
    802030a6:	8b85                	andi	a5,a5,1
    802030a8:	c7b1                	beqz	a5,802030f4 <check_mapping+0x82>
        printf("Address 0x%lx is mapped: pte=0x%lx\n", va, *pte);
    802030aa:	fe843783          	ld	a5,-24(s0)
    802030ae:	639c                	ld	a5,0(a5)
    802030b0:	863e                	mv	a2,a5
    802030b2:	fd843583          	ld	a1,-40(s0)
    802030b6:	00016517          	auipc	a0,0x16
    802030ba:	83a50513          	addi	a0,a0,-1990 # 802188f0 <user_test_table+0x740>
    802030be:	ffffe097          	auipc	ra,0xffffe
    802030c2:	1c6080e7          	jalr	454(ra) # 80201284 <printf>
		volatile unsigned char *p = (unsigned char*)va;
    802030c6:	fd843783          	ld	a5,-40(s0)
    802030ca:	fef43023          	sd	a5,-32(s0)
        printf("Try to read [0x%lx]: 0x%02x\n", va, *p);
    802030ce:	fe043783          	ld	a5,-32(s0)
    802030d2:	0007c783          	lbu	a5,0(a5)
    802030d6:	0ff7f793          	zext.b	a5,a5
    802030da:	2781                	sext.w	a5,a5
    802030dc:	863e                	mv	a2,a5
    802030de:	fd843583          	ld	a1,-40(s0)
    802030e2:	00016517          	auipc	a0,0x16
    802030e6:	83650513          	addi	a0,a0,-1994 # 80218918 <user_test_table+0x768>
    802030ea:	ffffe097          	auipc	ra,0xffffe
    802030ee:	19a080e7          	jalr	410(ra) # 80201284 <printf>
    if(pte && (*pte & PTE_V)) {
    802030f2:	a821                	j	8020310a <check_mapping+0x98>
        printf("Address 0x%lx is NOT mapped\n", va);
    802030f4:	fd843583          	ld	a1,-40(s0)
    802030f8:	00016517          	auipc	a0,0x16
    802030fc:	84050513          	addi	a0,a0,-1984 # 80218938 <user_test_table+0x788>
    80203100:	ffffe097          	auipc	ra,0xffffe
    80203104:	184080e7          	jalr	388(ra) # 80201284 <printf>
}
    80203108:	0001                	nop
    8020310a:	0001                	nop
    8020310c:	70a2                	ld	ra,40(sp)
    8020310e:	7402                	ld	s0,32(sp)
    80203110:	6145                	addi	sp,sp,48
    80203112:	8082                	ret

0000000080203114 <check_is_mapped>:
int check_is_mapped(uint64 va) {
    80203114:	7179                	addi	sp,sp,-48
    80203116:	f406                	sd	ra,40(sp)
    80203118:	f022                	sd	s0,32(sp)
    8020311a:	1800                	addi	s0,sp,48
    8020311c:	fca43c23          	sd	a0,-40(s0)
    pte_t *pte = walk_lookup(get_current_pagetable(), va);
    80203120:	00000097          	auipc	ra,0x0
    80203124:	85a080e7          	jalr	-1958(ra) # 8020297a <get_current_pagetable>
    80203128:	87aa                	mv	a5,a0
    8020312a:	fd843583          	ld	a1,-40(s0)
    8020312e:	853e                	mv	a0,a5
    80203130:	fffff097          	auipc	ra,0xfffff
    80203134:	0ac080e7          	jalr	172(ra) # 802021dc <walk_lookup>
    80203138:	fea43423          	sd	a0,-24(s0)
    if (pte && (*pte & PTE_V)) {
    8020313c:	fe843783          	ld	a5,-24(s0)
    80203140:	c795                	beqz	a5,8020316c <check_is_mapped+0x58>
    80203142:	fe843783          	ld	a5,-24(s0)
    80203146:	639c                	ld	a5,0(a5)
    80203148:	8b85                	andi	a5,a5,1
    8020314a:	c38d                	beqz	a5,8020316c <check_is_mapped+0x58>
        printf("Address 0x%lx is mapped: pte=0x%lx\n", va, *pte);
    8020314c:	fe843783          	ld	a5,-24(s0)
    80203150:	639c                	ld	a5,0(a5)
    80203152:	863e                	mv	a2,a5
    80203154:	fd843583          	ld	a1,-40(s0)
    80203158:	00015517          	auipc	a0,0x15
    8020315c:	79850513          	addi	a0,a0,1944 # 802188f0 <user_test_table+0x740>
    80203160:	ffffe097          	auipc	ra,0xffffe
    80203164:	124080e7          	jalr	292(ra) # 80201284 <printf>
        return 1;
    80203168:	4785                	li	a5,1
    8020316a:	a821                	j	80203182 <check_is_mapped+0x6e>
        printf("Address 0x%lx is NOT mapped\n", va);
    8020316c:	fd843583          	ld	a1,-40(s0)
    80203170:	00015517          	auipc	a0,0x15
    80203174:	7c850513          	addi	a0,a0,1992 # 80218938 <user_test_table+0x788>
    80203178:	ffffe097          	auipc	ra,0xffffe
    8020317c:	10c080e7          	jalr	268(ra) # 80201284 <printf>
        return 0;
    80203180:	4781                	li	a5,0
}
    80203182:	853e                	mv	a0,a5
    80203184:	70a2                	ld	ra,40(sp)
    80203186:	7402                	ld	s0,32(sp)
    80203188:	6145                	addi	sp,sp,48
    8020318a:	8082                	ret

000000008020318c <uvmcopy>:
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    8020318c:	711d                	addi	sp,sp,-96
    8020318e:	ec86                	sd	ra,88(sp)
    80203190:	e8a2                	sd	s0,80(sp)
    80203192:	1080                	addi	s0,sp,96
    80203194:	faa43c23          	sd	a0,-72(s0)
    80203198:	fab43823          	sd	a1,-80(s0)
    8020319c:	fac43423          	sd	a2,-88(s0)
    for (uint64 i = 0; i < sz; i += PGSIZE) {
    802031a0:	fe043423          	sd	zero,-24(s0)
    802031a4:	a8d1                	j	80203278 <uvmcopy+0xec>
        pte_t *pte = walk_lookup(old, i);
    802031a6:	fe843583          	ld	a1,-24(s0)
    802031aa:	fb843503          	ld	a0,-72(s0)
    802031ae:	fffff097          	auipc	ra,0xfffff
    802031b2:	02e080e7          	jalr	46(ra) # 802021dc <walk_lookup>
    802031b6:	fca43c23          	sd	a0,-40(s0)
        if (pte == 0 || (*pte & PTE_V) == 0)
    802031ba:	fd843783          	ld	a5,-40(s0)
    802031be:	c7d5                	beqz	a5,8020326a <uvmcopy+0xde>
    802031c0:	fd843783          	ld	a5,-40(s0)
    802031c4:	639c                	ld	a5,0(a5)
    802031c6:	8b85                	andi	a5,a5,1
    802031c8:	c3cd                	beqz	a5,8020326a <uvmcopy+0xde>
        uint64 pa = PTE2PA(*pte);
    802031ca:	fd843783          	ld	a5,-40(s0)
    802031ce:	639c                	ld	a5,0(a5)
    802031d0:	83a9                	srli	a5,a5,0xa
    802031d2:	07b2                	slli	a5,a5,0xc
    802031d4:	fcf43823          	sd	a5,-48(s0)
        int flags = PTE_FLAGS(*pte);
    802031d8:	fd843783          	ld	a5,-40(s0)
    802031dc:	639c                	ld	a5,0(a5)
    802031de:	2781                	sext.w	a5,a5
    802031e0:	3ff7f793          	andi	a5,a5,1023
    802031e4:	fef42223          	sw	a5,-28(s0)
		if (i < 0x80000000)
    802031e8:	fe843703          	ld	a4,-24(s0)
    802031ec:	800007b7          	lui	a5,0x80000
    802031f0:	fff7c793          	not	a5,a5
    802031f4:	00e7e963          	bltu	a5,a4,80203206 <uvmcopy+0x7a>
			flags |= PTE_U;
    802031f8:	fe442783          	lw	a5,-28(s0)
    802031fc:	0107e793          	ori	a5,a5,16
    80203200:	fef42223          	sw	a5,-28(s0)
    80203204:	a031                	j	80203210 <uvmcopy+0x84>
			flags &= ~PTE_U;
    80203206:	fe442783          	lw	a5,-28(s0)
    8020320a:	9bbd                	andi	a5,a5,-17
    8020320c:	fef42223          	sw	a5,-28(s0)
        void *mem = alloc_page();
    80203210:	00000097          	auipc	ra,0x0
    80203214:	14c080e7          	jalr	332(ra) # 8020335c <alloc_page>
    80203218:	fca43423          	sd	a0,-56(s0)
        if (mem == 0)
    8020321c:	fc843783          	ld	a5,-56(s0)
    80203220:	e399                	bnez	a5,80203226 <uvmcopy+0x9a>
            return -1; // 分配失败
    80203222:	57fd                	li	a5,-1
    80203224:	a08d                	j	80203286 <uvmcopy+0xfa>
        memmove(mem, (void*)pa, PGSIZE);
    80203226:	fd043783          	ld	a5,-48(s0)
    8020322a:	6605                	lui	a2,0x1
    8020322c:	85be                	mv	a1,a5
    8020322e:	fc843503          	ld	a0,-56(s0)
    80203232:	fffff097          	auipc	ra,0xfffff
    80203236:	d62080e7          	jalr	-670(ra) # 80201f94 <memmove>
        if (map_page(new, i, (uint64)mem, flags) != 0) {
    8020323a:	fc843783          	ld	a5,-56(s0)
    8020323e:	fe442703          	lw	a4,-28(s0)
    80203242:	86ba                	mv	a3,a4
    80203244:	863e                	mv	a2,a5
    80203246:	fe843583          	ld	a1,-24(s0)
    8020324a:	fb043503          	ld	a0,-80(s0)
    8020324e:	fffff097          	auipc	ra,0xfffff
    80203252:	1c2080e7          	jalr	450(ra) # 80202410 <map_page>
    80203256:	87aa                	mv	a5,a0
    80203258:	cb91                	beqz	a5,8020326c <uvmcopy+0xe0>
            free_page(mem);
    8020325a:	fc843503          	ld	a0,-56(s0)
    8020325e:	00000097          	auipc	ra,0x0
    80203262:	16a080e7          	jalr	362(ra) # 802033c8 <free_page>
            return -1;
    80203266:	57fd                	li	a5,-1
    80203268:	a839                	j	80203286 <uvmcopy+0xfa>
            continue; // 跳过未分配的页
    8020326a:	0001                	nop
    for (uint64 i = 0; i < sz; i += PGSIZE) {
    8020326c:	fe843703          	ld	a4,-24(s0)
    80203270:	6785                	lui	a5,0x1
    80203272:	97ba                	add	a5,a5,a4
    80203274:	fef43423          	sd	a5,-24(s0)
    80203278:	fe843703          	ld	a4,-24(s0)
    8020327c:	fa843783          	ld	a5,-88(s0)
    80203280:	f2f763e3          	bltu	a4,a5,802031a6 <uvmcopy+0x1a>
    return 0;
    80203284:	4781                	li	a5,0
    80203286:	853e                	mv	a0,a5
    80203288:	60e6                	ld	ra,88(sp)
    8020328a:	6446                	ld	s0,80(sp)
    8020328c:	6125                	addi	sp,sp,96
    8020328e:	8082                	ret

0000000080203290 <assert>:
    80203290:	1101                	addi	sp,sp,-32
    80203292:	ec06                	sd	ra,24(sp)
    80203294:	e822                	sd	s0,16(sp)
    80203296:	1000                	addi	s0,sp,32
    80203298:	87aa                	mv	a5,a0
    8020329a:	fef42623          	sw	a5,-20(s0)
    8020329e:	fec42783          	lw	a5,-20(s0)
    802032a2:	2781                	sext.w	a5,a5
    802032a4:	e79d                	bnez	a5,802032d2 <assert+0x42>
    802032a6:	33c00613          	li	a2,828
    802032aa:	00017597          	auipc	a1,0x17
    802032ae:	75e58593          	addi	a1,a1,1886 # 8021aa08 <user_test_table+0x78>
    802032b2:	00017517          	auipc	a0,0x17
    802032b6:	76650513          	addi	a0,a0,1894 # 8021aa18 <user_test_table+0x88>
    802032ba:	ffffe097          	auipc	ra,0xffffe
    802032be:	fca080e7          	jalr	-54(ra) # 80201284 <printf>
    802032c2:	00017517          	auipc	a0,0x17
    802032c6:	77e50513          	addi	a0,a0,1918 # 8021aa40 <user_test_table+0xb0>
    802032ca:	ffffe097          	auipc	ra,0xffffe
    802032ce:	53c080e7          	jalr	1340(ra) # 80201806 <panic>
    802032d2:	0001                	nop
    802032d4:	60e2                	ld	ra,24(sp)
    802032d6:	6442                	ld	s0,16(sp)
    802032d8:	6105                	addi	sp,sp,32
    802032da:	8082                	ret

00000000802032dc <freerange>:
static void freerange(void *pa_start, void *pa_end) {
    802032dc:	7179                	addi	sp,sp,-48
    802032de:	f406                	sd	ra,40(sp)
    802032e0:	f022                	sd	s0,32(sp)
    802032e2:	1800                	addi	s0,sp,48
    802032e4:	fca43c23          	sd	a0,-40(s0)
    802032e8:	fcb43823          	sd	a1,-48(s0)
  char *p = (char*)PGROUNDUP((uint64)pa_start);
    802032ec:	fd843703          	ld	a4,-40(s0)
    802032f0:	6785                	lui	a5,0x1
    802032f2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    802032f4:	973e                	add	a4,a4,a5
    802032f6:	77fd                	lui	a5,0xfffff
    802032f8:	8ff9                	and	a5,a5,a4
    802032fa:	fef43423          	sd	a5,-24(s0)
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    802032fe:	a829                	j	80203318 <freerange+0x3c>
    free_page(p);
    80203300:	fe843503          	ld	a0,-24(s0)
    80203304:	00000097          	auipc	ra,0x0
    80203308:	0c4080e7          	jalr	196(ra) # 802033c8 <free_page>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    8020330c:	fe843703          	ld	a4,-24(s0)
    80203310:	6785                	lui	a5,0x1
    80203312:	97ba                	add	a5,a5,a4
    80203314:	fef43423          	sd	a5,-24(s0)
    80203318:	fe843703          	ld	a4,-24(s0)
    8020331c:	6785                	lui	a5,0x1
    8020331e:	97ba                	add	a5,a5,a4
    80203320:	fd043703          	ld	a4,-48(s0)
    80203324:	fcf77ee3          	bgeu	a4,a5,80203300 <freerange+0x24>
}
    80203328:	0001                	nop
    8020332a:	0001                	nop
    8020332c:	70a2                	ld	ra,40(sp)
    8020332e:	7402                	ld	s0,32(sp)
    80203330:	6145                	addi	sp,sp,48
    80203332:	8082                	ret

0000000080203334 <pmm_init>:
void pmm_init(void) {
    80203334:	1141                	addi	sp,sp,-16
    80203336:	e406                	sd	ra,8(sp)
    80203338:	e022                	sd	s0,0(sp)
    8020333a:	0800                	addi	s0,sp,16
  freerange(end, (void*)PHYSTOP);
    8020333c:	47c5                	li	a5,17
    8020333e:	01b79593          	slli	a1,a5,0x1b
    80203342:	00045517          	auipc	a0,0x45
    80203346:	5ee50513          	addi	a0,a0,1518 # 80248930 <_bss_end>
    8020334a:	00000097          	auipc	ra,0x0
    8020334e:	f92080e7          	jalr	-110(ra) # 802032dc <freerange>
}
    80203352:	0001                	nop
    80203354:	60a2                	ld	ra,8(sp)
    80203356:	6402                	ld	s0,0(sp)
    80203358:	0141                	addi	sp,sp,16
    8020335a:	8082                	ret

000000008020335c <alloc_page>:
void* alloc_page(void) {
    8020335c:	1101                	addi	sp,sp,-32
    8020335e:	ec06                	sd	ra,24(sp)
    80203360:	e822                	sd	s0,16(sp)
    80203362:	1000                	addi	s0,sp,32
  struct run *r = freelist;
    80203364:	0003a797          	auipc	a5,0x3a
    80203368:	f1c78793          	addi	a5,a5,-228 # 8023d280 <freelist>
    8020336c:	639c                	ld	a5,0(a5)
    8020336e:	fef43423          	sd	a5,-24(s0)
  if(r)
    80203372:	fe843783          	ld	a5,-24(s0)
    80203376:	cb89                	beqz	a5,80203388 <alloc_page+0x2c>
    freelist = r->next;
    80203378:	fe843783          	ld	a5,-24(s0)
    8020337c:	6398                	ld	a4,0(a5)
    8020337e:	0003a797          	auipc	a5,0x3a
    80203382:	f0278793          	addi	a5,a5,-254 # 8023d280 <freelist>
    80203386:	e398                	sd	a4,0(a5)
  if(r)
    80203388:	fe843783          	ld	a5,-24(s0)
    8020338c:	cf99                	beqz	a5,802033aa <alloc_page+0x4e>
    memset((char*)r + sizeof(struct run), 5, PGSIZE - sizeof(struct run));
    8020338e:	fe843783          	ld	a5,-24(s0)
    80203392:	00878713          	addi	a4,a5,8
    80203396:	6785                	lui	a5,0x1
    80203398:	ff878613          	addi	a2,a5,-8 # ff8 <_entry-0x801ff008>
    8020339c:	4595                	li	a1,5
    8020339e:	853a                	mv	a0,a4
    802033a0:	fffff097          	auipc	ra,0xfffff
    802033a4:	ba4080e7          	jalr	-1116(ra) # 80201f44 <memset>
    802033a8:	a809                	j	802033ba <alloc_page+0x5e>
    panic("alloc_page: out of memory");
    802033aa:	00017517          	auipc	a0,0x17
    802033ae:	69e50513          	addi	a0,a0,1694 # 8021aa48 <user_test_table+0xb8>
    802033b2:	ffffe097          	auipc	ra,0xffffe
    802033b6:	454080e7          	jalr	1108(ra) # 80201806 <panic>
  return (void*)r;
    802033ba:	fe843783          	ld	a5,-24(s0)
}
    802033be:	853e                	mv	a0,a5
    802033c0:	60e2                	ld	ra,24(sp)
    802033c2:	6442                	ld	s0,16(sp)
    802033c4:	6105                	addi	sp,sp,32
    802033c6:	8082                	ret

00000000802033c8 <free_page>:
void free_page(void* page) {
    802033c8:	7179                	addi	sp,sp,-48
    802033ca:	f406                	sd	ra,40(sp)
    802033cc:	f022                	sd	s0,32(sp)
    802033ce:	1800                	addi	s0,sp,48
    802033d0:	fca43c23          	sd	a0,-40(s0)
  struct run *r = (struct run*)page;
    802033d4:	fd843783          	ld	a5,-40(s0)
    802033d8:	fef43423          	sd	a5,-24(s0)
  if(((uint64)page % PGSIZE) != 0 || (char*)page < end || (uint64)page >= PHYSTOP)
    802033dc:	fd843703          	ld	a4,-40(s0)
    802033e0:	6785                	lui	a5,0x1
    802033e2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    802033e4:	8ff9                	and	a5,a5,a4
    802033e6:	ef99                	bnez	a5,80203404 <free_page+0x3c>
    802033e8:	fd843703          	ld	a4,-40(s0)
    802033ec:	00045797          	auipc	a5,0x45
    802033f0:	54478793          	addi	a5,a5,1348 # 80248930 <_bss_end>
    802033f4:	00f76863          	bltu	a4,a5,80203404 <free_page+0x3c>
    802033f8:	fd843703          	ld	a4,-40(s0)
    802033fc:	47c5                	li	a5,17
    802033fe:	07ee                	slli	a5,a5,0x1b
    80203400:	00f76a63          	bltu	a4,a5,80203414 <free_page+0x4c>
    panic("free_page: invalid page address");
    80203404:	00017517          	auipc	a0,0x17
    80203408:	66450513          	addi	a0,a0,1636 # 8021aa68 <user_test_table+0xd8>
    8020340c:	ffffe097          	auipc	ra,0xffffe
    80203410:	3fa080e7          	jalr	1018(ra) # 80201806 <panic>
  r->next = freelist;
    80203414:	0003a797          	auipc	a5,0x3a
    80203418:	e6c78793          	addi	a5,a5,-404 # 8023d280 <freelist>
    8020341c:	6398                	ld	a4,0(a5)
    8020341e:	fe843783          	ld	a5,-24(s0)
    80203422:	e398                	sd	a4,0(a5)
  freelist = r;
    80203424:	0003a797          	auipc	a5,0x3a
    80203428:	e5c78793          	addi	a5,a5,-420 # 8023d280 <freelist>
    8020342c:	fe843703          	ld	a4,-24(s0)
    80203430:	e398                	sd	a4,0(a5)
}
    80203432:	0001                	nop
    80203434:	70a2                	ld	ra,40(sp)
    80203436:	7402                	ld	s0,32(sp)
    80203438:	6145                	addi	sp,sp,48
    8020343a:	8082                	ret

000000008020343c <test_physical_memory>:
void test_physical_memory(void) {
    8020343c:	7179                	addi	sp,sp,-48
    8020343e:	f406                	sd	ra,40(sp)
    80203440:	f022                	sd	s0,32(sp)
    80203442:	1800                	addi	s0,sp,48
    printf("[PM TEST] 分配两个页...\n");
    80203444:	00017517          	auipc	a0,0x17
    80203448:	64450513          	addi	a0,a0,1604 # 8021aa88 <user_test_table+0xf8>
    8020344c:	ffffe097          	auipc	ra,0xffffe
    80203450:	e38080e7          	jalr	-456(ra) # 80201284 <printf>
    void *page1 = alloc_page();
    80203454:	00000097          	auipc	ra,0x0
    80203458:	f08080e7          	jalr	-248(ra) # 8020335c <alloc_page>
    8020345c:	fea43423          	sd	a0,-24(s0)
    void *page2 = alloc_page();
    80203460:	00000097          	auipc	ra,0x0
    80203464:	efc080e7          	jalr	-260(ra) # 8020335c <alloc_page>
    80203468:	fea43023          	sd	a0,-32(s0)
    assert(page1 != 0);
    8020346c:	fe843783          	ld	a5,-24(s0)
    80203470:	00f037b3          	snez	a5,a5
    80203474:	0ff7f793          	zext.b	a5,a5
    80203478:	2781                	sext.w	a5,a5
    8020347a:	853e                	mv	a0,a5
    8020347c:	00000097          	auipc	ra,0x0
    80203480:	e14080e7          	jalr	-492(ra) # 80203290 <assert>
    assert(page2 != 0);
    80203484:	fe043783          	ld	a5,-32(s0)
    80203488:	00f037b3          	snez	a5,a5
    8020348c:	0ff7f793          	zext.b	a5,a5
    80203490:	2781                	sext.w	a5,a5
    80203492:	853e                	mv	a0,a5
    80203494:	00000097          	auipc	ra,0x0
    80203498:	dfc080e7          	jalr	-516(ra) # 80203290 <assert>
    assert(page1 != page2);
    8020349c:	fe843703          	ld	a4,-24(s0)
    802034a0:	fe043783          	ld	a5,-32(s0)
    802034a4:	40f707b3          	sub	a5,a4,a5
    802034a8:	00f037b3          	snez	a5,a5
    802034ac:	0ff7f793          	zext.b	a5,a5
    802034b0:	2781                	sext.w	a5,a5
    802034b2:	853e                	mv	a0,a5
    802034b4:	00000097          	auipc	ra,0x0
    802034b8:	ddc080e7          	jalr	-548(ra) # 80203290 <assert>
    assert(((uint64)page1 & 0xFFF) == 0);
    802034bc:	fe843703          	ld	a4,-24(s0)
    802034c0:	6785                	lui	a5,0x1
    802034c2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    802034c4:	8ff9                	and	a5,a5,a4
    802034c6:	0017b793          	seqz	a5,a5
    802034ca:	0ff7f793          	zext.b	a5,a5
    802034ce:	2781                	sext.w	a5,a5
    802034d0:	853e                	mv	a0,a5
    802034d2:	00000097          	auipc	ra,0x0
    802034d6:	dbe080e7          	jalr	-578(ra) # 80203290 <assert>
    assert(((uint64)page2 & 0xFFF) == 0);
    802034da:	fe043703          	ld	a4,-32(s0)
    802034de:	6785                	lui	a5,0x1
    802034e0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    802034e2:	8ff9                	and	a5,a5,a4
    802034e4:	0017b793          	seqz	a5,a5
    802034e8:	0ff7f793          	zext.b	a5,a5
    802034ec:	2781                	sext.w	a5,a5
    802034ee:	853e                	mv	a0,a5
    802034f0:	00000097          	auipc	ra,0x0
    802034f4:	da0080e7          	jalr	-608(ra) # 80203290 <assert>
    printf("[PM TEST] 分配测试通过\n");
    802034f8:	00017517          	auipc	a0,0x17
    802034fc:	5b050513          	addi	a0,a0,1456 # 8021aaa8 <user_test_table+0x118>
    80203500:	ffffe097          	auipc	ra,0xffffe
    80203504:	d84080e7          	jalr	-636(ra) # 80201284 <printf>
    printf("[PM TEST] 数据写入测试...\n");
    80203508:	00017517          	auipc	a0,0x17
    8020350c:	5c050513          	addi	a0,a0,1472 # 8021aac8 <user_test_table+0x138>
    80203510:	ffffe097          	auipc	ra,0xffffe
    80203514:	d74080e7          	jalr	-652(ra) # 80201284 <printf>
    *(int*)page1 = 0x12345678;
    80203518:	fe843783          	ld	a5,-24(s0)
    8020351c:	12345737          	lui	a4,0x12345
    80203520:	67870713          	addi	a4,a4,1656 # 12345678 <_entry-0x6deba988>
    80203524:	c398                	sw	a4,0(a5)
    assert(*(int*)page1 == 0x12345678);
    80203526:	fe843783          	ld	a5,-24(s0)
    8020352a:	439c                	lw	a5,0(a5)
    8020352c:	873e                	mv	a4,a5
    8020352e:	123457b7          	lui	a5,0x12345
    80203532:	67878793          	addi	a5,a5,1656 # 12345678 <_entry-0x6deba988>
    80203536:	40f707b3          	sub	a5,a4,a5
    8020353a:	0017b793          	seqz	a5,a5
    8020353e:	0ff7f793          	zext.b	a5,a5
    80203542:	2781                	sext.w	a5,a5
    80203544:	853e                	mv	a0,a5
    80203546:	00000097          	auipc	ra,0x0
    8020354a:	d4a080e7          	jalr	-694(ra) # 80203290 <assert>
    printf("[PM TEST] 数据写入测试通过\n");
    8020354e:	00017517          	auipc	a0,0x17
    80203552:	5a250513          	addi	a0,a0,1442 # 8021aaf0 <user_test_table+0x160>
    80203556:	ffffe097          	auipc	ra,0xffffe
    8020355a:	d2e080e7          	jalr	-722(ra) # 80201284 <printf>
    printf("[PM TEST] 释放与重新分配测试...\n");
    8020355e:	00017517          	auipc	a0,0x17
    80203562:	5ba50513          	addi	a0,a0,1466 # 8021ab18 <user_test_table+0x188>
    80203566:	ffffe097          	auipc	ra,0xffffe
    8020356a:	d1e080e7          	jalr	-738(ra) # 80201284 <printf>
    free_page(page1);
    8020356e:	fe843503          	ld	a0,-24(s0)
    80203572:	00000097          	auipc	ra,0x0
    80203576:	e56080e7          	jalr	-426(ra) # 802033c8 <free_page>
    void *page3 = alloc_page();
    8020357a:	00000097          	auipc	ra,0x0
    8020357e:	de2080e7          	jalr	-542(ra) # 8020335c <alloc_page>
    80203582:	fca43c23          	sd	a0,-40(s0)
    assert(page3 != 0);
    80203586:	fd843783          	ld	a5,-40(s0)
    8020358a:	00f037b3          	snez	a5,a5
    8020358e:	0ff7f793          	zext.b	a5,a5
    80203592:	2781                	sext.w	a5,a5
    80203594:	853e                	mv	a0,a5
    80203596:	00000097          	auipc	ra,0x0
    8020359a:	cfa080e7          	jalr	-774(ra) # 80203290 <assert>
    printf("[PM TEST] 释放与重新分配测试通过\n");
    8020359e:	00017517          	auipc	a0,0x17
    802035a2:	5aa50513          	addi	a0,a0,1450 # 8021ab48 <user_test_table+0x1b8>
    802035a6:	ffffe097          	auipc	ra,0xffffe
    802035aa:	cde080e7          	jalr	-802(ra) # 80201284 <printf>
    free_page(page2);
    802035ae:	fe043503          	ld	a0,-32(s0)
    802035b2:	00000097          	auipc	ra,0x0
    802035b6:	e16080e7          	jalr	-490(ra) # 802033c8 <free_page>
    free_page(page3);
    802035ba:	fd843503          	ld	a0,-40(s0)
    802035be:	00000097          	auipc	ra,0x0
    802035c2:	e0a080e7          	jalr	-502(ra) # 802033c8 <free_page>
    printf("[PM TEST] 所有物理内存管理测试通过\n");
    802035c6:	00017517          	auipc	a0,0x17
    802035ca:	5b250513          	addi	a0,a0,1458 # 8021ab78 <user_test_table+0x1e8>
    802035ce:	ffffe097          	auipc	ra,0xffffe
    802035d2:	cb6080e7          	jalr	-842(ra) # 80201284 <printf>
    802035d6:	0001                	nop
    802035d8:	70a2                	ld	ra,40(sp)
    802035da:	7402                	ld	s0,32(sp)
    802035dc:	6145                	addi	sp,sp,48
    802035de:	8082                	ret

00000000802035e0 <sbi_set_time>:
#include "defs.h"

void sbi_set_time(uint64 time) {
    802035e0:	1101                	addi	sp,sp,-32
    802035e2:	ec22                	sd	s0,24(sp)
    802035e4:	1000                	addi	s0,sp,32
    802035e6:	fea43423          	sd	a0,-24(s0)
    register uint64 a0 asm("a0") = time;
    802035ea:	fe843503          	ld	a0,-24(s0)
    register uint64 a7 asm("a7") = SBI_SET_TIME;
    802035ee:	4881                	li	a7,0
    asm volatile ("ecall"
    802035f0:	00000073          	ecall
                  : "+r"(a0)
                  : "r"(a7)
                  : "memory");
}
    802035f4:	0001                	nop
    802035f6:	6462                	ld	s0,24(sp)
    802035f8:	6105                	addi	sp,sp,32
    802035fa:	8082                	ret

00000000802035fc <sbi_get_time>:
// 直接读取 time CSR 寄存器获取当前时间
uint64 sbi_get_time(void) {
    802035fc:	1101                	addi	sp,sp,-32
    802035fe:	ec22                	sd	s0,24(sp)
    80203600:	1000                	addi	s0,sp,32
    uint64 time_value;
    
    asm volatile ("rdtime %0" : "=r"(time_value));
    80203602:	c01027f3          	rdtime	a5
    80203606:	fef43423          	sd	a5,-24(s0)
    
    return time_value;
    8020360a:	fe843783          	ld	a5,-24(s0)
    8020360e:	853e                	mv	a0,a5
    80203610:	6462                	ld	s0,24(sp)
    80203612:	6105                	addi	sp,sp,32
    80203614:	8082                	ret

0000000080203616 <timeintr>:
#include "defs.h"

// 声明外部测试标志
extern volatile int *interrupt_test_flag;
void timeintr(void){
    80203616:	1141                	addi	sp,sp,-16
    80203618:	e422                	sd	s0,8(sp)
    8020361a:	0800                	addi	s0,sp,16
	if (interrupt_test_flag)
    8020361c:	0003a797          	auipc	a5,0x3a
    80203620:	abc78793          	addi	a5,a5,-1348 # 8023d0d8 <interrupt_test_flag>
    80203624:	639c                	ld	a5,0(a5)
    80203626:	cb99                	beqz	a5,8020363c <timeintr+0x26>
        (*interrupt_test_flag)++;
    80203628:	0003a797          	auipc	a5,0x3a
    8020362c:	ab078793          	addi	a5,a5,-1360 # 8023d0d8 <interrupt_test_flag>
    80203630:	639c                	ld	a5,0(a5)
    80203632:	4398                	lw	a4,0(a5)
    80203634:	2701                	sext.w	a4,a4
    80203636:	2705                	addiw	a4,a4,1
    80203638:	2701                	sext.w	a4,a4
    8020363a:	c398                	sw	a4,0(a5)
    8020363c:	0001                	nop
    8020363e:	6422                	ld	s0,8(sp)
    80203640:	0141                	addi	sp,sp,16
    80203642:	8082                	ret

0000000080203644 <r_sie>:
    80203644:	1101                	addi	sp,sp,-32
    80203646:	ec22                	sd	s0,24(sp)
    80203648:	1000                	addi	s0,sp,32
    8020364a:	104027f3          	csrr	a5,sie
    8020364e:	fef43423          	sd	a5,-24(s0)
    80203652:	fe843783          	ld	a5,-24(s0)
    80203656:	853e                	mv	a0,a5
    80203658:	6462                	ld	s0,24(sp)
    8020365a:	6105                	addi	sp,sp,32
    8020365c:	8082                	ret

000000008020365e <w_sie>:
    8020365e:	1101                	addi	sp,sp,-32
    80203660:	ec22                	sd	s0,24(sp)
    80203662:	1000                	addi	s0,sp,32
    80203664:	fea43423          	sd	a0,-24(s0)
    80203668:	fe843783          	ld	a5,-24(s0)
    8020366c:	10479073          	csrw	sie,a5
    80203670:	0001                	nop
    80203672:	6462                	ld	s0,24(sp)
    80203674:	6105                	addi	sp,sp,32
    80203676:	8082                	ret

0000000080203678 <r_sstatus>:
    80203678:	1101                	addi	sp,sp,-32
    8020367a:	ec22                	sd	s0,24(sp)
    8020367c:	1000                	addi	s0,sp,32
    8020367e:	100027f3          	csrr	a5,sstatus
    80203682:	fef43423          	sd	a5,-24(s0)
    80203686:	fe843783          	ld	a5,-24(s0)
    8020368a:	853e                	mv	a0,a5
    8020368c:	6462                	ld	s0,24(sp)
    8020368e:	6105                	addi	sp,sp,32
    80203690:	8082                	ret

0000000080203692 <w_sstatus>:
    80203692:	1101                	addi	sp,sp,-32
    80203694:	ec22                	sd	s0,24(sp)
    80203696:	1000                	addi	s0,sp,32
    80203698:	fea43423          	sd	a0,-24(s0)
    8020369c:	fe843783          	ld	a5,-24(s0)
    802036a0:	10079073          	csrw	sstatus,a5
    802036a4:	0001                	nop
    802036a6:	6462                	ld	s0,24(sp)
    802036a8:	6105                	addi	sp,sp,32
    802036aa:	8082                	ret

00000000802036ac <w_sscratch>:
    802036ac:	1101                	addi	sp,sp,-32
    802036ae:	ec22                	sd	s0,24(sp)
    802036b0:	1000                	addi	s0,sp,32
    802036b2:	fea43423          	sd	a0,-24(s0)
    802036b6:	fe843783          	ld	a5,-24(s0)
    802036ba:	14079073          	csrw	sscratch,a5
    802036be:	0001                	nop
    802036c0:	6462                	ld	s0,24(sp)
    802036c2:	6105                	addi	sp,sp,32
    802036c4:	8082                	ret

00000000802036c6 <w_sepc>:
    802036c6:	1101                	addi	sp,sp,-32
    802036c8:	ec22                	sd	s0,24(sp)
    802036ca:	1000                	addi	s0,sp,32
    802036cc:	fea43423          	sd	a0,-24(s0)
    802036d0:	fe843783          	ld	a5,-24(s0)
    802036d4:	14179073          	csrw	sepc,a5
    802036d8:	0001                	nop
    802036da:	6462                	ld	s0,24(sp)
    802036dc:	6105                	addi	sp,sp,32
    802036de:	8082                	ret

00000000802036e0 <intr_off>:
    802036e0:	1141                	addi	sp,sp,-16
    802036e2:	e406                	sd	ra,8(sp)
    802036e4:	e022                	sd	s0,0(sp)
    802036e6:	0800                	addi	s0,sp,16
    802036e8:	00000097          	auipc	ra,0x0
    802036ec:	f90080e7          	jalr	-112(ra) # 80203678 <r_sstatus>
    802036f0:	87aa                	mv	a5,a0
    802036f2:	9bf5                	andi	a5,a5,-3
    802036f4:	853e                	mv	a0,a5
    802036f6:	00000097          	auipc	ra,0x0
    802036fa:	f9c080e7          	jalr	-100(ra) # 80203692 <w_sstatus>
    802036fe:	0001                	nop
    80203700:	60a2                	ld	ra,8(sp)
    80203702:	6402                	ld	s0,0(sp)
    80203704:	0141                	addi	sp,sp,16
    80203706:	8082                	ret

0000000080203708 <w_stvec>:
    80203708:	1101                	addi	sp,sp,-32
    8020370a:	ec22                	sd	s0,24(sp)
    8020370c:	1000                	addi	s0,sp,32
    8020370e:	fea43423          	sd	a0,-24(s0)
    80203712:	fe843783          	ld	a5,-24(s0)
    80203716:	10579073          	csrw	stvec,a5
    8020371a:	0001                	nop
    8020371c:	6462                	ld	s0,24(sp)
    8020371e:	6105                	addi	sp,sp,32
    80203720:	8082                	ret

0000000080203722 <r_scause>:
    80203722:	1101                	addi	sp,sp,-32
    80203724:	ec22                	sd	s0,24(sp)
    80203726:	1000                	addi	s0,sp,32
    80203728:	142027f3          	csrr	a5,scause
    8020372c:	fef43423          	sd	a5,-24(s0)
    80203730:	fe843783          	ld	a5,-24(s0)
    80203734:	853e                	mv	a0,a5
    80203736:	6462                	ld	s0,24(sp)
    80203738:	6105                	addi	sp,sp,32
    8020373a:	8082                	ret

000000008020373c <r_sepc>:
    8020373c:	1101                	addi	sp,sp,-32
    8020373e:	ec22                	sd	s0,24(sp)
    80203740:	1000                	addi	s0,sp,32
    80203742:	141027f3          	csrr	a5,sepc
    80203746:	fef43423          	sd	a5,-24(s0)
    8020374a:	fe843783          	ld	a5,-24(s0)
    8020374e:	853e                	mv	a0,a5
    80203750:	6462                	ld	s0,24(sp)
    80203752:	6105                	addi	sp,sp,32
    80203754:	8082                	ret

0000000080203756 <r_stval>:
    80203756:	1101                	addi	sp,sp,-32
    80203758:	ec22                	sd	s0,24(sp)
    8020375a:	1000                	addi	s0,sp,32
    8020375c:	143027f3          	csrr	a5,stval
    80203760:	fef43423          	sd	a5,-24(s0)
    80203764:	fe843783          	ld	a5,-24(s0)
    80203768:	853e                	mv	a0,a5
    8020376a:	6462                	ld	s0,24(sp)
    8020376c:	6105                	addi	sp,sp,32
    8020376e:	8082                	ret

0000000080203770 <save_exception_info>:
static inline void save_exception_info(struct trapframe *tf, uint64 sepc, uint64 sstatus, uint64 scause, uint64 stval) {
    80203770:	7139                	addi	sp,sp,-64
    80203772:	fc22                	sd	s0,56(sp)
    80203774:	0080                	addi	s0,sp,64
    80203776:	fea43423          	sd	a0,-24(s0)
    8020377a:	feb43023          	sd	a1,-32(s0)
    8020377e:	fcc43c23          	sd	a2,-40(s0)
    80203782:	fcd43823          	sd	a3,-48(s0)
    80203786:	fce43423          	sd	a4,-56(s0)
    tf->epc = sepc;
    8020378a:	fe843783          	ld	a5,-24(s0)
    8020378e:	fe043703          	ld	a4,-32(s0)
    80203792:	ff98                	sd	a4,56(a5)
}
    80203794:	0001                	nop
    80203796:	7462                	ld	s0,56(sp)
    80203798:	6121                	addi	sp,sp,64
    8020379a:	8082                	ret

000000008020379c <get_sepc>:
static inline uint64 get_sepc(struct trapframe *tf) {
    8020379c:	1101                	addi	sp,sp,-32
    8020379e:	ec22                	sd	s0,24(sp)
    802037a0:	1000                	addi	s0,sp,32
    802037a2:	fea43423          	sd	a0,-24(s0)
    return tf->epc;
    802037a6:	fe843783          	ld	a5,-24(s0)
    802037aa:	7f9c                	ld	a5,56(a5)
}
    802037ac:	853e                	mv	a0,a5
    802037ae:	6462                	ld	s0,24(sp)
    802037b0:	6105                	addi	sp,sp,32
    802037b2:	8082                	ret

00000000802037b4 <set_sepc>:
static inline void set_sepc(struct trapframe *tf, uint64 sepc) {
    802037b4:	1101                	addi	sp,sp,-32
    802037b6:	ec22                	sd	s0,24(sp)
    802037b8:	1000                	addi	s0,sp,32
    802037ba:	fea43423          	sd	a0,-24(s0)
    802037be:	feb43023          	sd	a1,-32(s0)
    tf->epc = sepc;
    802037c2:	fe843783          	ld	a5,-24(s0)
    802037c6:	fe043703          	ld	a4,-32(s0)
    802037ca:	ff98                	sd	a4,56(a5)
}
    802037cc:	0001                	nop
    802037ce:	6462                	ld	s0,24(sp)
    802037d0:	6105                	addi	sp,sp,32
    802037d2:	8082                	ret

00000000802037d4 <register_interrupt>:
void register_interrupt(int irq, interrupt_handler_t h) {
    802037d4:	1101                	addi	sp,sp,-32
    802037d6:	ec22                	sd	s0,24(sp)
    802037d8:	1000                	addi	s0,sp,32
    802037da:	87aa                	mv	a5,a0
    802037dc:	feb43023          	sd	a1,-32(s0)
    802037e0:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ){
    802037e4:	fec42783          	lw	a5,-20(s0)
    802037e8:	2781                	sext.w	a5,a5
    802037ea:	0207c563          	bltz	a5,80203814 <register_interrupt+0x40>
    802037ee:	fec42783          	lw	a5,-20(s0)
    802037f2:	0007871b          	sext.w	a4,a5
    802037f6:	03f00793          	li	a5,63
    802037fa:	00e7cd63          	blt	a5,a4,80203814 <register_interrupt+0x40>
        interrupt_vector[irq] = h;
    802037fe:	0003a717          	auipc	a4,0x3a
    80203802:	a8a70713          	addi	a4,a4,-1398 # 8023d288 <interrupt_vector>
    80203806:	fec42783          	lw	a5,-20(s0)
    8020380a:	078e                	slli	a5,a5,0x3
    8020380c:	97ba                	add	a5,a5,a4
    8020380e:	fe043703          	ld	a4,-32(s0)
    80203812:	e398                	sd	a4,0(a5)
}
    80203814:	0001                	nop
    80203816:	6462                	ld	s0,24(sp)
    80203818:	6105                	addi	sp,sp,32
    8020381a:	8082                	ret

000000008020381c <unregister_interrupt>:
void unregister_interrupt(int irq) {
    8020381c:	1101                	addi	sp,sp,-32
    8020381e:	ec22                	sd	s0,24(sp)
    80203820:	1000                	addi	s0,sp,32
    80203822:	87aa                	mv	a5,a0
    80203824:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ)
    80203828:	fec42783          	lw	a5,-20(s0)
    8020382c:	2781                	sext.w	a5,a5
    8020382e:	0207c463          	bltz	a5,80203856 <unregister_interrupt+0x3a>
    80203832:	fec42783          	lw	a5,-20(s0)
    80203836:	0007871b          	sext.w	a4,a5
    8020383a:	03f00793          	li	a5,63
    8020383e:	00e7cc63          	blt	a5,a4,80203856 <unregister_interrupt+0x3a>
        interrupt_vector[irq] = 0;
    80203842:	0003a717          	auipc	a4,0x3a
    80203846:	a4670713          	addi	a4,a4,-1466 # 8023d288 <interrupt_vector>
    8020384a:	fec42783          	lw	a5,-20(s0)
    8020384e:	078e                	slli	a5,a5,0x3
    80203850:	97ba                	add	a5,a5,a4
    80203852:	0007b023          	sd	zero,0(a5)
}
    80203856:	0001                	nop
    80203858:	6462                	ld	s0,24(sp)
    8020385a:	6105                	addi	sp,sp,32
    8020385c:	8082                	ret

000000008020385e <enable_interrupts>:
void enable_interrupts(int irq) {
    8020385e:	1101                	addi	sp,sp,-32
    80203860:	ec06                	sd	ra,24(sp)
    80203862:	e822                	sd	s0,16(sp)
    80203864:	1000                	addi	s0,sp,32
    80203866:	87aa                	mv	a5,a0
    80203868:	fef42623          	sw	a5,-20(s0)
    plic_enable(irq);
    8020386c:	fec42783          	lw	a5,-20(s0)
    80203870:	853e                	mv	a0,a5
    80203872:	00001097          	auipc	ra,0x1
    80203876:	390080e7          	jalr	912(ra) # 80204c02 <plic_enable>
}
    8020387a:	0001                	nop
    8020387c:	60e2                	ld	ra,24(sp)
    8020387e:	6442                	ld	s0,16(sp)
    80203880:	6105                	addi	sp,sp,32
    80203882:	8082                	ret

0000000080203884 <disable_interrupts>:
void disable_interrupts(int irq) {
    80203884:	1101                	addi	sp,sp,-32
    80203886:	ec06                	sd	ra,24(sp)
    80203888:	e822                	sd	s0,16(sp)
    8020388a:	1000                	addi	s0,sp,32
    8020388c:	87aa                	mv	a5,a0
    8020388e:	fef42623          	sw	a5,-20(s0)
    plic_disable(irq);
    80203892:	fec42783          	lw	a5,-20(s0)
    80203896:	853e                	mv	a0,a5
    80203898:	00001097          	auipc	ra,0x1
    8020389c:	3c2080e7          	jalr	962(ra) # 80204c5a <plic_disable>
}
    802038a0:	0001                	nop
    802038a2:	60e2                	ld	ra,24(sp)
    802038a4:	6442                	ld	s0,16(sp)
    802038a6:	6105                	addi	sp,sp,32
    802038a8:	8082                	ret

00000000802038aa <interrupt_dispatch>:
void interrupt_dispatch(int irq) {
    802038aa:	1101                	addi	sp,sp,-32
    802038ac:	ec06                	sd	ra,24(sp)
    802038ae:	e822                	sd	s0,16(sp)
    802038b0:	1000                	addi	s0,sp,32
    802038b2:	87aa                	mv	a5,a0
    802038b4:	fef42623          	sw	a5,-20(s0)
	if (irq >= 0 && irq < MAX_IRQ && interrupt_vector[irq]){
    802038b8:	fec42783          	lw	a5,-20(s0)
    802038bc:	2781                	sext.w	a5,a5
    802038be:	0207ce63          	bltz	a5,802038fa <interrupt_dispatch+0x50>
    802038c2:	fec42783          	lw	a5,-20(s0)
    802038c6:	0007871b          	sext.w	a4,a5
    802038ca:	03f00793          	li	a5,63
    802038ce:	02e7c663          	blt	a5,a4,802038fa <interrupt_dispatch+0x50>
    802038d2:	0003a717          	auipc	a4,0x3a
    802038d6:	9b670713          	addi	a4,a4,-1610 # 8023d288 <interrupt_vector>
    802038da:	fec42783          	lw	a5,-20(s0)
    802038de:	078e                	slli	a5,a5,0x3
    802038e0:	97ba                	add	a5,a5,a4
    802038e2:	639c                	ld	a5,0(a5)
    802038e4:	cb99                	beqz	a5,802038fa <interrupt_dispatch+0x50>
		interrupt_vector[irq]();
    802038e6:	0003a717          	auipc	a4,0x3a
    802038ea:	9a270713          	addi	a4,a4,-1630 # 8023d288 <interrupt_vector>
    802038ee:	fec42783          	lw	a5,-20(s0)
    802038f2:	078e                	slli	a5,a5,0x3
    802038f4:	97ba                	add	a5,a5,a4
    802038f6:	639c                	ld	a5,0(a5)
    802038f8:	9782                	jalr	a5
}
    802038fa:	0001                	nop
    802038fc:	60e2                	ld	ra,24(sp)
    802038fe:	6442                	ld	s0,16(sp)
    80203900:	6105                	addi	sp,sp,32
    80203902:	8082                	ret

0000000080203904 <handle_external_interrupt>:
void handle_external_interrupt(void) {
    80203904:	1101                	addi	sp,sp,-32
    80203906:	ec06                	sd	ra,24(sp)
    80203908:	e822                	sd	s0,16(sp)
    8020390a:	1000                	addi	s0,sp,32
    int irq = plic_claim();
    8020390c:	00001097          	auipc	ra,0x1
    80203910:	3ac080e7          	jalr	940(ra) # 80204cb8 <plic_claim>
    80203914:	87aa                	mv	a5,a0
    80203916:	fef42623          	sw	a5,-20(s0)
    if (irq == 0) {
    8020391a:	fec42783          	lw	a5,-20(s0)
    8020391e:	2781                	sext.w	a5,a5
    80203920:	eb91                	bnez	a5,80203934 <handle_external_interrupt+0x30>
        printf("Spurious external interrupt\n");
    80203922:	0001d517          	auipc	a0,0x1d
    80203926:	49650513          	addi	a0,a0,1174 # 80220db8 <user_test_table+0x78>
    8020392a:	ffffe097          	auipc	ra,0xffffe
    8020392e:	95a080e7          	jalr	-1702(ra) # 80201284 <printf>
        return;
    80203932:	a839                	j	80203950 <handle_external_interrupt+0x4c>
    interrupt_dispatch(irq);
    80203934:	fec42783          	lw	a5,-20(s0)
    80203938:	853e                	mv	a0,a5
    8020393a:	00000097          	auipc	ra,0x0
    8020393e:	f70080e7          	jalr	-144(ra) # 802038aa <interrupt_dispatch>
    plic_complete(irq);
    80203942:	fec42783          	lw	a5,-20(s0)
    80203946:	853e                	mv	a0,a5
    80203948:	00001097          	auipc	ra,0x1
    8020394c:	398080e7          	jalr	920(ra) # 80204ce0 <plic_complete>
}
    80203950:	60e2                	ld	ra,24(sp)
    80203952:	6442                	ld	s0,16(sp)
    80203954:	6105                	addi	sp,sp,32
    80203956:	8082                	ret

0000000080203958 <trap_init>:
void trap_init(void) {
    80203958:	1101                	addi	sp,sp,-32
    8020395a:	ec06                	sd	ra,24(sp)
    8020395c:	e822                	sd	s0,16(sp)
    8020395e:	1000                	addi	s0,sp,32
	intr_off();
    80203960:	00000097          	auipc	ra,0x0
    80203964:	d80080e7          	jalr	-640(ra) # 802036e0 <intr_off>
	printf("trap_init...\n");
    80203968:	0001d517          	auipc	a0,0x1d
    8020396c:	47050513          	addi	a0,a0,1136 # 80220dd8 <user_test_table+0x98>
    80203970:	ffffe097          	auipc	ra,0xffffe
    80203974:	914080e7          	jalr	-1772(ra) # 80201284 <printf>
	w_stvec((uint64)kernelvec);
    80203978:	00001797          	auipc	a5,0x1
    8020397c:	39878793          	addi	a5,a5,920 # 80204d10 <kernelvec>
    80203980:	853e                	mv	a0,a5
    80203982:	00000097          	auipc	ra,0x0
    80203986:	d86080e7          	jalr	-634(ra) # 80203708 <w_stvec>
	for(int i = 0; i < MAX_IRQ; i++){
    8020398a:	fe042623          	sw	zero,-20(s0)
    8020398e:	a005                	j	802039ae <trap_init+0x56>
		interrupt_vector[i] = 0;
    80203990:	0003a717          	auipc	a4,0x3a
    80203994:	8f870713          	addi	a4,a4,-1800 # 8023d288 <interrupt_vector>
    80203998:	fec42783          	lw	a5,-20(s0)
    8020399c:	078e                	slli	a5,a5,0x3
    8020399e:	97ba                	add	a5,a5,a4
    802039a0:	0007b023          	sd	zero,0(a5)
	for(int i = 0; i < MAX_IRQ; i++){
    802039a4:	fec42783          	lw	a5,-20(s0)
    802039a8:	2785                	addiw	a5,a5,1
    802039aa:	fef42623          	sw	a5,-20(s0)
    802039ae:	fec42783          	lw	a5,-20(s0)
    802039b2:	0007871b          	sext.w	a4,a5
    802039b6:	03f00793          	li	a5,63
    802039ba:	fce7dbe3          	bge	a5,a4,80203990 <trap_init+0x38>
	plic_init();// 初始化PLIC（外部中断控制器）
    802039be:	00001097          	auipc	ra,0x1
    802039c2:	1a6080e7          	jalr	422(ra) # 80204b64 <plic_init>
    uint64 sie = r_sie();
    802039c6:	00000097          	auipc	ra,0x0
    802039ca:	c7e080e7          	jalr	-898(ra) # 80203644 <r_sie>
    802039ce:	fea43023          	sd	a0,-32(s0)
    w_sie(sie | (1L << 5) | (1L<<9)); // 设置SIE.STIE位启用时钟中断和外部中断
    802039d2:	fe043783          	ld	a5,-32(s0)
    802039d6:	2207e793          	ori	a5,a5,544
    802039da:	853e                	mv	a0,a5
    802039dc:	00000097          	auipc	ra,0x0
    802039e0:	c82080e7          	jalr	-894(ra) # 8020365e <w_sie>
	sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    802039e4:	00000097          	auipc	ra,0x0
    802039e8:	c18080e7          	jalr	-1000(ra) # 802035fc <sbi_get_time>
    802039ec:	872a                	mv	a4,a0
    802039ee:	000f47b7          	lui	a5,0xf4
    802039f2:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    802039f6:	97ba                	add	a5,a5,a4
    802039f8:	853e                	mv	a0,a5
    802039fa:	00000097          	auipc	ra,0x0
    802039fe:	be6080e7          	jalr	-1050(ra) # 802035e0 <sbi_set_time>
	register_interrupt(VIRTIO0_IRQ, virtio_disk_intr); //设置VIRTIO0中断
    80203a02:	00005597          	auipc	a1,0x5
    80203a06:	22c58593          	addi	a1,a1,556 # 80208c2e <virtio_disk_intr>
    80203a0a:	4505                	li	a0,1
    80203a0c:	00000097          	auipc	ra,0x0
    80203a10:	dc8080e7          	jalr	-568(ra) # 802037d4 <register_interrupt>
	printf("Registered exception handlers: store_page_fault=%p\n", handle_store_page_fault);
    80203a14:	00001597          	auipc	a1,0x1
    80203a18:	e8058593          	addi	a1,a1,-384 # 80204894 <handle_store_page_fault>
    80203a1c:	0001d517          	auipc	a0,0x1d
    80203a20:	3cc50513          	addi	a0,a0,972 # 80220de8 <user_test_table+0xa8>
    80203a24:	ffffe097          	auipc	ra,0xffffe
    80203a28:	860080e7          	jalr	-1952(ra) # 80201284 <printf>
	printf("trap_init complete.\n");
    80203a2c:	0001d517          	auipc	a0,0x1d
    80203a30:	3f450513          	addi	a0,a0,1012 # 80220e20 <user_test_table+0xe0>
    80203a34:	ffffe097          	auipc	ra,0xffffe
    80203a38:	850080e7          	jalr	-1968(ra) # 80201284 <printf>
}
    80203a3c:	0001                	nop
    80203a3e:	60e2                	ld	ra,24(sp)
    80203a40:	6442                	ld	s0,16(sp)
    80203a42:	6105                	addi	sp,sp,32
    80203a44:	8082                	ret

0000000080203a46 <kerneltrap>:
void kerneltrap(void) {
    80203a46:	7165                	addi	sp,sp,-400
    80203a48:	e706                	sd	ra,392(sp)
    80203a4a:	e322                	sd	s0,384(sp)
    80203a4c:	0b00                	addi	s0,sp,400
    uint64 sstatus = r_sstatus();
    80203a4e:	00000097          	auipc	ra,0x0
    80203a52:	c2a080e7          	jalr	-982(ra) # 80203678 <r_sstatus>
    80203a56:	fea43023          	sd	a0,-32(s0)
    uint64 scause = r_scause();
    80203a5a:	00000097          	auipc	ra,0x0
    80203a5e:	cc8080e7          	jalr	-824(ra) # 80203722 <r_scause>
    80203a62:	fca43c23          	sd	a0,-40(s0)
    uint64 sepc = r_sepc();
    80203a66:	00000097          	auipc	ra,0x0
    80203a6a:	cd6080e7          	jalr	-810(ra) # 8020373c <r_sepc>
    80203a6e:	fea43423          	sd	a0,-24(s0)
    uint64 stval = r_stval();
    80203a72:	00000097          	auipc	ra,0x0
    80203a76:	ce4080e7          	jalr	-796(ra) # 80203756 <r_stval>
    80203a7a:	fca43823          	sd	a0,-48(s0)
    if(scause & 0x8000000000000000) {
    80203a7e:	fd843783          	ld	a5,-40(s0)
    80203a82:	0807da63          	bgez	a5,80203b16 <kerneltrap+0xd0>
        if((scause & 0xff) == 5) {
    80203a86:	fd843783          	ld	a5,-40(s0)
    80203a8a:	0ff7f713          	zext.b	a4,a5
    80203a8e:	4795                	li	a5,5
    80203a90:	04f71a63          	bne	a4,a5,80203ae4 <kerneltrap+0x9e>
            timeintr();
    80203a94:	00000097          	auipc	ra,0x0
    80203a98:	b82080e7          	jalr	-1150(ra) # 80203616 <timeintr>
            sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    80203a9c:	00000097          	auipc	ra,0x0
    80203aa0:	b60080e7          	jalr	-1184(ra) # 802035fc <sbi_get_time>
    80203aa4:	872a                	mv	a4,a0
    80203aa6:	000f47b7          	lui	a5,0xf4
    80203aaa:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    80203aae:	97ba                	add	a5,a5,a4
    80203ab0:	853e                	mv	a0,a5
    80203ab2:	00000097          	auipc	ra,0x0
    80203ab6:	b2e080e7          	jalr	-1234(ra) # 802035e0 <sbi_set_time>
			if(myproc() && myproc()->state == RUNNING) {
    80203aba:	00001097          	auipc	ra,0x1
    80203abe:	5a6080e7          	jalr	1446(ra) # 80205060 <myproc>
    80203ac2:	87aa                	mv	a5,a0
    80203ac4:	cbe9                	beqz	a5,80203b96 <kerneltrap+0x150>
    80203ac6:	00001097          	auipc	ra,0x1
    80203aca:	59a080e7          	jalr	1434(ra) # 80205060 <myproc>
    80203ace:	87aa                	mv	a5,a0
    80203ad0:	439c                	lw	a5,0(a5)
    80203ad2:	873e                	mv	a4,a5
    80203ad4:	4791                	li	a5,4
    80203ad6:	0cf71063          	bne	a4,a5,80203b96 <kerneltrap+0x150>
				yield();  // 当前进程让出 CPU
    80203ada:	00002097          	auipc	ra,0x2
    80203ade:	202080e7          	jalr	514(ra) # 80205cdc <yield>
    80203ae2:	a855                	j	80203b96 <kerneltrap+0x150>
        } else if((scause & 0xff) == 9) {
    80203ae4:	fd843783          	ld	a5,-40(s0)
    80203ae8:	0ff7f713          	zext.b	a4,a5
    80203aec:	47a5                	li	a5,9
    80203aee:	00f71763          	bne	a4,a5,80203afc <kerneltrap+0xb6>
            handle_external_interrupt();
    80203af2:	00000097          	auipc	ra,0x0
    80203af6:	e12080e7          	jalr	-494(ra) # 80203904 <handle_external_interrupt>
    80203afa:	a871                	j	80203b96 <kerneltrap+0x150>
            printf("kerneltrap: unknown interrupt scause=%lx sepc=%lx\n", scause, sepc);
    80203afc:	fe843603          	ld	a2,-24(s0)
    80203b00:	fd843583          	ld	a1,-40(s0)
    80203b04:	0001d517          	auipc	a0,0x1d
    80203b08:	33450513          	addi	a0,a0,820 # 80220e38 <user_test_table+0xf8>
    80203b0c:	ffffd097          	auipc	ra,0xffffd
    80203b10:	778080e7          	jalr	1912(ra) # 80201284 <printf>
    80203b14:	a049                	j	80203b96 <kerneltrap+0x150>
        printf("Exception: scause=%ld, sepc=0x%lx, stval=0x%lx\n", scause, sepc, stval);
    80203b16:	fd043683          	ld	a3,-48(s0)
    80203b1a:	fe843603          	ld	a2,-24(s0)
    80203b1e:	fd843583          	ld	a1,-40(s0)
    80203b22:	0001d517          	auipc	a0,0x1d
    80203b26:	34e50513          	addi	a0,a0,846 # 80220e70 <user_test_table+0x130>
    80203b2a:	ffffd097          	auipc	ra,0xffffd
    80203b2e:	75a080e7          	jalr	1882(ra) # 80201284 <printf>
        save_exception_info(&tf, sepc, sstatus, scause, stval);
    80203b32:	e9840793          	addi	a5,s0,-360
    80203b36:	fd043703          	ld	a4,-48(s0)
    80203b3a:	fd843683          	ld	a3,-40(s0)
    80203b3e:	fe043603          	ld	a2,-32(s0)
    80203b42:	fe843583          	ld	a1,-24(s0)
    80203b46:	853e                	mv	a0,a5
    80203b48:	00000097          	auipc	ra,0x0
    80203b4c:	c28080e7          	jalr	-984(ra) # 80203770 <save_exception_info>
        info.sepc = sepc;
    80203b50:	fe843783          	ld	a5,-24(s0)
    80203b54:	e6f43c23          	sd	a5,-392(s0)
        info.sstatus = sstatus;
    80203b58:	fe043783          	ld	a5,-32(s0)
    80203b5c:	e8f43023          	sd	a5,-384(s0)
        info.scause = scause;
    80203b60:	fd843783          	ld	a5,-40(s0)
    80203b64:	e8f43423          	sd	a5,-376(s0)
        info.stval = stval;
    80203b68:	fd043783          	ld	a5,-48(s0)
    80203b6c:	e8f43823          	sd	a5,-368(s0)
        handle_exception(&tf, &info);
    80203b70:	e7840713          	addi	a4,s0,-392
    80203b74:	e9840793          	addi	a5,s0,-360
    80203b78:	85ba                	mv	a1,a4
    80203b7a:	853e                	mv	a0,a5
    80203b7c:	00000097          	auipc	ra,0x0
    80203b80:	03c080e7          	jalr	60(ra) # 80203bb8 <handle_exception>
        sepc = get_sepc(&tf);
    80203b84:	e9840793          	addi	a5,s0,-360
    80203b88:	853e                	mv	a0,a5
    80203b8a:	00000097          	auipc	ra,0x0
    80203b8e:	c12080e7          	jalr	-1006(ra) # 8020379c <get_sepc>
    80203b92:	fea43423          	sd	a0,-24(s0)
    w_sepc(sepc);
    80203b96:	fe843503          	ld	a0,-24(s0)
    80203b9a:	00000097          	auipc	ra,0x0
    80203b9e:	b2c080e7          	jalr	-1236(ra) # 802036c6 <w_sepc>
    w_sstatus(sstatus);
    80203ba2:	fe043503          	ld	a0,-32(s0)
    80203ba6:	00000097          	auipc	ra,0x0
    80203baa:	aec080e7          	jalr	-1300(ra) # 80203692 <w_sstatus>
}
    80203bae:	0001                	nop
    80203bb0:	60ba                	ld	ra,392(sp)
    80203bb2:	641a                	ld	s0,384(sp)
    80203bb4:	6159                	addi	sp,sp,400
    80203bb6:	8082                	ret

0000000080203bb8 <handle_exception>:
void handle_exception(struct trapframe *tf, struct trap_info *info) {
    80203bb8:	7139                	addi	sp,sp,-64
    80203bba:	fc06                	sd	ra,56(sp)
    80203bbc:	f822                	sd	s0,48(sp)
    80203bbe:	0080                	addi	s0,sp,64
    80203bc0:	fca43423          	sd	a0,-56(s0)
    80203bc4:	fcb43023          	sd	a1,-64(s0)
    uint64 cause = info->scause;  // 使用info中的字段
    80203bc8:	fc043783          	ld	a5,-64(s0)
    80203bcc:	6b9c                	ld	a5,16(a5)
    80203bce:	fef43423          	sd	a5,-24(s0)
    switch (cause) {
    80203bd2:	fe843703          	ld	a4,-24(s0)
    80203bd6:	47bd                	li	a5,15
    80203bd8:	3ee7e763          	bltu	a5,a4,80203fc6 <handle_exception+0x40e>
    80203bdc:	fe843783          	ld	a5,-24(s0)
    80203be0:	00279713          	slli	a4,a5,0x2
    80203be4:	0001d797          	auipc	a5,0x1d
    80203be8:	4a078793          	addi	a5,a5,1184 # 80221084 <user_test_table+0x344>
    80203bec:	97ba                	add	a5,a5,a4
    80203bee:	439c                	lw	a5,0(a5)
    80203bf0:	0007871b          	sext.w	a4,a5
    80203bf4:	0001d797          	auipc	a5,0x1d
    80203bf8:	49078793          	addi	a5,a5,1168 # 80221084 <user_test_table+0x344>
    80203bfc:	97ba                	add	a5,a5,a4
    80203bfe:	8782                	jr	a5
            printf("Instruction address misaligned: 0x%lx\n", info->stval);
    80203c00:	fc043783          	ld	a5,-64(s0)
    80203c04:	6f9c                	ld	a5,24(a5)
    80203c06:	85be                	mv	a1,a5
    80203c08:	0001d517          	auipc	a0,0x1d
    80203c0c:	29850513          	addi	a0,a0,664 # 80220ea0 <user_test_table+0x160>
    80203c10:	ffffd097          	auipc	ra,0xffffd
    80203c14:	674080e7          	jalr	1652(ra) # 80201284 <printf>
			if(myproc()->is_user){
    80203c18:	00001097          	auipc	ra,0x1
    80203c1c:	448080e7          	jalr	1096(ra) # 80205060 <myproc>
    80203c20:	87aa                	mv	a5,a0
    80203c22:	0a87a783          	lw	a5,168(a5)
    80203c26:	c791                	beqz	a5,80203c32 <handle_exception+0x7a>
				exit_proc(-1);
    80203c28:	557d                	li	a0,-1
    80203c2a:	00002097          	auipc	ra,0x2
    80203c2e:	2f2080e7          	jalr	754(ra) # 80205f1c <exit_proc>
			set_sepc(tf, info->sepc + 4);  // 使用辅助函数
    80203c32:	fc043783          	ld	a5,-64(s0)
    80203c36:	639c                	ld	a5,0(a5)
    80203c38:	0791                	addi	a5,a5,4
    80203c3a:	85be                	mv	a1,a5
    80203c3c:	fc843503          	ld	a0,-56(s0)
    80203c40:	00000097          	auipc	ra,0x0
    80203c44:	b74080e7          	jalr	-1164(ra) # 802037b4 <set_sepc>
            break;
    80203c48:	ae6d                	j	80204002 <handle_exception+0x44a>
            printf("Instruction access fault: 0x%lx\n", info->stval);
    80203c4a:	fc043783          	ld	a5,-64(s0)
    80203c4e:	6f9c                	ld	a5,24(a5)
    80203c50:	85be                	mv	a1,a5
    80203c52:	0001d517          	auipc	a0,0x1d
    80203c56:	27650513          	addi	a0,a0,630 # 80220ec8 <user_test_table+0x188>
    80203c5a:	ffffd097          	auipc	ra,0xffffd
    80203c5e:	62a080e7          	jalr	1578(ra) # 80201284 <printf>
			if(myproc()->is_user){
    80203c62:	00001097          	auipc	ra,0x1
    80203c66:	3fe080e7          	jalr	1022(ra) # 80205060 <myproc>
    80203c6a:	87aa                	mv	a5,a0
    80203c6c:	0a87a783          	lw	a5,168(a5)
    80203c70:	c791                	beqz	a5,80203c7c <handle_exception+0xc4>
				exit_proc(-1);
    80203c72:	557d                	li	a0,-1
    80203c74:	00002097          	auipc	ra,0x2
    80203c78:	2a8080e7          	jalr	680(ra) # 80205f1c <exit_proc>
			set_sepc(tf, info->sepc + 4);  // 使用辅助函数
    80203c7c:	fc043783          	ld	a5,-64(s0)
    80203c80:	639c                	ld	a5,0(a5)
    80203c82:	0791                	addi	a5,a5,4
    80203c84:	85be                	mv	a1,a5
    80203c86:	fc843503          	ld	a0,-56(s0)
    80203c8a:	00000097          	auipc	ra,0x0
    80203c8e:	b2a080e7          	jalr	-1238(ra) # 802037b4 <set_sepc>
            break;
    80203c92:	ae85                	j	80204002 <handle_exception+0x44a>
			if (copyin((char*)&instruction, (uint64)info->sepc, 4) == 0) {
    80203c94:	fc043783          	ld	a5,-64(s0)
    80203c98:	6398                	ld	a4,0(a5)
    80203c9a:	fdc40793          	addi	a5,s0,-36
    80203c9e:	4611                	li	a2,4
    80203ca0:	85ba                	mv	a1,a4
    80203ca2:	853e                	mv	a0,a5
    80203ca4:	00000097          	auipc	ra,0x0
    80203ca8:	3da080e7          	jalr	986(ra) # 8020407e <copyin>
    80203cac:	87aa                	mv	a5,a0
    80203cae:	ebcd                	bnez	a5,80203d60 <handle_exception+0x1a8>
				uint32_t opcode = instruction & 0x7f;
    80203cb0:	fdc42783          	lw	a5,-36(s0)
    80203cb4:	07f7f793          	andi	a5,a5,127
    80203cb8:	fef42223          	sw	a5,-28(s0)
				uint32_t funct3 = (instruction >> 12) & 0x7;
    80203cbc:	fdc42783          	lw	a5,-36(s0)
    80203cc0:	00c7d79b          	srliw	a5,a5,0xc
    80203cc4:	2781                	sext.w	a5,a5
    80203cc6:	8b9d                	andi	a5,a5,7
    80203cc8:	fef42023          	sw	a5,-32(s0)
				if (opcode == 0x33 && (funct3 == 0x4 || funct3 == 0x5 || 
    80203ccc:	fe442783          	lw	a5,-28(s0)
    80203cd0:	0007871b          	sext.w	a4,a5
    80203cd4:	03300793          	li	a5,51
    80203cd8:	06f71363          	bne	a4,a5,80203d3e <handle_exception+0x186>
    80203cdc:	fe042783          	lw	a5,-32(s0)
    80203ce0:	0007871b          	sext.w	a4,a5
    80203ce4:	4791                	li	a5,4
    80203ce6:	02f70763          	beq	a4,a5,80203d14 <handle_exception+0x15c>
    80203cea:	fe042783          	lw	a5,-32(s0)
    80203cee:	0007871b          	sext.w	a4,a5
    80203cf2:	4795                	li	a5,5
    80203cf4:	02f70063          	beq	a4,a5,80203d14 <handle_exception+0x15c>
    80203cf8:	fe042783          	lw	a5,-32(s0)
    80203cfc:	0007871b          	sext.w	a4,a5
    80203d00:	4799                	li	a5,6
    80203d02:	00f70963          	beq	a4,a5,80203d14 <handle_exception+0x15c>
					funct3 == 0x6 || funct3 == 0x7)) {
    80203d06:	fe042783          	lw	a5,-32(s0)
    80203d0a:	0007871b          	sext.w	a4,a5
    80203d0e:	479d                	li	a5,7
    80203d10:	02f71763          	bne	a4,a5,80203d3e <handle_exception+0x186>
					printf("[FATAL] Process %d killed by divide by zero\n", myproc()->pid);
    80203d14:	00001097          	auipc	ra,0x1
    80203d18:	34c080e7          	jalr	844(ra) # 80205060 <myproc>
    80203d1c:	87aa                	mv	a5,a0
    80203d1e:	43dc                	lw	a5,4(a5)
    80203d20:	85be                	mv	a1,a5
    80203d22:	0001d517          	auipc	a0,0x1d
    80203d26:	1ce50513          	addi	a0,a0,462 # 80220ef0 <user_test_table+0x1b0>
    80203d2a:	ffffd097          	auipc	ra,0xffffd
    80203d2e:	55a080e7          	jalr	1370(ra) # 80201284 <printf>
            		exit_proc(-1);  // 直接终止进程
    80203d32:	557d                	li	a0,-1
    80203d34:	00002097          	auipc	ra,0x2
    80203d38:	1e8080e7          	jalr	488(ra) # 80205f1c <exit_proc>
    80203d3c:	a091                	j	80203d80 <handle_exception+0x1c8>
					printf("Illegal instruction at 0x%lx: 0x%lx\n", 
    80203d3e:	fc043783          	ld	a5,-64(s0)
    80203d42:	6398                	ld	a4,0(a5)
    80203d44:	fc043783          	ld	a5,-64(s0)
    80203d48:	6f9c                	ld	a5,24(a5)
    80203d4a:	863e                	mv	a2,a5
    80203d4c:	85ba                	mv	a1,a4
    80203d4e:	0001d517          	auipc	a0,0x1d
    80203d52:	1d250513          	addi	a0,a0,466 # 80220f20 <user_test_table+0x1e0>
    80203d56:	ffffd097          	auipc	ra,0xffffd
    80203d5a:	52e080e7          	jalr	1326(ra) # 80201284 <printf>
    80203d5e:	a00d                	j	80203d80 <handle_exception+0x1c8>
				printf("Illegal instruction at 0x%lx: 0x%lx\n", 
    80203d60:	fc043783          	ld	a5,-64(s0)
    80203d64:	6398                	ld	a4,0(a5)
    80203d66:	fc043783          	ld	a5,-64(s0)
    80203d6a:	6f9c                	ld	a5,24(a5)
    80203d6c:	863e                	mv	a2,a5
    80203d6e:	85ba                	mv	a1,a4
    80203d70:	0001d517          	auipc	a0,0x1d
    80203d74:	1b050513          	addi	a0,a0,432 # 80220f20 <user_test_table+0x1e0>
    80203d78:	ffffd097          	auipc	ra,0xffffd
    80203d7c:	50c080e7          	jalr	1292(ra) # 80201284 <printf>
			if(myproc()->is_user){
    80203d80:	00001097          	auipc	ra,0x1
    80203d84:	2e0080e7          	jalr	736(ra) # 80205060 <myproc>
    80203d88:	87aa                	mv	a5,a0
    80203d8a:	0a87a783          	lw	a5,168(a5)
    80203d8e:	c791                	beqz	a5,80203d9a <handle_exception+0x1e2>
				exit_proc(-1);
    80203d90:	557d                	li	a0,-1
    80203d92:	00002097          	auipc	ra,0x2
    80203d96:	18a080e7          	jalr	394(ra) # 80205f1c <exit_proc>
			set_sepc(tf, info->sepc + 4); 
    80203d9a:	fc043783          	ld	a5,-64(s0)
    80203d9e:	639c                	ld	a5,0(a5)
    80203da0:	0791                	addi	a5,a5,4
    80203da2:	85be                	mv	a1,a5
    80203da4:	fc843503          	ld	a0,-56(s0)
    80203da8:	00000097          	auipc	ra,0x0
    80203dac:	a0c080e7          	jalr	-1524(ra) # 802037b4 <set_sepc>
			break;
    80203db0:	ac89                	j	80204002 <handle_exception+0x44a>
            printf("Breakpoint at 0x%lx\n", info->sepc);
    80203db2:	fc043783          	ld	a5,-64(s0)
    80203db6:	639c                	ld	a5,0(a5)
    80203db8:	85be                	mv	a1,a5
    80203dba:	0001d517          	auipc	a0,0x1d
    80203dbe:	18e50513          	addi	a0,a0,398 # 80220f48 <user_test_table+0x208>
    80203dc2:	ffffd097          	auipc	ra,0xffffd
    80203dc6:	4c2080e7          	jalr	1218(ra) # 80201284 <printf>
            set_sepc(tf, info->sepc + 4);
    80203dca:	fc043783          	ld	a5,-64(s0)
    80203dce:	639c                	ld	a5,0(a5)
    80203dd0:	0791                	addi	a5,a5,4
    80203dd2:	85be                	mv	a1,a5
    80203dd4:	fc843503          	ld	a0,-56(s0)
    80203dd8:	00000097          	auipc	ra,0x0
    80203ddc:	9dc080e7          	jalr	-1572(ra) # 802037b4 <set_sepc>
            break;
    80203de0:	a40d                	j	80204002 <handle_exception+0x44a>
            printf("Load address misaligned: 0x%lx\n", info->stval);
    80203de2:	fc043783          	ld	a5,-64(s0)
    80203de6:	6f9c                	ld	a5,24(a5)
    80203de8:	85be                	mv	a1,a5
    80203dea:	0001d517          	auipc	a0,0x1d
    80203dee:	17650513          	addi	a0,a0,374 # 80220f60 <user_test_table+0x220>
    80203df2:	ffffd097          	auipc	ra,0xffffd
    80203df6:	492080e7          	jalr	1170(ra) # 80201284 <printf>
			if(myproc()->is_user){
    80203dfa:	00001097          	auipc	ra,0x1
    80203dfe:	266080e7          	jalr	614(ra) # 80205060 <myproc>
    80203e02:	87aa                	mv	a5,a0
    80203e04:	0a87a783          	lw	a5,168(a5)
    80203e08:	c791                	beqz	a5,80203e14 <handle_exception+0x25c>
				exit_proc(-1);
    80203e0a:	557d                	li	a0,-1
    80203e0c:	00002097          	auipc	ra,0x2
    80203e10:	110080e7          	jalr	272(ra) # 80205f1c <exit_proc>
			set_sepc(tf, info->sepc + 4); 
    80203e14:	fc043783          	ld	a5,-64(s0)
    80203e18:	639c                	ld	a5,0(a5)
    80203e1a:	0791                	addi	a5,a5,4
    80203e1c:	85be                	mv	a1,a5
    80203e1e:	fc843503          	ld	a0,-56(s0)
    80203e22:	00000097          	auipc	ra,0x0
    80203e26:	992080e7          	jalr	-1646(ra) # 802037b4 <set_sepc>
            break;
    80203e2a:	aae1                	j	80204002 <handle_exception+0x44a>
			printf("Load access fault: 0x%lx\n", info->stval);
    80203e2c:	fc043783          	ld	a5,-64(s0)
    80203e30:	6f9c                	ld	a5,24(a5)
    80203e32:	85be                	mv	a1,a5
    80203e34:	0001d517          	auipc	a0,0x1d
    80203e38:	14c50513          	addi	a0,a0,332 # 80220f80 <user_test_table+0x240>
    80203e3c:	ffffd097          	auipc	ra,0xffffd
    80203e40:	448080e7          	jalr	1096(ra) # 80201284 <printf>
			if (check_is_mapped(info->stval) && handle_page_fault(info->stval, 2)) {
    80203e44:	fc043783          	ld	a5,-64(s0)
    80203e48:	6f9c                	ld	a5,24(a5)
    80203e4a:	853e                	mv	a0,a5
    80203e4c:	fffff097          	auipc	ra,0xfffff
    80203e50:	2c8080e7          	jalr	712(ra) # 80203114 <check_is_mapped>
    80203e54:	87aa                	mv	a5,a0
    80203e56:	cf89                	beqz	a5,80203e70 <handle_exception+0x2b8>
    80203e58:	fc043783          	ld	a5,-64(s0)
    80203e5c:	6f9c                	ld	a5,24(a5)
    80203e5e:	4589                	li	a1,2
    80203e60:	853e                	mv	a0,a5
    80203e62:	fffff097          	auipc	ra,0xfffff
    80203e66:	c46080e7          	jalr	-954(ra) # 80202aa8 <handle_page_fault>
    80203e6a:	87aa                	mv	a5,a0
    80203e6c:	18079863          	bnez	a5,80203ffc <handle_exception+0x444>
			set_sepc(tf, info->sepc + 4);
    80203e70:	fc043783          	ld	a5,-64(s0)
    80203e74:	639c                	ld	a5,0(a5)
    80203e76:	0791                	addi	a5,a5,4
    80203e78:	85be                	mv	a1,a5
    80203e7a:	fc843503          	ld	a0,-56(s0)
    80203e7e:	00000097          	auipc	ra,0x0
    80203e82:	936080e7          	jalr	-1738(ra) # 802037b4 <set_sepc>
			break;
    80203e86:	aab5                	j	80204002 <handle_exception+0x44a>
            printf("Store address misaligned: 0x%lx\n", info->stval);
    80203e88:	fc043783          	ld	a5,-64(s0)
    80203e8c:	6f9c                	ld	a5,24(a5)
    80203e8e:	85be                	mv	a1,a5
    80203e90:	0001d517          	auipc	a0,0x1d
    80203e94:	11050513          	addi	a0,a0,272 # 80220fa0 <user_test_table+0x260>
    80203e98:	ffffd097          	auipc	ra,0xffffd
    80203e9c:	3ec080e7          	jalr	1004(ra) # 80201284 <printf>
			if(myproc()->is_user){
    80203ea0:	00001097          	auipc	ra,0x1
    80203ea4:	1c0080e7          	jalr	448(ra) # 80205060 <myproc>
    80203ea8:	87aa                	mv	a5,a0
    80203eaa:	0a87a783          	lw	a5,168(a5)
    80203eae:	c791                	beqz	a5,80203eba <handle_exception+0x302>
				exit_proc(-1);
    80203eb0:	557d                	li	a0,-1
    80203eb2:	00002097          	auipc	ra,0x2
    80203eb6:	06a080e7          	jalr	106(ra) # 80205f1c <exit_proc>
			set_sepc(tf, info->sepc + 4); 
    80203eba:	fc043783          	ld	a5,-64(s0)
    80203ebe:	639c                	ld	a5,0(a5)
    80203ec0:	0791                	addi	a5,a5,4
    80203ec2:	85be                	mv	a1,a5
    80203ec4:	fc843503          	ld	a0,-56(s0)
    80203ec8:	00000097          	auipc	ra,0x0
    80203ecc:	8ec080e7          	jalr	-1812(ra) # 802037b4 <set_sepc>
            break;
    80203ed0:	aa0d                	j	80204002 <handle_exception+0x44a>
			printf("Store access fault: 0x%lx\n", info->stval);
    80203ed2:	fc043783          	ld	a5,-64(s0)
    80203ed6:	6f9c                	ld	a5,24(a5)
    80203ed8:	85be                	mv	a1,a5
    80203eda:	0001d517          	auipc	a0,0x1d
    80203ede:	0ee50513          	addi	a0,a0,238 # 80220fc8 <user_test_table+0x288>
    80203ee2:	ffffd097          	auipc	ra,0xffffd
    80203ee6:	3a2080e7          	jalr	930(ra) # 80201284 <printf>
			if (check_is_mapped(info->stval) && handle_page_fault(info->stval, 3)) {
    80203eea:	fc043783          	ld	a5,-64(s0)
    80203eee:	6f9c                	ld	a5,24(a5)
    80203ef0:	853e                	mv	a0,a5
    80203ef2:	fffff097          	auipc	ra,0xfffff
    80203ef6:	222080e7          	jalr	546(ra) # 80203114 <check_is_mapped>
    80203efa:	87aa                	mv	a5,a0
    80203efc:	cf81                	beqz	a5,80203f14 <handle_exception+0x35c>
    80203efe:	fc043783          	ld	a5,-64(s0)
    80203f02:	6f9c                	ld	a5,24(a5)
    80203f04:	458d                	li	a1,3
    80203f06:	853e                	mv	a0,a5
    80203f08:	fffff097          	auipc	ra,0xfffff
    80203f0c:	ba0080e7          	jalr	-1120(ra) # 80202aa8 <handle_page_fault>
    80203f10:	87aa                	mv	a5,a0
    80203f12:	e7fd                	bnez	a5,80204000 <handle_exception+0x448>
			set_sepc(tf, info->sepc + 4);
    80203f14:	fc043783          	ld	a5,-64(s0)
    80203f18:	639c                	ld	a5,0(a5)
    80203f1a:	0791                	addi	a5,a5,4
    80203f1c:	85be                	mv	a1,a5
    80203f1e:	fc843503          	ld	a0,-56(s0)
    80203f22:	00000097          	auipc	ra,0x0
    80203f26:	892080e7          	jalr	-1902(ra) # 802037b4 <set_sepc>
			break;
    80203f2a:	a8e1                	j	80204002 <handle_exception+0x44a>
			if(myproc()->is_user){
    80203f2c:	00001097          	auipc	ra,0x1
    80203f30:	134080e7          	jalr	308(ra) # 80205060 <myproc>
    80203f34:	87aa                	mv	a5,a0
    80203f36:	0a87a783          	lw	a5,168(a5)
    80203f3a:	cb91                	beqz	a5,80203f4e <handle_exception+0x396>
            	handle_syscall(tf,info);
    80203f3c:	fc043583          	ld	a1,-64(s0)
    80203f40:	fc843503          	ld	a0,-56(s0)
    80203f44:	00000097          	auipc	ra,0x0
    80203f48:	42a080e7          	jalr	1066(ra) # 8020436e <handle_syscall>
            break;
    80203f4c:	a85d                	j	80204002 <handle_exception+0x44a>
				warning("[EXCEPTION] ecall was called in S-mode");
    80203f4e:	0001d517          	auipc	a0,0x1d
    80203f52:	09a50513          	addi	a0,a0,154 # 80220fe8 <user_test_table+0x2a8>
    80203f56:	ffffe097          	auipc	ra,0xffffe
    80203f5a:	8e4080e7          	jalr	-1820(ra) # 8020183a <warning>
            break;
    80203f5e:	a055                	j	80204002 <handle_exception+0x44a>
            printf("Supervisor environment call at 0x%lx\n", info->sepc);
    80203f60:	fc043783          	ld	a5,-64(s0)
    80203f64:	639c                	ld	a5,0(a5)
    80203f66:	85be                	mv	a1,a5
    80203f68:	0001d517          	auipc	a0,0x1d
    80203f6c:	0a850513          	addi	a0,a0,168 # 80221010 <user_test_table+0x2d0>
    80203f70:	ffffd097          	auipc	ra,0xffffd
    80203f74:	314080e7          	jalr	788(ra) # 80201284 <printf>
			set_sepc(tf, info->sepc + 4); 
    80203f78:	fc043783          	ld	a5,-64(s0)
    80203f7c:	639c                	ld	a5,0(a5)
    80203f7e:	0791                	addi	a5,a5,4
    80203f80:	85be                	mv	a1,a5
    80203f82:	fc843503          	ld	a0,-56(s0)
    80203f86:	00000097          	auipc	ra,0x0
    80203f8a:	82e080e7          	jalr	-2002(ra) # 802037b4 <set_sepc>
            break;
    80203f8e:	a895                	j	80204002 <handle_exception+0x44a>
            handle_instruction_page_fault(tf,info);
    80203f90:	fc043583          	ld	a1,-64(s0)
    80203f94:	fc843503          	ld	a0,-56(s0)
    80203f98:	00001097          	auipc	ra,0x1
    80203f9c:	838080e7          	jalr	-1992(ra) # 802047d0 <handle_instruction_page_fault>
            break;
    80203fa0:	a08d                	j	80204002 <handle_exception+0x44a>
            handle_load_page_fault(tf,info);
    80203fa2:	fc043583          	ld	a1,-64(s0)
    80203fa6:	fc843503          	ld	a0,-56(s0)
    80203faa:	00001097          	auipc	ra,0x1
    80203fae:	888080e7          	jalr	-1912(ra) # 80204832 <handle_load_page_fault>
            break;
    80203fb2:	a881                	j	80204002 <handle_exception+0x44a>
            handle_store_page_fault(tf,info);
    80203fb4:	fc043583          	ld	a1,-64(s0)
    80203fb8:	fc843503          	ld	a0,-56(s0)
    80203fbc:	00001097          	auipc	ra,0x1
    80203fc0:	8d8080e7          	jalr	-1832(ra) # 80204894 <handle_store_page_fault>
            break;
    80203fc4:	a83d                	j	80204002 <handle_exception+0x44a>
            printf("Unknown exception: cause=%ld, sepc=0x%lx, stval=0x%lx\n", 
    80203fc6:	fc043783          	ld	a5,-64(s0)
    80203fca:	6398                	ld	a4,0(a5)
    80203fcc:	fc043783          	ld	a5,-64(s0)
    80203fd0:	6f9c                	ld	a5,24(a5)
    80203fd2:	86be                	mv	a3,a5
    80203fd4:	863a                	mv	a2,a4
    80203fd6:	fe843583          	ld	a1,-24(s0)
    80203fda:	0001d517          	auipc	a0,0x1d
    80203fde:	05e50513          	addi	a0,a0,94 # 80221038 <user_test_table+0x2f8>
    80203fe2:	ffffd097          	auipc	ra,0xffffd
    80203fe6:	2a2080e7          	jalr	674(ra) # 80201284 <printf>
            panic("Unknown exception");
    80203fea:	0001d517          	auipc	a0,0x1d
    80203fee:	08650513          	addi	a0,a0,134 # 80221070 <user_test_table+0x330>
    80203ff2:	ffffe097          	auipc	ra,0xffffe
    80203ff6:	814080e7          	jalr	-2028(ra) # 80201806 <panic>
            break;
    80203ffa:	a021                	j	80204002 <handle_exception+0x44a>
				return; // 成功处理
    80203ffc:	0001                	nop
    80203ffe:	a011                	j	80204002 <handle_exception+0x44a>
				return; // 成功处理
    80204000:	0001                	nop
}
    80204002:	70e2                	ld	ra,56(sp)
    80204004:	7442                	ld	s0,48(sp)
    80204006:	6121                	addi	sp,sp,64
    80204008:	8082                	ret

000000008020400a <user_va2pa>:
void* user_va2pa(pagetable_t pagetable, uint64 va) {
    8020400a:	7179                	addi	sp,sp,-48
    8020400c:	f406                	sd	ra,40(sp)
    8020400e:	f022                	sd	s0,32(sp)
    80204010:	1800                	addi	s0,sp,48
    80204012:	fca43c23          	sd	a0,-40(s0)
    80204016:	fcb43823          	sd	a1,-48(s0)
    pte_t *pte = walk_lookup(pagetable, va);
    8020401a:	fd043583          	ld	a1,-48(s0)
    8020401e:	fd843503          	ld	a0,-40(s0)
    80204022:	ffffe097          	auipc	ra,0xffffe
    80204026:	1ba080e7          	jalr	442(ra) # 802021dc <walk_lookup>
    8020402a:	fea43423          	sd	a0,-24(s0)
    if (!pte) return 0;
    8020402e:	fe843783          	ld	a5,-24(s0)
    80204032:	e399                	bnez	a5,80204038 <user_va2pa+0x2e>
    80204034:	4781                	li	a5,0
    80204036:	a83d                	j	80204074 <user_va2pa+0x6a>
    if (!(*pte & PTE_V)) return 0;
    80204038:	fe843783          	ld	a5,-24(s0)
    8020403c:	639c                	ld	a5,0(a5)
    8020403e:	8b85                	andi	a5,a5,1
    80204040:	e399                	bnez	a5,80204046 <user_va2pa+0x3c>
    80204042:	4781                	li	a5,0
    80204044:	a805                	j	80204074 <user_va2pa+0x6a>
    if (!(*pte & PTE_U)) return 0; // 必须是用户可访问
    80204046:	fe843783          	ld	a5,-24(s0)
    8020404a:	639c                	ld	a5,0(a5)
    8020404c:	8bc1                	andi	a5,a5,16
    8020404e:	e399                	bnez	a5,80204054 <user_va2pa+0x4a>
    80204050:	4781                	li	a5,0
    80204052:	a00d                	j	80204074 <user_va2pa+0x6a>
    uint64 pa = (PTE2PA(*pte)) | (va & 0xFFF); // 物理页基址 + 页内偏移
    80204054:	fe843783          	ld	a5,-24(s0)
    80204058:	639c                	ld	a5,0(a5)
    8020405a:	83a9                	srli	a5,a5,0xa
    8020405c:	00c79713          	slli	a4,a5,0xc
    80204060:	fd043683          	ld	a3,-48(s0)
    80204064:	6785                	lui	a5,0x1
    80204066:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80204068:	8ff5                	and	a5,a5,a3
    8020406a:	8fd9                	or	a5,a5,a4
    8020406c:	fef43023          	sd	a5,-32(s0)
    return (void*)pa;
    80204070:	fe043783          	ld	a5,-32(s0)
}
    80204074:	853e                	mv	a0,a5
    80204076:	70a2                	ld	ra,40(sp)
    80204078:	7402                	ld	s0,32(sp)
    8020407a:	6145                	addi	sp,sp,48
    8020407c:	8082                	ret

000000008020407e <copyin>:
int copyin(char *dst, uint64 srcva, int maxlen) {
    8020407e:	715d                	addi	sp,sp,-80
    80204080:	e486                	sd	ra,72(sp)
    80204082:	e0a2                	sd	s0,64(sp)
    80204084:	0880                	addi	s0,sp,80
    80204086:	fca43423          	sd	a0,-56(s0)
    8020408a:	fcb43023          	sd	a1,-64(s0)
    8020408e:	87b2                	mv	a5,a2
    80204090:	faf42e23          	sw	a5,-68(s0)
    struct proc *p = myproc();
    80204094:	00001097          	auipc	ra,0x1
    80204098:	fcc080e7          	jalr	-52(ra) # 80205060 <myproc>
    8020409c:	fea43023          	sd	a0,-32(s0)
    for (int i = 0; i < maxlen; i++) {
    802040a0:	fe042623          	sw	zero,-20(s0)
    802040a4:	a085                	j	80204104 <copyin+0x86>
        char *pa = user_va2pa(p->pagetable, srcva + i);
    802040a6:	fe043783          	ld	a5,-32(s0)
    802040aa:	7fd4                	ld	a3,184(a5)
    802040ac:	fec42703          	lw	a4,-20(s0)
    802040b0:	fc043783          	ld	a5,-64(s0)
    802040b4:	97ba                	add	a5,a5,a4
    802040b6:	85be                	mv	a1,a5
    802040b8:	8536                	mv	a0,a3
    802040ba:	00000097          	auipc	ra,0x0
    802040be:	f50080e7          	jalr	-176(ra) # 8020400a <user_va2pa>
    802040c2:	fca43c23          	sd	a0,-40(s0)
        if (!pa) return -1;
    802040c6:	fd843783          	ld	a5,-40(s0)
    802040ca:	e399                	bnez	a5,802040d0 <copyin+0x52>
    802040cc:	57fd                	li	a5,-1
    802040ce:	a0a9                	j	80204118 <copyin+0x9a>
        dst[i] = *pa;
    802040d0:	fec42783          	lw	a5,-20(s0)
    802040d4:	fc843703          	ld	a4,-56(s0)
    802040d8:	97ba                	add	a5,a5,a4
    802040da:	fd843703          	ld	a4,-40(s0)
    802040de:	00074703          	lbu	a4,0(a4)
    802040e2:	00e78023          	sb	a4,0(a5)
        if (dst[i] == 0) return 0;
    802040e6:	fec42783          	lw	a5,-20(s0)
    802040ea:	fc843703          	ld	a4,-56(s0)
    802040ee:	97ba                	add	a5,a5,a4
    802040f0:	0007c783          	lbu	a5,0(a5)
    802040f4:	e399                	bnez	a5,802040fa <copyin+0x7c>
    802040f6:	4781                	li	a5,0
    802040f8:	a005                	j	80204118 <copyin+0x9a>
    for (int i = 0; i < maxlen; i++) {
    802040fa:	fec42783          	lw	a5,-20(s0)
    802040fe:	2785                	addiw	a5,a5,1
    80204100:	fef42623          	sw	a5,-20(s0)
    80204104:	fec42783          	lw	a5,-20(s0)
    80204108:	873e                	mv	a4,a5
    8020410a:	fbc42783          	lw	a5,-68(s0)
    8020410e:	2701                	sext.w	a4,a4
    80204110:	2781                	sext.w	a5,a5
    80204112:	f8f74ae3          	blt	a4,a5,802040a6 <copyin+0x28>
    return 0;
    80204116:	4781                	li	a5,0
}
    80204118:	853e                	mv	a0,a5
    8020411a:	60a6                	ld	ra,72(sp)
    8020411c:	6406                	ld	s0,64(sp)
    8020411e:	6161                	addi	sp,sp,80
    80204120:	8082                	ret

0000000080204122 <copyout>:
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
    80204122:	7139                	addi	sp,sp,-64
    80204124:	fc06                	sd	ra,56(sp)
    80204126:	f822                	sd	s0,48(sp)
    80204128:	0080                	addi	s0,sp,64
    8020412a:	fca43c23          	sd	a0,-40(s0)
    8020412e:	fcb43823          	sd	a1,-48(s0)
    80204132:	fcc43423          	sd	a2,-56(s0)
    80204136:	fcd43023          	sd	a3,-64(s0)
    for (uint64 i = 0; i < len; i++) {
    8020413a:	fe043423          	sd	zero,-24(s0)
    8020413e:	a0a1                	j	80204186 <copyout+0x64>
        char *pa = user_va2pa(pagetable, dstva + i);
    80204140:	fd043703          	ld	a4,-48(s0)
    80204144:	fe843783          	ld	a5,-24(s0)
    80204148:	97ba                	add	a5,a5,a4
    8020414a:	85be                	mv	a1,a5
    8020414c:	fd843503          	ld	a0,-40(s0)
    80204150:	00000097          	auipc	ra,0x0
    80204154:	eba080e7          	jalr	-326(ra) # 8020400a <user_va2pa>
    80204158:	fea43023          	sd	a0,-32(s0)
        if (!pa) return -1;
    8020415c:	fe043783          	ld	a5,-32(s0)
    80204160:	e399                	bnez	a5,80204166 <copyout+0x44>
    80204162:	57fd                	li	a5,-1
    80204164:	a805                	j	80204194 <copyout+0x72>
        *pa = src[i];
    80204166:	fc843703          	ld	a4,-56(s0)
    8020416a:	fe843783          	ld	a5,-24(s0)
    8020416e:	97ba                	add	a5,a5,a4
    80204170:	0007c703          	lbu	a4,0(a5)
    80204174:	fe043783          	ld	a5,-32(s0)
    80204178:	00e78023          	sb	a4,0(a5)
    for (uint64 i = 0; i < len; i++) {
    8020417c:	fe843783          	ld	a5,-24(s0)
    80204180:	0785                	addi	a5,a5,1
    80204182:	fef43423          	sd	a5,-24(s0)
    80204186:	fe843703          	ld	a4,-24(s0)
    8020418a:	fc043783          	ld	a5,-64(s0)
    8020418e:	faf769e3          	bltu	a4,a5,80204140 <copyout+0x1e>
    return 0;
    80204192:	4781                	li	a5,0
}
    80204194:	853e                	mv	a0,a5
    80204196:	70e2                	ld	ra,56(sp)
    80204198:	7442                	ld	s0,48(sp)
    8020419a:	6121                	addi	sp,sp,64
    8020419c:	8082                	ret

000000008020419e <copyinstr>:
int copyinstr(char *dst, pagetable_t pagetable, uint64 srcva, int max) {
    8020419e:	7139                	addi	sp,sp,-64
    802041a0:	fc06                	sd	ra,56(sp)
    802041a2:	f822                	sd	s0,48(sp)
    802041a4:	0080                	addi	s0,sp,64
    802041a6:	fca43c23          	sd	a0,-40(s0)
    802041aa:	fcb43823          	sd	a1,-48(s0)
    802041ae:	fcc43423          	sd	a2,-56(s0)
    802041b2:	87b6                	mv	a5,a3
    802041b4:	fcf42223          	sw	a5,-60(s0)
    for (i = 0; i < max; i++) {
    802041b8:	fe042623          	sw	zero,-20(s0)
    802041bc:	a0b9                	j	8020420a <copyinstr+0x6c>
        if (copyin(&c, srcva + i, 1) < 0)  // 每次拷贝 1 字节
    802041be:	fec42703          	lw	a4,-20(s0)
    802041c2:	fc843783          	ld	a5,-56(s0)
    802041c6:	973e                	add	a4,a4,a5
    802041c8:	feb40793          	addi	a5,s0,-21
    802041cc:	4605                	li	a2,1
    802041ce:	85ba                	mv	a1,a4
    802041d0:	853e                	mv	a0,a5
    802041d2:	00000097          	auipc	ra,0x0
    802041d6:	eac080e7          	jalr	-340(ra) # 8020407e <copyin>
    802041da:	87aa                	mv	a5,a0
    802041dc:	0007d463          	bgez	a5,802041e4 <copyinstr+0x46>
            return -1;
    802041e0:	57fd                	li	a5,-1
    802041e2:	a0b1                	j	8020422e <copyinstr+0x90>
        dst[i] = c;
    802041e4:	fec42783          	lw	a5,-20(s0)
    802041e8:	fd843703          	ld	a4,-40(s0)
    802041ec:	97ba                	add	a5,a5,a4
    802041ee:	feb44703          	lbu	a4,-21(s0)
    802041f2:	00e78023          	sb	a4,0(a5)
        if (c == '\0')
    802041f6:	feb44783          	lbu	a5,-21(s0)
    802041fa:	e399                	bnez	a5,80204200 <copyinstr+0x62>
            return 0;
    802041fc:	4781                	li	a5,0
    802041fe:	a805                	j	8020422e <copyinstr+0x90>
    for (i = 0; i < max; i++) {
    80204200:	fec42783          	lw	a5,-20(s0)
    80204204:	2785                	addiw	a5,a5,1
    80204206:	fef42623          	sw	a5,-20(s0)
    8020420a:	fec42783          	lw	a5,-20(s0)
    8020420e:	873e                	mv	a4,a5
    80204210:	fc442783          	lw	a5,-60(s0)
    80204214:	2701                	sext.w	a4,a4
    80204216:	2781                	sext.w	a5,a5
    80204218:	faf743e3          	blt	a4,a5,802041be <copyinstr+0x20>
    dst[max-1] = '\0';
    8020421c:	fc442783          	lw	a5,-60(s0)
    80204220:	17fd                	addi	a5,a5,-1
    80204222:	fd843703          	ld	a4,-40(s0)
    80204226:	97ba                	add	a5,a5,a4
    80204228:	00078023          	sb	zero,0(a5)
    return -1; // 超过最大长度还没遇到 \0
    8020422c:	57fd                	li	a5,-1
}
    8020422e:	853e                	mv	a0,a5
    80204230:	70e2                	ld	ra,56(sp)
    80204232:	7442                	ld	s0,48(sp)
    80204234:	6121                	addi	sp,sp,64
    80204236:	8082                	ret

0000000080204238 <check_user_addr>:
int check_user_addr(uint64 addr, uint64 size, int write) {
    80204238:	7179                	addi	sp,sp,-48
    8020423a:	f422                	sd	s0,40(sp)
    8020423c:	1800                	addi	s0,sp,48
    8020423e:	fea43423          	sd	a0,-24(s0)
    80204242:	feb43023          	sd	a1,-32(s0)
    80204246:	87b2                	mv	a5,a2
    80204248:	fcf42e23          	sw	a5,-36(s0)
    if (!IS_USER_ADDR(addr) || !IS_USER_ADDR(addr + size - 1))
    8020424c:	fe843703          	ld	a4,-24(s0)
    80204250:	67c1                	lui	a5,0x10
    80204252:	02f76d63          	bltu	a4,a5,8020428c <check_user_addr+0x54>
    80204256:	fe843703          	ld	a4,-24(s0)
    8020425a:	57fd                	li	a5,-1
    8020425c:	83e5                	srli	a5,a5,0x19
    8020425e:	02e7e763          	bltu	a5,a4,8020428c <check_user_addr+0x54>
    80204262:	fe843703          	ld	a4,-24(s0)
    80204266:	fe043783          	ld	a5,-32(s0)
    8020426a:	97ba                	add	a5,a5,a4
    8020426c:	fff78713          	addi	a4,a5,-1 # ffff <_entry-0x801f0001>
    80204270:	67c1                	lui	a5,0x10
    80204272:	00f76d63          	bltu	a4,a5,8020428c <check_user_addr+0x54>
    80204276:	fe843703          	ld	a4,-24(s0)
    8020427a:	fe043783          	ld	a5,-32(s0)
    8020427e:	97ba                	add	a5,a5,a4
    80204280:	fff78713          	addi	a4,a5,-1 # ffff <_entry-0x801f0001>
    80204284:	57fd                	li	a5,-1
    80204286:	83e5                	srli	a5,a5,0x19
    80204288:	00e7f463          	bgeu	a5,a4,80204290 <check_user_addr+0x58>
        return -1;
    8020428c:	57fd                	li	a5,-1
    8020428e:	a8e1                	j	80204366 <check_user_addr+0x12e>
    if (IS_USER_STACK(addr)) {
    80204290:	fe843703          	ld	a4,-24(s0)
    80204294:	ddfff7b7          	lui	a5,0xddfff
    80204298:	07b6                	slli	a5,a5,0xd
    8020429a:	83e5                	srli	a5,a5,0x19
    8020429c:	04e7f663          	bgeu	a5,a4,802042e8 <check_user_addr+0xb0>
    802042a0:	fe843703          	ld	a4,-24(s0)
    802042a4:	fdfff7b7          	lui	a5,0xfdfff
    802042a8:	07b6                	slli	a5,a5,0xd
    802042aa:	83e5                	srli	a5,a5,0x19
    802042ac:	02e7ee63          	bltu	a5,a4,802042e8 <check_user_addr+0xb0>
        if (!IS_USER_STACK(addr + size - 1))
    802042b0:	fe843703          	ld	a4,-24(s0)
    802042b4:	fe043783          	ld	a5,-32(s0)
    802042b8:	97ba                	add	a5,a5,a4
    802042ba:	fff78713          	addi	a4,a5,-1 # fffffffffdffefff <_bss_end+0xffffffff7ddb66cf>
    802042be:	ddfff7b7          	lui	a5,0xddfff
    802042c2:	07b6                	slli	a5,a5,0xd
    802042c4:	83e5                	srli	a5,a5,0x19
    802042c6:	00e7ff63          	bgeu	a5,a4,802042e4 <check_user_addr+0xac>
    802042ca:	fe843703          	ld	a4,-24(s0)
    802042ce:	fe043783          	ld	a5,-32(s0)
    802042d2:	97ba                	add	a5,a5,a4
    802042d4:	fff78713          	addi	a4,a5,-1 # ffffffffddffefff <_bss_end+0xffffffff5ddb66cf>
    802042d8:	fdfff7b7          	lui	a5,0xfdfff
    802042dc:	07b6                	slli	a5,a5,0xd
    802042de:	83e5                	srli	a5,a5,0x19
    802042e0:	06e7ff63          	bgeu	a5,a4,8020435e <check_user_addr+0x126>
            return -1;  // 跨越栈边界
    802042e4:	57fd                	li	a5,-1
    802042e6:	a041                	j	80204366 <check_user_addr+0x12e>
    } else if (IS_USER_HEAP(addr)) {
    802042e8:	fe843703          	ld	a4,-24(s0)
    802042ec:	004007b7          	lui	a5,0x400
    802042f0:	04f76463          	bltu	a4,a5,80204338 <check_user_addr+0x100>
    802042f4:	fe843703          	ld	a4,-24(s0)
    802042f8:	ddfff7b7          	lui	a5,0xddfff
    802042fc:	07b6                	slli	a5,a5,0xd
    802042fe:	83e5                	srli	a5,a5,0x19
    80204300:	02e7ec63          	bltu	a5,a4,80204338 <check_user_addr+0x100>
        if (!IS_USER_HEAP(addr + size - 1))
    80204304:	fe843703          	ld	a4,-24(s0)
    80204308:	fe043783          	ld	a5,-32(s0)
    8020430c:	97ba                	add	a5,a5,a4
    8020430e:	fff78713          	addi	a4,a5,-1 # ffffffffddffefff <_bss_end+0xffffffff5ddb66cf>
    80204312:	004007b7          	lui	a5,0x400
    80204316:	00f76f63          	bltu	a4,a5,80204334 <check_user_addr+0xfc>
    8020431a:	fe843703          	ld	a4,-24(s0)
    8020431e:	fe043783          	ld	a5,-32(s0)
    80204322:	97ba                	add	a5,a5,a4
    80204324:	fff78713          	addi	a4,a5,-1 # 3fffff <_entry-0x7fe00001>
    80204328:	ddfff7b7          	lui	a5,0xddfff
    8020432c:	07b6                	slli	a5,a5,0xd
    8020432e:	83e5                	srli	a5,a5,0x19
    80204330:	02e7f963          	bgeu	a5,a4,80204362 <check_user_addr+0x12a>
            return -1;  // 跨越堆边界
    80204334:	57fd                	li	a5,-1
    80204336:	a805                	j	80204366 <check_user_addr+0x12e>
    } else if (addr < USER_HEAP_START) {
    80204338:	fe843703          	ld	a4,-24(s0)
    8020433c:	004007b7          	lui	a5,0x400
    80204340:	00f77d63          	bgeu	a4,a5,8020435a <check_user_addr+0x122>
        if (addr + size > USER_HEAP_START)
    80204344:	fe843703          	ld	a4,-24(s0)
    80204348:	fe043783          	ld	a5,-32(s0)
    8020434c:	973e                	add	a4,a4,a5
    8020434e:	004007b7          	lui	a5,0x400
    80204352:	00e7f963          	bgeu	a5,a4,80204364 <check_user_addr+0x12c>
            return -1;  // 跨越代码/数据段边界
    80204356:	57fd                	li	a5,-1
    80204358:	a039                	j	80204366 <check_user_addr+0x12e>
        return -1;  // 在未定义区域
    8020435a:	57fd                	li	a5,-1
    8020435c:	a029                	j	80204366 <check_user_addr+0x12e>
        if (!IS_USER_STACK(addr + size - 1))
    8020435e:	0001                	nop
    80204360:	a011                	j	80204364 <check_user_addr+0x12c>
        if (!IS_USER_HEAP(addr + size - 1))
    80204362:	0001                	nop
    return 0;  // 地址合法
    80204364:	4781                	li	a5,0
}
    80204366:	853e                	mv	a0,a5
    80204368:	7422                	ld	s0,40(sp)
    8020436a:	6145                	addi	sp,sp,48
    8020436c:	8082                	ret

000000008020436e <handle_syscall>:
void handle_syscall(struct trapframe *tf, struct trap_info *info) {
    8020436e:	7155                	addi	sp,sp,-208
    80204370:	e586                	sd	ra,200(sp)
    80204372:	e1a2                	sd	s0,192(sp)
    80204374:	0980                	addi	s0,sp,208
    80204376:	f2a43c23          	sd	a0,-200(s0)
    8020437a:	f2b43823          	sd	a1,-208(s0)
	switch (tf->a7) {
    8020437e:	f3843783          	ld	a5,-200(s0)
    80204382:	73fc                	ld	a5,224(a5)
    80204384:	6705                	lui	a4,0x1
    80204386:	177d                	addi	a4,a4,-1 # fff <_entry-0x801ff001>
    80204388:	28e78563          	beq	a5,a4,80204612 <handle_syscall+0x2a4>
    8020438c:	6705                	lui	a4,0x1
    8020438e:	40e7f063          	bgeu	a5,a4,8020478e <handle_syscall+0x420>
    80204392:	0de00713          	li	a4,222
    80204396:	20e78c63          	beq	a5,a4,802045ae <handle_syscall+0x240>
    8020439a:	0de00713          	li	a4,222
    8020439e:	3ef76863          	bltu	a4,a5,8020478e <handle_syscall+0x420>
    802043a2:	0dd00713          	li	a4,221
    802043a6:	18e78963          	beq	a5,a4,80204538 <handle_syscall+0x1ca>
    802043aa:	0dd00713          	li	a4,221
    802043ae:	3ef76063          	bltu	a4,a5,8020478e <handle_syscall+0x420>
    802043b2:	0dc00713          	li	a4,220
    802043b6:	14e78963          	beq	a5,a4,80204508 <handle_syscall+0x19a>
    802043ba:	0dc00713          	li	a4,220
    802043be:	3cf76863          	bltu	a4,a5,8020478e <handle_syscall+0x420>
    802043c2:	0ad00713          	li	a4,173
    802043c6:	20e78863          	beq	a5,a4,802045d6 <handle_syscall+0x268>
    802043ca:	0ad00713          	li	a4,173
    802043ce:	3cf76063          	bltu	a4,a5,8020478e <handle_syscall+0x420>
    802043d2:	0ac00713          	li	a4,172
    802043d6:	1ee78563          	beq	a5,a4,802045c0 <handle_syscall+0x252>
    802043da:	0ac00713          	li	a4,172
    802043de:	3af76863          	bltu	a4,a5,8020478e <handle_syscall+0x420>
    802043e2:	08100713          	li	a4,129
    802043e6:	0ee78363          	beq	a5,a4,802044cc <handle_syscall+0x15e>
    802043ea:	08100713          	li	a4,129
    802043ee:	3af76063          	bltu	a4,a5,8020478e <handle_syscall+0x420>
    802043f2:	02a00713          	li	a4,42
    802043f6:	02f76863          	bltu	a4,a5,80204426 <handle_syscall+0xb8>
    802043fa:	38078a63          	beqz	a5,8020478e <handle_syscall+0x420>
    802043fe:	02a00713          	li	a4,42
    80204402:	38f76663          	bltu	a4,a5,8020478e <handle_syscall+0x420>
    80204406:	00279713          	slli	a4,a5,0x2
    8020440a:	0001d797          	auipc	a5,0x1d
    8020440e:	e2e78793          	addi	a5,a5,-466 # 80221238 <user_test_table+0x4f8>
    80204412:	97ba                	add	a5,a5,a4
    80204414:	439c                	lw	a5,0(a5)
    80204416:	0007871b          	sext.w	a4,a5
    8020441a:	0001d797          	auipc	a5,0x1d
    8020441e:	e1e78793          	addi	a5,a5,-482 # 80221238 <user_test_table+0x4f8>
    80204422:	97ba                	add	a5,a5,a4
    80204424:	8782                	jr	a5
    80204426:	05d00713          	li	a4,93
    8020442a:	06e78b63          	beq	a5,a4,802044a0 <handle_syscall+0x132>
    8020442e:	a685                	j	8020478e <handle_syscall+0x420>
			printf("[syscall] print int: %ld\n", tf->a0);
    80204430:	f3843783          	ld	a5,-200(s0)
    80204434:	77dc                	ld	a5,168(a5)
    80204436:	85be                	mv	a1,a5
    80204438:	0001d517          	auipc	a0,0x1d
    8020443c:	c9050513          	addi	a0,a0,-880 # 802210c8 <user_test_table+0x388>
    80204440:	ffffd097          	auipc	ra,0xffffd
    80204444:	e44080e7          	jalr	-444(ra) # 80201284 <printf>
			break;
    80204448:	a6a5                	j	802047b0 <handle_syscall+0x442>
			if (copyinstr(buf, myproc()->pagetable, tf->a0, sizeof(buf)) < 0) {
    8020444a:	00001097          	auipc	ra,0x1
    8020444e:	c16080e7          	jalr	-1002(ra) # 80205060 <myproc>
    80204452:	87aa                	mv	a5,a0
    80204454:	7fd8                	ld	a4,184(a5)
    80204456:	f3843783          	ld	a5,-200(s0)
    8020445a:	77d0                	ld	a2,168(a5)
    8020445c:	f4040793          	addi	a5,s0,-192
    80204460:	08000693          	li	a3,128
    80204464:	85ba                	mv	a1,a4
    80204466:	853e                	mv	a0,a5
    80204468:	00000097          	auipc	ra,0x0
    8020446c:	d36080e7          	jalr	-714(ra) # 8020419e <copyinstr>
    80204470:	87aa                	mv	a5,a0
    80204472:	0007db63          	bgez	a5,80204488 <handle_syscall+0x11a>
				printf("[syscall] invalid string\n");
    80204476:	0001d517          	auipc	a0,0x1d
    8020447a:	c7250513          	addi	a0,a0,-910 # 802210e8 <user_test_table+0x3a8>
    8020447e:	ffffd097          	auipc	ra,0xffffd
    80204482:	e06080e7          	jalr	-506(ra) # 80201284 <printf>
				break;
    80204486:	a62d                	j	802047b0 <handle_syscall+0x442>
			printf("[syscall] print str: %s\n", buf);
    80204488:	f4040793          	addi	a5,s0,-192
    8020448c:	85be                	mv	a1,a5
    8020448e:	0001d517          	auipc	a0,0x1d
    80204492:	c7a50513          	addi	a0,a0,-902 # 80221108 <user_test_table+0x3c8>
    80204496:	ffffd097          	auipc	ra,0xffffd
    8020449a:	dee080e7          	jalr	-530(ra) # 80201284 <printf>
			break;
    8020449e:	ae09                	j	802047b0 <handle_syscall+0x442>
			printf("[syscall] exit(%ld)\n", tf->a0);
    802044a0:	f3843783          	ld	a5,-200(s0)
    802044a4:	77dc                	ld	a5,168(a5)
    802044a6:	85be                	mv	a1,a5
    802044a8:	0001d517          	auipc	a0,0x1d
    802044ac:	c8050513          	addi	a0,a0,-896 # 80221128 <user_test_table+0x3e8>
    802044b0:	ffffd097          	auipc	ra,0xffffd
    802044b4:	dd4080e7          	jalr	-556(ra) # 80201284 <printf>
			exit_proc((int)tf->a0);
    802044b8:	f3843783          	ld	a5,-200(s0)
    802044bc:	77dc                	ld	a5,168(a5)
    802044be:	2781                	sext.w	a5,a5
    802044c0:	853e                	mv	a0,a5
    802044c2:	00002097          	auipc	ra,0x2
    802044c6:	a5a080e7          	jalr	-1446(ra) # 80205f1c <exit_proc>
			break;
    802044ca:	a4dd                	j	802047b0 <handle_syscall+0x442>
			if (myproc()->pid == tf->a0){
    802044cc:	00001097          	auipc	ra,0x1
    802044d0:	b94080e7          	jalr	-1132(ra) # 80205060 <myproc>
    802044d4:	87aa                	mv	a5,a0
    802044d6:	43dc                	lw	a5,4(a5)
    802044d8:	873e                	mv	a4,a5
    802044da:	f3843783          	ld	a5,-200(s0)
    802044de:	77dc                	ld	a5,168(a5)
    802044e0:	00f71a63          	bne	a4,a5,802044f4 <handle_syscall+0x186>
				warning("[syscall] will kill itself!!!\n");
    802044e4:	0001d517          	auipc	a0,0x1d
    802044e8:	c5c50513          	addi	a0,a0,-932 # 80221140 <user_test_table+0x400>
    802044ec:	ffffd097          	auipc	ra,0xffffd
    802044f0:	34e080e7          	jalr	846(ra) # 8020183a <warning>
			kill_proc(tf->a0);
    802044f4:	f3843783          	ld	a5,-200(s0)
    802044f8:	77dc                	ld	a5,168(a5)
    802044fa:	2781                	sext.w	a5,a5
    802044fc:	853e                	mv	a0,a5
    802044fe:	00002097          	auipc	ra,0x2
    80204502:	9ba080e7          	jalr	-1606(ra) # 80205eb8 <kill_proc>
			break;
    80204506:	a46d                	j	802047b0 <handle_syscall+0x442>
			int child_pid = fork_proc();
    80204508:	00001097          	auipc	ra,0x1
    8020450c:	54a080e7          	jalr	1354(ra) # 80205a52 <fork_proc>
    80204510:	87aa                	mv	a5,a0
    80204512:	fcf42e23          	sw	a5,-36(s0)
			tf->a0 = child_pid;
    80204516:	fdc42703          	lw	a4,-36(s0)
    8020451a:	f3843783          	ld	a5,-200(s0)
    8020451e:	f7d8                	sd	a4,168(a5)
			printf("[syscall] fork -> %d\n", child_pid);
    80204520:	fdc42783          	lw	a5,-36(s0)
    80204524:	85be                	mv	a1,a5
    80204526:	0001d517          	auipc	a0,0x1d
    8020452a:	c3a50513          	addi	a0,a0,-966 # 80221160 <user_test_table+0x420>
    8020452e:	ffffd097          	auipc	ra,0xffffd
    80204532:	d56080e7          	jalr	-682(ra) # 80201284 <printf>
			break;
    80204536:	acad                	j	802047b0 <handle_syscall+0x442>
				uint64 uaddr = tf->a0;
    80204538:	f3843783          	ld	a5,-200(s0)
    8020453c:	77dc                	ld	a5,168(a5)
    8020453e:	fef43023          	sd	a5,-32(s0)
				int kstatus = 0;
    80204542:	fc042023          	sw	zero,-64(s0)
				int pid = wait_proc(uaddr ? &kstatus : NULL);  // 在内核里等待并得到退出码
    80204546:	fe043783          	ld	a5,-32(s0)
    8020454a:	c781                	beqz	a5,80204552 <handle_syscall+0x1e4>
    8020454c:	fc040793          	addi	a5,s0,-64
    80204550:	a011                	j	80204554 <handle_syscall+0x1e6>
    80204552:	4781                	li	a5,0
    80204554:	853e                	mv	a0,a5
    80204556:	00002097          	auipc	ra,0x2
    8020455a:	a90080e7          	jalr	-1392(ra) # 80205fe6 <wait_proc>
    8020455e:	87aa                	mv	a5,a0
    80204560:	fef42623          	sw	a5,-20(s0)
				if (pid >= 0 && uaddr) {
    80204564:	fec42783          	lw	a5,-20(s0)
    80204568:	2781                	sext.w	a5,a5
    8020456a:	0207cc63          	bltz	a5,802045a2 <handle_syscall+0x234>
    8020456e:	fe043783          	ld	a5,-32(s0)
    80204572:	cb85                	beqz	a5,802045a2 <handle_syscall+0x234>
					if (copyout(myproc()->pagetable, uaddr, (char *)&kstatus, sizeof(kstatus)) < 0) {
    80204574:	00001097          	auipc	ra,0x1
    80204578:	aec080e7          	jalr	-1300(ra) # 80205060 <myproc>
    8020457c:	87aa                	mv	a5,a0
    8020457e:	7fdc                	ld	a5,184(a5)
    80204580:	fc040713          	addi	a4,s0,-64
    80204584:	4691                	li	a3,4
    80204586:	863a                	mv	a2,a4
    80204588:	fe043583          	ld	a1,-32(s0)
    8020458c:	853e                	mv	a0,a5
    8020458e:	00000097          	auipc	ra,0x0
    80204592:	b94080e7          	jalr	-1132(ra) # 80204122 <copyout>
    80204596:	87aa                	mv	a5,a0
    80204598:	0007d563          	bgez	a5,802045a2 <handle_syscall+0x234>
						pid = -1; // 用户空间地址不可写，视为失败
    8020459c:	57fd                	li	a5,-1
    8020459e:	fef42623          	sw	a5,-20(s0)
				tf->a0 = pid;
    802045a2:	fec42703          	lw	a4,-20(s0)
    802045a6:	f3843783          	ld	a5,-200(s0)
    802045aa:	f7d8                	sd	a4,168(a5)
				break;
    802045ac:	a411                	j	802047b0 <handle_syscall+0x442>
			tf->a0 =0;
    802045ae:	f3843783          	ld	a5,-200(s0)
    802045b2:	0a07b423          	sd	zero,168(a5)
			yield();
    802045b6:	00001097          	auipc	ra,0x1
    802045ba:	726080e7          	jalr	1830(ra) # 80205cdc <yield>
			break;
    802045be:	aacd                	j	802047b0 <handle_syscall+0x442>
			tf->a0 = myproc()->pid;
    802045c0:	00001097          	auipc	ra,0x1
    802045c4:	aa0080e7          	jalr	-1376(ra) # 80205060 <myproc>
    802045c8:	87aa                	mv	a5,a0
    802045ca:	43dc                	lw	a5,4(a5)
    802045cc:	873e                	mv	a4,a5
    802045ce:	f3843783          	ld	a5,-200(s0)
    802045d2:	f7d8                	sd	a4,168(a5)
			break;
    802045d4:	aaf1                	j	802047b0 <handle_syscall+0x442>
			tf->a0 = myproc()->parent ? myproc()->parent->pid : 0;
    802045d6:	00001097          	auipc	ra,0x1
    802045da:	a8a080e7          	jalr	-1398(ra) # 80205060 <myproc>
    802045de:	87aa                	mv	a5,a0
    802045e0:	6fdc                	ld	a5,152(a5)
    802045e2:	cb91                	beqz	a5,802045f6 <handle_syscall+0x288>
    802045e4:	00001097          	auipc	ra,0x1
    802045e8:	a7c080e7          	jalr	-1412(ra) # 80205060 <myproc>
    802045ec:	87aa                	mv	a5,a0
    802045ee:	6fdc                	ld	a5,152(a5)
    802045f0:	43dc                	lw	a5,4(a5)
    802045f2:	873e                	mv	a4,a5
    802045f4:	a011                	j	802045f8 <handle_syscall+0x28a>
    802045f6:	4701                	li	a4,0
    802045f8:	f3843783          	ld	a5,-200(s0)
    802045fc:	f7d8                	sd	a4,168(a5)
			break;
    802045fe:	aa4d                	j	802047b0 <handle_syscall+0x442>
			tf->a0 = get_time();
    80204600:	00002097          	auipc	ra,0x2
    80204604:	1f2080e7          	jalr	498(ra) # 802067f2 <get_time>
    80204608:	872a                	mv	a4,a0
    8020460a:	f3843783          	ld	a5,-200(s0)
    8020460e:	f7d8                	sd	a4,168(a5)
			break;
    80204610:	a245                	j	802047b0 <handle_syscall+0x442>
			tf->a0 = 0;
    80204612:	f3843783          	ld	a5,-200(s0)
    80204616:	0a07b423          	sd	zero,168(a5)
			printf("[syscall] step enabled but do nothing\n");
    8020461a:	0001d517          	auipc	a0,0x1d
    8020461e:	b5e50513          	addi	a0,a0,-1186 # 80221178 <user_test_table+0x438>
    80204622:	ffffd097          	auipc	ra,0xffffd
    80204626:	c62080e7          	jalr	-926(ra) # 80201284 <printf>
			break;
    8020462a:	a259                	j	802047b0 <handle_syscall+0x442>
		int fd = tf->a0;          // 文件描述符
    8020462c:	f3843783          	ld	a5,-200(s0)
    80204630:	77dc                	ld	a5,168(a5)
    80204632:	fcf42c23          	sw	a5,-40(s0)
		if (fd != 1 && fd != 2) {
    80204636:	fd842783          	lw	a5,-40(s0)
    8020463a:	0007871b          	sext.w	a4,a5
    8020463e:	4785                	li	a5,1
    80204640:	00f70e63          	beq	a4,a5,8020465c <handle_syscall+0x2ee>
    80204644:	fd842783          	lw	a5,-40(s0)
    80204648:	0007871b          	sext.w	a4,a5
    8020464c:	4789                	li	a5,2
    8020464e:	00f70763          	beq	a4,a5,8020465c <handle_syscall+0x2ee>
			tf->a0 = -1;
    80204652:	f3843783          	ld	a5,-200(s0)
    80204656:	577d                	li	a4,-1
    80204658:	f7d8                	sd	a4,168(a5)
			break;
    8020465a:	aa99                	j	802047b0 <handle_syscall+0x442>
		if (check_user_addr(tf->a1, tf->a2, 0) < 0) {
    8020465c:	f3843783          	ld	a5,-200(s0)
    80204660:	7bd8                	ld	a4,176(a5)
    80204662:	f3843783          	ld	a5,-200(s0)
    80204666:	7fdc                	ld	a5,184(a5)
    80204668:	4601                	li	a2,0
    8020466a:	85be                	mv	a1,a5
    8020466c:	853a                	mv	a0,a4
    8020466e:	00000097          	auipc	ra,0x0
    80204672:	bca080e7          	jalr	-1078(ra) # 80204238 <check_user_addr>
    80204676:	87aa                	mv	a5,a0
    80204678:	0007df63          	bgez	a5,80204696 <handle_syscall+0x328>
			printf("[syscall] invalid write buffer address\n");
    8020467c:	0001d517          	auipc	a0,0x1d
    80204680:	b2450513          	addi	a0,a0,-1244 # 802211a0 <user_test_table+0x460>
    80204684:	ffffd097          	auipc	ra,0xffffd
    80204688:	c00080e7          	jalr	-1024(ra) # 80201284 <printf>
			tf->a0 = -1;
    8020468c:	f3843783          	ld	a5,-200(s0)
    80204690:	577d                	li	a4,-1
    80204692:	f7d8                	sd	a4,168(a5)
			break;
    80204694:	aa31                	j	802047b0 <handle_syscall+0x442>
		if (copyinstr(buf, myproc()->pagetable, tf->a1, sizeof(buf)) < 0) {
    80204696:	00001097          	auipc	ra,0x1
    8020469a:	9ca080e7          	jalr	-1590(ra) # 80205060 <myproc>
    8020469e:	87aa                	mv	a5,a0
    802046a0:	7fd8                	ld	a4,184(a5)
    802046a2:	f3843783          	ld	a5,-200(s0)
    802046a6:	7bd0                	ld	a2,176(a5)
    802046a8:	f4040793          	addi	a5,s0,-192
    802046ac:	08000693          	li	a3,128
    802046b0:	85ba                	mv	a1,a4
    802046b2:	853e                	mv	a0,a5
    802046b4:	00000097          	auipc	ra,0x0
    802046b8:	aea080e7          	jalr	-1302(ra) # 8020419e <copyinstr>
    802046bc:	87aa                	mv	a5,a0
    802046be:	0007df63          	bgez	a5,802046dc <handle_syscall+0x36e>
			printf("[syscall] invalid write buffer\n");
    802046c2:	0001d517          	auipc	a0,0x1d
    802046c6:	b0650513          	addi	a0,a0,-1274 # 802211c8 <user_test_table+0x488>
    802046ca:	ffffd097          	auipc	ra,0xffffd
    802046ce:	bba080e7          	jalr	-1094(ra) # 80201284 <printf>
			tf->a0 = -1;
    802046d2:	f3843783          	ld	a5,-200(s0)
    802046d6:	577d                	li	a4,-1
    802046d8:	f7d8                	sd	a4,168(a5)
			break;
    802046da:	a8d9                	j	802047b0 <handle_syscall+0x442>
		printf("%s", buf);
    802046dc:	f4040793          	addi	a5,s0,-192
    802046e0:	85be                	mv	a1,a5
    802046e2:	0001d517          	auipc	a0,0x1d
    802046e6:	b0650513          	addi	a0,a0,-1274 # 802211e8 <user_test_table+0x4a8>
    802046ea:	ffffd097          	auipc	ra,0xffffd
    802046ee:	b9a080e7          	jalr	-1126(ra) # 80201284 <printf>
		tf->a0 = strlen(buf);  // 返回写入的字节数
    802046f2:	f4040793          	addi	a5,s0,-192
    802046f6:	853e                	mv	a0,a5
    802046f8:	00002097          	auipc	ra,0x2
    802046fc:	cb4080e7          	jalr	-844(ra) # 802063ac <strlen>
    80204700:	87aa                	mv	a5,a0
    80204702:	873e                	mv	a4,a5
    80204704:	f3843783          	ld	a5,-200(s0)
    80204708:	f7d8                	sd	a4,168(a5)
		break;
    8020470a:	a05d                	j	802047b0 <handle_syscall+0x442>
		int fd = tf->a0;          // 文件描述符
    8020470c:	f3843783          	ld	a5,-200(s0)
    80204710:	77dc                	ld	a5,168(a5)
    80204712:	fcf42a23          	sw	a5,-44(s0)
		uint64 buf = tf->a1;      // 用户缓冲区地址
    80204716:	f3843783          	ld	a5,-200(s0)
    8020471a:	7bdc                	ld	a5,176(a5)
    8020471c:	fcf43423          	sd	a5,-56(s0)
		int n = tf->a2;           // 要读取的字节数
    80204720:	f3843783          	ld	a5,-200(s0)
    80204724:	7fdc                	ld	a5,184(a5)
    80204726:	fcf42223          	sw	a5,-60(s0)
		if (fd != 0) {
    8020472a:	fd442783          	lw	a5,-44(s0)
    8020472e:	2781                	sext.w	a5,a5
    80204730:	c791                	beqz	a5,8020473c <handle_syscall+0x3ce>
			tf->a0 = -1;
    80204732:	f3843783          	ld	a5,-200(s0)
    80204736:	577d                	li	a4,-1
    80204738:	f7d8                	sd	a4,168(a5)
			break;
    8020473a:	a89d                	j	802047b0 <handle_syscall+0x442>
		if (check_user_addr(buf, n, 1) < 0) {  // 1表示写入访问
    8020473c:	fc442783          	lw	a5,-60(s0)
    80204740:	4605                	li	a2,1
    80204742:	85be                	mv	a1,a5
    80204744:	fc843503          	ld	a0,-56(s0)
    80204748:	00000097          	auipc	ra,0x0
    8020474c:	af0080e7          	jalr	-1296(ra) # 80204238 <check_user_addr>
    80204750:	87aa                	mv	a5,a0
    80204752:	0007df63          	bgez	a5,80204770 <handle_syscall+0x402>
			printf("[syscall] invalid read buffer address\n");
    80204756:	0001d517          	auipc	a0,0x1d
    8020475a:	a9a50513          	addi	a0,a0,-1382 # 802211f0 <user_test_table+0x4b0>
    8020475e:	ffffd097          	auipc	ra,0xffffd
    80204762:	b26080e7          	jalr	-1242(ra) # 80201284 <printf>
			tf->a0 = -1;
    80204766:	f3843783          	ld	a5,-200(s0)
    8020476a:	577d                	li	a4,-1
    8020476c:	f7d8                	sd	a4,168(a5)
			break;
    8020476e:	a089                	j	802047b0 <handle_syscall+0x442>
		tf->a0 = -1;
    80204770:	f3843783          	ld	a5,-200(s0)
    80204774:	577d                	li	a4,-1
    80204776:	f7d8                	sd	a4,168(a5)
		break;
    80204778:	a825                	j	802047b0 <handle_syscall+0x442>
            tf->a0 = -1;
    8020477a:	f3843783          	ld	a5,-200(s0)
    8020477e:	577d                	li	a4,-1
    80204780:	f7d8                	sd	a4,168(a5)
            break;
    80204782:	a03d                	j	802047b0 <handle_syscall+0x442>
			tf->a0 = -1;
    80204784:	f3843783          	ld	a5,-200(s0)
    80204788:	577d                	li	a4,-1
    8020478a:	f7d8                	sd	a4,168(a5)
			break;
    8020478c:	a015                	j	802047b0 <handle_syscall+0x442>
			printf("[syscall] unknown syscall: %ld\n", tf->a7);
    8020478e:	f3843783          	ld	a5,-200(s0)
    80204792:	73fc                	ld	a5,224(a5)
    80204794:	85be                	mv	a1,a5
    80204796:	0001d517          	auipc	a0,0x1d
    8020479a:	a8250513          	addi	a0,a0,-1406 # 80221218 <user_test_table+0x4d8>
    8020479e:	ffffd097          	auipc	ra,0xffffd
    802047a2:	ae6080e7          	jalr	-1306(ra) # 80201284 <printf>
			tf->a0 = -1;
    802047a6:	f3843783          	ld	a5,-200(s0)
    802047aa:	577d                	li	a4,-1
    802047ac:	f7d8                	sd	a4,168(a5)
			break;
    802047ae:	0001                	nop
	set_sepc(tf, info->sepc + 4);
    802047b0:	f3043783          	ld	a5,-208(s0)
    802047b4:	639c                	ld	a5,0(a5)
    802047b6:	0791                	addi	a5,a5,4
    802047b8:	85be                	mv	a1,a5
    802047ba:	f3843503          	ld	a0,-200(s0)
    802047be:	fffff097          	auipc	ra,0xfffff
    802047c2:	ff6080e7          	jalr	-10(ra) # 802037b4 <set_sepc>
}
    802047c6:	0001                	nop
    802047c8:	60ae                	ld	ra,200(sp)
    802047ca:	640e                	ld	s0,192(sp)
    802047cc:	6169                	addi	sp,sp,208
    802047ce:	8082                	ret

00000000802047d0 <handle_instruction_page_fault>:
void handle_instruction_page_fault(struct trapframe *tf, struct trap_info *info) {
    802047d0:	1101                	addi	sp,sp,-32
    802047d2:	ec06                	sd	ra,24(sp)
    802047d4:	e822                	sd	s0,16(sp)
    802047d6:	1000                	addi	s0,sp,32
    802047d8:	fea43423          	sd	a0,-24(s0)
    802047dc:	feb43023          	sd	a1,-32(s0)
    printf("Instruction page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    802047e0:	fe043783          	ld	a5,-32(s0)
    802047e4:	6f98                	ld	a4,24(a5)
    802047e6:	fe043783          	ld	a5,-32(s0)
    802047ea:	639c                	ld	a5,0(a5)
    802047ec:	863e                	mv	a2,a5
    802047ee:	85ba                	mv	a1,a4
    802047f0:	0001d517          	auipc	a0,0x1d
    802047f4:	af850513          	addi	a0,a0,-1288 # 802212e8 <user_test_table+0x5a8>
    802047f8:	ffffd097          	auipc	ra,0xffffd
    802047fc:	a8c080e7          	jalr	-1396(ra) # 80201284 <printf>
    if (handle_page_fault(info->stval, 1)) {  // 1表示指令页
    80204800:	fe043783          	ld	a5,-32(s0)
    80204804:	6f9c                	ld	a5,24(a5)
    80204806:	4585                	li	a1,1
    80204808:	853e                	mv	a0,a5
    8020480a:	ffffe097          	auipc	ra,0xffffe
    8020480e:	29e080e7          	jalr	670(ra) # 80202aa8 <handle_page_fault>
    80204812:	87aa                	mv	a5,a0
    80204814:	eb91                	bnez	a5,80204828 <handle_instruction_page_fault+0x58>
    panic("Unhandled instruction page fault");
    80204816:	0001d517          	auipc	a0,0x1d
    8020481a:	b0250513          	addi	a0,a0,-1278 # 80221318 <user_test_table+0x5d8>
    8020481e:	ffffd097          	auipc	ra,0xffffd
    80204822:	fe8080e7          	jalr	-24(ra) # 80201806 <panic>
    80204826:	a011                	j	8020482a <handle_instruction_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    80204828:	0001                	nop
}
    8020482a:	60e2                	ld	ra,24(sp)
    8020482c:	6442                	ld	s0,16(sp)
    8020482e:	6105                	addi	sp,sp,32
    80204830:	8082                	ret

0000000080204832 <handle_load_page_fault>:
void handle_load_page_fault(struct trapframe *tf, struct trap_info *info) {
    80204832:	1101                	addi	sp,sp,-32
    80204834:	ec06                	sd	ra,24(sp)
    80204836:	e822                	sd	s0,16(sp)
    80204838:	1000                	addi	s0,sp,32
    8020483a:	fea43423          	sd	a0,-24(s0)
    8020483e:	feb43023          	sd	a1,-32(s0)
    printf("Load page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    80204842:	fe043783          	ld	a5,-32(s0)
    80204846:	6f98                	ld	a4,24(a5)
    80204848:	fe043783          	ld	a5,-32(s0)
    8020484c:	639c                	ld	a5,0(a5)
    8020484e:	863e                	mv	a2,a5
    80204850:	85ba                	mv	a1,a4
    80204852:	0001d517          	auipc	a0,0x1d
    80204856:	aee50513          	addi	a0,a0,-1298 # 80221340 <user_test_table+0x600>
    8020485a:	ffffd097          	auipc	ra,0xffffd
    8020485e:	a2a080e7          	jalr	-1494(ra) # 80201284 <printf>
    if (handle_page_fault(info->stval, 2)) {  // 2表示读数据页
    80204862:	fe043783          	ld	a5,-32(s0)
    80204866:	6f9c                	ld	a5,24(a5)
    80204868:	4589                	li	a1,2
    8020486a:	853e                	mv	a0,a5
    8020486c:	ffffe097          	auipc	ra,0xffffe
    80204870:	23c080e7          	jalr	572(ra) # 80202aa8 <handle_page_fault>
    80204874:	87aa                	mv	a5,a0
    80204876:	eb91                	bnez	a5,8020488a <handle_load_page_fault+0x58>
    panic("Unhandled load page fault");
    80204878:	0001d517          	auipc	a0,0x1d
    8020487c:	af850513          	addi	a0,a0,-1288 # 80221370 <user_test_table+0x630>
    80204880:	ffffd097          	auipc	ra,0xffffd
    80204884:	f86080e7          	jalr	-122(ra) # 80201806 <panic>
    80204888:	a011                	j	8020488c <handle_load_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    8020488a:	0001                	nop
}
    8020488c:	60e2                	ld	ra,24(sp)
    8020488e:	6442                	ld	s0,16(sp)
    80204890:	6105                	addi	sp,sp,32
    80204892:	8082                	ret

0000000080204894 <handle_store_page_fault>:
void handle_store_page_fault(struct trapframe *tf, struct trap_info *info) {
    80204894:	1101                	addi	sp,sp,-32
    80204896:	ec06                	sd	ra,24(sp)
    80204898:	e822                	sd	s0,16(sp)
    8020489a:	1000                	addi	s0,sp,32
    8020489c:	fea43423          	sd	a0,-24(s0)
    802048a0:	feb43023          	sd	a1,-32(s0)
    printf("Store page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    802048a4:	fe043783          	ld	a5,-32(s0)
    802048a8:	6f98                	ld	a4,24(a5)
    802048aa:	fe043783          	ld	a5,-32(s0)
    802048ae:	639c                	ld	a5,0(a5)
    802048b0:	863e                	mv	a2,a5
    802048b2:	85ba                	mv	a1,a4
    802048b4:	0001d517          	auipc	a0,0x1d
    802048b8:	adc50513          	addi	a0,a0,-1316 # 80221390 <user_test_table+0x650>
    802048bc:	ffffd097          	auipc	ra,0xffffd
    802048c0:	9c8080e7          	jalr	-1592(ra) # 80201284 <printf>
    if (handle_page_fault(info->stval, 3)) {  // 3表示写数据页
    802048c4:	fe043783          	ld	a5,-32(s0)
    802048c8:	6f9c                	ld	a5,24(a5)
    802048ca:	458d                	li	a1,3
    802048cc:	853e                	mv	a0,a5
    802048ce:	ffffe097          	auipc	ra,0xffffe
    802048d2:	1da080e7          	jalr	474(ra) # 80202aa8 <handle_page_fault>
    802048d6:	87aa                	mv	a5,a0
    802048d8:	eb91                	bnez	a5,802048ec <handle_store_page_fault+0x58>
    panic("Unhandled store page fault");
    802048da:	0001d517          	auipc	a0,0x1d
    802048de:	ae650513          	addi	a0,a0,-1306 # 802213c0 <user_test_table+0x680>
    802048e2:	ffffd097          	auipc	ra,0xffffd
    802048e6:	f24080e7          	jalr	-220(ra) # 80201806 <panic>
    802048ea:	a011                	j	802048ee <handle_store_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    802048ec:	0001                	nop
}
    802048ee:	60e2                	ld	ra,24(sp)
    802048f0:	6442                	ld	s0,16(sp)
    802048f2:	6105                	addi	sp,sp,32
    802048f4:	8082                	ret

00000000802048f6 <usertrap>:
void usertrap(void) {
    802048f6:	7159                	addi	sp,sp,-112
    802048f8:	f486                	sd	ra,104(sp)
    802048fa:	f0a2                	sd	s0,96(sp)
    802048fc:	1880                	addi	s0,sp,112
    struct proc *p = myproc();
    802048fe:	00000097          	auipc	ra,0x0
    80204902:	762080e7          	jalr	1890(ra) # 80205060 <myproc>
    80204906:	fea43423          	sd	a0,-24(s0)
    struct trapframe *tf = p->trapframe;
    8020490a:	fe843783          	ld	a5,-24(s0)
    8020490e:	63fc                	ld	a5,192(a5)
    80204910:	fef43023          	sd	a5,-32(s0)
    uint64 scause = r_scause();
    80204914:	fffff097          	auipc	ra,0xfffff
    80204918:	e0e080e7          	jalr	-498(ra) # 80203722 <r_scause>
    8020491c:	fca43c23          	sd	a0,-40(s0)
    uint64 stval  = r_stval();
    80204920:	fffff097          	auipc	ra,0xfffff
    80204924:	e36080e7          	jalr	-458(ra) # 80203756 <r_stval>
    80204928:	fca43823          	sd	a0,-48(s0)
    uint64 sepc   = tf->epc;      // 已由 trampoline 保存
    8020492c:	fe043783          	ld	a5,-32(s0)
    80204930:	7f9c                	ld	a5,56(a5)
    80204932:	fcf43423          	sd	a5,-56(s0)
    uint64 sstatus= tf->sstatus;  // 已由 trampoline 保存
    80204936:	fe043783          	ld	a5,-32(s0)
    8020493a:	7b9c                	ld	a5,48(a5)
    8020493c:	fcf43023          	sd	a5,-64(s0)
    uint64 code = scause & 0xff;
    80204940:	fd843783          	ld	a5,-40(s0)
    80204944:	0ff7f793          	zext.b	a5,a5
    80204948:	faf43c23          	sd	a5,-72(s0)
    uint64 is_intr = (scause >> 63);
    8020494c:	fd843783          	ld	a5,-40(s0)
    80204950:	93fd                	srli	a5,a5,0x3f
    80204952:	faf43823          	sd	a5,-80(s0)
    if (!is_intr && code == 8) { // 用户态 ecall
    80204956:	fb043783          	ld	a5,-80(s0)
    8020495a:	e3a1                	bnez	a5,8020499a <usertrap+0xa4>
    8020495c:	fb843703          	ld	a4,-72(s0)
    80204960:	47a1                	li	a5,8
    80204962:	02f71c63          	bne	a4,a5,8020499a <usertrap+0xa4>
        struct trap_info info = { .sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval };
    80204966:	fc843783          	ld	a5,-56(s0)
    8020496a:	f8f43823          	sd	a5,-112(s0)
    8020496e:	fc043783          	ld	a5,-64(s0)
    80204972:	f8f43c23          	sd	a5,-104(s0)
    80204976:	fd843783          	ld	a5,-40(s0)
    8020497a:	faf43023          	sd	a5,-96(s0)
    8020497e:	fd043783          	ld	a5,-48(s0)
    80204982:	faf43423          	sd	a5,-88(s0)
        handle_syscall(tf, &info);
    80204986:	f9040793          	addi	a5,s0,-112
    8020498a:	85be                	mv	a1,a5
    8020498c:	fe043503          	ld	a0,-32(s0)
    80204990:	00000097          	auipc	ra,0x0
    80204994:	9de080e7          	jalr	-1570(ra) # 8020436e <handle_syscall>
    if (!is_intr && code == 8) { // 用户态 ecall
    80204998:	a869                	j	80204a32 <usertrap+0x13c>
    } else if (is_intr) {
    8020499a:	fb043783          	ld	a5,-80(s0)
    8020499e:	c3ad                	beqz	a5,80204a00 <usertrap+0x10a>
        if (code == 5) {
    802049a0:	fb843703          	ld	a4,-72(s0)
    802049a4:	4795                	li	a5,5
    802049a6:	02f71663          	bne	a4,a5,802049d2 <usertrap+0xdc>
            timeintr();
    802049aa:	fffff097          	auipc	ra,0xfffff
    802049ae:	c6c080e7          	jalr	-916(ra) # 80203616 <timeintr>
            sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    802049b2:	fffff097          	auipc	ra,0xfffff
    802049b6:	c4a080e7          	jalr	-950(ra) # 802035fc <sbi_get_time>
    802049ba:	872a                	mv	a4,a0
    802049bc:	000f47b7          	lui	a5,0xf4
    802049c0:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    802049c4:	97ba                	add	a5,a5,a4
    802049c6:	853e                	mv	a0,a5
    802049c8:	fffff097          	auipc	ra,0xfffff
    802049cc:	c18080e7          	jalr	-1000(ra) # 802035e0 <sbi_set_time>
    802049d0:	a08d                	j	80204a32 <usertrap+0x13c>
        } else if (code == 9) {
    802049d2:	fb843703          	ld	a4,-72(s0)
    802049d6:	47a5                	li	a5,9
    802049d8:	00f71763          	bne	a4,a5,802049e6 <usertrap+0xf0>
            handle_external_interrupt();
    802049dc:	fffff097          	auipc	ra,0xfffff
    802049e0:	f28080e7          	jalr	-216(ra) # 80203904 <handle_external_interrupt>
    802049e4:	a0b9                	j	80204a32 <usertrap+0x13c>
            printf("[usertrap] unknown interrupt scause=%lx sepc=%lx\n", scause, sepc);
    802049e6:	fc843603          	ld	a2,-56(s0)
    802049ea:	fd843583          	ld	a1,-40(s0)
    802049ee:	0001d517          	auipc	a0,0x1d
    802049f2:	9f250513          	addi	a0,a0,-1550 # 802213e0 <user_test_table+0x6a0>
    802049f6:	ffffd097          	auipc	ra,0xffffd
    802049fa:	88e080e7          	jalr	-1906(ra) # 80201284 <printf>
    802049fe:	a815                	j	80204a32 <usertrap+0x13c>
        struct trap_info info = { .sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval };
    80204a00:	fc843783          	ld	a5,-56(s0)
    80204a04:	f8f43823          	sd	a5,-112(s0)
    80204a08:	fc043783          	ld	a5,-64(s0)
    80204a0c:	f8f43c23          	sd	a5,-104(s0)
    80204a10:	fd843783          	ld	a5,-40(s0)
    80204a14:	faf43023          	sd	a5,-96(s0)
    80204a18:	fd043783          	ld	a5,-48(s0)
    80204a1c:	faf43423          	sd	a5,-88(s0)
        handle_exception(tf, &info);
    80204a20:	f9040793          	addi	a5,s0,-112
    80204a24:	85be                	mv	a1,a5
    80204a26:	fe043503          	ld	a0,-32(s0)
    80204a2a:	fffff097          	auipc	ra,0xfffff
    80204a2e:	18e080e7          	jalr	398(ra) # 80203bb8 <handle_exception>
    usertrapret();
    80204a32:	00000097          	auipc	ra,0x0
    80204a36:	012080e7          	jalr	18(ra) # 80204a44 <usertrapret>
}
    80204a3a:	0001                	nop
    80204a3c:	70a6                	ld	ra,104(sp)
    80204a3e:	7406                	ld	s0,96(sp)
    80204a40:	6165                	addi	sp,sp,112
    80204a42:	8082                	ret

0000000080204a44 <usertrapret>:
void usertrapret(void) {
    80204a44:	7179                	addi	sp,sp,-48
    80204a46:	f406                	sd	ra,40(sp)
    80204a48:	f022                	sd	s0,32(sp)
    80204a4a:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80204a4c:	00000097          	auipc	ra,0x0
    80204a50:	614080e7          	jalr	1556(ra) # 80205060 <myproc>
    80204a54:	fea43423          	sd	a0,-24(s0)
    uint64 uservec_va = (uint64)TRAMPOLINE + ((uint64)uservec - (uint64)trampoline);
    80204a58:	00000717          	auipc	a4,0x0
    80204a5c:	34870713          	addi	a4,a4,840 # 80204da0 <trampoline>
    80204a60:	77fd                	lui	a5,0xfffff
    80204a62:	973e                	add	a4,a4,a5
    80204a64:	00000797          	auipc	a5,0x0
    80204a68:	33c78793          	addi	a5,a5,828 # 80204da0 <trampoline>
    80204a6c:	40f707b3          	sub	a5,a4,a5
    80204a70:	fef43023          	sd	a5,-32(s0)
    w_stvec(uservec_va);
    80204a74:	fe043503          	ld	a0,-32(s0)
    80204a78:	fffff097          	auipc	ra,0xfffff
    80204a7c:	c90080e7          	jalr	-880(ra) # 80203708 <w_stvec>
    w_sscratch((uint64)TRAPFRAME);
    80204a80:	7579                	lui	a0,0xffffe
    80204a82:	fffff097          	auipc	ra,0xfffff
    80204a86:	c2a080e7          	jalr	-982(ra) # 802036ac <w_sscratch>
    uint64 user_satp = MAKE_SATP(p->pagetable);
    80204a8a:	fe843783          	ld	a5,-24(s0)
    80204a8e:	7fdc                	ld	a5,184(a5)
    80204a90:	00c7d713          	srli	a4,a5,0xc
    80204a94:	57fd                	li	a5,-1
    80204a96:	17fe                	slli	a5,a5,0x3f
    80204a98:	8fd9                	or	a5,a5,a4
    80204a9a:	fcf43c23          	sd	a5,-40(s0)
    uint64 userret_va = (uint64)TRAMPOLINE + ((uint64)userret - (uint64)trampoline);
    80204a9e:	00000717          	auipc	a4,0x0
    80204aa2:	3a870713          	addi	a4,a4,936 # 80204e46 <userret>
    80204aa6:	77fd                	lui	a5,0xfffff
    80204aa8:	973e                	add	a4,a4,a5
    80204aaa:	00000797          	auipc	a5,0x0
    80204aae:	2f678793          	addi	a5,a5,758 # 80204da0 <trampoline>
    80204ab2:	40f707b3          	sub	a5,a4,a5
    80204ab6:	fcf43823          	sd	a5,-48(s0)
    register uint64 a0 asm("a0") = (uint64)TRAPFRAME;
    80204aba:	7579                	lui	a0,0xffffe
    register uint64 a1 asm("a1") = user_satp;
    80204abc:	fd843583          	ld	a1,-40(s0)
    register void (*tgt)(uint64, uint64) asm("t0") = (void *)userret_va;
    80204ac0:	fd043783          	ld	a5,-48(s0)
    80204ac4:	82be                	mv	t0,a5
    asm volatile("jr t0" :: "r"(a0), "r"(a1), "r"(tgt) : "memory");
    80204ac6:	8282                	jr	t0
}
    80204ac8:	0001                	nop
    80204aca:	70a2                	ld	ra,40(sp)
    80204acc:	7402                	ld	s0,32(sp)
    80204ace:	6145                	addi	sp,sp,48
    80204ad0:	8082                	ret

0000000080204ad2 <write32>:
    80204ad2:	7179                	addi	sp,sp,-48
    80204ad4:	f406                	sd	ra,40(sp)
    80204ad6:	f022                	sd	s0,32(sp)
    80204ad8:	1800                	addi	s0,sp,48
    80204ada:	fca43c23          	sd	a0,-40(s0)
    80204ade:	87ae                	mv	a5,a1
    80204ae0:	fcf42a23          	sw	a5,-44(s0)
    80204ae4:	fd843783          	ld	a5,-40(s0)
    80204ae8:	8b8d                	andi	a5,a5,3
    80204aea:	eb99                	bnez	a5,80204b00 <write32+0x2e>
    80204aec:	fd843783          	ld	a5,-40(s0)
    80204af0:	fef43423          	sd	a5,-24(s0)
    80204af4:	fe843783          	ld	a5,-24(s0)
    80204af8:	fd442703          	lw	a4,-44(s0)
    80204afc:	c398                	sw	a4,0(a5)
    80204afe:	a819                	j	80204b14 <write32+0x42>
    80204b00:	fd843583          	ld	a1,-40(s0)
    80204b04:	0001f517          	auipc	a0,0x1f
    80204b08:	9c450513          	addi	a0,a0,-1596 # 802234c8 <user_test_table+0x78>
    80204b0c:	ffffc097          	auipc	ra,0xffffc
    80204b10:	778080e7          	jalr	1912(ra) # 80201284 <printf>
    80204b14:	0001                	nop
    80204b16:	70a2                	ld	ra,40(sp)
    80204b18:	7402                	ld	s0,32(sp)
    80204b1a:	6145                	addi	sp,sp,48
    80204b1c:	8082                	ret

0000000080204b1e <read32>:
    80204b1e:	7179                	addi	sp,sp,-48
    80204b20:	f406                	sd	ra,40(sp)
    80204b22:	f022                	sd	s0,32(sp)
    80204b24:	1800                	addi	s0,sp,48
    80204b26:	fca43c23          	sd	a0,-40(s0)
    80204b2a:	fd843783          	ld	a5,-40(s0)
    80204b2e:	8b8d                	andi	a5,a5,3
    80204b30:	eb91                	bnez	a5,80204b44 <read32+0x26>
    80204b32:	fd843783          	ld	a5,-40(s0)
    80204b36:	fef43423          	sd	a5,-24(s0)
    80204b3a:	fe843783          	ld	a5,-24(s0)
    80204b3e:	439c                	lw	a5,0(a5)
    80204b40:	2781                	sext.w	a5,a5
    80204b42:	a821                	j	80204b5a <read32+0x3c>
    80204b44:	fd843583          	ld	a1,-40(s0)
    80204b48:	0001f517          	auipc	a0,0x1f
    80204b4c:	9b050513          	addi	a0,a0,-1616 # 802234f8 <user_test_table+0xa8>
    80204b50:	ffffc097          	auipc	ra,0xffffc
    80204b54:	734080e7          	jalr	1844(ra) # 80201284 <printf>
    80204b58:	4781                	li	a5,0
    80204b5a:	853e                	mv	a0,a5
    80204b5c:	70a2                	ld	ra,40(sp)
    80204b5e:	7402                	ld	s0,32(sp)
    80204b60:	6145                	addi	sp,sp,48
    80204b62:	8082                	ret

0000000080204b64 <plic_init>:
void plic_init(void) {
    80204b64:	1101                	addi	sp,sp,-32
    80204b66:	ec06                	sd	ra,24(sp)
    80204b68:	e822                	sd	s0,16(sp)
    80204b6a:	1000                	addi	s0,sp,32
    for (int i = 1; i <= 32; i++) {
    80204b6c:	4785                	li	a5,1
    80204b6e:	fef42623          	sw	a5,-20(s0)
    80204b72:	a805                	j	80204ba2 <plic_init+0x3e>
        uint64 addr = PLIC + i * 4;
    80204b74:	fec42783          	lw	a5,-20(s0)
    80204b78:	0027979b          	slliw	a5,a5,0x2
    80204b7c:	2781                	sext.w	a5,a5
    80204b7e:	873e                	mv	a4,a5
    80204b80:	0c0007b7          	lui	a5,0xc000
    80204b84:	97ba                	add	a5,a5,a4
    80204b86:	fef43023          	sd	a5,-32(s0)
        write32(addr, 0);
    80204b8a:	4581                	li	a1,0
    80204b8c:	fe043503          	ld	a0,-32(s0)
    80204b90:	00000097          	auipc	ra,0x0
    80204b94:	f42080e7          	jalr	-190(ra) # 80204ad2 <write32>
    for (int i = 1; i <= 32; i++) {
    80204b98:	fec42783          	lw	a5,-20(s0)
    80204b9c:	2785                	addiw	a5,a5,1 # c000001 <_entry-0x741fffff>
    80204b9e:	fef42623          	sw	a5,-20(s0)
    80204ba2:	fec42783          	lw	a5,-20(s0)
    80204ba6:	0007871b          	sext.w	a4,a5
    80204baa:	02000793          	li	a5,32
    80204bae:	fce7d3e3          	bge	a5,a4,80204b74 <plic_init+0x10>
    write32(PLIC + UART0_IRQ * 4, 1);
    80204bb2:	4585                	li	a1,1
    80204bb4:	0c0007b7          	lui	a5,0xc000
    80204bb8:	02878513          	addi	a0,a5,40 # c000028 <_entry-0x741fffd8>
    80204bbc:	00000097          	auipc	ra,0x0
    80204bc0:	f16080e7          	jalr	-234(ra) # 80204ad2 <write32>
    write32(PLIC + VIRTIO0_IRQ * 4, 1);
    80204bc4:	4585                	li	a1,1
    80204bc6:	0c0007b7          	lui	a5,0xc000
    80204bca:	00478513          	addi	a0,a5,4 # c000004 <_entry-0x741ffffc>
    80204bce:	00000097          	auipc	ra,0x0
    80204bd2:	f04080e7          	jalr	-252(ra) # 80204ad2 <write32>
    write32(PLIC_ENABLE, (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ));
    80204bd6:	40200593          	li	a1,1026
    80204bda:	0c0027b7          	lui	a5,0xc002
    80204bde:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204be2:	00000097          	auipc	ra,0x0
    80204be6:	ef0080e7          	jalr	-272(ra) # 80204ad2 <write32>
    write32(PLIC_THRESHOLD, 0);
    80204bea:	4581                	li	a1,0
    80204bec:	0c201537          	lui	a0,0xc201
    80204bf0:	00000097          	auipc	ra,0x0
    80204bf4:	ee2080e7          	jalr	-286(ra) # 80204ad2 <write32>
}
    80204bf8:	0001                	nop
    80204bfa:	60e2                	ld	ra,24(sp)
    80204bfc:	6442                	ld	s0,16(sp)
    80204bfe:	6105                	addi	sp,sp,32
    80204c00:	8082                	ret

0000000080204c02 <plic_enable>:
void plic_enable(int irq) {
    80204c02:	7179                	addi	sp,sp,-48
    80204c04:	f406                	sd	ra,40(sp)
    80204c06:	f022                	sd	s0,32(sp)
    80204c08:	1800                	addi	s0,sp,48
    80204c0a:	87aa                	mv	a5,a0
    80204c0c:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    80204c10:	0c0027b7          	lui	a5,0xc002
    80204c14:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204c18:	00000097          	auipc	ra,0x0
    80204c1c:	f06080e7          	jalr	-250(ra) # 80204b1e <read32>
    80204c20:	87aa                	mv	a5,a0
    80204c22:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old | (1 << irq));
    80204c26:	fdc42783          	lw	a5,-36(s0)
    80204c2a:	873e                	mv	a4,a5
    80204c2c:	4785                	li	a5,1
    80204c2e:	00e797bb          	sllw	a5,a5,a4
    80204c32:	2781                	sext.w	a5,a5
    80204c34:	2781                	sext.w	a5,a5
    80204c36:	fec42703          	lw	a4,-20(s0)
    80204c3a:	8fd9                	or	a5,a5,a4
    80204c3c:	2781                	sext.w	a5,a5
    80204c3e:	85be                	mv	a1,a5
    80204c40:	0c0027b7          	lui	a5,0xc002
    80204c44:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204c48:	00000097          	auipc	ra,0x0
    80204c4c:	e8a080e7          	jalr	-374(ra) # 80204ad2 <write32>
}
    80204c50:	0001                	nop
    80204c52:	70a2                	ld	ra,40(sp)
    80204c54:	7402                	ld	s0,32(sp)
    80204c56:	6145                	addi	sp,sp,48
    80204c58:	8082                	ret

0000000080204c5a <plic_disable>:
void plic_disable(int irq) {
    80204c5a:	7179                	addi	sp,sp,-48
    80204c5c:	f406                	sd	ra,40(sp)
    80204c5e:	f022                	sd	s0,32(sp)
    80204c60:	1800                	addi	s0,sp,48
    80204c62:	87aa                	mv	a5,a0
    80204c64:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    80204c68:	0c0027b7          	lui	a5,0xc002
    80204c6c:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204c70:	00000097          	auipc	ra,0x0
    80204c74:	eae080e7          	jalr	-338(ra) # 80204b1e <read32>
    80204c78:	87aa                	mv	a5,a0
    80204c7a:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old & ~(1 << irq));
    80204c7e:	fdc42783          	lw	a5,-36(s0)
    80204c82:	873e                	mv	a4,a5
    80204c84:	4785                	li	a5,1
    80204c86:	00e797bb          	sllw	a5,a5,a4
    80204c8a:	2781                	sext.w	a5,a5
    80204c8c:	fff7c793          	not	a5,a5
    80204c90:	2781                	sext.w	a5,a5
    80204c92:	2781                	sext.w	a5,a5
    80204c94:	fec42703          	lw	a4,-20(s0)
    80204c98:	8ff9                	and	a5,a5,a4
    80204c9a:	2781                	sext.w	a5,a5
    80204c9c:	85be                	mv	a1,a5
    80204c9e:	0c0027b7          	lui	a5,0xc002
    80204ca2:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204ca6:	00000097          	auipc	ra,0x0
    80204caa:	e2c080e7          	jalr	-468(ra) # 80204ad2 <write32>
}
    80204cae:	0001                	nop
    80204cb0:	70a2                	ld	ra,40(sp)
    80204cb2:	7402                	ld	s0,32(sp)
    80204cb4:	6145                	addi	sp,sp,48
    80204cb6:	8082                	ret

0000000080204cb8 <plic_claim>:
int plic_claim(void) {
    80204cb8:	1141                	addi	sp,sp,-16
    80204cba:	e406                	sd	ra,8(sp)
    80204cbc:	e022                	sd	s0,0(sp)
    80204cbe:	0800                	addi	s0,sp,16
    return read32(PLIC_CLAIM);
    80204cc0:	0c2017b7          	lui	a5,0xc201
    80204cc4:	00478513          	addi	a0,a5,4 # c201004 <_entry-0x73ffeffc>
    80204cc8:	00000097          	auipc	ra,0x0
    80204ccc:	e56080e7          	jalr	-426(ra) # 80204b1e <read32>
    80204cd0:	87aa                	mv	a5,a0
    80204cd2:	2781                	sext.w	a5,a5
    80204cd4:	2781                	sext.w	a5,a5
}
    80204cd6:	853e                	mv	a0,a5
    80204cd8:	60a2                	ld	ra,8(sp)
    80204cda:	6402                	ld	s0,0(sp)
    80204cdc:	0141                	addi	sp,sp,16
    80204cde:	8082                	ret

0000000080204ce0 <plic_complete>:
void plic_complete(int irq) {
    80204ce0:	1101                	addi	sp,sp,-32
    80204ce2:	ec06                	sd	ra,24(sp)
    80204ce4:	e822                	sd	s0,16(sp)
    80204ce6:	1000                	addi	s0,sp,32
    80204ce8:	87aa                	mv	a5,a0
    80204cea:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_CLAIM, irq);
    80204cee:	fec42783          	lw	a5,-20(s0)
    80204cf2:	85be                	mv	a1,a5
    80204cf4:	0c2017b7          	lui	a5,0xc201
    80204cf8:	00478513          	addi	a0,a5,4 # c201004 <_entry-0x73ffeffc>
    80204cfc:	00000097          	auipc	ra,0x0
    80204d00:	dd6080e7          	jalr	-554(ra) # 80204ad2 <write32>
    80204d04:	0001                	nop
    80204d06:	60e2                	ld	ra,24(sp)
    80204d08:	6442                	ld	s0,16(sp)
    80204d0a:	6105                	addi	sp,sp,32
    80204d0c:	8082                	ret
	...

0000000080204d10 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80204d10:	7111                	addi	sp,sp,-256

        # save ALL registers (caller-saved and callee-saved)
        sd ra, 0(sp)
    80204d12:	e006                	sd	ra,0(sp)
        sd gp, 16(sp)
    80204d14:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80204d16:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80204d18:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80204d1a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    80204d1c:	f81e                	sd	t2,48(sp)
        sd s0, 56(sp)    # 保存s0/fp
    80204d1e:	fc22                	sd	s0,56(sp)
        sd s1, 64(sp)    # 保存s1
    80204d20:	e0a6                	sd	s1,64(sp)
        sd a0, 72(sp)
    80204d22:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80204d24:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80204d26:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80204d28:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80204d2a:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80204d2c:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80204d2e:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80204d30:	e146                	sd	a7,128(sp)
        sd s2, 136(sp)   # 保存s2
    80204d32:	e54a                	sd	s2,136(sp)
        sd s3, 144(sp)   # 保存s3
    80204d34:	e94e                	sd	s3,144(sp)
        sd s4, 152(sp)   # 保存s4
    80204d36:	ed52                	sd	s4,152(sp)
        sd s5, 160(sp)   # 保存s5
    80204d38:	f156                	sd	s5,160(sp)
        sd s6, 168(sp)   # 保存s6
    80204d3a:	f55a                	sd	s6,168(sp)
        sd s7, 176(sp)   # 保存s7
    80204d3c:	f95e                	sd	s7,176(sp)
        sd s8, 184(sp)   # 保存s8
    80204d3e:	fd62                	sd	s8,184(sp)
        sd s9, 192(sp)   # 保存s9
    80204d40:	e1e6                	sd	s9,192(sp)
        sd s10, 200(sp)  # 保存s10
    80204d42:	e5ea                	sd	s10,200(sp)
        sd s11, 208(sp)  # 保存s11
    80204d44:	e9ee                	sd	s11,208(sp)
        sd t3, 216(sp)
    80204d46:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80204d48:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80204d4a:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80204d4c:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80204d4e:	fffff097          	auipc	ra,0xfffff
    80204d52:	cf8080e7          	jalr	-776(ra) # 80203a46 <kerneltrap>

        # restore ALL registers
        ld ra, 0(sp)
    80204d56:	6082                	ld	ra,0(sp)
        # 不恢复sp
        ld gp, 16(sp)
    80204d58:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    80204d5a:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80204d5c:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80204d5e:	73c2                	ld	t2,48(sp)
        ld s0, 56(sp)    # 恢复s0/fp
    80204d60:	7462                	ld	s0,56(sp)
        ld s1, 64(sp)    # 恢复s1
    80204d62:	6486                	ld	s1,64(sp)
        ld a0, 72(sp)
    80204d64:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80204d66:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80204d68:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80204d6a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    80204d6c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    80204d6e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80204d70:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80204d72:	688a                	ld	a7,128(sp)
        ld s2, 136(sp)   # 恢复s2
    80204d74:	692a                	ld	s2,136(sp)
        ld s3, 144(sp)   # 恢复s3
    80204d76:	69ca                	ld	s3,144(sp)
        ld s4, 152(sp)   # 恢复s4
    80204d78:	6a6a                	ld	s4,152(sp)
        ld s5, 160(sp)   # 恢复s5
    80204d7a:	7a8a                	ld	s5,160(sp)
        ld s6, 168(sp)   # 恢复s6
    80204d7c:	7b2a                	ld	s6,168(sp)
        ld s7, 176(sp)   # 恢复s7
    80204d7e:	7bca                	ld	s7,176(sp)
        ld s8, 184(sp)   # 恢复s8
    80204d80:	7c6a                	ld	s8,184(sp)
        ld s9, 192(sp)   # 恢复s9
    80204d82:	6c8e                	ld	s9,192(sp)
        ld s10, 200(sp)  # 恢复s10
    80204d84:	6d2e                	ld	s10,200(sp)
        ld s11, 208(sp)  # 恢复s11
    80204d86:	6dce                	ld	s11,208(sp)
        ld t3, 216(sp)
    80204d88:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80204d8a:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80204d8c:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80204d8e:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80204d90:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
    80204d92:	10200073          	sret
    80204d96:	0001                	nop
    80204d98:	00000013          	nop
    80204d9c:	00000013          	nop

0000000080204da0 <trampoline>:
trampoline:
.align 4

uservec:
    # 1. 取 trapframe 指针
    csrrw a0, sscratch, a0      # a0 = TRAPFRAME (用户页表下可访问), sscratch = user a0
    80204da0:	14051573          	csrrw	a0,sscratch,a0

    # 2. 按新的trapframe结构保存寄存器
    sd   ra, 64(a0)             # ra offset: 64
    80204da4:	04153023          	sd	ra,64(a0) # c201040 <_entry-0x73ffefc0>
    sd   sp, 72(a0)             # sp offset: 72
    80204da8:	04253423          	sd	sp,72(a0)
    sd   gp, 80(a0)             # gp offset: 80
    80204dac:	04353823          	sd	gp,80(a0)
    sd   tp, 88(a0)             # tp offset: 88
    80204db0:	04453c23          	sd	tp,88(a0)
    sd   t0, 96(a0)             # t0 offset: 96
    80204db4:	06553023          	sd	t0,96(a0)
    sd   t1, 104(a0)            # t1 offset: 104
    80204db8:	06653423          	sd	t1,104(a0)
    sd   t2, 112(a0)            # t2 offset: 112
    80204dbc:	06753823          	sd	t2,112(a0)
    sd   t3, 120(a0)            # t3 offset: 120
    80204dc0:	07c53c23          	sd	t3,120(a0)
    sd   t4, 128(a0)            # t4 offset: 128
    80204dc4:	09d53023          	sd	t4,128(a0)
    sd   t5, 136(a0)            # t5 offset: 136
    80204dc8:	09e53423          	sd	t5,136(a0)
    sd   t6, 144(a0)            # t6 offset: 144
    80204dcc:	09f53823          	sd	t6,144(a0)
    sd   s0, 152(a0)            # s0 offset: 152
    80204dd0:	ed40                	sd	s0,152(a0)
    sd   s1, 160(a0)            # s1 offset: 160
    80204dd2:	f144                	sd	s1,160(a0)

    # 继续保存其他寄存器
    sd   a1, 176(a0)            # a1 offset: 176
    80204dd4:	f94c                	sd	a1,176(a0)
    sd   a2, 184(a0)            # a2 offset: 184
    80204dd6:	fd50                	sd	a2,184(a0)
    sd   a3, 192(a0)            # a3 offset: 192
    80204dd8:	e174                	sd	a3,192(a0)
    sd   a4, 200(a0)            # a4 offset: 200
    80204dda:	e578                	sd	a4,200(a0)
    sd   a5, 208(a0)            # a5 offset: 208
    80204ddc:	e97c                	sd	a5,208(a0)
    sd   a6, 216(a0)            # a6 offset: 216
    80204dde:	0d053c23          	sd	a6,216(a0)
    sd   a7, 224(a0)            # a7 offset: 224
    80204de2:	0f153023          	sd	a7,224(a0)
    sd   s2, 232(a0)            # s2 offset: 232
    80204de6:	0f253423          	sd	s2,232(a0)
    sd   s3, 240(a0)            # s3 offset: 240
    80204dea:	0f353823          	sd	s3,240(a0)
    sd   s4, 248(a0)            # s4 offset: 248
    80204dee:	0f453c23          	sd	s4,248(a0)
    sd   s5, 256(a0)            # s5 offset: 256
    80204df2:	11553023          	sd	s5,256(a0)
    sd   s6, 264(a0)            # s6 offset: 264
    80204df6:	11653423          	sd	s6,264(a0)
    sd   s7, 272(a0)            # s7 offset: 272
    80204dfa:	11753823          	sd	s7,272(a0)
    sd   s8, 280(a0)            # s8 offset: 280
    80204dfe:	11853c23          	sd	s8,280(a0)
    sd   s9, 288(a0)            # s9 offset: 288
    80204e02:	13953023          	sd	s9,288(a0)
    sd   s10, 296(a0)           # s10 offset: 296
    80204e06:	13a53423          	sd	s10,296(a0)
    sd   s11, 304(a0)           # s11 offset: 304
    80204e0a:	13b53823          	sd	s11,304(a0)

	# 保存用户 a0：先取回 sscratch 里的原值
    csrr t0, sscratch
    80204e0e:	140022f3          	csrr	t0,sscratch
    sd   t0, 168(a0)
    80204e12:	0a553423          	sd	t0,168(a0)

    # 保存控制寄存器
    csrr t0, sstatus
    80204e16:	100022f3          	csrr	t0,sstatus
    sd   t0, 48(a0)
    80204e1a:	02553823          	sd	t0,48(a0)
    csrr t1, sepc
    80204e1e:	14102373          	csrr	t1,sepc
    sd   t1, 56(a0)
    80204e22:	02653c23          	sd	t1,56(a0)

	# 在切换页表前，先读出关键字段到 t3–t6
    ld   t3, 0(a0)              # t3 = kernel_satp
    80204e26:	00053e03          	ld	t3,0(a0)
    ld   t4, 8(a0)              # t4 = kernel_sp
    80204e2a:	00853e83          	ld	t4,8(a0)
    ld   t5, 24(a0)            # t5 = usertrap
    80204e2e:	01853f03          	ld	t5,24(a0)
	ld   t6, 32(a0)			# t6 = kernel_vec
    80204e32:	02053f83          	ld	t6,32(a0)

    # 4. 切换到内核页表
    csrw satp, t3
    80204e36:	180e1073          	csrw	satp,t3
    sfence.vma x0, x0
    80204e3a:	12000073          	sfence.vma

    # 5. 切换到内核栈
    mv   sp, t4
    80204e3e:	8176                	mv	sp,t4

    # 6. 设置 stvec 并跳转到 C 层 usertrap
    csrw stvec, t6
    80204e40:	105f9073          	csrw	stvec,t6
    jr   t5
    80204e44:	8f02                	jr	t5

0000000080204e46 <userret>:
userret:
        csrw satp, a1
    80204e46:	18059073          	csrw	satp,a1
        sfence.vma zero, zero
    80204e4a:	12000073          	sfence.vma
    # 2. 按新的偏移量恢复寄存器
    ld   ra, 64(a0)
    80204e4e:	04053083          	ld	ra,64(a0)
    ld   sp, 72(a0)
    80204e52:	04853103          	ld	sp,72(a0)
    ld   gp, 80(a0)
    80204e56:	05053183          	ld	gp,80(a0)
    ld   tp, 88(a0)
    80204e5a:	05853203          	ld	tp,88(a0)
    ld   t0, 96(a0)
    80204e5e:	06053283          	ld	t0,96(a0)
    ld   t1, 104(a0)
    80204e62:	06853303          	ld	t1,104(a0)
    ld   t2, 112(a0)
    80204e66:	07053383          	ld	t2,112(a0)
    ld   t3, 120(a0)
    80204e6a:	07853e03          	ld	t3,120(a0)
    ld   t4, 128(a0)
    80204e6e:	08053e83          	ld	t4,128(a0)
    ld   t5, 136(a0)
    80204e72:	08853f03          	ld	t5,136(a0)
    ld   t6, 144(a0)
    80204e76:	09053f83          	ld	t6,144(a0)
    ld   s0, 152(a0)
    80204e7a:	6d40                	ld	s0,152(a0)
    ld   s1, 160(a0)
    80204e7c:	7144                	ld	s1,160(a0)
    ld   a1, 176(a0)
    80204e7e:	794c                	ld	a1,176(a0)
    ld   a2, 184(a0)
    80204e80:	7d50                	ld	a2,184(a0)
    ld   a3, 192(a0)
    80204e82:	6174                	ld	a3,192(a0)
    ld   a4, 200(a0)
    80204e84:	6578                	ld	a4,200(a0)
    ld   a5, 208(a0)
    80204e86:	697c                	ld	a5,208(a0)
    ld   a6, 216(a0)
    80204e88:	0d853803          	ld	a6,216(a0)
    ld   a7, 224(a0)
    80204e8c:	0e053883          	ld	a7,224(a0)
    ld   s2, 232(a0)
    80204e90:	0e853903          	ld	s2,232(a0)
    ld   s3, 240(a0)
    80204e94:	0f053983          	ld	s3,240(a0)
    ld   s4, 248(a0)
    80204e98:	0f853a03          	ld	s4,248(a0)
    ld   s5, 256(a0)
    80204e9c:	10053a83          	ld	s5,256(a0)
    ld   s6, 264(a0)
    80204ea0:	10853b03          	ld	s6,264(a0)
    ld   s7, 272(a0)
    80204ea4:	11053b83          	ld	s7,272(a0)
    ld   s8, 280(a0)
    80204ea8:	11853c03          	ld	s8,280(a0)
    ld   s9, 288(a0)
    80204eac:	12053c83          	ld	s9,288(a0)
    ld   s10, 296(a0)
    80204eb0:	12853d03          	ld	s10,296(a0)
    ld   s11, 304(a0)
    80204eb4:	13053d83          	ld	s11,304(a0)

        # 使用临时变量恢复控制寄存器
        ld t0, 56(a0)      # 恢复 sepc
    80204eb8:	03853283          	ld	t0,56(a0)
        csrw sepc, t0
    80204ebc:	14129073          	csrw	sepc,t0
        ld t0, 48(a0)      # 恢复 sstatus
    80204ec0:	03053283          	ld	t0,48(a0)
        csrw sstatus, t0
    80204ec4:	10029073          	csrw	sstatus,t0
		csrw sscratch, a0
    80204ec8:	14051073          	csrw	sscratch,a0
		ld a0, 168(a0)
    80204ecc:	7548                	ld	a0,168(a0)
    80204ece:	10200073          	sret
    80204ed2:	0001                	nop
    80204ed4:	00000013          	nop
    80204ed8:	00000013          	nop
    80204edc:	00000013          	nop

0000000080204ee0 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80204ee0:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80204ee4:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80204ee8:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80204eea:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80204eec:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80204ef0:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80204ef4:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80204ef8:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80204efc:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80204f00:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80204f04:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80204f08:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80204f0c:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80204f10:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80204f14:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80204f18:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80204f1c:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80204f1e:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80204f20:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80204f24:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80204f28:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80204f2c:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80204f30:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80204f34:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80204f38:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80204f3c:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80204f40:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80204f44:	0685bd83          	ld	s11,104(a1)
        
        ret
    80204f48:	8082                	ret

0000000080204f4a <r_sstatus>:
    80204f4a:	1101                	addi	sp,sp,-32
    80204f4c:	ec22                	sd	s0,24(sp)
    80204f4e:	1000                	addi	s0,sp,32
    80204f50:	100027f3          	csrr	a5,sstatus
    80204f54:	fef43423          	sd	a5,-24(s0)
    80204f58:	fe843783          	ld	a5,-24(s0)
    80204f5c:	853e                	mv	a0,a5
    80204f5e:	6462                	ld	s0,24(sp)
    80204f60:	6105                	addi	sp,sp,32
    80204f62:	8082                	ret

0000000080204f64 <w_sstatus>:
    80204f64:	1101                	addi	sp,sp,-32
    80204f66:	ec22                	sd	s0,24(sp)
    80204f68:	1000                	addi	s0,sp,32
    80204f6a:	fea43423          	sd	a0,-24(s0)
    80204f6e:	fe843783          	ld	a5,-24(s0)
    80204f72:	10079073          	csrw	sstatus,a5
    80204f76:	0001                	nop
    80204f78:	6462                	ld	s0,24(sp)
    80204f7a:	6105                	addi	sp,sp,32
    80204f7c:	8082                	ret

0000000080204f7e <intr_on>:
    80204f7e:	1141                	addi	sp,sp,-16
    80204f80:	e406                	sd	ra,8(sp)
    80204f82:	e022                	sd	s0,0(sp)
    80204f84:	0800                	addi	s0,sp,16
    80204f86:	00000097          	auipc	ra,0x0
    80204f8a:	fc4080e7          	jalr	-60(ra) # 80204f4a <r_sstatus>
    80204f8e:	87aa                	mv	a5,a0
    80204f90:	0027e793          	ori	a5,a5,2
    80204f94:	853e                	mv	a0,a5
    80204f96:	00000097          	auipc	ra,0x0
    80204f9a:	fce080e7          	jalr	-50(ra) # 80204f64 <w_sstatus>
    80204f9e:	0001                	nop
    80204fa0:	60a2                	ld	ra,8(sp)
    80204fa2:	6402                	ld	s0,0(sp)
    80204fa4:	0141                	addi	sp,sp,16
    80204fa6:	8082                	ret

0000000080204fa8 <intr_off>:
    80204fa8:	1141                	addi	sp,sp,-16
    80204faa:	e406                	sd	ra,8(sp)
    80204fac:	e022                	sd	s0,0(sp)
    80204fae:	0800                	addi	s0,sp,16
    80204fb0:	00000097          	auipc	ra,0x0
    80204fb4:	f9a080e7          	jalr	-102(ra) # 80204f4a <r_sstatus>
    80204fb8:	87aa                	mv	a5,a0
    80204fba:	9bf5                	andi	a5,a5,-3
    80204fbc:	853e                	mv	a0,a5
    80204fbe:	00000097          	auipc	ra,0x0
    80204fc2:	fa6080e7          	jalr	-90(ra) # 80204f64 <w_sstatus>
    80204fc6:	0001                	nop
    80204fc8:	60a2                	ld	ra,8(sp)
    80204fca:	6402                	ld	s0,0(sp)
    80204fcc:	0141                	addi	sp,sp,16
    80204fce:	8082                	ret

0000000080204fd0 <w_stvec>:
    80204fd0:	1101                	addi	sp,sp,-32
    80204fd2:	ec22                	sd	s0,24(sp)
    80204fd4:	1000                	addi	s0,sp,32
    80204fd6:	fea43423          	sd	a0,-24(s0)
    80204fda:	fe843783          	ld	a5,-24(s0)
    80204fde:	10579073          	csrw	stvec,a5
    80204fe2:	0001                	nop
    80204fe4:	6462                	ld	s0,24(sp)
    80204fe6:	6105                	addi	sp,sp,32
    80204fe8:	8082                	ret

0000000080204fea <assert>:
    80204fea:	1101                	addi	sp,sp,-32
    80204fec:	ec06                	sd	ra,24(sp)
    80204fee:	e822                	sd	s0,16(sp)
    80204ff0:	1000                	addi	s0,sp,32
    80204ff2:	87aa                	mv	a5,a0
    80204ff4:	fef42623          	sw	a5,-20(s0)
    80204ff8:	fec42783          	lw	a5,-20(s0)
    80204ffc:	2781                	sext.w	a5,a5
    80204ffe:	e79d                	bnez	a5,8020502c <assert+0x42>
    80205000:	33c00613          	li	a2,828
    80205004:	00020597          	auipc	a1,0x20
    80205008:	5d458593          	addi	a1,a1,1492 # 802255d8 <user_test_table+0x78>
    8020500c:	00020517          	auipc	a0,0x20
    80205010:	5dc50513          	addi	a0,a0,1500 # 802255e8 <user_test_table+0x88>
    80205014:	ffffc097          	auipc	ra,0xffffc
    80205018:	270080e7          	jalr	624(ra) # 80201284 <printf>
    8020501c:	00020517          	auipc	a0,0x20
    80205020:	5f450513          	addi	a0,a0,1524 # 80225610 <user_test_table+0xb0>
    80205024:	ffffc097          	auipc	ra,0xffffc
    80205028:	7e2080e7          	jalr	2018(ra) # 80201806 <panic>
    8020502c:	0001                	nop
    8020502e:	60e2                	ld	ra,24(sp)
    80205030:	6442                	ld	s0,16(sp)
    80205032:	6105                	addi	sp,sp,32
    80205034:	8082                	ret

0000000080205036 <shutdown>:
void shutdown() {
    80205036:	1141                	addi	sp,sp,-16
    80205038:	e406                	sd	ra,8(sp)
    8020503a:	e022                	sd	s0,0(sp)
    8020503c:	0800                	addi	s0,sp,16
	free_proc_table();
    8020503e:	00000097          	auipc	ra,0x0
    80205042:	3c8080e7          	jalr	968(ra) # 80205406 <free_proc_table>
    printf("关机\n");
    80205046:	00020517          	auipc	a0,0x20
    8020504a:	5d250513          	addi	a0,a0,1490 # 80225618 <user_test_table+0xb8>
    8020504e:	ffffc097          	auipc	ra,0xffffc
    80205052:	236080e7          	jalr	566(ra) # 80201284 <printf>
    asm volatile (
    80205056:	48a1                	li	a7,8
    80205058:	00000073          	ecall
    while (1) { }
    8020505c:	0001                	nop
    8020505e:	bffd                	j	8020505c <shutdown+0x26>

0000000080205060 <myproc>:
struct proc* myproc(void) {
    80205060:	1141                	addi	sp,sp,-16
    80205062:	e422                	sd	s0,8(sp)
    80205064:	0800                	addi	s0,sp,16
    return current_proc;
    80205066:	00038797          	auipc	a5,0x38
    8020506a:	06278793          	addi	a5,a5,98 # 8023d0c8 <current_proc>
    8020506e:	639c                	ld	a5,0(a5)
}
    80205070:	853e                	mv	a0,a5
    80205072:	6422                	ld	s0,8(sp)
    80205074:	0141                	addi	sp,sp,16
    80205076:	8082                	ret

0000000080205078 <mycpu>:
struct cpu* mycpu(void) {
    80205078:	1141                	addi	sp,sp,-16
    8020507a:	e406                	sd	ra,8(sp)
    8020507c:	e022                	sd	s0,0(sp)
    8020507e:	0800                	addi	s0,sp,16
    if (current_cpu == 0) {
    80205080:	00038797          	auipc	a5,0x38
    80205084:	05078793          	addi	a5,a5,80 # 8023d0d0 <current_cpu>
    80205088:	639c                	ld	a5,0(a5)
    8020508a:	ebb9                	bnez	a5,802050e0 <mycpu+0x68>
        warning("current_cpu is NULL, initializing...\n");
    8020508c:	00020517          	auipc	a0,0x20
    80205090:	59450513          	addi	a0,a0,1428 # 80225620 <user_test_table+0xc0>
    80205094:	ffffc097          	auipc	ra,0xffffc
    80205098:	7a6080e7          	jalr	1958(ra) # 8020183a <warning>
		memset(&cpu_instance, 0, sizeof(struct cpu));
    8020509c:	07800613          	li	a2,120
    802050a0:	4581                	li	a1,0
    802050a2:	00038517          	auipc	a0,0x38
    802050a6:	5ee50513          	addi	a0,a0,1518 # 8023d690 <cpu_instance.0>
    802050aa:	ffffd097          	auipc	ra,0xffffd
    802050ae:	e9a080e7          	jalr	-358(ra) # 80201f44 <memset>
		current_cpu = &cpu_instance;
    802050b2:	00038797          	auipc	a5,0x38
    802050b6:	01e78793          	addi	a5,a5,30 # 8023d0d0 <current_cpu>
    802050ba:	00038717          	auipc	a4,0x38
    802050be:	5d670713          	addi	a4,a4,1494 # 8023d690 <cpu_instance.0>
    802050c2:	e398                	sd	a4,0(a5)
		printf("CPU initialized: %p\n", current_cpu);
    802050c4:	00038797          	auipc	a5,0x38
    802050c8:	00c78793          	addi	a5,a5,12 # 8023d0d0 <current_cpu>
    802050cc:	639c                	ld	a5,0(a5)
    802050ce:	85be                	mv	a1,a5
    802050d0:	00020517          	auipc	a0,0x20
    802050d4:	57850513          	addi	a0,a0,1400 # 80225648 <user_test_table+0xe8>
    802050d8:	ffffc097          	auipc	ra,0xffffc
    802050dc:	1ac080e7          	jalr	428(ra) # 80201284 <printf>
	assert(current_cpu != 0);
    802050e0:	00038797          	auipc	a5,0x38
    802050e4:	ff078793          	addi	a5,a5,-16 # 8023d0d0 <current_cpu>
    802050e8:	639c                	ld	a5,0(a5)
    802050ea:	00f037b3          	snez	a5,a5
    802050ee:	0ff7f793          	zext.b	a5,a5
    802050f2:	2781                	sext.w	a5,a5
    802050f4:	853e                	mv	a0,a5
    802050f6:	00000097          	auipc	ra,0x0
    802050fa:	ef4080e7          	jalr	-268(ra) # 80204fea <assert>
    return current_cpu;
    802050fe:	00038797          	auipc	a5,0x38
    80205102:	fd278793          	addi	a5,a5,-46 # 8023d0d0 <current_cpu>
    80205106:	639c                	ld	a5,0(a5)
}
    80205108:	853e                	mv	a0,a5
    8020510a:	60a2                	ld	ra,8(sp)
    8020510c:	6402                	ld	s0,0(sp)
    8020510e:	0141                	addi	sp,sp,16
    80205110:	8082                	ret

0000000080205112 <return_to_user>:
void return_to_user(void) {
    80205112:	7179                	addi	sp,sp,-48
    80205114:	f406                	sd	ra,40(sp)
    80205116:	f022                	sd	s0,32(sp)
    80205118:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    8020511a:	00000097          	auipc	ra,0x0
    8020511e:	f46080e7          	jalr	-186(ra) # 80205060 <myproc>
    80205122:	fea43423          	sd	a0,-24(s0)
    if (!p) panic("return_to_user: no current process");
    80205126:	fe843783          	ld	a5,-24(s0)
    8020512a:	eb89                	bnez	a5,8020513c <return_to_user+0x2a>
    8020512c:	00020517          	auipc	a0,0x20
    80205130:	53450513          	addi	a0,a0,1332 # 80225660 <user_test_table+0x100>
    80205134:	ffffc097          	auipc	ra,0xffffc
    80205138:	6d2080e7          	jalr	1746(ra) # 80201806 <panic>
    w_stvec(TRAMPOLINE + (uservec - trampoline));
    8020513c:	00000717          	auipc	a4,0x0
    80205140:	c6470713          	addi	a4,a4,-924 # 80204da0 <trampoline>
    80205144:	00000797          	auipc	a5,0x0
    80205148:	c5c78793          	addi	a5,a5,-932 # 80204da0 <trampoline>
    8020514c:	40f707b3          	sub	a5,a4,a5
    80205150:	873e                	mv	a4,a5
    80205152:	77fd                	lui	a5,0xfffff
    80205154:	97ba                	add	a5,a5,a4
    80205156:	853e                	mv	a0,a5
    80205158:	00000097          	auipc	ra,0x0
    8020515c:	e78080e7          	jalr	-392(ra) # 80204fd0 <w_stvec>
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80205160:	00000717          	auipc	a4,0x0
    80205164:	ce670713          	addi	a4,a4,-794 # 80204e46 <userret>
    80205168:	00000797          	auipc	a5,0x0
    8020516c:	c3878793          	addi	a5,a5,-968 # 80204da0 <trampoline>
    80205170:	40f707b3          	sub	a5,a4,a5
    80205174:	873e                	mv	a4,a5
    80205176:	77fd                	lui	a5,0xfffff
    80205178:	97ba                	add	a5,a5,a4
    8020517a:	fef43023          	sd	a5,-32(s0)
    uint64 satp = MAKE_SATP(p->pagetable);
    8020517e:	fe843783          	ld	a5,-24(s0)
    80205182:	7fdc                	ld	a5,184(a5)
    80205184:	00c7d713          	srli	a4,a5,0xc
    80205188:	57fd                	li	a5,-1
    8020518a:	17fe                	slli	a5,a5,0x3f
    8020518c:	8fd9                	or	a5,a5,a4
    8020518e:	fcf43c23          	sd	a5,-40(s0)
    if ((trampoline_userret & ~(PGSIZE - 1)) != TRAMPOLINE) {
    80205192:	fe043703          	ld	a4,-32(s0)
    80205196:	77fd                	lui	a5,0xfffff
    80205198:	8f7d                	and	a4,a4,a5
    8020519a:	77fd                	lui	a5,0xfffff
    8020519c:	00f70a63          	beq	a4,a5,802051b0 <return_to_user+0x9e>
        panic("return_to_user: userret outside trampoline page");
    802051a0:	00020517          	auipc	a0,0x20
    802051a4:	4e850513          	addi	a0,a0,1256 # 80225688 <user_test_table+0x128>
    802051a8:	ffffc097          	auipc	ra,0xffffc
    802051ac:	65e080e7          	jalr	1630(ra) # 80201806 <panic>
    void (*userret_fn)(uint64, uint64) = (void (*)(uint64, uint64))trampoline_userret;
    802051b0:	fe043783          	ld	a5,-32(s0)
    802051b4:	fcf43823          	sd	a5,-48(s0)
    userret_fn(TRAPFRAME, satp);
    802051b8:	fd043783          	ld	a5,-48(s0)
    802051bc:	fd843583          	ld	a1,-40(s0)
    802051c0:	7579                	lui	a0,0xffffe
    802051c2:	9782                	jalr	a5
    panic("return_to_user: should not return");
    802051c4:	00020517          	auipc	a0,0x20
    802051c8:	4f450513          	addi	a0,a0,1268 # 802256b8 <user_test_table+0x158>
    802051cc:	ffffc097          	auipc	ra,0xffffc
    802051d0:	63a080e7          	jalr	1594(ra) # 80201806 <panic>
}
    802051d4:	0001                	nop
    802051d6:	70a2                	ld	ra,40(sp)
    802051d8:	7402                	ld	s0,32(sp)
    802051da:	6145                	addi	sp,sp,48
    802051dc:	8082                	ret

00000000802051de <forkret>:
void forkret(void) {
    802051de:	1101                	addi	sp,sp,-32
    802051e0:	ec06                	sd	ra,24(sp)
    802051e2:	e822                	sd	s0,16(sp)
    802051e4:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    802051e6:	00000097          	auipc	ra,0x0
    802051ea:	e7a080e7          	jalr	-390(ra) # 80205060 <myproc>
    802051ee:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    802051f2:	fe843783          	ld	a5,-24(s0)
    802051f6:	eb89                	bnez	a5,80205208 <forkret+0x2a>
        panic("forkret: no current process");
    802051f8:	00020517          	auipc	a0,0x20
    802051fc:	4e850513          	addi	a0,a0,1256 # 802256e0 <user_test_table+0x180>
    80205200:	ffffc097          	auipc	ra,0xffffc
    80205204:	606080e7          	jalr	1542(ra) # 80201806 <panic>
    if (p->killed) {
    80205208:	fe843783          	ld	a5,-24(s0)
    8020520c:	0807a783          	lw	a5,128(a5) # fffffffffffff080 <_bss_end+0xffffffff7fdb6750>
    80205210:	c785                	beqz	a5,80205238 <forkret+0x5a>
        printf("[forkret] Process PID %d killed before execution\n", p->pid);
    80205212:	fe843783          	ld	a5,-24(s0)
    80205216:	43dc                	lw	a5,4(a5)
    80205218:	85be                	mv	a1,a5
    8020521a:	00020517          	auipc	a0,0x20
    8020521e:	4e650513          	addi	a0,a0,1254 # 80225700 <user_test_table+0x1a0>
    80205222:	ffffc097          	auipc	ra,0xffffc
    80205226:	062080e7          	jalr	98(ra) # 80201284 <printf>
        exit_proc(SYS_kill);
    8020522a:	08100513          	li	a0,129
    8020522e:	00001097          	auipc	ra,0x1
    80205232:	cee080e7          	jalr	-786(ra) # 80205f1c <exit_proc>
        return; // 虽然不会执行到这里，但为了代码清晰
    80205236:	a099                	j	8020527c <forkret+0x9e>
    if (p->is_user) {
    80205238:	fe843783          	ld	a5,-24(s0)
    8020523c:	0a87a783          	lw	a5,168(a5)
    80205240:	c791                	beqz	a5,8020524c <forkret+0x6e>
        return_to_user();
    80205242:	00000097          	auipc	ra,0x0
    80205246:	ed0080e7          	jalr	-304(ra) # 80205112 <return_to_user>
    8020524a:	a80d                	j	8020527c <forkret+0x9e>
		if (p->trapframe->epc) {
    8020524c:	fe843783          	ld	a5,-24(s0)
    80205250:	63fc                	ld	a5,192(a5)
    80205252:	7f9c                	ld	a5,56(a5)
    80205254:	cf99                	beqz	a5,80205272 <forkret+0x94>
			void (*fn)(uint64) = (void(*)(uint64))p->trapframe->epc;
    80205256:	fe843783          	ld	a5,-24(s0)
    8020525a:	63fc                	ld	a5,192(a5)
    8020525c:	7f9c                	ld	a5,56(a5)
    8020525e:	fef43023          	sd	a5,-32(s0)
			fn(p->trapframe->a0);
    80205262:	fe843783          	ld	a5,-24(s0)
    80205266:	63fc                	ld	a5,192(a5)
    80205268:	77d8                	ld	a4,168(a5)
    8020526a:	fe043783          	ld	a5,-32(s0)
    8020526e:	853a                	mv	a0,a4
    80205270:	9782                	jalr	a5
        exit_proc(0);  // 内核线程函数返回则退出
    80205272:	4501                	li	a0,0
    80205274:	00001097          	auipc	ra,0x1
    80205278:	ca8080e7          	jalr	-856(ra) # 80205f1c <exit_proc>
}
    8020527c:	60e2                	ld	ra,24(sp)
    8020527e:	6442                	ld	s0,16(sp)
    80205280:	6105                	addi	sp,sp,32
    80205282:	8082                	ret

0000000080205284 <init_proc>:
void init_proc(void){
    80205284:	1101                	addi	sp,sp,-32
    80205286:	ec06                	sd	ra,24(sp)
    80205288:	e822                	sd	s0,16(sp)
    8020528a:	1000                	addi	s0,sp,32
    for (int i = 0; i < PROC; i++) {
    8020528c:	fe042623          	sw	zero,-20(s0)
    80205290:	aa81                	j	802053e0 <init_proc+0x15c>
        void *page = alloc_page();
    80205292:	ffffe097          	auipc	ra,0xffffe
    80205296:	0ca080e7          	jalr	202(ra) # 8020335c <alloc_page>
    8020529a:	fea43023          	sd	a0,-32(s0)
        if (!page) panic("init_proc: alloc_page failed for proc_table");
    8020529e:	fe043783          	ld	a5,-32(s0)
    802052a2:	eb89                	bnez	a5,802052b4 <init_proc+0x30>
    802052a4:	00020517          	auipc	a0,0x20
    802052a8:	49450513          	addi	a0,a0,1172 # 80225738 <user_test_table+0x1d8>
    802052ac:	ffffc097          	auipc	ra,0xffffc
    802052b0:	55a080e7          	jalr	1370(ra) # 80201806 <panic>
        proc_table_mem[i] = page;
    802052b4:	00038717          	auipc	a4,0x38
    802052b8:	2dc70713          	addi	a4,a4,732 # 8023d590 <proc_table_mem>
    802052bc:	fec42783          	lw	a5,-20(s0)
    802052c0:	078e                	slli	a5,a5,0x3
    802052c2:	97ba                	add	a5,a5,a4
    802052c4:	fe043703          	ld	a4,-32(s0)
    802052c8:	e398                	sd	a4,0(a5)
        proc_table[i] = (struct proc *)page;
    802052ca:	00038717          	auipc	a4,0x38
    802052ce:	1be70713          	addi	a4,a4,446 # 8023d488 <proc_table>
    802052d2:	fec42783          	lw	a5,-20(s0)
    802052d6:	078e                	slli	a5,a5,0x3
    802052d8:	97ba                	add	a5,a5,a4
    802052da:	fe043703          	ld	a4,-32(s0)
    802052de:	e398                	sd	a4,0(a5)
        memset(proc_table[i], 0, sizeof(struct proc));
    802052e0:	00038717          	auipc	a4,0x38
    802052e4:	1a870713          	addi	a4,a4,424 # 8023d488 <proc_table>
    802052e8:	fec42783          	lw	a5,-20(s0)
    802052ec:	078e                	slli	a5,a5,0x3
    802052ee:	97ba                	add	a5,a5,a4
    802052f0:	639c                	ld	a5,0(a5)
    802052f2:	0d000613          	li	a2,208
    802052f6:	4581                	li	a1,0
    802052f8:	853e                	mv	a0,a5
    802052fa:	ffffd097          	auipc	ra,0xffffd
    802052fe:	c4a080e7          	jalr	-950(ra) # 80201f44 <memset>
        proc_table[i]->state = UNUSED;
    80205302:	00038717          	auipc	a4,0x38
    80205306:	18670713          	addi	a4,a4,390 # 8023d488 <proc_table>
    8020530a:	fec42783          	lw	a5,-20(s0)
    8020530e:	078e                	slli	a5,a5,0x3
    80205310:	97ba                	add	a5,a5,a4
    80205312:	639c                	ld	a5,0(a5)
    80205314:	0007a023          	sw	zero,0(a5)
        proc_table[i]->pid = 0;
    80205318:	00038717          	auipc	a4,0x38
    8020531c:	17070713          	addi	a4,a4,368 # 8023d488 <proc_table>
    80205320:	fec42783          	lw	a5,-20(s0)
    80205324:	078e                	slli	a5,a5,0x3
    80205326:	97ba                	add	a5,a5,a4
    80205328:	639c                	ld	a5,0(a5)
    8020532a:	0007a223          	sw	zero,4(a5)
        proc_table[i]->kstack = 0;
    8020532e:	00038717          	auipc	a4,0x38
    80205332:	15a70713          	addi	a4,a4,346 # 8023d488 <proc_table>
    80205336:	fec42783          	lw	a5,-20(s0)
    8020533a:	078e                	slli	a5,a5,0x3
    8020533c:	97ba                	add	a5,a5,a4
    8020533e:	639c                	ld	a5,0(a5)
    80205340:	0007b423          	sd	zero,8(a5)
        proc_table[i]->pagetable = 0;
    80205344:	00038717          	auipc	a4,0x38
    80205348:	14470713          	addi	a4,a4,324 # 8023d488 <proc_table>
    8020534c:	fec42783          	lw	a5,-20(s0)
    80205350:	078e                	slli	a5,a5,0x3
    80205352:	97ba                	add	a5,a5,a4
    80205354:	639c                	ld	a5,0(a5)
    80205356:	0a07bc23          	sd	zero,184(a5)
        proc_table[i]->trapframe = 0;
    8020535a:	00038717          	auipc	a4,0x38
    8020535e:	12e70713          	addi	a4,a4,302 # 8023d488 <proc_table>
    80205362:	fec42783          	lw	a5,-20(s0)
    80205366:	078e                	slli	a5,a5,0x3
    80205368:	97ba                	add	a5,a5,a4
    8020536a:	639c                	ld	a5,0(a5)
    8020536c:	0c07b023          	sd	zero,192(a5)
        proc_table[i]->parent = 0;
    80205370:	00038717          	auipc	a4,0x38
    80205374:	11870713          	addi	a4,a4,280 # 8023d488 <proc_table>
    80205378:	fec42783          	lw	a5,-20(s0)
    8020537c:	078e                	slli	a5,a5,0x3
    8020537e:	97ba                	add	a5,a5,a4
    80205380:	639c                	ld	a5,0(a5)
    80205382:	0807bc23          	sd	zero,152(a5)
        proc_table[i]->chan = 0;
    80205386:	00038717          	auipc	a4,0x38
    8020538a:	10270713          	addi	a4,a4,258 # 8023d488 <proc_table>
    8020538e:	fec42783          	lw	a5,-20(s0)
    80205392:	078e                	slli	a5,a5,0x3
    80205394:	97ba                	add	a5,a5,a4
    80205396:	639c                	ld	a5,0(a5)
    80205398:	0a07b023          	sd	zero,160(a5)
        proc_table[i]->exit_status = 0;
    8020539c:	00038717          	auipc	a4,0x38
    802053a0:	0ec70713          	addi	a4,a4,236 # 8023d488 <proc_table>
    802053a4:	fec42783          	lw	a5,-20(s0)
    802053a8:	078e                	slli	a5,a5,0x3
    802053aa:	97ba                	add	a5,a5,a4
    802053ac:	639c                	ld	a5,0(a5)
    802053ae:	0807a223          	sw	zero,132(a5)
        memset(&proc_table[i]->context, 0, sizeof(struct context));
    802053b2:	00038717          	auipc	a4,0x38
    802053b6:	0d670713          	addi	a4,a4,214 # 8023d488 <proc_table>
    802053ba:	fec42783          	lw	a5,-20(s0)
    802053be:	078e                	slli	a5,a5,0x3
    802053c0:	97ba                	add	a5,a5,a4
    802053c2:	639c                	ld	a5,0(a5)
    802053c4:	07c1                	addi	a5,a5,16
    802053c6:	07000613          	li	a2,112
    802053ca:	4581                	li	a1,0
    802053cc:	853e                	mv	a0,a5
    802053ce:	ffffd097          	auipc	ra,0xffffd
    802053d2:	b76080e7          	jalr	-1162(ra) # 80201f44 <memset>
    for (int i = 0; i < PROC; i++) {
    802053d6:	fec42783          	lw	a5,-20(s0)
    802053da:	2785                	addiw	a5,a5,1
    802053dc:	fef42623          	sw	a5,-20(s0)
    802053e0:	fec42783          	lw	a5,-20(s0)
    802053e4:	0007871b          	sext.w	a4,a5
    802053e8:	47fd                	li	a5,31
    802053ea:	eae7d4e3          	bge	a5,a4,80205292 <init_proc+0xe>
    proc_table_pages = PROC; // 每个进程一页
    802053ee:	00038797          	auipc	a5,0x38
    802053f2:	19a78793          	addi	a5,a5,410 # 8023d588 <proc_table_pages>
    802053f6:	02000713          	li	a4,32
    802053fa:	c398                	sw	a4,0(a5)
}
    802053fc:	0001                	nop
    802053fe:	60e2                	ld	ra,24(sp)
    80205400:	6442                	ld	s0,16(sp)
    80205402:	6105                	addi	sp,sp,32
    80205404:	8082                	ret

0000000080205406 <free_proc_table>:
void free_proc_table(void) {
    80205406:	1101                	addi	sp,sp,-32
    80205408:	ec06                	sd	ra,24(sp)
    8020540a:	e822                	sd	s0,16(sp)
    8020540c:	1000                	addi	s0,sp,32
    for (int i = 0; i < proc_table_pages; i++) {
    8020540e:	fe042623          	sw	zero,-20(s0)
    80205412:	a025                	j	8020543a <free_proc_table+0x34>
        free_page(proc_table_mem[i]);
    80205414:	00038717          	auipc	a4,0x38
    80205418:	17c70713          	addi	a4,a4,380 # 8023d590 <proc_table_mem>
    8020541c:	fec42783          	lw	a5,-20(s0)
    80205420:	078e                	slli	a5,a5,0x3
    80205422:	97ba                	add	a5,a5,a4
    80205424:	639c                	ld	a5,0(a5)
    80205426:	853e                	mv	a0,a5
    80205428:	ffffe097          	auipc	ra,0xffffe
    8020542c:	fa0080e7          	jalr	-96(ra) # 802033c8 <free_page>
    for (int i = 0; i < proc_table_pages; i++) {
    80205430:	fec42783          	lw	a5,-20(s0)
    80205434:	2785                	addiw	a5,a5,1
    80205436:	fef42623          	sw	a5,-20(s0)
    8020543a:	00038797          	auipc	a5,0x38
    8020543e:	14e78793          	addi	a5,a5,334 # 8023d588 <proc_table_pages>
    80205442:	4398                	lw	a4,0(a5)
    80205444:	fec42783          	lw	a5,-20(s0)
    80205448:	2781                	sext.w	a5,a5
    8020544a:	fce7c5e3          	blt	a5,a4,80205414 <free_proc_table+0xe>
}
    8020544e:	0001                	nop
    80205450:	0001                	nop
    80205452:	60e2                	ld	ra,24(sp)
    80205454:	6442                	ld	s0,16(sp)
    80205456:	6105                	addi	sp,sp,32
    80205458:	8082                	ret

000000008020545a <alloc_proc>:
struct proc* alloc_proc(int is_user) {
    8020545a:	7139                	addi	sp,sp,-64
    8020545c:	fc06                	sd	ra,56(sp)
    8020545e:	f822                	sd	s0,48(sp)
    80205460:	0080                	addi	s0,sp,64
    80205462:	87aa                	mv	a5,a0
    80205464:	fcf42623          	sw	a5,-52(s0)
    for(int i = 0;i<PROC;i++) {
    80205468:	fe042623          	sw	zero,-20(s0)
    8020546c:	a241                	j	802055ec <alloc_proc+0x192>
		struct proc *p = proc_table[i];
    8020546e:	00038717          	auipc	a4,0x38
    80205472:	01a70713          	addi	a4,a4,26 # 8023d488 <proc_table>
    80205476:	fec42783          	lw	a5,-20(s0)
    8020547a:	078e                	slli	a5,a5,0x3
    8020547c:	97ba                	add	a5,a5,a4
    8020547e:	639c                	ld	a5,0(a5)
    80205480:	fef43023          	sd	a5,-32(s0)
        if(p->state == UNUSED) {
    80205484:	fe043783          	ld	a5,-32(s0)
    80205488:	439c                	lw	a5,0(a5)
    8020548a:	14079c63          	bnez	a5,802055e2 <alloc_proc+0x188>
            p->pid = i;
    8020548e:	fe043783          	ld	a5,-32(s0)
    80205492:	fec42703          	lw	a4,-20(s0)
    80205496:	c3d8                	sw	a4,4(a5)
			p->cwd = 0;
    80205498:	fe043783          	ld	a5,-32(s0)
    8020549c:	0c07b423          	sd	zero,200(a5)
            p->state = USED;
    802054a0:	fe043783          	ld	a5,-32(s0)
    802054a4:	4705                	li	a4,1
    802054a6:	c398                	sw	a4,0(a5)
			p->is_user = is_user;
    802054a8:	fe043783          	ld	a5,-32(s0)
    802054ac:	fcc42703          	lw	a4,-52(s0)
    802054b0:	0ae7a423          	sw	a4,168(a5)
            p->trapframe = (struct trapframe*)alloc_page();
    802054b4:	ffffe097          	auipc	ra,0xffffe
    802054b8:	ea8080e7          	jalr	-344(ra) # 8020335c <alloc_page>
    802054bc:	872a                	mv	a4,a0
    802054be:	fe043783          	ld	a5,-32(s0)
    802054c2:	e3f8                	sd	a4,192(a5)
            if(p->trapframe == 0){
    802054c4:	fe043783          	ld	a5,-32(s0)
    802054c8:	63fc                	ld	a5,192(a5)
    802054ca:	eb99                	bnez	a5,802054e0 <alloc_proc+0x86>
                p->state = UNUSED;
    802054cc:	fe043783          	ld	a5,-32(s0)
    802054d0:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    802054d4:	fe043783          	ld	a5,-32(s0)
    802054d8:	0007a223          	sw	zero,4(a5)
                return 0;
    802054dc:	4781                	li	a5,0
    802054de:	aa39                	j	802055fc <alloc_proc+0x1a2>
			if(p->is_user){
    802054e0:	fe043783          	ld	a5,-32(s0)
    802054e4:	0a87a783          	lw	a5,168(a5)
    802054e8:	c3b9                	beqz	a5,8020552e <alloc_proc+0xd4>
				p->pagetable = create_pagetable();
    802054ea:	ffffd097          	auipc	ra,0xffffd
    802054ee:	cb6080e7          	jalr	-842(ra) # 802021a0 <create_pagetable>
    802054f2:	872a                	mv	a4,a0
    802054f4:	fe043783          	ld	a5,-32(s0)
    802054f8:	ffd8                	sd	a4,184(a5)
				if(p->pagetable == 0){
    802054fa:	fe043783          	ld	a5,-32(s0)
    802054fe:	7fdc                	ld	a5,184(a5)
    80205500:	ef9d                	bnez	a5,8020553e <alloc_proc+0xe4>
					free_page(p->trapframe);
    80205502:	fe043783          	ld	a5,-32(s0)
    80205506:	63fc                	ld	a5,192(a5)
    80205508:	853e                	mv	a0,a5
    8020550a:	ffffe097          	auipc	ra,0xffffe
    8020550e:	ebe080e7          	jalr	-322(ra) # 802033c8 <free_page>
					p->trapframe = 0;
    80205512:	fe043783          	ld	a5,-32(s0)
    80205516:	0c07b023          	sd	zero,192(a5)
					p->state = UNUSED;
    8020551a:	fe043783          	ld	a5,-32(s0)
    8020551e:	0007a023          	sw	zero,0(a5)
					p->pid = 0;
    80205522:	fe043783          	ld	a5,-32(s0)
    80205526:	0007a223          	sw	zero,4(a5)
					return 0;
    8020552a:	4781                	li	a5,0
    8020552c:	a8c1                	j	802055fc <alloc_proc+0x1a2>
				p->pagetable = kernel_pagetable;
    8020552e:	00038797          	auipc	a5,0x38
    80205532:	b8278793          	addi	a5,a5,-1150 # 8023d0b0 <kernel_pagetable>
    80205536:	6398                	ld	a4,0(a5)
    80205538:	fe043783          	ld	a5,-32(s0)
    8020553c:	ffd8                	sd	a4,184(a5)
            void *kstack_mem = alloc_page();
    8020553e:	ffffe097          	auipc	ra,0xffffe
    80205542:	e1e080e7          	jalr	-482(ra) # 8020335c <alloc_page>
    80205546:	fca43c23          	sd	a0,-40(s0)
            if(kstack_mem == 0) {
    8020554a:	fd843783          	ld	a5,-40(s0)
    8020554e:	e3b9                	bnez	a5,80205594 <alloc_proc+0x13a>
                free_page(p->trapframe);
    80205550:	fe043783          	ld	a5,-32(s0)
    80205554:	63fc                	ld	a5,192(a5)
    80205556:	853e                	mv	a0,a5
    80205558:	ffffe097          	auipc	ra,0xffffe
    8020555c:	e70080e7          	jalr	-400(ra) # 802033c8 <free_page>
                free_pagetable(p->pagetable);
    80205560:	fe043783          	ld	a5,-32(s0)
    80205564:	7fdc                	ld	a5,184(a5)
    80205566:	853e                	mv	a0,a5
    80205568:	ffffd097          	auipc	ra,0xffffd
    8020556c:	01c080e7          	jalr	28(ra) # 80202584 <free_pagetable>
                p->trapframe = 0;
    80205570:	fe043783          	ld	a5,-32(s0)
    80205574:	0c07b023          	sd	zero,192(a5)
                p->pagetable = 0;
    80205578:	fe043783          	ld	a5,-32(s0)
    8020557c:	0a07bc23          	sd	zero,184(a5)
                p->state = UNUSED;
    80205580:	fe043783          	ld	a5,-32(s0)
    80205584:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    80205588:	fe043783          	ld	a5,-32(s0)
    8020558c:	0007a223          	sw	zero,4(a5)
                return 0;
    80205590:	4781                	li	a5,0
    80205592:	a0ad                	j	802055fc <alloc_proc+0x1a2>
            p->kstack = (uint64)kstack_mem;
    80205594:	fd843703          	ld	a4,-40(s0)
    80205598:	fe043783          	ld	a5,-32(s0)
    8020559c:	e798                	sd	a4,8(a5)
            memset(&p->context, 0, sizeof(p->context));
    8020559e:	fe043783          	ld	a5,-32(s0)
    802055a2:	07c1                	addi	a5,a5,16
    802055a4:	07000613          	li	a2,112
    802055a8:	4581                	li	a1,0
    802055aa:	853e                	mv	a0,a5
    802055ac:	ffffd097          	auipc	ra,0xffffd
    802055b0:	998080e7          	jalr	-1640(ra) # 80201f44 <memset>
            p->context.ra = (uint64)forkret;
    802055b4:	00000717          	auipc	a4,0x0
    802055b8:	c2a70713          	addi	a4,a4,-982 # 802051de <forkret>
    802055bc:	fe043783          	ld	a5,-32(s0)
    802055c0:	eb98                	sd	a4,16(a5)
            p->context.sp = p->kstack + PGSIZE - 16;  // 16字节对齐
    802055c2:	fe043783          	ld	a5,-32(s0)
    802055c6:	6798                	ld	a4,8(a5)
    802055c8:	6785                	lui	a5,0x1
    802055ca:	17c1                	addi	a5,a5,-16 # ff0 <_entry-0x801ff010>
    802055cc:	973e                	add	a4,a4,a5
    802055ce:	fe043783          	ld	a5,-32(s0)
    802055d2:	ef98                	sd	a4,24(a5)
			p->killed = 0; //重置死亡状态
    802055d4:	fe043783          	ld	a5,-32(s0)
    802055d8:	0807a023          	sw	zero,128(a5)
            return p;
    802055dc:	fe043783          	ld	a5,-32(s0)
    802055e0:	a831                	j	802055fc <alloc_proc+0x1a2>
    for(int i = 0;i<PROC;i++) {
    802055e2:	fec42783          	lw	a5,-20(s0)
    802055e6:	2785                	addiw	a5,a5,1
    802055e8:	fef42623          	sw	a5,-20(s0)
    802055ec:	fec42783          	lw	a5,-20(s0)
    802055f0:	0007871b          	sext.w	a4,a5
    802055f4:	47fd                	li	a5,31
    802055f6:	e6e7dce3          	bge	a5,a4,8020546e <alloc_proc+0x14>
    return 0;
    802055fa:	4781                	li	a5,0
}
    802055fc:	853e                	mv	a0,a5
    802055fe:	70e2                	ld	ra,56(sp)
    80205600:	7442                	ld	s0,48(sp)
    80205602:	6121                	addi	sp,sp,64
    80205604:	8082                	ret

0000000080205606 <free_proc>:
void free_proc(struct proc *p){
    80205606:	1101                	addi	sp,sp,-32
    80205608:	ec06                	sd	ra,24(sp)
    8020560a:	e822                	sd	s0,16(sp)
    8020560c:	1000                	addi	s0,sp,32
    8020560e:	fea43423          	sd	a0,-24(s0)
    if(p->trapframe)
    80205612:	fe843783          	ld	a5,-24(s0)
    80205616:	63fc                	ld	a5,192(a5)
    80205618:	cb89                	beqz	a5,8020562a <free_proc+0x24>
        free_page(p->trapframe);
    8020561a:	fe843783          	ld	a5,-24(s0)
    8020561e:	63fc                	ld	a5,192(a5)
    80205620:	853e                	mv	a0,a5
    80205622:	ffffe097          	auipc	ra,0xffffe
    80205626:	da6080e7          	jalr	-602(ra) # 802033c8 <free_page>
    p->trapframe = 0;
    8020562a:	fe843783          	ld	a5,-24(s0)
    8020562e:	0c07b023          	sd	zero,192(a5)
    if(p->pagetable && p->pagetable != kernel_pagetable)
    80205632:	fe843783          	ld	a5,-24(s0)
    80205636:	7fdc                	ld	a5,184(a5)
    80205638:	c39d                	beqz	a5,8020565e <free_proc+0x58>
    8020563a:	fe843783          	ld	a5,-24(s0)
    8020563e:	7fd8                	ld	a4,184(a5)
    80205640:	00038797          	auipc	a5,0x38
    80205644:	a7078793          	addi	a5,a5,-1424 # 8023d0b0 <kernel_pagetable>
    80205648:	639c                	ld	a5,0(a5)
    8020564a:	00f70a63          	beq	a4,a5,8020565e <free_proc+0x58>
        free_pagetable(p->pagetable);
    8020564e:	fe843783          	ld	a5,-24(s0)
    80205652:	7fdc                	ld	a5,184(a5)
    80205654:	853e                	mv	a0,a5
    80205656:	ffffd097          	auipc	ra,0xffffd
    8020565a:	f2e080e7          	jalr	-210(ra) # 80202584 <free_pagetable>
    p->pagetable = 0;
    8020565e:	fe843783          	ld	a5,-24(s0)
    80205662:	0a07bc23          	sd	zero,184(a5)
    if(p->kstack)
    80205666:	fe843783          	ld	a5,-24(s0)
    8020566a:	679c                	ld	a5,8(a5)
    8020566c:	cb89                	beqz	a5,8020567e <free_proc+0x78>
        free_page((void*)p->kstack);
    8020566e:	fe843783          	ld	a5,-24(s0)
    80205672:	679c                	ld	a5,8(a5)
    80205674:	853e                	mv	a0,a5
    80205676:	ffffe097          	auipc	ra,0xffffe
    8020567a:	d52080e7          	jalr	-686(ra) # 802033c8 <free_page>
    p->kstack = 0;
    8020567e:	fe843783          	ld	a5,-24(s0)
    80205682:	0007b423          	sd	zero,8(a5)
    p->pid = 0;
    80205686:	fe843783          	ld	a5,-24(s0)
    8020568a:	0007a223          	sw	zero,4(a5)
    p->state = UNUSED;
    8020568e:	fe843783          	ld	a5,-24(s0)
    80205692:	0007a023          	sw	zero,0(a5)
    p->parent = 0;
    80205696:	fe843783          	ld	a5,-24(s0)
    8020569a:	0807bc23          	sd	zero,152(a5)
    p->chan = 0;
    8020569e:	fe843783          	ld	a5,-24(s0)
    802056a2:	0a07b023          	sd	zero,160(a5)
    memset(&p->context, 0, sizeof(p->context));
    802056a6:	fe843783          	ld	a5,-24(s0)
    802056aa:	07c1                	addi	a5,a5,16
    802056ac:	07000613          	li	a2,112
    802056b0:	4581                	li	a1,0
    802056b2:	853e                	mv	a0,a5
    802056b4:	ffffd097          	auipc	ra,0xffffd
    802056b8:	890080e7          	jalr	-1904(ra) # 80201f44 <memset>
}
    802056bc:	0001                	nop
    802056be:	60e2                	ld	ra,24(sp)
    802056c0:	6442                	ld	s0,16(sp)
    802056c2:	6105                	addi	sp,sp,32
    802056c4:	8082                	ret

00000000802056c6 <create_kernel_proc>:
int create_kernel_proc(void (*entry)(void)) {
    802056c6:	7179                	addi	sp,sp,-48
    802056c8:	f406                	sd	ra,40(sp)
    802056ca:	f022                	sd	s0,32(sp)
    802056cc:	1800                	addi	s0,sp,48
    802056ce:	fca43c23          	sd	a0,-40(s0)
    struct proc *p = alloc_proc(0);
    802056d2:	4501                	li	a0,0
    802056d4:	00000097          	auipc	ra,0x0
    802056d8:	d86080e7          	jalr	-634(ra) # 8020545a <alloc_proc>
    802056dc:	fea43423          	sd	a0,-24(s0)
    if (!p) return -1;
    802056e0:	fe843783          	ld	a5,-24(s0)
    802056e4:	e399                	bnez	a5,802056ea <create_kernel_proc+0x24>
    802056e6:	57fd                	li	a5,-1
    802056e8:	a88d                	j	8020575a <create_kernel_proc+0x94>
    p->trapframe->epc = (uint64)entry;
    802056ea:	fe843783          	ld	a5,-24(s0)
    802056ee:	63fc                	ld	a5,192(a5)
    802056f0:	fd843703          	ld	a4,-40(s0)
    802056f4:	ff98                	sd	a4,56(a5)
    p->state = RUNNABLE;
    802056f6:	fe843783          	ld	a5,-24(s0)
    802056fa:	470d                	li	a4,3
    802056fc:	c398                	sw	a4,0(a5)
    struct proc *parent = myproc();
    802056fe:	00000097          	auipc	ra,0x0
    80205702:	962080e7          	jalr	-1694(ra) # 80205060 <myproc>
    80205706:	fea43023          	sd	a0,-32(s0)
    if (parent != 0) {
    8020570a:	fe043783          	ld	a5,-32(s0)
    8020570e:	c799                	beqz	a5,8020571c <create_kernel_proc+0x56>
        p->parent = parent;
    80205710:	fe843783          	ld	a5,-24(s0)
    80205714:	fe043703          	ld	a4,-32(s0)
    80205718:	efd8                	sd	a4,152(a5)
    8020571a:	a029                	j	80205724 <create_kernel_proc+0x5e>
        p->parent = NULL;
    8020571c:	fe843783          	ld	a5,-24(s0)
    80205720:	0807bc23          	sd	zero,152(a5)
	if (parent && parent->cwd)
    80205724:	fe043783          	ld	a5,-32(s0)
    80205728:	c395                	beqz	a5,8020574c <create_kernel_proc+0x86>
    8020572a:	fe043783          	ld	a5,-32(s0)
    8020572e:	67fc                	ld	a5,200(a5)
    80205730:	cf91                	beqz	a5,8020574c <create_kernel_proc+0x86>
		p->cwd = idup(parent->cwd);
    80205732:	fe043783          	ld	a5,-32(s0)
    80205736:	67fc                	ld	a5,200(a5)
    80205738:	853e                	mv	a0,a5
    8020573a:	00005097          	auipc	ra,0x5
    8020573e:	670080e7          	jalr	1648(ra) # 8020adaa <idup>
    80205742:	872a                	mv	a4,a0
    80205744:	fe843783          	ld	a5,-24(s0)
    80205748:	e7f8                	sd	a4,200(a5)
    8020574a:	a029                	j	80205754 <create_kernel_proc+0x8e>
		p->cwd = 0; // 或者在 main/init 进程里手动设置
    8020574c:	fe843783          	ld	a5,-24(s0)
    80205750:	0c07b423          	sd	zero,200(a5)
    return p->pid;
    80205754:	fe843783          	ld	a5,-24(s0)
    80205758:	43dc                	lw	a5,4(a5)
}
    8020575a:	853e                	mv	a0,a5
    8020575c:	70a2                	ld	ra,40(sp)
    8020575e:	7402                	ld	s0,32(sp)
    80205760:	6145                	addi	sp,sp,48
    80205762:	8082                	ret

0000000080205764 <create_kernel_proc1>:
int create_kernel_proc1(void (*entry)(uint64),uint64 arg){
    80205764:	7179                	addi	sp,sp,-48
    80205766:	f406                	sd	ra,40(sp)
    80205768:	f022                	sd	s0,32(sp)
    8020576a:	1800                	addi	s0,sp,48
    8020576c:	fca43c23          	sd	a0,-40(s0)
    80205770:	fcb43823          	sd	a1,-48(s0)
	struct proc *p = alloc_proc(0);
    80205774:	4501                	li	a0,0
    80205776:	00000097          	auipc	ra,0x0
    8020577a:	ce4080e7          	jalr	-796(ra) # 8020545a <alloc_proc>
    8020577e:	fea43423          	sd	a0,-24(s0)
    if (!p) return -1;
    80205782:	fe843783          	ld	a5,-24(s0)
    80205786:	e399                	bnez	a5,8020578c <create_kernel_proc1+0x28>
    80205788:	57fd                	li	a5,-1
    8020578a:	a8bd                	j	80205808 <create_kernel_proc1+0xa4>
    p->trapframe->epc = (uint64)entry;
    8020578c:	fe843783          	ld	a5,-24(s0)
    80205790:	63fc                	ld	a5,192(a5)
    80205792:	fd843703          	ld	a4,-40(s0)
    80205796:	ff98                	sd	a4,56(a5)
	p->trapframe->a0 = (uint64)arg;
    80205798:	fe843783          	ld	a5,-24(s0)
    8020579c:	63fc                	ld	a5,192(a5)
    8020579e:	fd043703          	ld	a4,-48(s0)
    802057a2:	f7d8                	sd	a4,168(a5)
    p->state = RUNNABLE;
    802057a4:	fe843783          	ld	a5,-24(s0)
    802057a8:	470d                	li	a4,3
    802057aa:	c398                	sw	a4,0(a5)
    struct proc *parent = myproc();
    802057ac:	00000097          	auipc	ra,0x0
    802057b0:	8b4080e7          	jalr	-1868(ra) # 80205060 <myproc>
    802057b4:	fea43023          	sd	a0,-32(s0)
    if (parent != 0) {
    802057b8:	fe043783          	ld	a5,-32(s0)
    802057bc:	c799                	beqz	a5,802057ca <create_kernel_proc1+0x66>
        p->parent = parent;
    802057be:	fe843783          	ld	a5,-24(s0)
    802057c2:	fe043703          	ld	a4,-32(s0)
    802057c6:	efd8                	sd	a4,152(a5)
    802057c8:	a029                	j	802057d2 <create_kernel_proc1+0x6e>
        p->parent = NULL;
    802057ca:	fe843783          	ld	a5,-24(s0)
    802057ce:	0807bc23          	sd	zero,152(a5)
	if (parent && parent->cwd)
    802057d2:	fe043783          	ld	a5,-32(s0)
    802057d6:	c395                	beqz	a5,802057fa <create_kernel_proc1+0x96>
    802057d8:	fe043783          	ld	a5,-32(s0)
    802057dc:	67fc                	ld	a5,200(a5)
    802057de:	cf91                	beqz	a5,802057fa <create_kernel_proc1+0x96>
		p->cwd = idup(parent->cwd);
    802057e0:	fe043783          	ld	a5,-32(s0)
    802057e4:	67fc                	ld	a5,200(a5)
    802057e6:	853e                	mv	a0,a5
    802057e8:	00005097          	auipc	ra,0x5
    802057ec:	5c2080e7          	jalr	1474(ra) # 8020adaa <idup>
    802057f0:	872a                	mv	a4,a0
    802057f2:	fe843783          	ld	a5,-24(s0)
    802057f6:	e7f8                	sd	a4,200(a5)
    802057f8:	a029                	j	80205802 <create_kernel_proc1+0x9e>
		p->cwd = 0; // 或者在 main/init 进程里手动设置
    802057fa:	fe843783          	ld	a5,-24(s0)
    802057fe:	0c07b423          	sd	zero,200(a5)
    return p->pid;
    80205802:	fe843783          	ld	a5,-24(s0)
    80205806:	43dc                	lw	a5,4(a5)
}
    80205808:	853e                	mv	a0,a5
    8020580a:	70a2                	ld	ra,40(sp)
    8020580c:	7402                	ld	s0,32(sp)
    8020580e:	6145                	addi	sp,sp,48
    80205810:	8082                	ret

0000000080205812 <create_user_proc>:
int create_user_proc(const void *user_bin, int bin_size) {
    80205812:	711d                	addi	sp,sp,-96
    80205814:	ec86                	sd	ra,88(sp)
    80205816:	e8a2                	sd	s0,80(sp)
    80205818:	1080                	addi	s0,sp,96
    8020581a:	faa43423          	sd	a0,-88(s0)
    8020581e:	87ae                	mv	a5,a1
    80205820:	faf42223          	sw	a5,-92(s0)
    struct proc *p = alloc_proc(1); // 1 表示用户进程
    80205824:	4505                	li	a0,1
    80205826:	00000097          	auipc	ra,0x0
    8020582a:	c34080e7          	jalr	-972(ra) # 8020545a <alloc_proc>
    8020582e:	fea43023          	sd	a0,-32(s0)
    if (!p) return -1;
    80205832:	fe043783          	ld	a5,-32(s0)
    80205836:	e399                	bnez	a5,8020583c <create_user_proc+0x2a>
    80205838:	57fd                	li	a5,-1
    8020583a:	a439                	j	80205a48 <create_user_proc+0x236>
    uint64 user_entry = USER_TEXT_START;
    8020583c:	67c1                	lui	a5,0x10
    8020583e:	fcf43c23          	sd	a5,-40(s0)
    uint64 user_stack = USER_STACK_SIZE;
    80205842:	000207b7          	lui	a5,0x20
    80205846:	fcf43823          	sd	a5,-48(s0)
    void *page = alloc_page();
    8020584a:	ffffe097          	auipc	ra,0xffffe
    8020584e:	b12080e7          	jalr	-1262(ra) # 8020335c <alloc_page>
    80205852:	fca43423          	sd	a0,-56(s0)
    if (!page) { free_proc(p); return -1; }
    80205856:	fc843783          	ld	a5,-56(s0)
    8020585a:	eb89                	bnez	a5,8020586c <create_user_proc+0x5a>
    8020585c:	fe043503          	ld	a0,-32(s0)
    80205860:	00000097          	auipc	ra,0x0
    80205864:	da6080e7          	jalr	-602(ra) # 80205606 <free_proc>
    80205868:	57fd                	li	a5,-1
    8020586a:	aaf9                	j	80205a48 <create_user_proc+0x236>
    map_page(p->pagetable, user_entry, (uint64)page, PTE_R | PTE_W | PTE_X | PTE_U);
    8020586c:	fe043783          	ld	a5,-32(s0)
    80205870:	7fdc                	ld	a5,184(a5)
    80205872:	fc843703          	ld	a4,-56(s0)
    80205876:	46f9                	li	a3,30
    80205878:	863a                	mv	a2,a4
    8020587a:	fd843583          	ld	a1,-40(s0)
    8020587e:	853e                	mv	a0,a5
    80205880:	ffffd097          	auipc	ra,0xffffd
    80205884:	b90080e7          	jalr	-1136(ra) # 80202410 <map_page>
    memcpy((void*)page, user_bin, bin_size);
    80205888:	fa442783          	lw	a5,-92(s0)
    8020588c:	863e                	mv	a2,a5
    8020588e:	fa843583          	ld	a1,-88(s0)
    80205892:	fc843503          	ld	a0,-56(s0)
    80205896:	ffffc097          	auipc	ra,0xffffc
    8020589a:	7ba080e7          	jalr	1978(ra) # 80202050 <memcpy>
    for(int i = 0; i < 2; i++) {
    8020589e:	fe042623          	sw	zero,-20(s0)
    802058a2:	a8bd                	j	80205920 <create_user_proc+0x10e>
        void *stack_page = alloc_page();
    802058a4:	ffffe097          	auipc	ra,0xffffe
    802058a8:	ab8080e7          	jalr	-1352(ra) # 8020335c <alloc_page>
    802058ac:	faa43c23          	sd	a0,-72(s0)
        if (!stack_page) { 
    802058b0:	fb843783          	ld	a5,-72(s0)
    802058b4:	eb89                	bnez	a5,802058c6 <create_user_proc+0xb4>
            free_proc(p); 
    802058b6:	fe043503          	ld	a0,-32(s0)
    802058ba:	00000097          	auipc	ra,0x0
    802058be:	d4c080e7          	jalr	-692(ra) # 80205606 <free_proc>
            return -1; 
    802058c2:	57fd                	li	a5,-1
    802058c4:	a251                	j	80205a48 <create_user_proc+0x236>
        uint64 stack_va = USER_STACK_SIZE - PGSIZE * (i + 1);
    802058c6:	47fd                	li	a5,31
    802058c8:	fec42703          	lw	a4,-20(s0)
    802058cc:	9f99                	subw	a5,a5,a4
    802058ce:	2781                	sext.w	a5,a5
    802058d0:	00c7979b          	slliw	a5,a5,0xc
    802058d4:	2781                	sext.w	a5,a5
    802058d6:	faf43823          	sd	a5,-80(s0)
        if(map_page(p->pagetable, stack_va, (uint64)stack_page, 
    802058da:	fe043783          	ld	a5,-32(s0)
    802058de:	7fdc                	ld	a5,184(a5)
    802058e0:	fb843703          	ld	a4,-72(s0)
    802058e4:	46d9                	li	a3,22
    802058e6:	863a                	mv	a2,a4
    802058e8:	fb043583          	ld	a1,-80(s0)
    802058ec:	853e                	mv	a0,a5
    802058ee:	ffffd097          	auipc	ra,0xffffd
    802058f2:	b22080e7          	jalr	-1246(ra) # 80202410 <map_page>
    802058f6:	87aa                	mv	a5,a0
    802058f8:	cf99                	beqz	a5,80205916 <create_user_proc+0x104>
            free_page(stack_page);
    802058fa:	fb843503          	ld	a0,-72(s0)
    802058fe:	ffffe097          	auipc	ra,0xffffe
    80205902:	aca080e7          	jalr	-1334(ra) # 802033c8 <free_page>
            free_proc(p);
    80205906:	fe043503          	ld	a0,-32(s0)
    8020590a:	00000097          	auipc	ra,0x0
    8020590e:	cfc080e7          	jalr	-772(ra) # 80205606 <free_proc>
            return -1;
    80205912:	57fd                	li	a5,-1
    80205914:	aa15                	j	80205a48 <create_user_proc+0x236>
    for(int i = 0; i < 2; i++) {
    80205916:	fec42783          	lw	a5,-20(s0)
    8020591a:	2785                	addiw	a5,a5,1 # 20001 <_entry-0x801dffff>
    8020591c:	fef42623          	sw	a5,-20(s0)
    80205920:	fec42783          	lw	a5,-20(s0)
    80205924:	0007871b          	sext.w	a4,a5
    80205928:	4785                	li	a5,1
    8020592a:	f6e7dde3          	bge	a5,a4,802058a4 <create_user_proc+0x92>
	p->sz = user_stack; // 用户空间从 0x10000 到 0x20000
    8020592e:	fe043783          	ld	a5,-32(s0)
    80205932:	fd043703          	ld	a4,-48(s0)
    80205936:	fbd8                	sd	a4,176(a5)
    if (map_page(p->pagetable, TRAPFRAME, (uint64)p->trapframe, PTE_R | PTE_W) != 0) {
    80205938:	fe043783          	ld	a5,-32(s0)
    8020593c:	7fd8                	ld	a4,184(a5)
    8020593e:	fe043783          	ld	a5,-32(s0)
    80205942:	63fc                	ld	a5,192(a5)
    80205944:	4699                	li	a3,6
    80205946:	863e                	mv	a2,a5
    80205948:	75f9                	lui	a1,0xffffe
    8020594a:	853a                	mv	a0,a4
    8020594c:	ffffd097          	auipc	ra,0xffffd
    80205950:	ac4080e7          	jalr	-1340(ra) # 80202410 <map_page>
    80205954:	87aa                	mv	a5,a0
    80205956:	cb89                	beqz	a5,80205968 <create_user_proc+0x156>
        free_proc(p);
    80205958:	fe043503          	ld	a0,-32(s0)
    8020595c:	00000097          	auipc	ra,0x0
    80205960:	caa080e7          	jalr	-854(ra) # 80205606 <free_proc>
        return -1;
    80205964:	57fd                	li	a5,-1
    80205966:	a0cd                	j	80205a48 <create_user_proc+0x236>
	memset(p->trapframe, 0, sizeof(*p->trapframe));
    80205968:	fe043783          	ld	a5,-32(s0)
    8020596c:	63fc                	ld	a5,192(a5)
    8020596e:	13800613          	li	a2,312
    80205972:	4581                	li	a1,0
    80205974:	853e                	mv	a0,a5
    80205976:	ffffc097          	auipc	ra,0xffffc
    8020597a:	5ce080e7          	jalr	1486(ra) # 80201f44 <memset>
	p->trapframe->epc = user_entry; // 应为 0x10000
    8020597e:	fe043783          	ld	a5,-32(s0)
    80205982:	63fc                	ld	a5,192(a5)
    80205984:	fd843703          	ld	a4,-40(s0)
    80205988:	ff98                	sd	a4,56(a5)
	p->trapframe->sp = user_stack;  // 应为 0x20000
    8020598a:	fe043783          	ld	a5,-32(s0)
    8020598e:	63fc                	ld	a5,192(a5)
    80205990:	fd043703          	ld	a4,-48(s0)
    80205994:	e7b8                	sd	a4,72(a5)
	p->trapframe->sstatus = (1UL << 5); // 0x20
    80205996:	fe043783          	ld	a5,-32(s0)
    8020599a:	63fc                	ld	a5,192(a5)
    8020599c:	02000713          	li	a4,32
    802059a0:	fb98                	sd	a4,48(a5)
	p->trapframe->kernel_satp = MAKE_SATP(kernel_pagetable);
    802059a2:	00037797          	auipc	a5,0x37
    802059a6:	70e78793          	addi	a5,a5,1806 # 8023d0b0 <kernel_pagetable>
    802059aa:	639c                	ld	a5,0(a5)
    802059ac:	00c7d693          	srli	a3,a5,0xc
    802059b0:	fe043783          	ld	a5,-32(s0)
    802059b4:	63fc                	ld	a5,192(a5)
    802059b6:	577d                	li	a4,-1
    802059b8:	177e                	slli	a4,a4,0x3f
    802059ba:	8f55                	or	a4,a4,a3
    802059bc:	e398                	sd	a4,0(a5)
	p->trapframe->kernel_sp = p->kstack + PGSIZE;   // 内核栈顶
    802059be:	fe043783          	ld	a5,-32(s0)
    802059c2:	6794                	ld	a3,8(a5)
    802059c4:	fe043783          	ld	a5,-32(s0)
    802059c8:	63fc                	ld	a5,192(a5)
    802059ca:	6705                	lui	a4,0x1
    802059cc:	9736                	add	a4,a4,a3
    802059ce:	e798                	sd	a4,8(a5)
	p->trapframe->usertrap  = (uint64)usertrap;     // C 层 trap 处理函数
    802059d0:	fe043783          	ld	a5,-32(s0)
    802059d4:	63fc                	ld	a5,192(a5)
    802059d6:	fffff717          	auipc	a4,0xfffff
    802059da:	f2070713          	addi	a4,a4,-224 # 802048f6 <usertrap>
    802059de:	ef98                	sd	a4,24(a5)
	p->trapframe->kernel_vec = (uint64)kernelvec;
    802059e0:	fe043783          	ld	a5,-32(s0)
    802059e4:	63fc                	ld	a5,192(a5)
    802059e6:	fffff717          	auipc	a4,0xfffff
    802059ea:	32a70713          	addi	a4,a4,810 # 80204d10 <kernelvec>
    802059ee:	f398                	sd	a4,32(a5)
    p->state = RUNNABLE;
    802059f0:	fe043783          	ld	a5,-32(s0)
    802059f4:	470d                	li	a4,3
    802059f6:	c398                	sw	a4,0(a5)
	if (map_page(p->pagetable, TRAMPOLINE, trampoline_phys_addr, PTE_X | PTE_R) != 0) {
    802059f8:	fe043783          	ld	a5,-32(s0)
    802059fc:	7fd8                	ld	a4,184(a5)
    802059fe:	00037797          	auipc	a5,0x37
    80205a02:	6ba78793          	addi	a5,a5,1722 # 8023d0b8 <trampoline_phys_addr>
    80205a06:	639c                	ld	a5,0(a5)
    80205a08:	46a9                	li	a3,10
    80205a0a:	863e                	mv	a2,a5
    80205a0c:	75fd                	lui	a1,0xfffff
    80205a0e:	853a                	mv	a0,a4
    80205a10:	ffffd097          	auipc	ra,0xffffd
    80205a14:	a00080e7          	jalr	-1536(ra) # 80202410 <map_page>
    80205a18:	87aa                	mv	a5,a0
    80205a1a:	cb89                	beqz	a5,80205a2c <create_user_proc+0x21a>
		free_proc(p);
    80205a1c:	fe043503          	ld	a0,-32(s0)
    80205a20:	00000097          	auipc	ra,0x0
    80205a24:	be6080e7          	jalr	-1050(ra) # 80205606 <free_proc>
		return -1;
    80205a28:	57fd                	li	a5,-1
    80205a2a:	a839                	j	80205a48 <create_user_proc+0x236>
    struct proc *parent = myproc();
    80205a2c:	fffff097          	auipc	ra,0xfffff
    80205a30:	634080e7          	jalr	1588(ra) # 80205060 <myproc>
    80205a34:	fca43023          	sd	a0,-64(s0)
    p->parent = parent ? parent : NULL;
    80205a38:	fe043783          	ld	a5,-32(s0)
    80205a3c:	fc043703          	ld	a4,-64(s0)
    80205a40:	efd8                	sd	a4,152(a5)
    return p->pid;
    80205a42:	fe043783          	ld	a5,-32(s0)
    80205a46:	43dc                	lw	a5,4(a5)
}
    80205a48:	853e                	mv	a0,a5
    80205a4a:	60e6                	ld	ra,88(sp)
    80205a4c:	6446                	ld	s0,80(sp)
    80205a4e:	6125                	addi	sp,sp,96
    80205a50:	8082                	ret

0000000080205a52 <fork_proc>:
int fork_proc(void) {
    80205a52:	7179                	addi	sp,sp,-48
    80205a54:	f406                	sd	ra,40(sp)
    80205a56:	f022                	sd	s0,32(sp)
    80205a58:	1800                	addi	s0,sp,48
    struct proc *parent = myproc();
    80205a5a:	fffff097          	auipc	ra,0xfffff
    80205a5e:	606080e7          	jalr	1542(ra) # 80205060 <myproc>
    80205a62:	fea43423          	sd	a0,-24(s0)
    struct proc *child = alloc_proc(parent->is_user);
    80205a66:	fe843783          	ld	a5,-24(s0)
    80205a6a:	0a87a783          	lw	a5,168(a5)
    80205a6e:	853e                	mv	a0,a5
    80205a70:	00000097          	auipc	ra,0x0
    80205a74:	9ea080e7          	jalr	-1558(ra) # 8020545a <alloc_proc>
    80205a78:	fea43023          	sd	a0,-32(s0)
    if (!child) return -1;
    80205a7c:	fe043783          	ld	a5,-32(s0)
    80205a80:	e399                	bnez	a5,80205a86 <fork_proc+0x34>
    80205a82:	57fd                	li	a5,-1
    80205a84:	aa69                	j	80205c1e <fork_proc+0x1cc>
    if (uvmcopy(parent->pagetable, child->pagetable, parent->sz) < 0) {
    80205a86:	fe843783          	ld	a5,-24(s0)
    80205a8a:	7fd8                	ld	a4,184(a5)
    80205a8c:	fe043783          	ld	a5,-32(s0)
    80205a90:	7fd4                	ld	a3,184(a5)
    80205a92:	fe843783          	ld	a5,-24(s0)
    80205a96:	7bdc                	ld	a5,176(a5)
    80205a98:	863e                	mv	a2,a5
    80205a9a:	85b6                	mv	a1,a3
    80205a9c:	853a                	mv	a0,a4
    80205a9e:	ffffd097          	auipc	ra,0xffffd
    80205aa2:	6ee080e7          	jalr	1774(ra) # 8020318c <uvmcopy>
    80205aa6:	87aa                	mv	a5,a0
    80205aa8:	0007da63          	bgez	a5,80205abc <fork_proc+0x6a>
        free_proc(child);
    80205aac:	fe043503          	ld	a0,-32(s0)
    80205ab0:	00000097          	auipc	ra,0x0
    80205ab4:	b56080e7          	jalr	-1194(ra) # 80205606 <free_proc>
        return -1;
    80205ab8:	57fd                	li	a5,-1
    80205aba:	a295                	j	80205c1e <fork_proc+0x1cc>
    child->sz = parent->sz;
    80205abc:	fe843783          	ld	a5,-24(s0)
    80205ac0:	7bd8                	ld	a4,176(a5)
    80205ac2:	fe043783          	ld	a5,-32(s0)
    80205ac6:	fbd8                	sd	a4,176(a5)
    uint64 tf_pa = (uint64)child->trapframe;
    80205ac8:	fe043783          	ld	a5,-32(s0)
    80205acc:	63fc                	ld	a5,192(a5)
    80205ace:	fcf43c23          	sd	a5,-40(s0)
    if ((tf_pa & (PGSIZE - 1)) != 0) {
    80205ad2:	fd843703          	ld	a4,-40(s0)
    80205ad6:	6785                	lui	a5,0x1
    80205ad8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80205ada:	8ff9                	and	a5,a5,a4
    80205adc:	c39d                	beqz	a5,80205b02 <fork_proc+0xb0>
        printf("[fork] trapframe not aligned: 0x%lx\n", tf_pa);
    80205ade:	fd843583          	ld	a1,-40(s0)
    80205ae2:	00020517          	auipc	a0,0x20
    80205ae6:	c8650513          	addi	a0,a0,-890 # 80225768 <user_test_table+0x208>
    80205aea:	ffffb097          	auipc	ra,0xffffb
    80205aee:	79a080e7          	jalr	1946(ra) # 80201284 <printf>
        free_proc(child);
    80205af2:	fe043503          	ld	a0,-32(s0)
    80205af6:	00000097          	auipc	ra,0x0
    80205afa:	b10080e7          	jalr	-1264(ra) # 80205606 <free_proc>
        return -1;
    80205afe:	57fd                	li	a5,-1
    80205b00:	aa39                	j	80205c1e <fork_proc+0x1cc>
    if (map_page(child->pagetable, TRAPFRAME, tf_pa, PTE_R | PTE_W) != 0) {
    80205b02:	fe043783          	ld	a5,-32(s0)
    80205b06:	7fdc                	ld	a5,184(a5)
    80205b08:	4699                	li	a3,6
    80205b0a:	fd843603          	ld	a2,-40(s0)
    80205b0e:	75f9                	lui	a1,0xffffe
    80205b10:	853e                	mv	a0,a5
    80205b12:	ffffd097          	auipc	ra,0xffffd
    80205b16:	8fe080e7          	jalr	-1794(ra) # 80202410 <map_page>
    80205b1a:	87aa                	mv	a5,a0
    80205b1c:	c38d                	beqz	a5,80205b3e <fork_proc+0xec>
        printf("[fork] map TRAPFRAME failed\n");
    80205b1e:	00020517          	auipc	a0,0x20
    80205b22:	c7250513          	addi	a0,a0,-910 # 80225790 <user_test_table+0x230>
    80205b26:	ffffb097          	auipc	ra,0xffffb
    80205b2a:	75e080e7          	jalr	1886(ra) # 80201284 <printf>
        free_proc(child);
    80205b2e:	fe043503          	ld	a0,-32(s0)
    80205b32:	00000097          	auipc	ra,0x0
    80205b36:	ad4080e7          	jalr	-1324(ra) # 80205606 <free_proc>
        return -1;
    80205b3a:	57fd                	li	a5,-1
    80205b3c:	a0cd                	j	80205c1e <fork_proc+0x1cc>
    if (map_page(child->pagetable, TRAMPOLINE, trampoline_phys_addr, PTE_R | PTE_X) != 0) {
    80205b3e:	fe043783          	ld	a5,-32(s0)
    80205b42:	7fd8                	ld	a4,184(a5)
    80205b44:	00037797          	auipc	a5,0x37
    80205b48:	57478793          	addi	a5,a5,1396 # 8023d0b8 <trampoline_phys_addr>
    80205b4c:	639c                	ld	a5,0(a5)
    80205b4e:	46a9                	li	a3,10
    80205b50:	863e                	mv	a2,a5
    80205b52:	75fd                	lui	a1,0xfffff
    80205b54:	853a                	mv	a0,a4
    80205b56:	ffffd097          	auipc	ra,0xffffd
    80205b5a:	8ba080e7          	jalr	-1862(ra) # 80202410 <map_page>
    80205b5e:	87aa                	mv	a5,a0
    80205b60:	c38d                	beqz	a5,80205b82 <fork_proc+0x130>
        printf("[fork] map TRAMPOLINE failed\n");
    80205b62:	00020517          	auipc	a0,0x20
    80205b66:	c4e50513          	addi	a0,a0,-946 # 802257b0 <user_test_table+0x250>
    80205b6a:	ffffb097          	auipc	ra,0xffffb
    80205b6e:	71a080e7          	jalr	1818(ra) # 80201284 <printf>
        free_proc(child);
    80205b72:	fe043503          	ld	a0,-32(s0)
    80205b76:	00000097          	auipc	ra,0x0
    80205b7a:	a90080e7          	jalr	-1392(ra) # 80205606 <free_proc>
        return -1;
    80205b7e:	57fd                	li	a5,-1
    80205b80:	a879                	j	80205c1e <fork_proc+0x1cc>
    *(child->trapframe) = *(parent->trapframe);
    80205b82:	fe843783          	ld	a5,-24(s0)
    80205b86:	63f8                	ld	a4,192(a5)
    80205b88:	fe043783          	ld	a5,-32(s0)
    80205b8c:	63fc                	ld	a5,192(a5)
    80205b8e:	86be                	mv	a3,a5
    80205b90:	13800793          	li	a5,312
    80205b94:	863e                	mv	a2,a5
    80205b96:	85ba                	mv	a1,a4
    80205b98:	8536                	mv	a0,a3
    80205b9a:	ffffc097          	auipc	ra,0xffffc
    80205b9e:	4b6080e7          	jalr	1206(ra) # 80202050 <memcpy>
	child->trapframe->kernel_sp = child->kstack + PGSIZE;
    80205ba2:	fe043783          	ld	a5,-32(s0)
    80205ba6:	6794                	ld	a3,8(a5)
    80205ba8:	fe043783          	ld	a5,-32(s0)
    80205bac:	63fc                	ld	a5,192(a5)
    80205bae:	6705                	lui	a4,0x1
    80205bb0:	9736                	add	a4,a4,a3
    80205bb2:	e798                	sd	a4,8(a5)
	assert(child->trapframe->kernel_satp = MAKE_SATP(kernel_pagetable));
    80205bb4:	00037797          	auipc	a5,0x37
    80205bb8:	4fc78793          	addi	a5,a5,1276 # 8023d0b0 <kernel_pagetable>
    80205bbc:	639c                	ld	a5,0(a5)
    80205bbe:	00c7d693          	srli	a3,a5,0xc
    80205bc2:	fe043783          	ld	a5,-32(s0)
    80205bc6:	63fc                	ld	a5,192(a5)
    80205bc8:	577d                	li	a4,-1
    80205bca:	177e                	slli	a4,a4,0x3f
    80205bcc:	8f55                	or	a4,a4,a3
    80205bce:	e398                	sd	a4,0(a5)
    80205bd0:	639c                	ld	a5,0(a5)
    80205bd2:	2781                	sext.w	a5,a5
    80205bd4:	853e                	mv	a0,a5
    80205bd6:	fffff097          	auipc	ra,0xfffff
    80205bda:	414080e7          	jalr	1044(ra) # 80204fea <assert>
    child->trapframe->epc += 4;  // 跳过 ecall 指令
    80205bde:	fe043783          	ld	a5,-32(s0)
    80205be2:	63fc                	ld	a5,192(a5)
    80205be4:	7f98                	ld	a4,56(a5)
    80205be6:	fe043783          	ld	a5,-32(s0)
    80205bea:	63fc                	ld	a5,192(a5)
    80205bec:	0711                	addi	a4,a4,4 # 1004 <_entry-0x801feffc>
    80205bee:	ff98                	sd	a4,56(a5)
    child->trapframe->a0 = 0;    // 子进程fork返回0
    80205bf0:	fe043783          	ld	a5,-32(s0)
    80205bf4:	63fc                	ld	a5,192(a5)
    80205bf6:	0a07b423          	sd	zero,168(a5)
    child->state = RUNNABLE;
    80205bfa:	fe043783          	ld	a5,-32(s0)
    80205bfe:	470d                	li	a4,3
    80205c00:	c398                	sw	a4,0(a5)
    child->parent = parent;
    80205c02:	fe043783          	ld	a5,-32(s0)
    80205c06:	fe843703          	ld	a4,-24(s0)
    80205c0a:	efd8                	sd	a4,152(a5)
	child->cwd = parent->cwd;
    80205c0c:	fe843783          	ld	a5,-24(s0)
    80205c10:	67f8                	ld	a4,200(a5)
    80205c12:	fe043783          	ld	a5,-32(s0)
    80205c16:	e7f8                	sd	a4,200(a5)
    return child->pid;
    80205c18:	fe043783          	ld	a5,-32(s0)
    80205c1c:	43dc                	lw	a5,4(a5)
}
    80205c1e:	853e                	mv	a0,a5
    80205c20:	70a2                	ld	ra,40(sp)
    80205c22:	7402                	ld	s0,32(sp)
    80205c24:	6145                	addi	sp,sp,48
    80205c26:	8082                	ret

0000000080205c28 <schedule>:
void schedule(void) {
    80205c28:	1101                	addi	sp,sp,-32
    80205c2a:	ec06                	sd	ra,24(sp)
    80205c2c:	e822                	sd	s0,16(sp)
    80205c2e:	1000                	addi	s0,sp,32
    intr_on();
    80205c30:	fffff097          	auipc	ra,0xfffff
    80205c34:	34e080e7          	jalr	846(ra) # 80204f7e <intr_on>
    for(int i = 0; i < PROC; i++) {
    80205c38:	fe042623          	sw	zero,-20(s0)
    80205c3c:	a841                	j	80205ccc <schedule+0xa4>
        struct proc *p = proc_table[i];
    80205c3e:	00038717          	auipc	a4,0x38
    80205c42:	84a70713          	addi	a4,a4,-1974 # 8023d488 <proc_table>
    80205c46:	fec42783          	lw	a5,-20(s0)
    80205c4a:	078e                	slli	a5,a5,0x3
    80205c4c:	97ba                	add	a5,a5,a4
    80205c4e:	639c                	ld	a5,0(a5)
    80205c50:	fef43023          	sd	a5,-32(s0)
        if(p->state == RUNNABLE) {
    80205c54:	fe043783          	ld	a5,-32(s0)
    80205c58:	439c                	lw	a5,0(a5)
    80205c5a:	873e                	mv	a4,a5
    80205c5c:	478d                	li	a5,3
    80205c5e:	06f71263          	bne	a4,a5,80205cc2 <schedule+0x9a>
            p->state = RUNNING;
    80205c62:	fe043783          	ld	a5,-32(s0)
    80205c66:	4711                	li	a4,4
    80205c68:	c398                	sw	a4,0(a5)
            mycpu()->proc = p;
    80205c6a:	fffff097          	auipc	ra,0xfffff
    80205c6e:	40e080e7          	jalr	1038(ra) # 80205078 <mycpu>
    80205c72:	872a                	mv	a4,a0
    80205c74:	fe043783          	ld	a5,-32(s0)
    80205c78:	e31c                	sd	a5,0(a4)
            current_proc = p;
    80205c7a:	00037797          	auipc	a5,0x37
    80205c7e:	44e78793          	addi	a5,a5,1102 # 8023d0c8 <current_proc>
    80205c82:	fe043703          	ld	a4,-32(s0)
    80205c86:	e398                	sd	a4,0(a5)
            swtch(&mycpu()->context, &p->context);
    80205c88:	fffff097          	auipc	ra,0xfffff
    80205c8c:	3f0080e7          	jalr	1008(ra) # 80205078 <mycpu>
    80205c90:	87aa                	mv	a5,a0
    80205c92:	00878713          	addi	a4,a5,8
    80205c96:	fe043783          	ld	a5,-32(s0)
    80205c9a:	07c1                	addi	a5,a5,16
    80205c9c:	85be                	mv	a1,a5
    80205c9e:	853a                	mv	a0,a4
    80205ca0:	fffff097          	auipc	ra,0xfffff
    80205ca4:	240080e7          	jalr	576(ra) # 80204ee0 <swtch>
            mycpu()->proc = 0;
    80205ca8:	fffff097          	auipc	ra,0xfffff
    80205cac:	3d0080e7          	jalr	976(ra) # 80205078 <mycpu>
    80205cb0:	87aa                	mv	a5,a0
    80205cb2:	0007b023          	sd	zero,0(a5)
            current_proc = 0;
    80205cb6:	00037797          	auipc	a5,0x37
    80205cba:	41278793          	addi	a5,a5,1042 # 8023d0c8 <current_proc>
    80205cbe:	0007b023          	sd	zero,0(a5)
    for(int i = 0; i < PROC; i++) {
    80205cc2:	fec42783          	lw	a5,-20(s0)
    80205cc6:	2785                	addiw	a5,a5,1
    80205cc8:	fef42623          	sw	a5,-20(s0)
    80205ccc:	fec42783          	lw	a5,-20(s0)
    80205cd0:	0007871b          	sext.w	a4,a5
    80205cd4:	47fd                	li	a5,31
    80205cd6:	f6e7d4e3          	bge	a5,a4,80205c3e <schedule+0x16>
    intr_on();
    80205cda:	bf99                	j	80205c30 <schedule+0x8>

0000000080205cdc <yield>:
void yield(void) {
    80205cdc:	1101                	addi	sp,sp,-32
    80205cde:	ec06                	sd	ra,24(sp)
    80205ce0:	e822                	sd	s0,16(sp)
    80205ce2:	1000                	addi	s0,sp,32
	intr_off();
    80205ce4:	fffff097          	auipc	ra,0xfffff
    80205ce8:	2c4080e7          	jalr	708(ra) # 80204fa8 <intr_off>
    struct proc *p = myproc();
    80205cec:	fffff097          	auipc	ra,0xfffff
    80205cf0:	374080e7          	jalr	884(ra) # 80205060 <myproc>
    80205cf4:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    80205cf8:	fe843783          	ld	a5,-24(s0)
    80205cfc:	cfb5                	beqz	a5,80205d78 <yield+0x9c>
    struct cpu *c = mycpu();
    80205cfe:	fffff097          	auipc	ra,0xfffff
    80205d02:	37a080e7          	jalr	890(ra) # 80205078 <mycpu>
    80205d06:	fea43023          	sd	a0,-32(s0)
    p->state = RUNNABLE;
    80205d0a:	fe843783          	ld	a5,-24(s0)
    80205d0e:	470d                	li	a4,3
    80205d10:	c398                	sw	a4,0(a5)
    current_proc = 0;
    80205d12:	00037797          	auipc	a5,0x37
    80205d16:	3b678793          	addi	a5,a5,950 # 8023d0c8 <current_proc>
    80205d1a:	0007b023          	sd	zero,0(a5)
    c->proc = 0;
    80205d1e:	fe043783          	ld	a5,-32(s0)
    80205d22:	0007b023          	sd	zero,0(a5)
	intr_on();
    80205d26:	fffff097          	auipc	ra,0xfffff
    80205d2a:	258080e7          	jalr	600(ra) # 80204f7e <intr_on>
    swtch(&p->context, &c->context);
    80205d2e:	fe843783          	ld	a5,-24(s0)
    80205d32:	01078713          	addi	a4,a5,16
    80205d36:	fe043783          	ld	a5,-32(s0)
    80205d3a:	07a1                	addi	a5,a5,8
    80205d3c:	85be                	mv	a1,a5
    80205d3e:	853a                	mv	a0,a4
    80205d40:	fffff097          	auipc	ra,0xfffff
    80205d44:	1a0080e7          	jalr	416(ra) # 80204ee0 <swtch>
	if (p->killed) {
    80205d48:	fe843783          	ld	a5,-24(s0)
    80205d4c:	0807a783          	lw	a5,128(a5)
    80205d50:	c78d                	beqz	a5,80205d7a <yield+0x9e>
        printf("[yield] Process PID %d killed during yield\n", p->pid);
    80205d52:	fe843783          	ld	a5,-24(s0)
    80205d56:	43dc                	lw	a5,4(a5)
    80205d58:	85be                	mv	a1,a5
    80205d5a:	00020517          	auipc	a0,0x20
    80205d5e:	a7650513          	addi	a0,a0,-1418 # 802257d0 <user_test_table+0x270>
    80205d62:	ffffb097          	auipc	ra,0xffffb
    80205d66:	522080e7          	jalr	1314(ra) # 80201284 <printf>
        exit_proc(SYS_kill);
    80205d6a:	08100513          	li	a0,129
    80205d6e:	00000097          	auipc	ra,0x0
    80205d72:	1ae080e7          	jalr	430(ra) # 80205f1c <exit_proc>
        return;
    80205d76:	a011                	j	80205d7a <yield+0x9e>
        return;
    80205d78:	0001                	nop
}
    80205d7a:	60e2                	ld	ra,24(sp)
    80205d7c:	6442                	ld	s0,16(sp)
    80205d7e:	6105                	addi	sp,sp,32
    80205d80:	8082                	ret

0000000080205d82 <sleep>:
void sleep(void *chan, struct spinlock *lk){
    80205d82:	7179                	addi	sp,sp,-48
    80205d84:	f406                	sd	ra,40(sp)
    80205d86:	f022                	sd	s0,32(sp)
    80205d88:	1800                	addi	s0,sp,48
    80205d8a:	fca43c23          	sd	a0,-40(s0)
    80205d8e:	fcb43823          	sd	a1,-48(s0)
	intr_off();
    80205d92:	fffff097          	auipc	ra,0xfffff
    80205d96:	216080e7          	jalr	534(ra) # 80204fa8 <intr_off>
    struct proc *p = myproc();
    80205d9a:	fffff097          	auipc	ra,0xfffff
    80205d9e:	2c6080e7          	jalr	710(ra) # 80205060 <myproc>
    80205da2:	fea43423          	sd	a0,-24(s0)
    struct cpu *c = mycpu();
    80205da6:	fffff097          	auipc	ra,0xfffff
    80205daa:	2d2080e7          	jalr	722(ra) # 80205078 <mycpu>
    80205dae:	fea43023          	sd	a0,-32(s0)
    p->context.ra = ra;
    80205db2:	8706                	mv	a4,ra
    80205db4:	fe843783          	ld	a5,-24(s0)
    80205db8:	eb98                	sd	a4,16(a5)
    p->chan = chan;
    80205dba:	fe843783          	ld	a5,-24(s0)
    80205dbe:	fd843703          	ld	a4,-40(s0)
    80205dc2:	f3d8                	sd	a4,160(a5)
    p->state = SLEEPING;
    80205dc4:	fe843783          	ld	a5,-24(s0)
    80205dc8:	4709                	li	a4,2
    80205dca:	c398                	sw	a4,0(a5)
    if (lk){
    80205dcc:	fd043783          	ld	a5,-48(s0)
    80205dd0:	c799                	beqz	a5,80205dde <sleep+0x5c>
        release(lk);
    80205dd2:	fd043503          	ld	a0,-48(s0)
    80205dd6:	00006097          	auipc	ra,0x6
    80205dda:	3ae080e7          	jalr	942(ra) # 8020c184 <release>
	intr_on();
    80205dde:	fffff097          	auipc	ra,0xfffff
    80205de2:	1a0080e7          	jalr	416(ra) # 80204f7e <intr_on>
    swtch(&p->context, &c->context);
    80205de6:	fe843783          	ld	a5,-24(s0)
    80205dea:	01078713          	addi	a4,a5,16
    80205dee:	fe043783          	ld	a5,-32(s0)
    80205df2:	07a1                	addi	a5,a5,8
    80205df4:	85be                	mv	a1,a5
    80205df6:	853a                	mv	a0,a4
    80205df8:	fffff097          	auipc	ra,0xfffff
    80205dfc:	0e8080e7          	jalr	232(ra) # 80204ee0 <swtch>
    p->chan = 0;
    80205e00:	fe843783          	ld	a5,-24(s0)
    80205e04:	0a07b023          	sd	zero,160(a5)
    if (lk)
    80205e08:	fd043783          	ld	a5,-48(s0)
    80205e0c:	c799                	beqz	a5,80205e1a <sleep+0x98>
        acquire(lk);
    80205e0e:	fd043503          	ld	a0,-48(s0)
    80205e12:	00006097          	auipc	ra,0x6
    80205e16:	326080e7          	jalr	806(ra) # 8020c138 <acquire>
    if(p->killed){
    80205e1a:	fe843783          	ld	a5,-24(s0)
    80205e1e:	0807a783          	lw	a5,128(a5)
    80205e22:	c799                	beqz	a5,80205e30 <sleep+0xae>
        exit_proc(SYS_kill);
    80205e24:	08100513          	li	a0,129
    80205e28:	00000097          	auipc	ra,0x0
    80205e2c:	0f4080e7          	jalr	244(ra) # 80205f1c <exit_proc>
}
    80205e30:	0001                	nop
    80205e32:	70a2                	ld	ra,40(sp)
    80205e34:	7402                	ld	s0,32(sp)
    80205e36:	6145                	addi	sp,sp,48
    80205e38:	8082                	ret

0000000080205e3a <wakeup>:
void wakeup(void *chan) {
    80205e3a:	7179                	addi	sp,sp,-48
    80205e3c:	f406                	sd	ra,40(sp)
    80205e3e:	f022                	sd	s0,32(sp)
    80205e40:	1800                	addi	s0,sp,48
    80205e42:	fca43c23          	sd	a0,-40(s0)
	intr_off();
    80205e46:	fffff097          	auipc	ra,0xfffff
    80205e4a:	162080e7          	jalr	354(ra) # 80204fa8 <intr_off>
    for(int i = 0; i < PROC; i++) {
    80205e4e:	fe042623          	sw	zero,-20(s0)
    80205e52:	a099                	j	80205e98 <wakeup+0x5e>
        struct proc *p = proc_table[i];
    80205e54:	00037717          	auipc	a4,0x37
    80205e58:	63470713          	addi	a4,a4,1588 # 8023d488 <proc_table>
    80205e5c:	fec42783          	lw	a5,-20(s0)
    80205e60:	078e                	slli	a5,a5,0x3
    80205e62:	97ba                	add	a5,a5,a4
    80205e64:	639c                	ld	a5,0(a5)
    80205e66:	fef43023          	sd	a5,-32(s0)
        if(p->state == SLEEPING && p->chan == chan) {
    80205e6a:	fe043783          	ld	a5,-32(s0)
    80205e6e:	439c                	lw	a5,0(a5)
    80205e70:	873e                	mv	a4,a5
    80205e72:	4789                	li	a5,2
    80205e74:	00f71d63          	bne	a4,a5,80205e8e <wakeup+0x54>
    80205e78:	fe043783          	ld	a5,-32(s0)
    80205e7c:	73dc                	ld	a5,160(a5)
    80205e7e:	fd843703          	ld	a4,-40(s0)
    80205e82:	00f71663          	bne	a4,a5,80205e8e <wakeup+0x54>
            p->state = RUNNABLE;
    80205e86:	fe043783          	ld	a5,-32(s0)
    80205e8a:	470d                	li	a4,3
    80205e8c:	c398                	sw	a4,0(a5)
    for(int i = 0; i < PROC; i++) {
    80205e8e:	fec42783          	lw	a5,-20(s0)
    80205e92:	2785                	addiw	a5,a5,1
    80205e94:	fef42623          	sw	a5,-20(s0)
    80205e98:	fec42783          	lw	a5,-20(s0)
    80205e9c:	0007871b          	sext.w	a4,a5
    80205ea0:	47fd                	li	a5,31
    80205ea2:	fae7d9e3          	bge	a5,a4,80205e54 <wakeup+0x1a>
	intr_on();
    80205ea6:	fffff097          	auipc	ra,0xfffff
    80205eaa:	0d8080e7          	jalr	216(ra) # 80204f7e <intr_on>
}
    80205eae:	0001                	nop
    80205eb0:	70a2                	ld	ra,40(sp)
    80205eb2:	7402                	ld	s0,32(sp)
    80205eb4:	6145                	addi	sp,sp,48
    80205eb6:	8082                	ret

0000000080205eb8 <kill_proc>:
void kill_proc(int pid){
    80205eb8:	7179                	addi	sp,sp,-48
    80205eba:	f422                	sd	s0,40(sp)
    80205ebc:	1800                	addi	s0,sp,48
    80205ebe:	87aa                	mv	a5,a0
    80205ec0:	fcf42e23          	sw	a5,-36(s0)
	for(int i=0;i<PROC;i++){
    80205ec4:	fe042623          	sw	zero,-20(s0)
    80205ec8:	a83d                	j	80205f06 <kill_proc+0x4e>
		struct proc *p = proc_table[i];
    80205eca:	00037717          	auipc	a4,0x37
    80205ece:	5be70713          	addi	a4,a4,1470 # 8023d488 <proc_table>
    80205ed2:	fec42783          	lw	a5,-20(s0)
    80205ed6:	078e                	slli	a5,a5,0x3
    80205ed8:	97ba                	add	a5,a5,a4
    80205eda:	639c                	ld	a5,0(a5)
    80205edc:	fef43023          	sd	a5,-32(s0)
		if(pid == p->pid){
    80205ee0:	fe043783          	ld	a5,-32(s0)
    80205ee4:	43d8                	lw	a4,4(a5)
    80205ee6:	fdc42783          	lw	a5,-36(s0)
    80205eea:	2781                	sext.w	a5,a5
    80205eec:	00e79863          	bne	a5,a4,80205efc <kill_proc+0x44>
			p->killed = 1;
    80205ef0:	fe043783          	ld	a5,-32(s0)
    80205ef4:	4705                	li	a4,1
    80205ef6:	08e7a023          	sw	a4,128(a5)
			break;
    80205efa:	a829                	j	80205f14 <kill_proc+0x5c>
	for(int i=0;i<PROC;i++){
    80205efc:	fec42783          	lw	a5,-20(s0)
    80205f00:	2785                	addiw	a5,a5,1
    80205f02:	fef42623          	sw	a5,-20(s0)
    80205f06:	fec42783          	lw	a5,-20(s0)
    80205f0a:	0007871b          	sext.w	a4,a5
    80205f0e:	47fd                	li	a5,31
    80205f10:	fae7dde3          	bge	a5,a4,80205eca <kill_proc+0x12>
	return;
    80205f14:	0001                	nop
}
    80205f16:	7422                	ld	s0,40(sp)
    80205f18:	6145                	addi	sp,sp,48
    80205f1a:	8082                	ret

0000000080205f1c <exit_proc>:
void exit_proc(int status) {
    80205f1c:	7179                	addi	sp,sp,-48
    80205f1e:	f406                	sd	ra,40(sp)
    80205f20:	f022                	sd	s0,32(sp)
    80205f22:	1800                	addi	s0,sp,48
    80205f24:	87aa                	mv	a5,a0
    80205f26:	fcf42e23          	sw	a5,-36(s0)
    struct proc *p = myproc();
    80205f2a:	fffff097          	auipc	ra,0xfffff
    80205f2e:	136080e7          	jalr	310(ra) # 80205060 <myproc>
    80205f32:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    80205f36:	fe843783          	ld	a5,-24(s0)
    80205f3a:	eb89                	bnez	a5,80205f4c <exit_proc+0x30>
        panic("exit_proc: no current process");
    80205f3c:	00020517          	auipc	a0,0x20
    80205f40:	8c450513          	addi	a0,a0,-1852 # 80225800 <user_test_table+0x2a0>
    80205f44:	ffffc097          	auipc	ra,0xffffc
    80205f48:	8c2080e7          	jalr	-1854(ra) # 80201806 <panic>
    p->exit_status = status;
    80205f4c:	fe843783          	ld	a5,-24(s0)
    80205f50:	fdc42703          	lw	a4,-36(s0)
    80205f54:	08e7a223          	sw	a4,132(a5)
    if (!p->parent) {
    80205f58:	fe843783          	ld	a5,-24(s0)
    80205f5c:	6fdc                	ld	a5,152(a5)
    80205f5e:	e789                	bnez	a5,80205f68 <exit_proc+0x4c>
        shutdown();
    80205f60:	fffff097          	auipc	ra,0xfffff
    80205f64:	0d6080e7          	jalr	214(ra) # 80205036 <shutdown>
    p->state = ZOMBIE;
    80205f68:	fe843783          	ld	a5,-24(s0)
    80205f6c:	4715                	li	a4,5
    80205f6e:	c398                	sw	a4,0(a5)
    wakeup((void*)p->parent);
    80205f70:	fe843783          	ld	a5,-24(s0)
    80205f74:	6fdc                	ld	a5,152(a5)
    80205f76:	853e                	mv	a0,a5
    80205f78:	00000097          	auipc	ra,0x0
    80205f7c:	ec2080e7          	jalr	-318(ra) # 80205e3a <wakeup>
    current_proc = 0;
    80205f80:	00037797          	auipc	a5,0x37
    80205f84:	14878793          	addi	a5,a5,328 # 8023d0c8 <current_proc>
    80205f88:	0007b023          	sd	zero,0(a5)
    if (mycpu())
    80205f8c:	fffff097          	auipc	ra,0xfffff
    80205f90:	0ec080e7          	jalr	236(ra) # 80205078 <mycpu>
    80205f94:	87aa                	mv	a5,a0
    80205f96:	cb81                	beqz	a5,80205fa6 <exit_proc+0x8a>
        mycpu()->proc = 0;
    80205f98:	fffff097          	auipc	ra,0xfffff
    80205f9c:	0e0080e7          	jalr	224(ra) # 80205078 <mycpu>
    80205fa0:	87aa                	mv	a5,a0
    80205fa2:	0007b023          	sd	zero,0(a5)
    struct cpu *c = mycpu();
    80205fa6:	fffff097          	auipc	ra,0xfffff
    80205faa:	0d2080e7          	jalr	210(ra) # 80205078 <mycpu>
    80205fae:	fea43023          	sd	a0,-32(s0)
    swtch(&p->context, &c->context);
    80205fb2:	fe843783          	ld	a5,-24(s0)
    80205fb6:	01078713          	addi	a4,a5,16
    80205fba:	fe043783          	ld	a5,-32(s0)
    80205fbe:	07a1                	addi	a5,a5,8
    80205fc0:	85be                	mv	a1,a5
    80205fc2:	853a                	mv	a0,a4
    80205fc4:	fffff097          	auipc	ra,0xfffff
    80205fc8:	f1c080e7          	jalr	-228(ra) # 80204ee0 <swtch>
    panic("exit_proc should not return after schedule");
    80205fcc:	00020517          	auipc	a0,0x20
    80205fd0:	85450513          	addi	a0,a0,-1964 # 80225820 <user_test_table+0x2c0>
    80205fd4:	ffffc097          	auipc	ra,0xffffc
    80205fd8:	832080e7          	jalr	-1998(ra) # 80201806 <panic>
}
    80205fdc:	0001                	nop
    80205fde:	70a2                	ld	ra,40(sp)
    80205fe0:	7402                	ld	s0,32(sp)
    80205fe2:	6145                	addi	sp,sp,48
    80205fe4:	8082                	ret

0000000080205fe6 <wait_proc>:
int wait_proc(int *status) {
    80205fe6:	711d                	addi	sp,sp,-96
    80205fe8:	ec86                	sd	ra,88(sp)
    80205fea:	e8a2                	sd	s0,80(sp)
    80205fec:	1080                	addi	s0,sp,96
    80205fee:	faa43423          	sd	a0,-88(s0)
    struct proc *p = myproc();
    80205ff2:	fffff097          	auipc	ra,0xfffff
    80205ff6:	06e080e7          	jalr	110(ra) # 80205060 <myproc>
    80205ffa:	fca43023          	sd	a0,-64(s0)
    if (p == 0) {
    80205ffe:	fc043783          	ld	a5,-64(s0)
    80206002:	eb99                	bnez	a5,80206018 <wait_proc+0x32>
        printf("Warning: wait_proc called with no current process\n");
    80206004:	00020517          	auipc	a0,0x20
    80206008:	84c50513          	addi	a0,a0,-1972 # 80225850 <user_test_table+0x2f0>
    8020600c:	ffffb097          	auipc	ra,0xffffb
    80206010:	278080e7          	jalr	632(ra) # 80201284 <printf>
        return -1;
    80206014:	57fd                	li	a5,-1
    80206016:	aa81                	j	80206166 <wait_proc+0x180>
        intr_off();
    80206018:	fffff097          	auipc	ra,0xfffff
    8020601c:	f90080e7          	jalr	-112(ra) # 80204fa8 <intr_off>
        int found_zombie = 0;
    80206020:	fe042623          	sw	zero,-20(s0)
        int zombie_pid = 0;
    80206024:	fe042423          	sw	zero,-24(s0)
        int zombie_status = 0;
    80206028:	fe042223          	sw	zero,-28(s0)
        struct proc *zombie_child = 0;
    8020602c:	fc043c23          	sd	zero,-40(s0)
        for (int i = 0; i < PROC; i++) {
    80206030:	fc042a23          	sw	zero,-44(s0)
    80206034:	a095                	j	80206098 <wait_proc+0xb2>
            struct proc *child = proc_table[i];
    80206036:	00037717          	auipc	a4,0x37
    8020603a:	45270713          	addi	a4,a4,1106 # 8023d488 <proc_table>
    8020603e:	fd442783          	lw	a5,-44(s0)
    80206042:	078e                	slli	a5,a5,0x3
    80206044:	97ba                	add	a5,a5,a4
    80206046:	639c                	ld	a5,0(a5)
    80206048:	faf43c23          	sd	a5,-72(s0)
            if (child->state == ZOMBIE && child->parent == p) {
    8020604c:	fb843783          	ld	a5,-72(s0)
    80206050:	439c                	lw	a5,0(a5)
    80206052:	873e                	mv	a4,a5
    80206054:	4795                	li	a5,5
    80206056:	02f71c63          	bne	a4,a5,8020608e <wait_proc+0xa8>
    8020605a:	fb843783          	ld	a5,-72(s0)
    8020605e:	6fdc                	ld	a5,152(a5)
    80206060:	fc043703          	ld	a4,-64(s0)
    80206064:	02f71563          	bne	a4,a5,8020608e <wait_proc+0xa8>
                found_zombie = 1;
    80206068:	4785                	li	a5,1
    8020606a:	fef42623          	sw	a5,-20(s0)
                zombie_pid = child->pid;
    8020606e:	fb843783          	ld	a5,-72(s0)
    80206072:	43dc                	lw	a5,4(a5)
    80206074:	fef42423          	sw	a5,-24(s0)
                zombie_status = child->exit_status;
    80206078:	fb843783          	ld	a5,-72(s0)
    8020607c:	0847a783          	lw	a5,132(a5)
    80206080:	fef42223          	sw	a5,-28(s0)
                zombie_child = child;
    80206084:	fb843783          	ld	a5,-72(s0)
    80206088:	fcf43c23          	sd	a5,-40(s0)
                break;
    8020608c:	a829                	j	802060a6 <wait_proc+0xc0>
        for (int i = 0; i < PROC; i++) {
    8020608e:	fd442783          	lw	a5,-44(s0)
    80206092:	2785                	addiw	a5,a5,1
    80206094:	fcf42a23          	sw	a5,-44(s0)
    80206098:	fd442783          	lw	a5,-44(s0)
    8020609c:	0007871b          	sext.w	a4,a5
    802060a0:	47fd                	li	a5,31
    802060a2:	f8e7dae3          	bge	a5,a4,80206036 <wait_proc+0x50>
        if (found_zombie) {
    802060a6:	fec42783          	lw	a5,-20(s0)
    802060aa:	2781                	sext.w	a5,a5
    802060ac:	cb85                	beqz	a5,802060dc <wait_proc+0xf6>
            if (status)
    802060ae:	fa843783          	ld	a5,-88(s0)
    802060b2:	c791                	beqz	a5,802060be <wait_proc+0xd8>
                *status = zombie_status;
    802060b4:	fa843783          	ld	a5,-88(s0)
    802060b8:	fe442703          	lw	a4,-28(s0)
    802060bc:	c398                	sw	a4,0(a5)
			intr_on();
    802060be:	fffff097          	auipc	ra,0xfffff
    802060c2:	ec0080e7          	jalr	-320(ra) # 80204f7e <intr_on>
            free_proc(zombie_child);
    802060c6:	fd843503          	ld	a0,-40(s0)
    802060ca:	fffff097          	auipc	ra,0xfffff
    802060ce:	53c080e7          	jalr	1340(ra) # 80205606 <free_proc>
            zombie_child = NULL;
    802060d2:	fc043c23          	sd	zero,-40(s0)
            return zombie_pid;
    802060d6:	fe842783          	lw	a5,-24(s0)
    802060da:	a071                	j	80206166 <wait_proc+0x180>
        int havekids = 0;
    802060dc:	fc042823          	sw	zero,-48(s0)
        for (int i = 0; i < PROC; i++) {
    802060e0:	fc042623          	sw	zero,-52(s0)
    802060e4:	a0b9                	j	80206132 <wait_proc+0x14c>
            struct proc *child = proc_table[i];
    802060e6:	00037717          	auipc	a4,0x37
    802060ea:	3a270713          	addi	a4,a4,930 # 8023d488 <proc_table>
    802060ee:	fcc42783          	lw	a5,-52(s0)
    802060f2:	078e                	slli	a5,a5,0x3
    802060f4:	97ba                	add	a5,a5,a4
    802060f6:	639c                	ld	a5,0(a5)
    802060f8:	faf43823          	sd	a5,-80(s0)
            if (child->state != UNUSED && child->state != ZOMBIE && child->parent == p) {
    802060fc:	fb043783          	ld	a5,-80(s0)
    80206100:	439c                	lw	a5,0(a5)
    80206102:	c39d                	beqz	a5,80206128 <wait_proc+0x142>
    80206104:	fb043783          	ld	a5,-80(s0)
    80206108:	439c                	lw	a5,0(a5)
    8020610a:	873e                	mv	a4,a5
    8020610c:	4795                	li	a5,5
    8020610e:	00f70d63          	beq	a4,a5,80206128 <wait_proc+0x142>
    80206112:	fb043783          	ld	a5,-80(s0)
    80206116:	6fdc                	ld	a5,152(a5)
    80206118:	fc043703          	ld	a4,-64(s0)
    8020611c:	00f71663          	bne	a4,a5,80206128 <wait_proc+0x142>
                havekids = 1;
    80206120:	4785                	li	a5,1
    80206122:	fcf42823          	sw	a5,-48(s0)
                break;
    80206126:	a829                	j	80206140 <wait_proc+0x15a>
        for (int i = 0; i < PROC; i++) {
    80206128:	fcc42783          	lw	a5,-52(s0)
    8020612c:	2785                	addiw	a5,a5,1
    8020612e:	fcf42623          	sw	a5,-52(s0)
    80206132:	fcc42783          	lw	a5,-52(s0)
    80206136:	0007871b          	sext.w	a4,a5
    8020613a:	47fd                	li	a5,31
    8020613c:	fae7d5e3          	bge	a5,a4,802060e6 <wait_proc+0x100>
        if (!havekids) {
    80206140:	fd042783          	lw	a5,-48(s0)
    80206144:	2781                	sext.w	a5,a5
    80206146:	e799                	bnez	a5,80206154 <wait_proc+0x16e>
            intr_on();
    80206148:	fffff097          	auipc	ra,0xfffff
    8020614c:	e36080e7          	jalr	-458(ra) # 80204f7e <intr_on>
            return -1;
    80206150:	57fd                	li	a5,-1
    80206152:	a811                	j	80206166 <wait_proc+0x180>
		intr_on();
    80206154:	fffff097          	auipc	ra,0xfffff
    80206158:	e2a080e7          	jalr	-470(ra) # 80204f7e <intr_on>
        yield();
    8020615c:	00000097          	auipc	ra,0x0
    80206160:	b80080e7          	jalr	-1152(ra) # 80205cdc <yield>
    while (1) {
    80206164:	bd55                	j	80206018 <wait_proc+0x32>
}
    80206166:	853e                	mv	a0,a5
    80206168:	60e6                	ld	ra,88(sp)
    8020616a:	6446                	ld	s0,80(sp)
    8020616c:	6125                	addi	sp,sp,96
    8020616e:	8082                	ret

0000000080206170 <print_proc_table>:
void print_proc_table(void) {
    80206170:	715d                	addi	sp,sp,-80
    80206172:	e486                	sd	ra,72(sp)
    80206174:	e0a2                	sd	s0,64(sp)
    80206176:	0880                	addi	s0,sp,80
    int count = 0;
    80206178:	fe042623          	sw	zero,-20(s0)
    printf("PID  TYPE STATUS     PPID   FUNC_ADDR      STACK_ADDR    \n");
    8020617c:	0001f517          	auipc	a0,0x1f
    80206180:	70c50513          	addi	a0,a0,1804 # 80225888 <user_test_table+0x328>
    80206184:	ffffb097          	auipc	ra,0xffffb
    80206188:	100080e7          	jalr	256(ra) # 80201284 <printf>
    printf("----------------------------------------------------------\n");
    8020618c:	0001f517          	auipc	a0,0x1f
    80206190:	73c50513          	addi	a0,a0,1852 # 802258c8 <user_test_table+0x368>
    80206194:	ffffb097          	auipc	ra,0xffffb
    80206198:	0f0080e7          	jalr	240(ra) # 80201284 <printf>
    for(int i = 0; i < PROC; i++) {
    8020619c:	fe042423          	sw	zero,-24(s0)
    802061a0:	a2a9                	j	802062ea <print_proc_table+0x17a>
        struct proc *p = proc_table[i];
    802061a2:	00037717          	auipc	a4,0x37
    802061a6:	2e670713          	addi	a4,a4,742 # 8023d488 <proc_table>
    802061aa:	fe842783          	lw	a5,-24(s0)
    802061ae:	078e                	slli	a5,a5,0x3
    802061b0:	97ba                	add	a5,a5,a4
    802061b2:	639c                	ld	a5,0(a5)
    802061b4:	fcf43c23          	sd	a5,-40(s0)
        if(p->state != UNUSED) {
    802061b8:	fd843783          	ld	a5,-40(s0)
    802061bc:	439c                	lw	a5,0(a5)
    802061be:	12078163          	beqz	a5,802062e0 <print_proc_table+0x170>
            count++;
    802061c2:	fec42783          	lw	a5,-20(s0)
    802061c6:	2785                	addiw	a5,a5,1
    802061c8:	fef42623          	sw	a5,-20(s0)
            const char *type = (p->is_user ? "USR" : "SYS");
    802061cc:	fd843783          	ld	a5,-40(s0)
    802061d0:	0a87a783          	lw	a5,168(a5)
    802061d4:	c791                	beqz	a5,802061e0 <print_proc_table+0x70>
    802061d6:	0001f797          	auipc	a5,0x1f
    802061da:	73278793          	addi	a5,a5,1842 # 80225908 <user_test_table+0x3a8>
    802061de:	a029                	j	802061e8 <print_proc_table+0x78>
    802061e0:	0001f797          	auipc	a5,0x1f
    802061e4:	73078793          	addi	a5,a5,1840 # 80225910 <user_test_table+0x3b0>
    802061e8:	fcf43823          	sd	a5,-48(s0)
            switch(p->state) {
    802061ec:	fd843783          	ld	a5,-40(s0)
    802061f0:	439c                	lw	a5,0(a5)
    802061f2:	86be                	mv	a3,a5
    802061f4:	4715                	li	a4,5
    802061f6:	06d76c63          	bltu	a4,a3,8020626e <print_proc_table+0xfe>
    802061fa:	00279713          	slli	a4,a5,0x2
    802061fe:	0001f797          	auipc	a5,0x1f
    80206202:	79a78793          	addi	a5,a5,1946 # 80225998 <user_test_table+0x438>
    80206206:	97ba                	add	a5,a5,a4
    80206208:	439c                	lw	a5,0(a5)
    8020620a:	0007871b          	sext.w	a4,a5
    8020620e:	0001f797          	auipc	a5,0x1f
    80206212:	78a78793          	addi	a5,a5,1930 # 80225998 <user_test_table+0x438>
    80206216:	97ba                	add	a5,a5,a4
    80206218:	8782                	jr	a5
                case UNUSED:   status = "UNUSED"; break;
    8020621a:	0001f797          	auipc	a5,0x1f
    8020621e:	6fe78793          	addi	a5,a5,1790 # 80225918 <user_test_table+0x3b8>
    80206222:	fef43023          	sd	a5,-32(s0)
    80206226:	a899                	j	8020627c <print_proc_table+0x10c>
                case USED:     status = "USED"; break;
    80206228:	0001f797          	auipc	a5,0x1f
    8020622c:	6f878793          	addi	a5,a5,1784 # 80225920 <user_test_table+0x3c0>
    80206230:	fef43023          	sd	a5,-32(s0)
    80206234:	a0a1                	j	8020627c <print_proc_table+0x10c>
                case SLEEPING: status = "SLEEP"; break;
    80206236:	0001f797          	auipc	a5,0x1f
    8020623a:	6f278793          	addi	a5,a5,1778 # 80225928 <user_test_table+0x3c8>
    8020623e:	fef43023          	sd	a5,-32(s0)
    80206242:	a82d                	j	8020627c <print_proc_table+0x10c>
                case RUNNABLE: status = "RUNNABLE"; break;
    80206244:	0001f797          	auipc	a5,0x1f
    80206248:	6ec78793          	addi	a5,a5,1772 # 80225930 <user_test_table+0x3d0>
    8020624c:	fef43023          	sd	a5,-32(s0)
    80206250:	a035                	j	8020627c <print_proc_table+0x10c>
                case RUNNING:  status = "RUNNING"; break;
    80206252:	0001f797          	auipc	a5,0x1f
    80206256:	6ee78793          	addi	a5,a5,1774 # 80225940 <user_test_table+0x3e0>
    8020625a:	fef43023          	sd	a5,-32(s0)
    8020625e:	a839                	j	8020627c <print_proc_table+0x10c>
                case ZOMBIE:   status = "ZOMBIE"; break;
    80206260:	0001f797          	auipc	a5,0x1f
    80206264:	6e878793          	addi	a5,a5,1768 # 80225948 <user_test_table+0x3e8>
    80206268:	fef43023          	sd	a5,-32(s0)
    8020626c:	a801                	j	8020627c <print_proc_table+0x10c>
                default:       status = "UNKNOWN"; break;
    8020626e:	0001f797          	auipc	a5,0x1f
    80206272:	6e278793          	addi	a5,a5,1762 # 80225950 <user_test_table+0x3f0>
    80206276:	fef43023          	sd	a5,-32(s0)
    8020627a:	0001                	nop
            int ppid = p->parent ? p->parent->pid : -1;
    8020627c:	fd843783          	ld	a5,-40(s0)
    80206280:	6fdc                	ld	a5,152(a5)
    80206282:	c791                	beqz	a5,8020628e <print_proc_table+0x11e>
    80206284:	fd843783          	ld	a5,-40(s0)
    80206288:	6fdc                	ld	a5,152(a5)
    8020628a:	43dc                	lw	a5,4(a5)
    8020628c:	a011                	j	80206290 <print_proc_table+0x120>
    8020628e:	57fd                	li	a5,-1
    80206290:	fcf42623          	sw	a5,-52(s0)
            unsigned long func_addr = p->trapframe ? p->trapframe->epc : 0;
    80206294:	fd843783          	ld	a5,-40(s0)
    80206298:	63fc                	ld	a5,192(a5)
    8020629a:	c791                	beqz	a5,802062a6 <print_proc_table+0x136>
    8020629c:	fd843783          	ld	a5,-40(s0)
    802062a0:	63fc                	ld	a5,192(a5)
    802062a2:	7f9c                	ld	a5,56(a5)
    802062a4:	a011                	j	802062a8 <print_proc_table+0x138>
    802062a6:	4781                	li	a5,0
    802062a8:	fcf43023          	sd	a5,-64(s0)
            unsigned long stack_addr = p->kstack;
    802062ac:	fd843783          	ld	a5,-40(s0)
    802062b0:	679c                	ld	a5,8(a5)
    802062b2:	faf43c23          	sd	a5,-72(s0)
            printf("%2d  %3s %8s %4d 0x%012lx 0x%012lx\n",
    802062b6:	fd843783          	ld	a5,-40(s0)
    802062ba:	43cc                	lw	a1,4(a5)
    802062bc:	fcc42703          	lw	a4,-52(s0)
    802062c0:	fb843803          	ld	a6,-72(s0)
    802062c4:	fc043783          	ld	a5,-64(s0)
    802062c8:	fe043683          	ld	a3,-32(s0)
    802062cc:	fd043603          	ld	a2,-48(s0)
    802062d0:	0001f517          	auipc	a0,0x1f
    802062d4:	68850513          	addi	a0,a0,1672 # 80225958 <user_test_table+0x3f8>
    802062d8:	ffffb097          	auipc	ra,0xffffb
    802062dc:	fac080e7          	jalr	-84(ra) # 80201284 <printf>
    for(int i = 0; i < PROC; i++) {
    802062e0:	fe842783          	lw	a5,-24(s0)
    802062e4:	2785                	addiw	a5,a5,1
    802062e6:	fef42423          	sw	a5,-24(s0)
    802062ea:	fe842783          	lw	a5,-24(s0)
    802062ee:	0007871b          	sext.w	a4,a5
    802062f2:	47fd                	li	a5,31
    802062f4:	eae7d7e3          	bge	a5,a4,802061a2 <print_proc_table+0x32>
    printf("----------------------------------------------------------\n");
    802062f8:	0001f517          	auipc	a0,0x1f
    802062fc:	5d050513          	addi	a0,a0,1488 # 802258c8 <user_test_table+0x368>
    80206300:	ffffb097          	auipc	ra,0xffffb
    80206304:	f84080e7          	jalr	-124(ra) # 80201284 <printf>
    printf("%d active processes\n", count);
    80206308:	fec42783          	lw	a5,-20(s0)
    8020630c:	85be                	mv	a1,a5
    8020630e:	0001f517          	auipc	a0,0x1f
    80206312:	67250513          	addi	a0,a0,1650 # 80225980 <user_test_table+0x420>
    80206316:	ffffb097          	auipc	ra,0xffffb
    8020631a:	f6e080e7          	jalr	-146(ra) # 80201284 <printf>
}
    8020631e:	0001                	nop
    80206320:	60a6                	ld	ra,72(sp)
    80206322:	6406                	ld	s0,64(sp)
    80206324:	6161                	addi	sp,sp,80
    80206326:	8082                	ret

0000000080206328 <get_proc>:
struct proc* get_proc(int pid){
    80206328:	7179                	addi	sp,sp,-48
    8020632a:	f422                	sd	s0,40(sp)
    8020632c:	1800                	addi	s0,sp,48
    8020632e:	87aa                	mv	a5,a0
    80206330:	fcf42e23          	sw	a5,-36(s0)
    if (pid < 0 || pid >= PROC) {
    80206334:	fdc42783          	lw	a5,-36(s0)
    80206338:	2781                	sext.w	a5,a5
    8020633a:	0007c963          	bltz	a5,8020634c <get_proc+0x24>
    8020633e:	fdc42783          	lw	a5,-36(s0)
    80206342:	0007871b          	sext.w	a4,a5
    80206346:	47fd                	li	a5,31
    80206348:	00e7d463          	bge	a5,a4,80206350 <get_proc+0x28>
        return 0;
    8020634c:	4781                	li	a5,0
    8020634e:	a899                	j	802063a4 <get_proc+0x7c>
    for (int i = 0; i < PROC; i++) {
    80206350:	fe042623          	sw	zero,-20(s0)
    80206354:	a081                	j	80206394 <get_proc+0x6c>
        struct proc *p = proc_table[i];
    80206356:	00037717          	auipc	a4,0x37
    8020635a:	13270713          	addi	a4,a4,306 # 8023d488 <proc_table>
    8020635e:	fec42783          	lw	a5,-20(s0)
    80206362:	078e                	slli	a5,a5,0x3
    80206364:	97ba                	add	a5,a5,a4
    80206366:	639c                	ld	a5,0(a5)
    80206368:	fef43023          	sd	a5,-32(s0)
        if (p->state != UNUSED && p->pid == pid) {
    8020636c:	fe043783          	ld	a5,-32(s0)
    80206370:	439c                	lw	a5,0(a5)
    80206372:	cf81                	beqz	a5,8020638a <get_proc+0x62>
    80206374:	fe043783          	ld	a5,-32(s0)
    80206378:	43d8                	lw	a4,4(a5)
    8020637a:	fdc42783          	lw	a5,-36(s0)
    8020637e:	2781                	sext.w	a5,a5
    80206380:	00e79563          	bne	a5,a4,8020638a <get_proc+0x62>
            return p;
    80206384:	fe043783          	ld	a5,-32(s0)
    80206388:	a831                	j	802063a4 <get_proc+0x7c>
    for (int i = 0; i < PROC; i++) {
    8020638a:	fec42783          	lw	a5,-20(s0)
    8020638e:	2785                	addiw	a5,a5,1
    80206390:	fef42623          	sw	a5,-20(s0)
    80206394:	fec42783          	lw	a5,-20(s0)
    80206398:	0007871b          	sext.w	a4,a5
    8020639c:	47fd                	li	a5,31
    8020639e:	fae7dce3          	bge	a5,a4,80206356 <get_proc+0x2e>
    return 0;
    802063a2:	4781                	li	a5,0
    802063a4:	853e                	mv	a0,a5
    802063a6:	7422                	ld	s0,40(sp)
    802063a8:	6145                	addi	sp,sp,48
    802063aa:	8082                	ret

00000000802063ac <strlen>:
#include "defs.h"

// 计算字符串长度
int strlen(const char *s) {
    802063ac:	7179                	addi	sp,sp,-48
    802063ae:	f422                	sd	s0,40(sp)
    802063b0:	1800                	addi	s0,sp,48
    802063b2:	fca43c23          	sd	a0,-40(s0)
    int n;
    for(n = 0; s[n]; n++)
    802063b6:	fe042623          	sw	zero,-20(s0)
    802063ba:	a031                	j	802063c6 <strlen+0x1a>
    802063bc:	fec42783          	lw	a5,-20(s0)
    802063c0:	2785                	addiw	a5,a5,1
    802063c2:	fef42623          	sw	a5,-20(s0)
    802063c6:	fec42783          	lw	a5,-20(s0)
    802063ca:	fd843703          	ld	a4,-40(s0)
    802063ce:	97ba                	add	a5,a5,a4
    802063d0:	0007c783          	lbu	a5,0(a5)
    802063d4:	f7e5                	bnez	a5,802063bc <strlen+0x10>
        ;
    return n;
    802063d6:	fec42783          	lw	a5,-20(s0)
}
    802063da:	853e                	mv	a0,a5
    802063dc:	7422                	ld	s0,40(sp)
    802063de:	6145                	addi	sp,sp,48
    802063e0:	8082                	ret

00000000802063e2 <strcmp>:

// 字符串比较
int strcmp(const char *p, const char *q) {
    802063e2:	1101                	addi	sp,sp,-32
    802063e4:	ec22                	sd	s0,24(sp)
    802063e6:	1000                	addi	s0,sp,32
    802063e8:	fea43423          	sd	a0,-24(s0)
    802063ec:	feb43023          	sd	a1,-32(s0)
    while(*p && *p == *q)
    802063f0:	a819                	j	80206406 <strcmp+0x24>
        p++, q++;
    802063f2:	fe843783          	ld	a5,-24(s0)
    802063f6:	0785                	addi	a5,a5,1
    802063f8:	fef43423          	sd	a5,-24(s0)
    802063fc:	fe043783          	ld	a5,-32(s0)
    80206400:	0785                	addi	a5,a5,1
    80206402:	fef43023          	sd	a5,-32(s0)
    while(*p && *p == *q)
    80206406:	fe843783          	ld	a5,-24(s0)
    8020640a:	0007c783          	lbu	a5,0(a5)
    8020640e:	cb99                	beqz	a5,80206424 <strcmp+0x42>
    80206410:	fe843783          	ld	a5,-24(s0)
    80206414:	0007c703          	lbu	a4,0(a5)
    80206418:	fe043783          	ld	a5,-32(s0)
    8020641c:	0007c783          	lbu	a5,0(a5)
    80206420:	fcf709e3          	beq	a4,a5,802063f2 <strcmp+0x10>
    return (uchar)*p - (uchar)*q;
    80206424:	fe843783          	ld	a5,-24(s0)
    80206428:	0007c783          	lbu	a5,0(a5)
    8020642c:	0007871b          	sext.w	a4,a5
    80206430:	fe043783          	ld	a5,-32(s0)
    80206434:	0007c783          	lbu	a5,0(a5)
    80206438:	2781                	sext.w	a5,a5
    8020643a:	40f707bb          	subw	a5,a4,a5
    8020643e:	2781                	sext.w	a5,a5
}
    80206440:	853e                	mv	a0,a5
    80206442:	6462                	ld	s0,24(sp)
    80206444:	6105                	addi	sp,sp,32
    80206446:	8082                	ret

0000000080206448 <strcpy>:

// 字符串复制
char* strcpy(char *s, const char *t) {
    80206448:	7179                	addi	sp,sp,-48
    8020644a:	f422                	sd	s0,40(sp)
    8020644c:	1800                	addi	s0,sp,48
    8020644e:	fca43c23          	sd	a0,-40(s0)
    80206452:	fcb43823          	sd	a1,-48(s0)
    char *os;
    
    os = s;
    80206456:	fd843783          	ld	a5,-40(s0)
    8020645a:	fef43423          	sd	a5,-24(s0)
    while((*s++ = *t++) != 0)
    8020645e:	0001                	nop
    80206460:	fd043703          	ld	a4,-48(s0)
    80206464:	00170793          	addi	a5,a4,1
    80206468:	fcf43823          	sd	a5,-48(s0)
    8020646c:	fd843783          	ld	a5,-40(s0)
    80206470:	00178693          	addi	a3,a5,1
    80206474:	fcd43c23          	sd	a3,-40(s0)
    80206478:	00074703          	lbu	a4,0(a4)
    8020647c:	00e78023          	sb	a4,0(a5)
    80206480:	0007c783          	lbu	a5,0(a5)
    80206484:	fff1                	bnez	a5,80206460 <strcpy+0x18>
        ;
    return os;
    80206486:	fe843783          	ld	a5,-24(s0)
}
    8020648a:	853e                	mv	a0,a5
    8020648c:	7422                	ld	s0,40(sp)
    8020648e:	6145                	addi	sp,sp,48
    80206490:	8082                	ret

0000000080206492 <safestrcpy>:

// 安全的字符串复制（指定最大长度）
char* safestrcpy(char *s, const char *t, int n) {
    80206492:	7139                	addi	sp,sp,-64
    80206494:	fc22                	sd	s0,56(sp)
    80206496:	0080                	addi	s0,sp,64
    80206498:	fca43c23          	sd	a0,-40(s0)
    8020649c:	fcb43823          	sd	a1,-48(s0)
    802064a0:	87b2                	mv	a5,a2
    802064a2:	fcf42623          	sw	a5,-52(s0)
    char *os;
    
    os = s;
    802064a6:	fd843783          	ld	a5,-40(s0)
    802064aa:	fef43423          	sd	a5,-24(s0)
    if(n <= 0)
    802064ae:	fcc42783          	lw	a5,-52(s0)
    802064b2:	2781                	sext.w	a5,a5
    802064b4:	00f04563          	bgtz	a5,802064be <safestrcpy+0x2c>
        return os;
    802064b8:	fe843783          	ld	a5,-24(s0)
    802064bc:	a0a9                	j	80206506 <safestrcpy+0x74>
    while(--n > 0 && (*s++ = *t++) != 0)
    802064be:	0001                	nop
    802064c0:	fcc42783          	lw	a5,-52(s0)
    802064c4:	37fd                	addiw	a5,a5,-1
    802064c6:	fcf42623          	sw	a5,-52(s0)
    802064ca:	fcc42783          	lw	a5,-52(s0)
    802064ce:	2781                	sext.w	a5,a5
    802064d0:	02f05563          	blez	a5,802064fa <safestrcpy+0x68>
    802064d4:	fd043703          	ld	a4,-48(s0)
    802064d8:	00170793          	addi	a5,a4,1
    802064dc:	fcf43823          	sd	a5,-48(s0)
    802064e0:	fd843783          	ld	a5,-40(s0)
    802064e4:	00178693          	addi	a3,a5,1
    802064e8:	fcd43c23          	sd	a3,-40(s0)
    802064ec:	00074703          	lbu	a4,0(a4)
    802064f0:	00e78023          	sb	a4,0(a5)
    802064f4:	0007c783          	lbu	a5,0(a5)
    802064f8:	f7e1                	bnez	a5,802064c0 <safestrcpy+0x2e>
        ;
    *s = 0;
    802064fa:	fd843783          	ld	a5,-40(s0)
    802064fe:	00078023          	sb	zero,0(a5)
    return os;
    80206502:	fe843783          	ld	a5,-24(s0)
}
    80206506:	853e                	mv	a0,a5
    80206508:	7462                	ld	s0,56(sp)
    8020650a:	6121                	addi	sp,sp,64
    8020650c:	8082                	ret

000000008020650e <atoi>:
// 将字符串转换为整数
int atoi(const char *s) {
    8020650e:	7179                	addi	sp,sp,-48
    80206510:	f422                	sd	s0,40(sp)
    80206512:	1800                	addi	s0,sp,48
    80206514:	fca43c23          	sd	a0,-40(s0)
    int n = 0;
    80206518:	fe042623          	sw	zero,-20(s0)
    int sign = 1;  // 正负号
    8020651c:	4785                	li	a5,1
    8020651e:	fef42423          	sw	a5,-24(s0)

    // 跳过空白字符
    while (*s == ' ' || *s == '\t') {
    80206522:	a031                	j	8020652e <atoi+0x20>
        s++;
    80206524:	fd843783          	ld	a5,-40(s0)
    80206528:	0785                	addi	a5,a5,1
    8020652a:	fcf43c23          	sd	a5,-40(s0)
    while (*s == ' ' || *s == '\t') {
    8020652e:	fd843783          	ld	a5,-40(s0)
    80206532:	0007c783          	lbu	a5,0(a5)
    80206536:	873e                	mv	a4,a5
    80206538:	02000793          	li	a5,32
    8020653c:	fef704e3          	beq	a4,a5,80206524 <atoi+0x16>
    80206540:	fd843783          	ld	a5,-40(s0)
    80206544:	0007c783          	lbu	a5,0(a5)
    80206548:	873e                	mv	a4,a5
    8020654a:	47a5                	li	a5,9
    8020654c:	fcf70ce3          	beq	a4,a5,80206524 <atoi+0x16>
    }

    // 处理符号
    if (*s == '-') {
    80206550:	fd843783          	ld	a5,-40(s0)
    80206554:	0007c783          	lbu	a5,0(a5)
    80206558:	873e                	mv	a4,a5
    8020655a:	02d00793          	li	a5,45
    8020655e:	00f71b63          	bne	a4,a5,80206574 <atoi+0x66>
        sign = -1;
    80206562:	57fd                	li	a5,-1
    80206564:	fef42423          	sw	a5,-24(s0)
        s++;
    80206568:	fd843783          	ld	a5,-40(s0)
    8020656c:	0785                	addi	a5,a5,1
    8020656e:	fcf43c23          	sd	a5,-40(s0)
    80206572:	a899                	j	802065c8 <atoi+0xba>
    } else if (*s == '+') {
    80206574:	fd843783          	ld	a5,-40(s0)
    80206578:	0007c783          	lbu	a5,0(a5)
    8020657c:	873e                	mv	a4,a5
    8020657e:	02b00793          	li	a5,43
    80206582:	04f71363          	bne	a4,a5,802065c8 <atoi+0xba>
        s++;
    80206586:	fd843783          	ld	a5,-40(s0)
    8020658a:	0785                	addi	a5,a5,1
    8020658c:	fcf43c23          	sd	a5,-40(s0)
    }

    // 转换数字字符
    while (*s >= '0' && *s <= '9') {
    80206590:	a825                	j	802065c8 <atoi+0xba>
        n = n * 10 + (*s - '0');
    80206592:	fec42783          	lw	a5,-20(s0)
    80206596:	873e                	mv	a4,a5
    80206598:	87ba                	mv	a5,a4
    8020659a:	0027979b          	slliw	a5,a5,0x2
    8020659e:	9fb9                	addw	a5,a5,a4
    802065a0:	0017979b          	slliw	a5,a5,0x1
    802065a4:	0007871b          	sext.w	a4,a5
    802065a8:	fd843783          	ld	a5,-40(s0)
    802065ac:	0007c783          	lbu	a5,0(a5)
    802065b0:	2781                	sext.w	a5,a5
    802065b2:	fd07879b          	addiw	a5,a5,-48
    802065b6:	2781                	sext.w	a5,a5
    802065b8:	9fb9                	addw	a5,a5,a4
    802065ba:	fef42623          	sw	a5,-20(s0)
        s++;
    802065be:	fd843783          	ld	a5,-40(s0)
    802065c2:	0785                	addi	a5,a5,1
    802065c4:	fcf43c23          	sd	a5,-40(s0)
    while (*s >= '0' && *s <= '9') {
    802065c8:	fd843783          	ld	a5,-40(s0)
    802065cc:	0007c783          	lbu	a5,0(a5)
    802065d0:	873e                	mv	a4,a5
    802065d2:	02f00793          	li	a5,47
    802065d6:	00e7fb63          	bgeu	a5,a4,802065ec <atoi+0xde>
    802065da:	fd843783          	ld	a5,-40(s0)
    802065de:	0007c783          	lbu	a5,0(a5)
    802065e2:	873e                	mv	a4,a5
    802065e4:	03900793          	li	a5,57
    802065e8:	fae7f5e3          	bgeu	a5,a4,80206592 <atoi+0x84>
    }

    return sign * n;
    802065ec:	fe842783          	lw	a5,-24(s0)
    802065f0:	873e                	mv	a4,a5
    802065f2:	fec42783          	lw	a5,-20(s0)
    802065f6:	02f707bb          	mulw	a5,a4,a5
    802065fa:	2781                	sext.w	a5,a5
}
    802065fc:	853e                	mv	a0,a5
    802065fe:	7422                	ld	s0,40(sp)
    80206600:	6145                	addi	sp,sp,48
    80206602:	8082                	ret

0000000080206604 <strncmp>:
// 比较字符串前 n 个字符
int strncmp(const char *s, const char *t, int n) {
    80206604:	7179                	addi	sp,sp,-48
    80206606:	f422                	sd	s0,40(sp)
    80206608:	1800                	addi	s0,sp,48
    8020660a:	fea43423          	sd	a0,-24(s0)
    8020660e:	feb43023          	sd	a1,-32(s0)
    80206612:	87b2                	mv	a5,a2
    80206614:	fcf42e23          	sw	a5,-36(s0)
    while(n > 0 && *s && *t) {
    80206618:	a889                	j	8020666a <strncmp+0x66>
        if(*s != *t)
    8020661a:	fe843783          	ld	a5,-24(s0)
    8020661e:	0007c703          	lbu	a4,0(a5)
    80206622:	fe043783          	ld	a5,-32(s0)
    80206626:	0007c783          	lbu	a5,0(a5)
    8020662a:	02f70163          	beq	a4,a5,8020664c <strncmp+0x48>
            return (uchar)*s - (uchar)*t;
    8020662e:	fe843783          	ld	a5,-24(s0)
    80206632:	0007c783          	lbu	a5,0(a5)
    80206636:	0007871b          	sext.w	a4,a5
    8020663a:	fe043783          	ld	a5,-32(s0)
    8020663e:	0007c783          	lbu	a5,0(a5)
    80206642:	2781                	sext.w	a5,a5
    80206644:	40f707bb          	subw	a5,a4,a5
    80206648:	2781                	sext.w	a5,a5
    8020664a:	a09d                	j	802066b0 <strncmp+0xac>
        s++;
    8020664c:	fe843783          	ld	a5,-24(s0)
    80206650:	0785                	addi	a5,a5,1
    80206652:	fef43423          	sd	a5,-24(s0)
        t++;
    80206656:	fe043783          	ld	a5,-32(s0)
    8020665a:	0785                	addi	a5,a5,1
    8020665c:	fef43023          	sd	a5,-32(s0)
        n--;
    80206660:	fdc42783          	lw	a5,-36(s0)
    80206664:	37fd                	addiw	a5,a5,-1
    80206666:	fcf42e23          	sw	a5,-36(s0)
    while(n > 0 && *s && *t) {
    8020666a:	fdc42783          	lw	a5,-36(s0)
    8020666e:	2781                	sext.w	a5,a5
    80206670:	00f05c63          	blez	a5,80206688 <strncmp+0x84>
    80206674:	fe843783          	ld	a5,-24(s0)
    80206678:	0007c783          	lbu	a5,0(a5)
    8020667c:	c791                	beqz	a5,80206688 <strncmp+0x84>
    8020667e:	fe043783          	ld	a5,-32(s0)
    80206682:	0007c783          	lbu	a5,0(a5)
    80206686:	fbd1                	bnez	a5,8020661a <strncmp+0x16>
    }
    if(n == 0)
    80206688:	fdc42783          	lw	a5,-36(s0)
    8020668c:	2781                	sext.w	a5,a5
    8020668e:	e399                	bnez	a5,80206694 <strncmp+0x90>
        return 0;
    80206690:	4781                	li	a5,0
    80206692:	a839                	j	802066b0 <strncmp+0xac>
    return (uchar)*s - (uchar)*t;
    80206694:	fe843783          	ld	a5,-24(s0)
    80206698:	0007c783          	lbu	a5,0(a5)
    8020669c:	0007871b          	sext.w	a4,a5
    802066a0:	fe043783          	ld	a5,-32(s0)
    802066a4:	0007c783          	lbu	a5,0(a5)
    802066a8:	2781                	sext.w	a5,a5
    802066aa:	40f707bb          	subw	a5,a4,a5
    802066ae:	2781                	sext.w	a5,a5
}
    802066b0:	853e                	mv	a0,a5
    802066b2:	7422                	ld	s0,40(sp)
    802066b4:	6145                	addi	sp,sp,48
    802066b6:	8082                	ret

00000000802066b8 <strncpy>:

// 复制字符串前 n 个字符
char *strncpy(char *dst, const char *src, int n) {
    802066b8:	7139                	addi	sp,sp,-64
    802066ba:	fc22                	sd	s0,56(sp)
    802066bc:	0080                	addi	s0,sp,64
    802066be:	fca43c23          	sd	a0,-40(s0)
    802066c2:	fcb43823          	sd	a1,-48(s0)
    802066c6:	87b2                	mv	a5,a2
    802066c8:	fcf42623          	sw	a5,-52(s0)
    char *ret = dst;
    802066cc:	fd843783          	ld	a5,-40(s0)
    802066d0:	fef43423          	sd	a5,-24(s0)
    while(n > 0 && *src) {
    802066d4:	a035                	j	80206700 <strncpy+0x48>
        *dst++ = *src++;
    802066d6:	fd043703          	ld	a4,-48(s0)
    802066da:	00170793          	addi	a5,a4,1
    802066de:	fcf43823          	sd	a5,-48(s0)
    802066e2:	fd843783          	ld	a5,-40(s0)
    802066e6:	00178693          	addi	a3,a5,1
    802066ea:	fcd43c23          	sd	a3,-40(s0)
    802066ee:	00074703          	lbu	a4,0(a4)
    802066f2:	00e78023          	sb	a4,0(a5)
        n--;
    802066f6:	fcc42783          	lw	a5,-52(s0)
    802066fa:	37fd                	addiw	a5,a5,-1
    802066fc:	fcf42623          	sw	a5,-52(s0)
    while(n > 0 && *src) {
    80206700:	fcc42783          	lw	a5,-52(s0)
    80206704:	2781                	sext.w	a5,a5
    80206706:	02f05563          	blez	a5,80206730 <strncpy+0x78>
    8020670a:	fd043783          	ld	a5,-48(s0)
    8020670e:	0007c783          	lbu	a5,0(a5)
    80206712:	f3f1                	bnez	a5,802066d6 <strncpy+0x1e>
    }
    while(n > 0) {
    80206714:	a831                	j	80206730 <strncpy+0x78>
        *dst++ = 0;
    80206716:	fd843783          	ld	a5,-40(s0)
    8020671a:	00178713          	addi	a4,a5,1
    8020671e:	fce43c23          	sd	a4,-40(s0)
    80206722:	00078023          	sb	zero,0(a5)
        n--;
    80206726:	fcc42783          	lw	a5,-52(s0)
    8020672a:	37fd                	addiw	a5,a5,-1
    8020672c:	fcf42623          	sw	a5,-52(s0)
    while(n > 0) {
    80206730:	fcc42783          	lw	a5,-52(s0)
    80206734:	2781                	sext.w	a5,a5
    80206736:	fef040e3          	bgtz	a5,80206716 <strncpy+0x5e>
    }
    return ret;
    8020673a:	fe843783          	ld	a5,-24(s0)
}
    8020673e:	853e                	mv	a0,a5
    80206740:	7462                	ld	s0,56(sp)
    80206742:	6121                	addi	sp,sp,64
    80206744:	8082                	ret

0000000080206746 <strcat>:
// 简单实现 strcat
char* strcat(char *dst, const char *src) {
    80206746:	7179                	addi	sp,sp,-48
    80206748:	f422                	sd	s0,40(sp)
    8020674a:	1800                	addi	s0,sp,48
    8020674c:	fca43c23          	sd	a0,-40(s0)
    80206750:	fcb43823          	sd	a1,-48(s0)
    char *ret = dst;
    80206754:	fd843783          	ld	a5,-40(s0)
    80206758:	fef43423          	sd	a5,-24(s0)
    while(*dst) dst++;
    8020675c:	a031                	j	80206768 <strcat+0x22>
    8020675e:	fd843783          	ld	a5,-40(s0)
    80206762:	0785                	addi	a5,a5,1
    80206764:	fcf43c23          	sd	a5,-40(s0)
    80206768:	fd843783          	ld	a5,-40(s0)
    8020676c:	0007c783          	lbu	a5,0(a5)
    80206770:	f7fd                	bnez	a5,8020675e <strcat+0x18>
    while((*dst++ = *src++));
    80206772:	0001                	nop
    80206774:	fd043703          	ld	a4,-48(s0)
    80206778:	00170793          	addi	a5,a4,1
    8020677c:	fcf43823          	sd	a5,-48(s0)
    80206780:	fd843783          	ld	a5,-40(s0)
    80206784:	00178693          	addi	a3,a5,1
    80206788:	fcd43c23          	sd	a3,-40(s0)
    8020678c:	00074703          	lbu	a4,0(a4)
    80206790:	00e78023          	sb	a4,0(a5)
    80206794:	0007c783          	lbu	a5,0(a5)
    80206798:	fff1                	bnez	a5,80206774 <strcat+0x2e>
    return ret;
    8020679a:	fe843783          	ld	a5,-24(s0)
    8020679e:	853e                	mv	a0,a5
    802067a0:	7422                	ld	s0,40(sp)
    802067a2:	6145                	addi	sp,sp,48
    802067a4:	8082                	ret

00000000802067a6 <assert>:
    802067a6:	1101                	addi	sp,sp,-32
    802067a8:	ec06                	sd	ra,24(sp)
    802067aa:	e822                	sd	s0,16(sp)
    802067ac:	1000                	addi	s0,sp,32
    802067ae:	87aa                	mv	a5,a0
    802067b0:	fef42623          	sw	a5,-20(s0)
    802067b4:	fec42783          	lw	a5,-20(s0)
    802067b8:	2781                	sext.w	a5,a5
    802067ba:	e79d                	bnez	a5,802067e8 <assert+0x42>
    802067bc:	33c00613          	li	a2,828
    802067c0:	00023597          	auipc	a1,0x23
    802067c4:	35058593          	addi	a1,a1,848 # 80229b10 <user_test_table+0x78>
    802067c8:	00023517          	auipc	a0,0x23
    802067cc:	35850513          	addi	a0,a0,856 # 80229b20 <user_test_table+0x88>
    802067d0:	ffffb097          	auipc	ra,0xffffb
    802067d4:	ab4080e7          	jalr	-1356(ra) # 80201284 <printf>
    802067d8:	00023517          	auipc	a0,0x23
    802067dc:	37050513          	addi	a0,a0,880 # 80229b48 <user_test_table+0xb0>
    802067e0:	ffffb097          	auipc	ra,0xffffb
    802067e4:	026080e7          	jalr	38(ra) # 80201806 <panic>
    802067e8:	0001                	nop
    802067ea:	60e2                	ld	ra,24(sp)
    802067ec:	6442                	ld	s0,16(sp)
    802067ee:	6105                	addi	sp,sp,32
    802067f0:	8082                	ret

00000000802067f2 <get_time>:
uint64 get_time(void) {
    802067f2:	1141                	addi	sp,sp,-16
    802067f4:	e406                	sd	ra,8(sp)
    802067f6:	e022                	sd	s0,0(sp)
    802067f8:	0800                	addi	s0,sp,16
    return sbi_get_time();
    802067fa:	ffffd097          	auipc	ra,0xffffd
    802067fe:	e02080e7          	jalr	-510(ra) # 802035fc <sbi_get_time>
    80206802:	87aa                	mv	a5,a0
}
    80206804:	853e                	mv	a0,a5
    80206806:	60a2                	ld	ra,8(sp)
    80206808:	6402                	ld	s0,0(sp)
    8020680a:	0141                	addi	sp,sp,16
    8020680c:	8082                	ret

000000008020680e <test_timer_interrupt>:
void test_timer_interrupt(void) {
    8020680e:	7179                	addi	sp,sp,-48
    80206810:	f406                	sd	ra,40(sp)
    80206812:	f022                	sd	s0,32(sp)
    80206814:	1800                	addi	s0,sp,48
    printf("Testing timer interrupt...\n");
    80206816:	00023517          	auipc	a0,0x23
    8020681a:	33a50513          	addi	a0,a0,826 # 80229b50 <user_test_table+0xb8>
    8020681e:	ffffb097          	auipc	ra,0xffffb
    80206822:	a66080e7          	jalr	-1434(ra) # 80201284 <printf>
    uint64 start_time = get_time();
    80206826:	00000097          	auipc	ra,0x0
    8020682a:	fcc080e7          	jalr	-52(ra) # 802067f2 <get_time>
    8020682e:	fea43023          	sd	a0,-32(s0)
    int interrupt_count = 0;
    80206832:	fc042a23          	sw	zero,-44(s0)
    int last_count = 0;
    80206836:	fe042623          	sw	zero,-20(s0)
    interrupt_test_flag = &interrupt_count;
    8020683a:	00037797          	auipc	a5,0x37
    8020683e:	89e78793          	addi	a5,a5,-1890 # 8023d0d8 <interrupt_test_flag>
    80206842:	fd440713          	addi	a4,s0,-44
    80206846:	e398                	sd	a4,0(a5)
    while (interrupt_count < 5) {
    80206848:	a03d                	j	80206876 <test_timer_interrupt+0x68>
        if (last_count != interrupt_count) {
    8020684a:	fd442703          	lw	a4,-44(s0)
    8020684e:	fec42783          	lw	a5,-20(s0)
    80206852:	2781                	sext.w	a5,a5
    80206854:	02e78163          	beq	a5,a4,80206876 <test_timer_interrupt+0x68>
            last_count = interrupt_count;
    80206858:	fd442783          	lw	a5,-44(s0)
    8020685c:	fef42623          	sw	a5,-20(s0)
            printf("Received interrupt %d\n", interrupt_count);
    80206860:	fd442783          	lw	a5,-44(s0)
    80206864:	85be                	mv	a1,a5
    80206866:	00023517          	auipc	a0,0x23
    8020686a:	30a50513          	addi	a0,a0,778 # 80229b70 <user_test_table+0xd8>
    8020686e:	ffffb097          	auipc	ra,0xffffb
    80206872:	a16080e7          	jalr	-1514(ra) # 80201284 <printf>
    while (interrupt_count < 5) {
    80206876:	fd442783          	lw	a5,-44(s0)
    8020687a:	873e                	mv	a4,a5
    8020687c:	4791                	li	a5,4
    8020687e:	fce7d6e3          	bge	a5,a4,8020684a <test_timer_interrupt+0x3c>
    interrupt_test_flag = 0;
    80206882:	00037797          	auipc	a5,0x37
    80206886:	85678793          	addi	a5,a5,-1962 # 8023d0d8 <interrupt_test_flag>
    8020688a:	0007b023          	sd	zero,0(a5)
    uint64 end_time = get_time();
    8020688e:	00000097          	auipc	ra,0x0
    80206892:	f64080e7          	jalr	-156(ra) # 802067f2 <get_time>
    80206896:	fca43c23          	sd	a0,-40(s0)
    printf("Timer test completed: %d interrupts in %lu cycles\n",
    8020689a:	fd442683          	lw	a3,-44(s0)
    8020689e:	fd843703          	ld	a4,-40(s0)
    802068a2:	fe043783          	ld	a5,-32(s0)
    802068a6:	40f707b3          	sub	a5,a4,a5
    802068aa:	863e                	mv	a2,a5
    802068ac:	85b6                	mv	a1,a3
    802068ae:	00023517          	auipc	a0,0x23
    802068b2:	2da50513          	addi	a0,a0,730 # 80229b88 <user_test_table+0xf0>
    802068b6:	ffffb097          	auipc	ra,0xffffb
    802068ba:	9ce080e7          	jalr	-1586(ra) # 80201284 <printf>
}
    802068be:	0001                	nop
    802068c0:	70a2                	ld	ra,40(sp)
    802068c2:	7402                	ld	s0,32(sp)
    802068c4:	6145                	addi	sp,sp,48
    802068c6:	8082                	ret

00000000802068c8 <test_exception>:
void test_exception(void) {
    802068c8:	711d                	addi	sp,sp,-96
    802068ca:	ec86                	sd	ra,88(sp)
    802068cc:	e8a2                	sd	s0,80(sp)
    802068ce:	1080                	addi	s0,sp,96
    printf("\n===== 开始全面异常处理测试 =====\n\n");
    802068d0:	00023517          	auipc	a0,0x23
    802068d4:	2f050513          	addi	a0,a0,752 # 80229bc0 <user_test_table+0x128>
    802068d8:	ffffb097          	auipc	ra,0xffffb
    802068dc:	9ac080e7          	jalr	-1620(ra) # 80201284 <printf>
    printf("1. 测试非法指令异常...\n");
    802068e0:	00023517          	auipc	a0,0x23
    802068e4:	31050513          	addi	a0,a0,784 # 80229bf0 <user_test_table+0x158>
    802068e8:	ffffb097          	auipc	ra,0xffffb
    802068ec:	99c080e7          	jalr	-1636(ra) # 80201284 <printf>
    802068f0:	ffffffff          	.word	0xffffffff
    printf("✓ 识别到指令异常并尝试忽略\n\n");
    802068f4:	00023517          	auipc	a0,0x23
    802068f8:	31c50513          	addi	a0,a0,796 # 80229c10 <user_test_table+0x178>
    802068fc:	ffffb097          	auipc	ra,0xffffb
    80206900:	988080e7          	jalr	-1656(ra) # 80201284 <printf>
    printf("2. 测试存储页故障异常...\n");
    80206904:	00023517          	auipc	a0,0x23
    80206908:	33c50513          	addi	a0,a0,828 # 80229c40 <user_test_table+0x1a8>
    8020690c:	ffffb097          	auipc	ra,0xffffb
    80206910:	978080e7          	jalr	-1672(ra) # 80201284 <printf>
    volatile uint64 *invalid_ptr = 0;
    80206914:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    80206918:	47a5                	li	a5,9
    8020691a:	07f2                	slli	a5,a5,0x1c
    8020691c:	fef43023          	sd	a5,-32(s0)
    80206920:	a835                	j	8020695c <test_exception+0x94>
        if (check_is_mapped(addr) == 0) {
    80206922:	fe043503          	ld	a0,-32(s0)
    80206926:	ffffc097          	auipc	ra,0xffffc
    8020692a:	7ee080e7          	jalr	2030(ra) # 80203114 <check_is_mapped>
    8020692e:	87aa                	mv	a5,a0
    80206930:	e385                	bnez	a5,80206950 <test_exception+0x88>
            invalid_ptr = (uint64*)addr;
    80206932:	fe043783          	ld	a5,-32(s0)
    80206936:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    8020693a:	fe043583          	ld	a1,-32(s0)
    8020693e:	00023517          	auipc	a0,0x23
    80206942:	32a50513          	addi	a0,a0,810 # 80229c68 <user_test_table+0x1d0>
    80206946:	ffffb097          	auipc	ra,0xffffb
    8020694a:	93e080e7          	jalr	-1730(ra) # 80201284 <printf>
            break;
    8020694e:	a829                	j	80206968 <test_exception+0xa0>
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    80206950:	fe043703          	ld	a4,-32(s0)
    80206954:	6785                	lui	a5,0x1
    80206956:	97ba                	add	a5,a5,a4
    80206958:	fef43023          	sd	a5,-32(s0)
    8020695c:	fe043703          	ld	a4,-32(s0)
    80206960:	47cd                	li	a5,19
    80206962:	07ee                	slli	a5,a5,0x1b
    80206964:	faf76fe3          	bltu	a4,a5,80206922 <test_exception+0x5a>
    if (invalid_ptr != 0) {
    80206968:	fe843783          	ld	a5,-24(s0)
    8020696c:	cb95                	beqz	a5,802069a0 <test_exception+0xd8>
        printf("尝试写入未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    8020696e:	fe843783          	ld	a5,-24(s0)
    80206972:	85be                	mv	a1,a5
    80206974:	00023517          	auipc	a0,0x23
    80206978:	31450513          	addi	a0,a0,788 # 80229c88 <user_test_table+0x1f0>
    8020697c:	ffffb097          	auipc	ra,0xffffb
    80206980:	908080e7          	jalr	-1784(ra) # 80201284 <printf>
        *invalid_ptr = 42;  // 触发存储页故障
    80206984:	fe843783          	ld	a5,-24(s0)
    80206988:	02a00713          	li	a4,42
    8020698c:	e398                	sd	a4,0(a5)
        printf("✓ 存储页故障异常处理成功\n\n");
    8020698e:	00023517          	auipc	a0,0x23
    80206992:	32a50513          	addi	a0,a0,810 # 80229cb8 <user_test_table+0x220>
    80206996:	ffffb097          	auipc	ra,0xffffb
    8020699a:	8ee080e7          	jalr	-1810(ra) # 80201284 <printf>
    8020699e:	a809                	j	802069b0 <test_exception+0xe8>
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    802069a0:	00023517          	auipc	a0,0x23
    802069a4:	34050513          	addi	a0,a0,832 # 80229ce0 <user_test_table+0x248>
    802069a8:	ffffb097          	auipc	ra,0xffffb
    802069ac:	8dc080e7          	jalr	-1828(ra) # 80201284 <printf>
    printf("3. 测试加载页故障异常...\n");
    802069b0:	00023517          	auipc	a0,0x23
    802069b4:	36850513          	addi	a0,a0,872 # 80229d18 <user_test_table+0x280>
    802069b8:	ffffb097          	auipc	ra,0xffffb
    802069bc:	8cc080e7          	jalr	-1844(ra) # 80201284 <printf>
    invalid_ptr = 0;
    802069c0:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    802069c4:	4795                	li	a5,5
    802069c6:	07f6                	slli	a5,a5,0x1d
    802069c8:	fcf43c23          	sd	a5,-40(s0)
    802069cc:	a835                	j	80206a08 <test_exception+0x140>
        if (check_is_mapped(addr) == 0) {
    802069ce:	fd843503          	ld	a0,-40(s0)
    802069d2:	ffffc097          	auipc	ra,0xffffc
    802069d6:	742080e7          	jalr	1858(ra) # 80203114 <check_is_mapped>
    802069da:	87aa                	mv	a5,a0
    802069dc:	e385                	bnez	a5,802069fc <test_exception+0x134>
            invalid_ptr = (uint64*)addr;
    802069de:	fd843783          	ld	a5,-40(s0)
    802069e2:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    802069e6:	fd843583          	ld	a1,-40(s0)
    802069ea:	00023517          	auipc	a0,0x23
    802069ee:	27e50513          	addi	a0,a0,638 # 80229c68 <user_test_table+0x1d0>
    802069f2:	ffffb097          	auipc	ra,0xffffb
    802069f6:	892080e7          	jalr	-1902(ra) # 80201284 <printf>
            break;
    802069fa:	a829                	j	80206a14 <test_exception+0x14c>
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    802069fc:	fd843703          	ld	a4,-40(s0)
    80206a00:	6785                	lui	a5,0x1
    80206a02:	97ba                	add	a5,a5,a4
    80206a04:	fcf43c23          	sd	a5,-40(s0)
    80206a08:	fd843703          	ld	a4,-40(s0)
    80206a0c:	47d5                	li	a5,21
    80206a0e:	07ee                	slli	a5,a5,0x1b
    80206a10:	faf76fe3          	bltu	a4,a5,802069ce <test_exception+0x106>
    if (invalid_ptr != 0) {
    80206a14:	fe843783          	ld	a5,-24(s0)
    80206a18:	c7a9                	beqz	a5,80206a62 <test_exception+0x19a>
        printf("尝试读取未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    80206a1a:	fe843783          	ld	a5,-24(s0)
    80206a1e:	85be                	mv	a1,a5
    80206a20:	00023517          	auipc	a0,0x23
    80206a24:	32050513          	addi	a0,a0,800 # 80229d40 <user_test_table+0x2a8>
    80206a28:	ffffb097          	auipc	ra,0xffffb
    80206a2c:	85c080e7          	jalr	-1956(ra) # 80201284 <printf>
        volatile uint64 value = *invalid_ptr;  // 触发加载页故障
    80206a30:	fe843783          	ld	a5,-24(s0)
    80206a34:	639c                	ld	a5,0(a5)
    80206a36:	faf43023          	sd	a5,-96(s0)
        printf("读取的值: %lu\n", value);  // 除非故障被处理
    80206a3a:	fa043783          	ld	a5,-96(s0)
    80206a3e:	85be                	mv	a1,a5
    80206a40:	00023517          	auipc	a0,0x23
    80206a44:	33050513          	addi	a0,a0,816 # 80229d70 <user_test_table+0x2d8>
    80206a48:	ffffb097          	auipc	ra,0xffffb
    80206a4c:	83c080e7          	jalr	-1988(ra) # 80201284 <printf>
        printf("✓ 加载页故障异常处理成功\n\n");
    80206a50:	00023517          	auipc	a0,0x23
    80206a54:	33850513          	addi	a0,a0,824 # 80229d88 <user_test_table+0x2f0>
    80206a58:	ffffb097          	auipc	ra,0xffffb
    80206a5c:	82c080e7          	jalr	-2004(ra) # 80201284 <printf>
    80206a60:	a809                	j	80206a72 <test_exception+0x1aa>
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    80206a62:	00023517          	auipc	a0,0x23
    80206a66:	27e50513          	addi	a0,a0,638 # 80229ce0 <user_test_table+0x248>
    80206a6a:	ffffb097          	auipc	ra,0xffffb
    80206a6e:	81a080e7          	jalr	-2022(ra) # 80201284 <printf>
    printf("4. 测试存储地址未对齐异常...\n");
    80206a72:	00023517          	auipc	a0,0x23
    80206a76:	33e50513          	addi	a0,a0,830 # 80229db0 <user_test_table+0x318>
    80206a7a:	ffffb097          	auipc	ra,0xffffb
    80206a7e:	80a080e7          	jalr	-2038(ra) # 80201284 <printf>
    uint64 aligned_addr = (uint64)alloc_page();
    80206a82:	ffffd097          	auipc	ra,0xffffd
    80206a86:	8da080e7          	jalr	-1830(ra) # 8020335c <alloc_page>
    80206a8a:	87aa                	mv	a5,a0
    80206a8c:	fcf43823          	sd	a5,-48(s0)
    if (aligned_addr != 0) {
    80206a90:	fd043783          	ld	a5,-48(s0)
    80206a94:	c3a1                	beqz	a5,80206ad4 <test_exception+0x20c>
        uint64 misaligned_addr = aligned_addr + 1;  // 制造未对齐地址
    80206a96:	fd043783          	ld	a5,-48(s0)
    80206a9a:	0785                	addi	a5,a5,1 # 1001 <_entry-0x801fefff>
    80206a9c:	fcf43423          	sd	a5,-56(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    80206aa0:	fc843583          	ld	a1,-56(s0)
    80206aa4:	00023517          	auipc	a0,0x23
    80206aa8:	33c50513          	addi	a0,a0,828 # 80229de0 <user_test_table+0x348>
    80206aac:	ffffa097          	auipc	ra,0xffffa
    80206ab0:	7d8080e7          	jalr	2008(ra) # 80201284 <printf>
        asm volatile (
    80206ab4:	deadc7b7          	lui	a5,0xdeadc
    80206ab8:	eef7879b          	addiw	a5,a5,-273 # ffffffffdeadbeef <_bss_end+0xffffffff5e8935bf>
    80206abc:	fc843703          	ld	a4,-56(s0)
    80206ac0:	e31c                	sd	a5,0(a4)
        printf("✓ 存储地址未对齐异常处理成功\n\n");
    80206ac2:	00023517          	auipc	a0,0x23
    80206ac6:	33e50513          	addi	a0,a0,830 # 80229e00 <user_test_table+0x368>
    80206aca:	ffffa097          	auipc	ra,0xffffa
    80206ace:	7ba080e7          	jalr	1978(ra) # 80201284 <printf>
    80206ad2:	a809                	j	80206ae4 <test_exception+0x21c>
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    80206ad4:	00023517          	auipc	a0,0x23
    80206ad8:	35c50513          	addi	a0,a0,860 # 80229e30 <user_test_table+0x398>
    80206adc:	ffffa097          	auipc	ra,0xffffa
    80206ae0:	7a8080e7          	jalr	1960(ra) # 80201284 <printf>
    printf("5. 测试加载地址未对齐异常...\n");
    80206ae4:	00023517          	auipc	a0,0x23
    80206ae8:	38c50513          	addi	a0,a0,908 # 80229e70 <user_test_table+0x3d8>
    80206aec:	ffffa097          	auipc	ra,0xffffa
    80206af0:	798080e7          	jalr	1944(ra) # 80201284 <printf>
    if (aligned_addr != 0) {
    80206af4:	fd043783          	ld	a5,-48(s0)
    80206af8:	cbb1                	beqz	a5,80206b4c <test_exception+0x284>
        uint64 misaligned_addr = aligned_addr + 1;
    80206afa:	fd043783          	ld	a5,-48(s0)
    80206afe:	0785                	addi	a5,a5,1
    80206b00:	fcf43023          	sd	a5,-64(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    80206b04:	fc043583          	ld	a1,-64(s0)
    80206b08:	00023517          	auipc	a0,0x23
    80206b0c:	2d850513          	addi	a0,a0,728 # 80229de0 <user_test_table+0x348>
    80206b10:	ffffa097          	auipc	ra,0xffffa
    80206b14:	774080e7          	jalr	1908(ra) # 80201284 <printf>
        uint64 value = 0;
    80206b18:	fa043c23          	sd	zero,-72(s0)
        asm volatile (
    80206b1c:	fc043783          	ld	a5,-64(s0)
    80206b20:	639c                	ld	a5,0(a5)
    80206b22:	faf43c23          	sd	a5,-72(s0)
        printf("读取的值: 0x%lx\n", value);
    80206b26:	fb843583          	ld	a1,-72(s0)
    80206b2a:	00023517          	auipc	a0,0x23
    80206b2e:	37650513          	addi	a0,a0,886 # 80229ea0 <user_test_table+0x408>
    80206b32:	ffffa097          	auipc	ra,0xffffa
    80206b36:	752080e7          	jalr	1874(ra) # 80201284 <printf>
        printf("✓ 加载地址未对齐异常处理成功\n\n");
    80206b3a:	00023517          	auipc	a0,0x23
    80206b3e:	37e50513          	addi	a0,a0,894 # 80229eb8 <user_test_table+0x420>
    80206b42:	ffffa097          	auipc	ra,0xffffa
    80206b46:	742080e7          	jalr	1858(ra) # 80201284 <printf>
    80206b4a:	a809                	j	80206b5c <test_exception+0x294>
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    80206b4c:	00023517          	auipc	a0,0x23
    80206b50:	2e450513          	addi	a0,a0,740 # 80229e30 <user_test_table+0x398>
    80206b54:	ffffa097          	auipc	ra,0xffffa
    80206b58:	730080e7          	jalr	1840(ra) # 80201284 <printf>
	printf("6. 测试断点异常...\n");
    80206b5c:	00023517          	auipc	a0,0x23
    80206b60:	38c50513          	addi	a0,a0,908 # 80229ee8 <user_test_table+0x450>
    80206b64:	ffffa097          	auipc	ra,0xffffa
    80206b68:	720080e7          	jalr	1824(ra) # 80201284 <printf>
	asm volatile (
    80206b6c:	0001                	nop
    80206b6e:	9002                	ebreak
    80206b70:	0001                	nop
	printf("✓ 断点异常处理成功\n\n");
    80206b72:	00023517          	auipc	a0,0x23
    80206b76:	39650513          	addi	a0,a0,918 # 80229f08 <user_test_table+0x470>
    80206b7a:	ffffa097          	auipc	ra,0xffffa
    80206b7e:	70a080e7          	jalr	1802(ra) # 80201284 <printf>
    printf("7. 测试环境调用异常...\n");
    80206b82:	00023517          	auipc	a0,0x23
    80206b86:	3a650513          	addi	a0,a0,934 # 80229f28 <user_test_table+0x490>
    80206b8a:	ffffa097          	auipc	ra,0xffffa
    80206b8e:	6fa080e7          	jalr	1786(ra) # 80201284 <printf>
    asm volatile ("ecall");  // 从S模式生成环境调用
    80206b92:	00000073          	ecall
    printf("✓ 环境调用异常处理成功\n\n");
    80206b96:	00023517          	auipc	a0,0x23
    80206b9a:	3b250513          	addi	a0,a0,946 # 80229f48 <user_test_table+0x4b0>
    80206b9e:	ffffa097          	auipc	ra,0xffffa
    80206ba2:	6e6080e7          	jalr	1766(ra) # 80201284 <printf>
    printf("===== 部分异常处理测试完成 =====\n\n");
    80206ba6:	00023517          	auipc	a0,0x23
    80206baa:	3ca50513          	addi	a0,a0,970 # 80229f70 <user_test_table+0x4d8>
    80206bae:	ffffa097          	auipc	ra,0xffffa
    80206bb2:	6d6080e7          	jalr	1750(ra) # 80201284 <printf>
	printf("===== 测试不可恢复的除零异常 ====\n");
    80206bb6:	00023517          	auipc	a0,0x23
    80206bba:	3ea50513          	addi	a0,a0,1002 # 80229fa0 <user_test_table+0x508>
    80206bbe:	ffffa097          	auipc	ra,0xffffa
    80206bc2:	6c6080e7          	jalr	1734(ra) # 80201284 <printf>
	unsigned int a = 1;
    80206bc6:	4785                	li	a5,1
    80206bc8:	faf42a23          	sw	a5,-76(s0)
	unsigned int b =0;
    80206bcc:	fa042823          	sw	zero,-80(s0)
	unsigned int result = a/b;
    80206bd0:	fb442783          	lw	a5,-76(s0)
    80206bd4:	873e                	mv	a4,a5
    80206bd6:	fb042783          	lw	a5,-80(s0)
    80206bda:	02f757bb          	divuw	a5,a4,a5
    80206bde:	faf42623          	sw	a5,-84(s0)
	printf("这行不应该被打印，如果打印了，那么result = %d\n",result);
    80206be2:	fac42783          	lw	a5,-84(s0)
    80206be6:	85be                	mv	a1,a5
    80206be8:	00023517          	auipc	a0,0x23
    80206bec:	3e850513          	addi	a0,a0,1000 # 80229fd0 <user_test_table+0x538>
    80206bf0:	ffffa097          	auipc	ra,0xffffa
    80206bf4:	694080e7          	jalr	1684(ra) # 80201284 <printf>
}
    80206bf8:	0001                	nop
    80206bfa:	60e6                	ld	ra,88(sp)
    80206bfc:	6446                	ld	s0,80(sp)
    80206bfe:	6125                	addi	sp,sp,96
    80206c00:	8082                	ret

0000000080206c02 <test_interrupt_overhead>:
void test_interrupt_overhead(void) {
    80206c02:	715d                	addi	sp,sp,-80
    80206c04:	e486                	sd	ra,72(sp)
    80206c06:	e0a2                	sd	s0,64(sp)
    80206c08:	0880                	addi	s0,sp,80
    printf("\n===== 开始中断开销测试 =====\n");
    80206c0a:	00023517          	auipc	a0,0x23
    80206c0e:	40650513          	addi	a0,a0,1030 # 8022a010 <user_test_table+0x578>
    80206c12:	ffffa097          	auipc	ra,0xffffa
    80206c16:	672080e7          	jalr	1650(ra) # 80201284 <printf>
    printf("\n----- 测试1: 时钟中断处理时间 -----\n");
    80206c1a:	00023517          	auipc	a0,0x23
    80206c1e:	41e50513          	addi	a0,a0,1054 # 8022a038 <user_test_table+0x5a0>
    80206c22:	ffffa097          	auipc	ra,0xffffa
    80206c26:	662080e7          	jalr	1634(ra) # 80201284 <printf>
    int count = 0;
    80206c2a:	fa042a23          	sw	zero,-76(s0)
    volatile int *test_flag = &count;
    80206c2e:	fb440793          	addi	a5,s0,-76
    80206c32:	fef43023          	sd	a5,-32(s0)
    start_cycles = get_time();
    80206c36:	00000097          	auipc	ra,0x0
    80206c3a:	bbc080e7          	jalr	-1092(ra) # 802067f2 <get_time>
    80206c3e:	fca43c23          	sd	a0,-40(s0)
    interrupt_test_flag = test_flag;  // 设置全局标志
    80206c42:	00036797          	auipc	a5,0x36
    80206c46:	49678793          	addi	a5,a5,1174 # 8023d0d8 <interrupt_test_flag>
    80206c4a:	fe043703          	ld	a4,-32(s0)
    80206c4e:	e398                	sd	a4,0(a5)
    while(count < 10) {
    80206c50:	a011                	j	80206c54 <test_interrupt_overhead+0x52>
        asm volatile("nop");
    80206c52:	0001                	nop
    while(count < 10) {
    80206c54:	fb442783          	lw	a5,-76(s0)
    80206c58:	873e                	mv	a4,a5
    80206c5a:	47a5                	li	a5,9
    80206c5c:	fee7dbe3          	bge	a5,a4,80206c52 <test_interrupt_overhead+0x50>
    end_cycles = get_time();
    80206c60:	00000097          	auipc	ra,0x0
    80206c64:	b92080e7          	jalr	-1134(ra) # 802067f2 <get_time>
    80206c68:	fca43823          	sd	a0,-48(s0)
    interrupt_test_flag = 0;  // 清除标志
    80206c6c:	00036797          	auipc	a5,0x36
    80206c70:	46c78793          	addi	a5,a5,1132 # 8023d0d8 <interrupt_test_flag>
    80206c74:	0007b023          	sd	zero,0(a5)
    uint64 total_cycles = end_cycles - start_cycles;
    80206c78:	fd043703          	ld	a4,-48(s0)
    80206c7c:	fd843783          	ld	a5,-40(s0)
    80206c80:	40f707b3          	sub	a5,a4,a5
    80206c84:	fcf43423          	sd	a5,-56(s0)
    uint64 avg_cycles1 = total_cycles / 10;
    80206c88:	fc843703          	ld	a4,-56(s0)
    80206c8c:	47a9                	li	a5,10
    80206c8e:	02f757b3          	divu	a5,a4,a5
    80206c92:	fcf43023          	sd	a5,-64(s0)
    printf("平均每次时钟中断处理耗时: %lu cycles\n", avg_cycles1);
    80206c96:	fc043583          	ld	a1,-64(s0)
    80206c9a:	00023517          	auipc	a0,0x23
    80206c9e:	3ce50513          	addi	a0,a0,974 # 8022a068 <user_test_table+0x5d0>
    80206ca2:	ffffa097          	auipc	ra,0xffffa
    80206ca6:	5e2080e7          	jalr	1506(ra) # 80201284 <printf>
    printf("\n----- 测试2: 上下文切换成本 -----\n");
    80206caa:	00023517          	auipc	a0,0x23
    80206cae:	3f650513          	addi	a0,a0,1014 # 8022a0a0 <user_test_table+0x608>
    80206cb2:	ffffa097          	auipc	ra,0xffffa
    80206cb6:	5d2080e7          	jalr	1490(ra) # 80201284 <printf>
    start_cycles = get_time();
    80206cba:	00000097          	auipc	ra,0x0
    80206cbe:	b38080e7          	jalr	-1224(ra) # 802067f2 <get_time>
    80206cc2:	fca43c23          	sd	a0,-40(s0)
    for(int i = 0; i < 1000; i++) {
    80206cc6:	fe042623          	sw	zero,-20(s0)
    80206cca:	a801                	j	80206cda <test_interrupt_overhead+0xd8>
    80206ccc:	ffffffff          	.word	0xffffffff
    80206cd0:	fec42783          	lw	a5,-20(s0)
    80206cd4:	2785                	addiw	a5,a5,1
    80206cd6:	fef42623          	sw	a5,-20(s0)
    80206cda:	fec42783          	lw	a5,-20(s0)
    80206cde:	0007871b          	sext.w	a4,a5
    80206ce2:	3e700793          	li	a5,999
    80206ce6:	fee7d3e3          	bge	a5,a4,80206ccc <test_interrupt_overhead+0xca>
    end_cycles = get_time();
    80206cea:	00000097          	auipc	ra,0x0
    80206cee:	b08080e7          	jalr	-1272(ra) # 802067f2 <get_time>
    80206cf2:	fca43823          	sd	a0,-48(s0)
    uint64 avg_cycles2 = (end_cycles - start_cycles) / 1000;
    80206cf6:	fd043703          	ld	a4,-48(s0)
    80206cfa:	fd843783          	ld	a5,-40(s0)
    80206cfe:	8f1d                	sub	a4,a4,a5
    80206d00:	3e800793          	li	a5,1000
    80206d04:	02f757b3          	divu	a5,a4,a5
    80206d08:	faf43c23          	sd	a5,-72(s0)
	printf("平均每次时钟中断处理耗时: %lu cycles\n", avg_cycles1);
    80206d0c:	fc043583          	ld	a1,-64(s0)
    80206d10:	00023517          	auipc	a0,0x23
    80206d14:	35850513          	addi	a0,a0,856 # 8022a068 <user_test_table+0x5d0>
    80206d18:	ffffa097          	auipc	ra,0xffffa
    80206d1c:	56c080e7          	jalr	1388(ra) # 80201284 <printf>
    printf("平均每次上下文切换耗时: %lu cycles\n", avg_cycles2);
    80206d20:	fb843583          	ld	a1,-72(s0)
    80206d24:	00023517          	auipc	a0,0x23
    80206d28:	3ac50513          	addi	a0,a0,940 # 8022a0d0 <user_test_table+0x638>
    80206d2c:	ffffa097          	auipc	ra,0xffffa
    80206d30:	558080e7          	jalr	1368(ra) # 80201284 <printf>
    printf("\n===== 中断开销测试完成 =====\n");
    80206d34:	00023517          	auipc	a0,0x23
    80206d38:	3cc50513          	addi	a0,a0,972 # 8022a100 <user_test_table+0x668>
    80206d3c:	ffffa097          	auipc	ra,0xffffa
    80206d40:	548080e7          	jalr	1352(ra) # 80201284 <printf>
}
    80206d44:	0001                	nop
    80206d46:	60a6                	ld	ra,72(sp)
    80206d48:	6406                	ld	s0,64(sp)
    80206d4a:	6161                	addi	sp,sp,80
    80206d4c:	8082                	ret

0000000080206d4e <simple_task>:
void simple_task(void) {
    80206d4e:	1141                	addi	sp,sp,-16
    80206d50:	e406                	sd	ra,8(sp)
    80206d52:	e022                	sd	s0,0(sp)
    80206d54:	0800                	addi	s0,sp,16
    printf("Simple kernel task running in PID %d\n", myproc()->pid);
    80206d56:	ffffe097          	auipc	ra,0xffffe
    80206d5a:	30a080e7          	jalr	778(ra) # 80205060 <myproc>
    80206d5e:	87aa                	mv	a5,a0
    80206d60:	43dc                	lw	a5,4(a5)
    80206d62:	85be                	mv	a1,a5
    80206d64:	00023517          	auipc	a0,0x23
    80206d68:	3c450513          	addi	a0,a0,964 # 8022a128 <user_test_table+0x690>
    80206d6c:	ffffa097          	auipc	ra,0xffffa
    80206d70:	518080e7          	jalr	1304(ra) # 80201284 <printf>
}
    80206d74:	0001                	nop
    80206d76:	60a2                	ld	ra,8(sp)
    80206d78:	6402                	ld	s0,0(sp)
    80206d7a:	0141                	addi	sp,sp,16
    80206d7c:	8082                	ret

0000000080206d7e <test_process_creation>:
void test_process_creation(void) {
    80206d7e:	7119                	addi	sp,sp,-128
    80206d80:	fc86                	sd	ra,120(sp)
    80206d82:	f8a2                	sd	s0,112(sp)
    80206d84:	0100                	addi	s0,sp,128
    printf("===== 测试开始: 进程创建与管理测试 =====\n");
    80206d86:	00023517          	auipc	a0,0x23
    80206d8a:	3ca50513          	addi	a0,a0,970 # 8022a150 <user_test_table+0x6b8>
    80206d8e:	ffffa097          	auipc	ra,0xffffa
    80206d92:	4f6080e7          	jalr	1270(ra) # 80201284 <printf>
    printf("\n----- 第一阶段：测试内核进程创建与管理 -----\n");
    80206d96:	00023517          	auipc	a0,0x23
    80206d9a:	3f250513          	addi	a0,a0,1010 # 8022a188 <user_test_table+0x6f0>
    80206d9e:	ffffa097          	auipc	ra,0xffffa
    80206da2:	4e6080e7          	jalr	1254(ra) # 80201284 <printf>
    int pid = create_kernel_proc(simple_task);
    80206da6:	00000517          	auipc	a0,0x0
    80206daa:	fa850513          	addi	a0,a0,-88 # 80206d4e <simple_task>
    80206dae:	fffff097          	auipc	ra,0xfffff
    80206db2:	918080e7          	jalr	-1768(ra) # 802056c6 <create_kernel_proc>
    80206db6:	87aa                	mv	a5,a0
    80206db8:	faf42a23          	sw	a5,-76(s0)
    assert(pid > 0);
    80206dbc:	fb442783          	lw	a5,-76(s0)
    80206dc0:	2781                	sext.w	a5,a5
    80206dc2:	00f027b3          	sgtz	a5,a5
    80206dc6:	0ff7f793          	zext.b	a5,a5
    80206dca:	2781                	sext.w	a5,a5
    80206dcc:	853e                	mv	a0,a5
    80206dce:	00000097          	auipc	ra,0x0
    80206dd2:	9d8080e7          	jalr	-1576(ra) # 802067a6 <assert>
    printf("【测试结果】: 基本内核进程创建成功，PID: %d\n", pid);
    80206dd6:	fb442783          	lw	a5,-76(s0)
    80206dda:	85be                	mv	a1,a5
    80206ddc:	00023517          	auipc	a0,0x23
    80206de0:	3ec50513          	addi	a0,a0,1004 # 8022a1c8 <user_test_table+0x730>
    80206de4:	ffffa097          	auipc	ra,0xffffa
    80206de8:	4a0080e7          	jalr	1184(ra) # 80201284 <printf>
    printf("\n----- 用内核进程填满进程表 -----\n");
    80206dec:	00023517          	auipc	a0,0x23
    80206df0:	41c50513          	addi	a0,a0,1052 # 8022a208 <user_test_table+0x770>
    80206df4:	ffffa097          	auipc	ra,0xffffa
    80206df8:	490080e7          	jalr	1168(ra) # 80201284 <printf>
    int kernel_count = 1; // 已经创建了一个
    80206dfc:	4785                	li	a5,1
    80206dfe:	fef42623          	sw	a5,-20(s0)
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    80206e02:	4785                	li	a5,1
    80206e04:	fef42423          	sw	a5,-24(s0)
    80206e08:	a881                	j	80206e58 <test_process_creation+0xda>
        int new_pid = create_kernel_proc(simple_task);
    80206e0a:	00000517          	auipc	a0,0x0
    80206e0e:	f4450513          	addi	a0,a0,-188 # 80206d4e <simple_task>
    80206e12:	fffff097          	auipc	ra,0xfffff
    80206e16:	8b4080e7          	jalr	-1868(ra) # 802056c6 <create_kernel_proc>
    80206e1a:	87aa                	mv	a5,a0
    80206e1c:	faf42823          	sw	a5,-80(s0)
        if (new_pid > 0) {
    80206e20:	fb042783          	lw	a5,-80(s0)
    80206e24:	2781                	sext.w	a5,a5
    80206e26:	00f05863          	blez	a5,80206e36 <test_process_creation+0xb8>
            kernel_count++; 
    80206e2a:	fec42783          	lw	a5,-20(s0)
    80206e2e:	2785                	addiw	a5,a5,1
    80206e30:	fef42623          	sw	a5,-20(s0)
    80206e34:	a829                	j	80206e4e <test_process_creation+0xd0>
            warning("process table was full at %d kernel processes\n", kernel_count);
    80206e36:	fec42783          	lw	a5,-20(s0)
    80206e3a:	85be                	mv	a1,a5
    80206e3c:	00023517          	auipc	a0,0x23
    80206e40:	3fc50513          	addi	a0,a0,1020 # 8022a238 <user_test_table+0x7a0>
    80206e44:	ffffb097          	auipc	ra,0xffffb
    80206e48:	9f6080e7          	jalr	-1546(ra) # 8020183a <warning>
            break;
    80206e4c:	a829                	j	80206e66 <test_process_creation+0xe8>
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    80206e4e:	fe842783          	lw	a5,-24(s0)
    80206e52:	2785                	addiw	a5,a5,1
    80206e54:	fef42423          	sw	a5,-24(s0)
    80206e58:	fe842783          	lw	a5,-24(s0)
    80206e5c:	0007871b          	sext.w	a4,a5
    80206e60:	47fd                	li	a5,31
    80206e62:	fae7d4e3          	bge	a5,a4,80206e0a <test_process_creation+0x8c>
    printf("【测试结果】: 成功创建 %d 个内核进程 (最大限制: %d)\n", kernel_count, PROC);
    80206e66:	fec42783          	lw	a5,-20(s0)
    80206e6a:	02000613          	li	a2,32
    80206e6e:	85be                	mv	a1,a5
    80206e70:	00023517          	auipc	a0,0x23
    80206e74:	3f850513          	addi	a0,a0,1016 # 8022a268 <user_test_table+0x7d0>
    80206e78:	ffffa097          	auipc	ra,0xffffa
    80206e7c:	40c080e7          	jalr	1036(ra) # 80201284 <printf>
    print_proc_table();
    80206e80:	fffff097          	auipc	ra,0xfffff
    80206e84:	2f0080e7          	jalr	752(ra) # 80206170 <print_proc_table>
    printf("\n----- 等待并清理所有内核进程 -----\n");
    80206e88:	00023517          	auipc	a0,0x23
    80206e8c:	42850513          	addi	a0,a0,1064 # 8022a2b0 <user_test_table+0x818>
    80206e90:	ffffa097          	auipc	ra,0xffffa
    80206e94:	3f4080e7          	jalr	1012(ra) # 80201284 <printf>
    int kernel_success_count = 0;
    80206e98:	fe042223          	sw	zero,-28(s0)
    for (int i = 0; i < kernel_count; i++) {
    80206e9c:	fe042023          	sw	zero,-32(s0)
    80206ea0:	a0a5                	j	80206f08 <test_process_creation+0x18a>
        int waited_pid = wait_proc(NULL);
    80206ea2:	4501                	li	a0,0
    80206ea4:	fffff097          	auipc	ra,0xfffff
    80206ea8:	142080e7          	jalr	322(ra) # 80205fe6 <wait_proc>
    80206eac:	87aa                	mv	a5,a0
    80206eae:	f8f42623          	sw	a5,-116(s0)
        if (waited_pid > 0) {
    80206eb2:	f8c42783          	lw	a5,-116(s0)
    80206eb6:	2781                	sext.w	a5,a5
    80206eb8:	02f05863          	blez	a5,80206ee8 <test_process_creation+0x16a>
            kernel_success_count++;
    80206ebc:	fe442783          	lw	a5,-28(s0)
    80206ec0:	2785                	addiw	a5,a5,1
    80206ec2:	fef42223          	sw	a5,-28(s0)
            printf("回收内核进程 PID: %d (%d/%d)\n", waited_pid, kernel_success_count, kernel_count);
    80206ec6:	fec42683          	lw	a3,-20(s0)
    80206eca:	fe442703          	lw	a4,-28(s0)
    80206ece:	f8c42783          	lw	a5,-116(s0)
    80206ed2:	863a                	mv	a2,a4
    80206ed4:	85be                	mv	a1,a5
    80206ed6:	00023517          	auipc	a0,0x23
    80206eda:	40a50513          	addi	a0,a0,1034 # 8022a2e0 <user_test_table+0x848>
    80206ede:	ffffa097          	auipc	ra,0xffffa
    80206ee2:	3a6080e7          	jalr	934(ra) # 80201284 <printf>
    80206ee6:	a821                	j	80206efe <test_process_creation+0x180>
            printf("【错误】: 等待内核进程失败，错误码: %d\n", waited_pid);
    80206ee8:	f8c42783          	lw	a5,-116(s0)
    80206eec:	85be                	mv	a1,a5
    80206eee:	00023517          	auipc	a0,0x23
    80206ef2:	41a50513          	addi	a0,a0,1050 # 8022a308 <user_test_table+0x870>
    80206ef6:	ffffa097          	auipc	ra,0xffffa
    80206efa:	38e080e7          	jalr	910(ra) # 80201284 <printf>
    for (int i = 0; i < kernel_count; i++) {
    80206efe:	fe042783          	lw	a5,-32(s0)
    80206f02:	2785                	addiw	a5,a5,1
    80206f04:	fef42023          	sw	a5,-32(s0)
    80206f08:	fe042783          	lw	a5,-32(s0)
    80206f0c:	873e                	mv	a4,a5
    80206f0e:	fec42783          	lw	a5,-20(s0)
    80206f12:	2701                	sext.w	a4,a4
    80206f14:	2781                	sext.w	a5,a5
    80206f16:	f8f746e3          	blt	a4,a5,80206ea2 <test_process_creation+0x124>
    printf("【测试结果】: 回收 %d/%d 个内核进程\n", kernel_success_count, kernel_count);
    80206f1a:	fec42703          	lw	a4,-20(s0)
    80206f1e:	fe442783          	lw	a5,-28(s0)
    80206f22:	863a                	mv	a2,a4
    80206f24:	85be                	mv	a1,a5
    80206f26:	00023517          	auipc	a0,0x23
    80206f2a:	41a50513          	addi	a0,a0,1050 # 8022a340 <user_test_table+0x8a8>
    80206f2e:	ffffa097          	auipc	ra,0xffffa
    80206f32:	356080e7          	jalr	854(ra) # 80201284 <printf>
    print_proc_table();
    80206f36:	fffff097          	auipc	ra,0xfffff
    80206f3a:	23a080e7          	jalr	570(ra) # 80206170 <print_proc_table>
    printf("\n----- 第二阶段：测试用户进程创建与管理 -----\n");
    80206f3e:	00023517          	auipc	a0,0x23
    80206f42:	43a50513          	addi	a0,a0,1082 # 8022a378 <user_test_table+0x8e0>
    80206f46:	ffffa097          	auipc	ra,0xffffa
    80206f4a:	33e080e7          	jalr	830(ra) # 80201284 <printf>
    int user_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
    80206f4e:	06c00793          	li	a5,108
    80206f52:	2781                	sext.w	a5,a5
    80206f54:	85be                	mv	a1,a5
    80206f56:	00022517          	auipc	a0,0x22
    80206f5a:	40250513          	addi	a0,a0,1026 # 80229358 <simple_user_task_bin>
    80206f5e:	fffff097          	auipc	ra,0xfffff
    80206f62:	8b4080e7          	jalr	-1868(ra) # 80205812 <create_user_proc>
    80206f66:	87aa                	mv	a5,a0
    80206f68:	faf42623          	sw	a5,-84(s0)
    if (user_pid > 0) {
    80206f6c:	fac42783          	lw	a5,-84(s0)
    80206f70:	2781                	sext.w	a5,a5
    80206f72:	02f05c63          	blez	a5,80206faa <test_process_creation+0x22c>
        printf("【测试结果】: 基本用户进程创建成功，PID: %d\n", user_pid);
    80206f76:	fac42783          	lw	a5,-84(s0)
    80206f7a:	85be                	mv	a1,a5
    80206f7c:	00023517          	auipc	a0,0x23
    80206f80:	43c50513          	addi	a0,a0,1084 # 8022a3b8 <user_test_table+0x920>
    80206f84:	ffffa097          	auipc	ra,0xffffa
    80206f88:	300080e7          	jalr	768(ra) # 80201284 <printf>
    printf("\n----- 用用户进程填满进程表 -----\n");
    80206f8c:	00023517          	auipc	a0,0x23
    80206f90:	49c50513          	addi	a0,a0,1180 # 8022a428 <user_test_table+0x990>
    80206f94:	ffffa097          	auipc	ra,0xffffa
    80206f98:	2f0080e7          	jalr	752(ra) # 80201284 <printf>
    int user_count = 1; // 已经创建了一个
    80206f9c:	4785                	li	a5,1
    80206f9e:	fcf42e23          	sw	a5,-36(s0)
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    80206fa2:	4785                	li	a5,1
    80206fa4:	fcf42c23          	sw	a5,-40(s0)
    80206fa8:	a841                	j	80207038 <test_process_creation+0x2ba>
        printf("【错误】: 基本用户进程创建失败\n");
    80206faa:	00023517          	auipc	a0,0x23
    80206fae:	44e50513          	addi	a0,a0,1102 # 8022a3f8 <user_test_table+0x960>
    80206fb2:	ffffa097          	auipc	ra,0xffffa
    80206fb6:	2d2080e7          	jalr	722(ra) # 80201284 <printf>
        return;
    80206fba:	a615                	j	802072de <test_process_creation+0x560>
        int new_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
    80206fbc:	06c00793          	li	a5,108
    80206fc0:	2781                	sext.w	a5,a5
    80206fc2:	85be                	mv	a1,a5
    80206fc4:	00022517          	auipc	a0,0x22
    80206fc8:	39450513          	addi	a0,a0,916 # 80229358 <simple_user_task_bin>
    80206fcc:	fffff097          	auipc	ra,0xfffff
    80206fd0:	846080e7          	jalr	-1978(ra) # 80205812 <create_user_proc>
    80206fd4:	87aa                	mv	a5,a0
    80206fd6:	faf42423          	sw	a5,-88(s0)
        if (new_pid > 0) {
    80206fda:	fa842783          	lw	a5,-88(s0)
    80206fde:	2781                	sext.w	a5,a5
    80206fe0:	02f05b63          	blez	a5,80207016 <test_process_creation+0x298>
            user_count++;
    80206fe4:	fdc42783          	lw	a5,-36(s0)
    80206fe8:	2785                	addiw	a5,a5,1
    80206fea:	fcf42e23          	sw	a5,-36(s0)
            if (user_count % 5 == 0) { // 每5个进程打印一次进度
    80206fee:	fdc42783          	lw	a5,-36(s0)
    80206ff2:	873e                	mv	a4,a5
    80206ff4:	4795                	li	a5,5
    80206ff6:	02f767bb          	remw	a5,a4,a5
    80206ffa:	2781                	sext.w	a5,a5
    80206ffc:	eb8d                	bnez	a5,8020702e <test_process_creation+0x2b0>
                printf("已创建 %d 个用户进程...\n", user_count);
    80206ffe:	fdc42783          	lw	a5,-36(s0)
    80207002:	85be                	mv	a1,a5
    80207004:	00023517          	auipc	a0,0x23
    80207008:	45450513          	addi	a0,a0,1108 # 8022a458 <user_test_table+0x9c0>
    8020700c:	ffffa097          	auipc	ra,0xffffa
    80207010:	278080e7          	jalr	632(ra) # 80201284 <printf>
    80207014:	a829                	j	8020702e <test_process_creation+0x2b0>
            warning("process table was full at %d user processes\n", user_count);
    80207016:	fdc42783          	lw	a5,-36(s0)
    8020701a:	85be                	mv	a1,a5
    8020701c:	00023517          	auipc	a0,0x23
    80207020:	46450513          	addi	a0,a0,1124 # 8022a480 <user_test_table+0x9e8>
    80207024:	ffffb097          	auipc	ra,0xffffb
    80207028:	816080e7          	jalr	-2026(ra) # 8020183a <warning>
            break;
    8020702c:	a829                	j	80207046 <test_process_creation+0x2c8>
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    8020702e:	fd842783          	lw	a5,-40(s0)
    80207032:	2785                	addiw	a5,a5,1
    80207034:	fcf42c23          	sw	a5,-40(s0)
    80207038:	fd842783          	lw	a5,-40(s0)
    8020703c:	0007871b          	sext.w	a4,a5
    80207040:	47fd                	li	a5,31
    80207042:	f6e7dde3          	bge	a5,a4,80206fbc <test_process_creation+0x23e>
    printf("【测试结果】: 成功创建 %d 个用户进程 (最大限制: %d)\n", user_count, PROC);
    80207046:	fdc42783          	lw	a5,-36(s0)
    8020704a:	02000613          	li	a2,32
    8020704e:	85be                	mv	a1,a5
    80207050:	00023517          	auipc	a0,0x23
    80207054:	46050513          	addi	a0,a0,1120 # 8022a4b0 <user_test_table+0xa18>
    80207058:	ffffa097          	auipc	ra,0xffffa
    8020705c:	22c080e7          	jalr	556(ra) # 80201284 <printf>
    print_proc_table();
    80207060:	fffff097          	auipc	ra,0xfffff
    80207064:	110080e7          	jalr	272(ra) # 80206170 <print_proc_table>
    printf("\n----- 等待并清理所有用户进程 -----\n");
    80207068:	00023517          	auipc	a0,0x23
    8020706c:	49050513          	addi	a0,a0,1168 # 8022a4f8 <user_test_table+0xa60>
    80207070:	ffffa097          	auipc	ra,0xffffa
    80207074:	214080e7          	jalr	532(ra) # 80201284 <printf>
    int user_success_count = 0;
    80207078:	fc042a23          	sw	zero,-44(s0)
    for (int i = 0; i < user_count; i++) {
    8020707c:	fc042823          	sw	zero,-48(s0)
    80207080:	a895                	j	802070f4 <test_process_creation+0x376>
        int waited_pid = wait_proc(NULL);
    80207082:	4501                	li	a0,0
    80207084:	fffff097          	auipc	ra,0xfffff
    80207088:	f62080e7          	jalr	-158(ra) # 80205fe6 <wait_proc>
    8020708c:	87aa                	mv	a5,a0
    8020708e:	f8f42823          	sw	a5,-112(s0)
        if (waited_pid > 0) {
    80207092:	f9042783          	lw	a5,-112(s0)
    80207096:	2781                	sext.w	a5,a5
    80207098:	02f05e63          	blez	a5,802070d4 <test_process_creation+0x356>
            user_success_count++;
    8020709c:	fd442783          	lw	a5,-44(s0)
    802070a0:	2785                	addiw	a5,a5,1
    802070a2:	fcf42a23          	sw	a5,-44(s0)
            if (user_success_count % 5 == 0) { // 每5个进程打印一次进度
    802070a6:	fd442783          	lw	a5,-44(s0)
    802070aa:	873e                	mv	a4,a5
    802070ac:	4795                	li	a5,5
    802070ae:	02f767bb          	remw	a5,a4,a5
    802070b2:	2781                	sext.w	a5,a5
    802070b4:	eb9d                	bnez	a5,802070ea <test_process_creation+0x36c>
                printf("已回收 %d/%d 个用户进程...\n", user_success_count, user_count);
    802070b6:	fdc42703          	lw	a4,-36(s0)
    802070ba:	fd442783          	lw	a5,-44(s0)
    802070be:	863a                	mv	a2,a4
    802070c0:	85be                	mv	a1,a5
    802070c2:	00023517          	auipc	a0,0x23
    802070c6:	46650513          	addi	a0,a0,1126 # 8022a528 <user_test_table+0xa90>
    802070ca:	ffffa097          	auipc	ra,0xffffa
    802070ce:	1ba080e7          	jalr	442(ra) # 80201284 <printf>
    802070d2:	a821                	j	802070ea <test_process_creation+0x36c>
            printf("【错误】: 等待用户进程失败，错误码: %d\n", waited_pid);
    802070d4:	f9042783          	lw	a5,-112(s0)
    802070d8:	85be                	mv	a1,a5
    802070da:	00023517          	auipc	a0,0x23
    802070de:	47650513          	addi	a0,a0,1142 # 8022a550 <user_test_table+0xab8>
    802070e2:	ffffa097          	auipc	ra,0xffffa
    802070e6:	1a2080e7          	jalr	418(ra) # 80201284 <printf>
    for (int i = 0; i < user_count; i++) {
    802070ea:	fd042783          	lw	a5,-48(s0)
    802070ee:	2785                	addiw	a5,a5,1
    802070f0:	fcf42823          	sw	a5,-48(s0)
    802070f4:	fd042783          	lw	a5,-48(s0)
    802070f8:	873e                	mv	a4,a5
    802070fa:	fdc42783          	lw	a5,-36(s0)
    802070fe:	2701                	sext.w	a4,a4
    80207100:	2781                	sext.w	a5,a5
    80207102:	f8f740e3          	blt	a4,a5,80207082 <test_process_creation+0x304>
    printf("【测试结果】: 回收 %d/%d 个用户进程\n", user_success_count, user_count);
    80207106:	fdc42703          	lw	a4,-36(s0)
    8020710a:	fd442783          	lw	a5,-44(s0)
    8020710e:	863a                	mv	a2,a4
    80207110:	85be                	mv	a1,a5
    80207112:	00023517          	auipc	a0,0x23
    80207116:	47650513          	addi	a0,a0,1142 # 8022a588 <user_test_table+0xaf0>
    8020711a:	ffffa097          	auipc	ra,0xffffa
    8020711e:	16a080e7          	jalr	362(ra) # 80201284 <printf>
    print_proc_table();
    80207122:	fffff097          	auipc	ra,0xfffff
    80207126:	04e080e7          	jalr	78(ra) # 80206170 <print_proc_table>
    printf("\n----- 第三阶段：混合进程测试 -----\n");
    8020712a:	00023517          	auipc	a0,0x23
    8020712e:	49650513          	addi	a0,a0,1174 # 8022a5c0 <user_test_table+0xb28>
    80207132:	ffffa097          	auipc	ra,0xffffa
    80207136:	152080e7          	jalr	338(ra) # 80201284 <printf>
    int mixed_kernel_count = 0;
    8020713a:	fc042623          	sw	zero,-52(s0)
    int mixed_user_count = 0;
    8020713e:	fc042423          	sw	zero,-56(s0)
    int target_count = PROC / 2;
    80207142:	47c1                	li	a5,16
    80207144:	faf42223          	sw	a5,-92(s0)
    printf("创建 %d 个内核进程和 %d 个用户进程...\n", target_count, target_count);
    80207148:	fa442703          	lw	a4,-92(s0)
    8020714c:	fa442783          	lw	a5,-92(s0)
    80207150:	863a                	mv	a2,a4
    80207152:	85be                	mv	a1,a5
    80207154:	00023517          	auipc	a0,0x23
    80207158:	49c50513          	addi	a0,a0,1180 # 8022a5f0 <user_test_table+0xb58>
    8020715c:	ffffa097          	auipc	ra,0xffffa
    80207160:	128080e7          	jalr	296(ra) # 80201284 <printf>
    for (int i = 0; i < target_count; i++) {
    80207164:	fc042223          	sw	zero,-60(s0)
    80207168:	a81d                	j	8020719e <test_process_creation+0x420>
        int new_pid = create_kernel_proc(simple_task);
    8020716a:	00000517          	auipc	a0,0x0
    8020716e:	be450513          	addi	a0,a0,-1052 # 80206d4e <simple_task>
    80207172:	ffffe097          	auipc	ra,0xffffe
    80207176:	554080e7          	jalr	1364(ra) # 802056c6 <create_kernel_proc>
    8020717a:	87aa                	mv	a5,a0
    8020717c:	faf42023          	sw	a5,-96(s0)
        if (new_pid > 0) {
    80207180:	fa042783          	lw	a5,-96(s0)
    80207184:	2781                	sext.w	a5,a5
    80207186:	02f05663          	blez	a5,802071b2 <test_process_creation+0x434>
            mixed_kernel_count++;
    8020718a:	fcc42783          	lw	a5,-52(s0)
    8020718e:	2785                	addiw	a5,a5,1
    80207190:	fcf42623          	sw	a5,-52(s0)
    for (int i = 0; i < target_count; i++) {
    80207194:	fc442783          	lw	a5,-60(s0)
    80207198:	2785                	addiw	a5,a5,1
    8020719a:	fcf42223          	sw	a5,-60(s0)
    8020719e:	fc442783          	lw	a5,-60(s0)
    802071a2:	873e                	mv	a4,a5
    802071a4:	fa442783          	lw	a5,-92(s0)
    802071a8:	2701                	sext.w	a4,a4
    802071aa:	2781                	sext.w	a5,a5
    802071ac:	faf74fe3          	blt	a4,a5,8020716a <test_process_creation+0x3ec>
    802071b0:	a011                	j	802071b4 <test_process_creation+0x436>
            break;
    802071b2:	0001                	nop
    for (int i = 0; i < target_count; i++) {
    802071b4:	fc042023          	sw	zero,-64(s0)
    802071b8:	a83d                	j	802071f6 <test_process_creation+0x478>
        int new_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
    802071ba:	06c00793          	li	a5,108
    802071be:	2781                	sext.w	a5,a5
    802071c0:	85be                	mv	a1,a5
    802071c2:	00022517          	auipc	a0,0x22
    802071c6:	19650513          	addi	a0,a0,406 # 80229358 <simple_user_task_bin>
    802071ca:	ffffe097          	auipc	ra,0xffffe
    802071ce:	648080e7          	jalr	1608(ra) # 80205812 <create_user_proc>
    802071d2:	87aa                	mv	a5,a0
    802071d4:	f8f42e23          	sw	a5,-100(s0)
        if (new_pid > 0) {
    802071d8:	f9c42783          	lw	a5,-100(s0)
    802071dc:	2781                	sext.w	a5,a5
    802071de:	02f05663          	blez	a5,8020720a <test_process_creation+0x48c>
            mixed_user_count++;
    802071e2:	fc842783          	lw	a5,-56(s0)
    802071e6:	2785                	addiw	a5,a5,1
    802071e8:	fcf42423          	sw	a5,-56(s0)
    for (int i = 0; i < target_count; i++) {
    802071ec:	fc042783          	lw	a5,-64(s0)
    802071f0:	2785                	addiw	a5,a5,1
    802071f2:	fcf42023          	sw	a5,-64(s0)
    802071f6:	fc042783          	lw	a5,-64(s0)
    802071fa:	873e                	mv	a4,a5
    802071fc:	fa442783          	lw	a5,-92(s0)
    80207200:	2701                	sext.w	a4,a4
    80207202:	2781                	sext.w	a5,a5
    80207204:	faf74be3          	blt	a4,a5,802071ba <test_process_creation+0x43c>
    80207208:	a011                	j	8020720c <test_process_creation+0x48e>
            break;
    8020720a:	0001                	nop
    printf("【混合测试结果】: 创建了 %d 个内核进程 + %d 个用户进程 = %d 个进程\n", 
    8020720c:	fcc42783          	lw	a5,-52(s0)
    80207210:	873e                	mv	a4,a5
    80207212:	fc842783          	lw	a5,-56(s0)
    80207216:	9fb9                	addw	a5,a5,a4
    80207218:	0007869b          	sext.w	a3,a5
    8020721c:	fc842703          	lw	a4,-56(s0)
    80207220:	fcc42783          	lw	a5,-52(s0)
    80207224:	863a                	mv	a2,a4
    80207226:	85be                	mv	a1,a5
    80207228:	00023517          	auipc	a0,0x23
    8020722c:	40050513          	addi	a0,a0,1024 # 8022a628 <user_test_table+0xb90>
    80207230:	ffffa097          	auipc	ra,0xffffa
    80207234:	054080e7          	jalr	84(ra) # 80201284 <printf>
    print_proc_table();
    80207238:	fffff097          	auipc	ra,0xfffff
    8020723c:	f38080e7          	jalr	-200(ra) # 80206170 <print_proc_table>
    printf("\n----- 清理混合进程 -----\n");
    80207240:	00023517          	auipc	a0,0x23
    80207244:	44850513          	addi	a0,a0,1096 # 8022a688 <user_test_table+0xbf0>
    80207248:	ffffa097          	auipc	ra,0xffffa
    8020724c:	03c080e7          	jalr	60(ra) # 80201284 <printf>
    int mixed_success_count = 0;
    80207250:	fa042e23          	sw	zero,-68(s0)
    int total_mixed = mixed_kernel_count + mixed_user_count;
    80207254:	fcc42783          	lw	a5,-52(s0)
    80207258:	873e                	mv	a4,a5
    8020725a:	fc842783          	lw	a5,-56(s0)
    8020725e:	9fb9                	addw	a5,a5,a4
    80207260:	f8f42c23          	sw	a5,-104(s0)
    for (int i = 0; i < total_mixed; i++) {
    80207264:	fa042c23          	sw	zero,-72(s0)
    80207268:	a805                	j	80207298 <test_process_creation+0x51a>
        int waited_pid = wait_proc(NULL);
    8020726a:	4501                	li	a0,0
    8020726c:	fffff097          	auipc	ra,0xfffff
    80207270:	d7a080e7          	jalr	-646(ra) # 80205fe6 <wait_proc>
    80207274:	87aa                	mv	a5,a0
    80207276:	f8f42a23          	sw	a5,-108(s0)
        if (waited_pid > 0) {
    8020727a:	f9442783          	lw	a5,-108(s0)
    8020727e:	2781                	sext.w	a5,a5
    80207280:	00f05763          	blez	a5,8020728e <test_process_creation+0x510>
            mixed_success_count++;
    80207284:	fbc42783          	lw	a5,-68(s0)
    80207288:	2785                	addiw	a5,a5,1
    8020728a:	faf42e23          	sw	a5,-68(s0)
    for (int i = 0; i < total_mixed; i++) {
    8020728e:	fb842783          	lw	a5,-72(s0)
    80207292:	2785                	addiw	a5,a5,1
    80207294:	faf42c23          	sw	a5,-72(s0)
    80207298:	fb842783          	lw	a5,-72(s0)
    8020729c:	873e                	mv	a4,a5
    8020729e:	f9842783          	lw	a5,-104(s0)
    802072a2:	2701                	sext.w	a4,a4
    802072a4:	2781                	sext.w	a5,a5
    802072a6:	fcf742e3          	blt	a4,a5,8020726a <test_process_creation+0x4ec>
    printf("【混合测试结果】: 回收 %d/%d 个混合进程\n", mixed_success_count, total_mixed);
    802072aa:	f9842703          	lw	a4,-104(s0)
    802072ae:	fbc42783          	lw	a5,-68(s0)
    802072b2:	863a                	mv	a2,a4
    802072b4:	85be                	mv	a1,a5
    802072b6:	00023517          	auipc	a0,0x23
    802072ba:	3fa50513          	addi	a0,a0,1018 # 8022a6b0 <user_test_table+0xc18>
    802072be:	ffffa097          	auipc	ra,0xffffa
    802072c2:	fc6080e7          	jalr	-58(ra) # 80201284 <printf>
    print_proc_table();
    802072c6:	fffff097          	auipc	ra,0xfffff
    802072ca:	eaa080e7          	jalr	-342(ra) # 80206170 <print_proc_table>
    printf("===== 测试结束: 进程创建与管理测试 =====\n");
    802072ce:	00023517          	auipc	a0,0x23
    802072d2:	41a50513          	addi	a0,a0,1050 # 8022a6e8 <user_test_table+0xc50>
    802072d6:	ffffa097          	auipc	ra,0xffffa
    802072da:	fae080e7          	jalr	-82(ra) # 80201284 <printf>
}
    802072de:	70e6                	ld	ra,120(sp)
    802072e0:	7446                	ld	s0,112(sp)
    802072e2:	6109                	addi	sp,sp,128
    802072e4:	8082                	ret

00000000802072e6 <cpu_intensive_task>:
void cpu_intensive_task(void) {
    802072e6:	7139                	addi	sp,sp,-64
    802072e8:	fc06                	sd	ra,56(sp)
    802072ea:	f822                	sd	s0,48(sp)
    802072ec:	0080                	addi	s0,sp,64
    int pid = myproc()->pid;
    802072ee:	ffffe097          	auipc	ra,0xffffe
    802072f2:	d72080e7          	jalr	-654(ra) # 80205060 <myproc>
    802072f6:	87aa                	mv	a5,a0
    802072f8:	43dc                	lw	a5,4(a5)
    802072fa:	fcf42e23          	sw	a5,-36(s0)
    printf("[进程 %d] 开始CPU密集计算\n", pid);
    802072fe:	fdc42783          	lw	a5,-36(s0)
    80207302:	85be                	mv	a1,a5
    80207304:	00023517          	auipc	a0,0x23
    80207308:	41c50513          	addi	a0,a0,1052 # 8022a720 <user_test_table+0xc88>
    8020730c:	ffffa097          	auipc	ra,0xffffa
    80207310:	f78080e7          	jalr	-136(ra) # 80201284 <printf>
    uint64 sum = 0;
    80207314:	fe043423          	sd	zero,-24(s0)
    const uint64 TOTAL_ITERATIONS = 100000000;
    80207318:	05f5e7b7          	lui	a5,0x5f5e
    8020731c:	10078793          	addi	a5,a5,256 # 5f5e100 <_entry-0x7a2a1f00>
    80207320:	fcf43823          	sd	a5,-48(s0)
    const uint64 REPORT_INTERVAL = TOTAL_ITERATIONS / 100;  // 每完成1%报告一次
    80207324:	fd043703          	ld	a4,-48(s0)
    80207328:	06400793          	li	a5,100
    8020732c:	02f757b3          	divu	a5,a4,a5
    80207330:	fcf43423          	sd	a5,-56(s0)
    for (uint64 i = 0; i < TOTAL_ITERATIONS; i++) {
    80207334:	fe043023          	sd	zero,-32(s0)
    80207338:	a8b5                	j	802073b4 <cpu_intensive_task+0xce>
        sum += (i * i) % 1000000007;  // 添加乘法和取模运算
    8020733a:	fe043783          	ld	a5,-32(s0)
    8020733e:	02f78733          	mul	a4,a5,a5
    80207342:	3b9ad7b7          	lui	a5,0x3b9ad
    80207346:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <_entry-0x448535f9>
    8020734a:	02f777b3          	remu	a5,a4,a5
    8020734e:	fe843703          	ld	a4,-24(s0)
    80207352:	97ba                	add	a5,a5,a4
    80207354:	fef43423          	sd	a5,-24(s0)
        if (i % REPORT_INTERVAL == 0) {
    80207358:	fe043703          	ld	a4,-32(s0)
    8020735c:	fc843783          	ld	a5,-56(s0)
    80207360:	02f777b3          	remu	a5,a4,a5
    80207364:	e3b9                	bnez	a5,802073aa <cpu_intensive_task+0xc4>
            uint64 percent = (i * 100) / TOTAL_ITERATIONS;
    80207366:	fe043703          	ld	a4,-32(s0)
    8020736a:	06400793          	li	a5,100
    8020736e:	02f70733          	mul	a4,a4,a5
    80207372:	fd043783          	ld	a5,-48(s0)
    80207376:	02f757b3          	divu	a5,a4,a5
    8020737a:	fcf43023          	sd	a5,-64(s0)
            printf("[进程 %d] 完成度: %lu%%，当前sum=%lu\n", 
    8020737e:	fdc42783          	lw	a5,-36(s0)
    80207382:	fe843683          	ld	a3,-24(s0)
    80207386:	fc043603          	ld	a2,-64(s0)
    8020738a:	85be                	mv	a1,a5
    8020738c:	00023517          	auipc	a0,0x23
    80207390:	3bc50513          	addi	a0,a0,956 # 8022a748 <user_test_table+0xcb0>
    80207394:	ffffa097          	auipc	ra,0xffffa
    80207398:	ef0080e7          	jalr	-272(ra) # 80201284 <printf>
            if (i > 0) {
    8020739c:	fe043783          	ld	a5,-32(s0)
    802073a0:	c789                	beqz	a5,802073aa <cpu_intensive_task+0xc4>
                yield();
    802073a2:	fffff097          	auipc	ra,0xfffff
    802073a6:	93a080e7          	jalr	-1734(ra) # 80205cdc <yield>
    for (uint64 i = 0; i < TOTAL_ITERATIONS; i++) {
    802073aa:	fe043783          	ld	a5,-32(s0)
    802073ae:	0785                	addi	a5,a5,1
    802073b0:	fef43023          	sd	a5,-32(s0)
    802073b4:	fe043703          	ld	a4,-32(s0)
    802073b8:	fd043783          	ld	a5,-48(s0)
    802073bc:	f6f76fe3          	bltu	a4,a5,8020733a <cpu_intensive_task+0x54>
    printf("[进程 %d] 计算完成，最终sum=%lu\n", pid, sum);
    802073c0:	fdc42783          	lw	a5,-36(s0)
    802073c4:	fe843603          	ld	a2,-24(s0)
    802073c8:	85be                	mv	a1,a5
    802073ca:	00023517          	auipc	a0,0x23
    802073ce:	3ae50513          	addi	a0,a0,942 # 8022a778 <user_test_table+0xce0>
    802073d2:	ffffa097          	auipc	ra,0xffffa
    802073d6:	eb2080e7          	jalr	-334(ra) # 80201284 <printf>
    exit_proc(0);
    802073da:	4501                	li	a0,0
    802073dc:	fffff097          	auipc	ra,0xfffff
    802073e0:	b40080e7          	jalr	-1216(ra) # 80205f1c <exit_proc>
}
    802073e4:	0001                	nop
    802073e6:	70e2                	ld	ra,56(sp)
    802073e8:	7442                	ld	s0,48(sp)
    802073ea:	6121                	addi	sp,sp,64
    802073ec:	8082                	ret

00000000802073ee <test_scheduler>:
void test_scheduler(void) {
    802073ee:	715d                	addi	sp,sp,-80
    802073f0:	e486                	sd	ra,72(sp)
    802073f2:	e0a2                	sd	s0,64(sp)
    802073f4:	0880                	addi	s0,sp,80
    printf("\n===== 测试开始: 调度器公平性测试 =====\n");
    802073f6:	00023517          	auipc	a0,0x23
    802073fa:	3b250513          	addi	a0,a0,946 # 8022a7a8 <user_test_table+0xd10>
    802073fe:	ffffa097          	auipc	ra,0xffffa
    80207402:	e86080e7          	jalr	-378(ra) # 80201284 <printf>
    for (int i = 0; i < 3; i++) {
    80207406:	fe042623          	sw	zero,-20(s0)
    8020740a:	a8a5                	j	80207482 <test_scheduler+0x94>
        pids[i] = create_kernel_proc(cpu_intensive_task);
    8020740c:	00000517          	auipc	a0,0x0
    80207410:	eda50513          	addi	a0,a0,-294 # 802072e6 <cpu_intensive_task>
    80207414:	ffffe097          	auipc	ra,0xffffe
    80207418:	2b2080e7          	jalr	690(ra) # 802056c6 <create_kernel_proc>
    8020741c:	87aa                	mv	a5,a0
    8020741e:	873e                	mv	a4,a5
    80207420:	fec42783          	lw	a5,-20(s0)
    80207424:	078a                	slli	a5,a5,0x2
    80207426:	17c1                	addi	a5,a5,-16
    80207428:	97a2                	add	a5,a5,s0
    8020742a:	fce7a823          	sw	a4,-48(a5)
        if (pids[i] < 0) {
    8020742e:	fec42783          	lw	a5,-20(s0)
    80207432:	078a                	slli	a5,a5,0x2
    80207434:	17c1                	addi	a5,a5,-16
    80207436:	97a2                	add	a5,a5,s0
    80207438:	fd07a783          	lw	a5,-48(a5)
    8020743c:	0007de63          	bgez	a5,80207458 <test_scheduler+0x6a>
            printf("【错误】创建进程 %d 失败\n", i);
    80207440:	fec42783          	lw	a5,-20(s0)
    80207444:	85be                	mv	a1,a5
    80207446:	00023517          	auipc	a0,0x23
    8020744a:	39a50513          	addi	a0,a0,922 # 8022a7e0 <user_test_table+0xd48>
    8020744e:	ffffa097          	auipc	ra,0xffffa
    80207452:	e36080e7          	jalr	-458(ra) # 80201284 <printf>
    80207456:	a239                	j	80207564 <test_scheduler+0x176>
        printf("创建进程成功，PID: %d\n", pids[i]);
    80207458:	fec42783          	lw	a5,-20(s0)
    8020745c:	078a                	slli	a5,a5,0x2
    8020745e:	17c1                	addi	a5,a5,-16
    80207460:	97a2                	add	a5,a5,s0
    80207462:	fd07a783          	lw	a5,-48(a5)
    80207466:	85be                	mv	a1,a5
    80207468:	00023517          	auipc	a0,0x23
    8020746c:	3a050513          	addi	a0,a0,928 # 8022a808 <user_test_table+0xd70>
    80207470:	ffffa097          	auipc	ra,0xffffa
    80207474:	e14080e7          	jalr	-492(ra) # 80201284 <printf>
    for (int i = 0; i < 3; i++) {
    80207478:	fec42783          	lw	a5,-20(s0)
    8020747c:	2785                	addiw	a5,a5,1
    8020747e:	fef42623          	sw	a5,-20(s0)
    80207482:	fec42783          	lw	a5,-20(s0)
    80207486:	0007871b          	sext.w	a4,a5
    8020748a:	4789                	li	a5,2
    8020748c:	f8e7d0e3          	bge	a5,a4,8020740c <test_scheduler+0x1e>
    uint64 start_time = get_time();
    80207490:	fffff097          	auipc	ra,0xfffff
    80207494:	362080e7          	jalr	866(ra) # 802067f2 <get_time>
    80207498:	fea43023          	sd	a0,-32(s0)
    int completed = 0;
    8020749c:	fe042423          	sw	zero,-24(s0)
    while (completed < 3) {
    802074a0:	a0a9                	j	802074ea <test_scheduler+0xfc>
        int pid = wait_proc(&status);
    802074a2:	fbc40793          	addi	a5,s0,-68
    802074a6:	853e                	mv	a0,a5
    802074a8:	fffff097          	auipc	ra,0xfffff
    802074ac:	b3e080e7          	jalr	-1218(ra) # 80205fe6 <wait_proc>
    802074b0:	87aa                	mv	a5,a0
    802074b2:	fcf42623          	sw	a5,-52(s0)
        if (pid > 0) {
    802074b6:	fcc42783          	lw	a5,-52(s0)
    802074ba:	2781                	sext.w	a5,a5
    802074bc:	02f05763          	blez	a5,802074ea <test_scheduler+0xfc>
            completed++;
    802074c0:	fe842783          	lw	a5,-24(s0)
    802074c4:	2785                	addiw	a5,a5,1
    802074c6:	fef42423          	sw	a5,-24(s0)
            printf("进程 %d 已完成，退出状态: %d (%d/3)\n", 
    802074ca:	fbc42703          	lw	a4,-68(s0)
    802074ce:	fe842683          	lw	a3,-24(s0)
    802074d2:	fcc42783          	lw	a5,-52(s0)
    802074d6:	863a                	mv	a2,a4
    802074d8:	85be                	mv	a1,a5
    802074da:	00023517          	auipc	a0,0x23
    802074de:	34e50513          	addi	a0,a0,846 # 8022a828 <user_test_table+0xd90>
    802074e2:	ffffa097          	auipc	ra,0xffffa
    802074e6:	da2080e7          	jalr	-606(ra) # 80201284 <printf>
    while (completed < 3) {
    802074ea:	fe842783          	lw	a5,-24(s0)
    802074ee:	0007871b          	sext.w	a4,a5
    802074f2:	4789                	li	a5,2
    802074f4:	fae7d7e3          	bge	a5,a4,802074a2 <test_scheduler+0xb4>
    uint64 end_time = get_time();
    802074f8:	fffff097          	auipc	ra,0xfffff
    802074fc:	2fa080e7          	jalr	762(ra) # 802067f2 <get_time>
    80207500:	fca43c23          	sd	a0,-40(s0)
    uint64 total_cycles = end_time - start_time;
    80207504:	fd843703          	ld	a4,-40(s0)
    80207508:	fe043783          	ld	a5,-32(s0)
    8020750c:	40f707b3          	sub	a5,a4,a5
    80207510:	fcf43823          	sd	a5,-48(s0)
    printf("\n----- 测试结果 -----\n");
    80207514:	00023517          	auipc	a0,0x23
    80207518:	34450513          	addi	a0,a0,836 # 8022a858 <user_test_table+0xdc0>
    8020751c:	ffffa097          	auipc	ra,0xffffa
    80207520:	d68080e7          	jalr	-664(ra) # 80201284 <printf>
    printf("总执行时间: %lu cycles\n", total_cycles);
    80207524:	fd043583          	ld	a1,-48(s0)
    80207528:	00023517          	auipc	a0,0x23
    8020752c:	35050513          	addi	a0,a0,848 # 8022a878 <user_test_table+0xde0>
    80207530:	ffffa097          	auipc	ra,0xffffa
    80207534:	d54080e7          	jalr	-684(ra) # 80201284 <printf>
    printf("平均每个进程执行时间: %lu cycles\n", total_cycles / 3);
    80207538:	fd043703          	ld	a4,-48(s0)
    8020753c:	478d                	li	a5,3
    8020753e:	02f757b3          	divu	a5,a4,a5
    80207542:	85be                	mv	a1,a5
    80207544:	00023517          	auipc	a0,0x23
    80207548:	35450513          	addi	a0,a0,852 # 8022a898 <user_test_table+0xe00>
    8020754c:	ffffa097          	auipc	ra,0xffffa
    80207550:	d38080e7          	jalr	-712(ra) # 80201284 <printf>
    printf("===== 调度器测试完成 =====\n");
    80207554:	00023517          	auipc	a0,0x23
    80207558:	37450513          	addi	a0,a0,884 # 8022a8c8 <user_test_table+0xe30>
    8020755c:	ffffa097          	auipc	ra,0xffffa
    80207560:	d28080e7          	jalr	-728(ra) # 80201284 <printf>
}
    80207564:	60a6                	ld	ra,72(sp)
    80207566:	6406                	ld	s0,64(sp)
    80207568:	6161                	addi	sp,sp,80
    8020756a:	8082                	ret

000000008020756c <shared_buffer_init>:
void shared_buffer_init() {
    8020756c:	1141                	addi	sp,sp,-16
    8020756e:	e422                	sd	s0,8(sp)
    80207570:	0800                	addi	s0,sp,16
    proc_buffer = 0;
    80207572:	00036797          	auipc	a5,0x36
    80207576:	19678793          	addi	a5,a5,406 # 8023d708 <proc_buffer>
    8020757a:	0007a023          	sw	zero,0(a5)
    proc_produced = 0;
    8020757e:	00036797          	auipc	a5,0x36
    80207582:	18e78793          	addi	a5,a5,398 # 8023d70c <proc_produced>
    80207586:	0007a023          	sw	zero,0(a5)
}
    8020758a:	0001                	nop
    8020758c:	6422                	ld	s0,8(sp)
    8020758e:	0141                	addi	sp,sp,16
    80207590:	8082                	ret

0000000080207592 <producer_task>:
void producer_task(void) {
    80207592:	7179                	addi	sp,sp,-48
    80207594:	f406                	sd	ra,40(sp)
    80207596:	f022                	sd	s0,32(sp)
    80207598:	1800                	addi	s0,sp,48
	int pid = myproc()->pid;
    8020759a:	ffffe097          	auipc	ra,0xffffe
    8020759e:	ac6080e7          	jalr	-1338(ra) # 80205060 <myproc>
    802075a2:	87aa                	mv	a5,a0
    802075a4:	43dc                	lw	a5,4(a5)
    802075a6:	fcf42e23          	sw	a5,-36(s0)
    uint64 sum = 0;
    802075aa:	fe043423          	sd	zero,-24(s0)
    const uint64 ITERATIONS = 10000000;  // 一千万次循环
    802075ae:	009897b7          	lui	a5,0x989
    802075b2:	68078793          	addi	a5,a5,1664 # 989680 <_entry-0x7f876980>
    802075b6:	fcf43823          	sd	a5,-48(s0)
    for(uint64 i = 0; i < ITERATIONS; i++) {
    802075ba:	fe043023          	sd	zero,-32(s0)
    802075be:	a0bd                	j	8020762c <producer_task+0x9a>
        sum += (i * i) % 1000000007;  // 复杂计算
    802075c0:	fe043783          	ld	a5,-32(s0)
    802075c4:	02f78733          	mul	a4,a5,a5
    802075c8:	3b9ad7b7          	lui	a5,0x3b9ad
    802075cc:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <_entry-0x448535f9>
    802075d0:	02f777b3          	remu	a5,a4,a5
    802075d4:	fe843703          	ld	a4,-24(s0)
    802075d8:	97ba                	add	a5,a5,a4
    802075da:	fef43423          	sd	a5,-24(s0)
        if(i % (ITERATIONS/10) == 0) {
    802075de:	fd043703          	ld	a4,-48(s0)
    802075e2:	47a9                	li	a5,10
    802075e4:	02f757b3          	divu	a5,a4,a5
    802075e8:	fe043703          	ld	a4,-32(s0)
    802075ec:	02f777b3          	remu	a5,a4,a5
    802075f0:	eb8d                	bnez	a5,80207622 <producer_task+0x90>
                   pid, (int)(i * 100 / ITERATIONS));
    802075f2:	fe043703          	ld	a4,-32(s0)
    802075f6:	06400793          	li	a5,100
    802075fa:	02f70733          	mul	a4,a4,a5
    802075fe:	fd043783          	ld	a5,-48(s0)
    80207602:	02f757b3          	divu	a5,a4,a5
            printf("[Producer %d] 计算进度: %d%%\n", 
    80207606:	0007871b          	sext.w	a4,a5
    8020760a:	fdc42783          	lw	a5,-36(s0)
    8020760e:	863a                	mv	a2,a4
    80207610:	85be                	mv	a1,a5
    80207612:	00023517          	auipc	a0,0x23
    80207616:	2de50513          	addi	a0,a0,734 # 8022a8f0 <user_test_table+0xe58>
    8020761a:	ffffa097          	auipc	ra,0xffffa
    8020761e:	c6a080e7          	jalr	-918(ra) # 80201284 <printf>
    for(uint64 i = 0; i < ITERATIONS; i++) {
    80207622:	fe043783          	ld	a5,-32(s0)
    80207626:	0785                	addi	a5,a5,1
    80207628:	fef43023          	sd	a5,-32(s0)
    8020762c:	fe043703          	ld	a4,-32(s0)
    80207630:	fd043783          	ld	a5,-48(s0)
    80207634:	f8f766e3          	bltu	a4,a5,802075c0 <producer_task+0x2e>
    proc_buffer = 42;
    80207638:	00036797          	auipc	a5,0x36
    8020763c:	0d078793          	addi	a5,a5,208 # 8023d708 <proc_buffer>
    80207640:	02a00713          	li	a4,42
    80207644:	c398                	sw	a4,0(a5)
    proc_produced = 1;
    80207646:	00036797          	auipc	a5,0x36
    8020764a:	0c678793          	addi	a5,a5,198 # 8023d70c <proc_produced>
    8020764e:	4705                	li	a4,1
    80207650:	c398                	sw	a4,0(a5)
    wakeup(&proc_produced); // 唤醒消费者
    80207652:	00036517          	auipc	a0,0x36
    80207656:	0ba50513          	addi	a0,a0,186 # 8023d70c <proc_produced>
    8020765a:	ffffe097          	auipc	ra,0xffffe
    8020765e:	7e0080e7          	jalr	2016(ra) # 80205e3a <wakeup>
    printf("Producer: produced value %d\n", proc_buffer);
    80207662:	00036797          	auipc	a5,0x36
    80207666:	0a678793          	addi	a5,a5,166 # 8023d708 <proc_buffer>
    8020766a:	439c                	lw	a5,0(a5)
    8020766c:	85be                	mv	a1,a5
    8020766e:	00023517          	auipc	a0,0x23
    80207672:	2aa50513          	addi	a0,a0,682 # 8022a918 <user_test_table+0xe80>
    80207676:	ffffa097          	auipc	ra,0xffffa
    8020767a:	c0e080e7          	jalr	-1010(ra) # 80201284 <printf>
    exit_proc(0);
    8020767e:	4501                	li	a0,0
    80207680:	fffff097          	auipc	ra,0xfffff
    80207684:	89c080e7          	jalr	-1892(ra) # 80205f1c <exit_proc>
}
    80207688:	0001                	nop
    8020768a:	70a2                	ld	ra,40(sp)
    8020768c:	7402                	ld	s0,32(sp)
    8020768e:	6145                	addi	sp,sp,48
    80207690:	8082                	ret

0000000080207692 <consumer_task>:
void consumer_task(void) {
    80207692:	1141                	addi	sp,sp,-16
    80207694:	e406                	sd	ra,8(sp)
    80207696:	e022                	sd	s0,0(sp)
    80207698:	0800                	addi	s0,sp,16
    while (!proc_produced) {
    8020769a:	a015                	j	802076be <consumer_task+0x2c>
		printf("wait for producer\n");
    8020769c:	00023517          	auipc	a0,0x23
    802076a0:	29c50513          	addi	a0,a0,668 # 8022a938 <user_test_table+0xea0>
    802076a4:	ffffa097          	auipc	ra,0xffffa
    802076a8:	be0080e7          	jalr	-1056(ra) # 80201284 <printf>
        sleep(&proc_produced,NULL); // 等待生产者
    802076ac:	4581                	li	a1,0
    802076ae:	00036517          	auipc	a0,0x36
    802076b2:	05e50513          	addi	a0,a0,94 # 8023d70c <proc_produced>
    802076b6:	ffffe097          	auipc	ra,0xffffe
    802076ba:	6cc080e7          	jalr	1740(ra) # 80205d82 <sleep>
    while (!proc_produced) {
    802076be:	00036797          	auipc	a5,0x36
    802076c2:	04e78793          	addi	a5,a5,78 # 8023d70c <proc_produced>
    802076c6:	439c                	lw	a5,0(a5)
    802076c8:	dbf1                	beqz	a5,8020769c <consumer_task+0xa>
    printf("Consumer: consumed value %d\n", proc_buffer);
    802076ca:	00036797          	auipc	a5,0x36
    802076ce:	03e78793          	addi	a5,a5,62 # 8023d708 <proc_buffer>
    802076d2:	439c                	lw	a5,0(a5)
    802076d4:	85be                	mv	a1,a5
    802076d6:	00023517          	auipc	a0,0x23
    802076da:	27a50513          	addi	a0,a0,634 # 8022a950 <user_test_table+0xeb8>
    802076de:	ffffa097          	auipc	ra,0xffffa
    802076e2:	ba6080e7          	jalr	-1114(ra) # 80201284 <printf>
    exit_proc(0);
    802076e6:	4501                	li	a0,0
    802076e8:	fffff097          	auipc	ra,0xfffff
    802076ec:	834080e7          	jalr	-1996(ra) # 80205f1c <exit_proc>
}
    802076f0:	0001                	nop
    802076f2:	60a2                	ld	ra,8(sp)
    802076f4:	6402                	ld	s0,0(sp)
    802076f6:	0141                	addi	sp,sp,16
    802076f8:	8082                	ret

00000000802076fa <test_synchronization>:
void test_synchronization(void) {
    802076fa:	1141                	addi	sp,sp,-16
    802076fc:	e406                	sd	ra,8(sp)
    802076fe:	e022                	sd	s0,0(sp)
    80207700:	0800                	addi	s0,sp,16
    printf("===== 测试开始: 同步机制测试 =====\n");
    80207702:	00023517          	auipc	a0,0x23
    80207706:	26e50513          	addi	a0,a0,622 # 8022a970 <user_test_table+0xed8>
    8020770a:	ffffa097          	auipc	ra,0xffffa
    8020770e:	b7a080e7          	jalr	-1158(ra) # 80201284 <printf>
    shared_buffer_init();
    80207712:	00000097          	auipc	ra,0x0
    80207716:	e5a080e7          	jalr	-422(ra) # 8020756c <shared_buffer_init>
    create_kernel_proc(producer_task);
    8020771a:	00000517          	auipc	a0,0x0
    8020771e:	e7850513          	addi	a0,a0,-392 # 80207592 <producer_task>
    80207722:	ffffe097          	auipc	ra,0xffffe
    80207726:	fa4080e7          	jalr	-92(ra) # 802056c6 <create_kernel_proc>
    create_kernel_proc(consumer_task);
    8020772a:	00000517          	auipc	a0,0x0
    8020772e:	f6850513          	addi	a0,a0,-152 # 80207692 <consumer_task>
    80207732:	ffffe097          	auipc	ra,0xffffe
    80207736:	f94080e7          	jalr	-108(ra) # 802056c6 <create_kernel_proc>
    wait_proc(NULL);
    8020773a:	4501                	li	a0,0
    8020773c:	fffff097          	auipc	ra,0xfffff
    80207740:	8aa080e7          	jalr	-1878(ra) # 80205fe6 <wait_proc>
    wait_proc(NULL);
    80207744:	4501                	li	a0,0
    80207746:	fffff097          	auipc	ra,0xfffff
    8020774a:	8a0080e7          	jalr	-1888(ra) # 80205fe6 <wait_proc>
    printf("===== 测试结束 =====\n");
    8020774e:	00023517          	auipc	a0,0x23
    80207752:	25250513          	addi	a0,a0,594 # 8022a9a0 <user_test_table+0xf08>
    80207756:	ffffa097          	auipc	ra,0xffffa
    8020775a:	b2e080e7          	jalr	-1234(ra) # 80201284 <printf>
}
    8020775e:	0001                	nop
    80207760:	60a2                	ld	ra,8(sp)
    80207762:	6402                	ld	s0,0(sp)
    80207764:	0141                	addi	sp,sp,16
    80207766:	8082                	ret

0000000080207768 <sys_access_task>:
void sys_access_task(void) {
    80207768:	1101                	addi	sp,sp,-32
    8020776a:	ec06                	sd	ra,24(sp)
    8020776c:	e822                	sd	s0,16(sp)
    8020776e:	1000                	addi	s0,sp,32
    volatile int *ptr = (int*)0x80200000; // 内核空间地址
    80207770:	40100793          	li	a5,1025
    80207774:	07d6                	slli	a5,a5,0x15
    80207776:	fef43423          	sd	a5,-24(s0)
    printf("SYS: try read kernel addr 0x80200000\n");
    8020777a:	00023517          	auipc	a0,0x23
    8020777e:	24650513          	addi	a0,a0,582 # 8022a9c0 <user_test_table+0xf28>
    80207782:	ffffa097          	auipc	ra,0xffffa
    80207786:	b02080e7          	jalr	-1278(ra) # 80201284 <printf>
    int val = *ptr;
    8020778a:	fe843783          	ld	a5,-24(s0)
    8020778e:	439c                	lw	a5,0(a5)
    80207790:	fef42223          	sw	a5,-28(s0)
    printf("SYS: read success, value=%d\n", val);
    80207794:	fe442783          	lw	a5,-28(s0)
    80207798:	85be                	mv	a1,a5
    8020779a:	00023517          	auipc	a0,0x23
    8020779e:	24e50513          	addi	a0,a0,590 # 8022a9e8 <user_test_table+0xf50>
    802077a2:	ffffa097          	auipc	ra,0xffffa
    802077a6:	ae2080e7          	jalr	-1310(ra) # 80201284 <printf>
    exit_proc(0);
    802077aa:	4501                	li	a0,0
    802077ac:	ffffe097          	auipc	ra,0xffffe
    802077b0:	770080e7          	jalr	1904(ra) # 80205f1c <exit_proc>
}
    802077b4:	0001                	nop
    802077b6:	60e2                	ld	ra,24(sp)
    802077b8:	6442                	ld	s0,16(sp)
    802077ba:	6105                	addi	sp,sp,32
    802077bc:	8082                	ret

00000000802077be <infinite_task>:
void infinite_task(void){
    802077be:	1101                	addi	sp,sp,-32
    802077c0:	ec06                	sd	ra,24(sp)
    802077c2:	e822                	sd	s0,16(sp)
    802077c4:	1000                	addi	s0,sp,32
	int count = 5000 ;
    802077c6:	6785                	lui	a5,0x1
    802077c8:	38878793          	addi	a5,a5,904 # 1388 <_entry-0x801fec78>
    802077cc:	fef42623          	sw	a5,-20(s0)
	while(count){
    802077d0:	a835                	j	8020780c <infinite_task+0x4e>
		count--;
    802077d2:	fec42783          	lw	a5,-20(s0)
    802077d6:	37fd                	addiw	a5,a5,-1
    802077d8:	fef42623          	sw	a5,-20(s0)
		if (count % 100 == 0)
    802077dc:	fec42783          	lw	a5,-20(s0)
    802077e0:	873e                	mv	a4,a5
    802077e2:	06400793          	li	a5,100
    802077e6:	02f767bb          	remw	a5,a4,a5
    802077ea:	2781                	sext.w	a5,a5
    802077ec:	ef81                	bnez	a5,80207804 <infinite_task+0x46>
			printf("count for %d\n",count);
    802077ee:	fec42783          	lw	a5,-20(s0)
    802077f2:	85be                	mv	a1,a5
    802077f4:	00023517          	auipc	a0,0x23
    802077f8:	21450513          	addi	a0,a0,532 # 8022aa08 <user_test_table+0xf70>
    802077fc:	ffffa097          	auipc	ra,0xffffa
    80207800:	a88080e7          	jalr	-1400(ra) # 80201284 <printf>
		yield();
    80207804:	ffffe097          	auipc	ra,0xffffe
    80207808:	4d8080e7          	jalr	1240(ra) # 80205cdc <yield>
	while(count){
    8020780c:	fec42783          	lw	a5,-20(s0)
    80207810:	2781                	sext.w	a5,a5
    80207812:	f3e1                	bnez	a5,802077d2 <infinite_task+0x14>
	warning("INFINITE TASK FINISH WITHOUT KILLED!!\n");
    80207814:	00023517          	auipc	a0,0x23
    80207818:	20450513          	addi	a0,a0,516 # 8022aa18 <user_test_table+0xf80>
    8020781c:	ffffa097          	auipc	ra,0xffffa
    80207820:	01e080e7          	jalr	30(ra) # 8020183a <warning>
}
    80207824:	0001                	nop
    80207826:	60e2                	ld	ra,24(sp)
    80207828:	6442                	ld	s0,16(sp)
    8020782a:	6105                	addi	sp,sp,32
    8020782c:	8082                	ret

000000008020782e <killer_task>:
void killer_task(uint64 kill_pid){
    8020782e:	7179                	addi	sp,sp,-48
    80207830:	f406                	sd	ra,40(sp)
    80207832:	f022                	sd	s0,32(sp)
    80207834:	1800                	addi	s0,sp,48
    80207836:	fca43c23          	sd	a0,-40(s0)
	int count = 500;
    8020783a:	1f400793          	li	a5,500
    8020783e:	fef42623          	sw	a5,-20(s0)
	while(count){
    80207842:	a81d                	j	80207878 <killer_task+0x4a>
		count--;
    80207844:	fec42783          	lw	a5,-20(s0)
    80207848:	37fd                	addiw	a5,a5,-1
    8020784a:	fef42623          	sw	a5,-20(s0)
		if(count % 100 == 0)
    8020784e:	fec42783          	lw	a5,-20(s0)
    80207852:	873e                	mv	a4,a5
    80207854:	06400793          	li	a5,100
    80207858:	02f767bb          	remw	a5,a4,a5
    8020785c:	2781                	sext.w	a5,a5
    8020785e:	eb89                	bnez	a5,80207870 <killer_task+0x42>
			printf("I see you!!!\n");
    80207860:	00023517          	auipc	a0,0x23
    80207864:	1e050513          	addi	a0,a0,480 # 8022aa40 <user_test_table+0xfa8>
    80207868:	ffffa097          	auipc	ra,0xffffa
    8020786c:	a1c080e7          	jalr	-1508(ra) # 80201284 <printf>
		yield();
    80207870:	ffffe097          	auipc	ra,0xffffe
    80207874:	46c080e7          	jalr	1132(ra) # 80205cdc <yield>
	while(count){
    80207878:	fec42783          	lw	a5,-20(s0)
    8020787c:	2781                	sext.w	a5,a5
    8020787e:	f3f9                	bnez	a5,80207844 <killer_task+0x16>
	kill_proc((int)kill_pid);
    80207880:	fd843783          	ld	a5,-40(s0)
    80207884:	2781                	sext.w	a5,a5
    80207886:	853e                	mv	a0,a5
    80207888:	ffffe097          	auipc	ra,0xffffe
    8020788c:	630080e7          	jalr	1584(ra) # 80205eb8 <kill_proc>
	printf("Killed proc %d\n",(int)kill_pid);
    80207890:	fd843783          	ld	a5,-40(s0)
    80207894:	2781                	sext.w	a5,a5
    80207896:	85be                	mv	a1,a5
    80207898:	00023517          	auipc	a0,0x23
    8020789c:	1b850513          	addi	a0,a0,440 # 8022aa50 <user_test_table+0xfb8>
    802078a0:	ffffa097          	auipc	ra,0xffffa
    802078a4:	9e4080e7          	jalr	-1564(ra) # 80201284 <printf>
	exit_proc(0);
    802078a8:	4501                	li	a0,0
    802078aa:	ffffe097          	auipc	ra,0xffffe
    802078ae:	672080e7          	jalr	1650(ra) # 80205f1c <exit_proc>
}
    802078b2:	0001                	nop
    802078b4:	70a2                	ld	ra,40(sp)
    802078b6:	7402                	ld	s0,32(sp)
    802078b8:	6145                	addi	sp,sp,48
    802078ba:	8082                	ret

00000000802078bc <victim_task>:
void victim_task(void){
    802078bc:	1101                	addi	sp,sp,-32
    802078be:	ec06                	sd	ra,24(sp)
    802078c0:	e822                	sd	s0,16(sp)
    802078c2:	1000                	addi	s0,sp,32
	int count =5000;
    802078c4:	6785                	lui	a5,0x1
    802078c6:	38878793          	addi	a5,a5,904 # 1388 <_entry-0x801fec78>
    802078ca:	fef42623          	sw	a5,-20(s0)
	while(count){
    802078ce:	a81d                	j	80207904 <victim_task+0x48>
		count--;
    802078d0:	fec42783          	lw	a5,-20(s0)
    802078d4:	37fd                	addiw	a5,a5,-1
    802078d6:	fef42623          	sw	a5,-20(s0)
		if(count % 100 == 0)
    802078da:	fec42783          	lw	a5,-20(s0)
    802078de:	873e                	mv	a4,a5
    802078e0:	06400793          	li	a5,100
    802078e4:	02f767bb          	remw	a5,a4,a5
    802078e8:	2781                	sext.w	a5,a5
    802078ea:	eb89                	bnez	a5,802078fc <victim_task+0x40>
			printf("Call for help!!\n");
    802078ec:	00023517          	auipc	a0,0x23
    802078f0:	17450513          	addi	a0,a0,372 # 8022aa60 <user_test_table+0xfc8>
    802078f4:	ffffa097          	auipc	ra,0xffffa
    802078f8:	990080e7          	jalr	-1648(ra) # 80201284 <printf>
		yield();
    802078fc:	ffffe097          	auipc	ra,0xffffe
    80207900:	3e0080e7          	jalr	992(ra) # 80205cdc <yield>
	while(count){
    80207904:	fec42783          	lw	a5,-20(s0)
    80207908:	2781                	sext.w	a5,a5
    8020790a:	f3f9                	bnez	a5,802078d0 <victim_task+0x14>
	printf("No one can kill me!\n");
    8020790c:	00023517          	auipc	a0,0x23
    80207910:	16c50513          	addi	a0,a0,364 # 8022aa78 <user_test_table+0xfe0>
    80207914:	ffffa097          	auipc	ra,0xffffa
    80207918:	970080e7          	jalr	-1680(ra) # 80201284 <printf>
	exit_proc(0);
    8020791c:	4501                	li	a0,0
    8020791e:	ffffe097          	auipc	ra,0xffffe
    80207922:	5fe080e7          	jalr	1534(ra) # 80205f1c <exit_proc>
}
    80207926:	0001                	nop
    80207928:	60e2                	ld	ra,24(sp)
    8020792a:	6442                	ld	s0,16(sp)
    8020792c:	6105                	addi	sp,sp,32
    8020792e:	8082                	ret

0000000080207930 <test_kill>:
void test_kill(void){
    80207930:	7179                	addi	sp,sp,-48
    80207932:	f406                	sd	ra,40(sp)
    80207934:	f022                	sd	s0,32(sp)
    80207936:	1800                	addi	s0,sp,48
	printf("\n----- 测试1: 创建后立即杀死 -----\n");
    80207938:	00023517          	auipc	a0,0x23
    8020793c:	15850513          	addi	a0,a0,344 # 8022aa90 <user_test_table+0xff8>
    80207940:	ffffa097          	auipc	ra,0xffffa
    80207944:	944080e7          	jalr	-1724(ra) # 80201284 <printf>
	int pid =create_kernel_proc(simple_task);
    80207948:	fffff517          	auipc	a0,0xfffff
    8020794c:	40650513          	addi	a0,a0,1030 # 80206d4e <simple_task>
    80207950:	ffffe097          	auipc	ra,0xffffe
    80207954:	d76080e7          	jalr	-650(ra) # 802056c6 <create_kernel_proc>
    80207958:	87aa                	mv	a5,a0
    8020795a:	fef42423          	sw	a5,-24(s0)
	printf("【测试】: 创建进程成功，PID: %d\n", pid);
    8020795e:	fe842783          	lw	a5,-24(s0)
    80207962:	85be                	mv	a1,a5
    80207964:	00023517          	auipc	a0,0x23
    80207968:	15c50513          	addi	a0,a0,348 # 8022aac0 <user_test_table+0x1028>
    8020796c:	ffffa097          	auipc	ra,0xffffa
    80207970:	918080e7          	jalr	-1768(ra) # 80201284 <printf>
	kill_proc(pid);
    80207974:	fe842783          	lw	a5,-24(s0)
    80207978:	853e                	mv	a0,a5
    8020797a:	ffffe097          	auipc	ra,0xffffe
    8020797e:	53e080e7          	jalr	1342(ra) # 80205eb8 <kill_proc>
	printf("【测试】: 等待被杀死的进程退出,此处被杀死的进程不会有输出...\n");
    80207982:	00023517          	auipc	a0,0x23
    80207986:	16e50513          	addi	a0,a0,366 # 8022aaf0 <user_test_table+0x1058>
    8020798a:	ffffa097          	auipc	ra,0xffffa
    8020798e:	8fa080e7          	jalr	-1798(ra) # 80201284 <printf>
	int ret =0;
    80207992:	fc042c23          	sw	zero,-40(s0)
	wait_proc(&ret);
    80207996:	fd840793          	addi	a5,s0,-40
    8020799a:	853e                	mv	a0,a5
    8020799c:	ffffe097          	auipc	ra,0xffffe
    802079a0:	64a080e7          	jalr	1610(ra) # 80205fe6 <wait_proc>
	printf("【测试】: 进程%d退出，退出码应该为129，此处为%d\n ",pid,ret);
    802079a4:	fd842703          	lw	a4,-40(s0)
    802079a8:	fe842783          	lw	a5,-24(s0)
    802079ac:	863a                	mv	a2,a4
    802079ae:	85be                	mv	a1,a5
    802079b0:	00023517          	auipc	a0,0x23
    802079b4:	1a050513          	addi	a0,a0,416 # 8022ab50 <user_test_table+0x10b8>
    802079b8:	ffffa097          	auipc	ra,0xffffa
    802079bc:	8cc080e7          	jalr	-1844(ra) # 80201284 <printf>
	if(SYS_kill == ret){
    802079c0:	fd842783          	lw	a5,-40(s0)
    802079c4:	873e                	mv	a4,a5
    802079c6:	08100793          	li	a5,129
    802079ca:	00f71b63          	bne	a4,a5,802079e0 <test_kill+0xb0>
		printf("【测试】:尝试立即杀死进程，测试成功\n");
    802079ce:	00023517          	auipc	a0,0x23
    802079d2:	1ca50513          	addi	a0,a0,458 # 8022ab98 <user_test_table+0x1100>
    802079d6:	ffffa097          	auipc	ra,0xffffa
    802079da:	8ae080e7          	jalr	-1874(ra) # 80201284 <printf>
    802079de:	a831                	j	802079fa <test_kill+0xca>
		printf("【测试】:尝试立即杀死进程失败，退出\n");
    802079e0:	00023517          	auipc	a0,0x23
    802079e4:	1f050513          	addi	a0,a0,496 # 8022abd0 <user_test_table+0x1138>
    802079e8:	ffffa097          	auipc	ra,0xffffa
    802079ec:	89c080e7          	jalr	-1892(ra) # 80201284 <printf>
		exit_proc(0);
    802079f0:	4501                	li	a0,0
    802079f2:	ffffe097          	auipc	ra,0xffffe
    802079f6:	52a080e7          	jalr	1322(ra) # 80205f1c <exit_proc>
	printf("\n----- 测试2: 创建后稍后杀死 -----\n");
    802079fa:	00023517          	auipc	a0,0x23
    802079fe:	20e50513          	addi	a0,a0,526 # 8022ac08 <user_test_table+0x1170>
    80207a02:	ffffa097          	auipc	ra,0xffffa
    80207a06:	882080e7          	jalr	-1918(ra) # 80201284 <printf>
	pid = create_kernel_proc(infinite_task);
    80207a0a:	00000517          	auipc	a0,0x0
    80207a0e:	db450513          	addi	a0,a0,-588 # 802077be <infinite_task>
    80207a12:	ffffe097          	auipc	ra,0xffffe
    80207a16:	cb4080e7          	jalr	-844(ra) # 802056c6 <create_kernel_proc>
    80207a1a:	87aa                	mv	a5,a0
    80207a1c:	fef42423          	sw	a5,-24(s0)
	int count = 500;
    80207a20:	1f400793          	li	a5,500
    80207a24:	fef42623          	sw	a5,-20(s0)
	while(count){
    80207a28:	a811                	j	80207a3c <test_kill+0x10c>
		count--; //等待500次调度
    80207a2a:	fec42783          	lw	a5,-20(s0)
    80207a2e:	37fd                	addiw	a5,a5,-1
    80207a30:	fef42623          	sw	a5,-20(s0)
		yield();
    80207a34:	ffffe097          	auipc	ra,0xffffe
    80207a38:	2a8080e7          	jalr	680(ra) # 80205cdc <yield>
	while(count){
    80207a3c:	fec42783          	lw	a5,-20(s0)
    80207a40:	2781                	sext.w	a5,a5
    80207a42:	f7e5                	bnez	a5,80207a2a <test_kill+0xfa>
	kill_proc(pid);
    80207a44:	fe842783          	lw	a5,-24(s0)
    80207a48:	853e                	mv	a0,a5
    80207a4a:	ffffe097          	auipc	ra,0xffffe
    80207a4e:	46e080e7          	jalr	1134(ra) # 80205eb8 <kill_proc>
	wait_proc(&ret);
    80207a52:	fd840793          	addi	a5,s0,-40
    80207a56:	853e                	mv	a0,a5
    80207a58:	ffffe097          	auipc	ra,0xffffe
    80207a5c:	58e080e7          	jalr	1422(ra) # 80205fe6 <wait_proc>
	if(SYS_kill == ret){
    80207a60:	fd842783          	lw	a5,-40(s0)
    80207a64:	873e                	mv	a4,a5
    80207a66:	08100793          	li	a5,129
    80207a6a:	00f71b63          	bne	a4,a5,80207a80 <test_kill+0x150>
		printf("【测试】:尝试稍后杀死进程，测试成功\n");
    80207a6e:	00023517          	auipc	a0,0x23
    80207a72:	1ca50513          	addi	a0,a0,458 # 8022ac38 <user_test_table+0x11a0>
    80207a76:	ffffa097          	auipc	ra,0xffffa
    80207a7a:	80e080e7          	jalr	-2034(ra) # 80201284 <printf>
    80207a7e:	a831                	j	80207a9a <test_kill+0x16a>
		printf("【测试】:尝试稍后杀死进程失败，退出\n");
    80207a80:	00023517          	auipc	a0,0x23
    80207a84:	1f050513          	addi	a0,a0,496 # 8022ac70 <user_test_table+0x11d8>
    80207a88:	ffff9097          	auipc	ra,0xffff9
    80207a8c:	7fc080e7          	jalr	2044(ra) # 80201284 <printf>
		exit_proc(0);
    80207a90:	4501                	li	a0,0
    80207a92:	ffffe097          	auipc	ra,0xffffe
    80207a96:	48a080e7          	jalr	1162(ra) # 80205f1c <exit_proc>
	printf("\n----- 测试3: 创建killer 和 victim -----\n");
    80207a9a:	00023517          	auipc	a0,0x23
    80207a9e:	20e50513          	addi	a0,a0,526 # 8022aca8 <user_test_table+0x1210>
    80207aa2:	ffff9097          	auipc	ra,0xffff9
    80207aa6:	7e2080e7          	jalr	2018(ra) # 80201284 <printf>
	int victim = create_kernel_proc(victim_task);
    80207aaa:	00000517          	auipc	a0,0x0
    80207aae:	e1250513          	addi	a0,a0,-494 # 802078bc <victim_task>
    80207ab2:	ffffe097          	auipc	ra,0xffffe
    80207ab6:	c14080e7          	jalr	-1004(ra) # 802056c6 <create_kernel_proc>
    80207aba:	87aa                	mv	a5,a0
    80207abc:	fef42223          	sw	a5,-28(s0)
	int killer = create_kernel_proc1(killer_task,victim);
    80207ac0:	fe442783          	lw	a5,-28(s0)
    80207ac4:	85be                	mv	a1,a5
    80207ac6:	00000517          	auipc	a0,0x0
    80207aca:	d6850513          	addi	a0,a0,-664 # 8020782e <killer_task>
    80207ace:	ffffe097          	auipc	ra,0xffffe
    80207ad2:	c96080e7          	jalr	-874(ra) # 80205764 <create_kernel_proc1>
    80207ad6:	87aa                	mv	a5,a0
    80207ad8:	fef42023          	sw	a5,-32(s0)
	int first_exit = wait_proc(&ret);
    80207adc:	fd840793          	addi	a5,s0,-40
    80207ae0:	853e                	mv	a0,a5
    80207ae2:	ffffe097          	auipc	ra,0xffffe
    80207ae6:	504080e7          	jalr	1284(ra) # 80205fe6 <wait_proc>
    80207aea:	87aa                	mv	a5,a0
    80207aec:	fcf42e23          	sw	a5,-36(s0)
	if(first_exit == killer){
    80207af0:	fdc42783          	lw	a5,-36(s0)
    80207af4:	873e                	mv	a4,a5
    80207af6:	fe042783          	lw	a5,-32(s0)
    80207afa:	2701                	sext.w	a4,a4
    80207afc:	2781                	sext.w	a5,a5
    80207afe:	04f71263          	bne	a4,a5,80207b42 <test_kill+0x212>
		wait_proc(&ret);
    80207b02:	fd840793          	addi	a5,s0,-40
    80207b06:	853e                	mv	a0,a5
    80207b08:	ffffe097          	auipc	ra,0xffffe
    80207b0c:	4de080e7          	jalr	1246(ra) # 80205fe6 <wait_proc>
		if(SYS_kill == ret){
    80207b10:	fd842783          	lw	a5,-40(s0)
    80207b14:	873e                	mv	a4,a5
    80207b16:	08100793          	li	a5,129
    80207b1a:	00f71b63          	bne	a4,a5,80207b30 <test_kill+0x200>
			printf("【测试】:killer win\n");
    80207b1e:	00023517          	auipc	a0,0x23
    80207b22:	1ba50513          	addi	a0,a0,442 # 8022acd8 <user_test_table+0x1240>
    80207b26:	ffff9097          	auipc	ra,0xffff9
    80207b2a:	75e080e7          	jalr	1886(ra) # 80201284 <printf>
    80207b2e:	a085                	j	80207b8e <test_kill+0x25e>
			printf("【测试】:出现问题，killer先结束但victim存活\n");
    80207b30:	00023517          	auipc	a0,0x23
    80207b34:	1c850513          	addi	a0,a0,456 # 8022acf8 <user_test_table+0x1260>
    80207b38:	ffff9097          	auipc	ra,0xffff9
    80207b3c:	74c080e7          	jalr	1868(ra) # 80201284 <printf>
    80207b40:	a0b9                	j	80207b8e <test_kill+0x25e>
	}else if(first_exit == victim){
    80207b42:	fdc42783          	lw	a5,-36(s0)
    80207b46:	873e                	mv	a4,a5
    80207b48:	fe442783          	lw	a5,-28(s0)
    80207b4c:	2701                	sext.w	a4,a4
    80207b4e:	2781                	sext.w	a5,a5
    80207b50:	02f71f63          	bne	a4,a5,80207b8e <test_kill+0x25e>
		wait_proc(NULL);
    80207b54:	4501                	li	a0,0
    80207b56:	ffffe097          	auipc	ra,0xffffe
    80207b5a:	490080e7          	jalr	1168(ra) # 80205fe6 <wait_proc>
		if(SYS_kill == ret){
    80207b5e:	fd842783          	lw	a5,-40(s0)
    80207b62:	873e                	mv	a4,a5
    80207b64:	08100793          	li	a5,129
    80207b68:	00f71b63          	bne	a4,a5,80207b7e <test_kill+0x24e>
			printf("【测试】:killer win\n");
    80207b6c:	00023517          	auipc	a0,0x23
    80207b70:	16c50513          	addi	a0,a0,364 # 8022acd8 <user_test_table+0x1240>
    80207b74:	ffff9097          	auipc	ra,0xffff9
    80207b78:	710080e7          	jalr	1808(ra) # 80201284 <printf>
    80207b7c:	a809                	j	80207b8e <test_kill+0x25e>
			printf("【测试】:出现问题，victim先结束且存活\n");
    80207b7e:	00023517          	auipc	a0,0x23
    80207b82:	1ba50513          	addi	a0,a0,442 # 8022ad38 <user_test_table+0x12a0>
    80207b86:	ffff9097          	auipc	ra,0xffff9
    80207b8a:	6fe080e7          	jalr	1790(ra) # 80201284 <printf>
	exit_proc(0);
    80207b8e:	4501                	li	a0,0
    80207b90:	ffffe097          	auipc	ra,0xffffe
    80207b94:	38c080e7          	jalr	908(ra) # 80205f1c <exit_proc>
}
    80207b98:	0001                	nop
    80207b9a:	70a2                	ld	ra,40(sp)
    80207b9c:	7402                	ld	s0,32(sp)
    80207b9e:	6145                	addi	sp,sp,48
    80207ba0:	8082                	ret

0000000080207ba2 <test_filesystem_integrity>:
void test_filesystem_integrity(void) {
    80207ba2:	7135                	addi	sp,sp,-160
    80207ba4:	ed06                	sd	ra,152(sp)
    80207ba6:	e922                	sd	s0,144(sp)
    80207ba8:	e526                	sd	s1,136(sp)
    80207baa:	1100                	addi	s0,sp,160
    printf("Testing filesystem integrity (kernel mode)...\n");
    80207bac:	00023517          	auipc	a0,0x23
    80207bb0:	1c450513          	addi	a0,a0,452 # 8022ad70 <user_test_table+0x12d8>
    80207bb4:	ffff9097          	auipc	ra,0xffff9
    80207bb8:	6d0080e7          	jalr	1744(ra) # 80201284 <printf>
    const char *filename = "testfile";
    80207bbc:	00023797          	auipc	a5,0x23
    80207bc0:	1e478793          	addi	a5,a5,484 # 8022ada0 <user_test_table+0x1308>
    80207bc4:	fcf43c23          	sd	a5,-40(s0)
    printf("Creating/opening file: %s\n", filename);
    80207bc8:	fd843583          	ld	a1,-40(s0)
    80207bcc:	00023517          	auipc	a0,0x23
    80207bd0:	1e450513          	addi	a0,a0,484 # 8022adb0 <user_test_table+0x1318>
    80207bd4:	ffff9097          	auipc	ra,0xffff9
    80207bd8:	6b0080e7          	jalr	1712(ra) # 80201284 <printf>
    struct inode *ip = create((char *)filename, T_FILE, 0, 0);
    80207bdc:	4681                	li	a3,0
    80207bde:	4601                	li	a2,0
    80207be0:	4589                	li	a1,2
    80207be2:	fd843503          	ld	a0,-40(s0)
    80207be6:	00004097          	auipc	ra,0x4
    80207bea:	18c080e7          	jalr	396(ra) # 8020bd72 <create>
    80207bee:	fca43823          	sd	a0,-48(s0)
    assert(ip != NULL);
    80207bf2:	fd043783          	ld	a5,-48(s0)
    80207bf6:	00f037b3          	snez	a5,a5
    80207bfa:	0ff7f793          	zext.b	a5,a5
    80207bfe:	2781                	sext.w	a5,a5
    80207c00:	853e                	mv	a0,a5
    80207c02:	fffff097          	auipc	ra,0xfffff
    80207c06:	ba4080e7          	jalr	-1116(ra) # 802067a6 <assert>
    struct file *f = fileopen(ip, 1, 1); // 可读可写
    80207c0a:	4605                	li	a2,1
    80207c0c:	4585                	li	a1,1
    80207c0e:	fd043503          	ld	a0,-48(s0)
    80207c12:	00002097          	auipc	ra,0x2
    80207c16:	f26080e7          	jalr	-218(ra) # 80209b38 <fileopen>
    80207c1a:	fca43423          	sd	a0,-56(s0)
    assert(f != NULL);
    80207c1e:	fc843783          	ld	a5,-56(s0)
    80207c22:	00f037b3          	snez	a5,a5
    80207c26:	0ff7f793          	zext.b	a5,a5
    80207c2a:	2781                	sext.w	a5,a5
    80207c2c:	853e                	mv	a0,a5
    80207c2e:	fffff097          	auipc	ra,0xfffff
    80207c32:	b78080e7          	jalr	-1160(ra) # 802067a6 <assert>
    printf("File opened for write: %s\n", filename);
    80207c36:	fd843583          	ld	a1,-40(s0)
    80207c3a:	00023517          	auipc	a0,0x23
    80207c3e:	19650513          	addi	a0,a0,406 # 8022add0 <user_test_table+0x1338>
    80207c42:	ffff9097          	auipc	ra,0xffff9
    80207c46:	642080e7          	jalr	1602(ra) # 80201284 <printf>
    char buffer[] = "Hello, filesystem!";
    80207c4a:	00023797          	auipc	a5,0x23
    80207c4e:	2c678793          	addi	a5,a5,710 # 8022af10 <user_test_table+0x1478>
    80207c52:	6394                	ld	a3,0(a5)
    80207c54:	6798                	ld	a4,8(a5)
    80207c56:	fad43423          	sd	a3,-88(s0)
    80207c5a:	fae43823          	sd	a4,-80(s0)
    80207c5e:	0107d703          	lhu	a4,16(a5)
    80207c62:	fae41c23          	sh	a4,-72(s0)
    80207c66:	0127c783          	lbu	a5,18(a5)
    80207c6a:	faf40d23          	sb	a5,-70(s0)
    printf("Writing data: \"%s\" (len=%lu)\n", buffer, strlen(buffer));
    80207c6e:	fa840793          	addi	a5,s0,-88
    80207c72:	853e                	mv	a0,a5
    80207c74:	ffffe097          	auipc	ra,0xffffe
    80207c78:	738080e7          	jalr	1848(ra) # 802063ac <strlen>
    80207c7c:	87aa                	mv	a5,a0
    80207c7e:	873e                	mv	a4,a5
    80207c80:	fa840793          	addi	a5,s0,-88
    80207c84:	863a                	mv	a2,a4
    80207c86:	85be                	mv	a1,a5
    80207c88:	00023517          	auipc	a0,0x23
    80207c8c:	16850513          	addi	a0,a0,360 # 8022adf0 <user_test_table+0x1358>
    80207c90:	ffff9097          	auipc	ra,0xffff9
    80207c94:	5f4080e7          	jalr	1524(ra) # 80201284 <printf>
    int bytes = write(f, (uint64)buffer, strlen(buffer));
    80207c98:	fa840493          	addi	s1,s0,-88
    80207c9c:	fa840793          	addi	a5,s0,-88
    80207ca0:	853e                	mv	a0,a5
    80207ca2:	ffffe097          	auipc	ra,0xffffe
    80207ca6:	70a080e7          	jalr	1802(ra) # 802063ac <strlen>
    80207caa:	87aa                	mv	a5,a0
    80207cac:	863e                	mv	a2,a5
    80207cae:	85a6                	mv	a1,s1
    80207cb0:	fc843503          	ld	a0,-56(s0)
    80207cb4:	00002097          	auipc	ra,0x2
    80207cb8:	50e080e7          	jalr	1294(ra) # 8020a1c2 <write>
    80207cbc:	87aa                	mv	a5,a0
    80207cbe:	fcf42223          	sw	a5,-60(s0)
    printf("Wrote %d bytes to file\n", bytes);
    80207cc2:	fc442783          	lw	a5,-60(s0)
    80207cc6:	85be                	mv	a1,a5
    80207cc8:	00023517          	auipc	a0,0x23
    80207ccc:	14850513          	addi	a0,a0,328 # 8022ae10 <user_test_table+0x1378>
    80207cd0:	ffff9097          	auipc	ra,0xffff9
    80207cd4:	5b4080e7          	jalr	1460(ra) # 80201284 <printf>
    assert(bytes == strlen(buffer));
    80207cd8:	fa840793          	addi	a5,s0,-88
    80207cdc:	853e                	mv	a0,a5
    80207cde:	ffffe097          	auipc	ra,0xffffe
    80207ce2:	6ce080e7          	jalr	1742(ra) # 802063ac <strlen>
    80207ce6:	87aa                	mv	a5,a0
    80207ce8:	873e                	mv	a4,a5
    80207cea:	fc442783          	lw	a5,-60(s0)
    80207cee:	2781                	sext.w	a5,a5
    80207cf0:	8f99                	sub	a5,a5,a4
    80207cf2:	0017b793          	seqz	a5,a5
    80207cf6:	0ff7f793          	zext.b	a5,a5
    80207cfa:	2781                	sext.w	a5,a5
    80207cfc:	853e                	mv	a0,a5
    80207cfe:	fffff097          	auipc	ra,0xfffff
    80207d02:	aa8080e7          	jalr	-1368(ra) # 802067a6 <assert>
    fileclose(f);
    80207d06:	fc843503          	ld	a0,-56(s0)
    80207d0a:	00002097          	auipc	ra,0x2
    80207d0e:	ea6080e7          	jalr	-346(ra) # 80209bb0 <fileclose>
    printf("File closed after write: %s\n", filename);
    80207d12:	fd843583          	ld	a1,-40(s0)
    80207d16:	00023517          	auipc	a0,0x23
    80207d1a:	11250513          	addi	a0,a0,274 # 8022ae28 <user_test_table+0x1390>
    80207d1e:	ffff9097          	auipc	ra,0xffff9
    80207d22:	566080e7          	jalr	1382(ra) # 80201284 <printf>
    ip = namei((char *)filename);
    80207d26:	fd843503          	ld	a0,-40(s0)
    80207d2a:	00004097          	auipc	ra,0x4
    80207d2e:	fee080e7          	jalr	-18(ra) # 8020bd18 <namei>
    80207d32:	fca43823          	sd	a0,-48(s0)
    assert(ip != NULL);
    80207d36:	fd043783          	ld	a5,-48(s0)
    80207d3a:	00f037b3          	snez	a5,a5
    80207d3e:	0ff7f793          	zext.b	a5,a5
    80207d42:	2781                	sext.w	a5,a5
    80207d44:	853e                	mv	a0,a5
    80207d46:	fffff097          	auipc	ra,0xfffff
    80207d4a:	a60080e7          	jalr	-1440(ra) # 802067a6 <assert>
    f = fileopen(ip, 1, 0); // 只读
    80207d4e:	4601                	li	a2,0
    80207d50:	4585                	li	a1,1
    80207d52:	fd043503          	ld	a0,-48(s0)
    80207d56:	00002097          	auipc	ra,0x2
    80207d5a:	de2080e7          	jalr	-542(ra) # 80209b38 <fileopen>
    80207d5e:	fca43423          	sd	a0,-56(s0)
    assert(f != NULL);
    80207d62:	fc843783          	ld	a5,-56(s0)
    80207d66:	00f037b3          	snez	a5,a5
    80207d6a:	0ff7f793          	zext.b	a5,a5
    80207d6e:	2781                	sext.w	a5,a5
    80207d70:	853e                	mv	a0,a5
    80207d72:	fffff097          	auipc	ra,0xfffff
    80207d76:	a34080e7          	jalr	-1484(ra) # 802067a6 <assert>
    printf("File opened for read: %s\n", filename);
    80207d7a:	fd843583          	ld	a1,-40(s0)
    80207d7e:	00023517          	auipc	a0,0x23
    80207d82:	0ca50513          	addi	a0,a0,202 # 8022ae48 <user_test_table+0x13b0>
    80207d86:	ffff9097          	auipc	ra,0xffff9
    80207d8a:	4fe080e7          	jalr	1278(ra) # 80201284 <printf>
    bytes = read(f, (uint64)read_buffer, sizeof(read_buffer) - 1);
    80207d8e:	f6840793          	addi	a5,s0,-152
    80207d92:	03f00613          	li	a2,63
    80207d96:	85be                	mv	a1,a5
    80207d98:	fc843503          	ld	a0,-56(s0)
    80207d9c:	00002097          	auipc	ra,0x2
    80207da0:	3be080e7          	jalr	958(ra) # 8020a15a <read>
    80207da4:	87aa                	mv	a5,a0
    80207da6:	fcf42223          	sw	a5,-60(s0)
    read_buffer[bytes] = '\0';
    80207daa:	fc442783          	lw	a5,-60(s0)
    80207dae:	1781                	addi	a5,a5,-32
    80207db0:	97a2                	add	a5,a5,s0
    80207db2:	f8078423          	sb	zero,-120(a5)
    printf("Read %d bytes from file\n", bytes);
    80207db6:	fc442783          	lw	a5,-60(s0)
    80207dba:	85be                	mv	a1,a5
    80207dbc:	00023517          	auipc	a0,0x23
    80207dc0:	0ac50513          	addi	a0,a0,172 # 8022ae68 <user_test_table+0x13d0>
    80207dc4:	ffff9097          	auipc	ra,0xffff9
    80207dc8:	4c0080e7          	jalr	1216(ra) # 80201284 <printf>
    printf("Read data: \"%s\"\n", read_buffer);
    80207dcc:	f6840793          	addi	a5,s0,-152
    80207dd0:	85be                	mv	a1,a5
    80207dd2:	00023517          	auipc	a0,0x23
    80207dd6:	0b650513          	addi	a0,a0,182 # 8022ae88 <user_test_table+0x13f0>
    80207dda:	ffff9097          	auipc	ra,0xffff9
    80207dde:	4aa080e7          	jalr	1194(ra) # 80201284 <printf>
    assert(strcmp(buffer, read_buffer) == 0);
    80207de2:	f6840713          	addi	a4,s0,-152
    80207de6:	fa840793          	addi	a5,s0,-88
    80207dea:	85ba                	mv	a1,a4
    80207dec:	853e                	mv	a0,a5
    80207dee:	ffffe097          	auipc	ra,0xffffe
    80207df2:	5f4080e7          	jalr	1524(ra) # 802063e2 <strcmp>
    80207df6:	87aa                	mv	a5,a0
    80207df8:	0017b793          	seqz	a5,a5
    80207dfc:	0ff7f793          	zext.b	a5,a5
    80207e00:	2781                	sext.w	a5,a5
    80207e02:	853e                	mv	a0,a5
    80207e04:	fffff097          	auipc	ra,0xfffff
    80207e08:	9a2080e7          	jalr	-1630(ra) # 802067a6 <assert>
    fileclose(f);
    80207e0c:	fc843503          	ld	a0,-56(s0)
    80207e10:	00002097          	auipc	ra,0x2
    80207e14:	da0080e7          	jalr	-608(ra) # 80209bb0 <fileclose>
    printf("File closed after read: %s\n", filename);
    80207e18:	fd843583          	ld	a1,-40(s0)
    80207e1c:	00023517          	auipc	a0,0x23
    80207e20:	08450513          	addi	a0,a0,132 # 8022aea0 <user_test_table+0x1408>
    80207e24:	ffff9097          	auipc	ra,0xffff9
    80207e28:	460080e7          	jalr	1120(ra) # 80201284 <printf>
    int unlink_ret = unlink((char *)filename);
    80207e2c:	fd843503          	ld	a0,-40(s0)
    80207e30:	00004097          	auipc	ra,0x4
    80207e34:	120080e7          	jalr	288(ra) # 8020bf50 <unlink>
    80207e38:	87aa                	mv	a5,a0
    80207e3a:	fcf42023          	sw	a5,-64(s0)
    printf("Unlink file: %s, result=%d\n", filename, unlink_ret);
    80207e3e:	fc042783          	lw	a5,-64(s0)
    80207e42:	863e                	mv	a2,a5
    80207e44:	fd843583          	ld	a1,-40(s0)
    80207e48:	00023517          	auipc	a0,0x23
    80207e4c:	07850513          	addi	a0,a0,120 # 8022aec0 <user_test_table+0x1428>
    80207e50:	ffff9097          	auipc	ra,0xffff9
    80207e54:	434080e7          	jalr	1076(ra) # 80201284 <printf>
    assert(unlink_ret == 0);
    80207e58:	fc042783          	lw	a5,-64(s0)
    80207e5c:	2781                	sext.w	a5,a5
    80207e5e:	0017b793          	seqz	a5,a5
    80207e62:	0ff7f793          	zext.b	a5,a5
    80207e66:	2781                	sext.w	a5,a5
    80207e68:	853e                	mv	a0,a5
    80207e6a:	fffff097          	auipc	ra,0xfffff
    80207e6e:	93c080e7          	jalr	-1732(ra) # 802067a6 <assert>
    printf("Filesystem integrity test passed (kernel mode)\n");
    80207e72:	00023517          	auipc	a0,0x23
    80207e76:	06e50513          	addi	a0,a0,110 # 8022aee0 <user_test_table+0x1448>
    80207e7a:	ffff9097          	auipc	ra,0xffff9
    80207e7e:	40a080e7          	jalr	1034(ra) # 80201284 <printf>
}
    80207e82:	0001                	nop
    80207e84:	60ea                	ld	ra,152(sp)
    80207e86:	644a                	ld	s0,144(sp)
    80207e88:	64aa                	ld	s1,136(sp)
    80207e8a:	610d                	addi	sp,sp,160
    80207e8c:	8082                	ret

0000000080207e8e <make_pid_string>:
void make_pid_string(char *buf, int pid) {
    80207e8e:	7139                	addi	sp,sp,-64
    80207e90:	fc06                	sd	ra,56(sp)
    80207e92:	f822                	sd	s0,48(sp)
    80207e94:	0080                	addi	s0,sp,64
    80207e96:	fca43423          	sd	a0,-56(s0)
    80207e9a:	87ae                	mv	a5,a1
    80207e9c:	fcf42223          	sw	a5,-60(s0)
    strcpy(buf, "my pid is ");
    80207ea0:	00023597          	auipc	a1,0x23
    80207ea4:	08858593          	addi	a1,a1,136 # 8022af28 <user_test_table+0x1490>
    80207ea8:	fc843503          	ld	a0,-56(s0)
    80207eac:	ffffe097          	auipc	ra,0xffffe
    80207eb0:	59c080e7          	jalr	1436(ra) # 80206448 <strcpy>
    int n = pid, i = 0;
    80207eb4:	fc442783          	lw	a5,-60(s0)
    80207eb8:	fef42023          	sw	a5,-32(s0)
    80207ebc:	fe042623          	sw	zero,-20(s0)
    if(n == 0) {
    80207ec0:	fe042783          	lw	a5,-32(s0)
    80207ec4:	2781                	sext.w	a5,a5
    80207ec6:	ef91                	bnez	a5,80207ee2 <make_pid_string+0x54>
        num[i++] = '0';
    80207ec8:	fec42783          	lw	a5,-20(s0)
    80207ecc:	0017871b          	addiw	a4,a5,1
    80207ed0:	fee42623          	sw	a4,-20(s0)
    80207ed4:	17c1                	addi	a5,a5,-16
    80207ed6:	97a2                	add	a5,a5,s0
    80207ed8:	03000713          	li	a4,48
    80207edc:	fee78023          	sb	a4,-32(a5)
    80207ee0:	a869                	j	80207f7a <make_pid_string+0xec>
        int tmp = n;
    80207ee2:	fe042783          	lw	a5,-32(s0)
    80207ee6:	fef42423          	sw	a5,-24(s0)
        while(tmp > 0) {
    80207eea:	a831                	j	80207f06 <make_pid_string+0x78>
            tmp /= 10;
    80207eec:	fe842783          	lw	a5,-24(s0)
    80207ef0:	873e                	mv	a4,a5
    80207ef2:	47a9                	li	a5,10
    80207ef4:	02f747bb          	divw	a5,a4,a5
    80207ef8:	fef42423          	sw	a5,-24(s0)
            i++;
    80207efc:	fec42783          	lw	a5,-20(s0)
    80207f00:	2785                	addiw	a5,a5,1
    80207f02:	fef42623          	sw	a5,-20(s0)
        while(tmp > 0) {
    80207f06:	fe842783          	lw	a5,-24(s0)
    80207f0a:	2781                	sext.w	a5,a5
    80207f0c:	fef040e3          	bgtz	a5,80207eec <make_pid_string+0x5e>
        num[i] = '\0';
    80207f10:	fec42783          	lw	a5,-20(s0)
    80207f14:	17c1                	addi	a5,a5,-16
    80207f16:	97a2                	add	a5,a5,s0
    80207f18:	fe078023          	sb	zero,-32(a5)
        tmp = n;
    80207f1c:	fe042783          	lw	a5,-32(s0)
    80207f20:	fef42423          	sw	a5,-24(s0)
        for(int j = i - 1; j >= 0; j--) {
    80207f24:	fec42783          	lw	a5,-20(s0)
    80207f28:	37fd                	addiw	a5,a5,-1
    80207f2a:	fef42223          	sw	a5,-28(s0)
    80207f2e:	a089                	j	80207f70 <make_pid_string+0xe2>
            num[j] = '0' + (tmp % 10);
    80207f30:	fe842783          	lw	a5,-24(s0)
    80207f34:	873e                	mv	a4,a5
    80207f36:	47a9                	li	a5,10
    80207f38:	02f767bb          	remw	a5,a4,a5
    80207f3c:	2781                	sext.w	a5,a5
    80207f3e:	0ff7f793          	zext.b	a5,a5
    80207f42:	0307879b          	addiw	a5,a5,48
    80207f46:	0ff7f713          	zext.b	a4,a5
    80207f4a:	fe442783          	lw	a5,-28(s0)
    80207f4e:	17c1                	addi	a5,a5,-16
    80207f50:	97a2                	add	a5,a5,s0
    80207f52:	fee78023          	sb	a4,-32(a5)
            tmp /= 10;
    80207f56:	fe842783          	lw	a5,-24(s0)
    80207f5a:	873e                	mv	a4,a5
    80207f5c:	47a9                	li	a5,10
    80207f5e:	02f747bb          	divw	a5,a4,a5
    80207f62:	fef42423          	sw	a5,-24(s0)
        for(int j = i - 1; j >= 0; j--) {
    80207f66:	fe442783          	lw	a5,-28(s0)
    80207f6a:	37fd                	addiw	a5,a5,-1
    80207f6c:	fef42223          	sw	a5,-28(s0)
    80207f70:	fe442783          	lw	a5,-28(s0)
    80207f74:	2781                	sext.w	a5,a5
    80207f76:	fa07dde3          	bgez	a5,80207f30 <make_pid_string+0xa2>
    strcat(buf, num);
    80207f7a:	fd040793          	addi	a5,s0,-48
    80207f7e:	85be                	mv	a1,a5
    80207f80:	fc843503          	ld	a0,-56(s0)
    80207f84:	ffffe097          	auipc	ra,0xffffe
    80207f88:	7c2080e7          	jalr	1986(ra) # 80206746 <strcat>
}
    80207f8c:	0001                	nop
    80207f8e:	70e2                	ld	ra,56(sp)
    80207f90:	7442                	ld	s0,48(sp)
    80207f92:	6121                	addi	sp,sp,64
    80207f94:	8082                	ret

0000000080207f96 <concurrent_child_task>:
void concurrent_child_task(uint64 filename_addr) {
    80207f96:	7131                	addi	sp,sp,-192
    80207f98:	fd06                	sd	ra,184(sp)
    80207f9a:	f922                	sd	s0,176(sp)
    80207f9c:	0180                	addi	s0,sp,192
    80207f9e:	f4a43423          	sd	a0,-184(s0)
    const char *filename = (const char *)filename_addr;
    80207fa2:	f4843783          	ld	a5,-184(s0)
    80207fa6:	fef43423          	sd	a5,-24(s0)
    struct inode *ip = namei((char *)filename);
    80207faa:	fe843503          	ld	a0,-24(s0)
    80207fae:	00004097          	auipc	ra,0x4
    80207fb2:	d6a080e7          	jalr	-662(ra) # 8020bd18 <namei>
    80207fb6:	fea43023          	sd	a0,-32(s0)
    assert(ip != NULL);
    80207fba:	fe043783          	ld	a5,-32(s0)
    80207fbe:	00f037b3          	snez	a5,a5
    80207fc2:	0ff7f793          	zext.b	a5,a5
    80207fc6:	2781                	sext.w	a5,a5
    80207fc8:	853e                	mv	a0,a5
    80207fca:	ffffe097          	auipc	ra,0xffffe
    80207fce:	7dc080e7          	jalr	2012(ra) # 802067a6 <assert>
    struct file *f = fileopen(ip, 1, 1); // 可读可写
    80207fd2:	4605                	li	a2,1
    80207fd4:	4585                	li	a1,1
    80207fd6:	fe043503          	ld	a0,-32(s0)
    80207fda:	00002097          	auipc	ra,0x2
    80207fde:	b5e080e7          	jalr	-1186(ra) # 80209b38 <fileopen>
    80207fe2:	fca43c23          	sd	a0,-40(s0)
    assert(f != NULL);
    80207fe6:	fd843783          	ld	a5,-40(s0)
    80207fea:	00f037b3          	snez	a5,a5
    80207fee:	0ff7f793          	zext.b	a5,a5
    80207ff2:	2781                	sext.w	a5,a5
    80207ff4:	853e                	mv	a0,a5
    80207ff6:	ffffe097          	auipc	ra,0xffffe
    80207ffa:	7b0080e7          	jalr	1968(ra) # 802067a6 <assert>
    int bytes = read(f, (uint64)read_buffer, sizeof(read_buffer) - 1);
    80207ffe:	f9040793          	addi	a5,s0,-112
    80208002:	03f00613          	li	a2,63
    80208006:	85be                	mv	a1,a5
    80208008:	fd843503          	ld	a0,-40(s0)
    8020800c:	00002097          	auipc	ra,0x2
    80208010:	14e080e7          	jalr	334(ra) # 8020a15a <read>
    80208014:	87aa                	mv	a5,a0
    80208016:	fcf42a23          	sw	a5,-44(s0)
    read_buffer[bytes] = '\0';
    8020801a:	fd442783          	lw	a5,-44(s0)
    8020801e:	17c1                	addi	a5,a5,-16
    80208020:	97a2                	add	a5,a5,s0
    80208022:	fa078023          	sb	zero,-96(a5)
    printf("[Child %d] Read from file: \"%s\"\n", myproc()->pid, read_buffer);
    80208026:	ffffd097          	auipc	ra,0xffffd
    8020802a:	03a080e7          	jalr	58(ra) # 80205060 <myproc>
    8020802e:	87aa                	mv	a5,a0
    80208030:	43dc                	lw	a5,4(a5)
    80208032:	f9040713          	addi	a4,s0,-112
    80208036:	863a                	mv	a2,a4
    80208038:	85be                	mv	a1,a5
    8020803a:	00023517          	auipc	a0,0x23
    8020803e:	efe50513          	addi	a0,a0,-258 # 8022af38 <user_test_table+0x14a0>
    80208042:	ffff9097          	auipc	ra,0xffff9
    80208046:	242080e7          	jalr	578(ra) # 80201284 <printf>
    make_pid_string(write_buffer, myproc()->pid);
    8020804a:	ffffd097          	auipc	ra,0xffffd
    8020804e:	016080e7          	jalr	22(ra) # 80205060 <myproc>
    80208052:	87aa                	mv	a5,a0
    80208054:	43d8                	lw	a4,4(a5)
    80208056:	f5040793          	addi	a5,s0,-176
    8020805a:	85ba                	mv	a1,a4
    8020805c:	853e                	mv	a0,a5
    8020805e:	00000097          	auipc	ra,0x0
    80208062:	e30080e7          	jalr	-464(ra) # 80207e8e <make_pid_string>
    int len = strlen(write_buffer);
    80208066:	f5040793          	addi	a5,s0,-176
    8020806a:	853e                	mv	a0,a5
    8020806c:	ffffe097          	auipc	ra,0xffffe
    80208070:	340080e7          	jalr	832(ra) # 802063ac <strlen>
    80208074:	87aa                	mv	a5,a0
    80208076:	fcf42823          	sw	a5,-48(s0)
	f->off = 0;
    8020807a:	fd843783          	ld	a5,-40(s0)
    8020807e:	0207a023          	sw	zero,32(a5)
    write(f, (uint64)write_buffer, len);
    80208082:	f5040793          	addi	a5,s0,-176
    80208086:	fd042703          	lw	a4,-48(s0)
    8020808a:	863a                	mv	a2,a4
    8020808c:	85be                	mv	a1,a5
    8020808e:	fd843503          	ld	a0,-40(s0)
    80208092:	00002097          	auipc	ra,0x2
    80208096:	130080e7          	jalr	304(ra) # 8020a1c2 <write>
    fileclose(f);
    8020809a:	fd843503          	ld	a0,-40(s0)
    8020809e:	00002097          	auipc	ra,0x2
    802080a2:	b12080e7          	jalr	-1262(ra) # 80209bb0 <fileclose>
    exit_proc(0);
    802080a6:	4501                	li	a0,0
    802080a8:	ffffe097          	auipc	ra,0xffffe
    802080ac:	e74080e7          	jalr	-396(ra) # 80205f1c <exit_proc>
}
    802080b0:	0001                	nop
    802080b2:	70ea                	ld	ra,184(sp)
    802080b4:	744a                	ld	s0,176(sp)
    802080b6:	6129                	addi	sp,sp,192
    802080b8:	8082                	ret

00000000802080ba <test_concurrent_access>:
void test_concurrent_access(void) {
    802080ba:	7155                	addi	sp,sp,-208
    802080bc:	e586                	sd	ra,200(sp)
    802080be:	e1a2                	sd	s0,192(sp)
    802080c0:	0980                	addi	s0,sp,208
    printf("Testing concurrent file access...\n");
    802080c2:	00023517          	auipc	a0,0x23
    802080c6:	e9e50513          	addi	a0,a0,-354 # 8022af60 <user_test_table+0x14c8>
    802080ca:	ffff9097          	auipc	ra,0xffff9
    802080ce:	1ba080e7          	jalr	442(ra) # 80201284 <printf>
    const char *filename = "concurrent_testfile";
    802080d2:	00023797          	auipc	a5,0x23
    802080d6:	eb678793          	addi	a5,a5,-330 # 8022af88 <user_test_table+0x14f0>
    802080da:	fef43023          	sd	a5,-32(s0)
    struct inode *ip = create((char *)filename, T_FILE, 0, 0);
    802080de:	4681                	li	a3,0
    802080e0:	4601                	li	a2,0
    802080e2:	4589                	li	a1,2
    802080e4:	fe043503          	ld	a0,-32(s0)
    802080e8:	00004097          	auipc	ra,0x4
    802080ec:	c8a080e7          	jalr	-886(ra) # 8020bd72 <create>
    802080f0:	fca43c23          	sd	a0,-40(s0)
    assert(ip != NULL);
    802080f4:	fd843783          	ld	a5,-40(s0)
    802080f8:	00f037b3          	snez	a5,a5
    802080fc:	0ff7f793          	zext.b	a5,a5
    80208100:	2781                	sext.w	a5,a5
    80208102:	853e                	mv	a0,a5
    80208104:	ffffe097          	auipc	ra,0xffffe
    80208108:	6a2080e7          	jalr	1698(ra) # 802067a6 <assert>
    struct file *f = fileopen(ip, 1, 1);
    8020810c:	4605                	li	a2,1
    8020810e:	4585                	li	a1,1
    80208110:	fd843503          	ld	a0,-40(s0)
    80208114:	00002097          	auipc	ra,0x2
    80208118:	a24080e7          	jalr	-1500(ra) # 80209b38 <fileopen>
    8020811c:	fca43823          	sd	a0,-48(s0)
    assert(f != NULL);
    80208120:	fd043783          	ld	a5,-48(s0)
    80208124:	00f037b3          	snez	a5,a5
    80208128:	0ff7f793          	zext.b	a5,a5
    8020812c:	2781                	sext.w	a5,a5
    8020812e:	853e                	mv	a0,a5
    80208130:	ffffe097          	auipc	ra,0xffffe
    80208134:	676080e7          	jalr	1654(ra) # 802067a6 <assert>
	make_pid_string(buffer, myproc()->pid);
    80208138:	ffffd097          	auipc	ra,0xffffd
    8020813c:	f28080e7          	jalr	-216(ra) # 80205060 <myproc>
    80208140:	87aa                	mv	a5,a0
    80208142:	43d8                	lw	a4,4(a5)
    80208144:	f8840793          	addi	a5,s0,-120
    80208148:	85ba                	mv	a1,a4
    8020814a:	853e                	mv	a0,a5
    8020814c:	00000097          	auipc	ra,0x0
    80208150:	d42080e7          	jalr	-702(ra) # 80207e8e <make_pid_string>
	int len = strlen(buffer);
    80208154:	f8840793          	addi	a5,s0,-120
    80208158:	853e                	mv	a0,a5
    8020815a:	ffffe097          	auipc	ra,0xffffe
    8020815e:	252080e7          	jalr	594(ra) # 802063ac <strlen>
    80208162:	87aa                	mv	a5,a0
    80208164:	fcf42623          	sw	a5,-52(s0)
	write(f, (uint64)buffer, len);
    80208168:	f8840793          	addi	a5,s0,-120
    8020816c:	fcc42703          	lw	a4,-52(s0)
    80208170:	863a                	mv	a2,a4
    80208172:	85be                	mv	a1,a5
    80208174:	fd043503          	ld	a0,-48(s0)
    80208178:	00002097          	auipc	ra,0x2
    8020817c:	04a080e7          	jalr	74(ra) # 8020a1c2 <write>
    fileclose(f);
    80208180:	fd043503          	ld	a0,-48(s0)
    80208184:	00002097          	auipc	ra,0x2
    80208188:	a2c080e7          	jalr	-1492(ra) # 80209bb0 <fileclose>
    printf("[Parent] Wrote initial content: \"%s\"\n", buffer);
    8020818c:	f8840793          	addi	a5,s0,-120
    80208190:	85be                	mv	a1,a5
    80208192:	00023517          	auipc	a0,0x23
    80208196:	e0e50513          	addi	a0,a0,-498 # 8022afa0 <user_test_table+0x1508>
    8020819a:	ffff9097          	auipc	ra,0xffff9
    8020819e:	0ea080e7          	jalr	234(ra) # 80201284 <printf>
    for (int i = 0; i < 3; i++) {
    802081a2:	fe042623          	sw	zero,-20(s0)
    802081a6:	a8a9                	j	80208200 <test_concurrent_access+0x146>
        child_pids[i] = create_kernel_proc1(concurrent_child_task, (uint64)filename);
    802081a8:	fe043783          	ld	a5,-32(s0)
    802081ac:	85be                	mv	a1,a5
    802081ae:	00000517          	auipc	a0,0x0
    802081b2:	de850513          	addi	a0,a0,-536 # 80207f96 <concurrent_child_task>
    802081b6:	ffffd097          	auipc	ra,0xffffd
    802081ba:	5ae080e7          	jalr	1454(ra) # 80205764 <create_kernel_proc1>
    802081be:	87aa                	mv	a5,a0
    802081c0:	873e                	mv	a4,a5
    802081c2:	fec42783          	lw	a5,-20(s0)
    802081c6:	078a                	slli	a5,a5,0x2
    802081c8:	17c1                	addi	a5,a5,-16
    802081ca:	97a2                	add	a5,a5,s0
    802081cc:	f8e7a423          	sw	a4,-120(a5)
        printf("[Parent] Created child %d, pid=%d\n", i, child_pids[i]);
    802081d0:	fec42783          	lw	a5,-20(s0)
    802081d4:	078a                	slli	a5,a5,0x2
    802081d6:	17c1                	addi	a5,a5,-16
    802081d8:	97a2                	add	a5,a5,s0
    802081da:	f887a703          	lw	a4,-120(a5)
    802081de:	fec42783          	lw	a5,-20(s0)
    802081e2:	863a                	mv	a2,a4
    802081e4:	85be                	mv	a1,a5
    802081e6:	00023517          	auipc	a0,0x23
    802081ea:	de250513          	addi	a0,a0,-542 # 8022afc8 <user_test_table+0x1530>
    802081ee:	ffff9097          	auipc	ra,0xffff9
    802081f2:	096080e7          	jalr	150(ra) # 80201284 <printf>
    for (int i = 0; i < 3; i++) {
    802081f6:	fec42783          	lw	a5,-20(s0)
    802081fa:	2785                	addiw	a5,a5,1
    802081fc:	fef42623          	sw	a5,-20(s0)
    80208200:	fec42783          	lw	a5,-20(s0)
    80208204:	0007871b          	sext.w	a4,a5
    80208208:	4789                	li	a5,2
    8020820a:	f8e7dfe3          	bge	a5,a4,802081a8 <test_concurrent_access+0xee>
    for (int i = 0; i < 3; i++) {
    8020820e:	fe042423          	sw	zero,-24(s0)
    80208212:	a819                	j	80208228 <test_concurrent_access+0x16e>
        wait_proc(NULL);
    80208214:	4501                	li	a0,0
    80208216:	ffffe097          	auipc	ra,0xffffe
    8020821a:	dd0080e7          	jalr	-560(ra) # 80205fe6 <wait_proc>
    for (int i = 0; i < 3; i++) {
    8020821e:	fe842783          	lw	a5,-24(s0)
    80208222:	2785                	addiw	a5,a5,1
    80208224:	fef42423          	sw	a5,-24(s0)
    80208228:	fe842783          	lw	a5,-24(s0)
    8020822c:	0007871b          	sext.w	a4,a5
    80208230:	4789                	li	a5,2
    80208232:	fee7d1e3          	bge	a5,a4,80208214 <test_concurrent_access+0x15a>
    ip = namei((char *)filename);
    80208236:	fe043503          	ld	a0,-32(s0)
    8020823a:	00004097          	auipc	ra,0x4
    8020823e:	ade080e7          	jalr	-1314(ra) # 8020bd18 <namei>
    80208242:	fca43c23          	sd	a0,-40(s0)
    assert(ip != NULL);
    80208246:	fd843783          	ld	a5,-40(s0)
    8020824a:	00f037b3          	snez	a5,a5
    8020824e:	0ff7f793          	zext.b	a5,a5
    80208252:	2781                	sext.w	a5,a5
    80208254:	853e                	mv	a0,a5
    80208256:	ffffe097          	auipc	ra,0xffffe
    8020825a:	550080e7          	jalr	1360(ra) # 802067a6 <assert>
    f = fileopen(ip, 1, 0); // 只读
    8020825e:	4601                	li	a2,0
    80208260:	4585                	li	a1,1
    80208262:	fd843503          	ld	a0,-40(s0)
    80208266:	00002097          	auipc	ra,0x2
    8020826a:	8d2080e7          	jalr	-1838(ra) # 80209b38 <fileopen>
    8020826e:	fca43823          	sd	a0,-48(s0)
    assert(f != NULL);
    80208272:	fd043783          	ld	a5,-48(s0)
    80208276:	00f037b3          	snez	a5,a5
    8020827a:	0ff7f793          	zext.b	a5,a5
    8020827e:	2781                	sext.w	a5,a5
    80208280:	853e                	mv	a0,a5
    80208282:	ffffe097          	auipc	ra,0xffffe
    80208286:	524080e7          	jalr	1316(ra) # 802067a6 <assert>
    int bytes = read(f, (uint64)final_buffer, sizeof(final_buffer) - 1);
    8020828a:	f3840793          	addi	a5,s0,-200
    8020828e:	03f00613          	li	a2,63
    80208292:	85be                	mv	a1,a5
    80208294:	fd043503          	ld	a0,-48(s0)
    80208298:	00002097          	auipc	ra,0x2
    8020829c:	ec2080e7          	jalr	-318(ra) # 8020a15a <read>
    802082a0:	87aa                	mv	a5,a0
    802082a2:	fcf42423          	sw	a5,-56(s0)
    final_buffer[bytes] = '\0';
    802082a6:	fc842783          	lw	a5,-56(s0)
    802082aa:	17c1                	addi	a5,a5,-16
    802082ac:	97a2                	add	a5,a5,s0
    802082ae:	f4078423          	sb	zero,-184(a5)
    printf("[Parent] Final file content: \"%s\"\n", final_buffer);
    802082b2:	f3840793          	addi	a5,s0,-200
    802082b6:	85be                	mv	a1,a5
    802082b8:	00023517          	auipc	a0,0x23
    802082bc:	d3850513          	addi	a0,a0,-712 # 8022aff0 <user_test_table+0x1558>
    802082c0:	ffff9097          	auipc	ra,0xffff9
    802082c4:	fc4080e7          	jalr	-60(ra) # 80201284 <printf>
    fileclose(f);
    802082c8:	fd043503          	ld	a0,-48(s0)
    802082cc:	00002097          	auipc	ra,0x2
    802082d0:	8e4080e7          	jalr	-1820(ra) # 80209bb0 <fileclose>
    printf("Concurrent access test finished.\n");
    802082d4:	00023517          	auipc	a0,0x23
    802082d8:	d4450513          	addi	a0,a0,-700 # 8022b018 <user_test_table+0x1580>
    802082dc:	ffff9097          	auipc	ra,0xffff9
    802082e0:	fa8080e7          	jalr	-88(ra) # 80201284 <printf>
    802082e4:	0001                	nop
    802082e6:	60ae                	ld	ra,200(sp)
    802082e8:	640e                	ld	s0,192(sp)
    802082ea:	6169                	addi	sp,sp,208
    802082ec:	8082                	ret

00000000802082ee <virtio_disk_init>:
#define R(r) ((volatile uint32 *)(VIRTIO0 + (r)))
static struct disk disk;

void
virtio_disk_init(void)
{
    802082ee:	7179                	addi	sp,sp,-48
    802082f0:	f406                	sd	ra,40(sp)
    802082f2:	f022                	sd	s0,32(sp)
    802082f4:	1800                	addi	s0,sp,48
  uint32 status = 0;
    802082f6:	fe042423          	sw	zero,-24(s0)

  initlock(&disk.vdisk_lock, "virtio_disk");
    802082fa:	00025597          	auipc	a1,0x25
    802082fe:	df658593          	addi	a1,a1,-522 # 8022d0f0 <user_test_table+0x78>
    80208302:	00035517          	auipc	a0,0x35
    80208306:	63e50513          	addi	a0,a0,1598 # 8023d940 <disk+0x230>
    8020830a:	00004097          	auipc	ra,0x4
    8020830e:	e06080e7          	jalr	-506(ra) # 8020c110 <initlock>

  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80208312:	100017b7          	lui	a5,0x10001
    80208316:	439c                	lw	a5,0(a5)
    80208318:	2781                	sext.w	a5,a5
    8020831a:	873e                	mv	a4,a5
    8020831c:	747277b7          	lui	a5,0x74727
    80208320:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xbad968a>
    80208324:	04f71063          	bne	a4,a5,80208364 <virtio_disk_init+0x76>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80208328:	100017b7          	lui	a5,0x10001
    8020832c:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x701feffc>
    8020832e:	439c                	lw	a5,0(a5)
    80208330:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80208332:	873e                	mv	a4,a5
    80208334:	4789                	li	a5,2
    80208336:	02f71763          	bne	a4,a5,80208364 <virtio_disk_init+0x76>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8020833a:	100017b7          	lui	a5,0x10001
    8020833e:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x701feff8>
    80208340:	439c                	lw	a5,0(a5)
    80208342:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80208344:	873e                	mv	a4,a5
    80208346:	4789                	li	a5,2
    80208348:	00f71e63          	bne	a4,a5,80208364 <virtio_disk_init+0x76>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8020834c:	100017b7          	lui	a5,0x10001
    80208350:	07b1                	addi	a5,a5,12 # 1000100c <_entry-0x701feff4>
    80208352:	439c                	lw	a5,0(a5)
    80208354:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80208356:	873e                	mv	a4,a5
    80208358:	554d47b7          	lui	a5,0x554d4
    8020835c:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ad2baaf>
    80208360:	00f70a63          	beq	a4,a5,80208374 <virtio_disk_init+0x86>
    panic("could not find virtio disk");
    80208364:	00025517          	auipc	a0,0x25
    80208368:	d9c50513          	addi	a0,a0,-612 # 8022d100 <user_test_table+0x88>
    8020836c:	ffff9097          	auipc	ra,0xffff9
    80208370:	49a080e7          	jalr	1178(ra) # 80201806 <panic>
  }
  
  // reset device
  *R(VIRTIO_MMIO_STATUS) = status;
    80208374:	100017b7          	lui	a5,0x10001
    80208378:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x701fef90>
    8020837c:	fe842703          	lw	a4,-24(s0)
    80208380:	c398                	sw	a4,0(a5)

  // set ACKNOWLEDGE status bit
  status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
    80208382:	fe842783          	lw	a5,-24(s0)
    80208386:	0017e793          	ori	a5,a5,1
    8020838a:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    8020838e:	100017b7          	lui	a5,0x10001
    80208392:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x701fef90>
    80208396:	fe842703          	lw	a4,-24(s0)
    8020839a:	c398                	sw	a4,0(a5)

  // set DRIVER status bit
  status |= VIRTIO_CONFIG_S_DRIVER;
    8020839c:	fe842783          	lw	a5,-24(s0)
    802083a0:	0027e793          	ori	a5,a5,2
    802083a4:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    802083a8:	100017b7          	lui	a5,0x10001
    802083ac:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x701fef90>
    802083b0:	fe842703          	lw	a4,-24(s0)
    802083b4:	c398                	sw	a4,0(a5)

  // negotiate features
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    802083b6:	100017b7          	lui	a5,0x10001
    802083ba:	07c1                	addi	a5,a5,16 # 10001010 <_entry-0x701feff0>
    802083bc:	439c                	lw	a5,0(a5)
    802083be:	2781                	sext.w	a5,a5
    802083c0:	1782                	slli	a5,a5,0x20
    802083c2:	9381                	srli	a5,a5,0x20
    802083c4:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_RO);
    802083c8:	fe043783          	ld	a5,-32(s0)
    802083cc:	fdf7f793          	andi	a5,a5,-33
    802083d0:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_SCSI);
    802083d4:	fe043783          	ld	a5,-32(s0)
    802083d8:	f7f7f793          	andi	a5,a5,-129
    802083dc:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_CONFIG_WCE);
    802083e0:	fe043703          	ld	a4,-32(s0)
    802083e4:	77fd                	lui	a5,0xfffff
    802083e6:	7ff78793          	addi	a5,a5,2047 # fffffffffffff7ff <_bss_end+0xffffffff7fdb6ecf>
    802083ea:	8ff9                	and	a5,a5,a4
    802083ec:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_MQ);
    802083f0:	fe043703          	ld	a4,-32(s0)
    802083f4:	77fd                	lui	a5,0xfffff
    802083f6:	17fd                	addi	a5,a5,-1 # ffffffffffffefff <_bss_end+0xffffffff7fdb66cf>
    802083f8:	8ff9                	and	a5,a5,a4
    802083fa:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_F_ANY_LAYOUT);
    802083fe:	fe043703          	ld	a4,-32(s0)
    80208402:	f80007b7          	lui	a5,0xf8000
    80208406:	17fd                	addi	a5,a5,-1 # fffffffff7ffffff <_bss_end+0xffffffff77db76cf>
    80208408:	8ff9                	and	a5,a5,a4
    8020840a:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_RING_F_EVENT_IDX);
    8020840e:	fe043703          	ld	a4,-32(s0)
    80208412:	e00007b7          	lui	a5,0xe0000
    80208416:	17fd                	addi	a5,a5,-1 # ffffffffdfffffff <_bss_end+0xffffffff5fdb76cf>
    80208418:	8ff9                	and	a5,a5,a4
    8020841a:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8020841e:	fe043703          	ld	a4,-32(s0)
    80208422:	f00007b7          	lui	a5,0xf0000
    80208426:	17fd                	addi	a5,a5,-1 # ffffffffefffffff <_bss_end+0xffffffff6fdb76cf>
    80208428:	8ff9                	and	a5,a5,a4
    8020842a:	fef43023          	sd	a5,-32(s0)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8020842e:	100017b7          	lui	a5,0x10001
    80208432:	02078793          	addi	a5,a5,32 # 10001020 <_entry-0x701fefe0>
    80208436:	fe043703          	ld	a4,-32(s0)
    8020843a:	2701                	sext.w	a4,a4
    8020843c:	c398                	sw	a4,0(a5)

  // tell device that feature negotiation is complete.
  status |= VIRTIO_CONFIG_S_FEATURES_OK;
    8020843e:	fe842783          	lw	a5,-24(s0)
    80208442:	0087e793          	ori	a5,a5,8
    80208446:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    8020844a:	100017b7          	lui	a5,0x10001
    8020844e:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x701fef90>
    80208452:	fe842703          	lw	a4,-24(s0)
    80208456:	c398                	sw	a4,0(a5)
  // re-read status to ensure FEATURES_OK is set.
  status = *R(VIRTIO_MMIO_STATUS);
    80208458:	100017b7          	lui	a5,0x10001
    8020845c:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x701fef90>
    80208460:	439c                	lw	a5,0(a5)
    80208462:	fef42423          	sw	a5,-24(s0)
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80208466:	fe842783          	lw	a5,-24(s0)
    8020846a:	8ba1                	andi	a5,a5,8
    8020846c:	2781                	sext.w	a5,a5
    8020846e:	eb89                	bnez	a5,80208480 <virtio_disk_init+0x192>
    panic("virtio disk FEATURES_OK unset");
    80208470:	00025517          	auipc	a0,0x25
    80208474:	cb050513          	addi	a0,a0,-848 # 8022d120 <user_test_table+0xa8>
    80208478:	ffff9097          	auipc	ra,0xffff9
    8020847c:	38e080e7          	jalr	910(ra) # 80201806 <panic>
  // initialize queue 0.
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80208480:	100017b7          	lui	a5,0x10001
    80208484:	03078793          	addi	a5,a5,48 # 10001030 <_entry-0x701fefd0>
    80208488:	0007a023          	sw	zero,0(a5)

  // ensure queue 0 is not in use.
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8020848c:	100017b7          	lui	a5,0x10001
    80208490:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x701fefbc>
    80208494:	439c                	lw	a5,0(a5)
    80208496:	2781                	sext.w	a5,a5
    80208498:	cb89                	beqz	a5,802084aa <virtio_disk_init+0x1bc>
    panic("virtio disk should not be ready");
    8020849a:	00025517          	auipc	a0,0x25
    8020849e:	ca650513          	addi	a0,a0,-858 # 8022d140 <user_test_table+0xc8>
    802084a2:	ffff9097          	auipc	ra,0xffff9
    802084a6:	364080e7          	jalr	868(ra) # 80201806 <panic>

  // check maximum queue size.
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    802084aa:	100017b7          	lui	a5,0x10001
    802084ae:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x701fefcc>
    802084b2:	439c                	lw	a5,0(a5)
    802084b4:	fcf42e23          	sw	a5,-36(s0)
  if(max == 0)
    802084b8:	fdc42783          	lw	a5,-36(s0)
    802084bc:	2781                	sext.w	a5,a5
    802084be:	eb89                	bnez	a5,802084d0 <virtio_disk_init+0x1e2>
    panic("virtio disk has no queue 0");
    802084c0:	00025517          	auipc	a0,0x25
    802084c4:	ca050513          	addi	a0,a0,-864 # 8022d160 <user_test_table+0xe8>
    802084c8:	ffff9097          	auipc	ra,0xffff9
    802084cc:	33e080e7          	jalr	830(ra) # 80201806 <panic>
  if(max < NUM)
    802084d0:	fdc42783          	lw	a5,-36(s0)
    802084d4:	0007871b          	sext.w	a4,a5
    802084d8:	47bd                	li	a5,15
    802084da:	00e7ea63          	bltu	a5,a4,802084ee <virtio_disk_init+0x200>
    panic("virtio disk max queue too short");
    802084de:	00025517          	auipc	a0,0x25
    802084e2:	ca250513          	addi	a0,a0,-862 # 8022d180 <user_test_table+0x108>
    802084e6:	ffff9097          	auipc	ra,0xffff9
    802084ea:	320080e7          	jalr	800(ra) # 80201806 <panic>

  // allocate and zero queue memory.
  disk.desc = alloc_page();
    802084ee:	ffffb097          	auipc	ra,0xffffb
    802084f2:	e6e080e7          	jalr	-402(ra) # 8020335c <alloc_page>
    802084f6:	872a                	mv	a4,a0
    802084f8:	00035797          	auipc	a5,0x35
    802084fc:	21878793          	addi	a5,a5,536 # 8023d710 <disk>
    80208500:	e398                	sd	a4,0(a5)
  disk.avail = alloc_page();
    80208502:	ffffb097          	auipc	ra,0xffffb
    80208506:	e5a080e7          	jalr	-422(ra) # 8020335c <alloc_page>
    8020850a:	872a                	mv	a4,a0
    8020850c:	00035797          	auipc	a5,0x35
    80208510:	20478793          	addi	a5,a5,516 # 8023d710 <disk>
    80208514:	e798                	sd	a4,8(a5)
  disk.used = alloc_page();
    80208516:	ffffb097          	auipc	ra,0xffffb
    8020851a:	e46080e7          	jalr	-442(ra) # 8020335c <alloc_page>
    8020851e:	872a                	mv	a4,a0
    80208520:	00035797          	auipc	a5,0x35
    80208524:	1f078793          	addi	a5,a5,496 # 8023d710 <disk>
    80208528:	eb98                	sd	a4,16(a5)
  if(!disk.desc || !disk.avail || !disk.used)
    8020852a:	00035797          	auipc	a5,0x35
    8020852e:	1e678793          	addi	a5,a5,486 # 8023d710 <disk>
    80208532:	639c                	ld	a5,0(a5)
    80208534:	cf89                	beqz	a5,8020854e <virtio_disk_init+0x260>
    80208536:	00035797          	auipc	a5,0x35
    8020853a:	1da78793          	addi	a5,a5,474 # 8023d710 <disk>
    8020853e:	679c                	ld	a5,8(a5)
    80208540:	c799                	beqz	a5,8020854e <virtio_disk_init+0x260>
    80208542:	00035797          	auipc	a5,0x35
    80208546:	1ce78793          	addi	a5,a5,462 # 8023d710 <disk>
    8020854a:	6b9c                	ld	a5,16(a5)
    8020854c:	eb89                	bnez	a5,8020855e <virtio_disk_init+0x270>
    panic("virtio disk kalloc");
    8020854e:	00025517          	auipc	a0,0x25
    80208552:	c5250513          	addi	a0,a0,-942 # 8022d1a0 <user_test_table+0x128>
    80208556:	ffff9097          	auipc	ra,0xffff9
    8020855a:	2b0080e7          	jalr	688(ra) # 80201806 <panic>
  memset(disk.desc, 0, PGSIZE);
    8020855e:	00035797          	auipc	a5,0x35
    80208562:	1b278793          	addi	a5,a5,434 # 8023d710 <disk>
    80208566:	639c                	ld	a5,0(a5)
    80208568:	6605                	lui	a2,0x1
    8020856a:	4581                	li	a1,0
    8020856c:	853e                	mv	a0,a5
    8020856e:	ffffa097          	auipc	ra,0xffffa
    80208572:	9d6080e7          	jalr	-1578(ra) # 80201f44 <memset>
  memset(disk.avail, 0, PGSIZE);
    80208576:	00035797          	auipc	a5,0x35
    8020857a:	19a78793          	addi	a5,a5,410 # 8023d710 <disk>
    8020857e:	679c                	ld	a5,8(a5)
    80208580:	6605                	lui	a2,0x1
    80208582:	4581                	li	a1,0
    80208584:	853e                	mv	a0,a5
    80208586:	ffffa097          	auipc	ra,0xffffa
    8020858a:	9be080e7          	jalr	-1602(ra) # 80201f44 <memset>
  memset(disk.used, 0, PGSIZE);
    8020858e:	00035797          	auipc	a5,0x35
    80208592:	18278793          	addi	a5,a5,386 # 8023d710 <disk>
    80208596:	6b9c                	ld	a5,16(a5)
    80208598:	6605                	lui	a2,0x1
    8020859a:	4581                	li	a1,0
    8020859c:	853e                	mv	a0,a5
    8020859e:	ffffa097          	auipc	ra,0xffffa
    802085a2:	9a6080e7          	jalr	-1626(ra) # 80201f44 <memset>

  // set queue size.
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    802085a6:	100017b7          	lui	a5,0x10001
    802085aa:	03878793          	addi	a5,a5,56 # 10001038 <_entry-0x701fefc8>
    802085ae:	4741                	li	a4,16
    802085b0:	c398                	sw	a4,0(a5)

  // write physical addresses.
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    802085b2:	00035797          	auipc	a5,0x35
    802085b6:	15e78793          	addi	a5,a5,350 # 8023d710 <disk>
    802085ba:	639c                	ld	a5,0(a5)
    802085bc:	873e                	mv	a4,a5
    802085be:	100017b7          	lui	a5,0x10001
    802085c2:	08078793          	addi	a5,a5,128 # 10001080 <_entry-0x701fef80>
    802085c6:	2701                	sext.w	a4,a4
    802085c8:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    802085ca:	00035797          	auipc	a5,0x35
    802085ce:	14678793          	addi	a5,a5,326 # 8023d710 <disk>
    802085d2:	639c                	ld	a5,0(a5)
    802085d4:	0207d713          	srli	a4,a5,0x20
    802085d8:	100017b7          	lui	a5,0x10001
    802085dc:	08478793          	addi	a5,a5,132 # 10001084 <_entry-0x701fef7c>
    802085e0:	2701                	sext.w	a4,a4
    802085e2:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    802085e4:	00035797          	auipc	a5,0x35
    802085e8:	12c78793          	addi	a5,a5,300 # 8023d710 <disk>
    802085ec:	679c                	ld	a5,8(a5)
    802085ee:	873e                	mv	a4,a5
    802085f0:	100017b7          	lui	a5,0x10001
    802085f4:	09078793          	addi	a5,a5,144 # 10001090 <_entry-0x701fef70>
    802085f8:	2701                	sext.w	a4,a4
    802085fa:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    802085fc:	00035797          	auipc	a5,0x35
    80208600:	11478793          	addi	a5,a5,276 # 8023d710 <disk>
    80208604:	679c                	ld	a5,8(a5)
    80208606:	0207d713          	srli	a4,a5,0x20
    8020860a:	100017b7          	lui	a5,0x10001
    8020860e:	09478793          	addi	a5,a5,148 # 10001094 <_entry-0x701fef6c>
    80208612:	2701                	sext.w	a4,a4
    80208614:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80208616:	00035797          	auipc	a5,0x35
    8020861a:	0fa78793          	addi	a5,a5,250 # 8023d710 <disk>
    8020861e:	6b9c                	ld	a5,16(a5)
    80208620:	873e                	mv	a4,a5
    80208622:	100017b7          	lui	a5,0x10001
    80208626:	0a078793          	addi	a5,a5,160 # 100010a0 <_entry-0x701fef60>
    8020862a:	2701                	sext.w	a4,a4
    8020862c:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8020862e:	00035797          	auipc	a5,0x35
    80208632:	0e278793          	addi	a5,a5,226 # 8023d710 <disk>
    80208636:	6b9c                	ld	a5,16(a5)
    80208638:	0207d713          	srli	a4,a5,0x20
    8020863c:	100017b7          	lui	a5,0x10001
    80208640:	0a478793          	addi	a5,a5,164 # 100010a4 <_entry-0x701fef5c>
    80208644:	2701                	sext.w	a4,a4
    80208646:	c398                	sw	a4,0(a5)

  // queue is ready.
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80208648:	100017b7          	lui	a5,0x10001
    8020864c:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x701fefbc>
    80208650:	4705                	li	a4,1
    80208652:	c398                	sw	a4,0(a5)

  // all NUM descriptors start out unused.
  for(int i = 0; i < NUM; i++)
    80208654:	fe042623          	sw	zero,-20(s0)
    80208658:	a005                	j	80208678 <virtio_disk_init+0x38a>
    disk.free[i] = 1;
    8020865a:	00035717          	auipc	a4,0x35
    8020865e:	0b670713          	addi	a4,a4,182 # 8023d710 <disk>
    80208662:	fec42783          	lw	a5,-20(s0)
    80208666:	97ba                	add	a5,a5,a4
    80208668:	4705                	li	a4,1
    8020866a:	00e78c23          	sb	a4,24(a5)
  for(int i = 0; i < NUM; i++)
    8020866e:	fec42783          	lw	a5,-20(s0)
    80208672:	2785                	addiw	a5,a5,1
    80208674:	fef42623          	sw	a5,-20(s0)
    80208678:	fec42783          	lw	a5,-20(s0)
    8020867c:	0007871b          	sext.w	a4,a5
    80208680:	47bd                	li	a5,15
    80208682:	fce7dce3          	bge	a5,a4,8020865a <virtio_disk_init+0x36c>

  // tell device we're completely ready.
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80208686:	fe842783          	lw	a5,-24(s0)
    8020868a:	0047e793          	ori	a5,a5,4
    8020868e:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    80208692:	100017b7          	lui	a5,0x10001
    80208696:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x701fef90>
    8020869a:	fe842703          	lw	a4,-24(s0)
    8020869e:	c398                	sw	a4,0(a5)

  // plic.c and trap.c arrange for interrupts from VIRTIO0_IRQ.
}
    802086a0:	0001                	nop
    802086a2:	70a2                	ld	ra,40(sp)
    802086a4:	7402                	ld	s0,32(sp)
    802086a6:	6145                	addi	sp,sp,48
    802086a8:	8082                	ret

00000000802086aa <alloc_desc>:

// find a free descriptor, mark it non-free, return its index.
int
alloc_desc()
{
    802086aa:	1101                	addi	sp,sp,-32
    802086ac:	ec22                	sd	s0,24(sp)
    802086ae:	1000                	addi	s0,sp,32
  for(int i = 0; i < NUM; i++){
    802086b0:	fe042623          	sw	zero,-20(s0)
    802086b4:	a825                	j	802086ec <alloc_desc+0x42>
    if(disk.free[i]){
    802086b6:	00035717          	auipc	a4,0x35
    802086ba:	05a70713          	addi	a4,a4,90 # 8023d710 <disk>
    802086be:	fec42783          	lw	a5,-20(s0)
    802086c2:	97ba                	add	a5,a5,a4
    802086c4:	0187c783          	lbu	a5,24(a5)
    802086c8:	cf89                	beqz	a5,802086e2 <alloc_desc+0x38>
      disk.free[i] = 0;
    802086ca:	00035717          	auipc	a4,0x35
    802086ce:	04670713          	addi	a4,a4,70 # 8023d710 <disk>
    802086d2:	fec42783          	lw	a5,-20(s0)
    802086d6:	97ba                	add	a5,a5,a4
    802086d8:	00078c23          	sb	zero,24(a5)
      return i;
    802086dc:	fec42783          	lw	a5,-20(s0)
    802086e0:	a831                	j	802086fc <alloc_desc+0x52>
  for(int i = 0; i < NUM; i++){
    802086e2:	fec42783          	lw	a5,-20(s0)
    802086e6:	2785                	addiw	a5,a5,1
    802086e8:	fef42623          	sw	a5,-20(s0)
    802086ec:	fec42783          	lw	a5,-20(s0)
    802086f0:	0007871b          	sext.w	a4,a5
    802086f4:	47bd                	li	a5,15
    802086f6:	fce7d0e3          	bge	a5,a4,802086b6 <alloc_desc+0xc>
    }
  }
  return -1;
    802086fa:	57fd                	li	a5,-1
}
    802086fc:	853e                	mv	a0,a5
    802086fe:	6462                	ld	s0,24(sp)
    80208700:	6105                	addi	sp,sp,32
    80208702:	8082                	ret

0000000080208704 <free_desc>:

// mark a descriptor as free.
void
free_desc(int i)
{
    80208704:	1101                	addi	sp,sp,-32
    80208706:	ec06                	sd	ra,24(sp)
    80208708:	e822                	sd	s0,16(sp)
    8020870a:	1000                	addi	s0,sp,32
    8020870c:	87aa                	mv	a5,a0
    8020870e:	fef42623          	sw	a5,-20(s0)
  if(i >= NUM)
    80208712:	fec42783          	lw	a5,-20(s0)
    80208716:	0007871b          	sext.w	a4,a5
    8020871a:	47bd                	li	a5,15
    8020871c:	00e7da63          	bge	a5,a4,80208730 <free_desc+0x2c>
    panic("free_desc i >= NUM");
    80208720:	00025517          	auipc	a0,0x25
    80208724:	a9850513          	addi	a0,a0,-1384 # 8022d1b8 <user_test_table+0x140>
    80208728:	ffff9097          	auipc	ra,0xffff9
    8020872c:	0de080e7          	jalr	222(ra) # 80201806 <panic>
  if(disk.free[i])
    80208730:	00035717          	auipc	a4,0x35
    80208734:	fe070713          	addi	a4,a4,-32 # 8023d710 <disk>
    80208738:	fec42783          	lw	a5,-20(s0)
    8020873c:	97ba                	add	a5,a5,a4
    8020873e:	0187c783          	lbu	a5,24(a5)
    80208742:	cb89                	beqz	a5,80208754 <free_desc+0x50>
    panic("free_desc i has already been free");
    80208744:	00025517          	auipc	a0,0x25
    80208748:	a8c50513          	addi	a0,a0,-1396 # 8022d1d0 <user_test_table+0x158>
    8020874c:	ffff9097          	auipc	ra,0xffff9
    80208750:	0ba080e7          	jalr	186(ra) # 80201806 <panic>
  disk.desc[i].addr = 0;
    80208754:	00035797          	auipc	a5,0x35
    80208758:	fbc78793          	addi	a5,a5,-68 # 8023d710 <disk>
    8020875c:	6398                	ld	a4,0(a5)
    8020875e:	fec42783          	lw	a5,-20(s0)
    80208762:	0792                	slli	a5,a5,0x4
    80208764:	97ba                	add	a5,a5,a4
    80208766:	0007b023          	sd	zero,0(a5)
  disk.desc[i].len = 0;
    8020876a:	00035797          	auipc	a5,0x35
    8020876e:	fa678793          	addi	a5,a5,-90 # 8023d710 <disk>
    80208772:	6398                	ld	a4,0(a5)
    80208774:	fec42783          	lw	a5,-20(s0)
    80208778:	0792                	slli	a5,a5,0x4
    8020877a:	97ba                	add	a5,a5,a4
    8020877c:	0007a423          	sw	zero,8(a5)
  disk.desc[i].flags = 0;
    80208780:	00035797          	auipc	a5,0x35
    80208784:	f9078793          	addi	a5,a5,-112 # 8023d710 <disk>
    80208788:	6398                	ld	a4,0(a5)
    8020878a:	fec42783          	lw	a5,-20(s0)
    8020878e:	0792                	slli	a5,a5,0x4
    80208790:	97ba                	add	a5,a5,a4
    80208792:	00079623          	sh	zero,12(a5)
  disk.desc[i].next = 0;
    80208796:	00035797          	auipc	a5,0x35
    8020879a:	f7a78793          	addi	a5,a5,-134 # 8023d710 <disk>
    8020879e:	6398                	ld	a4,0(a5)
    802087a0:	fec42783          	lw	a5,-20(s0)
    802087a4:	0792                	slli	a5,a5,0x4
    802087a6:	97ba                	add	a5,a5,a4
    802087a8:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    802087ac:	00035717          	auipc	a4,0x35
    802087b0:	f6470713          	addi	a4,a4,-156 # 8023d710 <disk>
    802087b4:	fec42783          	lw	a5,-20(s0)
    802087b8:	97ba                	add	a5,a5,a4
    802087ba:	4705                	li	a4,1
    802087bc:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    802087c0:	00035517          	auipc	a0,0x35
    802087c4:	f6850513          	addi	a0,a0,-152 # 8023d728 <disk+0x18>
    802087c8:	ffffd097          	auipc	ra,0xffffd
    802087cc:	672080e7          	jalr	1650(ra) # 80205e3a <wakeup>
}
    802087d0:	0001                	nop
    802087d2:	60e2                	ld	ra,24(sp)
    802087d4:	6442                	ld	s0,16(sp)
    802087d6:	6105                	addi	sp,sp,32
    802087d8:	8082                	ret

00000000802087da <free_chain>:

// free a chain of descriptors.
void
free_chain(int i)
{
    802087da:	7179                	addi	sp,sp,-48
    802087dc:	f406                	sd	ra,40(sp)
    802087de:	f022                	sd	s0,32(sp)
    802087e0:	1800                	addi	s0,sp,48
    802087e2:	87aa                	mv	a5,a0
    802087e4:	fcf42e23          	sw	a5,-36(s0)
  while(1){
    int flag = disk.desc[i].flags;
    802087e8:	00035797          	auipc	a5,0x35
    802087ec:	f2878793          	addi	a5,a5,-216 # 8023d710 <disk>
    802087f0:	6398                	ld	a4,0(a5)
    802087f2:	fdc42783          	lw	a5,-36(s0)
    802087f6:	0792                	slli	a5,a5,0x4
    802087f8:	97ba                	add	a5,a5,a4
    802087fa:	00c7d783          	lhu	a5,12(a5)
    802087fe:	fef42623          	sw	a5,-20(s0)
    int nxt = disk.desc[i].next;
    80208802:	00035797          	auipc	a5,0x35
    80208806:	f0e78793          	addi	a5,a5,-242 # 8023d710 <disk>
    8020880a:	6398                	ld	a4,0(a5)
    8020880c:	fdc42783          	lw	a5,-36(s0)
    80208810:	0792                	slli	a5,a5,0x4
    80208812:	97ba                	add	a5,a5,a4
    80208814:	00e7d783          	lhu	a5,14(a5)
    80208818:	fef42423          	sw	a5,-24(s0)
    free_desc(i);
    8020881c:	fdc42783          	lw	a5,-36(s0)
    80208820:	853e                	mv	a0,a5
    80208822:	00000097          	auipc	ra,0x0
    80208826:	ee2080e7          	jalr	-286(ra) # 80208704 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8020882a:	fec42783          	lw	a5,-20(s0)
    8020882e:	8b85                	andi	a5,a5,1
    80208830:	2781                	sext.w	a5,a5
    80208832:	c791                	beqz	a5,8020883e <free_chain+0x64>
      i = nxt;
    80208834:	fe842783          	lw	a5,-24(s0)
    80208838:	fcf42e23          	sw	a5,-36(s0)
  while(1){
    8020883c:	b775                	j	802087e8 <free_chain+0xe>
    else
      break;
    8020883e:	0001                	nop
  }
}
    80208840:	0001                	nop
    80208842:	70a2                	ld	ra,40(sp)
    80208844:	7402                	ld	s0,32(sp)
    80208846:	6145                	addi	sp,sp,48
    80208848:	8082                	ret

000000008020884a <alloc3_desc>:

int
alloc3_desc(int *idx)
{
    8020884a:	7139                	addi	sp,sp,-64
    8020884c:	fc06                	sd	ra,56(sp)
    8020884e:	f822                	sd	s0,48(sp)
    80208850:	f426                	sd	s1,40(sp)
    80208852:	0080                	addi	s0,sp,64
    80208854:	fca43423          	sd	a0,-56(s0)
  for(int i = 0; i < 3; i++){
    80208858:	fc042e23          	sw	zero,-36(s0)
    8020885c:	a89d                	j	802088d2 <alloc3_desc+0x88>
    idx[i] = alloc_desc();
    8020885e:	fdc42783          	lw	a5,-36(s0)
    80208862:	078a                	slli	a5,a5,0x2
    80208864:	fc843703          	ld	a4,-56(s0)
    80208868:	00f704b3          	add	s1,a4,a5
    8020886c:	00000097          	auipc	ra,0x0
    80208870:	e3e080e7          	jalr	-450(ra) # 802086aa <alloc_desc>
    80208874:	87aa                	mv	a5,a0
    80208876:	c09c                	sw	a5,0(s1)
    if(idx[i] < 0){
    80208878:	fdc42783          	lw	a5,-36(s0)
    8020887c:	078a                	slli	a5,a5,0x2
    8020887e:	fc843703          	ld	a4,-56(s0)
    80208882:	97ba                	add	a5,a5,a4
    80208884:	439c                	lw	a5,0(a5)
    80208886:	0407d163          	bgez	a5,802088c8 <alloc3_desc+0x7e>
      for(int j = 0; j < i; j++)
    8020888a:	fc042c23          	sw	zero,-40(s0)
    8020888e:	a015                	j	802088b2 <alloc3_desc+0x68>
        free_desc(idx[j]);
    80208890:	fd842783          	lw	a5,-40(s0)
    80208894:	078a                	slli	a5,a5,0x2
    80208896:	fc843703          	ld	a4,-56(s0)
    8020889a:	97ba                	add	a5,a5,a4
    8020889c:	439c                	lw	a5,0(a5)
    8020889e:	853e                	mv	a0,a5
    802088a0:	00000097          	auipc	ra,0x0
    802088a4:	e64080e7          	jalr	-412(ra) # 80208704 <free_desc>
      for(int j = 0; j < i; j++)
    802088a8:	fd842783          	lw	a5,-40(s0)
    802088ac:	2785                	addiw	a5,a5,1
    802088ae:	fcf42c23          	sw	a5,-40(s0)
    802088b2:	fd842783          	lw	a5,-40(s0)
    802088b6:	873e                	mv	a4,a5
    802088b8:	fdc42783          	lw	a5,-36(s0)
    802088bc:	2701                	sext.w	a4,a4
    802088be:	2781                	sext.w	a5,a5
    802088c0:	fcf748e3          	blt	a4,a5,80208890 <alloc3_desc+0x46>
      return -1;
    802088c4:	57fd                	li	a5,-1
    802088c6:	a831                	j	802088e2 <alloc3_desc+0x98>
  for(int i = 0; i < 3; i++){
    802088c8:	fdc42783          	lw	a5,-36(s0)
    802088cc:	2785                	addiw	a5,a5,1
    802088ce:	fcf42e23          	sw	a5,-36(s0)
    802088d2:	fdc42783          	lw	a5,-36(s0)
    802088d6:	0007871b          	sext.w	a4,a5
    802088da:	4789                	li	a5,2
    802088dc:	f8e7d1e3          	bge	a5,a4,8020885e <alloc3_desc+0x14>
    }
  }
  return 0;
    802088e0:	4781                	li	a5,0
}
    802088e2:	853e                	mv	a0,a5
    802088e4:	70e2                	ld	ra,56(sp)
    802088e6:	7442                	ld	s0,48(sp)
    802088e8:	74a2                	ld	s1,40(sp)
    802088ea:	6121                	addi	sp,sp,64
    802088ec:	8082                	ret

00000000802088ee <virtio_disk_rw>:

void
virtio_disk_rw(struct buf *b, int write)
{
    802088ee:	7139                	addi	sp,sp,-64
    802088f0:	fc06                	sd	ra,56(sp)
    802088f2:	f822                	sd	s0,48(sp)
    802088f4:	0080                	addi	s0,sp,64
    802088f6:	fca43423          	sd	a0,-56(s0)
    802088fa:	87ae                	mv	a5,a1
    802088fc:	fcf42223          	sw	a5,-60(s0)
  uint64 sector = b->blockno * (BSIZE / 512);
    80208900:	fc843783          	ld	a5,-56(s0)
    80208904:	47dc                	lw	a5,12(a5)
    80208906:	0017979b          	slliw	a5,a5,0x1
    8020890a:	2781                	sext.w	a5,a5
    8020890c:	1782                	slli	a5,a5,0x20
    8020890e:	9381                	srli	a5,a5,0x20
    80208910:	fef43423          	sd	a5,-24(s0)
  acquire(&disk.vdisk_lock);
    80208914:	00035517          	auipc	a0,0x35
    80208918:	02c50513          	addi	a0,a0,44 # 8023d940 <disk+0x230>
    8020891c:	00004097          	auipc	ra,0x4
    80208920:	81c080e7          	jalr	-2020(ra) # 8020c138 <acquire>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
    80208924:	fd040793          	addi	a5,s0,-48
    80208928:	853e                	mv	a0,a5
    8020892a:	00000097          	auipc	ra,0x0
    8020892e:	f20080e7          	jalr	-224(ra) # 8020884a <alloc3_desc>
    80208932:	87aa                	mv	a5,a0
    80208934:	cf91                	beqz	a5,80208950 <virtio_disk_rw+0x62>
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80208936:	00035597          	auipc	a1,0x35
    8020893a:	00a58593          	addi	a1,a1,10 # 8023d940 <disk+0x230>
    8020893e:	00035517          	auipc	a0,0x35
    80208942:	dea50513          	addi	a0,a0,-534 # 8023d728 <disk+0x18>
    80208946:	ffffd097          	auipc	ra,0xffffd
    8020894a:	43c080e7          	jalr	1084(ra) # 80205d82 <sleep>
    if(alloc3_desc(idx) == 0) {
    8020894e:	bfd9                	j	80208924 <virtio_disk_rw+0x36>
      break;
    80208950:	0001                	nop
  }
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80208952:	fd042783          	lw	a5,-48(s0)
    80208956:	07cd                	addi	a5,a5,19
    80208958:	00479713          	slli	a4,a5,0x4
    8020895c:	00035797          	auipc	a5,0x35
    80208960:	db478793          	addi	a5,a5,-588 # 8023d710 <disk>
    80208964:	97ba                	add	a5,a5,a4
    80208966:	fef43023          	sd	a5,-32(s0)
  if(write)
    8020896a:	fc442783          	lw	a5,-60(s0)
    8020896e:	2781                	sext.w	a5,a5
    80208970:	c791                	beqz	a5,8020897c <virtio_disk_rw+0x8e>
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80208972:	fe043783          	ld	a5,-32(s0)
    80208976:	4705                	li	a4,1
    80208978:	c398                	sw	a4,0(a5)
    8020897a:	a029                	j	80208984 <virtio_disk_rw+0x96>
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    8020897c:	fe043783          	ld	a5,-32(s0)
    80208980:	0007a023          	sw	zero,0(a5)
  buf0->reserved = 0;
    80208984:	fe043783          	ld	a5,-32(s0)
    80208988:	0007a223          	sw	zero,4(a5)
  buf0->sector = sector;
    8020898c:	fe043783          	ld	a5,-32(s0)
    80208990:	fe843703          	ld	a4,-24(s0)
    80208994:	e798                	sd	a4,8(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80208996:	00035797          	auipc	a5,0x35
    8020899a:	d7a78793          	addi	a5,a5,-646 # 8023d710 <disk>
    8020899e:	6398                	ld	a4,0(a5)
    802089a0:	fd042783          	lw	a5,-48(s0)
    802089a4:	0792                	slli	a5,a5,0x4
    802089a6:	97ba                	add	a5,a5,a4
    802089a8:	fe043703          	ld	a4,-32(s0)
    802089ac:	e398                	sd	a4,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    802089ae:	00035797          	auipc	a5,0x35
    802089b2:	d6278793          	addi	a5,a5,-670 # 8023d710 <disk>
    802089b6:	6398                	ld	a4,0(a5)
    802089b8:	fd042783          	lw	a5,-48(s0)
    802089bc:	0792                	slli	a5,a5,0x4
    802089be:	97ba                	add	a5,a5,a4
    802089c0:	4741                	li	a4,16
    802089c2:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    802089c4:	00035797          	auipc	a5,0x35
    802089c8:	d4c78793          	addi	a5,a5,-692 # 8023d710 <disk>
    802089cc:	6398                	ld	a4,0(a5)
    802089ce:	fd042783          	lw	a5,-48(s0)
    802089d2:	0792                	slli	a5,a5,0x4
    802089d4:	97ba                	add	a5,a5,a4
    802089d6:	4705                	li	a4,1
    802089d8:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    802089dc:	fd442683          	lw	a3,-44(s0)
    802089e0:	00035797          	auipc	a5,0x35
    802089e4:	d3078793          	addi	a5,a5,-720 # 8023d710 <disk>
    802089e8:	6398                	ld	a4,0(a5)
    802089ea:	fd042783          	lw	a5,-48(s0)
    802089ee:	0792                	slli	a5,a5,0x4
    802089f0:	97ba                	add	a5,a5,a4
    802089f2:	03069713          	slli	a4,a3,0x30
    802089f6:	9341                	srli	a4,a4,0x30
    802089f8:	00e79723          	sh	a4,14(a5)
  disk.desc[idx[1]].addr = (uint64) b->data;
    802089fc:	fc843783          	ld	a5,-56(s0)
    80208a00:	05078693          	addi	a3,a5,80
    80208a04:	00035797          	auipc	a5,0x35
    80208a08:	d0c78793          	addi	a5,a5,-756 # 8023d710 <disk>
    80208a0c:	6398                	ld	a4,0(a5)
    80208a0e:	fd442783          	lw	a5,-44(s0)
    80208a12:	0792                	slli	a5,a5,0x4
    80208a14:	97ba                	add	a5,a5,a4
    80208a16:	8736                	mv	a4,a3
    80208a18:	e398                	sd	a4,0(a5)
  disk.desc[idx[1]].len = BSIZE;
    80208a1a:	00035797          	auipc	a5,0x35
    80208a1e:	cf678793          	addi	a5,a5,-778 # 8023d710 <disk>
    80208a22:	6398                	ld	a4,0(a5)
    80208a24:	fd442783          	lw	a5,-44(s0)
    80208a28:	0792                	slli	a5,a5,0x4
    80208a2a:	97ba                	add	a5,a5,a4
    80208a2c:	40000713          	li	a4,1024
    80208a30:	c798                	sw	a4,8(a5)
  if(write){
    80208a32:	fc442783          	lw	a5,-60(s0)
    80208a36:	2781                	sext.w	a5,a5
    80208a38:	cf89                	beqz	a5,80208a52 <virtio_disk_rw+0x164>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80208a3a:	00035797          	auipc	a5,0x35
    80208a3e:	cd678793          	addi	a5,a5,-810 # 8023d710 <disk>
    80208a42:	6398                	ld	a4,0(a5)
    80208a44:	fd442783          	lw	a5,-44(s0)
    80208a48:	0792                	slli	a5,a5,0x4
    80208a4a:	97ba                	add	a5,a5,a4
    80208a4c:	00079623          	sh	zero,12(a5)
    80208a50:	a829                	j	80208a6a <virtio_disk_rw+0x17c>
  }else{
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80208a52:	00035797          	auipc	a5,0x35
    80208a56:	cbe78793          	addi	a5,a5,-834 # 8023d710 <disk>
    80208a5a:	6398                	ld	a4,0(a5)
    80208a5c:	fd442783          	lw	a5,-44(s0)
    80208a60:	0792                	slli	a5,a5,0x4
    80208a62:	97ba                	add	a5,a5,a4
    80208a64:	4709                	li	a4,2
    80208a66:	00e79623          	sh	a4,12(a5)
  }
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80208a6a:	00035797          	auipc	a5,0x35
    80208a6e:	ca678793          	addi	a5,a5,-858 # 8023d710 <disk>
    80208a72:	6398                	ld	a4,0(a5)
    80208a74:	fd442783          	lw	a5,-44(s0)
    80208a78:	0792                	slli	a5,a5,0x4
    80208a7a:	97ba                	add	a5,a5,a4
    80208a7c:	00c7d703          	lhu	a4,12(a5)
    80208a80:	00035797          	auipc	a5,0x35
    80208a84:	c9078793          	addi	a5,a5,-880 # 8023d710 <disk>
    80208a88:	6394                	ld	a3,0(a5)
    80208a8a:	fd442783          	lw	a5,-44(s0)
    80208a8e:	0792                	slli	a5,a5,0x4
    80208a90:	97b6                	add	a5,a5,a3
    80208a92:	00176713          	ori	a4,a4,1
    80208a96:	1742                	slli	a4,a4,0x30
    80208a98:	9341                	srli	a4,a4,0x30
    80208a9a:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[1]].next = idx[2];
    80208a9e:	fd842683          	lw	a3,-40(s0)
    80208aa2:	00035797          	auipc	a5,0x35
    80208aa6:	c6e78793          	addi	a5,a5,-914 # 8023d710 <disk>
    80208aaa:	6398                	ld	a4,0(a5)
    80208aac:	fd442783          	lw	a5,-44(s0)
    80208ab0:	0792                	slli	a5,a5,0x4
    80208ab2:	97ba                	add	a5,a5,a4
    80208ab4:	03069713          	slli	a4,a3,0x30
    80208ab8:	9341                	srli	a4,a4,0x30
    80208aba:	00e79723          	sh	a4,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80208abe:	fd042783          	lw	a5,-48(s0)
    80208ac2:	00035717          	auipc	a4,0x35
    80208ac6:	c4e70713          	addi	a4,a4,-946 # 8023d710 <disk>
    80208aca:	078d                	addi	a5,a5,3
    80208acc:	0792                	slli	a5,a5,0x4
    80208ace:	97ba                	add	a5,a5,a4
    80208ad0:	577d                	li	a4,-1
    80208ad2:	00e78423          	sb	a4,8(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80208ad6:	fd042783          	lw	a5,-48(s0)
    80208ada:	078d                	addi	a5,a5,3
    80208adc:	00479713          	slli	a4,a5,0x4
    80208ae0:	00035797          	auipc	a5,0x35
    80208ae4:	c3078793          	addi	a5,a5,-976 # 8023d710 <disk>
    80208ae8:	97ba                	add	a5,a5,a4
    80208aea:	00878693          	addi	a3,a5,8
    80208aee:	00035797          	auipc	a5,0x35
    80208af2:	c2278793          	addi	a5,a5,-990 # 8023d710 <disk>
    80208af6:	6398                	ld	a4,0(a5)
    80208af8:	fd842783          	lw	a5,-40(s0)
    80208afc:	0792                	slli	a5,a5,0x4
    80208afe:	97ba                	add	a5,a5,a4
    80208b00:	8736                	mv	a4,a3
    80208b02:	e398                	sd	a4,0(a5)
  disk.desc[idx[2]].len = 1;
    80208b04:	00035797          	auipc	a5,0x35
    80208b08:	c0c78793          	addi	a5,a5,-1012 # 8023d710 <disk>
    80208b0c:	6398                	ld	a4,0(a5)
    80208b0e:	fd842783          	lw	a5,-40(s0)
    80208b12:	0792                	slli	a5,a5,0x4
    80208b14:	97ba                	add	a5,a5,a4
    80208b16:	4705                	li	a4,1
    80208b18:	c798                	sw	a4,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80208b1a:	00035797          	auipc	a5,0x35
    80208b1e:	bf678793          	addi	a5,a5,-1034 # 8023d710 <disk>
    80208b22:	6398                	ld	a4,0(a5)
    80208b24:	fd842783          	lw	a5,-40(s0)
    80208b28:	0792                	slli	a5,a5,0x4
    80208b2a:	97ba                	add	a5,a5,a4
    80208b2c:	4709                	li	a4,2
    80208b2e:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[2]].next = 0;
    80208b32:	00035797          	auipc	a5,0x35
    80208b36:	bde78793          	addi	a5,a5,-1058 # 8023d710 <disk>
    80208b3a:	6398                	ld	a4,0(a5)
    80208b3c:	fd842783          	lw	a5,-40(s0)
    80208b40:	0792                	slli	a5,a5,0x4
    80208b42:	97ba                	add	a5,a5,a4
    80208b44:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80208b48:	fc843783          	ld	a5,-56(s0)
    80208b4c:	4705                	li	a4,1
    80208b4e:	c3d8                	sw	a4,4(a5)
  disk.info[idx[0]].b = b;
    80208b50:	fd042783          	lw	a5,-48(s0)
    80208b54:	00035717          	auipc	a4,0x35
    80208b58:	bbc70713          	addi	a4,a4,-1092 # 8023d710 <disk>
    80208b5c:	078d                	addi	a5,a5,3
    80208b5e:	0792                	slli	a5,a5,0x4
    80208b60:	97ba                	add	a5,a5,a4
    80208b62:	fc843703          	ld	a4,-56(s0)
    80208b66:	e398                	sd	a4,0(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80208b68:	fd042703          	lw	a4,-48(s0)
    80208b6c:	00035797          	auipc	a5,0x35
    80208b70:	ba478793          	addi	a5,a5,-1116 # 8023d710 <disk>
    80208b74:	6794                	ld	a3,8(a5)
    80208b76:	00035797          	auipc	a5,0x35
    80208b7a:	b9a78793          	addi	a5,a5,-1126 # 8023d710 <disk>
    80208b7e:	679c                	ld	a5,8(a5)
    80208b80:	0027d783          	lhu	a5,2(a5)
    80208b84:	2781                	sext.w	a5,a5
    80208b86:	8bbd                	andi	a5,a5,15
    80208b88:	2781                	sext.w	a5,a5
    80208b8a:	1742                	slli	a4,a4,0x30
    80208b8c:	9341                	srli	a4,a4,0x30
    80208b8e:	0786                	slli	a5,a5,0x1
    80208b90:	97b6                	add	a5,a5,a3
    80208b92:	00e79223          	sh	a4,4(a5)
  __sync_synchronize();
    80208b96:	0ff0000f          	fence
  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80208b9a:	00035797          	auipc	a5,0x35
    80208b9e:	b7678793          	addi	a5,a5,-1162 # 8023d710 <disk>
    80208ba2:	679c                	ld	a5,8(a5)
    80208ba4:	0027d703          	lhu	a4,2(a5)
    80208ba8:	00035797          	auipc	a5,0x35
    80208bac:	b6878793          	addi	a5,a5,-1176 # 8023d710 <disk>
    80208bb0:	679c                	ld	a5,8(a5)
    80208bb2:	2705                	addiw	a4,a4,1
    80208bb4:	1742                	slli	a4,a4,0x30
    80208bb6:	9341                	srli	a4,a4,0x30
    80208bb8:	00e79123          	sh	a4,2(a5)
  __sync_synchronize();
    80208bbc:	0ff0000f          	fence
  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80208bc0:	100017b7          	lui	a5,0x10001
    80208bc4:	05078793          	addi	a5,a5,80 # 10001050 <_entry-0x701fefb0>
    80208bc8:	0007a023          	sw	zero,0(a5)
  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80208bcc:	a819                	j	80208be2 <virtio_disk_rw+0x2f4>
    sleep(b, &disk.vdisk_lock);
    80208bce:	00035597          	auipc	a1,0x35
    80208bd2:	d7258593          	addi	a1,a1,-654 # 8023d940 <disk+0x230>
    80208bd6:	fc843503          	ld	a0,-56(s0)
    80208bda:	ffffd097          	auipc	ra,0xffffd
    80208bde:	1a8080e7          	jalr	424(ra) # 80205d82 <sleep>
  while(b->disk == 1) {
    80208be2:	fc843783          	ld	a5,-56(s0)
    80208be6:	43dc                	lw	a5,4(a5)
    80208be8:	873e                	mv	a4,a5
    80208bea:	4785                	li	a5,1
    80208bec:	fef701e3          	beq	a4,a5,80208bce <virtio_disk_rw+0x2e0>
  }

  disk.info[idx[0]].b = 0;
    80208bf0:	fd042783          	lw	a5,-48(s0)
    80208bf4:	00035717          	auipc	a4,0x35
    80208bf8:	b1c70713          	addi	a4,a4,-1252 # 8023d710 <disk>
    80208bfc:	078d                	addi	a5,a5,3
    80208bfe:	0792                	slli	a5,a5,0x4
    80208c00:	97ba                	add	a5,a5,a4
    80208c02:	0007b023          	sd	zero,0(a5)
  free_chain(idx[0]);
    80208c06:	fd042783          	lw	a5,-48(s0)
    80208c0a:	853e                	mv	a0,a5
    80208c0c:	00000097          	auipc	ra,0x0
    80208c10:	bce080e7          	jalr	-1074(ra) # 802087da <free_chain>
  release(&disk.vdisk_lock);
    80208c14:	00035517          	auipc	a0,0x35
    80208c18:	d2c50513          	addi	a0,a0,-724 # 8023d940 <disk+0x230>
    80208c1c:	00003097          	auipc	ra,0x3
    80208c20:	568080e7          	jalr	1384(ra) # 8020c184 <release>
}
    80208c24:	0001                	nop
    80208c26:	70e2                	ld	ra,56(sp)
    80208c28:	7442                	ld	s0,48(sp)
    80208c2a:	6121                	addi	sp,sp,64
    80208c2c:	8082                	ret

0000000080208c2e <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80208c2e:	1101                	addi	sp,sp,-32
    80208c30:	ec06                	sd	ra,24(sp)
    80208c32:	e822                	sd	s0,16(sp)
    80208c34:	1000                	addi	s0,sp,32
	acquire(&disk.vdisk_lock);
    80208c36:	00035517          	auipc	a0,0x35
    80208c3a:	d0a50513          	addi	a0,a0,-758 # 8023d940 <disk+0x230>
    80208c3e:	00003097          	auipc	ra,0x3
    80208c42:	4fa080e7          	jalr	1274(ra) # 8020c138 <acquire>

  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80208c46:	100017b7          	lui	a5,0x10001
    80208c4a:	06078793          	addi	a5,a5,96 # 10001060 <_entry-0x701fefa0>
    80208c4e:	439c                	lw	a5,0(a5)
    80208c50:	0007871b          	sext.w	a4,a5
    80208c54:	100017b7          	lui	a5,0x10001
    80208c58:	06478793          	addi	a5,a5,100 # 10001064 <_entry-0x701fef9c>
    80208c5c:	8b0d                	andi	a4,a4,3
    80208c5e:	2701                	sext.w	a4,a4
    80208c60:	c398                	sw	a4,0(a5)
  __sync_synchronize();
    80208c62:	0ff0000f          	fence
  while(disk.used_idx != disk.used->idx){
    80208c66:	a045                	j	80208d06 <virtio_disk_intr+0xd8>
	__sync_synchronize();
    80208c68:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80208c6c:	00035797          	auipc	a5,0x35
    80208c70:	aa478793          	addi	a5,a5,-1372 # 8023d710 <disk>
    80208c74:	6b98                	ld	a4,16(a5)
    80208c76:	00035797          	auipc	a5,0x35
    80208c7a:	a9a78793          	addi	a5,a5,-1382 # 8023d710 <disk>
    80208c7e:	0287d783          	lhu	a5,40(a5)
    80208c82:	2781                	sext.w	a5,a5
    80208c84:	8bbd                	andi	a5,a5,15
    80208c86:	2781                	sext.w	a5,a5
    80208c88:	078e                	slli	a5,a5,0x3
    80208c8a:	97ba                	add	a5,a5,a4
    80208c8c:	43dc                	lw	a5,4(a5)
    80208c8e:	fef42623          	sw	a5,-20(s0)

    if(disk.info[id].status != 0)
    80208c92:	00035717          	auipc	a4,0x35
    80208c96:	a7e70713          	addi	a4,a4,-1410 # 8023d710 <disk>
    80208c9a:	fec42783          	lw	a5,-20(s0)
    80208c9e:	078d                	addi	a5,a5,3
    80208ca0:	0792                	slli	a5,a5,0x4
    80208ca2:	97ba                	add	a5,a5,a4
    80208ca4:	0087c783          	lbu	a5,8(a5)
    80208ca8:	cb89                	beqz	a5,80208cba <virtio_disk_intr+0x8c>
      panic("virtio_disk_intr status");
    80208caa:	00024517          	auipc	a0,0x24
    80208cae:	54e50513          	addi	a0,a0,1358 # 8022d1f8 <user_test_table+0x180>
    80208cb2:	ffff9097          	auipc	ra,0xffff9
    80208cb6:	b54080e7          	jalr	-1196(ra) # 80201806 <panic>

    struct buf *b = disk.info[id].b;
    80208cba:	00035717          	auipc	a4,0x35
    80208cbe:	a5670713          	addi	a4,a4,-1450 # 8023d710 <disk>
    80208cc2:	fec42783          	lw	a5,-20(s0)
    80208cc6:	078d                	addi	a5,a5,3
    80208cc8:	0792                	slli	a5,a5,0x4
    80208cca:	97ba                	add	a5,a5,a4
    80208ccc:	639c                	ld	a5,0(a5)
    80208cce:	fef43023          	sd	a5,-32(s0)
    b->disk = 0;   // disk is done with buf
    80208cd2:	fe043783          	ld	a5,-32(s0)
    80208cd6:	0007a223          	sw	zero,4(a5)
    wakeup(b);
    80208cda:	fe043503          	ld	a0,-32(s0)
    80208cde:	ffffd097          	auipc	ra,0xffffd
    80208ce2:	15c080e7          	jalr	348(ra) # 80205e3a <wakeup>
    disk.used_idx += 1;
    80208ce6:	00035797          	auipc	a5,0x35
    80208cea:	a2a78793          	addi	a5,a5,-1494 # 8023d710 <disk>
    80208cee:	0287d783          	lhu	a5,40(a5)
    80208cf2:	2785                	addiw	a5,a5,1
    80208cf4:	03079713          	slli	a4,a5,0x30
    80208cf8:	9341                	srli	a4,a4,0x30
    80208cfa:	00035797          	auipc	a5,0x35
    80208cfe:	a1678793          	addi	a5,a5,-1514 # 8023d710 <disk>
    80208d02:	02e79423          	sh	a4,40(a5)
  while(disk.used_idx != disk.used->idx){
    80208d06:	00035797          	auipc	a5,0x35
    80208d0a:	a0a78793          	addi	a5,a5,-1526 # 8023d710 <disk>
    80208d0e:	0287d703          	lhu	a4,40(a5)
    80208d12:	00035797          	auipc	a5,0x35
    80208d16:	9fe78793          	addi	a5,a5,-1538 # 8023d710 <disk>
    80208d1a:	6b9c                	ld	a5,16(a5)
    80208d1c:	0027d783          	lhu	a5,2(a5)
    80208d20:	2701                	sext.w	a4,a4
    80208d22:	2781                	sext.w	a5,a5
    80208d24:	f4f712e3          	bne	a4,a5,80208c68 <virtio_disk_intr+0x3a>
  }
	release(&disk.vdisk_lock);
    80208d28:	00035517          	auipc	a0,0x35
    80208d2c:	c1850513          	addi	a0,a0,-1000 # 8023d940 <disk+0x230>
    80208d30:	00003097          	auipc	ra,0x3
    80208d34:	454080e7          	jalr	1108(ra) # 8020c184 <release>
}
    80208d38:	0001                	nop
    80208d3a:	60e2                	ld	ra,24(sp)
    80208d3c:	6442                	ld	s0,16(sp)
    80208d3e:	6105                	addi	sp,sp,32
    80208d40:	8082                	ret

0000000080208d42 <assert>:
    80208d42:	1101                	addi	sp,sp,-32
    80208d44:	ec06                	sd	ra,24(sp)
    80208d46:	e822                	sd	s0,16(sp)
    80208d48:	1000                	addi	s0,sp,32
    80208d4a:	87aa                	mv	a5,a0
    80208d4c:	fef42623          	sw	a5,-20(s0)
    80208d50:	fec42783          	lw	a5,-20(s0)
    80208d54:	2781                	sext.w	a5,a5
    80208d56:	e79d                	bnez	a5,80208d84 <assert+0x42>
    80208d58:	33c00613          	li	a2,828
    80208d5c:	00026597          	auipc	a1,0x26
    80208d60:	56458593          	addi	a1,a1,1380 # 8022f2c0 <user_test_table+0x78>
    80208d64:	00026517          	auipc	a0,0x26
    80208d68:	56c50513          	addi	a0,a0,1388 # 8022f2d0 <user_test_table+0x88>
    80208d6c:	ffff8097          	auipc	ra,0xffff8
    80208d70:	518080e7          	jalr	1304(ra) # 80201284 <printf>
    80208d74:	00026517          	auipc	a0,0x26
    80208d78:	58450513          	addi	a0,a0,1412 # 8022f2f8 <user_test_table+0xb0>
    80208d7c:	ffff9097          	auipc	ra,0xffff9
    80208d80:	a8a080e7          	jalr	-1398(ra) # 80201806 <panic>
    80208d84:	0001                	nop
    80208d86:	60e2                	ld	ra,24(sp)
    80208d88:	6442                	ld	s0,16(sp)
    80208d8a:	6105                	addi	sp,sp,32
    80208d8c:	8082                	ret

0000000080208d8e <binit>:
{
    80208d8e:	1101                	addi	sp,sp,-32
    80208d90:	ec06                	sd	ra,24(sp)
    80208d92:	e822                	sd	s0,16(sp)
    80208d94:	1000                	addi	s0,sp,32
  initlock(&bcache.lock, "bcache");
    80208d96:	00026597          	auipc	a1,0x26
    80208d9a:	56a58593          	addi	a1,a1,1386 # 8022f300 <user_test_table+0xb8>
    80208d9e:	0003d517          	auipc	a0,0x3d
    80208da2:	16250513          	addi	a0,a0,354 # 80245f00 <bcache+0x85b0>
    80208da6:	00003097          	auipc	ra,0x3
    80208daa:	36a080e7          	jalr	874(ra) # 8020c110 <initlock>
  bcache.head.prev = &bcache.head;
    80208dae:	00035717          	auipc	a4,0x35
    80208db2:	ba270713          	addi	a4,a4,-1118 # 8023d950 <bcache>
    80208db6:	67a1                	lui	a5,0x8
    80208db8:	97ba                	add	a5,a5,a4
    80208dba:	0003d717          	auipc	a4,0x3d
    80208dbe:	cf670713          	addi	a4,a4,-778 # 80245ab0 <bcache+0x8160>
    80208dc2:	1ae7b023          	sd	a4,416(a5) # 81a0 <_entry-0x801f7e60>
  bcache.head.next = &bcache.head;
    80208dc6:	00035717          	auipc	a4,0x35
    80208dca:	b8a70713          	addi	a4,a4,-1142 # 8023d950 <bcache>
    80208dce:	67a1                	lui	a5,0x8
    80208dd0:	97ba                	add	a5,a5,a4
    80208dd2:	0003d717          	auipc	a4,0x3d
    80208dd6:	cde70713          	addi	a4,a4,-802 # 80245ab0 <bcache+0x8160>
    80208dda:	1ae7b423          	sd	a4,424(a5) # 81a8 <_entry-0x801f7e58>
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80208dde:	00035797          	auipc	a5,0x35
    80208de2:	b7278793          	addi	a5,a5,-1166 # 8023d950 <bcache>
    80208de6:	fef43423          	sd	a5,-24(s0)
    80208dea:	a895                	j	80208e5e <binit+0xd0>
    b->next = bcache.head.next;
    80208dec:	00035717          	auipc	a4,0x35
    80208df0:	b6470713          	addi	a4,a4,-1180 # 8023d950 <bcache>
    80208df4:	67a1                	lui	a5,0x8
    80208df6:	97ba                	add	a5,a5,a4
    80208df8:	1a87b703          	ld	a4,424(a5) # 81a8 <_entry-0x801f7e58>
    80208dfc:	fe843783          	ld	a5,-24(s0)
    80208e00:	e7b8                	sd	a4,72(a5)
    b->prev = &bcache.head;
    80208e02:	fe843783          	ld	a5,-24(s0)
    80208e06:	0003d717          	auipc	a4,0x3d
    80208e0a:	caa70713          	addi	a4,a4,-854 # 80245ab0 <bcache+0x8160>
    80208e0e:	e3b8                	sd	a4,64(a5)
	initsleeplock(&b->lock, "buffer");
    80208e10:	fe843783          	ld	a5,-24(s0)
    80208e14:	07e1                	addi	a5,a5,24
    80208e16:	00026597          	auipc	a1,0x26
    80208e1a:	4f258593          	addi	a1,a1,1266 # 8022f308 <user_test_table+0xc0>
    80208e1e:	853e                	mv	a0,a5
    80208e20:	00003097          	auipc	ra,0x3
    80208e24:	3c4080e7          	jalr	964(ra) # 8020c1e4 <initsleeplock>
    bcache.head.next->prev = b;
    80208e28:	00035717          	auipc	a4,0x35
    80208e2c:	b2870713          	addi	a4,a4,-1240 # 8023d950 <bcache>
    80208e30:	67a1                	lui	a5,0x8
    80208e32:	97ba                	add	a5,a5,a4
    80208e34:	1a87b783          	ld	a5,424(a5) # 81a8 <_entry-0x801f7e58>
    80208e38:	fe843703          	ld	a4,-24(s0)
    80208e3c:	e3b8                	sd	a4,64(a5)
    bcache.head.next = b;
    80208e3e:	00035717          	auipc	a4,0x35
    80208e42:	b1270713          	addi	a4,a4,-1262 # 8023d950 <bcache>
    80208e46:	67a1                	lui	a5,0x8
    80208e48:	97ba                	add	a5,a5,a4
    80208e4a:	fe843703          	ld	a4,-24(s0)
    80208e4e:	1ae7b423          	sd	a4,424(a5) # 81a8 <_entry-0x801f7e58>
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80208e52:	fe843783          	ld	a5,-24(s0)
    80208e56:	45078793          	addi	a5,a5,1104
    80208e5a:	fef43423          	sd	a5,-24(s0)
    80208e5e:	0003d797          	auipc	a5,0x3d
    80208e62:	c5278793          	addi	a5,a5,-942 # 80245ab0 <bcache+0x8160>
    80208e66:	fe843703          	ld	a4,-24(s0)
    80208e6a:	f8f761e3          	bltu	a4,a5,80208dec <binit+0x5e>
}
    80208e6e:	0001                	nop
    80208e70:	0001                	nop
    80208e72:	60e2                	ld	ra,24(sp)
    80208e74:	6442                	ld	s0,16(sp)
    80208e76:	6105                	addi	sp,sp,32
    80208e78:	8082                	ret

0000000080208e7a <bget>:
{
    80208e7a:	7179                	addi	sp,sp,-48
    80208e7c:	f406                	sd	ra,40(sp)
    80208e7e:	f022                	sd	s0,32(sp)
    80208e80:	1800                	addi	s0,sp,48
    80208e82:	87aa                	mv	a5,a0
    80208e84:	872e                	mv	a4,a1
    80208e86:	fcf42e23          	sw	a5,-36(s0)
    80208e8a:	87ba                	mv	a5,a4
    80208e8c:	fcf42c23          	sw	a5,-40(s0)
  acquire(&bcache.lock); // 加锁
    80208e90:	0003d517          	auipc	a0,0x3d
    80208e94:	07050513          	addi	a0,a0,112 # 80245f00 <bcache+0x85b0>
    80208e98:	00003097          	auipc	ra,0x3
    80208e9c:	2a0080e7          	jalr	672(ra) # 8020c138 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80208ea0:	00035717          	auipc	a4,0x35
    80208ea4:	ab070713          	addi	a4,a4,-1360 # 8023d950 <bcache>
    80208ea8:	67a1                	lui	a5,0x8
    80208eaa:	97ba                	add	a5,a5,a4
    80208eac:	1a87b783          	ld	a5,424(a5) # 81a8 <_entry-0x801f7e58>
    80208eb0:	fef43423          	sd	a5,-24(s0)
    80208eb4:	a095                	j	80208f18 <bget+0x9e>
    if(b->dev == dev && b->blockno == blockno){
    80208eb6:	fe843783          	ld	a5,-24(s0)
    80208eba:	4798                	lw	a4,8(a5)
    80208ebc:	fdc42783          	lw	a5,-36(s0)
    80208ec0:	2781                	sext.w	a5,a5
    80208ec2:	04e79663          	bne	a5,a4,80208f0e <bget+0x94>
    80208ec6:	fe843783          	ld	a5,-24(s0)
    80208eca:	47d8                	lw	a4,12(a5)
    80208ecc:	fd842783          	lw	a5,-40(s0)
    80208ed0:	2781                	sext.w	a5,a5
    80208ed2:	02e79e63          	bne	a5,a4,80208f0e <bget+0x94>
      b->refcnt++;
    80208ed6:	fe843783          	ld	a5,-24(s0)
    80208eda:	4b9c                	lw	a5,16(a5)
    80208edc:	2785                	addiw	a5,a5,1
    80208ede:	0007871b          	sext.w	a4,a5
    80208ee2:	fe843783          	ld	a5,-24(s0)
    80208ee6:	cb98                	sw	a4,16(a5)
	  release(&bcache.lock); // 解锁
    80208ee8:	0003d517          	auipc	a0,0x3d
    80208eec:	01850513          	addi	a0,a0,24 # 80245f00 <bcache+0x85b0>
    80208ef0:	00003097          	auipc	ra,0x3
    80208ef4:	294080e7          	jalr	660(ra) # 8020c184 <release>
      acquiresleep(&b->lock);
    80208ef8:	fe843783          	ld	a5,-24(s0)
    80208efc:	07e1                	addi	a5,a5,24
    80208efe:	853e                	mv	a0,a5
    80208f00:	00003097          	auipc	ra,0x3
    80208f04:	330080e7          	jalr	816(ra) # 8020c230 <acquiresleep>
      return b;
    80208f08:	fe843783          	ld	a5,-24(s0)
    80208f0c:	a845                	j	80208fbc <bget+0x142>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80208f0e:	fe843783          	ld	a5,-24(s0)
    80208f12:	67bc                	ld	a5,72(a5)
    80208f14:	fef43423          	sd	a5,-24(s0)
    80208f18:	fe843703          	ld	a4,-24(s0)
    80208f1c:	0003d797          	auipc	a5,0x3d
    80208f20:	b9478793          	addi	a5,a5,-1132 # 80245ab0 <bcache+0x8160>
    80208f24:	f8f719e3          	bne	a4,a5,80208eb6 <bget+0x3c>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80208f28:	00035717          	auipc	a4,0x35
    80208f2c:	a2870713          	addi	a4,a4,-1496 # 8023d950 <bcache>
    80208f30:	67a1                	lui	a5,0x8
    80208f32:	97ba                	add	a5,a5,a4
    80208f34:	1a07b783          	ld	a5,416(a5) # 81a0 <_entry-0x801f7e60>
    80208f38:	fef43423          	sd	a5,-24(s0)
    80208f3c:	a8b9                	j	80208f9a <bget+0x120>
    if(b->refcnt == 0) {
    80208f3e:	fe843783          	ld	a5,-24(s0)
    80208f42:	4b9c                	lw	a5,16(a5)
    80208f44:	e7b1                	bnez	a5,80208f90 <bget+0x116>
      b->dev = dev;
    80208f46:	fe843783          	ld	a5,-24(s0)
    80208f4a:	fdc42703          	lw	a4,-36(s0)
    80208f4e:	c798                	sw	a4,8(a5)
      b->blockno = blockno;
    80208f50:	fe843783          	ld	a5,-24(s0)
    80208f54:	fd842703          	lw	a4,-40(s0)
    80208f58:	c7d8                	sw	a4,12(a5)
      b->valid = 0;
    80208f5a:	fe843783          	ld	a5,-24(s0)
    80208f5e:	0007a023          	sw	zero,0(a5)
      b->refcnt = 1;
    80208f62:	fe843783          	ld	a5,-24(s0)
    80208f66:	4705                	li	a4,1
    80208f68:	cb98                	sw	a4,16(a5)
	  release(&bcache.lock); // 解锁
    80208f6a:	0003d517          	auipc	a0,0x3d
    80208f6e:	f9650513          	addi	a0,a0,-106 # 80245f00 <bcache+0x85b0>
    80208f72:	00003097          	auipc	ra,0x3
    80208f76:	212080e7          	jalr	530(ra) # 8020c184 <release>
      acquiresleep(&b->lock);
    80208f7a:	fe843783          	ld	a5,-24(s0)
    80208f7e:	07e1                	addi	a5,a5,24
    80208f80:	853e                	mv	a0,a5
    80208f82:	00003097          	auipc	ra,0x3
    80208f86:	2ae080e7          	jalr	686(ra) # 8020c230 <acquiresleep>
      return b;
    80208f8a:	fe843783          	ld	a5,-24(s0)
    80208f8e:	a03d                	j	80208fbc <bget+0x142>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80208f90:	fe843783          	ld	a5,-24(s0)
    80208f94:	63bc                	ld	a5,64(a5)
    80208f96:	fef43423          	sd	a5,-24(s0)
    80208f9a:	fe843703          	ld	a4,-24(s0)
    80208f9e:	0003d797          	auipc	a5,0x3d
    80208fa2:	b1278793          	addi	a5,a5,-1262 # 80245ab0 <bcache+0x8160>
    80208fa6:	f8f71ce3          	bne	a4,a5,80208f3e <bget+0xc4>
  panic("bget: no buffers");
    80208faa:	00026517          	auipc	a0,0x26
    80208fae:	36650513          	addi	a0,a0,870 # 8022f310 <user_test_table+0xc8>
    80208fb2:	ffff9097          	auipc	ra,0xffff9
    80208fb6:	854080e7          	jalr	-1964(ra) # 80201806 <panic>
  return 0;
    80208fba:	4781                	li	a5,0
}
    80208fbc:	853e                	mv	a0,a5
    80208fbe:	70a2                	ld	ra,40(sp)
    80208fc0:	7402                	ld	s0,32(sp)
    80208fc2:	6145                	addi	sp,sp,48
    80208fc4:	8082                	ret

0000000080208fc6 <bread>:
{
    80208fc6:	7179                	addi	sp,sp,-48
    80208fc8:	f406                	sd	ra,40(sp)
    80208fca:	f022                	sd	s0,32(sp)
    80208fcc:	1800                	addi	s0,sp,48
    80208fce:	87aa                	mv	a5,a0
    80208fd0:	872e                	mv	a4,a1
    80208fd2:	fcf42e23          	sw	a5,-36(s0)
    80208fd6:	87ba                	mv	a5,a4
    80208fd8:	fcf42c23          	sw	a5,-40(s0)
  b = bget(dev, blockno);
    80208fdc:	fd842703          	lw	a4,-40(s0)
    80208fe0:	fdc42783          	lw	a5,-36(s0)
    80208fe4:	85ba                	mv	a1,a4
    80208fe6:	853e                	mv	a0,a5
    80208fe8:	00000097          	auipc	ra,0x0
    80208fec:	e92080e7          	jalr	-366(ra) # 80208e7a <bget>
    80208ff0:	fea43423          	sd	a0,-24(s0)
  if(!b->valid) {
    80208ff4:	fe843783          	ld	a5,-24(s0)
    80208ff8:	439c                	lw	a5,0(a5)
    80208ffa:	ef81                	bnez	a5,80209012 <bread+0x4c>
    virtio_disk_rw(b, 0);
    80208ffc:	4581                	li	a1,0
    80208ffe:	fe843503          	ld	a0,-24(s0)
    80209002:	00000097          	auipc	ra,0x0
    80209006:	8ec080e7          	jalr	-1812(ra) # 802088ee <virtio_disk_rw>
    b->valid = 1;
    8020900a:	fe843783          	ld	a5,-24(s0)
    8020900e:	4705                	li	a4,1
    80209010:	c398                	sw	a4,0(a5)
  return b;
    80209012:	fe843783          	ld	a5,-24(s0)
}
    80209016:	853e                	mv	a0,a5
    80209018:	70a2                	ld	ra,40(sp)
    8020901a:	7402                	ld	s0,32(sp)
    8020901c:	6145                	addi	sp,sp,48
    8020901e:	8082                	ret

0000000080209020 <bwrite>:
{
    80209020:	1101                	addi	sp,sp,-32
    80209022:	ec06                	sd	ra,24(sp)
    80209024:	e822                	sd	s0,16(sp)
    80209026:	1000                	addi	s0,sp,32
    80209028:	fea43423          	sd	a0,-24(s0)
  if(!holdingsleep(&b->lock))
    8020902c:	fe843783          	ld	a5,-24(s0)
    80209030:	07e1                	addi	a5,a5,24
    80209032:	853e                	mv	a0,a5
    80209034:	00003097          	auipc	ra,0x3
    80209038:	314080e7          	jalr	788(ra) # 8020c348 <holdingsleep>
    8020903c:	87aa                	mv	a5,a0
    8020903e:	eb89                	bnez	a5,80209050 <bwrite+0x30>
    panic("bwrite without lock");
    80209040:	00026517          	auipc	a0,0x26
    80209044:	2e850513          	addi	a0,a0,744 # 8022f328 <user_test_table+0xe0>
    80209048:	ffff8097          	auipc	ra,0xffff8
    8020904c:	7be080e7          	jalr	1982(ra) # 80201806 <panic>
  virtio_disk_rw(b, 1);
    80209050:	4585                	li	a1,1
    80209052:	fe843503          	ld	a0,-24(s0)
    80209056:	00000097          	auipc	ra,0x0
    8020905a:	898080e7          	jalr	-1896(ra) # 802088ee <virtio_disk_rw>
}
    8020905e:	0001                	nop
    80209060:	60e2                	ld	ra,24(sp)
    80209062:	6442                	ld	s0,16(sp)
    80209064:	6105                	addi	sp,sp,32
    80209066:	8082                	ret

0000000080209068 <brelse>:
{
    80209068:	1101                	addi	sp,sp,-32
    8020906a:	ec06                	sd	ra,24(sp)
    8020906c:	e822                	sd	s0,16(sp)
    8020906e:	1000                	addi	s0,sp,32
    80209070:	fea43423          	sd	a0,-24(s0)
  if(!holdingsleep(&b->lock))
    80209074:	fe843783          	ld	a5,-24(s0)
    80209078:	07e1                	addi	a5,a5,24
    8020907a:	853e                	mv	a0,a5
    8020907c:	00003097          	auipc	ra,0x3
    80209080:	2cc080e7          	jalr	716(ra) # 8020c348 <holdingsleep>
    80209084:	87aa                	mv	a5,a0
    80209086:	eb89                	bnez	a5,80209098 <brelse+0x30>
    panic("brelse without lock");
    80209088:	00026517          	auipc	a0,0x26
    8020908c:	2b850513          	addi	a0,a0,696 # 8022f340 <user_test_table+0xf8>
    80209090:	ffff8097          	auipc	ra,0xffff8
    80209094:	776080e7          	jalr	1910(ra) # 80201806 <panic>
  releasesleep(&b->lock);
    80209098:	fe843783          	ld	a5,-24(s0)
    8020909c:	07e1                	addi	a5,a5,24
    8020909e:	853e                	mv	a0,a5
    802090a0:	00003097          	auipc	ra,0x3
    802090a4:	256080e7          	jalr	598(ra) # 8020c2f6 <releasesleep>
  acquire(&bcache.lock); // 加锁
    802090a8:	0003d517          	auipc	a0,0x3d
    802090ac:	e5850513          	addi	a0,a0,-424 # 80245f00 <bcache+0x85b0>
    802090b0:	00003097          	auipc	ra,0x3
    802090b4:	088080e7          	jalr	136(ra) # 8020c138 <acquire>
  b->refcnt--;
    802090b8:	fe843783          	ld	a5,-24(s0)
    802090bc:	4b9c                	lw	a5,16(a5)
    802090be:	37fd                	addiw	a5,a5,-1
    802090c0:	0007871b          	sext.w	a4,a5
    802090c4:	fe843783          	ld	a5,-24(s0)
    802090c8:	cb98                	sw	a4,16(a5)
  if (b->refcnt == 0) {
    802090ca:	fe843783          	ld	a5,-24(s0)
    802090ce:	4b9c                	lw	a5,16(a5)
    802090d0:	e7b5                	bnez	a5,8020913c <brelse+0xd4>
    b->next->prev = b->prev;
    802090d2:	fe843783          	ld	a5,-24(s0)
    802090d6:	67bc                	ld	a5,72(a5)
    802090d8:	fe843703          	ld	a4,-24(s0)
    802090dc:	6338                	ld	a4,64(a4)
    802090de:	e3b8                	sd	a4,64(a5)
    b->prev->next = b->next;
    802090e0:	fe843783          	ld	a5,-24(s0)
    802090e4:	63bc                	ld	a5,64(a5)
    802090e6:	fe843703          	ld	a4,-24(s0)
    802090ea:	6738                	ld	a4,72(a4)
    802090ec:	e7b8                	sd	a4,72(a5)
    b->next = bcache.head.next;
    802090ee:	00035717          	auipc	a4,0x35
    802090f2:	86270713          	addi	a4,a4,-1950 # 8023d950 <bcache>
    802090f6:	67a1                	lui	a5,0x8
    802090f8:	97ba                	add	a5,a5,a4
    802090fa:	1a87b703          	ld	a4,424(a5) # 81a8 <_entry-0x801f7e58>
    802090fe:	fe843783          	ld	a5,-24(s0)
    80209102:	e7b8                	sd	a4,72(a5)
    b->prev = &bcache.head;
    80209104:	fe843783          	ld	a5,-24(s0)
    80209108:	0003d717          	auipc	a4,0x3d
    8020910c:	9a870713          	addi	a4,a4,-1624 # 80245ab0 <bcache+0x8160>
    80209110:	e3b8                	sd	a4,64(a5)
    bcache.head.next->prev = b;
    80209112:	00035717          	auipc	a4,0x35
    80209116:	83e70713          	addi	a4,a4,-1986 # 8023d950 <bcache>
    8020911a:	67a1                	lui	a5,0x8
    8020911c:	97ba                	add	a5,a5,a4
    8020911e:	1a87b783          	ld	a5,424(a5) # 81a8 <_entry-0x801f7e58>
    80209122:	fe843703          	ld	a4,-24(s0)
    80209126:	e3b8                	sd	a4,64(a5)
    bcache.head.next = b;
    80209128:	00035717          	auipc	a4,0x35
    8020912c:	82870713          	addi	a4,a4,-2008 # 8023d950 <bcache>
    80209130:	67a1                	lui	a5,0x8
    80209132:	97ba                	add	a5,a5,a4
    80209134:	fe843703          	ld	a4,-24(s0)
    80209138:	1ae7b423          	sd	a4,424(a5) # 81a8 <_entry-0x801f7e58>
  release(&bcache.lock); // 解锁;
    8020913c:	0003d517          	auipc	a0,0x3d
    80209140:	dc450513          	addi	a0,a0,-572 # 80245f00 <bcache+0x85b0>
    80209144:	00003097          	auipc	ra,0x3
    80209148:	040080e7          	jalr	64(ra) # 8020c184 <release>
}
    8020914c:	0001                	nop
    8020914e:	60e2                	ld	ra,24(sp)
    80209150:	6442                	ld	s0,16(sp)
    80209152:	6105                	addi	sp,sp,32
    80209154:	8082                	ret

0000000080209156 <bpin>:
bpin(struct buf *b) {
    80209156:	1101                	addi	sp,sp,-32
    80209158:	ec06                	sd	ra,24(sp)
    8020915a:	e822                	sd	s0,16(sp)
    8020915c:	1000                	addi	s0,sp,32
    8020915e:	fea43423          	sd	a0,-24(s0)
  acquire(&bcache.lock);
    80209162:	0003d517          	auipc	a0,0x3d
    80209166:	d9e50513          	addi	a0,a0,-610 # 80245f00 <bcache+0x85b0>
    8020916a:	00003097          	auipc	ra,0x3
    8020916e:	fce080e7          	jalr	-50(ra) # 8020c138 <acquire>
  b->refcnt++;
    80209172:	fe843783          	ld	a5,-24(s0)
    80209176:	4b9c                	lw	a5,16(a5)
    80209178:	2785                	addiw	a5,a5,1
    8020917a:	0007871b          	sext.w	a4,a5
    8020917e:	fe843783          	ld	a5,-24(s0)
    80209182:	cb98                	sw	a4,16(a5)
  release(&bcache.lock);
    80209184:	0003d517          	auipc	a0,0x3d
    80209188:	d7c50513          	addi	a0,a0,-644 # 80245f00 <bcache+0x85b0>
    8020918c:	00003097          	auipc	ra,0x3
    80209190:	ff8080e7          	jalr	-8(ra) # 8020c184 <release>
}
    80209194:	0001                	nop
    80209196:	60e2                	ld	ra,24(sp)
    80209198:	6442                	ld	s0,16(sp)
    8020919a:	6105                	addi	sp,sp,32
    8020919c:	8082                	ret

000000008020919e <bunpin>:
bunpin(struct buf *b) {
    8020919e:	1101                	addi	sp,sp,-32
    802091a0:	ec06                	sd	ra,24(sp)
    802091a2:	e822                	sd	s0,16(sp)
    802091a4:	1000                	addi	s0,sp,32
    802091a6:	fea43423          	sd	a0,-24(s0)
  acquire(&bcache.lock);
    802091aa:	0003d517          	auipc	a0,0x3d
    802091ae:	d5650513          	addi	a0,a0,-682 # 80245f00 <bcache+0x85b0>
    802091b2:	00003097          	auipc	ra,0x3
    802091b6:	f86080e7          	jalr	-122(ra) # 8020c138 <acquire>
  b->refcnt--;
    802091ba:	fe843783          	ld	a5,-24(s0)
    802091be:	4b9c                	lw	a5,16(a5)
    802091c0:	37fd                	addiw	a5,a5,-1
    802091c2:	0007871b          	sext.w	a4,a5
    802091c6:	fe843783          	ld	a5,-24(s0)
    802091ca:	cb98                	sw	a4,16(a5)
  release(&bcache.lock);
    802091cc:	0003d517          	auipc	a0,0x3d
    802091d0:	d3450513          	addi	a0,a0,-716 # 80245f00 <bcache+0x85b0>
    802091d4:	00003097          	auipc	ra,0x3
    802091d8:	fb0080e7          	jalr	-80(ra) # 8020c184 <release>
}
    802091dc:	0001                	nop
    802091de:	60e2                	ld	ra,24(sp)
    802091e0:	6442                	ld	s0,16(sp)
    802091e2:	6105                	addi	sp,sp,32
    802091e4:	8082                	ret

00000000802091e6 <print_buf_chain>:
void print_buf_chain() {
    802091e6:	1101                	addi	sp,sp,-32
    802091e8:	ec06                	sd	ra,24(sp)
    802091ea:	e822                	sd	s0,16(sp)
    802091ec:	1000                	addi	s0,sp,32
  int cnt = 0;
    802091ee:	fe042223          	sw	zero,-28(s0)
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    802091f2:	00034717          	auipc	a4,0x34
    802091f6:	75e70713          	addi	a4,a4,1886 # 8023d950 <bcache>
    802091fa:	67a1                	lui	a5,0x8
    802091fc:	97ba                	add	a5,a5,a4
    802091fe:	1a87b783          	ld	a5,424(a5) # 81a8 <_entry-0x801f7e58>
    80209202:	fef43423          	sd	a5,-24(s0)
    80209206:	a0c9                	j	802092c8 <print_buf_chain+0xe2>
    printf("[bufchain] #%d: buf at %p, next=%p, prev=%p, refcnt=%d, dev=%u, blockno=%u\n",
    80209208:	fe442583          	lw	a1,-28(s0)
    8020920c:	0015879b          	addiw	a5,a1,1
    80209210:	fef42223          	sw	a5,-28(s0)
    80209214:	fe843783          	ld	a5,-24(s0)
    80209218:	67b4                	ld	a3,72(a5)
    8020921a:	fe843783          	ld	a5,-24(s0)
    8020921e:	63b8                	ld	a4,64(a5)
    80209220:	fe843783          	ld	a5,-24(s0)
    80209224:	4b90                	lw	a2,16(a5)
    80209226:	fe843783          	ld	a5,-24(s0)
    8020922a:	4788                	lw	a0,8(a5)
    8020922c:	fe843783          	ld	a5,-24(s0)
    80209230:	47dc                	lw	a5,12(a5)
    80209232:	88be                	mv	a7,a5
    80209234:	882a                	mv	a6,a0
    80209236:	87b2                	mv	a5,a2
    80209238:	fe843603          	ld	a2,-24(s0)
    8020923c:	00026517          	auipc	a0,0x26
    80209240:	11c50513          	addi	a0,a0,284 # 8022f358 <user_test_table+0x110>
    80209244:	ffff8097          	auipc	ra,0xffff8
    80209248:	040080e7          	jalr	64(ra) # 80201284 <printf>
    assert(b != NULL);
    8020924c:	fe843783          	ld	a5,-24(s0)
    80209250:	00f037b3          	snez	a5,a5
    80209254:	0ff7f793          	zext.b	a5,a5
    80209258:	2781                	sext.w	a5,a5
    8020925a:	853e                	mv	a0,a5
    8020925c:	00000097          	auipc	ra,0x0
    80209260:	ae6080e7          	jalr	-1306(ra) # 80208d42 <assert>
    assert((uintptr_t)b > 0x1000 && (uintptr_t)b < 0xFFFFFFFFFFFF);
    80209264:	fe843703          	ld	a4,-24(s0)
    80209268:	6785                	lui	a5,0x1
    8020926a:	00e7fa63          	bgeu	a5,a4,8020927e <print_buf_chain+0x98>
    8020926e:	fe843703          	ld	a4,-24(s0)
    80209272:	7781                	lui	a5,0xfffe0
    80209274:	83c1                	srli	a5,a5,0x10
    80209276:	00e7e463          	bltu	a5,a4,8020927e <print_buf_chain+0x98>
    8020927a:	4785                	li	a5,1
    8020927c:	a011                	j	80209280 <print_buf_chain+0x9a>
    8020927e:	4781                	li	a5,0
    80209280:	853e                	mv	a0,a5
    80209282:	00000097          	auipc	ra,0x0
    80209286:	ac0080e7          	jalr	-1344(ra) # 80208d42 <assert>
    assert(b->prev != NULL);
    8020928a:	fe843783          	ld	a5,-24(s0)
    8020928e:	63bc                	ld	a5,64(a5)
    80209290:	00f037b3          	snez	a5,a5
    80209294:	0ff7f793          	zext.b	a5,a5
    80209298:	2781                	sext.w	a5,a5
    8020929a:	853e                	mv	a0,a5
    8020929c:	00000097          	auipc	ra,0x0
    802092a0:	aa6080e7          	jalr	-1370(ra) # 80208d42 <assert>
    assert(b->next != NULL);
    802092a4:	fe843783          	ld	a5,-24(s0)
    802092a8:	67bc                	ld	a5,72(a5)
    802092aa:	00f037b3          	snez	a5,a5
    802092ae:	0ff7f793          	zext.b	a5,a5
    802092b2:	2781                	sext.w	a5,a5
    802092b4:	853e                	mv	a0,a5
    802092b6:	00000097          	auipc	ra,0x0
    802092ba:	a8c080e7          	jalr	-1396(ra) # 80208d42 <assert>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    802092be:	fe843783          	ld	a5,-24(s0)
    802092c2:	67bc                	ld	a5,72(a5)
    802092c4:	fef43423          	sd	a5,-24(s0)
    802092c8:	fe843703          	ld	a4,-24(s0)
    802092cc:	0003c797          	auipc	a5,0x3c
    802092d0:	7e478793          	addi	a5,a5,2020 # 80245ab0 <bcache+0x8160>
    802092d4:	f2f71ae3          	bne	a4,a5,80209208 <print_buf_chain+0x22>
    802092d8:	0001                	nop
    802092da:	0001                	nop
    802092dc:	60e2                	ld	ra,24(sp)
    802092de:	6442                	ld	s0,16(sp)
    802092e0:	6105                	addi	sp,sp,32
    802092e2:	8082                	ret

00000000802092e4 <initlog>:
struct log log;
static void commit(void); // 在文件开头加上声明

void
initlog(int dev, struct superblock *sb)
{
    802092e4:	1101                	addi	sp,sp,-32
    802092e6:	ec06                	sd	ra,24(sp)
    802092e8:	e822                	sd	s0,16(sp)
    802092ea:	1000                	addi	s0,sp,32
    802092ec:	87aa                	mv	a5,a0
    802092ee:	feb43023          	sd	a1,-32(s0)
    802092f2:	fef42623          	sw	a5,-20(s0)
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");
initlock(&log.lock, "log");
    802092f6:	00028597          	auipc	a1,0x28
    802092fa:	16258593          	addi	a1,a1,354 # 80231458 <user_test_table+0x78>
    802092fe:	0003d517          	auipc	a0,0x3d
    80209302:	c1250513          	addi	a0,a0,-1006 # 80245f10 <log>
    80209306:	00003097          	auipc	ra,0x3
    8020930a:	e0a080e7          	jalr	-502(ra) # 8020c110 <initlock>
  log.start = sb->logstart;
    8020930e:	fe043783          	ld	a5,-32(s0)
    80209312:	4bdc                	lw	a5,20(a5)
    80209314:	0007871b          	sext.w	a4,a5
    80209318:	0003d797          	auipc	a5,0x3d
    8020931c:	bf878793          	addi	a5,a5,-1032 # 80245f10 <log>
    80209320:	cb98                	sw	a4,16(a5)
  log.dev = dev;
    80209322:	0003d797          	auipc	a5,0x3d
    80209326:	bee78793          	addi	a5,a5,-1042 # 80245f10 <log>
    8020932a:	fec42703          	lw	a4,-20(s0)
    8020932e:	cfd8                	sw	a4,28(a5)
  recover_from_log();
    80209330:	00000097          	auipc	ra,0x0
    80209334:	2b6080e7          	jalr	694(ra) # 802095e6 <recover_from_log>
  printf("log init done\n");
    80209338:	00028517          	auipc	a0,0x28
    8020933c:	12850513          	addi	a0,a0,296 # 80231460 <user_test_table+0x80>
    80209340:	ffff8097          	auipc	ra,0xffff8
    80209344:	f44080e7          	jalr	-188(ra) # 80201284 <printf>
}
    80209348:	0001                	nop
    8020934a:	60e2                	ld	ra,24(sp)
    8020934c:	6442                	ld	s0,16(sp)
    8020934e:	6105                	addi	sp,sp,32
    80209350:	8082                	ret

0000000080209352 <install_trans>:

static void
install_trans(int recovering)
{
    80209352:	7139                	addi	sp,sp,-64
    80209354:	fc06                	sd	ra,56(sp)
    80209356:	f822                	sd	s0,48(sp)
    80209358:	0080                	addi	s0,sp,64
    8020935a:	87aa                	mv	a5,a0
    8020935c:	fcf42623          	sw	a5,-52(s0)
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    80209360:	fe042623          	sw	zero,-20(s0)
    80209364:	a209                	j	80209466 <install_trans+0x114>
    if(recovering) {
    80209366:	fcc42783          	lw	a5,-52(s0)
    8020936a:	2781                	sext.w	a5,a5
    8020936c:	c79d                	beqz	a5,8020939a <install_trans+0x48>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    8020936e:	0003d717          	auipc	a4,0x3d
    80209372:	ba270713          	addi	a4,a4,-1118 # 80245f10 <log>
    80209376:	fec42783          	lw	a5,-20(s0)
    8020937a:	07a1                	addi	a5,a5,8
    8020937c:	078a                	slli	a5,a5,0x2
    8020937e:	97ba                	add	a5,a5,a4
    80209380:	43d8                	lw	a4,4(a5)
    80209382:	fec42783          	lw	a5,-20(s0)
    80209386:	863a                	mv	a2,a4
    80209388:	85be                	mv	a1,a5
    8020938a:	00028517          	auipc	a0,0x28
    8020938e:	0e650513          	addi	a0,a0,230 # 80231470 <user_test_table+0x90>
    80209392:	ffff8097          	auipc	ra,0xffff8
    80209396:	ef2080e7          	jalr	-270(ra) # 80201284 <printf>
    }
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8020939a:	0003d797          	auipc	a5,0x3d
    8020939e:	b7678793          	addi	a5,a5,-1162 # 80245f10 <log>
    802093a2:	4fdc                	lw	a5,28(a5)
    802093a4:	0007871b          	sext.w	a4,a5
    802093a8:	0003d797          	auipc	a5,0x3d
    802093ac:	b6878793          	addi	a5,a5,-1176 # 80245f10 <log>
    802093b0:	4b9c                	lw	a5,16(a5)
    802093b2:	fec42683          	lw	a3,-20(s0)
    802093b6:	9fb5                	addw	a5,a5,a3
    802093b8:	2781                	sext.w	a5,a5
    802093ba:	2785                	addiw	a5,a5,1
    802093bc:	2781                	sext.w	a5,a5
    802093be:	2781                	sext.w	a5,a5
    802093c0:	85be                	mv	a1,a5
    802093c2:	853a                	mv	a0,a4
    802093c4:	00000097          	auipc	ra,0x0
    802093c8:	c02080e7          	jalr	-1022(ra) # 80208fc6 <bread>
    802093cc:	fea43023          	sd	a0,-32(s0)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    802093d0:	0003d797          	auipc	a5,0x3d
    802093d4:	b4078793          	addi	a5,a5,-1216 # 80245f10 <log>
    802093d8:	4fdc                	lw	a5,28(a5)
    802093da:	0007869b          	sext.w	a3,a5
    802093de:	0003d717          	auipc	a4,0x3d
    802093e2:	b3270713          	addi	a4,a4,-1230 # 80245f10 <log>
    802093e6:	fec42783          	lw	a5,-20(s0)
    802093ea:	07a1                	addi	a5,a5,8
    802093ec:	078a                	slli	a5,a5,0x2
    802093ee:	97ba                	add	a5,a5,a4
    802093f0:	43dc                	lw	a5,4(a5)
    802093f2:	2781                	sext.w	a5,a5
    802093f4:	85be                	mv	a1,a5
    802093f6:	8536                	mv	a0,a3
    802093f8:	00000097          	auipc	ra,0x0
    802093fc:	bce080e7          	jalr	-1074(ra) # 80208fc6 <bread>
    80209400:	fca43c23          	sd	a0,-40(s0)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80209404:	fd843783          	ld	a5,-40(s0)
    80209408:	05078713          	addi	a4,a5,80
    8020940c:	fe043783          	ld	a5,-32(s0)
    80209410:	05078793          	addi	a5,a5,80
    80209414:	40000613          	li	a2,1024
    80209418:	85be                	mv	a1,a5
    8020941a:	853a                	mv	a0,a4
    8020941c:	ffff9097          	auipc	ra,0xffff9
    80209420:	b78080e7          	jalr	-1160(ra) # 80201f94 <memmove>
    bwrite(dbuf);  // write dst to disk
    80209424:	fd843503          	ld	a0,-40(s0)
    80209428:	00000097          	auipc	ra,0x0
    8020942c:	bf8080e7          	jalr	-1032(ra) # 80209020 <bwrite>
    if(recovering == 0)
    80209430:	fcc42783          	lw	a5,-52(s0)
    80209434:	2781                	sext.w	a5,a5
    80209436:	e799                	bnez	a5,80209444 <install_trans+0xf2>
      bunpin(dbuf);
    80209438:	fd843503          	ld	a0,-40(s0)
    8020943c:	00000097          	auipc	ra,0x0
    80209440:	d62080e7          	jalr	-670(ra) # 8020919e <bunpin>
    brelse(lbuf);
    80209444:	fe043503          	ld	a0,-32(s0)
    80209448:	00000097          	auipc	ra,0x0
    8020944c:	c20080e7          	jalr	-992(ra) # 80209068 <brelse>
    brelse(dbuf);
    80209450:	fd843503          	ld	a0,-40(s0)
    80209454:	00000097          	auipc	ra,0x0
    80209458:	c14080e7          	jalr	-1004(ra) # 80209068 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8020945c:	fec42783          	lw	a5,-20(s0)
    80209460:	2785                	addiw	a5,a5,1
    80209462:	fef42623          	sw	a5,-20(s0)
    80209466:	0003d797          	auipc	a5,0x3d
    8020946a:	aaa78793          	addi	a5,a5,-1366 # 80245f10 <log>
    8020946e:	5398                	lw	a4,32(a5)
    80209470:	fec42783          	lw	a5,-20(s0)
    80209474:	2781                	sext.w	a5,a5
    80209476:	eee7c8e3          	blt	a5,a4,80209366 <install_trans+0x14>
  }
}
    8020947a:	0001                	nop
    8020947c:	0001                	nop
    8020947e:	70e2                	ld	ra,56(sp)
    80209480:	7442                	ld	s0,48(sp)
    80209482:	6121                	addi	sp,sp,64
    80209484:	8082                	ret

0000000080209486 <read_head>:
static void
read_head(void)
{
    80209486:	7179                	addi	sp,sp,-48
    80209488:	f406                	sd	ra,40(sp)
    8020948a:	f022                	sd	s0,32(sp)
    8020948c:	1800                	addi	s0,sp,48
  struct buf *buf = bread(log.dev, log.start);
    8020948e:	0003d797          	auipc	a5,0x3d
    80209492:	a8278793          	addi	a5,a5,-1406 # 80245f10 <log>
    80209496:	4fdc                	lw	a5,28(a5)
    80209498:	0007871b          	sext.w	a4,a5
    8020949c:	0003d797          	auipc	a5,0x3d
    802094a0:	a7478793          	addi	a5,a5,-1420 # 80245f10 <log>
    802094a4:	4b9c                	lw	a5,16(a5)
    802094a6:	2781                	sext.w	a5,a5
    802094a8:	85be                	mv	a1,a5
    802094aa:	853a                	mv	a0,a4
    802094ac:	00000097          	auipc	ra,0x0
    802094b0:	b1a080e7          	jalr	-1254(ra) # 80208fc6 <bread>
    802094b4:	fea43023          	sd	a0,-32(s0)
  struct logheader *lh = (struct logheader *) (buf->data);
    802094b8:	fe043783          	ld	a5,-32(s0)
    802094bc:	05078793          	addi	a5,a5,80
    802094c0:	fcf43c23          	sd	a5,-40(s0)
  int i;
  log.lh.n = lh->n;
    802094c4:	fd843783          	ld	a5,-40(s0)
    802094c8:	4398                	lw	a4,0(a5)
    802094ca:	0003d797          	auipc	a5,0x3d
    802094ce:	a4678793          	addi	a5,a5,-1466 # 80245f10 <log>
    802094d2:	d398                	sw	a4,32(a5)
  for (i = 0; i < log.lh.n; i++) {
    802094d4:	fe042623          	sw	zero,-20(s0)
    802094d8:	a03d                	j	80209506 <read_head+0x80>
    log.lh.block[i] = lh->block[i];
    802094da:	fd843703          	ld	a4,-40(s0)
    802094de:	fec42783          	lw	a5,-20(s0)
    802094e2:	078a                	slli	a5,a5,0x2
    802094e4:	97ba                	add	a5,a5,a4
    802094e6:	43d8                	lw	a4,4(a5)
    802094e8:	0003d697          	auipc	a3,0x3d
    802094ec:	a2868693          	addi	a3,a3,-1496 # 80245f10 <log>
    802094f0:	fec42783          	lw	a5,-20(s0)
    802094f4:	07a1                	addi	a5,a5,8
    802094f6:	078a                	slli	a5,a5,0x2
    802094f8:	97b6                	add	a5,a5,a3
    802094fa:	c3d8                	sw	a4,4(a5)
  for (i = 0; i < log.lh.n; i++) {
    802094fc:	fec42783          	lw	a5,-20(s0)
    80209500:	2785                	addiw	a5,a5,1
    80209502:	fef42623          	sw	a5,-20(s0)
    80209506:	0003d797          	auipc	a5,0x3d
    8020950a:	a0a78793          	addi	a5,a5,-1526 # 80245f10 <log>
    8020950e:	5398                	lw	a4,32(a5)
    80209510:	fec42783          	lw	a5,-20(s0)
    80209514:	2781                	sext.w	a5,a5
    80209516:	fce7c2e3          	blt	a5,a4,802094da <read_head+0x54>
  }
  brelse(buf);
    8020951a:	fe043503          	ld	a0,-32(s0)
    8020951e:	00000097          	auipc	ra,0x0
    80209522:	b4a080e7          	jalr	-1206(ra) # 80209068 <brelse>
}
    80209526:	0001                	nop
    80209528:	70a2                	ld	ra,40(sp)
    8020952a:	7402                	ld	s0,32(sp)
    8020952c:	6145                	addi	sp,sp,48
    8020952e:	8082                	ret

0000000080209530 <write_head>:

static void
write_head(void)
{
    80209530:	7179                	addi	sp,sp,-48
    80209532:	f406                	sd	ra,40(sp)
    80209534:	f022                	sd	s0,32(sp)
    80209536:	1800                	addi	s0,sp,48
  struct buf *buf = bread(log.dev, log.start);
    80209538:	0003d797          	auipc	a5,0x3d
    8020953c:	9d878793          	addi	a5,a5,-1576 # 80245f10 <log>
    80209540:	4fdc                	lw	a5,28(a5)
    80209542:	0007871b          	sext.w	a4,a5
    80209546:	0003d797          	auipc	a5,0x3d
    8020954a:	9ca78793          	addi	a5,a5,-1590 # 80245f10 <log>
    8020954e:	4b9c                	lw	a5,16(a5)
    80209550:	2781                	sext.w	a5,a5
    80209552:	85be                	mv	a1,a5
    80209554:	853a                	mv	a0,a4
    80209556:	00000097          	auipc	ra,0x0
    8020955a:	a70080e7          	jalr	-1424(ra) # 80208fc6 <bread>
    8020955e:	fea43023          	sd	a0,-32(s0)
  struct logheader *hb = (struct logheader *) (buf->data);
    80209562:	fe043783          	ld	a5,-32(s0)
    80209566:	05078793          	addi	a5,a5,80
    8020956a:	fcf43c23          	sd	a5,-40(s0)
  int i;
  hb->n = log.lh.n;
    8020956e:	0003d797          	auipc	a5,0x3d
    80209572:	9a278793          	addi	a5,a5,-1630 # 80245f10 <log>
    80209576:	5398                	lw	a4,32(a5)
    80209578:	fd843783          	ld	a5,-40(s0)
    8020957c:	c398                	sw	a4,0(a5)
  for (i = 0; i < log.lh.n; i++) {
    8020957e:	fe042623          	sw	zero,-20(s0)
    80209582:	a03d                	j	802095b0 <write_head+0x80>
    hb->block[i] = log.lh.block[i];
    80209584:	0003d717          	auipc	a4,0x3d
    80209588:	98c70713          	addi	a4,a4,-1652 # 80245f10 <log>
    8020958c:	fec42783          	lw	a5,-20(s0)
    80209590:	07a1                	addi	a5,a5,8
    80209592:	078a                	slli	a5,a5,0x2
    80209594:	97ba                	add	a5,a5,a4
    80209596:	43d8                	lw	a4,4(a5)
    80209598:	fd843683          	ld	a3,-40(s0)
    8020959c:	fec42783          	lw	a5,-20(s0)
    802095a0:	078a                	slli	a5,a5,0x2
    802095a2:	97b6                	add	a5,a5,a3
    802095a4:	c3d8                	sw	a4,4(a5)
  for (i = 0; i < log.lh.n; i++) {
    802095a6:	fec42783          	lw	a5,-20(s0)
    802095aa:	2785                	addiw	a5,a5,1
    802095ac:	fef42623          	sw	a5,-20(s0)
    802095b0:	0003d797          	auipc	a5,0x3d
    802095b4:	96078793          	addi	a5,a5,-1696 # 80245f10 <log>
    802095b8:	5398                	lw	a4,32(a5)
    802095ba:	fec42783          	lw	a5,-20(s0)
    802095be:	2781                	sext.w	a5,a5
    802095c0:	fce7c2e3          	blt	a5,a4,80209584 <write_head+0x54>
  }
  bwrite(buf);
    802095c4:	fe043503          	ld	a0,-32(s0)
    802095c8:	00000097          	auipc	ra,0x0
    802095cc:	a58080e7          	jalr	-1448(ra) # 80209020 <bwrite>
  brelse(buf);
    802095d0:	fe043503          	ld	a0,-32(s0)
    802095d4:	00000097          	auipc	ra,0x0
    802095d8:	a94080e7          	jalr	-1388(ra) # 80209068 <brelse>
}
    802095dc:	0001                	nop
    802095de:	70a2                	ld	ra,40(sp)
    802095e0:	7402                	ld	s0,32(sp)
    802095e2:	6145                	addi	sp,sp,48
    802095e4:	8082                	ret

00000000802095e6 <recover_from_log>:

void
recover_from_log(void)
{
    802095e6:	1141                	addi	sp,sp,-16
    802095e8:	e406                	sd	ra,8(sp)
    802095ea:	e022                	sd	s0,0(sp)
    802095ec:	0800                	addi	s0,sp,16
  read_head();
    802095ee:	00000097          	auipc	ra,0x0
    802095f2:	e98080e7          	jalr	-360(ra) # 80209486 <read_head>
  install_trans(1); // if committed, copy from log to disk
    802095f6:	4505                	li	a0,1
    802095f8:	00000097          	auipc	ra,0x0
    802095fc:	d5a080e7          	jalr	-678(ra) # 80209352 <install_trans>
  log.lh.n = 0;
    80209600:	0003d797          	auipc	a5,0x3d
    80209604:	91078793          	addi	a5,a5,-1776 # 80245f10 <log>
    80209608:	0207a023          	sw	zero,32(a5)
  write_head(); // clear the log
    8020960c:	00000097          	auipc	ra,0x0
    80209610:	f24080e7          	jalr	-220(ra) # 80209530 <write_head>
}
    80209614:	0001                	nop
    80209616:	60a2                	ld	ra,8(sp)
    80209618:	6402                	ld	s0,0(sp)
    8020961a:	0141                	addi	sp,sp,16
    8020961c:	8082                	ret

000000008020961e <begin_op>:
void
begin_op(void)
{
    8020961e:	1141                	addi	sp,sp,-16
    80209620:	e406                	sd	ra,8(sp)
    80209622:	e022                	sd	s0,0(sp)
    80209624:	0800                	addi	s0,sp,16
  acquire(&log.lock);
    80209626:	0003d517          	auipc	a0,0x3d
    8020962a:	8ea50513          	addi	a0,a0,-1814 # 80245f10 <log>
    8020962e:	00003097          	auipc	ra,0x3
    80209632:	b0a080e7          	jalr	-1270(ra) # 8020c138 <acquire>
  while(1){
    if(log.committing){
    80209636:	0003d797          	auipc	a5,0x3d
    8020963a:	8da78793          	addi	a5,a5,-1830 # 80245f10 <log>
    8020963e:	4f9c                	lw	a5,24(a5)
    80209640:	cf91                	beqz	a5,8020965c <begin_op+0x3e>
      sleep(&log, &log.lock);
    80209642:	0003d597          	auipc	a1,0x3d
    80209646:	8ce58593          	addi	a1,a1,-1842 # 80245f10 <log>
    8020964a:	0003d517          	auipc	a0,0x3d
    8020964e:	8c650513          	addi	a0,a0,-1850 # 80245f10 <log>
    80209652:	ffffc097          	auipc	ra,0xffffc
    80209656:	730080e7          	jalr	1840(ra) # 80205d82 <sleep>
    8020965a:	bff1                	j	80209636 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    8020965c:	0003d797          	auipc	a5,0x3d
    80209660:	8b478793          	addi	a5,a5,-1868 # 80245f10 <log>
    80209664:	5398                	lw	a4,32(a5)
    80209666:	0003d797          	auipc	a5,0x3d
    8020966a:	8aa78793          	addi	a5,a5,-1878 # 80245f10 <log>
    8020966e:	4bdc                	lw	a5,20(a5)
    80209670:	2785                	addiw	a5,a5,1
    80209672:	2781                	sext.w	a5,a5
    80209674:	86be                	mv	a3,a5
    80209676:	87b6                	mv	a5,a3
    80209678:	0027979b          	slliw	a5,a5,0x2
    8020967c:	9fb5                	addw	a5,a5,a3
    8020967e:	0017979b          	slliw	a5,a5,0x1
    80209682:	2781                	sext.w	a5,a5
    80209684:	9fb9                	addw	a5,a5,a4
    80209686:	2781                	sext.w	a5,a5
    80209688:	873e                	mv	a4,a5
    8020968a:	47f9                	li	a5,30
    8020968c:	00e7df63          	bge	a5,a4,802096aa <begin_op+0x8c>
      sleep(&log, &log.lock);
    80209690:	0003d597          	auipc	a1,0x3d
    80209694:	88058593          	addi	a1,a1,-1920 # 80245f10 <log>
    80209698:	0003d517          	auipc	a0,0x3d
    8020969c:	87850513          	addi	a0,a0,-1928 # 80245f10 <log>
    802096a0:	ffffc097          	auipc	ra,0xffffc
    802096a4:	6e2080e7          	jalr	1762(ra) # 80205d82 <sleep>
    802096a8:	b779                	j	80209636 <begin_op+0x18>
    } else {
      log.outstanding += 1;
    802096aa:	0003d797          	auipc	a5,0x3d
    802096ae:	86678793          	addi	a5,a5,-1946 # 80245f10 <log>
    802096b2:	4bdc                	lw	a5,20(a5)
    802096b4:	2785                	addiw	a5,a5,1
    802096b6:	0007871b          	sext.w	a4,a5
    802096ba:	0003d797          	auipc	a5,0x3d
    802096be:	85678793          	addi	a5,a5,-1962 # 80245f10 <log>
    802096c2:	cbd8                	sw	a4,20(a5)
      release(&log.lock);
    802096c4:	0003d517          	auipc	a0,0x3d
    802096c8:	84c50513          	addi	a0,a0,-1972 # 80245f10 <log>
    802096cc:	00003097          	auipc	ra,0x3
    802096d0:	ab8080e7          	jalr	-1352(ra) # 8020c184 <release>
      break;
    802096d4:	0001                	nop
    }
  }
}
    802096d6:	0001                	nop
    802096d8:	60a2                	ld	ra,8(sp)
    802096da:	6402                	ld	s0,0(sp)
    802096dc:	0141                	addi	sp,sp,16
    802096de:	8082                	ret

00000000802096e0 <end_op>:

void
end_op(void)
{
    802096e0:	1101                	addi	sp,sp,-32
    802096e2:	ec06                	sd	ra,24(sp)
    802096e4:	e822                	sd	s0,16(sp)
    802096e6:	1000                	addi	s0,sp,32
  int do_commit = 0;
    802096e8:	fe042623          	sw	zero,-20(s0)
  acquire(&log.lock);
    802096ec:	0003d517          	auipc	a0,0x3d
    802096f0:	82450513          	addi	a0,a0,-2012 # 80245f10 <log>
    802096f4:	00003097          	auipc	ra,0x3
    802096f8:	a44080e7          	jalr	-1468(ra) # 8020c138 <acquire>
  log.outstanding -= 1;
    802096fc:	0003d797          	auipc	a5,0x3d
    80209700:	81478793          	addi	a5,a5,-2028 # 80245f10 <log>
    80209704:	4bdc                	lw	a5,20(a5)
    80209706:	37fd                	addiw	a5,a5,-1
    80209708:	0007871b          	sext.w	a4,a5
    8020970c:	0003d797          	auipc	a5,0x3d
    80209710:	80478793          	addi	a5,a5,-2044 # 80245f10 <log>
    80209714:	cbd8                	sw	a4,20(a5)
  if(log.committing)
    80209716:	0003c797          	auipc	a5,0x3c
    8020971a:	7fa78793          	addi	a5,a5,2042 # 80245f10 <log>
    8020971e:	4f9c                	lw	a5,24(a5)
    80209720:	cb89                	beqz	a5,80209732 <end_op+0x52>
    panic("log.committing");
    80209722:	00028517          	auipc	a0,0x28
    80209726:	d6e50513          	addi	a0,a0,-658 # 80231490 <user_test_table+0xb0>
    8020972a:	ffff8097          	auipc	ra,0xffff8
    8020972e:	0dc080e7          	jalr	220(ra) # 80201806 <panic>
  if(log.outstanding == 0){
    80209732:	0003c797          	auipc	a5,0x3c
    80209736:	7de78793          	addi	a5,a5,2014 # 80245f10 <log>
    8020973a:	4bdc                	lw	a5,20(a5)
    8020973c:	eb99                	bnez	a5,80209752 <end_op+0x72>
    do_commit = 1;
    8020973e:	4785                	li	a5,1
    80209740:	fef42623          	sw	a5,-20(s0)
    log.committing = 1;
    80209744:	0003c797          	auipc	a5,0x3c
    80209748:	7cc78793          	addi	a5,a5,1996 # 80245f10 <log>
    8020974c:	4705                	li	a4,1
    8020974e:	cf98                	sw	a4,24(a5)
    80209750:	a809                	j	80209762 <end_op+0x82>
  } else {
    wakeup(&log);
    80209752:	0003c517          	auipc	a0,0x3c
    80209756:	7be50513          	addi	a0,a0,1982 # 80245f10 <log>
    8020975a:	ffffc097          	auipc	ra,0xffffc
    8020975e:	6e0080e7          	jalr	1760(ra) # 80205e3a <wakeup>
  }
  release(&log.lock);
    80209762:	0003c517          	auipc	a0,0x3c
    80209766:	7ae50513          	addi	a0,a0,1966 # 80245f10 <log>
    8020976a:	00003097          	auipc	ra,0x3
    8020976e:	a1a080e7          	jalr	-1510(ra) # 8020c184 <release>

  if(do_commit){
    80209772:	fec42783          	lw	a5,-20(s0)
    80209776:	2781                	sext.w	a5,a5
    80209778:	c3b9                	beqz	a5,802097be <end_op+0xde>
    commit();
    8020977a:	00000097          	auipc	ra,0x0
    8020977e:	134080e7          	jalr	308(ra) # 802098ae <commit>
    acquire(&log.lock);
    80209782:	0003c517          	auipc	a0,0x3c
    80209786:	78e50513          	addi	a0,a0,1934 # 80245f10 <log>
    8020978a:	00003097          	auipc	ra,0x3
    8020978e:	9ae080e7          	jalr	-1618(ra) # 8020c138 <acquire>
    log.committing = 0;
    80209792:	0003c797          	auipc	a5,0x3c
    80209796:	77e78793          	addi	a5,a5,1918 # 80245f10 <log>
    8020979a:	0007ac23          	sw	zero,24(a5)
    wakeup(&log);
    8020979e:	0003c517          	auipc	a0,0x3c
    802097a2:	77250513          	addi	a0,a0,1906 # 80245f10 <log>
    802097a6:	ffffc097          	auipc	ra,0xffffc
    802097aa:	694080e7          	jalr	1684(ra) # 80205e3a <wakeup>
    release(&log.lock);
    802097ae:	0003c517          	auipc	a0,0x3c
    802097b2:	76250513          	addi	a0,a0,1890 # 80245f10 <log>
    802097b6:	00003097          	auipc	ra,0x3
    802097ba:	9ce080e7          	jalr	-1586(ra) # 8020c184 <release>
  }
}
    802097be:	0001                	nop
    802097c0:	60e2                	ld	ra,24(sp)
    802097c2:	6442                	ld	s0,16(sp)
    802097c4:	6105                	addi	sp,sp,32
    802097c6:	8082                	ret

00000000802097c8 <write_log>:
static void
write_log(void)
{
    802097c8:	7179                	addi	sp,sp,-48
    802097ca:	f406                	sd	ra,40(sp)
    802097cc:	f022                	sd	s0,32(sp)
    802097ce:	1800                	addi	s0,sp,48
  int tail;
  for (tail = 0; tail < log.lh.n; tail++) {
    802097d0:	fe042623          	sw	zero,-20(s0)
    802097d4:	a86d                	j	8020988e <write_log+0xc6>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    802097d6:	0003c797          	auipc	a5,0x3c
    802097da:	73a78793          	addi	a5,a5,1850 # 80245f10 <log>
    802097de:	4fdc                	lw	a5,28(a5)
    802097e0:	0007871b          	sext.w	a4,a5
    802097e4:	0003c797          	auipc	a5,0x3c
    802097e8:	72c78793          	addi	a5,a5,1836 # 80245f10 <log>
    802097ec:	4b9c                	lw	a5,16(a5)
    802097ee:	fec42683          	lw	a3,-20(s0)
    802097f2:	9fb5                	addw	a5,a5,a3
    802097f4:	2781                	sext.w	a5,a5
    802097f6:	2785                	addiw	a5,a5,1
    802097f8:	2781                	sext.w	a5,a5
    802097fa:	2781                	sext.w	a5,a5
    802097fc:	85be                	mv	a1,a5
    802097fe:	853a                	mv	a0,a4
    80209800:	fffff097          	auipc	ra,0xfffff
    80209804:	7c6080e7          	jalr	1990(ra) # 80208fc6 <bread>
    80209808:	fea43023          	sd	a0,-32(s0)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8020980c:	0003c797          	auipc	a5,0x3c
    80209810:	70478793          	addi	a5,a5,1796 # 80245f10 <log>
    80209814:	4fdc                	lw	a5,28(a5)
    80209816:	0007869b          	sext.w	a3,a5
    8020981a:	0003c717          	auipc	a4,0x3c
    8020981e:	6f670713          	addi	a4,a4,1782 # 80245f10 <log>
    80209822:	fec42783          	lw	a5,-20(s0)
    80209826:	07a1                	addi	a5,a5,8
    80209828:	078a                	slli	a5,a5,0x2
    8020982a:	97ba                	add	a5,a5,a4
    8020982c:	43dc                	lw	a5,4(a5)
    8020982e:	2781                	sext.w	a5,a5
    80209830:	85be                	mv	a1,a5
    80209832:	8536                	mv	a0,a3
    80209834:	fffff097          	auipc	ra,0xfffff
    80209838:	792080e7          	jalr	1938(ra) # 80208fc6 <bread>
    8020983c:	fca43c23          	sd	a0,-40(s0)
    memmove(to->data, from->data, BSIZE);
    80209840:	fe043783          	ld	a5,-32(s0)
    80209844:	05078713          	addi	a4,a5,80
    80209848:	fd843783          	ld	a5,-40(s0)
    8020984c:	05078793          	addi	a5,a5,80
    80209850:	40000613          	li	a2,1024
    80209854:	85be                	mv	a1,a5
    80209856:	853a                	mv	a0,a4
    80209858:	ffff8097          	auipc	ra,0xffff8
    8020985c:	73c080e7          	jalr	1852(ra) # 80201f94 <memmove>
    bwrite(to);  // write the log
    80209860:	fe043503          	ld	a0,-32(s0)
    80209864:	fffff097          	auipc	ra,0xfffff
    80209868:	7bc080e7          	jalr	1980(ra) # 80209020 <bwrite>
    brelse(from);
    8020986c:	fd843503          	ld	a0,-40(s0)
    80209870:	fffff097          	auipc	ra,0xfffff
    80209874:	7f8080e7          	jalr	2040(ra) # 80209068 <brelse>
    brelse(to);
    80209878:	fe043503          	ld	a0,-32(s0)
    8020987c:	fffff097          	auipc	ra,0xfffff
    80209880:	7ec080e7          	jalr	2028(ra) # 80209068 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80209884:	fec42783          	lw	a5,-20(s0)
    80209888:	2785                	addiw	a5,a5,1
    8020988a:	fef42623          	sw	a5,-20(s0)
    8020988e:	0003c797          	auipc	a5,0x3c
    80209892:	68278793          	addi	a5,a5,1666 # 80245f10 <log>
    80209896:	5398                	lw	a4,32(a5)
    80209898:	fec42783          	lw	a5,-20(s0)
    8020989c:	2781                	sext.w	a5,a5
    8020989e:	f2e7cce3          	blt	a5,a4,802097d6 <write_log+0xe>
  }
}
    802098a2:	0001                	nop
    802098a4:	0001                	nop
    802098a6:	70a2                	ld	ra,40(sp)
    802098a8:	7402                	ld	s0,32(sp)
    802098aa:	6145                	addi	sp,sp,48
    802098ac:	8082                	ret

00000000802098ae <commit>:
static void
commit()
{
    802098ae:	1141                	addi	sp,sp,-16
    802098b0:	e406                	sd	ra,8(sp)
    802098b2:	e022                	sd	s0,0(sp)
    802098b4:	0800                	addi	s0,sp,16
  if (log.lh.n > 0) {
    802098b6:	0003c797          	auipc	a5,0x3c
    802098ba:	65a78793          	addi	a5,a5,1626 # 80245f10 <log>
    802098be:	539c                	lw	a5,32(a5)
    802098c0:	02f05963          	blez	a5,802098f2 <commit+0x44>
    write_log();     // Write modified blocks from cache to log
    802098c4:	00000097          	auipc	ra,0x0
    802098c8:	f04080e7          	jalr	-252(ra) # 802097c8 <write_log>
    write_head();    // Write header to disk -- the real commit
    802098cc:	00000097          	auipc	ra,0x0
    802098d0:	c64080e7          	jalr	-924(ra) # 80209530 <write_head>
    install_trans(0); // Now install writes to home locations
    802098d4:	4501                	li	a0,0
    802098d6:	00000097          	auipc	ra,0x0
    802098da:	a7c080e7          	jalr	-1412(ra) # 80209352 <install_trans>
    log.lh.n = 0;
    802098de:	0003c797          	auipc	a5,0x3c
    802098e2:	63278793          	addi	a5,a5,1586 # 80245f10 <log>
    802098e6:	0207a023          	sw	zero,32(a5)
    write_head();    // Erase the transaction from the log
    802098ea:	00000097          	auipc	ra,0x0
    802098ee:	c46080e7          	jalr	-954(ra) # 80209530 <write_head>
  }
}
    802098f2:	0001                	nop
    802098f4:	60a2                	ld	ra,8(sp)
    802098f6:	6402                	ld	s0,0(sp)
    802098f8:	0141                	addi	sp,sp,16
    802098fa:	8082                	ret

00000000802098fc <log_write>:
void
log_write(struct buf *b)
{
    802098fc:	7179                	addi	sp,sp,-48
    802098fe:	f406                	sd	ra,40(sp)
    80209900:	f022                	sd	s0,32(sp)
    80209902:	1800                	addi	s0,sp,48
    80209904:	fca43c23          	sd	a0,-40(s0)
  int i;

  acquire(&log.lock);
    80209908:	0003c517          	auipc	a0,0x3c
    8020990c:	60850513          	addi	a0,a0,1544 # 80245f10 <log>
    80209910:	00003097          	auipc	ra,0x3
    80209914:	828080e7          	jalr	-2008(ra) # 8020c138 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80209918:	0003c797          	auipc	a5,0x3c
    8020991c:	5f878793          	addi	a5,a5,1528 # 80245f10 <log>
    80209920:	539c                	lw	a5,32(a5)
    80209922:	873e                	mv	a4,a5
    80209924:	47f5                	li	a5,29
    80209926:	00e7da63          	bge	a5,a4,8020993a <log_write+0x3e>
    panic("too big a transaction");
    8020992a:	00028517          	auipc	a0,0x28
    8020992e:	b7650513          	addi	a0,a0,-1162 # 802314a0 <user_test_table+0xc0>
    80209932:	ffff8097          	auipc	ra,0xffff8
    80209936:	ed4080e7          	jalr	-300(ra) # 80201806 <panic>
  if (log.outstanding < 1)
    8020993a:	0003c797          	auipc	a5,0x3c
    8020993e:	5d678793          	addi	a5,a5,1494 # 80245f10 <log>
    80209942:	4bdc                	lw	a5,20(a5)
    80209944:	00f04a63          	bgtz	a5,80209958 <log_write+0x5c>
    panic("log_write outside of trans");
    80209948:	00028517          	auipc	a0,0x28
    8020994c:	b7050513          	addi	a0,a0,-1168 # 802314b8 <user_test_table+0xd8>
    80209950:	ffff8097          	auipc	ra,0xffff8
    80209954:	eb6080e7          	jalr	-330(ra) # 80201806 <panic>

  for (i = 0; i < log.lh.n; i++) {
    80209958:	fe042623          	sw	zero,-20(s0)
    8020995c:	a03d                	j	8020998a <log_write+0x8e>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8020995e:	0003c717          	auipc	a4,0x3c
    80209962:	5b270713          	addi	a4,a4,1458 # 80245f10 <log>
    80209966:	fec42783          	lw	a5,-20(s0)
    8020996a:	07a1                	addi	a5,a5,8
    8020996c:	078a                	slli	a5,a5,0x2
    8020996e:	97ba                	add	a5,a5,a4
    80209970:	43dc                	lw	a5,4(a5)
    80209972:	0007871b          	sext.w	a4,a5
    80209976:	fd843783          	ld	a5,-40(s0)
    8020997a:	47dc                	lw	a5,12(a5)
    8020997c:	02f70263          	beq	a4,a5,802099a0 <log_write+0xa4>
  for (i = 0; i < log.lh.n; i++) {
    80209980:	fec42783          	lw	a5,-20(s0)
    80209984:	2785                	addiw	a5,a5,1
    80209986:	fef42623          	sw	a5,-20(s0)
    8020998a:	0003c797          	auipc	a5,0x3c
    8020998e:	58678793          	addi	a5,a5,1414 # 80245f10 <log>
    80209992:	5398                	lw	a4,32(a5)
    80209994:	fec42783          	lw	a5,-20(s0)
    80209998:	2781                	sext.w	a5,a5
    8020999a:	fce7c2e3          	blt	a5,a4,8020995e <log_write+0x62>
    8020999e:	a011                	j	802099a2 <log_write+0xa6>
      break;
    802099a0:	0001                	nop
  }
  log.lh.block[i] = b->blockno;
    802099a2:	fd843783          	ld	a5,-40(s0)
    802099a6:	47dc                	lw	a5,12(a5)
    802099a8:	0007871b          	sext.w	a4,a5
    802099ac:	0003c697          	auipc	a3,0x3c
    802099b0:	56468693          	addi	a3,a3,1380 # 80245f10 <log>
    802099b4:	fec42783          	lw	a5,-20(s0)
    802099b8:	07a1                	addi	a5,a5,8
    802099ba:	078a                	slli	a5,a5,0x2
    802099bc:	97b6                	add	a5,a5,a3
    802099be:	c3d8                	sw	a4,4(a5)
  if (i == log.lh.n) {  // Add new block to log?
    802099c0:	0003c797          	auipc	a5,0x3c
    802099c4:	55078793          	addi	a5,a5,1360 # 80245f10 <log>
    802099c8:	5398                	lw	a4,32(a5)
    802099ca:	fec42783          	lw	a5,-20(s0)
    802099ce:	2781                	sext.w	a5,a5
    802099d0:	02e79563          	bne	a5,a4,802099fa <log_write+0xfe>
    bpin(b);
    802099d4:	fd843503          	ld	a0,-40(s0)
    802099d8:	fffff097          	auipc	ra,0xfffff
    802099dc:	77e080e7          	jalr	1918(ra) # 80209156 <bpin>
    log.lh.n++;
    802099e0:	0003c797          	auipc	a5,0x3c
    802099e4:	53078793          	addi	a5,a5,1328 # 80245f10 <log>
    802099e8:	539c                	lw	a5,32(a5)
    802099ea:	2785                	addiw	a5,a5,1
    802099ec:	0007871b          	sext.w	a4,a5
    802099f0:	0003c797          	auipc	a5,0x3c
    802099f4:	52078793          	addi	a5,a5,1312 # 80245f10 <log>
    802099f8:	d398                	sw	a4,32(a5)
  }
  release(&log.lock);
    802099fa:	0003c517          	auipc	a0,0x3c
    802099fe:	51650513          	addi	a0,a0,1302 # 80245f10 <log>
    80209a02:	00002097          	auipc	ra,0x2
    80209a06:	782080e7          	jalr	1922(ra) # 8020c184 <release>
}
    80209a0a:	0001                	nop
    80209a0c:	70a2                	ld	ra,40(sp)
    80209a0e:	7402                	ld	s0,32(sp)
    80209a10:	6145                	addi	sp,sp,48
    80209a12:	8082                	ret

0000000080209a14 <fileinit>:
	struct spinlock lock;
	struct file file[NFILE];
} ftable;

void fileinit(void)
{
    80209a14:	1141                	addi	sp,sp,-16
    80209a16:	e406                	sd	ra,8(sp)
    80209a18:	e022                	sd	s0,0(sp)
    80209a1a:	0800                	addi	s0,sp,16
	initlock(&ftable.lock, "ftable");
    80209a1c:	0002a597          	auipc	a1,0x2a
    80209a20:	b6c58593          	addi	a1,a1,-1172 # 80233588 <user_test_table+0x78>
    80209a24:	0003c517          	auipc	a0,0x3c
    80209a28:	62c50513          	addi	a0,a0,1580 # 80246050 <ftable>
    80209a2c:	00002097          	auipc	ra,0x2
    80209a30:	6e4080e7          	jalr	1764(ra) # 8020c110 <initlock>
	printf("fileinit done \n");
    80209a34:	0002a517          	auipc	a0,0x2a
    80209a38:	b5c50513          	addi	a0,a0,-1188 # 80233590 <user_test_table+0x80>
    80209a3c:	ffff8097          	auipc	ra,0xffff8
    80209a40:	848080e7          	jalr	-1976(ra) # 80201284 <printf>
}
    80209a44:	0001                	nop
    80209a46:	60a2                	ld	ra,8(sp)
    80209a48:	6402                	ld	s0,0(sp)
    80209a4a:	0141                	addi	sp,sp,16
    80209a4c:	8082                	ret

0000000080209a4e <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
    80209a4e:	1101                	addi	sp,sp,-32
    80209a50:	ec06                	sd	ra,24(sp)
    80209a52:	e822                	sd	s0,16(sp)
    80209a54:	1000                	addi	s0,sp,32
	struct file *f;
	acquire(&ftable.lock);
    80209a56:	0003c517          	auipc	a0,0x3c
    80209a5a:	5fa50513          	addi	a0,a0,1530 # 80246050 <ftable>
    80209a5e:	00002097          	auipc	ra,0x2
    80209a62:	6da080e7          	jalr	1754(ra) # 8020c138 <acquire>
	for (f = ftable.file; f < ftable.file + NFILE; f++)
    80209a66:	0003c797          	auipc	a5,0x3c
    80209a6a:	5fa78793          	addi	a5,a5,1530 # 80246060 <ftable+0x10>
    80209a6e:	fef43423          	sd	a5,-24(s0)
    80209a72:	a815                	j	80209aa6 <filealloc+0x58>
	{
		if (f->ref == 0)
    80209a74:	fe843783          	ld	a5,-24(s0)
    80209a78:	43dc                	lw	a5,4(a5)
    80209a7a:	e385                	bnez	a5,80209a9a <filealloc+0x4c>
		{
			f->ref = 1;
    80209a7c:	fe843783          	ld	a5,-24(s0)
    80209a80:	4705                	li	a4,1
    80209a82:	c3d8                	sw	a4,4(a5)
			release(&ftable.lock);
    80209a84:	0003c517          	auipc	a0,0x3c
    80209a88:	5cc50513          	addi	a0,a0,1484 # 80246050 <ftable>
    80209a8c:	00002097          	auipc	ra,0x2
    80209a90:	6f8080e7          	jalr	1784(ra) # 8020c184 <release>
			return f;
    80209a94:	fe843783          	ld	a5,-24(s0)
    80209a98:	a805                	j	80209ac8 <filealloc+0x7a>
	for (f = ftable.file; f < ftable.file + NFILE; f++)
    80209a9a:	fe843783          	ld	a5,-24(s0)
    80209a9e:	02878793          	addi	a5,a5,40
    80209aa2:	fef43423          	sd	a5,-24(s0)
    80209aa6:	0003d797          	auipc	a5,0x3d
    80209aaa:	55a78793          	addi	a5,a5,1370 # 80247000 <sb>
    80209aae:	fe843703          	ld	a4,-24(s0)
    80209ab2:	fcf761e3          	bltu	a4,a5,80209a74 <filealloc+0x26>
		}
	}
	release(&ftable.lock);
    80209ab6:	0003c517          	auipc	a0,0x3c
    80209aba:	59a50513          	addi	a0,a0,1434 # 80246050 <ftable>
    80209abe:	00002097          	auipc	ra,0x2
    80209ac2:	6c6080e7          	jalr	1734(ra) # 8020c184 <release>
	return 0;
    80209ac6:	4781                	li	a5,0
}
    80209ac8:	853e                	mv	a0,a5
    80209aca:	60e2                	ld	ra,24(sp)
    80209acc:	6442                	ld	s0,16(sp)
    80209ace:	6105                	addi	sp,sp,32
    80209ad0:	8082                	ret

0000000080209ad2 <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
    80209ad2:	1101                	addi	sp,sp,-32
    80209ad4:	ec06                	sd	ra,24(sp)
    80209ad6:	e822                	sd	s0,16(sp)
    80209ad8:	1000                	addi	s0,sp,32
    80209ada:	fea43423          	sd	a0,-24(s0)
	acquire(&ftable.lock);
    80209ade:	0003c517          	auipc	a0,0x3c
    80209ae2:	57250513          	addi	a0,a0,1394 # 80246050 <ftable>
    80209ae6:	00002097          	auipc	ra,0x2
    80209aea:	652080e7          	jalr	1618(ra) # 8020c138 <acquire>
	if (f->ref < 1)
    80209aee:	fe843783          	ld	a5,-24(s0)
    80209af2:	43dc                	lw	a5,4(a5)
    80209af4:	00f04a63          	bgtz	a5,80209b08 <filedup+0x36>
		panic("filedup");
    80209af8:	0002a517          	auipc	a0,0x2a
    80209afc:	aa850513          	addi	a0,a0,-1368 # 802335a0 <user_test_table+0x90>
    80209b00:	ffff8097          	auipc	ra,0xffff8
    80209b04:	d06080e7          	jalr	-762(ra) # 80201806 <panic>
	f->ref++;
    80209b08:	fe843783          	ld	a5,-24(s0)
    80209b0c:	43dc                	lw	a5,4(a5)
    80209b0e:	2785                	addiw	a5,a5,1
    80209b10:	0007871b          	sext.w	a4,a5
    80209b14:	fe843783          	ld	a5,-24(s0)
    80209b18:	c3d8                	sw	a4,4(a5)
	release(&ftable.lock);
    80209b1a:	0003c517          	auipc	a0,0x3c
    80209b1e:	53650513          	addi	a0,a0,1334 # 80246050 <ftable>
    80209b22:	00002097          	auipc	ra,0x2
    80209b26:	662080e7          	jalr	1634(ra) # 8020c184 <release>
	return f;
    80209b2a:	fe843783          	ld	a5,-24(s0)
}
    80209b2e:	853e                	mv	a0,a5
    80209b30:	60e2                	ld	ra,24(sp)
    80209b32:	6442                	ld	s0,16(sp)
    80209b34:	6105                	addi	sp,sp,32
    80209b36:	8082                	ret

0000000080209b38 <fileopen>:

struct file *fileopen(struct inode *ip, int readable, int writable)
{
    80209b38:	7179                	addi	sp,sp,-48
    80209b3a:	f406                	sd	ra,40(sp)
    80209b3c:	f022                	sd	s0,32(sp)
    80209b3e:	1800                	addi	s0,sp,48
    80209b40:	fca43c23          	sd	a0,-40(s0)
    80209b44:	87ae                	mv	a5,a1
    80209b46:	8732                	mv	a4,a2
    80209b48:	fcf42a23          	sw	a5,-44(s0)
    80209b4c:	87ba                	mv	a5,a4
    80209b4e:	fcf42823          	sw	a5,-48(s0)
	struct file *f = filealloc();
    80209b52:	00000097          	auipc	ra,0x0
    80209b56:	efc080e7          	jalr	-260(ra) # 80209a4e <filealloc>
    80209b5a:	fea43423          	sd	a0,-24(s0)
	if (f == 0)
    80209b5e:	fe843783          	ld	a5,-24(s0)
    80209b62:	e399                	bnez	a5,80209b68 <fileopen+0x30>
		return 0;
    80209b64:	4781                	li	a5,0
    80209b66:	a081                	j	80209ba6 <fileopen+0x6e>
	f->type = FD_INODE;
    80209b68:	fe843783          	ld	a5,-24(s0)
    80209b6c:	4709                	li	a4,2
    80209b6e:	c398                	sw	a4,0(a5)
	f->ip = ip;
    80209b70:	fe843783          	ld	a5,-24(s0)
    80209b74:	fd843703          	ld	a4,-40(s0)
    80209b78:	ef98                	sd	a4,24(a5)
	f->readable = readable;
    80209b7a:	fd442783          	lw	a5,-44(s0)
    80209b7e:	0ff7f713          	zext.b	a4,a5
    80209b82:	fe843783          	ld	a5,-24(s0)
    80209b86:	00e78423          	sb	a4,8(a5)
	f->writable = writable;
    80209b8a:	fd042783          	lw	a5,-48(s0)
    80209b8e:	0ff7f713          	zext.b	a4,a5
    80209b92:	fe843783          	ld	a5,-24(s0)
    80209b96:	00e784a3          	sb	a4,9(a5)
	f->off = 0;
    80209b9a:	fe843783          	ld	a5,-24(s0)
    80209b9e:	0207a023          	sw	zero,32(a5)
	return f;
    80209ba2:	fe843783          	ld	a5,-24(s0)
}
    80209ba6:	853e                	mv	a0,a5
    80209ba8:	70a2                	ld	ra,40(sp)
    80209baa:	7402                	ld	s0,32(sp)
    80209bac:	6145                	addi	sp,sp,48
    80209bae:	8082                	ret

0000000080209bb0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f)
{
    80209bb0:	715d                	addi	sp,sp,-80
    80209bb2:	e486                	sd	ra,72(sp)
    80209bb4:	e0a2                	sd	s0,64(sp)
    80209bb6:	0880                	addi	s0,sp,80
    80209bb8:	faa43c23          	sd	a0,-72(s0)
	struct file ff;

	acquire(&ftable.lock);
    80209bbc:	0003c517          	auipc	a0,0x3c
    80209bc0:	49450513          	addi	a0,a0,1172 # 80246050 <ftable>
    80209bc4:	00002097          	auipc	ra,0x2
    80209bc8:	574080e7          	jalr	1396(ra) # 8020c138 <acquire>
	if (f->ref < 1)
    80209bcc:	fb843783          	ld	a5,-72(s0)
    80209bd0:	43dc                	lw	a5,4(a5)
    80209bd2:	00f04a63          	bgtz	a5,80209be6 <fileclose+0x36>
		panic("fileclose");
    80209bd6:	0002a517          	auipc	a0,0x2a
    80209bda:	9d250513          	addi	a0,a0,-1582 # 802335a8 <user_test_table+0x98>
    80209bde:	ffff8097          	auipc	ra,0xffff8
    80209be2:	c28080e7          	jalr	-984(ra) # 80201806 <panic>
	if (--f->ref > 0)
    80209be6:	fb843783          	ld	a5,-72(s0)
    80209bea:	43dc                	lw	a5,4(a5)
    80209bec:	37fd                	addiw	a5,a5,-1
    80209bee:	0007871b          	sext.w	a4,a5
    80209bf2:	fb843783          	ld	a5,-72(s0)
    80209bf6:	c3d8                	sw	a4,4(a5)
    80209bf8:	fb843783          	ld	a5,-72(s0)
    80209bfc:	43dc                	lw	a5,4(a5)
    80209bfe:	00f05b63          	blez	a5,80209c14 <fileclose+0x64>
	{
		release(&ftable.lock);
    80209c02:	0003c517          	auipc	a0,0x3c
    80209c06:	44e50513          	addi	a0,a0,1102 # 80246050 <ftable>
    80209c0a:	00002097          	auipc	ra,0x2
    80209c0e:	57a080e7          	jalr	1402(ra) # 8020c184 <release>
    80209c12:	a079                	j	80209ca0 <fileclose+0xf0>
		return;
	}
	ff = *f;
    80209c14:	fb843783          	ld	a5,-72(s0)
    80209c18:	638c                	ld	a1,0(a5)
    80209c1a:	6790                	ld	a2,8(a5)
    80209c1c:	6b94                	ld	a3,16(a5)
    80209c1e:	6f98                	ld	a4,24(a5)
    80209c20:	739c                	ld	a5,32(a5)
    80209c22:	fcb43423          	sd	a1,-56(s0)
    80209c26:	fcc43823          	sd	a2,-48(s0)
    80209c2a:	fcd43c23          	sd	a3,-40(s0)
    80209c2e:	fee43023          	sd	a4,-32(s0)
    80209c32:	fef43423          	sd	a5,-24(s0)
	f->ref = 0;
    80209c36:	fb843783          	ld	a5,-72(s0)
    80209c3a:	0007a223          	sw	zero,4(a5)
	f->type = FD_NONE;
    80209c3e:	fb843783          	ld	a5,-72(s0)
    80209c42:	0007a023          	sw	zero,0(a5)
	release(&ftable.lock);
    80209c46:	0003c517          	auipc	a0,0x3c
    80209c4a:	40a50513          	addi	a0,a0,1034 # 80246050 <ftable>
    80209c4e:	00002097          	auipc	ra,0x2
    80209c52:	536080e7          	jalr	1334(ra) # 8020c184 <release>

	if (ff.type == FD_PIPE)
    80209c56:	fc842783          	lw	a5,-56(s0)
    80209c5a:	873e                	mv	a4,a5
    80209c5c:	4785                	li	a5,1
    80209c5e:	00f71e63          	bne	a4,a5,80209c7a <fileclose+0xca>
	{
		pipeclose(ff.pipe, ff.writable);
    80209c62:	fd843783          	ld	a5,-40(s0)
    80209c66:	fd144703          	lbu	a4,-47(s0)
    80209c6a:	2701                	sext.w	a4,a4
    80209c6c:	85ba                	mv	a1,a4
    80209c6e:	853e                	mv	a0,a5
    80209c70:	00000097          	auipc	ra,0x0
    80209c74:	6f8080e7          	jalr	1784(ra) # 8020a368 <pipeclose>
    80209c78:	a025                	j	80209ca0 <fileclose+0xf0>
	}
	else if (ff.type == FD_INODE || ff.type == FD_DEVICE)
    80209c7a:	fc842783          	lw	a5,-56(s0)
    80209c7e:	873e                	mv	a4,a5
    80209c80:	4789                	li	a5,2
    80209c82:	00f70863          	beq	a4,a5,80209c92 <fileclose+0xe2>
    80209c86:	fc842783          	lw	a5,-56(s0)
    80209c8a:	873e                	mv	a4,a5
    80209c8c:	478d                	li	a5,3
    80209c8e:	00f71963          	bne	a4,a5,80209ca0 <fileclose+0xf0>
	{
		iput(ff.ip);
    80209c92:	fe043783          	ld	a5,-32(s0)
    80209c96:	853e                	mv	a0,a5
    80209c98:	00001097          	auipc	ra,0x1
    80209c9c:	2f2080e7          	jalr	754(ra) # 8020af8a <iput>
	}
}
    80209ca0:	60a6                	ld	ra,72(sp)
    80209ca2:	6406                	ld	s0,64(sp)
    80209ca4:	6161                	addi	sp,sp,80
    80209ca6:	8082                	ret

0000000080209ca8 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int filestat(struct file *f, uint64 addr)
{
    80209ca8:	7139                	addi	sp,sp,-64
    80209caa:	fc06                	sd	ra,56(sp)
    80209cac:	f822                	sd	s0,48(sp)
    80209cae:	0080                	addi	s0,sp,64
    80209cb0:	fca43423          	sd	a0,-56(s0)
    80209cb4:	fcb43023          	sd	a1,-64(s0)
	struct proc *p = myproc();
    80209cb8:	ffffb097          	auipc	ra,0xffffb
    80209cbc:	3a8080e7          	jalr	936(ra) # 80205060 <myproc>
    80209cc0:	fea43423          	sd	a0,-24(s0)
	struct stat st;

	if (f->type == FD_INODE || f->type == FD_DEVICE)
    80209cc4:	fc843783          	ld	a5,-56(s0)
    80209cc8:	439c                	lw	a5,0(a5)
    80209cca:	873e                	mv	a4,a5
    80209ccc:	4789                	li	a5,2
    80209cce:	00f70963          	beq	a4,a5,80209ce0 <filestat+0x38>
    80209cd2:	fc843783          	ld	a5,-56(s0)
    80209cd6:	439c                	lw	a5,0(a5)
    80209cd8:	873e                	mv	a4,a5
    80209cda:	478d                	li	a5,3
    80209cdc:	06f71263          	bne	a4,a5,80209d40 <filestat+0x98>
	{
		ilock(f->ip);
    80209ce0:	fc843783          	ld	a5,-56(s0)
    80209ce4:	6f9c                	ld	a5,24(a5)
    80209ce6:	853e                	mv	a0,a5
    80209ce8:	00001097          	auipc	ra,0x1
    80209cec:	10e080e7          	jalr	270(ra) # 8020adf6 <ilock>
		stati(f->ip, &st);
    80209cf0:	fc843783          	ld	a5,-56(s0)
    80209cf4:	6f9c                	ld	a5,24(a5)
    80209cf6:	fd040713          	addi	a4,s0,-48
    80209cfa:	85ba                	mv	a1,a4
    80209cfc:	853e                	mv	a0,a5
    80209cfe:	00001097          	auipc	ra,0x1
    80209d02:	774080e7          	jalr	1908(ra) # 8020b472 <stati>
		iunlock(f->ip);
    80209d06:	fc843783          	ld	a5,-56(s0)
    80209d0a:	6f9c                	ld	a5,24(a5)
    80209d0c:	853e                	mv	a0,a5
    80209d0e:	00001097          	auipc	ra,0x1
    80209d12:	21e080e7          	jalr	542(ra) # 8020af2c <iunlock>
		if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80209d16:	fe843783          	ld	a5,-24(s0)
    80209d1a:	7fdc                	ld	a5,184(a5)
    80209d1c:	fd040713          	addi	a4,s0,-48
    80209d20:	46e1                	li	a3,24
    80209d22:	863a                	mv	a2,a4
    80209d24:	fc043583          	ld	a1,-64(s0)
    80209d28:	853e                	mv	a0,a5
    80209d2a:	ffffa097          	auipc	ra,0xffffa
    80209d2e:	3f8080e7          	jalr	1016(ra) # 80204122 <copyout>
    80209d32:	87aa                	mv	a5,a0
    80209d34:	0007d463          	bgez	a5,80209d3c <filestat+0x94>
			return -1;
    80209d38:	57fd                	li	a5,-1
    80209d3a:	a021                	j	80209d42 <filestat+0x9a>
		return 0;
    80209d3c:	4781                	li	a5,0
    80209d3e:	a011                	j	80209d42 <filestat+0x9a>
	}
	return -1;
    80209d40:	57fd                	li	a5,-1
}
    80209d42:	853e                	mv	a0,a5
    80209d44:	70e2                	ld	ra,56(sp)
    80209d46:	7442                	ld	s0,48(sp)
    80209d48:	6121                	addi	sp,sp,64
    80209d4a:	8082                	ret

0000000080209d4c <filelock>:
// 加锁文件（对 inode 加锁）
void filelock(struct file *f) {
    80209d4c:	1101                	addi	sp,sp,-32
    80209d4e:	ec06                	sd	ra,24(sp)
    80209d50:	e822                	sd	s0,16(sp)
    80209d52:	1000                	addi	s0,sp,32
    80209d54:	fea43423          	sd	a0,-24(s0)
    if (f->type == FD_INODE || f->type == FD_DEVICE) {
    80209d58:	fe843783          	ld	a5,-24(s0)
    80209d5c:	439c                	lw	a5,0(a5)
    80209d5e:	873e                	mv	a4,a5
    80209d60:	4789                	li	a5,2
    80209d62:	00f70963          	beq	a4,a5,80209d74 <filelock+0x28>
    80209d66:	fe843783          	ld	a5,-24(s0)
    80209d6a:	439c                	lw	a5,0(a5)
    80209d6c:	873e                	mv	a4,a5
    80209d6e:	478d                	li	a5,3
    80209d70:	00f71a63          	bne	a4,a5,80209d84 <filelock+0x38>
        ilock(f->ip);
    80209d74:	fe843783          	ld	a5,-24(s0)
    80209d78:	6f9c                	ld	a5,24(a5)
    80209d7a:	853e                	mv	a0,a5
    80209d7c:	00001097          	auipc	ra,0x1
    80209d80:	07a080e7          	jalr	122(ra) # 8020adf6 <ilock>
    }
}
    80209d84:	0001                	nop
    80209d86:	60e2                	ld	ra,24(sp)
    80209d88:	6442                	ld	s0,16(sp)
    80209d8a:	6105                	addi	sp,sp,32
    80209d8c:	8082                	ret

0000000080209d8e <fileunlock>:

// 解锁文件（对 inode 解锁）
void fileunlock(struct file *f) {
    80209d8e:	1101                	addi	sp,sp,-32
    80209d90:	ec06                	sd	ra,24(sp)
    80209d92:	e822                	sd	s0,16(sp)
    80209d94:	1000                	addi	s0,sp,32
    80209d96:	fea43423          	sd	a0,-24(s0)
    if (f->type == FD_INODE || f->type == FD_DEVICE) {
    80209d9a:	fe843783          	ld	a5,-24(s0)
    80209d9e:	439c                	lw	a5,0(a5)
    80209da0:	873e                	mv	a4,a5
    80209da2:	4789                	li	a5,2
    80209da4:	00f70963          	beq	a4,a5,80209db6 <fileunlock+0x28>
    80209da8:	fe843783          	ld	a5,-24(s0)
    80209dac:	439c                	lw	a5,0(a5)
    80209dae:	873e                	mv	a4,a5
    80209db0:	478d                	li	a5,3
    80209db2:	00f71a63          	bne	a4,a5,80209dc6 <fileunlock+0x38>
        iunlock(f->ip);
    80209db6:	fe843783          	ld	a5,-24(s0)
    80209dba:	6f9c                	ld	a5,24(a5)
    80209dbc:	853e                	mv	a0,a5
    80209dbe:	00001097          	auipc	ra,0x1
    80209dc2:	16e080e7          	jalr	366(ra) # 8020af2c <iunlock>
    }
}
    80209dc6:	0001                	nop
    80209dc8:	60e2                	ld	ra,24(sp)
    80209dca:	6442                	ld	s0,16(sp)
    80209dcc:	6105                	addi	sp,sp,32
    80209dce:	8082                	ret

0000000080209dd0 <fileread>:
int fileread(struct file *f, uint64 addr, int n)
{
    80209dd0:	7139                	addi	sp,sp,-64
    80209dd2:	fc06                	sd	ra,56(sp)
    80209dd4:	f822                	sd	s0,48(sp)
    80209dd6:	0080                	addi	s0,sp,64
    80209dd8:	fca43c23          	sd	a0,-40(s0)
    80209ddc:	fcb43823          	sd	a1,-48(s0)
    80209de0:	87b2                	mv	a5,a2
    80209de2:	fcf42623          	sw	a5,-52(s0)
    int r = 0;
    80209de6:	fe042623          	sw	zero,-20(s0)

    if (f->readable == 0)
    80209dea:	fd843783          	ld	a5,-40(s0)
    80209dee:	0087c783          	lbu	a5,8(a5)
    80209df2:	e399                	bnez	a5,80209df8 <fileread+0x28>
        return -1;
    80209df4:	57fd                	li	a5,-1
    80209df6:	a2a1                	j	80209f3e <fileread+0x16e>

    if (f->type == FD_PIPE)
    80209df8:	fd843783          	ld	a5,-40(s0)
    80209dfc:	439c                	lw	a5,0(a5)
    80209dfe:	873e                	mv	a4,a5
    80209e00:	4785                	li	a5,1
    80209e02:	02f71363          	bne	a4,a5,80209e28 <fileread+0x58>
    {
        r = piperead(f->pipe, addr, n);
    80209e06:	fd843783          	ld	a5,-40(s0)
    80209e0a:	6b9c                	ld	a5,16(a5)
    80209e0c:	fcc42703          	lw	a4,-52(s0)
    80209e10:	863a                	mv	a2,a4
    80209e12:	fd043583          	ld	a1,-48(s0)
    80209e16:	853e                	mv	a0,a5
    80209e18:	00000097          	auipc	ra,0x0
    80209e1c:	6e4080e7          	jalr	1764(ra) # 8020a4fc <piperead>
    80209e20:	87aa                	mv	a5,a0
    80209e22:	fef42623          	sw	a5,-20(s0)
    80209e26:	aa11                	j	80209f3a <fileread+0x16a>
    }
    else if (f->type == FD_DEVICE)
    80209e28:	fd843783          	ld	a5,-40(s0)
    80209e2c:	439c                	lw	a5,0(a5)
    80209e2e:	873e                	mv	a4,a5
    80209e30:	478d                	li	a5,3
    80209e32:	06f71463          	bne	a4,a5,80209e9a <fileread+0xca>
    {
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80209e36:	fd843783          	ld	a5,-40(s0)
    80209e3a:	02479783          	lh	a5,36(a5)
    80209e3e:	0207c663          	bltz	a5,80209e6a <fileread+0x9a>
    80209e42:	fd843783          	ld	a5,-40(s0)
    80209e46:	02479783          	lh	a5,36(a5)
    80209e4a:	873e                	mv	a4,a5
    80209e4c:	47a5                	li	a5,9
    80209e4e:	00e7ce63          	blt	a5,a4,80209e6a <fileread+0x9a>
    80209e52:	fd843783          	ld	a5,-40(s0)
    80209e56:	02479783          	lh	a5,36(a5)
    80209e5a:	0003c717          	auipc	a4,0x3c
    80209e5e:	15670713          	addi	a4,a4,342 # 80245fb0 <devsw>
    80209e62:	0792                	slli	a5,a5,0x4
    80209e64:	97ba                	add	a5,a5,a4
    80209e66:	639c                	ld	a5,0(a5)
    80209e68:	e399                	bnez	a5,80209e6e <fileread+0x9e>
            return -1;
    80209e6a:	57fd                	li	a5,-1
    80209e6c:	a8c9                	j	80209f3e <fileread+0x16e>
        r = devsw[f->major].read(1, addr, n);
    80209e6e:	fd843783          	ld	a5,-40(s0)
    80209e72:	02479783          	lh	a5,36(a5)
    80209e76:	0003c717          	auipc	a4,0x3c
    80209e7a:	13a70713          	addi	a4,a4,314 # 80245fb0 <devsw>
    80209e7e:	0792                	slli	a5,a5,0x4
    80209e80:	97ba                	add	a5,a5,a4
    80209e82:	639c                	ld	a5,0(a5)
    80209e84:	fcc42703          	lw	a4,-52(s0)
    80209e88:	863a                	mv	a2,a4
    80209e8a:	fd043583          	ld	a1,-48(s0)
    80209e8e:	4505                	li	a0,1
    80209e90:	9782                	jalr	a5
    80209e92:	87aa                	mv	a5,a0
    80209e94:	fef42623          	sw	a5,-20(s0)
    80209e98:	a04d                	j	80209f3a <fileread+0x16a>
    }
    else if (f->type == FD_INODE)
    80209e9a:	fd843783          	ld	a5,-40(s0)
    80209e9e:	439c                	lw	a5,0(a5)
    80209ea0:	873e                	mv	a4,a5
    80209ea2:	4789                	li	a5,2
    80209ea4:	08f71363          	bne	a4,a5,80209f2a <fileread+0x15a>
    {
        if (!holdingsleep(&f->ip->lock)) {
    80209ea8:	fd843783          	ld	a5,-40(s0)
    80209eac:	6f9c                	ld	a5,24(a5)
    80209eae:	05878793          	addi	a5,a5,88
    80209eb2:	853e                	mv	a0,a5
    80209eb4:	00002097          	auipc	ra,0x2
    80209eb8:	494080e7          	jalr	1172(ra) # 8020c348 <holdingsleep>
    80209ebc:	87aa                	mv	a5,a0
    80209ebe:	e395                	bnez	a5,80209ee2 <fileread+0x112>
            warning("fileread: pid %d must hold inode lock before reading\n", myproc()->pid);
    80209ec0:	ffffb097          	auipc	ra,0xffffb
    80209ec4:	1a0080e7          	jalr	416(ra) # 80205060 <myproc>
    80209ec8:	87aa                	mv	a5,a0
    80209eca:	43dc                	lw	a5,4(a5)
    80209ecc:	85be                	mv	a1,a5
    80209ece:	00029517          	auipc	a0,0x29
    80209ed2:	6ea50513          	addi	a0,a0,1770 # 802335b8 <user_test_table+0xa8>
    80209ed6:	ffff8097          	auipc	ra,0xffff8
    80209eda:	964080e7          	jalr	-1692(ra) # 8020183a <warning>
            return -1;
    80209ede:	57fd                	li	a5,-1
    80209ee0:	a8b9                	j	80209f3e <fileread+0x16e>
        }
        if ((r = readi(f->ip, 0, addr, f->off, n)) > 0)
    80209ee2:	fd843783          	ld	a5,-40(s0)
    80209ee6:	6f88                	ld	a0,24(a5)
    80209ee8:	fd843783          	ld	a5,-40(s0)
    80209eec:	539c                	lw	a5,32(a5)
    80209eee:	fcc42703          	lw	a4,-52(s0)
    80209ef2:	86be                	mv	a3,a5
    80209ef4:	fd043603          	ld	a2,-48(s0)
    80209ef8:	4581                	li	a1,0
    80209efa:	00001097          	auipc	ra,0x1
    80209efe:	6a6080e7          	jalr	1702(ra) # 8020b5a0 <readi>
    80209f02:	87aa                	mv	a5,a0
    80209f04:	fef42623          	sw	a5,-20(s0)
    80209f08:	fec42783          	lw	a5,-20(s0)
    80209f0c:	2781                	sext.w	a5,a5
    80209f0e:	02f05663          	blez	a5,80209f3a <fileread+0x16a>
            f->off += r;
    80209f12:	fd843783          	ld	a5,-40(s0)
    80209f16:	5398                	lw	a4,32(a5)
    80209f18:	fec42783          	lw	a5,-20(s0)
    80209f1c:	9fb9                	addw	a5,a5,a4
    80209f1e:	0007871b          	sext.w	a4,a5
    80209f22:	fd843783          	ld	a5,-40(s0)
    80209f26:	d398                	sw	a4,32(a5)
    80209f28:	a809                	j	80209f3a <fileread+0x16a>
    }
    else
    {
        panic("fileread");
    80209f2a:	00029517          	auipc	a0,0x29
    80209f2e:	6c650513          	addi	a0,a0,1734 # 802335f0 <user_test_table+0xe0>
    80209f32:	ffff8097          	auipc	ra,0xffff8
    80209f36:	8d4080e7          	jalr	-1836(ra) # 80201806 <panic>
    }

    return r;
    80209f3a:	fec42783          	lw	a5,-20(s0)
}
    80209f3e:	853e                	mv	a0,a5
    80209f40:	70e2                	ld	ra,56(sp)
    80209f42:	7442                	ld	s0,48(sp)
    80209f44:	6121                	addi	sp,sp,64
    80209f46:	8082                	ret

0000000080209f48 <filewrite>:

int filewrite(struct file *f, uint64 addr, int n)
{
    80209f48:	715d                	addi	sp,sp,-80
    80209f4a:	e486                	sd	ra,72(sp)
    80209f4c:	e0a2                	sd	s0,64(sp)
    80209f4e:	0880                	addi	s0,sp,80
    80209f50:	fca43423          	sd	a0,-56(s0)
    80209f54:	fcb43023          	sd	a1,-64(s0)
    80209f58:	87b2                	mv	a5,a2
    80209f5a:	faf42e23          	sw	a5,-68(s0)
    int r, ret = 0;
    80209f5e:	fe042623          	sw	zero,-20(s0)

    if (f->writable == 0)
    80209f62:	fc843783          	ld	a5,-56(s0)
    80209f66:	0097c783          	lbu	a5,9(a5)
    80209f6a:	e399                	bnez	a5,80209f70 <filewrite+0x28>
        return -1;
    80209f6c:	57fd                	li	a5,-1
    80209f6e:	a2cd                	j	8020a150 <filewrite+0x208>

    if (f->type == FD_PIPE)
    80209f70:	fc843783          	ld	a5,-56(s0)
    80209f74:	439c                	lw	a5,0(a5)
    80209f76:	873e                	mv	a4,a5
    80209f78:	4785                	li	a5,1
    80209f7a:	02f71363          	bne	a4,a5,80209fa0 <filewrite+0x58>
    {
        ret = pipewrite(f->pipe, addr, n);
    80209f7e:	fc843783          	ld	a5,-56(s0)
    80209f82:	6b9c                	ld	a5,16(a5)
    80209f84:	fbc42703          	lw	a4,-68(s0)
    80209f88:	863a                	mv	a2,a4
    80209f8a:	fc043583          	ld	a1,-64(s0)
    80209f8e:	853e                	mv	a0,a5
    80209f90:	00000097          	auipc	ra,0x0
    80209f94:	452080e7          	jalr	1106(ra) # 8020a3e2 <pipewrite>
    80209f98:	87aa                	mv	a5,a0
    80209f9a:	fef42623          	sw	a5,-20(s0)
    80209f9e:	a27d                	j	8020a14c <filewrite+0x204>
    }
    else if (f->type == FD_DEVICE)
    80209fa0:	fc843783          	ld	a5,-56(s0)
    80209fa4:	439c                	lw	a5,0(a5)
    80209fa6:	873e                	mv	a4,a5
    80209fa8:	478d                	li	a5,3
    80209faa:	06f71463          	bne	a4,a5,8020a012 <filewrite+0xca>
    {
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80209fae:	fc843783          	ld	a5,-56(s0)
    80209fb2:	02479783          	lh	a5,36(a5)
    80209fb6:	0207c663          	bltz	a5,80209fe2 <filewrite+0x9a>
    80209fba:	fc843783          	ld	a5,-56(s0)
    80209fbe:	02479783          	lh	a5,36(a5)
    80209fc2:	873e                	mv	a4,a5
    80209fc4:	47a5                	li	a5,9
    80209fc6:	00e7ce63          	blt	a5,a4,80209fe2 <filewrite+0x9a>
    80209fca:	fc843783          	ld	a5,-56(s0)
    80209fce:	02479783          	lh	a5,36(a5)
    80209fd2:	0003c717          	auipc	a4,0x3c
    80209fd6:	fde70713          	addi	a4,a4,-34 # 80245fb0 <devsw>
    80209fda:	0792                	slli	a5,a5,0x4
    80209fdc:	97ba                	add	a5,a5,a4
    80209fde:	679c                	ld	a5,8(a5)
    80209fe0:	e399                	bnez	a5,80209fe6 <filewrite+0x9e>
            return -1;
    80209fe2:	57fd                	li	a5,-1
    80209fe4:	a2b5                	j	8020a150 <filewrite+0x208>
        ret = devsw[f->major].write(1, addr, n);
    80209fe6:	fc843783          	ld	a5,-56(s0)
    80209fea:	02479783          	lh	a5,36(a5)
    80209fee:	0003c717          	auipc	a4,0x3c
    80209ff2:	fc270713          	addi	a4,a4,-62 # 80245fb0 <devsw>
    80209ff6:	0792                	slli	a5,a5,0x4
    80209ff8:	97ba                	add	a5,a5,a4
    80209ffa:	679c                	ld	a5,8(a5)
    80209ffc:	fbc42703          	lw	a4,-68(s0)
    8020a000:	863a                	mv	a2,a4
    8020a002:	fc043583          	ld	a1,-64(s0)
    8020a006:	4505                	li	a0,1
    8020a008:	9782                	jalr	a5
    8020a00a:	87aa                	mv	a5,a0
    8020a00c:	fef42623          	sw	a5,-20(s0)
    8020a010:	aa35                	j	8020a14c <filewrite+0x204>
    }
    else if (f->type == FD_INODE)
    8020a012:	fc843783          	ld	a5,-56(s0)
    8020a016:	439c                	lw	a5,0(a5)
    8020a018:	873e                	mv	a4,a5
    8020a01a:	4789                	li	a5,2
    8020a01c:	12f71063          	bne	a4,a5,8020a13c <filewrite+0x1f4>
    {
        if (!holdingsleep(&f->ip->lock)) {
    8020a020:	fc843783          	ld	a5,-56(s0)
    8020a024:	6f9c                	ld	a5,24(a5)
    8020a026:	05878793          	addi	a5,a5,88
    8020a02a:	853e                	mv	a0,a5
    8020a02c:	00002097          	auipc	ra,0x2
    8020a030:	31c080e7          	jalr	796(ra) # 8020c348 <holdingsleep>
    8020a034:	87aa                	mv	a5,a0
    8020a036:	e395                	bnez	a5,8020a05a <filewrite+0x112>
            warning("filewrite: pid %d must hold inode lock before writing\n", myproc()->pid);
    8020a038:	ffffb097          	auipc	ra,0xffffb
    8020a03c:	028080e7          	jalr	40(ra) # 80205060 <myproc>
    8020a040:	87aa                	mv	a5,a0
    8020a042:	43dc                	lw	a5,4(a5)
    8020a044:	85be                	mv	a1,a5
    8020a046:	00029517          	auipc	a0,0x29
    8020a04a:	5ba50513          	addi	a0,a0,1466 # 80233600 <user_test_table+0xf0>
    8020a04e:	ffff7097          	auipc	ra,0xffff7
    8020a052:	7ec080e7          	jalr	2028(ra) # 8020183a <warning>
            return -1;
    8020a056:	57fd                	li	a5,-1
    8020a058:	a8e5                	j	8020a150 <filewrite+0x208>
        }
        int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    8020a05a:	6785                	lui	a5,0x1
    8020a05c:	c0078793          	addi	a5,a5,-1024 # c00 <_entry-0x801ff400>
    8020a060:	fef42023          	sw	a5,-32(s0)
        int i = 0;
    8020a064:	fe042423          	sw	zero,-24(s0)
        while (i < n)
    8020a068:	a879                	j	8020a106 <filewrite+0x1be>
        {
            int n1 = n - i;
    8020a06a:	fbc42783          	lw	a5,-68(s0)
    8020a06e:	873e                	mv	a4,a5
    8020a070:	fe842783          	lw	a5,-24(s0)
    8020a074:	40f707bb          	subw	a5,a4,a5
    8020a078:	fef42223          	sw	a5,-28(s0)
            if (n1 > max)
    8020a07c:	fe442783          	lw	a5,-28(s0)
    8020a080:	873e                	mv	a4,a5
    8020a082:	fe042783          	lw	a5,-32(s0)
    8020a086:	2701                	sext.w	a4,a4
    8020a088:	2781                	sext.w	a5,a5
    8020a08a:	00e7d663          	bge	a5,a4,8020a096 <filewrite+0x14e>
                n1 = max;
    8020a08e:	fe042783          	lw	a5,-32(s0)
    8020a092:	fef42223          	sw	a5,-28(s0)

            if ((r = writei(f->ip, 0, addr + i, f->off, n1)) > 0)
    8020a096:	fc843783          	ld	a5,-56(s0)
    8020a09a:	6f88                	ld	a0,24(a5)
    8020a09c:	fe842703          	lw	a4,-24(s0)
    8020a0a0:	fc043783          	ld	a5,-64(s0)
    8020a0a4:	00f70633          	add	a2,a4,a5
    8020a0a8:	fc843783          	ld	a5,-56(s0)
    8020a0ac:	539c                	lw	a5,32(a5)
    8020a0ae:	fe442703          	lw	a4,-28(s0)
    8020a0b2:	86be                	mv	a3,a5
    8020a0b4:	4581                	li	a1,0
    8020a0b6:	00001097          	auipc	ra,0x1
    8020a0ba:	688080e7          	jalr	1672(ra) # 8020b73e <writei>
    8020a0be:	87aa                	mv	a5,a0
    8020a0c0:	fcf42e23          	sw	a5,-36(s0)
    8020a0c4:	fdc42783          	lw	a5,-36(s0)
    8020a0c8:	2781                	sext.w	a5,a5
    8020a0ca:	00f05d63          	blez	a5,8020a0e4 <filewrite+0x19c>
                f->off += r;
    8020a0ce:	fc843783          	ld	a5,-56(s0)
    8020a0d2:	5398                	lw	a4,32(a5)
    8020a0d4:	fdc42783          	lw	a5,-36(s0)
    8020a0d8:	9fb9                	addw	a5,a5,a4
    8020a0da:	0007871b          	sext.w	a4,a5
    8020a0de:	fc843783          	ld	a5,-56(s0)
    8020a0e2:	d398                	sw	a4,32(a5)

            if (r != n1)
    8020a0e4:	fdc42783          	lw	a5,-36(s0)
    8020a0e8:	873e                	mv	a4,a5
    8020a0ea:	fe442783          	lw	a5,-28(s0)
    8020a0ee:	2701                	sext.w	a4,a4
    8020a0f0:	2781                	sext.w	a5,a5
    8020a0f2:	02f71463          	bne	a4,a5,8020a11a <filewrite+0x1d2>
            {
                // error from writei
                break;
            }
            i += r;
    8020a0f6:	fe842783          	lw	a5,-24(s0)
    8020a0fa:	873e                	mv	a4,a5
    8020a0fc:	fdc42783          	lw	a5,-36(s0)
    8020a100:	9fb9                	addw	a5,a5,a4
    8020a102:	fef42423          	sw	a5,-24(s0)
        while (i < n)
    8020a106:	fe842783          	lw	a5,-24(s0)
    8020a10a:	873e                	mv	a4,a5
    8020a10c:	fbc42783          	lw	a5,-68(s0)
    8020a110:	2701                	sext.w	a4,a4
    8020a112:	2781                	sext.w	a5,a5
    8020a114:	f4f74be3          	blt	a4,a5,8020a06a <filewrite+0x122>
    8020a118:	a011                	j	8020a11c <filewrite+0x1d4>
                break;
    8020a11a:	0001                	nop
        }
        ret = (i == n ? n : -1);
    8020a11c:	fe842783          	lw	a5,-24(s0)
    8020a120:	873e                	mv	a4,a5
    8020a122:	fbc42783          	lw	a5,-68(s0)
    8020a126:	2701                	sext.w	a4,a4
    8020a128:	2781                	sext.w	a5,a5
    8020a12a:	00f71563          	bne	a4,a5,8020a134 <filewrite+0x1ec>
    8020a12e:	fbc42783          	lw	a5,-68(s0)
    8020a132:	a011                	j	8020a136 <filewrite+0x1ee>
    8020a134:	57fd                	li	a5,-1
    8020a136:	fef42623          	sw	a5,-20(s0)
    8020a13a:	a809                	j	8020a14c <filewrite+0x204>
    }
    else
    {
        panic("filewrite");
    8020a13c:	00029517          	auipc	a0,0x29
    8020a140:	4fc50513          	addi	a0,a0,1276 # 80233638 <user_test_table+0x128>
    8020a144:	ffff7097          	auipc	ra,0xffff7
    8020a148:	6c2080e7          	jalr	1730(ra) # 80201806 <panic>
    }

    return ret;
    8020a14c:	fec42783          	lw	a5,-20(s0)
}
    8020a150:	853e                	mv	a0,a5
    8020a152:	60a6                	ld	ra,72(sp)
    8020a154:	6406                	ld	s0,64(sp)
    8020a156:	6161                	addi	sp,sp,80
    8020a158:	8082                	ret

000000008020a15a <read>:
int read(struct file *f, uint64 addr, int n) {
    8020a15a:	7139                	addi	sp,sp,-64
    8020a15c:	fc06                	sd	ra,56(sp)
    8020a15e:	f822                	sd	s0,48(sp)
    8020a160:	0080                	addi	s0,sp,64
    8020a162:	fca43c23          	sd	a0,-40(s0)
    8020a166:	fcb43823          	sd	a1,-48(s0)
    8020a16a:	87b2                	mv	a5,a2
    8020a16c:	fcf42623          	sw	a5,-52(s0)
    int ret;
    begin_op();
    8020a170:	fffff097          	auipc	ra,0xfffff
    8020a174:	4ae080e7          	jalr	1198(ra) # 8020961e <begin_op>
    filelock(f);
    8020a178:	fd843503          	ld	a0,-40(s0)
    8020a17c:	00000097          	auipc	ra,0x0
    8020a180:	bd0080e7          	jalr	-1072(ra) # 80209d4c <filelock>
    ret = fileread(f, addr, n);
    8020a184:	fcc42783          	lw	a5,-52(s0)
    8020a188:	863e                	mv	a2,a5
    8020a18a:	fd043583          	ld	a1,-48(s0)
    8020a18e:	fd843503          	ld	a0,-40(s0)
    8020a192:	00000097          	auipc	ra,0x0
    8020a196:	c3e080e7          	jalr	-962(ra) # 80209dd0 <fileread>
    8020a19a:	87aa                	mv	a5,a0
    8020a19c:	fef42623          	sw	a5,-20(s0)
    fileunlock(f);
    8020a1a0:	fd843503          	ld	a0,-40(s0)
    8020a1a4:	00000097          	auipc	ra,0x0
    8020a1a8:	bea080e7          	jalr	-1046(ra) # 80209d8e <fileunlock>
    end_op();
    8020a1ac:	fffff097          	auipc	ra,0xfffff
    8020a1b0:	534080e7          	jalr	1332(ra) # 802096e0 <end_op>
    return ret;
    8020a1b4:	fec42783          	lw	a5,-20(s0)
}
    8020a1b8:	853e                	mv	a0,a5
    8020a1ba:	70e2                	ld	ra,56(sp)
    8020a1bc:	7442                	ld	s0,48(sp)
    8020a1be:	6121                	addi	sp,sp,64
    8020a1c0:	8082                	ret

000000008020a1c2 <write>:

int write(struct file *f, uint64 addr, int n) {
    8020a1c2:	7139                	addi	sp,sp,-64
    8020a1c4:	fc06                	sd	ra,56(sp)
    8020a1c6:	f822                	sd	s0,48(sp)
    8020a1c8:	0080                	addi	s0,sp,64
    8020a1ca:	fca43c23          	sd	a0,-40(s0)
    8020a1ce:	fcb43823          	sd	a1,-48(s0)
    8020a1d2:	87b2                	mv	a5,a2
    8020a1d4:	fcf42623          	sw	a5,-52(s0)
    int ret;
    begin_op();
    8020a1d8:	fffff097          	auipc	ra,0xfffff
    8020a1dc:	446080e7          	jalr	1094(ra) # 8020961e <begin_op>
    filelock(f);
    8020a1e0:	fd843503          	ld	a0,-40(s0)
    8020a1e4:	00000097          	auipc	ra,0x0
    8020a1e8:	b68080e7          	jalr	-1176(ra) # 80209d4c <filelock>
    ret = filewrite(f, addr, n);
    8020a1ec:	fcc42783          	lw	a5,-52(s0)
    8020a1f0:	863e                	mv	a2,a5
    8020a1f2:	fd043583          	ld	a1,-48(s0)
    8020a1f6:	fd843503          	ld	a0,-40(s0)
    8020a1fa:	00000097          	auipc	ra,0x0
    8020a1fe:	d4e080e7          	jalr	-690(ra) # 80209f48 <filewrite>
    8020a202:	87aa                	mv	a5,a0
    8020a204:	fef42623          	sw	a5,-20(s0)
    fileunlock(f);
    8020a208:	fd843503          	ld	a0,-40(s0)
    8020a20c:	00000097          	auipc	ra,0x0
    8020a210:	b82080e7          	jalr	-1150(ra) # 80209d8e <fileunlock>
    end_op();
    8020a214:	fffff097          	auipc	ra,0xfffff
    8020a218:	4cc080e7          	jalr	1228(ra) # 802096e0 <end_op>
    return ret;
    8020a21c:	fec42783          	lw	a5,-20(s0)
    8020a220:	853e                	mv	a0,a5
    8020a222:	70e2                	ld	ra,56(sp)
    8020a224:	7442                	ld	s0,48(sp)
    8020a226:	6121                	addi	sp,sp,64
    8020a228:	8082                	ret

000000008020a22a <pipealloc>:
#include "defs.h"

int
pipealloc(struct file **f0, struct file **f1)
{
    8020a22a:	7179                	addi	sp,sp,-48
    8020a22c:	f406                	sd	ra,40(sp)
    8020a22e:	f022                	sd	s0,32(sp)
    8020a230:	1800                	addi	s0,sp,48
    8020a232:	fca43c23          	sd	a0,-40(s0)
    8020a236:	fcb43823          	sd	a1,-48(s0)
  struct pipe *pi;

  pi = 0;
    8020a23a:	fe043423          	sd	zero,-24(s0)
  *f0 = *f1 = 0;
    8020a23e:	fd043783          	ld	a5,-48(s0)
    8020a242:	0007b023          	sd	zero,0(a5)
    8020a246:	fd043783          	ld	a5,-48(s0)
    8020a24a:	6398                	ld	a4,0(a5)
    8020a24c:	fd843783          	ld	a5,-40(s0)
    8020a250:	e398                	sd	a4,0(a5)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8020a252:	fffff097          	auipc	ra,0xfffff
    8020a256:	7fc080e7          	jalr	2044(ra) # 80209a4e <filealloc>
    8020a25a:	872a                	mv	a4,a0
    8020a25c:	fd843783          	ld	a5,-40(s0)
    8020a260:	e398                	sd	a4,0(a5)
    8020a262:	fd843783          	ld	a5,-40(s0)
    8020a266:	639c                	ld	a5,0(a5)
    8020a268:	c7d5                	beqz	a5,8020a314 <pipealloc+0xea>
    8020a26a:	fffff097          	auipc	ra,0xfffff
    8020a26e:	7e4080e7          	jalr	2020(ra) # 80209a4e <filealloc>
    8020a272:	872a                	mv	a4,a0
    8020a274:	fd043783          	ld	a5,-48(s0)
    8020a278:	e398                	sd	a4,0(a5)
    8020a27a:	fd043783          	ld	a5,-48(s0)
    8020a27e:	639c                	ld	a5,0(a5)
    8020a280:	cbd1                	beqz	a5,8020a314 <pipealloc+0xea>
    goto bad;
  if((pi = (struct pipe*)alloc_page()) == 0)
    8020a282:	ffff9097          	auipc	ra,0xffff9
    8020a286:	0da080e7          	jalr	218(ra) # 8020335c <alloc_page>
    8020a28a:	fea43423          	sd	a0,-24(s0)
    8020a28e:	fe843783          	ld	a5,-24(s0)
    8020a292:	c3d9                	beqz	a5,8020a318 <pipealloc+0xee>
    goto bad;
  pi->readopen = 1;
    8020a294:	fe843783          	ld	a5,-24(s0)
    8020a298:	4705                	li	a4,1
    8020a29a:	20e7a423          	sw	a4,520(a5)
  pi->writeopen = 1;
    8020a29e:	fe843783          	ld	a5,-24(s0)
    8020a2a2:	4705                	li	a4,1
    8020a2a4:	20e7a623          	sw	a4,524(a5)
  pi->nwrite = 0;
    8020a2a8:	fe843783          	ld	a5,-24(s0)
    8020a2ac:	2007a223          	sw	zero,516(a5)
  pi->nread = 0;
    8020a2b0:	fe843783          	ld	a5,-24(s0)
    8020a2b4:	2007a023          	sw	zero,512(a5)
  (*f0)->type = FD_PIPE;
    8020a2b8:	fd843783          	ld	a5,-40(s0)
    8020a2bc:	639c                	ld	a5,0(a5)
    8020a2be:	4705                	li	a4,1
    8020a2c0:	c398                	sw	a4,0(a5)
  (*f0)->readable = 1;
    8020a2c2:	fd843783          	ld	a5,-40(s0)
    8020a2c6:	639c                	ld	a5,0(a5)
    8020a2c8:	4705                	li	a4,1
    8020a2ca:	00e78423          	sb	a4,8(a5)
  (*f0)->writable = 0;
    8020a2ce:	fd843783          	ld	a5,-40(s0)
    8020a2d2:	639c                	ld	a5,0(a5)
    8020a2d4:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8020a2d8:	fd843783          	ld	a5,-40(s0)
    8020a2dc:	639c                	ld	a5,0(a5)
    8020a2de:	fe843703          	ld	a4,-24(s0)
    8020a2e2:	eb98                	sd	a4,16(a5)
  (*f1)->type = FD_PIPE;
    8020a2e4:	fd043783          	ld	a5,-48(s0)
    8020a2e8:	639c                	ld	a5,0(a5)
    8020a2ea:	4705                	li	a4,1
    8020a2ec:	c398                	sw	a4,0(a5)
  (*f1)->readable = 0;
    8020a2ee:	fd043783          	ld	a5,-48(s0)
    8020a2f2:	639c                	ld	a5,0(a5)
    8020a2f4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8020a2f8:	fd043783          	ld	a5,-48(s0)
    8020a2fc:	639c                	ld	a5,0(a5)
    8020a2fe:	4705                	li	a4,1
    8020a300:	00e784a3          	sb	a4,9(a5)
  (*f1)->pipe = pi;
    8020a304:	fd043783          	ld	a5,-48(s0)
    8020a308:	639c                	ld	a5,0(a5)
    8020a30a:	fe843703          	ld	a4,-24(s0)
    8020a30e:	eb98                	sd	a4,16(a5)
  return 0;
    8020a310:	4781                	li	a5,0
    8020a312:	a0b1                	j	8020a35e <pipealloc+0x134>
    goto bad;
    8020a314:	0001                	nop
    8020a316:	a011                	j	8020a31a <pipealloc+0xf0>
    goto bad;
    8020a318:	0001                	nop

 bad:
  if(pi)
    8020a31a:	fe843783          	ld	a5,-24(s0)
    8020a31e:	c799                	beqz	a5,8020a32c <pipealloc+0x102>
    free_page((char*)pi);
    8020a320:	fe843503          	ld	a0,-24(s0)
    8020a324:	ffff9097          	auipc	ra,0xffff9
    8020a328:	0a4080e7          	jalr	164(ra) # 802033c8 <free_page>
  if(*f0)
    8020a32c:	fd843783          	ld	a5,-40(s0)
    8020a330:	639c                	ld	a5,0(a5)
    8020a332:	cb89                	beqz	a5,8020a344 <pipealloc+0x11a>
    fileclose(*f0);
    8020a334:	fd843783          	ld	a5,-40(s0)
    8020a338:	639c                	ld	a5,0(a5)
    8020a33a:	853e                	mv	a0,a5
    8020a33c:	00000097          	auipc	ra,0x0
    8020a340:	874080e7          	jalr	-1932(ra) # 80209bb0 <fileclose>
  if(*f1)
    8020a344:	fd043783          	ld	a5,-48(s0)
    8020a348:	639c                	ld	a5,0(a5)
    8020a34a:	cb89                	beqz	a5,8020a35c <pipealloc+0x132>
    fileclose(*f1);
    8020a34c:	fd043783          	ld	a5,-48(s0)
    8020a350:	639c                	ld	a5,0(a5)
    8020a352:	853e                	mv	a0,a5
    8020a354:	00000097          	auipc	ra,0x0
    8020a358:	85c080e7          	jalr	-1956(ra) # 80209bb0 <fileclose>
  return -1;
    8020a35c:	57fd                	li	a5,-1
}
    8020a35e:	853e                	mv	a0,a5
    8020a360:	70a2                	ld	ra,40(sp)
    8020a362:	7402                	ld	s0,32(sp)
    8020a364:	6145                	addi	sp,sp,48
    8020a366:	8082                	ret

000000008020a368 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8020a368:	1101                	addi	sp,sp,-32
    8020a36a:	ec06                	sd	ra,24(sp)
    8020a36c:	e822                	sd	s0,16(sp)
    8020a36e:	1000                	addi	s0,sp,32
    8020a370:	fea43423          	sd	a0,-24(s0)
    8020a374:	87ae                	mv	a5,a1
    8020a376:	fef42223          	sw	a5,-28(s0)
  if(writable){
    8020a37a:	fe442783          	lw	a5,-28(s0)
    8020a37e:	2781                	sext.w	a5,a5
    8020a380:	cf99                	beqz	a5,8020a39e <pipeclose+0x36>
    pi->writeopen = 0;
    8020a382:	fe843783          	ld	a5,-24(s0)
    8020a386:	2007a623          	sw	zero,524(a5)
    wakeup(&pi->nread);
    8020a38a:	fe843783          	ld	a5,-24(s0)
    8020a38e:	20078793          	addi	a5,a5,512
    8020a392:	853e                	mv	a0,a5
    8020a394:	ffffc097          	auipc	ra,0xffffc
    8020a398:	aa6080e7          	jalr	-1370(ra) # 80205e3a <wakeup>
    8020a39c:	a831                	j	8020a3b8 <pipeclose+0x50>
  } else {
    pi->readopen = 0;
    8020a39e:	fe843783          	ld	a5,-24(s0)
    8020a3a2:	2007a423          	sw	zero,520(a5)
    wakeup(&pi->nwrite);
    8020a3a6:	fe843783          	ld	a5,-24(s0)
    8020a3aa:	20478793          	addi	a5,a5,516
    8020a3ae:	853e                	mv	a0,a5
    8020a3b0:	ffffc097          	auipc	ra,0xffffc
    8020a3b4:	a8a080e7          	jalr	-1398(ra) # 80205e3a <wakeup>
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8020a3b8:	fe843783          	ld	a5,-24(s0)
    8020a3bc:	2087a783          	lw	a5,520(a5)
    8020a3c0:	ef81                	bnez	a5,8020a3d8 <pipeclose+0x70>
    8020a3c2:	fe843783          	ld	a5,-24(s0)
    8020a3c6:	20c7a783          	lw	a5,524(a5)
    8020a3ca:	e799                	bnez	a5,8020a3d8 <pipeclose+0x70>
    free_page((char*)pi);
    8020a3cc:	fe843503          	ld	a0,-24(s0)
    8020a3d0:	ffff9097          	auipc	ra,0xffff9
    8020a3d4:	ff8080e7          	jalr	-8(ra) # 802033c8 <free_page>
  }
}
    8020a3d8:	0001                	nop
    8020a3da:	60e2                	ld	ra,24(sp)
    8020a3dc:	6442                	ld	s0,16(sp)
    8020a3de:	6105                	addi	sp,sp,32
    8020a3e0:	8082                	ret

000000008020a3e2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8020a3e2:	715d                	addi	sp,sp,-80
    8020a3e4:	e486                	sd	ra,72(sp)
    8020a3e6:	e0a2                	sd	s0,64(sp)
    8020a3e8:	0880                	addi	s0,sp,80
    8020a3ea:	fca43423          	sd	a0,-56(s0)
    8020a3ee:	fcb43023          	sd	a1,-64(s0)
    8020a3f2:	87b2                	mv	a5,a2
    8020a3f4:	faf42e23          	sw	a5,-68(s0)
  int i = 0;
    8020a3f8:	fe042623          	sw	zero,-20(s0)
  struct proc *pr = myproc();
    8020a3fc:	ffffb097          	auipc	ra,0xffffb
    8020a400:	c64080e7          	jalr	-924(ra) # 80205060 <myproc>
    8020a404:	fea43023          	sd	a0,-32(s0)

  while(i < n){
    8020a408:	a87d                	j	8020a4c6 <pipewrite+0xe4>
    if(pi->readopen == 0 || pr->killed){
    8020a40a:	fc843783          	ld	a5,-56(s0)
    8020a40e:	2087a783          	lw	a5,520(a5)
    8020a412:	c791                	beqz	a5,8020a41e <pipewrite+0x3c>
    8020a414:	fe043783          	ld	a5,-32(s0)
    8020a418:	0807a783          	lw	a5,128(a5)
    8020a41c:	c399                	beqz	a5,8020a422 <pipewrite+0x40>
      return -1;
    8020a41e:	57fd                	li	a5,-1
    8020a420:	a8c9                	j	8020a4f2 <pipewrite+0x110>
    }
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8020a422:	fc843783          	ld	a5,-56(s0)
    8020a426:	2047a703          	lw	a4,516(a5)
    8020a42a:	fc843783          	ld	a5,-56(s0)
    8020a42e:	2007a783          	lw	a5,512(a5)
    8020a432:	2007879b          	addiw	a5,a5,512
    8020a436:	2781                	sext.w	a5,a5
    8020a438:	02f71663          	bne	a4,a5,8020a464 <pipewrite+0x82>
      wakeup(&pi->nread);
    8020a43c:	fc843783          	ld	a5,-56(s0)
    8020a440:	20078793          	addi	a5,a5,512
    8020a444:	853e                	mv	a0,a5
    8020a446:	ffffc097          	auipc	ra,0xffffc
    8020a44a:	9f4080e7          	jalr	-1548(ra) # 80205e3a <wakeup>
      sleep(&pi->nwrite,NULL);
    8020a44e:	fc843783          	ld	a5,-56(s0)
    8020a452:	20478793          	addi	a5,a5,516
    8020a456:	4581                	li	a1,0
    8020a458:	853e                	mv	a0,a5
    8020a45a:	ffffc097          	auipc	ra,0xffffc
    8020a45e:	928080e7          	jalr	-1752(ra) # 80205d82 <sleep>
    8020a462:	a095                	j	8020a4c6 <pipewrite+0xe4>
    } else {
      char ch;
      if(copyin(&ch, addr + i, 1) == -1)
    8020a464:	fec42703          	lw	a4,-20(s0)
    8020a468:	fc043783          	ld	a5,-64(s0)
    8020a46c:	973e                	add	a4,a4,a5
    8020a46e:	fdf40793          	addi	a5,s0,-33
    8020a472:	4605                	li	a2,1
    8020a474:	85ba                	mv	a1,a4
    8020a476:	853e                	mv	a0,a5
    8020a478:	ffffa097          	auipc	ra,0xffffa
    8020a47c:	c06080e7          	jalr	-1018(ra) # 8020407e <copyin>
    8020a480:	87aa                	mv	a5,a0
    8020a482:	873e                	mv	a4,a5
    8020a484:	57fd                	li	a5,-1
    8020a486:	04f70a63          	beq	a4,a5,8020a4da <pipewrite+0xf8>
        break;
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8020a48a:	fc843783          	ld	a5,-56(s0)
    8020a48e:	2047a783          	lw	a5,516(a5)
    8020a492:	2781                	sext.w	a5,a5
    8020a494:	0017871b          	addiw	a4,a5,1
    8020a498:	0007069b          	sext.w	a3,a4
    8020a49c:	fc843703          	ld	a4,-56(s0)
    8020a4a0:	20d72223          	sw	a3,516(a4)
    8020a4a4:	1ff7f793          	andi	a5,a5,511
    8020a4a8:	2781                	sext.w	a5,a5
    8020a4aa:	fdf44703          	lbu	a4,-33(s0)
    8020a4ae:	fc843683          	ld	a3,-56(s0)
    8020a4b2:	1782                	slli	a5,a5,0x20
    8020a4b4:	9381                	srli	a5,a5,0x20
    8020a4b6:	97b6                	add	a5,a5,a3
    8020a4b8:	00e78023          	sb	a4,0(a5)
      i++;
    8020a4bc:	fec42783          	lw	a5,-20(s0)
    8020a4c0:	2785                	addiw	a5,a5,1
    8020a4c2:	fef42623          	sw	a5,-20(s0)
  while(i < n){
    8020a4c6:	fec42783          	lw	a5,-20(s0)
    8020a4ca:	873e                	mv	a4,a5
    8020a4cc:	fbc42783          	lw	a5,-68(s0)
    8020a4d0:	2701                	sext.w	a4,a4
    8020a4d2:	2781                	sext.w	a5,a5
    8020a4d4:	f2f74be3          	blt	a4,a5,8020a40a <pipewrite+0x28>
    8020a4d8:	a011                	j	8020a4dc <pipewrite+0xfa>
        break;
    8020a4da:	0001                	nop
    }
  }
  wakeup(&pi->nread);
    8020a4dc:	fc843783          	ld	a5,-56(s0)
    8020a4e0:	20078793          	addi	a5,a5,512
    8020a4e4:	853e                	mv	a0,a5
    8020a4e6:	ffffc097          	auipc	ra,0xffffc
    8020a4ea:	954080e7          	jalr	-1708(ra) # 80205e3a <wakeup>
  return i;
    8020a4ee:	fec42783          	lw	a5,-20(s0)
}
    8020a4f2:	853e                	mv	a0,a5
    8020a4f4:	60a6                	ld	ra,72(sp)
    8020a4f6:	6406                	ld	s0,64(sp)
    8020a4f8:	6161                	addi	sp,sp,80
    8020a4fa:	8082                	ret

000000008020a4fc <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8020a4fc:	715d                	addi	sp,sp,-80
    8020a4fe:	e486                	sd	ra,72(sp)
    8020a500:	e0a2                	sd	s0,64(sp)
    8020a502:	0880                	addi	s0,sp,80
    8020a504:	fca43423          	sd	a0,-56(s0)
    8020a508:	fcb43023          	sd	a1,-64(s0)
    8020a50c:	87b2                	mv	a5,a2
    8020a50e:	faf42e23          	sw	a5,-68(s0)
  int i;
  struct proc *pr = myproc();
    8020a512:	ffffb097          	auipc	ra,0xffffb
    8020a516:	b4e080e7          	jalr	-1202(ra) # 80205060 <myproc>
    8020a51a:	fea43023          	sd	a0,-32(s0)
  char ch;
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8020a51e:	a015                	j	8020a542 <piperead+0x46>
    if(pr->killed){
    8020a520:	fe043783          	ld	a5,-32(s0)
    8020a524:	0807a783          	lw	a5,128(a5)
    8020a528:	c399                	beqz	a5,8020a52e <piperead+0x32>
      return -1;
    8020a52a:	57fd                	li	a5,-1
    8020a52c:	a0dd                	j	8020a612 <piperead+0x116>
    }
    sleep(&pi->nread,NULL); //DOC: piperead-sleep
    8020a52e:	fc843783          	ld	a5,-56(s0)
    8020a532:	20078793          	addi	a5,a5,512
    8020a536:	4581                	li	a1,0
    8020a538:	853e                	mv	a0,a5
    8020a53a:	ffffc097          	auipc	ra,0xffffc
    8020a53e:	848080e7          	jalr	-1976(ra) # 80205d82 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8020a542:	fc843783          	ld	a5,-56(s0)
    8020a546:	2007a703          	lw	a4,512(a5)
    8020a54a:	fc843783          	ld	a5,-56(s0)
    8020a54e:	2047a783          	lw	a5,516(a5)
    8020a552:	00f71763          	bne	a4,a5,8020a560 <piperead+0x64>
    8020a556:	fc843783          	ld	a5,-56(s0)
    8020a55a:	20c7a783          	lw	a5,524(a5)
    8020a55e:	f3e9                	bnez	a5,8020a520 <piperead+0x24>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8020a560:	fe042623          	sw	zero,-20(s0)
    8020a564:	a8bd                	j	8020a5e2 <piperead+0xe6>
    if(pi->nread == pi->nwrite)
    8020a566:	fc843783          	ld	a5,-56(s0)
    8020a56a:	2007a703          	lw	a4,512(a5)
    8020a56e:	fc843783          	ld	a5,-56(s0)
    8020a572:	2047a783          	lw	a5,516(a5)
    8020a576:	08f70063          	beq	a4,a5,8020a5f6 <piperead+0xfa>
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    8020a57a:	fc843783          	ld	a5,-56(s0)
    8020a57e:	2007a783          	lw	a5,512(a5)
    8020a582:	2781                	sext.w	a5,a5
    8020a584:	0017871b          	addiw	a4,a5,1
    8020a588:	0007069b          	sext.w	a3,a4
    8020a58c:	fc843703          	ld	a4,-56(s0)
    8020a590:	20d72023          	sw	a3,512(a4)
    8020a594:	1ff7f793          	andi	a5,a5,511
    8020a598:	2781                	sext.w	a5,a5
    8020a59a:	fc843703          	ld	a4,-56(s0)
    8020a59e:	1782                	slli	a5,a5,0x20
    8020a5a0:	9381                	srli	a5,a5,0x20
    8020a5a2:	97ba                	add	a5,a5,a4
    8020a5a4:	0007c783          	lbu	a5,0(a5)
    8020a5a8:	fcf40fa3          	sb	a5,-33(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8020a5ac:	fe043783          	ld	a5,-32(s0)
    8020a5b0:	7fc8                	ld	a0,184(a5)
    8020a5b2:	fec42703          	lw	a4,-20(s0)
    8020a5b6:	fc043783          	ld	a5,-64(s0)
    8020a5ba:	97ba                	add	a5,a5,a4
    8020a5bc:	fdf40713          	addi	a4,s0,-33
    8020a5c0:	4685                	li	a3,1
    8020a5c2:	863a                	mv	a2,a4
    8020a5c4:	85be                	mv	a1,a5
    8020a5c6:	ffffa097          	auipc	ra,0xffffa
    8020a5ca:	b5c080e7          	jalr	-1188(ra) # 80204122 <copyout>
    8020a5ce:	87aa                	mv	a5,a0
    8020a5d0:	873e                	mv	a4,a5
    8020a5d2:	57fd                	li	a5,-1
    8020a5d4:	02f70363          	beq	a4,a5,8020a5fa <piperead+0xfe>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8020a5d8:	fec42783          	lw	a5,-20(s0)
    8020a5dc:	2785                	addiw	a5,a5,1
    8020a5de:	fef42623          	sw	a5,-20(s0)
    8020a5e2:	fec42783          	lw	a5,-20(s0)
    8020a5e6:	873e                	mv	a4,a5
    8020a5e8:	fbc42783          	lw	a5,-68(s0)
    8020a5ec:	2701                	sext.w	a4,a4
    8020a5ee:	2781                	sext.w	a5,a5
    8020a5f0:	f6f74be3          	blt	a4,a5,8020a566 <piperead+0x6a>
    8020a5f4:	a021                	j	8020a5fc <piperead+0x100>
      break;
    8020a5f6:	0001                	nop
    8020a5f8:	a011                	j	8020a5fc <piperead+0x100>
      break;
    8020a5fa:	0001                	nop
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8020a5fc:	fc843783          	ld	a5,-56(s0)
    8020a600:	20478793          	addi	a5,a5,516
    8020a604:	853e                	mv	a0,a5
    8020a606:	ffffc097          	auipc	ra,0xffffc
    8020a60a:	834080e7          	jalr	-1996(ra) # 80205e3a <wakeup>
  return i;
    8020a60e:	fec42783          	lw	a5,-20(s0)
}
    8020a612:	853e                	mv	a0,a5
    8020a614:	60a6                	ld	ra,72(sp)
    8020a616:	6406                	ld	s0,64(sp)
    8020a618:	6161                	addi	sp,sp,80
    8020a61a:	8082                	ret

000000008020a61c <readsb>:

struct superblock sb;
// Read the super block.
static void
readsb(int dev, struct superblock *sb)
{
    8020a61c:	7179                	addi	sp,sp,-48
    8020a61e:	f406                	sd	ra,40(sp)
    8020a620:	f022                	sd	s0,32(sp)
    8020a622:	1800                	addi	s0,sp,48
    8020a624:	87aa                	mv	a5,a0
    8020a626:	fcb43823          	sd	a1,-48(s0)
    8020a62a:	fcf42e23          	sw	a5,-36(s0)
	struct buf *bp;

	bp = bread(dev, 1);
    8020a62e:	fdc42783          	lw	a5,-36(s0)
    8020a632:	4585                	li	a1,1
    8020a634:	853e                	mv	a0,a5
    8020a636:	fffff097          	auipc	ra,0xfffff
    8020a63a:	990080e7          	jalr	-1648(ra) # 80208fc6 <bread>
    8020a63e:	fea43423          	sd	a0,-24(s0)
	memmove(sb, bp->data, sizeof(*sb));
    8020a642:	fe843783          	ld	a5,-24(s0)
    8020a646:	05078793          	addi	a5,a5,80
    8020a64a:	02000613          	li	a2,32
    8020a64e:	85be                	mv	a1,a5
    8020a650:	fd043503          	ld	a0,-48(s0)
    8020a654:	ffff8097          	auipc	ra,0xffff8
    8020a658:	940080e7          	jalr	-1728(ra) # 80201f94 <memmove>
	brelse(bp);
    8020a65c:	fe843503          	ld	a0,-24(s0)
    8020a660:	fffff097          	auipc	ra,0xfffff
    8020a664:	a08080e7          	jalr	-1528(ra) # 80209068 <brelse>
}
    8020a668:	0001                	nop
    8020a66a:	70a2                	ld	ra,40(sp)
    8020a66c:	7402                	ld	s0,32(sp)
    8020a66e:	6145                	addi	sp,sp,48
    8020a670:	8082                	ret

000000008020a672 <fsinit>:

// Init fs
void fsinit(int dev)
{
    8020a672:	1101                	addi	sp,sp,-32
    8020a674:	ec06                	sd	ra,24(sp)
    8020a676:	e822                	sd	s0,16(sp)
    8020a678:	1000                	addi	s0,sp,32
    8020a67a:	87aa                	mv	a5,a0
    8020a67c:	fef42623          	sw	a5,-20(s0)
	readsb(dev, &sb);
    8020a680:	fec42783          	lw	a5,-20(s0)
    8020a684:	0003d597          	auipc	a1,0x3d
    8020a688:	97c58593          	addi	a1,a1,-1668 # 80247000 <sb>
    8020a68c:	853e                	mv	a0,a5
    8020a68e:	00000097          	auipc	ra,0x0
    8020a692:	f8e080e7          	jalr	-114(ra) # 8020a61c <readsb>
	if (sb.magic != FSMAGIC)
    8020a696:	0003d797          	auipc	a5,0x3d
    8020a69a:	96a78793          	addi	a5,a5,-1686 # 80247000 <sb>
    8020a69e:	439c                	lw	a5,0(a5)
    8020a6a0:	873e                	mv	a4,a5
    8020a6a2:	102037b7          	lui	a5,0x10203
    8020a6a6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fffcfc0>
    8020a6aa:	00f70a63          	beq	a4,a5,8020a6be <fsinit+0x4c>
		panic("invalid file system");
    8020a6ae:	0002d517          	auipc	a0,0x2d
    8020a6b2:	0fa50513          	addi	a0,a0,250 # 802377a8 <user_test_table+0x78>
    8020a6b6:	ffff7097          	auipc	ra,0xffff7
    8020a6ba:	150080e7          	jalr	336(ra) # 80201806 <panic>
	initlog(dev, &sb);
    8020a6be:	fec42783          	lw	a5,-20(s0)
    8020a6c2:	0003d597          	auipc	a1,0x3d
    8020a6c6:	93e58593          	addi	a1,a1,-1730 # 80247000 <sb>
    8020a6ca:	853e                	mv	a0,a5
    8020a6cc:	fffff097          	auipc	ra,0xfffff
    8020a6d0:	c18080e7          	jalr	-1000(ra) # 802092e4 <initlog>
	ireclaim(dev);
    8020a6d4:	fec42783          	lw	a5,-20(s0)
    8020a6d8:	853e                	mv	a0,a5
    8020a6da:	00001097          	auipc	ra,0x1
    8020a6de:	9b2080e7          	jalr	-1614(ra) # 8020b08c <ireclaim>
	printf("fs init done\n");
    8020a6e2:	0002d517          	auipc	a0,0x2d
    8020a6e6:	0de50513          	addi	a0,a0,222 # 802377c0 <user_test_table+0x90>
    8020a6ea:	ffff7097          	auipc	ra,0xffff7
    8020a6ee:	b9a080e7          	jalr	-1126(ra) # 80201284 <printf>
}
    8020a6f2:	0001                	nop
    8020a6f4:	60e2                	ld	ra,24(sp)
    8020a6f6:	6442                	ld	s0,16(sp)
    8020a6f8:	6105                	addi	sp,sp,32
    8020a6fa:	8082                	ret

000000008020a6fc <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
    8020a6fc:	7179                	addi	sp,sp,-48
    8020a6fe:	f406                	sd	ra,40(sp)
    8020a700:	f022                	sd	s0,32(sp)
    8020a702:	1800                	addi	s0,sp,48
    8020a704:	87aa                	mv	a5,a0
    8020a706:	872e                	mv	a4,a1
    8020a708:	fcf42e23          	sw	a5,-36(s0)
    8020a70c:	87ba                	mv	a5,a4
    8020a70e:	fcf42c23          	sw	a5,-40(s0)
	struct buf *bp;

	bp = bread(dev, bno);
    8020a712:	fdc42783          	lw	a5,-36(s0)
    8020a716:	fd842703          	lw	a4,-40(s0)
    8020a71a:	85ba                	mv	a1,a4
    8020a71c:	853e                	mv	a0,a5
    8020a71e:	fffff097          	auipc	ra,0xfffff
    8020a722:	8a8080e7          	jalr	-1880(ra) # 80208fc6 <bread>
    8020a726:	fea43423          	sd	a0,-24(s0)
	memset(bp->data, 0, BSIZE);
    8020a72a:	fe843783          	ld	a5,-24(s0)
    8020a72e:	05078793          	addi	a5,a5,80
    8020a732:	40000613          	li	a2,1024
    8020a736:	4581                	li	a1,0
    8020a738:	853e                	mv	a0,a5
    8020a73a:	ffff8097          	auipc	ra,0xffff8
    8020a73e:	80a080e7          	jalr	-2038(ra) # 80201f44 <memset>
	log_write(bp);
    8020a742:	fe843503          	ld	a0,-24(s0)
    8020a746:	fffff097          	auipc	ra,0xfffff
    8020a74a:	1b6080e7          	jalr	438(ra) # 802098fc <log_write>
	brelse(bp);
    8020a74e:	fe843503          	ld	a0,-24(s0)
    8020a752:	fffff097          	auipc	ra,0xfffff
    8020a756:	916080e7          	jalr	-1770(ra) # 80209068 <brelse>
}
    8020a75a:	0001                	nop
    8020a75c:	70a2                	ld	ra,40(sp)
    8020a75e:	7402                	ld	s0,32(sp)
    8020a760:	6145                	addi	sp,sp,48
    8020a762:	8082                	ret

000000008020a764 <balloc>:

static uint
balloc(uint dev)
{
    8020a764:	7139                	addi	sp,sp,-64
    8020a766:	fc06                	sd	ra,56(sp)
    8020a768:	f822                	sd	s0,48(sp)
    8020a76a:	0080                	addi	s0,sp,64
    8020a76c:	87aa                	mv	a5,a0
    8020a76e:	fcf42623          	sw	a5,-52(s0)
	int b, bi, m;
	struct buf *bp;

	bp = 0;
    8020a772:	fe043023          	sd	zero,-32(s0)
	for (b = 0; b < sb.size; b += BPB)
    8020a776:	fe042623          	sw	zero,-20(s0)
    8020a77a:	a295                	j	8020a8de <balloc+0x17a>
	{
		bp = bread(dev, BBLOCK(b, sb));
    8020a77c:	fec42783          	lw	a5,-20(s0)
    8020a780:	41f7d71b          	sraiw	a4,a5,0x1f
    8020a784:	0137571b          	srliw	a4,a4,0x13
    8020a788:	9fb9                	addw	a5,a5,a4
    8020a78a:	40d7d79b          	sraiw	a5,a5,0xd
    8020a78e:	2781                	sext.w	a5,a5
    8020a790:	0007871b          	sext.w	a4,a5
    8020a794:	0003d797          	auipc	a5,0x3d
    8020a798:	86c78793          	addi	a5,a5,-1940 # 80247000 <sb>
    8020a79c:	4fdc                	lw	a5,28(a5)
    8020a79e:	9fb9                	addw	a5,a5,a4
    8020a7a0:	0007871b          	sext.w	a4,a5
    8020a7a4:	fcc42783          	lw	a5,-52(s0)
    8020a7a8:	85ba                	mv	a1,a4
    8020a7aa:	853e                	mv	a0,a5
    8020a7ac:	fffff097          	auipc	ra,0xfffff
    8020a7b0:	81a080e7          	jalr	-2022(ra) # 80208fc6 <bread>
    8020a7b4:	fea43023          	sd	a0,-32(s0)
		for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    8020a7b8:	fe042423          	sw	zero,-24(s0)
    8020a7bc:	a8e9                	j	8020a896 <balloc+0x132>
		{
			m = 1 << (bi % 8);
    8020a7be:	fe842783          	lw	a5,-24(s0)
    8020a7c2:	8b9d                	andi	a5,a5,7
    8020a7c4:	2781                	sext.w	a5,a5
    8020a7c6:	4705                	li	a4,1
    8020a7c8:	00f717bb          	sllw	a5,a4,a5
    8020a7cc:	fcf42e23          	sw	a5,-36(s0)
			if ((bp->data[bi / 8] & m) == 0)
    8020a7d0:	fe842783          	lw	a5,-24(s0)
    8020a7d4:	41f7d71b          	sraiw	a4,a5,0x1f
    8020a7d8:	01d7571b          	srliw	a4,a4,0x1d
    8020a7dc:	9fb9                	addw	a5,a5,a4
    8020a7de:	4037d79b          	sraiw	a5,a5,0x3
    8020a7e2:	2781                	sext.w	a5,a5
    8020a7e4:	fe043703          	ld	a4,-32(s0)
    8020a7e8:	97ba                	add	a5,a5,a4
    8020a7ea:	0507c783          	lbu	a5,80(a5)
    8020a7ee:	2781                	sext.w	a5,a5
    8020a7f0:	fdc42703          	lw	a4,-36(s0)
    8020a7f4:	8ff9                	and	a5,a5,a4
    8020a7f6:	2781                	sext.w	a5,a5
    8020a7f8:	ebd1                	bnez	a5,8020a88c <balloc+0x128>
			{						   // Is block free?
				bp->data[bi / 8] |= m; // Mark block in use.
    8020a7fa:	fe842783          	lw	a5,-24(s0)
    8020a7fe:	41f7d71b          	sraiw	a4,a5,0x1f
    8020a802:	01d7571b          	srliw	a4,a4,0x1d
    8020a806:	9fb9                	addw	a5,a5,a4
    8020a808:	4037d79b          	sraiw	a5,a5,0x3
    8020a80c:	2781                	sext.w	a5,a5
    8020a80e:	fe043703          	ld	a4,-32(s0)
    8020a812:	973e                	add	a4,a4,a5
    8020a814:	05074703          	lbu	a4,80(a4)
    8020a818:	0187169b          	slliw	a3,a4,0x18
    8020a81c:	4186d69b          	sraiw	a3,a3,0x18
    8020a820:	fdc42703          	lw	a4,-36(s0)
    8020a824:	0187171b          	slliw	a4,a4,0x18
    8020a828:	4187571b          	sraiw	a4,a4,0x18
    8020a82c:	8f55                	or	a4,a4,a3
    8020a82e:	0187171b          	slliw	a4,a4,0x18
    8020a832:	4187571b          	sraiw	a4,a4,0x18
    8020a836:	0ff77713          	zext.b	a4,a4
    8020a83a:	fe043683          	ld	a3,-32(s0)
    8020a83e:	97b6                	add	a5,a5,a3
    8020a840:	04e78823          	sb	a4,80(a5)
				log_write(bp);
    8020a844:	fe043503          	ld	a0,-32(s0)
    8020a848:	fffff097          	auipc	ra,0xfffff
    8020a84c:	0b4080e7          	jalr	180(ra) # 802098fc <log_write>
				brelse(bp);
    8020a850:	fe043503          	ld	a0,-32(s0)
    8020a854:	fffff097          	auipc	ra,0xfffff
    8020a858:	814080e7          	jalr	-2028(ra) # 80209068 <brelse>
				bzero(dev, b + bi);
    8020a85c:	fcc42783          	lw	a5,-52(s0)
    8020a860:	fec42703          	lw	a4,-20(s0)
    8020a864:	86ba                	mv	a3,a4
    8020a866:	fe842703          	lw	a4,-24(s0)
    8020a86a:	9f35                	addw	a4,a4,a3
    8020a86c:	2701                	sext.w	a4,a4
    8020a86e:	85ba                	mv	a1,a4
    8020a870:	853e                	mv	a0,a5
    8020a872:	00000097          	auipc	ra,0x0
    8020a876:	e8a080e7          	jalr	-374(ra) # 8020a6fc <bzero>
				return b + bi;
    8020a87a:	fec42783          	lw	a5,-20(s0)
    8020a87e:	873e                	mv	a4,a5
    8020a880:	fe842783          	lw	a5,-24(s0)
    8020a884:	9fb9                	addw	a5,a5,a4
    8020a886:	2781                	sext.w	a5,a5
    8020a888:	2781                	sext.w	a5,a5
    8020a88a:	a8a5                	j	8020a902 <balloc+0x19e>
		for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    8020a88c:	fe842783          	lw	a5,-24(s0)
    8020a890:	2785                	addiw	a5,a5,1
    8020a892:	fef42423          	sw	a5,-24(s0)
    8020a896:	fe842783          	lw	a5,-24(s0)
    8020a89a:	0007871b          	sext.w	a4,a5
    8020a89e:	6789                	lui	a5,0x2
    8020a8a0:	02f75263          	bge	a4,a5,8020a8c4 <balloc+0x160>
    8020a8a4:	fec42783          	lw	a5,-20(s0)
    8020a8a8:	873e                	mv	a4,a5
    8020a8aa:	fe842783          	lw	a5,-24(s0)
    8020a8ae:	9fb9                	addw	a5,a5,a4
    8020a8b0:	2781                	sext.w	a5,a5
    8020a8b2:	0007871b          	sext.w	a4,a5
    8020a8b6:	0003c797          	auipc	a5,0x3c
    8020a8ba:	74a78793          	addi	a5,a5,1866 # 80247000 <sb>
    8020a8be:	43dc                	lw	a5,4(a5)
    8020a8c0:	eef76fe3          	bltu	a4,a5,8020a7be <balloc+0x5a>
			}
		}
		brelse(bp);
    8020a8c4:	fe043503          	ld	a0,-32(s0)
    8020a8c8:	ffffe097          	auipc	ra,0xffffe
    8020a8cc:	7a0080e7          	jalr	1952(ra) # 80209068 <brelse>
	for (b = 0; b < sb.size; b += BPB)
    8020a8d0:	fec42783          	lw	a5,-20(s0)
    8020a8d4:	873e                	mv	a4,a5
    8020a8d6:	6789                	lui	a5,0x2
    8020a8d8:	9fb9                	addw	a5,a5,a4
    8020a8da:	fef42623          	sw	a5,-20(s0)
    8020a8de:	0003c797          	auipc	a5,0x3c
    8020a8e2:	72278793          	addi	a5,a5,1826 # 80247000 <sb>
    8020a8e6:	43d8                	lw	a4,4(a5)
    8020a8e8:	fec42783          	lw	a5,-20(s0)
    8020a8ec:	e8e7e8e3          	bltu	a5,a4,8020a77c <balloc+0x18>
	}
	printf("balloc: out of blocks\n");
    8020a8f0:	0002d517          	auipc	a0,0x2d
    8020a8f4:	ee050513          	addi	a0,a0,-288 # 802377d0 <user_test_table+0xa0>
    8020a8f8:	ffff7097          	auipc	ra,0xffff7
    8020a8fc:	98c080e7          	jalr	-1652(ra) # 80201284 <printf>
	return 0;
    8020a900:	4781                	li	a5,0
}
    8020a902:	853e                	mv	a0,a5
    8020a904:	70e2                	ld	ra,56(sp)
    8020a906:	7442                	ld	s0,48(sp)
    8020a908:	6121                	addi	sp,sp,64
    8020a90a:	8082                	ret

000000008020a90c <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8020a90c:	7179                	addi	sp,sp,-48
    8020a90e:	f406                	sd	ra,40(sp)
    8020a910:	f022                	sd	s0,32(sp)
    8020a912:	1800                	addi	s0,sp,48
    8020a914:	87aa                	mv	a5,a0
    8020a916:	872e                	mv	a4,a1
    8020a918:	fcf42e23          	sw	a5,-36(s0)
    8020a91c:	87ba                	mv	a5,a4
    8020a91e:	fcf42c23          	sw	a5,-40(s0)
	struct buf *bp;
	int bi, m;

	bp = bread(dev, BBLOCK(b, sb));
    8020a922:	fdc42683          	lw	a3,-36(s0)
    8020a926:	fd842783          	lw	a5,-40(s0)
    8020a92a:	00d7d79b          	srliw	a5,a5,0xd
    8020a92e:	0007871b          	sext.w	a4,a5
    8020a932:	0003c797          	auipc	a5,0x3c
    8020a936:	6ce78793          	addi	a5,a5,1742 # 80247000 <sb>
    8020a93a:	4fdc                	lw	a5,28(a5)
    8020a93c:	9fb9                	addw	a5,a5,a4
    8020a93e:	2781                	sext.w	a5,a5
    8020a940:	85be                	mv	a1,a5
    8020a942:	8536                	mv	a0,a3
    8020a944:	ffffe097          	auipc	ra,0xffffe
    8020a948:	682080e7          	jalr	1666(ra) # 80208fc6 <bread>
    8020a94c:	fea43423          	sd	a0,-24(s0)
	bi = b % BPB;
    8020a950:	fd842703          	lw	a4,-40(s0)
    8020a954:	6789                	lui	a5,0x2
    8020a956:	17fd                	addi	a5,a5,-1 # 1fff <_entry-0x801fe001>
    8020a958:	8ff9                	and	a5,a5,a4
    8020a95a:	fef42223          	sw	a5,-28(s0)
	m = 1 << (bi % 8);
    8020a95e:	fe442783          	lw	a5,-28(s0)
    8020a962:	8b9d                	andi	a5,a5,7
    8020a964:	2781                	sext.w	a5,a5
    8020a966:	4705                	li	a4,1
    8020a968:	00f717bb          	sllw	a5,a4,a5
    8020a96c:	fef42023          	sw	a5,-32(s0)
	if ((bp->data[bi / 8] & m) == 0)
    8020a970:	fe442783          	lw	a5,-28(s0)
    8020a974:	41f7d71b          	sraiw	a4,a5,0x1f
    8020a978:	01d7571b          	srliw	a4,a4,0x1d
    8020a97c:	9fb9                	addw	a5,a5,a4
    8020a97e:	4037d79b          	sraiw	a5,a5,0x3
    8020a982:	2781                	sext.w	a5,a5
    8020a984:	fe843703          	ld	a4,-24(s0)
    8020a988:	97ba                	add	a5,a5,a4
    8020a98a:	0507c783          	lbu	a5,80(a5)
    8020a98e:	2781                	sext.w	a5,a5
    8020a990:	fe042703          	lw	a4,-32(s0)
    8020a994:	8ff9                	and	a5,a5,a4
    8020a996:	2781                	sext.w	a5,a5
    8020a998:	eb89                	bnez	a5,8020a9aa <bfree+0x9e>
		panic("freeing free block");
    8020a99a:	0002d517          	auipc	a0,0x2d
    8020a99e:	e4e50513          	addi	a0,a0,-434 # 802377e8 <user_test_table+0xb8>
    8020a9a2:	ffff7097          	auipc	ra,0xffff7
    8020a9a6:	e64080e7          	jalr	-412(ra) # 80201806 <panic>
	bp->data[bi / 8] &= ~m;
    8020a9aa:	fe442783          	lw	a5,-28(s0)
    8020a9ae:	41f7d71b          	sraiw	a4,a5,0x1f
    8020a9b2:	01d7571b          	srliw	a4,a4,0x1d
    8020a9b6:	9fb9                	addw	a5,a5,a4
    8020a9b8:	4037d79b          	sraiw	a5,a5,0x3
    8020a9bc:	2781                	sext.w	a5,a5
    8020a9be:	fe843703          	ld	a4,-24(s0)
    8020a9c2:	973e                	add	a4,a4,a5
    8020a9c4:	05074703          	lbu	a4,80(a4)
    8020a9c8:	0187169b          	slliw	a3,a4,0x18
    8020a9cc:	4186d69b          	sraiw	a3,a3,0x18
    8020a9d0:	fe042703          	lw	a4,-32(s0)
    8020a9d4:	0187171b          	slliw	a4,a4,0x18
    8020a9d8:	4187571b          	sraiw	a4,a4,0x18
    8020a9dc:	fff74713          	not	a4,a4
    8020a9e0:	0187171b          	slliw	a4,a4,0x18
    8020a9e4:	4187571b          	sraiw	a4,a4,0x18
    8020a9e8:	8f75                	and	a4,a4,a3
    8020a9ea:	0187171b          	slliw	a4,a4,0x18
    8020a9ee:	4187571b          	sraiw	a4,a4,0x18
    8020a9f2:	0ff77713          	zext.b	a4,a4
    8020a9f6:	fe843683          	ld	a3,-24(s0)
    8020a9fa:	97b6                	add	a5,a5,a3
    8020a9fc:	04e78823          	sb	a4,80(a5)
	log_write(bp);
    8020aa00:	fe843503          	ld	a0,-24(s0)
    8020aa04:	fffff097          	auipc	ra,0xfffff
    8020aa08:	ef8080e7          	jalr	-264(ra) # 802098fc <log_write>
	brelse(bp);
    8020aa0c:	fe843503          	ld	a0,-24(s0)
    8020aa10:	ffffe097          	auipc	ra,0xffffe
    8020aa14:	658080e7          	jalr	1624(ra) # 80209068 <brelse>
}
    8020aa18:	0001                	nop
    8020aa1a:	70a2                	ld	ra,40(sp)
    8020aa1c:	7402                	ld	s0,32(sp)
    8020aa1e:	6145                	addi	sp,sp,48
    8020aa20:	8082                	ret

000000008020aa22 <iinit>:
	struct spinlock lock;
	struct inode inode[NINODE];
} itable;

void iinit()
{
    8020aa22:	1101                	addi	sp,sp,-32
    8020aa24:	ec06                	sd	ra,24(sp)
    8020aa26:	e822                	sd	s0,16(sp)
    8020aa28:	1000                	addi	s0,sp,32
	int i = 0;
    8020aa2a:	fe042623          	sw	zero,-20(s0)

	initlock(&itable.lock, "itable");
    8020aa2e:	0002d597          	auipc	a1,0x2d
    8020aa32:	dd258593          	addi	a1,a1,-558 # 80237800 <user_test_table+0xd0>
    8020aa36:	0003c517          	auipc	a0,0x3c
    8020aa3a:	5ea50513          	addi	a0,a0,1514 # 80247020 <itable>
    8020aa3e:	00001097          	auipc	ra,0x1
    8020aa42:	6d2080e7          	jalr	1746(ra) # 8020c110 <initlock>
	for (i = 0; i < NINODE; i++)
    8020aa46:	fe042623          	sw	zero,-20(s0)
    8020aa4a:	a815                	j	8020aa7e <iinit+0x5c>
	{
		initsleeplock(&itable.inode[i].lock, "inode");
    8020aa4c:	fec42783          	lw	a5,-20(s0)
    8020aa50:	079e                	slli	a5,a5,0x7
    8020aa52:	06078713          	addi	a4,a5,96
    8020aa56:	0003c797          	auipc	a5,0x3c
    8020aa5a:	5ca78793          	addi	a5,a5,1482 # 80247020 <itable>
    8020aa5e:	97ba                	add	a5,a5,a4
    8020aa60:	07a1                	addi	a5,a5,8
    8020aa62:	0002d597          	auipc	a1,0x2d
    8020aa66:	da658593          	addi	a1,a1,-602 # 80237808 <user_test_table+0xd8>
    8020aa6a:	853e                	mv	a0,a5
    8020aa6c:	00001097          	auipc	ra,0x1
    8020aa70:	778080e7          	jalr	1912(ra) # 8020c1e4 <initsleeplock>
	for (i = 0; i < NINODE; i++)
    8020aa74:	fec42783          	lw	a5,-20(s0)
    8020aa78:	2785                	addiw	a5,a5,1
    8020aa7a:	fef42623          	sw	a5,-20(s0)
    8020aa7e:	fec42783          	lw	a5,-20(s0)
    8020aa82:	0007871b          	sext.w	a4,a5
    8020aa86:	03100793          	li	a5,49
    8020aa8a:	fce7d1e3          	bge	a5,a4,8020aa4c <iinit+0x2a>
	}
	printf("iinit done \n");
    8020aa8e:	0002d517          	auipc	a0,0x2d
    8020aa92:	d8250513          	addi	a0,a0,-638 # 80237810 <user_test_table+0xe0>
    8020aa96:	ffff6097          	auipc	ra,0xffff6
    8020aa9a:	7ee080e7          	jalr	2030(ra) # 80201284 <printf>
}
    8020aa9e:	0001                	nop
    8020aaa0:	60e2                	ld	ra,24(sp)
    8020aaa2:	6442                	ld	s0,16(sp)
    8020aaa4:	6105                	addi	sp,sp,32
    8020aaa6:	8082                	ret

000000008020aaa8 <ialloc>:

struct inode *
ialloc(uint dev, short type)
{
    8020aaa8:	7139                	addi	sp,sp,-64
    8020aaaa:	fc06                	sd	ra,56(sp)
    8020aaac:	f822                	sd	s0,48(sp)
    8020aaae:	0080                	addi	s0,sp,64
    8020aab0:	87aa                	mv	a5,a0
    8020aab2:	872e                	mv	a4,a1
    8020aab4:	fcf42623          	sw	a5,-52(s0)
    8020aab8:	87ba                	mv	a5,a4
    8020aaba:	fcf41523          	sh	a5,-54(s0)
	int inum;
	struct buf *bp;
	struct dinode *dip;

	for (inum = 1; inum < sb.ninodes; inum++)
    8020aabe:	4785                	li	a5,1
    8020aac0:	fef42623          	sw	a5,-20(s0)
    8020aac4:	a855                	j	8020ab78 <ialloc+0xd0>
	{
		bp = bread(dev, IBLOCK(inum, sb));
    8020aac6:	fec42783          	lw	a5,-20(s0)
    8020aaca:	8391                	srli	a5,a5,0x4
    8020aacc:	0007871b          	sext.w	a4,a5
    8020aad0:	0003c797          	auipc	a5,0x3c
    8020aad4:	53078793          	addi	a5,a5,1328 # 80247000 <sb>
    8020aad8:	4f9c                	lw	a5,24(a5)
    8020aada:	9fb9                	addw	a5,a5,a4
    8020aadc:	0007871b          	sext.w	a4,a5
    8020aae0:	fcc42783          	lw	a5,-52(s0)
    8020aae4:	85ba                	mv	a1,a4
    8020aae6:	853e                	mv	a0,a5
    8020aae8:	ffffe097          	auipc	ra,0xffffe
    8020aaec:	4de080e7          	jalr	1246(ra) # 80208fc6 <bread>
    8020aaf0:	fea43023          	sd	a0,-32(s0)
		dip = (struct dinode *)bp->data + inum % IPB;
    8020aaf4:	fe043783          	ld	a5,-32(s0)
    8020aaf8:	05078713          	addi	a4,a5,80
    8020aafc:	fec42783          	lw	a5,-20(s0)
    8020ab00:	8bbd                	andi	a5,a5,15
    8020ab02:	079a                	slli	a5,a5,0x6
    8020ab04:	97ba                	add	a5,a5,a4
    8020ab06:	fcf43c23          	sd	a5,-40(s0)
		if (dip->type == 0)
    8020ab0a:	fd843783          	ld	a5,-40(s0)
    8020ab0e:	00079783          	lh	a5,0(a5)
    8020ab12:	eba1                	bnez	a5,8020ab62 <ialloc+0xba>
		{ // a free inode
			memset(dip, 0, sizeof(*dip));
    8020ab14:	04000613          	li	a2,64
    8020ab18:	4581                	li	a1,0
    8020ab1a:	fd843503          	ld	a0,-40(s0)
    8020ab1e:	ffff7097          	auipc	ra,0xffff7
    8020ab22:	426080e7          	jalr	1062(ra) # 80201f44 <memset>
			dip->type = type;
    8020ab26:	fd843783          	ld	a5,-40(s0)
    8020ab2a:	fca45703          	lhu	a4,-54(s0)
    8020ab2e:	00e79023          	sh	a4,0(a5)
			log_write(bp); // mark it allocated on the disk
    8020ab32:	fe043503          	ld	a0,-32(s0)
    8020ab36:	fffff097          	auipc	ra,0xfffff
    8020ab3a:	dc6080e7          	jalr	-570(ra) # 802098fc <log_write>
			brelse(bp);
    8020ab3e:	fe043503          	ld	a0,-32(s0)
    8020ab42:	ffffe097          	auipc	ra,0xffffe
    8020ab46:	526080e7          	jalr	1318(ra) # 80209068 <brelse>
			return iget(dev, inum);
    8020ab4a:	fec42703          	lw	a4,-20(s0)
    8020ab4e:	fcc42783          	lw	a5,-52(s0)
    8020ab52:	85ba                	mv	a1,a4
    8020ab54:	853e                	mv	a0,a5
    8020ab56:	00000097          	auipc	ra,0x0
    8020ab5a:	138080e7          	jalr	312(ra) # 8020ac8e <iget>
    8020ab5e:	87aa                	mv	a5,a0
    8020ab60:	a835                	j	8020ab9c <ialloc+0xf4>
		}
		brelse(bp);
    8020ab62:	fe043503          	ld	a0,-32(s0)
    8020ab66:	ffffe097          	auipc	ra,0xffffe
    8020ab6a:	502080e7          	jalr	1282(ra) # 80209068 <brelse>
	for (inum = 1; inum < sb.ninodes; inum++)
    8020ab6e:	fec42783          	lw	a5,-20(s0)
    8020ab72:	2785                	addiw	a5,a5,1
    8020ab74:	fef42623          	sw	a5,-20(s0)
    8020ab78:	0003c797          	auipc	a5,0x3c
    8020ab7c:	48878793          	addi	a5,a5,1160 # 80247000 <sb>
    8020ab80:	47d8                	lw	a4,12(a5)
    8020ab82:	fec42783          	lw	a5,-20(s0)
    8020ab86:	f4e7e0e3          	bltu	a5,a4,8020aac6 <ialloc+0x1e>
	}
	printf("ialloc: no inodes\n");
    8020ab8a:	0002d517          	auipc	a0,0x2d
    8020ab8e:	c9650513          	addi	a0,a0,-874 # 80237820 <user_test_table+0xf0>
    8020ab92:	ffff6097          	auipc	ra,0xffff6
    8020ab96:	6f2080e7          	jalr	1778(ra) # 80201284 <printf>
	return 0;
    8020ab9a:	4781                	li	a5,0
}
    8020ab9c:	853e                	mv	a0,a5
    8020ab9e:	70e2                	ld	ra,56(sp)
    8020aba0:	7442                	ld	s0,48(sp)
    8020aba2:	6121                	addi	sp,sp,64
    8020aba4:	8082                	ret

000000008020aba6 <iupdate>:

void iupdate(struct inode *ip)
{
    8020aba6:	7179                	addi	sp,sp,-48
    8020aba8:	f406                	sd	ra,40(sp)
    8020abaa:	f022                	sd	s0,32(sp)
    8020abac:	1800                	addi	s0,sp,48
    8020abae:	fca43c23          	sd	a0,-40(s0)
	struct buf *bp;
	struct dinode *dip;

	bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8020abb2:	fd843783          	ld	a5,-40(s0)
    8020abb6:	4394                	lw	a3,0(a5)
    8020abb8:	fd843783          	ld	a5,-40(s0)
    8020abbc:	43dc                	lw	a5,4(a5)
    8020abbe:	0047d79b          	srliw	a5,a5,0x4
    8020abc2:	0007871b          	sext.w	a4,a5
    8020abc6:	0003c797          	auipc	a5,0x3c
    8020abca:	43a78793          	addi	a5,a5,1082 # 80247000 <sb>
    8020abce:	4f9c                	lw	a5,24(a5)
    8020abd0:	9fb9                	addw	a5,a5,a4
    8020abd2:	2781                	sext.w	a5,a5
    8020abd4:	85be                	mv	a1,a5
    8020abd6:	8536                	mv	a0,a3
    8020abd8:	ffffe097          	auipc	ra,0xffffe
    8020abdc:	3ee080e7          	jalr	1006(ra) # 80208fc6 <bread>
    8020abe0:	fea43423          	sd	a0,-24(s0)
	dip = (struct dinode *)bp->data + ip->inum % IPB;
    8020abe4:	fe843783          	ld	a5,-24(s0)
    8020abe8:	05078713          	addi	a4,a5,80
    8020abec:	fd843783          	ld	a5,-40(s0)
    8020abf0:	43dc                	lw	a5,4(a5)
    8020abf2:	1782                	slli	a5,a5,0x20
    8020abf4:	9381                	srli	a5,a5,0x20
    8020abf6:	8bbd                	andi	a5,a5,15
    8020abf8:	079a                	slli	a5,a5,0x6
    8020abfa:	97ba                	add	a5,a5,a4
    8020abfc:	fef43023          	sd	a5,-32(s0)
	dip->type = ip->type;
    8020ac00:	fd843783          	ld	a5,-40(s0)
    8020ac04:	01479703          	lh	a4,20(a5)
    8020ac08:	fe043783          	ld	a5,-32(s0)
    8020ac0c:	00e79023          	sh	a4,0(a5)
	dip->major = ip->major;
    8020ac10:	fd843783          	ld	a5,-40(s0)
    8020ac14:	01679703          	lh	a4,22(a5)
    8020ac18:	fe043783          	ld	a5,-32(s0)
    8020ac1c:	00e79123          	sh	a4,2(a5)
	dip->minor = ip->minor;
    8020ac20:	fd843783          	ld	a5,-40(s0)
    8020ac24:	01879703          	lh	a4,24(a5)
    8020ac28:	fe043783          	ld	a5,-32(s0)
    8020ac2c:	00e79223          	sh	a4,4(a5)
	dip->nlink = ip->nlink;
    8020ac30:	fd843783          	ld	a5,-40(s0)
    8020ac34:	01a79703          	lh	a4,26(a5)
    8020ac38:	fe043783          	ld	a5,-32(s0)
    8020ac3c:	00e79323          	sh	a4,6(a5)
	dip->size = ip->size;
    8020ac40:	fd843783          	ld	a5,-40(s0)
    8020ac44:	4fd8                	lw	a4,28(a5)
    8020ac46:	fe043783          	ld	a5,-32(s0)
    8020ac4a:	c798                	sw	a4,8(a5)
	memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8020ac4c:	fe043783          	ld	a5,-32(s0)
    8020ac50:	00c78713          	addi	a4,a5,12
    8020ac54:	fd843783          	ld	a5,-40(s0)
    8020ac58:	02078793          	addi	a5,a5,32
    8020ac5c:	03400613          	li	a2,52
    8020ac60:	85be                	mv	a1,a5
    8020ac62:	853a                	mv	a0,a4
    8020ac64:	ffff7097          	auipc	ra,0xffff7
    8020ac68:	330080e7          	jalr	816(ra) # 80201f94 <memmove>
	log_write(bp);
    8020ac6c:	fe843503          	ld	a0,-24(s0)
    8020ac70:	fffff097          	auipc	ra,0xfffff
    8020ac74:	c8c080e7          	jalr	-884(ra) # 802098fc <log_write>
	brelse(bp);
    8020ac78:	fe843503          	ld	a0,-24(s0)
    8020ac7c:	ffffe097          	auipc	ra,0xffffe
    8020ac80:	3ec080e7          	jalr	1004(ra) # 80209068 <brelse>
}
    8020ac84:	0001                	nop
    8020ac86:	70a2                	ld	ra,40(sp)
    8020ac88:	7402                	ld	s0,32(sp)
    8020ac8a:	6145                	addi	sp,sp,48
    8020ac8c:	8082                	ret

000000008020ac8e <iget>:
struct inode *
iget(uint dev, uint inum)
{
    8020ac8e:	7179                	addi	sp,sp,-48
    8020ac90:	f406                	sd	ra,40(sp)
    8020ac92:	f022                	sd	s0,32(sp)
    8020ac94:	1800                	addi	s0,sp,48
    8020ac96:	87aa                	mv	a5,a0
    8020ac98:	872e                	mv	a4,a1
    8020ac9a:	fcf42e23          	sw	a5,-36(s0)
    8020ac9e:	87ba                	mv	a5,a4
    8020aca0:	fcf42c23          	sw	a5,-40(s0)
	struct inode *ip, *empty;
	acquire(&itable.lock);
    8020aca4:	0003c517          	auipc	a0,0x3c
    8020aca8:	37c50513          	addi	a0,a0,892 # 80247020 <itable>
    8020acac:	00001097          	auipc	ra,0x1
    8020acb0:	48c080e7          	jalr	1164(ra) # 8020c138 <acquire>
	// Is the inode already in the table?
	empty = 0;
    8020acb4:	fe043023          	sd	zero,-32(s0)
	for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++)
    8020acb8:	0003c797          	auipc	a5,0x3c
    8020acbc:	37878793          	addi	a5,a5,888 # 80247030 <itable+0x10>
    8020acc0:	fef43423          	sd	a5,-24(s0)
    8020acc4:	a89d                	j	8020ad3a <iget+0xac>
	{
		if (ip->ref > 0 && ip->dev == dev && ip->inum == inum)
    8020acc6:	fe843783          	ld	a5,-24(s0)
    8020acca:	479c                	lw	a5,8(a5)
    8020accc:	04f05663          	blez	a5,8020ad18 <iget+0x8a>
    8020acd0:	fe843783          	ld	a5,-24(s0)
    8020acd4:	4398                	lw	a4,0(a5)
    8020acd6:	fdc42783          	lw	a5,-36(s0)
    8020acda:	2781                	sext.w	a5,a5
    8020acdc:	02e79e63          	bne	a5,a4,8020ad18 <iget+0x8a>
    8020ace0:	fe843783          	ld	a5,-24(s0)
    8020ace4:	43d8                	lw	a4,4(a5)
    8020ace6:	fd842783          	lw	a5,-40(s0)
    8020acea:	2781                	sext.w	a5,a5
    8020acec:	02e79663          	bne	a5,a4,8020ad18 <iget+0x8a>
		{
			ip->ref++;
    8020acf0:	fe843783          	ld	a5,-24(s0)
    8020acf4:	479c                	lw	a5,8(a5)
    8020acf6:	2785                	addiw	a5,a5,1
    8020acf8:	0007871b          	sext.w	a4,a5
    8020acfc:	fe843783          	ld	a5,-24(s0)
    8020ad00:	c798                	sw	a4,8(a5)
			release(&itable.lock);
    8020ad02:	0003c517          	auipc	a0,0x3c
    8020ad06:	31e50513          	addi	a0,a0,798 # 80247020 <itable>
    8020ad0a:	00001097          	auipc	ra,0x1
    8020ad0e:	47a080e7          	jalr	1146(ra) # 8020c184 <release>
			return ip;
    8020ad12:	fe843783          	ld	a5,-24(s0)
    8020ad16:	a069                	j	8020ada0 <iget+0x112>
		}
		if (empty == 0 && ip->ref == 0) // Remember empty slot.
    8020ad18:	fe043783          	ld	a5,-32(s0)
    8020ad1c:	eb89                	bnez	a5,8020ad2e <iget+0xa0>
    8020ad1e:	fe843783          	ld	a5,-24(s0)
    8020ad22:	479c                	lw	a5,8(a5)
    8020ad24:	e789                	bnez	a5,8020ad2e <iget+0xa0>
			empty = ip;
    8020ad26:	fe843783          	ld	a5,-24(s0)
    8020ad2a:	fef43023          	sd	a5,-32(s0)
	for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++)
    8020ad2e:	fe843783          	ld	a5,-24(s0)
    8020ad32:	08078793          	addi	a5,a5,128
    8020ad36:	fef43423          	sd	a5,-24(s0)
    8020ad3a:	fe843703          	ld	a4,-24(s0)
    8020ad3e:	0003e797          	auipc	a5,0x3e
    8020ad42:	bf278793          	addi	a5,a5,-1038 # 80248930 <_bss_end>
    8020ad46:	f8f760e3          	bltu	a4,a5,8020acc6 <iget+0x38>
	}

	// Recycle an inode entry.
	if (empty == 0)
    8020ad4a:	fe043783          	ld	a5,-32(s0)
    8020ad4e:	eb89                	bnez	a5,8020ad60 <iget+0xd2>
		panic("iget: no inodes");
    8020ad50:	0002d517          	auipc	a0,0x2d
    8020ad54:	ae850513          	addi	a0,a0,-1304 # 80237838 <user_test_table+0x108>
    8020ad58:	ffff7097          	auipc	ra,0xffff7
    8020ad5c:	aae080e7          	jalr	-1362(ra) # 80201806 <panic>

	ip = empty;
    8020ad60:	fe043783          	ld	a5,-32(s0)
    8020ad64:	fef43423          	sd	a5,-24(s0)
	ip->dev = dev;
    8020ad68:	fe843783          	ld	a5,-24(s0)
    8020ad6c:	fdc42703          	lw	a4,-36(s0)
    8020ad70:	c398                	sw	a4,0(a5)
	ip->inum = inum;
    8020ad72:	fe843783          	ld	a5,-24(s0)
    8020ad76:	fd842703          	lw	a4,-40(s0)
    8020ad7a:	c3d8                	sw	a4,4(a5)
	ip->ref = 1;
    8020ad7c:	fe843783          	ld	a5,-24(s0)
    8020ad80:	4705                	li	a4,1
    8020ad82:	c798                	sw	a4,8(a5)
	ip->valid = 0;
    8020ad84:	fe843783          	ld	a5,-24(s0)
    8020ad88:	0007a623          	sw	zero,12(a5)
	release(&itable.lock);
    8020ad8c:	0003c517          	auipc	a0,0x3c
    8020ad90:	29450513          	addi	a0,a0,660 # 80247020 <itable>
    8020ad94:	00001097          	auipc	ra,0x1
    8020ad98:	3f0080e7          	jalr	1008(ra) # 8020c184 <release>
	return ip;
    8020ad9c:	fe843783          	ld	a5,-24(s0)
}
    8020ada0:	853e                	mv	a0,a5
    8020ada2:	70a2                	ld	ra,40(sp)
    8020ada4:	7402                	ld	s0,32(sp)
    8020ada6:	6145                	addi	sp,sp,48
    8020ada8:	8082                	ret

000000008020adaa <idup>:

struct inode *
idup(struct inode *ip)
{
    8020adaa:	1101                	addi	sp,sp,-32
    8020adac:	ec06                	sd	ra,24(sp)
    8020adae:	e822                	sd	s0,16(sp)
    8020adb0:	1000                	addi	s0,sp,32
    8020adb2:	fea43423          	sd	a0,-24(s0)
	acquire(&itable.lock);
    8020adb6:	0003c517          	auipc	a0,0x3c
    8020adba:	26a50513          	addi	a0,a0,618 # 80247020 <itable>
    8020adbe:	00001097          	auipc	ra,0x1
    8020adc2:	37a080e7          	jalr	890(ra) # 8020c138 <acquire>
	ip->ref++;
    8020adc6:	fe843783          	ld	a5,-24(s0)
    8020adca:	479c                	lw	a5,8(a5)
    8020adcc:	2785                	addiw	a5,a5,1
    8020adce:	0007871b          	sext.w	a4,a5
    8020add2:	fe843783          	ld	a5,-24(s0)
    8020add6:	c798                	sw	a4,8(a5)
	release(&itable.lock);
    8020add8:	0003c517          	auipc	a0,0x3c
    8020addc:	24850513          	addi	a0,a0,584 # 80247020 <itable>
    8020ade0:	00001097          	auipc	ra,0x1
    8020ade4:	3a4080e7          	jalr	932(ra) # 8020c184 <release>
	return ip;
    8020ade8:	fe843783          	ld	a5,-24(s0)
}
    8020adec:	853e                	mv	a0,a5
    8020adee:	60e2                	ld	ra,24(sp)
    8020adf0:	6442                	ld	s0,16(sp)
    8020adf2:	6105                	addi	sp,sp,32
    8020adf4:	8082                	ret

000000008020adf6 <ilock>:

void ilock(struct inode *ip)
{
    8020adf6:	7179                	addi	sp,sp,-48
    8020adf8:	f406                	sd	ra,40(sp)
    8020adfa:	f022                	sd	s0,32(sp)
    8020adfc:	1800                	addi	s0,sp,48
    8020adfe:	fca43c23          	sd	a0,-40(s0)
	struct buf *bp;
	struct dinode *dip;

	if (ip == 0 || ip->ref < 1)
    8020ae02:	fd843783          	ld	a5,-40(s0)
    8020ae06:	c791                	beqz	a5,8020ae12 <ilock+0x1c>
    8020ae08:	fd843783          	ld	a5,-40(s0)
    8020ae0c:	479c                	lw	a5,8(a5)
    8020ae0e:	00f04a63          	bgtz	a5,8020ae22 <ilock+0x2c>
		panic("ilock");
    8020ae12:	0002d517          	auipc	a0,0x2d
    8020ae16:	a3650513          	addi	a0,a0,-1482 # 80237848 <user_test_table+0x118>
    8020ae1a:	ffff7097          	auipc	ra,0xffff7
    8020ae1e:	9ec080e7          	jalr	-1556(ra) # 80201806 <panic>
	acquiresleep(&ip->lock);
    8020ae22:	fd843783          	ld	a5,-40(s0)
    8020ae26:	05878793          	addi	a5,a5,88
    8020ae2a:	853e                	mv	a0,a5
    8020ae2c:	00001097          	auipc	ra,0x1
    8020ae30:	404080e7          	jalr	1028(ra) # 8020c230 <acquiresleep>
	if (ip->valid == 0)
    8020ae34:	fd843783          	ld	a5,-40(s0)
    8020ae38:	47dc                	lw	a5,12(a5)
    8020ae3a:	e7e5                	bnez	a5,8020af22 <ilock+0x12c>
	{
		bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8020ae3c:	fd843783          	ld	a5,-40(s0)
    8020ae40:	4394                	lw	a3,0(a5)
    8020ae42:	fd843783          	ld	a5,-40(s0)
    8020ae46:	43dc                	lw	a5,4(a5)
    8020ae48:	0047d79b          	srliw	a5,a5,0x4
    8020ae4c:	0007871b          	sext.w	a4,a5
    8020ae50:	0003c797          	auipc	a5,0x3c
    8020ae54:	1b078793          	addi	a5,a5,432 # 80247000 <sb>
    8020ae58:	4f9c                	lw	a5,24(a5)
    8020ae5a:	9fb9                	addw	a5,a5,a4
    8020ae5c:	2781                	sext.w	a5,a5
    8020ae5e:	85be                	mv	a1,a5
    8020ae60:	8536                	mv	a0,a3
    8020ae62:	ffffe097          	auipc	ra,0xffffe
    8020ae66:	164080e7          	jalr	356(ra) # 80208fc6 <bread>
    8020ae6a:	fea43423          	sd	a0,-24(s0)
		dip = (struct dinode *)bp->data + ip->inum % IPB;
    8020ae6e:	fe843783          	ld	a5,-24(s0)
    8020ae72:	05078713          	addi	a4,a5,80
    8020ae76:	fd843783          	ld	a5,-40(s0)
    8020ae7a:	43dc                	lw	a5,4(a5)
    8020ae7c:	1782                	slli	a5,a5,0x20
    8020ae7e:	9381                	srli	a5,a5,0x20
    8020ae80:	8bbd                	andi	a5,a5,15
    8020ae82:	079a                	slli	a5,a5,0x6
    8020ae84:	97ba                	add	a5,a5,a4
    8020ae86:	fef43023          	sd	a5,-32(s0)
		ip->type = dip->type;
    8020ae8a:	fe043783          	ld	a5,-32(s0)
    8020ae8e:	00079703          	lh	a4,0(a5)
    8020ae92:	fd843783          	ld	a5,-40(s0)
    8020ae96:	00e79a23          	sh	a4,20(a5)
		ip->major = dip->major;
    8020ae9a:	fe043783          	ld	a5,-32(s0)
    8020ae9e:	00279703          	lh	a4,2(a5)
    8020aea2:	fd843783          	ld	a5,-40(s0)
    8020aea6:	00e79b23          	sh	a4,22(a5)
		ip->minor = dip->minor;
    8020aeaa:	fe043783          	ld	a5,-32(s0)
    8020aeae:	00479703          	lh	a4,4(a5)
    8020aeb2:	fd843783          	ld	a5,-40(s0)
    8020aeb6:	00e79c23          	sh	a4,24(a5)
		ip->nlink = dip->nlink;
    8020aeba:	fe043783          	ld	a5,-32(s0)
    8020aebe:	00679703          	lh	a4,6(a5)
    8020aec2:	fd843783          	ld	a5,-40(s0)
    8020aec6:	00e79d23          	sh	a4,26(a5)
		ip->size = dip->size;
    8020aeca:	fe043783          	ld	a5,-32(s0)
    8020aece:	4798                	lw	a4,8(a5)
    8020aed0:	fd843783          	ld	a5,-40(s0)
    8020aed4:	cfd8                	sw	a4,28(a5)
		memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8020aed6:	fd843783          	ld	a5,-40(s0)
    8020aeda:	02078713          	addi	a4,a5,32
    8020aede:	fe043783          	ld	a5,-32(s0)
    8020aee2:	07b1                	addi	a5,a5,12
    8020aee4:	03400613          	li	a2,52
    8020aee8:	85be                	mv	a1,a5
    8020aeea:	853a                	mv	a0,a4
    8020aeec:	ffff7097          	auipc	ra,0xffff7
    8020aef0:	0a8080e7          	jalr	168(ra) # 80201f94 <memmove>
		brelse(bp);
    8020aef4:	fe843503          	ld	a0,-24(s0)
    8020aef8:	ffffe097          	auipc	ra,0xffffe
    8020aefc:	170080e7          	jalr	368(ra) # 80209068 <brelse>
		ip->valid = 1;
    8020af00:	fd843783          	ld	a5,-40(s0)
    8020af04:	4705                	li	a4,1
    8020af06:	c7d8                	sw	a4,12(a5)
		if (ip->type == 0)
    8020af08:	fd843783          	ld	a5,-40(s0)
    8020af0c:	01479783          	lh	a5,20(a5)
    8020af10:	eb89                	bnez	a5,8020af22 <ilock+0x12c>
			panic("ilock: no type");
    8020af12:	0002d517          	auipc	a0,0x2d
    8020af16:	93e50513          	addi	a0,a0,-1730 # 80237850 <user_test_table+0x120>
    8020af1a:	ffff7097          	auipc	ra,0xffff7
    8020af1e:	8ec080e7          	jalr	-1812(ra) # 80201806 <panic>
	}
}
    8020af22:	0001                	nop
    8020af24:	70a2                	ld	ra,40(sp)
    8020af26:	7402                	ld	s0,32(sp)
    8020af28:	6145                	addi	sp,sp,48
    8020af2a:	8082                	ret

000000008020af2c <iunlock>:

// Unlock the given inode.
void iunlock(struct inode *ip)
{
    8020af2c:	1101                	addi	sp,sp,-32
    8020af2e:	ec06                	sd	ra,24(sp)
    8020af30:	e822                	sd	s0,16(sp)
    8020af32:	1000                	addi	s0,sp,32
    8020af34:	fea43423          	sd	a0,-24(s0)
	if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8020af38:	fe843783          	ld	a5,-24(s0)
    8020af3c:	c38d                	beqz	a5,8020af5e <iunlock+0x32>
    8020af3e:	fe843783          	ld	a5,-24(s0)
    8020af42:	05878793          	addi	a5,a5,88
    8020af46:	853e                	mv	a0,a5
    8020af48:	00001097          	auipc	ra,0x1
    8020af4c:	400080e7          	jalr	1024(ra) # 8020c348 <holdingsleep>
    8020af50:	87aa                	mv	a5,a0
    8020af52:	c791                	beqz	a5,8020af5e <iunlock+0x32>
    8020af54:	fe843783          	ld	a5,-24(s0)
    8020af58:	479c                	lw	a5,8(a5)
    8020af5a:	00f04a63          	bgtz	a5,8020af6e <iunlock+0x42>
		panic("iunlock");
    8020af5e:	0002d517          	auipc	a0,0x2d
    8020af62:	90250513          	addi	a0,a0,-1790 # 80237860 <user_test_table+0x130>
    8020af66:	ffff7097          	auipc	ra,0xffff7
    8020af6a:	8a0080e7          	jalr	-1888(ra) # 80201806 <panic>
	releasesleep(&ip->lock);
    8020af6e:	fe843783          	ld	a5,-24(s0)
    8020af72:	05878793          	addi	a5,a5,88
    8020af76:	853e                	mv	a0,a5
    8020af78:	00001097          	auipc	ra,0x1
    8020af7c:	37e080e7          	jalr	894(ra) # 8020c2f6 <releasesleep>
}
    8020af80:	0001                	nop
    8020af82:	60e2                	ld	ra,24(sp)
    8020af84:	6442                	ld	s0,16(sp)
    8020af86:	6105                	addi	sp,sp,32
    8020af88:	8082                	ret

000000008020af8a <iput>:
void iput(struct inode *ip)
{
    8020af8a:	1101                	addi	sp,sp,-32
    8020af8c:	ec06                	sd	ra,24(sp)
    8020af8e:	e822                	sd	s0,16(sp)
    8020af90:	1000                	addi	s0,sp,32
    8020af92:	fea43423          	sd	a0,-24(s0)
	acquire(&itable.lock);
    8020af96:	0003c517          	auipc	a0,0x3c
    8020af9a:	08a50513          	addi	a0,a0,138 # 80247020 <itable>
    8020af9e:	00001097          	auipc	ra,0x1
    8020afa2:	19a080e7          	jalr	410(ra) # 8020c138 <acquire>
	if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    8020afa6:	fe843783          	ld	a5,-24(s0)
    8020afaa:	479c                	lw	a5,8(a5)
    8020afac:	873e                	mv	a4,a5
    8020afae:	4785                	li	a5,1
    8020afb0:	08f71163          	bne	a4,a5,8020b032 <iput+0xa8>
    8020afb4:	fe843783          	ld	a5,-24(s0)
    8020afb8:	47dc                	lw	a5,12(a5)
    8020afba:	cfa5                	beqz	a5,8020b032 <iput+0xa8>
    8020afbc:	fe843783          	ld	a5,-24(s0)
    8020afc0:	01a79783          	lh	a5,26(a5)
    8020afc4:	e7bd                	bnez	a5,8020b032 <iput+0xa8>
	{
		acquiresleep(&ip->lock);
    8020afc6:	fe843783          	ld	a5,-24(s0)
    8020afca:	05878793          	addi	a5,a5,88
    8020afce:	853e                	mv	a0,a5
    8020afd0:	00001097          	auipc	ra,0x1
    8020afd4:	260080e7          	jalr	608(ra) # 8020c230 <acquiresleep>

		release(&itable.lock);
    8020afd8:	0003c517          	auipc	a0,0x3c
    8020afdc:	04850513          	addi	a0,a0,72 # 80247020 <itable>
    8020afe0:	00001097          	auipc	ra,0x1
    8020afe4:	1a4080e7          	jalr	420(ra) # 8020c184 <release>
		itrunc(ip);
    8020afe8:	fe843503          	ld	a0,-24(s0)
    8020afec:	00000097          	auipc	ra,0x0
    8020aff0:	342080e7          	jalr	834(ra) # 8020b32e <itrunc>
		ip->type = 0;
    8020aff4:	fe843783          	ld	a5,-24(s0)
    8020aff8:	00079a23          	sh	zero,20(a5)
		iupdate(ip);
    8020affc:	fe843503          	ld	a0,-24(s0)
    8020b000:	00000097          	auipc	ra,0x0
    8020b004:	ba6080e7          	jalr	-1114(ra) # 8020aba6 <iupdate>
		ip->valid = 0;
    8020b008:	fe843783          	ld	a5,-24(s0)
    8020b00c:	0007a623          	sw	zero,12(a5)
		releasesleep(&ip->lock);
    8020b010:	fe843783          	ld	a5,-24(s0)
    8020b014:	05878793          	addi	a5,a5,88
    8020b018:	853e                	mv	a0,a5
    8020b01a:	00001097          	auipc	ra,0x1
    8020b01e:	2dc080e7          	jalr	732(ra) # 8020c2f6 <releasesleep>

		acquire(&itable.lock);
    8020b022:	0003c517          	auipc	a0,0x3c
    8020b026:	ffe50513          	addi	a0,a0,-2 # 80247020 <itable>
    8020b02a:	00001097          	auipc	ra,0x1
    8020b02e:	10e080e7          	jalr	270(ra) # 8020c138 <acquire>
	}

	ip->ref--;
    8020b032:	fe843783          	ld	a5,-24(s0)
    8020b036:	479c                	lw	a5,8(a5)
    8020b038:	37fd                	addiw	a5,a5,-1
    8020b03a:	0007871b          	sext.w	a4,a5
    8020b03e:	fe843783          	ld	a5,-24(s0)
    8020b042:	c798                	sw	a4,8(a5)
	release(&itable.lock);
    8020b044:	0003c517          	auipc	a0,0x3c
    8020b048:	fdc50513          	addi	a0,a0,-36 # 80247020 <itable>
    8020b04c:	00001097          	auipc	ra,0x1
    8020b050:	138080e7          	jalr	312(ra) # 8020c184 <release>
}
    8020b054:	0001                	nop
    8020b056:	60e2                	ld	ra,24(sp)
    8020b058:	6442                	ld	s0,16(sp)
    8020b05a:	6105                	addi	sp,sp,32
    8020b05c:	8082                	ret

000000008020b05e <iunlockput>:
void iunlockput(struct inode *ip)
{
    8020b05e:	1101                	addi	sp,sp,-32
    8020b060:	ec06                	sd	ra,24(sp)
    8020b062:	e822                	sd	s0,16(sp)
    8020b064:	1000                	addi	s0,sp,32
    8020b066:	fea43423          	sd	a0,-24(s0)
	iunlock(ip);
    8020b06a:	fe843503          	ld	a0,-24(s0)
    8020b06e:	00000097          	auipc	ra,0x0
    8020b072:	ebe080e7          	jalr	-322(ra) # 8020af2c <iunlock>
	iput(ip);
    8020b076:	fe843503          	ld	a0,-24(s0)
    8020b07a:	00000097          	auipc	ra,0x0
    8020b07e:	f10080e7          	jalr	-240(ra) # 8020af8a <iput>
}
    8020b082:	0001                	nop
    8020b084:	60e2                	ld	ra,24(sp)
    8020b086:	6442                	ld	s0,16(sp)
    8020b088:	6105                	addi	sp,sp,32
    8020b08a:	8082                	ret

000000008020b08c <ireclaim>:

void ireclaim(int dev)
{
    8020b08c:	7139                	addi	sp,sp,-64
    8020b08e:	fc06                	sd	ra,56(sp)
    8020b090:	f822                	sd	s0,48(sp)
    8020b092:	0080                	addi	s0,sp,64
    8020b094:	87aa                	mv	a5,a0
    8020b096:	fcf42623          	sw	a5,-52(s0)
	printf("Superblock: ninodes=%d\n", sb.ninodes);
    8020b09a:	0003c797          	auipc	a5,0x3c
    8020b09e:	f6678793          	addi	a5,a5,-154 # 80247000 <sb>
    8020b0a2:	47dc                	lw	a5,12(a5)
    8020b0a4:	85be                	mv	a1,a5
    8020b0a6:	0002c517          	auipc	a0,0x2c
    8020b0aa:	7c250513          	addi	a0,a0,1986 # 80237868 <user_test_table+0x138>
    8020b0ae:	ffff6097          	auipc	ra,0xffff6
    8020b0b2:	1d6080e7          	jalr	470(ra) # 80201284 <printf>
	for (int inum = 1; inum < sb.ninodes; inum++)
    8020b0b6:	4785                	li	a5,1
    8020b0b8:	fef42623          	sw	a5,-20(s0)
    8020b0bc:	a8e9                	j	8020b196 <ireclaim+0x10a>
	{
		struct inode *ip = 0;
    8020b0be:	fe043023          	sd	zero,-32(s0)
		struct buf *bp = bread(dev, IBLOCK(inum, sb));
    8020b0c2:	fcc42683          	lw	a3,-52(s0)
    8020b0c6:	fec42783          	lw	a5,-20(s0)
    8020b0ca:	8391                	srli	a5,a5,0x4
    8020b0cc:	0007871b          	sext.w	a4,a5
    8020b0d0:	0003c797          	auipc	a5,0x3c
    8020b0d4:	f3078793          	addi	a5,a5,-208 # 80247000 <sb>
    8020b0d8:	4f9c                	lw	a5,24(a5)
    8020b0da:	9fb9                	addw	a5,a5,a4
    8020b0dc:	2781                	sext.w	a5,a5
    8020b0de:	85be                	mv	a1,a5
    8020b0e0:	8536                	mv	a0,a3
    8020b0e2:	ffffe097          	auipc	ra,0xffffe
    8020b0e6:	ee4080e7          	jalr	-284(ra) # 80208fc6 <bread>
    8020b0ea:	fca43c23          	sd	a0,-40(s0)
		struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    8020b0ee:	fd843783          	ld	a5,-40(s0)
    8020b0f2:	05078713          	addi	a4,a5,80
    8020b0f6:	fec42783          	lw	a5,-20(s0)
    8020b0fa:	8bbd                	andi	a5,a5,15
    8020b0fc:	079a                	slli	a5,a5,0x6
    8020b0fe:	97ba                	add	a5,a5,a4
    8020b100:	fcf43823          	sd	a5,-48(s0)
		if (dip->type != 0 && dip->nlink == 0)
    8020b104:	fd043783          	ld	a5,-48(s0)
    8020b108:	00079783          	lh	a5,0(a5)
    8020b10c:	cf8d                	beqz	a5,8020b146 <ireclaim+0xba>
    8020b10e:	fd043783          	ld	a5,-48(s0)
    8020b112:	00679783          	lh	a5,6(a5)
    8020b116:	eb85                	bnez	a5,8020b146 <ireclaim+0xba>
		{ // is an orphaned inode
			printf("ireclaim: orphaned inode %d\n", inum);
    8020b118:	fec42783          	lw	a5,-20(s0)
    8020b11c:	85be                	mv	a1,a5
    8020b11e:	0002c517          	auipc	a0,0x2c
    8020b122:	76250513          	addi	a0,a0,1890 # 80237880 <user_test_table+0x150>
    8020b126:	ffff6097          	auipc	ra,0xffff6
    8020b12a:	15e080e7          	jalr	350(ra) # 80201284 <printf>
			ip = iget(dev, inum);
    8020b12e:	fcc42783          	lw	a5,-52(s0)
    8020b132:	fec42703          	lw	a4,-20(s0)
    8020b136:	85ba                	mv	a1,a4
    8020b138:	853e                	mv	a0,a5
    8020b13a:	00000097          	auipc	ra,0x0
    8020b13e:	b54080e7          	jalr	-1196(ra) # 8020ac8e <iget>
    8020b142:	fea43023          	sd	a0,-32(s0)
		}
		brelse(bp);
    8020b146:	fd843503          	ld	a0,-40(s0)
    8020b14a:	ffffe097          	auipc	ra,0xffffe
    8020b14e:	f1e080e7          	jalr	-226(ra) # 80209068 <brelse>
		if (ip)
    8020b152:	fe043783          	ld	a5,-32(s0)
    8020b156:	cb9d                	beqz	a5,8020b18c <ireclaim+0x100>
		{
			begin_op();
    8020b158:	ffffe097          	auipc	ra,0xffffe
    8020b15c:	4c6080e7          	jalr	1222(ra) # 8020961e <begin_op>
			ilock(ip);
    8020b160:	fe043503          	ld	a0,-32(s0)
    8020b164:	00000097          	auipc	ra,0x0
    8020b168:	c92080e7          	jalr	-878(ra) # 8020adf6 <ilock>
			iunlock(ip);
    8020b16c:	fe043503          	ld	a0,-32(s0)
    8020b170:	00000097          	auipc	ra,0x0
    8020b174:	dbc080e7          	jalr	-580(ra) # 8020af2c <iunlock>
			iput(ip);
    8020b178:	fe043503          	ld	a0,-32(s0)
    8020b17c:	00000097          	auipc	ra,0x0
    8020b180:	e0e080e7          	jalr	-498(ra) # 8020af8a <iput>
			end_op();
    8020b184:	ffffe097          	auipc	ra,0xffffe
    8020b188:	55c080e7          	jalr	1372(ra) # 802096e0 <end_op>
	for (int inum = 1; inum < sb.ninodes; inum++)
    8020b18c:	fec42783          	lw	a5,-20(s0)
    8020b190:	2785                	addiw	a5,a5,1
    8020b192:	fef42623          	sw	a5,-20(s0)
    8020b196:	0003c797          	auipc	a5,0x3c
    8020b19a:	e6a78793          	addi	a5,a5,-406 # 80247000 <sb>
    8020b19e:	47d8                	lw	a4,12(a5)
    8020b1a0:	fec42783          	lw	a5,-20(s0)
    8020b1a4:	f0e7ede3          	bltu	a5,a4,8020b0be <ireclaim+0x32>
		}
	}
}
    8020b1a8:	0001                	nop
    8020b1aa:	0001                	nop
    8020b1ac:	70e2                	ld	ra,56(sp)
    8020b1ae:	7442                	ld	s0,48(sp)
    8020b1b0:	6121                	addi	sp,sp,64
    8020b1b2:	8082                	ret

000000008020b1b4 <bmap>:

static uint
bmap(struct inode *ip, uint bn)
{
    8020b1b4:	7139                	addi	sp,sp,-64
    8020b1b6:	fc06                	sd	ra,56(sp)
    8020b1b8:	f822                	sd	s0,48(sp)
    8020b1ba:	0080                	addi	s0,sp,64
    8020b1bc:	fca43423          	sd	a0,-56(s0)
    8020b1c0:	87ae                	mv	a5,a1
    8020b1c2:	fcf42223          	sw	a5,-60(s0)
	uint addr, *a;
	struct buf *bp;

	if (bn < NDIRECT)
    8020b1c6:	fc442783          	lw	a5,-60(s0)
    8020b1ca:	0007871b          	sext.w	a4,a5
    8020b1ce:	47ad                	li	a5,11
    8020b1d0:	04e7ee63          	bltu	a5,a4,8020b22c <bmap+0x78>
	{
		if ((addr = ip->addrs[bn]) == 0)
    8020b1d4:	fc843703          	ld	a4,-56(s0)
    8020b1d8:	fc446783          	lwu	a5,-60(s0)
    8020b1dc:	07a1                	addi	a5,a5,8
    8020b1de:	078a                	slli	a5,a5,0x2
    8020b1e0:	97ba                	add	a5,a5,a4
    8020b1e2:	439c                	lw	a5,0(a5)
    8020b1e4:	fef42623          	sw	a5,-20(s0)
    8020b1e8:	fec42783          	lw	a5,-20(s0)
    8020b1ec:	2781                	sext.w	a5,a5
    8020b1ee:	ef85                	bnez	a5,8020b226 <bmap+0x72>
		{
			addr = balloc(ip->dev);
    8020b1f0:	fc843783          	ld	a5,-56(s0)
    8020b1f4:	439c                	lw	a5,0(a5)
    8020b1f6:	853e                	mv	a0,a5
    8020b1f8:	fffff097          	auipc	ra,0xfffff
    8020b1fc:	56c080e7          	jalr	1388(ra) # 8020a764 <balloc>
    8020b200:	87aa                	mv	a5,a0
    8020b202:	fef42623          	sw	a5,-20(s0)
			if (addr == 0)
    8020b206:	fec42783          	lw	a5,-20(s0)
    8020b20a:	2781                	sext.w	a5,a5
    8020b20c:	e399                	bnez	a5,8020b212 <bmap+0x5e>
				return 0;
    8020b20e:	4781                	li	a5,0
    8020b210:	aa11                	j	8020b324 <bmap+0x170>
			ip->addrs[bn] = addr;
    8020b212:	fc843703          	ld	a4,-56(s0)
    8020b216:	fc446783          	lwu	a5,-60(s0)
    8020b21a:	07a1                	addi	a5,a5,8
    8020b21c:	078a                	slli	a5,a5,0x2
    8020b21e:	97ba                	add	a5,a5,a4
    8020b220:	fec42703          	lw	a4,-20(s0)
    8020b224:	c398                	sw	a4,0(a5)
		}
		return addr;
    8020b226:	fec42783          	lw	a5,-20(s0)
    8020b22a:	a8ed                	j	8020b324 <bmap+0x170>
	}
	bn -= NDIRECT;
    8020b22c:	fc442783          	lw	a5,-60(s0)
    8020b230:	37d1                	addiw	a5,a5,-12
    8020b232:	fcf42223          	sw	a5,-60(s0)

	if (bn < NINDIRECT)
    8020b236:	fc442783          	lw	a5,-60(s0)
    8020b23a:	0007871b          	sext.w	a4,a5
    8020b23e:	0ff00793          	li	a5,255
    8020b242:	0ce7e863          	bltu	a5,a4,8020b312 <bmap+0x15e>
	{
		// Load indirect block, allocating if necessary.
		if ((addr = ip->addrs[NDIRECT]) == 0)
    8020b246:	fc843783          	ld	a5,-56(s0)
    8020b24a:	4bbc                	lw	a5,80(a5)
    8020b24c:	fef42623          	sw	a5,-20(s0)
    8020b250:	fec42783          	lw	a5,-20(s0)
    8020b254:	2781                	sext.w	a5,a5
    8020b256:	e79d                	bnez	a5,8020b284 <bmap+0xd0>
		{
			addr = balloc(ip->dev);
    8020b258:	fc843783          	ld	a5,-56(s0)
    8020b25c:	439c                	lw	a5,0(a5)
    8020b25e:	853e                	mv	a0,a5
    8020b260:	fffff097          	auipc	ra,0xfffff
    8020b264:	504080e7          	jalr	1284(ra) # 8020a764 <balloc>
    8020b268:	87aa                	mv	a5,a0
    8020b26a:	fef42623          	sw	a5,-20(s0)
			if (addr == 0)
    8020b26e:	fec42783          	lw	a5,-20(s0)
    8020b272:	2781                	sext.w	a5,a5
    8020b274:	e399                	bnez	a5,8020b27a <bmap+0xc6>
				return 0;
    8020b276:	4781                	li	a5,0
    8020b278:	a075                	j	8020b324 <bmap+0x170>
			ip->addrs[NDIRECT] = addr;
    8020b27a:	fc843783          	ld	a5,-56(s0)
    8020b27e:	fec42703          	lw	a4,-20(s0)
    8020b282:	cbb8                	sw	a4,80(a5)
		}
		bp = bread(ip->dev, addr);
    8020b284:	fc843783          	ld	a5,-56(s0)
    8020b288:	439c                	lw	a5,0(a5)
    8020b28a:	fec42703          	lw	a4,-20(s0)
    8020b28e:	85ba                	mv	a1,a4
    8020b290:	853e                	mv	a0,a5
    8020b292:	ffffe097          	auipc	ra,0xffffe
    8020b296:	d34080e7          	jalr	-716(ra) # 80208fc6 <bread>
    8020b29a:	fea43023          	sd	a0,-32(s0)
		a = (uint *)bp->data;
    8020b29e:	fe043783          	ld	a5,-32(s0)
    8020b2a2:	05078793          	addi	a5,a5,80
    8020b2a6:	fcf43c23          	sd	a5,-40(s0)
		if ((addr = a[bn]) == 0)
    8020b2aa:	fc446783          	lwu	a5,-60(s0)
    8020b2ae:	078a                	slli	a5,a5,0x2
    8020b2b0:	fd843703          	ld	a4,-40(s0)
    8020b2b4:	97ba                	add	a5,a5,a4
    8020b2b6:	439c                	lw	a5,0(a5)
    8020b2b8:	fef42623          	sw	a5,-20(s0)
    8020b2bc:	fec42783          	lw	a5,-20(s0)
    8020b2c0:	2781                	sext.w	a5,a5
    8020b2c2:	ef9d                	bnez	a5,8020b300 <bmap+0x14c>
		{
			addr = balloc(ip->dev);
    8020b2c4:	fc843783          	ld	a5,-56(s0)
    8020b2c8:	439c                	lw	a5,0(a5)
    8020b2ca:	853e                	mv	a0,a5
    8020b2cc:	fffff097          	auipc	ra,0xfffff
    8020b2d0:	498080e7          	jalr	1176(ra) # 8020a764 <balloc>
    8020b2d4:	87aa                	mv	a5,a0
    8020b2d6:	fef42623          	sw	a5,-20(s0)
			if (addr)
    8020b2da:	fec42783          	lw	a5,-20(s0)
    8020b2de:	2781                	sext.w	a5,a5
    8020b2e0:	c385                	beqz	a5,8020b300 <bmap+0x14c>
			{
				a[bn] = addr;
    8020b2e2:	fc446783          	lwu	a5,-60(s0)
    8020b2e6:	078a                	slli	a5,a5,0x2
    8020b2e8:	fd843703          	ld	a4,-40(s0)
    8020b2ec:	97ba                	add	a5,a5,a4
    8020b2ee:	fec42703          	lw	a4,-20(s0)
    8020b2f2:	c398                	sw	a4,0(a5)
				log_write(bp);
    8020b2f4:	fe043503          	ld	a0,-32(s0)
    8020b2f8:	ffffe097          	auipc	ra,0xffffe
    8020b2fc:	604080e7          	jalr	1540(ra) # 802098fc <log_write>
			}
		}
		brelse(bp);
    8020b300:	fe043503          	ld	a0,-32(s0)
    8020b304:	ffffe097          	auipc	ra,0xffffe
    8020b308:	d64080e7          	jalr	-668(ra) # 80209068 <brelse>
		return addr;
    8020b30c:	fec42783          	lw	a5,-20(s0)
    8020b310:	a811                	j	8020b324 <bmap+0x170>
	}

	panic("bmap: out of range");
    8020b312:	0002c517          	auipc	a0,0x2c
    8020b316:	58e50513          	addi	a0,a0,1422 # 802378a0 <user_test_table+0x170>
    8020b31a:	ffff6097          	auipc	ra,0xffff6
    8020b31e:	4ec080e7          	jalr	1260(ra) # 80201806 <panic>
	return 0;
    8020b322:	4781                	li	a5,0
}
    8020b324:	853e                	mv	a0,a5
    8020b326:	70e2                	ld	ra,56(sp)
    8020b328:	7442                	ld	s0,48(sp)
    8020b32a:	6121                	addi	sp,sp,64
    8020b32c:	8082                	ret

000000008020b32e <itrunc>:

void itrunc(struct inode *ip)
{
    8020b32e:	7139                	addi	sp,sp,-64
    8020b330:	fc06                	sd	ra,56(sp)
    8020b332:	f822                	sd	s0,48(sp)
    8020b334:	0080                	addi	s0,sp,64
    8020b336:	fca43423          	sd	a0,-56(s0)
	int i, j;
	struct buf *bp;
	uint *a;

	for (i = 0; i < NDIRECT; i++)
    8020b33a:	fe042623          	sw	zero,-20(s0)
    8020b33e:	a899                	j	8020b394 <itrunc+0x66>
	{
		if (ip->addrs[i])
    8020b340:	fc843703          	ld	a4,-56(s0)
    8020b344:	fec42783          	lw	a5,-20(s0)
    8020b348:	07a1                	addi	a5,a5,8
    8020b34a:	078a                	slli	a5,a5,0x2
    8020b34c:	97ba                	add	a5,a5,a4
    8020b34e:	439c                	lw	a5,0(a5)
    8020b350:	cf8d                	beqz	a5,8020b38a <itrunc+0x5c>
		{
			bfree(ip->dev, ip->addrs[i]);
    8020b352:	fc843783          	ld	a5,-56(s0)
    8020b356:	439c                	lw	a5,0(a5)
    8020b358:	0007869b          	sext.w	a3,a5
    8020b35c:	fc843703          	ld	a4,-56(s0)
    8020b360:	fec42783          	lw	a5,-20(s0)
    8020b364:	07a1                	addi	a5,a5,8
    8020b366:	078a                	slli	a5,a5,0x2
    8020b368:	97ba                	add	a5,a5,a4
    8020b36a:	439c                	lw	a5,0(a5)
    8020b36c:	85be                	mv	a1,a5
    8020b36e:	8536                	mv	a0,a3
    8020b370:	fffff097          	auipc	ra,0xfffff
    8020b374:	59c080e7          	jalr	1436(ra) # 8020a90c <bfree>
			ip->addrs[i] = 0;
    8020b378:	fc843703          	ld	a4,-56(s0)
    8020b37c:	fec42783          	lw	a5,-20(s0)
    8020b380:	07a1                	addi	a5,a5,8
    8020b382:	078a                	slli	a5,a5,0x2
    8020b384:	97ba                	add	a5,a5,a4
    8020b386:	0007a023          	sw	zero,0(a5)
	for (i = 0; i < NDIRECT; i++)
    8020b38a:	fec42783          	lw	a5,-20(s0)
    8020b38e:	2785                	addiw	a5,a5,1
    8020b390:	fef42623          	sw	a5,-20(s0)
    8020b394:	fec42783          	lw	a5,-20(s0)
    8020b398:	0007871b          	sext.w	a4,a5
    8020b39c:	47ad                	li	a5,11
    8020b39e:	fae7d1e3          	bge	a5,a4,8020b340 <itrunc+0x12>
		}
	}

	if (ip->addrs[NDIRECT])
    8020b3a2:	fc843783          	ld	a5,-56(s0)
    8020b3a6:	4bbc                	lw	a5,80(a5)
    8020b3a8:	c7d5                	beqz	a5,8020b454 <itrunc+0x126>
	{
		bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8020b3aa:	fc843783          	ld	a5,-56(s0)
    8020b3ae:	4398                	lw	a4,0(a5)
    8020b3b0:	fc843783          	ld	a5,-56(s0)
    8020b3b4:	4bbc                	lw	a5,80(a5)
    8020b3b6:	85be                	mv	a1,a5
    8020b3b8:	853a                	mv	a0,a4
    8020b3ba:	ffffe097          	auipc	ra,0xffffe
    8020b3be:	c0c080e7          	jalr	-1012(ra) # 80208fc6 <bread>
    8020b3c2:	fea43023          	sd	a0,-32(s0)
		a = (uint *)bp->data;
    8020b3c6:	fe043783          	ld	a5,-32(s0)
    8020b3ca:	05078793          	addi	a5,a5,80
    8020b3ce:	fcf43c23          	sd	a5,-40(s0)
		for (j = 0; j < NINDIRECT; j++)
    8020b3d2:	fe042423          	sw	zero,-24(s0)
    8020b3d6:	a081                	j	8020b416 <itrunc+0xe8>
		{
			if (a[j])
    8020b3d8:	fe842783          	lw	a5,-24(s0)
    8020b3dc:	078a                	slli	a5,a5,0x2
    8020b3de:	fd843703          	ld	a4,-40(s0)
    8020b3e2:	97ba                	add	a5,a5,a4
    8020b3e4:	439c                	lw	a5,0(a5)
    8020b3e6:	c39d                	beqz	a5,8020b40c <itrunc+0xde>
				bfree(ip->dev, a[j]);
    8020b3e8:	fc843783          	ld	a5,-56(s0)
    8020b3ec:	439c                	lw	a5,0(a5)
    8020b3ee:	0007869b          	sext.w	a3,a5
    8020b3f2:	fe842783          	lw	a5,-24(s0)
    8020b3f6:	078a                	slli	a5,a5,0x2
    8020b3f8:	fd843703          	ld	a4,-40(s0)
    8020b3fc:	97ba                	add	a5,a5,a4
    8020b3fe:	439c                	lw	a5,0(a5)
    8020b400:	85be                	mv	a1,a5
    8020b402:	8536                	mv	a0,a3
    8020b404:	fffff097          	auipc	ra,0xfffff
    8020b408:	508080e7          	jalr	1288(ra) # 8020a90c <bfree>
		for (j = 0; j < NINDIRECT; j++)
    8020b40c:	fe842783          	lw	a5,-24(s0)
    8020b410:	2785                	addiw	a5,a5,1
    8020b412:	fef42423          	sw	a5,-24(s0)
    8020b416:	fe842783          	lw	a5,-24(s0)
    8020b41a:	873e                	mv	a4,a5
    8020b41c:	0ff00793          	li	a5,255
    8020b420:	fae7fce3          	bgeu	a5,a4,8020b3d8 <itrunc+0xaa>
		}
		brelse(bp);
    8020b424:	fe043503          	ld	a0,-32(s0)
    8020b428:	ffffe097          	auipc	ra,0xffffe
    8020b42c:	c40080e7          	jalr	-960(ra) # 80209068 <brelse>
		bfree(ip->dev, ip->addrs[NDIRECT]);
    8020b430:	fc843783          	ld	a5,-56(s0)
    8020b434:	439c                	lw	a5,0(a5)
    8020b436:	0007871b          	sext.w	a4,a5
    8020b43a:	fc843783          	ld	a5,-56(s0)
    8020b43e:	4bbc                	lw	a5,80(a5)
    8020b440:	85be                	mv	a1,a5
    8020b442:	853a                	mv	a0,a4
    8020b444:	fffff097          	auipc	ra,0xfffff
    8020b448:	4c8080e7          	jalr	1224(ra) # 8020a90c <bfree>
		ip->addrs[NDIRECT] = 0;
    8020b44c:	fc843783          	ld	a5,-56(s0)
    8020b450:	0407a823          	sw	zero,80(a5)
	}

	ip->size = 0;
    8020b454:	fc843783          	ld	a5,-56(s0)
    8020b458:	0007ae23          	sw	zero,28(a5)
	iupdate(ip);
    8020b45c:	fc843503          	ld	a0,-56(s0)
    8020b460:	fffff097          	auipc	ra,0xfffff
    8020b464:	746080e7          	jalr	1862(ra) # 8020aba6 <iupdate>
}
    8020b468:	0001                	nop
    8020b46a:	70e2                	ld	ra,56(sp)
    8020b46c:	7442                	ld	s0,48(sp)
    8020b46e:	6121                	addi	sp,sp,64
    8020b470:	8082                	ret

000000008020b472 <stati>:

void stati(struct inode *ip, struct stat *st)
{
    8020b472:	1101                	addi	sp,sp,-32
    8020b474:	ec22                	sd	s0,24(sp)
    8020b476:	1000                	addi	s0,sp,32
    8020b478:	fea43423          	sd	a0,-24(s0)
    8020b47c:	feb43023          	sd	a1,-32(s0)
	st->dev = ip->dev;
    8020b480:	fe843783          	ld	a5,-24(s0)
    8020b484:	439c                	lw	a5,0(a5)
    8020b486:	0007871b          	sext.w	a4,a5
    8020b48a:	fe043783          	ld	a5,-32(s0)
    8020b48e:	c398                	sw	a4,0(a5)
	st->ino = ip->inum;
    8020b490:	fe843783          	ld	a5,-24(s0)
    8020b494:	43d8                	lw	a4,4(a5)
    8020b496:	fe043783          	ld	a5,-32(s0)
    8020b49a:	c3d8                	sw	a4,4(a5)
	st->type = ip->type;
    8020b49c:	fe843783          	ld	a5,-24(s0)
    8020b4a0:	01479703          	lh	a4,20(a5)
    8020b4a4:	fe043783          	ld	a5,-32(s0)
    8020b4a8:	00e79423          	sh	a4,8(a5)
	st->nlink = ip->nlink;
    8020b4ac:	fe843783          	ld	a5,-24(s0)
    8020b4b0:	01a79703          	lh	a4,26(a5)
    8020b4b4:	fe043783          	ld	a5,-32(s0)
    8020b4b8:	00e79523          	sh	a4,10(a5)
	st->size = ip->size;
    8020b4bc:	fe843783          	ld	a5,-24(s0)
    8020b4c0:	4fdc                	lw	a5,28(a5)
    8020b4c2:	02079713          	slli	a4,a5,0x20
    8020b4c6:	9301                	srli	a4,a4,0x20
    8020b4c8:	fe043783          	ld	a5,-32(s0)
    8020b4cc:	eb98                	sd	a4,16(a5)
}
    8020b4ce:	0001                	nop
    8020b4d0:	6462                	ld	s0,24(sp)
    8020b4d2:	6105                	addi	sp,sp,32
    8020b4d4:	8082                	ret

000000008020b4d6 <either_copyin>:
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8020b4d6:	7179                	addi	sp,sp,-48
    8020b4d8:	f406                	sd	ra,40(sp)
    8020b4da:	f022                	sd	s0,32(sp)
    8020b4dc:	1800                	addi	s0,sp,48
    8020b4de:	fea43423          	sd	a0,-24(s0)
    8020b4e2:	87ae                	mv	a5,a1
    8020b4e4:	fcc43c23          	sd	a2,-40(s0)
    8020b4e8:	fcd43823          	sd	a3,-48(s0)
    8020b4ec:	fef42223          	sw	a5,-28(s0)
	if (user_src)
    8020b4f0:	fe442783          	lw	a5,-28(s0)
    8020b4f4:	2781                	sext.w	a5,a5
    8020b4f6:	cf99                	beqz	a5,8020b514 <either_copyin+0x3e>
	{
		// src 是用户空间虚拟地址
		return copyin(dst, src, len);
    8020b4f8:	fd043783          	ld	a5,-48(s0)
    8020b4fc:	2781                	sext.w	a5,a5
    8020b4fe:	863e                	mv	a2,a5
    8020b500:	fd843583          	ld	a1,-40(s0)
    8020b504:	fe843503          	ld	a0,-24(s0)
    8020b508:	ffff9097          	auipc	ra,0xffff9
    8020b50c:	b76080e7          	jalr	-1162(ra) # 8020407e <copyin>
    8020b510:	87aa                	mv	a5,a0
    8020b512:	a829                	j	8020b52c <either_copyin+0x56>
	}
	else
	{
		// src 是内核空间地址
		memmove(dst, (void *)src, len);
    8020b514:	fd843783          	ld	a5,-40(s0)
    8020b518:	fd043603          	ld	a2,-48(s0)
    8020b51c:	85be                	mv	a1,a5
    8020b51e:	fe843503          	ld	a0,-24(s0)
    8020b522:	ffff7097          	auipc	ra,0xffff7
    8020b526:	a72080e7          	jalr	-1422(ra) # 80201f94 <memmove>
		return 0;
    8020b52a:	4781                	li	a5,0
	}
}
    8020b52c:	853e                	mv	a0,a5
    8020b52e:	70a2                	ld	ra,40(sp)
    8020b530:	7402                	ld	s0,32(sp)
    8020b532:	6145                	addi	sp,sp,48
    8020b534:	8082                	ret

000000008020b536 <either_copyout>:
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8020b536:	7179                	addi	sp,sp,-48
    8020b538:	f406                	sd	ra,40(sp)
    8020b53a:	f022                	sd	s0,32(sp)
    8020b53c:	1800                	addi	s0,sp,48
    8020b53e:	87aa                	mv	a5,a0
    8020b540:	feb43023          	sd	a1,-32(s0)
    8020b544:	fcc43c23          	sd	a2,-40(s0)
    8020b548:	fcd43823          	sd	a3,-48(s0)
    8020b54c:	fef42623          	sw	a5,-20(s0)
	if (user_dst)
    8020b550:	fec42783          	lw	a5,-20(s0)
    8020b554:	2781                	sext.w	a5,a5
    8020b556:	c785                	beqz	a5,8020b57e <either_copyout+0x48>
	{
		// dst 是用户空间虚拟地址
		return copyout(myproc()->pagetable, dst, src, len);
    8020b558:	ffffa097          	auipc	ra,0xffffa
    8020b55c:	b08080e7          	jalr	-1272(ra) # 80205060 <myproc>
    8020b560:	87aa                	mv	a5,a0
    8020b562:	7fdc                	ld	a5,184(a5)
    8020b564:	fd043683          	ld	a3,-48(s0)
    8020b568:	fd843603          	ld	a2,-40(s0)
    8020b56c:	fe043583          	ld	a1,-32(s0)
    8020b570:	853e                	mv	a0,a5
    8020b572:	ffff9097          	auipc	ra,0xffff9
    8020b576:	bb0080e7          	jalr	-1104(ra) # 80204122 <copyout>
    8020b57a:	87aa                	mv	a5,a0
    8020b57c:	a829                	j	8020b596 <either_copyout+0x60>
	}
	else
	{
		// dst 是内核空间地址
		memmove((void *)dst, src, len);
    8020b57e:	fe043783          	ld	a5,-32(s0)
    8020b582:	fd043603          	ld	a2,-48(s0)
    8020b586:	fd843583          	ld	a1,-40(s0)
    8020b58a:	853e                	mv	a0,a5
    8020b58c:	ffff7097          	auipc	ra,0xffff7
    8020b590:	a08080e7          	jalr	-1528(ra) # 80201f94 <memmove>
		return 0;
    8020b594:	4781                	li	a5,0
	}
}
    8020b596:	853e                	mv	a0,a5
    8020b598:	70a2                	ld	ra,40(sp)
    8020b59a:	7402                	ld	s0,32(sp)
    8020b59c:	6145                	addi	sp,sp,48
    8020b59e:	8082                	ret

000000008020b5a0 <readi>:
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
    8020b5a0:	715d                	addi	sp,sp,-80
    8020b5a2:	e486                	sd	ra,72(sp)
    8020b5a4:	e0a2                	sd	s0,64(sp)
    8020b5a6:	0880                	addi	s0,sp,80
    8020b5a8:	fca43423          	sd	a0,-56(s0)
    8020b5ac:	87ae                	mv	a5,a1
    8020b5ae:	fac43c23          	sd	a2,-72(s0)
    8020b5b2:	fcf42223          	sw	a5,-60(s0)
    8020b5b6:	87b6                	mv	a5,a3
    8020b5b8:	fcf42023          	sw	a5,-64(s0)
    8020b5bc:	87ba                	mv	a5,a4
    8020b5be:	faf42a23          	sw	a5,-76(s0)
	uint tot, m;
	struct buf *bp;

	if (off > ip->size || off + n < off)
    8020b5c2:	fc843783          	ld	a5,-56(s0)
    8020b5c6:	4fd8                	lw	a4,28(a5)
    8020b5c8:	fc042783          	lw	a5,-64(s0)
    8020b5cc:	2781                	sext.w	a5,a5
    8020b5ce:	00f76f63          	bltu	a4,a5,8020b5ec <readi+0x4c>
    8020b5d2:	fc042783          	lw	a5,-64(s0)
    8020b5d6:	873e                	mv	a4,a5
    8020b5d8:	fb442783          	lw	a5,-76(s0)
    8020b5dc:	9fb9                	addw	a5,a5,a4
    8020b5de:	0007871b          	sext.w	a4,a5
    8020b5e2:	fc042783          	lw	a5,-64(s0)
    8020b5e6:	2781                	sext.w	a5,a5
    8020b5e8:	00f77463          	bgeu	a4,a5,8020b5f0 <readi+0x50>
		return 0;
    8020b5ec:	4781                	li	a5,0
    8020b5ee:	a299                	j	8020b734 <readi+0x194>
	if (off + n > ip->size)
    8020b5f0:	fc042783          	lw	a5,-64(s0)
    8020b5f4:	873e                	mv	a4,a5
    8020b5f6:	fb442783          	lw	a5,-76(s0)
    8020b5fa:	9fb9                	addw	a5,a5,a4
    8020b5fc:	0007871b          	sext.w	a4,a5
    8020b600:	fc843783          	ld	a5,-56(s0)
    8020b604:	4fdc                	lw	a5,28(a5)
    8020b606:	00e7fa63          	bgeu	a5,a4,8020b61a <readi+0x7a>
		n = ip->size - off;
    8020b60a:	fc843783          	ld	a5,-56(s0)
    8020b60e:	4fdc                	lw	a5,28(a5)
    8020b610:	fc042703          	lw	a4,-64(s0)
    8020b614:	9f99                	subw	a5,a5,a4
    8020b616:	faf42a23          	sw	a5,-76(s0)

	for (tot = 0; tot < n; tot += m, off += m, dst += m)
    8020b61a:	fe042623          	sw	zero,-20(s0)
    8020b61e:	a8f5                	j	8020b71a <readi+0x17a>
	{
		uint addr = bmap(ip, off / BSIZE);
    8020b620:	fc042783          	lw	a5,-64(s0)
    8020b624:	00a7d79b          	srliw	a5,a5,0xa
    8020b628:	2781                	sext.w	a5,a5
    8020b62a:	85be                	mv	a1,a5
    8020b62c:	fc843503          	ld	a0,-56(s0)
    8020b630:	00000097          	auipc	ra,0x0
    8020b634:	b84080e7          	jalr	-1148(ra) # 8020b1b4 <bmap>
    8020b638:	87aa                	mv	a5,a0
    8020b63a:	fef42423          	sw	a5,-24(s0)
		if (addr == 0)
    8020b63e:	fe842783          	lw	a5,-24(s0)
    8020b642:	2781                	sext.w	a5,a5
    8020b644:	c7ed                	beqz	a5,8020b72e <readi+0x18e>
			break;
		bp = bread(ip->dev, addr);
    8020b646:	fc843783          	ld	a5,-56(s0)
    8020b64a:	439c                	lw	a5,0(a5)
    8020b64c:	fe842703          	lw	a4,-24(s0)
    8020b650:	85ba                	mv	a1,a4
    8020b652:	853e                	mv	a0,a5
    8020b654:	ffffe097          	auipc	ra,0xffffe
    8020b658:	972080e7          	jalr	-1678(ra) # 80208fc6 <bread>
    8020b65c:	fea43023          	sd	a0,-32(s0)
		m = min(n - tot, BSIZE - off % BSIZE);
    8020b660:	fc042783          	lw	a5,-64(s0)
    8020b664:	3ff7f793          	andi	a5,a5,1023
    8020b668:	2781                	sext.w	a5,a5
    8020b66a:	40000713          	li	a4,1024
    8020b66e:	40f707bb          	subw	a5,a4,a5
    8020b672:	2781                	sext.w	a5,a5
    8020b674:	fb442703          	lw	a4,-76(s0)
    8020b678:	86ba                	mv	a3,a4
    8020b67a:	fec42703          	lw	a4,-20(s0)
    8020b67e:	40e6873b          	subw	a4,a3,a4
    8020b682:	2701                	sext.w	a4,a4
    8020b684:	863a                	mv	a2,a4
    8020b686:	0007869b          	sext.w	a3,a5
    8020b68a:	0006071b          	sext.w	a4,a2
    8020b68e:	00d77363          	bgeu	a4,a3,8020b694 <readi+0xf4>
    8020b692:	87b2                	mv	a5,a2
    8020b694:	fcf42e23          	sw	a5,-36(s0)
		if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1)
    8020b698:	fe043783          	ld	a5,-32(s0)
    8020b69c:	05078713          	addi	a4,a5,80
    8020b6a0:	fc046783          	lwu	a5,-64(s0)
    8020b6a4:	3ff7f793          	andi	a5,a5,1023
    8020b6a8:	973e                	add	a4,a4,a5
    8020b6aa:	fdc46683          	lwu	a3,-36(s0)
    8020b6ae:	fc442783          	lw	a5,-60(s0)
    8020b6b2:	863a                	mv	a2,a4
    8020b6b4:	fb843583          	ld	a1,-72(s0)
    8020b6b8:	853e                	mv	a0,a5
    8020b6ba:	00000097          	auipc	ra,0x0
    8020b6be:	e7c080e7          	jalr	-388(ra) # 8020b536 <either_copyout>
    8020b6c2:	87aa                	mv	a5,a0
    8020b6c4:	873e                	mv	a4,a5
    8020b6c6:	57fd                	li	a5,-1
    8020b6c8:	00f71c63          	bne	a4,a5,8020b6e0 <readi+0x140>
		{
			brelse(bp);
    8020b6cc:	fe043503          	ld	a0,-32(s0)
    8020b6d0:	ffffe097          	auipc	ra,0xffffe
    8020b6d4:	998080e7          	jalr	-1640(ra) # 80209068 <brelse>
			tot = -1;
    8020b6d8:	57fd                	li	a5,-1
    8020b6da:	fef42623          	sw	a5,-20(s0)
			break;
    8020b6de:	a889                	j	8020b730 <readi+0x190>
		}
		brelse(bp);
    8020b6e0:	fe043503          	ld	a0,-32(s0)
    8020b6e4:	ffffe097          	auipc	ra,0xffffe
    8020b6e8:	984080e7          	jalr	-1660(ra) # 80209068 <brelse>
	for (tot = 0; tot < n; tot += m, off += m, dst += m)
    8020b6ec:	fec42783          	lw	a5,-20(s0)
    8020b6f0:	873e                	mv	a4,a5
    8020b6f2:	fdc42783          	lw	a5,-36(s0)
    8020b6f6:	9fb9                	addw	a5,a5,a4
    8020b6f8:	fef42623          	sw	a5,-20(s0)
    8020b6fc:	fc042783          	lw	a5,-64(s0)
    8020b700:	873e                	mv	a4,a5
    8020b702:	fdc42783          	lw	a5,-36(s0)
    8020b706:	9fb9                	addw	a5,a5,a4
    8020b708:	fcf42023          	sw	a5,-64(s0)
    8020b70c:	fdc46783          	lwu	a5,-36(s0)
    8020b710:	fb843703          	ld	a4,-72(s0)
    8020b714:	97ba                	add	a5,a5,a4
    8020b716:	faf43c23          	sd	a5,-72(s0)
    8020b71a:	fec42783          	lw	a5,-20(s0)
    8020b71e:	873e                	mv	a4,a5
    8020b720:	fb442783          	lw	a5,-76(s0)
    8020b724:	2701                	sext.w	a4,a4
    8020b726:	2781                	sext.w	a5,a5
    8020b728:	eef76ce3          	bltu	a4,a5,8020b620 <readi+0x80>
    8020b72c:	a011                	j	8020b730 <readi+0x190>
			break;
    8020b72e:	0001                	nop
	}
	return tot;
    8020b730:	fec42783          	lw	a5,-20(s0)
}
    8020b734:	853e                	mv	a0,a5
    8020b736:	60a6                	ld	ra,72(sp)
    8020b738:	6406                	ld	s0,64(sp)
    8020b73a:	6161                	addi	sp,sp,80
    8020b73c:	8082                	ret

000000008020b73e <writei>:

int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
    8020b73e:	715d                	addi	sp,sp,-80
    8020b740:	e486                	sd	ra,72(sp)
    8020b742:	e0a2                	sd	s0,64(sp)
    8020b744:	0880                	addi	s0,sp,80
    8020b746:	fca43423          	sd	a0,-56(s0)
    8020b74a:	87ae                	mv	a5,a1
    8020b74c:	fac43c23          	sd	a2,-72(s0)
    8020b750:	fcf42223          	sw	a5,-60(s0)
    8020b754:	87b6                	mv	a5,a3
    8020b756:	fcf42023          	sw	a5,-64(s0)
    8020b75a:	87ba                	mv	a5,a4
    8020b75c:	faf42a23          	sw	a5,-76(s0)
	uint tot, m;
	struct buf *bp;

	if (off > ip->size || off + n < off)
    8020b760:	fc843783          	ld	a5,-56(s0)
    8020b764:	4fd8                	lw	a4,28(a5)
    8020b766:	fc042783          	lw	a5,-64(s0)
    8020b76a:	2781                	sext.w	a5,a5
    8020b76c:	00f76f63          	bltu	a4,a5,8020b78a <writei+0x4c>
    8020b770:	fc042783          	lw	a5,-64(s0)
    8020b774:	873e                	mv	a4,a5
    8020b776:	fb442783          	lw	a5,-76(s0)
    8020b77a:	9fb9                	addw	a5,a5,a4
    8020b77c:	0007871b          	sext.w	a4,a5
    8020b780:	fc042783          	lw	a5,-64(s0)
    8020b784:	2781                	sext.w	a5,a5
    8020b786:	00f77463          	bgeu	a4,a5,8020b78e <writei+0x50>
		return -1;
    8020b78a:	57fd                	li	a5,-1
    8020b78c:	a295                	j	8020b8f0 <writei+0x1b2>
	if (off + n > MAXFILE * BSIZE)
    8020b78e:	fc042783          	lw	a5,-64(s0)
    8020b792:	873e                	mv	a4,a5
    8020b794:	fb442783          	lw	a5,-76(s0)
    8020b798:	9fb9                	addw	a5,a5,a4
    8020b79a:	2781                	sext.w	a5,a5
    8020b79c:	873e                	mv	a4,a5
    8020b79e:	000437b7          	lui	a5,0x43
    8020b7a2:	00e7f463          	bgeu	a5,a4,8020b7aa <writei+0x6c>
		return -1;
    8020b7a6:	57fd                	li	a5,-1
    8020b7a8:	a2a1                	j	8020b8f0 <writei+0x1b2>

	for (tot = 0; tot < n; tot += m, off += m, src += m)
    8020b7aa:	fe042623          	sw	zero,-20(s0)
    8020b7ae:	a209                	j	8020b8b0 <writei+0x172>
	{
		uint addr = bmap(ip, off / BSIZE);
    8020b7b0:	fc042783          	lw	a5,-64(s0)
    8020b7b4:	00a7d79b          	srliw	a5,a5,0xa
    8020b7b8:	2781                	sext.w	a5,a5
    8020b7ba:	85be                	mv	a1,a5
    8020b7bc:	fc843503          	ld	a0,-56(s0)
    8020b7c0:	00000097          	auipc	ra,0x0
    8020b7c4:	9f4080e7          	jalr	-1548(ra) # 8020b1b4 <bmap>
    8020b7c8:	87aa                	mv	a5,a0
    8020b7ca:	fef42423          	sw	a5,-24(s0)
		if (addr == 0)
    8020b7ce:	fe842783          	lw	a5,-24(s0)
    8020b7d2:	2781                	sext.w	a5,a5
    8020b7d4:	cbe5                	beqz	a5,8020b8c4 <writei+0x186>
			break;
		bp = bread(ip->dev, addr);
    8020b7d6:	fc843783          	ld	a5,-56(s0)
    8020b7da:	439c                	lw	a5,0(a5)
    8020b7dc:	fe842703          	lw	a4,-24(s0)
    8020b7e0:	85ba                	mv	a1,a4
    8020b7e2:	853e                	mv	a0,a5
    8020b7e4:	ffffd097          	auipc	ra,0xffffd
    8020b7e8:	7e2080e7          	jalr	2018(ra) # 80208fc6 <bread>
    8020b7ec:	fea43023          	sd	a0,-32(s0)
		m = min(n - tot, BSIZE - off % BSIZE);
    8020b7f0:	fc042783          	lw	a5,-64(s0)
    8020b7f4:	3ff7f793          	andi	a5,a5,1023
    8020b7f8:	2781                	sext.w	a5,a5
    8020b7fa:	40000713          	li	a4,1024
    8020b7fe:	40f707bb          	subw	a5,a4,a5
    8020b802:	2781                	sext.w	a5,a5
    8020b804:	fb442703          	lw	a4,-76(s0)
    8020b808:	86ba                	mv	a3,a4
    8020b80a:	fec42703          	lw	a4,-20(s0)
    8020b80e:	40e6873b          	subw	a4,a3,a4
    8020b812:	2701                	sext.w	a4,a4
    8020b814:	863a                	mv	a2,a4
    8020b816:	0007869b          	sext.w	a3,a5
    8020b81a:	0006071b          	sext.w	a4,a2
    8020b81e:	00d77363          	bgeu	a4,a3,8020b824 <writei+0xe6>
    8020b822:	87b2                	mv	a5,a2
    8020b824:	fcf42e23          	sw	a5,-36(s0)
		if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1)
    8020b828:	fe043783          	ld	a5,-32(s0)
    8020b82c:	05078713          	addi	a4,a5,80 # 43050 <_entry-0x801bcfb0>
    8020b830:	fc046783          	lwu	a5,-64(s0)
    8020b834:	3ff7f793          	andi	a5,a5,1023
    8020b838:	97ba                	add	a5,a5,a4
    8020b83a:	fdc46683          	lwu	a3,-36(s0)
    8020b83e:	fc442703          	lw	a4,-60(s0)
    8020b842:	fb843603          	ld	a2,-72(s0)
    8020b846:	85ba                	mv	a1,a4
    8020b848:	853e                	mv	a0,a5
    8020b84a:	00000097          	auipc	ra,0x0
    8020b84e:	c8c080e7          	jalr	-884(ra) # 8020b4d6 <either_copyin>
    8020b852:	87aa                	mv	a5,a0
    8020b854:	873e                	mv	a4,a5
    8020b856:	57fd                	li	a5,-1
    8020b858:	00f71963          	bne	a4,a5,8020b86a <writei+0x12c>
		{
			brelse(bp);
    8020b85c:	fe043503          	ld	a0,-32(s0)
    8020b860:	ffffe097          	auipc	ra,0xffffe
    8020b864:	808080e7          	jalr	-2040(ra) # 80209068 <brelse>
			break;
    8020b868:	a8b9                	j	8020b8c6 <writei+0x188>
		}
		log_write(bp);
    8020b86a:	fe043503          	ld	a0,-32(s0)
    8020b86e:	ffffe097          	auipc	ra,0xffffe
    8020b872:	08e080e7          	jalr	142(ra) # 802098fc <log_write>
		brelse(bp);
    8020b876:	fe043503          	ld	a0,-32(s0)
    8020b87a:	ffffd097          	auipc	ra,0xffffd
    8020b87e:	7ee080e7          	jalr	2030(ra) # 80209068 <brelse>
	for (tot = 0; tot < n; tot += m, off += m, src += m)
    8020b882:	fec42783          	lw	a5,-20(s0)
    8020b886:	873e                	mv	a4,a5
    8020b888:	fdc42783          	lw	a5,-36(s0)
    8020b88c:	9fb9                	addw	a5,a5,a4
    8020b88e:	fef42623          	sw	a5,-20(s0)
    8020b892:	fc042783          	lw	a5,-64(s0)
    8020b896:	873e                	mv	a4,a5
    8020b898:	fdc42783          	lw	a5,-36(s0)
    8020b89c:	9fb9                	addw	a5,a5,a4
    8020b89e:	fcf42023          	sw	a5,-64(s0)
    8020b8a2:	fdc46783          	lwu	a5,-36(s0)
    8020b8a6:	fb843703          	ld	a4,-72(s0)
    8020b8aa:	97ba                	add	a5,a5,a4
    8020b8ac:	faf43c23          	sd	a5,-72(s0)
    8020b8b0:	fec42783          	lw	a5,-20(s0)
    8020b8b4:	873e                	mv	a4,a5
    8020b8b6:	fb442783          	lw	a5,-76(s0)
    8020b8ba:	2701                	sext.w	a4,a4
    8020b8bc:	2781                	sext.w	a5,a5
    8020b8be:	eef769e3          	bltu	a4,a5,8020b7b0 <writei+0x72>
    8020b8c2:	a011                	j	8020b8c6 <writei+0x188>
			break;
    8020b8c4:	0001                	nop
	}

	if (off > ip->size)
    8020b8c6:	fc843783          	ld	a5,-56(s0)
    8020b8ca:	4fd8                	lw	a4,28(a5)
    8020b8cc:	fc042783          	lw	a5,-64(s0)
    8020b8d0:	2781                	sext.w	a5,a5
    8020b8d2:	00f77763          	bgeu	a4,a5,8020b8e0 <writei+0x1a2>
		ip->size = off;
    8020b8d6:	fc843783          	ld	a5,-56(s0)
    8020b8da:	fc042703          	lw	a4,-64(s0)
    8020b8de:	cfd8                	sw	a4,28(a5)

	iupdate(ip);
    8020b8e0:	fc843503          	ld	a0,-56(s0)
    8020b8e4:	fffff097          	auipc	ra,0xfffff
    8020b8e8:	2c2080e7          	jalr	706(ra) # 8020aba6 <iupdate>
	return tot;
    8020b8ec:	fec42783          	lw	a5,-20(s0)
}
    8020b8f0:	853e                	mv	a0,a5
    8020b8f2:	60a6                	ld	ra,72(sp)
    8020b8f4:	6406                	ld	s0,64(sp)
    8020b8f6:	6161                	addi	sp,sp,80
    8020b8f8:	8082                	ret

000000008020b8fa <namecmp>:

int namecmp(const char *s, const char *t)
{
    8020b8fa:	1101                	addi	sp,sp,-32
    8020b8fc:	ec06                	sd	ra,24(sp)
    8020b8fe:	e822                	sd	s0,16(sp)
    8020b900:	1000                	addi	s0,sp,32
    8020b902:	fea43423          	sd	a0,-24(s0)
    8020b906:	feb43023          	sd	a1,-32(s0)
	return strncmp(s, t, DIRSIZ);
    8020b90a:	4639                	li	a2,14
    8020b90c:	fe043583          	ld	a1,-32(s0)
    8020b910:	fe843503          	ld	a0,-24(s0)
    8020b914:	ffffb097          	auipc	ra,0xffffb
    8020b918:	cf0080e7          	jalr	-784(ra) # 80206604 <strncmp>
    8020b91c:	87aa                	mv	a5,a0
}
    8020b91e:	853e                	mv	a0,a5
    8020b920:	60e2                	ld	ra,24(sp)
    8020b922:	6442                	ld	s0,16(sp)
    8020b924:	6105                	addi	sp,sp,32
    8020b926:	8082                	ret

000000008020b928 <dirlookup>:
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8020b928:	715d                	addi	sp,sp,-80
    8020b92a:	e486                	sd	ra,72(sp)
    8020b92c:	e0a2                	sd	s0,64(sp)
    8020b92e:	0880                	addi	s0,sp,80
    8020b930:	fca43423          	sd	a0,-56(s0)
    8020b934:	fcb43023          	sd	a1,-64(s0)
    8020b938:	fac43c23          	sd	a2,-72(s0)
	uint off, inum;
	struct dirent de;

	if (dp->type != T_DIR)
    8020b93c:	fc843783          	ld	a5,-56(s0)
    8020b940:	01479783          	lh	a5,20(a5)
    8020b944:	873e                	mv	a4,a5
    8020b946:	4785                	li	a5,1
    8020b948:	00f70a63          	beq	a4,a5,8020b95c <dirlookup+0x34>
		panic("dirlookup not DIR");
    8020b94c:	0002c517          	auipc	a0,0x2c
    8020b950:	f6c50513          	addi	a0,a0,-148 # 802378b8 <user_test_table+0x188>
    8020b954:	ffff6097          	auipc	ra,0xffff6
    8020b958:	eb2080e7          	jalr	-334(ra) # 80201806 <panic>

	for (off = 0; off < dp->size; off += sizeof(de))
    8020b95c:	fe042623          	sw	zero,-20(s0)
    8020b960:	a849                	j	8020b9f2 <dirlookup+0xca>
	{
		if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8020b962:	fd840793          	addi	a5,s0,-40
    8020b966:	fec42683          	lw	a3,-20(s0)
    8020b96a:	4741                	li	a4,16
    8020b96c:	863e                	mv	a2,a5
    8020b96e:	4581                	li	a1,0
    8020b970:	fc843503          	ld	a0,-56(s0)
    8020b974:	00000097          	auipc	ra,0x0
    8020b978:	c2c080e7          	jalr	-980(ra) # 8020b5a0 <readi>
    8020b97c:	87aa                	mv	a5,a0
    8020b97e:	873e                	mv	a4,a5
    8020b980:	47c1                	li	a5,16
    8020b982:	00f70a63          	beq	a4,a5,8020b996 <dirlookup+0x6e>
			panic("dirlookup read");
    8020b986:	0002c517          	auipc	a0,0x2c
    8020b98a:	f4a50513          	addi	a0,a0,-182 # 802378d0 <user_test_table+0x1a0>
    8020b98e:	ffff6097          	auipc	ra,0xffff6
    8020b992:	e78080e7          	jalr	-392(ra) # 80201806 <panic>
		if (de.inum == 0)
    8020b996:	fd845783          	lhu	a5,-40(s0)
    8020b99a:	c7b1                	beqz	a5,8020b9e6 <dirlookup+0xbe>
			continue;
		if (namecmp(name, de.name) == 0)
    8020b99c:	fd840793          	addi	a5,s0,-40
    8020b9a0:	0789                	addi	a5,a5,2
    8020b9a2:	85be                	mv	a1,a5
    8020b9a4:	fc043503          	ld	a0,-64(s0)
    8020b9a8:	00000097          	auipc	ra,0x0
    8020b9ac:	f52080e7          	jalr	-174(ra) # 8020b8fa <namecmp>
    8020b9b0:	87aa                	mv	a5,a0
    8020b9b2:	eb9d                	bnez	a5,8020b9e8 <dirlookup+0xc0>
		{
			// entry matches path element
			if (poff)
    8020b9b4:	fb843783          	ld	a5,-72(s0)
    8020b9b8:	c791                	beqz	a5,8020b9c4 <dirlookup+0x9c>
				*poff = off;
    8020b9ba:	fb843783          	ld	a5,-72(s0)
    8020b9be:	fec42703          	lw	a4,-20(s0)
    8020b9c2:	c398                	sw	a4,0(a5)
			inum = de.inum;
    8020b9c4:	fd845783          	lhu	a5,-40(s0)
    8020b9c8:	fef42423          	sw	a5,-24(s0)
			return iget(dp->dev, inum);
    8020b9cc:	fc843783          	ld	a5,-56(s0)
    8020b9d0:	439c                	lw	a5,0(a5)
    8020b9d2:	fe842703          	lw	a4,-24(s0)
    8020b9d6:	85ba                	mv	a1,a4
    8020b9d8:	853e                	mv	a0,a5
    8020b9da:	fffff097          	auipc	ra,0xfffff
    8020b9de:	2b4080e7          	jalr	692(ra) # 8020ac8e <iget>
    8020b9e2:	87aa                	mv	a5,a0
    8020b9e4:	a005                	j	8020ba04 <dirlookup+0xdc>
			continue;
    8020b9e6:	0001                	nop
	for (off = 0; off < dp->size; off += sizeof(de))
    8020b9e8:	fec42783          	lw	a5,-20(s0)
    8020b9ec:	27c1                	addiw	a5,a5,16
    8020b9ee:	fef42623          	sw	a5,-20(s0)
    8020b9f2:	fc843783          	ld	a5,-56(s0)
    8020b9f6:	4fd8                	lw	a4,28(a5)
    8020b9f8:	fec42783          	lw	a5,-20(s0)
    8020b9fc:	2781                	sext.w	a5,a5
    8020b9fe:	f6e7e2e3          	bltu	a5,a4,8020b962 <dirlookup+0x3a>
		}
	}

	return 0;
    8020ba02:	4781                	li	a5,0
}
    8020ba04:	853e                	mv	a0,a5
    8020ba06:	60a6                	ld	ra,72(sp)
    8020ba08:	6406                	ld	s0,64(sp)
    8020ba0a:	6161                	addi	sp,sp,80
    8020ba0c:	8082                	ret

000000008020ba0e <dirlink>:
int dirlink(struct inode *dp, char *name, uint inum)
{
    8020ba0e:	715d                	addi	sp,sp,-80
    8020ba10:	e486                	sd	ra,72(sp)
    8020ba12:	e0a2                	sd	s0,64(sp)
    8020ba14:	0880                	addi	s0,sp,80
    8020ba16:	fca43423          	sd	a0,-56(s0)
    8020ba1a:	fcb43023          	sd	a1,-64(s0)
    8020ba1e:	87b2                	mv	a5,a2
    8020ba20:	faf42e23          	sw	a5,-68(s0)
	int off;
	struct dirent de;
	struct inode *ip;

	// Check that name is not present.
	if ((ip = dirlookup(dp, name, 0)) != 0)
    8020ba24:	4601                	li	a2,0
    8020ba26:	fc043583          	ld	a1,-64(s0)
    8020ba2a:	fc843503          	ld	a0,-56(s0)
    8020ba2e:	00000097          	auipc	ra,0x0
    8020ba32:	efa080e7          	jalr	-262(ra) # 8020b928 <dirlookup>
    8020ba36:	fea43023          	sd	a0,-32(s0)
    8020ba3a:	fe043783          	ld	a5,-32(s0)
    8020ba3e:	cb89                	beqz	a5,8020ba50 <dirlink+0x42>
	{
		iput(ip);
    8020ba40:	fe043503          	ld	a0,-32(s0)
    8020ba44:	fffff097          	auipc	ra,0xfffff
    8020ba48:	546080e7          	jalr	1350(ra) # 8020af8a <iput>
		return -1;
    8020ba4c:	57fd                	li	a5,-1
    8020ba4e:	a075                	j	8020bafa <dirlink+0xec>
	}

	// Look for an empty dirent.
	for (off = 0; off < dp->size; off += sizeof(de))
    8020ba50:	fe042623          	sw	zero,-20(s0)
    8020ba54:	a0a1                	j	8020ba9c <dirlink+0x8e>
	{
		if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8020ba56:	fd040793          	addi	a5,s0,-48
    8020ba5a:	fec42683          	lw	a3,-20(s0)
    8020ba5e:	4741                	li	a4,16
    8020ba60:	863e                	mv	a2,a5
    8020ba62:	4581                	li	a1,0
    8020ba64:	fc843503          	ld	a0,-56(s0)
    8020ba68:	00000097          	auipc	ra,0x0
    8020ba6c:	b38080e7          	jalr	-1224(ra) # 8020b5a0 <readi>
    8020ba70:	87aa                	mv	a5,a0
    8020ba72:	873e                	mv	a4,a5
    8020ba74:	47c1                	li	a5,16
    8020ba76:	00f70a63          	beq	a4,a5,8020ba8a <dirlink+0x7c>
			panic("dirlink read");
    8020ba7a:	0002c517          	auipc	a0,0x2c
    8020ba7e:	e6650513          	addi	a0,a0,-410 # 802378e0 <user_test_table+0x1b0>
    8020ba82:	ffff6097          	auipc	ra,0xffff6
    8020ba86:	d84080e7          	jalr	-636(ra) # 80201806 <panic>
		if (de.inum == 0)
    8020ba8a:	fd045783          	lhu	a5,-48(s0)
    8020ba8e:	cf99                	beqz	a5,8020baac <dirlink+0x9e>
	for (off = 0; off < dp->size; off += sizeof(de))
    8020ba90:	fec42783          	lw	a5,-20(s0)
    8020ba94:	27c1                	addiw	a5,a5,16
    8020ba96:	2781                	sext.w	a5,a5
    8020ba98:	fef42623          	sw	a5,-20(s0)
    8020ba9c:	fc843783          	ld	a5,-56(s0)
    8020baa0:	4fd8                	lw	a4,28(a5)
    8020baa2:	fec42783          	lw	a5,-20(s0)
    8020baa6:	fae7e8e3          	bltu	a5,a4,8020ba56 <dirlink+0x48>
    8020baaa:	a011                	j	8020baae <dirlink+0xa0>
			break;
    8020baac:	0001                	nop
	}

	strncpy(de.name, name, DIRSIZ);
    8020baae:	fd040793          	addi	a5,s0,-48
    8020bab2:	0789                	addi	a5,a5,2
    8020bab4:	4639                	li	a2,14
    8020bab6:	fc043583          	ld	a1,-64(s0)
    8020baba:	853e                	mv	a0,a5
    8020babc:	ffffb097          	auipc	ra,0xffffb
    8020bac0:	bfc080e7          	jalr	-1028(ra) # 802066b8 <strncpy>
	de.inum = inum;
    8020bac4:	fbc42783          	lw	a5,-68(s0)
    8020bac8:	17c2                	slli	a5,a5,0x30
    8020baca:	93c1                	srli	a5,a5,0x30
    8020bacc:	fcf41823          	sh	a5,-48(s0)
	if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8020bad0:	fd040793          	addi	a5,s0,-48
    8020bad4:	fec42683          	lw	a3,-20(s0)
    8020bad8:	4741                	li	a4,16
    8020bada:	863e                	mv	a2,a5
    8020badc:	4581                	li	a1,0
    8020bade:	fc843503          	ld	a0,-56(s0)
    8020bae2:	00000097          	auipc	ra,0x0
    8020bae6:	c5c080e7          	jalr	-932(ra) # 8020b73e <writei>
    8020baea:	87aa                	mv	a5,a0
    8020baec:	873e                	mv	a4,a5
    8020baee:	47c1                	li	a5,16
    8020baf0:	00f70463          	beq	a4,a5,8020baf8 <dirlink+0xea>
		return -1;
    8020baf4:	57fd                	li	a5,-1
    8020baf6:	a011                	j	8020bafa <dirlink+0xec>
	return 0;
    8020baf8:	4781                	li	a5,0
}
    8020bafa:	853e                	mv	a0,a5
    8020bafc:	60a6                	ld	ra,72(sp)
    8020bafe:	6406                	ld	s0,64(sp)
    8020bb00:	6161                	addi	sp,sp,80
    8020bb02:	8082                	ret

000000008020bb04 <skipelem>:

static char *
skipelem(char *path, char *name)
{
    8020bb04:	7179                	addi	sp,sp,-48
    8020bb06:	f406                	sd	ra,40(sp)
    8020bb08:	f022                	sd	s0,32(sp)
    8020bb0a:	1800                	addi	s0,sp,48
    8020bb0c:	fca43c23          	sd	a0,-40(s0)
    8020bb10:	fcb43823          	sd	a1,-48(s0)
	char *s;
	int len;

	while (*path == '/')
    8020bb14:	a031                	j	8020bb20 <skipelem+0x1c>
		path++;
    8020bb16:	fd843783          	ld	a5,-40(s0)
    8020bb1a:	0785                	addi	a5,a5,1
    8020bb1c:	fcf43c23          	sd	a5,-40(s0)
	while (*path == '/')
    8020bb20:	fd843783          	ld	a5,-40(s0)
    8020bb24:	0007c783          	lbu	a5,0(a5)
    8020bb28:	873e                	mv	a4,a5
    8020bb2a:	02f00793          	li	a5,47
    8020bb2e:	fef704e3          	beq	a4,a5,8020bb16 <skipelem+0x12>
	if (*path == 0)
    8020bb32:	fd843783          	ld	a5,-40(s0)
    8020bb36:	0007c783          	lbu	a5,0(a5)
    8020bb3a:	e399                	bnez	a5,8020bb40 <skipelem+0x3c>
		return 0;
    8020bb3c:	4781                	li	a5,0
    8020bb3e:	a06d                	j	8020bbe8 <skipelem+0xe4>
	s = path;
    8020bb40:	fd843783          	ld	a5,-40(s0)
    8020bb44:	fef43423          	sd	a5,-24(s0)
	while (*path != '/' && *path != 0)
    8020bb48:	a031                	j	8020bb54 <skipelem+0x50>
		path++;
    8020bb4a:	fd843783          	ld	a5,-40(s0)
    8020bb4e:	0785                	addi	a5,a5,1
    8020bb50:	fcf43c23          	sd	a5,-40(s0)
	while (*path != '/' && *path != 0)
    8020bb54:	fd843783          	ld	a5,-40(s0)
    8020bb58:	0007c783          	lbu	a5,0(a5)
    8020bb5c:	873e                	mv	a4,a5
    8020bb5e:	02f00793          	li	a5,47
    8020bb62:	00f70763          	beq	a4,a5,8020bb70 <skipelem+0x6c>
    8020bb66:	fd843783          	ld	a5,-40(s0)
    8020bb6a:	0007c783          	lbu	a5,0(a5)
    8020bb6e:	fff1                	bnez	a5,8020bb4a <skipelem+0x46>
	len = path - s;
    8020bb70:	fd843703          	ld	a4,-40(s0)
    8020bb74:	fe843783          	ld	a5,-24(s0)
    8020bb78:	40f707b3          	sub	a5,a4,a5
    8020bb7c:	fef42223          	sw	a5,-28(s0)
	if (len >= DIRSIZ)
    8020bb80:	fe442783          	lw	a5,-28(s0)
    8020bb84:	0007871b          	sext.w	a4,a5
    8020bb88:	47b5                	li	a5,13
    8020bb8a:	00e7dc63          	bge	a5,a4,8020bba2 <skipelem+0x9e>
		memmove(name, s, DIRSIZ);
    8020bb8e:	4639                	li	a2,14
    8020bb90:	fe843583          	ld	a1,-24(s0)
    8020bb94:	fd043503          	ld	a0,-48(s0)
    8020bb98:	ffff6097          	auipc	ra,0xffff6
    8020bb9c:	3fc080e7          	jalr	1020(ra) # 80201f94 <memmove>
    8020bba0:	a80d                	j	8020bbd2 <skipelem+0xce>
	else
	{
		memmove(name, s, len);
    8020bba2:	fe442783          	lw	a5,-28(s0)
    8020bba6:	863e                	mv	a2,a5
    8020bba8:	fe843583          	ld	a1,-24(s0)
    8020bbac:	fd043503          	ld	a0,-48(s0)
    8020bbb0:	ffff6097          	auipc	ra,0xffff6
    8020bbb4:	3e4080e7          	jalr	996(ra) # 80201f94 <memmove>
		name[len] = 0;
    8020bbb8:	fe442783          	lw	a5,-28(s0)
    8020bbbc:	fd043703          	ld	a4,-48(s0)
    8020bbc0:	97ba                	add	a5,a5,a4
    8020bbc2:	00078023          	sb	zero,0(a5)
	}
	while (*path == '/')
    8020bbc6:	a031                	j	8020bbd2 <skipelem+0xce>
		path++;
    8020bbc8:	fd843783          	ld	a5,-40(s0)
    8020bbcc:	0785                	addi	a5,a5,1
    8020bbce:	fcf43c23          	sd	a5,-40(s0)
	while (*path == '/')
    8020bbd2:	fd843783          	ld	a5,-40(s0)
    8020bbd6:	0007c783          	lbu	a5,0(a5)
    8020bbda:	873e                	mv	a4,a5
    8020bbdc:	02f00793          	li	a5,47
    8020bbe0:	fef704e3          	beq	a4,a5,8020bbc8 <skipelem+0xc4>
	return path;
    8020bbe4:	fd843783          	ld	a5,-40(s0)
}
    8020bbe8:	853e                	mv	a0,a5
    8020bbea:	70a2                	ld	ra,40(sp)
    8020bbec:	7402                	ld	s0,32(sp)
    8020bbee:	6145                	addi	sp,sp,48
    8020bbf0:	8082                	ret

000000008020bbf2 <namex>:
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    8020bbf2:	7139                	addi	sp,sp,-64
    8020bbf4:	fc06                	sd	ra,56(sp)
    8020bbf6:	f822                	sd	s0,48(sp)
    8020bbf8:	0080                	addi	s0,sp,64
    8020bbfa:	fca43c23          	sd	a0,-40(s0)
    8020bbfe:	87ae                	mv	a5,a1
    8020bc00:	fcc43423          	sd	a2,-56(s0)
    8020bc04:	fcf42a23          	sw	a5,-44(s0)
	struct inode *ip, *next;

	if (*path == '/')
    8020bc08:	fd843783          	ld	a5,-40(s0)
    8020bc0c:	0007c783          	lbu	a5,0(a5)
    8020bc10:	873e                	mv	a4,a5
    8020bc12:	02f00793          	li	a5,47
    8020bc16:	00f71b63          	bne	a4,a5,8020bc2c <namex+0x3a>
		ip = iget(ROOTDEV, ROOTINO);
    8020bc1a:	4585                	li	a1,1
    8020bc1c:	4505                	li	a0,1
    8020bc1e:	fffff097          	auipc	ra,0xfffff
    8020bc22:	070080e7          	jalr	112(ra) # 8020ac8e <iget>
    8020bc26:	fea43423          	sd	a0,-24(s0)
    8020bc2a:	a07d                	j	8020bcd8 <namex+0xe6>
	else
		ip = idup(myproc()->cwd);
    8020bc2c:	ffff9097          	auipc	ra,0xffff9
    8020bc30:	434080e7          	jalr	1076(ra) # 80205060 <myproc>
    8020bc34:	87aa                	mv	a5,a0
    8020bc36:	67fc                	ld	a5,200(a5)
    8020bc38:	853e                	mv	a0,a5
    8020bc3a:	fffff097          	auipc	ra,0xfffff
    8020bc3e:	170080e7          	jalr	368(ra) # 8020adaa <idup>
    8020bc42:	fea43423          	sd	a0,-24(s0)

	while ((path = skipelem(path, name)) != 0)
    8020bc46:	a849                	j	8020bcd8 <namex+0xe6>
	{
		ilock(ip);
    8020bc48:	fe843503          	ld	a0,-24(s0)
    8020bc4c:	fffff097          	auipc	ra,0xfffff
    8020bc50:	1aa080e7          	jalr	426(ra) # 8020adf6 <ilock>
		if (ip->type != T_DIR)
    8020bc54:	fe843783          	ld	a5,-24(s0)
    8020bc58:	01479783          	lh	a5,20(a5)
    8020bc5c:	873e                	mv	a4,a5
    8020bc5e:	4785                	li	a5,1
    8020bc60:	00f70a63          	beq	a4,a5,8020bc74 <namex+0x82>
		{
			iunlockput(ip);
    8020bc64:	fe843503          	ld	a0,-24(s0)
    8020bc68:	fffff097          	auipc	ra,0xfffff
    8020bc6c:	3f6080e7          	jalr	1014(ra) # 8020b05e <iunlockput>
			return 0;
    8020bc70:	4781                	li	a5,0
    8020bc72:	a871                	j	8020bd0e <namex+0x11c>
		}
		if (nameiparent && *path == '\0')
    8020bc74:	fd442783          	lw	a5,-44(s0)
    8020bc78:	2781                	sext.w	a5,a5
    8020bc7a:	cf99                	beqz	a5,8020bc98 <namex+0xa6>
    8020bc7c:	fd843783          	ld	a5,-40(s0)
    8020bc80:	0007c783          	lbu	a5,0(a5)
    8020bc84:	eb91                	bnez	a5,8020bc98 <namex+0xa6>
		{
			// Stop one level early.
			iunlock(ip);
    8020bc86:	fe843503          	ld	a0,-24(s0)
    8020bc8a:	fffff097          	auipc	ra,0xfffff
    8020bc8e:	2a2080e7          	jalr	674(ra) # 8020af2c <iunlock>
			return ip;
    8020bc92:	fe843783          	ld	a5,-24(s0)
    8020bc96:	a8a5                	j	8020bd0e <namex+0x11c>
		}
		if ((next = dirlookup(ip, name, 0)) == 0)
    8020bc98:	4601                	li	a2,0
    8020bc9a:	fc843583          	ld	a1,-56(s0)
    8020bc9e:	fe843503          	ld	a0,-24(s0)
    8020bca2:	00000097          	auipc	ra,0x0
    8020bca6:	c86080e7          	jalr	-890(ra) # 8020b928 <dirlookup>
    8020bcaa:	fea43023          	sd	a0,-32(s0)
    8020bcae:	fe043783          	ld	a5,-32(s0)
    8020bcb2:	eb89                	bnez	a5,8020bcc4 <namex+0xd2>
		{
			iunlockput(ip);
    8020bcb4:	fe843503          	ld	a0,-24(s0)
    8020bcb8:	fffff097          	auipc	ra,0xfffff
    8020bcbc:	3a6080e7          	jalr	934(ra) # 8020b05e <iunlockput>
			return 0;
    8020bcc0:	4781                	li	a5,0
    8020bcc2:	a0b1                	j	8020bd0e <namex+0x11c>
		}
		iunlockput(ip);
    8020bcc4:	fe843503          	ld	a0,-24(s0)
    8020bcc8:	fffff097          	auipc	ra,0xfffff
    8020bccc:	396080e7          	jalr	918(ra) # 8020b05e <iunlockput>
		ip = next;
    8020bcd0:	fe043783          	ld	a5,-32(s0)
    8020bcd4:	fef43423          	sd	a5,-24(s0)
	while ((path = skipelem(path, name)) != 0)
    8020bcd8:	fc843583          	ld	a1,-56(s0)
    8020bcdc:	fd843503          	ld	a0,-40(s0)
    8020bce0:	00000097          	auipc	ra,0x0
    8020bce4:	e24080e7          	jalr	-476(ra) # 8020bb04 <skipelem>
    8020bce8:	fca43c23          	sd	a0,-40(s0)
    8020bcec:	fd843783          	ld	a5,-40(s0)
    8020bcf0:	ffa1                	bnez	a5,8020bc48 <namex+0x56>
	}
	if (nameiparent)
    8020bcf2:	fd442783          	lw	a5,-44(s0)
    8020bcf6:	2781                	sext.w	a5,a5
    8020bcf8:	cb89                	beqz	a5,8020bd0a <namex+0x118>
	{
		iput(ip);
    8020bcfa:	fe843503          	ld	a0,-24(s0)
    8020bcfe:	fffff097          	auipc	ra,0xfffff
    8020bd02:	28c080e7          	jalr	652(ra) # 8020af8a <iput>
		return 0;
    8020bd06:	4781                	li	a5,0
    8020bd08:	a019                	j	8020bd0e <namex+0x11c>
	}
	return ip;
    8020bd0a:	fe843783          	ld	a5,-24(s0)
}
    8020bd0e:	853e                	mv	a0,a5
    8020bd10:	70e2                	ld	ra,56(sp)
    8020bd12:	7442                	ld	s0,48(sp)
    8020bd14:	6121                	addi	sp,sp,64
    8020bd16:	8082                	ret

000000008020bd18 <namei>:

struct inode *
namei(char *path)
{
    8020bd18:	7179                	addi	sp,sp,-48
    8020bd1a:	f406                	sd	ra,40(sp)
    8020bd1c:	f022                	sd	s0,32(sp)
    8020bd1e:	1800                	addi	s0,sp,48
    8020bd20:	fca43c23          	sd	a0,-40(s0)
	char name[DIRSIZ];
	return namex(path, 0, name);
    8020bd24:	fe040793          	addi	a5,s0,-32
    8020bd28:	863e                	mv	a2,a5
    8020bd2a:	4581                	li	a1,0
    8020bd2c:	fd843503          	ld	a0,-40(s0)
    8020bd30:	00000097          	auipc	ra,0x0
    8020bd34:	ec2080e7          	jalr	-318(ra) # 8020bbf2 <namex>
    8020bd38:	87aa                	mv	a5,a0
}
    8020bd3a:	853e                	mv	a0,a5
    8020bd3c:	70a2                	ld	ra,40(sp)
    8020bd3e:	7402                	ld	s0,32(sp)
    8020bd40:	6145                	addi	sp,sp,48
    8020bd42:	8082                	ret

000000008020bd44 <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    8020bd44:	1101                	addi	sp,sp,-32
    8020bd46:	ec06                	sd	ra,24(sp)
    8020bd48:	e822                	sd	s0,16(sp)
    8020bd4a:	1000                	addi	s0,sp,32
    8020bd4c:	fea43423          	sd	a0,-24(s0)
    8020bd50:	feb43023          	sd	a1,-32(s0)
	return namex(path, 1, name);
    8020bd54:	fe043603          	ld	a2,-32(s0)
    8020bd58:	4585                	li	a1,1
    8020bd5a:	fe843503          	ld	a0,-24(s0)
    8020bd5e:	00000097          	auipc	ra,0x0
    8020bd62:	e94080e7          	jalr	-364(ra) # 8020bbf2 <namex>
    8020bd66:	87aa                	mv	a5,a0
}
    8020bd68:	853e                	mv	a0,a5
    8020bd6a:	60e2                	ld	ra,24(sp)
    8020bd6c:	6442                	ld	s0,16(sp)
    8020bd6e:	6105                	addi	sp,sp,32
    8020bd70:	8082                	ret

000000008020bd72 <create>:
struct inode *
create(char *path, short type, short major, short minor)
{
    8020bd72:	7139                	addi	sp,sp,-64
    8020bd74:	fc06                	sd	ra,56(sp)
    8020bd76:	f822                	sd	s0,48(sp)
    8020bd78:	0080                	addi	s0,sp,64
    8020bd7a:	fca43423          	sd	a0,-56(s0)
    8020bd7e:	87ae                	mv	a5,a1
    8020bd80:	8736                	mv	a4,a3
    8020bd82:	fcf41323          	sh	a5,-58(s0)
    8020bd86:	87b2                	mv	a5,a2
    8020bd88:	fcf41223          	sh	a5,-60(s0)
    8020bd8c:	87ba                	mv	a5,a4
    8020bd8e:	fcf41123          	sh	a5,-62(s0)
	begin_op(); // 开始事务
    8020bd92:	ffffe097          	auipc	ra,0xffffe
    8020bd96:	88c080e7          	jalr	-1908(ra) # 8020961e <begin_op>
	char name[DIRSIZ];
	struct inode *dp, *ip;

	// 找到父目录 inode
	dp = nameiparent(path, name);
    8020bd9a:	fd040793          	addi	a5,s0,-48
    8020bd9e:	85be                	mv	a1,a5
    8020bda0:	fc843503          	ld	a0,-56(s0)
    8020bda4:	00000097          	auipc	ra,0x0
    8020bda8:	fa0080e7          	jalr	-96(ra) # 8020bd44 <nameiparent>
    8020bdac:	fea43423          	sd	a0,-24(s0)
	if (dp == 0)
    8020bdb0:	fe843783          	ld	a5,-24(s0)
    8020bdb4:	e399                	bnez	a5,8020bdba <create+0x48>
		return 0;
    8020bdb6:	4781                	li	a5,0
    8020bdb8:	a279                	j	8020bf46 <create+0x1d4>

	ilock(dp);
    8020bdba:	fe843503          	ld	a0,-24(s0)
    8020bdbe:	fffff097          	auipc	ra,0xfffff
    8020bdc2:	038080e7          	jalr	56(ra) # 8020adf6 <ilock>

	// 检查是否已存在
	if ((ip = dirlookup(dp, name, 0)) != 0)
    8020bdc6:	fd040793          	addi	a5,s0,-48
    8020bdca:	4601                	li	a2,0
    8020bdcc:	85be                	mv	a1,a5
    8020bdce:	fe843503          	ld	a0,-24(s0)
    8020bdd2:	00000097          	auipc	ra,0x0
    8020bdd6:	b56080e7          	jalr	-1194(ra) # 8020b928 <dirlookup>
    8020bdda:	fea43023          	sd	a0,-32(s0)
    8020bdde:	fe043783          	ld	a5,-32(s0)
    8020bde2:	c7ad                	beqz	a5,8020be4c <create+0xda>
	{
		iunlockput(dp);
    8020bde4:	fe843503          	ld	a0,-24(s0)
    8020bde8:	fffff097          	auipc	ra,0xfffff
    8020bdec:	276080e7          	jalr	630(ra) # 8020b05e <iunlockput>
		ilock(ip);
    8020bdf0:	fe043503          	ld	a0,-32(s0)
    8020bdf4:	fffff097          	auipc	ra,0xfffff
    8020bdf8:	002080e7          	jalr	2(ra) # 8020adf6 <ilock>
		if (type == T_FILE && ip->type == T_FILE) {
    8020bdfc:	fc641783          	lh	a5,-58(s0)
    8020be00:	0007871b          	sext.w	a4,a5
    8020be04:	4789                	li	a5,2
    8020be06:	02f71763          	bne	a4,a5,8020be34 <create+0xc2>
    8020be0a:	fe043783          	ld	a5,-32(s0)
    8020be0e:	01479783          	lh	a5,20(a5)
    8020be12:	873e                	mv	a4,a5
    8020be14:	4789                	li	a5,2
    8020be16:	00f71f63          	bne	a4,a5,8020be34 <create+0xc2>
			iunlock(ip); // 释放锁
    8020be1a:	fe043503          	ld	a0,-32(s0)
    8020be1e:	fffff097          	auipc	ra,0xfffff
    8020be22:	10e080e7          	jalr	270(ra) # 8020af2c <iunlock>
			end_op(); // 结束事务
    8020be26:	ffffe097          	auipc	ra,0xffffe
    8020be2a:	8ba080e7          	jalr	-1862(ra) # 802096e0 <end_op>
			return ip;
    8020be2e:	fe043783          	ld	a5,-32(s0)
    8020be32:	aa11                	j	8020bf46 <create+0x1d4>
		}
		iunlockput(ip);
    8020be34:	fe043503          	ld	a0,-32(s0)
    8020be38:	fffff097          	auipc	ra,0xfffff
    8020be3c:	226080e7          	jalr	550(ra) # 8020b05e <iunlockput>
		end_op(); // 结束事务
    8020be40:	ffffe097          	auipc	ra,0xffffe
    8020be44:	8a0080e7          	jalr	-1888(ra) # 802096e0 <end_op>
		return 0;
    8020be48:	4781                	li	a5,0
    8020be4a:	a8f5                	j	8020bf46 <create+0x1d4>
	}

	// 分配新 inode
	ip = ialloc(dp->dev, type);
    8020be4c:	fe843783          	ld	a5,-24(s0)
    8020be50:	439c                	lw	a5,0(a5)
    8020be52:	fc641703          	lh	a4,-58(s0)
    8020be56:	85ba                	mv	a1,a4
    8020be58:	853e                	mv	a0,a5
    8020be5a:	fffff097          	auipc	ra,0xfffff
    8020be5e:	c4e080e7          	jalr	-946(ra) # 8020aaa8 <ialloc>
    8020be62:	fea43023          	sd	a0,-32(s0)
	if (ip == 0)
    8020be66:	fe043783          	ld	a5,-32(s0)
    8020be6a:	eb89                	bnez	a5,8020be7c <create+0x10a>
		panic("create: ialloc");
    8020be6c:	0002c517          	auipc	a0,0x2c
    8020be70:	a8450513          	addi	a0,a0,-1404 # 802378f0 <user_test_table+0x1c0>
    8020be74:	ffff6097          	auipc	ra,0xffff6
    8020be78:	992080e7          	jalr	-1646(ra) # 80201806 <panic>

	ilock(ip);
    8020be7c:	fe043503          	ld	a0,-32(s0)
    8020be80:	fffff097          	auipc	ra,0xfffff
    8020be84:	f76080e7          	jalr	-138(ra) # 8020adf6 <ilock>
	ip->major = major;
    8020be88:	fe043783          	ld	a5,-32(s0)
    8020be8c:	fc445703          	lhu	a4,-60(s0)
    8020be90:	00e79b23          	sh	a4,22(a5)
	ip->minor = minor;
    8020be94:	fe043783          	ld	a5,-32(s0)
    8020be98:	fc245703          	lhu	a4,-62(s0)
    8020be9c:	00e79c23          	sh	a4,24(a5)
	ip->nlink = 1;
    8020bea0:	fe043783          	ld	a5,-32(s0)
    8020bea4:	4705                	li	a4,1
    8020bea6:	00e79d23          	sh	a4,26(a5)
	iupdate(ip);
    8020beaa:	fe043503          	ld	a0,-32(s0)
    8020beae:	fffff097          	auipc	ra,0xfffff
    8020beb2:	cf8080e7          	jalr	-776(ra) # 8020aba6 <iupdate>

	// 添加目录项
	if (type == T_DIR)
    8020beb6:	fc641783          	lh	a5,-58(s0)
    8020beba:	0007871b          	sext.w	a4,a5
    8020bebe:	4785                	li	a5,1
    8020bec0:	02f71963          	bne	a4,a5,8020bef2 <create+0x180>
	{
		dp->nlink++;
    8020bec4:	fe843783          	ld	a5,-24(s0)
    8020bec8:	01a79783          	lh	a5,26(a5)
    8020becc:	17c2                	slli	a5,a5,0x30
    8020bece:	93c1                	srli	a5,a5,0x30
    8020bed0:	2785                	addiw	a5,a5,1
    8020bed2:	17c2                	slli	a5,a5,0x30
    8020bed4:	93c1                	srli	a5,a5,0x30
    8020bed6:	0107971b          	slliw	a4,a5,0x10
    8020beda:	4107571b          	sraiw	a4,a4,0x10
    8020bede:	fe843783          	ld	a5,-24(s0)
    8020bee2:	00e79d23          	sh	a4,26(a5)
		iupdate(dp);
    8020bee6:	fe843503          	ld	a0,-24(s0)
    8020beea:	fffff097          	auipc	ra,0xfffff
    8020beee:	cbc080e7          	jalr	-836(ra) # 8020aba6 <iupdate>
	}

	if (dirlink(dp, name, ip->inum) < 0)
    8020bef2:	fe043783          	ld	a5,-32(s0)
    8020bef6:	43d8                	lw	a4,4(a5)
    8020bef8:	fd040793          	addi	a5,s0,-48
    8020befc:	863a                	mv	a2,a4
    8020befe:	85be                	mv	a1,a5
    8020bf00:	fe843503          	ld	a0,-24(s0)
    8020bf04:	00000097          	auipc	ra,0x0
    8020bf08:	b0a080e7          	jalr	-1270(ra) # 8020ba0e <dirlink>
    8020bf0c:	87aa                	mv	a5,a0
    8020bf0e:	0007da63          	bgez	a5,8020bf22 <create+0x1b0>
		panic("create: dirlink");
    8020bf12:	0002c517          	auipc	a0,0x2c
    8020bf16:	9ee50513          	addi	a0,a0,-1554 # 80237900 <user_test_table+0x1d0>
    8020bf1a:	ffff6097          	auipc	ra,0xffff6
    8020bf1e:	8ec080e7          	jalr	-1812(ra) # 80201806 <panic>

	iunlockput(dp);
    8020bf22:	fe843503          	ld	a0,-24(s0)
    8020bf26:	fffff097          	auipc	ra,0xfffff
    8020bf2a:	138080e7          	jalr	312(ra) # 8020b05e <iunlockput>
	iunlock(ip);
    8020bf2e:	fe043503          	ld	a0,-32(s0)
    8020bf32:	fffff097          	auipc	ra,0xfffff
    8020bf36:	ffa080e7          	jalr	-6(ra) # 8020af2c <iunlock>
	end_op(); 
    8020bf3a:	ffffd097          	auipc	ra,0xffffd
    8020bf3e:	7a6080e7          	jalr	1958(ra) # 802096e0 <end_op>
	return ip;
    8020bf42:	fe043783          	ld	a5,-32(s0)
}
    8020bf46:	853e                	mv	a0,a5
    8020bf48:	70e2                	ld	ra,56(sp)
    8020bf4a:	7442                	ld	s0,48(sp)
    8020bf4c:	6121                	addi	sp,sp,64
    8020bf4e:	8082                	ret

000000008020bf50 <unlink>:
int unlink(char *path)
{
    8020bf50:	711d                	addi	sp,sp,-96
    8020bf52:	ec86                	sd	ra,88(sp)
    8020bf54:	e8a2                	sd	s0,80(sp)
    8020bf56:	1080                	addi	s0,sp,96
    8020bf58:	faa43423          	sd	a0,-88(s0)
	begin_op(); // 开始事务
    8020bf5c:	ffffd097          	auipc	ra,0xffffd
    8020bf60:	6c2080e7          	jalr	1730(ra) # 8020961e <begin_op>
	struct inode *dp, *ip;
	char name[DIRSIZ];
	uint off;

	dp = nameiparent(path, name);
    8020bf64:	fd040793          	addi	a5,s0,-48
    8020bf68:	85be                	mv	a1,a5
    8020bf6a:	fa843503          	ld	a0,-88(s0)
    8020bf6e:	00000097          	auipc	ra,0x0
    8020bf72:	dd6080e7          	jalr	-554(ra) # 8020bd44 <nameiparent>
    8020bf76:	fea43423          	sd	a0,-24(s0)
	if (dp == 0)
    8020bf7a:	fe843783          	ld	a5,-24(s0)
    8020bf7e:	e399                	bnez	a5,8020bf84 <unlink+0x34>
		return -1;
    8020bf80:	57fd                	li	a5,-1
    8020bf82:	a8fd                	j	8020c080 <unlink+0x130>

	ilock(dp);
    8020bf84:	fe843503          	ld	a0,-24(s0)
    8020bf88:	fffff097          	auipc	ra,0xfffff
    8020bf8c:	e6e080e7          	jalr	-402(ra) # 8020adf6 <ilock>

	if ((ip = dirlookup(dp, name, &off)) == 0)
    8020bf90:	fcc40713          	addi	a4,s0,-52
    8020bf94:	fd040793          	addi	a5,s0,-48
    8020bf98:	863a                	mv	a2,a4
    8020bf9a:	85be                	mv	a1,a5
    8020bf9c:	fe843503          	ld	a0,-24(s0)
    8020bfa0:	00000097          	auipc	ra,0x0
    8020bfa4:	988080e7          	jalr	-1656(ra) # 8020b928 <dirlookup>
    8020bfa8:	fea43023          	sd	a0,-32(s0)
    8020bfac:	fe043783          	ld	a5,-32(s0)
    8020bfb0:	eb89                	bnez	a5,8020bfc2 <unlink+0x72>
	{
		iunlockput(dp);
    8020bfb2:	fe843503          	ld	a0,-24(s0)
    8020bfb6:	fffff097          	auipc	ra,0xfffff
    8020bfba:	0a8080e7          	jalr	168(ra) # 8020b05e <iunlockput>
		return -1;
    8020bfbe:	57fd                	li	a5,-1
    8020bfc0:	a0c1                	j	8020c080 <unlink+0x130>
	}

	ilock(ip);
    8020bfc2:	fe043503          	ld	a0,-32(s0)
    8020bfc6:	fffff097          	auipc	ra,0xfffff
    8020bfca:	e30080e7          	jalr	-464(ra) # 8020adf6 <ilock>

	if (ip->nlink < 1)
    8020bfce:	fe043783          	ld	a5,-32(s0)
    8020bfd2:	01a79783          	lh	a5,26(a5)
    8020bfd6:	00f04a63          	bgtz	a5,8020bfea <unlink+0x9a>
		panic("unlink: nlink < 1");
    8020bfda:	0002c517          	auipc	a0,0x2c
    8020bfde:	93650513          	addi	a0,a0,-1738 # 80237910 <user_test_table+0x1e0>
    8020bfe2:	ffff6097          	auipc	ra,0xffff6
    8020bfe6:	824080e7          	jalr	-2012(ra) # 80201806 <panic>

	ip->nlink--;
    8020bfea:	fe043783          	ld	a5,-32(s0)
    8020bfee:	01a79783          	lh	a5,26(a5)
    8020bff2:	17c2                	slli	a5,a5,0x30
    8020bff4:	93c1                	srli	a5,a5,0x30
    8020bff6:	37fd                	addiw	a5,a5,-1
    8020bff8:	17c2                	slli	a5,a5,0x30
    8020bffa:	93c1                	srli	a5,a5,0x30
    8020bffc:	0107971b          	slliw	a4,a5,0x10
    8020c000:	4107571b          	sraiw	a4,a4,0x10
    8020c004:	fe043783          	ld	a5,-32(s0)
    8020c008:	00e79d23          	sh	a4,26(a5)
	iupdate(ip);
    8020c00c:	fe043503          	ld	a0,-32(s0)
    8020c010:	fffff097          	auipc	ra,0xfffff
    8020c014:	b96080e7          	jalr	-1130(ra) # 8020aba6 <iupdate>

	// 清空目录项
	struct dirent de;
	memset(&de, 0, sizeof(de));
    8020c018:	fb840793          	addi	a5,s0,-72
    8020c01c:	4641                	li	a2,16
    8020c01e:	4581                	li	a1,0
    8020c020:	853e                	mv	a0,a5
    8020c022:	ffff6097          	auipc	ra,0xffff6
    8020c026:	f22080e7          	jalr	-222(ra) # 80201f44 <memset>
	if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8020c02a:	fb840793          	addi	a5,s0,-72
    8020c02e:	fcc42683          	lw	a3,-52(s0)
    8020c032:	4741                	li	a4,16
    8020c034:	863e                	mv	a2,a5
    8020c036:	4581                	li	a1,0
    8020c038:	fe843503          	ld	a0,-24(s0)
    8020c03c:	fffff097          	auipc	ra,0xfffff
    8020c040:	702080e7          	jalr	1794(ra) # 8020b73e <writei>
    8020c044:	87aa                	mv	a5,a0
    8020c046:	873e                	mv	a4,a5
    8020c048:	47c1                	li	a5,16
    8020c04a:	00f70a63          	beq	a4,a5,8020c05e <unlink+0x10e>
		panic("unlink: writei");
    8020c04e:	0002c517          	auipc	a0,0x2c
    8020c052:	8da50513          	addi	a0,a0,-1830 # 80237928 <user_test_table+0x1f8>
    8020c056:	ffff5097          	auipc	ra,0xffff5
    8020c05a:	7b0080e7          	jalr	1968(ra) # 80201806 <panic>

	iunlockput(ip);
    8020c05e:	fe043503          	ld	a0,-32(s0)
    8020c062:	fffff097          	auipc	ra,0xfffff
    8020c066:	ffc080e7          	jalr	-4(ra) # 8020b05e <iunlockput>
	iunlockput(dp);
    8020c06a:	fe843503          	ld	a0,-24(s0)
    8020c06e:	fffff097          	auipc	ra,0xfffff
    8020c072:	ff0080e7          	jalr	-16(ra) # 8020b05e <iunlockput>
	end_op(); // 结束事务
    8020c076:	ffffd097          	auipc	ra,0xffffd
    8020c07a:	66a080e7          	jalr	1642(ra) # 802096e0 <end_op>
	return 0;
    8020c07e:	4781                	li	a5,0
    8020c080:	853e                	mv	a0,a5
    8020c082:	60e6                	ld	ra,88(sp)
    8020c084:	6446                	ld	s0,80(sp)
    8020c086:	6125                	addi	sp,sp,96
    8020c088:	8082                	ret

000000008020c08a <r_sstatus>:
    8020c08a:	1101                	addi	sp,sp,-32
    8020c08c:	ec22                	sd	s0,24(sp)
    8020c08e:	1000                	addi	s0,sp,32
    8020c090:	100027f3          	csrr	a5,sstatus
    8020c094:	fef43423          	sd	a5,-24(s0)
    8020c098:	fe843783          	ld	a5,-24(s0)
    8020c09c:	853e                	mv	a0,a5
    8020c09e:	6462                	ld	s0,24(sp)
    8020c0a0:	6105                	addi	sp,sp,32
    8020c0a2:	8082                	ret

000000008020c0a4 <w_sstatus>:
    8020c0a4:	1101                	addi	sp,sp,-32
    8020c0a6:	ec22                	sd	s0,24(sp)
    8020c0a8:	1000                	addi	s0,sp,32
    8020c0aa:	fea43423          	sd	a0,-24(s0)
    8020c0ae:	fe843783          	ld	a5,-24(s0)
    8020c0b2:	10079073          	csrw	sstatus,a5
    8020c0b6:	0001                	nop
    8020c0b8:	6462                	ld	s0,24(sp)
    8020c0ba:	6105                	addi	sp,sp,32
    8020c0bc:	8082                	ret

000000008020c0be <intr_on>:
    8020c0be:	1141                	addi	sp,sp,-16
    8020c0c0:	e406                	sd	ra,8(sp)
    8020c0c2:	e022                	sd	s0,0(sp)
    8020c0c4:	0800                	addi	s0,sp,16
    8020c0c6:	00000097          	auipc	ra,0x0
    8020c0ca:	fc4080e7          	jalr	-60(ra) # 8020c08a <r_sstatus>
    8020c0ce:	87aa                	mv	a5,a0
    8020c0d0:	0027e793          	ori	a5,a5,2
    8020c0d4:	853e                	mv	a0,a5
    8020c0d6:	00000097          	auipc	ra,0x0
    8020c0da:	fce080e7          	jalr	-50(ra) # 8020c0a4 <w_sstatus>
    8020c0de:	0001                	nop
    8020c0e0:	60a2                	ld	ra,8(sp)
    8020c0e2:	6402                	ld	s0,0(sp)
    8020c0e4:	0141                	addi	sp,sp,16
    8020c0e6:	8082                	ret

000000008020c0e8 <intr_off>:
    8020c0e8:	1141                	addi	sp,sp,-16
    8020c0ea:	e406                	sd	ra,8(sp)
    8020c0ec:	e022                	sd	s0,0(sp)
    8020c0ee:	0800                	addi	s0,sp,16
    8020c0f0:	00000097          	auipc	ra,0x0
    8020c0f4:	f9a080e7          	jalr	-102(ra) # 8020c08a <r_sstatus>
    8020c0f8:	87aa                	mv	a5,a0
    8020c0fa:	9bf5                	andi	a5,a5,-3
    8020c0fc:	853e                	mv	a0,a5
    8020c0fe:	00000097          	auipc	ra,0x0
    8020c102:	fa6080e7          	jalr	-90(ra) # 8020c0a4 <w_sstatus>
    8020c106:	0001                	nop
    8020c108:	60a2                	ld	ra,8(sp)
    8020c10a:	6402                	ld	s0,0(sp)
    8020c10c:	0141                	addi	sp,sp,16
    8020c10e:	8082                	ret

000000008020c110 <initlock>:
{
    8020c110:	1101                	addi	sp,sp,-32
    8020c112:	ec22                	sd	s0,24(sp)
    8020c114:	1000                	addi	s0,sp,32
    8020c116:	fea43423          	sd	a0,-24(s0)
    8020c11a:	feb43023          	sd	a1,-32(s0)
  lk->name = name;
    8020c11e:	fe843783          	ld	a5,-24(s0)
    8020c122:	fe043703          	ld	a4,-32(s0)
    8020c126:	e798                	sd	a4,8(a5)
  lk->locked = 0;
    8020c128:	fe843783          	ld	a5,-24(s0)
    8020c12c:	0007a023          	sw	zero,0(a5)
}
    8020c130:	0001                	nop
    8020c132:	6462                	ld	s0,24(sp)
    8020c134:	6105                	addi	sp,sp,32
    8020c136:	8082                	ret

000000008020c138 <acquire>:
{
    8020c138:	1101                	addi	sp,sp,-32
    8020c13a:	ec06                	sd	ra,24(sp)
    8020c13c:	e822                	sd	s0,16(sp)
    8020c13e:	1000                	addi	s0,sp,32
    8020c140:	fea43423          	sd	a0,-24(s0)
  intr_off(); // 直接关闭中断
    8020c144:	00000097          	auipc	ra,0x0
    8020c148:	fa4080e7          	jalr	-92(ra) # 8020c0e8 <intr_off>
  if(lk->locked)
    8020c14c:	fe843783          	ld	a5,-24(s0)
    8020c150:	439c                	lw	a5,0(a5)
    8020c152:	cb89                	beqz	a5,8020c164 <acquire+0x2c>
    panic("acquire");
    8020c154:	0002e517          	auipc	a0,0x2e
    8020c158:	89450513          	addi	a0,a0,-1900 # 802399e8 <user_test_table+0x78>
    8020c15c:	ffff5097          	auipc	ra,0xffff5
    8020c160:	6aa080e7          	jalr	1706(ra) # 80201806 <panic>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8020c164:	0001                	nop
    8020c166:	fe843783          	ld	a5,-24(s0)
    8020c16a:	4705                	li	a4,1
    8020c16c:	0ce7a72f          	amoswap.w.aq	a4,a4,(a5)
    8020c170:	0007079b          	sext.w	a5,a4
    8020c174:	fbed                	bnez	a5,8020c166 <acquire+0x2e>
  __sync_synchronize();
    8020c176:	0ff0000f          	fence
}
    8020c17a:	0001                	nop
    8020c17c:	60e2                	ld	ra,24(sp)
    8020c17e:	6442                	ld	s0,16(sp)
    8020c180:	6105                	addi	sp,sp,32
    8020c182:	8082                	ret

000000008020c184 <release>:
{
    8020c184:	1101                	addi	sp,sp,-32
    8020c186:	ec06                	sd	ra,24(sp)
    8020c188:	e822                	sd	s0,16(sp)
    8020c18a:	1000                	addi	s0,sp,32
    8020c18c:	fea43423          	sd	a0,-24(s0)
  if(!lk->locked)
    8020c190:	fe843783          	ld	a5,-24(s0)
    8020c194:	439c                	lw	a5,0(a5)
    8020c196:	eb89                	bnez	a5,8020c1a8 <release+0x24>
    panic("release");
    8020c198:	0002e517          	auipc	a0,0x2e
    8020c19c:	85850513          	addi	a0,a0,-1960 # 802399f0 <user_test_table+0x80>
    8020c1a0:	ffff5097          	auipc	ra,0xffff5
    8020c1a4:	666080e7          	jalr	1638(ra) # 80201806 <panic>
  __sync_synchronize();
    8020c1a8:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8020c1ac:	fe843783          	ld	a5,-24(s0)
    8020c1b0:	0f50000f          	fence	iorw,ow
    8020c1b4:	0807a02f          	amoswap.w	zero,zero,(a5)
  intr_on(); // 直接开启中断
    8020c1b8:	00000097          	auipc	ra,0x0
    8020c1bc:	f06080e7          	jalr	-250(ra) # 8020c0be <intr_on>
}
    8020c1c0:	0001                	nop
    8020c1c2:	60e2                	ld	ra,24(sp)
    8020c1c4:	6442                	ld	s0,16(sp)
    8020c1c6:	6105                	addi	sp,sp,32
    8020c1c8:	8082                	ret

000000008020c1ca <holding>:
{
    8020c1ca:	1101                	addi	sp,sp,-32
    8020c1cc:	ec22                	sd	s0,24(sp)
    8020c1ce:	1000                	addi	s0,sp,32
    8020c1d0:	fea43423          	sd	a0,-24(s0)
  return lk->locked;
    8020c1d4:	fe843783          	ld	a5,-24(s0)
    8020c1d8:	439c                	lw	a5,0(a5)
    8020c1da:	2781                	sext.w	a5,a5
    8020c1dc:	853e                	mv	a0,a5
    8020c1de:	6462                	ld	s0,24(sp)
    8020c1e0:	6105                	addi	sp,sp,32
    8020c1e2:	8082                	ret

000000008020c1e4 <initsleeplock>:
#include "defs.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8020c1e4:	1101                	addi	sp,sp,-32
    8020c1e6:	ec06                	sd	ra,24(sp)
    8020c1e8:	e822                	sd	s0,16(sp)
    8020c1ea:	1000                	addi	s0,sp,32
    8020c1ec:	fea43423          	sd	a0,-24(s0)
    8020c1f0:	feb43023          	sd	a1,-32(s0)
  initlock(&lk->lk, "sleep lock");
    8020c1f4:	fe843783          	ld	a5,-24(s0)
    8020c1f8:	07a1                	addi	a5,a5,8
    8020c1fa:	00030597          	auipc	a1,0x30
    8020c1fe:	8ae58593          	addi	a1,a1,-1874 # 8023baa8 <user_test_table+0x78>
    8020c202:	853e                	mv	a0,a5
    8020c204:	00000097          	auipc	ra,0x0
    8020c208:	f0c080e7          	jalr	-244(ra) # 8020c110 <initlock>
  lk->name = name;
    8020c20c:	fe843783          	ld	a5,-24(s0)
    8020c210:	fe043703          	ld	a4,-32(s0)
    8020c214:	ef98                	sd	a4,24(a5)
  lk->locked = 0;
    8020c216:	fe843783          	ld	a5,-24(s0)
    8020c21a:	0007a023          	sw	zero,0(a5)
  lk->pid = 0;
    8020c21e:	fe843783          	ld	a5,-24(s0)
    8020c222:	0207a023          	sw	zero,32(a5)
}
    8020c226:	0001                	nop
    8020c228:	60e2                	ld	ra,24(sp)
    8020c22a:	6442                	ld	s0,16(sp)
    8020c22c:	6105                	addi	sp,sp,32
    8020c22e:	8082                	ret

000000008020c230 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8020c230:	7179                	addi	sp,sp,-48
    8020c232:	f406                	sd	ra,40(sp)
    8020c234:	f022                	sd	s0,32(sp)
    8020c236:	ec26                	sd	s1,24(sp)
    8020c238:	1800                	addi	s0,sp,48
    8020c23a:	fca43c23          	sd	a0,-40(s0)
  acquire(&lk->lk);
    8020c23e:	fd843783          	ld	a5,-40(s0)
    8020c242:	07a1                	addi	a5,a5,8
    8020c244:	853e                	mv	a0,a5
    8020c246:	00000097          	auipc	ra,0x0
    8020c24a:	ef2080e7          	jalr	-270(ra) # 8020c138 <acquire>
if (lk->locked && lk->pid == myproc()->pid) {
    8020c24e:	fd843783          	ld	a5,-40(s0)
    8020c252:	439c                	lw	a5,0(a5)
    8020c254:	c3bd                	beqz	a5,8020c2ba <acquiresleep+0x8a>
    8020c256:	fd843783          	ld	a5,-40(s0)
    8020c25a:	5384                	lw	s1,32(a5)
    8020c25c:	ffff9097          	auipc	ra,0xffff9
    8020c260:	e04080e7          	jalr	-508(ra) # 80205060 <myproc>
    8020c264:	87aa                	mv	a5,a0
    8020c266:	43dc                	lw	a5,4(a5)
    8020c268:	8726                	mv	a4,s1
    8020c26a:	04f71863          	bne	a4,a5,8020c2ba <acquiresleep+0x8a>
    warning("sleeplock: pid %d tries to recursively acquire lock '%s'\n", myproc()->pid, lk->name);
    8020c26e:	ffff9097          	auipc	ra,0xffff9
    8020c272:	df2080e7          	jalr	-526(ra) # 80205060 <myproc>
    8020c276:	87aa                	mv	a5,a0
    8020c278:	43d8                	lw	a4,4(a5)
    8020c27a:	fd843783          	ld	a5,-40(s0)
    8020c27e:	6f9c                	ld	a5,24(a5)
    8020c280:	863e                	mv	a2,a5
    8020c282:	85ba                	mv	a1,a4
    8020c284:	00030517          	auipc	a0,0x30
    8020c288:	83450513          	addi	a0,a0,-1996 # 8023bab8 <user_test_table+0x88>
    8020c28c:	ffff5097          	auipc	ra,0xffff5
    8020c290:	5ae080e7          	jalr	1454(ra) # 8020183a <warning>
    release(&lk->lk);
    8020c294:	fd843783          	ld	a5,-40(s0)
    8020c298:	07a1                	addi	a5,a5,8
    8020c29a:	853e                	mv	a0,a5
    8020c29c:	00000097          	auipc	ra,0x0
    8020c2a0:	ee8080e7          	jalr	-280(ra) # 8020c184 <release>
    return;
    8020c2a4:	a0a1                	j	8020c2ec <acquiresleep+0xbc>
  }
  while (lk->locked) {
    sleep(lk, &lk->lk);
    8020c2a6:	fd843783          	ld	a5,-40(s0)
    8020c2aa:	07a1                	addi	a5,a5,8
    8020c2ac:	85be                	mv	a1,a5
    8020c2ae:	fd843503          	ld	a0,-40(s0)
    8020c2b2:	ffffa097          	auipc	ra,0xffffa
    8020c2b6:	ad0080e7          	jalr	-1328(ra) # 80205d82 <sleep>
  while (lk->locked) {
    8020c2ba:	fd843783          	ld	a5,-40(s0)
    8020c2be:	439c                	lw	a5,0(a5)
    8020c2c0:	f3fd                	bnez	a5,8020c2a6 <acquiresleep+0x76>
  }
  lk->locked = 1;
    8020c2c2:	fd843783          	ld	a5,-40(s0)
    8020c2c6:	4705                	li	a4,1
    8020c2c8:	c398                	sw	a4,0(a5)
  lk->pid = myproc()->pid;
    8020c2ca:	ffff9097          	auipc	ra,0xffff9
    8020c2ce:	d96080e7          	jalr	-618(ra) # 80205060 <myproc>
    8020c2d2:	87aa                	mv	a5,a0
    8020c2d4:	43d8                	lw	a4,4(a5)
    8020c2d6:	fd843783          	ld	a5,-40(s0)
    8020c2da:	d398                	sw	a4,32(a5)
  release(&lk->lk);
    8020c2dc:	fd843783          	ld	a5,-40(s0)
    8020c2e0:	07a1                	addi	a5,a5,8
    8020c2e2:	853e                	mv	a0,a5
    8020c2e4:	00000097          	auipc	ra,0x0
    8020c2e8:	ea0080e7          	jalr	-352(ra) # 8020c184 <release>
}
    8020c2ec:	70a2                	ld	ra,40(sp)
    8020c2ee:	7402                	ld	s0,32(sp)
    8020c2f0:	64e2                	ld	s1,24(sp)
    8020c2f2:	6145                	addi	sp,sp,48
    8020c2f4:	8082                	ret

000000008020c2f6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8020c2f6:	1101                	addi	sp,sp,-32
    8020c2f8:	ec06                	sd	ra,24(sp)
    8020c2fa:	e822                	sd	s0,16(sp)
    8020c2fc:	1000                	addi	s0,sp,32
    8020c2fe:	fea43423          	sd	a0,-24(s0)
  acquire(&lk->lk);
    8020c302:	fe843783          	ld	a5,-24(s0)
    8020c306:	07a1                	addi	a5,a5,8
    8020c308:	853e                	mv	a0,a5
    8020c30a:	00000097          	auipc	ra,0x0
    8020c30e:	e2e080e7          	jalr	-466(ra) # 8020c138 <acquire>
  lk->locked = 0;
    8020c312:	fe843783          	ld	a5,-24(s0)
    8020c316:	0007a023          	sw	zero,0(a5)
  lk->pid = 0;
    8020c31a:	fe843783          	ld	a5,-24(s0)
    8020c31e:	0207a023          	sw	zero,32(a5)
  wakeup(lk);
    8020c322:	fe843503          	ld	a0,-24(s0)
    8020c326:	ffffa097          	auipc	ra,0xffffa
    8020c32a:	b14080e7          	jalr	-1260(ra) # 80205e3a <wakeup>
  release(&lk->lk);
    8020c32e:	fe843783          	ld	a5,-24(s0)
    8020c332:	07a1                	addi	a5,a5,8
    8020c334:	853e                	mv	a0,a5
    8020c336:	00000097          	auipc	ra,0x0
    8020c33a:	e4e080e7          	jalr	-434(ra) # 8020c184 <release>
}
    8020c33e:	0001                	nop
    8020c340:	60e2                	ld	ra,24(sp)
    8020c342:	6442                	ld	s0,16(sp)
    8020c344:	6105                	addi	sp,sp,32
    8020c346:	8082                	ret

000000008020c348 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8020c348:	7139                	addi	sp,sp,-64
    8020c34a:	fc06                	sd	ra,56(sp)
    8020c34c:	f822                	sd	s0,48(sp)
    8020c34e:	f426                	sd	s1,40(sp)
    8020c350:	0080                	addi	s0,sp,64
    8020c352:	fca43423          	sd	a0,-56(s0)
  int r;
  
  acquire(&lk->lk);
    8020c356:	fc843783          	ld	a5,-56(s0)
    8020c35a:	07a1                	addi	a5,a5,8
    8020c35c:	853e                	mv	a0,a5
    8020c35e:	00000097          	auipc	ra,0x0
    8020c362:	dda080e7          	jalr	-550(ra) # 8020c138 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8020c366:	fc843783          	ld	a5,-56(s0)
    8020c36a:	439c                	lw	a5,0(a5)
    8020c36c:	cf99                	beqz	a5,8020c38a <holdingsleep+0x42>
    8020c36e:	fc843783          	ld	a5,-56(s0)
    8020c372:	5384                	lw	s1,32(a5)
    8020c374:	ffff9097          	auipc	ra,0xffff9
    8020c378:	cec080e7          	jalr	-788(ra) # 80205060 <myproc>
    8020c37c:	87aa                	mv	a5,a0
    8020c37e:	43dc                	lw	a5,4(a5)
    8020c380:	8726                	mv	a4,s1
    8020c382:	00f71463          	bne	a4,a5,8020c38a <holdingsleep+0x42>
    8020c386:	4785                	li	a5,1
    8020c388:	a011                	j	8020c38c <holdingsleep+0x44>
    8020c38a:	4781                	li	a5,0
    8020c38c:	fcf42e23          	sw	a5,-36(s0)
  release(&lk->lk);
    8020c390:	fc843783          	ld	a5,-56(s0)
    8020c394:	07a1                	addi	a5,a5,8
    8020c396:	853e                	mv	a0,a5
    8020c398:	00000097          	auipc	ra,0x0
    8020c39c:	dec080e7          	jalr	-532(ra) # 8020c184 <release>
  return r;
    8020c3a0:	fdc42783          	lw	a5,-36(s0)
}
    8020c3a4:	853e                	mv	a0,a5
    8020c3a6:	70e2                	ld	ra,56(sp)
    8020c3a8:	7442                	ld	s0,48(sp)
    8020c3aa:	74a2                	ld	s1,40(sp)
    8020c3ac:	6121                	addi	sp,sp,64
    8020c3ae:	8082                	ret
	...
