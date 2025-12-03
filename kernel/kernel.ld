OUTPUT_ARCH( "riscv" ) /*定义目标平台*/
ENTRY( _entry ) /*定义入口点*/

SECTIONS
{
  . = 0x80200000;/*入口点的内存地址，给SBI组件腾出空间*/

  .text : {
    *(.text .text.*)
    . = ALIGN(0x1000);/*地址对齐到4KB*/
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
    _bss_start = .;        /* 在BSS段开始处定义_bss_start符号 */
    *(.sbss .sbss.*) /* do not need to distinguish this from .bss */
    . = ALIGN(16);
    *(.bss .bss.*)
    . = ALIGN(16);
    _bss_end = .;          /* 在BSS段结束处定义_bss_end符号 */
  }
  
  .bcache : ALIGN(16) {
    *(.bcache)
  }

  PROVIDE(end = .);
}