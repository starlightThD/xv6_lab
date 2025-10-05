#include "types.h"
#include "printf.h"

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