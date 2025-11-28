#include "defs.h"

struct Bcache bcache;

void print_buf_chain();
void
binit(void)
{
  struct buf *b;

  initlock(&bcache.lock, "bcache");
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
	initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}

static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;
  acquire(&bcache.lock); // 加锁
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    if(b->dev == dev && b->blockno == blockno){
      b->refcnt++;
	  release(&bcache.lock); // 解锁
      acquiresleep(&b->lock);
      return b;
    }
  }
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    if(b->refcnt == 0) {
      b->dev = dev;
      b->blockno = blockno;
      b->valid = 0;
      b->refcnt = 1;
	  release(&bcache.lock); // 解锁
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
  return 0;
}
// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}

void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite without lock");
  virtio_disk_rw(b, 1);
}

void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse without lock");
  releasesleep(&b->lock);
  acquire(&bcache.lock); // 加锁
  b->refcnt--;
  if (b->refcnt == 0) {
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  release(&bcache.lock); // 解锁;
}

void
bpin(struct buf *b) {
  acquire(&bcache.lock);
  b->refcnt++;
  release(&bcache.lock);
}

void
bunpin(struct buf *b) {
  acquire(&bcache.lock);
  b->refcnt--;
  release(&bcache.lock);
}
void print_buf_chain() {
  struct buf *b;
  int cnt = 0;
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    printf("[bufchain] #%d: buf at %p, next=%p, prev=%p, refcnt=%d, dev=%u, blockno=%u\n",
      cnt++, b, b->next, b->prev, b->refcnt, b->dev, b->blockno);
    assert(b != NULL);
    assert((uintptr_t)b > 0x1000 && (uintptr_t)b < 0xFFFFFFFFFFFF);
    assert(b->prev != NULL);
    assert(b->next != NULL);
  }
}