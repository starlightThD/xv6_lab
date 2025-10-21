#include "defs.h"
struct uart_input_buf_t uart_input_buf;
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

int uart_getc(void) {
    if ((ReadReg(LSR) & LSR_RX_READY) == 0)
        return -1; 
    return ReadReg(RHR); 
}

// UART中断处理函数
void uart_intr(void) {
    while (ReadReg(LSR) & LSR_RX_READY) {
        char c = ReadReg(RHR);
        
        // 回显接收的字符
        uart_putc(c);
        
        // 特殊字符处理
        if (c == '\r') {
            uart_putc('\n'); // 将回车转换为换行符并回显
            c = '\n';
        }
        
        // 缓冲区满检查
        int next = (uart_input_buf.w + 1) % INPUT_BUF_SIZE;
        if (next != uart_input_buf.r) {
            // 缓冲区未满，存储字符
            uart_input_buf.buf[uart_input_buf.w] = c;
            uart_input_buf.w = next;
        }
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