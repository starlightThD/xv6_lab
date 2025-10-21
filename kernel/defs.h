#include "types.h"
#include "memlayout.h"

struct trapframe {
  /*   0 */ uint64 kernel_satp;   // kernel page table
  /*   8 */ uint64 kernel_sp;     // top of process's kernel stack
  /*  16 */ uint64 kernel_trap;   // usertrap()
  /*  24 */ uint64 epc;           // saved user program counter
  /*  32 */ uint64 kernel_hartid; // saved kernel tp
  /*  40 */ uint64 ra;
  /*  48 */ uint64 sp;
  /*  56 */ uint64 gp;
  /*  64 */ uint64 tp;
  /*  72 */ uint64 t0;
  /*  80 */ uint64 t1;
  /*  88 */ uint64 t2;
  /*  96 */ uint64 s0;
  /* 104 */ uint64 s1;
  /* 112 */ uint64 a0;
  /* 120 */ uint64 a1;
  /* 128 */ uint64 a2;
  /* 136 */ uint64 a3;
  /* 144 */ uint64 a4;
  /* 152 */ uint64 a5;
  /* 160 */ uint64 a6;
  /* 168 */ uint64 a7;
  /* 176 */ uint64 s2;
  /* 184 */ uint64 s3;
  /* 192 */ uint64 s4;
  /* 200 */ uint64 s5;
  /* 208 */ uint64 s6;
  /* 216 */ uint64 s7;
  /* 224 */ uint64 s8;
  /* 232 */ uint64 s9;
  /* 240 */ uint64 s10;
  /* 248 */ uint64 s11;
  /* 256 */ uint64 t3;
  /* 264 */ uint64 t4;
  /* 272 */ uint64 t5;
  /* 280 */ uint64 t6;
};
// timer.h
#define TIMER_INTERVAL 1000000
void timeintr(void);

// uart.h
#define Reg(reg) ((volatile unsigned char *)(UART0 + (reg)))
#define INPUT_BUF_SIZE 128
// 寄存器定义
#define RHR 0      // 接收保持寄存器 (读取)
#define THR 0      // 发送保持寄存器 (写入)
#define IER 1      // 中断使能寄存器
#define FCR 2      // FIFO控制寄存器
#define LSR 5      // 线路状态寄存器

// 状态位定义
#define LSR_TX_IDLE (1<<5)     // 标记发送保持寄存器可以接受下一个字符
#define LSR_RX_READY (1<<0)    // 标记接收缓冲区有数据

// 中断使能位
#define IER_RX_ENABLE (1<<0)   // 接收中断使能
#define IER_TX_ENABLE (1<<1)   // 发送中断使能

// FIFO控制位
#define FCR_FIFO_ENABLE (1<<0) // FIFO使能
#define FCR_FIFO_CLEAR (3<<1)  // 清除FIFO

#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))

struct uart_input_buf_t{
	char buf[INPUT_BUF_SIZE];
	uint r;  // 读指针
	uint w;  // 写指针
	uint e;  // 编辑指针
};
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
// stdarg.h
// 使用 GCC 内建的可变参数支持
typedef __builtin_va_list va_list;
#define va_start(ap, last) __builtin_va_start(ap, last)
#define va_arg(ap, type) __builtin_va_arg(ap, type)
#define va_end(ap) __builtin_va_end(ap)


// sbi.h
#define SBI_SET_TIME 0x0
// 设置下次时钟中断时间
void sbi_set_time(uint64 time);

// 获取当前时间
uint64 sbi_get_time(void);

// plic.h
#define HART_ID 0

#define PLIC_ENABLE     (PLIC + 0x2080)  // hart 0 的S模式中断使能
#define PLIC_PRIORITY   (PLIC + 0x0)     // 中断优先级
#define PLIC_THRESHOLD  (PLIC + 0x201000) // hart 0 的S模式优先级阈值
#define PLIC_CLAIM      (PLIC + 0x201004) // hart 0 的S模式claim/complete

void plic_init(void);

void plic_enable(int irq);
void plic_disable(int irq);
int  plic_claim(void);
void plic_complete(int irq);

// start.h
struct CommandEntry{
    const char *name;
    void (*func)(void);
    const char *desc;
};
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
// 添加PTE标志定义
#define PTE_V (1L << 0) // 有效位
#define PTE_R (1L << 1) // 读权限
#define PTE_W (1L << 2) // 写权限
#define PTE_X (1L << 3) // 执行权限
#define PTE_U (1L << 4) // 用户模式可访问
#define PTE_FLAGS(pte) ((pte) & 0x3FF)

#define VPN_SHIFT(level) (12 + 9 * (level))
#define VPN_MASK(va, level) (((va) >> VPN_SHIFT(level)) & 0x1FF)
#define PA2PTE(pa) ((((uint64)(pa)) >> 12) << 10)
#define PTE2PA(pte) (((pte) >> 10) << 12)

#define SATP_MODE_SV39 (8L << 60)
#define MAKE_SATP(pgtbl) (SATP_MODE_SV39 | (((uint64)(pgtbl)) >> 12))

// 获取当前页表
pagetable_t get_current_pagetable(void);

// TLB操作
void sfence_vma(void);
// 基本操作接口
pagetable_t create_pagetable(void);
int map_page(pagetable_t pt, uint64 va, uint64 pa, int perm);
void free_pagetable(pagetable_t pt);
 
