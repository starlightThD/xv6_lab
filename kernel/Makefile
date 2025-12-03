# 内核构建 Makefile

# 工具链配置
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
BUILD_DIR = build

$(shell mkdir -p $(BUILD_DIR))

# 编译选项
CFLAGS = -Wall -Werror -O0 -fno-omit-frame-pointer -g3
CFLAGS += -mcmodel=medany
CFLAGS += -ffreestanding -fno-common -nostdlib -mno-relax
CFLAGS += -I.
CFLAGS += $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)

LDFLAGS = -z max-page-size=4096 -g

# 内核对象文件
KERNEL_OBJS = \
	$(BUILD_DIR)/entry.o \
	$(BUILD_DIR)/start.o \
	$(BUILD_DIR)/uart.o \
	$(BUILD_DIR)/printf.o \
	$(BUILD_DIR)/mem.o \
	$(BUILD_DIR)/vm.o \
	$(BUILD_DIR)/pm.o \
	$(BUILD_DIR)/sbi.o \
	$(BUILD_DIR)/timer.o \
	$(BUILD_DIR)/trap.o \
	$(BUILD_DIR)/plic.o \
	$(BUILD_DIR)/kernelvec.o \
	$(BUILD_DIR)/trampoline.o \
	$(BUILD_DIR)/switch.o \
	$(BUILD_DIR)/proc.o	\
	$(BUILD_DIR)/string.o \
	$(BUILD_DIR)/test.o \
	$(BUILD_DIR)/virtio_disk.o \
	$(BUILD_DIR)/bio.o \
	$(BUILD_DIR)/log.o \
	$(BUILD_DIR)/file.o \
	$(BUILD_DIR)/pipe.o \
	$(BUILD_DIR)/fs.o	\
	$(BUILD_DIR)/spinlock.o \
	$(BUILD_DIR)/sleeplock.o

	
# 默认目标
all: kernel

# 构建内核
kernel: $(KERNEL_OBJS) kernel.ld
	$(LD) $(LDFLAGS) -T kernel.ld -o $(BUILD_DIR)/kernel $(KERNEL_OBJS)
	$(OBJDUMP) -S $(BUILD_DIR)/kernel > $(BUILD_DIR)/kernel.asm
	$(OBJDUMP) -t $(BUILD_DIR)/kernel | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $(BUILD_DIR)/kernel.sym

# 编译规则
$(BUILD_DIR)/entry.o: entry.S
	$(CC) $(CFLAGS) -c entry.S -o $(BUILD_DIR)/entry.o

$(BUILD_DIR)/start.o: start.c
	$(CC) $(CFLAGS) -c start.c -o $(BUILD_DIR)/start.o

$(BUILD_DIR)/uart.o: uart.c
	$(CC) $(CFLAGS) -c uart.c -o $(BUILD_DIR)/uart.o

$(BUILD_DIR)/printf.o: printf.c
	$(CC) $(CFLAGS) -c printf.c -o $(BUILD_DIR)/printf.o

$(BUILD_DIR)/mem.o: mem.c
	$(CC) $(CFLAGS) -c mem.c -o $(BUILD_DIR)/mem.o

$(BUILD_DIR)/vm.o: vm.c
	$(CC) $(CFLAGS) -c vm.c -o $(BUILD_DIR)/vm.o

$(BUILD_DIR)/pm.o: pm.c
	$(CC) $(CFLAGS) -c pm.c -o $(BUILD_DIR)/pm.o

$(BUILD_DIR)/sbi.o: sbi.c
	$(CC) $(CFLAGS) -c sbi.c -o $(BUILD_DIR)/sbi.o

$(BUILD_DIR)/timer.o: timer.c
	$(CC) $(CFLAGS) -c timer.c -o $(BUILD_DIR)/timer.o

$(BUILD_DIR)/trap.o: trap.c
	$(CC) $(CFLAGS) -c trap.c -o $(BUILD_DIR)/trap.o

$(BUILD_DIR)/plic.o: plic.c
	$(CC) $(CFLAGS) -c plic.c -o $(BUILD_DIR)/plic.o

$(BUILD_DIR)/kernelvec.o: kernelvec.S
	$(CC) $(CFLAGS) -c kernelvec.S -o $(BUILD_DIR)/kernelvec.o

$(BUILD_DIR)/trampoline.o: trampoline.S
	$(CC) $(CFLAGS) -c trampoline.S -o $(BUILD_DIR)/trampoline.o

$(BUILD_DIR)/switch.o: switch.S
	$(CC) $(CFLAGS) -c switch.S -o $(BUILD_DIR)/switch.o

$(BUILD_DIR)/proc.o: proc.c
	$(CC) $(CFLAGS) -c proc.c -o $(BUILD_DIR)/proc.o

$(BUILD_DIR)/string.o: string.c
	$(CC) $(CFLAGS) -c string.c -o $(BUILD_DIR)/string.o

$(BUILD_DIR)/test.o: test.c
	$(CC) $(CFLAGS) -c test.c -o $(BUILD_DIR)/test.o

$(BUILD_DIR)/virtio_disk.o: virtio_disk.c
	$(CC) $(CFLAGS) -c virtio_disk.c -o $(BUILD_DIR)/virtio_disk.o

$(BUILD_DIR)/bio.o: bio.c
	$(CC) $(CFLAGS) -c bio.c -o $(BUILD_DIR)/bio.o

$(BUILD_DIR)/log.o: log.c
	$(CC) $(CFLAGS) -c log.c -o $(BUILD_DIR)/log.o

$(BUILD_DIR)/file.o: file.c
	$(CC) $(CFLAGS) -c file.c -o $(BUILD_DIR)/file.o

$(BUILD_DIR)/pipe.o: pipe.c
	$(CC) $(CFLAGS) -c pipe.c -o $(BUILD_DIR)/pipe.o 

$(BUILD_DIR)/fs.o: fs.c
	$(CC) $(CFLAGS) -c fs.c -o $(BUILD_DIR)/fs.o 

$(BUILD_DIR)/spinlock.o: spinlock.c
	$(CC) $(CFLAGS) -c spinlock.c -o $(BUILD_DIR)/spinlock.o 

$(BUILD_DIR)/sleeplock.o: sleeplock.c
	$(CC) $(CFLAGS) -c sleeplock.c -o $(BUILD_DIR)/sleeplock.o 

# 验证内存布局
check: kernel
	@echo "=== 检查段信息 ==="
	$(OBJDUMP) -h kernel
	@echo "=== 检查符号表 ==="
	$(NM) kernel | grep -E "(start|end|text|bss|entry)"
	@echo "=== 检查入口点 ==="
	$(OBJDUMP) -f kernel

# 清理
clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean check