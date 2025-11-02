#include "../syscall.h"

// 简单的字符串长度计算
int usr_strlen(const char *s) {
    int len = 0;
    while (s[len]) len++;
    return len;
}

// 将字符串复制到目标位置
void usr_strcpy(char *dst, const char *src) {
    while ((*dst++ = *src++));
}

// 将字符串追加到目标位置
void usr_strcat(char *dst, const char *src) {
    dst += usr_strlen(dst);
    usr_strcpy(dst, src);
}

// 将整数转换为字符串
void usr_itoa(int num, char *str) {
    if (num == 0) {
        str[0] = '0';
        str[1] = '\0';
        return;
    }
    
    int i = 0;
    int is_negative = 0;
    
    if (num < 0) {
        is_negative = 1;
        num = -num;
    }
    
    // 反向存储数字
    while (num > 0) {
        str[i++] = (num % 10) + '0';
        num /= 10;
    }
    
    if (is_negative) {
        str[i++] = '-';
    }
    
    str[i] = '\0';
    
    // 反转字符串
    int len = i;
    for (int j = 0; j < len / 2; j++) {
        char temp = str[j];
        str[j] = str[len - 1 - j];
        str[len - 1 - j] = temp;
    }
}

// 新增：构建包含数字的字符串
void usr_build_string_with_int(char *buffer, const char *prefix, int num, const char *suffix) {
    char num_str[32];
    usr_itoa(num, num_str);
    
    usr_strcpy(buffer, prefix);
    usr_strcat(buffer, num_str);
    usr_strcat(buffer, suffix);
}

// 新增：构建包含两个数字的字符串
void usr_build_string_with_two_ints(char *buffer, const char *prefix, int num1, const char *middle, int num2, const char *suffix) {
    char num1_str[32];
    char num2_str[32];
    
    usr_itoa(num1, num1_str);
    usr_itoa(num2, num2_str);
    
    usr_strcpy(buffer, prefix);
    usr_strcat(buffer, num1_str);
    usr_strcat(buffer, middle);
    usr_strcat(buffer, num2_str);
    usr_strcat(buffer, suffix);
}

// 新增：构建包含三个数字的字符串
void usr_build_string_with_three_ints(char *buffer, const char *prefix, int num1, const char *mid1, int num2, const char *mid2, int num3, const char *suffix) {
    char num1_str[32];
    char num2_str[32];
    char num3_str[32];
    
    usr_itoa(num1, num1_str);
    usr_itoa(num2, num2_str);
    usr_itoa(num3, num3_str);
    
    usr_strcpy(buffer, prefix);
    usr_strcat(buffer, num1_str);
    usr_strcat(buffer, mid1);
    usr_strcat(buffer, num2_str);
    usr_strcat(buffer, mid2);
    usr_strcat(buffer, num3_str);
    usr_strcat(buffer, suffix);
}

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
                
                int waited1 = sys_wait();
                usr_build_string_with_int(message, "child ", waited1, " exit\n");
                sys_printstr(message);
                
                int waited2 = sys_wait();
                usr_build_string_with_int(message, "child ", waited2, " exit\n");
                sys_printstr(message);
                
                sys_exit(0);  // 正常退出
            } else {
                sys_printstr("[L1-Child1] fork grandchild2 failed\n");
                sys_exit(0);
            }
        } else {
            sys_printstr("[L1-Child1] fork grandchild1 failed\n");
            sys_exit(0);
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
                sys_exit(0);  // 正常退出
            } else if (grandchild3 > 0) {
                int grandchild4 = sys_fork();
                if (grandchild4 == 0) {
                    // 第四个孙进程
                    int my_pid = sys_pid();
                    int my_ppid = sys_ppid();
                    usr_build_string_with_two_ints(message, "[L2-GChild4] pid=", my_pid, " ppid=", my_ppid, " working\n");
                    sys_printstr(message);
                    sys_exit(0);  // 正常退出
                } else if (grandchild4 > 0) {
                    // 第二个子进程等待两个孙进程
                    usr_build_string_with_two_ints(message, "[L1-Child2] created grandchildren: ", grandchild3, " and ", grandchild4, ", waiting...\n");
                    sys_printstr(message);
                    
                    int waited3 = sys_wait();
                    usr_build_string_with_int(message, "child ", waited3, " exit\n");
                    sys_printstr(message);
                    
                    int waited4 = sys_wait();
                    usr_build_string_with_int(message, "child ", waited4, " exit\n");
                    sys_printstr(message);
                    
                    sys_exit(0);  // 正常退出
                } else {
                    sys_printstr("[L1-Child2] fork grandchild4 failed\n");
                    sys_exit(0);
                }
            } else {
                sys_printstr("[L1-Child2] fork grandchild3 failed\n");
                sys_exit(0);
            }
        } else if (child2 > 0) {
            // 父进程等待两个子进程
            usr_build_string_with_two_ints(message, "[L0-Parent] created children: ", child1, " and ", child2, ", waiting...\n");
            sys_printstr(message);
            
            int waited_child1 = sys_wait();
            usr_build_string_with_int(message, "child ", waited_child1, " exit\n");
            sys_printstr(message);
            
            int waited_child2 = sys_wait();
            usr_build_string_with_int(message, "child ", waited_child2, " exit\n");
            sys_printstr(message);
            
            sys_printstr("=== Multi-level fork test completed successfully! ===\n");
            sys_exit(0);  // 正常退出
        } else {
            sys_printstr("[L0-Parent] fork child2 failed\n");
            sys_exit(0);
        }
    } else {
        sys_printstr("[L0-Parent] fork child1 failed\n");
        sys_exit(0);
    }
    
    return 0;
}