// 启动内核页表
void kvminit(void);
void kvminithart(void);
void check_mapping(uint64 va);
int check_is_mapped(uint64 va);

int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz);
// 测试接口
void test_pagetable(void);


// printf.h
#define ESC "\033"
#define CLEAR_SCREEN ESC "[2J"
#define CURSOR_HOME ESC "[H"
#define PRINTF_BUFFER_SIZE 128
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
void test_printf_precision(void);
void test_curse_move();
void test_basic_colors(void);

// trap.h
#define MAX_IRQ 64
struct trap_info {
    uint64 sepc;    // 保存在 tf->epc 中
    uint64 sstatus; // 需要单独保存
    uint64 scause;  // 需要单独保存
    uint64 stval;   // 需要单独保存
};

typedef  void (*interrupt_handler_t)(void);
extern interrupt_handler_t interrupt_vector[MAX_IRQ];

void register_interrupt(int irq, interrupt_handler_t h);
void unregister_interrupt(int irq);

void enable_interrupts(int irq);
void disable_interrupts(int irq);

void interrupt_dispatch(int irq);

uint64 get_time(void);
pagetable_t get_current_pagetable(void);
void sfence_vma(void);

void trap_init(void);
void kerneltrap(void);

void handle_exception(struct trapframe *tf, struct trap_info *info);
void handle_syscall(struct trapframe *tf, struct trap_info *info);
void handle_instruction_page_fault(struct trapframe *tf, struct trap_info *info);
void handle_load_page_fault(struct trapframe *tf, struct trap_info *info);
void handle_store_page_fault(struct trapframe *tf, struct trap_info *info);
int handle_page_fault(uint64 va, int type);

void test_timer_interrupt(void);
void test_exception(void);

// proc.h

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
extern void swtch(struct context *old, struct context *new);// !!! "swtch" instead of "switch"

struct cpu {
  struct proc *proc;          
  struct context context;   
};



enum procstate { UNUSED, USED, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };


// 进程结构体
struct proc {
  enum procstate state;    // 进程状态
  int pid;                 // 进程ID
  uint64 kstack;           // 内核栈虚拟地址
  struct context context;  // 切换上下文
  int killed;              // 是否被终止
  int exit_status;         // 退出状态
  char name[16];           // 进程名称
  struct proc *parent;     // 父进程
  void *chan;

  // 下面这些字段只对用户进程有意义
  int is_user;             // 是否是用户进程
  uint64 sz;               // 用户内存大小
  pagetable_t pagetable;   // 用户页表
  struct trapframe *trapframe; // 陷阱帧
};
struct proc* myproc(void);
struct cpu* mycpu(void);

void init_proc(void);
int create_proc(void (*entry)(void));
struct proc* alloc_proc(void);
void free_proc(struct proc *p);
void exit_proc(int status);
int wait_proc(int *status);

int kfork(void);
void kexit(void);
int kwait(int *status);

void return_to_user(void);
void forkret(void);

void schedule(void);

void yield(void);
void sleep(void *chan);
void wakeup(void *chan);

void print_proc_table(void);

void test_process_creation(void);
void test_scheduler(void);
void test_synchronization(void);

// riscv.h
// 常量定义
#define SSTATUS_SIE (1L << 1)  // Supervisor Interrupt Enable

// 读写SIE寄存器的函数
static inline uint64 r_sie() {
  uint64 x;
  asm volatile("csrr %0, sie" : "=r" (x));
  return x;
}

static inline void w_sie(uint64 x) {
  asm volatile("csrw sie, %0" : : "r" (x));
}
// 必须先声明读写sstatus的函数，因为intr_on和intr_off会用到它们
static inline uint64 r_sstatus() {
  uint64 x;
  asm volatile("csrr %0, sstatus" : "=r" (x));
  return x;
}
static inline void w_sstatus(uint64 x) {
  asm volatile("csrw sstatus, %0" : : "r" (x));
}


static inline void w_sepc(uint64 x) {
  asm volatile("csrw sepc, %0" : : "r"(x));
}
// 中断开关函数
static inline void intr_on() {
  w_sstatus(r_sstatus() | SSTATUS_SIE);
}

static inline void intr_off() {
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
}

// 其他寄存器操作函数
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

// 内存读写函数
static inline void write32(uint64 addr, uint32 val) {
    // 检查地址是否4字节对齐
    if ((addr & 0x3) == 0) { // 如果对齐
        // 使用volatile指针确保写入不被优化
        volatile uint32 *ptr = (volatile uint32 *)(addr);
        *ptr = val;
    } else { // 如果不对齐
        printf("ERROR: Misaligned write32 access: addr=%p\n", addr);
        // 不进行写入操作
    }
}

static inline uint32 read32(uint64 addr) {
    // 检查地址是否4字节对齐
    if ((addr & 0x3) == 0) { // 如果对齐
        // 使用volatile指针确保读取不被优化
        volatile uint32 *ptr = (volatile uint32 *)(addr);
        return *ptr;
    } else { // 如果不对齐
        printf("ERROR: Misaligned read32 access: addr=%p\n", addr);
        return 0; // 返回安全值
    }
}

// assert.h
static inline void assert(int expr) {
    if (!expr) {
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
        panic("assert");
    }
}