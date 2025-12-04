#include "defs.h"

#define major(dev) ((dev) >> 16 & 0xFFFF)
#define minor(dev) ((dev) & 0xFFFF)
#define mkdev(m, n) ((uint)((m) << 16 | (n)))
// map major device number to device functions.
extern struct devsw devsw[];
struct devsw devsw[NDEV];
struct
{
	struct spinlock lock;
	struct file file[NFILE];
} ftable;

void fileinit(void)
{
	initlock(&ftable.lock, "ftable");
	printf("ftable_lock init done \n");
}

// Allocate a file structure.
struct file *
filealloc(void)
{
	struct file *f;
	acquire(&ftable.lock);
	for (f = ftable.file; f < ftable.file + NFILE; f++)
	{
		if (f->ref == 0)
		{
			f->ref = 1;
			release(&ftable.lock);
			return f;
		}
	}
	release(&ftable.lock);
	return 0;
}

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
	acquire(&ftable.lock);
	if (f->ref < 1)
		panic("filedup");
	f->ref++;
	release(&ftable.lock);
	return f;
}
static struct file *fileopen(struct inode *ip, int readable, int writable)
{
	struct file *f = filealloc();
	if (f == 0)
		return 0;
	f->type = FD_INODE;
	f->ip = idup(ip);
	f->readable = readable;
	f->writable = writable;
	f->off = 0;
	return f;
}

// Close file f.  (Decrement ref count, close when reaches 0.)
static void fileclose(struct file *f)
{
	struct file ff;

	acquire(&ftable.lock);
	if (f->ref < 1)
		panic("fileclose");
	if (--f->ref > 0)
	{
		release(&ftable.lock);
		return;
	}
	ff = *f;
	f->ref = 0;
	f->type = FD_NONE;
	release(&ftable.lock);

	if (ff.type == FD_PIPE)
	{
		pipeclose(ff.pipe, ff.writable);
	}
	else if (ff.type == FD_INODE || ff.type == FD_DEVICE)
	{
		iput(ff.ip);
	}
}

//// Get metadata about file f.
//// addr is a user virtual address, pointing to a struct stat.
//static int filestat(struct file *f, uint64 addr)
//{
//	struct proc *p = myproc();
//	struct stat st;

//	if (f->type == FD_INODE || f->type == FD_DEVICE)
//	{
//		ilock(f->ip);
//		stati(f->ip, &st);
//		iunlock(f->ip);
//		if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
//			return -1;
//		return 0;
//	}
//	return -1;
//}
// 加锁文件（对 inode 加锁）
static void filelock(struct file *f) {
    if (f->type == FD_INODE || f->type == FD_DEVICE) {
        ilock(f->ip);
    }
}

// 解锁文件（对 inode 解锁）
static void fileunlock(struct file *f) {
    if (f->type == FD_INODE || f->type == FD_DEVICE) {
        iunlock(f->ip);
    }
}
static int fileread(struct file *f, uint64 addr, int n)
{
    int r = 0;

    if (f->readable == 0)
        return -1;

    if (f->type == FD_PIPE)
    {
        r = piperead(f->pipe, addr, n);
    }
    else if (f->type == FD_DEVICE)
    {
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
            return -1;
        r = devsw[f->major].read(1, addr, n);
    }
    else if (f->type == FD_INODE)
    {
        if (!holdingsleep(&f->ip->lock)) {
            warning("fileread: pid %d must hold inode lock before reading\n", myproc()->pid);
            return -1;
        }
        if ((r = readi(f->ip, 0, addr, f->off, n)) > 0)
            f->off += r;
    }
    else
    {
        panic("fileread");
    }

    return r;
}

static int filewrite(struct file *f, uint64 addr, int n)
{
    int r, ret = 0;

    if (f->writable == 0)
        return -1;

    if (f->type == FD_PIPE)
    {
        ret = pipewrite(f->pipe, addr, n);
    }
    else if (f->type == FD_DEVICE)
    {
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
            return -1;
        ret = devsw[f->major].write(1, addr, n);
    }
    else if (f->type == FD_INODE)
    {
        if (!holdingsleep(&f->ip->lock)) {
            warning("filewrite: pid %d must hold inode lock before writing\n", myproc()->pid);
            return -1;
        }
        int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
        int i = 0;
        while (i < n)
        {
            int n1 = n - i;
            if (n1 > max)
                n1 = max;

            if ((r = writei(f->ip, 0, addr + i, f->off, n1)) > 0)
                f->off += r;

            if (r != n1)
            {
                // error from writei
                break;
            }
            i += r;
        }
        ret = (i == n ? n : -1);
    }
    else
    {
        panic("filewrite");
    }

    return ret;
}

struct file *open(struct inode *ip, int readable, int writable) {
    begin_op();
    struct file *f = fileopen(ip, readable, writable);
    end_op();
    return f;
}

