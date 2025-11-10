TOOLPREFIX ?= riscv64-unknown-elf-
CC	  = $(TOOLPREFIX)gcc
OBJCOPY = $(TOOLPREFIX)objcopy
OBJDUMP = $(TOOLPREFIX)objdump

CFLAGS  = -Wall -O2 -nostdlib -nostartfiles -ffreestanding -fno-common -mno-relax
CFLAGS += -march=rv64gc -mabi=lp64
LDFLAGS = -T user.ld -z max-page-size=4096

# 源文件
CRT0  := crt0.c
SRCS  := $(filter-out $(CRT0), $(wildcard *.c))
NAMES := $(basename $(SRCS))

# 统一输出目录
BUILD := build
ELFS  := $(addprefix $(BUILD)/,$(NAMES:=.elf))
BINS  := $(addprefix $(BUILD)/,$(NAMES:=.bin))
HDRS  := $(addprefix $(BUILD)/,$(NAMES:=.h))
DUMPS := $(addprefix $(BUILD)/,$(NAMES:=.dump))
ALL_HDR := $(BUILD)/user_progs.h

# 静默编译选项
QUIET = @

# 总目标
all: $(BUILD) $(ALL_HDR) $(HDRS) $(DUMPS) regen-user-progs
	$(QUIET)echo "用户程序编译完成"

# 确保 build 目录存在
$(BUILD):
	$(QUIET)mkdir -p $(BUILD)

# 先生成一个空的 user_progs.h（避免循环依赖报错）
$(ALL_HDR): | $(BUILD)
	$(QUIET)rm -f $@
	$(QUIET)echo "/* 占位的空 user_progs.h */" > $@

# C → ELF
$(BUILD)/%.elf: %.c $(CRT0) | $(BUILD) $(ALL_HDR)
	$(QUIET)echo "LINK  $@"
	$(QUIET)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

# ELF → bin
$(BUILD)/%.bin: $(BUILD)/%.elf | $(BUILD)
	$(QUIET)echo "BIN   $@"
	$(QUIET)$(OBJCOPY) -O binary $< $@

# bin → h（数组名去掉 build_ 前缀）
$(BUILD)/%.h: $(BUILD)/%.bin | $(BUILD) $(ALL_HDR)
	$(QUIET)echo "HDR   $@"
	$(QUIET)xxd -i -n $*_bin $< > $@
	$(QUIET)sed -i 's/^unsigned char/static const unsigned char/' $@
	$(QUIET)sed -i 's/^unsigned int/static const unsigned int/' $@

# ELF → dump
$(BUILD)/%.dump: $(BUILD)/%.elf | $(BUILD)
	$(QUIET)echo "DUMP  $@"
	$(QUIET)$(OBJDUMP) -d -S -M no-aliases $< > $@

# 重新生成真正的聚合头文件
regen-user-progs: $(HDRS)
	$(QUIET)echo "GEN   $(ALL_HDR)"
	$(QUIET)rm -f $(ALL_HDR)
	$(QUIET)echo "/* 自动生成的聚合头文件 */" > $(ALL_HDR)
	$(QUIET)for f in $(HDRS); do \
		bn=$$(basename $$f); \
		echo "#include \"$$bn\"" >> $(ALL_HDR); \
	done
	$(QUIET)echo >> $(ALL_HDR)
	$(QUIET)echo "// 用户测试程序结构" >> $(ALL_HDR)
	$(QUIET)echo "struct UserTestEntry {" >> $(ALL_HDR)
	$(QUIET)echo "	const char* name;		  // 程序名" >> $(ALL_HDR)
	$(QUIET)echo "	const void* binary;		// 程序二进制数据" >> $(ALL_HDR)
	$(QUIET)echo "	const int size;			// 程序大小" >> $(ALL_HDR)
	$(QUIET)echo "};" >> $(ALL_HDR)
	$(QUIET)echo >> $(ALL_HDR)
	$(QUIET)echo "// 自动生成的用户程序表" >> $(ALL_HDR)
	$(QUIET)echo "static const struct UserTestEntry user_test_table[] = {" >> $(ALL_HDR)
	$(QUIET)for src in $(SRCS); do \
		name=$$(basename $$src .c); \
		echo "	{\"$$name\", $${name}_bin, $${name}_bin_len}," >> $(ALL_HDR); \
	done
	$(QUIET)echo "};" >> $(ALL_HDR)
	$(QUIET)echo >> $(ALL_HDR)
	$(QUIET)echo "#define USER_TEST_COUNT (sizeof(user_test_table)/sizeof(user_test_table[0]))" >> $(ALL_HDR)
clean:
	$(QUIET)echo "CLEAN build/"
	$(QUIET)rm -rf $(BUILD)

.PHONY: all clean regen-user-progs