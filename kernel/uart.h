#ifndef UART_H
#define UART_H

void uart_init(void);
void uart_intr(void);

void uart_putc(char c);
void uart_puts(char *s);

int uart_getc(void);

#endif