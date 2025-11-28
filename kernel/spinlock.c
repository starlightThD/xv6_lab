#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
  lk->locked = 0;
}

// Acquire the lock.
void
acquire(struct spinlock *lk)
{
  intr_off(); // 直接关闭中断
  if(lk->locked)
    panic("acquire");
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    ;
  __sync_synchronize();
}

// Release the lock.
void
release(struct spinlock *lk)
{
  if(!lk->locked)
    panic("release");
  __sync_synchronize();
  __sync_lock_release(&lk->locked);
  intr_on(); // 直接开启中断
}

int
holding(struct spinlock *lk)
{
  return lk->locked;
}