#ifndef _PMMANAGER_H_
#define _PMMANAGER_H_

#define PGSIZE 4096
void pmm_init(void);
void* alloc_page(void);
void free_page(void* page);

void test_physical_memory(void);
#endif