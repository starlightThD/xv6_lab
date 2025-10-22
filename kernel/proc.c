#include "defs.h"
#define PROC 64 // 设定64个进程，目前最多达到512个

struct proc *proc_table[PROC]; // 指针数组
static int proc_table_pages = 0; //记录分配的物理页以进行释放
static void *proc_table_mem[PROC]; // 每个进程一页
extern char trampoline[], userret[];
struct proc *current_proc = 0;
struct cpu *current_cpu=0;

void shutdown() {
	free_proc_table();
    printf("关机\n");
    asm volatile (
        "li a7, 8\n"      // SBI shutdown
        "ecall\n"
    );
    while (1) { }
}

struct proc* myproc(void) {
    return current_proc;
}

struct cpu* mycpu(void) {
    if (current_cpu == 0) {
        warning("current_cpu is NULL, initializing...\n");
        static struct cpu cpu_instance;
		memset(&cpu_instance, 0, sizeof(struct cpu));
		current_cpu = &cpu_instance;
		printf("CPU initialized: %p\n", current_cpu);
    }
    return current_cpu;
}
void return_to_user(void) {
    struct proc *p = myproc();
    if (p == 0) {
        panic("return_to_user: no current process");
    }
    // 如果是从等待子进程的进程唤醒，应该让它继续执行
    if (p->chan != 0) {
        p->chan = 0;  // 清除通道标记
        return;  // 直接返回，不做任何状态更改
    }
    
    // 检查地址是否有效
    if ((uint64)trampoline == 0 || (uint64)userret == 0) {
        panic("return_to_user: 无效的跳转地址");
    }
    
    // 正常的用户态返回逻辑
    w_stvec(TRAMPOLINE);
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    uint64 satp = MAKE_SATP(p->pagetable);
    
    // 确保地址有效
    if (trampoline_userret < TRAMPOLINE || trampoline_userret >= TRAMPOLINE + PGSIZE) {
        panic("return_to_user: 跳转地址超出trampoline页范围");
    }
    
    ((void (*)(uint64, uint64))trampoline_userret)(TRAPFRAME, satp);
    
    // 不应该返回到这里
    panic("return_to_user: 不应该返回到这里");
}
void forkret(void){
    struct proc *p = myproc();
    if (p == 0) {
        panic("forkret: no current process");
    }
    
    // 检查进程是否从睡眠中醒来
    if (p->chan != 0) {
        p->chan = 0;  // 清除通道标记
        return;  // 直接返回，继续执行原来的函数
    }
	// 入口点是否设置，直接执行入口函数
    uint64 entry = p->trapframe->epc;
    if (entry != 0) {
        void (*fn)(void) = (void(*)(void))entry;
        fn();  // 调用入口函数
        exit_proc(0);  // 如果入口函数返回，则退出进程
    } else {
        return_to_user();
    }
}

