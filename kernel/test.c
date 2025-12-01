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
    }

    // 清除测试标志
    interrupt_test_flag = 0;

    uint64 end_time = get_time();
    printf("Timer test completed: %d interrupts in %lu cycles\n",
           interrupt_count, end_time - start_time);
}

// 修改测试异常处理函数
// 在test_exception函数中添加虚拟内存测试部分

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

    // ===== 新增：虚拟内存系统测试 =====
    printf("===== 虚拟内存系统测试 =====\n\n");
    
    // 4. 测试按需分配功能
    printf("4. 测试按需页面分配...\n");
    for (uint64 test_addr = 0xB0000000; test_addr < 0xB0010000; test_addr += 0x1000) {
        if (check_is_mapped(test_addr) == 0) {
            printf("测试地址 0x%lx 的按需分配\n", test_addr);
            
            // 写入测试
            volatile uint64 *ptr = (uint64*)test_addr;
            *ptr = 0xDEADBEEF;
            printf("  写入成功: 0x%lx\n", *ptr);
            
            // 验证页面已分配
            if (check_is_mapped(test_addr)) {
                printf("  ✓ 页面成功分配并映射\n");
            } else {
                printf("  ✗ 页面分配失败\n");
            }
            break;
        }
    }
    printf("\n");
    
    // 5. 测试页面权限更新
    printf("5. 测试页面权限更新...\n");
    uint64 perm_test_addr = 0xC0000000;
    if (check_is_mapped(perm_test_addr) == 0) {
        printf("为地址 0x%lx 分配页面\n", perm_test_addr);
        
        // 先进行读访问，触发页面分配
        volatile uint64 *ptr = (uint64*)perm_test_addr;
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
    if (check_is_mapped(cross_page_addr) == 0 && check_is_mapped(cross_page_addr + 4) == 0) {
        printf("测试跨页面访问，起始地址: 0x%lx\n", cross_page_addr);
        
        // 写入跨页面的数据
        volatile uint32 *ptr = (uint32*)cross_page_addr;
        *ptr = 0xABCDEF01;
        printf("  跨页面写入成功: 0x%x\n", *ptr);
        
        // 验证两个页面都被分配
        if (check_is_mapped(cross_page_addr) && check_is_mapped(cross_page_addr + 4)) {
            printf("  ✓ 跨页面访问成功，相关页面都已分配\n");
        } else {
            printf("  ✗ 跨页面访问异常\n");
        }
    } else {
        printf("  跳过：页面已映射\n");
    }
    printf("\n");
    
    // 7. 测试连续页面分配
    printf("7. 测试连续页面分配...\n");
    uint64 base_addr = 0xE0000000;
    int allocated_pages = 0;
    
    for (int i = 0; i < 5; i++) {
        uint64 addr = base_addr + (i * 0x1000);
        if (check_is_mapped(addr) == 0) {
            printf("  分配页面 %d, 地址: 0x%lx\n", i, addr);
            
            volatile uint64 *ptr = (uint64*)addr;
            *ptr = 0x1000 + i; // 写入页面索引
            
            if (check_is_mapped(addr)) {
                allocated_pages++;
                printf("    写入值: %lu, 读取值: %lu\n", 0x1000UL + i, *ptr);
            }
        } else {
            printf("  页面 %d (0x%lx) 已映射，跳过\n", i, addr);
        }
    }
    printf("  ✓ 成功分配 %d 个连续页面\n", allocated_pages);
    printf("\n");
    
    // 8. 测试内存访问模式
    printf("8. 测试不同内存访问模式...\n");
    uint64 pattern_addr = 0xF0000000;
    if (check_is_mapped(pattern_addr) == 0) {
        volatile char *byte_ptr = (char*)pattern_addr;
        volatile uint16 *word_ptr = (uint16*)pattern_addr;
        volatile uint32 *dword_ptr = (uint32*)pattern_addr;
        volatile uint64 *qword_ptr = (uint64*)pattern_addr;
        
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
    } else {
        printf("  跳过：页面已映射\n");
    }
    printf("\n");
    
    // 9. 测试页表遍历
    printf("9. 测试页表结构验证...\n");
    
    // 检查几个已知映射的页面
    uint64 test_addrs[] = {0x80000000, 0x10000000, 0xB0000000, 0};
    for (int i = 0; test_addrs[i] != 0; i++) {
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
    printf("11. 测试加载地址未对齐异常...\n");
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
    printf("12. 测试断点异常...\n");
    asm volatile (
        "nop\n\t"      // 确保ebreak前有有效指令
        "ebreak\n\t"   // 断点指令
        "nop\n\t"      // 确保ebreak后有有效指令
    );
    printf("✓ 断点异常处理成功\n\n");
    
    // 7. 测试环境调用异常
    printf("13. 测试环境调用异常...\n");
    asm volatile ("ecall");  // 从S模式生成环境调用
    printf("✓ 环境调用异常处理成功\n\n");
    
    printf("===== 部分异常处理测试完成 =====\n\n");
    printf("===== 测试不可恢复的除零异常 ====\n");
    unsigned int a = 1;
    unsigned int b = 0;
    unsigned int result = a/b;
    // 根据中科大的手册，RV32I并不会因为除零而进入trap
    printf("这行不应该被打印，如果打印了，那么result = %d\n", result);
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
        sleep(&proc_produced,NULL); // 等待生产者
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

void test_filesystem_integrity(void) {
    printf("Filesystem stress test...\n");

    const char *filename = "stressfile";
    struct inode *ip = namei((char *)filename);
    if (ip == NULL) {
        debug("文件不存在，创建新文件: %s\n", filename);
        ip = create((char *)filename, T_FILE, 0, 0);
        assert(ip != NULL);
        close(open(ip, 1, 1));
    }
    struct file *f;
    int bytes;

    // 1. 多轮写入和读取
    for (int i = 0; i < 5; i++) {
        char buf[32];
        snprintf(buf, sizeof(buf), "round %d", i);

        ip = namei((char *)filename);
        assert(ip != NULL);
        f = open(ip, 1, 1);
        assert(f != NULL);
        f->off = 0;
        bytes = write(f, (uint64)buf, strlen(buf));
        assert(bytes == strlen(buf));
        close(f);

        ip = namei((char *)filename);
        assert(ip != NULL);
        f = open(ip, 1, 0);
        assert(f != NULL);
        char readbuf[32];
        f->off = 0;
        bytes = read(f, (uint64)readbuf, sizeof(readbuf) - 1);
        readbuf[bytes] = '\0';
        printf("Round %d: Read \"%s\"\n", i, readbuf);
        assert(strcmp(buf, readbuf) == 0);
        close(f);
    }

    // 2. 跨块写入与读取
    ip = namei((char *)filename);
    assert(ip != NULL);
    f = open(ip, 1, 1);
    assert(f != NULL);
    f->off = 0;
    char bigbuf[1024];
    for (int i = 0; i < sizeof(bigbuf) - 1; i++)
        bigbuf[i] = 'A' + (i % 26);
    bigbuf[1023] = '\0';
    bytes = write(f, (uint64)bigbuf, 1024);
    assert(bytes == 1024);
    close(f);

    ip = namei((char *)filename);
    assert(ip != NULL);
    f = open(ip, 1, 0);
    assert(f != NULL);
    char bigread[1024];
    f->off = 0;
    bytes = read(f, (uint64)bigread, 1024);
    bigread[1023] = '\0';
    printf("Cross-block read : \"%s\"\n", bigread);
    assert(bytes == 1024);
    close(f);

    // 3. 多文件操作
    for (int i = 0; i < 3; i++) {
        char fname[16];
        snprintf(fname, sizeof(fname), "file%d", i);
        ip = create(fname, T_FILE, 0, 0);
        assert(ip != NULL);
        f = open(ip, 1, 1);
        assert(f != NULL);
        char msg[32];
        snprintf(msg, sizeof(msg), "hello_%d", i);
        bytes = write(f, (uint64)msg, strlen(msg));
        assert(bytes == strlen(msg));
        close(f);

        ip = namei(fname);
        assert(ip != NULL);
        f = open(ip, 1, 0);
        assert(f != NULL);
        char rbuf[32];
        bytes = read(f, (uint64)rbuf, sizeof(rbuf) - 1);
        rbuf[bytes] = '\0';
        printf("Multi-file %s: \"%s\"\n", fname, rbuf);
        assert(strcmp(msg, rbuf) == 0);
        close(f);

        int ret = unlink(fname);
        assert(ret == 0);
    }

    // 4. 错误处理
    ip = namei("no_such_file");
    assert(ip == NULL);

    // 5. 边界测试
    ip = namei((char *)filename);
    assert(ip != NULL);
    f = open(ip, 1, 1);
    assert(f != NULL);
    bytes = write(f, (uint64)"", 0);
    assert(bytes == 0);
    close(f);

    ip = namei((char *)filename);
    assert(ip != NULL);
	itrunc(ip);
    f = open(ip, 1, 0);
    assert(f != NULL);
    char emptybuf[4];
    bytes = read(f, (uint64)emptybuf, sizeof(emptybuf) - 1);
    emptybuf[bytes] = '\0';
    printf("Empty read: \"%s\"\n", emptybuf);
    assert(bytes == 0);
	ip->size = 0;
    close(f);

    // 6. 文件删除与重建
    int unlink_ret = unlink((char *)filename);
    debug("文件删除结果: %d\n", unlink_ret);
    assert(unlink_ret == 0);

    ip = create((char *)filename, T_FILE, 0, 0);
    debug("重建文件，create返回ip=%p\n", ip);
    assert(ip != NULL);
    f = open(ip, 1, 0);
    debug("重建文件后，open返回f=%p\n", f);
    assert(f != NULL);
    char readbuf[32];
    bytes = read(f, (uint64)readbuf, sizeof(readbuf) - 1);
    readbuf[bytes] = '\0';
    debug("重建文件后读取，读取字节数=%d，内容=\"%s\"\n", bytes, readbuf);
    printf("After recreate: Read \"%s\"\n", readbuf);
    assert(bytes == 0); // 新文件应为空
    close(f);

    printf("Filesystem stress test passed!\n");
}

// 多进程并发写入和读取测试
static const char *mp_filename = "mpfile";
static int mp_proc_count = 5;
void mp_append_read_write_task() {
    struct inode *ip = namei((char *)mp_filename);
    assert(ip != NULL);

    // 先读全部内容
    struct file *f = open(ip, 1, 0);
    assert(f != NULL);
    char readbuf[128];
    int rbytes = read(f, (uint64)readbuf, sizeof(readbuf) - 1);
    readbuf[rbytes] = '\0';
    printf("[MP-APPEND] proc %d read: \"%s\" (%d bytes)\n", myproc()->pid, readbuf, rbytes);
    close(f);

    // 后追加写入（不重置 f->off）
	ip = namei((char *)mp_filename);
    f = open(ip, 1, 1);
    assert(f != NULL);
	f->off = ip->size; // 关键：追加到文件末尾
    char writebuf[32];
    snprintf(writebuf, sizeof(writebuf), "proc_%d\t", myproc()->pid);
    // 直接写入，f->off自动追加
    int wbytes = write(f, (uint64)writebuf, strlen(writebuf));
    printf("[MP-APPEND] proc %d wrote: \"%s\" (%d bytes)\n", myproc()->pid, writebuf, wbytes);
    close(f);

    exit_proc(0);
}

void test_multi_process_filesystem(void) {
    printf("===== 多进程文件系统追加写入测试 =====\n");

    // 创建测试文件
    struct inode *ip = namei((char *)mp_filename);
    if (ip == NULL) {
        ip = create((char *)mp_filename, T_FILE, 0, 0);
        assert(ip != NULL);
        close(open(ip, 1, 1));
    }

    // 并发读写
    for (int i = 0; i < mp_proc_count; i++) {
        int pid = create_kernel_proc(mp_append_read_write_task);
        assert(pid > 0);
    }
    for (int i = 0; i < mp_proc_count; i++) {
        wait_proc(NULL);
    }

    // 主进程读取全部内容
    ip = namei((char *)mp_filename);
    assert(ip != NULL);
    struct file *f = open(ip, 1, 0);
    assert(f != NULL);
    char allbuf[256];
    int bytes = read(f, (uint64)allbuf, sizeof(allbuf) - 1);
    allbuf[bytes] = '\0';
    printf("Final file content:\n%s", allbuf);
    close(f);

    printf("===== 多进程文件系统追加写入测试完成 =====\n");
}
void test_filesystem_performance(void) {
    printf("===== 文件系统性能测试 =====\n");
    uint64 start_time = get_time();

    // 小文件测试（16个文件，每个8KB，2块）
	for (int i = 0; i < 8; i++) {
		char filename[32];
		snprintf(filename, sizeof(filename), "small_%d", i);
		struct inode *ip = create(filename, T_FILE, 0, 0);
		if (ip == NULL) {
			warning("create failed for %s\n", filename);
			continue;
		}
		struct file *f = open(ip, 1, 1);
		if (f == NULL) {
			warning("open failed for %s\n", filename);
			continue;
		}
		char buf[4096];
		memset(buf, 'B' + i, sizeof(buf));
		for (int j = 0; j < 2; j++) {
			int bytes = write(f, (uint64)buf, sizeof(buf));
			if (bytes != sizeof(buf)) {
				warning("write failed for %s, bytes=%d\n", filename, bytes);
				break;
			}
		}
		close(f);
		int ret = unlink(filename);
		if (ret != 0) {
			warning("unlink failed for %s, ret=%d\n", filename, ret);
		}
	}
    uint64 small_files_time = get_time() - start_time;

    // 大文件测试（1个文件，2块，每块4096字节）
    start_time = get_time();
    struct inode *ip = create("large_file", T_FILE, 0, 0);
    assert(ip != NULL);
    struct file *f = open(ip, 1, 1);
    assert(f != NULL);
    char large_buffer[4096];
    memset(large_buffer, 'A', sizeof(large_buffer));
    for (int i = 0; i < 8; i++) {
        int bytes = write(f, (uint64)large_buffer, sizeof(large_buffer));
        assert(bytes == sizeof(large_buffer));
    }
	struct inode *ip_check = namei("large_file");
	if (ip_check == NULL) {
		warning("large_file not found after write\n");
	} else {
		debug("large_file inode: %p, size: %d\n", ip_check, ip_check->size);
	}
    close(f);
	ip_check = namei("large_file");
	if (ip_check == NULL) {
		warning("large_file not found before unlink\n");
	}
	int ret = unlink("large_file");
	if (ret != 0) {
		warning("unlink failed for %s, ret=%d\n", "large_file", ret);
	}
    uint64 large_file_time = get_time() - start_time;

    printf("小文件 (16 x 8KB): %lu cycles\n", small_files_time);
    printf("大文件 (1 x 8KB): %lu cycles\n", large_file_time);


    printf("===== 文件系统性能测试完成 =====\n");
}