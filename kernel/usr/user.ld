/* user.ld - 最小用户态程序链接脚本 */

OUTPUT_ARCH(riscv)
ENTRY(_start)

/* 用户程序加载的虚拟地址，可以根据内核加载策略调整 */
BASE_ADDR = 0x10000;

SECTIONS
{
  . = BASE_ADDR;

  /* 代码段 */
  .text : {
    *(.text.startup)   /* main 等入口 */
    *(.text .text.*)
  }

  /* 只读数据段 */
  .rodata : {
    *(.rodata .rodata.*)
  }

  /* 已初始化数据段 */
  .data : {
    *(.data .data.*)
  }

  /* 未初始化数据段 (BSS) */
  .bss : {
    *(.bss .bss.*)
    *(COMMON)
  }

  /* 符号，方便内核知道用户程序大小 */
  _end = .;
}
