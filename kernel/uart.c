#include "defs.h"
#define LINE_BUF_SIZE 128
struct uart_input_buf_t uart_input_buf;

static void uart_intr(void);
// UART初始化函数
void uart_init(void) {

    WriteReg(IER, 0x00);
    WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    WriteReg(IER, IER_RX_ENABLE);
    register_interrupt(UART0_IRQ, uart_intr);//注册键盘输入的中断处理函数
    enable_interrupts(UART0_IRQ);
    printf("UART initialized with input support\n");
}

// 发送单个字符
void uart_putc(char c) {
    // 等待发送缓冲区空闲
    while((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    WriteReg(THR, c);
}

void uart_puts(char *s) {
    if (!s) return;
    
    while (*s) {
        while ((ReadReg(LSR) & LSR_TX_IDLE) == 0);
        int sent_count = 0;
        while (*s && sent_count < 4) { 
            WriteReg(THR, *s);
            s++;
            sent_count++;
        }
    }
}

static void uart_intr(void) {
    static char linebuf[LINE_BUF_SIZE];
    static int line_len = 0;
    static int in_escape = 0;  // 标记是否在转义序列中

    while (ReadReg(LSR) & LSR_RX_READY) {
        char c = ReadReg(RHR);
        
        // 处理转义序列 - 简单忽略
        if (in_escape) {
            // 如果是转义序列的结束字符（通常是字母），则退出转义模式
            if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || c == '~') {
                in_escape = 0;
            }
            continue; // 忽略转义序列中的所有字符
        }
        
        if (c == 0x1b) { // ESC 开始转义序列
            in_escape = 1;
            continue;
        }
        
        // 处理可识别的控制字符
        if (c == 0x0c) { // Ctrl+L 清屏
            clear_screen();
            if (myproc()->pid == 1) { 
                printf("Console >>> ");
            }
            continue;
        }
        
        if (c == 0x03) { // Ctrl+C 
            warning("Ctrl+C to Crash\n");
            asm volatile (
                "li a7, 8\n"
                "ecall\n"
            );
            while(1);
        }
        
        if (c == '\r' || c == '\n') { // 回车/换行
            uart_putc('\n');
            // 将编辑好的整行写入全局缓冲区
            for (int i = 0; i < line_len; i++) {
                int next = (uart_input_buf.w + 1) % INPUT_BUF_SIZE;
                if (next != uart_input_buf.r) {
                    uart_input_buf.buf[uart_input_buf.w] = linebuf[i];
                    uart_input_buf.w = next;
                }
            }
            // 写入换行符
            int next = (uart_input_buf.w + 1) % INPUT_BUF_SIZE;
            if (next != uart_input_buf.r) {
                uart_input_buf.buf[uart_input_buf.w] = '\n';
                uart_input_buf.w = next;
            }
            line_len = 0;
        } else if (c == 0x7f || c == 0x08) { // 退格键
            if (line_len > 0) {
                uart_putc('\b');
                uart_putc(' ');
                uart_putc('\b');
                line_len--;
            }
        } else if (c == '\t') { // Tab 键
            // 可以选择处理制表符或转换为空格
            if (line_len < LINE_BUF_SIZE - 1) {
                uart_putc(' ');  // 显示为空格
                linebuf[line_len++] = ' ';  // 存储为空格
            }
        } else if (c >= 0x20 && c <= 0x7E && line_len < LINE_BUF_SIZE - 1) {
            // 只接收可打印的 ASCII 字符 (空格到 ~)
            uart_putc(c);
            linebuf[line_len++] = c;
        }
        // 忽略所有其他字符（包括方向键产生的转义序列）
    }
}
// 阻塞式读取一个字符
char uart_getc_blocking(void) {
    // 等待直到有字符可读
    while (uart_input_buf.r == uart_input_buf.w) {
        // 在实际系统中，这里可能需要让进程睡眠
        // 但目前我们使用简单的轮询
        asm volatile("nop");
    }
    
    // 读取字符
    char c = uart_input_buf.buf[uart_input_buf.r];
    uart_input_buf.r = (uart_input_buf.r + 1) % INPUT_BUF_SIZE;
    return c;
}
// 读取一行输入，最多读取max-1个字符，并在末尾添加\0
int readline(char *buf, int max) {
    int i = 0;
    char c;
    
    while (i < max - 1) {
        c = uart_getc_blocking();
        
        if (c == '\n') {
            buf[i] = '\0';
            return i;
        } else {
            buf[i++] = c;
        }
    }
    
    // 缓冲区满，添加\0并返回
    buf[max-1] = '\0';
    return max-1;
}