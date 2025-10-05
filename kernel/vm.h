#ifndef VM_H
#define VM_H

#include "types.h"
// 添加PTE标志定义
#define PTE_V (1L << 0) // 有效位
#define PTE_R (1L << 1) // 读权限
#define PTE_W (1L << 2) // 写权限
#define PTE_X (1L << 3) // 执行权限
#define PTE_U (1L << 4) // 用户模式可访问


// 获取当前页表
pagetable_t get_current_pagetable(void);

// TLB操作
void sfence_vma(void);
// 基本操作接口
pagetable_t create_pagetable(void);
int map_page(pagetable_t pt, uint64 va, uint64 pa, int perm);
void free_pagetable(pagetable_t pt);
 
// 启动内核页表
void kvminit(void);
void kvminithart(void);
void check_mapping(uint64 va);
int check_is_mapped(uint64 va);
// 测试接口
void test_pagetable(void);
#endif