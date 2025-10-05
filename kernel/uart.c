// 串口驱动

#include "types.h"
#include "memlayout.h"
#include "trap.h"
#include "printf.h"
#include "uart.h"

#define Reg(reg) ((volatile unsigned char *)(UART0 + (reg)))

// 寄存器定义
#define RHR 0      // 接收保持寄存器 (读取)
#define THR 0      // 发送保持寄存器 (写入)
#define IER 1      // 中断使能寄存器
#define FCR 2      // FIFO控制寄存器
#define LSR 5      // 线路状态寄存器

// 状态位定义
#define LSR_TX_IDLE (1<<5)     // 标记发送保持寄存器可以接受下一个字符
#define LSR_RX_READY (1<<0)    // 标记接收缓冲区有数据

// 中断使能位
#define IER_RX_ENABLE (1<<0)   // 接收中断使能
#define IER_TX_ENABLE (1<<1)   // 发送中断使能

// FIFO控制位
#define FCR_FIFO_ENABLE (1<<0) // FIFO使能
#define FCR_FIFO_CLEAR (3<<1)  // 清除FIFO

#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))


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
        uart_putc(c);
    }
}
