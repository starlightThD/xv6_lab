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

int main() {
    char message[256];  // 用于构建消息的缓冲区
    
    int ret = sys_fork();
    if (ret == 0) {
        // 子进程 - 使用新的字符串构建函数
        usr_build_string_with_two_ints(message, "child: ", sys_pid(), " ppid=", sys_ppid(), "\n");
        sys_printstr(message);
        sys_exit(0);
    } else if (ret > 0) {
        // 父进程 - 使用新的字符串构建函数
        usr_build_string_with_two_ints(message, "parent: ", sys_pid(), " forked child=", ret, "\n");
        sys_printstr(message);
        
        // 父进程等待子进程完成
        sys_printstr("before wait\n");
        int waited_pid = sys_wait();
        sys_printstr("after wait\n");

        usr_build_string_with_int(message, "parent: child ", waited_pid, " exited\n");
        sys_printstr(message);
        sys_exit(0);
    } else {
        // fork失败
        sys_printstr("fork failed!\n");
        sys_exit(0);
    }
    return 0;
}