#include "defs.h"

// 声明外部测试标志
extern volatile int *interrupt_test_flag;
void timeintr(void){
	debug("timer interrupt\n");
	if (interrupt_test_flag)
        (*interrupt_test_flag)++;
}