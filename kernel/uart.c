// 串口驱动

#define UART0 0x10000000		// UART寄存器基地址
#define Reg(reg) ((volatile unsigned char *)(UART0 + (reg)))
#define THR 0      	// 发送保持寄存器
#define LSR 5        	// 线路状态寄存器
#define LSR_TX_IDLE (1<<5)    	// 标记发送保持寄存器可以接受下一个字符

#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))


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
    if (!s) return;
    
    while (*s) {
        // 批量检查：一次等待，发送多个字符
        while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
            ;
            
        // 连续发送字符，直到缓冲区可能满或字符串结束
        int sent_count = 0;
        while (*s && sent_count < 4) {  // 假设FIFO深度至少为4
            WriteReg(THR, *s);
            s++;
            sent_count++;
        }
    }
}