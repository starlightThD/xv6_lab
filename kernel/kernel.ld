OUTPUT_ARCH( "riscv" ) /*定义目标平台*/
ENTRY( _entry ) /*定义入口点*/

SECTIONS
{
  . = 0x80000000;/*入口点的内存地址*/

  .text : {
    kernel/entry.o(_entry)
    *(.text .text.*)
    . = ALIGN(0x1000);/*地址对齐到4KB*/
    _trampoline = .;/*状态切换的部分*/
    *(trampsec)
    . = ALIGN(0x1000);
    ASSERT(. - _trampoline == 0x1000, "error: trampoline larger than one page");/*简单处理起见 */
    PROVIDE(etext = .); /*非必须，但一般都会加，便于分配结束地址*/
  }

  .rodata : {
    . = ALIGN(16);
    *(.srodata .srodata.*) /* do not need to distinguish this from .rodata */
    . = ALIGN(16);
    *(.rodata .rodata.*)
  }

  .data : {
    . = ALIGN(16);
    *(.sdata .sdata.*) /* do not need to distinguish this from .data */
    . = ALIGN(16);
    *(.data .data.*)
  }

  .bss : {
    . = ALIGN(16);
    *(.sbss .sbss.*) /* do not need to distinguish this from .bss */
    . = ALIGN(16);
    *(.bss .bss.*)
  }

  PROVIDE(end = .);
}