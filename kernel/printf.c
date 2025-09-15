#include "printf.h"
#include "stdarg.h"
#include "uart.h"
#define ESC "\033"
#define CLEAR_SCREEN ESC "[2J"
#define CURSOR_HOME ESC "[H"
#define PRINTF_BUFFER_SIZE 128
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
        switch(c){
        case 'd':
            printint(va_arg(ap, int), 10, 1);
            break;
        case 'x':
            printint(va_arg(ap, int), 16, 0);
            break;
        case 'u':
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
        case '%':
            buffer_char('%');
            break;
        default:
			buffer_char('%');
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
void color_white(void){
	set_fg_color(37); // 白色
}
void set_color(int fg, int bg) {
	set_fg_color(fg);
	set_bg_color(bg);
}
void clear_line(){
	consputc('\033');
	consputc('[');
	consputc('2');
	consputc('K');
}