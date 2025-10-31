    .section .text
    .globl _start
_start:
    li a7, 93        # 93 是 Linux ABI 下的 exit 系统调用号
    li a0, 0         # 退出码 0
    ecall            # 触发系统调用
