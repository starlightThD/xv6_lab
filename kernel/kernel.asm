
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_entry>:
.section .text # 设置代码段，基于内存的段式管理
.global _entry # 设置全局入口点，告知连接器入口地址

_entry: # 定义入口点标签
		la sp, stack0
    80200000:	00025117          	auipc	sp,0x25
    80200004:	00010113          	mv	sp,sp
        li a0,4096*4 # 表示4096个字节单位
    80200008:	6511                	lui	a0,0x4
        add sp,sp,a0 # 初始化栈指针
    8020000a:	912a                	add	sp,sp,a0

        la a0,_bss_start
    8020000c:	00026517          	auipc	a0,0x26
    80200010:	13450513          	addi	a0,a0,308 # 80226140 <kernel_pagetable>
        la a1,_bss_end
    80200014:	00026597          	auipc	a1,0x26
    80200018:	78c58593          	addi	a1,a1,1932 # 802267a0 <_bss_end>

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
    80200032:	1101                	addi	sp,sp,-32 # 80224fe0 <syscall_performance_bin+0x2e68>
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
    80200098:	03d00793          	li	a5,61
    8020009c:	2781                	sext.w	a5,a5
    8020009e:	85be                	mv	a1,a5
    802000a0:	00009517          	auipc	a0,0x9
    802000a4:	36850513          	addi	a0,a0,872 # 80209408 <hello_world_bin>
    802000a8:	00005097          	auipc	ra,0x5
    802000ac:	5a4080e7          	jalr	1444(ra) # 8020564c <create_user_proc>
	wait_proc(NULL);
    802000b0:	4501                	li	a0,0
    802000b2:	00006097          	auipc	ra,0x6
    802000b6:	ce0080e7          	jalr	-800(ra) # 80205d92 <wait_proc>
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
    802000d0:	174080e7          	jalr	372(ra) # 80203240 <pmm_init>
	kvminit();
    802000d4:	00002097          	auipc	ra,0x2
    802000d8:	748080e7          	jalr	1864(ra) # 8020281c <kvminit>
	trap_init();
    802000dc:	00003097          	auipc	ra,0x3
    802000e0:	788080e7          	jalr	1928(ra) # 80203864 <trap_init>
	uart_init();
    802000e4:	00000097          	auipc	ra,0x0
    802000e8:	4ea080e7          	jalr	1258(ra) # 802005ce <uart_init>
	intr_on();
    802000ec:	00000097          	auipc	ra,0x0
    802000f0:	f7a080e7          	jalr	-134(ra) # 80200066 <intr_on>
    printf("===============================================\n");
    802000f4:	0000a517          	auipc	a0,0xa
    802000f8:	07c50513          	addi	a0,a0,124 # 8020a170 <syscall_performance_bin+0x878>
    802000fc:	00001097          	auipc	ra,0x1
    80200100:	bda080e7          	jalr	-1062(ra) # 80200cd6 <printf>
    printf("        RISC-V Operating System v1.0         \n");
    80200104:	0000a517          	auipc	a0,0xa
    80200108:	0a450513          	addi	a0,a0,164 # 8020a1a8 <syscall_performance_bin+0x8b0>
    8020010c:	00001097          	auipc	ra,0x1
    80200110:	bca080e7          	jalr	-1078(ra) # 80200cd6 <printf>
    printf("===============================================\n\n");
    80200114:	0000a517          	auipc	a0,0xa
    80200118:	0c450513          	addi	a0,a0,196 # 8020a1d8 <syscall_performance_bin+0x8e0>
    8020011c:	00001097          	auipc	ra,0x1
    80200120:	bba080e7          	jalr	-1094(ra) # 80200cd6 <printf>
	init_proc(); // 初始化进程管理子系统
    80200124:	00005097          	auipc	ra,0x5
    80200128:	002080e7          	jalr	2(ra) # 80205126 <init_proc>
	int main_pid = create_kernel_proc(kernel_main);
    8020012c:	00000517          	auipc	a0,0x0
    80200130:	3fc50513          	addi	a0,a0,1020 # 80200528 <kernel_main>
    80200134:	00005097          	auipc	ra,0x5
    80200138:	42c080e7          	jalr	1068(ra) # 80205560 <create_kernel_proc>
    8020013c:	87aa                	mv	a5,a0
    8020013e:	fef42623          	sw	a5,-20(s0)
	if (main_pid < 0){
    80200142:	fec42783          	lw	a5,-20(s0)
    80200146:	2781                	sext.w	a5,a5
    80200148:	0007da63          	bgez	a5,8020015c <start+0x98>
		panic("START: create main process failed!\n");
    8020014c:	0000a517          	auipc	a0,0xa
    80200150:	0c450513          	addi	a0,a0,196 # 8020a210 <syscall_performance_bin+0x918>
    80200154:	00001097          	auipc	ra,0x1
    80200158:	5ce080e7          	jalr	1486(ra) # 80201722 <panic>
	schedule();
    8020015c:	00006097          	auipc	ra,0x6
    80200160:	8b0080e7          	jalr	-1872(ra) # 80205a0c <schedule>
    panic("START: main() exit unexpectedly!!!\n");
    80200164:	0000a517          	auipc	a0,0xa
    80200168:	0d450513          	addi	a0,a0,212 # 8020a238 <syscall_performance_bin+0x940>
    8020016c:	00001097          	auipc	ra,0x1
    80200170:	5b6080e7          	jalr	1462(ra) # 80201722 <panic>
}
    80200174:	0001                	nop
    80200176:	60e2                	ld	ra,24(sp)
    80200178:	6442                	ld	s0,16(sp)
    8020017a:	6105                	addi	sp,sp,32
    8020017c:	8082                	ret

000000008020017e <print_menu>:
void print_menu(void) {
    8020017e:	1101                	addi	sp,sp,-32
    80200180:	ec06                	sd	ra,24(sp)
    80200182:	e822                	sd	s0,16(sp)
    80200184:	1000                	addi	s0,sp,32
    printf("\n可用命令:\n");
    80200186:	0000a517          	auipc	a0,0xa
    8020018a:	0da50513          	addi	a0,a0,218 # 8020a260 <syscall_performance_bin+0x968>
    8020018e:	00001097          	auipc	ra,0x1
    80200192:	b48080e7          	jalr	-1208(ra) # 80200cd6 <printf>
    for (int i = 0; i < COMMAND_COUNT; i++) {
    80200196:	fe042623          	sw	zero,-20(s0)
    8020019a:	a8a1                	j	802001f2 <print_menu+0x74>
        printf("  %d. %s \t\t\t-%s\n", i+1, command_table[i].name, command_table[i].desc);
    8020019c:	fec42783          	lw	a5,-20(s0)
    802001a0:	2785                	addiw	a5,a5,1
    802001a2:	0007859b          	sext.w	a1,a5
    802001a6:	00026697          	auipc	a3,0x26
    802001aa:	e5a68693          	addi	a3,a3,-422 # 80226000 <command_table>
    802001ae:	fec42703          	lw	a4,-20(s0)
    802001b2:	87ba                	mv	a5,a4
    802001b4:	0786                	slli	a5,a5,0x1
    802001b6:	97ba                	add	a5,a5,a4
    802001b8:	078e                	slli	a5,a5,0x3
    802001ba:	97b6                	add	a5,a5,a3
    802001bc:	6390                	ld	a2,0(a5)
    802001be:	00026697          	auipc	a3,0x26
    802001c2:	e4268693          	addi	a3,a3,-446 # 80226000 <command_table>
    802001c6:	fec42703          	lw	a4,-20(s0)
    802001ca:	87ba                	mv	a5,a4
    802001cc:	0786                	slli	a5,a5,0x1
    802001ce:	97ba                	add	a5,a5,a4
    802001d0:	078e                	slli	a5,a5,0x3
    802001d2:	97b6                	add	a5,a5,a3
    802001d4:	6b9c                	ld	a5,16(a5)
    802001d6:	86be                	mv	a3,a5
    802001d8:	0000a517          	auipc	a0,0xa
    802001dc:	09850513          	addi	a0,a0,152 # 8020a270 <syscall_performance_bin+0x978>
    802001e0:	00001097          	auipc	ra,0x1
    802001e4:	af6080e7          	jalr	-1290(ra) # 80200cd6 <printf>
    for (int i = 0; i < COMMAND_COUNT; i++) {
    802001e8:	fec42783          	lw	a5,-20(s0)
    802001ec:	2785                	addiw	a5,a5,1
    802001ee:	fef42623          	sw	a5,-20(s0)
    802001f2:	fec42783          	lw	a5,-20(s0)
    802001f6:	873e                	mv	a4,a5
    802001f8:	47ad                	li	a5,11
    802001fa:	fae7f1e3          	bgeu	a5,a4,8020019c <print_menu+0x1e>
    printf("  h. help          - 显示此帮助\n");
    802001fe:	0000a517          	auipc	a0,0xa
    80200202:	08a50513          	addi	a0,a0,138 # 8020a288 <syscall_performance_bin+0x990>
    80200206:	00001097          	auipc	ra,0x1
    8020020a:	ad0080e7          	jalr	-1328(ra) # 80200cd6 <printf>
    printf("  e. exit          - 退出控制台\n");
    8020020e:	0000a517          	auipc	a0,0xa
    80200212:	0a250513          	addi	a0,a0,162 # 8020a2b0 <syscall_performance_bin+0x9b8>
    80200216:	00001097          	auipc	ra,0x1
    8020021a:	ac0080e7          	jalr	-1344(ra) # 80200cd6 <printf>
    printf("  p. ps            - 显示进程状态\n");
    8020021e:	0000a517          	auipc	a0,0xa
    80200222:	0ba50513          	addi	a0,a0,186 # 8020a2d8 <syscall_performance_bin+0x9e0>
    80200226:	00001097          	auipc	ra,0x1
    8020022a:	ab0080e7          	jalr	-1360(ra) # 80200cd6 <printf>
}
    8020022e:	0001                	nop
    80200230:	60e2                	ld	ra,24(sp)
    80200232:	6442                	ld	s0,16(sp)
    80200234:	6105                	addi	sp,sp,32
    80200236:	8082                	ret

0000000080200238 <console>:
void console(void) {
    80200238:	7169                	addi	sp,sp,-304
    8020023a:	f606                	sd	ra,296(sp)
    8020023c:	f222                	sd	s0,288(sp)
    8020023e:	1a00                	addi	s0,sp,304
    int exit_requested = 0;
    80200240:	fe042623          	sw	zero,-20(s0)
    print_menu();
    80200244:	00000097          	auipc	ra,0x0
    80200248:	f3a080e7          	jalr	-198(ra) # 8020017e <print_menu>
    while (!exit_requested) {
    8020024c:	ac65                	j	80200504 <console+0x2cc>
        printf("\nConsole >>> ");
    8020024e:	0000a517          	auipc	a0,0xa
    80200252:	0ba50513          	addi	a0,a0,186 # 8020a308 <syscall_performance_bin+0xa10>
    80200256:	00001097          	auipc	ra,0x1
    8020025a:	a80080e7          	jalr	-1408(ra) # 80200cd6 <printf>
        readline(input_buffer, sizeof(input_buffer));
    8020025e:	ed840793          	addi	a5,s0,-296
    80200262:	10000593          	li	a1,256
    80200266:	853e                	mv	a0,a5
    80200268:	00000097          	auipc	ra,0x0
    8020026c:	760080e7          	jalr	1888(ra) # 802009c8 <readline>
        if (input_buffer[0] == '\0') continue;
    80200270:	ed844783          	lbu	a5,-296(s0)
    80200274:	28078763          	beqz	a5,80200502 <console+0x2ca>
        if (input_buffer[0] == 'e' || input_buffer[0] == 'E') {
    80200278:	ed844783          	lbu	a5,-296(s0)
    8020027c:	873e                	mv	a4,a5
    8020027e:	06500793          	li	a5,101
    80200282:	00f70963          	beq	a4,a5,80200294 <console+0x5c>
    80200286:	ed844783          	lbu	a5,-296(s0)
    8020028a:	873e                	mv	a4,a5
    8020028c:	04500793          	li	a5,69
    80200290:	00f71663          	bne	a4,a5,8020029c <console+0x64>
            exit_requested = 1;
    80200294:	4785                	li	a5,1
    80200296:	fef42623          	sw	a5,-20(s0)
            continue;
    8020029a:	a4ad                	j	80200504 <console+0x2cc>
        if (input_buffer[0] == 'h' || input_buffer[0] == 'H') {
    8020029c:	ed844783          	lbu	a5,-296(s0)
    802002a0:	873e                	mv	a4,a5
    802002a2:	06800793          	li	a5,104
    802002a6:	00f70963          	beq	a4,a5,802002b8 <console+0x80>
    802002aa:	ed844783          	lbu	a5,-296(s0)
    802002ae:	873e                	mv	a4,a5
    802002b0:	04800793          	li	a5,72
    802002b4:	00f71763          	bne	a4,a5,802002c2 <console+0x8a>
            print_menu();
    802002b8:	00000097          	auipc	ra,0x0
    802002bc:	ec6080e7          	jalr	-314(ra) # 8020017e <print_menu>
            continue;
    802002c0:	a491                	j	80200504 <console+0x2cc>
        if (input_buffer[0] == 'p' || input_buffer[0] == 'P') {
    802002c2:	ed844783          	lbu	a5,-296(s0)
    802002c6:	873e                	mv	a4,a5
    802002c8:	07000793          	li	a5,112
    802002cc:	00f70963          	beq	a4,a5,802002de <console+0xa6>
    802002d0:	ed844783          	lbu	a5,-296(s0)
    802002d4:	873e                	mv	a4,a5
    802002d6:	05000793          	li	a5,80
    802002da:	00f71763          	bne	a4,a5,802002e8 <console+0xb0>
            print_proc_table();
    802002de:	00006097          	auipc	ra,0x6
    802002e2:	c42080e7          	jalr	-958(ra) # 80205f20 <print_proc_table>
            continue;
    802002e6:	ac39                	j	80200504 <console+0x2cc>
        int cmd_index = -1;
    802002e8:	57fd                	li	a5,-1
    802002ea:	fef42023          	sw	a5,-32(s0)
        if (input_buffer[0] >= '1' && input_buffer[0] <= '9') {
    802002ee:	ed844783          	lbu	a5,-296(s0)
    802002f2:	873e                	mv	a4,a5
    802002f4:	03000793          	li	a5,48
    802002f8:	16e7ff63          	bgeu	a5,a4,80200476 <console+0x23e>
    802002fc:	ed844783          	lbu	a5,-296(s0)
    80200300:	873e                	mv	a4,a5
    80200302:	03900793          	li	a5,57
    80200306:	16e7e863          	bltu	a5,a4,80200476 <console+0x23e>
            cmd_index = atoi(input_buffer) - 1;
    8020030a:	ed840793          	addi	a5,s0,-296
    8020030e:	853e                	mv	a0,a5
    80200310:	00006097          	auipc	ra,0x6
    80200314:	fae080e7          	jalr	-82(ra) # 802062be <atoi>
    80200318:	87aa                	mv	a5,a0
    8020031a:	37fd                	addiw	a5,a5,-1
    8020031c:	fef42023          	sw	a5,-32(s0)
            if (cmd_index >= 0 && cmd_index < COMMAND_COUNT) {
    80200320:	fe042783          	lw	a5,-32(s0)
    80200324:	2781                	sext.w	a5,a5
    80200326:	1407c863          	bltz	a5,80200476 <console+0x23e>
    8020032a:	fe042783          	lw	a5,-32(s0)
    8020032e:	873e                	mv	a4,a5
    80200330:	47ad                	li	a5,11
    80200332:	14e7e263          	bltu	a5,a4,80200476 <console+0x23e>
                printf("\n----- 执行命令: %s -----\n", command_table[cmd_index].name);
    80200336:	00026697          	auipc	a3,0x26
    8020033a:	cca68693          	addi	a3,a3,-822 # 80226000 <command_table>
    8020033e:	fe042703          	lw	a4,-32(s0)
    80200342:	87ba                	mv	a5,a4
    80200344:	0786                	slli	a5,a5,0x1
    80200346:	97ba                	add	a5,a5,a4
    80200348:	078e                	slli	a5,a5,0x3
    8020034a:	97b6                	add	a5,a5,a3
    8020034c:	639c                	ld	a5,0(a5)
    8020034e:	85be                	mv	a1,a5
    80200350:	0000a517          	auipc	a0,0xa
    80200354:	fc850513          	addi	a0,a0,-56 # 8020a318 <syscall_performance_bin+0xa20>
    80200358:	00001097          	auipc	ra,0x1
    8020035c:	97e080e7          	jalr	-1666(ra) # 80200cd6 <printf>
                int pid = create_kernel_proc(command_table[cmd_index].func);
    80200360:	00026697          	auipc	a3,0x26
    80200364:	ca068693          	addi	a3,a3,-864 # 80226000 <command_table>
    80200368:	fe042703          	lw	a4,-32(s0)
    8020036c:	87ba                	mv	a5,a4
    8020036e:	0786                	slli	a5,a5,0x1
    80200370:	97ba                	add	a5,a5,a4
    80200372:	078e                	slli	a5,a5,0x3
    80200374:	97b6                	add	a5,a5,a3
    80200376:	679c                	ld	a5,8(a5)
    80200378:	853e                	mv	a0,a5
    8020037a:	00005097          	auipc	ra,0x5
    8020037e:	1e6080e7          	jalr	486(ra) # 80205560 <create_kernel_proc>
    80200382:	87aa                	mv	a5,a0
    80200384:	fcf42e23          	sw	a5,-36(s0)
                if (pid < 0) {
    80200388:	fdc42783          	lw	a5,-36(s0)
    8020038c:	2781                	sext.w	a5,a5
    8020038e:	0207d863          	bgez	a5,802003be <console+0x186>
                    printf("创建%s进程失败\n", command_table[cmd_index].name);
    80200392:	00026697          	auipc	a3,0x26
    80200396:	c6e68693          	addi	a3,a3,-914 # 80226000 <command_table>
    8020039a:	fe042703          	lw	a4,-32(s0)
    8020039e:	87ba                	mv	a5,a4
    802003a0:	0786                	slli	a5,a5,0x1
    802003a2:	97ba                	add	a5,a5,a4
    802003a4:	078e                	slli	a5,a5,0x3
    802003a6:	97b6                	add	a5,a5,a3
    802003a8:	639c                	ld	a5,0(a5)
    802003aa:	85be                	mv	a1,a5
    802003ac:	0000a517          	auipc	a0,0xa
    802003b0:	f8c50513          	addi	a0,a0,-116 # 8020a338 <syscall_performance_bin+0xa40>
    802003b4:	00001097          	auipc	ra,0x1
    802003b8:	922080e7          	jalr	-1758(ra) # 80200cd6 <printf>
                continue;
    802003bc:	a2a1                	j	80200504 <console+0x2cc>
                    printf("创建%s进程成功，PID: %d\n", command_table[cmd_index].name, pid);
    802003be:	00026697          	auipc	a3,0x26
    802003c2:	c4268693          	addi	a3,a3,-958 # 80226000 <command_table>
    802003c6:	fe042703          	lw	a4,-32(s0)
    802003ca:	87ba                	mv	a5,a4
    802003cc:	0786                	slli	a5,a5,0x1
    802003ce:	97ba                	add	a5,a5,a4
    802003d0:	078e                	slli	a5,a5,0x3
    802003d2:	97b6                	add	a5,a5,a3
    802003d4:	639c                	ld	a5,0(a5)
    802003d6:	fdc42703          	lw	a4,-36(s0)
    802003da:	863a                	mv	a2,a4
    802003dc:	85be                	mv	a1,a5
    802003de:	0000a517          	auipc	a0,0xa
    802003e2:	f7250513          	addi	a0,a0,-142 # 8020a350 <syscall_performance_bin+0xa58>
    802003e6:	00001097          	auipc	ra,0x1
    802003ea:	8f0080e7          	jalr	-1808(ra) # 80200cd6 <printf>
                    int waited_pid = wait_proc(&status);
    802003ee:	ed440793          	addi	a5,s0,-300
    802003f2:	853e                	mv	a0,a5
    802003f4:	00006097          	auipc	ra,0x6
    802003f8:	99e080e7          	jalr	-1634(ra) # 80205d92 <wait_proc>
    802003fc:	87aa                	mv	a5,a0
    802003fe:	fcf42c23          	sw	a5,-40(s0)
                    if (waited_pid == pid) {
    80200402:	fd842783          	lw	a5,-40(s0)
    80200406:	873e                	mv	a4,a5
    80200408:	fdc42783          	lw	a5,-36(s0)
    8020040c:	2701                	sext.w	a4,a4
    8020040e:	2781                	sext.w	a5,a5
    80200410:	02f71d63          	bne	a4,a5,8020044a <console+0x212>
                        printf("%s进程(PID: %d)已退出，状态码: %d\n", 
    80200414:	00026697          	auipc	a3,0x26
    80200418:	bec68693          	addi	a3,a3,-1044 # 80226000 <command_table>
    8020041c:	fe042703          	lw	a4,-32(s0)
    80200420:	87ba                	mv	a5,a4
    80200422:	0786                	slli	a5,a5,0x1
    80200424:	97ba                	add	a5,a5,a4
    80200426:	078e                	slli	a5,a5,0x3
    80200428:	97b6                	add	a5,a5,a3
    8020042a:	639c                	ld	a5,0(a5)
    8020042c:	ed442683          	lw	a3,-300(s0)
    80200430:	fdc42703          	lw	a4,-36(s0)
    80200434:	863a                	mv	a2,a4
    80200436:	85be                	mv	a1,a5
    80200438:	0000a517          	auipc	a0,0xa
    8020043c:	f3850513          	addi	a0,a0,-200 # 8020a370 <syscall_performance_bin+0xa78>
    80200440:	00001097          	auipc	ra,0x1
    80200444:	896080e7          	jalr	-1898(ra) # 80200cd6 <printf>
                continue;
    80200448:	a875                	j	80200504 <console+0x2cc>
                        printf("等待%s进程时发生错误\n", command_table[cmd_index].name);
    8020044a:	00026697          	auipc	a3,0x26
    8020044e:	bb668693          	addi	a3,a3,-1098 # 80226000 <command_table>
    80200452:	fe042703          	lw	a4,-32(s0)
    80200456:	87ba                	mv	a5,a4
    80200458:	0786                	slli	a5,a5,0x1
    8020045a:	97ba                	add	a5,a5,a4
    8020045c:	078e                	slli	a5,a5,0x3
    8020045e:	97b6                	add	a5,a5,a3
    80200460:	639c                	ld	a5,0(a5)
    80200462:	85be                	mv	a1,a5
    80200464:	0000a517          	auipc	a0,0xa
    80200468:	f3c50513          	addi	a0,a0,-196 # 8020a3a0 <syscall_performance_bin+0xaa8>
    8020046c:	00001097          	auipc	ra,0x1
    80200470:	86a080e7          	jalr	-1942(ra) # 80200cd6 <printf>
                continue;
    80200474:	a841                	j	80200504 <console+0x2cc>
        int found = 0;
    80200476:	fe042423          	sw	zero,-24(s0)
        for (int i = 0; i < COMMAND_COUNT; i++) {
    8020047a:	fe042223          	sw	zero,-28(s0)
    8020047e:	a0a1                	j	802004c6 <console+0x28e>
            if (strcmp(input_buffer, command_table[i].name) == 0) {
    80200480:	00026697          	auipc	a3,0x26
    80200484:	b8068693          	addi	a3,a3,-1152 # 80226000 <command_table>
    80200488:	fe442703          	lw	a4,-28(s0)
    8020048c:	87ba                	mv	a5,a4
    8020048e:	0786                	slli	a5,a5,0x1
    80200490:	97ba                	add	a5,a5,a4
    80200492:	078e                	slli	a5,a5,0x3
    80200494:	97b6                	add	a5,a5,a3
    80200496:	6398                	ld	a4,0(a5)
    80200498:	ed840793          	addi	a5,s0,-296
    8020049c:	85ba                	mv	a1,a4
    8020049e:	853e                	mv	a0,a5
    802004a0:	00006097          	auipc	ra,0x6
    802004a4:	cf2080e7          	jalr	-782(ra) # 80206192 <strcmp>
    802004a8:	87aa                	mv	a5,a0
    802004aa:	eb89                	bnez	a5,802004bc <console+0x284>
                cmd_index = i;
    802004ac:	fe442783          	lw	a5,-28(s0)
    802004b0:	fef42023          	sw	a5,-32(s0)
                found = 1;
    802004b4:	4785                	li	a5,1
    802004b6:	fef42423          	sw	a5,-24(s0)
                break;
    802004ba:	a821                	j	802004d2 <console+0x29a>
        for (int i = 0; i < COMMAND_COUNT; i++) {
    802004bc:	fe442783          	lw	a5,-28(s0)
    802004c0:	2785                	addiw	a5,a5,1
    802004c2:	fef42223          	sw	a5,-28(s0)
    802004c6:	fe442783          	lw	a5,-28(s0)
    802004ca:	873e                	mv	a4,a5
    802004cc:	47ad                	li	a5,11
    802004ce:	fae7f9e3          	bgeu	a5,a4,80200480 <console+0x248>
        if (!found) {
    802004d2:	fe842783          	lw	a5,-24(s0)
    802004d6:	2781                	sext.w	a5,a5
    802004d8:	e795                	bnez	a5,80200504 <console+0x2cc>
            printf("无效命令或序号: %s\n", input_buffer);
    802004da:	ed840793          	addi	a5,s0,-296
    802004de:	85be                	mv	a1,a5
    802004e0:	0000a517          	auipc	a0,0xa
    802004e4:	ee050513          	addi	a0,a0,-288 # 8020a3c0 <syscall_performance_bin+0xac8>
    802004e8:	00000097          	auipc	ra,0x0
    802004ec:	7ee080e7          	jalr	2030(ra) # 80200cd6 <printf>
            printf("输入 'h' 查看帮助\n");
    802004f0:	0000a517          	auipc	a0,0xa
    802004f4:	ef050513          	addi	a0,a0,-272 # 8020a3e0 <syscall_performance_bin+0xae8>
    802004f8:	00000097          	auipc	ra,0x0
    802004fc:	7de080e7          	jalr	2014(ra) # 80200cd6 <printf>
    80200500:	a011                	j	80200504 <console+0x2cc>
        if (input_buffer[0] == '\0') continue;
    80200502:	0001                	nop
    while (!exit_requested) {
    80200504:	fec42783          	lw	a5,-20(s0)
    80200508:	2781                	sext.w	a5,a5
    8020050a:	d40782e3          	beqz	a5,8020024e <console+0x16>
    printf("控制台进程退出\n");
    8020050e:	0000a517          	auipc	a0,0xa
    80200512:	ef250513          	addi	a0,a0,-270 # 8020a400 <syscall_performance_bin+0xb08>
    80200516:	00000097          	auipc	ra,0x0
    8020051a:	7c0080e7          	jalr	1984(ra) # 80200cd6 <printf>
    return;
    8020051e:	0001                	nop
}
    80200520:	70b2                	ld	ra,296(sp)
    80200522:	7412                	ld	s0,288(sp)
    80200524:	6155                	addi	sp,sp,304
    80200526:	8082                	ret

0000000080200528 <kernel_main>:
void kernel_main(void){
    80200528:	1101                	addi	sp,sp,-32
    8020052a:	ec06                	sd	ra,24(sp)
    8020052c:	e822                	sd	s0,16(sp)
    8020052e:	1000                	addi	s0,sp,32
	clear_screen();
    80200530:	00001097          	auipc	ra,0x1
    80200534:	cbe080e7          	jalr	-834(ra) # 802011ee <clear_screen>
	int console_pid = create_kernel_proc(console);
    80200538:	00000517          	auipc	a0,0x0
    8020053c:	d0050513          	addi	a0,a0,-768 # 80200238 <console>
    80200540:	00005097          	auipc	ra,0x5
    80200544:	020080e7          	jalr	32(ra) # 80205560 <create_kernel_proc>
    80200548:	87aa                	mv	a5,a0
    8020054a:	fef42623          	sw	a5,-20(s0)
	if (console_pid < 0){
    8020054e:	fec42783          	lw	a5,-20(s0)
    80200552:	2781                	sext.w	a5,a5
    80200554:	0007db63          	bgez	a5,8020056a <kernel_main+0x42>
		panic("KERNEL_MAIN: create console process failed!\n");
    80200558:	0000a517          	auipc	a0,0xa
    8020055c:	ec050513          	addi	a0,a0,-320 # 8020a418 <syscall_performance_bin+0xb20>
    80200560:	00001097          	auipc	ra,0x1
    80200564:	1c2080e7          	jalr	450(ra) # 80201722 <panic>
    80200568:	a821                	j	80200580 <kernel_main+0x58>
		printf("KERNEL_MAIN: console process created with PID %d\n", console_pid);
    8020056a:	fec42783          	lw	a5,-20(s0)
    8020056e:	85be                	mv	a1,a5
    80200570:	0000a517          	auipc	a0,0xa
    80200574:	ed850513          	addi	a0,a0,-296 # 8020a448 <syscall_performance_bin+0xb50>
    80200578:	00000097          	auipc	ra,0x0
    8020057c:	75e080e7          	jalr	1886(ra) # 80200cd6 <printf>
	int pid = wait_proc(&status);
    80200580:	fe440793          	addi	a5,s0,-28
    80200584:	853e                	mv	a0,a5
    80200586:	00006097          	auipc	ra,0x6
    8020058a:	80c080e7          	jalr	-2036(ra) # 80205d92 <wait_proc>
    8020058e:	87aa                	mv	a5,a0
    80200590:	fef42423          	sw	a5,-24(s0)
	if(pid != console_pid){
    80200594:	fe842783          	lw	a5,-24(s0)
    80200598:	873e                	mv	a4,a5
    8020059a:	fec42783          	lw	a5,-20(s0)
    8020059e:	2701                	sext.w	a4,a4
    802005a0:	2781                	sext.w	a5,a5
    802005a2:	02f70163          	beq	a4,a5,802005c4 <kernel_main+0x9c>
		printf("KERNEL_MAIN: unexpected process %d exited with status %d\n", pid, status);
    802005a6:	fe442703          	lw	a4,-28(s0)
    802005aa:	fe842783          	lw	a5,-24(s0)
    802005ae:	863a                	mv	a2,a4
    802005b0:	85be                	mv	a1,a5
    802005b2:	0000a517          	auipc	a0,0xa
    802005b6:	ece50513          	addi	a0,a0,-306 # 8020a480 <syscall_performance_bin+0xb88>
    802005ba:	00000097          	auipc	ra,0x0
    802005be:	71c080e7          	jalr	1820(ra) # 80200cd6 <printf>
	return;
    802005c2:	0001                	nop
    802005c4:	0001                	nop
    802005c6:	60e2                	ld	ra,24(sp)
    802005c8:	6442                	ld	s0,16(sp)
    802005ca:	6105                	addi	sp,sp,32
    802005cc:	8082                	ret

00000000802005ce <uart_init>:
#include "defs.h"
#define LINE_BUF_SIZE 128
struct uart_input_buf_t uart_input_buf;
// UART初始化函数
void uart_init(void) {
    802005ce:	1141                	addi	sp,sp,-16
    802005d0:	e406                	sd	ra,8(sp)
    802005d2:	e022                	sd	s0,0(sp)
    802005d4:	0800                	addi	s0,sp,16

    WriteReg(IER, 0x00);
    802005d6:	100007b7          	lui	a5,0x10000
    802005da:	0785                	addi	a5,a5,1 # 10000001 <_entry-0x701fffff>
    802005dc:	00078023          	sb	zero,0(a5)
    WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    802005e0:	100007b7          	lui	a5,0x10000
    802005e4:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x701ffffe>
    802005e6:	471d                	li	a4,7
    802005e8:	00e78023          	sb	a4,0(a5)
    WriteReg(IER, IER_RX_ENABLE);
    802005ec:	100007b7          	lui	a5,0x10000
    802005f0:	0785                	addi	a5,a5,1 # 10000001 <_entry-0x701fffff>
    802005f2:	4705                	li	a4,1
    802005f4:	00e78023          	sb	a4,0(a5)
    register_interrupt(UART0_IRQ, uart_intr);//注册键盘输入的中断处理函数
    802005f8:	00000597          	auipc	a1,0x0
    802005fc:	12858593          	addi	a1,a1,296 # 80200720 <uart_intr>
    80200600:	4529                	li	a0,10
    80200602:	00003097          	auipc	ra,0x3
    80200606:	0de080e7          	jalr	222(ra) # 802036e0 <register_interrupt>
    enable_interrupts(UART0_IRQ);
    8020060a:	4529                	li	a0,10
    8020060c:	00003097          	auipc	ra,0x3
    80200610:	15e080e7          	jalr	350(ra) # 8020376a <enable_interrupts>
    printf("UART initialized with input support\n");
    80200614:	0000c517          	auipc	a0,0xc
    80200618:	ca450513          	addi	a0,a0,-860 # 8020c2b8 <syscall_performance_bin+0x670>
    8020061c:	00000097          	auipc	ra,0x0
    80200620:	6ba080e7          	jalr	1722(ra) # 80200cd6 <printf>
}
    80200624:	0001                	nop
    80200626:	60a2                	ld	ra,8(sp)
    80200628:	6402                	ld	s0,0(sp)
    8020062a:	0141                	addi	sp,sp,16
    8020062c:	8082                	ret

000000008020062e <uart_putc>:

// 发送单个字符
void uart_putc(char c) {
    8020062e:	1101                	addi	sp,sp,-32
    80200630:	ec22                	sd	s0,24(sp)
    80200632:	1000                	addi	s0,sp,32
    80200634:	87aa                	mv	a5,a0
    80200636:	fef407a3          	sb	a5,-17(s0)
    // 等待发送缓冲区空闲
    while((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    8020063a:	0001                	nop
    8020063c:	100007b7          	lui	a5,0x10000
    80200640:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    80200642:	0007c783          	lbu	a5,0(a5)
    80200646:	0ff7f793          	zext.b	a5,a5
    8020064a:	2781                	sext.w	a5,a5
    8020064c:	0207f793          	andi	a5,a5,32
    80200650:	2781                	sext.w	a5,a5
    80200652:	d7ed                	beqz	a5,8020063c <uart_putc+0xe>
    WriteReg(THR, c);
    80200654:	100007b7          	lui	a5,0x10000
    80200658:	fef44703          	lbu	a4,-17(s0)
    8020065c:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70200000>
}
    80200660:	0001                	nop
    80200662:	6462                	ld	s0,24(sp)
    80200664:	6105                	addi	sp,sp,32
    80200666:	8082                	ret

0000000080200668 <uart_puts>:

void uart_puts(char *s) {
    80200668:	7179                	addi	sp,sp,-48
    8020066a:	f422                	sd	s0,40(sp)
    8020066c:	1800                	addi	s0,sp,48
    8020066e:	fca43c23          	sd	a0,-40(s0)
    if (!s) return;
    80200672:	fd843783          	ld	a5,-40(s0)
    80200676:	c7b5                	beqz	a5,802006e2 <uart_puts+0x7a>
    
    while (*s) {
    80200678:	a8b9                	j	802006d6 <uart_puts+0x6e>
        while ((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    8020067a:	0001                	nop
    8020067c:	100007b7          	lui	a5,0x10000
    80200680:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    80200682:	0007c783          	lbu	a5,0(a5)
    80200686:	0ff7f793          	zext.b	a5,a5
    8020068a:	2781                	sext.w	a5,a5
    8020068c:	0207f793          	andi	a5,a5,32
    80200690:	2781                	sext.w	a5,a5
    80200692:	d7ed                	beqz	a5,8020067c <uart_puts+0x14>
        int sent_count = 0;
    80200694:	fe042623          	sw	zero,-20(s0)
        while (*s && sent_count < 4) { 
    80200698:	a01d                	j	802006be <uart_puts+0x56>
            WriteReg(THR, *s);
    8020069a:	100007b7          	lui	a5,0x10000
    8020069e:	fd843703          	ld	a4,-40(s0)
    802006a2:	00074703          	lbu	a4,0(a4)
    802006a6:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70200000>
            s++;
    802006aa:	fd843783          	ld	a5,-40(s0)
    802006ae:	0785                	addi	a5,a5,1
    802006b0:	fcf43c23          	sd	a5,-40(s0)
            sent_count++;
    802006b4:	fec42783          	lw	a5,-20(s0)
    802006b8:	2785                	addiw	a5,a5,1
    802006ba:	fef42623          	sw	a5,-20(s0)
        while (*s && sent_count < 4) { 
    802006be:	fd843783          	ld	a5,-40(s0)
    802006c2:	0007c783          	lbu	a5,0(a5)
    802006c6:	cb81                	beqz	a5,802006d6 <uart_puts+0x6e>
    802006c8:	fec42783          	lw	a5,-20(s0)
    802006cc:	0007871b          	sext.w	a4,a5
    802006d0:	478d                	li	a5,3
    802006d2:	fce7d4e3          	bge	a5,a4,8020069a <uart_puts+0x32>
    while (*s) {
    802006d6:	fd843783          	ld	a5,-40(s0)
    802006da:	0007c783          	lbu	a5,0(a5)
    802006de:	ffd1                	bnez	a5,8020067a <uart_puts+0x12>
    802006e0:	a011                	j	802006e4 <uart_puts+0x7c>
    if (!s) return;
    802006e2:	0001                	nop
        }
    }
}
    802006e4:	7422                	ld	s0,40(sp)
    802006e6:	6145                	addi	sp,sp,48
    802006e8:	8082                	ret

00000000802006ea <uart_getc>:

int uart_getc(void) {
    802006ea:	1141                	addi	sp,sp,-16
    802006ec:	e422                	sd	s0,8(sp)
    802006ee:	0800                	addi	s0,sp,16
    if ((ReadReg(LSR) & LSR_RX_READY) == 0)
    802006f0:	100007b7          	lui	a5,0x10000
    802006f4:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    802006f6:	0007c783          	lbu	a5,0(a5)
    802006fa:	0ff7f793          	zext.b	a5,a5
    802006fe:	2781                	sext.w	a5,a5
    80200700:	8b85                	andi	a5,a5,1
    80200702:	2781                	sext.w	a5,a5
    80200704:	e399                	bnez	a5,8020070a <uart_getc+0x20>
        return -1; 
    80200706:	57fd                	li	a5,-1
    80200708:	a801                	j	80200718 <uart_getc+0x2e>
    return ReadReg(RHR); 
    8020070a:	100007b7          	lui	a5,0x10000
    8020070e:	0007c783          	lbu	a5,0(a5) # 10000000 <_entry-0x70200000>
    80200712:	0ff7f793          	zext.b	a5,a5
    80200716:	2781                	sext.w	a5,a5
}
    80200718:	853e                	mv	a0,a5
    8020071a:	6422                	ld	s0,8(sp)
    8020071c:	0141                	addi	sp,sp,16
    8020071e:	8082                	ret

0000000080200720 <uart_intr>:

void uart_intr(void) {
    80200720:	1101                	addi	sp,sp,-32
    80200722:	ec06                	sd	ra,24(sp)
    80200724:	e822                	sd	s0,16(sp)
    80200726:	1000                	addi	s0,sp,32
    static char linebuf[LINE_BUF_SIZE];
    static int line_len = 0;

    while (ReadReg(LSR) & LSR_RX_READY) {
    80200728:	a411                	j	8020092c <uart_intr+0x20c>
        char c = ReadReg(RHR);
    8020072a:	100007b7          	lui	a5,0x10000
    8020072e:	0007c783          	lbu	a5,0(a5) # 10000000 <_entry-0x70200000>
    80200732:	fef405a3          	sb	a5,-21(s0)
		if (c == 0x0c) { // 是'L'与 0x1f按位与的结果
    80200736:	feb44783          	lbu	a5,-21(s0)
    8020073a:	0ff7f713          	zext.b	a4,a5
    8020073e:	47b1                	li	a5,12
    80200740:	00f71763          	bne	a4,a5,8020074e <uart_intr+0x2e>
            clear_screen();
    80200744:	00001097          	auipc	ra,0x1
    80200748:	aaa080e7          	jalr	-1366(ra) # 802011ee <clear_screen>
            continue;
    8020074c:	a2c5                	j	8020092c <uart_intr+0x20c>
        }
        if (c == '\r' || c == '\n') {
    8020074e:	feb44783          	lbu	a5,-21(s0)
    80200752:	0ff7f713          	zext.b	a4,a5
    80200756:	47b5                	li	a5,13
    80200758:	00f70963          	beq	a4,a5,8020076a <uart_intr+0x4a>
    8020075c:	feb44783          	lbu	a5,-21(s0)
    80200760:	0ff7f713          	zext.b	a4,a5
    80200764:	47a9                	li	a5,10
    80200766:	10f71763          	bne	a4,a5,80200874 <uart_intr+0x154>
            uart_putc('\n');
    8020076a:	4529                	li	a0,10
    8020076c:	00000097          	auipc	ra,0x0
    80200770:	ec2080e7          	jalr	-318(ra) # 8020062e <uart_putc>
            // 将编辑好的整行写入全局缓冲区
            for (int i = 0; i < line_len; i++) {
    80200774:	fe042623          	sw	zero,-20(s0)
    80200778:	a8b5                	j	802007f4 <uart_intr+0xd4>
                int next = (uart_input_buf.w + 1) % INPUT_BUF_SIZE;
    8020077a:	00026797          	auipc	a5,0x26
    8020077e:	9f678793          	addi	a5,a5,-1546 # 80226170 <uart_input_buf>
    80200782:	0847a783          	lw	a5,132(a5)
    80200786:	2785                	addiw	a5,a5,1
    80200788:	2781                	sext.w	a5,a5
    8020078a:	2781                	sext.w	a5,a5
    8020078c:	07f7f793          	andi	a5,a5,127
    80200790:	fef42023          	sw	a5,-32(s0)
                if (next != uart_input_buf.r) {
    80200794:	00026797          	auipc	a5,0x26
    80200798:	9dc78793          	addi	a5,a5,-1572 # 80226170 <uart_input_buf>
    8020079c:	0807a703          	lw	a4,128(a5)
    802007a0:	fe042783          	lw	a5,-32(s0)
    802007a4:	04f70363          	beq	a4,a5,802007ea <uart_intr+0xca>
                    uart_input_buf.buf[uart_input_buf.w] = linebuf[i];
    802007a8:	00026797          	auipc	a5,0x26
    802007ac:	9c878793          	addi	a5,a5,-1592 # 80226170 <uart_input_buf>
    802007b0:	0847a603          	lw	a2,132(a5)
    802007b4:	00026717          	auipc	a4,0x26
    802007b8:	a4c70713          	addi	a4,a4,-1460 # 80226200 <linebuf.1>
    802007bc:	fec42783          	lw	a5,-20(s0)
    802007c0:	97ba                	add	a5,a5,a4
    802007c2:	0007c703          	lbu	a4,0(a5)
    802007c6:	00026697          	auipc	a3,0x26
    802007ca:	9aa68693          	addi	a3,a3,-1622 # 80226170 <uart_input_buf>
    802007ce:	02061793          	slli	a5,a2,0x20
    802007d2:	9381                	srli	a5,a5,0x20
    802007d4:	97b6                	add	a5,a5,a3
    802007d6:	00e78023          	sb	a4,0(a5)
                    uart_input_buf.w = next;
    802007da:	fe042703          	lw	a4,-32(s0)
    802007de:	00026797          	auipc	a5,0x26
    802007e2:	99278793          	addi	a5,a5,-1646 # 80226170 <uart_input_buf>
    802007e6:	08e7a223          	sw	a4,132(a5)
            for (int i = 0; i < line_len; i++) {
    802007ea:	fec42783          	lw	a5,-20(s0)
    802007ee:	2785                	addiw	a5,a5,1
    802007f0:	fef42623          	sw	a5,-20(s0)
    802007f4:	00026797          	auipc	a5,0x26
    802007f8:	a8c78793          	addi	a5,a5,-1396 # 80226280 <line_len.0>
    802007fc:	4398                	lw	a4,0(a5)
    802007fe:	fec42783          	lw	a5,-20(s0)
    80200802:	2781                	sext.w	a5,a5
    80200804:	f6e7cbe3          	blt	a5,a4,8020077a <uart_intr+0x5a>
                }
            }
            // 写入换行符
            int next = (uart_input_buf.w + 1) % INPUT_BUF_SIZE;
    80200808:	00026797          	auipc	a5,0x26
    8020080c:	96878793          	addi	a5,a5,-1688 # 80226170 <uart_input_buf>
    80200810:	0847a783          	lw	a5,132(a5)
    80200814:	2785                	addiw	a5,a5,1
    80200816:	2781                	sext.w	a5,a5
    80200818:	2781                	sext.w	a5,a5
    8020081a:	07f7f793          	andi	a5,a5,127
    8020081e:	fef42223          	sw	a5,-28(s0)
            if (next != uart_input_buf.r) {
    80200822:	00026797          	auipc	a5,0x26
    80200826:	94e78793          	addi	a5,a5,-1714 # 80226170 <uart_input_buf>
    8020082a:	0807a703          	lw	a4,128(a5)
    8020082e:	fe442783          	lw	a5,-28(s0)
    80200832:	02f70a63          	beq	a4,a5,80200866 <uart_intr+0x146>
                uart_input_buf.buf[uart_input_buf.w] = '\n';
    80200836:	00026797          	auipc	a5,0x26
    8020083a:	93a78793          	addi	a5,a5,-1734 # 80226170 <uart_input_buf>
    8020083e:	0847a783          	lw	a5,132(a5)
    80200842:	00026717          	auipc	a4,0x26
    80200846:	92e70713          	addi	a4,a4,-1746 # 80226170 <uart_input_buf>
    8020084a:	1782                	slli	a5,a5,0x20
    8020084c:	9381                	srli	a5,a5,0x20
    8020084e:	97ba                	add	a5,a5,a4
    80200850:	4729                	li	a4,10
    80200852:	00e78023          	sb	a4,0(a5)
                uart_input_buf.w = next;
    80200856:	fe442703          	lw	a4,-28(s0)
    8020085a:	00026797          	auipc	a5,0x26
    8020085e:	91678793          	addi	a5,a5,-1770 # 80226170 <uart_input_buf>
    80200862:	08e7a223          	sw	a4,132(a5)
            }
            line_len = 0;
    80200866:	00026797          	auipc	a5,0x26
    8020086a:	a1a78793          	addi	a5,a5,-1510 # 80226280 <line_len.0>
    8020086e:	0007a023          	sw	zero,0(a5)
        if (c == '\r' || c == '\n') {
    80200872:	a86d                	j	8020092c <uart_intr+0x20c>
        } else if (c == 0x7f || c == 0x08) { // 退格
    80200874:	feb44783          	lbu	a5,-21(s0)
    80200878:	0ff7f713          	zext.b	a4,a5
    8020087c:	07f00793          	li	a5,127
    80200880:	00f70963          	beq	a4,a5,80200892 <uart_intr+0x172>
    80200884:	feb44783          	lbu	a5,-21(s0)
    80200888:	0ff7f713          	zext.b	a4,a5
    8020088c:	47a1                	li	a5,8
    8020088e:	04f71763          	bne	a4,a5,802008dc <uart_intr+0x1bc>
            if (line_len > 0) {
    80200892:	00026797          	auipc	a5,0x26
    80200896:	9ee78793          	addi	a5,a5,-1554 # 80226280 <line_len.0>
    8020089a:	439c                	lw	a5,0(a5)
    8020089c:	08f05863          	blez	a5,8020092c <uart_intr+0x20c>
                uart_putc('\b');
    802008a0:	4521                	li	a0,8
    802008a2:	00000097          	auipc	ra,0x0
    802008a6:	d8c080e7          	jalr	-628(ra) # 8020062e <uart_putc>
                uart_putc(' ');
    802008aa:	02000513          	li	a0,32
    802008ae:	00000097          	auipc	ra,0x0
    802008b2:	d80080e7          	jalr	-640(ra) # 8020062e <uart_putc>
                uart_putc('\b');
    802008b6:	4521                	li	a0,8
    802008b8:	00000097          	auipc	ra,0x0
    802008bc:	d76080e7          	jalr	-650(ra) # 8020062e <uart_putc>
                line_len--;
    802008c0:	00026797          	auipc	a5,0x26
    802008c4:	9c078793          	addi	a5,a5,-1600 # 80226280 <line_len.0>
    802008c8:	439c                	lw	a5,0(a5)
    802008ca:	37fd                	addiw	a5,a5,-1
    802008cc:	0007871b          	sext.w	a4,a5
    802008d0:	00026797          	auipc	a5,0x26
    802008d4:	9b078793          	addi	a5,a5,-1616 # 80226280 <line_len.0>
    802008d8:	c398                	sw	a4,0(a5)
            if (line_len > 0) {
    802008da:	a889                	j	8020092c <uart_intr+0x20c>
            }
        } else if (line_len < LINE_BUF_SIZE - 1) {
    802008dc:	00026797          	auipc	a5,0x26
    802008e0:	9a478793          	addi	a5,a5,-1628 # 80226280 <line_len.0>
    802008e4:	439c                	lw	a5,0(a5)
    802008e6:	873e                	mv	a4,a5
    802008e8:	07e00793          	li	a5,126
    802008ec:	04e7c063          	blt	a5,a4,8020092c <uart_intr+0x20c>
            uart_putc(c);
    802008f0:	feb44783          	lbu	a5,-21(s0)
    802008f4:	853e                	mv	a0,a5
    802008f6:	00000097          	auipc	ra,0x0
    802008fa:	d38080e7          	jalr	-712(ra) # 8020062e <uart_putc>
            linebuf[line_len++] = c;
    802008fe:	00026797          	auipc	a5,0x26
    80200902:	98278793          	addi	a5,a5,-1662 # 80226280 <line_len.0>
    80200906:	439c                	lw	a5,0(a5)
    80200908:	0017871b          	addiw	a4,a5,1
    8020090c:	0007069b          	sext.w	a3,a4
    80200910:	00026717          	auipc	a4,0x26
    80200914:	97070713          	addi	a4,a4,-1680 # 80226280 <line_len.0>
    80200918:	c314                	sw	a3,0(a4)
    8020091a:	00026717          	auipc	a4,0x26
    8020091e:	8e670713          	addi	a4,a4,-1818 # 80226200 <linebuf.1>
    80200922:	97ba                	add	a5,a5,a4
    80200924:	feb44703          	lbu	a4,-21(s0)
    80200928:	00e78023          	sb	a4,0(a5)
    while (ReadReg(LSR) & LSR_RX_READY) {
    8020092c:	100007b7          	lui	a5,0x10000
    80200930:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    80200932:	0007c783          	lbu	a5,0(a5)
    80200936:	0ff7f793          	zext.b	a5,a5
    8020093a:	2781                	sext.w	a5,a5
    8020093c:	8b85                	andi	a5,a5,1
    8020093e:	2781                	sext.w	a5,a5
    80200940:	de0795e3          	bnez	a5,8020072a <uart_intr+0xa>
        }
    }
}
    80200944:	0001                	nop
    80200946:	0001                	nop
    80200948:	60e2                	ld	ra,24(sp)
    8020094a:	6442                	ld	s0,16(sp)
    8020094c:	6105                	addi	sp,sp,32
    8020094e:	8082                	ret

0000000080200950 <uart_getc_blocking>:
// 阻塞式读取一个字符
char uart_getc_blocking(void) {
    80200950:	1101                	addi	sp,sp,-32
    80200952:	ec22                	sd	s0,24(sp)
    80200954:	1000                	addi	s0,sp,32
    // 等待直到有字符可读
    while (uart_input_buf.r == uart_input_buf.w) {
    80200956:	a011                	j	8020095a <uart_getc_blocking+0xa>
        // 在实际系统中，这里可能需要让进程睡眠
        // 但目前我们使用简单的轮询
        asm volatile("nop");
    80200958:	0001                	nop
    while (uart_input_buf.r == uart_input_buf.w) {
    8020095a:	00026797          	auipc	a5,0x26
    8020095e:	81678793          	addi	a5,a5,-2026 # 80226170 <uart_input_buf>
    80200962:	0807a703          	lw	a4,128(a5)
    80200966:	00026797          	auipc	a5,0x26
    8020096a:	80a78793          	addi	a5,a5,-2038 # 80226170 <uart_input_buf>
    8020096e:	0847a783          	lw	a5,132(a5)
    80200972:	fef703e3          	beq	a4,a5,80200958 <uart_getc_blocking+0x8>
    }
    
    // 读取字符
    char c = uart_input_buf.buf[uart_input_buf.r];
    80200976:	00025797          	auipc	a5,0x25
    8020097a:	7fa78793          	addi	a5,a5,2042 # 80226170 <uart_input_buf>
    8020097e:	0807a783          	lw	a5,128(a5)
    80200982:	00025717          	auipc	a4,0x25
    80200986:	7ee70713          	addi	a4,a4,2030 # 80226170 <uart_input_buf>
    8020098a:	1782                	slli	a5,a5,0x20
    8020098c:	9381                	srli	a5,a5,0x20
    8020098e:	97ba                	add	a5,a5,a4
    80200990:	0007c783          	lbu	a5,0(a5)
    80200994:	fef407a3          	sb	a5,-17(s0)
    uart_input_buf.r = (uart_input_buf.r + 1) % INPUT_BUF_SIZE;
    80200998:	00025797          	auipc	a5,0x25
    8020099c:	7d878793          	addi	a5,a5,2008 # 80226170 <uart_input_buf>
    802009a0:	0807a783          	lw	a5,128(a5)
    802009a4:	2785                	addiw	a5,a5,1
    802009a6:	2781                	sext.w	a5,a5
    802009a8:	07f7f793          	andi	a5,a5,127
    802009ac:	0007871b          	sext.w	a4,a5
    802009b0:	00025797          	auipc	a5,0x25
    802009b4:	7c078793          	addi	a5,a5,1984 # 80226170 <uart_input_buf>
    802009b8:	08e7a023          	sw	a4,128(a5)
    return c;
    802009bc:	fef44783          	lbu	a5,-17(s0)
}
    802009c0:	853e                	mv	a0,a5
    802009c2:	6462                	ld	s0,24(sp)
    802009c4:	6105                	addi	sp,sp,32
    802009c6:	8082                	ret

00000000802009c8 <readline>:
// 读取一行输入，最多读取max-1个字符，并在末尾添加\0
int readline(char *buf, int max) {
    802009c8:	7179                	addi	sp,sp,-48
    802009ca:	f406                	sd	ra,40(sp)
    802009cc:	f022                	sd	s0,32(sp)
    802009ce:	1800                	addi	s0,sp,48
    802009d0:	fca43c23          	sd	a0,-40(s0)
    802009d4:	87ae                	mv	a5,a1
    802009d6:	fcf42a23          	sw	a5,-44(s0)
    int i = 0;
    802009da:	fe042623          	sw	zero,-20(s0)
    char c;
    
    while (i < max - 1) {
    802009de:	a0b9                	j	80200a2c <readline+0x64>
        c = uart_getc_blocking();
    802009e0:	00000097          	auipc	ra,0x0
    802009e4:	f70080e7          	jalr	-144(ra) # 80200950 <uart_getc_blocking>
    802009e8:	87aa                	mv	a5,a0
    802009ea:	fef405a3          	sb	a5,-21(s0)
        
        if (c == '\n') {
    802009ee:	feb44783          	lbu	a5,-21(s0)
    802009f2:	0ff7f713          	zext.b	a4,a5
    802009f6:	47a9                	li	a5,10
    802009f8:	00f71c63          	bne	a4,a5,80200a10 <readline+0x48>
            buf[i] = '\0';
    802009fc:	fec42783          	lw	a5,-20(s0)
    80200a00:	fd843703          	ld	a4,-40(s0)
    80200a04:	97ba                	add	a5,a5,a4
    80200a06:	00078023          	sb	zero,0(a5)
            return i;
    80200a0a:	fec42783          	lw	a5,-20(s0)
    80200a0e:	a0a9                	j	80200a58 <readline+0x90>
        } else {
            buf[i++] = c;
    80200a10:	fec42783          	lw	a5,-20(s0)
    80200a14:	0017871b          	addiw	a4,a5,1
    80200a18:	fee42623          	sw	a4,-20(s0)
    80200a1c:	873e                	mv	a4,a5
    80200a1e:	fd843783          	ld	a5,-40(s0)
    80200a22:	97ba                	add	a5,a5,a4
    80200a24:	feb44703          	lbu	a4,-21(s0)
    80200a28:	00e78023          	sb	a4,0(a5)
    while (i < max - 1) {
    80200a2c:	fd442783          	lw	a5,-44(s0)
    80200a30:	37fd                	addiw	a5,a5,-1
    80200a32:	0007871b          	sext.w	a4,a5
    80200a36:	fec42783          	lw	a5,-20(s0)
    80200a3a:	2781                	sext.w	a5,a5
    80200a3c:	fae7c2e3          	blt	a5,a4,802009e0 <readline+0x18>
        }
    }
    
    // 缓冲区满，添加\0并返回
    buf[max-1] = '\0';
    80200a40:	fd442783          	lw	a5,-44(s0)
    80200a44:	17fd                	addi	a5,a5,-1
    80200a46:	fd843703          	ld	a4,-40(s0)
    80200a4a:	97ba                	add	a5,a5,a4
    80200a4c:	00078023          	sb	zero,0(a5)
    return max-1;
    80200a50:	fd442783          	lw	a5,-44(s0)
    80200a54:	37fd                	addiw	a5,a5,-1
    80200a56:	2781                	sext.w	a5,a5
    80200a58:	853e                	mv	a0,a5
    80200a5a:	70a2                	ld	ra,40(sp)
    80200a5c:	7402                	ld	s0,32(sp)
    80200a5e:	6145                	addi	sp,sp,48
    80200a60:	8082                	ret

0000000080200a62 <flush_printf_buffer>:

extern void uart_putc(char c);

static char printf_buffer[PRINTF_BUFFER_SIZE];
static int printf_buf_pos = 0;
static void flush_printf_buffer(void) {
    80200a62:	1141                	addi	sp,sp,-16
    80200a64:	e406                	sd	ra,8(sp)
    80200a66:	e022                	sd	s0,0(sp)
    80200a68:	0800                	addi	s0,sp,16
	if (printf_buf_pos > 0) {
    80200a6a:	00026797          	auipc	a5,0x26
    80200a6e:	89e78793          	addi	a5,a5,-1890 # 80226308 <printf_buf_pos>
    80200a72:	439c                	lw	a5,0(a5)
    80200a74:	02f05c63          	blez	a5,80200aac <flush_printf_buffer+0x4a>
		printf_buffer[printf_buf_pos] = '\0'; // Null-terminate the string
    80200a78:	00026797          	auipc	a5,0x26
    80200a7c:	89078793          	addi	a5,a5,-1904 # 80226308 <printf_buf_pos>
    80200a80:	439c                	lw	a5,0(a5)
    80200a82:	00026717          	auipc	a4,0x26
    80200a86:	80670713          	addi	a4,a4,-2042 # 80226288 <printf_buffer>
    80200a8a:	97ba                	add	a5,a5,a4
    80200a8c:	00078023          	sb	zero,0(a5)
		uart_puts(printf_buffer); // Send the buffer to UART
    80200a90:	00025517          	auipc	a0,0x25
    80200a94:	7f850513          	addi	a0,a0,2040 # 80226288 <printf_buffer>
    80200a98:	00000097          	auipc	ra,0x0
    80200a9c:	bd0080e7          	jalr	-1072(ra) # 80200668 <uart_puts>
		printf_buf_pos = 0; // Reset buffer position
    80200aa0:	00026797          	auipc	a5,0x26
    80200aa4:	86878793          	addi	a5,a5,-1944 # 80226308 <printf_buf_pos>
    80200aa8:	0007a023          	sw	zero,0(a5)
	}
}
    80200aac:	0001                	nop
    80200aae:	60a2                	ld	ra,8(sp)
    80200ab0:	6402                	ld	s0,0(sp)
    80200ab2:	0141                	addi	sp,sp,16
    80200ab4:	8082                	ret

0000000080200ab6 <buffer_char>:
static void buffer_char(char c) {
    80200ab6:	1101                	addi	sp,sp,-32
    80200ab8:	ec06                	sd	ra,24(sp)
    80200aba:	e822                	sd	s0,16(sp)
    80200abc:	1000                	addi	s0,sp,32
    80200abe:	87aa                	mv	a5,a0
    80200ac0:	fef407a3          	sb	a5,-17(s0)
	if (printf_buf_pos < PRINTF_BUFFER_SIZE - 1) { // Leave space for null terminator
    80200ac4:	00026797          	auipc	a5,0x26
    80200ac8:	84478793          	addi	a5,a5,-1980 # 80226308 <printf_buf_pos>
    80200acc:	439c                	lw	a5,0(a5)
    80200ace:	873e                	mv	a4,a5
    80200ad0:	07e00793          	li	a5,126
    80200ad4:	02e7ca63          	blt	a5,a4,80200b08 <buffer_char+0x52>
		printf_buffer[printf_buf_pos++] = c;
    80200ad8:	00026797          	auipc	a5,0x26
    80200adc:	83078793          	addi	a5,a5,-2000 # 80226308 <printf_buf_pos>
    80200ae0:	439c                	lw	a5,0(a5)
    80200ae2:	0017871b          	addiw	a4,a5,1
    80200ae6:	0007069b          	sext.w	a3,a4
    80200aea:	00026717          	auipc	a4,0x26
    80200aee:	81e70713          	addi	a4,a4,-2018 # 80226308 <printf_buf_pos>
    80200af2:	c314                	sw	a3,0(a4)
    80200af4:	00025717          	auipc	a4,0x25
    80200af8:	79470713          	addi	a4,a4,1940 # 80226288 <printf_buffer>
    80200afc:	97ba                	add	a5,a5,a4
    80200afe:	fef44703          	lbu	a4,-17(s0)
    80200b02:	00e78023          	sb	a4,0(a5)
	} else {
		flush_printf_buffer(); // Buffer full, flush it
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
	}
}
    80200b06:	a825                	j	80200b3e <buffer_char+0x88>
		flush_printf_buffer(); // Buffer full, flush it
    80200b08:	00000097          	auipc	ra,0x0
    80200b0c:	f5a080e7          	jalr	-166(ra) # 80200a62 <flush_printf_buffer>
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
    80200b10:	00025797          	auipc	a5,0x25
    80200b14:	7f878793          	addi	a5,a5,2040 # 80226308 <printf_buf_pos>
    80200b18:	439c                	lw	a5,0(a5)
    80200b1a:	0017871b          	addiw	a4,a5,1
    80200b1e:	0007069b          	sext.w	a3,a4
    80200b22:	00025717          	auipc	a4,0x25
    80200b26:	7e670713          	addi	a4,a4,2022 # 80226308 <printf_buf_pos>
    80200b2a:	c314                	sw	a3,0(a4)
    80200b2c:	00025717          	auipc	a4,0x25
    80200b30:	75c70713          	addi	a4,a4,1884 # 80226288 <printf_buffer>
    80200b34:	97ba                	add	a5,a5,a4
    80200b36:	fef44703          	lbu	a4,-17(s0)
    80200b3a:	00e78023          	sb	a4,0(a5)
}
    80200b3e:	0001                	nop
    80200b40:	60e2                	ld	ra,24(sp)
    80200b42:	6442                	ld	s0,16(sp)
    80200b44:	6105                	addi	sp,sp,32
    80200b46:	8082                	ret

0000000080200b48 <consputc>:

static void consputc(int c){
    80200b48:	1101                	addi	sp,sp,-32
    80200b4a:	ec06                	sd	ra,24(sp)
    80200b4c:	e822                	sd	s0,16(sp)
    80200b4e:	1000                	addi	s0,sp,32
    80200b50:	87aa                	mv	a5,a0
    80200b52:	fef42623          	sw	a5,-20(s0)
	// 实现到多个输出的处理，目前只有串口输出
	uart_putc(c);
    80200b56:	fec42783          	lw	a5,-20(s0)
    80200b5a:	0ff7f793          	zext.b	a5,a5
    80200b5e:	853e                	mv	a0,a5
    80200b60:	00000097          	auipc	ra,0x0
    80200b64:	ace080e7          	jalr	-1330(ra) # 8020062e <uart_putc>
}
    80200b68:	0001                	nop
    80200b6a:	60e2                	ld	ra,24(sp)
    80200b6c:	6442                	ld	s0,16(sp)
    80200b6e:	6105                	addi	sp,sp,32
    80200b70:	8082                	ret

0000000080200b72 <consputs>:
static void consputs(const char *s){
    80200b72:	7179                	addi	sp,sp,-48
    80200b74:	f406                	sd	ra,40(sp)
    80200b76:	f022                	sd	s0,32(sp)
    80200b78:	1800                	addi	s0,sp,48
    80200b7a:	fca43c23          	sd	a0,-40(s0)
	char *str = (char *)s;
    80200b7e:	fd843783          	ld	a5,-40(s0)
    80200b82:	fef43423          	sd	a5,-24(s0)
	// 直接调用uart_puts输出字符串
	uart_puts(str);
    80200b86:	fe843503          	ld	a0,-24(s0)
    80200b8a:	00000097          	auipc	ra,0x0
    80200b8e:	ade080e7          	jalr	-1314(ra) # 80200668 <uart_puts>
}
    80200b92:	0001                	nop
    80200b94:	70a2                	ld	ra,40(sp)
    80200b96:	7402                	ld	s0,32(sp)
    80200b98:	6145                	addi	sp,sp,48
    80200b9a:	8082                	ret

0000000080200b9c <printint>:
static void printint(long long xx, int base, int sign, int width, int padzero){
    80200b9c:	7159                	addi	sp,sp,-112
    80200b9e:	f486                	sd	ra,104(sp)
    80200ba0:	f0a2                	sd	s0,96(sp)
    80200ba2:	1880                	addi	s0,sp,112
    80200ba4:	faa43423          	sd	a0,-88(s0)
    80200ba8:	87ae                	mv	a5,a1
    80200baa:	faf42223          	sw	a5,-92(s0)
    80200bae:	87b2                	mv	a5,a2
    80200bb0:	faf42023          	sw	a5,-96(s0)
    80200bb4:	87b6                	mv	a5,a3
    80200bb6:	f8f42e23          	sw	a5,-100(s0)
    80200bba:	87ba                	mv	a5,a4
    80200bbc:	f8f42c23          	sw	a5,-104(s0)
    static char digits[] = "0123456789abcdef";
    char buf[32];
    int i = 0;
    80200bc0:	fe042623          	sw	zero,-20(s0)
    unsigned long long x;

    if (sign && (sign = xx < 0))
    80200bc4:	fa042783          	lw	a5,-96(s0)
    80200bc8:	2781                	sext.w	a5,a5
    80200bca:	c39d                	beqz	a5,80200bf0 <printint+0x54>
    80200bcc:	fa843783          	ld	a5,-88(s0)
    80200bd0:	93fd                	srli	a5,a5,0x3f
    80200bd2:	0ff7f793          	zext.b	a5,a5
    80200bd6:	faf42023          	sw	a5,-96(s0)
    80200bda:	fa042783          	lw	a5,-96(s0)
    80200bde:	2781                	sext.w	a5,a5
    80200be0:	cb81                	beqz	a5,80200bf0 <printint+0x54>
        x = -(unsigned long long)xx;
    80200be2:	fa843783          	ld	a5,-88(s0)
    80200be6:	40f007b3          	neg	a5,a5
    80200bea:	fef43023          	sd	a5,-32(s0)
    80200bee:	a029                	j	80200bf8 <printint+0x5c>
    else
        x = xx;
    80200bf0:	fa843783          	ld	a5,-88(s0)
    80200bf4:	fef43023          	sd	a5,-32(s0)

    do {
        buf[i++] = digits[x % base];
    80200bf8:	fa442783          	lw	a5,-92(s0)
    80200bfc:	fe043703          	ld	a4,-32(s0)
    80200c00:	02f77733          	remu	a4,a4,a5
    80200c04:	fec42783          	lw	a5,-20(s0)
    80200c08:	0017869b          	addiw	a3,a5,1
    80200c0c:	fed42623          	sw	a3,-20(s0)
    80200c10:	00025697          	auipc	a3,0x25
    80200c14:	51068693          	addi	a3,a3,1296 # 80226120 <digits.0>
    80200c18:	9736                	add	a4,a4,a3
    80200c1a:	00074703          	lbu	a4,0(a4)
    80200c1e:	17c1                	addi	a5,a5,-16
    80200c20:	97a2                	add	a5,a5,s0
    80200c22:	fce78423          	sb	a4,-56(a5)
    } while ((x /= base) != 0);
    80200c26:	fa442783          	lw	a5,-92(s0)
    80200c2a:	fe043703          	ld	a4,-32(s0)
    80200c2e:	02f757b3          	divu	a5,a4,a5
    80200c32:	fef43023          	sd	a5,-32(s0)
    80200c36:	fe043783          	ld	a5,-32(s0)
    80200c3a:	ffdd                	bnez	a5,80200bf8 <printint+0x5c>

    if (sign)
    80200c3c:	fa042783          	lw	a5,-96(s0)
    80200c40:	2781                	sext.w	a5,a5
    80200c42:	cf89                	beqz	a5,80200c5c <printint+0xc0>
        buf[i++] = '-';
    80200c44:	fec42783          	lw	a5,-20(s0)
    80200c48:	0017871b          	addiw	a4,a5,1
    80200c4c:	fee42623          	sw	a4,-20(s0)
    80200c50:	17c1                	addi	a5,a5,-16
    80200c52:	97a2                	add	a5,a5,s0
    80200c54:	02d00713          	li	a4,45
    80200c58:	fce78423          	sb	a4,-56(a5)

    // 计算需要补的填充字符数
    int pad = width - i;
    80200c5c:	f9c42783          	lw	a5,-100(s0)
    80200c60:	873e                	mv	a4,a5
    80200c62:	fec42783          	lw	a5,-20(s0)
    80200c66:	40f707bb          	subw	a5,a4,a5
    80200c6a:	fcf42e23          	sw	a5,-36(s0)
    while (pad-- > 0) {
    80200c6e:	a839                	j	80200c8c <printint+0xf0>
        consputc(padzero ? '0' : ' ');
    80200c70:	f9842783          	lw	a5,-104(s0)
    80200c74:	2781                	sext.w	a5,a5
    80200c76:	c781                	beqz	a5,80200c7e <printint+0xe2>
    80200c78:	03000793          	li	a5,48
    80200c7c:	a019                	j	80200c82 <printint+0xe6>
    80200c7e:	02000793          	li	a5,32
    80200c82:	853e                	mv	a0,a5
    80200c84:	00000097          	auipc	ra,0x0
    80200c88:	ec4080e7          	jalr	-316(ra) # 80200b48 <consputc>
    while (pad-- > 0) {
    80200c8c:	fdc42783          	lw	a5,-36(s0)
    80200c90:	fff7871b          	addiw	a4,a5,-1
    80200c94:	fce42e23          	sw	a4,-36(s0)
    80200c98:	fcf04ce3          	bgtz	a5,80200c70 <printint+0xd4>
    }

    while (--i >= 0)
    80200c9c:	a829                	j	80200cb6 <printint+0x11a>
        consputc(buf[i]);
    80200c9e:	fec42783          	lw	a5,-20(s0)
    80200ca2:	17c1                	addi	a5,a5,-16
    80200ca4:	97a2                	add	a5,a5,s0
    80200ca6:	fc87c783          	lbu	a5,-56(a5)
    80200caa:	2781                	sext.w	a5,a5
    80200cac:	853e                	mv	a0,a5
    80200cae:	00000097          	auipc	ra,0x0
    80200cb2:	e9a080e7          	jalr	-358(ra) # 80200b48 <consputc>
    while (--i >= 0)
    80200cb6:	fec42783          	lw	a5,-20(s0)
    80200cba:	37fd                	addiw	a5,a5,-1
    80200cbc:	fef42623          	sw	a5,-20(s0)
    80200cc0:	fec42783          	lw	a5,-20(s0)
    80200cc4:	2781                	sext.w	a5,a5
    80200cc6:	fc07dce3          	bgez	a5,80200c9e <printint+0x102>
}
    80200cca:	0001                	nop
    80200ccc:	0001                	nop
    80200cce:	70a6                	ld	ra,104(sp)
    80200cd0:	7406                	ld	s0,96(sp)
    80200cd2:	6165                	addi	sp,sp,112
    80200cd4:	8082                	ret

0000000080200cd6 <printf>:
void printf(const char *fmt, ...) {
    80200cd6:	7171                	addi	sp,sp,-176
    80200cd8:	f486                	sd	ra,104(sp)
    80200cda:	f0a2                	sd	s0,96(sp)
    80200cdc:	1880                	addi	s0,sp,112
    80200cde:	f8a43c23          	sd	a0,-104(s0)
    80200ce2:	e40c                	sd	a1,8(s0)
    80200ce4:	e810                	sd	a2,16(s0)
    80200ce6:	ec14                	sd	a3,24(s0)
    80200ce8:	f018                	sd	a4,32(s0)
    80200cea:	f41c                	sd	a5,40(s0)
    80200cec:	03043823          	sd	a6,48(s0)
    80200cf0:	03143c23          	sd	a7,56(s0)
    va_list ap;
    int i, c;
    char *s;

    va_start(ap, fmt);
    80200cf4:	04040793          	addi	a5,s0,64
    80200cf8:	f8f43823          	sd	a5,-112(s0)
    80200cfc:	f9043783          	ld	a5,-112(s0)
    80200d00:	fc878793          	addi	a5,a5,-56
    80200d04:	faf43c23          	sd	a5,-72(s0)
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80200d08:	fe042623          	sw	zero,-20(s0)
    80200d0c:	a945                	j	802011bc <printf+0x4e6>
        if(c != '%'){
    80200d0e:	fe842783          	lw	a5,-24(s0)
    80200d12:	0007871b          	sext.w	a4,a5
    80200d16:	02500793          	li	a5,37
    80200d1a:	00f70c63          	beq	a4,a5,80200d32 <printf+0x5c>
            buffer_char(c);
    80200d1e:	fe842783          	lw	a5,-24(s0)
    80200d22:	0ff7f793          	zext.b	a5,a5
    80200d26:	853e                	mv	a0,a5
    80200d28:	00000097          	auipc	ra,0x0
    80200d2c:	d8e080e7          	jalr	-626(ra) # 80200ab6 <buffer_char>
            continue;
    80200d30:	a149                	j	802011b2 <printf+0x4dc>
        }
        flush_printf_buffer(); // 遇到格式化标志时，先刷新缓冲区
    80200d32:	00000097          	auipc	ra,0x0
    80200d36:	d30080e7          	jalr	-720(ra) # 80200a62 <flush_printf_buffer>
		// 解析填充标志和宽度
        int padzero = 0, width = 0;
    80200d3a:	fc042e23          	sw	zero,-36(s0)
    80200d3e:	fc042c23          	sw	zero,-40(s0)
        c = fmt[++i] & 0xff;
    80200d42:	fec42783          	lw	a5,-20(s0)
    80200d46:	2785                	addiw	a5,a5,1
    80200d48:	fef42623          	sw	a5,-20(s0)
    80200d4c:	fec42783          	lw	a5,-20(s0)
    80200d50:	f9843703          	ld	a4,-104(s0)
    80200d54:	97ba                	add	a5,a5,a4
    80200d56:	0007c783          	lbu	a5,0(a5)
    80200d5a:	fef42423          	sw	a5,-24(s0)
        if (c == '0') {
    80200d5e:	fe842783          	lw	a5,-24(s0)
    80200d62:	0007871b          	sext.w	a4,a5
    80200d66:	03000793          	li	a5,48
    80200d6a:	06f71563          	bne	a4,a5,80200dd4 <printf+0xfe>
            padzero = 1;
    80200d6e:	4785                	li	a5,1
    80200d70:	fcf42e23          	sw	a5,-36(s0)
            c = fmt[++i] & 0xff;
    80200d74:	fec42783          	lw	a5,-20(s0)
    80200d78:	2785                	addiw	a5,a5,1
    80200d7a:	fef42623          	sw	a5,-20(s0)
    80200d7e:	fec42783          	lw	a5,-20(s0)
    80200d82:	f9843703          	ld	a4,-104(s0)
    80200d86:	97ba                	add	a5,a5,a4
    80200d88:	0007c783          	lbu	a5,0(a5)
    80200d8c:	fef42423          	sw	a5,-24(s0)
        }
        while (c >= '0' && c <= '9') {
    80200d90:	a091                	j	80200dd4 <printf+0xfe>
            width = width * 10 + (c - '0');
    80200d92:	fd842783          	lw	a5,-40(s0)
    80200d96:	873e                	mv	a4,a5
    80200d98:	87ba                	mv	a5,a4
    80200d9a:	0027979b          	slliw	a5,a5,0x2
    80200d9e:	9fb9                	addw	a5,a5,a4
    80200da0:	0017979b          	slliw	a5,a5,0x1
    80200da4:	0007871b          	sext.w	a4,a5
    80200da8:	fe842783          	lw	a5,-24(s0)
    80200dac:	fd07879b          	addiw	a5,a5,-48
    80200db0:	2781                	sext.w	a5,a5
    80200db2:	9fb9                	addw	a5,a5,a4
    80200db4:	fcf42c23          	sw	a5,-40(s0)
            c = fmt[++i] & 0xff;
    80200db8:	fec42783          	lw	a5,-20(s0)
    80200dbc:	2785                	addiw	a5,a5,1
    80200dbe:	fef42623          	sw	a5,-20(s0)
    80200dc2:	fec42783          	lw	a5,-20(s0)
    80200dc6:	f9843703          	ld	a4,-104(s0)
    80200dca:	97ba                	add	a5,a5,a4
    80200dcc:	0007c783          	lbu	a5,0(a5)
    80200dd0:	fef42423          	sw	a5,-24(s0)
        while (c >= '0' && c <= '9') {
    80200dd4:	fe842783          	lw	a5,-24(s0)
    80200dd8:	0007871b          	sext.w	a4,a5
    80200ddc:	02f00793          	li	a5,47
    80200de0:	00e7da63          	bge	a5,a4,80200df4 <printf+0x11e>
    80200de4:	fe842783          	lw	a5,-24(s0)
    80200de8:	0007871b          	sext.w	a4,a5
    80200dec:	03900793          	li	a5,57
    80200df0:	fae7d1e3          	bge	a5,a4,80200d92 <printf+0xbc>
        }
        // 检查是否有长整型标记'l'
        int is_long = 0;
    80200df4:	fc042a23          	sw	zero,-44(s0)
        if(c == 'l') {
    80200df8:	fe842783          	lw	a5,-24(s0)
    80200dfc:	0007871b          	sext.w	a4,a5
    80200e00:	06c00793          	li	a5,108
    80200e04:	02f71863          	bne	a4,a5,80200e34 <printf+0x15e>
            is_long = 1;
    80200e08:	4785                	li	a5,1
    80200e0a:	fcf42a23          	sw	a5,-44(s0)
            c = fmt[++i] & 0xff;
    80200e0e:	fec42783          	lw	a5,-20(s0)
    80200e12:	2785                	addiw	a5,a5,1
    80200e14:	fef42623          	sw	a5,-20(s0)
    80200e18:	fec42783          	lw	a5,-20(s0)
    80200e1c:	f9843703          	ld	a4,-104(s0)
    80200e20:	97ba                	add	a5,a5,a4
    80200e22:	0007c783          	lbu	a5,0(a5)
    80200e26:	fef42423          	sw	a5,-24(s0)
            if(c == 0)
    80200e2a:	fe842783          	lw	a5,-24(s0)
    80200e2e:	2781                	sext.w	a5,a5
    80200e30:	3a078563          	beqz	a5,802011da <printf+0x504>
                break;
        }
        
        switch(c){
    80200e34:	fe842783          	lw	a5,-24(s0)
    80200e38:	0007871b          	sext.w	a4,a5
    80200e3c:	02500793          	li	a5,37
    80200e40:	2ef70d63          	beq	a4,a5,8020113a <printf+0x464>
    80200e44:	fe842783          	lw	a5,-24(s0)
    80200e48:	0007871b          	sext.w	a4,a5
    80200e4c:	02500793          	li	a5,37
    80200e50:	2ef74c63          	blt	a4,a5,80201148 <printf+0x472>
    80200e54:	fe842783          	lw	a5,-24(s0)
    80200e58:	0007871b          	sext.w	a4,a5
    80200e5c:	07800793          	li	a5,120
    80200e60:	2ee7c463          	blt	a5,a4,80201148 <printf+0x472>
    80200e64:	fe842783          	lw	a5,-24(s0)
    80200e68:	0007871b          	sext.w	a4,a5
    80200e6c:	06200793          	li	a5,98
    80200e70:	2cf74c63          	blt	a4,a5,80201148 <printf+0x472>
    80200e74:	fe842783          	lw	a5,-24(s0)
    80200e78:	f9e7869b          	addiw	a3,a5,-98
    80200e7c:	0006871b          	sext.w	a4,a3
    80200e80:	47d9                	li	a5,22
    80200e82:	2ce7e363          	bltu	a5,a4,80201148 <printf+0x472>
    80200e86:	02069793          	slli	a5,a3,0x20
    80200e8a:	9381                	srli	a5,a5,0x20
    80200e8c:	00279713          	slli	a4,a5,0x2
    80200e90:	0000d797          	auipc	a5,0xd
    80200e94:	26c78793          	addi	a5,a5,620 # 8020e0fc <syscall_performance_bin+0x694>
    80200e98:	97ba                	add	a5,a5,a4
    80200e9a:	439c                	lw	a5,0(a5)
    80200e9c:	0007871b          	sext.w	a4,a5
    80200ea0:	0000d797          	auipc	a5,0xd
    80200ea4:	25c78793          	addi	a5,a5,604 # 8020e0fc <syscall_performance_bin+0x694>
    80200ea8:	97ba                	add	a5,a5,a4
    80200eaa:	8782                	jr	a5
        case 'd':
            if(is_long)
    80200eac:	fd442783          	lw	a5,-44(s0)
    80200eb0:	2781                	sext.w	a5,a5
    80200eb2:	c785                	beqz	a5,80200eda <printf+0x204>
                printint(va_arg(ap, long long), 10, 1, width, padzero);
    80200eb4:	fb843783          	ld	a5,-72(s0)
    80200eb8:	00878713          	addi	a4,a5,8
    80200ebc:	fae43c23          	sd	a4,-72(s0)
    80200ec0:	639c                	ld	a5,0(a5)
    80200ec2:	fdc42703          	lw	a4,-36(s0)
    80200ec6:	fd842683          	lw	a3,-40(s0)
    80200eca:	4605                	li	a2,1
    80200ecc:	45a9                	li	a1,10
    80200ece:	853e                	mv	a0,a5
    80200ed0:	00000097          	auipc	ra,0x0
    80200ed4:	ccc080e7          	jalr	-820(ra) # 80200b9c <printint>
            else
                printint(va_arg(ap, int), 10, 1, width, padzero);
            break;
    80200ed8:	ace9                	j	802011b2 <printf+0x4dc>
                printint(va_arg(ap, int), 10, 1, width, padzero);
    80200eda:	fb843783          	ld	a5,-72(s0)
    80200ede:	00878713          	addi	a4,a5,8
    80200ee2:	fae43c23          	sd	a4,-72(s0)
    80200ee6:	439c                	lw	a5,0(a5)
    80200ee8:	853e                	mv	a0,a5
    80200eea:	fdc42703          	lw	a4,-36(s0)
    80200eee:	fd842783          	lw	a5,-40(s0)
    80200ef2:	86be                	mv	a3,a5
    80200ef4:	4605                	li	a2,1
    80200ef6:	45a9                	li	a1,10
    80200ef8:	00000097          	auipc	ra,0x0
    80200efc:	ca4080e7          	jalr	-860(ra) # 80200b9c <printint>
            break;
    80200f00:	ac4d                	j	802011b2 <printf+0x4dc>
        case 'x':
            if(is_long)
    80200f02:	fd442783          	lw	a5,-44(s0)
    80200f06:	2781                	sext.w	a5,a5
    80200f08:	c785                	beqz	a5,80200f30 <printf+0x25a>
                printint(va_arg(ap, long long), 16, 0, width, padzero);
    80200f0a:	fb843783          	ld	a5,-72(s0)
    80200f0e:	00878713          	addi	a4,a5,8
    80200f12:	fae43c23          	sd	a4,-72(s0)
    80200f16:	639c                	ld	a5,0(a5)
    80200f18:	fdc42703          	lw	a4,-36(s0)
    80200f1c:	fd842683          	lw	a3,-40(s0)
    80200f20:	4601                	li	a2,0
    80200f22:	45c1                	li	a1,16
    80200f24:	853e                	mv	a0,a5
    80200f26:	00000097          	auipc	ra,0x0
    80200f2a:	c76080e7          	jalr	-906(ra) # 80200b9c <printint>
            else
                printint(va_arg(ap, int), 16, 0, width, padzero);
            break;
    80200f2e:	a451                	j	802011b2 <printf+0x4dc>
                printint(va_arg(ap, int), 16, 0, width, padzero);
    80200f30:	fb843783          	ld	a5,-72(s0)
    80200f34:	00878713          	addi	a4,a5,8
    80200f38:	fae43c23          	sd	a4,-72(s0)
    80200f3c:	439c                	lw	a5,0(a5)
    80200f3e:	853e                	mv	a0,a5
    80200f40:	fdc42703          	lw	a4,-36(s0)
    80200f44:	fd842783          	lw	a5,-40(s0)
    80200f48:	86be                	mv	a3,a5
    80200f4a:	4601                	li	a2,0
    80200f4c:	45c1                	li	a1,16
    80200f4e:	00000097          	auipc	ra,0x0
    80200f52:	c4e080e7          	jalr	-946(ra) # 80200b9c <printint>
            break;
    80200f56:	acb1                	j	802011b2 <printf+0x4dc>
        case 'u':
            if(is_long)
    80200f58:	fd442783          	lw	a5,-44(s0)
    80200f5c:	2781                	sext.w	a5,a5
    80200f5e:	c78d                	beqz	a5,80200f88 <printf+0x2b2>
                printint(va_arg(ap, unsigned long long), 10, 0, width, padzero);
    80200f60:	fb843783          	ld	a5,-72(s0)
    80200f64:	00878713          	addi	a4,a5,8
    80200f68:	fae43c23          	sd	a4,-72(s0)
    80200f6c:	639c                	ld	a5,0(a5)
    80200f6e:	853e                	mv	a0,a5
    80200f70:	fdc42703          	lw	a4,-36(s0)
    80200f74:	fd842783          	lw	a5,-40(s0)
    80200f78:	86be                	mv	a3,a5
    80200f7a:	4601                	li	a2,0
    80200f7c:	45a9                	li	a1,10
    80200f7e:	00000097          	auipc	ra,0x0
    80200f82:	c1e080e7          	jalr	-994(ra) # 80200b9c <printint>
            else
                printint(va_arg(ap, unsigned int), 10, 0, width, padzero);
            break;
    80200f86:	a435                	j	802011b2 <printf+0x4dc>
                printint(va_arg(ap, unsigned int), 10, 0, width, padzero);
    80200f88:	fb843783          	ld	a5,-72(s0)
    80200f8c:	00878713          	addi	a4,a5,8
    80200f90:	fae43c23          	sd	a4,-72(s0)
    80200f94:	439c                	lw	a5,0(a5)
    80200f96:	1782                	slli	a5,a5,0x20
    80200f98:	9381                	srli	a5,a5,0x20
    80200f9a:	fdc42703          	lw	a4,-36(s0)
    80200f9e:	fd842683          	lw	a3,-40(s0)
    80200fa2:	4601                	li	a2,0
    80200fa4:	45a9                	li	a1,10
    80200fa6:	853e                	mv	a0,a5
    80200fa8:	00000097          	auipc	ra,0x0
    80200fac:	bf4080e7          	jalr	-1036(ra) # 80200b9c <printint>
            break;
    80200fb0:	a409                	j	802011b2 <printf+0x4dc>
        case 'c':
            consputc(va_arg(ap, int));
    80200fb2:	fb843783          	ld	a5,-72(s0)
    80200fb6:	00878713          	addi	a4,a5,8
    80200fba:	fae43c23          	sd	a4,-72(s0)
    80200fbe:	439c                	lw	a5,0(a5)
    80200fc0:	853e                	mv	a0,a5
    80200fc2:	00000097          	auipc	ra,0x0
    80200fc6:	b86080e7          	jalr	-1146(ra) # 80200b48 <consputc>
            break;
    80200fca:	a2e5                	j	802011b2 <printf+0x4dc>
        case 's':
            if((s = va_arg(ap, char*)) == 0)
    80200fcc:	fb843783          	ld	a5,-72(s0)
    80200fd0:	00878713          	addi	a4,a5,8
    80200fd4:	fae43c23          	sd	a4,-72(s0)
    80200fd8:	639c                	ld	a5,0(a5)
    80200fda:	fef43023          	sd	a5,-32(s0)
    80200fde:	fe043783          	ld	a5,-32(s0)
    80200fe2:	e799                	bnez	a5,80200ff0 <printf+0x31a>
                s = "(null)";
    80200fe4:	0000d797          	auipc	a5,0xd
    80200fe8:	0f478793          	addi	a5,a5,244 # 8020e0d8 <syscall_performance_bin+0x670>
    80200fec:	fef43023          	sd	a5,-32(s0)
            consputs(s);
    80200ff0:	fe043503          	ld	a0,-32(s0)
    80200ff4:	00000097          	auipc	ra,0x0
    80200ff8:	b7e080e7          	jalr	-1154(ra) # 80200b72 <consputs>
            break;
    80200ffc:	aa5d                	j	802011b2 <printf+0x4dc>
        case 'p':
            unsigned long ptr = (unsigned long)va_arg(ap, void*);
    80200ffe:	fb843783          	ld	a5,-72(s0)
    80201002:	00878713          	addi	a4,a5,8
    80201006:	fae43c23          	sd	a4,-72(s0)
    8020100a:	639c                	ld	a5,0(a5)
    8020100c:	fcf43423          	sd	a5,-56(s0)
            consputs("0x");
    80201010:	0000d517          	auipc	a0,0xd
    80201014:	0d050513          	addi	a0,a0,208 # 8020e0e0 <syscall_performance_bin+0x678>
    80201018:	00000097          	auipc	ra,0x0
    8020101c:	b5a080e7          	jalr	-1190(ra) # 80200b72 <consputs>
            // 输出16位宽，不足补0
            char buf[17];
            int i;
            for (i = 0; i < 16; i++) {
    80201020:	fc042823          	sw	zero,-48(s0)
    80201024:	a0a1                	j	8020106c <printf+0x396>
                int shift = (15 - i) * 4;
    80201026:	47bd                	li	a5,15
    80201028:	fd042703          	lw	a4,-48(s0)
    8020102c:	9f99                	subw	a5,a5,a4
    8020102e:	2781                	sext.w	a5,a5
    80201030:	0027979b          	slliw	a5,a5,0x2
    80201034:	fcf42223          	sw	a5,-60(s0)
                buf[i] = "0123456789abcdef"[(ptr >> shift) & 0xf];
    80201038:	fc442783          	lw	a5,-60(s0)
    8020103c:	873e                	mv	a4,a5
    8020103e:	fc843783          	ld	a5,-56(s0)
    80201042:	00e7d7b3          	srl	a5,a5,a4
    80201046:	8bbd                	andi	a5,a5,15
    80201048:	0000d717          	auipc	a4,0xd
    8020104c:	0a070713          	addi	a4,a4,160 # 8020e0e8 <syscall_performance_bin+0x680>
    80201050:	97ba                	add	a5,a5,a4
    80201052:	0007c703          	lbu	a4,0(a5)
    80201056:	fd042783          	lw	a5,-48(s0)
    8020105a:	17c1                	addi	a5,a5,-16
    8020105c:	97a2                	add	a5,a5,s0
    8020105e:	fae78823          	sb	a4,-80(a5)
            for (i = 0; i < 16; i++) {
    80201062:	fd042783          	lw	a5,-48(s0)
    80201066:	2785                	addiw	a5,a5,1
    80201068:	fcf42823          	sw	a5,-48(s0)
    8020106c:	fd042783          	lw	a5,-48(s0)
    80201070:	0007871b          	sext.w	a4,a5
    80201074:	47bd                	li	a5,15
    80201076:	fae7d8e3          	bge	a5,a4,80201026 <printf+0x350>
            }
            buf[16] = '\0';
    8020107a:	fa040823          	sb	zero,-80(s0)
            consputs(buf);
    8020107e:	fa040793          	addi	a5,s0,-96
    80201082:	853e                	mv	a0,a5
    80201084:	00000097          	auipc	ra,0x0
    80201088:	aee080e7          	jalr	-1298(ra) # 80200b72 <consputs>
            break;
    8020108c:	a21d                	j	802011b2 <printf+0x4dc>
        case 'b':
            if(is_long)
    8020108e:	fd442783          	lw	a5,-44(s0)
    80201092:	2781                	sext.w	a5,a5
    80201094:	c785                	beqz	a5,802010bc <printf+0x3e6>
                printint(va_arg(ap, long long), 2, 0, width, padzero);
    80201096:	fb843783          	ld	a5,-72(s0)
    8020109a:	00878713          	addi	a4,a5,8
    8020109e:	fae43c23          	sd	a4,-72(s0)
    802010a2:	639c                	ld	a5,0(a5)
    802010a4:	fdc42703          	lw	a4,-36(s0)
    802010a8:	fd842683          	lw	a3,-40(s0)
    802010ac:	4601                	li	a2,0
    802010ae:	4589                	li	a1,2
    802010b0:	853e                	mv	a0,a5
    802010b2:	00000097          	auipc	ra,0x0
    802010b6:	aea080e7          	jalr	-1302(ra) # 80200b9c <printint>
            else
                printint(va_arg(ap, int), 2, 0, width, padzero);
            break;
    802010ba:	a8e5                	j	802011b2 <printf+0x4dc>
                printint(va_arg(ap, int), 2, 0, width, padzero);
    802010bc:	fb843783          	ld	a5,-72(s0)
    802010c0:	00878713          	addi	a4,a5,8
    802010c4:	fae43c23          	sd	a4,-72(s0)
    802010c8:	439c                	lw	a5,0(a5)
    802010ca:	853e                	mv	a0,a5
    802010cc:	fdc42703          	lw	a4,-36(s0)
    802010d0:	fd842783          	lw	a5,-40(s0)
    802010d4:	86be                	mv	a3,a5
    802010d6:	4601                	li	a2,0
    802010d8:	4589                	li	a1,2
    802010da:	00000097          	auipc	ra,0x0
    802010de:	ac2080e7          	jalr	-1342(ra) # 80200b9c <printint>
            break;
    802010e2:	a8c1                	j	802011b2 <printf+0x4dc>
        case 'o':
            if(is_long)
    802010e4:	fd442783          	lw	a5,-44(s0)
    802010e8:	2781                	sext.w	a5,a5
    802010ea:	c785                	beqz	a5,80201112 <printf+0x43c>
                printint(va_arg(ap, long long), 8, 0, width, padzero);
    802010ec:	fb843783          	ld	a5,-72(s0)
    802010f0:	00878713          	addi	a4,a5,8
    802010f4:	fae43c23          	sd	a4,-72(s0)
    802010f8:	639c                	ld	a5,0(a5)
    802010fa:	fdc42703          	lw	a4,-36(s0)
    802010fe:	fd842683          	lw	a3,-40(s0)
    80201102:	4601                	li	a2,0
    80201104:	45a1                	li	a1,8
    80201106:	853e                	mv	a0,a5
    80201108:	00000097          	auipc	ra,0x0
    8020110c:	a94080e7          	jalr	-1388(ra) # 80200b9c <printint>
            else
                printint(va_arg(ap, int), 8, 0, width, padzero);
            break;
    80201110:	a04d                	j	802011b2 <printf+0x4dc>
                printint(va_arg(ap, int), 8, 0, width, padzero);
    80201112:	fb843783          	ld	a5,-72(s0)
    80201116:	00878713          	addi	a4,a5,8
    8020111a:	fae43c23          	sd	a4,-72(s0)
    8020111e:	439c                	lw	a5,0(a5)
    80201120:	853e                	mv	a0,a5
    80201122:	fdc42703          	lw	a4,-36(s0)
    80201126:	fd842783          	lw	a5,-40(s0)
    8020112a:	86be                	mv	a3,a5
    8020112c:	4601                	li	a2,0
    8020112e:	45a1                	li	a1,8
    80201130:	00000097          	auipc	ra,0x0
    80201134:	a6c080e7          	jalr	-1428(ra) # 80200b9c <printint>
            break;
    80201138:	a8ad                	j	802011b2 <printf+0x4dc>
        case '%':
            buffer_char('%');
    8020113a:	02500513          	li	a0,37
    8020113e:	00000097          	auipc	ra,0x0
    80201142:	978080e7          	jalr	-1672(ra) # 80200ab6 <buffer_char>
            break;
    80201146:	a0b5                	j	802011b2 <printf+0x4dc>
        default:
            buffer_char('%');
    80201148:	02500513          	li	a0,37
    8020114c:	00000097          	auipc	ra,0x0
    80201150:	96a080e7          	jalr	-1686(ra) # 80200ab6 <buffer_char>
            if(padzero) buffer_char('0');
    80201154:	fdc42783          	lw	a5,-36(s0)
    80201158:	2781                	sext.w	a5,a5
    8020115a:	c799                	beqz	a5,80201168 <printf+0x492>
    8020115c:	03000513          	li	a0,48
    80201160:	00000097          	auipc	ra,0x0
    80201164:	956080e7          	jalr	-1706(ra) # 80200ab6 <buffer_char>
            if(width) {
    80201168:	fd842783          	lw	a5,-40(s0)
    8020116c:	2781                	sext.w	a5,a5
    8020116e:	cf91                	beqz	a5,8020118a <printf+0x4b4>
                // 只支持一位宽度，简单处理
                buffer_char('0' + width);
    80201170:	fd842783          	lw	a5,-40(s0)
    80201174:	0ff7f793          	zext.b	a5,a5
    80201178:	0307879b          	addiw	a5,a5,48
    8020117c:	0ff7f793          	zext.b	a5,a5
    80201180:	853e                	mv	a0,a5
    80201182:	00000097          	auipc	ra,0x0
    80201186:	934080e7          	jalr	-1740(ra) # 80200ab6 <buffer_char>
            }
            if(is_long) buffer_char('l');
    8020118a:	fd442783          	lw	a5,-44(s0)
    8020118e:	2781                	sext.w	a5,a5
    80201190:	c799                	beqz	a5,8020119e <printf+0x4c8>
    80201192:	06c00513          	li	a0,108
    80201196:	00000097          	auipc	ra,0x0
    8020119a:	920080e7          	jalr	-1760(ra) # 80200ab6 <buffer_char>
            buffer_char(c);
    8020119e:	fe842783          	lw	a5,-24(s0)
    802011a2:	0ff7f793          	zext.b	a5,a5
    802011a6:	853e                	mv	a0,a5
    802011a8:	00000097          	auipc	ra,0x0
    802011ac:	90e080e7          	jalr	-1778(ra) # 80200ab6 <buffer_char>
            break;
    802011b0:	0001                	nop
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    802011b2:	fec42783          	lw	a5,-20(s0)
    802011b6:	2785                	addiw	a5,a5,1
    802011b8:	fef42623          	sw	a5,-20(s0)
    802011bc:	fec42783          	lw	a5,-20(s0)
    802011c0:	f9843703          	ld	a4,-104(s0)
    802011c4:	97ba                	add	a5,a5,a4
    802011c6:	0007c783          	lbu	a5,0(a5)
    802011ca:	fef42423          	sw	a5,-24(s0)
    802011ce:	fe842783          	lw	a5,-24(s0)
    802011d2:	2781                	sext.w	a5,a5
    802011d4:	b2079de3          	bnez	a5,80200d0e <printf+0x38>
    802011d8:	a011                	j	802011dc <printf+0x506>
                break;
    802011da:	0001                	nop
        }
    }
    flush_printf_buffer(); // 最后刷新缓冲区
    802011dc:	00000097          	auipc	ra,0x0
    802011e0:	886080e7          	jalr	-1914(ra) # 80200a62 <flush_printf_buffer>
    va_end(ap);
}
    802011e4:	0001                	nop
    802011e6:	70a6                	ld	ra,104(sp)
    802011e8:	7406                	ld	s0,96(sp)
    802011ea:	614d                	addi	sp,sp,176
    802011ec:	8082                	ret

00000000802011ee <clear_screen>:
// 清屏功能
void clear_screen(void) {
    802011ee:	1141                	addi	sp,sp,-16
    802011f0:	e406                	sd	ra,8(sp)
    802011f2:	e022                	sd	s0,0(sp)
    802011f4:	0800                	addi	s0,sp,16
    uart_puts(CLEAR_SCREEN);
    802011f6:	0000d517          	auipc	a0,0xd
    802011fa:	f6250513          	addi	a0,a0,-158 # 8020e158 <syscall_performance_bin+0x6f0>
    802011fe:	fffff097          	auipc	ra,0xfffff
    80201202:	46a080e7          	jalr	1130(ra) # 80200668 <uart_puts>
	uart_puts(CURSOR_HOME);
    80201206:	0000d517          	auipc	a0,0xd
    8020120a:	f5a50513          	addi	a0,a0,-166 # 8020e160 <syscall_performance_bin+0x6f8>
    8020120e:	fffff097          	auipc	ra,0xfffff
    80201212:	45a080e7          	jalr	1114(ra) # 80200668 <uart_puts>
}
    80201216:	0001                	nop
    80201218:	60a2                	ld	ra,8(sp)
    8020121a:	6402                	ld	s0,0(sp)
    8020121c:	0141                	addi	sp,sp,16
    8020121e:	8082                	ret

0000000080201220 <cursor_up>:

// 光标上移
void cursor_up(int lines) {
    80201220:	1101                	addi	sp,sp,-32
    80201222:	ec06                	sd	ra,24(sp)
    80201224:	e822                	sd	s0,16(sp)
    80201226:	1000                	addi	s0,sp,32
    80201228:	87aa                	mv	a5,a0
    8020122a:	fef42623          	sw	a5,-20(s0)
    if (lines <= 0) return;
    8020122e:	fec42783          	lw	a5,-20(s0)
    80201232:	2781                	sext.w	a5,a5
    80201234:	02f05f63          	blez	a5,80201272 <cursor_up+0x52>
    consputc('\033');
    80201238:	456d                	li	a0,27
    8020123a:	00000097          	auipc	ra,0x0
    8020123e:	90e080e7          	jalr	-1778(ra) # 80200b48 <consputc>
    consputc('[');
    80201242:	05b00513          	li	a0,91
    80201246:	00000097          	auipc	ra,0x0
    8020124a:	902080e7          	jalr	-1790(ra) # 80200b48 <consputc>
    printint(lines, 10, 0, 0,0);
    8020124e:	fec42783          	lw	a5,-20(s0)
    80201252:	4701                	li	a4,0
    80201254:	4681                	li	a3,0
    80201256:	4601                	li	a2,0
    80201258:	45a9                	li	a1,10
    8020125a:	853e                	mv	a0,a5
    8020125c:	00000097          	auipc	ra,0x0
    80201260:	940080e7          	jalr	-1728(ra) # 80200b9c <printint>
    consputc('A');
    80201264:	04100513          	li	a0,65
    80201268:	00000097          	auipc	ra,0x0
    8020126c:	8e0080e7          	jalr	-1824(ra) # 80200b48 <consputc>
    80201270:	a011                	j	80201274 <cursor_up+0x54>
    if (lines <= 0) return;
    80201272:	0001                	nop
}
    80201274:	60e2                	ld	ra,24(sp)
    80201276:	6442                	ld	s0,16(sp)
    80201278:	6105                	addi	sp,sp,32
    8020127a:	8082                	ret

000000008020127c <cursor_down>:

// 光标下移
void cursor_down(int lines) {
    8020127c:	1101                	addi	sp,sp,-32
    8020127e:	ec06                	sd	ra,24(sp)
    80201280:	e822                	sd	s0,16(sp)
    80201282:	1000                	addi	s0,sp,32
    80201284:	87aa                	mv	a5,a0
    80201286:	fef42623          	sw	a5,-20(s0)
    if (lines <= 0) return;
    8020128a:	fec42783          	lw	a5,-20(s0)
    8020128e:	2781                	sext.w	a5,a5
    80201290:	02f05f63          	blez	a5,802012ce <cursor_down+0x52>
    consputc('\033');
    80201294:	456d                	li	a0,27
    80201296:	00000097          	auipc	ra,0x0
    8020129a:	8b2080e7          	jalr	-1870(ra) # 80200b48 <consputc>
    consputc('[');
    8020129e:	05b00513          	li	a0,91
    802012a2:	00000097          	auipc	ra,0x0
    802012a6:	8a6080e7          	jalr	-1882(ra) # 80200b48 <consputc>
    printint(lines, 10, 0, 0,0);
    802012aa:	fec42783          	lw	a5,-20(s0)
    802012ae:	4701                	li	a4,0
    802012b0:	4681                	li	a3,0
    802012b2:	4601                	li	a2,0
    802012b4:	45a9                	li	a1,10
    802012b6:	853e                	mv	a0,a5
    802012b8:	00000097          	auipc	ra,0x0
    802012bc:	8e4080e7          	jalr	-1820(ra) # 80200b9c <printint>
    consputc('B');
    802012c0:	04200513          	li	a0,66
    802012c4:	00000097          	auipc	ra,0x0
    802012c8:	884080e7          	jalr	-1916(ra) # 80200b48 <consputc>
    802012cc:	a011                	j	802012d0 <cursor_down+0x54>
    if (lines <= 0) return;
    802012ce:	0001                	nop
}
    802012d0:	60e2                	ld	ra,24(sp)
    802012d2:	6442                	ld	s0,16(sp)
    802012d4:	6105                	addi	sp,sp,32
    802012d6:	8082                	ret

00000000802012d8 <cursor_right>:

// 光标右移
void cursor_right(int cols) {
    802012d8:	1101                	addi	sp,sp,-32
    802012da:	ec06                	sd	ra,24(sp)
    802012dc:	e822                	sd	s0,16(sp)
    802012de:	1000                	addi	s0,sp,32
    802012e0:	87aa                	mv	a5,a0
    802012e2:	fef42623          	sw	a5,-20(s0)
    if (cols <= 0) return;
    802012e6:	fec42783          	lw	a5,-20(s0)
    802012ea:	2781                	sext.w	a5,a5
    802012ec:	02f05f63          	blez	a5,8020132a <cursor_right+0x52>
    consputc('\033');
    802012f0:	456d                	li	a0,27
    802012f2:	00000097          	auipc	ra,0x0
    802012f6:	856080e7          	jalr	-1962(ra) # 80200b48 <consputc>
    consputc('[');
    802012fa:	05b00513          	li	a0,91
    802012fe:	00000097          	auipc	ra,0x0
    80201302:	84a080e7          	jalr	-1974(ra) # 80200b48 <consputc>
    printint(cols, 10, 0,0,0);
    80201306:	fec42783          	lw	a5,-20(s0)
    8020130a:	4701                	li	a4,0
    8020130c:	4681                	li	a3,0
    8020130e:	4601                	li	a2,0
    80201310:	45a9                	li	a1,10
    80201312:	853e                	mv	a0,a5
    80201314:	00000097          	auipc	ra,0x0
    80201318:	888080e7          	jalr	-1912(ra) # 80200b9c <printint>
    consputc('C');
    8020131c:	04300513          	li	a0,67
    80201320:	00000097          	auipc	ra,0x0
    80201324:	828080e7          	jalr	-2008(ra) # 80200b48 <consputc>
    80201328:	a011                	j	8020132c <cursor_right+0x54>
    if (cols <= 0) return;
    8020132a:	0001                	nop
}
    8020132c:	60e2                	ld	ra,24(sp)
    8020132e:	6442                	ld	s0,16(sp)
    80201330:	6105                	addi	sp,sp,32
    80201332:	8082                	ret

0000000080201334 <cursor_left>:

// 光标左移
void cursor_left(int cols) {
    80201334:	1101                	addi	sp,sp,-32
    80201336:	ec06                	sd	ra,24(sp)
    80201338:	e822                	sd	s0,16(sp)
    8020133a:	1000                	addi	s0,sp,32
    8020133c:	87aa                	mv	a5,a0
    8020133e:	fef42623          	sw	a5,-20(s0)
    if (cols <= 0) return;
    80201342:	fec42783          	lw	a5,-20(s0)
    80201346:	2781                	sext.w	a5,a5
    80201348:	02f05f63          	blez	a5,80201386 <cursor_left+0x52>
    consputc('\033');
    8020134c:	456d                	li	a0,27
    8020134e:	fffff097          	auipc	ra,0xfffff
    80201352:	7fa080e7          	jalr	2042(ra) # 80200b48 <consputc>
    consputc('[');
    80201356:	05b00513          	li	a0,91
    8020135a:	fffff097          	auipc	ra,0xfffff
    8020135e:	7ee080e7          	jalr	2030(ra) # 80200b48 <consputc>
    printint(cols, 10, 0,0,0);
    80201362:	fec42783          	lw	a5,-20(s0)
    80201366:	4701                	li	a4,0
    80201368:	4681                	li	a3,0
    8020136a:	4601                	li	a2,0
    8020136c:	45a9                	li	a1,10
    8020136e:	853e                	mv	a0,a5
    80201370:	00000097          	auipc	ra,0x0
    80201374:	82c080e7          	jalr	-2004(ra) # 80200b9c <printint>
    consputc('D');
    80201378:	04400513          	li	a0,68
    8020137c:	fffff097          	auipc	ra,0xfffff
    80201380:	7cc080e7          	jalr	1996(ra) # 80200b48 <consputc>
    80201384:	a011                	j	80201388 <cursor_left+0x54>
    if (cols <= 0) return;
    80201386:	0001                	nop
}
    80201388:	60e2                	ld	ra,24(sp)
    8020138a:	6442                	ld	s0,16(sp)
    8020138c:	6105                	addi	sp,sp,32
    8020138e:	8082                	ret

0000000080201390 <save_cursor>:
// 保存光标位置
void save_cursor(void) {
    80201390:	1141                	addi	sp,sp,-16
    80201392:	e406                	sd	ra,8(sp)
    80201394:	e022                	sd	s0,0(sp)
    80201396:	0800                	addi	s0,sp,16
    consputc('\033');
    80201398:	456d                	li	a0,27
    8020139a:	fffff097          	auipc	ra,0xfffff
    8020139e:	7ae080e7          	jalr	1966(ra) # 80200b48 <consputc>
    consputc('[');
    802013a2:	05b00513          	li	a0,91
    802013a6:	fffff097          	auipc	ra,0xfffff
    802013aa:	7a2080e7          	jalr	1954(ra) # 80200b48 <consputc>
    consputc('s');
    802013ae:	07300513          	li	a0,115
    802013b2:	fffff097          	auipc	ra,0xfffff
    802013b6:	796080e7          	jalr	1942(ra) # 80200b48 <consputc>
}
    802013ba:	0001                	nop
    802013bc:	60a2                	ld	ra,8(sp)
    802013be:	6402                	ld	s0,0(sp)
    802013c0:	0141                	addi	sp,sp,16
    802013c2:	8082                	ret

00000000802013c4 <restore_cursor>:

// 恢复光标位置
void restore_cursor(void) {
    802013c4:	1141                	addi	sp,sp,-16
    802013c6:	e406                	sd	ra,8(sp)
    802013c8:	e022                	sd	s0,0(sp)
    802013ca:	0800                	addi	s0,sp,16
    consputc('\033');
    802013cc:	456d                	li	a0,27
    802013ce:	fffff097          	auipc	ra,0xfffff
    802013d2:	77a080e7          	jalr	1914(ra) # 80200b48 <consputc>
    consputc('[');
    802013d6:	05b00513          	li	a0,91
    802013da:	fffff097          	auipc	ra,0xfffff
    802013de:	76e080e7          	jalr	1902(ra) # 80200b48 <consputc>
    consputc('u');
    802013e2:	07500513          	li	a0,117
    802013e6:	fffff097          	auipc	ra,0xfffff
    802013ea:	762080e7          	jalr	1890(ra) # 80200b48 <consputc>
}
    802013ee:	0001                	nop
    802013f0:	60a2                	ld	ra,8(sp)
    802013f2:	6402                	ld	s0,0(sp)
    802013f4:	0141                	addi	sp,sp,16
    802013f6:	8082                	ret

00000000802013f8 <cursor_to_column>:

// 移动到行首
void cursor_to_column(int col) {
    802013f8:	1101                	addi	sp,sp,-32
    802013fa:	ec06                	sd	ra,24(sp)
    802013fc:	e822                	sd	s0,16(sp)
    802013fe:	1000                	addi	s0,sp,32
    80201400:	87aa                	mv	a5,a0
    80201402:	fef42623          	sw	a5,-20(s0)
    if (col <= 0) col = 1;
    80201406:	fec42783          	lw	a5,-20(s0)
    8020140a:	2781                	sext.w	a5,a5
    8020140c:	00f04563          	bgtz	a5,80201416 <cursor_to_column+0x1e>
    80201410:	4785                	li	a5,1
    80201412:	fef42623          	sw	a5,-20(s0)
    consputc('\033');
    80201416:	456d                	li	a0,27
    80201418:	fffff097          	auipc	ra,0xfffff
    8020141c:	730080e7          	jalr	1840(ra) # 80200b48 <consputc>
    consputc('[');
    80201420:	05b00513          	li	a0,91
    80201424:	fffff097          	auipc	ra,0xfffff
    80201428:	724080e7          	jalr	1828(ra) # 80200b48 <consputc>
    printint(col, 10, 0,0,0);
    8020142c:	fec42783          	lw	a5,-20(s0)
    80201430:	4701                	li	a4,0
    80201432:	4681                	li	a3,0
    80201434:	4601                	li	a2,0
    80201436:	45a9                	li	a1,10
    80201438:	853e                	mv	a0,a5
    8020143a:	fffff097          	auipc	ra,0xfffff
    8020143e:	762080e7          	jalr	1890(ra) # 80200b9c <printint>
    consputc('G');
    80201442:	04700513          	li	a0,71
    80201446:	fffff097          	auipc	ra,0xfffff
    8020144a:	702080e7          	jalr	1794(ra) # 80200b48 <consputc>
}
    8020144e:	0001                	nop
    80201450:	60e2                	ld	ra,24(sp)
    80201452:	6442                	ld	s0,16(sp)
    80201454:	6105                	addi	sp,sp,32
    80201456:	8082                	ret

0000000080201458 <goto_rc>:
// 光标定位到指定行列
void goto_rc(int row, int col) {
    80201458:	1101                	addi	sp,sp,-32
    8020145a:	ec06                	sd	ra,24(sp)
    8020145c:	e822                	sd	s0,16(sp)
    8020145e:	1000                	addi	s0,sp,32
    80201460:	87aa                	mv	a5,a0
    80201462:	872e                	mv	a4,a1
    80201464:	fef42623          	sw	a5,-20(s0)
    80201468:	87ba                	mv	a5,a4
    8020146a:	fef42423          	sw	a5,-24(s0)
    consputc('\033');
    8020146e:	456d                	li	a0,27
    80201470:	fffff097          	auipc	ra,0xfffff
    80201474:	6d8080e7          	jalr	1752(ra) # 80200b48 <consputc>
    consputc('[');
    80201478:	05b00513          	li	a0,91
    8020147c:	fffff097          	auipc	ra,0xfffff
    80201480:	6cc080e7          	jalr	1740(ra) # 80200b48 <consputc>
    printint(row, 10, 0,0,0);
    80201484:	fec42783          	lw	a5,-20(s0)
    80201488:	4701                	li	a4,0
    8020148a:	4681                	li	a3,0
    8020148c:	4601                	li	a2,0
    8020148e:	45a9                	li	a1,10
    80201490:	853e                	mv	a0,a5
    80201492:	fffff097          	auipc	ra,0xfffff
    80201496:	70a080e7          	jalr	1802(ra) # 80200b9c <printint>
    consputc(';');
    8020149a:	03b00513          	li	a0,59
    8020149e:	fffff097          	auipc	ra,0xfffff
    802014a2:	6aa080e7          	jalr	1706(ra) # 80200b48 <consputc>
    printint(col, 10, 0,0,0);
    802014a6:	fe842783          	lw	a5,-24(s0)
    802014aa:	4701                	li	a4,0
    802014ac:	4681                	li	a3,0
    802014ae:	4601                	li	a2,0
    802014b0:	45a9                	li	a1,10
    802014b2:	853e                	mv	a0,a5
    802014b4:	fffff097          	auipc	ra,0xfffff
    802014b8:	6e8080e7          	jalr	1768(ra) # 80200b9c <printint>
    consputc('H');
    802014bc:	04800513          	li	a0,72
    802014c0:	fffff097          	auipc	ra,0xfffff
    802014c4:	688080e7          	jalr	1672(ra) # 80200b48 <consputc>
}
    802014c8:	0001                	nop
    802014ca:	60e2                	ld	ra,24(sp)
    802014cc:	6442                	ld	s0,16(sp)
    802014ce:	6105                	addi	sp,sp,32
    802014d0:	8082                	ret

00000000802014d2 <reset_color>:
// 颜色控制
void reset_color(void) {
    802014d2:	1141                	addi	sp,sp,-16
    802014d4:	e406                	sd	ra,8(sp)
    802014d6:	e022                	sd	s0,0(sp)
    802014d8:	0800                	addi	s0,sp,16
	uart_puts(ESC "[0m");
    802014da:	0000d517          	auipc	a0,0xd
    802014de:	c8e50513          	addi	a0,a0,-882 # 8020e168 <syscall_performance_bin+0x700>
    802014e2:	fffff097          	auipc	ra,0xfffff
    802014e6:	186080e7          	jalr	390(ra) # 80200668 <uart_puts>
}
    802014ea:	0001                	nop
    802014ec:	60a2                	ld	ra,8(sp)
    802014ee:	6402                	ld	s0,0(sp)
    802014f0:	0141                	addi	sp,sp,16
    802014f2:	8082                	ret

00000000802014f4 <set_fg_color>:
// 设置前景色
void set_fg_color(int color) {
    802014f4:	1101                	addi	sp,sp,-32
    802014f6:	ec06                	sd	ra,24(sp)
    802014f8:	e822                	sd	s0,16(sp)
    802014fa:	1000                	addi	s0,sp,32
    802014fc:	87aa                	mv	a5,a0
    802014fe:	fef42623          	sw	a5,-20(s0)
	if (color < 30 || color > 37) return; // 支持30-37
    80201502:	fec42783          	lw	a5,-20(s0)
    80201506:	0007871b          	sext.w	a4,a5
    8020150a:	47f5                	li	a5,29
    8020150c:	04e7d763          	bge	a5,a4,8020155a <set_fg_color+0x66>
    80201510:	fec42783          	lw	a5,-20(s0)
    80201514:	0007871b          	sext.w	a4,a5
    80201518:	02500793          	li	a5,37
    8020151c:	02e7cf63          	blt	a5,a4,8020155a <set_fg_color+0x66>
	consputc('\033');
    80201520:	456d                	li	a0,27
    80201522:	fffff097          	auipc	ra,0xfffff
    80201526:	626080e7          	jalr	1574(ra) # 80200b48 <consputc>
	consputc('[');
    8020152a:	05b00513          	li	a0,91
    8020152e:	fffff097          	auipc	ra,0xfffff
    80201532:	61a080e7          	jalr	1562(ra) # 80200b48 <consputc>
	printint(color, 10, 0,0,0);
    80201536:	fec42783          	lw	a5,-20(s0)
    8020153a:	4701                	li	a4,0
    8020153c:	4681                	li	a3,0
    8020153e:	4601                	li	a2,0
    80201540:	45a9                	li	a1,10
    80201542:	853e                	mv	a0,a5
    80201544:	fffff097          	auipc	ra,0xfffff
    80201548:	658080e7          	jalr	1624(ra) # 80200b9c <printint>
	consputc('m');
    8020154c:	06d00513          	li	a0,109
    80201550:	fffff097          	auipc	ra,0xfffff
    80201554:	5f8080e7          	jalr	1528(ra) # 80200b48 <consputc>
    80201558:	a011                	j	8020155c <set_fg_color+0x68>
	if (color < 30 || color > 37) return; // 支持30-37
    8020155a:	0001                	nop
}
    8020155c:	60e2                	ld	ra,24(sp)
    8020155e:	6442                	ld	s0,16(sp)
    80201560:	6105                	addi	sp,sp,32
    80201562:	8082                	ret

0000000080201564 <set_bg_color>:
// 设置背景色
void set_bg_color(int color) {
    80201564:	1101                	addi	sp,sp,-32
    80201566:	ec06                	sd	ra,24(sp)
    80201568:	e822                	sd	s0,16(sp)
    8020156a:	1000                	addi	s0,sp,32
    8020156c:	87aa                	mv	a5,a0
    8020156e:	fef42623          	sw	a5,-20(s0)
	if (color < 40 || color > 47) return; // 支持40-47
    80201572:	fec42783          	lw	a5,-20(s0)
    80201576:	0007871b          	sext.w	a4,a5
    8020157a:	02700793          	li	a5,39
    8020157e:	04e7d763          	bge	a5,a4,802015cc <set_bg_color+0x68>
    80201582:	fec42783          	lw	a5,-20(s0)
    80201586:	0007871b          	sext.w	a4,a5
    8020158a:	02f00793          	li	a5,47
    8020158e:	02e7cf63          	blt	a5,a4,802015cc <set_bg_color+0x68>
	consputc('\033');
    80201592:	456d                	li	a0,27
    80201594:	fffff097          	auipc	ra,0xfffff
    80201598:	5b4080e7          	jalr	1460(ra) # 80200b48 <consputc>
	consputc('[');
    8020159c:	05b00513          	li	a0,91
    802015a0:	fffff097          	auipc	ra,0xfffff
    802015a4:	5a8080e7          	jalr	1448(ra) # 80200b48 <consputc>
	printint(color, 10, 0,0,0);
    802015a8:	fec42783          	lw	a5,-20(s0)
    802015ac:	4701                	li	a4,0
    802015ae:	4681                	li	a3,0
    802015b0:	4601                	li	a2,0
    802015b2:	45a9                	li	a1,10
    802015b4:	853e                	mv	a0,a5
    802015b6:	fffff097          	auipc	ra,0xfffff
    802015ba:	5e6080e7          	jalr	1510(ra) # 80200b9c <printint>
	consputc('m');
    802015be:	06d00513          	li	a0,109
    802015c2:	fffff097          	auipc	ra,0xfffff
    802015c6:	586080e7          	jalr	1414(ra) # 80200b48 <consputc>
    802015ca:	a011                	j	802015ce <set_bg_color+0x6a>
	if (color < 40 || color > 47) return; // 支持40-47
    802015cc:	0001                	nop
}
    802015ce:	60e2                	ld	ra,24(sp)
    802015d0:	6442                	ld	s0,16(sp)
    802015d2:	6105                	addi	sp,sp,32
    802015d4:	8082                	ret

00000000802015d6 <color_red>:
// 简易文字颜色
void color_red(void) {
    802015d6:	1141                	addi	sp,sp,-16
    802015d8:	e406                	sd	ra,8(sp)
    802015da:	e022                	sd	s0,0(sp)
    802015dc:	0800                	addi	s0,sp,16
	set_fg_color(31); // 红色
    802015de:	457d                	li	a0,31
    802015e0:	00000097          	auipc	ra,0x0
    802015e4:	f14080e7          	jalr	-236(ra) # 802014f4 <set_fg_color>
}
    802015e8:	0001                	nop
    802015ea:	60a2                	ld	ra,8(sp)
    802015ec:	6402                	ld	s0,0(sp)
    802015ee:	0141                	addi	sp,sp,16
    802015f0:	8082                	ret

00000000802015f2 <color_green>:
void color_green(void) {
    802015f2:	1141                	addi	sp,sp,-16
    802015f4:	e406                	sd	ra,8(sp)
    802015f6:	e022                	sd	s0,0(sp)
    802015f8:	0800                	addi	s0,sp,16
	set_fg_color(32); // 绿色
    802015fa:	02000513          	li	a0,32
    802015fe:	00000097          	auipc	ra,0x0
    80201602:	ef6080e7          	jalr	-266(ra) # 802014f4 <set_fg_color>
}
    80201606:	0001                	nop
    80201608:	60a2                	ld	ra,8(sp)
    8020160a:	6402                	ld	s0,0(sp)
    8020160c:	0141                	addi	sp,sp,16
    8020160e:	8082                	ret

0000000080201610 <color_yellow>:
void color_yellow(void) {
    80201610:	1141                	addi	sp,sp,-16
    80201612:	e406                	sd	ra,8(sp)
    80201614:	e022                	sd	s0,0(sp)
    80201616:	0800                	addi	s0,sp,16
	set_fg_color(33); // 黄色
    80201618:	02100513          	li	a0,33
    8020161c:	00000097          	auipc	ra,0x0
    80201620:	ed8080e7          	jalr	-296(ra) # 802014f4 <set_fg_color>
}
    80201624:	0001                	nop
    80201626:	60a2                	ld	ra,8(sp)
    80201628:	6402                	ld	s0,0(sp)
    8020162a:	0141                	addi	sp,sp,16
    8020162c:	8082                	ret

000000008020162e <color_blue>:
void color_blue(void) {
    8020162e:	1141                	addi	sp,sp,-16
    80201630:	e406                	sd	ra,8(sp)
    80201632:	e022                	sd	s0,0(sp)
    80201634:	0800                	addi	s0,sp,16
	set_fg_color(34); // 蓝色
    80201636:	02200513          	li	a0,34
    8020163a:	00000097          	auipc	ra,0x0
    8020163e:	eba080e7          	jalr	-326(ra) # 802014f4 <set_fg_color>
}
    80201642:	0001                	nop
    80201644:	60a2                	ld	ra,8(sp)
    80201646:	6402                	ld	s0,0(sp)
    80201648:	0141                	addi	sp,sp,16
    8020164a:	8082                	ret

000000008020164c <color_purple>:
void color_purple(void) {
    8020164c:	1141                	addi	sp,sp,-16
    8020164e:	e406                	sd	ra,8(sp)
    80201650:	e022                	sd	s0,0(sp)
    80201652:	0800                	addi	s0,sp,16
	set_fg_color(35); // 紫色
    80201654:	02300513          	li	a0,35
    80201658:	00000097          	auipc	ra,0x0
    8020165c:	e9c080e7          	jalr	-356(ra) # 802014f4 <set_fg_color>
}
    80201660:	0001                	nop
    80201662:	60a2                	ld	ra,8(sp)
    80201664:	6402                	ld	s0,0(sp)
    80201666:	0141                	addi	sp,sp,16
    80201668:	8082                	ret

000000008020166a <color_cyan>:
void color_cyan(void) {
    8020166a:	1141                	addi	sp,sp,-16
    8020166c:	e406                	sd	ra,8(sp)
    8020166e:	e022                	sd	s0,0(sp)
    80201670:	0800                	addi	s0,sp,16
	set_fg_color(36); // 青色
    80201672:	02400513          	li	a0,36
    80201676:	00000097          	auipc	ra,0x0
    8020167a:	e7e080e7          	jalr	-386(ra) # 802014f4 <set_fg_color>
}
    8020167e:	0001                	nop
    80201680:	60a2                	ld	ra,8(sp)
    80201682:	6402                	ld	s0,0(sp)
    80201684:	0141                	addi	sp,sp,16
    80201686:	8082                	ret

0000000080201688 <color_reverse>:
void color_reverse(void){
    80201688:	1141                	addi	sp,sp,-16
    8020168a:	e406                	sd	ra,8(sp)
    8020168c:	e022                	sd	s0,0(sp)
    8020168e:	0800                	addi	s0,sp,16
	set_fg_color(37); // 反色
    80201690:	02500513          	li	a0,37
    80201694:	00000097          	auipc	ra,0x0
    80201698:	e60080e7          	jalr	-416(ra) # 802014f4 <set_fg_color>
}
    8020169c:	0001                	nop
    8020169e:	60a2                	ld	ra,8(sp)
    802016a0:	6402                	ld	s0,0(sp)
    802016a2:	0141                	addi	sp,sp,16
    802016a4:	8082                	ret

00000000802016a6 <set_color>:
void set_color(int fg, int bg) {
    802016a6:	1101                	addi	sp,sp,-32
    802016a8:	ec06                	sd	ra,24(sp)
    802016aa:	e822                	sd	s0,16(sp)
    802016ac:	1000                	addi	s0,sp,32
    802016ae:	87aa                	mv	a5,a0
    802016b0:	872e                	mv	a4,a1
    802016b2:	fef42623          	sw	a5,-20(s0)
    802016b6:	87ba                	mv	a5,a4
    802016b8:	fef42423          	sw	a5,-24(s0)
	set_bg_color(bg);
    802016bc:	fe842783          	lw	a5,-24(s0)
    802016c0:	853e                	mv	a0,a5
    802016c2:	00000097          	auipc	ra,0x0
    802016c6:	ea2080e7          	jalr	-350(ra) # 80201564 <set_bg_color>
	set_fg_color(fg);
    802016ca:	fec42783          	lw	a5,-20(s0)
    802016ce:	853e                	mv	a0,a5
    802016d0:	00000097          	auipc	ra,0x0
    802016d4:	e24080e7          	jalr	-476(ra) # 802014f4 <set_fg_color>
}
    802016d8:	0001                	nop
    802016da:	60e2                	ld	ra,24(sp)
    802016dc:	6442                	ld	s0,16(sp)
    802016de:	6105                	addi	sp,sp,32
    802016e0:	8082                	ret

00000000802016e2 <clear_line>:
void clear_line(){
    802016e2:	1141                	addi	sp,sp,-16
    802016e4:	e406                	sd	ra,8(sp)
    802016e6:	e022                	sd	s0,0(sp)
    802016e8:	0800                	addi	s0,sp,16
	consputc('\033');
    802016ea:	456d                	li	a0,27
    802016ec:	fffff097          	auipc	ra,0xfffff
    802016f0:	45c080e7          	jalr	1116(ra) # 80200b48 <consputc>
	consputc('[');
    802016f4:	05b00513          	li	a0,91
    802016f8:	fffff097          	auipc	ra,0xfffff
    802016fc:	450080e7          	jalr	1104(ra) # 80200b48 <consputc>
	consputc('2');
    80201700:	03200513          	li	a0,50
    80201704:	fffff097          	auipc	ra,0xfffff
    80201708:	444080e7          	jalr	1092(ra) # 80200b48 <consputc>
	consputc('K');
    8020170c:	04b00513          	li	a0,75
    80201710:	fffff097          	auipc	ra,0xfffff
    80201714:	438080e7          	jalr	1080(ra) # 80200b48 <consputc>
}
    80201718:	0001                	nop
    8020171a:	60a2                	ld	ra,8(sp)
    8020171c:	6402                	ld	s0,0(sp)
    8020171e:	0141                	addi	sp,sp,16
    80201720:	8082                	ret

0000000080201722 <panic>:

void panic(const char *msg) {
    80201722:	1101                	addi	sp,sp,-32
    80201724:	ec06                	sd	ra,24(sp)
    80201726:	e822                	sd	s0,16(sp)
    80201728:	1000                	addi	s0,sp,32
    8020172a:	fea43423          	sd	a0,-24(s0)
	color_red(); // 可选：红色显示
    8020172e:	00000097          	auipc	ra,0x0
    80201732:	ea8080e7          	jalr	-344(ra) # 802015d6 <color_red>
	printf("panic: %s\n", msg);
    80201736:	fe843583          	ld	a1,-24(s0)
    8020173a:	0000d517          	auipc	a0,0xd
    8020173e:	a3650513          	addi	a0,a0,-1482 # 8020e170 <syscall_performance_bin+0x708>
    80201742:	fffff097          	auipc	ra,0xfffff
    80201746:	594080e7          	jalr	1428(ra) # 80200cd6 <printf>
	reset_color();
    8020174a:	00000097          	auipc	ra,0x0
    8020174e:	d88080e7          	jalr	-632(ra) # 802014d2 <reset_color>
	while (1) { /* 死循环，防止继续执行 */ }
    80201752:	0001                	nop
    80201754:	bffd                	j	80201752 <panic+0x30>

0000000080201756 <warning>:
}
void warning(const char *fmt, ...) {
    80201756:	7159                	addi	sp,sp,-112
    80201758:	f406                	sd	ra,40(sp)
    8020175a:	f022                	sd	s0,32(sp)
    8020175c:	1800                	addi	s0,sp,48
    8020175e:	fca43c23          	sd	a0,-40(s0)
    80201762:	e40c                	sd	a1,8(s0)
    80201764:	e810                	sd	a2,16(s0)
    80201766:	ec14                	sd	a3,24(s0)
    80201768:	f018                	sd	a4,32(s0)
    8020176a:	f41c                	sd	a5,40(s0)
    8020176c:	03043823          	sd	a6,48(s0)
    80201770:	03143c23          	sd	a7,56(s0)
    va_list ap;
    color_purple(); // 设置紫色
    80201774:	00000097          	auipc	ra,0x0
    80201778:	ed8080e7          	jalr	-296(ra) # 8020164c <color_purple>
    printf("[WARNING] ");
    8020177c:	0000d517          	auipc	a0,0xd
    80201780:	a0450513          	addi	a0,a0,-1532 # 8020e180 <syscall_performance_bin+0x718>
    80201784:	fffff097          	auipc	ra,0xfffff
    80201788:	552080e7          	jalr	1362(ra) # 80200cd6 <printf>
    va_start(ap, fmt);
    8020178c:	04040793          	addi	a5,s0,64
    80201790:	fcf43823          	sd	a5,-48(s0)
    80201794:	fd043783          	ld	a5,-48(s0)
    80201798:	fc878793          	addi	a5,a5,-56
    8020179c:	fef43423          	sd	a5,-24(s0)
    printf(fmt, ap);
    802017a0:	fe843783          	ld	a5,-24(s0)
    802017a4:	85be                	mv	a1,a5
    802017a6:	fd843503          	ld	a0,-40(s0)
    802017aa:	fffff097          	auipc	ra,0xfffff
    802017ae:	52c080e7          	jalr	1324(ra) # 80200cd6 <printf>
    va_end(ap);
    reset_color(); // 恢复默认颜色
    802017b2:	00000097          	auipc	ra,0x0
    802017b6:	d20080e7          	jalr	-736(ra) # 802014d2 <reset_color>
}
    802017ba:	0001                	nop
    802017bc:	70a2                	ld	ra,40(sp)
    802017be:	7402                	ld	s0,32(sp)
    802017c0:	6165                	addi	sp,sp,112
    802017c2:	8082                	ret

00000000802017c4 <test_printf_precision>:
void test_printf_precision(void) {
    802017c4:	1101                	addi	sp,sp,-32
    802017c6:	ec06                	sd	ra,24(sp)
    802017c8:	e822                	sd	s0,16(sp)
    802017ca:	1000                	addi	s0,sp,32
	clear_screen();
    802017cc:	00000097          	auipc	ra,0x0
    802017d0:	a22080e7          	jalr	-1502(ra) # 802011ee <clear_screen>
    printf("=== 详细的printf测试 ===\n");
    802017d4:	0000d517          	auipc	a0,0xd
    802017d8:	9bc50513          	addi	a0,a0,-1604 # 8020e190 <syscall_performance_bin+0x728>
    802017dc:	fffff097          	auipc	ra,0xfffff
    802017e0:	4fa080e7          	jalr	1274(ra) # 80200cd6 <printf>
    
    // 测试十六进制格式
    printf("十六进制测试:\n");
    802017e4:	0000d517          	auipc	a0,0xd
    802017e8:	9cc50513          	addi	a0,a0,-1588 # 8020e1b0 <syscall_performance_bin+0x748>
    802017ec:	fffff097          	auipc	ra,0xfffff
    802017f0:	4ea080e7          	jalr	1258(ra) # 80200cd6 <printf>
    printf("  255 = 0x%x (expected: ff)\n", 255);
    802017f4:	0ff00593          	li	a1,255
    802017f8:	0000d517          	auipc	a0,0xd
    802017fc:	9d050513          	addi	a0,a0,-1584 # 8020e1c8 <syscall_performance_bin+0x760>
    80201800:	fffff097          	auipc	ra,0xfffff
    80201804:	4d6080e7          	jalr	1238(ra) # 80200cd6 <printf>
    printf("  4096 = 0x%x (expected: 1000)\n", 4096);
    80201808:	6585                	lui	a1,0x1
    8020180a:	0000d517          	auipc	a0,0xd
    8020180e:	9de50513          	addi	a0,a0,-1570 # 8020e1e8 <syscall_performance_bin+0x780>
    80201812:	fffff097          	auipc	ra,0xfffff
    80201816:	4c4080e7          	jalr	1220(ra) # 80200cd6 <printf>
    printf("  0x1234abcd = 0x%x\n", 0x1234abcd);
    8020181a:	1234b7b7          	lui	a5,0x1234b
    8020181e:	bcd78593          	addi	a1,a5,-1075 # 1234abcd <_entry-0x6deb5433>
    80201822:	0000d517          	auipc	a0,0xd
    80201826:	9e650513          	addi	a0,a0,-1562 # 8020e208 <syscall_performance_bin+0x7a0>
    8020182a:	fffff097          	auipc	ra,0xfffff
    8020182e:	4ac080e7          	jalr	1196(ra) # 80200cd6 <printf>
    
    // 测试十进制格式  
    printf("十进制测试:\n");
    80201832:	0000d517          	auipc	a0,0xd
    80201836:	9ee50513          	addi	a0,a0,-1554 # 8020e220 <syscall_performance_bin+0x7b8>
    8020183a:	fffff097          	auipc	ra,0xfffff
    8020183e:	49c080e7          	jalr	1180(ra) # 80200cd6 <printf>
    printf("  正数: %d\n", 42);
    80201842:	02a00593          	li	a1,42
    80201846:	0000d517          	auipc	a0,0xd
    8020184a:	9f250513          	addi	a0,a0,-1550 # 8020e238 <syscall_performance_bin+0x7d0>
    8020184e:	fffff097          	auipc	ra,0xfffff
    80201852:	488080e7          	jalr	1160(ra) # 80200cd6 <printf>
    printf("  负数: %d\n", -42);
    80201856:	fd600593          	li	a1,-42
    8020185a:	0000d517          	auipc	a0,0xd
    8020185e:	9ee50513          	addi	a0,a0,-1554 # 8020e248 <syscall_performance_bin+0x7e0>
    80201862:	fffff097          	auipc	ra,0xfffff
    80201866:	474080e7          	jalr	1140(ra) # 80200cd6 <printf>
    printf("  零: %d\n", 0);
    8020186a:	4581                	li	a1,0
    8020186c:	0000d517          	auipc	a0,0xd
    80201870:	9ec50513          	addi	a0,a0,-1556 # 8020e258 <syscall_performance_bin+0x7f0>
    80201874:	fffff097          	auipc	ra,0xfffff
    80201878:	462080e7          	jalr	1122(ra) # 80200cd6 <printf>
    printf("  大数: %d\n", 123456789);
    8020187c:	075bd7b7          	lui	a5,0x75bd
    80201880:	d1578593          	addi	a1,a5,-747 # 75bcd15 <_entry-0x78c432eb>
    80201884:	0000d517          	auipc	a0,0xd
    80201888:	9e450513          	addi	a0,a0,-1564 # 8020e268 <syscall_performance_bin+0x800>
    8020188c:	fffff097          	auipc	ra,0xfffff
    80201890:	44a080e7          	jalr	1098(ra) # 80200cd6 <printf>
    
    // 测试无符号格式
    printf("无符号测试:\n");
    80201894:	0000d517          	auipc	a0,0xd
    80201898:	9e450513          	addi	a0,a0,-1564 # 8020e278 <syscall_performance_bin+0x810>
    8020189c:	fffff097          	auipc	ra,0xfffff
    802018a0:	43a080e7          	jalr	1082(ra) # 80200cd6 <printf>
    printf("  大无符号数：%u\n", 4294967295U);
    802018a4:	55fd                	li	a1,-1
    802018a6:	0000d517          	auipc	a0,0xd
    802018aa:	9ea50513          	addi	a0,a0,-1558 # 8020e290 <syscall_performance_bin+0x828>
    802018ae:	fffff097          	auipc	ra,0xfffff
    802018b2:	428080e7          	jalr	1064(ra) # 80200cd6 <printf>
    printf("  零：%u\n", 0U);
    802018b6:	4581                	li	a1,0
    802018b8:	0000d517          	auipc	a0,0xd
    802018bc:	9f050513          	addi	a0,a0,-1552 # 8020e2a8 <syscall_performance_bin+0x840>
    802018c0:	fffff097          	auipc	ra,0xfffff
    802018c4:	416080e7          	jalr	1046(ra) # 80200cd6 <printf>
	printf("  小无符号数：%u\n", 12345U);
    802018c8:	678d                	lui	a5,0x3
    802018ca:	03978593          	addi	a1,a5,57 # 3039 <_entry-0x801fcfc7>
    802018ce:	0000d517          	auipc	a0,0xd
    802018d2:	9ea50513          	addi	a0,a0,-1558 # 8020e2b8 <syscall_performance_bin+0x850>
    802018d6:	fffff097          	auipc	ra,0xfffff
    802018da:	400080e7          	jalr	1024(ra) # 80200cd6 <printf>

	// 测试边界
	printf("边界测试:\n");
    802018de:	0000d517          	auipc	a0,0xd
    802018e2:	9f250513          	addi	a0,a0,-1550 # 8020e2d0 <syscall_performance_bin+0x868>
    802018e6:	fffff097          	auipc	ra,0xfffff
    802018ea:	3f0080e7          	jalr	1008(ra) # 80200cd6 <printf>
	printf("  INT_MAX: %d\n", 2147483647);
    802018ee:	800007b7          	lui	a5,0x80000
    802018f2:	fff7c593          	not	a1,a5
    802018f6:	0000d517          	auipc	a0,0xd
    802018fa:	9ea50513          	addi	a0,a0,-1558 # 8020e2e0 <syscall_performance_bin+0x878>
    802018fe:	fffff097          	auipc	ra,0xfffff
    80201902:	3d8080e7          	jalr	984(ra) # 80200cd6 <printf>
	printf("  INT_MIN: %d\n", -2147483648);
    80201906:	800005b7          	lui	a1,0x80000
    8020190a:	0000d517          	auipc	a0,0xd
    8020190e:	9e650513          	addi	a0,a0,-1562 # 8020e2f0 <syscall_performance_bin+0x888>
    80201912:	fffff097          	auipc	ra,0xfffff
    80201916:	3c4080e7          	jalr	964(ra) # 80200cd6 <printf>
	printf("  UINT_MAX: %u\n", 4294967295U);
    8020191a:	55fd                	li	a1,-1
    8020191c:	0000d517          	auipc	a0,0xd
    80201920:	9e450513          	addi	a0,a0,-1564 # 8020e300 <syscall_performance_bin+0x898>
    80201924:	fffff097          	auipc	ra,0xfffff
    80201928:	3b2080e7          	jalr	946(ra) # 80200cd6 <printf>
	printf(" -1 as unsigned: %u\n", (unsigned int)-1);
    8020192c:	55fd                	li	a1,-1
    8020192e:	0000d517          	auipc	a0,0xd
    80201932:	9e250513          	addi	a0,a0,-1566 # 8020e310 <syscall_performance_bin+0x8a8>
    80201936:	fffff097          	auipc	ra,0xfffff
    8020193a:	3a0080e7          	jalr	928(ra) # 80200cd6 <printf>
    
    // 测试字符串边界情况
    printf("字符串测试:\n");
    8020193e:	0000d517          	auipc	a0,0xd
    80201942:	9ea50513          	addi	a0,a0,-1558 # 8020e328 <syscall_performance_bin+0x8c0>
    80201946:	fffff097          	auipc	ra,0xfffff
    8020194a:	390080e7          	jalr	912(ra) # 80200cd6 <printf>
    printf("  空字符串: '%s'\n", "");
    8020194e:	0000d597          	auipc	a1,0xd
    80201952:	9f258593          	addi	a1,a1,-1550 # 8020e340 <syscall_performance_bin+0x8d8>
    80201956:	0000d517          	auipc	a0,0xd
    8020195a:	9f250513          	addi	a0,a0,-1550 # 8020e348 <syscall_performance_bin+0x8e0>
    8020195e:	fffff097          	auipc	ra,0xfffff
    80201962:	378080e7          	jalr	888(ra) # 80200cd6 <printf>
    printf("  单字符: '%s'\n", "X");
    80201966:	0000d597          	auipc	a1,0xd
    8020196a:	9fa58593          	addi	a1,a1,-1542 # 8020e360 <syscall_performance_bin+0x8f8>
    8020196e:	0000d517          	auipc	a0,0xd
    80201972:	9fa50513          	addi	a0,a0,-1542 # 8020e368 <syscall_performance_bin+0x900>
    80201976:	fffff097          	auipc	ra,0xfffff
    8020197a:	360080e7          	jalr	864(ra) # 80200cd6 <printf>
    printf("  长字符串: '%s'\n", "This is a longer test string");
    8020197e:	0000d597          	auipc	a1,0xd
    80201982:	a0258593          	addi	a1,a1,-1534 # 8020e380 <syscall_performance_bin+0x918>
    80201986:	0000d517          	auipc	a0,0xd
    8020198a:	a1a50513          	addi	a0,a0,-1510 # 8020e3a0 <syscall_performance_bin+0x938>
    8020198e:	fffff097          	auipc	ra,0xfffff
    80201992:	348080e7          	jalr	840(ra) # 80200cd6 <printf>
	printf("  非常长字符串： '%s'\n", "Formal version: Entities should not be multiplied beyond necessity.\nPlain English: If two or more explanations fit the facts equally well, choose the simplest one.\nScientific phrasing: When multiple hypotheses explain the same observation, the simplest hypothesis that requires the fewest assumptions is most likely to be correct.");
    80201996:	0000d597          	auipc	a1,0xd
    8020199a:	a2258593          	addi	a1,a1,-1502 # 8020e3b8 <syscall_performance_bin+0x950>
    8020199e:	0000d517          	auipc	a0,0xd
    802019a2:	b6a50513          	addi	a0,a0,-1174 # 8020e508 <syscall_performance_bin+0xaa0>
    802019a6:	fffff097          	auipc	ra,0xfffff
    802019aa:	330080e7          	jalr	816(ra) # 80200cd6 <printf>
	
	// 测试混合格式
	printf("混合格式测试:\n");
    802019ae:	0000d517          	auipc	a0,0xd
    802019b2:	b7a50513          	addi	a0,a0,-1158 # 8020e528 <syscall_performance_bin+0xac0>
    802019b6:	fffff097          	auipc	ra,0xfffff
    802019ba:	320080e7          	jalr	800(ra) # 80200cd6 <printf>
	printf("  Hex: 0x%x, Dec: %d, Unsigned: %u\n", 255, -255, 255U);
    802019be:	0ff00693          	li	a3,255
    802019c2:	f0100613          	li	a2,-255
    802019c6:	0ff00593          	li	a1,255
    802019ca:	0000d517          	auipc	a0,0xd
    802019ce:	b7650513          	addi	a0,a0,-1162 # 8020e540 <syscall_performance_bin+0xad8>
    802019d2:	fffff097          	auipc	ra,0xfffff
    802019d6:	304080e7          	jalr	772(ra) # 80200cd6 <printf>
	
	// 测试百分号输出
	printf("百分号输出测试:\n");
    802019da:	0000d517          	auipc	a0,0xd
    802019de:	b8e50513          	addi	a0,a0,-1138 # 8020e568 <syscall_performance_bin+0xb00>
    802019e2:	fffff097          	auipc	ra,0xfffff
    802019e6:	2f4080e7          	jalr	756(ra) # 80200cd6 <printf>
	printf("  100%% 完成!\n");
    802019ea:	0000d517          	auipc	a0,0xd
    802019ee:	b9650513          	addi	a0,a0,-1130 # 8020e580 <syscall_performance_bin+0xb18>
    802019f2:	fffff097          	auipc	ra,0xfffff
    802019f6:	2e4080e7          	jalr	740(ra) # 80200cd6 <printf>
	
	// 测试NULL字符串
	char *null_str = 0;
    802019fa:	fe043423          	sd	zero,-24(s0)
	printf("NULL字符串测试:\n");
    802019fe:	0000d517          	auipc	a0,0xd
    80201a02:	b9a50513          	addi	a0,a0,-1126 # 8020e598 <syscall_performance_bin+0xb30>
    80201a06:	fffff097          	auipc	ra,0xfffff
    80201a0a:	2d0080e7          	jalr	720(ra) # 80200cd6 <printf>
	printf("  NULL as string: '%s'\n", null_str);
    80201a0e:	fe843583          	ld	a1,-24(s0)
    80201a12:	0000d517          	auipc	a0,0xd
    80201a16:	b9e50513          	addi	a0,a0,-1122 # 8020e5b0 <syscall_performance_bin+0xb48>
    80201a1a:	fffff097          	auipc	ra,0xfffff
    80201a1e:	2bc080e7          	jalr	700(ra) # 80200cd6 <printf>
	
	// 测试指针格式
	int var = 42;
    80201a22:	02a00793          	li	a5,42
    80201a26:	fef42223          	sw	a5,-28(s0)
	printf("指针测试:\n");
    80201a2a:	0000d517          	auipc	a0,0xd
    80201a2e:	b9e50513          	addi	a0,a0,-1122 # 8020e5c8 <syscall_performance_bin+0xb60>
    80201a32:	fffff097          	auipc	ra,0xfffff
    80201a36:	2a4080e7          	jalr	676(ra) # 80200cd6 <printf>
	printf("  Address of var: %p\n", &var);
    80201a3a:	fe440793          	addi	a5,s0,-28
    80201a3e:	85be                	mv	a1,a5
    80201a40:	0000d517          	auipc	a0,0xd
    80201a44:	b9850513          	addi	a0,a0,-1128 # 8020e5d8 <syscall_performance_bin+0xb70>
    80201a48:	fffff097          	auipc	ra,0xfffff
    80201a4c:	28e080e7          	jalr	654(ra) # 80200cd6 <printf>
	
	// 测试负数的无符号输出
	printf("负数无符号输出测试:\n");
    80201a50:	0000d517          	auipc	a0,0xd
    80201a54:	ba050513          	addi	a0,a0,-1120 # 8020e5f0 <syscall_performance_bin+0xb88>
    80201a58:	fffff097          	auipc	ra,0xfffff
    80201a5c:	27e080e7          	jalr	638(ra) # 80200cd6 <printf>
	printf("  -1 as unsigned: %u\n", (unsigned int)-1);
    80201a60:	55fd                	li	a1,-1
    80201a62:	0000d517          	auipc	a0,0xd
    80201a66:	bae50513          	addi	a0,a0,-1106 # 8020e610 <syscall_performance_bin+0xba8>
    80201a6a:	fffff097          	auipc	ra,0xfffff
    80201a6e:	26c080e7          	jalr	620(ra) # 80200cd6 <printf>
	
	// 测试不同进制的数字
	printf("不同进制测试:\n");
    80201a72:	0000d517          	auipc	a0,0xd
    80201a76:	bb650513          	addi	a0,a0,-1098 # 8020e628 <syscall_performance_bin+0xbc0>
    80201a7a:	fffff097          	auipc	ra,0xfffff
    80201a7e:	25c080e7          	jalr	604(ra) # 80200cd6 <printf>
	printf("  Binary of 5: %b\n", 5);
    80201a82:	4595                	li	a1,5
    80201a84:	0000d517          	auipc	a0,0xd
    80201a88:	bbc50513          	addi	a0,a0,-1092 # 8020e640 <syscall_performance_bin+0xbd8>
    80201a8c:	fffff097          	auipc	ra,0xfffff
    80201a90:	24a080e7          	jalr	586(ra) # 80200cd6 <printf>
	printf("  Octal of 8 : %o\n", 8); 
    80201a94:	45a1                	li	a1,8
    80201a96:	0000d517          	auipc	a0,0xd
    80201a9a:	bc250513          	addi	a0,a0,-1086 # 8020e658 <syscall_performance_bin+0xbf0>
    80201a9e:	fffff097          	auipc	ra,0xfffff
    80201aa2:	238080e7          	jalr	568(ra) # 80200cd6 <printf>
	printf("=== printf测试结束 ===\n");
    80201aa6:	0000d517          	auipc	a0,0xd
    80201aaa:	bca50513          	addi	a0,a0,-1078 # 8020e670 <syscall_performance_bin+0xc08>
    80201aae:	fffff097          	auipc	ra,0xfffff
    80201ab2:	228080e7          	jalr	552(ra) # 80200cd6 <printf>
}
    80201ab6:	0001                	nop
    80201ab8:	60e2                	ld	ra,24(sp)
    80201aba:	6442                	ld	s0,16(sp)
    80201abc:	6105                	addi	sp,sp,32
    80201abe:	8082                	ret

0000000080201ac0 <test_curse_move>:
void test_curse_move(){
    80201ac0:	1101                	addi	sp,sp,-32
    80201ac2:	ec06                	sd	ra,24(sp)
    80201ac4:	e822                	sd	s0,16(sp)
    80201ac6:	1000                	addi	s0,sp,32
	clear_screen(); // 清屏
    80201ac8:	fffff097          	auipc	ra,0xfffff
    80201acc:	726080e7          	jalr	1830(ra) # 802011ee <clear_screen>
	printf("=== 光标移动测试 ===\n");
    80201ad0:	0000d517          	auipc	a0,0xd
    80201ad4:	bc050513          	addi	a0,a0,-1088 # 8020e690 <syscall_performance_bin+0xc28>
    80201ad8:	fffff097          	auipc	ra,0xfffff
    80201adc:	1fe080e7          	jalr	510(ra) # 80200cd6 <printf>
	for (int i = 3; i <= 7; i++) {
    80201ae0:	478d                	li	a5,3
    80201ae2:	fef42623          	sw	a5,-20(s0)
    80201ae6:	a881                	j	80201b36 <test_curse_move+0x76>
		for (int j = 1; j <= 10; j++) {
    80201ae8:	4785                	li	a5,1
    80201aea:	fef42423          	sw	a5,-24(s0)
    80201aee:	a805                	j	80201b1e <test_curse_move+0x5e>
			goto_rc(i, j);
    80201af0:	fe842703          	lw	a4,-24(s0)
    80201af4:	fec42783          	lw	a5,-20(s0)
    80201af8:	85ba                	mv	a1,a4
    80201afa:	853e                	mv	a0,a5
    80201afc:	00000097          	auipc	ra,0x0
    80201b00:	95c080e7          	jalr	-1700(ra) # 80201458 <goto_rc>
			printf("*");
    80201b04:	0000d517          	auipc	a0,0xd
    80201b08:	bac50513          	addi	a0,a0,-1108 # 8020e6b0 <syscall_performance_bin+0xc48>
    80201b0c:	fffff097          	auipc	ra,0xfffff
    80201b10:	1ca080e7          	jalr	458(ra) # 80200cd6 <printf>
		for (int j = 1; j <= 10; j++) {
    80201b14:	fe842783          	lw	a5,-24(s0)
    80201b18:	2785                	addiw	a5,a5,1 # ffffffff80000001 <_bss_end+0xfffffffeffdd9861>
    80201b1a:	fef42423          	sw	a5,-24(s0)
    80201b1e:	fe842783          	lw	a5,-24(s0)
    80201b22:	0007871b          	sext.w	a4,a5
    80201b26:	47a9                	li	a5,10
    80201b28:	fce7d4e3          	bge	a5,a4,80201af0 <test_curse_move+0x30>
	for (int i = 3; i <= 7; i++) {
    80201b2c:	fec42783          	lw	a5,-20(s0)
    80201b30:	2785                	addiw	a5,a5,1
    80201b32:	fef42623          	sw	a5,-20(s0)
    80201b36:	fec42783          	lw	a5,-20(s0)
    80201b3a:	0007871b          	sext.w	a4,a5
    80201b3e:	479d                	li	a5,7
    80201b40:	fae7d4e3          	bge	a5,a4,80201ae8 <test_curse_move+0x28>
		}
	}
	goto_rc(9, 1);
    80201b44:	4585                	li	a1,1
    80201b46:	4525                	li	a0,9
    80201b48:	00000097          	auipc	ra,0x0
    80201b4c:	910080e7          	jalr	-1776(ra) # 80201458 <goto_rc>
	save_cursor();
    80201b50:	00000097          	auipc	ra,0x0
    80201b54:	840080e7          	jalr	-1984(ra) # 80201390 <save_cursor>
	// 光标移动测试
	cursor_up(5);
    80201b58:	4515                	li	a0,5
    80201b5a:	fffff097          	auipc	ra,0xfffff
    80201b5e:	6c6080e7          	jalr	1734(ra) # 80201220 <cursor_up>
	cursor_right(2);
    80201b62:	4509                	li	a0,2
    80201b64:	fffff097          	auipc	ra,0xfffff
    80201b68:	774080e7          	jalr	1908(ra) # 802012d8 <cursor_right>
	printf("+++++");
    80201b6c:	0000d517          	auipc	a0,0xd
    80201b70:	b4c50513          	addi	a0,a0,-1204 # 8020e6b8 <syscall_performance_bin+0xc50>
    80201b74:	fffff097          	auipc	ra,0xfffff
    80201b78:	162080e7          	jalr	354(ra) # 80200cd6 <printf>
	cursor_down(2);
    80201b7c:	4509                	li	a0,2
    80201b7e:	fffff097          	auipc	ra,0xfffff
    80201b82:	6fe080e7          	jalr	1790(ra) # 8020127c <cursor_down>
	cursor_left(5);
    80201b86:	4515                	li	a0,5
    80201b88:	fffff097          	auipc	ra,0xfffff
    80201b8c:	7ac080e7          	jalr	1964(ra) # 80201334 <cursor_left>
	printf("-----");
    80201b90:	0000d517          	auipc	a0,0xd
    80201b94:	b3050513          	addi	a0,a0,-1232 # 8020e6c0 <syscall_performance_bin+0xc58>
    80201b98:	fffff097          	auipc	ra,0xfffff
    80201b9c:	13e080e7          	jalr	318(ra) # 80200cd6 <printf>
	restore_cursor();
    80201ba0:	00000097          	auipc	ra,0x0
    80201ba4:	824080e7          	jalr	-2012(ra) # 802013c4 <restore_cursor>
	printf("=== 光标移动测试结束 ===\n");
    80201ba8:	0000d517          	auipc	a0,0xd
    80201bac:	b2050513          	addi	a0,a0,-1248 # 8020e6c8 <syscall_performance_bin+0xc60>
    80201bb0:	fffff097          	auipc	ra,0xfffff
    80201bb4:	126080e7          	jalr	294(ra) # 80200cd6 <printf>
}
    80201bb8:	0001                	nop
    80201bba:	60e2                	ld	ra,24(sp)
    80201bbc:	6442                	ld	s0,16(sp)
    80201bbe:	6105                	addi	sp,sp,32
    80201bc0:	8082                	ret

0000000080201bc2 <test_basic_colors>:

void test_basic_colors(void) {
    80201bc2:	1141                	addi	sp,sp,-16
    80201bc4:	e406                	sd	ra,8(sp)
    80201bc6:	e022                	sd	s0,0(sp)
    80201bc8:	0800                	addi	s0,sp,16
    clear_screen();
    80201bca:	fffff097          	auipc	ra,0xfffff
    80201bce:	624080e7          	jalr	1572(ra) # 802011ee <clear_screen>
    printf("=== 基本颜色测试 ===\n\n");
    80201bd2:	0000d517          	auipc	a0,0xd
    80201bd6:	b1e50513          	addi	a0,a0,-1250 # 8020e6f0 <syscall_performance_bin+0xc88>
    80201bda:	fffff097          	auipc	ra,0xfffff
    80201bde:	0fc080e7          	jalr	252(ra) # 80200cd6 <printf>
    
    // 测试基本前景色
    printf("前景色测试:\n");
    80201be2:	0000d517          	auipc	a0,0xd
    80201be6:	b2e50513          	addi	a0,a0,-1234 # 8020e710 <syscall_performance_bin+0xca8>
    80201bea:	fffff097          	auipc	ra,0xfffff
    80201bee:	0ec080e7          	jalr	236(ra) # 80200cd6 <printf>
    color_red();    printf("红色文字 ");
    80201bf2:	00000097          	auipc	ra,0x0
    80201bf6:	9e4080e7          	jalr	-1564(ra) # 802015d6 <color_red>
    80201bfa:	0000d517          	auipc	a0,0xd
    80201bfe:	b2e50513          	addi	a0,a0,-1234 # 8020e728 <syscall_performance_bin+0xcc0>
    80201c02:	fffff097          	auipc	ra,0xfffff
    80201c06:	0d4080e7          	jalr	212(ra) # 80200cd6 <printf>
    color_green();  printf("绿色文字 ");
    80201c0a:	00000097          	auipc	ra,0x0
    80201c0e:	9e8080e7          	jalr	-1560(ra) # 802015f2 <color_green>
    80201c12:	0000d517          	auipc	a0,0xd
    80201c16:	b2650513          	addi	a0,a0,-1242 # 8020e738 <syscall_performance_bin+0xcd0>
    80201c1a:	fffff097          	auipc	ra,0xfffff
    80201c1e:	0bc080e7          	jalr	188(ra) # 80200cd6 <printf>
    color_yellow(); printf("黄色文字 ");
    80201c22:	00000097          	auipc	ra,0x0
    80201c26:	9ee080e7          	jalr	-1554(ra) # 80201610 <color_yellow>
    80201c2a:	0000d517          	auipc	a0,0xd
    80201c2e:	b1e50513          	addi	a0,a0,-1250 # 8020e748 <syscall_performance_bin+0xce0>
    80201c32:	fffff097          	auipc	ra,0xfffff
    80201c36:	0a4080e7          	jalr	164(ra) # 80200cd6 <printf>
    color_blue();   printf("蓝色文字 ");
    80201c3a:	00000097          	auipc	ra,0x0
    80201c3e:	9f4080e7          	jalr	-1548(ra) # 8020162e <color_blue>
    80201c42:	0000d517          	auipc	a0,0xd
    80201c46:	b1650513          	addi	a0,a0,-1258 # 8020e758 <syscall_performance_bin+0xcf0>
    80201c4a:	fffff097          	auipc	ra,0xfffff
    80201c4e:	08c080e7          	jalr	140(ra) # 80200cd6 <printf>
    color_purple(); printf("紫色文字 ");
    80201c52:	00000097          	auipc	ra,0x0
    80201c56:	9fa080e7          	jalr	-1542(ra) # 8020164c <color_purple>
    80201c5a:	0000d517          	auipc	a0,0xd
    80201c5e:	b0e50513          	addi	a0,a0,-1266 # 8020e768 <syscall_performance_bin+0xd00>
    80201c62:	fffff097          	auipc	ra,0xfffff
    80201c66:	074080e7          	jalr	116(ra) # 80200cd6 <printf>
    color_cyan();   printf("青色文字 ");
    80201c6a:	00000097          	auipc	ra,0x0
    80201c6e:	a00080e7          	jalr	-1536(ra) # 8020166a <color_cyan>
    80201c72:	0000d517          	auipc	a0,0xd
    80201c76:	b0650513          	addi	a0,a0,-1274 # 8020e778 <syscall_performance_bin+0xd10>
    80201c7a:	fffff097          	auipc	ra,0xfffff
    80201c7e:	05c080e7          	jalr	92(ra) # 80200cd6 <printf>
    color_reverse();  printf("反色文字");
    80201c82:	00000097          	auipc	ra,0x0
    80201c86:	a06080e7          	jalr	-1530(ra) # 80201688 <color_reverse>
    80201c8a:	0000d517          	auipc	a0,0xd
    80201c8e:	afe50513          	addi	a0,a0,-1282 # 8020e788 <syscall_performance_bin+0xd20>
    80201c92:	fffff097          	auipc	ra,0xfffff
    80201c96:	044080e7          	jalr	68(ra) # 80200cd6 <printf>
    reset_color();
    80201c9a:	00000097          	auipc	ra,0x0
    80201c9e:	838080e7          	jalr	-1992(ra) # 802014d2 <reset_color>
    printf("\n\n");
    80201ca2:	0000d517          	auipc	a0,0xd
    80201ca6:	af650513          	addi	a0,a0,-1290 # 8020e798 <syscall_performance_bin+0xd30>
    80201caa:	fffff097          	auipc	ra,0xfffff
    80201cae:	02c080e7          	jalr	44(ra) # 80200cd6 <printf>
    
    // 测试背景色
    printf("背景色测试:\n");
    80201cb2:	0000d517          	auipc	a0,0xd
    80201cb6:	aee50513          	addi	a0,a0,-1298 # 8020e7a0 <syscall_performance_bin+0xd38>
    80201cba:	fffff097          	auipc	ra,0xfffff
    80201cbe:	01c080e7          	jalr	28(ra) # 80200cd6 <printf>
    set_bg_color(41); printf(" 红色背景 "); reset_color();
    80201cc2:	02900513          	li	a0,41
    80201cc6:	00000097          	auipc	ra,0x0
    80201cca:	89e080e7          	jalr	-1890(ra) # 80201564 <set_bg_color>
    80201cce:	0000d517          	auipc	a0,0xd
    80201cd2:	aea50513          	addi	a0,a0,-1302 # 8020e7b8 <syscall_performance_bin+0xd50>
    80201cd6:	fffff097          	auipc	ra,0xfffff
    80201cda:	000080e7          	jalr	ra # 80200cd6 <printf>
    80201cde:	fffff097          	auipc	ra,0xfffff
    80201ce2:	7f4080e7          	jalr	2036(ra) # 802014d2 <reset_color>
    set_bg_color(42); printf(" 绿色背景 "); reset_color();
    80201ce6:	02a00513          	li	a0,42
    80201cea:	00000097          	auipc	ra,0x0
    80201cee:	87a080e7          	jalr	-1926(ra) # 80201564 <set_bg_color>
    80201cf2:	0000d517          	auipc	a0,0xd
    80201cf6:	ad650513          	addi	a0,a0,-1322 # 8020e7c8 <syscall_performance_bin+0xd60>
    80201cfa:	fffff097          	auipc	ra,0xfffff
    80201cfe:	fdc080e7          	jalr	-36(ra) # 80200cd6 <printf>
    80201d02:	fffff097          	auipc	ra,0xfffff
    80201d06:	7d0080e7          	jalr	2000(ra) # 802014d2 <reset_color>
    set_bg_color(43); printf(" 黄色背景 "); reset_color();
    80201d0a:	02b00513          	li	a0,43
    80201d0e:	00000097          	auipc	ra,0x0
    80201d12:	856080e7          	jalr	-1962(ra) # 80201564 <set_bg_color>
    80201d16:	0000d517          	auipc	a0,0xd
    80201d1a:	ac250513          	addi	a0,a0,-1342 # 8020e7d8 <syscall_performance_bin+0xd70>
    80201d1e:	fffff097          	auipc	ra,0xfffff
    80201d22:	fb8080e7          	jalr	-72(ra) # 80200cd6 <printf>
    80201d26:	fffff097          	auipc	ra,0xfffff
    80201d2a:	7ac080e7          	jalr	1964(ra) # 802014d2 <reset_color>
    set_bg_color(44); printf(" 蓝色背景 "); reset_color();
    80201d2e:	02c00513          	li	a0,44
    80201d32:	00000097          	auipc	ra,0x0
    80201d36:	832080e7          	jalr	-1998(ra) # 80201564 <set_bg_color>
    80201d3a:	0000d517          	auipc	a0,0xd
    80201d3e:	aae50513          	addi	a0,a0,-1362 # 8020e7e8 <syscall_performance_bin+0xd80>
    80201d42:	fffff097          	auipc	ra,0xfffff
    80201d46:	f94080e7          	jalr	-108(ra) # 80200cd6 <printf>
    80201d4a:	fffff097          	auipc	ra,0xfffff
    80201d4e:	788080e7          	jalr	1928(ra) # 802014d2 <reset_color>
	set_bg_color(47); printf(" 反色背景 "); reset_color();
    80201d52:	02f00513          	li	a0,47
    80201d56:	00000097          	auipc	ra,0x0
    80201d5a:	80e080e7          	jalr	-2034(ra) # 80201564 <set_bg_color>
    80201d5e:	0000d517          	auipc	a0,0xd
    80201d62:	a9a50513          	addi	a0,a0,-1382 # 8020e7f8 <syscall_performance_bin+0xd90>
    80201d66:	fffff097          	auipc	ra,0xfffff
    80201d6a:	f70080e7          	jalr	-144(ra) # 80200cd6 <printf>
    80201d6e:	fffff097          	auipc	ra,0xfffff
    80201d72:	764080e7          	jalr	1892(ra) # 802014d2 <reset_color>
    printf("\n\n");
    80201d76:	0000d517          	auipc	a0,0xd
    80201d7a:	a2250513          	addi	a0,a0,-1502 # 8020e798 <syscall_performance_bin+0xd30>
    80201d7e:	fffff097          	auipc	ra,0xfffff
    80201d82:	f58080e7          	jalr	-168(ra) # 80200cd6 <printf>
    
    // 测试组合效果
    printf("组合效果测试:\n");
    80201d86:	0000d517          	auipc	a0,0xd
    80201d8a:	a8250513          	addi	a0,a0,-1406 # 8020e808 <syscall_performance_bin+0xda0>
    80201d8e:	fffff097          	auipc	ra,0xfffff
    80201d92:	f48080e7          	jalr	-184(ra) # 80200cd6 <printf>
    set_color(31, 44); printf(" 红字蓝底 "); reset_color();
    80201d96:	02c00593          	li	a1,44
    80201d9a:	457d                	li	a0,31
    80201d9c:	00000097          	auipc	ra,0x0
    80201da0:	90a080e7          	jalr	-1782(ra) # 802016a6 <set_color>
    80201da4:	0000d517          	auipc	a0,0xd
    80201da8:	a7c50513          	addi	a0,a0,-1412 # 8020e820 <syscall_performance_bin+0xdb8>
    80201dac:	fffff097          	auipc	ra,0xfffff
    80201db0:	f2a080e7          	jalr	-214(ra) # 80200cd6 <printf>
    80201db4:	fffff097          	auipc	ra,0xfffff
    80201db8:	71e080e7          	jalr	1822(ra) # 802014d2 <reset_color>
    set_color(33, 45); printf(" 黄字紫底 "); reset_color();
    80201dbc:	02d00593          	li	a1,45
    80201dc0:	02100513          	li	a0,33
    80201dc4:	00000097          	auipc	ra,0x0
    80201dc8:	8e2080e7          	jalr	-1822(ra) # 802016a6 <set_color>
    80201dcc:	0000d517          	auipc	a0,0xd
    80201dd0:	a6450513          	addi	a0,a0,-1436 # 8020e830 <syscall_performance_bin+0xdc8>
    80201dd4:	fffff097          	auipc	ra,0xfffff
    80201dd8:	f02080e7          	jalr	-254(ra) # 80200cd6 <printf>
    80201ddc:	fffff097          	auipc	ra,0xfffff
    80201de0:	6f6080e7          	jalr	1782(ra) # 802014d2 <reset_color>
    set_color(32, 47); printf(" 绿字反底 "); reset_color();
    80201de4:	02f00593          	li	a1,47
    80201de8:	02000513          	li	a0,32
    80201dec:	00000097          	auipc	ra,0x0
    80201df0:	8ba080e7          	jalr	-1862(ra) # 802016a6 <set_color>
    80201df4:	0000d517          	auipc	a0,0xd
    80201df8:	a4c50513          	addi	a0,a0,-1460 # 8020e840 <syscall_performance_bin+0xdd8>
    80201dfc:	fffff097          	auipc	ra,0xfffff
    80201e00:	eda080e7          	jalr	-294(ra) # 80200cd6 <printf>
    80201e04:	fffff097          	auipc	ra,0xfffff
    80201e08:	6ce080e7          	jalr	1742(ra) # 802014d2 <reset_color>
    printf("\n\n");
    80201e0c:	0000d517          	auipc	a0,0xd
    80201e10:	98c50513          	addi	a0,a0,-1652 # 8020e798 <syscall_performance_bin+0xd30>
    80201e14:	fffff097          	auipc	ra,0xfffff
    80201e18:	ec2080e7          	jalr	-318(ra) # 80200cd6 <printf>
	reset_color();
    80201e1c:	fffff097          	auipc	ra,0xfffff
    80201e20:	6b6080e7          	jalr	1718(ra) # 802014d2 <reset_color>
	printf("重置为默认颜色，本行文字会被清除\n"); 
    80201e24:	0000d517          	auipc	a0,0xd
    80201e28:	a2c50513          	addi	a0,a0,-1492 # 8020e850 <syscall_performance_bin+0xde8>
    80201e2c:	fffff097          	auipc	ra,0xfffff
    80201e30:	eaa080e7          	jalr	-342(ra) # 80200cd6 <printf>
	cursor_up(1); // 光标上移一行
    80201e34:	4505                	li	a0,1
    80201e36:	fffff097          	auipc	ra,0xfffff
    80201e3a:	3ea080e7          	jalr	1002(ra) # 80201220 <cursor_up>
	clear_line();
    80201e3e:	00000097          	auipc	ra,0x0
    80201e42:	8a4080e7          	jalr	-1884(ra) # 802016e2 <clear_line>

	printf("=== 颜色测试结束 ===\n");
    80201e46:	0000d517          	auipc	a0,0xd
    80201e4a:	a4250513          	addi	a0,a0,-1470 # 8020e888 <syscall_performance_bin+0xe20>
    80201e4e:	fffff097          	auipc	ra,0xfffff
    80201e52:	e88080e7          	jalr	-376(ra) # 80200cd6 <printf>
    80201e56:	0001                	nop
    80201e58:	60a2                	ld	ra,8(sp)
    80201e5a:	6402                	ld	s0,0(sp)
    80201e5c:	0141                	addi	sp,sp,16
    80201e5e:	8082                	ret

0000000080201e60 <memset>:
#include "defs.h"
// 自行实现memset
void *memset(void *dst, int c, unsigned long n) {
    80201e60:	7139                	addi	sp,sp,-64
    80201e62:	fc22                	sd	s0,56(sp)
    80201e64:	0080                	addi	s0,sp,64
    80201e66:	fca43c23          	sd	a0,-40(s0)
    80201e6a:	87ae                	mv	a5,a1
    80201e6c:	fcc43423          	sd	a2,-56(s0)
    80201e70:	fcf42a23          	sw	a5,-44(s0)
    unsigned char *p = dst;
    80201e74:	fd843783          	ld	a5,-40(s0)
    80201e78:	fef43423          	sd	a5,-24(s0)
    while (n-- > 0)
    80201e7c:	a829                	j	80201e96 <memset+0x36>
        *p++ = (unsigned char)c;
    80201e7e:	fe843783          	ld	a5,-24(s0)
    80201e82:	00178713          	addi	a4,a5,1
    80201e86:	fee43423          	sd	a4,-24(s0)
    80201e8a:	fd442703          	lw	a4,-44(s0)
    80201e8e:	0ff77713          	zext.b	a4,a4
    80201e92:	00e78023          	sb	a4,0(a5)
    while (n-- > 0)
    80201e96:	fc843783          	ld	a5,-56(s0)
    80201e9a:	fff78713          	addi	a4,a5,-1
    80201e9e:	fce43423          	sd	a4,-56(s0)
    80201ea2:	fff1                	bnez	a5,80201e7e <memset+0x1e>
    return dst;
    80201ea4:	fd843783          	ld	a5,-40(s0)
}
    80201ea8:	853e                	mv	a0,a5
    80201eaa:	7462                	ld	s0,56(sp)
    80201eac:	6121                	addi	sp,sp,64
    80201eae:	8082                	ret

0000000080201eb0 <memmove>:
void *memmove(void *dst, const void *src, unsigned long n) {
    80201eb0:	7139                	addi	sp,sp,-64
    80201eb2:	fc22                	sd	s0,56(sp)
    80201eb4:	0080                	addi	s0,sp,64
    80201eb6:	fca43c23          	sd	a0,-40(s0)
    80201eba:	fcb43823          	sd	a1,-48(s0)
    80201ebe:	fcc43423          	sd	a2,-56(s0)
	unsigned char *d = dst;
    80201ec2:	fd843783          	ld	a5,-40(s0)
    80201ec6:	fef43423          	sd	a5,-24(s0)
	const unsigned char *s = src;
    80201eca:	fd043783          	ld	a5,-48(s0)
    80201ece:	fef43023          	sd	a5,-32(s0)
	if (d < s) {
    80201ed2:	fe843703          	ld	a4,-24(s0)
    80201ed6:	fe043783          	ld	a5,-32(s0)
    80201eda:	02f77b63          	bgeu	a4,a5,80201f10 <memmove+0x60>
		while (n-- > 0)
    80201ede:	a00d                	j	80201f00 <memmove+0x50>
			*d++ = *s++;
    80201ee0:	fe043703          	ld	a4,-32(s0)
    80201ee4:	00170793          	addi	a5,a4,1
    80201ee8:	fef43023          	sd	a5,-32(s0)
    80201eec:	fe843783          	ld	a5,-24(s0)
    80201ef0:	00178693          	addi	a3,a5,1
    80201ef4:	fed43423          	sd	a3,-24(s0)
    80201ef8:	00074703          	lbu	a4,0(a4)
    80201efc:	00e78023          	sb	a4,0(a5)
		while (n-- > 0)
    80201f00:	fc843783          	ld	a5,-56(s0)
    80201f04:	fff78713          	addi	a4,a5,-1
    80201f08:	fce43423          	sd	a4,-56(s0)
    80201f0c:	fbf1                	bnez	a5,80201ee0 <memmove+0x30>
    80201f0e:	a889                	j	80201f60 <memmove+0xb0>
	} else {
		d += n;
    80201f10:	fe843703          	ld	a4,-24(s0)
    80201f14:	fc843783          	ld	a5,-56(s0)
    80201f18:	97ba                	add	a5,a5,a4
    80201f1a:	fef43423          	sd	a5,-24(s0)
		s += n;
    80201f1e:	fe043703          	ld	a4,-32(s0)
    80201f22:	fc843783          	ld	a5,-56(s0)
    80201f26:	97ba                	add	a5,a5,a4
    80201f28:	fef43023          	sd	a5,-32(s0)
		while (n-- > 0)
    80201f2c:	a01d                	j	80201f52 <memmove+0xa2>
			*(--d) = *(--s);
    80201f2e:	fe043783          	ld	a5,-32(s0)
    80201f32:	17fd                	addi	a5,a5,-1
    80201f34:	fef43023          	sd	a5,-32(s0)
    80201f38:	fe843783          	ld	a5,-24(s0)
    80201f3c:	17fd                	addi	a5,a5,-1
    80201f3e:	fef43423          	sd	a5,-24(s0)
    80201f42:	fe043783          	ld	a5,-32(s0)
    80201f46:	0007c703          	lbu	a4,0(a5)
    80201f4a:	fe843783          	ld	a5,-24(s0)
    80201f4e:	00e78023          	sb	a4,0(a5)
		while (n-- > 0)
    80201f52:	fc843783          	ld	a5,-56(s0)
    80201f56:	fff78713          	addi	a4,a5,-1
    80201f5a:	fce43423          	sd	a4,-56(s0)
    80201f5e:	fbe1                	bnez	a5,80201f2e <memmove+0x7e>
	}
	return dst;
    80201f60:	fd843783          	ld	a5,-40(s0)
}
    80201f64:	853e                	mv	a0,a5
    80201f66:	7462                	ld	s0,56(sp)
    80201f68:	6121                	addi	sp,sp,64
    80201f6a:	8082                	ret

0000000080201f6c <memcpy>:
void *memcpy(void *dst, const void *src, size_t n) {
    80201f6c:	715d                	addi	sp,sp,-80
    80201f6e:	e4a2                	sd	s0,72(sp)
    80201f70:	0880                	addi	s0,sp,80
    80201f72:	fca43423          	sd	a0,-56(s0)
    80201f76:	fcb43023          	sd	a1,-64(s0)
    80201f7a:	fac43c23          	sd	a2,-72(s0)
    char *d = dst;
    80201f7e:	fc843783          	ld	a5,-56(s0)
    80201f82:	fef43023          	sd	a5,-32(s0)
    const char *s = src;
    80201f86:	fc043783          	ld	a5,-64(s0)
    80201f8a:	fcf43c23          	sd	a5,-40(s0)
    for (size_t i = 0; i < n; i++) {
    80201f8e:	fe043423          	sd	zero,-24(s0)
    80201f92:	a025                	j	80201fba <memcpy+0x4e>
        d[i] = s[i];
    80201f94:	fd843703          	ld	a4,-40(s0)
    80201f98:	fe843783          	ld	a5,-24(s0)
    80201f9c:	973e                	add	a4,a4,a5
    80201f9e:	fe043683          	ld	a3,-32(s0)
    80201fa2:	fe843783          	ld	a5,-24(s0)
    80201fa6:	97b6                	add	a5,a5,a3
    80201fa8:	00074703          	lbu	a4,0(a4)
    80201fac:	00e78023          	sb	a4,0(a5)
    for (size_t i = 0; i < n; i++) {
    80201fb0:	fe843783          	ld	a5,-24(s0)
    80201fb4:	0785                	addi	a5,a5,1
    80201fb6:	fef43423          	sd	a5,-24(s0)
    80201fba:	fe843703          	ld	a4,-24(s0)
    80201fbe:	fb843783          	ld	a5,-72(s0)
    80201fc2:	fcf769e3          	bltu	a4,a5,80201f94 <memcpy+0x28>
    }
    return dst;
    80201fc6:	fc843783          	ld	a5,-56(s0)
    80201fca:	853e                	mv	a0,a5
    80201fcc:	6426                	ld	s0,72(sp)
    80201fce:	6161                	addi	sp,sp,80
    80201fd0:	8082                	ret

0000000080201fd2 <assert>:
    80201fd2:	1101                	addi	sp,sp,-32
    80201fd4:	ec06                	sd	ra,24(sp)
    80201fd6:	e822                	sd	s0,16(sp)
    80201fd8:	1000                	addi	s0,sp,32
    80201fda:	87aa                	mv	a5,a0
    80201fdc:	fef42623          	sw	a5,-20(s0)
    80201fe0:	fec42783          	lw	a5,-20(s0)
    80201fe4:	2781                	sext.w	a5,a5
    80201fe6:	e79d                	bnez	a5,80202014 <assert+0x42>
    80201fe8:	1b300613          	li	a2,435
    80201fec:	00010597          	auipc	a1,0x10
    80201ff0:	4ac58593          	addi	a1,a1,1196 # 80212498 <syscall_performance_bin+0x670>
    80201ff4:	00010517          	auipc	a0,0x10
    80201ff8:	4b450513          	addi	a0,a0,1204 # 802124a8 <syscall_performance_bin+0x680>
    80201ffc:	fffff097          	auipc	ra,0xfffff
    80202000:	cda080e7          	jalr	-806(ra) # 80200cd6 <printf>
    80202004:	00010517          	auipc	a0,0x10
    80202008:	4cc50513          	addi	a0,a0,1228 # 802124d0 <syscall_performance_bin+0x6a8>
    8020200c:	fffff097          	auipc	ra,0xfffff
    80202010:	716080e7          	jalr	1814(ra) # 80201722 <panic>
    80202014:	0001                	nop
    80202016:	60e2                	ld	ra,24(sp)
    80202018:	6442                	ld	s0,16(sp)
    8020201a:	6105                	addi	sp,sp,32
    8020201c:	8082                	ret

000000008020201e <sv39_sign_extend>:
    8020201e:	1101                	addi	sp,sp,-32
    80202020:	ec22                	sd	s0,24(sp)
    80202022:	1000                	addi	s0,sp,32
    80202024:	fea43423          	sd	a0,-24(s0)
    80202028:	fe843703          	ld	a4,-24(s0)
    8020202c:	4785                	li	a5,1
    8020202e:	179a                	slli	a5,a5,0x26
    80202030:	8ff9                	and	a5,a5,a4
    80202032:	c799                	beqz	a5,80202040 <sv39_sign_extend+0x22>
    80202034:	fe843703          	ld	a4,-24(s0)
    80202038:	57fd                	li	a5,-1
    8020203a:	179e                	slli	a5,a5,0x27
    8020203c:	8fd9                	or	a5,a5,a4
    8020203e:	a031                	j	8020204a <sv39_sign_extend+0x2c>
    80202040:	fe843703          	ld	a4,-24(s0)
    80202044:	57fd                	li	a5,-1
    80202046:	83e5                	srli	a5,a5,0x19
    80202048:	8ff9                	and	a5,a5,a4
    8020204a:	853e                	mv	a0,a5
    8020204c:	6462                	ld	s0,24(sp)
    8020204e:	6105                	addi	sp,sp,32
    80202050:	8082                	ret

0000000080202052 <sv39_check_valid>:
    80202052:	1101                	addi	sp,sp,-32
    80202054:	ec22                	sd	s0,24(sp)
    80202056:	1000                	addi	s0,sp,32
    80202058:	fea43423          	sd	a0,-24(s0)
    8020205c:	fe843703          	ld	a4,-24(s0)
    80202060:	57fd                	li	a5,-1
    80202062:	83e5                	srli	a5,a5,0x19
    80202064:	00e7f863          	bgeu	a5,a4,80202074 <sv39_check_valid+0x22>
    80202068:	fe843703          	ld	a4,-24(s0)
    8020206c:	57fd                	li	a5,-1
    8020206e:	179e                	slli	a5,a5,0x27
    80202070:	00f76463          	bltu	a4,a5,80202078 <sv39_check_valid+0x26>
    80202074:	4785                	li	a5,1
    80202076:	a011                	j	8020207a <sv39_check_valid+0x28>
    80202078:	4781                	li	a5,0
    8020207a:	853e                	mv	a0,a5
    8020207c:	6462                	ld	s0,24(sp)
    8020207e:	6105                	addi	sp,sp,32
    80202080:	8082                	ret

0000000080202082 <px>:
static inline uint64 px(int level, uint64 va) {
    80202082:	1101                	addi	sp,sp,-32
    80202084:	ec22                	sd	s0,24(sp)
    80202086:	1000                	addi	s0,sp,32
    80202088:	87aa                	mv	a5,a0
    8020208a:	feb43023          	sd	a1,-32(s0)
    8020208e:	fef42623          	sw	a5,-20(s0)
    return VPN_MASK(va, level);
    80202092:	fec42783          	lw	a5,-20(s0)
    80202096:	873e                	mv	a4,a5
    80202098:	87ba                	mv	a5,a4
    8020209a:	0037979b          	slliw	a5,a5,0x3
    8020209e:	9fb9                	addw	a5,a5,a4
    802020a0:	2781                	sext.w	a5,a5
    802020a2:	27b1                	addiw	a5,a5,12
    802020a4:	2781                	sext.w	a5,a5
    802020a6:	873e                	mv	a4,a5
    802020a8:	fe043783          	ld	a5,-32(s0)
    802020ac:	00e7d7b3          	srl	a5,a5,a4
    802020b0:	1ff7f793          	andi	a5,a5,511
}
    802020b4:	853e                	mv	a0,a5
    802020b6:	6462                	ld	s0,24(sp)
    802020b8:	6105                	addi	sp,sp,32
    802020ba:	8082                	ret

00000000802020bc <create_pagetable>:
pagetable_t create_pagetable(void) {
    802020bc:	1101                	addi	sp,sp,-32
    802020be:	ec06                	sd	ra,24(sp)
    802020c0:	e822                	sd	s0,16(sp)
    802020c2:	1000                	addi	s0,sp,32
    pagetable_t pt = (pagetable_t)alloc_page();
    802020c4:	00001097          	auipc	ra,0x1
    802020c8:	1a4080e7          	jalr	420(ra) # 80203268 <alloc_page>
    802020cc:	fea43423          	sd	a0,-24(s0)
    if (!pt)
    802020d0:	fe843783          	ld	a5,-24(s0)
    802020d4:	e399                	bnez	a5,802020da <create_pagetable+0x1e>
        return 0;
    802020d6:	4781                	li	a5,0
    802020d8:	a819                	j	802020ee <create_pagetable+0x32>
    memset(pt, 0, PGSIZE);
    802020da:	6605                	lui	a2,0x1
    802020dc:	4581                	li	a1,0
    802020de:	fe843503          	ld	a0,-24(s0)
    802020e2:	00000097          	auipc	ra,0x0
    802020e6:	d7e080e7          	jalr	-642(ra) # 80201e60 <memset>
    return pt;
    802020ea:	fe843783          	ld	a5,-24(s0)
}
    802020ee:	853e                	mv	a0,a5
    802020f0:	60e2                	ld	ra,24(sp)
    802020f2:	6442                	ld	s0,16(sp)
    802020f4:	6105                	addi	sp,sp,32
    802020f6:	8082                	ret

00000000802020f8 <walk_lookup>:
pte_t* walk_lookup(pagetable_t pt, uint64 va) {
    802020f8:	7139                	addi	sp,sp,-64
    802020fa:	fc06                	sd	ra,56(sp)
    802020fc:	f822                	sd	s0,48(sp)
    802020fe:	0080                	addi	s0,sp,64
    80202100:	fca43423          	sd	a0,-56(s0)
    80202104:	fcb43023          	sd	a1,-64(s0)
	va = sv39_sign_extend(va);
    80202108:	fc043503          	ld	a0,-64(s0)
    8020210c:	00000097          	auipc	ra,0x0
    80202110:	f12080e7          	jalr	-238(ra) # 8020201e <sv39_sign_extend>
    80202114:	fca43023          	sd	a0,-64(s0)
	if (!sv39_check_valid(va))
    80202118:	fc043503          	ld	a0,-64(s0)
    8020211c:	00000097          	auipc	ra,0x0
    80202120:	f36080e7          	jalr	-202(ra) # 80202052 <sv39_check_valid>
    80202124:	87aa                	mv	a5,a0
    80202126:	eb89                	bnez	a5,80202138 <walk_lookup+0x40>
		panic("va out of sv39 range");
    80202128:	00010517          	auipc	a0,0x10
    8020212c:	3b050513          	addi	a0,a0,944 # 802124d8 <syscall_performance_bin+0x6b0>
    80202130:	fffff097          	auipc	ra,0xfffff
    80202134:	5f2080e7          	jalr	1522(ra) # 80201722 <panic>
    for (int level = 2; level > 0; level--) {
    80202138:	4789                	li	a5,2
    8020213a:	fef42623          	sw	a5,-20(s0)
    8020213e:	a0e9                	j	80202208 <walk_lookup+0x110>
        pte_t *pte = &pt[px(level, va)];
    80202140:	fec42783          	lw	a5,-20(s0)
    80202144:	fc043583          	ld	a1,-64(s0)
    80202148:	853e                	mv	a0,a5
    8020214a:	00000097          	auipc	ra,0x0
    8020214e:	f38080e7          	jalr	-200(ra) # 80202082 <px>
    80202152:	87aa                	mv	a5,a0
    80202154:	078e                	slli	a5,a5,0x3
    80202156:	fc843703          	ld	a4,-56(s0)
    8020215a:	97ba                	add	a5,a5,a4
    8020215c:	fef43023          	sd	a5,-32(s0)
        if (!pte) {
    80202160:	fe043783          	ld	a5,-32(s0)
    80202164:	ef91                	bnez	a5,80202180 <walk_lookup+0x88>
            printf("[WALK_LOOKUP] pte is NULL at level %d\n", level);
    80202166:	fec42783          	lw	a5,-20(s0)
    8020216a:	85be                	mv	a1,a5
    8020216c:	00010517          	auipc	a0,0x10
    80202170:	38450513          	addi	a0,a0,900 # 802124f0 <syscall_performance_bin+0x6c8>
    80202174:	fffff097          	auipc	ra,0xfffff
    80202178:	b62080e7          	jalr	-1182(ra) # 80200cd6 <printf>
            return 0;
    8020217c:	4781                	li	a5,0
    8020217e:	a075                	j	8020222a <walk_lookup+0x132>
        if (*pte & PTE_V) {
    80202180:	fe043783          	ld	a5,-32(s0)
    80202184:	639c                	ld	a5,0(a5)
    80202186:	8b85                	andi	a5,a5,1
    80202188:	cfa1                	beqz	a5,802021e0 <walk_lookup+0xe8>
            uint64 pa = PTE2PA(*pte);
    8020218a:	fe043783          	ld	a5,-32(s0)
    8020218e:	639c                	ld	a5,0(a5)
    80202190:	83a9                	srli	a5,a5,0xa
    80202192:	07b2                	slli	a5,a5,0xc
    80202194:	fcf43c23          	sd	a5,-40(s0)
            if (pa < KERNBASE || pa >= PHYSTOP) {
    80202198:	fd843703          	ld	a4,-40(s0)
    8020219c:	800007b7          	lui	a5,0x80000
    802021a0:	fff7c793          	not	a5,a5
    802021a4:	00e7f863          	bgeu	a5,a4,802021b4 <walk_lookup+0xbc>
    802021a8:	fd843703          	ld	a4,-40(s0)
    802021ac:	47c5                	li	a5,17
    802021ae:	07ee                	slli	a5,a5,0x1b
    802021b0:	02f76363          	bltu	a4,a5,802021d6 <walk_lookup+0xde>
                printf("[WALK_LOOKUP] 非法页表物理地址: 0x%lx (level %d, va=0x%lx)\n", pa, level, va);
    802021b4:	fec42783          	lw	a5,-20(s0)
    802021b8:	fc043683          	ld	a3,-64(s0)
    802021bc:	863e                	mv	a2,a5
    802021be:	fd843583          	ld	a1,-40(s0)
    802021c2:	00010517          	auipc	a0,0x10
    802021c6:	35650513          	addi	a0,a0,854 # 80212518 <syscall_performance_bin+0x6f0>
    802021ca:	fffff097          	auipc	ra,0xfffff
    802021ce:	b0c080e7          	jalr	-1268(ra) # 80200cd6 <printf>
                return 0;
    802021d2:	4781                	li	a5,0
    802021d4:	a899                	j	8020222a <walk_lookup+0x132>
            pt = (pagetable_t)pa;
    802021d6:	fd843783          	ld	a5,-40(s0)
    802021da:	fcf43423          	sd	a5,-56(s0)
    802021de:	a005                	j	802021fe <walk_lookup+0x106>
            printf("[WALK_LOOKUP] 页表项无效: level=%d va=0x%lx\n", level, va);
    802021e0:	fec42783          	lw	a5,-20(s0)
    802021e4:	fc043603          	ld	a2,-64(s0)
    802021e8:	85be                	mv	a1,a5
    802021ea:	00010517          	auipc	a0,0x10
    802021ee:	37650513          	addi	a0,a0,886 # 80212560 <syscall_performance_bin+0x738>
    802021f2:	fffff097          	auipc	ra,0xfffff
    802021f6:	ae4080e7          	jalr	-1308(ra) # 80200cd6 <printf>
            return 0;
    802021fa:	4781                	li	a5,0
    802021fc:	a03d                	j	8020222a <walk_lookup+0x132>
    for (int level = 2; level > 0; level--) {
    802021fe:	fec42783          	lw	a5,-20(s0)
    80202202:	37fd                	addiw	a5,a5,-1 # 7fffffff <_entry-0x200001>
    80202204:	fef42623          	sw	a5,-20(s0)
    80202208:	fec42783          	lw	a5,-20(s0)
    8020220c:	2781                	sext.w	a5,a5
    8020220e:	f2f049e3          	bgtz	a5,80202140 <walk_lookup+0x48>
    return &pt[px(0, va)];
    80202212:	fc043583          	ld	a1,-64(s0)
    80202216:	4501                	li	a0,0
    80202218:	00000097          	auipc	ra,0x0
    8020221c:	e6a080e7          	jalr	-406(ra) # 80202082 <px>
    80202220:	87aa                	mv	a5,a0
    80202222:	078e                	slli	a5,a5,0x3
    80202224:	fc843703          	ld	a4,-56(s0)
    80202228:	97ba                	add	a5,a5,a4
}
    8020222a:	853e                	mv	a0,a5
    8020222c:	70e2                	ld	ra,56(sp)
    8020222e:	7442                	ld	s0,48(sp)
    80202230:	6121                	addi	sp,sp,64
    80202232:	8082                	ret

0000000080202234 <walk_create>:
static pte_t* walk_create(pagetable_t pt, uint64 va) {
    80202234:	7139                	addi	sp,sp,-64
    80202236:	fc06                	sd	ra,56(sp)
    80202238:	f822                	sd	s0,48(sp)
    8020223a:	0080                	addi	s0,sp,64
    8020223c:	fca43423          	sd	a0,-56(s0)
    80202240:	fcb43023          	sd	a1,-64(s0)
	va = sv39_sign_extend(va);
    80202244:	fc043503          	ld	a0,-64(s0)
    80202248:	00000097          	auipc	ra,0x0
    8020224c:	dd6080e7          	jalr	-554(ra) # 8020201e <sv39_sign_extend>
    80202250:	fca43023          	sd	a0,-64(s0)
	if (!sv39_check_valid(va))
    80202254:	fc043503          	ld	a0,-64(s0)
    80202258:	00000097          	auipc	ra,0x0
    8020225c:	dfa080e7          	jalr	-518(ra) # 80202052 <sv39_check_valid>
    80202260:	87aa                	mv	a5,a0
    80202262:	eb89                	bnez	a5,80202274 <walk_create+0x40>
		panic("va out of sv39 range");
    80202264:	00010517          	auipc	a0,0x10
    80202268:	27450513          	addi	a0,a0,628 # 802124d8 <syscall_performance_bin+0x6b0>
    8020226c:	fffff097          	auipc	ra,0xfffff
    80202270:	4b6080e7          	jalr	1206(ra) # 80201722 <panic>
    for (int level = 2; level > 0; level--) {
    80202274:	4789                	li	a5,2
    80202276:	fef42623          	sw	a5,-20(s0)
    8020227a:	a059                	j	80202300 <walk_create+0xcc>
        pte_t *pte = &pt[px(level, va)];
    8020227c:	fec42783          	lw	a5,-20(s0)
    80202280:	fc043583          	ld	a1,-64(s0)
    80202284:	853e                	mv	a0,a5
    80202286:	00000097          	auipc	ra,0x0
    8020228a:	dfc080e7          	jalr	-516(ra) # 80202082 <px>
    8020228e:	87aa                	mv	a5,a0
    80202290:	078e                	slli	a5,a5,0x3
    80202292:	fc843703          	ld	a4,-56(s0)
    80202296:	97ba                	add	a5,a5,a4
    80202298:	fef43023          	sd	a5,-32(s0)
        if (*pte & PTE_V) {
    8020229c:	fe043783          	ld	a5,-32(s0)
    802022a0:	639c                	ld	a5,0(a5)
    802022a2:	8b85                	andi	a5,a5,1
    802022a4:	cb89                	beqz	a5,802022b6 <walk_create+0x82>
            pt = (pagetable_t)PTE2PA(*pte);
    802022a6:	fe043783          	ld	a5,-32(s0)
    802022aa:	639c                	ld	a5,0(a5)
    802022ac:	83a9                	srli	a5,a5,0xa
    802022ae:	07b2                	slli	a5,a5,0xc
    802022b0:	fcf43423          	sd	a5,-56(s0)
    802022b4:	a089                	j	802022f6 <walk_create+0xc2>
            pagetable_t new_pt = (pagetable_t)alloc_page();
    802022b6:	00001097          	auipc	ra,0x1
    802022ba:	fb2080e7          	jalr	-78(ra) # 80203268 <alloc_page>
    802022be:	fca43c23          	sd	a0,-40(s0)
            if (!new_pt)
    802022c2:	fd843783          	ld	a5,-40(s0)
    802022c6:	e399                	bnez	a5,802022cc <walk_create+0x98>
                return 0;
    802022c8:	4781                	li	a5,0
    802022ca:	a8a1                	j	80202322 <walk_create+0xee>
            memset(new_pt, 0, PGSIZE);
    802022cc:	6605                	lui	a2,0x1
    802022ce:	4581                	li	a1,0
    802022d0:	fd843503          	ld	a0,-40(s0)
    802022d4:	00000097          	auipc	ra,0x0
    802022d8:	b8c080e7          	jalr	-1140(ra) # 80201e60 <memset>
            *pte = PA2PTE(new_pt) | PTE_V;
    802022dc:	fd843783          	ld	a5,-40(s0)
    802022e0:	83b1                	srli	a5,a5,0xc
    802022e2:	07aa                	slli	a5,a5,0xa
    802022e4:	0017e713          	ori	a4,a5,1
    802022e8:	fe043783          	ld	a5,-32(s0)
    802022ec:	e398                	sd	a4,0(a5)
            pt = new_pt;
    802022ee:	fd843783          	ld	a5,-40(s0)
    802022f2:	fcf43423          	sd	a5,-56(s0)
    for (int level = 2; level > 0; level--) {
    802022f6:	fec42783          	lw	a5,-20(s0)
    802022fa:	37fd                	addiw	a5,a5,-1
    802022fc:	fef42623          	sw	a5,-20(s0)
    80202300:	fec42783          	lw	a5,-20(s0)
    80202304:	2781                	sext.w	a5,a5
    80202306:	f6f04be3          	bgtz	a5,8020227c <walk_create+0x48>
    return &pt[px(0, va)];
    8020230a:	fc043583          	ld	a1,-64(s0)
    8020230e:	4501                	li	a0,0
    80202310:	00000097          	auipc	ra,0x0
    80202314:	d72080e7          	jalr	-654(ra) # 80202082 <px>
    80202318:	87aa                	mv	a5,a0
    8020231a:	078e                	slli	a5,a5,0x3
    8020231c:	fc843703          	ld	a4,-56(s0)
    80202320:	97ba                	add	a5,a5,a4
}
    80202322:	853e                	mv	a0,a5
    80202324:	70e2                	ld	ra,56(sp)
    80202326:	7442                	ld	s0,48(sp)
    80202328:	6121                	addi	sp,sp,64
    8020232a:	8082                	ret

000000008020232c <map_page>:
int map_page(pagetable_t pt, uint64 va, uint64 pa, int perm) {
    8020232c:	715d                	addi	sp,sp,-80
    8020232e:	e486                	sd	ra,72(sp)
    80202330:	e0a2                	sd	s0,64(sp)
    80202332:	0880                	addi	s0,sp,80
    80202334:	fca43423          	sd	a0,-56(s0)
    80202338:	fcb43023          	sd	a1,-64(s0)
    8020233c:	fac43c23          	sd	a2,-72(s0)
    80202340:	87b6                	mv	a5,a3
    80202342:	faf42a23          	sw	a5,-76(s0)
    struct proc *p = myproc();
    80202346:	00003097          	auipc	ra,0x3
    8020234a:	bda080e7          	jalr	-1062(ra) # 80204f20 <myproc>
    8020234e:	fea43023          	sd	a0,-32(s0)
	if (p && p->is_user && va >= 0x80000000
    80202352:	fe043783          	ld	a5,-32(s0)
    80202356:	c7a9                	beqz	a5,802023a0 <map_page+0x74>
    80202358:	fe043783          	ld	a5,-32(s0)
    8020235c:	0a87a783          	lw	a5,168(a5)
    80202360:	c3a1                	beqz	a5,802023a0 <map_page+0x74>
    80202362:	fc043703          	ld	a4,-64(s0)
    80202366:	800007b7          	lui	a5,0x80000
    8020236a:	fff7c793          	not	a5,a5
    8020236e:	02e7f963          	bgeu	a5,a4,802023a0 <map_page+0x74>
		&& va != TRAMPOLINE
    80202372:	fc043703          	ld	a4,-64(s0)
    80202376:	77fd                	lui	a5,0xfffff
    80202378:	02f70463          	beq	a4,a5,802023a0 <map_page+0x74>
		&& va != TRAPFRAME) {
    8020237c:	fc043703          	ld	a4,-64(s0)
    80202380:	77f9                	lui	a5,0xffffe
    80202382:	00f70f63          	beq	a4,a5,802023a0 <map_page+0x74>
		warning("map_page: 用户进程禁止映射内核空间");
    80202386:	00010517          	auipc	a0,0x10
    8020238a:	21250513          	addi	a0,a0,530 # 80212598 <syscall_performance_bin+0x770>
    8020238e:	fffff097          	auipc	ra,0xfffff
    80202392:	3c8080e7          	jalr	968(ra) # 80201756 <warning>
		exit_proc(-1);
    80202396:	557d                	li	a0,-1
    80202398:	00004097          	auipc	ra,0x4
    8020239c:	930080e7          	jalr	-1744(ra) # 80205cc8 <exit_proc>
    if ((va % PGSIZE) != 0)
    802023a0:	fc043703          	ld	a4,-64(s0)
    802023a4:	6785                	lui	a5,0x1
    802023a6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    802023a8:	8ff9                	and	a5,a5,a4
    802023aa:	cb89                	beqz	a5,802023bc <map_page+0x90>
        panic("map_page: va not aligned");
    802023ac:	00010517          	auipc	a0,0x10
    802023b0:	21c50513          	addi	a0,a0,540 # 802125c8 <syscall_performance_bin+0x7a0>
    802023b4:	fffff097          	auipc	ra,0xfffff
    802023b8:	36e080e7          	jalr	878(ra) # 80201722 <panic>
    pte_t *pte = walk_create(pt, va);
    802023bc:	fc043583          	ld	a1,-64(s0)
    802023c0:	fc843503          	ld	a0,-56(s0)
    802023c4:	00000097          	auipc	ra,0x0
    802023c8:	e70080e7          	jalr	-400(ra) # 80202234 <walk_create>
    802023cc:	fca43c23          	sd	a0,-40(s0)
    if (!pte)
    802023d0:	fd843783          	ld	a5,-40(s0)
    802023d4:	e399                	bnez	a5,802023da <map_page+0xae>
        return -1;
    802023d6:	57fd                	li	a5,-1
    802023d8:	a87d                	j	80202496 <map_page+0x16a>
    if (va >= 0x80000000)
    802023da:	fc043703          	ld	a4,-64(s0)
    802023de:	800007b7          	lui	a5,0x80000
    802023e2:	fff7c793          	not	a5,a5
    802023e6:	00e7f763          	bgeu	a5,a4,802023f4 <map_page+0xc8>
        perm &= ~PTE_U;
    802023ea:	fb442783          	lw	a5,-76(s0)
    802023ee:	9bbd                	andi	a5,a5,-17
    802023f0:	faf42a23          	sw	a5,-76(s0)
    if (*pte & PTE_V) {
    802023f4:	fd843783          	ld	a5,-40(s0)
    802023f8:	639c                	ld	a5,0(a5)
    802023fa:	8b85                	andi	a5,a5,1
    802023fc:	cfbd                	beqz	a5,8020247a <map_page+0x14e>
        if (PTE2PA(*pte) == pa) {
    802023fe:	fd843783          	ld	a5,-40(s0)
    80202402:	639c                	ld	a5,0(a5)
    80202404:	83a9                	srli	a5,a5,0xa
    80202406:	07b2                	slli	a5,a5,0xc
    80202408:	fb843703          	ld	a4,-72(s0)
    8020240c:	04f71f63          	bne	a4,a5,8020246a <map_page+0x13e>
            int new_perm = (PTE_FLAGS(*pte) | perm) & 0x3FF;
    80202410:	fd843783          	ld	a5,-40(s0)
    80202414:	639c                	ld	a5,0(a5)
    80202416:	2781                	sext.w	a5,a5
    80202418:	3ff7f793          	andi	a5,a5,1023
    8020241c:	0007871b          	sext.w	a4,a5
    80202420:	fb442783          	lw	a5,-76(s0)
    80202424:	8fd9                	or	a5,a5,a4
    80202426:	2781                	sext.w	a5,a5
    80202428:	2781                	sext.w	a5,a5
    8020242a:	3ff7f793          	andi	a5,a5,1023
    8020242e:	fef42623          	sw	a5,-20(s0)
            if (va >= 0x80000000)
    80202432:	fc043703          	ld	a4,-64(s0)
    80202436:	800007b7          	lui	a5,0x80000
    8020243a:	fff7c793          	not	a5,a5
    8020243e:	00e7f763          	bgeu	a5,a4,8020244c <map_page+0x120>
                new_perm &= ~PTE_U;
    80202442:	fec42783          	lw	a5,-20(s0)
    80202446:	9bbd                	andi	a5,a5,-17
    80202448:	fef42623          	sw	a5,-20(s0)
            *pte = PA2PTE(pa) | new_perm | PTE_V;
    8020244c:	fb843783          	ld	a5,-72(s0)
    80202450:	83b1                	srli	a5,a5,0xc
    80202452:	00a79713          	slli	a4,a5,0xa
    80202456:	fec42783          	lw	a5,-20(s0)
    8020245a:	8fd9                	or	a5,a5,a4
    8020245c:	0017e713          	ori	a4,a5,1
    80202460:	fd843783          	ld	a5,-40(s0)
    80202464:	e398                	sd	a4,0(a5)
            return 0;
    80202466:	4781                	li	a5,0
    80202468:	a03d                	j	80202496 <map_page+0x16a>
            panic("map_page: remap to different physical address");
    8020246a:	00010517          	auipc	a0,0x10
    8020246e:	17e50513          	addi	a0,a0,382 # 802125e8 <syscall_performance_bin+0x7c0>
    80202472:	fffff097          	auipc	ra,0xfffff
    80202476:	2b0080e7          	jalr	688(ra) # 80201722 <panic>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8020247a:	fb843783          	ld	a5,-72(s0)
    8020247e:	83b1                	srli	a5,a5,0xc
    80202480:	00a79713          	slli	a4,a5,0xa
    80202484:	fb442783          	lw	a5,-76(s0)
    80202488:	8fd9                	or	a5,a5,a4
    8020248a:	0017e713          	ori	a4,a5,1
    8020248e:	fd843783          	ld	a5,-40(s0)
    80202492:	e398                	sd	a4,0(a5)
    return 0;
    80202494:	4781                	li	a5,0
}
    80202496:	853e                	mv	a0,a5
    80202498:	60a6                	ld	ra,72(sp)
    8020249a:	6406                	ld	s0,64(sp)
    8020249c:	6161                	addi	sp,sp,80
    8020249e:	8082                	ret

00000000802024a0 <free_pagetable>:
void free_pagetable(pagetable_t pt) {
    802024a0:	7139                	addi	sp,sp,-64
    802024a2:	fc06                	sd	ra,56(sp)
    802024a4:	f822                	sd	s0,48(sp)
    802024a6:	0080                	addi	s0,sp,64
    802024a8:	fca43423          	sd	a0,-56(s0)
    for (int i = 0; i < 512; i++) {
    802024ac:	fe042623          	sw	zero,-20(s0)
    802024b0:	a8a5                	j	80202528 <free_pagetable+0x88>
        pte_t pte = pt[i];
    802024b2:	fec42783          	lw	a5,-20(s0)
    802024b6:	078e                	slli	a5,a5,0x3
    802024b8:	fc843703          	ld	a4,-56(s0)
    802024bc:	97ba                	add	a5,a5,a4
    802024be:	639c                	ld	a5,0(a5)
    802024c0:	fef43023          	sd	a5,-32(s0)
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    802024c4:	fe043783          	ld	a5,-32(s0)
    802024c8:	8b85                	andi	a5,a5,1
    802024ca:	cb95                	beqz	a5,802024fe <free_pagetable+0x5e>
    802024cc:	fe043783          	ld	a5,-32(s0)
    802024d0:	8bb9                	andi	a5,a5,14
    802024d2:	e795                	bnez	a5,802024fe <free_pagetable+0x5e>
            pagetable_t child = (pagetable_t)PTE2PA(pte);
    802024d4:	fe043783          	ld	a5,-32(s0)
    802024d8:	83a9                	srli	a5,a5,0xa
    802024da:	07b2                	slli	a5,a5,0xc
    802024dc:	fcf43c23          	sd	a5,-40(s0)
            free_pagetable(child);
    802024e0:	fd843503          	ld	a0,-40(s0)
    802024e4:	00000097          	auipc	ra,0x0
    802024e8:	fbc080e7          	jalr	-68(ra) # 802024a0 <free_pagetable>
            pt[i] = 0;
    802024ec:	fec42783          	lw	a5,-20(s0)
    802024f0:	078e                	slli	a5,a5,0x3
    802024f2:	fc843703          	ld	a4,-56(s0)
    802024f6:	97ba                	add	a5,a5,a4
    802024f8:	0007b023          	sd	zero,0(a5) # ffffffff80000000 <_bss_end+0xfffffffeffdd9860>
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    802024fc:	a00d                	j	8020251e <free_pagetable+0x7e>
        } else if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X))) {
    802024fe:	fe043783          	ld	a5,-32(s0)
    80202502:	8b85                	andi	a5,a5,1
    80202504:	cf89                	beqz	a5,8020251e <free_pagetable+0x7e>
    80202506:	fe043783          	ld	a5,-32(s0)
    8020250a:	8bb9                	andi	a5,a5,14
    8020250c:	cb89                	beqz	a5,8020251e <free_pagetable+0x7e>
            pt[i] = 0;
    8020250e:	fec42783          	lw	a5,-20(s0)
    80202512:	078e                	slli	a5,a5,0x3
    80202514:	fc843703          	ld	a4,-56(s0)
    80202518:	97ba                	add	a5,a5,a4
    8020251a:	0007b023          	sd	zero,0(a5)
    for (int i = 0; i < 512; i++) {
    8020251e:	fec42783          	lw	a5,-20(s0)
    80202522:	2785                	addiw	a5,a5,1
    80202524:	fef42623          	sw	a5,-20(s0)
    80202528:	fec42783          	lw	a5,-20(s0)
    8020252c:	0007871b          	sext.w	a4,a5
    80202530:	1ff00793          	li	a5,511
    80202534:	f6e7dfe3          	bge	a5,a4,802024b2 <free_pagetable+0x12>
    free_page(pt);
    80202538:	fc843503          	ld	a0,-56(s0)
    8020253c:	00001097          	auipc	ra,0x1
    80202540:	d98080e7          	jalr	-616(ra) # 802032d4 <free_page>
}
    80202544:	0001                	nop
    80202546:	70e2                	ld	ra,56(sp)
    80202548:	7442                	ld	s0,48(sp)
    8020254a:	6121                	addi	sp,sp,64
    8020254c:	8082                	ret

000000008020254e <kvmmake>:
static pagetable_t kvmmake(void) {
    8020254e:	715d                	addi	sp,sp,-80
    80202550:	e486                	sd	ra,72(sp)
    80202552:	e0a2                	sd	s0,64(sp)
    80202554:	0880                	addi	s0,sp,80
    pagetable_t kpgtbl = create_pagetable();
    80202556:	00000097          	auipc	ra,0x0
    8020255a:	b66080e7          	jalr	-1178(ra) # 802020bc <create_pagetable>
    8020255e:	fca43423          	sd	a0,-56(s0)
    if (!kpgtbl){
    80202562:	fc843783          	ld	a5,-56(s0)
    80202566:	eb89                	bnez	a5,80202578 <kvmmake+0x2a>
        panic("kvmmake: alloc failed");
    80202568:	00010517          	auipc	a0,0x10
    8020256c:	0b050513          	addi	a0,a0,176 # 80212618 <syscall_performance_bin+0x7f0>
    80202570:	fffff097          	auipc	ra,0xfffff
    80202574:	1b2080e7          	jalr	434(ra) # 80201722 <panic>
	for (uint64 pa = KERNBASE; pa < PHYSTOP; pa += PGSIZE) {
    80202578:	4785                	li	a5,1
    8020257a:	07fe                	slli	a5,a5,0x1f
    8020257c:	fef43423          	sd	a5,-24(s0)
    80202580:	a8a1                	j	802025d8 <kvmmake+0x8a>
        int perm = PTE_R | PTE_W;
    80202582:	4799                	li	a5,6
    80202584:	fef42223          	sw	a5,-28(s0)
        if (pa < (uint64)etext)
    80202588:	00006797          	auipc	a5,0x6
    8020258c:	a7878793          	addi	a5,a5,-1416 # 80208000 <etext>
    80202590:	fe843703          	ld	a4,-24(s0)
    80202594:	00f77563          	bgeu	a4,a5,8020259e <kvmmake+0x50>
            perm = PTE_R | PTE_X;
    80202598:	47a9                	li	a5,10
    8020259a:	fef42223          	sw	a5,-28(s0)
        if (map_page(kpgtbl, pa, pa, perm) != 0)
    8020259e:	fe442783          	lw	a5,-28(s0)
    802025a2:	86be                	mv	a3,a5
    802025a4:	fe843603          	ld	a2,-24(s0)
    802025a8:	fe843583          	ld	a1,-24(s0)
    802025ac:	fc843503          	ld	a0,-56(s0)
    802025b0:	00000097          	auipc	ra,0x0
    802025b4:	d7c080e7          	jalr	-644(ra) # 8020232c <map_page>
    802025b8:	87aa                	mv	a5,a0
    802025ba:	cb89                	beqz	a5,802025cc <kvmmake+0x7e>
            panic("kvmmake: heap map failed");
    802025bc:	00010517          	auipc	a0,0x10
    802025c0:	07450513          	addi	a0,a0,116 # 80212630 <syscall_performance_bin+0x808>
    802025c4:	fffff097          	auipc	ra,0xfffff
    802025c8:	15e080e7          	jalr	350(ra) # 80201722 <panic>
	for (uint64 pa = KERNBASE; pa < PHYSTOP; pa += PGSIZE) {
    802025cc:	fe843703          	ld	a4,-24(s0)
    802025d0:	6785                	lui	a5,0x1
    802025d2:	97ba                	add	a5,a5,a4
    802025d4:	fef43423          	sd	a5,-24(s0)
    802025d8:	fe843703          	ld	a4,-24(s0)
    802025dc:	47c5                	li	a5,17
    802025de:	07ee                	slli	a5,a5,0x1b
    802025e0:	faf761e3          	bltu	a4,a5,80202582 <kvmmake+0x34>
    if (map_page(kpgtbl, UART0, UART0, PTE_R | PTE_W) != 0)
    802025e4:	4699                	li	a3,6
    802025e6:	10000637          	lui	a2,0x10000
    802025ea:	100005b7          	lui	a1,0x10000
    802025ee:	fc843503          	ld	a0,-56(s0)
    802025f2:	00000097          	auipc	ra,0x0
    802025f6:	d3a080e7          	jalr	-710(ra) # 8020232c <map_page>
    802025fa:	87aa                	mv	a5,a0
    802025fc:	cb89                	beqz	a5,8020260e <kvmmake+0xc0>
        panic("kvmmake: uart map failed");
    802025fe:	00010517          	auipc	a0,0x10
    80202602:	05250513          	addi	a0,a0,82 # 80212650 <syscall_performance_bin+0x828>
    80202606:	fffff097          	auipc	ra,0xfffff
    8020260a:	11c080e7          	jalr	284(ra) # 80201722 <panic>
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    8020260e:	0c0007b7          	lui	a5,0xc000
    80202612:	fcf43c23          	sd	a5,-40(s0)
    80202616:	a825                	j	8020264e <kvmmake+0x100>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80202618:	4699                	li	a3,6
    8020261a:	fd843603          	ld	a2,-40(s0)
    8020261e:	fd843583          	ld	a1,-40(s0)
    80202622:	fc843503          	ld	a0,-56(s0)
    80202626:	00000097          	auipc	ra,0x0
    8020262a:	d06080e7          	jalr	-762(ra) # 8020232c <map_page>
    8020262e:	87aa                	mv	a5,a0
    80202630:	cb89                	beqz	a5,80202642 <kvmmake+0xf4>
            panic("kvmmake: plic map failed");
    80202632:	00010517          	auipc	a0,0x10
    80202636:	03e50513          	addi	a0,a0,62 # 80212670 <syscall_performance_bin+0x848>
    8020263a:	fffff097          	auipc	ra,0xfffff
    8020263e:	0e8080e7          	jalr	232(ra) # 80201722 <panic>
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    80202642:	fd843703          	ld	a4,-40(s0)
    80202646:	6785                	lui	a5,0x1
    80202648:	97ba                	add	a5,a5,a4
    8020264a:	fcf43c23          	sd	a5,-40(s0)
    8020264e:	fd843703          	ld	a4,-40(s0)
    80202652:	0c4007b7          	lui	a5,0xc400
    80202656:	fcf761e3          	bltu	a4,a5,80202618 <kvmmake+0xca>
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    8020265a:	020007b7          	lui	a5,0x2000
    8020265e:	fcf43823          	sd	a5,-48(s0)
    80202662:	a825                	j	8020269a <kvmmake+0x14c>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80202664:	4699                	li	a3,6
    80202666:	fd043603          	ld	a2,-48(s0)
    8020266a:	fd043583          	ld	a1,-48(s0)
    8020266e:	fc843503          	ld	a0,-56(s0)
    80202672:	00000097          	auipc	ra,0x0
    80202676:	cba080e7          	jalr	-838(ra) # 8020232c <map_page>
    8020267a:	87aa                	mv	a5,a0
    8020267c:	cb89                	beqz	a5,8020268e <kvmmake+0x140>
            panic("kvmmake: clint map failed");
    8020267e:	00010517          	auipc	a0,0x10
    80202682:	01250513          	addi	a0,a0,18 # 80212690 <syscall_performance_bin+0x868>
    80202686:	fffff097          	auipc	ra,0xfffff
    8020268a:	09c080e7          	jalr	156(ra) # 80201722 <panic>
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    8020268e:	fd043703          	ld	a4,-48(s0)
    80202692:	6785                	lui	a5,0x1
    80202694:	97ba                	add	a5,a5,a4
    80202696:	fcf43823          	sd	a5,-48(s0)
    8020269a:	fd043703          	ld	a4,-48(s0)
    8020269e:	020107b7          	lui	a5,0x2010
    802026a2:	fcf761e3          	bltu	a4,a5,80202664 <kvmmake+0x116>
    if (map_page(kpgtbl, VIRTIO0, VIRTIO0, PTE_R | PTE_W) != 0)
    802026a6:	4699                	li	a3,6
    802026a8:	10001637          	lui	a2,0x10001
    802026ac:	100015b7          	lui	a1,0x10001
    802026b0:	fc843503          	ld	a0,-56(s0)
    802026b4:	00000097          	auipc	ra,0x0
    802026b8:	c78080e7          	jalr	-904(ra) # 8020232c <map_page>
    802026bc:	87aa                	mv	a5,a0
    802026be:	cb89                	beqz	a5,802026d0 <kvmmake+0x182>
        panic("kvmmake: virtio map failed");
    802026c0:	00010517          	auipc	a0,0x10
    802026c4:	ff050513          	addi	a0,a0,-16 # 802126b0 <syscall_performance_bin+0x888>
    802026c8:	fffff097          	auipc	ra,0xfffff
    802026cc:	05a080e7          	jalr	90(ra) # 80201722 <panic>
	void *tramp_phys = alloc_page();
    802026d0:	00001097          	auipc	ra,0x1
    802026d4:	b98080e7          	jalr	-1128(ra) # 80203268 <alloc_page>
    802026d8:	fca43023          	sd	a0,-64(s0)
	if (!tramp_phys)
    802026dc:	fc043783          	ld	a5,-64(s0)
    802026e0:	eb89                	bnez	a5,802026f2 <kvmmake+0x1a4>
		panic("kvmmake: alloc trampoline page failed");
    802026e2:	00010517          	auipc	a0,0x10
    802026e6:	fee50513          	addi	a0,a0,-18 # 802126d0 <syscall_performance_bin+0x8a8>
    802026ea:	fffff097          	auipc	ra,0xfffff
    802026ee:	038080e7          	jalr	56(ra) # 80201722 <panic>
	memcpy(tramp_phys, trampoline, PGSIZE);
    802026f2:	6605                	lui	a2,0x1
    802026f4:	00002597          	auipc	a1,0x2
    802026f8:	58c58593          	addi	a1,a1,1420 # 80204c80 <trampoline>
    802026fc:	fc043503          	ld	a0,-64(s0)
    80202700:	00000097          	auipc	ra,0x0
    80202704:	86c080e7          	jalr	-1940(ra) # 80201f6c <memcpy>
	void *trapframe_phys = alloc_page();
    80202708:	00001097          	auipc	ra,0x1
    8020270c:	b60080e7          	jalr	-1184(ra) # 80203268 <alloc_page>
    80202710:	faa43c23          	sd	a0,-72(s0)
	if (!trapframe_phys)
    80202714:	fb843783          	ld	a5,-72(s0)
    80202718:	eb89                	bnez	a5,8020272a <kvmmake+0x1dc>
		panic("kvmmake: alloc trapframe page failed");
    8020271a:	00010517          	auipc	a0,0x10
    8020271e:	fde50513          	addi	a0,a0,-34 # 802126f8 <syscall_performance_bin+0x8d0>
    80202722:	fffff097          	auipc	ra,0xfffff
    80202726:	000080e7          	jalr	ra # 80201722 <panic>
	memset(trapframe_phys, 0, PGSIZE);
    8020272a:	6605                	lui	a2,0x1
    8020272c:	4581                	li	a1,0
    8020272e:	fb843503          	ld	a0,-72(s0)
    80202732:	fffff097          	auipc	ra,0xfffff
    80202736:	72e080e7          	jalr	1838(ra) # 80201e60 <memset>
	if (map_page(kpgtbl, TRAMPOLINE, (uint64)tramp_phys, PTE_R | PTE_X) != 0){
    8020273a:	fc043783          	ld	a5,-64(s0)
    8020273e:	46a9                	li	a3,10
    80202740:	863e                	mv	a2,a5
    80202742:	75fd                	lui	a1,0xfffff
    80202744:	fc843503          	ld	a0,-56(s0)
    80202748:	00000097          	auipc	ra,0x0
    8020274c:	be4080e7          	jalr	-1052(ra) # 8020232c <map_page>
    80202750:	87aa                	mv	a5,a0
    80202752:	cb89                	beqz	a5,80202764 <kvmmake+0x216>
		panic("kvmmake: trampoline map failed");
    80202754:	00010517          	auipc	a0,0x10
    80202758:	fcc50513          	addi	a0,a0,-52 # 80212720 <syscall_performance_bin+0x8f8>
    8020275c:	fffff097          	auipc	ra,0xfffff
    80202760:	fc6080e7          	jalr	-58(ra) # 80201722 <panic>
	if (map_page(kpgtbl, TRAPFRAME, (uint64)trapframe_phys, PTE_R | PTE_W) != 0){
    80202764:	fb843783          	ld	a5,-72(s0)
    80202768:	4699                	li	a3,6
    8020276a:	863e                	mv	a2,a5
    8020276c:	75f9                	lui	a1,0xffffe
    8020276e:	fc843503          	ld	a0,-56(s0)
    80202772:	00000097          	auipc	ra,0x0
    80202776:	bba080e7          	jalr	-1094(ra) # 8020232c <map_page>
    8020277a:	87aa                	mv	a5,a0
    8020277c:	cb89                	beqz	a5,8020278e <kvmmake+0x240>
		panic("kvmmake: trapframe map failed");
    8020277e:	00010517          	auipc	a0,0x10
    80202782:	fc250513          	addi	a0,a0,-62 # 80212740 <syscall_performance_bin+0x918>
    80202786:	fffff097          	auipc	ra,0xfffff
    8020278a:	f9c080e7          	jalr	-100(ra) # 80201722 <panic>
	trampoline_phys_addr = (uint64)tramp_phys;
    8020278e:	fc043703          	ld	a4,-64(s0)
    80202792:	00024797          	auipc	a5,0x24
    80202796:	9b678793          	addi	a5,a5,-1610 # 80226148 <trampoline_phys_addr>
    8020279a:	e398                	sd	a4,0(a5)
	trapframe_phys_addr = (uint64)trapframe_phys;
    8020279c:	fb843703          	ld	a4,-72(s0)
    802027a0:	00024797          	auipc	a5,0x24
    802027a4:	9b078793          	addi	a5,a5,-1616 # 80226150 <trapframe_phys_addr>
    802027a8:	e398                	sd	a4,0(a5)
	printf("trampoline_phy_addr = %lx\n",trampoline_phys_addr);
    802027aa:	00024797          	auipc	a5,0x24
    802027ae:	99e78793          	addi	a5,a5,-1634 # 80226148 <trampoline_phys_addr>
    802027b2:	639c                	ld	a5,0(a5)
    802027b4:	85be                	mv	a1,a5
    802027b6:	00010517          	auipc	a0,0x10
    802027ba:	faa50513          	addi	a0,a0,-86 # 80212760 <syscall_performance_bin+0x938>
    802027be:	ffffe097          	auipc	ra,0xffffe
    802027c2:	518080e7          	jalr	1304(ra) # 80200cd6 <printf>
	printf("trapframe_phys_addr = %lx\n",trapframe_phys_addr);
    802027c6:	00024797          	auipc	a5,0x24
    802027ca:	98a78793          	addi	a5,a5,-1654 # 80226150 <trapframe_phys_addr>
    802027ce:	639c                	ld	a5,0(a5)
    802027d0:	85be                	mv	a1,a5
    802027d2:	00010517          	auipc	a0,0x10
    802027d6:	fae50513          	addi	a0,a0,-82 # 80212780 <syscall_performance_bin+0x958>
    802027da:	ffffe097          	auipc	ra,0xffffe
    802027de:	4fc080e7          	jalr	1276(ra) # 80200cd6 <printf>
    return kpgtbl;
    802027e2:	fc843783          	ld	a5,-56(s0)
}
    802027e6:	853e                	mv	a0,a5
    802027e8:	60a6                	ld	ra,72(sp)
    802027ea:	6406                	ld	s0,64(sp)
    802027ec:	6161                	addi	sp,sp,80
    802027ee:	8082                	ret

00000000802027f0 <w_satp>:
static inline void w_satp(uint64 x) {
    802027f0:	1101                	addi	sp,sp,-32
    802027f2:	ec22                	sd	s0,24(sp)
    802027f4:	1000                	addi	s0,sp,32
    802027f6:	fea43423          	sd	a0,-24(s0)
    asm volatile("csrw satp, %0" : : "r"(x));
    802027fa:	fe843783          	ld	a5,-24(s0)
    802027fe:	18079073          	csrw	satp,a5
}
    80202802:	0001                	nop
    80202804:	6462                	ld	s0,24(sp)
    80202806:	6105                	addi	sp,sp,32
    80202808:	8082                	ret

000000008020280a <sfence_vma>:
inline void sfence_vma(void) {
    8020280a:	1141                	addi	sp,sp,-16
    8020280c:	e422                	sd	s0,8(sp)
    8020280e:	0800                	addi	s0,sp,16
    asm volatile("sfence.vma zero, zero");
    80202810:	12000073          	sfence.vma
}
    80202814:	0001                	nop
    80202816:	6422                	ld	s0,8(sp)
    80202818:	0141                	addi	sp,sp,16
    8020281a:	8082                	ret

000000008020281c <kvminit>:
void kvminit(void) {
    8020281c:	1141                	addi	sp,sp,-16
    8020281e:	e406                	sd	ra,8(sp)
    80202820:	e022                	sd	s0,0(sp)
    80202822:	0800                	addi	s0,sp,16
    kernel_pagetable = kvmmake();
    80202824:	00000097          	auipc	ra,0x0
    80202828:	d2a080e7          	jalr	-726(ra) # 8020254e <kvmmake>
    8020282c:	872a                	mv	a4,a0
    8020282e:	00024797          	auipc	a5,0x24
    80202832:	91278793          	addi	a5,a5,-1774 # 80226140 <kernel_pagetable>
    80202836:	e398                	sd	a4,0(a5)
    sfence_vma();
    80202838:	00000097          	auipc	ra,0x0
    8020283c:	fd2080e7          	jalr	-46(ra) # 8020280a <sfence_vma>
    w_satp(MAKE_SATP(kernel_pagetable));
    80202840:	00024797          	auipc	a5,0x24
    80202844:	90078793          	addi	a5,a5,-1792 # 80226140 <kernel_pagetable>
    80202848:	639c                	ld	a5,0(a5)
    8020284a:	00c7d713          	srli	a4,a5,0xc
    8020284e:	57fd                	li	a5,-1
    80202850:	17fe                	slli	a5,a5,0x3f
    80202852:	8fd9                	or	a5,a5,a4
    80202854:	853e                	mv	a0,a5
    80202856:	00000097          	auipc	ra,0x0
    8020285a:	f9a080e7          	jalr	-102(ra) # 802027f0 <w_satp>
    sfence_vma();
    8020285e:	00000097          	auipc	ra,0x0
    80202862:	fac080e7          	jalr	-84(ra) # 8020280a <sfence_vma>
    printf("[KVM] 内核分页已启用，satp=0x%lx\n", MAKE_SATP(kernel_pagetable));
    80202866:	00024797          	auipc	a5,0x24
    8020286a:	8da78793          	addi	a5,a5,-1830 # 80226140 <kernel_pagetable>
    8020286e:	639c                	ld	a5,0(a5)
    80202870:	00c7d713          	srli	a4,a5,0xc
    80202874:	57fd                	li	a5,-1
    80202876:	17fe                	slli	a5,a5,0x3f
    80202878:	8fd9                	or	a5,a5,a4
    8020287a:	85be                	mv	a1,a5
    8020287c:	00010517          	auipc	a0,0x10
    80202880:	f2450513          	addi	a0,a0,-220 # 802127a0 <syscall_performance_bin+0x978>
    80202884:	ffffe097          	auipc	ra,0xffffe
    80202888:	452080e7          	jalr	1106(ra) # 80200cd6 <printf>
}
    8020288c:	0001                	nop
    8020288e:	60a2                	ld	ra,8(sp)
    80202890:	6402                	ld	s0,0(sp)
    80202892:	0141                	addi	sp,sp,16
    80202894:	8082                	ret

0000000080202896 <get_current_pagetable>:
pagetable_t get_current_pagetable(void) {
    80202896:	1141                	addi	sp,sp,-16
    80202898:	e422                	sd	s0,8(sp)
    8020289a:	0800                	addi	s0,sp,16
    return kernel_pagetable;  // 在没有进程时返回内核页表
    8020289c:	00024797          	auipc	a5,0x24
    802028a0:	8a478793          	addi	a5,a5,-1884 # 80226140 <kernel_pagetable>
    802028a4:	639c                	ld	a5,0(a5)
}
    802028a6:	853e                	mv	a0,a5
    802028a8:	6422                	ld	s0,8(sp)
    802028aa:	0141                	addi	sp,sp,16
    802028ac:	8082                	ret

00000000802028ae <print_pagetable>:
void print_pagetable(pagetable_t pagetable, int level, uint64 va_base) {
    802028ae:	715d                	addi	sp,sp,-80
    802028b0:	e486                	sd	ra,72(sp)
    802028b2:	e0a2                	sd	s0,64(sp)
    802028b4:	0880                	addi	s0,sp,80
    802028b6:	fca43423          	sd	a0,-56(s0)
    802028ba:	87ae                	mv	a5,a1
    802028bc:	fac43c23          	sd	a2,-72(s0)
    802028c0:	fcf42223          	sw	a5,-60(s0)
    for (int i = 0; i < 512; i++) {
    802028c4:	fe042623          	sw	zero,-20(s0)
    802028c8:	a0c5                	j	802029a8 <print_pagetable+0xfa>
        pte_t pte = pagetable[i];
    802028ca:	fec42783          	lw	a5,-20(s0)
    802028ce:	078e                	slli	a5,a5,0x3
    802028d0:	fc843703          	ld	a4,-56(s0)
    802028d4:	97ba                	add	a5,a5,a4
    802028d6:	639c                	ld	a5,0(a5)
    802028d8:	fef43023          	sd	a5,-32(s0)
        if (pte & PTE_V) {
    802028dc:	fe043783          	ld	a5,-32(s0)
    802028e0:	8b85                	andi	a5,a5,1
    802028e2:	cfd5                	beqz	a5,8020299e <print_pagetable+0xf0>
            uint64 pa = PTE2PA(pte);
    802028e4:	fe043783          	ld	a5,-32(s0)
    802028e8:	83a9                	srli	a5,a5,0xa
    802028ea:	07b2                	slli	a5,a5,0xc
    802028ec:	fcf43c23          	sd	a5,-40(s0)
            uint64 va = va_base + (i << (12 + 9 * (2 - level)));
    802028f0:	4789                	li	a5,2
    802028f2:	fc442703          	lw	a4,-60(s0)
    802028f6:	9f99                	subw	a5,a5,a4
    802028f8:	2781                	sext.w	a5,a5
    802028fa:	873e                	mv	a4,a5
    802028fc:	87ba                	mv	a5,a4
    802028fe:	0037979b          	slliw	a5,a5,0x3
    80202902:	9fb9                	addw	a5,a5,a4
    80202904:	2781                	sext.w	a5,a5
    80202906:	27b1                	addiw	a5,a5,12
    80202908:	2781                	sext.w	a5,a5
    8020290a:	fec42703          	lw	a4,-20(s0)
    8020290e:	00f717bb          	sllw	a5,a4,a5
    80202912:	2781                	sext.w	a5,a5
    80202914:	873e                	mv	a4,a5
    80202916:	fb843783          	ld	a5,-72(s0)
    8020291a:	97ba                	add	a5,a5,a4
    8020291c:	fcf43823          	sd	a5,-48(s0)
            for (int l = 0; l < level; l++) printf("  "); // 缩进
    80202920:	fe042423          	sw	zero,-24(s0)
    80202924:	a831                	j	80202940 <print_pagetable+0x92>
    80202926:	00010517          	auipc	a0,0x10
    8020292a:	eaa50513          	addi	a0,a0,-342 # 802127d0 <syscall_performance_bin+0x9a8>
    8020292e:	ffffe097          	auipc	ra,0xffffe
    80202932:	3a8080e7          	jalr	936(ra) # 80200cd6 <printf>
    80202936:	fe842783          	lw	a5,-24(s0)
    8020293a:	2785                	addiw	a5,a5,1
    8020293c:	fef42423          	sw	a5,-24(s0)
    80202940:	fe842783          	lw	a5,-24(s0)
    80202944:	873e                	mv	a4,a5
    80202946:	fc442783          	lw	a5,-60(s0)
    8020294a:	2701                	sext.w	a4,a4
    8020294c:	2781                	sext.w	a5,a5
    8020294e:	fcf74ce3          	blt	a4,a5,80202926 <print_pagetable+0x78>
            printf("L%d[%3d] VA:0x%lx -> PA:0x%lx flags:0x%lx\n", level, i, va, pa, pte & 0x3FF);
    80202952:	fe043783          	ld	a5,-32(s0)
    80202956:	3ff7f793          	andi	a5,a5,1023
    8020295a:	fec42603          	lw	a2,-20(s0)
    8020295e:	fc442583          	lw	a1,-60(s0)
    80202962:	fd843703          	ld	a4,-40(s0)
    80202966:	fd043683          	ld	a3,-48(s0)
    8020296a:	00010517          	auipc	a0,0x10
    8020296e:	e6e50513          	addi	a0,a0,-402 # 802127d8 <syscall_performance_bin+0x9b0>
    80202972:	ffffe097          	auipc	ra,0xffffe
    80202976:	364080e7          	jalr	868(ra) # 80200cd6 <printf>
            if ((pte & (PTE_R | PTE_W | PTE_X)) == 0) { // 不是叶子
    8020297a:	fe043783          	ld	a5,-32(s0)
    8020297e:	8bb9                	andi	a5,a5,14
    80202980:	ef99                	bnez	a5,8020299e <print_pagetable+0xf0>
                print_pagetable((pagetable_t)pa, level + 1, va);
    80202982:	fd843783          	ld	a5,-40(s0)
    80202986:	fc442703          	lw	a4,-60(s0)
    8020298a:	2705                	addiw	a4,a4,1
    8020298c:	2701                	sext.w	a4,a4
    8020298e:	fd043603          	ld	a2,-48(s0)
    80202992:	85ba                	mv	a1,a4
    80202994:	853e                	mv	a0,a5
    80202996:	00000097          	auipc	ra,0x0
    8020299a:	f18080e7          	jalr	-232(ra) # 802028ae <print_pagetable>
    for (int i = 0; i < 512; i++) {
    8020299e:	fec42783          	lw	a5,-20(s0)
    802029a2:	2785                	addiw	a5,a5,1
    802029a4:	fef42623          	sw	a5,-20(s0)
    802029a8:	fec42783          	lw	a5,-20(s0)
    802029ac:	0007871b          	sext.w	a4,a5
    802029b0:	1ff00793          	li	a5,511
    802029b4:	f0e7dbe3          	bge	a5,a4,802028ca <print_pagetable+0x1c>
}
    802029b8:	0001                	nop
    802029ba:	0001                	nop
    802029bc:	60a6                	ld	ra,72(sp)
    802029be:	6406                	ld	s0,64(sp)
    802029c0:	6161                	addi	sp,sp,80
    802029c2:	8082                	ret

00000000802029c4 <handle_page_fault>:
int handle_page_fault(uint64 va, int type) {
    802029c4:	715d                	addi	sp,sp,-80
    802029c6:	e486                	sd	ra,72(sp)
    802029c8:	e0a2                	sd	s0,64(sp)
    802029ca:	0880                	addi	s0,sp,80
    802029cc:	faa43c23          	sd	a0,-72(s0)
    802029d0:	87ae                	mv	a5,a1
    802029d2:	faf42a23          	sw	a5,-76(s0)
    printf("[PAGE FAULT] 处理地址 0x%lx, 类型 %d\n", va, type);
    802029d6:	fb442783          	lw	a5,-76(s0)
    802029da:	863e                	mv	a2,a5
    802029dc:	fb843583          	ld	a1,-72(s0)
    802029e0:	00010517          	auipc	a0,0x10
    802029e4:	e2850513          	addi	a0,a0,-472 # 80212808 <syscall_performance_bin+0x9e0>
    802029e8:	ffffe097          	auipc	ra,0xffffe
    802029ec:	2ee080e7          	jalr	750(ra) # 80200cd6 <printf>
    uint64 page_va = (va / PGSIZE) * PGSIZE;
    802029f0:	fb843703          	ld	a4,-72(s0)
    802029f4:	77fd                	lui	a5,0xfffff
    802029f6:	8ff9                	and	a5,a5,a4
    802029f8:	fcf43c23          	sd	a5,-40(s0)
    if (page_va >= MAXVA) {
    802029fc:	fd843703          	ld	a4,-40(s0)
    80202a00:	57fd                	li	a5,-1
    80202a02:	83e5                	srli	a5,a5,0x19
    80202a04:	00e7fc63          	bgeu	a5,a4,80202a1c <handle_page_fault+0x58>
        printf("[PAGE FAULT] 虚拟地址超出范围\n");
    80202a08:	00010517          	auipc	a0,0x10
    80202a0c:	e3050513          	addi	a0,a0,-464 # 80212838 <syscall_performance_bin+0xa10>
    80202a10:	ffffe097          	auipc	ra,0xffffe
    80202a14:	2c6080e7          	jalr	710(ra) # 80200cd6 <printf>
        return 0;
    80202a18:	4781                	li	a5,0
    80202a1a:	aae9                	j	80202bf4 <handle_page_fault+0x230>
    struct proc *p = myproc();
    80202a1c:	00002097          	auipc	ra,0x2
    80202a20:	504080e7          	jalr	1284(ra) # 80204f20 <myproc>
    80202a24:	fca43823          	sd	a0,-48(s0)
    pagetable_t pt = kernel_pagetable;
    80202a28:	00023797          	auipc	a5,0x23
    80202a2c:	71878793          	addi	a5,a5,1816 # 80226140 <kernel_pagetable>
    80202a30:	639c                	ld	a5,0(a5)
    80202a32:	fef43423          	sd	a5,-24(s0)
    if (p && p->pagetable && p->is_user) {
    80202a36:	fd043783          	ld	a5,-48(s0)
    80202a3a:	cf99                	beqz	a5,80202a58 <handle_page_fault+0x94>
    80202a3c:	fd043783          	ld	a5,-48(s0)
    80202a40:	7fdc                	ld	a5,184(a5)
    80202a42:	cb99                	beqz	a5,80202a58 <handle_page_fault+0x94>
    80202a44:	fd043783          	ld	a5,-48(s0)
    80202a48:	0a87a783          	lw	a5,168(a5)
    80202a4c:	c791                	beqz	a5,80202a58 <handle_page_fault+0x94>
        pt = p->pagetable;
    80202a4e:	fd043783          	ld	a5,-48(s0)
    80202a52:	7fdc                	ld	a5,184(a5)
    80202a54:	fef43423          	sd	a5,-24(s0)
    pte_t *pte = walk_lookup(pt, page_va);
    80202a58:	fd843583          	ld	a1,-40(s0)
    80202a5c:	fe843503          	ld	a0,-24(s0)
    80202a60:	fffff097          	auipc	ra,0xfffff
    80202a64:	698080e7          	jalr	1688(ra) # 802020f8 <walk_lookup>
    80202a68:	fca43423          	sd	a0,-56(s0)
    if (pte && (*pte & PTE_V)) {
    80202a6c:	fc843783          	ld	a5,-56(s0)
    80202a70:	c3dd                	beqz	a5,80202b16 <handle_page_fault+0x152>
    80202a72:	fc843783          	ld	a5,-56(s0)
    80202a76:	639c                	ld	a5,0(a5)
    80202a78:	8b85                	andi	a5,a5,1
    80202a7a:	cfd1                	beqz	a5,80202b16 <handle_page_fault+0x152>
        int need_perm = 0;
    80202a7c:	fe042223          	sw	zero,-28(s0)
        if (type == 1) need_perm = PTE_X;
    80202a80:	fb442783          	lw	a5,-76(s0)
    80202a84:	0007871b          	sext.w	a4,a5
    80202a88:	4785                	li	a5,1
    80202a8a:	00f71663          	bne	a4,a5,80202a96 <handle_page_fault+0xd2>
    80202a8e:	47a1                	li	a5,8
    80202a90:	fef42223          	sw	a5,-28(s0)
    80202a94:	a035                	j	80202ac0 <handle_page_fault+0xfc>
        else if (type == 2) need_perm = PTE_R;
    80202a96:	fb442783          	lw	a5,-76(s0)
    80202a9a:	0007871b          	sext.w	a4,a5
    80202a9e:	4789                	li	a5,2
    80202aa0:	00f71663          	bne	a4,a5,80202aac <handle_page_fault+0xe8>
    80202aa4:	4789                	li	a5,2
    80202aa6:	fef42223          	sw	a5,-28(s0)
    80202aaa:	a819                	j	80202ac0 <handle_page_fault+0xfc>
        else if (type == 3) need_perm = PTE_R | PTE_W;
    80202aac:	fb442783          	lw	a5,-76(s0)
    80202ab0:	0007871b          	sext.w	a4,a5
    80202ab4:	478d                	li	a5,3
    80202ab6:	00f71563          	bne	a4,a5,80202ac0 <handle_page_fault+0xfc>
    80202aba:	4799                	li	a5,6
    80202abc:	fef42223          	sw	a5,-28(s0)
        if ((*pte & need_perm) != need_perm) {
    80202ac0:	fc843783          	ld	a5,-56(s0)
    80202ac4:	6398                	ld	a4,0(a5)
    80202ac6:	fe442783          	lw	a5,-28(s0)
    80202aca:	8f7d                	and	a4,a4,a5
    80202acc:	fe442783          	lw	a5,-28(s0)
    80202ad0:	02f70963          	beq	a4,a5,80202b02 <handle_page_fault+0x13e>
            *pte |= need_perm;
    80202ad4:	fc843783          	ld	a5,-56(s0)
    80202ad8:	6398                	ld	a4,0(a5)
    80202ada:	fe442783          	lw	a5,-28(s0)
    80202ade:	8f5d                	or	a4,a4,a5
    80202ae0:	fc843783          	ld	a5,-56(s0)
    80202ae4:	e398                	sd	a4,0(a5)
            sfence_vma();
    80202ae6:	00000097          	auipc	ra,0x0
    80202aea:	d24080e7          	jalr	-732(ra) # 8020280a <sfence_vma>
            printf("[PAGE FAULT] 已更新页面权限\n");
    80202aee:	00010517          	auipc	a0,0x10
    80202af2:	d7250513          	addi	a0,a0,-654 # 80212860 <syscall_performance_bin+0xa38>
    80202af6:	ffffe097          	auipc	ra,0xffffe
    80202afa:	1e0080e7          	jalr	480(ra) # 80200cd6 <printf>
            return 1;
    80202afe:	4785                	li	a5,1
    80202b00:	a8d5                	j	80202bf4 <handle_page_fault+0x230>
        printf("[PAGE FAULT] 页面已映射且权限正确\n");
    80202b02:	00010517          	auipc	a0,0x10
    80202b06:	d8650513          	addi	a0,a0,-634 # 80212888 <syscall_performance_bin+0xa60>
    80202b0a:	ffffe097          	auipc	ra,0xffffe
    80202b0e:	1cc080e7          	jalr	460(ra) # 80200cd6 <printf>
        return 1;
    80202b12:	4785                	li	a5,1
    80202b14:	a0c5                	j	80202bf4 <handle_page_fault+0x230>
    void* page = alloc_page();
    80202b16:	00000097          	auipc	ra,0x0
    80202b1a:	752080e7          	jalr	1874(ra) # 80203268 <alloc_page>
    80202b1e:	fca43023          	sd	a0,-64(s0)
    if (page == 0) {
    80202b22:	fc043783          	ld	a5,-64(s0)
    80202b26:	eb99                	bnez	a5,80202b3c <handle_page_fault+0x178>
        printf("[PAGE FAULT] 内存不足，无法分配页面\n");
    80202b28:	00010517          	auipc	a0,0x10
    80202b2c:	d9050513          	addi	a0,a0,-624 # 802128b8 <syscall_performance_bin+0xa90>
    80202b30:	ffffe097          	auipc	ra,0xffffe
    80202b34:	1a6080e7          	jalr	422(ra) # 80200cd6 <printf>
        return 0;
    80202b38:	4781                	li	a5,0
    80202b3a:	a86d                	j	80202bf4 <handle_page_fault+0x230>
    memset(page, 0, PGSIZE);
    80202b3c:	6605                	lui	a2,0x1
    80202b3e:	4581                	li	a1,0
    80202b40:	fc043503          	ld	a0,-64(s0)
    80202b44:	fffff097          	auipc	ra,0xfffff
    80202b48:	31c080e7          	jalr	796(ra) # 80201e60 <memset>
    int perm = 0;
    80202b4c:	fe042023          	sw	zero,-32(s0)
    if (type == 1) perm = PTE_X | PTE_R | PTE_U;
    80202b50:	fb442783          	lw	a5,-76(s0)
    80202b54:	0007871b          	sext.w	a4,a5
    80202b58:	4785                	li	a5,1
    80202b5a:	00f71663          	bne	a4,a5,80202b66 <handle_page_fault+0x1a2>
    80202b5e:	47e9                	li	a5,26
    80202b60:	fef42023          	sw	a5,-32(s0)
    80202b64:	a035                	j	80202b90 <handle_page_fault+0x1cc>
    else if (type == 2) perm = PTE_R | PTE_U;
    80202b66:	fb442783          	lw	a5,-76(s0)
    80202b6a:	0007871b          	sext.w	a4,a5
    80202b6e:	4789                	li	a5,2
    80202b70:	00f71663          	bne	a4,a5,80202b7c <handle_page_fault+0x1b8>
    80202b74:	47c9                	li	a5,18
    80202b76:	fef42023          	sw	a5,-32(s0)
    80202b7a:	a819                	j	80202b90 <handle_page_fault+0x1cc>
    else if (type == 3) perm = PTE_R | PTE_W | PTE_U;
    80202b7c:	fb442783          	lw	a5,-76(s0)
    80202b80:	0007871b          	sext.w	a4,a5
    80202b84:	478d                	li	a5,3
    80202b86:	00f71563          	bne	a4,a5,80202b90 <handle_page_fault+0x1cc>
    80202b8a:	47d9                	li	a5,22
    80202b8c:	fef42023          	sw	a5,-32(s0)
    if (map_page(pt, page_va, (uint64)page, perm) != 0) {
    80202b90:	fc043783          	ld	a5,-64(s0)
    80202b94:	fe042703          	lw	a4,-32(s0)
    80202b98:	86ba                	mv	a3,a4
    80202b9a:	863e                	mv	a2,a5
    80202b9c:	fd843583          	ld	a1,-40(s0)
    80202ba0:	fe843503          	ld	a0,-24(s0)
    80202ba4:	fffff097          	auipc	ra,0xfffff
    80202ba8:	788080e7          	jalr	1928(ra) # 8020232c <map_page>
    80202bac:	87aa                	mv	a5,a0
    80202bae:	c38d                	beqz	a5,80202bd0 <handle_page_fault+0x20c>
        free_page(page);
    80202bb0:	fc043503          	ld	a0,-64(s0)
    80202bb4:	00000097          	auipc	ra,0x0
    80202bb8:	720080e7          	jalr	1824(ra) # 802032d4 <free_page>
        printf("[PAGE FAULT] 页面映射失败\n");
    80202bbc:	00010517          	auipc	a0,0x10
    80202bc0:	d2c50513          	addi	a0,a0,-724 # 802128e8 <syscall_performance_bin+0xac0>
    80202bc4:	ffffe097          	auipc	ra,0xffffe
    80202bc8:	112080e7          	jalr	274(ra) # 80200cd6 <printf>
        return 0;
    80202bcc:	4781                	li	a5,0
    80202bce:	a01d                	j	80202bf4 <handle_page_fault+0x230>
    sfence_vma();
    80202bd0:	00000097          	auipc	ra,0x0
    80202bd4:	c3a080e7          	jalr	-966(ra) # 8020280a <sfence_vma>
    printf("[PAGE FAULT] 成功分配并映射页面 0x%lx -> 0x%lx\n", page_va, (uint64)page);
    80202bd8:	fc043783          	ld	a5,-64(s0)
    80202bdc:	863e                	mv	a2,a5
    80202bde:	fd843583          	ld	a1,-40(s0)
    80202be2:	00010517          	auipc	a0,0x10
    80202be6:	d2e50513          	addi	a0,a0,-722 # 80212910 <syscall_performance_bin+0xae8>
    80202bea:	ffffe097          	auipc	ra,0xffffe
    80202bee:	0ec080e7          	jalr	236(ra) # 80200cd6 <printf>
    return 1;
    80202bf2:	4785                	li	a5,1
}
    80202bf4:	853e                	mv	a0,a5
    80202bf6:	60a6                	ld	ra,72(sp)
    80202bf8:	6406                	ld	s0,64(sp)
    80202bfa:	6161                	addi	sp,sp,80
    80202bfc:	8082                	ret

0000000080202bfe <test_pagetable>:
void test_pagetable(void) {
    80202bfe:	7155                	addi	sp,sp,-208
    80202c00:	e586                	sd	ra,200(sp)
    80202c02:	e1a2                	sd	s0,192(sp)
    80202c04:	fd26                	sd	s1,184(sp)
    80202c06:	f94a                	sd	s2,176(sp)
    80202c08:	f54e                	sd	s3,168(sp)
    80202c0a:	f152                	sd	s4,160(sp)
    80202c0c:	ed56                	sd	s5,152(sp)
    80202c0e:	e95a                	sd	s6,144(sp)
    80202c10:	e55e                	sd	s7,136(sp)
    80202c12:	e162                	sd	s8,128(sp)
    80202c14:	fce6                	sd	s9,120(sp)
    80202c16:	0980                	addi	s0,sp,208
    80202c18:	878a                	mv	a5,sp
    80202c1a:	84be                	mv	s1,a5
    printf("[PT TEST] 创建页表...\n");
    80202c1c:	00010517          	auipc	a0,0x10
    80202c20:	d3450513          	addi	a0,a0,-716 # 80212950 <syscall_performance_bin+0xb28>
    80202c24:	ffffe097          	auipc	ra,0xffffe
    80202c28:	0b2080e7          	jalr	178(ra) # 80200cd6 <printf>
    pagetable_t pt = create_pagetable();
    80202c2c:	fffff097          	auipc	ra,0xfffff
    80202c30:	490080e7          	jalr	1168(ra) # 802020bc <create_pagetable>
    80202c34:	f8a43423          	sd	a0,-120(s0)
    assert(pt != 0);
    80202c38:	f8843783          	ld	a5,-120(s0)
    80202c3c:	00f037b3          	snez	a5,a5
    80202c40:	0ff7f793          	zext.b	a5,a5
    80202c44:	2781                	sext.w	a5,a5
    80202c46:	853e                	mv	a0,a5
    80202c48:	fffff097          	auipc	ra,0xfffff
    80202c4c:	38a080e7          	jalr	906(ra) # 80201fd2 <assert>
    printf("[PT TEST] 页表创建通过\n");
    80202c50:	00010517          	auipc	a0,0x10
    80202c54:	d2050513          	addi	a0,a0,-736 # 80212970 <syscall_performance_bin+0xb48>
    80202c58:	ffffe097          	auipc	ra,0xffffe
    80202c5c:	07e080e7          	jalr	126(ra) # 80200cd6 <printf>
    uint64 va[] = {
    80202c60:	00010797          	auipc	a5,0x10
    80202c64:	ed078793          	addi	a5,a5,-304 # 80212b30 <syscall_performance_bin+0xd08>
    80202c68:	638c                	ld	a1,0(a5)
    80202c6a:	6790                	ld	a2,8(a5)
    80202c6c:	6b94                	ld	a3,16(a5)
    80202c6e:	6f98                	ld	a4,24(a5)
    80202c70:	739c                	ld	a5,32(a5)
    80202c72:	f2b43c23          	sd	a1,-200(s0)
    80202c76:	f4c43023          	sd	a2,-192(s0)
    80202c7a:	f4d43423          	sd	a3,-184(s0)
    80202c7e:	f4e43823          	sd	a4,-176(s0)
    80202c82:	f4f43c23          	sd	a5,-168(s0)
    int n = sizeof(va) / sizeof(va[0]);
    80202c86:	4795                	li	a5,5
    80202c88:	f8f42223          	sw	a5,-124(s0)
    uint64 pa[n];
    80202c8c:	f8442783          	lw	a5,-124(s0)
    80202c90:	873e                	mv	a4,a5
    80202c92:	177d                	addi	a4,a4,-1
    80202c94:	f6e43c23          	sd	a4,-136(s0)
    80202c98:	873e                	mv	a4,a5
    80202c9a:	8c3a                	mv	s8,a4
    80202c9c:	4c81                	li	s9,0
    80202c9e:	03ac5713          	srli	a4,s8,0x3a
    80202ca2:	006c9a93          	slli	s5,s9,0x6
    80202ca6:	01576ab3          	or	s5,a4,s5
    80202caa:	006c1a13          	slli	s4,s8,0x6
    80202cae:	873e                	mv	a4,a5
    80202cb0:	8b3a                	mv	s6,a4
    80202cb2:	4b81                	li	s7,0
    80202cb4:	03ab5713          	srli	a4,s6,0x3a
    80202cb8:	006b9993          	slli	s3,s7,0x6
    80202cbc:	013769b3          	or	s3,a4,s3
    80202cc0:	006b1913          	slli	s2,s6,0x6
    80202cc4:	078e                	slli	a5,a5,0x3
    80202cc6:	07bd                	addi	a5,a5,15
    80202cc8:	8391                	srli	a5,a5,0x4
    80202cca:	0792                	slli	a5,a5,0x4
    80202ccc:	40f10133          	sub	sp,sp,a5
    80202cd0:	878a                	mv	a5,sp
    80202cd2:	079d                	addi	a5,a5,7
    80202cd4:	838d                	srli	a5,a5,0x3
    80202cd6:	078e                	slli	a5,a5,0x3
    80202cd8:	f6f43823          	sd	a5,-144(s0)
    for (int i = 0; i < n; i++) {
    80202cdc:	f8042e23          	sw	zero,-100(s0)
    80202ce0:	a201                	j	80202de0 <test_pagetable+0x1e2>
        pa[i] = (uint64)alloc_page();
    80202ce2:	00000097          	auipc	ra,0x0
    80202ce6:	586080e7          	jalr	1414(ra) # 80203268 <alloc_page>
    80202cea:	87aa                	mv	a5,a0
    80202cec:	86be                	mv	a3,a5
    80202cee:	f7043703          	ld	a4,-144(s0)
    80202cf2:	f9c42783          	lw	a5,-100(s0)
    80202cf6:	078e                	slli	a5,a5,0x3
    80202cf8:	97ba                	add	a5,a5,a4
    80202cfa:	e394                	sd	a3,0(a5)
        assert(pa[i]);
    80202cfc:	f7043703          	ld	a4,-144(s0)
    80202d00:	f9c42783          	lw	a5,-100(s0)
    80202d04:	078e                	slli	a5,a5,0x3
    80202d06:	97ba                	add	a5,a5,a4
    80202d08:	639c                	ld	a5,0(a5)
    80202d0a:	2781                	sext.w	a5,a5
    80202d0c:	853e                	mv	a0,a5
    80202d0e:	fffff097          	auipc	ra,0xfffff
    80202d12:	2c4080e7          	jalr	708(ra) # 80201fd2 <assert>
        printf("[PT TEST] 分配物理页 pa[%d]=0x%lx\n", i, pa[i]);
    80202d16:	f7043703          	ld	a4,-144(s0)
    80202d1a:	f9c42783          	lw	a5,-100(s0)
    80202d1e:	078e                	slli	a5,a5,0x3
    80202d20:	97ba                	add	a5,a5,a4
    80202d22:	6398                	ld	a4,0(a5)
    80202d24:	f9c42783          	lw	a5,-100(s0)
    80202d28:	863a                	mv	a2,a4
    80202d2a:	85be                	mv	a1,a5
    80202d2c:	00010517          	auipc	a0,0x10
    80202d30:	c6450513          	addi	a0,a0,-924 # 80212990 <syscall_performance_bin+0xb68>
    80202d34:	ffffe097          	auipc	ra,0xffffe
    80202d38:	fa2080e7          	jalr	-94(ra) # 80200cd6 <printf>
        int ret = map_page(pt, va[i], pa[i], PTE_R | PTE_W);
    80202d3c:	f9c42783          	lw	a5,-100(s0)
    80202d40:	078e                	slli	a5,a5,0x3
    80202d42:	fa078793          	addi	a5,a5,-96
    80202d46:	97a2                	add	a5,a5,s0
    80202d48:	f987b583          	ld	a1,-104(a5)
    80202d4c:	f7043703          	ld	a4,-144(s0)
    80202d50:	f9c42783          	lw	a5,-100(s0)
    80202d54:	078e                	slli	a5,a5,0x3
    80202d56:	97ba                	add	a5,a5,a4
    80202d58:	639c                	ld	a5,0(a5)
    80202d5a:	4699                	li	a3,6
    80202d5c:	863e                	mv	a2,a5
    80202d5e:	f8843503          	ld	a0,-120(s0)
    80202d62:	fffff097          	auipc	ra,0xfffff
    80202d66:	5ca080e7          	jalr	1482(ra) # 8020232c <map_page>
    80202d6a:	87aa                	mv	a5,a0
    80202d6c:	f6f42223          	sw	a5,-156(s0)
        printf("[PT TEST] 映射 va=0x%lx -> pa=0x%lx %s\n", va[i], pa[i], ret == 0 ? "成功" : "失败");
    80202d70:	f9c42783          	lw	a5,-100(s0)
    80202d74:	078e                	slli	a5,a5,0x3
    80202d76:	fa078793          	addi	a5,a5,-96
    80202d7a:	97a2                	add	a5,a5,s0
    80202d7c:	f987b583          	ld	a1,-104(a5)
    80202d80:	f7043703          	ld	a4,-144(s0)
    80202d84:	f9c42783          	lw	a5,-100(s0)
    80202d88:	078e                	slli	a5,a5,0x3
    80202d8a:	97ba                	add	a5,a5,a4
    80202d8c:	6398                	ld	a4,0(a5)
    80202d8e:	f6442783          	lw	a5,-156(s0)
    80202d92:	2781                	sext.w	a5,a5
    80202d94:	e791                	bnez	a5,80202da0 <test_pagetable+0x1a2>
    80202d96:	00010797          	auipc	a5,0x10
    80202d9a:	c2278793          	addi	a5,a5,-990 # 802129b8 <syscall_performance_bin+0xb90>
    80202d9e:	a029                	j	80202da8 <test_pagetable+0x1aa>
    80202da0:	00010797          	auipc	a5,0x10
    80202da4:	c2078793          	addi	a5,a5,-992 # 802129c0 <syscall_performance_bin+0xb98>
    80202da8:	86be                	mv	a3,a5
    80202daa:	863a                	mv	a2,a4
    80202dac:	00010517          	auipc	a0,0x10
    80202db0:	c1c50513          	addi	a0,a0,-996 # 802129c8 <syscall_performance_bin+0xba0>
    80202db4:	ffffe097          	auipc	ra,0xffffe
    80202db8:	f22080e7          	jalr	-222(ra) # 80200cd6 <printf>
        assert(ret == 0);
    80202dbc:	f6442783          	lw	a5,-156(s0)
    80202dc0:	2781                	sext.w	a5,a5
    80202dc2:	0017b793          	seqz	a5,a5
    80202dc6:	0ff7f793          	zext.b	a5,a5
    80202dca:	2781                	sext.w	a5,a5
    80202dcc:	853e                	mv	a0,a5
    80202dce:	fffff097          	auipc	ra,0xfffff
    80202dd2:	204080e7          	jalr	516(ra) # 80201fd2 <assert>
    for (int i = 0; i < n; i++) {
    80202dd6:	f9c42783          	lw	a5,-100(s0)
    80202dda:	2785                	addiw	a5,a5,1
    80202ddc:	f8f42e23          	sw	a5,-100(s0)
    80202de0:	f9c42783          	lw	a5,-100(s0)
    80202de4:	873e                	mv	a4,a5
    80202de6:	f8442783          	lw	a5,-124(s0)
    80202dea:	2701                	sext.w	a4,a4
    80202dec:	2781                	sext.w	a5,a5
    80202dee:	eef74ae3          	blt	a4,a5,80202ce2 <test_pagetable+0xe4>
    printf("[PT TEST] 多级映射测试通过\n");
    80202df2:	00010517          	auipc	a0,0x10
    80202df6:	c0650513          	addi	a0,a0,-1018 # 802129f8 <syscall_performance_bin+0xbd0>
    80202dfa:	ffffe097          	auipc	ra,0xffffe
    80202dfe:	edc080e7          	jalr	-292(ra) # 80200cd6 <printf>
    for (int i = 0; i < n; i++) {
    80202e02:	f8042c23          	sw	zero,-104(s0)
    80202e06:	a861                	j	80202e9e <test_pagetable+0x2a0>
        pte_t *pte = walk_lookup(pt, va[i]);
    80202e08:	f9842783          	lw	a5,-104(s0)
    80202e0c:	078e                	slli	a5,a5,0x3
    80202e0e:	fa078793          	addi	a5,a5,-96
    80202e12:	97a2                	add	a5,a5,s0
    80202e14:	f987b783          	ld	a5,-104(a5)
    80202e18:	85be                	mv	a1,a5
    80202e1a:	f8843503          	ld	a0,-120(s0)
    80202e1e:	fffff097          	auipc	ra,0xfffff
    80202e22:	2da080e7          	jalr	730(ra) # 802020f8 <walk_lookup>
    80202e26:	f6a43423          	sd	a0,-152(s0)
        if (pte && (*pte & PTE_V)) {
    80202e2a:	f6843783          	ld	a5,-152(s0)
    80202e2e:	c3b1                	beqz	a5,80202e72 <test_pagetable+0x274>
    80202e30:	f6843783          	ld	a5,-152(s0)
    80202e34:	639c                	ld	a5,0(a5)
    80202e36:	8b85                	andi	a5,a5,1
    80202e38:	cf8d                	beqz	a5,80202e72 <test_pagetable+0x274>
            printf("[PT TEST] 检查映射: va=0x%lx -> pa=0x%lx, pte=0x%lx\n", va[i], PTE2PA(*pte), *pte);
    80202e3a:	f9842783          	lw	a5,-104(s0)
    80202e3e:	078e                	slli	a5,a5,0x3
    80202e40:	fa078793          	addi	a5,a5,-96
    80202e44:	97a2                	add	a5,a5,s0
    80202e46:	f987b703          	ld	a4,-104(a5)
    80202e4a:	f6843783          	ld	a5,-152(s0)
    80202e4e:	639c                	ld	a5,0(a5)
    80202e50:	83a9                	srli	a5,a5,0xa
    80202e52:	00c79613          	slli	a2,a5,0xc
    80202e56:	f6843783          	ld	a5,-152(s0)
    80202e5a:	639c                	ld	a5,0(a5)
    80202e5c:	86be                	mv	a3,a5
    80202e5e:	85ba                	mv	a1,a4
    80202e60:	00010517          	auipc	a0,0x10
    80202e64:	bc050513          	addi	a0,a0,-1088 # 80212a20 <syscall_performance_bin+0xbf8>
    80202e68:	ffffe097          	auipc	ra,0xffffe
    80202e6c:	e6e080e7          	jalr	-402(ra) # 80200cd6 <printf>
    80202e70:	a015                	j	80202e94 <test_pagetable+0x296>
            printf("[PT TEST] 检查映射: va=0x%lx 未映射\n", va[i]);
    80202e72:	f9842783          	lw	a5,-104(s0)
    80202e76:	078e                	slli	a5,a5,0x3
    80202e78:	fa078793          	addi	a5,a5,-96
    80202e7c:	97a2                	add	a5,a5,s0
    80202e7e:	f987b783          	ld	a5,-104(a5)
    80202e82:	85be                	mv	a1,a5
    80202e84:	00010517          	auipc	a0,0x10
    80202e88:	bdc50513          	addi	a0,a0,-1060 # 80212a60 <syscall_performance_bin+0xc38>
    80202e8c:	ffffe097          	auipc	ra,0xffffe
    80202e90:	e4a080e7          	jalr	-438(ra) # 80200cd6 <printf>
    for (int i = 0; i < n; i++) {
    80202e94:	f9842783          	lw	a5,-104(s0)
    80202e98:	2785                	addiw	a5,a5,1
    80202e9a:	f8f42c23          	sw	a5,-104(s0)
    80202e9e:	f9842783          	lw	a5,-104(s0)
    80202ea2:	873e                	mv	a4,a5
    80202ea4:	f8442783          	lw	a5,-124(s0)
    80202ea8:	2701                	sext.w	a4,a4
    80202eaa:	2781                	sext.w	a5,a5
    80202eac:	f4f74ee3          	blt	a4,a5,80202e08 <test_pagetable+0x20a>
    printf("[PT TEST] 打印页表结构（递归）\n");
    80202eb0:	00010517          	auipc	a0,0x10
    80202eb4:	be050513          	addi	a0,a0,-1056 # 80212a90 <syscall_performance_bin+0xc68>
    80202eb8:	ffffe097          	auipc	ra,0xffffe
    80202ebc:	e1e080e7          	jalr	-482(ra) # 80200cd6 <printf>
    print_pagetable(pt, 0, 0);
    80202ec0:	4601                	li	a2,0
    80202ec2:	4581                	li	a1,0
    80202ec4:	f8843503          	ld	a0,-120(s0)
    80202ec8:	00000097          	auipc	ra,0x0
    80202ecc:	9e6080e7          	jalr	-1562(ra) # 802028ae <print_pagetable>
    for (int i = 0; i < n; i++) {
    80202ed0:	f8042a23          	sw	zero,-108(s0)
    80202ed4:	a0a9                	j	80202f1e <test_pagetable+0x320>
        free_page((void*)pa[i]);
    80202ed6:	f7043703          	ld	a4,-144(s0)
    80202eda:	f9442783          	lw	a5,-108(s0)
    80202ede:	078e                	slli	a5,a5,0x3
    80202ee0:	97ba                	add	a5,a5,a4
    80202ee2:	639c                	ld	a5,0(a5)
    80202ee4:	853e                	mv	a0,a5
    80202ee6:	00000097          	auipc	ra,0x0
    80202eea:	3ee080e7          	jalr	1006(ra) # 802032d4 <free_page>
        printf("[PT TEST] 释放物理页 pa[%d]=0x%lx\n", i, pa[i]);
    80202eee:	f7043703          	ld	a4,-144(s0)
    80202ef2:	f9442783          	lw	a5,-108(s0)
    80202ef6:	078e                	slli	a5,a5,0x3
    80202ef8:	97ba                	add	a5,a5,a4
    80202efa:	6398                	ld	a4,0(a5)
    80202efc:	f9442783          	lw	a5,-108(s0)
    80202f00:	863a                	mv	a2,a4
    80202f02:	85be                	mv	a1,a5
    80202f04:	00010517          	auipc	a0,0x10
    80202f08:	bbc50513          	addi	a0,a0,-1092 # 80212ac0 <syscall_performance_bin+0xc98>
    80202f0c:	ffffe097          	auipc	ra,0xffffe
    80202f10:	dca080e7          	jalr	-566(ra) # 80200cd6 <printf>
    for (int i = 0; i < n; i++) {
    80202f14:	f9442783          	lw	a5,-108(s0)
    80202f18:	2785                	addiw	a5,a5,1
    80202f1a:	f8f42a23          	sw	a5,-108(s0)
    80202f1e:	f9442783          	lw	a5,-108(s0)
    80202f22:	873e                	mv	a4,a5
    80202f24:	f8442783          	lw	a5,-124(s0)
    80202f28:	2701                	sext.w	a4,a4
    80202f2a:	2781                	sext.w	a5,a5
    80202f2c:	faf745e3          	blt	a4,a5,80202ed6 <test_pagetable+0x2d8>
    free_pagetable(pt);
    80202f30:	f8843503          	ld	a0,-120(s0)
    80202f34:	fffff097          	auipc	ra,0xfffff
    80202f38:	56c080e7          	jalr	1388(ra) # 802024a0 <free_pagetable>
    printf("[PT TEST] 释放页表完成\n");
    80202f3c:	00010517          	auipc	a0,0x10
    80202f40:	bac50513          	addi	a0,a0,-1108 # 80212ae8 <syscall_performance_bin+0xcc0>
    80202f44:	ffffe097          	auipc	ra,0xffffe
    80202f48:	d92080e7          	jalr	-622(ra) # 80200cd6 <printf>
    printf("[PT TEST] 所有页表测试通过\n");
    80202f4c:	00010517          	auipc	a0,0x10
    80202f50:	bbc50513          	addi	a0,a0,-1092 # 80212b08 <syscall_performance_bin+0xce0>
    80202f54:	ffffe097          	auipc	ra,0xffffe
    80202f58:	d82080e7          	jalr	-638(ra) # 80200cd6 <printf>
    80202f5c:	8126                	mv	sp,s1
}
    80202f5e:	0001                	nop
    80202f60:	f3040113          	addi	sp,s0,-208
    80202f64:	60ae                	ld	ra,200(sp)
    80202f66:	640e                	ld	s0,192(sp)
    80202f68:	74ea                	ld	s1,184(sp)
    80202f6a:	794a                	ld	s2,176(sp)
    80202f6c:	79aa                	ld	s3,168(sp)
    80202f6e:	7a0a                	ld	s4,160(sp)
    80202f70:	6aea                	ld	s5,152(sp)
    80202f72:	6b4a                	ld	s6,144(sp)
    80202f74:	6baa                	ld	s7,136(sp)
    80202f76:	6c0a                	ld	s8,128(sp)
    80202f78:	7ce6                	ld	s9,120(sp)
    80202f7a:	6169                	addi	sp,sp,208
    80202f7c:	8082                	ret

0000000080202f7e <check_mapping>:
void check_mapping(uint64 va) {
    80202f7e:	7179                	addi	sp,sp,-48
    80202f80:	f406                	sd	ra,40(sp)
    80202f82:	f022                	sd	s0,32(sp)
    80202f84:	1800                	addi	s0,sp,48
    80202f86:	fca43c23          	sd	a0,-40(s0)
    pte_t *pte = walk_lookup(kernel_pagetable, va);
    80202f8a:	00023797          	auipc	a5,0x23
    80202f8e:	1b678793          	addi	a5,a5,438 # 80226140 <kernel_pagetable>
    80202f92:	639c                	ld	a5,0(a5)
    80202f94:	fd843583          	ld	a1,-40(s0)
    80202f98:	853e                	mv	a0,a5
    80202f9a:	fffff097          	auipc	ra,0xfffff
    80202f9e:	15e080e7          	jalr	350(ra) # 802020f8 <walk_lookup>
    80202fa2:	fea43423          	sd	a0,-24(s0)
    if(pte && (*pte & PTE_V)) {
    80202fa6:	fe843783          	ld	a5,-24(s0)
    80202faa:	cbb9                	beqz	a5,80203000 <check_mapping+0x82>
    80202fac:	fe843783          	ld	a5,-24(s0)
    80202fb0:	639c                	ld	a5,0(a5)
    80202fb2:	8b85                	andi	a5,a5,1
    80202fb4:	c7b1                	beqz	a5,80203000 <check_mapping+0x82>
        printf("Address 0x%lx is mapped: pte=0x%lx\n", va, *pte);
    80202fb6:	fe843783          	ld	a5,-24(s0)
    80202fba:	639c                	ld	a5,0(a5)
    80202fbc:	863e                	mv	a2,a5
    80202fbe:	fd843583          	ld	a1,-40(s0)
    80202fc2:	00010517          	auipc	a0,0x10
    80202fc6:	b9650513          	addi	a0,a0,-1130 # 80212b58 <syscall_performance_bin+0xd30>
    80202fca:	ffffe097          	auipc	ra,0xffffe
    80202fce:	d0c080e7          	jalr	-756(ra) # 80200cd6 <printf>
		volatile unsigned char *p = (unsigned char*)va;
    80202fd2:	fd843783          	ld	a5,-40(s0)
    80202fd6:	fef43023          	sd	a5,-32(s0)
        printf("Try to read [0x%lx]: 0x%02x\n", va, *p);
    80202fda:	fe043783          	ld	a5,-32(s0)
    80202fde:	0007c783          	lbu	a5,0(a5)
    80202fe2:	0ff7f793          	zext.b	a5,a5
    80202fe6:	2781                	sext.w	a5,a5
    80202fe8:	863e                	mv	a2,a5
    80202fea:	fd843583          	ld	a1,-40(s0)
    80202fee:	00010517          	auipc	a0,0x10
    80202ff2:	b9250513          	addi	a0,a0,-1134 # 80212b80 <syscall_performance_bin+0xd58>
    80202ff6:	ffffe097          	auipc	ra,0xffffe
    80202ffa:	ce0080e7          	jalr	-800(ra) # 80200cd6 <printf>
    if(pte && (*pte & PTE_V)) {
    80202ffe:	a821                	j	80203016 <check_mapping+0x98>
        printf("Address 0x%lx is NOT mapped\n", va);
    80203000:	fd843583          	ld	a1,-40(s0)
    80203004:	00010517          	auipc	a0,0x10
    80203008:	b9c50513          	addi	a0,a0,-1124 # 80212ba0 <syscall_performance_bin+0xd78>
    8020300c:	ffffe097          	auipc	ra,0xffffe
    80203010:	cca080e7          	jalr	-822(ra) # 80200cd6 <printf>
}
    80203014:	0001                	nop
    80203016:	0001                	nop
    80203018:	70a2                	ld	ra,40(sp)
    8020301a:	7402                	ld	s0,32(sp)
    8020301c:	6145                	addi	sp,sp,48
    8020301e:	8082                	ret

0000000080203020 <check_is_mapped>:
int check_is_mapped(uint64 va) {
    80203020:	7179                	addi	sp,sp,-48
    80203022:	f406                	sd	ra,40(sp)
    80203024:	f022                	sd	s0,32(sp)
    80203026:	1800                	addi	s0,sp,48
    80203028:	fca43c23          	sd	a0,-40(s0)
    pte_t *pte = walk_lookup(get_current_pagetable(), va);
    8020302c:	00000097          	auipc	ra,0x0
    80203030:	86a080e7          	jalr	-1942(ra) # 80202896 <get_current_pagetable>
    80203034:	87aa                	mv	a5,a0
    80203036:	fd843583          	ld	a1,-40(s0)
    8020303a:	853e                	mv	a0,a5
    8020303c:	fffff097          	auipc	ra,0xfffff
    80203040:	0bc080e7          	jalr	188(ra) # 802020f8 <walk_lookup>
    80203044:	fea43423          	sd	a0,-24(s0)
    if (pte && (*pte & PTE_V)) {
    80203048:	fe843783          	ld	a5,-24(s0)
    8020304c:	c795                	beqz	a5,80203078 <check_is_mapped+0x58>
    8020304e:	fe843783          	ld	a5,-24(s0)
    80203052:	639c                	ld	a5,0(a5)
    80203054:	8b85                	andi	a5,a5,1
    80203056:	c38d                	beqz	a5,80203078 <check_is_mapped+0x58>
        printf("Address 0x%lx is mapped: pte=0x%lx\n", va, *pte);
    80203058:	fe843783          	ld	a5,-24(s0)
    8020305c:	639c                	ld	a5,0(a5)
    8020305e:	863e                	mv	a2,a5
    80203060:	fd843583          	ld	a1,-40(s0)
    80203064:	00010517          	auipc	a0,0x10
    80203068:	af450513          	addi	a0,a0,-1292 # 80212b58 <syscall_performance_bin+0xd30>
    8020306c:	ffffe097          	auipc	ra,0xffffe
    80203070:	c6a080e7          	jalr	-918(ra) # 80200cd6 <printf>
        return 1;
    80203074:	4785                	li	a5,1
    80203076:	a821                	j	8020308e <check_is_mapped+0x6e>
        printf("Address 0x%lx is NOT mapped\n", va);
    80203078:	fd843583          	ld	a1,-40(s0)
    8020307c:	00010517          	auipc	a0,0x10
    80203080:	b2450513          	addi	a0,a0,-1244 # 80212ba0 <syscall_performance_bin+0xd78>
    80203084:	ffffe097          	auipc	ra,0xffffe
    80203088:	c52080e7          	jalr	-942(ra) # 80200cd6 <printf>
        return 0;
    8020308c:	4781                	li	a5,0
}
    8020308e:	853e                	mv	a0,a5
    80203090:	70a2                	ld	ra,40(sp)
    80203092:	7402                	ld	s0,32(sp)
    80203094:	6145                	addi	sp,sp,48
    80203096:	8082                	ret

0000000080203098 <uvmcopy>:
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    80203098:	711d                	addi	sp,sp,-96
    8020309a:	ec86                	sd	ra,88(sp)
    8020309c:	e8a2                	sd	s0,80(sp)
    8020309e:	1080                	addi	s0,sp,96
    802030a0:	faa43c23          	sd	a0,-72(s0)
    802030a4:	fab43823          	sd	a1,-80(s0)
    802030a8:	fac43423          	sd	a2,-88(s0)
    for (uint64 i = 0; i < sz; i += PGSIZE) {
    802030ac:	fe043423          	sd	zero,-24(s0)
    802030b0:	a8d1                	j	80203184 <uvmcopy+0xec>
        pte_t *pte = walk_lookup(old, i);
    802030b2:	fe843583          	ld	a1,-24(s0)
    802030b6:	fb843503          	ld	a0,-72(s0)
    802030ba:	fffff097          	auipc	ra,0xfffff
    802030be:	03e080e7          	jalr	62(ra) # 802020f8 <walk_lookup>
    802030c2:	fca43c23          	sd	a0,-40(s0)
        if (pte == 0 || (*pte & PTE_V) == 0)
    802030c6:	fd843783          	ld	a5,-40(s0)
    802030ca:	c7d5                	beqz	a5,80203176 <uvmcopy+0xde>
    802030cc:	fd843783          	ld	a5,-40(s0)
    802030d0:	639c                	ld	a5,0(a5)
    802030d2:	8b85                	andi	a5,a5,1
    802030d4:	c3cd                	beqz	a5,80203176 <uvmcopy+0xde>
        uint64 pa = PTE2PA(*pte);
    802030d6:	fd843783          	ld	a5,-40(s0)
    802030da:	639c                	ld	a5,0(a5)
    802030dc:	83a9                	srli	a5,a5,0xa
    802030de:	07b2                	slli	a5,a5,0xc
    802030e0:	fcf43823          	sd	a5,-48(s0)
        int flags = PTE_FLAGS(*pte);
    802030e4:	fd843783          	ld	a5,-40(s0)
    802030e8:	639c                	ld	a5,0(a5)
    802030ea:	2781                	sext.w	a5,a5
    802030ec:	3ff7f793          	andi	a5,a5,1023
    802030f0:	fef42223          	sw	a5,-28(s0)
		if (i < 0x80000000)
    802030f4:	fe843703          	ld	a4,-24(s0)
    802030f8:	800007b7          	lui	a5,0x80000
    802030fc:	fff7c793          	not	a5,a5
    80203100:	00e7e963          	bltu	a5,a4,80203112 <uvmcopy+0x7a>
			flags |= PTE_U;
    80203104:	fe442783          	lw	a5,-28(s0)
    80203108:	0107e793          	ori	a5,a5,16
    8020310c:	fef42223          	sw	a5,-28(s0)
    80203110:	a031                	j	8020311c <uvmcopy+0x84>
			flags &= ~PTE_U;
    80203112:	fe442783          	lw	a5,-28(s0)
    80203116:	9bbd                	andi	a5,a5,-17
    80203118:	fef42223          	sw	a5,-28(s0)
        void *mem = alloc_page();
    8020311c:	00000097          	auipc	ra,0x0
    80203120:	14c080e7          	jalr	332(ra) # 80203268 <alloc_page>
    80203124:	fca43423          	sd	a0,-56(s0)
        if (mem == 0)
    80203128:	fc843783          	ld	a5,-56(s0)
    8020312c:	e399                	bnez	a5,80203132 <uvmcopy+0x9a>
            return -1; // 分配失败
    8020312e:	57fd                	li	a5,-1
    80203130:	a08d                	j	80203192 <uvmcopy+0xfa>
        memmove(mem, (void*)pa, PGSIZE);
    80203132:	fd043783          	ld	a5,-48(s0)
    80203136:	6605                	lui	a2,0x1
    80203138:	85be                	mv	a1,a5
    8020313a:	fc843503          	ld	a0,-56(s0)
    8020313e:	fffff097          	auipc	ra,0xfffff
    80203142:	d72080e7          	jalr	-654(ra) # 80201eb0 <memmove>
        if (map_page(new, i, (uint64)mem, flags) != 0) {
    80203146:	fc843783          	ld	a5,-56(s0)
    8020314a:	fe442703          	lw	a4,-28(s0)
    8020314e:	86ba                	mv	a3,a4
    80203150:	863e                	mv	a2,a5
    80203152:	fe843583          	ld	a1,-24(s0)
    80203156:	fb043503          	ld	a0,-80(s0)
    8020315a:	fffff097          	auipc	ra,0xfffff
    8020315e:	1d2080e7          	jalr	466(ra) # 8020232c <map_page>
    80203162:	87aa                	mv	a5,a0
    80203164:	cb91                	beqz	a5,80203178 <uvmcopy+0xe0>
            free_page(mem);
    80203166:	fc843503          	ld	a0,-56(s0)
    8020316a:	00000097          	auipc	ra,0x0
    8020316e:	16a080e7          	jalr	362(ra) # 802032d4 <free_page>
            return -1;
    80203172:	57fd                	li	a5,-1
    80203174:	a839                	j	80203192 <uvmcopy+0xfa>
            continue; // 跳过未分配的页
    80203176:	0001                	nop
    for (uint64 i = 0; i < sz; i += PGSIZE) {
    80203178:	fe843703          	ld	a4,-24(s0)
    8020317c:	6785                	lui	a5,0x1
    8020317e:	97ba                	add	a5,a5,a4
    80203180:	fef43423          	sd	a5,-24(s0)
    80203184:	fe843703          	ld	a4,-24(s0)
    80203188:	fa843783          	ld	a5,-88(s0)
    8020318c:	f2f763e3          	bltu	a4,a5,802030b2 <uvmcopy+0x1a>
    return 0;
    80203190:	4781                	li	a5,0
    80203192:	853e                	mv	a0,a5
    80203194:	60e6                	ld	ra,88(sp)
    80203196:	6446                	ld	s0,80(sp)
    80203198:	6125                	addi	sp,sp,96
    8020319a:	8082                	ret

000000008020319c <assert>:
    8020319c:	1101                	addi	sp,sp,-32
    8020319e:	ec06                	sd	ra,24(sp)
    802031a0:	e822                	sd	s0,16(sp)
    802031a2:	1000                	addi	s0,sp,32
    802031a4:	87aa                	mv	a5,a0
    802031a6:	fef42623          	sw	a5,-20(s0)
    802031aa:	fec42783          	lw	a5,-20(s0)
    802031ae:	2781                	sext.w	a5,a5
    802031b0:	e79d                	bnez	a5,802031de <assert+0x42>
    802031b2:	1b300613          	li	a2,435
    802031b6:	00012597          	auipc	a1,0x12
    802031ba:	80258593          	addi	a1,a1,-2046 # 802149b8 <syscall_performance_bin+0x670>
    802031be:	00012517          	auipc	a0,0x12
    802031c2:	80a50513          	addi	a0,a0,-2038 # 802149c8 <syscall_performance_bin+0x680>
    802031c6:	ffffe097          	auipc	ra,0xffffe
    802031ca:	b10080e7          	jalr	-1264(ra) # 80200cd6 <printf>
    802031ce:	00012517          	auipc	a0,0x12
    802031d2:	82250513          	addi	a0,a0,-2014 # 802149f0 <syscall_performance_bin+0x6a8>
    802031d6:	ffffe097          	auipc	ra,0xffffe
    802031da:	54c080e7          	jalr	1356(ra) # 80201722 <panic>
    802031de:	0001                	nop
    802031e0:	60e2                	ld	ra,24(sp)
    802031e2:	6442                	ld	s0,16(sp)
    802031e4:	6105                	addi	sp,sp,32
    802031e6:	8082                	ret

00000000802031e8 <freerange>:
static void freerange(void *pa_start, void *pa_end) {
    802031e8:	7179                	addi	sp,sp,-48
    802031ea:	f406                	sd	ra,40(sp)
    802031ec:	f022                	sd	s0,32(sp)
    802031ee:	1800                	addi	s0,sp,48
    802031f0:	fca43c23          	sd	a0,-40(s0)
    802031f4:	fcb43823          	sd	a1,-48(s0)
  char *p = (char*)PGROUNDUP((uint64)pa_start);
    802031f8:	fd843703          	ld	a4,-40(s0)
    802031fc:	6785                	lui	a5,0x1
    802031fe:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80203200:	973e                	add	a4,a4,a5
    80203202:	77fd                	lui	a5,0xfffff
    80203204:	8ff9                	and	a5,a5,a4
    80203206:	fef43423          	sd	a5,-24(s0)
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    8020320a:	a829                	j	80203224 <freerange+0x3c>
    free_page(p);
    8020320c:	fe843503          	ld	a0,-24(s0)
    80203210:	00000097          	auipc	ra,0x0
    80203214:	0c4080e7          	jalr	196(ra) # 802032d4 <free_page>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80203218:	fe843703          	ld	a4,-24(s0)
    8020321c:	6785                	lui	a5,0x1
    8020321e:	97ba                	add	a5,a5,a4
    80203220:	fef43423          	sd	a5,-24(s0)
    80203224:	fe843703          	ld	a4,-24(s0)
    80203228:	6785                	lui	a5,0x1
    8020322a:	97ba                	add	a5,a5,a4
    8020322c:	fd043703          	ld	a4,-48(s0)
    80203230:	fcf77ee3          	bgeu	a4,a5,8020320c <freerange+0x24>
}
    80203234:	0001                	nop
    80203236:	0001                	nop
    80203238:	70a2                	ld	ra,40(sp)
    8020323a:	7402                	ld	s0,32(sp)
    8020323c:	6145                	addi	sp,sp,48
    8020323e:	8082                	ret

0000000080203240 <pmm_init>:
void pmm_init(void) {
    80203240:	1141                	addi	sp,sp,-16
    80203242:	e406                	sd	ra,8(sp)
    80203244:	e022                	sd	s0,0(sp)
    80203246:	0800                	addi	s0,sp,16
  freerange(end, (void*)PHYSTOP);
    80203248:	47c5                	li	a5,17
    8020324a:	01b79593          	slli	a1,a5,0x1b
    8020324e:	00023517          	auipc	a0,0x23
    80203252:	55250513          	addi	a0,a0,1362 # 802267a0 <_bss_end>
    80203256:	00000097          	auipc	ra,0x0
    8020325a:	f92080e7          	jalr	-110(ra) # 802031e8 <freerange>
}
    8020325e:	0001                	nop
    80203260:	60a2                	ld	ra,8(sp)
    80203262:	6402                	ld	s0,0(sp)
    80203264:	0141                	addi	sp,sp,16
    80203266:	8082                	ret

0000000080203268 <alloc_page>:
void* alloc_page(void) {
    80203268:	1101                	addi	sp,sp,-32
    8020326a:	ec06                	sd	ra,24(sp)
    8020326c:	e822                	sd	s0,16(sp)
    8020326e:	1000                	addi	s0,sp,32
  struct run *r = freelist;
    80203270:	00023797          	auipc	a5,0x23
    80203274:	0a078793          	addi	a5,a5,160 # 80226310 <freelist>
    80203278:	639c                	ld	a5,0(a5)
    8020327a:	fef43423          	sd	a5,-24(s0)
  if(r)
    8020327e:	fe843783          	ld	a5,-24(s0)
    80203282:	cb89                	beqz	a5,80203294 <alloc_page+0x2c>
    freelist = r->next;
    80203284:	fe843783          	ld	a5,-24(s0)
    80203288:	6398                	ld	a4,0(a5)
    8020328a:	00023797          	auipc	a5,0x23
    8020328e:	08678793          	addi	a5,a5,134 # 80226310 <freelist>
    80203292:	e398                	sd	a4,0(a5)
  if(r)
    80203294:	fe843783          	ld	a5,-24(s0)
    80203298:	cf99                	beqz	a5,802032b6 <alloc_page+0x4e>
    memset((char*)r + sizeof(struct run), 5, PGSIZE - sizeof(struct run));
    8020329a:	fe843783          	ld	a5,-24(s0)
    8020329e:	00878713          	addi	a4,a5,8
    802032a2:	6785                	lui	a5,0x1
    802032a4:	ff878613          	addi	a2,a5,-8 # ff8 <_entry-0x801ff008>
    802032a8:	4595                	li	a1,5
    802032aa:	853a                	mv	a0,a4
    802032ac:	fffff097          	auipc	ra,0xfffff
    802032b0:	bb4080e7          	jalr	-1100(ra) # 80201e60 <memset>
    802032b4:	a809                	j	802032c6 <alloc_page+0x5e>
    panic("alloc_page: out of memory");
    802032b6:	00011517          	auipc	a0,0x11
    802032ba:	74250513          	addi	a0,a0,1858 # 802149f8 <syscall_performance_bin+0x6b0>
    802032be:	ffffe097          	auipc	ra,0xffffe
    802032c2:	464080e7          	jalr	1124(ra) # 80201722 <panic>
  return (void*)r;
    802032c6:	fe843783          	ld	a5,-24(s0)
}
    802032ca:	853e                	mv	a0,a5
    802032cc:	60e2                	ld	ra,24(sp)
    802032ce:	6442                	ld	s0,16(sp)
    802032d0:	6105                	addi	sp,sp,32
    802032d2:	8082                	ret

00000000802032d4 <free_page>:
void free_page(void* page) {
    802032d4:	7179                	addi	sp,sp,-48
    802032d6:	f406                	sd	ra,40(sp)
    802032d8:	f022                	sd	s0,32(sp)
    802032da:	1800                	addi	s0,sp,48
    802032dc:	fca43c23          	sd	a0,-40(s0)
  struct run *r = (struct run*)page;
    802032e0:	fd843783          	ld	a5,-40(s0)
    802032e4:	fef43423          	sd	a5,-24(s0)
  if(((uint64)page % PGSIZE) != 0 || (char*)page < end || (uint64)page >= PHYSTOP)
    802032e8:	fd843703          	ld	a4,-40(s0)
    802032ec:	6785                	lui	a5,0x1
    802032ee:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    802032f0:	8ff9                	and	a5,a5,a4
    802032f2:	ef99                	bnez	a5,80203310 <free_page+0x3c>
    802032f4:	fd843703          	ld	a4,-40(s0)
    802032f8:	00023797          	auipc	a5,0x23
    802032fc:	4a878793          	addi	a5,a5,1192 # 802267a0 <_bss_end>
    80203300:	00f76863          	bltu	a4,a5,80203310 <free_page+0x3c>
    80203304:	fd843703          	ld	a4,-40(s0)
    80203308:	47c5                	li	a5,17
    8020330a:	07ee                	slli	a5,a5,0x1b
    8020330c:	00f76a63          	bltu	a4,a5,80203320 <free_page+0x4c>
    panic("free_page: invalid page address");
    80203310:	00011517          	auipc	a0,0x11
    80203314:	70850513          	addi	a0,a0,1800 # 80214a18 <syscall_performance_bin+0x6d0>
    80203318:	ffffe097          	auipc	ra,0xffffe
    8020331c:	40a080e7          	jalr	1034(ra) # 80201722 <panic>
  r->next = freelist;
    80203320:	00023797          	auipc	a5,0x23
    80203324:	ff078793          	addi	a5,a5,-16 # 80226310 <freelist>
    80203328:	6398                	ld	a4,0(a5)
    8020332a:	fe843783          	ld	a5,-24(s0)
    8020332e:	e398                	sd	a4,0(a5)
  freelist = r;
    80203330:	00023797          	auipc	a5,0x23
    80203334:	fe078793          	addi	a5,a5,-32 # 80226310 <freelist>
    80203338:	fe843703          	ld	a4,-24(s0)
    8020333c:	e398                	sd	a4,0(a5)
}
    8020333e:	0001                	nop
    80203340:	70a2                	ld	ra,40(sp)
    80203342:	7402                	ld	s0,32(sp)
    80203344:	6145                	addi	sp,sp,48
    80203346:	8082                	ret

0000000080203348 <test_physical_memory>:
void test_physical_memory(void) {
    80203348:	7179                	addi	sp,sp,-48
    8020334a:	f406                	sd	ra,40(sp)
    8020334c:	f022                	sd	s0,32(sp)
    8020334e:	1800                	addi	s0,sp,48
    printf("[PM TEST] 分配两个页...\n");
    80203350:	00011517          	auipc	a0,0x11
    80203354:	6e850513          	addi	a0,a0,1768 # 80214a38 <syscall_performance_bin+0x6f0>
    80203358:	ffffe097          	auipc	ra,0xffffe
    8020335c:	97e080e7          	jalr	-1666(ra) # 80200cd6 <printf>
    void *page1 = alloc_page();
    80203360:	00000097          	auipc	ra,0x0
    80203364:	f08080e7          	jalr	-248(ra) # 80203268 <alloc_page>
    80203368:	fea43423          	sd	a0,-24(s0)
    void *page2 = alloc_page();
    8020336c:	00000097          	auipc	ra,0x0
    80203370:	efc080e7          	jalr	-260(ra) # 80203268 <alloc_page>
    80203374:	fea43023          	sd	a0,-32(s0)
    assert(page1 != 0);
    80203378:	fe843783          	ld	a5,-24(s0)
    8020337c:	00f037b3          	snez	a5,a5
    80203380:	0ff7f793          	zext.b	a5,a5
    80203384:	2781                	sext.w	a5,a5
    80203386:	853e                	mv	a0,a5
    80203388:	00000097          	auipc	ra,0x0
    8020338c:	e14080e7          	jalr	-492(ra) # 8020319c <assert>
    assert(page2 != 0);
    80203390:	fe043783          	ld	a5,-32(s0)
    80203394:	00f037b3          	snez	a5,a5
    80203398:	0ff7f793          	zext.b	a5,a5
    8020339c:	2781                	sext.w	a5,a5
    8020339e:	853e                	mv	a0,a5
    802033a0:	00000097          	auipc	ra,0x0
    802033a4:	dfc080e7          	jalr	-516(ra) # 8020319c <assert>
    assert(page1 != page2);
    802033a8:	fe843703          	ld	a4,-24(s0)
    802033ac:	fe043783          	ld	a5,-32(s0)
    802033b0:	40f707b3          	sub	a5,a4,a5
    802033b4:	00f037b3          	snez	a5,a5
    802033b8:	0ff7f793          	zext.b	a5,a5
    802033bc:	2781                	sext.w	a5,a5
    802033be:	853e                	mv	a0,a5
    802033c0:	00000097          	auipc	ra,0x0
    802033c4:	ddc080e7          	jalr	-548(ra) # 8020319c <assert>
    assert(((uint64)page1 & 0xFFF) == 0);
    802033c8:	fe843703          	ld	a4,-24(s0)
    802033cc:	6785                	lui	a5,0x1
    802033ce:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    802033d0:	8ff9                	and	a5,a5,a4
    802033d2:	0017b793          	seqz	a5,a5
    802033d6:	0ff7f793          	zext.b	a5,a5
    802033da:	2781                	sext.w	a5,a5
    802033dc:	853e                	mv	a0,a5
    802033de:	00000097          	auipc	ra,0x0
    802033e2:	dbe080e7          	jalr	-578(ra) # 8020319c <assert>
    assert(((uint64)page2 & 0xFFF) == 0);
    802033e6:	fe043703          	ld	a4,-32(s0)
    802033ea:	6785                	lui	a5,0x1
    802033ec:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    802033ee:	8ff9                	and	a5,a5,a4
    802033f0:	0017b793          	seqz	a5,a5
    802033f4:	0ff7f793          	zext.b	a5,a5
    802033f8:	2781                	sext.w	a5,a5
    802033fa:	853e                	mv	a0,a5
    802033fc:	00000097          	auipc	ra,0x0
    80203400:	da0080e7          	jalr	-608(ra) # 8020319c <assert>
    printf("[PM TEST] 分配测试通过\n");
    80203404:	00011517          	auipc	a0,0x11
    80203408:	65450513          	addi	a0,a0,1620 # 80214a58 <syscall_performance_bin+0x710>
    8020340c:	ffffe097          	auipc	ra,0xffffe
    80203410:	8ca080e7          	jalr	-1846(ra) # 80200cd6 <printf>
    printf("[PM TEST] 数据写入测试...\n");
    80203414:	00011517          	auipc	a0,0x11
    80203418:	66450513          	addi	a0,a0,1636 # 80214a78 <syscall_performance_bin+0x730>
    8020341c:	ffffe097          	auipc	ra,0xffffe
    80203420:	8ba080e7          	jalr	-1862(ra) # 80200cd6 <printf>
    *(int*)page1 = 0x12345678;
    80203424:	fe843783          	ld	a5,-24(s0)
    80203428:	12345737          	lui	a4,0x12345
    8020342c:	67870713          	addi	a4,a4,1656 # 12345678 <_entry-0x6deba988>
    80203430:	c398                	sw	a4,0(a5)
    assert(*(int*)page1 == 0x12345678);
    80203432:	fe843783          	ld	a5,-24(s0)
    80203436:	439c                	lw	a5,0(a5)
    80203438:	873e                	mv	a4,a5
    8020343a:	123457b7          	lui	a5,0x12345
    8020343e:	67878793          	addi	a5,a5,1656 # 12345678 <_entry-0x6deba988>
    80203442:	40f707b3          	sub	a5,a4,a5
    80203446:	0017b793          	seqz	a5,a5
    8020344a:	0ff7f793          	zext.b	a5,a5
    8020344e:	2781                	sext.w	a5,a5
    80203450:	853e                	mv	a0,a5
    80203452:	00000097          	auipc	ra,0x0
    80203456:	d4a080e7          	jalr	-694(ra) # 8020319c <assert>
    printf("[PM TEST] 数据写入测试通过\n");
    8020345a:	00011517          	auipc	a0,0x11
    8020345e:	64650513          	addi	a0,a0,1606 # 80214aa0 <syscall_performance_bin+0x758>
    80203462:	ffffe097          	auipc	ra,0xffffe
    80203466:	874080e7          	jalr	-1932(ra) # 80200cd6 <printf>
    printf("[PM TEST] 释放与重新分配测试...\n");
    8020346a:	00011517          	auipc	a0,0x11
    8020346e:	65e50513          	addi	a0,a0,1630 # 80214ac8 <syscall_performance_bin+0x780>
    80203472:	ffffe097          	auipc	ra,0xffffe
    80203476:	864080e7          	jalr	-1948(ra) # 80200cd6 <printf>
    free_page(page1);
    8020347a:	fe843503          	ld	a0,-24(s0)
    8020347e:	00000097          	auipc	ra,0x0
    80203482:	e56080e7          	jalr	-426(ra) # 802032d4 <free_page>
    void *page3 = alloc_page();
    80203486:	00000097          	auipc	ra,0x0
    8020348a:	de2080e7          	jalr	-542(ra) # 80203268 <alloc_page>
    8020348e:	fca43c23          	sd	a0,-40(s0)
    assert(page3 != 0);
    80203492:	fd843783          	ld	a5,-40(s0)
    80203496:	00f037b3          	snez	a5,a5
    8020349a:	0ff7f793          	zext.b	a5,a5
    8020349e:	2781                	sext.w	a5,a5
    802034a0:	853e                	mv	a0,a5
    802034a2:	00000097          	auipc	ra,0x0
    802034a6:	cfa080e7          	jalr	-774(ra) # 8020319c <assert>
    printf("[PM TEST] 释放与重新分配测试通过\n");
    802034aa:	00011517          	auipc	a0,0x11
    802034ae:	64e50513          	addi	a0,a0,1614 # 80214af8 <syscall_performance_bin+0x7b0>
    802034b2:	ffffe097          	auipc	ra,0xffffe
    802034b6:	824080e7          	jalr	-2012(ra) # 80200cd6 <printf>
    free_page(page2);
    802034ba:	fe043503          	ld	a0,-32(s0)
    802034be:	00000097          	auipc	ra,0x0
    802034c2:	e16080e7          	jalr	-490(ra) # 802032d4 <free_page>
    free_page(page3);
    802034c6:	fd843503          	ld	a0,-40(s0)
    802034ca:	00000097          	auipc	ra,0x0
    802034ce:	e0a080e7          	jalr	-502(ra) # 802032d4 <free_page>
    printf("[PM TEST] 所有物理内存管理测试通过\n");
    802034d2:	00011517          	auipc	a0,0x11
    802034d6:	65650513          	addi	a0,a0,1622 # 80214b28 <syscall_performance_bin+0x7e0>
    802034da:	ffffd097          	auipc	ra,0xffffd
    802034de:	7fc080e7          	jalr	2044(ra) # 80200cd6 <printf>
    802034e2:	0001                	nop
    802034e4:	70a2                	ld	ra,40(sp)
    802034e6:	7402                	ld	s0,32(sp)
    802034e8:	6145                	addi	sp,sp,48
    802034ea:	8082                	ret

00000000802034ec <sbi_set_time>:
#include "defs.h"

void sbi_set_time(uint64 time) {
    802034ec:	1101                	addi	sp,sp,-32
    802034ee:	ec22                	sd	s0,24(sp)
    802034f0:	1000                	addi	s0,sp,32
    802034f2:	fea43423          	sd	a0,-24(s0)
    register uint64 a0 asm("a0") = time;
    802034f6:	fe843503          	ld	a0,-24(s0)
    register uint64 a7 asm("a7") = SBI_SET_TIME;
    802034fa:	4881                	li	a7,0
    asm volatile ("ecall"
    802034fc:	00000073          	ecall
                  : "+r"(a0)
                  : "r"(a7)
                  : "memory");
}
    80203500:	0001                	nop
    80203502:	6462                	ld	s0,24(sp)
    80203504:	6105                	addi	sp,sp,32
    80203506:	8082                	ret

0000000080203508 <sbi_get_time>:
// 直接读取 time CSR 寄存器获取当前时间
uint64 sbi_get_time(void) {
    80203508:	1101                	addi	sp,sp,-32
    8020350a:	ec22                	sd	s0,24(sp)
    8020350c:	1000                	addi	s0,sp,32
    uint64 time_value;
    
    asm volatile ("rdtime %0" : "=r"(time_value));
    8020350e:	c01027f3          	rdtime	a5
    80203512:	fef43423          	sd	a5,-24(s0)
    
    return time_value;
    80203516:	fe843783          	ld	a5,-24(s0)
    8020351a:	853e                	mv	a0,a5
    8020351c:	6462                	ld	s0,24(sp)
    8020351e:	6105                	addi	sp,sp,32
    80203520:	8082                	ret

0000000080203522 <timeintr>:
#include "defs.h"

// 声明外部测试标志
extern volatile int *interrupt_test_flag;
void timeintr(void){
    80203522:	1141                	addi	sp,sp,-16
    80203524:	e422                	sd	s0,8(sp)
    80203526:	0800                	addi	s0,sp,16
	if (interrupt_test_flag)
    80203528:	00023797          	auipc	a5,0x23
    8020352c:	c4078793          	addi	a5,a5,-960 # 80226168 <interrupt_test_flag>
    80203530:	639c                	ld	a5,0(a5)
    80203532:	cb99                	beqz	a5,80203548 <timeintr+0x26>
        (*interrupt_test_flag)++;
    80203534:	00023797          	auipc	a5,0x23
    80203538:	c3478793          	addi	a5,a5,-972 # 80226168 <interrupt_test_flag>
    8020353c:	639c                	ld	a5,0(a5)
    8020353e:	4398                	lw	a4,0(a5)
    80203540:	2701                	sext.w	a4,a4
    80203542:	2705                	addiw	a4,a4,1
    80203544:	2701                	sext.w	a4,a4
    80203546:	c398                	sw	a4,0(a5)
    80203548:	0001                	nop
    8020354a:	6422                	ld	s0,8(sp)
    8020354c:	0141                	addi	sp,sp,16
    8020354e:	8082                	ret

0000000080203550 <r_sie>:
		case SYS_yield:
			tf->a0 =0;
			yield();
			break;
		case SYS_pid:
			tf->a0 = myproc()->pid;
    80203550:	1101                	addi	sp,sp,-32
    80203552:	ec22                	sd	s0,24(sp)
    80203554:	1000                	addi	s0,sp,32
			break;
		case SYS_ppid:
    80203556:	104027f3          	csrr	a5,sie
    8020355a:	fef43423          	sd	a5,-24(s0)
			tf->a0 = myproc()->parent ? myproc()->parent->pid : 0;
    8020355e:	fe843783          	ld	a5,-24(s0)
			break;
    80203562:	853e                	mv	a0,a5
    80203564:	6462                	ld	s0,24(sp)
    80203566:	6105                	addi	sp,sp,32
    80203568:	8082                	ret

000000008020356a <w_sie>:
		case SYS_get_time:
			tf->a0 = get_time();
    8020356a:	1101                	addi	sp,sp,-32
    8020356c:	ec22                	sd	s0,24(sp)
    8020356e:	1000                	addi	s0,sp,32
    80203570:	fea43423          	sd	a0,-24(s0)
			break;
    80203574:	fe843783          	ld	a5,-24(s0)
    80203578:	10479073          	csrw	sie,a5
		case SYS_step:
    8020357c:	0001                	nop
    8020357e:	6462                	ld	s0,24(sp)
    80203580:	6105                	addi	sp,sp,32
    80203582:	8082                	ret

0000000080203584 <r_sstatus>:
			tf->a0 = 0;
			printf("[syscall] step enabled but do nothing\n");
    80203584:	1101                	addi	sp,sp,-32
    80203586:	ec22                	sd	s0,24(sp)
    80203588:	1000                	addi	s0,sp,32
			break;
	case SYS_write: {
    8020358a:	100027f3          	csrr	a5,sstatus
    8020358e:	fef43423          	sd	a5,-24(s0)
		int fd = tf->a0;          // 文件描述符
    80203592:	fe843783          	ld	a5,-24(s0)
		char buf[128];            // 临时缓冲区
    80203596:	853e                	mv	a0,a5
    80203598:	6462                	ld	s0,24(sp)
    8020359a:	6105                	addi	sp,sp,32
    8020359c:	8082                	ret

000000008020359e <w_sstatus>:
		
    8020359e:	1101                	addi	sp,sp,-32
    802035a0:	ec22                	sd	s0,24(sp)
    802035a2:	1000                	addi	s0,sp,32
    802035a4:	fea43423          	sd	a0,-24(s0)
		// 目前只支持标准输出(fd=1)和标准错误(fd=2)
    802035a8:	fe843783          	ld	a5,-24(s0)
    802035ac:	10079073          	csrw	sstatus,a5
		if (fd != 1 && fd != 2) {
    802035b0:	0001                	nop
    802035b2:	6462                	ld	s0,24(sp)
    802035b4:	6105                	addi	sp,sp,32
    802035b6:	8082                	ret

00000000802035b8 <w_sscratch>:
			tf->a0 = -1;
    802035b8:	1101                	addi	sp,sp,-32
    802035ba:	ec22                	sd	s0,24(sp)
    802035bc:	1000                	addi	s0,sp,32
    802035be:	fea43423          	sd	a0,-24(s0)
			break;
    802035c2:	fe843783          	ld	a5,-24(s0)
    802035c6:	14079073          	csrw	sscratch,a5
		}
    802035ca:	0001                	nop
    802035cc:	6462                	ld	s0,24(sp)
    802035ce:	6105                	addi	sp,sp,32
    802035d0:	8082                	ret

00000000802035d2 <w_sepc>:
		
		// 检查用户提供的缓冲区地址是否合法
    802035d2:	1101                	addi	sp,sp,-32
    802035d4:	ec22                	sd	s0,24(sp)
    802035d6:	1000                	addi	s0,sp,32
    802035d8:	fea43423          	sd	a0,-24(s0)
		if (check_user_addr(tf->a1, tf->a2, 0) < 0) {
    802035dc:	fe843783          	ld	a5,-24(s0)
    802035e0:	14179073          	csrw	sepc,a5
			printf("[syscall] invalid write buffer address\n");
    802035e4:	0001                	nop
    802035e6:	6462                	ld	s0,24(sp)
    802035e8:	6105                	addi	sp,sp,32
    802035ea:	8082                	ret

00000000802035ec <intr_off>:
			tf->a0 = -1;
			break;
		}
		
		// 从用户空间安全地复制字符串
		if (copyinstr(buf, myproc()->pagetable, tf->a1, sizeof(buf)) < 0) {
    802035ec:	1141                	addi	sp,sp,-16
    802035ee:	e406                	sd	ra,8(sp)
    802035f0:	e022                	sd	s0,0(sp)
    802035f2:	0800                	addi	s0,sp,16
			printf("[syscall] invalid write buffer\n");
    802035f4:	00000097          	auipc	ra,0x0
    802035f8:	f90080e7          	jalr	-112(ra) # 80203584 <r_sstatus>
    802035fc:	87aa                	mv	a5,a0
    802035fe:	9bf5                	andi	a5,a5,-3
    80203600:	853e                	mv	a0,a5
    80203602:	00000097          	auipc	ra,0x0
    80203606:	f9c080e7          	jalr	-100(ra) # 8020359e <w_sstatus>
			tf->a0 = -1;
    8020360a:	0001                	nop
    8020360c:	60a2                	ld	ra,8(sp)
    8020360e:	6402                	ld	s0,0(sp)
    80203610:	0141                	addi	sp,sp,16
    80203612:	8082                	ret

0000000080203614 <w_stvec>:
			break;
		}
    80203614:	1101                	addi	sp,sp,-32
    80203616:	ec22                	sd	s0,24(sp)
    80203618:	1000                	addi	s0,sp,32
    8020361a:	fea43423          	sd	a0,-24(s0)
		
    8020361e:	fe843783          	ld	a5,-24(s0)
    80203622:	10579073          	csrw	stvec,a5
		// 输出到控制台
    80203626:	0001                	nop
    80203628:	6462                	ld	s0,24(sp)
    8020362a:	6105                	addi	sp,sp,32
    8020362c:	8082                	ret

000000008020362e <r_scause>:
		break;
	}

	case SYS_read: {
		int fd = tf->a0;          // 文件描述符
		uint64 buf = tf->a1;      // 用户缓冲区地址
    8020362e:	1101                	addi	sp,sp,-32
    80203630:	ec22                	sd	s0,24(sp)
    80203632:	1000                	addi	s0,sp,32
		int n = tf->a2;           // 要读取的字节数
		
    80203634:	142027f3          	csrr	a5,scause
    80203638:	fef43423          	sd	a5,-24(s0)
		// 目前只支持标准输入(fd=0)
    8020363c:	fe843783          	ld	a5,-24(s0)
		if (fd != 0) {
    80203640:	853e                	mv	a0,a5
    80203642:	6462                	ld	s0,24(sp)
    80203644:	6105                	addi	sp,sp,32
    80203646:	8082                	ret

0000000080203648 <r_sepc>:
			tf->a0 = -1;
			break;
    80203648:	1101                	addi	sp,sp,-32
    8020364a:	ec22                	sd	s0,24(sp)
    8020364c:	1000                	addi	s0,sp,32
		}
		
    8020364e:	141027f3          	csrr	a5,sepc
    80203652:	fef43423          	sd	a5,-24(s0)
		// 检查用户提供的缓冲区地址是否合法
    80203656:	fe843783          	ld	a5,-24(s0)
		if (check_user_addr(buf, n, 1) < 0) {  // 1表示写入访问
    8020365a:	853e                	mv	a0,a5
    8020365c:	6462                	ld	s0,24(sp)
    8020365e:	6105                	addi	sp,sp,32
    80203660:	8082                	ret

0000000080203662 <r_stval>:
			printf("[syscall] invalid read buffer address\n");
			tf->a0 = -1;
    80203662:	1101                	addi	sp,sp,-32
    80203664:	ec22                	sd	s0,24(sp)
    80203666:	1000                	addi	s0,sp,32
			break;
		}
    80203668:	143027f3          	csrr	a5,stval
    8020366c:	fef43423          	sd	a5,-24(s0)
		
    80203670:	fe843783          	ld	a5,-24(s0)
		// TODO: 实现从控制台读取
    80203674:	853e                	mv	a0,a5
    80203676:	6462                	ld	s0,24(sp)
    80203678:	6105                	addi	sp,sp,32
    8020367a:	8082                	ret

000000008020367c <save_exception_info>:
static inline void save_exception_info(struct trapframe *tf, uint64 sepc, uint64 sstatus, uint64 scause, uint64 stval) {
    8020367c:	7139                	addi	sp,sp,-64
    8020367e:	fc22                	sd	s0,56(sp)
    80203680:	0080                	addi	s0,sp,64
    80203682:	fea43423          	sd	a0,-24(s0)
    80203686:	feb43023          	sd	a1,-32(s0)
    8020368a:	fcc43c23          	sd	a2,-40(s0)
    8020368e:	fcd43823          	sd	a3,-48(s0)
    80203692:	fce43423          	sd	a4,-56(s0)
    tf->epc = sepc;
    80203696:	fe843783          	ld	a5,-24(s0)
    8020369a:	fe043703          	ld	a4,-32(s0)
    8020369e:	f398                	sd	a4,32(a5)
}
    802036a0:	0001                	nop
    802036a2:	7462                	ld	s0,56(sp)
    802036a4:	6121                	addi	sp,sp,64
    802036a6:	8082                	ret

00000000802036a8 <get_sepc>:
static inline uint64 get_sepc(struct trapframe *tf) {
    802036a8:	1101                	addi	sp,sp,-32
    802036aa:	ec22                	sd	s0,24(sp)
    802036ac:	1000                	addi	s0,sp,32
    802036ae:	fea43423          	sd	a0,-24(s0)
    return tf->epc;
    802036b2:	fe843783          	ld	a5,-24(s0)
    802036b6:	739c                	ld	a5,32(a5)
}
    802036b8:	853e                	mv	a0,a5
    802036ba:	6462                	ld	s0,24(sp)
    802036bc:	6105                	addi	sp,sp,32
    802036be:	8082                	ret

00000000802036c0 <set_sepc>:
static inline void set_sepc(struct trapframe *tf, uint64 sepc) {
    802036c0:	1101                	addi	sp,sp,-32
    802036c2:	ec22                	sd	s0,24(sp)
    802036c4:	1000                	addi	s0,sp,32
    802036c6:	fea43423          	sd	a0,-24(s0)
    802036ca:	feb43023          	sd	a1,-32(s0)
    tf->epc = sepc;
    802036ce:	fe843783          	ld	a5,-24(s0)
    802036d2:	fe043703          	ld	a4,-32(s0)
    802036d6:	f398                	sd	a4,32(a5)
}
    802036d8:	0001                	nop
    802036da:	6462                	ld	s0,24(sp)
    802036dc:	6105                	addi	sp,sp,32
    802036de:	8082                	ret

00000000802036e0 <register_interrupt>:
void register_interrupt(int irq, interrupt_handler_t h) {
    802036e0:	1101                	addi	sp,sp,-32
    802036e2:	ec22                	sd	s0,24(sp)
    802036e4:	1000                	addi	s0,sp,32
    802036e6:	87aa                	mv	a5,a0
    802036e8:	feb43023          	sd	a1,-32(s0)
    802036ec:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ){
    802036f0:	fec42783          	lw	a5,-20(s0)
    802036f4:	2781                	sext.w	a5,a5
    802036f6:	0207c563          	bltz	a5,80203720 <register_interrupt+0x40>
    802036fa:	fec42783          	lw	a5,-20(s0)
    802036fe:	0007871b          	sext.w	a4,a5
    80203702:	03f00793          	li	a5,63
    80203706:	00e7cd63          	blt	a5,a4,80203720 <register_interrupt+0x40>
        interrupt_vector[irq] = h;
    8020370a:	00023717          	auipc	a4,0x23
    8020370e:	c0e70713          	addi	a4,a4,-1010 # 80226318 <interrupt_vector>
    80203712:	fec42783          	lw	a5,-20(s0)
    80203716:	078e                	slli	a5,a5,0x3
    80203718:	97ba                	add	a5,a5,a4
    8020371a:	fe043703          	ld	a4,-32(s0)
    8020371e:	e398                	sd	a4,0(a5)
}
    80203720:	0001                	nop
    80203722:	6462                	ld	s0,24(sp)
    80203724:	6105                	addi	sp,sp,32
    80203726:	8082                	ret

0000000080203728 <unregister_interrupt>:
void unregister_interrupt(int irq) {
    80203728:	1101                	addi	sp,sp,-32
    8020372a:	ec22                	sd	s0,24(sp)
    8020372c:	1000                	addi	s0,sp,32
    8020372e:	87aa                	mv	a5,a0
    80203730:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ)
    80203734:	fec42783          	lw	a5,-20(s0)
    80203738:	2781                	sext.w	a5,a5
    8020373a:	0207c463          	bltz	a5,80203762 <unregister_interrupt+0x3a>
    8020373e:	fec42783          	lw	a5,-20(s0)
    80203742:	0007871b          	sext.w	a4,a5
    80203746:	03f00793          	li	a5,63
    8020374a:	00e7cc63          	blt	a5,a4,80203762 <unregister_interrupt+0x3a>
        interrupt_vector[irq] = 0;
    8020374e:	00023717          	auipc	a4,0x23
    80203752:	bca70713          	addi	a4,a4,-1078 # 80226318 <interrupt_vector>
    80203756:	fec42783          	lw	a5,-20(s0)
    8020375a:	078e                	slli	a5,a5,0x3
    8020375c:	97ba                	add	a5,a5,a4
    8020375e:	0007b023          	sd	zero,0(a5)
}
    80203762:	0001                	nop
    80203764:	6462                	ld	s0,24(sp)
    80203766:	6105                	addi	sp,sp,32
    80203768:	8082                	ret

000000008020376a <enable_interrupts>:
void enable_interrupts(int irq) {
    8020376a:	1101                	addi	sp,sp,-32
    8020376c:	ec06                	sd	ra,24(sp)
    8020376e:	e822                	sd	s0,16(sp)
    80203770:	1000                	addi	s0,sp,32
    80203772:	87aa                	mv	a5,a0
    80203774:	fef42623          	sw	a5,-20(s0)
    plic_enable(irq);
    80203778:	fec42783          	lw	a5,-20(s0)
    8020377c:	853e                	mv	a0,a5
    8020377e:	00001097          	auipc	ra,0x1
    80203782:	360080e7          	jalr	864(ra) # 80204ade <plic_enable>
}
    80203786:	0001                	nop
    80203788:	60e2                	ld	ra,24(sp)
    8020378a:	6442                	ld	s0,16(sp)
    8020378c:	6105                	addi	sp,sp,32
    8020378e:	8082                	ret

0000000080203790 <disable_interrupts>:
void disable_interrupts(int irq) {
    80203790:	1101                	addi	sp,sp,-32
    80203792:	ec06                	sd	ra,24(sp)
    80203794:	e822                	sd	s0,16(sp)
    80203796:	1000                	addi	s0,sp,32
    80203798:	87aa                	mv	a5,a0
    8020379a:	fef42623          	sw	a5,-20(s0)
    plic_disable(irq);
    8020379e:	fec42783          	lw	a5,-20(s0)
    802037a2:	853e                	mv	a0,a5
    802037a4:	00001097          	auipc	ra,0x1
    802037a8:	392080e7          	jalr	914(ra) # 80204b36 <plic_disable>
}
    802037ac:	0001                	nop
    802037ae:	60e2                	ld	ra,24(sp)
    802037b0:	6442                	ld	s0,16(sp)
    802037b2:	6105                	addi	sp,sp,32
    802037b4:	8082                	ret

00000000802037b6 <interrupt_dispatch>:
void interrupt_dispatch(int irq) {
    802037b6:	1101                	addi	sp,sp,-32
    802037b8:	ec06                	sd	ra,24(sp)
    802037ba:	e822                	sd	s0,16(sp)
    802037bc:	1000                	addi	s0,sp,32
    802037be:	87aa                	mv	a5,a0
    802037c0:	fef42623          	sw	a5,-20(s0)
	if (irq >= 0 && irq < MAX_IRQ && interrupt_vector[irq]){
    802037c4:	fec42783          	lw	a5,-20(s0)
    802037c8:	2781                	sext.w	a5,a5
    802037ca:	0207ce63          	bltz	a5,80203806 <interrupt_dispatch+0x50>
    802037ce:	fec42783          	lw	a5,-20(s0)
    802037d2:	0007871b          	sext.w	a4,a5
    802037d6:	03f00793          	li	a5,63
    802037da:	02e7c663          	blt	a5,a4,80203806 <interrupt_dispatch+0x50>
    802037de:	00023717          	auipc	a4,0x23
    802037e2:	b3a70713          	addi	a4,a4,-1222 # 80226318 <interrupt_vector>
    802037e6:	fec42783          	lw	a5,-20(s0)
    802037ea:	078e                	slli	a5,a5,0x3
    802037ec:	97ba                	add	a5,a5,a4
    802037ee:	639c                	ld	a5,0(a5)
    802037f0:	cb99                	beqz	a5,80203806 <interrupt_dispatch+0x50>
		interrupt_vector[irq]();
    802037f2:	00023717          	auipc	a4,0x23
    802037f6:	b2670713          	addi	a4,a4,-1242 # 80226318 <interrupt_vector>
    802037fa:	fec42783          	lw	a5,-20(s0)
    802037fe:	078e                	slli	a5,a5,0x3
    80203800:	97ba                	add	a5,a5,a4
    80203802:	639c                	ld	a5,0(a5)
    80203804:	9782                	jalr	a5
}
    80203806:	0001                	nop
    80203808:	60e2                	ld	ra,24(sp)
    8020380a:	6442                	ld	s0,16(sp)
    8020380c:	6105                	addi	sp,sp,32
    8020380e:	8082                	ret

0000000080203810 <handle_external_interrupt>:
void handle_external_interrupt(void) {
    80203810:	1101                	addi	sp,sp,-32
    80203812:	ec06                	sd	ra,24(sp)
    80203814:	e822                	sd	s0,16(sp)
    80203816:	1000                	addi	s0,sp,32
    int irq = plic_claim();
    80203818:	00001097          	auipc	ra,0x1
    8020381c:	37c080e7          	jalr	892(ra) # 80204b94 <plic_claim>
    80203820:	87aa                	mv	a5,a0
    80203822:	fef42623          	sw	a5,-20(s0)
    if (irq == 0) {
    80203826:	fec42783          	lw	a5,-20(s0)
    8020382a:	2781                	sext.w	a5,a5
    8020382c:	eb91                	bnez	a5,80203840 <handle_external_interrupt+0x30>
        printf("Spurious external interrupt\n");
    8020382e:	00017517          	auipc	a0,0x17
    80203832:	d1250513          	addi	a0,a0,-750 # 8021a540 <syscall_performance_bin+0x670>
    80203836:	ffffd097          	auipc	ra,0xffffd
    8020383a:	4a0080e7          	jalr	1184(ra) # 80200cd6 <printf>
        return;
    8020383e:	a839                	j	8020385c <handle_external_interrupt+0x4c>
    interrupt_dispatch(irq);
    80203840:	fec42783          	lw	a5,-20(s0)
    80203844:	853e                	mv	a0,a5
    80203846:	00000097          	auipc	ra,0x0
    8020384a:	f70080e7          	jalr	-144(ra) # 802037b6 <interrupt_dispatch>
    plic_complete(irq);
    8020384e:	fec42783          	lw	a5,-20(s0)
    80203852:	853e                	mv	a0,a5
    80203854:	00001097          	auipc	ra,0x1
    80203858:	368080e7          	jalr	872(ra) # 80204bbc <plic_complete>
}
    8020385c:	60e2                	ld	ra,24(sp)
    8020385e:	6442                	ld	s0,16(sp)
    80203860:	6105                	addi	sp,sp,32
    80203862:	8082                	ret

0000000080203864 <trap_init>:
void trap_init(void) {
    80203864:	1101                	addi	sp,sp,-32
    80203866:	ec06                	sd	ra,24(sp)
    80203868:	e822                	sd	s0,16(sp)
    8020386a:	1000                	addi	s0,sp,32
	intr_off();
    8020386c:	00000097          	auipc	ra,0x0
    80203870:	d80080e7          	jalr	-640(ra) # 802035ec <intr_off>
	printf("trap_init...\n");
    80203874:	00017517          	auipc	a0,0x17
    80203878:	cec50513          	addi	a0,a0,-788 # 8021a560 <syscall_performance_bin+0x690>
    8020387c:	ffffd097          	auipc	ra,0xffffd
    80203880:	45a080e7          	jalr	1114(ra) # 80200cd6 <printf>
	w_stvec((uint64)kernelvec);
    80203884:	00001797          	auipc	a5,0x1
    80203888:	36c78793          	addi	a5,a5,876 # 80204bf0 <kernelvec>
    8020388c:	853e                	mv	a0,a5
    8020388e:	00000097          	auipc	ra,0x0
    80203892:	d86080e7          	jalr	-634(ra) # 80203614 <w_stvec>
	for(int i = 0; i < MAX_IRQ; i++){
    80203896:	fe042623          	sw	zero,-20(s0)
    8020389a:	a005                	j	802038ba <trap_init+0x56>
		interrupt_vector[i] = 0;
    8020389c:	00023717          	auipc	a4,0x23
    802038a0:	a7c70713          	addi	a4,a4,-1412 # 80226318 <interrupt_vector>
    802038a4:	fec42783          	lw	a5,-20(s0)
    802038a8:	078e                	slli	a5,a5,0x3
    802038aa:	97ba                	add	a5,a5,a4
    802038ac:	0007b023          	sd	zero,0(a5)
	for(int i = 0; i < MAX_IRQ; i++){
    802038b0:	fec42783          	lw	a5,-20(s0)
    802038b4:	2785                	addiw	a5,a5,1
    802038b6:	fef42623          	sw	a5,-20(s0)
    802038ba:	fec42783          	lw	a5,-20(s0)
    802038be:	0007871b          	sext.w	a4,a5
    802038c2:	03f00793          	li	a5,63
    802038c6:	fce7dbe3          	bge	a5,a4,8020389c <trap_init+0x38>
	plic_init();// 初始化PLIC（外部中断控制器）
    802038ca:	00001097          	auipc	ra,0x1
    802038ce:	176080e7          	jalr	374(ra) # 80204a40 <plic_init>
    uint64 sie = r_sie();
    802038d2:	00000097          	auipc	ra,0x0
    802038d6:	c7e080e7          	jalr	-898(ra) # 80203550 <r_sie>
    802038da:	fea43023          	sd	a0,-32(s0)
    w_sie(sie | (1L << 5) | (1L<<9)); // 设置SIE.STIE位启用时钟中断和外部中断
    802038de:	fe043783          	ld	a5,-32(s0)
    802038e2:	2207e793          	ori	a5,a5,544
    802038e6:	853e                	mv	a0,a5
    802038e8:	00000097          	auipc	ra,0x0
    802038ec:	c82080e7          	jalr	-894(ra) # 8020356a <w_sie>
	sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    802038f0:	00000097          	auipc	ra,0x0
    802038f4:	c18080e7          	jalr	-1000(ra) # 80203508 <sbi_get_time>
    802038f8:	872a                	mv	a4,a0
    802038fa:	000f47b7          	lui	a5,0xf4
    802038fe:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    80203902:	97ba                	add	a5,a5,a4
    80203904:	853e                	mv	a0,a5
    80203906:	00000097          	auipc	ra,0x0
    8020390a:	be6080e7          	jalr	-1050(ra) # 802034ec <sbi_set_time>
	printf("Registered exception handlers: store_page_fault=%p\n", handle_store_page_fault);
    8020390e:	00001597          	auipc	a1,0x1
    80203912:	e6258593          	addi	a1,a1,-414 # 80204770 <handle_store_page_fault>
    80203916:	00017517          	auipc	a0,0x17
    8020391a:	c5a50513          	addi	a0,a0,-934 # 8021a570 <syscall_performance_bin+0x6a0>
    8020391e:	ffffd097          	auipc	ra,0xffffd
    80203922:	3b8080e7          	jalr	952(ra) # 80200cd6 <printf>
	printf("trap_init complete.\n");
    80203926:	00017517          	auipc	a0,0x17
    8020392a:	c8250513          	addi	a0,a0,-894 # 8021a5a8 <syscall_performance_bin+0x6d8>
    8020392e:	ffffd097          	auipc	ra,0xffffd
    80203932:	3a8080e7          	jalr	936(ra) # 80200cd6 <printf>
}
    80203936:	0001                	nop
    80203938:	60e2                	ld	ra,24(sp)
    8020393a:	6442                	ld	s0,16(sp)
    8020393c:	6105                	addi	sp,sp,32
    8020393e:	8082                	ret

0000000080203940 <kerneltrap>:
void kerneltrap(void) {
    80203940:	7149                	addi	sp,sp,-368
    80203942:	f686                	sd	ra,360(sp)
    80203944:	f2a2                	sd	s0,352(sp)
    80203946:	1a80                	addi	s0,sp,368
    uint64 sstatus = r_sstatus();
    80203948:	00000097          	auipc	ra,0x0
    8020394c:	c3c080e7          	jalr	-964(ra) # 80203584 <r_sstatus>
    80203950:	fea43023          	sd	a0,-32(s0)
    uint64 scause = r_scause();
    80203954:	00000097          	auipc	ra,0x0
    80203958:	cda080e7          	jalr	-806(ra) # 8020362e <r_scause>
    8020395c:	fca43c23          	sd	a0,-40(s0)
    uint64 sepc = r_sepc();
    80203960:	00000097          	auipc	ra,0x0
    80203964:	ce8080e7          	jalr	-792(ra) # 80203648 <r_sepc>
    80203968:	fea43423          	sd	a0,-24(s0)
    uint64 stval = r_stval();
    8020396c:	00000097          	auipc	ra,0x0
    80203970:	cf6080e7          	jalr	-778(ra) # 80203662 <r_stval>
    80203974:	fca43823          	sd	a0,-48(s0)
    if(scause & 0x8000000000000000) {
    80203978:	fd843783          	ld	a5,-40(s0)
    8020397c:	0807da63          	bgez	a5,80203a10 <kerneltrap+0xd0>
        if((scause & 0xff) == 5) {
    80203980:	fd843783          	ld	a5,-40(s0)
    80203984:	0ff7f713          	zext.b	a4,a5
    80203988:	4795                	li	a5,5
    8020398a:	04f71a63          	bne	a4,a5,802039de <kerneltrap+0x9e>
            timeintr();
    8020398e:	00000097          	auipc	ra,0x0
    80203992:	b94080e7          	jalr	-1132(ra) # 80203522 <timeintr>
            sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    80203996:	00000097          	auipc	ra,0x0
    8020399a:	b72080e7          	jalr	-1166(ra) # 80203508 <sbi_get_time>
    8020399e:	872a                	mv	a4,a0
    802039a0:	000f47b7          	lui	a5,0xf4
    802039a4:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    802039a8:	97ba                	add	a5,a5,a4
    802039aa:	853e                	mv	a0,a5
    802039ac:	00000097          	auipc	ra,0x0
    802039b0:	b40080e7          	jalr	-1216(ra) # 802034ec <sbi_set_time>
			if(myproc() && myproc()->state == RUNNING) {
    802039b4:	00001097          	auipc	ra,0x1
    802039b8:	56c080e7          	jalr	1388(ra) # 80204f20 <myproc>
    802039bc:	87aa                	mv	a5,a0
    802039be:	cbe9                	beqz	a5,80203a90 <kerneltrap+0x150>
    802039c0:	00001097          	auipc	ra,0x1
    802039c4:	560080e7          	jalr	1376(ra) # 80204f20 <myproc>
    802039c8:	87aa                	mv	a5,a0
    802039ca:	439c                	lw	a5,0(a5)
    802039cc:	873e                	mv	a4,a5
    802039ce:	4791                	li	a5,4
    802039d0:	0cf71063          	bne	a4,a5,80203a90 <kerneltrap+0x150>
				yield();  // 当前进程让出 CPU
    802039d4:	00002097          	auipc	ra,0x2
    802039d8:	0e6080e7          	jalr	230(ra) # 80205aba <yield>
    802039dc:	a855                	j	80203a90 <kerneltrap+0x150>
        } else if((scause & 0xff) == 9) {
    802039de:	fd843783          	ld	a5,-40(s0)
    802039e2:	0ff7f713          	zext.b	a4,a5
    802039e6:	47a5                	li	a5,9
    802039e8:	00f71763          	bne	a4,a5,802039f6 <kerneltrap+0xb6>
            handle_external_interrupt();
    802039ec:	00000097          	auipc	ra,0x0
    802039f0:	e24080e7          	jalr	-476(ra) # 80203810 <handle_external_interrupt>
    802039f4:	a871                	j	80203a90 <kerneltrap+0x150>
            printf("kerneltrap: unknown interrupt scause=%lx sepc=%lx\n", scause, sepc);
    802039f6:	fe843603          	ld	a2,-24(s0)
    802039fa:	fd843583          	ld	a1,-40(s0)
    802039fe:	00017517          	auipc	a0,0x17
    80203a02:	bc250513          	addi	a0,a0,-1086 # 8021a5c0 <syscall_performance_bin+0x6f0>
    80203a06:	ffffd097          	auipc	ra,0xffffd
    80203a0a:	2d0080e7          	jalr	720(ra) # 80200cd6 <printf>
    80203a0e:	a049                	j	80203a90 <kerneltrap+0x150>
        printf("Exception: scause=%ld, sepc=0x%lx, stval=0x%lx\n", scause, sepc, stval);
    80203a10:	fd043683          	ld	a3,-48(s0)
    80203a14:	fe843603          	ld	a2,-24(s0)
    80203a18:	fd843583          	ld	a1,-40(s0)
    80203a1c:	00017517          	auipc	a0,0x17
    80203a20:	bdc50513          	addi	a0,a0,-1060 # 8021a5f8 <syscall_performance_bin+0x728>
    80203a24:	ffffd097          	auipc	ra,0xffffd
    80203a28:	2b2080e7          	jalr	690(ra) # 80200cd6 <printf>
        save_exception_info(&tf, sepc, sstatus, scause, stval);
    80203a2c:	eb840793          	addi	a5,s0,-328
    80203a30:	fd043703          	ld	a4,-48(s0)
    80203a34:	fd843683          	ld	a3,-40(s0)
    80203a38:	fe043603          	ld	a2,-32(s0)
    80203a3c:	fe843583          	ld	a1,-24(s0)
    80203a40:	853e                	mv	a0,a5
    80203a42:	00000097          	auipc	ra,0x0
    80203a46:	c3a080e7          	jalr	-966(ra) # 8020367c <save_exception_info>
        info.sepc = sepc;
    80203a4a:	fe843783          	ld	a5,-24(s0)
    80203a4e:	e8f43c23          	sd	a5,-360(s0)
        info.sstatus = sstatus;
    80203a52:	fe043783          	ld	a5,-32(s0)
    80203a56:	eaf43023          	sd	a5,-352(s0)
        info.scause = scause;
    80203a5a:	fd843783          	ld	a5,-40(s0)
    80203a5e:	eaf43423          	sd	a5,-344(s0)
        info.stval = stval;
    80203a62:	fd043783          	ld	a5,-48(s0)
    80203a66:	eaf43823          	sd	a5,-336(s0)
        handle_exception(&tf, &info);
    80203a6a:	e9840713          	addi	a4,s0,-360
    80203a6e:	eb840793          	addi	a5,s0,-328
    80203a72:	85ba                	mv	a1,a4
    80203a74:	853e                	mv	a0,a5
    80203a76:	00000097          	auipc	ra,0x0
    80203a7a:	03c080e7          	jalr	60(ra) # 80203ab2 <handle_exception>
        sepc = get_sepc(&tf);
    80203a7e:	eb840793          	addi	a5,s0,-328
    80203a82:	853e                	mv	a0,a5
    80203a84:	00000097          	auipc	ra,0x0
    80203a88:	c24080e7          	jalr	-988(ra) # 802036a8 <get_sepc>
    80203a8c:	fea43423          	sd	a0,-24(s0)
    w_sepc(sepc);
    80203a90:	fe843503          	ld	a0,-24(s0)
    80203a94:	00000097          	auipc	ra,0x0
    80203a98:	b3e080e7          	jalr	-1218(ra) # 802035d2 <w_sepc>
    w_sstatus(sstatus);
    80203a9c:	fe043503          	ld	a0,-32(s0)
    80203aa0:	00000097          	auipc	ra,0x0
    80203aa4:	afe080e7          	jalr	-1282(ra) # 8020359e <w_sstatus>
}
    80203aa8:	0001                	nop
    80203aaa:	70b6                	ld	ra,360(sp)
    80203aac:	7416                	ld	s0,352(sp)
    80203aae:	6175                	addi	sp,sp,368
    80203ab0:	8082                	ret

0000000080203ab2 <handle_exception>:
void handle_exception(struct trapframe *tf, struct trap_info *info) {
    80203ab2:	7139                	addi	sp,sp,-64
    80203ab4:	fc06                	sd	ra,56(sp)
    80203ab6:	f822                	sd	s0,48(sp)
    80203ab8:	0080                	addi	s0,sp,64
    80203aba:	fca43423          	sd	a0,-56(s0)
    80203abe:	fcb43023          	sd	a1,-64(s0)
    uint64 cause = info->scause;  // 使用info中的字段
    80203ac2:	fc043783          	ld	a5,-64(s0)
    80203ac6:	6b9c                	ld	a5,16(a5)
    80203ac8:	fef43423          	sd	a5,-24(s0)
    switch (cause) {
    80203acc:	fe843703          	ld	a4,-24(s0)
    80203ad0:	47bd                	li	a5,15
    80203ad2:	3ee7e763          	bltu	a5,a4,80203ec0 <handle_exception+0x40e>
    80203ad6:	fe843783          	ld	a5,-24(s0)
    80203ada:	00279713          	slli	a4,a5,0x2
    80203ade:	00017797          	auipc	a5,0x17
    80203ae2:	d2e78793          	addi	a5,a5,-722 # 8021a80c <syscall_performance_bin+0x93c>
    80203ae6:	97ba                	add	a5,a5,a4
    80203ae8:	439c                	lw	a5,0(a5)
    80203aea:	0007871b          	sext.w	a4,a5
    80203aee:	00017797          	auipc	a5,0x17
    80203af2:	d1e78793          	addi	a5,a5,-738 # 8021a80c <syscall_performance_bin+0x93c>
    80203af6:	97ba                	add	a5,a5,a4
    80203af8:	8782                	jr	a5
            printf("Instruction address misaligned: 0x%lx\n", info->stval);
    80203afa:	fc043783          	ld	a5,-64(s0)
    80203afe:	6f9c                	ld	a5,24(a5)
    80203b00:	85be                	mv	a1,a5
    80203b02:	00017517          	auipc	a0,0x17
    80203b06:	b2650513          	addi	a0,a0,-1242 # 8021a628 <syscall_performance_bin+0x758>
    80203b0a:	ffffd097          	auipc	ra,0xffffd
    80203b0e:	1cc080e7          	jalr	460(ra) # 80200cd6 <printf>
			if(myproc()->is_user){
    80203b12:	00001097          	auipc	ra,0x1
    80203b16:	40e080e7          	jalr	1038(ra) # 80204f20 <myproc>
    80203b1a:	87aa                	mv	a5,a0
    80203b1c:	0a87a783          	lw	a5,168(a5)
    80203b20:	c791                	beqz	a5,80203b2c <handle_exception+0x7a>
				exit_proc(-1);
    80203b22:	557d                	li	a0,-1
    80203b24:	00002097          	auipc	ra,0x2
    80203b28:	1a4080e7          	jalr	420(ra) # 80205cc8 <exit_proc>
			set_sepc(tf, info->sepc + 4);  // 使用辅助函数
    80203b2c:	fc043783          	ld	a5,-64(s0)
    80203b30:	639c                	ld	a5,0(a5)
    80203b32:	0791                	addi	a5,a5,4
    80203b34:	85be                	mv	a1,a5
    80203b36:	fc843503          	ld	a0,-56(s0)
    80203b3a:	00000097          	auipc	ra,0x0
    80203b3e:	b86080e7          	jalr	-1146(ra) # 802036c0 <set_sepc>
            break;
    80203b42:	ae6d                	j	80203efc <handle_exception+0x44a>
            printf("Instruction access fault: 0x%lx\n", info->stval);
    80203b44:	fc043783          	ld	a5,-64(s0)
    80203b48:	6f9c                	ld	a5,24(a5)
    80203b4a:	85be                	mv	a1,a5
    80203b4c:	00017517          	auipc	a0,0x17
    80203b50:	b0450513          	addi	a0,a0,-1276 # 8021a650 <syscall_performance_bin+0x780>
    80203b54:	ffffd097          	auipc	ra,0xffffd
    80203b58:	182080e7          	jalr	386(ra) # 80200cd6 <printf>
			if(myproc()->is_user){
    80203b5c:	00001097          	auipc	ra,0x1
    80203b60:	3c4080e7          	jalr	964(ra) # 80204f20 <myproc>
    80203b64:	87aa                	mv	a5,a0
    80203b66:	0a87a783          	lw	a5,168(a5)
    80203b6a:	c791                	beqz	a5,80203b76 <handle_exception+0xc4>
				exit_proc(-1);
    80203b6c:	557d                	li	a0,-1
    80203b6e:	00002097          	auipc	ra,0x2
    80203b72:	15a080e7          	jalr	346(ra) # 80205cc8 <exit_proc>
			set_sepc(tf, info->sepc + 4);  // 使用辅助函数
    80203b76:	fc043783          	ld	a5,-64(s0)
    80203b7a:	639c                	ld	a5,0(a5)
    80203b7c:	0791                	addi	a5,a5,4
    80203b7e:	85be                	mv	a1,a5
    80203b80:	fc843503          	ld	a0,-56(s0)
    80203b84:	00000097          	auipc	ra,0x0
    80203b88:	b3c080e7          	jalr	-1220(ra) # 802036c0 <set_sepc>
            break;
    80203b8c:	ae85                	j	80203efc <handle_exception+0x44a>
			if (copyin((char*)&instruction, (uint64)info->sepc, 4) == 0) {
    80203b8e:	fc043783          	ld	a5,-64(s0)
    80203b92:	6398                	ld	a4,0(a5)
    80203b94:	fdc40793          	addi	a5,s0,-36
    80203b98:	4611                	li	a2,4
    80203b9a:	85ba                	mv	a1,a4
    80203b9c:	853e                	mv	a0,a5
    80203b9e:	00000097          	auipc	ra,0x0
    80203ba2:	3da080e7          	jalr	986(ra) # 80203f78 <copyin>
    80203ba6:	87aa                	mv	a5,a0
    80203ba8:	ebcd                	bnez	a5,80203c5a <handle_exception+0x1a8>
				uint32_t opcode = instruction & 0x7f;
    80203baa:	fdc42783          	lw	a5,-36(s0)
    80203bae:	07f7f793          	andi	a5,a5,127
    80203bb2:	fef42223          	sw	a5,-28(s0)
				uint32_t funct3 = (instruction >> 12) & 0x7;
    80203bb6:	fdc42783          	lw	a5,-36(s0)
    80203bba:	00c7d79b          	srliw	a5,a5,0xc
    80203bbe:	2781                	sext.w	a5,a5
    80203bc0:	8b9d                	andi	a5,a5,7
    80203bc2:	fef42023          	sw	a5,-32(s0)
				if (opcode == 0x33 && (funct3 == 0x4 || funct3 == 0x5 || 
    80203bc6:	fe442783          	lw	a5,-28(s0)
    80203bca:	0007871b          	sext.w	a4,a5
    80203bce:	03300793          	li	a5,51
    80203bd2:	06f71363          	bne	a4,a5,80203c38 <handle_exception+0x186>
    80203bd6:	fe042783          	lw	a5,-32(s0)
    80203bda:	0007871b          	sext.w	a4,a5
    80203bde:	4791                	li	a5,4
    80203be0:	02f70763          	beq	a4,a5,80203c0e <handle_exception+0x15c>
    80203be4:	fe042783          	lw	a5,-32(s0)
    80203be8:	0007871b          	sext.w	a4,a5
    80203bec:	4795                	li	a5,5
    80203bee:	02f70063          	beq	a4,a5,80203c0e <handle_exception+0x15c>
    80203bf2:	fe042783          	lw	a5,-32(s0)
    80203bf6:	0007871b          	sext.w	a4,a5
    80203bfa:	4799                	li	a5,6
    80203bfc:	00f70963          	beq	a4,a5,80203c0e <handle_exception+0x15c>
					funct3 == 0x6 || funct3 == 0x7)) {
    80203c00:	fe042783          	lw	a5,-32(s0)
    80203c04:	0007871b          	sext.w	a4,a5
    80203c08:	479d                	li	a5,7
    80203c0a:	02f71763          	bne	a4,a5,80203c38 <handle_exception+0x186>
					printf("[FATAL] Process %d killed by divide by zero\n", myproc()->pid);
    80203c0e:	00001097          	auipc	ra,0x1
    80203c12:	312080e7          	jalr	786(ra) # 80204f20 <myproc>
    80203c16:	87aa                	mv	a5,a0
    80203c18:	43dc                	lw	a5,4(a5)
    80203c1a:	85be                	mv	a1,a5
    80203c1c:	00017517          	auipc	a0,0x17
    80203c20:	a5c50513          	addi	a0,a0,-1444 # 8021a678 <syscall_performance_bin+0x7a8>
    80203c24:	ffffd097          	auipc	ra,0xffffd
    80203c28:	0b2080e7          	jalr	178(ra) # 80200cd6 <printf>
            		exit_proc(-1);  // 直接终止进程
    80203c2c:	557d                	li	a0,-1
    80203c2e:	00002097          	auipc	ra,0x2
    80203c32:	09a080e7          	jalr	154(ra) # 80205cc8 <exit_proc>
    80203c36:	a091                	j	80203c7a <handle_exception+0x1c8>
					printf("Illegal instruction at 0x%lx: 0x%lx\n", 
    80203c38:	fc043783          	ld	a5,-64(s0)
    80203c3c:	6398                	ld	a4,0(a5)
    80203c3e:	fc043783          	ld	a5,-64(s0)
    80203c42:	6f9c                	ld	a5,24(a5)
    80203c44:	863e                	mv	a2,a5
    80203c46:	85ba                	mv	a1,a4
    80203c48:	00017517          	auipc	a0,0x17
    80203c4c:	a6050513          	addi	a0,a0,-1440 # 8021a6a8 <syscall_performance_bin+0x7d8>
    80203c50:	ffffd097          	auipc	ra,0xffffd
    80203c54:	086080e7          	jalr	134(ra) # 80200cd6 <printf>
    80203c58:	a00d                	j	80203c7a <handle_exception+0x1c8>
				printf("Illegal instruction at 0x%lx: 0x%lx\n", 
    80203c5a:	fc043783          	ld	a5,-64(s0)
    80203c5e:	6398                	ld	a4,0(a5)
    80203c60:	fc043783          	ld	a5,-64(s0)
    80203c64:	6f9c                	ld	a5,24(a5)
    80203c66:	863e                	mv	a2,a5
    80203c68:	85ba                	mv	a1,a4
    80203c6a:	00017517          	auipc	a0,0x17
    80203c6e:	a3e50513          	addi	a0,a0,-1474 # 8021a6a8 <syscall_performance_bin+0x7d8>
    80203c72:	ffffd097          	auipc	ra,0xffffd
    80203c76:	064080e7          	jalr	100(ra) # 80200cd6 <printf>
			if(myproc()->is_user){
    80203c7a:	00001097          	auipc	ra,0x1
    80203c7e:	2a6080e7          	jalr	678(ra) # 80204f20 <myproc>
    80203c82:	87aa                	mv	a5,a0
    80203c84:	0a87a783          	lw	a5,168(a5)
    80203c88:	c791                	beqz	a5,80203c94 <handle_exception+0x1e2>
				exit_proc(-1);
    80203c8a:	557d                	li	a0,-1
    80203c8c:	00002097          	auipc	ra,0x2
    80203c90:	03c080e7          	jalr	60(ra) # 80205cc8 <exit_proc>
			set_sepc(tf, info->sepc + 4); 
    80203c94:	fc043783          	ld	a5,-64(s0)
    80203c98:	639c                	ld	a5,0(a5)
    80203c9a:	0791                	addi	a5,a5,4
    80203c9c:	85be                	mv	a1,a5
    80203c9e:	fc843503          	ld	a0,-56(s0)
    80203ca2:	00000097          	auipc	ra,0x0
    80203ca6:	a1e080e7          	jalr	-1506(ra) # 802036c0 <set_sepc>
			break;
    80203caa:	ac89                	j	80203efc <handle_exception+0x44a>
            printf("Breakpoint at 0x%lx\n", info->sepc);
    80203cac:	fc043783          	ld	a5,-64(s0)
    80203cb0:	639c                	ld	a5,0(a5)
    80203cb2:	85be                	mv	a1,a5
    80203cb4:	00017517          	auipc	a0,0x17
    80203cb8:	a1c50513          	addi	a0,a0,-1508 # 8021a6d0 <syscall_performance_bin+0x800>
    80203cbc:	ffffd097          	auipc	ra,0xffffd
    80203cc0:	01a080e7          	jalr	26(ra) # 80200cd6 <printf>
            set_sepc(tf, info->sepc + 4);
    80203cc4:	fc043783          	ld	a5,-64(s0)
    80203cc8:	639c                	ld	a5,0(a5)
    80203cca:	0791                	addi	a5,a5,4
    80203ccc:	85be                	mv	a1,a5
    80203cce:	fc843503          	ld	a0,-56(s0)
    80203cd2:	00000097          	auipc	ra,0x0
    80203cd6:	9ee080e7          	jalr	-1554(ra) # 802036c0 <set_sepc>
            break;
    80203cda:	a40d                	j	80203efc <handle_exception+0x44a>
            printf("Load address misaligned: 0x%lx\n", info->stval);
    80203cdc:	fc043783          	ld	a5,-64(s0)
    80203ce0:	6f9c                	ld	a5,24(a5)
    80203ce2:	85be                	mv	a1,a5
    80203ce4:	00017517          	auipc	a0,0x17
    80203ce8:	a0450513          	addi	a0,a0,-1532 # 8021a6e8 <syscall_performance_bin+0x818>
    80203cec:	ffffd097          	auipc	ra,0xffffd
    80203cf0:	fea080e7          	jalr	-22(ra) # 80200cd6 <printf>
			if(myproc()->is_user){
    80203cf4:	00001097          	auipc	ra,0x1
    80203cf8:	22c080e7          	jalr	556(ra) # 80204f20 <myproc>
    80203cfc:	87aa                	mv	a5,a0
    80203cfe:	0a87a783          	lw	a5,168(a5)
    80203d02:	c791                	beqz	a5,80203d0e <handle_exception+0x25c>
				exit_proc(-1);
    80203d04:	557d                	li	a0,-1
    80203d06:	00002097          	auipc	ra,0x2
    80203d0a:	fc2080e7          	jalr	-62(ra) # 80205cc8 <exit_proc>
			set_sepc(tf, info->sepc + 4); 
    80203d0e:	fc043783          	ld	a5,-64(s0)
    80203d12:	639c                	ld	a5,0(a5)
    80203d14:	0791                	addi	a5,a5,4
    80203d16:	85be                	mv	a1,a5
    80203d18:	fc843503          	ld	a0,-56(s0)
    80203d1c:	00000097          	auipc	ra,0x0
    80203d20:	9a4080e7          	jalr	-1628(ra) # 802036c0 <set_sepc>
            break;
    80203d24:	aae1                	j	80203efc <handle_exception+0x44a>
			printf("Load access fault: 0x%lx\n", info->stval);
    80203d26:	fc043783          	ld	a5,-64(s0)
    80203d2a:	6f9c                	ld	a5,24(a5)
    80203d2c:	85be                	mv	a1,a5
    80203d2e:	00017517          	auipc	a0,0x17
    80203d32:	9da50513          	addi	a0,a0,-1574 # 8021a708 <syscall_performance_bin+0x838>
    80203d36:	ffffd097          	auipc	ra,0xffffd
    80203d3a:	fa0080e7          	jalr	-96(ra) # 80200cd6 <printf>
			if (check_is_mapped(info->stval) && handle_page_fault(info->stval, 2)) {
    80203d3e:	fc043783          	ld	a5,-64(s0)
    80203d42:	6f9c                	ld	a5,24(a5)
    80203d44:	853e                	mv	a0,a5
    80203d46:	fffff097          	auipc	ra,0xfffff
    80203d4a:	2da080e7          	jalr	730(ra) # 80203020 <check_is_mapped>
    80203d4e:	87aa                	mv	a5,a0
    80203d50:	cf89                	beqz	a5,80203d6a <handle_exception+0x2b8>
    80203d52:	fc043783          	ld	a5,-64(s0)
    80203d56:	6f9c                	ld	a5,24(a5)
    80203d58:	4589                	li	a1,2
    80203d5a:	853e                	mv	a0,a5
    80203d5c:	fffff097          	auipc	ra,0xfffff
    80203d60:	c68080e7          	jalr	-920(ra) # 802029c4 <handle_page_fault>
    80203d64:	87aa                	mv	a5,a0
    80203d66:	18079863          	bnez	a5,80203ef6 <handle_exception+0x444>
			set_sepc(tf, info->sepc + 4);
    80203d6a:	fc043783          	ld	a5,-64(s0)
    80203d6e:	639c                	ld	a5,0(a5)
    80203d70:	0791                	addi	a5,a5,4
    80203d72:	85be                	mv	a1,a5
    80203d74:	fc843503          	ld	a0,-56(s0)
    80203d78:	00000097          	auipc	ra,0x0
    80203d7c:	948080e7          	jalr	-1720(ra) # 802036c0 <set_sepc>
			break;
    80203d80:	aab5                	j	80203efc <handle_exception+0x44a>
            printf("Store address misaligned: 0x%lx\n", info->stval);
    80203d82:	fc043783          	ld	a5,-64(s0)
    80203d86:	6f9c                	ld	a5,24(a5)
    80203d88:	85be                	mv	a1,a5
    80203d8a:	00017517          	auipc	a0,0x17
    80203d8e:	99e50513          	addi	a0,a0,-1634 # 8021a728 <syscall_performance_bin+0x858>
    80203d92:	ffffd097          	auipc	ra,0xffffd
    80203d96:	f44080e7          	jalr	-188(ra) # 80200cd6 <printf>
			if(myproc()->is_user){
    80203d9a:	00001097          	auipc	ra,0x1
    80203d9e:	186080e7          	jalr	390(ra) # 80204f20 <myproc>
    80203da2:	87aa                	mv	a5,a0
    80203da4:	0a87a783          	lw	a5,168(a5)
    80203da8:	c791                	beqz	a5,80203db4 <handle_exception+0x302>
				exit_proc(-1);
    80203daa:	557d                	li	a0,-1
    80203dac:	00002097          	auipc	ra,0x2
    80203db0:	f1c080e7          	jalr	-228(ra) # 80205cc8 <exit_proc>
			set_sepc(tf, info->sepc + 4); 
    80203db4:	fc043783          	ld	a5,-64(s0)
    80203db8:	639c                	ld	a5,0(a5)
    80203dba:	0791                	addi	a5,a5,4
    80203dbc:	85be                	mv	a1,a5
    80203dbe:	fc843503          	ld	a0,-56(s0)
    80203dc2:	00000097          	auipc	ra,0x0
    80203dc6:	8fe080e7          	jalr	-1794(ra) # 802036c0 <set_sepc>
            break;
    80203dca:	aa0d                	j	80203efc <handle_exception+0x44a>
			printf("Store access fault: 0x%lx\n", info->stval);
    80203dcc:	fc043783          	ld	a5,-64(s0)
    80203dd0:	6f9c                	ld	a5,24(a5)
    80203dd2:	85be                	mv	a1,a5
    80203dd4:	00017517          	auipc	a0,0x17
    80203dd8:	97c50513          	addi	a0,a0,-1668 # 8021a750 <syscall_performance_bin+0x880>
    80203ddc:	ffffd097          	auipc	ra,0xffffd
    80203de0:	efa080e7          	jalr	-262(ra) # 80200cd6 <printf>
			if (check_is_mapped(info->stval) && handle_page_fault(info->stval, 3)) {
    80203de4:	fc043783          	ld	a5,-64(s0)
    80203de8:	6f9c                	ld	a5,24(a5)
    80203dea:	853e                	mv	a0,a5
    80203dec:	fffff097          	auipc	ra,0xfffff
    80203df0:	234080e7          	jalr	564(ra) # 80203020 <check_is_mapped>
    80203df4:	87aa                	mv	a5,a0
    80203df6:	cf81                	beqz	a5,80203e0e <handle_exception+0x35c>
    80203df8:	fc043783          	ld	a5,-64(s0)
    80203dfc:	6f9c                	ld	a5,24(a5)
    80203dfe:	458d                	li	a1,3
    80203e00:	853e                	mv	a0,a5
    80203e02:	fffff097          	auipc	ra,0xfffff
    80203e06:	bc2080e7          	jalr	-1086(ra) # 802029c4 <handle_page_fault>
    80203e0a:	87aa                	mv	a5,a0
    80203e0c:	e7fd                	bnez	a5,80203efa <handle_exception+0x448>
			set_sepc(tf, info->sepc + 4);
    80203e0e:	fc043783          	ld	a5,-64(s0)
    80203e12:	639c                	ld	a5,0(a5)
    80203e14:	0791                	addi	a5,a5,4
    80203e16:	85be                	mv	a1,a5
    80203e18:	fc843503          	ld	a0,-56(s0)
    80203e1c:	00000097          	auipc	ra,0x0
    80203e20:	8a4080e7          	jalr	-1884(ra) # 802036c0 <set_sepc>
			break;
    80203e24:	a8e1                	j	80203efc <handle_exception+0x44a>
			if(myproc()->is_user){
    80203e26:	00001097          	auipc	ra,0x1
    80203e2a:	0fa080e7          	jalr	250(ra) # 80204f20 <myproc>
    80203e2e:	87aa                	mv	a5,a0
    80203e30:	0a87a783          	lw	a5,168(a5)
    80203e34:	cb91                	beqz	a5,80203e48 <handle_exception+0x396>
            	handle_syscall(tf,info);
    80203e36:	fc043583          	ld	a1,-64(s0)
    80203e3a:	fc843503          	ld	a0,-56(s0)
    80203e3e:	00000097          	auipc	ra,0x0
    80203e42:	40c080e7          	jalr	1036(ra) # 8020424a <handle_syscall>
            break;
    80203e46:	a85d                	j	80203efc <handle_exception+0x44a>
				warning("[EXCEPTION] ecall was called in S-mode");
    80203e48:	00017517          	auipc	a0,0x17
    80203e4c:	92850513          	addi	a0,a0,-1752 # 8021a770 <syscall_performance_bin+0x8a0>
    80203e50:	ffffe097          	auipc	ra,0xffffe
    80203e54:	906080e7          	jalr	-1786(ra) # 80201756 <warning>
            break;
    80203e58:	a055                	j	80203efc <handle_exception+0x44a>
            printf("Supervisor environment call at 0x%lx\n", info->sepc);
    80203e5a:	fc043783          	ld	a5,-64(s0)
    80203e5e:	639c                	ld	a5,0(a5)
    80203e60:	85be                	mv	a1,a5
    80203e62:	00017517          	auipc	a0,0x17
    80203e66:	93650513          	addi	a0,a0,-1738 # 8021a798 <syscall_performance_bin+0x8c8>
    80203e6a:	ffffd097          	auipc	ra,0xffffd
    80203e6e:	e6c080e7          	jalr	-404(ra) # 80200cd6 <printf>
			set_sepc(tf, info->sepc + 4); 
    80203e72:	fc043783          	ld	a5,-64(s0)
    80203e76:	639c                	ld	a5,0(a5)
    80203e78:	0791                	addi	a5,a5,4
    80203e7a:	85be                	mv	a1,a5
    80203e7c:	fc843503          	ld	a0,-56(s0)
    80203e80:	00000097          	auipc	ra,0x0
    80203e84:	840080e7          	jalr	-1984(ra) # 802036c0 <set_sepc>
            break;
    80203e88:	a895                	j	80203efc <handle_exception+0x44a>
            handle_instruction_page_fault(tf,info);
    80203e8a:	fc043583          	ld	a1,-64(s0)
    80203e8e:	fc843503          	ld	a0,-56(s0)
    80203e92:	00001097          	auipc	ra,0x1
    80203e96:	81a080e7          	jalr	-2022(ra) # 802046ac <handle_instruction_page_fault>
            break;
    80203e9a:	a08d                	j	80203efc <handle_exception+0x44a>
            handle_load_page_fault(tf,info);
    80203e9c:	fc043583          	ld	a1,-64(s0)
    80203ea0:	fc843503          	ld	a0,-56(s0)
    80203ea4:	00001097          	auipc	ra,0x1
    80203ea8:	86a080e7          	jalr	-1942(ra) # 8020470e <handle_load_page_fault>
            break;
    80203eac:	a881                	j	80203efc <handle_exception+0x44a>
            handle_store_page_fault(tf,info);
    80203eae:	fc043583          	ld	a1,-64(s0)
    80203eb2:	fc843503          	ld	a0,-56(s0)
    80203eb6:	00001097          	auipc	ra,0x1
    80203eba:	8ba080e7          	jalr	-1862(ra) # 80204770 <handle_store_page_fault>
            break;
    80203ebe:	a83d                	j	80203efc <handle_exception+0x44a>
            printf("Unknown exception: cause=%ld, sepc=0x%lx, stval=0x%lx\n", 
    80203ec0:	fc043783          	ld	a5,-64(s0)
    80203ec4:	6398                	ld	a4,0(a5)
    80203ec6:	fc043783          	ld	a5,-64(s0)
    80203eca:	6f9c                	ld	a5,24(a5)
    80203ecc:	86be                	mv	a3,a5
    80203ece:	863a                	mv	a2,a4
    80203ed0:	fe843583          	ld	a1,-24(s0)
    80203ed4:	00017517          	auipc	a0,0x17
    80203ed8:	8ec50513          	addi	a0,a0,-1812 # 8021a7c0 <syscall_performance_bin+0x8f0>
    80203edc:	ffffd097          	auipc	ra,0xffffd
    80203ee0:	dfa080e7          	jalr	-518(ra) # 80200cd6 <printf>
            panic("Unknown exception");
    80203ee4:	00017517          	auipc	a0,0x17
    80203ee8:	91450513          	addi	a0,a0,-1772 # 8021a7f8 <syscall_performance_bin+0x928>
    80203eec:	ffffe097          	auipc	ra,0xffffe
    80203ef0:	836080e7          	jalr	-1994(ra) # 80201722 <panic>
            break;
    80203ef4:	a021                	j	80203efc <handle_exception+0x44a>
				return; // 成功处理
    80203ef6:	0001                	nop
    80203ef8:	a011                	j	80203efc <handle_exception+0x44a>
				return; // 成功处理
    80203efa:	0001                	nop
}
    80203efc:	70e2                	ld	ra,56(sp)
    80203efe:	7442                	ld	s0,48(sp)
    80203f00:	6121                	addi	sp,sp,64
    80203f02:	8082                	ret

0000000080203f04 <user_va2pa>:
void* user_va2pa(pagetable_t pagetable, uint64 va) {
    80203f04:	7179                	addi	sp,sp,-48
    80203f06:	f406                	sd	ra,40(sp)
    80203f08:	f022                	sd	s0,32(sp)
    80203f0a:	1800                	addi	s0,sp,48
    80203f0c:	fca43c23          	sd	a0,-40(s0)
    80203f10:	fcb43823          	sd	a1,-48(s0)
    pte_t *pte = walk_lookup(pagetable, va);
    80203f14:	fd043583          	ld	a1,-48(s0)
    80203f18:	fd843503          	ld	a0,-40(s0)
    80203f1c:	ffffe097          	auipc	ra,0xffffe
    80203f20:	1dc080e7          	jalr	476(ra) # 802020f8 <walk_lookup>
    80203f24:	fea43423          	sd	a0,-24(s0)
    if (!pte) return 0;
    80203f28:	fe843783          	ld	a5,-24(s0)
    80203f2c:	e399                	bnez	a5,80203f32 <user_va2pa+0x2e>
    80203f2e:	4781                	li	a5,0
    80203f30:	a83d                	j	80203f6e <user_va2pa+0x6a>
    if (!(*pte & PTE_V)) return 0;
    80203f32:	fe843783          	ld	a5,-24(s0)
    80203f36:	639c                	ld	a5,0(a5)
    80203f38:	8b85                	andi	a5,a5,1
    80203f3a:	e399                	bnez	a5,80203f40 <user_va2pa+0x3c>
    80203f3c:	4781                	li	a5,0
    80203f3e:	a805                	j	80203f6e <user_va2pa+0x6a>
    if (!(*pte & PTE_U)) return 0; // 必须是用户可访问
    80203f40:	fe843783          	ld	a5,-24(s0)
    80203f44:	639c                	ld	a5,0(a5)
    80203f46:	8bc1                	andi	a5,a5,16
    80203f48:	e399                	bnez	a5,80203f4e <user_va2pa+0x4a>
    80203f4a:	4781                	li	a5,0
    80203f4c:	a00d                	j	80203f6e <user_va2pa+0x6a>
    uint64 pa = (PTE2PA(*pte)) | (va & 0xFFF); // 物理页基址 + 页内偏移
    80203f4e:	fe843783          	ld	a5,-24(s0)
    80203f52:	639c                	ld	a5,0(a5)
    80203f54:	83a9                	srli	a5,a5,0xa
    80203f56:	00c79713          	slli	a4,a5,0xc
    80203f5a:	fd043683          	ld	a3,-48(s0)
    80203f5e:	6785                	lui	a5,0x1
    80203f60:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80203f62:	8ff5                	and	a5,a5,a3
    80203f64:	8fd9                	or	a5,a5,a4
    80203f66:	fef43023          	sd	a5,-32(s0)
    return (void*)pa;
    80203f6a:	fe043783          	ld	a5,-32(s0)
}
    80203f6e:	853e                	mv	a0,a5
    80203f70:	70a2                	ld	ra,40(sp)
    80203f72:	7402                	ld	s0,32(sp)
    80203f74:	6145                	addi	sp,sp,48
    80203f76:	8082                	ret

0000000080203f78 <copyin>:
int copyin(char *dst, uint64 srcva, int maxlen) {
    80203f78:	715d                	addi	sp,sp,-80
    80203f7a:	e486                	sd	ra,72(sp)
    80203f7c:	e0a2                	sd	s0,64(sp)
    80203f7e:	0880                	addi	s0,sp,80
    80203f80:	fca43423          	sd	a0,-56(s0)
    80203f84:	fcb43023          	sd	a1,-64(s0)
    80203f88:	87b2                	mv	a5,a2
    80203f8a:	faf42e23          	sw	a5,-68(s0)
    struct proc *p = myproc();
    80203f8e:	00001097          	auipc	ra,0x1
    80203f92:	f92080e7          	jalr	-110(ra) # 80204f20 <myproc>
    80203f96:	fea43023          	sd	a0,-32(s0)
    for (int i = 0; i < maxlen; i++) {
    80203f9a:	fe042623          	sw	zero,-20(s0)
    80203f9e:	a085                	j	80203ffe <copyin+0x86>
        char *pa = user_va2pa(p->pagetable, srcva + i);
    80203fa0:	fe043783          	ld	a5,-32(s0)
    80203fa4:	7fd4                	ld	a3,184(a5)
    80203fa6:	fec42703          	lw	a4,-20(s0)
    80203faa:	fc043783          	ld	a5,-64(s0)
    80203fae:	97ba                	add	a5,a5,a4
    80203fb0:	85be                	mv	a1,a5
    80203fb2:	8536                	mv	a0,a3
    80203fb4:	00000097          	auipc	ra,0x0
    80203fb8:	f50080e7          	jalr	-176(ra) # 80203f04 <user_va2pa>
    80203fbc:	fca43c23          	sd	a0,-40(s0)
        if (!pa) return -1;
    80203fc0:	fd843783          	ld	a5,-40(s0)
    80203fc4:	e399                	bnez	a5,80203fca <copyin+0x52>
    80203fc6:	57fd                	li	a5,-1
    80203fc8:	a0a9                	j	80204012 <copyin+0x9a>
        dst[i] = *pa;
    80203fca:	fec42783          	lw	a5,-20(s0)
    80203fce:	fc843703          	ld	a4,-56(s0)
    80203fd2:	97ba                	add	a5,a5,a4
    80203fd4:	fd843703          	ld	a4,-40(s0)
    80203fd8:	00074703          	lbu	a4,0(a4)
    80203fdc:	00e78023          	sb	a4,0(a5)
        if (dst[i] == 0) return 0;
    80203fe0:	fec42783          	lw	a5,-20(s0)
    80203fe4:	fc843703          	ld	a4,-56(s0)
    80203fe8:	97ba                	add	a5,a5,a4
    80203fea:	0007c783          	lbu	a5,0(a5)
    80203fee:	e399                	bnez	a5,80203ff4 <copyin+0x7c>
    80203ff0:	4781                	li	a5,0
    80203ff2:	a005                	j	80204012 <copyin+0x9a>
    for (int i = 0; i < maxlen; i++) {
    80203ff4:	fec42783          	lw	a5,-20(s0)
    80203ff8:	2785                	addiw	a5,a5,1
    80203ffa:	fef42623          	sw	a5,-20(s0)
    80203ffe:	fec42783          	lw	a5,-20(s0)
    80204002:	873e                	mv	a4,a5
    80204004:	fbc42783          	lw	a5,-68(s0)
    80204008:	2701                	sext.w	a4,a4
    8020400a:	2781                	sext.w	a5,a5
    8020400c:	f8f74ae3          	blt	a4,a5,80203fa0 <copyin+0x28>
    return 0;
    80204010:	4781                	li	a5,0
}
    80204012:	853e                	mv	a0,a5
    80204014:	60a6                	ld	ra,72(sp)
    80204016:	6406                	ld	s0,64(sp)
    80204018:	6161                	addi	sp,sp,80
    8020401a:	8082                	ret

000000008020401c <copyout>:
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
    8020401c:	7139                	addi	sp,sp,-64
    8020401e:	fc06                	sd	ra,56(sp)
    80204020:	f822                	sd	s0,48(sp)
    80204022:	0080                	addi	s0,sp,64
    80204024:	fca43c23          	sd	a0,-40(s0)
    80204028:	fcb43823          	sd	a1,-48(s0)
    8020402c:	fcc43423          	sd	a2,-56(s0)
    80204030:	fcd43023          	sd	a3,-64(s0)
    for (uint64 i = 0; i < len; i++) {
    80204034:	fe043423          	sd	zero,-24(s0)
    80204038:	a0a1                	j	80204080 <copyout+0x64>
        char *pa = user_va2pa(pagetable, dstva + i);
    8020403a:	fd043703          	ld	a4,-48(s0)
    8020403e:	fe843783          	ld	a5,-24(s0)
    80204042:	97ba                	add	a5,a5,a4
    80204044:	85be                	mv	a1,a5
    80204046:	fd843503          	ld	a0,-40(s0)
    8020404a:	00000097          	auipc	ra,0x0
    8020404e:	eba080e7          	jalr	-326(ra) # 80203f04 <user_va2pa>
    80204052:	fea43023          	sd	a0,-32(s0)
        if (!pa) return -1;
    80204056:	fe043783          	ld	a5,-32(s0)
    8020405a:	e399                	bnez	a5,80204060 <copyout+0x44>
    8020405c:	57fd                	li	a5,-1
    8020405e:	a805                	j	8020408e <copyout+0x72>
        *pa = src[i];
    80204060:	fc843703          	ld	a4,-56(s0)
    80204064:	fe843783          	ld	a5,-24(s0)
    80204068:	97ba                	add	a5,a5,a4
    8020406a:	0007c703          	lbu	a4,0(a5)
    8020406e:	fe043783          	ld	a5,-32(s0)
    80204072:	00e78023          	sb	a4,0(a5)
    for (uint64 i = 0; i < len; i++) {
    80204076:	fe843783          	ld	a5,-24(s0)
    8020407a:	0785                	addi	a5,a5,1
    8020407c:	fef43423          	sd	a5,-24(s0)
    80204080:	fe843703          	ld	a4,-24(s0)
    80204084:	fc043783          	ld	a5,-64(s0)
    80204088:	faf769e3          	bltu	a4,a5,8020403a <copyout+0x1e>
    return 0;
    8020408c:	4781                	li	a5,0
}
    8020408e:	853e                	mv	a0,a5
    80204090:	70e2                	ld	ra,56(sp)
    80204092:	7442                	ld	s0,48(sp)
    80204094:	6121                	addi	sp,sp,64
    80204096:	8082                	ret

0000000080204098 <copyinstr>:
int copyinstr(char *dst, pagetable_t pagetable, uint64 srcva, int max) {
    80204098:	7139                	addi	sp,sp,-64
    8020409a:	fc06                	sd	ra,56(sp)
    8020409c:	f822                	sd	s0,48(sp)
    8020409e:	0080                	addi	s0,sp,64
    802040a0:	fca43c23          	sd	a0,-40(s0)
    802040a4:	fcb43823          	sd	a1,-48(s0)
    802040a8:	fcc43423          	sd	a2,-56(s0)
    802040ac:	87b6                	mv	a5,a3
    802040ae:	fcf42223          	sw	a5,-60(s0)
    for (i = 0; i < max; i++) {
    802040b2:	fe042623          	sw	zero,-20(s0)
    802040b6:	a0b9                	j	80204104 <copyinstr+0x6c>
        if (copyin(&c, srcva + i, 1) < 0)  // 每次拷贝 1 字节
    802040b8:	fec42703          	lw	a4,-20(s0)
    802040bc:	fc843783          	ld	a5,-56(s0)
    802040c0:	973e                	add	a4,a4,a5
    802040c2:	feb40793          	addi	a5,s0,-21
    802040c6:	4605                	li	a2,1
    802040c8:	85ba                	mv	a1,a4
    802040ca:	853e                	mv	a0,a5
    802040cc:	00000097          	auipc	ra,0x0
    802040d0:	eac080e7          	jalr	-340(ra) # 80203f78 <copyin>
    802040d4:	87aa                	mv	a5,a0
    802040d6:	0007d463          	bgez	a5,802040de <copyinstr+0x46>
            return -1;
    802040da:	57fd                	li	a5,-1
    802040dc:	a0b1                	j	80204128 <copyinstr+0x90>
        dst[i] = c;
    802040de:	fec42783          	lw	a5,-20(s0)
    802040e2:	fd843703          	ld	a4,-40(s0)
    802040e6:	97ba                	add	a5,a5,a4
    802040e8:	feb44703          	lbu	a4,-21(s0)
    802040ec:	00e78023          	sb	a4,0(a5)
        if (c == '\0')
    802040f0:	feb44783          	lbu	a5,-21(s0)
    802040f4:	e399                	bnez	a5,802040fa <copyinstr+0x62>
            return 0;
    802040f6:	4781                	li	a5,0
    802040f8:	a805                	j	80204128 <copyinstr+0x90>
    for (i = 0; i < max; i++) {
    802040fa:	fec42783          	lw	a5,-20(s0)
    802040fe:	2785                	addiw	a5,a5,1
    80204100:	fef42623          	sw	a5,-20(s0)
    80204104:	fec42783          	lw	a5,-20(s0)
    80204108:	873e                	mv	a4,a5
    8020410a:	fc442783          	lw	a5,-60(s0)
    8020410e:	2701                	sext.w	a4,a4
    80204110:	2781                	sext.w	a5,a5
    80204112:	faf743e3          	blt	a4,a5,802040b8 <copyinstr+0x20>
    dst[max-1] = '\0';
    80204116:	fc442783          	lw	a5,-60(s0)
    8020411a:	17fd                	addi	a5,a5,-1
    8020411c:	fd843703          	ld	a4,-40(s0)
    80204120:	97ba                	add	a5,a5,a4
    80204122:	00078023          	sb	zero,0(a5)
    return -1; // 超过最大长度还没遇到 \0
    80204126:	57fd                	li	a5,-1
}
    80204128:	853e                	mv	a0,a5
    8020412a:	70e2                	ld	ra,56(sp)
    8020412c:	7442                	ld	s0,48(sp)
    8020412e:	6121                	addi	sp,sp,64
    80204130:	8082                	ret

0000000080204132 <check_user_addr>:
int check_user_addr(uint64 addr, uint64 size, int write) {
    80204132:	7179                	addi	sp,sp,-48
    80204134:	f422                	sd	s0,40(sp)
    80204136:	1800                	addi	s0,sp,48
    80204138:	fea43423          	sd	a0,-24(s0)
    8020413c:	feb43023          	sd	a1,-32(s0)
    80204140:	87b2                	mv	a5,a2
    80204142:	fcf42e23          	sw	a5,-36(s0)
    if (!IS_USER_ADDR(addr) || !IS_USER_ADDR(addr + size - 1))
    80204146:	fe843703          	ld	a4,-24(s0)
    8020414a:	57fd                	li	a5,-1
    8020414c:	83e5                	srli	a5,a5,0x19
    8020414e:	00e7ed63          	bltu	a5,a4,80204168 <check_user_addr+0x36>
    80204152:	fe843703          	ld	a4,-24(s0)
    80204156:	fe043783          	ld	a5,-32(s0)
    8020415a:	97ba                	add	a5,a5,a4
    8020415c:	fff78713          	addi	a4,a5,-1
    80204160:	57fd                	li	a5,-1
    80204162:	83e5                	srli	a5,a5,0x19
    80204164:	00e7f463          	bgeu	a5,a4,8020416c <check_user_addr+0x3a>
        return -1;
    80204168:	57fd                	li	a5,-1
    8020416a:	a8e1                	j	80204242 <check_user_addr+0x110>
    if (IS_USER_STACK(addr)) {
    8020416c:	fe843703          	ld	a4,-24(s0)
    80204170:	defff7b7          	lui	a5,0xdefff
    80204174:	07b6                	slli	a5,a5,0xd
    80204176:	83e5                	srli	a5,a5,0x19
    80204178:	04e7f663          	bgeu	a5,a4,802041c4 <check_user_addr+0x92>
    8020417c:	fe843703          	ld	a4,-24(s0)
    80204180:	fefff7b7          	lui	a5,0xfefff
    80204184:	07b6                	slli	a5,a5,0xd
    80204186:	83e5                	srli	a5,a5,0x19
    80204188:	02e7ee63          	bltu	a5,a4,802041c4 <check_user_addr+0x92>
        if (!IS_USER_STACK(addr + size - 1))
    8020418c:	fe843703          	ld	a4,-24(s0)
    80204190:	fe043783          	ld	a5,-32(s0)
    80204194:	97ba                	add	a5,a5,a4
    80204196:	fff78713          	addi	a4,a5,-1 # fffffffffeffefff <_bss_end+0xffffffff7edd885f>
    8020419a:	defff7b7          	lui	a5,0xdefff
    8020419e:	07b6                	slli	a5,a5,0xd
    802041a0:	83e5                	srli	a5,a5,0x19
    802041a2:	00e7ff63          	bgeu	a5,a4,802041c0 <check_user_addr+0x8e>
    802041a6:	fe843703          	ld	a4,-24(s0)
    802041aa:	fe043783          	ld	a5,-32(s0)
    802041ae:	97ba                	add	a5,a5,a4
    802041b0:	fff78713          	addi	a4,a5,-1 # ffffffffdeffefff <_bss_end+0xffffffff5edd885f>
    802041b4:	fefff7b7          	lui	a5,0xfefff
    802041b8:	07b6                	slli	a5,a5,0xd
    802041ba:	83e5                	srli	a5,a5,0x19
    802041bc:	06e7ff63          	bgeu	a5,a4,8020423a <check_user_addr+0x108>
            return -1;  // 跨越栈边界
    802041c0:	57fd                	li	a5,-1
    802041c2:	a041                	j	80204242 <check_user_addr+0x110>
    } else if (IS_USER_HEAP(addr)) {
    802041c4:	fe843703          	ld	a4,-24(s0)
    802041c8:	004007b7          	lui	a5,0x400
    802041cc:	04f76463          	bltu	a4,a5,80204214 <check_user_addr+0xe2>
    802041d0:	fe843703          	ld	a4,-24(s0)
    802041d4:	defff7b7          	lui	a5,0xdefff
    802041d8:	07b6                	slli	a5,a5,0xd
    802041da:	83e5                	srli	a5,a5,0x19
    802041dc:	02e7ec63          	bltu	a5,a4,80204214 <check_user_addr+0xe2>
        if (!IS_USER_HEAP(addr + size - 1))
    802041e0:	fe843703          	ld	a4,-24(s0)
    802041e4:	fe043783          	ld	a5,-32(s0)
    802041e8:	97ba                	add	a5,a5,a4
    802041ea:	fff78713          	addi	a4,a5,-1 # ffffffffdeffefff <_bss_end+0xffffffff5edd885f>
    802041ee:	004007b7          	lui	a5,0x400
    802041f2:	00f76f63          	bltu	a4,a5,80204210 <check_user_addr+0xde>
    802041f6:	fe843703          	ld	a4,-24(s0)
    802041fa:	fe043783          	ld	a5,-32(s0)
    802041fe:	97ba                	add	a5,a5,a4
    80204200:	fff78713          	addi	a4,a5,-1 # 3fffff <_entry-0x7fe00001>
    80204204:	defff7b7          	lui	a5,0xdefff
    80204208:	07b6                	slli	a5,a5,0xd
    8020420a:	83e5                	srli	a5,a5,0x19
    8020420c:	02e7f963          	bgeu	a5,a4,8020423e <check_user_addr+0x10c>
            return -1;  // 跨越堆边界
    80204210:	57fd                	li	a5,-1
    80204212:	a805                	j	80204242 <check_user_addr+0x110>
    } else if (addr < USER_HEAP_START) {
    80204214:	fe843703          	ld	a4,-24(s0)
    80204218:	004007b7          	lui	a5,0x400
    8020421c:	00f77d63          	bgeu	a4,a5,80204236 <check_user_addr+0x104>
        if (addr + size > USER_HEAP_START)
    80204220:	fe843703          	ld	a4,-24(s0)
    80204224:	fe043783          	ld	a5,-32(s0)
    80204228:	973e                	add	a4,a4,a5
    8020422a:	004007b7          	lui	a5,0x400
    8020422e:	00e7f963          	bgeu	a5,a4,80204240 <check_user_addr+0x10e>
            return -1;  // 跨越代码/数据段边界
    80204232:	57fd                	li	a5,-1
    80204234:	a039                	j	80204242 <check_user_addr+0x110>
        return -1;  // 在未定义区域
    80204236:	57fd                	li	a5,-1
    80204238:	a029                	j	80204242 <check_user_addr+0x110>
        if (!IS_USER_STACK(addr + size - 1))
    8020423a:	0001                	nop
    8020423c:	a011                	j	80204240 <check_user_addr+0x10e>
        if (!IS_USER_HEAP(addr + size - 1))
    8020423e:	0001                	nop
    return 0;  // 地址合法
    80204240:	4781                	li	a5,0
}
    80204242:	853e                	mv	a0,a5
    80204244:	7422                	ld	s0,40(sp)
    80204246:	6145                	addi	sp,sp,48
    80204248:	8082                	ret

000000008020424a <handle_syscall>:
void handle_syscall(struct trapframe *tf, struct trap_info *info) {
    8020424a:	7155                	addi	sp,sp,-208
    8020424c:	e586                	sd	ra,200(sp)
    8020424e:	e1a2                	sd	s0,192(sp)
    80204250:	0980                	addi	s0,sp,208
    80204252:	f2a43c23          	sd	a0,-200(s0)
    80204256:	f2b43823          	sd	a1,-208(s0)
	switch (tf->a7) {
    8020425a:	f3843783          	ld	a5,-200(s0)
    8020425e:	7bdc                	ld	a5,176(a5)
    80204260:	6705                	lui	a4,0x1
    80204262:	177d                	addi	a4,a4,-1 # fff <_entry-0x801ff001>
    80204264:	28e78563          	beq	a5,a4,802044ee <handle_syscall+0x2a4>
    80204268:	6705                	lui	a4,0x1
    8020426a:	40e7f063          	bgeu	a5,a4,8020466a <handle_syscall+0x420>
    8020426e:	0de00713          	li	a4,222
    80204272:	20e78c63          	beq	a5,a4,8020448a <handle_syscall+0x240>
    80204276:	0de00713          	li	a4,222
    8020427a:	3ef76863          	bltu	a4,a5,8020466a <handle_syscall+0x420>
    8020427e:	0dd00713          	li	a4,221
    80204282:	18e78963          	beq	a5,a4,80204414 <handle_syscall+0x1ca>
    80204286:	0dd00713          	li	a4,221
    8020428a:	3ef76063          	bltu	a4,a5,8020466a <handle_syscall+0x420>
    8020428e:	0dc00713          	li	a4,220
    80204292:	14e78963          	beq	a5,a4,802043e4 <handle_syscall+0x19a>
    80204296:	0dc00713          	li	a4,220
    8020429a:	3cf76863          	bltu	a4,a5,8020466a <handle_syscall+0x420>
    8020429e:	0ad00713          	li	a4,173
    802042a2:	20e78863          	beq	a5,a4,802044b2 <handle_syscall+0x268>
    802042a6:	0ad00713          	li	a4,173
    802042aa:	3cf76063          	bltu	a4,a5,8020466a <handle_syscall+0x420>
    802042ae:	0ac00713          	li	a4,172
    802042b2:	1ee78563          	beq	a5,a4,8020449c <handle_syscall+0x252>
    802042b6:	0ac00713          	li	a4,172
    802042ba:	3af76863          	bltu	a4,a5,8020466a <handle_syscall+0x420>
    802042be:	08100713          	li	a4,129
    802042c2:	0ee78363          	beq	a5,a4,802043a8 <handle_syscall+0x15e>
    802042c6:	08100713          	li	a4,129
    802042ca:	3af76063          	bltu	a4,a5,8020466a <handle_syscall+0x420>
    802042ce:	02a00713          	li	a4,42
    802042d2:	02f76863          	bltu	a4,a5,80204302 <handle_syscall+0xb8>
    802042d6:	38078a63          	beqz	a5,8020466a <handle_syscall+0x420>
    802042da:	02a00713          	li	a4,42
    802042de:	38f76663          	bltu	a4,a5,8020466a <handle_syscall+0x420>
    802042e2:	00279713          	slli	a4,a5,0x2
    802042e6:	00016797          	auipc	a5,0x16
    802042ea:	6da78793          	addi	a5,a5,1754 # 8021a9c0 <syscall_performance_bin+0xaf0>
    802042ee:	97ba                	add	a5,a5,a4
    802042f0:	439c                	lw	a5,0(a5)
    802042f2:	0007871b          	sext.w	a4,a5
    802042f6:	00016797          	auipc	a5,0x16
    802042fa:	6ca78793          	addi	a5,a5,1738 # 8021a9c0 <syscall_performance_bin+0xaf0>
    802042fe:	97ba                	add	a5,a5,a4
    80204300:	8782                	jr	a5
    80204302:	05d00713          	li	a4,93
    80204306:	06e78b63          	beq	a5,a4,8020437c <handle_syscall+0x132>
    8020430a:	a685                	j	8020466a <handle_syscall+0x420>
			printf("[syscall] print int: %ld\n", tf->a0);
    8020430c:	f3843783          	ld	a5,-200(s0)
    80204310:	7fbc                	ld	a5,120(a5)
    80204312:	85be                	mv	a1,a5
    80204314:	00016517          	auipc	a0,0x16
    80204318:	53c50513          	addi	a0,a0,1340 # 8021a850 <syscall_performance_bin+0x980>
    8020431c:	ffffd097          	auipc	ra,0xffffd
    80204320:	9ba080e7          	jalr	-1606(ra) # 80200cd6 <printf>
			break;
    80204324:	a6a5                	j	8020468c <handle_syscall+0x442>
			if (copyinstr(buf, myproc()->pagetable, tf->a0, sizeof(buf)) < 0) {
    80204326:	00001097          	auipc	ra,0x1
    8020432a:	bfa080e7          	jalr	-1030(ra) # 80204f20 <myproc>
    8020432e:	87aa                	mv	a5,a0
    80204330:	7fd8                	ld	a4,184(a5)
    80204332:	f3843783          	ld	a5,-200(s0)
    80204336:	7fb0                	ld	a2,120(a5)
    80204338:	f4040793          	addi	a5,s0,-192
    8020433c:	08000693          	li	a3,128
    80204340:	85ba                	mv	a1,a4
    80204342:	853e                	mv	a0,a5
    80204344:	00000097          	auipc	ra,0x0
    80204348:	d54080e7          	jalr	-684(ra) # 80204098 <copyinstr>
    8020434c:	87aa                	mv	a5,a0
    8020434e:	0007db63          	bgez	a5,80204364 <handle_syscall+0x11a>
				printf("[syscall] invalid string\n");
    80204352:	00016517          	auipc	a0,0x16
    80204356:	51e50513          	addi	a0,a0,1310 # 8021a870 <syscall_performance_bin+0x9a0>
    8020435a:	ffffd097          	auipc	ra,0xffffd
    8020435e:	97c080e7          	jalr	-1668(ra) # 80200cd6 <printf>
				break;
    80204362:	a62d                	j	8020468c <handle_syscall+0x442>
			printf("[syscall] print str: %s\n", buf);
    80204364:	f4040793          	addi	a5,s0,-192
    80204368:	85be                	mv	a1,a5
    8020436a:	00016517          	auipc	a0,0x16
    8020436e:	52650513          	addi	a0,a0,1318 # 8021a890 <syscall_performance_bin+0x9c0>
    80204372:	ffffd097          	auipc	ra,0xffffd
    80204376:	964080e7          	jalr	-1692(ra) # 80200cd6 <printf>
			break;
    8020437a:	ae09                	j	8020468c <handle_syscall+0x442>
			printf("[syscall] exit(%ld)\n", tf->a0);
    8020437c:	f3843783          	ld	a5,-200(s0)
    80204380:	7fbc                	ld	a5,120(a5)
    80204382:	85be                	mv	a1,a5
    80204384:	00016517          	auipc	a0,0x16
    80204388:	52c50513          	addi	a0,a0,1324 # 8021a8b0 <syscall_performance_bin+0x9e0>
    8020438c:	ffffd097          	auipc	ra,0xffffd
    80204390:	94a080e7          	jalr	-1718(ra) # 80200cd6 <printf>
			exit_proc((int)tf->a0);
    80204394:	f3843783          	ld	a5,-200(s0)
    80204398:	7fbc                	ld	a5,120(a5)
    8020439a:	2781                	sext.w	a5,a5
    8020439c:	853e                	mv	a0,a5
    8020439e:	00002097          	auipc	ra,0x2
    802043a2:	92a080e7          	jalr	-1750(ra) # 80205cc8 <exit_proc>
			break;
    802043a6:	a4dd                	j	8020468c <handle_syscall+0x442>
			if (myproc()->pid == tf->a0){
    802043a8:	00001097          	auipc	ra,0x1
    802043ac:	b78080e7          	jalr	-1160(ra) # 80204f20 <myproc>
    802043b0:	87aa                	mv	a5,a0
    802043b2:	43dc                	lw	a5,4(a5)
    802043b4:	873e                	mv	a4,a5
    802043b6:	f3843783          	ld	a5,-200(s0)
    802043ba:	7fbc                	ld	a5,120(a5)
    802043bc:	00f71a63          	bne	a4,a5,802043d0 <handle_syscall+0x186>
				warning("[syscall] will kill itself!!!\n");
    802043c0:	00016517          	auipc	a0,0x16
    802043c4:	50850513          	addi	a0,a0,1288 # 8021a8c8 <syscall_performance_bin+0x9f8>
    802043c8:	ffffd097          	auipc	ra,0xffffd
    802043cc:	38e080e7          	jalr	910(ra) # 80201756 <warning>
			kill_proc(tf->a0);
    802043d0:	f3843783          	ld	a5,-200(s0)
    802043d4:	7fbc                	ld	a5,120(a5)
    802043d6:	2781                	sext.w	a5,a5
    802043d8:	853e                	mv	a0,a5
    802043da:	00002097          	auipc	ra,0x2
    802043de:	88a080e7          	jalr	-1910(ra) # 80205c64 <kill_proc>
			break;
    802043e2:	a46d                	j	8020468c <handle_syscall+0x442>
			int child_pid = fork_proc();
    802043e4:	00001097          	auipc	ra,0x1
    802043e8:	45e080e7          	jalr	1118(ra) # 80205842 <fork_proc>
    802043ec:	87aa                	mv	a5,a0
    802043ee:	fcf42e23          	sw	a5,-36(s0)
			tf->a0 = child_pid;
    802043f2:	fdc42703          	lw	a4,-36(s0)
    802043f6:	f3843783          	ld	a5,-200(s0)
    802043fa:	ffb8                	sd	a4,120(a5)
			printf("[syscall] fork -> %d\n", child_pid);
    802043fc:	fdc42783          	lw	a5,-36(s0)
    80204400:	85be                	mv	a1,a5
    80204402:	00016517          	auipc	a0,0x16
    80204406:	4e650513          	addi	a0,a0,1254 # 8021a8e8 <syscall_performance_bin+0xa18>
    8020440a:	ffffd097          	auipc	ra,0xffffd
    8020440e:	8cc080e7          	jalr	-1844(ra) # 80200cd6 <printf>
			break;
    80204412:	acad                	j	8020468c <handle_syscall+0x442>
				uint64 uaddr = tf->a0;
    80204414:	f3843783          	ld	a5,-200(s0)
    80204418:	7fbc                	ld	a5,120(a5)
    8020441a:	fef43023          	sd	a5,-32(s0)
				int kstatus = 0;
    8020441e:	fc042023          	sw	zero,-64(s0)
				int pid = wait_proc(uaddr ? &kstatus : NULL);  // 在内核里等待并得到退出码
    80204422:	fe043783          	ld	a5,-32(s0)
    80204426:	c781                	beqz	a5,8020442e <handle_syscall+0x1e4>
    80204428:	fc040793          	addi	a5,s0,-64
    8020442c:	a011                	j	80204430 <handle_syscall+0x1e6>
    8020442e:	4781                	li	a5,0
    80204430:	853e                	mv	a0,a5
    80204432:	00002097          	auipc	ra,0x2
    80204436:	960080e7          	jalr	-1696(ra) # 80205d92 <wait_proc>
    8020443a:	87aa                	mv	a5,a0
    8020443c:	fef42623          	sw	a5,-20(s0)
				if (pid >= 0 && uaddr) {
    80204440:	fec42783          	lw	a5,-20(s0)
    80204444:	2781                	sext.w	a5,a5
    80204446:	0207cc63          	bltz	a5,8020447e <handle_syscall+0x234>
    8020444a:	fe043783          	ld	a5,-32(s0)
    8020444e:	cb85                	beqz	a5,8020447e <handle_syscall+0x234>
					if (copyout(myproc()->pagetable, uaddr, (char *)&kstatus, sizeof(kstatus)) < 0) {
    80204450:	00001097          	auipc	ra,0x1
    80204454:	ad0080e7          	jalr	-1328(ra) # 80204f20 <myproc>
    80204458:	87aa                	mv	a5,a0
    8020445a:	7fdc                	ld	a5,184(a5)
    8020445c:	fc040713          	addi	a4,s0,-64
    80204460:	4691                	li	a3,4
    80204462:	863a                	mv	a2,a4
    80204464:	fe043583          	ld	a1,-32(s0)
    80204468:	853e                	mv	a0,a5
    8020446a:	00000097          	auipc	ra,0x0
    8020446e:	bb2080e7          	jalr	-1102(ra) # 8020401c <copyout>
    80204472:	87aa                	mv	a5,a0
    80204474:	0007d563          	bgez	a5,8020447e <handle_syscall+0x234>
						pid = -1; // 用户空间地址不可写，视为失败
    80204478:	57fd                	li	a5,-1
    8020447a:	fef42623          	sw	a5,-20(s0)
				tf->a0 = pid;
    8020447e:	fec42703          	lw	a4,-20(s0)
    80204482:	f3843783          	ld	a5,-200(s0)
    80204486:	ffb8                	sd	a4,120(a5)
				break;
    80204488:	a411                	j	8020468c <handle_syscall+0x442>
			tf->a0 =0;
    8020448a:	f3843783          	ld	a5,-200(s0)
    8020448e:	0607bc23          	sd	zero,120(a5)
			yield();
    80204492:	00001097          	auipc	ra,0x1
    80204496:	628080e7          	jalr	1576(ra) # 80205aba <yield>
			break;
    8020449a:	aacd                	j	8020468c <handle_syscall+0x442>
			tf->a0 = myproc()->pid;
    8020449c:	00001097          	auipc	ra,0x1
    802044a0:	a84080e7          	jalr	-1404(ra) # 80204f20 <myproc>
    802044a4:	87aa                	mv	a5,a0
    802044a6:	43dc                	lw	a5,4(a5)
    802044a8:	873e                	mv	a4,a5
    802044aa:	f3843783          	ld	a5,-200(s0)
    802044ae:	ffb8                	sd	a4,120(a5)
			break;
    802044b0:	aaf1                	j	8020468c <handle_syscall+0x442>
			tf->a0 = myproc()->parent ? myproc()->parent->pid : 0;
    802044b2:	00001097          	auipc	ra,0x1
    802044b6:	a6e080e7          	jalr	-1426(ra) # 80204f20 <myproc>
    802044ba:	87aa                	mv	a5,a0
    802044bc:	6fdc                	ld	a5,152(a5)
    802044be:	cb91                	beqz	a5,802044d2 <handle_syscall+0x288>
    802044c0:	00001097          	auipc	ra,0x1
    802044c4:	a60080e7          	jalr	-1440(ra) # 80204f20 <myproc>
    802044c8:	87aa                	mv	a5,a0
    802044ca:	6fdc                	ld	a5,152(a5)
    802044cc:	43dc                	lw	a5,4(a5)
    802044ce:	873e                	mv	a4,a5
    802044d0:	a011                	j	802044d4 <handle_syscall+0x28a>
    802044d2:	4701                	li	a4,0
    802044d4:	f3843783          	ld	a5,-200(s0)
    802044d8:	ffb8                	sd	a4,120(a5)
			break;
    802044da:	aa4d                	j	8020468c <handle_syscall+0x442>
			tf->a0 = get_time();
    802044dc:	00002097          	auipc	ra,0x2
    802044e0:	f24080e7          	jalr	-220(ra) # 80206400 <get_time>
    802044e4:	872a                	mv	a4,a0
    802044e6:	f3843783          	ld	a5,-200(s0)
    802044ea:	ffb8                	sd	a4,120(a5)
			break;
    802044ec:	a245                	j	8020468c <handle_syscall+0x442>
			tf->a0 = 0;
    802044ee:	f3843783          	ld	a5,-200(s0)
    802044f2:	0607bc23          	sd	zero,120(a5)
			printf("[syscall] step enabled but do nothing\n");
    802044f6:	00016517          	auipc	a0,0x16
    802044fa:	40a50513          	addi	a0,a0,1034 # 8021a900 <syscall_performance_bin+0xa30>
    802044fe:	ffffc097          	auipc	ra,0xffffc
    80204502:	7d8080e7          	jalr	2008(ra) # 80200cd6 <printf>
			break;
    80204506:	a259                	j	8020468c <handle_syscall+0x442>
		int fd = tf->a0;          // 文件描述符
    80204508:	f3843783          	ld	a5,-200(s0)
    8020450c:	7fbc                	ld	a5,120(a5)
    8020450e:	fcf42c23          	sw	a5,-40(s0)
		if (fd != 1 && fd != 2) {
    80204512:	fd842783          	lw	a5,-40(s0)
    80204516:	0007871b          	sext.w	a4,a5
    8020451a:	4785                	li	a5,1
    8020451c:	00f70e63          	beq	a4,a5,80204538 <handle_syscall+0x2ee>
    80204520:	fd842783          	lw	a5,-40(s0)
    80204524:	0007871b          	sext.w	a4,a5
    80204528:	4789                	li	a5,2
    8020452a:	00f70763          	beq	a4,a5,80204538 <handle_syscall+0x2ee>
			tf->a0 = -1;
    8020452e:	f3843783          	ld	a5,-200(s0)
    80204532:	577d                	li	a4,-1
    80204534:	ffb8                	sd	a4,120(a5)
			break;
    80204536:	aa99                	j	8020468c <handle_syscall+0x442>
		if (check_user_addr(tf->a1, tf->a2, 0) < 0) {
    80204538:	f3843783          	ld	a5,-200(s0)
    8020453c:	63d8                	ld	a4,128(a5)
    8020453e:	f3843783          	ld	a5,-200(s0)
    80204542:	67dc                	ld	a5,136(a5)
    80204544:	4601                	li	a2,0
    80204546:	85be                	mv	a1,a5
    80204548:	853a                	mv	a0,a4
    8020454a:	00000097          	auipc	ra,0x0
    8020454e:	be8080e7          	jalr	-1048(ra) # 80204132 <check_user_addr>
    80204552:	87aa                	mv	a5,a0
    80204554:	0007df63          	bgez	a5,80204572 <handle_syscall+0x328>
			printf("[syscall] invalid write buffer address\n");
    80204558:	00016517          	auipc	a0,0x16
    8020455c:	3d050513          	addi	a0,a0,976 # 8021a928 <syscall_performance_bin+0xa58>
    80204560:	ffffc097          	auipc	ra,0xffffc
    80204564:	776080e7          	jalr	1910(ra) # 80200cd6 <printf>
			tf->a0 = -1;
    80204568:	f3843783          	ld	a5,-200(s0)
    8020456c:	577d                	li	a4,-1
    8020456e:	ffb8                	sd	a4,120(a5)
			break;
    80204570:	aa31                	j	8020468c <handle_syscall+0x442>
		if (copyinstr(buf, myproc()->pagetable, tf->a1, sizeof(buf)) < 0) {
    80204572:	00001097          	auipc	ra,0x1
    80204576:	9ae080e7          	jalr	-1618(ra) # 80204f20 <myproc>
    8020457a:	87aa                	mv	a5,a0
    8020457c:	7fd8                	ld	a4,184(a5)
    8020457e:	f3843783          	ld	a5,-200(s0)
    80204582:	63d0                	ld	a2,128(a5)
    80204584:	f4040793          	addi	a5,s0,-192
    80204588:	08000693          	li	a3,128
    8020458c:	85ba                	mv	a1,a4
    8020458e:	853e                	mv	a0,a5
    80204590:	00000097          	auipc	ra,0x0
    80204594:	b08080e7          	jalr	-1272(ra) # 80204098 <copyinstr>
    80204598:	87aa                	mv	a5,a0
    8020459a:	0007df63          	bgez	a5,802045b8 <handle_syscall+0x36e>
			printf("[syscall] invalid write buffer\n");
    8020459e:	00016517          	auipc	a0,0x16
    802045a2:	3b250513          	addi	a0,a0,946 # 8021a950 <syscall_performance_bin+0xa80>
    802045a6:	ffffc097          	auipc	ra,0xffffc
    802045aa:	730080e7          	jalr	1840(ra) # 80200cd6 <printf>
			tf->a0 = -1;
    802045ae:	f3843783          	ld	a5,-200(s0)
    802045b2:	577d                	li	a4,-1
    802045b4:	ffb8                	sd	a4,120(a5)
			break;
    802045b6:	a8d9                	j	8020468c <handle_syscall+0x442>
		printf("%s", buf);
    802045b8:	f4040793          	addi	a5,s0,-192
    802045bc:	85be                	mv	a1,a5
    802045be:	00016517          	auipc	a0,0x16
    802045c2:	3b250513          	addi	a0,a0,946 # 8021a970 <syscall_performance_bin+0xaa0>
    802045c6:	ffffc097          	auipc	ra,0xffffc
    802045ca:	710080e7          	jalr	1808(ra) # 80200cd6 <printf>
		tf->a0 = strlen(buf);  // 返回写入的字节数
    802045ce:	f4040793          	addi	a5,s0,-192
    802045d2:	853e                	mv	a0,a5
    802045d4:	00002097          	auipc	ra,0x2
    802045d8:	b88080e7          	jalr	-1144(ra) # 8020615c <strlen>
    802045dc:	87aa                	mv	a5,a0
    802045de:	873e                	mv	a4,a5
    802045e0:	f3843783          	ld	a5,-200(s0)
    802045e4:	ffb8                	sd	a4,120(a5)
		break;
    802045e6:	a05d                	j	8020468c <handle_syscall+0x442>
		int fd = tf->a0;          // 文件描述符
    802045e8:	f3843783          	ld	a5,-200(s0)
    802045ec:	7fbc                	ld	a5,120(a5)
    802045ee:	fcf42a23          	sw	a5,-44(s0)
		uint64 buf = tf->a1;      // 用户缓冲区地址
    802045f2:	f3843783          	ld	a5,-200(s0)
    802045f6:	63dc                	ld	a5,128(a5)
    802045f8:	fcf43423          	sd	a5,-56(s0)
		int n = tf->a2;           // 要读取的字节数
    802045fc:	f3843783          	ld	a5,-200(s0)
    80204600:	67dc                	ld	a5,136(a5)
    80204602:	fcf42223          	sw	a5,-60(s0)
		if (fd != 0) {
    80204606:	fd442783          	lw	a5,-44(s0)
    8020460a:	2781                	sext.w	a5,a5
    8020460c:	c791                	beqz	a5,80204618 <handle_syscall+0x3ce>
			tf->a0 = -1;
    8020460e:	f3843783          	ld	a5,-200(s0)
    80204612:	577d                	li	a4,-1
    80204614:	ffb8                	sd	a4,120(a5)
			break;
    80204616:	a89d                	j	8020468c <handle_syscall+0x442>
		if (check_user_addr(buf, n, 1) < 0) {  // 1表示写入访问
    80204618:	fc442783          	lw	a5,-60(s0)
    8020461c:	4605                	li	a2,1
    8020461e:	85be                	mv	a1,a5
    80204620:	fc843503          	ld	a0,-56(s0)
    80204624:	00000097          	auipc	ra,0x0
    80204628:	b0e080e7          	jalr	-1266(ra) # 80204132 <check_user_addr>
    8020462c:	87aa                	mv	a5,a0
    8020462e:	0007df63          	bgez	a5,8020464c <handle_syscall+0x402>
			printf("[syscall] invalid read buffer address\n");
    80204632:	00016517          	auipc	a0,0x16
    80204636:	34650513          	addi	a0,a0,838 # 8021a978 <syscall_performance_bin+0xaa8>
    8020463a:	ffffc097          	auipc	ra,0xffffc
    8020463e:	69c080e7          	jalr	1692(ra) # 80200cd6 <printf>
			tf->a0 = -1;
    80204642:	f3843783          	ld	a5,-200(s0)
    80204646:	577d                	li	a4,-1
    80204648:	ffb8                	sd	a4,120(a5)
			break;
    8020464a:	a089                	j	8020468c <handle_syscall+0x442>
		tf->a0 = -1;
    8020464c:	f3843783          	ld	a5,-200(s0)
    80204650:	577d                	li	a4,-1
    80204652:	ffb8                	sd	a4,120(a5)
		break;
    80204654:	a825                	j	8020468c <handle_syscall+0x442>
	}
        
        case SYS_open:
        case SYS_close: 
            // 暂时不支持真实的文件操作
            tf->a0 = -1;
    80204656:	f3843783          	ld	a5,-200(s0)
    8020465a:	577d                	li	a4,-1
    8020465c:	ffb8                	sd	a4,120(a5)
            break;
    8020465e:	a03d                	j	8020468c <handle_syscall+0x442>
		case SYS_sbrk:
			tf->a0 = -1;
    80204660:	f3843783          	ld	a5,-200(s0)
    80204664:	577d                	li	a4,-1
    80204666:	ffb8                	sd	a4,120(a5)
			break;
    80204668:	a015                	j	8020468c <handle_syscall+0x442>
		default:
			printf("[syscall] unknown syscall: %ld\n", tf->a7);
    8020466a:	f3843783          	ld	a5,-200(s0)
    8020466e:	7bdc                	ld	a5,176(a5)
    80204670:	85be                	mv	a1,a5
    80204672:	00016517          	auipc	a0,0x16
    80204676:	32e50513          	addi	a0,a0,814 # 8021a9a0 <syscall_performance_bin+0xad0>
    8020467a:	ffffc097          	auipc	ra,0xffffc
    8020467e:	65c080e7          	jalr	1628(ra) # 80200cd6 <printf>
			tf->a0 = -1;
    80204682:	f3843783          	ld	a5,-200(s0)
    80204686:	577d                	li	a4,-1
    80204688:	ffb8                	sd	a4,120(a5)
			break;
    8020468a:	0001                	nop
	}
	set_sepc(tf, info->sepc + 4);
    8020468c:	f3043783          	ld	a5,-208(s0)
    80204690:	639c                	ld	a5,0(a5)
    80204692:	0791                	addi	a5,a5,4
    80204694:	85be                	mv	a1,a5
    80204696:	f3843503          	ld	a0,-200(s0)
    8020469a:	fffff097          	auipc	ra,0xfffff
    8020469e:	026080e7          	jalr	38(ra) # 802036c0 <set_sepc>
}
    802046a2:	0001                	nop
    802046a4:	60ae                	ld	ra,200(sp)
    802046a6:	640e                	ld	s0,192(sp)
    802046a8:	6169                	addi	sp,sp,208
    802046aa:	8082                	ret

00000000802046ac <handle_instruction_page_fault>:



// 处理指令页故障
void handle_instruction_page_fault(struct trapframe *tf, struct trap_info *info) {
    802046ac:	1101                	addi	sp,sp,-32
    802046ae:	ec06                	sd	ra,24(sp)
    802046b0:	e822                	sd	s0,16(sp)
    802046b2:	1000                	addi	s0,sp,32
    802046b4:	fea43423          	sd	a0,-24(s0)
    802046b8:	feb43023          	sd	a1,-32(s0)
    printf("Instruction page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    802046bc:	fe043783          	ld	a5,-32(s0)
    802046c0:	6f98                	ld	a4,24(a5)
    802046c2:	fe043783          	ld	a5,-32(s0)
    802046c6:	639c                	ld	a5,0(a5)
    802046c8:	863e                	mv	a2,a5
    802046ca:	85ba                	mv	a1,a4
    802046cc:	00016517          	auipc	a0,0x16
    802046d0:	3a450513          	addi	a0,a0,932 # 8021aa70 <syscall_performance_bin+0xba0>
    802046d4:	ffffc097          	auipc	ra,0xffffc
    802046d8:	602080e7          	jalr	1538(ra) # 80200cd6 <printf>
    
    // 尝试处理页面故障
    if (handle_page_fault(info->stval, 1)) {  // 1表示指令页
    802046dc:	fe043783          	ld	a5,-32(s0)
    802046e0:	6f9c                	ld	a5,24(a5)
    802046e2:	4585                	li	a1,1
    802046e4:	853e                	mv	a0,a5
    802046e6:	ffffe097          	auipc	ra,0xffffe
    802046ea:	2de080e7          	jalr	734(ra) # 802029c4 <handle_page_fault>
    802046ee:	87aa                	mv	a5,a0
    802046f0:	eb91                	bnez	a5,80204704 <handle_instruction_page_fault+0x58>
        return; // 成功处理页面故障，可以继续执行
    }
    
    // 无法处理的页面故障
    panic("Unhandled instruction page fault");
    802046f2:	00016517          	auipc	a0,0x16
    802046f6:	3ae50513          	addi	a0,a0,942 # 8021aaa0 <syscall_performance_bin+0xbd0>
    802046fa:	ffffd097          	auipc	ra,0xffffd
    802046fe:	028080e7          	jalr	40(ra) # 80201722 <panic>
    80204702:	a011                	j	80204706 <handle_instruction_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    80204704:	0001                	nop
}
    80204706:	60e2                	ld	ra,24(sp)
    80204708:	6442                	ld	s0,16(sp)
    8020470a:	6105                	addi	sp,sp,32
    8020470c:	8082                	ret

000000008020470e <handle_load_page_fault>:

// 处理加载页故障
void handle_load_page_fault(struct trapframe *tf, struct trap_info *info) {
    8020470e:	1101                	addi	sp,sp,-32
    80204710:	ec06                	sd	ra,24(sp)
    80204712:	e822                	sd	s0,16(sp)
    80204714:	1000                	addi	s0,sp,32
    80204716:	fea43423          	sd	a0,-24(s0)
    8020471a:	feb43023          	sd	a1,-32(s0)
    printf("Load page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    8020471e:	fe043783          	ld	a5,-32(s0)
    80204722:	6f98                	ld	a4,24(a5)
    80204724:	fe043783          	ld	a5,-32(s0)
    80204728:	639c                	ld	a5,0(a5)
    8020472a:	863e                	mv	a2,a5
    8020472c:	85ba                	mv	a1,a4
    8020472e:	00016517          	auipc	a0,0x16
    80204732:	39a50513          	addi	a0,a0,922 # 8021aac8 <syscall_performance_bin+0xbf8>
    80204736:	ffffc097          	auipc	ra,0xffffc
    8020473a:	5a0080e7          	jalr	1440(ra) # 80200cd6 <printf>
    
    // 尝试处理页面故障
    if (handle_page_fault(info->stval, 2)) {  // 2表示读数据页
    8020473e:	fe043783          	ld	a5,-32(s0)
    80204742:	6f9c                	ld	a5,24(a5)
    80204744:	4589                	li	a1,2
    80204746:	853e                	mv	a0,a5
    80204748:	ffffe097          	auipc	ra,0xffffe
    8020474c:	27c080e7          	jalr	636(ra) # 802029c4 <handle_page_fault>
    80204750:	87aa                	mv	a5,a0
    80204752:	eb91                	bnez	a5,80204766 <handle_load_page_fault+0x58>
        return; // 成功处理页面故障，可以继续执行
    }
    
    // 无法处理的页面故障
    panic("Unhandled load page fault");
    80204754:	00016517          	auipc	a0,0x16
    80204758:	3a450513          	addi	a0,a0,932 # 8021aaf8 <syscall_performance_bin+0xc28>
    8020475c:	ffffd097          	auipc	ra,0xffffd
    80204760:	fc6080e7          	jalr	-58(ra) # 80201722 <panic>
    80204764:	a011                	j	80204768 <handle_load_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    80204766:	0001                	nop
}
    80204768:	60e2                	ld	ra,24(sp)
    8020476a:	6442                	ld	s0,16(sp)
    8020476c:	6105                	addi	sp,sp,32
    8020476e:	8082                	ret

0000000080204770 <handle_store_page_fault>:

// 处理存储页故障
void handle_store_page_fault(struct trapframe *tf, struct trap_info *info) {
    80204770:	1101                	addi	sp,sp,-32
    80204772:	ec06                	sd	ra,24(sp)
    80204774:	e822                	sd	s0,16(sp)
    80204776:	1000                	addi	s0,sp,32
    80204778:	fea43423          	sd	a0,-24(s0)
    8020477c:	feb43023          	sd	a1,-32(s0)
    printf("Store page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    80204780:	fe043783          	ld	a5,-32(s0)
    80204784:	6f98                	ld	a4,24(a5)
    80204786:	fe043783          	ld	a5,-32(s0)
    8020478a:	639c                	ld	a5,0(a5)
    8020478c:	863e                	mv	a2,a5
    8020478e:	85ba                	mv	a1,a4
    80204790:	00016517          	auipc	a0,0x16
    80204794:	38850513          	addi	a0,a0,904 # 8021ab18 <syscall_performance_bin+0xc48>
    80204798:	ffffc097          	auipc	ra,0xffffc
    8020479c:	53e080e7          	jalr	1342(ra) # 80200cd6 <printf>
    
    // 尝试处理页面故障
    if (handle_page_fault(info->stval, 3)) {  // 3表示写数据页
    802047a0:	fe043783          	ld	a5,-32(s0)
    802047a4:	6f9c                	ld	a5,24(a5)
    802047a6:	458d                	li	a1,3
    802047a8:	853e                	mv	a0,a5
    802047aa:	ffffe097          	auipc	ra,0xffffe
    802047ae:	21a080e7          	jalr	538(ra) # 802029c4 <handle_page_fault>
    802047b2:	87aa                	mv	a5,a0
    802047b4:	eb91                	bnez	a5,802047c8 <handle_store_page_fault+0x58>
        return; // 成功处理页面故障，可以继续执行
    }
    
    // 无法处理的页面故障
    panic("Unhandled store page fault");
    802047b6:	00016517          	auipc	a0,0x16
    802047ba:	39250513          	addi	a0,a0,914 # 8021ab48 <syscall_performance_bin+0xc78>
    802047be:	ffffd097          	auipc	ra,0xffffd
    802047c2:	f64080e7          	jalr	-156(ra) # 80201722 <panic>
    802047c6:	a011                	j	802047ca <handle_store_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    802047c8:	0001                	nop
}
    802047ca:	60e2                	ld	ra,24(sp)
    802047cc:	6442                	ld	s0,16(sp)
    802047ce:	6105                	addi	sp,sp,32
    802047d0:	8082                	ret

00000000802047d2 <usertrap>:

void usertrap(void) {
    802047d2:	7159                	addi	sp,sp,-112
    802047d4:	f486                	sd	ra,104(sp)
    802047d6:	f0a2                	sd	s0,96(sp)
    802047d8:	1880                	addi	s0,sp,112
    struct proc *p = myproc();
    802047da:	00000097          	auipc	ra,0x0
    802047de:	746080e7          	jalr	1862(ra) # 80204f20 <myproc>
    802047e2:	fea43423          	sd	a0,-24(s0)
    struct trapframe *tf = p->trapframe;
    802047e6:	fe843783          	ld	a5,-24(s0)
    802047ea:	63fc                	ld	a5,192(a5)
    802047ec:	fef43023          	sd	a5,-32(s0)

    uint64 scause = r_scause();
    802047f0:	fffff097          	auipc	ra,0xfffff
    802047f4:	e3e080e7          	jalr	-450(ra) # 8020362e <r_scause>
    802047f8:	fca43c23          	sd	a0,-40(s0)
    uint64 stval  = r_stval();
    802047fc:	fffff097          	auipc	ra,0xfffff
    80204800:	e66080e7          	jalr	-410(ra) # 80203662 <r_stval>
    80204804:	fca43823          	sd	a0,-48(s0)
    uint64 sepc   = tf->epc;      // 已由 trampoline 保存
    80204808:	fe043783          	ld	a5,-32(s0)
    8020480c:	739c                	ld	a5,32(a5)
    8020480e:	fcf43423          	sd	a5,-56(s0)
    uint64 sstatus= tf->sstatus;  // 已由 trampoline 保存
    80204812:	fe043783          	ld	a5,-32(s0)
    80204816:	6f9c                	ld	a5,24(a5)
    80204818:	fcf43023          	sd	a5,-64(s0)

    uint64 code = scause & 0xff;
    8020481c:	fd843783          	ld	a5,-40(s0)
    80204820:	0ff7f793          	zext.b	a5,a5
    80204824:	faf43c23          	sd	a5,-72(s0)
    uint64 is_intr = (scause >> 63);
    80204828:	fd843783          	ld	a5,-40(s0)
    8020482c:	93fd                	srli	a5,a5,0x3f
    8020482e:	faf43823          	sd	a5,-80(s0)

    if (!is_intr && code == 8) { // 用户态 ecall
    80204832:	fb043783          	ld	a5,-80(s0)
    80204836:	e3a1                	bnez	a5,80204876 <usertrap+0xa4>
    80204838:	fb843703          	ld	a4,-72(s0)
    8020483c:	47a1                	li	a5,8
    8020483e:	02f71c63          	bne	a4,a5,80204876 <usertrap+0xa4>
        struct trap_info info = { .sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval };
    80204842:	fc843783          	ld	a5,-56(s0)
    80204846:	f8f43823          	sd	a5,-112(s0)
    8020484a:	fc043783          	ld	a5,-64(s0)
    8020484e:	f8f43c23          	sd	a5,-104(s0)
    80204852:	fd843783          	ld	a5,-40(s0)
    80204856:	faf43023          	sd	a5,-96(s0)
    8020485a:	fd043783          	ld	a5,-48(s0)
    8020485e:	faf43423          	sd	a5,-88(s0)
        handle_syscall(tf, &info);
    80204862:	f9040793          	addi	a5,s0,-112
    80204866:	85be                	mv	a1,a5
    80204868:	fe043503          	ld	a0,-32(s0)
    8020486c:	00000097          	auipc	ra,0x0
    80204870:	9de080e7          	jalr	-1570(ra) # 8020424a <handle_syscall>
    if (!is_intr && code == 8) { // 用户态 ecall
    80204874:	a869                	j	8020490e <usertrap+0x13c>
        // handle_syscall 应该已 set_sepc(tf, sepc+4)
    } else if (is_intr) {
    80204876:	fb043783          	ld	a5,-80(s0)
    8020487a:	c3ad                	beqz	a5,802048dc <usertrap+0x10a>
        if (code == 5) {
    8020487c:	fb843703          	ld	a4,-72(s0)
    80204880:	4795                	li	a5,5
    80204882:	02f71663          	bne	a4,a5,802048ae <usertrap+0xdc>
            timeintr();
    80204886:	fffff097          	auipc	ra,0xfffff
    8020488a:	c9c080e7          	jalr	-868(ra) # 80203522 <timeintr>
            sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    8020488e:	fffff097          	auipc	ra,0xfffff
    80204892:	c7a080e7          	jalr	-902(ra) # 80203508 <sbi_get_time>
    80204896:	872a                	mv	a4,a0
    80204898:	000f47b7          	lui	a5,0xf4
    8020489c:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    802048a0:	97ba                	add	a5,a5,a4
    802048a2:	853e                	mv	a0,a5
    802048a4:	fffff097          	auipc	ra,0xfffff
    802048a8:	c48080e7          	jalr	-952(ra) # 802034ec <sbi_set_time>
    802048ac:	a08d                	j	8020490e <usertrap+0x13c>
        } else if (code == 9) {
    802048ae:	fb843703          	ld	a4,-72(s0)
    802048b2:	47a5                	li	a5,9
    802048b4:	00f71763          	bne	a4,a5,802048c2 <usertrap+0xf0>
            handle_external_interrupt();
    802048b8:	fffff097          	auipc	ra,0xfffff
    802048bc:	f58080e7          	jalr	-168(ra) # 80203810 <handle_external_interrupt>
    802048c0:	a0b9                	j	8020490e <usertrap+0x13c>
        } else {
            printf("[usertrap] unknown interrupt scause=%lx sepc=%lx\n", scause, sepc);
    802048c2:	fc843603          	ld	a2,-56(s0)
    802048c6:	fd843583          	ld	a1,-40(s0)
    802048ca:	00016517          	auipc	a0,0x16
    802048ce:	29e50513          	addi	a0,a0,670 # 8021ab68 <syscall_performance_bin+0xc98>
    802048d2:	ffffc097          	auipc	ra,0xffffc
    802048d6:	404080e7          	jalr	1028(ra) # 80200cd6 <printf>
    802048da:	a815                	j	8020490e <usertrap+0x13c>
        }
    } else {
        struct trap_info info = { .sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval };
    802048dc:	fc843783          	ld	a5,-56(s0)
    802048e0:	f8f43823          	sd	a5,-112(s0)
    802048e4:	fc043783          	ld	a5,-64(s0)
    802048e8:	f8f43c23          	sd	a5,-104(s0)
    802048ec:	fd843783          	ld	a5,-40(s0)
    802048f0:	faf43023          	sd	a5,-96(s0)
    802048f4:	fd043783          	ld	a5,-48(s0)
    802048f8:	faf43423          	sd	a5,-88(s0)
        handle_exception(tf, &info);
    802048fc:	f9040793          	addi	a5,s0,-112
    80204900:	85be                	mv	a1,a5
    80204902:	fe043503          	ld	a0,-32(s0)
    80204906:	fffff097          	auipc	ra,0xfffff
    8020490a:	1ac080e7          	jalr	428(ra) # 80203ab2 <handle_exception>
    }

    usertrapret();
    8020490e:	00000097          	auipc	ra,0x0
    80204912:	012080e7          	jalr	18(ra) # 80204920 <usertrapret>
}
    80204916:	0001                	nop
    80204918:	70a6                	ld	ra,104(sp)
    8020491a:	7406                	ld	s0,96(sp)
    8020491c:	6165                	addi	sp,sp,112
    8020491e:	8082                	ret

0000000080204920 <usertrapret>:

void usertrapret(void) {
    80204920:	7179                	addi	sp,sp,-48
    80204922:	f406                	sd	ra,40(sp)
    80204924:	f022                	sd	s0,32(sp)
    80204926:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80204928:	00000097          	auipc	ra,0x0
    8020492c:	5f8080e7          	jalr	1528(ra) # 80204f20 <myproc>
    80204930:	fea43423          	sd	a0,-24(s0)
    // 计算 trampoline 中 uservec 的虚拟地址（对双方页表一致）
    uint64 uservec_va = (uint64)TRAMPOLINE + ((uint64)uservec - (uint64)trampoline);
    80204934:	00000717          	auipc	a4,0x0
    80204938:	34c70713          	addi	a4,a4,844 # 80204c80 <trampoline>
    8020493c:	77fd                	lui	a5,0xfffff
    8020493e:	973e                	add	a4,a4,a5
    80204940:	00000797          	auipc	a5,0x0
    80204944:	34078793          	addi	a5,a5,832 # 80204c80 <trampoline>
    80204948:	40f707b3          	sub	a5,a4,a5
    8020494c:	fef43023          	sd	a5,-32(s0)
    w_stvec(uservec_va);
    80204950:	fe043503          	ld	a0,-32(s0)
    80204954:	fffff097          	auipc	ra,0xfffff
    80204958:	cc0080e7          	jalr	-832(ra) # 80203614 <w_stvec>

    // sscratch 设为 TRAPFRAME 的虚拟地址（trampoline 代码用它访问 tf）
    w_sscratch((uint64)TRAPFRAME);
    8020495c:	7579                	lui	a0,0xffffe
    8020495e:	fffff097          	auipc	ra,0xfffff
    80204962:	c5a080e7          	jalr	-934(ra) # 802035b8 <w_sscratch>

    // 准备用户页表的 satp
    uint64 user_satp = MAKE_SATP(p->pagetable);
    80204966:	fe843783          	ld	a5,-24(s0)
    8020496a:	7fdc                	ld	a5,184(a5)
    8020496c:	00c7d713          	srli	a4,a5,0xc
    80204970:	57fd                	li	a5,-1
    80204972:	17fe                	slli	a5,a5,0x3f
    80204974:	8fd9                	or	a5,a5,a4
    80204976:	fcf43c23          	sd	a5,-40(s0)

    // 计算 trampoline 中 userret 的虚拟地址
    uint64 userret_va = (uint64)TRAMPOLINE + ((uint64)userret - (uint64)trampoline);
    8020497a:	00000717          	auipc	a4,0x0
    8020497e:	39c70713          	addi	a4,a4,924 # 80204d16 <userret>
    80204982:	77fd                	lui	a5,0xfffff
    80204984:	973e                	add	a4,a4,a5
    80204986:	00000797          	auipc	a5,0x0
    8020498a:	2fa78793          	addi	a5,a5,762 # 80204c80 <trampoline>
    8020498e:	40f707b3          	sub	a5,a4,a5
    80204992:	fcf43823          	sd	a5,-48(s0)

    // a0 = TRAPFRAME（虚拟地址，双方页表都映射）
    // a1 = user_satp
    register uint64 a0 asm("a0") = (uint64)TRAPFRAME;
    80204996:	7579                	lui	a0,0xffffe
    register uint64 a1 asm("a1") = user_satp;
    80204998:	fd843583          	ld	a1,-40(s0)
    register void (*tgt)(uint64, uint64) asm("t0") = (void *)userret_va;
    8020499c:	fd043783          	ld	a5,-48(s0)
    802049a0:	82be                	mv	t0,a5

    // 跳到 trampoline 上的 userret
    asm volatile("jr t0" :: "r"(a0), "r"(a1), "r"(tgt) : "memory");
    802049a2:	8282                	jr	t0
}
    802049a4:	0001                	nop
    802049a6:	70a2                	ld	ra,40(sp)
    802049a8:	7402                	ld	s0,32(sp)
    802049aa:	6145                	addi	sp,sp,48
    802049ac:	8082                	ret

00000000802049ae <write32>:
    802049ae:	7179                	addi	sp,sp,-48
    802049b0:	f406                	sd	ra,40(sp)
    802049b2:	f022                	sd	s0,32(sp)
    802049b4:	1800                	addi	s0,sp,48
    802049b6:	fca43c23          	sd	a0,-40(s0)
    802049ba:	87ae                	mv	a5,a1
    802049bc:	fcf42a23          	sw	a5,-44(s0)
    802049c0:	fd843783          	ld	a5,-40(s0)
    802049c4:	8b8d                	andi	a5,a5,3
    802049c6:	eb99                	bnez	a5,802049dc <write32+0x2e>
    802049c8:	fd843783          	ld	a5,-40(s0)
    802049cc:	fef43423          	sd	a5,-24(s0)
    802049d0:	fe843783          	ld	a5,-24(s0)
    802049d4:	fd442703          	lw	a4,-44(s0)
    802049d8:	c398                	sw	a4,0(a5)
    802049da:	a819                	j	802049f0 <write32+0x42>
    802049dc:	fd843583          	ld	a1,-40(s0)
    802049e0:	00018517          	auipc	a0,0x18
    802049e4:	fb850513          	addi	a0,a0,-72 # 8021c998 <syscall_performance_bin+0x670>
    802049e8:	ffffc097          	auipc	ra,0xffffc
    802049ec:	2ee080e7          	jalr	750(ra) # 80200cd6 <printf>
    802049f0:	0001                	nop
    802049f2:	70a2                	ld	ra,40(sp)
    802049f4:	7402                	ld	s0,32(sp)
    802049f6:	6145                	addi	sp,sp,48
    802049f8:	8082                	ret

00000000802049fa <read32>:
    802049fa:	7179                	addi	sp,sp,-48
    802049fc:	f406                	sd	ra,40(sp)
    802049fe:	f022                	sd	s0,32(sp)
    80204a00:	1800                	addi	s0,sp,48
    80204a02:	fca43c23          	sd	a0,-40(s0)
    80204a06:	fd843783          	ld	a5,-40(s0)
    80204a0a:	8b8d                	andi	a5,a5,3
    80204a0c:	eb91                	bnez	a5,80204a20 <read32+0x26>
    80204a0e:	fd843783          	ld	a5,-40(s0)
    80204a12:	fef43423          	sd	a5,-24(s0)
    80204a16:	fe843783          	ld	a5,-24(s0)
    80204a1a:	439c                	lw	a5,0(a5)
    80204a1c:	2781                	sext.w	a5,a5
    80204a1e:	a821                	j	80204a36 <read32+0x3c>
    80204a20:	fd843583          	ld	a1,-40(s0)
    80204a24:	00018517          	auipc	a0,0x18
    80204a28:	fa450513          	addi	a0,a0,-92 # 8021c9c8 <syscall_performance_bin+0x6a0>
    80204a2c:	ffffc097          	auipc	ra,0xffffc
    80204a30:	2aa080e7          	jalr	682(ra) # 80200cd6 <printf>
    80204a34:	4781                	li	a5,0
    80204a36:	853e                	mv	a0,a5
    80204a38:	70a2                	ld	ra,40(sp)
    80204a3a:	7402                	ld	s0,32(sp)
    80204a3c:	6145                	addi	sp,sp,48
    80204a3e:	8082                	ret

0000000080204a40 <plic_init>:
void plic_init(void) {
    80204a40:	1101                	addi	sp,sp,-32
    80204a42:	ec06                	sd	ra,24(sp)
    80204a44:	e822                	sd	s0,16(sp)
    80204a46:	1000                	addi	s0,sp,32
    for (int i = 1; i <= 32; i++) {
    80204a48:	4785                	li	a5,1
    80204a4a:	fef42623          	sw	a5,-20(s0)
    80204a4e:	a805                	j	80204a7e <plic_init+0x3e>
        uint64 addr = PLIC + i * 4;
    80204a50:	fec42783          	lw	a5,-20(s0)
    80204a54:	0027979b          	slliw	a5,a5,0x2
    80204a58:	2781                	sext.w	a5,a5
    80204a5a:	873e                	mv	a4,a5
    80204a5c:	0c0007b7          	lui	a5,0xc000
    80204a60:	97ba                	add	a5,a5,a4
    80204a62:	fef43023          	sd	a5,-32(s0)
        write32(addr, 0);
    80204a66:	4581                	li	a1,0
    80204a68:	fe043503          	ld	a0,-32(s0)
    80204a6c:	00000097          	auipc	ra,0x0
    80204a70:	f42080e7          	jalr	-190(ra) # 802049ae <write32>
    for (int i = 1; i <= 32; i++) {
    80204a74:	fec42783          	lw	a5,-20(s0)
    80204a78:	2785                	addiw	a5,a5,1 # c000001 <_entry-0x741fffff>
    80204a7a:	fef42623          	sw	a5,-20(s0)
    80204a7e:	fec42783          	lw	a5,-20(s0)
    80204a82:	0007871b          	sext.w	a4,a5
    80204a86:	02000793          	li	a5,32
    80204a8a:	fce7d3e3          	bge	a5,a4,80204a50 <plic_init+0x10>
    write32(PLIC + UART0_IRQ * 4, 1);
    80204a8e:	4585                	li	a1,1
    80204a90:	0c0007b7          	lui	a5,0xc000
    80204a94:	02878513          	addi	a0,a5,40 # c000028 <_entry-0x741fffd8>
    80204a98:	00000097          	auipc	ra,0x0
    80204a9c:	f16080e7          	jalr	-234(ra) # 802049ae <write32>
    write32(PLIC + VIRTIO0_IRQ * 4, 1);
    80204aa0:	4585                	li	a1,1
    80204aa2:	0c0007b7          	lui	a5,0xc000
    80204aa6:	00478513          	addi	a0,a5,4 # c000004 <_entry-0x741ffffc>
    80204aaa:	00000097          	auipc	ra,0x0
    80204aae:	f04080e7          	jalr	-252(ra) # 802049ae <write32>
    write32(PLIC_ENABLE, (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ));
    80204ab2:	40200593          	li	a1,1026
    80204ab6:	0c0027b7          	lui	a5,0xc002
    80204aba:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204abe:	00000097          	auipc	ra,0x0
    80204ac2:	ef0080e7          	jalr	-272(ra) # 802049ae <write32>
    write32(PLIC_THRESHOLD, 0);
    80204ac6:	4581                	li	a1,0
    80204ac8:	0c201537          	lui	a0,0xc201
    80204acc:	00000097          	auipc	ra,0x0
    80204ad0:	ee2080e7          	jalr	-286(ra) # 802049ae <write32>
}
    80204ad4:	0001                	nop
    80204ad6:	60e2                	ld	ra,24(sp)
    80204ad8:	6442                	ld	s0,16(sp)
    80204ada:	6105                	addi	sp,sp,32
    80204adc:	8082                	ret

0000000080204ade <plic_enable>:
void plic_enable(int irq) {
    80204ade:	7179                	addi	sp,sp,-48
    80204ae0:	f406                	sd	ra,40(sp)
    80204ae2:	f022                	sd	s0,32(sp)
    80204ae4:	1800                	addi	s0,sp,48
    80204ae6:	87aa                	mv	a5,a0
    80204ae8:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    80204aec:	0c0027b7          	lui	a5,0xc002
    80204af0:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204af4:	00000097          	auipc	ra,0x0
    80204af8:	f06080e7          	jalr	-250(ra) # 802049fa <read32>
    80204afc:	87aa                	mv	a5,a0
    80204afe:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old | (1 << irq));
    80204b02:	fdc42783          	lw	a5,-36(s0)
    80204b06:	873e                	mv	a4,a5
    80204b08:	4785                	li	a5,1
    80204b0a:	00e797bb          	sllw	a5,a5,a4
    80204b0e:	2781                	sext.w	a5,a5
    80204b10:	2781                	sext.w	a5,a5
    80204b12:	fec42703          	lw	a4,-20(s0)
    80204b16:	8fd9                	or	a5,a5,a4
    80204b18:	2781                	sext.w	a5,a5
    80204b1a:	85be                	mv	a1,a5
    80204b1c:	0c0027b7          	lui	a5,0xc002
    80204b20:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204b24:	00000097          	auipc	ra,0x0
    80204b28:	e8a080e7          	jalr	-374(ra) # 802049ae <write32>
}
    80204b2c:	0001                	nop
    80204b2e:	70a2                	ld	ra,40(sp)
    80204b30:	7402                	ld	s0,32(sp)
    80204b32:	6145                	addi	sp,sp,48
    80204b34:	8082                	ret

0000000080204b36 <plic_disable>:
void plic_disable(int irq) {
    80204b36:	7179                	addi	sp,sp,-48
    80204b38:	f406                	sd	ra,40(sp)
    80204b3a:	f022                	sd	s0,32(sp)
    80204b3c:	1800                	addi	s0,sp,48
    80204b3e:	87aa                	mv	a5,a0
    80204b40:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    80204b44:	0c0027b7          	lui	a5,0xc002
    80204b48:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204b4c:	00000097          	auipc	ra,0x0
    80204b50:	eae080e7          	jalr	-338(ra) # 802049fa <read32>
    80204b54:	87aa                	mv	a5,a0
    80204b56:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old & ~(1 << irq));
    80204b5a:	fdc42783          	lw	a5,-36(s0)
    80204b5e:	873e                	mv	a4,a5
    80204b60:	4785                	li	a5,1
    80204b62:	00e797bb          	sllw	a5,a5,a4
    80204b66:	2781                	sext.w	a5,a5
    80204b68:	fff7c793          	not	a5,a5
    80204b6c:	2781                	sext.w	a5,a5
    80204b6e:	2781                	sext.w	a5,a5
    80204b70:	fec42703          	lw	a4,-20(s0)
    80204b74:	8ff9                	and	a5,a5,a4
    80204b76:	2781                	sext.w	a5,a5
    80204b78:	85be                	mv	a1,a5
    80204b7a:	0c0027b7          	lui	a5,0xc002
    80204b7e:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204b82:	00000097          	auipc	ra,0x0
    80204b86:	e2c080e7          	jalr	-468(ra) # 802049ae <write32>
}
    80204b8a:	0001                	nop
    80204b8c:	70a2                	ld	ra,40(sp)
    80204b8e:	7402                	ld	s0,32(sp)
    80204b90:	6145                	addi	sp,sp,48
    80204b92:	8082                	ret

0000000080204b94 <plic_claim>:
int plic_claim(void) {
    80204b94:	1141                	addi	sp,sp,-16
    80204b96:	e406                	sd	ra,8(sp)
    80204b98:	e022                	sd	s0,0(sp)
    80204b9a:	0800                	addi	s0,sp,16
    return read32(PLIC_CLAIM);
    80204b9c:	0c2017b7          	lui	a5,0xc201
    80204ba0:	00478513          	addi	a0,a5,4 # c201004 <_entry-0x73ffeffc>
    80204ba4:	00000097          	auipc	ra,0x0
    80204ba8:	e56080e7          	jalr	-426(ra) # 802049fa <read32>
    80204bac:	87aa                	mv	a5,a0
    80204bae:	2781                	sext.w	a5,a5
    80204bb0:	2781                	sext.w	a5,a5
}
    80204bb2:	853e                	mv	a0,a5
    80204bb4:	60a2                	ld	ra,8(sp)
    80204bb6:	6402                	ld	s0,0(sp)
    80204bb8:	0141                	addi	sp,sp,16
    80204bba:	8082                	ret

0000000080204bbc <plic_complete>:
void plic_complete(int irq) {
    80204bbc:	1101                	addi	sp,sp,-32
    80204bbe:	ec06                	sd	ra,24(sp)
    80204bc0:	e822                	sd	s0,16(sp)
    80204bc2:	1000                	addi	s0,sp,32
    80204bc4:	87aa                	mv	a5,a0
    80204bc6:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_CLAIM, irq);
    80204bca:	fec42783          	lw	a5,-20(s0)
    80204bce:	85be                	mv	a1,a5
    80204bd0:	0c2017b7          	lui	a5,0xc201
    80204bd4:	00478513          	addi	a0,a5,4 # c201004 <_entry-0x73ffeffc>
    80204bd8:	00000097          	auipc	ra,0x0
    80204bdc:	dd6080e7          	jalr	-554(ra) # 802049ae <write32>
    80204be0:	0001                	nop
    80204be2:	60e2                	ld	ra,24(sp)
    80204be4:	6442                	ld	s0,16(sp)
    80204be6:	6105                	addi	sp,sp,32
    80204be8:	8082                	ret
    80204bea:	0000                	unimp
    80204bec:	0000                	unimp
	...

0000000080204bf0 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80204bf0:	7111                	addi	sp,sp,-256

        # save ALL registers (caller-saved and callee-saved)
        sd ra, 0(sp)
    80204bf2:	e006                	sd	ra,0(sp)
        sd gp, 16(sp)
    80204bf4:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80204bf6:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80204bf8:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80204bfa:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    80204bfc:	f81e                	sd	t2,48(sp)
        sd s0, 56(sp)    # 保存s0/fp
    80204bfe:	fc22                	sd	s0,56(sp)
        sd s1, 64(sp)    # 保存s1
    80204c00:	e0a6                	sd	s1,64(sp)
        sd a0, 72(sp)
    80204c02:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80204c04:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80204c06:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80204c08:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80204c0a:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80204c0c:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80204c0e:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80204c10:	e146                	sd	a7,128(sp)
        sd s2, 136(sp)   # 保存s2
    80204c12:	e54a                	sd	s2,136(sp)
        sd s3, 144(sp)   # 保存s3
    80204c14:	e94e                	sd	s3,144(sp)
        sd s4, 152(sp)   # 保存s4
    80204c16:	ed52                	sd	s4,152(sp)
        sd s5, 160(sp)   # 保存s5
    80204c18:	f156                	sd	s5,160(sp)
        sd s6, 168(sp)   # 保存s6
    80204c1a:	f55a                	sd	s6,168(sp)
        sd s7, 176(sp)   # 保存s7
    80204c1c:	f95e                	sd	s7,176(sp)
        sd s8, 184(sp)   # 保存s8
    80204c1e:	fd62                	sd	s8,184(sp)
        sd s9, 192(sp)   # 保存s9
    80204c20:	e1e6                	sd	s9,192(sp)
        sd s10, 200(sp)  # 保存s10
    80204c22:	e5ea                	sd	s10,200(sp)
        sd s11, 208(sp)  # 保存s11
    80204c24:	e9ee                	sd	s11,208(sp)
        sd t3, 216(sp)
    80204c26:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80204c28:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80204c2a:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80204c2c:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80204c2e:	fffff097          	auipc	ra,0xfffff
    80204c32:	d12080e7          	jalr	-750(ra) # 80203940 <kerneltrap>

        # restore ALL registers
        ld ra, 0(sp)
    80204c36:	6082                	ld	ra,0(sp)
        # 不恢复sp
        ld gp, 16(sp)
    80204c38:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    80204c3a:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80204c3c:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80204c3e:	73c2                	ld	t2,48(sp)
        ld s0, 56(sp)    # 恢复s0/fp
    80204c40:	7462                	ld	s0,56(sp)
        ld s1, 64(sp)    # 恢复s1
    80204c42:	6486                	ld	s1,64(sp)
        ld a0, 72(sp)
    80204c44:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80204c46:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80204c48:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80204c4a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    80204c4c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    80204c4e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80204c50:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80204c52:	688a                	ld	a7,128(sp)
        ld s2, 136(sp)   # 恢复s2
    80204c54:	692a                	ld	s2,136(sp)
        ld s3, 144(sp)   # 恢复s3
    80204c56:	69ca                	ld	s3,144(sp)
        ld s4, 152(sp)   # 恢复s4
    80204c58:	6a6a                	ld	s4,152(sp)
        ld s5, 160(sp)   # 恢复s5
    80204c5a:	7a8a                	ld	s5,160(sp)
        ld s6, 168(sp)   # 恢复s6
    80204c5c:	7b2a                	ld	s6,168(sp)
        ld s7, 176(sp)   # 恢复s7
    80204c5e:	7bca                	ld	s7,176(sp)
        ld s8, 184(sp)   # 恢复s8
    80204c60:	7c6a                	ld	s8,184(sp)
        ld s9, 192(sp)   # 恢复s9
    80204c62:	6c8e                	ld	s9,192(sp)
        ld s10, 200(sp)  # 恢复s10
    80204c64:	6d2e                	ld	s10,200(sp)
        ld s11, 208(sp)  # 恢复s11
    80204c66:	6dce                	ld	s11,208(sp)
        ld t3, 216(sp)
    80204c68:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80204c6a:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80204c6c:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80204c6e:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80204c70:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
    80204c72:	10200073          	sret
    80204c76:	0001                	nop
    80204c78:	00000013          	nop
    80204c7c:	00000013          	nop

0000000080204c80 <trampoline>:
trampoline:
.align 4

uservec:
    # 1. 取 trapframe 指针
    csrrw a0, sscratch, a0      # a0 = TRAPFRAME (用户页表下可访问), sscratch = user a0
    80204c80:	14051573          	csrrw	a0,sscratch,a0

    # 2. 在切换页表前，先读出关键字段到 t3–t6
    ld   t3, 0(a0)              # t3 = kernel_satp
    80204c84:	00053e03          	ld	t3,0(a0) # c201000 <_entry-0x73fff000>
    ld   t4, 8(a0)              # t4 = kernel_sp
    80204c88:	00853e83          	ld	t4,8(a0)
    ld   t5, 264(a0)            # t5 = usertrap
    80204c8c:	10853f03          	ld	t5,264(a0)
	ld   t6, 272(a0)			# t6 = kernel_vec
    80204c90:	11053f83          	ld	t6,272(a0)

    # 3. 保存用户寄存器到 trapframe（仍在用户页表下）
    sd   ra, 48(a0)
    80204c94:	02153823          	sd	ra,48(a0)
    sd   sp, 56(a0)
    80204c98:	02253c23          	sd	sp,56(a0)
    sd   gp, 64(a0)
    80204c9c:	04353023          	sd	gp,64(a0)
    sd   tp, 72(a0)
    80204ca0:	04453423          	sd	tp,72(a0)
    sd   t0, 80(a0)
    80204ca4:	04553823          	sd	t0,80(a0)
    sd   t1, 88(a0)
    80204ca8:	04653c23          	sd	t1,88(a0)
    sd   t2, 96(a0)
    80204cac:	06753023          	sd	t2,96(a0)
    sd   s0, 104(a0)
    80204cb0:	f520                	sd	s0,104(a0)
    sd   s1, 112(a0)
    80204cb2:	f924                	sd	s1,112(a0)

    # 保存用户 a0：先取回 sscratch 里的原值
    csrr t2, sscratch
    80204cb4:	140023f3          	csrr	t2,sscratch
    sd   t2, 120(a0)
    80204cb8:	06753c23          	sd	t2,120(a0)

    sd   a1, 128(a0)
    80204cbc:	e14c                	sd	a1,128(a0)
    sd   a2, 136(a0)
    80204cbe:	e550                	sd	a2,136(a0)
    sd   a3, 144(a0)
    80204cc0:	e954                	sd	a3,144(a0)
    sd   a4, 152(a0)
    80204cc2:	ed58                	sd	a4,152(a0)
    sd   a5, 160(a0)
    80204cc4:	f15c                	sd	a5,160(a0)
    sd   a6, 168(a0)
    80204cc6:	0b053423          	sd	a6,168(a0)
    sd   a7, 176(a0)
    80204cca:	0b153823          	sd	a7,176(a0)
    sd   s2, 184(a0)
    80204cce:	0b253c23          	sd	s2,184(a0)
    sd   s3, 192(a0)
    80204cd2:	0d353023          	sd	s3,192(a0)
    sd   s4, 200(a0)
    80204cd6:	0d453423          	sd	s4,200(a0)
    sd   s5, 208(a0)
    80204cda:	0d553823          	sd	s5,208(a0)
    sd   s6, 216(a0)
    80204cde:	0d653c23          	sd	s6,216(a0)
    sd   s7, 224(a0)
    80204ce2:	0f753023          	sd	s7,224(a0)
    sd   s8, 232(a0)
    80204ce6:	0f853423          	sd	s8,232(a0)
    sd   s9, 240(a0)
    80204cea:	0f953823          	sd	s9,240(a0)
    sd   s10, 248(a0)
    80204cee:	0fa53c23          	sd	s10,248(a0)
    sd   s11, 256(a0)
    80204cf2:	11b53023          	sd	s11,256(a0)

    # 保存控制寄存器
    csrr t0, sstatus
    80204cf6:	100022f3          	csrr	t0,sstatus
    sd   t0, 24(a0)
    80204cfa:	00553c23          	sd	t0,24(a0)
    csrr t1, sepc
    80204cfe:	14102373          	csrr	t1,sepc
    sd   t1, 32(a0)
    80204d02:	02653023          	sd	t1,32(a0)

    # 4. 切换到内核页表
    csrw satp, t3
    80204d06:	180e1073          	csrw	satp,t3
    sfence.vma x0, x0
    80204d0a:	12000073          	sfence.vma

    # 5. 切换到内核栈
    mv   sp, t4
    80204d0e:	8176                	mv	sp,t4

    # 6. 设置 stvec 并跳转到 C 层 usertrap
    csrw stvec, t6
    80204d10:	105f9073          	csrw	stvec,t6
    jr   t5
    80204d14:	8f02                	jr	t5

0000000080204d16 <userret>:
userret:
        csrw satp, a1
    80204d16:	18059073          	csrw	satp,a1
        sfence.vma zero, zero
    80204d1a:	12000073          	sfence.vma
        ld ra, 48(a0)
    80204d1e:	03053083          	ld	ra,48(a0)
        ld sp, 56(a0)
    80204d22:	03853103          	ld	sp,56(a0)
        ld gp, 64(a0)
    80204d26:	04053183          	ld	gp,64(a0)
        ld tp, 72(a0)
    80204d2a:	04853203          	ld	tp,72(a0)
        ld t0, 80(a0)
    80204d2e:	05053283          	ld	t0,80(a0)
        ld t1, 88(a0)
    80204d32:	05853303          	ld	t1,88(a0)
        ld t2, 96(a0)
    80204d36:	06053383          	ld	t2,96(a0)
        ld s0, 104(a0)
    80204d3a:	7520                	ld	s0,104(a0)
        ld s1, 112(a0)
    80204d3c:	7924                	ld	s1,112(a0)
        ld a1, 128(a0)
    80204d3e:	614c                	ld	a1,128(a0)
        ld a2, 136(a0)
    80204d40:	6550                	ld	a2,136(a0)
        ld a3, 144(a0)
    80204d42:	6954                	ld	a3,144(a0)
        ld a4, 152(a0)
    80204d44:	6d58                	ld	a4,152(a0)
        ld a5, 160(a0)
    80204d46:	715c                	ld	a5,160(a0)
        ld a6, 168(a0)
    80204d48:	0a853803          	ld	a6,168(a0)
        ld a7, 176(a0)
    80204d4c:	0b053883          	ld	a7,176(a0)
        ld s2, 184(a0)
    80204d50:	0b853903          	ld	s2,184(a0)
        ld s3, 192(a0)
    80204d54:	0c053983          	ld	s3,192(a0)
        ld s4, 200(a0)
    80204d58:	0c853a03          	ld	s4,200(a0)
        ld s5, 208(a0)
    80204d5c:	0d053a83          	ld	s5,208(a0)
        ld s6, 216(a0)
    80204d60:	0d853b03          	ld	s6,216(a0)
        ld s7, 224(a0)
    80204d64:	0e053b83          	ld	s7,224(a0)
        ld s8, 232(a0)
    80204d68:	0e853c03          	ld	s8,232(a0)
        ld s9, 240(a0)
    80204d6c:	0f053c83          	ld	s9,240(a0)
        ld s10, 248(a0)
    80204d70:	0f853d03          	ld	s10,248(a0)
        ld s11, 256(a0)
    80204d74:	10053d83          	ld	s11,256(a0)

        ld t3, 32(a0)      # 恢复 sepc
    80204d78:	02053e03          	ld	t3,32(a0)
        csrw sepc, t3
    80204d7c:	141e1073          	csrw	sepc,t3
        ld t3, 24(a0)      # 恢复 sstatus
    80204d80:	01853e03          	ld	t3,24(a0)
        csrw sstatus, t3
    80204d84:	100e1073          	csrw	sstatus,t3
		csrw sscratch, a0
    80204d88:	14051073          	csrw	sscratch,a0
		ld a0, 120(a0)
    80204d8c:	7d28                	ld	a0,120(a0)
    80204d8e:	10200073          	sret
    80204d92:	0001                	nop
    80204d94:	00000013          	nop
    80204d98:	00000013          	nop
    80204d9c:	00000013          	nop

0000000080204da0 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80204da0:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80204da4:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80204da8:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80204daa:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80204dac:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80204db0:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80204db4:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80204db8:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80204dbc:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80204dc0:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80204dc4:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80204dc8:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80204dcc:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80204dd0:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80204dd4:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80204dd8:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80204ddc:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80204dde:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80204de0:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80204de4:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80204de8:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80204dec:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80204df0:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80204df4:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80204df8:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80204dfc:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80204e00:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80204e04:	0685bd83          	ld	s11,104(a1)
        
        ret
    80204e08:	8082                	ret

0000000080204e0a <r_sstatus>:
	if(p->killed){
		printf("[sleep] Process PID %d killed when wakeup\n", p->pid);
		exit_proc(SYS_kill);
	}
}
void wakeup(void *chan) {
    80204e0a:	1101                	addi	sp,sp,-32
    80204e0c:	ec22                	sd	s0,24(sp)
    80204e0e:	1000                	addi	s0,sp,32
    for(int i = 0; i < PROC; i++) {
        struct proc *p = proc_table[i];
    80204e10:	100027f3          	csrr	a5,sstatus
    80204e14:	fef43423          	sd	a5,-24(s0)
        if(p->state == SLEEPING && p->chan == chan) {
    80204e18:	fe843783          	ld	a5,-24(s0)
            p->state = RUNNABLE;
    80204e1c:	853e                	mv	a0,a5
    80204e1e:	6462                	ld	s0,24(sp)
    80204e20:	6105                	addi	sp,sp,32
    80204e22:	8082                	ret

0000000080204e24 <w_sstatus>:
        }
    80204e24:	1101                	addi	sp,sp,-32
    80204e26:	ec22                	sd	s0,24(sp)
    80204e28:	1000                	addi	s0,sp,32
    80204e2a:	fea43423          	sd	a0,-24(s0)
    }
    80204e2e:	fe843783          	ld	a5,-24(s0)
    80204e32:	10079073          	csrw	sstatus,a5
}
    80204e36:	0001                	nop
    80204e38:	6462                	ld	s0,24(sp)
    80204e3a:	6105                	addi	sp,sp,32
    80204e3c:	8082                	ret

0000000080204e3e <intr_on>:
		if(pid == p->pid){
			p->killed = 1;
			break;
		}
	}
	return;
    80204e3e:	1141                	addi	sp,sp,-16
    80204e40:	e406                	sd	ra,8(sp)
    80204e42:	e022                	sd	s0,0(sp)
    80204e44:	0800                	addi	s0,sp,16
}
    80204e46:	00000097          	auipc	ra,0x0
    80204e4a:	fc4080e7          	jalr	-60(ra) # 80204e0a <r_sstatus>
    80204e4e:	87aa                	mv	a5,a0
    80204e50:	0027e793          	ori	a5,a5,2
    80204e54:	853e                	mv	a0,a5
    80204e56:	00000097          	auipc	ra,0x0
    80204e5a:	fce080e7          	jalr	-50(ra) # 80204e24 <w_sstatus>
void exit_proc(int status) {
    80204e5e:	0001                	nop
    80204e60:	60a2                	ld	ra,8(sp)
    80204e62:	6402                	ld	s0,0(sp)
    80204e64:	0141                	addi	sp,sp,16
    80204e66:	8082                	ret

0000000080204e68 <intr_off>:
    struct proc *p = myproc();
    if (p == 0) {
    80204e68:	1141                	addi	sp,sp,-16
    80204e6a:	e406                	sd	ra,8(sp)
    80204e6c:	e022                	sd	s0,0(sp)
    80204e6e:	0800                	addi	s0,sp,16
        panic("exit_proc: no current process");
    80204e70:	00000097          	auipc	ra,0x0
    80204e74:	f9a080e7          	jalr	-102(ra) # 80204e0a <r_sstatus>
    80204e78:	87aa                	mv	a5,a0
    80204e7a:	9bf5                	andi	a5,a5,-3
    80204e7c:	853e                	mv	a0,a5
    80204e7e:	00000097          	auipc	ra,0x0
    80204e82:	fa6080e7          	jalr	-90(ra) # 80204e24 <w_sstatus>
    }
    80204e86:	0001                	nop
    80204e88:	60a2                	ld	ra,8(sp)
    80204e8a:	6402                	ld	s0,0(sp)
    80204e8c:	0141                	addi	sp,sp,16
    80204e8e:	8082                	ret

0000000080204e90 <w_stvec>:
    p->exit_status = status;
    // 如果没有父进程的初始进程退出，表示关机
    80204e90:	1101                	addi	sp,sp,-32
    80204e92:	ec22                	sd	s0,24(sp)
    80204e94:	1000                	addi	s0,sp,32
    80204e96:	fea43423          	sd	a0,-24(s0)
    if (!p->parent) {
    80204e9a:	fe843783          	ld	a5,-24(s0)
    80204e9e:	10579073          	csrw	stvec,a5
        shutdown();
    80204ea2:	0001                	nop
    80204ea4:	6462                	ld	s0,24(sp)
    80204ea6:	6105                	addi	sp,sp,32
    80204ea8:	8082                	ret

0000000080204eaa <assert>:
                break;
            }
        }
        
        if (found_zombie) {
            if (status)
    80204eaa:	1101                	addi	sp,sp,-32
    80204eac:	ec06                	sd	ra,24(sp)
    80204eae:	e822                	sd	s0,16(sp)
    80204eb0:	1000                	addi	s0,sp,32
    80204eb2:	87aa                	mv	a5,a0
    80204eb4:	fef42623          	sw	a5,-20(s0)
                *status = zombie_status;
    80204eb8:	fec42783          	lw	a5,-20(s0)
    80204ebc:	2781                	sext.w	a5,a5
    80204ebe:	e79d                	bnez	a5,80204eec <assert+0x42>
			intr_on();
    80204ec0:	1b300613          	li	a2,435
    80204ec4:	0001a597          	auipc	a1,0x1a
    80204ec8:	92c58593          	addi	a1,a1,-1748 # 8021e7f0 <syscall_performance_bin+0x670>
    80204ecc:	0001a517          	auipc	a0,0x1a
    80204ed0:	93450513          	addi	a0,a0,-1740 # 8021e800 <syscall_performance_bin+0x680>
    80204ed4:	ffffc097          	auipc	ra,0xffffc
    80204ed8:	e02080e7          	jalr	-510(ra) # 80200cd6 <printf>
            free_proc(zombie_child);
    80204edc:	0001a517          	auipc	a0,0x1a
    80204ee0:	94c50513          	addi	a0,a0,-1716 # 8021e828 <syscall_performance_bin+0x6a8>
    80204ee4:	ffffd097          	auipc	ra,0xffffd
    80204ee8:	83e080e7          	jalr	-1986(ra) # 80201722 <panic>
            zombie_child = NULL;
            return zombie_pid;
    80204eec:	0001                	nop
    80204eee:	60e2                	ld	ra,24(sp)
    80204ef0:	6442                	ld	s0,16(sp)
    80204ef2:	6105                	addi	sp,sp,32
    80204ef4:	8082                	ret

0000000080204ef6 <shutdown>:
void shutdown() {
    80204ef6:	1141                	addi	sp,sp,-16
    80204ef8:	e406                	sd	ra,8(sp)
    80204efa:	e022                	sd	s0,0(sp)
    80204efc:	0800                	addi	s0,sp,16
	free_proc_table();
    80204efe:	00000097          	auipc	ra,0x0
    80204f02:	3aa080e7          	jalr	938(ra) # 802052a8 <free_proc_table>
    printf("关机\n");
    80204f06:	0001a517          	auipc	a0,0x1a
    80204f0a:	92a50513          	addi	a0,a0,-1750 # 8021e830 <syscall_performance_bin+0x6b0>
    80204f0e:	ffffc097          	auipc	ra,0xffffc
    80204f12:	dc8080e7          	jalr	-568(ra) # 80200cd6 <printf>
    asm volatile (
    80204f16:	48a1                	li	a7,8
    80204f18:	00000073          	ecall
    while (1) { }
    80204f1c:	0001                	nop
    80204f1e:	bffd                	j	80204f1c <shutdown+0x26>

0000000080204f20 <myproc>:
struct proc* myproc(void) {
    80204f20:	1141                	addi	sp,sp,-16
    80204f22:	e422                	sd	s0,8(sp)
    80204f24:	0800                	addi	s0,sp,16
    return current_proc;
    80204f26:	00021797          	auipc	a5,0x21
    80204f2a:	23278793          	addi	a5,a5,562 # 80226158 <current_proc>
    80204f2e:	639c                	ld	a5,0(a5)
}
    80204f30:	853e                	mv	a0,a5
    80204f32:	6422                	ld	s0,8(sp)
    80204f34:	0141                	addi	sp,sp,16
    80204f36:	8082                	ret

0000000080204f38 <mycpu>:
struct cpu* mycpu(void) {
    80204f38:	1141                	addi	sp,sp,-16
    80204f3a:	e406                	sd	ra,8(sp)
    80204f3c:	e022                	sd	s0,0(sp)
    80204f3e:	0800                	addi	s0,sp,16
    if (current_cpu == 0) {
    80204f40:	00021797          	auipc	a5,0x21
    80204f44:	22078793          	addi	a5,a5,544 # 80226160 <current_cpu>
    80204f48:	639c                	ld	a5,0(a5)
    80204f4a:	ebb9                	bnez	a5,80204fa0 <mycpu+0x68>
        warning("current_cpu is NULL, initializing...\n");
    80204f4c:	0001a517          	auipc	a0,0x1a
    80204f50:	8ec50513          	addi	a0,a0,-1812 # 8021e838 <syscall_performance_bin+0x6b8>
    80204f54:	ffffd097          	auipc	ra,0xffffd
    80204f58:	802080e7          	jalr	-2046(ra) # 80201756 <warning>
		memset(&cpu_instance, 0, sizeof(struct cpu));
    80204f5c:	07800613          	li	a2,120
    80204f60:	4581                	li	a1,0
    80204f62:	00021517          	auipc	a0,0x21
    80204f66:	7be50513          	addi	a0,a0,1982 # 80226720 <cpu_instance.0>
    80204f6a:	ffffd097          	auipc	ra,0xffffd
    80204f6e:	ef6080e7          	jalr	-266(ra) # 80201e60 <memset>
		current_cpu = &cpu_instance;
    80204f72:	00021797          	auipc	a5,0x21
    80204f76:	1ee78793          	addi	a5,a5,494 # 80226160 <current_cpu>
    80204f7a:	00021717          	auipc	a4,0x21
    80204f7e:	7a670713          	addi	a4,a4,1958 # 80226720 <cpu_instance.0>
    80204f82:	e398                	sd	a4,0(a5)
		printf("CPU initialized: %p\n", current_cpu);
    80204f84:	00021797          	auipc	a5,0x21
    80204f88:	1dc78793          	addi	a5,a5,476 # 80226160 <current_cpu>
    80204f8c:	639c                	ld	a5,0(a5)
    80204f8e:	85be                	mv	a1,a5
    80204f90:	0001a517          	auipc	a0,0x1a
    80204f94:	8d050513          	addi	a0,a0,-1840 # 8021e860 <syscall_performance_bin+0x6e0>
    80204f98:	ffffc097          	auipc	ra,0xffffc
    80204f9c:	d3e080e7          	jalr	-706(ra) # 80200cd6 <printf>
    return current_cpu;
    80204fa0:	00021797          	auipc	a5,0x21
    80204fa4:	1c078793          	addi	a5,a5,448 # 80226160 <current_cpu>
    80204fa8:	639c                	ld	a5,0(a5)
}
    80204faa:	853e                	mv	a0,a5
    80204fac:	60a2                	ld	ra,8(sp)
    80204fae:	6402                	ld	s0,0(sp)
    80204fb0:	0141                	addi	sp,sp,16
    80204fb2:	8082                	ret

0000000080204fb4 <return_to_user>:
void return_to_user(void) {
    80204fb4:	7179                	addi	sp,sp,-48
    80204fb6:	f406                	sd	ra,40(sp)
    80204fb8:	f022                	sd	s0,32(sp)
    80204fba:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80204fbc:	00000097          	auipc	ra,0x0
    80204fc0:	f64080e7          	jalr	-156(ra) # 80204f20 <myproc>
    80204fc4:	fea43423          	sd	a0,-24(s0)
    if (!p) panic("return_to_user: no current process");
    80204fc8:	fe843783          	ld	a5,-24(s0)
    80204fcc:	eb89                	bnez	a5,80204fde <return_to_user+0x2a>
    80204fce:	0001a517          	auipc	a0,0x1a
    80204fd2:	8aa50513          	addi	a0,a0,-1878 # 8021e878 <syscall_performance_bin+0x6f8>
    80204fd6:	ffffc097          	auipc	ra,0xffffc
    80204fda:	74c080e7          	jalr	1868(ra) # 80201722 <panic>
    w_stvec(TRAMPOLINE + (uservec - trampoline));
    80204fde:	00000717          	auipc	a4,0x0
    80204fe2:	ca270713          	addi	a4,a4,-862 # 80204c80 <trampoline>
    80204fe6:	00000797          	auipc	a5,0x0
    80204fea:	c9a78793          	addi	a5,a5,-870 # 80204c80 <trampoline>
    80204fee:	40f707b3          	sub	a5,a4,a5
    80204ff2:	873e                	mv	a4,a5
    80204ff4:	77fd                	lui	a5,0xfffff
    80204ff6:	97ba                	add	a5,a5,a4
    80204ff8:	853e                	mv	a0,a5
    80204ffa:	00000097          	auipc	ra,0x0
    80204ffe:	e96080e7          	jalr	-362(ra) # 80204e90 <w_stvec>
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80205002:	00000717          	auipc	a4,0x0
    80205006:	d1470713          	addi	a4,a4,-748 # 80204d16 <userret>
    8020500a:	00000797          	auipc	a5,0x0
    8020500e:	c7678793          	addi	a5,a5,-906 # 80204c80 <trampoline>
    80205012:	40f707b3          	sub	a5,a4,a5
    80205016:	873e                	mv	a4,a5
    80205018:	77fd                	lui	a5,0xfffff
    8020501a:	97ba                	add	a5,a5,a4
    8020501c:	fef43023          	sd	a5,-32(s0)
    uint64 satp = MAKE_SATP(p->pagetable);
    80205020:	fe843783          	ld	a5,-24(s0)
    80205024:	7fdc                	ld	a5,184(a5)
    80205026:	00c7d713          	srli	a4,a5,0xc
    8020502a:	57fd                	li	a5,-1
    8020502c:	17fe                	slli	a5,a5,0x3f
    8020502e:	8fd9                	or	a5,a5,a4
    80205030:	fcf43c23          	sd	a5,-40(s0)
    if ((trampoline_userret & ~(PGSIZE - 1)) != TRAMPOLINE) {
    80205034:	fe043703          	ld	a4,-32(s0)
    80205038:	77fd                	lui	a5,0xfffff
    8020503a:	8f7d                	and	a4,a4,a5
    8020503c:	77fd                	lui	a5,0xfffff
    8020503e:	00f70a63          	beq	a4,a5,80205052 <return_to_user+0x9e>
        panic("return_to_user: userret outside trampoline page");
    80205042:	0001a517          	auipc	a0,0x1a
    80205046:	85e50513          	addi	a0,a0,-1954 # 8021e8a0 <syscall_performance_bin+0x720>
    8020504a:	ffffc097          	auipc	ra,0xffffc
    8020504e:	6d8080e7          	jalr	1752(ra) # 80201722 <panic>
    void (*userret_fn)(uint64, uint64) = (void (*)(uint64, uint64))trampoline_userret;
    80205052:	fe043783          	ld	a5,-32(s0)
    80205056:	fcf43823          	sd	a5,-48(s0)
    userret_fn(TRAPFRAME, satp);
    8020505a:	fd043783          	ld	a5,-48(s0)
    8020505e:	fd843583          	ld	a1,-40(s0)
    80205062:	7579                	lui	a0,0xffffe
    80205064:	9782                	jalr	a5
    panic("return_to_user: should not return");
    80205066:	0001a517          	auipc	a0,0x1a
    8020506a:	86a50513          	addi	a0,a0,-1942 # 8021e8d0 <syscall_performance_bin+0x750>
    8020506e:	ffffc097          	auipc	ra,0xffffc
    80205072:	6b4080e7          	jalr	1716(ra) # 80201722 <panic>
}
    80205076:	0001                	nop
    80205078:	70a2                	ld	ra,40(sp)
    8020507a:	7402                	ld	s0,32(sp)
    8020507c:	6145                	addi	sp,sp,48
    8020507e:	8082                	ret

0000000080205080 <forkret>:
void forkret(void) {
    80205080:	1101                	addi	sp,sp,-32
    80205082:	ec06                	sd	ra,24(sp)
    80205084:	e822                	sd	s0,16(sp)
    80205086:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80205088:	00000097          	auipc	ra,0x0
    8020508c:	e98080e7          	jalr	-360(ra) # 80204f20 <myproc>
    80205090:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    80205094:	fe843783          	ld	a5,-24(s0)
    80205098:	eb89                	bnez	a5,802050aa <forkret+0x2a>
        panic("forkret: no current process");
    8020509a:	0001a517          	auipc	a0,0x1a
    8020509e:	85e50513          	addi	a0,a0,-1954 # 8021e8f8 <syscall_performance_bin+0x778>
    802050a2:	ffffc097          	auipc	ra,0xffffc
    802050a6:	680080e7          	jalr	1664(ra) # 80201722 <panic>
    if (p->killed) {
    802050aa:	fe843783          	ld	a5,-24(s0)
    802050ae:	0807a783          	lw	a5,128(a5) # fffffffffffff080 <_bss_end+0xffffffff7fdd88e0>
    802050b2:	c785                	beqz	a5,802050da <forkret+0x5a>
        printf("[forkret] Process PID %d killed before execution\n", p->pid);
    802050b4:	fe843783          	ld	a5,-24(s0)
    802050b8:	43dc                	lw	a5,4(a5)
    802050ba:	85be                	mv	a1,a5
    802050bc:	0001a517          	auipc	a0,0x1a
    802050c0:	85c50513          	addi	a0,a0,-1956 # 8021e918 <syscall_performance_bin+0x798>
    802050c4:	ffffc097          	auipc	ra,0xffffc
    802050c8:	c12080e7          	jalr	-1006(ra) # 80200cd6 <printf>
        exit_proc(SYS_kill);
    802050cc:	08100513          	li	a0,129
    802050d0:	00001097          	auipc	ra,0x1
    802050d4:	bf8080e7          	jalr	-1032(ra) # 80205cc8 <exit_proc>
        return; // 虽然不会执行到这里，但为了代码清晰
    802050d8:	a099                	j	8020511e <forkret+0x9e>
    if (p->is_user) {
    802050da:	fe843783          	ld	a5,-24(s0)
    802050de:	0a87a783          	lw	a5,168(a5)
    802050e2:	c791                	beqz	a5,802050ee <forkret+0x6e>
        return_to_user();
    802050e4:	00000097          	auipc	ra,0x0
    802050e8:	ed0080e7          	jalr	-304(ra) # 80204fb4 <return_to_user>
    802050ec:	a80d                	j	8020511e <forkret+0x9e>
		if (p->trapframe->epc) {
    802050ee:	fe843783          	ld	a5,-24(s0)
    802050f2:	63fc                	ld	a5,192(a5)
    802050f4:	739c                	ld	a5,32(a5)
    802050f6:	cf99                	beqz	a5,80205114 <forkret+0x94>
			void (*fn)(uint64) = (void(*)(uint64))p->trapframe->epc;
    802050f8:	fe843783          	ld	a5,-24(s0)
    802050fc:	63fc                	ld	a5,192(a5)
    802050fe:	739c                	ld	a5,32(a5)
    80205100:	fef43023          	sd	a5,-32(s0)
			fn(p->trapframe->a0);
    80205104:	fe843783          	ld	a5,-24(s0)
    80205108:	63fc                	ld	a5,192(a5)
    8020510a:	7fb8                	ld	a4,120(a5)
    8020510c:	fe043783          	ld	a5,-32(s0)
    80205110:	853a                	mv	a0,a4
    80205112:	9782                	jalr	a5
        exit_proc(0);  // 内核线程函数返回则退出
    80205114:	4501                	li	a0,0
    80205116:	00001097          	auipc	ra,0x1
    8020511a:	bb2080e7          	jalr	-1102(ra) # 80205cc8 <exit_proc>
}
    8020511e:	60e2                	ld	ra,24(sp)
    80205120:	6442                	ld	s0,16(sp)
    80205122:	6105                	addi	sp,sp,32
    80205124:	8082                	ret

0000000080205126 <init_proc>:
void init_proc(void){
    80205126:	1101                	addi	sp,sp,-32
    80205128:	ec06                	sd	ra,24(sp)
    8020512a:	e822                	sd	s0,16(sp)
    8020512c:	1000                	addi	s0,sp,32
    for (int i = 0; i < PROC; i++) {
    8020512e:	fe042623          	sw	zero,-20(s0)
    80205132:	aa81                	j	80205282 <init_proc+0x15c>
        void *page = alloc_page();
    80205134:	ffffe097          	auipc	ra,0xffffe
    80205138:	134080e7          	jalr	308(ra) # 80203268 <alloc_page>
    8020513c:	fea43023          	sd	a0,-32(s0)
        if (!page) panic("init_proc: alloc_page failed for proc_table");
    80205140:	fe043783          	ld	a5,-32(s0)
    80205144:	eb89                	bnez	a5,80205156 <init_proc+0x30>
    80205146:	0001a517          	auipc	a0,0x1a
    8020514a:	80a50513          	addi	a0,a0,-2038 # 8021e950 <syscall_performance_bin+0x7d0>
    8020514e:	ffffc097          	auipc	ra,0xffffc
    80205152:	5d4080e7          	jalr	1492(ra) # 80201722 <panic>
        proc_table_mem[i] = page;
    80205156:	00021717          	auipc	a4,0x21
    8020515a:	4ca70713          	addi	a4,a4,1226 # 80226620 <proc_table_mem>
    8020515e:	fec42783          	lw	a5,-20(s0)
    80205162:	078e                	slli	a5,a5,0x3
    80205164:	97ba                	add	a5,a5,a4
    80205166:	fe043703          	ld	a4,-32(s0)
    8020516a:	e398                	sd	a4,0(a5)
        proc_table[i] = (struct proc *)page;
    8020516c:	00021717          	auipc	a4,0x21
    80205170:	3ac70713          	addi	a4,a4,940 # 80226518 <proc_table>
    80205174:	fec42783          	lw	a5,-20(s0)
    80205178:	078e                	slli	a5,a5,0x3
    8020517a:	97ba                	add	a5,a5,a4
    8020517c:	fe043703          	ld	a4,-32(s0)
    80205180:	e398                	sd	a4,0(a5)
        memset(proc_table[i], 0, sizeof(struct proc));
    80205182:	00021717          	auipc	a4,0x21
    80205186:	39670713          	addi	a4,a4,918 # 80226518 <proc_table>
    8020518a:	fec42783          	lw	a5,-20(s0)
    8020518e:	078e                	slli	a5,a5,0x3
    80205190:	97ba                	add	a5,a5,a4
    80205192:	639c                	ld	a5,0(a5)
    80205194:	0c800613          	li	a2,200
    80205198:	4581                	li	a1,0
    8020519a:	853e                	mv	a0,a5
    8020519c:	ffffd097          	auipc	ra,0xffffd
    802051a0:	cc4080e7          	jalr	-828(ra) # 80201e60 <memset>
        proc_table[i]->state = UNUSED;
    802051a4:	00021717          	auipc	a4,0x21
    802051a8:	37470713          	addi	a4,a4,884 # 80226518 <proc_table>
    802051ac:	fec42783          	lw	a5,-20(s0)
    802051b0:	078e                	slli	a5,a5,0x3
    802051b2:	97ba                	add	a5,a5,a4
    802051b4:	639c                	ld	a5,0(a5)
    802051b6:	0007a023          	sw	zero,0(a5)
        proc_table[i]->pid = 0;
    802051ba:	00021717          	auipc	a4,0x21
    802051be:	35e70713          	addi	a4,a4,862 # 80226518 <proc_table>
    802051c2:	fec42783          	lw	a5,-20(s0)
    802051c6:	078e                	slli	a5,a5,0x3
    802051c8:	97ba                	add	a5,a5,a4
    802051ca:	639c                	ld	a5,0(a5)
    802051cc:	0007a223          	sw	zero,4(a5)
        proc_table[i]->kstack = 0;
    802051d0:	00021717          	auipc	a4,0x21
    802051d4:	34870713          	addi	a4,a4,840 # 80226518 <proc_table>
    802051d8:	fec42783          	lw	a5,-20(s0)
    802051dc:	078e                	slli	a5,a5,0x3
    802051de:	97ba                	add	a5,a5,a4
    802051e0:	639c                	ld	a5,0(a5)
    802051e2:	0007b423          	sd	zero,8(a5)
        proc_table[i]->pagetable = 0;
    802051e6:	00021717          	auipc	a4,0x21
    802051ea:	33270713          	addi	a4,a4,818 # 80226518 <proc_table>
    802051ee:	fec42783          	lw	a5,-20(s0)
    802051f2:	078e                	slli	a5,a5,0x3
    802051f4:	97ba                	add	a5,a5,a4
    802051f6:	639c                	ld	a5,0(a5)
    802051f8:	0a07bc23          	sd	zero,184(a5)
        proc_table[i]->trapframe = 0;
    802051fc:	00021717          	auipc	a4,0x21
    80205200:	31c70713          	addi	a4,a4,796 # 80226518 <proc_table>
    80205204:	fec42783          	lw	a5,-20(s0)
    80205208:	078e                	slli	a5,a5,0x3
    8020520a:	97ba                	add	a5,a5,a4
    8020520c:	639c                	ld	a5,0(a5)
    8020520e:	0c07b023          	sd	zero,192(a5)
        proc_table[i]->parent = 0;
    80205212:	00021717          	auipc	a4,0x21
    80205216:	30670713          	addi	a4,a4,774 # 80226518 <proc_table>
    8020521a:	fec42783          	lw	a5,-20(s0)
    8020521e:	078e                	slli	a5,a5,0x3
    80205220:	97ba                	add	a5,a5,a4
    80205222:	639c                	ld	a5,0(a5)
    80205224:	0807bc23          	sd	zero,152(a5)
        proc_table[i]->chan = 0;
    80205228:	00021717          	auipc	a4,0x21
    8020522c:	2f070713          	addi	a4,a4,752 # 80226518 <proc_table>
    80205230:	fec42783          	lw	a5,-20(s0)
    80205234:	078e                	slli	a5,a5,0x3
    80205236:	97ba                	add	a5,a5,a4
    80205238:	639c                	ld	a5,0(a5)
    8020523a:	0a07b023          	sd	zero,160(a5)
        proc_table[i]->exit_status = 0;
    8020523e:	00021717          	auipc	a4,0x21
    80205242:	2da70713          	addi	a4,a4,730 # 80226518 <proc_table>
    80205246:	fec42783          	lw	a5,-20(s0)
    8020524a:	078e                	slli	a5,a5,0x3
    8020524c:	97ba                	add	a5,a5,a4
    8020524e:	639c                	ld	a5,0(a5)
    80205250:	0807a223          	sw	zero,132(a5)
        memset(&proc_table[i]->context, 0, sizeof(struct context));
    80205254:	00021717          	auipc	a4,0x21
    80205258:	2c470713          	addi	a4,a4,708 # 80226518 <proc_table>
    8020525c:	fec42783          	lw	a5,-20(s0)
    80205260:	078e                	slli	a5,a5,0x3
    80205262:	97ba                	add	a5,a5,a4
    80205264:	639c                	ld	a5,0(a5)
    80205266:	07c1                	addi	a5,a5,16
    80205268:	07000613          	li	a2,112
    8020526c:	4581                	li	a1,0
    8020526e:	853e                	mv	a0,a5
    80205270:	ffffd097          	auipc	ra,0xffffd
    80205274:	bf0080e7          	jalr	-1040(ra) # 80201e60 <memset>
    for (int i = 0; i < PROC; i++) {
    80205278:	fec42783          	lw	a5,-20(s0)
    8020527c:	2785                	addiw	a5,a5,1
    8020527e:	fef42623          	sw	a5,-20(s0)
    80205282:	fec42783          	lw	a5,-20(s0)
    80205286:	0007871b          	sext.w	a4,a5
    8020528a:	47fd                	li	a5,31
    8020528c:	eae7d4e3          	bge	a5,a4,80205134 <init_proc+0xe>
    proc_table_pages = PROC; // 每个进程一页
    80205290:	00021797          	auipc	a5,0x21
    80205294:	38878793          	addi	a5,a5,904 # 80226618 <proc_table_pages>
    80205298:	02000713          	li	a4,32
    8020529c:	c398                	sw	a4,0(a5)
}
    8020529e:	0001                	nop
    802052a0:	60e2                	ld	ra,24(sp)
    802052a2:	6442                	ld	s0,16(sp)
    802052a4:	6105                	addi	sp,sp,32
    802052a6:	8082                	ret

00000000802052a8 <free_proc_table>:
void free_proc_table(void) {
    802052a8:	1101                	addi	sp,sp,-32
    802052aa:	ec06                	sd	ra,24(sp)
    802052ac:	e822                	sd	s0,16(sp)
    802052ae:	1000                	addi	s0,sp,32
    for (int i = 0; i < proc_table_pages; i++) {
    802052b0:	fe042623          	sw	zero,-20(s0)
    802052b4:	a025                	j	802052dc <free_proc_table+0x34>
        free_page(proc_table_mem[i]);
    802052b6:	00021717          	auipc	a4,0x21
    802052ba:	36a70713          	addi	a4,a4,874 # 80226620 <proc_table_mem>
    802052be:	fec42783          	lw	a5,-20(s0)
    802052c2:	078e                	slli	a5,a5,0x3
    802052c4:	97ba                	add	a5,a5,a4
    802052c6:	639c                	ld	a5,0(a5)
    802052c8:	853e                	mv	a0,a5
    802052ca:	ffffe097          	auipc	ra,0xffffe
    802052ce:	00a080e7          	jalr	10(ra) # 802032d4 <free_page>
    for (int i = 0; i < proc_table_pages; i++) {
    802052d2:	fec42783          	lw	a5,-20(s0)
    802052d6:	2785                	addiw	a5,a5,1
    802052d8:	fef42623          	sw	a5,-20(s0)
    802052dc:	00021797          	auipc	a5,0x21
    802052e0:	33c78793          	addi	a5,a5,828 # 80226618 <proc_table_pages>
    802052e4:	4398                	lw	a4,0(a5)
    802052e6:	fec42783          	lw	a5,-20(s0)
    802052ea:	2781                	sext.w	a5,a5
    802052ec:	fce7c5e3          	blt	a5,a4,802052b6 <free_proc_table+0xe>
}
    802052f0:	0001                	nop
    802052f2:	0001                	nop
    802052f4:	60e2                	ld	ra,24(sp)
    802052f6:	6442                	ld	s0,16(sp)
    802052f8:	6105                	addi	sp,sp,32
    802052fa:	8082                	ret

00000000802052fc <alloc_proc>:
struct proc* alloc_proc(int is_user) {
    802052fc:	7139                	addi	sp,sp,-64
    802052fe:	fc06                	sd	ra,56(sp)
    80205300:	f822                	sd	s0,48(sp)
    80205302:	0080                	addi	s0,sp,64
    80205304:	87aa                	mv	a5,a0
    80205306:	fcf42623          	sw	a5,-52(s0)
    for(int i = 0;i<PROC;i++) {
    8020530a:	fe042623          	sw	zero,-20(s0)
    8020530e:	aaa5                	j	80205486 <alloc_proc+0x18a>
		struct proc *p = proc_table[i];
    80205310:	00021717          	auipc	a4,0x21
    80205314:	20870713          	addi	a4,a4,520 # 80226518 <proc_table>
    80205318:	fec42783          	lw	a5,-20(s0)
    8020531c:	078e                	slli	a5,a5,0x3
    8020531e:	97ba                	add	a5,a5,a4
    80205320:	639c                	ld	a5,0(a5)
    80205322:	fef43023          	sd	a5,-32(s0)
        if(p->state == UNUSED) {
    80205326:	fe043783          	ld	a5,-32(s0)
    8020532a:	439c                	lw	a5,0(a5)
    8020532c:	14079863          	bnez	a5,8020547c <alloc_proc+0x180>
            p->pid = i;
    80205330:	fe043783          	ld	a5,-32(s0)
    80205334:	fec42703          	lw	a4,-20(s0)
    80205338:	c3d8                	sw	a4,4(a5)
            p->state = USED;
    8020533a:	fe043783          	ld	a5,-32(s0)
    8020533e:	4705                	li	a4,1
    80205340:	c398                	sw	a4,0(a5)
			p->is_user = is_user;
    80205342:	fe043783          	ld	a5,-32(s0)
    80205346:	fcc42703          	lw	a4,-52(s0)
    8020534a:	0ae7a423          	sw	a4,168(a5)
            p->trapframe = (struct trapframe*)alloc_page();
    8020534e:	ffffe097          	auipc	ra,0xffffe
    80205352:	f1a080e7          	jalr	-230(ra) # 80203268 <alloc_page>
    80205356:	872a                	mv	a4,a0
    80205358:	fe043783          	ld	a5,-32(s0)
    8020535c:	e3f8                	sd	a4,192(a5)
            if(p->trapframe == 0){
    8020535e:	fe043783          	ld	a5,-32(s0)
    80205362:	63fc                	ld	a5,192(a5)
    80205364:	eb99                	bnez	a5,8020537a <alloc_proc+0x7e>
                p->state = UNUSED;
    80205366:	fe043783          	ld	a5,-32(s0)
    8020536a:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    8020536e:	fe043783          	ld	a5,-32(s0)
    80205372:	0007a223          	sw	zero,4(a5)
                return 0;
    80205376:	4781                	li	a5,0
    80205378:	aa39                	j	80205496 <alloc_proc+0x19a>
			if(p->is_user){
    8020537a:	fe043783          	ld	a5,-32(s0)
    8020537e:	0a87a783          	lw	a5,168(a5)
    80205382:	c3b9                	beqz	a5,802053c8 <alloc_proc+0xcc>
				p->pagetable = create_pagetable();
    80205384:	ffffd097          	auipc	ra,0xffffd
    80205388:	d38080e7          	jalr	-712(ra) # 802020bc <create_pagetable>
    8020538c:	872a                	mv	a4,a0
    8020538e:	fe043783          	ld	a5,-32(s0)
    80205392:	ffd8                	sd	a4,184(a5)
				if(p->pagetable == 0){
    80205394:	fe043783          	ld	a5,-32(s0)
    80205398:	7fdc                	ld	a5,184(a5)
    8020539a:	ef9d                	bnez	a5,802053d8 <alloc_proc+0xdc>
					free_page(p->trapframe);
    8020539c:	fe043783          	ld	a5,-32(s0)
    802053a0:	63fc                	ld	a5,192(a5)
    802053a2:	853e                	mv	a0,a5
    802053a4:	ffffe097          	auipc	ra,0xffffe
    802053a8:	f30080e7          	jalr	-208(ra) # 802032d4 <free_page>
					p->trapframe = 0;
    802053ac:	fe043783          	ld	a5,-32(s0)
    802053b0:	0c07b023          	sd	zero,192(a5)
					p->state = UNUSED;
    802053b4:	fe043783          	ld	a5,-32(s0)
    802053b8:	0007a023          	sw	zero,0(a5)
					p->pid = 0;
    802053bc:	fe043783          	ld	a5,-32(s0)
    802053c0:	0007a223          	sw	zero,4(a5)
					return 0;
    802053c4:	4781                	li	a5,0
    802053c6:	a8c1                	j	80205496 <alloc_proc+0x19a>
				p->pagetable = kernel_pagetable;
    802053c8:	00021797          	auipc	a5,0x21
    802053cc:	d7878793          	addi	a5,a5,-648 # 80226140 <kernel_pagetable>
    802053d0:	6398                	ld	a4,0(a5)
    802053d2:	fe043783          	ld	a5,-32(s0)
    802053d6:	ffd8                	sd	a4,184(a5)
            void *kstack_mem = alloc_page();
    802053d8:	ffffe097          	auipc	ra,0xffffe
    802053dc:	e90080e7          	jalr	-368(ra) # 80203268 <alloc_page>
    802053e0:	fca43c23          	sd	a0,-40(s0)
            if(kstack_mem == 0) {
    802053e4:	fd843783          	ld	a5,-40(s0)
    802053e8:	e3b9                	bnez	a5,8020542e <alloc_proc+0x132>
                free_page(p->trapframe);
    802053ea:	fe043783          	ld	a5,-32(s0)
    802053ee:	63fc                	ld	a5,192(a5)
    802053f0:	853e                	mv	a0,a5
    802053f2:	ffffe097          	auipc	ra,0xffffe
    802053f6:	ee2080e7          	jalr	-286(ra) # 802032d4 <free_page>
                free_pagetable(p->pagetable);
    802053fa:	fe043783          	ld	a5,-32(s0)
    802053fe:	7fdc                	ld	a5,184(a5)
    80205400:	853e                	mv	a0,a5
    80205402:	ffffd097          	auipc	ra,0xffffd
    80205406:	09e080e7          	jalr	158(ra) # 802024a0 <free_pagetable>
                p->trapframe = 0;
    8020540a:	fe043783          	ld	a5,-32(s0)
    8020540e:	0c07b023          	sd	zero,192(a5)
                p->pagetable = 0;
    80205412:	fe043783          	ld	a5,-32(s0)
    80205416:	0a07bc23          	sd	zero,184(a5)
                p->state = UNUSED;
    8020541a:	fe043783          	ld	a5,-32(s0)
    8020541e:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    80205422:	fe043783          	ld	a5,-32(s0)
    80205426:	0007a223          	sw	zero,4(a5)
                return 0;
    8020542a:	4781                	li	a5,0
    8020542c:	a0ad                	j	80205496 <alloc_proc+0x19a>
            p->kstack = (uint64)kstack_mem;
    8020542e:	fd843703          	ld	a4,-40(s0)
    80205432:	fe043783          	ld	a5,-32(s0)
    80205436:	e798                	sd	a4,8(a5)
            memset(&p->context, 0, sizeof(p->context));
    80205438:	fe043783          	ld	a5,-32(s0)
    8020543c:	07c1                	addi	a5,a5,16
    8020543e:	07000613          	li	a2,112
    80205442:	4581                	li	a1,0
    80205444:	853e                	mv	a0,a5
    80205446:	ffffd097          	auipc	ra,0xffffd
    8020544a:	a1a080e7          	jalr	-1510(ra) # 80201e60 <memset>
            p->context.ra = (uint64)forkret;
    8020544e:	00000717          	auipc	a4,0x0
    80205452:	c3270713          	addi	a4,a4,-974 # 80205080 <forkret>
    80205456:	fe043783          	ld	a5,-32(s0)
    8020545a:	eb98                	sd	a4,16(a5)
            p->context.sp = p->kstack + PGSIZE - 16;  // 16字节对齐
    8020545c:	fe043783          	ld	a5,-32(s0)
    80205460:	6798                	ld	a4,8(a5)
    80205462:	6785                	lui	a5,0x1
    80205464:	17c1                	addi	a5,a5,-16 # ff0 <_entry-0x801ff010>
    80205466:	973e                	add	a4,a4,a5
    80205468:	fe043783          	ld	a5,-32(s0)
    8020546c:	ef98                	sd	a4,24(a5)
			p->killed = 0; //重置死亡状态
    8020546e:	fe043783          	ld	a5,-32(s0)
    80205472:	0807a023          	sw	zero,128(a5)
            return p;
    80205476:	fe043783          	ld	a5,-32(s0)
    8020547a:	a831                	j	80205496 <alloc_proc+0x19a>
    for(int i = 0;i<PROC;i++) {
    8020547c:	fec42783          	lw	a5,-20(s0)
    80205480:	2785                	addiw	a5,a5,1
    80205482:	fef42623          	sw	a5,-20(s0)
    80205486:	fec42783          	lw	a5,-20(s0)
    8020548a:	0007871b          	sext.w	a4,a5
    8020548e:	47fd                	li	a5,31
    80205490:	e8e7d0e3          	bge	a5,a4,80205310 <alloc_proc+0x14>
    return 0;
    80205494:	4781                	li	a5,0
}
    80205496:	853e                	mv	a0,a5
    80205498:	70e2                	ld	ra,56(sp)
    8020549a:	7442                	ld	s0,48(sp)
    8020549c:	6121                	addi	sp,sp,64
    8020549e:	8082                	ret

00000000802054a0 <free_proc>:
void free_proc(struct proc *p){
    802054a0:	1101                	addi	sp,sp,-32
    802054a2:	ec06                	sd	ra,24(sp)
    802054a4:	e822                	sd	s0,16(sp)
    802054a6:	1000                	addi	s0,sp,32
    802054a8:	fea43423          	sd	a0,-24(s0)
    if(p->trapframe)
    802054ac:	fe843783          	ld	a5,-24(s0)
    802054b0:	63fc                	ld	a5,192(a5)
    802054b2:	cb89                	beqz	a5,802054c4 <free_proc+0x24>
        free_page(p->trapframe);
    802054b4:	fe843783          	ld	a5,-24(s0)
    802054b8:	63fc                	ld	a5,192(a5)
    802054ba:	853e                	mv	a0,a5
    802054bc:	ffffe097          	auipc	ra,0xffffe
    802054c0:	e18080e7          	jalr	-488(ra) # 802032d4 <free_page>
    p->trapframe = 0;
    802054c4:	fe843783          	ld	a5,-24(s0)
    802054c8:	0c07b023          	sd	zero,192(a5)
    if(p->pagetable && p->pagetable != kernel_pagetable)
    802054cc:	fe843783          	ld	a5,-24(s0)
    802054d0:	7fdc                	ld	a5,184(a5)
    802054d2:	c39d                	beqz	a5,802054f8 <free_proc+0x58>
    802054d4:	fe843783          	ld	a5,-24(s0)
    802054d8:	7fd8                	ld	a4,184(a5)
    802054da:	00021797          	auipc	a5,0x21
    802054de:	c6678793          	addi	a5,a5,-922 # 80226140 <kernel_pagetable>
    802054e2:	639c                	ld	a5,0(a5)
    802054e4:	00f70a63          	beq	a4,a5,802054f8 <free_proc+0x58>
        free_pagetable(p->pagetable);
    802054e8:	fe843783          	ld	a5,-24(s0)
    802054ec:	7fdc                	ld	a5,184(a5)
    802054ee:	853e                	mv	a0,a5
    802054f0:	ffffd097          	auipc	ra,0xffffd
    802054f4:	fb0080e7          	jalr	-80(ra) # 802024a0 <free_pagetable>
    p->pagetable = 0;
    802054f8:	fe843783          	ld	a5,-24(s0)
    802054fc:	0a07bc23          	sd	zero,184(a5)
    if(p->kstack)
    80205500:	fe843783          	ld	a5,-24(s0)
    80205504:	679c                	ld	a5,8(a5)
    80205506:	cb89                	beqz	a5,80205518 <free_proc+0x78>
        free_page((void*)p->kstack);
    80205508:	fe843783          	ld	a5,-24(s0)
    8020550c:	679c                	ld	a5,8(a5)
    8020550e:	853e                	mv	a0,a5
    80205510:	ffffe097          	auipc	ra,0xffffe
    80205514:	dc4080e7          	jalr	-572(ra) # 802032d4 <free_page>
    p->kstack = 0;
    80205518:	fe843783          	ld	a5,-24(s0)
    8020551c:	0007b423          	sd	zero,8(a5)
    p->pid = 0;
    80205520:	fe843783          	ld	a5,-24(s0)
    80205524:	0007a223          	sw	zero,4(a5)
    p->state = UNUSED;
    80205528:	fe843783          	ld	a5,-24(s0)
    8020552c:	0007a023          	sw	zero,0(a5)
    p->parent = 0;
    80205530:	fe843783          	ld	a5,-24(s0)
    80205534:	0807bc23          	sd	zero,152(a5)
    p->chan = 0;
    80205538:	fe843783          	ld	a5,-24(s0)
    8020553c:	0a07b023          	sd	zero,160(a5)
    memset(&p->context, 0, sizeof(p->context));
    80205540:	fe843783          	ld	a5,-24(s0)
    80205544:	07c1                	addi	a5,a5,16
    80205546:	07000613          	li	a2,112
    8020554a:	4581                	li	a1,0
    8020554c:	853e                	mv	a0,a5
    8020554e:	ffffd097          	auipc	ra,0xffffd
    80205552:	912080e7          	jalr	-1774(ra) # 80201e60 <memset>
}
    80205556:	0001                	nop
    80205558:	60e2                	ld	ra,24(sp)
    8020555a:	6442                	ld	s0,16(sp)
    8020555c:	6105                	addi	sp,sp,32
    8020555e:	8082                	ret

0000000080205560 <create_kernel_proc>:
int create_kernel_proc(void (*entry)(void)) {
    80205560:	7179                	addi	sp,sp,-48
    80205562:	f406                	sd	ra,40(sp)
    80205564:	f022                	sd	s0,32(sp)
    80205566:	1800                	addi	s0,sp,48
    80205568:	fca43c23          	sd	a0,-40(s0)
    struct proc *p = alloc_proc(0);
    8020556c:	4501                	li	a0,0
    8020556e:	00000097          	auipc	ra,0x0
    80205572:	d8e080e7          	jalr	-626(ra) # 802052fc <alloc_proc>
    80205576:	fea43423          	sd	a0,-24(s0)
    if (!p) return -1;
    8020557a:	fe843783          	ld	a5,-24(s0)
    8020557e:	e399                	bnez	a5,80205584 <create_kernel_proc+0x24>
    80205580:	57fd                	li	a5,-1
    80205582:	a089                	j	802055c4 <create_kernel_proc+0x64>
    p->trapframe->epc = (uint64)entry;
    80205584:	fe843783          	ld	a5,-24(s0)
    80205588:	63fc                	ld	a5,192(a5)
    8020558a:	fd843703          	ld	a4,-40(s0)
    8020558e:	f398                	sd	a4,32(a5)
    p->state = RUNNABLE;
    80205590:	fe843783          	ld	a5,-24(s0)
    80205594:	470d                	li	a4,3
    80205596:	c398                	sw	a4,0(a5)
    struct proc *parent = myproc();
    80205598:	00000097          	auipc	ra,0x0
    8020559c:	988080e7          	jalr	-1656(ra) # 80204f20 <myproc>
    802055a0:	fea43023          	sd	a0,-32(s0)
    if (parent != 0) {
    802055a4:	fe043783          	ld	a5,-32(s0)
    802055a8:	c799                	beqz	a5,802055b6 <create_kernel_proc+0x56>
        p->parent = parent;
    802055aa:	fe843783          	ld	a5,-24(s0)
    802055ae:	fe043703          	ld	a4,-32(s0)
    802055b2:	efd8                	sd	a4,152(a5)
    802055b4:	a029                	j	802055be <create_kernel_proc+0x5e>
        p->parent = NULL;
    802055b6:	fe843783          	ld	a5,-24(s0)
    802055ba:	0807bc23          	sd	zero,152(a5)
    return p->pid;
    802055be:	fe843783          	ld	a5,-24(s0)
    802055c2:	43dc                	lw	a5,4(a5)
}
    802055c4:	853e                	mv	a0,a5
    802055c6:	70a2                	ld	ra,40(sp)
    802055c8:	7402                	ld	s0,32(sp)
    802055ca:	6145                	addi	sp,sp,48
    802055cc:	8082                	ret

00000000802055ce <create_kernel_proc1>:
int create_kernel_proc1(void (*entry)(uint64),uint64 arg){
    802055ce:	7179                	addi	sp,sp,-48
    802055d0:	f406                	sd	ra,40(sp)
    802055d2:	f022                	sd	s0,32(sp)
    802055d4:	1800                	addi	s0,sp,48
    802055d6:	fca43c23          	sd	a0,-40(s0)
    802055da:	fcb43823          	sd	a1,-48(s0)
	struct proc *p = alloc_proc(0);
    802055de:	4501                	li	a0,0
    802055e0:	00000097          	auipc	ra,0x0
    802055e4:	d1c080e7          	jalr	-740(ra) # 802052fc <alloc_proc>
    802055e8:	fea43423          	sd	a0,-24(s0)
    if (!p) return -1;
    802055ec:	fe843783          	ld	a5,-24(s0)
    802055f0:	e399                	bnez	a5,802055f6 <create_kernel_proc1+0x28>
    802055f2:	57fd                	li	a5,-1
    802055f4:	a0b9                	j	80205642 <create_kernel_proc1+0x74>
    p->trapframe->epc = (uint64)entry;
    802055f6:	fe843783          	ld	a5,-24(s0)
    802055fa:	63fc                	ld	a5,192(a5)
    802055fc:	fd843703          	ld	a4,-40(s0)
    80205600:	f398                	sd	a4,32(a5)
	p->trapframe->a0 = (uint64)arg;
    80205602:	fe843783          	ld	a5,-24(s0)
    80205606:	63fc                	ld	a5,192(a5)
    80205608:	fd043703          	ld	a4,-48(s0)
    8020560c:	ffb8                	sd	a4,120(a5)
    p->state = RUNNABLE;
    8020560e:	fe843783          	ld	a5,-24(s0)
    80205612:	470d                	li	a4,3
    80205614:	c398                	sw	a4,0(a5)
    struct proc *parent = myproc();
    80205616:	00000097          	auipc	ra,0x0
    8020561a:	90a080e7          	jalr	-1782(ra) # 80204f20 <myproc>
    8020561e:	fea43023          	sd	a0,-32(s0)
    if (parent != 0) {
    80205622:	fe043783          	ld	a5,-32(s0)
    80205626:	c799                	beqz	a5,80205634 <create_kernel_proc1+0x66>
        p->parent = parent;
    80205628:	fe843783          	ld	a5,-24(s0)
    8020562c:	fe043703          	ld	a4,-32(s0)
    80205630:	efd8                	sd	a4,152(a5)
    80205632:	a029                	j	8020563c <create_kernel_proc1+0x6e>
        p->parent = NULL;
    80205634:	fe843783          	ld	a5,-24(s0)
    80205638:	0807bc23          	sd	zero,152(a5)
    return p->pid;
    8020563c:	fe843783          	ld	a5,-24(s0)
    80205640:	43dc                	lw	a5,4(a5)
}
    80205642:	853e                	mv	a0,a5
    80205644:	70a2                	ld	ra,40(sp)
    80205646:	7402                	ld	s0,32(sp)
    80205648:	6145                	addi	sp,sp,48
    8020564a:	8082                	ret

000000008020564c <create_user_proc>:
int create_user_proc(const void *user_bin, int bin_size) {
    8020564c:	715d                	addi	sp,sp,-80
    8020564e:	e486                	sd	ra,72(sp)
    80205650:	e0a2                	sd	s0,64(sp)
    80205652:	0880                	addi	s0,sp,80
    80205654:	faa43c23          	sd	a0,-72(s0)
    80205658:	87ae                	mv	a5,a1
    8020565a:	faf42a23          	sw	a5,-76(s0)
    struct proc *p = alloc_proc(1); // 1 表示用户进程
    8020565e:	4505                	li	a0,1
    80205660:	00000097          	auipc	ra,0x0
    80205664:	c9c080e7          	jalr	-868(ra) # 802052fc <alloc_proc>
    80205668:	fea43423          	sd	a0,-24(s0)
    if (!p) return -1;
    8020566c:	fe843783          	ld	a5,-24(s0)
    80205670:	e399                	bnez	a5,80205676 <create_user_proc+0x2a>
    80205672:	57fd                	li	a5,-1
    80205674:	a2d1                	j	80205838 <create_user_proc+0x1ec>
    uint64 user_entry = 0x10000;
    80205676:	67c1                	lui	a5,0x10
    80205678:	fef43023          	sd	a5,-32(s0)
    uint64 user_stack = 0x20000;
    8020567c:	000207b7          	lui	a5,0x20
    80205680:	fcf43c23          	sd	a5,-40(s0)
    void *page = alloc_page();
    80205684:	ffffe097          	auipc	ra,0xffffe
    80205688:	be4080e7          	jalr	-1052(ra) # 80203268 <alloc_page>
    8020568c:	fca43823          	sd	a0,-48(s0)
    if (!page) { free_proc(p); return -1; }
    80205690:	fd043783          	ld	a5,-48(s0)
    80205694:	eb89                	bnez	a5,802056a6 <create_user_proc+0x5a>
    80205696:	fe843503          	ld	a0,-24(s0)
    8020569a:	00000097          	auipc	ra,0x0
    8020569e:	e06080e7          	jalr	-506(ra) # 802054a0 <free_proc>
    802056a2:	57fd                	li	a5,-1
    802056a4:	aa51                	j	80205838 <create_user_proc+0x1ec>
    map_page(p->pagetable, user_entry, (uint64)page, PTE_R | PTE_W | PTE_X | PTE_U);
    802056a6:	fe843783          	ld	a5,-24(s0)
    802056aa:	7fdc                	ld	a5,184(a5)
    802056ac:	fd043703          	ld	a4,-48(s0)
    802056b0:	46f9                	li	a3,30
    802056b2:	863a                	mv	a2,a4
    802056b4:	fe043583          	ld	a1,-32(s0)
    802056b8:	853e                	mv	a0,a5
    802056ba:	ffffd097          	auipc	ra,0xffffd
    802056be:	c72080e7          	jalr	-910(ra) # 8020232c <map_page>
    memcpy((void*)page, user_bin, bin_size);
    802056c2:	fb442783          	lw	a5,-76(s0)
    802056c6:	863e                	mv	a2,a5
    802056c8:	fb843583          	ld	a1,-72(s0)
    802056cc:	fd043503          	ld	a0,-48(s0)
    802056d0:	ffffd097          	auipc	ra,0xffffd
    802056d4:	89c080e7          	jalr	-1892(ra) # 80201f6c <memcpy>
    void *stack_page = alloc_page();
    802056d8:	ffffe097          	auipc	ra,0xffffe
    802056dc:	b90080e7          	jalr	-1136(ra) # 80203268 <alloc_page>
    802056e0:	fca43423          	sd	a0,-56(s0)
    if (!stack_page) { free_proc(p); return -1; }
    802056e4:	fc843783          	ld	a5,-56(s0)
    802056e8:	eb89                	bnez	a5,802056fa <create_user_proc+0xae>
    802056ea:	fe843503          	ld	a0,-24(s0)
    802056ee:	00000097          	auipc	ra,0x0
    802056f2:	db2080e7          	jalr	-590(ra) # 802054a0 <free_proc>
    802056f6:	57fd                	li	a5,-1
    802056f8:	a281                	j	80205838 <create_user_proc+0x1ec>
    map_page(p->pagetable, user_stack - PGSIZE, (uint64)stack_page, PTE_R | PTE_W | PTE_U);
    802056fa:	fe843783          	ld	a5,-24(s0)
    802056fe:	7fc8                	ld	a0,184(a5)
    80205700:	fd843703          	ld	a4,-40(s0)
    80205704:	77fd                	lui	a5,0xfffff
    80205706:	97ba                	add	a5,a5,a4
    80205708:	fc843703          	ld	a4,-56(s0)
    8020570c:	46d9                	li	a3,22
    8020570e:	863a                	mv	a2,a4
    80205710:	85be                	mv	a1,a5
    80205712:	ffffd097          	auipc	ra,0xffffd
    80205716:	c1a080e7          	jalr	-998(ra) # 8020232c <map_page>
	p->sz = user_stack; // 用户空间从 0x10000 到 0x20000
    8020571a:	fe843783          	ld	a5,-24(s0)
    8020571e:	fd843703          	ld	a4,-40(s0)
    80205722:	fbd8                	sd	a4,176(a5)
    if (map_page(p->pagetable, TRAPFRAME, (uint64)p->trapframe, PTE_R | PTE_W) != 0) {
    80205724:	fe843783          	ld	a5,-24(s0)
    80205728:	7fd8                	ld	a4,184(a5)
    8020572a:	fe843783          	ld	a5,-24(s0)
    8020572e:	63fc                	ld	a5,192(a5)
    80205730:	4699                	li	a3,6
    80205732:	863e                	mv	a2,a5
    80205734:	75f9                	lui	a1,0xffffe
    80205736:	853a                	mv	a0,a4
    80205738:	ffffd097          	auipc	ra,0xffffd
    8020573c:	bf4080e7          	jalr	-1036(ra) # 8020232c <map_page>
    80205740:	87aa                	mv	a5,a0
    80205742:	cb89                	beqz	a5,80205754 <create_user_proc+0x108>
        free_proc(p);
    80205744:	fe843503          	ld	a0,-24(s0)
    80205748:	00000097          	auipc	ra,0x0
    8020574c:	d58080e7          	jalr	-680(ra) # 802054a0 <free_proc>
        return -1;
    80205750:	57fd                	li	a5,-1
    80205752:	a0dd                	j	80205838 <create_user_proc+0x1ec>
	memset(p->trapframe, 0, sizeof(*p->trapframe));
    80205754:	fe843783          	ld	a5,-24(s0)
    80205758:	63fc                	ld	a5,192(a5)
    8020575a:	11800613          	li	a2,280
    8020575e:	4581                	li	a1,0
    80205760:	853e                	mv	a0,a5
    80205762:	ffffc097          	auipc	ra,0xffffc
    80205766:	6fe080e7          	jalr	1790(ra) # 80201e60 <memset>
	p->trapframe->epc = user_entry; // 应为 0x10000
    8020576a:	fe843783          	ld	a5,-24(s0)
    8020576e:	63fc                	ld	a5,192(a5)
    80205770:	fe043703          	ld	a4,-32(s0)
    80205774:	f398                	sd	a4,32(a5)
	p->trapframe->sp = user_stack;  // 应为 0x20000
    80205776:	fe843783          	ld	a5,-24(s0)
    8020577a:	63fc                	ld	a5,192(a5)
    8020577c:	fd843703          	ld	a4,-40(s0)
    80205780:	ff98                	sd	a4,56(a5)
	p->trapframe->sstatus = (1UL << 5); // 0x20
    80205782:	fe843783          	ld	a5,-24(s0)
    80205786:	63fc                	ld	a5,192(a5)
    80205788:	02000713          	li	a4,32
    8020578c:	ef98                	sd	a4,24(a5)
	p->trapframe->kernel_satp = MAKE_SATP(kernel_pagetable);
    8020578e:	00021797          	auipc	a5,0x21
    80205792:	9b278793          	addi	a5,a5,-1614 # 80226140 <kernel_pagetable>
    80205796:	639c                	ld	a5,0(a5)
    80205798:	00c7d693          	srli	a3,a5,0xc
    8020579c:	fe843783          	ld	a5,-24(s0)
    802057a0:	63fc                	ld	a5,192(a5)
    802057a2:	577d                	li	a4,-1
    802057a4:	177e                	slli	a4,a4,0x3f
    802057a6:	8f55                	or	a4,a4,a3
    802057a8:	e398                	sd	a4,0(a5)
	p->trapframe->kernel_sp = p->kstack + PGSIZE;   // 内核栈顶
    802057aa:	fe843783          	ld	a5,-24(s0)
    802057ae:	6794                	ld	a3,8(a5)
    802057b0:	fe843783          	ld	a5,-24(s0)
    802057b4:	63fc                	ld	a5,192(a5)
    802057b6:	6705                	lui	a4,0x1
    802057b8:	9736                	add	a4,a4,a3
    802057ba:	e798                	sd	a4,8(a5)
	p->trapframe->usertrap  = (uint64)usertrap;     // C 层 trap 处理函数
    802057bc:	fe843783          	ld	a5,-24(s0)
    802057c0:	63fc                	ld	a5,192(a5)
    802057c2:	fffff717          	auipc	a4,0xfffff
    802057c6:	01070713          	addi	a4,a4,16 # 802047d2 <usertrap>
    802057ca:	10e7b423          	sd	a4,264(a5)
	p->trapframe->kernel_vec = (uint64)kernelvec;
    802057ce:	fe843783          	ld	a5,-24(s0)
    802057d2:	63fc                	ld	a5,192(a5)
    802057d4:	fffff717          	auipc	a4,0xfffff
    802057d8:	41c70713          	addi	a4,a4,1052 # 80204bf0 <kernelvec>
    802057dc:	10e7b823          	sd	a4,272(a5)
    p->state = RUNNABLE;
    802057e0:	fe843783          	ld	a5,-24(s0)
    802057e4:	470d                	li	a4,3
    802057e6:	c398                	sw	a4,0(a5)
	if (map_page(p->pagetable, TRAMPOLINE, trampoline_phys_addr, PTE_X | PTE_R) != 0) {
    802057e8:	fe843783          	ld	a5,-24(s0)
    802057ec:	7fd8                	ld	a4,184(a5)
    802057ee:	00021797          	auipc	a5,0x21
    802057f2:	95a78793          	addi	a5,a5,-1702 # 80226148 <trampoline_phys_addr>
    802057f6:	639c                	ld	a5,0(a5)
    802057f8:	46a9                	li	a3,10
    802057fa:	863e                	mv	a2,a5
    802057fc:	75fd                	lui	a1,0xfffff
    802057fe:	853a                	mv	a0,a4
    80205800:	ffffd097          	auipc	ra,0xffffd
    80205804:	b2c080e7          	jalr	-1236(ra) # 8020232c <map_page>
    80205808:	87aa                	mv	a5,a0
    8020580a:	cb89                	beqz	a5,8020581c <create_user_proc+0x1d0>
		free_proc(p);
    8020580c:	fe843503          	ld	a0,-24(s0)
    80205810:	00000097          	auipc	ra,0x0
    80205814:	c90080e7          	jalr	-880(ra) # 802054a0 <free_proc>
		return -1;
    80205818:	57fd                	li	a5,-1
    8020581a:	a839                	j	80205838 <create_user_proc+0x1ec>
    struct proc *parent = myproc();
    8020581c:	fffff097          	auipc	ra,0xfffff
    80205820:	704080e7          	jalr	1796(ra) # 80204f20 <myproc>
    80205824:	fca43023          	sd	a0,-64(s0)
    p->parent = parent ? parent : NULL;
    80205828:	fe843783          	ld	a5,-24(s0)
    8020582c:	fc043703          	ld	a4,-64(s0)
    80205830:	efd8                	sd	a4,152(a5)
    return p->pid;
    80205832:	fe843783          	ld	a5,-24(s0)
    80205836:	43dc                	lw	a5,4(a5)
}
    80205838:	853e                	mv	a0,a5
    8020583a:	60a6                	ld	ra,72(sp)
    8020583c:	6406                	ld	s0,64(sp)
    8020583e:	6161                	addi	sp,sp,80
    80205840:	8082                	ret

0000000080205842 <fork_proc>:
int fork_proc(void) {
    80205842:	7179                	addi	sp,sp,-48
    80205844:	f406                	sd	ra,40(sp)
    80205846:	f022                	sd	s0,32(sp)
    80205848:	1800                	addi	s0,sp,48
    struct proc *parent = myproc();
    8020584a:	fffff097          	auipc	ra,0xfffff
    8020584e:	6d6080e7          	jalr	1750(ra) # 80204f20 <myproc>
    80205852:	fea43423          	sd	a0,-24(s0)
    struct proc *child = alloc_proc(parent->is_user);
    80205856:	fe843783          	ld	a5,-24(s0)
    8020585a:	0a87a783          	lw	a5,168(a5)
    8020585e:	853e                	mv	a0,a5
    80205860:	00000097          	auipc	ra,0x0
    80205864:	a9c080e7          	jalr	-1380(ra) # 802052fc <alloc_proc>
    80205868:	fea43023          	sd	a0,-32(s0)
    if (!child) return -1;
    8020586c:	fe043783          	ld	a5,-32(s0)
    80205870:	e399                	bnez	a5,80205876 <fork_proc+0x34>
    80205872:	57fd                	li	a5,-1
    80205874:	a279                	j	80205a02 <fork_proc+0x1c0>
    if (uvmcopy(parent->pagetable, child->pagetable, parent->sz) < 0) {
    80205876:	fe843783          	ld	a5,-24(s0)
    8020587a:	7fd8                	ld	a4,184(a5)
    8020587c:	fe043783          	ld	a5,-32(s0)
    80205880:	7fd4                	ld	a3,184(a5)
    80205882:	fe843783          	ld	a5,-24(s0)
    80205886:	7bdc                	ld	a5,176(a5)
    80205888:	863e                	mv	a2,a5
    8020588a:	85b6                	mv	a1,a3
    8020588c:	853a                	mv	a0,a4
    8020588e:	ffffe097          	auipc	ra,0xffffe
    80205892:	80a080e7          	jalr	-2038(ra) # 80203098 <uvmcopy>
    80205896:	87aa                	mv	a5,a0
    80205898:	0007da63          	bgez	a5,802058ac <fork_proc+0x6a>
        free_proc(child);
    8020589c:	fe043503          	ld	a0,-32(s0)
    802058a0:	00000097          	auipc	ra,0x0
    802058a4:	c00080e7          	jalr	-1024(ra) # 802054a0 <free_proc>
        return -1;
    802058a8:	57fd                	li	a5,-1
    802058aa:	aaa1                	j	80205a02 <fork_proc+0x1c0>
    child->sz = parent->sz;
    802058ac:	fe843783          	ld	a5,-24(s0)
    802058b0:	7bd8                	ld	a4,176(a5)
    802058b2:	fe043783          	ld	a5,-32(s0)
    802058b6:	fbd8                	sd	a4,176(a5)
    uint64 tf_pa = (uint64)child->trapframe;
    802058b8:	fe043783          	ld	a5,-32(s0)
    802058bc:	63fc                	ld	a5,192(a5)
    802058be:	fcf43c23          	sd	a5,-40(s0)
    if ((tf_pa & (PGSIZE - 1)) != 0) {
    802058c2:	fd843703          	ld	a4,-40(s0)
    802058c6:	6785                	lui	a5,0x1
    802058c8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    802058ca:	8ff9                	and	a5,a5,a4
    802058cc:	c39d                	beqz	a5,802058f2 <fork_proc+0xb0>
        printf("[fork] trapframe not aligned: 0x%lx\n", tf_pa);
    802058ce:	fd843583          	ld	a1,-40(s0)
    802058d2:	00019517          	auipc	a0,0x19
    802058d6:	0ae50513          	addi	a0,a0,174 # 8021e980 <syscall_performance_bin+0x800>
    802058da:	ffffb097          	auipc	ra,0xffffb
    802058de:	3fc080e7          	jalr	1020(ra) # 80200cd6 <printf>
        free_proc(child);
    802058e2:	fe043503          	ld	a0,-32(s0)
    802058e6:	00000097          	auipc	ra,0x0
    802058ea:	bba080e7          	jalr	-1094(ra) # 802054a0 <free_proc>
        return -1;
    802058ee:	57fd                	li	a5,-1
    802058f0:	aa09                	j	80205a02 <fork_proc+0x1c0>
    if (map_page(child->pagetable, TRAPFRAME, tf_pa, PTE_R | PTE_W) != 0) {
    802058f2:	fe043783          	ld	a5,-32(s0)
    802058f6:	7fdc                	ld	a5,184(a5)
    802058f8:	4699                	li	a3,6
    802058fa:	fd843603          	ld	a2,-40(s0)
    802058fe:	75f9                	lui	a1,0xffffe
    80205900:	853e                	mv	a0,a5
    80205902:	ffffd097          	auipc	ra,0xffffd
    80205906:	a2a080e7          	jalr	-1494(ra) # 8020232c <map_page>
    8020590a:	87aa                	mv	a5,a0
    8020590c:	c38d                	beqz	a5,8020592e <fork_proc+0xec>
        printf("[fork] map TRAPFRAME failed\n");
    8020590e:	00019517          	auipc	a0,0x19
    80205912:	09a50513          	addi	a0,a0,154 # 8021e9a8 <syscall_performance_bin+0x828>
    80205916:	ffffb097          	auipc	ra,0xffffb
    8020591a:	3c0080e7          	jalr	960(ra) # 80200cd6 <printf>
        free_proc(child);
    8020591e:	fe043503          	ld	a0,-32(s0)
    80205922:	00000097          	auipc	ra,0x0
    80205926:	b7e080e7          	jalr	-1154(ra) # 802054a0 <free_proc>
        return -1;
    8020592a:	57fd                	li	a5,-1
    8020592c:	a8d9                	j	80205a02 <fork_proc+0x1c0>
    if (map_page(child->pagetable, TRAMPOLINE, trampoline_phys_addr, PTE_R | PTE_X) != 0) {
    8020592e:	fe043783          	ld	a5,-32(s0)
    80205932:	7fd8                	ld	a4,184(a5)
    80205934:	00021797          	auipc	a5,0x21
    80205938:	81478793          	addi	a5,a5,-2028 # 80226148 <trampoline_phys_addr>
    8020593c:	639c                	ld	a5,0(a5)
    8020593e:	46a9                	li	a3,10
    80205940:	863e                	mv	a2,a5
    80205942:	75fd                	lui	a1,0xfffff
    80205944:	853a                	mv	a0,a4
    80205946:	ffffd097          	auipc	ra,0xffffd
    8020594a:	9e6080e7          	jalr	-1562(ra) # 8020232c <map_page>
    8020594e:	87aa                	mv	a5,a0
    80205950:	c38d                	beqz	a5,80205972 <fork_proc+0x130>
        printf("[fork] map TRAMPOLINE failed\n");
    80205952:	00019517          	auipc	a0,0x19
    80205956:	07650513          	addi	a0,a0,118 # 8021e9c8 <syscall_performance_bin+0x848>
    8020595a:	ffffb097          	auipc	ra,0xffffb
    8020595e:	37c080e7          	jalr	892(ra) # 80200cd6 <printf>
        free_proc(child);
    80205962:	fe043503          	ld	a0,-32(s0)
    80205966:	00000097          	auipc	ra,0x0
    8020596a:	b3a080e7          	jalr	-1222(ra) # 802054a0 <free_proc>
        return -1;
    8020596e:	57fd                	li	a5,-1
    80205970:	a849                	j	80205a02 <fork_proc+0x1c0>
    *(child->trapframe) = *(parent->trapframe);
    80205972:	fe843783          	ld	a5,-24(s0)
    80205976:	63f8                	ld	a4,192(a5)
    80205978:	fe043783          	ld	a5,-32(s0)
    8020597c:	63fc                	ld	a5,192(a5)
    8020597e:	86be                	mv	a3,a5
    80205980:	11800793          	li	a5,280
    80205984:	863e                	mv	a2,a5
    80205986:	85ba                	mv	a1,a4
    80205988:	8536                	mv	a0,a3
    8020598a:	ffffc097          	auipc	ra,0xffffc
    8020598e:	5e2080e7          	jalr	1506(ra) # 80201f6c <memcpy>
	child->trapframe->kernel_sp = child->kstack + PGSIZE;
    80205992:	fe043783          	ld	a5,-32(s0)
    80205996:	6794                	ld	a3,8(a5)
    80205998:	fe043783          	ld	a5,-32(s0)
    8020599c:	63fc                	ld	a5,192(a5)
    8020599e:	6705                	lui	a4,0x1
    802059a0:	9736                	add	a4,a4,a3
    802059a2:	e798                	sd	a4,8(a5)
	assert(child->trapframe->kernel_satp = MAKE_SATP(kernel_pagetable));
    802059a4:	00020797          	auipc	a5,0x20
    802059a8:	79c78793          	addi	a5,a5,1948 # 80226140 <kernel_pagetable>
    802059ac:	639c                	ld	a5,0(a5)
    802059ae:	00c7d693          	srli	a3,a5,0xc
    802059b2:	fe043783          	ld	a5,-32(s0)
    802059b6:	63fc                	ld	a5,192(a5)
    802059b8:	577d                	li	a4,-1
    802059ba:	177e                	slli	a4,a4,0x3f
    802059bc:	8f55                	or	a4,a4,a3
    802059be:	e398                	sd	a4,0(a5)
    802059c0:	639c                	ld	a5,0(a5)
    802059c2:	2781                	sext.w	a5,a5
    802059c4:	853e                	mv	a0,a5
    802059c6:	fffff097          	auipc	ra,0xfffff
    802059ca:	4e4080e7          	jalr	1252(ra) # 80204eaa <assert>
    child->trapframe->epc += 4;  // 跳过 ecall 指令
    802059ce:	fe043783          	ld	a5,-32(s0)
    802059d2:	63fc                	ld	a5,192(a5)
    802059d4:	7398                	ld	a4,32(a5)
    802059d6:	fe043783          	ld	a5,-32(s0)
    802059da:	63fc                	ld	a5,192(a5)
    802059dc:	0711                	addi	a4,a4,4 # 1004 <_entry-0x801feffc>
    802059de:	f398                	sd	a4,32(a5)
    child->trapframe->a0 = 0;    // 子进程fork返回0
    802059e0:	fe043783          	ld	a5,-32(s0)
    802059e4:	63fc                	ld	a5,192(a5)
    802059e6:	0607bc23          	sd	zero,120(a5)
    child->state = RUNNABLE;
    802059ea:	fe043783          	ld	a5,-32(s0)
    802059ee:	470d                	li	a4,3
    802059f0:	c398                	sw	a4,0(a5)
    child->parent = parent;
    802059f2:	fe043783          	ld	a5,-32(s0)
    802059f6:	fe843703          	ld	a4,-24(s0)
    802059fa:	efd8                	sd	a4,152(a5)
    return child->pid;
    802059fc:	fe043783          	ld	a5,-32(s0)
    80205a00:	43dc                	lw	a5,4(a5)
}
    80205a02:	853e                	mv	a0,a5
    80205a04:	70a2                	ld	ra,40(sp)
    80205a06:	7402                	ld	s0,32(sp)
    80205a08:	6145                	addi	sp,sp,48
    80205a0a:	8082                	ret

0000000080205a0c <schedule>:
void schedule(void) {
    80205a0c:	7179                	addi	sp,sp,-48
    80205a0e:	f406                	sd	ra,40(sp)
    80205a10:	f022                	sd	s0,32(sp)
    80205a12:	1800                	addi	s0,sp,48
  struct cpu *c = mycpu();
    80205a14:	fffff097          	auipc	ra,0xfffff
    80205a18:	524080e7          	jalr	1316(ra) # 80204f38 <mycpu>
    80205a1c:	fea43023          	sd	a0,-32(s0)
    intr_on();
    80205a20:	fffff097          	auipc	ra,0xfffff
    80205a24:	41e080e7          	jalr	1054(ra) # 80204e3e <intr_on>
    for(int i = 0; i < PROC; i++) {
    80205a28:	fe042623          	sw	zero,-20(s0)
    80205a2c:	a8bd                	j	80205aaa <schedule+0x9e>
        struct proc *p = proc_table[i];
    80205a2e:	00021717          	auipc	a4,0x21
    80205a32:	aea70713          	addi	a4,a4,-1302 # 80226518 <proc_table>
    80205a36:	fec42783          	lw	a5,-20(s0)
    80205a3a:	078e                	slli	a5,a5,0x3
    80205a3c:	97ba                	add	a5,a5,a4
    80205a3e:	639c                	ld	a5,0(a5)
    80205a40:	fcf43c23          	sd	a5,-40(s0)
      	if(p->state == RUNNABLE) {
    80205a44:	fd843783          	ld	a5,-40(s0)
    80205a48:	439c                	lw	a5,0(a5)
    80205a4a:	873e                	mv	a4,a5
    80205a4c:	478d                	li	a5,3
    80205a4e:	04f71963          	bne	a4,a5,80205aa0 <schedule+0x94>
			p->state = RUNNING;
    80205a52:	fd843783          	ld	a5,-40(s0)
    80205a56:	4711                	li	a4,4
    80205a58:	c398                	sw	a4,0(a5)
			c->proc = p;
    80205a5a:	fe043783          	ld	a5,-32(s0)
    80205a5e:	fd843703          	ld	a4,-40(s0)
    80205a62:	e398                	sd	a4,0(a5)
			current_proc = p;
    80205a64:	00020797          	auipc	a5,0x20
    80205a68:	6f478793          	addi	a5,a5,1780 # 80226158 <current_proc>
    80205a6c:	fd843703          	ld	a4,-40(s0)
    80205a70:	e398                	sd	a4,0(a5)
			swtch(&c->context, &p->context);
    80205a72:	fe043783          	ld	a5,-32(s0)
    80205a76:	00878713          	addi	a4,a5,8
    80205a7a:	fd843783          	ld	a5,-40(s0)
    80205a7e:	07c1                	addi	a5,a5,16
    80205a80:	85be                	mv	a1,a5
    80205a82:	853a                	mv	a0,a4
    80205a84:	fffff097          	auipc	ra,0xfffff
    80205a88:	31c080e7          	jalr	796(ra) # 80204da0 <swtch>
			c->proc = 0;
    80205a8c:	fe043783          	ld	a5,-32(s0)
    80205a90:	0007b023          	sd	zero,0(a5)
			current_proc = 0;
    80205a94:	00020797          	auipc	a5,0x20
    80205a98:	6c478793          	addi	a5,a5,1732 # 80226158 <current_proc>
    80205a9c:	0007b023          	sd	zero,0(a5)
    for(int i = 0; i < PROC; i++) {
    80205aa0:	fec42783          	lw	a5,-20(s0)
    80205aa4:	2785                	addiw	a5,a5,1
    80205aa6:	fef42623          	sw	a5,-20(s0)
    80205aaa:	fec42783          	lw	a5,-20(s0)
    80205aae:	0007871b          	sext.w	a4,a5
    80205ab2:	47fd                	li	a5,31
    80205ab4:	f6e7dde3          	bge	a5,a4,80205a2e <schedule+0x22>
    intr_on();
    80205ab8:	b7a5                	j	80205a20 <schedule+0x14>

0000000080205aba <yield>:
void yield(void) {
    80205aba:	1101                	addi	sp,sp,-32
    80205abc:	ec06                	sd	ra,24(sp)
    80205abe:	e822                	sd	s0,16(sp)
    80205ac0:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80205ac2:	fffff097          	auipc	ra,0xfffff
    80205ac6:	45e080e7          	jalr	1118(ra) # 80204f20 <myproc>
    80205aca:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    80205ace:	fe843783          	ld	a5,-24(s0)
    80205ad2:	c3d1                	beqz	a5,80205b56 <yield+0x9c>
    intr_off();
    80205ad4:	fffff097          	auipc	ra,0xfffff
    80205ad8:	394080e7          	jalr	916(ra) # 80204e68 <intr_off>
    struct cpu *c = mycpu();
    80205adc:	fffff097          	auipc	ra,0xfffff
    80205ae0:	45c080e7          	jalr	1116(ra) # 80204f38 <mycpu>
    80205ae4:	fea43023          	sd	a0,-32(s0)
    p->state = RUNNABLE;
    80205ae8:	fe843783          	ld	a5,-24(s0)
    80205aec:	470d                	li	a4,3
    80205aee:	c398                	sw	a4,0(a5)
    current_proc = 0;
    80205af0:	00020797          	auipc	a5,0x20
    80205af4:	66878793          	addi	a5,a5,1640 # 80226158 <current_proc>
    80205af8:	0007b023          	sd	zero,0(a5)
    c->proc = 0;
    80205afc:	fe043783          	ld	a5,-32(s0)
    80205b00:	0007b023          	sd	zero,0(a5)
    swtch(&p->context, &c->context);
    80205b04:	fe843783          	ld	a5,-24(s0)
    80205b08:	01078713          	addi	a4,a5,16
    80205b0c:	fe043783          	ld	a5,-32(s0)
    80205b10:	07a1                	addi	a5,a5,8
    80205b12:	85be                	mv	a1,a5
    80205b14:	853a                	mv	a0,a4
    80205b16:	fffff097          	auipc	ra,0xfffff
    80205b1a:	28a080e7          	jalr	650(ra) # 80204da0 <swtch>
    intr_on();
    80205b1e:	fffff097          	auipc	ra,0xfffff
    80205b22:	320080e7          	jalr	800(ra) # 80204e3e <intr_on>
	if (p->killed) {
    80205b26:	fe843783          	ld	a5,-24(s0)
    80205b2a:	0807a783          	lw	a5,128(a5)
    80205b2e:	c78d                	beqz	a5,80205b58 <yield+0x9e>
        printf("[yield] Process PID %d killed during yield\n", p->pid);
    80205b30:	fe843783          	ld	a5,-24(s0)
    80205b34:	43dc                	lw	a5,4(a5)
    80205b36:	85be                	mv	a1,a5
    80205b38:	00019517          	auipc	a0,0x19
    80205b3c:	eb050513          	addi	a0,a0,-336 # 8021e9e8 <syscall_performance_bin+0x868>
    80205b40:	ffffb097          	auipc	ra,0xffffb
    80205b44:	196080e7          	jalr	406(ra) # 80200cd6 <printf>
        exit_proc(SYS_kill);
    80205b48:	08100513          	li	a0,129
    80205b4c:	00000097          	auipc	ra,0x0
    80205b50:	17c080e7          	jalr	380(ra) # 80205cc8 <exit_proc>
        return;
    80205b54:	a011                	j	80205b58 <yield+0x9e>
        return;
    80205b56:	0001                	nop
}
    80205b58:	60e2                	ld	ra,24(sp)
    80205b5a:	6442                	ld	s0,16(sp)
    80205b5c:	6105                	addi	sp,sp,32
    80205b5e:	8082                	ret

0000000080205b60 <sleep>:
void sleep(void *chan){
    80205b60:	7179                	addi	sp,sp,-48
    80205b62:	f406                	sd	ra,40(sp)
    80205b64:	f022                	sd	s0,32(sp)
    80205b66:	1800                	addi	s0,sp,48
    80205b68:	fca43c23          	sd	a0,-40(s0)
    struct proc *p = myproc();
    80205b6c:	fffff097          	auipc	ra,0xfffff
    80205b70:	3b4080e7          	jalr	948(ra) # 80204f20 <myproc>
    80205b74:	fea43423          	sd	a0,-24(s0)
    struct cpu *c = mycpu();
    80205b78:	fffff097          	auipc	ra,0xfffff
    80205b7c:	3c0080e7          	jalr	960(ra) # 80204f38 <mycpu>
    80205b80:	fea43023          	sd	a0,-32(s0)
    p->context.ra = ra;
    80205b84:	8706                	mv	a4,ra
    80205b86:	fe843783          	ld	a5,-24(s0)
    80205b8a:	eb98                	sd	a4,16(a5)
    p->chan = chan;
    80205b8c:	fe843783          	ld	a5,-24(s0)
    80205b90:	fd843703          	ld	a4,-40(s0)
    80205b94:	f3d8                	sd	a4,160(a5)
    p->state = SLEEPING;
    80205b96:	fe843783          	ld	a5,-24(s0)
    80205b9a:	4709                	li	a4,2
    80205b9c:	c398                	sw	a4,0(a5)
    swtch(&p->context, &c->context);
    80205b9e:	fe843783          	ld	a5,-24(s0)
    80205ba2:	01078713          	addi	a4,a5,16
    80205ba6:	fe043783          	ld	a5,-32(s0)
    80205baa:	07a1                	addi	a5,a5,8
    80205bac:	85be                	mv	a1,a5
    80205bae:	853a                	mv	a0,a4
    80205bb0:	fffff097          	auipc	ra,0xfffff
    80205bb4:	1f0080e7          	jalr	496(ra) # 80204da0 <swtch>
    p->chan = 0;
    80205bb8:	fe843783          	ld	a5,-24(s0)
    80205bbc:	0a07b023          	sd	zero,160(a5)
	if(p->killed){
    80205bc0:	fe843783          	ld	a5,-24(s0)
    80205bc4:	0807a783          	lw	a5,128(a5)
    80205bc8:	c39d                	beqz	a5,80205bee <sleep+0x8e>
		printf("[sleep] Process PID %d killed when wakeup\n", p->pid);
    80205bca:	fe843783          	ld	a5,-24(s0)
    80205bce:	43dc                	lw	a5,4(a5)
    80205bd0:	85be                	mv	a1,a5
    80205bd2:	00019517          	auipc	a0,0x19
    80205bd6:	e4650513          	addi	a0,a0,-442 # 8021ea18 <syscall_performance_bin+0x898>
    80205bda:	ffffb097          	auipc	ra,0xffffb
    80205bde:	0fc080e7          	jalr	252(ra) # 80200cd6 <printf>
		exit_proc(SYS_kill);
    80205be2:	08100513          	li	a0,129
    80205be6:	00000097          	auipc	ra,0x0
    80205bea:	0e2080e7          	jalr	226(ra) # 80205cc8 <exit_proc>
}
    80205bee:	0001                	nop
    80205bf0:	70a2                	ld	ra,40(sp)
    80205bf2:	7402                	ld	s0,32(sp)
    80205bf4:	6145                	addi	sp,sp,48
    80205bf6:	8082                	ret

0000000080205bf8 <wakeup>:
void wakeup(void *chan) {
    80205bf8:	7179                	addi	sp,sp,-48
    80205bfa:	f422                	sd	s0,40(sp)
    80205bfc:	1800                	addi	s0,sp,48
    80205bfe:	fca43c23          	sd	a0,-40(s0)
    for(int i = 0; i < PROC; i++) {
    80205c02:	fe042623          	sw	zero,-20(s0)
    80205c06:	a099                	j	80205c4c <wakeup+0x54>
        struct proc *p = proc_table[i];
    80205c08:	00021717          	auipc	a4,0x21
    80205c0c:	91070713          	addi	a4,a4,-1776 # 80226518 <proc_table>
    80205c10:	fec42783          	lw	a5,-20(s0)
    80205c14:	078e                	slli	a5,a5,0x3
    80205c16:	97ba                	add	a5,a5,a4
    80205c18:	639c                	ld	a5,0(a5)
    80205c1a:	fef43023          	sd	a5,-32(s0)
        if(p->state == SLEEPING && p->chan == chan) {
    80205c1e:	fe043783          	ld	a5,-32(s0)
    80205c22:	439c                	lw	a5,0(a5)
    80205c24:	873e                	mv	a4,a5
    80205c26:	4789                	li	a5,2
    80205c28:	00f71d63          	bne	a4,a5,80205c42 <wakeup+0x4a>
    80205c2c:	fe043783          	ld	a5,-32(s0)
    80205c30:	73dc                	ld	a5,160(a5)
    80205c32:	fd843703          	ld	a4,-40(s0)
    80205c36:	00f71663          	bne	a4,a5,80205c42 <wakeup+0x4a>
            p->state = RUNNABLE;
    80205c3a:	fe043783          	ld	a5,-32(s0)
    80205c3e:	470d                	li	a4,3
    80205c40:	c398                	sw	a4,0(a5)
    for(int i = 0; i < PROC; i++) {
    80205c42:	fec42783          	lw	a5,-20(s0)
    80205c46:	2785                	addiw	a5,a5,1
    80205c48:	fef42623          	sw	a5,-20(s0)
    80205c4c:	fec42783          	lw	a5,-20(s0)
    80205c50:	0007871b          	sext.w	a4,a5
    80205c54:	47fd                	li	a5,31
    80205c56:	fae7d9e3          	bge	a5,a4,80205c08 <wakeup+0x10>
}
    80205c5a:	0001                	nop
    80205c5c:	0001                	nop
    80205c5e:	7422                	ld	s0,40(sp)
    80205c60:	6145                	addi	sp,sp,48
    80205c62:	8082                	ret

0000000080205c64 <kill_proc>:
void kill_proc(int pid){
    80205c64:	7179                	addi	sp,sp,-48
    80205c66:	f422                	sd	s0,40(sp)
    80205c68:	1800                	addi	s0,sp,48
    80205c6a:	87aa                	mv	a5,a0
    80205c6c:	fcf42e23          	sw	a5,-36(s0)
	for(int i=0;i<PROC;i++){
    80205c70:	fe042623          	sw	zero,-20(s0)
    80205c74:	a83d                	j	80205cb2 <kill_proc+0x4e>
		struct proc *p = proc_table[i];
    80205c76:	00021717          	auipc	a4,0x21
    80205c7a:	8a270713          	addi	a4,a4,-1886 # 80226518 <proc_table>
    80205c7e:	fec42783          	lw	a5,-20(s0)
    80205c82:	078e                	slli	a5,a5,0x3
    80205c84:	97ba                	add	a5,a5,a4
    80205c86:	639c                	ld	a5,0(a5)
    80205c88:	fef43023          	sd	a5,-32(s0)
		if(pid == p->pid){
    80205c8c:	fe043783          	ld	a5,-32(s0)
    80205c90:	43d8                	lw	a4,4(a5)
    80205c92:	fdc42783          	lw	a5,-36(s0)
    80205c96:	2781                	sext.w	a5,a5
    80205c98:	00e79863          	bne	a5,a4,80205ca8 <kill_proc+0x44>
			p->killed = 1;
    80205c9c:	fe043783          	ld	a5,-32(s0)
    80205ca0:	4705                	li	a4,1
    80205ca2:	08e7a023          	sw	a4,128(a5)
			break;
    80205ca6:	a829                	j	80205cc0 <kill_proc+0x5c>
	for(int i=0;i<PROC;i++){
    80205ca8:	fec42783          	lw	a5,-20(s0)
    80205cac:	2785                	addiw	a5,a5,1
    80205cae:	fef42623          	sw	a5,-20(s0)
    80205cb2:	fec42783          	lw	a5,-20(s0)
    80205cb6:	0007871b          	sext.w	a4,a5
    80205cba:	47fd                	li	a5,31
    80205cbc:	fae7dde3          	bge	a5,a4,80205c76 <kill_proc+0x12>
	return;
    80205cc0:	0001                	nop
}
    80205cc2:	7422                	ld	s0,40(sp)
    80205cc4:	6145                	addi	sp,sp,48
    80205cc6:	8082                	ret

0000000080205cc8 <exit_proc>:
void exit_proc(int status) {
    80205cc8:	7179                	addi	sp,sp,-48
    80205cca:	f406                	sd	ra,40(sp)
    80205ccc:	f022                	sd	s0,32(sp)
    80205cce:	1800                	addi	s0,sp,48
    80205cd0:	87aa                	mv	a5,a0
    80205cd2:	fcf42e23          	sw	a5,-36(s0)
    struct proc *p = myproc();
    80205cd6:	fffff097          	auipc	ra,0xfffff
    80205cda:	24a080e7          	jalr	586(ra) # 80204f20 <myproc>
    80205cde:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    80205ce2:	fe843783          	ld	a5,-24(s0)
    80205ce6:	eb89                	bnez	a5,80205cf8 <exit_proc+0x30>
        panic("exit_proc: no current process");
    80205ce8:	00019517          	auipc	a0,0x19
    80205cec:	d6050513          	addi	a0,a0,-672 # 8021ea48 <syscall_performance_bin+0x8c8>
    80205cf0:	ffffc097          	auipc	ra,0xffffc
    80205cf4:	a32080e7          	jalr	-1486(ra) # 80201722 <panic>
    p->exit_status = status;
    80205cf8:	fe843783          	ld	a5,-24(s0)
    80205cfc:	fdc42703          	lw	a4,-36(s0)
    80205d00:	08e7a223          	sw	a4,132(a5)
    if (!p->parent) {
    80205d04:	fe843783          	ld	a5,-24(s0)
    80205d08:	6fdc                	ld	a5,152(a5)
    80205d0a:	e789                	bnez	a5,80205d14 <exit_proc+0x4c>
        shutdown();
    80205d0c:	fffff097          	auipc	ra,0xfffff
    80205d10:	1ea080e7          	jalr	490(ra) # 80204ef6 <shutdown>
    p->state = ZOMBIE;
    80205d14:	fe843783          	ld	a5,-24(s0)
    80205d18:	4715                	li	a4,5
    80205d1a:	c398                	sw	a4,0(a5)
    wakeup((void*)p->parent);
    80205d1c:	fe843783          	ld	a5,-24(s0)
    80205d20:	6fdc                	ld	a5,152(a5)
    80205d22:	853e                	mv	a0,a5
    80205d24:	00000097          	auipc	ra,0x0
    80205d28:	ed4080e7          	jalr	-300(ra) # 80205bf8 <wakeup>
    current_proc = 0;
    80205d2c:	00020797          	auipc	a5,0x20
    80205d30:	42c78793          	addi	a5,a5,1068 # 80226158 <current_proc>
    80205d34:	0007b023          	sd	zero,0(a5)
    if (mycpu())
    80205d38:	fffff097          	auipc	ra,0xfffff
    80205d3c:	200080e7          	jalr	512(ra) # 80204f38 <mycpu>
    80205d40:	87aa                	mv	a5,a0
    80205d42:	cb81                	beqz	a5,80205d52 <exit_proc+0x8a>
        mycpu()->proc = 0;
    80205d44:	fffff097          	auipc	ra,0xfffff
    80205d48:	1f4080e7          	jalr	500(ra) # 80204f38 <mycpu>
    80205d4c:	87aa                	mv	a5,a0
    80205d4e:	0007b023          	sd	zero,0(a5)
    struct cpu *c = mycpu();
    80205d52:	fffff097          	auipc	ra,0xfffff
    80205d56:	1e6080e7          	jalr	486(ra) # 80204f38 <mycpu>
    80205d5a:	fea43023          	sd	a0,-32(s0)
    swtch(&p->context, &c->context);
    80205d5e:	fe843783          	ld	a5,-24(s0)
    80205d62:	01078713          	addi	a4,a5,16
    80205d66:	fe043783          	ld	a5,-32(s0)
    80205d6a:	07a1                	addi	a5,a5,8
    80205d6c:	85be                	mv	a1,a5
    80205d6e:	853a                	mv	a0,a4
    80205d70:	fffff097          	auipc	ra,0xfffff
    80205d74:	030080e7          	jalr	48(ra) # 80204da0 <swtch>
    panic("exit_proc should not return after schedule");
    80205d78:	00019517          	auipc	a0,0x19
    80205d7c:	cf050513          	addi	a0,a0,-784 # 8021ea68 <syscall_performance_bin+0x8e8>
    80205d80:	ffffc097          	auipc	ra,0xffffc
    80205d84:	9a2080e7          	jalr	-1630(ra) # 80201722 <panic>
}
    80205d88:	0001                	nop
    80205d8a:	70a2                	ld	ra,40(sp)
    80205d8c:	7402                	ld	s0,32(sp)
    80205d8e:	6145                	addi	sp,sp,48
    80205d90:	8082                	ret

0000000080205d92 <wait_proc>:
int wait_proc(int *status) {
    80205d92:	711d                	addi	sp,sp,-96
    80205d94:	ec86                	sd	ra,88(sp)
    80205d96:	e8a2                	sd	s0,80(sp)
    80205d98:	1080                	addi	s0,sp,96
    80205d9a:	faa43423          	sd	a0,-88(s0)
    struct proc *p = myproc();
    80205d9e:	fffff097          	auipc	ra,0xfffff
    80205da2:	182080e7          	jalr	386(ra) # 80204f20 <myproc>
    80205da6:	fca43023          	sd	a0,-64(s0)
    if (p == 0) {
    80205daa:	fc043783          	ld	a5,-64(s0)
    80205dae:	eb99                	bnez	a5,80205dc4 <wait_proc+0x32>
        printf("Warning: wait_proc called with no current process\n");
    80205db0:	00019517          	auipc	a0,0x19
    80205db4:	ce850513          	addi	a0,a0,-792 # 8021ea98 <syscall_performance_bin+0x918>
    80205db8:	ffffb097          	auipc	ra,0xffffb
    80205dbc:	f1e080e7          	jalr	-226(ra) # 80200cd6 <printf>
        return -1;
    80205dc0:	57fd                	li	a5,-1
    80205dc2:	aa91                	j	80205f16 <wait_proc+0x184>
        intr_off();
    80205dc4:	fffff097          	auipc	ra,0xfffff
    80205dc8:	0a4080e7          	jalr	164(ra) # 80204e68 <intr_off>
        int found_zombie = 0;
    80205dcc:	fe042623          	sw	zero,-20(s0)
        int zombie_pid = 0;
    80205dd0:	fe042423          	sw	zero,-24(s0)
        int zombie_status = 0;
    80205dd4:	fe042223          	sw	zero,-28(s0)
        struct proc *zombie_child = 0;
    80205dd8:	fc043c23          	sd	zero,-40(s0)
        for (int i = 0; i < PROC; i++) {
    80205ddc:	fc042a23          	sw	zero,-44(s0)
    80205de0:	a095                	j	80205e44 <wait_proc+0xb2>
            struct proc *child = proc_table[i];
    80205de2:	00020717          	auipc	a4,0x20
    80205de6:	73670713          	addi	a4,a4,1846 # 80226518 <proc_table>
    80205dea:	fd442783          	lw	a5,-44(s0)
    80205dee:	078e                	slli	a5,a5,0x3
    80205df0:	97ba                	add	a5,a5,a4
    80205df2:	639c                	ld	a5,0(a5)
    80205df4:	faf43c23          	sd	a5,-72(s0)
            if (child->state == ZOMBIE && child->parent == p) {
    80205df8:	fb843783          	ld	a5,-72(s0)
    80205dfc:	439c                	lw	a5,0(a5)
    80205dfe:	873e                	mv	a4,a5
    80205e00:	4795                	li	a5,5
    80205e02:	02f71c63          	bne	a4,a5,80205e3a <wait_proc+0xa8>
    80205e06:	fb843783          	ld	a5,-72(s0)
    80205e0a:	6fdc                	ld	a5,152(a5)
    80205e0c:	fc043703          	ld	a4,-64(s0)
    80205e10:	02f71563          	bne	a4,a5,80205e3a <wait_proc+0xa8>
                found_zombie = 1;
    80205e14:	4785                	li	a5,1
    80205e16:	fef42623          	sw	a5,-20(s0)
                zombie_pid = child->pid;
    80205e1a:	fb843783          	ld	a5,-72(s0)
    80205e1e:	43dc                	lw	a5,4(a5)
    80205e20:	fef42423          	sw	a5,-24(s0)
                zombie_status = child->exit_status;
    80205e24:	fb843783          	ld	a5,-72(s0)
    80205e28:	0847a783          	lw	a5,132(a5)
    80205e2c:	fef42223          	sw	a5,-28(s0)
                zombie_child = child;
    80205e30:	fb843783          	ld	a5,-72(s0)
    80205e34:	fcf43c23          	sd	a5,-40(s0)
                break;
    80205e38:	a829                	j	80205e52 <wait_proc+0xc0>
        for (int i = 0; i < PROC; i++) {
    80205e3a:	fd442783          	lw	a5,-44(s0)
    80205e3e:	2785                	addiw	a5,a5,1
    80205e40:	fcf42a23          	sw	a5,-44(s0)
    80205e44:	fd442783          	lw	a5,-44(s0)
    80205e48:	0007871b          	sext.w	a4,a5
    80205e4c:	47fd                	li	a5,31
    80205e4e:	f8e7dae3          	bge	a5,a4,80205de2 <wait_proc+0x50>
        if (found_zombie) {
    80205e52:	fec42783          	lw	a5,-20(s0)
    80205e56:	2781                	sext.w	a5,a5
    80205e58:	cb85                	beqz	a5,80205e88 <wait_proc+0xf6>
            if (status)
    80205e5a:	fa843783          	ld	a5,-88(s0)
    80205e5e:	c791                	beqz	a5,80205e6a <wait_proc+0xd8>
                *status = zombie_status;
    80205e60:	fa843783          	ld	a5,-88(s0)
    80205e64:	fe442703          	lw	a4,-28(s0)
    80205e68:	c398                	sw	a4,0(a5)
			intr_on();
    80205e6a:	fffff097          	auipc	ra,0xfffff
    80205e6e:	fd4080e7          	jalr	-44(ra) # 80204e3e <intr_on>
            free_proc(zombie_child);
    80205e72:	fd843503          	ld	a0,-40(s0)
    80205e76:	fffff097          	auipc	ra,0xfffff
    80205e7a:	62a080e7          	jalr	1578(ra) # 802054a0 <free_proc>
            zombie_child = NULL;
    80205e7e:	fc043c23          	sd	zero,-40(s0)
            return zombie_pid;
    80205e82:	fe842783          	lw	a5,-24(s0)
    80205e86:	a841                	j	80205f16 <wait_proc+0x184>
        }
        
        // 检查是否有任何活跃的子进程（非ZOMBIE状态）
        int havekids = 0;
    80205e88:	fc042823          	sw	zero,-48(s0)
        for (int i = 0; i < PROC; i++) {
    80205e8c:	fc042623          	sw	zero,-52(s0)
    80205e90:	a0b9                	j	80205ede <wait_proc+0x14c>
            struct proc *child = proc_table[i];
    80205e92:	00020717          	auipc	a4,0x20
    80205e96:	68670713          	addi	a4,a4,1670 # 80226518 <proc_table>
    80205e9a:	fcc42783          	lw	a5,-52(s0)
    80205e9e:	078e                	slli	a5,a5,0x3
    80205ea0:	97ba                	add	a5,a5,a4
    80205ea2:	639c                	ld	a5,0(a5)
    80205ea4:	faf43823          	sd	a5,-80(s0)
            if (child->state != UNUSED && child->state != ZOMBIE && child->parent == p) {
    80205ea8:	fb043783          	ld	a5,-80(s0)
    80205eac:	439c                	lw	a5,0(a5)
    80205eae:	c39d                	beqz	a5,80205ed4 <wait_proc+0x142>
    80205eb0:	fb043783          	ld	a5,-80(s0)
    80205eb4:	439c                	lw	a5,0(a5)
    80205eb6:	873e                	mv	a4,a5
    80205eb8:	4795                	li	a5,5
    80205eba:	00f70d63          	beq	a4,a5,80205ed4 <wait_proc+0x142>
    80205ebe:	fb043783          	ld	a5,-80(s0)
    80205ec2:	6fdc                	ld	a5,152(a5)
    80205ec4:	fc043703          	ld	a4,-64(s0)
    80205ec8:	00f71663          	bne	a4,a5,80205ed4 <wait_proc+0x142>
                havekids = 1;
    80205ecc:	4785                	li	a5,1
    80205ece:	fcf42823          	sw	a5,-48(s0)
                break;
    80205ed2:	a829                	j	80205eec <wait_proc+0x15a>
        for (int i = 0; i < PROC; i++) {
    80205ed4:	fcc42783          	lw	a5,-52(s0)
    80205ed8:	2785                	addiw	a5,a5,1
    80205eda:	fcf42623          	sw	a5,-52(s0)
    80205ede:	fcc42783          	lw	a5,-52(s0)
    80205ee2:	0007871b          	sext.w	a4,a5
    80205ee6:	47fd                	li	a5,31
    80205ee8:	fae7d5e3          	bge	a5,a4,80205e92 <wait_proc+0x100>
            }
        }
        
        if (!havekids) {
    80205eec:	fd042783          	lw	a5,-48(s0)
    80205ef0:	2781                	sext.w	a5,a5
    80205ef2:	e799                	bnez	a5,80205f00 <wait_proc+0x16e>
            intr_on();
    80205ef4:	fffff097          	auipc	ra,0xfffff
    80205ef8:	f4a080e7          	jalr	-182(ra) # 80204e3e <intr_on>
            return -1;
    80205efc:	57fd                	li	a5,-1
    80205efe:	a821                	j	80205f16 <wait_proc+0x184>
        }
        
        // 有活跃子进程但没有僵尸子进程，进入睡眠等待
		intr_on();
    80205f00:	fffff097          	auipc	ra,0xfffff
    80205f04:	f3e080e7          	jalr	-194(ra) # 80204e3e <intr_on>
        sleep((void*)p);
    80205f08:	fc043503          	ld	a0,-64(s0)
    80205f0c:	00000097          	auipc	ra,0x0
    80205f10:	c54080e7          	jalr	-940(ra) # 80205b60 <sleep>
    while (1) {
    80205f14:	bd45                	j	80205dc4 <wait_proc+0x32>
    }
}
    80205f16:	853e                	mv	a0,a5
    80205f18:	60e6                	ld	ra,88(sp)
    80205f1a:	6446                	ld	s0,80(sp)
    80205f1c:	6125                	addi	sp,sp,96
    80205f1e:	8082                	ret

0000000080205f20 <print_proc_table>:

void print_proc_table(void) {
    80205f20:	715d                	addi	sp,sp,-80
    80205f22:	e486                	sd	ra,72(sp)
    80205f24:	e0a2                	sd	s0,64(sp)
    80205f26:	0880                	addi	s0,sp,80
    int count = 0;
    80205f28:	fe042623          	sw	zero,-20(s0)
    printf("PID  TYPE STATUS     PPID   FUNC_ADDR      STACK_ADDR    \n");
    80205f2c:	00019517          	auipc	a0,0x19
    80205f30:	ba450513          	addi	a0,a0,-1116 # 8021ead0 <syscall_performance_bin+0x950>
    80205f34:	ffffb097          	auipc	ra,0xffffb
    80205f38:	da2080e7          	jalr	-606(ra) # 80200cd6 <printf>
    printf("----------------------------------------------------------\n");
    80205f3c:	00019517          	auipc	a0,0x19
    80205f40:	bd450513          	addi	a0,a0,-1068 # 8021eb10 <syscall_performance_bin+0x990>
    80205f44:	ffffb097          	auipc	ra,0xffffb
    80205f48:	d92080e7          	jalr	-622(ra) # 80200cd6 <printf>
    for(int i = 0; i < PROC; i++) {
    80205f4c:	fe042423          	sw	zero,-24(s0)
    80205f50:	a2a9                	j	8020609a <print_proc_table+0x17a>
        struct proc *p = proc_table[i];
    80205f52:	00020717          	auipc	a4,0x20
    80205f56:	5c670713          	addi	a4,a4,1478 # 80226518 <proc_table>
    80205f5a:	fe842783          	lw	a5,-24(s0)
    80205f5e:	078e                	slli	a5,a5,0x3
    80205f60:	97ba                	add	a5,a5,a4
    80205f62:	639c                	ld	a5,0(a5)
    80205f64:	fcf43c23          	sd	a5,-40(s0)
        if(p->state != UNUSED) {
    80205f68:	fd843783          	ld	a5,-40(s0)
    80205f6c:	439c                	lw	a5,0(a5)
    80205f6e:	12078163          	beqz	a5,80206090 <print_proc_table+0x170>
            count++;
    80205f72:	fec42783          	lw	a5,-20(s0)
    80205f76:	2785                	addiw	a5,a5,1
    80205f78:	fef42623          	sw	a5,-20(s0)
            const char *type = (p->is_user ? "USR" : "SYS");
    80205f7c:	fd843783          	ld	a5,-40(s0)
    80205f80:	0a87a783          	lw	a5,168(a5)
    80205f84:	c791                	beqz	a5,80205f90 <print_proc_table+0x70>
    80205f86:	00019797          	auipc	a5,0x19
    80205f8a:	bca78793          	addi	a5,a5,-1078 # 8021eb50 <syscall_performance_bin+0x9d0>
    80205f8e:	a029                	j	80205f98 <print_proc_table+0x78>
    80205f90:	00019797          	auipc	a5,0x19
    80205f94:	bc878793          	addi	a5,a5,-1080 # 8021eb58 <syscall_performance_bin+0x9d8>
    80205f98:	fcf43823          	sd	a5,-48(s0)
            const char *status;
            switch(p->state) {
    80205f9c:	fd843783          	ld	a5,-40(s0)
    80205fa0:	439c                	lw	a5,0(a5)
    80205fa2:	86be                	mv	a3,a5
    80205fa4:	4715                	li	a4,5
    80205fa6:	06d76c63          	bltu	a4,a3,8020601e <print_proc_table+0xfe>
    80205faa:	00279713          	slli	a4,a5,0x2
    80205fae:	00019797          	auipc	a5,0x19
    80205fb2:	c3278793          	addi	a5,a5,-974 # 8021ebe0 <syscall_performance_bin+0xa60>
    80205fb6:	97ba                	add	a5,a5,a4
    80205fb8:	439c                	lw	a5,0(a5)
    80205fba:	0007871b          	sext.w	a4,a5
    80205fbe:	00019797          	auipc	a5,0x19
    80205fc2:	c2278793          	addi	a5,a5,-990 # 8021ebe0 <syscall_performance_bin+0xa60>
    80205fc6:	97ba                	add	a5,a5,a4
    80205fc8:	8782                	jr	a5
                case UNUSED:   status = "UNUSED"; break;
    80205fca:	00019797          	auipc	a5,0x19
    80205fce:	b9678793          	addi	a5,a5,-1130 # 8021eb60 <syscall_performance_bin+0x9e0>
    80205fd2:	fef43023          	sd	a5,-32(s0)
    80205fd6:	a899                	j	8020602c <print_proc_table+0x10c>
                case USED:     status = "USED"; break;
    80205fd8:	00019797          	auipc	a5,0x19
    80205fdc:	b9078793          	addi	a5,a5,-1136 # 8021eb68 <syscall_performance_bin+0x9e8>
    80205fe0:	fef43023          	sd	a5,-32(s0)
    80205fe4:	a0a1                	j	8020602c <print_proc_table+0x10c>
                case SLEEPING: status = "SLEEP"; break;
    80205fe6:	00019797          	auipc	a5,0x19
    80205fea:	b8a78793          	addi	a5,a5,-1142 # 8021eb70 <syscall_performance_bin+0x9f0>
    80205fee:	fef43023          	sd	a5,-32(s0)
    80205ff2:	a82d                	j	8020602c <print_proc_table+0x10c>
                case RUNNABLE: status = "RUNNABLE"; break;
    80205ff4:	00019797          	auipc	a5,0x19
    80205ff8:	b8478793          	addi	a5,a5,-1148 # 8021eb78 <syscall_performance_bin+0x9f8>
    80205ffc:	fef43023          	sd	a5,-32(s0)
    80206000:	a035                	j	8020602c <print_proc_table+0x10c>
                case RUNNING:  status = "RUNNING"; break;
    80206002:	00019797          	auipc	a5,0x19
    80206006:	b8678793          	addi	a5,a5,-1146 # 8021eb88 <syscall_performance_bin+0xa08>
    8020600a:	fef43023          	sd	a5,-32(s0)
    8020600e:	a839                	j	8020602c <print_proc_table+0x10c>
                case ZOMBIE:   status = "ZOMBIE"; break;
    80206010:	00019797          	auipc	a5,0x19
    80206014:	b8078793          	addi	a5,a5,-1152 # 8021eb90 <syscall_performance_bin+0xa10>
    80206018:	fef43023          	sd	a5,-32(s0)
    8020601c:	a801                	j	8020602c <print_proc_table+0x10c>
                default:       status = "UNKNOWN"; break;
    8020601e:	00019797          	auipc	a5,0x19
    80206022:	b7a78793          	addi	a5,a5,-1158 # 8021eb98 <syscall_performance_bin+0xa18>
    80206026:	fef43023          	sd	a5,-32(s0)
    8020602a:	0001                	nop
            }
            int ppid = p->parent ? p->parent->pid : -1;
    8020602c:	fd843783          	ld	a5,-40(s0)
    80206030:	6fdc                	ld	a5,152(a5)
    80206032:	c791                	beqz	a5,8020603e <print_proc_table+0x11e>
    80206034:	fd843783          	ld	a5,-40(s0)
    80206038:	6fdc                	ld	a5,152(a5)
    8020603a:	43dc                	lw	a5,4(a5)
    8020603c:	a011                	j	80206040 <print_proc_table+0x120>
    8020603e:	57fd                	li	a5,-1
    80206040:	fcf42623          	sw	a5,-52(s0)
            unsigned long func_addr = p->trapframe ? p->trapframe->epc : 0;
    80206044:	fd843783          	ld	a5,-40(s0)
    80206048:	63fc                	ld	a5,192(a5)
    8020604a:	c791                	beqz	a5,80206056 <print_proc_table+0x136>
    8020604c:	fd843783          	ld	a5,-40(s0)
    80206050:	63fc                	ld	a5,192(a5)
    80206052:	739c                	ld	a5,32(a5)
    80206054:	a011                	j	80206058 <print_proc_table+0x138>
    80206056:	4781                	li	a5,0
    80206058:	fcf43023          	sd	a5,-64(s0)
            unsigned long stack_addr = p->kstack;
    8020605c:	fd843783          	ld	a5,-40(s0)
    80206060:	679c                	ld	a5,8(a5)
    80206062:	faf43c23          	sd	a5,-72(s0)
            printf("%2d  %3s %8s %4d 0x%012lx 0x%012lx\n",
    80206066:	fd843783          	ld	a5,-40(s0)
    8020606a:	43cc                	lw	a1,4(a5)
    8020606c:	fcc42703          	lw	a4,-52(s0)
    80206070:	fb843803          	ld	a6,-72(s0)
    80206074:	fc043783          	ld	a5,-64(s0)
    80206078:	fe043683          	ld	a3,-32(s0)
    8020607c:	fd043603          	ld	a2,-48(s0)
    80206080:	00019517          	auipc	a0,0x19
    80206084:	b2050513          	addi	a0,a0,-1248 # 8021eba0 <syscall_performance_bin+0xa20>
    80206088:	ffffb097          	auipc	ra,0xffffb
    8020608c:	c4e080e7          	jalr	-946(ra) # 80200cd6 <printf>
    for(int i = 0; i < PROC; i++) {
    80206090:	fe842783          	lw	a5,-24(s0)
    80206094:	2785                	addiw	a5,a5,1
    80206096:	fef42423          	sw	a5,-24(s0)
    8020609a:	fe842783          	lw	a5,-24(s0)
    8020609e:	0007871b          	sext.w	a4,a5
    802060a2:	47fd                	li	a5,31
    802060a4:	eae7d7e3          	bge	a5,a4,80205f52 <print_proc_table+0x32>
                p->pid, type, status, ppid, func_addr, stack_addr);
        }
    }
    printf("----------------------------------------------------------\n");
    802060a8:	00019517          	auipc	a0,0x19
    802060ac:	a6850513          	addi	a0,a0,-1432 # 8021eb10 <syscall_performance_bin+0x990>
    802060b0:	ffffb097          	auipc	ra,0xffffb
    802060b4:	c26080e7          	jalr	-986(ra) # 80200cd6 <printf>
    printf("%d active processes\n", count);
    802060b8:	fec42783          	lw	a5,-20(s0)
    802060bc:	85be                	mv	a1,a5
    802060be:	00019517          	auipc	a0,0x19
    802060c2:	b0a50513          	addi	a0,a0,-1270 # 8021ebc8 <syscall_performance_bin+0xa48>
    802060c6:	ffffb097          	auipc	ra,0xffffb
    802060ca:	c10080e7          	jalr	-1008(ra) # 80200cd6 <printf>
}
    802060ce:	0001                	nop
    802060d0:	60a6                	ld	ra,72(sp)
    802060d2:	6406                	ld	s0,64(sp)
    802060d4:	6161                	addi	sp,sp,80
    802060d6:	8082                	ret

00000000802060d8 <get_proc>:

struct proc* get_proc(int pid){
    802060d8:	7179                	addi	sp,sp,-48
    802060da:	f422                	sd	s0,40(sp)
    802060dc:	1800                	addi	s0,sp,48
    802060de:	87aa                	mv	a5,a0
    802060e0:	fcf42e23          	sw	a5,-36(s0)
	    // 检查 PID 是否有效
    if (pid < 0 || pid >= PROC) {
    802060e4:	fdc42783          	lw	a5,-36(s0)
    802060e8:	2781                	sext.w	a5,a5
    802060ea:	0007c963          	bltz	a5,802060fc <get_proc+0x24>
    802060ee:	fdc42783          	lw	a5,-36(s0)
    802060f2:	0007871b          	sext.w	a4,a5
    802060f6:	47fd                	li	a5,31
    802060f8:	00e7d463          	bge	a5,a4,80206100 <get_proc+0x28>
        return 0;
    802060fc:	4781                	li	a5,0
    802060fe:	a899                	j	80206154 <get_proc+0x7c>
    }
    // 遍历进程表查找匹配的 PID
    for (int i = 0; i < PROC; i++) {
    80206100:	fe042623          	sw	zero,-20(s0)
    80206104:	a081                	j	80206144 <get_proc+0x6c>
        struct proc *p = proc_table[i];
    80206106:	00020717          	auipc	a4,0x20
    8020610a:	41270713          	addi	a4,a4,1042 # 80226518 <proc_table>
    8020610e:	fec42783          	lw	a5,-20(s0)
    80206112:	078e                	slli	a5,a5,0x3
    80206114:	97ba                	add	a5,a5,a4
    80206116:	639c                	ld	a5,0(a5)
    80206118:	fef43023          	sd	a5,-32(s0)
        if (p->state != UNUSED && p->pid == pid) {
    8020611c:	fe043783          	ld	a5,-32(s0)
    80206120:	439c                	lw	a5,0(a5)
    80206122:	cf81                	beqz	a5,8020613a <get_proc+0x62>
    80206124:	fe043783          	ld	a5,-32(s0)
    80206128:	43d8                	lw	a4,4(a5)
    8020612a:	fdc42783          	lw	a5,-36(s0)
    8020612e:	2781                	sext.w	a5,a5
    80206130:	00e79563          	bne	a5,a4,8020613a <get_proc+0x62>
            return p;
    80206134:	fe043783          	ld	a5,-32(s0)
    80206138:	a831                	j	80206154 <get_proc+0x7c>
    for (int i = 0; i < PROC; i++) {
    8020613a:	fec42783          	lw	a5,-20(s0)
    8020613e:	2785                	addiw	a5,a5,1
    80206140:	fef42623          	sw	a5,-20(s0)
    80206144:	fec42783          	lw	a5,-20(s0)
    80206148:	0007871b          	sext.w	a4,a5
    8020614c:	47fd                	li	a5,31
    8020614e:	fae7dce3          	bge	a5,a4,80206106 <get_proc+0x2e>
        }
    }
    return 0;
    80206152:	4781                	li	a5,0
    80206154:	853e                	mv	a0,a5
    80206156:	7422                	ld	s0,40(sp)
    80206158:	6145                	addi	sp,sp,48
    8020615a:	8082                	ret

000000008020615c <strlen>:
#include "defs.h"

// 计算字符串长度
int strlen(const char *s) {
    8020615c:	7179                	addi	sp,sp,-48
    8020615e:	f422                	sd	s0,40(sp)
    80206160:	1800                	addi	s0,sp,48
    80206162:	fca43c23          	sd	a0,-40(s0)
    int n;
    for(n = 0; s[n]; n++)
    80206166:	fe042623          	sw	zero,-20(s0)
    8020616a:	a031                	j	80206176 <strlen+0x1a>
    8020616c:	fec42783          	lw	a5,-20(s0)
    80206170:	2785                	addiw	a5,a5,1
    80206172:	fef42623          	sw	a5,-20(s0)
    80206176:	fec42783          	lw	a5,-20(s0)
    8020617a:	fd843703          	ld	a4,-40(s0)
    8020617e:	97ba                	add	a5,a5,a4
    80206180:	0007c783          	lbu	a5,0(a5)
    80206184:	f7e5                	bnez	a5,8020616c <strlen+0x10>
        ;
    return n;
    80206186:	fec42783          	lw	a5,-20(s0)
}
    8020618a:	853e                	mv	a0,a5
    8020618c:	7422                	ld	s0,40(sp)
    8020618e:	6145                	addi	sp,sp,48
    80206190:	8082                	ret

0000000080206192 <strcmp>:

// 字符串比较
int strcmp(const char *p, const char *q) {
    80206192:	1101                	addi	sp,sp,-32
    80206194:	ec22                	sd	s0,24(sp)
    80206196:	1000                	addi	s0,sp,32
    80206198:	fea43423          	sd	a0,-24(s0)
    8020619c:	feb43023          	sd	a1,-32(s0)
    while(*p && *p == *q)
    802061a0:	a819                	j	802061b6 <strcmp+0x24>
        p++, q++;
    802061a2:	fe843783          	ld	a5,-24(s0)
    802061a6:	0785                	addi	a5,a5,1
    802061a8:	fef43423          	sd	a5,-24(s0)
    802061ac:	fe043783          	ld	a5,-32(s0)
    802061b0:	0785                	addi	a5,a5,1
    802061b2:	fef43023          	sd	a5,-32(s0)
    while(*p && *p == *q)
    802061b6:	fe843783          	ld	a5,-24(s0)
    802061ba:	0007c783          	lbu	a5,0(a5)
    802061be:	cb99                	beqz	a5,802061d4 <strcmp+0x42>
    802061c0:	fe843783          	ld	a5,-24(s0)
    802061c4:	0007c703          	lbu	a4,0(a5)
    802061c8:	fe043783          	ld	a5,-32(s0)
    802061cc:	0007c783          	lbu	a5,0(a5)
    802061d0:	fcf709e3          	beq	a4,a5,802061a2 <strcmp+0x10>
    return (uchar)*p - (uchar)*q;
    802061d4:	fe843783          	ld	a5,-24(s0)
    802061d8:	0007c783          	lbu	a5,0(a5)
    802061dc:	0007871b          	sext.w	a4,a5
    802061e0:	fe043783          	ld	a5,-32(s0)
    802061e4:	0007c783          	lbu	a5,0(a5)
    802061e8:	2781                	sext.w	a5,a5
    802061ea:	40f707bb          	subw	a5,a4,a5
    802061ee:	2781                	sext.w	a5,a5
}
    802061f0:	853e                	mv	a0,a5
    802061f2:	6462                	ld	s0,24(sp)
    802061f4:	6105                	addi	sp,sp,32
    802061f6:	8082                	ret

00000000802061f8 <strcpy>:

// 字符串复制
char* strcpy(char *s, const char *t) {
    802061f8:	7179                	addi	sp,sp,-48
    802061fa:	f422                	sd	s0,40(sp)
    802061fc:	1800                	addi	s0,sp,48
    802061fe:	fca43c23          	sd	a0,-40(s0)
    80206202:	fcb43823          	sd	a1,-48(s0)
    char *os;
    
    os = s;
    80206206:	fd843783          	ld	a5,-40(s0)
    8020620a:	fef43423          	sd	a5,-24(s0)
    while((*s++ = *t++) != 0)
    8020620e:	0001                	nop
    80206210:	fd043703          	ld	a4,-48(s0)
    80206214:	00170793          	addi	a5,a4,1
    80206218:	fcf43823          	sd	a5,-48(s0)
    8020621c:	fd843783          	ld	a5,-40(s0)
    80206220:	00178693          	addi	a3,a5,1
    80206224:	fcd43c23          	sd	a3,-40(s0)
    80206228:	00074703          	lbu	a4,0(a4)
    8020622c:	00e78023          	sb	a4,0(a5)
    80206230:	0007c783          	lbu	a5,0(a5)
    80206234:	fff1                	bnez	a5,80206210 <strcpy+0x18>
        ;
    return os;
    80206236:	fe843783          	ld	a5,-24(s0)
}
    8020623a:	853e                	mv	a0,a5
    8020623c:	7422                	ld	s0,40(sp)
    8020623e:	6145                	addi	sp,sp,48
    80206240:	8082                	ret

0000000080206242 <safestrcpy>:

// 安全的字符串复制（指定最大长度）
char* safestrcpy(char *s, const char *t, int n) {
    80206242:	7139                	addi	sp,sp,-64
    80206244:	fc22                	sd	s0,56(sp)
    80206246:	0080                	addi	s0,sp,64
    80206248:	fca43c23          	sd	a0,-40(s0)
    8020624c:	fcb43823          	sd	a1,-48(s0)
    80206250:	87b2                	mv	a5,a2
    80206252:	fcf42623          	sw	a5,-52(s0)
    char *os;
    
    os = s;
    80206256:	fd843783          	ld	a5,-40(s0)
    8020625a:	fef43423          	sd	a5,-24(s0)
    if(n <= 0)
    8020625e:	fcc42783          	lw	a5,-52(s0)
    80206262:	2781                	sext.w	a5,a5
    80206264:	00f04563          	bgtz	a5,8020626e <safestrcpy+0x2c>
        return os;
    80206268:	fe843783          	ld	a5,-24(s0)
    8020626c:	a0a9                	j	802062b6 <safestrcpy+0x74>
    while(--n > 0 && (*s++ = *t++) != 0)
    8020626e:	0001                	nop
    80206270:	fcc42783          	lw	a5,-52(s0)
    80206274:	37fd                	addiw	a5,a5,-1
    80206276:	fcf42623          	sw	a5,-52(s0)
    8020627a:	fcc42783          	lw	a5,-52(s0)
    8020627e:	2781                	sext.w	a5,a5
    80206280:	02f05563          	blez	a5,802062aa <safestrcpy+0x68>
    80206284:	fd043703          	ld	a4,-48(s0)
    80206288:	00170793          	addi	a5,a4,1
    8020628c:	fcf43823          	sd	a5,-48(s0)
    80206290:	fd843783          	ld	a5,-40(s0)
    80206294:	00178693          	addi	a3,a5,1
    80206298:	fcd43c23          	sd	a3,-40(s0)
    8020629c:	00074703          	lbu	a4,0(a4)
    802062a0:	00e78023          	sb	a4,0(a5)
    802062a4:	0007c783          	lbu	a5,0(a5)
    802062a8:	f7e1                	bnez	a5,80206270 <safestrcpy+0x2e>
        ;
    *s = 0;
    802062aa:	fd843783          	ld	a5,-40(s0)
    802062ae:	00078023          	sb	zero,0(a5)
    return os;
    802062b2:	fe843783          	ld	a5,-24(s0)
}
    802062b6:	853e                	mv	a0,a5
    802062b8:	7462                	ld	s0,56(sp)
    802062ba:	6121                	addi	sp,sp,64
    802062bc:	8082                	ret

00000000802062be <atoi>:
// 将字符串转换为整数
int atoi(const char *s) {
    802062be:	7179                	addi	sp,sp,-48
    802062c0:	f422                	sd	s0,40(sp)
    802062c2:	1800                	addi	s0,sp,48
    802062c4:	fca43c23          	sd	a0,-40(s0)
    int n = 0;
    802062c8:	fe042623          	sw	zero,-20(s0)
    int sign = 1;  // 正负号
    802062cc:	4785                	li	a5,1
    802062ce:	fef42423          	sw	a5,-24(s0)

    // 跳过空白字符
    while (*s == ' ' || *s == '\t') {
    802062d2:	a031                	j	802062de <atoi+0x20>
        s++;
    802062d4:	fd843783          	ld	a5,-40(s0)
    802062d8:	0785                	addi	a5,a5,1
    802062da:	fcf43c23          	sd	a5,-40(s0)
    while (*s == ' ' || *s == '\t') {
    802062de:	fd843783          	ld	a5,-40(s0)
    802062e2:	0007c783          	lbu	a5,0(a5)
    802062e6:	873e                	mv	a4,a5
    802062e8:	02000793          	li	a5,32
    802062ec:	fef704e3          	beq	a4,a5,802062d4 <atoi+0x16>
    802062f0:	fd843783          	ld	a5,-40(s0)
    802062f4:	0007c783          	lbu	a5,0(a5)
    802062f8:	873e                	mv	a4,a5
    802062fa:	47a5                	li	a5,9
    802062fc:	fcf70ce3          	beq	a4,a5,802062d4 <atoi+0x16>
    }

    // 处理符号
    if (*s == '-') {
    80206300:	fd843783          	ld	a5,-40(s0)
    80206304:	0007c783          	lbu	a5,0(a5)
    80206308:	873e                	mv	a4,a5
    8020630a:	02d00793          	li	a5,45
    8020630e:	00f71b63          	bne	a4,a5,80206324 <atoi+0x66>
        sign = -1;
    80206312:	57fd                	li	a5,-1
    80206314:	fef42423          	sw	a5,-24(s0)
        s++;
    80206318:	fd843783          	ld	a5,-40(s0)
    8020631c:	0785                	addi	a5,a5,1
    8020631e:	fcf43c23          	sd	a5,-40(s0)
    80206322:	a899                	j	80206378 <atoi+0xba>
    } else if (*s == '+') {
    80206324:	fd843783          	ld	a5,-40(s0)
    80206328:	0007c783          	lbu	a5,0(a5)
    8020632c:	873e                	mv	a4,a5
    8020632e:	02b00793          	li	a5,43
    80206332:	04f71363          	bne	a4,a5,80206378 <atoi+0xba>
        s++;
    80206336:	fd843783          	ld	a5,-40(s0)
    8020633a:	0785                	addi	a5,a5,1
    8020633c:	fcf43c23          	sd	a5,-40(s0)
    }

    // 转换数字字符
    while (*s >= '0' && *s <= '9') {
    80206340:	a825                	j	80206378 <atoi+0xba>
        n = n * 10 + (*s - '0');
    80206342:	fec42783          	lw	a5,-20(s0)
    80206346:	873e                	mv	a4,a5
    80206348:	87ba                	mv	a5,a4
    8020634a:	0027979b          	slliw	a5,a5,0x2
    8020634e:	9fb9                	addw	a5,a5,a4
    80206350:	0017979b          	slliw	a5,a5,0x1
    80206354:	0007871b          	sext.w	a4,a5
    80206358:	fd843783          	ld	a5,-40(s0)
    8020635c:	0007c783          	lbu	a5,0(a5)
    80206360:	2781                	sext.w	a5,a5
    80206362:	fd07879b          	addiw	a5,a5,-48
    80206366:	2781                	sext.w	a5,a5
    80206368:	9fb9                	addw	a5,a5,a4
    8020636a:	fef42623          	sw	a5,-20(s0)
        s++;
    8020636e:	fd843783          	ld	a5,-40(s0)
    80206372:	0785                	addi	a5,a5,1
    80206374:	fcf43c23          	sd	a5,-40(s0)
    while (*s >= '0' && *s <= '9') {
    80206378:	fd843783          	ld	a5,-40(s0)
    8020637c:	0007c783          	lbu	a5,0(a5)
    80206380:	873e                	mv	a4,a5
    80206382:	02f00793          	li	a5,47
    80206386:	00e7fb63          	bgeu	a5,a4,8020639c <atoi+0xde>
    8020638a:	fd843783          	ld	a5,-40(s0)
    8020638e:	0007c783          	lbu	a5,0(a5)
    80206392:	873e                	mv	a4,a5
    80206394:	03900793          	li	a5,57
    80206398:	fae7f5e3          	bgeu	a5,a4,80206342 <atoi+0x84>
    }

    return sign * n;
    8020639c:	fe842783          	lw	a5,-24(s0)
    802063a0:	873e                	mv	a4,a5
    802063a2:	fec42783          	lw	a5,-20(s0)
    802063a6:	02f707bb          	mulw	a5,a4,a5
    802063aa:	2781                	sext.w	a5,a5
    802063ac:	853e                	mv	a0,a5
    802063ae:	7422                	ld	s0,40(sp)
    802063b0:	6145                	addi	sp,sp,48
    802063b2:	8082                	ret

00000000802063b4 <assert>:

void shared_buffer_init() {
    proc_buffer = 0;
    proc_produced = 0;
}

    802063b4:	1101                	addi	sp,sp,-32
    802063b6:	ec06                	sd	ra,24(sp)
    802063b8:	e822                	sd	s0,16(sp)
    802063ba:	1000                	addi	s0,sp,32
    802063bc:	87aa                	mv	a5,a0
    802063be:	fef42623          	sw	a5,-20(s0)
void producer_task(void) {
    802063c2:	fec42783          	lw	a5,-20(s0)
    802063c6:	2781                	sext.w	a5,a5
    802063c8:	e79d                	bnez	a5,802063f6 <assert+0x42>
	// 复杂计算
    802063ca:	1b300613          	li	a2,435
    802063ce:	0001c597          	auipc	a1,0x1c
    802063d2:	41a58593          	addi	a1,a1,1050 # 802227e8 <syscall_performance_bin+0x670>
    802063d6:	0001c517          	auipc	a0,0x1c
    802063da:	42250513          	addi	a0,a0,1058 # 802227f8 <syscall_performance_bin+0x680>
    802063de:	ffffb097          	auipc	ra,0xffffb
    802063e2:	8f8080e7          	jalr	-1800(ra) # 80200cd6 <printf>
	int pid = myproc()->pid;
    802063e6:	0001c517          	auipc	a0,0x1c
    802063ea:	43a50513          	addi	a0,a0,1082 # 80222820 <syscall_performance_bin+0x6a8>
    802063ee:	ffffb097          	auipc	ra,0xffffb
    802063f2:	334080e7          	jalr	820(ra) # 80201722 <panic>
    uint64 sum = 0;
    const uint64 ITERATIONS = 10000000;  // 一千万次循环
    802063f6:	0001                	nop
    802063f8:	60e2                	ld	ra,24(sp)
    802063fa:	6442                	ld	s0,16(sp)
    802063fc:	6105                	addi	sp,sp,32
    802063fe:	8082                	ret

0000000080206400 <get_time>:
uint64 get_time(void) {
    80206400:	1141                	addi	sp,sp,-16
    80206402:	e406                	sd	ra,8(sp)
    80206404:	e022                	sd	s0,0(sp)
    80206406:	0800                	addi	s0,sp,16
    return sbi_get_time();
    80206408:	ffffd097          	auipc	ra,0xffffd
    8020640c:	100080e7          	jalr	256(ra) # 80203508 <sbi_get_time>
    80206410:	87aa                	mv	a5,a0
}
    80206412:	853e                	mv	a0,a5
    80206414:	60a2                	ld	ra,8(sp)
    80206416:	6402                	ld	s0,0(sp)
    80206418:	0141                	addi	sp,sp,16
    8020641a:	8082                	ret

000000008020641c <test_timer_interrupt>:
void test_timer_interrupt(void) {
    8020641c:	7179                	addi	sp,sp,-48
    8020641e:	f406                	sd	ra,40(sp)
    80206420:	f022                	sd	s0,32(sp)
    80206422:	1800                	addi	s0,sp,48
    printf("Testing timer interrupt...\n");
    80206424:	0001c517          	auipc	a0,0x1c
    80206428:	40450513          	addi	a0,a0,1028 # 80222828 <syscall_performance_bin+0x6b0>
    8020642c:	ffffb097          	auipc	ra,0xffffb
    80206430:	8aa080e7          	jalr	-1878(ra) # 80200cd6 <printf>
    uint64 start_time = get_time();
    80206434:	00000097          	auipc	ra,0x0
    80206438:	fcc080e7          	jalr	-52(ra) # 80206400 <get_time>
    8020643c:	fea43023          	sd	a0,-32(s0)
    int interrupt_count = 0;
    80206440:	fc042a23          	sw	zero,-44(s0)
    int last_count = 0;
    80206444:	fe042623          	sw	zero,-20(s0)
    interrupt_test_flag = &interrupt_count;
    80206448:	00020797          	auipc	a5,0x20
    8020644c:	d2078793          	addi	a5,a5,-736 # 80226168 <interrupt_test_flag>
    80206450:	fd440713          	addi	a4,s0,-44
    80206454:	e398                	sd	a4,0(a5)
    while (interrupt_count < 5) {
    80206456:	a899                	j	802064ac <test_timer_interrupt+0x90>
        if (last_count != interrupt_count) {
    80206458:	fd442703          	lw	a4,-44(s0)
    8020645c:	fec42783          	lw	a5,-20(s0)
    80206460:	2781                	sext.w	a5,a5
    80206462:	02e78163          	beq	a5,a4,80206484 <test_timer_interrupt+0x68>
            last_count = interrupt_count;
    80206466:	fd442783          	lw	a5,-44(s0)
    8020646a:	fef42623          	sw	a5,-20(s0)
            printf("Received interrupt %d\n", interrupt_count);
    8020646e:	fd442783          	lw	a5,-44(s0)
    80206472:	85be                	mv	a1,a5
    80206474:	0001c517          	auipc	a0,0x1c
    80206478:	3d450513          	addi	a0,a0,980 # 80222848 <syscall_performance_bin+0x6d0>
    8020647c:	ffffb097          	auipc	ra,0xffffb
    80206480:	85a080e7          	jalr	-1958(ra) # 80200cd6 <printf>
        for (volatile int i = 0; i < 1000000; i++);
    80206484:	fc042823          	sw	zero,-48(s0)
    80206488:	a801                	j	80206498 <test_timer_interrupt+0x7c>
    8020648a:	fd042783          	lw	a5,-48(s0)
    8020648e:	2781                	sext.w	a5,a5
    80206490:	2785                	addiw	a5,a5,1
    80206492:	2781                	sext.w	a5,a5
    80206494:	fcf42823          	sw	a5,-48(s0)
    80206498:	fd042783          	lw	a5,-48(s0)
    8020649c:	2781                	sext.w	a5,a5
    8020649e:	873e                	mv	a4,a5
    802064a0:	000f47b7          	lui	a5,0xf4
    802064a4:	23f78793          	addi	a5,a5,575 # f423f <_entry-0x8010bdc1>
    802064a8:	fee7d1e3          	bge	a5,a4,8020648a <test_timer_interrupt+0x6e>
    while (interrupt_count < 5) {
    802064ac:	fd442783          	lw	a5,-44(s0)
    802064b0:	873e                	mv	a4,a5
    802064b2:	4791                	li	a5,4
    802064b4:	fae7d2e3          	bge	a5,a4,80206458 <test_timer_interrupt+0x3c>
    interrupt_test_flag = 0;
    802064b8:	00020797          	auipc	a5,0x20
    802064bc:	cb078793          	addi	a5,a5,-848 # 80226168 <interrupt_test_flag>
    802064c0:	0007b023          	sd	zero,0(a5)
    uint64 end_time = get_time();
    802064c4:	00000097          	auipc	ra,0x0
    802064c8:	f3c080e7          	jalr	-196(ra) # 80206400 <get_time>
    802064cc:	fca43c23          	sd	a0,-40(s0)
    printf("Timer test completed: %d interrupts in %lu cycles\n",
    802064d0:	fd442683          	lw	a3,-44(s0)
    802064d4:	fd843703          	ld	a4,-40(s0)
    802064d8:	fe043783          	ld	a5,-32(s0)
    802064dc:	40f707b3          	sub	a5,a4,a5
    802064e0:	863e                	mv	a2,a5
    802064e2:	85b6                	mv	a1,a3
    802064e4:	0001c517          	auipc	a0,0x1c
    802064e8:	37c50513          	addi	a0,a0,892 # 80222860 <syscall_performance_bin+0x6e8>
    802064ec:	ffffa097          	auipc	ra,0xffffa
    802064f0:	7ea080e7          	jalr	2026(ra) # 80200cd6 <printf>
}
    802064f4:	0001                	nop
    802064f6:	70a2                	ld	ra,40(sp)
    802064f8:	7402                	ld	s0,32(sp)
    802064fa:	6145                	addi	sp,sp,48
    802064fc:	8082                	ret

00000000802064fe <test_exception>:
void test_exception(void) {
    802064fe:	711d                	addi	sp,sp,-96
    80206500:	ec86                	sd	ra,88(sp)
    80206502:	e8a2                	sd	s0,80(sp)
    80206504:	1080                	addi	s0,sp,96
    printf("\n===== 开始全面异常处理测试 =====\n\n");
    80206506:	0001c517          	auipc	a0,0x1c
    8020650a:	39250513          	addi	a0,a0,914 # 80222898 <syscall_performance_bin+0x720>
    8020650e:	ffffa097          	auipc	ra,0xffffa
    80206512:	7c8080e7          	jalr	1992(ra) # 80200cd6 <printf>
    printf("1. 测试非法指令异常...\n");
    80206516:	0001c517          	auipc	a0,0x1c
    8020651a:	3b250513          	addi	a0,a0,946 # 802228c8 <syscall_performance_bin+0x750>
    8020651e:	ffffa097          	auipc	ra,0xffffa
    80206522:	7b8080e7          	jalr	1976(ra) # 80200cd6 <printf>
    80206526:	ffffffff          	.word	0xffffffff
    printf("✓ 识别到指令异常并尝试忽略\n\n");
    8020652a:	0001c517          	auipc	a0,0x1c
    8020652e:	3be50513          	addi	a0,a0,958 # 802228e8 <syscall_performance_bin+0x770>
    80206532:	ffffa097          	auipc	ra,0xffffa
    80206536:	7a4080e7          	jalr	1956(ra) # 80200cd6 <printf>
    printf("2. 测试存储页故障异常...\n");
    8020653a:	0001c517          	auipc	a0,0x1c
    8020653e:	3de50513          	addi	a0,a0,990 # 80222918 <syscall_performance_bin+0x7a0>
    80206542:	ffffa097          	auipc	ra,0xffffa
    80206546:	794080e7          	jalr	1940(ra) # 80200cd6 <printf>
    volatile uint64 *invalid_ptr = 0;
    8020654a:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    8020654e:	47a5                	li	a5,9
    80206550:	07f2                	slli	a5,a5,0x1c
    80206552:	fef43023          	sd	a5,-32(s0)
    80206556:	a835                	j	80206592 <test_exception+0x94>
        if (check_is_mapped(addr) == 0) {
    80206558:	fe043503          	ld	a0,-32(s0)
    8020655c:	ffffd097          	auipc	ra,0xffffd
    80206560:	ac4080e7          	jalr	-1340(ra) # 80203020 <check_is_mapped>
    80206564:	87aa                	mv	a5,a0
    80206566:	e385                	bnez	a5,80206586 <test_exception+0x88>
            invalid_ptr = (uint64*)addr;
    80206568:	fe043783          	ld	a5,-32(s0)
    8020656c:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    80206570:	fe043583          	ld	a1,-32(s0)
    80206574:	0001c517          	auipc	a0,0x1c
    80206578:	3cc50513          	addi	a0,a0,972 # 80222940 <syscall_performance_bin+0x7c8>
    8020657c:	ffffa097          	auipc	ra,0xffffa
    80206580:	75a080e7          	jalr	1882(ra) # 80200cd6 <printf>
            break;
    80206584:	a829                	j	8020659e <test_exception+0xa0>
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    80206586:	fe043703          	ld	a4,-32(s0)
    8020658a:	6785                	lui	a5,0x1
    8020658c:	97ba                	add	a5,a5,a4
    8020658e:	fef43023          	sd	a5,-32(s0)
    80206592:	fe043703          	ld	a4,-32(s0)
    80206596:	47cd                	li	a5,19
    80206598:	07ee                	slli	a5,a5,0x1b
    8020659a:	faf76fe3          	bltu	a4,a5,80206558 <test_exception+0x5a>
    if (invalid_ptr != 0) {
    8020659e:	fe843783          	ld	a5,-24(s0)
    802065a2:	cb95                	beqz	a5,802065d6 <test_exception+0xd8>
        printf("尝试写入未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    802065a4:	fe843783          	ld	a5,-24(s0)
    802065a8:	85be                	mv	a1,a5
    802065aa:	0001c517          	auipc	a0,0x1c
    802065ae:	3b650513          	addi	a0,a0,950 # 80222960 <syscall_performance_bin+0x7e8>
    802065b2:	ffffa097          	auipc	ra,0xffffa
    802065b6:	724080e7          	jalr	1828(ra) # 80200cd6 <printf>
        *invalid_ptr = 42;  // 触发存储页故障
    802065ba:	fe843783          	ld	a5,-24(s0)
    802065be:	02a00713          	li	a4,42
    802065c2:	e398                	sd	a4,0(a5)
        printf("✓ 存储页故障异常处理成功\n\n");
    802065c4:	0001c517          	auipc	a0,0x1c
    802065c8:	3cc50513          	addi	a0,a0,972 # 80222990 <syscall_performance_bin+0x818>
    802065cc:	ffffa097          	auipc	ra,0xffffa
    802065d0:	70a080e7          	jalr	1802(ra) # 80200cd6 <printf>
    802065d4:	a809                	j	802065e6 <test_exception+0xe8>
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    802065d6:	0001c517          	auipc	a0,0x1c
    802065da:	3e250513          	addi	a0,a0,994 # 802229b8 <syscall_performance_bin+0x840>
    802065de:	ffffa097          	auipc	ra,0xffffa
    802065e2:	6f8080e7          	jalr	1784(ra) # 80200cd6 <printf>
    printf("3. 测试加载页故障异常...\n");
    802065e6:	0001c517          	auipc	a0,0x1c
    802065ea:	40a50513          	addi	a0,a0,1034 # 802229f0 <syscall_performance_bin+0x878>
    802065ee:	ffffa097          	auipc	ra,0xffffa
    802065f2:	6e8080e7          	jalr	1768(ra) # 80200cd6 <printf>
    invalid_ptr = 0;
    802065f6:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    802065fa:	4795                	li	a5,5
    802065fc:	07f6                	slli	a5,a5,0x1d
    802065fe:	fcf43c23          	sd	a5,-40(s0)
    80206602:	a835                	j	8020663e <test_exception+0x140>
        if (check_is_mapped(addr) == 0) {
    80206604:	fd843503          	ld	a0,-40(s0)
    80206608:	ffffd097          	auipc	ra,0xffffd
    8020660c:	a18080e7          	jalr	-1512(ra) # 80203020 <check_is_mapped>
    80206610:	87aa                	mv	a5,a0
    80206612:	e385                	bnez	a5,80206632 <test_exception+0x134>
            invalid_ptr = (uint64*)addr;
    80206614:	fd843783          	ld	a5,-40(s0)
    80206618:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    8020661c:	fd843583          	ld	a1,-40(s0)
    80206620:	0001c517          	auipc	a0,0x1c
    80206624:	32050513          	addi	a0,a0,800 # 80222940 <syscall_performance_bin+0x7c8>
    80206628:	ffffa097          	auipc	ra,0xffffa
    8020662c:	6ae080e7          	jalr	1710(ra) # 80200cd6 <printf>
            break;
    80206630:	a829                	j	8020664a <test_exception+0x14c>
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    80206632:	fd843703          	ld	a4,-40(s0)
    80206636:	6785                	lui	a5,0x1
    80206638:	97ba                	add	a5,a5,a4
    8020663a:	fcf43c23          	sd	a5,-40(s0)
    8020663e:	fd843703          	ld	a4,-40(s0)
    80206642:	47d5                	li	a5,21
    80206644:	07ee                	slli	a5,a5,0x1b
    80206646:	faf76fe3          	bltu	a4,a5,80206604 <test_exception+0x106>
    if (invalid_ptr != 0) {
    8020664a:	fe843783          	ld	a5,-24(s0)
    8020664e:	c7a9                	beqz	a5,80206698 <test_exception+0x19a>
        printf("尝试读取未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    80206650:	fe843783          	ld	a5,-24(s0)
    80206654:	85be                	mv	a1,a5
    80206656:	0001c517          	auipc	a0,0x1c
    8020665a:	3c250513          	addi	a0,a0,962 # 80222a18 <syscall_performance_bin+0x8a0>
    8020665e:	ffffa097          	auipc	ra,0xffffa
    80206662:	678080e7          	jalr	1656(ra) # 80200cd6 <printf>
        volatile uint64 value = *invalid_ptr;  // 触发加载页故障
    80206666:	fe843783          	ld	a5,-24(s0)
    8020666a:	639c                	ld	a5,0(a5)
    8020666c:	faf43023          	sd	a5,-96(s0)
        printf("读取的值: %lu\n", value);  // 除非故障被处理
    80206670:	fa043783          	ld	a5,-96(s0)
    80206674:	85be                	mv	a1,a5
    80206676:	0001c517          	auipc	a0,0x1c
    8020667a:	3d250513          	addi	a0,a0,978 # 80222a48 <syscall_performance_bin+0x8d0>
    8020667e:	ffffa097          	auipc	ra,0xffffa
    80206682:	658080e7          	jalr	1624(ra) # 80200cd6 <printf>
        printf("✓ 加载页故障异常处理成功\n\n");
    80206686:	0001c517          	auipc	a0,0x1c
    8020668a:	3da50513          	addi	a0,a0,986 # 80222a60 <syscall_performance_bin+0x8e8>
    8020668e:	ffffa097          	auipc	ra,0xffffa
    80206692:	648080e7          	jalr	1608(ra) # 80200cd6 <printf>
    80206696:	a809                	j	802066a8 <test_exception+0x1aa>
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    80206698:	0001c517          	auipc	a0,0x1c
    8020669c:	32050513          	addi	a0,a0,800 # 802229b8 <syscall_performance_bin+0x840>
    802066a0:	ffffa097          	auipc	ra,0xffffa
    802066a4:	636080e7          	jalr	1590(ra) # 80200cd6 <printf>
    printf("4. 测试存储地址未对齐异常...\n");
    802066a8:	0001c517          	auipc	a0,0x1c
    802066ac:	3e050513          	addi	a0,a0,992 # 80222a88 <syscall_performance_bin+0x910>
    802066b0:	ffffa097          	auipc	ra,0xffffa
    802066b4:	626080e7          	jalr	1574(ra) # 80200cd6 <printf>
    uint64 aligned_addr = (uint64)alloc_page();
    802066b8:	ffffd097          	auipc	ra,0xffffd
    802066bc:	bb0080e7          	jalr	-1104(ra) # 80203268 <alloc_page>
    802066c0:	87aa                	mv	a5,a0
    802066c2:	fcf43823          	sd	a5,-48(s0)
    if (aligned_addr != 0) {
    802066c6:	fd043783          	ld	a5,-48(s0)
    802066ca:	c3a1                	beqz	a5,8020670a <test_exception+0x20c>
        uint64 misaligned_addr = aligned_addr + 1;  // 制造未对齐地址
    802066cc:	fd043783          	ld	a5,-48(s0)
    802066d0:	0785                	addi	a5,a5,1 # 1001 <_entry-0x801fefff>
    802066d2:	fcf43423          	sd	a5,-56(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    802066d6:	fc843583          	ld	a1,-56(s0)
    802066da:	0001c517          	auipc	a0,0x1c
    802066de:	3de50513          	addi	a0,a0,990 # 80222ab8 <syscall_performance_bin+0x940>
    802066e2:	ffffa097          	auipc	ra,0xffffa
    802066e6:	5f4080e7          	jalr	1524(ra) # 80200cd6 <printf>
        asm volatile (
    802066ea:	deadc7b7          	lui	a5,0xdeadc
    802066ee:	eef7879b          	addiw	a5,a5,-273 # ffffffffdeadbeef <_bss_end+0xffffffff5e8b574f>
    802066f2:	fc843703          	ld	a4,-56(s0)
    802066f6:	e31c                	sd	a5,0(a4)
        printf("✓ 存储地址未对齐异常处理成功\n\n");
    802066f8:	0001c517          	auipc	a0,0x1c
    802066fc:	3e050513          	addi	a0,a0,992 # 80222ad8 <syscall_performance_bin+0x960>
    80206700:	ffffa097          	auipc	ra,0xffffa
    80206704:	5d6080e7          	jalr	1494(ra) # 80200cd6 <printf>
    80206708:	a809                	j	8020671a <test_exception+0x21c>
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    8020670a:	0001c517          	auipc	a0,0x1c
    8020670e:	3fe50513          	addi	a0,a0,1022 # 80222b08 <syscall_performance_bin+0x990>
    80206712:	ffffa097          	auipc	ra,0xffffa
    80206716:	5c4080e7          	jalr	1476(ra) # 80200cd6 <printf>
    printf("5. 测试加载地址未对齐异常...\n");
    8020671a:	0001c517          	auipc	a0,0x1c
    8020671e:	42e50513          	addi	a0,a0,1070 # 80222b48 <syscall_performance_bin+0x9d0>
    80206722:	ffffa097          	auipc	ra,0xffffa
    80206726:	5b4080e7          	jalr	1460(ra) # 80200cd6 <printf>
    if (aligned_addr != 0) {
    8020672a:	fd043783          	ld	a5,-48(s0)
    8020672e:	cbb1                	beqz	a5,80206782 <test_exception+0x284>
        uint64 misaligned_addr = aligned_addr + 1;
    80206730:	fd043783          	ld	a5,-48(s0)
    80206734:	0785                	addi	a5,a5,1
    80206736:	fcf43023          	sd	a5,-64(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    8020673a:	fc043583          	ld	a1,-64(s0)
    8020673e:	0001c517          	auipc	a0,0x1c
    80206742:	37a50513          	addi	a0,a0,890 # 80222ab8 <syscall_performance_bin+0x940>
    80206746:	ffffa097          	auipc	ra,0xffffa
    8020674a:	590080e7          	jalr	1424(ra) # 80200cd6 <printf>
        uint64 value = 0;
    8020674e:	fa043c23          	sd	zero,-72(s0)
        asm volatile (
    80206752:	fc043783          	ld	a5,-64(s0)
    80206756:	639c                	ld	a5,0(a5)
    80206758:	faf43c23          	sd	a5,-72(s0)
        printf("读取的值: 0x%lx\n", value);
    8020675c:	fb843583          	ld	a1,-72(s0)
    80206760:	0001c517          	auipc	a0,0x1c
    80206764:	41850513          	addi	a0,a0,1048 # 80222b78 <syscall_performance_bin+0xa00>
    80206768:	ffffa097          	auipc	ra,0xffffa
    8020676c:	56e080e7          	jalr	1390(ra) # 80200cd6 <printf>
        printf("✓ 加载地址未对齐异常处理成功\n\n");
    80206770:	0001c517          	auipc	a0,0x1c
    80206774:	42050513          	addi	a0,a0,1056 # 80222b90 <syscall_performance_bin+0xa18>
    80206778:	ffffa097          	auipc	ra,0xffffa
    8020677c:	55e080e7          	jalr	1374(ra) # 80200cd6 <printf>
    80206780:	a809                	j	80206792 <test_exception+0x294>
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    80206782:	0001c517          	auipc	a0,0x1c
    80206786:	38650513          	addi	a0,a0,902 # 80222b08 <syscall_performance_bin+0x990>
    8020678a:	ffffa097          	auipc	ra,0xffffa
    8020678e:	54c080e7          	jalr	1356(ra) # 80200cd6 <printf>
	printf("6. 测试断点异常...\n");
    80206792:	0001c517          	auipc	a0,0x1c
    80206796:	42e50513          	addi	a0,a0,1070 # 80222bc0 <syscall_performance_bin+0xa48>
    8020679a:	ffffa097          	auipc	ra,0xffffa
    8020679e:	53c080e7          	jalr	1340(ra) # 80200cd6 <printf>
	asm volatile (
    802067a2:	0001                	nop
    802067a4:	9002                	ebreak
    802067a6:	0001                	nop
	printf("✓ 断点异常处理成功\n\n");
    802067a8:	0001c517          	auipc	a0,0x1c
    802067ac:	43850513          	addi	a0,a0,1080 # 80222be0 <syscall_performance_bin+0xa68>
    802067b0:	ffffa097          	auipc	ra,0xffffa
    802067b4:	526080e7          	jalr	1318(ra) # 80200cd6 <printf>
    printf("7. 测试环境调用异常...\n");
    802067b8:	0001c517          	auipc	a0,0x1c
    802067bc:	44850513          	addi	a0,a0,1096 # 80222c00 <syscall_performance_bin+0xa88>
    802067c0:	ffffa097          	auipc	ra,0xffffa
    802067c4:	516080e7          	jalr	1302(ra) # 80200cd6 <printf>
    asm volatile ("ecall");  // 从S模式生成环境调用
    802067c8:	00000073          	ecall
    printf("✓ 环境调用异常处理成功\n\n");
    802067cc:	0001c517          	auipc	a0,0x1c
    802067d0:	45450513          	addi	a0,a0,1108 # 80222c20 <syscall_performance_bin+0xaa8>
    802067d4:	ffffa097          	auipc	ra,0xffffa
    802067d8:	502080e7          	jalr	1282(ra) # 80200cd6 <printf>
    printf("===== 部分异常处理测试完成 =====\n\n");
    802067dc:	0001c517          	auipc	a0,0x1c
    802067e0:	46c50513          	addi	a0,a0,1132 # 80222c48 <syscall_performance_bin+0xad0>
    802067e4:	ffffa097          	auipc	ra,0xffffa
    802067e8:	4f2080e7          	jalr	1266(ra) # 80200cd6 <printf>
	printf("===== 测试不可恢复的除零异常 ====\n");
    802067ec:	0001c517          	auipc	a0,0x1c
    802067f0:	48c50513          	addi	a0,a0,1164 # 80222c78 <syscall_performance_bin+0xb00>
    802067f4:	ffffa097          	auipc	ra,0xffffa
    802067f8:	4e2080e7          	jalr	1250(ra) # 80200cd6 <printf>
	unsigned int a = 1;
    802067fc:	4785                	li	a5,1
    802067fe:	faf42a23          	sw	a5,-76(s0)
	unsigned int b =0;
    80206802:	fa042823          	sw	zero,-80(s0)
	unsigned int result = a/b;
    80206806:	fb442783          	lw	a5,-76(s0)
    8020680a:	873e                	mv	a4,a5
    8020680c:	fb042783          	lw	a5,-80(s0)
    80206810:	02f757bb          	divuw	a5,a4,a5
    80206814:	faf42623          	sw	a5,-84(s0)
	printf("这行不应该被打印，如果打印了，那么result = %d\n",result);
    80206818:	fac42783          	lw	a5,-84(s0)
    8020681c:	85be                	mv	a1,a5
    8020681e:	0001c517          	auipc	a0,0x1c
    80206822:	48a50513          	addi	a0,a0,1162 # 80222ca8 <syscall_performance_bin+0xb30>
    80206826:	ffffa097          	auipc	ra,0xffffa
    8020682a:	4b0080e7          	jalr	1200(ra) # 80200cd6 <printf>
}
    8020682e:	0001                	nop
    80206830:	60e6                	ld	ra,88(sp)
    80206832:	6446                	ld	s0,80(sp)
    80206834:	6125                	addi	sp,sp,96
    80206836:	8082                	ret

0000000080206838 <test_interrupt_overhead>:
void test_interrupt_overhead(void) {
    80206838:	715d                	addi	sp,sp,-80
    8020683a:	e486                	sd	ra,72(sp)
    8020683c:	e0a2                	sd	s0,64(sp)
    8020683e:	0880                	addi	s0,sp,80
    printf("\n===== 开始中断开销测试 =====\n");
    80206840:	0001c517          	auipc	a0,0x1c
    80206844:	4a850513          	addi	a0,a0,1192 # 80222ce8 <syscall_performance_bin+0xb70>
    80206848:	ffffa097          	auipc	ra,0xffffa
    8020684c:	48e080e7          	jalr	1166(ra) # 80200cd6 <printf>
    printf("\n----- 测试1: 时钟中断处理时间 -----\n");
    80206850:	0001c517          	auipc	a0,0x1c
    80206854:	4c050513          	addi	a0,a0,1216 # 80222d10 <syscall_performance_bin+0xb98>
    80206858:	ffffa097          	auipc	ra,0xffffa
    8020685c:	47e080e7          	jalr	1150(ra) # 80200cd6 <printf>
    int count = 0;
    80206860:	fa042a23          	sw	zero,-76(s0)
    volatile int *test_flag = &count;
    80206864:	fb440793          	addi	a5,s0,-76
    80206868:	fef43023          	sd	a5,-32(s0)
    start_cycles = get_time();
    8020686c:	00000097          	auipc	ra,0x0
    80206870:	b94080e7          	jalr	-1132(ra) # 80206400 <get_time>
    80206874:	fca43c23          	sd	a0,-40(s0)
    interrupt_test_flag = test_flag;  // 设置全局标志
    80206878:	00020797          	auipc	a5,0x20
    8020687c:	8f078793          	addi	a5,a5,-1808 # 80226168 <interrupt_test_flag>
    80206880:	fe043703          	ld	a4,-32(s0)
    80206884:	e398                	sd	a4,0(a5)
    while(count < 10) {
    80206886:	a011                	j	8020688a <test_interrupt_overhead+0x52>
        asm volatile("nop");
    80206888:	0001                	nop
    while(count < 10) {
    8020688a:	fb442783          	lw	a5,-76(s0)
    8020688e:	873e                	mv	a4,a5
    80206890:	47a5                	li	a5,9
    80206892:	fee7dbe3          	bge	a5,a4,80206888 <test_interrupt_overhead+0x50>
    end_cycles = get_time();
    80206896:	00000097          	auipc	ra,0x0
    8020689a:	b6a080e7          	jalr	-1174(ra) # 80206400 <get_time>
    8020689e:	fca43823          	sd	a0,-48(s0)
    interrupt_test_flag = 0;  // 清除标志
    802068a2:	00020797          	auipc	a5,0x20
    802068a6:	8c678793          	addi	a5,a5,-1850 # 80226168 <interrupt_test_flag>
    802068aa:	0007b023          	sd	zero,0(a5)
    uint64 total_cycles = end_cycles - start_cycles;
    802068ae:	fd043703          	ld	a4,-48(s0)
    802068b2:	fd843783          	ld	a5,-40(s0)
    802068b6:	40f707b3          	sub	a5,a4,a5
    802068ba:	fcf43423          	sd	a5,-56(s0)
    uint64 avg_cycles1 = total_cycles / 10;
    802068be:	fc843703          	ld	a4,-56(s0)
    802068c2:	47a9                	li	a5,10
    802068c4:	02f757b3          	divu	a5,a4,a5
    802068c8:	fcf43023          	sd	a5,-64(s0)
    printf("平均每次时钟中断处理耗时: %lu cycles\n", avg_cycles1);
    802068cc:	fc043583          	ld	a1,-64(s0)
    802068d0:	0001c517          	auipc	a0,0x1c
    802068d4:	47050513          	addi	a0,a0,1136 # 80222d40 <syscall_performance_bin+0xbc8>
    802068d8:	ffffa097          	auipc	ra,0xffffa
    802068dc:	3fe080e7          	jalr	1022(ra) # 80200cd6 <printf>
    printf("\n----- 测试2: 上下文切换成本 -----\n");
    802068e0:	0001c517          	auipc	a0,0x1c
    802068e4:	49850513          	addi	a0,a0,1176 # 80222d78 <syscall_performance_bin+0xc00>
    802068e8:	ffffa097          	auipc	ra,0xffffa
    802068ec:	3ee080e7          	jalr	1006(ra) # 80200cd6 <printf>
    start_cycles = get_time();
    802068f0:	00000097          	auipc	ra,0x0
    802068f4:	b10080e7          	jalr	-1264(ra) # 80206400 <get_time>
    802068f8:	fca43c23          	sd	a0,-40(s0)
    for(int i = 0; i < 1000; i++) {
    802068fc:	fe042623          	sw	zero,-20(s0)
    80206900:	a801                	j	80206910 <test_interrupt_overhead+0xd8>
    80206902:	ffffffff          	.word	0xffffffff
    80206906:	fec42783          	lw	a5,-20(s0)
    8020690a:	2785                	addiw	a5,a5,1
    8020690c:	fef42623          	sw	a5,-20(s0)
    80206910:	fec42783          	lw	a5,-20(s0)
    80206914:	0007871b          	sext.w	a4,a5
    80206918:	3e700793          	li	a5,999
    8020691c:	fee7d3e3          	bge	a5,a4,80206902 <test_interrupt_overhead+0xca>
    end_cycles = get_time();
    80206920:	00000097          	auipc	ra,0x0
    80206924:	ae0080e7          	jalr	-1312(ra) # 80206400 <get_time>
    80206928:	fca43823          	sd	a0,-48(s0)
    uint64 avg_cycles2 = (end_cycles - start_cycles) / 1000;
    8020692c:	fd043703          	ld	a4,-48(s0)
    80206930:	fd843783          	ld	a5,-40(s0)
    80206934:	8f1d                	sub	a4,a4,a5
    80206936:	3e800793          	li	a5,1000
    8020693a:	02f757b3          	divu	a5,a4,a5
    8020693e:	faf43c23          	sd	a5,-72(s0)
	printf("平均每次时钟中断处理耗时: %lu cycles\n", avg_cycles1);
    80206942:	fc043583          	ld	a1,-64(s0)
    80206946:	0001c517          	auipc	a0,0x1c
    8020694a:	3fa50513          	addi	a0,a0,1018 # 80222d40 <syscall_performance_bin+0xbc8>
    8020694e:	ffffa097          	auipc	ra,0xffffa
    80206952:	388080e7          	jalr	904(ra) # 80200cd6 <printf>
    printf("平均每次上下文切换耗时: %lu cycles\n", avg_cycles2);
    80206956:	fb843583          	ld	a1,-72(s0)
    8020695a:	0001c517          	auipc	a0,0x1c
    8020695e:	44e50513          	addi	a0,a0,1102 # 80222da8 <syscall_performance_bin+0xc30>
    80206962:	ffffa097          	auipc	ra,0xffffa
    80206966:	374080e7          	jalr	884(ra) # 80200cd6 <printf>
    printf("\n===== 中断开销测试完成 =====\n");
    8020696a:	0001c517          	auipc	a0,0x1c
    8020696e:	46e50513          	addi	a0,a0,1134 # 80222dd8 <syscall_performance_bin+0xc60>
    80206972:	ffffa097          	auipc	ra,0xffffa
    80206976:	364080e7          	jalr	868(ra) # 80200cd6 <printf>
}
    8020697a:	0001                	nop
    8020697c:	60a6                	ld	ra,72(sp)
    8020697e:	6406                	ld	s0,64(sp)
    80206980:	6161                	addi	sp,sp,80
    80206982:	8082                	ret

0000000080206984 <simple_task>:
void simple_task(void) {
    80206984:	1141                	addi	sp,sp,-16
    80206986:	e406                	sd	ra,8(sp)
    80206988:	e022                	sd	s0,0(sp)
    8020698a:	0800                	addi	s0,sp,16
    printf("Simple kernel task running in PID %d\n", myproc()->pid);
    8020698c:	ffffe097          	auipc	ra,0xffffe
    80206990:	594080e7          	jalr	1428(ra) # 80204f20 <myproc>
    80206994:	87aa                	mv	a5,a0
    80206996:	43dc                	lw	a5,4(a5)
    80206998:	85be                	mv	a1,a5
    8020699a:	0001c517          	auipc	a0,0x1c
    8020699e:	46650513          	addi	a0,a0,1126 # 80222e00 <syscall_performance_bin+0xc88>
    802069a2:	ffffa097          	auipc	ra,0xffffa
    802069a6:	334080e7          	jalr	820(ra) # 80200cd6 <printf>
}
    802069aa:	0001                	nop
    802069ac:	60a2                	ld	ra,8(sp)
    802069ae:	6402                	ld	s0,0(sp)
    802069b0:	0141                	addi	sp,sp,16
    802069b2:	8082                	ret

00000000802069b4 <test_process_creation>:
void test_process_creation(void) {
    802069b4:	7119                	addi	sp,sp,-128
    802069b6:	fc86                	sd	ra,120(sp)
    802069b8:	f8a2                	sd	s0,112(sp)
    802069ba:	0100                	addi	s0,sp,128
    printf("===== 测试开始: 进程创建与管理测试 =====\n");
    802069bc:	0001c517          	auipc	a0,0x1c
    802069c0:	46c50513          	addi	a0,a0,1132 # 80222e28 <syscall_performance_bin+0xcb0>
    802069c4:	ffffa097          	auipc	ra,0xffffa
    802069c8:	312080e7          	jalr	786(ra) # 80200cd6 <printf>
    printf("\n----- 第一阶段：测试内核进程创建与管理 -----\n");
    802069cc:	0001c517          	auipc	a0,0x1c
    802069d0:	49450513          	addi	a0,a0,1172 # 80222e60 <syscall_performance_bin+0xce8>
    802069d4:	ffffa097          	auipc	ra,0xffffa
    802069d8:	302080e7          	jalr	770(ra) # 80200cd6 <printf>
    int pid = create_kernel_proc(simple_task);
    802069dc:	00000517          	auipc	a0,0x0
    802069e0:	fa850513          	addi	a0,a0,-88 # 80206984 <simple_task>
    802069e4:	fffff097          	auipc	ra,0xfffff
    802069e8:	b7c080e7          	jalr	-1156(ra) # 80205560 <create_kernel_proc>
    802069ec:	87aa                	mv	a5,a0
    802069ee:	faf42a23          	sw	a5,-76(s0)
    assert(pid > 0);
    802069f2:	fb442783          	lw	a5,-76(s0)
    802069f6:	2781                	sext.w	a5,a5
    802069f8:	00f027b3          	sgtz	a5,a5
    802069fc:	0ff7f793          	zext.b	a5,a5
    80206a00:	2781                	sext.w	a5,a5
    80206a02:	853e                	mv	a0,a5
    80206a04:	00000097          	auipc	ra,0x0
    80206a08:	9b0080e7          	jalr	-1616(ra) # 802063b4 <assert>
    printf("【测试结果】: 基本内核进程创建成功，PID: %d\n", pid);
    80206a0c:	fb442783          	lw	a5,-76(s0)
    80206a10:	85be                	mv	a1,a5
    80206a12:	0001c517          	auipc	a0,0x1c
    80206a16:	48e50513          	addi	a0,a0,1166 # 80222ea0 <syscall_performance_bin+0xd28>
    80206a1a:	ffffa097          	auipc	ra,0xffffa
    80206a1e:	2bc080e7          	jalr	700(ra) # 80200cd6 <printf>
    printf("\n----- 用内核进程填满进程表 -----\n");
    80206a22:	0001c517          	auipc	a0,0x1c
    80206a26:	4be50513          	addi	a0,a0,1214 # 80222ee0 <syscall_performance_bin+0xd68>
    80206a2a:	ffffa097          	auipc	ra,0xffffa
    80206a2e:	2ac080e7          	jalr	684(ra) # 80200cd6 <printf>
    int kernel_count = 1; // 已经创建了一个
    80206a32:	4785                	li	a5,1
    80206a34:	fef42623          	sw	a5,-20(s0)
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    80206a38:	4785                	li	a5,1
    80206a3a:	fef42423          	sw	a5,-24(s0)
    80206a3e:	a881                	j	80206a8e <test_process_creation+0xda>
        int new_pid = create_kernel_proc(simple_task);
    80206a40:	00000517          	auipc	a0,0x0
    80206a44:	f4450513          	addi	a0,a0,-188 # 80206984 <simple_task>
    80206a48:	fffff097          	auipc	ra,0xfffff
    80206a4c:	b18080e7          	jalr	-1256(ra) # 80205560 <create_kernel_proc>
    80206a50:	87aa                	mv	a5,a0
    80206a52:	faf42823          	sw	a5,-80(s0)
        if (new_pid > 0) {
    80206a56:	fb042783          	lw	a5,-80(s0)
    80206a5a:	2781                	sext.w	a5,a5
    80206a5c:	00f05863          	blez	a5,80206a6c <test_process_creation+0xb8>
            kernel_count++; 
    80206a60:	fec42783          	lw	a5,-20(s0)
    80206a64:	2785                	addiw	a5,a5,1
    80206a66:	fef42623          	sw	a5,-20(s0)
    80206a6a:	a829                	j	80206a84 <test_process_creation+0xd0>
            warning("process table was full at %d kernel processes\n", kernel_count);
    80206a6c:	fec42783          	lw	a5,-20(s0)
    80206a70:	85be                	mv	a1,a5
    80206a72:	0001c517          	auipc	a0,0x1c
    80206a76:	49e50513          	addi	a0,a0,1182 # 80222f10 <syscall_performance_bin+0xd98>
    80206a7a:	ffffb097          	auipc	ra,0xffffb
    80206a7e:	cdc080e7          	jalr	-804(ra) # 80201756 <warning>
            break;
    80206a82:	a829                	j	80206a9c <test_process_creation+0xe8>
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    80206a84:	fe842783          	lw	a5,-24(s0)
    80206a88:	2785                	addiw	a5,a5,1
    80206a8a:	fef42423          	sw	a5,-24(s0)
    80206a8e:	fe842783          	lw	a5,-24(s0)
    80206a92:	0007871b          	sext.w	a4,a5
    80206a96:	47fd                	li	a5,31
    80206a98:	fae7d4e3          	bge	a5,a4,80206a40 <test_process_creation+0x8c>
    printf("【测试结果】: 成功创建 %d 个内核进程 (最大限制: %d)\n", kernel_count, PROC);
    80206a9c:	fec42783          	lw	a5,-20(s0)
    80206aa0:	02000613          	li	a2,32
    80206aa4:	85be                	mv	a1,a5
    80206aa6:	0001c517          	auipc	a0,0x1c
    80206aaa:	49a50513          	addi	a0,a0,1178 # 80222f40 <syscall_performance_bin+0xdc8>
    80206aae:	ffffa097          	auipc	ra,0xffffa
    80206ab2:	228080e7          	jalr	552(ra) # 80200cd6 <printf>
    print_proc_table();
    80206ab6:	fffff097          	auipc	ra,0xfffff
    80206aba:	46a080e7          	jalr	1130(ra) # 80205f20 <print_proc_table>
    printf("\n----- 等待并清理所有内核进程 -----\n");
    80206abe:	0001c517          	auipc	a0,0x1c
    80206ac2:	4ca50513          	addi	a0,a0,1226 # 80222f88 <syscall_performance_bin+0xe10>
    80206ac6:	ffffa097          	auipc	ra,0xffffa
    80206aca:	210080e7          	jalr	528(ra) # 80200cd6 <printf>
    int kernel_success_count = 0;
    80206ace:	fe042223          	sw	zero,-28(s0)
    for (int i = 0; i < kernel_count; i++) {
    80206ad2:	fe042023          	sw	zero,-32(s0)
    80206ad6:	a0a5                	j	80206b3e <test_process_creation+0x18a>
        int waited_pid = wait_proc(NULL);
    80206ad8:	4501                	li	a0,0
    80206ada:	fffff097          	auipc	ra,0xfffff
    80206ade:	2b8080e7          	jalr	696(ra) # 80205d92 <wait_proc>
    80206ae2:	87aa                	mv	a5,a0
    80206ae4:	f8f42623          	sw	a5,-116(s0)
        if (waited_pid > 0) {
    80206ae8:	f8c42783          	lw	a5,-116(s0)
    80206aec:	2781                	sext.w	a5,a5
    80206aee:	02f05863          	blez	a5,80206b1e <test_process_creation+0x16a>
            kernel_success_count++;
    80206af2:	fe442783          	lw	a5,-28(s0)
    80206af6:	2785                	addiw	a5,a5,1
    80206af8:	fef42223          	sw	a5,-28(s0)
            printf("回收内核进程 PID: %d (%d/%d)\n", waited_pid, kernel_success_count, kernel_count);
    80206afc:	fec42683          	lw	a3,-20(s0)
    80206b00:	fe442703          	lw	a4,-28(s0)
    80206b04:	f8c42783          	lw	a5,-116(s0)
    80206b08:	863a                	mv	a2,a4
    80206b0a:	85be                	mv	a1,a5
    80206b0c:	0001c517          	auipc	a0,0x1c
    80206b10:	4ac50513          	addi	a0,a0,1196 # 80222fb8 <syscall_performance_bin+0xe40>
    80206b14:	ffffa097          	auipc	ra,0xffffa
    80206b18:	1c2080e7          	jalr	450(ra) # 80200cd6 <printf>
    80206b1c:	a821                	j	80206b34 <test_process_creation+0x180>
            printf("【错误】: 等待内核进程失败，错误码: %d\n", waited_pid);
    80206b1e:	f8c42783          	lw	a5,-116(s0)
    80206b22:	85be                	mv	a1,a5
    80206b24:	0001c517          	auipc	a0,0x1c
    80206b28:	4bc50513          	addi	a0,a0,1212 # 80222fe0 <syscall_performance_bin+0xe68>
    80206b2c:	ffffa097          	auipc	ra,0xffffa
    80206b30:	1aa080e7          	jalr	426(ra) # 80200cd6 <printf>
    for (int i = 0; i < kernel_count; i++) {
    80206b34:	fe042783          	lw	a5,-32(s0)
    80206b38:	2785                	addiw	a5,a5,1
    80206b3a:	fef42023          	sw	a5,-32(s0)
    80206b3e:	fe042783          	lw	a5,-32(s0)
    80206b42:	873e                	mv	a4,a5
    80206b44:	fec42783          	lw	a5,-20(s0)
    80206b48:	2701                	sext.w	a4,a4
    80206b4a:	2781                	sext.w	a5,a5
    80206b4c:	f8f746e3          	blt	a4,a5,80206ad8 <test_process_creation+0x124>
    printf("【测试结果】: 回收 %d/%d 个内核进程\n", kernel_success_count, kernel_count);
    80206b50:	fec42703          	lw	a4,-20(s0)
    80206b54:	fe442783          	lw	a5,-28(s0)
    80206b58:	863a                	mv	a2,a4
    80206b5a:	85be                	mv	a1,a5
    80206b5c:	0001c517          	auipc	a0,0x1c
    80206b60:	4bc50513          	addi	a0,a0,1212 # 80223018 <syscall_performance_bin+0xea0>
    80206b64:	ffffa097          	auipc	ra,0xffffa
    80206b68:	172080e7          	jalr	370(ra) # 80200cd6 <printf>
    print_proc_table();
    80206b6c:	fffff097          	auipc	ra,0xfffff
    80206b70:	3b4080e7          	jalr	948(ra) # 80205f20 <print_proc_table>
    printf("\n----- 第二阶段：测试用户进程创建与管理 -----\n");
    80206b74:	0001c517          	auipc	a0,0x1c
    80206b78:	4dc50513          	addi	a0,a0,1244 # 80223050 <syscall_performance_bin+0xed8>
    80206b7c:	ffffa097          	auipc	ra,0xffffa
    80206b80:	15a080e7          	jalr	346(ra) # 80200cd6 <printf>
    int user_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
    80206b84:	06400793          	li	a5,100
    80206b88:	2781                	sext.w	a5,a5
    80206b8a:	85be                	mv	a1,a5
    80206b8c:	0001b517          	auipc	a0,0x1b
    80206b90:	58450513          	addi	a0,a0,1412 # 80222110 <simple_user_task_bin>
    80206b94:	fffff097          	auipc	ra,0xfffff
    80206b98:	ab8080e7          	jalr	-1352(ra) # 8020564c <create_user_proc>
    80206b9c:	87aa                	mv	a5,a0
    80206b9e:	faf42623          	sw	a5,-84(s0)
    if (user_pid > 0) {
    80206ba2:	fac42783          	lw	a5,-84(s0)
    80206ba6:	2781                	sext.w	a5,a5
    80206ba8:	02f05c63          	blez	a5,80206be0 <test_process_creation+0x22c>
        printf("【测试结果】: 基本用户进程创建成功，PID: %d\n", user_pid);
    80206bac:	fac42783          	lw	a5,-84(s0)
    80206bb0:	85be                	mv	a1,a5
    80206bb2:	0001c517          	auipc	a0,0x1c
    80206bb6:	4de50513          	addi	a0,a0,1246 # 80223090 <syscall_performance_bin+0xf18>
    80206bba:	ffffa097          	auipc	ra,0xffffa
    80206bbe:	11c080e7          	jalr	284(ra) # 80200cd6 <printf>
    printf("\n----- 用用户进程填满进程表 -----\n");
    80206bc2:	0001c517          	auipc	a0,0x1c
    80206bc6:	53e50513          	addi	a0,a0,1342 # 80223100 <syscall_performance_bin+0xf88>
    80206bca:	ffffa097          	auipc	ra,0xffffa
    80206bce:	10c080e7          	jalr	268(ra) # 80200cd6 <printf>
    int user_count = 1; // 已经创建了一个
    80206bd2:	4785                	li	a5,1
    80206bd4:	fcf42e23          	sw	a5,-36(s0)
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    80206bd8:	4785                	li	a5,1
    80206bda:	fcf42c23          	sw	a5,-40(s0)
    80206bde:	a841                	j	80206c6e <test_process_creation+0x2ba>
        printf("【错误】: 基本用户进程创建失败\n");
    80206be0:	0001c517          	auipc	a0,0x1c
    80206be4:	4f050513          	addi	a0,a0,1264 # 802230d0 <syscall_performance_bin+0xf58>
    80206be8:	ffffa097          	auipc	ra,0xffffa
    80206bec:	0ee080e7          	jalr	238(ra) # 80200cd6 <printf>
        return;
    80206bf0:	a615                	j	80206f14 <test_process_creation+0x560>
        int new_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
    80206bf2:	06400793          	li	a5,100
    80206bf6:	2781                	sext.w	a5,a5
    80206bf8:	85be                	mv	a1,a5
    80206bfa:	0001b517          	auipc	a0,0x1b
    80206bfe:	51650513          	addi	a0,a0,1302 # 80222110 <simple_user_task_bin>
    80206c02:	fffff097          	auipc	ra,0xfffff
    80206c06:	a4a080e7          	jalr	-1462(ra) # 8020564c <create_user_proc>
    80206c0a:	87aa                	mv	a5,a0
    80206c0c:	faf42423          	sw	a5,-88(s0)
        if (new_pid > 0) {
    80206c10:	fa842783          	lw	a5,-88(s0)
    80206c14:	2781                	sext.w	a5,a5
    80206c16:	02f05b63          	blez	a5,80206c4c <test_process_creation+0x298>
            user_count++;
    80206c1a:	fdc42783          	lw	a5,-36(s0)
    80206c1e:	2785                	addiw	a5,a5,1
    80206c20:	fcf42e23          	sw	a5,-36(s0)
            if (user_count % 5 == 0) { // 每5个进程打印一次进度
    80206c24:	fdc42783          	lw	a5,-36(s0)
    80206c28:	873e                	mv	a4,a5
    80206c2a:	4795                	li	a5,5
    80206c2c:	02f767bb          	remw	a5,a4,a5
    80206c30:	2781                	sext.w	a5,a5
    80206c32:	eb8d                	bnez	a5,80206c64 <test_process_creation+0x2b0>
                printf("已创建 %d 个用户进程...\n", user_count);
    80206c34:	fdc42783          	lw	a5,-36(s0)
    80206c38:	85be                	mv	a1,a5
    80206c3a:	0001c517          	auipc	a0,0x1c
    80206c3e:	4f650513          	addi	a0,a0,1270 # 80223130 <syscall_performance_bin+0xfb8>
    80206c42:	ffffa097          	auipc	ra,0xffffa
    80206c46:	094080e7          	jalr	148(ra) # 80200cd6 <printf>
    80206c4a:	a829                	j	80206c64 <test_process_creation+0x2b0>
            warning("process table was full at %d user processes\n", user_count);
    80206c4c:	fdc42783          	lw	a5,-36(s0)
    80206c50:	85be                	mv	a1,a5
    80206c52:	0001c517          	auipc	a0,0x1c
    80206c56:	50650513          	addi	a0,a0,1286 # 80223158 <syscall_performance_bin+0xfe0>
    80206c5a:	ffffb097          	auipc	ra,0xffffb
    80206c5e:	afc080e7          	jalr	-1284(ra) # 80201756 <warning>
            break;
    80206c62:	a829                	j	80206c7c <test_process_creation+0x2c8>
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    80206c64:	fd842783          	lw	a5,-40(s0)
    80206c68:	2785                	addiw	a5,a5,1
    80206c6a:	fcf42c23          	sw	a5,-40(s0)
    80206c6e:	fd842783          	lw	a5,-40(s0)
    80206c72:	0007871b          	sext.w	a4,a5
    80206c76:	47fd                	li	a5,31
    80206c78:	f6e7dde3          	bge	a5,a4,80206bf2 <test_process_creation+0x23e>
    printf("【测试结果】: 成功创建 %d 个用户进程 (最大限制: %d)\n", user_count, PROC);
    80206c7c:	fdc42783          	lw	a5,-36(s0)
    80206c80:	02000613          	li	a2,32
    80206c84:	85be                	mv	a1,a5
    80206c86:	0001c517          	auipc	a0,0x1c
    80206c8a:	50250513          	addi	a0,a0,1282 # 80223188 <syscall_performance_bin+0x1010>
    80206c8e:	ffffa097          	auipc	ra,0xffffa
    80206c92:	048080e7          	jalr	72(ra) # 80200cd6 <printf>
    print_proc_table();
    80206c96:	fffff097          	auipc	ra,0xfffff
    80206c9a:	28a080e7          	jalr	650(ra) # 80205f20 <print_proc_table>
    printf("\n----- 等待并清理所有用户进程 -----\n");
    80206c9e:	0001c517          	auipc	a0,0x1c
    80206ca2:	53250513          	addi	a0,a0,1330 # 802231d0 <syscall_performance_bin+0x1058>
    80206ca6:	ffffa097          	auipc	ra,0xffffa
    80206caa:	030080e7          	jalr	48(ra) # 80200cd6 <printf>
    int user_success_count = 0;
    80206cae:	fc042a23          	sw	zero,-44(s0)
    for (int i = 0; i < user_count; i++) {
    80206cb2:	fc042823          	sw	zero,-48(s0)
    80206cb6:	a895                	j	80206d2a <test_process_creation+0x376>
        int waited_pid = wait_proc(NULL);
    80206cb8:	4501                	li	a0,0
    80206cba:	fffff097          	auipc	ra,0xfffff
    80206cbe:	0d8080e7          	jalr	216(ra) # 80205d92 <wait_proc>
    80206cc2:	87aa                	mv	a5,a0
    80206cc4:	f8f42823          	sw	a5,-112(s0)
        if (waited_pid > 0) {
    80206cc8:	f9042783          	lw	a5,-112(s0)
    80206ccc:	2781                	sext.w	a5,a5
    80206cce:	02f05e63          	blez	a5,80206d0a <test_process_creation+0x356>
            user_success_count++;
    80206cd2:	fd442783          	lw	a5,-44(s0)
    80206cd6:	2785                	addiw	a5,a5,1
    80206cd8:	fcf42a23          	sw	a5,-44(s0)
            if (user_success_count % 5 == 0) { // 每5个进程打印一次进度
    80206cdc:	fd442783          	lw	a5,-44(s0)
    80206ce0:	873e                	mv	a4,a5
    80206ce2:	4795                	li	a5,5
    80206ce4:	02f767bb          	remw	a5,a4,a5
    80206ce8:	2781                	sext.w	a5,a5
    80206cea:	eb9d                	bnez	a5,80206d20 <test_process_creation+0x36c>
                printf("已回收 %d/%d 个用户进程...\n", user_success_count, user_count);
    80206cec:	fdc42703          	lw	a4,-36(s0)
    80206cf0:	fd442783          	lw	a5,-44(s0)
    80206cf4:	863a                	mv	a2,a4
    80206cf6:	85be                	mv	a1,a5
    80206cf8:	0001c517          	auipc	a0,0x1c
    80206cfc:	50850513          	addi	a0,a0,1288 # 80223200 <syscall_performance_bin+0x1088>
    80206d00:	ffffa097          	auipc	ra,0xffffa
    80206d04:	fd6080e7          	jalr	-42(ra) # 80200cd6 <printf>
    80206d08:	a821                	j	80206d20 <test_process_creation+0x36c>
            printf("【错误】: 等待用户进程失败，错误码: %d\n", waited_pid);
    80206d0a:	f9042783          	lw	a5,-112(s0)
    80206d0e:	85be                	mv	a1,a5
    80206d10:	0001c517          	auipc	a0,0x1c
    80206d14:	51850513          	addi	a0,a0,1304 # 80223228 <syscall_performance_bin+0x10b0>
    80206d18:	ffffa097          	auipc	ra,0xffffa
    80206d1c:	fbe080e7          	jalr	-66(ra) # 80200cd6 <printf>
    for (int i = 0; i < user_count; i++) {
    80206d20:	fd042783          	lw	a5,-48(s0)
    80206d24:	2785                	addiw	a5,a5,1
    80206d26:	fcf42823          	sw	a5,-48(s0)
    80206d2a:	fd042783          	lw	a5,-48(s0)
    80206d2e:	873e                	mv	a4,a5
    80206d30:	fdc42783          	lw	a5,-36(s0)
    80206d34:	2701                	sext.w	a4,a4
    80206d36:	2781                	sext.w	a5,a5
    80206d38:	f8f740e3          	blt	a4,a5,80206cb8 <test_process_creation+0x304>
    printf("【测试结果】: 回收 %d/%d 个用户进程\n", user_success_count, user_count);
    80206d3c:	fdc42703          	lw	a4,-36(s0)
    80206d40:	fd442783          	lw	a5,-44(s0)
    80206d44:	863a                	mv	a2,a4
    80206d46:	85be                	mv	a1,a5
    80206d48:	0001c517          	auipc	a0,0x1c
    80206d4c:	51850513          	addi	a0,a0,1304 # 80223260 <syscall_performance_bin+0x10e8>
    80206d50:	ffffa097          	auipc	ra,0xffffa
    80206d54:	f86080e7          	jalr	-122(ra) # 80200cd6 <printf>
    print_proc_table();
    80206d58:	fffff097          	auipc	ra,0xfffff
    80206d5c:	1c8080e7          	jalr	456(ra) # 80205f20 <print_proc_table>
    printf("\n----- 第三阶段：混合进程测试 -----\n");
    80206d60:	0001c517          	auipc	a0,0x1c
    80206d64:	53850513          	addi	a0,a0,1336 # 80223298 <syscall_performance_bin+0x1120>
    80206d68:	ffffa097          	auipc	ra,0xffffa
    80206d6c:	f6e080e7          	jalr	-146(ra) # 80200cd6 <printf>
    int mixed_kernel_count = 0;
    80206d70:	fc042623          	sw	zero,-52(s0)
    int mixed_user_count = 0;
    80206d74:	fc042423          	sw	zero,-56(s0)
    int target_count = PROC / 2;
    80206d78:	47c1                	li	a5,16
    80206d7a:	faf42223          	sw	a5,-92(s0)
    printf("创建 %d 个内核进程和 %d 个用户进程...\n", target_count, target_count);
    80206d7e:	fa442703          	lw	a4,-92(s0)
    80206d82:	fa442783          	lw	a5,-92(s0)
    80206d86:	863a                	mv	a2,a4
    80206d88:	85be                	mv	a1,a5
    80206d8a:	0001c517          	auipc	a0,0x1c
    80206d8e:	53e50513          	addi	a0,a0,1342 # 802232c8 <syscall_performance_bin+0x1150>
    80206d92:	ffffa097          	auipc	ra,0xffffa
    80206d96:	f44080e7          	jalr	-188(ra) # 80200cd6 <printf>
    for (int i = 0; i < target_count; i++) {
    80206d9a:	fc042223          	sw	zero,-60(s0)
    80206d9e:	a81d                	j	80206dd4 <test_process_creation+0x420>
        int new_pid = create_kernel_proc(simple_task);
    80206da0:	00000517          	auipc	a0,0x0
    80206da4:	be450513          	addi	a0,a0,-1052 # 80206984 <simple_task>
    80206da8:	ffffe097          	auipc	ra,0xffffe
    80206dac:	7b8080e7          	jalr	1976(ra) # 80205560 <create_kernel_proc>
    80206db0:	87aa                	mv	a5,a0
    80206db2:	faf42023          	sw	a5,-96(s0)
        if (new_pid > 0) {
    80206db6:	fa042783          	lw	a5,-96(s0)
    80206dba:	2781                	sext.w	a5,a5
    80206dbc:	02f05663          	blez	a5,80206de8 <test_process_creation+0x434>
            mixed_kernel_count++;
    80206dc0:	fcc42783          	lw	a5,-52(s0)
    80206dc4:	2785                	addiw	a5,a5,1
    80206dc6:	fcf42623          	sw	a5,-52(s0)
    for (int i = 0; i < target_count; i++) {
    80206dca:	fc442783          	lw	a5,-60(s0)
    80206dce:	2785                	addiw	a5,a5,1
    80206dd0:	fcf42223          	sw	a5,-60(s0)
    80206dd4:	fc442783          	lw	a5,-60(s0)
    80206dd8:	873e                	mv	a4,a5
    80206dda:	fa442783          	lw	a5,-92(s0)
    80206dde:	2701                	sext.w	a4,a4
    80206de0:	2781                	sext.w	a5,a5
    80206de2:	faf74fe3          	blt	a4,a5,80206da0 <test_process_creation+0x3ec>
    80206de6:	a011                	j	80206dea <test_process_creation+0x436>
            break;
    80206de8:	0001                	nop
    for (int i = 0; i < target_count; i++) {
    80206dea:	fc042023          	sw	zero,-64(s0)
    80206dee:	a83d                	j	80206e2c <test_process_creation+0x478>
        int new_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
    80206df0:	06400793          	li	a5,100
    80206df4:	2781                	sext.w	a5,a5
    80206df6:	85be                	mv	a1,a5
    80206df8:	0001b517          	auipc	a0,0x1b
    80206dfc:	31850513          	addi	a0,a0,792 # 80222110 <simple_user_task_bin>
    80206e00:	fffff097          	auipc	ra,0xfffff
    80206e04:	84c080e7          	jalr	-1972(ra) # 8020564c <create_user_proc>
    80206e08:	87aa                	mv	a5,a0
    80206e0a:	f8f42e23          	sw	a5,-100(s0)
        if (new_pid > 0) {
    80206e0e:	f9c42783          	lw	a5,-100(s0)
    80206e12:	2781                	sext.w	a5,a5
    80206e14:	02f05663          	blez	a5,80206e40 <test_process_creation+0x48c>
            mixed_user_count++;
    80206e18:	fc842783          	lw	a5,-56(s0)
    80206e1c:	2785                	addiw	a5,a5,1
    80206e1e:	fcf42423          	sw	a5,-56(s0)
    for (int i = 0; i < target_count; i++) {
    80206e22:	fc042783          	lw	a5,-64(s0)
    80206e26:	2785                	addiw	a5,a5,1
    80206e28:	fcf42023          	sw	a5,-64(s0)
    80206e2c:	fc042783          	lw	a5,-64(s0)
    80206e30:	873e                	mv	a4,a5
    80206e32:	fa442783          	lw	a5,-92(s0)
    80206e36:	2701                	sext.w	a4,a4
    80206e38:	2781                	sext.w	a5,a5
    80206e3a:	faf74be3          	blt	a4,a5,80206df0 <test_process_creation+0x43c>
    80206e3e:	a011                	j	80206e42 <test_process_creation+0x48e>
            break;
    80206e40:	0001                	nop
    printf("【混合测试结果】: 创建了 %d 个内核进程 + %d 个用户进程 = %d 个进程\n", 
    80206e42:	fcc42783          	lw	a5,-52(s0)
    80206e46:	873e                	mv	a4,a5
    80206e48:	fc842783          	lw	a5,-56(s0)
    80206e4c:	9fb9                	addw	a5,a5,a4
    80206e4e:	0007869b          	sext.w	a3,a5
    80206e52:	fc842703          	lw	a4,-56(s0)
    80206e56:	fcc42783          	lw	a5,-52(s0)
    80206e5a:	863a                	mv	a2,a4
    80206e5c:	85be                	mv	a1,a5
    80206e5e:	0001c517          	auipc	a0,0x1c
    80206e62:	4a250513          	addi	a0,a0,1186 # 80223300 <syscall_performance_bin+0x1188>
    80206e66:	ffffa097          	auipc	ra,0xffffa
    80206e6a:	e70080e7          	jalr	-400(ra) # 80200cd6 <printf>
    print_proc_table();
    80206e6e:	fffff097          	auipc	ra,0xfffff
    80206e72:	0b2080e7          	jalr	178(ra) # 80205f20 <print_proc_table>
    printf("\n----- 清理混合进程 -----\n");
    80206e76:	0001c517          	auipc	a0,0x1c
    80206e7a:	4ea50513          	addi	a0,a0,1258 # 80223360 <syscall_performance_bin+0x11e8>
    80206e7e:	ffffa097          	auipc	ra,0xffffa
    80206e82:	e58080e7          	jalr	-424(ra) # 80200cd6 <printf>
    int mixed_success_count = 0;
    80206e86:	fa042e23          	sw	zero,-68(s0)
    int total_mixed = mixed_kernel_count + mixed_user_count;
    80206e8a:	fcc42783          	lw	a5,-52(s0)
    80206e8e:	873e                	mv	a4,a5
    80206e90:	fc842783          	lw	a5,-56(s0)
    80206e94:	9fb9                	addw	a5,a5,a4
    80206e96:	f8f42c23          	sw	a5,-104(s0)
    for (int i = 0; i < total_mixed; i++) {
    80206e9a:	fa042c23          	sw	zero,-72(s0)
    80206e9e:	a805                	j	80206ece <test_process_creation+0x51a>
        int waited_pid = wait_proc(NULL);
    80206ea0:	4501                	li	a0,0
    80206ea2:	fffff097          	auipc	ra,0xfffff
    80206ea6:	ef0080e7          	jalr	-272(ra) # 80205d92 <wait_proc>
    80206eaa:	87aa                	mv	a5,a0
    80206eac:	f8f42a23          	sw	a5,-108(s0)
        if (waited_pid > 0) {
    80206eb0:	f9442783          	lw	a5,-108(s0)
    80206eb4:	2781                	sext.w	a5,a5
    80206eb6:	00f05763          	blez	a5,80206ec4 <test_process_creation+0x510>
            mixed_success_count++;
    80206eba:	fbc42783          	lw	a5,-68(s0)
    80206ebe:	2785                	addiw	a5,a5,1
    80206ec0:	faf42e23          	sw	a5,-68(s0)
    for (int i = 0; i < total_mixed; i++) {
    80206ec4:	fb842783          	lw	a5,-72(s0)
    80206ec8:	2785                	addiw	a5,a5,1
    80206eca:	faf42c23          	sw	a5,-72(s0)
    80206ece:	fb842783          	lw	a5,-72(s0)
    80206ed2:	873e                	mv	a4,a5
    80206ed4:	f9842783          	lw	a5,-104(s0)
    80206ed8:	2701                	sext.w	a4,a4
    80206eda:	2781                	sext.w	a5,a5
    80206edc:	fcf742e3          	blt	a4,a5,80206ea0 <test_process_creation+0x4ec>
    printf("【混合测试结果】: 回收 %d/%d 个混合进程\n", mixed_success_count, total_mixed);
    80206ee0:	f9842703          	lw	a4,-104(s0)
    80206ee4:	fbc42783          	lw	a5,-68(s0)
    80206ee8:	863a                	mv	a2,a4
    80206eea:	85be                	mv	a1,a5
    80206eec:	0001c517          	auipc	a0,0x1c
    80206ef0:	49c50513          	addi	a0,a0,1180 # 80223388 <syscall_performance_bin+0x1210>
    80206ef4:	ffffa097          	auipc	ra,0xffffa
    80206ef8:	de2080e7          	jalr	-542(ra) # 80200cd6 <printf>
    print_proc_table();
    80206efc:	fffff097          	auipc	ra,0xfffff
    80206f00:	024080e7          	jalr	36(ra) # 80205f20 <print_proc_table>
    printf("===== 测试结束: 进程创建与管理测试 =====\n");
    80206f04:	0001c517          	auipc	a0,0x1c
    80206f08:	4bc50513          	addi	a0,a0,1212 # 802233c0 <syscall_performance_bin+0x1248>
    80206f0c:	ffffa097          	auipc	ra,0xffffa
    80206f10:	dca080e7          	jalr	-566(ra) # 80200cd6 <printf>
}
    80206f14:	70e6                	ld	ra,120(sp)
    80206f16:	7446                	ld	s0,112(sp)
    80206f18:	6109                	addi	sp,sp,128
    80206f1a:	8082                	ret

0000000080206f1c <test_user_fork>:
void test_user_fork(void) {
    80206f1c:	1101                	addi	sp,sp,-32
    80206f1e:	ec06                	sd	ra,24(sp)
    80206f20:	e822                	sd	s0,16(sp)
    80206f22:	1000                	addi	s0,sp,32
    printf("===== 测试开始: 用户进程Fork测试 =====\n");
    80206f24:	0001c517          	auipc	a0,0x1c
    80206f28:	4d450513          	addi	a0,a0,1236 # 802233f8 <syscall_performance_bin+0x1280>
    80206f2c:	ffffa097          	auipc	ra,0xffffa
    80206f30:	daa080e7          	jalr	-598(ra) # 80200cd6 <printf>
    printf("\n----- 创建fork测试进程 -----\n");
    80206f34:	0001c517          	auipc	a0,0x1c
    80206f38:	4fc50513          	addi	a0,a0,1276 # 80223430 <syscall_performance_bin+0x12b8>
    80206f3c:	ffffa097          	auipc	ra,0xffffa
    80206f40:	d9a080e7          	jalr	-614(ra) # 80200cd6 <printf>
    int fork_test_pid = create_user_proc(fork_user_test_bin, fork_user_test_bin_len);
    80206f44:	6785                	lui	a5,0x1
    80206f46:	8e878793          	addi	a5,a5,-1816 # 8e8 <_entry-0x801ff718>
    80206f4a:	2781                	sext.w	a5,a5
    80206f4c:	85be                	mv	a1,a5
    80206f4e:	0001a517          	auipc	a0,0x1a
    80206f52:	45250513          	addi	a0,a0,1106 # 802213a0 <fork_user_test_bin>
    80206f56:	ffffe097          	auipc	ra,0xffffe
    80206f5a:	6f6080e7          	jalr	1782(ra) # 8020564c <create_user_proc>
    80206f5e:	87aa                	mv	a5,a0
    80206f60:	fef42623          	sw	a5,-20(s0)
    if (fork_test_pid < 0) {
    80206f64:	fec42783          	lw	a5,-20(s0)
    80206f68:	2781                	sext.w	a5,a5
    80206f6a:	0007db63          	bgez	a5,80206f80 <test_user_fork+0x64>
        printf("【错误】: 创建fork测试进程失败\n");
    80206f6e:	0001c517          	auipc	a0,0x1c
    80206f72:	4ea50513          	addi	a0,a0,1258 # 80223458 <syscall_performance_bin+0x12e0>
    80206f76:	ffffa097          	auipc	ra,0xffffa
    80206f7a:	d60080e7          	jalr	-672(ra) # 80200cd6 <printf>
    80206f7e:	a865                	j	80207036 <test_user_fork+0x11a>
    printf("【测试结果】: 创建fork测试进程成功，PID: %d\n", fork_test_pid);
    80206f80:	fec42783          	lw	a5,-20(s0)
    80206f84:	85be                	mv	a1,a5
    80206f86:	0001c517          	auipc	a0,0x1c
    80206f8a:	50250513          	addi	a0,a0,1282 # 80223488 <syscall_performance_bin+0x1310>
    80206f8e:	ffffa097          	auipc	ra,0xffffa
    80206f92:	d48080e7          	jalr	-696(ra) # 80200cd6 <printf>
    printf("\n----- 等待fork测试进程完成 -----\n");
    80206f96:	0001c517          	auipc	a0,0x1c
    80206f9a:	53250513          	addi	a0,a0,1330 # 802234c8 <syscall_performance_bin+0x1350>
    80206f9e:	ffffa097          	auipc	ra,0xffffa
    80206fa2:	d38080e7          	jalr	-712(ra) # 80200cd6 <printf>
    int waited_pid = wait_proc(&status);
    80206fa6:	fe440793          	addi	a5,s0,-28
    80206faa:	853e                	mv	a0,a5
    80206fac:	fffff097          	auipc	ra,0xfffff
    80206fb0:	de6080e7          	jalr	-538(ra) # 80205d92 <wait_proc>
    80206fb4:	87aa                	mv	a5,a0
    80206fb6:	fef42423          	sw	a5,-24(s0)
    if (waited_pid == fork_test_pid) {
    80206fba:	fe842783          	lw	a5,-24(s0)
    80206fbe:	873e                	mv	a4,a5
    80206fc0:	fec42783          	lw	a5,-20(s0)
    80206fc4:	2701                	sext.w	a4,a4
    80206fc6:	2781                	sext.w	a5,a5
    80206fc8:	02f71963          	bne	a4,a5,80206ffa <test_user_fork+0xde>
        printf("【测试结果】: fork测试进程(PID: %d)完成，状态码: %d\n", fork_test_pid, status);
    80206fcc:	fe442703          	lw	a4,-28(s0)
    80206fd0:	fec42783          	lw	a5,-20(s0)
    80206fd4:	863a                	mv	a2,a4
    80206fd6:	85be                	mv	a1,a5
    80206fd8:	0001c517          	auipc	a0,0x1c
    80206fdc:	52050513          	addi	a0,a0,1312 # 802234f8 <syscall_performance_bin+0x1380>
    80206fe0:	ffffa097          	auipc	ra,0xffffa
    80206fe4:	cf6080e7          	jalr	-778(ra) # 80200cd6 <printf>
        printf("✓ Fork测试: 通过\n");
    80206fe8:	0001c517          	auipc	a0,0x1c
    80206fec:	55850513          	addi	a0,a0,1368 # 80223540 <syscall_performance_bin+0x13c8>
    80206ff0:	ffffa097          	auipc	ra,0xffffa
    80206ff4:	ce6080e7          	jalr	-794(ra) # 80200cd6 <printf>
    80206ff8:	a03d                	j	80207026 <test_user_fork+0x10a>
        printf("【错误】: 等待fork测试进程时出错，等待到PID: %d，期望PID: %d\n", waited_pid, fork_test_pid);
    80206ffa:	fec42703          	lw	a4,-20(s0)
    80206ffe:	fe842783          	lw	a5,-24(s0)
    80207002:	863a                	mv	a2,a4
    80207004:	85be                	mv	a1,a5
    80207006:	0001c517          	auipc	a0,0x1c
    8020700a:	55250513          	addi	a0,a0,1362 # 80223558 <syscall_performance_bin+0x13e0>
    8020700e:	ffffa097          	auipc	ra,0xffffa
    80207012:	cc8080e7          	jalr	-824(ra) # 80200cd6 <printf>
        printf("✗ Fork测试: 失败\n");
    80207016:	0001c517          	auipc	a0,0x1c
    8020701a:	59a50513          	addi	a0,a0,1434 # 802235b0 <syscall_performance_bin+0x1438>
    8020701e:	ffffa097          	auipc	ra,0xffffa
    80207022:	cb8080e7          	jalr	-840(ra) # 80200cd6 <printf>
    printf("===== 测试结束: 用户进程Fork测试 =====\n");
    80207026:	0001c517          	auipc	a0,0x1c
    8020702a:	5a250513          	addi	a0,a0,1442 # 802235c8 <syscall_performance_bin+0x1450>
    8020702e:	ffffa097          	auipc	ra,0xffffa
    80207032:	ca8080e7          	jalr	-856(ra) # 80200cd6 <printf>
}
    80207036:	60e2                	ld	ra,24(sp)
    80207038:	6442                	ld	s0,16(sp)
    8020703a:	6105                	addi	sp,sp,32
    8020703c:	8082                	ret

000000008020703e <cpu_intensive_task>:
void cpu_intensive_task(void) {
    8020703e:	7139                	addi	sp,sp,-64
    80207040:	fc06                	sd	ra,56(sp)
    80207042:	f822                	sd	s0,48(sp)
    80207044:	0080                	addi	s0,sp,64
    int pid = myproc()->pid;
    80207046:	ffffe097          	auipc	ra,0xffffe
    8020704a:	eda080e7          	jalr	-294(ra) # 80204f20 <myproc>
    8020704e:	87aa                	mv	a5,a0
    80207050:	43dc                	lw	a5,4(a5)
    80207052:	fcf42e23          	sw	a5,-36(s0)
    printf("[进程 %d] 开始CPU密集计算\n", pid);
    80207056:	fdc42783          	lw	a5,-36(s0)
    8020705a:	85be                	mv	a1,a5
    8020705c:	0001c517          	auipc	a0,0x1c
    80207060:	5a450513          	addi	a0,a0,1444 # 80223600 <syscall_performance_bin+0x1488>
    80207064:	ffffa097          	auipc	ra,0xffffa
    80207068:	c72080e7          	jalr	-910(ra) # 80200cd6 <printf>
    uint64 sum = 0;
    8020706c:	fe043423          	sd	zero,-24(s0)
    const uint64 TOTAL_ITERATIONS = 100000000;
    80207070:	05f5e7b7          	lui	a5,0x5f5e
    80207074:	10078793          	addi	a5,a5,256 # 5f5e100 <_entry-0x7a2a1f00>
    80207078:	fcf43823          	sd	a5,-48(s0)
    const uint64 REPORT_INTERVAL = TOTAL_ITERATIONS / 100;  // 每完成1%报告一次
    8020707c:	fd043703          	ld	a4,-48(s0)
    80207080:	06400793          	li	a5,100
    80207084:	02f757b3          	divu	a5,a4,a5
    80207088:	fcf43423          	sd	a5,-56(s0)
    for (uint64 i = 0; i < TOTAL_ITERATIONS; i++) {
    8020708c:	fe043023          	sd	zero,-32(s0)
    80207090:	a8b5                	j	8020710c <cpu_intensive_task+0xce>
        sum += (i * i) % 1000000007;  // 添加乘法和取模运算
    80207092:	fe043783          	ld	a5,-32(s0)
    80207096:	02f78733          	mul	a4,a5,a5
    8020709a:	3b9ad7b7          	lui	a5,0x3b9ad
    8020709e:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <_entry-0x448535f9>
    802070a2:	02f777b3          	remu	a5,a4,a5
    802070a6:	fe843703          	ld	a4,-24(s0)
    802070aa:	97ba                	add	a5,a5,a4
    802070ac:	fef43423          	sd	a5,-24(s0)
        if (i % REPORT_INTERVAL == 0) {
    802070b0:	fe043703          	ld	a4,-32(s0)
    802070b4:	fc843783          	ld	a5,-56(s0)
    802070b8:	02f777b3          	remu	a5,a4,a5
    802070bc:	e3b9                	bnez	a5,80207102 <cpu_intensive_task+0xc4>
            uint64 percent = (i * 100) / TOTAL_ITERATIONS;
    802070be:	fe043703          	ld	a4,-32(s0)
    802070c2:	06400793          	li	a5,100
    802070c6:	02f70733          	mul	a4,a4,a5
    802070ca:	fd043783          	ld	a5,-48(s0)
    802070ce:	02f757b3          	divu	a5,a4,a5
    802070d2:	fcf43023          	sd	a5,-64(s0)
            printf("[进程 %d] 完成度: %lu%%，当前sum=%lu\n", 
    802070d6:	fdc42783          	lw	a5,-36(s0)
    802070da:	fe843683          	ld	a3,-24(s0)
    802070de:	fc043603          	ld	a2,-64(s0)
    802070e2:	85be                	mv	a1,a5
    802070e4:	0001c517          	auipc	a0,0x1c
    802070e8:	54450513          	addi	a0,a0,1348 # 80223628 <syscall_performance_bin+0x14b0>
    802070ec:	ffffa097          	auipc	ra,0xffffa
    802070f0:	bea080e7          	jalr	-1046(ra) # 80200cd6 <printf>
            if (i > 0) {
    802070f4:	fe043783          	ld	a5,-32(s0)
    802070f8:	c789                	beqz	a5,80207102 <cpu_intensive_task+0xc4>
                yield();
    802070fa:	fffff097          	auipc	ra,0xfffff
    802070fe:	9c0080e7          	jalr	-1600(ra) # 80205aba <yield>
    for (uint64 i = 0; i < TOTAL_ITERATIONS; i++) {
    80207102:	fe043783          	ld	a5,-32(s0)
    80207106:	0785                	addi	a5,a5,1
    80207108:	fef43023          	sd	a5,-32(s0)
    8020710c:	fe043703          	ld	a4,-32(s0)
    80207110:	fd043783          	ld	a5,-48(s0)
    80207114:	f6f76fe3          	bltu	a4,a5,80207092 <cpu_intensive_task+0x54>
    printf("[进程 %d] 计算完成，最终sum=%lu\n", pid, sum);
    80207118:	fdc42783          	lw	a5,-36(s0)
    8020711c:	fe843603          	ld	a2,-24(s0)
    80207120:	85be                	mv	a1,a5
    80207122:	0001c517          	auipc	a0,0x1c
    80207126:	53650513          	addi	a0,a0,1334 # 80223658 <syscall_performance_bin+0x14e0>
    8020712a:	ffffa097          	auipc	ra,0xffffa
    8020712e:	bac080e7          	jalr	-1108(ra) # 80200cd6 <printf>
    exit_proc(0);
    80207132:	4501                	li	a0,0
    80207134:	fffff097          	auipc	ra,0xfffff
    80207138:	b94080e7          	jalr	-1132(ra) # 80205cc8 <exit_proc>
}
    8020713c:	0001                	nop
    8020713e:	70e2                	ld	ra,56(sp)
    80207140:	7442                	ld	s0,48(sp)
    80207142:	6121                	addi	sp,sp,64
    80207144:	8082                	ret

0000000080207146 <test_scheduler>:
void test_scheduler(void) {
    80207146:	715d                	addi	sp,sp,-80
    80207148:	e486                	sd	ra,72(sp)
    8020714a:	e0a2                	sd	s0,64(sp)
    8020714c:	0880                	addi	s0,sp,80
    printf("\n===== 测试开始: 调度器公平性测试 =====\n");
    8020714e:	0001c517          	auipc	a0,0x1c
    80207152:	53a50513          	addi	a0,a0,1338 # 80223688 <syscall_performance_bin+0x1510>
    80207156:	ffffa097          	auipc	ra,0xffffa
    8020715a:	b80080e7          	jalr	-1152(ra) # 80200cd6 <printf>
    for (int i = 0; i < 3; i++) {
    8020715e:	fe042623          	sw	zero,-20(s0)
    80207162:	a8a5                	j	802071da <test_scheduler+0x94>
        pids[i] = create_kernel_proc(cpu_intensive_task);
    80207164:	00000517          	auipc	a0,0x0
    80207168:	eda50513          	addi	a0,a0,-294 # 8020703e <cpu_intensive_task>
    8020716c:	ffffe097          	auipc	ra,0xffffe
    80207170:	3f4080e7          	jalr	1012(ra) # 80205560 <create_kernel_proc>
    80207174:	87aa                	mv	a5,a0
    80207176:	873e                	mv	a4,a5
    80207178:	fec42783          	lw	a5,-20(s0)
    8020717c:	078a                	slli	a5,a5,0x2
    8020717e:	17c1                	addi	a5,a5,-16
    80207180:	97a2                	add	a5,a5,s0
    80207182:	fce7a823          	sw	a4,-48(a5)
        if (pids[i] < 0) {
    80207186:	fec42783          	lw	a5,-20(s0)
    8020718a:	078a                	slli	a5,a5,0x2
    8020718c:	17c1                	addi	a5,a5,-16
    8020718e:	97a2                	add	a5,a5,s0
    80207190:	fd07a783          	lw	a5,-48(a5)
    80207194:	0007de63          	bgez	a5,802071b0 <test_scheduler+0x6a>
            printf("【错误】创建进程 %d 失败\n", i);
    80207198:	fec42783          	lw	a5,-20(s0)
    8020719c:	85be                	mv	a1,a5
    8020719e:	0001c517          	auipc	a0,0x1c
    802071a2:	52250513          	addi	a0,a0,1314 # 802236c0 <syscall_performance_bin+0x1548>
    802071a6:	ffffa097          	auipc	ra,0xffffa
    802071aa:	b30080e7          	jalr	-1232(ra) # 80200cd6 <printf>
    802071ae:	a239                	j	802072bc <test_scheduler+0x176>
        printf("创建进程成功，PID: %d\n", pids[i]);
    802071b0:	fec42783          	lw	a5,-20(s0)
    802071b4:	078a                	slli	a5,a5,0x2
    802071b6:	17c1                	addi	a5,a5,-16
    802071b8:	97a2                	add	a5,a5,s0
    802071ba:	fd07a783          	lw	a5,-48(a5)
    802071be:	85be                	mv	a1,a5
    802071c0:	0001c517          	auipc	a0,0x1c
    802071c4:	52850513          	addi	a0,a0,1320 # 802236e8 <syscall_performance_bin+0x1570>
    802071c8:	ffffa097          	auipc	ra,0xffffa
    802071cc:	b0e080e7          	jalr	-1266(ra) # 80200cd6 <printf>
    for (int i = 0; i < 3; i++) {
    802071d0:	fec42783          	lw	a5,-20(s0)
    802071d4:	2785                	addiw	a5,a5,1
    802071d6:	fef42623          	sw	a5,-20(s0)
    802071da:	fec42783          	lw	a5,-20(s0)
    802071de:	0007871b          	sext.w	a4,a5
    802071e2:	4789                	li	a5,2
    802071e4:	f8e7d0e3          	bge	a5,a4,80207164 <test_scheduler+0x1e>
    uint64 start_time = get_time();
    802071e8:	fffff097          	auipc	ra,0xfffff
    802071ec:	218080e7          	jalr	536(ra) # 80206400 <get_time>
    802071f0:	fea43023          	sd	a0,-32(s0)
    int completed = 0;
    802071f4:	fe042423          	sw	zero,-24(s0)
    while (completed < 3) {
    802071f8:	a0a9                	j	80207242 <test_scheduler+0xfc>
        int pid = wait_proc(&status);
    802071fa:	fbc40793          	addi	a5,s0,-68
    802071fe:	853e                	mv	a0,a5
    80207200:	fffff097          	auipc	ra,0xfffff
    80207204:	b92080e7          	jalr	-1134(ra) # 80205d92 <wait_proc>
    80207208:	87aa                	mv	a5,a0
    8020720a:	fcf42623          	sw	a5,-52(s0)
        if (pid > 0) {
    8020720e:	fcc42783          	lw	a5,-52(s0)
    80207212:	2781                	sext.w	a5,a5
    80207214:	02f05763          	blez	a5,80207242 <test_scheduler+0xfc>
            completed++;
    80207218:	fe842783          	lw	a5,-24(s0)
    8020721c:	2785                	addiw	a5,a5,1
    8020721e:	fef42423          	sw	a5,-24(s0)
            printf("进程 %d 已完成，退出状态: %d (%d/3)\n", 
    80207222:	fbc42703          	lw	a4,-68(s0)
    80207226:	fe842683          	lw	a3,-24(s0)
    8020722a:	fcc42783          	lw	a5,-52(s0)
    8020722e:	863a                	mv	a2,a4
    80207230:	85be                	mv	a1,a5
    80207232:	0001c517          	auipc	a0,0x1c
    80207236:	4d650513          	addi	a0,a0,1238 # 80223708 <syscall_performance_bin+0x1590>
    8020723a:	ffffa097          	auipc	ra,0xffffa
    8020723e:	a9c080e7          	jalr	-1380(ra) # 80200cd6 <printf>
    while (completed < 3) {
    80207242:	fe842783          	lw	a5,-24(s0)
    80207246:	0007871b          	sext.w	a4,a5
    8020724a:	4789                	li	a5,2
    8020724c:	fae7d7e3          	bge	a5,a4,802071fa <test_scheduler+0xb4>
    uint64 end_time = get_time();
    80207250:	fffff097          	auipc	ra,0xfffff
    80207254:	1b0080e7          	jalr	432(ra) # 80206400 <get_time>
    80207258:	fca43c23          	sd	a0,-40(s0)
    uint64 total_cycles = end_time - start_time;
    8020725c:	fd843703          	ld	a4,-40(s0)
    80207260:	fe043783          	ld	a5,-32(s0)
    80207264:	40f707b3          	sub	a5,a4,a5
    80207268:	fcf43823          	sd	a5,-48(s0)
    printf("\n----- 测试结果 -----\n");
    8020726c:	0001c517          	auipc	a0,0x1c
    80207270:	4cc50513          	addi	a0,a0,1228 # 80223738 <syscall_performance_bin+0x15c0>
    80207274:	ffffa097          	auipc	ra,0xffffa
    80207278:	a62080e7          	jalr	-1438(ra) # 80200cd6 <printf>
    printf("总执行时间: %lu cycles\n", total_cycles);
    8020727c:	fd043583          	ld	a1,-48(s0)
    80207280:	0001c517          	auipc	a0,0x1c
    80207284:	4d850513          	addi	a0,a0,1240 # 80223758 <syscall_performance_bin+0x15e0>
    80207288:	ffffa097          	auipc	ra,0xffffa
    8020728c:	a4e080e7          	jalr	-1458(ra) # 80200cd6 <printf>
    printf("平均每个进程执行时间: %lu cycles\n", total_cycles / 3);
    80207290:	fd043703          	ld	a4,-48(s0)
    80207294:	478d                	li	a5,3
    80207296:	02f757b3          	divu	a5,a4,a5
    8020729a:	85be                	mv	a1,a5
    8020729c:	0001c517          	auipc	a0,0x1c
    802072a0:	4dc50513          	addi	a0,a0,1244 # 80223778 <syscall_performance_bin+0x1600>
    802072a4:	ffffa097          	auipc	ra,0xffffa
    802072a8:	a32080e7          	jalr	-1486(ra) # 80200cd6 <printf>
    printf("===== 调度器测试完成 =====\n");
    802072ac:	0001c517          	auipc	a0,0x1c
    802072b0:	4fc50513          	addi	a0,a0,1276 # 802237a8 <syscall_performance_bin+0x1630>
    802072b4:	ffffa097          	auipc	ra,0xffffa
    802072b8:	a22080e7          	jalr	-1502(ra) # 80200cd6 <printf>
}
    802072bc:	60a6                	ld	ra,72(sp)
    802072be:	6406                	ld	s0,64(sp)
    802072c0:	6161                	addi	sp,sp,80
    802072c2:	8082                	ret

00000000802072c4 <shared_buffer_init>:
void shared_buffer_init() {
    802072c4:	1141                	addi	sp,sp,-16
    802072c6:	e422                	sd	s0,8(sp)
    802072c8:	0800                	addi	s0,sp,16
    proc_buffer = 0;
    802072ca:	0001f797          	auipc	a5,0x1f
    802072ce:	4ce78793          	addi	a5,a5,1230 # 80226798 <proc_buffer>
    802072d2:	0007a023          	sw	zero,0(a5)
    proc_produced = 0;
    802072d6:	0001f797          	auipc	a5,0x1f
    802072da:	4c678793          	addi	a5,a5,1222 # 8022679c <proc_produced>
    802072de:	0007a023          	sw	zero,0(a5)
}
    802072e2:	0001                	nop
    802072e4:	6422                	ld	s0,8(sp)
    802072e6:	0141                	addi	sp,sp,16
    802072e8:	8082                	ret

00000000802072ea <producer_task>:
void producer_task(void) {
    802072ea:	7179                	addi	sp,sp,-48
    802072ec:	f406                	sd	ra,40(sp)
    802072ee:	f022                	sd	s0,32(sp)
    802072f0:	1800                	addi	s0,sp,48
	int pid = myproc()->pid;
    802072f2:	ffffe097          	auipc	ra,0xffffe
    802072f6:	c2e080e7          	jalr	-978(ra) # 80204f20 <myproc>
    802072fa:	87aa                	mv	a5,a0
    802072fc:	43dc                	lw	a5,4(a5)
    802072fe:	fcf42e23          	sw	a5,-36(s0)
    uint64 sum = 0;
    80207302:	fe043423          	sd	zero,-24(s0)
    const uint64 ITERATIONS = 10000000;  // 一千万次循环
    80207306:	009897b7          	lui	a5,0x989
    8020730a:	68078793          	addi	a5,a5,1664 # 989680 <_entry-0x7f876980>
    8020730e:	fcf43823          	sd	a5,-48(s0)
    
    for(uint64 i = 0; i < ITERATIONS; i++) {
    80207312:	fe043023          	sd	zero,-32(s0)
    80207316:	a0bd                	j	80207384 <producer_task+0x9a>
        sum += (i * i) % 1000000007;  // 复杂计算
    80207318:	fe043783          	ld	a5,-32(s0)
    8020731c:	02f78733          	mul	a4,a5,a5
    80207320:	3b9ad7b7          	lui	a5,0x3b9ad
    80207324:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <_entry-0x448535f9>
    80207328:	02f777b3          	remu	a5,a4,a5
    8020732c:	fe843703          	ld	a4,-24(s0)
    80207330:	97ba                	add	a5,a5,a4
    80207332:	fef43423          	sd	a5,-24(s0)
        if(i % (ITERATIONS/10) == 0) {
    80207336:	fd043703          	ld	a4,-48(s0)
    8020733a:	47a9                	li	a5,10
    8020733c:	02f757b3          	divu	a5,a4,a5
    80207340:	fe043703          	ld	a4,-32(s0)
    80207344:	02f777b3          	remu	a5,a4,a5
    80207348:	eb8d                	bnez	a5,8020737a <producer_task+0x90>
            printf("[Producer %d] 计算进度: %d%%\n", 
                   pid, (int)(i * 100 / ITERATIONS));
    8020734a:	fe043703          	ld	a4,-32(s0)
    8020734e:	06400793          	li	a5,100
    80207352:	02f70733          	mul	a4,a4,a5
    80207356:	fd043783          	ld	a5,-48(s0)
    8020735a:	02f757b3          	divu	a5,a4,a5
            printf("[Producer %d] 计算进度: %d%%\n", 
    8020735e:	0007871b          	sext.w	a4,a5
    80207362:	fdc42783          	lw	a5,-36(s0)
    80207366:	863a                	mv	a2,a4
    80207368:	85be                	mv	a1,a5
    8020736a:	0001c517          	auipc	a0,0x1c
    8020736e:	46650513          	addi	a0,a0,1126 # 802237d0 <syscall_performance_bin+0x1658>
    80207372:	ffffa097          	auipc	ra,0xffffa
    80207376:	964080e7          	jalr	-1692(ra) # 80200cd6 <printf>
    for(uint64 i = 0; i < ITERATIONS; i++) {
    8020737a:	fe043783          	ld	a5,-32(s0)
    8020737e:	0785                	addi	a5,a5,1
    80207380:	fef43023          	sd	a5,-32(s0)
    80207384:	fe043703          	ld	a4,-32(s0)
    80207388:	fd043783          	ld	a5,-48(s0)
    8020738c:	f8f766e3          	bltu	a4,a5,80207318 <producer_task+0x2e>
        }
    }
    proc_buffer = 42;
    80207390:	0001f797          	auipc	a5,0x1f
    80207394:	40878793          	addi	a5,a5,1032 # 80226798 <proc_buffer>
    80207398:	02a00713          	li	a4,42
    8020739c:	c398                	sw	a4,0(a5)
    proc_produced = 1;
    8020739e:	0001f797          	auipc	a5,0x1f
    802073a2:	3fe78793          	addi	a5,a5,1022 # 8022679c <proc_produced>
    802073a6:	4705                	li	a4,1
    802073a8:	c398                	sw	a4,0(a5)
    wakeup(&proc_produced); // 唤醒消费者
    802073aa:	0001f517          	auipc	a0,0x1f
    802073ae:	3f250513          	addi	a0,a0,1010 # 8022679c <proc_produced>
    802073b2:	fffff097          	auipc	ra,0xfffff
    802073b6:	846080e7          	jalr	-1978(ra) # 80205bf8 <wakeup>
    printf("Producer: produced value %d\n", proc_buffer);
    802073ba:	0001f797          	auipc	a5,0x1f
    802073be:	3de78793          	addi	a5,a5,990 # 80226798 <proc_buffer>
    802073c2:	439c                	lw	a5,0(a5)
    802073c4:	85be                	mv	a1,a5
    802073c6:	0001c517          	auipc	a0,0x1c
    802073ca:	43250513          	addi	a0,a0,1074 # 802237f8 <syscall_performance_bin+0x1680>
    802073ce:	ffffa097          	auipc	ra,0xffffa
    802073d2:	908080e7          	jalr	-1784(ra) # 80200cd6 <printf>
    exit_proc(0);
    802073d6:	4501                	li	a0,0
    802073d8:	fffff097          	auipc	ra,0xfffff
    802073dc:	8f0080e7          	jalr	-1808(ra) # 80205cc8 <exit_proc>
}
    802073e0:	0001                	nop
    802073e2:	70a2                	ld	ra,40(sp)
    802073e4:	7402                	ld	s0,32(sp)
    802073e6:	6145                	addi	sp,sp,48
    802073e8:	8082                	ret

00000000802073ea <consumer_task>:

void consumer_task(void) {
    802073ea:	1141                	addi	sp,sp,-16
    802073ec:	e406                	sd	ra,8(sp)
    802073ee:	e022                	sd	s0,0(sp)
    802073f0:	0800                	addi	s0,sp,16
    while (!proc_produced) {
    802073f2:	a00d                	j	80207414 <consumer_task+0x2a>
		printf("wait for producer\n");
    802073f4:	0001c517          	auipc	a0,0x1c
    802073f8:	42450513          	addi	a0,a0,1060 # 80223818 <syscall_performance_bin+0x16a0>
    802073fc:	ffffa097          	auipc	ra,0xffffa
    80207400:	8da080e7          	jalr	-1830(ra) # 80200cd6 <printf>
        sleep(&proc_produced); // 等待生产者
    80207404:	0001f517          	auipc	a0,0x1f
    80207408:	39850513          	addi	a0,a0,920 # 8022679c <proc_produced>
    8020740c:	ffffe097          	auipc	ra,0xffffe
    80207410:	754080e7          	jalr	1876(ra) # 80205b60 <sleep>
    while (!proc_produced) {
    80207414:	0001f797          	auipc	a5,0x1f
    80207418:	38878793          	addi	a5,a5,904 # 8022679c <proc_produced>
    8020741c:	439c                	lw	a5,0(a5)
    8020741e:	dbf9                	beqz	a5,802073f4 <consumer_task+0xa>
    }
    printf("Consumer: consumed value %d\n", proc_buffer);
    80207420:	0001f797          	auipc	a5,0x1f
    80207424:	37878793          	addi	a5,a5,888 # 80226798 <proc_buffer>
    80207428:	439c                	lw	a5,0(a5)
    8020742a:	85be                	mv	a1,a5
    8020742c:	0001c517          	auipc	a0,0x1c
    80207430:	40450513          	addi	a0,a0,1028 # 80223830 <syscall_performance_bin+0x16b8>
    80207434:	ffffa097          	auipc	ra,0xffffa
    80207438:	8a2080e7          	jalr	-1886(ra) # 80200cd6 <printf>
    exit_proc(0);
    8020743c:	4501                	li	a0,0
    8020743e:	fffff097          	auipc	ra,0xfffff
    80207442:	88a080e7          	jalr	-1910(ra) # 80205cc8 <exit_proc>
}
    80207446:	0001                	nop
    80207448:	60a2                	ld	ra,8(sp)
    8020744a:	6402                	ld	s0,0(sp)
    8020744c:	0141                	addi	sp,sp,16
    8020744e:	8082                	ret

0000000080207450 <test_synchronization>:
void test_synchronization(void) {
    80207450:	1141                	addi	sp,sp,-16
    80207452:	e406                	sd	ra,8(sp)
    80207454:	e022                	sd	s0,0(sp)
    80207456:	0800                	addi	s0,sp,16
    printf("===== 测试开始: 同步机制测试 =====\n");
    80207458:	0001c517          	auipc	a0,0x1c
    8020745c:	3f850513          	addi	a0,a0,1016 # 80223850 <syscall_performance_bin+0x16d8>
    80207460:	ffffa097          	auipc	ra,0xffffa
    80207464:	876080e7          	jalr	-1930(ra) # 80200cd6 <printf>

    // 初始化共享缓冲区
    shared_buffer_init();
    80207468:	00000097          	auipc	ra,0x0
    8020746c:	e5c080e7          	jalr	-420(ra) # 802072c4 <shared_buffer_init>

    // 创建生产者和消费者进程
    create_kernel_proc(producer_task);
    80207470:	00000517          	auipc	a0,0x0
    80207474:	e7a50513          	addi	a0,a0,-390 # 802072ea <producer_task>
    80207478:	ffffe097          	auipc	ra,0xffffe
    8020747c:	0e8080e7          	jalr	232(ra) # 80205560 <create_kernel_proc>
    create_kernel_proc(consumer_task);
    80207480:	00000517          	auipc	a0,0x0
    80207484:	f6a50513          	addi	a0,a0,-150 # 802073ea <consumer_task>
    80207488:	ffffe097          	auipc	ra,0xffffe
    8020748c:	0d8080e7          	jalr	216(ra) # 80205560 <create_kernel_proc>

    // 等待两个进程完成
    wait_proc(NULL);
    80207490:	4501                	li	a0,0
    80207492:	fffff097          	auipc	ra,0xfffff
    80207496:	900080e7          	jalr	-1792(ra) # 80205d92 <wait_proc>
    wait_proc(NULL);
    8020749a:	4501                	li	a0,0
    8020749c:	fffff097          	auipc	ra,0xfffff
    802074a0:	8f6080e7          	jalr	-1802(ra) # 80205d92 <wait_proc>

    printf("===== 测试结束 =====\n");
    802074a4:	0001c517          	auipc	a0,0x1c
    802074a8:	3dc50513          	addi	a0,a0,988 # 80223880 <syscall_performance_bin+0x1708>
    802074ac:	ffffa097          	auipc	ra,0xffffa
    802074b0:	82a080e7          	jalr	-2006(ra) # 80200cd6 <printf>
}
    802074b4:	0001                	nop
    802074b6:	60a2                	ld	ra,8(sp)
    802074b8:	6402                	ld	s0,0(sp)
    802074ba:	0141                	addi	sp,sp,16
    802074bc:	8082                	ret

00000000802074be <sys_access_task>:

void sys_access_task(void) {
    802074be:	1101                	addi	sp,sp,-32
    802074c0:	ec06                	sd	ra,24(sp)
    802074c2:	e822                	sd	s0,16(sp)
    802074c4:	1000                	addi	s0,sp,32
    volatile int *ptr = (int*)0x80200000; // 内核空间地址
    802074c6:	40100793          	li	a5,1025
    802074ca:	07d6                	slli	a5,a5,0x15
    802074cc:	fef43423          	sd	a5,-24(s0)
    printf("SYS: try read kernel addr 0x80200000\n");
    802074d0:	0001c517          	auipc	a0,0x1c
    802074d4:	3d050513          	addi	a0,a0,976 # 802238a0 <syscall_performance_bin+0x1728>
    802074d8:	ffff9097          	auipc	ra,0xffff9
    802074dc:	7fe080e7          	jalr	2046(ra) # 80200cd6 <printf>
    int val = *ptr;
    802074e0:	fe843783          	ld	a5,-24(s0)
    802074e4:	439c                	lw	a5,0(a5)
    802074e6:	fef42223          	sw	a5,-28(s0)
    printf("SYS: read success, value=%d\n", val);
    802074ea:	fe442783          	lw	a5,-28(s0)
    802074ee:	85be                	mv	a1,a5
    802074f0:	0001c517          	auipc	a0,0x1c
    802074f4:	3d850513          	addi	a0,a0,984 # 802238c8 <syscall_performance_bin+0x1750>
    802074f8:	ffff9097          	auipc	ra,0xffff9
    802074fc:	7de080e7          	jalr	2014(ra) # 80200cd6 <printf>
    exit_proc(0);
    80207500:	4501                	li	a0,0
    80207502:	ffffe097          	auipc	ra,0xffffe
    80207506:	7c6080e7          	jalr	1990(ra) # 80205cc8 <exit_proc>
}
    8020750a:	0001                	nop
    8020750c:	60e2                	ld	ra,24(sp)
    8020750e:	6442                	ld	s0,16(sp)
    80207510:	6105                	addi	sp,sp,32
    80207512:	8082                	ret

0000000080207514 <infinite_task>:

void infinite_task(void){
    80207514:	1101                	addi	sp,sp,-32
    80207516:	ec06                	sd	ra,24(sp)
    80207518:	e822                	sd	s0,16(sp)
    8020751a:	1000                	addi	s0,sp,32
	int count = 5000 ;
    8020751c:	6785                	lui	a5,0x1
    8020751e:	38878793          	addi	a5,a5,904 # 1388 <_entry-0x801fec78>
    80207522:	fef42623          	sw	a5,-20(s0)
	while(count){
    80207526:	a835                	j	80207562 <infinite_task+0x4e>
		count--;
    80207528:	fec42783          	lw	a5,-20(s0)
    8020752c:	37fd                	addiw	a5,a5,-1
    8020752e:	fef42623          	sw	a5,-20(s0)
		if (count % 100 == 0)
    80207532:	fec42783          	lw	a5,-20(s0)
    80207536:	873e                	mv	a4,a5
    80207538:	06400793          	li	a5,100
    8020753c:	02f767bb          	remw	a5,a4,a5
    80207540:	2781                	sext.w	a5,a5
    80207542:	ef81                	bnez	a5,8020755a <infinite_task+0x46>
			printf("count for %d\n",count);
    80207544:	fec42783          	lw	a5,-20(s0)
    80207548:	85be                	mv	a1,a5
    8020754a:	0001c517          	auipc	a0,0x1c
    8020754e:	39e50513          	addi	a0,a0,926 # 802238e8 <syscall_performance_bin+0x1770>
    80207552:	ffff9097          	auipc	ra,0xffff9
    80207556:	784080e7          	jalr	1924(ra) # 80200cd6 <printf>
		yield();
    8020755a:	ffffe097          	auipc	ra,0xffffe
    8020755e:	560080e7          	jalr	1376(ra) # 80205aba <yield>
	while(count){
    80207562:	fec42783          	lw	a5,-20(s0)
    80207566:	2781                	sext.w	a5,a5
    80207568:	f3e1                	bnez	a5,80207528 <infinite_task+0x14>
	}
	warning("INFINITE TASK FINISH WITHOUT KILLED!!\n");
    8020756a:	0001c517          	auipc	a0,0x1c
    8020756e:	38e50513          	addi	a0,a0,910 # 802238f8 <syscall_performance_bin+0x1780>
    80207572:	ffffa097          	auipc	ra,0xffffa
    80207576:	1e4080e7          	jalr	484(ra) # 80201756 <warning>
}
    8020757a:	0001                	nop
    8020757c:	60e2                	ld	ra,24(sp)
    8020757e:	6442                	ld	s0,16(sp)
    80207580:	6105                	addi	sp,sp,32
    80207582:	8082                	ret

0000000080207584 <killer_task>:

void killer_task(uint64 kill_pid){
    80207584:	7179                	addi	sp,sp,-48
    80207586:	f406                	sd	ra,40(sp)
    80207588:	f022                	sd	s0,32(sp)
    8020758a:	1800                	addi	s0,sp,48
    8020758c:	fca43c23          	sd	a0,-40(s0)
	int count = 500;
    80207590:	1f400793          	li	a5,500
    80207594:	fef42623          	sw	a5,-20(s0)
	while(count){
    80207598:	a81d                	j	802075ce <killer_task+0x4a>
		count--;
    8020759a:	fec42783          	lw	a5,-20(s0)
    8020759e:	37fd                	addiw	a5,a5,-1
    802075a0:	fef42623          	sw	a5,-20(s0)
		if(count % 100 == 0)
    802075a4:	fec42783          	lw	a5,-20(s0)
    802075a8:	873e                	mv	a4,a5
    802075aa:	06400793          	li	a5,100
    802075ae:	02f767bb          	remw	a5,a4,a5
    802075b2:	2781                	sext.w	a5,a5
    802075b4:	eb89                	bnez	a5,802075c6 <killer_task+0x42>
			printf("I see you!!!\n");
    802075b6:	0001c517          	auipc	a0,0x1c
    802075ba:	36a50513          	addi	a0,a0,874 # 80223920 <syscall_performance_bin+0x17a8>
    802075be:	ffff9097          	auipc	ra,0xffff9
    802075c2:	718080e7          	jalr	1816(ra) # 80200cd6 <printf>
		yield();
    802075c6:	ffffe097          	auipc	ra,0xffffe
    802075ca:	4f4080e7          	jalr	1268(ra) # 80205aba <yield>
	while(count){
    802075ce:	fec42783          	lw	a5,-20(s0)
    802075d2:	2781                	sext.w	a5,a5
    802075d4:	f3f9                	bnez	a5,8020759a <killer_task+0x16>
	}
	kill_proc((int)kill_pid);
    802075d6:	fd843783          	ld	a5,-40(s0)
    802075da:	2781                	sext.w	a5,a5
    802075dc:	853e                	mv	a0,a5
    802075de:	ffffe097          	auipc	ra,0xffffe
    802075e2:	686080e7          	jalr	1670(ra) # 80205c64 <kill_proc>
	printf("Killed proc %d\n",(int)kill_pid);
    802075e6:	fd843783          	ld	a5,-40(s0)
    802075ea:	2781                	sext.w	a5,a5
    802075ec:	85be                	mv	a1,a5
    802075ee:	0001c517          	auipc	a0,0x1c
    802075f2:	34250513          	addi	a0,a0,834 # 80223930 <syscall_performance_bin+0x17b8>
    802075f6:	ffff9097          	auipc	ra,0xffff9
    802075fa:	6e0080e7          	jalr	1760(ra) # 80200cd6 <printf>
	exit_proc(0);
    802075fe:	4501                	li	a0,0
    80207600:	ffffe097          	auipc	ra,0xffffe
    80207604:	6c8080e7          	jalr	1736(ra) # 80205cc8 <exit_proc>
}
    80207608:	0001                	nop
    8020760a:	70a2                	ld	ra,40(sp)
    8020760c:	7402                	ld	s0,32(sp)
    8020760e:	6145                	addi	sp,sp,48
    80207610:	8082                	ret

0000000080207612 <victim_task>:
void victim_task(void){
    80207612:	1101                	addi	sp,sp,-32
    80207614:	ec06                	sd	ra,24(sp)
    80207616:	e822                	sd	s0,16(sp)
    80207618:	1000                	addi	s0,sp,32
	int count =5000;
    8020761a:	6785                	lui	a5,0x1
    8020761c:	38878793          	addi	a5,a5,904 # 1388 <_entry-0x801fec78>
    80207620:	fef42623          	sw	a5,-20(s0)
	while(count){
    80207624:	a81d                	j	8020765a <victim_task+0x48>
		count--;
    80207626:	fec42783          	lw	a5,-20(s0)
    8020762a:	37fd                	addiw	a5,a5,-1
    8020762c:	fef42623          	sw	a5,-20(s0)
		if(count % 100 == 0)
    80207630:	fec42783          	lw	a5,-20(s0)
    80207634:	873e                	mv	a4,a5
    80207636:	06400793          	li	a5,100
    8020763a:	02f767bb          	remw	a5,a4,a5
    8020763e:	2781                	sext.w	a5,a5
    80207640:	eb89                	bnez	a5,80207652 <victim_task+0x40>
			printf("Call for help!!\n");
    80207642:	0001c517          	auipc	a0,0x1c
    80207646:	2fe50513          	addi	a0,a0,766 # 80223940 <syscall_performance_bin+0x17c8>
    8020764a:	ffff9097          	auipc	ra,0xffff9
    8020764e:	68c080e7          	jalr	1676(ra) # 80200cd6 <printf>
		yield();
    80207652:	ffffe097          	auipc	ra,0xffffe
    80207656:	468080e7          	jalr	1128(ra) # 80205aba <yield>
	while(count){
    8020765a:	fec42783          	lw	a5,-20(s0)
    8020765e:	2781                	sext.w	a5,a5
    80207660:	f3f9                	bnez	a5,80207626 <victim_task+0x14>
	}
	printf("No one can kill me!\n");
    80207662:	0001c517          	auipc	a0,0x1c
    80207666:	2f650513          	addi	a0,a0,758 # 80223958 <syscall_performance_bin+0x17e0>
    8020766a:	ffff9097          	auipc	ra,0xffff9
    8020766e:	66c080e7          	jalr	1644(ra) # 80200cd6 <printf>
	exit_proc(0);
    80207672:	4501                	li	a0,0
    80207674:	ffffe097          	auipc	ra,0xffffe
    80207678:	654080e7          	jalr	1620(ra) # 80205cc8 <exit_proc>
}
    8020767c:	0001                	nop
    8020767e:	60e2                	ld	ra,24(sp)
    80207680:	6442                	ld	s0,16(sp)
    80207682:	6105                	addi	sp,sp,32
    80207684:	8082                	ret

0000000080207686 <test_kill>:

void test_kill(void){
    80207686:	7179                	addi	sp,sp,-48
    80207688:	f406                	sd	ra,40(sp)
    8020768a:	f022                	sd	s0,32(sp)
    8020768c:	1800                	addi	s0,sp,48
	printf("\n----- 测试1: 创建后立即杀死 -----\n");
    8020768e:	0001c517          	auipc	a0,0x1c
    80207692:	2e250513          	addi	a0,a0,738 # 80223970 <syscall_performance_bin+0x17f8>
    80207696:	ffff9097          	auipc	ra,0xffff9
    8020769a:	640080e7          	jalr	1600(ra) # 80200cd6 <printf>
	int pid =create_kernel_proc(simple_task);
    8020769e:	fffff517          	auipc	a0,0xfffff
    802076a2:	2e650513          	addi	a0,a0,742 # 80206984 <simple_task>
    802076a6:	ffffe097          	auipc	ra,0xffffe
    802076aa:	eba080e7          	jalr	-326(ra) # 80205560 <create_kernel_proc>
    802076ae:	87aa                	mv	a5,a0
    802076b0:	fef42423          	sw	a5,-24(s0)
	printf("【测试】: 创建进程成功，PID: %d\n", pid);
    802076b4:	fe842783          	lw	a5,-24(s0)
    802076b8:	85be                	mv	a1,a5
    802076ba:	0001c517          	auipc	a0,0x1c
    802076be:	2e650513          	addi	a0,a0,742 # 802239a0 <syscall_performance_bin+0x1828>
    802076c2:	ffff9097          	auipc	ra,0xffff9
    802076c6:	614080e7          	jalr	1556(ra) # 80200cd6 <printf>
	kill_proc(pid);
    802076ca:	fe842783          	lw	a5,-24(s0)
    802076ce:	853e                	mv	a0,a5
    802076d0:	ffffe097          	auipc	ra,0xffffe
    802076d4:	594080e7          	jalr	1428(ra) # 80205c64 <kill_proc>
	printf("【测试】: 等待被杀死的进程退出,此处被杀死的进程不会有输出...\n");
    802076d8:	0001c517          	auipc	a0,0x1c
    802076dc:	2f850513          	addi	a0,a0,760 # 802239d0 <syscall_performance_bin+0x1858>
    802076e0:	ffff9097          	auipc	ra,0xffff9
    802076e4:	5f6080e7          	jalr	1526(ra) # 80200cd6 <printf>
	int ret =0;
    802076e8:	fc042c23          	sw	zero,-40(s0)
	wait_proc(&ret);
    802076ec:	fd840793          	addi	a5,s0,-40
    802076f0:	853e                	mv	a0,a5
    802076f2:	ffffe097          	auipc	ra,0xffffe
    802076f6:	6a0080e7          	jalr	1696(ra) # 80205d92 <wait_proc>
	printf("【测试】: 进程%d退出，退出码应该为129，此处为%d\n ",pid,ret);
    802076fa:	fd842703          	lw	a4,-40(s0)
    802076fe:	fe842783          	lw	a5,-24(s0)
    80207702:	863a                	mv	a2,a4
    80207704:	85be                	mv	a1,a5
    80207706:	0001c517          	auipc	a0,0x1c
    8020770a:	32a50513          	addi	a0,a0,810 # 80223a30 <syscall_performance_bin+0x18b8>
    8020770e:	ffff9097          	auipc	ra,0xffff9
    80207712:	5c8080e7          	jalr	1480(ra) # 80200cd6 <printf>
	if(SYS_kill == ret){
    80207716:	fd842783          	lw	a5,-40(s0)
    8020771a:	873e                	mv	a4,a5
    8020771c:	08100793          	li	a5,129
    80207720:	00f71b63          	bne	a4,a5,80207736 <test_kill+0xb0>
		printf("【测试】:尝试立即杀死进程，测试成功\n");
    80207724:	0001c517          	auipc	a0,0x1c
    80207728:	35450513          	addi	a0,a0,852 # 80223a78 <syscall_performance_bin+0x1900>
    8020772c:	ffff9097          	auipc	ra,0xffff9
    80207730:	5aa080e7          	jalr	1450(ra) # 80200cd6 <printf>
    80207734:	a831                	j	80207750 <test_kill+0xca>
	}else{
		printf("【测试】:尝试立即杀死进程失败，退出\n");
    80207736:	0001c517          	auipc	a0,0x1c
    8020773a:	37a50513          	addi	a0,a0,890 # 80223ab0 <syscall_performance_bin+0x1938>
    8020773e:	ffff9097          	auipc	ra,0xffff9
    80207742:	598080e7          	jalr	1432(ra) # 80200cd6 <printf>
		exit_proc(0);
    80207746:	4501                	li	a0,0
    80207748:	ffffe097          	auipc	ra,0xffffe
    8020774c:	580080e7          	jalr	1408(ra) # 80205cc8 <exit_proc>
	}
	printf("\n----- 测试2: 创建后稍后杀死 -----\n");
    80207750:	0001c517          	auipc	a0,0x1c
    80207754:	39850513          	addi	a0,a0,920 # 80223ae8 <syscall_performance_bin+0x1970>
    80207758:	ffff9097          	auipc	ra,0xffff9
    8020775c:	57e080e7          	jalr	1406(ra) # 80200cd6 <printf>
	pid = create_kernel_proc(infinite_task);
    80207760:	00000517          	auipc	a0,0x0
    80207764:	db450513          	addi	a0,a0,-588 # 80207514 <infinite_task>
    80207768:	ffffe097          	auipc	ra,0xffffe
    8020776c:	df8080e7          	jalr	-520(ra) # 80205560 <create_kernel_proc>
    80207770:	87aa                	mv	a5,a0
    80207772:	fef42423          	sw	a5,-24(s0)
	int count = 500;
    80207776:	1f400793          	li	a5,500
    8020777a:	fef42623          	sw	a5,-20(s0)
	while(count){
    8020777e:	a811                	j	80207792 <test_kill+0x10c>
		count--; //等待500次调度
    80207780:	fec42783          	lw	a5,-20(s0)
    80207784:	37fd                	addiw	a5,a5,-1
    80207786:	fef42623          	sw	a5,-20(s0)
		yield();
    8020778a:	ffffe097          	auipc	ra,0xffffe
    8020778e:	330080e7          	jalr	816(ra) # 80205aba <yield>
	while(count){
    80207792:	fec42783          	lw	a5,-20(s0)
    80207796:	2781                	sext.w	a5,a5
    80207798:	f7e5                	bnez	a5,80207780 <test_kill+0xfa>
	}
	kill_proc(pid);
    8020779a:	fe842783          	lw	a5,-24(s0)
    8020779e:	853e                	mv	a0,a5
    802077a0:	ffffe097          	auipc	ra,0xffffe
    802077a4:	4c4080e7          	jalr	1220(ra) # 80205c64 <kill_proc>
	wait_proc(&ret);
    802077a8:	fd840793          	addi	a5,s0,-40
    802077ac:	853e                	mv	a0,a5
    802077ae:	ffffe097          	auipc	ra,0xffffe
    802077b2:	5e4080e7          	jalr	1508(ra) # 80205d92 <wait_proc>
	if(SYS_kill == ret){
    802077b6:	fd842783          	lw	a5,-40(s0)
    802077ba:	873e                	mv	a4,a5
    802077bc:	08100793          	li	a5,129
    802077c0:	00f71b63          	bne	a4,a5,802077d6 <test_kill+0x150>
		printf("【测试】:尝试稍后杀死进程，测试成功\n");
    802077c4:	0001c517          	auipc	a0,0x1c
    802077c8:	35450513          	addi	a0,a0,852 # 80223b18 <syscall_performance_bin+0x19a0>
    802077cc:	ffff9097          	auipc	ra,0xffff9
    802077d0:	50a080e7          	jalr	1290(ra) # 80200cd6 <printf>
    802077d4:	a831                	j	802077f0 <test_kill+0x16a>
	}else{
		printf("【测试】:尝试稍后杀死进程失败，退出\n");
    802077d6:	0001c517          	auipc	a0,0x1c
    802077da:	37a50513          	addi	a0,a0,890 # 80223b50 <syscall_performance_bin+0x19d8>
    802077de:	ffff9097          	auipc	ra,0xffff9
    802077e2:	4f8080e7          	jalr	1272(ra) # 80200cd6 <printf>
		exit_proc(0);
    802077e6:	4501                	li	a0,0
    802077e8:	ffffe097          	auipc	ra,0xffffe
    802077ec:	4e0080e7          	jalr	1248(ra) # 80205cc8 <exit_proc>
	}
	printf("\n----- 测试3: 创建killer 和 victim -----\n");
    802077f0:	0001c517          	auipc	a0,0x1c
    802077f4:	39850513          	addi	a0,a0,920 # 80223b88 <syscall_performance_bin+0x1a10>
    802077f8:	ffff9097          	auipc	ra,0xffff9
    802077fc:	4de080e7          	jalr	1246(ra) # 80200cd6 <printf>
	int victim = create_kernel_proc(victim_task);
    80207800:	00000517          	auipc	a0,0x0
    80207804:	e1250513          	addi	a0,a0,-494 # 80207612 <victim_task>
    80207808:	ffffe097          	auipc	ra,0xffffe
    8020780c:	d58080e7          	jalr	-680(ra) # 80205560 <create_kernel_proc>
    80207810:	87aa                	mv	a5,a0
    80207812:	fef42223          	sw	a5,-28(s0)
	int killer = create_kernel_proc1(killer_task,victim);
    80207816:	fe442783          	lw	a5,-28(s0)
    8020781a:	85be                	mv	a1,a5
    8020781c:	00000517          	auipc	a0,0x0
    80207820:	d6850513          	addi	a0,a0,-664 # 80207584 <killer_task>
    80207824:	ffffe097          	auipc	ra,0xffffe
    80207828:	daa080e7          	jalr	-598(ra) # 802055ce <create_kernel_proc1>
    8020782c:	87aa                	mv	a5,a0
    8020782e:	fef42023          	sw	a5,-32(s0)
	int first_exit = wait_proc(&ret);
    80207832:	fd840793          	addi	a5,s0,-40
    80207836:	853e                	mv	a0,a5
    80207838:	ffffe097          	auipc	ra,0xffffe
    8020783c:	55a080e7          	jalr	1370(ra) # 80205d92 <wait_proc>
    80207840:	87aa                	mv	a5,a0
    80207842:	fcf42e23          	sw	a5,-36(s0)
	if(first_exit == killer){
    80207846:	fdc42783          	lw	a5,-36(s0)
    8020784a:	873e                	mv	a4,a5
    8020784c:	fe042783          	lw	a5,-32(s0)
    80207850:	2701                	sext.w	a4,a4
    80207852:	2781                	sext.w	a5,a5
    80207854:	04f71263          	bne	a4,a5,80207898 <test_kill+0x212>
		wait_proc(&ret);
    80207858:	fd840793          	addi	a5,s0,-40
    8020785c:	853e                	mv	a0,a5
    8020785e:	ffffe097          	auipc	ra,0xffffe
    80207862:	534080e7          	jalr	1332(ra) # 80205d92 <wait_proc>
		if(SYS_kill == ret){
    80207866:	fd842783          	lw	a5,-40(s0)
    8020786a:	873e                	mv	a4,a5
    8020786c:	08100793          	li	a5,129
    80207870:	00f71b63          	bne	a4,a5,80207886 <test_kill+0x200>
			printf("【测试】:killer win\n");
    80207874:	0001c517          	auipc	a0,0x1c
    80207878:	34450513          	addi	a0,a0,836 # 80223bb8 <syscall_performance_bin+0x1a40>
    8020787c:	ffff9097          	auipc	ra,0xffff9
    80207880:	45a080e7          	jalr	1114(ra) # 80200cd6 <printf>
    80207884:	a085                	j	802078e4 <test_kill+0x25e>
		}else{
			printf("【测试】:出现问题，killer先结束但victim存活\n");
    80207886:	0001c517          	auipc	a0,0x1c
    8020788a:	35250513          	addi	a0,a0,850 # 80223bd8 <syscall_performance_bin+0x1a60>
    8020788e:	ffff9097          	auipc	ra,0xffff9
    80207892:	448080e7          	jalr	1096(ra) # 80200cd6 <printf>
    80207896:	a0b9                	j	802078e4 <test_kill+0x25e>
		}
	}else if(first_exit == victim){
    80207898:	fdc42783          	lw	a5,-36(s0)
    8020789c:	873e                	mv	a4,a5
    8020789e:	fe442783          	lw	a5,-28(s0)
    802078a2:	2701                	sext.w	a4,a4
    802078a4:	2781                	sext.w	a5,a5
    802078a6:	02f71f63          	bne	a4,a5,802078e4 <test_kill+0x25e>
		wait_proc(NULL);
    802078aa:	4501                	li	a0,0
    802078ac:	ffffe097          	auipc	ra,0xffffe
    802078b0:	4e6080e7          	jalr	1254(ra) # 80205d92 <wait_proc>
		if(SYS_kill == ret){
    802078b4:	fd842783          	lw	a5,-40(s0)
    802078b8:	873e                	mv	a4,a5
    802078ba:	08100793          	li	a5,129
    802078be:	00f71b63          	bne	a4,a5,802078d4 <test_kill+0x24e>
			printf("【测试】:killer win\n");
    802078c2:	0001c517          	auipc	a0,0x1c
    802078c6:	2f650513          	addi	a0,a0,758 # 80223bb8 <syscall_performance_bin+0x1a40>
    802078ca:	ffff9097          	auipc	ra,0xffff9
    802078ce:	40c080e7          	jalr	1036(ra) # 80200cd6 <printf>
    802078d2:	a809                	j	802078e4 <test_kill+0x25e>
		}else{
			printf("【测试】:出现问题，victim先结束且存活\n");
    802078d4:	0001c517          	auipc	a0,0x1c
    802078d8:	34450513          	addi	a0,a0,836 # 80223c18 <syscall_performance_bin+0x1aa0>
    802078dc:	ffff9097          	auipc	ra,0xffff9
    802078e0:	3fa080e7          	jalr	1018(ra) # 80200cd6 <printf>
		}
	}
	exit_proc(0);
    802078e4:	4501                	li	a0,0
    802078e6:	ffffe097          	auipc	ra,0xffffe
    802078ea:	3e2080e7          	jalr	994(ra) # 80205cc8 <exit_proc>
}
    802078ee:	0001                	nop
    802078f0:	70a2                	ld	ra,40(sp)
    802078f2:	7402                	ld	s0,32(sp)
    802078f4:	6145                	addi	sp,sp,48
    802078f6:	8082                	ret

00000000802078f8 <test_user_kill>:
void test_user_kill(void){
    802078f8:	1101                	addi	sp,sp,-32
    802078fa:	ec06                	sd	ra,24(sp)
    802078fc:	e822                	sd	s0,16(sp)
    802078fe:	1000                	addi	s0,sp,32
	printf("===== 测试开始: 用户进程Kill测试 =====\n");
    80207900:	0001c517          	auipc	a0,0x1c
    80207904:	35050513          	addi	a0,a0,848 # 80223c50 <syscall_performance_bin+0x1ad8>
    80207908:	ffff9097          	auipc	ra,0xffff9
    8020790c:	3ce080e7          	jalr	974(ra) # 80200cd6 <printf>
    
    printf("\n----- 创建fork测试进程 -----\n");
    80207910:	0001c517          	auipc	a0,0x1c
    80207914:	b2050513          	addi	a0,a0,-1248 # 80223430 <syscall_performance_bin+0x12b8>
    80207918:	ffff9097          	auipc	ra,0xffff9
    8020791c:	3be080e7          	jalr	958(ra) # 80200cd6 <printf>
    int test_pid = create_user_proc(kill_user_test_bin, kill_user_test_bin_len);
    80207920:	42000793          	li	a5,1056
    80207924:	2781                	sext.w	a5,a5
    80207926:	85be                	mv	a1,a5
    80207928:	0001a517          	auipc	a0,0x1a
    8020792c:	3a050513          	addi	a0,a0,928 # 80221cc8 <kill_user_test_bin>
    80207930:	ffffe097          	auipc	ra,0xffffe
    80207934:	d1c080e7          	jalr	-740(ra) # 8020564c <create_user_proc>
    80207938:	87aa                	mv	a5,a0
    8020793a:	fef42623          	sw	a5,-20(s0)
    
    if (test_pid < 0) {
    8020793e:	fec42783          	lw	a5,-20(s0)
    80207942:	2781                	sext.w	a5,a5
    80207944:	0007db63          	bgez	a5,8020795a <test_user_kill+0x62>
        printf("【错误】: 创建fork测试进程失败\n");
    80207948:	0001c517          	auipc	a0,0x1c
    8020794c:	b1050513          	addi	a0,a0,-1264 # 80223458 <syscall_performance_bin+0x12e0>
    80207950:	ffff9097          	auipc	ra,0xffff9
    80207954:	386080e7          	jalr	902(ra) # 80200cd6 <printf>
    80207958:	a861                	j	802079f0 <test_user_kill+0xf8>
        return;
    }
    
    printf("【测试结果】: 创建fork测试进程成功，PID: %d\n", test_pid);
    8020795a:	fec42783          	lw	a5,-20(s0)
    8020795e:	85be                	mv	a1,a5
    80207960:	0001c517          	auipc	a0,0x1c
    80207964:	b2850513          	addi	a0,a0,-1240 # 80223488 <syscall_performance_bin+0x1310>
    80207968:	ffff9097          	auipc	ra,0xffff9
    8020796c:	36e080e7          	jalr	878(ra) # 80200cd6 <printf>
    
    // 等待fork测试进程完成
    printf("\n----- 等待fork测试进程完成 -----\n");
    80207970:	0001c517          	auipc	a0,0x1c
    80207974:	b5850513          	addi	a0,a0,-1192 # 802234c8 <syscall_performance_bin+0x1350>
    80207978:	ffff9097          	auipc	ra,0xffff9
    8020797c:	35e080e7          	jalr	862(ra) # 80200cd6 <printf>
    int status;
    int waited_pid = wait_proc(&status);
    80207980:	fe440793          	addi	a5,s0,-28
    80207984:	853e                	mv	a0,a5
    80207986:	ffffe097          	auipc	ra,0xffffe
    8020798a:	40c080e7          	jalr	1036(ra) # 80205d92 <wait_proc>
    8020798e:	87aa                	mv	a5,a0
    80207990:	fef42423          	sw	a5,-24(s0)
    if (waited_pid == test_pid) {
    80207994:	fe842783          	lw	a5,-24(s0)
    80207998:	873e                	mv	a4,a5
    8020799a:	fec42783          	lw	a5,-20(s0)
    8020799e:	2701                	sext.w	a4,a4
    802079a0:	2781                	sext.w	a5,a5
    802079a2:	02f71163          	bne	a4,a5,802079c4 <test_user_kill+0xcc>
        printf("【测试结果】: fork测试进程(PID: %d)完成，状态码: %d\n", test_pid, status);
    802079a6:	fe442703          	lw	a4,-28(s0)
    802079aa:	fec42783          	lw	a5,-20(s0)
    802079ae:	863a                	mv	a2,a4
    802079b0:	85be                	mv	a1,a5
    802079b2:	0001c517          	auipc	a0,0x1c
    802079b6:	b4650513          	addi	a0,a0,-1210 # 802234f8 <syscall_performance_bin+0x1380>
    802079ba:	ffff9097          	auipc	ra,0xffff9
    802079be:	31c080e7          	jalr	796(ra) # 80200cd6 <printf>
    802079c2:	a839                	j	802079e0 <test_user_kill+0xe8>
    } else {
        printf("【错误】: 等待fork测试进程时出错，等待到PID: %d，期望PID: %d\n", waited_pid, test_pid);
    802079c4:	fec42703          	lw	a4,-20(s0)
    802079c8:	fe842783          	lw	a5,-24(s0)
    802079cc:	863a                	mv	a2,a4
    802079ce:	85be                	mv	a1,a5
    802079d0:	0001c517          	auipc	a0,0x1c
    802079d4:	b8850513          	addi	a0,a0,-1144 # 80223558 <syscall_performance_bin+0x13e0>
    802079d8:	ffff9097          	auipc	ra,0xffff9
    802079dc:	2fe080e7          	jalr	766(ra) # 80200cd6 <printf>
    }
    printf("===== 测试结束: 用户进程Kill测试 =====\n");
    802079e0:	0001c517          	auipc	a0,0x1c
    802079e4:	2a850513          	addi	a0,a0,680 # 80223c88 <syscall_performance_bin+0x1b10>
    802079e8:	ffff9097          	auipc	ra,0xffff9
    802079ec:	2ee080e7          	jalr	750(ra) # 80200cd6 <printf>
}
    802079f0:	60e2                	ld	ra,24(sp)
    802079f2:	6442                	ld	s0,16(sp)
    802079f4:	6105                	addi	sp,sp,32
    802079f6:	8082                	ret

00000000802079f8 <test_file_syscalls>:
void test_file_syscalls(void) {
    802079f8:	1101                	addi	sp,sp,-32
    802079fa:	ec06                	sd	ra,24(sp)
    802079fc:	e822                	sd	s0,16(sp)
    802079fe:	1000                	addi	s0,sp,32
    printf("\n===== 测试开始: 文件系统调用测试 =====\n");
    80207a00:	0001c517          	auipc	a0,0x1c
    80207a04:	2c050513          	addi	a0,a0,704 # 80223cc0 <syscall_performance_bin+0x1b48>
    80207a08:	ffff9097          	auipc	ra,0xffff9
    80207a0c:	2ce080e7          	jalr	718(ra) # 80200cd6 <printf>
    
    printf("\n----- 创建文件测试进程 -----\n");
    80207a10:	0001c517          	auipc	a0,0x1c
    80207a14:	2e850513          	addi	a0,a0,744 # 80223cf8 <syscall_performance_bin+0x1b80>
    80207a18:	ffff9097          	auipc	ra,0xffff9
    80207a1c:	2be080e7          	jalr	702(ra) # 80200cd6 <printf>
    int test_pid = create_user_proc(file_test_bin, file_test_bin_len);
    80207a20:	6785                	lui	a5,0x1
    80207a22:	9ad78793          	addi	a5,a5,-1619 # 9ad <_entry-0x801ff653>
    80207a26:	2781                	sext.w	a5,a5
    80207a28:	85be                	mv	a1,a5
    80207a2a:	00019517          	auipc	a0,0x19
    80207a2e:	fc650513          	addi	a0,a0,-58 # 802209f0 <file_test_bin>
    80207a32:	ffffe097          	auipc	ra,0xffffe
    80207a36:	c1a080e7          	jalr	-998(ra) # 8020564c <create_user_proc>
    80207a3a:	87aa                	mv	a5,a0
    80207a3c:	fef42623          	sw	a5,-20(s0)
    
    if (test_pid < 0) {
    80207a40:	fec42783          	lw	a5,-20(s0)
    80207a44:	2781                	sext.w	a5,a5
    80207a46:	0007db63          	bgez	a5,80207a5c <test_file_syscalls+0x64>
        printf("【错误】: 创建文件测试进程失败\n");
    80207a4a:	0001c517          	auipc	a0,0x1c
    80207a4e:	2d650513          	addi	a0,a0,726 # 80223d20 <syscall_performance_bin+0x1ba8>
    80207a52:	ffff9097          	auipc	ra,0xffff9
    80207a56:	284080e7          	jalr	644(ra) # 80200cd6 <printf>
    80207a5a:	a861                	j	80207af2 <test_file_syscalls+0xfa>
        return;
    }
    
    printf("【测试结果】: 创建文件测试进程成功，PID: %d\n", test_pid);
    80207a5c:	fec42783          	lw	a5,-20(s0)
    80207a60:	85be                	mv	a1,a5
    80207a62:	0001c517          	auipc	a0,0x1c
    80207a66:	2ee50513          	addi	a0,a0,750 # 80223d50 <syscall_performance_bin+0x1bd8>
    80207a6a:	ffff9097          	auipc	ra,0xffff9
    80207a6e:	26c080e7          	jalr	620(ra) # 80200cd6 <printf>
    
    // 等待测试进程完成
    printf("\n----- 等待文件测试进程完成 -----\n");
    80207a72:	0001c517          	auipc	a0,0x1c
    80207a76:	31e50513          	addi	a0,a0,798 # 80223d90 <syscall_performance_bin+0x1c18>
    80207a7a:	ffff9097          	auipc	ra,0xffff9
    80207a7e:	25c080e7          	jalr	604(ra) # 80200cd6 <printf>
    int status;
    int waited_pid = wait_proc(&status);
    80207a82:	fe440793          	addi	a5,s0,-28
    80207a86:	853e                	mv	a0,a5
    80207a88:	ffffe097          	auipc	ra,0xffffe
    80207a8c:	30a080e7          	jalr	778(ra) # 80205d92 <wait_proc>
    80207a90:	87aa                	mv	a5,a0
    80207a92:	fef42423          	sw	a5,-24(s0)
    if (waited_pid == test_pid) {
    80207a96:	fe842783          	lw	a5,-24(s0)
    80207a9a:	873e                	mv	a4,a5
    80207a9c:	fec42783          	lw	a5,-20(s0)
    80207aa0:	2701                	sext.w	a4,a4
    80207aa2:	2781                	sext.w	a5,a5
    80207aa4:	02f71163          	bne	a4,a5,80207ac6 <test_file_syscalls+0xce>
        printf("【测试结果】: 文件测试进程(PID: %d)完成，状态码: %d\n", 
    80207aa8:	fe442703          	lw	a4,-28(s0)
    80207aac:	fec42783          	lw	a5,-20(s0)
    80207ab0:	863a                	mv	a2,a4
    80207ab2:	85be                	mv	a1,a5
    80207ab4:	0001c517          	auipc	a0,0x1c
    80207ab8:	30c50513          	addi	a0,a0,780 # 80223dc0 <syscall_performance_bin+0x1c48>
    80207abc:	ffff9097          	auipc	ra,0xffff9
    80207ac0:	21a080e7          	jalr	538(ra) # 80200cd6 <printf>
    80207ac4:	a839                	j	80207ae2 <test_file_syscalls+0xea>
               test_pid, status);
    } else {
        printf("【错误】: 等待文件测试进程时出错，等待到PID: %d，期望PID: %d\n", 
    80207ac6:	fec42703          	lw	a4,-20(s0)
    80207aca:	fe842783          	lw	a5,-24(s0)
    80207ace:	863a                	mv	a2,a4
    80207ad0:	85be                	mv	a1,a5
    80207ad2:	0001c517          	auipc	a0,0x1c
    80207ad6:	33650513          	addi	a0,a0,822 # 80223e08 <syscall_performance_bin+0x1c90>
    80207ada:	ffff9097          	auipc	ra,0xffff9
    80207ade:	1fc080e7          	jalr	508(ra) # 80200cd6 <printf>
               waited_pid, test_pid);
    }
    
    printf("===== 测试结束: 文件系统调用测试 =====\n");
    80207ae2:	0001c517          	auipc	a0,0x1c
    80207ae6:	37e50513          	addi	a0,a0,894 # 80223e60 <syscall_performance_bin+0x1ce8>
    80207aea:	ffff9097          	auipc	ra,0xffff9
    80207aee:	1ec080e7          	jalr	492(ra) # 80200cd6 <printf>
}
    80207af2:	60e2                	ld	ra,24(sp)
    80207af4:	6442                	ld	s0,16(sp)
    80207af6:	6105                	addi	sp,sp,32
    80207af8:	8082                	ret

0000000080207afa <test_syscall_performance>:
void test_syscall_performance(void) {
    80207afa:	1101                	addi	sp,sp,-32
    80207afc:	ec06                	sd	ra,24(sp)
    80207afe:	e822                	sd	s0,16(sp)
    80207b00:	1000                	addi	s0,sp,32
    printf("\n===== 测试开始: 系统调用性能测试 =====\n");
    80207b02:	0001c517          	auipc	a0,0x1c
    80207b06:	39650513          	addi	a0,a0,918 # 80223e98 <syscall_performance_bin+0x1d20>
    80207b0a:	ffff9097          	auipc	ra,0xffff9
    80207b0e:	1cc080e7          	jalr	460(ra) # 80200cd6 <printf>
    
    printf("\n----- 创建性能测试进程 -----\n");
    80207b12:	0001c517          	auipc	a0,0x1c
    80207b16:	3be50513          	addi	a0,a0,958 # 80223ed0 <syscall_performance_bin+0x1d58>
    80207b1a:	ffff9097          	auipc	ra,0xffff9
    80207b1e:	1bc080e7          	jalr	444(ra) # 80200cd6 <printf>
    int test_pid = create_user_proc(syscall_performance_bin, syscall_performance_bin_len);
    80207b22:	66c00793          	li	a5,1644
    80207b26:	2781                	sext.w	a5,a5
    80207b28:	85be                	mv	a1,a5
    80207b2a:	0001a517          	auipc	a0,0x1a
    80207b2e:	64e50513          	addi	a0,a0,1614 # 80222178 <syscall_performance_bin>
    80207b32:	ffffe097          	auipc	ra,0xffffe
    80207b36:	b1a080e7          	jalr	-1254(ra) # 8020564c <create_user_proc>
    80207b3a:	87aa                	mv	a5,a0
    80207b3c:	fef42623          	sw	a5,-20(s0)
    
    if (test_pid < 0) {
    80207b40:	fec42783          	lw	a5,-20(s0)
    80207b44:	2781                	sext.w	a5,a5
    80207b46:	0007db63          	bgez	a5,80207b5c <test_syscall_performance+0x62>
        printf("【错误】: 创建性能测试进程失败\n");
    80207b4a:	0001c517          	auipc	a0,0x1c
    80207b4e:	3ae50513          	addi	a0,a0,942 # 80223ef8 <syscall_performance_bin+0x1d80>
    80207b52:	ffff9097          	auipc	ra,0xffff9
    80207b56:	184080e7          	jalr	388(ra) # 80200cd6 <printf>
    80207b5a:	a861                	j	80207bf2 <test_syscall_performance+0xf8>
        return;
    }
    
    printf("【测试结果】: 创建性能测试进程成功，PID: %d\n", test_pid);
    80207b5c:	fec42783          	lw	a5,-20(s0)
    80207b60:	85be                	mv	a1,a5
    80207b62:	0001c517          	auipc	a0,0x1c
    80207b66:	3c650513          	addi	a0,a0,966 # 80223f28 <syscall_performance_bin+0x1db0>
    80207b6a:	ffff9097          	auipc	ra,0xffff9
    80207b6e:	16c080e7          	jalr	364(ra) # 80200cd6 <printf>
    
    // 等待测试进程完成
    printf("\n----- 等待性能测试进程完成 -----\n");
    80207b72:	0001c517          	auipc	a0,0x1c
    80207b76:	3f650513          	addi	a0,a0,1014 # 80223f68 <syscall_performance_bin+0x1df0>
    80207b7a:	ffff9097          	auipc	ra,0xffff9
    80207b7e:	15c080e7          	jalr	348(ra) # 80200cd6 <printf>
    int status;
    int waited_pid = wait_proc(&status);
    80207b82:	fe440793          	addi	a5,s0,-28
    80207b86:	853e                	mv	a0,a5
    80207b88:	ffffe097          	auipc	ra,0xffffe
    80207b8c:	20a080e7          	jalr	522(ra) # 80205d92 <wait_proc>
    80207b90:	87aa                	mv	a5,a0
    80207b92:	fef42423          	sw	a5,-24(s0)
    
    if (waited_pid == test_pid) {
    80207b96:	fe842783          	lw	a5,-24(s0)
    80207b9a:	873e                	mv	a4,a5
    80207b9c:	fec42783          	lw	a5,-20(s0)
    80207ba0:	2701                	sext.w	a4,a4
    80207ba2:	2781                	sext.w	a5,a5
    80207ba4:	02f71163          	bne	a4,a5,80207bc6 <test_syscall_performance+0xcc>
        printf("【测试结果】: 性能测试进程(PID: %d)完成，状态码: %d\n", 
    80207ba8:	fe442703          	lw	a4,-28(s0)
    80207bac:	fec42783          	lw	a5,-20(s0)
    80207bb0:	863a                	mv	a2,a4
    80207bb2:	85be                	mv	a1,a5
    80207bb4:	0001c517          	auipc	a0,0x1c
    80207bb8:	3e450513          	addi	a0,a0,996 # 80223f98 <syscall_performance_bin+0x1e20>
    80207bbc:	ffff9097          	auipc	ra,0xffff9
    80207bc0:	11a080e7          	jalr	282(ra) # 80200cd6 <printf>
    80207bc4:	a839                	j	80207be2 <test_syscall_performance+0xe8>
               test_pid, status);
    } else {
        printf("【错误】: 等待性能测试进程时出错，等待到PID: %d，期望PID: %d\n", 
    80207bc6:	fec42703          	lw	a4,-20(s0)
    80207bca:	fe842783          	lw	a5,-24(s0)
    80207bce:	863a                	mv	a2,a4
    80207bd0:	85be                	mv	a1,a5
    80207bd2:	0001c517          	auipc	a0,0x1c
    80207bd6:	40e50513          	addi	a0,a0,1038 # 80223fe0 <syscall_performance_bin+0x1e68>
    80207bda:	ffff9097          	auipc	ra,0xffff9
    80207bde:	0fc080e7          	jalr	252(ra) # 80200cd6 <printf>
               waited_pid, test_pid);
    }
    
    printf("===== 测试结束: 系统调用性能测试 =====\n");
    80207be2:	0001c517          	auipc	a0,0x1c
    80207be6:	45650513          	addi	a0,a0,1110 # 80224038 <syscall_performance_bin+0x1ec0>
    80207bea:	ffff9097          	auipc	ra,0xffff9
    80207bee:	0ec080e7          	jalr	236(ra) # 80200cd6 <printf>
    80207bf2:	60e2                	ld	ra,24(sp)
    80207bf4:	6442                	ld	s0,16(sp)
    80207bf6:	6105                	addi	sp,sp,32
    80207bf8:	8082                	ret
	...
