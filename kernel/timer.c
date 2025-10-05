#include "timer.h"
#include "sbi.h"
#include "printf.h"
#include "trap.h"
#include "riscv.h"  // 确保包含了这个头文件

// 声明外部测试标志
extern volatile int *interrupt_test_flag;
void timeintr(void){
	if (interrupt_test_flag)
        (*interrupt_test_flag)++;
}