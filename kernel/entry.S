.section .text # 设置代码段，基于内存的段式管理
.global _entry # 设置全局入口点，告知连接器入口地址

_entry: # 定义入口点标签
        li t0, 0x10000000 # UART基地址
        li t1,'S'
        sb t1, 0(t0) # 输出字符'S'到UART
		li t1, '\n'
		sb t1, 0(t0)

		la sp, stack0
        li a0,4096*4 # 表示4096个字节单位
        add sp,sp,a0 # 初始化栈指针


        li t1,'P'
        sb t1,0(t0) # 输出字符'P'到UART
		li t1, '\n'
        sb t1, 0(t0)

        la a0,_bss_start
        la a1,_bss_end
clear_bss:
        bgeu a0,a1,bss_done
        sw zero,0(a0)
        addi a0,a0,4
        j clear_bss
bss_done:
        call start # 跳转到start函数
spin:
        j spin # 无限循环，防止程序退出

.section .data
.align 12
stack0:
        .space 4096*4 # 分配16KB栈空间