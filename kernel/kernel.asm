
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_entry>:
.section .text # 设置代码段，基于内存的段式管理
.global _entry # 设置全局入口点，告知连接器入口地址

_entry: # 定义入口点标签
		la sp, stack0
    80200000:	0003b117          	auipc	sp,0x3b
    80200004:	00010113          	mv	sp,sp
        li a0,4096*4 # 表示4096个字节单位
    80200008:	6511                	lui	a0,0x4
        add sp,sp,a0 # 初始化栈指针
    8020000a:	912a                	add	sp,sp,a0

        la a0,_bss_start
    8020000c:	0003c517          	auipc	a0,0x3c
    80200010:	09450513          	addi	a0,a0,148 # 8023c0a0 <kernel_pagetable>
        la a1,_bss_end
    80200014:	00048597          	auipc	a1,0x48
    80200018:	90c58593          	addi	a1,a1,-1780 # 80247920 <_bss_end>

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
    80200032:	1101                	addi	sp,sp,-32 # 8023afe0 <user_test_table+0x700>
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
    8020009c:	270080e7          	jalr	624(ra) # 80203308 <pmm_init>
	kvminit();
    802000a0:	00003097          	auipc	ra,0x3
    802000a4:	834080e7          	jalr	-1996(ra) # 802028d4 <kvminit>
	trap_init();
    802000a8:	00004097          	auipc	ra,0x4
    802000ac:	884080e7          	jalr	-1916(ra) # 8020392c <trap_init>
	uart_init();
    802000b0:	00000097          	auipc	ra,0x0
    802000b4:	5ae080e7          	jalr	1454(ra) # 8020065e <uart_init>
	intr_on();
    802000b8:	00000097          	auipc	ra,0x0
    802000bc:	fae080e7          	jalr	-82(ra) # 80200066 <intr_on>
    printf("===============================================\n");
    802000c0:	0000e517          	auipc	a0,0xe
    802000c4:	24850513          	addi	a0,a0,584 # 8020e308 <user_test_table+0x120>
    802000c8:	00001097          	auipc	ra,0x1
    802000cc:	cc6080e7          	jalr	-826(ra) # 80200d8e <printf>
    printf("        RISC-V Operating System v1.0         \n");
    802000d0:	0000e517          	auipc	a0,0xe
    802000d4:	27050513          	addi	a0,a0,624 # 8020e340 <user_test_table+0x158>
    802000d8:	00001097          	auipc	ra,0x1
    802000dc:	cb6080e7          	jalr	-842(ra) # 80200d8e <printf>
    printf("===============================================\n\n");
    802000e0:	0000e517          	auipc	a0,0xe
    802000e4:	29050513          	addi	a0,a0,656 # 8020e370 <user_test_table+0x188>
    802000e8:	00001097          	auipc	ra,0x1
    802000ec:	ca6080e7          	jalr	-858(ra) # 80200d8e <printf>
	init_proc(); // 初始化进程管理子系统
    802000f0:	00005097          	auipc	ra,0x5
    802000f4:	174080e7          	jalr	372(ra) # 80205264 <init_proc>
	int main_pid = create_kernel_proc(kernel_main);
    802000f8:	00000517          	auipc	a0,0x0
    802000fc:	46050513          	addi	a0,a0,1120 # 80200558 <kernel_main>
    80200100:	00005097          	auipc	ra,0x5
    80200104:	5a6080e7          	jalr	1446(ra) # 802056a6 <create_kernel_proc>
    80200108:	87aa                	mv	a5,a0
    8020010a:	fef42623          	sw	a5,-20(s0)
	if (main_pid < 0){
    8020010e:	fec42783          	lw	a5,-20(s0)
    80200112:	2781                	sext.w	a5,a5
    80200114:	0007da63          	bgez	a5,80200128 <start+0x98>
		panic("START: create main process failed!\n");
    80200118:	0000e517          	auipc	a0,0xe
    8020011c:	29050513          	addi	a0,a0,656 # 8020e3a8 <user_test_table+0x1c0>
    80200120:	00001097          	auipc	ra,0x1
    80200124:	6ba080e7          	jalr	1722(ra) # 802017da <panic>
	schedule();
    80200128:	00006097          	auipc	ra,0x6
    8020012c:	ae0080e7          	jalr	-1312(ra) # 80205c08 <schedule>
    panic("START: main() exit unexpectedly!!!\n");
    80200130:	0000e517          	auipc	a0,0xe
    80200134:	2a050513          	addi	a0,a0,672 # 8020e3d0 <user_test_table+0x1e8>
    80200138:	00001097          	auipc	ra,0x1
    8020013c:	6a2080e7          	jalr	1698(ra) # 802017da <panic>
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
    80200152:	0000e517          	auipc	a0,0xe
    80200156:	2a650513          	addi	a0,a0,678 # 8020e3f8 <user_test_table+0x210>
    8020015a:	00001097          	auipc	ra,0x1
    8020015e:	c34080e7          	jalr	-972(ra) # 80200d8e <printf>
    for (int i = 0; i < KERNEL_TEST_COUNT; i++) {
    80200162:	fe042623          	sw	zero,-20(s0)
    80200166:	a835                	j	802001a2 <print_menu+0x58>
        printf("  k%d. %s\n", i+1, kernel_test_table[i].name);
    80200168:	fec42783          	lw	a5,-20(s0)
    8020016c:	2785                	addiw	a5,a5,1
    8020016e:	0007869b          	sext.w	a3,a5
    80200172:	0003c717          	auipc	a4,0x3c
    80200176:	e8e70713          	addi	a4,a4,-370 # 8023c000 <kernel_test_table>
    8020017a:	fec42783          	lw	a5,-20(s0)
    8020017e:	0792                	slli	a5,a5,0x4
    80200180:	97ba                	add	a5,a5,a4
    80200182:	639c                	ld	a5,0(a5)
    80200184:	863e                	mv	a2,a5
    80200186:	85b6                	mv	a1,a3
    80200188:	0000e517          	auipc	a0,0xe
    8020018c:	28850513          	addi	a0,a0,648 # 8020e410 <user_test_table+0x228>
    80200190:	00001097          	auipc	ra,0x1
    80200194:	bfe080e7          	jalr	-1026(ra) # 80200d8e <printf>
    for (int i = 0; i < KERNEL_TEST_COUNT; i++) {
    80200198:	fec42783          	lw	a5,-20(s0)
    8020019c:	2785                	addiw	a5,a5,1
    8020019e:	fef42623          	sw	a5,-20(s0)
    802001a2:	fec42783          	lw	a5,-20(s0)
    802001a6:	873e                	mv	a4,a5
    802001a8:	479d                	li	a5,7
    802001aa:	fae7ffe3          	bgeu	a5,a4,80200168 <print_menu+0x1e>
    printf("\n=== 用户测试 ===\n");
    802001ae:	0000e517          	auipc	a0,0xe
    802001b2:	27250513          	addi	a0,a0,626 # 8020e420 <user_test_table+0x238>
    802001b6:	00001097          	auipc	ra,0x1
    802001ba:	bd8080e7          	jalr	-1064(ra) # 80200d8e <printf>
    for (int i = 0; i < USER_TEST_COUNT; i++) {
    802001be:	fe042423          	sw	zero,-24(s0)
    802001c2:	a081                	j	80200202 <print_menu+0xb8>
        printf("  u%d. %s\n", i+1, user_test_table[i].name);
    802001c4:	fe842783          	lw	a5,-24(s0)
    802001c8:	2785                	addiw	a5,a5,1
    802001ca:	0007859b          	sext.w	a1,a5
    802001ce:	0000e697          	auipc	a3,0xe
    802001d2:	01a68693          	addi	a3,a3,26 # 8020e1e8 <user_test_table>
    802001d6:	fe842703          	lw	a4,-24(s0)
    802001da:	87ba                	mv	a5,a4
    802001dc:	0786                	slli	a5,a5,0x1
    802001de:	97ba                	add	a5,a5,a4
    802001e0:	078e                	slli	a5,a5,0x3
    802001e2:	97b6                	add	a5,a5,a3
    802001e4:	639c                	ld	a5,0(a5)
    802001e6:	863e                	mv	a2,a5
    802001e8:	0000e517          	auipc	a0,0xe
    802001ec:	25050513          	addi	a0,a0,592 # 8020e438 <user_test_table+0x250>
    802001f0:	00001097          	auipc	ra,0x1
    802001f4:	b9e080e7          	jalr	-1122(ra) # 80200d8e <printf>
    for (int i = 0; i < USER_TEST_COUNT; i++) {
    802001f8:	fe842783          	lw	a5,-24(s0)
    802001fc:	2785                	addiw	a5,a5,1
    802001fe:	fef42423          	sw	a5,-24(s0)
    80200202:	fe842783          	lw	a5,-24(s0)
    80200206:	873e                	mv	a4,a5
    80200208:	4791                	li	a5,4
    8020020a:	fae7fde3          	bgeu	a5,a4,802001c4 <print_menu+0x7a>
    printf("\n=== 基础命令 ===\n");
    8020020e:	0000e517          	auipc	a0,0xe
    80200212:	23a50513          	addi	a0,a0,570 # 8020e448 <user_test_table+0x260>
    80200216:	00001097          	auipc	ra,0x1
    8020021a:	b78080e7          	jalr	-1160(ra) # 80200d8e <printf>
    printf("  h. help          - 显示此帮助\n");
    8020021e:	0000e517          	auipc	a0,0xe
    80200222:	24250513          	addi	a0,a0,578 # 8020e460 <user_test_table+0x278>
    80200226:	00001097          	auipc	ra,0x1
    8020022a:	b68080e7          	jalr	-1176(ra) # 80200d8e <printf>
    printf("  e. exit          - 退出控制台\n");
    8020022e:	0000e517          	auipc	a0,0xe
    80200232:	25a50513          	addi	a0,a0,602 # 8020e488 <user_test_table+0x2a0>
    80200236:	00001097          	auipc	ra,0x1
    8020023a:	b58080e7          	jalr	-1192(ra) # 80200d8e <printf>
    printf("  p. ps            - 显示进程状态\n");
    8020023e:	0000e517          	auipc	a0,0xe
    80200242:	27250513          	addi	a0,a0,626 # 8020e4b0 <user_test_table+0x2c8>
    80200246:	00001097          	auipc	ra,0x1
    8020024a:	b48080e7          	jalr	-1208(ra) # 80200d8e <printf>
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
    8020026e:	0000e517          	auipc	a0,0xe
    80200272:	27250513          	addi	a0,a0,626 # 8020e4e0 <user_test_table+0x2f8>
    80200276:	00001097          	auipc	ra,0x1
    8020027a:	b18080e7          	jalr	-1256(ra) # 80200d8e <printf>
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
    802002be:	0000e717          	auipc	a4,0xe
    802002c2:	48270713          	addi	a4,a4,1154 # 8020e740 <user_test_table+0x558>
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
    80200312:	e42080e7          	jalr	-446(ra) # 80206150 <print_proc_table>
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
    80200340:	1b2080e7          	jalr	434(ra) # 802064ee <atoi>
    80200344:	87aa                	mv	a5,a0
    80200346:	37fd                	addiw	a5,a5,-1
    80200348:	fef42023          	sw	a5,-32(s0)
            if (index >= 0 && index < KERNEL_TEST_COUNT) {
    8020034c:	fe042783          	lw	a5,-32(s0)
    80200350:	2781                	sext.w	a5,a5
    80200352:	0807cc63          	bltz	a5,802003ea <console+0x192>
    80200356:	fe042783          	lw	a5,-32(s0)
    8020035a:	873e                	mv	a4,a5
    8020035c:	479d                	li	a5,7
    8020035e:	08e7e663          	bltu	a5,a4,802003ea <console+0x192>
                printf("\n----- 执行内核测试: %s -----\n", 
    80200362:	0003c717          	auipc	a4,0x3c
    80200366:	c9e70713          	addi	a4,a4,-866 # 8023c000 <kernel_test_table>
    8020036a:	fe042783          	lw	a5,-32(s0)
    8020036e:	0792                	slli	a5,a5,0x4
    80200370:	97ba                	add	a5,a5,a4
    80200372:	639c                	ld	a5,0(a5)
    80200374:	85be                	mv	a1,a5
    80200376:	0000e517          	auipc	a0,0xe
    8020037a:	17a50513          	addi	a0,a0,378 # 8020e4f0 <user_test_table+0x308>
    8020037e:	00001097          	auipc	ra,0x1
    80200382:	a10080e7          	jalr	-1520(ra) # 80200d8e <printf>
                int pid = create_kernel_proc(kernel_test_table[index].func);
    80200386:	0003c717          	auipc	a4,0x3c
    8020038a:	c7a70713          	addi	a4,a4,-902 # 8023c000 <kernel_test_table>
    8020038e:	fe042783          	lw	a5,-32(s0)
    80200392:	0792                	slli	a5,a5,0x4
    80200394:	97ba                	add	a5,a5,a4
    80200396:	679c                	ld	a5,8(a5)
    80200398:	853e                	mv	a0,a5
    8020039a:	00005097          	auipc	ra,0x5
    8020039e:	30c080e7          	jalr	780(ra) # 802056a6 <create_kernel_proc>
    802003a2:	87aa                	mv	a5,a0
    802003a4:	fcf42e23          	sw	a5,-36(s0)
                if (pid < 0) {
    802003a8:	fdc42783          	lw	a5,-36(s0)
    802003ac:	2781                	sext.w	a5,a5
    802003ae:	0007db63          	bgez	a5,802003c4 <console+0x16c>
                    printf("创建内核测试进程失败\n");
    802003b2:	0000e517          	auipc	a0,0xe
    802003b6:	16650513          	addi	a0,a0,358 # 8020e518 <user_test_table+0x330>
    802003ba:	00001097          	auipc	ra,0x1
    802003be:	9d4080e7          	jalr	-1580(ra) # 80200d8e <printf>
            if (index >= 0 && index < KERNEL_TEST_COUNT) {
    802003c2:	a82d                	j	802003fc <console+0x1a4>
                    printf("创建内核测试进程成功，PID: %d\n", pid);
    802003c4:	fdc42783          	lw	a5,-36(s0)
    802003c8:	85be                	mv	a1,a5
    802003ca:	0000e517          	auipc	a0,0xe
    802003ce:	16e50513          	addi	a0,a0,366 # 8020e538 <user_test_table+0x350>
    802003d2:	00001097          	auipc	ra,0x1
    802003d6:	9bc080e7          	jalr	-1604(ra) # 80200d8e <printf>
                    wait_proc(&status);
    802003da:	ed440793          	addi	a5,s0,-300
    802003de:	853e                	mv	a0,a5
    802003e0:	00006097          	auipc	ra,0x6
    802003e4:	be6080e7          	jalr	-1050(ra) # 80205fc6 <wait_proc>
            if (index >= 0 && index < KERNEL_TEST_COUNT) {
    802003e8:	a811                	j	802003fc <console+0x1a4>
                printf("无效的内核测试序号\n");
    802003ea:	0000e517          	auipc	a0,0xe
    802003ee:	17e50513          	addi	a0,a0,382 # 8020e568 <user_test_table+0x380>
    802003f2:	00001097          	auipc	ra,0x1
    802003f6:	99c080e7          	jalr	-1636(ra) # 80200d8e <printf>
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
    80200426:	0cc080e7          	jalr	204(ra) # 802064ee <atoi>
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
    80200448:	0000e697          	auipc	a3,0xe
    8020044c:	da068693          	addi	a3,a3,-608 # 8020e1e8 <user_test_table>
    80200450:	fe842703          	lw	a4,-24(s0)
    80200454:	87ba                	mv	a5,a4
    80200456:	0786                	slli	a5,a5,0x1
    80200458:	97ba                	add	a5,a5,a4
    8020045a:	078e                	slli	a5,a5,0x3
    8020045c:	97b6                	add	a5,a5,a3
    8020045e:	639c                	ld	a5,0(a5)
                printf("\n----- 执行用户测试: %s -----\n", 
    80200460:	85be                	mv	a1,a5
    80200462:	0000e517          	auipc	a0,0xe
    80200466:	12650513          	addi	a0,a0,294 # 8020e588 <user_test_table+0x3a0>
    8020046a:	00001097          	auipc	ra,0x1
    8020046e:	924080e7          	jalr	-1756(ra) # 80200d8e <printf>
                int pid = create_user_proc(user_test_table[index].binary,
    80200472:	0000e697          	auipc	a3,0xe
    80200476:	d7668693          	addi	a3,a3,-650 # 8020e1e8 <user_test_table>
    8020047a:	fe842703          	lw	a4,-24(s0)
    8020047e:	87ba                	mv	a5,a4
    80200480:	0786                	slli	a5,a5,0x1
    80200482:	97ba                	add	a5,a5,a4
    80200484:	078e                	slli	a5,a5,0x3
    80200486:	97b6                	add	a5,a5,a3
    80200488:	6790                	ld	a2,8(a5)
                                         user_test_table[index].size);
    8020048a:	0000e697          	auipc	a3,0xe
    8020048e:	d5e68693          	addi	a3,a3,-674 # 8020e1e8 <user_test_table>
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
    802004aa:	34c080e7          	jalr	844(ra) # 802057f2 <create_user_proc>
    802004ae:	87aa                	mv	a5,a0
    802004b0:	fef42223          	sw	a5,-28(s0)
                if (pid < 0) {
    802004b4:	fe442783          	lw	a5,-28(s0)
    802004b8:	2781                	sext.w	a5,a5
    802004ba:	0007db63          	bgez	a5,802004d0 <console+0x278>
                    printf("创建用户测试进程失败\n");
    802004be:	0000e517          	auipc	a0,0xe
    802004c2:	0f250513          	addi	a0,a0,242 # 8020e5b0 <user_test_table+0x3c8>
    802004c6:	00001097          	auipc	ra,0x1
    802004ca:	8c8080e7          	jalr	-1848(ra) # 80200d8e <printf>
            if (index >= 0 && index < USER_TEST_COUNT) {
    802004ce:	a82d                	j	80200508 <console+0x2b0>
                    printf("创建用户测试进程成功，PID: %d\n", pid);
    802004d0:	fe442783          	lw	a5,-28(s0)
    802004d4:	85be                	mv	a1,a5
    802004d6:	0000e517          	auipc	a0,0xe
    802004da:	0fa50513          	addi	a0,a0,250 # 8020e5d0 <user_test_table+0x3e8>
    802004de:	00001097          	auipc	ra,0x1
    802004e2:	8b0080e7          	jalr	-1872(ra) # 80200d8e <printf>
                    wait_proc(&status);
    802004e6:	ed040793          	addi	a5,s0,-304
    802004ea:	853e                	mv	a0,a5
    802004ec:	00006097          	auipc	ra,0x6
    802004f0:	ada080e7          	jalr	-1318(ra) # 80205fc6 <wait_proc>
            if (index >= 0 && index < USER_TEST_COUNT) {
    802004f4:	a811                	j	80200508 <console+0x2b0>
                printf("无效的用户测试序号\n");
    802004f6:	0000e517          	auipc	a0,0xe
    802004fa:	10a50513          	addi	a0,a0,266 # 8020e600 <user_test_table+0x418>
    802004fe:	00001097          	auipc	ra,0x1
    80200502:	890080e7          	jalr	-1904(ra) # 80200d8e <printf>
        } else if (input_buffer[0] == 'u' || input_buffer[0] == 'U') {
    80200506:	a03d                	j	80200534 <console+0x2dc>
    80200508:	a035                	j	80200534 <console+0x2dc>
            printf("无效命令: %s\n", input_buffer);
    8020050a:	ed840793          	addi	a5,s0,-296
    8020050e:	85be                	mv	a1,a5
    80200510:	0000e517          	auipc	a0,0xe
    80200514:	11050513          	addi	a0,a0,272 # 8020e620 <user_test_table+0x438>
    80200518:	00001097          	auipc	ra,0x1
    8020051c:	876080e7          	jalr	-1930(ra) # 80200d8e <printf>
            printf("输入 'h' 查看帮助\n");
    80200520:	0000e517          	auipc	a0,0xe
    80200524:	11850513          	addi	a0,a0,280 # 8020e638 <user_test_table+0x450>
    80200528:	00001097          	auipc	ra,0x1
    8020052c:	866080e7          	jalr	-1946(ra) # 80200d8e <printf>
    80200530:	a011                	j	80200534 <console+0x2dc>
        if (input_buffer[0] == '\0') continue;
    80200532:	0001                	nop
    while (!exit_requested) {
    80200534:	fec42783          	lw	a5,-20(s0)
    80200538:	2781                	sext.w	a5,a5
    8020053a:	d2078ae3          	beqz	a5,8020026e <console+0x16>
    printf("控制台进程退出\n");
    8020053e:	0000e517          	auipc	a0,0xe
    80200542:	11a50513          	addi	a0,a0,282 # 8020e658 <user_test_table+0x470>
    80200546:	00001097          	auipc	ra,0x1
    8020054a:	848080e7          	jalr	-1976(ra) # 80200d8e <printf>
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
    80200568:	11a080e7          	jalr	282(ra) # 8020a67e <iget>
    8020056c:	fea43423          	sd	a0,-24(s0)
    if (rootip == 0) {
    80200570:	fe843783          	ld	a5,-24(s0)
    80200574:	eb89                	bnez	a5,80200586 <kernel_main+0x2e>
        panic("KERNEL_MAIN: cannot get root inode!\n");
    80200576:	0000e517          	auipc	a0,0xe
    8020057a:	0fa50513          	addi	a0,a0,250 # 8020e670 <user_test_table+0x488>
    8020057e:	00001097          	auipc	ra,0x1
    80200582:	25c080e7          	jalr	604(ra) # 802017da <panic>
    myproc()->cwd = rootip;
    80200586:	00005097          	auipc	ra,0x5
    8020058a:	aba080e7          	jalr	-1350(ra) # 80205040 <myproc>
    8020058e:	872a                	mv	a4,a0
    80200590:	fe843783          	ld	a5,-24(s0)
    80200594:	e77c                	sd	a5,200(a4)
	virtio_disk_init();   // 1. 初始化磁盘驱动
    80200596:	00008097          	auipc	ra,0x8
    8020059a:	878080e7          	jalr	-1928(ra) # 80207e0e <virtio_disk_init>
    binit();              // 2. 初始化块缓冲区
    8020059e:	00008097          	auipc	ra,0x8
    802005a2:	310080e7          	jalr	784(ra) # 802088ae <binit>
    fileinit();           // 3. 初始化文件表
    802005a6:	00009097          	auipc	ra,0x9
    802005aa:	fc6080e7          	jalr	-58(ra) # 8020956c <fileinit>
    iinit();              // 4. 初始化 inode 表
    802005ae:	0000a097          	auipc	ra,0xa
    802005b2:	e64080e7          	jalr	-412(ra) # 8020a412 <iinit>
    fsinit(ROOTDEV);      // 5. 初始化文件系统（会自动调用 initlog）
    802005b6:	4505                	li	a0,1
    802005b8:	0000a097          	auipc	ra,0xa
    802005bc:	aaa080e7          	jalr	-1366(ra) # 8020a062 <fsinit>
	clear_screen();
    802005c0:	00001097          	auipc	ra,0x1
    802005c4:	ce6080e7          	jalr	-794(ra) # 802012a6 <clear_screen>
	int console_pid = create_kernel_proc(console);
    802005c8:	00000517          	auipc	a0,0x0
    802005cc:	c9050513          	addi	a0,a0,-880 # 80200258 <console>
    802005d0:	00005097          	auipc	ra,0x5
    802005d4:	0d6080e7          	jalr	214(ra) # 802056a6 <create_kernel_proc>
    802005d8:	87aa                	mv	a5,a0
    802005da:	fef42223          	sw	a5,-28(s0)
	if (console_pid < 0){
    802005de:	fe442783          	lw	a5,-28(s0)
    802005e2:	2781                	sext.w	a5,a5
    802005e4:	0007db63          	bgez	a5,802005fa <kernel_main+0xa2>
		panic("KERNEL_MAIN: create console process failed!\n");
    802005e8:	0000e517          	auipc	a0,0xe
    802005ec:	0b050513          	addi	a0,a0,176 # 8020e698 <user_test_table+0x4b0>
    802005f0:	00001097          	auipc	ra,0x1
    802005f4:	1ea080e7          	jalr	490(ra) # 802017da <panic>
    802005f8:	a821                	j	80200610 <kernel_main+0xb8>
		printf("KERNEL_MAIN: console process created with PID %d\n", console_pid);
    802005fa:	fe442783          	lw	a5,-28(s0)
    802005fe:	85be                	mv	a1,a5
    80200600:	0000e517          	auipc	a0,0xe
    80200604:	0c850513          	addi	a0,a0,200 # 8020e6c8 <user_test_table+0x4e0>
    80200608:	00000097          	auipc	ra,0x0
    8020060c:	786080e7          	jalr	1926(ra) # 80200d8e <printf>
	int pid = wait_proc(&status);
    80200610:	fdc40793          	addi	a5,s0,-36
    80200614:	853e                	mv	a0,a5
    80200616:	00006097          	auipc	ra,0x6
    8020061a:	9b0080e7          	jalr	-1616(ra) # 80205fc6 <wait_proc>
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
    80200642:	0000e517          	auipc	a0,0xe
    80200646:	0be50513          	addi	a0,a0,190 # 8020e700 <user_test_table+0x518>
    8020064a:	00000097          	auipc	ra,0x0
    8020064e:	744080e7          	jalr	1860(ra) # 80200d8e <printf>
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
    80200696:	116080e7          	jalr	278(ra) # 802037a8 <register_interrupt>
    enable_interrupts(UART0_IRQ);
    8020069a:	4529                	li	a0,10
    8020069c:	00003097          	auipc	ra,0x3
    802006a0:	196080e7          	jalr	406(ra) # 80203832 <enable_interrupts>
    printf("UART initialized with input support\n");
    802006a4:	00010517          	auipc	a0,0x10
    802006a8:	15450513          	addi	a0,a0,340 # 802107f8 <user_test_table+0x78>
    802006ac:	00000097          	auipc	ra,0x0
    802006b0:	6e2080e7          	jalr	1762(ra) # 80200d8e <printf>
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
    802007d8:	ad2080e7          	jalr	-1326(ra) # 802012a6 <clear_screen>
			if (myproc()->pid == 1){ // 检查当前进程是否为控制台进程
    802007dc:	00005097          	auipc	ra,0x5
    802007e0:	864080e7          	jalr	-1948(ra) # 80205040 <myproc>
    802007e4:	87aa                	mv	a5,a0
    802007e6:	43dc                	lw	a5,4(a5)
    802007e8:	873e                	mv	a4,a5
    802007ea:	4785                	li	a5,1
    802007ec:	1ef71b63          	bne	a4,a5,802009e2 <uart_intr+0x232>
				printf("Console >>> ");
    802007f0:	00010517          	auipc	a0,0x10
    802007f4:	03050513          	addi	a0,a0,48 # 80210820 <user_test_table+0xa0>
    802007f8:	00000097          	auipc	ra,0x0
    802007fc:	596080e7          	jalr	1430(ra) # 80200d8e <printf>
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
    8020082e:	0003c797          	auipc	a5,0x3c
    80200832:	8a278793          	addi	a5,a5,-1886 # 8023c0d0 <uart_input_buf>
    80200836:	0847a783          	lw	a5,132(a5)
    8020083a:	2785                	addiw	a5,a5,1
    8020083c:	2781                	sext.w	a5,a5
    8020083e:	2781                	sext.w	a5,a5
    80200840:	07f7f793          	andi	a5,a5,127
    80200844:	fef42023          	sw	a5,-32(s0)
                if (next != uart_input_buf.r) {
    80200848:	0003c797          	auipc	a5,0x3c
    8020084c:	88878793          	addi	a5,a5,-1912 # 8023c0d0 <uart_input_buf>
    80200850:	0807a703          	lw	a4,128(a5)
    80200854:	fe042783          	lw	a5,-32(s0)
    80200858:	04f70363          	beq	a4,a5,8020089e <uart_intr+0xee>
                    uart_input_buf.buf[uart_input_buf.w] = linebuf[i];
    8020085c:	0003c797          	auipc	a5,0x3c
    80200860:	87478793          	addi	a5,a5,-1932 # 8023c0d0 <uart_input_buf>
    80200864:	0847a603          	lw	a2,132(a5)
    80200868:	0003c717          	auipc	a4,0x3c
    8020086c:	8f870713          	addi	a4,a4,-1800 # 8023c160 <linebuf.1>
    80200870:	fec42783          	lw	a5,-20(s0)
    80200874:	97ba                	add	a5,a5,a4
    80200876:	0007c703          	lbu	a4,0(a5)
    8020087a:	0003c697          	auipc	a3,0x3c
    8020087e:	85668693          	addi	a3,a3,-1962 # 8023c0d0 <uart_input_buf>
    80200882:	02061793          	slli	a5,a2,0x20
    80200886:	9381                	srli	a5,a5,0x20
    80200888:	97b6                	add	a5,a5,a3
    8020088a:	00e78023          	sb	a4,0(a5)
                    uart_input_buf.w = next;
    8020088e:	fe042703          	lw	a4,-32(s0)
    80200892:	0003c797          	auipc	a5,0x3c
    80200896:	83e78793          	addi	a5,a5,-1986 # 8023c0d0 <uart_input_buf>
    8020089a:	08e7a223          	sw	a4,132(a5)
            for (int i = 0; i < line_len; i++) {
    8020089e:	fec42783          	lw	a5,-20(s0)
    802008a2:	2785                	addiw	a5,a5,1
    802008a4:	fef42623          	sw	a5,-20(s0)
    802008a8:	0003c797          	auipc	a5,0x3c
    802008ac:	93878793          	addi	a5,a5,-1736 # 8023c1e0 <line_len.0>
    802008b0:	4398                	lw	a4,0(a5)
    802008b2:	fec42783          	lw	a5,-20(s0)
    802008b6:	2781                	sext.w	a5,a5
    802008b8:	f6e7cbe3          	blt	a5,a4,8020082e <uart_intr+0x7e>
                }
            }
            // 写入换行符
            int next = (uart_input_buf.w + 1) % INPUT_BUF_SIZE;
    802008bc:	0003c797          	auipc	a5,0x3c
    802008c0:	81478793          	addi	a5,a5,-2028 # 8023c0d0 <uart_input_buf>
    802008c4:	0847a783          	lw	a5,132(a5)
    802008c8:	2785                	addiw	a5,a5,1
    802008ca:	2781                	sext.w	a5,a5
    802008cc:	2781                	sext.w	a5,a5
    802008ce:	07f7f793          	andi	a5,a5,127
    802008d2:	fef42223          	sw	a5,-28(s0)
            if (next != uart_input_buf.r) {
    802008d6:	0003b797          	auipc	a5,0x3b
    802008da:	7fa78793          	addi	a5,a5,2042 # 8023c0d0 <uart_input_buf>
    802008de:	0807a703          	lw	a4,128(a5)
    802008e2:	fe442783          	lw	a5,-28(s0)
    802008e6:	02f70a63          	beq	a4,a5,8020091a <uart_intr+0x16a>
                uart_input_buf.buf[uart_input_buf.w] = '\n';
    802008ea:	0003b797          	auipc	a5,0x3b
    802008ee:	7e678793          	addi	a5,a5,2022 # 8023c0d0 <uart_input_buf>
    802008f2:	0847a783          	lw	a5,132(a5)
    802008f6:	0003b717          	auipc	a4,0x3b
    802008fa:	7da70713          	addi	a4,a4,2010 # 8023c0d0 <uart_input_buf>
    802008fe:	1782                	slli	a5,a5,0x20
    80200900:	9381                	srli	a5,a5,0x20
    80200902:	97ba                	add	a5,a5,a4
    80200904:	4729                	li	a4,10
    80200906:	00e78023          	sb	a4,0(a5)
                uart_input_buf.w = next;
    8020090a:	fe442703          	lw	a4,-28(s0)
    8020090e:	0003b797          	auipc	a5,0x3b
    80200912:	7c278793          	addi	a5,a5,1986 # 8023c0d0 <uart_input_buf>
    80200916:	08e7a223          	sw	a4,132(a5)
            }
            line_len = 0;
    8020091a:	0003c797          	auipc	a5,0x3c
    8020091e:	8c678793          	addi	a5,a5,-1850 # 8023c1e0 <line_len.0>
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
    80200946:	0003c797          	auipc	a5,0x3c
    8020094a:	89a78793          	addi	a5,a5,-1894 # 8023c1e0 <line_len.0>
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
    80200974:	0003c797          	auipc	a5,0x3c
    80200978:	86c78793          	addi	a5,a5,-1940 # 8023c1e0 <line_len.0>
    8020097c:	439c                	lw	a5,0(a5)
    8020097e:	37fd                	addiw	a5,a5,-1
    80200980:	0007871b          	sext.w	a4,a5
    80200984:	0003c797          	auipc	a5,0x3c
    80200988:	85c78793          	addi	a5,a5,-1956 # 8023c1e0 <line_len.0>
    8020098c:	c398                	sw	a4,0(a5)
            if (line_len > 0) {
    8020098e:	a899                	j	802009e4 <uart_intr+0x234>
            }
        } else if (line_len < LINE_BUF_SIZE - 1) {
    80200990:	0003c797          	auipc	a5,0x3c
    80200994:	85078793          	addi	a5,a5,-1968 # 8023c1e0 <line_len.0>
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
    802009b2:	0003c797          	auipc	a5,0x3c
    802009b6:	82e78793          	addi	a5,a5,-2002 # 8023c1e0 <line_len.0>
    802009ba:	439c                	lw	a5,0(a5)
    802009bc:	0017871b          	addiw	a4,a5,1
    802009c0:	0007069b          	sext.w	a3,a4
    802009c4:	0003c717          	auipc	a4,0x3c
    802009c8:	81c70713          	addi	a4,a4,-2020 # 8023c1e0 <line_len.0>
    802009cc:	c314                	sw	a3,0(a4)
    802009ce:	0003b717          	auipc	a4,0x3b
    802009d2:	79270713          	addi	a4,a4,1938 # 8023c160 <linebuf.1>
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
    80200a12:	0003b797          	auipc	a5,0x3b
    80200a16:	6be78793          	addi	a5,a5,1726 # 8023c0d0 <uart_input_buf>
    80200a1a:	0807a703          	lw	a4,128(a5)
    80200a1e:	0003b797          	auipc	a5,0x3b
    80200a22:	6b278793          	addi	a5,a5,1714 # 8023c0d0 <uart_input_buf>
    80200a26:	0847a783          	lw	a5,132(a5)
    80200a2a:	fef703e3          	beq	a4,a5,80200a10 <uart_getc_blocking+0x8>
    }
    
    // 读取字符
    char c = uart_input_buf.buf[uart_input_buf.r];
    80200a2e:	0003b797          	auipc	a5,0x3b
    80200a32:	6a278793          	addi	a5,a5,1698 # 8023c0d0 <uart_input_buf>
    80200a36:	0807a783          	lw	a5,128(a5)
    80200a3a:	0003b717          	auipc	a4,0x3b
    80200a3e:	69670713          	addi	a4,a4,1686 # 8023c0d0 <uart_input_buf>
    80200a42:	1782                	slli	a5,a5,0x20
    80200a44:	9381                	srli	a5,a5,0x20
    80200a46:	97ba                	add	a5,a5,a4
    80200a48:	0007c783          	lbu	a5,0(a5)
    80200a4c:	fef407a3          	sb	a5,-17(s0)
    uart_input_buf.r = (uart_input_buf.r + 1) % INPUT_BUF_SIZE;
    80200a50:	0003b797          	auipc	a5,0x3b
    80200a54:	68078793          	addi	a5,a5,1664 # 8023c0d0 <uart_input_buf>
    80200a58:	0807a783          	lw	a5,128(a5)
    80200a5c:	2785                	addiw	a5,a5,1
    80200a5e:	2781                	sext.w	a5,a5
    80200a60:	07f7f793          	andi	a5,a5,127
    80200a64:	0007871b          	sext.w	a4,a5
    80200a68:	0003b797          	auipc	a5,0x3b
    80200a6c:	66878793          	addi	a5,a5,1640 # 8023c0d0 <uart_input_buf>
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
    80200b22:	0003b797          	auipc	a5,0x3b
    80200b26:	74678793          	addi	a5,a5,1862 # 8023c268 <printf_buf_pos>
    80200b2a:	439c                	lw	a5,0(a5)
    80200b2c:	02f05c63          	blez	a5,80200b64 <flush_printf_buffer+0x4a>
		printf_buffer[printf_buf_pos] = '\0'; // Null-terminate the string
    80200b30:	0003b797          	auipc	a5,0x3b
    80200b34:	73878793          	addi	a5,a5,1848 # 8023c268 <printf_buf_pos>
    80200b38:	439c                	lw	a5,0(a5)
    80200b3a:	0003b717          	auipc	a4,0x3b
    80200b3e:	6ae70713          	addi	a4,a4,1710 # 8023c1e8 <printf_buffer>
    80200b42:	97ba                	add	a5,a5,a4
    80200b44:	00078023          	sb	zero,0(a5)
		uart_puts(printf_buffer); // Send the buffer to UART
    80200b48:	0003b517          	auipc	a0,0x3b
    80200b4c:	6a050513          	addi	a0,a0,1696 # 8023c1e8 <printf_buffer>
    80200b50:	00000097          	auipc	ra,0x0
    80200b54:	ba8080e7          	jalr	-1112(ra) # 802006f8 <uart_puts>
		printf_buf_pos = 0; // Reset buffer position
    80200b58:	0003b797          	auipc	a5,0x3b
    80200b5c:	71078793          	addi	a5,a5,1808 # 8023c268 <printf_buf_pos>
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
    80200b7c:	0003b797          	auipc	a5,0x3b
    80200b80:	6ec78793          	addi	a5,a5,1772 # 8023c268 <printf_buf_pos>
    80200b84:	439c                	lw	a5,0(a5)
    80200b86:	873e                	mv	a4,a5
    80200b88:	07e00793          	li	a5,126
    80200b8c:	02e7ca63          	blt	a5,a4,80200bc0 <buffer_char+0x52>
		printf_buffer[printf_buf_pos++] = c;
    80200b90:	0003b797          	auipc	a5,0x3b
    80200b94:	6d878793          	addi	a5,a5,1752 # 8023c268 <printf_buf_pos>
    80200b98:	439c                	lw	a5,0(a5)
    80200b9a:	0017871b          	addiw	a4,a5,1
    80200b9e:	0007069b          	sext.w	a3,a4
    80200ba2:	0003b717          	auipc	a4,0x3b
    80200ba6:	6c670713          	addi	a4,a4,1734 # 8023c268 <printf_buf_pos>
    80200baa:	c314                	sw	a3,0(a4)
    80200bac:	0003b717          	auipc	a4,0x3b
    80200bb0:	63c70713          	addi	a4,a4,1596 # 8023c1e8 <printf_buffer>
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
    80200bc8:	0003b797          	auipc	a5,0x3b
    80200bcc:	6a078793          	addi	a5,a5,1696 # 8023c268 <printf_buf_pos>
    80200bd0:	439c                	lw	a5,0(a5)
    80200bd2:	0017871b          	addiw	a4,a5,1
    80200bd6:	0007069b          	sext.w	a3,a4
    80200bda:	0003b717          	auipc	a4,0x3b
    80200bde:	68e70713          	addi	a4,a4,1678 # 8023c268 <printf_buf_pos>
    80200be2:	c314                	sw	a3,0(a4)
    80200be4:	0003b717          	auipc	a4,0x3b
    80200be8:	60470713          	addi	a4,a4,1540 # 8023c1e8 <printf_buffer>
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
    80200cc8:	0003b697          	auipc	a3,0x3b
    80200ccc:	3b868693          	addi	a3,a3,952 # 8023c080 <digits.0>
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

0000000080200d8e <printf>:
void printf(const char *fmt, ...) {
    80200d8e:	7171                	addi	sp,sp,-176
    80200d90:	f486                	sd	ra,104(sp)
    80200d92:	f0a2                	sd	s0,96(sp)
    80200d94:	1880                	addi	s0,sp,112
    80200d96:	f8a43c23          	sd	a0,-104(s0)
    80200d9a:	e40c                	sd	a1,8(s0)
    80200d9c:	e810                	sd	a2,16(s0)
    80200d9e:	ec14                	sd	a3,24(s0)
    80200da0:	f018                	sd	a4,32(s0)
    80200da2:	f41c                	sd	a5,40(s0)
    80200da4:	03043823          	sd	a6,48(s0)
    80200da8:	03143c23          	sd	a7,56(s0)
    va_list ap;
    int i, c;
    char *s;

    va_start(ap, fmt);
    80200dac:	04040793          	addi	a5,s0,64
    80200db0:	f8f43823          	sd	a5,-112(s0)
    80200db4:	f9043783          	ld	a5,-112(s0)
    80200db8:	fc878793          	addi	a5,a5,-56
    80200dbc:	faf43c23          	sd	a5,-72(s0)
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80200dc0:	fe042623          	sw	zero,-20(s0)
    80200dc4:	a945                	j	80201274 <printf+0x4e6>
        if(c != '%'){
    80200dc6:	fe842783          	lw	a5,-24(s0)
    80200dca:	0007871b          	sext.w	a4,a5
    80200dce:	02500793          	li	a5,37
    80200dd2:	00f70c63          	beq	a4,a5,80200dea <printf+0x5c>
            buffer_char(c);
    80200dd6:	fe842783          	lw	a5,-24(s0)
    80200dda:	0ff7f793          	zext.b	a5,a5
    80200dde:	853e                	mv	a0,a5
    80200de0:	00000097          	auipc	ra,0x0
    80200de4:	d8e080e7          	jalr	-626(ra) # 80200b6e <buffer_char>
            continue;
    80200de8:	a149                	j	8020126a <printf+0x4dc>
        }
        flush_printf_buffer(); // 遇到格式化标志时，先刷新缓冲区
    80200dea:	00000097          	auipc	ra,0x0
    80200dee:	d30080e7          	jalr	-720(ra) # 80200b1a <flush_printf_buffer>
		// 解析填充标志和宽度
        int padzero = 0, width = 0;
    80200df2:	fc042e23          	sw	zero,-36(s0)
    80200df6:	fc042c23          	sw	zero,-40(s0)
        c = fmt[++i] & 0xff;
    80200dfa:	fec42783          	lw	a5,-20(s0)
    80200dfe:	2785                	addiw	a5,a5,1
    80200e00:	fef42623          	sw	a5,-20(s0)
    80200e04:	fec42783          	lw	a5,-20(s0)
    80200e08:	f9843703          	ld	a4,-104(s0)
    80200e0c:	97ba                	add	a5,a5,a4
    80200e0e:	0007c783          	lbu	a5,0(a5)
    80200e12:	fef42423          	sw	a5,-24(s0)
        if (c == '0') {
    80200e16:	fe842783          	lw	a5,-24(s0)
    80200e1a:	0007871b          	sext.w	a4,a5
    80200e1e:	03000793          	li	a5,48
    80200e22:	06f71563          	bne	a4,a5,80200e8c <printf+0xfe>
            padzero = 1;
    80200e26:	4785                	li	a5,1
    80200e28:	fcf42e23          	sw	a5,-36(s0)
            c = fmt[++i] & 0xff;
    80200e2c:	fec42783          	lw	a5,-20(s0)
    80200e30:	2785                	addiw	a5,a5,1
    80200e32:	fef42623          	sw	a5,-20(s0)
    80200e36:	fec42783          	lw	a5,-20(s0)
    80200e3a:	f9843703          	ld	a4,-104(s0)
    80200e3e:	97ba                	add	a5,a5,a4
    80200e40:	0007c783          	lbu	a5,0(a5)
    80200e44:	fef42423          	sw	a5,-24(s0)
        }
        while (c >= '0' && c <= '9') {
    80200e48:	a091                	j	80200e8c <printf+0xfe>
            width = width * 10 + (c - '0');
    80200e4a:	fd842783          	lw	a5,-40(s0)
    80200e4e:	873e                	mv	a4,a5
    80200e50:	87ba                	mv	a5,a4
    80200e52:	0027979b          	slliw	a5,a5,0x2
    80200e56:	9fb9                	addw	a5,a5,a4
    80200e58:	0017979b          	slliw	a5,a5,0x1
    80200e5c:	0007871b          	sext.w	a4,a5
    80200e60:	fe842783          	lw	a5,-24(s0)
    80200e64:	fd07879b          	addiw	a5,a5,-48
    80200e68:	2781                	sext.w	a5,a5
    80200e6a:	9fb9                	addw	a5,a5,a4
    80200e6c:	fcf42c23          	sw	a5,-40(s0)
            c = fmt[++i] & 0xff;
    80200e70:	fec42783          	lw	a5,-20(s0)
    80200e74:	2785                	addiw	a5,a5,1
    80200e76:	fef42623          	sw	a5,-20(s0)
    80200e7a:	fec42783          	lw	a5,-20(s0)
    80200e7e:	f9843703          	ld	a4,-104(s0)
    80200e82:	97ba                	add	a5,a5,a4
    80200e84:	0007c783          	lbu	a5,0(a5)
    80200e88:	fef42423          	sw	a5,-24(s0)
        while (c >= '0' && c <= '9') {
    80200e8c:	fe842783          	lw	a5,-24(s0)
    80200e90:	0007871b          	sext.w	a4,a5
    80200e94:	02f00793          	li	a5,47
    80200e98:	00e7da63          	bge	a5,a4,80200eac <printf+0x11e>
    80200e9c:	fe842783          	lw	a5,-24(s0)
    80200ea0:	0007871b          	sext.w	a4,a5
    80200ea4:	03900793          	li	a5,57
    80200ea8:	fae7d1e3          	bge	a5,a4,80200e4a <printf+0xbc>
        }
        // 检查是否有长整型标记'l'
        int is_long = 0;
    80200eac:	fc042a23          	sw	zero,-44(s0)
        if(c == 'l') {
    80200eb0:	fe842783          	lw	a5,-24(s0)
    80200eb4:	0007871b          	sext.w	a4,a5
    80200eb8:	06c00793          	li	a5,108
    80200ebc:	02f71863          	bne	a4,a5,80200eec <printf+0x15e>
            is_long = 1;
    80200ec0:	4785                	li	a5,1
    80200ec2:	fcf42a23          	sw	a5,-44(s0)
            c = fmt[++i] & 0xff;
    80200ec6:	fec42783          	lw	a5,-20(s0)
    80200eca:	2785                	addiw	a5,a5,1
    80200ecc:	fef42623          	sw	a5,-20(s0)
    80200ed0:	fec42783          	lw	a5,-20(s0)
    80200ed4:	f9843703          	ld	a4,-104(s0)
    80200ed8:	97ba                	add	a5,a5,a4
    80200eda:	0007c783          	lbu	a5,0(a5)
    80200ede:	fef42423          	sw	a5,-24(s0)
            if(c == 0)
    80200ee2:	fe842783          	lw	a5,-24(s0)
    80200ee6:	2781                	sext.w	a5,a5
    80200ee8:	3a078563          	beqz	a5,80201292 <printf+0x504>
                break;
        }
        
        switch(c){
    80200eec:	fe842783          	lw	a5,-24(s0)
    80200ef0:	0007871b          	sext.w	a4,a5
    80200ef4:	02500793          	li	a5,37
    80200ef8:	2ef70d63          	beq	a4,a5,802011f2 <printf+0x464>
    80200efc:	fe842783          	lw	a5,-24(s0)
    80200f00:	0007871b          	sext.w	a4,a5
    80200f04:	02500793          	li	a5,37
    80200f08:	2ef74c63          	blt	a4,a5,80201200 <printf+0x472>
    80200f0c:	fe842783          	lw	a5,-24(s0)
    80200f10:	0007871b          	sext.w	a4,a5
    80200f14:	07800793          	li	a5,120
    80200f18:	2ee7c463          	blt	a5,a4,80201200 <printf+0x472>
    80200f1c:	fe842783          	lw	a5,-24(s0)
    80200f20:	0007871b          	sext.w	a4,a5
    80200f24:	06200793          	li	a5,98
    80200f28:	2cf74c63          	blt	a4,a5,80201200 <printf+0x472>
    80200f2c:	fe842783          	lw	a5,-24(s0)
    80200f30:	f9e7869b          	addiw	a3,a5,-98
    80200f34:	0006871b          	sext.w	a4,a3
    80200f38:	47d9                	li	a5,22
    80200f3a:	2ce7e363          	bltu	a5,a4,80201200 <printf+0x472>
    80200f3e:	02069793          	slli	a5,a3,0x20
    80200f42:	9381                	srli	a5,a5,0x20
    80200f44:	00279713          	slli	a4,a5,0x2
    80200f48:	00012797          	auipc	a5,0x12
    80200f4c:	9bc78793          	addi	a5,a5,-1604 # 80212904 <user_test_table+0x9c>
    80200f50:	97ba                	add	a5,a5,a4
    80200f52:	439c                	lw	a5,0(a5)
    80200f54:	0007871b          	sext.w	a4,a5
    80200f58:	00012797          	auipc	a5,0x12
    80200f5c:	9ac78793          	addi	a5,a5,-1620 # 80212904 <user_test_table+0x9c>
    80200f60:	97ba                	add	a5,a5,a4
    80200f62:	8782                	jr	a5
        case 'd':
            if(is_long)
    80200f64:	fd442783          	lw	a5,-44(s0)
    80200f68:	2781                	sext.w	a5,a5
    80200f6a:	c785                	beqz	a5,80200f92 <printf+0x204>
                printint(va_arg(ap, long long), 10, 1, width, padzero);
    80200f6c:	fb843783          	ld	a5,-72(s0)
    80200f70:	00878713          	addi	a4,a5,8
    80200f74:	fae43c23          	sd	a4,-72(s0)
    80200f78:	639c                	ld	a5,0(a5)
    80200f7a:	fdc42703          	lw	a4,-36(s0)
    80200f7e:	fd842683          	lw	a3,-40(s0)
    80200f82:	4605                	li	a2,1
    80200f84:	45a9                	li	a1,10
    80200f86:	853e                	mv	a0,a5
    80200f88:	00000097          	auipc	ra,0x0
    80200f8c:	ccc080e7          	jalr	-820(ra) # 80200c54 <printint>
            else
                printint(va_arg(ap, int), 10, 1, width, padzero);
            break;
    80200f90:	ace9                	j	8020126a <printf+0x4dc>
                printint(va_arg(ap, int), 10, 1, width, padzero);
    80200f92:	fb843783          	ld	a5,-72(s0)
    80200f96:	00878713          	addi	a4,a5,8
    80200f9a:	fae43c23          	sd	a4,-72(s0)
    80200f9e:	439c                	lw	a5,0(a5)
    80200fa0:	853e                	mv	a0,a5
    80200fa2:	fdc42703          	lw	a4,-36(s0)
    80200fa6:	fd842783          	lw	a5,-40(s0)
    80200faa:	86be                	mv	a3,a5
    80200fac:	4605                	li	a2,1
    80200fae:	45a9                	li	a1,10
    80200fb0:	00000097          	auipc	ra,0x0
    80200fb4:	ca4080e7          	jalr	-860(ra) # 80200c54 <printint>
            break;
    80200fb8:	ac4d                	j	8020126a <printf+0x4dc>
        case 'x':
            if(is_long)
    80200fba:	fd442783          	lw	a5,-44(s0)
    80200fbe:	2781                	sext.w	a5,a5
    80200fc0:	c785                	beqz	a5,80200fe8 <printf+0x25a>
                printint(va_arg(ap, long long), 16, 0, width, padzero);
    80200fc2:	fb843783          	ld	a5,-72(s0)
    80200fc6:	00878713          	addi	a4,a5,8
    80200fca:	fae43c23          	sd	a4,-72(s0)
    80200fce:	639c                	ld	a5,0(a5)
    80200fd0:	fdc42703          	lw	a4,-36(s0)
    80200fd4:	fd842683          	lw	a3,-40(s0)
    80200fd8:	4601                	li	a2,0
    80200fda:	45c1                	li	a1,16
    80200fdc:	853e                	mv	a0,a5
    80200fde:	00000097          	auipc	ra,0x0
    80200fe2:	c76080e7          	jalr	-906(ra) # 80200c54 <printint>
            else
                printint(va_arg(ap, int), 16, 0, width, padzero);
            break;
    80200fe6:	a451                	j	8020126a <printf+0x4dc>
                printint(va_arg(ap, int), 16, 0, width, padzero);
    80200fe8:	fb843783          	ld	a5,-72(s0)
    80200fec:	00878713          	addi	a4,a5,8
    80200ff0:	fae43c23          	sd	a4,-72(s0)
    80200ff4:	439c                	lw	a5,0(a5)
    80200ff6:	853e                	mv	a0,a5
    80200ff8:	fdc42703          	lw	a4,-36(s0)
    80200ffc:	fd842783          	lw	a5,-40(s0)
    80201000:	86be                	mv	a3,a5
    80201002:	4601                	li	a2,0
    80201004:	45c1                	li	a1,16
    80201006:	00000097          	auipc	ra,0x0
    8020100a:	c4e080e7          	jalr	-946(ra) # 80200c54 <printint>
            break;
    8020100e:	acb1                	j	8020126a <printf+0x4dc>
        case 'u':
            if(is_long)
    80201010:	fd442783          	lw	a5,-44(s0)
    80201014:	2781                	sext.w	a5,a5
    80201016:	c78d                	beqz	a5,80201040 <printf+0x2b2>
                printint(va_arg(ap, unsigned long long), 10, 0, width, padzero);
    80201018:	fb843783          	ld	a5,-72(s0)
    8020101c:	00878713          	addi	a4,a5,8
    80201020:	fae43c23          	sd	a4,-72(s0)
    80201024:	639c                	ld	a5,0(a5)
    80201026:	853e                	mv	a0,a5
    80201028:	fdc42703          	lw	a4,-36(s0)
    8020102c:	fd842783          	lw	a5,-40(s0)
    80201030:	86be                	mv	a3,a5
    80201032:	4601                	li	a2,0
    80201034:	45a9                	li	a1,10
    80201036:	00000097          	auipc	ra,0x0
    8020103a:	c1e080e7          	jalr	-994(ra) # 80200c54 <printint>
            else
                printint(va_arg(ap, unsigned int), 10, 0, width, padzero);
            break;
    8020103e:	a435                	j	8020126a <printf+0x4dc>
                printint(va_arg(ap, unsigned int), 10, 0, width, padzero);
    80201040:	fb843783          	ld	a5,-72(s0)
    80201044:	00878713          	addi	a4,a5,8
    80201048:	fae43c23          	sd	a4,-72(s0)
    8020104c:	439c                	lw	a5,0(a5)
    8020104e:	1782                	slli	a5,a5,0x20
    80201050:	9381                	srli	a5,a5,0x20
    80201052:	fdc42703          	lw	a4,-36(s0)
    80201056:	fd842683          	lw	a3,-40(s0)
    8020105a:	4601                	li	a2,0
    8020105c:	45a9                	li	a1,10
    8020105e:	853e                	mv	a0,a5
    80201060:	00000097          	auipc	ra,0x0
    80201064:	bf4080e7          	jalr	-1036(ra) # 80200c54 <printint>
            break;
    80201068:	a409                	j	8020126a <printf+0x4dc>
        case 'c':
            consputc(va_arg(ap, int));
    8020106a:	fb843783          	ld	a5,-72(s0)
    8020106e:	00878713          	addi	a4,a5,8
    80201072:	fae43c23          	sd	a4,-72(s0)
    80201076:	439c                	lw	a5,0(a5)
    80201078:	853e                	mv	a0,a5
    8020107a:	00000097          	auipc	ra,0x0
    8020107e:	b86080e7          	jalr	-1146(ra) # 80200c00 <consputc>
            break;
    80201082:	a2e5                	j	8020126a <printf+0x4dc>
        case 's':
            if((s = va_arg(ap, char*)) == 0)
    80201084:	fb843783          	ld	a5,-72(s0)
    80201088:	00878713          	addi	a4,a5,8
    8020108c:	fae43c23          	sd	a4,-72(s0)
    80201090:	639c                	ld	a5,0(a5)
    80201092:	fef43023          	sd	a5,-32(s0)
    80201096:	fe043783          	ld	a5,-32(s0)
    8020109a:	e799                	bnez	a5,802010a8 <printf+0x31a>
                s = "(null)";
    8020109c:	00012797          	auipc	a5,0x12
    802010a0:	84478793          	addi	a5,a5,-1980 # 802128e0 <user_test_table+0x78>
    802010a4:	fef43023          	sd	a5,-32(s0)
            consputs(s);
    802010a8:	fe043503          	ld	a0,-32(s0)
    802010ac:	00000097          	auipc	ra,0x0
    802010b0:	b7e080e7          	jalr	-1154(ra) # 80200c2a <consputs>
            break;
    802010b4:	aa5d                	j	8020126a <printf+0x4dc>
        case 'p':
            unsigned long ptr = (unsigned long)va_arg(ap, void*);
    802010b6:	fb843783          	ld	a5,-72(s0)
    802010ba:	00878713          	addi	a4,a5,8
    802010be:	fae43c23          	sd	a4,-72(s0)
    802010c2:	639c                	ld	a5,0(a5)
    802010c4:	fcf43423          	sd	a5,-56(s0)
            consputs("0x");
    802010c8:	00012517          	auipc	a0,0x12
    802010cc:	82050513          	addi	a0,a0,-2016 # 802128e8 <user_test_table+0x80>
    802010d0:	00000097          	auipc	ra,0x0
    802010d4:	b5a080e7          	jalr	-1190(ra) # 80200c2a <consputs>
            // 输出16位宽，不足补0
            char buf[17];
            int i;
            for (i = 0; i < 16; i++) {
    802010d8:	fc042823          	sw	zero,-48(s0)
    802010dc:	a0a1                	j	80201124 <printf+0x396>
                int shift = (15 - i) * 4;
    802010de:	47bd                	li	a5,15
    802010e0:	fd042703          	lw	a4,-48(s0)
    802010e4:	9f99                	subw	a5,a5,a4
    802010e6:	2781                	sext.w	a5,a5
    802010e8:	0027979b          	slliw	a5,a5,0x2
    802010ec:	fcf42223          	sw	a5,-60(s0)
                buf[i] = "0123456789abcdef"[(ptr >> shift) & 0xf];
    802010f0:	fc442783          	lw	a5,-60(s0)
    802010f4:	873e                	mv	a4,a5
    802010f6:	fc843783          	ld	a5,-56(s0)
    802010fa:	00e7d7b3          	srl	a5,a5,a4
    802010fe:	8bbd                	andi	a5,a5,15
    80201100:	00011717          	auipc	a4,0x11
    80201104:	7f070713          	addi	a4,a4,2032 # 802128f0 <user_test_table+0x88>
    80201108:	97ba                	add	a5,a5,a4
    8020110a:	0007c703          	lbu	a4,0(a5)
    8020110e:	fd042783          	lw	a5,-48(s0)
    80201112:	17c1                	addi	a5,a5,-16
    80201114:	97a2                	add	a5,a5,s0
    80201116:	fae78823          	sb	a4,-80(a5)
            for (i = 0; i < 16; i++) {
    8020111a:	fd042783          	lw	a5,-48(s0)
    8020111e:	2785                	addiw	a5,a5,1
    80201120:	fcf42823          	sw	a5,-48(s0)
    80201124:	fd042783          	lw	a5,-48(s0)
    80201128:	0007871b          	sext.w	a4,a5
    8020112c:	47bd                	li	a5,15
    8020112e:	fae7d8e3          	bge	a5,a4,802010de <printf+0x350>
            }
            buf[16] = '\0';
    80201132:	fa040823          	sb	zero,-80(s0)
            consputs(buf);
    80201136:	fa040793          	addi	a5,s0,-96
    8020113a:	853e                	mv	a0,a5
    8020113c:	00000097          	auipc	ra,0x0
    80201140:	aee080e7          	jalr	-1298(ra) # 80200c2a <consputs>
            break;
    80201144:	a21d                	j	8020126a <printf+0x4dc>
        case 'b':
            if(is_long)
    80201146:	fd442783          	lw	a5,-44(s0)
    8020114a:	2781                	sext.w	a5,a5
    8020114c:	c785                	beqz	a5,80201174 <printf+0x3e6>
                printint(va_arg(ap, long long), 2, 0, width, padzero);
    8020114e:	fb843783          	ld	a5,-72(s0)
    80201152:	00878713          	addi	a4,a5,8
    80201156:	fae43c23          	sd	a4,-72(s0)
    8020115a:	639c                	ld	a5,0(a5)
    8020115c:	fdc42703          	lw	a4,-36(s0)
    80201160:	fd842683          	lw	a3,-40(s0)
    80201164:	4601                	li	a2,0
    80201166:	4589                	li	a1,2
    80201168:	853e                	mv	a0,a5
    8020116a:	00000097          	auipc	ra,0x0
    8020116e:	aea080e7          	jalr	-1302(ra) # 80200c54 <printint>
            else
                printint(va_arg(ap, int), 2, 0, width, padzero);
            break;
    80201172:	a8e5                	j	8020126a <printf+0x4dc>
                printint(va_arg(ap, int), 2, 0, width, padzero);
    80201174:	fb843783          	ld	a5,-72(s0)
    80201178:	00878713          	addi	a4,a5,8
    8020117c:	fae43c23          	sd	a4,-72(s0)
    80201180:	439c                	lw	a5,0(a5)
    80201182:	853e                	mv	a0,a5
    80201184:	fdc42703          	lw	a4,-36(s0)
    80201188:	fd842783          	lw	a5,-40(s0)
    8020118c:	86be                	mv	a3,a5
    8020118e:	4601                	li	a2,0
    80201190:	4589                	li	a1,2
    80201192:	00000097          	auipc	ra,0x0
    80201196:	ac2080e7          	jalr	-1342(ra) # 80200c54 <printint>
            break;
    8020119a:	a8c1                	j	8020126a <printf+0x4dc>
        case 'o':
            if(is_long)
    8020119c:	fd442783          	lw	a5,-44(s0)
    802011a0:	2781                	sext.w	a5,a5
    802011a2:	c785                	beqz	a5,802011ca <printf+0x43c>
                printint(va_arg(ap, long long), 8, 0, width, padzero);
    802011a4:	fb843783          	ld	a5,-72(s0)
    802011a8:	00878713          	addi	a4,a5,8
    802011ac:	fae43c23          	sd	a4,-72(s0)
    802011b0:	639c                	ld	a5,0(a5)
    802011b2:	fdc42703          	lw	a4,-36(s0)
    802011b6:	fd842683          	lw	a3,-40(s0)
    802011ba:	4601                	li	a2,0
    802011bc:	45a1                	li	a1,8
    802011be:	853e                	mv	a0,a5
    802011c0:	00000097          	auipc	ra,0x0
    802011c4:	a94080e7          	jalr	-1388(ra) # 80200c54 <printint>
            else
                printint(va_arg(ap, int), 8, 0, width, padzero);
            break;
    802011c8:	a04d                	j	8020126a <printf+0x4dc>
                printint(va_arg(ap, int), 8, 0, width, padzero);
    802011ca:	fb843783          	ld	a5,-72(s0)
    802011ce:	00878713          	addi	a4,a5,8
    802011d2:	fae43c23          	sd	a4,-72(s0)
    802011d6:	439c                	lw	a5,0(a5)
    802011d8:	853e                	mv	a0,a5
    802011da:	fdc42703          	lw	a4,-36(s0)
    802011de:	fd842783          	lw	a5,-40(s0)
    802011e2:	86be                	mv	a3,a5
    802011e4:	4601                	li	a2,0
    802011e6:	45a1                	li	a1,8
    802011e8:	00000097          	auipc	ra,0x0
    802011ec:	a6c080e7          	jalr	-1428(ra) # 80200c54 <printint>
            break;
    802011f0:	a8ad                	j	8020126a <printf+0x4dc>
        case '%':
            buffer_char('%');
    802011f2:	02500513          	li	a0,37
    802011f6:	00000097          	auipc	ra,0x0
    802011fa:	978080e7          	jalr	-1672(ra) # 80200b6e <buffer_char>
            break;
    802011fe:	a0b5                	j	8020126a <printf+0x4dc>
        default:
            buffer_char('%');
    80201200:	02500513          	li	a0,37
    80201204:	00000097          	auipc	ra,0x0
    80201208:	96a080e7          	jalr	-1686(ra) # 80200b6e <buffer_char>
            if(padzero) buffer_char('0');
    8020120c:	fdc42783          	lw	a5,-36(s0)
    80201210:	2781                	sext.w	a5,a5
    80201212:	c799                	beqz	a5,80201220 <printf+0x492>
    80201214:	03000513          	li	a0,48
    80201218:	00000097          	auipc	ra,0x0
    8020121c:	956080e7          	jalr	-1706(ra) # 80200b6e <buffer_char>
            if(width) {
    80201220:	fd842783          	lw	a5,-40(s0)
    80201224:	2781                	sext.w	a5,a5
    80201226:	cf91                	beqz	a5,80201242 <printf+0x4b4>
                // 只支持一位宽度，简单处理
                buffer_char('0' + width);
    80201228:	fd842783          	lw	a5,-40(s0)
    8020122c:	0ff7f793          	zext.b	a5,a5
    80201230:	0307879b          	addiw	a5,a5,48
    80201234:	0ff7f793          	zext.b	a5,a5
    80201238:	853e                	mv	a0,a5
    8020123a:	00000097          	auipc	ra,0x0
    8020123e:	934080e7          	jalr	-1740(ra) # 80200b6e <buffer_char>
            }
            if(is_long) buffer_char('l');
    80201242:	fd442783          	lw	a5,-44(s0)
    80201246:	2781                	sext.w	a5,a5
    80201248:	c799                	beqz	a5,80201256 <printf+0x4c8>
    8020124a:	06c00513          	li	a0,108
    8020124e:	00000097          	auipc	ra,0x0
    80201252:	920080e7          	jalr	-1760(ra) # 80200b6e <buffer_char>
            buffer_char(c);
    80201256:	fe842783          	lw	a5,-24(s0)
    8020125a:	0ff7f793          	zext.b	a5,a5
    8020125e:	853e                	mv	a0,a5
    80201260:	00000097          	auipc	ra,0x0
    80201264:	90e080e7          	jalr	-1778(ra) # 80200b6e <buffer_char>
            break;
    80201268:	0001                	nop
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8020126a:	fec42783          	lw	a5,-20(s0)
    8020126e:	2785                	addiw	a5,a5,1
    80201270:	fef42623          	sw	a5,-20(s0)
    80201274:	fec42783          	lw	a5,-20(s0)
    80201278:	f9843703          	ld	a4,-104(s0)
    8020127c:	97ba                	add	a5,a5,a4
    8020127e:	0007c783          	lbu	a5,0(a5)
    80201282:	fef42423          	sw	a5,-24(s0)
    80201286:	fe842783          	lw	a5,-24(s0)
    8020128a:	2781                	sext.w	a5,a5
    8020128c:	b2079de3          	bnez	a5,80200dc6 <printf+0x38>
    80201290:	a011                	j	80201294 <printf+0x506>
                break;
    80201292:	0001                	nop
        }
    }
    flush_printf_buffer(); // 最后刷新缓冲区
    80201294:	00000097          	auipc	ra,0x0
    80201298:	886080e7          	jalr	-1914(ra) # 80200b1a <flush_printf_buffer>
    va_end(ap);
}
    8020129c:	0001                	nop
    8020129e:	70a6                	ld	ra,104(sp)
    802012a0:	7406                	ld	s0,96(sp)
    802012a2:	614d                	addi	sp,sp,176
    802012a4:	8082                	ret

00000000802012a6 <clear_screen>:
// 清屏功能
void clear_screen(void) {
    802012a6:	1141                	addi	sp,sp,-16
    802012a8:	e406                	sd	ra,8(sp)
    802012aa:	e022                	sd	s0,0(sp)
    802012ac:	0800                	addi	s0,sp,16
    uart_puts(CLEAR_SCREEN);
    802012ae:	00011517          	auipc	a0,0x11
    802012b2:	6b250513          	addi	a0,a0,1714 # 80212960 <user_test_table+0xf8>
    802012b6:	fffff097          	auipc	ra,0xfffff
    802012ba:	442080e7          	jalr	1090(ra) # 802006f8 <uart_puts>
	uart_puts(CURSOR_HOME);
    802012be:	00011517          	auipc	a0,0x11
    802012c2:	6aa50513          	addi	a0,a0,1706 # 80212968 <user_test_table+0x100>
    802012c6:	fffff097          	auipc	ra,0xfffff
    802012ca:	432080e7          	jalr	1074(ra) # 802006f8 <uart_puts>
}
    802012ce:	0001                	nop
    802012d0:	60a2                	ld	ra,8(sp)
    802012d2:	6402                	ld	s0,0(sp)
    802012d4:	0141                	addi	sp,sp,16
    802012d6:	8082                	ret

00000000802012d8 <cursor_up>:

// 光标上移
void cursor_up(int lines) {
    802012d8:	1101                	addi	sp,sp,-32
    802012da:	ec06                	sd	ra,24(sp)
    802012dc:	e822                	sd	s0,16(sp)
    802012de:	1000                	addi	s0,sp,32
    802012e0:	87aa                	mv	a5,a0
    802012e2:	fef42623          	sw	a5,-20(s0)
    if (lines <= 0) return;
    802012e6:	fec42783          	lw	a5,-20(s0)
    802012ea:	2781                	sext.w	a5,a5
    802012ec:	02f05f63          	blez	a5,8020132a <cursor_up+0x52>
    consputc('\033');
    802012f0:	456d                	li	a0,27
    802012f2:	00000097          	auipc	ra,0x0
    802012f6:	90e080e7          	jalr	-1778(ra) # 80200c00 <consputc>
    consputc('[');
    802012fa:	05b00513          	li	a0,91
    802012fe:	00000097          	auipc	ra,0x0
    80201302:	902080e7          	jalr	-1790(ra) # 80200c00 <consputc>
    printint(lines, 10, 0, 0,0);
    80201306:	fec42783          	lw	a5,-20(s0)
    8020130a:	4701                	li	a4,0
    8020130c:	4681                	li	a3,0
    8020130e:	4601                	li	a2,0
    80201310:	45a9                	li	a1,10
    80201312:	853e                	mv	a0,a5
    80201314:	00000097          	auipc	ra,0x0
    80201318:	940080e7          	jalr	-1728(ra) # 80200c54 <printint>
    consputc('A');
    8020131c:	04100513          	li	a0,65
    80201320:	00000097          	auipc	ra,0x0
    80201324:	8e0080e7          	jalr	-1824(ra) # 80200c00 <consputc>
    80201328:	a011                	j	8020132c <cursor_up+0x54>
    if (lines <= 0) return;
    8020132a:	0001                	nop
}
    8020132c:	60e2                	ld	ra,24(sp)
    8020132e:	6442                	ld	s0,16(sp)
    80201330:	6105                	addi	sp,sp,32
    80201332:	8082                	ret

0000000080201334 <cursor_down>:

// 光标下移
void cursor_down(int lines) {
    80201334:	1101                	addi	sp,sp,-32
    80201336:	ec06                	sd	ra,24(sp)
    80201338:	e822                	sd	s0,16(sp)
    8020133a:	1000                	addi	s0,sp,32
    8020133c:	87aa                	mv	a5,a0
    8020133e:	fef42623          	sw	a5,-20(s0)
    if (lines <= 0) return;
    80201342:	fec42783          	lw	a5,-20(s0)
    80201346:	2781                	sext.w	a5,a5
    80201348:	02f05f63          	blez	a5,80201386 <cursor_down+0x52>
    consputc('\033');
    8020134c:	456d                	li	a0,27
    8020134e:	00000097          	auipc	ra,0x0
    80201352:	8b2080e7          	jalr	-1870(ra) # 80200c00 <consputc>
    consputc('[');
    80201356:	05b00513          	li	a0,91
    8020135a:	00000097          	auipc	ra,0x0
    8020135e:	8a6080e7          	jalr	-1882(ra) # 80200c00 <consputc>
    printint(lines, 10, 0, 0,0);
    80201362:	fec42783          	lw	a5,-20(s0)
    80201366:	4701                	li	a4,0
    80201368:	4681                	li	a3,0
    8020136a:	4601                	li	a2,0
    8020136c:	45a9                	li	a1,10
    8020136e:	853e                	mv	a0,a5
    80201370:	00000097          	auipc	ra,0x0
    80201374:	8e4080e7          	jalr	-1820(ra) # 80200c54 <printint>
    consputc('B');
    80201378:	04200513          	li	a0,66
    8020137c:	00000097          	auipc	ra,0x0
    80201380:	884080e7          	jalr	-1916(ra) # 80200c00 <consputc>
    80201384:	a011                	j	80201388 <cursor_down+0x54>
    if (lines <= 0) return;
    80201386:	0001                	nop
}
    80201388:	60e2                	ld	ra,24(sp)
    8020138a:	6442                	ld	s0,16(sp)
    8020138c:	6105                	addi	sp,sp,32
    8020138e:	8082                	ret

0000000080201390 <cursor_right>:

// 光标右移
void cursor_right(int cols) {
    80201390:	1101                	addi	sp,sp,-32
    80201392:	ec06                	sd	ra,24(sp)
    80201394:	e822                	sd	s0,16(sp)
    80201396:	1000                	addi	s0,sp,32
    80201398:	87aa                	mv	a5,a0
    8020139a:	fef42623          	sw	a5,-20(s0)
    if (cols <= 0) return;
    8020139e:	fec42783          	lw	a5,-20(s0)
    802013a2:	2781                	sext.w	a5,a5
    802013a4:	02f05f63          	blez	a5,802013e2 <cursor_right+0x52>
    consputc('\033');
    802013a8:	456d                	li	a0,27
    802013aa:	00000097          	auipc	ra,0x0
    802013ae:	856080e7          	jalr	-1962(ra) # 80200c00 <consputc>
    consputc('[');
    802013b2:	05b00513          	li	a0,91
    802013b6:	00000097          	auipc	ra,0x0
    802013ba:	84a080e7          	jalr	-1974(ra) # 80200c00 <consputc>
    printint(cols, 10, 0,0,0);
    802013be:	fec42783          	lw	a5,-20(s0)
    802013c2:	4701                	li	a4,0
    802013c4:	4681                	li	a3,0
    802013c6:	4601                	li	a2,0
    802013c8:	45a9                	li	a1,10
    802013ca:	853e                	mv	a0,a5
    802013cc:	00000097          	auipc	ra,0x0
    802013d0:	888080e7          	jalr	-1912(ra) # 80200c54 <printint>
    consputc('C');
    802013d4:	04300513          	li	a0,67
    802013d8:	00000097          	auipc	ra,0x0
    802013dc:	828080e7          	jalr	-2008(ra) # 80200c00 <consputc>
    802013e0:	a011                	j	802013e4 <cursor_right+0x54>
    if (cols <= 0) return;
    802013e2:	0001                	nop
}
    802013e4:	60e2                	ld	ra,24(sp)
    802013e6:	6442                	ld	s0,16(sp)
    802013e8:	6105                	addi	sp,sp,32
    802013ea:	8082                	ret

00000000802013ec <cursor_left>:

// 光标左移
void cursor_left(int cols) {
    802013ec:	1101                	addi	sp,sp,-32
    802013ee:	ec06                	sd	ra,24(sp)
    802013f0:	e822                	sd	s0,16(sp)
    802013f2:	1000                	addi	s0,sp,32
    802013f4:	87aa                	mv	a5,a0
    802013f6:	fef42623          	sw	a5,-20(s0)
    if (cols <= 0) return;
    802013fa:	fec42783          	lw	a5,-20(s0)
    802013fe:	2781                	sext.w	a5,a5
    80201400:	02f05f63          	blez	a5,8020143e <cursor_left+0x52>
    consputc('\033');
    80201404:	456d                	li	a0,27
    80201406:	fffff097          	auipc	ra,0xfffff
    8020140a:	7fa080e7          	jalr	2042(ra) # 80200c00 <consputc>
    consputc('[');
    8020140e:	05b00513          	li	a0,91
    80201412:	fffff097          	auipc	ra,0xfffff
    80201416:	7ee080e7          	jalr	2030(ra) # 80200c00 <consputc>
    printint(cols, 10, 0,0,0);
    8020141a:	fec42783          	lw	a5,-20(s0)
    8020141e:	4701                	li	a4,0
    80201420:	4681                	li	a3,0
    80201422:	4601                	li	a2,0
    80201424:	45a9                	li	a1,10
    80201426:	853e                	mv	a0,a5
    80201428:	00000097          	auipc	ra,0x0
    8020142c:	82c080e7          	jalr	-2004(ra) # 80200c54 <printint>
    consputc('D');
    80201430:	04400513          	li	a0,68
    80201434:	fffff097          	auipc	ra,0xfffff
    80201438:	7cc080e7          	jalr	1996(ra) # 80200c00 <consputc>
    8020143c:	a011                	j	80201440 <cursor_left+0x54>
    if (cols <= 0) return;
    8020143e:	0001                	nop
}
    80201440:	60e2                	ld	ra,24(sp)
    80201442:	6442                	ld	s0,16(sp)
    80201444:	6105                	addi	sp,sp,32
    80201446:	8082                	ret

0000000080201448 <save_cursor>:
// 保存光标位置
void save_cursor(void) {
    80201448:	1141                	addi	sp,sp,-16
    8020144a:	e406                	sd	ra,8(sp)
    8020144c:	e022                	sd	s0,0(sp)
    8020144e:	0800                	addi	s0,sp,16
    consputc('\033');
    80201450:	456d                	li	a0,27
    80201452:	fffff097          	auipc	ra,0xfffff
    80201456:	7ae080e7          	jalr	1966(ra) # 80200c00 <consputc>
    consputc('[');
    8020145a:	05b00513          	li	a0,91
    8020145e:	fffff097          	auipc	ra,0xfffff
    80201462:	7a2080e7          	jalr	1954(ra) # 80200c00 <consputc>
    consputc('s');
    80201466:	07300513          	li	a0,115
    8020146a:	fffff097          	auipc	ra,0xfffff
    8020146e:	796080e7          	jalr	1942(ra) # 80200c00 <consputc>
}
    80201472:	0001                	nop
    80201474:	60a2                	ld	ra,8(sp)
    80201476:	6402                	ld	s0,0(sp)
    80201478:	0141                	addi	sp,sp,16
    8020147a:	8082                	ret

000000008020147c <restore_cursor>:

// 恢复光标位置
void restore_cursor(void) {
    8020147c:	1141                	addi	sp,sp,-16
    8020147e:	e406                	sd	ra,8(sp)
    80201480:	e022                	sd	s0,0(sp)
    80201482:	0800                	addi	s0,sp,16
    consputc('\033');
    80201484:	456d                	li	a0,27
    80201486:	fffff097          	auipc	ra,0xfffff
    8020148a:	77a080e7          	jalr	1914(ra) # 80200c00 <consputc>
    consputc('[');
    8020148e:	05b00513          	li	a0,91
    80201492:	fffff097          	auipc	ra,0xfffff
    80201496:	76e080e7          	jalr	1902(ra) # 80200c00 <consputc>
    consputc('u');
    8020149a:	07500513          	li	a0,117
    8020149e:	fffff097          	auipc	ra,0xfffff
    802014a2:	762080e7          	jalr	1890(ra) # 80200c00 <consputc>
}
    802014a6:	0001                	nop
    802014a8:	60a2                	ld	ra,8(sp)
    802014aa:	6402                	ld	s0,0(sp)
    802014ac:	0141                	addi	sp,sp,16
    802014ae:	8082                	ret

00000000802014b0 <cursor_to_column>:

// 移动到行首
void cursor_to_column(int col) {
    802014b0:	1101                	addi	sp,sp,-32
    802014b2:	ec06                	sd	ra,24(sp)
    802014b4:	e822                	sd	s0,16(sp)
    802014b6:	1000                	addi	s0,sp,32
    802014b8:	87aa                	mv	a5,a0
    802014ba:	fef42623          	sw	a5,-20(s0)
    if (col <= 0) col = 1;
    802014be:	fec42783          	lw	a5,-20(s0)
    802014c2:	2781                	sext.w	a5,a5
    802014c4:	00f04563          	bgtz	a5,802014ce <cursor_to_column+0x1e>
    802014c8:	4785                	li	a5,1
    802014ca:	fef42623          	sw	a5,-20(s0)
    consputc('\033');
    802014ce:	456d                	li	a0,27
    802014d0:	fffff097          	auipc	ra,0xfffff
    802014d4:	730080e7          	jalr	1840(ra) # 80200c00 <consputc>
    consputc('[');
    802014d8:	05b00513          	li	a0,91
    802014dc:	fffff097          	auipc	ra,0xfffff
    802014e0:	724080e7          	jalr	1828(ra) # 80200c00 <consputc>
    printint(col, 10, 0,0,0);
    802014e4:	fec42783          	lw	a5,-20(s0)
    802014e8:	4701                	li	a4,0
    802014ea:	4681                	li	a3,0
    802014ec:	4601                	li	a2,0
    802014ee:	45a9                	li	a1,10
    802014f0:	853e                	mv	a0,a5
    802014f2:	fffff097          	auipc	ra,0xfffff
    802014f6:	762080e7          	jalr	1890(ra) # 80200c54 <printint>
    consputc('G');
    802014fa:	04700513          	li	a0,71
    802014fe:	fffff097          	auipc	ra,0xfffff
    80201502:	702080e7          	jalr	1794(ra) # 80200c00 <consputc>
}
    80201506:	0001                	nop
    80201508:	60e2                	ld	ra,24(sp)
    8020150a:	6442                	ld	s0,16(sp)
    8020150c:	6105                	addi	sp,sp,32
    8020150e:	8082                	ret

0000000080201510 <goto_rc>:
// 光标定位到指定行列
void goto_rc(int row, int col) {
    80201510:	1101                	addi	sp,sp,-32
    80201512:	ec06                	sd	ra,24(sp)
    80201514:	e822                	sd	s0,16(sp)
    80201516:	1000                	addi	s0,sp,32
    80201518:	87aa                	mv	a5,a0
    8020151a:	872e                	mv	a4,a1
    8020151c:	fef42623          	sw	a5,-20(s0)
    80201520:	87ba                	mv	a5,a4
    80201522:	fef42423          	sw	a5,-24(s0)
    consputc('\033');
    80201526:	456d                	li	a0,27
    80201528:	fffff097          	auipc	ra,0xfffff
    8020152c:	6d8080e7          	jalr	1752(ra) # 80200c00 <consputc>
    consputc('[');
    80201530:	05b00513          	li	a0,91
    80201534:	fffff097          	auipc	ra,0xfffff
    80201538:	6cc080e7          	jalr	1740(ra) # 80200c00 <consputc>
    printint(row, 10, 0,0,0);
    8020153c:	fec42783          	lw	a5,-20(s0)
    80201540:	4701                	li	a4,0
    80201542:	4681                	li	a3,0
    80201544:	4601                	li	a2,0
    80201546:	45a9                	li	a1,10
    80201548:	853e                	mv	a0,a5
    8020154a:	fffff097          	auipc	ra,0xfffff
    8020154e:	70a080e7          	jalr	1802(ra) # 80200c54 <printint>
    consputc(';');
    80201552:	03b00513          	li	a0,59
    80201556:	fffff097          	auipc	ra,0xfffff
    8020155a:	6aa080e7          	jalr	1706(ra) # 80200c00 <consputc>
    printint(col, 10, 0,0,0);
    8020155e:	fe842783          	lw	a5,-24(s0)
    80201562:	4701                	li	a4,0
    80201564:	4681                	li	a3,0
    80201566:	4601                	li	a2,0
    80201568:	45a9                	li	a1,10
    8020156a:	853e                	mv	a0,a5
    8020156c:	fffff097          	auipc	ra,0xfffff
    80201570:	6e8080e7          	jalr	1768(ra) # 80200c54 <printint>
    consputc('H');
    80201574:	04800513          	li	a0,72
    80201578:	fffff097          	auipc	ra,0xfffff
    8020157c:	688080e7          	jalr	1672(ra) # 80200c00 <consputc>
}
    80201580:	0001                	nop
    80201582:	60e2                	ld	ra,24(sp)
    80201584:	6442                	ld	s0,16(sp)
    80201586:	6105                	addi	sp,sp,32
    80201588:	8082                	ret

000000008020158a <reset_color>:
// 颜色控制
void reset_color(void) {
    8020158a:	1141                	addi	sp,sp,-16
    8020158c:	e406                	sd	ra,8(sp)
    8020158e:	e022                	sd	s0,0(sp)
    80201590:	0800                	addi	s0,sp,16
	uart_puts(ESC "[0m");
    80201592:	00011517          	auipc	a0,0x11
    80201596:	3de50513          	addi	a0,a0,990 # 80212970 <user_test_table+0x108>
    8020159a:	fffff097          	auipc	ra,0xfffff
    8020159e:	15e080e7          	jalr	350(ra) # 802006f8 <uart_puts>
}
    802015a2:	0001                	nop
    802015a4:	60a2                	ld	ra,8(sp)
    802015a6:	6402                	ld	s0,0(sp)
    802015a8:	0141                	addi	sp,sp,16
    802015aa:	8082                	ret

00000000802015ac <set_fg_color>:
// 设置前景色
void set_fg_color(int color) {
    802015ac:	1101                	addi	sp,sp,-32
    802015ae:	ec06                	sd	ra,24(sp)
    802015b0:	e822                	sd	s0,16(sp)
    802015b2:	1000                	addi	s0,sp,32
    802015b4:	87aa                	mv	a5,a0
    802015b6:	fef42623          	sw	a5,-20(s0)
	if (color < 30 || color > 37) return; // 支持30-37
    802015ba:	fec42783          	lw	a5,-20(s0)
    802015be:	0007871b          	sext.w	a4,a5
    802015c2:	47f5                	li	a5,29
    802015c4:	04e7d763          	bge	a5,a4,80201612 <set_fg_color+0x66>
    802015c8:	fec42783          	lw	a5,-20(s0)
    802015cc:	0007871b          	sext.w	a4,a5
    802015d0:	02500793          	li	a5,37
    802015d4:	02e7cf63          	blt	a5,a4,80201612 <set_fg_color+0x66>
	consputc('\033');
    802015d8:	456d                	li	a0,27
    802015da:	fffff097          	auipc	ra,0xfffff
    802015de:	626080e7          	jalr	1574(ra) # 80200c00 <consputc>
	consputc('[');
    802015e2:	05b00513          	li	a0,91
    802015e6:	fffff097          	auipc	ra,0xfffff
    802015ea:	61a080e7          	jalr	1562(ra) # 80200c00 <consputc>
	printint(color, 10, 0,0,0);
    802015ee:	fec42783          	lw	a5,-20(s0)
    802015f2:	4701                	li	a4,0
    802015f4:	4681                	li	a3,0
    802015f6:	4601                	li	a2,0
    802015f8:	45a9                	li	a1,10
    802015fa:	853e                	mv	a0,a5
    802015fc:	fffff097          	auipc	ra,0xfffff
    80201600:	658080e7          	jalr	1624(ra) # 80200c54 <printint>
	consputc('m');
    80201604:	06d00513          	li	a0,109
    80201608:	fffff097          	auipc	ra,0xfffff
    8020160c:	5f8080e7          	jalr	1528(ra) # 80200c00 <consputc>
    80201610:	a011                	j	80201614 <set_fg_color+0x68>
	if (color < 30 || color > 37) return; // 支持30-37
    80201612:	0001                	nop
}
    80201614:	60e2                	ld	ra,24(sp)
    80201616:	6442                	ld	s0,16(sp)
    80201618:	6105                	addi	sp,sp,32
    8020161a:	8082                	ret

000000008020161c <set_bg_color>:
// 设置背景色
void set_bg_color(int color) {
    8020161c:	1101                	addi	sp,sp,-32
    8020161e:	ec06                	sd	ra,24(sp)
    80201620:	e822                	sd	s0,16(sp)
    80201622:	1000                	addi	s0,sp,32
    80201624:	87aa                	mv	a5,a0
    80201626:	fef42623          	sw	a5,-20(s0)
	if (color < 40 || color > 47) return; // 支持40-47
    8020162a:	fec42783          	lw	a5,-20(s0)
    8020162e:	0007871b          	sext.w	a4,a5
    80201632:	02700793          	li	a5,39
    80201636:	04e7d763          	bge	a5,a4,80201684 <set_bg_color+0x68>
    8020163a:	fec42783          	lw	a5,-20(s0)
    8020163e:	0007871b          	sext.w	a4,a5
    80201642:	02f00793          	li	a5,47
    80201646:	02e7cf63          	blt	a5,a4,80201684 <set_bg_color+0x68>
	consputc('\033');
    8020164a:	456d                	li	a0,27
    8020164c:	fffff097          	auipc	ra,0xfffff
    80201650:	5b4080e7          	jalr	1460(ra) # 80200c00 <consputc>
	consputc('[');
    80201654:	05b00513          	li	a0,91
    80201658:	fffff097          	auipc	ra,0xfffff
    8020165c:	5a8080e7          	jalr	1448(ra) # 80200c00 <consputc>
	printint(color, 10, 0,0,0);
    80201660:	fec42783          	lw	a5,-20(s0)
    80201664:	4701                	li	a4,0
    80201666:	4681                	li	a3,0
    80201668:	4601                	li	a2,0
    8020166a:	45a9                	li	a1,10
    8020166c:	853e                	mv	a0,a5
    8020166e:	fffff097          	auipc	ra,0xfffff
    80201672:	5e6080e7          	jalr	1510(ra) # 80200c54 <printint>
	consputc('m');
    80201676:	06d00513          	li	a0,109
    8020167a:	fffff097          	auipc	ra,0xfffff
    8020167e:	586080e7          	jalr	1414(ra) # 80200c00 <consputc>
    80201682:	a011                	j	80201686 <set_bg_color+0x6a>
	if (color < 40 || color > 47) return; // 支持40-47
    80201684:	0001                	nop
}
    80201686:	60e2                	ld	ra,24(sp)
    80201688:	6442                	ld	s0,16(sp)
    8020168a:	6105                	addi	sp,sp,32
    8020168c:	8082                	ret

000000008020168e <color_red>:
// 简易文字颜色
void color_red(void) {
    8020168e:	1141                	addi	sp,sp,-16
    80201690:	e406                	sd	ra,8(sp)
    80201692:	e022                	sd	s0,0(sp)
    80201694:	0800                	addi	s0,sp,16
	set_fg_color(31); // 红色
    80201696:	457d                	li	a0,31
    80201698:	00000097          	auipc	ra,0x0
    8020169c:	f14080e7          	jalr	-236(ra) # 802015ac <set_fg_color>
}
    802016a0:	0001                	nop
    802016a2:	60a2                	ld	ra,8(sp)
    802016a4:	6402                	ld	s0,0(sp)
    802016a6:	0141                	addi	sp,sp,16
    802016a8:	8082                	ret

00000000802016aa <color_green>:
void color_green(void) {
    802016aa:	1141                	addi	sp,sp,-16
    802016ac:	e406                	sd	ra,8(sp)
    802016ae:	e022                	sd	s0,0(sp)
    802016b0:	0800                	addi	s0,sp,16
	set_fg_color(32); // 绿色
    802016b2:	02000513          	li	a0,32
    802016b6:	00000097          	auipc	ra,0x0
    802016ba:	ef6080e7          	jalr	-266(ra) # 802015ac <set_fg_color>
}
    802016be:	0001                	nop
    802016c0:	60a2                	ld	ra,8(sp)
    802016c2:	6402                	ld	s0,0(sp)
    802016c4:	0141                	addi	sp,sp,16
    802016c6:	8082                	ret

00000000802016c8 <color_yellow>:
void color_yellow(void) {
    802016c8:	1141                	addi	sp,sp,-16
    802016ca:	e406                	sd	ra,8(sp)
    802016cc:	e022                	sd	s0,0(sp)
    802016ce:	0800                	addi	s0,sp,16
	set_fg_color(33); // 黄色
    802016d0:	02100513          	li	a0,33
    802016d4:	00000097          	auipc	ra,0x0
    802016d8:	ed8080e7          	jalr	-296(ra) # 802015ac <set_fg_color>
}
    802016dc:	0001                	nop
    802016de:	60a2                	ld	ra,8(sp)
    802016e0:	6402                	ld	s0,0(sp)
    802016e2:	0141                	addi	sp,sp,16
    802016e4:	8082                	ret

00000000802016e6 <color_blue>:
void color_blue(void) {
    802016e6:	1141                	addi	sp,sp,-16
    802016e8:	e406                	sd	ra,8(sp)
    802016ea:	e022                	sd	s0,0(sp)
    802016ec:	0800                	addi	s0,sp,16
	set_fg_color(34); // 蓝色
    802016ee:	02200513          	li	a0,34
    802016f2:	00000097          	auipc	ra,0x0
    802016f6:	eba080e7          	jalr	-326(ra) # 802015ac <set_fg_color>
}
    802016fa:	0001                	nop
    802016fc:	60a2                	ld	ra,8(sp)
    802016fe:	6402                	ld	s0,0(sp)
    80201700:	0141                	addi	sp,sp,16
    80201702:	8082                	ret

0000000080201704 <color_purple>:
void color_purple(void) {
    80201704:	1141                	addi	sp,sp,-16
    80201706:	e406                	sd	ra,8(sp)
    80201708:	e022                	sd	s0,0(sp)
    8020170a:	0800                	addi	s0,sp,16
	set_fg_color(35); // 紫色
    8020170c:	02300513          	li	a0,35
    80201710:	00000097          	auipc	ra,0x0
    80201714:	e9c080e7          	jalr	-356(ra) # 802015ac <set_fg_color>
}
    80201718:	0001                	nop
    8020171a:	60a2                	ld	ra,8(sp)
    8020171c:	6402                	ld	s0,0(sp)
    8020171e:	0141                	addi	sp,sp,16
    80201720:	8082                	ret

0000000080201722 <color_cyan>:
void color_cyan(void) {
    80201722:	1141                	addi	sp,sp,-16
    80201724:	e406                	sd	ra,8(sp)
    80201726:	e022                	sd	s0,0(sp)
    80201728:	0800                	addi	s0,sp,16
	set_fg_color(36); // 青色
    8020172a:	02400513          	li	a0,36
    8020172e:	00000097          	auipc	ra,0x0
    80201732:	e7e080e7          	jalr	-386(ra) # 802015ac <set_fg_color>
}
    80201736:	0001                	nop
    80201738:	60a2                	ld	ra,8(sp)
    8020173a:	6402                	ld	s0,0(sp)
    8020173c:	0141                	addi	sp,sp,16
    8020173e:	8082                	ret

0000000080201740 <color_reverse>:
void color_reverse(void){
    80201740:	1141                	addi	sp,sp,-16
    80201742:	e406                	sd	ra,8(sp)
    80201744:	e022                	sd	s0,0(sp)
    80201746:	0800                	addi	s0,sp,16
	set_fg_color(37); // 反色
    80201748:	02500513          	li	a0,37
    8020174c:	00000097          	auipc	ra,0x0
    80201750:	e60080e7          	jalr	-416(ra) # 802015ac <set_fg_color>
}
    80201754:	0001                	nop
    80201756:	60a2                	ld	ra,8(sp)
    80201758:	6402                	ld	s0,0(sp)
    8020175a:	0141                	addi	sp,sp,16
    8020175c:	8082                	ret

000000008020175e <set_color>:
void set_color(int fg, int bg) {
    8020175e:	1101                	addi	sp,sp,-32
    80201760:	ec06                	sd	ra,24(sp)
    80201762:	e822                	sd	s0,16(sp)
    80201764:	1000                	addi	s0,sp,32
    80201766:	87aa                	mv	a5,a0
    80201768:	872e                	mv	a4,a1
    8020176a:	fef42623          	sw	a5,-20(s0)
    8020176e:	87ba                	mv	a5,a4
    80201770:	fef42423          	sw	a5,-24(s0)
	set_bg_color(bg);
    80201774:	fe842783          	lw	a5,-24(s0)
    80201778:	853e                	mv	a0,a5
    8020177a:	00000097          	auipc	ra,0x0
    8020177e:	ea2080e7          	jalr	-350(ra) # 8020161c <set_bg_color>
	set_fg_color(fg);
    80201782:	fec42783          	lw	a5,-20(s0)
    80201786:	853e                	mv	a0,a5
    80201788:	00000097          	auipc	ra,0x0
    8020178c:	e24080e7          	jalr	-476(ra) # 802015ac <set_fg_color>
}
    80201790:	0001                	nop
    80201792:	60e2                	ld	ra,24(sp)
    80201794:	6442                	ld	s0,16(sp)
    80201796:	6105                	addi	sp,sp,32
    80201798:	8082                	ret

000000008020179a <clear_line>:
void clear_line(){
    8020179a:	1141                	addi	sp,sp,-16
    8020179c:	e406                	sd	ra,8(sp)
    8020179e:	e022                	sd	s0,0(sp)
    802017a0:	0800                	addi	s0,sp,16
	consputc('\033');
    802017a2:	456d                	li	a0,27
    802017a4:	fffff097          	auipc	ra,0xfffff
    802017a8:	45c080e7          	jalr	1116(ra) # 80200c00 <consputc>
	consputc('[');
    802017ac:	05b00513          	li	a0,91
    802017b0:	fffff097          	auipc	ra,0xfffff
    802017b4:	450080e7          	jalr	1104(ra) # 80200c00 <consputc>
	consputc('2');
    802017b8:	03200513          	li	a0,50
    802017bc:	fffff097          	auipc	ra,0xfffff
    802017c0:	444080e7          	jalr	1092(ra) # 80200c00 <consputc>
	consputc('K');
    802017c4:	04b00513          	li	a0,75
    802017c8:	fffff097          	auipc	ra,0xfffff
    802017cc:	438080e7          	jalr	1080(ra) # 80200c00 <consputc>
}
    802017d0:	0001                	nop
    802017d2:	60a2                	ld	ra,8(sp)
    802017d4:	6402                	ld	s0,0(sp)
    802017d6:	0141                	addi	sp,sp,16
    802017d8:	8082                	ret

00000000802017da <panic>:

void panic(const char *msg) {
    802017da:	1101                	addi	sp,sp,-32
    802017dc:	ec06                	sd	ra,24(sp)
    802017de:	e822                	sd	s0,16(sp)
    802017e0:	1000                	addi	s0,sp,32
    802017e2:	fea43423          	sd	a0,-24(s0)
	color_red(); // 可选：红色显示
    802017e6:	00000097          	auipc	ra,0x0
    802017ea:	ea8080e7          	jalr	-344(ra) # 8020168e <color_red>
	printf("panic: %s\n", msg);
    802017ee:	fe843583          	ld	a1,-24(s0)
    802017f2:	00011517          	auipc	a0,0x11
    802017f6:	18650513          	addi	a0,a0,390 # 80212978 <user_test_table+0x110>
    802017fa:	fffff097          	auipc	ra,0xfffff
    802017fe:	594080e7          	jalr	1428(ra) # 80200d8e <printf>
	reset_color();
    80201802:	00000097          	auipc	ra,0x0
    80201806:	d88080e7          	jalr	-632(ra) # 8020158a <reset_color>
	while (1) { /* 死循环，防止继续执行 */ }
    8020180a:	0001                	nop
    8020180c:	bffd                	j	8020180a <panic+0x30>

000000008020180e <warning>:
}
void warning(const char *fmt, ...) {
    8020180e:	7159                	addi	sp,sp,-112
    80201810:	f406                	sd	ra,40(sp)
    80201812:	f022                	sd	s0,32(sp)
    80201814:	1800                	addi	s0,sp,48
    80201816:	fca43c23          	sd	a0,-40(s0)
    8020181a:	e40c                	sd	a1,8(s0)
    8020181c:	e810                	sd	a2,16(s0)
    8020181e:	ec14                	sd	a3,24(s0)
    80201820:	f018                	sd	a4,32(s0)
    80201822:	f41c                	sd	a5,40(s0)
    80201824:	03043823          	sd	a6,48(s0)
    80201828:	03143c23          	sd	a7,56(s0)
    va_list ap;
    color_purple(); // 设置紫色
    8020182c:	00000097          	auipc	ra,0x0
    80201830:	ed8080e7          	jalr	-296(ra) # 80201704 <color_purple>
    printf("[WARNING] ");
    80201834:	00011517          	auipc	a0,0x11
    80201838:	15450513          	addi	a0,a0,340 # 80212988 <user_test_table+0x120>
    8020183c:	fffff097          	auipc	ra,0xfffff
    80201840:	552080e7          	jalr	1362(ra) # 80200d8e <printf>
    va_start(ap, fmt);
    80201844:	04040793          	addi	a5,s0,64
    80201848:	fcf43823          	sd	a5,-48(s0)
    8020184c:	fd043783          	ld	a5,-48(s0)
    80201850:	fc878793          	addi	a5,a5,-56
    80201854:	fef43423          	sd	a5,-24(s0)
    printf(fmt, ap);
    80201858:	fe843783          	ld	a5,-24(s0)
    8020185c:	85be                	mv	a1,a5
    8020185e:	fd843503          	ld	a0,-40(s0)
    80201862:	fffff097          	auipc	ra,0xfffff
    80201866:	52c080e7          	jalr	1324(ra) # 80200d8e <printf>
    va_end(ap);
    reset_color(); // 恢复默认颜色
    8020186a:	00000097          	auipc	ra,0x0
    8020186e:	d20080e7          	jalr	-736(ra) # 8020158a <reset_color>
}
    80201872:	0001                	nop
    80201874:	70a2                	ld	ra,40(sp)
    80201876:	7402                	ld	s0,32(sp)
    80201878:	6165                	addi	sp,sp,112
    8020187a:	8082                	ret

000000008020187c <test_printf_precision>:
void test_printf_precision(void) {
    8020187c:	1101                	addi	sp,sp,-32
    8020187e:	ec06                	sd	ra,24(sp)
    80201880:	e822                	sd	s0,16(sp)
    80201882:	1000                	addi	s0,sp,32
	clear_screen();
    80201884:	00000097          	auipc	ra,0x0
    80201888:	a22080e7          	jalr	-1502(ra) # 802012a6 <clear_screen>
    printf("=== 详细的printf测试 ===\n");
    8020188c:	00011517          	auipc	a0,0x11
    80201890:	10c50513          	addi	a0,a0,268 # 80212998 <user_test_table+0x130>
    80201894:	fffff097          	auipc	ra,0xfffff
    80201898:	4fa080e7          	jalr	1274(ra) # 80200d8e <printf>
    
    // 测试十六进制格式
    printf("十六进制测试:\n");
    8020189c:	00011517          	auipc	a0,0x11
    802018a0:	11c50513          	addi	a0,a0,284 # 802129b8 <user_test_table+0x150>
    802018a4:	fffff097          	auipc	ra,0xfffff
    802018a8:	4ea080e7          	jalr	1258(ra) # 80200d8e <printf>
    printf("  255 = 0x%x (expected: ff)\n", 255);
    802018ac:	0ff00593          	li	a1,255
    802018b0:	00011517          	auipc	a0,0x11
    802018b4:	12050513          	addi	a0,a0,288 # 802129d0 <user_test_table+0x168>
    802018b8:	fffff097          	auipc	ra,0xfffff
    802018bc:	4d6080e7          	jalr	1238(ra) # 80200d8e <printf>
    printf("  4096 = 0x%x (expected: 1000)\n", 4096);
    802018c0:	6585                	lui	a1,0x1
    802018c2:	00011517          	auipc	a0,0x11
    802018c6:	12e50513          	addi	a0,a0,302 # 802129f0 <user_test_table+0x188>
    802018ca:	fffff097          	auipc	ra,0xfffff
    802018ce:	4c4080e7          	jalr	1220(ra) # 80200d8e <printf>
    printf("  0x1234abcd = 0x%x\n", 0x1234abcd);
    802018d2:	1234b7b7          	lui	a5,0x1234b
    802018d6:	bcd78593          	addi	a1,a5,-1075 # 1234abcd <_entry-0x6deb5433>
    802018da:	00011517          	auipc	a0,0x11
    802018de:	13650513          	addi	a0,a0,310 # 80212a10 <user_test_table+0x1a8>
    802018e2:	fffff097          	auipc	ra,0xfffff
    802018e6:	4ac080e7          	jalr	1196(ra) # 80200d8e <printf>
    
    // 测试十进制格式  
    printf("十进制测试:\n");
    802018ea:	00011517          	auipc	a0,0x11
    802018ee:	13e50513          	addi	a0,a0,318 # 80212a28 <user_test_table+0x1c0>
    802018f2:	fffff097          	auipc	ra,0xfffff
    802018f6:	49c080e7          	jalr	1180(ra) # 80200d8e <printf>
    printf("  正数: %d\n", 42);
    802018fa:	02a00593          	li	a1,42
    802018fe:	00011517          	auipc	a0,0x11
    80201902:	14250513          	addi	a0,a0,322 # 80212a40 <user_test_table+0x1d8>
    80201906:	fffff097          	auipc	ra,0xfffff
    8020190a:	488080e7          	jalr	1160(ra) # 80200d8e <printf>
    printf("  负数: %d\n", -42);
    8020190e:	fd600593          	li	a1,-42
    80201912:	00011517          	auipc	a0,0x11
    80201916:	13e50513          	addi	a0,a0,318 # 80212a50 <user_test_table+0x1e8>
    8020191a:	fffff097          	auipc	ra,0xfffff
    8020191e:	474080e7          	jalr	1140(ra) # 80200d8e <printf>
    printf("  零: %d\n", 0);
    80201922:	4581                	li	a1,0
    80201924:	00011517          	auipc	a0,0x11
    80201928:	13c50513          	addi	a0,a0,316 # 80212a60 <user_test_table+0x1f8>
    8020192c:	fffff097          	auipc	ra,0xfffff
    80201930:	462080e7          	jalr	1122(ra) # 80200d8e <printf>
    printf("  大数: %d\n", 123456789);
    80201934:	075bd7b7          	lui	a5,0x75bd
    80201938:	d1578593          	addi	a1,a5,-747 # 75bcd15 <_entry-0x78c432eb>
    8020193c:	00011517          	auipc	a0,0x11
    80201940:	13450513          	addi	a0,a0,308 # 80212a70 <user_test_table+0x208>
    80201944:	fffff097          	auipc	ra,0xfffff
    80201948:	44a080e7          	jalr	1098(ra) # 80200d8e <printf>
    
    // 测试无符号格式
    printf("无符号测试:\n");
    8020194c:	00011517          	auipc	a0,0x11
    80201950:	13450513          	addi	a0,a0,308 # 80212a80 <user_test_table+0x218>
    80201954:	fffff097          	auipc	ra,0xfffff
    80201958:	43a080e7          	jalr	1082(ra) # 80200d8e <printf>
    printf("  大无符号数：%u\n", 4294967295U);
    8020195c:	55fd                	li	a1,-1
    8020195e:	00011517          	auipc	a0,0x11
    80201962:	13a50513          	addi	a0,a0,314 # 80212a98 <user_test_table+0x230>
    80201966:	fffff097          	auipc	ra,0xfffff
    8020196a:	428080e7          	jalr	1064(ra) # 80200d8e <printf>
    printf("  零：%u\n", 0U);
    8020196e:	4581                	li	a1,0
    80201970:	00011517          	auipc	a0,0x11
    80201974:	14050513          	addi	a0,a0,320 # 80212ab0 <user_test_table+0x248>
    80201978:	fffff097          	auipc	ra,0xfffff
    8020197c:	416080e7          	jalr	1046(ra) # 80200d8e <printf>
	printf("  小无符号数：%u\n", 12345U);
    80201980:	678d                	lui	a5,0x3
    80201982:	03978593          	addi	a1,a5,57 # 3039 <_entry-0x801fcfc7>
    80201986:	00011517          	auipc	a0,0x11
    8020198a:	13a50513          	addi	a0,a0,314 # 80212ac0 <user_test_table+0x258>
    8020198e:	fffff097          	auipc	ra,0xfffff
    80201992:	400080e7          	jalr	1024(ra) # 80200d8e <printf>

	// 测试边界
	printf("边界测试:\n");
    80201996:	00011517          	auipc	a0,0x11
    8020199a:	14250513          	addi	a0,a0,322 # 80212ad8 <user_test_table+0x270>
    8020199e:	fffff097          	auipc	ra,0xfffff
    802019a2:	3f0080e7          	jalr	1008(ra) # 80200d8e <printf>
	printf("  INT_MAX: %d\n", 2147483647);
    802019a6:	800007b7          	lui	a5,0x80000
    802019aa:	fff7c593          	not	a1,a5
    802019ae:	00011517          	auipc	a0,0x11
    802019b2:	13a50513          	addi	a0,a0,314 # 80212ae8 <user_test_table+0x280>
    802019b6:	fffff097          	auipc	ra,0xfffff
    802019ba:	3d8080e7          	jalr	984(ra) # 80200d8e <printf>
	printf("  INT_MIN: %d\n", -2147483648);
    802019be:	800005b7          	lui	a1,0x80000
    802019c2:	00011517          	auipc	a0,0x11
    802019c6:	13650513          	addi	a0,a0,310 # 80212af8 <user_test_table+0x290>
    802019ca:	fffff097          	auipc	ra,0xfffff
    802019ce:	3c4080e7          	jalr	964(ra) # 80200d8e <printf>
	printf("  UINT_MAX: %u\n", 4294967295U);
    802019d2:	55fd                	li	a1,-1
    802019d4:	00011517          	auipc	a0,0x11
    802019d8:	13450513          	addi	a0,a0,308 # 80212b08 <user_test_table+0x2a0>
    802019dc:	fffff097          	auipc	ra,0xfffff
    802019e0:	3b2080e7          	jalr	946(ra) # 80200d8e <printf>
	printf(" -1 as unsigned: %u\n", (unsigned int)-1);
    802019e4:	55fd                	li	a1,-1
    802019e6:	00011517          	auipc	a0,0x11
    802019ea:	13250513          	addi	a0,a0,306 # 80212b18 <user_test_table+0x2b0>
    802019ee:	fffff097          	auipc	ra,0xfffff
    802019f2:	3a0080e7          	jalr	928(ra) # 80200d8e <printf>
    
    // 测试字符串边界情况
    printf("字符串测试:\n");
    802019f6:	00011517          	auipc	a0,0x11
    802019fa:	13a50513          	addi	a0,a0,314 # 80212b30 <user_test_table+0x2c8>
    802019fe:	fffff097          	auipc	ra,0xfffff
    80201a02:	390080e7          	jalr	912(ra) # 80200d8e <printf>
    printf("  空字符串: '%s'\n", "");
    80201a06:	00011597          	auipc	a1,0x11
    80201a0a:	14258593          	addi	a1,a1,322 # 80212b48 <user_test_table+0x2e0>
    80201a0e:	00011517          	auipc	a0,0x11
    80201a12:	14250513          	addi	a0,a0,322 # 80212b50 <user_test_table+0x2e8>
    80201a16:	fffff097          	auipc	ra,0xfffff
    80201a1a:	378080e7          	jalr	888(ra) # 80200d8e <printf>
    printf("  单字符: '%s'\n", "X");
    80201a1e:	00011597          	auipc	a1,0x11
    80201a22:	14a58593          	addi	a1,a1,330 # 80212b68 <user_test_table+0x300>
    80201a26:	00011517          	auipc	a0,0x11
    80201a2a:	14a50513          	addi	a0,a0,330 # 80212b70 <user_test_table+0x308>
    80201a2e:	fffff097          	auipc	ra,0xfffff
    80201a32:	360080e7          	jalr	864(ra) # 80200d8e <printf>
    printf("  长字符串: '%s'\n", "This is a longer test string");
    80201a36:	00011597          	auipc	a1,0x11
    80201a3a:	15258593          	addi	a1,a1,338 # 80212b88 <user_test_table+0x320>
    80201a3e:	00011517          	auipc	a0,0x11
    80201a42:	16a50513          	addi	a0,a0,362 # 80212ba8 <user_test_table+0x340>
    80201a46:	fffff097          	auipc	ra,0xfffff
    80201a4a:	348080e7          	jalr	840(ra) # 80200d8e <printf>
	printf("  非常长字符串： '%s'\n", "Formal version: Entities should not be multiplied beyond necessity.\nPlain English: If two or more explanations fit the facts equally well, choose the simplest one.\nScientific phrasing: When multiple hypotheses explain the same observation, the simplest hypothesis that requires the fewest assumptions is most likely to be correct.");
    80201a4e:	00011597          	auipc	a1,0x11
    80201a52:	17258593          	addi	a1,a1,370 # 80212bc0 <user_test_table+0x358>
    80201a56:	00011517          	auipc	a0,0x11
    80201a5a:	2ba50513          	addi	a0,a0,698 # 80212d10 <user_test_table+0x4a8>
    80201a5e:	fffff097          	auipc	ra,0xfffff
    80201a62:	330080e7          	jalr	816(ra) # 80200d8e <printf>
	
	// 测试混合格式
	printf("混合格式测试:\n");
    80201a66:	00011517          	auipc	a0,0x11
    80201a6a:	2ca50513          	addi	a0,a0,714 # 80212d30 <user_test_table+0x4c8>
    80201a6e:	fffff097          	auipc	ra,0xfffff
    80201a72:	320080e7          	jalr	800(ra) # 80200d8e <printf>
	printf("  Hex: 0x%x, Dec: %d, Unsigned: %u\n", 255, -255, 255U);
    80201a76:	0ff00693          	li	a3,255
    80201a7a:	f0100613          	li	a2,-255
    80201a7e:	0ff00593          	li	a1,255
    80201a82:	00011517          	auipc	a0,0x11
    80201a86:	2c650513          	addi	a0,a0,710 # 80212d48 <user_test_table+0x4e0>
    80201a8a:	fffff097          	auipc	ra,0xfffff
    80201a8e:	304080e7          	jalr	772(ra) # 80200d8e <printf>
	
	// 测试百分号输出
	printf("百分号输出测试:\n");
    80201a92:	00011517          	auipc	a0,0x11
    80201a96:	2de50513          	addi	a0,a0,734 # 80212d70 <user_test_table+0x508>
    80201a9a:	fffff097          	auipc	ra,0xfffff
    80201a9e:	2f4080e7          	jalr	756(ra) # 80200d8e <printf>
	printf("  100%% 完成!\n");
    80201aa2:	00011517          	auipc	a0,0x11
    80201aa6:	2e650513          	addi	a0,a0,742 # 80212d88 <user_test_table+0x520>
    80201aaa:	fffff097          	auipc	ra,0xfffff
    80201aae:	2e4080e7          	jalr	740(ra) # 80200d8e <printf>
	
	// 测试NULL字符串
	char *null_str = 0;
    80201ab2:	fe043423          	sd	zero,-24(s0)
	printf("NULL字符串测试:\n");
    80201ab6:	00011517          	auipc	a0,0x11
    80201aba:	2ea50513          	addi	a0,a0,746 # 80212da0 <user_test_table+0x538>
    80201abe:	fffff097          	auipc	ra,0xfffff
    80201ac2:	2d0080e7          	jalr	720(ra) # 80200d8e <printf>
	printf("  NULL as string: '%s'\n", null_str);
    80201ac6:	fe843583          	ld	a1,-24(s0)
    80201aca:	00011517          	auipc	a0,0x11
    80201ace:	2ee50513          	addi	a0,a0,750 # 80212db8 <user_test_table+0x550>
    80201ad2:	fffff097          	auipc	ra,0xfffff
    80201ad6:	2bc080e7          	jalr	700(ra) # 80200d8e <printf>
	
	// 测试指针格式
	int var = 42;
    80201ada:	02a00793          	li	a5,42
    80201ade:	fef42223          	sw	a5,-28(s0)
	printf("指针测试:\n");
    80201ae2:	00011517          	auipc	a0,0x11
    80201ae6:	2ee50513          	addi	a0,a0,750 # 80212dd0 <user_test_table+0x568>
    80201aea:	fffff097          	auipc	ra,0xfffff
    80201aee:	2a4080e7          	jalr	676(ra) # 80200d8e <printf>
	printf("  Address of var: %p\n", &var);
    80201af2:	fe440793          	addi	a5,s0,-28
    80201af6:	85be                	mv	a1,a5
    80201af8:	00011517          	auipc	a0,0x11
    80201afc:	2e850513          	addi	a0,a0,744 # 80212de0 <user_test_table+0x578>
    80201b00:	fffff097          	auipc	ra,0xfffff
    80201b04:	28e080e7          	jalr	654(ra) # 80200d8e <printf>
	
	// 测试负数的无符号输出
	printf("负数无符号输出测试:\n");
    80201b08:	00011517          	auipc	a0,0x11
    80201b0c:	2f050513          	addi	a0,a0,752 # 80212df8 <user_test_table+0x590>
    80201b10:	fffff097          	auipc	ra,0xfffff
    80201b14:	27e080e7          	jalr	638(ra) # 80200d8e <printf>
	printf("  -1 as unsigned: %u\n", (unsigned int)-1);
    80201b18:	55fd                	li	a1,-1
    80201b1a:	00011517          	auipc	a0,0x11
    80201b1e:	2fe50513          	addi	a0,a0,766 # 80212e18 <user_test_table+0x5b0>
    80201b22:	fffff097          	auipc	ra,0xfffff
    80201b26:	26c080e7          	jalr	620(ra) # 80200d8e <printf>
	
	// 测试不同进制的数字
	printf("不同进制测试:\n");
    80201b2a:	00011517          	auipc	a0,0x11
    80201b2e:	30650513          	addi	a0,a0,774 # 80212e30 <user_test_table+0x5c8>
    80201b32:	fffff097          	auipc	ra,0xfffff
    80201b36:	25c080e7          	jalr	604(ra) # 80200d8e <printf>
	printf("  Binary of 5: %b\n", 5);
    80201b3a:	4595                	li	a1,5
    80201b3c:	00011517          	auipc	a0,0x11
    80201b40:	30c50513          	addi	a0,a0,780 # 80212e48 <user_test_table+0x5e0>
    80201b44:	fffff097          	auipc	ra,0xfffff
    80201b48:	24a080e7          	jalr	586(ra) # 80200d8e <printf>
	printf("  Octal of 8 : %o\n", 8); 
    80201b4c:	45a1                	li	a1,8
    80201b4e:	00011517          	auipc	a0,0x11
    80201b52:	31250513          	addi	a0,a0,786 # 80212e60 <user_test_table+0x5f8>
    80201b56:	fffff097          	auipc	ra,0xfffff
    80201b5a:	238080e7          	jalr	568(ra) # 80200d8e <printf>
	printf("=== printf测试结束 ===\n");
    80201b5e:	00011517          	auipc	a0,0x11
    80201b62:	31a50513          	addi	a0,a0,794 # 80212e78 <user_test_table+0x610>
    80201b66:	fffff097          	auipc	ra,0xfffff
    80201b6a:	228080e7          	jalr	552(ra) # 80200d8e <printf>
}
    80201b6e:	0001                	nop
    80201b70:	60e2                	ld	ra,24(sp)
    80201b72:	6442                	ld	s0,16(sp)
    80201b74:	6105                	addi	sp,sp,32
    80201b76:	8082                	ret

0000000080201b78 <test_curse_move>:
void test_curse_move(){
    80201b78:	1101                	addi	sp,sp,-32
    80201b7a:	ec06                	sd	ra,24(sp)
    80201b7c:	e822                	sd	s0,16(sp)
    80201b7e:	1000                	addi	s0,sp,32
	clear_screen(); // 清屏
    80201b80:	fffff097          	auipc	ra,0xfffff
    80201b84:	726080e7          	jalr	1830(ra) # 802012a6 <clear_screen>
	printf("=== 光标移动测试 ===\n");
    80201b88:	00011517          	auipc	a0,0x11
    80201b8c:	31050513          	addi	a0,a0,784 # 80212e98 <user_test_table+0x630>
    80201b90:	fffff097          	auipc	ra,0xfffff
    80201b94:	1fe080e7          	jalr	510(ra) # 80200d8e <printf>
	for (int i = 3; i <= 7; i++) {
    80201b98:	478d                	li	a5,3
    80201b9a:	fef42623          	sw	a5,-20(s0)
    80201b9e:	a881                	j	80201bee <test_curse_move+0x76>
		for (int j = 1; j <= 10; j++) {
    80201ba0:	4785                	li	a5,1
    80201ba2:	fef42423          	sw	a5,-24(s0)
    80201ba6:	a805                	j	80201bd6 <test_curse_move+0x5e>
			goto_rc(i, j);
    80201ba8:	fe842703          	lw	a4,-24(s0)
    80201bac:	fec42783          	lw	a5,-20(s0)
    80201bb0:	85ba                	mv	a1,a4
    80201bb2:	853e                	mv	a0,a5
    80201bb4:	00000097          	auipc	ra,0x0
    80201bb8:	95c080e7          	jalr	-1700(ra) # 80201510 <goto_rc>
			printf("*");
    80201bbc:	00011517          	auipc	a0,0x11
    80201bc0:	2fc50513          	addi	a0,a0,764 # 80212eb8 <user_test_table+0x650>
    80201bc4:	fffff097          	auipc	ra,0xfffff
    80201bc8:	1ca080e7          	jalr	458(ra) # 80200d8e <printf>
		for (int j = 1; j <= 10; j++) {
    80201bcc:	fe842783          	lw	a5,-24(s0)
    80201bd0:	2785                	addiw	a5,a5,1 # ffffffff80000001 <_bss_end+0xfffffffeffdb86e1>
    80201bd2:	fef42423          	sw	a5,-24(s0)
    80201bd6:	fe842783          	lw	a5,-24(s0)
    80201bda:	0007871b          	sext.w	a4,a5
    80201bde:	47a9                	li	a5,10
    80201be0:	fce7d4e3          	bge	a5,a4,80201ba8 <test_curse_move+0x30>
	for (int i = 3; i <= 7; i++) {
    80201be4:	fec42783          	lw	a5,-20(s0)
    80201be8:	2785                	addiw	a5,a5,1
    80201bea:	fef42623          	sw	a5,-20(s0)
    80201bee:	fec42783          	lw	a5,-20(s0)
    80201bf2:	0007871b          	sext.w	a4,a5
    80201bf6:	479d                	li	a5,7
    80201bf8:	fae7d4e3          	bge	a5,a4,80201ba0 <test_curse_move+0x28>
		}
	}
	goto_rc(9, 1);
    80201bfc:	4585                	li	a1,1
    80201bfe:	4525                	li	a0,9
    80201c00:	00000097          	auipc	ra,0x0
    80201c04:	910080e7          	jalr	-1776(ra) # 80201510 <goto_rc>
	save_cursor();
    80201c08:	00000097          	auipc	ra,0x0
    80201c0c:	840080e7          	jalr	-1984(ra) # 80201448 <save_cursor>
	// 光标移动测试
	cursor_up(5);
    80201c10:	4515                	li	a0,5
    80201c12:	fffff097          	auipc	ra,0xfffff
    80201c16:	6c6080e7          	jalr	1734(ra) # 802012d8 <cursor_up>
	cursor_right(2);
    80201c1a:	4509                	li	a0,2
    80201c1c:	fffff097          	auipc	ra,0xfffff
    80201c20:	774080e7          	jalr	1908(ra) # 80201390 <cursor_right>
	printf("+++++");
    80201c24:	00011517          	auipc	a0,0x11
    80201c28:	29c50513          	addi	a0,a0,668 # 80212ec0 <user_test_table+0x658>
    80201c2c:	fffff097          	auipc	ra,0xfffff
    80201c30:	162080e7          	jalr	354(ra) # 80200d8e <printf>
	cursor_down(2);
    80201c34:	4509                	li	a0,2
    80201c36:	fffff097          	auipc	ra,0xfffff
    80201c3a:	6fe080e7          	jalr	1790(ra) # 80201334 <cursor_down>
	cursor_left(5);
    80201c3e:	4515                	li	a0,5
    80201c40:	fffff097          	auipc	ra,0xfffff
    80201c44:	7ac080e7          	jalr	1964(ra) # 802013ec <cursor_left>
	printf("-----");
    80201c48:	00011517          	auipc	a0,0x11
    80201c4c:	28050513          	addi	a0,a0,640 # 80212ec8 <user_test_table+0x660>
    80201c50:	fffff097          	auipc	ra,0xfffff
    80201c54:	13e080e7          	jalr	318(ra) # 80200d8e <printf>
	restore_cursor();
    80201c58:	00000097          	auipc	ra,0x0
    80201c5c:	824080e7          	jalr	-2012(ra) # 8020147c <restore_cursor>
	printf("=== 光标移动测试结束 ===\n");
    80201c60:	00011517          	auipc	a0,0x11
    80201c64:	27050513          	addi	a0,a0,624 # 80212ed0 <user_test_table+0x668>
    80201c68:	fffff097          	auipc	ra,0xfffff
    80201c6c:	126080e7          	jalr	294(ra) # 80200d8e <printf>
}
    80201c70:	0001                	nop
    80201c72:	60e2                	ld	ra,24(sp)
    80201c74:	6442                	ld	s0,16(sp)
    80201c76:	6105                	addi	sp,sp,32
    80201c78:	8082                	ret

0000000080201c7a <test_basic_colors>:

void test_basic_colors(void) {
    80201c7a:	1141                	addi	sp,sp,-16
    80201c7c:	e406                	sd	ra,8(sp)
    80201c7e:	e022                	sd	s0,0(sp)
    80201c80:	0800                	addi	s0,sp,16
    clear_screen();
    80201c82:	fffff097          	auipc	ra,0xfffff
    80201c86:	624080e7          	jalr	1572(ra) # 802012a6 <clear_screen>
    printf("=== 基本颜色测试 ===\n\n");
    80201c8a:	00011517          	auipc	a0,0x11
    80201c8e:	26e50513          	addi	a0,a0,622 # 80212ef8 <user_test_table+0x690>
    80201c92:	fffff097          	auipc	ra,0xfffff
    80201c96:	0fc080e7          	jalr	252(ra) # 80200d8e <printf>
    
    // 测试基本前景色
    printf("前景色测试:\n");
    80201c9a:	00011517          	auipc	a0,0x11
    80201c9e:	27e50513          	addi	a0,a0,638 # 80212f18 <user_test_table+0x6b0>
    80201ca2:	fffff097          	auipc	ra,0xfffff
    80201ca6:	0ec080e7          	jalr	236(ra) # 80200d8e <printf>
    color_red();    printf("红色文字 ");
    80201caa:	00000097          	auipc	ra,0x0
    80201cae:	9e4080e7          	jalr	-1564(ra) # 8020168e <color_red>
    80201cb2:	00011517          	auipc	a0,0x11
    80201cb6:	27e50513          	addi	a0,a0,638 # 80212f30 <user_test_table+0x6c8>
    80201cba:	fffff097          	auipc	ra,0xfffff
    80201cbe:	0d4080e7          	jalr	212(ra) # 80200d8e <printf>
    color_green();  printf("绿色文字 ");
    80201cc2:	00000097          	auipc	ra,0x0
    80201cc6:	9e8080e7          	jalr	-1560(ra) # 802016aa <color_green>
    80201cca:	00011517          	auipc	a0,0x11
    80201cce:	27650513          	addi	a0,a0,630 # 80212f40 <user_test_table+0x6d8>
    80201cd2:	fffff097          	auipc	ra,0xfffff
    80201cd6:	0bc080e7          	jalr	188(ra) # 80200d8e <printf>
    color_yellow(); printf("黄色文字 ");
    80201cda:	00000097          	auipc	ra,0x0
    80201cde:	9ee080e7          	jalr	-1554(ra) # 802016c8 <color_yellow>
    80201ce2:	00011517          	auipc	a0,0x11
    80201ce6:	26e50513          	addi	a0,a0,622 # 80212f50 <user_test_table+0x6e8>
    80201cea:	fffff097          	auipc	ra,0xfffff
    80201cee:	0a4080e7          	jalr	164(ra) # 80200d8e <printf>
    color_blue();   printf("蓝色文字 ");
    80201cf2:	00000097          	auipc	ra,0x0
    80201cf6:	9f4080e7          	jalr	-1548(ra) # 802016e6 <color_blue>
    80201cfa:	00011517          	auipc	a0,0x11
    80201cfe:	26650513          	addi	a0,a0,614 # 80212f60 <user_test_table+0x6f8>
    80201d02:	fffff097          	auipc	ra,0xfffff
    80201d06:	08c080e7          	jalr	140(ra) # 80200d8e <printf>
    color_purple(); printf("紫色文字 ");
    80201d0a:	00000097          	auipc	ra,0x0
    80201d0e:	9fa080e7          	jalr	-1542(ra) # 80201704 <color_purple>
    80201d12:	00011517          	auipc	a0,0x11
    80201d16:	25e50513          	addi	a0,a0,606 # 80212f70 <user_test_table+0x708>
    80201d1a:	fffff097          	auipc	ra,0xfffff
    80201d1e:	074080e7          	jalr	116(ra) # 80200d8e <printf>
    color_cyan();   printf("青色文字 ");
    80201d22:	00000097          	auipc	ra,0x0
    80201d26:	a00080e7          	jalr	-1536(ra) # 80201722 <color_cyan>
    80201d2a:	00011517          	auipc	a0,0x11
    80201d2e:	25650513          	addi	a0,a0,598 # 80212f80 <user_test_table+0x718>
    80201d32:	fffff097          	auipc	ra,0xfffff
    80201d36:	05c080e7          	jalr	92(ra) # 80200d8e <printf>
    color_reverse();  printf("反色文字");
    80201d3a:	00000097          	auipc	ra,0x0
    80201d3e:	a06080e7          	jalr	-1530(ra) # 80201740 <color_reverse>
    80201d42:	00011517          	auipc	a0,0x11
    80201d46:	24e50513          	addi	a0,a0,590 # 80212f90 <user_test_table+0x728>
    80201d4a:	fffff097          	auipc	ra,0xfffff
    80201d4e:	044080e7          	jalr	68(ra) # 80200d8e <printf>
    reset_color();
    80201d52:	00000097          	auipc	ra,0x0
    80201d56:	838080e7          	jalr	-1992(ra) # 8020158a <reset_color>
    printf("\n\n");
    80201d5a:	00011517          	auipc	a0,0x11
    80201d5e:	24650513          	addi	a0,a0,582 # 80212fa0 <user_test_table+0x738>
    80201d62:	fffff097          	auipc	ra,0xfffff
    80201d66:	02c080e7          	jalr	44(ra) # 80200d8e <printf>
    
    // 测试背景色
    printf("背景色测试:\n");
    80201d6a:	00011517          	auipc	a0,0x11
    80201d6e:	23e50513          	addi	a0,a0,574 # 80212fa8 <user_test_table+0x740>
    80201d72:	fffff097          	auipc	ra,0xfffff
    80201d76:	01c080e7          	jalr	28(ra) # 80200d8e <printf>
    set_bg_color(41); printf(" 红色背景 "); reset_color();
    80201d7a:	02900513          	li	a0,41
    80201d7e:	00000097          	auipc	ra,0x0
    80201d82:	89e080e7          	jalr	-1890(ra) # 8020161c <set_bg_color>
    80201d86:	00011517          	auipc	a0,0x11
    80201d8a:	23a50513          	addi	a0,a0,570 # 80212fc0 <user_test_table+0x758>
    80201d8e:	fffff097          	auipc	ra,0xfffff
    80201d92:	000080e7          	jalr	ra # 80200d8e <printf>
    80201d96:	fffff097          	auipc	ra,0xfffff
    80201d9a:	7f4080e7          	jalr	2036(ra) # 8020158a <reset_color>
    set_bg_color(42); printf(" 绿色背景 "); reset_color();
    80201d9e:	02a00513          	li	a0,42
    80201da2:	00000097          	auipc	ra,0x0
    80201da6:	87a080e7          	jalr	-1926(ra) # 8020161c <set_bg_color>
    80201daa:	00011517          	auipc	a0,0x11
    80201dae:	22650513          	addi	a0,a0,550 # 80212fd0 <user_test_table+0x768>
    80201db2:	fffff097          	auipc	ra,0xfffff
    80201db6:	fdc080e7          	jalr	-36(ra) # 80200d8e <printf>
    80201dba:	fffff097          	auipc	ra,0xfffff
    80201dbe:	7d0080e7          	jalr	2000(ra) # 8020158a <reset_color>
    set_bg_color(43); printf(" 黄色背景 "); reset_color();
    80201dc2:	02b00513          	li	a0,43
    80201dc6:	00000097          	auipc	ra,0x0
    80201dca:	856080e7          	jalr	-1962(ra) # 8020161c <set_bg_color>
    80201dce:	00011517          	auipc	a0,0x11
    80201dd2:	21250513          	addi	a0,a0,530 # 80212fe0 <user_test_table+0x778>
    80201dd6:	fffff097          	auipc	ra,0xfffff
    80201dda:	fb8080e7          	jalr	-72(ra) # 80200d8e <printf>
    80201dde:	fffff097          	auipc	ra,0xfffff
    80201de2:	7ac080e7          	jalr	1964(ra) # 8020158a <reset_color>
    set_bg_color(44); printf(" 蓝色背景 "); reset_color();
    80201de6:	02c00513          	li	a0,44
    80201dea:	00000097          	auipc	ra,0x0
    80201dee:	832080e7          	jalr	-1998(ra) # 8020161c <set_bg_color>
    80201df2:	00011517          	auipc	a0,0x11
    80201df6:	1fe50513          	addi	a0,a0,510 # 80212ff0 <user_test_table+0x788>
    80201dfa:	fffff097          	auipc	ra,0xfffff
    80201dfe:	f94080e7          	jalr	-108(ra) # 80200d8e <printf>
    80201e02:	fffff097          	auipc	ra,0xfffff
    80201e06:	788080e7          	jalr	1928(ra) # 8020158a <reset_color>
	set_bg_color(47); printf(" 反色背景 "); reset_color();
    80201e0a:	02f00513          	li	a0,47
    80201e0e:	00000097          	auipc	ra,0x0
    80201e12:	80e080e7          	jalr	-2034(ra) # 8020161c <set_bg_color>
    80201e16:	00011517          	auipc	a0,0x11
    80201e1a:	1ea50513          	addi	a0,a0,490 # 80213000 <user_test_table+0x798>
    80201e1e:	fffff097          	auipc	ra,0xfffff
    80201e22:	f70080e7          	jalr	-144(ra) # 80200d8e <printf>
    80201e26:	fffff097          	auipc	ra,0xfffff
    80201e2a:	764080e7          	jalr	1892(ra) # 8020158a <reset_color>
    printf("\n\n");
    80201e2e:	00011517          	auipc	a0,0x11
    80201e32:	17250513          	addi	a0,a0,370 # 80212fa0 <user_test_table+0x738>
    80201e36:	fffff097          	auipc	ra,0xfffff
    80201e3a:	f58080e7          	jalr	-168(ra) # 80200d8e <printf>
    
    // 测试组合效果
    printf("组合效果测试:\n");
    80201e3e:	00011517          	auipc	a0,0x11
    80201e42:	1d250513          	addi	a0,a0,466 # 80213010 <user_test_table+0x7a8>
    80201e46:	fffff097          	auipc	ra,0xfffff
    80201e4a:	f48080e7          	jalr	-184(ra) # 80200d8e <printf>
    set_color(31, 44); printf(" 红字蓝底 "); reset_color();
    80201e4e:	02c00593          	li	a1,44
    80201e52:	457d                	li	a0,31
    80201e54:	00000097          	auipc	ra,0x0
    80201e58:	90a080e7          	jalr	-1782(ra) # 8020175e <set_color>
    80201e5c:	00011517          	auipc	a0,0x11
    80201e60:	1cc50513          	addi	a0,a0,460 # 80213028 <user_test_table+0x7c0>
    80201e64:	fffff097          	auipc	ra,0xfffff
    80201e68:	f2a080e7          	jalr	-214(ra) # 80200d8e <printf>
    80201e6c:	fffff097          	auipc	ra,0xfffff
    80201e70:	71e080e7          	jalr	1822(ra) # 8020158a <reset_color>
    set_color(33, 45); printf(" 黄字紫底 "); reset_color();
    80201e74:	02d00593          	li	a1,45
    80201e78:	02100513          	li	a0,33
    80201e7c:	00000097          	auipc	ra,0x0
    80201e80:	8e2080e7          	jalr	-1822(ra) # 8020175e <set_color>
    80201e84:	00011517          	auipc	a0,0x11
    80201e88:	1b450513          	addi	a0,a0,436 # 80213038 <user_test_table+0x7d0>
    80201e8c:	fffff097          	auipc	ra,0xfffff
    80201e90:	f02080e7          	jalr	-254(ra) # 80200d8e <printf>
    80201e94:	fffff097          	auipc	ra,0xfffff
    80201e98:	6f6080e7          	jalr	1782(ra) # 8020158a <reset_color>
    set_color(32, 47); printf(" 绿字反底 "); reset_color();
    80201e9c:	02f00593          	li	a1,47
    80201ea0:	02000513          	li	a0,32
    80201ea4:	00000097          	auipc	ra,0x0
    80201ea8:	8ba080e7          	jalr	-1862(ra) # 8020175e <set_color>
    80201eac:	00011517          	auipc	a0,0x11
    80201eb0:	19c50513          	addi	a0,a0,412 # 80213048 <user_test_table+0x7e0>
    80201eb4:	fffff097          	auipc	ra,0xfffff
    80201eb8:	eda080e7          	jalr	-294(ra) # 80200d8e <printf>
    80201ebc:	fffff097          	auipc	ra,0xfffff
    80201ec0:	6ce080e7          	jalr	1742(ra) # 8020158a <reset_color>
    printf("\n\n");
    80201ec4:	00011517          	auipc	a0,0x11
    80201ec8:	0dc50513          	addi	a0,a0,220 # 80212fa0 <user_test_table+0x738>
    80201ecc:	fffff097          	auipc	ra,0xfffff
    80201ed0:	ec2080e7          	jalr	-318(ra) # 80200d8e <printf>
	reset_color();
    80201ed4:	fffff097          	auipc	ra,0xfffff
    80201ed8:	6b6080e7          	jalr	1718(ra) # 8020158a <reset_color>
	printf("重置为默认颜色，本行文字会被清除\n"); 
    80201edc:	00011517          	auipc	a0,0x11
    80201ee0:	17c50513          	addi	a0,a0,380 # 80213058 <user_test_table+0x7f0>
    80201ee4:	fffff097          	auipc	ra,0xfffff
    80201ee8:	eaa080e7          	jalr	-342(ra) # 80200d8e <printf>
	cursor_up(1); // 光标上移一行
    80201eec:	4505                	li	a0,1
    80201eee:	fffff097          	auipc	ra,0xfffff
    80201ef2:	3ea080e7          	jalr	1002(ra) # 802012d8 <cursor_up>
	clear_line();
    80201ef6:	00000097          	auipc	ra,0x0
    80201efa:	8a4080e7          	jalr	-1884(ra) # 8020179a <clear_line>

	printf("=== 颜色测试结束 ===\n");
    80201efe:	00011517          	auipc	a0,0x11
    80201f02:	19250513          	addi	a0,a0,402 # 80213090 <user_test_table+0x828>
    80201f06:	fffff097          	auipc	ra,0xfffff
    80201f0a:	e88080e7          	jalr	-376(ra) # 80200d8e <printf>
    80201f0e:	0001                	nop
    80201f10:	60a2                	ld	ra,8(sp)
    80201f12:	6402                	ld	s0,0(sp)
    80201f14:	0141                	addi	sp,sp,16
    80201f16:	8082                	ret

0000000080201f18 <memset>:
#include "defs.h"
// 自行实现memset
void *memset(void *dst, int c, unsigned long n) {
    80201f18:	7139                	addi	sp,sp,-64
    80201f1a:	fc22                	sd	s0,56(sp)
    80201f1c:	0080                	addi	s0,sp,64
    80201f1e:	fca43c23          	sd	a0,-40(s0)
    80201f22:	87ae                	mv	a5,a1
    80201f24:	fcc43423          	sd	a2,-56(s0)
    80201f28:	fcf42a23          	sw	a5,-44(s0)
    unsigned char *p = dst;
    80201f2c:	fd843783          	ld	a5,-40(s0)
    80201f30:	fef43423          	sd	a5,-24(s0)
    while (n-- > 0)
    80201f34:	a829                	j	80201f4e <memset+0x36>
        *p++ = (unsigned char)c;
    80201f36:	fe843783          	ld	a5,-24(s0)
    80201f3a:	00178713          	addi	a4,a5,1
    80201f3e:	fee43423          	sd	a4,-24(s0)
    80201f42:	fd442703          	lw	a4,-44(s0)
    80201f46:	0ff77713          	zext.b	a4,a4
    80201f4a:	00e78023          	sb	a4,0(a5)
    while (n-- > 0)
    80201f4e:	fc843783          	ld	a5,-56(s0)
    80201f52:	fff78713          	addi	a4,a5,-1
    80201f56:	fce43423          	sd	a4,-56(s0)
    80201f5a:	fff1                	bnez	a5,80201f36 <memset+0x1e>
    return dst;
    80201f5c:	fd843783          	ld	a5,-40(s0)
}
    80201f60:	853e                	mv	a0,a5
    80201f62:	7462                	ld	s0,56(sp)
    80201f64:	6121                	addi	sp,sp,64
    80201f66:	8082                	ret

0000000080201f68 <memmove>:
void *memmove(void *dst, const void *src, unsigned long n) {
    80201f68:	7139                	addi	sp,sp,-64
    80201f6a:	fc22                	sd	s0,56(sp)
    80201f6c:	0080                	addi	s0,sp,64
    80201f6e:	fca43c23          	sd	a0,-40(s0)
    80201f72:	fcb43823          	sd	a1,-48(s0)
    80201f76:	fcc43423          	sd	a2,-56(s0)
	unsigned char *d = dst;
    80201f7a:	fd843783          	ld	a5,-40(s0)
    80201f7e:	fef43423          	sd	a5,-24(s0)
	const unsigned char *s = src;
    80201f82:	fd043783          	ld	a5,-48(s0)
    80201f86:	fef43023          	sd	a5,-32(s0)
	if (d < s) {
    80201f8a:	fe843703          	ld	a4,-24(s0)
    80201f8e:	fe043783          	ld	a5,-32(s0)
    80201f92:	02f77b63          	bgeu	a4,a5,80201fc8 <memmove+0x60>
		while (n-- > 0)
    80201f96:	a00d                	j	80201fb8 <memmove+0x50>
			*d++ = *s++;
    80201f98:	fe043703          	ld	a4,-32(s0)
    80201f9c:	00170793          	addi	a5,a4,1
    80201fa0:	fef43023          	sd	a5,-32(s0)
    80201fa4:	fe843783          	ld	a5,-24(s0)
    80201fa8:	00178693          	addi	a3,a5,1
    80201fac:	fed43423          	sd	a3,-24(s0)
    80201fb0:	00074703          	lbu	a4,0(a4)
    80201fb4:	00e78023          	sb	a4,0(a5)
		while (n-- > 0)
    80201fb8:	fc843783          	ld	a5,-56(s0)
    80201fbc:	fff78713          	addi	a4,a5,-1
    80201fc0:	fce43423          	sd	a4,-56(s0)
    80201fc4:	fbf1                	bnez	a5,80201f98 <memmove+0x30>
    80201fc6:	a889                	j	80202018 <memmove+0xb0>
	} else {
		d += n;
    80201fc8:	fe843703          	ld	a4,-24(s0)
    80201fcc:	fc843783          	ld	a5,-56(s0)
    80201fd0:	97ba                	add	a5,a5,a4
    80201fd2:	fef43423          	sd	a5,-24(s0)
		s += n;
    80201fd6:	fe043703          	ld	a4,-32(s0)
    80201fda:	fc843783          	ld	a5,-56(s0)
    80201fde:	97ba                	add	a5,a5,a4
    80201fe0:	fef43023          	sd	a5,-32(s0)
		while (n-- > 0)
    80201fe4:	a01d                	j	8020200a <memmove+0xa2>
			*(--d) = *(--s);
    80201fe6:	fe043783          	ld	a5,-32(s0)
    80201fea:	17fd                	addi	a5,a5,-1
    80201fec:	fef43023          	sd	a5,-32(s0)
    80201ff0:	fe843783          	ld	a5,-24(s0)
    80201ff4:	17fd                	addi	a5,a5,-1
    80201ff6:	fef43423          	sd	a5,-24(s0)
    80201ffa:	fe043783          	ld	a5,-32(s0)
    80201ffe:	0007c703          	lbu	a4,0(a5)
    80202002:	fe843783          	ld	a5,-24(s0)
    80202006:	00e78023          	sb	a4,0(a5)
		while (n-- > 0)
    8020200a:	fc843783          	ld	a5,-56(s0)
    8020200e:	fff78713          	addi	a4,a5,-1
    80202012:	fce43423          	sd	a4,-56(s0)
    80202016:	fbe1                	bnez	a5,80201fe6 <memmove+0x7e>
	}
	return dst;
    80202018:	fd843783          	ld	a5,-40(s0)
}
    8020201c:	853e                	mv	a0,a5
    8020201e:	7462                	ld	s0,56(sp)
    80202020:	6121                	addi	sp,sp,64
    80202022:	8082                	ret

0000000080202024 <memcpy>:
void *memcpy(void *dst, const void *src, size_t n) {
    80202024:	715d                	addi	sp,sp,-80
    80202026:	e4a2                	sd	s0,72(sp)
    80202028:	0880                	addi	s0,sp,80
    8020202a:	fca43423          	sd	a0,-56(s0)
    8020202e:	fcb43023          	sd	a1,-64(s0)
    80202032:	fac43c23          	sd	a2,-72(s0)
    char *d = dst;
    80202036:	fc843783          	ld	a5,-56(s0)
    8020203a:	fef43023          	sd	a5,-32(s0)
    const char *s = src;
    8020203e:	fc043783          	ld	a5,-64(s0)
    80202042:	fcf43c23          	sd	a5,-40(s0)
    for (size_t i = 0; i < n; i++) {
    80202046:	fe043423          	sd	zero,-24(s0)
    8020204a:	a025                	j	80202072 <memcpy+0x4e>
        d[i] = s[i];
    8020204c:	fd843703          	ld	a4,-40(s0)
    80202050:	fe843783          	ld	a5,-24(s0)
    80202054:	973e                	add	a4,a4,a5
    80202056:	fe043683          	ld	a3,-32(s0)
    8020205a:	fe843783          	ld	a5,-24(s0)
    8020205e:	97b6                	add	a5,a5,a3
    80202060:	00074703          	lbu	a4,0(a4)
    80202064:	00e78023          	sb	a4,0(a5)
    for (size_t i = 0; i < n; i++) {
    80202068:	fe843783          	ld	a5,-24(s0)
    8020206c:	0785                	addi	a5,a5,1
    8020206e:	fef43423          	sd	a5,-24(s0)
    80202072:	fe843703          	ld	a4,-24(s0)
    80202076:	fb843783          	ld	a5,-72(s0)
    8020207a:	fcf769e3          	bltu	a4,a5,8020204c <memcpy+0x28>
    }
    return dst;
    8020207e:	fc843783          	ld	a5,-56(s0)
    80202082:	853e                	mv	a0,a5
    80202084:	6426                	ld	s0,72(sp)
    80202086:	6161                	addi	sp,sp,80
    80202088:	8082                	ret

000000008020208a <assert>:
    8020208a:	1101                	addi	sp,sp,-32
    8020208c:	ec06                	sd	ra,24(sp)
    8020208e:	e822                	sd	s0,16(sp)
    80202090:	1000                	addi	s0,sp,32
    80202092:	87aa                	mv	a5,a0
    80202094:	fef42623          	sw	a5,-20(s0)
    80202098:	fec42783          	lw	a5,-20(s0)
    8020209c:	2781                	sext.w	a5,a5
    8020209e:	e79d                	bnez	a5,802020cc <assert+0x42>
    802020a0:	33800613          	li	a2,824
    802020a4:	00015597          	auipc	a1,0x15
    802020a8:	16c58593          	addi	a1,a1,364 # 80217210 <user_test_table+0x78>
    802020ac:	00015517          	auipc	a0,0x15
    802020b0:	17450513          	addi	a0,a0,372 # 80217220 <user_test_table+0x88>
    802020b4:	fffff097          	auipc	ra,0xfffff
    802020b8:	cda080e7          	jalr	-806(ra) # 80200d8e <printf>
    802020bc:	00015517          	auipc	a0,0x15
    802020c0:	18c50513          	addi	a0,a0,396 # 80217248 <user_test_table+0xb0>
    802020c4:	fffff097          	auipc	ra,0xfffff
    802020c8:	716080e7          	jalr	1814(ra) # 802017da <panic>
    802020cc:	0001                	nop
    802020ce:	60e2                	ld	ra,24(sp)
    802020d0:	6442                	ld	s0,16(sp)
    802020d2:	6105                	addi	sp,sp,32
    802020d4:	8082                	ret

00000000802020d6 <sv39_sign_extend>:
    802020d6:	1101                	addi	sp,sp,-32
    802020d8:	ec22                	sd	s0,24(sp)
    802020da:	1000                	addi	s0,sp,32
    802020dc:	fea43423          	sd	a0,-24(s0)
    802020e0:	fe843703          	ld	a4,-24(s0)
    802020e4:	4785                	li	a5,1
    802020e6:	179a                	slli	a5,a5,0x26
    802020e8:	8ff9                	and	a5,a5,a4
    802020ea:	c799                	beqz	a5,802020f8 <sv39_sign_extend+0x22>
    802020ec:	fe843703          	ld	a4,-24(s0)
    802020f0:	57fd                	li	a5,-1
    802020f2:	179e                	slli	a5,a5,0x27
    802020f4:	8fd9                	or	a5,a5,a4
    802020f6:	a031                	j	80202102 <sv39_sign_extend+0x2c>
    802020f8:	fe843703          	ld	a4,-24(s0)
    802020fc:	57fd                	li	a5,-1
    802020fe:	83e5                	srli	a5,a5,0x19
    80202100:	8ff9                	and	a5,a5,a4
    80202102:	853e                	mv	a0,a5
    80202104:	6462                	ld	s0,24(sp)
    80202106:	6105                	addi	sp,sp,32
    80202108:	8082                	ret

000000008020210a <sv39_check_valid>:
    8020210a:	1101                	addi	sp,sp,-32
    8020210c:	ec22                	sd	s0,24(sp)
    8020210e:	1000                	addi	s0,sp,32
    80202110:	fea43423          	sd	a0,-24(s0)
    80202114:	fe843703          	ld	a4,-24(s0)
    80202118:	57fd                	li	a5,-1
    8020211a:	83e5                	srli	a5,a5,0x19
    8020211c:	00e7f863          	bgeu	a5,a4,8020212c <sv39_check_valid+0x22>
    80202120:	fe843703          	ld	a4,-24(s0)
    80202124:	57fd                	li	a5,-1
    80202126:	179e                	slli	a5,a5,0x27
    80202128:	00f76463          	bltu	a4,a5,80202130 <sv39_check_valid+0x26>
    8020212c:	4785                	li	a5,1
    8020212e:	a011                	j	80202132 <sv39_check_valid+0x28>
    80202130:	4781                	li	a5,0
    80202132:	853e                	mv	a0,a5
    80202134:	6462                	ld	s0,24(sp)
    80202136:	6105                	addi	sp,sp,32
    80202138:	8082                	ret

000000008020213a <px>:
static inline uint64 px(int level, uint64 va) {
    8020213a:	1101                	addi	sp,sp,-32
    8020213c:	ec22                	sd	s0,24(sp)
    8020213e:	1000                	addi	s0,sp,32
    80202140:	87aa                	mv	a5,a0
    80202142:	feb43023          	sd	a1,-32(s0)
    80202146:	fef42623          	sw	a5,-20(s0)
    return VPN_MASK(va, level);
    8020214a:	fec42783          	lw	a5,-20(s0)
    8020214e:	873e                	mv	a4,a5
    80202150:	87ba                	mv	a5,a4
    80202152:	0037979b          	slliw	a5,a5,0x3
    80202156:	9fb9                	addw	a5,a5,a4
    80202158:	2781                	sext.w	a5,a5
    8020215a:	27b1                	addiw	a5,a5,12
    8020215c:	2781                	sext.w	a5,a5
    8020215e:	873e                	mv	a4,a5
    80202160:	fe043783          	ld	a5,-32(s0)
    80202164:	00e7d7b3          	srl	a5,a5,a4
    80202168:	1ff7f793          	andi	a5,a5,511
}
    8020216c:	853e                	mv	a0,a5
    8020216e:	6462                	ld	s0,24(sp)
    80202170:	6105                	addi	sp,sp,32
    80202172:	8082                	ret

0000000080202174 <create_pagetable>:
pagetable_t create_pagetable(void) {
    80202174:	1101                	addi	sp,sp,-32
    80202176:	ec06                	sd	ra,24(sp)
    80202178:	e822                	sd	s0,16(sp)
    8020217a:	1000                	addi	s0,sp,32
    pagetable_t pt = (pagetable_t)alloc_page();
    8020217c:	00001097          	auipc	ra,0x1
    80202180:	1b4080e7          	jalr	436(ra) # 80203330 <alloc_page>
    80202184:	fea43423          	sd	a0,-24(s0)
    if (!pt)
    80202188:	fe843783          	ld	a5,-24(s0)
    8020218c:	e399                	bnez	a5,80202192 <create_pagetable+0x1e>
        return 0;
    8020218e:	4781                	li	a5,0
    80202190:	a819                	j	802021a6 <create_pagetable+0x32>
    memset(pt, 0, PGSIZE);
    80202192:	6605                	lui	a2,0x1
    80202194:	4581                	li	a1,0
    80202196:	fe843503          	ld	a0,-24(s0)
    8020219a:	00000097          	auipc	ra,0x0
    8020219e:	d7e080e7          	jalr	-642(ra) # 80201f18 <memset>
    return pt;
    802021a2:	fe843783          	ld	a5,-24(s0)
}
    802021a6:	853e                	mv	a0,a5
    802021a8:	60e2                	ld	ra,24(sp)
    802021aa:	6442                	ld	s0,16(sp)
    802021ac:	6105                	addi	sp,sp,32
    802021ae:	8082                	ret

00000000802021b0 <walk_lookup>:
pte_t* walk_lookup(pagetable_t pt, uint64 va) {
    802021b0:	7139                	addi	sp,sp,-64
    802021b2:	fc06                	sd	ra,56(sp)
    802021b4:	f822                	sd	s0,48(sp)
    802021b6:	0080                	addi	s0,sp,64
    802021b8:	fca43423          	sd	a0,-56(s0)
    802021bc:	fcb43023          	sd	a1,-64(s0)
	va = sv39_sign_extend(va);
    802021c0:	fc043503          	ld	a0,-64(s0)
    802021c4:	00000097          	auipc	ra,0x0
    802021c8:	f12080e7          	jalr	-238(ra) # 802020d6 <sv39_sign_extend>
    802021cc:	fca43023          	sd	a0,-64(s0)
	if (!sv39_check_valid(va))
    802021d0:	fc043503          	ld	a0,-64(s0)
    802021d4:	00000097          	auipc	ra,0x0
    802021d8:	f36080e7          	jalr	-202(ra) # 8020210a <sv39_check_valid>
    802021dc:	87aa                	mv	a5,a0
    802021de:	eb89                	bnez	a5,802021f0 <walk_lookup+0x40>
		panic("va out of sv39 range");
    802021e0:	00015517          	auipc	a0,0x15
    802021e4:	07050513          	addi	a0,a0,112 # 80217250 <user_test_table+0xb8>
    802021e8:	fffff097          	auipc	ra,0xfffff
    802021ec:	5f2080e7          	jalr	1522(ra) # 802017da <panic>
    for (int level = 2; level > 0; level--) {
    802021f0:	4789                	li	a5,2
    802021f2:	fef42623          	sw	a5,-20(s0)
    802021f6:	a0e9                	j	802022c0 <walk_lookup+0x110>
        pte_t *pte = &pt[px(level, va)];
    802021f8:	fec42783          	lw	a5,-20(s0)
    802021fc:	fc043583          	ld	a1,-64(s0)
    80202200:	853e                	mv	a0,a5
    80202202:	00000097          	auipc	ra,0x0
    80202206:	f38080e7          	jalr	-200(ra) # 8020213a <px>
    8020220a:	87aa                	mv	a5,a0
    8020220c:	078e                	slli	a5,a5,0x3
    8020220e:	fc843703          	ld	a4,-56(s0)
    80202212:	97ba                	add	a5,a5,a4
    80202214:	fef43023          	sd	a5,-32(s0)
        if (!pte) {
    80202218:	fe043783          	ld	a5,-32(s0)
    8020221c:	ef91                	bnez	a5,80202238 <walk_lookup+0x88>
            printf("[WALK_LOOKUP] pte is NULL at level %d\n", level);
    8020221e:	fec42783          	lw	a5,-20(s0)
    80202222:	85be                	mv	a1,a5
    80202224:	00015517          	auipc	a0,0x15
    80202228:	04450513          	addi	a0,a0,68 # 80217268 <user_test_table+0xd0>
    8020222c:	fffff097          	auipc	ra,0xfffff
    80202230:	b62080e7          	jalr	-1182(ra) # 80200d8e <printf>
            return 0;
    80202234:	4781                	li	a5,0
    80202236:	a075                	j	802022e2 <walk_lookup+0x132>
        if (*pte & PTE_V) {
    80202238:	fe043783          	ld	a5,-32(s0)
    8020223c:	639c                	ld	a5,0(a5)
    8020223e:	8b85                	andi	a5,a5,1
    80202240:	cfa1                	beqz	a5,80202298 <walk_lookup+0xe8>
            uint64 pa = PTE2PA(*pte);
    80202242:	fe043783          	ld	a5,-32(s0)
    80202246:	639c                	ld	a5,0(a5)
    80202248:	83a9                	srli	a5,a5,0xa
    8020224a:	07b2                	slli	a5,a5,0xc
    8020224c:	fcf43c23          	sd	a5,-40(s0)
            if (pa < KERNBASE || pa >= PHYSTOP) {
    80202250:	fd843703          	ld	a4,-40(s0)
    80202254:	800007b7          	lui	a5,0x80000
    80202258:	fff7c793          	not	a5,a5
    8020225c:	00e7f863          	bgeu	a5,a4,8020226c <walk_lookup+0xbc>
    80202260:	fd843703          	ld	a4,-40(s0)
    80202264:	47c5                	li	a5,17
    80202266:	07ee                	slli	a5,a5,0x1b
    80202268:	02f76363          	bltu	a4,a5,8020228e <walk_lookup+0xde>
                printf("[WALK_LOOKUP] 非法页表物理地址: 0x%lx (level %d, va=0x%lx)\n", pa, level, va);
    8020226c:	fec42783          	lw	a5,-20(s0)
    80202270:	fc043683          	ld	a3,-64(s0)
    80202274:	863e                	mv	a2,a5
    80202276:	fd843583          	ld	a1,-40(s0)
    8020227a:	00015517          	auipc	a0,0x15
    8020227e:	01650513          	addi	a0,a0,22 # 80217290 <user_test_table+0xf8>
    80202282:	fffff097          	auipc	ra,0xfffff
    80202286:	b0c080e7          	jalr	-1268(ra) # 80200d8e <printf>
                return 0;
    8020228a:	4781                	li	a5,0
    8020228c:	a899                	j	802022e2 <walk_lookup+0x132>
            pt = (pagetable_t)pa;
    8020228e:	fd843783          	ld	a5,-40(s0)
    80202292:	fcf43423          	sd	a5,-56(s0)
    80202296:	a005                	j	802022b6 <walk_lookup+0x106>
            printf("[WALK_LOOKUP] 页表项无效: level=%d va=0x%lx\n", level, va);
    80202298:	fec42783          	lw	a5,-20(s0)
    8020229c:	fc043603          	ld	a2,-64(s0)
    802022a0:	85be                	mv	a1,a5
    802022a2:	00015517          	auipc	a0,0x15
    802022a6:	03650513          	addi	a0,a0,54 # 802172d8 <user_test_table+0x140>
    802022aa:	fffff097          	auipc	ra,0xfffff
    802022ae:	ae4080e7          	jalr	-1308(ra) # 80200d8e <printf>
            return 0;
    802022b2:	4781                	li	a5,0
    802022b4:	a03d                	j	802022e2 <walk_lookup+0x132>
    for (int level = 2; level > 0; level--) {
    802022b6:	fec42783          	lw	a5,-20(s0)
    802022ba:	37fd                	addiw	a5,a5,-1 # 7fffffff <_entry-0x200001>
    802022bc:	fef42623          	sw	a5,-20(s0)
    802022c0:	fec42783          	lw	a5,-20(s0)
    802022c4:	2781                	sext.w	a5,a5
    802022c6:	f2f049e3          	bgtz	a5,802021f8 <walk_lookup+0x48>
    return &pt[px(0, va)];
    802022ca:	fc043583          	ld	a1,-64(s0)
    802022ce:	4501                	li	a0,0
    802022d0:	00000097          	auipc	ra,0x0
    802022d4:	e6a080e7          	jalr	-406(ra) # 8020213a <px>
    802022d8:	87aa                	mv	a5,a0
    802022da:	078e                	slli	a5,a5,0x3
    802022dc:	fc843703          	ld	a4,-56(s0)
    802022e0:	97ba                	add	a5,a5,a4
}
    802022e2:	853e                	mv	a0,a5
    802022e4:	70e2                	ld	ra,56(sp)
    802022e6:	7442                	ld	s0,48(sp)
    802022e8:	6121                	addi	sp,sp,64
    802022ea:	8082                	ret

00000000802022ec <walk_create>:
static pte_t* walk_create(pagetable_t pt, uint64 va) {
    802022ec:	7139                	addi	sp,sp,-64
    802022ee:	fc06                	sd	ra,56(sp)
    802022f0:	f822                	sd	s0,48(sp)
    802022f2:	0080                	addi	s0,sp,64
    802022f4:	fca43423          	sd	a0,-56(s0)
    802022f8:	fcb43023          	sd	a1,-64(s0)
	va = sv39_sign_extend(va);
    802022fc:	fc043503          	ld	a0,-64(s0)
    80202300:	00000097          	auipc	ra,0x0
    80202304:	dd6080e7          	jalr	-554(ra) # 802020d6 <sv39_sign_extend>
    80202308:	fca43023          	sd	a0,-64(s0)
	if (!sv39_check_valid(va))
    8020230c:	fc043503          	ld	a0,-64(s0)
    80202310:	00000097          	auipc	ra,0x0
    80202314:	dfa080e7          	jalr	-518(ra) # 8020210a <sv39_check_valid>
    80202318:	87aa                	mv	a5,a0
    8020231a:	eb89                	bnez	a5,8020232c <walk_create+0x40>
		panic("va out of sv39 range");
    8020231c:	00015517          	auipc	a0,0x15
    80202320:	f3450513          	addi	a0,a0,-204 # 80217250 <user_test_table+0xb8>
    80202324:	fffff097          	auipc	ra,0xfffff
    80202328:	4b6080e7          	jalr	1206(ra) # 802017da <panic>
    for (int level = 2; level > 0; level--) {
    8020232c:	4789                	li	a5,2
    8020232e:	fef42623          	sw	a5,-20(s0)
    80202332:	a059                	j	802023b8 <walk_create+0xcc>
        pte_t *pte = &pt[px(level, va)];
    80202334:	fec42783          	lw	a5,-20(s0)
    80202338:	fc043583          	ld	a1,-64(s0)
    8020233c:	853e                	mv	a0,a5
    8020233e:	00000097          	auipc	ra,0x0
    80202342:	dfc080e7          	jalr	-516(ra) # 8020213a <px>
    80202346:	87aa                	mv	a5,a0
    80202348:	078e                	slli	a5,a5,0x3
    8020234a:	fc843703          	ld	a4,-56(s0)
    8020234e:	97ba                	add	a5,a5,a4
    80202350:	fef43023          	sd	a5,-32(s0)
        if (*pte & PTE_V) {
    80202354:	fe043783          	ld	a5,-32(s0)
    80202358:	639c                	ld	a5,0(a5)
    8020235a:	8b85                	andi	a5,a5,1
    8020235c:	cb89                	beqz	a5,8020236e <walk_create+0x82>
            pt = (pagetable_t)PTE2PA(*pte);
    8020235e:	fe043783          	ld	a5,-32(s0)
    80202362:	639c                	ld	a5,0(a5)
    80202364:	83a9                	srli	a5,a5,0xa
    80202366:	07b2                	slli	a5,a5,0xc
    80202368:	fcf43423          	sd	a5,-56(s0)
    8020236c:	a089                	j	802023ae <walk_create+0xc2>
            pagetable_t new_pt = (pagetable_t)alloc_page();
    8020236e:	00001097          	auipc	ra,0x1
    80202372:	fc2080e7          	jalr	-62(ra) # 80203330 <alloc_page>
    80202376:	fca43c23          	sd	a0,-40(s0)
            if (!new_pt)
    8020237a:	fd843783          	ld	a5,-40(s0)
    8020237e:	e399                	bnez	a5,80202384 <walk_create+0x98>
                return 0;
    80202380:	4781                	li	a5,0
    80202382:	a8a1                	j	802023da <walk_create+0xee>
            memset(new_pt, 0, PGSIZE);
    80202384:	6605                	lui	a2,0x1
    80202386:	4581                	li	a1,0
    80202388:	fd843503          	ld	a0,-40(s0)
    8020238c:	00000097          	auipc	ra,0x0
    80202390:	b8c080e7          	jalr	-1140(ra) # 80201f18 <memset>
            *pte = PA2PTE(new_pt) | PTE_V;
    80202394:	fd843783          	ld	a5,-40(s0)
    80202398:	83b1                	srli	a5,a5,0xc
    8020239a:	07aa                	slli	a5,a5,0xa
    8020239c:	0017e713          	ori	a4,a5,1
    802023a0:	fe043783          	ld	a5,-32(s0)
    802023a4:	e398                	sd	a4,0(a5)
            pt = new_pt;
    802023a6:	fd843783          	ld	a5,-40(s0)
    802023aa:	fcf43423          	sd	a5,-56(s0)
    for (int level = 2; level > 0; level--) {
    802023ae:	fec42783          	lw	a5,-20(s0)
    802023b2:	37fd                	addiw	a5,a5,-1
    802023b4:	fef42623          	sw	a5,-20(s0)
    802023b8:	fec42783          	lw	a5,-20(s0)
    802023bc:	2781                	sext.w	a5,a5
    802023be:	f6f04be3          	bgtz	a5,80202334 <walk_create+0x48>
    return &pt[px(0, va)];
    802023c2:	fc043583          	ld	a1,-64(s0)
    802023c6:	4501                	li	a0,0
    802023c8:	00000097          	auipc	ra,0x0
    802023cc:	d72080e7          	jalr	-654(ra) # 8020213a <px>
    802023d0:	87aa                	mv	a5,a0
    802023d2:	078e                	slli	a5,a5,0x3
    802023d4:	fc843703          	ld	a4,-56(s0)
    802023d8:	97ba                	add	a5,a5,a4
}
    802023da:	853e                	mv	a0,a5
    802023dc:	70e2                	ld	ra,56(sp)
    802023de:	7442                	ld	s0,48(sp)
    802023e0:	6121                	addi	sp,sp,64
    802023e2:	8082                	ret

00000000802023e4 <map_page>:
int map_page(pagetable_t pt, uint64 va, uint64 pa, int perm) {
    802023e4:	715d                	addi	sp,sp,-80
    802023e6:	e486                	sd	ra,72(sp)
    802023e8:	e0a2                	sd	s0,64(sp)
    802023ea:	0880                	addi	s0,sp,80
    802023ec:	fca43423          	sd	a0,-56(s0)
    802023f0:	fcb43023          	sd	a1,-64(s0)
    802023f4:	fac43c23          	sd	a2,-72(s0)
    802023f8:	87b6                	mv	a5,a3
    802023fa:	faf42a23          	sw	a5,-76(s0)
    struct proc *p = myproc();
    802023fe:	00003097          	auipc	ra,0x3
    80202402:	c42080e7          	jalr	-958(ra) # 80205040 <myproc>
    80202406:	fea43023          	sd	a0,-32(s0)
	if (p && p->is_user && va >= 0x80000000
    8020240a:	fe043783          	ld	a5,-32(s0)
    8020240e:	c7a9                	beqz	a5,80202458 <map_page+0x74>
    80202410:	fe043783          	ld	a5,-32(s0)
    80202414:	0a87a783          	lw	a5,168(a5)
    80202418:	c3a1                	beqz	a5,80202458 <map_page+0x74>
    8020241a:	fc043703          	ld	a4,-64(s0)
    8020241e:	800007b7          	lui	a5,0x80000
    80202422:	fff7c793          	not	a5,a5
    80202426:	02e7f963          	bgeu	a5,a4,80202458 <map_page+0x74>
		&& va != TRAMPOLINE
    8020242a:	fc043703          	ld	a4,-64(s0)
    8020242e:	77fd                	lui	a5,0xfffff
    80202430:	02f70463          	beq	a4,a5,80202458 <map_page+0x74>
		&& va != TRAPFRAME) {
    80202434:	fc043703          	ld	a4,-64(s0)
    80202438:	77f9                	lui	a5,0xffffe
    8020243a:	00f70f63          	beq	a4,a5,80202458 <map_page+0x74>
		warning("map_page: 用户进程禁止映射内核空间");
    8020243e:	00015517          	auipc	a0,0x15
    80202442:	ed250513          	addi	a0,a0,-302 # 80217310 <user_test_table+0x178>
    80202446:	fffff097          	auipc	ra,0xfffff
    8020244a:	3c8080e7          	jalr	968(ra) # 8020180e <warning>
		exit_proc(-1);
    8020244e:	557d                	li	a0,-1
    80202450:	00004097          	auipc	ra,0x4
    80202454:	aac080e7          	jalr	-1364(ra) # 80205efc <exit_proc>
    if ((va % PGSIZE) != 0)
    80202458:	fc043703          	ld	a4,-64(s0)
    8020245c:	6785                	lui	a5,0x1
    8020245e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80202460:	8ff9                	and	a5,a5,a4
    80202462:	cb89                	beqz	a5,80202474 <map_page+0x90>
        panic("map_page: va not aligned");
    80202464:	00015517          	auipc	a0,0x15
    80202468:	edc50513          	addi	a0,a0,-292 # 80217340 <user_test_table+0x1a8>
    8020246c:	fffff097          	auipc	ra,0xfffff
    80202470:	36e080e7          	jalr	878(ra) # 802017da <panic>
    pte_t *pte = walk_create(pt, va);
    80202474:	fc043583          	ld	a1,-64(s0)
    80202478:	fc843503          	ld	a0,-56(s0)
    8020247c:	00000097          	auipc	ra,0x0
    80202480:	e70080e7          	jalr	-400(ra) # 802022ec <walk_create>
    80202484:	fca43c23          	sd	a0,-40(s0)
    if (!pte)
    80202488:	fd843783          	ld	a5,-40(s0)
    8020248c:	e399                	bnez	a5,80202492 <map_page+0xae>
        return -1;
    8020248e:	57fd                	li	a5,-1
    80202490:	a87d                	j	8020254e <map_page+0x16a>
    if (va >= 0x80000000)
    80202492:	fc043703          	ld	a4,-64(s0)
    80202496:	800007b7          	lui	a5,0x80000
    8020249a:	fff7c793          	not	a5,a5
    8020249e:	00e7f763          	bgeu	a5,a4,802024ac <map_page+0xc8>
        perm &= ~PTE_U;
    802024a2:	fb442783          	lw	a5,-76(s0)
    802024a6:	9bbd                	andi	a5,a5,-17
    802024a8:	faf42a23          	sw	a5,-76(s0)
    if (*pte & PTE_V) {
    802024ac:	fd843783          	ld	a5,-40(s0)
    802024b0:	639c                	ld	a5,0(a5)
    802024b2:	8b85                	andi	a5,a5,1
    802024b4:	cfbd                	beqz	a5,80202532 <map_page+0x14e>
        if (PTE2PA(*pte) == pa) {
    802024b6:	fd843783          	ld	a5,-40(s0)
    802024ba:	639c                	ld	a5,0(a5)
    802024bc:	83a9                	srli	a5,a5,0xa
    802024be:	07b2                	slli	a5,a5,0xc
    802024c0:	fb843703          	ld	a4,-72(s0)
    802024c4:	04f71f63          	bne	a4,a5,80202522 <map_page+0x13e>
            int new_perm = (PTE_FLAGS(*pte) | perm) & 0x3FF;
    802024c8:	fd843783          	ld	a5,-40(s0)
    802024cc:	639c                	ld	a5,0(a5)
    802024ce:	2781                	sext.w	a5,a5
    802024d0:	3ff7f793          	andi	a5,a5,1023
    802024d4:	0007871b          	sext.w	a4,a5
    802024d8:	fb442783          	lw	a5,-76(s0)
    802024dc:	8fd9                	or	a5,a5,a4
    802024de:	2781                	sext.w	a5,a5
    802024e0:	2781                	sext.w	a5,a5
    802024e2:	3ff7f793          	andi	a5,a5,1023
    802024e6:	fef42623          	sw	a5,-20(s0)
            if (va >= 0x80000000)
    802024ea:	fc043703          	ld	a4,-64(s0)
    802024ee:	800007b7          	lui	a5,0x80000
    802024f2:	fff7c793          	not	a5,a5
    802024f6:	00e7f763          	bgeu	a5,a4,80202504 <map_page+0x120>
                new_perm &= ~PTE_U;
    802024fa:	fec42783          	lw	a5,-20(s0)
    802024fe:	9bbd                	andi	a5,a5,-17
    80202500:	fef42623          	sw	a5,-20(s0)
            *pte = PA2PTE(pa) | new_perm | PTE_V;
    80202504:	fb843783          	ld	a5,-72(s0)
    80202508:	83b1                	srli	a5,a5,0xc
    8020250a:	00a79713          	slli	a4,a5,0xa
    8020250e:	fec42783          	lw	a5,-20(s0)
    80202512:	8fd9                	or	a5,a5,a4
    80202514:	0017e713          	ori	a4,a5,1
    80202518:	fd843783          	ld	a5,-40(s0)
    8020251c:	e398                	sd	a4,0(a5)
            return 0;
    8020251e:	4781                	li	a5,0
    80202520:	a03d                	j	8020254e <map_page+0x16a>
            panic("map_page: remap to different physical address");
    80202522:	00015517          	auipc	a0,0x15
    80202526:	e3e50513          	addi	a0,a0,-450 # 80217360 <user_test_table+0x1c8>
    8020252a:	fffff097          	auipc	ra,0xfffff
    8020252e:	2b0080e7          	jalr	688(ra) # 802017da <panic>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80202532:	fb843783          	ld	a5,-72(s0)
    80202536:	83b1                	srli	a5,a5,0xc
    80202538:	00a79713          	slli	a4,a5,0xa
    8020253c:	fb442783          	lw	a5,-76(s0)
    80202540:	8fd9                	or	a5,a5,a4
    80202542:	0017e713          	ori	a4,a5,1
    80202546:	fd843783          	ld	a5,-40(s0)
    8020254a:	e398                	sd	a4,0(a5)
    return 0;
    8020254c:	4781                	li	a5,0
}
    8020254e:	853e                	mv	a0,a5
    80202550:	60a6                	ld	ra,72(sp)
    80202552:	6406                	ld	s0,64(sp)
    80202554:	6161                	addi	sp,sp,80
    80202556:	8082                	ret

0000000080202558 <free_pagetable>:
void free_pagetable(pagetable_t pt) {
    80202558:	7139                	addi	sp,sp,-64
    8020255a:	fc06                	sd	ra,56(sp)
    8020255c:	f822                	sd	s0,48(sp)
    8020255e:	0080                	addi	s0,sp,64
    80202560:	fca43423          	sd	a0,-56(s0)
    for (int i = 0; i < 512; i++) {
    80202564:	fe042623          	sw	zero,-20(s0)
    80202568:	a8a5                	j	802025e0 <free_pagetable+0x88>
        pte_t pte = pt[i];
    8020256a:	fec42783          	lw	a5,-20(s0)
    8020256e:	078e                	slli	a5,a5,0x3
    80202570:	fc843703          	ld	a4,-56(s0)
    80202574:	97ba                	add	a5,a5,a4
    80202576:	639c                	ld	a5,0(a5)
    80202578:	fef43023          	sd	a5,-32(s0)
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    8020257c:	fe043783          	ld	a5,-32(s0)
    80202580:	8b85                	andi	a5,a5,1
    80202582:	cb95                	beqz	a5,802025b6 <free_pagetable+0x5e>
    80202584:	fe043783          	ld	a5,-32(s0)
    80202588:	8bb9                	andi	a5,a5,14
    8020258a:	e795                	bnez	a5,802025b6 <free_pagetable+0x5e>
            pagetable_t child = (pagetable_t)PTE2PA(pte);
    8020258c:	fe043783          	ld	a5,-32(s0)
    80202590:	83a9                	srli	a5,a5,0xa
    80202592:	07b2                	slli	a5,a5,0xc
    80202594:	fcf43c23          	sd	a5,-40(s0)
            free_pagetable(child);
    80202598:	fd843503          	ld	a0,-40(s0)
    8020259c:	00000097          	auipc	ra,0x0
    802025a0:	fbc080e7          	jalr	-68(ra) # 80202558 <free_pagetable>
            pt[i] = 0;
    802025a4:	fec42783          	lw	a5,-20(s0)
    802025a8:	078e                	slli	a5,a5,0x3
    802025aa:	fc843703          	ld	a4,-56(s0)
    802025ae:	97ba                	add	a5,a5,a4
    802025b0:	0007b023          	sd	zero,0(a5) # ffffffff80000000 <_bss_end+0xfffffffeffdb86e0>
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    802025b4:	a00d                	j	802025d6 <free_pagetable+0x7e>
        } else if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X))) {
    802025b6:	fe043783          	ld	a5,-32(s0)
    802025ba:	8b85                	andi	a5,a5,1
    802025bc:	cf89                	beqz	a5,802025d6 <free_pagetable+0x7e>
    802025be:	fe043783          	ld	a5,-32(s0)
    802025c2:	8bb9                	andi	a5,a5,14
    802025c4:	cb89                	beqz	a5,802025d6 <free_pagetable+0x7e>
            pt[i] = 0;
    802025c6:	fec42783          	lw	a5,-20(s0)
    802025ca:	078e                	slli	a5,a5,0x3
    802025cc:	fc843703          	ld	a4,-56(s0)
    802025d0:	97ba                	add	a5,a5,a4
    802025d2:	0007b023          	sd	zero,0(a5)
    for (int i = 0; i < 512; i++) {
    802025d6:	fec42783          	lw	a5,-20(s0)
    802025da:	2785                	addiw	a5,a5,1
    802025dc:	fef42623          	sw	a5,-20(s0)
    802025e0:	fec42783          	lw	a5,-20(s0)
    802025e4:	0007871b          	sext.w	a4,a5
    802025e8:	1ff00793          	li	a5,511
    802025ec:	f6e7dfe3          	bge	a5,a4,8020256a <free_pagetable+0x12>
    free_page(pt);
    802025f0:	fc843503          	ld	a0,-56(s0)
    802025f4:	00001097          	auipc	ra,0x1
    802025f8:	da8080e7          	jalr	-600(ra) # 8020339c <free_page>
}
    802025fc:	0001                	nop
    802025fe:	70e2                	ld	ra,56(sp)
    80202600:	7442                	ld	s0,48(sp)
    80202602:	6121                	addi	sp,sp,64
    80202604:	8082                	ret

0000000080202606 <kvmmake>:
static pagetable_t kvmmake(void) {
    80202606:	715d                	addi	sp,sp,-80
    80202608:	e486                	sd	ra,72(sp)
    8020260a:	e0a2                	sd	s0,64(sp)
    8020260c:	0880                	addi	s0,sp,80
    pagetable_t kpgtbl = create_pagetable();
    8020260e:	00000097          	auipc	ra,0x0
    80202612:	b66080e7          	jalr	-1178(ra) # 80202174 <create_pagetable>
    80202616:	fca43423          	sd	a0,-56(s0)
    if (!kpgtbl){
    8020261a:	fc843783          	ld	a5,-56(s0)
    8020261e:	eb89                	bnez	a5,80202630 <kvmmake+0x2a>
        panic("kvmmake: alloc failed");
    80202620:	00015517          	auipc	a0,0x15
    80202624:	d7050513          	addi	a0,a0,-656 # 80217390 <user_test_table+0x1f8>
    80202628:	fffff097          	auipc	ra,0xfffff
    8020262c:	1b2080e7          	jalr	434(ra) # 802017da <panic>
	for (uint64 pa = KERNBASE; pa < PHYSTOP; pa += PGSIZE) {
    80202630:	4785                	li	a5,1
    80202632:	07fe                	slli	a5,a5,0x1f
    80202634:	fef43423          	sd	a5,-24(s0)
    80202638:	a8a1                	j	80202690 <kvmmake+0x8a>
        int perm = PTE_R | PTE_W;
    8020263a:	4799                	li	a5,6
    8020263c:	fef42223          	sw	a5,-28(s0)
        if (pa < (uint64)etext)
    80202640:	0000a797          	auipc	a5,0xa
    80202644:	9c078793          	addi	a5,a5,-1600 # 8020c000 <etext>
    80202648:	fe843703          	ld	a4,-24(s0)
    8020264c:	00f77563          	bgeu	a4,a5,80202656 <kvmmake+0x50>
            perm = PTE_R | PTE_X;
    80202650:	47a9                	li	a5,10
    80202652:	fef42223          	sw	a5,-28(s0)
        if (map_page(kpgtbl, pa, pa, perm) != 0)
    80202656:	fe442783          	lw	a5,-28(s0)
    8020265a:	86be                	mv	a3,a5
    8020265c:	fe843603          	ld	a2,-24(s0)
    80202660:	fe843583          	ld	a1,-24(s0)
    80202664:	fc843503          	ld	a0,-56(s0)
    80202668:	00000097          	auipc	ra,0x0
    8020266c:	d7c080e7          	jalr	-644(ra) # 802023e4 <map_page>
    80202670:	87aa                	mv	a5,a0
    80202672:	cb89                	beqz	a5,80202684 <kvmmake+0x7e>
            panic("kvmmake: heap map failed");
    80202674:	00015517          	auipc	a0,0x15
    80202678:	d3450513          	addi	a0,a0,-716 # 802173a8 <user_test_table+0x210>
    8020267c:	fffff097          	auipc	ra,0xfffff
    80202680:	15e080e7          	jalr	350(ra) # 802017da <panic>
	for (uint64 pa = KERNBASE; pa < PHYSTOP; pa += PGSIZE) {
    80202684:	fe843703          	ld	a4,-24(s0)
    80202688:	6785                	lui	a5,0x1
    8020268a:	97ba                	add	a5,a5,a4
    8020268c:	fef43423          	sd	a5,-24(s0)
    80202690:	fe843703          	ld	a4,-24(s0)
    80202694:	47c5                	li	a5,17
    80202696:	07ee                	slli	a5,a5,0x1b
    80202698:	faf761e3          	bltu	a4,a5,8020263a <kvmmake+0x34>
    if (map_page(kpgtbl, UART0, UART0, PTE_R | PTE_W) != 0)
    8020269c:	4699                	li	a3,6
    8020269e:	10000637          	lui	a2,0x10000
    802026a2:	100005b7          	lui	a1,0x10000
    802026a6:	fc843503          	ld	a0,-56(s0)
    802026aa:	00000097          	auipc	ra,0x0
    802026ae:	d3a080e7          	jalr	-710(ra) # 802023e4 <map_page>
    802026b2:	87aa                	mv	a5,a0
    802026b4:	cb89                	beqz	a5,802026c6 <kvmmake+0xc0>
        panic("kvmmake: uart map failed");
    802026b6:	00015517          	auipc	a0,0x15
    802026ba:	d1250513          	addi	a0,a0,-750 # 802173c8 <user_test_table+0x230>
    802026be:	fffff097          	auipc	ra,0xfffff
    802026c2:	11c080e7          	jalr	284(ra) # 802017da <panic>
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    802026c6:	0c0007b7          	lui	a5,0xc000
    802026ca:	fcf43c23          	sd	a5,-40(s0)
    802026ce:	a825                	j	80202706 <kvmmake+0x100>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    802026d0:	4699                	li	a3,6
    802026d2:	fd843603          	ld	a2,-40(s0)
    802026d6:	fd843583          	ld	a1,-40(s0)
    802026da:	fc843503          	ld	a0,-56(s0)
    802026de:	00000097          	auipc	ra,0x0
    802026e2:	d06080e7          	jalr	-762(ra) # 802023e4 <map_page>
    802026e6:	87aa                	mv	a5,a0
    802026e8:	cb89                	beqz	a5,802026fa <kvmmake+0xf4>
            panic("kvmmake: plic map failed");
    802026ea:	00015517          	auipc	a0,0x15
    802026ee:	cfe50513          	addi	a0,a0,-770 # 802173e8 <user_test_table+0x250>
    802026f2:	fffff097          	auipc	ra,0xfffff
    802026f6:	0e8080e7          	jalr	232(ra) # 802017da <panic>
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    802026fa:	fd843703          	ld	a4,-40(s0)
    802026fe:	6785                	lui	a5,0x1
    80202700:	97ba                	add	a5,a5,a4
    80202702:	fcf43c23          	sd	a5,-40(s0)
    80202706:	fd843703          	ld	a4,-40(s0)
    8020270a:	0c4007b7          	lui	a5,0xc400
    8020270e:	fcf761e3          	bltu	a4,a5,802026d0 <kvmmake+0xca>
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    80202712:	020007b7          	lui	a5,0x2000
    80202716:	fcf43823          	sd	a5,-48(s0)
    8020271a:	a825                	j	80202752 <kvmmake+0x14c>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    8020271c:	4699                	li	a3,6
    8020271e:	fd043603          	ld	a2,-48(s0)
    80202722:	fd043583          	ld	a1,-48(s0)
    80202726:	fc843503          	ld	a0,-56(s0)
    8020272a:	00000097          	auipc	ra,0x0
    8020272e:	cba080e7          	jalr	-838(ra) # 802023e4 <map_page>
    80202732:	87aa                	mv	a5,a0
    80202734:	cb89                	beqz	a5,80202746 <kvmmake+0x140>
            panic("kvmmake: clint map failed");
    80202736:	00015517          	auipc	a0,0x15
    8020273a:	cd250513          	addi	a0,a0,-814 # 80217408 <user_test_table+0x270>
    8020273e:	fffff097          	auipc	ra,0xfffff
    80202742:	09c080e7          	jalr	156(ra) # 802017da <panic>
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    80202746:	fd043703          	ld	a4,-48(s0)
    8020274a:	6785                	lui	a5,0x1
    8020274c:	97ba                	add	a5,a5,a4
    8020274e:	fcf43823          	sd	a5,-48(s0)
    80202752:	fd043703          	ld	a4,-48(s0)
    80202756:	020107b7          	lui	a5,0x2010
    8020275a:	fcf761e3          	bltu	a4,a5,8020271c <kvmmake+0x116>
    if (map_page(kpgtbl, VIRTIO0, VIRTIO0, PTE_R | PTE_W) != 0)
    8020275e:	4699                	li	a3,6
    80202760:	10001637          	lui	a2,0x10001
    80202764:	100015b7          	lui	a1,0x10001
    80202768:	fc843503          	ld	a0,-56(s0)
    8020276c:	00000097          	auipc	ra,0x0
    80202770:	c78080e7          	jalr	-904(ra) # 802023e4 <map_page>
    80202774:	87aa                	mv	a5,a0
    80202776:	cb89                	beqz	a5,80202788 <kvmmake+0x182>
        panic("kvmmake: virtio map failed");
    80202778:	00015517          	auipc	a0,0x15
    8020277c:	cb050513          	addi	a0,a0,-848 # 80217428 <user_test_table+0x290>
    80202780:	fffff097          	auipc	ra,0xfffff
    80202784:	05a080e7          	jalr	90(ra) # 802017da <panic>
	void *tramp_phys = alloc_page();
    80202788:	00001097          	auipc	ra,0x1
    8020278c:	ba8080e7          	jalr	-1112(ra) # 80203330 <alloc_page>
    80202790:	fca43023          	sd	a0,-64(s0)
	if (!tramp_phys)
    80202794:	fc043783          	ld	a5,-64(s0)
    80202798:	eb89                	bnez	a5,802027aa <kvmmake+0x1a4>
		panic("kvmmake: alloc trampoline page failed");
    8020279a:	00015517          	auipc	a0,0x15
    8020279e:	cae50513          	addi	a0,a0,-850 # 80217448 <user_test_table+0x2b0>
    802027a2:	fffff097          	auipc	ra,0xfffff
    802027a6:	038080e7          	jalr	56(ra) # 802017da <panic>
	memcpy(tramp_phys, trampoline, PGSIZE);
    802027aa:	6605                	lui	a2,0x1
    802027ac:	00002597          	auipc	a1,0x2
    802027b0:	5d458593          	addi	a1,a1,1492 # 80204d80 <trampoline>
    802027b4:	fc043503          	ld	a0,-64(s0)
    802027b8:	00000097          	auipc	ra,0x0
    802027bc:	86c080e7          	jalr	-1940(ra) # 80202024 <memcpy>
	void *trapframe_phys = alloc_page();
    802027c0:	00001097          	auipc	ra,0x1
    802027c4:	b70080e7          	jalr	-1168(ra) # 80203330 <alloc_page>
    802027c8:	faa43c23          	sd	a0,-72(s0)
	if (!trapframe_phys)
    802027cc:	fb843783          	ld	a5,-72(s0)
    802027d0:	eb89                	bnez	a5,802027e2 <kvmmake+0x1dc>
		panic("kvmmake: alloc trapframe page failed");
    802027d2:	00015517          	auipc	a0,0x15
    802027d6:	c9e50513          	addi	a0,a0,-866 # 80217470 <user_test_table+0x2d8>
    802027da:	fffff097          	auipc	ra,0xfffff
    802027de:	000080e7          	jalr	ra # 802017da <panic>
	memset(trapframe_phys, 0, PGSIZE);
    802027e2:	6605                	lui	a2,0x1
    802027e4:	4581                	li	a1,0
    802027e6:	fb843503          	ld	a0,-72(s0)
    802027ea:	fffff097          	auipc	ra,0xfffff
    802027ee:	72e080e7          	jalr	1838(ra) # 80201f18 <memset>
	if (map_page(kpgtbl, TRAMPOLINE, (uint64)tramp_phys, PTE_R | PTE_X) != 0){
    802027f2:	fc043783          	ld	a5,-64(s0)
    802027f6:	46a9                	li	a3,10
    802027f8:	863e                	mv	a2,a5
    802027fa:	75fd                	lui	a1,0xfffff
    802027fc:	fc843503          	ld	a0,-56(s0)
    80202800:	00000097          	auipc	ra,0x0
    80202804:	be4080e7          	jalr	-1052(ra) # 802023e4 <map_page>
    80202808:	87aa                	mv	a5,a0
    8020280a:	cb89                	beqz	a5,8020281c <kvmmake+0x216>
		panic("kvmmake: trampoline map failed");
    8020280c:	00015517          	auipc	a0,0x15
    80202810:	c8c50513          	addi	a0,a0,-884 # 80217498 <user_test_table+0x300>
    80202814:	fffff097          	auipc	ra,0xfffff
    80202818:	fc6080e7          	jalr	-58(ra) # 802017da <panic>
	if (map_page(kpgtbl, TRAPFRAME, (uint64)trapframe_phys, PTE_R | PTE_W) != 0){
    8020281c:	fb843783          	ld	a5,-72(s0)
    80202820:	4699                	li	a3,6
    80202822:	863e                	mv	a2,a5
    80202824:	75f9                	lui	a1,0xffffe
    80202826:	fc843503          	ld	a0,-56(s0)
    8020282a:	00000097          	auipc	ra,0x0
    8020282e:	bba080e7          	jalr	-1094(ra) # 802023e4 <map_page>
    80202832:	87aa                	mv	a5,a0
    80202834:	cb89                	beqz	a5,80202846 <kvmmake+0x240>
		panic("kvmmake: trapframe map failed");
    80202836:	00015517          	auipc	a0,0x15
    8020283a:	c8250513          	addi	a0,a0,-894 # 802174b8 <user_test_table+0x320>
    8020283e:	fffff097          	auipc	ra,0xfffff
    80202842:	f9c080e7          	jalr	-100(ra) # 802017da <panic>
	trampoline_phys_addr = (uint64)tramp_phys;
    80202846:	fc043703          	ld	a4,-64(s0)
    8020284a:	0003a797          	auipc	a5,0x3a
    8020284e:	85e78793          	addi	a5,a5,-1954 # 8023c0a8 <trampoline_phys_addr>
    80202852:	e398                	sd	a4,0(a5)
	trapframe_phys_addr = (uint64)trapframe_phys;
    80202854:	fb843703          	ld	a4,-72(s0)
    80202858:	0003a797          	auipc	a5,0x3a
    8020285c:	85878793          	addi	a5,a5,-1960 # 8023c0b0 <trapframe_phys_addr>
    80202860:	e398                	sd	a4,0(a5)
	printf("trampoline_phy_addr = %lx\n",trampoline_phys_addr);
    80202862:	0003a797          	auipc	a5,0x3a
    80202866:	84678793          	addi	a5,a5,-1978 # 8023c0a8 <trampoline_phys_addr>
    8020286a:	639c                	ld	a5,0(a5)
    8020286c:	85be                	mv	a1,a5
    8020286e:	00015517          	auipc	a0,0x15
    80202872:	c6a50513          	addi	a0,a0,-918 # 802174d8 <user_test_table+0x340>
    80202876:	ffffe097          	auipc	ra,0xffffe
    8020287a:	518080e7          	jalr	1304(ra) # 80200d8e <printf>
	printf("trapframe_phys_addr = %lx\n",trapframe_phys_addr);
    8020287e:	0003a797          	auipc	a5,0x3a
    80202882:	83278793          	addi	a5,a5,-1998 # 8023c0b0 <trapframe_phys_addr>
    80202886:	639c                	ld	a5,0(a5)
    80202888:	85be                	mv	a1,a5
    8020288a:	00015517          	auipc	a0,0x15
    8020288e:	c6e50513          	addi	a0,a0,-914 # 802174f8 <user_test_table+0x360>
    80202892:	ffffe097          	auipc	ra,0xffffe
    80202896:	4fc080e7          	jalr	1276(ra) # 80200d8e <printf>
    return kpgtbl;
    8020289a:	fc843783          	ld	a5,-56(s0)
}
    8020289e:	853e                	mv	a0,a5
    802028a0:	60a6                	ld	ra,72(sp)
    802028a2:	6406                	ld	s0,64(sp)
    802028a4:	6161                	addi	sp,sp,80
    802028a6:	8082                	ret

00000000802028a8 <w_satp>:
static inline void w_satp(uint64 x) {
    802028a8:	1101                	addi	sp,sp,-32
    802028aa:	ec22                	sd	s0,24(sp)
    802028ac:	1000                	addi	s0,sp,32
    802028ae:	fea43423          	sd	a0,-24(s0)
    asm volatile("csrw satp, %0" : : "r"(x));
    802028b2:	fe843783          	ld	a5,-24(s0)
    802028b6:	18079073          	csrw	satp,a5
}
    802028ba:	0001                	nop
    802028bc:	6462                	ld	s0,24(sp)
    802028be:	6105                	addi	sp,sp,32
    802028c0:	8082                	ret

00000000802028c2 <sfence_vma>:
inline void sfence_vma(void) {
    802028c2:	1141                	addi	sp,sp,-16
    802028c4:	e422                	sd	s0,8(sp)
    802028c6:	0800                	addi	s0,sp,16
    asm volatile("sfence.vma zero, zero");
    802028c8:	12000073          	sfence.vma
}
    802028cc:	0001                	nop
    802028ce:	6422                	ld	s0,8(sp)
    802028d0:	0141                	addi	sp,sp,16
    802028d2:	8082                	ret

00000000802028d4 <kvminit>:
void kvminit(void) {
    802028d4:	1141                	addi	sp,sp,-16
    802028d6:	e406                	sd	ra,8(sp)
    802028d8:	e022                	sd	s0,0(sp)
    802028da:	0800                	addi	s0,sp,16
    kernel_pagetable = kvmmake();
    802028dc:	00000097          	auipc	ra,0x0
    802028e0:	d2a080e7          	jalr	-726(ra) # 80202606 <kvmmake>
    802028e4:	872a                	mv	a4,a0
    802028e6:	00039797          	auipc	a5,0x39
    802028ea:	7ba78793          	addi	a5,a5,1978 # 8023c0a0 <kernel_pagetable>
    802028ee:	e398                	sd	a4,0(a5)
    sfence_vma();
    802028f0:	00000097          	auipc	ra,0x0
    802028f4:	fd2080e7          	jalr	-46(ra) # 802028c2 <sfence_vma>
    w_satp(MAKE_SATP(kernel_pagetable));
    802028f8:	00039797          	auipc	a5,0x39
    802028fc:	7a878793          	addi	a5,a5,1960 # 8023c0a0 <kernel_pagetable>
    80202900:	639c                	ld	a5,0(a5)
    80202902:	00c7d713          	srli	a4,a5,0xc
    80202906:	57fd                	li	a5,-1
    80202908:	17fe                	slli	a5,a5,0x3f
    8020290a:	8fd9                	or	a5,a5,a4
    8020290c:	853e                	mv	a0,a5
    8020290e:	00000097          	auipc	ra,0x0
    80202912:	f9a080e7          	jalr	-102(ra) # 802028a8 <w_satp>
    sfence_vma();
    80202916:	00000097          	auipc	ra,0x0
    8020291a:	fac080e7          	jalr	-84(ra) # 802028c2 <sfence_vma>
    printf("[KVM] 内核分页已启用，satp=0x%lx\n", MAKE_SATP(kernel_pagetable));
    8020291e:	00039797          	auipc	a5,0x39
    80202922:	78278793          	addi	a5,a5,1922 # 8023c0a0 <kernel_pagetable>
    80202926:	639c                	ld	a5,0(a5)
    80202928:	00c7d713          	srli	a4,a5,0xc
    8020292c:	57fd                	li	a5,-1
    8020292e:	17fe                	slli	a5,a5,0x3f
    80202930:	8fd9                	or	a5,a5,a4
    80202932:	85be                	mv	a1,a5
    80202934:	00015517          	auipc	a0,0x15
    80202938:	be450513          	addi	a0,a0,-1052 # 80217518 <user_test_table+0x380>
    8020293c:	ffffe097          	auipc	ra,0xffffe
    80202940:	452080e7          	jalr	1106(ra) # 80200d8e <printf>
}
    80202944:	0001                	nop
    80202946:	60a2                	ld	ra,8(sp)
    80202948:	6402                	ld	s0,0(sp)
    8020294a:	0141                	addi	sp,sp,16
    8020294c:	8082                	ret

000000008020294e <get_current_pagetable>:
pagetable_t get_current_pagetable(void) {
    8020294e:	1141                	addi	sp,sp,-16
    80202950:	e422                	sd	s0,8(sp)
    80202952:	0800                	addi	s0,sp,16
    return kernel_pagetable;  // 在没有进程时返回内核页表
    80202954:	00039797          	auipc	a5,0x39
    80202958:	74c78793          	addi	a5,a5,1868 # 8023c0a0 <kernel_pagetable>
    8020295c:	639c                	ld	a5,0(a5)
}
    8020295e:	853e                	mv	a0,a5
    80202960:	6422                	ld	s0,8(sp)
    80202962:	0141                	addi	sp,sp,16
    80202964:	8082                	ret

0000000080202966 <print_pagetable>:
void print_pagetable(pagetable_t pagetable, int level, uint64 va_base) {
    80202966:	715d                	addi	sp,sp,-80
    80202968:	e486                	sd	ra,72(sp)
    8020296a:	e0a2                	sd	s0,64(sp)
    8020296c:	0880                	addi	s0,sp,80
    8020296e:	fca43423          	sd	a0,-56(s0)
    80202972:	87ae                	mv	a5,a1
    80202974:	fac43c23          	sd	a2,-72(s0)
    80202978:	fcf42223          	sw	a5,-60(s0)
    for (int i = 0; i < 512; i++) {
    8020297c:	fe042623          	sw	zero,-20(s0)
    80202980:	a0c5                	j	80202a60 <print_pagetable+0xfa>
        pte_t pte = pagetable[i];
    80202982:	fec42783          	lw	a5,-20(s0)
    80202986:	078e                	slli	a5,a5,0x3
    80202988:	fc843703          	ld	a4,-56(s0)
    8020298c:	97ba                	add	a5,a5,a4
    8020298e:	639c                	ld	a5,0(a5)
    80202990:	fef43023          	sd	a5,-32(s0)
        if (pte & PTE_V) {
    80202994:	fe043783          	ld	a5,-32(s0)
    80202998:	8b85                	andi	a5,a5,1
    8020299a:	cfd5                	beqz	a5,80202a56 <print_pagetable+0xf0>
            uint64 pa = PTE2PA(pte);
    8020299c:	fe043783          	ld	a5,-32(s0)
    802029a0:	83a9                	srli	a5,a5,0xa
    802029a2:	07b2                	slli	a5,a5,0xc
    802029a4:	fcf43c23          	sd	a5,-40(s0)
            uint64 va = va_base + (i << (12 + 9 * (2 - level)));
    802029a8:	4789                	li	a5,2
    802029aa:	fc442703          	lw	a4,-60(s0)
    802029ae:	9f99                	subw	a5,a5,a4
    802029b0:	2781                	sext.w	a5,a5
    802029b2:	873e                	mv	a4,a5
    802029b4:	87ba                	mv	a5,a4
    802029b6:	0037979b          	slliw	a5,a5,0x3
    802029ba:	9fb9                	addw	a5,a5,a4
    802029bc:	2781                	sext.w	a5,a5
    802029be:	27b1                	addiw	a5,a5,12
    802029c0:	2781                	sext.w	a5,a5
    802029c2:	fec42703          	lw	a4,-20(s0)
    802029c6:	00f717bb          	sllw	a5,a4,a5
    802029ca:	2781                	sext.w	a5,a5
    802029cc:	873e                	mv	a4,a5
    802029ce:	fb843783          	ld	a5,-72(s0)
    802029d2:	97ba                	add	a5,a5,a4
    802029d4:	fcf43823          	sd	a5,-48(s0)
            for (int l = 0; l < level; l++) printf("  "); // 缩进
    802029d8:	fe042423          	sw	zero,-24(s0)
    802029dc:	a831                	j	802029f8 <print_pagetable+0x92>
    802029de:	00015517          	auipc	a0,0x15
    802029e2:	b6a50513          	addi	a0,a0,-1174 # 80217548 <user_test_table+0x3b0>
    802029e6:	ffffe097          	auipc	ra,0xffffe
    802029ea:	3a8080e7          	jalr	936(ra) # 80200d8e <printf>
    802029ee:	fe842783          	lw	a5,-24(s0)
    802029f2:	2785                	addiw	a5,a5,1
    802029f4:	fef42423          	sw	a5,-24(s0)
    802029f8:	fe842783          	lw	a5,-24(s0)
    802029fc:	873e                	mv	a4,a5
    802029fe:	fc442783          	lw	a5,-60(s0)
    80202a02:	2701                	sext.w	a4,a4
    80202a04:	2781                	sext.w	a5,a5
    80202a06:	fcf74ce3          	blt	a4,a5,802029de <print_pagetable+0x78>
            printf("L%d[%3d] VA:0x%lx -> PA:0x%lx flags:0x%lx\n", level, i, va, pa, pte & 0x3FF);
    80202a0a:	fe043783          	ld	a5,-32(s0)
    80202a0e:	3ff7f793          	andi	a5,a5,1023
    80202a12:	fec42603          	lw	a2,-20(s0)
    80202a16:	fc442583          	lw	a1,-60(s0)
    80202a1a:	fd843703          	ld	a4,-40(s0)
    80202a1e:	fd043683          	ld	a3,-48(s0)
    80202a22:	00015517          	auipc	a0,0x15
    80202a26:	b2e50513          	addi	a0,a0,-1234 # 80217550 <user_test_table+0x3b8>
    80202a2a:	ffffe097          	auipc	ra,0xffffe
    80202a2e:	364080e7          	jalr	868(ra) # 80200d8e <printf>
            if ((pte & (PTE_R | PTE_W | PTE_X)) == 0) { // 不是叶子
    80202a32:	fe043783          	ld	a5,-32(s0)
    80202a36:	8bb9                	andi	a5,a5,14
    80202a38:	ef99                	bnez	a5,80202a56 <print_pagetable+0xf0>
                print_pagetable((pagetable_t)pa, level + 1, va);
    80202a3a:	fd843783          	ld	a5,-40(s0)
    80202a3e:	fc442703          	lw	a4,-60(s0)
    80202a42:	2705                	addiw	a4,a4,1
    80202a44:	2701                	sext.w	a4,a4
    80202a46:	fd043603          	ld	a2,-48(s0)
    80202a4a:	85ba                	mv	a1,a4
    80202a4c:	853e                	mv	a0,a5
    80202a4e:	00000097          	auipc	ra,0x0
    80202a52:	f18080e7          	jalr	-232(ra) # 80202966 <print_pagetable>
    for (int i = 0; i < 512; i++) {
    80202a56:	fec42783          	lw	a5,-20(s0)
    80202a5a:	2785                	addiw	a5,a5,1
    80202a5c:	fef42623          	sw	a5,-20(s0)
    80202a60:	fec42783          	lw	a5,-20(s0)
    80202a64:	0007871b          	sext.w	a4,a5
    80202a68:	1ff00793          	li	a5,511
    80202a6c:	f0e7dbe3          	bge	a5,a4,80202982 <print_pagetable+0x1c>
}
    80202a70:	0001                	nop
    80202a72:	0001                	nop
    80202a74:	60a6                	ld	ra,72(sp)
    80202a76:	6406                	ld	s0,64(sp)
    80202a78:	6161                	addi	sp,sp,80
    80202a7a:	8082                	ret

0000000080202a7c <handle_page_fault>:
int handle_page_fault(uint64 va, int type) {
    80202a7c:	715d                	addi	sp,sp,-80
    80202a7e:	e486                	sd	ra,72(sp)
    80202a80:	e0a2                	sd	s0,64(sp)
    80202a82:	0880                	addi	s0,sp,80
    80202a84:	faa43c23          	sd	a0,-72(s0)
    80202a88:	87ae                	mv	a5,a1
    80202a8a:	faf42a23          	sw	a5,-76(s0)
    printf("[PAGE FAULT] 处理地址 0x%lx, 类型 %d\n", va, type);
    80202a8e:	fb442783          	lw	a5,-76(s0)
    80202a92:	863e                	mv	a2,a5
    80202a94:	fb843583          	ld	a1,-72(s0)
    80202a98:	00015517          	auipc	a0,0x15
    80202a9c:	ae850513          	addi	a0,a0,-1304 # 80217580 <user_test_table+0x3e8>
    80202aa0:	ffffe097          	auipc	ra,0xffffe
    80202aa4:	2ee080e7          	jalr	750(ra) # 80200d8e <printf>
    uint64 page_va = (va / PGSIZE) * PGSIZE;
    80202aa8:	fb843703          	ld	a4,-72(s0)
    80202aac:	77fd                	lui	a5,0xfffff
    80202aae:	8ff9                	and	a5,a5,a4
    80202ab0:	fcf43c23          	sd	a5,-40(s0)
    if (page_va >= MAXVA) {
    80202ab4:	fd843703          	ld	a4,-40(s0)
    80202ab8:	57fd                	li	a5,-1
    80202aba:	83e5                	srli	a5,a5,0x19
    80202abc:	00e7fc63          	bgeu	a5,a4,80202ad4 <handle_page_fault+0x58>
        printf("[PAGE FAULT] 虚拟地址超出范围\n");
    80202ac0:	00015517          	auipc	a0,0x15
    80202ac4:	af050513          	addi	a0,a0,-1296 # 802175b0 <user_test_table+0x418>
    80202ac8:	ffffe097          	auipc	ra,0xffffe
    80202acc:	2c6080e7          	jalr	710(ra) # 80200d8e <printf>
        return 0;
    80202ad0:	4781                	li	a5,0
    80202ad2:	a2ed                	j	80202cbc <handle_page_fault+0x240>
    struct proc *p = myproc();
    80202ad4:	00002097          	auipc	ra,0x2
    80202ad8:	56c080e7          	jalr	1388(ra) # 80205040 <myproc>
    80202adc:	fca43823          	sd	a0,-48(s0)
    pagetable_t pt = kernel_pagetable;
    80202ae0:	00039797          	auipc	a5,0x39
    80202ae4:	5c078793          	addi	a5,a5,1472 # 8023c0a0 <kernel_pagetable>
    80202ae8:	639c                	ld	a5,0(a5)
    80202aea:	fef43423          	sd	a5,-24(s0)
    if (p && p->pagetable && p->is_user) {
    80202aee:	fd043783          	ld	a5,-48(s0)
    80202af2:	cf99                	beqz	a5,80202b10 <handle_page_fault+0x94>
    80202af4:	fd043783          	ld	a5,-48(s0)
    80202af8:	7fdc                	ld	a5,184(a5)
    80202afa:	cb99                	beqz	a5,80202b10 <handle_page_fault+0x94>
    80202afc:	fd043783          	ld	a5,-48(s0)
    80202b00:	0a87a783          	lw	a5,168(a5)
    80202b04:	c791                	beqz	a5,80202b10 <handle_page_fault+0x94>
        pt = p->pagetable;
    80202b06:	fd043783          	ld	a5,-48(s0)
    80202b0a:	7fdc                	ld	a5,184(a5)
    80202b0c:	fef43423          	sd	a5,-24(s0)
    pte_t *pte = walk_lookup(pt, page_va);
    80202b10:	fd843583          	ld	a1,-40(s0)
    80202b14:	fe843503          	ld	a0,-24(s0)
    80202b18:	fffff097          	auipc	ra,0xfffff
    80202b1c:	698080e7          	jalr	1688(ra) # 802021b0 <walk_lookup>
    80202b20:	fca43423          	sd	a0,-56(s0)
    if (pte && (*pte & PTE_V)) {
    80202b24:	fc843783          	ld	a5,-56(s0)
    80202b28:	cbdd                	beqz	a5,80202bde <handle_page_fault+0x162>
    80202b2a:	fc843783          	ld	a5,-56(s0)
    80202b2e:	639c                	ld	a5,0(a5)
    80202b30:	8b85                	andi	a5,a5,1
    80202b32:	c7d5                	beqz	a5,80202bde <handle_page_fault+0x162>
        int need_perm = 0;
    80202b34:	fe042223          	sw	zero,-28(s0)
        if (type == 1) need_perm = PTE_X;
    80202b38:	fb442783          	lw	a5,-76(s0)
    80202b3c:	0007871b          	sext.w	a4,a5
    80202b40:	4785                	li	a5,1
    80202b42:	00f71663          	bne	a4,a5,80202b4e <handle_page_fault+0xd2>
    80202b46:	47a1                	li	a5,8
    80202b48:	fef42223          	sw	a5,-28(s0)
    80202b4c:	a035                	j	80202b78 <handle_page_fault+0xfc>
        else if (type == 2) need_perm = PTE_R;
    80202b4e:	fb442783          	lw	a5,-76(s0)
    80202b52:	0007871b          	sext.w	a4,a5
    80202b56:	4789                	li	a5,2
    80202b58:	00f71663          	bne	a4,a5,80202b64 <handle_page_fault+0xe8>
    80202b5c:	4789                	li	a5,2
    80202b5e:	fef42223          	sw	a5,-28(s0)
    80202b62:	a819                	j	80202b78 <handle_page_fault+0xfc>
        else if (type == 3) need_perm = PTE_R | PTE_W;
    80202b64:	fb442783          	lw	a5,-76(s0)
    80202b68:	0007871b          	sext.w	a4,a5
    80202b6c:	478d                	li	a5,3
    80202b6e:	00f71563          	bne	a4,a5,80202b78 <handle_page_fault+0xfc>
    80202b72:	4799                	li	a5,6
    80202b74:	fef42223          	sw	a5,-28(s0)
        if ((*pte & need_perm) != need_perm) {
    80202b78:	fc843783          	ld	a5,-56(s0)
    80202b7c:	6398                	ld	a4,0(a5)
    80202b7e:	fe442783          	lw	a5,-28(s0)
    80202b82:	8f7d                	and	a4,a4,a5
    80202b84:	fe442783          	lw	a5,-28(s0)
    80202b88:	02f70963          	beq	a4,a5,80202bba <handle_page_fault+0x13e>
            *pte |= need_perm;
    80202b8c:	fc843783          	ld	a5,-56(s0)
    80202b90:	6398                	ld	a4,0(a5)
    80202b92:	fe442783          	lw	a5,-28(s0)
    80202b96:	8f5d                	or	a4,a4,a5
    80202b98:	fc843783          	ld	a5,-56(s0)
    80202b9c:	e398                	sd	a4,0(a5)
            sfence_vma();
    80202b9e:	00000097          	auipc	ra,0x0
    80202ba2:	d24080e7          	jalr	-732(ra) # 802028c2 <sfence_vma>
            printf("[PAGE FAULT] 已更新页面权限\n");
    80202ba6:	00015517          	auipc	a0,0x15
    80202baa:	a3250513          	addi	a0,a0,-1486 # 802175d8 <user_test_table+0x440>
    80202bae:	ffffe097          	auipc	ra,0xffffe
    80202bb2:	1e0080e7          	jalr	480(ra) # 80200d8e <printf>
            return 1;
    80202bb6:	4785                	li	a5,1
    80202bb8:	a211                	j	80202cbc <handle_page_fault+0x240>
        printf("[PAGE FAULT] 页面已映射且权限正确\n");
    80202bba:	00015517          	auipc	a0,0x15
    80202bbe:	a4650513          	addi	a0,a0,-1466 # 80217600 <user_test_table+0x468>
    80202bc2:	ffffe097          	auipc	ra,0xffffe
    80202bc6:	1cc080e7          	jalr	460(ra) # 80200d8e <printf>
		panic("debug");
    80202bca:	00015517          	auipc	a0,0x15
    80202bce:	a6650513          	addi	a0,a0,-1434 # 80217630 <user_test_table+0x498>
    80202bd2:	fffff097          	auipc	ra,0xfffff
    80202bd6:	c08080e7          	jalr	-1016(ra) # 802017da <panic>
        return 1;
    80202bda:	4785                	li	a5,1
    80202bdc:	a0c5                	j	80202cbc <handle_page_fault+0x240>
    void* page = alloc_page();
    80202bde:	00000097          	auipc	ra,0x0
    80202be2:	752080e7          	jalr	1874(ra) # 80203330 <alloc_page>
    80202be6:	fca43023          	sd	a0,-64(s0)
    if (page == 0) {
    80202bea:	fc043783          	ld	a5,-64(s0)
    80202bee:	eb99                	bnez	a5,80202c04 <handle_page_fault+0x188>
        printf("[PAGE FAULT] 内存不足，无法分配页面\n");
    80202bf0:	00015517          	auipc	a0,0x15
    80202bf4:	a4850513          	addi	a0,a0,-1464 # 80217638 <user_test_table+0x4a0>
    80202bf8:	ffffe097          	auipc	ra,0xffffe
    80202bfc:	196080e7          	jalr	406(ra) # 80200d8e <printf>
        return 0;
    80202c00:	4781                	li	a5,0
    80202c02:	a86d                	j	80202cbc <handle_page_fault+0x240>
    memset(page, 0, PGSIZE);
    80202c04:	6605                	lui	a2,0x1
    80202c06:	4581                	li	a1,0
    80202c08:	fc043503          	ld	a0,-64(s0)
    80202c0c:	fffff097          	auipc	ra,0xfffff
    80202c10:	30c080e7          	jalr	780(ra) # 80201f18 <memset>
    int perm = 0;
    80202c14:	fe042023          	sw	zero,-32(s0)
    if (type == 1) perm = PTE_X | PTE_R | PTE_U;
    80202c18:	fb442783          	lw	a5,-76(s0)
    80202c1c:	0007871b          	sext.w	a4,a5
    80202c20:	4785                	li	a5,1
    80202c22:	00f71663          	bne	a4,a5,80202c2e <handle_page_fault+0x1b2>
    80202c26:	47e9                	li	a5,26
    80202c28:	fef42023          	sw	a5,-32(s0)
    80202c2c:	a035                	j	80202c58 <handle_page_fault+0x1dc>
    else if (type == 2) perm = PTE_R | PTE_U;
    80202c2e:	fb442783          	lw	a5,-76(s0)
    80202c32:	0007871b          	sext.w	a4,a5
    80202c36:	4789                	li	a5,2
    80202c38:	00f71663          	bne	a4,a5,80202c44 <handle_page_fault+0x1c8>
    80202c3c:	47c9                	li	a5,18
    80202c3e:	fef42023          	sw	a5,-32(s0)
    80202c42:	a819                	j	80202c58 <handle_page_fault+0x1dc>
    else if (type == 3) perm = PTE_R | PTE_W | PTE_U;
    80202c44:	fb442783          	lw	a5,-76(s0)
    80202c48:	0007871b          	sext.w	a4,a5
    80202c4c:	478d                	li	a5,3
    80202c4e:	00f71563          	bne	a4,a5,80202c58 <handle_page_fault+0x1dc>
    80202c52:	47d9                	li	a5,22
    80202c54:	fef42023          	sw	a5,-32(s0)
    if (map_page(pt, page_va, (uint64)page, perm) != 0) {
    80202c58:	fc043783          	ld	a5,-64(s0)
    80202c5c:	fe042703          	lw	a4,-32(s0)
    80202c60:	86ba                	mv	a3,a4
    80202c62:	863e                	mv	a2,a5
    80202c64:	fd843583          	ld	a1,-40(s0)
    80202c68:	fe843503          	ld	a0,-24(s0)
    80202c6c:	fffff097          	auipc	ra,0xfffff
    80202c70:	778080e7          	jalr	1912(ra) # 802023e4 <map_page>
    80202c74:	87aa                	mv	a5,a0
    80202c76:	c38d                	beqz	a5,80202c98 <handle_page_fault+0x21c>
        free_page(page);
    80202c78:	fc043503          	ld	a0,-64(s0)
    80202c7c:	00000097          	auipc	ra,0x0
    80202c80:	720080e7          	jalr	1824(ra) # 8020339c <free_page>
        printf("[PAGE FAULT] 页面映射失败\n");
    80202c84:	00015517          	auipc	a0,0x15
    80202c88:	9e450513          	addi	a0,a0,-1564 # 80217668 <user_test_table+0x4d0>
    80202c8c:	ffffe097          	auipc	ra,0xffffe
    80202c90:	102080e7          	jalr	258(ra) # 80200d8e <printf>
        return 0;
    80202c94:	4781                	li	a5,0
    80202c96:	a01d                	j	80202cbc <handle_page_fault+0x240>
    sfence_vma();
    80202c98:	00000097          	auipc	ra,0x0
    80202c9c:	c2a080e7          	jalr	-982(ra) # 802028c2 <sfence_vma>
    printf("[PAGE FAULT] 成功分配并映射页面 0x%lx -> 0x%lx\n", page_va, (uint64)page);
    80202ca0:	fc043783          	ld	a5,-64(s0)
    80202ca4:	863e                	mv	a2,a5
    80202ca6:	fd843583          	ld	a1,-40(s0)
    80202caa:	00015517          	auipc	a0,0x15
    80202cae:	9e650513          	addi	a0,a0,-1562 # 80217690 <user_test_table+0x4f8>
    80202cb2:	ffffe097          	auipc	ra,0xffffe
    80202cb6:	0dc080e7          	jalr	220(ra) # 80200d8e <printf>
    return 1;
    80202cba:	4785                	li	a5,1
}
    80202cbc:	853e                	mv	a0,a5
    80202cbe:	60a6                	ld	ra,72(sp)
    80202cc0:	6406                	ld	s0,64(sp)
    80202cc2:	6161                	addi	sp,sp,80
    80202cc4:	8082                	ret

0000000080202cc6 <test_pagetable>:
void test_pagetable(void) {
    80202cc6:	7155                	addi	sp,sp,-208
    80202cc8:	e586                	sd	ra,200(sp)
    80202cca:	e1a2                	sd	s0,192(sp)
    80202ccc:	fd26                	sd	s1,184(sp)
    80202cce:	f94a                	sd	s2,176(sp)
    80202cd0:	f54e                	sd	s3,168(sp)
    80202cd2:	f152                	sd	s4,160(sp)
    80202cd4:	ed56                	sd	s5,152(sp)
    80202cd6:	e95a                	sd	s6,144(sp)
    80202cd8:	e55e                	sd	s7,136(sp)
    80202cda:	e162                	sd	s8,128(sp)
    80202cdc:	fce6                	sd	s9,120(sp)
    80202cde:	0980                	addi	s0,sp,208
    80202ce0:	878a                	mv	a5,sp
    80202ce2:	84be                	mv	s1,a5
    printf("[PT TEST] 创建页表...\n");
    80202ce4:	00015517          	auipc	a0,0x15
    80202ce8:	9ec50513          	addi	a0,a0,-1556 # 802176d0 <user_test_table+0x538>
    80202cec:	ffffe097          	auipc	ra,0xffffe
    80202cf0:	0a2080e7          	jalr	162(ra) # 80200d8e <printf>
    pagetable_t pt = create_pagetable();
    80202cf4:	fffff097          	auipc	ra,0xfffff
    80202cf8:	480080e7          	jalr	1152(ra) # 80202174 <create_pagetable>
    80202cfc:	f8a43423          	sd	a0,-120(s0)
    assert(pt != 0);
    80202d00:	f8843783          	ld	a5,-120(s0)
    80202d04:	00f037b3          	snez	a5,a5
    80202d08:	0ff7f793          	zext.b	a5,a5
    80202d0c:	2781                	sext.w	a5,a5
    80202d0e:	853e                	mv	a0,a5
    80202d10:	fffff097          	auipc	ra,0xfffff
    80202d14:	37a080e7          	jalr	890(ra) # 8020208a <assert>
    printf("[PT TEST] 页表创建通过\n");
    80202d18:	00015517          	auipc	a0,0x15
    80202d1c:	9d850513          	addi	a0,a0,-1576 # 802176f0 <user_test_table+0x558>
    80202d20:	ffffe097          	auipc	ra,0xffffe
    80202d24:	06e080e7          	jalr	110(ra) # 80200d8e <printf>
    uint64 va[] = {
    80202d28:	00015797          	auipc	a5,0x15
    80202d2c:	b8878793          	addi	a5,a5,-1144 # 802178b0 <user_test_table+0x718>
    80202d30:	638c                	ld	a1,0(a5)
    80202d32:	6790                	ld	a2,8(a5)
    80202d34:	6b94                	ld	a3,16(a5)
    80202d36:	6f98                	ld	a4,24(a5)
    80202d38:	739c                	ld	a5,32(a5)
    80202d3a:	f2b43c23          	sd	a1,-200(s0)
    80202d3e:	f4c43023          	sd	a2,-192(s0)
    80202d42:	f4d43423          	sd	a3,-184(s0)
    80202d46:	f4e43823          	sd	a4,-176(s0)
    80202d4a:	f4f43c23          	sd	a5,-168(s0)
    int n = sizeof(va) / sizeof(va[0]);
    80202d4e:	4795                	li	a5,5
    80202d50:	f8f42223          	sw	a5,-124(s0)
    uint64 pa[n];
    80202d54:	f8442783          	lw	a5,-124(s0)
    80202d58:	873e                	mv	a4,a5
    80202d5a:	177d                	addi	a4,a4,-1
    80202d5c:	f6e43c23          	sd	a4,-136(s0)
    80202d60:	873e                	mv	a4,a5
    80202d62:	8c3a                	mv	s8,a4
    80202d64:	4c81                	li	s9,0
    80202d66:	03ac5713          	srli	a4,s8,0x3a
    80202d6a:	006c9a93          	slli	s5,s9,0x6
    80202d6e:	01576ab3          	or	s5,a4,s5
    80202d72:	006c1a13          	slli	s4,s8,0x6
    80202d76:	873e                	mv	a4,a5
    80202d78:	8b3a                	mv	s6,a4
    80202d7a:	4b81                	li	s7,0
    80202d7c:	03ab5713          	srli	a4,s6,0x3a
    80202d80:	006b9993          	slli	s3,s7,0x6
    80202d84:	013769b3          	or	s3,a4,s3
    80202d88:	006b1913          	slli	s2,s6,0x6
    80202d8c:	078e                	slli	a5,a5,0x3
    80202d8e:	07bd                	addi	a5,a5,15
    80202d90:	8391                	srli	a5,a5,0x4
    80202d92:	0792                	slli	a5,a5,0x4
    80202d94:	40f10133          	sub	sp,sp,a5
    80202d98:	878a                	mv	a5,sp
    80202d9a:	079d                	addi	a5,a5,7
    80202d9c:	838d                	srli	a5,a5,0x3
    80202d9e:	078e                	slli	a5,a5,0x3
    80202da0:	f6f43823          	sd	a5,-144(s0)
    for (int i = 0; i < n; i++) {
    80202da4:	f8042e23          	sw	zero,-100(s0)
    80202da8:	a201                	j	80202ea8 <test_pagetable+0x1e2>
        pa[i] = (uint64)alloc_page();
    80202daa:	00000097          	auipc	ra,0x0
    80202dae:	586080e7          	jalr	1414(ra) # 80203330 <alloc_page>
    80202db2:	87aa                	mv	a5,a0
    80202db4:	86be                	mv	a3,a5
    80202db6:	f7043703          	ld	a4,-144(s0)
    80202dba:	f9c42783          	lw	a5,-100(s0)
    80202dbe:	078e                	slli	a5,a5,0x3
    80202dc0:	97ba                	add	a5,a5,a4
    80202dc2:	e394                	sd	a3,0(a5)
        assert(pa[i]);
    80202dc4:	f7043703          	ld	a4,-144(s0)
    80202dc8:	f9c42783          	lw	a5,-100(s0)
    80202dcc:	078e                	slli	a5,a5,0x3
    80202dce:	97ba                	add	a5,a5,a4
    80202dd0:	639c                	ld	a5,0(a5)
    80202dd2:	2781                	sext.w	a5,a5
    80202dd4:	853e                	mv	a0,a5
    80202dd6:	fffff097          	auipc	ra,0xfffff
    80202dda:	2b4080e7          	jalr	692(ra) # 8020208a <assert>
        printf("[PT TEST] 分配物理页 pa[%d]=0x%lx\n", i, pa[i]);
    80202dde:	f7043703          	ld	a4,-144(s0)
    80202de2:	f9c42783          	lw	a5,-100(s0)
    80202de6:	078e                	slli	a5,a5,0x3
    80202de8:	97ba                	add	a5,a5,a4
    80202dea:	6398                	ld	a4,0(a5)
    80202dec:	f9c42783          	lw	a5,-100(s0)
    80202df0:	863a                	mv	a2,a4
    80202df2:	85be                	mv	a1,a5
    80202df4:	00015517          	auipc	a0,0x15
    80202df8:	91c50513          	addi	a0,a0,-1764 # 80217710 <user_test_table+0x578>
    80202dfc:	ffffe097          	auipc	ra,0xffffe
    80202e00:	f92080e7          	jalr	-110(ra) # 80200d8e <printf>
        int ret = map_page(pt, va[i], pa[i], PTE_R | PTE_W);
    80202e04:	f9c42783          	lw	a5,-100(s0)
    80202e08:	078e                	slli	a5,a5,0x3
    80202e0a:	fa078793          	addi	a5,a5,-96
    80202e0e:	97a2                	add	a5,a5,s0
    80202e10:	f987b583          	ld	a1,-104(a5)
    80202e14:	f7043703          	ld	a4,-144(s0)
    80202e18:	f9c42783          	lw	a5,-100(s0)
    80202e1c:	078e                	slli	a5,a5,0x3
    80202e1e:	97ba                	add	a5,a5,a4
    80202e20:	639c                	ld	a5,0(a5)
    80202e22:	4699                	li	a3,6
    80202e24:	863e                	mv	a2,a5
    80202e26:	f8843503          	ld	a0,-120(s0)
    80202e2a:	fffff097          	auipc	ra,0xfffff
    80202e2e:	5ba080e7          	jalr	1466(ra) # 802023e4 <map_page>
    80202e32:	87aa                	mv	a5,a0
    80202e34:	f6f42223          	sw	a5,-156(s0)
        printf("[PT TEST] 映射 va=0x%lx -> pa=0x%lx %s\n", va[i], pa[i], ret == 0 ? "成功" : "失败");
    80202e38:	f9c42783          	lw	a5,-100(s0)
    80202e3c:	078e                	slli	a5,a5,0x3
    80202e3e:	fa078793          	addi	a5,a5,-96
    80202e42:	97a2                	add	a5,a5,s0
    80202e44:	f987b583          	ld	a1,-104(a5)
    80202e48:	f7043703          	ld	a4,-144(s0)
    80202e4c:	f9c42783          	lw	a5,-100(s0)
    80202e50:	078e                	slli	a5,a5,0x3
    80202e52:	97ba                	add	a5,a5,a4
    80202e54:	6398                	ld	a4,0(a5)
    80202e56:	f6442783          	lw	a5,-156(s0)
    80202e5a:	2781                	sext.w	a5,a5
    80202e5c:	e791                	bnez	a5,80202e68 <test_pagetable+0x1a2>
    80202e5e:	00015797          	auipc	a5,0x15
    80202e62:	8da78793          	addi	a5,a5,-1830 # 80217738 <user_test_table+0x5a0>
    80202e66:	a029                	j	80202e70 <test_pagetable+0x1aa>
    80202e68:	00015797          	auipc	a5,0x15
    80202e6c:	8d878793          	addi	a5,a5,-1832 # 80217740 <user_test_table+0x5a8>
    80202e70:	86be                	mv	a3,a5
    80202e72:	863a                	mv	a2,a4
    80202e74:	00015517          	auipc	a0,0x15
    80202e78:	8d450513          	addi	a0,a0,-1836 # 80217748 <user_test_table+0x5b0>
    80202e7c:	ffffe097          	auipc	ra,0xffffe
    80202e80:	f12080e7          	jalr	-238(ra) # 80200d8e <printf>
        assert(ret == 0);
    80202e84:	f6442783          	lw	a5,-156(s0)
    80202e88:	2781                	sext.w	a5,a5
    80202e8a:	0017b793          	seqz	a5,a5
    80202e8e:	0ff7f793          	zext.b	a5,a5
    80202e92:	2781                	sext.w	a5,a5
    80202e94:	853e                	mv	a0,a5
    80202e96:	fffff097          	auipc	ra,0xfffff
    80202e9a:	1f4080e7          	jalr	500(ra) # 8020208a <assert>
    for (int i = 0; i < n; i++) {
    80202e9e:	f9c42783          	lw	a5,-100(s0)
    80202ea2:	2785                	addiw	a5,a5,1
    80202ea4:	f8f42e23          	sw	a5,-100(s0)
    80202ea8:	f9c42783          	lw	a5,-100(s0)
    80202eac:	873e                	mv	a4,a5
    80202eae:	f8442783          	lw	a5,-124(s0)
    80202eb2:	2701                	sext.w	a4,a4
    80202eb4:	2781                	sext.w	a5,a5
    80202eb6:	eef74ae3          	blt	a4,a5,80202daa <test_pagetable+0xe4>
    printf("[PT TEST] 多级映射测试通过\n");
    80202eba:	00015517          	auipc	a0,0x15
    80202ebe:	8be50513          	addi	a0,a0,-1858 # 80217778 <user_test_table+0x5e0>
    80202ec2:	ffffe097          	auipc	ra,0xffffe
    80202ec6:	ecc080e7          	jalr	-308(ra) # 80200d8e <printf>
    for (int i = 0; i < n; i++) {
    80202eca:	f8042c23          	sw	zero,-104(s0)
    80202ece:	a861                	j	80202f66 <test_pagetable+0x2a0>
        pte_t *pte = walk_lookup(pt, va[i]);
    80202ed0:	f9842783          	lw	a5,-104(s0)
    80202ed4:	078e                	slli	a5,a5,0x3
    80202ed6:	fa078793          	addi	a5,a5,-96
    80202eda:	97a2                	add	a5,a5,s0
    80202edc:	f987b783          	ld	a5,-104(a5)
    80202ee0:	85be                	mv	a1,a5
    80202ee2:	f8843503          	ld	a0,-120(s0)
    80202ee6:	fffff097          	auipc	ra,0xfffff
    80202eea:	2ca080e7          	jalr	714(ra) # 802021b0 <walk_lookup>
    80202eee:	f6a43423          	sd	a0,-152(s0)
        if (pte && (*pte & PTE_V)) {
    80202ef2:	f6843783          	ld	a5,-152(s0)
    80202ef6:	c3b1                	beqz	a5,80202f3a <test_pagetable+0x274>
    80202ef8:	f6843783          	ld	a5,-152(s0)
    80202efc:	639c                	ld	a5,0(a5)
    80202efe:	8b85                	andi	a5,a5,1
    80202f00:	cf8d                	beqz	a5,80202f3a <test_pagetable+0x274>
            printf("[PT TEST] 检查映射: va=0x%lx -> pa=0x%lx, pte=0x%lx\n", va[i], PTE2PA(*pte), *pte);
    80202f02:	f9842783          	lw	a5,-104(s0)
    80202f06:	078e                	slli	a5,a5,0x3
    80202f08:	fa078793          	addi	a5,a5,-96
    80202f0c:	97a2                	add	a5,a5,s0
    80202f0e:	f987b703          	ld	a4,-104(a5)
    80202f12:	f6843783          	ld	a5,-152(s0)
    80202f16:	639c                	ld	a5,0(a5)
    80202f18:	83a9                	srli	a5,a5,0xa
    80202f1a:	00c79613          	slli	a2,a5,0xc
    80202f1e:	f6843783          	ld	a5,-152(s0)
    80202f22:	639c                	ld	a5,0(a5)
    80202f24:	86be                	mv	a3,a5
    80202f26:	85ba                	mv	a1,a4
    80202f28:	00015517          	auipc	a0,0x15
    80202f2c:	87850513          	addi	a0,a0,-1928 # 802177a0 <user_test_table+0x608>
    80202f30:	ffffe097          	auipc	ra,0xffffe
    80202f34:	e5e080e7          	jalr	-418(ra) # 80200d8e <printf>
    80202f38:	a015                	j	80202f5c <test_pagetable+0x296>
            printf("[PT TEST] 检查映射: va=0x%lx 未映射\n", va[i]);
    80202f3a:	f9842783          	lw	a5,-104(s0)
    80202f3e:	078e                	slli	a5,a5,0x3
    80202f40:	fa078793          	addi	a5,a5,-96
    80202f44:	97a2                	add	a5,a5,s0
    80202f46:	f987b783          	ld	a5,-104(a5)
    80202f4a:	85be                	mv	a1,a5
    80202f4c:	00015517          	auipc	a0,0x15
    80202f50:	89450513          	addi	a0,a0,-1900 # 802177e0 <user_test_table+0x648>
    80202f54:	ffffe097          	auipc	ra,0xffffe
    80202f58:	e3a080e7          	jalr	-454(ra) # 80200d8e <printf>
    for (int i = 0; i < n; i++) {
    80202f5c:	f9842783          	lw	a5,-104(s0)
    80202f60:	2785                	addiw	a5,a5,1
    80202f62:	f8f42c23          	sw	a5,-104(s0)
    80202f66:	f9842783          	lw	a5,-104(s0)
    80202f6a:	873e                	mv	a4,a5
    80202f6c:	f8442783          	lw	a5,-124(s0)
    80202f70:	2701                	sext.w	a4,a4
    80202f72:	2781                	sext.w	a5,a5
    80202f74:	f4f74ee3          	blt	a4,a5,80202ed0 <test_pagetable+0x20a>
    printf("[PT TEST] 打印页表结构（递归）\n");
    80202f78:	00015517          	auipc	a0,0x15
    80202f7c:	89850513          	addi	a0,a0,-1896 # 80217810 <user_test_table+0x678>
    80202f80:	ffffe097          	auipc	ra,0xffffe
    80202f84:	e0e080e7          	jalr	-498(ra) # 80200d8e <printf>
    print_pagetable(pt, 0, 0);
    80202f88:	4601                	li	a2,0
    80202f8a:	4581                	li	a1,0
    80202f8c:	f8843503          	ld	a0,-120(s0)
    80202f90:	00000097          	auipc	ra,0x0
    80202f94:	9d6080e7          	jalr	-1578(ra) # 80202966 <print_pagetable>
    for (int i = 0; i < n; i++) {
    80202f98:	f8042a23          	sw	zero,-108(s0)
    80202f9c:	a0a9                	j	80202fe6 <test_pagetable+0x320>
        free_page((void*)pa[i]);
    80202f9e:	f7043703          	ld	a4,-144(s0)
    80202fa2:	f9442783          	lw	a5,-108(s0)
    80202fa6:	078e                	slli	a5,a5,0x3
    80202fa8:	97ba                	add	a5,a5,a4
    80202faa:	639c                	ld	a5,0(a5)
    80202fac:	853e                	mv	a0,a5
    80202fae:	00000097          	auipc	ra,0x0
    80202fb2:	3ee080e7          	jalr	1006(ra) # 8020339c <free_page>
        printf("[PT TEST] 释放物理页 pa[%d]=0x%lx\n", i, pa[i]);
    80202fb6:	f7043703          	ld	a4,-144(s0)
    80202fba:	f9442783          	lw	a5,-108(s0)
    80202fbe:	078e                	slli	a5,a5,0x3
    80202fc0:	97ba                	add	a5,a5,a4
    80202fc2:	6398                	ld	a4,0(a5)
    80202fc4:	f9442783          	lw	a5,-108(s0)
    80202fc8:	863a                	mv	a2,a4
    80202fca:	85be                	mv	a1,a5
    80202fcc:	00015517          	auipc	a0,0x15
    80202fd0:	87450513          	addi	a0,a0,-1932 # 80217840 <user_test_table+0x6a8>
    80202fd4:	ffffe097          	auipc	ra,0xffffe
    80202fd8:	dba080e7          	jalr	-582(ra) # 80200d8e <printf>
    for (int i = 0; i < n; i++) {
    80202fdc:	f9442783          	lw	a5,-108(s0)
    80202fe0:	2785                	addiw	a5,a5,1
    80202fe2:	f8f42a23          	sw	a5,-108(s0)
    80202fe6:	f9442783          	lw	a5,-108(s0)
    80202fea:	873e                	mv	a4,a5
    80202fec:	f8442783          	lw	a5,-124(s0)
    80202ff0:	2701                	sext.w	a4,a4
    80202ff2:	2781                	sext.w	a5,a5
    80202ff4:	faf745e3          	blt	a4,a5,80202f9e <test_pagetable+0x2d8>
    free_pagetable(pt);
    80202ff8:	f8843503          	ld	a0,-120(s0)
    80202ffc:	fffff097          	auipc	ra,0xfffff
    80203000:	55c080e7          	jalr	1372(ra) # 80202558 <free_pagetable>
    printf("[PT TEST] 释放页表完成\n");
    80203004:	00015517          	auipc	a0,0x15
    80203008:	86450513          	addi	a0,a0,-1948 # 80217868 <user_test_table+0x6d0>
    8020300c:	ffffe097          	auipc	ra,0xffffe
    80203010:	d82080e7          	jalr	-638(ra) # 80200d8e <printf>
    printf("[PT TEST] 所有页表测试通过\n");
    80203014:	00015517          	auipc	a0,0x15
    80203018:	87450513          	addi	a0,a0,-1932 # 80217888 <user_test_table+0x6f0>
    8020301c:	ffffe097          	auipc	ra,0xffffe
    80203020:	d72080e7          	jalr	-654(ra) # 80200d8e <printf>
    80203024:	8126                	mv	sp,s1
}
    80203026:	0001                	nop
    80203028:	f3040113          	addi	sp,s0,-208
    8020302c:	60ae                	ld	ra,200(sp)
    8020302e:	640e                	ld	s0,192(sp)
    80203030:	74ea                	ld	s1,184(sp)
    80203032:	794a                	ld	s2,176(sp)
    80203034:	79aa                	ld	s3,168(sp)
    80203036:	7a0a                	ld	s4,160(sp)
    80203038:	6aea                	ld	s5,152(sp)
    8020303a:	6b4a                	ld	s6,144(sp)
    8020303c:	6baa                	ld	s7,136(sp)
    8020303e:	6c0a                	ld	s8,128(sp)
    80203040:	7ce6                	ld	s9,120(sp)
    80203042:	6169                	addi	sp,sp,208
    80203044:	8082                	ret

0000000080203046 <check_mapping>:
void check_mapping(uint64 va) {
    80203046:	7179                	addi	sp,sp,-48
    80203048:	f406                	sd	ra,40(sp)
    8020304a:	f022                	sd	s0,32(sp)
    8020304c:	1800                	addi	s0,sp,48
    8020304e:	fca43c23          	sd	a0,-40(s0)
    pte_t *pte = walk_lookup(kernel_pagetable, va);
    80203052:	00039797          	auipc	a5,0x39
    80203056:	04e78793          	addi	a5,a5,78 # 8023c0a0 <kernel_pagetable>
    8020305a:	639c                	ld	a5,0(a5)
    8020305c:	fd843583          	ld	a1,-40(s0)
    80203060:	853e                	mv	a0,a5
    80203062:	fffff097          	auipc	ra,0xfffff
    80203066:	14e080e7          	jalr	334(ra) # 802021b0 <walk_lookup>
    8020306a:	fea43423          	sd	a0,-24(s0)
    if(pte && (*pte & PTE_V)) {
    8020306e:	fe843783          	ld	a5,-24(s0)
    80203072:	cbb9                	beqz	a5,802030c8 <check_mapping+0x82>
    80203074:	fe843783          	ld	a5,-24(s0)
    80203078:	639c                	ld	a5,0(a5)
    8020307a:	8b85                	andi	a5,a5,1
    8020307c:	c7b1                	beqz	a5,802030c8 <check_mapping+0x82>
        printf("Address 0x%lx is mapped: pte=0x%lx\n", va, *pte);
    8020307e:	fe843783          	ld	a5,-24(s0)
    80203082:	639c                	ld	a5,0(a5)
    80203084:	863e                	mv	a2,a5
    80203086:	fd843583          	ld	a1,-40(s0)
    8020308a:	00015517          	auipc	a0,0x15
    8020308e:	84e50513          	addi	a0,a0,-1970 # 802178d8 <user_test_table+0x740>
    80203092:	ffffe097          	auipc	ra,0xffffe
    80203096:	cfc080e7          	jalr	-772(ra) # 80200d8e <printf>
		volatile unsigned char *p = (unsigned char*)va;
    8020309a:	fd843783          	ld	a5,-40(s0)
    8020309e:	fef43023          	sd	a5,-32(s0)
        printf("Try to read [0x%lx]: 0x%02x\n", va, *p);
    802030a2:	fe043783          	ld	a5,-32(s0)
    802030a6:	0007c783          	lbu	a5,0(a5)
    802030aa:	0ff7f793          	zext.b	a5,a5
    802030ae:	2781                	sext.w	a5,a5
    802030b0:	863e                	mv	a2,a5
    802030b2:	fd843583          	ld	a1,-40(s0)
    802030b6:	00015517          	auipc	a0,0x15
    802030ba:	84a50513          	addi	a0,a0,-1974 # 80217900 <user_test_table+0x768>
    802030be:	ffffe097          	auipc	ra,0xffffe
    802030c2:	cd0080e7          	jalr	-816(ra) # 80200d8e <printf>
    if(pte && (*pte & PTE_V)) {
    802030c6:	a821                	j	802030de <check_mapping+0x98>
        printf("Address 0x%lx is NOT mapped\n", va);
    802030c8:	fd843583          	ld	a1,-40(s0)
    802030cc:	00015517          	auipc	a0,0x15
    802030d0:	85450513          	addi	a0,a0,-1964 # 80217920 <user_test_table+0x788>
    802030d4:	ffffe097          	auipc	ra,0xffffe
    802030d8:	cba080e7          	jalr	-838(ra) # 80200d8e <printf>
}
    802030dc:	0001                	nop
    802030de:	0001                	nop
    802030e0:	70a2                	ld	ra,40(sp)
    802030e2:	7402                	ld	s0,32(sp)
    802030e4:	6145                	addi	sp,sp,48
    802030e6:	8082                	ret

00000000802030e8 <check_is_mapped>:
int check_is_mapped(uint64 va) {
    802030e8:	7179                	addi	sp,sp,-48
    802030ea:	f406                	sd	ra,40(sp)
    802030ec:	f022                	sd	s0,32(sp)
    802030ee:	1800                	addi	s0,sp,48
    802030f0:	fca43c23          	sd	a0,-40(s0)
    pte_t *pte = walk_lookup(get_current_pagetable(), va);
    802030f4:	00000097          	auipc	ra,0x0
    802030f8:	85a080e7          	jalr	-1958(ra) # 8020294e <get_current_pagetable>
    802030fc:	87aa                	mv	a5,a0
    802030fe:	fd843583          	ld	a1,-40(s0)
    80203102:	853e                	mv	a0,a5
    80203104:	fffff097          	auipc	ra,0xfffff
    80203108:	0ac080e7          	jalr	172(ra) # 802021b0 <walk_lookup>
    8020310c:	fea43423          	sd	a0,-24(s0)
    if (pte && (*pte & PTE_V)) {
    80203110:	fe843783          	ld	a5,-24(s0)
    80203114:	c795                	beqz	a5,80203140 <check_is_mapped+0x58>
    80203116:	fe843783          	ld	a5,-24(s0)
    8020311a:	639c                	ld	a5,0(a5)
    8020311c:	8b85                	andi	a5,a5,1
    8020311e:	c38d                	beqz	a5,80203140 <check_is_mapped+0x58>
        printf("Address 0x%lx is mapped: pte=0x%lx\n", va, *pte);
    80203120:	fe843783          	ld	a5,-24(s0)
    80203124:	639c                	ld	a5,0(a5)
    80203126:	863e                	mv	a2,a5
    80203128:	fd843583          	ld	a1,-40(s0)
    8020312c:	00014517          	auipc	a0,0x14
    80203130:	7ac50513          	addi	a0,a0,1964 # 802178d8 <user_test_table+0x740>
    80203134:	ffffe097          	auipc	ra,0xffffe
    80203138:	c5a080e7          	jalr	-934(ra) # 80200d8e <printf>
        return 1;
    8020313c:	4785                	li	a5,1
    8020313e:	a821                	j	80203156 <check_is_mapped+0x6e>
        printf("Address 0x%lx is NOT mapped\n", va);
    80203140:	fd843583          	ld	a1,-40(s0)
    80203144:	00014517          	auipc	a0,0x14
    80203148:	7dc50513          	addi	a0,a0,2012 # 80217920 <user_test_table+0x788>
    8020314c:	ffffe097          	auipc	ra,0xffffe
    80203150:	c42080e7          	jalr	-958(ra) # 80200d8e <printf>
        return 0;
    80203154:	4781                	li	a5,0
}
    80203156:	853e                	mv	a0,a5
    80203158:	70a2                	ld	ra,40(sp)
    8020315a:	7402                	ld	s0,32(sp)
    8020315c:	6145                	addi	sp,sp,48
    8020315e:	8082                	ret

0000000080203160 <uvmcopy>:
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    80203160:	711d                	addi	sp,sp,-96
    80203162:	ec86                	sd	ra,88(sp)
    80203164:	e8a2                	sd	s0,80(sp)
    80203166:	1080                	addi	s0,sp,96
    80203168:	faa43c23          	sd	a0,-72(s0)
    8020316c:	fab43823          	sd	a1,-80(s0)
    80203170:	fac43423          	sd	a2,-88(s0)
    for (uint64 i = 0; i < sz; i += PGSIZE) {
    80203174:	fe043423          	sd	zero,-24(s0)
    80203178:	a8d1                	j	8020324c <uvmcopy+0xec>
        pte_t *pte = walk_lookup(old, i);
    8020317a:	fe843583          	ld	a1,-24(s0)
    8020317e:	fb843503          	ld	a0,-72(s0)
    80203182:	fffff097          	auipc	ra,0xfffff
    80203186:	02e080e7          	jalr	46(ra) # 802021b0 <walk_lookup>
    8020318a:	fca43c23          	sd	a0,-40(s0)
        if (pte == 0 || (*pte & PTE_V) == 0)
    8020318e:	fd843783          	ld	a5,-40(s0)
    80203192:	c7d5                	beqz	a5,8020323e <uvmcopy+0xde>
    80203194:	fd843783          	ld	a5,-40(s0)
    80203198:	639c                	ld	a5,0(a5)
    8020319a:	8b85                	andi	a5,a5,1
    8020319c:	c3cd                	beqz	a5,8020323e <uvmcopy+0xde>
        uint64 pa = PTE2PA(*pte);
    8020319e:	fd843783          	ld	a5,-40(s0)
    802031a2:	639c                	ld	a5,0(a5)
    802031a4:	83a9                	srli	a5,a5,0xa
    802031a6:	07b2                	slli	a5,a5,0xc
    802031a8:	fcf43823          	sd	a5,-48(s0)
        int flags = PTE_FLAGS(*pte);
    802031ac:	fd843783          	ld	a5,-40(s0)
    802031b0:	639c                	ld	a5,0(a5)
    802031b2:	2781                	sext.w	a5,a5
    802031b4:	3ff7f793          	andi	a5,a5,1023
    802031b8:	fef42223          	sw	a5,-28(s0)
		if (i < 0x80000000)
    802031bc:	fe843703          	ld	a4,-24(s0)
    802031c0:	800007b7          	lui	a5,0x80000
    802031c4:	fff7c793          	not	a5,a5
    802031c8:	00e7e963          	bltu	a5,a4,802031da <uvmcopy+0x7a>
			flags |= PTE_U;
    802031cc:	fe442783          	lw	a5,-28(s0)
    802031d0:	0107e793          	ori	a5,a5,16
    802031d4:	fef42223          	sw	a5,-28(s0)
    802031d8:	a031                	j	802031e4 <uvmcopy+0x84>
			flags &= ~PTE_U;
    802031da:	fe442783          	lw	a5,-28(s0)
    802031de:	9bbd                	andi	a5,a5,-17
    802031e0:	fef42223          	sw	a5,-28(s0)
        void *mem = alloc_page();
    802031e4:	00000097          	auipc	ra,0x0
    802031e8:	14c080e7          	jalr	332(ra) # 80203330 <alloc_page>
    802031ec:	fca43423          	sd	a0,-56(s0)
        if (mem == 0)
    802031f0:	fc843783          	ld	a5,-56(s0)
    802031f4:	e399                	bnez	a5,802031fa <uvmcopy+0x9a>
            return -1; // 分配失败
    802031f6:	57fd                	li	a5,-1
    802031f8:	a08d                	j	8020325a <uvmcopy+0xfa>
        memmove(mem, (void*)pa, PGSIZE);
    802031fa:	fd043783          	ld	a5,-48(s0)
    802031fe:	6605                	lui	a2,0x1
    80203200:	85be                	mv	a1,a5
    80203202:	fc843503          	ld	a0,-56(s0)
    80203206:	fffff097          	auipc	ra,0xfffff
    8020320a:	d62080e7          	jalr	-670(ra) # 80201f68 <memmove>
        if (map_page(new, i, (uint64)mem, flags) != 0) {
    8020320e:	fc843783          	ld	a5,-56(s0)
    80203212:	fe442703          	lw	a4,-28(s0)
    80203216:	86ba                	mv	a3,a4
    80203218:	863e                	mv	a2,a5
    8020321a:	fe843583          	ld	a1,-24(s0)
    8020321e:	fb043503          	ld	a0,-80(s0)
    80203222:	fffff097          	auipc	ra,0xfffff
    80203226:	1c2080e7          	jalr	450(ra) # 802023e4 <map_page>
    8020322a:	87aa                	mv	a5,a0
    8020322c:	cb91                	beqz	a5,80203240 <uvmcopy+0xe0>
            free_page(mem);
    8020322e:	fc843503          	ld	a0,-56(s0)
    80203232:	00000097          	auipc	ra,0x0
    80203236:	16a080e7          	jalr	362(ra) # 8020339c <free_page>
            return -1;
    8020323a:	57fd                	li	a5,-1
    8020323c:	a839                	j	8020325a <uvmcopy+0xfa>
            continue; // 跳过未分配的页
    8020323e:	0001                	nop
    for (uint64 i = 0; i < sz; i += PGSIZE) {
    80203240:	fe843703          	ld	a4,-24(s0)
    80203244:	6785                	lui	a5,0x1
    80203246:	97ba                	add	a5,a5,a4
    80203248:	fef43423          	sd	a5,-24(s0)
    8020324c:	fe843703          	ld	a4,-24(s0)
    80203250:	fa843783          	ld	a5,-88(s0)
    80203254:	f2f763e3          	bltu	a4,a5,8020317a <uvmcopy+0x1a>
    return 0;
    80203258:	4781                	li	a5,0
    8020325a:	853e                	mv	a0,a5
    8020325c:	60e6                	ld	ra,88(sp)
    8020325e:	6446                	ld	s0,80(sp)
    80203260:	6125                	addi	sp,sp,96
    80203262:	8082                	ret

0000000080203264 <assert>:
    80203264:	1101                	addi	sp,sp,-32
    80203266:	ec06                	sd	ra,24(sp)
    80203268:	e822                	sd	s0,16(sp)
    8020326a:	1000                	addi	s0,sp,32
    8020326c:	87aa                	mv	a5,a0
    8020326e:	fef42623          	sw	a5,-20(s0)
    80203272:	fec42783          	lw	a5,-20(s0)
    80203276:	2781                	sext.w	a5,a5
    80203278:	e79d                	bnez	a5,802032a6 <assert+0x42>
    8020327a:	33800613          	li	a2,824
    8020327e:	00016597          	auipc	a1,0x16
    80203282:	77258593          	addi	a1,a1,1906 # 802199f0 <user_test_table+0x78>
    80203286:	00016517          	auipc	a0,0x16
    8020328a:	77a50513          	addi	a0,a0,1914 # 80219a00 <user_test_table+0x88>
    8020328e:	ffffe097          	auipc	ra,0xffffe
    80203292:	b00080e7          	jalr	-1280(ra) # 80200d8e <printf>
    80203296:	00016517          	auipc	a0,0x16
    8020329a:	79250513          	addi	a0,a0,1938 # 80219a28 <user_test_table+0xb0>
    8020329e:	ffffe097          	auipc	ra,0xffffe
    802032a2:	53c080e7          	jalr	1340(ra) # 802017da <panic>
    802032a6:	0001                	nop
    802032a8:	60e2                	ld	ra,24(sp)
    802032aa:	6442                	ld	s0,16(sp)
    802032ac:	6105                	addi	sp,sp,32
    802032ae:	8082                	ret

00000000802032b0 <freerange>:
static void freerange(void *pa_start, void *pa_end) {
    802032b0:	7179                	addi	sp,sp,-48
    802032b2:	f406                	sd	ra,40(sp)
    802032b4:	f022                	sd	s0,32(sp)
    802032b6:	1800                	addi	s0,sp,48
    802032b8:	fca43c23          	sd	a0,-40(s0)
    802032bc:	fcb43823          	sd	a1,-48(s0)
  char *p = (char*)PGROUNDUP((uint64)pa_start);
    802032c0:	fd843703          	ld	a4,-40(s0)
    802032c4:	6785                	lui	a5,0x1
    802032c6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    802032c8:	973e                	add	a4,a4,a5
    802032ca:	77fd                	lui	a5,0xfffff
    802032cc:	8ff9                	and	a5,a5,a4
    802032ce:	fef43423          	sd	a5,-24(s0)
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    802032d2:	a829                	j	802032ec <freerange+0x3c>
    free_page(p);
    802032d4:	fe843503          	ld	a0,-24(s0)
    802032d8:	00000097          	auipc	ra,0x0
    802032dc:	0c4080e7          	jalr	196(ra) # 8020339c <free_page>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    802032e0:	fe843703          	ld	a4,-24(s0)
    802032e4:	6785                	lui	a5,0x1
    802032e6:	97ba                	add	a5,a5,a4
    802032e8:	fef43423          	sd	a5,-24(s0)
    802032ec:	fe843703          	ld	a4,-24(s0)
    802032f0:	6785                	lui	a5,0x1
    802032f2:	97ba                	add	a5,a5,a4
    802032f4:	fd043703          	ld	a4,-48(s0)
    802032f8:	fcf77ee3          	bgeu	a4,a5,802032d4 <freerange+0x24>
}
    802032fc:	0001                	nop
    802032fe:	0001                	nop
    80203300:	70a2                	ld	ra,40(sp)
    80203302:	7402                	ld	s0,32(sp)
    80203304:	6145                	addi	sp,sp,48
    80203306:	8082                	ret

0000000080203308 <pmm_init>:
void pmm_init(void) {
    80203308:	1141                	addi	sp,sp,-16
    8020330a:	e406                	sd	ra,8(sp)
    8020330c:	e022                	sd	s0,0(sp)
    8020330e:	0800                	addi	s0,sp,16
  freerange(end, (void*)PHYSTOP);
    80203310:	47c5                	li	a5,17
    80203312:	01b79593          	slli	a1,a5,0x1b
    80203316:	00044517          	auipc	a0,0x44
    8020331a:	60a50513          	addi	a0,a0,1546 # 80247920 <_bss_end>
    8020331e:	00000097          	auipc	ra,0x0
    80203322:	f92080e7          	jalr	-110(ra) # 802032b0 <freerange>
}
    80203326:	0001                	nop
    80203328:	60a2                	ld	ra,8(sp)
    8020332a:	6402                	ld	s0,0(sp)
    8020332c:	0141                	addi	sp,sp,16
    8020332e:	8082                	ret

0000000080203330 <alloc_page>:
void* alloc_page(void) {
    80203330:	1101                	addi	sp,sp,-32
    80203332:	ec06                	sd	ra,24(sp)
    80203334:	e822                	sd	s0,16(sp)
    80203336:	1000                	addi	s0,sp,32
  struct run *r = freelist;
    80203338:	00039797          	auipc	a5,0x39
    8020333c:	f3878793          	addi	a5,a5,-200 # 8023c270 <freelist>
    80203340:	639c                	ld	a5,0(a5)
    80203342:	fef43423          	sd	a5,-24(s0)
  if(r)
    80203346:	fe843783          	ld	a5,-24(s0)
    8020334a:	cb89                	beqz	a5,8020335c <alloc_page+0x2c>
    freelist = r->next;
    8020334c:	fe843783          	ld	a5,-24(s0)
    80203350:	6398                	ld	a4,0(a5)
    80203352:	00039797          	auipc	a5,0x39
    80203356:	f1e78793          	addi	a5,a5,-226 # 8023c270 <freelist>
    8020335a:	e398                	sd	a4,0(a5)
  if(r)
    8020335c:	fe843783          	ld	a5,-24(s0)
    80203360:	cf99                	beqz	a5,8020337e <alloc_page+0x4e>
    memset((char*)r + sizeof(struct run), 5, PGSIZE - sizeof(struct run));
    80203362:	fe843783          	ld	a5,-24(s0)
    80203366:	00878713          	addi	a4,a5,8
    8020336a:	6785                	lui	a5,0x1
    8020336c:	ff878613          	addi	a2,a5,-8 # ff8 <_entry-0x801ff008>
    80203370:	4595                	li	a1,5
    80203372:	853a                	mv	a0,a4
    80203374:	fffff097          	auipc	ra,0xfffff
    80203378:	ba4080e7          	jalr	-1116(ra) # 80201f18 <memset>
    8020337c:	a809                	j	8020338e <alloc_page+0x5e>
    panic("alloc_page: out of memory");
    8020337e:	00016517          	auipc	a0,0x16
    80203382:	6b250513          	addi	a0,a0,1714 # 80219a30 <user_test_table+0xb8>
    80203386:	ffffe097          	auipc	ra,0xffffe
    8020338a:	454080e7          	jalr	1108(ra) # 802017da <panic>
  return (void*)r;
    8020338e:	fe843783          	ld	a5,-24(s0)
}
    80203392:	853e                	mv	a0,a5
    80203394:	60e2                	ld	ra,24(sp)
    80203396:	6442                	ld	s0,16(sp)
    80203398:	6105                	addi	sp,sp,32
    8020339a:	8082                	ret

000000008020339c <free_page>:
void free_page(void* page) {
    8020339c:	7179                	addi	sp,sp,-48
    8020339e:	f406                	sd	ra,40(sp)
    802033a0:	f022                	sd	s0,32(sp)
    802033a2:	1800                	addi	s0,sp,48
    802033a4:	fca43c23          	sd	a0,-40(s0)
  struct run *r = (struct run*)page;
    802033a8:	fd843783          	ld	a5,-40(s0)
    802033ac:	fef43423          	sd	a5,-24(s0)
  if(((uint64)page % PGSIZE) != 0 || (char*)page < end || (uint64)page >= PHYSTOP)
    802033b0:	fd843703          	ld	a4,-40(s0)
    802033b4:	6785                	lui	a5,0x1
    802033b6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    802033b8:	8ff9                	and	a5,a5,a4
    802033ba:	ef99                	bnez	a5,802033d8 <free_page+0x3c>
    802033bc:	fd843703          	ld	a4,-40(s0)
    802033c0:	00044797          	auipc	a5,0x44
    802033c4:	56078793          	addi	a5,a5,1376 # 80247920 <_bss_end>
    802033c8:	00f76863          	bltu	a4,a5,802033d8 <free_page+0x3c>
    802033cc:	fd843703          	ld	a4,-40(s0)
    802033d0:	47c5                	li	a5,17
    802033d2:	07ee                	slli	a5,a5,0x1b
    802033d4:	00f76a63          	bltu	a4,a5,802033e8 <free_page+0x4c>
    panic("free_page: invalid page address");
    802033d8:	00016517          	auipc	a0,0x16
    802033dc:	67850513          	addi	a0,a0,1656 # 80219a50 <user_test_table+0xd8>
    802033e0:	ffffe097          	auipc	ra,0xffffe
    802033e4:	3fa080e7          	jalr	1018(ra) # 802017da <panic>
  r->next = freelist;
    802033e8:	00039797          	auipc	a5,0x39
    802033ec:	e8878793          	addi	a5,a5,-376 # 8023c270 <freelist>
    802033f0:	6398                	ld	a4,0(a5)
    802033f2:	fe843783          	ld	a5,-24(s0)
    802033f6:	e398                	sd	a4,0(a5)
  freelist = r;
    802033f8:	00039797          	auipc	a5,0x39
    802033fc:	e7878793          	addi	a5,a5,-392 # 8023c270 <freelist>
    80203400:	fe843703          	ld	a4,-24(s0)
    80203404:	e398                	sd	a4,0(a5)
}
    80203406:	0001                	nop
    80203408:	70a2                	ld	ra,40(sp)
    8020340a:	7402                	ld	s0,32(sp)
    8020340c:	6145                	addi	sp,sp,48
    8020340e:	8082                	ret

0000000080203410 <test_physical_memory>:
void test_physical_memory(void) {
    80203410:	7179                	addi	sp,sp,-48
    80203412:	f406                	sd	ra,40(sp)
    80203414:	f022                	sd	s0,32(sp)
    80203416:	1800                	addi	s0,sp,48
    printf("[PM TEST] 分配两个页...\n");
    80203418:	00016517          	auipc	a0,0x16
    8020341c:	65850513          	addi	a0,a0,1624 # 80219a70 <user_test_table+0xf8>
    80203420:	ffffe097          	auipc	ra,0xffffe
    80203424:	96e080e7          	jalr	-1682(ra) # 80200d8e <printf>
    void *page1 = alloc_page();
    80203428:	00000097          	auipc	ra,0x0
    8020342c:	f08080e7          	jalr	-248(ra) # 80203330 <alloc_page>
    80203430:	fea43423          	sd	a0,-24(s0)
    void *page2 = alloc_page();
    80203434:	00000097          	auipc	ra,0x0
    80203438:	efc080e7          	jalr	-260(ra) # 80203330 <alloc_page>
    8020343c:	fea43023          	sd	a0,-32(s0)
    assert(page1 != 0);
    80203440:	fe843783          	ld	a5,-24(s0)
    80203444:	00f037b3          	snez	a5,a5
    80203448:	0ff7f793          	zext.b	a5,a5
    8020344c:	2781                	sext.w	a5,a5
    8020344e:	853e                	mv	a0,a5
    80203450:	00000097          	auipc	ra,0x0
    80203454:	e14080e7          	jalr	-492(ra) # 80203264 <assert>
    assert(page2 != 0);
    80203458:	fe043783          	ld	a5,-32(s0)
    8020345c:	00f037b3          	snez	a5,a5
    80203460:	0ff7f793          	zext.b	a5,a5
    80203464:	2781                	sext.w	a5,a5
    80203466:	853e                	mv	a0,a5
    80203468:	00000097          	auipc	ra,0x0
    8020346c:	dfc080e7          	jalr	-516(ra) # 80203264 <assert>
    assert(page1 != page2);
    80203470:	fe843703          	ld	a4,-24(s0)
    80203474:	fe043783          	ld	a5,-32(s0)
    80203478:	40f707b3          	sub	a5,a4,a5
    8020347c:	00f037b3          	snez	a5,a5
    80203480:	0ff7f793          	zext.b	a5,a5
    80203484:	2781                	sext.w	a5,a5
    80203486:	853e                	mv	a0,a5
    80203488:	00000097          	auipc	ra,0x0
    8020348c:	ddc080e7          	jalr	-548(ra) # 80203264 <assert>
    assert(((uint64)page1 & 0xFFF) == 0);
    80203490:	fe843703          	ld	a4,-24(s0)
    80203494:	6785                	lui	a5,0x1
    80203496:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80203498:	8ff9                	and	a5,a5,a4
    8020349a:	0017b793          	seqz	a5,a5
    8020349e:	0ff7f793          	zext.b	a5,a5
    802034a2:	2781                	sext.w	a5,a5
    802034a4:	853e                	mv	a0,a5
    802034a6:	00000097          	auipc	ra,0x0
    802034aa:	dbe080e7          	jalr	-578(ra) # 80203264 <assert>
    assert(((uint64)page2 & 0xFFF) == 0);
    802034ae:	fe043703          	ld	a4,-32(s0)
    802034b2:	6785                	lui	a5,0x1
    802034b4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    802034b6:	8ff9                	and	a5,a5,a4
    802034b8:	0017b793          	seqz	a5,a5
    802034bc:	0ff7f793          	zext.b	a5,a5
    802034c0:	2781                	sext.w	a5,a5
    802034c2:	853e                	mv	a0,a5
    802034c4:	00000097          	auipc	ra,0x0
    802034c8:	da0080e7          	jalr	-608(ra) # 80203264 <assert>
    printf("[PM TEST] 分配测试通过\n");
    802034cc:	00016517          	auipc	a0,0x16
    802034d0:	5c450513          	addi	a0,a0,1476 # 80219a90 <user_test_table+0x118>
    802034d4:	ffffe097          	auipc	ra,0xffffe
    802034d8:	8ba080e7          	jalr	-1862(ra) # 80200d8e <printf>
    printf("[PM TEST] 数据写入测试...\n");
    802034dc:	00016517          	auipc	a0,0x16
    802034e0:	5d450513          	addi	a0,a0,1492 # 80219ab0 <user_test_table+0x138>
    802034e4:	ffffe097          	auipc	ra,0xffffe
    802034e8:	8aa080e7          	jalr	-1878(ra) # 80200d8e <printf>
    *(int*)page1 = 0x12345678;
    802034ec:	fe843783          	ld	a5,-24(s0)
    802034f0:	12345737          	lui	a4,0x12345
    802034f4:	67870713          	addi	a4,a4,1656 # 12345678 <_entry-0x6deba988>
    802034f8:	c398                	sw	a4,0(a5)
    assert(*(int*)page1 == 0x12345678);
    802034fa:	fe843783          	ld	a5,-24(s0)
    802034fe:	439c                	lw	a5,0(a5)
    80203500:	873e                	mv	a4,a5
    80203502:	123457b7          	lui	a5,0x12345
    80203506:	67878793          	addi	a5,a5,1656 # 12345678 <_entry-0x6deba988>
    8020350a:	40f707b3          	sub	a5,a4,a5
    8020350e:	0017b793          	seqz	a5,a5
    80203512:	0ff7f793          	zext.b	a5,a5
    80203516:	2781                	sext.w	a5,a5
    80203518:	853e                	mv	a0,a5
    8020351a:	00000097          	auipc	ra,0x0
    8020351e:	d4a080e7          	jalr	-694(ra) # 80203264 <assert>
    printf("[PM TEST] 数据写入测试通过\n");
    80203522:	00016517          	auipc	a0,0x16
    80203526:	5b650513          	addi	a0,a0,1462 # 80219ad8 <user_test_table+0x160>
    8020352a:	ffffe097          	auipc	ra,0xffffe
    8020352e:	864080e7          	jalr	-1948(ra) # 80200d8e <printf>
    printf("[PM TEST] 释放与重新分配测试...\n");
    80203532:	00016517          	auipc	a0,0x16
    80203536:	5ce50513          	addi	a0,a0,1486 # 80219b00 <user_test_table+0x188>
    8020353a:	ffffe097          	auipc	ra,0xffffe
    8020353e:	854080e7          	jalr	-1964(ra) # 80200d8e <printf>
    free_page(page1);
    80203542:	fe843503          	ld	a0,-24(s0)
    80203546:	00000097          	auipc	ra,0x0
    8020354a:	e56080e7          	jalr	-426(ra) # 8020339c <free_page>
    void *page3 = alloc_page();
    8020354e:	00000097          	auipc	ra,0x0
    80203552:	de2080e7          	jalr	-542(ra) # 80203330 <alloc_page>
    80203556:	fca43c23          	sd	a0,-40(s0)
    assert(page3 != 0);
    8020355a:	fd843783          	ld	a5,-40(s0)
    8020355e:	00f037b3          	snez	a5,a5
    80203562:	0ff7f793          	zext.b	a5,a5
    80203566:	2781                	sext.w	a5,a5
    80203568:	853e                	mv	a0,a5
    8020356a:	00000097          	auipc	ra,0x0
    8020356e:	cfa080e7          	jalr	-774(ra) # 80203264 <assert>
    printf("[PM TEST] 释放与重新分配测试通过\n");
    80203572:	00016517          	auipc	a0,0x16
    80203576:	5be50513          	addi	a0,a0,1470 # 80219b30 <user_test_table+0x1b8>
    8020357a:	ffffe097          	auipc	ra,0xffffe
    8020357e:	814080e7          	jalr	-2028(ra) # 80200d8e <printf>
    free_page(page2);
    80203582:	fe043503          	ld	a0,-32(s0)
    80203586:	00000097          	auipc	ra,0x0
    8020358a:	e16080e7          	jalr	-490(ra) # 8020339c <free_page>
    free_page(page3);
    8020358e:	fd843503          	ld	a0,-40(s0)
    80203592:	00000097          	auipc	ra,0x0
    80203596:	e0a080e7          	jalr	-502(ra) # 8020339c <free_page>
    printf("[PM TEST] 所有物理内存管理测试通过\n");
    8020359a:	00016517          	auipc	a0,0x16
    8020359e:	5c650513          	addi	a0,a0,1478 # 80219b60 <user_test_table+0x1e8>
    802035a2:	ffffd097          	auipc	ra,0xffffd
    802035a6:	7ec080e7          	jalr	2028(ra) # 80200d8e <printf>
    802035aa:	0001                	nop
    802035ac:	70a2                	ld	ra,40(sp)
    802035ae:	7402                	ld	s0,32(sp)
    802035b0:	6145                	addi	sp,sp,48
    802035b2:	8082                	ret

00000000802035b4 <sbi_set_time>:
#include "defs.h"

void sbi_set_time(uint64 time) {
    802035b4:	1101                	addi	sp,sp,-32
    802035b6:	ec22                	sd	s0,24(sp)
    802035b8:	1000                	addi	s0,sp,32
    802035ba:	fea43423          	sd	a0,-24(s0)
    register uint64 a0 asm("a0") = time;
    802035be:	fe843503          	ld	a0,-24(s0)
    register uint64 a7 asm("a7") = SBI_SET_TIME;
    802035c2:	4881                	li	a7,0
    asm volatile ("ecall"
    802035c4:	00000073          	ecall
                  : "+r"(a0)
                  : "r"(a7)
                  : "memory");
}
    802035c8:	0001                	nop
    802035ca:	6462                	ld	s0,24(sp)
    802035cc:	6105                	addi	sp,sp,32
    802035ce:	8082                	ret

00000000802035d0 <sbi_get_time>:
// 直接读取 time CSR 寄存器获取当前时间
uint64 sbi_get_time(void) {
    802035d0:	1101                	addi	sp,sp,-32
    802035d2:	ec22                	sd	s0,24(sp)
    802035d4:	1000                	addi	s0,sp,32
    uint64 time_value;
    
    asm volatile ("rdtime %0" : "=r"(time_value));
    802035d6:	c01027f3          	rdtime	a5
    802035da:	fef43423          	sd	a5,-24(s0)
    
    return time_value;
    802035de:	fe843783          	ld	a5,-24(s0)
    802035e2:	853e                	mv	a0,a5
    802035e4:	6462                	ld	s0,24(sp)
    802035e6:	6105                	addi	sp,sp,32
    802035e8:	8082                	ret

00000000802035ea <timeintr>:
#include "defs.h"

// 声明外部测试标志
extern volatile int *interrupt_test_flag;
void timeintr(void){
    802035ea:	1141                	addi	sp,sp,-16
    802035ec:	e422                	sd	s0,8(sp)
    802035ee:	0800                	addi	s0,sp,16
	if (interrupt_test_flag)
    802035f0:	00039797          	auipc	a5,0x39
    802035f4:	ad878793          	addi	a5,a5,-1320 # 8023c0c8 <interrupt_test_flag>
    802035f8:	639c                	ld	a5,0(a5)
    802035fa:	cb99                	beqz	a5,80203610 <timeintr+0x26>
        (*interrupt_test_flag)++;
    802035fc:	00039797          	auipc	a5,0x39
    80203600:	acc78793          	addi	a5,a5,-1332 # 8023c0c8 <interrupt_test_flag>
    80203604:	639c                	ld	a5,0(a5)
    80203606:	4398                	lw	a4,0(a5)
    80203608:	2701                	sext.w	a4,a4
    8020360a:	2705                	addiw	a4,a4,1
    8020360c:	2701                	sext.w	a4,a4
    8020360e:	c398                	sw	a4,0(a5)
    80203610:	0001                	nop
    80203612:	6422                	ld	s0,8(sp)
    80203614:	0141                	addi	sp,sp,16
    80203616:	8082                	ret

0000000080203618 <r_sie>:
    80203618:	1101                	addi	sp,sp,-32
    8020361a:	ec22                	sd	s0,24(sp)
    8020361c:	1000                	addi	s0,sp,32
    8020361e:	104027f3          	csrr	a5,sie
    80203622:	fef43423          	sd	a5,-24(s0)
    80203626:	fe843783          	ld	a5,-24(s0)
    8020362a:	853e                	mv	a0,a5
    8020362c:	6462                	ld	s0,24(sp)
    8020362e:	6105                	addi	sp,sp,32
    80203630:	8082                	ret

0000000080203632 <w_sie>:
    80203632:	1101                	addi	sp,sp,-32
    80203634:	ec22                	sd	s0,24(sp)
    80203636:	1000                	addi	s0,sp,32
    80203638:	fea43423          	sd	a0,-24(s0)
    8020363c:	fe843783          	ld	a5,-24(s0)
    80203640:	10479073          	csrw	sie,a5
    80203644:	0001                	nop
    80203646:	6462                	ld	s0,24(sp)
    80203648:	6105                	addi	sp,sp,32
    8020364a:	8082                	ret

000000008020364c <r_sstatus>:
    8020364c:	1101                	addi	sp,sp,-32
    8020364e:	ec22                	sd	s0,24(sp)
    80203650:	1000                	addi	s0,sp,32
    80203652:	100027f3          	csrr	a5,sstatus
    80203656:	fef43423          	sd	a5,-24(s0)
    8020365a:	fe843783          	ld	a5,-24(s0)
    8020365e:	853e                	mv	a0,a5
    80203660:	6462                	ld	s0,24(sp)
    80203662:	6105                	addi	sp,sp,32
    80203664:	8082                	ret

0000000080203666 <w_sstatus>:
    80203666:	1101                	addi	sp,sp,-32
    80203668:	ec22                	sd	s0,24(sp)
    8020366a:	1000                	addi	s0,sp,32
    8020366c:	fea43423          	sd	a0,-24(s0)
    80203670:	fe843783          	ld	a5,-24(s0)
    80203674:	10079073          	csrw	sstatus,a5
    80203678:	0001                	nop
    8020367a:	6462                	ld	s0,24(sp)
    8020367c:	6105                	addi	sp,sp,32
    8020367e:	8082                	ret

0000000080203680 <w_sscratch>:
    80203680:	1101                	addi	sp,sp,-32
    80203682:	ec22                	sd	s0,24(sp)
    80203684:	1000                	addi	s0,sp,32
    80203686:	fea43423          	sd	a0,-24(s0)
    8020368a:	fe843783          	ld	a5,-24(s0)
    8020368e:	14079073          	csrw	sscratch,a5
    80203692:	0001                	nop
    80203694:	6462                	ld	s0,24(sp)
    80203696:	6105                	addi	sp,sp,32
    80203698:	8082                	ret

000000008020369a <w_sepc>:
    8020369a:	1101                	addi	sp,sp,-32
    8020369c:	ec22                	sd	s0,24(sp)
    8020369e:	1000                	addi	s0,sp,32
    802036a0:	fea43423          	sd	a0,-24(s0)
    802036a4:	fe843783          	ld	a5,-24(s0)
    802036a8:	14179073          	csrw	sepc,a5
    802036ac:	0001                	nop
    802036ae:	6462                	ld	s0,24(sp)
    802036b0:	6105                	addi	sp,sp,32
    802036b2:	8082                	ret

00000000802036b4 <intr_off>:
    802036b4:	1141                	addi	sp,sp,-16
    802036b6:	e406                	sd	ra,8(sp)
    802036b8:	e022                	sd	s0,0(sp)
    802036ba:	0800                	addi	s0,sp,16
    802036bc:	00000097          	auipc	ra,0x0
    802036c0:	f90080e7          	jalr	-112(ra) # 8020364c <r_sstatus>
    802036c4:	87aa                	mv	a5,a0
    802036c6:	9bf5                	andi	a5,a5,-3
    802036c8:	853e                	mv	a0,a5
    802036ca:	00000097          	auipc	ra,0x0
    802036ce:	f9c080e7          	jalr	-100(ra) # 80203666 <w_sstatus>
    802036d2:	0001                	nop
    802036d4:	60a2                	ld	ra,8(sp)
    802036d6:	6402                	ld	s0,0(sp)
    802036d8:	0141                	addi	sp,sp,16
    802036da:	8082                	ret

00000000802036dc <w_stvec>:
    802036dc:	1101                	addi	sp,sp,-32
    802036de:	ec22                	sd	s0,24(sp)
    802036e0:	1000                	addi	s0,sp,32
    802036e2:	fea43423          	sd	a0,-24(s0)
    802036e6:	fe843783          	ld	a5,-24(s0)
    802036ea:	10579073          	csrw	stvec,a5
    802036ee:	0001                	nop
    802036f0:	6462                	ld	s0,24(sp)
    802036f2:	6105                	addi	sp,sp,32
    802036f4:	8082                	ret

00000000802036f6 <r_scause>:
    802036f6:	1101                	addi	sp,sp,-32
    802036f8:	ec22                	sd	s0,24(sp)
    802036fa:	1000                	addi	s0,sp,32
    802036fc:	142027f3          	csrr	a5,scause
    80203700:	fef43423          	sd	a5,-24(s0)
    80203704:	fe843783          	ld	a5,-24(s0)
    80203708:	853e                	mv	a0,a5
    8020370a:	6462                	ld	s0,24(sp)
    8020370c:	6105                	addi	sp,sp,32
    8020370e:	8082                	ret

0000000080203710 <r_sepc>:
    80203710:	1101                	addi	sp,sp,-32
    80203712:	ec22                	sd	s0,24(sp)
    80203714:	1000                	addi	s0,sp,32
    80203716:	141027f3          	csrr	a5,sepc
    8020371a:	fef43423          	sd	a5,-24(s0)
    8020371e:	fe843783          	ld	a5,-24(s0)
    80203722:	853e                	mv	a0,a5
    80203724:	6462                	ld	s0,24(sp)
    80203726:	6105                	addi	sp,sp,32
    80203728:	8082                	ret

000000008020372a <r_stval>:
    8020372a:	1101                	addi	sp,sp,-32
    8020372c:	ec22                	sd	s0,24(sp)
    8020372e:	1000                	addi	s0,sp,32
    80203730:	143027f3          	csrr	a5,stval
    80203734:	fef43423          	sd	a5,-24(s0)
    80203738:	fe843783          	ld	a5,-24(s0)
    8020373c:	853e                	mv	a0,a5
    8020373e:	6462                	ld	s0,24(sp)
    80203740:	6105                	addi	sp,sp,32
    80203742:	8082                	ret

0000000080203744 <save_exception_info>:
static inline void save_exception_info(struct trapframe *tf, uint64 sepc, uint64 sstatus, uint64 scause, uint64 stval) {
    80203744:	7139                	addi	sp,sp,-64
    80203746:	fc22                	sd	s0,56(sp)
    80203748:	0080                	addi	s0,sp,64
    8020374a:	fea43423          	sd	a0,-24(s0)
    8020374e:	feb43023          	sd	a1,-32(s0)
    80203752:	fcc43c23          	sd	a2,-40(s0)
    80203756:	fcd43823          	sd	a3,-48(s0)
    8020375a:	fce43423          	sd	a4,-56(s0)
    tf->epc = sepc;
    8020375e:	fe843783          	ld	a5,-24(s0)
    80203762:	fe043703          	ld	a4,-32(s0)
    80203766:	ff98                	sd	a4,56(a5)
}
    80203768:	0001                	nop
    8020376a:	7462                	ld	s0,56(sp)
    8020376c:	6121                	addi	sp,sp,64
    8020376e:	8082                	ret

0000000080203770 <get_sepc>:
static inline uint64 get_sepc(struct trapframe *tf) {
    80203770:	1101                	addi	sp,sp,-32
    80203772:	ec22                	sd	s0,24(sp)
    80203774:	1000                	addi	s0,sp,32
    80203776:	fea43423          	sd	a0,-24(s0)
    return tf->epc;
    8020377a:	fe843783          	ld	a5,-24(s0)
    8020377e:	7f9c                	ld	a5,56(a5)
}
    80203780:	853e                	mv	a0,a5
    80203782:	6462                	ld	s0,24(sp)
    80203784:	6105                	addi	sp,sp,32
    80203786:	8082                	ret

0000000080203788 <set_sepc>:
static inline void set_sepc(struct trapframe *tf, uint64 sepc) {
    80203788:	1101                	addi	sp,sp,-32
    8020378a:	ec22                	sd	s0,24(sp)
    8020378c:	1000                	addi	s0,sp,32
    8020378e:	fea43423          	sd	a0,-24(s0)
    80203792:	feb43023          	sd	a1,-32(s0)
    tf->epc = sepc;
    80203796:	fe843783          	ld	a5,-24(s0)
    8020379a:	fe043703          	ld	a4,-32(s0)
    8020379e:	ff98                	sd	a4,56(a5)
}
    802037a0:	0001                	nop
    802037a2:	6462                	ld	s0,24(sp)
    802037a4:	6105                	addi	sp,sp,32
    802037a6:	8082                	ret

00000000802037a8 <register_interrupt>:
void register_interrupt(int irq, interrupt_handler_t h) {
    802037a8:	1101                	addi	sp,sp,-32
    802037aa:	ec22                	sd	s0,24(sp)
    802037ac:	1000                	addi	s0,sp,32
    802037ae:	87aa                	mv	a5,a0
    802037b0:	feb43023          	sd	a1,-32(s0)
    802037b4:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ){
    802037b8:	fec42783          	lw	a5,-20(s0)
    802037bc:	2781                	sext.w	a5,a5
    802037be:	0207c563          	bltz	a5,802037e8 <register_interrupt+0x40>
    802037c2:	fec42783          	lw	a5,-20(s0)
    802037c6:	0007871b          	sext.w	a4,a5
    802037ca:	03f00793          	li	a5,63
    802037ce:	00e7cd63          	blt	a5,a4,802037e8 <register_interrupt+0x40>
        interrupt_vector[irq] = h;
    802037d2:	00039717          	auipc	a4,0x39
    802037d6:	aa670713          	addi	a4,a4,-1370 # 8023c278 <interrupt_vector>
    802037da:	fec42783          	lw	a5,-20(s0)
    802037de:	078e                	slli	a5,a5,0x3
    802037e0:	97ba                	add	a5,a5,a4
    802037e2:	fe043703          	ld	a4,-32(s0)
    802037e6:	e398                	sd	a4,0(a5)
}
    802037e8:	0001                	nop
    802037ea:	6462                	ld	s0,24(sp)
    802037ec:	6105                	addi	sp,sp,32
    802037ee:	8082                	ret

00000000802037f0 <unregister_interrupt>:
void unregister_interrupt(int irq) {
    802037f0:	1101                	addi	sp,sp,-32
    802037f2:	ec22                	sd	s0,24(sp)
    802037f4:	1000                	addi	s0,sp,32
    802037f6:	87aa                	mv	a5,a0
    802037f8:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ)
    802037fc:	fec42783          	lw	a5,-20(s0)
    80203800:	2781                	sext.w	a5,a5
    80203802:	0207c463          	bltz	a5,8020382a <unregister_interrupt+0x3a>
    80203806:	fec42783          	lw	a5,-20(s0)
    8020380a:	0007871b          	sext.w	a4,a5
    8020380e:	03f00793          	li	a5,63
    80203812:	00e7cc63          	blt	a5,a4,8020382a <unregister_interrupt+0x3a>
        interrupt_vector[irq] = 0;
    80203816:	00039717          	auipc	a4,0x39
    8020381a:	a6270713          	addi	a4,a4,-1438 # 8023c278 <interrupt_vector>
    8020381e:	fec42783          	lw	a5,-20(s0)
    80203822:	078e                	slli	a5,a5,0x3
    80203824:	97ba                	add	a5,a5,a4
    80203826:	0007b023          	sd	zero,0(a5)
}
    8020382a:	0001                	nop
    8020382c:	6462                	ld	s0,24(sp)
    8020382e:	6105                	addi	sp,sp,32
    80203830:	8082                	ret

0000000080203832 <enable_interrupts>:
void enable_interrupts(int irq) {
    80203832:	1101                	addi	sp,sp,-32
    80203834:	ec06                	sd	ra,24(sp)
    80203836:	e822                	sd	s0,16(sp)
    80203838:	1000                	addi	s0,sp,32
    8020383a:	87aa                	mv	a5,a0
    8020383c:	fef42623          	sw	a5,-20(s0)
    plic_enable(irq);
    80203840:	fec42783          	lw	a5,-20(s0)
    80203844:	853e                	mv	a0,a5
    80203846:	00001097          	auipc	ra,0x1
    8020384a:	390080e7          	jalr	912(ra) # 80204bd6 <plic_enable>
}
    8020384e:	0001                	nop
    80203850:	60e2                	ld	ra,24(sp)
    80203852:	6442                	ld	s0,16(sp)
    80203854:	6105                	addi	sp,sp,32
    80203856:	8082                	ret

0000000080203858 <disable_interrupts>:
void disable_interrupts(int irq) {
    80203858:	1101                	addi	sp,sp,-32
    8020385a:	ec06                	sd	ra,24(sp)
    8020385c:	e822                	sd	s0,16(sp)
    8020385e:	1000                	addi	s0,sp,32
    80203860:	87aa                	mv	a5,a0
    80203862:	fef42623          	sw	a5,-20(s0)
    plic_disable(irq);
    80203866:	fec42783          	lw	a5,-20(s0)
    8020386a:	853e                	mv	a0,a5
    8020386c:	00001097          	auipc	ra,0x1
    80203870:	3c2080e7          	jalr	962(ra) # 80204c2e <plic_disable>
}
    80203874:	0001                	nop
    80203876:	60e2                	ld	ra,24(sp)
    80203878:	6442                	ld	s0,16(sp)
    8020387a:	6105                	addi	sp,sp,32
    8020387c:	8082                	ret

000000008020387e <interrupt_dispatch>:
void interrupt_dispatch(int irq) {
    8020387e:	1101                	addi	sp,sp,-32
    80203880:	ec06                	sd	ra,24(sp)
    80203882:	e822                	sd	s0,16(sp)
    80203884:	1000                	addi	s0,sp,32
    80203886:	87aa                	mv	a5,a0
    80203888:	fef42623          	sw	a5,-20(s0)
	if (irq >= 0 && irq < MAX_IRQ && interrupt_vector[irq]){
    8020388c:	fec42783          	lw	a5,-20(s0)
    80203890:	2781                	sext.w	a5,a5
    80203892:	0207ce63          	bltz	a5,802038ce <interrupt_dispatch+0x50>
    80203896:	fec42783          	lw	a5,-20(s0)
    8020389a:	0007871b          	sext.w	a4,a5
    8020389e:	03f00793          	li	a5,63
    802038a2:	02e7c663          	blt	a5,a4,802038ce <interrupt_dispatch+0x50>
    802038a6:	00039717          	auipc	a4,0x39
    802038aa:	9d270713          	addi	a4,a4,-1582 # 8023c278 <interrupt_vector>
    802038ae:	fec42783          	lw	a5,-20(s0)
    802038b2:	078e                	slli	a5,a5,0x3
    802038b4:	97ba                	add	a5,a5,a4
    802038b6:	639c                	ld	a5,0(a5)
    802038b8:	cb99                	beqz	a5,802038ce <interrupt_dispatch+0x50>
		interrupt_vector[irq]();
    802038ba:	00039717          	auipc	a4,0x39
    802038be:	9be70713          	addi	a4,a4,-1602 # 8023c278 <interrupt_vector>
    802038c2:	fec42783          	lw	a5,-20(s0)
    802038c6:	078e                	slli	a5,a5,0x3
    802038c8:	97ba                	add	a5,a5,a4
    802038ca:	639c                	ld	a5,0(a5)
    802038cc:	9782                	jalr	a5
}
    802038ce:	0001                	nop
    802038d0:	60e2                	ld	ra,24(sp)
    802038d2:	6442                	ld	s0,16(sp)
    802038d4:	6105                	addi	sp,sp,32
    802038d6:	8082                	ret

00000000802038d8 <handle_external_interrupt>:
void handle_external_interrupt(void) {
    802038d8:	1101                	addi	sp,sp,-32
    802038da:	ec06                	sd	ra,24(sp)
    802038dc:	e822                	sd	s0,16(sp)
    802038de:	1000                	addi	s0,sp,32
    int irq = plic_claim();
    802038e0:	00001097          	auipc	ra,0x1
    802038e4:	3ac080e7          	jalr	940(ra) # 80204c8c <plic_claim>
    802038e8:	87aa                	mv	a5,a0
    802038ea:	fef42623          	sw	a5,-20(s0)
    if (irq == 0) {
    802038ee:	fec42783          	lw	a5,-20(s0)
    802038f2:	2781                	sext.w	a5,a5
    802038f4:	eb91                	bnez	a5,80203908 <handle_external_interrupt+0x30>
        printf("Spurious external interrupt\n");
    802038f6:	0001c517          	auipc	a0,0x1c
    802038fa:	4aa50513          	addi	a0,a0,1194 # 8021fda0 <user_test_table+0x78>
    802038fe:	ffffd097          	auipc	ra,0xffffd
    80203902:	490080e7          	jalr	1168(ra) # 80200d8e <printf>
        return;
    80203906:	a839                	j	80203924 <handle_external_interrupt+0x4c>
    interrupt_dispatch(irq);
    80203908:	fec42783          	lw	a5,-20(s0)
    8020390c:	853e                	mv	a0,a5
    8020390e:	00000097          	auipc	ra,0x0
    80203912:	f70080e7          	jalr	-144(ra) # 8020387e <interrupt_dispatch>
    plic_complete(irq);
    80203916:	fec42783          	lw	a5,-20(s0)
    8020391a:	853e                	mv	a0,a5
    8020391c:	00001097          	auipc	ra,0x1
    80203920:	398080e7          	jalr	920(ra) # 80204cb4 <plic_complete>
}
    80203924:	60e2                	ld	ra,24(sp)
    80203926:	6442                	ld	s0,16(sp)
    80203928:	6105                	addi	sp,sp,32
    8020392a:	8082                	ret

000000008020392c <trap_init>:
void trap_init(void) {
    8020392c:	1101                	addi	sp,sp,-32
    8020392e:	ec06                	sd	ra,24(sp)
    80203930:	e822                	sd	s0,16(sp)
    80203932:	1000                	addi	s0,sp,32
	intr_off();
    80203934:	00000097          	auipc	ra,0x0
    80203938:	d80080e7          	jalr	-640(ra) # 802036b4 <intr_off>
	printf("trap_init...\n");
    8020393c:	0001c517          	auipc	a0,0x1c
    80203940:	48450513          	addi	a0,a0,1156 # 8021fdc0 <user_test_table+0x98>
    80203944:	ffffd097          	auipc	ra,0xffffd
    80203948:	44a080e7          	jalr	1098(ra) # 80200d8e <printf>
	w_stvec((uint64)kernelvec);
    8020394c:	00001797          	auipc	a5,0x1
    80203950:	3a478793          	addi	a5,a5,932 # 80204cf0 <kernelvec>
    80203954:	853e                	mv	a0,a5
    80203956:	00000097          	auipc	ra,0x0
    8020395a:	d86080e7          	jalr	-634(ra) # 802036dc <w_stvec>
	for(int i = 0; i < MAX_IRQ; i++){
    8020395e:	fe042623          	sw	zero,-20(s0)
    80203962:	a005                	j	80203982 <trap_init+0x56>
		interrupt_vector[i] = 0;
    80203964:	00039717          	auipc	a4,0x39
    80203968:	91470713          	addi	a4,a4,-1772 # 8023c278 <interrupt_vector>
    8020396c:	fec42783          	lw	a5,-20(s0)
    80203970:	078e                	slli	a5,a5,0x3
    80203972:	97ba                	add	a5,a5,a4
    80203974:	0007b023          	sd	zero,0(a5)
	for(int i = 0; i < MAX_IRQ; i++){
    80203978:	fec42783          	lw	a5,-20(s0)
    8020397c:	2785                	addiw	a5,a5,1
    8020397e:	fef42623          	sw	a5,-20(s0)
    80203982:	fec42783          	lw	a5,-20(s0)
    80203986:	0007871b          	sext.w	a4,a5
    8020398a:	03f00793          	li	a5,63
    8020398e:	fce7dbe3          	bge	a5,a4,80203964 <trap_init+0x38>
	plic_init();// 初始化PLIC（外部中断控制器）
    80203992:	00001097          	auipc	ra,0x1
    80203996:	1a6080e7          	jalr	422(ra) # 80204b38 <plic_init>
    uint64 sie = r_sie();
    8020399a:	00000097          	auipc	ra,0x0
    8020399e:	c7e080e7          	jalr	-898(ra) # 80203618 <r_sie>
    802039a2:	fea43023          	sd	a0,-32(s0)
    w_sie(sie | (1L << 5) | (1L<<9)); // 设置SIE.STIE位启用时钟中断和外部中断
    802039a6:	fe043783          	ld	a5,-32(s0)
    802039aa:	2207e793          	ori	a5,a5,544
    802039ae:	853e                	mv	a0,a5
    802039b0:	00000097          	auipc	ra,0x0
    802039b4:	c82080e7          	jalr	-894(ra) # 80203632 <w_sie>
	sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    802039b8:	00000097          	auipc	ra,0x0
    802039bc:	c18080e7          	jalr	-1000(ra) # 802035d0 <sbi_get_time>
    802039c0:	872a                	mv	a4,a0
    802039c2:	000f47b7          	lui	a5,0xf4
    802039c6:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    802039ca:	97ba                	add	a5,a5,a4
    802039cc:	853e                	mv	a0,a5
    802039ce:	00000097          	auipc	ra,0x0
    802039d2:	be6080e7          	jalr	-1050(ra) # 802035b4 <sbi_set_time>
	register_interrupt(VIRTIO0_IRQ, virtio_disk_intr); //设置VIRTIO0中断
    802039d6:	00005597          	auipc	a1,0x5
    802039da:	d7858593          	addi	a1,a1,-648 # 8020874e <virtio_disk_intr>
    802039de:	4505                	li	a0,1
    802039e0:	00000097          	auipc	ra,0x0
    802039e4:	dc8080e7          	jalr	-568(ra) # 802037a8 <register_interrupt>
	printf("Registered exception handlers: store_page_fault=%p\n", handle_store_page_fault);
    802039e8:	00001597          	auipc	a1,0x1
    802039ec:	e8058593          	addi	a1,a1,-384 # 80204868 <handle_store_page_fault>
    802039f0:	0001c517          	auipc	a0,0x1c
    802039f4:	3e050513          	addi	a0,a0,992 # 8021fdd0 <user_test_table+0xa8>
    802039f8:	ffffd097          	auipc	ra,0xffffd
    802039fc:	396080e7          	jalr	918(ra) # 80200d8e <printf>
	printf("trap_init complete.\n");
    80203a00:	0001c517          	auipc	a0,0x1c
    80203a04:	40850513          	addi	a0,a0,1032 # 8021fe08 <user_test_table+0xe0>
    80203a08:	ffffd097          	auipc	ra,0xffffd
    80203a0c:	386080e7          	jalr	902(ra) # 80200d8e <printf>
}
    80203a10:	0001                	nop
    80203a12:	60e2                	ld	ra,24(sp)
    80203a14:	6442                	ld	s0,16(sp)
    80203a16:	6105                	addi	sp,sp,32
    80203a18:	8082                	ret

0000000080203a1a <kerneltrap>:
void kerneltrap(void) {
    80203a1a:	7165                	addi	sp,sp,-400
    80203a1c:	e706                	sd	ra,392(sp)
    80203a1e:	e322                	sd	s0,384(sp)
    80203a20:	0b00                	addi	s0,sp,400
    uint64 sstatus = r_sstatus();
    80203a22:	00000097          	auipc	ra,0x0
    80203a26:	c2a080e7          	jalr	-982(ra) # 8020364c <r_sstatus>
    80203a2a:	fea43023          	sd	a0,-32(s0)
    uint64 scause = r_scause();
    80203a2e:	00000097          	auipc	ra,0x0
    80203a32:	cc8080e7          	jalr	-824(ra) # 802036f6 <r_scause>
    80203a36:	fca43c23          	sd	a0,-40(s0)
    uint64 sepc = r_sepc();
    80203a3a:	00000097          	auipc	ra,0x0
    80203a3e:	cd6080e7          	jalr	-810(ra) # 80203710 <r_sepc>
    80203a42:	fea43423          	sd	a0,-24(s0)
    uint64 stval = r_stval();
    80203a46:	00000097          	auipc	ra,0x0
    80203a4a:	ce4080e7          	jalr	-796(ra) # 8020372a <r_stval>
    80203a4e:	fca43823          	sd	a0,-48(s0)
    if(scause & 0x8000000000000000) {
    80203a52:	fd843783          	ld	a5,-40(s0)
    80203a56:	0807da63          	bgez	a5,80203aea <kerneltrap+0xd0>
        if((scause & 0xff) == 5) {
    80203a5a:	fd843783          	ld	a5,-40(s0)
    80203a5e:	0ff7f713          	zext.b	a4,a5
    80203a62:	4795                	li	a5,5
    80203a64:	04f71a63          	bne	a4,a5,80203ab8 <kerneltrap+0x9e>
            timeintr();
    80203a68:	00000097          	auipc	ra,0x0
    80203a6c:	b82080e7          	jalr	-1150(ra) # 802035ea <timeintr>
            sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    80203a70:	00000097          	auipc	ra,0x0
    80203a74:	b60080e7          	jalr	-1184(ra) # 802035d0 <sbi_get_time>
    80203a78:	872a                	mv	a4,a0
    80203a7a:	000f47b7          	lui	a5,0xf4
    80203a7e:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    80203a82:	97ba                	add	a5,a5,a4
    80203a84:	853e                	mv	a0,a5
    80203a86:	00000097          	auipc	ra,0x0
    80203a8a:	b2e080e7          	jalr	-1234(ra) # 802035b4 <sbi_set_time>
			if(myproc() && myproc()->state == RUNNING) {
    80203a8e:	00001097          	auipc	ra,0x1
    80203a92:	5b2080e7          	jalr	1458(ra) # 80205040 <myproc>
    80203a96:	87aa                	mv	a5,a0
    80203a98:	cbe9                	beqz	a5,80203b6a <kerneltrap+0x150>
    80203a9a:	00001097          	auipc	ra,0x1
    80203a9e:	5a6080e7          	jalr	1446(ra) # 80205040 <myproc>
    80203aa2:	87aa                	mv	a5,a0
    80203aa4:	439c                	lw	a5,0(a5)
    80203aa6:	873e                	mv	a4,a5
    80203aa8:	4791                	li	a5,4
    80203aaa:	0cf71063          	bne	a4,a5,80203b6a <kerneltrap+0x150>
				yield();  // 当前进程让出 CPU
    80203aae:	00002097          	auipc	ra,0x2
    80203ab2:	20e080e7          	jalr	526(ra) # 80205cbc <yield>
    80203ab6:	a855                	j	80203b6a <kerneltrap+0x150>
        } else if((scause & 0xff) == 9) {
    80203ab8:	fd843783          	ld	a5,-40(s0)
    80203abc:	0ff7f713          	zext.b	a4,a5
    80203ac0:	47a5                	li	a5,9
    80203ac2:	00f71763          	bne	a4,a5,80203ad0 <kerneltrap+0xb6>
            handle_external_interrupt();
    80203ac6:	00000097          	auipc	ra,0x0
    80203aca:	e12080e7          	jalr	-494(ra) # 802038d8 <handle_external_interrupt>
    80203ace:	a871                	j	80203b6a <kerneltrap+0x150>
            printf("kerneltrap: unknown interrupt scause=%lx sepc=%lx\n", scause, sepc);
    80203ad0:	fe843603          	ld	a2,-24(s0)
    80203ad4:	fd843583          	ld	a1,-40(s0)
    80203ad8:	0001c517          	auipc	a0,0x1c
    80203adc:	34850513          	addi	a0,a0,840 # 8021fe20 <user_test_table+0xf8>
    80203ae0:	ffffd097          	auipc	ra,0xffffd
    80203ae4:	2ae080e7          	jalr	686(ra) # 80200d8e <printf>
    80203ae8:	a049                	j	80203b6a <kerneltrap+0x150>
        printf("Exception: scause=%ld, sepc=0x%lx, stval=0x%lx\n", scause, sepc, stval);
    80203aea:	fd043683          	ld	a3,-48(s0)
    80203aee:	fe843603          	ld	a2,-24(s0)
    80203af2:	fd843583          	ld	a1,-40(s0)
    80203af6:	0001c517          	auipc	a0,0x1c
    80203afa:	36250513          	addi	a0,a0,866 # 8021fe58 <user_test_table+0x130>
    80203afe:	ffffd097          	auipc	ra,0xffffd
    80203b02:	290080e7          	jalr	656(ra) # 80200d8e <printf>
        save_exception_info(&tf, sepc, sstatus, scause, stval);
    80203b06:	e9840793          	addi	a5,s0,-360
    80203b0a:	fd043703          	ld	a4,-48(s0)
    80203b0e:	fd843683          	ld	a3,-40(s0)
    80203b12:	fe043603          	ld	a2,-32(s0)
    80203b16:	fe843583          	ld	a1,-24(s0)
    80203b1a:	853e                	mv	a0,a5
    80203b1c:	00000097          	auipc	ra,0x0
    80203b20:	c28080e7          	jalr	-984(ra) # 80203744 <save_exception_info>
        info.sepc = sepc;
    80203b24:	fe843783          	ld	a5,-24(s0)
    80203b28:	e6f43c23          	sd	a5,-392(s0)
        info.sstatus = sstatus;
    80203b2c:	fe043783          	ld	a5,-32(s0)
    80203b30:	e8f43023          	sd	a5,-384(s0)
        info.scause = scause;
    80203b34:	fd843783          	ld	a5,-40(s0)
    80203b38:	e8f43423          	sd	a5,-376(s0)
        info.stval = stval;
    80203b3c:	fd043783          	ld	a5,-48(s0)
    80203b40:	e8f43823          	sd	a5,-368(s0)
        handle_exception(&tf, &info);
    80203b44:	e7840713          	addi	a4,s0,-392
    80203b48:	e9840793          	addi	a5,s0,-360
    80203b4c:	85ba                	mv	a1,a4
    80203b4e:	853e                	mv	a0,a5
    80203b50:	00000097          	auipc	ra,0x0
    80203b54:	03c080e7          	jalr	60(ra) # 80203b8c <handle_exception>
        sepc = get_sepc(&tf);
    80203b58:	e9840793          	addi	a5,s0,-360
    80203b5c:	853e                	mv	a0,a5
    80203b5e:	00000097          	auipc	ra,0x0
    80203b62:	c12080e7          	jalr	-1006(ra) # 80203770 <get_sepc>
    80203b66:	fea43423          	sd	a0,-24(s0)
    w_sepc(sepc);
    80203b6a:	fe843503          	ld	a0,-24(s0)
    80203b6e:	00000097          	auipc	ra,0x0
    80203b72:	b2c080e7          	jalr	-1236(ra) # 8020369a <w_sepc>
    w_sstatus(sstatus);
    80203b76:	fe043503          	ld	a0,-32(s0)
    80203b7a:	00000097          	auipc	ra,0x0
    80203b7e:	aec080e7          	jalr	-1300(ra) # 80203666 <w_sstatus>
}
    80203b82:	0001                	nop
    80203b84:	60ba                	ld	ra,392(sp)
    80203b86:	641a                	ld	s0,384(sp)
    80203b88:	6159                	addi	sp,sp,400
    80203b8a:	8082                	ret

0000000080203b8c <handle_exception>:
void handle_exception(struct trapframe *tf, struct trap_info *info) {
    80203b8c:	7139                	addi	sp,sp,-64
    80203b8e:	fc06                	sd	ra,56(sp)
    80203b90:	f822                	sd	s0,48(sp)
    80203b92:	0080                	addi	s0,sp,64
    80203b94:	fca43423          	sd	a0,-56(s0)
    80203b98:	fcb43023          	sd	a1,-64(s0)
    uint64 cause = info->scause;  // 使用info中的字段
    80203b9c:	fc043783          	ld	a5,-64(s0)
    80203ba0:	6b9c                	ld	a5,16(a5)
    80203ba2:	fef43423          	sd	a5,-24(s0)
    switch (cause) {
    80203ba6:	fe843703          	ld	a4,-24(s0)
    80203baa:	47bd                	li	a5,15
    80203bac:	3ee7e763          	bltu	a5,a4,80203f9a <handle_exception+0x40e>
    80203bb0:	fe843783          	ld	a5,-24(s0)
    80203bb4:	00279713          	slli	a4,a5,0x2
    80203bb8:	0001c797          	auipc	a5,0x1c
    80203bbc:	4b478793          	addi	a5,a5,1204 # 8022006c <user_test_table+0x344>
    80203bc0:	97ba                	add	a5,a5,a4
    80203bc2:	439c                	lw	a5,0(a5)
    80203bc4:	0007871b          	sext.w	a4,a5
    80203bc8:	0001c797          	auipc	a5,0x1c
    80203bcc:	4a478793          	addi	a5,a5,1188 # 8022006c <user_test_table+0x344>
    80203bd0:	97ba                	add	a5,a5,a4
    80203bd2:	8782                	jr	a5
            printf("Instruction address misaligned: 0x%lx\n", info->stval);
    80203bd4:	fc043783          	ld	a5,-64(s0)
    80203bd8:	6f9c                	ld	a5,24(a5)
    80203bda:	85be                	mv	a1,a5
    80203bdc:	0001c517          	auipc	a0,0x1c
    80203be0:	2ac50513          	addi	a0,a0,684 # 8021fe88 <user_test_table+0x160>
    80203be4:	ffffd097          	auipc	ra,0xffffd
    80203be8:	1aa080e7          	jalr	426(ra) # 80200d8e <printf>
			if(myproc()->is_user){
    80203bec:	00001097          	auipc	ra,0x1
    80203bf0:	454080e7          	jalr	1108(ra) # 80205040 <myproc>
    80203bf4:	87aa                	mv	a5,a0
    80203bf6:	0a87a783          	lw	a5,168(a5)
    80203bfa:	c791                	beqz	a5,80203c06 <handle_exception+0x7a>
				exit_proc(-1);
    80203bfc:	557d                	li	a0,-1
    80203bfe:	00002097          	auipc	ra,0x2
    80203c02:	2fe080e7          	jalr	766(ra) # 80205efc <exit_proc>
			set_sepc(tf, info->sepc + 4);  // 使用辅助函数
    80203c06:	fc043783          	ld	a5,-64(s0)
    80203c0a:	639c                	ld	a5,0(a5)
    80203c0c:	0791                	addi	a5,a5,4
    80203c0e:	85be                	mv	a1,a5
    80203c10:	fc843503          	ld	a0,-56(s0)
    80203c14:	00000097          	auipc	ra,0x0
    80203c18:	b74080e7          	jalr	-1164(ra) # 80203788 <set_sepc>
            break;
    80203c1c:	ae6d                	j	80203fd6 <handle_exception+0x44a>
            printf("Instruction access fault: 0x%lx\n", info->stval);
    80203c1e:	fc043783          	ld	a5,-64(s0)
    80203c22:	6f9c                	ld	a5,24(a5)
    80203c24:	85be                	mv	a1,a5
    80203c26:	0001c517          	auipc	a0,0x1c
    80203c2a:	28a50513          	addi	a0,a0,650 # 8021feb0 <user_test_table+0x188>
    80203c2e:	ffffd097          	auipc	ra,0xffffd
    80203c32:	160080e7          	jalr	352(ra) # 80200d8e <printf>
			if(myproc()->is_user){
    80203c36:	00001097          	auipc	ra,0x1
    80203c3a:	40a080e7          	jalr	1034(ra) # 80205040 <myproc>
    80203c3e:	87aa                	mv	a5,a0
    80203c40:	0a87a783          	lw	a5,168(a5)
    80203c44:	c791                	beqz	a5,80203c50 <handle_exception+0xc4>
				exit_proc(-1);
    80203c46:	557d                	li	a0,-1
    80203c48:	00002097          	auipc	ra,0x2
    80203c4c:	2b4080e7          	jalr	692(ra) # 80205efc <exit_proc>
			set_sepc(tf, info->sepc + 4);  // 使用辅助函数
    80203c50:	fc043783          	ld	a5,-64(s0)
    80203c54:	639c                	ld	a5,0(a5)
    80203c56:	0791                	addi	a5,a5,4
    80203c58:	85be                	mv	a1,a5
    80203c5a:	fc843503          	ld	a0,-56(s0)
    80203c5e:	00000097          	auipc	ra,0x0
    80203c62:	b2a080e7          	jalr	-1238(ra) # 80203788 <set_sepc>
            break;
    80203c66:	ae85                	j	80203fd6 <handle_exception+0x44a>
			if (copyin((char*)&instruction, (uint64)info->sepc, 4) == 0) {
    80203c68:	fc043783          	ld	a5,-64(s0)
    80203c6c:	6398                	ld	a4,0(a5)
    80203c6e:	fdc40793          	addi	a5,s0,-36
    80203c72:	4611                	li	a2,4
    80203c74:	85ba                	mv	a1,a4
    80203c76:	853e                	mv	a0,a5
    80203c78:	00000097          	auipc	ra,0x0
    80203c7c:	3da080e7          	jalr	986(ra) # 80204052 <copyin>
    80203c80:	87aa                	mv	a5,a0
    80203c82:	ebcd                	bnez	a5,80203d34 <handle_exception+0x1a8>
				uint32_t opcode = instruction & 0x7f;
    80203c84:	fdc42783          	lw	a5,-36(s0)
    80203c88:	07f7f793          	andi	a5,a5,127
    80203c8c:	fef42223          	sw	a5,-28(s0)
				uint32_t funct3 = (instruction >> 12) & 0x7;
    80203c90:	fdc42783          	lw	a5,-36(s0)
    80203c94:	00c7d79b          	srliw	a5,a5,0xc
    80203c98:	2781                	sext.w	a5,a5
    80203c9a:	8b9d                	andi	a5,a5,7
    80203c9c:	fef42023          	sw	a5,-32(s0)
				if (opcode == 0x33 && (funct3 == 0x4 || funct3 == 0x5 || 
    80203ca0:	fe442783          	lw	a5,-28(s0)
    80203ca4:	0007871b          	sext.w	a4,a5
    80203ca8:	03300793          	li	a5,51
    80203cac:	06f71363          	bne	a4,a5,80203d12 <handle_exception+0x186>
    80203cb0:	fe042783          	lw	a5,-32(s0)
    80203cb4:	0007871b          	sext.w	a4,a5
    80203cb8:	4791                	li	a5,4
    80203cba:	02f70763          	beq	a4,a5,80203ce8 <handle_exception+0x15c>
    80203cbe:	fe042783          	lw	a5,-32(s0)
    80203cc2:	0007871b          	sext.w	a4,a5
    80203cc6:	4795                	li	a5,5
    80203cc8:	02f70063          	beq	a4,a5,80203ce8 <handle_exception+0x15c>
    80203ccc:	fe042783          	lw	a5,-32(s0)
    80203cd0:	0007871b          	sext.w	a4,a5
    80203cd4:	4799                	li	a5,6
    80203cd6:	00f70963          	beq	a4,a5,80203ce8 <handle_exception+0x15c>
					funct3 == 0x6 || funct3 == 0x7)) {
    80203cda:	fe042783          	lw	a5,-32(s0)
    80203cde:	0007871b          	sext.w	a4,a5
    80203ce2:	479d                	li	a5,7
    80203ce4:	02f71763          	bne	a4,a5,80203d12 <handle_exception+0x186>
					printf("[FATAL] Process %d killed by divide by zero\n", myproc()->pid);
    80203ce8:	00001097          	auipc	ra,0x1
    80203cec:	358080e7          	jalr	856(ra) # 80205040 <myproc>
    80203cf0:	87aa                	mv	a5,a0
    80203cf2:	43dc                	lw	a5,4(a5)
    80203cf4:	85be                	mv	a1,a5
    80203cf6:	0001c517          	auipc	a0,0x1c
    80203cfa:	1e250513          	addi	a0,a0,482 # 8021fed8 <user_test_table+0x1b0>
    80203cfe:	ffffd097          	auipc	ra,0xffffd
    80203d02:	090080e7          	jalr	144(ra) # 80200d8e <printf>
            		exit_proc(-1);  // 直接终止进程
    80203d06:	557d                	li	a0,-1
    80203d08:	00002097          	auipc	ra,0x2
    80203d0c:	1f4080e7          	jalr	500(ra) # 80205efc <exit_proc>
    80203d10:	a091                	j	80203d54 <handle_exception+0x1c8>
					printf("Illegal instruction at 0x%lx: 0x%lx\n", 
    80203d12:	fc043783          	ld	a5,-64(s0)
    80203d16:	6398                	ld	a4,0(a5)
    80203d18:	fc043783          	ld	a5,-64(s0)
    80203d1c:	6f9c                	ld	a5,24(a5)
    80203d1e:	863e                	mv	a2,a5
    80203d20:	85ba                	mv	a1,a4
    80203d22:	0001c517          	auipc	a0,0x1c
    80203d26:	1e650513          	addi	a0,a0,486 # 8021ff08 <user_test_table+0x1e0>
    80203d2a:	ffffd097          	auipc	ra,0xffffd
    80203d2e:	064080e7          	jalr	100(ra) # 80200d8e <printf>
    80203d32:	a00d                	j	80203d54 <handle_exception+0x1c8>
				printf("Illegal instruction at 0x%lx: 0x%lx\n", 
    80203d34:	fc043783          	ld	a5,-64(s0)
    80203d38:	6398                	ld	a4,0(a5)
    80203d3a:	fc043783          	ld	a5,-64(s0)
    80203d3e:	6f9c                	ld	a5,24(a5)
    80203d40:	863e                	mv	a2,a5
    80203d42:	85ba                	mv	a1,a4
    80203d44:	0001c517          	auipc	a0,0x1c
    80203d48:	1c450513          	addi	a0,a0,452 # 8021ff08 <user_test_table+0x1e0>
    80203d4c:	ffffd097          	auipc	ra,0xffffd
    80203d50:	042080e7          	jalr	66(ra) # 80200d8e <printf>
			if(myproc()->is_user){
    80203d54:	00001097          	auipc	ra,0x1
    80203d58:	2ec080e7          	jalr	748(ra) # 80205040 <myproc>
    80203d5c:	87aa                	mv	a5,a0
    80203d5e:	0a87a783          	lw	a5,168(a5)
    80203d62:	c791                	beqz	a5,80203d6e <handle_exception+0x1e2>
				exit_proc(-1);
    80203d64:	557d                	li	a0,-1
    80203d66:	00002097          	auipc	ra,0x2
    80203d6a:	196080e7          	jalr	406(ra) # 80205efc <exit_proc>
			set_sepc(tf, info->sepc + 4); 
    80203d6e:	fc043783          	ld	a5,-64(s0)
    80203d72:	639c                	ld	a5,0(a5)
    80203d74:	0791                	addi	a5,a5,4
    80203d76:	85be                	mv	a1,a5
    80203d78:	fc843503          	ld	a0,-56(s0)
    80203d7c:	00000097          	auipc	ra,0x0
    80203d80:	a0c080e7          	jalr	-1524(ra) # 80203788 <set_sepc>
			break;
    80203d84:	ac89                	j	80203fd6 <handle_exception+0x44a>
            printf("Breakpoint at 0x%lx\n", info->sepc);
    80203d86:	fc043783          	ld	a5,-64(s0)
    80203d8a:	639c                	ld	a5,0(a5)
    80203d8c:	85be                	mv	a1,a5
    80203d8e:	0001c517          	auipc	a0,0x1c
    80203d92:	1a250513          	addi	a0,a0,418 # 8021ff30 <user_test_table+0x208>
    80203d96:	ffffd097          	auipc	ra,0xffffd
    80203d9a:	ff8080e7          	jalr	-8(ra) # 80200d8e <printf>
            set_sepc(tf, info->sepc + 4);
    80203d9e:	fc043783          	ld	a5,-64(s0)
    80203da2:	639c                	ld	a5,0(a5)
    80203da4:	0791                	addi	a5,a5,4
    80203da6:	85be                	mv	a1,a5
    80203da8:	fc843503          	ld	a0,-56(s0)
    80203dac:	00000097          	auipc	ra,0x0
    80203db0:	9dc080e7          	jalr	-1572(ra) # 80203788 <set_sepc>
            break;
    80203db4:	a40d                	j	80203fd6 <handle_exception+0x44a>
            printf("Load address misaligned: 0x%lx\n", info->stval);
    80203db6:	fc043783          	ld	a5,-64(s0)
    80203dba:	6f9c                	ld	a5,24(a5)
    80203dbc:	85be                	mv	a1,a5
    80203dbe:	0001c517          	auipc	a0,0x1c
    80203dc2:	18a50513          	addi	a0,a0,394 # 8021ff48 <user_test_table+0x220>
    80203dc6:	ffffd097          	auipc	ra,0xffffd
    80203dca:	fc8080e7          	jalr	-56(ra) # 80200d8e <printf>
			if(myproc()->is_user){
    80203dce:	00001097          	auipc	ra,0x1
    80203dd2:	272080e7          	jalr	626(ra) # 80205040 <myproc>
    80203dd6:	87aa                	mv	a5,a0
    80203dd8:	0a87a783          	lw	a5,168(a5)
    80203ddc:	c791                	beqz	a5,80203de8 <handle_exception+0x25c>
				exit_proc(-1);
    80203dde:	557d                	li	a0,-1
    80203de0:	00002097          	auipc	ra,0x2
    80203de4:	11c080e7          	jalr	284(ra) # 80205efc <exit_proc>
			set_sepc(tf, info->sepc + 4); 
    80203de8:	fc043783          	ld	a5,-64(s0)
    80203dec:	639c                	ld	a5,0(a5)
    80203dee:	0791                	addi	a5,a5,4
    80203df0:	85be                	mv	a1,a5
    80203df2:	fc843503          	ld	a0,-56(s0)
    80203df6:	00000097          	auipc	ra,0x0
    80203dfa:	992080e7          	jalr	-1646(ra) # 80203788 <set_sepc>
            break;
    80203dfe:	aae1                	j	80203fd6 <handle_exception+0x44a>
			printf("Load access fault: 0x%lx\n", info->stval);
    80203e00:	fc043783          	ld	a5,-64(s0)
    80203e04:	6f9c                	ld	a5,24(a5)
    80203e06:	85be                	mv	a1,a5
    80203e08:	0001c517          	auipc	a0,0x1c
    80203e0c:	16050513          	addi	a0,a0,352 # 8021ff68 <user_test_table+0x240>
    80203e10:	ffffd097          	auipc	ra,0xffffd
    80203e14:	f7e080e7          	jalr	-130(ra) # 80200d8e <printf>
			if (check_is_mapped(info->stval) && handle_page_fault(info->stval, 2)) {
    80203e18:	fc043783          	ld	a5,-64(s0)
    80203e1c:	6f9c                	ld	a5,24(a5)
    80203e1e:	853e                	mv	a0,a5
    80203e20:	fffff097          	auipc	ra,0xfffff
    80203e24:	2c8080e7          	jalr	712(ra) # 802030e8 <check_is_mapped>
    80203e28:	87aa                	mv	a5,a0
    80203e2a:	cf89                	beqz	a5,80203e44 <handle_exception+0x2b8>
    80203e2c:	fc043783          	ld	a5,-64(s0)
    80203e30:	6f9c                	ld	a5,24(a5)
    80203e32:	4589                	li	a1,2
    80203e34:	853e                	mv	a0,a5
    80203e36:	fffff097          	auipc	ra,0xfffff
    80203e3a:	c46080e7          	jalr	-954(ra) # 80202a7c <handle_page_fault>
    80203e3e:	87aa                	mv	a5,a0
    80203e40:	18079863          	bnez	a5,80203fd0 <handle_exception+0x444>
			set_sepc(tf, info->sepc + 4);
    80203e44:	fc043783          	ld	a5,-64(s0)
    80203e48:	639c                	ld	a5,0(a5)
    80203e4a:	0791                	addi	a5,a5,4
    80203e4c:	85be                	mv	a1,a5
    80203e4e:	fc843503          	ld	a0,-56(s0)
    80203e52:	00000097          	auipc	ra,0x0
    80203e56:	936080e7          	jalr	-1738(ra) # 80203788 <set_sepc>
			break;
    80203e5a:	aab5                	j	80203fd6 <handle_exception+0x44a>
            printf("Store address misaligned: 0x%lx\n", info->stval);
    80203e5c:	fc043783          	ld	a5,-64(s0)
    80203e60:	6f9c                	ld	a5,24(a5)
    80203e62:	85be                	mv	a1,a5
    80203e64:	0001c517          	auipc	a0,0x1c
    80203e68:	12450513          	addi	a0,a0,292 # 8021ff88 <user_test_table+0x260>
    80203e6c:	ffffd097          	auipc	ra,0xffffd
    80203e70:	f22080e7          	jalr	-222(ra) # 80200d8e <printf>
			if(myproc()->is_user){
    80203e74:	00001097          	auipc	ra,0x1
    80203e78:	1cc080e7          	jalr	460(ra) # 80205040 <myproc>
    80203e7c:	87aa                	mv	a5,a0
    80203e7e:	0a87a783          	lw	a5,168(a5)
    80203e82:	c791                	beqz	a5,80203e8e <handle_exception+0x302>
				exit_proc(-1);
    80203e84:	557d                	li	a0,-1
    80203e86:	00002097          	auipc	ra,0x2
    80203e8a:	076080e7          	jalr	118(ra) # 80205efc <exit_proc>
			set_sepc(tf, info->sepc + 4); 
    80203e8e:	fc043783          	ld	a5,-64(s0)
    80203e92:	639c                	ld	a5,0(a5)
    80203e94:	0791                	addi	a5,a5,4
    80203e96:	85be                	mv	a1,a5
    80203e98:	fc843503          	ld	a0,-56(s0)
    80203e9c:	00000097          	auipc	ra,0x0
    80203ea0:	8ec080e7          	jalr	-1812(ra) # 80203788 <set_sepc>
            break;
    80203ea4:	aa0d                	j	80203fd6 <handle_exception+0x44a>
			printf("Store access fault: 0x%lx\n", info->stval);
    80203ea6:	fc043783          	ld	a5,-64(s0)
    80203eaa:	6f9c                	ld	a5,24(a5)
    80203eac:	85be                	mv	a1,a5
    80203eae:	0001c517          	auipc	a0,0x1c
    80203eb2:	10250513          	addi	a0,a0,258 # 8021ffb0 <user_test_table+0x288>
    80203eb6:	ffffd097          	auipc	ra,0xffffd
    80203eba:	ed8080e7          	jalr	-296(ra) # 80200d8e <printf>
			if (check_is_mapped(info->stval) && handle_page_fault(info->stval, 3)) {
    80203ebe:	fc043783          	ld	a5,-64(s0)
    80203ec2:	6f9c                	ld	a5,24(a5)
    80203ec4:	853e                	mv	a0,a5
    80203ec6:	fffff097          	auipc	ra,0xfffff
    80203eca:	222080e7          	jalr	546(ra) # 802030e8 <check_is_mapped>
    80203ece:	87aa                	mv	a5,a0
    80203ed0:	cf81                	beqz	a5,80203ee8 <handle_exception+0x35c>
    80203ed2:	fc043783          	ld	a5,-64(s0)
    80203ed6:	6f9c                	ld	a5,24(a5)
    80203ed8:	458d                	li	a1,3
    80203eda:	853e                	mv	a0,a5
    80203edc:	fffff097          	auipc	ra,0xfffff
    80203ee0:	ba0080e7          	jalr	-1120(ra) # 80202a7c <handle_page_fault>
    80203ee4:	87aa                	mv	a5,a0
    80203ee6:	e7fd                	bnez	a5,80203fd4 <handle_exception+0x448>
			set_sepc(tf, info->sepc + 4);
    80203ee8:	fc043783          	ld	a5,-64(s0)
    80203eec:	639c                	ld	a5,0(a5)
    80203eee:	0791                	addi	a5,a5,4
    80203ef0:	85be                	mv	a1,a5
    80203ef2:	fc843503          	ld	a0,-56(s0)
    80203ef6:	00000097          	auipc	ra,0x0
    80203efa:	892080e7          	jalr	-1902(ra) # 80203788 <set_sepc>
			break;
    80203efe:	a8e1                	j	80203fd6 <handle_exception+0x44a>
			if(myproc()->is_user){
    80203f00:	00001097          	auipc	ra,0x1
    80203f04:	140080e7          	jalr	320(ra) # 80205040 <myproc>
    80203f08:	87aa                	mv	a5,a0
    80203f0a:	0a87a783          	lw	a5,168(a5)
    80203f0e:	cb91                	beqz	a5,80203f22 <handle_exception+0x396>
            	handle_syscall(tf,info);
    80203f10:	fc043583          	ld	a1,-64(s0)
    80203f14:	fc843503          	ld	a0,-56(s0)
    80203f18:	00000097          	auipc	ra,0x0
    80203f1c:	42a080e7          	jalr	1066(ra) # 80204342 <handle_syscall>
            break;
    80203f20:	a85d                	j	80203fd6 <handle_exception+0x44a>
				warning("[EXCEPTION] ecall was called in S-mode");
    80203f22:	0001c517          	auipc	a0,0x1c
    80203f26:	0ae50513          	addi	a0,a0,174 # 8021ffd0 <user_test_table+0x2a8>
    80203f2a:	ffffe097          	auipc	ra,0xffffe
    80203f2e:	8e4080e7          	jalr	-1820(ra) # 8020180e <warning>
            break;
    80203f32:	a055                	j	80203fd6 <handle_exception+0x44a>
            printf("Supervisor environment call at 0x%lx\n", info->sepc);
    80203f34:	fc043783          	ld	a5,-64(s0)
    80203f38:	639c                	ld	a5,0(a5)
    80203f3a:	85be                	mv	a1,a5
    80203f3c:	0001c517          	auipc	a0,0x1c
    80203f40:	0bc50513          	addi	a0,a0,188 # 8021fff8 <user_test_table+0x2d0>
    80203f44:	ffffd097          	auipc	ra,0xffffd
    80203f48:	e4a080e7          	jalr	-438(ra) # 80200d8e <printf>
			set_sepc(tf, info->sepc + 4); 
    80203f4c:	fc043783          	ld	a5,-64(s0)
    80203f50:	639c                	ld	a5,0(a5)
    80203f52:	0791                	addi	a5,a5,4
    80203f54:	85be                	mv	a1,a5
    80203f56:	fc843503          	ld	a0,-56(s0)
    80203f5a:	00000097          	auipc	ra,0x0
    80203f5e:	82e080e7          	jalr	-2002(ra) # 80203788 <set_sepc>
            break;
    80203f62:	a895                	j	80203fd6 <handle_exception+0x44a>
            handle_instruction_page_fault(tf,info);
    80203f64:	fc043583          	ld	a1,-64(s0)
    80203f68:	fc843503          	ld	a0,-56(s0)
    80203f6c:	00001097          	auipc	ra,0x1
    80203f70:	838080e7          	jalr	-1992(ra) # 802047a4 <handle_instruction_page_fault>
            break;
    80203f74:	a08d                	j	80203fd6 <handle_exception+0x44a>
            handle_load_page_fault(tf,info);
    80203f76:	fc043583          	ld	a1,-64(s0)
    80203f7a:	fc843503          	ld	a0,-56(s0)
    80203f7e:	00001097          	auipc	ra,0x1
    80203f82:	888080e7          	jalr	-1912(ra) # 80204806 <handle_load_page_fault>
            break;
    80203f86:	a881                	j	80203fd6 <handle_exception+0x44a>
            handle_store_page_fault(tf,info);
    80203f88:	fc043583          	ld	a1,-64(s0)
    80203f8c:	fc843503          	ld	a0,-56(s0)
    80203f90:	00001097          	auipc	ra,0x1
    80203f94:	8d8080e7          	jalr	-1832(ra) # 80204868 <handle_store_page_fault>
            break;
    80203f98:	a83d                	j	80203fd6 <handle_exception+0x44a>
            printf("Unknown exception: cause=%ld, sepc=0x%lx, stval=0x%lx\n", 
    80203f9a:	fc043783          	ld	a5,-64(s0)
    80203f9e:	6398                	ld	a4,0(a5)
    80203fa0:	fc043783          	ld	a5,-64(s0)
    80203fa4:	6f9c                	ld	a5,24(a5)
    80203fa6:	86be                	mv	a3,a5
    80203fa8:	863a                	mv	a2,a4
    80203faa:	fe843583          	ld	a1,-24(s0)
    80203fae:	0001c517          	auipc	a0,0x1c
    80203fb2:	07250513          	addi	a0,a0,114 # 80220020 <user_test_table+0x2f8>
    80203fb6:	ffffd097          	auipc	ra,0xffffd
    80203fba:	dd8080e7          	jalr	-552(ra) # 80200d8e <printf>
            panic("Unknown exception");
    80203fbe:	0001c517          	auipc	a0,0x1c
    80203fc2:	09a50513          	addi	a0,a0,154 # 80220058 <user_test_table+0x330>
    80203fc6:	ffffe097          	auipc	ra,0xffffe
    80203fca:	814080e7          	jalr	-2028(ra) # 802017da <panic>
            break;
    80203fce:	a021                	j	80203fd6 <handle_exception+0x44a>
				return; // 成功处理
    80203fd0:	0001                	nop
    80203fd2:	a011                	j	80203fd6 <handle_exception+0x44a>
				return; // 成功处理
    80203fd4:	0001                	nop
}
    80203fd6:	70e2                	ld	ra,56(sp)
    80203fd8:	7442                	ld	s0,48(sp)
    80203fda:	6121                	addi	sp,sp,64
    80203fdc:	8082                	ret

0000000080203fde <user_va2pa>:
void* user_va2pa(pagetable_t pagetable, uint64 va) {
    80203fde:	7179                	addi	sp,sp,-48
    80203fe0:	f406                	sd	ra,40(sp)
    80203fe2:	f022                	sd	s0,32(sp)
    80203fe4:	1800                	addi	s0,sp,48
    80203fe6:	fca43c23          	sd	a0,-40(s0)
    80203fea:	fcb43823          	sd	a1,-48(s0)
    pte_t *pte = walk_lookup(pagetable, va);
    80203fee:	fd043583          	ld	a1,-48(s0)
    80203ff2:	fd843503          	ld	a0,-40(s0)
    80203ff6:	ffffe097          	auipc	ra,0xffffe
    80203ffa:	1ba080e7          	jalr	442(ra) # 802021b0 <walk_lookup>
    80203ffe:	fea43423          	sd	a0,-24(s0)
    if (!pte) return 0;
    80204002:	fe843783          	ld	a5,-24(s0)
    80204006:	e399                	bnez	a5,8020400c <user_va2pa+0x2e>
    80204008:	4781                	li	a5,0
    8020400a:	a83d                	j	80204048 <user_va2pa+0x6a>
    if (!(*pte & PTE_V)) return 0;
    8020400c:	fe843783          	ld	a5,-24(s0)
    80204010:	639c                	ld	a5,0(a5)
    80204012:	8b85                	andi	a5,a5,1
    80204014:	e399                	bnez	a5,8020401a <user_va2pa+0x3c>
    80204016:	4781                	li	a5,0
    80204018:	a805                	j	80204048 <user_va2pa+0x6a>
    if (!(*pte & PTE_U)) return 0; // 必须是用户可访问
    8020401a:	fe843783          	ld	a5,-24(s0)
    8020401e:	639c                	ld	a5,0(a5)
    80204020:	8bc1                	andi	a5,a5,16
    80204022:	e399                	bnez	a5,80204028 <user_va2pa+0x4a>
    80204024:	4781                	li	a5,0
    80204026:	a00d                	j	80204048 <user_va2pa+0x6a>
    uint64 pa = (PTE2PA(*pte)) | (va & 0xFFF); // 物理页基址 + 页内偏移
    80204028:	fe843783          	ld	a5,-24(s0)
    8020402c:	639c                	ld	a5,0(a5)
    8020402e:	83a9                	srli	a5,a5,0xa
    80204030:	00c79713          	slli	a4,a5,0xc
    80204034:	fd043683          	ld	a3,-48(s0)
    80204038:	6785                	lui	a5,0x1
    8020403a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    8020403c:	8ff5                	and	a5,a5,a3
    8020403e:	8fd9                	or	a5,a5,a4
    80204040:	fef43023          	sd	a5,-32(s0)
    return (void*)pa;
    80204044:	fe043783          	ld	a5,-32(s0)
}
    80204048:	853e                	mv	a0,a5
    8020404a:	70a2                	ld	ra,40(sp)
    8020404c:	7402                	ld	s0,32(sp)
    8020404e:	6145                	addi	sp,sp,48
    80204050:	8082                	ret

0000000080204052 <copyin>:
int copyin(char *dst, uint64 srcva, int maxlen) {
    80204052:	715d                	addi	sp,sp,-80
    80204054:	e486                	sd	ra,72(sp)
    80204056:	e0a2                	sd	s0,64(sp)
    80204058:	0880                	addi	s0,sp,80
    8020405a:	fca43423          	sd	a0,-56(s0)
    8020405e:	fcb43023          	sd	a1,-64(s0)
    80204062:	87b2                	mv	a5,a2
    80204064:	faf42e23          	sw	a5,-68(s0)
    struct proc *p = myproc();
    80204068:	00001097          	auipc	ra,0x1
    8020406c:	fd8080e7          	jalr	-40(ra) # 80205040 <myproc>
    80204070:	fea43023          	sd	a0,-32(s0)
    for (int i = 0; i < maxlen; i++) {
    80204074:	fe042623          	sw	zero,-20(s0)
    80204078:	a085                	j	802040d8 <copyin+0x86>
        char *pa = user_va2pa(p->pagetable, srcva + i);
    8020407a:	fe043783          	ld	a5,-32(s0)
    8020407e:	7fd4                	ld	a3,184(a5)
    80204080:	fec42703          	lw	a4,-20(s0)
    80204084:	fc043783          	ld	a5,-64(s0)
    80204088:	97ba                	add	a5,a5,a4
    8020408a:	85be                	mv	a1,a5
    8020408c:	8536                	mv	a0,a3
    8020408e:	00000097          	auipc	ra,0x0
    80204092:	f50080e7          	jalr	-176(ra) # 80203fde <user_va2pa>
    80204096:	fca43c23          	sd	a0,-40(s0)
        if (!pa) return -1;
    8020409a:	fd843783          	ld	a5,-40(s0)
    8020409e:	e399                	bnez	a5,802040a4 <copyin+0x52>
    802040a0:	57fd                	li	a5,-1
    802040a2:	a0a9                	j	802040ec <copyin+0x9a>
        dst[i] = *pa;
    802040a4:	fec42783          	lw	a5,-20(s0)
    802040a8:	fc843703          	ld	a4,-56(s0)
    802040ac:	97ba                	add	a5,a5,a4
    802040ae:	fd843703          	ld	a4,-40(s0)
    802040b2:	00074703          	lbu	a4,0(a4)
    802040b6:	00e78023          	sb	a4,0(a5)
        if (dst[i] == 0) return 0;
    802040ba:	fec42783          	lw	a5,-20(s0)
    802040be:	fc843703          	ld	a4,-56(s0)
    802040c2:	97ba                	add	a5,a5,a4
    802040c4:	0007c783          	lbu	a5,0(a5)
    802040c8:	e399                	bnez	a5,802040ce <copyin+0x7c>
    802040ca:	4781                	li	a5,0
    802040cc:	a005                	j	802040ec <copyin+0x9a>
    for (int i = 0; i < maxlen; i++) {
    802040ce:	fec42783          	lw	a5,-20(s0)
    802040d2:	2785                	addiw	a5,a5,1
    802040d4:	fef42623          	sw	a5,-20(s0)
    802040d8:	fec42783          	lw	a5,-20(s0)
    802040dc:	873e                	mv	a4,a5
    802040de:	fbc42783          	lw	a5,-68(s0)
    802040e2:	2701                	sext.w	a4,a4
    802040e4:	2781                	sext.w	a5,a5
    802040e6:	f8f74ae3          	blt	a4,a5,8020407a <copyin+0x28>
    return 0;
    802040ea:	4781                	li	a5,0
}
    802040ec:	853e                	mv	a0,a5
    802040ee:	60a6                	ld	ra,72(sp)
    802040f0:	6406                	ld	s0,64(sp)
    802040f2:	6161                	addi	sp,sp,80
    802040f4:	8082                	ret

00000000802040f6 <copyout>:
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
    802040f6:	7139                	addi	sp,sp,-64
    802040f8:	fc06                	sd	ra,56(sp)
    802040fa:	f822                	sd	s0,48(sp)
    802040fc:	0080                	addi	s0,sp,64
    802040fe:	fca43c23          	sd	a0,-40(s0)
    80204102:	fcb43823          	sd	a1,-48(s0)
    80204106:	fcc43423          	sd	a2,-56(s0)
    8020410a:	fcd43023          	sd	a3,-64(s0)
    for (uint64 i = 0; i < len; i++) {
    8020410e:	fe043423          	sd	zero,-24(s0)
    80204112:	a0a1                	j	8020415a <copyout+0x64>
        char *pa = user_va2pa(pagetable, dstva + i);
    80204114:	fd043703          	ld	a4,-48(s0)
    80204118:	fe843783          	ld	a5,-24(s0)
    8020411c:	97ba                	add	a5,a5,a4
    8020411e:	85be                	mv	a1,a5
    80204120:	fd843503          	ld	a0,-40(s0)
    80204124:	00000097          	auipc	ra,0x0
    80204128:	eba080e7          	jalr	-326(ra) # 80203fde <user_va2pa>
    8020412c:	fea43023          	sd	a0,-32(s0)
        if (!pa) return -1;
    80204130:	fe043783          	ld	a5,-32(s0)
    80204134:	e399                	bnez	a5,8020413a <copyout+0x44>
    80204136:	57fd                	li	a5,-1
    80204138:	a805                	j	80204168 <copyout+0x72>
        *pa = src[i];
    8020413a:	fc843703          	ld	a4,-56(s0)
    8020413e:	fe843783          	ld	a5,-24(s0)
    80204142:	97ba                	add	a5,a5,a4
    80204144:	0007c703          	lbu	a4,0(a5)
    80204148:	fe043783          	ld	a5,-32(s0)
    8020414c:	00e78023          	sb	a4,0(a5)
    for (uint64 i = 0; i < len; i++) {
    80204150:	fe843783          	ld	a5,-24(s0)
    80204154:	0785                	addi	a5,a5,1
    80204156:	fef43423          	sd	a5,-24(s0)
    8020415a:	fe843703          	ld	a4,-24(s0)
    8020415e:	fc043783          	ld	a5,-64(s0)
    80204162:	faf769e3          	bltu	a4,a5,80204114 <copyout+0x1e>
    return 0;
    80204166:	4781                	li	a5,0
}
    80204168:	853e                	mv	a0,a5
    8020416a:	70e2                	ld	ra,56(sp)
    8020416c:	7442                	ld	s0,48(sp)
    8020416e:	6121                	addi	sp,sp,64
    80204170:	8082                	ret

0000000080204172 <copyinstr>:
int copyinstr(char *dst, pagetable_t pagetable, uint64 srcva, int max) {
    80204172:	7139                	addi	sp,sp,-64
    80204174:	fc06                	sd	ra,56(sp)
    80204176:	f822                	sd	s0,48(sp)
    80204178:	0080                	addi	s0,sp,64
    8020417a:	fca43c23          	sd	a0,-40(s0)
    8020417e:	fcb43823          	sd	a1,-48(s0)
    80204182:	fcc43423          	sd	a2,-56(s0)
    80204186:	87b6                	mv	a5,a3
    80204188:	fcf42223          	sw	a5,-60(s0)
    for (i = 0; i < max; i++) {
    8020418c:	fe042623          	sw	zero,-20(s0)
    80204190:	a0b9                	j	802041de <copyinstr+0x6c>
        if (copyin(&c, srcva + i, 1) < 0)  // 每次拷贝 1 字节
    80204192:	fec42703          	lw	a4,-20(s0)
    80204196:	fc843783          	ld	a5,-56(s0)
    8020419a:	973e                	add	a4,a4,a5
    8020419c:	feb40793          	addi	a5,s0,-21
    802041a0:	4605                	li	a2,1
    802041a2:	85ba                	mv	a1,a4
    802041a4:	853e                	mv	a0,a5
    802041a6:	00000097          	auipc	ra,0x0
    802041aa:	eac080e7          	jalr	-340(ra) # 80204052 <copyin>
    802041ae:	87aa                	mv	a5,a0
    802041b0:	0007d463          	bgez	a5,802041b8 <copyinstr+0x46>
            return -1;
    802041b4:	57fd                	li	a5,-1
    802041b6:	a0b1                	j	80204202 <copyinstr+0x90>
        dst[i] = c;
    802041b8:	fec42783          	lw	a5,-20(s0)
    802041bc:	fd843703          	ld	a4,-40(s0)
    802041c0:	97ba                	add	a5,a5,a4
    802041c2:	feb44703          	lbu	a4,-21(s0)
    802041c6:	00e78023          	sb	a4,0(a5)
        if (c == '\0')
    802041ca:	feb44783          	lbu	a5,-21(s0)
    802041ce:	e399                	bnez	a5,802041d4 <copyinstr+0x62>
            return 0;
    802041d0:	4781                	li	a5,0
    802041d2:	a805                	j	80204202 <copyinstr+0x90>
    for (i = 0; i < max; i++) {
    802041d4:	fec42783          	lw	a5,-20(s0)
    802041d8:	2785                	addiw	a5,a5,1
    802041da:	fef42623          	sw	a5,-20(s0)
    802041de:	fec42783          	lw	a5,-20(s0)
    802041e2:	873e                	mv	a4,a5
    802041e4:	fc442783          	lw	a5,-60(s0)
    802041e8:	2701                	sext.w	a4,a4
    802041ea:	2781                	sext.w	a5,a5
    802041ec:	faf743e3          	blt	a4,a5,80204192 <copyinstr+0x20>
    dst[max-1] = '\0';
    802041f0:	fc442783          	lw	a5,-60(s0)
    802041f4:	17fd                	addi	a5,a5,-1
    802041f6:	fd843703          	ld	a4,-40(s0)
    802041fa:	97ba                	add	a5,a5,a4
    802041fc:	00078023          	sb	zero,0(a5)
    return -1; // 超过最大长度还没遇到 \0
    80204200:	57fd                	li	a5,-1
}
    80204202:	853e                	mv	a0,a5
    80204204:	70e2                	ld	ra,56(sp)
    80204206:	7442                	ld	s0,48(sp)
    80204208:	6121                	addi	sp,sp,64
    8020420a:	8082                	ret

000000008020420c <check_user_addr>:
int check_user_addr(uint64 addr, uint64 size, int write) {
    8020420c:	7179                	addi	sp,sp,-48
    8020420e:	f422                	sd	s0,40(sp)
    80204210:	1800                	addi	s0,sp,48
    80204212:	fea43423          	sd	a0,-24(s0)
    80204216:	feb43023          	sd	a1,-32(s0)
    8020421a:	87b2                	mv	a5,a2
    8020421c:	fcf42e23          	sw	a5,-36(s0)
    if (!IS_USER_ADDR(addr) || !IS_USER_ADDR(addr + size - 1))
    80204220:	fe843703          	ld	a4,-24(s0)
    80204224:	67c1                	lui	a5,0x10
    80204226:	02f76d63          	bltu	a4,a5,80204260 <check_user_addr+0x54>
    8020422a:	fe843703          	ld	a4,-24(s0)
    8020422e:	57fd                	li	a5,-1
    80204230:	83e5                	srli	a5,a5,0x19
    80204232:	02e7e763          	bltu	a5,a4,80204260 <check_user_addr+0x54>
    80204236:	fe843703          	ld	a4,-24(s0)
    8020423a:	fe043783          	ld	a5,-32(s0)
    8020423e:	97ba                	add	a5,a5,a4
    80204240:	fff78713          	addi	a4,a5,-1 # ffff <_entry-0x801f0001>
    80204244:	67c1                	lui	a5,0x10
    80204246:	00f76d63          	bltu	a4,a5,80204260 <check_user_addr+0x54>
    8020424a:	fe843703          	ld	a4,-24(s0)
    8020424e:	fe043783          	ld	a5,-32(s0)
    80204252:	97ba                	add	a5,a5,a4
    80204254:	fff78713          	addi	a4,a5,-1 # ffff <_entry-0x801f0001>
    80204258:	57fd                	li	a5,-1
    8020425a:	83e5                	srli	a5,a5,0x19
    8020425c:	00e7f463          	bgeu	a5,a4,80204264 <check_user_addr+0x58>
        return -1;
    80204260:	57fd                	li	a5,-1
    80204262:	a8e1                	j	8020433a <check_user_addr+0x12e>
    if (IS_USER_STACK(addr)) {
    80204264:	fe843703          	ld	a4,-24(s0)
    80204268:	ddfff7b7          	lui	a5,0xddfff
    8020426c:	07b6                	slli	a5,a5,0xd
    8020426e:	83e5                	srli	a5,a5,0x19
    80204270:	04e7f663          	bgeu	a5,a4,802042bc <check_user_addr+0xb0>
    80204274:	fe843703          	ld	a4,-24(s0)
    80204278:	fdfff7b7          	lui	a5,0xfdfff
    8020427c:	07b6                	slli	a5,a5,0xd
    8020427e:	83e5                	srli	a5,a5,0x19
    80204280:	02e7ee63          	bltu	a5,a4,802042bc <check_user_addr+0xb0>
        if (!IS_USER_STACK(addr + size - 1))
    80204284:	fe843703          	ld	a4,-24(s0)
    80204288:	fe043783          	ld	a5,-32(s0)
    8020428c:	97ba                	add	a5,a5,a4
    8020428e:	fff78713          	addi	a4,a5,-1 # fffffffffdffefff <_bss_end+0xffffffff7ddb76df>
    80204292:	ddfff7b7          	lui	a5,0xddfff
    80204296:	07b6                	slli	a5,a5,0xd
    80204298:	83e5                	srli	a5,a5,0x19
    8020429a:	00e7ff63          	bgeu	a5,a4,802042b8 <check_user_addr+0xac>
    8020429e:	fe843703          	ld	a4,-24(s0)
    802042a2:	fe043783          	ld	a5,-32(s0)
    802042a6:	97ba                	add	a5,a5,a4
    802042a8:	fff78713          	addi	a4,a5,-1 # ffffffffddffefff <_bss_end+0xffffffff5ddb76df>
    802042ac:	fdfff7b7          	lui	a5,0xfdfff
    802042b0:	07b6                	slli	a5,a5,0xd
    802042b2:	83e5                	srli	a5,a5,0x19
    802042b4:	06e7ff63          	bgeu	a5,a4,80204332 <check_user_addr+0x126>
            return -1;  // 跨越栈边界
    802042b8:	57fd                	li	a5,-1
    802042ba:	a041                	j	8020433a <check_user_addr+0x12e>
    } else if (IS_USER_HEAP(addr)) {
    802042bc:	fe843703          	ld	a4,-24(s0)
    802042c0:	004007b7          	lui	a5,0x400
    802042c4:	04f76463          	bltu	a4,a5,8020430c <check_user_addr+0x100>
    802042c8:	fe843703          	ld	a4,-24(s0)
    802042cc:	ddfff7b7          	lui	a5,0xddfff
    802042d0:	07b6                	slli	a5,a5,0xd
    802042d2:	83e5                	srli	a5,a5,0x19
    802042d4:	02e7ec63          	bltu	a5,a4,8020430c <check_user_addr+0x100>
        if (!IS_USER_HEAP(addr + size - 1))
    802042d8:	fe843703          	ld	a4,-24(s0)
    802042dc:	fe043783          	ld	a5,-32(s0)
    802042e0:	97ba                	add	a5,a5,a4
    802042e2:	fff78713          	addi	a4,a5,-1 # ffffffffddffefff <_bss_end+0xffffffff5ddb76df>
    802042e6:	004007b7          	lui	a5,0x400
    802042ea:	00f76f63          	bltu	a4,a5,80204308 <check_user_addr+0xfc>
    802042ee:	fe843703          	ld	a4,-24(s0)
    802042f2:	fe043783          	ld	a5,-32(s0)
    802042f6:	97ba                	add	a5,a5,a4
    802042f8:	fff78713          	addi	a4,a5,-1 # 3fffff <_entry-0x7fe00001>
    802042fc:	ddfff7b7          	lui	a5,0xddfff
    80204300:	07b6                	slli	a5,a5,0xd
    80204302:	83e5                	srli	a5,a5,0x19
    80204304:	02e7f963          	bgeu	a5,a4,80204336 <check_user_addr+0x12a>
            return -1;  // 跨越堆边界
    80204308:	57fd                	li	a5,-1
    8020430a:	a805                	j	8020433a <check_user_addr+0x12e>
    } else if (addr < USER_HEAP_START) {
    8020430c:	fe843703          	ld	a4,-24(s0)
    80204310:	004007b7          	lui	a5,0x400
    80204314:	00f77d63          	bgeu	a4,a5,8020432e <check_user_addr+0x122>
        if (addr + size > USER_HEAP_START)
    80204318:	fe843703          	ld	a4,-24(s0)
    8020431c:	fe043783          	ld	a5,-32(s0)
    80204320:	973e                	add	a4,a4,a5
    80204322:	004007b7          	lui	a5,0x400
    80204326:	00e7f963          	bgeu	a5,a4,80204338 <check_user_addr+0x12c>
            return -1;  // 跨越代码/数据段边界
    8020432a:	57fd                	li	a5,-1
    8020432c:	a039                	j	8020433a <check_user_addr+0x12e>
        return -1;  // 在未定义区域
    8020432e:	57fd                	li	a5,-1
    80204330:	a029                	j	8020433a <check_user_addr+0x12e>
        if (!IS_USER_STACK(addr + size - 1))
    80204332:	0001                	nop
    80204334:	a011                	j	80204338 <check_user_addr+0x12c>
        if (!IS_USER_HEAP(addr + size - 1))
    80204336:	0001                	nop
    return 0;  // 地址合法
    80204338:	4781                	li	a5,0
}
    8020433a:	853e                	mv	a0,a5
    8020433c:	7422                	ld	s0,40(sp)
    8020433e:	6145                	addi	sp,sp,48
    80204340:	8082                	ret

0000000080204342 <handle_syscall>:
void handle_syscall(struct trapframe *tf, struct trap_info *info) {
    80204342:	7155                	addi	sp,sp,-208
    80204344:	e586                	sd	ra,200(sp)
    80204346:	e1a2                	sd	s0,192(sp)
    80204348:	0980                	addi	s0,sp,208
    8020434a:	f2a43c23          	sd	a0,-200(s0)
    8020434e:	f2b43823          	sd	a1,-208(s0)
	switch (tf->a7) {
    80204352:	f3843783          	ld	a5,-200(s0)
    80204356:	73fc                	ld	a5,224(a5)
    80204358:	6705                	lui	a4,0x1
    8020435a:	177d                	addi	a4,a4,-1 # fff <_entry-0x801ff001>
    8020435c:	28e78563          	beq	a5,a4,802045e6 <handle_syscall+0x2a4>
    80204360:	6705                	lui	a4,0x1
    80204362:	40e7f063          	bgeu	a5,a4,80204762 <handle_syscall+0x420>
    80204366:	0de00713          	li	a4,222
    8020436a:	20e78c63          	beq	a5,a4,80204582 <handle_syscall+0x240>
    8020436e:	0de00713          	li	a4,222
    80204372:	3ef76863          	bltu	a4,a5,80204762 <handle_syscall+0x420>
    80204376:	0dd00713          	li	a4,221
    8020437a:	18e78963          	beq	a5,a4,8020450c <handle_syscall+0x1ca>
    8020437e:	0dd00713          	li	a4,221
    80204382:	3ef76063          	bltu	a4,a5,80204762 <handle_syscall+0x420>
    80204386:	0dc00713          	li	a4,220
    8020438a:	14e78963          	beq	a5,a4,802044dc <handle_syscall+0x19a>
    8020438e:	0dc00713          	li	a4,220
    80204392:	3cf76863          	bltu	a4,a5,80204762 <handle_syscall+0x420>
    80204396:	0ad00713          	li	a4,173
    8020439a:	20e78863          	beq	a5,a4,802045aa <handle_syscall+0x268>
    8020439e:	0ad00713          	li	a4,173
    802043a2:	3cf76063          	bltu	a4,a5,80204762 <handle_syscall+0x420>
    802043a6:	0ac00713          	li	a4,172
    802043aa:	1ee78563          	beq	a5,a4,80204594 <handle_syscall+0x252>
    802043ae:	0ac00713          	li	a4,172
    802043b2:	3af76863          	bltu	a4,a5,80204762 <handle_syscall+0x420>
    802043b6:	08100713          	li	a4,129
    802043ba:	0ee78363          	beq	a5,a4,802044a0 <handle_syscall+0x15e>
    802043be:	08100713          	li	a4,129
    802043c2:	3af76063          	bltu	a4,a5,80204762 <handle_syscall+0x420>
    802043c6:	02a00713          	li	a4,42
    802043ca:	02f76863          	bltu	a4,a5,802043fa <handle_syscall+0xb8>
    802043ce:	38078a63          	beqz	a5,80204762 <handle_syscall+0x420>
    802043d2:	02a00713          	li	a4,42
    802043d6:	38f76663          	bltu	a4,a5,80204762 <handle_syscall+0x420>
    802043da:	00279713          	slli	a4,a5,0x2
    802043de:	0001c797          	auipc	a5,0x1c
    802043e2:	e4278793          	addi	a5,a5,-446 # 80220220 <user_test_table+0x4f8>
    802043e6:	97ba                	add	a5,a5,a4
    802043e8:	439c                	lw	a5,0(a5)
    802043ea:	0007871b          	sext.w	a4,a5
    802043ee:	0001c797          	auipc	a5,0x1c
    802043f2:	e3278793          	addi	a5,a5,-462 # 80220220 <user_test_table+0x4f8>
    802043f6:	97ba                	add	a5,a5,a4
    802043f8:	8782                	jr	a5
    802043fa:	05d00713          	li	a4,93
    802043fe:	06e78b63          	beq	a5,a4,80204474 <handle_syscall+0x132>
    80204402:	a685                	j	80204762 <handle_syscall+0x420>
			printf("[syscall] print int: %ld\n", tf->a0);
    80204404:	f3843783          	ld	a5,-200(s0)
    80204408:	77dc                	ld	a5,168(a5)
    8020440a:	85be                	mv	a1,a5
    8020440c:	0001c517          	auipc	a0,0x1c
    80204410:	ca450513          	addi	a0,a0,-860 # 802200b0 <user_test_table+0x388>
    80204414:	ffffd097          	auipc	ra,0xffffd
    80204418:	97a080e7          	jalr	-1670(ra) # 80200d8e <printf>
			break;
    8020441c:	a6a5                	j	80204784 <handle_syscall+0x442>
			if (copyinstr(buf, myproc()->pagetable, tf->a0, sizeof(buf)) < 0) {
    8020441e:	00001097          	auipc	ra,0x1
    80204422:	c22080e7          	jalr	-990(ra) # 80205040 <myproc>
    80204426:	87aa                	mv	a5,a0
    80204428:	7fd8                	ld	a4,184(a5)
    8020442a:	f3843783          	ld	a5,-200(s0)
    8020442e:	77d0                	ld	a2,168(a5)
    80204430:	f4040793          	addi	a5,s0,-192
    80204434:	08000693          	li	a3,128
    80204438:	85ba                	mv	a1,a4
    8020443a:	853e                	mv	a0,a5
    8020443c:	00000097          	auipc	ra,0x0
    80204440:	d36080e7          	jalr	-714(ra) # 80204172 <copyinstr>
    80204444:	87aa                	mv	a5,a0
    80204446:	0007db63          	bgez	a5,8020445c <handle_syscall+0x11a>
				printf("[syscall] invalid string\n");
    8020444a:	0001c517          	auipc	a0,0x1c
    8020444e:	c8650513          	addi	a0,a0,-890 # 802200d0 <user_test_table+0x3a8>
    80204452:	ffffd097          	auipc	ra,0xffffd
    80204456:	93c080e7          	jalr	-1732(ra) # 80200d8e <printf>
				break;
    8020445a:	a62d                	j	80204784 <handle_syscall+0x442>
			printf("[syscall] print str: %s\n", buf);
    8020445c:	f4040793          	addi	a5,s0,-192
    80204460:	85be                	mv	a1,a5
    80204462:	0001c517          	auipc	a0,0x1c
    80204466:	c8e50513          	addi	a0,a0,-882 # 802200f0 <user_test_table+0x3c8>
    8020446a:	ffffd097          	auipc	ra,0xffffd
    8020446e:	924080e7          	jalr	-1756(ra) # 80200d8e <printf>
			break;
    80204472:	ae09                	j	80204784 <handle_syscall+0x442>
			printf("[syscall] exit(%ld)\n", tf->a0);
    80204474:	f3843783          	ld	a5,-200(s0)
    80204478:	77dc                	ld	a5,168(a5)
    8020447a:	85be                	mv	a1,a5
    8020447c:	0001c517          	auipc	a0,0x1c
    80204480:	c9450513          	addi	a0,a0,-876 # 80220110 <user_test_table+0x3e8>
    80204484:	ffffd097          	auipc	ra,0xffffd
    80204488:	90a080e7          	jalr	-1782(ra) # 80200d8e <printf>
			exit_proc((int)tf->a0);
    8020448c:	f3843783          	ld	a5,-200(s0)
    80204490:	77dc                	ld	a5,168(a5)
    80204492:	2781                	sext.w	a5,a5
    80204494:	853e                	mv	a0,a5
    80204496:	00002097          	auipc	ra,0x2
    8020449a:	a66080e7          	jalr	-1434(ra) # 80205efc <exit_proc>
			break;
    8020449e:	a4dd                	j	80204784 <handle_syscall+0x442>
			if (myproc()->pid == tf->a0){
    802044a0:	00001097          	auipc	ra,0x1
    802044a4:	ba0080e7          	jalr	-1120(ra) # 80205040 <myproc>
    802044a8:	87aa                	mv	a5,a0
    802044aa:	43dc                	lw	a5,4(a5)
    802044ac:	873e                	mv	a4,a5
    802044ae:	f3843783          	ld	a5,-200(s0)
    802044b2:	77dc                	ld	a5,168(a5)
    802044b4:	00f71a63          	bne	a4,a5,802044c8 <handle_syscall+0x186>
				warning("[syscall] will kill itself!!!\n");
    802044b8:	0001c517          	auipc	a0,0x1c
    802044bc:	c7050513          	addi	a0,a0,-912 # 80220128 <user_test_table+0x400>
    802044c0:	ffffd097          	auipc	ra,0xffffd
    802044c4:	34e080e7          	jalr	846(ra) # 8020180e <warning>
			kill_proc(tf->a0);
    802044c8:	f3843783          	ld	a5,-200(s0)
    802044cc:	77dc                	ld	a5,168(a5)
    802044ce:	2781                	sext.w	a5,a5
    802044d0:	853e                	mv	a0,a5
    802044d2:	00002097          	auipc	ra,0x2
    802044d6:	9c6080e7          	jalr	-1594(ra) # 80205e98 <kill_proc>
			break;
    802044da:	a46d                	j	80204784 <handle_syscall+0x442>
			int child_pid = fork_proc();
    802044dc:	00001097          	auipc	ra,0x1
    802044e0:	556080e7          	jalr	1366(ra) # 80205a32 <fork_proc>
    802044e4:	87aa                	mv	a5,a0
    802044e6:	fcf42e23          	sw	a5,-36(s0)
			tf->a0 = child_pid;
    802044ea:	fdc42703          	lw	a4,-36(s0)
    802044ee:	f3843783          	ld	a5,-200(s0)
    802044f2:	f7d8                	sd	a4,168(a5)
			printf("[syscall] fork -> %d\n", child_pid);
    802044f4:	fdc42783          	lw	a5,-36(s0)
    802044f8:	85be                	mv	a1,a5
    802044fa:	0001c517          	auipc	a0,0x1c
    802044fe:	c4e50513          	addi	a0,a0,-946 # 80220148 <user_test_table+0x420>
    80204502:	ffffd097          	auipc	ra,0xffffd
    80204506:	88c080e7          	jalr	-1908(ra) # 80200d8e <printf>
			break;
    8020450a:	acad                	j	80204784 <handle_syscall+0x442>
				uint64 uaddr = tf->a0;
    8020450c:	f3843783          	ld	a5,-200(s0)
    80204510:	77dc                	ld	a5,168(a5)
    80204512:	fef43023          	sd	a5,-32(s0)
				int kstatus = 0;
    80204516:	fc042023          	sw	zero,-64(s0)
				int pid = wait_proc(uaddr ? &kstatus : NULL);  // 在内核里等待并得到退出码
    8020451a:	fe043783          	ld	a5,-32(s0)
    8020451e:	c781                	beqz	a5,80204526 <handle_syscall+0x1e4>
    80204520:	fc040793          	addi	a5,s0,-64
    80204524:	a011                	j	80204528 <handle_syscall+0x1e6>
    80204526:	4781                	li	a5,0
    80204528:	853e                	mv	a0,a5
    8020452a:	00002097          	auipc	ra,0x2
    8020452e:	a9c080e7          	jalr	-1380(ra) # 80205fc6 <wait_proc>
    80204532:	87aa                	mv	a5,a0
    80204534:	fef42623          	sw	a5,-20(s0)
				if (pid >= 0 && uaddr) {
    80204538:	fec42783          	lw	a5,-20(s0)
    8020453c:	2781                	sext.w	a5,a5
    8020453e:	0207cc63          	bltz	a5,80204576 <handle_syscall+0x234>
    80204542:	fe043783          	ld	a5,-32(s0)
    80204546:	cb85                	beqz	a5,80204576 <handle_syscall+0x234>
					if (copyout(myproc()->pagetable, uaddr, (char *)&kstatus, sizeof(kstatus)) < 0) {
    80204548:	00001097          	auipc	ra,0x1
    8020454c:	af8080e7          	jalr	-1288(ra) # 80205040 <myproc>
    80204550:	87aa                	mv	a5,a0
    80204552:	7fdc                	ld	a5,184(a5)
    80204554:	fc040713          	addi	a4,s0,-64
    80204558:	4691                	li	a3,4
    8020455a:	863a                	mv	a2,a4
    8020455c:	fe043583          	ld	a1,-32(s0)
    80204560:	853e                	mv	a0,a5
    80204562:	00000097          	auipc	ra,0x0
    80204566:	b94080e7          	jalr	-1132(ra) # 802040f6 <copyout>
    8020456a:	87aa                	mv	a5,a0
    8020456c:	0007d563          	bgez	a5,80204576 <handle_syscall+0x234>
						pid = -1; // 用户空间地址不可写，视为失败
    80204570:	57fd                	li	a5,-1
    80204572:	fef42623          	sw	a5,-20(s0)
				tf->a0 = pid;
    80204576:	fec42703          	lw	a4,-20(s0)
    8020457a:	f3843783          	ld	a5,-200(s0)
    8020457e:	f7d8                	sd	a4,168(a5)
				break;
    80204580:	a411                	j	80204784 <handle_syscall+0x442>
			tf->a0 =0;
    80204582:	f3843783          	ld	a5,-200(s0)
    80204586:	0a07b423          	sd	zero,168(a5)
			yield();
    8020458a:	00001097          	auipc	ra,0x1
    8020458e:	732080e7          	jalr	1842(ra) # 80205cbc <yield>
			break;
    80204592:	aacd                	j	80204784 <handle_syscall+0x442>
			tf->a0 = myproc()->pid;
    80204594:	00001097          	auipc	ra,0x1
    80204598:	aac080e7          	jalr	-1364(ra) # 80205040 <myproc>
    8020459c:	87aa                	mv	a5,a0
    8020459e:	43dc                	lw	a5,4(a5)
    802045a0:	873e                	mv	a4,a5
    802045a2:	f3843783          	ld	a5,-200(s0)
    802045a6:	f7d8                	sd	a4,168(a5)
			break;
    802045a8:	aaf1                	j	80204784 <handle_syscall+0x442>
			tf->a0 = myproc()->parent ? myproc()->parent->pid : 0;
    802045aa:	00001097          	auipc	ra,0x1
    802045ae:	a96080e7          	jalr	-1386(ra) # 80205040 <myproc>
    802045b2:	87aa                	mv	a5,a0
    802045b4:	6fdc                	ld	a5,152(a5)
    802045b6:	cb91                	beqz	a5,802045ca <handle_syscall+0x288>
    802045b8:	00001097          	auipc	ra,0x1
    802045bc:	a88080e7          	jalr	-1400(ra) # 80205040 <myproc>
    802045c0:	87aa                	mv	a5,a0
    802045c2:	6fdc                	ld	a5,152(a5)
    802045c4:	43dc                	lw	a5,4(a5)
    802045c6:	873e                	mv	a4,a5
    802045c8:	a011                	j	802045cc <handle_syscall+0x28a>
    802045ca:	4701                	li	a4,0
    802045cc:	f3843783          	ld	a5,-200(s0)
    802045d0:	f7d8                	sd	a4,168(a5)
			break;
    802045d2:	aa4d                	j	80204784 <handle_syscall+0x442>
			tf->a0 = get_time();
    802045d4:	00002097          	auipc	ra,0x2
    802045d8:	19e080e7          	jalr	414(ra) # 80206772 <get_time>
    802045dc:	872a                	mv	a4,a0
    802045de:	f3843783          	ld	a5,-200(s0)
    802045e2:	f7d8                	sd	a4,168(a5)
			break;
    802045e4:	a245                	j	80204784 <handle_syscall+0x442>
			tf->a0 = 0;
    802045e6:	f3843783          	ld	a5,-200(s0)
    802045ea:	0a07b423          	sd	zero,168(a5)
			printf("[syscall] step enabled but do nothing\n");
    802045ee:	0001c517          	auipc	a0,0x1c
    802045f2:	b7250513          	addi	a0,a0,-1166 # 80220160 <user_test_table+0x438>
    802045f6:	ffffc097          	auipc	ra,0xffffc
    802045fa:	798080e7          	jalr	1944(ra) # 80200d8e <printf>
			break;
    802045fe:	a259                	j	80204784 <handle_syscall+0x442>
		int fd = tf->a0;          // 文件描述符
    80204600:	f3843783          	ld	a5,-200(s0)
    80204604:	77dc                	ld	a5,168(a5)
    80204606:	fcf42c23          	sw	a5,-40(s0)
		if (fd != 1 && fd != 2) {
    8020460a:	fd842783          	lw	a5,-40(s0)
    8020460e:	0007871b          	sext.w	a4,a5
    80204612:	4785                	li	a5,1
    80204614:	00f70e63          	beq	a4,a5,80204630 <handle_syscall+0x2ee>
    80204618:	fd842783          	lw	a5,-40(s0)
    8020461c:	0007871b          	sext.w	a4,a5
    80204620:	4789                	li	a5,2
    80204622:	00f70763          	beq	a4,a5,80204630 <handle_syscall+0x2ee>
			tf->a0 = -1;
    80204626:	f3843783          	ld	a5,-200(s0)
    8020462a:	577d                	li	a4,-1
    8020462c:	f7d8                	sd	a4,168(a5)
			break;
    8020462e:	aa99                	j	80204784 <handle_syscall+0x442>
		if (check_user_addr(tf->a1, tf->a2, 0) < 0) {
    80204630:	f3843783          	ld	a5,-200(s0)
    80204634:	7bd8                	ld	a4,176(a5)
    80204636:	f3843783          	ld	a5,-200(s0)
    8020463a:	7fdc                	ld	a5,184(a5)
    8020463c:	4601                	li	a2,0
    8020463e:	85be                	mv	a1,a5
    80204640:	853a                	mv	a0,a4
    80204642:	00000097          	auipc	ra,0x0
    80204646:	bca080e7          	jalr	-1078(ra) # 8020420c <check_user_addr>
    8020464a:	87aa                	mv	a5,a0
    8020464c:	0007df63          	bgez	a5,8020466a <handle_syscall+0x328>
			printf("[syscall] invalid write buffer address\n");
    80204650:	0001c517          	auipc	a0,0x1c
    80204654:	b3850513          	addi	a0,a0,-1224 # 80220188 <user_test_table+0x460>
    80204658:	ffffc097          	auipc	ra,0xffffc
    8020465c:	736080e7          	jalr	1846(ra) # 80200d8e <printf>
			tf->a0 = -1;
    80204660:	f3843783          	ld	a5,-200(s0)
    80204664:	577d                	li	a4,-1
    80204666:	f7d8                	sd	a4,168(a5)
			break;
    80204668:	aa31                	j	80204784 <handle_syscall+0x442>
		if (copyinstr(buf, myproc()->pagetable, tf->a1, sizeof(buf)) < 0) {
    8020466a:	00001097          	auipc	ra,0x1
    8020466e:	9d6080e7          	jalr	-1578(ra) # 80205040 <myproc>
    80204672:	87aa                	mv	a5,a0
    80204674:	7fd8                	ld	a4,184(a5)
    80204676:	f3843783          	ld	a5,-200(s0)
    8020467a:	7bd0                	ld	a2,176(a5)
    8020467c:	f4040793          	addi	a5,s0,-192
    80204680:	08000693          	li	a3,128
    80204684:	85ba                	mv	a1,a4
    80204686:	853e                	mv	a0,a5
    80204688:	00000097          	auipc	ra,0x0
    8020468c:	aea080e7          	jalr	-1302(ra) # 80204172 <copyinstr>
    80204690:	87aa                	mv	a5,a0
    80204692:	0007df63          	bgez	a5,802046b0 <handle_syscall+0x36e>
			printf("[syscall] invalid write buffer\n");
    80204696:	0001c517          	auipc	a0,0x1c
    8020469a:	b1a50513          	addi	a0,a0,-1254 # 802201b0 <user_test_table+0x488>
    8020469e:	ffffc097          	auipc	ra,0xffffc
    802046a2:	6f0080e7          	jalr	1776(ra) # 80200d8e <printf>
			tf->a0 = -1;
    802046a6:	f3843783          	ld	a5,-200(s0)
    802046aa:	577d                	li	a4,-1
    802046ac:	f7d8                	sd	a4,168(a5)
			break;
    802046ae:	a8d9                	j	80204784 <handle_syscall+0x442>
		printf("%s", buf);
    802046b0:	f4040793          	addi	a5,s0,-192
    802046b4:	85be                	mv	a1,a5
    802046b6:	0001c517          	auipc	a0,0x1c
    802046ba:	b1a50513          	addi	a0,a0,-1254 # 802201d0 <user_test_table+0x4a8>
    802046be:	ffffc097          	auipc	ra,0xffffc
    802046c2:	6d0080e7          	jalr	1744(ra) # 80200d8e <printf>
		tf->a0 = strlen(buf);  // 返回写入的字节数
    802046c6:	f4040793          	addi	a5,s0,-192
    802046ca:	853e                	mv	a0,a5
    802046cc:	00002097          	auipc	ra,0x2
    802046d0:	cc0080e7          	jalr	-832(ra) # 8020638c <strlen>
    802046d4:	87aa                	mv	a5,a0
    802046d6:	873e                	mv	a4,a5
    802046d8:	f3843783          	ld	a5,-200(s0)
    802046dc:	f7d8                	sd	a4,168(a5)
		break;
    802046de:	a05d                	j	80204784 <handle_syscall+0x442>
		int fd = tf->a0;          // 文件描述符
    802046e0:	f3843783          	ld	a5,-200(s0)
    802046e4:	77dc                	ld	a5,168(a5)
    802046e6:	fcf42a23          	sw	a5,-44(s0)
		uint64 buf = tf->a1;      // 用户缓冲区地址
    802046ea:	f3843783          	ld	a5,-200(s0)
    802046ee:	7bdc                	ld	a5,176(a5)
    802046f0:	fcf43423          	sd	a5,-56(s0)
		int n = tf->a2;           // 要读取的字节数
    802046f4:	f3843783          	ld	a5,-200(s0)
    802046f8:	7fdc                	ld	a5,184(a5)
    802046fa:	fcf42223          	sw	a5,-60(s0)
		if (fd != 0) {
    802046fe:	fd442783          	lw	a5,-44(s0)
    80204702:	2781                	sext.w	a5,a5
    80204704:	c791                	beqz	a5,80204710 <handle_syscall+0x3ce>
			tf->a0 = -1;
    80204706:	f3843783          	ld	a5,-200(s0)
    8020470a:	577d                	li	a4,-1
    8020470c:	f7d8                	sd	a4,168(a5)
			break;
    8020470e:	a89d                	j	80204784 <handle_syscall+0x442>
		if (check_user_addr(buf, n, 1) < 0) {  // 1表示写入访问
    80204710:	fc442783          	lw	a5,-60(s0)
    80204714:	4605                	li	a2,1
    80204716:	85be                	mv	a1,a5
    80204718:	fc843503          	ld	a0,-56(s0)
    8020471c:	00000097          	auipc	ra,0x0
    80204720:	af0080e7          	jalr	-1296(ra) # 8020420c <check_user_addr>
    80204724:	87aa                	mv	a5,a0
    80204726:	0007df63          	bgez	a5,80204744 <handle_syscall+0x402>
			printf("[syscall] invalid read buffer address\n");
    8020472a:	0001c517          	auipc	a0,0x1c
    8020472e:	aae50513          	addi	a0,a0,-1362 # 802201d8 <user_test_table+0x4b0>
    80204732:	ffffc097          	auipc	ra,0xffffc
    80204736:	65c080e7          	jalr	1628(ra) # 80200d8e <printf>
			tf->a0 = -1;
    8020473a:	f3843783          	ld	a5,-200(s0)
    8020473e:	577d                	li	a4,-1
    80204740:	f7d8                	sd	a4,168(a5)
			break;
    80204742:	a089                	j	80204784 <handle_syscall+0x442>
		tf->a0 = -1;
    80204744:	f3843783          	ld	a5,-200(s0)
    80204748:	577d                	li	a4,-1
    8020474a:	f7d8                	sd	a4,168(a5)
		break;
    8020474c:	a825                	j	80204784 <handle_syscall+0x442>
            tf->a0 = -1;
    8020474e:	f3843783          	ld	a5,-200(s0)
    80204752:	577d                	li	a4,-1
    80204754:	f7d8                	sd	a4,168(a5)
            break;
    80204756:	a03d                	j	80204784 <handle_syscall+0x442>
			tf->a0 = -1;
    80204758:	f3843783          	ld	a5,-200(s0)
    8020475c:	577d                	li	a4,-1
    8020475e:	f7d8                	sd	a4,168(a5)
			break;
    80204760:	a015                	j	80204784 <handle_syscall+0x442>
			printf("[syscall] unknown syscall: %ld\n", tf->a7);
    80204762:	f3843783          	ld	a5,-200(s0)
    80204766:	73fc                	ld	a5,224(a5)
    80204768:	85be                	mv	a1,a5
    8020476a:	0001c517          	auipc	a0,0x1c
    8020476e:	a9650513          	addi	a0,a0,-1386 # 80220200 <user_test_table+0x4d8>
    80204772:	ffffc097          	auipc	ra,0xffffc
    80204776:	61c080e7          	jalr	1564(ra) # 80200d8e <printf>
			tf->a0 = -1;
    8020477a:	f3843783          	ld	a5,-200(s0)
    8020477e:	577d                	li	a4,-1
    80204780:	f7d8                	sd	a4,168(a5)
			break;
    80204782:	0001                	nop
	set_sepc(tf, info->sepc + 4);
    80204784:	f3043783          	ld	a5,-208(s0)
    80204788:	639c                	ld	a5,0(a5)
    8020478a:	0791                	addi	a5,a5,4
    8020478c:	85be                	mv	a1,a5
    8020478e:	f3843503          	ld	a0,-200(s0)
    80204792:	fffff097          	auipc	ra,0xfffff
    80204796:	ff6080e7          	jalr	-10(ra) # 80203788 <set_sepc>
}
    8020479a:	0001                	nop
    8020479c:	60ae                	ld	ra,200(sp)
    8020479e:	640e                	ld	s0,192(sp)
    802047a0:	6169                	addi	sp,sp,208
    802047a2:	8082                	ret

00000000802047a4 <handle_instruction_page_fault>:
void handle_instruction_page_fault(struct trapframe *tf, struct trap_info *info) {
    802047a4:	1101                	addi	sp,sp,-32
    802047a6:	ec06                	sd	ra,24(sp)
    802047a8:	e822                	sd	s0,16(sp)
    802047aa:	1000                	addi	s0,sp,32
    802047ac:	fea43423          	sd	a0,-24(s0)
    802047b0:	feb43023          	sd	a1,-32(s0)
    printf("Instruction page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    802047b4:	fe043783          	ld	a5,-32(s0)
    802047b8:	6f98                	ld	a4,24(a5)
    802047ba:	fe043783          	ld	a5,-32(s0)
    802047be:	639c                	ld	a5,0(a5)
    802047c0:	863e                	mv	a2,a5
    802047c2:	85ba                	mv	a1,a4
    802047c4:	0001c517          	auipc	a0,0x1c
    802047c8:	b0c50513          	addi	a0,a0,-1268 # 802202d0 <user_test_table+0x5a8>
    802047cc:	ffffc097          	auipc	ra,0xffffc
    802047d0:	5c2080e7          	jalr	1474(ra) # 80200d8e <printf>
    if (handle_page_fault(info->stval, 1)) {  // 1表示指令页
    802047d4:	fe043783          	ld	a5,-32(s0)
    802047d8:	6f9c                	ld	a5,24(a5)
    802047da:	4585                	li	a1,1
    802047dc:	853e                	mv	a0,a5
    802047de:	ffffe097          	auipc	ra,0xffffe
    802047e2:	29e080e7          	jalr	670(ra) # 80202a7c <handle_page_fault>
    802047e6:	87aa                	mv	a5,a0
    802047e8:	eb91                	bnez	a5,802047fc <handle_instruction_page_fault+0x58>
    panic("Unhandled instruction page fault");
    802047ea:	0001c517          	auipc	a0,0x1c
    802047ee:	b1650513          	addi	a0,a0,-1258 # 80220300 <user_test_table+0x5d8>
    802047f2:	ffffd097          	auipc	ra,0xffffd
    802047f6:	fe8080e7          	jalr	-24(ra) # 802017da <panic>
    802047fa:	a011                	j	802047fe <handle_instruction_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    802047fc:	0001                	nop
}
    802047fe:	60e2                	ld	ra,24(sp)
    80204800:	6442                	ld	s0,16(sp)
    80204802:	6105                	addi	sp,sp,32
    80204804:	8082                	ret

0000000080204806 <handle_load_page_fault>:
void handle_load_page_fault(struct trapframe *tf, struct trap_info *info) {
    80204806:	1101                	addi	sp,sp,-32
    80204808:	ec06                	sd	ra,24(sp)
    8020480a:	e822                	sd	s0,16(sp)
    8020480c:	1000                	addi	s0,sp,32
    8020480e:	fea43423          	sd	a0,-24(s0)
    80204812:	feb43023          	sd	a1,-32(s0)
    printf("Load page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    80204816:	fe043783          	ld	a5,-32(s0)
    8020481a:	6f98                	ld	a4,24(a5)
    8020481c:	fe043783          	ld	a5,-32(s0)
    80204820:	639c                	ld	a5,0(a5)
    80204822:	863e                	mv	a2,a5
    80204824:	85ba                	mv	a1,a4
    80204826:	0001c517          	auipc	a0,0x1c
    8020482a:	b0250513          	addi	a0,a0,-1278 # 80220328 <user_test_table+0x600>
    8020482e:	ffffc097          	auipc	ra,0xffffc
    80204832:	560080e7          	jalr	1376(ra) # 80200d8e <printf>
    if (handle_page_fault(info->stval, 2)) {  // 2表示读数据页
    80204836:	fe043783          	ld	a5,-32(s0)
    8020483a:	6f9c                	ld	a5,24(a5)
    8020483c:	4589                	li	a1,2
    8020483e:	853e                	mv	a0,a5
    80204840:	ffffe097          	auipc	ra,0xffffe
    80204844:	23c080e7          	jalr	572(ra) # 80202a7c <handle_page_fault>
    80204848:	87aa                	mv	a5,a0
    8020484a:	eb91                	bnez	a5,8020485e <handle_load_page_fault+0x58>
    panic("Unhandled load page fault");
    8020484c:	0001c517          	auipc	a0,0x1c
    80204850:	b0c50513          	addi	a0,a0,-1268 # 80220358 <user_test_table+0x630>
    80204854:	ffffd097          	auipc	ra,0xffffd
    80204858:	f86080e7          	jalr	-122(ra) # 802017da <panic>
    8020485c:	a011                	j	80204860 <handle_load_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    8020485e:	0001                	nop
}
    80204860:	60e2                	ld	ra,24(sp)
    80204862:	6442                	ld	s0,16(sp)
    80204864:	6105                	addi	sp,sp,32
    80204866:	8082                	ret

0000000080204868 <handle_store_page_fault>:
void handle_store_page_fault(struct trapframe *tf, struct trap_info *info) {
    80204868:	1101                	addi	sp,sp,-32
    8020486a:	ec06                	sd	ra,24(sp)
    8020486c:	e822                	sd	s0,16(sp)
    8020486e:	1000                	addi	s0,sp,32
    80204870:	fea43423          	sd	a0,-24(s0)
    80204874:	feb43023          	sd	a1,-32(s0)
    printf("Store page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    80204878:	fe043783          	ld	a5,-32(s0)
    8020487c:	6f98                	ld	a4,24(a5)
    8020487e:	fe043783          	ld	a5,-32(s0)
    80204882:	639c                	ld	a5,0(a5)
    80204884:	863e                	mv	a2,a5
    80204886:	85ba                	mv	a1,a4
    80204888:	0001c517          	auipc	a0,0x1c
    8020488c:	af050513          	addi	a0,a0,-1296 # 80220378 <user_test_table+0x650>
    80204890:	ffffc097          	auipc	ra,0xffffc
    80204894:	4fe080e7          	jalr	1278(ra) # 80200d8e <printf>
    if (handle_page_fault(info->stval, 3)) {  // 3表示写数据页
    80204898:	fe043783          	ld	a5,-32(s0)
    8020489c:	6f9c                	ld	a5,24(a5)
    8020489e:	458d                	li	a1,3
    802048a0:	853e                	mv	a0,a5
    802048a2:	ffffe097          	auipc	ra,0xffffe
    802048a6:	1da080e7          	jalr	474(ra) # 80202a7c <handle_page_fault>
    802048aa:	87aa                	mv	a5,a0
    802048ac:	eb91                	bnez	a5,802048c0 <handle_store_page_fault+0x58>
    panic("Unhandled store page fault");
    802048ae:	0001c517          	auipc	a0,0x1c
    802048b2:	afa50513          	addi	a0,a0,-1286 # 802203a8 <user_test_table+0x680>
    802048b6:	ffffd097          	auipc	ra,0xffffd
    802048ba:	f24080e7          	jalr	-220(ra) # 802017da <panic>
    802048be:	a011                	j	802048c2 <handle_store_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    802048c0:	0001                	nop
}
    802048c2:	60e2                	ld	ra,24(sp)
    802048c4:	6442                	ld	s0,16(sp)
    802048c6:	6105                	addi	sp,sp,32
    802048c8:	8082                	ret

00000000802048ca <usertrap>:
void usertrap(void) {
    802048ca:	7159                	addi	sp,sp,-112
    802048cc:	f486                	sd	ra,104(sp)
    802048ce:	f0a2                	sd	s0,96(sp)
    802048d0:	1880                	addi	s0,sp,112
    struct proc *p = myproc();
    802048d2:	00000097          	auipc	ra,0x0
    802048d6:	76e080e7          	jalr	1902(ra) # 80205040 <myproc>
    802048da:	fea43423          	sd	a0,-24(s0)
    struct trapframe *tf = p->trapframe;
    802048de:	fe843783          	ld	a5,-24(s0)
    802048e2:	63fc                	ld	a5,192(a5)
    802048e4:	fef43023          	sd	a5,-32(s0)
    uint64 scause = r_scause();
    802048e8:	fffff097          	auipc	ra,0xfffff
    802048ec:	e0e080e7          	jalr	-498(ra) # 802036f6 <r_scause>
    802048f0:	fca43c23          	sd	a0,-40(s0)
    uint64 stval  = r_stval();
    802048f4:	fffff097          	auipc	ra,0xfffff
    802048f8:	e36080e7          	jalr	-458(ra) # 8020372a <r_stval>
    802048fc:	fca43823          	sd	a0,-48(s0)
    uint64 sepc   = tf->epc;      // 已由 trampoline 保存
    80204900:	fe043783          	ld	a5,-32(s0)
    80204904:	7f9c                	ld	a5,56(a5)
    80204906:	fcf43423          	sd	a5,-56(s0)
    uint64 sstatus= tf->sstatus;  // 已由 trampoline 保存
    8020490a:	fe043783          	ld	a5,-32(s0)
    8020490e:	7b9c                	ld	a5,48(a5)
    80204910:	fcf43023          	sd	a5,-64(s0)
    uint64 code = scause & 0xff;
    80204914:	fd843783          	ld	a5,-40(s0)
    80204918:	0ff7f793          	zext.b	a5,a5
    8020491c:	faf43c23          	sd	a5,-72(s0)
    uint64 is_intr = (scause >> 63);
    80204920:	fd843783          	ld	a5,-40(s0)
    80204924:	93fd                	srli	a5,a5,0x3f
    80204926:	faf43823          	sd	a5,-80(s0)
    if (!is_intr && code == 8) { // 用户态 ecall
    8020492a:	fb043783          	ld	a5,-80(s0)
    8020492e:	e3a1                	bnez	a5,8020496e <usertrap+0xa4>
    80204930:	fb843703          	ld	a4,-72(s0)
    80204934:	47a1                	li	a5,8
    80204936:	02f71c63          	bne	a4,a5,8020496e <usertrap+0xa4>
        struct trap_info info = { .sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval };
    8020493a:	fc843783          	ld	a5,-56(s0)
    8020493e:	f8f43823          	sd	a5,-112(s0)
    80204942:	fc043783          	ld	a5,-64(s0)
    80204946:	f8f43c23          	sd	a5,-104(s0)
    8020494a:	fd843783          	ld	a5,-40(s0)
    8020494e:	faf43023          	sd	a5,-96(s0)
    80204952:	fd043783          	ld	a5,-48(s0)
    80204956:	faf43423          	sd	a5,-88(s0)
        handle_syscall(tf, &info);
    8020495a:	f9040793          	addi	a5,s0,-112
    8020495e:	85be                	mv	a1,a5
    80204960:	fe043503          	ld	a0,-32(s0)
    80204964:	00000097          	auipc	ra,0x0
    80204968:	9de080e7          	jalr	-1570(ra) # 80204342 <handle_syscall>
    if (!is_intr && code == 8) { // 用户态 ecall
    8020496c:	a869                	j	80204a06 <usertrap+0x13c>
    } else if (is_intr) {
    8020496e:	fb043783          	ld	a5,-80(s0)
    80204972:	c3ad                	beqz	a5,802049d4 <usertrap+0x10a>
        if (code == 5) {
    80204974:	fb843703          	ld	a4,-72(s0)
    80204978:	4795                	li	a5,5
    8020497a:	02f71663          	bne	a4,a5,802049a6 <usertrap+0xdc>
            timeintr();
    8020497e:	fffff097          	auipc	ra,0xfffff
    80204982:	c6c080e7          	jalr	-916(ra) # 802035ea <timeintr>
            sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    80204986:	fffff097          	auipc	ra,0xfffff
    8020498a:	c4a080e7          	jalr	-950(ra) # 802035d0 <sbi_get_time>
    8020498e:	872a                	mv	a4,a0
    80204990:	000f47b7          	lui	a5,0xf4
    80204994:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    80204998:	97ba                	add	a5,a5,a4
    8020499a:	853e                	mv	a0,a5
    8020499c:	fffff097          	auipc	ra,0xfffff
    802049a0:	c18080e7          	jalr	-1000(ra) # 802035b4 <sbi_set_time>
    802049a4:	a08d                	j	80204a06 <usertrap+0x13c>
        } else if (code == 9) {
    802049a6:	fb843703          	ld	a4,-72(s0)
    802049aa:	47a5                	li	a5,9
    802049ac:	00f71763          	bne	a4,a5,802049ba <usertrap+0xf0>
            handle_external_interrupt();
    802049b0:	fffff097          	auipc	ra,0xfffff
    802049b4:	f28080e7          	jalr	-216(ra) # 802038d8 <handle_external_interrupt>
    802049b8:	a0b9                	j	80204a06 <usertrap+0x13c>
            printf("[usertrap] unknown interrupt scause=%lx sepc=%lx\n", scause, sepc);
    802049ba:	fc843603          	ld	a2,-56(s0)
    802049be:	fd843583          	ld	a1,-40(s0)
    802049c2:	0001c517          	auipc	a0,0x1c
    802049c6:	a0650513          	addi	a0,a0,-1530 # 802203c8 <user_test_table+0x6a0>
    802049ca:	ffffc097          	auipc	ra,0xffffc
    802049ce:	3c4080e7          	jalr	964(ra) # 80200d8e <printf>
    802049d2:	a815                	j	80204a06 <usertrap+0x13c>
        struct trap_info info = { .sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval };
    802049d4:	fc843783          	ld	a5,-56(s0)
    802049d8:	f8f43823          	sd	a5,-112(s0)
    802049dc:	fc043783          	ld	a5,-64(s0)
    802049e0:	f8f43c23          	sd	a5,-104(s0)
    802049e4:	fd843783          	ld	a5,-40(s0)
    802049e8:	faf43023          	sd	a5,-96(s0)
    802049ec:	fd043783          	ld	a5,-48(s0)
    802049f0:	faf43423          	sd	a5,-88(s0)
        handle_exception(tf, &info);
    802049f4:	f9040793          	addi	a5,s0,-112
    802049f8:	85be                	mv	a1,a5
    802049fa:	fe043503          	ld	a0,-32(s0)
    802049fe:	fffff097          	auipc	ra,0xfffff
    80204a02:	18e080e7          	jalr	398(ra) # 80203b8c <handle_exception>
    usertrapret();
    80204a06:	00000097          	auipc	ra,0x0
    80204a0a:	012080e7          	jalr	18(ra) # 80204a18 <usertrapret>
}
    80204a0e:	0001                	nop
    80204a10:	70a6                	ld	ra,104(sp)
    80204a12:	7406                	ld	s0,96(sp)
    80204a14:	6165                	addi	sp,sp,112
    80204a16:	8082                	ret

0000000080204a18 <usertrapret>:
void usertrapret(void) {
    80204a18:	7179                	addi	sp,sp,-48
    80204a1a:	f406                	sd	ra,40(sp)
    80204a1c:	f022                	sd	s0,32(sp)
    80204a1e:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80204a20:	00000097          	auipc	ra,0x0
    80204a24:	620080e7          	jalr	1568(ra) # 80205040 <myproc>
    80204a28:	fea43423          	sd	a0,-24(s0)
    uint64 uservec_va = (uint64)TRAMPOLINE + ((uint64)uservec - (uint64)trampoline);
    80204a2c:	00000717          	auipc	a4,0x0
    80204a30:	35470713          	addi	a4,a4,852 # 80204d80 <trampoline>
    80204a34:	77fd                	lui	a5,0xfffff
    80204a36:	973e                	add	a4,a4,a5
    80204a38:	00000797          	auipc	a5,0x0
    80204a3c:	34878793          	addi	a5,a5,840 # 80204d80 <trampoline>
    80204a40:	40f707b3          	sub	a5,a4,a5
    80204a44:	fef43023          	sd	a5,-32(s0)
    w_stvec(uservec_va);
    80204a48:	fe043503          	ld	a0,-32(s0)
    80204a4c:	fffff097          	auipc	ra,0xfffff
    80204a50:	c90080e7          	jalr	-880(ra) # 802036dc <w_stvec>
    w_sscratch((uint64)TRAPFRAME);
    80204a54:	7579                	lui	a0,0xffffe
    80204a56:	fffff097          	auipc	ra,0xfffff
    80204a5a:	c2a080e7          	jalr	-982(ra) # 80203680 <w_sscratch>
    uint64 user_satp = MAKE_SATP(p->pagetable);
    80204a5e:	fe843783          	ld	a5,-24(s0)
    80204a62:	7fdc                	ld	a5,184(a5)
    80204a64:	00c7d713          	srli	a4,a5,0xc
    80204a68:	57fd                	li	a5,-1
    80204a6a:	17fe                	slli	a5,a5,0x3f
    80204a6c:	8fd9                	or	a5,a5,a4
    80204a6e:	fcf43c23          	sd	a5,-40(s0)
    uint64 userret_va = (uint64)TRAMPOLINE + ((uint64)userret - (uint64)trampoline);
    80204a72:	00000717          	auipc	a4,0x0
    80204a76:	3b470713          	addi	a4,a4,948 # 80204e26 <userret>
    80204a7a:	77fd                	lui	a5,0xfffff
    80204a7c:	973e                	add	a4,a4,a5
    80204a7e:	00000797          	auipc	a5,0x0
    80204a82:	30278793          	addi	a5,a5,770 # 80204d80 <trampoline>
    80204a86:	40f707b3          	sub	a5,a4,a5
    80204a8a:	fcf43823          	sd	a5,-48(s0)
    register uint64 a0 asm("a0") = (uint64)TRAPFRAME;
    80204a8e:	7579                	lui	a0,0xffffe
    register uint64 a1 asm("a1") = user_satp;
    80204a90:	fd843583          	ld	a1,-40(s0)
    register void (*tgt)(uint64, uint64) asm("t0") = (void *)userret_va;
    80204a94:	fd043783          	ld	a5,-48(s0)
    80204a98:	82be                	mv	t0,a5
    asm volatile("jr t0" :: "r"(a0), "r"(a1), "r"(tgt) : "memory");
    80204a9a:	8282                	jr	t0
}
    80204a9c:	0001                	nop
    80204a9e:	70a2                	ld	ra,40(sp)
    80204aa0:	7402                	ld	s0,32(sp)
    80204aa2:	6145                	addi	sp,sp,48
    80204aa4:	8082                	ret

0000000080204aa6 <write32>:
    80204aa6:	7179                	addi	sp,sp,-48
    80204aa8:	f406                	sd	ra,40(sp)
    80204aaa:	f022                	sd	s0,32(sp)
    80204aac:	1800                	addi	s0,sp,48
    80204aae:	fca43c23          	sd	a0,-40(s0)
    80204ab2:	87ae                	mv	a5,a1
    80204ab4:	fcf42a23          	sw	a5,-44(s0)
    80204ab8:	fd843783          	ld	a5,-40(s0)
    80204abc:	8b8d                	andi	a5,a5,3
    80204abe:	eb99                	bnez	a5,80204ad4 <write32+0x2e>
    80204ac0:	fd843783          	ld	a5,-40(s0)
    80204ac4:	fef43423          	sd	a5,-24(s0)
    80204ac8:	fe843783          	ld	a5,-24(s0)
    80204acc:	fd442703          	lw	a4,-44(s0)
    80204ad0:	c398                	sw	a4,0(a5)
    80204ad2:	a819                	j	80204ae8 <write32+0x42>
    80204ad4:	fd843583          	ld	a1,-40(s0)
    80204ad8:	0001e517          	auipc	a0,0x1e
    80204adc:	9d850513          	addi	a0,a0,-1576 # 802224b0 <user_test_table+0x78>
    80204ae0:	ffffc097          	auipc	ra,0xffffc
    80204ae4:	2ae080e7          	jalr	686(ra) # 80200d8e <printf>
    80204ae8:	0001                	nop
    80204aea:	70a2                	ld	ra,40(sp)
    80204aec:	7402                	ld	s0,32(sp)
    80204aee:	6145                	addi	sp,sp,48
    80204af0:	8082                	ret

0000000080204af2 <read32>:
    80204af2:	7179                	addi	sp,sp,-48
    80204af4:	f406                	sd	ra,40(sp)
    80204af6:	f022                	sd	s0,32(sp)
    80204af8:	1800                	addi	s0,sp,48
    80204afa:	fca43c23          	sd	a0,-40(s0)
    80204afe:	fd843783          	ld	a5,-40(s0)
    80204b02:	8b8d                	andi	a5,a5,3
    80204b04:	eb91                	bnez	a5,80204b18 <read32+0x26>
    80204b06:	fd843783          	ld	a5,-40(s0)
    80204b0a:	fef43423          	sd	a5,-24(s0)
    80204b0e:	fe843783          	ld	a5,-24(s0)
    80204b12:	439c                	lw	a5,0(a5)
    80204b14:	2781                	sext.w	a5,a5
    80204b16:	a821                	j	80204b2e <read32+0x3c>
    80204b18:	fd843583          	ld	a1,-40(s0)
    80204b1c:	0001e517          	auipc	a0,0x1e
    80204b20:	9c450513          	addi	a0,a0,-1596 # 802224e0 <user_test_table+0xa8>
    80204b24:	ffffc097          	auipc	ra,0xffffc
    80204b28:	26a080e7          	jalr	618(ra) # 80200d8e <printf>
    80204b2c:	4781                	li	a5,0
    80204b2e:	853e                	mv	a0,a5
    80204b30:	70a2                	ld	ra,40(sp)
    80204b32:	7402                	ld	s0,32(sp)
    80204b34:	6145                	addi	sp,sp,48
    80204b36:	8082                	ret

0000000080204b38 <plic_init>:
void plic_init(void) {
    80204b38:	1101                	addi	sp,sp,-32
    80204b3a:	ec06                	sd	ra,24(sp)
    80204b3c:	e822                	sd	s0,16(sp)
    80204b3e:	1000                	addi	s0,sp,32
    for (int i = 1; i <= 32; i++) {
    80204b40:	4785                	li	a5,1
    80204b42:	fef42623          	sw	a5,-20(s0)
    80204b46:	a805                	j	80204b76 <plic_init+0x3e>
        uint64 addr = PLIC + i * 4;
    80204b48:	fec42783          	lw	a5,-20(s0)
    80204b4c:	0027979b          	slliw	a5,a5,0x2
    80204b50:	2781                	sext.w	a5,a5
    80204b52:	873e                	mv	a4,a5
    80204b54:	0c0007b7          	lui	a5,0xc000
    80204b58:	97ba                	add	a5,a5,a4
    80204b5a:	fef43023          	sd	a5,-32(s0)
        write32(addr, 0);
    80204b5e:	4581                	li	a1,0
    80204b60:	fe043503          	ld	a0,-32(s0)
    80204b64:	00000097          	auipc	ra,0x0
    80204b68:	f42080e7          	jalr	-190(ra) # 80204aa6 <write32>
    for (int i = 1; i <= 32; i++) {
    80204b6c:	fec42783          	lw	a5,-20(s0)
    80204b70:	2785                	addiw	a5,a5,1 # c000001 <_entry-0x741fffff>
    80204b72:	fef42623          	sw	a5,-20(s0)
    80204b76:	fec42783          	lw	a5,-20(s0)
    80204b7a:	0007871b          	sext.w	a4,a5
    80204b7e:	02000793          	li	a5,32
    80204b82:	fce7d3e3          	bge	a5,a4,80204b48 <plic_init+0x10>
    write32(PLIC + UART0_IRQ * 4, 1);
    80204b86:	4585                	li	a1,1
    80204b88:	0c0007b7          	lui	a5,0xc000
    80204b8c:	02878513          	addi	a0,a5,40 # c000028 <_entry-0x741fffd8>
    80204b90:	00000097          	auipc	ra,0x0
    80204b94:	f16080e7          	jalr	-234(ra) # 80204aa6 <write32>
    write32(PLIC + VIRTIO0_IRQ * 4, 1);
    80204b98:	4585                	li	a1,1
    80204b9a:	0c0007b7          	lui	a5,0xc000
    80204b9e:	00478513          	addi	a0,a5,4 # c000004 <_entry-0x741ffffc>
    80204ba2:	00000097          	auipc	ra,0x0
    80204ba6:	f04080e7          	jalr	-252(ra) # 80204aa6 <write32>
    write32(PLIC_ENABLE, (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ));
    80204baa:	40200593          	li	a1,1026
    80204bae:	0c0027b7          	lui	a5,0xc002
    80204bb2:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204bb6:	00000097          	auipc	ra,0x0
    80204bba:	ef0080e7          	jalr	-272(ra) # 80204aa6 <write32>
    write32(PLIC_THRESHOLD, 0);
    80204bbe:	4581                	li	a1,0
    80204bc0:	0c201537          	lui	a0,0xc201
    80204bc4:	00000097          	auipc	ra,0x0
    80204bc8:	ee2080e7          	jalr	-286(ra) # 80204aa6 <write32>
}
    80204bcc:	0001                	nop
    80204bce:	60e2                	ld	ra,24(sp)
    80204bd0:	6442                	ld	s0,16(sp)
    80204bd2:	6105                	addi	sp,sp,32
    80204bd4:	8082                	ret

0000000080204bd6 <plic_enable>:
void plic_enable(int irq) {
    80204bd6:	7179                	addi	sp,sp,-48
    80204bd8:	f406                	sd	ra,40(sp)
    80204bda:	f022                	sd	s0,32(sp)
    80204bdc:	1800                	addi	s0,sp,48
    80204bde:	87aa                	mv	a5,a0
    80204be0:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    80204be4:	0c0027b7          	lui	a5,0xc002
    80204be8:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204bec:	00000097          	auipc	ra,0x0
    80204bf0:	f06080e7          	jalr	-250(ra) # 80204af2 <read32>
    80204bf4:	87aa                	mv	a5,a0
    80204bf6:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old | (1 << irq));
    80204bfa:	fdc42783          	lw	a5,-36(s0)
    80204bfe:	873e                	mv	a4,a5
    80204c00:	4785                	li	a5,1
    80204c02:	00e797bb          	sllw	a5,a5,a4
    80204c06:	2781                	sext.w	a5,a5
    80204c08:	2781                	sext.w	a5,a5
    80204c0a:	fec42703          	lw	a4,-20(s0)
    80204c0e:	8fd9                	or	a5,a5,a4
    80204c10:	2781                	sext.w	a5,a5
    80204c12:	85be                	mv	a1,a5
    80204c14:	0c0027b7          	lui	a5,0xc002
    80204c18:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204c1c:	00000097          	auipc	ra,0x0
    80204c20:	e8a080e7          	jalr	-374(ra) # 80204aa6 <write32>
}
    80204c24:	0001                	nop
    80204c26:	70a2                	ld	ra,40(sp)
    80204c28:	7402                	ld	s0,32(sp)
    80204c2a:	6145                	addi	sp,sp,48
    80204c2c:	8082                	ret

0000000080204c2e <plic_disable>:
void plic_disable(int irq) {
    80204c2e:	7179                	addi	sp,sp,-48
    80204c30:	f406                	sd	ra,40(sp)
    80204c32:	f022                	sd	s0,32(sp)
    80204c34:	1800                	addi	s0,sp,48
    80204c36:	87aa                	mv	a5,a0
    80204c38:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    80204c3c:	0c0027b7          	lui	a5,0xc002
    80204c40:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204c44:	00000097          	auipc	ra,0x0
    80204c48:	eae080e7          	jalr	-338(ra) # 80204af2 <read32>
    80204c4c:	87aa                	mv	a5,a0
    80204c4e:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old & ~(1 << irq));
    80204c52:	fdc42783          	lw	a5,-36(s0)
    80204c56:	873e                	mv	a4,a5
    80204c58:	4785                	li	a5,1
    80204c5a:	00e797bb          	sllw	a5,a5,a4
    80204c5e:	2781                	sext.w	a5,a5
    80204c60:	fff7c793          	not	a5,a5
    80204c64:	2781                	sext.w	a5,a5
    80204c66:	2781                	sext.w	a5,a5
    80204c68:	fec42703          	lw	a4,-20(s0)
    80204c6c:	8ff9                	and	a5,a5,a4
    80204c6e:	2781                	sext.w	a5,a5
    80204c70:	85be                	mv	a1,a5
    80204c72:	0c0027b7          	lui	a5,0xc002
    80204c76:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204c7a:	00000097          	auipc	ra,0x0
    80204c7e:	e2c080e7          	jalr	-468(ra) # 80204aa6 <write32>
}
    80204c82:	0001                	nop
    80204c84:	70a2                	ld	ra,40(sp)
    80204c86:	7402                	ld	s0,32(sp)
    80204c88:	6145                	addi	sp,sp,48
    80204c8a:	8082                	ret

0000000080204c8c <plic_claim>:
int plic_claim(void) {
    80204c8c:	1141                	addi	sp,sp,-16
    80204c8e:	e406                	sd	ra,8(sp)
    80204c90:	e022                	sd	s0,0(sp)
    80204c92:	0800                	addi	s0,sp,16
    return read32(PLIC_CLAIM);
    80204c94:	0c2017b7          	lui	a5,0xc201
    80204c98:	00478513          	addi	a0,a5,4 # c201004 <_entry-0x73ffeffc>
    80204c9c:	00000097          	auipc	ra,0x0
    80204ca0:	e56080e7          	jalr	-426(ra) # 80204af2 <read32>
    80204ca4:	87aa                	mv	a5,a0
    80204ca6:	2781                	sext.w	a5,a5
    80204ca8:	2781                	sext.w	a5,a5
}
    80204caa:	853e                	mv	a0,a5
    80204cac:	60a2                	ld	ra,8(sp)
    80204cae:	6402                	ld	s0,0(sp)
    80204cb0:	0141                	addi	sp,sp,16
    80204cb2:	8082                	ret

0000000080204cb4 <plic_complete>:
void plic_complete(int irq) {
    80204cb4:	1101                	addi	sp,sp,-32
    80204cb6:	ec06                	sd	ra,24(sp)
    80204cb8:	e822                	sd	s0,16(sp)
    80204cba:	1000                	addi	s0,sp,32
    80204cbc:	87aa                	mv	a5,a0
    80204cbe:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_CLAIM, irq);
    80204cc2:	fec42783          	lw	a5,-20(s0)
    80204cc6:	85be                	mv	a1,a5
    80204cc8:	0c2017b7          	lui	a5,0xc201
    80204ccc:	00478513          	addi	a0,a5,4 # c201004 <_entry-0x73ffeffc>
    80204cd0:	00000097          	auipc	ra,0x0
    80204cd4:	dd6080e7          	jalr	-554(ra) # 80204aa6 <write32>
    80204cd8:	0001                	nop
    80204cda:	60e2                	ld	ra,24(sp)
    80204cdc:	6442                	ld	s0,16(sp)
    80204cde:	6105                	addi	sp,sp,32
    80204ce0:	8082                	ret
	...

0000000080204cf0 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80204cf0:	7111                	addi	sp,sp,-256

        # save ALL registers (caller-saved and callee-saved)
        sd ra, 0(sp)
    80204cf2:	e006                	sd	ra,0(sp)
        sd gp, 16(sp)
    80204cf4:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80204cf6:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80204cf8:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80204cfa:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    80204cfc:	f81e                	sd	t2,48(sp)
        sd s0, 56(sp)    # 保存s0/fp
    80204cfe:	fc22                	sd	s0,56(sp)
        sd s1, 64(sp)    # 保存s1
    80204d00:	e0a6                	sd	s1,64(sp)
        sd a0, 72(sp)
    80204d02:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80204d04:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80204d06:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80204d08:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80204d0a:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80204d0c:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80204d0e:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80204d10:	e146                	sd	a7,128(sp)
        sd s2, 136(sp)   # 保存s2
    80204d12:	e54a                	sd	s2,136(sp)
        sd s3, 144(sp)   # 保存s3
    80204d14:	e94e                	sd	s3,144(sp)
        sd s4, 152(sp)   # 保存s4
    80204d16:	ed52                	sd	s4,152(sp)
        sd s5, 160(sp)   # 保存s5
    80204d18:	f156                	sd	s5,160(sp)
        sd s6, 168(sp)   # 保存s6
    80204d1a:	f55a                	sd	s6,168(sp)
        sd s7, 176(sp)   # 保存s7
    80204d1c:	f95e                	sd	s7,176(sp)
        sd s8, 184(sp)   # 保存s8
    80204d1e:	fd62                	sd	s8,184(sp)
        sd s9, 192(sp)   # 保存s9
    80204d20:	e1e6                	sd	s9,192(sp)
        sd s10, 200(sp)  # 保存s10
    80204d22:	e5ea                	sd	s10,200(sp)
        sd s11, 208(sp)  # 保存s11
    80204d24:	e9ee                	sd	s11,208(sp)
        sd t3, 216(sp)
    80204d26:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80204d28:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80204d2a:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80204d2c:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80204d2e:	fffff097          	auipc	ra,0xfffff
    80204d32:	cec080e7          	jalr	-788(ra) # 80203a1a <kerneltrap>

        # restore ALL registers
        ld ra, 0(sp)
    80204d36:	6082                	ld	ra,0(sp)
        # 不恢复sp
        ld gp, 16(sp)
    80204d38:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    80204d3a:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80204d3c:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80204d3e:	73c2                	ld	t2,48(sp)
        ld s0, 56(sp)    # 恢复s0/fp
    80204d40:	7462                	ld	s0,56(sp)
        ld s1, 64(sp)    # 恢复s1
    80204d42:	6486                	ld	s1,64(sp)
        ld a0, 72(sp)
    80204d44:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80204d46:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80204d48:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80204d4a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    80204d4c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    80204d4e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80204d50:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80204d52:	688a                	ld	a7,128(sp)
        ld s2, 136(sp)   # 恢复s2
    80204d54:	692a                	ld	s2,136(sp)
        ld s3, 144(sp)   # 恢复s3
    80204d56:	69ca                	ld	s3,144(sp)
        ld s4, 152(sp)   # 恢复s4
    80204d58:	6a6a                	ld	s4,152(sp)
        ld s5, 160(sp)   # 恢复s5
    80204d5a:	7a8a                	ld	s5,160(sp)
        ld s6, 168(sp)   # 恢复s6
    80204d5c:	7b2a                	ld	s6,168(sp)
        ld s7, 176(sp)   # 恢复s7
    80204d5e:	7bca                	ld	s7,176(sp)
        ld s8, 184(sp)   # 恢复s8
    80204d60:	7c6a                	ld	s8,184(sp)
        ld s9, 192(sp)   # 恢复s9
    80204d62:	6c8e                	ld	s9,192(sp)
        ld s10, 200(sp)  # 恢复s10
    80204d64:	6d2e                	ld	s10,200(sp)
        ld s11, 208(sp)  # 恢复s11
    80204d66:	6dce                	ld	s11,208(sp)
        ld t3, 216(sp)
    80204d68:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80204d6a:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80204d6c:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80204d6e:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80204d70:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
    80204d72:	10200073          	sret
    80204d76:	0001                	nop
    80204d78:	00000013          	nop
    80204d7c:	00000013          	nop

0000000080204d80 <trampoline>:
trampoline:
.align 4

uservec:
    # 1. 取 trapframe 指针
    csrrw a0, sscratch, a0      # a0 = TRAPFRAME (用户页表下可访问), sscratch = user a0
    80204d80:	14051573          	csrrw	a0,sscratch,a0

    # 2. 按新的trapframe结构保存寄存器
    sd   ra, 64(a0)             # ra offset: 64
    80204d84:	04153023          	sd	ra,64(a0) # c201040 <_entry-0x73ffefc0>
    sd   sp, 72(a0)             # sp offset: 72
    80204d88:	04253423          	sd	sp,72(a0)
    sd   gp, 80(a0)             # gp offset: 80
    80204d8c:	04353823          	sd	gp,80(a0)
    sd   tp, 88(a0)             # tp offset: 88
    80204d90:	04453c23          	sd	tp,88(a0)
    sd   t0, 96(a0)             # t0 offset: 96
    80204d94:	06553023          	sd	t0,96(a0)
    sd   t1, 104(a0)            # t1 offset: 104
    80204d98:	06653423          	sd	t1,104(a0)
    sd   t2, 112(a0)            # t2 offset: 112
    80204d9c:	06753823          	sd	t2,112(a0)
    sd   t3, 120(a0)            # t3 offset: 120
    80204da0:	07c53c23          	sd	t3,120(a0)
    sd   t4, 128(a0)            # t4 offset: 128
    80204da4:	09d53023          	sd	t4,128(a0)
    sd   t5, 136(a0)            # t5 offset: 136
    80204da8:	09e53423          	sd	t5,136(a0)
    sd   t6, 144(a0)            # t6 offset: 144
    80204dac:	09f53823          	sd	t6,144(a0)
    sd   s0, 152(a0)            # s0 offset: 152
    80204db0:	ed40                	sd	s0,152(a0)
    sd   s1, 160(a0)            # s1 offset: 160
    80204db2:	f144                	sd	s1,160(a0)

    # 继续保存其他寄存器
    sd   a1, 176(a0)            # a1 offset: 176
    80204db4:	f94c                	sd	a1,176(a0)
    sd   a2, 184(a0)            # a2 offset: 184
    80204db6:	fd50                	sd	a2,184(a0)
    sd   a3, 192(a0)            # a3 offset: 192
    80204db8:	e174                	sd	a3,192(a0)
    sd   a4, 200(a0)            # a4 offset: 200
    80204dba:	e578                	sd	a4,200(a0)
    sd   a5, 208(a0)            # a5 offset: 208
    80204dbc:	e97c                	sd	a5,208(a0)
    sd   a6, 216(a0)            # a6 offset: 216
    80204dbe:	0d053c23          	sd	a6,216(a0)
    sd   a7, 224(a0)            # a7 offset: 224
    80204dc2:	0f153023          	sd	a7,224(a0)
    sd   s2, 232(a0)            # s2 offset: 232
    80204dc6:	0f253423          	sd	s2,232(a0)
    sd   s3, 240(a0)            # s3 offset: 240
    80204dca:	0f353823          	sd	s3,240(a0)
    sd   s4, 248(a0)            # s4 offset: 248
    80204dce:	0f453c23          	sd	s4,248(a0)
    sd   s5, 256(a0)            # s5 offset: 256
    80204dd2:	11553023          	sd	s5,256(a0)
    sd   s6, 264(a0)            # s6 offset: 264
    80204dd6:	11653423          	sd	s6,264(a0)
    sd   s7, 272(a0)            # s7 offset: 272
    80204dda:	11753823          	sd	s7,272(a0)
    sd   s8, 280(a0)            # s8 offset: 280
    80204dde:	11853c23          	sd	s8,280(a0)
    sd   s9, 288(a0)            # s9 offset: 288
    80204de2:	13953023          	sd	s9,288(a0)
    sd   s10, 296(a0)           # s10 offset: 296
    80204de6:	13a53423          	sd	s10,296(a0)
    sd   s11, 304(a0)           # s11 offset: 304
    80204dea:	13b53823          	sd	s11,304(a0)

	# 保存用户 a0：先取回 sscratch 里的原值
    csrr t0, sscratch
    80204dee:	140022f3          	csrr	t0,sscratch
    sd   t0, 168(a0)
    80204df2:	0a553423          	sd	t0,168(a0)

    # 保存控制寄存器
    csrr t0, sstatus
    80204df6:	100022f3          	csrr	t0,sstatus
    sd   t0, 48(a0)
    80204dfa:	02553823          	sd	t0,48(a0)
    csrr t1, sepc
    80204dfe:	14102373          	csrr	t1,sepc
    sd   t1, 56(a0)
    80204e02:	02653c23          	sd	t1,56(a0)

	# 在切换页表前，先读出关键字段到 t3–t6
    ld   t3, 0(a0)              # t3 = kernel_satp
    80204e06:	00053e03          	ld	t3,0(a0)
    ld   t4, 8(a0)              # t4 = kernel_sp
    80204e0a:	00853e83          	ld	t4,8(a0)
    ld   t5, 24(a0)            # t5 = usertrap
    80204e0e:	01853f03          	ld	t5,24(a0)
	ld   t6, 32(a0)			# t6 = kernel_vec
    80204e12:	02053f83          	ld	t6,32(a0)

    # 4. 切换到内核页表
    csrw satp, t3
    80204e16:	180e1073          	csrw	satp,t3
    sfence.vma x0, x0
    80204e1a:	12000073          	sfence.vma

    # 5. 切换到内核栈
    mv   sp, t4
    80204e1e:	8176                	mv	sp,t4

    # 6. 设置 stvec 并跳转到 C 层 usertrap
    csrw stvec, t6
    80204e20:	105f9073          	csrw	stvec,t6
    jr   t5
    80204e24:	8f02                	jr	t5

0000000080204e26 <userret>:
userret:
        csrw satp, a1
    80204e26:	18059073          	csrw	satp,a1
        sfence.vma zero, zero
    80204e2a:	12000073          	sfence.vma
    # 2. 按新的偏移量恢复寄存器
    ld   ra, 64(a0)
    80204e2e:	04053083          	ld	ra,64(a0)
    ld   sp, 72(a0)
    80204e32:	04853103          	ld	sp,72(a0)
    ld   gp, 80(a0)
    80204e36:	05053183          	ld	gp,80(a0)
    ld   tp, 88(a0)
    80204e3a:	05853203          	ld	tp,88(a0)
    ld   t0, 96(a0)
    80204e3e:	06053283          	ld	t0,96(a0)
    ld   t1, 104(a0)
    80204e42:	06853303          	ld	t1,104(a0)
    ld   t2, 112(a0)
    80204e46:	07053383          	ld	t2,112(a0)
    ld   t3, 120(a0)
    80204e4a:	07853e03          	ld	t3,120(a0)
    ld   t4, 128(a0)
    80204e4e:	08053e83          	ld	t4,128(a0)
    ld   t5, 136(a0)
    80204e52:	08853f03          	ld	t5,136(a0)
    ld   t6, 144(a0)
    80204e56:	09053f83          	ld	t6,144(a0)
    ld   s0, 152(a0)
    80204e5a:	6d40                	ld	s0,152(a0)
    ld   s1, 160(a0)
    80204e5c:	7144                	ld	s1,160(a0)
    ld   a1, 176(a0)
    80204e5e:	794c                	ld	a1,176(a0)
    ld   a2, 184(a0)
    80204e60:	7d50                	ld	a2,184(a0)
    ld   a3, 192(a0)
    80204e62:	6174                	ld	a3,192(a0)
    ld   a4, 200(a0)
    80204e64:	6578                	ld	a4,200(a0)
    ld   a5, 208(a0)
    80204e66:	697c                	ld	a5,208(a0)
    ld   a6, 216(a0)
    80204e68:	0d853803          	ld	a6,216(a0)
    ld   a7, 224(a0)
    80204e6c:	0e053883          	ld	a7,224(a0)
    ld   s2, 232(a0)
    80204e70:	0e853903          	ld	s2,232(a0)
    ld   s3, 240(a0)
    80204e74:	0f053983          	ld	s3,240(a0)
    ld   s4, 248(a0)
    80204e78:	0f853a03          	ld	s4,248(a0)
    ld   s5, 256(a0)
    80204e7c:	10053a83          	ld	s5,256(a0)
    ld   s6, 264(a0)
    80204e80:	10853b03          	ld	s6,264(a0)
    ld   s7, 272(a0)
    80204e84:	11053b83          	ld	s7,272(a0)
    ld   s8, 280(a0)
    80204e88:	11853c03          	ld	s8,280(a0)
    ld   s9, 288(a0)
    80204e8c:	12053c83          	ld	s9,288(a0)
    ld   s10, 296(a0)
    80204e90:	12853d03          	ld	s10,296(a0)
    ld   s11, 304(a0)
    80204e94:	13053d83          	ld	s11,304(a0)

        # 使用临时变量恢复控制寄存器
        ld t0, 56(a0)      # 恢复 sepc
    80204e98:	03853283          	ld	t0,56(a0)
        csrw sepc, t0
    80204e9c:	14129073          	csrw	sepc,t0
        ld t0, 48(a0)      # 恢复 sstatus
    80204ea0:	03053283          	ld	t0,48(a0)
        csrw sstatus, t0
    80204ea4:	10029073          	csrw	sstatus,t0
		csrw sscratch, a0
    80204ea8:	14051073          	csrw	sscratch,a0
		ld a0, 168(a0)
    80204eac:	7548                	ld	a0,168(a0)
    80204eae:	10200073          	sret
    80204eb2:	0001                	nop
    80204eb4:	00000013          	nop
    80204eb8:	00000013          	nop
    80204ebc:	00000013          	nop

0000000080204ec0 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80204ec0:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80204ec4:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80204ec8:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80204eca:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80204ecc:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80204ed0:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80204ed4:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80204ed8:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80204edc:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80204ee0:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80204ee4:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80204ee8:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80204eec:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80204ef0:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80204ef4:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80204ef8:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80204efc:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80204efe:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80204f00:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80204f04:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80204f08:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80204f0c:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80204f10:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80204f14:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80204f18:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80204f1c:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80204f20:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80204f24:	0685bd83          	ld	s11,104(a1)
        
        ret
    80204f28:	8082                	ret

0000000080204f2a <r_sstatus>:
    80204f2a:	1101                	addi	sp,sp,-32
    80204f2c:	ec22                	sd	s0,24(sp)
    80204f2e:	1000                	addi	s0,sp,32
    80204f30:	100027f3          	csrr	a5,sstatus
    80204f34:	fef43423          	sd	a5,-24(s0)
    80204f38:	fe843783          	ld	a5,-24(s0)
    80204f3c:	853e                	mv	a0,a5
    80204f3e:	6462                	ld	s0,24(sp)
    80204f40:	6105                	addi	sp,sp,32
    80204f42:	8082                	ret

0000000080204f44 <w_sstatus>:
    80204f44:	1101                	addi	sp,sp,-32
    80204f46:	ec22                	sd	s0,24(sp)
    80204f48:	1000                	addi	s0,sp,32
    80204f4a:	fea43423          	sd	a0,-24(s0)
    80204f4e:	fe843783          	ld	a5,-24(s0)
    80204f52:	10079073          	csrw	sstatus,a5
    80204f56:	0001                	nop
    80204f58:	6462                	ld	s0,24(sp)
    80204f5a:	6105                	addi	sp,sp,32
    80204f5c:	8082                	ret

0000000080204f5e <intr_on>:
    80204f5e:	1141                	addi	sp,sp,-16
    80204f60:	e406                	sd	ra,8(sp)
    80204f62:	e022                	sd	s0,0(sp)
    80204f64:	0800                	addi	s0,sp,16
    80204f66:	00000097          	auipc	ra,0x0
    80204f6a:	fc4080e7          	jalr	-60(ra) # 80204f2a <r_sstatus>
    80204f6e:	87aa                	mv	a5,a0
    80204f70:	0027e793          	ori	a5,a5,2
    80204f74:	853e                	mv	a0,a5
    80204f76:	00000097          	auipc	ra,0x0
    80204f7a:	fce080e7          	jalr	-50(ra) # 80204f44 <w_sstatus>
    80204f7e:	0001                	nop
    80204f80:	60a2                	ld	ra,8(sp)
    80204f82:	6402                	ld	s0,0(sp)
    80204f84:	0141                	addi	sp,sp,16
    80204f86:	8082                	ret

0000000080204f88 <intr_off>:
    80204f88:	1141                	addi	sp,sp,-16
    80204f8a:	e406                	sd	ra,8(sp)
    80204f8c:	e022                	sd	s0,0(sp)
    80204f8e:	0800                	addi	s0,sp,16
    80204f90:	00000097          	auipc	ra,0x0
    80204f94:	f9a080e7          	jalr	-102(ra) # 80204f2a <r_sstatus>
    80204f98:	87aa                	mv	a5,a0
    80204f9a:	9bf5                	andi	a5,a5,-3
    80204f9c:	853e                	mv	a0,a5
    80204f9e:	00000097          	auipc	ra,0x0
    80204fa2:	fa6080e7          	jalr	-90(ra) # 80204f44 <w_sstatus>
    80204fa6:	0001                	nop
    80204fa8:	60a2                	ld	ra,8(sp)
    80204faa:	6402                	ld	s0,0(sp)
    80204fac:	0141                	addi	sp,sp,16
    80204fae:	8082                	ret

0000000080204fb0 <w_stvec>:
    80204fb0:	1101                	addi	sp,sp,-32
    80204fb2:	ec22                	sd	s0,24(sp)
    80204fb4:	1000                	addi	s0,sp,32
    80204fb6:	fea43423          	sd	a0,-24(s0)
    80204fba:	fe843783          	ld	a5,-24(s0)
    80204fbe:	10579073          	csrw	stvec,a5
    80204fc2:	0001                	nop
    80204fc4:	6462                	ld	s0,24(sp)
    80204fc6:	6105                	addi	sp,sp,32
    80204fc8:	8082                	ret

0000000080204fca <assert>:
    80204fca:	1101                	addi	sp,sp,-32
    80204fcc:	ec06                	sd	ra,24(sp)
    80204fce:	e822                	sd	s0,16(sp)
    80204fd0:	1000                	addi	s0,sp,32
    80204fd2:	87aa                	mv	a5,a0
    80204fd4:	fef42623          	sw	a5,-20(s0)
    80204fd8:	fec42783          	lw	a5,-20(s0)
    80204fdc:	2781                	sext.w	a5,a5
    80204fde:	e79d                	bnez	a5,8020500c <assert+0x42>
    80204fe0:	33800613          	li	a2,824
    80204fe4:	0001f597          	auipc	a1,0x1f
    80204fe8:	5dc58593          	addi	a1,a1,1500 # 802245c0 <user_test_table+0x78>
    80204fec:	0001f517          	auipc	a0,0x1f
    80204ff0:	5e450513          	addi	a0,a0,1508 # 802245d0 <user_test_table+0x88>
    80204ff4:	ffffc097          	auipc	ra,0xffffc
    80204ff8:	d9a080e7          	jalr	-614(ra) # 80200d8e <printf>
    80204ffc:	0001f517          	auipc	a0,0x1f
    80205000:	5fc50513          	addi	a0,a0,1532 # 802245f8 <user_test_table+0xb0>
    80205004:	ffffc097          	auipc	ra,0xffffc
    80205008:	7d6080e7          	jalr	2006(ra) # 802017da <panic>
    8020500c:	0001                	nop
    8020500e:	60e2                	ld	ra,24(sp)
    80205010:	6442                	ld	s0,16(sp)
    80205012:	6105                	addi	sp,sp,32
    80205014:	8082                	ret

0000000080205016 <shutdown>:
void shutdown() {
    80205016:	1141                	addi	sp,sp,-16
    80205018:	e406                	sd	ra,8(sp)
    8020501a:	e022                	sd	s0,0(sp)
    8020501c:	0800                	addi	s0,sp,16
	free_proc_table();
    8020501e:	00000097          	auipc	ra,0x0
    80205022:	3c8080e7          	jalr	968(ra) # 802053e6 <free_proc_table>
    printf("关机\n");
    80205026:	0001f517          	auipc	a0,0x1f
    8020502a:	5da50513          	addi	a0,a0,1498 # 80224600 <user_test_table+0xb8>
    8020502e:	ffffc097          	auipc	ra,0xffffc
    80205032:	d60080e7          	jalr	-672(ra) # 80200d8e <printf>
    asm volatile (
    80205036:	48a1                	li	a7,8
    80205038:	00000073          	ecall
    while (1) { }
    8020503c:	0001                	nop
    8020503e:	bffd                	j	8020503c <shutdown+0x26>

0000000080205040 <myproc>:
struct proc* myproc(void) {
    80205040:	1141                	addi	sp,sp,-16
    80205042:	e422                	sd	s0,8(sp)
    80205044:	0800                	addi	s0,sp,16
    return current_proc;
    80205046:	00037797          	auipc	a5,0x37
    8020504a:	07278793          	addi	a5,a5,114 # 8023c0b8 <current_proc>
    8020504e:	639c                	ld	a5,0(a5)
}
    80205050:	853e                	mv	a0,a5
    80205052:	6422                	ld	s0,8(sp)
    80205054:	0141                	addi	sp,sp,16
    80205056:	8082                	ret

0000000080205058 <mycpu>:
struct cpu* mycpu(void) {
    80205058:	1141                	addi	sp,sp,-16
    8020505a:	e406                	sd	ra,8(sp)
    8020505c:	e022                	sd	s0,0(sp)
    8020505e:	0800                	addi	s0,sp,16
    if (current_cpu == 0) {
    80205060:	00037797          	auipc	a5,0x37
    80205064:	06078793          	addi	a5,a5,96 # 8023c0c0 <current_cpu>
    80205068:	639c                	ld	a5,0(a5)
    8020506a:	ebb9                	bnez	a5,802050c0 <mycpu+0x68>
        warning("current_cpu is NULL, initializing...\n");
    8020506c:	0001f517          	auipc	a0,0x1f
    80205070:	59c50513          	addi	a0,a0,1436 # 80224608 <user_test_table+0xc0>
    80205074:	ffffc097          	auipc	ra,0xffffc
    80205078:	79a080e7          	jalr	1946(ra) # 8020180e <warning>
		memset(&cpu_instance, 0, sizeof(struct cpu));
    8020507c:	07800613          	li	a2,120
    80205080:	4581                	li	a1,0
    80205082:	00037517          	auipc	a0,0x37
    80205086:	5fe50513          	addi	a0,a0,1534 # 8023c680 <cpu_instance.0>
    8020508a:	ffffd097          	auipc	ra,0xffffd
    8020508e:	e8e080e7          	jalr	-370(ra) # 80201f18 <memset>
		current_cpu = &cpu_instance;
    80205092:	00037797          	auipc	a5,0x37
    80205096:	02e78793          	addi	a5,a5,46 # 8023c0c0 <current_cpu>
    8020509a:	00037717          	auipc	a4,0x37
    8020509e:	5e670713          	addi	a4,a4,1510 # 8023c680 <cpu_instance.0>
    802050a2:	e398                	sd	a4,0(a5)
		printf("CPU initialized: %p\n", current_cpu);
    802050a4:	00037797          	auipc	a5,0x37
    802050a8:	01c78793          	addi	a5,a5,28 # 8023c0c0 <current_cpu>
    802050ac:	639c                	ld	a5,0(a5)
    802050ae:	85be                	mv	a1,a5
    802050b0:	0001f517          	auipc	a0,0x1f
    802050b4:	58050513          	addi	a0,a0,1408 # 80224630 <user_test_table+0xe8>
    802050b8:	ffffc097          	auipc	ra,0xffffc
    802050bc:	cd6080e7          	jalr	-810(ra) # 80200d8e <printf>
	assert(current_cpu != 0);
    802050c0:	00037797          	auipc	a5,0x37
    802050c4:	00078793          	mv	a5,a5
    802050c8:	639c                	ld	a5,0(a5)
    802050ca:	00f037b3          	snez	a5,a5
    802050ce:	0ff7f793          	zext.b	a5,a5
    802050d2:	2781                	sext.w	a5,a5
    802050d4:	853e                	mv	a0,a5
    802050d6:	00000097          	auipc	ra,0x0
    802050da:	ef4080e7          	jalr	-268(ra) # 80204fca <assert>
    return current_cpu;
    802050de:	00037797          	auipc	a5,0x37
    802050e2:	fe278793          	addi	a5,a5,-30 # 8023c0c0 <current_cpu>
    802050e6:	639c                	ld	a5,0(a5)
}
    802050e8:	853e                	mv	a0,a5
    802050ea:	60a2                	ld	ra,8(sp)
    802050ec:	6402                	ld	s0,0(sp)
    802050ee:	0141                	addi	sp,sp,16
    802050f0:	8082                	ret

00000000802050f2 <return_to_user>:
void return_to_user(void) {
    802050f2:	7179                	addi	sp,sp,-48
    802050f4:	f406                	sd	ra,40(sp)
    802050f6:	f022                	sd	s0,32(sp)
    802050f8:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    802050fa:	00000097          	auipc	ra,0x0
    802050fe:	f46080e7          	jalr	-186(ra) # 80205040 <myproc>
    80205102:	fea43423          	sd	a0,-24(s0)
    if (!p) panic("return_to_user: no current process");
    80205106:	fe843783          	ld	a5,-24(s0)
    8020510a:	eb89                	bnez	a5,8020511c <return_to_user+0x2a>
    8020510c:	0001f517          	auipc	a0,0x1f
    80205110:	53c50513          	addi	a0,a0,1340 # 80224648 <user_test_table+0x100>
    80205114:	ffffc097          	auipc	ra,0xffffc
    80205118:	6c6080e7          	jalr	1734(ra) # 802017da <panic>
    w_stvec(TRAMPOLINE + (uservec - trampoline));
    8020511c:	00000717          	auipc	a4,0x0
    80205120:	c6470713          	addi	a4,a4,-924 # 80204d80 <trampoline>
    80205124:	00000797          	auipc	a5,0x0
    80205128:	c5c78793          	addi	a5,a5,-932 # 80204d80 <trampoline>
    8020512c:	40f707b3          	sub	a5,a4,a5
    80205130:	873e                	mv	a4,a5
    80205132:	77fd                	lui	a5,0xfffff
    80205134:	97ba                	add	a5,a5,a4
    80205136:	853e                	mv	a0,a5
    80205138:	00000097          	auipc	ra,0x0
    8020513c:	e78080e7          	jalr	-392(ra) # 80204fb0 <w_stvec>
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80205140:	00000717          	auipc	a4,0x0
    80205144:	ce670713          	addi	a4,a4,-794 # 80204e26 <userret>
    80205148:	00000797          	auipc	a5,0x0
    8020514c:	c3878793          	addi	a5,a5,-968 # 80204d80 <trampoline>
    80205150:	40f707b3          	sub	a5,a4,a5
    80205154:	873e                	mv	a4,a5
    80205156:	77fd                	lui	a5,0xfffff
    80205158:	97ba                	add	a5,a5,a4
    8020515a:	fef43023          	sd	a5,-32(s0)
    uint64 satp = MAKE_SATP(p->pagetable);
    8020515e:	fe843783          	ld	a5,-24(s0)
    80205162:	7fdc                	ld	a5,184(a5)
    80205164:	00c7d713          	srli	a4,a5,0xc
    80205168:	57fd                	li	a5,-1
    8020516a:	17fe                	slli	a5,a5,0x3f
    8020516c:	8fd9                	or	a5,a5,a4
    8020516e:	fcf43c23          	sd	a5,-40(s0)
    if ((trampoline_userret & ~(PGSIZE - 1)) != TRAMPOLINE) {
    80205172:	fe043703          	ld	a4,-32(s0)
    80205176:	77fd                	lui	a5,0xfffff
    80205178:	8f7d                	and	a4,a4,a5
    8020517a:	77fd                	lui	a5,0xfffff
    8020517c:	00f70a63          	beq	a4,a5,80205190 <return_to_user+0x9e>
        panic("return_to_user: userret outside trampoline page");
    80205180:	0001f517          	auipc	a0,0x1f
    80205184:	4f050513          	addi	a0,a0,1264 # 80224670 <user_test_table+0x128>
    80205188:	ffffc097          	auipc	ra,0xffffc
    8020518c:	652080e7          	jalr	1618(ra) # 802017da <panic>
    void (*userret_fn)(uint64, uint64) = (void (*)(uint64, uint64))trampoline_userret;
    80205190:	fe043783          	ld	a5,-32(s0)
    80205194:	fcf43823          	sd	a5,-48(s0)
    userret_fn(TRAPFRAME, satp);
    80205198:	fd043783          	ld	a5,-48(s0)
    8020519c:	fd843583          	ld	a1,-40(s0)
    802051a0:	7579                	lui	a0,0xffffe
    802051a2:	9782                	jalr	a5
    panic("return_to_user: should not return");
    802051a4:	0001f517          	auipc	a0,0x1f
    802051a8:	4fc50513          	addi	a0,a0,1276 # 802246a0 <user_test_table+0x158>
    802051ac:	ffffc097          	auipc	ra,0xffffc
    802051b0:	62e080e7          	jalr	1582(ra) # 802017da <panic>
}
    802051b4:	0001                	nop
    802051b6:	70a2                	ld	ra,40(sp)
    802051b8:	7402                	ld	s0,32(sp)
    802051ba:	6145                	addi	sp,sp,48
    802051bc:	8082                	ret

00000000802051be <forkret>:
void forkret(void) {
    802051be:	1101                	addi	sp,sp,-32
    802051c0:	ec06                	sd	ra,24(sp)
    802051c2:	e822                	sd	s0,16(sp)
    802051c4:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    802051c6:	00000097          	auipc	ra,0x0
    802051ca:	e7a080e7          	jalr	-390(ra) # 80205040 <myproc>
    802051ce:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    802051d2:	fe843783          	ld	a5,-24(s0)
    802051d6:	eb89                	bnez	a5,802051e8 <forkret+0x2a>
        panic("forkret: no current process");
    802051d8:	0001f517          	auipc	a0,0x1f
    802051dc:	4f050513          	addi	a0,a0,1264 # 802246c8 <user_test_table+0x180>
    802051e0:	ffffc097          	auipc	ra,0xffffc
    802051e4:	5fa080e7          	jalr	1530(ra) # 802017da <panic>
    if (p->killed) {
    802051e8:	fe843783          	ld	a5,-24(s0)
    802051ec:	0807a783          	lw	a5,128(a5) # fffffffffffff080 <_bss_end+0xffffffff7fdb7760>
    802051f0:	c785                	beqz	a5,80205218 <forkret+0x5a>
        printf("[forkret] Process PID %d killed before execution\n", p->pid);
    802051f2:	fe843783          	ld	a5,-24(s0)
    802051f6:	43dc                	lw	a5,4(a5)
    802051f8:	85be                	mv	a1,a5
    802051fa:	0001f517          	auipc	a0,0x1f
    802051fe:	4ee50513          	addi	a0,a0,1262 # 802246e8 <user_test_table+0x1a0>
    80205202:	ffffc097          	auipc	ra,0xffffc
    80205206:	b8c080e7          	jalr	-1140(ra) # 80200d8e <printf>
        exit_proc(SYS_kill);
    8020520a:	08100513          	li	a0,129
    8020520e:	00001097          	auipc	ra,0x1
    80205212:	cee080e7          	jalr	-786(ra) # 80205efc <exit_proc>
        return; // 虽然不会执行到这里，但为了代码清晰
    80205216:	a099                	j	8020525c <forkret+0x9e>
    if (p->is_user) {
    80205218:	fe843783          	ld	a5,-24(s0)
    8020521c:	0a87a783          	lw	a5,168(a5)
    80205220:	c791                	beqz	a5,8020522c <forkret+0x6e>
        return_to_user();
    80205222:	00000097          	auipc	ra,0x0
    80205226:	ed0080e7          	jalr	-304(ra) # 802050f2 <return_to_user>
    8020522a:	a80d                	j	8020525c <forkret+0x9e>
		if (p->trapframe->epc) {
    8020522c:	fe843783          	ld	a5,-24(s0)
    80205230:	63fc                	ld	a5,192(a5)
    80205232:	7f9c                	ld	a5,56(a5)
    80205234:	cf99                	beqz	a5,80205252 <forkret+0x94>
			void (*fn)(uint64) = (void(*)(uint64))p->trapframe->epc;
    80205236:	fe843783          	ld	a5,-24(s0)
    8020523a:	63fc                	ld	a5,192(a5)
    8020523c:	7f9c                	ld	a5,56(a5)
    8020523e:	fef43023          	sd	a5,-32(s0)
			fn(p->trapframe->a0);
    80205242:	fe843783          	ld	a5,-24(s0)
    80205246:	63fc                	ld	a5,192(a5)
    80205248:	77d8                	ld	a4,168(a5)
    8020524a:	fe043783          	ld	a5,-32(s0)
    8020524e:	853a                	mv	a0,a4
    80205250:	9782                	jalr	a5
        exit_proc(0);  // 内核线程函数返回则退出
    80205252:	4501                	li	a0,0
    80205254:	00001097          	auipc	ra,0x1
    80205258:	ca8080e7          	jalr	-856(ra) # 80205efc <exit_proc>
}
    8020525c:	60e2                	ld	ra,24(sp)
    8020525e:	6442                	ld	s0,16(sp)
    80205260:	6105                	addi	sp,sp,32
    80205262:	8082                	ret

0000000080205264 <init_proc>:
void init_proc(void){
    80205264:	1101                	addi	sp,sp,-32
    80205266:	ec06                	sd	ra,24(sp)
    80205268:	e822                	sd	s0,16(sp)
    8020526a:	1000                	addi	s0,sp,32
    for (int i = 0; i < PROC; i++) {
    8020526c:	fe042623          	sw	zero,-20(s0)
    80205270:	aa81                	j	802053c0 <init_proc+0x15c>
        void *page = alloc_page();
    80205272:	ffffe097          	auipc	ra,0xffffe
    80205276:	0be080e7          	jalr	190(ra) # 80203330 <alloc_page>
    8020527a:	fea43023          	sd	a0,-32(s0)
        if (!page) panic("init_proc: alloc_page failed for proc_table");
    8020527e:	fe043783          	ld	a5,-32(s0)
    80205282:	eb89                	bnez	a5,80205294 <init_proc+0x30>
    80205284:	0001f517          	auipc	a0,0x1f
    80205288:	49c50513          	addi	a0,a0,1180 # 80224720 <user_test_table+0x1d8>
    8020528c:	ffffc097          	auipc	ra,0xffffc
    80205290:	54e080e7          	jalr	1358(ra) # 802017da <panic>
        proc_table_mem[i] = page;
    80205294:	00037717          	auipc	a4,0x37
    80205298:	2ec70713          	addi	a4,a4,748 # 8023c580 <proc_table_mem>
    8020529c:	fec42783          	lw	a5,-20(s0)
    802052a0:	078e                	slli	a5,a5,0x3
    802052a2:	97ba                	add	a5,a5,a4
    802052a4:	fe043703          	ld	a4,-32(s0)
    802052a8:	e398                	sd	a4,0(a5)
        proc_table[i] = (struct proc *)page;
    802052aa:	00037717          	auipc	a4,0x37
    802052ae:	1ce70713          	addi	a4,a4,462 # 8023c478 <proc_table>
    802052b2:	fec42783          	lw	a5,-20(s0)
    802052b6:	078e                	slli	a5,a5,0x3
    802052b8:	97ba                	add	a5,a5,a4
    802052ba:	fe043703          	ld	a4,-32(s0)
    802052be:	e398                	sd	a4,0(a5)
        memset(proc_table[i], 0, sizeof(struct proc));
    802052c0:	00037717          	auipc	a4,0x37
    802052c4:	1b870713          	addi	a4,a4,440 # 8023c478 <proc_table>
    802052c8:	fec42783          	lw	a5,-20(s0)
    802052cc:	078e                	slli	a5,a5,0x3
    802052ce:	97ba                	add	a5,a5,a4
    802052d0:	639c                	ld	a5,0(a5)
    802052d2:	0d000613          	li	a2,208
    802052d6:	4581                	li	a1,0
    802052d8:	853e                	mv	a0,a5
    802052da:	ffffd097          	auipc	ra,0xffffd
    802052de:	c3e080e7          	jalr	-962(ra) # 80201f18 <memset>
        proc_table[i]->state = UNUSED;
    802052e2:	00037717          	auipc	a4,0x37
    802052e6:	19670713          	addi	a4,a4,406 # 8023c478 <proc_table>
    802052ea:	fec42783          	lw	a5,-20(s0)
    802052ee:	078e                	slli	a5,a5,0x3
    802052f0:	97ba                	add	a5,a5,a4
    802052f2:	639c                	ld	a5,0(a5)
    802052f4:	0007a023          	sw	zero,0(a5)
        proc_table[i]->pid = 0;
    802052f8:	00037717          	auipc	a4,0x37
    802052fc:	18070713          	addi	a4,a4,384 # 8023c478 <proc_table>
    80205300:	fec42783          	lw	a5,-20(s0)
    80205304:	078e                	slli	a5,a5,0x3
    80205306:	97ba                	add	a5,a5,a4
    80205308:	639c                	ld	a5,0(a5)
    8020530a:	0007a223          	sw	zero,4(a5)
        proc_table[i]->kstack = 0;
    8020530e:	00037717          	auipc	a4,0x37
    80205312:	16a70713          	addi	a4,a4,362 # 8023c478 <proc_table>
    80205316:	fec42783          	lw	a5,-20(s0)
    8020531a:	078e                	slli	a5,a5,0x3
    8020531c:	97ba                	add	a5,a5,a4
    8020531e:	639c                	ld	a5,0(a5)
    80205320:	0007b423          	sd	zero,8(a5)
        proc_table[i]->pagetable = 0;
    80205324:	00037717          	auipc	a4,0x37
    80205328:	15470713          	addi	a4,a4,340 # 8023c478 <proc_table>
    8020532c:	fec42783          	lw	a5,-20(s0)
    80205330:	078e                	slli	a5,a5,0x3
    80205332:	97ba                	add	a5,a5,a4
    80205334:	639c                	ld	a5,0(a5)
    80205336:	0a07bc23          	sd	zero,184(a5)
        proc_table[i]->trapframe = 0;
    8020533a:	00037717          	auipc	a4,0x37
    8020533e:	13e70713          	addi	a4,a4,318 # 8023c478 <proc_table>
    80205342:	fec42783          	lw	a5,-20(s0)
    80205346:	078e                	slli	a5,a5,0x3
    80205348:	97ba                	add	a5,a5,a4
    8020534a:	639c                	ld	a5,0(a5)
    8020534c:	0c07b023          	sd	zero,192(a5)
        proc_table[i]->parent = 0;
    80205350:	00037717          	auipc	a4,0x37
    80205354:	12870713          	addi	a4,a4,296 # 8023c478 <proc_table>
    80205358:	fec42783          	lw	a5,-20(s0)
    8020535c:	078e                	slli	a5,a5,0x3
    8020535e:	97ba                	add	a5,a5,a4
    80205360:	639c                	ld	a5,0(a5)
    80205362:	0807bc23          	sd	zero,152(a5)
        proc_table[i]->chan = 0;
    80205366:	00037717          	auipc	a4,0x37
    8020536a:	11270713          	addi	a4,a4,274 # 8023c478 <proc_table>
    8020536e:	fec42783          	lw	a5,-20(s0)
    80205372:	078e                	slli	a5,a5,0x3
    80205374:	97ba                	add	a5,a5,a4
    80205376:	639c                	ld	a5,0(a5)
    80205378:	0a07b023          	sd	zero,160(a5)
        proc_table[i]->exit_status = 0;
    8020537c:	00037717          	auipc	a4,0x37
    80205380:	0fc70713          	addi	a4,a4,252 # 8023c478 <proc_table>
    80205384:	fec42783          	lw	a5,-20(s0)
    80205388:	078e                	slli	a5,a5,0x3
    8020538a:	97ba                	add	a5,a5,a4
    8020538c:	639c                	ld	a5,0(a5)
    8020538e:	0807a223          	sw	zero,132(a5)
        memset(&proc_table[i]->context, 0, sizeof(struct context));
    80205392:	00037717          	auipc	a4,0x37
    80205396:	0e670713          	addi	a4,a4,230 # 8023c478 <proc_table>
    8020539a:	fec42783          	lw	a5,-20(s0)
    8020539e:	078e                	slli	a5,a5,0x3
    802053a0:	97ba                	add	a5,a5,a4
    802053a2:	639c                	ld	a5,0(a5)
    802053a4:	07c1                	addi	a5,a5,16
    802053a6:	07000613          	li	a2,112
    802053aa:	4581                	li	a1,0
    802053ac:	853e                	mv	a0,a5
    802053ae:	ffffd097          	auipc	ra,0xffffd
    802053b2:	b6a080e7          	jalr	-1174(ra) # 80201f18 <memset>
    for (int i = 0; i < PROC; i++) {
    802053b6:	fec42783          	lw	a5,-20(s0)
    802053ba:	2785                	addiw	a5,a5,1
    802053bc:	fef42623          	sw	a5,-20(s0)
    802053c0:	fec42783          	lw	a5,-20(s0)
    802053c4:	0007871b          	sext.w	a4,a5
    802053c8:	47fd                	li	a5,31
    802053ca:	eae7d4e3          	bge	a5,a4,80205272 <init_proc+0xe>
    proc_table_pages = PROC; // 每个进程一页
    802053ce:	00037797          	auipc	a5,0x37
    802053d2:	1aa78793          	addi	a5,a5,426 # 8023c578 <proc_table_pages>
    802053d6:	02000713          	li	a4,32
    802053da:	c398                	sw	a4,0(a5)
}
    802053dc:	0001                	nop
    802053de:	60e2                	ld	ra,24(sp)
    802053e0:	6442                	ld	s0,16(sp)
    802053e2:	6105                	addi	sp,sp,32
    802053e4:	8082                	ret

00000000802053e6 <free_proc_table>:
void free_proc_table(void) {
    802053e6:	1101                	addi	sp,sp,-32
    802053e8:	ec06                	sd	ra,24(sp)
    802053ea:	e822                	sd	s0,16(sp)
    802053ec:	1000                	addi	s0,sp,32
    for (int i = 0; i < proc_table_pages; i++) {
    802053ee:	fe042623          	sw	zero,-20(s0)
    802053f2:	a025                	j	8020541a <free_proc_table+0x34>
        free_page(proc_table_mem[i]);
    802053f4:	00037717          	auipc	a4,0x37
    802053f8:	18c70713          	addi	a4,a4,396 # 8023c580 <proc_table_mem>
    802053fc:	fec42783          	lw	a5,-20(s0)
    80205400:	078e                	slli	a5,a5,0x3
    80205402:	97ba                	add	a5,a5,a4
    80205404:	639c                	ld	a5,0(a5)
    80205406:	853e                	mv	a0,a5
    80205408:	ffffe097          	auipc	ra,0xffffe
    8020540c:	f94080e7          	jalr	-108(ra) # 8020339c <free_page>
    for (int i = 0; i < proc_table_pages; i++) {
    80205410:	fec42783          	lw	a5,-20(s0)
    80205414:	2785                	addiw	a5,a5,1
    80205416:	fef42623          	sw	a5,-20(s0)
    8020541a:	00037797          	auipc	a5,0x37
    8020541e:	15e78793          	addi	a5,a5,350 # 8023c578 <proc_table_pages>
    80205422:	4398                	lw	a4,0(a5)
    80205424:	fec42783          	lw	a5,-20(s0)
    80205428:	2781                	sext.w	a5,a5
    8020542a:	fce7c5e3          	blt	a5,a4,802053f4 <free_proc_table+0xe>
}
    8020542e:	0001                	nop
    80205430:	0001                	nop
    80205432:	60e2                	ld	ra,24(sp)
    80205434:	6442                	ld	s0,16(sp)
    80205436:	6105                	addi	sp,sp,32
    80205438:	8082                	ret

000000008020543a <alloc_proc>:
struct proc* alloc_proc(int is_user) {
    8020543a:	7139                	addi	sp,sp,-64
    8020543c:	fc06                	sd	ra,56(sp)
    8020543e:	f822                	sd	s0,48(sp)
    80205440:	0080                	addi	s0,sp,64
    80205442:	87aa                	mv	a5,a0
    80205444:	fcf42623          	sw	a5,-52(s0)
    for(int i = 0;i<PROC;i++) {
    80205448:	fe042623          	sw	zero,-20(s0)
    8020544c:	a241                	j	802055cc <alloc_proc+0x192>
		struct proc *p = proc_table[i];
    8020544e:	00037717          	auipc	a4,0x37
    80205452:	02a70713          	addi	a4,a4,42 # 8023c478 <proc_table>
    80205456:	fec42783          	lw	a5,-20(s0)
    8020545a:	078e                	slli	a5,a5,0x3
    8020545c:	97ba                	add	a5,a5,a4
    8020545e:	639c                	ld	a5,0(a5)
    80205460:	fef43023          	sd	a5,-32(s0)
        if(p->state == UNUSED) {
    80205464:	fe043783          	ld	a5,-32(s0)
    80205468:	439c                	lw	a5,0(a5)
    8020546a:	14079c63          	bnez	a5,802055c2 <alloc_proc+0x188>
            p->pid = i;
    8020546e:	fe043783          	ld	a5,-32(s0)
    80205472:	fec42703          	lw	a4,-20(s0)
    80205476:	c3d8                	sw	a4,4(a5)
			p->cwd = 0;
    80205478:	fe043783          	ld	a5,-32(s0)
    8020547c:	0c07b423          	sd	zero,200(a5)
            p->state = USED;
    80205480:	fe043783          	ld	a5,-32(s0)
    80205484:	4705                	li	a4,1
    80205486:	c398                	sw	a4,0(a5)
			p->is_user = is_user;
    80205488:	fe043783          	ld	a5,-32(s0)
    8020548c:	fcc42703          	lw	a4,-52(s0)
    80205490:	0ae7a423          	sw	a4,168(a5)
            p->trapframe = (struct trapframe*)alloc_page();
    80205494:	ffffe097          	auipc	ra,0xffffe
    80205498:	e9c080e7          	jalr	-356(ra) # 80203330 <alloc_page>
    8020549c:	872a                	mv	a4,a0
    8020549e:	fe043783          	ld	a5,-32(s0)
    802054a2:	e3f8                	sd	a4,192(a5)
            if(p->trapframe == 0){
    802054a4:	fe043783          	ld	a5,-32(s0)
    802054a8:	63fc                	ld	a5,192(a5)
    802054aa:	eb99                	bnez	a5,802054c0 <alloc_proc+0x86>
                p->state = UNUSED;
    802054ac:	fe043783          	ld	a5,-32(s0)
    802054b0:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    802054b4:	fe043783          	ld	a5,-32(s0)
    802054b8:	0007a223          	sw	zero,4(a5)
                return 0;
    802054bc:	4781                	li	a5,0
    802054be:	aa39                	j	802055dc <alloc_proc+0x1a2>
			if(p->is_user){
    802054c0:	fe043783          	ld	a5,-32(s0)
    802054c4:	0a87a783          	lw	a5,168(a5)
    802054c8:	c3b9                	beqz	a5,8020550e <alloc_proc+0xd4>
				p->pagetable = create_pagetable();
    802054ca:	ffffd097          	auipc	ra,0xffffd
    802054ce:	caa080e7          	jalr	-854(ra) # 80202174 <create_pagetable>
    802054d2:	872a                	mv	a4,a0
    802054d4:	fe043783          	ld	a5,-32(s0)
    802054d8:	ffd8                	sd	a4,184(a5)
				if(p->pagetable == 0){
    802054da:	fe043783          	ld	a5,-32(s0)
    802054de:	7fdc                	ld	a5,184(a5)
    802054e0:	ef9d                	bnez	a5,8020551e <alloc_proc+0xe4>
					free_page(p->trapframe);
    802054e2:	fe043783          	ld	a5,-32(s0)
    802054e6:	63fc                	ld	a5,192(a5)
    802054e8:	853e                	mv	a0,a5
    802054ea:	ffffe097          	auipc	ra,0xffffe
    802054ee:	eb2080e7          	jalr	-334(ra) # 8020339c <free_page>
					p->trapframe = 0;
    802054f2:	fe043783          	ld	a5,-32(s0)
    802054f6:	0c07b023          	sd	zero,192(a5)
					p->state = UNUSED;
    802054fa:	fe043783          	ld	a5,-32(s0)
    802054fe:	0007a023          	sw	zero,0(a5)
					p->pid = 0;
    80205502:	fe043783          	ld	a5,-32(s0)
    80205506:	0007a223          	sw	zero,4(a5)
					return 0;
    8020550a:	4781                	li	a5,0
    8020550c:	a8c1                	j	802055dc <alloc_proc+0x1a2>
				p->pagetable = kernel_pagetable;
    8020550e:	00037797          	auipc	a5,0x37
    80205512:	b9278793          	addi	a5,a5,-1134 # 8023c0a0 <kernel_pagetable>
    80205516:	6398                	ld	a4,0(a5)
    80205518:	fe043783          	ld	a5,-32(s0)
    8020551c:	ffd8                	sd	a4,184(a5)
            void *kstack_mem = alloc_page();
    8020551e:	ffffe097          	auipc	ra,0xffffe
    80205522:	e12080e7          	jalr	-494(ra) # 80203330 <alloc_page>
    80205526:	fca43c23          	sd	a0,-40(s0)
            if(kstack_mem == 0) {
    8020552a:	fd843783          	ld	a5,-40(s0)
    8020552e:	e3b9                	bnez	a5,80205574 <alloc_proc+0x13a>
                free_page(p->trapframe);
    80205530:	fe043783          	ld	a5,-32(s0)
    80205534:	63fc                	ld	a5,192(a5)
    80205536:	853e                	mv	a0,a5
    80205538:	ffffe097          	auipc	ra,0xffffe
    8020553c:	e64080e7          	jalr	-412(ra) # 8020339c <free_page>
                free_pagetable(p->pagetable);
    80205540:	fe043783          	ld	a5,-32(s0)
    80205544:	7fdc                	ld	a5,184(a5)
    80205546:	853e                	mv	a0,a5
    80205548:	ffffd097          	auipc	ra,0xffffd
    8020554c:	010080e7          	jalr	16(ra) # 80202558 <free_pagetable>
                p->trapframe = 0;
    80205550:	fe043783          	ld	a5,-32(s0)
    80205554:	0c07b023          	sd	zero,192(a5)
                p->pagetable = 0;
    80205558:	fe043783          	ld	a5,-32(s0)
    8020555c:	0a07bc23          	sd	zero,184(a5)
                p->state = UNUSED;
    80205560:	fe043783          	ld	a5,-32(s0)
    80205564:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    80205568:	fe043783          	ld	a5,-32(s0)
    8020556c:	0007a223          	sw	zero,4(a5)
                return 0;
    80205570:	4781                	li	a5,0
    80205572:	a0ad                	j	802055dc <alloc_proc+0x1a2>
            p->kstack = (uint64)kstack_mem;
    80205574:	fd843703          	ld	a4,-40(s0)
    80205578:	fe043783          	ld	a5,-32(s0)
    8020557c:	e798                	sd	a4,8(a5)
            memset(&p->context, 0, sizeof(p->context));
    8020557e:	fe043783          	ld	a5,-32(s0)
    80205582:	07c1                	addi	a5,a5,16
    80205584:	07000613          	li	a2,112
    80205588:	4581                	li	a1,0
    8020558a:	853e                	mv	a0,a5
    8020558c:	ffffd097          	auipc	ra,0xffffd
    80205590:	98c080e7          	jalr	-1652(ra) # 80201f18 <memset>
            p->context.ra = (uint64)forkret;
    80205594:	00000717          	auipc	a4,0x0
    80205598:	c2a70713          	addi	a4,a4,-982 # 802051be <forkret>
    8020559c:	fe043783          	ld	a5,-32(s0)
    802055a0:	eb98                	sd	a4,16(a5)
            p->context.sp = p->kstack + PGSIZE - 16;  // 16字节对齐
    802055a2:	fe043783          	ld	a5,-32(s0)
    802055a6:	6798                	ld	a4,8(a5)
    802055a8:	6785                	lui	a5,0x1
    802055aa:	17c1                	addi	a5,a5,-16 # ff0 <_entry-0x801ff010>
    802055ac:	973e                	add	a4,a4,a5
    802055ae:	fe043783          	ld	a5,-32(s0)
    802055b2:	ef98                	sd	a4,24(a5)
			p->killed = 0; //重置死亡状态
    802055b4:	fe043783          	ld	a5,-32(s0)
    802055b8:	0807a023          	sw	zero,128(a5)
            return p;
    802055bc:	fe043783          	ld	a5,-32(s0)
    802055c0:	a831                	j	802055dc <alloc_proc+0x1a2>
    for(int i = 0;i<PROC;i++) {
    802055c2:	fec42783          	lw	a5,-20(s0)
    802055c6:	2785                	addiw	a5,a5,1
    802055c8:	fef42623          	sw	a5,-20(s0)
    802055cc:	fec42783          	lw	a5,-20(s0)
    802055d0:	0007871b          	sext.w	a4,a5
    802055d4:	47fd                	li	a5,31
    802055d6:	e6e7dce3          	bge	a5,a4,8020544e <alloc_proc+0x14>
    return 0;
    802055da:	4781                	li	a5,0
}
    802055dc:	853e                	mv	a0,a5
    802055de:	70e2                	ld	ra,56(sp)
    802055e0:	7442                	ld	s0,48(sp)
    802055e2:	6121                	addi	sp,sp,64
    802055e4:	8082                	ret

00000000802055e6 <free_proc>:
void free_proc(struct proc *p){
    802055e6:	1101                	addi	sp,sp,-32
    802055e8:	ec06                	sd	ra,24(sp)
    802055ea:	e822                	sd	s0,16(sp)
    802055ec:	1000                	addi	s0,sp,32
    802055ee:	fea43423          	sd	a0,-24(s0)
    if(p->trapframe)
    802055f2:	fe843783          	ld	a5,-24(s0)
    802055f6:	63fc                	ld	a5,192(a5)
    802055f8:	cb89                	beqz	a5,8020560a <free_proc+0x24>
        free_page(p->trapframe);
    802055fa:	fe843783          	ld	a5,-24(s0)
    802055fe:	63fc                	ld	a5,192(a5)
    80205600:	853e                	mv	a0,a5
    80205602:	ffffe097          	auipc	ra,0xffffe
    80205606:	d9a080e7          	jalr	-614(ra) # 8020339c <free_page>
    p->trapframe = 0;
    8020560a:	fe843783          	ld	a5,-24(s0)
    8020560e:	0c07b023          	sd	zero,192(a5)
    if(p->pagetable && p->pagetable != kernel_pagetable)
    80205612:	fe843783          	ld	a5,-24(s0)
    80205616:	7fdc                	ld	a5,184(a5)
    80205618:	c39d                	beqz	a5,8020563e <free_proc+0x58>
    8020561a:	fe843783          	ld	a5,-24(s0)
    8020561e:	7fd8                	ld	a4,184(a5)
    80205620:	00037797          	auipc	a5,0x37
    80205624:	a8078793          	addi	a5,a5,-1408 # 8023c0a0 <kernel_pagetable>
    80205628:	639c                	ld	a5,0(a5)
    8020562a:	00f70a63          	beq	a4,a5,8020563e <free_proc+0x58>
        free_pagetable(p->pagetable);
    8020562e:	fe843783          	ld	a5,-24(s0)
    80205632:	7fdc                	ld	a5,184(a5)
    80205634:	853e                	mv	a0,a5
    80205636:	ffffd097          	auipc	ra,0xffffd
    8020563a:	f22080e7          	jalr	-222(ra) # 80202558 <free_pagetable>
    p->pagetable = 0;
    8020563e:	fe843783          	ld	a5,-24(s0)
    80205642:	0a07bc23          	sd	zero,184(a5)
    if(p->kstack)
    80205646:	fe843783          	ld	a5,-24(s0)
    8020564a:	679c                	ld	a5,8(a5)
    8020564c:	cb89                	beqz	a5,8020565e <free_proc+0x78>
        free_page((void*)p->kstack);
    8020564e:	fe843783          	ld	a5,-24(s0)
    80205652:	679c                	ld	a5,8(a5)
    80205654:	853e                	mv	a0,a5
    80205656:	ffffe097          	auipc	ra,0xffffe
    8020565a:	d46080e7          	jalr	-698(ra) # 8020339c <free_page>
    p->kstack = 0;
    8020565e:	fe843783          	ld	a5,-24(s0)
    80205662:	0007b423          	sd	zero,8(a5)
    p->pid = 0;
    80205666:	fe843783          	ld	a5,-24(s0)
    8020566a:	0007a223          	sw	zero,4(a5)
    p->state = UNUSED;
    8020566e:	fe843783          	ld	a5,-24(s0)
    80205672:	0007a023          	sw	zero,0(a5)
    p->parent = 0;
    80205676:	fe843783          	ld	a5,-24(s0)
    8020567a:	0807bc23          	sd	zero,152(a5)
    p->chan = 0;
    8020567e:	fe843783          	ld	a5,-24(s0)
    80205682:	0a07b023          	sd	zero,160(a5)
    memset(&p->context, 0, sizeof(p->context));
    80205686:	fe843783          	ld	a5,-24(s0)
    8020568a:	07c1                	addi	a5,a5,16
    8020568c:	07000613          	li	a2,112
    80205690:	4581                	li	a1,0
    80205692:	853e                	mv	a0,a5
    80205694:	ffffd097          	auipc	ra,0xffffd
    80205698:	884080e7          	jalr	-1916(ra) # 80201f18 <memset>
}
    8020569c:	0001                	nop
    8020569e:	60e2                	ld	ra,24(sp)
    802056a0:	6442                	ld	s0,16(sp)
    802056a2:	6105                	addi	sp,sp,32
    802056a4:	8082                	ret

00000000802056a6 <create_kernel_proc>:
int create_kernel_proc(void (*entry)(void)) {
    802056a6:	7179                	addi	sp,sp,-48
    802056a8:	f406                	sd	ra,40(sp)
    802056aa:	f022                	sd	s0,32(sp)
    802056ac:	1800                	addi	s0,sp,48
    802056ae:	fca43c23          	sd	a0,-40(s0)
    struct proc *p = alloc_proc(0);
    802056b2:	4501                	li	a0,0
    802056b4:	00000097          	auipc	ra,0x0
    802056b8:	d86080e7          	jalr	-634(ra) # 8020543a <alloc_proc>
    802056bc:	fea43423          	sd	a0,-24(s0)
    if (!p) return -1;
    802056c0:	fe843783          	ld	a5,-24(s0)
    802056c4:	e399                	bnez	a5,802056ca <create_kernel_proc+0x24>
    802056c6:	57fd                	li	a5,-1
    802056c8:	a88d                	j	8020573a <create_kernel_proc+0x94>
    p->trapframe->epc = (uint64)entry;
    802056ca:	fe843783          	ld	a5,-24(s0)
    802056ce:	63fc                	ld	a5,192(a5)
    802056d0:	fd843703          	ld	a4,-40(s0)
    802056d4:	ff98                	sd	a4,56(a5)
    p->state = RUNNABLE;
    802056d6:	fe843783          	ld	a5,-24(s0)
    802056da:	470d                	li	a4,3
    802056dc:	c398                	sw	a4,0(a5)
    struct proc *parent = myproc();
    802056de:	00000097          	auipc	ra,0x0
    802056e2:	962080e7          	jalr	-1694(ra) # 80205040 <myproc>
    802056e6:	fea43023          	sd	a0,-32(s0)
    if (parent != 0) {
    802056ea:	fe043783          	ld	a5,-32(s0)
    802056ee:	c799                	beqz	a5,802056fc <create_kernel_proc+0x56>
        p->parent = parent;
    802056f0:	fe843783          	ld	a5,-24(s0)
    802056f4:	fe043703          	ld	a4,-32(s0)
    802056f8:	efd8                	sd	a4,152(a5)
    802056fa:	a029                	j	80205704 <create_kernel_proc+0x5e>
        p->parent = NULL;
    802056fc:	fe843783          	ld	a5,-24(s0)
    80205700:	0807bc23          	sd	zero,152(a5)
	if (parent && parent->cwd)
    80205704:	fe043783          	ld	a5,-32(s0)
    80205708:	c395                	beqz	a5,8020572c <create_kernel_proc+0x86>
    8020570a:	fe043783          	ld	a5,-32(s0)
    8020570e:	67fc                	ld	a5,200(a5)
    80205710:	cf91                	beqz	a5,8020572c <create_kernel_proc+0x86>
		p->cwd = idup(parent->cwd);
    80205712:	fe043783          	ld	a5,-32(s0)
    80205716:	67fc                	ld	a5,200(a5)
    80205718:	853e                	mv	a0,a5
    8020571a:	00005097          	auipc	ra,0x5
    8020571e:	080080e7          	jalr	128(ra) # 8020a79a <idup>
    80205722:	872a                	mv	a4,a0
    80205724:	fe843783          	ld	a5,-24(s0)
    80205728:	e7f8                	sd	a4,200(a5)
    8020572a:	a029                	j	80205734 <create_kernel_proc+0x8e>
		p->cwd = 0; // 或者在 main/init 进程里手动设置
    8020572c:	fe843783          	ld	a5,-24(s0)
    80205730:	0c07b423          	sd	zero,200(a5)
    return p->pid;
    80205734:	fe843783          	ld	a5,-24(s0)
    80205738:	43dc                	lw	a5,4(a5)
}
    8020573a:	853e                	mv	a0,a5
    8020573c:	70a2                	ld	ra,40(sp)
    8020573e:	7402                	ld	s0,32(sp)
    80205740:	6145                	addi	sp,sp,48
    80205742:	8082                	ret

0000000080205744 <create_kernel_proc1>:
int create_kernel_proc1(void (*entry)(uint64),uint64 arg){
    80205744:	7179                	addi	sp,sp,-48
    80205746:	f406                	sd	ra,40(sp)
    80205748:	f022                	sd	s0,32(sp)
    8020574a:	1800                	addi	s0,sp,48
    8020574c:	fca43c23          	sd	a0,-40(s0)
    80205750:	fcb43823          	sd	a1,-48(s0)
	struct proc *p = alloc_proc(0);
    80205754:	4501                	li	a0,0
    80205756:	00000097          	auipc	ra,0x0
    8020575a:	ce4080e7          	jalr	-796(ra) # 8020543a <alloc_proc>
    8020575e:	fea43423          	sd	a0,-24(s0)
    if (!p) return -1;
    80205762:	fe843783          	ld	a5,-24(s0)
    80205766:	e399                	bnez	a5,8020576c <create_kernel_proc1+0x28>
    80205768:	57fd                	li	a5,-1
    8020576a:	a8bd                	j	802057e8 <create_kernel_proc1+0xa4>
    p->trapframe->epc = (uint64)entry;
    8020576c:	fe843783          	ld	a5,-24(s0)
    80205770:	63fc                	ld	a5,192(a5)
    80205772:	fd843703          	ld	a4,-40(s0)
    80205776:	ff98                	sd	a4,56(a5)
	p->trapframe->a0 = (uint64)arg;
    80205778:	fe843783          	ld	a5,-24(s0)
    8020577c:	63fc                	ld	a5,192(a5)
    8020577e:	fd043703          	ld	a4,-48(s0)
    80205782:	f7d8                	sd	a4,168(a5)
    p->state = RUNNABLE;
    80205784:	fe843783          	ld	a5,-24(s0)
    80205788:	470d                	li	a4,3
    8020578a:	c398                	sw	a4,0(a5)
    struct proc *parent = myproc();
    8020578c:	00000097          	auipc	ra,0x0
    80205790:	8b4080e7          	jalr	-1868(ra) # 80205040 <myproc>
    80205794:	fea43023          	sd	a0,-32(s0)
    if (parent != 0) {
    80205798:	fe043783          	ld	a5,-32(s0)
    8020579c:	c799                	beqz	a5,802057aa <create_kernel_proc1+0x66>
        p->parent = parent;
    8020579e:	fe843783          	ld	a5,-24(s0)
    802057a2:	fe043703          	ld	a4,-32(s0)
    802057a6:	efd8                	sd	a4,152(a5)
    802057a8:	a029                	j	802057b2 <create_kernel_proc1+0x6e>
        p->parent = NULL;
    802057aa:	fe843783          	ld	a5,-24(s0)
    802057ae:	0807bc23          	sd	zero,152(a5)
	if (parent && parent->cwd)
    802057b2:	fe043783          	ld	a5,-32(s0)
    802057b6:	c395                	beqz	a5,802057da <create_kernel_proc1+0x96>
    802057b8:	fe043783          	ld	a5,-32(s0)
    802057bc:	67fc                	ld	a5,200(a5)
    802057be:	cf91                	beqz	a5,802057da <create_kernel_proc1+0x96>
		p->cwd = idup(parent->cwd);
    802057c0:	fe043783          	ld	a5,-32(s0)
    802057c4:	67fc                	ld	a5,200(a5)
    802057c6:	853e                	mv	a0,a5
    802057c8:	00005097          	auipc	ra,0x5
    802057cc:	fd2080e7          	jalr	-46(ra) # 8020a79a <idup>
    802057d0:	872a                	mv	a4,a0
    802057d2:	fe843783          	ld	a5,-24(s0)
    802057d6:	e7f8                	sd	a4,200(a5)
    802057d8:	a029                	j	802057e2 <create_kernel_proc1+0x9e>
		p->cwd = 0; // 或者在 main/init 进程里手动设置
    802057da:	fe843783          	ld	a5,-24(s0)
    802057de:	0c07b423          	sd	zero,200(a5)
    return p->pid;
    802057e2:	fe843783          	ld	a5,-24(s0)
    802057e6:	43dc                	lw	a5,4(a5)
}
    802057e8:	853e                	mv	a0,a5
    802057ea:	70a2                	ld	ra,40(sp)
    802057ec:	7402                	ld	s0,32(sp)
    802057ee:	6145                	addi	sp,sp,48
    802057f0:	8082                	ret

00000000802057f2 <create_user_proc>:
int create_user_proc(const void *user_bin, int bin_size) {
    802057f2:	711d                	addi	sp,sp,-96
    802057f4:	ec86                	sd	ra,88(sp)
    802057f6:	e8a2                	sd	s0,80(sp)
    802057f8:	1080                	addi	s0,sp,96
    802057fa:	faa43423          	sd	a0,-88(s0)
    802057fe:	87ae                	mv	a5,a1
    80205800:	faf42223          	sw	a5,-92(s0)
    struct proc *p = alloc_proc(1); // 1 表示用户进程
    80205804:	4505                	li	a0,1
    80205806:	00000097          	auipc	ra,0x0
    8020580a:	c34080e7          	jalr	-972(ra) # 8020543a <alloc_proc>
    8020580e:	fea43023          	sd	a0,-32(s0)
    if (!p) return -1;
    80205812:	fe043783          	ld	a5,-32(s0)
    80205816:	e399                	bnez	a5,8020581c <create_user_proc+0x2a>
    80205818:	57fd                	li	a5,-1
    8020581a:	a439                	j	80205a28 <create_user_proc+0x236>
    uint64 user_entry = USER_TEXT_START;
    8020581c:	67c1                	lui	a5,0x10
    8020581e:	fcf43c23          	sd	a5,-40(s0)
    uint64 user_stack = USER_STACK_SIZE;
    80205822:	000207b7          	lui	a5,0x20
    80205826:	fcf43823          	sd	a5,-48(s0)
    void *page = alloc_page();
    8020582a:	ffffe097          	auipc	ra,0xffffe
    8020582e:	b06080e7          	jalr	-1274(ra) # 80203330 <alloc_page>
    80205832:	fca43423          	sd	a0,-56(s0)
    if (!page) { free_proc(p); return -1; }
    80205836:	fc843783          	ld	a5,-56(s0)
    8020583a:	eb89                	bnez	a5,8020584c <create_user_proc+0x5a>
    8020583c:	fe043503          	ld	a0,-32(s0)
    80205840:	00000097          	auipc	ra,0x0
    80205844:	da6080e7          	jalr	-602(ra) # 802055e6 <free_proc>
    80205848:	57fd                	li	a5,-1
    8020584a:	aaf9                	j	80205a28 <create_user_proc+0x236>
    map_page(p->pagetable, user_entry, (uint64)page, PTE_R | PTE_W | PTE_X | PTE_U);
    8020584c:	fe043783          	ld	a5,-32(s0)
    80205850:	7fdc                	ld	a5,184(a5)
    80205852:	fc843703          	ld	a4,-56(s0)
    80205856:	46f9                	li	a3,30
    80205858:	863a                	mv	a2,a4
    8020585a:	fd843583          	ld	a1,-40(s0)
    8020585e:	853e                	mv	a0,a5
    80205860:	ffffd097          	auipc	ra,0xffffd
    80205864:	b84080e7          	jalr	-1148(ra) # 802023e4 <map_page>
    memcpy((void*)page, user_bin, bin_size);
    80205868:	fa442783          	lw	a5,-92(s0)
    8020586c:	863e                	mv	a2,a5
    8020586e:	fa843583          	ld	a1,-88(s0)
    80205872:	fc843503          	ld	a0,-56(s0)
    80205876:	ffffc097          	auipc	ra,0xffffc
    8020587a:	7ae080e7          	jalr	1966(ra) # 80202024 <memcpy>
    for(int i = 0; i < 2; i++) {
    8020587e:	fe042623          	sw	zero,-20(s0)
    80205882:	a8bd                	j	80205900 <create_user_proc+0x10e>
        void *stack_page = alloc_page();
    80205884:	ffffe097          	auipc	ra,0xffffe
    80205888:	aac080e7          	jalr	-1364(ra) # 80203330 <alloc_page>
    8020588c:	faa43c23          	sd	a0,-72(s0)
        if (!stack_page) { 
    80205890:	fb843783          	ld	a5,-72(s0)
    80205894:	eb89                	bnez	a5,802058a6 <create_user_proc+0xb4>
            free_proc(p); 
    80205896:	fe043503          	ld	a0,-32(s0)
    8020589a:	00000097          	auipc	ra,0x0
    8020589e:	d4c080e7          	jalr	-692(ra) # 802055e6 <free_proc>
            return -1; 
    802058a2:	57fd                	li	a5,-1
    802058a4:	a251                	j	80205a28 <create_user_proc+0x236>
        uint64 stack_va = USER_STACK_SIZE - PGSIZE * (i + 1);
    802058a6:	47fd                	li	a5,31
    802058a8:	fec42703          	lw	a4,-20(s0)
    802058ac:	9f99                	subw	a5,a5,a4
    802058ae:	2781                	sext.w	a5,a5
    802058b0:	00c7979b          	slliw	a5,a5,0xc
    802058b4:	2781                	sext.w	a5,a5
    802058b6:	faf43823          	sd	a5,-80(s0)
        if(map_page(p->pagetable, stack_va, (uint64)stack_page, 
    802058ba:	fe043783          	ld	a5,-32(s0)
    802058be:	7fdc                	ld	a5,184(a5)
    802058c0:	fb843703          	ld	a4,-72(s0)
    802058c4:	46d9                	li	a3,22
    802058c6:	863a                	mv	a2,a4
    802058c8:	fb043583          	ld	a1,-80(s0)
    802058cc:	853e                	mv	a0,a5
    802058ce:	ffffd097          	auipc	ra,0xffffd
    802058d2:	b16080e7          	jalr	-1258(ra) # 802023e4 <map_page>
    802058d6:	87aa                	mv	a5,a0
    802058d8:	cf99                	beqz	a5,802058f6 <create_user_proc+0x104>
            free_page(stack_page);
    802058da:	fb843503          	ld	a0,-72(s0)
    802058de:	ffffe097          	auipc	ra,0xffffe
    802058e2:	abe080e7          	jalr	-1346(ra) # 8020339c <free_page>
            free_proc(p);
    802058e6:	fe043503          	ld	a0,-32(s0)
    802058ea:	00000097          	auipc	ra,0x0
    802058ee:	cfc080e7          	jalr	-772(ra) # 802055e6 <free_proc>
            return -1;
    802058f2:	57fd                	li	a5,-1
    802058f4:	aa15                	j	80205a28 <create_user_proc+0x236>
    for(int i = 0; i < 2; i++) {
    802058f6:	fec42783          	lw	a5,-20(s0)
    802058fa:	2785                	addiw	a5,a5,1 # 20001 <_entry-0x801dffff>
    802058fc:	fef42623          	sw	a5,-20(s0)
    80205900:	fec42783          	lw	a5,-20(s0)
    80205904:	0007871b          	sext.w	a4,a5
    80205908:	4785                	li	a5,1
    8020590a:	f6e7dde3          	bge	a5,a4,80205884 <create_user_proc+0x92>
	p->sz = user_stack; // 用户空间从 0x10000 到 0x20000
    8020590e:	fe043783          	ld	a5,-32(s0)
    80205912:	fd043703          	ld	a4,-48(s0)
    80205916:	fbd8                	sd	a4,176(a5)
    if (map_page(p->pagetable, TRAPFRAME, (uint64)p->trapframe, PTE_R | PTE_W) != 0) {
    80205918:	fe043783          	ld	a5,-32(s0)
    8020591c:	7fd8                	ld	a4,184(a5)
    8020591e:	fe043783          	ld	a5,-32(s0)
    80205922:	63fc                	ld	a5,192(a5)
    80205924:	4699                	li	a3,6
    80205926:	863e                	mv	a2,a5
    80205928:	75f9                	lui	a1,0xffffe
    8020592a:	853a                	mv	a0,a4
    8020592c:	ffffd097          	auipc	ra,0xffffd
    80205930:	ab8080e7          	jalr	-1352(ra) # 802023e4 <map_page>
    80205934:	87aa                	mv	a5,a0
    80205936:	cb89                	beqz	a5,80205948 <create_user_proc+0x156>
        free_proc(p);
    80205938:	fe043503          	ld	a0,-32(s0)
    8020593c:	00000097          	auipc	ra,0x0
    80205940:	caa080e7          	jalr	-854(ra) # 802055e6 <free_proc>
        return -1;
    80205944:	57fd                	li	a5,-1
    80205946:	a0cd                	j	80205a28 <create_user_proc+0x236>
	memset(p->trapframe, 0, sizeof(*p->trapframe));
    80205948:	fe043783          	ld	a5,-32(s0)
    8020594c:	63fc                	ld	a5,192(a5)
    8020594e:	13800613          	li	a2,312
    80205952:	4581                	li	a1,0
    80205954:	853e                	mv	a0,a5
    80205956:	ffffc097          	auipc	ra,0xffffc
    8020595a:	5c2080e7          	jalr	1474(ra) # 80201f18 <memset>
	p->trapframe->epc = user_entry; // 应为 0x10000
    8020595e:	fe043783          	ld	a5,-32(s0)
    80205962:	63fc                	ld	a5,192(a5)
    80205964:	fd843703          	ld	a4,-40(s0)
    80205968:	ff98                	sd	a4,56(a5)
	p->trapframe->sp = user_stack;  // 应为 0x20000
    8020596a:	fe043783          	ld	a5,-32(s0)
    8020596e:	63fc                	ld	a5,192(a5)
    80205970:	fd043703          	ld	a4,-48(s0)
    80205974:	e7b8                	sd	a4,72(a5)
	p->trapframe->sstatus = (1UL << 5); // 0x20
    80205976:	fe043783          	ld	a5,-32(s0)
    8020597a:	63fc                	ld	a5,192(a5)
    8020597c:	02000713          	li	a4,32
    80205980:	fb98                	sd	a4,48(a5)
	p->trapframe->kernel_satp = MAKE_SATP(kernel_pagetable);
    80205982:	00036797          	auipc	a5,0x36
    80205986:	71e78793          	addi	a5,a5,1822 # 8023c0a0 <kernel_pagetable>
    8020598a:	639c                	ld	a5,0(a5)
    8020598c:	00c7d693          	srli	a3,a5,0xc
    80205990:	fe043783          	ld	a5,-32(s0)
    80205994:	63fc                	ld	a5,192(a5)
    80205996:	577d                	li	a4,-1
    80205998:	177e                	slli	a4,a4,0x3f
    8020599a:	8f55                	or	a4,a4,a3
    8020599c:	e398                	sd	a4,0(a5)
	p->trapframe->kernel_sp = p->kstack + PGSIZE;   // 内核栈顶
    8020599e:	fe043783          	ld	a5,-32(s0)
    802059a2:	6794                	ld	a3,8(a5)
    802059a4:	fe043783          	ld	a5,-32(s0)
    802059a8:	63fc                	ld	a5,192(a5)
    802059aa:	6705                	lui	a4,0x1
    802059ac:	9736                	add	a4,a4,a3
    802059ae:	e798                	sd	a4,8(a5)
	p->trapframe->usertrap  = (uint64)usertrap;     // C 层 trap 处理函数
    802059b0:	fe043783          	ld	a5,-32(s0)
    802059b4:	63fc                	ld	a5,192(a5)
    802059b6:	fffff717          	auipc	a4,0xfffff
    802059ba:	f1470713          	addi	a4,a4,-236 # 802048ca <usertrap>
    802059be:	ef98                	sd	a4,24(a5)
	p->trapframe->kernel_vec = (uint64)kernelvec;
    802059c0:	fe043783          	ld	a5,-32(s0)
    802059c4:	63fc                	ld	a5,192(a5)
    802059c6:	fffff717          	auipc	a4,0xfffff
    802059ca:	32a70713          	addi	a4,a4,810 # 80204cf0 <kernelvec>
    802059ce:	f398                	sd	a4,32(a5)
    p->state = RUNNABLE;
    802059d0:	fe043783          	ld	a5,-32(s0)
    802059d4:	470d                	li	a4,3
    802059d6:	c398                	sw	a4,0(a5)
	if (map_page(p->pagetable, TRAMPOLINE, trampoline_phys_addr, PTE_X | PTE_R) != 0) {
    802059d8:	fe043783          	ld	a5,-32(s0)
    802059dc:	7fd8                	ld	a4,184(a5)
    802059de:	00036797          	auipc	a5,0x36
    802059e2:	6ca78793          	addi	a5,a5,1738 # 8023c0a8 <trampoline_phys_addr>
    802059e6:	639c                	ld	a5,0(a5)
    802059e8:	46a9                	li	a3,10
    802059ea:	863e                	mv	a2,a5
    802059ec:	75fd                	lui	a1,0xfffff
    802059ee:	853a                	mv	a0,a4
    802059f0:	ffffd097          	auipc	ra,0xffffd
    802059f4:	9f4080e7          	jalr	-1548(ra) # 802023e4 <map_page>
    802059f8:	87aa                	mv	a5,a0
    802059fa:	cb89                	beqz	a5,80205a0c <create_user_proc+0x21a>
		free_proc(p);
    802059fc:	fe043503          	ld	a0,-32(s0)
    80205a00:	00000097          	auipc	ra,0x0
    80205a04:	be6080e7          	jalr	-1050(ra) # 802055e6 <free_proc>
		return -1;
    80205a08:	57fd                	li	a5,-1
    80205a0a:	a839                	j	80205a28 <create_user_proc+0x236>
    struct proc *parent = myproc();
    80205a0c:	fffff097          	auipc	ra,0xfffff
    80205a10:	634080e7          	jalr	1588(ra) # 80205040 <myproc>
    80205a14:	fca43023          	sd	a0,-64(s0)
    p->parent = parent ? parent : NULL;
    80205a18:	fe043783          	ld	a5,-32(s0)
    80205a1c:	fc043703          	ld	a4,-64(s0)
    80205a20:	efd8                	sd	a4,152(a5)
    return p->pid;
    80205a22:	fe043783          	ld	a5,-32(s0)
    80205a26:	43dc                	lw	a5,4(a5)
}
    80205a28:	853e                	mv	a0,a5
    80205a2a:	60e6                	ld	ra,88(sp)
    80205a2c:	6446                	ld	s0,80(sp)
    80205a2e:	6125                	addi	sp,sp,96
    80205a30:	8082                	ret

0000000080205a32 <fork_proc>:
int fork_proc(void) {
    80205a32:	7179                	addi	sp,sp,-48
    80205a34:	f406                	sd	ra,40(sp)
    80205a36:	f022                	sd	s0,32(sp)
    80205a38:	1800                	addi	s0,sp,48
    struct proc *parent = myproc();
    80205a3a:	fffff097          	auipc	ra,0xfffff
    80205a3e:	606080e7          	jalr	1542(ra) # 80205040 <myproc>
    80205a42:	fea43423          	sd	a0,-24(s0)
    struct proc *child = alloc_proc(parent->is_user);
    80205a46:	fe843783          	ld	a5,-24(s0)
    80205a4a:	0a87a783          	lw	a5,168(a5)
    80205a4e:	853e                	mv	a0,a5
    80205a50:	00000097          	auipc	ra,0x0
    80205a54:	9ea080e7          	jalr	-1558(ra) # 8020543a <alloc_proc>
    80205a58:	fea43023          	sd	a0,-32(s0)
    if (!child) return -1;
    80205a5c:	fe043783          	ld	a5,-32(s0)
    80205a60:	e399                	bnez	a5,80205a66 <fork_proc+0x34>
    80205a62:	57fd                	li	a5,-1
    80205a64:	aa69                	j	80205bfe <fork_proc+0x1cc>
    if (uvmcopy(parent->pagetable, child->pagetable, parent->sz) < 0) {
    80205a66:	fe843783          	ld	a5,-24(s0)
    80205a6a:	7fd8                	ld	a4,184(a5)
    80205a6c:	fe043783          	ld	a5,-32(s0)
    80205a70:	7fd4                	ld	a3,184(a5)
    80205a72:	fe843783          	ld	a5,-24(s0)
    80205a76:	7bdc                	ld	a5,176(a5)
    80205a78:	863e                	mv	a2,a5
    80205a7a:	85b6                	mv	a1,a3
    80205a7c:	853a                	mv	a0,a4
    80205a7e:	ffffd097          	auipc	ra,0xffffd
    80205a82:	6e2080e7          	jalr	1762(ra) # 80203160 <uvmcopy>
    80205a86:	87aa                	mv	a5,a0
    80205a88:	0007da63          	bgez	a5,80205a9c <fork_proc+0x6a>
        free_proc(child);
    80205a8c:	fe043503          	ld	a0,-32(s0)
    80205a90:	00000097          	auipc	ra,0x0
    80205a94:	b56080e7          	jalr	-1194(ra) # 802055e6 <free_proc>
        return -1;
    80205a98:	57fd                	li	a5,-1
    80205a9a:	a295                	j	80205bfe <fork_proc+0x1cc>
    child->sz = parent->sz;
    80205a9c:	fe843783          	ld	a5,-24(s0)
    80205aa0:	7bd8                	ld	a4,176(a5)
    80205aa2:	fe043783          	ld	a5,-32(s0)
    80205aa6:	fbd8                	sd	a4,176(a5)
    uint64 tf_pa = (uint64)child->trapframe;
    80205aa8:	fe043783          	ld	a5,-32(s0)
    80205aac:	63fc                	ld	a5,192(a5)
    80205aae:	fcf43c23          	sd	a5,-40(s0)
    if ((tf_pa & (PGSIZE - 1)) != 0) {
    80205ab2:	fd843703          	ld	a4,-40(s0)
    80205ab6:	6785                	lui	a5,0x1
    80205ab8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80205aba:	8ff9                	and	a5,a5,a4
    80205abc:	c39d                	beqz	a5,80205ae2 <fork_proc+0xb0>
        printf("[fork] trapframe not aligned: 0x%lx\n", tf_pa);
    80205abe:	fd843583          	ld	a1,-40(s0)
    80205ac2:	0001f517          	auipc	a0,0x1f
    80205ac6:	c8e50513          	addi	a0,a0,-882 # 80224750 <user_test_table+0x208>
    80205aca:	ffffb097          	auipc	ra,0xffffb
    80205ace:	2c4080e7          	jalr	708(ra) # 80200d8e <printf>
        free_proc(child);
    80205ad2:	fe043503          	ld	a0,-32(s0)
    80205ad6:	00000097          	auipc	ra,0x0
    80205ada:	b10080e7          	jalr	-1264(ra) # 802055e6 <free_proc>
        return -1;
    80205ade:	57fd                	li	a5,-1
    80205ae0:	aa39                	j	80205bfe <fork_proc+0x1cc>
    if (map_page(child->pagetable, TRAPFRAME, tf_pa, PTE_R | PTE_W) != 0) {
    80205ae2:	fe043783          	ld	a5,-32(s0)
    80205ae6:	7fdc                	ld	a5,184(a5)
    80205ae8:	4699                	li	a3,6
    80205aea:	fd843603          	ld	a2,-40(s0)
    80205aee:	75f9                	lui	a1,0xffffe
    80205af0:	853e                	mv	a0,a5
    80205af2:	ffffd097          	auipc	ra,0xffffd
    80205af6:	8f2080e7          	jalr	-1806(ra) # 802023e4 <map_page>
    80205afa:	87aa                	mv	a5,a0
    80205afc:	c38d                	beqz	a5,80205b1e <fork_proc+0xec>
        printf("[fork] map TRAPFRAME failed\n");
    80205afe:	0001f517          	auipc	a0,0x1f
    80205b02:	c7a50513          	addi	a0,a0,-902 # 80224778 <user_test_table+0x230>
    80205b06:	ffffb097          	auipc	ra,0xffffb
    80205b0a:	288080e7          	jalr	648(ra) # 80200d8e <printf>
        free_proc(child);
    80205b0e:	fe043503          	ld	a0,-32(s0)
    80205b12:	00000097          	auipc	ra,0x0
    80205b16:	ad4080e7          	jalr	-1324(ra) # 802055e6 <free_proc>
        return -1;
    80205b1a:	57fd                	li	a5,-1
    80205b1c:	a0cd                	j	80205bfe <fork_proc+0x1cc>
    if (map_page(child->pagetable, TRAMPOLINE, trampoline_phys_addr, PTE_R | PTE_X) != 0) {
    80205b1e:	fe043783          	ld	a5,-32(s0)
    80205b22:	7fd8                	ld	a4,184(a5)
    80205b24:	00036797          	auipc	a5,0x36
    80205b28:	58478793          	addi	a5,a5,1412 # 8023c0a8 <trampoline_phys_addr>
    80205b2c:	639c                	ld	a5,0(a5)
    80205b2e:	46a9                	li	a3,10
    80205b30:	863e                	mv	a2,a5
    80205b32:	75fd                	lui	a1,0xfffff
    80205b34:	853a                	mv	a0,a4
    80205b36:	ffffd097          	auipc	ra,0xffffd
    80205b3a:	8ae080e7          	jalr	-1874(ra) # 802023e4 <map_page>
    80205b3e:	87aa                	mv	a5,a0
    80205b40:	c38d                	beqz	a5,80205b62 <fork_proc+0x130>
        printf("[fork] map TRAMPOLINE failed\n");
    80205b42:	0001f517          	auipc	a0,0x1f
    80205b46:	c5650513          	addi	a0,a0,-938 # 80224798 <user_test_table+0x250>
    80205b4a:	ffffb097          	auipc	ra,0xffffb
    80205b4e:	244080e7          	jalr	580(ra) # 80200d8e <printf>
        free_proc(child);
    80205b52:	fe043503          	ld	a0,-32(s0)
    80205b56:	00000097          	auipc	ra,0x0
    80205b5a:	a90080e7          	jalr	-1392(ra) # 802055e6 <free_proc>
        return -1;
    80205b5e:	57fd                	li	a5,-1
    80205b60:	a879                	j	80205bfe <fork_proc+0x1cc>
    *(child->trapframe) = *(parent->trapframe);
    80205b62:	fe843783          	ld	a5,-24(s0)
    80205b66:	63f8                	ld	a4,192(a5)
    80205b68:	fe043783          	ld	a5,-32(s0)
    80205b6c:	63fc                	ld	a5,192(a5)
    80205b6e:	86be                	mv	a3,a5
    80205b70:	13800793          	li	a5,312
    80205b74:	863e                	mv	a2,a5
    80205b76:	85ba                	mv	a1,a4
    80205b78:	8536                	mv	a0,a3
    80205b7a:	ffffc097          	auipc	ra,0xffffc
    80205b7e:	4aa080e7          	jalr	1194(ra) # 80202024 <memcpy>
	child->trapframe->kernel_sp = child->kstack + PGSIZE;
    80205b82:	fe043783          	ld	a5,-32(s0)
    80205b86:	6794                	ld	a3,8(a5)
    80205b88:	fe043783          	ld	a5,-32(s0)
    80205b8c:	63fc                	ld	a5,192(a5)
    80205b8e:	6705                	lui	a4,0x1
    80205b90:	9736                	add	a4,a4,a3
    80205b92:	e798                	sd	a4,8(a5)
	assert(child->trapframe->kernel_satp = MAKE_SATP(kernel_pagetable));
    80205b94:	00036797          	auipc	a5,0x36
    80205b98:	50c78793          	addi	a5,a5,1292 # 8023c0a0 <kernel_pagetable>
    80205b9c:	639c                	ld	a5,0(a5)
    80205b9e:	00c7d693          	srli	a3,a5,0xc
    80205ba2:	fe043783          	ld	a5,-32(s0)
    80205ba6:	63fc                	ld	a5,192(a5)
    80205ba8:	577d                	li	a4,-1
    80205baa:	177e                	slli	a4,a4,0x3f
    80205bac:	8f55                	or	a4,a4,a3
    80205bae:	e398                	sd	a4,0(a5)
    80205bb0:	639c                	ld	a5,0(a5)
    80205bb2:	2781                	sext.w	a5,a5
    80205bb4:	853e                	mv	a0,a5
    80205bb6:	fffff097          	auipc	ra,0xfffff
    80205bba:	414080e7          	jalr	1044(ra) # 80204fca <assert>
    child->trapframe->epc += 4;  // 跳过 ecall 指令
    80205bbe:	fe043783          	ld	a5,-32(s0)
    80205bc2:	63fc                	ld	a5,192(a5)
    80205bc4:	7f98                	ld	a4,56(a5)
    80205bc6:	fe043783          	ld	a5,-32(s0)
    80205bca:	63fc                	ld	a5,192(a5)
    80205bcc:	0711                	addi	a4,a4,4 # 1004 <_entry-0x801feffc>
    80205bce:	ff98                	sd	a4,56(a5)
    child->trapframe->a0 = 0;    // 子进程fork返回0
    80205bd0:	fe043783          	ld	a5,-32(s0)
    80205bd4:	63fc                	ld	a5,192(a5)
    80205bd6:	0a07b423          	sd	zero,168(a5)
    child->state = RUNNABLE;
    80205bda:	fe043783          	ld	a5,-32(s0)
    80205bde:	470d                	li	a4,3
    80205be0:	c398                	sw	a4,0(a5)
    child->parent = parent;
    80205be2:	fe043783          	ld	a5,-32(s0)
    80205be6:	fe843703          	ld	a4,-24(s0)
    80205bea:	efd8                	sd	a4,152(a5)
	child->cwd = parent->cwd;
    80205bec:	fe843783          	ld	a5,-24(s0)
    80205bf0:	67f8                	ld	a4,200(a5)
    80205bf2:	fe043783          	ld	a5,-32(s0)
    80205bf6:	e7f8                	sd	a4,200(a5)
    return child->pid;
    80205bf8:	fe043783          	ld	a5,-32(s0)
    80205bfc:	43dc                	lw	a5,4(a5)
}
    80205bfe:	853e                	mv	a0,a5
    80205c00:	70a2                	ld	ra,40(sp)
    80205c02:	7402                	ld	s0,32(sp)
    80205c04:	6145                	addi	sp,sp,48
    80205c06:	8082                	ret

0000000080205c08 <schedule>:
void schedule(void) {
    80205c08:	1101                	addi	sp,sp,-32
    80205c0a:	ec06                	sd	ra,24(sp)
    80205c0c:	e822                	sd	s0,16(sp)
    80205c0e:	1000                	addi	s0,sp,32
    intr_on();
    80205c10:	fffff097          	auipc	ra,0xfffff
    80205c14:	34e080e7          	jalr	846(ra) # 80204f5e <intr_on>
    for(int i = 0; i < PROC; i++) {
    80205c18:	fe042623          	sw	zero,-20(s0)
    80205c1c:	a841                	j	80205cac <schedule+0xa4>
        struct proc *p = proc_table[i];
    80205c1e:	00037717          	auipc	a4,0x37
    80205c22:	85a70713          	addi	a4,a4,-1958 # 8023c478 <proc_table>
    80205c26:	fec42783          	lw	a5,-20(s0)
    80205c2a:	078e                	slli	a5,a5,0x3
    80205c2c:	97ba                	add	a5,a5,a4
    80205c2e:	639c                	ld	a5,0(a5)
    80205c30:	fef43023          	sd	a5,-32(s0)
        if(p->state == RUNNABLE) {
    80205c34:	fe043783          	ld	a5,-32(s0)
    80205c38:	439c                	lw	a5,0(a5)
    80205c3a:	873e                	mv	a4,a5
    80205c3c:	478d                	li	a5,3
    80205c3e:	06f71263          	bne	a4,a5,80205ca2 <schedule+0x9a>
            p->state = RUNNING;
    80205c42:	fe043783          	ld	a5,-32(s0)
    80205c46:	4711                	li	a4,4
    80205c48:	c398                	sw	a4,0(a5)
            mycpu()->proc = p;
    80205c4a:	fffff097          	auipc	ra,0xfffff
    80205c4e:	40e080e7          	jalr	1038(ra) # 80205058 <mycpu>
    80205c52:	872a                	mv	a4,a0
    80205c54:	fe043783          	ld	a5,-32(s0)
    80205c58:	e31c                	sd	a5,0(a4)
            current_proc = p;
    80205c5a:	00036797          	auipc	a5,0x36
    80205c5e:	45e78793          	addi	a5,a5,1118 # 8023c0b8 <current_proc>
    80205c62:	fe043703          	ld	a4,-32(s0)
    80205c66:	e398                	sd	a4,0(a5)
            swtch(&mycpu()->context, &p->context);
    80205c68:	fffff097          	auipc	ra,0xfffff
    80205c6c:	3f0080e7          	jalr	1008(ra) # 80205058 <mycpu>
    80205c70:	87aa                	mv	a5,a0
    80205c72:	00878713          	addi	a4,a5,8
    80205c76:	fe043783          	ld	a5,-32(s0)
    80205c7a:	07c1                	addi	a5,a5,16
    80205c7c:	85be                	mv	a1,a5
    80205c7e:	853a                	mv	a0,a4
    80205c80:	fffff097          	auipc	ra,0xfffff
    80205c84:	240080e7          	jalr	576(ra) # 80204ec0 <swtch>
            mycpu()->proc = 0;
    80205c88:	fffff097          	auipc	ra,0xfffff
    80205c8c:	3d0080e7          	jalr	976(ra) # 80205058 <mycpu>
    80205c90:	87aa                	mv	a5,a0
    80205c92:	0007b023          	sd	zero,0(a5)
            current_proc = 0;
    80205c96:	00036797          	auipc	a5,0x36
    80205c9a:	42278793          	addi	a5,a5,1058 # 8023c0b8 <current_proc>
    80205c9e:	0007b023          	sd	zero,0(a5)
    for(int i = 0; i < PROC; i++) {
    80205ca2:	fec42783          	lw	a5,-20(s0)
    80205ca6:	2785                	addiw	a5,a5,1
    80205ca8:	fef42623          	sw	a5,-20(s0)
    80205cac:	fec42783          	lw	a5,-20(s0)
    80205cb0:	0007871b          	sext.w	a4,a5
    80205cb4:	47fd                	li	a5,31
    80205cb6:	f6e7d4e3          	bge	a5,a4,80205c1e <schedule+0x16>
    intr_on();
    80205cba:	bf99                	j	80205c10 <schedule+0x8>

0000000080205cbc <yield>:
void yield(void) {
    80205cbc:	1101                	addi	sp,sp,-32
    80205cbe:	ec06                	sd	ra,24(sp)
    80205cc0:	e822                	sd	s0,16(sp)
    80205cc2:	1000                	addi	s0,sp,32
	intr_off();
    80205cc4:	fffff097          	auipc	ra,0xfffff
    80205cc8:	2c4080e7          	jalr	708(ra) # 80204f88 <intr_off>
    struct proc *p = myproc();
    80205ccc:	fffff097          	auipc	ra,0xfffff
    80205cd0:	374080e7          	jalr	884(ra) # 80205040 <myproc>
    80205cd4:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    80205cd8:	fe843783          	ld	a5,-24(s0)
    80205cdc:	cfb5                	beqz	a5,80205d58 <yield+0x9c>
    struct cpu *c = mycpu();
    80205cde:	fffff097          	auipc	ra,0xfffff
    80205ce2:	37a080e7          	jalr	890(ra) # 80205058 <mycpu>
    80205ce6:	fea43023          	sd	a0,-32(s0)
    p->state = RUNNABLE;
    80205cea:	fe843783          	ld	a5,-24(s0)
    80205cee:	470d                	li	a4,3
    80205cf0:	c398                	sw	a4,0(a5)
    current_proc = 0;
    80205cf2:	00036797          	auipc	a5,0x36
    80205cf6:	3c678793          	addi	a5,a5,966 # 8023c0b8 <current_proc>
    80205cfa:	0007b023          	sd	zero,0(a5)
    c->proc = 0;
    80205cfe:	fe043783          	ld	a5,-32(s0)
    80205d02:	0007b023          	sd	zero,0(a5)
	intr_on();
    80205d06:	fffff097          	auipc	ra,0xfffff
    80205d0a:	258080e7          	jalr	600(ra) # 80204f5e <intr_on>
    swtch(&p->context, &c->context);
    80205d0e:	fe843783          	ld	a5,-24(s0)
    80205d12:	01078713          	addi	a4,a5,16
    80205d16:	fe043783          	ld	a5,-32(s0)
    80205d1a:	07a1                	addi	a5,a5,8
    80205d1c:	85be                	mv	a1,a5
    80205d1e:	853a                	mv	a0,a4
    80205d20:	fffff097          	auipc	ra,0xfffff
    80205d24:	1a0080e7          	jalr	416(ra) # 80204ec0 <swtch>
	if (p->killed) {
    80205d28:	fe843783          	ld	a5,-24(s0)
    80205d2c:	0807a783          	lw	a5,128(a5)
    80205d30:	c78d                	beqz	a5,80205d5a <yield+0x9e>
        printf("[yield] Process PID %d killed during yield\n", p->pid);
    80205d32:	fe843783          	ld	a5,-24(s0)
    80205d36:	43dc                	lw	a5,4(a5)
    80205d38:	85be                	mv	a1,a5
    80205d3a:	0001f517          	auipc	a0,0x1f
    80205d3e:	a7e50513          	addi	a0,a0,-1410 # 802247b8 <user_test_table+0x270>
    80205d42:	ffffb097          	auipc	ra,0xffffb
    80205d46:	04c080e7          	jalr	76(ra) # 80200d8e <printf>
        exit_proc(SYS_kill);
    80205d4a:	08100513          	li	a0,129
    80205d4e:	00000097          	auipc	ra,0x0
    80205d52:	1ae080e7          	jalr	430(ra) # 80205efc <exit_proc>
        return;
    80205d56:	a011                	j	80205d5a <yield+0x9e>
        return;
    80205d58:	0001                	nop
}
    80205d5a:	60e2                	ld	ra,24(sp)
    80205d5c:	6442                	ld	s0,16(sp)
    80205d5e:	6105                	addi	sp,sp,32
    80205d60:	8082                	ret

0000000080205d62 <sleep>:
void sleep(void *chan, struct spinlock *lk){
    80205d62:	7179                	addi	sp,sp,-48
    80205d64:	f406                	sd	ra,40(sp)
    80205d66:	f022                	sd	s0,32(sp)
    80205d68:	1800                	addi	s0,sp,48
    80205d6a:	fca43c23          	sd	a0,-40(s0)
    80205d6e:	fcb43823          	sd	a1,-48(s0)
	intr_off();
    80205d72:	fffff097          	auipc	ra,0xfffff
    80205d76:	216080e7          	jalr	534(ra) # 80204f88 <intr_off>
    struct proc *p = myproc();
    80205d7a:	fffff097          	auipc	ra,0xfffff
    80205d7e:	2c6080e7          	jalr	710(ra) # 80205040 <myproc>
    80205d82:	fea43423          	sd	a0,-24(s0)
    struct cpu *c = mycpu();
    80205d86:	fffff097          	auipc	ra,0xfffff
    80205d8a:	2d2080e7          	jalr	722(ra) # 80205058 <mycpu>
    80205d8e:	fea43023          	sd	a0,-32(s0)
    p->context.ra = ra;
    80205d92:	8706                	mv	a4,ra
    80205d94:	fe843783          	ld	a5,-24(s0)
    80205d98:	eb98                	sd	a4,16(a5)
    p->chan = chan;
    80205d9a:	fe843783          	ld	a5,-24(s0)
    80205d9e:	fd843703          	ld	a4,-40(s0)
    80205da2:	f3d8                	sd	a4,160(a5)
    p->state = SLEEPING;
    80205da4:	fe843783          	ld	a5,-24(s0)
    80205da8:	4709                	li	a4,2
    80205daa:	c398                	sw	a4,0(a5)
    if (lk){
    80205dac:	fd043783          	ld	a5,-48(s0)
    80205db0:	c799                	beqz	a5,80205dbe <sleep+0x5c>
        release(lk);
    80205db2:	fd043503          	ld	a0,-48(s0)
    80205db6:	00006097          	auipc	ra,0x6
    80205dba:	dbe080e7          	jalr	-578(ra) # 8020bb74 <release>
	intr_on();
    80205dbe:	fffff097          	auipc	ra,0xfffff
    80205dc2:	1a0080e7          	jalr	416(ra) # 80204f5e <intr_on>
    swtch(&p->context, &c->context);
    80205dc6:	fe843783          	ld	a5,-24(s0)
    80205dca:	01078713          	addi	a4,a5,16
    80205dce:	fe043783          	ld	a5,-32(s0)
    80205dd2:	07a1                	addi	a5,a5,8
    80205dd4:	85be                	mv	a1,a5
    80205dd6:	853a                	mv	a0,a4
    80205dd8:	fffff097          	auipc	ra,0xfffff
    80205ddc:	0e8080e7          	jalr	232(ra) # 80204ec0 <swtch>
    p->chan = 0;
    80205de0:	fe843783          	ld	a5,-24(s0)
    80205de4:	0a07b023          	sd	zero,160(a5)
    if (lk)
    80205de8:	fd043783          	ld	a5,-48(s0)
    80205dec:	c799                	beqz	a5,80205dfa <sleep+0x98>
        acquire(lk);
    80205dee:	fd043503          	ld	a0,-48(s0)
    80205df2:	00006097          	auipc	ra,0x6
    80205df6:	d36080e7          	jalr	-714(ra) # 8020bb28 <acquire>
    if(p->killed){
    80205dfa:	fe843783          	ld	a5,-24(s0)
    80205dfe:	0807a783          	lw	a5,128(a5)
    80205e02:	c799                	beqz	a5,80205e10 <sleep+0xae>
        exit_proc(SYS_kill);
    80205e04:	08100513          	li	a0,129
    80205e08:	00000097          	auipc	ra,0x0
    80205e0c:	0f4080e7          	jalr	244(ra) # 80205efc <exit_proc>
}
    80205e10:	0001                	nop
    80205e12:	70a2                	ld	ra,40(sp)
    80205e14:	7402                	ld	s0,32(sp)
    80205e16:	6145                	addi	sp,sp,48
    80205e18:	8082                	ret

0000000080205e1a <wakeup>:
void wakeup(void *chan) {
    80205e1a:	7179                	addi	sp,sp,-48
    80205e1c:	f406                	sd	ra,40(sp)
    80205e1e:	f022                	sd	s0,32(sp)
    80205e20:	1800                	addi	s0,sp,48
    80205e22:	fca43c23          	sd	a0,-40(s0)
	intr_off();
    80205e26:	fffff097          	auipc	ra,0xfffff
    80205e2a:	162080e7          	jalr	354(ra) # 80204f88 <intr_off>
    for(int i = 0; i < PROC; i++) {
    80205e2e:	fe042623          	sw	zero,-20(s0)
    80205e32:	a099                	j	80205e78 <wakeup+0x5e>
        struct proc *p = proc_table[i];
    80205e34:	00036717          	auipc	a4,0x36
    80205e38:	64470713          	addi	a4,a4,1604 # 8023c478 <proc_table>
    80205e3c:	fec42783          	lw	a5,-20(s0)
    80205e40:	078e                	slli	a5,a5,0x3
    80205e42:	97ba                	add	a5,a5,a4
    80205e44:	639c                	ld	a5,0(a5)
    80205e46:	fef43023          	sd	a5,-32(s0)
        if(p->state == SLEEPING && p->chan == chan) {
    80205e4a:	fe043783          	ld	a5,-32(s0)
    80205e4e:	439c                	lw	a5,0(a5)
    80205e50:	873e                	mv	a4,a5
    80205e52:	4789                	li	a5,2
    80205e54:	00f71d63          	bne	a4,a5,80205e6e <wakeup+0x54>
    80205e58:	fe043783          	ld	a5,-32(s0)
    80205e5c:	73dc                	ld	a5,160(a5)
    80205e5e:	fd843703          	ld	a4,-40(s0)
    80205e62:	00f71663          	bne	a4,a5,80205e6e <wakeup+0x54>
            p->state = RUNNABLE;
    80205e66:	fe043783          	ld	a5,-32(s0)
    80205e6a:	470d                	li	a4,3
    80205e6c:	c398                	sw	a4,0(a5)
    for(int i = 0; i < PROC; i++) {
    80205e6e:	fec42783          	lw	a5,-20(s0)
    80205e72:	2785                	addiw	a5,a5,1
    80205e74:	fef42623          	sw	a5,-20(s0)
    80205e78:	fec42783          	lw	a5,-20(s0)
    80205e7c:	0007871b          	sext.w	a4,a5
    80205e80:	47fd                	li	a5,31
    80205e82:	fae7d9e3          	bge	a5,a4,80205e34 <wakeup+0x1a>
	intr_on();
    80205e86:	fffff097          	auipc	ra,0xfffff
    80205e8a:	0d8080e7          	jalr	216(ra) # 80204f5e <intr_on>
}
    80205e8e:	0001                	nop
    80205e90:	70a2                	ld	ra,40(sp)
    80205e92:	7402                	ld	s0,32(sp)
    80205e94:	6145                	addi	sp,sp,48
    80205e96:	8082                	ret

0000000080205e98 <kill_proc>:
void kill_proc(int pid){
    80205e98:	7179                	addi	sp,sp,-48
    80205e9a:	f422                	sd	s0,40(sp)
    80205e9c:	1800                	addi	s0,sp,48
    80205e9e:	87aa                	mv	a5,a0
    80205ea0:	fcf42e23          	sw	a5,-36(s0)
	for(int i=0;i<PROC;i++){
    80205ea4:	fe042623          	sw	zero,-20(s0)
    80205ea8:	a83d                	j	80205ee6 <kill_proc+0x4e>
		struct proc *p = proc_table[i];
    80205eaa:	00036717          	auipc	a4,0x36
    80205eae:	5ce70713          	addi	a4,a4,1486 # 8023c478 <proc_table>
    80205eb2:	fec42783          	lw	a5,-20(s0)
    80205eb6:	078e                	slli	a5,a5,0x3
    80205eb8:	97ba                	add	a5,a5,a4
    80205eba:	639c                	ld	a5,0(a5)
    80205ebc:	fef43023          	sd	a5,-32(s0)
		if(pid == p->pid){
    80205ec0:	fe043783          	ld	a5,-32(s0)
    80205ec4:	43d8                	lw	a4,4(a5)
    80205ec6:	fdc42783          	lw	a5,-36(s0)
    80205eca:	2781                	sext.w	a5,a5
    80205ecc:	00e79863          	bne	a5,a4,80205edc <kill_proc+0x44>
			p->killed = 1;
    80205ed0:	fe043783          	ld	a5,-32(s0)
    80205ed4:	4705                	li	a4,1
    80205ed6:	08e7a023          	sw	a4,128(a5)
			break;
    80205eda:	a829                	j	80205ef4 <kill_proc+0x5c>
	for(int i=0;i<PROC;i++){
    80205edc:	fec42783          	lw	a5,-20(s0)
    80205ee0:	2785                	addiw	a5,a5,1
    80205ee2:	fef42623          	sw	a5,-20(s0)
    80205ee6:	fec42783          	lw	a5,-20(s0)
    80205eea:	0007871b          	sext.w	a4,a5
    80205eee:	47fd                	li	a5,31
    80205ef0:	fae7dde3          	bge	a5,a4,80205eaa <kill_proc+0x12>
	return;
    80205ef4:	0001                	nop
}
    80205ef6:	7422                	ld	s0,40(sp)
    80205ef8:	6145                	addi	sp,sp,48
    80205efa:	8082                	ret

0000000080205efc <exit_proc>:
void exit_proc(int status) {
    80205efc:	7179                	addi	sp,sp,-48
    80205efe:	f406                	sd	ra,40(sp)
    80205f00:	f022                	sd	s0,32(sp)
    80205f02:	1800                	addi	s0,sp,48
    80205f04:	87aa                	mv	a5,a0
    80205f06:	fcf42e23          	sw	a5,-36(s0)
    struct proc *p = myproc();
    80205f0a:	fffff097          	auipc	ra,0xfffff
    80205f0e:	136080e7          	jalr	310(ra) # 80205040 <myproc>
    80205f12:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    80205f16:	fe843783          	ld	a5,-24(s0)
    80205f1a:	eb89                	bnez	a5,80205f2c <exit_proc+0x30>
        panic("exit_proc: no current process");
    80205f1c:	0001f517          	auipc	a0,0x1f
    80205f20:	8cc50513          	addi	a0,a0,-1844 # 802247e8 <user_test_table+0x2a0>
    80205f24:	ffffc097          	auipc	ra,0xffffc
    80205f28:	8b6080e7          	jalr	-1866(ra) # 802017da <panic>
    p->exit_status = status;
    80205f2c:	fe843783          	ld	a5,-24(s0)
    80205f30:	fdc42703          	lw	a4,-36(s0)
    80205f34:	08e7a223          	sw	a4,132(a5)
    if (!p->parent) {
    80205f38:	fe843783          	ld	a5,-24(s0)
    80205f3c:	6fdc                	ld	a5,152(a5)
    80205f3e:	e789                	bnez	a5,80205f48 <exit_proc+0x4c>
        shutdown();
    80205f40:	fffff097          	auipc	ra,0xfffff
    80205f44:	0d6080e7          	jalr	214(ra) # 80205016 <shutdown>
    p->state = ZOMBIE;
    80205f48:	fe843783          	ld	a5,-24(s0)
    80205f4c:	4715                	li	a4,5
    80205f4e:	c398                	sw	a4,0(a5)
    wakeup((void*)p->parent);
    80205f50:	fe843783          	ld	a5,-24(s0)
    80205f54:	6fdc                	ld	a5,152(a5)
    80205f56:	853e                	mv	a0,a5
    80205f58:	00000097          	auipc	ra,0x0
    80205f5c:	ec2080e7          	jalr	-318(ra) # 80205e1a <wakeup>
    current_proc = 0;
    80205f60:	00036797          	auipc	a5,0x36
    80205f64:	15878793          	addi	a5,a5,344 # 8023c0b8 <current_proc>
    80205f68:	0007b023          	sd	zero,0(a5)
    if (mycpu())
    80205f6c:	fffff097          	auipc	ra,0xfffff
    80205f70:	0ec080e7          	jalr	236(ra) # 80205058 <mycpu>
    80205f74:	87aa                	mv	a5,a0
    80205f76:	cb81                	beqz	a5,80205f86 <exit_proc+0x8a>
        mycpu()->proc = 0;
    80205f78:	fffff097          	auipc	ra,0xfffff
    80205f7c:	0e0080e7          	jalr	224(ra) # 80205058 <mycpu>
    80205f80:	87aa                	mv	a5,a0
    80205f82:	0007b023          	sd	zero,0(a5)
    struct cpu *c = mycpu();
    80205f86:	fffff097          	auipc	ra,0xfffff
    80205f8a:	0d2080e7          	jalr	210(ra) # 80205058 <mycpu>
    80205f8e:	fea43023          	sd	a0,-32(s0)
    swtch(&p->context, &c->context);
    80205f92:	fe843783          	ld	a5,-24(s0)
    80205f96:	01078713          	addi	a4,a5,16
    80205f9a:	fe043783          	ld	a5,-32(s0)
    80205f9e:	07a1                	addi	a5,a5,8
    80205fa0:	85be                	mv	a1,a5
    80205fa2:	853a                	mv	a0,a4
    80205fa4:	fffff097          	auipc	ra,0xfffff
    80205fa8:	f1c080e7          	jalr	-228(ra) # 80204ec0 <swtch>
    panic("exit_proc should not return after schedule");
    80205fac:	0001f517          	auipc	a0,0x1f
    80205fb0:	85c50513          	addi	a0,a0,-1956 # 80224808 <user_test_table+0x2c0>
    80205fb4:	ffffc097          	auipc	ra,0xffffc
    80205fb8:	826080e7          	jalr	-2010(ra) # 802017da <panic>
}
    80205fbc:	0001                	nop
    80205fbe:	70a2                	ld	ra,40(sp)
    80205fc0:	7402                	ld	s0,32(sp)
    80205fc2:	6145                	addi	sp,sp,48
    80205fc4:	8082                	ret

0000000080205fc6 <wait_proc>:
int wait_proc(int *status) {
    80205fc6:	711d                	addi	sp,sp,-96
    80205fc8:	ec86                	sd	ra,88(sp)
    80205fca:	e8a2                	sd	s0,80(sp)
    80205fcc:	1080                	addi	s0,sp,96
    80205fce:	faa43423          	sd	a0,-88(s0)
    struct proc *p = myproc();
    80205fd2:	fffff097          	auipc	ra,0xfffff
    80205fd6:	06e080e7          	jalr	110(ra) # 80205040 <myproc>
    80205fda:	fca43023          	sd	a0,-64(s0)
    if (p == 0) {
    80205fde:	fc043783          	ld	a5,-64(s0)
    80205fe2:	eb99                	bnez	a5,80205ff8 <wait_proc+0x32>
        printf("Warning: wait_proc called with no current process\n");
    80205fe4:	0001f517          	auipc	a0,0x1f
    80205fe8:	85450513          	addi	a0,a0,-1964 # 80224838 <user_test_table+0x2f0>
    80205fec:	ffffb097          	auipc	ra,0xffffb
    80205ff0:	da2080e7          	jalr	-606(ra) # 80200d8e <printf>
        return -1;
    80205ff4:	57fd                	li	a5,-1
    80205ff6:	aa81                	j	80206146 <wait_proc+0x180>
        intr_off();
    80205ff8:	fffff097          	auipc	ra,0xfffff
    80205ffc:	f90080e7          	jalr	-112(ra) # 80204f88 <intr_off>
        int found_zombie = 0;
    80206000:	fe042623          	sw	zero,-20(s0)
        int zombie_pid = 0;
    80206004:	fe042423          	sw	zero,-24(s0)
        int zombie_status = 0;
    80206008:	fe042223          	sw	zero,-28(s0)
        struct proc *zombie_child = 0;
    8020600c:	fc043c23          	sd	zero,-40(s0)
        for (int i = 0; i < PROC; i++) {
    80206010:	fc042a23          	sw	zero,-44(s0)
    80206014:	a095                	j	80206078 <wait_proc+0xb2>
            struct proc *child = proc_table[i];
    80206016:	00036717          	auipc	a4,0x36
    8020601a:	46270713          	addi	a4,a4,1122 # 8023c478 <proc_table>
    8020601e:	fd442783          	lw	a5,-44(s0)
    80206022:	078e                	slli	a5,a5,0x3
    80206024:	97ba                	add	a5,a5,a4
    80206026:	639c                	ld	a5,0(a5)
    80206028:	faf43c23          	sd	a5,-72(s0)
            if (child->state == ZOMBIE && child->parent == p) {
    8020602c:	fb843783          	ld	a5,-72(s0)
    80206030:	439c                	lw	a5,0(a5)
    80206032:	873e                	mv	a4,a5
    80206034:	4795                	li	a5,5
    80206036:	02f71c63          	bne	a4,a5,8020606e <wait_proc+0xa8>
    8020603a:	fb843783          	ld	a5,-72(s0)
    8020603e:	6fdc                	ld	a5,152(a5)
    80206040:	fc043703          	ld	a4,-64(s0)
    80206044:	02f71563          	bne	a4,a5,8020606e <wait_proc+0xa8>
                found_zombie = 1;
    80206048:	4785                	li	a5,1
    8020604a:	fef42623          	sw	a5,-20(s0)
                zombie_pid = child->pid;
    8020604e:	fb843783          	ld	a5,-72(s0)
    80206052:	43dc                	lw	a5,4(a5)
    80206054:	fef42423          	sw	a5,-24(s0)
                zombie_status = child->exit_status;
    80206058:	fb843783          	ld	a5,-72(s0)
    8020605c:	0847a783          	lw	a5,132(a5)
    80206060:	fef42223          	sw	a5,-28(s0)
                zombie_child = child;
    80206064:	fb843783          	ld	a5,-72(s0)
    80206068:	fcf43c23          	sd	a5,-40(s0)
                break;
    8020606c:	a829                	j	80206086 <wait_proc+0xc0>
        for (int i = 0; i < PROC; i++) {
    8020606e:	fd442783          	lw	a5,-44(s0)
    80206072:	2785                	addiw	a5,a5,1
    80206074:	fcf42a23          	sw	a5,-44(s0)
    80206078:	fd442783          	lw	a5,-44(s0)
    8020607c:	0007871b          	sext.w	a4,a5
    80206080:	47fd                	li	a5,31
    80206082:	f8e7dae3          	bge	a5,a4,80206016 <wait_proc+0x50>
        if (found_zombie) {
    80206086:	fec42783          	lw	a5,-20(s0)
    8020608a:	2781                	sext.w	a5,a5
    8020608c:	cb85                	beqz	a5,802060bc <wait_proc+0xf6>
            if (status)
    8020608e:	fa843783          	ld	a5,-88(s0)
    80206092:	c791                	beqz	a5,8020609e <wait_proc+0xd8>
                *status = zombie_status;
    80206094:	fa843783          	ld	a5,-88(s0)
    80206098:	fe442703          	lw	a4,-28(s0)
    8020609c:	c398                	sw	a4,0(a5)
			intr_on();
    8020609e:	fffff097          	auipc	ra,0xfffff
    802060a2:	ec0080e7          	jalr	-320(ra) # 80204f5e <intr_on>
            free_proc(zombie_child);
    802060a6:	fd843503          	ld	a0,-40(s0)
    802060aa:	fffff097          	auipc	ra,0xfffff
    802060ae:	53c080e7          	jalr	1340(ra) # 802055e6 <free_proc>
            zombie_child = NULL;
    802060b2:	fc043c23          	sd	zero,-40(s0)
            return zombie_pid;
    802060b6:	fe842783          	lw	a5,-24(s0)
    802060ba:	a071                	j	80206146 <wait_proc+0x180>
        int havekids = 0;
    802060bc:	fc042823          	sw	zero,-48(s0)
        for (int i = 0; i < PROC; i++) {
    802060c0:	fc042623          	sw	zero,-52(s0)
    802060c4:	a0b9                	j	80206112 <wait_proc+0x14c>
            struct proc *child = proc_table[i];
    802060c6:	00036717          	auipc	a4,0x36
    802060ca:	3b270713          	addi	a4,a4,946 # 8023c478 <proc_table>
    802060ce:	fcc42783          	lw	a5,-52(s0)
    802060d2:	078e                	slli	a5,a5,0x3
    802060d4:	97ba                	add	a5,a5,a4
    802060d6:	639c                	ld	a5,0(a5)
    802060d8:	faf43823          	sd	a5,-80(s0)
            if (child->state != UNUSED && child->state != ZOMBIE && child->parent == p) {
    802060dc:	fb043783          	ld	a5,-80(s0)
    802060e0:	439c                	lw	a5,0(a5)
    802060e2:	c39d                	beqz	a5,80206108 <wait_proc+0x142>
    802060e4:	fb043783          	ld	a5,-80(s0)
    802060e8:	439c                	lw	a5,0(a5)
    802060ea:	873e                	mv	a4,a5
    802060ec:	4795                	li	a5,5
    802060ee:	00f70d63          	beq	a4,a5,80206108 <wait_proc+0x142>
    802060f2:	fb043783          	ld	a5,-80(s0)
    802060f6:	6fdc                	ld	a5,152(a5)
    802060f8:	fc043703          	ld	a4,-64(s0)
    802060fc:	00f71663          	bne	a4,a5,80206108 <wait_proc+0x142>
                havekids = 1;
    80206100:	4785                	li	a5,1
    80206102:	fcf42823          	sw	a5,-48(s0)
                break;
    80206106:	a829                	j	80206120 <wait_proc+0x15a>
        for (int i = 0; i < PROC; i++) {
    80206108:	fcc42783          	lw	a5,-52(s0)
    8020610c:	2785                	addiw	a5,a5,1
    8020610e:	fcf42623          	sw	a5,-52(s0)
    80206112:	fcc42783          	lw	a5,-52(s0)
    80206116:	0007871b          	sext.w	a4,a5
    8020611a:	47fd                	li	a5,31
    8020611c:	fae7d5e3          	bge	a5,a4,802060c6 <wait_proc+0x100>
        if (!havekids) {
    80206120:	fd042783          	lw	a5,-48(s0)
    80206124:	2781                	sext.w	a5,a5
    80206126:	e799                	bnez	a5,80206134 <wait_proc+0x16e>
            intr_on();
    80206128:	fffff097          	auipc	ra,0xfffff
    8020612c:	e36080e7          	jalr	-458(ra) # 80204f5e <intr_on>
            return -1;
    80206130:	57fd                	li	a5,-1
    80206132:	a811                	j	80206146 <wait_proc+0x180>
		intr_on();
    80206134:	fffff097          	auipc	ra,0xfffff
    80206138:	e2a080e7          	jalr	-470(ra) # 80204f5e <intr_on>
        yield();
    8020613c:	00000097          	auipc	ra,0x0
    80206140:	b80080e7          	jalr	-1152(ra) # 80205cbc <yield>
    while (1) {
    80206144:	bd55                	j	80205ff8 <wait_proc+0x32>
}
    80206146:	853e                	mv	a0,a5
    80206148:	60e6                	ld	ra,88(sp)
    8020614a:	6446                	ld	s0,80(sp)
    8020614c:	6125                	addi	sp,sp,96
    8020614e:	8082                	ret

0000000080206150 <print_proc_table>:
void print_proc_table(void) {
    80206150:	715d                	addi	sp,sp,-80
    80206152:	e486                	sd	ra,72(sp)
    80206154:	e0a2                	sd	s0,64(sp)
    80206156:	0880                	addi	s0,sp,80
    int count = 0;
    80206158:	fe042623          	sw	zero,-20(s0)
    printf("PID  TYPE STATUS     PPID   FUNC_ADDR      STACK_ADDR    \n");
    8020615c:	0001e517          	auipc	a0,0x1e
    80206160:	71450513          	addi	a0,a0,1812 # 80224870 <user_test_table+0x328>
    80206164:	ffffb097          	auipc	ra,0xffffb
    80206168:	c2a080e7          	jalr	-982(ra) # 80200d8e <printf>
    printf("----------------------------------------------------------\n");
    8020616c:	0001e517          	auipc	a0,0x1e
    80206170:	74450513          	addi	a0,a0,1860 # 802248b0 <user_test_table+0x368>
    80206174:	ffffb097          	auipc	ra,0xffffb
    80206178:	c1a080e7          	jalr	-998(ra) # 80200d8e <printf>
    for(int i = 0; i < PROC; i++) {
    8020617c:	fe042423          	sw	zero,-24(s0)
    80206180:	a2a9                	j	802062ca <print_proc_table+0x17a>
        struct proc *p = proc_table[i];
    80206182:	00036717          	auipc	a4,0x36
    80206186:	2f670713          	addi	a4,a4,758 # 8023c478 <proc_table>
    8020618a:	fe842783          	lw	a5,-24(s0)
    8020618e:	078e                	slli	a5,a5,0x3
    80206190:	97ba                	add	a5,a5,a4
    80206192:	639c                	ld	a5,0(a5)
    80206194:	fcf43c23          	sd	a5,-40(s0)
        if(p->state != UNUSED) {
    80206198:	fd843783          	ld	a5,-40(s0)
    8020619c:	439c                	lw	a5,0(a5)
    8020619e:	12078163          	beqz	a5,802062c0 <print_proc_table+0x170>
            count++;
    802061a2:	fec42783          	lw	a5,-20(s0)
    802061a6:	2785                	addiw	a5,a5,1
    802061a8:	fef42623          	sw	a5,-20(s0)
            const char *type = (p->is_user ? "USR" : "SYS");
    802061ac:	fd843783          	ld	a5,-40(s0)
    802061b0:	0a87a783          	lw	a5,168(a5)
    802061b4:	c791                	beqz	a5,802061c0 <print_proc_table+0x70>
    802061b6:	0001e797          	auipc	a5,0x1e
    802061ba:	73a78793          	addi	a5,a5,1850 # 802248f0 <user_test_table+0x3a8>
    802061be:	a029                	j	802061c8 <print_proc_table+0x78>
    802061c0:	0001e797          	auipc	a5,0x1e
    802061c4:	73878793          	addi	a5,a5,1848 # 802248f8 <user_test_table+0x3b0>
    802061c8:	fcf43823          	sd	a5,-48(s0)
            switch(p->state) {
    802061cc:	fd843783          	ld	a5,-40(s0)
    802061d0:	439c                	lw	a5,0(a5)
    802061d2:	86be                	mv	a3,a5
    802061d4:	4715                	li	a4,5
    802061d6:	06d76c63          	bltu	a4,a3,8020624e <print_proc_table+0xfe>
    802061da:	00279713          	slli	a4,a5,0x2
    802061de:	0001e797          	auipc	a5,0x1e
    802061e2:	7a278793          	addi	a5,a5,1954 # 80224980 <user_test_table+0x438>
    802061e6:	97ba                	add	a5,a5,a4
    802061e8:	439c                	lw	a5,0(a5)
    802061ea:	0007871b          	sext.w	a4,a5
    802061ee:	0001e797          	auipc	a5,0x1e
    802061f2:	79278793          	addi	a5,a5,1938 # 80224980 <user_test_table+0x438>
    802061f6:	97ba                	add	a5,a5,a4
    802061f8:	8782                	jr	a5
                case UNUSED:   status = "UNUSED"; break;
    802061fa:	0001e797          	auipc	a5,0x1e
    802061fe:	70678793          	addi	a5,a5,1798 # 80224900 <user_test_table+0x3b8>
    80206202:	fef43023          	sd	a5,-32(s0)
    80206206:	a899                	j	8020625c <print_proc_table+0x10c>
                case USED:     status = "USED"; break;
    80206208:	0001e797          	auipc	a5,0x1e
    8020620c:	70078793          	addi	a5,a5,1792 # 80224908 <user_test_table+0x3c0>
    80206210:	fef43023          	sd	a5,-32(s0)
    80206214:	a0a1                	j	8020625c <print_proc_table+0x10c>
                case SLEEPING: status = "SLEEP"; break;
    80206216:	0001e797          	auipc	a5,0x1e
    8020621a:	6fa78793          	addi	a5,a5,1786 # 80224910 <user_test_table+0x3c8>
    8020621e:	fef43023          	sd	a5,-32(s0)
    80206222:	a82d                	j	8020625c <print_proc_table+0x10c>
                case RUNNABLE: status = "RUNNABLE"; break;
    80206224:	0001e797          	auipc	a5,0x1e
    80206228:	6f478793          	addi	a5,a5,1780 # 80224918 <user_test_table+0x3d0>
    8020622c:	fef43023          	sd	a5,-32(s0)
    80206230:	a035                	j	8020625c <print_proc_table+0x10c>
                case RUNNING:  status = "RUNNING"; break;
    80206232:	0001e797          	auipc	a5,0x1e
    80206236:	6f678793          	addi	a5,a5,1782 # 80224928 <user_test_table+0x3e0>
    8020623a:	fef43023          	sd	a5,-32(s0)
    8020623e:	a839                	j	8020625c <print_proc_table+0x10c>
                case ZOMBIE:   status = "ZOMBIE"; break;
    80206240:	0001e797          	auipc	a5,0x1e
    80206244:	6f078793          	addi	a5,a5,1776 # 80224930 <user_test_table+0x3e8>
    80206248:	fef43023          	sd	a5,-32(s0)
    8020624c:	a801                	j	8020625c <print_proc_table+0x10c>
                default:       status = "UNKNOWN"; break;
    8020624e:	0001e797          	auipc	a5,0x1e
    80206252:	6ea78793          	addi	a5,a5,1770 # 80224938 <user_test_table+0x3f0>
    80206256:	fef43023          	sd	a5,-32(s0)
    8020625a:	0001                	nop
            int ppid = p->parent ? p->parent->pid : -1;
    8020625c:	fd843783          	ld	a5,-40(s0)
    80206260:	6fdc                	ld	a5,152(a5)
    80206262:	c791                	beqz	a5,8020626e <print_proc_table+0x11e>
    80206264:	fd843783          	ld	a5,-40(s0)
    80206268:	6fdc                	ld	a5,152(a5)
    8020626a:	43dc                	lw	a5,4(a5)
    8020626c:	a011                	j	80206270 <print_proc_table+0x120>
    8020626e:	57fd                	li	a5,-1
    80206270:	fcf42623          	sw	a5,-52(s0)
            unsigned long func_addr = p->trapframe ? p->trapframe->epc : 0;
    80206274:	fd843783          	ld	a5,-40(s0)
    80206278:	63fc                	ld	a5,192(a5)
    8020627a:	c791                	beqz	a5,80206286 <print_proc_table+0x136>
    8020627c:	fd843783          	ld	a5,-40(s0)
    80206280:	63fc                	ld	a5,192(a5)
    80206282:	7f9c                	ld	a5,56(a5)
    80206284:	a011                	j	80206288 <print_proc_table+0x138>
    80206286:	4781                	li	a5,0
    80206288:	fcf43023          	sd	a5,-64(s0)
            unsigned long stack_addr = p->kstack;
    8020628c:	fd843783          	ld	a5,-40(s0)
    80206290:	679c                	ld	a5,8(a5)
    80206292:	faf43c23          	sd	a5,-72(s0)
            printf("%2d  %3s %8s %4d 0x%012lx 0x%012lx\n",
    80206296:	fd843783          	ld	a5,-40(s0)
    8020629a:	43cc                	lw	a1,4(a5)
    8020629c:	fcc42703          	lw	a4,-52(s0)
    802062a0:	fb843803          	ld	a6,-72(s0)
    802062a4:	fc043783          	ld	a5,-64(s0)
    802062a8:	fe043683          	ld	a3,-32(s0)
    802062ac:	fd043603          	ld	a2,-48(s0)
    802062b0:	0001e517          	auipc	a0,0x1e
    802062b4:	69050513          	addi	a0,a0,1680 # 80224940 <user_test_table+0x3f8>
    802062b8:	ffffb097          	auipc	ra,0xffffb
    802062bc:	ad6080e7          	jalr	-1322(ra) # 80200d8e <printf>
    for(int i = 0; i < PROC; i++) {
    802062c0:	fe842783          	lw	a5,-24(s0)
    802062c4:	2785                	addiw	a5,a5,1
    802062c6:	fef42423          	sw	a5,-24(s0)
    802062ca:	fe842783          	lw	a5,-24(s0)
    802062ce:	0007871b          	sext.w	a4,a5
    802062d2:	47fd                	li	a5,31
    802062d4:	eae7d7e3          	bge	a5,a4,80206182 <print_proc_table+0x32>
    printf("----------------------------------------------------------\n");
    802062d8:	0001e517          	auipc	a0,0x1e
    802062dc:	5d850513          	addi	a0,a0,1496 # 802248b0 <user_test_table+0x368>
    802062e0:	ffffb097          	auipc	ra,0xffffb
    802062e4:	aae080e7          	jalr	-1362(ra) # 80200d8e <printf>
    printf("%d active processes\n", count);
    802062e8:	fec42783          	lw	a5,-20(s0)
    802062ec:	85be                	mv	a1,a5
    802062ee:	0001e517          	auipc	a0,0x1e
    802062f2:	67a50513          	addi	a0,a0,1658 # 80224968 <user_test_table+0x420>
    802062f6:	ffffb097          	auipc	ra,0xffffb
    802062fa:	a98080e7          	jalr	-1384(ra) # 80200d8e <printf>
}
    802062fe:	0001                	nop
    80206300:	60a6                	ld	ra,72(sp)
    80206302:	6406                	ld	s0,64(sp)
    80206304:	6161                	addi	sp,sp,80
    80206306:	8082                	ret

0000000080206308 <get_proc>:
struct proc* get_proc(int pid){
    80206308:	7179                	addi	sp,sp,-48
    8020630a:	f422                	sd	s0,40(sp)
    8020630c:	1800                	addi	s0,sp,48
    8020630e:	87aa                	mv	a5,a0
    80206310:	fcf42e23          	sw	a5,-36(s0)
    if (pid < 0 || pid >= PROC) {
    80206314:	fdc42783          	lw	a5,-36(s0)
    80206318:	2781                	sext.w	a5,a5
    8020631a:	0007c963          	bltz	a5,8020632c <get_proc+0x24>
    8020631e:	fdc42783          	lw	a5,-36(s0)
    80206322:	0007871b          	sext.w	a4,a5
    80206326:	47fd                	li	a5,31
    80206328:	00e7d463          	bge	a5,a4,80206330 <get_proc+0x28>
        return 0;
    8020632c:	4781                	li	a5,0
    8020632e:	a899                	j	80206384 <get_proc+0x7c>
    for (int i = 0; i < PROC; i++) {
    80206330:	fe042623          	sw	zero,-20(s0)
    80206334:	a081                	j	80206374 <get_proc+0x6c>
        struct proc *p = proc_table[i];
    80206336:	00036717          	auipc	a4,0x36
    8020633a:	14270713          	addi	a4,a4,322 # 8023c478 <proc_table>
    8020633e:	fec42783          	lw	a5,-20(s0)
    80206342:	078e                	slli	a5,a5,0x3
    80206344:	97ba                	add	a5,a5,a4
    80206346:	639c                	ld	a5,0(a5)
    80206348:	fef43023          	sd	a5,-32(s0)
        if (p->state != UNUSED && p->pid == pid) {
    8020634c:	fe043783          	ld	a5,-32(s0)
    80206350:	439c                	lw	a5,0(a5)
    80206352:	cf81                	beqz	a5,8020636a <get_proc+0x62>
    80206354:	fe043783          	ld	a5,-32(s0)
    80206358:	43d8                	lw	a4,4(a5)
    8020635a:	fdc42783          	lw	a5,-36(s0)
    8020635e:	2781                	sext.w	a5,a5
    80206360:	00e79563          	bne	a5,a4,8020636a <get_proc+0x62>
            return p;
    80206364:	fe043783          	ld	a5,-32(s0)
    80206368:	a831                	j	80206384 <get_proc+0x7c>
    for (int i = 0; i < PROC; i++) {
    8020636a:	fec42783          	lw	a5,-20(s0)
    8020636e:	2785                	addiw	a5,a5,1
    80206370:	fef42623          	sw	a5,-20(s0)
    80206374:	fec42783          	lw	a5,-20(s0)
    80206378:	0007871b          	sext.w	a4,a5
    8020637c:	47fd                	li	a5,31
    8020637e:	fae7dce3          	bge	a5,a4,80206336 <get_proc+0x2e>
    return 0;
    80206382:	4781                	li	a5,0
    80206384:	853e                	mv	a0,a5
    80206386:	7422                	ld	s0,40(sp)
    80206388:	6145                	addi	sp,sp,48
    8020638a:	8082                	ret

000000008020638c <strlen>:
#include "defs.h"

// 计算字符串长度
int strlen(const char *s) {
    8020638c:	7179                	addi	sp,sp,-48
    8020638e:	f422                	sd	s0,40(sp)
    80206390:	1800                	addi	s0,sp,48
    80206392:	fca43c23          	sd	a0,-40(s0)
    int n;
    for(n = 0; s[n]; n++)
    80206396:	fe042623          	sw	zero,-20(s0)
    8020639a:	a031                	j	802063a6 <strlen+0x1a>
    8020639c:	fec42783          	lw	a5,-20(s0)
    802063a0:	2785                	addiw	a5,a5,1
    802063a2:	fef42623          	sw	a5,-20(s0)
    802063a6:	fec42783          	lw	a5,-20(s0)
    802063aa:	fd843703          	ld	a4,-40(s0)
    802063ae:	97ba                	add	a5,a5,a4
    802063b0:	0007c783          	lbu	a5,0(a5)
    802063b4:	f7e5                	bnez	a5,8020639c <strlen+0x10>
        ;
    return n;
    802063b6:	fec42783          	lw	a5,-20(s0)
}
    802063ba:	853e                	mv	a0,a5
    802063bc:	7422                	ld	s0,40(sp)
    802063be:	6145                	addi	sp,sp,48
    802063c0:	8082                	ret

00000000802063c2 <strcmp>:

// 字符串比较
int strcmp(const char *p, const char *q) {
    802063c2:	1101                	addi	sp,sp,-32
    802063c4:	ec22                	sd	s0,24(sp)
    802063c6:	1000                	addi	s0,sp,32
    802063c8:	fea43423          	sd	a0,-24(s0)
    802063cc:	feb43023          	sd	a1,-32(s0)
    while(*p && *p == *q)
    802063d0:	a819                	j	802063e6 <strcmp+0x24>
        p++, q++;
    802063d2:	fe843783          	ld	a5,-24(s0)
    802063d6:	0785                	addi	a5,a5,1
    802063d8:	fef43423          	sd	a5,-24(s0)
    802063dc:	fe043783          	ld	a5,-32(s0)
    802063e0:	0785                	addi	a5,a5,1
    802063e2:	fef43023          	sd	a5,-32(s0)
    while(*p && *p == *q)
    802063e6:	fe843783          	ld	a5,-24(s0)
    802063ea:	0007c783          	lbu	a5,0(a5)
    802063ee:	cb99                	beqz	a5,80206404 <strcmp+0x42>
    802063f0:	fe843783          	ld	a5,-24(s0)
    802063f4:	0007c703          	lbu	a4,0(a5)
    802063f8:	fe043783          	ld	a5,-32(s0)
    802063fc:	0007c783          	lbu	a5,0(a5)
    80206400:	fcf709e3          	beq	a4,a5,802063d2 <strcmp+0x10>
    return (uchar)*p - (uchar)*q;
    80206404:	fe843783          	ld	a5,-24(s0)
    80206408:	0007c783          	lbu	a5,0(a5)
    8020640c:	0007871b          	sext.w	a4,a5
    80206410:	fe043783          	ld	a5,-32(s0)
    80206414:	0007c783          	lbu	a5,0(a5)
    80206418:	2781                	sext.w	a5,a5
    8020641a:	40f707bb          	subw	a5,a4,a5
    8020641e:	2781                	sext.w	a5,a5
}
    80206420:	853e                	mv	a0,a5
    80206422:	6462                	ld	s0,24(sp)
    80206424:	6105                	addi	sp,sp,32
    80206426:	8082                	ret

0000000080206428 <strcpy>:

// 字符串复制
char* strcpy(char *s, const char *t) {
    80206428:	7179                	addi	sp,sp,-48
    8020642a:	f422                	sd	s0,40(sp)
    8020642c:	1800                	addi	s0,sp,48
    8020642e:	fca43c23          	sd	a0,-40(s0)
    80206432:	fcb43823          	sd	a1,-48(s0)
    char *os;
    
    os = s;
    80206436:	fd843783          	ld	a5,-40(s0)
    8020643a:	fef43423          	sd	a5,-24(s0)
    while((*s++ = *t++) != 0)
    8020643e:	0001                	nop
    80206440:	fd043703          	ld	a4,-48(s0)
    80206444:	00170793          	addi	a5,a4,1
    80206448:	fcf43823          	sd	a5,-48(s0)
    8020644c:	fd843783          	ld	a5,-40(s0)
    80206450:	00178693          	addi	a3,a5,1
    80206454:	fcd43c23          	sd	a3,-40(s0)
    80206458:	00074703          	lbu	a4,0(a4)
    8020645c:	00e78023          	sb	a4,0(a5)
    80206460:	0007c783          	lbu	a5,0(a5)
    80206464:	fff1                	bnez	a5,80206440 <strcpy+0x18>
        ;
    return os;
    80206466:	fe843783          	ld	a5,-24(s0)
}
    8020646a:	853e                	mv	a0,a5
    8020646c:	7422                	ld	s0,40(sp)
    8020646e:	6145                	addi	sp,sp,48
    80206470:	8082                	ret

0000000080206472 <safestrcpy>:

// 安全的字符串复制（指定最大长度）
char* safestrcpy(char *s, const char *t, int n) {
    80206472:	7139                	addi	sp,sp,-64
    80206474:	fc22                	sd	s0,56(sp)
    80206476:	0080                	addi	s0,sp,64
    80206478:	fca43c23          	sd	a0,-40(s0)
    8020647c:	fcb43823          	sd	a1,-48(s0)
    80206480:	87b2                	mv	a5,a2
    80206482:	fcf42623          	sw	a5,-52(s0)
    char *os;
    
    os = s;
    80206486:	fd843783          	ld	a5,-40(s0)
    8020648a:	fef43423          	sd	a5,-24(s0)
    if(n <= 0)
    8020648e:	fcc42783          	lw	a5,-52(s0)
    80206492:	2781                	sext.w	a5,a5
    80206494:	00f04563          	bgtz	a5,8020649e <safestrcpy+0x2c>
        return os;
    80206498:	fe843783          	ld	a5,-24(s0)
    8020649c:	a0a9                	j	802064e6 <safestrcpy+0x74>
    while(--n > 0 && (*s++ = *t++) != 0)
    8020649e:	0001                	nop
    802064a0:	fcc42783          	lw	a5,-52(s0)
    802064a4:	37fd                	addiw	a5,a5,-1
    802064a6:	fcf42623          	sw	a5,-52(s0)
    802064aa:	fcc42783          	lw	a5,-52(s0)
    802064ae:	2781                	sext.w	a5,a5
    802064b0:	02f05563          	blez	a5,802064da <safestrcpy+0x68>
    802064b4:	fd043703          	ld	a4,-48(s0)
    802064b8:	00170793          	addi	a5,a4,1
    802064bc:	fcf43823          	sd	a5,-48(s0)
    802064c0:	fd843783          	ld	a5,-40(s0)
    802064c4:	00178693          	addi	a3,a5,1
    802064c8:	fcd43c23          	sd	a3,-40(s0)
    802064cc:	00074703          	lbu	a4,0(a4)
    802064d0:	00e78023          	sb	a4,0(a5)
    802064d4:	0007c783          	lbu	a5,0(a5)
    802064d8:	f7e1                	bnez	a5,802064a0 <safestrcpy+0x2e>
        ;
    *s = 0;
    802064da:	fd843783          	ld	a5,-40(s0)
    802064de:	00078023          	sb	zero,0(a5)
    return os;
    802064e2:	fe843783          	ld	a5,-24(s0)
}
    802064e6:	853e                	mv	a0,a5
    802064e8:	7462                	ld	s0,56(sp)
    802064ea:	6121                	addi	sp,sp,64
    802064ec:	8082                	ret

00000000802064ee <atoi>:
// 将字符串转换为整数
int atoi(const char *s) {
    802064ee:	7179                	addi	sp,sp,-48
    802064f0:	f422                	sd	s0,40(sp)
    802064f2:	1800                	addi	s0,sp,48
    802064f4:	fca43c23          	sd	a0,-40(s0)
    int n = 0;
    802064f8:	fe042623          	sw	zero,-20(s0)
    int sign = 1;  // 正负号
    802064fc:	4785                	li	a5,1
    802064fe:	fef42423          	sw	a5,-24(s0)

    // 跳过空白字符
    while (*s == ' ' || *s == '\t') {
    80206502:	a031                	j	8020650e <atoi+0x20>
        s++;
    80206504:	fd843783          	ld	a5,-40(s0)
    80206508:	0785                	addi	a5,a5,1
    8020650a:	fcf43c23          	sd	a5,-40(s0)
    while (*s == ' ' || *s == '\t') {
    8020650e:	fd843783          	ld	a5,-40(s0)
    80206512:	0007c783          	lbu	a5,0(a5)
    80206516:	873e                	mv	a4,a5
    80206518:	02000793          	li	a5,32
    8020651c:	fef704e3          	beq	a4,a5,80206504 <atoi+0x16>
    80206520:	fd843783          	ld	a5,-40(s0)
    80206524:	0007c783          	lbu	a5,0(a5)
    80206528:	873e                	mv	a4,a5
    8020652a:	47a5                	li	a5,9
    8020652c:	fcf70ce3          	beq	a4,a5,80206504 <atoi+0x16>
    }

    // 处理符号
    if (*s == '-') {
    80206530:	fd843783          	ld	a5,-40(s0)
    80206534:	0007c783          	lbu	a5,0(a5)
    80206538:	873e                	mv	a4,a5
    8020653a:	02d00793          	li	a5,45
    8020653e:	00f71b63          	bne	a4,a5,80206554 <atoi+0x66>
        sign = -1;
    80206542:	57fd                	li	a5,-1
    80206544:	fef42423          	sw	a5,-24(s0)
        s++;
    80206548:	fd843783          	ld	a5,-40(s0)
    8020654c:	0785                	addi	a5,a5,1
    8020654e:	fcf43c23          	sd	a5,-40(s0)
    80206552:	a899                	j	802065a8 <atoi+0xba>
    } else if (*s == '+') {
    80206554:	fd843783          	ld	a5,-40(s0)
    80206558:	0007c783          	lbu	a5,0(a5)
    8020655c:	873e                	mv	a4,a5
    8020655e:	02b00793          	li	a5,43
    80206562:	04f71363          	bne	a4,a5,802065a8 <atoi+0xba>
        s++;
    80206566:	fd843783          	ld	a5,-40(s0)
    8020656a:	0785                	addi	a5,a5,1
    8020656c:	fcf43c23          	sd	a5,-40(s0)
    }

    // 转换数字字符
    while (*s >= '0' && *s <= '9') {
    80206570:	a825                	j	802065a8 <atoi+0xba>
        n = n * 10 + (*s - '0');
    80206572:	fec42783          	lw	a5,-20(s0)
    80206576:	873e                	mv	a4,a5
    80206578:	87ba                	mv	a5,a4
    8020657a:	0027979b          	slliw	a5,a5,0x2
    8020657e:	9fb9                	addw	a5,a5,a4
    80206580:	0017979b          	slliw	a5,a5,0x1
    80206584:	0007871b          	sext.w	a4,a5
    80206588:	fd843783          	ld	a5,-40(s0)
    8020658c:	0007c783          	lbu	a5,0(a5)
    80206590:	2781                	sext.w	a5,a5
    80206592:	fd07879b          	addiw	a5,a5,-48
    80206596:	2781                	sext.w	a5,a5
    80206598:	9fb9                	addw	a5,a5,a4
    8020659a:	fef42623          	sw	a5,-20(s0)
        s++;
    8020659e:	fd843783          	ld	a5,-40(s0)
    802065a2:	0785                	addi	a5,a5,1
    802065a4:	fcf43c23          	sd	a5,-40(s0)
    while (*s >= '0' && *s <= '9') {
    802065a8:	fd843783          	ld	a5,-40(s0)
    802065ac:	0007c783          	lbu	a5,0(a5)
    802065b0:	873e                	mv	a4,a5
    802065b2:	02f00793          	li	a5,47
    802065b6:	00e7fb63          	bgeu	a5,a4,802065cc <atoi+0xde>
    802065ba:	fd843783          	ld	a5,-40(s0)
    802065be:	0007c783          	lbu	a5,0(a5)
    802065c2:	873e                	mv	a4,a5
    802065c4:	03900793          	li	a5,57
    802065c8:	fae7f5e3          	bgeu	a5,a4,80206572 <atoi+0x84>
    }

    return sign * n;
    802065cc:	fe842783          	lw	a5,-24(s0)
    802065d0:	873e                	mv	a4,a5
    802065d2:	fec42783          	lw	a5,-20(s0)
    802065d6:	02f707bb          	mulw	a5,a4,a5
    802065da:	2781                	sext.w	a5,a5
}
    802065dc:	853e                	mv	a0,a5
    802065de:	7422                	ld	s0,40(sp)
    802065e0:	6145                	addi	sp,sp,48
    802065e2:	8082                	ret

00000000802065e4 <strncmp>:
// 比较字符串前 n 个字符
int strncmp(const char *s, const char *t, int n) {
    802065e4:	7179                	addi	sp,sp,-48
    802065e6:	f422                	sd	s0,40(sp)
    802065e8:	1800                	addi	s0,sp,48
    802065ea:	fea43423          	sd	a0,-24(s0)
    802065ee:	feb43023          	sd	a1,-32(s0)
    802065f2:	87b2                	mv	a5,a2
    802065f4:	fcf42e23          	sw	a5,-36(s0)
    while(n > 0 && *s && *t) {
    802065f8:	a889                	j	8020664a <strncmp+0x66>
        if(*s != *t)
    802065fa:	fe843783          	ld	a5,-24(s0)
    802065fe:	0007c703          	lbu	a4,0(a5)
    80206602:	fe043783          	ld	a5,-32(s0)
    80206606:	0007c783          	lbu	a5,0(a5)
    8020660a:	02f70163          	beq	a4,a5,8020662c <strncmp+0x48>
            return (uchar)*s - (uchar)*t;
    8020660e:	fe843783          	ld	a5,-24(s0)
    80206612:	0007c783          	lbu	a5,0(a5)
    80206616:	0007871b          	sext.w	a4,a5
    8020661a:	fe043783          	ld	a5,-32(s0)
    8020661e:	0007c783          	lbu	a5,0(a5)
    80206622:	2781                	sext.w	a5,a5
    80206624:	40f707bb          	subw	a5,a4,a5
    80206628:	2781                	sext.w	a5,a5
    8020662a:	a09d                	j	80206690 <strncmp+0xac>
        s++;
    8020662c:	fe843783          	ld	a5,-24(s0)
    80206630:	0785                	addi	a5,a5,1
    80206632:	fef43423          	sd	a5,-24(s0)
        t++;
    80206636:	fe043783          	ld	a5,-32(s0)
    8020663a:	0785                	addi	a5,a5,1
    8020663c:	fef43023          	sd	a5,-32(s0)
        n--;
    80206640:	fdc42783          	lw	a5,-36(s0)
    80206644:	37fd                	addiw	a5,a5,-1
    80206646:	fcf42e23          	sw	a5,-36(s0)
    while(n > 0 && *s && *t) {
    8020664a:	fdc42783          	lw	a5,-36(s0)
    8020664e:	2781                	sext.w	a5,a5
    80206650:	00f05c63          	blez	a5,80206668 <strncmp+0x84>
    80206654:	fe843783          	ld	a5,-24(s0)
    80206658:	0007c783          	lbu	a5,0(a5)
    8020665c:	c791                	beqz	a5,80206668 <strncmp+0x84>
    8020665e:	fe043783          	ld	a5,-32(s0)
    80206662:	0007c783          	lbu	a5,0(a5)
    80206666:	fbd1                	bnez	a5,802065fa <strncmp+0x16>
    }
    if(n == 0)
    80206668:	fdc42783          	lw	a5,-36(s0)
    8020666c:	2781                	sext.w	a5,a5
    8020666e:	e399                	bnez	a5,80206674 <strncmp+0x90>
        return 0;
    80206670:	4781                	li	a5,0
    80206672:	a839                	j	80206690 <strncmp+0xac>
    return (uchar)*s - (uchar)*t;
    80206674:	fe843783          	ld	a5,-24(s0)
    80206678:	0007c783          	lbu	a5,0(a5)
    8020667c:	0007871b          	sext.w	a4,a5
    80206680:	fe043783          	ld	a5,-32(s0)
    80206684:	0007c783          	lbu	a5,0(a5)
    80206688:	2781                	sext.w	a5,a5
    8020668a:	40f707bb          	subw	a5,a4,a5
    8020668e:	2781                	sext.w	a5,a5
}
    80206690:	853e                	mv	a0,a5
    80206692:	7422                	ld	s0,40(sp)
    80206694:	6145                	addi	sp,sp,48
    80206696:	8082                	ret

0000000080206698 <strncpy>:

// 复制字符串前 n 个字符
char *strncpy(char *dst, const char *src, int n) {
    80206698:	7139                	addi	sp,sp,-64
    8020669a:	fc22                	sd	s0,56(sp)
    8020669c:	0080                	addi	s0,sp,64
    8020669e:	fca43c23          	sd	a0,-40(s0)
    802066a2:	fcb43823          	sd	a1,-48(s0)
    802066a6:	87b2                	mv	a5,a2
    802066a8:	fcf42623          	sw	a5,-52(s0)
    char *ret = dst;
    802066ac:	fd843783          	ld	a5,-40(s0)
    802066b0:	fef43423          	sd	a5,-24(s0)
    while(n > 0 && *src) {
    802066b4:	a035                	j	802066e0 <strncpy+0x48>
        *dst++ = *src++;
    802066b6:	fd043703          	ld	a4,-48(s0)
    802066ba:	00170793          	addi	a5,a4,1
    802066be:	fcf43823          	sd	a5,-48(s0)
    802066c2:	fd843783          	ld	a5,-40(s0)
    802066c6:	00178693          	addi	a3,a5,1
    802066ca:	fcd43c23          	sd	a3,-40(s0)
    802066ce:	00074703          	lbu	a4,0(a4)
    802066d2:	00e78023          	sb	a4,0(a5)
        n--;
    802066d6:	fcc42783          	lw	a5,-52(s0)
    802066da:	37fd                	addiw	a5,a5,-1
    802066dc:	fcf42623          	sw	a5,-52(s0)
    while(n > 0 && *src) {
    802066e0:	fcc42783          	lw	a5,-52(s0)
    802066e4:	2781                	sext.w	a5,a5
    802066e6:	02f05563          	blez	a5,80206710 <strncpy+0x78>
    802066ea:	fd043783          	ld	a5,-48(s0)
    802066ee:	0007c783          	lbu	a5,0(a5)
    802066f2:	f3f1                	bnez	a5,802066b6 <strncpy+0x1e>
    }
    while(n > 0) {
    802066f4:	a831                	j	80206710 <strncpy+0x78>
        *dst++ = 0;
    802066f6:	fd843783          	ld	a5,-40(s0)
    802066fa:	00178713          	addi	a4,a5,1
    802066fe:	fce43c23          	sd	a4,-40(s0)
    80206702:	00078023          	sb	zero,0(a5)
        n--;
    80206706:	fcc42783          	lw	a5,-52(s0)
    8020670a:	37fd                	addiw	a5,a5,-1
    8020670c:	fcf42623          	sw	a5,-52(s0)
    while(n > 0) {
    80206710:	fcc42783          	lw	a5,-52(s0)
    80206714:	2781                	sext.w	a5,a5
    80206716:	fef040e3          	bgtz	a5,802066f6 <strncpy+0x5e>
    }
    return ret;
    8020671a:	fe843783          	ld	a5,-24(s0)
    8020671e:	853e                	mv	a0,a5
    80206720:	7462                	ld	s0,56(sp)
    80206722:	6121                	addi	sp,sp,64
    80206724:	8082                	ret

0000000080206726 <assert>:
    80206726:	1101                	addi	sp,sp,-32
    80206728:	ec06                	sd	ra,24(sp)
    8020672a:	e822                	sd	s0,16(sp)
    8020672c:	1000                	addi	s0,sp,32
    8020672e:	87aa                	mv	a5,a0
    80206730:	fef42623          	sw	a5,-20(s0)
    80206734:	fec42783          	lw	a5,-20(s0)
    80206738:	2781                	sext.w	a5,a5
    8020673a:	e79d                	bnez	a5,80206768 <assert+0x42>
    8020673c:	33800613          	li	a2,824
    80206740:	00022597          	auipc	a1,0x22
    80206744:	3b858593          	addi	a1,a1,952 # 80228af8 <user_test_table+0x78>
    80206748:	00022517          	auipc	a0,0x22
    8020674c:	3c050513          	addi	a0,a0,960 # 80228b08 <user_test_table+0x88>
    80206750:	ffffa097          	auipc	ra,0xffffa
    80206754:	63e080e7          	jalr	1598(ra) # 80200d8e <printf>
    80206758:	00022517          	auipc	a0,0x22
    8020675c:	3d850513          	addi	a0,a0,984 # 80228b30 <user_test_table+0xb0>
    80206760:	ffffb097          	auipc	ra,0xffffb
    80206764:	07a080e7          	jalr	122(ra) # 802017da <panic>
    80206768:	0001                	nop
    8020676a:	60e2                	ld	ra,24(sp)
    8020676c:	6442                	ld	s0,16(sp)
    8020676e:	6105                	addi	sp,sp,32
    80206770:	8082                	ret

0000000080206772 <get_time>:
uint64 get_time(void) {
    80206772:	1141                	addi	sp,sp,-16
    80206774:	e406                	sd	ra,8(sp)
    80206776:	e022                	sd	s0,0(sp)
    80206778:	0800                	addi	s0,sp,16
    return sbi_get_time();
    8020677a:	ffffd097          	auipc	ra,0xffffd
    8020677e:	e56080e7          	jalr	-426(ra) # 802035d0 <sbi_get_time>
    80206782:	87aa                	mv	a5,a0
}
    80206784:	853e                	mv	a0,a5
    80206786:	60a2                	ld	ra,8(sp)
    80206788:	6402                	ld	s0,0(sp)
    8020678a:	0141                	addi	sp,sp,16
    8020678c:	8082                	ret

000000008020678e <test_timer_interrupt>:
void test_timer_interrupt(void) {
    8020678e:	7179                	addi	sp,sp,-48
    80206790:	f406                	sd	ra,40(sp)
    80206792:	f022                	sd	s0,32(sp)
    80206794:	1800                	addi	s0,sp,48
    printf("Testing timer interrupt...\n");
    80206796:	00022517          	auipc	a0,0x22
    8020679a:	3a250513          	addi	a0,a0,930 # 80228b38 <user_test_table+0xb8>
    8020679e:	ffffa097          	auipc	ra,0xffffa
    802067a2:	5f0080e7          	jalr	1520(ra) # 80200d8e <printf>
    uint64 start_time = get_time();
    802067a6:	00000097          	auipc	ra,0x0
    802067aa:	fcc080e7          	jalr	-52(ra) # 80206772 <get_time>
    802067ae:	fea43023          	sd	a0,-32(s0)
    int interrupt_count = 0;
    802067b2:	fc042a23          	sw	zero,-44(s0)
    int last_count = 0;
    802067b6:	fe042623          	sw	zero,-20(s0)
    interrupt_test_flag = &interrupt_count;
    802067ba:	00036797          	auipc	a5,0x36
    802067be:	90e78793          	addi	a5,a5,-1778 # 8023c0c8 <interrupt_test_flag>
    802067c2:	fd440713          	addi	a4,s0,-44
    802067c6:	e398                	sd	a4,0(a5)
    while (interrupt_count < 5) {
    802067c8:	a03d                	j	802067f6 <test_timer_interrupt+0x68>
        if (last_count != interrupt_count) {
    802067ca:	fd442703          	lw	a4,-44(s0)
    802067ce:	fec42783          	lw	a5,-20(s0)
    802067d2:	2781                	sext.w	a5,a5
    802067d4:	02e78163          	beq	a5,a4,802067f6 <test_timer_interrupt+0x68>
            last_count = interrupt_count;
    802067d8:	fd442783          	lw	a5,-44(s0)
    802067dc:	fef42623          	sw	a5,-20(s0)
            printf("Received interrupt %d\n", interrupt_count);
    802067e0:	fd442783          	lw	a5,-44(s0)
    802067e4:	85be                	mv	a1,a5
    802067e6:	00022517          	auipc	a0,0x22
    802067ea:	37250513          	addi	a0,a0,882 # 80228b58 <user_test_table+0xd8>
    802067ee:	ffffa097          	auipc	ra,0xffffa
    802067f2:	5a0080e7          	jalr	1440(ra) # 80200d8e <printf>
    while (interrupt_count < 5) {
    802067f6:	fd442783          	lw	a5,-44(s0)
    802067fa:	873e                	mv	a4,a5
    802067fc:	4791                	li	a5,4
    802067fe:	fce7d6e3          	bge	a5,a4,802067ca <test_timer_interrupt+0x3c>
    interrupt_test_flag = 0;
    80206802:	00036797          	auipc	a5,0x36
    80206806:	8c678793          	addi	a5,a5,-1850 # 8023c0c8 <interrupt_test_flag>
    8020680a:	0007b023          	sd	zero,0(a5)
    uint64 end_time = get_time();
    8020680e:	00000097          	auipc	ra,0x0
    80206812:	f64080e7          	jalr	-156(ra) # 80206772 <get_time>
    80206816:	fca43c23          	sd	a0,-40(s0)
    printf("Timer test completed: %d interrupts in %lu cycles\n",
    8020681a:	fd442683          	lw	a3,-44(s0)
    8020681e:	fd843703          	ld	a4,-40(s0)
    80206822:	fe043783          	ld	a5,-32(s0)
    80206826:	40f707b3          	sub	a5,a4,a5
    8020682a:	863e                	mv	a2,a5
    8020682c:	85b6                	mv	a1,a3
    8020682e:	00022517          	auipc	a0,0x22
    80206832:	34250513          	addi	a0,a0,834 # 80228b70 <user_test_table+0xf0>
    80206836:	ffffa097          	auipc	ra,0xffffa
    8020683a:	558080e7          	jalr	1368(ra) # 80200d8e <printf>
}
    8020683e:	0001                	nop
    80206840:	70a2                	ld	ra,40(sp)
    80206842:	7402                	ld	s0,32(sp)
    80206844:	6145                	addi	sp,sp,48
    80206846:	8082                	ret

0000000080206848 <test_exception>:
void test_exception(void) {
    80206848:	711d                	addi	sp,sp,-96
    8020684a:	ec86                	sd	ra,88(sp)
    8020684c:	e8a2                	sd	s0,80(sp)
    8020684e:	1080                	addi	s0,sp,96
    printf("\n===== 开始全面异常处理测试 =====\n\n");
    80206850:	00022517          	auipc	a0,0x22
    80206854:	35850513          	addi	a0,a0,856 # 80228ba8 <user_test_table+0x128>
    80206858:	ffffa097          	auipc	ra,0xffffa
    8020685c:	536080e7          	jalr	1334(ra) # 80200d8e <printf>
    printf("1. 测试非法指令异常...\n");
    80206860:	00022517          	auipc	a0,0x22
    80206864:	37850513          	addi	a0,a0,888 # 80228bd8 <user_test_table+0x158>
    80206868:	ffffa097          	auipc	ra,0xffffa
    8020686c:	526080e7          	jalr	1318(ra) # 80200d8e <printf>
    80206870:	ffffffff          	.word	0xffffffff
    printf("✓ 识别到指令异常并尝试忽略\n\n");
    80206874:	00022517          	auipc	a0,0x22
    80206878:	38450513          	addi	a0,a0,900 # 80228bf8 <user_test_table+0x178>
    8020687c:	ffffa097          	auipc	ra,0xffffa
    80206880:	512080e7          	jalr	1298(ra) # 80200d8e <printf>
    printf("2. 测试存储页故障异常...\n");
    80206884:	00022517          	auipc	a0,0x22
    80206888:	3a450513          	addi	a0,a0,932 # 80228c28 <user_test_table+0x1a8>
    8020688c:	ffffa097          	auipc	ra,0xffffa
    80206890:	502080e7          	jalr	1282(ra) # 80200d8e <printf>
    volatile uint64 *invalid_ptr = 0;
    80206894:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    80206898:	47a5                	li	a5,9
    8020689a:	07f2                	slli	a5,a5,0x1c
    8020689c:	fef43023          	sd	a5,-32(s0)
    802068a0:	a835                	j	802068dc <test_exception+0x94>
        if (check_is_mapped(addr) == 0) {
    802068a2:	fe043503          	ld	a0,-32(s0)
    802068a6:	ffffd097          	auipc	ra,0xffffd
    802068aa:	842080e7          	jalr	-1982(ra) # 802030e8 <check_is_mapped>
    802068ae:	87aa                	mv	a5,a0
    802068b0:	e385                	bnez	a5,802068d0 <test_exception+0x88>
            invalid_ptr = (uint64*)addr;
    802068b2:	fe043783          	ld	a5,-32(s0)
    802068b6:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    802068ba:	fe043583          	ld	a1,-32(s0)
    802068be:	00022517          	auipc	a0,0x22
    802068c2:	39250513          	addi	a0,a0,914 # 80228c50 <user_test_table+0x1d0>
    802068c6:	ffffa097          	auipc	ra,0xffffa
    802068ca:	4c8080e7          	jalr	1224(ra) # 80200d8e <printf>
            break;
    802068ce:	a829                	j	802068e8 <test_exception+0xa0>
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    802068d0:	fe043703          	ld	a4,-32(s0)
    802068d4:	6785                	lui	a5,0x1
    802068d6:	97ba                	add	a5,a5,a4
    802068d8:	fef43023          	sd	a5,-32(s0)
    802068dc:	fe043703          	ld	a4,-32(s0)
    802068e0:	47cd                	li	a5,19
    802068e2:	07ee                	slli	a5,a5,0x1b
    802068e4:	faf76fe3          	bltu	a4,a5,802068a2 <test_exception+0x5a>
    if (invalid_ptr != 0) {
    802068e8:	fe843783          	ld	a5,-24(s0)
    802068ec:	cb95                	beqz	a5,80206920 <test_exception+0xd8>
        printf("尝试写入未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    802068ee:	fe843783          	ld	a5,-24(s0)
    802068f2:	85be                	mv	a1,a5
    802068f4:	00022517          	auipc	a0,0x22
    802068f8:	37c50513          	addi	a0,a0,892 # 80228c70 <user_test_table+0x1f0>
    802068fc:	ffffa097          	auipc	ra,0xffffa
    80206900:	492080e7          	jalr	1170(ra) # 80200d8e <printf>
        *invalid_ptr = 42;  // 触发存储页故障
    80206904:	fe843783          	ld	a5,-24(s0)
    80206908:	02a00713          	li	a4,42
    8020690c:	e398                	sd	a4,0(a5)
        printf("✓ 存储页故障异常处理成功\n\n");
    8020690e:	00022517          	auipc	a0,0x22
    80206912:	39250513          	addi	a0,a0,914 # 80228ca0 <user_test_table+0x220>
    80206916:	ffffa097          	auipc	ra,0xffffa
    8020691a:	478080e7          	jalr	1144(ra) # 80200d8e <printf>
    8020691e:	a809                	j	80206930 <test_exception+0xe8>
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    80206920:	00022517          	auipc	a0,0x22
    80206924:	3a850513          	addi	a0,a0,936 # 80228cc8 <user_test_table+0x248>
    80206928:	ffffa097          	auipc	ra,0xffffa
    8020692c:	466080e7          	jalr	1126(ra) # 80200d8e <printf>
    printf("3. 测试加载页故障异常...\n");
    80206930:	00022517          	auipc	a0,0x22
    80206934:	3d050513          	addi	a0,a0,976 # 80228d00 <user_test_table+0x280>
    80206938:	ffffa097          	auipc	ra,0xffffa
    8020693c:	456080e7          	jalr	1110(ra) # 80200d8e <printf>
    invalid_ptr = 0;
    80206940:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    80206944:	4795                	li	a5,5
    80206946:	07f6                	slli	a5,a5,0x1d
    80206948:	fcf43c23          	sd	a5,-40(s0)
    8020694c:	a835                	j	80206988 <test_exception+0x140>
        if (check_is_mapped(addr) == 0) {
    8020694e:	fd843503          	ld	a0,-40(s0)
    80206952:	ffffc097          	auipc	ra,0xffffc
    80206956:	796080e7          	jalr	1942(ra) # 802030e8 <check_is_mapped>
    8020695a:	87aa                	mv	a5,a0
    8020695c:	e385                	bnez	a5,8020697c <test_exception+0x134>
            invalid_ptr = (uint64*)addr;
    8020695e:	fd843783          	ld	a5,-40(s0)
    80206962:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    80206966:	fd843583          	ld	a1,-40(s0)
    8020696a:	00022517          	auipc	a0,0x22
    8020696e:	2e650513          	addi	a0,a0,742 # 80228c50 <user_test_table+0x1d0>
    80206972:	ffffa097          	auipc	ra,0xffffa
    80206976:	41c080e7          	jalr	1052(ra) # 80200d8e <printf>
            break;
    8020697a:	a829                	j	80206994 <test_exception+0x14c>
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    8020697c:	fd843703          	ld	a4,-40(s0)
    80206980:	6785                	lui	a5,0x1
    80206982:	97ba                	add	a5,a5,a4
    80206984:	fcf43c23          	sd	a5,-40(s0)
    80206988:	fd843703          	ld	a4,-40(s0)
    8020698c:	47d5                	li	a5,21
    8020698e:	07ee                	slli	a5,a5,0x1b
    80206990:	faf76fe3          	bltu	a4,a5,8020694e <test_exception+0x106>
    if (invalid_ptr != 0) {
    80206994:	fe843783          	ld	a5,-24(s0)
    80206998:	c7a9                	beqz	a5,802069e2 <test_exception+0x19a>
        printf("尝试读取未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    8020699a:	fe843783          	ld	a5,-24(s0)
    8020699e:	85be                	mv	a1,a5
    802069a0:	00022517          	auipc	a0,0x22
    802069a4:	38850513          	addi	a0,a0,904 # 80228d28 <user_test_table+0x2a8>
    802069a8:	ffffa097          	auipc	ra,0xffffa
    802069ac:	3e6080e7          	jalr	998(ra) # 80200d8e <printf>
        volatile uint64 value = *invalid_ptr;  // 触发加载页故障
    802069b0:	fe843783          	ld	a5,-24(s0)
    802069b4:	639c                	ld	a5,0(a5)
    802069b6:	faf43023          	sd	a5,-96(s0)
        printf("读取的值: %lu\n", value);  // 除非故障被处理
    802069ba:	fa043783          	ld	a5,-96(s0)
    802069be:	85be                	mv	a1,a5
    802069c0:	00022517          	auipc	a0,0x22
    802069c4:	39850513          	addi	a0,a0,920 # 80228d58 <user_test_table+0x2d8>
    802069c8:	ffffa097          	auipc	ra,0xffffa
    802069cc:	3c6080e7          	jalr	966(ra) # 80200d8e <printf>
        printf("✓ 加载页故障异常处理成功\n\n");
    802069d0:	00022517          	auipc	a0,0x22
    802069d4:	3a050513          	addi	a0,a0,928 # 80228d70 <user_test_table+0x2f0>
    802069d8:	ffffa097          	auipc	ra,0xffffa
    802069dc:	3b6080e7          	jalr	950(ra) # 80200d8e <printf>
    802069e0:	a809                	j	802069f2 <test_exception+0x1aa>
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    802069e2:	00022517          	auipc	a0,0x22
    802069e6:	2e650513          	addi	a0,a0,742 # 80228cc8 <user_test_table+0x248>
    802069ea:	ffffa097          	auipc	ra,0xffffa
    802069ee:	3a4080e7          	jalr	932(ra) # 80200d8e <printf>
    printf("4. 测试存储地址未对齐异常...\n");
    802069f2:	00022517          	auipc	a0,0x22
    802069f6:	3a650513          	addi	a0,a0,934 # 80228d98 <user_test_table+0x318>
    802069fa:	ffffa097          	auipc	ra,0xffffa
    802069fe:	394080e7          	jalr	916(ra) # 80200d8e <printf>
    uint64 aligned_addr = (uint64)alloc_page();
    80206a02:	ffffd097          	auipc	ra,0xffffd
    80206a06:	92e080e7          	jalr	-1746(ra) # 80203330 <alloc_page>
    80206a0a:	87aa                	mv	a5,a0
    80206a0c:	fcf43823          	sd	a5,-48(s0)
    if (aligned_addr != 0) {
    80206a10:	fd043783          	ld	a5,-48(s0)
    80206a14:	c3a1                	beqz	a5,80206a54 <test_exception+0x20c>
        uint64 misaligned_addr = aligned_addr + 1;  // 制造未对齐地址
    80206a16:	fd043783          	ld	a5,-48(s0)
    80206a1a:	0785                	addi	a5,a5,1 # 1001 <_entry-0x801fefff>
    80206a1c:	fcf43423          	sd	a5,-56(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    80206a20:	fc843583          	ld	a1,-56(s0)
    80206a24:	00022517          	auipc	a0,0x22
    80206a28:	3a450513          	addi	a0,a0,932 # 80228dc8 <user_test_table+0x348>
    80206a2c:	ffffa097          	auipc	ra,0xffffa
    80206a30:	362080e7          	jalr	866(ra) # 80200d8e <printf>
        asm volatile (
    80206a34:	deadc7b7          	lui	a5,0xdeadc
    80206a38:	eef7879b          	addiw	a5,a5,-273 # ffffffffdeadbeef <_bss_end+0xffffffff5e8945cf>
    80206a3c:	fc843703          	ld	a4,-56(s0)
    80206a40:	e31c                	sd	a5,0(a4)
        printf("✓ 存储地址未对齐异常处理成功\n\n");
    80206a42:	00022517          	auipc	a0,0x22
    80206a46:	3a650513          	addi	a0,a0,934 # 80228de8 <user_test_table+0x368>
    80206a4a:	ffffa097          	auipc	ra,0xffffa
    80206a4e:	344080e7          	jalr	836(ra) # 80200d8e <printf>
    80206a52:	a809                	j	80206a64 <test_exception+0x21c>
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    80206a54:	00022517          	auipc	a0,0x22
    80206a58:	3c450513          	addi	a0,a0,964 # 80228e18 <user_test_table+0x398>
    80206a5c:	ffffa097          	auipc	ra,0xffffa
    80206a60:	332080e7          	jalr	818(ra) # 80200d8e <printf>
    printf("5. 测试加载地址未对齐异常...\n");
    80206a64:	00022517          	auipc	a0,0x22
    80206a68:	3f450513          	addi	a0,a0,1012 # 80228e58 <user_test_table+0x3d8>
    80206a6c:	ffffa097          	auipc	ra,0xffffa
    80206a70:	322080e7          	jalr	802(ra) # 80200d8e <printf>
    if (aligned_addr != 0) {
    80206a74:	fd043783          	ld	a5,-48(s0)
    80206a78:	cbb1                	beqz	a5,80206acc <test_exception+0x284>
        uint64 misaligned_addr = aligned_addr + 1;
    80206a7a:	fd043783          	ld	a5,-48(s0)
    80206a7e:	0785                	addi	a5,a5,1
    80206a80:	fcf43023          	sd	a5,-64(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    80206a84:	fc043583          	ld	a1,-64(s0)
    80206a88:	00022517          	auipc	a0,0x22
    80206a8c:	34050513          	addi	a0,a0,832 # 80228dc8 <user_test_table+0x348>
    80206a90:	ffffa097          	auipc	ra,0xffffa
    80206a94:	2fe080e7          	jalr	766(ra) # 80200d8e <printf>
        uint64 value = 0;
    80206a98:	fa043c23          	sd	zero,-72(s0)
        asm volatile (
    80206a9c:	fc043783          	ld	a5,-64(s0)
    80206aa0:	639c                	ld	a5,0(a5)
    80206aa2:	faf43c23          	sd	a5,-72(s0)
        printf("读取的值: 0x%lx\n", value);
    80206aa6:	fb843583          	ld	a1,-72(s0)
    80206aaa:	00022517          	auipc	a0,0x22
    80206aae:	3de50513          	addi	a0,a0,990 # 80228e88 <user_test_table+0x408>
    80206ab2:	ffffa097          	auipc	ra,0xffffa
    80206ab6:	2dc080e7          	jalr	732(ra) # 80200d8e <printf>
        printf("✓ 加载地址未对齐异常处理成功\n\n");
    80206aba:	00022517          	auipc	a0,0x22
    80206abe:	3e650513          	addi	a0,a0,998 # 80228ea0 <user_test_table+0x420>
    80206ac2:	ffffa097          	auipc	ra,0xffffa
    80206ac6:	2cc080e7          	jalr	716(ra) # 80200d8e <printf>
    80206aca:	a809                	j	80206adc <test_exception+0x294>
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    80206acc:	00022517          	auipc	a0,0x22
    80206ad0:	34c50513          	addi	a0,a0,844 # 80228e18 <user_test_table+0x398>
    80206ad4:	ffffa097          	auipc	ra,0xffffa
    80206ad8:	2ba080e7          	jalr	698(ra) # 80200d8e <printf>
	printf("6. 测试断点异常...\n");
    80206adc:	00022517          	auipc	a0,0x22
    80206ae0:	3f450513          	addi	a0,a0,1012 # 80228ed0 <user_test_table+0x450>
    80206ae4:	ffffa097          	auipc	ra,0xffffa
    80206ae8:	2aa080e7          	jalr	682(ra) # 80200d8e <printf>
	asm volatile (
    80206aec:	0001                	nop
    80206aee:	9002                	ebreak
    80206af0:	0001                	nop
	printf("✓ 断点异常处理成功\n\n");
    80206af2:	00022517          	auipc	a0,0x22
    80206af6:	3fe50513          	addi	a0,a0,1022 # 80228ef0 <user_test_table+0x470>
    80206afa:	ffffa097          	auipc	ra,0xffffa
    80206afe:	294080e7          	jalr	660(ra) # 80200d8e <printf>
    printf("7. 测试环境调用异常...\n");
    80206b02:	00022517          	auipc	a0,0x22
    80206b06:	40e50513          	addi	a0,a0,1038 # 80228f10 <user_test_table+0x490>
    80206b0a:	ffffa097          	auipc	ra,0xffffa
    80206b0e:	284080e7          	jalr	644(ra) # 80200d8e <printf>
    asm volatile ("ecall");  // 从S模式生成环境调用
    80206b12:	00000073          	ecall
    printf("✓ 环境调用异常处理成功\n\n");
    80206b16:	00022517          	auipc	a0,0x22
    80206b1a:	41a50513          	addi	a0,a0,1050 # 80228f30 <user_test_table+0x4b0>
    80206b1e:	ffffa097          	auipc	ra,0xffffa
    80206b22:	270080e7          	jalr	624(ra) # 80200d8e <printf>
    printf("===== 部分异常处理测试完成 =====\n\n");
    80206b26:	00022517          	auipc	a0,0x22
    80206b2a:	43250513          	addi	a0,a0,1074 # 80228f58 <user_test_table+0x4d8>
    80206b2e:	ffffa097          	auipc	ra,0xffffa
    80206b32:	260080e7          	jalr	608(ra) # 80200d8e <printf>
	printf("===== 测试不可恢复的除零异常 ====\n");
    80206b36:	00022517          	auipc	a0,0x22
    80206b3a:	45250513          	addi	a0,a0,1106 # 80228f88 <user_test_table+0x508>
    80206b3e:	ffffa097          	auipc	ra,0xffffa
    80206b42:	250080e7          	jalr	592(ra) # 80200d8e <printf>
	unsigned int a = 1;
    80206b46:	4785                	li	a5,1
    80206b48:	faf42a23          	sw	a5,-76(s0)
	unsigned int b =0;
    80206b4c:	fa042823          	sw	zero,-80(s0)
	unsigned int result = a/b;
    80206b50:	fb442783          	lw	a5,-76(s0)
    80206b54:	873e                	mv	a4,a5
    80206b56:	fb042783          	lw	a5,-80(s0)
    80206b5a:	02f757bb          	divuw	a5,a4,a5
    80206b5e:	faf42623          	sw	a5,-84(s0)
	printf("这行不应该被打印，如果打印了，那么result = %d\n",result);
    80206b62:	fac42783          	lw	a5,-84(s0)
    80206b66:	85be                	mv	a1,a5
    80206b68:	00022517          	auipc	a0,0x22
    80206b6c:	45050513          	addi	a0,a0,1104 # 80228fb8 <user_test_table+0x538>
    80206b70:	ffffa097          	auipc	ra,0xffffa
    80206b74:	21e080e7          	jalr	542(ra) # 80200d8e <printf>
}
    80206b78:	0001                	nop
    80206b7a:	60e6                	ld	ra,88(sp)
    80206b7c:	6446                	ld	s0,80(sp)
    80206b7e:	6125                	addi	sp,sp,96
    80206b80:	8082                	ret

0000000080206b82 <test_interrupt_overhead>:
void test_interrupt_overhead(void) {
    80206b82:	715d                	addi	sp,sp,-80
    80206b84:	e486                	sd	ra,72(sp)
    80206b86:	e0a2                	sd	s0,64(sp)
    80206b88:	0880                	addi	s0,sp,80
    printf("\n===== 开始中断开销测试 =====\n");
    80206b8a:	00022517          	auipc	a0,0x22
    80206b8e:	46e50513          	addi	a0,a0,1134 # 80228ff8 <user_test_table+0x578>
    80206b92:	ffffa097          	auipc	ra,0xffffa
    80206b96:	1fc080e7          	jalr	508(ra) # 80200d8e <printf>
    printf("\n----- 测试1: 时钟中断处理时间 -----\n");
    80206b9a:	00022517          	auipc	a0,0x22
    80206b9e:	48650513          	addi	a0,a0,1158 # 80229020 <user_test_table+0x5a0>
    80206ba2:	ffffa097          	auipc	ra,0xffffa
    80206ba6:	1ec080e7          	jalr	492(ra) # 80200d8e <printf>
    int count = 0;
    80206baa:	fa042a23          	sw	zero,-76(s0)
    volatile int *test_flag = &count;
    80206bae:	fb440793          	addi	a5,s0,-76
    80206bb2:	fef43023          	sd	a5,-32(s0)
    start_cycles = get_time();
    80206bb6:	00000097          	auipc	ra,0x0
    80206bba:	bbc080e7          	jalr	-1092(ra) # 80206772 <get_time>
    80206bbe:	fca43c23          	sd	a0,-40(s0)
    interrupt_test_flag = test_flag;  // 设置全局标志
    80206bc2:	00035797          	auipc	a5,0x35
    80206bc6:	50678793          	addi	a5,a5,1286 # 8023c0c8 <interrupt_test_flag>
    80206bca:	fe043703          	ld	a4,-32(s0)
    80206bce:	e398                	sd	a4,0(a5)
    while(count < 10) {
    80206bd0:	a011                	j	80206bd4 <test_interrupt_overhead+0x52>
        asm volatile("nop");
    80206bd2:	0001                	nop
    while(count < 10) {
    80206bd4:	fb442783          	lw	a5,-76(s0)
    80206bd8:	873e                	mv	a4,a5
    80206bda:	47a5                	li	a5,9
    80206bdc:	fee7dbe3          	bge	a5,a4,80206bd2 <test_interrupt_overhead+0x50>
    end_cycles = get_time();
    80206be0:	00000097          	auipc	ra,0x0
    80206be4:	b92080e7          	jalr	-1134(ra) # 80206772 <get_time>
    80206be8:	fca43823          	sd	a0,-48(s0)
    interrupt_test_flag = 0;  // 清除标志
    80206bec:	00035797          	auipc	a5,0x35
    80206bf0:	4dc78793          	addi	a5,a5,1244 # 8023c0c8 <interrupt_test_flag>
    80206bf4:	0007b023          	sd	zero,0(a5)
    uint64 total_cycles = end_cycles - start_cycles;
    80206bf8:	fd043703          	ld	a4,-48(s0)
    80206bfc:	fd843783          	ld	a5,-40(s0)
    80206c00:	40f707b3          	sub	a5,a4,a5
    80206c04:	fcf43423          	sd	a5,-56(s0)
    uint64 avg_cycles1 = total_cycles / 10;
    80206c08:	fc843703          	ld	a4,-56(s0)
    80206c0c:	47a9                	li	a5,10
    80206c0e:	02f757b3          	divu	a5,a4,a5
    80206c12:	fcf43023          	sd	a5,-64(s0)
    printf("平均每次时钟中断处理耗时: %lu cycles\n", avg_cycles1);
    80206c16:	fc043583          	ld	a1,-64(s0)
    80206c1a:	00022517          	auipc	a0,0x22
    80206c1e:	43650513          	addi	a0,a0,1078 # 80229050 <user_test_table+0x5d0>
    80206c22:	ffffa097          	auipc	ra,0xffffa
    80206c26:	16c080e7          	jalr	364(ra) # 80200d8e <printf>
    printf("\n----- 测试2: 上下文切换成本 -----\n");
    80206c2a:	00022517          	auipc	a0,0x22
    80206c2e:	45e50513          	addi	a0,a0,1118 # 80229088 <user_test_table+0x608>
    80206c32:	ffffa097          	auipc	ra,0xffffa
    80206c36:	15c080e7          	jalr	348(ra) # 80200d8e <printf>
    start_cycles = get_time();
    80206c3a:	00000097          	auipc	ra,0x0
    80206c3e:	b38080e7          	jalr	-1224(ra) # 80206772 <get_time>
    80206c42:	fca43c23          	sd	a0,-40(s0)
    for(int i = 0; i < 1000; i++) {
    80206c46:	fe042623          	sw	zero,-20(s0)
    80206c4a:	a801                	j	80206c5a <test_interrupt_overhead+0xd8>
    80206c4c:	ffffffff          	.word	0xffffffff
    80206c50:	fec42783          	lw	a5,-20(s0)
    80206c54:	2785                	addiw	a5,a5,1
    80206c56:	fef42623          	sw	a5,-20(s0)
    80206c5a:	fec42783          	lw	a5,-20(s0)
    80206c5e:	0007871b          	sext.w	a4,a5
    80206c62:	3e700793          	li	a5,999
    80206c66:	fee7d3e3          	bge	a5,a4,80206c4c <test_interrupt_overhead+0xca>
    end_cycles = get_time();
    80206c6a:	00000097          	auipc	ra,0x0
    80206c6e:	b08080e7          	jalr	-1272(ra) # 80206772 <get_time>
    80206c72:	fca43823          	sd	a0,-48(s0)
    uint64 avg_cycles2 = (end_cycles - start_cycles) / 1000;
    80206c76:	fd043703          	ld	a4,-48(s0)
    80206c7a:	fd843783          	ld	a5,-40(s0)
    80206c7e:	8f1d                	sub	a4,a4,a5
    80206c80:	3e800793          	li	a5,1000
    80206c84:	02f757b3          	divu	a5,a4,a5
    80206c88:	faf43c23          	sd	a5,-72(s0)
	printf("平均每次时钟中断处理耗时: %lu cycles\n", avg_cycles1);
    80206c8c:	fc043583          	ld	a1,-64(s0)
    80206c90:	00022517          	auipc	a0,0x22
    80206c94:	3c050513          	addi	a0,a0,960 # 80229050 <user_test_table+0x5d0>
    80206c98:	ffffa097          	auipc	ra,0xffffa
    80206c9c:	0f6080e7          	jalr	246(ra) # 80200d8e <printf>
    printf("平均每次上下文切换耗时: %lu cycles\n", avg_cycles2);
    80206ca0:	fb843583          	ld	a1,-72(s0)
    80206ca4:	00022517          	auipc	a0,0x22
    80206ca8:	41450513          	addi	a0,a0,1044 # 802290b8 <user_test_table+0x638>
    80206cac:	ffffa097          	auipc	ra,0xffffa
    80206cb0:	0e2080e7          	jalr	226(ra) # 80200d8e <printf>
    printf("\n===== 中断开销测试完成 =====\n");
    80206cb4:	00022517          	auipc	a0,0x22
    80206cb8:	43450513          	addi	a0,a0,1076 # 802290e8 <user_test_table+0x668>
    80206cbc:	ffffa097          	auipc	ra,0xffffa
    80206cc0:	0d2080e7          	jalr	210(ra) # 80200d8e <printf>
}
    80206cc4:	0001                	nop
    80206cc6:	60a6                	ld	ra,72(sp)
    80206cc8:	6406                	ld	s0,64(sp)
    80206cca:	6161                	addi	sp,sp,80
    80206ccc:	8082                	ret

0000000080206cce <simple_task>:
void simple_task(void) {
    80206cce:	1141                	addi	sp,sp,-16
    80206cd0:	e406                	sd	ra,8(sp)
    80206cd2:	e022                	sd	s0,0(sp)
    80206cd4:	0800                	addi	s0,sp,16
    printf("Simple kernel task running in PID %d\n", myproc()->pid);
    80206cd6:	ffffe097          	auipc	ra,0xffffe
    80206cda:	36a080e7          	jalr	874(ra) # 80205040 <myproc>
    80206cde:	87aa                	mv	a5,a0
    80206ce0:	43dc                	lw	a5,4(a5)
    80206ce2:	85be                	mv	a1,a5
    80206ce4:	00022517          	auipc	a0,0x22
    80206ce8:	42c50513          	addi	a0,a0,1068 # 80229110 <user_test_table+0x690>
    80206cec:	ffffa097          	auipc	ra,0xffffa
    80206cf0:	0a2080e7          	jalr	162(ra) # 80200d8e <printf>
}
    80206cf4:	0001                	nop
    80206cf6:	60a2                	ld	ra,8(sp)
    80206cf8:	6402                	ld	s0,0(sp)
    80206cfa:	0141                	addi	sp,sp,16
    80206cfc:	8082                	ret

0000000080206cfe <test_process_creation>:
void test_process_creation(void) {
    80206cfe:	7119                	addi	sp,sp,-128
    80206d00:	fc86                	sd	ra,120(sp)
    80206d02:	f8a2                	sd	s0,112(sp)
    80206d04:	0100                	addi	s0,sp,128
    printf("===== 测试开始: 进程创建与管理测试 =====\n");
    80206d06:	00022517          	auipc	a0,0x22
    80206d0a:	43250513          	addi	a0,a0,1074 # 80229138 <user_test_table+0x6b8>
    80206d0e:	ffffa097          	auipc	ra,0xffffa
    80206d12:	080080e7          	jalr	128(ra) # 80200d8e <printf>
    printf("\n----- 第一阶段：测试内核进程创建与管理 -----\n");
    80206d16:	00022517          	auipc	a0,0x22
    80206d1a:	45a50513          	addi	a0,a0,1114 # 80229170 <user_test_table+0x6f0>
    80206d1e:	ffffa097          	auipc	ra,0xffffa
    80206d22:	070080e7          	jalr	112(ra) # 80200d8e <printf>
    int pid = create_kernel_proc(simple_task);
    80206d26:	00000517          	auipc	a0,0x0
    80206d2a:	fa850513          	addi	a0,a0,-88 # 80206cce <simple_task>
    80206d2e:	fffff097          	auipc	ra,0xfffff
    80206d32:	978080e7          	jalr	-1672(ra) # 802056a6 <create_kernel_proc>
    80206d36:	87aa                	mv	a5,a0
    80206d38:	faf42a23          	sw	a5,-76(s0)
    assert(pid > 0);
    80206d3c:	fb442783          	lw	a5,-76(s0)
    80206d40:	2781                	sext.w	a5,a5
    80206d42:	00f027b3          	sgtz	a5,a5
    80206d46:	0ff7f793          	zext.b	a5,a5
    80206d4a:	2781                	sext.w	a5,a5
    80206d4c:	853e                	mv	a0,a5
    80206d4e:	00000097          	auipc	ra,0x0
    80206d52:	9d8080e7          	jalr	-1576(ra) # 80206726 <assert>
    printf("【测试结果】: 基本内核进程创建成功，PID: %d\n", pid);
    80206d56:	fb442783          	lw	a5,-76(s0)
    80206d5a:	85be                	mv	a1,a5
    80206d5c:	00022517          	auipc	a0,0x22
    80206d60:	45450513          	addi	a0,a0,1108 # 802291b0 <user_test_table+0x730>
    80206d64:	ffffa097          	auipc	ra,0xffffa
    80206d68:	02a080e7          	jalr	42(ra) # 80200d8e <printf>
    printf("\n----- 用内核进程填满进程表 -----\n");
    80206d6c:	00022517          	auipc	a0,0x22
    80206d70:	48450513          	addi	a0,a0,1156 # 802291f0 <user_test_table+0x770>
    80206d74:	ffffa097          	auipc	ra,0xffffa
    80206d78:	01a080e7          	jalr	26(ra) # 80200d8e <printf>
    int kernel_count = 1; // 已经创建了一个
    80206d7c:	4785                	li	a5,1
    80206d7e:	fef42623          	sw	a5,-20(s0)
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    80206d82:	4785                	li	a5,1
    80206d84:	fef42423          	sw	a5,-24(s0)
    80206d88:	a881                	j	80206dd8 <test_process_creation+0xda>
        int new_pid = create_kernel_proc(simple_task);
    80206d8a:	00000517          	auipc	a0,0x0
    80206d8e:	f4450513          	addi	a0,a0,-188 # 80206cce <simple_task>
    80206d92:	fffff097          	auipc	ra,0xfffff
    80206d96:	914080e7          	jalr	-1772(ra) # 802056a6 <create_kernel_proc>
    80206d9a:	87aa                	mv	a5,a0
    80206d9c:	faf42823          	sw	a5,-80(s0)
        if (new_pid > 0) {
    80206da0:	fb042783          	lw	a5,-80(s0)
    80206da4:	2781                	sext.w	a5,a5
    80206da6:	00f05863          	blez	a5,80206db6 <test_process_creation+0xb8>
            kernel_count++; 
    80206daa:	fec42783          	lw	a5,-20(s0)
    80206dae:	2785                	addiw	a5,a5,1
    80206db0:	fef42623          	sw	a5,-20(s0)
    80206db4:	a829                	j	80206dce <test_process_creation+0xd0>
            warning("process table was full at %d kernel processes\n", kernel_count);
    80206db6:	fec42783          	lw	a5,-20(s0)
    80206dba:	85be                	mv	a1,a5
    80206dbc:	00022517          	auipc	a0,0x22
    80206dc0:	46450513          	addi	a0,a0,1124 # 80229220 <user_test_table+0x7a0>
    80206dc4:	ffffb097          	auipc	ra,0xffffb
    80206dc8:	a4a080e7          	jalr	-1462(ra) # 8020180e <warning>
            break;
    80206dcc:	a829                	j	80206de6 <test_process_creation+0xe8>
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    80206dce:	fe842783          	lw	a5,-24(s0)
    80206dd2:	2785                	addiw	a5,a5,1
    80206dd4:	fef42423          	sw	a5,-24(s0)
    80206dd8:	fe842783          	lw	a5,-24(s0)
    80206ddc:	0007871b          	sext.w	a4,a5
    80206de0:	47fd                	li	a5,31
    80206de2:	fae7d4e3          	bge	a5,a4,80206d8a <test_process_creation+0x8c>
    printf("【测试结果】: 成功创建 %d 个内核进程 (最大限制: %d)\n", kernel_count, PROC);
    80206de6:	fec42783          	lw	a5,-20(s0)
    80206dea:	02000613          	li	a2,32
    80206dee:	85be                	mv	a1,a5
    80206df0:	00022517          	auipc	a0,0x22
    80206df4:	46050513          	addi	a0,a0,1120 # 80229250 <user_test_table+0x7d0>
    80206df8:	ffffa097          	auipc	ra,0xffffa
    80206dfc:	f96080e7          	jalr	-106(ra) # 80200d8e <printf>
    print_proc_table();
    80206e00:	fffff097          	auipc	ra,0xfffff
    80206e04:	350080e7          	jalr	848(ra) # 80206150 <print_proc_table>
    printf("\n----- 等待并清理所有内核进程 -----\n");
    80206e08:	00022517          	auipc	a0,0x22
    80206e0c:	49050513          	addi	a0,a0,1168 # 80229298 <user_test_table+0x818>
    80206e10:	ffffa097          	auipc	ra,0xffffa
    80206e14:	f7e080e7          	jalr	-130(ra) # 80200d8e <printf>
    int kernel_success_count = 0;
    80206e18:	fe042223          	sw	zero,-28(s0)
    for (int i = 0; i < kernel_count; i++) {
    80206e1c:	fe042023          	sw	zero,-32(s0)
    80206e20:	a0a5                	j	80206e88 <test_process_creation+0x18a>
        int waited_pid = wait_proc(NULL);
    80206e22:	4501                	li	a0,0
    80206e24:	fffff097          	auipc	ra,0xfffff
    80206e28:	1a2080e7          	jalr	418(ra) # 80205fc6 <wait_proc>
    80206e2c:	87aa                	mv	a5,a0
    80206e2e:	f8f42623          	sw	a5,-116(s0)
        if (waited_pid > 0) {
    80206e32:	f8c42783          	lw	a5,-116(s0)
    80206e36:	2781                	sext.w	a5,a5
    80206e38:	02f05863          	blez	a5,80206e68 <test_process_creation+0x16a>
            kernel_success_count++;
    80206e3c:	fe442783          	lw	a5,-28(s0)
    80206e40:	2785                	addiw	a5,a5,1
    80206e42:	fef42223          	sw	a5,-28(s0)
            printf("回收内核进程 PID: %d (%d/%d)\n", waited_pid, kernel_success_count, kernel_count);
    80206e46:	fec42683          	lw	a3,-20(s0)
    80206e4a:	fe442703          	lw	a4,-28(s0)
    80206e4e:	f8c42783          	lw	a5,-116(s0)
    80206e52:	863a                	mv	a2,a4
    80206e54:	85be                	mv	a1,a5
    80206e56:	00022517          	auipc	a0,0x22
    80206e5a:	47250513          	addi	a0,a0,1138 # 802292c8 <user_test_table+0x848>
    80206e5e:	ffffa097          	auipc	ra,0xffffa
    80206e62:	f30080e7          	jalr	-208(ra) # 80200d8e <printf>
    80206e66:	a821                	j	80206e7e <test_process_creation+0x180>
            printf("【错误】: 等待内核进程失败，错误码: %d\n", waited_pid);
    80206e68:	f8c42783          	lw	a5,-116(s0)
    80206e6c:	85be                	mv	a1,a5
    80206e6e:	00022517          	auipc	a0,0x22
    80206e72:	48250513          	addi	a0,a0,1154 # 802292f0 <user_test_table+0x870>
    80206e76:	ffffa097          	auipc	ra,0xffffa
    80206e7a:	f18080e7          	jalr	-232(ra) # 80200d8e <printf>
    for (int i = 0; i < kernel_count; i++) {
    80206e7e:	fe042783          	lw	a5,-32(s0)
    80206e82:	2785                	addiw	a5,a5,1
    80206e84:	fef42023          	sw	a5,-32(s0)
    80206e88:	fe042783          	lw	a5,-32(s0)
    80206e8c:	873e                	mv	a4,a5
    80206e8e:	fec42783          	lw	a5,-20(s0)
    80206e92:	2701                	sext.w	a4,a4
    80206e94:	2781                	sext.w	a5,a5
    80206e96:	f8f746e3          	blt	a4,a5,80206e22 <test_process_creation+0x124>
    printf("【测试结果】: 回收 %d/%d 个内核进程\n", kernel_success_count, kernel_count);
    80206e9a:	fec42703          	lw	a4,-20(s0)
    80206e9e:	fe442783          	lw	a5,-28(s0)
    80206ea2:	863a                	mv	a2,a4
    80206ea4:	85be                	mv	a1,a5
    80206ea6:	00022517          	auipc	a0,0x22
    80206eaa:	48250513          	addi	a0,a0,1154 # 80229328 <user_test_table+0x8a8>
    80206eae:	ffffa097          	auipc	ra,0xffffa
    80206eb2:	ee0080e7          	jalr	-288(ra) # 80200d8e <printf>
    print_proc_table();
    80206eb6:	fffff097          	auipc	ra,0xfffff
    80206eba:	29a080e7          	jalr	666(ra) # 80206150 <print_proc_table>
    printf("\n----- 第二阶段：测试用户进程创建与管理 -----\n");
    80206ebe:	00022517          	auipc	a0,0x22
    80206ec2:	4a250513          	addi	a0,a0,1186 # 80229360 <user_test_table+0x8e0>
    80206ec6:	ffffa097          	auipc	ra,0xffffa
    80206eca:	ec8080e7          	jalr	-312(ra) # 80200d8e <printf>
    int user_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
    80206ece:	06c00793          	li	a5,108
    80206ed2:	2781                	sext.w	a5,a5
    80206ed4:	85be                	mv	a1,a5
    80206ed6:	00021517          	auipc	a0,0x21
    80206eda:	46a50513          	addi	a0,a0,1130 # 80228340 <simple_user_task_bin>
    80206ede:	fffff097          	auipc	ra,0xfffff
    80206ee2:	914080e7          	jalr	-1772(ra) # 802057f2 <create_user_proc>
    80206ee6:	87aa                	mv	a5,a0
    80206ee8:	faf42623          	sw	a5,-84(s0)
    if (user_pid > 0) {
    80206eec:	fac42783          	lw	a5,-84(s0)
    80206ef0:	2781                	sext.w	a5,a5
    80206ef2:	02f05c63          	blez	a5,80206f2a <test_process_creation+0x22c>
        printf("【测试结果】: 基本用户进程创建成功，PID: %d\n", user_pid);
    80206ef6:	fac42783          	lw	a5,-84(s0)
    80206efa:	85be                	mv	a1,a5
    80206efc:	00022517          	auipc	a0,0x22
    80206f00:	4a450513          	addi	a0,a0,1188 # 802293a0 <user_test_table+0x920>
    80206f04:	ffffa097          	auipc	ra,0xffffa
    80206f08:	e8a080e7          	jalr	-374(ra) # 80200d8e <printf>
    printf("\n----- 用用户进程填满进程表 -----\n");
    80206f0c:	00022517          	auipc	a0,0x22
    80206f10:	50450513          	addi	a0,a0,1284 # 80229410 <user_test_table+0x990>
    80206f14:	ffffa097          	auipc	ra,0xffffa
    80206f18:	e7a080e7          	jalr	-390(ra) # 80200d8e <printf>
    int user_count = 1; // 已经创建了一个
    80206f1c:	4785                	li	a5,1
    80206f1e:	fcf42e23          	sw	a5,-36(s0)
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    80206f22:	4785                	li	a5,1
    80206f24:	fcf42c23          	sw	a5,-40(s0)
    80206f28:	a841                	j	80206fb8 <test_process_creation+0x2ba>
        printf("【错误】: 基本用户进程创建失败\n");
    80206f2a:	00022517          	auipc	a0,0x22
    80206f2e:	4b650513          	addi	a0,a0,1206 # 802293e0 <user_test_table+0x960>
    80206f32:	ffffa097          	auipc	ra,0xffffa
    80206f36:	e5c080e7          	jalr	-420(ra) # 80200d8e <printf>
        return;
    80206f3a:	a615                	j	8020725e <test_process_creation+0x560>
        int new_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
    80206f3c:	06c00793          	li	a5,108
    80206f40:	2781                	sext.w	a5,a5
    80206f42:	85be                	mv	a1,a5
    80206f44:	00021517          	auipc	a0,0x21
    80206f48:	3fc50513          	addi	a0,a0,1020 # 80228340 <simple_user_task_bin>
    80206f4c:	fffff097          	auipc	ra,0xfffff
    80206f50:	8a6080e7          	jalr	-1882(ra) # 802057f2 <create_user_proc>
    80206f54:	87aa                	mv	a5,a0
    80206f56:	faf42423          	sw	a5,-88(s0)
        if (new_pid > 0) {
    80206f5a:	fa842783          	lw	a5,-88(s0)
    80206f5e:	2781                	sext.w	a5,a5
    80206f60:	02f05b63          	blez	a5,80206f96 <test_process_creation+0x298>
            user_count++;
    80206f64:	fdc42783          	lw	a5,-36(s0)
    80206f68:	2785                	addiw	a5,a5,1
    80206f6a:	fcf42e23          	sw	a5,-36(s0)
            if (user_count % 5 == 0) { // 每5个进程打印一次进度
    80206f6e:	fdc42783          	lw	a5,-36(s0)
    80206f72:	873e                	mv	a4,a5
    80206f74:	4795                	li	a5,5
    80206f76:	02f767bb          	remw	a5,a4,a5
    80206f7a:	2781                	sext.w	a5,a5
    80206f7c:	eb8d                	bnez	a5,80206fae <test_process_creation+0x2b0>
                printf("已创建 %d 个用户进程...\n", user_count);
    80206f7e:	fdc42783          	lw	a5,-36(s0)
    80206f82:	85be                	mv	a1,a5
    80206f84:	00022517          	auipc	a0,0x22
    80206f88:	4bc50513          	addi	a0,a0,1212 # 80229440 <user_test_table+0x9c0>
    80206f8c:	ffffa097          	auipc	ra,0xffffa
    80206f90:	e02080e7          	jalr	-510(ra) # 80200d8e <printf>
    80206f94:	a829                	j	80206fae <test_process_creation+0x2b0>
            warning("process table was full at %d user processes\n", user_count);
    80206f96:	fdc42783          	lw	a5,-36(s0)
    80206f9a:	85be                	mv	a1,a5
    80206f9c:	00022517          	auipc	a0,0x22
    80206fa0:	4cc50513          	addi	a0,a0,1228 # 80229468 <user_test_table+0x9e8>
    80206fa4:	ffffb097          	auipc	ra,0xffffb
    80206fa8:	86a080e7          	jalr	-1942(ra) # 8020180e <warning>
            break;
    80206fac:	a829                	j	80206fc6 <test_process_creation+0x2c8>
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    80206fae:	fd842783          	lw	a5,-40(s0)
    80206fb2:	2785                	addiw	a5,a5,1
    80206fb4:	fcf42c23          	sw	a5,-40(s0)
    80206fb8:	fd842783          	lw	a5,-40(s0)
    80206fbc:	0007871b          	sext.w	a4,a5
    80206fc0:	47fd                	li	a5,31
    80206fc2:	f6e7dde3          	bge	a5,a4,80206f3c <test_process_creation+0x23e>
    printf("【测试结果】: 成功创建 %d 个用户进程 (最大限制: %d)\n", user_count, PROC);
    80206fc6:	fdc42783          	lw	a5,-36(s0)
    80206fca:	02000613          	li	a2,32
    80206fce:	85be                	mv	a1,a5
    80206fd0:	00022517          	auipc	a0,0x22
    80206fd4:	4c850513          	addi	a0,a0,1224 # 80229498 <user_test_table+0xa18>
    80206fd8:	ffffa097          	auipc	ra,0xffffa
    80206fdc:	db6080e7          	jalr	-586(ra) # 80200d8e <printf>
    print_proc_table();
    80206fe0:	fffff097          	auipc	ra,0xfffff
    80206fe4:	170080e7          	jalr	368(ra) # 80206150 <print_proc_table>
    printf("\n----- 等待并清理所有用户进程 -----\n");
    80206fe8:	00022517          	auipc	a0,0x22
    80206fec:	4f850513          	addi	a0,a0,1272 # 802294e0 <user_test_table+0xa60>
    80206ff0:	ffffa097          	auipc	ra,0xffffa
    80206ff4:	d9e080e7          	jalr	-610(ra) # 80200d8e <printf>
    int user_success_count = 0;
    80206ff8:	fc042a23          	sw	zero,-44(s0)
    for (int i = 0; i < user_count; i++) {
    80206ffc:	fc042823          	sw	zero,-48(s0)
    80207000:	a895                	j	80207074 <test_process_creation+0x376>
        int waited_pid = wait_proc(NULL);
    80207002:	4501                	li	a0,0
    80207004:	fffff097          	auipc	ra,0xfffff
    80207008:	fc2080e7          	jalr	-62(ra) # 80205fc6 <wait_proc>
    8020700c:	87aa                	mv	a5,a0
    8020700e:	f8f42823          	sw	a5,-112(s0)
        if (waited_pid > 0) {
    80207012:	f9042783          	lw	a5,-112(s0)
    80207016:	2781                	sext.w	a5,a5
    80207018:	02f05e63          	blez	a5,80207054 <test_process_creation+0x356>
            user_success_count++;
    8020701c:	fd442783          	lw	a5,-44(s0)
    80207020:	2785                	addiw	a5,a5,1
    80207022:	fcf42a23          	sw	a5,-44(s0)
            if (user_success_count % 5 == 0) { // 每5个进程打印一次进度
    80207026:	fd442783          	lw	a5,-44(s0)
    8020702a:	873e                	mv	a4,a5
    8020702c:	4795                	li	a5,5
    8020702e:	02f767bb          	remw	a5,a4,a5
    80207032:	2781                	sext.w	a5,a5
    80207034:	eb9d                	bnez	a5,8020706a <test_process_creation+0x36c>
                printf("已回收 %d/%d 个用户进程...\n", user_success_count, user_count);
    80207036:	fdc42703          	lw	a4,-36(s0)
    8020703a:	fd442783          	lw	a5,-44(s0)
    8020703e:	863a                	mv	a2,a4
    80207040:	85be                	mv	a1,a5
    80207042:	00022517          	auipc	a0,0x22
    80207046:	4ce50513          	addi	a0,a0,1230 # 80229510 <user_test_table+0xa90>
    8020704a:	ffffa097          	auipc	ra,0xffffa
    8020704e:	d44080e7          	jalr	-700(ra) # 80200d8e <printf>
    80207052:	a821                	j	8020706a <test_process_creation+0x36c>
            printf("【错误】: 等待用户进程失败，错误码: %d\n", waited_pid);
    80207054:	f9042783          	lw	a5,-112(s0)
    80207058:	85be                	mv	a1,a5
    8020705a:	00022517          	auipc	a0,0x22
    8020705e:	4de50513          	addi	a0,a0,1246 # 80229538 <user_test_table+0xab8>
    80207062:	ffffa097          	auipc	ra,0xffffa
    80207066:	d2c080e7          	jalr	-724(ra) # 80200d8e <printf>
    for (int i = 0; i < user_count; i++) {
    8020706a:	fd042783          	lw	a5,-48(s0)
    8020706e:	2785                	addiw	a5,a5,1
    80207070:	fcf42823          	sw	a5,-48(s0)
    80207074:	fd042783          	lw	a5,-48(s0)
    80207078:	873e                	mv	a4,a5
    8020707a:	fdc42783          	lw	a5,-36(s0)
    8020707e:	2701                	sext.w	a4,a4
    80207080:	2781                	sext.w	a5,a5
    80207082:	f8f740e3          	blt	a4,a5,80207002 <test_process_creation+0x304>
    printf("【测试结果】: 回收 %d/%d 个用户进程\n", user_success_count, user_count);
    80207086:	fdc42703          	lw	a4,-36(s0)
    8020708a:	fd442783          	lw	a5,-44(s0)
    8020708e:	863a                	mv	a2,a4
    80207090:	85be                	mv	a1,a5
    80207092:	00022517          	auipc	a0,0x22
    80207096:	4de50513          	addi	a0,a0,1246 # 80229570 <user_test_table+0xaf0>
    8020709a:	ffffa097          	auipc	ra,0xffffa
    8020709e:	cf4080e7          	jalr	-780(ra) # 80200d8e <printf>
    print_proc_table();
    802070a2:	fffff097          	auipc	ra,0xfffff
    802070a6:	0ae080e7          	jalr	174(ra) # 80206150 <print_proc_table>
    printf("\n----- 第三阶段：混合进程测试 -----\n");
    802070aa:	00022517          	auipc	a0,0x22
    802070ae:	4fe50513          	addi	a0,a0,1278 # 802295a8 <user_test_table+0xb28>
    802070b2:	ffffa097          	auipc	ra,0xffffa
    802070b6:	cdc080e7          	jalr	-804(ra) # 80200d8e <printf>
    int mixed_kernel_count = 0;
    802070ba:	fc042623          	sw	zero,-52(s0)
    int mixed_user_count = 0;
    802070be:	fc042423          	sw	zero,-56(s0)
    int target_count = PROC / 2;
    802070c2:	47c1                	li	a5,16
    802070c4:	faf42223          	sw	a5,-92(s0)
    printf("创建 %d 个内核进程和 %d 个用户进程...\n", target_count, target_count);
    802070c8:	fa442703          	lw	a4,-92(s0)
    802070cc:	fa442783          	lw	a5,-92(s0)
    802070d0:	863a                	mv	a2,a4
    802070d2:	85be                	mv	a1,a5
    802070d4:	00022517          	auipc	a0,0x22
    802070d8:	50450513          	addi	a0,a0,1284 # 802295d8 <user_test_table+0xb58>
    802070dc:	ffffa097          	auipc	ra,0xffffa
    802070e0:	cb2080e7          	jalr	-846(ra) # 80200d8e <printf>
    for (int i = 0; i < target_count; i++) {
    802070e4:	fc042223          	sw	zero,-60(s0)
    802070e8:	a81d                	j	8020711e <test_process_creation+0x420>
        int new_pid = create_kernel_proc(simple_task);
    802070ea:	00000517          	auipc	a0,0x0
    802070ee:	be450513          	addi	a0,a0,-1052 # 80206cce <simple_task>
    802070f2:	ffffe097          	auipc	ra,0xffffe
    802070f6:	5b4080e7          	jalr	1460(ra) # 802056a6 <create_kernel_proc>
    802070fa:	87aa                	mv	a5,a0
    802070fc:	faf42023          	sw	a5,-96(s0)
        if (new_pid > 0) {
    80207100:	fa042783          	lw	a5,-96(s0)
    80207104:	2781                	sext.w	a5,a5
    80207106:	02f05663          	blez	a5,80207132 <test_process_creation+0x434>
            mixed_kernel_count++;
    8020710a:	fcc42783          	lw	a5,-52(s0)
    8020710e:	2785                	addiw	a5,a5,1
    80207110:	fcf42623          	sw	a5,-52(s0)
    for (int i = 0; i < target_count; i++) {
    80207114:	fc442783          	lw	a5,-60(s0)
    80207118:	2785                	addiw	a5,a5,1
    8020711a:	fcf42223          	sw	a5,-60(s0)
    8020711e:	fc442783          	lw	a5,-60(s0)
    80207122:	873e                	mv	a4,a5
    80207124:	fa442783          	lw	a5,-92(s0)
    80207128:	2701                	sext.w	a4,a4
    8020712a:	2781                	sext.w	a5,a5
    8020712c:	faf74fe3          	blt	a4,a5,802070ea <test_process_creation+0x3ec>
    80207130:	a011                	j	80207134 <test_process_creation+0x436>
            break;
    80207132:	0001                	nop
    for (int i = 0; i < target_count; i++) {
    80207134:	fc042023          	sw	zero,-64(s0)
    80207138:	a83d                	j	80207176 <test_process_creation+0x478>
        int new_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
    8020713a:	06c00793          	li	a5,108
    8020713e:	2781                	sext.w	a5,a5
    80207140:	85be                	mv	a1,a5
    80207142:	00021517          	auipc	a0,0x21
    80207146:	1fe50513          	addi	a0,a0,510 # 80228340 <simple_user_task_bin>
    8020714a:	ffffe097          	auipc	ra,0xffffe
    8020714e:	6a8080e7          	jalr	1704(ra) # 802057f2 <create_user_proc>
    80207152:	87aa                	mv	a5,a0
    80207154:	f8f42e23          	sw	a5,-100(s0)
        if (new_pid > 0) {
    80207158:	f9c42783          	lw	a5,-100(s0)
    8020715c:	2781                	sext.w	a5,a5
    8020715e:	02f05663          	blez	a5,8020718a <test_process_creation+0x48c>
            mixed_user_count++;
    80207162:	fc842783          	lw	a5,-56(s0)
    80207166:	2785                	addiw	a5,a5,1
    80207168:	fcf42423          	sw	a5,-56(s0)
    for (int i = 0; i < target_count; i++) {
    8020716c:	fc042783          	lw	a5,-64(s0)
    80207170:	2785                	addiw	a5,a5,1
    80207172:	fcf42023          	sw	a5,-64(s0)
    80207176:	fc042783          	lw	a5,-64(s0)
    8020717a:	873e                	mv	a4,a5
    8020717c:	fa442783          	lw	a5,-92(s0)
    80207180:	2701                	sext.w	a4,a4
    80207182:	2781                	sext.w	a5,a5
    80207184:	faf74be3          	blt	a4,a5,8020713a <test_process_creation+0x43c>
    80207188:	a011                	j	8020718c <test_process_creation+0x48e>
            break;
    8020718a:	0001                	nop
    printf("【混合测试结果】: 创建了 %d 个内核进程 + %d 个用户进程 = %d 个进程\n", 
    8020718c:	fcc42783          	lw	a5,-52(s0)
    80207190:	873e                	mv	a4,a5
    80207192:	fc842783          	lw	a5,-56(s0)
    80207196:	9fb9                	addw	a5,a5,a4
    80207198:	0007869b          	sext.w	a3,a5
    8020719c:	fc842703          	lw	a4,-56(s0)
    802071a0:	fcc42783          	lw	a5,-52(s0)
    802071a4:	863a                	mv	a2,a4
    802071a6:	85be                	mv	a1,a5
    802071a8:	00022517          	auipc	a0,0x22
    802071ac:	46850513          	addi	a0,a0,1128 # 80229610 <user_test_table+0xb90>
    802071b0:	ffffa097          	auipc	ra,0xffffa
    802071b4:	bde080e7          	jalr	-1058(ra) # 80200d8e <printf>
    print_proc_table();
    802071b8:	fffff097          	auipc	ra,0xfffff
    802071bc:	f98080e7          	jalr	-104(ra) # 80206150 <print_proc_table>
    printf("\n----- 清理混合进程 -----\n");
    802071c0:	00022517          	auipc	a0,0x22
    802071c4:	4b050513          	addi	a0,a0,1200 # 80229670 <user_test_table+0xbf0>
    802071c8:	ffffa097          	auipc	ra,0xffffa
    802071cc:	bc6080e7          	jalr	-1082(ra) # 80200d8e <printf>
    int mixed_success_count = 0;
    802071d0:	fa042e23          	sw	zero,-68(s0)
    int total_mixed = mixed_kernel_count + mixed_user_count;
    802071d4:	fcc42783          	lw	a5,-52(s0)
    802071d8:	873e                	mv	a4,a5
    802071da:	fc842783          	lw	a5,-56(s0)
    802071de:	9fb9                	addw	a5,a5,a4
    802071e0:	f8f42c23          	sw	a5,-104(s0)
    for (int i = 0; i < total_mixed; i++) {
    802071e4:	fa042c23          	sw	zero,-72(s0)
    802071e8:	a805                	j	80207218 <test_process_creation+0x51a>
        int waited_pid = wait_proc(NULL);
    802071ea:	4501                	li	a0,0
    802071ec:	fffff097          	auipc	ra,0xfffff
    802071f0:	dda080e7          	jalr	-550(ra) # 80205fc6 <wait_proc>
    802071f4:	87aa                	mv	a5,a0
    802071f6:	f8f42a23          	sw	a5,-108(s0)
        if (waited_pid > 0) {
    802071fa:	f9442783          	lw	a5,-108(s0)
    802071fe:	2781                	sext.w	a5,a5
    80207200:	00f05763          	blez	a5,8020720e <test_process_creation+0x510>
            mixed_success_count++;
    80207204:	fbc42783          	lw	a5,-68(s0)
    80207208:	2785                	addiw	a5,a5,1
    8020720a:	faf42e23          	sw	a5,-68(s0)
    for (int i = 0; i < total_mixed; i++) {
    8020720e:	fb842783          	lw	a5,-72(s0)
    80207212:	2785                	addiw	a5,a5,1
    80207214:	faf42c23          	sw	a5,-72(s0)
    80207218:	fb842783          	lw	a5,-72(s0)
    8020721c:	873e                	mv	a4,a5
    8020721e:	f9842783          	lw	a5,-104(s0)
    80207222:	2701                	sext.w	a4,a4
    80207224:	2781                	sext.w	a5,a5
    80207226:	fcf742e3          	blt	a4,a5,802071ea <test_process_creation+0x4ec>
    printf("【混合测试结果】: 回收 %d/%d 个混合进程\n", mixed_success_count, total_mixed);
    8020722a:	f9842703          	lw	a4,-104(s0)
    8020722e:	fbc42783          	lw	a5,-68(s0)
    80207232:	863a                	mv	a2,a4
    80207234:	85be                	mv	a1,a5
    80207236:	00022517          	auipc	a0,0x22
    8020723a:	46250513          	addi	a0,a0,1122 # 80229698 <user_test_table+0xc18>
    8020723e:	ffffa097          	auipc	ra,0xffffa
    80207242:	b50080e7          	jalr	-1200(ra) # 80200d8e <printf>
    print_proc_table();
    80207246:	fffff097          	auipc	ra,0xfffff
    8020724a:	f0a080e7          	jalr	-246(ra) # 80206150 <print_proc_table>
    printf("===== 测试结束: 进程创建与管理测试 =====\n");
    8020724e:	00022517          	auipc	a0,0x22
    80207252:	48250513          	addi	a0,a0,1154 # 802296d0 <user_test_table+0xc50>
    80207256:	ffffa097          	auipc	ra,0xffffa
    8020725a:	b38080e7          	jalr	-1224(ra) # 80200d8e <printf>
}
    8020725e:	70e6                	ld	ra,120(sp)
    80207260:	7446                	ld	s0,112(sp)
    80207262:	6109                	addi	sp,sp,128
    80207264:	8082                	ret

0000000080207266 <cpu_intensive_task>:
void cpu_intensive_task(void) {
    80207266:	7139                	addi	sp,sp,-64
    80207268:	fc06                	sd	ra,56(sp)
    8020726a:	f822                	sd	s0,48(sp)
    8020726c:	0080                	addi	s0,sp,64
    int pid = myproc()->pid;
    8020726e:	ffffe097          	auipc	ra,0xffffe
    80207272:	dd2080e7          	jalr	-558(ra) # 80205040 <myproc>
    80207276:	87aa                	mv	a5,a0
    80207278:	43dc                	lw	a5,4(a5)
    8020727a:	fcf42e23          	sw	a5,-36(s0)
    printf("[进程 %d] 开始CPU密集计算\n", pid);
    8020727e:	fdc42783          	lw	a5,-36(s0)
    80207282:	85be                	mv	a1,a5
    80207284:	00022517          	auipc	a0,0x22
    80207288:	48450513          	addi	a0,a0,1156 # 80229708 <user_test_table+0xc88>
    8020728c:	ffffa097          	auipc	ra,0xffffa
    80207290:	b02080e7          	jalr	-1278(ra) # 80200d8e <printf>
    uint64 sum = 0;
    80207294:	fe043423          	sd	zero,-24(s0)
    const uint64 TOTAL_ITERATIONS = 100000000;
    80207298:	05f5e7b7          	lui	a5,0x5f5e
    8020729c:	10078793          	addi	a5,a5,256 # 5f5e100 <_entry-0x7a2a1f00>
    802072a0:	fcf43823          	sd	a5,-48(s0)
    const uint64 REPORT_INTERVAL = TOTAL_ITERATIONS / 100;  // 每完成1%报告一次
    802072a4:	fd043703          	ld	a4,-48(s0)
    802072a8:	06400793          	li	a5,100
    802072ac:	02f757b3          	divu	a5,a4,a5
    802072b0:	fcf43423          	sd	a5,-56(s0)
    for (uint64 i = 0; i < TOTAL_ITERATIONS; i++) {
    802072b4:	fe043023          	sd	zero,-32(s0)
    802072b8:	a8b5                	j	80207334 <cpu_intensive_task+0xce>
        sum += (i * i) % 1000000007;  // 添加乘法和取模运算
    802072ba:	fe043783          	ld	a5,-32(s0)
    802072be:	02f78733          	mul	a4,a5,a5
    802072c2:	3b9ad7b7          	lui	a5,0x3b9ad
    802072c6:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <_entry-0x448535f9>
    802072ca:	02f777b3          	remu	a5,a4,a5
    802072ce:	fe843703          	ld	a4,-24(s0)
    802072d2:	97ba                	add	a5,a5,a4
    802072d4:	fef43423          	sd	a5,-24(s0)
        if (i % REPORT_INTERVAL == 0) {
    802072d8:	fe043703          	ld	a4,-32(s0)
    802072dc:	fc843783          	ld	a5,-56(s0)
    802072e0:	02f777b3          	remu	a5,a4,a5
    802072e4:	e3b9                	bnez	a5,8020732a <cpu_intensive_task+0xc4>
            uint64 percent = (i * 100) / TOTAL_ITERATIONS;
    802072e6:	fe043703          	ld	a4,-32(s0)
    802072ea:	06400793          	li	a5,100
    802072ee:	02f70733          	mul	a4,a4,a5
    802072f2:	fd043783          	ld	a5,-48(s0)
    802072f6:	02f757b3          	divu	a5,a4,a5
    802072fa:	fcf43023          	sd	a5,-64(s0)
            printf("[进程 %d] 完成度: %lu%%，当前sum=%lu\n", 
    802072fe:	fdc42783          	lw	a5,-36(s0)
    80207302:	fe843683          	ld	a3,-24(s0)
    80207306:	fc043603          	ld	a2,-64(s0)
    8020730a:	85be                	mv	a1,a5
    8020730c:	00022517          	auipc	a0,0x22
    80207310:	42450513          	addi	a0,a0,1060 # 80229730 <user_test_table+0xcb0>
    80207314:	ffffa097          	auipc	ra,0xffffa
    80207318:	a7a080e7          	jalr	-1414(ra) # 80200d8e <printf>
            if (i > 0) {
    8020731c:	fe043783          	ld	a5,-32(s0)
    80207320:	c789                	beqz	a5,8020732a <cpu_intensive_task+0xc4>
                yield();
    80207322:	fffff097          	auipc	ra,0xfffff
    80207326:	99a080e7          	jalr	-1638(ra) # 80205cbc <yield>
    for (uint64 i = 0; i < TOTAL_ITERATIONS; i++) {
    8020732a:	fe043783          	ld	a5,-32(s0)
    8020732e:	0785                	addi	a5,a5,1
    80207330:	fef43023          	sd	a5,-32(s0)
    80207334:	fe043703          	ld	a4,-32(s0)
    80207338:	fd043783          	ld	a5,-48(s0)
    8020733c:	f6f76fe3          	bltu	a4,a5,802072ba <cpu_intensive_task+0x54>
    printf("[进程 %d] 计算完成，最终sum=%lu\n", pid, sum);
    80207340:	fdc42783          	lw	a5,-36(s0)
    80207344:	fe843603          	ld	a2,-24(s0)
    80207348:	85be                	mv	a1,a5
    8020734a:	00022517          	auipc	a0,0x22
    8020734e:	41650513          	addi	a0,a0,1046 # 80229760 <user_test_table+0xce0>
    80207352:	ffffa097          	auipc	ra,0xffffa
    80207356:	a3c080e7          	jalr	-1476(ra) # 80200d8e <printf>
    exit_proc(0);
    8020735a:	4501                	li	a0,0
    8020735c:	fffff097          	auipc	ra,0xfffff
    80207360:	ba0080e7          	jalr	-1120(ra) # 80205efc <exit_proc>
}
    80207364:	0001                	nop
    80207366:	70e2                	ld	ra,56(sp)
    80207368:	7442                	ld	s0,48(sp)
    8020736a:	6121                	addi	sp,sp,64
    8020736c:	8082                	ret

000000008020736e <test_scheduler>:
void test_scheduler(void) {
    8020736e:	715d                	addi	sp,sp,-80
    80207370:	e486                	sd	ra,72(sp)
    80207372:	e0a2                	sd	s0,64(sp)
    80207374:	0880                	addi	s0,sp,80
    printf("\n===== 测试开始: 调度器公平性测试 =====\n");
    80207376:	00022517          	auipc	a0,0x22
    8020737a:	41a50513          	addi	a0,a0,1050 # 80229790 <user_test_table+0xd10>
    8020737e:	ffffa097          	auipc	ra,0xffffa
    80207382:	a10080e7          	jalr	-1520(ra) # 80200d8e <printf>
    for (int i = 0; i < 3; i++) {
    80207386:	fe042623          	sw	zero,-20(s0)
    8020738a:	a8a5                	j	80207402 <test_scheduler+0x94>
        pids[i] = create_kernel_proc(cpu_intensive_task);
    8020738c:	00000517          	auipc	a0,0x0
    80207390:	eda50513          	addi	a0,a0,-294 # 80207266 <cpu_intensive_task>
    80207394:	ffffe097          	auipc	ra,0xffffe
    80207398:	312080e7          	jalr	786(ra) # 802056a6 <create_kernel_proc>
    8020739c:	87aa                	mv	a5,a0
    8020739e:	873e                	mv	a4,a5
    802073a0:	fec42783          	lw	a5,-20(s0)
    802073a4:	078a                	slli	a5,a5,0x2
    802073a6:	17c1                	addi	a5,a5,-16
    802073a8:	97a2                	add	a5,a5,s0
    802073aa:	fce7a823          	sw	a4,-48(a5)
        if (pids[i] < 0) {
    802073ae:	fec42783          	lw	a5,-20(s0)
    802073b2:	078a                	slli	a5,a5,0x2
    802073b4:	17c1                	addi	a5,a5,-16
    802073b6:	97a2                	add	a5,a5,s0
    802073b8:	fd07a783          	lw	a5,-48(a5)
    802073bc:	0007de63          	bgez	a5,802073d8 <test_scheduler+0x6a>
            printf("【错误】创建进程 %d 失败\n", i);
    802073c0:	fec42783          	lw	a5,-20(s0)
    802073c4:	85be                	mv	a1,a5
    802073c6:	00022517          	auipc	a0,0x22
    802073ca:	40250513          	addi	a0,a0,1026 # 802297c8 <user_test_table+0xd48>
    802073ce:	ffffa097          	auipc	ra,0xffffa
    802073d2:	9c0080e7          	jalr	-1600(ra) # 80200d8e <printf>
    802073d6:	a239                	j	802074e4 <test_scheduler+0x176>
        printf("创建进程成功，PID: %d\n", pids[i]);
    802073d8:	fec42783          	lw	a5,-20(s0)
    802073dc:	078a                	slli	a5,a5,0x2
    802073de:	17c1                	addi	a5,a5,-16
    802073e0:	97a2                	add	a5,a5,s0
    802073e2:	fd07a783          	lw	a5,-48(a5)
    802073e6:	85be                	mv	a1,a5
    802073e8:	00022517          	auipc	a0,0x22
    802073ec:	40850513          	addi	a0,a0,1032 # 802297f0 <user_test_table+0xd70>
    802073f0:	ffffa097          	auipc	ra,0xffffa
    802073f4:	99e080e7          	jalr	-1634(ra) # 80200d8e <printf>
    for (int i = 0; i < 3; i++) {
    802073f8:	fec42783          	lw	a5,-20(s0)
    802073fc:	2785                	addiw	a5,a5,1
    802073fe:	fef42623          	sw	a5,-20(s0)
    80207402:	fec42783          	lw	a5,-20(s0)
    80207406:	0007871b          	sext.w	a4,a5
    8020740a:	4789                	li	a5,2
    8020740c:	f8e7d0e3          	bge	a5,a4,8020738c <test_scheduler+0x1e>
    uint64 start_time = get_time();
    80207410:	fffff097          	auipc	ra,0xfffff
    80207414:	362080e7          	jalr	866(ra) # 80206772 <get_time>
    80207418:	fea43023          	sd	a0,-32(s0)
    int completed = 0;
    8020741c:	fe042423          	sw	zero,-24(s0)
    while (completed < 3) {
    80207420:	a0a9                	j	8020746a <test_scheduler+0xfc>
        int pid = wait_proc(&status);
    80207422:	fbc40793          	addi	a5,s0,-68
    80207426:	853e                	mv	a0,a5
    80207428:	fffff097          	auipc	ra,0xfffff
    8020742c:	b9e080e7          	jalr	-1122(ra) # 80205fc6 <wait_proc>
    80207430:	87aa                	mv	a5,a0
    80207432:	fcf42623          	sw	a5,-52(s0)
        if (pid > 0) {
    80207436:	fcc42783          	lw	a5,-52(s0)
    8020743a:	2781                	sext.w	a5,a5
    8020743c:	02f05763          	blez	a5,8020746a <test_scheduler+0xfc>
            completed++;
    80207440:	fe842783          	lw	a5,-24(s0)
    80207444:	2785                	addiw	a5,a5,1
    80207446:	fef42423          	sw	a5,-24(s0)
            printf("进程 %d 已完成，退出状态: %d (%d/3)\n", 
    8020744a:	fbc42703          	lw	a4,-68(s0)
    8020744e:	fe842683          	lw	a3,-24(s0)
    80207452:	fcc42783          	lw	a5,-52(s0)
    80207456:	863a                	mv	a2,a4
    80207458:	85be                	mv	a1,a5
    8020745a:	00022517          	auipc	a0,0x22
    8020745e:	3b650513          	addi	a0,a0,950 # 80229810 <user_test_table+0xd90>
    80207462:	ffffa097          	auipc	ra,0xffffa
    80207466:	92c080e7          	jalr	-1748(ra) # 80200d8e <printf>
    while (completed < 3) {
    8020746a:	fe842783          	lw	a5,-24(s0)
    8020746e:	0007871b          	sext.w	a4,a5
    80207472:	4789                	li	a5,2
    80207474:	fae7d7e3          	bge	a5,a4,80207422 <test_scheduler+0xb4>
    uint64 end_time = get_time();
    80207478:	fffff097          	auipc	ra,0xfffff
    8020747c:	2fa080e7          	jalr	762(ra) # 80206772 <get_time>
    80207480:	fca43c23          	sd	a0,-40(s0)
    uint64 total_cycles = end_time - start_time;
    80207484:	fd843703          	ld	a4,-40(s0)
    80207488:	fe043783          	ld	a5,-32(s0)
    8020748c:	40f707b3          	sub	a5,a4,a5
    80207490:	fcf43823          	sd	a5,-48(s0)
    printf("\n----- 测试结果 -----\n");
    80207494:	00022517          	auipc	a0,0x22
    80207498:	3ac50513          	addi	a0,a0,940 # 80229840 <user_test_table+0xdc0>
    8020749c:	ffffa097          	auipc	ra,0xffffa
    802074a0:	8f2080e7          	jalr	-1806(ra) # 80200d8e <printf>
    printf("总执行时间: %lu cycles\n", total_cycles);
    802074a4:	fd043583          	ld	a1,-48(s0)
    802074a8:	00022517          	auipc	a0,0x22
    802074ac:	3b850513          	addi	a0,a0,952 # 80229860 <user_test_table+0xde0>
    802074b0:	ffffa097          	auipc	ra,0xffffa
    802074b4:	8de080e7          	jalr	-1826(ra) # 80200d8e <printf>
    printf("平均每个进程执行时间: %lu cycles\n", total_cycles / 3);
    802074b8:	fd043703          	ld	a4,-48(s0)
    802074bc:	478d                	li	a5,3
    802074be:	02f757b3          	divu	a5,a4,a5
    802074c2:	85be                	mv	a1,a5
    802074c4:	00022517          	auipc	a0,0x22
    802074c8:	3bc50513          	addi	a0,a0,956 # 80229880 <user_test_table+0xe00>
    802074cc:	ffffa097          	auipc	ra,0xffffa
    802074d0:	8c2080e7          	jalr	-1854(ra) # 80200d8e <printf>
    printf("===== 调度器测试完成 =====\n");
    802074d4:	00022517          	auipc	a0,0x22
    802074d8:	3dc50513          	addi	a0,a0,988 # 802298b0 <user_test_table+0xe30>
    802074dc:	ffffa097          	auipc	ra,0xffffa
    802074e0:	8b2080e7          	jalr	-1870(ra) # 80200d8e <printf>
}
    802074e4:	60a6                	ld	ra,72(sp)
    802074e6:	6406                	ld	s0,64(sp)
    802074e8:	6161                	addi	sp,sp,80
    802074ea:	8082                	ret

00000000802074ec <shared_buffer_init>:
void shared_buffer_init() {
    802074ec:	1141                	addi	sp,sp,-16
    802074ee:	e422                	sd	s0,8(sp)
    802074f0:	0800                	addi	s0,sp,16
    proc_buffer = 0;
    802074f2:	00035797          	auipc	a5,0x35
    802074f6:	20678793          	addi	a5,a5,518 # 8023c6f8 <proc_buffer>
    802074fa:	0007a023          	sw	zero,0(a5)
    proc_produced = 0;
    802074fe:	00035797          	auipc	a5,0x35
    80207502:	1fe78793          	addi	a5,a5,510 # 8023c6fc <proc_produced>
    80207506:	0007a023          	sw	zero,0(a5)
}
    8020750a:	0001                	nop
    8020750c:	6422                	ld	s0,8(sp)
    8020750e:	0141                	addi	sp,sp,16
    80207510:	8082                	ret

0000000080207512 <producer_task>:
void producer_task(void) {
    80207512:	7179                	addi	sp,sp,-48
    80207514:	f406                	sd	ra,40(sp)
    80207516:	f022                	sd	s0,32(sp)
    80207518:	1800                	addi	s0,sp,48
	int pid = myproc()->pid;
    8020751a:	ffffe097          	auipc	ra,0xffffe
    8020751e:	b26080e7          	jalr	-1242(ra) # 80205040 <myproc>
    80207522:	87aa                	mv	a5,a0
    80207524:	43dc                	lw	a5,4(a5)
    80207526:	fcf42e23          	sw	a5,-36(s0)
    uint64 sum = 0;
    8020752a:	fe043423          	sd	zero,-24(s0)
    const uint64 ITERATIONS = 10000000;  // 一千万次循环
    8020752e:	009897b7          	lui	a5,0x989
    80207532:	68078793          	addi	a5,a5,1664 # 989680 <_entry-0x7f876980>
    80207536:	fcf43823          	sd	a5,-48(s0)
    for(uint64 i = 0; i < ITERATIONS; i++) {
    8020753a:	fe043023          	sd	zero,-32(s0)
    8020753e:	a0bd                	j	802075ac <producer_task+0x9a>
        sum += (i * i) % 1000000007;  // 复杂计算
    80207540:	fe043783          	ld	a5,-32(s0)
    80207544:	02f78733          	mul	a4,a5,a5
    80207548:	3b9ad7b7          	lui	a5,0x3b9ad
    8020754c:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <_entry-0x448535f9>
    80207550:	02f777b3          	remu	a5,a4,a5
    80207554:	fe843703          	ld	a4,-24(s0)
    80207558:	97ba                	add	a5,a5,a4
    8020755a:	fef43423          	sd	a5,-24(s0)
        if(i % (ITERATIONS/10) == 0) {
    8020755e:	fd043703          	ld	a4,-48(s0)
    80207562:	47a9                	li	a5,10
    80207564:	02f757b3          	divu	a5,a4,a5
    80207568:	fe043703          	ld	a4,-32(s0)
    8020756c:	02f777b3          	remu	a5,a4,a5
    80207570:	eb8d                	bnez	a5,802075a2 <producer_task+0x90>
                   pid, (int)(i * 100 / ITERATIONS));
    80207572:	fe043703          	ld	a4,-32(s0)
    80207576:	06400793          	li	a5,100
    8020757a:	02f70733          	mul	a4,a4,a5
    8020757e:	fd043783          	ld	a5,-48(s0)
    80207582:	02f757b3          	divu	a5,a4,a5
            printf("[Producer %d] 计算进度: %d%%\n", 
    80207586:	0007871b          	sext.w	a4,a5
    8020758a:	fdc42783          	lw	a5,-36(s0)
    8020758e:	863a                	mv	a2,a4
    80207590:	85be                	mv	a1,a5
    80207592:	00022517          	auipc	a0,0x22
    80207596:	34650513          	addi	a0,a0,838 # 802298d8 <user_test_table+0xe58>
    8020759a:	ffff9097          	auipc	ra,0xffff9
    8020759e:	7f4080e7          	jalr	2036(ra) # 80200d8e <printf>
    for(uint64 i = 0; i < ITERATIONS; i++) {
    802075a2:	fe043783          	ld	a5,-32(s0)
    802075a6:	0785                	addi	a5,a5,1
    802075a8:	fef43023          	sd	a5,-32(s0)
    802075ac:	fe043703          	ld	a4,-32(s0)
    802075b0:	fd043783          	ld	a5,-48(s0)
    802075b4:	f8f766e3          	bltu	a4,a5,80207540 <producer_task+0x2e>
    proc_buffer = 42;
    802075b8:	00035797          	auipc	a5,0x35
    802075bc:	14078793          	addi	a5,a5,320 # 8023c6f8 <proc_buffer>
    802075c0:	02a00713          	li	a4,42
    802075c4:	c398                	sw	a4,0(a5)
    proc_produced = 1;
    802075c6:	00035797          	auipc	a5,0x35
    802075ca:	13678793          	addi	a5,a5,310 # 8023c6fc <proc_produced>
    802075ce:	4705                	li	a4,1
    802075d0:	c398                	sw	a4,0(a5)
    wakeup(&proc_produced); // 唤醒消费者
    802075d2:	00035517          	auipc	a0,0x35
    802075d6:	12a50513          	addi	a0,a0,298 # 8023c6fc <proc_produced>
    802075da:	fffff097          	auipc	ra,0xfffff
    802075de:	840080e7          	jalr	-1984(ra) # 80205e1a <wakeup>
    printf("Producer: produced value %d\n", proc_buffer);
    802075e2:	00035797          	auipc	a5,0x35
    802075e6:	11678793          	addi	a5,a5,278 # 8023c6f8 <proc_buffer>
    802075ea:	439c                	lw	a5,0(a5)
    802075ec:	85be                	mv	a1,a5
    802075ee:	00022517          	auipc	a0,0x22
    802075f2:	31250513          	addi	a0,a0,786 # 80229900 <user_test_table+0xe80>
    802075f6:	ffff9097          	auipc	ra,0xffff9
    802075fa:	798080e7          	jalr	1944(ra) # 80200d8e <printf>
    exit_proc(0);
    802075fe:	4501                	li	a0,0
    80207600:	fffff097          	auipc	ra,0xfffff
    80207604:	8fc080e7          	jalr	-1796(ra) # 80205efc <exit_proc>
}
    80207608:	0001                	nop
    8020760a:	70a2                	ld	ra,40(sp)
    8020760c:	7402                	ld	s0,32(sp)
    8020760e:	6145                	addi	sp,sp,48
    80207610:	8082                	ret

0000000080207612 <consumer_task>:
void consumer_task(void) {
    80207612:	1141                	addi	sp,sp,-16
    80207614:	e406                	sd	ra,8(sp)
    80207616:	e022                	sd	s0,0(sp)
    80207618:	0800                	addi	s0,sp,16
    while (!proc_produced) {
    8020761a:	a015                	j	8020763e <consumer_task+0x2c>
		printf("wait for producer\n");
    8020761c:	00022517          	auipc	a0,0x22
    80207620:	30450513          	addi	a0,a0,772 # 80229920 <user_test_table+0xea0>
    80207624:	ffff9097          	auipc	ra,0xffff9
    80207628:	76a080e7          	jalr	1898(ra) # 80200d8e <printf>
        sleep(&proc_produced,NULL); // 等待生产者
    8020762c:	4581                	li	a1,0
    8020762e:	00035517          	auipc	a0,0x35
    80207632:	0ce50513          	addi	a0,a0,206 # 8023c6fc <proc_produced>
    80207636:	ffffe097          	auipc	ra,0xffffe
    8020763a:	72c080e7          	jalr	1836(ra) # 80205d62 <sleep>
    while (!proc_produced) {
    8020763e:	00035797          	auipc	a5,0x35
    80207642:	0be78793          	addi	a5,a5,190 # 8023c6fc <proc_produced>
    80207646:	439c                	lw	a5,0(a5)
    80207648:	dbf1                	beqz	a5,8020761c <consumer_task+0xa>
    printf("Consumer: consumed value %d\n", proc_buffer);
    8020764a:	00035797          	auipc	a5,0x35
    8020764e:	0ae78793          	addi	a5,a5,174 # 8023c6f8 <proc_buffer>
    80207652:	439c                	lw	a5,0(a5)
    80207654:	85be                	mv	a1,a5
    80207656:	00022517          	auipc	a0,0x22
    8020765a:	2e250513          	addi	a0,a0,738 # 80229938 <user_test_table+0xeb8>
    8020765e:	ffff9097          	auipc	ra,0xffff9
    80207662:	730080e7          	jalr	1840(ra) # 80200d8e <printf>
    exit_proc(0);
    80207666:	4501                	li	a0,0
    80207668:	fffff097          	auipc	ra,0xfffff
    8020766c:	894080e7          	jalr	-1900(ra) # 80205efc <exit_proc>
}
    80207670:	0001                	nop
    80207672:	60a2                	ld	ra,8(sp)
    80207674:	6402                	ld	s0,0(sp)
    80207676:	0141                	addi	sp,sp,16
    80207678:	8082                	ret

000000008020767a <test_synchronization>:
void test_synchronization(void) {
    8020767a:	1141                	addi	sp,sp,-16
    8020767c:	e406                	sd	ra,8(sp)
    8020767e:	e022                	sd	s0,0(sp)
    80207680:	0800                	addi	s0,sp,16
    printf("===== 测试开始: 同步机制测试 =====\n");
    80207682:	00022517          	auipc	a0,0x22
    80207686:	2d650513          	addi	a0,a0,726 # 80229958 <user_test_table+0xed8>
    8020768a:	ffff9097          	auipc	ra,0xffff9
    8020768e:	704080e7          	jalr	1796(ra) # 80200d8e <printf>
    shared_buffer_init();
    80207692:	00000097          	auipc	ra,0x0
    80207696:	e5a080e7          	jalr	-422(ra) # 802074ec <shared_buffer_init>
    create_kernel_proc(producer_task);
    8020769a:	00000517          	auipc	a0,0x0
    8020769e:	e7850513          	addi	a0,a0,-392 # 80207512 <producer_task>
    802076a2:	ffffe097          	auipc	ra,0xffffe
    802076a6:	004080e7          	jalr	4(ra) # 802056a6 <create_kernel_proc>
    create_kernel_proc(consumer_task);
    802076aa:	00000517          	auipc	a0,0x0
    802076ae:	f6850513          	addi	a0,a0,-152 # 80207612 <consumer_task>
    802076b2:	ffffe097          	auipc	ra,0xffffe
    802076b6:	ff4080e7          	jalr	-12(ra) # 802056a6 <create_kernel_proc>
    wait_proc(NULL);
    802076ba:	4501                	li	a0,0
    802076bc:	fffff097          	auipc	ra,0xfffff
    802076c0:	90a080e7          	jalr	-1782(ra) # 80205fc6 <wait_proc>
    wait_proc(NULL);
    802076c4:	4501                	li	a0,0
    802076c6:	fffff097          	auipc	ra,0xfffff
    802076ca:	900080e7          	jalr	-1792(ra) # 80205fc6 <wait_proc>
    printf("===== 测试结束 =====\n");
    802076ce:	00022517          	auipc	a0,0x22
    802076d2:	2ba50513          	addi	a0,a0,698 # 80229988 <user_test_table+0xf08>
    802076d6:	ffff9097          	auipc	ra,0xffff9
    802076da:	6b8080e7          	jalr	1720(ra) # 80200d8e <printf>
}
    802076de:	0001                	nop
    802076e0:	60a2                	ld	ra,8(sp)
    802076e2:	6402                	ld	s0,0(sp)
    802076e4:	0141                	addi	sp,sp,16
    802076e6:	8082                	ret

00000000802076e8 <sys_access_task>:
void sys_access_task(void) {
    802076e8:	1101                	addi	sp,sp,-32
    802076ea:	ec06                	sd	ra,24(sp)
    802076ec:	e822                	sd	s0,16(sp)
    802076ee:	1000                	addi	s0,sp,32
    volatile int *ptr = (int*)0x80200000; // 内核空间地址
    802076f0:	40100793          	li	a5,1025
    802076f4:	07d6                	slli	a5,a5,0x15
    802076f6:	fef43423          	sd	a5,-24(s0)
    printf("SYS: try read kernel addr 0x80200000\n");
    802076fa:	00022517          	auipc	a0,0x22
    802076fe:	2ae50513          	addi	a0,a0,686 # 802299a8 <user_test_table+0xf28>
    80207702:	ffff9097          	auipc	ra,0xffff9
    80207706:	68c080e7          	jalr	1676(ra) # 80200d8e <printf>
    int val = *ptr;
    8020770a:	fe843783          	ld	a5,-24(s0)
    8020770e:	439c                	lw	a5,0(a5)
    80207710:	fef42223          	sw	a5,-28(s0)
    printf("SYS: read success, value=%d\n", val);
    80207714:	fe442783          	lw	a5,-28(s0)
    80207718:	85be                	mv	a1,a5
    8020771a:	00022517          	auipc	a0,0x22
    8020771e:	2b650513          	addi	a0,a0,694 # 802299d0 <user_test_table+0xf50>
    80207722:	ffff9097          	auipc	ra,0xffff9
    80207726:	66c080e7          	jalr	1644(ra) # 80200d8e <printf>
    exit_proc(0);
    8020772a:	4501                	li	a0,0
    8020772c:	ffffe097          	auipc	ra,0xffffe
    80207730:	7d0080e7          	jalr	2000(ra) # 80205efc <exit_proc>
}
    80207734:	0001                	nop
    80207736:	60e2                	ld	ra,24(sp)
    80207738:	6442                	ld	s0,16(sp)
    8020773a:	6105                	addi	sp,sp,32
    8020773c:	8082                	ret

000000008020773e <infinite_task>:
void infinite_task(void){
    8020773e:	1101                	addi	sp,sp,-32
    80207740:	ec06                	sd	ra,24(sp)
    80207742:	e822                	sd	s0,16(sp)
    80207744:	1000                	addi	s0,sp,32
	int count = 5000 ;
    80207746:	6785                	lui	a5,0x1
    80207748:	38878793          	addi	a5,a5,904 # 1388 <_entry-0x801fec78>
    8020774c:	fef42623          	sw	a5,-20(s0)
	while(count){
    80207750:	a835                	j	8020778c <infinite_task+0x4e>
		count--;
    80207752:	fec42783          	lw	a5,-20(s0)
    80207756:	37fd                	addiw	a5,a5,-1
    80207758:	fef42623          	sw	a5,-20(s0)
		if (count % 100 == 0)
    8020775c:	fec42783          	lw	a5,-20(s0)
    80207760:	873e                	mv	a4,a5
    80207762:	06400793          	li	a5,100
    80207766:	02f767bb          	remw	a5,a4,a5
    8020776a:	2781                	sext.w	a5,a5
    8020776c:	ef81                	bnez	a5,80207784 <infinite_task+0x46>
			printf("count for %d\n",count);
    8020776e:	fec42783          	lw	a5,-20(s0)
    80207772:	85be                	mv	a1,a5
    80207774:	00022517          	auipc	a0,0x22
    80207778:	27c50513          	addi	a0,a0,636 # 802299f0 <user_test_table+0xf70>
    8020777c:	ffff9097          	auipc	ra,0xffff9
    80207780:	612080e7          	jalr	1554(ra) # 80200d8e <printf>
		yield();
    80207784:	ffffe097          	auipc	ra,0xffffe
    80207788:	538080e7          	jalr	1336(ra) # 80205cbc <yield>
	while(count){
    8020778c:	fec42783          	lw	a5,-20(s0)
    80207790:	2781                	sext.w	a5,a5
    80207792:	f3e1                	bnez	a5,80207752 <infinite_task+0x14>
	warning("INFINITE TASK FINISH WITHOUT KILLED!!\n");
    80207794:	00022517          	auipc	a0,0x22
    80207798:	26c50513          	addi	a0,a0,620 # 80229a00 <user_test_table+0xf80>
    8020779c:	ffffa097          	auipc	ra,0xffffa
    802077a0:	072080e7          	jalr	114(ra) # 8020180e <warning>
}
    802077a4:	0001                	nop
    802077a6:	60e2                	ld	ra,24(sp)
    802077a8:	6442                	ld	s0,16(sp)
    802077aa:	6105                	addi	sp,sp,32
    802077ac:	8082                	ret

00000000802077ae <killer_task>:
void killer_task(uint64 kill_pid){
    802077ae:	7179                	addi	sp,sp,-48
    802077b0:	f406                	sd	ra,40(sp)
    802077b2:	f022                	sd	s0,32(sp)
    802077b4:	1800                	addi	s0,sp,48
    802077b6:	fca43c23          	sd	a0,-40(s0)
	int count = 500;
    802077ba:	1f400793          	li	a5,500
    802077be:	fef42623          	sw	a5,-20(s0)
	while(count){
    802077c2:	a81d                	j	802077f8 <killer_task+0x4a>
		count--;
    802077c4:	fec42783          	lw	a5,-20(s0)
    802077c8:	37fd                	addiw	a5,a5,-1
    802077ca:	fef42623          	sw	a5,-20(s0)
		if(count % 100 == 0)
    802077ce:	fec42783          	lw	a5,-20(s0)
    802077d2:	873e                	mv	a4,a5
    802077d4:	06400793          	li	a5,100
    802077d8:	02f767bb          	remw	a5,a4,a5
    802077dc:	2781                	sext.w	a5,a5
    802077de:	eb89                	bnez	a5,802077f0 <killer_task+0x42>
			printf("I see you!!!\n");
    802077e0:	00022517          	auipc	a0,0x22
    802077e4:	24850513          	addi	a0,a0,584 # 80229a28 <user_test_table+0xfa8>
    802077e8:	ffff9097          	auipc	ra,0xffff9
    802077ec:	5a6080e7          	jalr	1446(ra) # 80200d8e <printf>
		yield();
    802077f0:	ffffe097          	auipc	ra,0xffffe
    802077f4:	4cc080e7          	jalr	1228(ra) # 80205cbc <yield>
	while(count){
    802077f8:	fec42783          	lw	a5,-20(s0)
    802077fc:	2781                	sext.w	a5,a5
    802077fe:	f3f9                	bnez	a5,802077c4 <killer_task+0x16>
	kill_proc((int)kill_pid);
    80207800:	fd843783          	ld	a5,-40(s0)
    80207804:	2781                	sext.w	a5,a5
    80207806:	853e                	mv	a0,a5
    80207808:	ffffe097          	auipc	ra,0xffffe
    8020780c:	690080e7          	jalr	1680(ra) # 80205e98 <kill_proc>
	printf("Killed proc %d\n",(int)kill_pid);
    80207810:	fd843783          	ld	a5,-40(s0)
    80207814:	2781                	sext.w	a5,a5
    80207816:	85be                	mv	a1,a5
    80207818:	00022517          	auipc	a0,0x22
    8020781c:	22050513          	addi	a0,a0,544 # 80229a38 <user_test_table+0xfb8>
    80207820:	ffff9097          	auipc	ra,0xffff9
    80207824:	56e080e7          	jalr	1390(ra) # 80200d8e <printf>
	exit_proc(0);
    80207828:	4501                	li	a0,0
    8020782a:	ffffe097          	auipc	ra,0xffffe
    8020782e:	6d2080e7          	jalr	1746(ra) # 80205efc <exit_proc>
}
    80207832:	0001                	nop
    80207834:	70a2                	ld	ra,40(sp)
    80207836:	7402                	ld	s0,32(sp)
    80207838:	6145                	addi	sp,sp,48
    8020783a:	8082                	ret

000000008020783c <victim_task>:
void victim_task(void){
    8020783c:	1101                	addi	sp,sp,-32
    8020783e:	ec06                	sd	ra,24(sp)
    80207840:	e822                	sd	s0,16(sp)
    80207842:	1000                	addi	s0,sp,32
	int count =5000;
    80207844:	6785                	lui	a5,0x1
    80207846:	38878793          	addi	a5,a5,904 # 1388 <_entry-0x801fec78>
    8020784a:	fef42623          	sw	a5,-20(s0)
	while(count){
    8020784e:	a81d                	j	80207884 <victim_task+0x48>
		count--;
    80207850:	fec42783          	lw	a5,-20(s0)
    80207854:	37fd                	addiw	a5,a5,-1
    80207856:	fef42623          	sw	a5,-20(s0)
		if(count % 100 == 0)
    8020785a:	fec42783          	lw	a5,-20(s0)
    8020785e:	873e                	mv	a4,a5
    80207860:	06400793          	li	a5,100
    80207864:	02f767bb          	remw	a5,a4,a5
    80207868:	2781                	sext.w	a5,a5
    8020786a:	eb89                	bnez	a5,8020787c <victim_task+0x40>
			printf("Call for help!!\n");
    8020786c:	00022517          	auipc	a0,0x22
    80207870:	1dc50513          	addi	a0,a0,476 # 80229a48 <user_test_table+0xfc8>
    80207874:	ffff9097          	auipc	ra,0xffff9
    80207878:	51a080e7          	jalr	1306(ra) # 80200d8e <printf>
		yield();
    8020787c:	ffffe097          	auipc	ra,0xffffe
    80207880:	440080e7          	jalr	1088(ra) # 80205cbc <yield>
	while(count){
    80207884:	fec42783          	lw	a5,-20(s0)
    80207888:	2781                	sext.w	a5,a5
    8020788a:	f3f9                	bnez	a5,80207850 <victim_task+0x14>
	printf("No one can kill me!\n");
    8020788c:	00022517          	auipc	a0,0x22
    80207890:	1d450513          	addi	a0,a0,468 # 80229a60 <user_test_table+0xfe0>
    80207894:	ffff9097          	auipc	ra,0xffff9
    80207898:	4fa080e7          	jalr	1274(ra) # 80200d8e <printf>
	exit_proc(0);
    8020789c:	4501                	li	a0,0
    8020789e:	ffffe097          	auipc	ra,0xffffe
    802078a2:	65e080e7          	jalr	1630(ra) # 80205efc <exit_proc>
}
    802078a6:	0001                	nop
    802078a8:	60e2                	ld	ra,24(sp)
    802078aa:	6442                	ld	s0,16(sp)
    802078ac:	6105                	addi	sp,sp,32
    802078ae:	8082                	ret

00000000802078b0 <test_kill>:
void test_kill(void){
    802078b0:	7179                	addi	sp,sp,-48
    802078b2:	f406                	sd	ra,40(sp)
    802078b4:	f022                	sd	s0,32(sp)
    802078b6:	1800                	addi	s0,sp,48
	printf("\n----- 测试1: 创建后立即杀死 -----\n");
    802078b8:	00022517          	auipc	a0,0x22
    802078bc:	1c050513          	addi	a0,a0,448 # 80229a78 <user_test_table+0xff8>
    802078c0:	ffff9097          	auipc	ra,0xffff9
    802078c4:	4ce080e7          	jalr	1230(ra) # 80200d8e <printf>
	int pid =create_kernel_proc(simple_task);
    802078c8:	fffff517          	auipc	a0,0xfffff
    802078cc:	40650513          	addi	a0,a0,1030 # 80206cce <simple_task>
    802078d0:	ffffe097          	auipc	ra,0xffffe
    802078d4:	dd6080e7          	jalr	-554(ra) # 802056a6 <create_kernel_proc>
    802078d8:	87aa                	mv	a5,a0
    802078da:	fef42423          	sw	a5,-24(s0)
	printf("【测试】: 创建进程成功，PID: %d\n", pid);
    802078de:	fe842783          	lw	a5,-24(s0)
    802078e2:	85be                	mv	a1,a5
    802078e4:	00022517          	auipc	a0,0x22
    802078e8:	1c450513          	addi	a0,a0,452 # 80229aa8 <user_test_table+0x1028>
    802078ec:	ffff9097          	auipc	ra,0xffff9
    802078f0:	4a2080e7          	jalr	1186(ra) # 80200d8e <printf>
	kill_proc(pid);
    802078f4:	fe842783          	lw	a5,-24(s0)
    802078f8:	853e                	mv	a0,a5
    802078fa:	ffffe097          	auipc	ra,0xffffe
    802078fe:	59e080e7          	jalr	1438(ra) # 80205e98 <kill_proc>
	printf("【测试】: 等待被杀死的进程退出,此处被杀死的进程不会有输出...\n");
    80207902:	00022517          	auipc	a0,0x22
    80207906:	1d650513          	addi	a0,a0,470 # 80229ad8 <user_test_table+0x1058>
    8020790a:	ffff9097          	auipc	ra,0xffff9
    8020790e:	484080e7          	jalr	1156(ra) # 80200d8e <printf>
	int ret =0;
    80207912:	fc042c23          	sw	zero,-40(s0)
	wait_proc(&ret);
    80207916:	fd840793          	addi	a5,s0,-40
    8020791a:	853e                	mv	a0,a5
    8020791c:	ffffe097          	auipc	ra,0xffffe
    80207920:	6aa080e7          	jalr	1706(ra) # 80205fc6 <wait_proc>
	printf("【测试】: 进程%d退出，退出码应该为129，此处为%d\n ",pid,ret);
    80207924:	fd842703          	lw	a4,-40(s0)
    80207928:	fe842783          	lw	a5,-24(s0)
    8020792c:	863a                	mv	a2,a4
    8020792e:	85be                	mv	a1,a5
    80207930:	00022517          	auipc	a0,0x22
    80207934:	20850513          	addi	a0,a0,520 # 80229b38 <user_test_table+0x10b8>
    80207938:	ffff9097          	auipc	ra,0xffff9
    8020793c:	456080e7          	jalr	1110(ra) # 80200d8e <printf>
	if(SYS_kill == ret){
    80207940:	fd842783          	lw	a5,-40(s0)
    80207944:	873e                	mv	a4,a5
    80207946:	08100793          	li	a5,129
    8020794a:	00f71b63          	bne	a4,a5,80207960 <test_kill+0xb0>
		printf("【测试】:尝试立即杀死进程，测试成功\n");
    8020794e:	00022517          	auipc	a0,0x22
    80207952:	23250513          	addi	a0,a0,562 # 80229b80 <user_test_table+0x1100>
    80207956:	ffff9097          	auipc	ra,0xffff9
    8020795a:	438080e7          	jalr	1080(ra) # 80200d8e <printf>
    8020795e:	a831                	j	8020797a <test_kill+0xca>
		printf("【测试】:尝试立即杀死进程失败，退出\n");
    80207960:	00022517          	auipc	a0,0x22
    80207964:	25850513          	addi	a0,a0,600 # 80229bb8 <user_test_table+0x1138>
    80207968:	ffff9097          	auipc	ra,0xffff9
    8020796c:	426080e7          	jalr	1062(ra) # 80200d8e <printf>
		exit_proc(0);
    80207970:	4501                	li	a0,0
    80207972:	ffffe097          	auipc	ra,0xffffe
    80207976:	58a080e7          	jalr	1418(ra) # 80205efc <exit_proc>
	printf("\n----- 测试2: 创建后稍后杀死 -----\n");
    8020797a:	00022517          	auipc	a0,0x22
    8020797e:	27650513          	addi	a0,a0,630 # 80229bf0 <user_test_table+0x1170>
    80207982:	ffff9097          	auipc	ra,0xffff9
    80207986:	40c080e7          	jalr	1036(ra) # 80200d8e <printf>
	pid = create_kernel_proc(infinite_task);
    8020798a:	00000517          	auipc	a0,0x0
    8020798e:	db450513          	addi	a0,a0,-588 # 8020773e <infinite_task>
    80207992:	ffffe097          	auipc	ra,0xffffe
    80207996:	d14080e7          	jalr	-748(ra) # 802056a6 <create_kernel_proc>
    8020799a:	87aa                	mv	a5,a0
    8020799c:	fef42423          	sw	a5,-24(s0)
	int count = 500;
    802079a0:	1f400793          	li	a5,500
    802079a4:	fef42623          	sw	a5,-20(s0)
	while(count){
    802079a8:	a811                	j	802079bc <test_kill+0x10c>
		count--; //等待500次调度
    802079aa:	fec42783          	lw	a5,-20(s0)
    802079ae:	37fd                	addiw	a5,a5,-1
    802079b0:	fef42623          	sw	a5,-20(s0)
		yield();
    802079b4:	ffffe097          	auipc	ra,0xffffe
    802079b8:	308080e7          	jalr	776(ra) # 80205cbc <yield>
	while(count){
    802079bc:	fec42783          	lw	a5,-20(s0)
    802079c0:	2781                	sext.w	a5,a5
    802079c2:	f7e5                	bnez	a5,802079aa <test_kill+0xfa>
	kill_proc(pid);
    802079c4:	fe842783          	lw	a5,-24(s0)
    802079c8:	853e                	mv	a0,a5
    802079ca:	ffffe097          	auipc	ra,0xffffe
    802079ce:	4ce080e7          	jalr	1230(ra) # 80205e98 <kill_proc>
	wait_proc(&ret);
    802079d2:	fd840793          	addi	a5,s0,-40
    802079d6:	853e                	mv	a0,a5
    802079d8:	ffffe097          	auipc	ra,0xffffe
    802079dc:	5ee080e7          	jalr	1518(ra) # 80205fc6 <wait_proc>
	if(SYS_kill == ret){
    802079e0:	fd842783          	lw	a5,-40(s0)
    802079e4:	873e                	mv	a4,a5
    802079e6:	08100793          	li	a5,129
    802079ea:	00f71b63          	bne	a4,a5,80207a00 <test_kill+0x150>
		printf("【测试】:尝试稍后杀死进程，测试成功\n");
    802079ee:	00022517          	auipc	a0,0x22
    802079f2:	23250513          	addi	a0,a0,562 # 80229c20 <user_test_table+0x11a0>
    802079f6:	ffff9097          	auipc	ra,0xffff9
    802079fa:	398080e7          	jalr	920(ra) # 80200d8e <printf>
    802079fe:	a831                	j	80207a1a <test_kill+0x16a>
		printf("【测试】:尝试稍后杀死进程失败，退出\n");
    80207a00:	00022517          	auipc	a0,0x22
    80207a04:	25850513          	addi	a0,a0,600 # 80229c58 <user_test_table+0x11d8>
    80207a08:	ffff9097          	auipc	ra,0xffff9
    80207a0c:	386080e7          	jalr	902(ra) # 80200d8e <printf>
		exit_proc(0);
    80207a10:	4501                	li	a0,0
    80207a12:	ffffe097          	auipc	ra,0xffffe
    80207a16:	4ea080e7          	jalr	1258(ra) # 80205efc <exit_proc>
	printf("\n----- 测试3: 创建killer 和 victim -----\n");
    80207a1a:	00022517          	auipc	a0,0x22
    80207a1e:	27650513          	addi	a0,a0,630 # 80229c90 <user_test_table+0x1210>
    80207a22:	ffff9097          	auipc	ra,0xffff9
    80207a26:	36c080e7          	jalr	876(ra) # 80200d8e <printf>
	int victim = create_kernel_proc(victim_task);
    80207a2a:	00000517          	auipc	a0,0x0
    80207a2e:	e1250513          	addi	a0,a0,-494 # 8020783c <victim_task>
    80207a32:	ffffe097          	auipc	ra,0xffffe
    80207a36:	c74080e7          	jalr	-908(ra) # 802056a6 <create_kernel_proc>
    80207a3a:	87aa                	mv	a5,a0
    80207a3c:	fef42223          	sw	a5,-28(s0)
	int killer = create_kernel_proc1(killer_task,victim);
    80207a40:	fe442783          	lw	a5,-28(s0)
    80207a44:	85be                	mv	a1,a5
    80207a46:	00000517          	auipc	a0,0x0
    80207a4a:	d6850513          	addi	a0,a0,-664 # 802077ae <killer_task>
    80207a4e:	ffffe097          	auipc	ra,0xffffe
    80207a52:	cf6080e7          	jalr	-778(ra) # 80205744 <create_kernel_proc1>
    80207a56:	87aa                	mv	a5,a0
    80207a58:	fef42023          	sw	a5,-32(s0)
	int first_exit = wait_proc(&ret);
    80207a5c:	fd840793          	addi	a5,s0,-40
    80207a60:	853e                	mv	a0,a5
    80207a62:	ffffe097          	auipc	ra,0xffffe
    80207a66:	564080e7          	jalr	1380(ra) # 80205fc6 <wait_proc>
    80207a6a:	87aa                	mv	a5,a0
    80207a6c:	fcf42e23          	sw	a5,-36(s0)
	if(first_exit == killer){
    80207a70:	fdc42783          	lw	a5,-36(s0)
    80207a74:	873e                	mv	a4,a5
    80207a76:	fe042783          	lw	a5,-32(s0)
    80207a7a:	2701                	sext.w	a4,a4
    80207a7c:	2781                	sext.w	a5,a5
    80207a7e:	04f71263          	bne	a4,a5,80207ac2 <test_kill+0x212>
		wait_proc(&ret);
    80207a82:	fd840793          	addi	a5,s0,-40
    80207a86:	853e                	mv	a0,a5
    80207a88:	ffffe097          	auipc	ra,0xffffe
    80207a8c:	53e080e7          	jalr	1342(ra) # 80205fc6 <wait_proc>
		if(SYS_kill == ret){
    80207a90:	fd842783          	lw	a5,-40(s0)
    80207a94:	873e                	mv	a4,a5
    80207a96:	08100793          	li	a5,129
    80207a9a:	00f71b63          	bne	a4,a5,80207ab0 <test_kill+0x200>
			printf("【测试】:killer win\n");
    80207a9e:	00022517          	auipc	a0,0x22
    80207aa2:	22250513          	addi	a0,a0,546 # 80229cc0 <user_test_table+0x1240>
    80207aa6:	ffff9097          	auipc	ra,0xffff9
    80207aaa:	2e8080e7          	jalr	744(ra) # 80200d8e <printf>
    80207aae:	a085                	j	80207b0e <test_kill+0x25e>
			printf("【测试】:出现问题，killer先结束但victim存活\n");
    80207ab0:	00022517          	auipc	a0,0x22
    80207ab4:	23050513          	addi	a0,a0,560 # 80229ce0 <user_test_table+0x1260>
    80207ab8:	ffff9097          	auipc	ra,0xffff9
    80207abc:	2d6080e7          	jalr	726(ra) # 80200d8e <printf>
    80207ac0:	a0b9                	j	80207b0e <test_kill+0x25e>
	}else if(first_exit == victim){
    80207ac2:	fdc42783          	lw	a5,-36(s0)
    80207ac6:	873e                	mv	a4,a5
    80207ac8:	fe442783          	lw	a5,-28(s0)
    80207acc:	2701                	sext.w	a4,a4
    80207ace:	2781                	sext.w	a5,a5
    80207ad0:	02f71f63          	bne	a4,a5,80207b0e <test_kill+0x25e>
		wait_proc(NULL);
    80207ad4:	4501                	li	a0,0
    80207ad6:	ffffe097          	auipc	ra,0xffffe
    80207ada:	4f0080e7          	jalr	1264(ra) # 80205fc6 <wait_proc>
		if(SYS_kill == ret){
    80207ade:	fd842783          	lw	a5,-40(s0)
    80207ae2:	873e                	mv	a4,a5
    80207ae4:	08100793          	li	a5,129
    80207ae8:	00f71b63          	bne	a4,a5,80207afe <test_kill+0x24e>
			printf("【测试】:killer win\n");
    80207aec:	00022517          	auipc	a0,0x22
    80207af0:	1d450513          	addi	a0,a0,468 # 80229cc0 <user_test_table+0x1240>
    80207af4:	ffff9097          	auipc	ra,0xffff9
    80207af8:	29a080e7          	jalr	666(ra) # 80200d8e <printf>
    80207afc:	a809                	j	80207b0e <test_kill+0x25e>
			printf("【测试】:出现问题，victim先结束且存活\n");
    80207afe:	00022517          	auipc	a0,0x22
    80207b02:	22250513          	addi	a0,a0,546 # 80229d20 <user_test_table+0x12a0>
    80207b06:	ffff9097          	auipc	ra,0xffff9
    80207b0a:	288080e7          	jalr	648(ra) # 80200d8e <printf>
	exit_proc(0);
    80207b0e:	4501                	li	a0,0
    80207b10:	ffffe097          	auipc	ra,0xffffe
    80207b14:	3ec080e7          	jalr	1004(ra) # 80205efc <exit_proc>
}
    80207b18:	0001                	nop
    80207b1a:	70a2                	ld	ra,40(sp)
    80207b1c:	7402                	ld	s0,32(sp)
    80207b1e:	6145                	addi	sp,sp,48
    80207b20:	8082                	ret

0000000080207b22 <test_filesystem_integrity>:
void test_filesystem_integrity(void) {
    80207b22:	7135                	addi	sp,sp,-160
    80207b24:	ed06                	sd	ra,152(sp)
    80207b26:	e922                	sd	s0,144(sp)
    80207b28:	e526                	sd	s1,136(sp)
    80207b2a:	1100                	addi	s0,sp,160
    printf("Testing filesystem integrity (kernel mode)...\n");
    80207b2c:	00022517          	auipc	a0,0x22
    80207b30:	22c50513          	addi	a0,a0,556 # 80229d58 <user_test_table+0x12d8>
    80207b34:	ffff9097          	auipc	ra,0xffff9
    80207b38:	25a080e7          	jalr	602(ra) # 80200d8e <printf>
    const char *filename = "testfile";
    80207b3c:	00022797          	auipc	a5,0x22
    80207b40:	24c78793          	addi	a5,a5,588 # 80229d88 <user_test_table+0x1308>
    80207b44:	fcf43c23          	sd	a5,-40(s0)
    printf("Creating/opening file: %s\n", filename);
    80207b48:	fd843583          	ld	a1,-40(s0)
    80207b4c:	00022517          	auipc	a0,0x22
    80207b50:	24c50513          	addi	a0,a0,588 # 80229d98 <user_test_table+0x1318>
    80207b54:	ffff9097          	auipc	ra,0xffff9
    80207b58:	23a080e7          	jalr	570(ra) # 80200d8e <printf>
    struct inode *ip = create((char *)filename, T_FILE, 0, 0);
    80207b5c:	4681                	li	a3,0
    80207b5e:	4601                	li	a2,0
    80207b60:	4589                	li	a1,2
    80207b62:	fd843503          	ld	a0,-40(s0)
    80207b66:	00004097          	auipc	ra,0x4
    80207b6a:	bfc080e7          	jalr	-1028(ra) # 8020b762 <create>
    80207b6e:	fca43823          	sd	a0,-48(s0)
    assert(ip != NULL);
    80207b72:	fd043783          	ld	a5,-48(s0)
    80207b76:	00f037b3          	snez	a5,a5
    80207b7a:	0ff7f793          	zext.b	a5,a5
    80207b7e:	2781                	sext.w	a5,a5
    80207b80:	853e                	mv	a0,a5
    80207b82:	fffff097          	auipc	ra,0xfffff
    80207b86:	ba4080e7          	jalr	-1116(ra) # 80206726 <assert>
    struct file *f = fileopen(ip, 1, 1); // 可读可写
    80207b8a:	4605                	li	a2,1
    80207b8c:	4585                	li	a1,1
    80207b8e:	fd043503          	ld	a0,-48(s0)
    80207b92:	00002097          	auipc	ra,0x2
    80207b96:	afe080e7          	jalr	-1282(ra) # 80209690 <fileopen>
    80207b9a:	fca43423          	sd	a0,-56(s0)
    assert(f != NULL);
    80207b9e:	fc843783          	ld	a5,-56(s0)
    80207ba2:	00f037b3          	snez	a5,a5
    80207ba6:	0ff7f793          	zext.b	a5,a5
    80207baa:	2781                	sext.w	a5,a5
    80207bac:	853e                	mv	a0,a5
    80207bae:	fffff097          	auipc	ra,0xfffff
    80207bb2:	b78080e7          	jalr	-1160(ra) # 80206726 <assert>
    printf("File opened for write: %s\n", filename);
    80207bb6:	fd843583          	ld	a1,-40(s0)
    80207bba:	00022517          	auipc	a0,0x22
    80207bbe:	1fe50513          	addi	a0,a0,510 # 80229db8 <user_test_table+0x1338>
    80207bc2:	ffff9097          	auipc	ra,0xffff9
    80207bc6:	1cc080e7          	jalr	460(ra) # 80200d8e <printf>
    char buffer[] = "Hello, filesystem!";
    80207bca:	00022797          	auipc	a5,0x22
    80207bce:	32e78793          	addi	a5,a5,814 # 80229ef8 <user_test_table+0x1478>
    80207bd2:	6394                	ld	a3,0(a5)
    80207bd4:	6798                	ld	a4,8(a5)
    80207bd6:	fad43423          	sd	a3,-88(s0)
    80207bda:	fae43823          	sd	a4,-80(s0)
    80207bde:	0107d703          	lhu	a4,16(a5)
    80207be2:	fae41c23          	sh	a4,-72(s0)
    80207be6:	0127c783          	lbu	a5,18(a5)
    80207bea:	faf40d23          	sb	a5,-70(s0)
    printf("Writing data: \"%s\" (len=%lu)\n", buffer, strlen(buffer));
    80207bee:	fa840793          	addi	a5,s0,-88
    80207bf2:	853e                	mv	a0,a5
    80207bf4:	ffffe097          	auipc	ra,0xffffe
    80207bf8:	798080e7          	jalr	1944(ra) # 8020638c <strlen>
    80207bfc:	87aa                	mv	a5,a0
    80207bfe:	873e                	mv	a4,a5
    80207c00:	fa840793          	addi	a5,s0,-88
    80207c04:	863a                	mv	a2,a4
    80207c06:	85be                	mv	a1,a5
    80207c08:	00022517          	auipc	a0,0x22
    80207c0c:	1d050513          	addi	a0,a0,464 # 80229dd8 <user_test_table+0x1358>
    80207c10:	ffff9097          	auipc	ra,0xffff9
    80207c14:	17e080e7          	jalr	382(ra) # 80200d8e <printf>
    int bytes = filewrite(f, (uint64)buffer, strlen(buffer));
    80207c18:	fa840493          	addi	s1,s0,-88
    80207c1c:	fa840793          	addi	a5,s0,-88
    80207c20:	853e                	mv	a0,a5
    80207c22:	ffffe097          	auipc	ra,0xffffe
    80207c26:	76a080e7          	jalr	1898(ra) # 8020638c <strlen>
    80207c2a:	87aa                	mv	a5,a0
    80207c2c:	863e                	mv	a2,a5
    80207c2e:	85a6                	mv	a1,s1
    80207c30:	fc843503          	ld	a0,-56(s0)
    80207c34:	00002097          	auipc	ra,0x2
    80207c38:	dde080e7          	jalr	-546(ra) # 80209a12 <filewrite>
    80207c3c:	87aa                	mv	a5,a0
    80207c3e:	fcf42223          	sw	a5,-60(s0)
    printf("Wrote %d bytes to file\n", bytes);
    80207c42:	fc442783          	lw	a5,-60(s0)
    80207c46:	85be                	mv	a1,a5
    80207c48:	00022517          	auipc	a0,0x22
    80207c4c:	1b050513          	addi	a0,a0,432 # 80229df8 <user_test_table+0x1378>
    80207c50:	ffff9097          	auipc	ra,0xffff9
    80207c54:	13e080e7          	jalr	318(ra) # 80200d8e <printf>
    assert(bytes == strlen(buffer));
    80207c58:	fa840793          	addi	a5,s0,-88
    80207c5c:	853e                	mv	a0,a5
    80207c5e:	ffffe097          	auipc	ra,0xffffe
    80207c62:	72e080e7          	jalr	1838(ra) # 8020638c <strlen>
    80207c66:	87aa                	mv	a5,a0
    80207c68:	873e                	mv	a4,a5
    80207c6a:	fc442783          	lw	a5,-60(s0)
    80207c6e:	2781                	sext.w	a5,a5
    80207c70:	8f99                	sub	a5,a5,a4
    80207c72:	0017b793          	seqz	a5,a5
    80207c76:	0ff7f793          	zext.b	a5,a5
    80207c7a:	2781                	sext.w	a5,a5
    80207c7c:	853e                	mv	a0,a5
    80207c7e:	fffff097          	auipc	ra,0xfffff
    80207c82:	aa8080e7          	jalr	-1368(ra) # 80206726 <assert>
    fileclose(f);
    80207c86:	fc843503          	ld	a0,-56(s0)
    80207c8a:	00002097          	auipc	ra,0x2
    80207c8e:	a7e080e7          	jalr	-1410(ra) # 80209708 <fileclose>
    printf("File closed after write: %s\n", filename);
    80207c92:	fd843583          	ld	a1,-40(s0)
    80207c96:	00022517          	auipc	a0,0x22
    80207c9a:	17a50513          	addi	a0,a0,378 # 80229e10 <user_test_table+0x1390>
    80207c9e:	ffff9097          	auipc	ra,0xffff9
    80207ca2:	0f0080e7          	jalr	240(ra) # 80200d8e <printf>
    ip = namei((char *)filename);
    80207ca6:	fd843503          	ld	a0,-40(s0)
    80207caa:	00004097          	auipc	ra,0x4
    80207cae:	a5e080e7          	jalr	-1442(ra) # 8020b708 <namei>
    80207cb2:	fca43823          	sd	a0,-48(s0)
    assert(ip != NULL);
    80207cb6:	fd043783          	ld	a5,-48(s0)
    80207cba:	00f037b3          	snez	a5,a5
    80207cbe:	0ff7f793          	zext.b	a5,a5
    80207cc2:	2781                	sext.w	a5,a5
    80207cc4:	853e                	mv	a0,a5
    80207cc6:	fffff097          	auipc	ra,0xfffff
    80207cca:	a60080e7          	jalr	-1440(ra) # 80206726 <assert>
    f = fileopen(ip, 1, 0); // 只读
    80207cce:	4601                	li	a2,0
    80207cd0:	4585                	li	a1,1
    80207cd2:	fd043503          	ld	a0,-48(s0)
    80207cd6:	00002097          	auipc	ra,0x2
    80207cda:	9ba080e7          	jalr	-1606(ra) # 80209690 <fileopen>
    80207cde:	fca43423          	sd	a0,-56(s0)
    assert(f != NULL);
    80207ce2:	fc843783          	ld	a5,-56(s0)
    80207ce6:	00f037b3          	snez	a5,a5
    80207cea:	0ff7f793          	zext.b	a5,a5
    80207cee:	2781                	sext.w	a5,a5
    80207cf0:	853e                	mv	a0,a5
    80207cf2:	fffff097          	auipc	ra,0xfffff
    80207cf6:	a34080e7          	jalr	-1484(ra) # 80206726 <assert>
    printf("File opened for read: %s\n", filename);
    80207cfa:	fd843583          	ld	a1,-40(s0)
    80207cfe:	00022517          	auipc	a0,0x22
    80207d02:	13250513          	addi	a0,a0,306 # 80229e30 <user_test_table+0x13b0>
    80207d06:	ffff9097          	auipc	ra,0xffff9
    80207d0a:	088080e7          	jalr	136(ra) # 80200d8e <printf>
    bytes = fileread(f, (uint64)read_buffer, sizeof(read_buffer) - 1);
    80207d0e:	f6840793          	addi	a5,s0,-152
    80207d12:	03f00613          	li	a2,63
    80207d16:	85be                	mv	a1,a5
    80207d18:	fc843503          	ld	a0,-56(s0)
    80207d1c:	00002097          	auipc	ra,0x2
    80207d20:	b98080e7          	jalr	-1128(ra) # 802098b4 <fileread>
    80207d24:	87aa                	mv	a5,a0
    80207d26:	fcf42223          	sw	a5,-60(s0)
    read_buffer[bytes] = '\0';
    80207d2a:	fc442783          	lw	a5,-60(s0)
    80207d2e:	1781                	addi	a5,a5,-32
    80207d30:	97a2                	add	a5,a5,s0
    80207d32:	f8078423          	sb	zero,-120(a5)
    printf("Read %d bytes from file\n", bytes);
    80207d36:	fc442783          	lw	a5,-60(s0)
    80207d3a:	85be                	mv	a1,a5
    80207d3c:	00022517          	auipc	a0,0x22
    80207d40:	11450513          	addi	a0,a0,276 # 80229e50 <user_test_table+0x13d0>
    80207d44:	ffff9097          	auipc	ra,0xffff9
    80207d48:	04a080e7          	jalr	74(ra) # 80200d8e <printf>
    printf("Read data: \"%s\"\n", read_buffer);
    80207d4c:	f6840793          	addi	a5,s0,-152
    80207d50:	85be                	mv	a1,a5
    80207d52:	00022517          	auipc	a0,0x22
    80207d56:	11e50513          	addi	a0,a0,286 # 80229e70 <user_test_table+0x13f0>
    80207d5a:	ffff9097          	auipc	ra,0xffff9
    80207d5e:	034080e7          	jalr	52(ra) # 80200d8e <printf>
    assert(strcmp(buffer, read_buffer) == 0);
    80207d62:	f6840713          	addi	a4,s0,-152
    80207d66:	fa840793          	addi	a5,s0,-88
    80207d6a:	85ba                	mv	a1,a4
    80207d6c:	853e                	mv	a0,a5
    80207d6e:	ffffe097          	auipc	ra,0xffffe
    80207d72:	654080e7          	jalr	1620(ra) # 802063c2 <strcmp>
    80207d76:	87aa                	mv	a5,a0
    80207d78:	0017b793          	seqz	a5,a5
    80207d7c:	0ff7f793          	zext.b	a5,a5
    80207d80:	2781                	sext.w	a5,a5
    80207d82:	853e                	mv	a0,a5
    80207d84:	fffff097          	auipc	ra,0xfffff
    80207d88:	9a2080e7          	jalr	-1630(ra) # 80206726 <assert>
    fileclose(f);
    80207d8c:	fc843503          	ld	a0,-56(s0)
    80207d90:	00002097          	auipc	ra,0x2
    80207d94:	978080e7          	jalr	-1672(ra) # 80209708 <fileclose>
    printf("File closed after read: %s\n", filename);
    80207d98:	fd843583          	ld	a1,-40(s0)
    80207d9c:	00022517          	auipc	a0,0x22
    80207da0:	0ec50513          	addi	a0,a0,236 # 80229e88 <user_test_table+0x1408>
    80207da4:	ffff9097          	auipc	ra,0xffff9
    80207da8:	fea080e7          	jalr	-22(ra) # 80200d8e <printf>
    int unlink_ret = unlink((char *)filename);
    80207dac:	fd843503          	ld	a0,-40(s0)
    80207db0:	00004097          	auipc	ra,0x4
    80207db4:	b90080e7          	jalr	-1136(ra) # 8020b940 <unlink>
    80207db8:	87aa                	mv	a5,a0
    80207dba:	fcf42023          	sw	a5,-64(s0)
    printf("Unlink file: %s, result=%d\n", filename, unlink_ret);
    80207dbe:	fc042783          	lw	a5,-64(s0)
    80207dc2:	863e                	mv	a2,a5
    80207dc4:	fd843583          	ld	a1,-40(s0)
    80207dc8:	00022517          	auipc	a0,0x22
    80207dcc:	0e050513          	addi	a0,a0,224 # 80229ea8 <user_test_table+0x1428>
    80207dd0:	ffff9097          	auipc	ra,0xffff9
    80207dd4:	fbe080e7          	jalr	-66(ra) # 80200d8e <printf>
    assert(unlink_ret == 0);
    80207dd8:	fc042783          	lw	a5,-64(s0)
    80207ddc:	2781                	sext.w	a5,a5
    80207dde:	0017b793          	seqz	a5,a5
    80207de2:	0ff7f793          	zext.b	a5,a5
    80207de6:	2781                	sext.w	a5,a5
    80207de8:	853e                	mv	a0,a5
    80207dea:	fffff097          	auipc	ra,0xfffff
    80207dee:	93c080e7          	jalr	-1732(ra) # 80206726 <assert>
    printf("Filesystem integrity test passed (kernel mode)\n");
    80207df2:	00022517          	auipc	a0,0x22
    80207df6:	0d650513          	addi	a0,a0,214 # 80229ec8 <user_test_table+0x1448>
    80207dfa:	ffff9097          	auipc	ra,0xffff9
    80207dfe:	f94080e7          	jalr	-108(ra) # 80200d8e <printf>
    80207e02:	0001                	nop
    80207e04:	60ea                	ld	ra,152(sp)
    80207e06:	644a                	ld	s0,144(sp)
    80207e08:	64aa                	ld	s1,136(sp)
    80207e0a:	610d                	addi	sp,sp,160
    80207e0c:	8082                	ret

0000000080207e0e <virtio_disk_init>:
#define R(r) ((volatile uint32 *)(VIRTIO0 + (r)))
static struct disk disk;

void
virtio_disk_init(void)
{
    80207e0e:	7179                	addi	sp,sp,-48
    80207e10:	f406                	sd	ra,40(sp)
    80207e12:	f022                	sd	s0,32(sp)
    80207e14:	1800                	addi	s0,sp,48
  uint32 status = 0;
    80207e16:	fe042423          	sw	zero,-24(s0)

  initlock(&disk.vdisk_lock, "virtio_disk");
    80207e1a:	00024597          	auipc	a1,0x24
    80207e1e:	1a658593          	addi	a1,a1,422 # 8022bfc0 <user_test_table+0x78>
    80207e22:	00035517          	auipc	a0,0x35
    80207e26:	b0e50513          	addi	a0,a0,-1266 # 8023c930 <disk+0x230>
    80207e2a:	00004097          	auipc	ra,0x4
    80207e2e:	cd6080e7          	jalr	-810(ra) # 8020bb00 <initlock>

  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80207e32:	100017b7          	lui	a5,0x10001
    80207e36:	439c                	lw	a5,0(a5)
    80207e38:	2781                	sext.w	a5,a5
    80207e3a:	873e                	mv	a4,a5
    80207e3c:	747277b7          	lui	a5,0x74727
    80207e40:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xbad968a>
    80207e44:	04f71063          	bne	a4,a5,80207e84 <virtio_disk_init+0x76>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80207e48:	100017b7          	lui	a5,0x10001
    80207e4c:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x701feffc>
    80207e4e:	439c                	lw	a5,0(a5)
    80207e50:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80207e52:	873e                	mv	a4,a5
    80207e54:	4789                	li	a5,2
    80207e56:	02f71763          	bne	a4,a5,80207e84 <virtio_disk_init+0x76>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80207e5a:	100017b7          	lui	a5,0x10001
    80207e5e:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x701feff8>
    80207e60:	439c                	lw	a5,0(a5)
    80207e62:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80207e64:	873e                	mv	a4,a5
    80207e66:	4789                	li	a5,2
    80207e68:	00f71e63          	bne	a4,a5,80207e84 <virtio_disk_init+0x76>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80207e6c:	100017b7          	lui	a5,0x10001
    80207e70:	07b1                	addi	a5,a5,12 # 1000100c <_entry-0x701feff4>
    80207e72:	439c                	lw	a5,0(a5)
    80207e74:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80207e76:	873e                	mv	a4,a5
    80207e78:	554d47b7          	lui	a5,0x554d4
    80207e7c:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ad2baaf>
    80207e80:	00f70a63          	beq	a4,a5,80207e94 <virtio_disk_init+0x86>
    panic("could not find virtio disk");
    80207e84:	00024517          	auipc	a0,0x24
    80207e88:	14c50513          	addi	a0,a0,332 # 8022bfd0 <user_test_table+0x88>
    80207e8c:	ffffa097          	auipc	ra,0xffffa
    80207e90:	94e080e7          	jalr	-1714(ra) # 802017da <panic>
  }
  
  // reset device
  *R(VIRTIO_MMIO_STATUS) = status;
    80207e94:	100017b7          	lui	a5,0x10001
    80207e98:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x701fef90>
    80207e9c:	fe842703          	lw	a4,-24(s0)
    80207ea0:	c398                	sw	a4,0(a5)

  // set ACKNOWLEDGE status bit
  status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
    80207ea2:	fe842783          	lw	a5,-24(s0)
    80207ea6:	0017e793          	ori	a5,a5,1
    80207eaa:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    80207eae:	100017b7          	lui	a5,0x10001
    80207eb2:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x701fef90>
    80207eb6:	fe842703          	lw	a4,-24(s0)
    80207eba:	c398                	sw	a4,0(a5)

  // set DRIVER status bit
  status |= VIRTIO_CONFIG_S_DRIVER;
    80207ebc:	fe842783          	lw	a5,-24(s0)
    80207ec0:	0027e793          	ori	a5,a5,2
    80207ec4:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    80207ec8:	100017b7          	lui	a5,0x10001
    80207ecc:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x701fef90>
    80207ed0:	fe842703          	lw	a4,-24(s0)
    80207ed4:	c398                	sw	a4,0(a5)

  // negotiate features
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80207ed6:	100017b7          	lui	a5,0x10001
    80207eda:	07c1                	addi	a5,a5,16 # 10001010 <_entry-0x701feff0>
    80207edc:	439c                	lw	a5,0(a5)
    80207ede:	2781                	sext.w	a5,a5
    80207ee0:	1782                	slli	a5,a5,0x20
    80207ee2:	9381                	srli	a5,a5,0x20
    80207ee4:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_RO);
    80207ee8:	fe043783          	ld	a5,-32(s0)
    80207eec:	fdf7f793          	andi	a5,a5,-33
    80207ef0:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_SCSI);
    80207ef4:	fe043783          	ld	a5,-32(s0)
    80207ef8:	f7f7f793          	andi	a5,a5,-129
    80207efc:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_CONFIG_WCE);
    80207f00:	fe043703          	ld	a4,-32(s0)
    80207f04:	77fd                	lui	a5,0xfffff
    80207f06:	7ff78793          	addi	a5,a5,2047 # fffffffffffff7ff <_bss_end+0xffffffff7fdb7edf>
    80207f0a:	8ff9                	and	a5,a5,a4
    80207f0c:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_MQ);
    80207f10:	fe043703          	ld	a4,-32(s0)
    80207f14:	77fd                	lui	a5,0xfffff
    80207f16:	17fd                	addi	a5,a5,-1 # ffffffffffffefff <_bss_end+0xffffffff7fdb76df>
    80207f18:	8ff9                	and	a5,a5,a4
    80207f1a:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_F_ANY_LAYOUT);
    80207f1e:	fe043703          	ld	a4,-32(s0)
    80207f22:	f80007b7          	lui	a5,0xf8000
    80207f26:	17fd                	addi	a5,a5,-1 # fffffffff7ffffff <_bss_end+0xffffffff77db86df>
    80207f28:	8ff9                	and	a5,a5,a4
    80207f2a:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_RING_F_EVENT_IDX);
    80207f2e:	fe043703          	ld	a4,-32(s0)
    80207f32:	e00007b7          	lui	a5,0xe0000
    80207f36:	17fd                	addi	a5,a5,-1 # ffffffffdfffffff <_bss_end+0xffffffff5fdb86df>
    80207f38:	8ff9                	and	a5,a5,a4
    80207f3a:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80207f3e:	fe043703          	ld	a4,-32(s0)
    80207f42:	f00007b7          	lui	a5,0xf0000
    80207f46:	17fd                	addi	a5,a5,-1 # ffffffffefffffff <_bss_end+0xffffffff6fdb86df>
    80207f48:	8ff9                	and	a5,a5,a4
    80207f4a:	fef43023          	sd	a5,-32(s0)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80207f4e:	100017b7          	lui	a5,0x10001
    80207f52:	02078793          	addi	a5,a5,32 # 10001020 <_entry-0x701fefe0>
    80207f56:	fe043703          	ld	a4,-32(s0)
    80207f5a:	2701                	sext.w	a4,a4
    80207f5c:	c398                	sw	a4,0(a5)

  // tell device that feature negotiation is complete.
  status |= VIRTIO_CONFIG_S_FEATURES_OK;
    80207f5e:	fe842783          	lw	a5,-24(s0)
    80207f62:	0087e793          	ori	a5,a5,8
    80207f66:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    80207f6a:	100017b7          	lui	a5,0x10001
    80207f6e:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x701fef90>
    80207f72:	fe842703          	lw	a4,-24(s0)
    80207f76:	c398                	sw	a4,0(a5)
  // re-read status to ensure FEATURES_OK is set.
  status = *R(VIRTIO_MMIO_STATUS);
    80207f78:	100017b7          	lui	a5,0x10001
    80207f7c:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x701fef90>
    80207f80:	439c                	lw	a5,0(a5)
    80207f82:	fef42423          	sw	a5,-24(s0)
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80207f86:	fe842783          	lw	a5,-24(s0)
    80207f8a:	8ba1                	andi	a5,a5,8
    80207f8c:	2781                	sext.w	a5,a5
    80207f8e:	eb89                	bnez	a5,80207fa0 <virtio_disk_init+0x192>
    panic("virtio disk FEATURES_OK unset");
    80207f90:	00024517          	auipc	a0,0x24
    80207f94:	06050513          	addi	a0,a0,96 # 8022bff0 <user_test_table+0xa8>
    80207f98:	ffffa097          	auipc	ra,0xffffa
    80207f9c:	842080e7          	jalr	-1982(ra) # 802017da <panic>
  // initialize queue 0.
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80207fa0:	100017b7          	lui	a5,0x10001
    80207fa4:	03078793          	addi	a5,a5,48 # 10001030 <_entry-0x701fefd0>
    80207fa8:	0007a023          	sw	zero,0(a5)

  // ensure queue 0 is not in use.
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80207fac:	100017b7          	lui	a5,0x10001
    80207fb0:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x701fefbc>
    80207fb4:	439c                	lw	a5,0(a5)
    80207fb6:	2781                	sext.w	a5,a5
    80207fb8:	cb89                	beqz	a5,80207fca <virtio_disk_init+0x1bc>
    panic("virtio disk should not be ready");
    80207fba:	00024517          	auipc	a0,0x24
    80207fbe:	05650513          	addi	a0,a0,86 # 8022c010 <user_test_table+0xc8>
    80207fc2:	ffffa097          	auipc	ra,0xffffa
    80207fc6:	818080e7          	jalr	-2024(ra) # 802017da <panic>

  // check maximum queue size.
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80207fca:	100017b7          	lui	a5,0x10001
    80207fce:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x701fefcc>
    80207fd2:	439c                	lw	a5,0(a5)
    80207fd4:	fcf42e23          	sw	a5,-36(s0)
  if(max == 0)
    80207fd8:	fdc42783          	lw	a5,-36(s0)
    80207fdc:	2781                	sext.w	a5,a5
    80207fde:	eb89                	bnez	a5,80207ff0 <virtio_disk_init+0x1e2>
    panic("virtio disk has no queue 0");
    80207fe0:	00024517          	auipc	a0,0x24
    80207fe4:	05050513          	addi	a0,a0,80 # 8022c030 <user_test_table+0xe8>
    80207fe8:	ffff9097          	auipc	ra,0xffff9
    80207fec:	7f2080e7          	jalr	2034(ra) # 802017da <panic>
  if(max < NUM)
    80207ff0:	fdc42783          	lw	a5,-36(s0)
    80207ff4:	0007871b          	sext.w	a4,a5
    80207ff8:	47bd                	li	a5,15
    80207ffa:	00e7ea63          	bltu	a5,a4,8020800e <virtio_disk_init+0x200>
    panic("virtio disk max queue too short");
    80207ffe:	00024517          	auipc	a0,0x24
    80208002:	05250513          	addi	a0,a0,82 # 8022c050 <user_test_table+0x108>
    80208006:	ffff9097          	auipc	ra,0xffff9
    8020800a:	7d4080e7          	jalr	2004(ra) # 802017da <panic>

  // allocate and zero queue memory.
  disk.desc = alloc_page();
    8020800e:	ffffb097          	auipc	ra,0xffffb
    80208012:	322080e7          	jalr	802(ra) # 80203330 <alloc_page>
    80208016:	872a                	mv	a4,a0
    80208018:	00034797          	auipc	a5,0x34
    8020801c:	6e878793          	addi	a5,a5,1768 # 8023c700 <disk>
    80208020:	e398                	sd	a4,0(a5)
  disk.avail = alloc_page();
    80208022:	ffffb097          	auipc	ra,0xffffb
    80208026:	30e080e7          	jalr	782(ra) # 80203330 <alloc_page>
    8020802a:	872a                	mv	a4,a0
    8020802c:	00034797          	auipc	a5,0x34
    80208030:	6d478793          	addi	a5,a5,1748 # 8023c700 <disk>
    80208034:	e798                	sd	a4,8(a5)
  disk.used = alloc_page();
    80208036:	ffffb097          	auipc	ra,0xffffb
    8020803a:	2fa080e7          	jalr	762(ra) # 80203330 <alloc_page>
    8020803e:	872a                	mv	a4,a0
    80208040:	00034797          	auipc	a5,0x34
    80208044:	6c078793          	addi	a5,a5,1728 # 8023c700 <disk>
    80208048:	eb98                	sd	a4,16(a5)
  if(!disk.desc || !disk.avail || !disk.used)
    8020804a:	00034797          	auipc	a5,0x34
    8020804e:	6b678793          	addi	a5,a5,1718 # 8023c700 <disk>
    80208052:	639c                	ld	a5,0(a5)
    80208054:	cf89                	beqz	a5,8020806e <virtio_disk_init+0x260>
    80208056:	00034797          	auipc	a5,0x34
    8020805a:	6aa78793          	addi	a5,a5,1706 # 8023c700 <disk>
    8020805e:	679c                	ld	a5,8(a5)
    80208060:	c799                	beqz	a5,8020806e <virtio_disk_init+0x260>
    80208062:	00034797          	auipc	a5,0x34
    80208066:	69e78793          	addi	a5,a5,1694 # 8023c700 <disk>
    8020806a:	6b9c                	ld	a5,16(a5)
    8020806c:	eb89                	bnez	a5,8020807e <virtio_disk_init+0x270>
    panic("virtio disk kalloc");
    8020806e:	00024517          	auipc	a0,0x24
    80208072:	00250513          	addi	a0,a0,2 # 8022c070 <user_test_table+0x128>
    80208076:	ffff9097          	auipc	ra,0xffff9
    8020807a:	764080e7          	jalr	1892(ra) # 802017da <panic>
  memset(disk.desc, 0, PGSIZE);
    8020807e:	00034797          	auipc	a5,0x34
    80208082:	68278793          	addi	a5,a5,1666 # 8023c700 <disk>
    80208086:	639c                	ld	a5,0(a5)
    80208088:	6605                	lui	a2,0x1
    8020808a:	4581                	li	a1,0
    8020808c:	853e                	mv	a0,a5
    8020808e:	ffffa097          	auipc	ra,0xffffa
    80208092:	e8a080e7          	jalr	-374(ra) # 80201f18 <memset>
  memset(disk.avail, 0, PGSIZE);
    80208096:	00034797          	auipc	a5,0x34
    8020809a:	66a78793          	addi	a5,a5,1642 # 8023c700 <disk>
    8020809e:	679c                	ld	a5,8(a5)
    802080a0:	6605                	lui	a2,0x1
    802080a2:	4581                	li	a1,0
    802080a4:	853e                	mv	a0,a5
    802080a6:	ffffa097          	auipc	ra,0xffffa
    802080aa:	e72080e7          	jalr	-398(ra) # 80201f18 <memset>
  memset(disk.used, 0, PGSIZE);
    802080ae:	00034797          	auipc	a5,0x34
    802080b2:	65278793          	addi	a5,a5,1618 # 8023c700 <disk>
    802080b6:	6b9c                	ld	a5,16(a5)
    802080b8:	6605                	lui	a2,0x1
    802080ba:	4581                	li	a1,0
    802080bc:	853e                	mv	a0,a5
    802080be:	ffffa097          	auipc	ra,0xffffa
    802080c2:	e5a080e7          	jalr	-422(ra) # 80201f18 <memset>

  // set queue size.
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    802080c6:	100017b7          	lui	a5,0x10001
    802080ca:	03878793          	addi	a5,a5,56 # 10001038 <_entry-0x701fefc8>
    802080ce:	4741                	li	a4,16
    802080d0:	c398                	sw	a4,0(a5)

  // write physical addresses.
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    802080d2:	00034797          	auipc	a5,0x34
    802080d6:	62e78793          	addi	a5,a5,1582 # 8023c700 <disk>
    802080da:	639c                	ld	a5,0(a5)
    802080dc:	873e                	mv	a4,a5
    802080de:	100017b7          	lui	a5,0x10001
    802080e2:	08078793          	addi	a5,a5,128 # 10001080 <_entry-0x701fef80>
    802080e6:	2701                	sext.w	a4,a4
    802080e8:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    802080ea:	00034797          	auipc	a5,0x34
    802080ee:	61678793          	addi	a5,a5,1558 # 8023c700 <disk>
    802080f2:	639c                	ld	a5,0(a5)
    802080f4:	0207d713          	srli	a4,a5,0x20
    802080f8:	100017b7          	lui	a5,0x10001
    802080fc:	08478793          	addi	a5,a5,132 # 10001084 <_entry-0x701fef7c>
    80208100:	2701                	sext.w	a4,a4
    80208102:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80208104:	00034797          	auipc	a5,0x34
    80208108:	5fc78793          	addi	a5,a5,1532 # 8023c700 <disk>
    8020810c:	679c                	ld	a5,8(a5)
    8020810e:	873e                	mv	a4,a5
    80208110:	100017b7          	lui	a5,0x10001
    80208114:	09078793          	addi	a5,a5,144 # 10001090 <_entry-0x701fef70>
    80208118:	2701                	sext.w	a4,a4
    8020811a:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    8020811c:	00034797          	auipc	a5,0x34
    80208120:	5e478793          	addi	a5,a5,1508 # 8023c700 <disk>
    80208124:	679c                	ld	a5,8(a5)
    80208126:	0207d713          	srli	a4,a5,0x20
    8020812a:	100017b7          	lui	a5,0x10001
    8020812e:	09478793          	addi	a5,a5,148 # 10001094 <_entry-0x701fef6c>
    80208132:	2701                	sext.w	a4,a4
    80208134:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80208136:	00034797          	auipc	a5,0x34
    8020813a:	5ca78793          	addi	a5,a5,1482 # 8023c700 <disk>
    8020813e:	6b9c                	ld	a5,16(a5)
    80208140:	873e                	mv	a4,a5
    80208142:	100017b7          	lui	a5,0x10001
    80208146:	0a078793          	addi	a5,a5,160 # 100010a0 <_entry-0x701fef60>
    8020814a:	2701                	sext.w	a4,a4
    8020814c:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8020814e:	00034797          	auipc	a5,0x34
    80208152:	5b278793          	addi	a5,a5,1458 # 8023c700 <disk>
    80208156:	6b9c                	ld	a5,16(a5)
    80208158:	0207d713          	srli	a4,a5,0x20
    8020815c:	100017b7          	lui	a5,0x10001
    80208160:	0a478793          	addi	a5,a5,164 # 100010a4 <_entry-0x701fef5c>
    80208164:	2701                	sext.w	a4,a4
    80208166:	c398                	sw	a4,0(a5)

  // queue is ready.
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80208168:	100017b7          	lui	a5,0x10001
    8020816c:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x701fefbc>
    80208170:	4705                	li	a4,1
    80208172:	c398                	sw	a4,0(a5)

  // all NUM descriptors start out unused.
  for(int i = 0; i < NUM; i++)
    80208174:	fe042623          	sw	zero,-20(s0)
    80208178:	a005                	j	80208198 <virtio_disk_init+0x38a>
    disk.free[i] = 1;
    8020817a:	00034717          	auipc	a4,0x34
    8020817e:	58670713          	addi	a4,a4,1414 # 8023c700 <disk>
    80208182:	fec42783          	lw	a5,-20(s0)
    80208186:	97ba                	add	a5,a5,a4
    80208188:	4705                	li	a4,1
    8020818a:	00e78c23          	sb	a4,24(a5)
  for(int i = 0; i < NUM; i++)
    8020818e:	fec42783          	lw	a5,-20(s0)
    80208192:	2785                	addiw	a5,a5,1
    80208194:	fef42623          	sw	a5,-20(s0)
    80208198:	fec42783          	lw	a5,-20(s0)
    8020819c:	0007871b          	sext.w	a4,a5
    802081a0:	47bd                	li	a5,15
    802081a2:	fce7dce3          	bge	a5,a4,8020817a <virtio_disk_init+0x36c>

  // tell device we're completely ready.
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    802081a6:	fe842783          	lw	a5,-24(s0)
    802081aa:	0047e793          	ori	a5,a5,4
    802081ae:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    802081b2:	100017b7          	lui	a5,0x10001
    802081b6:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x701fef90>
    802081ba:	fe842703          	lw	a4,-24(s0)
    802081be:	c398                	sw	a4,0(a5)

  // plic.c and trap.c arrange for interrupts from VIRTIO0_IRQ.
}
    802081c0:	0001                	nop
    802081c2:	70a2                	ld	ra,40(sp)
    802081c4:	7402                	ld	s0,32(sp)
    802081c6:	6145                	addi	sp,sp,48
    802081c8:	8082                	ret

00000000802081ca <alloc_desc>:

// find a free descriptor, mark it non-free, return its index.
int
alloc_desc()
{
    802081ca:	1101                	addi	sp,sp,-32
    802081cc:	ec22                	sd	s0,24(sp)
    802081ce:	1000                	addi	s0,sp,32
  for(int i = 0; i < NUM; i++){
    802081d0:	fe042623          	sw	zero,-20(s0)
    802081d4:	a825                	j	8020820c <alloc_desc+0x42>
    if(disk.free[i]){
    802081d6:	00034717          	auipc	a4,0x34
    802081da:	52a70713          	addi	a4,a4,1322 # 8023c700 <disk>
    802081de:	fec42783          	lw	a5,-20(s0)
    802081e2:	97ba                	add	a5,a5,a4
    802081e4:	0187c783          	lbu	a5,24(a5)
    802081e8:	cf89                	beqz	a5,80208202 <alloc_desc+0x38>
      disk.free[i] = 0;
    802081ea:	00034717          	auipc	a4,0x34
    802081ee:	51670713          	addi	a4,a4,1302 # 8023c700 <disk>
    802081f2:	fec42783          	lw	a5,-20(s0)
    802081f6:	97ba                	add	a5,a5,a4
    802081f8:	00078c23          	sb	zero,24(a5)
      return i;
    802081fc:	fec42783          	lw	a5,-20(s0)
    80208200:	a831                	j	8020821c <alloc_desc+0x52>
  for(int i = 0; i < NUM; i++){
    80208202:	fec42783          	lw	a5,-20(s0)
    80208206:	2785                	addiw	a5,a5,1
    80208208:	fef42623          	sw	a5,-20(s0)
    8020820c:	fec42783          	lw	a5,-20(s0)
    80208210:	0007871b          	sext.w	a4,a5
    80208214:	47bd                	li	a5,15
    80208216:	fce7d0e3          	bge	a5,a4,802081d6 <alloc_desc+0xc>
    }
  }
  return -1;
    8020821a:	57fd                	li	a5,-1
}
    8020821c:	853e                	mv	a0,a5
    8020821e:	6462                	ld	s0,24(sp)
    80208220:	6105                	addi	sp,sp,32
    80208222:	8082                	ret

0000000080208224 <free_desc>:

// mark a descriptor as free.
void
free_desc(int i)
{
    80208224:	1101                	addi	sp,sp,-32
    80208226:	ec06                	sd	ra,24(sp)
    80208228:	e822                	sd	s0,16(sp)
    8020822a:	1000                	addi	s0,sp,32
    8020822c:	87aa                	mv	a5,a0
    8020822e:	fef42623          	sw	a5,-20(s0)
  if(i >= NUM)
    80208232:	fec42783          	lw	a5,-20(s0)
    80208236:	0007871b          	sext.w	a4,a5
    8020823a:	47bd                	li	a5,15
    8020823c:	00e7da63          	bge	a5,a4,80208250 <free_desc+0x2c>
    panic("free_desc i >= NUM");
    80208240:	00024517          	auipc	a0,0x24
    80208244:	e4850513          	addi	a0,a0,-440 # 8022c088 <user_test_table+0x140>
    80208248:	ffff9097          	auipc	ra,0xffff9
    8020824c:	592080e7          	jalr	1426(ra) # 802017da <panic>
  if(disk.free[i])
    80208250:	00034717          	auipc	a4,0x34
    80208254:	4b070713          	addi	a4,a4,1200 # 8023c700 <disk>
    80208258:	fec42783          	lw	a5,-20(s0)
    8020825c:	97ba                	add	a5,a5,a4
    8020825e:	0187c783          	lbu	a5,24(a5)
    80208262:	cb89                	beqz	a5,80208274 <free_desc+0x50>
    panic("free_desc i has already been free");
    80208264:	00024517          	auipc	a0,0x24
    80208268:	e3c50513          	addi	a0,a0,-452 # 8022c0a0 <user_test_table+0x158>
    8020826c:	ffff9097          	auipc	ra,0xffff9
    80208270:	56e080e7          	jalr	1390(ra) # 802017da <panic>
  disk.desc[i].addr = 0;
    80208274:	00034797          	auipc	a5,0x34
    80208278:	48c78793          	addi	a5,a5,1164 # 8023c700 <disk>
    8020827c:	6398                	ld	a4,0(a5)
    8020827e:	fec42783          	lw	a5,-20(s0)
    80208282:	0792                	slli	a5,a5,0x4
    80208284:	97ba                	add	a5,a5,a4
    80208286:	0007b023          	sd	zero,0(a5)
  disk.desc[i].len = 0;
    8020828a:	00034797          	auipc	a5,0x34
    8020828e:	47678793          	addi	a5,a5,1142 # 8023c700 <disk>
    80208292:	6398                	ld	a4,0(a5)
    80208294:	fec42783          	lw	a5,-20(s0)
    80208298:	0792                	slli	a5,a5,0x4
    8020829a:	97ba                	add	a5,a5,a4
    8020829c:	0007a423          	sw	zero,8(a5)
  disk.desc[i].flags = 0;
    802082a0:	00034797          	auipc	a5,0x34
    802082a4:	46078793          	addi	a5,a5,1120 # 8023c700 <disk>
    802082a8:	6398                	ld	a4,0(a5)
    802082aa:	fec42783          	lw	a5,-20(s0)
    802082ae:	0792                	slli	a5,a5,0x4
    802082b0:	97ba                	add	a5,a5,a4
    802082b2:	00079623          	sh	zero,12(a5)
  disk.desc[i].next = 0;
    802082b6:	00034797          	auipc	a5,0x34
    802082ba:	44a78793          	addi	a5,a5,1098 # 8023c700 <disk>
    802082be:	6398                	ld	a4,0(a5)
    802082c0:	fec42783          	lw	a5,-20(s0)
    802082c4:	0792                	slli	a5,a5,0x4
    802082c6:	97ba                	add	a5,a5,a4
    802082c8:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    802082cc:	00034717          	auipc	a4,0x34
    802082d0:	43470713          	addi	a4,a4,1076 # 8023c700 <disk>
    802082d4:	fec42783          	lw	a5,-20(s0)
    802082d8:	97ba                	add	a5,a5,a4
    802082da:	4705                	li	a4,1
    802082dc:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    802082e0:	00034517          	auipc	a0,0x34
    802082e4:	43850513          	addi	a0,a0,1080 # 8023c718 <disk+0x18>
    802082e8:	ffffe097          	auipc	ra,0xffffe
    802082ec:	b32080e7          	jalr	-1230(ra) # 80205e1a <wakeup>
}
    802082f0:	0001                	nop
    802082f2:	60e2                	ld	ra,24(sp)
    802082f4:	6442                	ld	s0,16(sp)
    802082f6:	6105                	addi	sp,sp,32
    802082f8:	8082                	ret

00000000802082fa <free_chain>:

// free a chain of descriptors.
void
free_chain(int i)
{
    802082fa:	7179                	addi	sp,sp,-48
    802082fc:	f406                	sd	ra,40(sp)
    802082fe:	f022                	sd	s0,32(sp)
    80208300:	1800                	addi	s0,sp,48
    80208302:	87aa                	mv	a5,a0
    80208304:	fcf42e23          	sw	a5,-36(s0)
  while(1){
    int flag = disk.desc[i].flags;
    80208308:	00034797          	auipc	a5,0x34
    8020830c:	3f878793          	addi	a5,a5,1016 # 8023c700 <disk>
    80208310:	6398                	ld	a4,0(a5)
    80208312:	fdc42783          	lw	a5,-36(s0)
    80208316:	0792                	slli	a5,a5,0x4
    80208318:	97ba                	add	a5,a5,a4
    8020831a:	00c7d783          	lhu	a5,12(a5)
    8020831e:	fef42623          	sw	a5,-20(s0)
    int nxt = disk.desc[i].next;
    80208322:	00034797          	auipc	a5,0x34
    80208326:	3de78793          	addi	a5,a5,990 # 8023c700 <disk>
    8020832a:	6398                	ld	a4,0(a5)
    8020832c:	fdc42783          	lw	a5,-36(s0)
    80208330:	0792                	slli	a5,a5,0x4
    80208332:	97ba                	add	a5,a5,a4
    80208334:	00e7d783          	lhu	a5,14(a5)
    80208338:	fef42423          	sw	a5,-24(s0)
    free_desc(i);
    8020833c:	fdc42783          	lw	a5,-36(s0)
    80208340:	853e                	mv	a0,a5
    80208342:	00000097          	auipc	ra,0x0
    80208346:	ee2080e7          	jalr	-286(ra) # 80208224 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8020834a:	fec42783          	lw	a5,-20(s0)
    8020834e:	8b85                	andi	a5,a5,1
    80208350:	2781                	sext.w	a5,a5
    80208352:	c791                	beqz	a5,8020835e <free_chain+0x64>
      i = nxt;
    80208354:	fe842783          	lw	a5,-24(s0)
    80208358:	fcf42e23          	sw	a5,-36(s0)
  while(1){
    8020835c:	b775                	j	80208308 <free_chain+0xe>
    else
      break;
    8020835e:	0001                	nop
  }
}
    80208360:	0001                	nop
    80208362:	70a2                	ld	ra,40(sp)
    80208364:	7402                	ld	s0,32(sp)
    80208366:	6145                	addi	sp,sp,48
    80208368:	8082                	ret

000000008020836a <alloc3_desc>:

int
alloc3_desc(int *idx)
{
    8020836a:	7139                	addi	sp,sp,-64
    8020836c:	fc06                	sd	ra,56(sp)
    8020836e:	f822                	sd	s0,48(sp)
    80208370:	f426                	sd	s1,40(sp)
    80208372:	0080                	addi	s0,sp,64
    80208374:	fca43423          	sd	a0,-56(s0)
  for(int i = 0; i < 3; i++){
    80208378:	fc042e23          	sw	zero,-36(s0)
    8020837c:	a89d                	j	802083f2 <alloc3_desc+0x88>
    idx[i] = alloc_desc();
    8020837e:	fdc42783          	lw	a5,-36(s0)
    80208382:	078a                	slli	a5,a5,0x2
    80208384:	fc843703          	ld	a4,-56(s0)
    80208388:	00f704b3          	add	s1,a4,a5
    8020838c:	00000097          	auipc	ra,0x0
    80208390:	e3e080e7          	jalr	-450(ra) # 802081ca <alloc_desc>
    80208394:	87aa                	mv	a5,a0
    80208396:	c09c                	sw	a5,0(s1)
    if(idx[i] < 0){
    80208398:	fdc42783          	lw	a5,-36(s0)
    8020839c:	078a                	slli	a5,a5,0x2
    8020839e:	fc843703          	ld	a4,-56(s0)
    802083a2:	97ba                	add	a5,a5,a4
    802083a4:	439c                	lw	a5,0(a5)
    802083a6:	0407d163          	bgez	a5,802083e8 <alloc3_desc+0x7e>
      for(int j = 0; j < i; j++)
    802083aa:	fc042c23          	sw	zero,-40(s0)
    802083ae:	a015                	j	802083d2 <alloc3_desc+0x68>
        free_desc(idx[j]);
    802083b0:	fd842783          	lw	a5,-40(s0)
    802083b4:	078a                	slli	a5,a5,0x2
    802083b6:	fc843703          	ld	a4,-56(s0)
    802083ba:	97ba                	add	a5,a5,a4
    802083bc:	439c                	lw	a5,0(a5)
    802083be:	853e                	mv	a0,a5
    802083c0:	00000097          	auipc	ra,0x0
    802083c4:	e64080e7          	jalr	-412(ra) # 80208224 <free_desc>
      for(int j = 0; j < i; j++)
    802083c8:	fd842783          	lw	a5,-40(s0)
    802083cc:	2785                	addiw	a5,a5,1
    802083ce:	fcf42c23          	sw	a5,-40(s0)
    802083d2:	fd842783          	lw	a5,-40(s0)
    802083d6:	873e                	mv	a4,a5
    802083d8:	fdc42783          	lw	a5,-36(s0)
    802083dc:	2701                	sext.w	a4,a4
    802083de:	2781                	sext.w	a5,a5
    802083e0:	fcf748e3          	blt	a4,a5,802083b0 <alloc3_desc+0x46>
      return -1;
    802083e4:	57fd                	li	a5,-1
    802083e6:	a831                	j	80208402 <alloc3_desc+0x98>
  for(int i = 0; i < 3; i++){
    802083e8:	fdc42783          	lw	a5,-36(s0)
    802083ec:	2785                	addiw	a5,a5,1
    802083ee:	fcf42e23          	sw	a5,-36(s0)
    802083f2:	fdc42783          	lw	a5,-36(s0)
    802083f6:	0007871b          	sext.w	a4,a5
    802083fa:	4789                	li	a5,2
    802083fc:	f8e7d1e3          	bge	a5,a4,8020837e <alloc3_desc+0x14>
    }
  }
  return 0;
    80208400:	4781                	li	a5,0
}
    80208402:	853e                	mv	a0,a5
    80208404:	70e2                	ld	ra,56(sp)
    80208406:	7442                	ld	s0,48(sp)
    80208408:	74a2                	ld	s1,40(sp)
    8020840a:	6121                	addi	sp,sp,64
    8020840c:	8082                	ret

000000008020840e <virtio_disk_rw>:

void
virtio_disk_rw(struct buf *b, int write)
{
    8020840e:	7139                	addi	sp,sp,-64
    80208410:	fc06                	sd	ra,56(sp)
    80208412:	f822                	sd	s0,48(sp)
    80208414:	0080                	addi	s0,sp,64
    80208416:	fca43423          	sd	a0,-56(s0)
    8020841a:	87ae                	mv	a5,a1
    8020841c:	fcf42223          	sw	a5,-60(s0)
  uint64 sector = b->blockno * (BSIZE / 512);
    80208420:	fc843783          	ld	a5,-56(s0)
    80208424:	47dc                	lw	a5,12(a5)
    80208426:	0017979b          	slliw	a5,a5,0x1
    8020842a:	2781                	sext.w	a5,a5
    8020842c:	1782                	slli	a5,a5,0x20
    8020842e:	9381                	srli	a5,a5,0x20
    80208430:	fef43423          	sd	a5,-24(s0)
  acquire(&disk.vdisk_lock);
    80208434:	00034517          	auipc	a0,0x34
    80208438:	4fc50513          	addi	a0,a0,1276 # 8023c930 <disk+0x230>
    8020843c:	00003097          	auipc	ra,0x3
    80208440:	6ec080e7          	jalr	1772(ra) # 8020bb28 <acquire>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
    80208444:	fd040793          	addi	a5,s0,-48
    80208448:	853e                	mv	a0,a5
    8020844a:	00000097          	auipc	ra,0x0
    8020844e:	f20080e7          	jalr	-224(ra) # 8020836a <alloc3_desc>
    80208452:	87aa                	mv	a5,a0
    80208454:	cf91                	beqz	a5,80208470 <virtio_disk_rw+0x62>
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80208456:	00034597          	auipc	a1,0x34
    8020845a:	4da58593          	addi	a1,a1,1242 # 8023c930 <disk+0x230>
    8020845e:	00034517          	auipc	a0,0x34
    80208462:	2ba50513          	addi	a0,a0,698 # 8023c718 <disk+0x18>
    80208466:	ffffe097          	auipc	ra,0xffffe
    8020846a:	8fc080e7          	jalr	-1796(ra) # 80205d62 <sleep>
    if(alloc3_desc(idx) == 0) {
    8020846e:	bfd9                	j	80208444 <virtio_disk_rw+0x36>
      break;
    80208470:	0001                	nop
  }
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80208472:	fd042783          	lw	a5,-48(s0)
    80208476:	07cd                	addi	a5,a5,19
    80208478:	00479713          	slli	a4,a5,0x4
    8020847c:	00034797          	auipc	a5,0x34
    80208480:	28478793          	addi	a5,a5,644 # 8023c700 <disk>
    80208484:	97ba                	add	a5,a5,a4
    80208486:	fef43023          	sd	a5,-32(s0)
  if(write)
    8020848a:	fc442783          	lw	a5,-60(s0)
    8020848e:	2781                	sext.w	a5,a5
    80208490:	c791                	beqz	a5,8020849c <virtio_disk_rw+0x8e>
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80208492:	fe043783          	ld	a5,-32(s0)
    80208496:	4705                	li	a4,1
    80208498:	c398                	sw	a4,0(a5)
    8020849a:	a029                	j	802084a4 <virtio_disk_rw+0x96>
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    8020849c:	fe043783          	ld	a5,-32(s0)
    802084a0:	0007a023          	sw	zero,0(a5)
  buf0->reserved = 0;
    802084a4:	fe043783          	ld	a5,-32(s0)
    802084a8:	0007a223          	sw	zero,4(a5)
  buf0->sector = sector;
    802084ac:	fe043783          	ld	a5,-32(s0)
    802084b0:	fe843703          	ld	a4,-24(s0)
    802084b4:	e798                	sd	a4,8(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    802084b6:	00034797          	auipc	a5,0x34
    802084ba:	24a78793          	addi	a5,a5,586 # 8023c700 <disk>
    802084be:	6398                	ld	a4,0(a5)
    802084c0:	fd042783          	lw	a5,-48(s0)
    802084c4:	0792                	slli	a5,a5,0x4
    802084c6:	97ba                	add	a5,a5,a4
    802084c8:	fe043703          	ld	a4,-32(s0)
    802084cc:	e398                	sd	a4,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    802084ce:	00034797          	auipc	a5,0x34
    802084d2:	23278793          	addi	a5,a5,562 # 8023c700 <disk>
    802084d6:	6398                	ld	a4,0(a5)
    802084d8:	fd042783          	lw	a5,-48(s0)
    802084dc:	0792                	slli	a5,a5,0x4
    802084de:	97ba                	add	a5,a5,a4
    802084e0:	4741                	li	a4,16
    802084e2:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    802084e4:	00034797          	auipc	a5,0x34
    802084e8:	21c78793          	addi	a5,a5,540 # 8023c700 <disk>
    802084ec:	6398                	ld	a4,0(a5)
    802084ee:	fd042783          	lw	a5,-48(s0)
    802084f2:	0792                	slli	a5,a5,0x4
    802084f4:	97ba                	add	a5,a5,a4
    802084f6:	4705                	li	a4,1
    802084f8:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    802084fc:	fd442683          	lw	a3,-44(s0)
    80208500:	00034797          	auipc	a5,0x34
    80208504:	20078793          	addi	a5,a5,512 # 8023c700 <disk>
    80208508:	6398                	ld	a4,0(a5)
    8020850a:	fd042783          	lw	a5,-48(s0)
    8020850e:	0792                	slli	a5,a5,0x4
    80208510:	97ba                	add	a5,a5,a4
    80208512:	03069713          	slli	a4,a3,0x30
    80208516:	9341                	srli	a4,a4,0x30
    80208518:	00e79723          	sh	a4,14(a5)
  disk.desc[idx[1]].addr = (uint64) b->data;
    8020851c:	fc843783          	ld	a5,-56(s0)
    80208520:	05078693          	addi	a3,a5,80
    80208524:	00034797          	auipc	a5,0x34
    80208528:	1dc78793          	addi	a5,a5,476 # 8023c700 <disk>
    8020852c:	6398                	ld	a4,0(a5)
    8020852e:	fd442783          	lw	a5,-44(s0)
    80208532:	0792                	slli	a5,a5,0x4
    80208534:	97ba                	add	a5,a5,a4
    80208536:	8736                	mv	a4,a3
    80208538:	e398                	sd	a4,0(a5)
  disk.desc[idx[1]].len = BSIZE;
    8020853a:	00034797          	auipc	a5,0x34
    8020853e:	1c678793          	addi	a5,a5,454 # 8023c700 <disk>
    80208542:	6398                	ld	a4,0(a5)
    80208544:	fd442783          	lw	a5,-44(s0)
    80208548:	0792                	slli	a5,a5,0x4
    8020854a:	97ba                	add	a5,a5,a4
    8020854c:	40000713          	li	a4,1024
    80208550:	c798                	sw	a4,8(a5)
  if(write){
    80208552:	fc442783          	lw	a5,-60(s0)
    80208556:	2781                	sext.w	a5,a5
    80208558:	cf89                	beqz	a5,80208572 <virtio_disk_rw+0x164>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8020855a:	00034797          	auipc	a5,0x34
    8020855e:	1a678793          	addi	a5,a5,422 # 8023c700 <disk>
    80208562:	6398                	ld	a4,0(a5)
    80208564:	fd442783          	lw	a5,-44(s0)
    80208568:	0792                	slli	a5,a5,0x4
    8020856a:	97ba                	add	a5,a5,a4
    8020856c:	00079623          	sh	zero,12(a5)
    80208570:	a829                	j	8020858a <virtio_disk_rw+0x17c>
  }else{
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80208572:	00034797          	auipc	a5,0x34
    80208576:	18e78793          	addi	a5,a5,398 # 8023c700 <disk>
    8020857a:	6398                	ld	a4,0(a5)
    8020857c:	fd442783          	lw	a5,-44(s0)
    80208580:	0792                	slli	a5,a5,0x4
    80208582:	97ba                	add	a5,a5,a4
    80208584:	4709                	li	a4,2
    80208586:	00e79623          	sh	a4,12(a5)
  }
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8020858a:	00034797          	auipc	a5,0x34
    8020858e:	17678793          	addi	a5,a5,374 # 8023c700 <disk>
    80208592:	6398                	ld	a4,0(a5)
    80208594:	fd442783          	lw	a5,-44(s0)
    80208598:	0792                	slli	a5,a5,0x4
    8020859a:	97ba                	add	a5,a5,a4
    8020859c:	00c7d703          	lhu	a4,12(a5)
    802085a0:	00034797          	auipc	a5,0x34
    802085a4:	16078793          	addi	a5,a5,352 # 8023c700 <disk>
    802085a8:	6394                	ld	a3,0(a5)
    802085aa:	fd442783          	lw	a5,-44(s0)
    802085ae:	0792                	slli	a5,a5,0x4
    802085b0:	97b6                	add	a5,a5,a3
    802085b2:	00176713          	ori	a4,a4,1
    802085b6:	1742                	slli	a4,a4,0x30
    802085b8:	9341                	srli	a4,a4,0x30
    802085ba:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[1]].next = idx[2];
    802085be:	fd842683          	lw	a3,-40(s0)
    802085c2:	00034797          	auipc	a5,0x34
    802085c6:	13e78793          	addi	a5,a5,318 # 8023c700 <disk>
    802085ca:	6398                	ld	a4,0(a5)
    802085cc:	fd442783          	lw	a5,-44(s0)
    802085d0:	0792                	slli	a5,a5,0x4
    802085d2:	97ba                	add	a5,a5,a4
    802085d4:	03069713          	slli	a4,a3,0x30
    802085d8:	9341                	srli	a4,a4,0x30
    802085da:	00e79723          	sh	a4,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    802085de:	fd042783          	lw	a5,-48(s0)
    802085e2:	00034717          	auipc	a4,0x34
    802085e6:	11e70713          	addi	a4,a4,286 # 8023c700 <disk>
    802085ea:	078d                	addi	a5,a5,3
    802085ec:	0792                	slli	a5,a5,0x4
    802085ee:	97ba                	add	a5,a5,a4
    802085f0:	577d                	li	a4,-1
    802085f2:	00e78423          	sb	a4,8(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    802085f6:	fd042783          	lw	a5,-48(s0)
    802085fa:	078d                	addi	a5,a5,3
    802085fc:	00479713          	slli	a4,a5,0x4
    80208600:	00034797          	auipc	a5,0x34
    80208604:	10078793          	addi	a5,a5,256 # 8023c700 <disk>
    80208608:	97ba                	add	a5,a5,a4
    8020860a:	00878693          	addi	a3,a5,8
    8020860e:	00034797          	auipc	a5,0x34
    80208612:	0f278793          	addi	a5,a5,242 # 8023c700 <disk>
    80208616:	6398                	ld	a4,0(a5)
    80208618:	fd842783          	lw	a5,-40(s0)
    8020861c:	0792                	slli	a5,a5,0x4
    8020861e:	97ba                	add	a5,a5,a4
    80208620:	8736                	mv	a4,a3
    80208622:	e398                	sd	a4,0(a5)
  disk.desc[idx[2]].len = 1;
    80208624:	00034797          	auipc	a5,0x34
    80208628:	0dc78793          	addi	a5,a5,220 # 8023c700 <disk>
    8020862c:	6398                	ld	a4,0(a5)
    8020862e:	fd842783          	lw	a5,-40(s0)
    80208632:	0792                	slli	a5,a5,0x4
    80208634:	97ba                	add	a5,a5,a4
    80208636:	4705                	li	a4,1
    80208638:	c798                	sw	a4,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8020863a:	00034797          	auipc	a5,0x34
    8020863e:	0c678793          	addi	a5,a5,198 # 8023c700 <disk>
    80208642:	6398                	ld	a4,0(a5)
    80208644:	fd842783          	lw	a5,-40(s0)
    80208648:	0792                	slli	a5,a5,0x4
    8020864a:	97ba                	add	a5,a5,a4
    8020864c:	4709                	li	a4,2
    8020864e:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[2]].next = 0;
    80208652:	00034797          	auipc	a5,0x34
    80208656:	0ae78793          	addi	a5,a5,174 # 8023c700 <disk>
    8020865a:	6398                	ld	a4,0(a5)
    8020865c:	fd842783          	lw	a5,-40(s0)
    80208660:	0792                	slli	a5,a5,0x4
    80208662:	97ba                	add	a5,a5,a4
    80208664:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80208668:	fc843783          	ld	a5,-56(s0)
    8020866c:	4705                	li	a4,1
    8020866e:	c3d8                	sw	a4,4(a5)
  disk.info[idx[0]].b = b;
    80208670:	fd042783          	lw	a5,-48(s0)
    80208674:	00034717          	auipc	a4,0x34
    80208678:	08c70713          	addi	a4,a4,140 # 8023c700 <disk>
    8020867c:	078d                	addi	a5,a5,3
    8020867e:	0792                	slli	a5,a5,0x4
    80208680:	97ba                	add	a5,a5,a4
    80208682:	fc843703          	ld	a4,-56(s0)
    80208686:	e398                	sd	a4,0(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80208688:	fd042703          	lw	a4,-48(s0)
    8020868c:	00034797          	auipc	a5,0x34
    80208690:	07478793          	addi	a5,a5,116 # 8023c700 <disk>
    80208694:	6794                	ld	a3,8(a5)
    80208696:	00034797          	auipc	a5,0x34
    8020869a:	06a78793          	addi	a5,a5,106 # 8023c700 <disk>
    8020869e:	679c                	ld	a5,8(a5)
    802086a0:	0027d783          	lhu	a5,2(a5)
    802086a4:	2781                	sext.w	a5,a5
    802086a6:	8bbd                	andi	a5,a5,15
    802086a8:	2781                	sext.w	a5,a5
    802086aa:	1742                	slli	a4,a4,0x30
    802086ac:	9341                	srli	a4,a4,0x30
    802086ae:	0786                	slli	a5,a5,0x1
    802086b0:	97b6                	add	a5,a5,a3
    802086b2:	00e79223          	sh	a4,4(a5)
  __sync_synchronize();
    802086b6:	0ff0000f          	fence
  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    802086ba:	00034797          	auipc	a5,0x34
    802086be:	04678793          	addi	a5,a5,70 # 8023c700 <disk>
    802086c2:	679c                	ld	a5,8(a5)
    802086c4:	0027d703          	lhu	a4,2(a5)
    802086c8:	00034797          	auipc	a5,0x34
    802086cc:	03878793          	addi	a5,a5,56 # 8023c700 <disk>
    802086d0:	679c                	ld	a5,8(a5)
    802086d2:	2705                	addiw	a4,a4,1
    802086d4:	1742                	slli	a4,a4,0x30
    802086d6:	9341                	srli	a4,a4,0x30
    802086d8:	00e79123          	sh	a4,2(a5)
  __sync_synchronize();
    802086dc:	0ff0000f          	fence
  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    802086e0:	100017b7          	lui	a5,0x10001
    802086e4:	05078793          	addi	a5,a5,80 # 10001050 <_entry-0x701fefb0>
    802086e8:	0007a023          	sw	zero,0(a5)
  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    802086ec:	a819                	j	80208702 <virtio_disk_rw+0x2f4>
    sleep(b, &disk.vdisk_lock);
    802086ee:	00034597          	auipc	a1,0x34
    802086f2:	24258593          	addi	a1,a1,578 # 8023c930 <disk+0x230>
    802086f6:	fc843503          	ld	a0,-56(s0)
    802086fa:	ffffd097          	auipc	ra,0xffffd
    802086fe:	668080e7          	jalr	1640(ra) # 80205d62 <sleep>
  while(b->disk == 1) {
    80208702:	fc843783          	ld	a5,-56(s0)
    80208706:	43dc                	lw	a5,4(a5)
    80208708:	873e                	mv	a4,a5
    8020870a:	4785                	li	a5,1
    8020870c:	fef701e3          	beq	a4,a5,802086ee <virtio_disk_rw+0x2e0>
  }

  disk.info[idx[0]].b = 0;
    80208710:	fd042783          	lw	a5,-48(s0)
    80208714:	00034717          	auipc	a4,0x34
    80208718:	fec70713          	addi	a4,a4,-20 # 8023c700 <disk>
    8020871c:	078d                	addi	a5,a5,3
    8020871e:	0792                	slli	a5,a5,0x4
    80208720:	97ba                	add	a5,a5,a4
    80208722:	0007b023          	sd	zero,0(a5)
  free_chain(idx[0]);
    80208726:	fd042783          	lw	a5,-48(s0)
    8020872a:	853e                	mv	a0,a5
    8020872c:	00000097          	auipc	ra,0x0
    80208730:	bce080e7          	jalr	-1074(ra) # 802082fa <free_chain>
  release(&disk.vdisk_lock);
    80208734:	00034517          	auipc	a0,0x34
    80208738:	1fc50513          	addi	a0,a0,508 # 8023c930 <disk+0x230>
    8020873c:	00003097          	auipc	ra,0x3
    80208740:	438080e7          	jalr	1080(ra) # 8020bb74 <release>
}
    80208744:	0001                	nop
    80208746:	70e2                	ld	ra,56(sp)
    80208748:	7442                	ld	s0,48(sp)
    8020874a:	6121                	addi	sp,sp,64
    8020874c:	8082                	ret

000000008020874e <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8020874e:	1101                	addi	sp,sp,-32
    80208750:	ec06                	sd	ra,24(sp)
    80208752:	e822                	sd	s0,16(sp)
    80208754:	1000                	addi	s0,sp,32
	acquire(&disk.vdisk_lock);
    80208756:	00034517          	auipc	a0,0x34
    8020875a:	1da50513          	addi	a0,a0,474 # 8023c930 <disk+0x230>
    8020875e:	00003097          	auipc	ra,0x3
    80208762:	3ca080e7          	jalr	970(ra) # 8020bb28 <acquire>

  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80208766:	100017b7          	lui	a5,0x10001
    8020876a:	06078793          	addi	a5,a5,96 # 10001060 <_entry-0x701fefa0>
    8020876e:	439c                	lw	a5,0(a5)
    80208770:	0007871b          	sext.w	a4,a5
    80208774:	100017b7          	lui	a5,0x10001
    80208778:	06478793          	addi	a5,a5,100 # 10001064 <_entry-0x701fef9c>
    8020877c:	8b0d                	andi	a4,a4,3
    8020877e:	2701                	sext.w	a4,a4
    80208780:	c398                	sw	a4,0(a5)
  __sync_synchronize();
    80208782:	0ff0000f          	fence
  while(disk.used_idx != disk.used->idx){
    80208786:	a045                	j	80208826 <virtio_disk_intr+0xd8>
	__sync_synchronize();
    80208788:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8020878c:	00034797          	auipc	a5,0x34
    80208790:	f7478793          	addi	a5,a5,-140 # 8023c700 <disk>
    80208794:	6b98                	ld	a4,16(a5)
    80208796:	00034797          	auipc	a5,0x34
    8020879a:	f6a78793          	addi	a5,a5,-150 # 8023c700 <disk>
    8020879e:	0287d783          	lhu	a5,40(a5)
    802087a2:	2781                	sext.w	a5,a5
    802087a4:	8bbd                	andi	a5,a5,15
    802087a6:	2781                	sext.w	a5,a5
    802087a8:	078e                	slli	a5,a5,0x3
    802087aa:	97ba                	add	a5,a5,a4
    802087ac:	43dc                	lw	a5,4(a5)
    802087ae:	fef42623          	sw	a5,-20(s0)

    if(disk.info[id].status != 0)
    802087b2:	00034717          	auipc	a4,0x34
    802087b6:	f4e70713          	addi	a4,a4,-178 # 8023c700 <disk>
    802087ba:	fec42783          	lw	a5,-20(s0)
    802087be:	078d                	addi	a5,a5,3
    802087c0:	0792                	slli	a5,a5,0x4
    802087c2:	97ba                	add	a5,a5,a4
    802087c4:	0087c783          	lbu	a5,8(a5)
    802087c8:	cb89                	beqz	a5,802087da <virtio_disk_intr+0x8c>
      panic("virtio_disk_intr status");
    802087ca:	00024517          	auipc	a0,0x24
    802087ce:	8fe50513          	addi	a0,a0,-1794 # 8022c0c8 <user_test_table+0x180>
    802087d2:	ffff9097          	auipc	ra,0xffff9
    802087d6:	008080e7          	jalr	8(ra) # 802017da <panic>

    struct buf *b = disk.info[id].b;
    802087da:	00034717          	auipc	a4,0x34
    802087de:	f2670713          	addi	a4,a4,-218 # 8023c700 <disk>
    802087e2:	fec42783          	lw	a5,-20(s0)
    802087e6:	078d                	addi	a5,a5,3
    802087e8:	0792                	slli	a5,a5,0x4
    802087ea:	97ba                	add	a5,a5,a4
    802087ec:	639c                	ld	a5,0(a5)
    802087ee:	fef43023          	sd	a5,-32(s0)
    b->disk = 0;   // disk is done with buf
    802087f2:	fe043783          	ld	a5,-32(s0)
    802087f6:	0007a223          	sw	zero,4(a5)
    wakeup(b);
    802087fa:	fe043503          	ld	a0,-32(s0)
    802087fe:	ffffd097          	auipc	ra,0xffffd
    80208802:	61c080e7          	jalr	1564(ra) # 80205e1a <wakeup>
    disk.used_idx += 1;
    80208806:	00034797          	auipc	a5,0x34
    8020880a:	efa78793          	addi	a5,a5,-262 # 8023c700 <disk>
    8020880e:	0287d783          	lhu	a5,40(a5)
    80208812:	2785                	addiw	a5,a5,1
    80208814:	03079713          	slli	a4,a5,0x30
    80208818:	9341                	srli	a4,a4,0x30
    8020881a:	00034797          	auipc	a5,0x34
    8020881e:	ee678793          	addi	a5,a5,-282 # 8023c700 <disk>
    80208822:	02e79423          	sh	a4,40(a5)
  while(disk.used_idx != disk.used->idx){
    80208826:	00034797          	auipc	a5,0x34
    8020882a:	eda78793          	addi	a5,a5,-294 # 8023c700 <disk>
    8020882e:	0287d703          	lhu	a4,40(a5)
    80208832:	00034797          	auipc	a5,0x34
    80208836:	ece78793          	addi	a5,a5,-306 # 8023c700 <disk>
    8020883a:	6b9c                	ld	a5,16(a5)
    8020883c:	0027d783          	lhu	a5,2(a5)
    80208840:	2701                	sext.w	a4,a4
    80208842:	2781                	sext.w	a5,a5
    80208844:	f4f712e3          	bne	a4,a5,80208788 <virtio_disk_intr+0x3a>
  }
	release(&disk.vdisk_lock);
    80208848:	00034517          	auipc	a0,0x34
    8020884c:	0e850513          	addi	a0,a0,232 # 8023c930 <disk+0x230>
    80208850:	00003097          	auipc	ra,0x3
    80208854:	324080e7          	jalr	804(ra) # 8020bb74 <release>
}
    80208858:	0001                	nop
    8020885a:	60e2                	ld	ra,24(sp)
    8020885c:	6442                	ld	s0,16(sp)
    8020885e:	6105                	addi	sp,sp,32
    80208860:	8082                	ret

0000000080208862 <assert>:
    80208862:	1101                	addi	sp,sp,-32
    80208864:	ec06                	sd	ra,24(sp)
    80208866:	e822                	sd	s0,16(sp)
    80208868:	1000                	addi	s0,sp,32
    8020886a:	87aa                	mv	a5,a0
    8020886c:	fef42623          	sw	a5,-20(s0)
    80208870:	fec42783          	lw	a5,-20(s0)
    80208874:	2781                	sext.w	a5,a5
    80208876:	e79d                	bnez	a5,802088a4 <assert+0x42>
    80208878:	33800613          	li	a2,824
    8020887c:	00026597          	auipc	a1,0x26
    80208880:	91458593          	addi	a1,a1,-1772 # 8022e190 <user_test_table+0x78>
    80208884:	00026517          	auipc	a0,0x26
    80208888:	91c50513          	addi	a0,a0,-1764 # 8022e1a0 <user_test_table+0x88>
    8020888c:	ffff8097          	auipc	ra,0xffff8
    80208890:	502080e7          	jalr	1282(ra) # 80200d8e <printf>
    80208894:	00026517          	auipc	a0,0x26
    80208898:	93450513          	addi	a0,a0,-1740 # 8022e1c8 <user_test_table+0xb0>
    8020889c:	ffff9097          	auipc	ra,0xffff9
    802088a0:	f3e080e7          	jalr	-194(ra) # 802017da <panic>
    802088a4:	0001                	nop
    802088a6:	60e2                	ld	ra,24(sp)
    802088a8:	6442                	ld	s0,16(sp)
    802088aa:	6105                	addi	sp,sp,32
    802088ac:	8082                	ret

00000000802088ae <binit>:
{
    802088ae:	1101                	addi	sp,sp,-32
    802088b0:	ec06                	sd	ra,24(sp)
    802088b2:	e822                	sd	s0,16(sp)
    802088b4:	1000                	addi	s0,sp,32
  initlock(&bcache.lock, "bcache");
    802088b6:	00026597          	auipc	a1,0x26
    802088ba:	91a58593          	addi	a1,a1,-1766 # 8022e1d0 <user_test_table+0xb8>
    802088be:	0003c517          	auipc	a0,0x3c
    802088c2:	63250513          	addi	a0,a0,1586 # 80244ef0 <bcache+0x85b0>
    802088c6:	00003097          	auipc	ra,0x3
    802088ca:	23a080e7          	jalr	570(ra) # 8020bb00 <initlock>
  bcache.head.prev = &bcache.head;
    802088ce:	00034717          	auipc	a4,0x34
    802088d2:	07270713          	addi	a4,a4,114 # 8023c940 <bcache>
    802088d6:	67a1                	lui	a5,0x8
    802088d8:	97ba                	add	a5,a5,a4
    802088da:	0003c717          	auipc	a4,0x3c
    802088de:	1c670713          	addi	a4,a4,454 # 80244aa0 <bcache+0x8160>
    802088e2:	1ae7b023          	sd	a4,416(a5) # 81a0 <_entry-0x801f7e60>
  bcache.head.next = &bcache.head;
    802088e6:	00034717          	auipc	a4,0x34
    802088ea:	05a70713          	addi	a4,a4,90 # 8023c940 <bcache>
    802088ee:	67a1                	lui	a5,0x8
    802088f0:	97ba                	add	a5,a5,a4
    802088f2:	0003c717          	auipc	a4,0x3c
    802088f6:	1ae70713          	addi	a4,a4,430 # 80244aa0 <bcache+0x8160>
    802088fa:	1ae7b423          	sd	a4,424(a5) # 81a8 <_entry-0x801f7e58>
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    802088fe:	00034797          	auipc	a5,0x34
    80208902:	04278793          	addi	a5,a5,66 # 8023c940 <bcache>
    80208906:	fef43423          	sd	a5,-24(s0)
    8020890a:	a895                	j	8020897e <binit+0xd0>
    b->next = bcache.head.next;
    8020890c:	00034717          	auipc	a4,0x34
    80208910:	03470713          	addi	a4,a4,52 # 8023c940 <bcache>
    80208914:	67a1                	lui	a5,0x8
    80208916:	97ba                	add	a5,a5,a4
    80208918:	1a87b703          	ld	a4,424(a5) # 81a8 <_entry-0x801f7e58>
    8020891c:	fe843783          	ld	a5,-24(s0)
    80208920:	e7b8                	sd	a4,72(a5)
    b->prev = &bcache.head;
    80208922:	fe843783          	ld	a5,-24(s0)
    80208926:	0003c717          	auipc	a4,0x3c
    8020892a:	17a70713          	addi	a4,a4,378 # 80244aa0 <bcache+0x8160>
    8020892e:	e3b8                	sd	a4,64(a5)
	initsleeplock(&b->lock, "buffer");
    80208930:	fe843783          	ld	a5,-24(s0)
    80208934:	07e1                	addi	a5,a5,24
    80208936:	00026597          	auipc	a1,0x26
    8020893a:	8a258593          	addi	a1,a1,-1886 # 8022e1d8 <user_test_table+0xc0>
    8020893e:	853e                	mv	a0,a5
    80208940:	00003097          	auipc	ra,0x3
    80208944:	294080e7          	jalr	660(ra) # 8020bbd4 <initsleeplock>
    bcache.head.next->prev = b;
    80208948:	00034717          	auipc	a4,0x34
    8020894c:	ff870713          	addi	a4,a4,-8 # 8023c940 <bcache>
    80208950:	67a1                	lui	a5,0x8
    80208952:	97ba                	add	a5,a5,a4
    80208954:	1a87b783          	ld	a5,424(a5) # 81a8 <_entry-0x801f7e58>
    80208958:	fe843703          	ld	a4,-24(s0)
    8020895c:	e3b8                	sd	a4,64(a5)
    bcache.head.next = b;
    8020895e:	00034717          	auipc	a4,0x34
    80208962:	fe270713          	addi	a4,a4,-30 # 8023c940 <bcache>
    80208966:	67a1                	lui	a5,0x8
    80208968:	97ba                	add	a5,a5,a4
    8020896a:	fe843703          	ld	a4,-24(s0)
    8020896e:	1ae7b423          	sd	a4,424(a5) # 81a8 <_entry-0x801f7e58>
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80208972:	fe843783          	ld	a5,-24(s0)
    80208976:	45078793          	addi	a5,a5,1104
    8020897a:	fef43423          	sd	a5,-24(s0)
    8020897e:	0003c797          	auipc	a5,0x3c
    80208982:	12278793          	addi	a5,a5,290 # 80244aa0 <bcache+0x8160>
    80208986:	fe843703          	ld	a4,-24(s0)
    8020898a:	f8f761e3          	bltu	a4,a5,8020890c <binit+0x5e>
}
    8020898e:	0001                	nop
    80208990:	0001                	nop
    80208992:	60e2                	ld	ra,24(sp)
    80208994:	6442                	ld	s0,16(sp)
    80208996:	6105                	addi	sp,sp,32
    80208998:	8082                	ret

000000008020899a <bget>:
{
    8020899a:	7179                	addi	sp,sp,-48
    8020899c:	f406                	sd	ra,40(sp)
    8020899e:	f022                	sd	s0,32(sp)
    802089a0:	1800                	addi	s0,sp,48
    802089a2:	87aa                	mv	a5,a0
    802089a4:	872e                	mv	a4,a1
    802089a6:	fcf42e23          	sw	a5,-36(s0)
    802089aa:	87ba                	mv	a5,a4
    802089ac:	fcf42c23          	sw	a5,-40(s0)
  acquire(&bcache.lock); // 加锁
    802089b0:	0003c517          	auipc	a0,0x3c
    802089b4:	54050513          	addi	a0,a0,1344 # 80244ef0 <bcache+0x85b0>
    802089b8:	00003097          	auipc	ra,0x3
    802089bc:	170080e7          	jalr	368(ra) # 8020bb28 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    802089c0:	00034717          	auipc	a4,0x34
    802089c4:	f8070713          	addi	a4,a4,-128 # 8023c940 <bcache>
    802089c8:	67a1                	lui	a5,0x8
    802089ca:	97ba                	add	a5,a5,a4
    802089cc:	1a87b783          	ld	a5,424(a5) # 81a8 <_entry-0x801f7e58>
    802089d0:	fef43423          	sd	a5,-24(s0)
    802089d4:	a095                	j	80208a38 <bget+0x9e>
    if(b->dev == dev && b->blockno == blockno){
    802089d6:	fe843783          	ld	a5,-24(s0)
    802089da:	4798                	lw	a4,8(a5)
    802089dc:	fdc42783          	lw	a5,-36(s0)
    802089e0:	2781                	sext.w	a5,a5
    802089e2:	04e79663          	bne	a5,a4,80208a2e <bget+0x94>
    802089e6:	fe843783          	ld	a5,-24(s0)
    802089ea:	47d8                	lw	a4,12(a5)
    802089ec:	fd842783          	lw	a5,-40(s0)
    802089f0:	2781                	sext.w	a5,a5
    802089f2:	02e79e63          	bne	a5,a4,80208a2e <bget+0x94>
      b->refcnt++;
    802089f6:	fe843783          	ld	a5,-24(s0)
    802089fa:	4b9c                	lw	a5,16(a5)
    802089fc:	2785                	addiw	a5,a5,1
    802089fe:	0007871b          	sext.w	a4,a5
    80208a02:	fe843783          	ld	a5,-24(s0)
    80208a06:	cb98                	sw	a4,16(a5)
	  release(&bcache.lock); // 解锁
    80208a08:	0003c517          	auipc	a0,0x3c
    80208a0c:	4e850513          	addi	a0,a0,1256 # 80244ef0 <bcache+0x85b0>
    80208a10:	00003097          	auipc	ra,0x3
    80208a14:	164080e7          	jalr	356(ra) # 8020bb74 <release>
      acquiresleep(&b->lock);
    80208a18:	fe843783          	ld	a5,-24(s0)
    80208a1c:	07e1                	addi	a5,a5,24
    80208a1e:	853e                	mv	a0,a5
    80208a20:	00003097          	auipc	ra,0x3
    80208a24:	200080e7          	jalr	512(ra) # 8020bc20 <acquiresleep>
      return b;
    80208a28:	fe843783          	ld	a5,-24(s0)
    80208a2c:	a845                	j	80208adc <bget+0x142>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80208a2e:	fe843783          	ld	a5,-24(s0)
    80208a32:	67bc                	ld	a5,72(a5)
    80208a34:	fef43423          	sd	a5,-24(s0)
    80208a38:	fe843703          	ld	a4,-24(s0)
    80208a3c:	0003c797          	auipc	a5,0x3c
    80208a40:	06478793          	addi	a5,a5,100 # 80244aa0 <bcache+0x8160>
    80208a44:	f8f719e3          	bne	a4,a5,802089d6 <bget+0x3c>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80208a48:	00034717          	auipc	a4,0x34
    80208a4c:	ef870713          	addi	a4,a4,-264 # 8023c940 <bcache>
    80208a50:	67a1                	lui	a5,0x8
    80208a52:	97ba                	add	a5,a5,a4
    80208a54:	1a07b783          	ld	a5,416(a5) # 81a0 <_entry-0x801f7e60>
    80208a58:	fef43423          	sd	a5,-24(s0)
    80208a5c:	a8b9                	j	80208aba <bget+0x120>
    if(b->refcnt == 0) {
    80208a5e:	fe843783          	ld	a5,-24(s0)
    80208a62:	4b9c                	lw	a5,16(a5)
    80208a64:	e7b1                	bnez	a5,80208ab0 <bget+0x116>
      b->dev = dev;
    80208a66:	fe843783          	ld	a5,-24(s0)
    80208a6a:	fdc42703          	lw	a4,-36(s0)
    80208a6e:	c798                	sw	a4,8(a5)
      b->blockno = blockno;
    80208a70:	fe843783          	ld	a5,-24(s0)
    80208a74:	fd842703          	lw	a4,-40(s0)
    80208a78:	c7d8                	sw	a4,12(a5)
      b->valid = 0;
    80208a7a:	fe843783          	ld	a5,-24(s0)
    80208a7e:	0007a023          	sw	zero,0(a5)
      b->refcnt = 1;
    80208a82:	fe843783          	ld	a5,-24(s0)
    80208a86:	4705                	li	a4,1
    80208a88:	cb98                	sw	a4,16(a5)
	  release(&bcache.lock); // 解锁
    80208a8a:	0003c517          	auipc	a0,0x3c
    80208a8e:	46650513          	addi	a0,a0,1126 # 80244ef0 <bcache+0x85b0>
    80208a92:	00003097          	auipc	ra,0x3
    80208a96:	0e2080e7          	jalr	226(ra) # 8020bb74 <release>
      acquiresleep(&b->lock);
    80208a9a:	fe843783          	ld	a5,-24(s0)
    80208a9e:	07e1                	addi	a5,a5,24
    80208aa0:	853e                	mv	a0,a5
    80208aa2:	00003097          	auipc	ra,0x3
    80208aa6:	17e080e7          	jalr	382(ra) # 8020bc20 <acquiresleep>
      return b;
    80208aaa:	fe843783          	ld	a5,-24(s0)
    80208aae:	a03d                	j	80208adc <bget+0x142>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80208ab0:	fe843783          	ld	a5,-24(s0)
    80208ab4:	63bc                	ld	a5,64(a5)
    80208ab6:	fef43423          	sd	a5,-24(s0)
    80208aba:	fe843703          	ld	a4,-24(s0)
    80208abe:	0003c797          	auipc	a5,0x3c
    80208ac2:	fe278793          	addi	a5,a5,-30 # 80244aa0 <bcache+0x8160>
    80208ac6:	f8f71ce3          	bne	a4,a5,80208a5e <bget+0xc4>
  panic("bget: no buffers");
    80208aca:	00025517          	auipc	a0,0x25
    80208ace:	71650513          	addi	a0,a0,1814 # 8022e1e0 <user_test_table+0xc8>
    80208ad2:	ffff9097          	auipc	ra,0xffff9
    80208ad6:	d08080e7          	jalr	-760(ra) # 802017da <panic>
  return 0;
    80208ada:	4781                	li	a5,0
}
    80208adc:	853e                	mv	a0,a5
    80208ade:	70a2                	ld	ra,40(sp)
    80208ae0:	7402                	ld	s0,32(sp)
    80208ae2:	6145                	addi	sp,sp,48
    80208ae4:	8082                	ret

0000000080208ae6 <bread>:
{
    80208ae6:	7179                	addi	sp,sp,-48
    80208ae8:	f406                	sd	ra,40(sp)
    80208aea:	f022                	sd	s0,32(sp)
    80208aec:	1800                	addi	s0,sp,48
    80208aee:	87aa                	mv	a5,a0
    80208af0:	872e                	mv	a4,a1
    80208af2:	fcf42e23          	sw	a5,-36(s0)
    80208af6:	87ba                	mv	a5,a4
    80208af8:	fcf42c23          	sw	a5,-40(s0)
  b = bget(dev, blockno);
    80208afc:	fd842703          	lw	a4,-40(s0)
    80208b00:	fdc42783          	lw	a5,-36(s0)
    80208b04:	85ba                	mv	a1,a4
    80208b06:	853e                	mv	a0,a5
    80208b08:	00000097          	auipc	ra,0x0
    80208b0c:	e92080e7          	jalr	-366(ra) # 8020899a <bget>
    80208b10:	fea43423          	sd	a0,-24(s0)
  if(!b->valid) {
    80208b14:	fe843783          	ld	a5,-24(s0)
    80208b18:	439c                	lw	a5,0(a5)
    80208b1a:	ef81                	bnez	a5,80208b32 <bread+0x4c>
    virtio_disk_rw(b, 0);
    80208b1c:	4581                	li	a1,0
    80208b1e:	fe843503          	ld	a0,-24(s0)
    80208b22:	00000097          	auipc	ra,0x0
    80208b26:	8ec080e7          	jalr	-1812(ra) # 8020840e <virtio_disk_rw>
    b->valid = 1;
    80208b2a:	fe843783          	ld	a5,-24(s0)
    80208b2e:	4705                	li	a4,1
    80208b30:	c398                	sw	a4,0(a5)
  return b;
    80208b32:	fe843783          	ld	a5,-24(s0)
}
    80208b36:	853e                	mv	a0,a5
    80208b38:	70a2                	ld	ra,40(sp)
    80208b3a:	7402                	ld	s0,32(sp)
    80208b3c:	6145                	addi	sp,sp,48
    80208b3e:	8082                	ret

0000000080208b40 <bwrite>:
{
    80208b40:	1101                	addi	sp,sp,-32
    80208b42:	ec06                	sd	ra,24(sp)
    80208b44:	e822                	sd	s0,16(sp)
    80208b46:	1000                	addi	s0,sp,32
    80208b48:	fea43423          	sd	a0,-24(s0)
  if(!holdingsleep(&b->lock))
    80208b4c:	fe843783          	ld	a5,-24(s0)
    80208b50:	07e1                	addi	a5,a5,24
    80208b52:	853e                	mv	a0,a5
    80208b54:	00003097          	auipc	ra,0x3
    80208b58:	18c080e7          	jalr	396(ra) # 8020bce0 <holdingsleep>
    80208b5c:	87aa                	mv	a5,a0
    80208b5e:	eb89                	bnez	a5,80208b70 <bwrite+0x30>
    panic("bwrite without lock");
    80208b60:	00025517          	auipc	a0,0x25
    80208b64:	69850513          	addi	a0,a0,1688 # 8022e1f8 <user_test_table+0xe0>
    80208b68:	ffff9097          	auipc	ra,0xffff9
    80208b6c:	c72080e7          	jalr	-910(ra) # 802017da <panic>
  virtio_disk_rw(b, 1);
    80208b70:	4585                	li	a1,1
    80208b72:	fe843503          	ld	a0,-24(s0)
    80208b76:	00000097          	auipc	ra,0x0
    80208b7a:	898080e7          	jalr	-1896(ra) # 8020840e <virtio_disk_rw>
}
    80208b7e:	0001                	nop
    80208b80:	60e2                	ld	ra,24(sp)
    80208b82:	6442                	ld	s0,16(sp)
    80208b84:	6105                	addi	sp,sp,32
    80208b86:	8082                	ret

0000000080208b88 <brelse>:
{
    80208b88:	1101                	addi	sp,sp,-32
    80208b8a:	ec06                	sd	ra,24(sp)
    80208b8c:	e822                	sd	s0,16(sp)
    80208b8e:	1000                	addi	s0,sp,32
    80208b90:	fea43423          	sd	a0,-24(s0)
  if(!holdingsleep(&b->lock))
    80208b94:	fe843783          	ld	a5,-24(s0)
    80208b98:	07e1                	addi	a5,a5,24
    80208b9a:	853e                	mv	a0,a5
    80208b9c:	00003097          	auipc	ra,0x3
    80208ba0:	144080e7          	jalr	324(ra) # 8020bce0 <holdingsleep>
    80208ba4:	87aa                	mv	a5,a0
    80208ba6:	eb89                	bnez	a5,80208bb8 <brelse+0x30>
    panic("brelse without lock");
    80208ba8:	00025517          	auipc	a0,0x25
    80208bac:	66850513          	addi	a0,a0,1640 # 8022e210 <user_test_table+0xf8>
    80208bb0:	ffff9097          	auipc	ra,0xffff9
    80208bb4:	c2a080e7          	jalr	-982(ra) # 802017da <panic>
  releasesleep(&b->lock);
    80208bb8:	fe843783          	ld	a5,-24(s0)
    80208bbc:	07e1                	addi	a5,a5,24
    80208bbe:	853e                	mv	a0,a5
    80208bc0:	00003097          	auipc	ra,0x3
    80208bc4:	0ce080e7          	jalr	206(ra) # 8020bc8e <releasesleep>
  acquire(&bcache.lock); // 加锁
    80208bc8:	0003c517          	auipc	a0,0x3c
    80208bcc:	32850513          	addi	a0,a0,808 # 80244ef0 <bcache+0x85b0>
    80208bd0:	00003097          	auipc	ra,0x3
    80208bd4:	f58080e7          	jalr	-168(ra) # 8020bb28 <acquire>
  b->refcnt--;
    80208bd8:	fe843783          	ld	a5,-24(s0)
    80208bdc:	4b9c                	lw	a5,16(a5)
    80208bde:	37fd                	addiw	a5,a5,-1
    80208be0:	0007871b          	sext.w	a4,a5
    80208be4:	fe843783          	ld	a5,-24(s0)
    80208be8:	cb98                	sw	a4,16(a5)
  if (b->refcnt == 0) {
    80208bea:	fe843783          	ld	a5,-24(s0)
    80208bee:	4b9c                	lw	a5,16(a5)
    80208bf0:	e7b5                	bnez	a5,80208c5c <brelse+0xd4>
    b->next->prev = b->prev;
    80208bf2:	fe843783          	ld	a5,-24(s0)
    80208bf6:	67bc                	ld	a5,72(a5)
    80208bf8:	fe843703          	ld	a4,-24(s0)
    80208bfc:	6338                	ld	a4,64(a4)
    80208bfe:	e3b8                	sd	a4,64(a5)
    b->prev->next = b->next;
    80208c00:	fe843783          	ld	a5,-24(s0)
    80208c04:	63bc                	ld	a5,64(a5)
    80208c06:	fe843703          	ld	a4,-24(s0)
    80208c0a:	6738                	ld	a4,72(a4)
    80208c0c:	e7b8                	sd	a4,72(a5)
    b->next = bcache.head.next;
    80208c0e:	00034717          	auipc	a4,0x34
    80208c12:	d3270713          	addi	a4,a4,-718 # 8023c940 <bcache>
    80208c16:	67a1                	lui	a5,0x8
    80208c18:	97ba                	add	a5,a5,a4
    80208c1a:	1a87b703          	ld	a4,424(a5) # 81a8 <_entry-0x801f7e58>
    80208c1e:	fe843783          	ld	a5,-24(s0)
    80208c22:	e7b8                	sd	a4,72(a5)
    b->prev = &bcache.head;
    80208c24:	fe843783          	ld	a5,-24(s0)
    80208c28:	0003c717          	auipc	a4,0x3c
    80208c2c:	e7870713          	addi	a4,a4,-392 # 80244aa0 <bcache+0x8160>
    80208c30:	e3b8                	sd	a4,64(a5)
    bcache.head.next->prev = b;
    80208c32:	00034717          	auipc	a4,0x34
    80208c36:	d0e70713          	addi	a4,a4,-754 # 8023c940 <bcache>
    80208c3a:	67a1                	lui	a5,0x8
    80208c3c:	97ba                	add	a5,a5,a4
    80208c3e:	1a87b783          	ld	a5,424(a5) # 81a8 <_entry-0x801f7e58>
    80208c42:	fe843703          	ld	a4,-24(s0)
    80208c46:	e3b8                	sd	a4,64(a5)
    bcache.head.next = b;
    80208c48:	00034717          	auipc	a4,0x34
    80208c4c:	cf870713          	addi	a4,a4,-776 # 8023c940 <bcache>
    80208c50:	67a1                	lui	a5,0x8
    80208c52:	97ba                	add	a5,a5,a4
    80208c54:	fe843703          	ld	a4,-24(s0)
    80208c58:	1ae7b423          	sd	a4,424(a5) # 81a8 <_entry-0x801f7e58>
  release(&bcache.lock); // 解锁;
    80208c5c:	0003c517          	auipc	a0,0x3c
    80208c60:	29450513          	addi	a0,a0,660 # 80244ef0 <bcache+0x85b0>
    80208c64:	00003097          	auipc	ra,0x3
    80208c68:	f10080e7          	jalr	-240(ra) # 8020bb74 <release>
}
    80208c6c:	0001                	nop
    80208c6e:	60e2                	ld	ra,24(sp)
    80208c70:	6442                	ld	s0,16(sp)
    80208c72:	6105                	addi	sp,sp,32
    80208c74:	8082                	ret

0000000080208c76 <bpin>:
bpin(struct buf *b) {
    80208c76:	1101                	addi	sp,sp,-32
    80208c78:	ec06                	sd	ra,24(sp)
    80208c7a:	e822                	sd	s0,16(sp)
    80208c7c:	1000                	addi	s0,sp,32
    80208c7e:	fea43423          	sd	a0,-24(s0)
  acquire(&bcache.lock);
    80208c82:	0003c517          	auipc	a0,0x3c
    80208c86:	26e50513          	addi	a0,a0,622 # 80244ef0 <bcache+0x85b0>
    80208c8a:	00003097          	auipc	ra,0x3
    80208c8e:	e9e080e7          	jalr	-354(ra) # 8020bb28 <acquire>
  b->refcnt++;
    80208c92:	fe843783          	ld	a5,-24(s0)
    80208c96:	4b9c                	lw	a5,16(a5)
    80208c98:	2785                	addiw	a5,a5,1
    80208c9a:	0007871b          	sext.w	a4,a5
    80208c9e:	fe843783          	ld	a5,-24(s0)
    80208ca2:	cb98                	sw	a4,16(a5)
  release(&bcache.lock);
    80208ca4:	0003c517          	auipc	a0,0x3c
    80208ca8:	24c50513          	addi	a0,a0,588 # 80244ef0 <bcache+0x85b0>
    80208cac:	00003097          	auipc	ra,0x3
    80208cb0:	ec8080e7          	jalr	-312(ra) # 8020bb74 <release>
}
    80208cb4:	0001                	nop
    80208cb6:	60e2                	ld	ra,24(sp)
    80208cb8:	6442                	ld	s0,16(sp)
    80208cba:	6105                	addi	sp,sp,32
    80208cbc:	8082                	ret

0000000080208cbe <bunpin>:
bunpin(struct buf *b) {
    80208cbe:	1101                	addi	sp,sp,-32
    80208cc0:	ec06                	sd	ra,24(sp)
    80208cc2:	e822                	sd	s0,16(sp)
    80208cc4:	1000                	addi	s0,sp,32
    80208cc6:	fea43423          	sd	a0,-24(s0)
  acquire(&bcache.lock);
    80208cca:	0003c517          	auipc	a0,0x3c
    80208cce:	22650513          	addi	a0,a0,550 # 80244ef0 <bcache+0x85b0>
    80208cd2:	00003097          	auipc	ra,0x3
    80208cd6:	e56080e7          	jalr	-426(ra) # 8020bb28 <acquire>
  b->refcnt--;
    80208cda:	fe843783          	ld	a5,-24(s0)
    80208cde:	4b9c                	lw	a5,16(a5)
    80208ce0:	37fd                	addiw	a5,a5,-1
    80208ce2:	0007871b          	sext.w	a4,a5
    80208ce6:	fe843783          	ld	a5,-24(s0)
    80208cea:	cb98                	sw	a4,16(a5)
  release(&bcache.lock);
    80208cec:	0003c517          	auipc	a0,0x3c
    80208cf0:	20450513          	addi	a0,a0,516 # 80244ef0 <bcache+0x85b0>
    80208cf4:	00003097          	auipc	ra,0x3
    80208cf8:	e80080e7          	jalr	-384(ra) # 8020bb74 <release>
}
    80208cfc:	0001                	nop
    80208cfe:	60e2                	ld	ra,24(sp)
    80208d00:	6442                	ld	s0,16(sp)
    80208d02:	6105                	addi	sp,sp,32
    80208d04:	8082                	ret

0000000080208d06 <print_buf_chain>:
void print_buf_chain() {
    80208d06:	1101                	addi	sp,sp,-32
    80208d08:	ec06                	sd	ra,24(sp)
    80208d0a:	e822                	sd	s0,16(sp)
    80208d0c:	1000                	addi	s0,sp,32
  int cnt = 0;
    80208d0e:	fe042223          	sw	zero,-28(s0)
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80208d12:	00034717          	auipc	a4,0x34
    80208d16:	c2e70713          	addi	a4,a4,-978 # 8023c940 <bcache>
    80208d1a:	67a1                	lui	a5,0x8
    80208d1c:	97ba                	add	a5,a5,a4
    80208d1e:	1a87b783          	ld	a5,424(a5) # 81a8 <_entry-0x801f7e58>
    80208d22:	fef43423          	sd	a5,-24(s0)
    80208d26:	a0c9                	j	80208de8 <print_buf_chain+0xe2>
    printf("[bufchain] #%d: buf at %p, next=%p, prev=%p, refcnt=%d, dev=%u, blockno=%u\n",
    80208d28:	fe442583          	lw	a1,-28(s0)
    80208d2c:	0015879b          	addiw	a5,a1,1
    80208d30:	fef42223          	sw	a5,-28(s0)
    80208d34:	fe843783          	ld	a5,-24(s0)
    80208d38:	67b4                	ld	a3,72(a5)
    80208d3a:	fe843783          	ld	a5,-24(s0)
    80208d3e:	63b8                	ld	a4,64(a5)
    80208d40:	fe843783          	ld	a5,-24(s0)
    80208d44:	4b90                	lw	a2,16(a5)
    80208d46:	fe843783          	ld	a5,-24(s0)
    80208d4a:	4788                	lw	a0,8(a5)
    80208d4c:	fe843783          	ld	a5,-24(s0)
    80208d50:	47dc                	lw	a5,12(a5)
    80208d52:	88be                	mv	a7,a5
    80208d54:	882a                	mv	a6,a0
    80208d56:	87b2                	mv	a5,a2
    80208d58:	fe843603          	ld	a2,-24(s0)
    80208d5c:	00025517          	auipc	a0,0x25
    80208d60:	4cc50513          	addi	a0,a0,1228 # 8022e228 <user_test_table+0x110>
    80208d64:	ffff8097          	auipc	ra,0xffff8
    80208d68:	02a080e7          	jalr	42(ra) # 80200d8e <printf>
    assert(b != NULL);
    80208d6c:	fe843783          	ld	a5,-24(s0)
    80208d70:	00f037b3          	snez	a5,a5
    80208d74:	0ff7f793          	zext.b	a5,a5
    80208d78:	2781                	sext.w	a5,a5
    80208d7a:	853e                	mv	a0,a5
    80208d7c:	00000097          	auipc	ra,0x0
    80208d80:	ae6080e7          	jalr	-1306(ra) # 80208862 <assert>
    assert((uintptr_t)b > 0x1000 && (uintptr_t)b < 0xFFFFFFFFFFFF);
    80208d84:	fe843703          	ld	a4,-24(s0)
    80208d88:	6785                	lui	a5,0x1
    80208d8a:	00e7fa63          	bgeu	a5,a4,80208d9e <print_buf_chain+0x98>
    80208d8e:	fe843703          	ld	a4,-24(s0)
    80208d92:	7781                	lui	a5,0xfffe0
    80208d94:	83c1                	srli	a5,a5,0x10
    80208d96:	00e7e463          	bltu	a5,a4,80208d9e <print_buf_chain+0x98>
    80208d9a:	4785                	li	a5,1
    80208d9c:	a011                	j	80208da0 <print_buf_chain+0x9a>
    80208d9e:	4781                	li	a5,0
    80208da0:	853e                	mv	a0,a5
    80208da2:	00000097          	auipc	ra,0x0
    80208da6:	ac0080e7          	jalr	-1344(ra) # 80208862 <assert>
    assert(b->prev != NULL);
    80208daa:	fe843783          	ld	a5,-24(s0)
    80208dae:	63bc                	ld	a5,64(a5)
    80208db0:	00f037b3          	snez	a5,a5
    80208db4:	0ff7f793          	zext.b	a5,a5
    80208db8:	2781                	sext.w	a5,a5
    80208dba:	853e                	mv	a0,a5
    80208dbc:	00000097          	auipc	ra,0x0
    80208dc0:	aa6080e7          	jalr	-1370(ra) # 80208862 <assert>
    assert(b->next != NULL);
    80208dc4:	fe843783          	ld	a5,-24(s0)
    80208dc8:	67bc                	ld	a5,72(a5)
    80208dca:	00f037b3          	snez	a5,a5
    80208dce:	0ff7f793          	zext.b	a5,a5
    80208dd2:	2781                	sext.w	a5,a5
    80208dd4:	853e                	mv	a0,a5
    80208dd6:	00000097          	auipc	ra,0x0
    80208dda:	a8c080e7          	jalr	-1396(ra) # 80208862 <assert>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80208dde:	fe843783          	ld	a5,-24(s0)
    80208de2:	67bc                	ld	a5,72(a5)
    80208de4:	fef43423          	sd	a5,-24(s0)
    80208de8:	fe843703          	ld	a4,-24(s0)
    80208dec:	0003c797          	auipc	a5,0x3c
    80208df0:	cb478793          	addi	a5,a5,-844 # 80244aa0 <bcache+0x8160>
    80208df4:	f2f71ae3          	bne	a4,a5,80208d28 <print_buf_chain+0x22>
    80208df8:	0001                	nop
    80208dfa:	0001                	nop
    80208dfc:	60e2                	ld	ra,24(sp)
    80208dfe:	6442                	ld	s0,16(sp)
    80208e00:	6105                	addi	sp,sp,32
    80208e02:	8082                	ret

0000000080208e04 <initlog>:
struct log log;
static void commit(void); // 在文件开头加上声明

void
initlog(int dev, struct superblock *sb)
{
    80208e04:	1101                	addi	sp,sp,-32
    80208e06:	ec06                	sd	ra,24(sp)
    80208e08:	e822                	sd	s0,16(sp)
    80208e0a:	1000                	addi	s0,sp,32
    80208e0c:	87aa                	mv	a5,a0
    80208e0e:	feb43023          	sd	a1,-32(s0)
    80208e12:	fef42623          	sw	a5,-20(s0)
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");
initlock(&log.lock, "log");
    80208e16:	00027597          	auipc	a1,0x27
    80208e1a:	51258593          	addi	a1,a1,1298 # 80230328 <user_test_table+0x78>
    80208e1e:	0003c517          	auipc	a0,0x3c
    80208e22:	0e250513          	addi	a0,a0,226 # 80244f00 <log>
    80208e26:	00003097          	auipc	ra,0x3
    80208e2a:	cda080e7          	jalr	-806(ra) # 8020bb00 <initlock>
  log.start = sb->logstart;
    80208e2e:	fe043783          	ld	a5,-32(s0)
    80208e32:	4bdc                	lw	a5,20(a5)
    80208e34:	0007871b          	sext.w	a4,a5
    80208e38:	0003c797          	auipc	a5,0x3c
    80208e3c:	0c878793          	addi	a5,a5,200 # 80244f00 <log>
    80208e40:	cb98                	sw	a4,16(a5)
  log.dev = dev;
    80208e42:	0003c797          	auipc	a5,0x3c
    80208e46:	0be78793          	addi	a5,a5,190 # 80244f00 <log>
    80208e4a:	fec42703          	lw	a4,-20(s0)
    80208e4e:	cfd8                	sw	a4,28(a5)
  recover_from_log();
    80208e50:	00000097          	auipc	ra,0x0
    80208e54:	2b6080e7          	jalr	694(ra) # 80209106 <recover_from_log>
  printf("log init done\n");
    80208e58:	00027517          	auipc	a0,0x27
    80208e5c:	4d850513          	addi	a0,a0,1240 # 80230330 <user_test_table+0x80>
    80208e60:	ffff8097          	auipc	ra,0xffff8
    80208e64:	f2e080e7          	jalr	-210(ra) # 80200d8e <printf>
}
    80208e68:	0001                	nop
    80208e6a:	60e2                	ld	ra,24(sp)
    80208e6c:	6442                	ld	s0,16(sp)
    80208e6e:	6105                	addi	sp,sp,32
    80208e70:	8082                	ret

0000000080208e72 <install_trans>:

static void
install_trans(int recovering)
{
    80208e72:	7139                	addi	sp,sp,-64
    80208e74:	fc06                	sd	ra,56(sp)
    80208e76:	f822                	sd	s0,48(sp)
    80208e78:	0080                	addi	s0,sp,64
    80208e7a:	87aa                	mv	a5,a0
    80208e7c:	fcf42623          	sw	a5,-52(s0)
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    80208e80:	fe042623          	sw	zero,-20(s0)
    80208e84:	a209                	j	80208f86 <install_trans+0x114>
    if(recovering) {
    80208e86:	fcc42783          	lw	a5,-52(s0)
    80208e8a:	2781                	sext.w	a5,a5
    80208e8c:	c79d                	beqz	a5,80208eba <install_trans+0x48>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80208e8e:	0003c717          	auipc	a4,0x3c
    80208e92:	07270713          	addi	a4,a4,114 # 80244f00 <log>
    80208e96:	fec42783          	lw	a5,-20(s0)
    80208e9a:	07a1                	addi	a5,a5,8
    80208e9c:	078a                	slli	a5,a5,0x2
    80208e9e:	97ba                	add	a5,a5,a4
    80208ea0:	43d8                	lw	a4,4(a5)
    80208ea2:	fec42783          	lw	a5,-20(s0)
    80208ea6:	863a                	mv	a2,a4
    80208ea8:	85be                	mv	a1,a5
    80208eaa:	00027517          	auipc	a0,0x27
    80208eae:	49650513          	addi	a0,a0,1174 # 80230340 <user_test_table+0x90>
    80208eb2:	ffff8097          	auipc	ra,0xffff8
    80208eb6:	edc080e7          	jalr	-292(ra) # 80200d8e <printf>
    }
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80208eba:	0003c797          	auipc	a5,0x3c
    80208ebe:	04678793          	addi	a5,a5,70 # 80244f00 <log>
    80208ec2:	4fdc                	lw	a5,28(a5)
    80208ec4:	0007871b          	sext.w	a4,a5
    80208ec8:	0003c797          	auipc	a5,0x3c
    80208ecc:	03878793          	addi	a5,a5,56 # 80244f00 <log>
    80208ed0:	4b9c                	lw	a5,16(a5)
    80208ed2:	fec42683          	lw	a3,-20(s0)
    80208ed6:	9fb5                	addw	a5,a5,a3
    80208ed8:	2781                	sext.w	a5,a5
    80208eda:	2785                	addiw	a5,a5,1
    80208edc:	2781                	sext.w	a5,a5
    80208ede:	2781                	sext.w	a5,a5
    80208ee0:	85be                	mv	a1,a5
    80208ee2:	853a                	mv	a0,a4
    80208ee4:	00000097          	auipc	ra,0x0
    80208ee8:	c02080e7          	jalr	-1022(ra) # 80208ae6 <bread>
    80208eec:	fea43023          	sd	a0,-32(s0)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80208ef0:	0003c797          	auipc	a5,0x3c
    80208ef4:	01078793          	addi	a5,a5,16 # 80244f00 <log>
    80208ef8:	4fdc                	lw	a5,28(a5)
    80208efa:	0007869b          	sext.w	a3,a5
    80208efe:	0003c717          	auipc	a4,0x3c
    80208f02:	00270713          	addi	a4,a4,2 # 80244f00 <log>
    80208f06:	fec42783          	lw	a5,-20(s0)
    80208f0a:	07a1                	addi	a5,a5,8
    80208f0c:	078a                	slli	a5,a5,0x2
    80208f0e:	97ba                	add	a5,a5,a4
    80208f10:	43dc                	lw	a5,4(a5)
    80208f12:	2781                	sext.w	a5,a5
    80208f14:	85be                	mv	a1,a5
    80208f16:	8536                	mv	a0,a3
    80208f18:	00000097          	auipc	ra,0x0
    80208f1c:	bce080e7          	jalr	-1074(ra) # 80208ae6 <bread>
    80208f20:	fca43c23          	sd	a0,-40(s0)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80208f24:	fd843783          	ld	a5,-40(s0)
    80208f28:	05078713          	addi	a4,a5,80
    80208f2c:	fe043783          	ld	a5,-32(s0)
    80208f30:	05078793          	addi	a5,a5,80
    80208f34:	40000613          	li	a2,1024
    80208f38:	85be                	mv	a1,a5
    80208f3a:	853a                	mv	a0,a4
    80208f3c:	ffff9097          	auipc	ra,0xffff9
    80208f40:	02c080e7          	jalr	44(ra) # 80201f68 <memmove>
    bwrite(dbuf);  // write dst to disk
    80208f44:	fd843503          	ld	a0,-40(s0)
    80208f48:	00000097          	auipc	ra,0x0
    80208f4c:	bf8080e7          	jalr	-1032(ra) # 80208b40 <bwrite>
    if(recovering == 0)
    80208f50:	fcc42783          	lw	a5,-52(s0)
    80208f54:	2781                	sext.w	a5,a5
    80208f56:	e799                	bnez	a5,80208f64 <install_trans+0xf2>
      bunpin(dbuf);
    80208f58:	fd843503          	ld	a0,-40(s0)
    80208f5c:	00000097          	auipc	ra,0x0
    80208f60:	d62080e7          	jalr	-670(ra) # 80208cbe <bunpin>
    brelse(lbuf);
    80208f64:	fe043503          	ld	a0,-32(s0)
    80208f68:	00000097          	auipc	ra,0x0
    80208f6c:	c20080e7          	jalr	-992(ra) # 80208b88 <brelse>
    brelse(dbuf);
    80208f70:	fd843503          	ld	a0,-40(s0)
    80208f74:	00000097          	auipc	ra,0x0
    80208f78:	c14080e7          	jalr	-1004(ra) # 80208b88 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80208f7c:	fec42783          	lw	a5,-20(s0)
    80208f80:	2785                	addiw	a5,a5,1
    80208f82:	fef42623          	sw	a5,-20(s0)
    80208f86:	0003c797          	auipc	a5,0x3c
    80208f8a:	f7a78793          	addi	a5,a5,-134 # 80244f00 <log>
    80208f8e:	5398                	lw	a4,32(a5)
    80208f90:	fec42783          	lw	a5,-20(s0)
    80208f94:	2781                	sext.w	a5,a5
    80208f96:	eee7c8e3          	blt	a5,a4,80208e86 <install_trans+0x14>
  }
}
    80208f9a:	0001                	nop
    80208f9c:	0001                	nop
    80208f9e:	70e2                	ld	ra,56(sp)
    80208fa0:	7442                	ld	s0,48(sp)
    80208fa2:	6121                	addi	sp,sp,64
    80208fa4:	8082                	ret

0000000080208fa6 <read_head>:
static void
read_head(void)
{
    80208fa6:	7179                	addi	sp,sp,-48
    80208fa8:	f406                	sd	ra,40(sp)
    80208faa:	f022                	sd	s0,32(sp)
    80208fac:	1800                	addi	s0,sp,48
  struct buf *buf = bread(log.dev, log.start);
    80208fae:	0003c797          	auipc	a5,0x3c
    80208fb2:	f5278793          	addi	a5,a5,-174 # 80244f00 <log>
    80208fb6:	4fdc                	lw	a5,28(a5)
    80208fb8:	0007871b          	sext.w	a4,a5
    80208fbc:	0003c797          	auipc	a5,0x3c
    80208fc0:	f4478793          	addi	a5,a5,-188 # 80244f00 <log>
    80208fc4:	4b9c                	lw	a5,16(a5)
    80208fc6:	2781                	sext.w	a5,a5
    80208fc8:	85be                	mv	a1,a5
    80208fca:	853a                	mv	a0,a4
    80208fcc:	00000097          	auipc	ra,0x0
    80208fd0:	b1a080e7          	jalr	-1254(ra) # 80208ae6 <bread>
    80208fd4:	fea43023          	sd	a0,-32(s0)
  struct logheader *lh = (struct logheader *) (buf->data);
    80208fd8:	fe043783          	ld	a5,-32(s0)
    80208fdc:	05078793          	addi	a5,a5,80
    80208fe0:	fcf43c23          	sd	a5,-40(s0)
  int i;
  log.lh.n = lh->n;
    80208fe4:	fd843783          	ld	a5,-40(s0)
    80208fe8:	4398                	lw	a4,0(a5)
    80208fea:	0003c797          	auipc	a5,0x3c
    80208fee:	f1678793          	addi	a5,a5,-234 # 80244f00 <log>
    80208ff2:	d398                	sw	a4,32(a5)
  for (i = 0; i < log.lh.n; i++) {
    80208ff4:	fe042623          	sw	zero,-20(s0)
    80208ff8:	a03d                	j	80209026 <read_head+0x80>
    log.lh.block[i] = lh->block[i];
    80208ffa:	fd843703          	ld	a4,-40(s0)
    80208ffe:	fec42783          	lw	a5,-20(s0)
    80209002:	078a                	slli	a5,a5,0x2
    80209004:	97ba                	add	a5,a5,a4
    80209006:	43d8                	lw	a4,4(a5)
    80209008:	0003c697          	auipc	a3,0x3c
    8020900c:	ef868693          	addi	a3,a3,-264 # 80244f00 <log>
    80209010:	fec42783          	lw	a5,-20(s0)
    80209014:	07a1                	addi	a5,a5,8
    80209016:	078a                	slli	a5,a5,0x2
    80209018:	97b6                	add	a5,a5,a3
    8020901a:	c3d8                	sw	a4,4(a5)
  for (i = 0; i < log.lh.n; i++) {
    8020901c:	fec42783          	lw	a5,-20(s0)
    80209020:	2785                	addiw	a5,a5,1
    80209022:	fef42623          	sw	a5,-20(s0)
    80209026:	0003c797          	auipc	a5,0x3c
    8020902a:	eda78793          	addi	a5,a5,-294 # 80244f00 <log>
    8020902e:	5398                	lw	a4,32(a5)
    80209030:	fec42783          	lw	a5,-20(s0)
    80209034:	2781                	sext.w	a5,a5
    80209036:	fce7c2e3          	blt	a5,a4,80208ffa <read_head+0x54>
  }
  brelse(buf);
    8020903a:	fe043503          	ld	a0,-32(s0)
    8020903e:	00000097          	auipc	ra,0x0
    80209042:	b4a080e7          	jalr	-1206(ra) # 80208b88 <brelse>
}
    80209046:	0001                	nop
    80209048:	70a2                	ld	ra,40(sp)
    8020904a:	7402                	ld	s0,32(sp)
    8020904c:	6145                	addi	sp,sp,48
    8020904e:	8082                	ret

0000000080209050 <write_head>:

static void
write_head(void)
{
    80209050:	7179                	addi	sp,sp,-48
    80209052:	f406                	sd	ra,40(sp)
    80209054:	f022                	sd	s0,32(sp)
    80209056:	1800                	addi	s0,sp,48
  struct buf *buf = bread(log.dev, log.start);
    80209058:	0003c797          	auipc	a5,0x3c
    8020905c:	ea878793          	addi	a5,a5,-344 # 80244f00 <log>
    80209060:	4fdc                	lw	a5,28(a5)
    80209062:	0007871b          	sext.w	a4,a5
    80209066:	0003c797          	auipc	a5,0x3c
    8020906a:	e9a78793          	addi	a5,a5,-358 # 80244f00 <log>
    8020906e:	4b9c                	lw	a5,16(a5)
    80209070:	2781                	sext.w	a5,a5
    80209072:	85be                	mv	a1,a5
    80209074:	853a                	mv	a0,a4
    80209076:	00000097          	auipc	ra,0x0
    8020907a:	a70080e7          	jalr	-1424(ra) # 80208ae6 <bread>
    8020907e:	fea43023          	sd	a0,-32(s0)
  struct logheader *hb = (struct logheader *) (buf->data);
    80209082:	fe043783          	ld	a5,-32(s0)
    80209086:	05078793          	addi	a5,a5,80
    8020908a:	fcf43c23          	sd	a5,-40(s0)
  int i;
  hb->n = log.lh.n;
    8020908e:	0003c797          	auipc	a5,0x3c
    80209092:	e7278793          	addi	a5,a5,-398 # 80244f00 <log>
    80209096:	5398                	lw	a4,32(a5)
    80209098:	fd843783          	ld	a5,-40(s0)
    8020909c:	c398                	sw	a4,0(a5)
  for (i = 0; i < log.lh.n; i++) {
    8020909e:	fe042623          	sw	zero,-20(s0)
    802090a2:	a03d                	j	802090d0 <write_head+0x80>
    hb->block[i] = log.lh.block[i];
    802090a4:	0003c717          	auipc	a4,0x3c
    802090a8:	e5c70713          	addi	a4,a4,-420 # 80244f00 <log>
    802090ac:	fec42783          	lw	a5,-20(s0)
    802090b0:	07a1                	addi	a5,a5,8
    802090b2:	078a                	slli	a5,a5,0x2
    802090b4:	97ba                	add	a5,a5,a4
    802090b6:	43d8                	lw	a4,4(a5)
    802090b8:	fd843683          	ld	a3,-40(s0)
    802090bc:	fec42783          	lw	a5,-20(s0)
    802090c0:	078a                	slli	a5,a5,0x2
    802090c2:	97b6                	add	a5,a5,a3
    802090c4:	c3d8                	sw	a4,4(a5)
  for (i = 0; i < log.lh.n; i++) {
    802090c6:	fec42783          	lw	a5,-20(s0)
    802090ca:	2785                	addiw	a5,a5,1
    802090cc:	fef42623          	sw	a5,-20(s0)
    802090d0:	0003c797          	auipc	a5,0x3c
    802090d4:	e3078793          	addi	a5,a5,-464 # 80244f00 <log>
    802090d8:	5398                	lw	a4,32(a5)
    802090da:	fec42783          	lw	a5,-20(s0)
    802090de:	2781                	sext.w	a5,a5
    802090e0:	fce7c2e3          	blt	a5,a4,802090a4 <write_head+0x54>
  }
  bwrite(buf);
    802090e4:	fe043503          	ld	a0,-32(s0)
    802090e8:	00000097          	auipc	ra,0x0
    802090ec:	a58080e7          	jalr	-1448(ra) # 80208b40 <bwrite>
  brelse(buf);
    802090f0:	fe043503          	ld	a0,-32(s0)
    802090f4:	00000097          	auipc	ra,0x0
    802090f8:	a94080e7          	jalr	-1388(ra) # 80208b88 <brelse>
}
    802090fc:	0001                	nop
    802090fe:	70a2                	ld	ra,40(sp)
    80209100:	7402                	ld	s0,32(sp)
    80209102:	6145                	addi	sp,sp,48
    80209104:	8082                	ret

0000000080209106 <recover_from_log>:

void
recover_from_log(void)
{
    80209106:	1141                	addi	sp,sp,-16
    80209108:	e406                	sd	ra,8(sp)
    8020910a:	e022                	sd	s0,0(sp)
    8020910c:	0800                	addi	s0,sp,16
  read_head();
    8020910e:	00000097          	auipc	ra,0x0
    80209112:	e98080e7          	jalr	-360(ra) # 80208fa6 <read_head>
  install_trans(1); // if committed, copy from log to disk
    80209116:	4505                	li	a0,1
    80209118:	00000097          	auipc	ra,0x0
    8020911c:	d5a080e7          	jalr	-678(ra) # 80208e72 <install_trans>
  log.lh.n = 0;
    80209120:	0003c797          	auipc	a5,0x3c
    80209124:	de078793          	addi	a5,a5,-544 # 80244f00 <log>
    80209128:	0207a023          	sw	zero,32(a5)
  write_head(); // clear the log
    8020912c:	00000097          	auipc	ra,0x0
    80209130:	f24080e7          	jalr	-220(ra) # 80209050 <write_head>
}
    80209134:	0001                	nop
    80209136:	60a2                	ld	ra,8(sp)
    80209138:	6402                	ld	s0,0(sp)
    8020913a:	0141                	addi	sp,sp,16
    8020913c:	8082                	ret

000000008020913e <begin_op>:
void
begin_op(void)
{
    8020913e:	1141                	addi	sp,sp,-16
    80209140:	e406                	sd	ra,8(sp)
    80209142:	e022                	sd	s0,0(sp)
    80209144:	0800                	addi	s0,sp,16
  acquire(&log.lock);
    80209146:	0003c517          	auipc	a0,0x3c
    8020914a:	dba50513          	addi	a0,a0,-582 # 80244f00 <log>
    8020914e:	00003097          	auipc	ra,0x3
    80209152:	9da080e7          	jalr	-1574(ra) # 8020bb28 <acquire>
  printf("[begin_op] outstanding(before)=%d\n", log.outstanding);
    80209156:	0003c797          	auipc	a5,0x3c
    8020915a:	daa78793          	addi	a5,a5,-598 # 80244f00 <log>
    8020915e:	4bdc                	lw	a5,20(a5)
    80209160:	85be                	mv	a1,a5
    80209162:	00027517          	auipc	a0,0x27
    80209166:	1fe50513          	addi	a0,a0,510 # 80230360 <user_test_table+0xb0>
    8020916a:	ffff8097          	auipc	ra,0xffff8
    8020916e:	c24080e7          	jalr	-988(ra) # 80200d8e <printf>
  while(1){
    if(log.committing){
    80209172:	0003c797          	auipc	a5,0x3c
    80209176:	d8e78793          	addi	a5,a5,-626 # 80244f00 <log>
    8020917a:	4f9c                	lw	a5,24(a5)
    8020917c:	cf91                	beqz	a5,80209198 <begin_op+0x5a>
      sleep(&log, &log.lock);
    8020917e:	0003c597          	auipc	a1,0x3c
    80209182:	d8258593          	addi	a1,a1,-638 # 80244f00 <log>
    80209186:	0003c517          	auipc	a0,0x3c
    8020918a:	d7a50513          	addi	a0,a0,-646 # 80244f00 <log>
    8020918e:	ffffd097          	auipc	ra,0xffffd
    80209192:	bd4080e7          	jalr	-1068(ra) # 80205d62 <sleep>
    80209196:	bff1                	j	80209172 <begin_op+0x34>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80209198:	0003c797          	auipc	a5,0x3c
    8020919c:	d6878793          	addi	a5,a5,-664 # 80244f00 <log>
    802091a0:	5398                	lw	a4,32(a5)
    802091a2:	0003c797          	auipc	a5,0x3c
    802091a6:	d5e78793          	addi	a5,a5,-674 # 80244f00 <log>
    802091aa:	4bdc                	lw	a5,20(a5)
    802091ac:	2785                	addiw	a5,a5,1
    802091ae:	2781                	sext.w	a5,a5
    802091b0:	86be                	mv	a3,a5
    802091b2:	87b6                	mv	a5,a3
    802091b4:	0027979b          	slliw	a5,a5,0x2
    802091b8:	9fb5                	addw	a5,a5,a3
    802091ba:	0017979b          	slliw	a5,a5,0x1
    802091be:	2781                	sext.w	a5,a5
    802091c0:	9fb9                	addw	a5,a5,a4
    802091c2:	2781                	sext.w	a5,a5
    802091c4:	873e                	mv	a4,a5
    802091c6:	47f9                	li	a5,30
    802091c8:	00e7df63          	bge	a5,a4,802091e6 <begin_op+0xa8>
      sleep(&log, &log.lock);
    802091cc:	0003c597          	auipc	a1,0x3c
    802091d0:	d3458593          	addi	a1,a1,-716 # 80244f00 <log>
    802091d4:	0003c517          	auipc	a0,0x3c
    802091d8:	d2c50513          	addi	a0,a0,-724 # 80244f00 <log>
    802091dc:	ffffd097          	auipc	ra,0xffffd
    802091e0:	b86080e7          	jalr	-1146(ra) # 80205d62 <sleep>
    802091e4:	b779                	j	80209172 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    802091e6:	0003c797          	auipc	a5,0x3c
    802091ea:	d1a78793          	addi	a5,a5,-742 # 80244f00 <log>
    802091ee:	4bdc                	lw	a5,20(a5)
    802091f0:	2785                	addiw	a5,a5,1
    802091f2:	0007871b          	sext.w	a4,a5
    802091f6:	0003c797          	auipc	a5,0x3c
    802091fa:	d0a78793          	addi	a5,a5,-758 # 80244f00 <log>
    802091fe:	cbd8                	sw	a4,20(a5)
      release(&log.lock);
    80209200:	0003c517          	auipc	a0,0x3c
    80209204:	d0050513          	addi	a0,a0,-768 # 80244f00 <log>
    80209208:	00003097          	auipc	ra,0x3
    8020920c:	96c080e7          	jalr	-1684(ra) # 8020bb74 <release>
      break;
    80209210:	0001                	nop
    }
  }
}
    80209212:	0001                	nop
    80209214:	60a2                	ld	ra,8(sp)
    80209216:	6402                	ld	s0,0(sp)
    80209218:	0141                	addi	sp,sp,16
    8020921a:	8082                	ret

000000008020921c <end_op>:

void
end_op(void)
{
    8020921c:	1101                	addi	sp,sp,-32
    8020921e:	ec06                	sd	ra,24(sp)
    80209220:	e822                	sd	s0,16(sp)
    80209222:	1000                	addi	s0,sp,32
  int do_commit = 0;
    80209224:	fe042623          	sw	zero,-20(s0)

  acquire(&log.lock);
    80209228:	0003c517          	auipc	a0,0x3c
    8020922c:	cd850513          	addi	a0,a0,-808 # 80244f00 <log>
    80209230:	00003097          	auipc	ra,0x3
    80209234:	8f8080e7          	jalr	-1800(ra) # 8020bb28 <acquire>
  printf("[end_op] outstanding(before)=%d\n", log.outstanding);
    80209238:	0003c797          	auipc	a5,0x3c
    8020923c:	cc878793          	addi	a5,a5,-824 # 80244f00 <log>
    80209240:	4bdc                	lw	a5,20(a5)
    80209242:	85be                	mv	a1,a5
    80209244:	00027517          	auipc	a0,0x27
    80209248:	14450513          	addi	a0,a0,324 # 80230388 <user_test_table+0xd8>
    8020924c:	ffff8097          	auipc	ra,0xffff8
    80209250:	b42080e7          	jalr	-1214(ra) # 80200d8e <printf>
  log.outstanding -= 1;
    80209254:	0003c797          	auipc	a5,0x3c
    80209258:	cac78793          	addi	a5,a5,-852 # 80244f00 <log>
    8020925c:	4bdc                	lw	a5,20(a5)
    8020925e:	37fd                	addiw	a5,a5,-1
    80209260:	0007871b          	sext.w	a4,a5
    80209264:	0003c797          	auipc	a5,0x3c
    80209268:	c9c78793          	addi	a5,a5,-868 # 80244f00 <log>
    8020926c:	cbd8                	sw	a4,20(a5)
  if(log.committing)
    8020926e:	0003c797          	auipc	a5,0x3c
    80209272:	c9278793          	addi	a5,a5,-878 # 80244f00 <log>
    80209276:	4f9c                	lw	a5,24(a5)
    80209278:	cb89                	beqz	a5,8020928a <end_op+0x6e>
    panic("log.committing");
    8020927a:	00027517          	auipc	a0,0x27
    8020927e:	13650513          	addi	a0,a0,310 # 802303b0 <user_test_table+0x100>
    80209282:	ffff8097          	auipc	ra,0xffff8
    80209286:	558080e7          	jalr	1368(ra) # 802017da <panic>
  if(log.outstanding == 0){
    8020928a:	0003c797          	auipc	a5,0x3c
    8020928e:	c7678793          	addi	a5,a5,-906 # 80244f00 <log>
    80209292:	4bdc                	lw	a5,20(a5)
    80209294:	eb99                	bnez	a5,802092aa <end_op+0x8e>
    do_commit = 1;
    80209296:	4785                	li	a5,1
    80209298:	fef42623          	sw	a5,-20(s0)
    log.committing = 1;
    8020929c:	0003c797          	auipc	a5,0x3c
    802092a0:	c6478793          	addi	a5,a5,-924 # 80244f00 <log>
    802092a4:	4705                	li	a4,1
    802092a6:	cf98                	sw	a4,24(a5)
    802092a8:	a809                	j	802092ba <end_op+0x9e>
  } else {
    wakeup(&log);
    802092aa:	0003c517          	auipc	a0,0x3c
    802092ae:	c5650513          	addi	a0,a0,-938 # 80244f00 <log>
    802092b2:	ffffd097          	auipc	ra,0xffffd
    802092b6:	b68080e7          	jalr	-1176(ra) # 80205e1a <wakeup>
  }
  release(&log.lock);
    802092ba:	0003c517          	auipc	a0,0x3c
    802092be:	c4650513          	addi	a0,a0,-954 # 80244f00 <log>
    802092c2:	00003097          	auipc	ra,0x3
    802092c6:	8b2080e7          	jalr	-1870(ra) # 8020bb74 <release>

  if(do_commit){
    802092ca:	fec42783          	lw	a5,-20(s0)
    802092ce:	2781                	sext.w	a5,a5
    802092d0:	c3b9                	beqz	a5,80209316 <end_op+0xfa>
    commit();
    802092d2:	00000097          	auipc	ra,0x0
    802092d6:	134080e7          	jalr	308(ra) # 80209406 <commit>
    acquire(&log.lock);
    802092da:	0003c517          	auipc	a0,0x3c
    802092de:	c2650513          	addi	a0,a0,-986 # 80244f00 <log>
    802092e2:	00003097          	auipc	ra,0x3
    802092e6:	846080e7          	jalr	-1978(ra) # 8020bb28 <acquire>
    log.committing = 0;
    802092ea:	0003c797          	auipc	a5,0x3c
    802092ee:	c1678793          	addi	a5,a5,-1002 # 80244f00 <log>
    802092f2:	0007ac23          	sw	zero,24(a5)
    wakeup(&log);
    802092f6:	0003c517          	auipc	a0,0x3c
    802092fa:	c0a50513          	addi	a0,a0,-1014 # 80244f00 <log>
    802092fe:	ffffd097          	auipc	ra,0xffffd
    80209302:	b1c080e7          	jalr	-1252(ra) # 80205e1a <wakeup>
    release(&log.lock);
    80209306:	0003c517          	auipc	a0,0x3c
    8020930a:	bfa50513          	addi	a0,a0,-1030 # 80244f00 <log>
    8020930e:	00003097          	auipc	ra,0x3
    80209312:	866080e7          	jalr	-1946(ra) # 8020bb74 <release>
  }
}
    80209316:	0001                	nop
    80209318:	60e2                	ld	ra,24(sp)
    8020931a:	6442                	ld	s0,16(sp)
    8020931c:	6105                	addi	sp,sp,32
    8020931e:	8082                	ret

0000000080209320 <write_log>:
static void
write_log(void)
{
    80209320:	7179                	addi	sp,sp,-48
    80209322:	f406                	sd	ra,40(sp)
    80209324:	f022                	sd	s0,32(sp)
    80209326:	1800                	addi	s0,sp,48
  int tail;
  for (tail = 0; tail < log.lh.n; tail++) {
    80209328:	fe042623          	sw	zero,-20(s0)
    8020932c:	a86d                	j	802093e6 <write_log+0xc6>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8020932e:	0003c797          	auipc	a5,0x3c
    80209332:	bd278793          	addi	a5,a5,-1070 # 80244f00 <log>
    80209336:	4fdc                	lw	a5,28(a5)
    80209338:	0007871b          	sext.w	a4,a5
    8020933c:	0003c797          	auipc	a5,0x3c
    80209340:	bc478793          	addi	a5,a5,-1084 # 80244f00 <log>
    80209344:	4b9c                	lw	a5,16(a5)
    80209346:	fec42683          	lw	a3,-20(s0)
    8020934a:	9fb5                	addw	a5,a5,a3
    8020934c:	2781                	sext.w	a5,a5
    8020934e:	2785                	addiw	a5,a5,1
    80209350:	2781                	sext.w	a5,a5
    80209352:	2781                	sext.w	a5,a5
    80209354:	85be                	mv	a1,a5
    80209356:	853a                	mv	a0,a4
    80209358:	fffff097          	auipc	ra,0xfffff
    8020935c:	78e080e7          	jalr	1934(ra) # 80208ae6 <bread>
    80209360:	fea43023          	sd	a0,-32(s0)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80209364:	0003c797          	auipc	a5,0x3c
    80209368:	b9c78793          	addi	a5,a5,-1124 # 80244f00 <log>
    8020936c:	4fdc                	lw	a5,28(a5)
    8020936e:	0007869b          	sext.w	a3,a5
    80209372:	0003c717          	auipc	a4,0x3c
    80209376:	b8e70713          	addi	a4,a4,-1138 # 80244f00 <log>
    8020937a:	fec42783          	lw	a5,-20(s0)
    8020937e:	07a1                	addi	a5,a5,8
    80209380:	078a                	slli	a5,a5,0x2
    80209382:	97ba                	add	a5,a5,a4
    80209384:	43dc                	lw	a5,4(a5)
    80209386:	2781                	sext.w	a5,a5
    80209388:	85be                	mv	a1,a5
    8020938a:	8536                	mv	a0,a3
    8020938c:	fffff097          	auipc	ra,0xfffff
    80209390:	75a080e7          	jalr	1882(ra) # 80208ae6 <bread>
    80209394:	fca43c23          	sd	a0,-40(s0)
    memmove(to->data, from->data, BSIZE);
    80209398:	fe043783          	ld	a5,-32(s0)
    8020939c:	05078713          	addi	a4,a5,80
    802093a0:	fd843783          	ld	a5,-40(s0)
    802093a4:	05078793          	addi	a5,a5,80
    802093a8:	40000613          	li	a2,1024
    802093ac:	85be                	mv	a1,a5
    802093ae:	853a                	mv	a0,a4
    802093b0:	ffff9097          	auipc	ra,0xffff9
    802093b4:	bb8080e7          	jalr	-1096(ra) # 80201f68 <memmove>
    bwrite(to);  // write the log
    802093b8:	fe043503          	ld	a0,-32(s0)
    802093bc:	fffff097          	auipc	ra,0xfffff
    802093c0:	784080e7          	jalr	1924(ra) # 80208b40 <bwrite>
    brelse(from);
    802093c4:	fd843503          	ld	a0,-40(s0)
    802093c8:	fffff097          	auipc	ra,0xfffff
    802093cc:	7c0080e7          	jalr	1984(ra) # 80208b88 <brelse>
    brelse(to);
    802093d0:	fe043503          	ld	a0,-32(s0)
    802093d4:	fffff097          	auipc	ra,0xfffff
    802093d8:	7b4080e7          	jalr	1972(ra) # 80208b88 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    802093dc:	fec42783          	lw	a5,-20(s0)
    802093e0:	2785                	addiw	a5,a5,1
    802093e2:	fef42623          	sw	a5,-20(s0)
    802093e6:	0003c797          	auipc	a5,0x3c
    802093ea:	b1a78793          	addi	a5,a5,-1254 # 80244f00 <log>
    802093ee:	5398                	lw	a4,32(a5)
    802093f0:	fec42783          	lw	a5,-20(s0)
    802093f4:	2781                	sext.w	a5,a5
    802093f6:	f2e7cce3          	blt	a5,a4,8020932e <write_log+0xe>
  }
}
    802093fa:	0001                	nop
    802093fc:	0001                	nop
    802093fe:	70a2                	ld	ra,40(sp)
    80209400:	7402                	ld	s0,32(sp)
    80209402:	6145                	addi	sp,sp,48
    80209404:	8082                	ret

0000000080209406 <commit>:
static void
commit()
{
    80209406:	1141                	addi	sp,sp,-16
    80209408:	e406                	sd	ra,8(sp)
    8020940a:	e022                	sd	s0,0(sp)
    8020940c:	0800                	addi	s0,sp,16
  if (log.lh.n > 0) {
    8020940e:	0003c797          	auipc	a5,0x3c
    80209412:	af278793          	addi	a5,a5,-1294 # 80244f00 <log>
    80209416:	539c                	lw	a5,32(a5)
    80209418:	02f05963          	blez	a5,8020944a <commit+0x44>
    write_log();     // Write modified blocks from cache to log
    8020941c:	00000097          	auipc	ra,0x0
    80209420:	f04080e7          	jalr	-252(ra) # 80209320 <write_log>
    write_head();    // Write header to disk -- the real commit
    80209424:	00000097          	auipc	ra,0x0
    80209428:	c2c080e7          	jalr	-980(ra) # 80209050 <write_head>
    install_trans(0); // Now install writes to home locations
    8020942c:	4501                	li	a0,0
    8020942e:	00000097          	auipc	ra,0x0
    80209432:	a44080e7          	jalr	-1468(ra) # 80208e72 <install_trans>
    log.lh.n = 0;
    80209436:	0003c797          	auipc	a5,0x3c
    8020943a:	aca78793          	addi	a5,a5,-1334 # 80244f00 <log>
    8020943e:	0207a023          	sw	zero,32(a5)
    write_head();    // Erase the transaction from the log
    80209442:	00000097          	auipc	ra,0x0
    80209446:	c0e080e7          	jalr	-1010(ra) # 80209050 <write_head>
  }
}
    8020944a:	0001                	nop
    8020944c:	60a2                	ld	ra,8(sp)
    8020944e:	6402                	ld	s0,0(sp)
    80209450:	0141                	addi	sp,sp,16
    80209452:	8082                	ret

0000000080209454 <log_write>:
void
log_write(struct buf *b)
{
    80209454:	7179                	addi	sp,sp,-48
    80209456:	f406                	sd	ra,40(sp)
    80209458:	f022                	sd	s0,32(sp)
    8020945a:	1800                	addi	s0,sp,48
    8020945c:	fca43c23          	sd	a0,-40(s0)
  int i;

  acquire(&log.lock);
    80209460:	0003c517          	auipc	a0,0x3c
    80209464:	aa050513          	addi	a0,a0,-1376 # 80244f00 <log>
    80209468:	00002097          	auipc	ra,0x2
    8020946c:	6c0080e7          	jalr	1728(ra) # 8020bb28 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80209470:	0003c797          	auipc	a5,0x3c
    80209474:	a9078793          	addi	a5,a5,-1392 # 80244f00 <log>
    80209478:	539c                	lw	a5,32(a5)
    8020947a:	873e                	mv	a4,a5
    8020947c:	47f5                	li	a5,29
    8020947e:	00e7da63          	bge	a5,a4,80209492 <log_write+0x3e>
    panic("too big a transaction");
    80209482:	00027517          	auipc	a0,0x27
    80209486:	f3e50513          	addi	a0,a0,-194 # 802303c0 <user_test_table+0x110>
    8020948a:	ffff8097          	auipc	ra,0xffff8
    8020948e:	350080e7          	jalr	848(ra) # 802017da <panic>
  if (log.outstanding < 1)
    80209492:	0003c797          	auipc	a5,0x3c
    80209496:	a6e78793          	addi	a5,a5,-1426 # 80244f00 <log>
    8020949a:	4bdc                	lw	a5,20(a5)
    8020949c:	00f04a63          	bgtz	a5,802094b0 <log_write+0x5c>
    panic("log_write outside of trans");
    802094a0:	00027517          	auipc	a0,0x27
    802094a4:	f3850513          	addi	a0,a0,-200 # 802303d8 <user_test_table+0x128>
    802094a8:	ffff8097          	auipc	ra,0xffff8
    802094ac:	332080e7          	jalr	818(ra) # 802017da <panic>

  for (i = 0; i < log.lh.n; i++) {
    802094b0:	fe042623          	sw	zero,-20(s0)
    802094b4:	a03d                	j	802094e2 <log_write+0x8e>
    if (log.lh.block[i] == b->blockno)   // log absorption
    802094b6:	0003c717          	auipc	a4,0x3c
    802094ba:	a4a70713          	addi	a4,a4,-1462 # 80244f00 <log>
    802094be:	fec42783          	lw	a5,-20(s0)
    802094c2:	07a1                	addi	a5,a5,8
    802094c4:	078a                	slli	a5,a5,0x2
    802094c6:	97ba                	add	a5,a5,a4
    802094c8:	43dc                	lw	a5,4(a5)
    802094ca:	0007871b          	sext.w	a4,a5
    802094ce:	fd843783          	ld	a5,-40(s0)
    802094d2:	47dc                	lw	a5,12(a5)
    802094d4:	02f70263          	beq	a4,a5,802094f8 <log_write+0xa4>
  for (i = 0; i < log.lh.n; i++) {
    802094d8:	fec42783          	lw	a5,-20(s0)
    802094dc:	2785                	addiw	a5,a5,1
    802094de:	fef42623          	sw	a5,-20(s0)
    802094e2:	0003c797          	auipc	a5,0x3c
    802094e6:	a1e78793          	addi	a5,a5,-1506 # 80244f00 <log>
    802094ea:	5398                	lw	a4,32(a5)
    802094ec:	fec42783          	lw	a5,-20(s0)
    802094f0:	2781                	sext.w	a5,a5
    802094f2:	fce7c2e3          	blt	a5,a4,802094b6 <log_write+0x62>
    802094f6:	a011                	j	802094fa <log_write+0xa6>
      break;
    802094f8:	0001                	nop
  }
  log.lh.block[i] = b->blockno;
    802094fa:	fd843783          	ld	a5,-40(s0)
    802094fe:	47dc                	lw	a5,12(a5)
    80209500:	0007871b          	sext.w	a4,a5
    80209504:	0003c697          	auipc	a3,0x3c
    80209508:	9fc68693          	addi	a3,a3,-1540 # 80244f00 <log>
    8020950c:	fec42783          	lw	a5,-20(s0)
    80209510:	07a1                	addi	a5,a5,8
    80209512:	078a                	slli	a5,a5,0x2
    80209514:	97b6                	add	a5,a5,a3
    80209516:	c3d8                	sw	a4,4(a5)
  if (i == log.lh.n) {  // Add new block to log?
    80209518:	0003c797          	auipc	a5,0x3c
    8020951c:	9e878793          	addi	a5,a5,-1560 # 80244f00 <log>
    80209520:	5398                	lw	a4,32(a5)
    80209522:	fec42783          	lw	a5,-20(s0)
    80209526:	2781                	sext.w	a5,a5
    80209528:	02e79563          	bne	a5,a4,80209552 <log_write+0xfe>
    bpin(b);
    8020952c:	fd843503          	ld	a0,-40(s0)
    80209530:	fffff097          	auipc	ra,0xfffff
    80209534:	746080e7          	jalr	1862(ra) # 80208c76 <bpin>
    log.lh.n++;
    80209538:	0003c797          	auipc	a5,0x3c
    8020953c:	9c878793          	addi	a5,a5,-1592 # 80244f00 <log>
    80209540:	539c                	lw	a5,32(a5)
    80209542:	2785                	addiw	a5,a5,1
    80209544:	0007871b          	sext.w	a4,a5
    80209548:	0003c797          	auipc	a5,0x3c
    8020954c:	9b878793          	addi	a5,a5,-1608 # 80244f00 <log>
    80209550:	d398                	sw	a4,32(a5)
  }
  release(&log.lock);
    80209552:	0003c517          	auipc	a0,0x3c
    80209556:	9ae50513          	addi	a0,a0,-1618 # 80244f00 <log>
    8020955a:	00002097          	auipc	ra,0x2
    8020955e:	61a080e7          	jalr	1562(ra) # 8020bb74 <release>
}
    80209562:	0001                	nop
    80209564:	70a2                	ld	ra,40(sp)
    80209566:	7402                	ld	s0,32(sp)
    80209568:	6145                	addi	sp,sp,48
    8020956a:	8082                	ret

000000008020956c <fileinit>:
	struct spinlock lock;
	struct file file[NFILE];
} ftable;

void fileinit(void)
{
    8020956c:	1141                	addi	sp,sp,-16
    8020956e:	e406                	sd	ra,8(sp)
    80209570:	e022                	sd	s0,0(sp)
    80209572:	0800                	addi	s0,sp,16
	initlock(&ftable.lock, "ftable");
    80209574:	00029597          	auipc	a1,0x29
    80209578:	f3458593          	addi	a1,a1,-204 # 802324a8 <user_test_table+0x78>
    8020957c:	0003c517          	auipc	a0,0x3c
    80209580:	ac450513          	addi	a0,a0,-1340 # 80245040 <ftable>
    80209584:	00002097          	auipc	ra,0x2
    80209588:	57c080e7          	jalr	1404(ra) # 8020bb00 <initlock>
	printf("fileinit done \n");
    8020958c:	00029517          	auipc	a0,0x29
    80209590:	f2450513          	addi	a0,a0,-220 # 802324b0 <user_test_table+0x80>
    80209594:	ffff7097          	auipc	ra,0xffff7
    80209598:	7fa080e7          	jalr	2042(ra) # 80200d8e <printf>
}
    8020959c:	0001                	nop
    8020959e:	60a2                	ld	ra,8(sp)
    802095a0:	6402                	ld	s0,0(sp)
    802095a2:	0141                	addi	sp,sp,16
    802095a4:	8082                	ret

00000000802095a6 <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
    802095a6:	1101                	addi	sp,sp,-32
    802095a8:	ec06                	sd	ra,24(sp)
    802095aa:	e822                	sd	s0,16(sp)
    802095ac:	1000                	addi	s0,sp,32
	struct file *f;
	acquire(&ftable.lock);
    802095ae:	0003c517          	auipc	a0,0x3c
    802095b2:	a9250513          	addi	a0,a0,-1390 # 80245040 <ftable>
    802095b6:	00002097          	auipc	ra,0x2
    802095ba:	572080e7          	jalr	1394(ra) # 8020bb28 <acquire>
	for (f = ftable.file; f < ftable.file + NFILE; f++)
    802095be:	0003c797          	auipc	a5,0x3c
    802095c2:	a9278793          	addi	a5,a5,-1390 # 80245050 <ftable+0x10>
    802095c6:	fef43423          	sd	a5,-24(s0)
    802095ca:	a815                	j	802095fe <filealloc+0x58>
	{
		if (f->ref == 0)
    802095cc:	fe843783          	ld	a5,-24(s0)
    802095d0:	43dc                	lw	a5,4(a5)
    802095d2:	e385                	bnez	a5,802095f2 <filealloc+0x4c>
		{
			f->ref = 1;
    802095d4:	fe843783          	ld	a5,-24(s0)
    802095d8:	4705                	li	a4,1
    802095da:	c3d8                	sw	a4,4(a5)
			release(&ftable.lock);
    802095dc:	0003c517          	auipc	a0,0x3c
    802095e0:	a6450513          	addi	a0,a0,-1436 # 80245040 <ftable>
    802095e4:	00002097          	auipc	ra,0x2
    802095e8:	590080e7          	jalr	1424(ra) # 8020bb74 <release>
			return f;
    802095ec:	fe843783          	ld	a5,-24(s0)
    802095f0:	a805                	j	80209620 <filealloc+0x7a>
	for (f = ftable.file; f < ftable.file + NFILE; f++)
    802095f2:	fe843783          	ld	a5,-24(s0)
    802095f6:	02878793          	addi	a5,a5,40
    802095fa:	fef43423          	sd	a5,-24(s0)
    802095fe:	0003d797          	auipc	a5,0x3d
    80209602:	9f278793          	addi	a5,a5,-1550 # 80245ff0 <sb>
    80209606:	fe843703          	ld	a4,-24(s0)
    8020960a:	fcf761e3          	bltu	a4,a5,802095cc <filealloc+0x26>
		}
	}
	release(&ftable.lock);
    8020960e:	0003c517          	auipc	a0,0x3c
    80209612:	a3250513          	addi	a0,a0,-1486 # 80245040 <ftable>
    80209616:	00002097          	auipc	ra,0x2
    8020961a:	55e080e7          	jalr	1374(ra) # 8020bb74 <release>
	return 0;
    8020961e:	4781                	li	a5,0
}
    80209620:	853e                	mv	a0,a5
    80209622:	60e2                	ld	ra,24(sp)
    80209624:	6442                	ld	s0,16(sp)
    80209626:	6105                	addi	sp,sp,32
    80209628:	8082                	ret

000000008020962a <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
    8020962a:	1101                	addi	sp,sp,-32
    8020962c:	ec06                	sd	ra,24(sp)
    8020962e:	e822                	sd	s0,16(sp)
    80209630:	1000                	addi	s0,sp,32
    80209632:	fea43423          	sd	a0,-24(s0)
	acquire(&ftable.lock);
    80209636:	0003c517          	auipc	a0,0x3c
    8020963a:	a0a50513          	addi	a0,a0,-1526 # 80245040 <ftable>
    8020963e:	00002097          	auipc	ra,0x2
    80209642:	4ea080e7          	jalr	1258(ra) # 8020bb28 <acquire>
	if (f->ref < 1)
    80209646:	fe843783          	ld	a5,-24(s0)
    8020964a:	43dc                	lw	a5,4(a5)
    8020964c:	00f04a63          	bgtz	a5,80209660 <filedup+0x36>
		panic("filedup");
    80209650:	00029517          	auipc	a0,0x29
    80209654:	e7050513          	addi	a0,a0,-400 # 802324c0 <user_test_table+0x90>
    80209658:	ffff8097          	auipc	ra,0xffff8
    8020965c:	182080e7          	jalr	386(ra) # 802017da <panic>
	f->ref++;
    80209660:	fe843783          	ld	a5,-24(s0)
    80209664:	43dc                	lw	a5,4(a5)
    80209666:	2785                	addiw	a5,a5,1
    80209668:	0007871b          	sext.w	a4,a5
    8020966c:	fe843783          	ld	a5,-24(s0)
    80209670:	c3d8                	sw	a4,4(a5)
	release(&ftable.lock);
    80209672:	0003c517          	auipc	a0,0x3c
    80209676:	9ce50513          	addi	a0,a0,-1586 # 80245040 <ftable>
    8020967a:	00002097          	auipc	ra,0x2
    8020967e:	4fa080e7          	jalr	1274(ra) # 8020bb74 <release>
	return f;
    80209682:	fe843783          	ld	a5,-24(s0)
}
    80209686:	853e                	mv	a0,a5
    80209688:	60e2                	ld	ra,24(sp)
    8020968a:	6442                	ld	s0,16(sp)
    8020968c:	6105                	addi	sp,sp,32
    8020968e:	8082                	ret

0000000080209690 <fileopen>:

struct file *fileopen(struct inode *ip, int readable, int writable)
{
    80209690:	7179                	addi	sp,sp,-48
    80209692:	f406                	sd	ra,40(sp)
    80209694:	f022                	sd	s0,32(sp)
    80209696:	1800                	addi	s0,sp,48
    80209698:	fca43c23          	sd	a0,-40(s0)
    8020969c:	87ae                	mv	a5,a1
    8020969e:	8732                	mv	a4,a2
    802096a0:	fcf42a23          	sw	a5,-44(s0)
    802096a4:	87ba                	mv	a5,a4
    802096a6:	fcf42823          	sw	a5,-48(s0)
	struct file *f = filealloc();
    802096aa:	00000097          	auipc	ra,0x0
    802096ae:	efc080e7          	jalr	-260(ra) # 802095a6 <filealloc>
    802096b2:	fea43423          	sd	a0,-24(s0)
	if (f == 0)
    802096b6:	fe843783          	ld	a5,-24(s0)
    802096ba:	e399                	bnez	a5,802096c0 <fileopen+0x30>
		return 0;
    802096bc:	4781                	li	a5,0
    802096be:	a081                	j	802096fe <fileopen+0x6e>
	f->type = FD_INODE;
    802096c0:	fe843783          	ld	a5,-24(s0)
    802096c4:	4709                	li	a4,2
    802096c6:	c398                	sw	a4,0(a5)
	f->ip = ip;
    802096c8:	fe843783          	ld	a5,-24(s0)
    802096cc:	fd843703          	ld	a4,-40(s0)
    802096d0:	ef98                	sd	a4,24(a5)
	f->readable = readable;
    802096d2:	fd442783          	lw	a5,-44(s0)
    802096d6:	0ff7f713          	zext.b	a4,a5
    802096da:	fe843783          	ld	a5,-24(s0)
    802096de:	00e78423          	sb	a4,8(a5)
	f->writable = writable;
    802096e2:	fd042783          	lw	a5,-48(s0)
    802096e6:	0ff7f713          	zext.b	a4,a5
    802096ea:	fe843783          	ld	a5,-24(s0)
    802096ee:	00e784a3          	sb	a4,9(a5)
	f->off = 0;
    802096f2:	fe843783          	ld	a5,-24(s0)
    802096f6:	0207a023          	sw	zero,32(a5)
	return f;
    802096fa:	fe843783          	ld	a5,-24(s0)
}
    802096fe:	853e                	mv	a0,a5
    80209700:	70a2                	ld	ra,40(sp)
    80209702:	7402                	ld	s0,32(sp)
    80209704:	6145                	addi	sp,sp,48
    80209706:	8082                	ret

0000000080209708 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f)
{
    80209708:	715d                	addi	sp,sp,-80
    8020970a:	e486                	sd	ra,72(sp)
    8020970c:	e0a2                	sd	s0,64(sp)
    8020970e:	0880                	addi	s0,sp,80
    80209710:	faa43c23          	sd	a0,-72(s0)
	struct file ff;

	acquire(&ftable.lock);
    80209714:	0003c517          	auipc	a0,0x3c
    80209718:	92c50513          	addi	a0,a0,-1748 # 80245040 <ftable>
    8020971c:	00002097          	auipc	ra,0x2
    80209720:	40c080e7          	jalr	1036(ra) # 8020bb28 <acquire>
	if (f->ref < 1)
    80209724:	fb843783          	ld	a5,-72(s0)
    80209728:	43dc                	lw	a5,4(a5)
    8020972a:	00f04a63          	bgtz	a5,8020973e <fileclose+0x36>
		panic("fileclose");
    8020972e:	00029517          	auipc	a0,0x29
    80209732:	d9a50513          	addi	a0,a0,-614 # 802324c8 <user_test_table+0x98>
    80209736:	ffff8097          	auipc	ra,0xffff8
    8020973a:	0a4080e7          	jalr	164(ra) # 802017da <panic>
	if (--f->ref > 0)
    8020973e:	fb843783          	ld	a5,-72(s0)
    80209742:	43dc                	lw	a5,4(a5)
    80209744:	37fd                	addiw	a5,a5,-1
    80209746:	0007871b          	sext.w	a4,a5
    8020974a:	fb843783          	ld	a5,-72(s0)
    8020974e:	c3d8                	sw	a4,4(a5)
    80209750:	fb843783          	ld	a5,-72(s0)
    80209754:	43dc                	lw	a5,4(a5)
    80209756:	00f05b63          	blez	a5,8020976c <fileclose+0x64>
	{
		release(&ftable.lock);
    8020975a:	0003c517          	auipc	a0,0x3c
    8020975e:	8e650513          	addi	a0,a0,-1818 # 80245040 <ftable>
    80209762:	00002097          	auipc	ra,0x2
    80209766:	412080e7          	jalr	1042(ra) # 8020bb74 <release>
    8020976a:	a879                	j	80209808 <fileclose+0x100>
		return;
	}
	ff = *f;
    8020976c:	fb843783          	ld	a5,-72(s0)
    80209770:	638c                	ld	a1,0(a5)
    80209772:	6790                	ld	a2,8(a5)
    80209774:	6b94                	ld	a3,16(a5)
    80209776:	6f98                	ld	a4,24(a5)
    80209778:	739c                	ld	a5,32(a5)
    8020977a:	fcb43423          	sd	a1,-56(s0)
    8020977e:	fcc43823          	sd	a2,-48(s0)
    80209782:	fcd43c23          	sd	a3,-40(s0)
    80209786:	fee43023          	sd	a4,-32(s0)
    8020978a:	fef43423          	sd	a5,-24(s0)
	f->ref = 0;
    8020978e:	fb843783          	ld	a5,-72(s0)
    80209792:	0007a223          	sw	zero,4(a5)
	f->type = FD_NONE;
    80209796:	fb843783          	ld	a5,-72(s0)
    8020979a:	0007a023          	sw	zero,0(a5)
	release(&ftable.lock);
    8020979e:	0003c517          	auipc	a0,0x3c
    802097a2:	8a250513          	addi	a0,a0,-1886 # 80245040 <ftable>
    802097a6:	00002097          	auipc	ra,0x2
    802097aa:	3ce080e7          	jalr	974(ra) # 8020bb74 <release>

	if (ff.type == FD_PIPE)
    802097ae:	fc842783          	lw	a5,-56(s0)
    802097b2:	873e                	mv	a4,a5
    802097b4:	4785                	li	a5,1
    802097b6:	00f71e63          	bne	a4,a5,802097d2 <fileclose+0xca>
	{
		pipeclose(ff.pipe, ff.writable);
    802097ba:	fd843783          	ld	a5,-40(s0)
    802097be:	fd144703          	lbu	a4,-47(s0)
    802097c2:	2701                	sext.w	a4,a4
    802097c4:	85ba                	mv	a1,a4
    802097c6:	853e                	mv	a0,a5
    802097c8:	00000097          	auipc	ra,0x0
    802097cc:	590080e7          	jalr	1424(ra) # 80209d58 <pipeclose>
    802097d0:	a825                	j	80209808 <fileclose+0x100>
	}
	else if (ff.type == FD_INODE || ff.type == FD_DEVICE)
    802097d2:	fc842783          	lw	a5,-56(s0)
    802097d6:	873e                	mv	a4,a5
    802097d8:	4789                	li	a5,2
    802097da:	00f70863          	beq	a4,a5,802097ea <fileclose+0xe2>
    802097de:	fc842783          	lw	a5,-56(s0)
    802097e2:	873e                	mv	a4,a5
    802097e4:	478d                	li	a5,3
    802097e6:	02f71163          	bne	a4,a5,80209808 <fileclose+0x100>
	{
		begin_op();
    802097ea:	00000097          	auipc	ra,0x0
    802097ee:	954080e7          	jalr	-1708(ra) # 8020913e <begin_op>
		iput(ff.ip);
    802097f2:	fe043783          	ld	a5,-32(s0)
    802097f6:	853e                	mv	a0,a5
    802097f8:	00001097          	auipc	ra,0x1
    802097fc:	182080e7          	jalr	386(ra) # 8020a97a <iput>
		end_op();
    80209800:	00000097          	auipc	ra,0x0
    80209804:	a1c080e7          	jalr	-1508(ra) # 8020921c <end_op>
	}
}
    80209808:	60a6                	ld	ra,72(sp)
    8020980a:	6406                	ld	s0,64(sp)
    8020980c:	6161                	addi	sp,sp,80
    8020980e:	8082                	ret

0000000080209810 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int filestat(struct file *f, uint64 addr)
{
    80209810:	7139                	addi	sp,sp,-64
    80209812:	fc06                	sd	ra,56(sp)
    80209814:	f822                	sd	s0,48(sp)
    80209816:	0080                	addi	s0,sp,64
    80209818:	fca43423          	sd	a0,-56(s0)
    8020981c:	fcb43023          	sd	a1,-64(s0)
	struct proc *p = myproc();
    80209820:	ffffc097          	auipc	ra,0xffffc
    80209824:	820080e7          	jalr	-2016(ra) # 80205040 <myproc>
    80209828:	fea43423          	sd	a0,-24(s0)
	struct stat st;

	if (f->type == FD_INODE || f->type == FD_DEVICE)
    8020982c:	fc843783          	ld	a5,-56(s0)
    80209830:	439c                	lw	a5,0(a5)
    80209832:	873e                	mv	a4,a5
    80209834:	4789                	li	a5,2
    80209836:	00f70963          	beq	a4,a5,80209848 <filestat+0x38>
    8020983a:	fc843783          	ld	a5,-56(s0)
    8020983e:	439c                	lw	a5,0(a5)
    80209840:	873e                	mv	a4,a5
    80209842:	478d                	li	a5,3
    80209844:	06f71263          	bne	a4,a5,802098a8 <filestat+0x98>
	{
		ilock(f->ip);
    80209848:	fc843783          	ld	a5,-56(s0)
    8020984c:	6f9c                	ld	a5,24(a5)
    8020984e:	853e                	mv	a0,a5
    80209850:	00001097          	auipc	ra,0x1
    80209854:	f96080e7          	jalr	-106(ra) # 8020a7e6 <ilock>
		stati(f->ip, &st);
    80209858:	fc843783          	ld	a5,-56(s0)
    8020985c:	6f9c                	ld	a5,24(a5)
    8020985e:	fd040713          	addi	a4,s0,-48
    80209862:	85ba                	mv	a1,a4
    80209864:	853e                	mv	a0,a5
    80209866:	00001097          	auipc	ra,0x1
    8020986a:	5fc080e7          	jalr	1532(ra) # 8020ae62 <stati>
		iunlock(f->ip);
    8020986e:	fc843783          	ld	a5,-56(s0)
    80209872:	6f9c                	ld	a5,24(a5)
    80209874:	853e                	mv	a0,a5
    80209876:	00001097          	auipc	ra,0x1
    8020987a:	0a6080e7          	jalr	166(ra) # 8020a91c <iunlock>
		if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8020987e:	fe843783          	ld	a5,-24(s0)
    80209882:	7fdc                	ld	a5,184(a5)
    80209884:	fd040713          	addi	a4,s0,-48
    80209888:	46e1                	li	a3,24
    8020988a:	863a                	mv	a2,a4
    8020988c:	fc043583          	ld	a1,-64(s0)
    80209890:	853e                	mv	a0,a5
    80209892:	ffffb097          	auipc	ra,0xffffb
    80209896:	864080e7          	jalr	-1948(ra) # 802040f6 <copyout>
    8020989a:	87aa                	mv	a5,a0
    8020989c:	0007d463          	bgez	a5,802098a4 <filestat+0x94>
			return -1;
    802098a0:	57fd                	li	a5,-1
    802098a2:	a021                	j	802098aa <filestat+0x9a>
		return 0;
    802098a4:	4781                	li	a5,0
    802098a6:	a011                	j	802098aa <filestat+0x9a>
	}
	return -1;
    802098a8:	57fd                	li	a5,-1
}
    802098aa:	853e                	mv	a0,a5
    802098ac:	70e2                	ld	ra,56(sp)
    802098ae:	7442                	ld	s0,48(sp)
    802098b0:	6121                	addi	sp,sp,64
    802098b2:	8082                	ret

00000000802098b4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int fileread(struct file *f, uint64 addr, int n)
{
    802098b4:	7139                	addi	sp,sp,-64
    802098b6:	fc06                	sd	ra,56(sp)
    802098b8:	f822                	sd	s0,48(sp)
    802098ba:	0080                	addi	s0,sp,64
    802098bc:	fca43c23          	sd	a0,-40(s0)
    802098c0:	fcb43823          	sd	a1,-48(s0)
    802098c4:	87b2                	mv	a5,a2
    802098c6:	fcf42623          	sw	a5,-52(s0)
	int r = 0;
    802098ca:	fe042623          	sw	zero,-20(s0)

	if (f->readable == 0)
    802098ce:	fd843783          	ld	a5,-40(s0)
    802098d2:	0087c783          	lbu	a5,8(a5)
    802098d6:	e399                	bnez	a5,802098dc <fileread+0x28>
		return -1;
    802098d8:	57fd                	li	a5,-1
    802098da:	a23d                	j	80209a08 <fileread+0x154>

	if (f->type == FD_PIPE)
    802098dc:	fd843783          	ld	a5,-40(s0)
    802098e0:	439c                	lw	a5,0(a5)
    802098e2:	873e                	mv	a4,a5
    802098e4:	4785                	li	a5,1
    802098e6:	02f71363          	bne	a4,a5,8020990c <fileread+0x58>
	{
		r = piperead(f->pipe, addr, n);
    802098ea:	fd843783          	ld	a5,-40(s0)
    802098ee:	6b9c                	ld	a5,16(a5)
    802098f0:	fcc42703          	lw	a4,-52(s0)
    802098f4:	863a                	mv	a2,a4
    802098f6:	fd043583          	ld	a1,-48(s0)
    802098fa:	853e                	mv	a0,a5
    802098fc:	00000097          	auipc	ra,0x0
    80209900:	5f0080e7          	jalr	1520(ra) # 80209eec <piperead>
    80209904:	87aa                	mv	a5,a0
    80209906:	fef42623          	sw	a5,-20(s0)
    8020990a:	a8ed                	j	80209a04 <fileread+0x150>
	}
	else if (f->type == FD_DEVICE)
    8020990c:	fd843783          	ld	a5,-40(s0)
    80209910:	439c                	lw	a5,0(a5)
    80209912:	873e                	mv	a4,a5
    80209914:	478d                	li	a5,3
    80209916:	06f71463          	bne	a4,a5,8020997e <fileread+0xca>
	{
		if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8020991a:	fd843783          	ld	a5,-40(s0)
    8020991e:	02479783          	lh	a5,36(a5)
    80209922:	0207c663          	bltz	a5,8020994e <fileread+0x9a>
    80209926:	fd843783          	ld	a5,-40(s0)
    8020992a:	02479783          	lh	a5,36(a5)
    8020992e:	873e                	mv	a4,a5
    80209930:	47a5                	li	a5,9
    80209932:	00e7ce63          	blt	a5,a4,8020994e <fileread+0x9a>
    80209936:	fd843783          	ld	a5,-40(s0)
    8020993a:	02479783          	lh	a5,36(a5)
    8020993e:	0003b717          	auipc	a4,0x3b
    80209942:	66270713          	addi	a4,a4,1634 # 80244fa0 <devsw>
    80209946:	0792                	slli	a5,a5,0x4
    80209948:	97ba                	add	a5,a5,a4
    8020994a:	639c                	ld	a5,0(a5)
    8020994c:	e399                	bnez	a5,80209952 <fileread+0x9e>
			return -1;
    8020994e:	57fd                	li	a5,-1
    80209950:	a865                	j	80209a08 <fileread+0x154>
		r = devsw[f->major].read(1, addr, n);
    80209952:	fd843783          	ld	a5,-40(s0)
    80209956:	02479783          	lh	a5,36(a5)
    8020995a:	0003b717          	auipc	a4,0x3b
    8020995e:	64670713          	addi	a4,a4,1606 # 80244fa0 <devsw>
    80209962:	0792                	slli	a5,a5,0x4
    80209964:	97ba                	add	a5,a5,a4
    80209966:	639c                	ld	a5,0(a5)
    80209968:	fcc42703          	lw	a4,-52(s0)
    8020996c:	863a                	mv	a2,a4
    8020996e:	fd043583          	ld	a1,-48(s0)
    80209972:	4505                	li	a0,1
    80209974:	9782                	jalr	a5
    80209976:	87aa                	mv	a5,a0
    80209978:	fef42623          	sw	a5,-20(s0)
    8020997c:	a061                	j	80209a04 <fileread+0x150>
	}
	else if (f->type == FD_INODE)
    8020997e:	fd843783          	ld	a5,-40(s0)
    80209982:	439c                	lw	a5,0(a5)
    80209984:	873e                	mv	a4,a5
    80209986:	4789                	li	a5,2
    80209988:	06f71663          	bne	a4,a5,802099f4 <fileread+0x140>
	{
		ilock(f->ip);
    8020998c:	fd843783          	ld	a5,-40(s0)
    80209990:	6f9c                	ld	a5,24(a5)
    80209992:	853e                	mv	a0,a5
    80209994:	00001097          	auipc	ra,0x1
    80209998:	e52080e7          	jalr	-430(ra) # 8020a7e6 <ilock>
		if ((r = readi(f->ip, 0, addr, f->off, n)) > 0)
    8020999c:	fd843783          	ld	a5,-40(s0)
    802099a0:	6f88                	ld	a0,24(a5)
    802099a2:	fd843783          	ld	a5,-40(s0)
    802099a6:	539c                	lw	a5,32(a5)
    802099a8:	fcc42703          	lw	a4,-52(s0)
    802099ac:	86be                	mv	a3,a5
    802099ae:	fd043603          	ld	a2,-48(s0)
    802099b2:	4581                	li	a1,0
    802099b4:	00001097          	auipc	ra,0x1
    802099b8:	5dc080e7          	jalr	1500(ra) # 8020af90 <readi>
    802099bc:	87aa                	mv	a5,a0
    802099be:	fef42623          	sw	a5,-20(s0)
    802099c2:	fec42783          	lw	a5,-20(s0)
    802099c6:	2781                	sext.w	a5,a5
    802099c8:	00f05d63          	blez	a5,802099e2 <fileread+0x12e>
			f->off += r;
    802099cc:	fd843783          	ld	a5,-40(s0)
    802099d0:	5398                	lw	a4,32(a5)
    802099d2:	fec42783          	lw	a5,-20(s0)
    802099d6:	9fb9                	addw	a5,a5,a4
    802099d8:	0007871b          	sext.w	a4,a5
    802099dc:	fd843783          	ld	a5,-40(s0)
    802099e0:	d398                	sw	a4,32(a5)
		iunlock(f->ip);
    802099e2:	fd843783          	ld	a5,-40(s0)
    802099e6:	6f9c                	ld	a5,24(a5)
    802099e8:	853e                	mv	a0,a5
    802099ea:	00001097          	auipc	ra,0x1
    802099ee:	f32080e7          	jalr	-206(ra) # 8020a91c <iunlock>
    802099f2:	a809                	j	80209a04 <fileread+0x150>
	}
	else
	{
		panic("fileread");
    802099f4:	00029517          	auipc	a0,0x29
    802099f8:	ae450513          	addi	a0,a0,-1308 # 802324d8 <user_test_table+0xa8>
    802099fc:	ffff8097          	auipc	ra,0xffff8
    80209a00:	dde080e7          	jalr	-546(ra) # 802017da <panic>
	}

	return r;
    80209a04:	fec42783          	lw	a5,-20(s0)
}
    80209a08:	853e                	mv	a0,a5
    80209a0a:	70e2                	ld	ra,56(sp)
    80209a0c:	7442                	ld	s0,48(sp)
    80209a0e:	6121                	addi	sp,sp,64
    80209a10:	8082                	ret

0000000080209a12 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int filewrite(struct file *f, uint64 addr, int n)
{
    80209a12:	715d                	addi	sp,sp,-80
    80209a14:	e486                	sd	ra,72(sp)
    80209a16:	e0a2                	sd	s0,64(sp)
    80209a18:	0880                	addi	s0,sp,80
    80209a1a:	fca43423          	sd	a0,-56(s0)
    80209a1e:	fcb43023          	sd	a1,-64(s0)
    80209a22:	87b2                	mv	a5,a2
    80209a24:	faf42e23          	sw	a5,-68(s0)
	int r, ret = 0;
    80209a28:	fe042623          	sw	zero,-20(s0)

	if (f->writable == 0)
    80209a2c:	fc843783          	ld	a5,-56(s0)
    80209a30:	0097c783          	lbu	a5,9(a5)
    80209a34:	e399                	bnez	a5,80209a3a <filewrite+0x28>
		return -1;
    80209a36:	57fd                	li	a5,-1
    80209a38:	aae1                	j	80209c10 <filewrite+0x1fe>

	if (f->type == FD_PIPE)
    80209a3a:	fc843783          	ld	a5,-56(s0)
    80209a3e:	439c                	lw	a5,0(a5)
    80209a40:	873e                	mv	a4,a5
    80209a42:	4785                	li	a5,1
    80209a44:	02f71363          	bne	a4,a5,80209a6a <filewrite+0x58>
	{
		ret = pipewrite(f->pipe, addr, n);
    80209a48:	fc843783          	ld	a5,-56(s0)
    80209a4c:	6b9c                	ld	a5,16(a5)
    80209a4e:	fbc42703          	lw	a4,-68(s0)
    80209a52:	863a                	mv	a2,a4
    80209a54:	fc043583          	ld	a1,-64(s0)
    80209a58:	853e                	mv	a0,a5
    80209a5a:	00000097          	auipc	ra,0x0
    80209a5e:	378080e7          	jalr	888(ra) # 80209dd2 <pipewrite>
    80209a62:	87aa                	mv	a5,a0
    80209a64:	fef42623          	sw	a5,-20(s0)
    80209a68:	a255                	j	80209c0c <filewrite+0x1fa>
	}
	else if (f->type == FD_DEVICE)
    80209a6a:	fc843783          	ld	a5,-56(s0)
    80209a6e:	439c                	lw	a5,0(a5)
    80209a70:	873e                	mv	a4,a5
    80209a72:	478d                	li	a5,3
    80209a74:	06f71463          	bne	a4,a5,80209adc <filewrite+0xca>
	{
		if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80209a78:	fc843783          	ld	a5,-56(s0)
    80209a7c:	02479783          	lh	a5,36(a5)
    80209a80:	0207c663          	bltz	a5,80209aac <filewrite+0x9a>
    80209a84:	fc843783          	ld	a5,-56(s0)
    80209a88:	02479783          	lh	a5,36(a5)
    80209a8c:	873e                	mv	a4,a5
    80209a8e:	47a5                	li	a5,9
    80209a90:	00e7ce63          	blt	a5,a4,80209aac <filewrite+0x9a>
    80209a94:	fc843783          	ld	a5,-56(s0)
    80209a98:	02479783          	lh	a5,36(a5)
    80209a9c:	0003b717          	auipc	a4,0x3b
    80209aa0:	50470713          	addi	a4,a4,1284 # 80244fa0 <devsw>
    80209aa4:	0792                	slli	a5,a5,0x4
    80209aa6:	97ba                	add	a5,a5,a4
    80209aa8:	679c                	ld	a5,8(a5)
    80209aaa:	e399                	bnez	a5,80209ab0 <filewrite+0x9e>
			return -1;
    80209aac:	57fd                	li	a5,-1
    80209aae:	a28d                	j	80209c10 <filewrite+0x1fe>
		ret = devsw[f->major].write(1, addr, n);
    80209ab0:	fc843783          	ld	a5,-56(s0)
    80209ab4:	02479783          	lh	a5,36(a5)
    80209ab8:	0003b717          	auipc	a4,0x3b
    80209abc:	4e870713          	addi	a4,a4,1256 # 80244fa0 <devsw>
    80209ac0:	0792                	slli	a5,a5,0x4
    80209ac2:	97ba                	add	a5,a5,a4
    80209ac4:	679c                	ld	a5,8(a5)
    80209ac6:	fbc42703          	lw	a4,-68(s0)
    80209aca:	863a                	mv	a2,a4
    80209acc:	fc043583          	ld	a1,-64(s0)
    80209ad0:	4505                	li	a0,1
    80209ad2:	9782                	jalr	a5
    80209ad4:	87aa                	mv	a5,a0
    80209ad6:	fef42623          	sw	a5,-20(s0)
    80209ada:	aa0d                	j	80209c0c <filewrite+0x1fa>
	}
	else if (f->type == FD_INODE)
    80209adc:	fc843783          	ld	a5,-56(s0)
    80209ae0:	439c                	lw	a5,0(a5)
    80209ae2:	873e                	mv	a4,a5
    80209ae4:	4789                	li	a5,2
    80209ae6:	10f71b63          	bne	a4,a5,80209bfc <filewrite+0x1ea>
	{
		int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    80209aea:	6785                	lui	a5,0x1
    80209aec:	c0078793          	addi	a5,a5,-1024 # c00 <_entry-0x801ff400>
    80209af0:	fef42023          	sw	a5,-32(s0)
		int i = 0;
    80209af4:	fe042423          	sw	zero,-24(s0)
		while (i < n)
    80209af8:	a0f9                	j	80209bc6 <filewrite+0x1b4>
		{
			int n1 = n - i;
    80209afa:	fbc42783          	lw	a5,-68(s0)
    80209afe:	873e                	mv	a4,a5
    80209b00:	fe842783          	lw	a5,-24(s0)
    80209b04:	40f707bb          	subw	a5,a4,a5
    80209b08:	fef42223          	sw	a5,-28(s0)
			if (n1 > max)
    80209b0c:	fe442783          	lw	a5,-28(s0)
    80209b10:	873e                	mv	a4,a5
    80209b12:	fe042783          	lw	a5,-32(s0)
    80209b16:	2701                	sext.w	a4,a4
    80209b18:	2781                	sext.w	a5,a5
    80209b1a:	00e7d663          	bge	a5,a4,80209b26 <filewrite+0x114>
				n1 = max;
    80209b1e:	fe042783          	lw	a5,-32(s0)
    80209b22:	fef42223          	sw	a5,-28(s0)

			begin_op();
    80209b26:	fffff097          	auipc	ra,0xfffff
    80209b2a:	618080e7          	jalr	1560(ra) # 8020913e <begin_op>
			ilock(f->ip);
    80209b2e:	fc843783          	ld	a5,-56(s0)
    80209b32:	6f9c                	ld	a5,24(a5)
    80209b34:	853e                	mv	a0,a5
    80209b36:	00001097          	auipc	ra,0x1
    80209b3a:	cb0080e7          	jalr	-848(ra) # 8020a7e6 <ilock>
			if ((r = writei(f->ip, 0, addr + i, f->off, n1)) > 0)
    80209b3e:	fc843783          	ld	a5,-56(s0)
    80209b42:	6f88                	ld	a0,24(a5)
    80209b44:	fe842703          	lw	a4,-24(s0)
    80209b48:	fc043783          	ld	a5,-64(s0)
    80209b4c:	00f70633          	add	a2,a4,a5
    80209b50:	fc843783          	ld	a5,-56(s0)
    80209b54:	539c                	lw	a5,32(a5)
    80209b56:	fe442703          	lw	a4,-28(s0)
    80209b5a:	86be                	mv	a3,a5
    80209b5c:	4581                	li	a1,0
    80209b5e:	00001097          	auipc	ra,0x1
    80209b62:	5d0080e7          	jalr	1488(ra) # 8020b12e <writei>
    80209b66:	87aa                	mv	a5,a0
    80209b68:	fcf42e23          	sw	a5,-36(s0)
    80209b6c:	fdc42783          	lw	a5,-36(s0)
    80209b70:	2781                	sext.w	a5,a5
    80209b72:	00f05d63          	blez	a5,80209b8c <filewrite+0x17a>
				f->off += r;
    80209b76:	fc843783          	ld	a5,-56(s0)
    80209b7a:	5398                	lw	a4,32(a5)
    80209b7c:	fdc42783          	lw	a5,-36(s0)
    80209b80:	9fb9                	addw	a5,a5,a4
    80209b82:	0007871b          	sext.w	a4,a5
    80209b86:	fc843783          	ld	a5,-56(s0)
    80209b8a:	d398                	sw	a4,32(a5)
			iunlock(f->ip);
    80209b8c:	fc843783          	ld	a5,-56(s0)
    80209b90:	6f9c                	ld	a5,24(a5)
    80209b92:	853e                	mv	a0,a5
    80209b94:	00001097          	auipc	ra,0x1
    80209b98:	d88080e7          	jalr	-632(ra) # 8020a91c <iunlock>
			end_op();
    80209b9c:	fffff097          	auipc	ra,0xfffff
    80209ba0:	680080e7          	jalr	1664(ra) # 8020921c <end_op>

			if (r != n1)
    80209ba4:	fdc42783          	lw	a5,-36(s0)
    80209ba8:	873e                	mv	a4,a5
    80209baa:	fe442783          	lw	a5,-28(s0)
    80209bae:	2701                	sext.w	a4,a4
    80209bb0:	2781                	sext.w	a5,a5
    80209bb2:	02f71463          	bne	a4,a5,80209bda <filewrite+0x1c8>
			{
				// error from writei
				break;
			}
			i += r;
    80209bb6:	fe842783          	lw	a5,-24(s0)
    80209bba:	873e                	mv	a4,a5
    80209bbc:	fdc42783          	lw	a5,-36(s0)
    80209bc0:	9fb9                	addw	a5,a5,a4
    80209bc2:	fef42423          	sw	a5,-24(s0)
		while (i < n)
    80209bc6:	fe842783          	lw	a5,-24(s0)
    80209bca:	873e                	mv	a4,a5
    80209bcc:	fbc42783          	lw	a5,-68(s0)
    80209bd0:	2701                	sext.w	a4,a4
    80209bd2:	2781                	sext.w	a5,a5
    80209bd4:	f2f743e3          	blt	a4,a5,80209afa <filewrite+0xe8>
    80209bd8:	a011                	j	80209bdc <filewrite+0x1ca>
				break;
    80209bda:	0001                	nop
		}
		ret = (i == n ? n : -1);
    80209bdc:	fe842783          	lw	a5,-24(s0)
    80209be0:	873e                	mv	a4,a5
    80209be2:	fbc42783          	lw	a5,-68(s0)
    80209be6:	2701                	sext.w	a4,a4
    80209be8:	2781                	sext.w	a5,a5
    80209bea:	00f71563          	bne	a4,a5,80209bf4 <filewrite+0x1e2>
    80209bee:	fbc42783          	lw	a5,-68(s0)
    80209bf2:	a011                	j	80209bf6 <filewrite+0x1e4>
    80209bf4:	57fd                	li	a5,-1
    80209bf6:	fef42623          	sw	a5,-20(s0)
    80209bfa:	a809                	j	80209c0c <filewrite+0x1fa>
	}
	else
	{
		panic("filewrite");
    80209bfc:	00029517          	auipc	a0,0x29
    80209c00:	8ec50513          	addi	a0,a0,-1812 # 802324e8 <user_test_table+0xb8>
    80209c04:	ffff8097          	auipc	ra,0xffff8
    80209c08:	bd6080e7          	jalr	-1066(ra) # 802017da <panic>
	}

	return ret;
    80209c0c:	fec42783          	lw	a5,-20(s0)
}
    80209c10:	853e                	mv	a0,a5
    80209c12:	60a6                	ld	ra,72(sp)
    80209c14:	6406                	ld	s0,64(sp)
    80209c16:	6161                	addi	sp,sp,80
    80209c18:	8082                	ret

0000000080209c1a <pipealloc>:
#include "defs.h"

int
pipealloc(struct file **f0, struct file **f1)
{
    80209c1a:	7179                	addi	sp,sp,-48
    80209c1c:	f406                	sd	ra,40(sp)
    80209c1e:	f022                	sd	s0,32(sp)
    80209c20:	1800                	addi	s0,sp,48
    80209c22:	fca43c23          	sd	a0,-40(s0)
    80209c26:	fcb43823          	sd	a1,-48(s0)
  struct pipe *pi;

  pi = 0;
    80209c2a:	fe043423          	sd	zero,-24(s0)
  *f0 = *f1 = 0;
    80209c2e:	fd043783          	ld	a5,-48(s0)
    80209c32:	0007b023          	sd	zero,0(a5)
    80209c36:	fd043783          	ld	a5,-48(s0)
    80209c3a:	6398                	ld	a4,0(a5)
    80209c3c:	fd843783          	ld	a5,-40(s0)
    80209c40:	e398                	sd	a4,0(a5)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80209c42:	00000097          	auipc	ra,0x0
    80209c46:	964080e7          	jalr	-1692(ra) # 802095a6 <filealloc>
    80209c4a:	872a                	mv	a4,a0
    80209c4c:	fd843783          	ld	a5,-40(s0)
    80209c50:	e398                	sd	a4,0(a5)
    80209c52:	fd843783          	ld	a5,-40(s0)
    80209c56:	639c                	ld	a5,0(a5)
    80209c58:	c7d5                	beqz	a5,80209d04 <pipealloc+0xea>
    80209c5a:	00000097          	auipc	ra,0x0
    80209c5e:	94c080e7          	jalr	-1716(ra) # 802095a6 <filealloc>
    80209c62:	872a                	mv	a4,a0
    80209c64:	fd043783          	ld	a5,-48(s0)
    80209c68:	e398                	sd	a4,0(a5)
    80209c6a:	fd043783          	ld	a5,-48(s0)
    80209c6e:	639c                	ld	a5,0(a5)
    80209c70:	cbd1                	beqz	a5,80209d04 <pipealloc+0xea>
    goto bad;
  if((pi = (struct pipe*)alloc_page()) == 0)
    80209c72:	ffff9097          	auipc	ra,0xffff9
    80209c76:	6be080e7          	jalr	1726(ra) # 80203330 <alloc_page>
    80209c7a:	fea43423          	sd	a0,-24(s0)
    80209c7e:	fe843783          	ld	a5,-24(s0)
    80209c82:	c3d9                	beqz	a5,80209d08 <pipealloc+0xee>
    goto bad;
  pi->readopen = 1;
    80209c84:	fe843783          	ld	a5,-24(s0)
    80209c88:	4705                	li	a4,1
    80209c8a:	20e7a423          	sw	a4,520(a5)
  pi->writeopen = 1;
    80209c8e:	fe843783          	ld	a5,-24(s0)
    80209c92:	4705                	li	a4,1
    80209c94:	20e7a623          	sw	a4,524(a5)
  pi->nwrite = 0;
    80209c98:	fe843783          	ld	a5,-24(s0)
    80209c9c:	2007a223          	sw	zero,516(a5)
  pi->nread = 0;
    80209ca0:	fe843783          	ld	a5,-24(s0)
    80209ca4:	2007a023          	sw	zero,512(a5)
  (*f0)->type = FD_PIPE;
    80209ca8:	fd843783          	ld	a5,-40(s0)
    80209cac:	639c                	ld	a5,0(a5)
    80209cae:	4705                	li	a4,1
    80209cb0:	c398                	sw	a4,0(a5)
  (*f0)->readable = 1;
    80209cb2:	fd843783          	ld	a5,-40(s0)
    80209cb6:	639c                	ld	a5,0(a5)
    80209cb8:	4705                	li	a4,1
    80209cba:	00e78423          	sb	a4,8(a5)
  (*f0)->writable = 0;
    80209cbe:	fd843783          	ld	a5,-40(s0)
    80209cc2:	639c                	ld	a5,0(a5)
    80209cc4:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80209cc8:	fd843783          	ld	a5,-40(s0)
    80209ccc:	639c                	ld	a5,0(a5)
    80209cce:	fe843703          	ld	a4,-24(s0)
    80209cd2:	eb98                	sd	a4,16(a5)
  (*f1)->type = FD_PIPE;
    80209cd4:	fd043783          	ld	a5,-48(s0)
    80209cd8:	639c                	ld	a5,0(a5)
    80209cda:	4705                	li	a4,1
    80209cdc:	c398                	sw	a4,0(a5)
  (*f1)->readable = 0;
    80209cde:	fd043783          	ld	a5,-48(s0)
    80209ce2:	639c                	ld	a5,0(a5)
    80209ce4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80209ce8:	fd043783          	ld	a5,-48(s0)
    80209cec:	639c                	ld	a5,0(a5)
    80209cee:	4705                	li	a4,1
    80209cf0:	00e784a3          	sb	a4,9(a5)
  (*f1)->pipe = pi;
    80209cf4:	fd043783          	ld	a5,-48(s0)
    80209cf8:	639c                	ld	a5,0(a5)
    80209cfa:	fe843703          	ld	a4,-24(s0)
    80209cfe:	eb98                	sd	a4,16(a5)
  return 0;
    80209d00:	4781                	li	a5,0
    80209d02:	a0b1                	j	80209d4e <pipealloc+0x134>
    goto bad;
    80209d04:	0001                	nop
    80209d06:	a011                	j	80209d0a <pipealloc+0xf0>
    goto bad;
    80209d08:	0001                	nop

 bad:
  if(pi)
    80209d0a:	fe843783          	ld	a5,-24(s0)
    80209d0e:	c799                	beqz	a5,80209d1c <pipealloc+0x102>
    free_page((char*)pi);
    80209d10:	fe843503          	ld	a0,-24(s0)
    80209d14:	ffff9097          	auipc	ra,0xffff9
    80209d18:	688080e7          	jalr	1672(ra) # 8020339c <free_page>
  if(*f0)
    80209d1c:	fd843783          	ld	a5,-40(s0)
    80209d20:	639c                	ld	a5,0(a5)
    80209d22:	cb89                	beqz	a5,80209d34 <pipealloc+0x11a>
    fileclose(*f0);
    80209d24:	fd843783          	ld	a5,-40(s0)
    80209d28:	639c                	ld	a5,0(a5)
    80209d2a:	853e                	mv	a0,a5
    80209d2c:	00000097          	auipc	ra,0x0
    80209d30:	9dc080e7          	jalr	-1572(ra) # 80209708 <fileclose>
  if(*f1)
    80209d34:	fd043783          	ld	a5,-48(s0)
    80209d38:	639c                	ld	a5,0(a5)
    80209d3a:	cb89                	beqz	a5,80209d4c <pipealloc+0x132>
    fileclose(*f1);
    80209d3c:	fd043783          	ld	a5,-48(s0)
    80209d40:	639c                	ld	a5,0(a5)
    80209d42:	853e                	mv	a0,a5
    80209d44:	00000097          	auipc	ra,0x0
    80209d48:	9c4080e7          	jalr	-1596(ra) # 80209708 <fileclose>
  return -1;
    80209d4c:	57fd                	li	a5,-1
}
    80209d4e:	853e                	mv	a0,a5
    80209d50:	70a2                	ld	ra,40(sp)
    80209d52:	7402                	ld	s0,32(sp)
    80209d54:	6145                	addi	sp,sp,48
    80209d56:	8082                	ret

0000000080209d58 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80209d58:	1101                	addi	sp,sp,-32
    80209d5a:	ec06                	sd	ra,24(sp)
    80209d5c:	e822                	sd	s0,16(sp)
    80209d5e:	1000                	addi	s0,sp,32
    80209d60:	fea43423          	sd	a0,-24(s0)
    80209d64:	87ae                	mv	a5,a1
    80209d66:	fef42223          	sw	a5,-28(s0)
  if(writable){
    80209d6a:	fe442783          	lw	a5,-28(s0)
    80209d6e:	2781                	sext.w	a5,a5
    80209d70:	cf99                	beqz	a5,80209d8e <pipeclose+0x36>
    pi->writeopen = 0;
    80209d72:	fe843783          	ld	a5,-24(s0)
    80209d76:	2007a623          	sw	zero,524(a5)
    wakeup(&pi->nread);
    80209d7a:	fe843783          	ld	a5,-24(s0)
    80209d7e:	20078793          	addi	a5,a5,512
    80209d82:	853e                	mv	a0,a5
    80209d84:	ffffc097          	auipc	ra,0xffffc
    80209d88:	096080e7          	jalr	150(ra) # 80205e1a <wakeup>
    80209d8c:	a831                	j	80209da8 <pipeclose+0x50>
  } else {
    pi->readopen = 0;
    80209d8e:	fe843783          	ld	a5,-24(s0)
    80209d92:	2007a423          	sw	zero,520(a5)
    wakeup(&pi->nwrite);
    80209d96:	fe843783          	ld	a5,-24(s0)
    80209d9a:	20478793          	addi	a5,a5,516
    80209d9e:	853e                	mv	a0,a5
    80209da0:	ffffc097          	auipc	ra,0xffffc
    80209da4:	07a080e7          	jalr	122(ra) # 80205e1a <wakeup>
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80209da8:	fe843783          	ld	a5,-24(s0)
    80209dac:	2087a783          	lw	a5,520(a5)
    80209db0:	ef81                	bnez	a5,80209dc8 <pipeclose+0x70>
    80209db2:	fe843783          	ld	a5,-24(s0)
    80209db6:	20c7a783          	lw	a5,524(a5)
    80209dba:	e799                	bnez	a5,80209dc8 <pipeclose+0x70>
    free_page((char*)pi);
    80209dbc:	fe843503          	ld	a0,-24(s0)
    80209dc0:	ffff9097          	auipc	ra,0xffff9
    80209dc4:	5dc080e7          	jalr	1500(ra) # 8020339c <free_page>
  }
}
    80209dc8:	0001                	nop
    80209dca:	60e2                	ld	ra,24(sp)
    80209dcc:	6442                	ld	s0,16(sp)
    80209dce:	6105                	addi	sp,sp,32
    80209dd0:	8082                	ret

0000000080209dd2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80209dd2:	715d                	addi	sp,sp,-80
    80209dd4:	e486                	sd	ra,72(sp)
    80209dd6:	e0a2                	sd	s0,64(sp)
    80209dd8:	0880                	addi	s0,sp,80
    80209dda:	fca43423          	sd	a0,-56(s0)
    80209dde:	fcb43023          	sd	a1,-64(s0)
    80209de2:	87b2                	mv	a5,a2
    80209de4:	faf42e23          	sw	a5,-68(s0)
  int i = 0;
    80209de8:	fe042623          	sw	zero,-20(s0)
  struct proc *pr = myproc();
    80209dec:	ffffb097          	auipc	ra,0xffffb
    80209df0:	254080e7          	jalr	596(ra) # 80205040 <myproc>
    80209df4:	fea43023          	sd	a0,-32(s0)

  while(i < n){
    80209df8:	a87d                	j	80209eb6 <pipewrite+0xe4>
    if(pi->readopen == 0 || pr->killed){
    80209dfa:	fc843783          	ld	a5,-56(s0)
    80209dfe:	2087a783          	lw	a5,520(a5)
    80209e02:	c791                	beqz	a5,80209e0e <pipewrite+0x3c>
    80209e04:	fe043783          	ld	a5,-32(s0)
    80209e08:	0807a783          	lw	a5,128(a5)
    80209e0c:	c399                	beqz	a5,80209e12 <pipewrite+0x40>
      return -1;
    80209e0e:	57fd                	li	a5,-1
    80209e10:	a8c9                	j	80209ee2 <pipewrite+0x110>
    }
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80209e12:	fc843783          	ld	a5,-56(s0)
    80209e16:	2047a703          	lw	a4,516(a5)
    80209e1a:	fc843783          	ld	a5,-56(s0)
    80209e1e:	2007a783          	lw	a5,512(a5)
    80209e22:	2007879b          	addiw	a5,a5,512
    80209e26:	2781                	sext.w	a5,a5
    80209e28:	02f71663          	bne	a4,a5,80209e54 <pipewrite+0x82>
      wakeup(&pi->nread);
    80209e2c:	fc843783          	ld	a5,-56(s0)
    80209e30:	20078793          	addi	a5,a5,512
    80209e34:	853e                	mv	a0,a5
    80209e36:	ffffc097          	auipc	ra,0xffffc
    80209e3a:	fe4080e7          	jalr	-28(ra) # 80205e1a <wakeup>
      sleep(&pi->nwrite,NULL);
    80209e3e:	fc843783          	ld	a5,-56(s0)
    80209e42:	20478793          	addi	a5,a5,516
    80209e46:	4581                	li	a1,0
    80209e48:	853e                	mv	a0,a5
    80209e4a:	ffffc097          	auipc	ra,0xffffc
    80209e4e:	f18080e7          	jalr	-232(ra) # 80205d62 <sleep>
    80209e52:	a095                	j	80209eb6 <pipewrite+0xe4>
    } else {
      char ch;
      if(copyin(&ch, addr + i, 1) == -1)
    80209e54:	fec42703          	lw	a4,-20(s0)
    80209e58:	fc043783          	ld	a5,-64(s0)
    80209e5c:	973e                	add	a4,a4,a5
    80209e5e:	fdf40793          	addi	a5,s0,-33
    80209e62:	4605                	li	a2,1
    80209e64:	85ba                	mv	a1,a4
    80209e66:	853e                	mv	a0,a5
    80209e68:	ffffa097          	auipc	ra,0xffffa
    80209e6c:	1ea080e7          	jalr	490(ra) # 80204052 <copyin>
    80209e70:	87aa                	mv	a5,a0
    80209e72:	873e                	mv	a4,a5
    80209e74:	57fd                	li	a5,-1
    80209e76:	04f70a63          	beq	a4,a5,80209eca <pipewrite+0xf8>
        break;
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80209e7a:	fc843783          	ld	a5,-56(s0)
    80209e7e:	2047a783          	lw	a5,516(a5)
    80209e82:	2781                	sext.w	a5,a5
    80209e84:	0017871b          	addiw	a4,a5,1
    80209e88:	0007069b          	sext.w	a3,a4
    80209e8c:	fc843703          	ld	a4,-56(s0)
    80209e90:	20d72223          	sw	a3,516(a4)
    80209e94:	1ff7f793          	andi	a5,a5,511
    80209e98:	2781                	sext.w	a5,a5
    80209e9a:	fdf44703          	lbu	a4,-33(s0)
    80209e9e:	fc843683          	ld	a3,-56(s0)
    80209ea2:	1782                	slli	a5,a5,0x20
    80209ea4:	9381                	srli	a5,a5,0x20
    80209ea6:	97b6                	add	a5,a5,a3
    80209ea8:	00e78023          	sb	a4,0(a5)
      i++;
    80209eac:	fec42783          	lw	a5,-20(s0)
    80209eb0:	2785                	addiw	a5,a5,1
    80209eb2:	fef42623          	sw	a5,-20(s0)
  while(i < n){
    80209eb6:	fec42783          	lw	a5,-20(s0)
    80209eba:	873e                	mv	a4,a5
    80209ebc:	fbc42783          	lw	a5,-68(s0)
    80209ec0:	2701                	sext.w	a4,a4
    80209ec2:	2781                	sext.w	a5,a5
    80209ec4:	f2f74be3          	blt	a4,a5,80209dfa <pipewrite+0x28>
    80209ec8:	a011                	j	80209ecc <pipewrite+0xfa>
        break;
    80209eca:	0001                	nop
    }
  }
  wakeup(&pi->nread);
    80209ecc:	fc843783          	ld	a5,-56(s0)
    80209ed0:	20078793          	addi	a5,a5,512
    80209ed4:	853e                	mv	a0,a5
    80209ed6:	ffffc097          	auipc	ra,0xffffc
    80209eda:	f44080e7          	jalr	-188(ra) # 80205e1a <wakeup>
  return i;
    80209ede:	fec42783          	lw	a5,-20(s0)
}
    80209ee2:	853e                	mv	a0,a5
    80209ee4:	60a6                	ld	ra,72(sp)
    80209ee6:	6406                	ld	s0,64(sp)
    80209ee8:	6161                	addi	sp,sp,80
    80209eea:	8082                	ret

0000000080209eec <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80209eec:	715d                	addi	sp,sp,-80
    80209eee:	e486                	sd	ra,72(sp)
    80209ef0:	e0a2                	sd	s0,64(sp)
    80209ef2:	0880                	addi	s0,sp,80
    80209ef4:	fca43423          	sd	a0,-56(s0)
    80209ef8:	fcb43023          	sd	a1,-64(s0)
    80209efc:	87b2                	mv	a5,a2
    80209efe:	faf42e23          	sw	a5,-68(s0)
  int i;
  struct proc *pr = myproc();
    80209f02:	ffffb097          	auipc	ra,0xffffb
    80209f06:	13e080e7          	jalr	318(ra) # 80205040 <myproc>
    80209f0a:	fea43023          	sd	a0,-32(s0)
  char ch;
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80209f0e:	a015                	j	80209f32 <piperead+0x46>
    if(pr->killed){
    80209f10:	fe043783          	ld	a5,-32(s0)
    80209f14:	0807a783          	lw	a5,128(a5)
    80209f18:	c399                	beqz	a5,80209f1e <piperead+0x32>
      return -1;
    80209f1a:	57fd                	li	a5,-1
    80209f1c:	a0dd                	j	8020a002 <piperead+0x116>
    }
    sleep(&pi->nread,NULL); //DOC: piperead-sleep
    80209f1e:	fc843783          	ld	a5,-56(s0)
    80209f22:	20078793          	addi	a5,a5,512
    80209f26:	4581                	li	a1,0
    80209f28:	853e                	mv	a0,a5
    80209f2a:	ffffc097          	auipc	ra,0xffffc
    80209f2e:	e38080e7          	jalr	-456(ra) # 80205d62 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80209f32:	fc843783          	ld	a5,-56(s0)
    80209f36:	2007a703          	lw	a4,512(a5)
    80209f3a:	fc843783          	ld	a5,-56(s0)
    80209f3e:	2047a783          	lw	a5,516(a5)
    80209f42:	00f71763          	bne	a4,a5,80209f50 <piperead+0x64>
    80209f46:	fc843783          	ld	a5,-56(s0)
    80209f4a:	20c7a783          	lw	a5,524(a5)
    80209f4e:	f3e9                	bnez	a5,80209f10 <piperead+0x24>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80209f50:	fe042623          	sw	zero,-20(s0)
    80209f54:	a8bd                	j	80209fd2 <piperead+0xe6>
    if(pi->nread == pi->nwrite)
    80209f56:	fc843783          	ld	a5,-56(s0)
    80209f5a:	2007a703          	lw	a4,512(a5)
    80209f5e:	fc843783          	ld	a5,-56(s0)
    80209f62:	2047a783          	lw	a5,516(a5)
    80209f66:	08f70063          	beq	a4,a5,80209fe6 <piperead+0xfa>
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    80209f6a:	fc843783          	ld	a5,-56(s0)
    80209f6e:	2007a783          	lw	a5,512(a5)
    80209f72:	2781                	sext.w	a5,a5
    80209f74:	0017871b          	addiw	a4,a5,1
    80209f78:	0007069b          	sext.w	a3,a4
    80209f7c:	fc843703          	ld	a4,-56(s0)
    80209f80:	20d72023          	sw	a3,512(a4)
    80209f84:	1ff7f793          	andi	a5,a5,511
    80209f88:	2781                	sext.w	a5,a5
    80209f8a:	fc843703          	ld	a4,-56(s0)
    80209f8e:	1782                	slli	a5,a5,0x20
    80209f90:	9381                	srli	a5,a5,0x20
    80209f92:	97ba                	add	a5,a5,a4
    80209f94:	0007c783          	lbu	a5,0(a5)
    80209f98:	fcf40fa3          	sb	a5,-33(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80209f9c:	fe043783          	ld	a5,-32(s0)
    80209fa0:	7fc8                	ld	a0,184(a5)
    80209fa2:	fec42703          	lw	a4,-20(s0)
    80209fa6:	fc043783          	ld	a5,-64(s0)
    80209faa:	97ba                	add	a5,a5,a4
    80209fac:	fdf40713          	addi	a4,s0,-33
    80209fb0:	4685                	li	a3,1
    80209fb2:	863a                	mv	a2,a4
    80209fb4:	85be                	mv	a1,a5
    80209fb6:	ffffa097          	auipc	ra,0xffffa
    80209fba:	140080e7          	jalr	320(ra) # 802040f6 <copyout>
    80209fbe:	87aa                	mv	a5,a0
    80209fc0:	873e                	mv	a4,a5
    80209fc2:	57fd                	li	a5,-1
    80209fc4:	02f70363          	beq	a4,a5,80209fea <piperead+0xfe>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80209fc8:	fec42783          	lw	a5,-20(s0)
    80209fcc:	2785                	addiw	a5,a5,1
    80209fce:	fef42623          	sw	a5,-20(s0)
    80209fd2:	fec42783          	lw	a5,-20(s0)
    80209fd6:	873e                	mv	a4,a5
    80209fd8:	fbc42783          	lw	a5,-68(s0)
    80209fdc:	2701                	sext.w	a4,a4
    80209fde:	2781                	sext.w	a5,a5
    80209fe0:	f6f74be3          	blt	a4,a5,80209f56 <piperead+0x6a>
    80209fe4:	a021                	j	80209fec <piperead+0x100>
      break;
    80209fe6:	0001                	nop
    80209fe8:	a011                	j	80209fec <piperead+0x100>
      break;
    80209fea:	0001                	nop
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80209fec:	fc843783          	ld	a5,-56(s0)
    80209ff0:	20478793          	addi	a5,a5,516
    80209ff4:	853e                	mv	a0,a5
    80209ff6:	ffffc097          	auipc	ra,0xffffc
    80209ffa:	e24080e7          	jalr	-476(ra) # 80205e1a <wakeup>
  return i;
    80209ffe:	fec42783          	lw	a5,-20(s0)
}
    8020a002:	853e                	mv	a0,a5
    8020a004:	60a6                	ld	ra,72(sp)
    8020a006:	6406                	ld	s0,64(sp)
    8020a008:	6161                	addi	sp,sp,80
    8020a00a:	8082                	ret

000000008020a00c <readsb>:

struct superblock sb;
// Read the super block.
static void
readsb(int dev, struct superblock *sb)
{
    8020a00c:	7179                	addi	sp,sp,-48
    8020a00e:	f406                	sd	ra,40(sp)
    8020a010:	f022                	sd	s0,32(sp)
    8020a012:	1800                	addi	s0,sp,48
    8020a014:	87aa                	mv	a5,a0
    8020a016:	fcb43823          	sd	a1,-48(s0)
    8020a01a:	fcf42e23          	sw	a5,-36(s0)
	struct buf *bp;

	bp = bread(dev, 1);
    8020a01e:	fdc42783          	lw	a5,-36(s0)
    8020a022:	4585                	li	a1,1
    8020a024:	853e                	mv	a0,a5
    8020a026:	fffff097          	auipc	ra,0xfffff
    8020a02a:	ac0080e7          	jalr	-1344(ra) # 80208ae6 <bread>
    8020a02e:	fea43423          	sd	a0,-24(s0)
	memmove(sb, bp->data, sizeof(*sb));
    8020a032:	fe843783          	ld	a5,-24(s0)
    8020a036:	05078793          	addi	a5,a5,80
    8020a03a:	02000613          	li	a2,32
    8020a03e:	85be                	mv	a1,a5
    8020a040:	fd043503          	ld	a0,-48(s0)
    8020a044:	ffff8097          	auipc	ra,0xffff8
    8020a048:	f24080e7          	jalr	-220(ra) # 80201f68 <memmove>
	brelse(bp);
    8020a04c:	fe843503          	ld	a0,-24(s0)
    8020a050:	fffff097          	auipc	ra,0xfffff
    8020a054:	b38080e7          	jalr	-1224(ra) # 80208b88 <brelse>
}
    8020a058:	0001                	nop
    8020a05a:	70a2                	ld	ra,40(sp)
    8020a05c:	7402                	ld	s0,32(sp)
    8020a05e:	6145                	addi	sp,sp,48
    8020a060:	8082                	ret

000000008020a062 <fsinit>:

// Init fs
void fsinit(int dev)
{
    8020a062:	1101                	addi	sp,sp,-32
    8020a064:	ec06                	sd	ra,24(sp)
    8020a066:	e822                	sd	s0,16(sp)
    8020a068:	1000                	addi	s0,sp,32
    8020a06a:	87aa                	mv	a5,a0
    8020a06c:	fef42623          	sw	a5,-20(s0)
	readsb(dev, &sb);
    8020a070:	fec42783          	lw	a5,-20(s0)
    8020a074:	0003c597          	auipc	a1,0x3c
    8020a078:	f7c58593          	addi	a1,a1,-132 # 80245ff0 <sb>
    8020a07c:	853e                	mv	a0,a5
    8020a07e:	00000097          	auipc	ra,0x0
    8020a082:	f8e080e7          	jalr	-114(ra) # 8020a00c <readsb>
	if (sb.magic != FSMAGIC)
    8020a086:	0003c797          	auipc	a5,0x3c
    8020a08a:	f6a78793          	addi	a5,a5,-150 # 80245ff0 <sb>
    8020a08e:	439c                	lw	a5,0(a5)
    8020a090:	873e                	mv	a4,a5
    8020a092:	102037b7          	lui	a5,0x10203
    8020a096:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fffcfc0>
    8020a09a:	00f70a63          	beq	a4,a5,8020a0ae <fsinit+0x4c>
		panic("invalid file system");
    8020a09e:	0002c517          	auipc	a0,0x2c
    8020a0a2:	5ba50513          	addi	a0,a0,1466 # 80236658 <user_test_table+0x78>
    8020a0a6:	ffff7097          	auipc	ra,0xffff7
    8020a0aa:	734080e7          	jalr	1844(ra) # 802017da <panic>
	initlog(dev, &sb);
    8020a0ae:	fec42783          	lw	a5,-20(s0)
    8020a0b2:	0003c597          	auipc	a1,0x3c
    8020a0b6:	f3e58593          	addi	a1,a1,-194 # 80245ff0 <sb>
    8020a0ba:	853e                	mv	a0,a5
    8020a0bc:	fffff097          	auipc	ra,0xfffff
    8020a0c0:	d48080e7          	jalr	-696(ra) # 80208e04 <initlog>
	ireclaim(dev);
    8020a0c4:	fec42783          	lw	a5,-20(s0)
    8020a0c8:	853e                	mv	a0,a5
    8020a0ca:	00001097          	auipc	ra,0x1
    8020a0ce:	9b2080e7          	jalr	-1614(ra) # 8020aa7c <ireclaim>
	printf("fs init done\n");
    8020a0d2:	0002c517          	auipc	a0,0x2c
    8020a0d6:	59e50513          	addi	a0,a0,1438 # 80236670 <user_test_table+0x90>
    8020a0da:	ffff7097          	auipc	ra,0xffff7
    8020a0de:	cb4080e7          	jalr	-844(ra) # 80200d8e <printf>
}
    8020a0e2:	0001                	nop
    8020a0e4:	60e2                	ld	ra,24(sp)
    8020a0e6:	6442                	ld	s0,16(sp)
    8020a0e8:	6105                	addi	sp,sp,32
    8020a0ea:	8082                	ret

000000008020a0ec <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
    8020a0ec:	7179                	addi	sp,sp,-48
    8020a0ee:	f406                	sd	ra,40(sp)
    8020a0f0:	f022                	sd	s0,32(sp)
    8020a0f2:	1800                	addi	s0,sp,48
    8020a0f4:	87aa                	mv	a5,a0
    8020a0f6:	872e                	mv	a4,a1
    8020a0f8:	fcf42e23          	sw	a5,-36(s0)
    8020a0fc:	87ba                	mv	a5,a4
    8020a0fe:	fcf42c23          	sw	a5,-40(s0)
	struct buf *bp;

	bp = bread(dev, bno);
    8020a102:	fdc42783          	lw	a5,-36(s0)
    8020a106:	fd842703          	lw	a4,-40(s0)
    8020a10a:	85ba                	mv	a1,a4
    8020a10c:	853e                	mv	a0,a5
    8020a10e:	fffff097          	auipc	ra,0xfffff
    8020a112:	9d8080e7          	jalr	-1576(ra) # 80208ae6 <bread>
    8020a116:	fea43423          	sd	a0,-24(s0)
	memset(bp->data, 0, BSIZE);
    8020a11a:	fe843783          	ld	a5,-24(s0)
    8020a11e:	05078793          	addi	a5,a5,80
    8020a122:	40000613          	li	a2,1024
    8020a126:	4581                	li	a1,0
    8020a128:	853e                	mv	a0,a5
    8020a12a:	ffff8097          	auipc	ra,0xffff8
    8020a12e:	dee080e7          	jalr	-530(ra) # 80201f18 <memset>
	log_write(bp);
    8020a132:	fe843503          	ld	a0,-24(s0)
    8020a136:	fffff097          	auipc	ra,0xfffff
    8020a13a:	31e080e7          	jalr	798(ra) # 80209454 <log_write>
	brelse(bp);
    8020a13e:	fe843503          	ld	a0,-24(s0)
    8020a142:	fffff097          	auipc	ra,0xfffff
    8020a146:	a46080e7          	jalr	-1466(ra) # 80208b88 <brelse>
}
    8020a14a:	0001                	nop
    8020a14c:	70a2                	ld	ra,40(sp)
    8020a14e:	7402                	ld	s0,32(sp)
    8020a150:	6145                	addi	sp,sp,48
    8020a152:	8082                	ret

000000008020a154 <balloc>:

static uint
balloc(uint dev)
{
    8020a154:	7139                	addi	sp,sp,-64
    8020a156:	fc06                	sd	ra,56(sp)
    8020a158:	f822                	sd	s0,48(sp)
    8020a15a:	0080                	addi	s0,sp,64
    8020a15c:	87aa                	mv	a5,a0
    8020a15e:	fcf42623          	sw	a5,-52(s0)
	int b, bi, m;
	struct buf *bp;

	bp = 0;
    8020a162:	fe043023          	sd	zero,-32(s0)
	for (b = 0; b < sb.size; b += BPB)
    8020a166:	fe042623          	sw	zero,-20(s0)
    8020a16a:	a295                	j	8020a2ce <balloc+0x17a>
	{
		bp = bread(dev, BBLOCK(b, sb));
    8020a16c:	fec42783          	lw	a5,-20(s0)
    8020a170:	41f7d71b          	sraiw	a4,a5,0x1f
    8020a174:	0137571b          	srliw	a4,a4,0x13
    8020a178:	9fb9                	addw	a5,a5,a4
    8020a17a:	40d7d79b          	sraiw	a5,a5,0xd
    8020a17e:	2781                	sext.w	a5,a5
    8020a180:	0007871b          	sext.w	a4,a5
    8020a184:	0003c797          	auipc	a5,0x3c
    8020a188:	e6c78793          	addi	a5,a5,-404 # 80245ff0 <sb>
    8020a18c:	4fdc                	lw	a5,28(a5)
    8020a18e:	9fb9                	addw	a5,a5,a4
    8020a190:	0007871b          	sext.w	a4,a5
    8020a194:	fcc42783          	lw	a5,-52(s0)
    8020a198:	85ba                	mv	a1,a4
    8020a19a:	853e                	mv	a0,a5
    8020a19c:	fffff097          	auipc	ra,0xfffff
    8020a1a0:	94a080e7          	jalr	-1718(ra) # 80208ae6 <bread>
    8020a1a4:	fea43023          	sd	a0,-32(s0)
		for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    8020a1a8:	fe042423          	sw	zero,-24(s0)
    8020a1ac:	a8e9                	j	8020a286 <balloc+0x132>
		{
			m = 1 << (bi % 8);
    8020a1ae:	fe842783          	lw	a5,-24(s0)
    8020a1b2:	8b9d                	andi	a5,a5,7
    8020a1b4:	2781                	sext.w	a5,a5
    8020a1b6:	4705                	li	a4,1
    8020a1b8:	00f717bb          	sllw	a5,a4,a5
    8020a1bc:	fcf42e23          	sw	a5,-36(s0)
			if ((bp->data[bi / 8] & m) == 0)
    8020a1c0:	fe842783          	lw	a5,-24(s0)
    8020a1c4:	41f7d71b          	sraiw	a4,a5,0x1f
    8020a1c8:	01d7571b          	srliw	a4,a4,0x1d
    8020a1cc:	9fb9                	addw	a5,a5,a4
    8020a1ce:	4037d79b          	sraiw	a5,a5,0x3
    8020a1d2:	2781                	sext.w	a5,a5
    8020a1d4:	fe043703          	ld	a4,-32(s0)
    8020a1d8:	97ba                	add	a5,a5,a4
    8020a1da:	0507c783          	lbu	a5,80(a5)
    8020a1de:	2781                	sext.w	a5,a5
    8020a1e0:	fdc42703          	lw	a4,-36(s0)
    8020a1e4:	8ff9                	and	a5,a5,a4
    8020a1e6:	2781                	sext.w	a5,a5
    8020a1e8:	ebd1                	bnez	a5,8020a27c <balloc+0x128>
			{						   // Is block free?
				bp->data[bi / 8] |= m; // Mark block in use.
    8020a1ea:	fe842783          	lw	a5,-24(s0)
    8020a1ee:	41f7d71b          	sraiw	a4,a5,0x1f
    8020a1f2:	01d7571b          	srliw	a4,a4,0x1d
    8020a1f6:	9fb9                	addw	a5,a5,a4
    8020a1f8:	4037d79b          	sraiw	a5,a5,0x3
    8020a1fc:	2781                	sext.w	a5,a5
    8020a1fe:	fe043703          	ld	a4,-32(s0)
    8020a202:	973e                	add	a4,a4,a5
    8020a204:	05074703          	lbu	a4,80(a4)
    8020a208:	0187169b          	slliw	a3,a4,0x18
    8020a20c:	4186d69b          	sraiw	a3,a3,0x18
    8020a210:	fdc42703          	lw	a4,-36(s0)
    8020a214:	0187171b          	slliw	a4,a4,0x18
    8020a218:	4187571b          	sraiw	a4,a4,0x18
    8020a21c:	8f55                	or	a4,a4,a3
    8020a21e:	0187171b          	slliw	a4,a4,0x18
    8020a222:	4187571b          	sraiw	a4,a4,0x18
    8020a226:	0ff77713          	zext.b	a4,a4
    8020a22a:	fe043683          	ld	a3,-32(s0)
    8020a22e:	97b6                	add	a5,a5,a3
    8020a230:	04e78823          	sb	a4,80(a5)
				log_write(bp);
    8020a234:	fe043503          	ld	a0,-32(s0)
    8020a238:	fffff097          	auipc	ra,0xfffff
    8020a23c:	21c080e7          	jalr	540(ra) # 80209454 <log_write>
				brelse(bp);
    8020a240:	fe043503          	ld	a0,-32(s0)
    8020a244:	fffff097          	auipc	ra,0xfffff
    8020a248:	944080e7          	jalr	-1724(ra) # 80208b88 <brelse>
				bzero(dev, b + bi);
    8020a24c:	fcc42783          	lw	a5,-52(s0)
    8020a250:	fec42703          	lw	a4,-20(s0)
    8020a254:	86ba                	mv	a3,a4
    8020a256:	fe842703          	lw	a4,-24(s0)
    8020a25a:	9f35                	addw	a4,a4,a3
    8020a25c:	2701                	sext.w	a4,a4
    8020a25e:	85ba                	mv	a1,a4
    8020a260:	853e                	mv	a0,a5
    8020a262:	00000097          	auipc	ra,0x0
    8020a266:	e8a080e7          	jalr	-374(ra) # 8020a0ec <bzero>
				return b + bi;
    8020a26a:	fec42783          	lw	a5,-20(s0)
    8020a26e:	873e                	mv	a4,a5
    8020a270:	fe842783          	lw	a5,-24(s0)
    8020a274:	9fb9                	addw	a5,a5,a4
    8020a276:	2781                	sext.w	a5,a5
    8020a278:	2781                	sext.w	a5,a5
    8020a27a:	a8a5                	j	8020a2f2 <balloc+0x19e>
		for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    8020a27c:	fe842783          	lw	a5,-24(s0)
    8020a280:	2785                	addiw	a5,a5,1
    8020a282:	fef42423          	sw	a5,-24(s0)
    8020a286:	fe842783          	lw	a5,-24(s0)
    8020a28a:	0007871b          	sext.w	a4,a5
    8020a28e:	6789                	lui	a5,0x2
    8020a290:	02f75263          	bge	a4,a5,8020a2b4 <balloc+0x160>
    8020a294:	fec42783          	lw	a5,-20(s0)
    8020a298:	873e                	mv	a4,a5
    8020a29a:	fe842783          	lw	a5,-24(s0)
    8020a29e:	9fb9                	addw	a5,a5,a4
    8020a2a0:	2781                	sext.w	a5,a5
    8020a2a2:	0007871b          	sext.w	a4,a5
    8020a2a6:	0003c797          	auipc	a5,0x3c
    8020a2aa:	d4a78793          	addi	a5,a5,-694 # 80245ff0 <sb>
    8020a2ae:	43dc                	lw	a5,4(a5)
    8020a2b0:	eef76fe3          	bltu	a4,a5,8020a1ae <balloc+0x5a>
			}
		}
		brelse(bp);
    8020a2b4:	fe043503          	ld	a0,-32(s0)
    8020a2b8:	fffff097          	auipc	ra,0xfffff
    8020a2bc:	8d0080e7          	jalr	-1840(ra) # 80208b88 <brelse>
	for (b = 0; b < sb.size; b += BPB)
    8020a2c0:	fec42783          	lw	a5,-20(s0)
    8020a2c4:	873e                	mv	a4,a5
    8020a2c6:	6789                	lui	a5,0x2
    8020a2c8:	9fb9                	addw	a5,a5,a4
    8020a2ca:	fef42623          	sw	a5,-20(s0)
    8020a2ce:	0003c797          	auipc	a5,0x3c
    8020a2d2:	d2278793          	addi	a5,a5,-734 # 80245ff0 <sb>
    8020a2d6:	43d8                	lw	a4,4(a5)
    8020a2d8:	fec42783          	lw	a5,-20(s0)
    8020a2dc:	e8e7e8e3          	bltu	a5,a4,8020a16c <balloc+0x18>
	}
	printf("balloc: out of blocks\n");
    8020a2e0:	0002c517          	auipc	a0,0x2c
    8020a2e4:	3a050513          	addi	a0,a0,928 # 80236680 <user_test_table+0xa0>
    8020a2e8:	ffff7097          	auipc	ra,0xffff7
    8020a2ec:	aa6080e7          	jalr	-1370(ra) # 80200d8e <printf>
	return 0;
    8020a2f0:	4781                	li	a5,0
}
    8020a2f2:	853e                	mv	a0,a5
    8020a2f4:	70e2                	ld	ra,56(sp)
    8020a2f6:	7442                	ld	s0,48(sp)
    8020a2f8:	6121                	addi	sp,sp,64
    8020a2fa:	8082                	ret

000000008020a2fc <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8020a2fc:	7179                	addi	sp,sp,-48
    8020a2fe:	f406                	sd	ra,40(sp)
    8020a300:	f022                	sd	s0,32(sp)
    8020a302:	1800                	addi	s0,sp,48
    8020a304:	87aa                	mv	a5,a0
    8020a306:	872e                	mv	a4,a1
    8020a308:	fcf42e23          	sw	a5,-36(s0)
    8020a30c:	87ba                	mv	a5,a4
    8020a30e:	fcf42c23          	sw	a5,-40(s0)
	struct buf *bp;
	int bi, m;

	bp = bread(dev, BBLOCK(b, sb));
    8020a312:	fdc42683          	lw	a3,-36(s0)
    8020a316:	fd842783          	lw	a5,-40(s0)
    8020a31a:	00d7d79b          	srliw	a5,a5,0xd
    8020a31e:	0007871b          	sext.w	a4,a5
    8020a322:	0003c797          	auipc	a5,0x3c
    8020a326:	cce78793          	addi	a5,a5,-818 # 80245ff0 <sb>
    8020a32a:	4fdc                	lw	a5,28(a5)
    8020a32c:	9fb9                	addw	a5,a5,a4
    8020a32e:	2781                	sext.w	a5,a5
    8020a330:	85be                	mv	a1,a5
    8020a332:	8536                	mv	a0,a3
    8020a334:	ffffe097          	auipc	ra,0xffffe
    8020a338:	7b2080e7          	jalr	1970(ra) # 80208ae6 <bread>
    8020a33c:	fea43423          	sd	a0,-24(s0)
	bi = b % BPB;
    8020a340:	fd842703          	lw	a4,-40(s0)
    8020a344:	6789                	lui	a5,0x2
    8020a346:	17fd                	addi	a5,a5,-1 # 1fff <_entry-0x801fe001>
    8020a348:	8ff9                	and	a5,a5,a4
    8020a34a:	fef42223          	sw	a5,-28(s0)
	m = 1 << (bi % 8);
    8020a34e:	fe442783          	lw	a5,-28(s0)
    8020a352:	8b9d                	andi	a5,a5,7
    8020a354:	2781                	sext.w	a5,a5
    8020a356:	4705                	li	a4,1
    8020a358:	00f717bb          	sllw	a5,a4,a5
    8020a35c:	fef42023          	sw	a5,-32(s0)
	if ((bp->data[bi / 8] & m) == 0)
    8020a360:	fe442783          	lw	a5,-28(s0)
    8020a364:	41f7d71b          	sraiw	a4,a5,0x1f
    8020a368:	01d7571b          	srliw	a4,a4,0x1d
    8020a36c:	9fb9                	addw	a5,a5,a4
    8020a36e:	4037d79b          	sraiw	a5,a5,0x3
    8020a372:	2781                	sext.w	a5,a5
    8020a374:	fe843703          	ld	a4,-24(s0)
    8020a378:	97ba                	add	a5,a5,a4
    8020a37a:	0507c783          	lbu	a5,80(a5)
    8020a37e:	2781                	sext.w	a5,a5
    8020a380:	fe042703          	lw	a4,-32(s0)
    8020a384:	8ff9                	and	a5,a5,a4
    8020a386:	2781                	sext.w	a5,a5
    8020a388:	eb89                	bnez	a5,8020a39a <bfree+0x9e>
		panic("freeing free block");
    8020a38a:	0002c517          	auipc	a0,0x2c
    8020a38e:	30e50513          	addi	a0,a0,782 # 80236698 <user_test_table+0xb8>
    8020a392:	ffff7097          	auipc	ra,0xffff7
    8020a396:	448080e7          	jalr	1096(ra) # 802017da <panic>
	bp->data[bi / 8] &= ~m;
    8020a39a:	fe442783          	lw	a5,-28(s0)
    8020a39e:	41f7d71b          	sraiw	a4,a5,0x1f
    8020a3a2:	01d7571b          	srliw	a4,a4,0x1d
    8020a3a6:	9fb9                	addw	a5,a5,a4
    8020a3a8:	4037d79b          	sraiw	a5,a5,0x3
    8020a3ac:	2781                	sext.w	a5,a5
    8020a3ae:	fe843703          	ld	a4,-24(s0)
    8020a3b2:	973e                	add	a4,a4,a5
    8020a3b4:	05074703          	lbu	a4,80(a4)
    8020a3b8:	0187169b          	slliw	a3,a4,0x18
    8020a3bc:	4186d69b          	sraiw	a3,a3,0x18
    8020a3c0:	fe042703          	lw	a4,-32(s0)
    8020a3c4:	0187171b          	slliw	a4,a4,0x18
    8020a3c8:	4187571b          	sraiw	a4,a4,0x18
    8020a3cc:	fff74713          	not	a4,a4
    8020a3d0:	0187171b          	slliw	a4,a4,0x18
    8020a3d4:	4187571b          	sraiw	a4,a4,0x18
    8020a3d8:	8f75                	and	a4,a4,a3
    8020a3da:	0187171b          	slliw	a4,a4,0x18
    8020a3de:	4187571b          	sraiw	a4,a4,0x18
    8020a3e2:	0ff77713          	zext.b	a4,a4
    8020a3e6:	fe843683          	ld	a3,-24(s0)
    8020a3ea:	97b6                	add	a5,a5,a3
    8020a3ec:	04e78823          	sb	a4,80(a5)
	log_write(bp);
    8020a3f0:	fe843503          	ld	a0,-24(s0)
    8020a3f4:	fffff097          	auipc	ra,0xfffff
    8020a3f8:	060080e7          	jalr	96(ra) # 80209454 <log_write>
	brelse(bp);
    8020a3fc:	fe843503          	ld	a0,-24(s0)
    8020a400:	ffffe097          	auipc	ra,0xffffe
    8020a404:	788080e7          	jalr	1928(ra) # 80208b88 <brelse>
}
    8020a408:	0001                	nop
    8020a40a:	70a2                	ld	ra,40(sp)
    8020a40c:	7402                	ld	s0,32(sp)
    8020a40e:	6145                	addi	sp,sp,48
    8020a410:	8082                	ret

000000008020a412 <iinit>:
	struct spinlock lock;
	struct inode inode[NINODE];
} itable;

void iinit()
{
    8020a412:	1101                	addi	sp,sp,-32
    8020a414:	ec06                	sd	ra,24(sp)
    8020a416:	e822                	sd	s0,16(sp)
    8020a418:	1000                	addi	s0,sp,32
	int i = 0;
    8020a41a:	fe042623          	sw	zero,-20(s0)

	initlock(&itable.lock, "itable");
    8020a41e:	0002c597          	auipc	a1,0x2c
    8020a422:	29258593          	addi	a1,a1,658 # 802366b0 <user_test_table+0xd0>
    8020a426:	0003c517          	auipc	a0,0x3c
    8020a42a:	bea50513          	addi	a0,a0,-1046 # 80246010 <itable>
    8020a42e:	00001097          	auipc	ra,0x1
    8020a432:	6d2080e7          	jalr	1746(ra) # 8020bb00 <initlock>
	for (i = 0; i < NINODE; i++)
    8020a436:	fe042623          	sw	zero,-20(s0)
    8020a43a:	a815                	j	8020a46e <iinit+0x5c>
	{
		initsleeplock(&itable.inode[i].lock, "inode");
    8020a43c:	fec42783          	lw	a5,-20(s0)
    8020a440:	079e                	slli	a5,a5,0x7
    8020a442:	06078713          	addi	a4,a5,96
    8020a446:	0003c797          	auipc	a5,0x3c
    8020a44a:	bca78793          	addi	a5,a5,-1078 # 80246010 <itable>
    8020a44e:	97ba                	add	a5,a5,a4
    8020a450:	07a1                	addi	a5,a5,8
    8020a452:	0002c597          	auipc	a1,0x2c
    8020a456:	26658593          	addi	a1,a1,614 # 802366b8 <user_test_table+0xd8>
    8020a45a:	853e                	mv	a0,a5
    8020a45c:	00001097          	auipc	ra,0x1
    8020a460:	778080e7          	jalr	1912(ra) # 8020bbd4 <initsleeplock>
	for (i = 0; i < NINODE; i++)
    8020a464:	fec42783          	lw	a5,-20(s0)
    8020a468:	2785                	addiw	a5,a5,1
    8020a46a:	fef42623          	sw	a5,-20(s0)
    8020a46e:	fec42783          	lw	a5,-20(s0)
    8020a472:	0007871b          	sext.w	a4,a5
    8020a476:	03100793          	li	a5,49
    8020a47a:	fce7d1e3          	bge	a5,a4,8020a43c <iinit+0x2a>
	}
	printf("iinit done \n");
    8020a47e:	0002c517          	auipc	a0,0x2c
    8020a482:	24250513          	addi	a0,a0,578 # 802366c0 <user_test_table+0xe0>
    8020a486:	ffff7097          	auipc	ra,0xffff7
    8020a48a:	908080e7          	jalr	-1784(ra) # 80200d8e <printf>
}
    8020a48e:	0001                	nop
    8020a490:	60e2                	ld	ra,24(sp)
    8020a492:	6442                	ld	s0,16(sp)
    8020a494:	6105                	addi	sp,sp,32
    8020a496:	8082                	ret

000000008020a498 <ialloc>:

struct inode *
ialloc(uint dev, short type)
{
    8020a498:	7139                	addi	sp,sp,-64
    8020a49a:	fc06                	sd	ra,56(sp)
    8020a49c:	f822                	sd	s0,48(sp)
    8020a49e:	0080                	addi	s0,sp,64
    8020a4a0:	87aa                	mv	a5,a0
    8020a4a2:	872e                	mv	a4,a1
    8020a4a4:	fcf42623          	sw	a5,-52(s0)
    8020a4a8:	87ba                	mv	a5,a4
    8020a4aa:	fcf41523          	sh	a5,-54(s0)
	int inum;
	struct buf *bp;
	struct dinode *dip;

	for (inum = 1; inum < sb.ninodes; inum++)
    8020a4ae:	4785                	li	a5,1
    8020a4b0:	fef42623          	sw	a5,-20(s0)
    8020a4b4:	a855                	j	8020a568 <ialloc+0xd0>
	{
		bp = bread(dev, IBLOCK(inum, sb));
    8020a4b6:	fec42783          	lw	a5,-20(s0)
    8020a4ba:	8391                	srli	a5,a5,0x4
    8020a4bc:	0007871b          	sext.w	a4,a5
    8020a4c0:	0003c797          	auipc	a5,0x3c
    8020a4c4:	b3078793          	addi	a5,a5,-1232 # 80245ff0 <sb>
    8020a4c8:	4f9c                	lw	a5,24(a5)
    8020a4ca:	9fb9                	addw	a5,a5,a4
    8020a4cc:	0007871b          	sext.w	a4,a5
    8020a4d0:	fcc42783          	lw	a5,-52(s0)
    8020a4d4:	85ba                	mv	a1,a4
    8020a4d6:	853e                	mv	a0,a5
    8020a4d8:	ffffe097          	auipc	ra,0xffffe
    8020a4dc:	60e080e7          	jalr	1550(ra) # 80208ae6 <bread>
    8020a4e0:	fea43023          	sd	a0,-32(s0)
		dip = (struct dinode *)bp->data + inum % IPB;
    8020a4e4:	fe043783          	ld	a5,-32(s0)
    8020a4e8:	05078713          	addi	a4,a5,80
    8020a4ec:	fec42783          	lw	a5,-20(s0)
    8020a4f0:	8bbd                	andi	a5,a5,15
    8020a4f2:	079a                	slli	a5,a5,0x6
    8020a4f4:	97ba                	add	a5,a5,a4
    8020a4f6:	fcf43c23          	sd	a5,-40(s0)
		if (dip->type == 0)
    8020a4fa:	fd843783          	ld	a5,-40(s0)
    8020a4fe:	00079783          	lh	a5,0(a5)
    8020a502:	eba1                	bnez	a5,8020a552 <ialloc+0xba>
		{ // a free inode
			memset(dip, 0, sizeof(*dip));
    8020a504:	04000613          	li	a2,64
    8020a508:	4581                	li	a1,0
    8020a50a:	fd843503          	ld	a0,-40(s0)
    8020a50e:	ffff8097          	auipc	ra,0xffff8
    8020a512:	a0a080e7          	jalr	-1526(ra) # 80201f18 <memset>
			dip->type = type;
    8020a516:	fd843783          	ld	a5,-40(s0)
    8020a51a:	fca45703          	lhu	a4,-54(s0)
    8020a51e:	00e79023          	sh	a4,0(a5)
			log_write(bp); // mark it allocated on the disk
    8020a522:	fe043503          	ld	a0,-32(s0)
    8020a526:	fffff097          	auipc	ra,0xfffff
    8020a52a:	f2e080e7          	jalr	-210(ra) # 80209454 <log_write>
			brelse(bp);
    8020a52e:	fe043503          	ld	a0,-32(s0)
    8020a532:	ffffe097          	auipc	ra,0xffffe
    8020a536:	656080e7          	jalr	1622(ra) # 80208b88 <brelse>
			return iget(dev, inum);
    8020a53a:	fec42703          	lw	a4,-20(s0)
    8020a53e:	fcc42783          	lw	a5,-52(s0)
    8020a542:	85ba                	mv	a1,a4
    8020a544:	853e                	mv	a0,a5
    8020a546:	00000097          	auipc	ra,0x0
    8020a54a:	138080e7          	jalr	312(ra) # 8020a67e <iget>
    8020a54e:	87aa                	mv	a5,a0
    8020a550:	a835                	j	8020a58c <ialloc+0xf4>
		}
		brelse(bp);
    8020a552:	fe043503          	ld	a0,-32(s0)
    8020a556:	ffffe097          	auipc	ra,0xffffe
    8020a55a:	632080e7          	jalr	1586(ra) # 80208b88 <brelse>
	for (inum = 1; inum < sb.ninodes; inum++)
    8020a55e:	fec42783          	lw	a5,-20(s0)
    8020a562:	2785                	addiw	a5,a5,1
    8020a564:	fef42623          	sw	a5,-20(s0)
    8020a568:	0003c797          	auipc	a5,0x3c
    8020a56c:	a8878793          	addi	a5,a5,-1400 # 80245ff0 <sb>
    8020a570:	47d8                	lw	a4,12(a5)
    8020a572:	fec42783          	lw	a5,-20(s0)
    8020a576:	f4e7e0e3          	bltu	a5,a4,8020a4b6 <ialloc+0x1e>
	}
	printf("ialloc: no inodes\n");
    8020a57a:	0002c517          	auipc	a0,0x2c
    8020a57e:	15650513          	addi	a0,a0,342 # 802366d0 <user_test_table+0xf0>
    8020a582:	ffff7097          	auipc	ra,0xffff7
    8020a586:	80c080e7          	jalr	-2036(ra) # 80200d8e <printf>
	return 0;
    8020a58a:	4781                	li	a5,0
}
    8020a58c:	853e                	mv	a0,a5
    8020a58e:	70e2                	ld	ra,56(sp)
    8020a590:	7442                	ld	s0,48(sp)
    8020a592:	6121                	addi	sp,sp,64
    8020a594:	8082                	ret

000000008020a596 <iupdate>:

void iupdate(struct inode *ip)
{
    8020a596:	7179                	addi	sp,sp,-48
    8020a598:	f406                	sd	ra,40(sp)
    8020a59a:	f022                	sd	s0,32(sp)
    8020a59c:	1800                	addi	s0,sp,48
    8020a59e:	fca43c23          	sd	a0,-40(s0)
	struct buf *bp;
	struct dinode *dip;

	bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8020a5a2:	fd843783          	ld	a5,-40(s0)
    8020a5a6:	4394                	lw	a3,0(a5)
    8020a5a8:	fd843783          	ld	a5,-40(s0)
    8020a5ac:	43dc                	lw	a5,4(a5)
    8020a5ae:	0047d79b          	srliw	a5,a5,0x4
    8020a5b2:	0007871b          	sext.w	a4,a5
    8020a5b6:	0003c797          	auipc	a5,0x3c
    8020a5ba:	a3a78793          	addi	a5,a5,-1478 # 80245ff0 <sb>
    8020a5be:	4f9c                	lw	a5,24(a5)
    8020a5c0:	9fb9                	addw	a5,a5,a4
    8020a5c2:	2781                	sext.w	a5,a5
    8020a5c4:	85be                	mv	a1,a5
    8020a5c6:	8536                	mv	a0,a3
    8020a5c8:	ffffe097          	auipc	ra,0xffffe
    8020a5cc:	51e080e7          	jalr	1310(ra) # 80208ae6 <bread>
    8020a5d0:	fea43423          	sd	a0,-24(s0)
	dip = (struct dinode *)bp->data + ip->inum % IPB;
    8020a5d4:	fe843783          	ld	a5,-24(s0)
    8020a5d8:	05078713          	addi	a4,a5,80
    8020a5dc:	fd843783          	ld	a5,-40(s0)
    8020a5e0:	43dc                	lw	a5,4(a5)
    8020a5e2:	1782                	slli	a5,a5,0x20
    8020a5e4:	9381                	srli	a5,a5,0x20
    8020a5e6:	8bbd                	andi	a5,a5,15
    8020a5e8:	079a                	slli	a5,a5,0x6
    8020a5ea:	97ba                	add	a5,a5,a4
    8020a5ec:	fef43023          	sd	a5,-32(s0)
	dip->type = ip->type;
    8020a5f0:	fd843783          	ld	a5,-40(s0)
    8020a5f4:	01479703          	lh	a4,20(a5)
    8020a5f8:	fe043783          	ld	a5,-32(s0)
    8020a5fc:	00e79023          	sh	a4,0(a5)
	dip->major = ip->major;
    8020a600:	fd843783          	ld	a5,-40(s0)
    8020a604:	01679703          	lh	a4,22(a5)
    8020a608:	fe043783          	ld	a5,-32(s0)
    8020a60c:	00e79123          	sh	a4,2(a5)
	dip->minor = ip->minor;
    8020a610:	fd843783          	ld	a5,-40(s0)
    8020a614:	01879703          	lh	a4,24(a5)
    8020a618:	fe043783          	ld	a5,-32(s0)
    8020a61c:	00e79223          	sh	a4,4(a5)
	dip->nlink = ip->nlink;
    8020a620:	fd843783          	ld	a5,-40(s0)
    8020a624:	01a79703          	lh	a4,26(a5)
    8020a628:	fe043783          	ld	a5,-32(s0)
    8020a62c:	00e79323          	sh	a4,6(a5)
	dip->size = ip->size;
    8020a630:	fd843783          	ld	a5,-40(s0)
    8020a634:	4fd8                	lw	a4,28(a5)
    8020a636:	fe043783          	ld	a5,-32(s0)
    8020a63a:	c798                	sw	a4,8(a5)
	memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8020a63c:	fe043783          	ld	a5,-32(s0)
    8020a640:	00c78713          	addi	a4,a5,12
    8020a644:	fd843783          	ld	a5,-40(s0)
    8020a648:	02078793          	addi	a5,a5,32
    8020a64c:	03400613          	li	a2,52
    8020a650:	85be                	mv	a1,a5
    8020a652:	853a                	mv	a0,a4
    8020a654:	ffff8097          	auipc	ra,0xffff8
    8020a658:	914080e7          	jalr	-1772(ra) # 80201f68 <memmove>
	log_write(bp);
    8020a65c:	fe843503          	ld	a0,-24(s0)
    8020a660:	fffff097          	auipc	ra,0xfffff
    8020a664:	df4080e7          	jalr	-524(ra) # 80209454 <log_write>
	brelse(bp);
    8020a668:	fe843503          	ld	a0,-24(s0)
    8020a66c:	ffffe097          	auipc	ra,0xffffe
    8020a670:	51c080e7          	jalr	1308(ra) # 80208b88 <brelse>
}
    8020a674:	0001                	nop
    8020a676:	70a2                	ld	ra,40(sp)
    8020a678:	7402                	ld	s0,32(sp)
    8020a67a:	6145                	addi	sp,sp,48
    8020a67c:	8082                	ret

000000008020a67e <iget>:
struct inode *
iget(uint dev, uint inum)
{
    8020a67e:	7179                	addi	sp,sp,-48
    8020a680:	f406                	sd	ra,40(sp)
    8020a682:	f022                	sd	s0,32(sp)
    8020a684:	1800                	addi	s0,sp,48
    8020a686:	87aa                	mv	a5,a0
    8020a688:	872e                	mv	a4,a1
    8020a68a:	fcf42e23          	sw	a5,-36(s0)
    8020a68e:	87ba                	mv	a5,a4
    8020a690:	fcf42c23          	sw	a5,-40(s0)
	struct inode *ip, *empty;
	acquire(&itable.lock);
    8020a694:	0003c517          	auipc	a0,0x3c
    8020a698:	97c50513          	addi	a0,a0,-1668 # 80246010 <itable>
    8020a69c:	00001097          	auipc	ra,0x1
    8020a6a0:	48c080e7          	jalr	1164(ra) # 8020bb28 <acquire>
	// Is the inode already in the table?
	empty = 0;
    8020a6a4:	fe043023          	sd	zero,-32(s0)
	for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++)
    8020a6a8:	0003c797          	auipc	a5,0x3c
    8020a6ac:	97878793          	addi	a5,a5,-1672 # 80246020 <itable+0x10>
    8020a6b0:	fef43423          	sd	a5,-24(s0)
    8020a6b4:	a89d                	j	8020a72a <iget+0xac>
	{
		if (ip->ref > 0 && ip->dev == dev && ip->inum == inum)
    8020a6b6:	fe843783          	ld	a5,-24(s0)
    8020a6ba:	479c                	lw	a5,8(a5)
    8020a6bc:	04f05663          	blez	a5,8020a708 <iget+0x8a>
    8020a6c0:	fe843783          	ld	a5,-24(s0)
    8020a6c4:	4398                	lw	a4,0(a5)
    8020a6c6:	fdc42783          	lw	a5,-36(s0)
    8020a6ca:	2781                	sext.w	a5,a5
    8020a6cc:	02e79e63          	bne	a5,a4,8020a708 <iget+0x8a>
    8020a6d0:	fe843783          	ld	a5,-24(s0)
    8020a6d4:	43d8                	lw	a4,4(a5)
    8020a6d6:	fd842783          	lw	a5,-40(s0)
    8020a6da:	2781                	sext.w	a5,a5
    8020a6dc:	02e79663          	bne	a5,a4,8020a708 <iget+0x8a>
		{
			ip->ref++;
    8020a6e0:	fe843783          	ld	a5,-24(s0)
    8020a6e4:	479c                	lw	a5,8(a5)
    8020a6e6:	2785                	addiw	a5,a5,1
    8020a6e8:	0007871b          	sext.w	a4,a5
    8020a6ec:	fe843783          	ld	a5,-24(s0)
    8020a6f0:	c798                	sw	a4,8(a5)
			release(&itable.lock);
    8020a6f2:	0003c517          	auipc	a0,0x3c
    8020a6f6:	91e50513          	addi	a0,a0,-1762 # 80246010 <itable>
    8020a6fa:	00001097          	auipc	ra,0x1
    8020a6fe:	47a080e7          	jalr	1146(ra) # 8020bb74 <release>
			return ip;
    8020a702:	fe843783          	ld	a5,-24(s0)
    8020a706:	a069                	j	8020a790 <iget+0x112>
		}
		if (empty == 0 && ip->ref == 0) // Remember empty slot.
    8020a708:	fe043783          	ld	a5,-32(s0)
    8020a70c:	eb89                	bnez	a5,8020a71e <iget+0xa0>
    8020a70e:	fe843783          	ld	a5,-24(s0)
    8020a712:	479c                	lw	a5,8(a5)
    8020a714:	e789                	bnez	a5,8020a71e <iget+0xa0>
			empty = ip;
    8020a716:	fe843783          	ld	a5,-24(s0)
    8020a71a:	fef43023          	sd	a5,-32(s0)
	for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++)
    8020a71e:	fe843783          	ld	a5,-24(s0)
    8020a722:	08078793          	addi	a5,a5,128
    8020a726:	fef43423          	sd	a5,-24(s0)
    8020a72a:	fe843703          	ld	a4,-24(s0)
    8020a72e:	0003d797          	auipc	a5,0x3d
    8020a732:	1f278793          	addi	a5,a5,498 # 80247920 <_bss_end>
    8020a736:	f8f760e3          	bltu	a4,a5,8020a6b6 <iget+0x38>
	}

	// Recycle an inode entry.
	if (empty == 0)
    8020a73a:	fe043783          	ld	a5,-32(s0)
    8020a73e:	eb89                	bnez	a5,8020a750 <iget+0xd2>
		panic("iget: no inodes");
    8020a740:	0002c517          	auipc	a0,0x2c
    8020a744:	fa850513          	addi	a0,a0,-88 # 802366e8 <user_test_table+0x108>
    8020a748:	ffff7097          	auipc	ra,0xffff7
    8020a74c:	092080e7          	jalr	146(ra) # 802017da <panic>

	ip = empty;
    8020a750:	fe043783          	ld	a5,-32(s0)
    8020a754:	fef43423          	sd	a5,-24(s0)
	ip->dev = dev;
    8020a758:	fe843783          	ld	a5,-24(s0)
    8020a75c:	fdc42703          	lw	a4,-36(s0)
    8020a760:	c398                	sw	a4,0(a5)
	ip->inum = inum;
    8020a762:	fe843783          	ld	a5,-24(s0)
    8020a766:	fd842703          	lw	a4,-40(s0)
    8020a76a:	c3d8                	sw	a4,4(a5)
	ip->ref = 1;
    8020a76c:	fe843783          	ld	a5,-24(s0)
    8020a770:	4705                	li	a4,1
    8020a772:	c798                	sw	a4,8(a5)
	ip->valid = 0;
    8020a774:	fe843783          	ld	a5,-24(s0)
    8020a778:	0007a623          	sw	zero,12(a5)
	release(&itable.lock);
    8020a77c:	0003c517          	auipc	a0,0x3c
    8020a780:	89450513          	addi	a0,a0,-1900 # 80246010 <itable>
    8020a784:	00001097          	auipc	ra,0x1
    8020a788:	3f0080e7          	jalr	1008(ra) # 8020bb74 <release>
	return ip;
    8020a78c:	fe843783          	ld	a5,-24(s0)
}
    8020a790:	853e                	mv	a0,a5
    8020a792:	70a2                	ld	ra,40(sp)
    8020a794:	7402                	ld	s0,32(sp)
    8020a796:	6145                	addi	sp,sp,48
    8020a798:	8082                	ret

000000008020a79a <idup>:

struct inode *
idup(struct inode *ip)
{
    8020a79a:	1101                	addi	sp,sp,-32
    8020a79c:	ec06                	sd	ra,24(sp)
    8020a79e:	e822                	sd	s0,16(sp)
    8020a7a0:	1000                	addi	s0,sp,32
    8020a7a2:	fea43423          	sd	a0,-24(s0)
	acquire(&itable.lock);
    8020a7a6:	0003c517          	auipc	a0,0x3c
    8020a7aa:	86a50513          	addi	a0,a0,-1942 # 80246010 <itable>
    8020a7ae:	00001097          	auipc	ra,0x1
    8020a7b2:	37a080e7          	jalr	890(ra) # 8020bb28 <acquire>
	ip->ref++;
    8020a7b6:	fe843783          	ld	a5,-24(s0)
    8020a7ba:	479c                	lw	a5,8(a5)
    8020a7bc:	2785                	addiw	a5,a5,1
    8020a7be:	0007871b          	sext.w	a4,a5
    8020a7c2:	fe843783          	ld	a5,-24(s0)
    8020a7c6:	c798                	sw	a4,8(a5)
	release(&itable.lock);
    8020a7c8:	0003c517          	auipc	a0,0x3c
    8020a7cc:	84850513          	addi	a0,a0,-1976 # 80246010 <itable>
    8020a7d0:	00001097          	auipc	ra,0x1
    8020a7d4:	3a4080e7          	jalr	932(ra) # 8020bb74 <release>
	return ip;
    8020a7d8:	fe843783          	ld	a5,-24(s0)
}
    8020a7dc:	853e                	mv	a0,a5
    8020a7de:	60e2                	ld	ra,24(sp)
    8020a7e0:	6442                	ld	s0,16(sp)
    8020a7e2:	6105                	addi	sp,sp,32
    8020a7e4:	8082                	ret

000000008020a7e6 <ilock>:

void ilock(struct inode *ip)
{
    8020a7e6:	7179                	addi	sp,sp,-48
    8020a7e8:	f406                	sd	ra,40(sp)
    8020a7ea:	f022                	sd	s0,32(sp)
    8020a7ec:	1800                	addi	s0,sp,48
    8020a7ee:	fca43c23          	sd	a0,-40(s0)
	struct buf *bp;
	struct dinode *dip;

	if (ip == 0 || ip->ref < 1)
    8020a7f2:	fd843783          	ld	a5,-40(s0)
    8020a7f6:	c791                	beqz	a5,8020a802 <ilock+0x1c>
    8020a7f8:	fd843783          	ld	a5,-40(s0)
    8020a7fc:	479c                	lw	a5,8(a5)
    8020a7fe:	00f04a63          	bgtz	a5,8020a812 <ilock+0x2c>
		panic("ilock");
    8020a802:	0002c517          	auipc	a0,0x2c
    8020a806:	ef650513          	addi	a0,a0,-266 # 802366f8 <user_test_table+0x118>
    8020a80a:	ffff7097          	auipc	ra,0xffff7
    8020a80e:	fd0080e7          	jalr	-48(ra) # 802017da <panic>
	acquiresleep(&ip->lock);
    8020a812:	fd843783          	ld	a5,-40(s0)
    8020a816:	05878793          	addi	a5,a5,88
    8020a81a:	853e                	mv	a0,a5
    8020a81c:	00001097          	auipc	ra,0x1
    8020a820:	404080e7          	jalr	1028(ra) # 8020bc20 <acquiresleep>
	if (ip->valid == 0)
    8020a824:	fd843783          	ld	a5,-40(s0)
    8020a828:	47dc                	lw	a5,12(a5)
    8020a82a:	e7e5                	bnez	a5,8020a912 <ilock+0x12c>
	{
		bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8020a82c:	fd843783          	ld	a5,-40(s0)
    8020a830:	4394                	lw	a3,0(a5)
    8020a832:	fd843783          	ld	a5,-40(s0)
    8020a836:	43dc                	lw	a5,4(a5)
    8020a838:	0047d79b          	srliw	a5,a5,0x4
    8020a83c:	0007871b          	sext.w	a4,a5
    8020a840:	0003b797          	auipc	a5,0x3b
    8020a844:	7b078793          	addi	a5,a5,1968 # 80245ff0 <sb>
    8020a848:	4f9c                	lw	a5,24(a5)
    8020a84a:	9fb9                	addw	a5,a5,a4
    8020a84c:	2781                	sext.w	a5,a5
    8020a84e:	85be                	mv	a1,a5
    8020a850:	8536                	mv	a0,a3
    8020a852:	ffffe097          	auipc	ra,0xffffe
    8020a856:	294080e7          	jalr	660(ra) # 80208ae6 <bread>
    8020a85a:	fea43423          	sd	a0,-24(s0)
		dip = (struct dinode *)bp->data + ip->inum % IPB;
    8020a85e:	fe843783          	ld	a5,-24(s0)
    8020a862:	05078713          	addi	a4,a5,80
    8020a866:	fd843783          	ld	a5,-40(s0)
    8020a86a:	43dc                	lw	a5,4(a5)
    8020a86c:	1782                	slli	a5,a5,0x20
    8020a86e:	9381                	srli	a5,a5,0x20
    8020a870:	8bbd                	andi	a5,a5,15
    8020a872:	079a                	slli	a5,a5,0x6
    8020a874:	97ba                	add	a5,a5,a4
    8020a876:	fef43023          	sd	a5,-32(s0)
		ip->type = dip->type;
    8020a87a:	fe043783          	ld	a5,-32(s0)
    8020a87e:	00079703          	lh	a4,0(a5)
    8020a882:	fd843783          	ld	a5,-40(s0)
    8020a886:	00e79a23          	sh	a4,20(a5)
		ip->major = dip->major;
    8020a88a:	fe043783          	ld	a5,-32(s0)
    8020a88e:	00279703          	lh	a4,2(a5)
    8020a892:	fd843783          	ld	a5,-40(s0)
    8020a896:	00e79b23          	sh	a4,22(a5)
		ip->minor = dip->minor;
    8020a89a:	fe043783          	ld	a5,-32(s0)
    8020a89e:	00479703          	lh	a4,4(a5)
    8020a8a2:	fd843783          	ld	a5,-40(s0)
    8020a8a6:	00e79c23          	sh	a4,24(a5)
		ip->nlink = dip->nlink;
    8020a8aa:	fe043783          	ld	a5,-32(s0)
    8020a8ae:	00679703          	lh	a4,6(a5)
    8020a8b2:	fd843783          	ld	a5,-40(s0)
    8020a8b6:	00e79d23          	sh	a4,26(a5)
		ip->size = dip->size;
    8020a8ba:	fe043783          	ld	a5,-32(s0)
    8020a8be:	4798                	lw	a4,8(a5)
    8020a8c0:	fd843783          	ld	a5,-40(s0)
    8020a8c4:	cfd8                	sw	a4,28(a5)
		memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8020a8c6:	fd843783          	ld	a5,-40(s0)
    8020a8ca:	02078713          	addi	a4,a5,32
    8020a8ce:	fe043783          	ld	a5,-32(s0)
    8020a8d2:	07b1                	addi	a5,a5,12
    8020a8d4:	03400613          	li	a2,52
    8020a8d8:	85be                	mv	a1,a5
    8020a8da:	853a                	mv	a0,a4
    8020a8dc:	ffff7097          	auipc	ra,0xffff7
    8020a8e0:	68c080e7          	jalr	1676(ra) # 80201f68 <memmove>
		brelse(bp);
    8020a8e4:	fe843503          	ld	a0,-24(s0)
    8020a8e8:	ffffe097          	auipc	ra,0xffffe
    8020a8ec:	2a0080e7          	jalr	672(ra) # 80208b88 <brelse>
		ip->valid = 1;
    8020a8f0:	fd843783          	ld	a5,-40(s0)
    8020a8f4:	4705                	li	a4,1
    8020a8f6:	c7d8                	sw	a4,12(a5)
		if (ip->type == 0)
    8020a8f8:	fd843783          	ld	a5,-40(s0)
    8020a8fc:	01479783          	lh	a5,20(a5)
    8020a900:	eb89                	bnez	a5,8020a912 <ilock+0x12c>
			panic("ilock: no type");
    8020a902:	0002c517          	auipc	a0,0x2c
    8020a906:	dfe50513          	addi	a0,a0,-514 # 80236700 <user_test_table+0x120>
    8020a90a:	ffff7097          	auipc	ra,0xffff7
    8020a90e:	ed0080e7          	jalr	-304(ra) # 802017da <panic>
	}
}
    8020a912:	0001                	nop
    8020a914:	70a2                	ld	ra,40(sp)
    8020a916:	7402                	ld	s0,32(sp)
    8020a918:	6145                	addi	sp,sp,48
    8020a91a:	8082                	ret

000000008020a91c <iunlock>:

// Unlock the given inode.
void iunlock(struct inode *ip)
{
    8020a91c:	1101                	addi	sp,sp,-32
    8020a91e:	ec06                	sd	ra,24(sp)
    8020a920:	e822                	sd	s0,16(sp)
    8020a922:	1000                	addi	s0,sp,32
    8020a924:	fea43423          	sd	a0,-24(s0)
	if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8020a928:	fe843783          	ld	a5,-24(s0)
    8020a92c:	c38d                	beqz	a5,8020a94e <iunlock+0x32>
    8020a92e:	fe843783          	ld	a5,-24(s0)
    8020a932:	05878793          	addi	a5,a5,88
    8020a936:	853e                	mv	a0,a5
    8020a938:	00001097          	auipc	ra,0x1
    8020a93c:	3a8080e7          	jalr	936(ra) # 8020bce0 <holdingsleep>
    8020a940:	87aa                	mv	a5,a0
    8020a942:	c791                	beqz	a5,8020a94e <iunlock+0x32>
    8020a944:	fe843783          	ld	a5,-24(s0)
    8020a948:	479c                	lw	a5,8(a5)
    8020a94a:	00f04a63          	bgtz	a5,8020a95e <iunlock+0x42>
		panic("iunlock");
    8020a94e:	0002c517          	auipc	a0,0x2c
    8020a952:	dc250513          	addi	a0,a0,-574 # 80236710 <user_test_table+0x130>
    8020a956:	ffff7097          	auipc	ra,0xffff7
    8020a95a:	e84080e7          	jalr	-380(ra) # 802017da <panic>
	releasesleep(&ip->lock);
    8020a95e:	fe843783          	ld	a5,-24(s0)
    8020a962:	05878793          	addi	a5,a5,88
    8020a966:	853e                	mv	a0,a5
    8020a968:	00001097          	auipc	ra,0x1
    8020a96c:	326080e7          	jalr	806(ra) # 8020bc8e <releasesleep>
}
    8020a970:	0001                	nop
    8020a972:	60e2                	ld	ra,24(sp)
    8020a974:	6442                	ld	s0,16(sp)
    8020a976:	6105                	addi	sp,sp,32
    8020a978:	8082                	ret

000000008020a97a <iput>:
void iput(struct inode *ip)
{
    8020a97a:	1101                	addi	sp,sp,-32
    8020a97c:	ec06                	sd	ra,24(sp)
    8020a97e:	e822                	sd	s0,16(sp)
    8020a980:	1000                	addi	s0,sp,32
    8020a982:	fea43423          	sd	a0,-24(s0)
	acquire(&itable.lock);
    8020a986:	0003b517          	auipc	a0,0x3b
    8020a98a:	68a50513          	addi	a0,a0,1674 # 80246010 <itable>
    8020a98e:	00001097          	auipc	ra,0x1
    8020a992:	19a080e7          	jalr	410(ra) # 8020bb28 <acquire>
	if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    8020a996:	fe843783          	ld	a5,-24(s0)
    8020a99a:	479c                	lw	a5,8(a5)
    8020a99c:	873e                	mv	a4,a5
    8020a99e:	4785                	li	a5,1
    8020a9a0:	08f71163          	bne	a4,a5,8020aa22 <iput+0xa8>
    8020a9a4:	fe843783          	ld	a5,-24(s0)
    8020a9a8:	47dc                	lw	a5,12(a5)
    8020a9aa:	cfa5                	beqz	a5,8020aa22 <iput+0xa8>
    8020a9ac:	fe843783          	ld	a5,-24(s0)
    8020a9b0:	01a79783          	lh	a5,26(a5)
    8020a9b4:	e7bd                	bnez	a5,8020aa22 <iput+0xa8>
	{
		acquiresleep(&ip->lock);
    8020a9b6:	fe843783          	ld	a5,-24(s0)
    8020a9ba:	05878793          	addi	a5,a5,88
    8020a9be:	853e                	mv	a0,a5
    8020a9c0:	00001097          	auipc	ra,0x1
    8020a9c4:	260080e7          	jalr	608(ra) # 8020bc20 <acquiresleep>

		release(&itable.lock);
    8020a9c8:	0003b517          	auipc	a0,0x3b
    8020a9cc:	64850513          	addi	a0,a0,1608 # 80246010 <itable>
    8020a9d0:	00001097          	auipc	ra,0x1
    8020a9d4:	1a4080e7          	jalr	420(ra) # 8020bb74 <release>
		itrunc(ip);
    8020a9d8:	fe843503          	ld	a0,-24(s0)
    8020a9dc:	00000097          	auipc	ra,0x0
    8020a9e0:	342080e7          	jalr	834(ra) # 8020ad1e <itrunc>
		ip->type = 0;
    8020a9e4:	fe843783          	ld	a5,-24(s0)
    8020a9e8:	00079a23          	sh	zero,20(a5)
		iupdate(ip);
    8020a9ec:	fe843503          	ld	a0,-24(s0)
    8020a9f0:	00000097          	auipc	ra,0x0
    8020a9f4:	ba6080e7          	jalr	-1114(ra) # 8020a596 <iupdate>
		ip->valid = 0;
    8020a9f8:	fe843783          	ld	a5,-24(s0)
    8020a9fc:	0007a623          	sw	zero,12(a5)
		releasesleep(&ip->lock);
    8020aa00:	fe843783          	ld	a5,-24(s0)
    8020aa04:	05878793          	addi	a5,a5,88
    8020aa08:	853e                	mv	a0,a5
    8020aa0a:	00001097          	auipc	ra,0x1
    8020aa0e:	284080e7          	jalr	644(ra) # 8020bc8e <releasesleep>

		acquire(&itable.lock);
    8020aa12:	0003b517          	auipc	a0,0x3b
    8020aa16:	5fe50513          	addi	a0,a0,1534 # 80246010 <itable>
    8020aa1a:	00001097          	auipc	ra,0x1
    8020aa1e:	10e080e7          	jalr	270(ra) # 8020bb28 <acquire>
	}

	ip->ref--;
    8020aa22:	fe843783          	ld	a5,-24(s0)
    8020aa26:	479c                	lw	a5,8(a5)
    8020aa28:	37fd                	addiw	a5,a5,-1
    8020aa2a:	0007871b          	sext.w	a4,a5
    8020aa2e:	fe843783          	ld	a5,-24(s0)
    8020aa32:	c798                	sw	a4,8(a5)
	release(&itable.lock);
    8020aa34:	0003b517          	auipc	a0,0x3b
    8020aa38:	5dc50513          	addi	a0,a0,1500 # 80246010 <itable>
    8020aa3c:	00001097          	auipc	ra,0x1
    8020aa40:	138080e7          	jalr	312(ra) # 8020bb74 <release>
}
    8020aa44:	0001                	nop
    8020aa46:	60e2                	ld	ra,24(sp)
    8020aa48:	6442                	ld	s0,16(sp)
    8020aa4a:	6105                	addi	sp,sp,32
    8020aa4c:	8082                	ret

000000008020aa4e <iunlockput>:
void iunlockput(struct inode *ip)
{
    8020aa4e:	1101                	addi	sp,sp,-32
    8020aa50:	ec06                	sd	ra,24(sp)
    8020aa52:	e822                	sd	s0,16(sp)
    8020aa54:	1000                	addi	s0,sp,32
    8020aa56:	fea43423          	sd	a0,-24(s0)
	iunlock(ip);
    8020aa5a:	fe843503          	ld	a0,-24(s0)
    8020aa5e:	00000097          	auipc	ra,0x0
    8020aa62:	ebe080e7          	jalr	-322(ra) # 8020a91c <iunlock>
	iput(ip);
    8020aa66:	fe843503          	ld	a0,-24(s0)
    8020aa6a:	00000097          	auipc	ra,0x0
    8020aa6e:	f10080e7          	jalr	-240(ra) # 8020a97a <iput>
}
    8020aa72:	0001                	nop
    8020aa74:	60e2                	ld	ra,24(sp)
    8020aa76:	6442                	ld	s0,16(sp)
    8020aa78:	6105                	addi	sp,sp,32
    8020aa7a:	8082                	ret

000000008020aa7c <ireclaim>:

void ireclaim(int dev)
{
    8020aa7c:	7139                	addi	sp,sp,-64
    8020aa7e:	fc06                	sd	ra,56(sp)
    8020aa80:	f822                	sd	s0,48(sp)
    8020aa82:	0080                	addi	s0,sp,64
    8020aa84:	87aa                	mv	a5,a0
    8020aa86:	fcf42623          	sw	a5,-52(s0)
	printf("Superblock: ninodes=%d\n", sb.ninodes);
    8020aa8a:	0003b797          	auipc	a5,0x3b
    8020aa8e:	56678793          	addi	a5,a5,1382 # 80245ff0 <sb>
    8020aa92:	47dc                	lw	a5,12(a5)
    8020aa94:	85be                	mv	a1,a5
    8020aa96:	0002c517          	auipc	a0,0x2c
    8020aa9a:	c8250513          	addi	a0,a0,-894 # 80236718 <user_test_table+0x138>
    8020aa9e:	ffff6097          	auipc	ra,0xffff6
    8020aaa2:	2f0080e7          	jalr	752(ra) # 80200d8e <printf>
	for (int inum = 1; inum < sb.ninodes; inum++)
    8020aaa6:	4785                	li	a5,1
    8020aaa8:	fef42623          	sw	a5,-20(s0)
    8020aaac:	a8e9                	j	8020ab86 <ireclaim+0x10a>
	{
		struct inode *ip = 0;
    8020aaae:	fe043023          	sd	zero,-32(s0)
		struct buf *bp = bread(dev, IBLOCK(inum, sb));
    8020aab2:	fcc42683          	lw	a3,-52(s0)
    8020aab6:	fec42783          	lw	a5,-20(s0)
    8020aaba:	8391                	srli	a5,a5,0x4
    8020aabc:	0007871b          	sext.w	a4,a5
    8020aac0:	0003b797          	auipc	a5,0x3b
    8020aac4:	53078793          	addi	a5,a5,1328 # 80245ff0 <sb>
    8020aac8:	4f9c                	lw	a5,24(a5)
    8020aaca:	9fb9                	addw	a5,a5,a4
    8020aacc:	2781                	sext.w	a5,a5
    8020aace:	85be                	mv	a1,a5
    8020aad0:	8536                	mv	a0,a3
    8020aad2:	ffffe097          	auipc	ra,0xffffe
    8020aad6:	014080e7          	jalr	20(ra) # 80208ae6 <bread>
    8020aada:	fca43c23          	sd	a0,-40(s0)
		struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    8020aade:	fd843783          	ld	a5,-40(s0)
    8020aae2:	05078713          	addi	a4,a5,80
    8020aae6:	fec42783          	lw	a5,-20(s0)
    8020aaea:	8bbd                	andi	a5,a5,15
    8020aaec:	079a                	slli	a5,a5,0x6
    8020aaee:	97ba                	add	a5,a5,a4
    8020aaf0:	fcf43823          	sd	a5,-48(s0)
		if (dip->type != 0 && dip->nlink == 0)
    8020aaf4:	fd043783          	ld	a5,-48(s0)
    8020aaf8:	00079783          	lh	a5,0(a5)
    8020aafc:	cf8d                	beqz	a5,8020ab36 <ireclaim+0xba>
    8020aafe:	fd043783          	ld	a5,-48(s0)
    8020ab02:	00679783          	lh	a5,6(a5)
    8020ab06:	eb85                	bnez	a5,8020ab36 <ireclaim+0xba>
		{ // is an orphaned inode
			printf("ireclaim: orphaned inode %d\n", inum);
    8020ab08:	fec42783          	lw	a5,-20(s0)
    8020ab0c:	85be                	mv	a1,a5
    8020ab0e:	0002c517          	auipc	a0,0x2c
    8020ab12:	c2250513          	addi	a0,a0,-990 # 80236730 <user_test_table+0x150>
    8020ab16:	ffff6097          	auipc	ra,0xffff6
    8020ab1a:	278080e7          	jalr	632(ra) # 80200d8e <printf>
			ip = iget(dev, inum);
    8020ab1e:	fcc42783          	lw	a5,-52(s0)
    8020ab22:	fec42703          	lw	a4,-20(s0)
    8020ab26:	85ba                	mv	a1,a4
    8020ab28:	853e                	mv	a0,a5
    8020ab2a:	00000097          	auipc	ra,0x0
    8020ab2e:	b54080e7          	jalr	-1196(ra) # 8020a67e <iget>
    8020ab32:	fea43023          	sd	a0,-32(s0)
		}
		brelse(bp);
    8020ab36:	fd843503          	ld	a0,-40(s0)
    8020ab3a:	ffffe097          	auipc	ra,0xffffe
    8020ab3e:	04e080e7          	jalr	78(ra) # 80208b88 <brelse>
		if (ip)
    8020ab42:	fe043783          	ld	a5,-32(s0)
    8020ab46:	cb9d                	beqz	a5,8020ab7c <ireclaim+0x100>
		{
			begin_op();
    8020ab48:	ffffe097          	auipc	ra,0xffffe
    8020ab4c:	5f6080e7          	jalr	1526(ra) # 8020913e <begin_op>
			ilock(ip);
    8020ab50:	fe043503          	ld	a0,-32(s0)
    8020ab54:	00000097          	auipc	ra,0x0
    8020ab58:	c92080e7          	jalr	-878(ra) # 8020a7e6 <ilock>
			iunlock(ip);
    8020ab5c:	fe043503          	ld	a0,-32(s0)
    8020ab60:	00000097          	auipc	ra,0x0
    8020ab64:	dbc080e7          	jalr	-580(ra) # 8020a91c <iunlock>
			iput(ip);
    8020ab68:	fe043503          	ld	a0,-32(s0)
    8020ab6c:	00000097          	auipc	ra,0x0
    8020ab70:	e0e080e7          	jalr	-498(ra) # 8020a97a <iput>
			end_op();
    8020ab74:	ffffe097          	auipc	ra,0xffffe
    8020ab78:	6a8080e7          	jalr	1704(ra) # 8020921c <end_op>
	for (int inum = 1; inum < sb.ninodes; inum++)
    8020ab7c:	fec42783          	lw	a5,-20(s0)
    8020ab80:	2785                	addiw	a5,a5,1
    8020ab82:	fef42623          	sw	a5,-20(s0)
    8020ab86:	0003b797          	auipc	a5,0x3b
    8020ab8a:	46a78793          	addi	a5,a5,1130 # 80245ff0 <sb>
    8020ab8e:	47d8                	lw	a4,12(a5)
    8020ab90:	fec42783          	lw	a5,-20(s0)
    8020ab94:	f0e7ede3          	bltu	a5,a4,8020aaae <ireclaim+0x32>
		}
	}
}
    8020ab98:	0001                	nop
    8020ab9a:	0001                	nop
    8020ab9c:	70e2                	ld	ra,56(sp)
    8020ab9e:	7442                	ld	s0,48(sp)
    8020aba0:	6121                	addi	sp,sp,64
    8020aba2:	8082                	ret

000000008020aba4 <bmap>:

static uint
bmap(struct inode *ip, uint bn)
{
    8020aba4:	7139                	addi	sp,sp,-64
    8020aba6:	fc06                	sd	ra,56(sp)
    8020aba8:	f822                	sd	s0,48(sp)
    8020abaa:	0080                	addi	s0,sp,64
    8020abac:	fca43423          	sd	a0,-56(s0)
    8020abb0:	87ae                	mv	a5,a1
    8020abb2:	fcf42223          	sw	a5,-60(s0)
	uint addr, *a;
	struct buf *bp;

	if (bn < NDIRECT)
    8020abb6:	fc442783          	lw	a5,-60(s0)
    8020abba:	0007871b          	sext.w	a4,a5
    8020abbe:	47ad                	li	a5,11
    8020abc0:	04e7ee63          	bltu	a5,a4,8020ac1c <bmap+0x78>
	{
		if ((addr = ip->addrs[bn]) == 0)
    8020abc4:	fc843703          	ld	a4,-56(s0)
    8020abc8:	fc446783          	lwu	a5,-60(s0)
    8020abcc:	07a1                	addi	a5,a5,8
    8020abce:	078a                	slli	a5,a5,0x2
    8020abd0:	97ba                	add	a5,a5,a4
    8020abd2:	439c                	lw	a5,0(a5)
    8020abd4:	fef42623          	sw	a5,-20(s0)
    8020abd8:	fec42783          	lw	a5,-20(s0)
    8020abdc:	2781                	sext.w	a5,a5
    8020abde:	ef85                	bnez	a5,8020ac16 <bmap+0x72>
		{
			addr = balloc(ip->dev);
    8020abe0:	fc843783          	ld	a5,-56(s0)
    8020abe4:	439c                	lw	a5,0(a5)
    8020abe6:	853e                	mv	a0,a5
    8020abe8:	fffff097          	auipc	ra,0xfffff
    8020abec:	56c080e7          	jalr	1388(ra) # 8020a154 <balloc>
    8020abf0:	87aa                	mv	a5,a0
    8020abf2:	fef42623          	sw	a5,-20(s0)
			if (addr == 0)
    8020abf6:	fec42783          	lw	a5,-20(s0)
    8020abfa:	2781                	sext.w	a5,a5
    8020abfc:	e399                	bnez	a5,8020ac02 <bmap+0x5e>
				return 0;
    8020abfe:	4781                	li	a5,0
    8020ac00:	aa11                	j	8020ad14 <bmap+0x170>
			ip->addrs[bn] = addr;
    8020ac02:	fc843703          	ld	a4,-56(s0)
    8020ac06:	fc446783          	lwu	a5,-60(s0)
    8020ac0a:	07a1                	addi	a5,a5,8
    8020ac0c:	078a                	slli	a5,a5,0x2
    8020ac0e:	97ba                	add	a5,a5,a4
    8020ac10:	fec42703          	lw	a4,-20(s0)
    8020ac14:	c398                	sw	a4,0(a5)
		}
		return addr;
    8020ac16:	fec42783          	lw	a5,-20(s0)
    8020ac1a:	a8ed                	j	8020ad14 <bmap+0x170>
	}
	bn -= NDIRECT;
    8020ac1c:	fc442783          	lw	a5,-60(s0)
    8020ac20:	37d1                	addiw	a5,a5,-12
    8020ac22:	fcf42223          	sw	a5,-60(s0)

	if (bn < NINDIRECT)
    8020ac26:	fc442783          	lw	a5,-60(s0)
    8020ac2a:	0007871b          	sext.w	a4,a5
    8020ac2e:	0ff00793          	li	a5,255
    8020ac32:	0ce7e863          	bltu	a5,a4,8020ad02 <bmap+0x15e>
	{
		// Load indirect block, allocating if necessary.
		if ((addr = ip->addrs[NDIRECT]) == 0)
    8020ac36:	fc843783          	ld	a5,-56(s0)
    8020ac3a:	4bbc                	lw	a5,80(a5)
    8020ac3c:	fef42623          	sw	a5,-20(s0)
    8020ac40:	fec42783          	lw	a5,-20(s0)
    8020ac44:	2781                	sext.w	a5,a5
    8020ac46:	e79d                	bnez	a5,8020ac74 <bmap+0xd0>
		{
			addr = balloc(ip->dev);
    8020ac48:	fc843783          	ld	a5,-56(s0)
    8020ac4c:	439c                	lw	a5,0(a5)
    8020ac4e:	853e                	mv	a0,a5
    8020ac50:	fffff097          	auipc	ra,0xfffff
    8020ac54:	504080e7          	jalr	1284(ra) # 8020a154 <balloc>
    8020ac58:	87aa                	mv	a5,a0
    8020ac5a:	fef42623          	sw	a5,-20(s0)
			if (addr == 0)
    8020ac5e:	fec42783          	lw	a5,-20(s0)
    8020ac62:	2781                	sext.w	a5,a5
    8020ac64:	e399                	bnez	a5,8020ac6a <bmap+0xc6>
				return 0;
    8020ac66:	4781                	li	a5,0
    8020ac68:	a075                	j	8020ad14 <bmap+0x170>
			ip->addrs[NDIRECT] = addr;
    8020ac6a:	fc843783          	ld	a5,-56(s0)
    8020ac6e:	fec42703          	lw	a4,-20(s0)
    8020ac72:	cbb8                	sw	a4,80(a5)
		}
		bp = bread(ip->dev, addr);
    8020ac74:	fc843783          	ld	a5,-56(s0)
    8020ac78:	439c                	lw	a5,0(a5)
    8020ac7a:	fec42703          	lw	a4,-20(s0)
    8020ac7e:	85ba                	mv	a1,a4
    8020ac80:	853e                	mv	a0,a5
    8020ac82:	ffffe097          	auipc	ra,0xffffe
    8020ac86:	e64080e7          	jalr	-412(ra) # 80208ae6 <bread>
    8020ac8a:	fea43023          	sd	a0,-32(s0)
		a = (uint *)bp->data;
    8020ac8e:	fe043783          	ld	a5,-32(s0)
    8020ac92:	05078793          	addi	a5,a5,80
    8020ac96:	fcf43c23          	sd	a5,-40(s0)
		if ((addr = a[bn]) == 0)
    8020ac9a:	fc446783          	lwu	a5,-60(s0)
    8020ac9e:	078a                	slli	a5,a5,0x2
    8020aca0:	fd843703          	ld	a4,-40(s0)
    8020aca4:	97ba                	add	a5,a5,a4
    8020aca6:	439c                	lw	a5,0(a5)
    8020aca8:	fef42623          	sw	a5,-20(s0)
    8020acac:	fec42783          	lw	a5,-20(s0)
    8020acb0:	2781                	sext.w	a5,a5
    8020acb2:	ef9d                	bnez	a5,8020acf0 <bmap+0x14c>
		{
			addr = balloc(ip->dev);
    8020acb4:	fc843783          	ld	a5,-56(s0)
    8020acb8:	439c                	lw	a5,0(a5)
    8020acba:	853e                	mv	a0,a5
    8020acbc:	fffff097          	auipc	ra,0xfffff
    8020acc0:	498080e7          	jalr	1176(ra) # 8020a154 <balloc>
    8020acc4:	87aa                	mv	a5,a0
    8020acc6:	fef42623          	sw	a5,-20(s0)
			if (addr)
    8020acca:	fec42783          	lw	a5,-20(s0)
    8020acce:	2781                	sext.w	a5,a5
    8020acd0:	c385                	beqz	a5,8020acf0 <bmap+0x14c>
			{
				a[bn] = addr;
    8020acd2:	fc446783          	lwu	a5,-60(s0)
    8020acd6:	078a                	slli	a5,a5,0x2
    8020acd8:	fd843703          	ld	a4,-40(s0)
    8020acdc:	97ba                	add	a5,a5,a4
    8020acde:	fec42703          	lw	a4,-20(s0)
    8020ace2:	c398                	sw	a4,0(a5)
				log_write(bp);
    8020ace4:	fe043503          	ld	a0,-32(s0)
    8020ace8:	ffffe097          	auipc	ra,0xffffe
    8020acec:	76c080e7          	jalr	1900(ra) # 80209454 <log_write>
			}
		}
		brelse(bp);
    8020acf0:	fe043503          	ld	a0,-32(s0)
    8020acf4:	ffffe097          	auipc	ra,0xffffe
    8020acf8:	e94080e7          	jalr	-364(ra) # 80208b88 <brelse>
		return addr;
    8020acfc:	fec42783          	lw	a5,-20(s0)
    8020ad00:	a811                	j	8020ad14 <bmap+0x170>
	}

	panic("bmap: out of range");
    8020ad02:	0002c517          	auipc	a0,0x2c
    8020ad06:	a4e50513          	addi	a0,a0,-1458 # 80236750 <user_test_table+0x170>
    8020ad0a:	ffff7097          	auipc	ra,0xffff7
    8020ad0e:	ad0080e7          	jalr	-1328(ra) # 802017da <panic>
	return 0;
    8020ad12:	4781                	li	a5,0
}
    8020ad14:	853e                	mv	a0,a5
    8020ad16:	70e2                	ld	ra,56(sp)
    8020ad18:	7442                	ld	s0,48(sp)
    8020ad1a:	6121                	addi	sp,sp,64
    8020ad1c:	8082                	ret

000000008020ad1e <itrunc>:

void itrunc(struct inode *ip)
{
    8020ad1e:	7139                	addi	sp,sp,-64
    8020ad20:	fc06                	sd	ra,56(sp)
    8020ad22:	f822                	sd	s0,48(sp)
    8020ad24:	0080                	addi	s0,sp,64
    8020ad26:	fca43423          	sd	a0,-56(s0)
	int i, j;
	struct buf *bp;
	uint *a;

	for (i = 0; i < NDIRECT; i++)
    8020ad2a:	fe042623          	sw	zero,-20(s0)
    8020ad2e:	a899                	j	8020ad84 <itrunc+0x66>
	{
		if (ip->addrs[i])
    8020ad30:	fc843703          	ld	a4,-56(s0)
    8020ad34:	fec42783          	lw	a5,-20(s0)
    8020ad38:	07a1                	addi	a5,a5,8
    8020ad3a:	078a                	slli	a5,a5,0x2
    8020ad3c:	97ba                	add	a5,a5,a4
    8020ad3e:	439c                	lw	a5,0(a5)
    8020ad40:	cf8d                	beqz	a5,8020ad7a <itrunc+0x5c>
		{
			bfree(ip->dev, ip->addrs[i]);
    8020ad42:	fc843783          	ld	a5,-56(s0)
    8020ad46:	439c                	lw	a5,0(a5)
    8020ad48:	0007869b          	sext.w	a3,a5
    8020ad4c:	fc843703          	ld	a4,-56(s0)
    8020ad50:	fec42783          	lw	a5,-20(s0)
    8020ad54:	07a1                	addi	a5,a5,8
    8020ad56:	078a                	slli	a5,a5,0x2
    8020ad58:	97ba                	add	a5,a5,a4
    8020ad5a:	439c                	lw	a5,0(a5)
    8020ad5c:	85be                	mv	a1,a5
    8020ad5e:	8536                	mv	a0,a3
    8020ad60:	fffff097          	auipc	ra,0xfffff
    8020ad64:	59c080e7          	jalr	1436(ra) # 8020a2fc <bfree>
			ip->addrs[i] = 0;
    8020ad68:	fc843703          	ld	a4,-56(s0)
    8020ad6c:	fec42783          	lw	a5,-20(s0)
    8020ad70:	07a1                	addi	a5,a5,8
    8020ad72:	078a                	slli	a5,a5,0x2
    8020ad74:	97ba                	add	a5,a5,a4
    8020ad76:	0007a023          	sw	zero,0(a5)
	for (i = 0; i < NDIRECT; i++)
    8020ad7a:	fec42783          	lw	a5,-20(s0)
    8020ad7e:	2785                	addiw	a5,a5,1
    8020ad80:	fef42623          	sw	a5,-20(s0)
    8020ad84:	fec42783          	lw	a5,-20(s0)
    8020ad88:	0007871b          	sext.w	a4,a5
    8020ad8c:	47ad                	li	a5,11
    8020ad8e:	fae7d1e3          	bge	a5,a4,8020ad30 <itrunc+0x12>
		}
	}

	if (ip->addrs[NDIRECT])
    8020ad92:	fc843783          	ld	a5,-56(s0)
    8020ad96:	4bbc                	lw	a5,80(a5)
    8020ad98:	c7d5                	beqz	a5,8020ae44 <itrunc+0x126>
	{
		bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8020ad9a:	fc843783          	ld	a5,-56(s0)
    8020ad9e:	4398                	lw	a4,0(a5)
    8020ada0:	fc843783          	ld	a5,-56(s0)
    8020ada4:	4bbc                	lw	a5,80(a5)
    8020ada6:	85be                	mv	a1,a5
    8020ada8:	853a                	mv	a0,a4
    8020adaa:	ffffe097          	auipc	ra,0xffffe
    8020adae:	d3c080e7          	jalr	-708(ra) # 80208ae6 <bread>
    8020adb2:	fea43023          	sd	a0,-32(s0)
		a = (uint *)bp->data;
    8020adb6:	fe043783          	ld	a5,-32(s0)
    8020adba:	05078793          	addi	a5,a5,80
    8020adbe:	fcf43c23          	sd	a5,-40(s0)
		for (j = 0; j < NINDIRECT; j++)
    8020adc2:	fe042423          	sw	zero,-24(s0)
    8020adc6:	a081                	j	8020ae06 <itrunc+0xe8>
		{
			if (a[j])
    8020adc8:	fe842783          	lw	a5,-24(s0)
    8020adcc:	078a                	slli	a5,a5,0x2
    8020adce:	fd843703          	ld	a4,-40(s0)
    8020add2:	97ba                	add	a5,a5,a4
    8020add4:	439c                	lw	a5,0(a5)
    8020add6:	c39d                	beqz	a5,8020adfc <itrunc+0xde>
				bfree(ip->dev, a[j]);
    8020add8:	fc843783          	ld	a5,-56(s0)
    8020addc:	439c                	lw	a5,0(a5)
    8020adde:	0007869b          	sext.w	a3,a5
    8020ade2:	fe842783          	lw	a5,-24(s0)
    8020ade6:	078a                	slli	a5,a5,0x2
    8020ade8:	fd843703          	ld	a4,-40(s0)
    8020adec:	97ba                	add	a5,a5,a4
    8020adee:	439c                	lw	a5,0(a5)
    8020adf0:	85be                	mv	a1,a5
    8020adf2:	8536                	mv	a0,a3
    8020adf4:	fffff097          	auipc	ra,0xfffff
    8020adf8:	508080e7          	jalr	1288(ra) # 8020a2fc <bfree>
		for (j = 0; j < NINDIRECT; j++)
    8020adfc:	fe842783          	lw	a5,-24(s0)
    8020ae00:	2785                	addiw	a5,a5,1
    8020ae02:	fef42423          	sw	a5,-24(s0)
    8020ae06:	fe842783          	lw	a5,-24(s0)
    8020ae0a:	873e                	mv	a4,a5
    8020ae0c:	0ff00793          	li	a5,255
    8020ae10:	fae7fce3          	bgeu	a5,a4,8020adc8 <itrunc+0xaa>
		}
		brelse(bp);
    8020ae14:	fe043503          	ld	a0,-32(s0)
    8020ae18:	ffffe097          	auipc	ra,0xffffe
    8020ae1c:	d70080e7          	jalr	-656(ra) # 80208b88 <brelse>
		bfree(ip->dev, ip->addrs[NDIRECT]);
    8020ae20:	fc843783          	ld	a5,-56(s0)
    8020ae24:	439c                	lw	a5,0(a5)
    8020ae26:	0007871b          	sext.w	a4,a5
    8020ae2a:	fc843783          	ld	a5,-56(s0)
    8020ae2e:	4bbc                	lw	a5,80(a5)
    8020ae30:	85be                	mv	a1,a5
    8020ae32:	853a                	mv	a0,a4
    8020ae34:	fffff097          	auipc	ra,0xfffff
    8020ae38:	4c8080e7          	jalr	1224(ra) # 8020a2fc <bfree>
		ip->addrs[NDIRECT] = 0;
    8020ae3c:	fc843783          	ld	a5,-56(s0)
    8020ae40:	0407a823          	sw	zero,80(a5)
	}

	ip->size = 0;
    8020ae44:	fc843783          	ld	a5,-56(s0)
    8020ae48:	0007ae23          	sw	zero,28(a5)
	iupdate(ip);
    8020ae4c:	fc843503          	ld	a0,-56(s0)
    8020ae50:	fffff097          	auipc	ra,0xfffff
    8020ae54:	746080e7          	jalr	1862(ra) # 8020a596 <iupdate>
}
    8020ae58:	0001                	nop
    8020ae5a:	70e2                	ld	ra,56(sp)
    8020ae5c:	7442                	ld	s0,48(sp)
    8020ae5e:	6121                	addi	sp,sp,64
    8020ae60:	8082                	ret

000000008020ae62 <stati>:

void stati(struct inode *ip, struct stat *st)
{
    8020ae62:	1101                	addi	sp,sp,-32
    8020ae64:	ec22                	sd	s0,24(sp)
    8020ae66:	1000                	addi	s0,sp,32
    8020ae68:	fea43423          	sd	a0,-24(s0)
    8020ae6c:	feb43023          	sd	a1,-32(s0)
	st->dev = ip->dev;
    8020ae70:	fe843783          	ld	a5,-24(s0)
    8020ae74:	439c                	lw	a5,0(a5)
    8020ae76:	0007871b          	sext.w	a4,a5
    8020ae7a:	fe043783          	ld	a5,-32(s0)
    8020ae7e:	c398                	sw	a4,0(a5)
	st->ino = ip->inum;
    8020ae80:	fe843783          	ld	a5,-24(s0)
    8020ae84:	43d8                	lw	a4,4(a5)
    8020ae86:	fe043783          	ld	a5,-32(s0)
    8020ae8a:	c3d8                	sw	a4,4(a5)
	st->type = ip->type;
    8020ae8c:	fe843783          	ld	a5,-24(s0)
    8020ae90:	01479703          	lh	a4,20(a5)
    8020ae94:	fe043783          	ld	a5,-32(s0)
    8020ae98:	00e79423          	sh	a4,8(a5)
	st->nlink = ip->nlink;
    8020ae9c:	fe843783          	ld	a5,-24(s0)
    8020aea0:	01a79703          	lh	a4,26(a5)
    8020aea4:	fe043783          	ld	a5,-32(s0)
    8020aea8:	00e79523          	sh	a4,10(a5)
	st->size = ip->size;
    8020aeac:	fe843783          	ld	a5,-24(s0)
    8020aeb0:	4fdc                	lw	a5,28(a5)
    8020aeb2:	02079713          	slli	a4,a5,0x20
    8020aeb6:	9301                	srli	a4,a4,0x20
    8020aeb8:	fe043783          	ld	a5,-32(s0)
    8020aebc:	eb98                	sd	a4,16(a5)
}
    8020aebe:	0001                	nop
    8020aec0:	6462                	ld	s0,24(sp)
    8020aec2:	6105                	addi	sp,sp,32
    8020aec4:	8082                	ret

000000008020aec6 <either_copyin>:
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8020aec6:	7179                	addi	sp,sp,-48
    8020aec8:	f406                	sd	ra,40(sp)
    8020aeca:	f022                	sd	s0,32(sp)
    8020aecc:	1800                	addi	s0,sp,48
    8020aece:	fea43423          	sd	a0,-24(s0)
    8020aed2:	87ae                	mv	a5,a1
    8020aed4:	fcc43c23          	sd	a2,-40(s0)
    8020aed8:	fcd43823          	sd	a3,-48(s0)
    8020aedc:	fef42223          	sw	a5,-28(s0)
	if (user_src)
    8020aee0:	fe442783          	lw	a5,-28(s0)
    8020aee4:	2781                	sext.w	a5,a5
    8020aee6:	cf99                	beqz	a5,8020af04 <either_copyin+0x3e>
	{
		// src 是用户空间虚拟地址
		return copyin(dst, src, len);
    8020aee8:	fd043783          	ld	a5,-48(s0)
    8020aeec:	2781                	sext.w	a5,a5
    8020aeee:	863e                	mv	a2,a5
    8020aef0:	fd843583          	ld	a1,-40(s0)
    8020aef4:	fe843503          	ld	a0,-24(s0)
    8020aef8:	ffff9097          	auipc	ra,0xffff9
    8020aefc:	15a080e7          	jalr	346(ra) # 80204052 <copyin>
    8020af00:	87aa                	mv	a5,a0
    8020af02:	a829                	j	8020af1c <either_copyin+0x56>
	}
	else
	{
		// src 是内核空间地址
		memmove(dst, (void *)src, len);
    8020af04:	fd843783          	ld	a5,-40(s0)
    8020af08:	fd043603          	ld	a2,-48(s0)
    8020af0c:	85be                	mv	a1,a5
    8020af0e:	fe843503          	ld	a0,-24(s0)
    8020af12:	ffff7097          	auipc	ra,0xffff7
    8020af16:	056080e7          	jalr	86(ra) # 80201f68 <memmove>
		return 0;
    8020af1a:	4781                	li	a5,0
	}
}
    8020af1c:	853e                	mv	a0,a5
    8020af1e:	70a2                	ld	ra,40(sp)
    8020af20:	7402                	ld	s0,32(sp)
    8020af22:	6145                	addi	sp,sp,48
    8020af24:	8082                	ret

000000008020af26 <either_copyout>:
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8020af26:	7179                	addi	sp,sp,-48
    8020af28:	f406                	sd	ra,40(sp)
    8020af2a:	f022                	sd	s0,32(sp)
    8020af2c:	1800                	addi	s0,sp,48
    8020af2e:	87aa                	mv	a5,a0
    8020af30:	feb43023          	sd	a1,-32(s0)
    8020af34:	fcc43c23          	sd	a2,-40(s0)
    8020af38:	fcd43823          	sd	a3,-48(s0)
    8020af3c:	fef42623          	sw	a5,-20(s0)
	if (user_dst)
    8020af40:	fec42783          	lw	a5,-20(s0)
    8020af44:	2781                	sext.w	a5,a5
    8020af46:	c785                	beqz	a5,8020af6e <either_copyout+0x48>
	{
		// dst 是用户空间虚拟地址
		return copyout(myproc()->pagetable, dst, src, len);
    8020af48:	ffffa097          	auipc	ra,0xffffa
    8020af4c:	0f8080e7          	jalr	248(ra) # 80205040 <myproc>
    8020af50:	87aa                	mv	a5,a0
    8020af52:	7fdc                	ld	a5,184(a5)
    8020af54:	fd043683          	ld	a3,-48(s0)
    8020af58:	fd843603          	ld	a2,-40(s0)
    8020af5c:	fe043583          	ld	a1,-32(s0)
    8020af60:	853e                	mv	a0,a5
    8020af62:	ffff9097          	auipc	ra,0xffff9
    8020af66:	194080e7          	jalr	404(ra) # 802040f6 <copyout>
    8020af6a:	87aa                	mv	a5,a0
    8020af6c:	a829                	j	8020af86 <either_copyout+0x60>
	}
	else
	{
		// dst 是内核空间地址
		memmove((void *)dst, src, len);
    8020af6e:	fe043783          	ld	a5,-32(s0)
    8020af72:	fd043603          	ld	a2,-48(s0)
    8020af76:	fd843583          	ld	a1,-40(s0)
    8020af7a:	853e                	mv	a0,a5
    8020af7c:	ffff7097          	auipc	ra,0xffff7
    8020af80:	fec080e7          	jalr	-20(ra) # 80201f68 <memmove>
		return 0;
    8020af84:	4781                	li	a5,0
	}
}
    8020af86:	853e                	mv	a0,a5
    8020af88:	70a2                	ld	ra,40(sp)
    8020af8a:	7402                	ld	s0,32(sp)
    8020af8c:	6145                	addi	sp,sp,48
    8020af8e:	8082                	ret

000000008020af90 <readi>:
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
    8020af90:	715d                	addi	sp,sp,-80
    8020af92:	e486                	sd	ra,72(sp)
    8020af94:	e0a2                	sd	s0,64(sp)
    8020af96:	0880                	addi	s0,sp,80
    8020af98:	fca43423          	sd	a0,-56(s0)
    8020af9c:	87ae                	mv	a5,a1
    8020af9e:	fac43c23          	sd	a2,-72(s0)
    8020afa2:	fcf42223          	sw	a5,-60(s0)
    8020afa6:	87b6                	mv	a5,a3
    8020afa8:	fcf42023          	sw	a5,-64(s0)
    8020afac:	87ba                	mv	a5,a4
    8020afae:	faf42a23          	sw	a5,-76(s0)
	uint tot, m;
	struct buf *bp;

	if (off > ip->size || off + n < off)
    8020afb2:	fc843783          	ld	a5,-56(s0)
    8020afb6:	4fd8                	lw	a4,28(a5)
    8020afb8:	fc042783          	lw	a5,-64(s0)
    8020afbc:	2781                	sext.w	a5,a5
    8020afbe:	00f76f63          	bltu	a4,a5,8020afdc <readi+0x4c>
    8020afc2:	fc042783          	lw	a5,-64(s0)
    8020afc6:	873e                	mv	a4,a5
    8020afc8:	fb442783          	lw	a5,-76(s0)
    8020afcc:	9fb9                	addw	a5,a5,a4
    8020afce:	0007871b          	sext.w	a4,a5
    8020afd2:	fc042783          	lw	a5,-64(s0)
    8020afd6:	2781                	sext.w	a5,a5
    8020afd8:	00f77463          	bgeu	a4,a5,8020afe0 <readi+0x50>
		return 0;
    8020afdc:	4781                	li	a5,0
    8020afde:	a299                	j	8020b124 <readi+0x194>
	if (off + n > ip->size)
    8020afe0:	fc042783          	lw	a5,-64(s0)
    8020afe4:	873e                	mv	a4,a5
    8020afe6:	fb442783          	lw	a5,-76(s0)
    8020afea:	9fb9                	addw	a5,a5,a4
    8020afec:	0007871b          	sext.w	a4,a5
    8020aff0:	fc843783          	ld	a5,-56(s0)
    8020aff4:	4fdc                	lw	a5,28(a5)
    8020aff6:	00e7fa63          	bgeu	a5,a4,8020b00a <readi+0x7a>
		n = ip->size - off;
    8020affa:	fc843783          	ld	a5,-56(s0)
    8020affe:	4fdc                	lw	a5,28(a5)
    8020b000:	fc042703          	lw	a4,-64(s0)
    8020b004:	9f99                	subw	a5,a5,a4
    8020b006:	faf42a23          	sw	a5,-76(s0)

	for (tot = 0; tot < n; tot += m, off += m, dst += m)
    8020b00a:	fe042623          	sw	zero,-20(s0)
    8020b00e:	a8f5                	j	8020b10a <readi+0x17a>
	{
		uint addr = bmap(ip, off / BSIZE);
    8020b010:	fc042783          	lw	a5,-64(s0)
    8020b014:	00a7d79b          	srliw	a5,a5,0xa
    8020b018:	2781                	sext.w	a5,a5
    8020b01a:	85be                	mv	a1,a5
    8020b01c:	fc843503          	ld	a0,-56(s0)
    8020b020:	00000097          	auipc	ra,0x0
    8020b024:	b84080e7          	jalr	-1148(ra) # 8020aba4 <bmap>
    8020b028:	87aa                	mv	a5,a0
    8020b02a:	fef42423          	sw	a5,-24(s0)
		if (addr == 0)
    8020b02e:	fe842783          	lw	a5,-24(s0)
    8020b032:	2781                	sext.w	a5,a5
    8020b034:	c7ed                	beqz	a5,8020b11e <readi+0x18e>
			break;
		bp = bread(ip->dev, addr);
    8020b036:	fc843783          	ld	a5,-56(s0)
    8020b03a:	439c                	lw	a5,0(a5)
    8020b03c:	fe842703          	lw	a4,-24(s0)
    8020b040:	85ba                	mv	a1,a4
    8020b042:	853e                	mv	a0,a5
    8020b044:	ffffe097          	auipc	ra,0xffffe
    8020b048:	aa2080e7          	jalr	-1374(ra) # 80208ae6 <bread>
    8020b04c:	fea43023          	sd	a0,-32(s0)
		m = min(n - tot, BSIZE - off % BSIZE);
    8020b050:	fc042783          	lw	a5,-64(s0)
    8020b054:	3ff7f793          	andi	a5,a5,1023
    8020b058:	2781                	sext.w	a5,a5
    8020b05a:	40000713          	li	a4,1024
    8020b05e:	40f707bb          	subw	a5,a4,a5
    8020b062:	2781                	sext.w	a5,a5
    8020b064:	fb442703          	lw	a4,-76(s0)
    8020b068:	86ba                	mv	a3,a4
    8020b06a:	fec42703          	lw	a4,-20(s0)
    8020b06e:	40e6873b          	subw	a4,a3,a4
    8020b072:	2701                	sext.w	a4,a4
    8020b074:	863a                	mv	a2,a4
    8020b076:	0007869b          	sext.w	a3,a5
    8020b07a:	0006071b          	sext.w	a4,a2
    8020b07e:	00d77363          	bgeu	a4,a3,8020b084 <readi+0xf4>
    8020b082:	87b2                	mv	a5,a2
    8020b084:	fcf42e23          	sw	a5,-36(s0)
		if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1)
    8020b088:	fe043783          	ld	a5,-32(s0)
    8020b08c:	05078713          	addi	a4,a5,80
    8020b090:	fc046783          	lwu	a5,-64(s0)
    8020b094:	3ff7f793          	andi	a5,a5,1023
    8020b098:	973e                	add	a4,a4,a5
    8020b09a:	fdc46683          	lwu	a3,-36(s0)
    8020b09e:	fc442783          	lw	a5,-60(s0)
    8020b0a2:	863a                	mv	a2,a4
    8020b0a4:	fb843583          	ld	a1,-72(s0)
    8020b0a8:	853e                	mv	a0,a5
    8020b0aa:	00000097          	auipc	ra,0x0
    8020b0ae:	e7c080e7          	jalr	-388(ra) # 8020af26 <either_copyout>
    8020b0b2:	87aa                	mv	a5,a0
    8020b0b4:	873e                	mv	a4,a5
    8020b0b6:	57fd                	li	a5,-1
    8020b0b8:	00f71c63          	bne	a4,a5,8020b0d0 <readi+0x140>
		{
			brelse(bp);
    8020b0bc:	fe043503          	ld	a0,-32(s0)
    8020b0c0:	ffffe097          	auipc	ra,0xffffe
    8020b0c4:	ac8080e7          	jalr	-1336(ra) # 80208b88 <brelse>
			tot = -1;
    8020b0c8:	57fd                	li	a5,-1
    8020b0ca:	fef42623          	sw	a5,-20(s0)
			break;
    8020b0ce:	a889                	j	8020b120 <readi+0x190>
		}
		brelse(bp);
    8020b0d0:	fe043503          	ld	a0,-32(s0)
    8020b0d4:	ffffe097          	auipc	ra,0xffffe
    8020b0d8:	ab4080e7          	jalr	-1356(ra) # 80208b88 <brelse>
	for (tot = 0; tot < n; tot += m, off += m, dst += m)
    8020b0dc:	fec42783          	lw	a5,-20(s0)
    8020b0e0:	873e                	mv	a4,a5
    8020b0e2:	fdc42783          	lw	a5,-36(s0)
    8020b0e6:	9fb9                	addw	a5,a5,a4
    8020b0e8:	fef42623          	sw	a5,-20(s0)
    8020b0ec:	fc042783          	lw	a5,-64(s0)
    8020b0f0:	873e                	mv	a4,a5
    8020b0f2:	fdc42783          	lw	a5,-36(s0)
    8020b0f6:	9fb9                	addw	a5,a5,a4
    8020b0f8:	fcf42023          	sw	a5,-64(s0)
    8020b0fc:	fdc46783          	lwu	a5,-36(s0)
    8020b100:	fb843703          	ld	a4,-72(s0)
    8020b104:	97ba                	add	a5,a5,a4
    8020b106:	faf43c23          	sd	a5,-72(s0)
    8020b10a:	fec42783          	lw	a5,-20(s0)
    8020b10e:	873e                	mv	a4,a5
    8020b110:	fb442783          	lw	a5,-76(s0)
    8020b114:	2701                	sext.w	a4,a4
    8020b116:	2781                	sext.w	a5,a5
    8020b118:	eef76ce3          	bltu	a4,a5,8020b010 <readi+0x80>
    8020b11c:	a011                	j	8020b120 <readi+0x190>
			break;
    8020b11e:	0001                	nop
	}
	return tot;
    8020b120:	fec42783          	lw	a5,-20(s0)
}
    8020b124:	853e                	mv	a0,a5
    8020b126:	60a6                	ld	ra,72(sp)
    8020b128:	6406                	ld	s0,64(sp)
    8020b12a:	6161                	addi	sp,sp,80
    8020b12c:	8082                	ret

000000008020b12e <writei>:

int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
    8020b12e:	715d                	addi	sp,sp,-80
    8020b130:	e486                	sd	ra,72(sp)
    8020b132:	e0a2                	sd	s0,64(sp)
    8020b134:	0880                	addi	s0,sp,80
    8020b136:	fca43423          	sd	a0,-56(s0)
    8020b13a:	87ae                	mv	a5,a1
    8020b13c:	fac43c23          	sd	a2,-72(s0)
    8020b140:	fcf42223          	sw	a5,-60(s0)
    8020b144:	87b6                	mv	a5,a3
    8020b146:	fcf42023          	sw	a5,-64(s0)
    8020b14a:	87ba                	mv	a5,a4
    8020b14c:	faf42a23          	sw	a5,-76(s0)
	uint tot, m;
	struct buf *bp;

	if (off > ip->size || off + n < off)
    8020b150:	fc843783          	ld	a5,-56(s0)
    8020b154:	4fd8                	lw	a4,28(a5)
    8020b156:	fc042783          	lw	a5,-64(s0)
    8020b15a:	2781                	sext.w	a5,a5
    8020b15c:	00f76f63          	bltu	a4,a5,8020b17a <writei+0x4c>
    8020b160:	fc042783          	lw	a5,-64(s0)
    8020b164:	873e                	mv	a4,a5
    8020b166:	fb442783          	lw	a5,-76(s0)
    8020b16a:	9fb9                	addw	a5,a5,a4
    8020b16c:	0007871b          	sext.w	a4,a5
    8020b170:	fc042783          	lw	a5,-64(s0)
    8020b174:	2781                	sext.w	a5,a5
    8020b176:	00f77463          	bgeu	a4,a5,8020b17e <writei+0x50>
		return -1;
    8020b17a:	57fd                	li	a5,-1
    8020b17c:	a295                	j	8020b2e0 <writei+0x1b2>
	if (off + n > MAXFILE * BSIZE)
    8020b17e:	fc042783          	lw	a5,-64(s0)
    8020b182:	873e                	mv	a4,a5
    8020b184:	fb442783          	lw	a5,-76(s0)
    8020b188:	9fb9                	addw	a5,a5,a4
    8020b18a:	2781                	sext.w	a5,a5
    8020b18c:	873e                	mv	a4,a5
    8020b18e:	000437b7          	lui	a5,0x43
    8020b192:	00e7f463          	bgeu	a5,a4,8020b19a <writei+0x6c>
		return -1;
    8020b196:	57fd                	li	a5,-1
    8020b198:	a2a1                	j	8020b2e0 <writei+0x1b2>

	for (tot = 0; tot < n; tot += m, off += m, src += m)
    8020b19a:	fe042623          	sw	zero,-20(s0)
    8020b19e:	a209                	j	8020b2a0 <writei+0x172>
	{
		uint addr = bmap(ip, off / BSIZE);
    8020b1a0:	fc042783          	lw	a5,-64(s0)
    8020b1a4:	00a7d79b          	srliw	a5,a5,0xa
    8020b1a8:	2781                	sext.w	a5,a5
    8020b1aa:	85be                	mv	a1,a5
    8020b1ac:	fc843503          	ld	a0,-56(s0)
    8020b1b0:	00000097          	auipc	ra,0x0
    8020b1b4:	9f4080e7          	jalr	-1548(ra) # 8020aba4 <bmap>
    8020b1b8:	87aa                	mv	a5,a0
    8020b1ba:	fef42423          	sw	a5,-24(s0)
		if (addr == 0)
    8020b1be:	fe842783          	lw	a5,-24(s0)
    8020b1c2:	2781                	sext.w	a5,a5
    8020b1c4:	cbe5                	beqz	a5,8020b2b4 <writei+0x186>
			break;
		bp = bread(ip->dev, addr);
    8020b1c6:	fc843783          	ld	a5,-56(s0)
    8020b1ca:	439c                	lw	a5,0(a5)
    8020b1cc:	fe842703          	lw	a4,-24(s0)
    8020b1d0:	85ba                	mv	a1,a4
    8020b1d2:	853e                	mv	a0,a5
    8020b1d4:	ffffe097          	auipc	ra,0xffffe
    8020b1d8:	912080e7          	jalr	-1774(ra) # 80208ae6 <bread>
    8020b1dc:	fea43023          	sd	a0,-32(s0)
		m = min(n - tot, BSIZE - off % BSIZE);
    8020b1e0:	fc042783          	lw	a5,-64(s0)
    8020b1e4:	3ff7f793          	andi	a5,a5,1023
    8020b1e8:	2781                	sext.w	a5,a5
    8020b1ea:	40000713          	li	a4,1024
    8020b1ee:	40f707bb          	subw	a5,a4,a5
    8020b1f2:	2781                	sext.w	a5,a5
    8020b1f4:	fb442703          	lw	a4,-76(s0)
    8020b1f8:	86ba                	mv	a3,a4
    8020b1fa:	fec42703          	lw	a4,-20(s0)
    8020b1fe:	40e6873b          	subw	a4,a3,a4
    8020b202:	2701                	sext.w	a4,a4
    8020b204:	863a                	mv	a2,a4
    8020b206:	0007869b          	sext.w	a3,a5
    8020b20a:	0006071b          	sext.w	a4,a2
    8020b20e:	00d77363          	bgeu	a4,a3,8020b214 <writei+0xe6>
    8020b212:	87b2                	mv	a5,a2
    8020b214:	fcf42e23          	sw	a5,-36(s0)
		if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1)
    8020b218:	fe043783          	ld	a5,-32(s0)
    8020b21c:	05078713          	addi	a4,a5,80 # 43050 <_entry-0x801bcfb0>
    8020b220:	fc046783          	lwu	a5,-64(s0)
    8020b224:	3ff7f793          	andi	a5,a5,1023
    8020b228:	97ba                	add	a5,a5,a4
    8020b22a:	fdc46683          	lwu	a3,-36(s0)
    8020b22e:	fc442703          	lw	a4,-60(s0)
    8020b232:	fb843603          	ld	a2,-72(s0)
    8020b236:	85ba                	mv	a1,a4
    8020b238:	853e                	mv	a0,a5
    8020b23a:	00000097          	auipc	ra,0x0
    8020b23e:	c8c080e7          	jalr	-884(ra) # 8020aec6 <either_copyin>
    8020b242:	87aa                	mv	a5,a0
    8020b244:	873e                	mv	a4,a5
    8020b246:	57fd                	li	a5,-1
    8020b248:	00f71963          	bne	a4,a5,8020b25a <writei+0x12c>
		{
			brelse(bp);
    8020b24c:	fe043503          	ld	a0,-32(s0)
    8020b250:	ffffe097          	auipc	ra,0xffffe
    8020b254:	938080e7          	jalr	-1736(ra) # 80208b88 <brelse>
			break;
    8020b258:	a8b9                	j	8020b2b6 <writei+0x188>
		}
		log_write(bp);
    8020b25a:	fe043503          	ld	a0,-32(s0)
    8020b25e:	ffffe097          	auipc	ra,0xffffe
    8020b262:	1f6080e7          	jalr	502(ra) # 80209454 <log_write>
		brelse(bp);
    8020b266:	fe043503          	ld	a0,-32(s0)
    8020b26a:	ffffe097          	auipc	ra,0xffffe
    8020b26e:	91e080e7          	jalr	-1762(ra) # 80208b88 <brelse>
	for (tot = 0; tot < n; tot += m, off += m, src += m)
    8020b272:	fec42783          	lw	a5,-20(s0)
    8020b276:	873e                	mv	a4,a5
    8020b278:	fdc42783          	lw	a5,-36(s0)
    8020b27c:	9fb9                	addw	a5,a5,a4
    8020b27e:	fef42623          	sw	a5,-20(s0)
    8020b282:	fc042783          	lw	a5,-64(s0)
    8020b286:	873e                	mv	a4,a5
    8020b288:	fdc42783          	lw	a5,-36(s0)
    8020b28c:	9fb9                	addw	a5,a5,a4
    8020b28e:	fcf42023          	sw	a5,-64(s0)
    8020b292:	fdc46783          	lwu	a5,-36(s0)
    8020b296:	fb843703          	ld	a4,-72(s0)
    8020b29a:	97ba                	add	a5,a5,a4
    8020b29c:	faf43c23          	sd	a5,-72(s0)
    8020b2a0:	fec42783          	lw	a5,-20(s0)
    8020b2a4:	873e                	mv	a4,a5
    8020b2a6:	fb442783          	lw	a5,-76(s0)
    8020b2aa:	2701                	sext.w	a4,a4
    8020b2ac:	2781                	sext.w	a5,a5
    8020b2ae:	eef769e3          	bltu	a4,a5,8020b1a0 <writei+0x72>
    8020b2b2:	a011                	j	8020b2b6 <writei+0x188>
			break;
    8020b2b4:	0001                	nop
	}

	if (off > ip->size)
    8020b2b6:	fc843783          	ld	a5,-56(s0)
    8020b2ba:	4fd8                	lw	a4,28(a5)
    8020b2bc:	fc042783          	lw	a5,-64(s0)
    8020b2c0:	2781                	sext.w	a5,a5
    8020b2c2:	00f77763          	bgeu	a4,a5,8020b2d0 <writei+0x1a2>
		ip->size = off;
    8020b2c6:	fc843783          	ld	a5,-56(s0)
    8020b2ca:	fc042703          	lw	a4,-64(s0)
    8020b2ce:	cfd8                	sw	a4,28(a5)

	iupdate(ip);
    8020b2d0:	fc843503          	ld	a0,-56(s0)
    8020b2d4:	fffff097          	auipc	ra,0xfffff
    8020b2d8:	2c2080e7          	jalr	706(ra) # 8020a596 <iupdate>
	return tot;
    8020b2dc:	fec42783          	lw	a5,-20(s0)
}
    8020b2e0:	853e                	mv	a0,a5
    8020b2e2:	60a6                	ld	ra,72(sp)
    8020b2e4:	6406                	ld	s0,64(sp)
    8020b2e6:	6161                	addi	sp,sp,80
    8020b2e8:	8082                	ret

000000008020b2ea <namecmp>:

int namecmp(const char *s, const char *t)
{
    8020b2ea:	1101                	addi	sp,sp,-32
    8020b2ec:	ec06                	sd	ra,24(sp)
    8020b2ee:	e822                	sd	s0,16(sp)
    8020b2f0:	1000                	addi	s0,sp,32
    8020b2f2:	fea43423          	sd	a0,-24(s0)
    8020b2f6:	feb43023          	sd	a1,-32(s0)
	return strncmp(s, t, DIRSIZ);
    8020b2fa:	4639                	li	a2,14
    8020b2fc:	fe043583          	ld	a1,-32(s0)
    8020b300:	fe843503          	ld	a0,-24(s0)
    8020b304:	ffffb097          	auipc	ra,0xffffb
    8020b308:	2e0080e7          	jalr	736(ra) # 802065e4 <strncmp>
    8020b30c:	87aa                	mv	a5,a0
}
    8020b30e:	853e                	mv	a0,a5
    8020b310:	60e2                	ld	ra,24(sp)
    8020b312:	6442                	ld	s0,16(sp)
    8020b314:	6105                	addi	sp,sp,32
    8020b316:	8082                	ret

000000008020b318 <dirlookup>:
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8020b318:	715d                	addi	sp,sp,-80
    8020b31a:	e486                	sd	ra,72(sp)
    8020b31c:	e0a2                	sd	s0,64(sp)
    8020b31e:	0880                	addi	s0,sp,80
    8020b320:	fca43423          	sd	a0,-56(s0)
    8020b324:	fcb43023          	sd	a1,-64(s0)
    8020b328:	fac43c23          	sd	a2,-72(s0)
	uint off, inum;
	struct dirent de;

	if (dp->type != T_DIR)
    8020b32c:	fc843783          	ld	a5,-56(s0)
    8020b330:	01479783          	lh	a5,20(a5)
    8020b334:	873e                	mv	a4,a5
    8020b336:	4785                	li	a5,1
    8020b338:	00f70a63          	beq	a4,a5,8020b34c <dirlookup+0x34>
		panic("dirlookup not DIR");
    8020b33c:	0002b517          	auipc	a0,0x2b
    8020b340:	42c50513          	addi	a0,a0,1068 # 80236768 <user_test_table+0x188>
    8020b344:	ffff6097          	auipc	ra,0xffff6
    8020b348:	496080e7          	jalr	1174(ra) # 802017da <panic>

	for (off = 0; off < dp->size; off += sizeof(de))
    8020b34c:	fe042623          	sw	zero,-20(s0)
    8020b350:	a849                	j	8020b3e2 <dirlookup+0xca>
	{
		if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8020b352:	fd840793          	addi	a5,s0,-40
    8020b356:	fec42683          	lw	a3,-20(s0)
    8020b35a:	4741                	li	a4,16
    8020b35c:	863e                	mv	a2,a5
    8020b35e:	4581                	li	a1,0
    8020b360:	fc843503          	ld	a0,-56(s0)
    8020b364:	00000097          	auipc	ra,0x0
    8020b368:	c2c080e7          	jalr	-980(ra) # 8020af90 <readi>
    8020b36c:	87aa                	mv	a5,a0
    8020b36e:	873e                	mv	a4,a5
    8020b370:	47c1                	li	a5,16
    8020b372:	00f70a63          	beq	a4,a5,8020b386 <dirlookup+0x6e>
			panic("dirlookup read");
    8020b376:	0002b517          	auipc	a0,0x2b
    8020b37a:	40a50513          	addi	a0,a0,1034 # 80236780 <user_test_table+0x1a0>
    8020b37e:	ffff6097          	auipc	ra,0xffff6
    8020b382:	45c080e7          	jalr	1116(ra) # 802017da <panic>
		if (de.inum == 0)
    8020b386:	fd845783          	lhu	a5,-40(s0)
    8020b38a:	c7b1                	beqz	a5,8020b3d6 <dirlookup+0xbe>
			continue;
		if (namecmp(name, de.name) == 0)
    8020b38c:	fd840793          	addi	a5,s0,-40
    8020b390:	0789                	addi	a5,a5,2
    8020b392:	85be                	mv	a1,a5
    8020b394:	fc043503          	ld	a0,-64(s0)
    8020b398:	00000097          	auipc	ra,0x0
    8020b39c:	f52080e7          	jalr	-174(ra) # 8020b2ea <namecmp>
    8020b3a0:	87aa                	mv	a5,a0
    8020b3a2:	eb9d                	bnez	a5,8020b3d8 <dirlookup+0xc0>
		{
			// entry matches path element
			if (poff)
    8020b3a4:	fb843783          	ld	a5,-72(s0)
    8020b3a8:	c791                	beqz	a5,8020b3b4 <dirlookup+0x9c>
				*poff = off;
    8020b3aa:	fb843783          	ld	a5,-72(s0)
    8020b3ae:	fec42703          	lw	a4,-20(s0)
    8020b3b2:	c398                	sw	a4,0(a5)
			inum = de.inum;
    8020b3b4:	fd845783          	lhu	a5,-40(s0)
    8020b3b8:	fef42423          	sw	a5,-24(s0)
			return iget(dp->dev, inum);
    8020b3bc:	fc843783          	ld	a5,-56(s0)
    8020b3c0:	439c                	lw	a5,0(a5)
    8020b3c2:	fe842703          	lw	a4,-24(s0)
    8020b3c6:	85ba                	mv	a1,a4
    8020b3c8:	853e                	mv	a0,a5
    8020b3ca:	fffff097          	auipc	ra,0xfffff
    8020b3ce:	2b4080e7          	jalr	692(ra) # 8020a67e <iget>
    8020b3d2:	87aa                	mv	a5,a0
    8020b3d4:	a005                	j	8020b3f4 <dirlookup+0xdc>
			continue;
    8020b3d6:	0001                	nop
	for (off = 0; off < dp->size; off += sizeof(de))
    8020b3d8:	fec42783          	lw	a5,-20(s0)
    8020b3dc:	27c1                	addiw	a5,a5,16
    8020b3de:	fef42623          	sw	a5,-20(s0)
    8020b3e2:	fc843783          	ld	a5,-56(s0)
    8020b3e6:	4fd8                	lw	a4,28(a5)
    8020b3e8:	fec42783          	lw	a5,-20(s0)
    8020b3ec:	2781                	sext.w	a5,a5
    8020b3ee:	f6e7e2e3          	bltu	a5,a4,8020b352 <dirlookup+0x3a>
		}
	}

	return 0;
    8020b3f2:	4781                	li	a5,0
}
    8020b3f4:	853e                	mv	a0,a5
    8020b3f6:	60a6                	ld	ra,72(sp)
    8020b3f8:	6406                	ld	s0,64(sp)
    8020b3fa:	6161                	addi	sp,sp,80
    8020b3fc:	8082                	ret

000000008020b3fe <dirlink>:
int dirlink(struct inode *dp, char *name, uint inum)
{
    8020b3fe:	715d                	addi	sp,sp,-80
    8020b400:	e486                	sd	ra,72(sp)
    8020b402:	e0a2                	sd	s0,64(sp)
    8020b404:	0880                	addi	s0,sp,80
    8020b406:	fca43423          	sd	a0,-56(s0)
    8020b40a:	fcb43023          	sd	a1,-64(s0)
    8020b40e:	87b2                	mv	a5,a2
    8020b410:	faf42e23          	sw	a5,-68(s0)
	int off;
	struct dirent de;
	struct inode *ip;

	// Check that name is not present.
	if ((ip = dirlookup(dp, name, 0)) != 0)
    8020b414:	4601                	li	a2,0
    8020b416:	fc043583          	ld	a1,-64(s0)
    8020b41a:	fc843503          	ld	a0,-56(s0)
    8020b41e:	00000097          	auipc	ra,0x0
    8020b422:	efa080e7          	jalr	-262(ra) # 8020b318 <dirlookup>
    8020b426:	fea43023          	sd	a0,-32(s0)
    8020b42a:	fe043783          	ld	a5,-32(s0)
    8020b42e:	cb89                	beqz	a5,8020b440 <dirlink+0x42>
	{
		iput(ip);
    8020b430:	fe043503          	ld	a0,-32(s0)
    8020b434:	fffff097          	auipc	ra,0xfffff
    8020b438:	546080e7          	jalr	1350(ra) # 8020a97a <iput>
		return -1;
    8020b43c:	57fd                	li	a5,-1
    8020b43e:	a075                	j	8020b4ea <dirlink+0xec>
	}

	// Look for an empty dirent.
	for (off = 0; off < dp->size; off += sizeof(de))
    8020b440:	fe042623          	sw	zero,-20(s0)
    8020b444:	a0a1                	j	8020b48c <dirlink+0x8e>
	{
		if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8020b446:	fd040793          	addi	a5,s0,-48
    8020b44a:	fec42683          	lw	a3,-20(s0)
    8020b44e:	4741                	li	a4,16
    8020b450:	863e                	mv	a2,a5
    8020b452:	4581                	li	a1,0
    8020b454:	fc843503          	ld	a0,-56(s0)
    8020b458:	00000097          	auipc	ra,0x0
    8020b45c:	b38080e7          	jalr	-1224(ra) # 8020af90 <readi>
    8020b460:	87aa                	mv	a5,a0
    8020b462:	873e                	mv	a4,a5
    8020b464:	47c1                	li	a5,16
    8020b466:	00f70a63          	beq	a4,a5,8020b47a <dirlink+0x7c>
			panic("dirlink read");
    8020b46a:	0002b517          	auipc	a0,0x2b
    8020b46e:	32650513          	addi	a0,a0,806 # 80236790 <user_test_table+0x1b0>
    8020b472:	ffff6097          	auipc	ra,0xffff6
    8020b476:	368080e7          	jalr	872(ra) # 802017da <panic>
		if (de.inum == 0)
    8020b47a:	fd045783          	lhu	a5,-48(s0)
    8020b47e:	cf99                	beqz	a5,8020b49c <dirlink+0x9e>
	for (off = 0; off < dp->size; off += sizeof(de))
    8020b480:	fec42783          	lw	a5,-20(s0)
    8020b484:	27c1                	addiw	a5,a5,16
    8020b486:	2781                	sext.w	a5,a5
    8020b488:	fef42623          	sw	a5,-20(s0)
    8020b48c:	fc843783          	ld	a5,-56(s0)
    8020b490:	4fd8                	lw	a4,28(a5)
    8020b492:	fec42783          	lw	a5,-20(s0)
    8020b496:	fae7e8e3          	bltu	a5,a4,8020b446 <dirlink+0x48>
    8020b49a:	a011                	j	8020b49e <dirlink+0xa0>
			break;
    8020b49c:	0001                	nop
	}

	strncpy(de.name, name, DIRSIZ);
    8020b49e:	fd040793          	addi	a5,s0,-48
    8020b4a2:	0789                	addi	a5,a5,2
    8020b4a4:	4639                	li	a2,14
    8020b4a6:	fc043583          	ld	a1,-64(s0)
    8020b4aa:	853e                	mv	a0,a5
    8020b4ac:	ffffb097          	auipc	ra,0xffffb
    8020b4b0:	1ec080e7          	jalr	492(ra) # 80206698 <strncpy>
	de.inum = inum;
    8020b4b4:	fbc42783          	lw	a5,-68(s0)
    8020b4b8:	17c2                	slli	a5,a5,0x30
    8020b4ba:	93c1                	srli	a5,a5,0x30
    8020b4bc:	fcf41823          	sh	a5,-48(s0)
	if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8020b4c0:	fd040793          	addi	a5,s0,-48
    8020b4c4:	fec42683          	lw	a3,-20(s0)
    8020b4c8:	4741                	li	a4,16
    8020b4ca:	863e                	mv	a2,a5
    8020b4cc:	4581                	li	a1,0
    8020b4ce:	fc843503          	ld	a0,-56(s0)
    8020b4d2:	00000097          	auipc	ra,0x0
    8020b4d6:	c5c080e7          	jalr	-932(ra) # 8020b12e <writei>
    8020b4da:	87aa                	mv	a5,a0
    8020b4dc:	873e                	mv	a4,a5
    8020b4de:	47c1                	li	a5,16
    8020b4e0:	00f70463          	beq	a4,a5,8020b4e8 <dirlink+0xea>
		return -1;
    8020b4e4:	57fd                	li	a5,-1
    8020b4e6:	a011                	j	8020b4ea <dirlink+0xec>
	return 0;
    8020b4e8:	4781                	li	a5,0
}
    8020b4ea:	853e                	mv	a0,a5
    8020b4ec:	60a6                	ld	ra,72(sp)
    8020b4ee:	6406                	ld	s0,64(sp)
    8020b4f0:	6161                	addi	sp,sp,80
    8020b4f2:	8082                	ret

000000008020b4f4 <skipelem>:

static char *
skipelem(char *path, char *name)
{
    8020b4f4:	7179                	addi	sp,sp,-48
    8020b4f6:	f406                	sd	ra,40(sp)
    8020b4f8:	f022                	sd	s0,32(sp)
    8020b4fa:	1800                	addi	s0,sp,48
    8020b4fc:	fca43c23          	sd	a0,-40(s0)
    8020b500:	fcb43823          	sd	a1,-48(s0)
	char *s;
	int len;

	while (*path == '/')
    8020b504:	a031                	j	8020b510 <skipelem+0x1c>
		path++;
    8020b506:	fd843783          	ld	a5,-40(s0)
    8020b50a:	0785                	addi	a5,a5,1
    8020b50c:	fcf43c23          	sd	a5,-40(s0)
	while (*path == '/')
    8020b510:	fd843783          	ld	a5,-40(s0)
    8020b514:	0007c783          	lbu	a5,0(a5)
    8020b518:	873e                	mv	a4,a5
    8020b51a:	02f00793          	li	a5,47
    8020b51e:	fef704e3          	beq	a4,a5,8020b506 <skipelem+0x12>
	if (*path == 0)
    8020b522:	fd843783          	ld	a5,-40(s0)
    8020b526:	0007c783          	lbu	a5,0(a5)
    8020b52a:	e399                	bnez	a5,8020b530 <skipelem+0x3c>
		return 0;
    8020b52c:	4781                	li	a5,0
    8020b52e:	a06d                	j	8020b5d8 <skipelem+0xe4>
	s = path;
    8020b530:	fd843783          	ld	a5,-40(s0)
    8020b534:	fef43423          	sd	a5,-24(s0)
	while (*path != '/' && *path != 0)
    8020b538:	a031                	j	8020b544 <skipelem+0x50>
		path++;
    8020b53a:	fd843783          	ld	a5,-40(s0)
    8020b53e:	0785                	addi	a5,a5,1
    8020b540:	fcf43c23          	sd	a5,-40(s0)
	while (*path != '/' && *path != 0)
    8020b544:	fd843783          	ld	a5,-40(s0)
    8020b548:	0007c783          	lbu	a5,0(a5)
    8020b54c:	873e                	mv	a4,a5
    8020b54e:	02f00793          	li	a5,47
    8020b552:	00f70763          	beq	a4,a5,8020b560 <skipelem+0x6c>
    8020b556:	fd843783          	ld	a5,-40(s0)
    8020b55a:	0007c783          	lbu	a5,0(a5)
    8020b55e:	fff1                	bnez	a5,8020b53a <skipelem+0x46>
	len = path - s;
    8020b560:	fd843703          	ld	a4,-40(s0)
    8020b564:	fe843783          	ld	a5,-24(s0)
    8020b568:	40f707b3          	sub	a5,a4,a5
    8020b56c:	fef42223          	sw	a5,-28(s0)
	if (len >= DIRSIZ)
    8020b570:	fe442783          	lw	a5,-28(s0)
    8020b574:	0007871b          	sext.w	a4,a5
    8020b578:	47b5                	li	a5,13
    8020b57a:	00e7dc63          	bge	a5,a4,8020b592 <skipelem+0x9e>
		memmove(name, s, DIRSIZ);
    8020b57e:	4639                	li	a2,14
    8020b580:	fe843583          	ld	a1,-24(s0)
    8020b584:	fd043503          	ld	a0,-48(s0)
    8020b588:	ffff7097          	auipc	ra,0xffff7
    8020b58c:	9e0080e7          	jalr	-1568(ra) # 80201f68 <memmove>
    8020b590:	a80d                	j	8020b5c2 <skipelem+0xce>
	else
	{
		memmove(name, s, len);
    8020b592:	fe442783          	lw	a5,-28(s0)
    8020b596:	863e                	mv	a2,a5
    8020b598:	fe843583          	ld	a1,-24(s0)
    8020b59c:	fd043503          	ld	a0,-48(s0)
    8020b5a0:	ffff7097          	auipc	ra,0xffff7
    8020b5a4:	9c8080e7          	jalr	-1592(ra) # 80201f68 <memmove>
		name[len] = 0;
    8020b5a8:	fe442783          	lw	a5,-28(s0)
    8020b5ac:	fd043703          	ld	a4,-48(s0)
    8020b5b0:	97ba                	add	a5,a5,a4
    8020b5b2:	00078023          	sb	zero,0(a5)
	}
	while (*path == '/')
    8020b5b6:	a031                	j	8020b5c2 <skipelem+0xce>
		path++;
    8020b5b8:	fd843783          	ld	a5,-40(s0)
    8020b5bc:	0785                	addi	a5,a5,1
    8020b5be:	fcf43c23          	sd	a5,-40(s0)
	while (*path == '/')
    8020b5c2:	fd843783          	ld	a5,-40(s0)
    8020b5c6:	0007c783          	lbu	a5,0(a5)
    8020b5ca:	873e                	mv	a4,a5
    8020b5cc:	02f00793          	li	a5,47
    8020b5d0:	fef704e3          	beq	a4,a5,8020b5b8 <skipelem+0xc4>
	return path;
    8020b5d4:	fd843783          	ld	a5,-40(s0)
}
    8020b5d8:	853e                	mv	a0,a5
    8020b5da:	70a2                	ld	ra,40(sp)
    8020b5dc:	7402                	ld	s0,32(sp)
    8020b5de:	6145                	addi	sp,sp,48
    8020b5e0:	8082                	ret

000000008020b5e2 <namex>:
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    8020b5e2:	7139                	addi	sp,sp,-64
    8020b5e4:	fc06                	sd	ra,56(sp)
    8020b5e6:	f822                	sd	s0,48(sp)
    8020b5e8:	0080                	addi	s0,sp,64
    8020b5ea:	fca43c23          	sd	a0,-40(s0)
    8020b5ee:	87ae                	mv	a5,a1
    8020b5f0:	fcc43423          	sd	a2,-56(s0)
    8020b5f4:	fcf42a23          	sw	a5,-44(s0)
	struct inode *ip, *next;

	if (*path == '/')
    8020b5f8:	fd843783          	ld	a5,-40(s0)
    8020b5fc:	0007c783          	lbu	a5,0(a5)
    8020b600:	873e                	mv	a4,a5
    8020b602:	02f00793          	li	a5,47
    8020b606:	00f71b63          	bne	a4,a5,8020b61c <namex+0x3a>
		ip = iget(ROOTDEV, ROOTINO);
    8020b60a:	4585                	li	a1,1
    8020b60c:	4505                	li	a0,1
    8020b60e:	fffff097          	auipc	ra,0xfffff
    8020b612:	070080e7          	jalr	112(ra) # 8020a67e <iget>
    8020b616:	fea43423          	sd	a0,-24(s0)
    8020b61a:	a07d                	j	8020b6c8 <namex+0xe6>
	else
		ip = idup(myproc()->cwd);
    8020b61c:	ffffa097          	auipc	ra,0xffffa
    8020b620:	a24080e7          	jalr	-1500(ra) # 80205040 <myproc>
    8020b624:	87aa                	mv	a5,a0
    8020b626:	67fc                	ld	a5,200(a5)
    8020b628:	853e                	mv	a0,a5
    8020b62a:	fffff097          	auipc	ra,0xfffff
    8020b62e:	170080e7          	jalr	368(ra) # 8020a79a <idup>
    8020b632:	fea43423          	sd	a0,-24(s0)

	while ((path = skipelem(path, name)) != 0)
    8020b636:	a849                	j	8020b6c8 <namex+0xe6>
	{
		ilock(ip);
    8020b638:	fe843503          	ld	a0,-24(s0)
    8020b63c:	fffff097          	auipc	ra,0xfffff
    8020b640:	1aa080e7          	jalr	426(ra) # 8020a7e6 <ilock>
		if (ip->type != T_DIR)
    8020b644:	fe843783          	ld	a5,-24(s0)
    8020b648:	01479783          	lh	a5,20(a5)
    8020b64c:	873e                	mv	a4,a5
    8020b64e:	4785                	li	a5,1
    8020b650:	00f70a63          	beq	a4,a5,8020b664 <namex+0x82>
		{
			iunlockput(ip);
    8020b654:	fe843503          	ld	a0,-24(s0)
    8020b658:	fffff097          	auipc	ra,0xfffff
    8020b65c:	3f6080e7          	jalr	1014(ra) # 8020aa4e <iunlockput>
			return 0;
    8020b660:	4781                	li	a5,0
    8020b662:	a871                	j	8020b6fe <namex+0x11c>
		}
		if (nameiparent && *path == '\0')
    8020b664:	fd442783          	lw	a5,-44(s0)
    8020b668:	2781                	sext.w	a5,a5
    8020b66a:	cf99                	beqz	a5,8020b688 <namex+0xa6>
    8020b66c:	fd843783          	ld	a5,-40(s0)
    8020b670:	0007c783          	lbu	a5,0(a5)
    8020b674:	eb91                	bnez	a5,8020b688 <namex+0xa6>
		{
			// Stop one level early.
			iunlock(ip);
    8020b676:	fe843503          	ld	a0,-24(s0)
    8020b67a:	fffff097          	auipc	ra,0xfffff
    8020b67e:	2a2080e7          	jalr	674(ra) # 8020a91c <iunlock>
			return ip;
    8020b682:	fe843783          	ld	a5,-24(s0)
    8020b686:	a8a5                	j	8020b6fe <namex+0x11c>
		}
		if ((next = dirlookup(ip, name, 0)) == 0)
    8020b688:	4601                	li	a2,0
    8020b68a:	fc843583          	ld	a1,-56(s0)
    8020b68e:	fe843503          	ld	a0,-24(s0)
    8020b692:	00000097          	auipc	ra,0x0
    8020b696:	c86080e7          	jalr	-890(ra) # 8020b318 <dirlookup>
    8020b69a:	fea43023          	sd	a0,-32(s0)
    8020b69e:	fe043783          	ld	a5,-32(s0)
    8020b6a2:	eb89                	bnez	a5,8020b6b4 <namex+0xd2>
		{
			iunlockput(ip);
    8020b6a4:	fe843503          	ld	a0,-24(s0)
    8020b6a8:	fffff097          	auipc	ra,0xfffff
    8020b6ac:	3a6080e7          	jalr	934(ra) # 8020aa4e <iunlockput>
			return 0;
    8020b6b0:	4781                	li	a5,0
    8020b6b2:	a0b1                	j	8020b6fe <namex+0x11c>
		}
		iunlockput(ip);
    8020b6b4:	fe843503          	ld	a0,-24(s0)
    8020b6b8:	fffff097          	auipc	ra,0xfffff
    8020b6bc:	396080e7          	jalr	918(ra) # 8020aa4e <iunlockput>
		ip = next;
    8020b6c0:	fe043783          	ld	a5,-32(s0)
    8020b6c4:	fef43423          	sd	a5,-24(s0)
	while ((path = skipelem(path, name)) != 0)
    8020b6c8:	fc843583          	ld	a1,-56(s0)
    8020b6cc:	fd843503          	ld	a0,-40(s0)
    8020b6d0:	00000097          	auipc	ra,0x0
    8020b6d4:	e24080e7          	jalr	-476(ra) # 8020b4f4 <skipelem>
    8020b6d8:	fca43c23          	sd	a0,-40(s0)
    8020b6dc:	fd843783          	ld	a5,-40(s0)
    8020b6e0:	ffa1                	bnez	a5,8020b638 <namex+0x56>
	}
	if (nameiparent)
    8020b6e2:	fd442783          	lw	a5,-44(s0)
    8020b6e6:	2781                	sext.w	a5,a5
    8020b6e8:	cb89                	beqz	a5,8020b6fa <namex+0x118>
	{
		iput(ip);
    8020b6ea:	fe843503          	ld	a0,-24(s0)
    8020b6ee:	fffff097          	auipc	ra,0xfffff
    8020b6f2:	28c080e7          	jalr	652(ra) # 8020a97a <iput>
		return 0;
    8020b6f6:	4781                	li	a5,0
    8020b6f8:	a019                	j	8020b6fe <namex+0x11c>
	}
	return ip;
    8020b6fa:	fe843783          	ld	a5,-24(s0)
}
    8020b6fe:	853e                	mv	a0,a5
    8020b700:	70e2                	ld	ra,56(sp)
    8020b702:	7442                	ld	s0,48(sp)
    8020b704:	6121                	addi	sp,sp,64
    8020b706:	8082                	ret

000000008020b708 <namei>:

struct inode *
namei(char *path)
{
    8020b708:	7179                	addi	sp,sp,-48
    8020b70a:	f406                	sd	ra,40(sp)
    8020b70c:	f022                	sd	s0,32(sp)
    8020b70e:	1800                	addi	s0,sp,48
    8020b710:	fca43c23          	sd	a0,-40(s0)
	char name[DIRSIZ];
	return namex(path, 0, name);
    8020b714:	fe040793          	addi	a5,s0,-32
    8020b718:	863e                	mv	a2,a5
    8020b71a:	4581                	li	a1,0
    8020b71c:	fd843503          	ld	a0,-40(s0)
    8020b720:	00000097          	auipc	ra,0x0
    8020b724:	ec2080e7          	jalr	-318(ra) # 8020b5e2 <namex>
    8020b728:	87aa                	mv	a5,a0
}
    8020b72a:	853e                	mv	a0,a5
    8020b72c:	70a2                	ld	ra,40(sp)
    8020b72e:	7402                	ld	s0,32(sp)
    8020b730:	6145                	addi	sp,sp,48
    8020b732:	8082                	ret

000000008020b734 <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    8020b734:	1101                	addi	sp,sp,-32
    8020b736:	ec06                	sd	ra,24(sp)
    8020b738:	e822                	sd	s0,16(sp)
    8020b73a:	1000                	addi	s0,sp,32
    8020b73c:	fea43423          	sd	a0,-24(s0)
    8020b740:	feb43023          	sd	a1,-32(s0)
	return namex(path, 1, name);
    8020b744:	fe043603          	ld	a2,-32(s0)
    8020b748:	4585                	li	a1,1
    8020b74a:	fe843503          	ld	a0,-24(s0)
    8020b74e:	00000097          	auipc	ra,0x0
    8020b752:	e94080e7          	jalr	-364(ra) # 8020b5e2 <namex>
    8020b756:	87aa                	mv	a5,a0
}
    8020b758:	853e                	mv	a0,a5
    8020b75a:	60e2                	ld	ra,24(sp)
    8020b75c:	6442                	ld	s0,16(sp)
    8020b75e:	6105                	addi	sp,sp,32
    8020b760:	8082                	ret

000000008020b762 <create>:
struct inode *
create(char *path, short type, short major, short minor)
{
    8020b762:	7139                	addi	sp,sp,-64
    8020b764:	fc06                	sd	ra,56(sp)
    8020b766:	f822                	sd	s0,48(sp)
    8020b768:	0080                	addi	s0,sp,64
    8020b76a:	fca43423          	sd	a0,-56(s0)
    8020b76e:	87ae                	mv	a5,a1
    8020b770:	8736                	mv	a4,a3
    8020b772:	fcf41323          	sh	a5,-58(s0)
    8020b776:	87b2                	mv	a5,a2
    8020b778:	fcf41223          	sh	a5,-60(s0)
    8020b77c:	87ba                	mv	a5,a4
    8020b77e:	fcf41123          	sh	a5,-62(s0)
	begin_op(); // 开始事务
    8020b782:	ffffe097          	auipc	ra,0xffffe
    8020b786:	9bc080e7          	jalr	-1604(ra) # 8020913e <begin_op>
	char name[DIRSIZ];
	struct inode *dp, *ip;

	// 找到父目录 inode
	dp = nameiparent(path, name);
    8020b78a:	fd040793          	addi	a5,s0,-48
    8020b78e:	85be                	mv	a1,a5
    8020b790:	fc843503          	ld	a0,-56(s0)
    8020b794:	00000097          	auipc	ra,0x0
    8020b798:	fa0080e7          	jalr	-96(ra) # 8020b734 <nameiparent>
    8020b79c:	fea43423          	sd	a0,-24(s0)
	if (dp == 0)
    8020b7a0:	fe843783          	ld	a5,-24(s0)
    8020b7a4:	e399                	bnez	a5,8020b7aa <create+0x48>
		return 0;
    8020b7a6:	4781                	li	a5,0
    8020b7a8:	a279                	j	8020b936 <create+0x1d4>

	ilock(dp);
    8020b7aa:	fe843503          	ld	a0,-24(s0)
    8020b7ae:	fffff097          	auipc	ra,0xfffff
    8020b7b2:	038080e7          	jalr	56(ra) # 8020a7e6 <ilock>

	// 检查是否已存在
	if ((ip = dirlookup(dp, name, 0)) != 0)
    8020b7b6:	fd040793          	addi	a5,s0,-48
    8020b7ba:	4601                	li	a2,0
    8020b7bc:	85be                	mv	a1,a5
    8020b7be:	fe843503          	ld	a0,-24(s0)
    8020b7c2:	00000097          	auipc	ra,0x0
    8020b7c6:	b56080e7          	jalr	-1194(ra) # 8020b318 <dirlookup>
    8020b7ca:	fea43023          	sd	a0,-32(s0)
    8020b7ce:	fe043783          	ld	a5,-32(s0)
    8020b7d2:	c7ad                	beqz	a5,8020b83c <create+0xda>
	{
		iunlockput(dp);
    8020b7d4:	fe843503          	ld	a0,-24(s0)
    8020b7d8:	fffff097          	auipc	ra,0xfffff
    8020b7dc:	276080e7          	jalr	630(ra) # 8020aa4e <iunlockput>
		ilock(ip);
    8020b7e0:	fe043503          	ld	a0,-32(s0)
    8020b7e4:	fffff097          	auipc	ra,0xfffff
    8020b7e8:	002080e7          	jalr	2(ra) # 8020a7e6 <ilock>
		if (type == T_FILE && ip->type == T_FILE) {
    8020b7ec:	fc641783          	lh	a5,-58(s0)
    8020b7f0:	0007871b          	sext.w	a4,a5
    8020b7f4:	4789                	li	a5,2
    8020b7f6:	02f71763          	bne	a4,a5,8020b824 <create+0xc2>
    8020b7fa:	fe043783          	ld	a5,-32(s0)
    8020b7fe:	01479783          	lh	a5,20(a5)
    8020b802:	873e                	mv	a4,a5
    8020b804:	4789                	li	a5,2
    8020b806:	00f71f63          	bne	a4,a5,8020b824 <create+0xc2>
			iunlock(ip); // 释放锁
    8020b80a:	fe043503          	ld	a0,-32(s0)
    8020b80e:	fffff097          	auipc	ra,0xfffff
    8020b812:	10e080e7          	jalr	270(ra) # 8020a91c <iunlock>
			end_op(); // 结束事务
    8020b816:	ffffe097          	auipc	ra,0xffffe
    8020b81a:	a06080e7          	jalr	-1530(ra) # 8020921c <end_op>
			return ip;
    8020b81e:	fe043783          	ld	a5,-32(s0)
    8020b822:	aa11                	j	8020b936 <create+0x1d4>
		}
		iunlockput(ip);
    8020b824:	fe043503          	ld	a0,-32(s0)
    8020b828:	fffff097          	auipc	ra,0xfffff
    8020b82c:	226080e7          	jalr	550(ra) # 8020aa4e <iunlockput>
		end_op(); // 结束事务
    8020b830:	ffffe097          	auipc	ra,0xffffe
    8020b834:	9ec080e7          	jalr	-1556(ra) # 8020921c <end_op>
		return 0;
    8020b838:	4781                	li	a5,0
    8020b83a:	a8f5                	j	8020b936 <create+0x1d4>
	}

	// 分配新 inode
	ip = ialloc(dp->dev, type);
    8020b83c:	fe843783          	ld	a5,-24(s0)
    8020b840:	439c                	lw	a5,0(a5)
    8020b842:	fc641703          	lh	a4,-58(s0)
    8020b846:	85ba                	mv	a1,a4
    8020b848:	853e                	mv	a0,a5
    8020b84a:	fffff097          	auipc	ra,0xfffff
    8020b84e:	c4e080e7          	jalr	-946(ra) # 8020a498 <ialloc>
    8020b852:	fea43023          	sd	a0,-32(s0)
	if (ip == 0)
    8020b856:	fe043783          	ld	a5,-32(s0)
    8020b85a:	eb89                	bnez	a5,8020b86c <create+0x10a>
		panic("create: ialloc");
    8020b85c:	0002b517          	auipc	a0,0x2b
    8020b860:	f4450513          	addi	a0,a0,-188 # 802367a0 <user_test_table+0x1c0>
    8020b864:	ffff6097          	auipc	ra,0xffff6
    8020b868:	f76080e7          	jalr	-138(ra) # 802017da <panic>

	ilock(ip);
    8020b86c:	fe043503          	ld	a0,-32(s0)
    8020b870:	fffff097          	auipc	ra,0xfffff
    8020b874:	f76080e7          	jalr	-138(ra) # 8020a7e6 <ilock>
	ip->major = major;
    8020b878:	fe043783          	ld	a5,-32(s0)
    8020b87c:	fc445703          	lhu	a4,-60(s0)
    8020b880:	00e79b23          	sh	a4,22(a5)
	ip->minor = minor;
    8020b884:	fe043783          	ld	a5,-32(s0)
    8020b888:	fc245703          	lhu	a4,-62(s0)
    8020b88c:	00e79c23          	sh	a4,24(a5)
	ip->nlink = 1;
    8020b890:	fe043783          	ld	a5,-32(s0)
    8020b894:	4705                	li	a4,1
    8020b896:	00e79d23          	sh	a4,26(a5)
	iupdate(ip);
    8020b89a:	fe043503          	ld	a0,-32(s0)
    8020b89e:	fffff097          	auipc	ra,0xfffff
    8020b8a2:	cf8080e7          	jalr	-776(ra) # 8020a596 <iupdate>

	// 添加目录项
	if (type == T_DIR)
    8020b8a6:	fc641783          	lh	a5,-58(s0)
    8020b8aa:	0007871b          	sext.w	a4,a5
    8020b8ae:	4785                	li	a5,1
    8020b8b0:	02f71963          	bne	a4,a5,8020b8e2 <create+0x180>
	{
		dp->nlink++;
    8020b8b4:	fe843783          	ld	a5,-24(s0)
    8020b8b8:	01a79783          	lh	a5,26(a5)
    8020b8bc:	17c2                	slli	a5,a5,0x30
    8020b8be:	93c1                	srli	a5,a5,0x30
    8020b8c0:	2785                	addiw	a5,a5,1
    8020b8c2:	17c2                	slli	a5,a5,0x30
    8020b8c4:	93c1                	srli	a5,a5,0x30
    8020b8c6:	0107971b          	slliw	a4,a5,0x10
    8020b8ca:	4107571b          	sraiw	a4,a4,0x10
    8020b8ce:	fe843783          	ld	a5,-24(s0)
    8020b8d2:	00e79d23          	sh	a4,26(a5)
		iupdate(dp);
    8020b8d6:	fe843503          	ld	a0,-24(s0)
    8020b8da:	fffff097          	auipc	ra,0xfffff
    8020b8de:	cbc080e7          	jalr	-836(ra) # 8020a596 <iupdate>
	}

	if (dirlink(dp, name, ip->inum) < 0)
    8020b8e2:	fe043783          	ld	a5,-32(s0)
    8020b8e6:	43d8                	lw	a4,4(a5)
    8020b8e8:	fd040793          	addi	a5,s0,-48
    8020b8ec:	863a                	mv	a2,a4
    8020b8ee:	85be                	mv	a1,a5
    8020b8f0:	fe843503          	ld	a0,-24(s0)
    8020b8f4:	00000097          	auipc	ra,0x0
    8020b8f8:	b0a080e7          	jalr	-1270(ra) # 8020b3fe <dirlink>
    8020b8fc:	87aa                	mv	a5,a0
    8020b8fe:	0007da63          	bgez	a5,8020b912 <create+0x1b0>
		panic("create: dirlink");
    8020b902:	0002b517          	auipc	a0,0x2b
    8020b906:	eae50513          	addi	a0,a0,-338 # 802367b0 <user_test_table+0x1d0>
    8020b90a:	ffff6097          	auipc	ra,0xffff6
    8020b90e:	ed0080e7          	jalr	-304(ra) # 802017da <panic>

	iunlockput(dp);
    8020b912:	fe843503          	ld	a0,-24(s0)
    8020b916:	fffff097          	auipc	ra,0xfffff
    8020b91a:	138080e7          	jalr	312(ra) # 8020aa4e <iunlockput>
	iunlock(ip);
    8020b91e:	fe043503          	ld	a0,-32(s0)
    8020b922:	fffff097          	auipc	ra,0xfffff
    8020b926:	ffa080e7          	jalr	-6(ra) # 8020a91c <iunlock>
	end_op(); 
    8020b92a:	ffffe097          	auipc	ra,0xffffe
    8020b92e:	8f2080e7          	jalr	-1806(ra) # 8020921c <end_op>
	return ip;
    8020b932:	fe043783          	ld	a5,-32(s0)
}
    8020b936:	853e                	mv	a0,a5
    8020b938:	70e2                	ld	ra,56(sp)
    8020b93a:	7442                	ld	s0,48(sp)
    8020b93c:	6121                	addi	sp,sp,64
    8020b93e:	8082                	ret

000000008020b940 <unlink>:
int unlink(char *path)
{
    8020b940:	711d                	addi	sp,sp,-96
    8020b942:	ec86                	sd	ra,88(sp)
    8020b944:	e8a2                	sd	s0,80(sp)
    8020b946:	1080                	addi	s0,sp,96
    8020b948:	faa43423          	sd	a0,-88(s0)
	begin_op(); // 开始事务
    8020b94c:	ffffd097          	auipc	ra,0xffffd
    8020b950:	7f2080e7          	jalr	2034(ra) # 8020913e <begin_op>
	struct inode *dp, *ip;
	char name[DIRSIZ];
	uint off;

	dp = nameiparent(path, name);
    8020b954:	fd040793          	addi	a5,s0,-48
    8020b958:	85be                	mv	a1,a5
    8020b95a:	fa843503          	ld	a0,-88(s0)
    8020b95e:	00000097          	auipc	ra,0x0
    8020b962:	dd6080e7          	jalr	-554(ra) # 8020b734 <nameiparent>
    8020b966:	fea43423          	sd	a0,-24(s0)
	if (dp == 0)
    8020b96a:	fe843783          	ld	a5,-24(s0)
    8020b96e:	e399                	bnez	a5,8020b974 <unlink+0x34>
		return -1;
    8020b970:	57fd                	li	a5,-1
    8020b972:	a8fd                	j	8020ba70 <unlink+0x130>

	ilock(dp);
    8020b974:	fe843503          	ld	a0,-24(s0)
    8020b978:	fffff097          	auipc	ra,0xfffff
    8020b97c:	e6e080e7          	jalr	-402(ra) # 8020a7e6 <ilock>

	if ((ip = dirlookup(dp, name, &off)) == 0)
    8020b980:	fcc40713          	addi	a4,s0,-52
    8020b984:	fd040793          	addi	a5,s0,-48
    8020b988:	863a                	mv	a2,a4
    8020b98a:	85be                	mv	a1,a5
    8020b98c:	fe843503          	ld	a0,-24(s0)
    8020b990:	00000097          	auipc	ra,0x0
    8020b994:	988080e7          	jalr	-1656(ra) # 8020b318 <dirlookup>
    8020b998:	fea43023          	sd	a0,-32(s0)
    8020b99c:	fe043783          	ld	a5,-32(s0)
    8020b9a0:	eb89                	bnez	a5,8020b9b2 <unlink+0x72>
	{
		iunlockput(dp);
    8020b9a2:	fe843503          	ld	a0,-24(s0)
    8020b9a6:	fffff097          	auipc	ra,0xfffff
    8020b9aa:	0a8080e7          	jalr	168(ra) # 8020aa4e <iunlockput>
		return -1;
    8020b9ae:	57fd                	li	a5,-1
    8020b9b0:	a0c1                	j	8020ba70 <unlink+0x130>
	}

	ilock(ip);
    8020b9b2:	fe043503          	ld	a0,-32(s0)
    8020b9b6:	fffff097          	auipc	ra,0xfffff
    8020b9ba:	e30080e7          	jalr	-464(ra) # 8020a7e6 <ilock>

	if (ip->nlink < 1)
    8020b9be:	fe043783          	ld	a5,-32(s0)
    8020b9c2:	01a79783          	lh	a5,26(a5)
    8020b9c6:	00f04a63          	bgtz	a5,8020b9da <unlink+0x9a>
		panic("unlink: nlink < 1");
    8020b9ca:	0002b517          	auipc	a0,0x2b
    8020b9ce:	df650513          	addi	a0,a0,-522 # 802367c0 <user_test_table+0x1e0>
    8020b9d2:	ffff6097          	auipc	ra,0xffff6
    8020b9d6:	e08080e7          	jalr	-504(ra) # 802017da <panic>

	ip->nlink--;
    8020b9da:	fe043783          	ld	a5,-32(s0)
    8020b9de:	01a79783          	lh	a5,26(a5)
    8020b9e2:	17c2                	slli	a5,a5,0x30
    8020b9e4:	93c1                	srli	a5,a5,0x30
    8020b9e6:	37fd                	addiw	a5,a5,-1
    8020b9e8:	17c2                	slli	a5,a5,0x30
    8020b9ea:	93c1                	srli	a5,a5,0x30
    8020b9ec:	0107971b          	slliw	a4,a5,0x10
    8020b9f0:	4107571b          	sraiw	a4,a4,0x10
    8020b9f4:	fe043783          	ld	a5,-32(s0)
    8020b9f8:	00e79d23          	sh	a4,26(a5)
	iupdate(ip);
    8020b9fc:	fe043503          	ld	a0,-32(s0)
    8020ba00:	fffff097          	auipc	ra,0xfffff
    8020ba04:	b96080e7          	jalr	-1130(ra) # 8020a596 <iupdate>

	// 清空目录项
	struct dirent de;
	memset(&de, 0, sizeof(de));
    8020ba08:	fb840793          	addi	a5,s0,-72
    8020ba0c:	4641                	li	a2,16
    8020ba0e:	4581                	li	a1,0
    8020ba10:	853e                	mv	a0,a5
    8020ba12:	ffff6097          	auipc	ra,0xffff6
    8020ba16:	506080e7          	jalr	1286(ra) # 80201f18 <memset>
	if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8020ba1a:	fb840793          	addi	a5,s0,-72
    8020ba1e:	fcc42683          	lw	a3,-52(s0)
    8020ba22:	4741                	li	a4,16
    8020ba24:	863e                	mv	a2,a5
    8020ba26:	4581                	li	a1,0
    8020ba28:	fe843503          	ld	a0,-24(s0)
    8020ba2c:	fffff097          	auipc	ra,0xfffff
    8020ba30:	702080e7          	jalr	1794(ra) # 8020b12e <writei>
    8020ba34:	87aa                	mv	a5,a0
    8020ba36:	873e                	mv	a4,a5
    8020ba38:	47c1                	li	a5,16
    8020ba3a:	00f70a63          	beq	a4,a5,8020ba4e <unlink+0x10e>
		panic("unlink: writei");
    8020ba3e:	0002b517          	auipc	a0,0x2b
    8020ba42:	d9a50513          	addi	a0,a0,-614 # 802367d8 <user_test_table+0x1f8>
    8020ba46:	ffff6097          	auipc	ra,0xffff6
    8020ba4a:	d94080e7          	jalr	-620(ra) # 802017da <panic>

	iunlockput(ip);
    8020ba4e:	fe043503          	ld	a0,-32(s0)
    8020ba52:	fffff097          	auipc	ra,0xfffff
    8020ba56:	ffc080e7          	jalr	-4(ra) # 8020aa4e <iunlockput>
	iunlockput(dp);
    8020ba5a:	fe843503          	ld	a0,-24(s0)
    8020ba5e:	fffff097          	auipc	ra,0xfffff
    8020ba62:	ff0080e7          	jalr	-16(ra) # 8020aa4e <iunlockput>
	end_op(); // 结束事务
    8020ba66:	ffffd097          	auipc	ra,0xffffd
    8020ba6a:	7b6080e7          	jalr	1974(ra) # 8020921c <end_op>
	return 0;
    8020ba6e:	4781                	li	a5,0
    8020ba70:	853e                	mv	a0,a5
    8020ba72:	60e6                	ld	ra,88(sp)
    8020ba74:	6446                	ld	s0,80(sp)
    8020ba76:	6125                	addi	sp,sp,96
    8020ba78:	8082                	ret

000000008020ba7a <r_sstatus>:
    8020ba7a:	1101                	addi	sp,sp,-32
    8020ba7c:	ec22                	sd	s0,24(sp)
    8020ba7e:	1000                	addi	s0,sp,32
    8020ba80:	100027f3          	csrr	a5,sstatus
    8020ba84:	fef43423          	sd	a5,-24(s0)
    8020ba88:	fe843783          	ld	a5,-24(s0)
    8020ba8c:	853e                	mv	a0,a5
    8020ba8e:	6462                	ld	s0,24(sp)
    8020ba90:	6105                	addi	sp,sp,32
    8020ba92:	8082                	ret

000000008020ba94 <w_sstatus>:
    8020ba94:	1101                	addi	sp,sp,-32
    8020ba96:	ec22                	sd	s0,24(sp)
    8020ba98:	1000                	addi	s0,sp,32
    8020ba9a:	fea43423          	sd	a0,-24(s0)
    8020ba9e:	fe843783          	ld	a5,-24(s0)
    8020baa2:	10079073          	csrw	sstatus,a5
    8020baa6:	0001                	nop
    8020baa8:	6462                	ld	s0,24(sp)
    8020baaa:	6105                	addi	sp,sp,32
    8020baac:	8082                	ret

000000008020baae <intr_on>:
    8020baae:	1141                	addi	sp,sp,-16
    8020bab0:	e406                	sd	ra,8(sp)
    8020bab2:	e022                	sd	s0,0(sp)
    8020bab4:	0800                	addi	s0,sp,16
    8020bab6:	00000097          	auipc	ra,0x0
    8020baba:	fc4080e7          	jalr	-60(ra) # 8020ba7a <r_sstatus>
    8020babe:	87aa                	mv	a5,a0
    8020bac0:	0027e793          	ori	a5,a5,2
    8020bac4:	853e                	mv	a0,a5
    8020bac6:	00000097          	auipc	ra,0x0
    8020baca:	fce080e7          	jalr	-50(ra) # 8020ba94 <w_sstatus>
    8020bace:	0001                	nop
    8020bad0:	60a2                	ld	ra,8(sp)
    8020bad2:	6402                	ld	s0,0(sp)
    8020bad4:	0141                	addi	sp,sp,16
    8020bad6:	8082                	ret

000000008020bad8 <intr_off>:
    8020bad8:	1141                	addi	sp,sp,-16
    8020bada:	e406                	sd	ra,8(sp)
    8020badc:	e022                	sd	s0,0(sp)
    8020bade:	0800                	addi	s0,sp,16
    8020bae0:	00000097          	auipc	ra,0x0
    8020bae4:	f9a080e7          	jalr	-102(ra) # 8020ba7a <r_sstatus>
    8020bae8:	87aa                	mv	a5,a0
    8020baea:	9bf5                	andi	a5,a5,-3
    8020baec:	853e                	mv	a0,a5
    8020baee:	00000097          	auipc	ra,0x0
    8020baf2:	fa6080e7          	jalr	-90(ra) # 8020ba94 <w_sstatus>
    8020baf6:	0001                	nop
    8020baf8:	60a2                	ld	ra,8(sp)
    8020bafa:	6402                	ld	s0,0(sp)
    8020bafc:	0141                	addi	sp,sp,16
    8020bafe:	8082                	ret

000000008020bb00 <initlock>:
{
    8020bb00:	1101                	addi	sp,sp,-32
    8020bb02:	ec22                	sd	s0,24(sp)
    8020bb04:	1000                	addi	s0,sp,32
    8020bb06:	fea43423          	sd	a0,-24(s0)
    8020bb0a:	feb43023          	sd	a1,-32(s0)
  lk->name = name;
    8020bb0e:	fe843783          	ld	a5,-24(s0)
    8020bb12:	fe043703          	ld	a4,-32(s0)
    8020bb16:	e798                	sd	a4,8(a5)
  lk->locked = 0;
    8020bb18:	fe843783          	ld	a5,-24(s0)
    8020bb1c:	0007a023          	sw	zero,0(a5)
}
    8020bb20:	0001                	nop
    8020bb22:	6462                	ld	s0,24(sp)
    8020bb24:	6105                	addi	sp,sp,32
    8020bb26:	8082                	ret

000000008020bb28 <acquire>:
{
    8020bb28:	1101                	addi	sp,sp,-32
    8020bb2a:	ec06                	sd	ra,24(sp)
    8020bb2c:	e822                	sd	s0,16(sp)
    8020bb2e:	1000                	addi	s0,sp,32
    8020bb30:	fea43423          	sd	a0,-24(s0)
  intr_off(); // 直接关闭中断
    8020bb34:	00000097          	auipc	ra,0x0
    8020bb38:	fa4080e7          	jalr	-92(ra) # 8020bad8 <intr_off>
  if(lk->locked)
    8020bb3c:	fe843783          	ld	a5,-24(s0)
    8020bb40:	439c                	lw	a5,0(a5)
    8020bb42:	cb89                	beqz	a5,8020bb54 <acquire+0x2c>
    panic("acquire");
    8020bb44:	0002d517          	auipc	a0,0x2d
    8020bb48:	d5450513          	addi	a0,a0,-684 # 80238898 <user_test_table+0x78>
    8020bb4c:	ffff6097          	auipc	ra,0xffff6
    8020bb50:	c8e080e7          	jalr	-882(ra) # 802017da <panic>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8020bb54:	0001                	nop
    8020bb56:	fe843783          	ld	a5,-24(s0)
    8020bb5a:	4705                	li	a4,1
    8020bb5c:	0ce7a72f          	amoswap.w.aq	a4,a4,(a5)
    8020bb60:	0007079b          	sext.w	a5,a4
    8020bb64:	fbed                	bnez	a5,8020bb56 <acquire+0x2e>
  __sync_synchronize();
    8020bb66:	0ff0000f          	fence
}
    8020bb6a:	0001                	nop
    8020bb6c:	60e2                	ld	ra,24(sp)
    8020bb6e:	6442                	ld	s0,16(sp)
    8020bb70:	6105                	addi	sp,sp,32
    8020bb72:	8082                	ret

000000008020bb74 <release>:
{
    8020bb74:	1101                	addi	sp,sp,-32
    8020bb76:	ec06                	sd	ra,24(sp)
    8020bb78:	e822                	sd	s0,16(sp)
    8020bb7a:	1000                	addi	s0,sp,32
    8020bb7c:	fea43423          	sd	a0,-24(s0)
  if(!lk->locked)
    8020bb80:	fe843783          	ld	a5,-24(s0)
    8020bb84:	439c                	lw	a5,0(a5)
    8020bb86:	eb89                	bnez	a5,8020bb98 <release+0x24>
    panic("release");
    8020bb88:	0002d517          	auipc	a0,0x2d
    8020bb8c:	d1850513          	addi	a0,a0,-744 # 802388a0 <user_test_table+0x80>
    8020bb90:	ffff6097          	auipc	ra,0xffff6
    8020bb94:	c4a080e7          	jalr	-950(ra) # 802017da <panic>
  __sync_synchronize();
    8020bb98:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8020bb9c:	fe843783          	ld	a5,-24(s0)
    8020bba0:	0f50000f          	fence	iorw,ow
    8020bba4:	0807a02f          	amoswap.w	zero,zero,(a5)
  intr_on(); // 直接开启中断
    8020bba8:	00000097          	auipc	ra,0x0
    8020bbac:	f06080e7          	jalr	-250(ra) # 8020baae <intr_on>
}
    8020bbb0:	0001                	nop
    8020bbb2:	60e2                	ld	ra,24(sp)
    8020bbb4:	6442                	ld	s0,16(sp)
    8020bbb6:	6105                	addi	sp,sp,32
    8020bbb8:	8082                	ret

000000008020bbba <holding>:
{
    8020bbba:	1101                	addi	sp,sp,-32
    8020bbbc:	ec22                	sd	s0,24(sp)
    8020bbbe:	1000                	addi	s0,sp,32
    8020bbc0:	fea43423          	sd	a0,-24(s0)
  return lk->locked;
    8020bbc4:	fe843783          	ld	a5,-24(s0)
    8020bbc8:	439c                	lw	a5,0(a5)
    8020bbca:	2781                	sext.w	a5,a5
    8020bbcc:	853e                	mv	a0,a5
    8020bbce:	6462                	ld	s0,24(sp)
    8020bbd0:	6105                	addi	sp,sp,32
    8020bbd2:	8082                	ret

000000008020bbd4 <initsleeplock>:
#include "defs.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8020bbd4:	1101                	addi	sp,sp,-32
    8020bbd6:	ec06                	sd	ra,24(sp)
    8020bbd8:	e822                	sd	s0,16(sp)
    8020bbda:	1000                	addi	s0,sp,32
    8020bbdc:	fea43423          	sd	a0,-24(s0)
    8020bbe0:	feb43023          	sd	a1,-32(s0)
  initlock(&lk->lk, "sleep lock");
    8020bbe4:	fe843783          	ld	a5,-24(s0)
    8020bbe8:	07a1                	addi	a5,a5,8
    8020bbea:	0002f597          	auipc	a1,0x2f
    8020bbee:	d6e58593          	addi	a1,a1,-658 # 8023a958 <user_test_table+0x78>
    8020bbf2:	853e                	mv	a0,a5
    8020bbf4:	00000097          	auipc	ra,0x0
    8020bbf8:	f0c080e7          	jalr	-244(ra) # 8020bb00 <initlock>
  lk->name = name;
    8020bbfc:	fe843783          	ld	a5,-24(s0)
    8020bc00:	fe043703          	ld	a4,-32(s0)
    8020bc04:	ef98                	sd	a4,24(a5)
  lk->locked = 0;
    8020bc06:	fe843783          	ld	a5,-24(s0)
    8020bc0a:	0007a023          	sw	zero,0(a5)
  lk->pid = 0;
    8020bc0e:	fe843783          	ld	a5,-24(s0)
    8020bc12:	0207a023          	sw	zero,32(a5)
}
    8020bc16:	0001                	nop
    8020bc18:	60e2                	ld	ra,24(sp)
    8020bc1a:	6442                	ld	s0,16(sp)
    8020bc1c:	6105                	addi	sp,sp,32
    8020bc1e:	8082                	ret

000000008020bc20 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8020bc20:	1101                	addi	sp,sp,-32
    8020bc22:	ec06                	sd	ra,24(sp)
    8020bc24:	e822                	sd	s0,16(sp)
    8020bc26:	1000                	addi	s0,sp,32
    8020bc28:	fea43423          	sd	a0,-24(s0)
  acquire(&lk->lk);
    8020bc2c:	fe843783          	ld	a5,-24(s0)
    8020bc30:	07a1                	addi	a5,a5,8
    8020bc32:	853e                	mv	a0,a5
    8020bc34:	00000097          	auipc	ra,0x0
    8020bc38:	ef4080e7          	jalr	-268(ra) # 8020bb28 <acquire>
  while (lk->locked) {
    8020bc3c:	a819                	j	8020bc52 <acquiresleep+0x32>
    sleep(lk, &lk->lk);
    8020bc3e:	fe843783          	ld	a5,-24(s0)
    8020bc42:	07a1                	addi	a5,a5,8
    8020bc44:	85be                	mv	a1,a5
    8020bc46:	fe843503          	ld	a0,-24(s0)
    8020bc4a:	ffffa097          	auipc	ra,0xffffa
    8020bc4e:	118080e7          	jalr	280(ra) # 80205d62 <sleep>
  while (lk->locked) {
    8020bc52:	fe843783          	ld	a5,-24(s0)
    8020bc56:	439c                	lw	a5,0(a5)
    8020bc58:	f3fd                	bnez	a5,8020bc3e <acquiresleep+0x1e>
  }
  lk->locked = 1;
    8020bc5a:	fe843783          	ld	a5,-24(s0)
    8020bc5e:	4705                	li	a4,1
    8020bc60:	c398                	sw	a4,0(a5)
  lk->pid = myproc()->pid;
    8020bc62:	ffff9097          	auipc	ra,0xffff9
    8020bc66:	3de080e7          	jalr	990(ra) # 80205040 <myproc>
    8020bc6a:	87aa                	mv	a5,a0
    8020bc6c:	43d8                	lw	a4,4(a5)
    8020bc6e:	fe843783          	ld	a5,-24(s0)
    8020bc72:	d398                	sw	a4,32(a5)
  release(&lk->lk);
    8020bc74:	fe843783          	ld	a5,-24(s0)
    8020bc78:	07a1                	addi	a5,a5,8
    8020bc7a:	853e                	mv	a0,a5
    8020bc7c:	00000097          	auipc	ra,0x0
    8020bc80:	ef8080e7          	jalr	-264(ra) # 8020bb74 <release>
}
    8020bc84:	0001                	nop
    8020bc86:	60e2                	ld	ra,24(sp)
    8020bc88:	6442                	ld	s0,16(sp)
    8020bc8a:	6105                	addi	sp,sp,32
    8020bc8c:	8082                	ret

000000008020bc8e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8020bc8e:	1101                	addi	sp,sp,-32
    8020bc90:	ec06                	sd	ra,24(sp)
    8020bc92:	e822                	sd	s0,16(sp)
    8020bc94:	1000                	addi	s0,sp,32
    8020bc96:	fea43423          	sd	a0,-24(s0)
  acquire(&lk->lk);
    8020bc9a:	fe843783          	ld	a5,-24(s0)
    8020bc9e:	07a1                	addi	a5,a5,8
    8020bca0:	853e                	mv	a0,a5
    8020bca2:	00000097          	auipc	ra,0x0
    8020bca6:	e86080e7          	jalr	-378(ra) # 8020bb28 <acquire>
  lk->locked = 0;
    8020bcaa:	fe843783          	ld	a5,-24(s0)
    8020bcae:	0007a023          	sw	zero,0(a5)
  lk->pid = 0;
    8020bcb2:	fe843783          	ld	a5,-24(s0)
    8020bcb6:	0207a023          	sw	zero,32(a5)
  wakeup(lk);
    8020bcba:	fe843503          	ld	a0,-24(s0)
    8020bcbe:	ffffa097          	auipc	ra,0xffffa
    8020bcc2:	15c080e7          	jalr	348(ra) # 80205e1a <wakeup>
  release(&lk->lk);
    8020bcc6:	fe843783          	ld	a5,-24(s0)
    8020bcca:	07a1                	addi	a5,a5,8
    8020bccc:	853e                	mv	a0,a5
    8020bcce:	00000097          	auipc	ra,0x0
    8020bcd2:	ea6080e7          	jalr	-346(ra) # 8020bb74 <release>
}
    8020bcd6:	0001                	nop
    8020bcd8:	60e2                	ld	ra,24(sp)
    8020bcda:	6442                	ld	s0,16(sp)
    8020bcdc:	6105                	addi	sp,sp,32
    8020bcde:	8082                	ret

000000008020bce0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8020bce0:	7139                	addi	sp,sp,-64
    8020bce2:	fc06                	sd	ra,56(sp)
    8020bce4:	f822                	sd	s0,48(sp)
    8020bce6:	f426                	sd	s1,40(sp)
    8020bce8:	0080                	addi	s0,sp,64
    8020bcea:	fca43423          	sd	a0,-56(s0)
  int r;
  
  acquire(&lk->lk);
    8020bcee:	fc843783          	ld	a5,-56(s0)
    8020bcf2:	07a1                	addi	a5,a5,8
    8020bcf4:	853e                	mv	a0,a5
    8020bcf6:	00000097          	auipc	ra,0x0
    8020bcfa:	e32080e7          	jalr	-462(ra) # 8020bb28 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8020bcfe:	fc843783          	ld	a5,-56(s0)
    8020bd02:	439c                	lw	a5,0(a5)
    8020bd04:	cf99                	beqz	a5,8020bd22 <holdingsleep+0x42>
    8020bd06:	fc843783          	ld	a5,-56(s0)
    8020bd0a:	5384                	lw	s1,32(a5)
    8020bd0c:	ffff9097          	auipc	ra,0xffff9
    8020bd10:	334080e7          	jalr	820(ra) # 80205040 <myproc>
    8020bd14:	87aa                	mv	a5,a0
    8020bd16:	43dc                	lw	a5,4(a5)
    8020bd18:	8726                	mv	a4,s1
    8020bd1a:	00f71463          	bne	a4,a5,8020bd22 <holdingsleep+0x42>
    8020bd1e:	4785                	li	a5,1
    8020bd20:	a011                	j	8020bd24 <holdingsleep+0x44>
    8020bd22:	4781                	li	a5,0
    8020bd24:	fcf42e23          	sw	a5,-36(s0)
  release(&lk->lk);
    8020bd28:	fc843783          	ld	a5,-56(s0)
    8020bd2c:	07a1                	addi	a5,a5,8
    8020bd2e:	853e                	mv	a0,a5
    8020bd30:	00000097          	auipc	ra,0x0
    8020bd34:	e44080e7          	jalr	-444(ra) # 8020bb74 <release>
  return r;
    8020bd38:	fdc42783          	lw	a5,-36(s0)
}
    8020bd3c:	853e                	mv	a0,a5
    8020bd3e:	70e2                	ld	ra,56(sp)
    8020bd40:	7442                	ld	s0,48(sp)
    8020bd42:	74a2                	ld	s1,40(sp)
    8020bd44:	6121                	addi	sp,sp,64
    8020bd46:	8082                	ret
	...
