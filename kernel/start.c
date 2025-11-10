#include "defs.h"

// 内核测试命令表
struct CommandEntry kernel_test_table[] = {
    {"test_timer_interrupt", test_timer_interrupt},
    {"test_exception", test_exception},
    {"test_interrupt_overhead", test_interrupt_overhead},
    {"test_process", test_process_creation},
    {"test_scheduler", test_scheduler},
    {"test_synchronization", test_synchronization},
    {"test_kernel_kill", test_kill},
};

#define KERNEL_TEST_COUNT (sizeof(kernel_test_table)/sizeof(kernel_test_table[0]))

void kernel_main(void);
// start函数：内核的C语言入口
void start(){
	// 初始化内核的重要组件
	// 内存页分配器
	pmm_init();
	// 虚拟内存
	kvminit();
	// 中断和异常处理
	trap_init();
	uart_init();
	intr_on();
    // 输出操作系统启动横幅
    printf("===============================================\n");
    printf("        RISC-V Operating System v1.0         \n");
    printf("===============================================\n\n");

	init_proc(); // 初始化进程管理子系统
	int main_pid = create_kernel_proc(kernel_main);
	if (main_pid < 0){
		panic("START: create main process failed!\n");
	}
	
	schedule();
    
    // 防止返回保险
    panic("START: main() exit unexpectedly!!!\n");
}
// 显示菜单函数
void print_menu(void) {
    printf("\n=== 内核测试 ===\n");
    for (int i = 0; i < KERNEL_TEST_COUNT; i++) {
        printf("  k%d. %s\n", i+1, kernel_test_table[i].name);
    }
    
    printf("\n=== 用户测试 ===\n");
    for (int i = 0; i < USER_TEST_COUNT; i++) {
        printf("  u%d. %s\n", i+1, user_test_table[i].name);
    }
    
    printf("\n=== 基础命令 ===\n");
    printf("  h. help          - 显示此帮助\n");
    printf("  e. exit          - 退出控制台\n");
    printf("  p. ps            - 显示进程状态\n");
}

void console(void) {
    char input_buffer[256];
    int exit_requested = 0;
    print_menu();

    while (!exit_requested) {
        printf("\nConsole >>> ");
        readline(input_buffer, sizeof(input_buffer));

        if (input_buffer[0] == '\0') continue;

        // 处理基础命令
        switch(input_buffer[0]) {
            case 'e':
            case 'E':
                exit_requested = 1;
                continue;
            case 'h':
            case 'H':
                print_menu();
                continue;
            case 'p':
            case 'P':
                print_proc_table();
                continue;
        }

        // 解析测试命令
        if (input_buffer[0] == 'k' || input_buffer[0] == 'K') {
            // 内核测试
            int index = atoi(input_buffer + 1) - 1;
            if (index >= 0 && index < KERNEL_TEST_COUNT) {
                printf("\n----- 执行内核测试: %s -----\n", 
                       kernel_test_table[index].name);
                int pid = create_kernel_proc(kernel_test_table[index].func);
                if (pid < 0) {
                    printf("创建内核测试进程失败\n");
                } else {
                    printf("创建内核测试进程成功，PID: %d\n", pid);
                    int status;
                    wait_proc(&status);
                }
            } else {
                printf("无效的内核测试序号\n");
            }
        } else if (input_buffer[0] == 'u' || input_buffer[0] == 'U') {
            // 用户测试
            int index = atoi(input_buffer + 1) - 1;
            if (index >= 0 && index < USER_TEST_COUNT) {
                printf("\n----- 执行用户测试: %s -----\n", 
                       user_test_table[index].name);
                       
                int pid = create_user_proc(user_test_table[index].binary,
                                         user_test_table[index].size);
                                         
                if (pid < 0) {
                    printf("创建用户测试进程失败\n");
                } else {
                    printf("创建用户测试进程成功，PID: %d\n", pid);
                    int status;
                    wait_proc(&status);
                }
            } else {
                printf("无效的用户测试序号\n");
            }
        } else {
            printf("无效命令: %s\n", input_buffer);
            printf("输入 'h' 查看帮助\n");
        }
    }
    printf("控制台进程退出\n");
}
void kernel_main(void){
	// 内核主函数
	clear_screen();
	int console_pid = create_kernel_proc(console);
	if (console_pid < 0){
		panic("KERNEL_MAIN: create console process failed!\n");
	}else{
		printf("KERNEL_MAIN: console process created with PID %d\n", console_pid);
	}
	int status;
	int pid = wait_proc(&status);
	if(pid != console_pid){
		printf("KERNEL_MAIN: unexpected process %d exited with status %d\n", pid, status);
	}
	return;
};