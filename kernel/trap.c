#include "defs.h"
extern char trampoline[], uservec[], userret[];
extern pagetable_t kernel_pagetable;
extern void virtio_disk_intr(void);
static inline void save_exception_info(struct trapframe *tf, uint64 sepc, uint64 sstatus, uint64 scause, uint64 stval)
{
	tf->epc = sepc;
	// 其他字段需要保存在全局变量或函数参数中
}

static inline uint64 get_sepc(struct trapframe *tf)
{
	return tf->epc;
}

static inline void set_sepc(struct trapframe *tf, uint64 sepc)
{
	tf->epc = sepc;
}

// 全局测试变量，用于中断测试
extern void kernelvec();
interrupt_handler_t interrupt_vector[MAX_IRQ];
void register_interrupt(int irq, interrupt_handler_t h)
{
	if (irq >= 0 && irq < MAX_IRQ)
	{
		interrupt_vector[irq] = h;
	}
}

void unregister_interrupt(int irq)
{
	if (irq >= 0 && irq < MAX_IRQ)
		interrupt_vector[irq] = 0;
}
void enable_interrupts(int irq)
{
	plic_enable(irq);
}

void disable_interrupts(int irq)
{
	plic_disable(irq);
}

void interrupt_dispatch(int irq)
{
	if (irq >= 0 && irq < MAX_IRQ && interrupt_vector[irq])
	{
		interrupt_vector[irq]();
	}
}
// 处理外部中断
void handle_external_interrupt(void)
{
	// 从PLIC获取中断号
	int irq = plic_claim();

	if (irq == 0)
	{
		// 虚假中断
		debug("Spurious external interrupt\n");
		return;
	}
	interrupt_dispatch(irq);
	plic_complete(irq);
}

void trap_init(void)
{
	debug("trap_init...\n");
	w_stvec((uint64)kernelvec);
	for (int i = 0; i < MAX_IRQ; i++)
	{
		interrupt_vector[i] = 0;
	}
	plic_init(); // 初始化PLIC（外部中断控制器）
	uint64 sie = r_sie();
	w_sie(sie | (1L << 5) | (1L << 9)); // 设置SIE.STIE位启用时钟中断和外部中断
	sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
	debug("Registered exception handlers: store_page_fault=%p\n", handle_store_page_fault);
	debug("trap_init complete.\n");
}

