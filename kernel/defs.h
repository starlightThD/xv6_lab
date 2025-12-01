#include "types.h"
#include "memlayout.h"
#include "./usr/build/user_progs.h"
// ========================
// 宏定义
// ========================
// debug
//#ifndef DEBUG 
//#define DEBUG 1 
//#endif
// timer.h
#define TIMER_INTERVAL 1000000

// uart.h
#define Reg(reg) ((volatile unsigned char *)(UART0 + (reg)))
#define INPUT_BUF_SIZE 128
#define RHR 0					 // 接收保持寄存器 (读取)
#define THR 0					 // 发送保持寄存器 (写入)
#define IER 1					 // 中断使能寄存器
#define FCR 2					 // FIFO控制寄存器
#define LSR 5					 // 线路状态寄存器
#define LSR_TX_IDLE (1 << 5)	 // 标记发送保持寄存器可以接受下一个字符
#define LSR_RX_READY (1 << 0)	 // 标记接收缓冲区有数据
#define IER_RX_ENABLE (1 << 0)	 // 接收中断使能
#define IER_TX_ENABLE (1 << 1)	 // 发送中断使能
#define FCR_FIFO_ENABLE (1 << 0) // FIFO使能
#define FCR_FIFO_CLEAR (3 << 1)	 // 清除FIFO
#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))

// sbi.h
#define SBI_SET_TIME 0x0

// plic.h
#define HART_ID 0
#define PLIC_ENABLE (PLIC + 0x2080)
#define PLIC_PRIORITY (PLIC + 0x0)
#define PLIC_THRESHOLD (PLIC + 0x201000)
#define PLIC_CLAIM (PLIC + 0x201004)

// vm.h
#define PTE_V (1L << 0)
#define PTE_R (1L << 1)
#define PTE_W (1L << 2)
#define PTE_X (1L << 3)
#define PTE_U (1L << 4)
#define PTE_FLAGS(pte) ((pte) & 0x3FF)
#define VPN_SHIFT(level) (12 + 9 * (level))
#define VPN_MASK(va, level) (((va) >> VPN_SHIFT(level)) & 0x1FF)
#define PA2PTE(pa) ((((uint64)(pa)) >> 12) << 10)
#define PTE2PA(pte) (((pte) >> 10) << 12)
#define SATP_MODE_SV39 (8L << 60)
#define MAKE_SATP(pgtbl) (SATP_MODE_SV39 | (((uint64)(pgtbl)) >> 12))

// printf.h
#define ESC "\033"
#define CLEAR_SCREEN ESC "[2J"
#define CURSOR_HOME ESC "[H"
#define PRINTF_BUFFER_SIZE 128

// trap.h
#define MAX_IRQ 64
#define SSTATUS_SIE (1L << 1) // Supervisor Interrupt Enable

// proc.h
#define PROC 32 // 设定32个进程，目前最多达到512个

// syscall.h
#define SYS_printint 1
#define SYS_printstr 2
#define SYS_open 16
#define SYS_close 17
#define SYS_read 18
#define SYS_write 19
#define SYS_sbrk 25
#define SYS_get_time 42
#define SYS_exit 93
#define SYS_kill 129
#define SYS_pid 172
#define SYS_ppid 173
#define SYS_fork 220
#define SYS_wait 221
#define SYS_yield 222
#define SYS_step 0xFFF

// stat.h
#define T_DIR 1	   // Directory
#define T_FILE 2   // File
#define T_DEVICE 3 // Device

// fs.h
#define ROOTINO 1
#define BSIZE 1024
#define FSMAGIC 0x10203040
#define NDIRECT 12
#define NINDIRECT (BSIZE / sizeof(uint))
#define MAXFILE (NDIRECT + NINDIRECT)
#define IPB (BSIZE / sizeof(struct dinode))
#define BPB (BSIZE * 8)
#define DIRSIZ 14
#define NPROC 64	   // maximum number of processes
#define NCPU 8		   // maximum number of CPUs
#define NOFILE 16	   // open files per process
#define NFILE 100	   // open files per system
#define NINODE 50	   // maximum number of active i-nodes
#define NDEV 10		   // maximum major device number
#define ROOTDEV 1	   // device number of file system root disk
#define MAXARG 32	   // max exec arguments
#define MAXOPBLOCKS 10 // max # of blocks any FS op writes
#define FSSIZE 2000	   // size of file system in blocks
#define MAXPATH 128	   // maximum file path name
#define USERSTACK 1	   // user stack pages
#define CONSOLE 1
#define IBLOCK(i, sb) ((i) / IPB + sb.inodestart)
#define BBLOCK(b, sb) ((b) / BPB + sb.bmapstart)
#define O_RDONLY 0x0000 // 只读
#define O_WRONLY 0x0001 // 只写
#define O_RDWR 0x0002	// 读写
#define O_CREATE 0x0200 // 创建文件
// pipe.h
#define PIPESIZE 512

