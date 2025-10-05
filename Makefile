K=kernel

# 检测工具链
ifndef TOOLPREFIX
TOOLPREFIX := $(shell if riscv64-unknown-elf-objdump -i 2>&1 | grep 'elf64-big' >/dev/null 2>&1; \
	then echo 'riscv64-unknown-elf-'; \
	elif riscv64-linux-gnu-objdump -i 2>&1 | grep 'elf64-big' >/dev/null 2>&1; \
	then echo 'riscv64-linux-gnu-'; \
	else echo "*** Error: Couldn't find a riscv64 version of GCC/binutils." 1>&2; exit 1; fi)
endif

CC = $(TOOLPREFIX)gcc
LD = $(TOOLPREFIX)ld
OBJDUMP = $(TOOLPREFIX)objdump
NM = $(TOOLPREFIX)nm

# 检测可用的调试器
GDB := $(shell if which $(TOOLPREFIX)gdb >/dev/null 2>&1; \
	then echo '$(TOOLPREFIX)gdb'; \
	elif which gdb-multiarch >/dev/null 2>&1; \
	then echo 'gdb-multiarch'; \
	elif which riscv64-linux-gnu-gdb >/dev/null 2>&1; \
	then echo 'riscv64-linux-gnu-gdb'; \
	else echo "*** Error: No suitable RISC-V GDB found." 1>&2; exit 1; fi)

CFLAGS = -Wall -Werror -O0 -fno-omit-frame-pointer -g3
CFLAGS += -mcmodel=medany
CFLAGS += -ffreestanding -fno-common -nostdlib -mno-relax
CFLAGS += -I.
CFLAGS += $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)

LDFLAGS = -z max-page-size=4096 -g

# QEMU 配置
QEMU = qemu-system-riscv64
QEMUOPTS = -machine virt -bios /usr/riscv64-linux-gnu/opensbi/fw_jump.elf -kernel $K/kernel -m 128M -smp 1 -nographic

# 最小化对象文件
MINIMAL_OBJS = \
  $K/entry.o \
  $K/start.o \
  $K/uart.o \
  $K/printf.o \
  $K/mem.o \
  $K/vm.o \
  $K/pm.o \
  $K/sbi.o \
  $K/timer.o \
  $K/trap.o \
  $K/plic.o \
  $K/kernelvec.o

$K/kernel: $(MINIMAL_OBJS) $K/kernel.ld
	$(LD) $(LDFLAGS) -T $K/kernel.ld -o $K/kernel $(MINIMAL_OBJS)
	$(OBJDUMP) -S $K/kernel > $K/kernel.asm
	$(OBJDUMP) -t $K/kernel | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $K/kernel.sym

$K/entry.o: $K/entry.S
	$(CC) $(CFLAGS) -c $K/entry.S -o $K/entry.o

$K/start.o: $K/start.c
	$(CC) $(CFLAGS) -c $K/start.c -o $K/start.o

$K/uart.o: $K/uart.c
	$(CC) $(CFLAGS) -c $K/uart.c -o $K/uart.o

$K/printf.o: $K/printf.c
	$(CC) $(CFLAGS) -c $K/printf.c -o $K/printf.o

$K/mem.o: $K/mem.c
	$(CC) $(CFLAGS) -c $K/mem.c -o $K/mem.o

$K/vm.o: $K/vm.c
	$(CC) $(CFLAGS) -c $K/vm.c -o $K/vm.o

$K/pm.o: $K/pm.c
	$(CC) $(CFLAGS) -c $K/pm.c -o $K/pm.o

$K/sbi.o: $K/sbi.c
	$(CC) $(CFLAGS) -c $K/sbi.c -o $K/sbi.o

$K/timer.o: $K/timer.c
	$(CC) $(CFLAGS) -c $K/timer.c -o $K/timer.o

$K/trap.o: $K/trap.c
	$(CC) $(CFLAGS) -c $K/trap.c -o $K/trap.o

$K/plic.o: $K/plic.c
	$(CC) $(CFLAGS) -c $K/plic.c -o $K/plic.o

$K/kernelvec.o: $K/kernelvec.S
	$(CC) $(CFLAGS) -c $K/kernelvec.S -o $K/kernelvec.o
# 验证内存布局
check: $K/kernel
	@echo "=== 检查段信息 ==="
	$(OBJDUMP) -h $K/kernel
	@echo "=== 检查符号表 ==="
	$(NM) $K/kernel | grep -E "(start|end|text|bss|entry)"
	@echo "=== 检查入口点 ==="
	$(OBJDUMP) -f $K/kernel

