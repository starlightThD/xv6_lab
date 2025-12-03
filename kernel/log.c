#include "defs.h"
struct log log;
static void commit(void); // 在文件开头加上声明

void initlog(int dev, struct superblock *sb)
{
	if (sizeof(struct logheader) >= BSIZE)
		panic("initlog: too big logheader");
	initlock(&log.lock, "log");
	log.start = sb->logstart;
	log.dev = dev;
	recover_from_log();
	printf("log init done\n");
}

static void install_trans(int recovering)
{
    int tail;

    for (tail = 0; tail < log.lh.n; tail++)
    {
        struct buf *lbuf = bread(log.dev, log.start + tail + 1); // log block
        struct buf *dbuf = bread(log.dev, log.lh.block[tail]);   // dest block
        
        if (recovering) {
            printf("recovering block %d from log position %d\n", 
                   log.lh.block[tail], tail);
        }
        
        // 将日志中的数据复制到目标位置
        memmove(dbuf->data, lbuf->data, BSIZE);
        bwrite(dbuf);  // 立即写入磁盘
        
        if (recovering == 0)
            bunpin(dbuf);
            
        brelse(lbuf);
        brelse(dbuf);
    }
}
static void
read_head(void)
{
	struct buf *buf = bread(log.dev, log.start);
	struct logheader *lh = (struct logheader *)(buf->data);
	int i;
	log.lh.n = lh->n;
	for (i = 0; i < log.lh.n; i++)
	{
		log.lh.block[i] = lh->block[i];
	}
	brelse(buf);
}

static void
write_head(void)
{
	struct buf *buf = bread(log.dev, log.start);
	struct logheader *hb = (struct logheader *)(buf->data);
	int i;
	hb->n = log.lh.n;
	for (i = 0; i < log.lh.n; i++)
	{
		hb->block[i] = log.lh.block[i];
	}
	bwrite(buf);
	brelse(buf);
}

void recover_from_log(void)
{
	read_head();
	install_trans(1); // if committed, copy from log to disk
	log.lh.n = 0;
	write_head(); // clear the log
}
void begin_op(void)
{
	acquire(&log.lock);
	while (1)
	{
		if (log.committing)
		{
			sleep(&log, &log.lock);
		}
		else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS)
		{
			sleep(&log, &log.lock);
		}
		else
		{
			log.outstanding += 1;
			release(&log.lock);
			break;
		}
	}
}

void end_op(void)
{
	int do_commit = 0;
	acquire(&log.lock);
    log.outstanding -= 1;
	if (log.committing)
		panic("log.committing");
	if (log.outstanding == 0)
	{
		do_commit = 1;
		log.committing = 1;
	}
	else
	{
		wakeup(&log);
	}
	release(&log.lock);

	if (do_commit)
	{
		commit();
		acquire(&log.lock);
		log.committing = 0;
		wakeup(&log);
		release(&log.lock);
	}
}
static void write_log(void)
{
    int tail;
    for (tail = 0; tail < log.lh.n; tail++)
    {
        uint blockno = log.lh.block[tail];
        struct buf *to = bread(log.dev, log.start + tail + 1);
        struct buf *from = bread(log.dev, blockno);
		if (!to || !from) {
            panic("write_log: bread failed");
        }
        memset(to->data, 0, BSIZE);
        memmove(to->data, from->data, BSIZE);
        bwrite(to); 
        brelse(from);
        brelse(to);
    }
}
static void
commit()
{
	if (log.lh.n > 0)
	{
		write_log();	  // Write modified blocks from cache to log
		write_head();	  // Write header to disk -- the real commit
		install_trans(0); // Now install writes to home locations
		log.lh.n = 0;
		write_head(); // Erase the transaction from the log
	}
}
void log_write(struct buf *b)
{
    int i;
    acquire(&log.lock);
    if (log.lh.n >= LOGBLOCKS) {
        panic("too big a transaction");
    }
    
    if (log.outstanding < 1) {
        panic("log_write outside of trans");
    }
    
    // 查找是否已有该块（log absorption）
    for (i = 0; i < log.lh.n; i++) {
        if (log.lh.block[i] == b->blockno) {
            break;
        }
    }
    
    // 如果没有找到，且有空间，则添加新块
    if (i == log.lh.n) {
        log.lh.block[i] = b->blockno;
        bpin(b);
        log.lh.n++;
    }
    
    release(&log.lock);
}

void force_commit_log(void) {
    acquire(&log.lock);
    
    printf("强制提交日志系统...\n");
    printf("当前状态: outstanding=%d, committing=%d\n", 
           log.outstanding, log.committing);
    
    // 如果有未完成的事务，强制完成它们
    while (log.outstanding > 0) {
        printf("等待未完成事务: %d\n", log.outstanding);
        
        // 如果当前没有在提交中，启动提交
        if (!log.committing) {
            log.committing = 1;
            release(&log.lock);
            
            // 执行提交过程
            commit();
            
            acquire(&log.lock);
            log.committing = 0;
            
            // 唤醒可能等待的进程
            wakeup(&log);
        } else {
            // 如果正在提交中，等待完成
            printf("等待当前提交完成...\n");
            release(&log.lock);
            // 简单延时等待
            for (volatile int i = 0; i < 1000000; i++);
            acquire(&log.lock);
        }
    }
    
    printf("所有日志事务已完成\n");
    release(&log.lock);
}

// 获取日志系统状态的函数
void get_log_status(int *outstanding, int *committing) {
    acquire(&log.lock);
    if (outstanding) *outstanding = log.outstanding;
    if (committing) *committing = log.committing;
    release(&log.lock);
}