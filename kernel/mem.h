#ifndef MEM_H
#define MEM_H

// 内存操作函数声明
void *memset(void *dst, int c, unsigned long n);
void *memmove(void *dst, const void *src, unsigned long n);
void *memcpy(void *dst, const void *src, unsigned long n);
#endif