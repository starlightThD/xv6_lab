#include "../syscall.h"

int main() {
    sys_printstr("Simple kernel task running in pid: ");   // 打印
	sys_printint(sys_pid());
    return 0;         
}