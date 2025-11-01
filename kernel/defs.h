#include "types.h"
#include "memlayout.h"

// ========================
// 宏定义
// ========================

// timer.h
#define TIMER_INTERVAL 1000000

// uart.h
#define Reg(reg) ((volatile unsigned char *)(UART0 + (reg)))
#define INPUT_BUF_SIZE 128
#define RHR 0      // 接收保持寄存器 (读取)
#define THR 0      // 发送保持寄存器 (写入)
#define IER 1      // 中断使能寄存器
#define FCR 2      // FIFO控制寄存器
#define LSR 5      // 线路状态寄存器
#define LSR_TX_IDLE (1<<5)     // 标记发送保持寄存器可以接受下一个字符
#define LSR_RX_READY (1<<0)    // 标记接收缓冲区有数据
#define IER_RX_ENABLE (1<<0)   // 接收中断使能
#define IER_TX_ENABLE (1<<1)   // 发送中断使能
#define FCR_FIFO_ENABLE (1<<0) // FIFO使能
#define FCR_FIFO_CLEAR (3<<1)  // 清除FIFO
#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))

// sbi.h
#define SBI_SET_TIME 0x0

// plic.h
#define HART_ID 0
#define PLIC_ENABLE     (PLIC + 0x2080)
#define PLIC_PRIORITY   (PLIC + 0x0)
#define PLIC_THRESHOLD  (PLIC + 0x201000)
#define PLIC_CLAIM      (PLIC + 0x201004)

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
#define SSTATUS_SIE (1L << 1)  // Supervisor Interrupt Enable

// proc.h
#define PROC 64 // 设定64个进程，目前最多达到512个
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

struct trapframe {
  uint64 kernel_satp;	//0
  uint64 kernel_sp;		//8
  uint64 kernel_trap;	//16
  uint64 sstatus;		//24
  uint64 epc;			//32
  uint64 kernel_hartid;	//40
  uint64 ra;			//48
  uint64 sp;			//56
  uint64 gp;			//64
  uint64 tp;			//72
  uint64 t0;			//80
  uint64 t1;			//88
  uint64 t2;			//96
  uint64 s0;			//104
  uint64 s1;			//112
  uint64 a0;			//120
  uint64 a1;			//128
  uint64 a2;			//136
  uint64 a3;
  uint64 a4;
  uint64 a5;
  uint64 a6;
  uint64 a7;
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
  uint64 usertrap; 		//264
  uint64 kernel_vec;	//272
};

struct uart_input_buf_t {
    char buf[INPUT_BUF_SIZE];
    uint r;
    uint w;
    uint e;
};

struct trap_info {
    uint64 sepc;
    uint64 sstatus;
    uint64 scause;
    uint64 stval;
};

struct CommandEntry {
    const char *name;
    void (*func)(void);
    const char *desc;
};

