#include "../kernel/syscall.h"
#include "user_lib.h"

int main() {
    char message[256];  // 用于构建消息的缓冲区
    
    // 1. 创建子进程
    sys_printstr("\n----- 测试: 强制终止子进程 -----\n");
    int child = sys_fork();
    
    if(child == 0) {
        // 子进程：执行较长的计数任务
        int my_pid = sys_pid();
        usr_build_string_with_int(message,
            "[子进程 PID: ", my_pid, "] 开始执行长任务...\n");
        sys_printstr(message);

        int count = 1000000;  // 一个较大的数值
        while(count > 0) {
            count--;
            if(count % 100000 == 0) {  // 定期报告进度
                usr_build_string_with_int(message,
                    "[子进程] 剩余计数: ", count, "\n");
                sys_printstr(message);
                sys_yield();  // 让出CPU
            }
        }
        
        // 正常情况下不应该执行到这里
        sys_printstr("[子进程] 任务完成（不应该看到这条消息）\n");
        sys_exit(0);
    } else {
        // 父进程：等待一段时间后终止子进程
        usr_build_string_with_int(message,
            "[父进程] 创建子进程 PID: ", child, "\n");
        sys_printstr(message);
        
        // 等待一小段时间
        int wait_count = 10000;
        while(wait_count--) {
            if(wait_count % 1000 == 0) {
                sys_yield();
            }
        }
        
        // 发送终止信号
        usr_build_string_with_int(message,
            "[父进程] 终止子进程 PID: ", child, "\n");
        sys_printstr(message);
        sys_kill(child);
        
        // 等待子进程退出并检查状态
        int status = 0;
        int waited_pid = sys_wait(&status);
        
        usr_build_string_with_two_ints(message,
            "[父进程] 子进程 PID: ", waited_pid,
            " 已退出，状态码: ", status, "\n");
        sys_printstr(message);
        
        // 验证退出状态
        if(status == SYS_kill) { 
            sys_printstr("测试通过：子进程被成功终止\n");
        } else {
            sys_printstr("测试失败：子进程非正常终止\n");
        }
        sys_exit(0);
    }
    return 0;
}