# 运行 QEMU
qemu: $K/kernel
	@echo "=== 启动 QEMU ==="
	$(QEMU) $(QEMUOPTS)

# 调试模式运行 QEMU (等待 GDB 连接)
qemu-gdb: $K/kernel
	@echo "=== 启动 QEMU 调试模式 ==="
	@echo "使用调试器: $(GDB)"
	@echo "在另一个终端运行: make debug"
	@echo "或手动运行: $(GDB) kernel/kernel"
	@echo "然后在 GDB 中执行:"
	@echo "  target remote localhost:1234"
	@echo "  set architecture riscv:rv64"
	@echo "  hb *0x80000000"
	$(QEMU) $(QEMUOPTS) -S -gdb tcp::1234

# 自动启动GDB并连接
debug: $K/kernel
	@echo "=== 连接到QEMU调试会话 ==="
	@echo "使用调试器: $(GDB)"
	@echo "确保已经运行了 'make qemu-gdb'"
	$(GDB) $K/kernel \
		-ex "target remote localhost:1234" \
		-ex "set architecture riscv:rv64" \
		-ex "set confirm off" \
		-ex "hb *0x80000000" \
		-ex "hb start" \
		-ex "layout split" \
		-ex "continue"

# 简单调试模式（手动操作）
debug-simple: $K/kernel
	@echo "=== 启动简单调试会话 ==="
	@echo "使用调试器: $(GDB)"
	@echo "请手动执行以下命令:"
	@echo "  target remote localhost:1234"
	@echo "  set architecture riscv:rv64"
	@echo "  hb *0x80000000"
	@echo "  c"
	$(GDB) $K/kernel

# 创建GDB配置文件
gdb-init: $K/kernel
	@echo "创建 .gdbinit 文件..."
	@echo "set confirm off" > .gdbinit
	@echo "target remote localhost:1234" >> .gdbinit
	@echo "set architecture riscv:rv64" >> .gdbinit
	@echo "set riscv use-compressed-breakpoints on" >> .gdbinit
	@echo "# 硬件断点" >> .gdbinit
	@echo "hb *0x80000000" >> .gdbinit
	@echo "hb start" >> .gdbinit
	@echo "hb uart_putc" >> .gdbinit
	@echo "layout split" >> .gdbinit
	@echo "已创建 .gdbinit 文件"
	@echo "现在可以运行: $(GDB) kernel/kernel"

# 调试帮助信息
gdb-help:
	@echo "=== GDB 调试帮助 ==="
	@echo "检测到的调试器: $(GDB)"
	@echo ""
	@echo "使用方法:"
	@echo "  1. 启动调试模式: make qemu-gdb"
	@echo "  2. 在新终端连接GDB: make debug"
	@echo "  3. 或者手动调试: make debug-simple"
	@echo "  4. 创建GDB配置: make gdb-init"
	@echo ""
	@echo "常用GDB命令:"
	@echo "  target remote localhost:1234  - 连接到QEMU"
	@echo "  set architecture riscv:rv64	- 设置架构"
	@echo "  hb *0x80000000				 - 在入口点设置硬件断点"
	@echo "  b start						- 在start函数设置断点"
	@echo "  c							  - 继续执行"
	@echo "  si							 - 单步执行指令"
	@echo "  ni							 - 下一条指令"
	@echo "  info registers				 - 查看寄存器"
	@echo "  x/10i \$$pc					- 查看当前指令"
	@echo "  x/10x \$$sp					- 查看栈内容"
	@echo "  quit						   - 退出GDB"

# 检查调试环境
debug-check:
	@echo "=== 调试环境检查 ==="
	@echo "TOOLPREFIX: $(TOOLPREFIX)"
	@echo "检测到的GDB: $(GDB)"
	@echo ""
	@echo "工具链状态:"
	@which $(CC) && echo "  编译器: ✓" || echo "  编译器: ✗"
	@which $(GDB) && echo "  调试器: ✓" || echo "  调试器: ✗"
	@which $(QEMU) && echo "  QEMU: ✓" || echo "  QEMU: ✗"
	@echo ""
	@echo "GDB架构支持测试:"
	@$(GDB) -batch -ex "set architecture riscv:rv64" -ex "quit" 2>/dev/null && echo "  RISC-V支持: ✓" || echo "  RISC-V支持: ✗"

# 清理调试文件
clean-debug:
	rm -f .gdbinit

# 扩展clean目标
clean: clean-debug
	rm -f $K/*.o $K/kernel $K/*.asm $K/*.sym

.PHONY: check clean qemu qemu-gdb debug debug-simple gdb-help gdb-init debug-check clean-debug