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

static void consputc(int c){
	// 实现到多个输出的处理，目前只有串口输出
	uart_putc(c);
}
static void consputs(const char *s){
	char *str = (char *)s;
	// 直接调用uart_puts输出字符串
	uart_puts(str);
}
static void printint(long long xx, int base, int sign, int width, int padzero){
    static char digits[] = "0123456789abcdef";
    char buf[32];
    int i = 0;
    unsigned long long x;

    if (sign && (sign = xx < 0))
        x = -(unsigned long long)xx;
    else
        x = xx;

    do {
        buf[i++] = digits[x % base];
    } while ((x /= base) != 0);

    if (sign)
        buf[i++] = '-';

    // 计算需要补的填充字符数
    int pad = width - i;
    while (pad-- > 0) {
        consputc(padzero ? '0' : ' ');
    }

    while (--i >= 0)
        consputc(buf[i]);
}
void vprintf(const char *fmt, va_list ap) {
    int i, c;
    char *s;

    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
        if(c != '%'){
            buffer_char(c);
            continue;
        }
        flush_printf_buffer();
        int padzero = 0, width = 0;
        c = fmt[++i] & 0xff;
        if (c == '0') {
            padzero = 1;
            c = fmt[++i] & 0xff;
        }
        while (c >= '0' && c <= '9') {
            width = width * 10 + (c - '0');
            c = fmt[++i] & 0xff;
        }
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
                printint(va_arg(ap, long long), 10, 1, width, padzero);
            else
                printint(va_arg(ap, int), 10, 1, width, padzero);
            break;
        case 'x':
            if(is_long)
                printint(va_arg(ap, long long), 16, 0, width, padzero);
            else
                printint(va_arg(ap, int), 16, 0, width, padzero);
            break;
        case 'u':
            if(is_long)
                printint(va_arg(ap, unsigned long long), 10, 0, width, padzero);
            else
                printint(va_arg(ap, unsigned int), 10, 0, width, padzero);
            break;
        case 'c':
            consputc(va_arg(ap, int));
            break;
        case 's':
            if((s = va_arg(ap, char*)) == 0)
                s = "(null)";
            consputs(s);
            break;
        case 'p': {
            unsigned long ptr = (unsigned long)va_arg(ap, void*);
            consputs("0x");
            char buf[17];
            int i;
            for (i = 0; i < 16; i++) {
                int shift = (15 - i) * 4;
                buf[i] = "0123456789abcdef"[(ptr >> shift) & 0xf];
            }
            buf[16] = '\0';
            consputs(buf);
            break;
        }
        case 'b':
            if(is_long)
                printint(va_arg(ap, long long), 2, 0, width, padzero);
            else
                printint(va_arg(ap, int), 2, 0, width, padzero);
            break;
        case 'o':
            if(is_long)
                printint(va_arg(ap, long long), 8, 0, width, padzero);
            else
                printint(va_arg(ap, int), 8, 0, width, padzero);
            break;
        case '%':
            buffer_char('%');
            break;
        default:
            buffer_char('%');
            if(padzero) buffer_char('0');
            if(width) buffer_char('0' + width);
            if(is_long) buffer_char('l');
            buffer_char(c);
            break;
        }
    }
    flush_printf_buffer();
}
void printf(const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    vprintf(fmt, ap);
    va_end(ap);
}
// 内部辅助：将数字转为字符串（支持10/16/8/2进制）
static int int_to_str(char *buf, unsigned long long x, int base, int sign) {
    static char digits[] = "0123456789abcdef";
    char tmp[32];
    int i = 0, len = 0;
    if (sign && (long long)x < 0) {
        x = -(long long)x;
        buf[len++] = '-';
    }
    do {
        tmp[i++] = digits[x % base];
        x /= base;
    } while (x);
    while (i > 0)
        buf[len++] = tmp[--i];
    buf[len] = '\0';
    return len;
}

