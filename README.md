## 操作系统实践课
### 阶段性任务
时间： 2025-9-13
进度： 实验一完成
## 项目概述

这是一个最小化的 RISC-V 操作系统内核，实现了基本的系统启动、内存管理和串口输出功能。该项目旨在展示操作系统内核的基本原理和 RISC-V 架构的底层编程。

## 系统架构

### 内存布局
- **入口地址**: `0x80000000`
- **代码段**: 存放内核代码，4KB 对齐
- **只读数据段**: 存放常量字符串
- **数据段**: 存放已初始化的全局变量
- **BSS段**: 存放未初始化的全局变量，启动时自动清零
- **栈空间**: 4KB

### 启动流程
1. **汇编入口** ([`kernel/entry.S`](kernel/entry.S))
   - 初始化 UART 输出调试信息 ('S', 'P')
   - 设置栈指针到 4KB 栈空间
   - 清零 BSS 段内存
   - 跳转到 C 语言入口函数

2. **C 语言入口** ([`kernel/start.c`](kernel/start.c))
   - 清屏并输出系统横幅
   - 验证 BSS 段清零功能
   - 验证初始化变量正确性
   - 进入主循环

## 核心组件

### 1. 串口驱动 ([`kernel/uart.c`](kernel/uart.c))
实现了基本的 UART 串口通信功能：
- [`uart_putc`](kernel/uart.c): 输出单个字符
- [`uart_puts`](kernel/uart.c): 输出字符串
- 支持标准 16550 UART 寄存器操作

### 2. 内存管理
- 链接脚本 ([`kernel/kernel.ld`](kernel/kernel.ld)) 定义内存布局
- 自动 BSS 段清零，确保未初始化变量为 0
- 分离代码段、数据段和 BSS 段

### 3. 启动引导
- 汇编启动代码处理最底层初始化
- C 语言代码处理高级别系统初始化
- 完整的系统状态验证

## 文件结构

```
riscv-os/
├── Makefile           # 构建脚本和调试配置
├── README.md          # 项目文档
├── test.c             # 测试文件
└── kernel/            # 内核源代码
    ├── entry.S        # 汇编入口点
    ├── start.c        # C语言内核入口
    ├── uart.c         # 串口驱动
    ├── kernel.ld      # 链接脚本
    ├── kernel         # 编译后的内核二进制文件
    ├── kernel.asm     # 反汇编文件
    └── kernel.sym     # 符号表文件
```

## 构建和运行

### 环境要求
- Ubuntu 24.04.2 LTS (或兼容的 Linux 发行版)
- RISC-V 工具链 (riscv64-unknown-elf-* 或 riscv64-linux-gnu-*)
- QEMU RISC-V 模拟器
- GDB 调试器 (支持 RISC-V)

### 构建内核
```bash
make
```

### 运行系统
```bash
make qemu
```

### 调试功能
```bash
# 启动调试模式
make qemu-gdb

# 在另一个终端连接调试器
make debug

# 检查调试环境
make debug-check

# 查看调试帮助
make gdb-help
```

### 验证内存布局
```bash
make check
```

## 系统输出

启动成功后，系统会显示：

```
===============================================
        RISC-V Operating System v1.0         
===============================================

Hello, RISC-V Kernel!
Kernel startup complete!
Testing BSS zero initialization:
  [OK] BSS variables correctly zeroed
  [OK] Initialized variables working

System ready. Entering main loop...
Press Ctrl+A then X to exit QEMU
```
## 调试信息

### 关键符号
- `_entry`: 系统入口点 (0x80000000)
- [`start`](kernel/start.c): C 语言入口函数
- `_bss_start`: BSS 段起始地址
- `_bss_end`: BSS 段结束地址
- [`uart_putc`](kernel/uart.c): 字符输出函数
- [`uart_puts`](kernel/uart.c): 字符串输出函数

### 内存映射
- **0x80000000**: 内核代码入口
- **0x10000000**: UART 控制器基地址
- **栈指针**: stack0 + 4KB