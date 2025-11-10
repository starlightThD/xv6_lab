#define MAXVA (1L << (39))

#define KERNBASE 0x80000000UL
#define PHYSTOP (KERNBASE + 128*1024*1024)
#define PGSIZE 4096
#define PLIC        0x0c000000L
#define PLIC_SENABLE(hart)   (PLIC + 0x2080 + (hart) * 0x100)
#define PLIC_SPRIORITY(hart) (PLIC + 0x201000 + (hart) * 0x2000)
#define PLIC_SCLAIM(hart)    (PLIC + 0x201004 + (hart) * 0x2000)
#define UART0       0x10000000L
#define UART0_IRQ   10
#define VIRTIO0     0x10001000L
#define VIRTIO0_IRQ 1
#define TIMER_IRQ 5
#define CLINT 0x2000000L
#define TRAMPOLINE 0xfffffffffffff000UL

#define KSTACK(p) (TRAMPOLINE - ((p)+1)* 2*PGSIZE)

#define TRAPFRAME (TRAMPOLINE - PGSIZE)

#define PGROUNDUP(sz)  (((sz)+PGSIZE-1) & ~(PGSIZE-1))
#define PGROUNDDOWN(a) (((a)) & ~(PGSIZE-1))

#define PA2VA(pa) ((void *)(pa))
#define VA2PA(va) ((uint64)(va))

// ...existing code...

// ...existing code...

// 用户空间布局定义
#define USER_TEXT_START    0x10000         // 用户代码段起始地址
#define USER_DATA_START    0x20000         // 用户数据段起始地址
#define USER_HEAP_START    0x400000        // 用户堆起始地址（4MB）
#define USER_STACK_SIZE    0x20000         // 用户栈大小（128KB）
#define USER_STACK_TOP     (MAXVA - PGSIZE*2)  // 用户栈顶地址，给trampoline留空间
#define USER_STACK_BOTTOM  (USER_STACK_TOP - USER_STACK_SIZE) // 用户栈底地址
#define USER_HEAP_MAX      USER_STACK_BOTTOM // 堆的最大扩展限制

// 用户空间地址检查宏
#define IS_USER_ADDR(va) ((uint64)(va) >= USER_TEXT_START && (uint64)(va) < MAXVA)
#define IS_USER_STACK(va) ((uint64)(va) >= USER_STACK_BOTTOM && (uint64)(va) < USER_STACK_TOP)
#define IS_USER_HEAP(va)  ((uint64)(va) >= USER_HEAP_START && (uint64)(va) < USER_HEAP_MAX)