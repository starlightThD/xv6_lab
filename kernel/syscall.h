// syscall.h
#include "defs.h"

static __attribute__((always_inline)) inline long do_syscall(long n, long arg0,long arg1) {
    register long a0 asm("a0") = arg0;
    register long a1 asm("a1") = arg1;
    register long a7 asm("a7") = n;
    asm volatile("ecall"
                 : "+r"(a0)  // 输出：系统调用返回值
                 : "r"(a1),  "r"(a7)  // 输入：参数和系统调用号
                 : "memory");
    return a0;
}
static __attribute__((always_inline)) inline long 
do_syscall_5(long n, long arg0, long arg1, long arg2, long arg3, long arg4) {
    register long a0 asm("a0") = arg0;
    register long a1 asm("a1") = arg1;
    register long a2 asm("a2") = arg2;
    register long a3 asm("a3") = arg3;
    register long a4 asm("a4") = arg4;
    register long a7 asm("a7") = n;
    
    asm volatile("ecall"
                 : "+r"(a0)  // 输出：系统调用返回值
                 : "r"(a1), "r"(a2), "r"(a3), "r"(a4), "r"(a7)  // 输入：参数和系统调用号
                 : "memory");
    return a0;
}
static __attribute__((always_inline)) inline void 
sys_exit(int status) {
    do_syscall(SYS_exit, status,0);
    while (1) {} // 不会返回
}
static __attribute__((always_inline)) inline void 
sys_kill(int pid) {
	do_syscall(SYS_kill,pid,0);
}
static __attribute__((always_inline)) inline int 
sys_fork(void) {
    return do_syscall(SYS_fork, 0,0);
}
static __attribute__((always_inline)) inline int 
sys_wait(int *status) {
    return do_syscall(SYS_wait, (long)status,0);
}
static __attribute__((always_inline)) inline int 
sys_yield(void) {
    return do_syscall(SYS_yield, 0,0);
}
static __attribute__((always_inline)) inline int 
sys_step(void) {
    return do_syscall(SYS_step, 0,0);
}
static __attribute__((always_inline)) inline int 
sys_pid(void) {
    return do_syscall(SYS_pid, 0,0);
}

static __attribute__((always_inline)) inline int 
sys_ppid(void) {
    return do_syscall(SYS_ppid, 0,0);
}

static __attribute__((always_inline)) inline void 
sys_printint(long x) {
    do_syscall(SYS_printint, x,0);
}

static __attribute__((always_inline)) inline void 
sys_printstr(const char *s) {
    do_syscall(SYS_printstr, (long)s,0);
}

static __attribute__((always_inline)) inline int 
sys_open(const char *pathname, int flags, int mode) {
    return do_syscall_5(SYS_open, (long)pathname, flags, mode, 0, 0);
}

static __attribute__((always_inline)) inline int 
sys_close(int fd) {
    return do_syscall(SYS_close, fd, 0);
}

static __attribute__((always_inline)) inline int 
sys_read(int fd, void *buf, int count) {
    return do_syscall_5(SYS_read, fd, (long)buf, count, 0, 0);
}

static __attribute__((always_inline)) inline int 
sys_write(int fd, const void *buf, int count) {
    return do_syscall_5(SYS_write, fd, (long)buf, count, 0, 0);
}
static __attribute__((always_inline)) inline int 
sys_unlink(const char *pathname) {
    return do_syscall(SYS_unlink, (long)pathname, 0);
}
static __attribute__((always_inline)) inline void* 
sys_sbrk(int increment) {
    return (void*)do_syscall(SYS_sbrk, increment, 0);
}
static __attribute__((always_inline)) inline uint64 
sys_get_time(void) {
    return do_syscall(SYS_get_time, 0, 0);
}