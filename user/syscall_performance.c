#include "../kernel/syscall.h"
#include "user_lib.h"

#define TEST_ITERATIONS 10000  // 每种系统调用测试的次数

void test_syscall(const char* name, void (*func)(void), int iterations) {
    char message[256];
    
    // 开始测试前的提示
    usr_build_string_with_int(message, 
        "\n开始测试 ", iterations, 
        " 次系统调用: ");
    sys_printstr(message);
    sys_printstr(name);
    sys_printstr("\n");
    
    // 记录开始时间
    uint64 start_time = sys_get_time();
    
    // 执行系统调用
    for(int i = 0; i < iterations; i++) {
        func();
    }
    
    // 记录结束时间并计算
    uint64 end_time = sys_get_time();
    uint64 total_cycles = end_time - start_time;
    uint64 avg_cycles = total_cycles / iterations;
    
    // 输出结果
    usr_build_string_with_two_ints(message,
        "总耗时(cycles): ", (int)total_cycles,
        " 平均(cycles): ", (int)avg_cycles,
        "\n");
    sys_printstr(message);
}

// 测试用的空函数
static void empty_func(void) {
    sys_pid();  // 最简单的系统调用
}

static void print_func(void) {
    sys_printint(0);  // 带输出的系统调用
}

int main() {
    // 输出测试开始信息
    sys_printstr("===== 系统调用性能测试开始 =====\n");
    
    // 测试不同类型的系统调用
    test_syscall("获取PID", empty_func, TEST_ITERATIONS);
    test_syscall("打印数字", print_func, TEST_ITERATIONS/10);  // 减少打印次数
    
    // 测试获取时间本身的开销
    uint64 start = sys_get_time();
    uint64 end = sys_get_time();
    
    char message[256];
    usr_build_string_with_int(message,
        "\n获取时间的开销(cycles): ",
        (int)(end - start),
        "\n");
    sys_printstr(message);
    
    sys_printstr("===== 系统调用性能测试结束 =====\n");
    sys_exit(0);
    return 0;
}