void init_proc(void){
    for (int i = 0; i < PROC; i++) {
        void *page = alloc_page();
        if (!page) panic("init_proc: alloc_page failed for proc_table");
        proc_table_mem[i] = page;
        proc_table[i] = (struct proc *)page;

        memset(proc_table[i], 0, sizeof(struct proc));
        proc_table[i]->state = UNUSED;
        proc_table[i]->pid = 0;
        proc_table[i]->kstack = 0;
        proc_table[i]->pagetable = 0;
        proc_table[i]->trapframe = 0;
        proc_table[i]->parent = 0;
        proc_table[i]->chan = 0;
        proc_table[i]->exit_status = 0;
        memset(&proc_table[i]->context, 0, sizeof(struct context));
    }
    proc_table_pages = PROC; // 每个进程一页
}
void free_proc_table(void) {
    for (int i = 0; i < proc_table_pages; i++) {
        free_page(proc_table_mem[i]);
    }
}
struct proc* alloc_proc(void) {
    for(int i = 0;i<PROC;i++) {
		struct proc *p = proc_table[i];
        if(p->state == UNUSED) {
            p->pid = i;
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
            memset(&p->context, 0, sizeof(p->context));
            p->context.ra = (uint64)forkret;
            p->context.sp = p->kstack + PGSIZE - 16;  // 16字节对齐
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
    memset(&p->context, 0, sizeof(p->context));
}

int create_proc(void (*entry)(void)) {
    struct proc *p = alloc_proc();
    if (!p) return -1;
    
    p->trapframe->epc = (uint64)entry;
    p->state = RUNNABLE;
    
    // 安全地设置父进程
    struct proc *parent = myproc();
    if (parent != 0) {
        p->parent = parent;
    } else {
		warning("Set parent to NULL\n");
        p->parent = NULL;
    }
    
    return p->pid;
}
void exit_proc(int status) {
    struct proc *p = myproc();
    p->exit_status = status;
    kexit();
}

int wait_proc(int *status) {
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

// 调度器 - 简化版
void schedule(void) {
  static int initialized = 0;
  struct cpu *c = mycpu();
  
  if (!initialized) {
    
    if(c == 0) {
      panic("schedule: no current cpu");
    }
    c->proc = 0;
    current_proc = 0;
    initialized = 1;
  }
  
  while(1) {
    intr_on();
    for(int i = 0; i < PROC; i++) {
        struct proc *p = proc_table[i];
      	if(p->state == RUNNABLE) {
			p->state = RUNNING;
			c->proc = p;
			current_proc = p;
			swtch(&c->context, &p->context);
			c = mycpu();
			c->proc = 0;
			current_proc = 0;
      }
    }
  }
}
// 进程主动让出CPU
void yield(void) {
    struct proc *p = myproc();
    if (p == 0) {
        return;
    }
    
    // 防御性检查当前状态
    if (p->state != RUNNING) {
        warning("yield when status is not RUNNING (%d)\n", p->state);
        return;
    }
    
    // 关中断，确保状态修改是原子的
    intr_off();
    
    // 获取当前CPU
    struct cpu *c = mycpu();
    
    // 设置进程状态为RUNNABLE
    p->state = RUNNABLE;
    
    // 获取当前返回地址
    register uint64 ra asm("ra");

    p->context.ra = ra;
    // 确保CPU上下文有有效的返回地址
    if (c->context.ra == 0) {
        c->context.ra = (uint64)schedule;
        c->context.sp = (uint64)c + PGSIZE;
    }
    
    current_proc = 0;
    c->proc = 0;
    
    // 直接进行上下文切换
    swtch(&p->context, &c->context);

    intr_on();
}
void sleep(void *chan){
    struct proc *p = myproc();
    struct cpu *c = mycpu();
    
    // 获取当前返回地址，确保唤醒后能回到正确位置
    register uint64 ra asm("ra");
    
    // 关键修复：显式保存返回地址到进程上下文中
    p->context.ra = ra;
    p->chan = chan;
    p->state = SLEEPING;
    
    // 直接进行上下文切换
    swtch(&p->context, &c->context);
    
    p->chan = 0;  // 显式清除通道标记
}
void wakeup(void *chan) {
    for(int i = 0; i < PROC; i++) {
        struct proc *p = proc_table[i];
        if(p->state == SLEEPING && p->chan == chan) {
            p->state = RUNNABLE;
        }
    }
}
void kexit() {
    struct proc *p = myproc();
    
    if (p == 0) {
        panic("kexit: no current process");
    }
    
    // 不parent为NULL的初始进程退出，目前表示为关机
    if (!p->parent){
		shutdown();
	}
    
    // 正确设置ZOMBIE状态
    p->state = ZOMBIE;
    
    // 使用父进程自身地址作为通道标识
    void *chan = (void*)p->parent;
    // 检查父进程是否在使用相同的通道等待
    if (p->parent->state == SLEEPING && p->parent->chan == chan) {
        wakeup(chan);
    }
    
    // 在调度前清除当前进程指针，防止该进程再次被调度
    current_proc = 0;
    if (mycpu())
        mycpu()->proc = 0;
        
    schedule();
    
    panic("kexit should not return after schedule");
}
int kwait(int *status) {
    struct proc *p = myproc();
    
    if (p == 0) {
        printf("Warning: kwait called with no current process\n");
        return -1;
    }
    
    while (1) {
        // 关中断确保原子操作
        intr_off();
        
        // 优先检查是否有僵尸子进程
        int found_zombie = 0;
        int zombie_pid = 0;
        int zombie_status = 0;
        struct proc *zombie_child = 0;
        
        // 先查找ZOMBIE状态的子进程
        for (int i = 0; i < PROC; i++) {
            struct proc *child = proc_table[i];
            if (child->state == ZOMBIE && child->parent == p) {
                found_zombie = 1;
                zombie_pid = child->pid;
                zombie_status = child->exit_status;
                zombie_child = child;
                break;
            }
        }
        
        if (found_zombie) {
            if (status)
                *status = zombie_status;

            free_proc(zombie_child);
			zombie_child = NULL;
            intr_on();
            return zombie_pid;
        }
        
        // 检查是否有任何子进程
        int havekids = 0;
        for (int i = 0; i < PROC; i++) {
            struct proc *child = proc_table[i];
            if (child->state != UNUSED && child->parent == p) {
                havekids = 1;
            }
        }
        
        if (!havekids) {
            intr_on();
            return -1;
        }
        void *wait_chan = (void*)p;
		register uint64 ra asm("ra");
		p->context.ra = ra;
        p->chan = wait_chan;
        p->state = SLEEPING;
        
		struct cpu *c = mycpu();
		current_proc = 0;
		c->proc = 0;
        // 在睡眠前确保中断是开启的
        intr_on();
        swtch(&p->context,&c->context);
        intr_off();
        p->state = RUNNING;
        intr_on();
    }
}

void print_proc_table(void) {
    int count = 0;
    
    printf("PID  status     parent  func_address    stack_address\n");
    printf("--------------------------------------------\n");
    
    for(int i = 0; i < PROC; i++) {
        struct proc *p = proc_table[i];
        if(p->state != UNUSED) {
            count++;
            printf("%d ", p->pid);
            
            switch(p->state) {
                case UNUSED:   printf("UNUSED    "); break;
                case USED:     printf("USED      "); break;
                case SLEEPING: printf("SLEEP     "); break;
                case RUNNABLE: printf("RUNNABLE  "); break;
                case RUNNING:  printf("RUNNING   "); break;
                case ZOMBIE:   printf("ZOMBIE    "); break;
                default:       printf("UNKNOWN(%d) ", p->state); break;
            }
            
            if(p->parent)
                printf("%d ", p->parent->pid);
            else
                printf("none    ");
                
            if(p->trapframe)
                printf("%p ", (void*)p->trapframe->epc);
            else
                printf("none    ");
                
            printf("%p\n", (void*)p->kstack);
        }
    }
    
    printf("--------------------------------------------\n");
    printf("%d active processes\n", count);

}

// 简单测试任务，用于测试进程创建
void simple_task(void) {
    // 简单任务，只打印并退出
    printf("Simple task running in PID %d\n", myproc()->pid);
}
void test_process_creation(void) {
    printf("===== 测试开始: 进程创建与管理测试 =====\n");

    // 测试基本的进程创建
    int pid = create_proc(simple_task);
    assert(pid > 0);
    printf("【测试结果】: 基本进程创建成功，PID: %d，正常退出\n", pid);

    int count = 1;
    printf("\n----- 测试进程表容量限制 -----\n");
    for (int i = 0; i < PROC+5; i++) {// 验证超量创建进程的处理
        int pid = create_proc(simple_task);
        if (pid > 0) {
            count++; 
        } else {
			warning("process table was full\n");
            break;
        }
    }
    printf("【测试结果】: 成功创建 %d 个进程 (最大限制: %d)\n", count, PROC);
	print_proc_table();
    // 清理测试进程
    printf("\n----- 测试进程等待与清理 -----\n");
    int success_count = 0;
    for (int i = 0; i < count; i++) {
        int waited_pid = wait_proc(NULL);
        if (waited_pid > 0) {
            success_count++;
        } else {
            printf("【错误】: 等待进程失败，错误码: %d\n", waited_pid);
        }
    }
    printf("【测试结果】: 回收 %d/%d 个进程\n", success_count, count);
	print_proc_table();
    // 增强测试：清理后尝试重新创建进程
	printf("\n----- 清理后尝试重新填满进程表 -----\n");
	int refill_count = 0;
	for (int i = 0; i < PROC; i++) {
		int pid = create_proc(simple_task);
		if (pid > 0) {
			refill_count++;
		} else {
			printf("【错误】: 进程槽已满或分配失败\n");
			break;
		}
	}
	printf("【测试结果】: 清理后成功重新创建 %d 个进程\n", refill_count);
	print_proc_table();
	printf("\n----- 测试进程等待与清理 -----\n");
    success_count = 0;
    for (int i = 0; i < count; i++) {
        int waited_pid = wait_proc(NULL);
        if (waited_pid > 0) {
            success_count++;
        } else {
            printf("【错误】: 等待进程失败，错误码: %d\n", waited_pid);
        }
    }
    printf("【测试结果】: 回收 %d/%d 个进程\n", success_count, count);
	print_proc_table();
    printf("===== 测试结束: 进程创建与管理测试 =====\n");
}

void cpu_intensive_task(void) {
    uint64 sum = 0;
    for (uint64 i = 0; i < 10000000; i++) {
        sum += i;
    }
    printf("CPU intensive task done in PID %d, sum=%lu\n", myproc()->pid, sum);
    exit_proc(0);
}

void test_scheduler(void) {
    printf("===== 测试开始: 调度器测试 =====\n");

    // 创建多个计算密集型进程
    for (int i = 0; i < 3; i++) {
        create_proc(cpu_intensive_task);
    }

    // 观察调度行为
    uint64 start_time = get_time();
	for (int i = 0; i < 3; i++) {
    	wait_proc(NULL); // 等待所有子进程结束
	}
    uint64 end_time = get_time();

    printf("Scheduler test completed in %lu cycles\n", end_time - start_time);
    printf("===== 测试结束 =====\n");
}
static int proc_buffer = 0;
static int proc_produced = 0;

void shared_buffer_init() {
    proc_buffer = 0;
    proc_produced = 0;
}

void producer_task(void) {
    proc_buffer = 42;
    proc_produced = 1;
    wakeup(&proc_produced); // 唤醒消费者
    printf("Producer: produced value %d\n", proc_buffer);
    exit_proc(0);
}

void consumer_task(void) {
    while (!proc_produced) {
        sleep(&proc_produced); // 等待生产者
    }
    printf("Consumer: consumed value %d\n", proc_buffer);
    exit_proc(0);
}
void test_synchronization(void) {
    printf("===== 测试开始: 同步机制测试 =====\n");

    // 初始化共享缓冲区
    shared_buffer_init();

    // 创建生产者和消费者进程
    create_proc(producer_task);
    create_proc(consumer_task);

    // 等待两个进程完成
    wait_proc(NULL);
    wait_proc(NULL);

    printf("===== 测试结束 =====\n");
}