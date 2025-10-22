#include "defs.h"


extern void uart_putc(char c);

static char printf_buffer[PRINTF_BUFFER_SIZE];
static int printf_buf_pos = 0;
static void flush_printf_buffer(void) {
	if (printf_buf_pos > 0) {
		printf_buffer[printf_buf_pos] = '\0'; // Null-terminate the string
		uart_puts(printf_buffer); // Send the buffer to UART
		printf_buf_pos = 0; // Reset buffer position
	}
}
static void buffer_char(char c) {
	if (printf_buf_pos < PRINTF_BUFFER_SIZE - 1) { // Leave space for null terminator
		printf_buffer[printf_buf_pos++] = c;
	} else {
		flush_printf_buffer(); // Buffer full, flush it
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
	}
}

// 小数字快速转换表（0-99）
static const char small_numbers[][4] = {
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
    "10", "11", "12", "13", "14", "15", "16", "17", "18", "19",
    "20", "21", "22", "23", "24", "25", "26", "27", "28", "29",
    "30", "31", "32", "33", "34", "35", "36", "37", "38", "39",
    "40", "41", "42", "43", "44", "45", "46", "47", "48", "49",
    "50", "51", "52", "53", "54", "55", "56", "57", "58", "59",
    "60", "61", "62", "63", "64", "65", "66", "67", "68", "69",
    "70", "71", "72", "73", "74", "75", "76", "77", "78", "79",
    "80", "81", "82", "83", "84", "85", "86", "87", "88", "89",
    "90", "91", "92", "93", "94", "95", "96", "97", "98", "99"
};

static void consputc(int c){
	// 实现到多个输出的处理，目前只有串口输出
	uart_putc(c);
}
static void consputs(const char *s){
	char *str = (char *)s;
	// 直接调用uart_puts输出字符串
	uart_puts(str);
}
static void printint(long long xx,int base,int sign){
	// 模仿xv6的printint
	static char digits[] = "0123456789abcdef";
	char buf[20]; // 增大缓冲区以处理64位整数
	int i;
	unsigned long long x;
	if (sign && (sign = xx < 0)) // 符号处理
		x = -(unsigned long long)xx; // 强制转换以避免溢出
	else
		x = xx;

	if (base == 10 && x < 100) {
		// 使用查表法处理小数字
		consputs(small_numbers[x]);
		return;
	}
	i = 0;
	do{
		buf[i] = digits[x % base];
		i++;
	}while((x/=base) !=0);
	if (sign){
		buf[i] = '-';
		i++;
	}
	i--;
	while( i>=0){
		consputc(buf[i]);
		i--;
	}
}
void printf(const char *fmt, ...) {
    va_list ap;
    int i, c;
    char *s;

    va_start(ap, fmt);
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
        if(c != '%'){
            buffer_char(c);
            continue;
        }
        flush_printf_buffer(); // 遇到格式化标志时，先刷新缓冲区
        c = fmt[++i] & 0xff;
        if(c == 0)
            break;
            
        // 检查是否有长整型标记'l'
        int is_long = 0;
        if(c == 'l') {
            is_long = 1;
            c = fmt[++i] & 0xff;
            if(c == 0)
                break;
        }
        
        switch(c){
        case 'd':
            if(is_long)
                printint(va_arg(ap, long long), 10, 1);
            else
                printint(va_arg(ap, int), 10, 1);
            break;
        case 'x':
            if(is_long)
                printint(va_arg(ap, long long), 16, 0);
            else
                printint(va_arg(ap, int), 16, 0);
            break;
        case 'u':
            if(is_long)
                printint(va_arg(ap, unsigned long long), 10, 0);
            else
                printint(va_arg(ap, unsigned int), 10, 0);
            break;
        case 'c':
            consputc(va_arg(ap, int));
            break;
        case 's':
            if((s = va_arg(ap, char*)) == 0)
                s = "(null)";
            consputs(s);
            break;
        case 'p':
            unsigned long ptr = (unsigned long)va_arg(ap, void*);
            consputs("0x");
            // 输出16位宽，不足补0
            char buf[17];
            int i;
            for (i = 0; i < 16; i++) {
                int shift = (15 - i) * 4;
                buf[i] = "0123456789abcdef"[(ptr >> shift) & 0xf];
            }
            buf[16] = '\0';
            consputs(buf);
            break;
        case 'b':
            if(is_long)
                printint(va_arg(ap, long long), 2, 0);
            else
                printint(va_arg(ap, int), 2, 0);
            break;
        case 'o':
            if(is_long)
                printint(va_arg(ap, long long), 8, 0);
            else
                printint(va_arg(ap, int), 8, 0);
            break;
        case '%':
            buffer_char('%');
            break;
        default:
            buffer_char('%');
            if(is_long) buffer_char('l');
            buffer_char(c);
            break;
        }
    }
    flush_printf_buffer(); // 最后刷新缓冲区
    va_end(ap);
}
// 清屏功能
void clear_screen(void) {
    uart_puts(CLEAR_SCREEN);
	uart_puts(CURSOR_HOME);
}

