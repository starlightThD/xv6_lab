TOOLPREFIX ?= riscv64-unknown-elf-
CC	  = $(TOOLPREFIX)gcc
OBJCOPY = $(TOOLPREFIX)objcopy
OBJDUMP = $(TOOLPREFIX)objdump

CFLAGS  = -Wall -O2 -nostdlib -nostartfiles -ffreestanding -fno-common -mno-relax
CFLAGS += -march=rv64gc -mabi=lp64
LDFLAGS = -T user.ld -z max-page-size=4096

# 源文件
SRCS  := $(wildcard *.c)
NAMES := $(basename $(SRCS))

# 统一输出目录
BUILD := build
ELFS  := $(addprefix $(BUILD)/,$(NAMES:=.elf))
BINS  := $(addprefix $(BUILD)/,$(NAMES:=.bin))
HDRS  := $(addprefix $(BUILD)/,$(NAMES:=.h))
ASMS  := $(addprefix $(BUILD)/,$(NAMES:=.s))
DUMPS := $(addprefix $(BUILD)/,$(NAMES:=.dump))
ALL_HDR := $(BUILD)/user_progs.h

# 总目标
all: $(BUILD) $(ALL_HDR) $(HDRS) $(ASMS) $(DUMPS) regen-user-progs

# 确保 build 目录存在
$(BUILD):
	mkdir -p $(BUILD)

# 先生成一个空的 user_progs.h（避免循环依赖报错）
$(ALL_HDR): | $(BUILD)
	@rm -f $@
	@echo "/* 占位的空 user_progs.h */" > $@

# C → 汇编
$(BUILD)/%.s: %.c | $(BUILD) $(ALL_HDR)
	$(CC) $(CFLAGS) -S -o $@ $<

# C → ELF
$(BUILD)/%.elf: %.c user.ld | $(BUILD) $(ALL_HDR)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $<

# ELF → bin
$(BUILD)/%.bin: $(BUILD)/%.elf | $(BUILD)
	$(OBJCOPY) -O binary $< $@

# bin → h（数组名去掉 build_ 前缀）
$(BUILD)/%.h: $(BUILD)/%.bin | $(BUILD) $(ALL_HDR)
	@echo "生成 $@"
	xxd -i -n $*_bin $< > $@
	# 把全局符号改成 static const
	sed -i 's/^unsigned char/static const unsigned char/' $@
	sed -i 's/^unsigned int/static const unsigned int/' $@


# ELF → dump
$(BUILD)/%.dump: $(BUILD)/%.elf | $(BUILD)
	$(OBJDUMP) -d -S -M no-aliases $< > $@

# 重新生成真正的聚合头文件
regen-user-progs: $(HDRS)
	@echo "更新 $(ALL_HDR)"
	@rm -f $(ALL_HDR)
	@echo "/* 自动生成的聚合头文件 */" > $(ALL_HDR)
	@for f in $(HDRS); do \
		bn=$$(basename $$f); \
		echo "#include \"$$bn\"" >> $(ALL_HDR); \
	done

clean:
	rm -rf $(BUILD)

.PHONY: all clean regen-user-progs
