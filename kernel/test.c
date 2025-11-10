#include "defs.h"

// trap_test
volatile int *interrupt_test_flag = 0;
// 获取当前时间的辅助函数
uint64 get_time(void) {
    return sbi_get_time();
}

// 时钟中断测试函数
void test_timer_interrupt(void) {
    printf("Testing timer interrupt...\n");

    uint64 start_time = get_time();
    int interrupt_count = 0;
    int last_count = 0;

    // 设置全局测试标志，让中断处理函数能访问
    interrupt_test_flag = &interrupt_count;

    while (interrupt_count < 5) {
        if (last_count != interrupt_count) {
            last_count = interrupt_count;
            printf("Received interrupt %d\n", interrupt_count);
        }
        // 简单延时
        for (volatile int i = 0; i < 1000000; i++);
    }

    // 清除测试标志
    interrupt_test_flag = 0;

    uint64 end_time = get_time();
    printf("Timer test completed: %d interrupts in %lu cycles\n",
           interrupt_count, end_time - start_time);
}

// 修改测试异常处理函数
void test_exception(void) {
    printf("\n===== 开始全面异常处理测试 =====\n\n");
    
    // 1. 测试非法指令异常
    printf("1. 测试非法指令异常...\n");
    asm volatile (".word 0xffffffff");  // 非法RISC-V指令
    printf("✓ 识别到指令异常并尝试忽略\n\n");
    
    // 2. 测试存储页故障
    printf("2. 测试存储页故障异常...\n");
    volatile uint64 *invalid_ptr = 0;
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
        if (check_is_mapped(addr) == 0) {
            invalid_ptr = (uint64*)addr;
            printf("找到未映射地址: 0x%lx\n", addr);
            break;
        }
    }
    
    if (invalid_ptr != 0) {
        printf("尝试写入未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
        *invalid_ptr = 42;  // 触发存储页故障
        printf("✓ 存储页故障异常处理成功\n\n");
    } else {
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    }
    
    // 3. 测试加载页故障
    printf("3. 测试加载页故障异常...\n");
    invalid_ptr = 0;
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
        if (check_is_mapped(addr) == 0) {
            invalid_ptr = (uint64*)addr;
            printf("找到未映射地址: 0x%lx\n", addr);
            break;
        }
    }
    
    if (invalid_ptr != 0) {
        printf("尝试读取未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
        volatile uint64 value = *invalid_ptr;  // 触发加载页故障
        printf("读取的值: %lu\n", value);  // 除非故障被处理
        printf("✓ 加载页故障异常处理成功\n\n");
    } else {
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    }
    
    // 4. 测试存储地址未对齐异常
    printf("4. 测试存储地址未对齐异常...\n");
    uint64 aligned_addr = (uint64)alloc_page();
    if (aligned_addr != 0) {
        uint64 misaligned_addr = aligned_addr + 1;  // 制造未对齐地址
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
        
        // 使用内联汇编进行未对齐访问，因为编译器可能会自动对齐
        asm volatile (
            "sd %0, 0(%1)"
            : 
            : "r" (0xdeadbeef), "r" (misaligned_addr)
            : "memory"
        );
        printf("✓ 存储地址未对齐异常处理成功\n\n");
    } else {
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    }
    
    // 5. 测试加载地址未对齐异常
    printf("5. 测试加载地址未对齐异常...\n");
    if (aligned_addr != 0) {
        uint64 misaligned_addr = aligned_addr + 1;
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
        
        uint64 value = 0;
        asm volatile (
            "ld %0, 0(%1)"
            : "=r" (value)
            : "r" (misaligned_addr)
            : "memory"
        );
        printf("读取的值: 0x%lx\n", value);
        printf("✓ 加载地址未对齐异常处理成功\n\n");
    } else {
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    }

	// 6. 测试断点异常
	printf("6. 测试断点异常...\n");
	asm volatile (
		"nop\n\t"      // 确保ebreak前有有效指令
		"ebreak\n\t"   // 断点指令
		"nop\n\t"      // 确保ebreak后有有效指令
	);
	printf("✓ 断点异常处理成功\n\n");
    // 7. 测试环境调用异常
    printf("7. 测试环境调用异常...\n");
    asm volatile ("ecall");  // 从S模式生成环境调用
    printf("✓ 环境调用异常处理成功\n\n");
    
    printf("===== 部分异常处理测试完成 =====\n\n");
	printf("===== 测试不可恢复的除零异常 ====\n");
	unsigned int a = 1;
	unsigned int b =0;
	unsigned int result = a/b;
	// 根据中科大的手册，RV32I并不会因为除零而进入trap
	printf("这行不应该被打印，如果打印了，那么result = %d\n",result);
}
void test_interrupt_overhead(void) {
    printf("\n===== 开始中断开销测试 =====\n");

    // 1. 测量时钟中断处理时间
    printf("\n----- 测试1: 时钟中断处理时间 -----\n");
    uint64 start_cycles, end_cycles;
    int count = 0;
    volatile int *test_flag = &count;
    
    // 记录开始时间
    start_cycles = get_time();
    interrupt_test_flag = test_flag;  // 设置全局标志
    
    // 等待10次中断
    while(count < 10) {
        // 空循环等待中断
        asm volatile("nop");
    }
    
    end_cycles = get_time();
    interrupt_test_flag = 0;  // 清除标志
    
    uint64 total_cycles = end_cycles - start_cycles;
    uint64 avg_cycles1 = total_cycles / 10;
    printf("平均每次时钟中断处理耗时: %lu cycles\n", avg_cycles1);
    
    // 2. 测量上下文切换成本
    printf("\n----- 测试2: 上下文切换成本 -----\n");
    start_cycles = get_time();
    
    // 执行1000次yield来触发上下文切换
    for(int i = 0; i < 1000; i++) {
        asm volatile (".word 0xffffffff");  // 非法RISC-V指令
    }
    
    end_cycles = get_time();
    uint64 avg_cycles2 = (end_cycles - start_cycles) / 1000;
	printf("平均每次时钟中断处理耗时: %lu cycles\n", avg_cycles1);
    printf("平均每次上下文切换耗时: %lu cycles\n", avg_cycles2);
    printf("\n===== 中断开销测试完成 =====\n");
}

