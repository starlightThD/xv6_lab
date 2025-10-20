#ifndef VM_H
#define VM_H

#include "types.h"
// 添加PTE标志定义
#define PTE_V (1L << 0) // 有效位
#define PTE_R (1L << 1) // 读权限
#define PTE_W (1L << 2) // 写权限
#define PTE_X (1L << 3) // 执行权限
#define PTE_U (1L << 4) // 用户模式可访问
#define PTE_FLAGS(pte) ((pte) & 0x3FF)

#define VPN_SHIFT(level) (12 + 9 * (level))
#define VPN_MASK(va, level) (((va) >> VPN_SHIFT(level)) & 0x1FF)
#define PA2PTE(pa) ((((uint64)(pa)) >> 12) << 10)
#define PTE2PA(pte) (((pte) >> 10) << 12)

#define SATP_MODE_SV39 (8L << 60)
#define MAKE_SATP(pgtbl) (SATP_MODE_SV39 | (((uint64)(pgtbl)) >> 12))

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

int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz);
// 测试接口
void test_pagetable(void);
#endif