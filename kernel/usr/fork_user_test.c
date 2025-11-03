#include "../syscall.h"
#include "user_lib.h"

int main() {
    char message[256];  // 用于构建消息的缓冲区
    int my_pid = sys_pid();
    int my_ppid = sys_ppid();
    
    usr_build_string_with_two_ints(message, "=== Initial process: pid=", my_pid, " ppid=", my_ppid, " ===\n");
    sys_printstr(message);
    
    // 第一层：父进程创建两个子进程
    int child1 = sys_fork();
    if (child1 == 0) {
        // 第一个子进程
        int my_pid = sys_pid();
        int my_ppid = sys_ppid();
        usr_build_string_with_two_ints(message, "[L1-Child1] pid=", my_pid, " ppid=", my_ppid, " started\n");
        sys_printstr(message);
        
        // 第二层：第一个子进程创建两个孙进程
        int grandchild1 = sys_fork();
        if (grandchild1 == 0) {
            // 第一个孙进程
            int my_pid = sys_pid();
            int my_ppid = sys_ppid();
            usr_build_string_with_two_ints(message, "[L2-GChild1] pid=", my_pid, " ppid=", my_ppid, " working\n");
            sys_printstr(message);
            sys_exit(0);  // 正常退出
        } else if (grandchild1 > 0) {
            int grandchild2 = sys_fork();
            if (grandchild2 == 0) {
                // 第二个孙进程
                int my_pid = sys_pid();
                int my_ppid = sys_ppid();
                usr_build_string_with_two_ints(message, "[L2-GChild2] pid=", my_pid, " ppid=", my_ppid, " working\n");
                sys_printstr(message);
                sys_exit(0);  // 正常退出
            } else if (grandchild2 > 0) {
                // 第一个子进程等待两个孙进程
                usr_build_string_with_two_ints(message, "[L1-Child1] created grandchildren: ", grandchild1, " and ", grandchild2, ", waiting...\n");
                sys_printstr(message);
                
                int waited1 = sys_wait(NULL);
                usr_build_string_with_int(message, "child ", waited1, " exit\n");
                sys_printstr(message);
                
                int waited2 = sys_wait(NULL);
                usr_build_string_with_int(message, "child ", waited2, " exit\n");
                sys_printstr(message);
                
                sys_exit(0);  // 正常退出
            } else {
                sys_printstr("[L1-Child1] fork grandchild2 failed\n");
            }
        } else {
            sys_printstr("[L1-Child1] fork grandchild1 failed\n");
        }
    } else if (child1 > 0) {
        // 父进程继续创建第二个子进程
        int child2 = sys_fork();
        if (child2 == 0) {
            // 第二个子进程
            int my_pid = sys_pid();
            int my_ppid = sys_ppid();
            usr_build_string_with_two_ints(message, "[L1-Child2] pid=", my_pid, " ppid=", my_ppid, " started\n");
            sys_printstr(message);
            
            // 第二层：第二个子进程创建两个孙进程
            int grandchild3 = sys_fork();
            if (grandchild3 == 0) {
                // 第三个孙进程
                int my_pid = sys_pid();
                int my_ppid = sys_ppid();
                usr_build_string_with_two_ints(message, "[L2-GChild3] pid=", my_pid, " ppid=", my_ppid, " working\n");
                sys_printstr(message);
                sys_exit(0);  // 无法替换为return 0?
            } else if (grandchild3 > 0) {
                int grandchild4 = sys_fork();
                if (grandchild4 == 0) {
                    // 第四个孙进程
                    int my_pid = sys_pid();
                    int my_ppid = sys_ppid();
                    usr_build_string_with_two_ints(message, "[L2-GChild4] pid=", my_pid, " ppid=", my_ppid, " working\n");
                    sys_printstr(message);
                    sys_exit(0);  // 无法替换为return 0?
                } else if (grandchild4 > 0) {
                    // 第二个子进程等待两个孙进程
                    usr_build_string_with_two_ints(message, "[L1-Child2] created grandchildren: ", grandchild3, " and ", grandchild4, ", waiting...\n");
                    sys_printstr(message);
                    
                    int waited3 = sys_wait(NULL);
                    usr_build_string_with_int(message, "child ", waited3, " exit\n");
                    sys_printstr(message);
                    
                    int waited4 = sys_wait(NULL);
                    usr_build_string_with_int(message, "child ", waited4, " exit\n");
                    sys_printstr(message);
                    
                    sys_exit(0);  // 无法替换为return 0?
                } else {
                    sys_printstr("[L1-Child2] fork grandchild4 failed\n");
                }
            } else {
                sys_printstr("[L1-Child2] fork grandchild3 failed\n");
                
            }
        } else if (child2 > 0) {
            // 父进程等待两个子进程
            usr_build_string_with_two_ints(message, "[L0-Parent] created children: ", child1, " and ", child2, ", waiting...\n");
            sys_printstr(message);
            
            int waited_child1 = sys_wait(NULL);
            usr_build_string_with_int(message, "child ", waited_child1, " exit\n");
            sys_printstr(message);
            
            int waited_child2 = sys_wait(NULL);
            usr_build_string_with_int(message, "child ", waited_child2, " exit\n");
            sys_printstr(message);
            
            sys_printstr("=== Multi-level fork test completed successfully! ===\n");
            sys_exit(0);  // 无法替换为return 0?
        } else {
            sys_printstr("[L0-Parent] fork child2 failed\n");
        }
    } else {
        sys_printstr("[L0-Parent] fork child1 failed\n");
    }
    
    return 0;
}