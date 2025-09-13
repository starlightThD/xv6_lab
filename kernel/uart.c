// 串口驱动

#define UART0 0x10000000
#define Reg(reg) ((volatile unsigned char *)(UART0 + (reg)))
#define THR 0                 // transmit holding register (for output bytes)
#define LSR 5                 // line status register
#define LSR_TX_IDLE (1<<5)    // THR can accept another character to send

#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))

// 先实现最基本的字符输出
void uart_putc(char c)
{
  // 等待发送缓冲区空闲
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    ;
  // 写入字符到发送寄存器
  WriteReg(THR, c);
}

// 成功后实现字符串输出
void uart_puts(char *s)
{
  while(*s) {
    uart_putc(*s);
    s++;
  }
}