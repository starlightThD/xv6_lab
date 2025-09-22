#define MAXVA (1L << (39))

#define KERNBASE 0x80000000L
#define PHYSTOP (KERNBASE + 128*1024*1024)

#define UART0 0x10000000L
#define UART0_IRQ 10

#define TRAMPOLINE (MAXVA - PGSIZE)

#define KSTACK(p) (TRAMPOLINE - ((p)+1)* 2*PGSIZE)

#define TRAPFRAME (TRAMPOLINE - PGSIZE)

#define PGROUNDUP(sz)  (((sz)+PGSIZE-1) & ~(PGSIZE-1))
#define PGROUNDDOWN(a) (((a)) & ~(PGSIZE-1))