#include "defs.h"

// 计算字符串长度
int strlen(const char *s) {
    int n;
    for(n = 0; s[n]; n++)
        ;
    return n;
}

// 字符串比较
int strcmp(const char *p, const char *q) {
    while(*p && *p == *q)
        p++, q++;
    return (uchar)*p - (uchar)*q;
}

// 字符串复制
char* strcpy(char *s, const char *t) {
    char *os;
    
    os = s;
    while((*s++ = *t++) != 0)
        ;
    return os;
}

// 安全的字符串复制（指定最大长度）
char* safestrcpy(char *s, const char *t, int n) {
    char *os;
    
    os = s;
    if(n <= 0)
        return os;
    while(--n > 0 && (*s++ = *t++) != 0)
        ;
    *s = 0;
    return os;
}
// 将字符串转换为整数
int atoi(const char *s) {
    int n = 0;
    int sign = 1;  // 正负号

    // 跳过空白字符
    while (*s == ' ' || *s == '\t') {
        s++;
    }

    // 处理符号
    if (*s == '-') {
        sign = -1;
        s++;
    } else if (*s == '+') {
        s++;
    }

    // 转换数字字符
    while (*s >= '0' && *s <= '9') {
        n = n * 10 + (*s - '0');
        s++;
    }

    return sign * n;
}