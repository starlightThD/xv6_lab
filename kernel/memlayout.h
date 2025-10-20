#define MAXVA (1L << (39))

#define KERNBASE 0x80000000L
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
#define TRAMPOLINE (MAXVA - PGSIZE)

#define KSTACK(p) (TRAMPOLINE - ((p)+1)* 2*PGSIZE)

#define TRAPFRAME (TRAMPOLINE - PGSIZE)

#define PGROUNDUP(sz)  (((sz)+PGSIZE-1) & ~(PGSIZE-1))
#define PGROUNDDOWN(a) (((a)) & ~(PGSIZE-1))