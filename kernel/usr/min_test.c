#include "../syscall.h"

int main() {
    sys_printint(1);   // 打印整数 1
    sys_exit(0);       // 以状态 0 退出
    return 0;          // 实际不会执行到这里
}