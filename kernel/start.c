#include "printf.h"
#include "pm.h"
#include "vm.h"

void uart_putc(char c);
void uart_puts(char *s);

void test_printf_precision(void);
void test_curse_move(void);
void test_basic_colors(void);
void clear_screen(void);
// 全局变量测试BSS段清零
int global_test1;
int global_test2;
int buffer[10];
int initialized_global = 123;
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
    // 验证BSS段是否被正确清零
    uart_puts("Testing BSS zero initialization:\n");
    if (global_test1 == 0 && global_test2 == 0) {
        uart_puts("  [OK] BSS variables correctly zeroed\n");
    } else {
        uart_puts("  [ERROR] BSS variables not zeroed!\n");
    }
    
    // 验证初始化变量
    if (initialized_global == 123) {
        uart_puts("  [OK] Initialized variables working\n");
    } else {
        uart_puts("  [ERROR] Initialized variables corrupted!\n");
    }
    test_physical_memory();
	test_pagetable();
    uart_puts("\nSystem ready. Entering main loop...\n");
    test_printf_precision();
	test_curse_move();
	test_basic_colors();
	clear_screen();
    // 主循环
    while(1) {
        // 死循环，防止返回
    }
    
    // 双重保险
    uart_puts("NEVER REACH HERE!\n");
    while(1); 
}
