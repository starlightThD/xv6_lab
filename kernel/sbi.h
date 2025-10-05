#pragma once
#include "types.h"

// 设置下次时钟中断时间
void sbi_set_time(uint64 time);

// 获取当前时间
uint64 sbi_get_time(void);