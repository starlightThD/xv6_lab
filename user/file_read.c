#include "../kernel/syscall.h"
#include "user_lib.h"

int main() {
    char message[256];
    char read_buffer[512];
    
    sys_printstr("===== 文件读取和删除测试 =====\n");
    
    // 尝试读取第一个程序创建的文件
    sys_printstr("[测试] 尝试读取持久化文件 /persistent_file.txt\n");
    int fd = sys_open("/persistent_file.txt", 0x000, 0);  // O_RDONLY
    
    if (fd < 0) {
        sys_printstr("[结果] ❌ 文件不存在或无法打开\n");
        sys_exit(1);
        return 1;
    }
    
    usr_build_string_with_int(message, "[测试] ✅ 文件打开成功，fd=", fd, "\n");
    sys_printstr(message);
    
    // 清空缓冲区
    for (int i = 0; i < sizeof(read_buffer); i++) {
        read_buffer[i] = 0;
    }
    
    // 读取文件内容
    sys_printstr("[测试] 读取文件完整内容\n");
    int read_ret = sys_read(fd, read_buffer, sizeof(read_buffer) - 1);
    
    if (read_ret > 0) {
        read_buffer[read_ret] = '\0';  // 确保字符串结尾
        
        usr_build_string_with_int(message, "[测试] ✅ 成功读取 ", read_ret, " 字节\n");
        sys_printstr(message);
        
        sys_printstr("\n[内容] 文件完整内容如下：\n");
        sys_printstr("==========================================\n");
        sys_printstr(read_buffer);
        sys_printstr("==========================================\n");
        
    } else if (read_ret == 0) {
        sys_printstr("[结果] ⚠️  文件为空\n");
    } else {
        sys_printstr("[错误] 读取文件失败\n");
    }
    
    // 关闭文件
    int close_ret = sys_close(fd);
    if (close_ret == 0) {
        sys_printstr("[测试] ✅ 文件关闭成功\n");
    } else {
        sys_printstr("[错误] 文件关闭失败\n");
    }
    
    // 删除文件
    sys_printstr("\n[清理] 准备删除文件\n");
    int unlink_ret = sys_unlink("/persistent_file.txt");
    
    if (unlink_ret == 0) {
        sys_printstr("[清理] ✅ 文件删除成功\n");
    } else {
        sys_printstr("[清理] ❌ 文件删除失败\n");
        usr_build_string_with_int(message, "删除返回值: ", unlink_ret, "\n");
        sys_printstr(message);
    }
    
    // 验证文件已被删除
    sys_printstr("[验证] 确认文件是否已删除\n");
    fd = sys_open("/persistent_file.txt", 0x000, 0);  // O_RDONLY
    
    if (fd < 0) {
        sys_printstr("[验证] ✅ 文件确已删除，无法再次打开\n");
    } else {
        sys_printstr("[验证] ❌ 警告：文件删除可能不完整，仍可打开\n");
        sys_close(fd);
    }
    
    sys_printstr("\n===== 文件读取和删除测试完成 =====\n");
    sys_exit(0);
    return 0;
}