// virtio.h
#define VIRTIO_MMIO_MAGIC_VALUE 0x000 // 0x74726976
#define VIRTIO_MMIO_VERSION 0x004	  // version; should be 2
#define VIRTIO_MMIO_DEVICE_ID 0x008	  // device type; 1 is net, 2 is disk
#define VIRTIO_MMIO_VENDOR_ID 0x00c	  // 0x554d4551
#define VIRTIO_MMIO_DEVICE_FEATURES 0x010
#define VIRTIO_MMIO_DRIVER_FEATURES 0x020
#define VIRTIO_MMIO_QUEUE_SEL 0x030		   // select queue, write-only
#define VIRTIO_MMIO_QUEUE_NUM_MAX 0x034	   // max size of current queue, read-only
#define VIRTIO_MMIO_QUEUE_NUM 0x038		   // size of current queue, write-only
#define VIRTIO_MMIO_QUEUE_READY 0x044	   // ready bit
#define VIRTIO_MMIO_QUEUE_NOTIFY 0x050	   // write-only
#define VIRTIO_MMIO_INTERRUPT_STATUS 0x060 // read-only
#define VIRTIO_MMIO_INTERRUPT_ACK 0x064	   // write-only
#define VIRTIO_MMIO_STATUS 0x070		   // read/write
#define VIRTIO_MMIO_QUEUE_DESC_LOW 0x080   // physical address for descriptor table, write-only
#define VIRTIO_MMIO_QUEUE_DESC_HIGH 0x084
#define VIRTIO_MMIO_DRIVER_DESC_LOW 0x090 // physical address for available ring, write-only
#define VIRTIO_MMIO_DRIVER_DESC_HIGH 0x094
#define VIRTIO_MMIO_DEVICE_DESC_LOW 0x0a0 // physical address for used ring, write-only
#define VIRTIO_MMIO_DEVICE_DESC_HIGH 0x0a4
#define VIRTIO_CONFIG_S_ACKNOWLEDGE 1
#define VIRTIO_CONFIG_S_DRIVER 2
#define VIRTIO_CONFIG_S_DRIVER_OK 4
#define VIRTIO_CONFIG_S_FEATURES_OK 8
#define VIRTIO_BLK_F_RO 5		   /* Disk is read-only */
#define VIRTIO_BLK_F_SCSI 7		   /* Supports scsi command passthru */
#define VIRTIO_BLK_F_CONFIG_WCE 11 /* Writeback mode available in config */
#define VIRTIO_BLK_F_MQ 12		   /* support more than one vq */
#define VIRTIO_F_ANY_LAYOUT 27
#define VIRTIO_RING_F_INDIRECT_DESC 28
#define VIRTIO_RING_F_EVENT_IDX 29
#define NUM 16
#define VRING_DESC_F_NEXT 1	 // chained with another descriptor
#define VRING_DESC_F_WRITE 2 // device writes (vs read)
#define VIRTIO_BLK_T_IN 0	 // read the disk
#define VIRTIO_BLK_T_OUT 1	 // write the disk

// bio.h
#define BSIZE 1024
#define MAXOPBLOCKS 10				// max # of blocks any FS op writes
#define LOGBLOCKS (MAXOPBLOCKS * 3) // max data blocks in on-disk log
#define NBUF (MAXOPBLOCKS * 3)		// size of disk block cache
// ========================
// typedef
// ========================

typedef __builtin_va_list va_list;
#define va_start(ap, last) __builtin_va_start(ap, last)
#define va_arg(ap, type) __builtin_va_arg(ap, type)
#define va_end(ap) __builtin_va_end(ap)

// ========================
// struct定义
// ========================

