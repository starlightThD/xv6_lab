#include "../kernel/syscall.h"
#include "user_lib.h"

void test_invalid_fd(void) {
    char message[256];
    char buf[128];
    
    // 测试无效的文件描述符
    int ret = sys_write(-1, "test");
    usr_build_string_with_int(message,
        "[测试] 写入无效fd返回值: ", ret, "\n");
    sys_printstr(message);
    
    ret = sys_read(-1, buf);
    usr_build_string_with_int(message,
        "[测试] 读取无效fd返回值: ", ret, "\n");
    sys_printstr(message);
}

void test_invalid_buffer(void) {
    char message[256];
    
    // 测试无效的缓冲区地址
    int ret = sys_write(1, (char*)0);  // NULL指针
    usr_build_string_with_int(message,
        "[测试] 写入NULL指针返回值: ", ret, "\n");
    sys_printstr(message);
    
    ret = sys_read(0, (char*)0xffffffff);  // 非法地址
    usr_build_string_with_int(message,
        "[测试] 读取非法地址返回值: ", ret, "\n");
    sys_printstr(message);
}

void test_stdout_stderr(void) {
    char message[256];
    
    // 测试标准输出和标准错误
    int ret = sys_write(1, "输出到stdout\n");
    usr_build_string_with_int(message,
        "[测试] 标准输出返回值: ", ret, "\n");
    sys_printstr(message);
    
    ret = sys_write(2, "输出到stderr\n");
    usr_build_string_with_int(message,
        "[测试] 标准错误返回值: ", ret, "\n");
    sys_printstr(message);
}

int main() {
    sys_printstr("===== 文件系统调用测试开始 =====\n");
    
    // 测试无效的文件操作
    sys_printstr("\n----- 测试1: 无效的文件描述符 -----\n");
    test_invalid_fd();
    
    // 测试无效的缓冲区
    sys_printstr("\n----- 测试2: 无效的缓冲区地址 -----\n");
    test_invalid_buffer();
    
    // 测试标准输出/错误
    sys_printstr("\n----- 测试3: 标准输出和标准错误 -----\n");
    test_stdout_stderr();
    
    sys_printstr("\n===== 文件系统调用测试结束 =====\n");
    sys_exit(0);
    return 0;
}