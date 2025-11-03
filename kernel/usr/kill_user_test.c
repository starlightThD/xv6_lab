#include "../syscall.h"
#include "user_lib.h"
int main() {
    char message[256];  // 用于构建消息的缓冲区
    sys_printstr("\n----- 测试1: 创建后立即杀死 -----\n");
    int child1 = sys_fork();
	if(child1 == 0){
		int my_pid = sys_pid();
        usr_build_string_with_int(message, "[Child1] PID ", my_pid, " started, waiting to be killed...\n");
        sys_printstr(message);
		int count = 5000;
		while(count){
			count--;
			if(count%100 == 0){
				usr_build_string_with_int(message, "[Child2] Count: ", count, "\n");
                sys_printstr(message);
                sys_yield(); // 让出CPU
            }
		}
		sys_printstr("[Child2] Finished counting (should not reach here)\n");
	}else{
		usr_build_string_with_int(message, "【测试】: 创建子进程，PID: ", child1, "\n");
        sys_printstr(message);
        int ret =0;
        sys_printstr("【测试】: 让进程运行一段时间...\n");
        // 等待一段时间
        for (int i = 0; i < 500; i++) {
            sys_yield();
        }
		sys_kill(child1);
		sys_wait(&ret);
		if(SYS_kill == ret){
			sys_printstr("【测试】: 杀死命令发送成功\n");
		}else{
			sys_printstr("【测试】: 杀死命令发送失败\n");
		}
	}
    return 0;
}