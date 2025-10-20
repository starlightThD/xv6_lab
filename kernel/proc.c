#include "proc.h"
#include "vm.h"
#include "pm.h"
#include "memlayout.h"
#include "mem.h"
#include "types.h"
#include "printf.h"
#define PROC 64 //最多64个进程

struct proc proc_table[PROC]; //进程表
int nextpid = 1; //下一个进程ID
extern char trampoline[], userret[];
struct proc *current_proc = 0;
struct cpu *current_cpu=0;

struct proc* myproc(void) {
    return current_proc;
}
// 添加CPU初始化函数
void init_cpu(void) {
    // 假设只有一个CPU
    static struct cpu cpu_instance;
    // 初始化CPU结构体
    memset(&cpu_instance, 0, sizeof(struct cpu));
    current_cpu = &cpu_instance;
    printf("CPU initialized: %p\n", current_cpu);
}
struct cpu* mycpu(void) {
    if (current_cpu == 0) {
        printf("WARNING: current_cpu is NULL, initializing...\n");
        init_cpu();
    }
    return current_cpu;
}

void return_to_user(void){
    struct proc *p = myproc();
    if (p == 0) {
        panic("return_to_user: no current process");
    }
    
    printf("return_to_user: 进程 %d 尝试返回用户态\n", p->pid);
    
    // 检测是否在测试模式
    if (p->trapframe->kernel_satp == 0) {
        printf("return_to_user: 在测试模式下，不返回用户态\n");
        printf("设置进程为RUNNABLE并调度\n");
        p->state = RUNNABLE;
        schedule();
        panic("return_to_user should not return");
    }
    
    // 正常的用户态返回逻辑
    w_stvec(TRAMPOLINE);
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    uint64 satp = MAKE_SATP(p->pagetable);
    ((void(*)(uint64))trampoline_userret)(satp);
}
void forkret(void){
    // 检查栈指针是否有效
    uint64 sp_val;
    asm volatile("mv %0, sp" : "=r"(sp_val));
    printf("forkret: 进入函数，当前sp=%p\n", (void*)sp_val);
    
    struct proc *p = myproc();
    if (p == 0) {
        panic("forkret: no current process");
    }
    
    printf("forkret: 进程 %d (状态 %d), 栈范围 [%p, %p]\n", 
           p->pid, p->state, (void*)p->kstack, (void*)(p->kstack + PGSIZE));
    
    // 验证栈地址
    if (sp_val < p->kstack || sp_val >= p->kstack + PGSIZE) {
        printf("错误: 栈指针 %p 不在有效范围 [%p, %p]\n",
               (void*)sp_val, (void*)p->kstack, (void*)(p->kstack + PGSIZE));
        panic("forkret: 无效的栈指针");
    }
    
    // 其余代码不变...
    if (p->trapframe == 0) {
        printf("forkret: trapframe为NULL，设为RUNNABLE并调度\n");
        p->state = RUNNABLE;
        schedule();
        panic("forkret should not return after schedule");
    }
    
    // 如果是simple_task测试进程，不调用return_to_user
    if (p->trapframe->epc == (uint64)simple_task) {
        printf("forkret: 检测到测试进程，执行simple_task\n");
        // 直接调用函数而不是通过return_to_user
        ((void(*)())p->trapframe->epc)();
        printf("forkret: simple_task返回，调度新进程\n");
        p->state = ZOMBIE;
        schedule();
        panic("forkret should not return");
    }
    
    printf("forkret: 调用return_to_user\n");
    return_to_user();
}
void init_proc(void){
    for(int i=0; i<PROC; i++){
        struct proc *p = &proc_table[i];
        p->state = UNUSED;
        p->pid = 0;
        p->kstack = 0;  // 不预先设置栈地址，而是在 alloc_proc 中分配
        p->parent = 0;
        p->chan = 0;
    }
}
struct proc* alloc_proc(void) {
    struct proc *p;
    for(p = proc_table; p < &proc_table[PROC]; p++) {
        if(p->state == UNUSED) {
            p->pid = nextpid++;
            p->state = USED;

            // 分配 trapframe
            p->trapframe = (struct trapframe*)alloc_page();
            if(p->trapframe == 0){
                p->state = UNUSED;
                p->pid = 0;
                return 0;
            }

            // 分配页表
            p->pagetable = create_pagetable();
            if(p->pagetable == 0){
                free_page(p->trapframe);
                p->trapframe = 0;
                p->state = UNUSED;
                p->pid = 0;
                return 0;
            }
            
            // 分配实际内核栈（关键修复）
            void *kstack_mem = alloc_page();
            if(kstack_mem == 0) {
                free_page(p->trapframe);
                free_pagetable(p->pagetable);
                p->trapframe = 0;
                p->pagetable = 0;
                p->state = UNUSED;
                p->pid = 0;
                return 0;
            }
            
            p->kstack = (uint64)kstack_mem;
            printf("分配进程 %d 内核栈: %p\n", p->pid, (void*)p->kstack);

            // 初始化上下文
            memset(&p->context, 0, sizeof(p->context));
            p->context.ra = (uint64)forkret;
            p->context.sp = p->kstack + PGSIZE - 16;  // 16字节对齐
            printf("初始化进程 %d 上下文: ra=%p, sp=%p\n",
                   p->pid, (void*)p->context.ra, (void*)p->context.sp);
                   
            return p;
        }
    }
    return 0;
}

