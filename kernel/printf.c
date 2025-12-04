#include "defs.h"

extern void uart_putc(char c);

static char printf_buffer[PRINTF_BUFFER_SIZE];
static int printf_buf_pos = 0;\

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
void set_fg_color(color_t color) {
	int code = 30 + color;
	if (code < 30 || code > 37) return; // 支持30-37
	consputc('\033');
	consputc('[');
	printint(code, 10, 0,0,0);
	consputc('m');
}
// 设置背景色
void set_bg_color(color_t color) {
	int code = 30 + color;
	if (code < 40 || code > 47) return; // 支持40-47
	consputc('\033');
	consputc('[');
	printint(code, 10, 0,0,0);
	consputc('m');
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
    set_fg_color(CYAN); // 调试信息用青色
    printf("[DEBUG] ");
    va_start(ap, fmt);
    vprintf(fmt, ap);
    va_end(ap);
    reset_color();
#endif
}
void panic(const char *fmt, ...) {
    va_list ap;
    set_fg_color(RED); // 红色显示
    printf("[PANIC] ");
    va_start(ap, fmt);
    vprintf(fmt, ap);
    va_end(ap);
    reset_color();
    while (1) { /* 死循环，防止继续执行 */ }
}
void warning(const char *fmt, ...) {
    va_list ap;
    set_fg_color(PURPLE); // 设置紫色
    printf("[WARNING] ");
    va_start(ap, fmt);
    vprintf(fmt, ap);
    va_end(ap);
    reset_color(); // 恢复默认颜色
}