#include "defs.h"

void hello_world() {
    create_user_proc(hello_world_bin,hello_world_bin_len);
	wait_proc(NULL);
}
struct CommandEntry command_table[] = {
    {"hello", hello_world, "打印Hello World"},
    {"test_proc", test_process_creation, "进程创建测试"},
    {"test_sche", test_scheduler, "调度器测试"},
    {"test_sync", test_synchronization, "同步性测试"},
	{"test_kill", test_kill,"内核下的kill测试"},
	{"test_fork", test_user_fork, "用户进程Fork测试"},
};
#define COMMAND_COUNT (sizeof(command_table)/sizeof(command_table[0]))
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

void console(void) {
    char input_buffer[256];
    int exit_requested = 0;

    printf("可用命令:\n");
    for (int i = 0; i < COMMAND_COUNT; i++) {
        printf("  %s - %s\n", command_table[i].name, command_table[i].desc);
    }
    printf("  help          - 显示此帮助\n");
    printf("  exit          - 退出控制台\n");
    printf("  ps            - 显示进程状态\n");

    while (!exit_requested) {
        printf("Console >>> ");
        readline(input_buffer, sizeof(input_buffer));

        if (strcmp(input_buffer, "exit") == 0) {
            exit_requested = 1;
        } else if (strcmp(input_buffer, "help") == 0) {
            printf("可用命令:\n");
            for (int i = 0; i < COMMAND_COUNT; i++) {
                printf("  %s - %s\n", command_table[i].name, command_table[i].desc);
            }
            printf("  help          - 显示此帮助\n");
            printf("  exit          - 退出控制台\n");
            printf("  ps            - 显示进程状态\n");
        } else if (strcmp(input_buffer, "ps") == 0) {
            print_proc_table();
        } else {
            int found = 0;
            for (int i = 0; i < COMMAND_COUNT; i++) {
                if (strcmp(input_buffer, command_table[i].name) == 0) {
                    int pid = create_kernel_proc(command_table[i].func);
                    if (pid < 0) {
                        printf("创建%s进程失败\n", command_table[i].name);
                    } else {
                        printf("创建%s进程成功，PID: %d\n", command_table[i].name, pid);
                        int status;
                        int waited_pid = wait_proc(&status);
                        if (waited_pid == pid) {
                            printf("%s进程(PID: %d)已退出，状态码: %d\n", command_table[i].name, pid, status);
                        } else {
                            printf("等待%s进程时发生错误\n", command_table[i].name);
                        }
                    }
                    found = 1;
                    break;
                }
            }
            if (!found && input_buffer[0] != '\0') {
                printf("无效命令: %s\n", input_buffer);
            }
        }
    }
    printf("控制台进程退出\n");
    return;
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