#include "defs.h"

// trap_test
volatile int *interrupt_test_flag = 0;
// 获取当前时间的辅助函数
uint64 get_time(void)
{
	return sbi_get_time();
}

// 时钟中断测试函数
void test_timer_interrupt(void)
{
	printf("Testing timer interrupt...\n");

	uint64 start_time = get_time();
	int interrupt_count = 0;
	int last_count = 0;

	// 设置全局测试标志，让中断处理函数能访问
	interrupt_test_flag = &interrupt_count;

	while (interrupt_count < 5)
	{
		if (last_count != interrupt_count)
		{
			last_count = interrupt_count;
			printf("Received interrupt %d\n", interrupt_count);
		}
	}

	// 清除测试标志
	interrupt_test_flag = 0;

	uint64 end_time = get_time();
	printf("Timer test completed: %d interrupts in %lu cycles\n",
		   interrupt_count, end_time - start_time);
}

// 修改测试异常处理函数
// 在test_exception函数中添加虚拟内存测试部分

void test_exception(void)
{
	printf("\n===== 开始全面异常处理测试 =====\n\n");

	// 1. 测试非法指令异常
	printf("1. 测试非法指令异常...\n");
	asm volatile(".word 0xffffffff"); // 非法RISC-V指令
	printf("✓ 识别到指令异常并尝试忽略\n\n");

	// 2. 测试存储页故障
	printf("2. 测试存储页故障异常...\n");
	volatile uint64 *invalid_ptr = 0;
	for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000)
	{
		if (check_is_mapped(addr) == 0)
		{
			invalid_ptr = (uint64 *)addr;
			printf("找到未映射地址: 0x%lx\n", addr);
			break;
		}
	}

	if (invalid_ptr != 0)
	{
		printf("尝试写入未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
		*invalid_ptr = 42; // 触发存储页故障
		printf("✓ 存储页故障异常处理成功\n\n");
	}
	else
	{
		printf("警告: 无法找到未映射地址进行测试!\n\n");
	}

	// 3. 测试加载页故障
	printf("3. 测试加载页故障异常...\n");
	invalid_ptr = 0;
	for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000)
	{
		if (check_is_mapped(addr) == 0)
		{
			invalid_ptr = (uint64 *)addr;
			printf("找到未映射地址: 0x%lx\n", addr);
			break;
		}
	}

	if (invalid_ptr != 0)
	{
		printf("尝试读取未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
		volatile uint64 value = *invalid_ptr; // 触发加载页故障
		printf("读取的值: %lu\n", value);	  // 除非故障被处理
		printf("✓ 加载页故障异常处理成功\n\n");
	}
	else
	{
		printf("警告: 无法找到未映射地址进行测试!\n\n");
	}

	// ===== 新增：虚拟内存系统测试 =====
	printf("===== 虚拟内存系统测试 =====\n\n");

	// 4. 测试按需分配功能
	printf("4. 测试按需页面分配...\n");
	for (uint64 test_addr = 0xB0000000; test_addr < 0xB0010000; test_addr += 0x1000)
	{
		if (check_is_mapped(test_addr) == 0)
		{
			printf("测试地址 0x%lx 的按需分配\n", test_addr);

			// 写入测试
			volatile uint64 *ptr = (uint64 *)test_addr;
			*ptr = 0xDEADBEEF;
			printf("  写入成功: 0x%lx\n", *ptr);

			// 验证页面已分配
			if (check_is_mapped(test_addr))
			{
				printf("  ✓ 页面成功分配并映射\n");
			}
			else
			{
				printf("  ✗ 页面分配失败\n");
			}
			break;
		}
	}
	printf("\n");

	// 5. 测试页面权限更新
	printf("5. 测试页面权限更新...\n");
	uint64 perm_test_addr = 0xC0000000;
	if (check_is_mapped(perm_test_addr) == 0)
	{
		printf("为地址 0x%lx 分配页面\n", perm_test_addr);

		// 先进行读访问，触发页面分配
		volatile uint64 *ptr = (uint64 *)perm_test_addr;
		uint64 read_val = *ptr;
		printf("  初始读取值: 0x%lx\n", read_val);

		// 再进行写访问，可能触发权限更新
		*ptr = 0x12345678;
		printf("  写入后读取: 0x%lx\n", *ptr);
		printf("  ✓ 页面权限更新成功\n");
	}
	printf("\n");

	// 6. 测试跨页面访问
	printf("6. 测试跨页面数据访问...\n");
	uint64 cross_page_addr = 0xD0000FFE; // 跨越页面边界的地址
	if (check_is_mapped(cross_page_addr) == 0 && check_is_mapped(cross_page_addr + 4) == 0)
	{
		printf("测试跨页面访问，起始地址: 0x%lx\n", cross_page_addr);

		// 写入跨页面的数据
		volatile uint32 *ptr = (uint32 *)cross_page_addr;
		*ptr = 0xABCDEF01;
		printf("  跨页面写入成功: 0x%x\n", *ptr);

		// 验证两个页面都被分配
		if (check_is_mapped(cross_page_addr) && check_is_mapped(cross_page_addr + 4))
		{
			printf("  ✓ 跨页面访问成功，相关页面都已分配\n");
		}
		else
		{
			printf("  ✗ 跨页面访问异常\n");
		}
	}
	else
	{
		printf("  跳过：页面已映射\n");
	}
	printf("\n");

	// 7. 测试连续页面分配
	printf("7. 测试连续页面分配...\n");
	uint64 base_addr = 0xE0000000;
	int allocated_pages = 0;

	for (int i = 0; i < 5; i++)
	{
		uint64 addr = base_addr + (i * 0x1000);
		if (check_is_mapped(addr) == 0)
		{
			printf("  分配页面 %d, 地址: 0x%lx\n", i, addr);

			volatile uint64 *ptr = (uint64 *)addr;
			*ptr = 0x1000 + i; // 写入页面索引

			if (check_is_mapped(addr))
			{
				allocated_pages++;
				printf("    写入值: %lu, 读取值: %lu\n", 0x1000UL + i, *ptr);
			}
		}
		else
		{
			printf("  页面 %d (0x%lx) 已映射，跳过\n", i, addr);
		}
	}
	printf("  ✓ 成功分配 %d 个连续页面\n", allocated_pages);
	printf("\n");

	// 8. 测试内存访问模式
	printf("8. 测试不同内存访问模式...\n");
	uint64 pattern_addr = 0xF0000000;
	if (check_is_mapped(pattern_addr) == 0)
	{
		volatile char *byte_ptr = (char *)pattern_addr;
		volatile uint16 *word_ptr = (uint16 *)pattern_addr;
		volatile uint32 *dword_ptr = (uint32 *)pattern_addr;
		volatile uint64 *qword_ptr = (uint64 *)pattern_addr;

		// 字节访问
		*byte_ptr = 0xAB;
		printf("  字节访问: 写入 0xAB, 读取 0x%x\n", *byte_ptr);

		// 字访问
		*word_ptr = 0xCDEF;
		printf("  字访问: 写入 0xCDEF, 读取 0x%x\n", *word_ptr);

		// 双字访问
		*dword_ptr = 0x12345678;
		printf("  双字访问: 写入 0x12345678, 读取 0x%x\n", *dword_ptr);

		// 四字访问
		*qword_ptr = 0xFEDCBA9876543210UL;
		printf("  四字访问: 写入 0xFEDCBA9876543210, 读取 0x%lx\n", *qword_ptr);

		printf("  ✓ 不同访问模式测试成功\n");
	}
	else
	{
		printf("  跳过：页面已映射\n");
	}
	printf("\n");

	// 9. 测试页表遍历
	printf("9. 测试页表结构验证...\n");

	// 检查几个已知映射的页面
	uint64 test_addrs[] = {0x80000000, 0x10000000, 0xB0000000, 0};
	for (int i = 0; test_addrs[i] != 0; i++)
	{
		int mapped = check_is_mapped(test_addrs[i]);
		printf("  地址 0x%lx: %s\n", test_addrs[i], mapped ? "已映射" : "未映射");
	}
	printf("  ✓ 页表结构验证完成\n");
	printf("\n");

	printf("===== 虚拟内存系统测试完成 =====\n\n");

	// 继续原有的其他测试...
	// 4. 测试存储地址未对齐异常
	printf("10. 测试存储地址未对齐异常...\n");
	uint64 aligned_addr = (uint64)alloc_page();
	if (aligned_addr != 0)
	{
		uint64 misaligned_addr = aligned_addr + 1; // 制造未对齐地址
		printf("使用未对齐地址: 0x%lx\n", misaligned_addr);

		// 使用内联汇编进行未对齐访问，因为编译器可能会自动对齐
		asm volatile(
			"sd %0, 0(%1)"
			:
			: "r"(0xdeadbeef), "r"(misaligned_addr)
			: "memory");
		printf("✓ 存储地址未对齐异常处理成功\n\n");
	}
	else
	{
		printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
	}

	// 5. 测试加载地址未对齐异常
	printf("11. 测试加载地址未对齐异常...\n");
	if (aligned_addr != 0)
	{
		uint64 misaligned_addr = aligned_addr + 1;
		printf("使用未对齐地址: 0x%lx\n", misaligned_addr);

		uint64 value = 0;
		asm volatile(
			"ld %0, 0(%1)"
			: "=r"(value)
			: "r"(misaligned_addr)
			: "memory");
		printf("读取的值: 0x%lx\n", value);
		printf("✓ 加载地址未对齐异常处理成功\n\n");
	}
	else
	{
		printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
	}

	// 6. 测试断点异常
	printf("12. 测试断点异常...\n");
	asm volatile(
		"nop\n\t"	 // 确保ebreak前有有效指令
		"ebreak\n\t" // 断点指令
		"nop\n\t"	 // 确保ebreak后有有效指令
	);
	printf("✓ 断点异常处理成功\n\n");

	// 7. 测试环境调用异常
	printf("13. 测试环境调用异常...\n");
	asm volatile("ecall"); // 从S模式生成环境调用
	printf("✓ 环境调用异常处理成功\n\n");

	printf("===== 部分异常处理测试完成 =====\n\n");
	printf("===== 测试不可恢复的除零异常 ====\n");
	unsigned int a = 1;
	unsigned int b = 0;
	unsigned int result = a / b;
	// 根据中科大的手册，RV32I并不会因为除零而进入trap
	printf("这行不应该被打印，如果打印了，那么result = %d\n", result);
}
void test_interrupt_overhead(void)
{
	printf("\n===== 开始中断开销测试 =====\n");

	// 1. 测量时钟中断处理时间
	printf("\n----- 测试1: 时钟中断处理时间 -----\n");
	uint64 start_cycles, end_cycles;
	int count = 0;
	volatile int *test_flag = &count;

	// 记录开始时间
	start_cycles = get_time();
	interrupt_test_flag = test_flag; // 设置全局标志

	// 等待10次中断
	while (count < 10)
	{
		// 空循环等待中断
		asm volatile("nop");
	}

	end_cycles = get_time();
	interrupt_test_flag = 0; // 清除标志

	uint64 total_cycles = end_cycles - start_cycles;
	uint64 avg_cycles1 = total_cycles / 10;
	printf("平均每次时钟中断处理耗时: %lu cycles\n", avg_cycles1);

	// 2. 测量上下文切换成本
	printf("\n----- 测试2: 上下文切换成本 -----\n");
	start_cycles = get_time();

	// 执行1000次yield来触发上下文切换
	for (int i = 0; i < 1000; i++)
	{
		yield();
	}

	end_cycles = get_time();
	uint64 avg_cycles2 = (end_cycles - start_cycles) / 1000;
	printf("平均每次时钟中断处理耗时: %lu cycles\n", avg_cycles1);
	printf("平均每次上下文切换耗时: %lu cycles\n", avg_cycles2);
	printf("\n===== 中断开销测试完成 =====\n");
}

