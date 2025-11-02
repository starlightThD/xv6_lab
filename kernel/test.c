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

    // 记录中断前的时间
    uint64 start_time = get_time();
    int interrupt_count = 0;
	int last_count = interrupt_count;
    // 设置测试标志
    interrupt_test_flag = &interrupt_count;

    // 等待几次中断
    while (interrupt_count < 5) {
        if(last_count != interrupt_count) {
			last_count = interrupt_count;
			printf("Received interrupt %d\n", interrupt_count);
		}
        // 简单延时
        for (volatile int i = 0; i < 1000000; i++);
    }

    // 测试结束，清除标志
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
    printf("✓ 非法指令异常处理成功\n\n");
    
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
        printf("读取的值: %lu\n", value);  // 不太可能执行到这里，除非故障被处理
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
    
    printf("===== 异常处理测试完成 =====\n\n");
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