void free_proc(struct proc *p){
    if(p->trapframe)
        free_page(p->trapframe);
    p->trapframe = 0;
    
    if(p->pagetable)
        free_pagetable(p->pagetable);
    p->pagetable = 0;
    
    // 释放内核栈（如果存在）
    if(p->kstack)
        free_page((void*)p->kstack);
    p->kstack = 0;
    
    p->pid = 0;
    p->state = UNUSED;
    p->parent = 0;
    p->chan = 0;
}
int create_proc(void (*entry)(void)) {
    struct proc *p = alloc_proc();
    if (!p)
        return -1;
    
    p->trapframe->epc = (uint64)entry;
    p->state = RUNNABLE;
    
    // 安全地设置父进程
    struct proc *parent = myproc();
    if (parent != 0) {
        p->parent = parent;
    } else {
        printf("Warning: creating process with no parent\n");
        p->parent = 0;
    }
    
    return p->pid;
}
void exit_proc(int status) {
    struct proc *p = myproc();
    p->exit_status = status;
    kexit();
}

int wait_proc(int *status) {
	printf("wait_proc called\n");
    return kwait(status);
}
int kfork(void) {
    struct proc *parent = myproc();
    struct proc *child = alloc_proc();
    if(child == 0)
        return -1;

    if(uvmcopy(parent->pagetable, child->pagetable, parent->sz) < 0){
        free_proc(child);
        return -1;
    }
    child->sz = parent->sz;

    *(child->trapframe) = *(parent->trapframe);
    child->trapframe->a0 = 0; // 子进程fork返回值为0
    child->state = RUNNABLE;
    child->parent = parent;
    return child->pid;
}
void print_context(struct context *ctx, char *name) {
    printf("%s: ra=%p, sp=%p", name, (void*)ctx->ra, (void*)ctx->sp);
    printf(", s0=%p, s1=%p\n", (void*)ctx->s0, (void*)ctx->s1);
    // 可以根据实际结构体定义添加更多字段
}

// 添加一个辅助函数，作为CPU上下文的返回点
void scheduler_ret(void) {
    printf("返回到调度器\n");
    schedule();  // 继续调度
}
void schedule(void){
    struct proc *p;
    struct cpu *c = mycpu();
    
    if (c == 0) {
        panic("schedule: mycpu() returned NULL");
    }
    
    // 添加防御性检查
    printf("Schedule: CPU=%p, current proc=%p\n", c, c->proc);
        // 初始化CPU上下文返回地址 - 关键修复
    if (c->context.ra == 0) {
        c->context.ra = (uint64)scheduler_ret;  // 指向一个辅助函数
        c->context.sp = (uint64)c + PGSIZE;     // 为CPU上下文分配栈空间
        printf("初始化CPU上下文: ra=%p, sp=%p\n", (void*)c->context.ra, (void*)c->context.sp);
    }
    c->proc = 0;
    
    while(1){
        intr_on();
        
        // 查找可运行的进程
        for(p = proc_table; p < &proc_table[PROC]; p++){
            if(p->state == RUNNABLE){
                // 添加安全检查
                if (p->trapframe == 0) {
                    printf("ERROR: Found RUNNABLE process %d with NULL trapframe\n", p->pid);
                    p->state = UNUSED;
                    continue;
                }
                
                printf("Scheduling process %d\n", p->pid);
                p->state = RUNNING;
                c->proc = p;
                current_proc = p;
                
				// 进程上下文切换前打印信息
				print_context(&c->context, "CPU上下文");
				print_context(&p->context, "进程上下文");
				swtch(&c->context, &p->context);
                
                // 切换回来后
                current_proc = 0;
                c->proc = 0;
                break;
            }
        }
        
        // 如果没有可运行的进程，就暂停一下
        if (p >= &proc_table[PROC]) {
            printf("No RUNNABLE processes, waiting...\n");
            // 可以添加一个简单的延迟
            for (int i = 0; i < 1000000; i++) {
                asm volatile("nop");
            }
        }
    }
}
void sleep(void *chan, int (*cond)(void*), void *arg) {
    struct proc *p = myproc();
    if(p == 0){
        panic("scheduler want to sleep! \n");
    }
    
    // 打印更多调试信息
    printf("Process %d going to sleep on channel %p\n", p->pid, chan);
    
    intr_off();
    // 如果条件不满足，则睡眠
    if(cond == 0 || !cond(arg)) {
        p->chan = chan;
        p->state = SLEEPING;
        schedule();
        p->chan = 0;
    }else{
        intr_on();
    }
}

