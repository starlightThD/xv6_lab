#ifndef VM_H
#define VM_H

#include "types.h"

// 页表类型定义
typedef uint64 pte_t;
typedef uint64* pagetable_t;

// 基本操作接口
pagetable_t create_pagetable(void);
int map_page(pagetable_t pt, uint64 va, uint64 pa, int perm);
void free_pagetable(pagetable_t pt);
 
// 启动内核页表
void kvminit(void);
void kvminithart(void);

// 测试接口
void test_pagetable(void);
#endif