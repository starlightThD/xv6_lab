#include "../kernel/syscall.h"
#include "user_lib.h"

int main() {
    char message[256];
    
    sys_printstr("===== 文件创建和写入测试 =====\n");
    
    // 创建持久化测试文件
    sys_printstr("[测试] 创建持久化文件 /persistent_file.txt\n");
    int fd = sys_open("/persistent_file.txt", 0x202, 0);  // O_RDWR | O_CREATE
    if (fd < 0) {
        sys_printstr("[错误] 无法创建文件\n");
        sys_exit(1);
        return 1;
    }
    
    usr_build_string_with_int(message, "[测试] 文件创建成功，fd=", fd, "\n");
    sys_printstr(message);
    
    // 写入测试数据
    const char *test_content = 
        "=== 持久化测试文件 ===\n"
        "这个文件由第一个测试程序创建\n"
        "包含多行内容用于验证持久化\n"
        "创建时间：系统启动后\n"
        "文件大小：约150字节\n"
        "=== 内容结束 ===\n";
    
    int content_len = usr_strlen(test_content);
    int write_ret = sys_write(fd, test_content, content_len);
    
    if (write_ret == content_len) {
        usr_build_string_with_int(message, "[测试] ✅ 成功写入 ", write_ret, " 字节\n");
        sys_printstr(message);
    } else {
        usr_build_string_with_int(message, "[错误] 写入失败，期望 ", content_len, " 字节，实际写入 ");
        sys_printstr(message);
        usr_build_string_with_int(message, "", write_ret, " 字节\n");
        sys_printstr(message);
    }
    
    // 关闭文件
    int close_ret = sys_close(fd);
    if (close_ret == 0) {
        sys_printstr("[测试] ✅ 文件关闭成功\n");
    } else {
        sys_printstr("[错误] 文件关闭失败\n");
    }
    
    // 验证文件确实存在
    sys_printstr("[验证] 重新打开文件验证写入成功\n");
    fd = sys_open("/persistent_file.txt", 0x000, 0);  // O_RDONLY
    if (fd >= 0) {
        char verify_buf[64];
        int read_ret = sys_read(fd, verify_buf, sizeof(verify_buf) - 1);
        if (read_ret > 0) {
            verify_buf[read_ret] = '\0';
            sys_printstr("[验证] ✅ 文件内容预览（前63字符）:\n");
            sys_printstr(verify_buf);
            sys_printstr("...\n");
        }
        sys_close(fd);
    } else {
        sys_printstr("[错误] 无法重新打开文件进行验证\n");
    }
    
    sys_printstr("\n[重要] 文件已创建但未删除，将保持持久化状态\n");
    sys_printstr("请运行第二个测试程序来读取和删除此文件\n");
    
    sys_printstr("\n===== 文件创建测试完成 =====\n");
    sys_exit(0);
    return 0;
}