#include "defs.h"

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
    if (!p) panic("return_to_user: no current process");

    if ((uint64)trampoline == 0 || (uint64)userret == 0) {
        panic("return_to_user: invalid trampoline addresses");
    }

    // 设置 stvec
    w_stvec(TRAMPOLINE + (uservec - trampoline));
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);

    // satp 构造（注意要用物理地址）
    uint64 satp = MAKE_SATP(p->pagetable);

    if ((trampoline_userret & ~(PGSIZE - 1)) != TRAMPOLINE) {
        panic("return_to_user: userret outside trampoline page");
    }


    // 跳到 trampoline 的 userret
    void (*userret_fn)(uint64, uint64) = (void (*)(uint64, uint64))trampoline_userret;
    userret_fn(TRAPFRAME, satp);

    panic("return_to_user: should not return");
}


void forkret(void) {
    struct proc *p = myproc();
    if (p == 0) {
        panic("forkret: no current process");
    }
    if (p->killed) {
        printf("[forkret] Process PID %d killed before execution\n", p->pid);
        exit_proc(SYS_kill);
        return; // 虽然不会执行到这里，但为了代码清晰
    }
    if (p->is_user) {
        // 用户进程：直接返回用户态
        return_to_user();
    } else {
        // 内核线程：执行入口函数
		if (p->trapframe->epc) {
			void (*fn)(uint64) = (void(*)(uint64))p->trapframe->epc;
			fn(p->trapframe->a0);
		}
        exit_proc(0);  // 内核线程函数返回则退出
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
			p->killed = 0; //重置死亡状态
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
int create_kernel_proc1(void (*entry)(uint64),uint64 arg){
	struct proc *p = alloc_proc(0);
    if (!p) return -1;
    p->trapframe->epc = (uint64)entry;
	p->trapframe->a0 = (uint64)arg;
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

	p->sz = user_stack; // 用户空间从 0x10000 到 0x20000
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
int fork_proc(void) {
    struct proc *parent = myproc();
    struct proc *child = alloc_proc(parent->is_user);
    if (!child) return -1;
    
    // 复制父进程的用户空间
    if (uvmcopy(parent->pagetable, child->pagetable, parent->sz) < 0) {
        free_proc(child);
        return -1;
    }
    child->sz = parent->sz;

    // 获取trapframe的物理地址
    uint64 tf_pa = (uint64)child->trapframe;
    
    if ((tf_pa & (PGSIZE - 1)) != 0) {
        printf("[fork] trapframe not aligned: 0x%lx\n", tf_pa);
        free_proc(child);
        return -1;
    }

    // 映射trapframe和trampoline
    if (map_page(child->pagetable, TRAPFRAME, tf_pa, PTE_R | PTE_W) != 0) {
        printf("[fork] map TRAPFRAME failed\n");
        free_proc(child);
        return -1;
    }

    extern uint64 trampoline_phys_addr;
    if (map_page(child->pagetable, TRAMPOLINE, trampoline_phys_addr, PTE_R | PTE_X) != 0) {
        printf("[fork] map TRAMPOLINE failed\n");
        free_proc(child);
        return -1;
    }

    // 复制父trapframe到子trapframe
    *(child->trapframe) = *(parent->trapframe);
	child->trapframe->kernel_sp = child->kstack + PGSIZE;
	assert(child->trapframe->kernel_satp = MAKE_SATP(kernel_pagetable));
    child->trapframe->epc += 4;  // 跳过 ecall 指令
    child->trapframe->a0 = 0;    // 子进程fork返回0

    child->state = RUNNABLE;
    child->parent = parent;
    return child->pid;
}


// 调度器 - 简化版
void schedule(void) {
  struct cpu *c = mycpu();
  while(1) {
    intr_on();
    for(int i = 0; i < PROC; i++) {
        struct proc *p = proc_table[i];
      	if(p->state == RUNNABLE) {
			p->state = RUNNING;
			c->proc = p;
			current_proc = p;
			swtch(&c->context, &p->context);
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
    intr_off();
    struct cpu *c = mycpu();
    p->state = RUNNABLE;
    //if (c->context.ra == 0) {
    //    c->context.ra = (uint64)schedule;
    //    c->context.sp = (uint64)c + PGSIZE;
    //}
    current_proc = 0;
    c->proc = 0;
    swtch(&p->context, &c->context);
    intr_on();
	if (p->killed) {
        printf("[yield] Process PID %d killed during yield\n", p->pid);
        exit_proc(SYS_kill);
        return;
    }
}
void sleep(void *chan){
    struct proc *p = myproc();
    struct cpu *c = mycpu();
    register uint64 ra asm("ra");
    p->context.ra = ra;
    p->chan = chan;
    p->state = SLEEPING;
    swtch(&p->context, &c->context);
    p->chan = 0;
	if(p->killed){
		printf("[sleep] Process PID %d killed when wakeup\n", p->pid);
		exit_proc(SYS_kill);
	}
}
void wakeup(void *chan) {
    for(int i = 0; i < PROC; i++) {
        struct proc *p = proc_table[i];
        if(p->state == SLEEPING && p->chan == chan) {
            p->state = RUNNABLE;
        }
    }
}
void kill_proc(int pid){
	for(int i=0;i<PROC;i++){
		struct proc *p = proc_table[i];
		if(pid == p->pid){
			p->killed = 1;
			break;
		}
	}
	return;
}
void exit_proc(int status) {
    struct proc *p = myproc();
    
    if (p == 0) {
        panic("exit_proc: no current process");
    }
    
    p->exit_status = status;
    
    // 如果没有父进程的初始进程退出，表示关机
    if (!p->parent) {
        shutdown();
    }
    
    // 设置为僵尸状态
    p->state = ZOMBIE;
    
    wakeup((void*)p->parent);
    // 清除当前进程
    current_proc = 0;
    if (mycpu())
        mycpu()->proc = 0;
    
    // 让出CPU给其他进程
    struct cpu *c = mycpu();
    swtch(&p->context, &c->context);
    
    panic("exit_proc should not return after schedule");
}
int wait_proc(int *status) {
    struct proc *p = myproc();
    
    if (p == 0) {
        printf("Warning: wait_proc called with no current process\n");
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
        
        // 检查是否有任何活跃的子进程（非ZOMBIE状态）
        int havekids = 0;
        for (int i = 0; i < PROC; i++) {
            struct proc *child = proc_table[i];
            if (child->state != UNUSED && child->state != ZOMBIE && child->parent == p) {
                havekids = 1;
                break;
            }
        }
        
        if (!havekids) {
            intr_on();
            return -1;
        }
        
        // 有活跃子进程但没有僵尸子进程，进入睡眠等待
		intr_on();
        sleep((void*)p);
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

struct proc* get_proc(int pid){
	    // 检查 PID 是否有效
    if (pid < 0 || pid >= PROC) {
        return 0;
    }
    // 遍历进程表查找匹配的 PID
    for (int i = 0; i < PROC; i++) {
        struct proc *p = proc_table[i];
        if (p->state != UNUSED && p->pid == pid) {
            return p;
        }
    }
    return 0;
}