struct context {
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

struct cpu {
  struct proc *proc;
  struct context context;
};

enum procstate { UNUSED, USED, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };

struct proc {
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
char* strcpy(char *s, const char *t);
char* safestrcpy(char *s, const char *t, int n);

// sbi.h
void sbi_set_time(uint64 time);
uint64 sbi_get_time(void);

// plic.h
void plic_init(void);
void plic_enable(int irq);
void plic_disable(int irq);
int  plic_claim(void);
void plic_complete(int irq);

// start.h
// struct CommandEntry 已定义

// mem.h
void *memset(void *dst, int c, unsigned long n);
void *memmove(void *dst, const void *src, unsigned long n);
void *memcpy(void *dst, const void *src, unsigned long n);

// pm.h
void pmm_init(void);
void* alloc_page(void);
void free_page(void* page);
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
pte_t* walk_lookup(pagetable_t pt, uint64 va);
void print_pagetable(pagetable_t pagetable, int level, uint64 va_base);

// printf.h
void printf(const char *fmt, ...);
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
void panic(const char *msg);
void warning(const char *fmt, ...);
void test_printf_precision(void);
void test_curse_move();
void test_basic_colors(void);

// trap.h
typedef  void (*interrupt_handler_t)(void);
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

// proc.h
extern void swtch(struct context *old, struct context *new);
struct proc* myproc(void);
struct cpu* mycpu(void);
void init_proc(void);
struct proc* alloc_proc(int is_user);
void free_proc(struct proc *p);
void free_proc_table(void);
int create_kernel_proc(void (*entry)(void));
int create_user_proc(const void *user_bin, int bin_size);
int fork_proc(void);
void exit_proc(int status);
int wait_proc(int *status);
void return_to_user(void);
void forkret(void);
void schedule(void);
void yield(void);
void sleep(void *chan);
void wakeup(void *chan);
void print_proc_table(void);

// syscall.h
// 系统调用实现函数声明
uint64 sys_exit(void);
uint64 sys_getpid(void);
uint64 sys_getppid(void);
uint64 sys_fork(void);
uint64 sys_wait(void);
uint64 sys_read(void);
uint64 sys_write(void);
uint64 sys_open(void);
uint64 sys_close(void);
uint64 sys_brk(void);
uint64 sys_mmap(void);
uint64 sys_munmap(void);
uint64 sys_gettimeofday(void);
uint64 sys_sleep(void);

// test.h
void test_timer_interrupt(void);
void test_exception(void);

void test_process_creation(void);
void test_scheduler(void);
void test_synchronization(void);
void test_sys_usr(void);
// ========================
// static inline 函数
// ========================

// riscv.h
static inline uint64 r_sie() {
  uint64 x;
  asm volatile("csrr %0, sie" : "=r" (x));
  return x;
}

static inline void w_sie(uint64 x) {
  asm volatile("csrw sie, %0" : : "r"(x));
}

static inline uint64 r_sstatus() {
  uint64 x;
  asm volatile("csrr %0, sstatus" : "=r" (x));
  return x;
}
static inline void w_sstatus(uint64 x) {
  asm volatile("csrw sstatus, %0" : : "r"(x));
}
static inline void w_sscratch(uint64 x) {
  asm volatile("csrw sscratch, %0" : : "r"(x));
}

static inline void w_sepc(uint64 x) {
  asm volatile("csrw sepc, %0" : : "r"(x));
}

static inline void intr_on() {
  w_sstatus(r_sstatus() | SSTATUS_SIE);
}

static inline void intr_off() {
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
}

static inline void w_stvec(uint64 x) {
  asm volatile("csrw stvec, %0" : : "r"(x));
}

static inline uint64 r_tp() {
  uint64 x;
  asm volatile("mv %0, tp" : "=r" (x));
  return x;
}

static inline uint64 r_scause() {
  uint64 x;
  asm volatile("csrr %0, scause" : "=r" (x));
  return x;
}

static inline uint64 r_sepc() {
  uint64 x;
  asm volatile("csrr %0, sepc" : "=r" (x));
  return x;
}

static inline uint64 r_stval() {
  uint64 x;
  asm volatile("csrr %0, stval" : "=r" (x));
  return x;
}

static inline void write32(uint64 addr, uint32 val) {
    if ((addr & 0x3) == 0) {
        volatile uint32 *ptr = (volatile uint32 *)(addr);
        *ptr = val;
    } else {
        printf("ERROR: Misaligned write32 access: addr=%p\n", addr);
    }
}

static inline uint32 read32(uint64 addr) {
    if ((addr & 0x3) == 0) {
        volatile uint32 *ptr = (volatile uint32 *)(addr);
        return *ptr;
    } else {
        printf("ERROR: Misaligned read32 access: addr=%p\n", addr);
        return 0;
    }
}

static inline void assert(int expr) {
    if (!expr) {
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
        panic("assert");
    }
}
static inline uint64 sv39_sign_extend(uint64 va) {
    if (va & (1L << 38))
        return va | (~((1ULL << 39) - 1));
    else
        return va & ((1ULL << 39) - 1);
}
static inline int sv39_check_valid(uint64 va) {
    // Sv39 有效范围：0x000000000000 ~ 0x7FFFFFFFFF 或 0xFFFFFFFFC0000000 ~ 0xFFFFFFFFFFFFFFFF
    return (va < (1ULL << 39)) || (va >= (uint64)(-1LL << 39));
}