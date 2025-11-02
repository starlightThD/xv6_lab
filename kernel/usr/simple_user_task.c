#include "../syscall.h"

int main() {
    sys_printstr("Simple kernel task running in pid: ");   // 打印
	sys_printint(sys_pid());
    sys_exit(0);       // 以状态 0 退出
    return 0;          // 实际不会执行到这里
}