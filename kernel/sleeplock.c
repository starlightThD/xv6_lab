#include "defs.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
}

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  if (lk->locked && lk->pid == myproc()->pid) {
    debug("[SLEEPLOCK ERROR] pid %d tries to recursively acquire lock '%s'\n", myproc()->pid, lk->name);
    release(&lk->lk);
    panic("acquiresleep: recursive lock");
  }
  while (lk->locked) {
    debug("[SLEEPLOCK] pid %d waiting for lock '%s'\n", myproc()->pid, lk->name);
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  debug("[SLEEPLOCK] pid %d acquired lock '%s'\n", myproc()->pid, lk->name);
  release(&lk->lk);
}

void
releasesleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  if (!lk->locked) {
    debug("[SLEEPLOCK ERROR] pid %d tries to release unused lock '%s'\n", myproc()->pid, lk->name);
    release(&lk->lk);
    panic("releasesleep: lock not held");
  }
  if (lk->pid != myproc()->pid) {
    debug("[SLEEPLOCK ERROR] pid %d tries to release lock '%s' held by pid %d\n", myproc()->pid, lk->name, lk->pid);
    release(&lk->lk);
    panic("releasesleep: not lock owner");
  }
  lk->locked = 0;
  lk->pid = 0;
  debug("[SLEEPLOCK] pid %d released lock '%s'\n", myproc()->pid, lk->name);
  wakeup(lk);
  release(&lk->lk);
}

int
holdingsleep(struct sleeplock *lk)
{
  int r;
  acquire(&lk->lk);
  r = lk->locked && (lk->pid == myproc()->pid);
  //debug("[SLEEPLOCK] pid %d holdingsleep '%s': %d\n", myproc()->pid, lk->name, r);
  release(&lk->lk);
  return r;
}