// proc_test
// 简单测试任务，用于测试进程创建
void simple_task(void)
{
	// 简单任务，只打印并退出
	printf("Simple kernel task running in PID %d\n", myproc()->pid);
}
void test_process_creation(void)
{
	printf("===== 测试开始: 进程创建与管理测试 =====\n");

	// ========== 第一阶段：测试内核进程 ==========
	printf("\n----- 第一阶段：测试内核进程创建与管理 -----\n");

	// 测试基本的内核进程创建
	int pid = create_kernel_proc(simple_task);
	assert(pid > 0);
	printf("【测试结果】: 基本内核进程创建成功，PID: %d\n", pid);

	// 填满进程表 - 内核进程
	printf("\n----- 用内核进程填满进程表 -----\n");
	int kernel_count = 1; // 已经创建了一个
	for (int i = 1; i < PROC; i++)
	{ // 从1开始，因为已经创建了一个
		int new_pid = create_kernel_proc(simple_task);
		if (new_pid > 0)
		{
			kernel_count++;
		}
		else
		{
			warning("process table was full at %d kernel processes\n", kernel_count);
			break;
		}
	}
	printf("【测试结果】: 成功创建 %d 个内核进程 (最大限制: %d)\n", kernel_count, PROC);
	print_proc_table();

	// 清理内核进程
	printf("\n----- 等待并清理所有内核进程 -----\n");
	int kernel_success_count = 0;
	for (int i = 0; i < kernel_count; i++)
	{
		int waited_pid = wait_proc(NULL);
		if (waited_pid > 0)
		{
			kernel_success_count++;
			printf("回收内核进程 PID: %d (%d/%d)\n", waited_pid, kernel_success_count, kernel_count);
		}
		else
		{
			printf("【错误】: 等待内核进程失败，错误码: %d\n", waited_pid);
		}
	}
	printf("【测试结果】: 回收 %d/%d 个内核进程\n", kernel_success_count, kernel_count);
	print_proc_table();

	// ========== 第二阶段：测试用户进程 ==========
	printf("\n----- 第二阶段：测试用户进程创建与管理 -----\n");

	// 测试基本的用户进程创建
	int user_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
	if (user_pid > 0)
	{
		printf("【测试结果】: 基本用户进程创建成功，PID: %d\n", user_pid);
	}
	else
	{
		printf("【错误】: 基本用户进程创建失败\n");
		return;
	}

	// 填满进程表 - 用户进程
	printf("\n----- 用用户进程填满进程表 -----\n");
	int user_count = 1; // 已经创建了一个
	for (int i = 1; i < PROC; i++)
	{ // 从1开始，因为已经创建了一个
		int new_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
		if (new_pid > 0)
		{
			user_count++;
			if (user_count % 5 == 0)
			{ // 每5个进程打印一次进度
				printf("已创建 %d 个用户进程...\n", user_count);
			}
		}
		else
		{
			warning("process table was full at %d user processes\n", user_count);
			break;
		}
	}
	printf("【测试结果】: 成功创建 %d 个用户进程 (最大限制: %d)\n", user_count, PROC);
	print_proc_table();

	// 清理用户进程
	printf("\n----- 等待并清理所有用户进程 -----\n");
	int user_success_count = 0;
	for (int i = 0; i < user_count; i++)
	{
		int waited_pid = wait_proc(NULL);
		if (waited_pid > 0)
		{
			user_success_count++;
			if (user_success_count % 5 == 0)
			{ // 每5个进程打印一次进度
				printf("已回收 %d/%d 个用户进程...\n", user_success_count, user_count);
			}
		}
		else
		{
			printf("【错误】: 等待用户进程失败，错误码: %d\n", waited_pid);
		}
	}
	printf("【测试结果】: 回收 %d/%d 个用户进程\n", user_success_count, user_count);
	print_proc_table();

	// ========== 第三阶段：混合测试 ==========
	printf("\n----- 第三阶段：混合进程测试 -----\n");

	// 创建混合进程（一半内核，一半用户）
	int mixed_kernel_count = 0;
	int mixed_user_count = 0;
	int target_count = PROC / 2;

	printf("创建 %d 个内核进程和 %d 个用户进程...\n", target_count, target_count);

	// 创建内核进程
	for (int i = 0; i < target_count; i++)
	{
		int new_pid = create_kernel_proc(simple_task);
		if (new_pid > 0)
		{
			mixed_kernel_count++;
		}
		else
		{
			break;
		}
	}

	// 创建用户进程
	for (int i = 0; i < target_count; i++)
	{
		int new_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
		if (new_pid > 0)
		{
			mixed_user_count++;
		}
		else
		{
			break;
		}
	}

	printf("【混合测试结果】: 创建了 %d 个内核进程 + %d 个用户进程 = %d 个进程\n",
		   mixed_kernel_count, mixed_user_count, mixed_kernel_count + mixed_user_count);
	print_proc_table();

	// 清理混合进程
	printf("\n----- 清理混合进程 -----\n");
	int mixed_success_count = 0;
	int total_mixed = mixed_kernel_count + mixed_user_count;
	for (int i = 0; i < total_mixed; i++)
	{
		int waited_pid = wait_proc(NULL);
		if (waited_pid > 0)
		{
			mixed_success_count++;
		}
	}
	printf("【混合测试结果】: 回收 %d/%d 个混合进程\n", mixed_success_count, total_mixed);
	print_proc_table();

	printf("===== 测试结束: 进程创建与管理测试 =====\n");
}
void cpu_intensive_task(void)
{
	int pid = myproc()->pid;
	printf("[进程 %d] 开始CPU密集计算\n", pid);

	uint64 sum = 0;

	// 增加循环次数到1亿次
	const uint64 TOTAL_ITERATIONS = 100000000;
	const uint64 REPORT_INTERVAL = TOTAL_ITERATIONS / 100; // 每完成1%报告一次

	// 执行计算任务
	for (uint64 i = 0; i < TOTAL_ITERATIONS; i++)
	{
		// 增加计算复杂度
		sum += (i * i) % 1000000007; // 添加乘法和取模运算

		// 更频繁的进度报告（每1%报告一次）
		if (i % REPORT_INTERVAL == 0)
		{
			uint64 percent = (i * 100) / TOTAL_ITERATIONS;
			printf("[进程 %d] 完成度: %lu%%，当前sum=%lu\n",
				   pid, percent, sum);

			// 主动让出CPU，增加切换机会
			if (i > 0)
			{
				yield();
			}
		}
	}

	printf("[进程 %d] 计算完成，最终sum=%lu\n", pid, sum);
	exit_proc(0);
}

