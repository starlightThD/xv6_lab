#include "defs.h"
#include "user_test_bin.h"
#define PROC 64 // 设定64个进程，目前最多达到512个

struct proc *proc_table[PROC]; // 指针数组
static int proc_table_pages = 0; //记录分配的物理页以进行释放
static void *proc_table_mem[PROC]; // 每个进程一页
extern pagetable_t kernel_pagetable;
extern char trampoline[],uservec[], userret[];
extern char kernelvec[];
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
    if (p->chan != 0) {
        p->chan = 0;
        return;
    }
    if ((uint64)trampoline == 0 || (uint64)userret == 0) {
        panic("return_to_user: 无效的跳转地址");
    }
    w_stvec(TRAMPOLINE + (uservec - trampoline));
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    uint64 satp = MAKE_SATP(p->pagetable);

	if ((trampoline_userret & ~(PGSIZE - 1)) != TRAMPOLINE) {
		panic("return_to_user: 跳转地址超出trampoline页范围");
	}
    // 用函数指针调用 trampoline_userret
    void (*userret_fn)(uint64, uint64) = (void (*)(uint64, uint64))trampoline_userret;
    userret_fn(TRAPFRAME, satp);

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
	if (p->is_user){
		return_to_user();
	}else if (entry != 0) {
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
struct proc* alloc_proc(int is_user) {
    for(int i = 0;i<PROC;i++) {
		struct proc *p = proc_table[i];
        if(p->state == UNUSED) {
            p->pid = i;
            p->state = USED;
			p->is_user = is_user;
            // 分配 trapframe
            p->trapframe = (struct trapframe*)alloc_page();
            if(p->trapframe == 0){
                p->state = UNUSED;
                p->pid = 0;
                return 0;
            }
			// 分配页表
			if(p->is_user){
				p->pagetable = create_pagetable();
				if(p->pagetable == 0){
					free_page(p->trapframe);
					p->trapframe = 0;
					p->state = UNUSED;
					p->pid = 0;
					return 0;
				}
			}else{
				extern pagetable_t kernel_pagetable;
				p->pagetable = kernel_pagetable;
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
    extern pagetable_t kernel_pagetable;
    if(p->pagetable && p->pagetable != kernel_pagetable)
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

int create_kernel_proc(void (*entry)(void)) {
    struct proc *p = alloc_proc(0);
    if (!p) return -1;
    p->trapframe->epc = (uint64)entry;
    p->state = RUNNABLE;

    struct proc *parent = myproc();
    if (parent != 0) {
        p->parent = parent;
    } else {
        p->parent = NULL;
    }
    return p->pid;
}
int create_user_proc(const void *user_bin, int bin_size) {
    struct proc *p = alloc_proc(1); // 1 表示用户进程
    if (!p) return -1;

    uint64 user_entry = 0x10000;
    uint64 user_stack = 0x20000;

    // 分配用户代码页
    void *page = alloc_page();
    if (!page) { free_proc(p); return -1; }
    map_page(p->pagetable, user_entry, (uint64)page, PTE_R | PTE_W | PTE_X | PTE_U);
    memcpy((void*)page, user_bin, bin_size);

    // 分配用户栈页
    void *stack_page = alloc_page();
    if (!stack_page) { free_proc(p); return -1; }
    map_page(p->pagetable, user_stack - PGSIZE, (uint64)stack_page, PTE_R | PTE_W | PTE_U);

	    // 关键：将 trapframe 映射到 TRAPFRAME 虚拟地址
    if (map_page(p->pagetable, TRAPFRAME, (uint64)p->trapframe, PTE_R | PTE_W) != 0) {
        free_proc(p);
        return -1;
    }

    // 设置 trapframe
	memset(p->trapframe, 0, sizeof(*p->trapframe));
	p->trapframe->epc = user_entry; // 应为 0x10000
	p->trapframe->sp = user_stack;  // 应为 0x20000
	// 设置用户初始 sstatus：SPIE=1, SPP=0
	p->trapframe->sstatus = (1UL << 5); // 0x20
	p->trapframe->kernel_satp = MAKE_SATP(kernel_pagetable);
	p->trapframe->kernel_sp = p->kstack + PGSIZE;   // 内核栈顶
	p->trapframe->usertrap  = (uint64)usertrap;     // C 层 trap 处理函数
	p->trapframe->kernel_vec = (uint64)kernelvec;
    p->state = RUNNABLE;
	// 添加trampoline页面映射
	extern uint64 trampoline_phys_addr;
	if (map_page(p->pagetable, TRAMPOLINE, trampoline_phys_addr, PTE_X | PTE_R) != 0) {
		free_proc(p);
		return -1;
	}
    struct proc *parent = myproc();
    p->parent = parent ? parent : NULL;
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
    struct proc *child = alloc_proc(parent->is_user);
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
    printf("PID  TYPE STATUS     PPID   FUNC_ADDR      STACK_ADDR    \n");
    printf("----------------------------------------------------------\n");
    for(int i = 0; i < PROC; i++) {
        struct proc *p = proc_table[i];
        if(p->state != UNUSED) {
            count++;
            const char *type = (p->is_user ? "USR" : "SYS");
            const char *status;
            switch(p->state) {
                case UNUSED:   status = "UNUSED"; break;
                case USED:     status = "USED"; break;
                case SLEEPING: status = "SLEEP"; break;
                case RUNNABLE: status = "RUNNABLE"; break;
                case RUNNING:  status = "RUNNING"; break;
                case ZOMBIE:   status = "ZOMBIE"; break;
                default:       status = "UNKNOWN"; break;
            }
            int ppid = p->parent ? p->parent->pid : -1;
            unsigned long func_addr = p->trapframe ? p->trapframe->epc : 0;
            unsigned long stack_addr = p->kstack;
            printf("%2d  %3s %8s %4d 0x%012lx 0x%012lx\n",
                p->pid, type, status, ppid, func_addr, stack_addr);
        }
    }
    printf("----------------------------------------------------------\n");
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
    int pid = create_kernel_proc(simple_task);
    assert(pid > 0);
    printf("【测试结果】: 基本进程创建成功，PID: %d，正常退出\n", pid);

    int count = 1;
    printf("\n----- 测试进程表容量限制 -----\n");
    for (int i = 0; i < PROC+5; i++) {// 验证超量创建进程的处理
        int pid = create_kernel_proc(simple_task);
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
		int pid = create_kernel_proc(simple_task);
		if (pid > 0) {
			refill_count++;
		} else {
			warning("process table was full\n");
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
        create_kernel_proc(cpu_intensive_task);
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
    create_kernel_proc(producer_task);
    create_kernel_proc(consumer_task);

    // 等待两个进程完成
    wait_proc(NULL);
    wait_proc(NULL);

    printf("===== 测试结束 =====\n");
}

void sys_access_task(void) {
    volatile int *ptr = (int*)0x80200000; // 内核空间地址
    printf("SYS: try read kernel addr 0x80200000\n");
    int val = *ptr;
    printf("SYS: read success, value=%d\n", val);
    exit_proc(0);
}

void test_sys_usr(void) {
    printf("===== 测试: 用户/系统进程访问内核空间 =====\n");
    int sys_pid = create_kernel_proc(sys_access_task); // 系统进程
	printf("创建系统进程：%d成功\n",sys_pid);
	int status =0;
	int ret_val = wait_proc(&status); // 等待系统进程
	printf("系统进程%d退出，退出码为%d\n",ret_val,status);
    // 创建真正的用户进程，运行 user_test_bin
    int usr_pid = create_user_proc(user_test_bin, user_test_bin_len);
    printf("创建用户进程：%d成功\n", usr_pid);
    ret_val = wait_proc(&status); // 等待用户进程
    printf("用户进程%d退出，退出码为%d\n", ret_val,status);
    printf("===== 测试结束 =====\n");
}