struct trapframe
{
	uint64 kernel_satp;	  // 0
	uint64 kernel_sp;	  // 8
	uint64 kernel_trap;	  // 16
	uint64 usertrap;	  // 24
	uint64 kernel_vec;	  // 32
	uint64 kernel_hartid; // 40
	uint64 sstatus;		  // 48
	uint64 epc;			  // 56
	uint64 ra;			  // 64
	uint64 sp;			  // 72
	uint64 gp;			  // 80
	uint64 tp;			  // 88
	uint64 t0;			  // 96
	uint64 t1;			  // 104
	uint64 t2;			  // 112
	uint64 t3;			  // 120
	uint64 t4;			  // 128
	uint64 t5;			  // 136
	uint64 t6;			  // 144
	uint64 s0;			  // 152
	uint64 s1;			  // 160
	uint64 a0;			  // 168
	uint64 a1;			  // 176
	uint64 a2;			  // 184
	uint64 a3;			  // 192
	uint64 a4;			  // 200
	uint64 a5;			  // 208
	uint64 a6;			  // 216
	uint64 a7;			  // 224
	uint64 s2;			  // 232
	uint64 s3;			  // 240
	uint64 s4;			  // 248
	uint64 s5;			  // 256
	uint64 s6;			  // 264
	uint64 s7;			  // 272
	uint64 s8;			  // 280
	uint64 s9;			  // 288
	uint64 s10;			  // 296
	uint64 s11;			  // 304
};

struct uart_input_buf_t
{
	char buf[INPUT_BUF_SIZE];
	uint r;
	uint w;
	uint e;
};

struct trap_info
{
	uint64 sepc;
	uint64 sstatus;
	uint64 scause;
	uint64 stval;
};

struct CommandEntry
{
	const char *name;
	void (*func)(void);
};

struct context
{
	uint64 ra;
	uint64 sp;
	uint64 s0;
	uint64 s1;
	uint64 s2;
	uint64 s3;
	uint64 s4;
	uint64 s5;
	uint64 s6;
	uint64 s7;
	uint64 s8;
	uint64 s9;
	uint64 s10;
	uint64 s11;
};

struct cpu
{
	struct proc *proc;
	struct context context;
};

enum procstate
{
	UNUSED,
	USED,
	SLEEPING,
	RUNNABLE,
	RUNNING,
	ZOMBIE
};

struct proc
{
	enum procstate state;
	int pid;
	uint64 kstack;
	struct context context;
	int killed;
	int exit_status;
	char name[16];
	struct proc *parent;
	void *chan;
	int is_user;
	uint64 sz;
	pagetable_t pagetable;
	struct trapframe *trapframe;
	struct inode *cwd; // 当前工作目录
};
// fs.h
// 超级块结构
struct superblock
{
	uint magic;
	uint size;
	uint nblocks;
	uint ninodes;
	uint nlog;
	uint logstart;
	uint inodestart;
	uint bmapstart;
};
// 磁盘 inode 结构
struct dinode
{
	short type;
	short major;
	short minor;
	short nlink;
	uint size;
	uint addrs[NDIRECT + 1];
};

// 目录项结构
struct dirent
{
	ushort inum;
	char name[DIRSIZ] __attribute__((nonstring));
};

// spinlock.h
struct spinlock
{
	uint locked; // Is the lock held?
	char *name;	 // Name of lock.
};
// sleeplock.h
struct sleeplock
{
	uint locked;		// Is the lock held?
	struct spinlock lk; // spinlock protecting this sleep lock
	char *name;			// Name of lock.
	int pid;			// Process holding lock
};
// 内存 inode 结构
struct inode
{
	uint dev;
	uint inum;
	int ref;
	int valid;
	int used; // 0: 空闲，1: 被占用
	// 从磁盘拷贝的内容
	short type;
	short major;
	short minor;
	short nlink;
	uint size;
	uint addrs[NDIRECT + 1];
	struct sleeplock lock; // 新增：inode的睡眠锁
};

// virtio.h
struct virtq_desc
{
	uint64 addr;
	uint32 len;
	uint16 flags;
	uint16 next;
};

struct virtq_avail
{
	uint16 flags;	  // always zero
	uint16 idx;		  // driver will write ring[idx] next
	uint16 ring[NUM]; // descriptor numbers of chain heads
	uint16 unused;
};

struct virtq_used_elem
{
	uint32 id; // index of start of completed descriptor chain
	uint32 len;
};