// 光标上移
void cursor_up(int lines) {
    if (lines <= 0) return;
    consputc('\033');
    consputc('[');
    printint(lines, 10, 0);
    consputc('A');
}

// 光标下移
void cursor_down(int lines) {
    if (lines <= 0) return;
    consputc('\033');
    consputc('[');
    printint(lines, 10, 0);
    consputc('B');
}

// 光标右移
void cursor_right(int cols) {
    if (cols <= 0) return;
    consputc('\033');
    consputc('[');
    printint(cols, 10, 0);
    consputc('C');
}

// 光标左移
void cursor_left(int cols) {
    if (cols <= 0) return;
    consputc('\033');
    consputc('[');
    printint(cols, 10, 0);
    consputc('D');
}
// 保存光标位置
void save_cursor(void) {
    consputc('\033');
    consputc('[');
    consputc('s');
}

// 恢复光标位置
void restore_cursor(void) {
    consputc('\033');
    consputc('[');
    consputc('u');
}

// 移动到行首
void cursor_to_column(int col) {
    if (col <= 0) col = 1;
    consputc('\033');
    consputc('[');
    printint(col, 10, 0);
    consputc('G');
}
// 光标定位到指定行列
void goto_rc(int row, int col) {
    consputc('\033');
    consputc('[');
    printint(row, 10, 0);
    consputc(';');
    printint(col, 10, 0);
    consputc('H');
}
// 颜色控制
void reset_color(void) {
	uart_puts(ESC "[0m");
}
// 设置前景色
void set_fg_color(int color) {
	if (color < 30 || color > 37) return; // 支持30-37
	consputc('\033');
	consputc('[');
	printint(color, 10, 0);
	consputc('m');
}
// 设置背景色
void set_bg_color(int color) {
	if (color < 40 || color > 47) return; // 支持40-47
	consputc('\033');
	consputc('[');
	printint(color, 10, 0);
	consputc('m');
}
// 简易文字颜色
void color_red(void) {
	set_fg_color(31); // 红色
}
void color_green(void) {
	set_fg_color(32); // 绿色
}
void color_yellow(void) {
	set_fg_color(33); // 黄色
}
void color_blue(void) {
	set_fg_color(34); // 蓝色
}
void color_purple(void) {
	set_fg_color(35); // 紫色
}
void color_cyan(void) {
	set_fg_color(36); // 青色
}
void color_reverse(void){
	set_fg_color(37); // 反色
}
void set_color(int fg, int bg) {
	set_bg_color(bg);
	set_fg_color(fg);
}
void clear_line(){
	consputc('\033');
	consputc('[');
	consputc('2');
	consputc('K');
}

void panic(const char *msg) {
	color_red(); // 可选：红色显示
	printf("panic: %s\n", msg);
	reset_color();
	while (1) { /* 死循环，防止继续执行 */ }
}
void warning(const char *fmt, ...) {
    va_list ap;
    color_purple(); // 设置紫色
    printf("[WARNING] ");
    va_start(ap, fmt);
    printf(fmt, ap);
    va_end(ap);
    reset_color(); // 恢复默认颜色
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