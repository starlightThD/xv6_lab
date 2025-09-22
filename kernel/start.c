#include "printf.h"

void uart_putc(char c);
void uart_puts(char *s);

void test_printf_precision(void);
void test_curse_move(void);
void test_basic_colors(void);
void clear_screen(void);
// 全局变量测试BSS段清零
int global_test1;
int global_test2;
int buffer[10];
int initialized_global = 123;
// start函数：内核的C语言入口
void start(){
    //// 进入操作系统后立即清屏
    //clear_screen();
    // 输出操作系统启动横幅
    uart_puts("===============================================\n");
    uart_puts("        RISC-V Operating System v1.0         \n");
    uart_puts("===============================================\n\n");
    
    // 测试UART输出
    uart_puts("Hello, RISC-V Kernel!\n");
    uart_puts("Kernel startup complete!\n");
    
    // 验证BSS段是否被正确清零
    uart_puts("Testing BSS zero initialization:\n");
    if (global_test1 == 0 && global_test2 == 0) {
        uart_puts("  [OK] BSS variables correctly zeroed\n");
    } else {
        uart_puts("  [ERROR] BSS variables not zeroed!\n");
    }
    
    // 验证初始化变量
    if (initialized_global == 123) {
        uart_puts("  [OK] Initialized variables working\n");
    } else {
        uart_puts("  [ERROR] Initialized variables corrupted!\n");
    }
    
    uart_puts("\nSystem ready. Entering main loop...\n");

	// 测试printf模块
	clear_screen();
	test_printf_precision();
	test_curse_move();
	test_basic_colors();
    
    // 主循环
    while(1) {
        // 死循环，防止返回
    }
    
    // 双重保险
    uart_puts("NEVER REACH HERE!\n");
    while(1); 
}

void test_printf_precision(void) {
	clear_screen();
    printf("=== 详细的Printf测试 ===\n");
    
    // 测试十六进制格式
    printf("十六进制测试:\n");
    printf("  255 = 0x%x (expected: ff)\n", 255);
    printf("  4096 = 0x%x (expected: 1000)\n", 4096);
    printf("  0x1234abcd = 0x%x\n", 0x1234abcd);
    
    // 测试十进制格式  
    printf("十进制测试:\n");
    printf("  正数: %d\n", 42);
    printf("  负数: %d\n", -42);
    printf("  零: %d\n", 0);
    printf("  大数: %d\n", 123456789);
    
    // 测试无符号格式
    printf("无符号测试:\n");
    printf("  大无符号数：%u\n", 4294967295U);
    printf("  零：%u\n", 0U);
	printf("  小无符号数：%u\n", 12345U);

	// 测试边界
	printf("边界测试:\n");
	printf("  INT_MAX: %d\n", 2147483647);
	printf("  INT_MIN: %d\n", -2147483648);
	printf("  UINT_MAX: %u\n", 4294967295U);
	printf(" -1 as unsigned: %u\n", (unsigned int)-1);
    
    // 测试字符串边界情况
    printf("字符串测试:\n");
    printf("  空字符串: '%s'\n", "");
    printf("  单字符: '%s'\n", "X");
    printf("  长字符串: '%s'\n", "This is a longer test string");
	printf("  非常长字符串： '%s'\n", "Formal version: Entities should not be multiplied beyond necessity.\nPlain English: If two or more explanations fit the facts equally well, choose the simplest one.\nScientific phrasing: When multiple hypotheses explain the same observation, the simplest hypothesis that requires the fewest assumptions is most likely to be correct.");
	
	// 测试混合格式
	printf("混合格式测试:\n");
	printf("  Hex: 0x%x, Dec: %d, Unsigned: %u\n", 255, -255, 255U);
	
	// 测试百分号输出
	printf("百分号输出测试:\n");
	printf("  100%% 完成!\n");
	
	// 测试NULL字符串
	char *null_str = 0;
	printf("NULL字符串测试:\n");
	printf("  NULL as string: '%s'\n", null_str);
	
	// 测试指针格式
	int var = 42;
	printf("指针测试:\n");
	printf("  Address of var: %p\n", &var);
	
	// 测试负数的无符号输出
	printf("负数无符号输出测试:\n");
	printf("  -1 as unsigned: %u\n", (unsigned int)-1);
	
	// 测试不同进制的数字
	printf("不同进制测试:\n");
	printf("  Binary of 5: %b\n", 5);
	printf("  Octal of 8 : %o\n", 8); 
	printf("=== Printf测试结束 ===\n");
}
void test_curse_move(){
	clear_screen(); // 清屏
	printf("=== 光标移动测试 ===\n");
	for (int i = 3; i <= 7; i++) {
		for (int j = 1; j <= 10; j++) {
			goto_rc(i, j);
			printf("*");
		}
	}
	goto_rc(9, 1);
	save_cursor();
	// 光标移动测试
	cursor_up(5);
	cursor_right(2);
	printf("+++++");
	cursor_down(2);
	cursor_left(5);
	printf("-----");
	restore_cursor();
	printf("=== 光标移动测试结束 ===\n");
}
void test_basic_colors(void) {
    clear_screen();
    printf("=== 基本颜色测试 ===\n\n");
    
    // 测试基本前景色
    printf("前景色测试:\n");
    color_red();    printf("红色文字 ");
    color_green();  printf("绿色文字 ");
    color_yellow(); printf("黄色文字 ");
    color_blue();   printf("蓝色文字 ");
    color_purple(); printf("紫色文字 ");
    color_cyan();   printf("青色文字 ");
    color_reverse();  printf("反色文字");
    reset_color();
    printf("\n\n");
    
    // 测试背景色
    printf("背景色测试:\n");
    set_bg_color(41); printf(" 红色背景 "); reset_color();
    set_bg_color(42); printf(" 绿色背景 "); reset_color();
    set_bg_color(43); printf(" 黄色背景 "); reset_color();
    set_bg_color(44); printf(" 蓝色背景 "); reset_color();
	set_bg_color(47); printf(" 反色背景 "); reset_color();
    printf("\n\n");
    
    // 测试组合效果
    printf("组合效果测试:\n");
    set_color(31, 44); printf(" 红字蓝底 "); reset_color();
    set_color(33, 45); printf(" 黄字紫底 "); reset_color();
    set_color(32, 47); printf(" 绿字反底 "); reset_color();
    printf("\n\n");
	reset_color();
	printf("重置为默认颜色，本行文字会被清除\n"); 
	cursor_up(1); // 光标上移一行
	clear_line();

	printf("=== 颜色测试结束 ===\n");
}