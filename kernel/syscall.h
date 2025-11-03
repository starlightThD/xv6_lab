// syscall.h
#include "defs.h"

static inline void sys_exit(int status);
static inline int  sys_fork(void);
static inline int  sys_step(void);
static inline void sys_printint(long x);
static inline void sys_printstr(const char *s);


static __attribute__((always_inline)) inline long do_syscall(long n, long arg0) {
    register long a0 asm("a0") = arg0;
    register long a7 asm("a7") = n;
    asm volatile("ecall"
                 : "+r"(a0)
                 : "r"(a7)
                 : "memory");
    return a0;
}

static __attribute__((always_inline)) inline void sys_exit(int status) {
    do_syscall(SYS_exit, status);
    while (1) {} // 不会返回
}
static __attribute__((always_inline)) inline void sys_kill(int pid) {
	do_syscall(SYS_kill,pid);
}
static __attribute__((always_inline)) inline int sys_fork(void) {
    return do_syscall(SYS_fork, 0);
}
static __attribute__((always_inline)) inline int sys_wait(int *status) {
    return do_syscall(SYS_wait, (long)status);
}
static __attribute__((always_inline)) inline int sys_yield(void) {
    return do_syscall(SYS_yield, 0);
}
static __attribute__((always_inline)) inline int sys_step(void) {
    return do_syscall(SYS_step, 0);
}
static __attribute__((always_inline)) inline int sys_pid(void) {
    return do_syscall(SYS_pid, 0);
}

static __attribute__((always_inline)) inline int sys_ppid(void) {
    return do_syscall(SYS_ppid, 0);
}

static __attribute__((always_inline)) inline void sys_printint(long x) {
    do_syscall(SYS_printint, x);
}

static __attribute__((always_inline)) inline void sys_printstr(const char *s) {
    do_syscall(SYS_printstr, (long)s);
}