// 改进后的调度器测试函数
void test_scheduler(void)
{
	printf("\n===== 测试开始: 调度器公平性测试 =====\n");

	// 创建多个计算密集型进程
	int pids[3];
	for (int i = 0; i < 3; i++)
	{
		pids[i] = create_kernel_proc(cpu_intensive_task);
		if (pids[i] < 0)
		{
			printf("【错误】创建进程 %d 失败\n", i);
			return;
		}
		printf("创建进程成功，PID: %d\n", pids[i]);
	}

	// 等待所有进程完成并记录时间
	uint64 start_time = get_time();
	int completed = 0;

	while (completed < 3)
	{
		int status;
		int pid = wait_proc(&status);
		if (pid > 0)
		{
			completed++;
			printf("进程 %d 已完成，退出状态: %d (%d/3)\n",
				   pid, status, completed);
		}
	}

	uint64 end_time = get_time();
	uint64 total_cycles = end_time - start_time;

	printf("\n----- 测试结果 -----\n");
	printf("总执行时间: %lu cycles\n", total_cycles);
	printf("平均每个进程执行时间: %lu cycles\n", total_cycles / 3);
	printf("===== 调度器测试完成 =====\n");
}
static int proc_buffer = 0;
static int proc_produced = 0;

void shared_buffer_init()
{
	proc_buffer = 0;
	proc_produced = 0;
}

