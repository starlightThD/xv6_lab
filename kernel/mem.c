#include "mem.h"
// 自行实现memset
void *memset(void *dst, int c, unsigned long n) {
    unsigned char *p = dst;
    while (n-- > 0)
        *p++ = (unsigned char)c;
    return dst;
}