void close(struct file *f) {
    begin_op();
    fileclose(f);
    end_op();
}
int read(struct file *f, uint64 addr, int n) {
    int ret;
    begin_op();
    filelock(f);
    ret = fileread(f, addr, n);
    fileunlock(f);
    end_op();
    return ret;
}

int write(struct file *f, uint64 addr, int n) {
    int ret;
    begin_op();
    filelock(f);
    ret = filewrite(f, addr, n);
    fileunlock(f);
    end_op();
    return ret;
}
// 为当前进程分配一个文件描述符
static int fdalloc(struct file *f)
{
    struct proc *p = myproc();
    
    for (int fd = 3; fd < NOFILE; fd++) {
        if (p->ofile[fd] == 0) {
            p->ofile[fd] = f;
            return fd;
        }
    }
    return -1;
}

// 根据文件描述符获取文件结构
static struct file *fdget(int fd)
{
    struct proc *p = myproc();
    
    if (fd < 0 || fd >= NOFILE || p->ofile[fd] == 0) {
        return 0;
    }
    return p->ofile[fd];
}

// 系统调用：打开文件
int ker_open(char *path, int omode, int mode)
{
    struct inode *ip;
    struct file *f;
    int fd;

    debug("[ker_open] path=%s, mode=%d\n", path, omode);

    if (omode & O_CREATE) {
        // 创建新文件
        ip = create(path, T_FILE, 0, 0);
        if (ip == 0) {
            return -1;
        }
    } else {
        // 打开已存在的文件
        ip = namei(path);
        if (ip == 0) {
            return -1;
        }
        ilock(ip);
        if (ip->type == T_DIR && omode != O_RDONLY) {
            iunlockput(ip);
            return -1;
        }
    }

    // 创建文件结构
    int readable = !(omode & O_WRONLY);
    int writable = (omode & O_WRONLY) || (omode & O_RDWR);
    
    f = open(ip, readable, writable);
    if (f == 0) {
        if (ip->ref == 1) {
            iunlockput(ip);
        } else {
            iunlock(ip);
            iput(ip);
        }
        return -1;
    }

    // 分配文件描述符
    fd = fdalloc(f);
    if (fd < 0) {
        close(f);
        return -1;
    }

    if (!(omode & O_CREATE)) {
        iunlock(ip);
    }

    debug("[ker_open] success, fd=%d, inum=%d\n", fd, ip->inum);
    return fd;
}

// 系统调用：关闭文件
int ker_close(int fd)
{
    struct file *f;
    struct proc *p = myproc();

    f = fdget(fd);
    if (f == 0) {
        return -1;
    }

    p->ofile[fd] = 0;
    close(f);
    
    debug("[ker_close] fd=%d closed\n", fd);
    return 0;
}

// 系统调用：读取文件
int ker_read(int fd, uint64 addr, int n)
{
    struct file *f;
    char kbuf[256];
    int bytes_read = 0;
    int total_read = 0;

    f = fdget(fd);
    if (f == 0) {
        return -1;
    }

    while (total_read < n) {
        int to_read = n - total_read;
        if (to_read > sizeof(kbuf)) {
            to_read = sizeof(kbuf);
        }

        bytes_read = read(f, (uint64)kbuf, to_read);
        if (bytes_read <= 0) {
            break;
        }

        // 将数据复制到用户空间
        if (copyout(myproc()->pagetable, addr + total_read, kbuf, bytes_read) < 0) {
            return -1;
        }

        total_read += bytes_read;
        
        // 如果读取的字节数少于请求的，说明到达文件末尾
        if (bytes_read < to_read) {
            break;
        }
    }

    debug("[ker_read] fd=%d, read %d bytes\n", fd, total_read);
    return total_read;
}

// 系统调用：写入文件
int ker_write(int fd, uint64 addr, int n)
{
    struct file *f;
    char kbuf[256];
    int bytes_written = 0;
    int total_written = 0;

    f = fdget(fd);
    if (f == 0) {
        return -1;
    }

    while (total_written < n) {
        int to_write = n - total_written;
        if (to_write > sizeof(kbuf)) {
            to_write = sizeof(kbuf);
        }

        // 从用户空间复制数据
        if (copyin(kbuf, addr + total_written, to_write) < 0) {
            return -1;
        }

        bytes_written = write(f, (uint64)kbuf, to_write);
        if (bytes_written <= 0) {
            break;
        }

        total_written += bytes_written;
        
        // 如果写入的字节数少于请求的，说明出现错误
        if (bytes_written < to_write) {
            break;
        }
    }

    debug("[ker_write] fd=%d, wrote %d bytes\n", fd, total_written);
    return total_written;
}
int ker_unlink(char *path)
{
    debug("[ker_unlink] path=%s\n", path);
    
    // 调用现有的 unlink 函数
    int result = unlink(path);
    
    debug("[ker_unlink] result=%d\n", result);
    return result;
}