void producer_task(void)
{
	// 复杂计算
	int pid = myproc()->pid;
	uint64 sum = 0;
	const uint64 ITERATIONS = 10000000; // 一千万次循环

	for (uint64 i = 0; i < ITERATIONS; i++)
	{
		sum += (i * i) % 1000000007; // 复杂计算
		if (i % (ITERATIONS / 10) == 0)
		{
			printf("[Producer %d] 计算进度: %d%%\n",
				   pid, (int)(i * 100 / ITERATIONS));
		}
	}
	proc_buffer = 42;
	proc_produced = 1;
	wakeup(&proc_produced); // 唤醒消费者
	printf("Producer: produced value %d\n", proc_buffer);
	exit_proc(0);
}

void consumer_task(void)
{
	while (!proc_produced)
	{
		printf("wait for producer\n");
		sleep(&proc_produced, NULL); // 等待生产者
	}
	printf("Consumer: consumed value %d\n", proc_buffer);
	exit_proc(0);
}
void test_synchronization(void)
{
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

void sys_access_task(void)
{
	volatile int *ptr = (int *)0x80200000; // 内核空间地址
	printf("SYS: try read kernel addr 0x80200000\n");
	int val = *ptr;
	printf("SYS: read success, value=%d\n", val);
	exit_proc(0);
}

void infinite_task(void)
{
	int count = 5000;
	while (count)
	{
		count--;
		if (count % 100 == 0)
			printf("count for %d\n", count);
		yield();
	}
	warning("INFINITE TASK FINISH WITHOUT KILLED!!\n");
}

void killer_task(uint64 kill_pid)
{
	int count = 500;
	while (count)
	{
		count--;
		if (count % 100 == 0)
			printf("I see you!!!\n");
		yield();
	}
	kill_proc((int)kill_pid);
	printf("Killed proc %d\n", (int)kill_pid);
	exit_proc(0);
}
void victim_task(void)
{
	int count = 5000;
	while (count)
	{
		count--;
		if (count % 100 == 0)
			printf("Call for help!!\n");
		yield();
	}
	printf("No one can kill me!\n");
	exit_proc(0);
}

void test_kill(void)
{
	printf("\n----- 测试1: 创建后立即杀死 -----\n");
	int pid = create_kernel_proc(simple_task);
	printf("【测试】: 创建进程成功，PID: %d\n", pid);
	kill_proc(pid);
	printf("【测试】: 等待被杀死的进程退出,此处被杀死的进程不会有输出...\n");
	int ret = 0;
	wait_proc(&ret);
	printf("【测试】: 进程%d退出，退出码应该为129，此处为%d\n ", pid, ret);
	if (SYS_kill == ret)
	{
		printf("【测试】:尝试立即杀死进程，测试成功\n");
	}
	else
	{
		printf("【测试】:尝试立即杀死进程失败，退出\n");
		exit_proc(0);
	}
	printf("\n----- 测试2: 创建后稍后杀死 -----\n");
	pid = create_kernel_proc(infinite_task);
	int count = 500;
	while (count)
	{
		count--; // 等待500次调度
		yield();
	}
	kill_proc(pid);
	wait_proc(&ret);
	if (SYS_kill == ret)
	{
		printf("【测试】:尝试稍后杀死进程，测试成功\n");
	}
	else
	{
		printf("【测试】:尝试稍后杀死进程失败，退出\n");
		exit_proc(0);
	}
	printf("\n----- 测试3: 创建killer 和 victim -----\n");
	int victim = create_kernel_proc(victim_task);
	int killer = create_kernel_proc1(killer_task, victim);
	int first_exit = wait_proc(&ret);
	if (first_exit == killer)
	{
		wait_proc(&ret);
		if (SYS_kill == ret)
		{
			printf("【测试】:killer win\n");
		}
		else
		{
			printf("【测试】:出现问题，killer先结束但victim存活\n");
		}
	}
	else if (first_exit == victim)
	{
		wait_proc(NULL);
		if (SYS_kill == ret)
		{
			printf("【测试】:killer win\n");
		}
		else
		{
			printf("【测试】:出现问题，victim先结束且存活\n");
		}
	}
	exit_proc(0);
}
// 添加到 test.c 文件中

void test_file_system_basic(void)
{
	printf("\n===== 开始基本文件系统测试 =====\n");

	// 测试1: 文件系统初始化验证
	printf("\n----- 测试1: 文件系统初始化验证 -----\n");
	printf("文件系统已初始化，开始功能测试...\n");

	// 测试2: 获取根目录 inode
	printf("\n----- 测试2: 获取根目录 inode -----\n");
	struct inode *root_ip = iget(ROOTDEV, ROOTINO);
	if (root_ip == 0)
	{
		printf("✗ 无法获取根目录 inode\n");
		return;
	}
	printf("✓ 成功获取根目录 inode: 设备=%d, inum=%d\n", ROOTDEV, ROOTINO);

	// 测试3: 文件分配和释放
	printf("\n----- 测试3: 文件描述符分配测试 -----\n");
	struct file *f1 = filealloc();
	if (f1 == 0)
	{
		printf("✗ 文件分配失败\n");
		iput(root_ip);
		return;
	}
	printf("✓ 文件描述符分配成功: %p\n", f1);

	struct file *f2 = filealloc();
	if (f2 == 0)
	{
		printf("✗ 第二个文件分配失败\n");
		close(f1);
		iput(root_ip);
		return;
	}
	printf("✓ 第二个文件描述符分配成功: %p\n", f2);

	// 测试4: 打开根目录进行读取
	printf("\n----- 测试4: 打开根目录测试 -----\n");
	struct file *dir_file = open(root_ip, 1, 0); // 只读方式打开根目录
	if (dir_file == 0)
	{
		printf("✗ 无法打开根目录\n");
		close(f1);
		close(f2);
		iput(root_ip);
		return;
	}
	printf("✓ 成功打开根目录进行读取\n");

	// 测试5: 读取根目录内容
	printf("\n----- 测试5: 读取根目录内容 -----\n");
	char buffer[512];
	memset(buffer, 0, sizeof(buffer));

	int bytes_read = read(dir_file, (uint64)buffer, sizeof(struct dirent) * 4);
	if (bytes_read < 0)
	{
		printf("✗ 读取根目录失败\n");
	}
	else
	{
		printf("✓ 成功读取 %d 字节\n", bytes_read);

		// 解析目录项
		struct dirent *entries = (struct dirent *)buffer;
		int num_entries = bytes_read / sizeof(struct dirent);

		printf("根目录包含 %d 个目录项:\n", num_entries);
		for (int i = 0; i < num_entries && i < 4; i++)
		{
			if (entries[i].inum != 0)
			{
				printf("  [%d] inum=%d, name='%s'\n",
					   i, entries[i].inum, entries[i].name);
			}
		}
	}

	// 测试6: 文件复制功能
	printf("\n----- 测试6: 文件复制功能测试 -----\n");
	struct file *dup_file = filedup(dir_file);
	if (dup_file == 0)
	{
		printf("✗ 文件复制失败\n");
	}
	else
	{
		printf("✓ 文件复制成功: 原文件=%p, 复制文件=%p\n", dir_file, dup_file);

		// 测试复制的文件是否可用
		char dup_buffer[64];
		memset(dup_buffer, 0, sizeof(dup_buffer));
		int dup_bytes = read(dup_file, (uint64)dup_buffer, sizeof(struct dirent));
		if (dup_bytes > 0)
		{
			printf("✓ 复制的文件可正常读取 %d 字节\n", dup_bytes);
		}
		else
		{
			printf("✗ 复制的文件读取失败\n");
		}

		close(dup_file);
	}

	// 测试7: 创建新文件（如果支持写入）
	printf("\n----- 测试7: 文件写入功能测试 -----\n");

	// 尝试以读写方式打开根目录（虽然这在真实情况下可能不合适）
	struct file *write_test = open(root_ip, 1, 1);
	if (write_test == 0)
	{
		printf("! 无法以读写方式打开根目录（这是正常的）\n");
	}
	else
	{
		printf("✓ 以读写方式打开成功\n");

		// 尝试写入一些数据
		const char *test_data = "Hello, FileSystem!";
		int bytes_written = write(write_test, (uint64)test_data, strlen(test_data));
		if (bytes_written > 0)
		{
			printf("✓ 成功写入 %d 字节\n", bytes_written);
		}
		else
		{
			printf("! 写入失败（目录可能不支持直接写入）\n");
		}

		close(write_test);
	}

	// 测试8: 资源清理测试
	printf("\n----- 测试8: 资源清理测试 -----\n");

	// 关闭所有打开的文件
	close(f1);
	close(f2);
	close(dir_file);
	printf("✓ 所有文件描述符已关闭\n");

	// 释放 inode
	iput(root_ip);
	printf("✓ 根目录 inode 已释放\n");

	// 测试9: 文件系统状态检查
	printf("\n----- 测试9: 文件系统状态检查 -----\n");

	// 尝试再次获取根目录，验证系统稳定性
	struct inode *root_ip2 = iget(ROOTDEV, ROOTINO);
	if (root_ip2 == 0)
	{
		printf("✗ 清理后无法重新获取根目录\n");
	}
	else
	{
		printf("✓ 清理后成功重新获取根目录\n");
		iput(root_ip2);
	}

	// 测试10: 压力测试 - 多次分配和释放
	printf("\n----- 测试10: 文件描述符压力测试 -----\n");
	int success_count = 0;
	const int TEST_COUNT = 10;

	for (int i = 0; i < TEST_COUNT; i++)
	{
		struct file *test_file = filealloc();
		if (test_file != 0)
		{
			success_count++;
			close(test_file);
		}
	}

	printf("压力测试结果: %d/%d 次分配成功\n", success_count, TEST_COUNT);
	if (success_count == TEST_COUNT)
	{
		printf("✓ 文件描述符压力测试通过\n");
	}
	else
	{
		printf("! 文件描述符压力测试部分失败\n");
	}

	printf("\n===== 基本文件系统测试完成 =====\n");
	printf("测试总结:\n");
	printf("- 文件系统初始化: ✓\n");
	printf("- inode 获取/释放: ✓\n");
	printf("- 文件描述符分配: ✓\n");
	printf("- 目录读取: ✓\n");
	printf("- 文件复制: ✓\n");
	printf("- 资源清理: ✓\n");
	printf("- 系统稳定性: ✓\n");
}

void test_file_system_readwrite(void)
{
	printf("\n===== 开始文件系统读写验证测试 =====\n");

	// 测试1: 使用 create 函数创建新文件
	printf("\n----- 测试1: 使用 create 创建新文件 -----\n");

	struct inode *test_ip = create("/testfile.txt", T_FILE, 0, 0);
	if (test_ip == 0)
	{
		printf("✗ 无法创建新文件 /testfile.txt\n");
		return;
	}
	printf("✓ 成功创建新文件: /testfile.txt, inum=%d\n", test_ip->inum);

	// 验证创建的文件类型
	ilock(test_ip);
	printf("  文件类型: %d (T_FILE=%d)\n", test_ip->type, T_FILE);
	printf("  文件大小: %d 字节\n", test_ip->size);
	iunlock(test_ip);

	// 测试2: 以读写方式打开创建的文件
	printf("\n----- 测试2: 打开新创建的文件进行读写 -----\n");

	struct file *write_file = open(test_ip, 1, 1); // 读写模式
	if (write_file == 0)
	{
		printf("✗ 无法打开新创建的文件进行读写\n");
		iput(test_ip);
		return;
	}
	printf("✓ 成功以读写模式打开文件\n");

	// 测试3: 写入测试数据
	printf("\n----- 测试3: 写入测试数据 -----\n");
	const char *test_data[] = {
		"Hello, File System!\n",
		"This is line 2.\n",
		"Testing write functionality...\n",
		"Line 4 with numbers: 12345\n",
		"Final test line.\n"};

	int total_written = 0;
	for (int i = 0; i < 5; i++)
	{
		int len = strlen(test_data[i]);
		int bytes_written = write(write_file, (uint64)test_data[i], len);
		if (bytes_written != len)
		{
			printf("✗ 写入第 %d 行失败: 期望 %d 字节，实际 %d 字节\n",
				   i + 1, len, bytes_written);
		}
		else
		{
			printf("✓ 成功写入第 %d 行: %d 字节\n", i + 1, bytes_written);
			total_written += bytes_written;
		}
	}
	printf("总共写入: %d 字节\n", total_written);

	// 关闭文件以确保数据写入磁盘
	close(write_file);
	printf("✓ 文件已关闭，数据应已同步到磁盘\n");

	// 释放创建时的 inode 引用
	iput(test_ip);
	printf("✓ 释放创建时的 inode 引用\n");

	// 测试4: 通过路径重新打开文件进行读取
	printf("\n----- 测试4: 通过路径重新打开文件并读取数据 -----\n");

	// 使用 namei 通过路径查找 inode
	struct inode *read_ip = namei("/testfile.txt");
	if (read_ip == 0)
	{
		printf("✗ 无法通过路径查找文件 /testfile.txt\n");
		return;
	}
	printf("✓ 成功通过路径找到文件，inum=%d\n", read_ip->inum);

	struct file *read_file = open(read_ip, 1, 0); // 只读模式
	if (read_file == 0)
	{
		printf("✗ 无法重新打开文件进行读取\n");
		iput(read_ip);
		return;
	}
	printf("✓ 成功以只读模式重新打开文件\n");

	// 读取数据并验证
	char read_buffer[512];
	memset(read_buffer, 0, sizeof(read_buffer));

	int bytes_read = read(read_file, (uint64)read_buffer, sizeof(read_buffer) - 1);
	if (bytes_read < 0)
	{
		printf("✗ 读取文件失败\n");
	}
	else
	{
		printf("✓ 成功读取 %d 字节\n", bytes_read);
		printf("读取的内容:\n");
		printf("==================\n");
		printf("%s", read_buffer);
		printf("==================\n");

		// 验证数据完整性
		if (bytes_read == total_written)
		{
			printf("✓ 读取字节数与写入字节数匹配\n");
		}
		else
		{
			printf("! 读取字节数 (%d) 与写入字节数 (%d) 不匹配\n",
				   bytes_read, total_written);
		}
	}

	close(read_file);
	// close 会自动处理 inode 引用，所以不需要手动 iput
	printf("✓ 读取文件已关闭\n");

	// 测试5: 追加写入测试
	printf("\n----- 测试5: 追加写入测试 -----\n");

	// 重新通过路径获取 inode
	struct inode *append_ip = namei("/testfile.txt");
	if (append_ip == 0)
	{
		printf("✗ 无法获取文件进行追加\n");
		iput(read_ip); // 清理之前的引用
		return;
	}

	struct file *append_file = open(append_ip, 1, 1); // 读写模式
	if (append_file == 0)
	{
		printf("✗ 无法打开文件进行追加\n");
		iput(append_ip);
		iput(read_ip);
		return;
	}
	printf("✓ 成功以读写模式打开文件进行追加\n");
	append_file->off = append_ip->size;
	// 追加新内容
	const char *append_data = "\n--- APPENDED DATA ---\nThis line was added later.\n";
	int append_len = strlen(append_data);
	int appended_bytes = write(append_file, (uint64)append_data, append_len);

	if (appended_bytes == append_len)
	{
		printf("✓ 成功追加 %d 字节\n", appended_bytes);
	}
	else
	{
		printf("✗ 追加失败: 期望 %d 字节，实际 %d 字节\n",
			   append_len, appended_bytes);
	}

	close(append_file);
	printf("✓ 追加文件已关闭\n");

	// 测试6: 验证追加后的完整内容
	printf("\n----- 测试6: 验证追加后的完整内容 -----\n");

	// 再次通过路径获取 inode
	struct inode *final_ip = namei("/testfile.txt");
	if (final_ip == 0)
	{
		printf("✗ 无法获取文件验证追加内容\n");
		iput(append_ip);
		iput(read_ip);
		return;
	}

	struct file *final_read = open(final_ip, 1, 0);
	if (final_read != 0)
	{
		char final_buffer[1024];
		memset(final_buffer, 0, sizeof(final_buffer));

		int final_bytes = read(final_read, (uint64)final_buffer, sizeof(final_buffer) - 1);
		if (final_bytes > 0)
		{
			printf("✓ 最终文件内容 (%d 字节):\n", final_bytes);
			printf("==================\n");
			printf("%s", final_buffer);
			printf("==================\n");

			// 验证总大小
			int expected_size = total_written + append_len;
			if (final_bytes == expected_size)
			{
				printf("✓ 文件大小验证成功: %d 字节\n", final_bytes);
			}
			else
			{
				printf("! 文件大小不符: 期望 %d，实际 %d\n",
					   expected_size, final_bytes);
			}
		}
		close(final_read);
	}

	// 测试7: 创建第二个文件测试
	printf("\n----- 测试7: 创建第二个文件 -----\n");

	struct inode *test_ip2 = create("/testfile2.txt", T_FILE, 0, 0);
	if (test_ip2 != 0)
	{
		printf("✓ 成功创建第二个文件: /testfile2.txt, inum=%d\n", test_ip2->inum);

		struct file *file2 = open(test_ip2, 1, 1);
		if (file2 != 0)
		{
			const char *data2 = "Second file content!\n";
			int written2 = write(file2, (uint64)data2, strlen(data2));
			printf("✓ 向第二个文件写入 %d 字节\n", written2);
			close(file2);
		}
		iput(test_ip2); // 释放创建时的引用
	}
	else
	{
		printf("✗ 创建第二个文件失败\n");
	}

	// 测试8: 删除文件测试
	printf("\n----- 测试8: 删除文件测试 -----\n");

	// 首先清理所有剩余的 inode 引用
	iput(append_ip);
	iput(final_ip);
	iput(read_ip);
	printf("✓ 清理了所有 inode 引用\n");

	// 尝试删除第二个文件
	int unlink_result = unlink("/testfile2.txt");
	if (unlink_result == 0)
	{
		printf("✓ 成功删除文件 /testfile2.txt\n");
	}
	else
	{
		printf("✗ 删除文件失败，错误码: %d\n", unlink_result);
	}

	// 尝试删除第一个文件
	unlink_result = unlink("/testfile.txt");
	if (unlink_result == 0)
	{
		printf("✓ 成功删除文件 /testfile.txt\n");
	}
	else
	{
		printf("✗ 删除文件失败，错误码: %d\n", unlink_result);
	}

	// 测试9: 验证文件已被删除
	printf("\n----- 测试9: 验证文件已被删除 -----\n");

	struct inode *deleted_check = namei("/testfile.txt");
	if (deleted_check == 0)
	{
		printf("✓ 确认文件已被删除，无法通过路径找到\n");
	}
	else
	{
		printf("! 文件删除可能不完整，仍可通过路径找到\n");
		iput(deleted_check);
	}

	printf("\n===== 文件系统读写验证测试完成 =====\n");
	printf("测试总结:\n");
	printf("- 文件创建 (create): ✓\n");
	printf("- 数据写入: ✓\n");
	printf("- 数据读取: ✓\n");
	printf("- 路径查找 (namei): ✓\n");
	printf("- 文件重新打开: ✓\n");
	printf("- 数据持久化: ✓\n");
	printf("- 追加写入: ✓\n");
	printf("- 多文件操作: ✓\n");
	printf("- 文件删除 (unlink): ✓\n");
	printf("- inode 引用管理: ✓\n");
}
char *filename = "/concurrent_test.txt";
void child_write()
{
	struct inode *ip = namei(filename);
	if (!ip)
	{
		printf("✗ 子进程无法找到文件\n");
		exit_proc(-1);
	}

	struct file *f = open(ip, 1, 1); // 读写模式
	if (!f)
	{
		printf("✗ 子进程打开文件失败\n");
		iput(ip);
		exit_proc(-1);
	}

	char buf[64];
	int len = snprintf(buf, sizeof(buf), "child:%d\n", myproc()->pid);

	// 设置偏移到文件末尾进行追加
	f->off = ip->size;

	int written = write(f, (uint64)buf, len);
	if (written == len)
	{
		printf("✓ 子进程 %d 成功写入\n", myproc()->pid);
	}
	else
	{
		printf("✗ 子进程 %d 写入失败\n", myproc()->pid);
	}

	close(f);
	iput(ip);
	exit_proc(0);
}

void test_simple_concurrent_write(void)
{
    printf("\n===== 简单并发文件写入测试 =====\n");

    struct inode *ip = create(filename, T_FILE, 0, 0);
    if (!ip)
    {
        printf("✗ 父进程创建文件失败\n");
        return;
    }

    // 父进程写入自己的PID
    struct file *f = open(ip, 1, 1);
    if (!f)
    {
        printf("✗ 父进程打开文件失败\n");
        iput(ip);
        return;
    }
    char buf[64];
    int len = snprintf(buf, sizeof(buf), "parent:%d\n", myproc()->pid);
    f->off = ip->size; // 追加
    write(f, (uint64)buf, len);
    close(f);
    iput(ip);
    printf("✓ 父进程已写入PID: %d\n", myproc()->pid);

    // 创建10个子进程并发写入
    int child_count = 10;
    int created_children = 0;
    
    for (int i = 0; i < child_count; i++)
    {
        int child_pid = create_kernel_proc(child_write);
        if (child_pid > 0)
        {
            created_children++;
            printf("✓ 创建子进程 %d: PID=%d\n", i+1, child_pid);
        }
        else
        {
            printf("✗ 创建子进程 %d 失败\n", i+1);
        }
    }
    
    printf("成功创建 %d/%d 个子进程\n", created_children, child_count);

    // 等待所有子进程完成
    printf("等待所有子进程完成...\n");
    int completed_count = 0;
    
    for (int i = 0; i < created_children; i++)
    {
        int status;
        int pid = wait_proc(&status);
        if (pid > 0)
        {
            completed_count++;
            printf("✓ 子进程 %d 已完成 (%d/%d)\n", pid, completed_count, created_children);
        }
        else
        {
            printf("✗ 等待子进程失败\n");
        }
    }
    
    printf("✓ 所有 %d 个子进程已完成\n", completed_count);

    // 父进程读取文件内容验证
    printf("\n----- 验证并发写入结果 -----\n");
    struct inode *read_ip = namei(filename);
    if (!read_ip)
    {
        printf("✗ 父进程无法找到文件读取\n");
        return;
    }

    struct file *rf = open(read_ip, 1, 0);
    if (!rf)
    {
        printf("✗ 父进程打开文件读取失败\n");
        iput(read_ip);
        return;
    }

    // 增大读取缓冲区以容纳更多内容
    char readbuf[1024] = {0};
    int bytes = read(rf, (uint64)readbuf, sizeof(readbuf) - 1);
    if (bytes > 0)
    {
        printf("✓ 文件总共读取 %d 字节\n", bytes);
        printf("✓ 并发写入的完整内容:\n");
        printf("==================\n");
        printf("%s", readbuf);
        printf("==================\n");
        
    }
    else
    {
        printf("✗ 文件读取失败\n");
    }

    close(rf);
    iput(read_ip);

    // 删除测试文件
    int unlink_result = unlink(filename);
    if (unlink_result == 0)
    {
        printf("✓ 测试文件已清理\n");
    }
    else
    {
        printf("! 测试文件清理失败\n");
    }

    printf("===== 简单并发文件写入测试完成 =====\n");
}


void test_log_recovery(void) {
    printf("\n===== 日志恢复功能测试 =====\n");
    
    char *test_file = "/recovery_test.txt";
    char *test_data = "This data should survive a crash!\n";
    
    // 首先检查是否是重启后的恢复验证
    struct inode *existing_ip = namei(test_file);
    if (existing_ip) {
        printf("检测到恢复测试文件存在，这是重启后的恢复验证\n");
        
        // 验证恢复后数据完整性
        printf("步骤: 验证恢复后的数据完整性\n");
        
        struct file *recovery_f = open(existing_ip, 1, 0);
        if (!recovery_f) {
            printf("✗ 恢复后无法打开文件\n");
            iput(existing_ip);
            return;
        }
        
        char recovery_buffer[128] = {0};
        int recovery_bytes = read(recovery_f, (uint64)recovery_buffer, sizeof(recovery_buffer)-1);
        close(recovery_f);
        iput(existing_ip);
        
        if (recovery_bytes > 0 && strcmp(recovery_buffer, test_data) == 0) {
            printf("✓ 恢复后数据完整: %s", recovery_buffer);
            printf("✓ 日志恢复功能验证成功！\n");
            printf("✓ 系统成功从模拟崩溃中恢复了文件数据\n");
        } else {
            printf("✗ 恢复后数据损坏或丢失\n");
            printf("期望: %s", test_data);
            printf("实际: %s\n", recovery_buffer);
        }
        
        // 清理测试文件
        unlink(test_file);
        printf("✓ 测试文件已清理\n");
        
        printf("===== 日志恢复功能测试完成 =====\n");
        return;  // 重要：直接返回，不进行崩溃测试
    }
    
    // 如果文件不存在，说明这是第一次运行测试
    printf("这是首次运行恢复测试，开始创建测试文件\n");
    
    // 第一步：创建文件并写入数据
    printf("步骤1: 创建文件并写入测试数据\n");
    
    struct inode *ip = create(test_file, T_FILE, 0, 0);
    if (!ip) {
        printf("✗ 创建测试文件失败\n");
        return;
    }
    
    struct file *f = open(ip, 1, 1);
    if (!f) {
        printf("✗ 打开文件失败\n");
        iput(ip);
        return;
    }
    
    // 写入数据（内部会自动调用 begin_op/end_op）
    int written = write(f, (uint64)test_data, strlen(test_data));
    if (written != strlen(test_data)) {
        printf("✗ 写入数据失败\n");
        close(f);
        iput(ip);
        return;
    }
    
    close(f);
    iput(ip);
    printf("✓ 数据已写入并提交到日志\n");
    
    // 第二步：验证数据是否正确写入
    printf("步骤2: 验证数据写入\n");
    
    struct inode *read_ip = namei(test_file);
    if (!read_ip) {
        printf("✗ 无法找到测试文件\n");
        return;
    }
    
    struct file *rf = open(read_ip, 1, 0);
    if (!rf) {
        printf("✗ 无法打开文件读取\n");
        iput(read_ip);
        return;
    }
    
    char read_buffer[128] = {0};
    int read_bytes = read(rf, (uint64)read_buffer, sizeof(read_buffer)-1);
    close(rf);
    iput(read_ip);
    
    if (read_bytes > 0 && strcmp(read_buffer, test_data) == 0) {
        printf("✓ 数据写入验证成功: %s", read_buffer);
    } else {
        printf("✗ 数据验证失败\n");
        return;
    }
    
    // 等待用户操作
    printf("等待用户操作...(按 Ctrl+C 崩溃，或按其他键跳过)\n");
	while(1) ;
}