struct virtq_used
{
	uint16 flags; // always zero
	uint16 idx;	  // device increments when it adds a ring[] entry
	struct virtq_used_elem ring[NUM];
};
struct virtio_blk_req
{
	uint32 type; // VIRTIO_BLK_T_IN or ..._OUT
	uint32 reserved;
	uint64 sector;
};

struct disk
{
	struct virtq_desc *desc;
	struct virtq_avail *avail;
	struct virtq_used *used;
	char free[NUM];	 // is a descriptor free?
	uint16 used_idx; // we've looked this far in used[2..NUM].
	struct
	{
		struct buf *b;
		char status;
	} info[NUM];
	struct virtio_blk_req ops[NUM];
	struct spinlock vdisk_lock;
};

// bio.h
struct buf
{
	int valid; // has data been read from disk?
	int disk;  // does disk "own" buf?
	uint dev;
	uint blockno;
	uint refcnt;
	struct sleeplock lock; // 统一使用 sleeplock
	struct buf *prev;	   // LRU cache list
	struct buf *next;
	uchar data[BSIZE];
};

struct Bcache
{
	struct buf buf[NBUF];
	struct buf head;
	struct spinlock lock; // 全局锁
};

// log.h
struct logheader
{
	int n;
	int block[LOGBLOCKS];
};

struct log
{
	struct spinlock lock;
	int start;
	int outstanding; // how many FS sys calls are executing.
	int committing;	 // in commit(), please wait.
	int dev;
	struct logheader lh;
};
// file.h
struct file
{
	enum
	{
		FD_NONE,
		FD_PIPE,
		FD_INODE,
		FD_DEVICE
	} type;
	int ref; // reference count
	char readable;
	char writable;
	struct pipe *pipe; // FD_PIPE
	struct inode *ip;  // FD_INODE and FD_DEVICE
	uint off;		   // FD_INODE
	short major;	   // FD_DEVICE
};
struct devsw
{
	int (*read)(int, uint64, int);
	int (*write)(int, uint64, int);
};
// pipe.h
struct pipe
{
	char data[PIPESIZE];
	uint nread;	   // number of bytes read
	uint nwrite;   // number of bytes written
	int readopen;  // read fd is still open
	int writeopen; // write fd is still open
};

// stat.h
struct stat
{
	int dev;	 // File system's disk device
	uint ino;	 // Inode number
	short type;	 // Type of file
	short nlink; // Number of links to file
	uint64 size; // Size of file in bytes
};
// ========================
// 函数声明（分模块）
// ========================

// timer.h
void timeintr(void);

// uart.h
extern struct uart_input_buf_t uart_input_buf;
void uart_init(void);
void uart_intr(void);
void uart_putc(char c);
void uart_puts(char *s);
int uart_getc(void);
char uart_getchar(void);
int readline(char *buf, int max);

// string.h
int strlen(const char *s);
int strcmp(const char *p, const char *q);
char *strcpy(char *s, const char *t);
char *safestrcpy(char *s, const char *t, int n);
int atoi(const char *s);
int strncmp(const char *s, const char *t, int n);
char *strncpy(char *dst, const char *src, int n);
char* strcat(char *dst, const char *src);

// sbi.h
void sbi_set_time(uint64 time);
uint64 sbi_get_time(void);

// plic.h
void plic_init(void);
void plic_enable(int irq);
void plic_disable(int irq);
int plic_claim(void);
void plic_complete(int irq);

// start.h
// struct CommandEntry 已定义

// mem.h
void *memset(void *dst, int c, unsigned long n);
void *memmove(void *dst, const void *src, unsigned long n);
void *memcpy(void *dst, const void *src, unsigned long n);

// pm.h
void pmm_init(void);
void *alloc_page(void);
void free_page(void *page);
void test_physical_memory(void);

// vm.h
pagetable_t get_current_pagetable(void);
void sfence_vma(void);
pagetable_t create_pagetable(void);
int map_page(pagetable_t pt, uint64 va, uint64 pa, int perm);
void free_pagetable(pagetable_t pt);
void kvminit(void);
void check_mapping(uint64 va);
int check_is_mapped(uint64 va);
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz);
void test_pagetable(void);
pte_t *walk_lookup(pagetable_t pt, uint64 va);
void print_pagetable(pagetable_t pagetable, int level, uint64 va_base);

