void uart_putc(char c);
void uart_puts(char *s);
// 全局变量测试BSS段清零
int global_test1;
int global_test2;
int buffer[10];
int initialized_global = 123;

// 清屏函数：发送ANSI转义序列
void clear_screen() {
    // ANSI 转义序列：清屏并将光标移到左上角
    uart_puts("\033[2J");      // 清屏
    uart_puts("\033[H");       // 光标移到左上角 (1,1)
}

// start函数：内核的C语言入口
void start(){
    //// 进入操作系统后立即清屏
    clear_screen();
    // 输出操作系统启动横幅
    uart_puts("===============================================\n");
    uart_puts("        RISC-V Operating System v1.0         \n");
    uart_puts("===============================================\n\n");
    
    // 测试UART输出
    uart_puts("Hello, RISC-V Kernel!\n");
    uart_puts("Kernel startup complete!\n");
    
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
    
    uart_puts("\nSystem ready. Entering main loop...\n");
    uart_puts("Press Ctrl+A then X to exit QEMU\n\n");
    
    // 主循环
    while(1) {
        // 死循环，防止返回
    }
    
    // 双重保险
    uart_puts("NEVER REACH HERE!\n");
    while(1); 
}