// proc_test
// 简单测试任务，用于测试进程创建
void simple_task(void) {
    // 简单任务，只打印并退出
    printf("Simple kernel task running in PID %d\n", myproc()->pid);
}
void test_process_creation(void) {
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
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
        int new_pid = create_kernel_proc(simple_task);
        if (new_pid > 0) {
            kernel_count++; 
        } else {
            warning("process table was full at %d kernel processes\n", kernel_count);
            break;
        }
    }
    printf("【测试结果】: 成功创建 %d 个内核进程 (最大限制: %d)\n", kernel_count, PROC);
    print_proc_table();

    // 清理内核进程
    printf("\n----- 等待并清理所有内核进程 -----\n");
    int kernel_success_count = 0;
    for (int i = 0; i < kernel_count; i++) {
        int waited_pid = wait_proc(NULL);
        if (waited_pid > 0) {
            kernel_success_count++;
            printf("回收内核进程 PID: %d (%d/%d)\n", waited_pid, kernel_success_count, kernel_count);
        } else {
            printf("【错误】: 等待内核进程失败，错误码: %d\n", waited_pid);
        }
    }
    printf("【测试结果】: 回收 %d/%d 个内核进程\n", kernel_success_count, kernel_count);
    print_proc_table();

    // ========== 第二阶段：测试用户进程 ==========
    printf("\n----- 第二阶段：测试用户进程创建与管理 -----\n");
    
    // 测试基本的用户进程创建
    int user_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
    if (user_pid > 0) {
        printf("【测试结果】: 基本用户进程创建成功，PID: %d\n", user_pid);
    } else {
        printf("【错误】: 基本用户进程创建失败\n");
        return;
    }

    // 填满进程表 - 用户进程
    printf("\n----- 用用户进程填满进程表 -----\n");
    int user_count = 1; // 已经创建了一个
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
        int new_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
        if (new_pid > 0) {
            user_count++;
            if (user_count % 5 == 0) { // 每5个进程打印一次进度
                printf("已创建 %d 个用户进程...\n", user_count);
            }
        } else {
            warning("process table was full at %d user processes\n", user_count);
            break;
        }
    }
    printf("【测试结果】: 成功创建 %d 个用户进程 (最大限制: %d)\n", user_count, PROC);
    print_proc_table();

    // 清理用户进程
    printf("\n----- 等待并清理所有用户进程 -----\n");
    int user_success_count = 0;
    for (int i = 0; i < user_count; i++) {
        int waited_pid = wait_proc(NULL);
        if (waited_pid > 0) {
            user_success_count++;
            if (user_success_count % 5 == 0) { // 每5个进程打印一次进度
                printf("已回收 %d/%d 个用户进程...\n", user_success_count, user_count);
            }
        } else {
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
    for (int i = 0; i < target_count; i++) {
        int new_pid = create_kernel_proc(simple_task);
        if (new_pid > 0) {
            mixed_kernel_count++;
        } else {
            break;
        }
    }
    
    // 创建用户进程
    for (int i = 0; i < target_count; i++) {
        int new_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
        if (new_pid > 0) {
            mixed_user_count++;
        } else {
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
    for (int i = 0; i < total_mixed; i++) {
        int waited_pid = wait_proc(NULL);
        if (waited_pid > 0) {
            mixed_success_count++;
        }
    }
    printf("【混合测试结果】: 回收 %d/%d 个混合进程\n", mixed_success_count, total_mixed);
    print_proc_table();

    printf("===== 测试结束: 进程创建与管理测试 =====\n");
}
void test_user_fork(void) {
    printf("===== 测试开始: 用户进程Fork测试 =====\n");
    
    // 创建fork测试进程
    printf("\n----- 创建fork测试进程 -----\n");
    int fork_test_pid = create_user_proc(fork_user_test_bin, fork_user_test_bin_len);
    
    if (fork_test_pid < 0) {
        printf("【错误】: 创建fork测试进程失败\n");
        return;
    }
    
    printf("【测试结果】: 创建fork测试进程成功，PID: %d\n", fork_test_pid);
    
    // 等待fork测试进程完成
    printf("\n----- 等待fork测试进程完成 -----\n");
    int status;
    int waited_pid = wait_proc(&status);
    if (waited_pid == fork_test_pid) {
        printf("【测试结果】: fork测试进程(PID: %d)完成，状态码: %d\n", fork_test_pid, status);
        printf("✓ Fork测试: 通过\n");
    } else {
        printf("【错误】: 等待fork测试进程时出错，等待到PID: %d，期望PID: %d\n", waited_pid, fork_test_pid);
        printf("✗ Fork测试: 失败\n");
    }
    printf("===== 测试结束: 用户进程Fork测试 =====\n");
}
void cpu_intensive_task(void) {
    int pid = myproc()->pid;
    printf("[进程 %d] 开始CPU密集计算\n", pid);
    
    uint64 sum = 0;
    
    // 增加循环次数到1亿次
    const uint64 TOTAL_ITERATIONS = 100000000;
    const uint64 REPORT_INTERVAL = TOTAL_ITERATIONS / 100;  // 每完成1%报告一次
    
    // 执行计算任务
    for (uint64 i = 0; i < TOTAL_ITERATIONS; i++) {
        // 增加计算复杂度
        sum += (i * i) % 1000000007;  // 添加乘法和取模运算
        
        // 更频繁的进度报告（每1%报告一次）
        if (i % REPORT_INTERVAL == 0) {
            uint64 percent = (i * 100) / TOTAL_ITERATIONS;
            printf("[进程 %d] 完成度: %lu%%，当前sum=%lu\n", 
                   pid, percent, sum);
            
            // 主动让出CPU，增加切换机会
            if (i > 0) {
                yield();
            }
        }
    }
    
    printf("[进程 %d] 计算完成，最终sum=%lu\n", pid, sum);
    exit_proc(0);
}

// 改进后的调度器测试函数
void test_scheduler(void) {
    printf("\n===== 测试开始: 调度器公平性测试 =====\n");
    
    // 创建多个计算密集型进程
    int pids[3];
    for (int i = 0; i < 3; i++) {
        pids[i] = create_kernel_proc(cpu_intensive_task);
        if (pids[i] < 0) {
            printf("【错误】创建进程 %d 失败\n", i);
            return;
        }
        printf("创建进程成功，PID: %d\n", pids[i]);
    }
    
    // 等待所有进程完成并记录时间
    uint64 start_time = get_time();
    int completed = 0;
    
    while (completed < 3) {
        int status;
        int pid = wait_proc(&status);
        if (pid > 0) {
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

void shared_buffer_init() {
    proc_buffer = 0;
    proc_produced = 0;
}

void producer_task(void) {
	// 复杂计算
	int pid = myproc()->pid;
    uint64 sum = 0;
    const uint64 ITERATIONS = 10000000;  // 一千万次循环
    
    for(uint64 i = 0; i < ITERATIONS; i++) {
        sum += (i * i) % 1000000007;  // 复杂计算
        if(i % (ITERATIONS/10) == 0) {
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

void consumer_task(void) {
    while (!proc_produced) {
		printf("wait for producer\n");
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

void infinite_task(void){
	int count = 5000 ;
	while(count){
		count--;
		if (count % 100 == 0)
			printf("count for %d\n",count);
		yield();
	}
	warning("INFINITE TASK FINISH WITHOUT KILLED!!\n");
}

void killer_task(uint64 kill_pid){
	int count = 500;
	while(count){
		count--;
		if(count % 100 == 0)
			printf("I see you!!!\n");
		yield();
	}
	kill_proc((int)kill_pid);
	printf("Killed proc %d\n",(int)kill_pid);
	exit_proc(0);
}
void victim_task(void){
	int count =5000;
	while(count){
		count--;
		if(count % 100 == 0)
			printf("Call for help!!\n");
		yield();
	}
	printf("No one can kill me!\n");
	exit_proc(0);
}

void test_kill(void){
	printf("\n----- 测试1: 创建后立即杀死 -----\n");
	int pid =create_kernel_proc(simple_task);
	printf("【测试】: 创建进程成功，PID: %d\n", pid);
	kill_proc(pid);
	printf("【测试】: 等待被杀死的进程退出,此处被杀死的进程不会有输出...\n");
	int ret =0;
	wait_proc(&ret);
	printf("【测试】: 进程%d退出，退出码应该为129，此处为%d\n ",pid,ret);
	if(SYS_kill == ret){
		printf("【测试】:尝试立即杀死进程，测试成功\n");
	}else{
		printf("【测试】:尝试立即杀死进程失败，退出\n");
		exit_proc(0);
	}
	printf("\n----- 测试2: 创建后稍后杀死 -----\n");
	pid = create_kernel_proc(infinite_task);
	int count = 500;
	while(count){
		count--; //等待500次调度
		yield();
	}
	kill_proc(pid);
	wait_proc(&ret);
	if(SYS_kill == ret){
		printf("【测试】:尝试稍后杀死进程，测试成功\n");
	}else{
		printf("【测试】:尝试稍后杀死进程失败，退出\n");
		exit_proc(0);
	}
	printf("\n----- 测试3: 创建killer 和 victim -----\n");
	int victim = create_kernel_proc(victim_task);
	int killer = create_kernel_proc1(killer_task,victim);
	int first_exit = wait_proc(&ret);
	if(first_exit == killer){
		wait_proc(&ret);
		if(SYS_kill == ret){
			printf("【测试】:killer win\n");
		}else{
			printf("【测试】:出现问题，killer先结束但victim存活\n");
		}
	}else if(first_exit == victim){
		wait_proc(NULL);
		if(SYS_kill == ret){
			printf("【测试】:killer win\n");
		}else{
			printf("【测试】:出现问题，victim先结束且存活\n");
		}
	}
	exit_proc(0);
}
void test_user_kill(void){
	printf("===== 测试开始: 用户进程Kill测试 =====\n");
    
    printf("\n----- 创建fork测试进程 -----\n");
    int test_pid = create_user_proc(kill_user_test_bin, kill_user_test_bin_len);
    
    if (test_pid < 0) {
        printf("【错误】: 创建fork测试进程失败\n");
        return;
    }
    
    printf("【测试结果】: 创建fork测试进程成功，PID: %d\n", test_pid);
    
    // 等待fork测试进程完成
    printf("\n----- 等待fork测试进程完成 -----\n");
    int status;
    int waited_pid = wait_proc(&status);
    if (waited_pid == test_pid) {
        printf("【测试结果】: fork测试进程(PID: %d)完成，状态码: %d\n", test_pid, status);
    } else {
        printf("【错误】: 等待fork测试进程时出错，等待到PID: %d，期望PID: %d\n", waited_pid, test_pid);
    }
    printf("===== 测试结束: 用户进程Kill测试 =====\n");
}
void test_file_syscalls(void) {
    printf("\n===== 测试开始: 文件系统调用测试 =====\n");
    
    printf("\n----- 创建文件测试进程 -----\n");
    int test_pid = create_user_proc(file_test_bin, file_test_bin_len);
    
    if (test_pid < 0) {
        printf("【错误】: 创建文件测试进程失败\n");
        return;
    }
    
    printf("【测试结果】: 创建文件测试进程成功，PID: %d\n", test_pid);
    
    // 等待测试进程完成
    printf("\n----- 等待文件测试进程完成 -----\n");
    int status;
    int waited_pid = wait_proc(&status);
    if (waited_pid == test_pid) {
        printf("【测试结果】: 文件测试进程(PID: %d)完成，状态码: %d\n", 
               test_pid, status);
    } else {
        printf("【错误】: 等待文件测试进程时出错，等待到PID: %d，期望PID: %d\n", 
               waited_pid, test_pid);
    }
    
    printf("===== 测试结束: 文件系统调用测试 =====\n");
}
void test_syscall_performance(void) {
    printf("\n===== 测试开始: 系统调用性能测试 =====\n");
    
    printf("\n----- 创建性能测试进程 -----\n");
    int test_pid = create_user_proc(syscall_performance_bin, syscall_performance_bin_len);
    
    if (test_pid < 0) {
        printf("【错误】: 创建性能测试进程失败\n");
        return;
    }
    
    printf("【测试结果】: 创建性能测试进程成功，PID: %d\n", test_pid);
    
    // 等待测试进程完成
    printf("\n----- 等待性能测试进程完成 -----\n");
    int status;
    int waited_pid = wait_proc(&status);
    
    if (waited_pid == test_pid) {
        printf("【测试结果】: 性能测试进程(PID: %d)完成，状态码: %d\n", 
               test_pid, status);
    } else {
        printf("【错误】: 等待性能测试进程时出错，等待到PID: %d，期望PID: %d\n", 
               waited_pid, test_pid);
    }
    
    printf("===== 测试结束: 系统调用性能测试 =====\n");
}