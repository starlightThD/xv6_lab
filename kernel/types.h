#ifndef _TYPES_H
#define _TYPES_H

typedef unsigned int   uint;
typedef unsigned short ushort;
typedef unsigned char  uchar;

typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int  uint32;
typedef unsigned long uint64;
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long uint64_t;
typedef unsigned long size_t;

typedef unsigned long uintptr_t;

typedef uint64 pde_t;
// 页表类型定义
typedef uint64 pte_t;
typedef uint64* pagetable_t;
// NULL 定义
#ifndef NULL
#define NULL ((void*)0)
#endif
#endif // _TYPES_H