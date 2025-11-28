K=kernel
USRDIR = $(K)/usr
DISK = fs.img

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
QEMUOPTS = -machine virt -bios /usr/riscv64-linux-gnu/opensbi/fw_jump.elf -kernel $K/kernel -m 128M -smp 1 -nographic \
-global virtio-mmio.force-legacy=false \
-drive file=$(DISK),if=none,format=raw,id=x0 \
-device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0 \
-d int -D qemu_int.log 

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
  $K/kernelvec.o \
  $K/trampoline.o \
  $K/switch.o \
  $K/proc.o  \
  $K/string.o \
  $K/test.o \
  $K/virtio_disk.o \
  $K/bio.o \
  $K/log.o \
  $K/file.o \
  $K/pipe.o \
  $K/fs.o	\
  $K/spinlock.o \
  $K/sleeplock.o

all: userprog $(K)/kernel 

userprog:
	$(MAKE) -C $(USRDIR)

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

$K/trampoline.o: $K/trampoline.S
	$(CC) $(CFLAGS) -c $K/trampoline.S -o $K/trampoline.o

$K/switch.o: $K/switch.S
	$(CC) $(CFLAGS) -c $K/switch.S -o $K/switch.o

$K/proc.o: $K/proc.c
	$(CC) $(CFLAGS) -c $K/proc.c -o $K/proc.o

$K/string.o: $K/string.c
	$(CC) $(CFLAGS) -c $K/string.c -o $K/string.o

$K/test.o: $K/test.c
	$(CC) $(CFLAGS) -c $K/test.c -o $K/test.o

$K/virtio_disk.o: $K/virtio_disk.c
	$(CC) $(CFLAGS) -c $K/virtio_disk.c -o $K/virtio_disk.o

$K/bio.o: $K/bio.c
	$(CC) $(CFLAGS) -c $K/bio.c -o $K/bio.o

$K/log.o: $K/log.c	
	$(CC) $(CFLAGS) -c $K/log.c -o $K/log.o

$K/file.o: $K/file.c
	$(CC) $(CFLAGS) -c $K/file.c -o $K/file.o

$K/pipe.o: $K/pipe.c
	$(CC) $(CFLAGS) -c $K/pipe.c -o $K/pipe.o 

$K/fs.o: $K/fs.c
	$(CC) $(CFLAGS) -c $K/fs.c -o $K/fs.o 

$K/spinlock.o: $K/spinlock.c
	$(CC) $(CFLAGS) -c $K/spinlock.c -o $K/spinlock.o 

$K/sleeplock.o: $K/sleeplock.c
	$(CC) $(CFLAGS) -c $K/sleeplock.c -o $K/sleeplock.o 
# 验证内存布局
check: $K/kernel
	@echo "=== 检查段信息 ==="
	$(OBJDUMP) -h $K/kernel
	@echo "=== 检查符号表 ==="
	$(NM) $K/kernel | grep -E "(start|end|text|bss|entry)"
	@echo "=== 检查入口点 ==="
	$(OBJDUMP) -f $K/kernel

# 运行 QEMU
qemu: userprog $K/kernel
	@echo "=== 启动 QEMU ==="
	$(QEMU) $(QEMUOPTS)

# 调试模式运行 QEMU (等待 GDB 连接)
qemu-gdb: userprog $K/kernel
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

# 清理调试文件
clean-debug:
	rm -f .gdbinit

# 扩展clean目标
clean: clean-debug
	$(MAKE) -C $(USRDIR) clean
	rm -f $K/*.o $K/kernel $K/*.asm $K/*.sym

.PHONY: all userprog check clean qemu qemu-gdb debug gdb-init clean-debug fs