#include "defs.h"

void sbi_set_time(uint64 time) {
    register uint64 a0 asm("a0") = time;
    register uint64 a7 asm("a7") = SBI_SET_TIME;
    asm volatile ("ecall"
                  : "+r"(a0)
                  : "r"(a7)
                  : "memory");
}
// 直接读取 time CSR 寄存器获取当前时间
uint64 sbi_get_time(void) {
    uint64 time_value;
    
    asm volatile ("rdtime %0" : "=r"(time_value));
    
    return time_value;
}