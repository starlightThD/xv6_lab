/* 自动生成的聚合头文件 */
#include "file_read.h"
#include "file_write.h"
#include "fork_user_test.h"
#include "kill_user_test.h"
#include "simple_user_task.h"
#include "syscall_performance.h"

// 用户测试程序结构
struct UserTestEntry {
	const char* name;		  // 程序名
	const void* binary;		// 程序二进制数据
	const int size;			// 程序大小
};

// 自动生成的用户程序表
static const struct UserTestEntry user_test_table[] = {
	{"file_read", file_read_bin, file_read_bin_len},
	{"file_write", file_write_bin, file_write_bin_len},
	{"fork_user_test", fork_user_test_bin, fork_user_test_bin_len},
	{"kill_user_test", kill_user_test_bin, kill_user_test_bin_len},
	{"simple_user_task", simple_user_task_bin, simple_user_task_bin_len},
	{"syscall_performance", syscall_performance_bin, syscall_performance_bin_len},
};

#define USER_TEST_COUNT (sizeof(user_test_table)/sizeof(user_test_table[0]))
