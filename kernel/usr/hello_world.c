#include "../syscall.h"

int main(){
	sys_printstr("hello world\n");
    sys_exit(0);       // 以状态 0 退出
    return 0;          // 实际不会执行到这里
}