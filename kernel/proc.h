#ifndef PROC_H
#define PROC_H
#include "types.h"
#include "riscv.h"

struct context {
  uint64 ra;
  uint64 sp;
  uint64 s0;
  uint64 s1;
  uint64 s2;
  uint64 s3;
  uint64 s4;
  uint64 s5;
  uint64 s6;
  uint64 s7;
  uint64 s8;
  uint64 s9;
  uint64 s10;
  uint64 s11;
};
extern void swtch(struct context *old, struct context *new);// !!! "swtch" instead of "switch"

struct cpu {
  struct proc *proc;          
  struct context context;   
};

struct trapframe {
  /*   0 */ uint64 kernel_satp;   // kernel page table
  /*   8 */ uint64 kernel_sp;     // top of process's kernel stack
  /*  16 */ uint64 kernel_trap;   // usertrap()
  /*  24 */ uint64 epc;           // saved user program counter
  /*  32 */ uint64 kernel_hartid; // saved kernel tp
  /*  40 */ uint64 ra;
  /*  48 */ uint64 sp;
  /*  56 */ uint64 gp;
  /*  64 */ uint64 tp;
  /*  72 */ uint64 t0;
  /*  80 */ uint64 t1;
  /*  88 */ uint64 t2;
  /*  96 */ uint64 s0;
  /* 104 */ uint64 s1;
  /* 112 */ uint64 a0;
  /* 120 */ uint64 a1;
  /* 128 */ uint64 a2;
  /* 136 */ uint64 a3;
  /* 144 */ uint64 a4;
  /* 152 */ uint64 a5;
  /* 160 */ uint64 a6;
  /* 168 */ uint64 a7;
  /* 176 */ uint64 s2;
  /* 184 */ uint64 s3;
  /* 192 */ uint64 s4;
  /* 200 */ uint64 s5;
  /* 208 */ uint64 s6;
  /* 216 */ uint64 s7;
  /* 224 */ uint64 s8;
  /* 232 */ uint64 s9;
  /* 240 */ uint64 s10;
  /* 248 */ uint64 s11;
  /* 256 */ uint64 t3;
  /* 264 */ uint64 t4;
  /* 272 */ uint64 t5;
  /* 280 */ uint64 t6;
};

enum procstate { UNUSED, USED, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };


struct proc {
  enum procstate state;         // 进程状态（如 UNUSED、RUNNABLE 等）
  void *chan;                   // 睡眠时等待的事件/通道
  int killed;                   // 是否被杀死
  int exit_status;                   // 退出状态，父进程 wait 时返回
  int pid;                      // 进程ID
  struct proc *parent;          // 父进程指针
  uint64 kstack;                // 内核栈虚拟地址
  uint64 sz;                    // 用户空间大小（字节）
  pagetable_t pagetable;        // 用户页表
  struct trapframe *trapframe;  // 用户态寄存器保存区
  struct context context;       // 进程切换时保存的寄存器
  //struct file *ofile[NOFILE];   // 打开的文件表
  //struct inode *cwd;            // 当前工作目录
  char name[16];                // 进程名（调试用）
};
struct proc* myproc(void);
struct cpu* mycpu(void);

void init_proc(void);
struct proc* alloc_proc(void);
void free_proc(struct proc *p);
int create_proc(void (*entry)(void));
void exit_proc(int status);
int wait_proc(int *status);

int kfork(void);
void kexit(void);
int kwait(int *status);

void return_to_user(void);
void forkret(void);

void schedule(void);

void sleep(void *chan, int (*cond)(void*), void *arg);
void wakeup(void *chan, int wake_all);

void simple_task(void);
void test_proc_sync(void);
void test_proc_manager(void);
void test_proc_functions(void);

#endif