#include "../syscall.h"

int main() {
    int ret = sys_fork();
    if (ret == 0) {
        // 子进程
        sys_printstr("child: ");
        sys_printint(sys_pid());
        sys_printstr(" ppid=");
        sys_printint(sys_ppid());
        sys_printstr("\n");
		sys_exit(0);
    } else if (ret > 0) {
        // 父进程
        sys_printstr("parent: ");
        sys_printint(sys_pid());
        sys_printstr(" forked child=");
        sys_printint(ret);
        
        // 父进程等待子进程完成
		sys_printstr("before wait\n");
		int waited_pid = sys_wait();
		sys_printstr("after wait\n");

        sys_printstr("parent: child ");
        sys_printint(waited_pid);
        sys_printstr(" exited");
        sys_printstr("\n");
		sys_exit(0);
    } else {
        // fork失败
        sys_printstr("fork failed!\n");
		sys_exit(0);
    }
    return 0;
}