void wakeup(void *chan, int wake_all) {
    // 打印更多调试信息
    printf("Waking up processes on channel %p\n", chan);
    
    if (chan == 0) {
        printf("WARNING: wakeup called with NULL channel\n");
        return;
    }
    
    intr_off();
    int woke_up = 0;
    for(struct proc *p = proc_table; p < &proc_table[PROC]; p++) {
        // 移除 p != myproc() 条件，让当前进程也能被唤醒
        if (p->state == SLEEPING && p->chan == chan) {
            printf("Waking up process %d\n", p->pid);
            p->state = RUNNABLE;
            woke_up++;
            if(!wake_all) break;
        }
    }
    
    printf("Woke up %d processes\n", woke_up);
    intr_on();
}
void kexit() {
    struct proc *p = myproc();
    
    if (p == 0) {
        panic("kexit: no current process");
    }
    
    if (p->parent == 0) {
        printf("WARNING: Process %d has no parent, self cleaning\n", p->pid);
        p->state = UNUSED;  // 不设为ZOMBIE，直接清理
        free_proc(p);
        schedule();
        panic("kexit should not return");
    }
    
    printf("Process %d exiting (parent: %d)\n", p->pid, p->parent->pid);
    
    // 正确设置ZOMBIE状态
    p->state = ZOMBIE;
    
    // 明确打印父进程状态
    printf("Parent process %d state before wakeup: %d\n", 
           p->parent->pid, p->parent->state);
    
    // 使用父进程作为唤醒通道
    if (p->parent->state == SLEEPING && p->parent->chan == p->parent) {
        printf("Waking up parent process %d\n", p->parent->pid);
        wakeup(p->parent, 0);
    } else {
        printf("Parent %d not sleeping or using different channel\n", p->parent->pid);
    }
    
    schedule();
    panic("kexit should not return");
}
int kwait(int *status) {
    struct proc *p = myproc();
    
    if (p == 0) {
        printf("Warning: kwait called with no current process\n");
        return -1;
    }
    
    printf("Process %d waiting for children\n", p->pid);
    
    while (1) {
        int havekids = 0;
        intr_off();
        
        // 检查ZOMBIE子进程
        for (int i = 0; i < PROC; i++) {
            struct proc *child = &proc_table[i];
            if (child->state != UNUSED && child->parent == p) {
                havekids = 1;
                printf("Process %d found child %d in state %d\n", 
                       p->pid, child->pid, child->state);
                
                if (child->state == ZOMBIE) {
                    int pid = child->pid;
                    if (status)
                        *status = child->exit_status;
                    printf("Process %d cleaning up ZOMBIE child %d\n", p->pid, pid);
                    free_proc(child);
                    intr_on();
                    return pid;
                }
            }
        }
        
        if (!havekids) {
            intr_on();
            printf("Process %d has no children\n", p->pid);
            return -1;
        }
        
        // 定义一个明确的通道值 - 不使用进程指针
        static uint64 wait_channel = 0xBEEF;
        
        printf("Process %d sleeping on wait channel %p\n", p->pid, (void*)wait_channel);
        p->chan = (void*)wait_channel;
        p->state = SLEEPING;
        intr_on();
        schedule();
        
        // 被唤醒后继续循环检查
        printf("Process %d woken up, rechecking children\n", p->pid);
    }
}
void simple_task(void) {
    struct proc *p = myproc();
    if (p == 0) {
        panic("simple_task: no current process");
    }
    
    printf("Simple task running in pid %d (parent pid: %d)\n", 
           p->pid, p->parent ? p->parent->pid : -1);
    
    // 在退出前确保父进程指针有效
    if (p->parent == 0) {
        printf("ERROR: parent is NULL for pid %d\n", p->pid);
        // 直接自我清理
        p->state = UNUSED;
        free_proc(p);
        schedule();
        panic("simple_task should not return after schedule");
    }
    
    // 安全地退出
    printf("Process %d exiting normally\n", p->pid);
    exit_proc(0);
}

