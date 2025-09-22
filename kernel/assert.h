#include "printf.h"

static inline void assert(int expr) {
    if (!expr) {
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
        panic("assert");
    }
}