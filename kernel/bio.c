#include "defs.h"

__attribute__((section(".bcache"))) // Bcache莫名被篡改，怀疑是内存管理错误，单独为其分配空间
static struct Bcache bcache;

static void print_bcache_list(char* msg) {
    struct buf *b = bcache.head.next;
    int count = 0;
    debug("bcache list when %s\n",msg);
    while (b != &bcache.head && count < NBUF) {
        debug("  buf[%d]: %p prev=%p next=%p\n", count, b, b->prev, b->next);
        b = b->next;
        count++;
    }
    debug("  head: %p prev=%p next=%p\n", &bcache.head, bcache.head.prev, bcache.head.next);
}
void
binit(void)
{
  struct buf *b;

  initlock(&bcache.lock, "bcache");

  // 初始化头结点为自环
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  // 将所有缓冲块插入到头结点之后（形成双向循环链表）
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  print_bcache_list("init"); // 打印链表状态
  printf("binit done\n");
}
static struct buf*
bget(uint dev, uint blockno)
{
	print_bcache_list("bget begin");
  struct buf *b;

  acquire(&bcache.lock);
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    if (b->dev == dev && b->blockno == blockno) {
	  printf("bget1: b=%p\n", b);
      b->refcnt++;
      release(&bcache.lock);
      acquiresleep(&b->lock);
	  print_bcache_list("bget1"); // 打印链表状态
      return b;
    }
  }

  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
	printf("bget2: b=%p\n", b);
    if (b->refcnt == 0) {
      b->dev = dev;
      b->blockno = blockno;
      b->valid = 0;
      b->refcnt = 1;
      release(&bcache.lock);
      acquiresleep(&b->lock);
	  print_bcache_list("bget2"); // 打印链表状态
      return b;
    }
  }
  panic("bget: no buffers");
  return 0;
}
struct buf*
bread(uint dev, uint blockno)
{
    print_bcache_list("bread begin");
    struct buf *b = bget(dev, blockno);
    if(!b->valid) {
        virtio_disk_rw(b, 0);
        b->valid = 1;
    }
    print_bcache_list("bread end");
    return b;
}

void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite without lock");
  virtio_disk_rw(b, 1);
  print_bcache_list("bwrite"); // 打印链表状态
}

void brelse(struct buf *b)
{
    print_bcache_list("brelse begin"); // 打印链表状态
  if (!holdingsleep(&b->lock))
    panic("brelse without lock");

  releasesleep(&b->lock);
  acquire(&bcache.lock);
    intr_off();
  b->refcnt--;
  if (b->refcnt <= 0) {
    // 先确认操作前的状态
    debug("before relse: b=%p b->prev=%p b->next=%p\n", b,b->prev,b->next);
    debug("before relse: bcache.head=%p next=%p\n", &bcache.head,bcache.head.next);
    
    // 检查是否已经在链表头部
    if (b->prev == &bcache.head) {
        printf("brelse: buffer already at head, skip move\n");
    } else {
        // 从当前位置摘除
        b->next->prev = b->prev;
        b->prev->next = b->next;
        // 插入到链表头（bcache.head 之后）
        b->next = bcache.head.next;
        b->prev = &bcache.head;
        bcache.head.next->prev = b;
        bcache.head.next = b;
    }
    debug("after relse: b=%p b->prev=%p b->next=%p\n", b,b->prev,b->next);
    debug("after relse: bcache.head=%p next=%p\n", &bcache.head,bcache.head.next);
  }else{
	debug("b->refcnt > 0 so no brelse\n");
  }
    print_bcache_list("brelse end"); // 打印链表状态
  intr_on();
  release(&bcache.lock);
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