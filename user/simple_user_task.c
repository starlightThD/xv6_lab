#include "../kernel/syscall.h"

int main() {
    sys_printstr("Simple kernel task running in pid: ");   // 打印
	sys_printint(sys_pid());
	sys_exit(0);
    return 0;         
}