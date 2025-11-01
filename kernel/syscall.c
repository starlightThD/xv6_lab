#include "defs.h"

uint64 sys_exit(void) {
    int status;
    argint(0, &status);
    printf("[syscall] exit(%d)\n", status);
    exit_proc(status);
    return 0;  // never reached
}

uint64 sys_getpid(void) {
    struct proc *p = myproc();
    return p ? p->pid : -1;
}

uint64 sys_getppid(void) {
    struct proc *p = myproc();
    return (p && p->parent) ? p->parent->pid : -1;
}

uint64 sys_fork(void) {
    printf("[syscall] fork() - not implemented\n");
    return -1;
}

uint64 sys_wait(void) {
    uint64 status_addr;
    argaddr(0, &status_addr);
    int status;
    int ret = wait_proc(&status);
    
    // 将状态写回用户空间
    if(status_addr && ret > 0) {
        copyout(status_addr, (char*)&status, sizeof(status));
    }
    return ret;
}

uint64 sys_read(void) {
    int fd;
    uint64 buf_addr;
    int count;
    
    argint(0, &fd);
    argaddr(1, &buf_addr);
    argint(2, &count);
    
    if(fd == 0) {  // stdin
        // 简单实现：返回0表示EOF
        return 0;
    }
    
    printf("[syscall] read(fd=%d) - not fully implemented\n", fd);
    return -1;
}

uint64 sys_write(void) {
    int fd;
    uint64 buf_addr;
    int count;
    
    argint(0, &fd);
    argaddr(1, &buf_addr);
    argint(2, &count);
    
    if(fd == 1 || fd == 2) {  // stdout/stderr
        char buf[256];
        int copy_len = count > sizeof(buf)-1 ? sizeof(buf)-1 : count;
        
        if(copyin(buf, buf_addr, copy_len) == 0) {
            buf[copy_len] = '\0';
            printf("%s", buf);
            return copy_len;
        }
    }
    
    return -1;
}

uint64 sys_open(void) {
    printf("[syscall] open() - not implemented\n");
    return -1;
}

uint64 sys_close(void) {
    int fd;
    argint(0, &fd);
    printf("[syscall] close(%d)\n", fd);
    return 0;  // 简化实现
}

uint64 sys_brk(void) {
    uint64 addr;
    argaddr(0, &addr);
    printf("[syscall] brk(0x%lx) - simplified\n", addr);
    return addr;  // 简化实现
}

uint64 sys_mmap(void) {
    printf("[syscall] mmap() - not implemented\n");
    return -1;
}

uint64 sys_munmap(void) {
    printf("[syscall] munmap() - not implemented\n");
    return 0;
}

uint64 sys_gettimeofday(void) {
    printf("[syscall] gettimeofday() - simplified\n");
    return 0;
}

uint64 sys_sleep(void) {
    printf("[syscall] sleep() - not implemented\n");
    return 0;
}