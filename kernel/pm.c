#include "pm.h"
#include "memlayout.h"
#include "types.h"
#include "printf.h"
#include "mem.h"
#include "assert.h"

struct run {
  struct run *next;
};

static struct run *freelist = 0;
//static int free_page_num = 0;

// 统计空闲页数量
int  get_free_page_count() {
	struct run *r = freelist;
	int count = 0;
	while (r) {
		count++;
		r = r->next;
	}
	return count;
}
extern char end[];

static void freerange(void *pa_start, void *pa_end) {
  char *p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    free_page(p);
  }
}

void pmm_init(void) {
  freerange(end, (void*)PHYSTOP);
}

void* alloc_page(void) {
  struct run *r = freelist;
  if(r)
    freelist = r->next;
  if(r)
    memset((char*)r + sizeof(struct run), 5, PGSIZE - sizeof(struct run));
  else
    panic("alloc_page: out of memory");
  return (void*)r;
}

void free_page(void* page) {
  struct run *r = (struct run*)page;
  if(((uint64)page % PGSIZE) != 0 || (char*)page < end || (uint64)page >= PHYSTOP)
    panic("free_page: invalid page address");

//  // 检查页面是否已经在空闲链表中
//  struct run *current = freelist;
//  while(current) {
//    if(current == r)
//      panic("free_page: double free");
//    current = current->next;
//  }
  r->next = freelist;
  freelist = r;
}

void test_physical_memory(void) {
	printf("%d \n",get_free_page_count());
    printf("[PM TEST] 分配两个页...\n");
    void *page1 = alloc_page();
    void *page2 = alloc_page();
    assert(page1 != 0);
    assert(page2 != 0);
    assert(page1 != page2);
    assert(((uint64)page1 & 0xFFF) == 0);
    assert(((uint64)page2 & 0xFFF) == 0);
	printf("%d \n",get_free_page_count());
    printf("[PM TEST] 分配测试通过\n");

    printf("[PM TEST] 数据写入测试...\n");
    *(int*)page1 = 0x12345678;
    assert(*(int*)page1 == 0x12345678);
    printf("[PM TEST] 数据写入测试通过\n");

    printf("[PM TEST] 释放与重新分配测试...\n");
    free_page(page1);
	printf("%d \n",get_free_page_count());
    void *page3 = alloc_page();
	printf("%d \n",get_free_page_count());
    assert(page3 != 0);
    printf("[PM TEST] 释放与重新分配测试通过\n");

    free_page(page2);
    free_page(page3);
	printf("%d \n",get_free_page_count());
	//free_page(page3);
	//void *page[10];
	//for(int i=0;i<10;i++){
	//	page[i]=alloc_page();
	//	for(int j=0;j<i;j++){
	//		assert(page[i]!=page[j]);
	//	}
	//}

    printf("[PM TEST] 所有物理内存管理测试通过\n");
}