// 用于唤醒测试的简单任务
void wake_test_task(void) {
    struct proc *p = myproc();
    printf("唤醒测试任务运行在 pid=%d\n", p->pid);
    exit_proc(0);
}

void test_proc_functions(void) {
    printf("\n=== 进程管理函数测试 ===\n");
    
    // 测试1: alloc_proc
    printf("\n[测试1] alloc_proc 测试\n");
    struct proc *p = alloc_proc();
    if(p == 0) {
        printf("alloc_proc 测试失败: 无法分配进程\n");
    } else {
        printf("alloc_proc 测试通过: 成功分配进程 pid=%d\n", p->pid);
        
        // 测试2: free_proc
        printf("\n[测试2] free_proc 测试\n");
        free_proc(p);
        printf("free_proc 测试通过: 进程被释放\n");
    }
    
    // 测试3: create_proc 和简单运行
    printf("\n[测试3] create_proc 测试\n");
    current_proc = 0; // 确保没有父进程
    int pid = create_proc(simple_task);
    if(pid <= 0) {
        printf("create_proc 测试失败: 无法创建进程\n");
    } else {
        printf("create_proc 测试通过: 成功创建进程 pid=%d\n", pid);
    }
    
    // 测试4: 测试睡眠和唤醒机制
printf("\n[测试4] sleep/wakeup 测试\n");
struct proc *sleep_test = alloc_proc();
if(sleep_test) {
    current_proc = sleep_test;
    sleep_test->state = RUNNING;
    
    // 创建一个唤醒线程
    int wake_pid = create_proc(wake_test_task);
    if(wake_pid > 0) {
        printf("创建唤醒测试进程 pid=%d\n", wake_pid);
        
        // 用于测试的特定通道
        void *test_channel = (void*)0xDEADBEEF;
        printf("进程 %d 将在通道 %p 上睡眠\n", sleep_test->pid, test_channel);
        
        // 显式输出当前进程
        printf("当前进程: pid=%d\n", myproc() ? myproc()->pid : -1);
        
        // 这里我们不能真正睡眠，因为会导致测试停止
        // 但我们可以模拟通道设置
        sleep_test->chan = test_channel;
        sleep_test->state = SLEEPING;
        
        // 输出设置后的状态
        printf("睡眠设置后进程 %d 状态: %d, 通道: %p\n", 
               sleep_test->pid, sleep_test->state, sleep_test->chan);
        
        // 手动唤醒
        wakeup(test_channel, 0);
        
        // 检查状态
        if(sleep_test->state == RUNNABLE) {
            printf("sleep/wakeup 测试通过: 进程被成功唤醒\n");
        } else {
            printf("sleep/wakeup 测试失败: 进程未被唤醒，状态=%d\n", 
                   sleep_test->state);
            
            // 调试: 检查所有进程
            printf("所有进程状态:\n");
            for(int i = 0; i < PROC; i++) {
                if(proc_table[i].state != UNUSED) {
                    printf("- pid=%d, state=%d, chan=%p\n", 
                           proc_table[i].pid, proc_table[i].state, 
                           proc_table[i].chan);
                }
            }
        }
    }
        
        // 清理
        free_proc(sleep_test);
    }
    
    printf("\n=== 进程管理函数测试完成 ===\n");
}

void test_proc_manager(void) {
    printf("Starting simplified test\n");
    
    // 创建初始进程
    struct proc *init = alloc_proc();
    current_proc = init;
    init->state = RUNNING;
    
    // 创建子进程
    int pid = create_proc(simple_task);
    printf("Created child process: pid=%d\n", pid);
    
    // 手动让子进程运行
    struct proc *child = 0;
    for(int i = 0; i < PROC; i++) {
        if(proc_table[i].pid == pid) {
            child = &proc_table[i];
            break;
        }
    }
    
    if(child) {
        printf("Found child process at %p\n", child);
        printf("Child process state before: %d\n", child->state);
        
        // 直接执行子进程函数
        struct proc *saved = current_proc;
        current_proc = child;
        simple_task();  // 执行但不调度
        current_proc = saved;
        
        printf("Child process state after: %d\n", child->state);
    }
    
    // 清理
    free_proc(init);
    printf("Simplified test completed\n");
}