// printf.h
void printf(const char *fmt, ...);
int snprintf(char *buf, size_t size, const char *fmt, ...);
void clear_screen(void);
void goto_rc(int row, int col);
void cursor_up(int lines);
void cursor_down(int lines);
void cursor_right(int lines);
void cursor_left(int lines);
void save_cursor(void);
void restore_cursor(void);
void reset_color(void);
void set_fg_color(int color);
void set_bg_color(int color);
void set_color(int fg, int bg);
void color_red(void);
void color_green(void);
void color_yellow(void);
void color_blue(void);
void color_purple(void);
void color_cyan(void);
void color_reverse(void);
void clear_line(void);
void debug(const char *fmt, ...);
void panic(const char *fmt, ...);
void warning(const char *fmt, ...);
void test_printf_precision(void);
void test_curse_move();
void test_basic_colors(void);

// trap.h
typedef void (*interrupt_handler_t)(void);
extern interrupt_handler_t interrupt_vector[MAX_IRQ];
void register_interrupt(int irq, interrupt_handler_t h);
void unregister_interrupt(int irq);
void enable_interrupts(int irq);
void disable_interrupts(int irq);
void interrupt_dispatch(int irq);
uint64 get_time(void);
void trap_init(void);
void kerneltrap(void);
void handle_exception(struct trapframe *tf, struct trap_info *info);
void handle_syscall(struct trapframe *tf, struct trap_info *info);
void handle_instruction_page_fault(struct trapframe *tf, struct trap_info *info);
void handle_load_page_fault(struct trapframe *tf, struct trap_info *info);
void handle_store_page_fault(struct trapframe *tf, struct trap_info *info);
int handle_page_fault(uint64 va, int type);
void usertrap(void);
void usertrapret(void);
int copyin(char *dst, uint64 srcva, int maxlen);
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len);
int copyinstr(char *dst, pagetable_t pagetable, uint64 srcva, int max);
int check_user_addr(uint64 addr, uint64 size, int write);

// proc.h
extern void swtch(struct context *old, struct context *new);
struct proc *myproc(void);
struct cpu *mycpu(void);
void init_proc(void);
struct proc *alloc_proc(int is_user);
void free_proc(struct proc *p);
void free_proc_table(void);
int create_kernel_proc(void (*entry)(void));
int create_kernel_proc1(void (*entry)(uint64), uint64 arg);
int create_user_proc(const void *user_bin, int bin_size);
int fork_proc(void);
void exit_proc(int status);
int wait_proc(int *status);
void kill_proc(int pid);
void return_to_user(void);
void forkret(void);
void schedule(void);
void yield(void);
void sleep(void *chan, struct spinlock *lk);
void wakeup(void *chan);
void print_proc_table(void);
struct proc *get_proc(int pid);

// test.h
void test_timer_interrupt(void);
void test_exception(void);
void test_interrupt_overhead(void);

void test_process_creation(void);
void test_scheduler(void);
void test_synchronization(void);
void test_kill(void);

void test_filesystem_integrity(void);
void test_multi_process_filesystem(void);
void test_filesystem_performance(void);
// virtio_disk.h
void virtio_disk_init(void);
int alloc_desc(void);
void free_desc(int i);
void free_chain(int i);
int alloc3_desc(int *idx);
void virtio_disk_rw(struct buf *b, int write);
void virtio_disk_intr(void);

// spinlock.h
void initlock(struct spinlock *lk, char *name);
void acquire(struct spinlock *lk);
void release(struct spinlock *lk);
int holding(struct spinlock *lk);

// sleeplock.h
void initsleeplock(struct sleeplock *lk, char *name);
void acquiresleep(struct sleeplock *lk);
void releasesleep(struct sleeplock *lk);
int holdingsleep(struct sleeplock *lk);

// bio.h
void binit(void);
struct buf *bread(uint dev, uint blockno);
void bwrite(struct buf *b);
void brelse(struct buf *b);
void bpin(struct buf *b);
void bunpin(struct buf *b);

// log.h
void initlog(int dev, struct superblock *sb);
void begin_op(void);
void end_op(void);
void recover_from_log(void);
void log_write(struct buf *b);

// pipe.h
int pipealloc(struct file **f0, struct file **f1);
void pipeclose(struct pipe *pi, int writable);
int pipewrite(struct pipe *pi, uint64 addr, int n);
int piperead(struct pipe *pi, uint64 addr, int n);