int vsnprintf(char *buf, size_t size, const char *fmt, va_list ap) {
    size_t pos = 0;
    int i, c;
    char *s;
    for (i = 0; (c = fmt[i] & 0xff) != 0 && pos + 1 < size; i++) {
        if (c != '%') {
            buf[pos++] = c;
            continue;
        }
        int padzero = 0, width = 0, is_long = 0;
        c = fmt[++i] & 0xff;
        if (c == '0') {
            padzero = 1;
            c = fmt[++i] & 0xff;
        }
        while (c >= '0' && c <= '9') {
            width = width * 10 + (c - '0');
            c = fmt[++i] & 0xff;
        }
        if (c == 'l') {
            is_long = 1;
            c = fmt[++i] & 0xff;
            if (c == 0) break;
        }
        char numbuf[32];
        int nlen = 0;
        switch (c) {
        case 'd':
            if (is_long)
                nlen = int_to_str(numbuf, va_arg(ap, long long), 10, 1);
            else
                nlen = int_to_str(numbuf, va_arg(ap, int), 10, 1);
            break;
        case 'x':
            if (is_long)
                nlen = int_to_str(numbuf, va_arg(ap, long long), 16, 0);
            else
                nlen = int_to_str(numbuf, va_arg(ap, int), 16, 0);
            break;
        case 'u':
            if (is_long)
                nlen = int_to_str(numbuf, va_arg(ap, unsigned long long), 10, 0);
            else
                nlen = int_to_str(numbuf, va_arg(ap, unsigned int), 10, 0);
            break;
        case 'o':
            if (is_long)
                nlen = int_to_str(numbuf, va_arg(ap, long long), 8, 0);
            else
                nlen = int_to_str(numbuf, va_arg(ap, int), 8, 0);
            break;
        case 'b':
            if (is_long)
                nlen = int_to_str(numbuf, va_arg(ap, long long), 2, 0);
            else
                nlen = int_to_str(numbuf, va_arg(ap, int), 2, 0);
            break;
        case 'c':
            numbuf[0] = va_arg(ap, int);
            nlen = 1;
            break;
        case 's':
            s = va_arg(ap, char*);
            if (!s) s = "(null)";
            nlen = 0;
            while (s[nlen] && pos + nlen + 1 < size)
                buf[pos + nlen] = s[nlen], nlen++;
            pos += nlen;
            continue;
        case 'p': {
            unsigned long ptr = (unsigned long)va_arg(ap, void*);
            char pbuf[18] = "0x";
            int pi = 2;
            for (int j = 0; j < 16; j++) {
                int shift = (15 - j) * 4;
                pbuf[pi++] = "0123456789abcdef"[(ptr >> shift) & 0xf];
            }
            pbuf[pi] = '\0';
            nlen = pi;
            for (int j = 0; j < nlen && pos + 1 < size; j++)
                buf[pos++] = pbuf[j];
            continue;
        }
        case '%':
            numbuf[0] = '%';
            nlen = 1;
            break;
        default:
            numbuf[0] = '%';
            numbuf[1] = c;
            nlen = 2;
            break;
        }
        // 宽度和填充
        int pad = width - nlen;
        while (pad-- > 0 && pos + 1 < size)
            buf[pos++] = padzero ? '0' : ' ';
        for (int j = 0; j < nlen && pos + 1 < size; j++)
            buf[pos++] = numbuf[j];
    }
    buf[pos] = '\0';
    return pos;
}

int snprintf(char *buf, size_t size, const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    int ret = vsnprintf(buf, size, fmt, ap);
    va_end(ap);
    return ret;
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
    printint(lines, 10, 0, 0,0);
    consputc('A');
}

// 光标下移
void cursor_down(int lines) {
    if (lines <= 0) return;
    consputc('\033');
    consputc('[');
    printint(lines, 10, 0, 0,0);
    consputc('B');
}

// 光标右移
void cursor_right(int cols) {
    if (cols <= 0) return;
    consputc('\033');
    consputc('[');
    printint(cols, 10, 0,0,0);
    consputc('C');
}

// 光标左移
void cursor_left(int cols) {
    if (cols <= 0) return;
    consputc('\033');
    consputc('[');
    printint(cols, 10, 0,0,0);
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
    printint(col, 10, 0,0,0);
    consputc('G');
}
// 光标定位到指定行列
void goto_rc(int row, int col) {
    consputc('\033');
    consputc('[');
    printint(row, 10, 0,0,0);
    consputc(';');
    printint(col, 10, 0,0,0);
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
	printint(color, 10, 0,0,0);
	consputc('m');
}
// 设置背景色
void set_bg_color(int color) {
	if (color < 40 || color > 47) return; // 支持40-47
	consputc('\033');
	consputc('[');
	printint(color, 10, 0,0,0);
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
void debug(const char *fmt, ...) {
#if DEBUG
    va_list ap;
    color_cyan(); // 调试信息用青色
    printf("[DEBUG] ");
    va_start(ap, fmt);
    vprintf(fmt, ap);
    va_end(ap);
    reset_color();
#endif
}
void panic(const char *fmt, ...) {
    va_list ap;
    color_red(); // 红色显示
    printf("[PANIC] ");
    va_start(ap, fmt);
    vprintf(fmt, ap);
    va_end(ap);
    reset_color();
    while (1) { /* 死循环，防止继续执行 */ }
}
void warning(const char *fmt, ...) {
    va_list ap;
    color_purple(); // 设置紫色
    printf("[WARNING] ");
    va_start(ap, fmt);
    vprintf(fmt, ap);
    va_end(ap);
    reset_color(); // 恢复默认颜色
}
void test_printf_precision(void) {
	clear_screen();
    printf("=== 详细的printf测试 ===\n");
    
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
	printf("=== printf测试结束 ===\n");
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