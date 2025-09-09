.section .text # 设置代码段，基于内存的段式管理
.global _entry # 设置全局入口点，告知连接器入口地址
_entry: # 定义入口点标签
        la sp, stack0 # 加载栈顶地址，stack0会指定所有核心分配的总栈大小
        li a0, 1024*4 # 每个核心的栈大小，4096是一个页的大小，是效率与大小较为平均的选择
        csrr a1, mhartid # 从核心的寄存器获取每个CPU的编号
        addi a1, a1, 1 
        mul a0, a0, a1 # 计算自己核心栈的偏移量
        add sp, sp, a0 # 设置自己的栈指针
        call start # 跳转到start函数
spin:
        j spin # 无限循环，防止程序退出