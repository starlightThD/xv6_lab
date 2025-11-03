#include "../syscall.h"

int main(){
	sys_printstr("hello world\n");
    return 0;          // 实际不会执行到这里
}