// file.h
void fileinit(void);
struct file *filealloc(void);
struct file *filedup(struct file *f);
int filestat(struct file *f, uint64 addr);
void filelock(struct file *f);
void fileunlock(struct file *f);
struct file *open(struct inode *ip, int readable, int writable);
void close(struct file *f);
int read(struct file *f, uint64 addr, int n);
int write(struct file *f, uint64 addr, int n);

// fs.h
void fsinit(int dev);
struct inode *ialloc(uint dev, short type);
void iinit();
struct inode *idup(struct inode *ip);
void ilock(struct inode *ip);
void iunlock(struct inode *ip); // 你需要在文件中实现或声明
void iput(struct inode *ip);
void iupdate(struct inode *ip);
void itrunc(struct inode *ip);
void stati(struct inode *ip, struct stat *st);
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n);
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n);
struct inode *dirlookup(struct inode *dp, char *name, uint *poff);
int dirlink(struct inode *dp, char *name, uint inum);
struct inode *namei(char *path);
struct inode *nameiparent(char *path, char *name);
void ireclaim(int dev);
struct inode *iget(uint dev, uint inum);
void iunlockput(struct inode *ip);
struct inode* create(char *path, short type, short major, short minor);
int unlink(char *path);

// ========================
// static inline 函数
// ========================

// riscv.h
static inline uint64 r_sie()
{
	uint64 x;
	asm volatile("csrr %0, sie" : "=r"(x));
	return x;
}

static inline void w_sie(uint64 x)
{
	asm volatile("csrw sie, %0" : : "r"(x));
}

static inline uint64 r_sstatus()
{
	uint64 x;
	asm volatile("csrr %0, sstatus" : "=r"(x));
	return x;
}
static inline void w_sstatus(uint64 x)
{
	asm volatile("csrw sstatus, %0" : : "r"(x));
}
static inline void w_sscratch(uint64 x)
{
	asm volatile("csrw sscratch, %0" : : "r"(x));
}

static inline void w_sepc(uint64 x)
{
	asm volatile("csrw sepc, %0" : : "r"(x));
}

static inline void intr_on()
{
	w_sstatus(r_sstatus() | SSTATUS_SIE);
}

static inline void intr_off()
{
	w_sstatus(r_sstatus() & ~SSTATUS_SIE);
}

static inline void w_stvec(uint64 x)
{
	asm volatile("csrw stvec, %0" : : "r"(x));
}

static inline uint64 r_tp()
{
	uint64 x;
	asm volatile("mv %0, tp" : "=r"(x));
	return x;
}

static inline uint64 r_scause()
{
	uint64 x;
	asm volatile("csrr %0, scause" : "=r"(x));
	return x;
}

static inline uint64 r_sepc()
{
	uint64 x;
	asm volatile("csrr %0, sepc" : "=r"(x));
	return x;
}

static inline uint64 r_stval()
{
	uint64 x;
	asm volatile("csrr %0, stval" : "=r"(x));
	return x;
}

static inline void write32(uint64 addr, uint32 val)
{
	if ((addr & 0x3) == 0)
	{
		volatile uint32 *ptr = (volatile uint32 *)(addr);
		*ptr = val;
	}
	else
	{
		printf("ERROR: Misaligned write32 access: addr=%p\n", addr);
	}
}

static inline uint32 read32(uint64 addr)
{
	if ((addr & 0x3) == 0)
	{
		volatile uint32 *ptr = (volatile uint32 *)(addr);
		return *ptr;
	}
	else
	{
		printf("ERROR: Misaligned read32 access: addr=%p\n", addr);
		return 0;
	}
}

#define assert(expr) \
    do { \
        if (!(expr)) { \
            printf("assert failed: file %s, line %d\n", __FILE__, __LINE__); \
            panic("assert"); \
        } \
    } while (0)


static inline uint64 sv39_sign_extend(uint64 va)
{
	if (va & (1L << 38))
		return va | (~((1ULL << 39) - 1));
	else
		return va & ((1ULL << 39) - 1);
}
static inline int sv39_check_valid(uint64 va)
{
	// Sv39 有效范围：0x000000000000 ~ 0x7FFFFFFFFF 或 0xFFFFFFFFC0000000 ~ 0xFFFFFFFFFFFFFFFF
	return (va < (1ULL << 39)) || (va >= (uint64)(-1LL << 39));
}