K=kernel
USRDIR = user
DISK = mkfs/fs.img
	
# 检测可用的调试器
ifndef TOOLPREFIX
TOOLPREFIX := $(shell if riscv64-unknown-elf-objdump -i 2>&1 | grep 'elf64-big' >/dev/null 2>&1; \
	then echo 'riscv64-unknown-elf-'; \
	elif riscv64-linux-gnu-objdump -i 2>&1 | grep 'elf64-big' >/dev/null 2>&1; \
	then echo 'riscv64-linux-gnu-'; \
	else echo "*** Error: Couldn't find a riscv64 version of GCC/binutils." 1>&2; exit 1; fi)
endif

GDB := $(shell if which $(TOOLPREFIX)gdb >/dev/null 2>&1; \
	then echo '$(TOOLPREFIX)gdb'; \
	elif which gdb-multiarch >/dev/null 2>&1; \
	then echo 'gdb-multiarch'; \
	elif which riscv64-linux-gnu-gdb >/dev/null 2>&1; \
	then echo 'riscv64-linux-gnu-gdb'; \
	else echo "*** Error: No suitable RISC-V GDB found." 1>&2; exit 1; fi)

# QEMU 配置
QEMU = qemu-system-riscv64
QEMUOPTS = -machine virt -bios /usr/riscv64-linux-gnu/opensbi/fw_jump.elf -kernel $K/build/kernel -m 128M -smp 1 -nographic \
-global virtio-mmio.force-legacy=false \
-drive file=$(DISK),if=none,format=raw,id=x0 \
-device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0

# 文件系统
fs:
	rm -rf ./mkfs/fs.img && ./mkfs/mkfs ./mkfs/fs.img

# 默认目标
all: userprog kernel

# 构建用户程序
userprog:
	$(MAKE) -C $(USRDIR)

# 构建内核
kernel:
	$(MAKE) -C $(K) TOOLPREFIX=$(TOOLPREFIX)

# 验证内存布局
check: kernel
	$(MAKE) -C $(K) check TOOLPREFIX=$(TOOLPREFIX)

# 运行 QEMU
qemu: userprog kernel
	@echo "=== 启动 QEMU ==="
	$(QEMU) $(QEMUOPTS)

# 调试模式运行 QEMU (等待 GDB 连接)
qemu-gdb: userprog kernel
	@echo "=== 启动 QEMU 调试模式 ==="
	@echo "使用调试器: $(GDB)"
	@echo "在另一个终端运行: make debug"
	@echo "或手动运行: $(GDB) kernel/build/kernel"
	@echo "然后在 GDB 中执行:"
	@echo "  target remote localhost:1234"
	@echo "  set architecture riscv:rv64"
	@echo "  hb *0x80000000"
	$(QEMU) $(QEMUOPTS) -S -gdb tcp::1234

# 自动启动GDB并连接
debug: kernel
	@echo "=== 连接到QEMU调试会话 ==="
	@echo "使用调试器: $(GDB)"
	@echo "确保已经运行了 'make qemu-gdb'"
	$(GDB) $K/build/kernel \
		-ex "target remote localhost:1234" \
		-ex "set architecture riscv:rv64" \
		-ex "set confirm off" \
		-ex "hb *0x80000000" \
		-ex "hb start" \
		-ex "layout split" \
		-ex "continue"

# 创建GDB配置文件
gdb-init: kernel
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
	@echo "现在可以运行: $(GDB) kernel/build/kernel"

# 清理调试文件
clean-debug:
	rm -f .gdbinit

# 清理所有构建文件
clean: clean-debug
	$(MAKE) -C $(USRDIR) clean
	$(MAKE) -C $(K) clean

.PHONY: all userprog kernel check clean qemu qemu-gdb debug gdb-init clean-debug fs