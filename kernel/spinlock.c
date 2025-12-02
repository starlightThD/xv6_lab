#include "defs.h"

void initlock(struct spinlock *lk, char *name)
{
	lk->name = name;
	lk->locked = 0;
	lk->pid = -1;
}

// Acquire the lock.
void acquire(struct spinlock *lk)
{
	if (lk->locked)
	{
		warning("lock name address: %p, value: %s\n", lk->name, lk->name);
		warning("proc %d acquire lock %s but forbid by proc %d \n", myproc()->pid, lk->name, lk->pid);
	}
	while (__sync_lock_test_and_set(&lk->locked, 1) != 0) ;
	lk->pid = myproc()->pid;
	__sync_synchronize();
}

// Release the lock.
void release(struct spinlock *lk)
{
	if (!lk->locked)
	{
		warning("proc %d want release lock %s but it is unused\n", myproc()->pid, lk->name);
		return;
	}
	__sync_synchronize();
	__sync_lock_release(&lk->locked);
	// debug("proc %d release lock %s\n",lk->pid,lk->name);
	lk->pid = -1;
}

int holding(struct spinlock *lk)
{
	return lk->locked;
}