void kerneltrap(void)
{
	// 保存当前中断状态
	uint64 sstatus = r_sstatus();
	uint64 scause = r_scause();
	uint64 sepc = r_sepc();
	uint64 stval = r_stval();

	// 检查是否为中断（最高位为1表示中断）
	if (scause & 0x8000000000000000)
	{
		// 处理中断
		if ((scause & 0xff) == 5)
		{
			// 时钟中断
			timeintr();
			sbi_set_time(sbi_get_time() + TIMER_INTERVAL);	
		}
		else if ((scause & 0xff) == 9)
		{
			// 外部中断
			handle_external_interrupt();
		}
		else
		{
			debug("kerneltrap: unknown interrupt scause=%lx sepc=%lx\n", scause, sepc);
		}
	}
	else
	{
		// 处理异常（最高位为0）
		debug("Exception: scause=%ld, sepc=0x%lx, stval=0x%lx\n", scause, sepc, stval);

		// 构造trapframe结构
		struct trapframe tf;
		save_exception_info(&tf, sepc, sstatus, scause, stval);

		// 创建一个trap_info用于传递额外信息
		struct trap_info info;
		info.sepc = sepc;
		info.sstatus = sstatus;
		info.scause = scause;
		info.stval = stval;

		// 调用异常处理函数
		handle_exception(&tf, &info);

		// 更新sepc
		sepc = get_sepc(&tf);
	}

	// 恢复中断现场
	w_sepc(sepc);
	w_sstatus(sstatus);
}
// 修改函数声明
void handle_exception(struct trapframe *tf, struct trap_info *info)
{
	uint64 cause = info->scause; // 使用info中的字段

	switch (cause)
	{
	case 0: // 指令地址未对齐
		debug("Instruction address misaligned: 0x%lx\n", info->stval);
		if (myproc()->is_user)
		{
			exit_proc(-1);
		}
		set_sepc(tf, info->sepc + 4); // 使用辅助函数
		break;

	case 1: // 指令访问故障
		debug("Instruction access fault: 0x%lx\n", info->stval);
		if (myproc()->is_user)
		{
			exit_proc(-1);
		}
		set_sepc(tf, info->sepc + 4); // 使用辅助函数
		break;

	case 2: // 非法指令
		// 检查是否是除0导致的非法指令
		uint32_t instruction;
		if (copyin((char *)&instruction, (uint64)info->sepc, 4) == 0)
		{
			uint32_t opcode = instruction & 0x7f;
			uint32_t funct3 = (instruction >> 12) & 0x7;

			// 检查是否是除法指令（rv64i中的div/divu/rem/remu等）
			if (opcode == 0x33 && (funct3 == 0x4 || funct3 == 0x5 ||
								   funct3 == 0x6 || funct3 == 0x7))
			{
				debug("[FATAL] Process %d killed by divide by zero\n", myproc()->pid);
				exit_proc(-1); // 直接终止进程
			}
			else
			{
				debug("Illegal instruction at 0x%lx: 0x%lx\n",
					  info->sepc, info->stval);
			}
		}
		else
		{
			debug("Illegal instruction at 0x%lx: 0x%lx\n",
				  info->sepc, info->stval);
		}
		// 用户进程直接终止
		if (myproc()->is_user)
		{
			exit_proc(-1);
		}
		// 内核进程跳过故障指令
		set_sepc(tf, info->sepc + 4);
		break;

	case 3: // 断点
		debug("Breakpoint at 0x%lx\n", info->sepc);
		set_sepc(tf, info->sepc + 4);
		break;

	case 4: // 加载地址未对齐
		debug("Load address misaligned: 0x%lx\n", info->stval);
		if (myproc()->is_user)
		{
			exit_proc(-1);
		}
		set_sepc(tf, info->sepc + 4);
		break;

	case 5: // 加载访问故障
		debug("Load access fault: 0x%lx\n", info->stval);
		// 尝试先增加页权限
		if (check_is_mapped(info->stval) && handle_page_fault(info->stval, 2))
		{
			return; // 成功处理
		}
		// 如果无法处理或不是权限问题，则跳过错误指令
		set_sepc(tf, info->sepc + 4);
		break;

	case 6: // 存储地址未对齐
		debug("Store address misaligned: 0x%lx\n", info->stval);
		if (myproc()->is_user)
		{
			exit_proc(-1);
		}
		set_sepc(tf, info->sepc + 4);
		break;

	case 7: // 存储访问故障
		debug("Store access fault: 0x%lx\n", info->stval);
		// 尝试先增加页权限
		if (check_is_mapped(info->stval) && handle_page_fault(info->stval, 3))
		{
			return; // 成功处理
		}
		// 如果无法处理或不是权限问题，则跳过错误指令
		set_sepc(tf, info->sepc + 4);
		break;

	case 8: // 用户模式环境调用
		if (myproc()->is_user)
		{
			handle_syscall(tf, info);
		}
		else
		{
			warning("[EXCEPTION] ecall was called in S-mode");
		}
		break;

	case 9: // 监督模式环境调用
		debug("Supervisor environment call at 0x%lx\n", info->sepc);
		set_sepc(tf, info->sepc + 4);
		break;

	case 12: // 指令页故障
		handle_instruction_page_fault(tf, info);
		break;

	case 13: // 加载页故障
		handle_load_page_fault(tf, info);
		break;

	case 15: // 存储页故障
		handle_store_page_fault(tf, info);
		break;

	default:
		debug("Unknown exception: cause=%ld, sepc=0x%lx, stval=0x%lx\n",
			  cause, info->sepc, info->stval);
		panic("Unknown exception");
		break;
	}
}
void handle_syscall(struct trapframe *tf, struct trap_info *info)
{
	switch (tf->a7)
	{
	case SYS_printint:
		debug("[syscall] print int: %ld\n", tf->a0);
		printf("%ld", tf->a0);
		break;

	case SYS_printstr:
		char buf[128];
		if (copyinstr(buf, myproc()->pagetable, tf->a0, sizeof(buf)) < 0)
		{
			debug("[syscall] invalid string\n");
			break;
		}
		debug("[syscall] print str: %s\n", buf);
		printf("%s", buf);
		break;
	case SYS_exit:
		debug("[syscall] exit(%ld)\n", tf->a0);
		exit_proc((int)tf->a0);
		break;
	case SYS_kill:
		if (myproc()->pid == tf->a0)
		{
			warning("[syscall] will kill itself!!!\n");
		}
		kill_proc(tf->a0);
		break;
	case SYS_fork:
		int child_pid = fork_proc();
		tf->a0 = child_pid;
		debug("[syscall] fork -> %d\n", child_pid);
		break;
	case SYS_wait:
	{
		uint64 uaddr = tf->a0;
		int kstatus = 0;
		int pid = wait_proc(uaddr ? &kstatus : NULL); // 在内核里等待并得到退出码

		if (pid >= 0 && uaddr)
		{
			// 将内核中的 kstatus 写回用户空间
			if (copyout(myproc()->pagetable, uaddr, (char *)&kstatus, sizeof(kstatus)) < 0)
			{
				pid = -1; // 用户空间地址不可写，视为失败
			}
		}
		tf->a0 = pid;
		break;
	}
	case SYS_yield:
		tf->a0 = 0;
		yield();
		break;
	case SYS_pid:
		tf->a0 = myproc()->pid;
		break;
	case SYS_ppid:
		tf->a0 = myproc()->parent ? myproc()->parent->pid : 0;
		break;
	case SYS_get_time:
		tf->a0 = get_time();
		break;
	case SYS_step:
		tf->a0 = 0;
		debug("[syscall] step enabled but do nothing\n");
		break;
	case SYS_open:
	{
		char path[128];
		int flags = tf->a1; // 打开标志 (O_RDONLY, O_WRONLY, O_RDWR, O_CREATE等)
		int mode = tf->a2;	// 文件模式 (暂时不使用)

		// 从用户空间复制文件路径
		if (copyinstr(path, myproc()->pagetable, tf->a0, sizeof(path)) < 0)
		{
			debug("[syscall] invalid path in open\n");
			tf->a0 = -1;
			break;
		}

		debug("[syscall] open: path=%s, flags=%d\n", path, flags);

		// 调用内核的文件打开函数
		int fd = ker_open(path, flags, mode);
		tf->a0 = fd;
		break;
	}

	case SYS_close:
	{
		int fd = tf->a0;
		debug("[syscall] close: fd=%d\n", fd);

		int result = ker_close(fd);
		tf->a0 = result;
		break;
	}

	case SYS_read:
	{
		int fd = tf->a0;	 // 文件描述符
		uint64 buf = tf->a1; // 用户缓冲区地址
		int n = tf->a2;		 // 要读取的字节数

		// 检查用户提供的缓冲区地址是否合法
		if (check_user_addr(buf, n, 1) < 0)
		{ // 1表示写入访问
			debug("[syscall] invalid read buffer address\n");
			tf->a0 = -1;
			break;
		}

		// 为标准输入保留原有逻辑
		if (fd == 0)
		{
			// TODO: 实现从控制台读取
			tf->a0 = -1;
			break;
		}

		debug("[syscall] read: fd=%d, buf=0x%lx, n=%d\n", fd, buf, n);

		// 调用内核的文件读取函数
		int result = ker_read(fd, buf, n);
		tf->a0 = result;
		break;
	}

	case SYS_write:
	{
		int fd = tf->a0;	 // 文件描述符
		uint64 buf = tf->a1; // 用户缓冲区地址
		int n = tf->a2;		 // 要写入的字节数

		// 为标准输出保留原有逻辑
		if (fd == 1 || fd == 2)
		{
			char kbuf[128]; // 临时缓冲区

			// 检查用户提供的缓冲区地址是否合法
			if (check_user_addr(buf, n, 0) < 0)
			{
				debug("[syscall] invalid write buffer address\n");
				tf->a0 = -1;
				break;
			}

			// 从用户空间安全地复制字符串
			if (copyinstr(kbuf, myproc()->pagetable, buf, sizeof(kbuf)) < 0)
			{
				debug("[syscall] invalid write buffer\n");
				tf->a0 = -1;
				break;
			}

			// 输出到控制台
			printf("%s", kbuf);
			tf->a0 = strlen(kbuf); // 返回写入的字节数
			break;
		}

		// 检查用户提供的缓冲区地址是否合法
		if (check_user_addr(buf, n, 0) < 0)
		{
			debug("[syscall] invalid write buffer address\n");
			tf->a0 = -1;
			break;
		}

		debug("[syscall] write: fd=%d, buf=0x%lx, n=%d\n", fd, buf, n);

		// 调用内核的文件写入函数
		int result = ker_write(fd, buf, n);
		tf->a0 = result;
		break;
	}
	case SYS_unlink:
{
    char path[128];
    
    // 从用户空间复制文件路径
    if (copyinstr(path, myproc()->pagetable, tf->a0, sizeof(path)) < 0) {
        debug("[syscall] invalid path in unlink\n");
        tf->a0 = -1;
        break;
    }
    
    debug("[syscall] unlink: path=%s\n", path);
    
    // 调用内核的文件删除函数
    int result = ker_unlink(path);
    tf->a0 = result;
    break;
}
	case SYS_sbrk:
		tf->a0 = -1;
		break;
	default:
		debug("[syscall] unknown syscall: %ld\n", tf->a7);
		tf->a0 = -1;
		break;
	}
	set_sepc(tf, info->sepc + 4);
}

