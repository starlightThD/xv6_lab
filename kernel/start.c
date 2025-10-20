#include "printf.h"
#include "pm.h"
#include "vm.h"
#include "riscv.h"
#include "trap.h"
#include "uart.h"
#include "proc.h"

void uart_putc(char c);
void uart_puts(char *s);

void test_printf_precision(void);
void test_curse_move(void);
void test_basic_colors(void);
void clear_screen(void);
// start函数：内核的C语言入口
void start(){
	// 初始化内核的重要组件
	// 内存页分配器
	pmm_init();
	// 虚拟内存
	printf("[VP TEST] 尝试启用分页模式\n");
	kvminit();
    kvminithart();
    // 进入操作系统后立即清屏
    clear_screen();
    // 输出操作系统启动横幅
    uart_puts("===============================================\n");
    uart_puts("        RISC-V Operating System v1.0         \n");
    uart_puts("===============================================\n\n");
    printf("[VP TEST] 当前已启用分页模式\n");

	trap_init();
    uart_puts("\nSystem ready. Entering main loop...\n");
	// 允许中断
    intr_on();
	test_timer_interrupt();
	printf("[KERNEL] Timer interrupt test finished!\n");
	test_exception();
	printf("[KERNEL] Exception test finished!\n");
	test_proc_functions();
	test_proc_manager();
	printf("[KERNEL] Process manager test finished!\n");
	uart_init();
	printf("外部中断：键盘输入已经注册，请尝试输入字符并观察UART输出\n");
    // 主循环
	while(1){
	}
    
    // 双重保险
    uart_puts("NEVER REACH HERE!\n");
    while(1); 
}
