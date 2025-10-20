#include "mem.h"
#include "types.h"
// 自行实现memset
void *memset(void *dst, int c, unsigned long n) {
    unsigned char *p = dst;
    while (n-- > 0)
        *p++ = (unsigned char)c;
    return dst;
}
void *memmove(void *dst, const void *src, unsigned long n) {
	unsigned char *d = dst;
	const unsigned char *s = src;
	if (d < s) {
		while (n-- > 0)
			*d++ = *s++;
	} else {
		d += n;
		s += n;
		while (n-- > 0)
			*(--d) = *(--s);
	}
	return dst;
}
void *memcpy(void *dst, const void *src, size_t n) {
    char *d = dst;
    const char *s = src;
    for (size_t i = 0; i < n; i++) {
        d[i] = s[i];
    }
    return dst;
}