// 处理指令页故障
void handle_instruction_page_fault(struct trapframe *tf, struct trap_info *info)
{
	debug("Instruction page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);

	// 尝试处理页面故障
	if (handle_page_fault(info->stval, 1))
	{			// 1表示指令页
		return; // 成功处理页面故障，可以继续执行
	}

	// 无法处理的页面故障
	panic("Unhandled instruction page fault");
}

// 处理加载页故障
void handle_load_page_fault(struct trapframe *tf, struct trap_info *info)
{
	debug("Load page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);

	// 尝试处理页面故障
	if (handle_page_fault(info->stval, 2))
	{			// 2表示读数据页
		return; // 成功处理页面故障，可以继续执行
	}

	// 无法处理的页面故障
	panic("Unhandled load page fault");
}

// 处理存储页故障
void handle_store_page_fault(struct trapframe *tf, struct trap_info *info)
{
	debug("Store page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);

	// 尝试处理页面故障
	if (handle_page_fault(info->stval, 3))
	{			// 3表示写数据页
		return; // 成功处理页面故障，可以继续执行
	}

	// 无法处理的页面故障
	panic("Unhandled store page fault");
}

void usertrap(void)
{
	struct proc *p = myproc();
	struct trapframe *tf = p->trapframe;

	uint64 scause = r_scause();
	uint64 stval = r_stval();
	uint64 sepc = tf->epc;		  // 已由 trampoline 保存
	uint64 sstatus = tf->sstatus; // 已由 trampoline 保存

	uint64 code = scause & 0xff;
	uint64 is_intr = (scause >> 63);

	if (!is_intr && code == 8)
	{ // 用户态 ecall
		struct trap_info info = {.sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval};
		handle_syscall(tf, &info);
		// handle_syscall 应该已 set_sepc(tf, sepc+4)
	}
	else if (is_intr)
	{
		if (code == 5)
		{
			timeintr();
			sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
		}
		else if (code == 9)
		{
			handle_external_interrupt();
		}
		else
		{
			debug("[usertrap] unknown interrupt scause=%lx sepc=%lx\n", scause, sepc);
		}
	}
	else
	{
		struct trap_info info = {.sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval};
		handle_exception(tf, &info);
	}

	usertrapret();
}

void usertrapret(void)
{
	struct proc *p = myproc();
	// 计算 trampoline 中 uservec 的虚拟地址（对双方页表一致）
	uint64 uservec_va = (uint64)TRAMPOLINE + ((uint64)uservec - (uint64)trampoline);
	w_stvec(uservec_va);

	// sscratch 设为 TRAPFRAME 的虚拟地址（trampoline 代码用它访问 tf）
	w_sscratch((uint64)TRAPFRAME);

	// 准备用户页表的 satp
	uint64 user_satp = MAKE_SATP(p->pagetable);

	// 计算 trampoline 中 userret 的虚拟地址
	uint64 userret_va = (uint64)TRAMPOLINE + ((uint64)userret - (uint64)trampoline);

	// a0 = TRAPFRAME（虚拟地址，双方页表都映射）
	// a1 = user_satp
	register uint64 a0 asm("a0") = (uint64)TRAPFRAME;
	register uint64 a1 asm("a1") = user_satp;
	register void (*tgt)(uint64, uint64) asm("t0") = (void *)userret_va;

	// 跳到 trampoline 上的 userret
	asm volatile("jr t0" ::"r"(a0), "r"(a1), "r"(tgt) : "memory");
}
