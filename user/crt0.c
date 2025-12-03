#include "../kernel/syscall.h"

extern int main(void);

void _start(void) {
    int ret = main();
    sys_exit(ret);
    while (1) { } // 防止意外继续执行
}