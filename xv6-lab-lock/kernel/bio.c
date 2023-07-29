// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.

#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"

#define NBUCKET 13 // 哈希桶上限，按理来说只有需要二次哈希时才考虑素数个桶
#define INTMAX 0x7fffffff

// 哈希函数
int hash(uint dev, uint blockno)
{
    return ((blockno) % NBUCKET);
}

struct {
    struct spinlock lock;
    struct buf buf[NBUF];

    // 维护NBUCKET个桶，每个桶维护一个链表
    // 每个桶都有一个自己的锁，用于保护自己的链表
    // 而每个桶中存储的元素buf作为缓冲区存在自己的锁
    struct buf bucket[NBUCKET];
    struct spinlock bucket_locks[NBUCKET];
} bcache;

void binit(void)
{
    initlock(&bcache.lock, "bcache_lock");

    // 初始化bucket
    char name[32];
    for (int i = 0; i < NBUCKET; i++) {
        snprintf(name, 32, "bucket_lock_%d", i);
        initlock(&bcache.bucket_locks[i], name);
        bcache.bucket[i].next = 0;
    }

    // 初始化buffer
    for (int i = 0; i < NBUF; i++) {
        struct buf *b = &bcache.buf[i]; // 链表头指针
        initsleeplock(&b->lock, "buffer");

        b->LUtime = 0;
        b->refcnt = 0;
        b->curBucket = 0;

        // 将buffer加入到bucket[0]中
        b->next = bcache.bucket[0].next;
        bcache.bucket[0].next = b;
    }
}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf *bget(uint dev, uint blockno)
{

    uint index = hash(dev, blockno);

    acquire(&bcache.bucket_locks[index]);
    struct buf *b = bcache.bucket[index].next;

    // 在当前bucket[index]中查找
    while (b) {
        if (b->dev == dev && b->blockno == blockno) {
            // 已找到
            b->refcnt++;
            release(&bcache.bucket_locks[index]);
            acquiresleep(&b->lock);
            return b;
        }
        b = b->next;
    }

    // 未找到，需要从其他bucket中查找
    // 占有bucket_lock时, 再获取其他bucket锁是不安全的, 同时占有多个bucket锁
    // 容易导致循环等待造成死锁，故先释放当前bucket锁
    release(&bcache.bucket_locks[index]);

    // 因其他进程可能使用使用该块，因此要检查一遍该block是否已经在其他bucket中
    // 如果已经在其他bucket中，则等待获取sleeplock再返回即可
    acquire(&bcache.lock);
    b = bcache.bucket[index].next;
    while (b) {
        if (b->dev == dev && b->blockno == blockno) {
            // 已被其他进程放入其他bucket中
            acquire(&bcache.bucket_locks[index]);
            b->refcnt++;
            release(&bcache.bucket_locks[index]);
            release(&bcache.lock); // 释放bcache锁

            // 重新获取该block的锁，睡眠等待即可，等待完毕便可返回
            acquiresleep(&b->lock);
            return b;
        }
        b = b->next;
    }

    // 若还未找到，需要依据LRU从其他bucket中查找
    // 在当前bucket[index]中查找空闲缓冲区或者最近最少使用的缓冲区
    struct buf *LRUb = 0;
    uint curBucket = -1;
    uint LUtime = INTMAX;

    for (int i = 0; i < NBUCKET; i++) {
        acquire(&bcache.bucket_locks[i]);

        b = &bcache.bucket[i];
        int found = 0;

        while (b->next) {
            if (b->next->refcnt == 0 && LRUb == 0) {
                // 如果找到空闲缓冲区且之前还没有找到过空闲缓冲区
                LRUb = b;
                LUtime = b->next->LUtime;
                found = 1;
            }
            else if (b->next->refcnt == 0 && b->next->LUtime < LUtime) {
                // 如果找到空闲缓冲区，且该缓冲区上次使用时间更早
                LRUb = b;
                LUtime = b->next->LUtime;
                found = 1;
            }
            b = b->next;
        }
        if (found) {
            // 更新了LRUb，要释放这个桶之前的bucket锁
            if (curBucket != -1) {
                // 释放之前的bucket锁
                release(&bcache.bucket_locks[curBucket]);
            }
            curBucket = i;
        }
        else {
            // 没找到，释放访问的桶
            release(&bcache.bucket_locks[i]);
        }
    }
    if (LRUb == 0) { // 最终都没有找到一个buffer
        panic("bget: No buffer.");
    }
    else {
        struct buf *p = LRUb->next;

        if (curBucket != index) {
            // 删除LRUb节点
            LRUb->next = p->next;
            release(&bcache.bucket_locks[curBucket]);

            // 将LRUb节点放入当前bucket[index]中
            acquire(&bcache.bucket_locks[index]);
            p->next = bcache.bucket[index].next;
            bcache.bucket[index].next = p;
        }

        // 更新LRUb的信息
        p->dev = dev;
        p->blockno = blockno;
        p->refcnt = 1;
        p->valid = 0;
        p->curBucket = index;

        release(&bcache.bucket_locks[index]); // 释放bucket[index]锁
        release(&bcache.lock);                // 释放bcache锁
        acquiresleep(&p->lock);               // 获取LRUb的锁
        return p;
    }
}

// Return a locked buf with the contents of the indicated block.
struct buf *bread(uint dev, uint blockno)
{
    struct buf *b;

    b = bget(dev, blockno);
    if (!b->valid) {
        virtio_disk_rw(b, 0);
        b->valid = 1;
    }
    return b;
}

// Write b's contents to disk.  Must be locked.
void bwrite(struct buf *b)
{
    if (!holdingsleep(&b->lock))
        panic("bwrite");
    virtio_disk_rw(b, 1);
}

// Release a locked buffer.
void brelse(struct buf *b)
{
    if (!holdingsleep(&b->lock))
        panic("brelse");

    releasesleep(&b->lock);

    uint index = hash(b->dev, b->blockno);
    acquire(&bcache.bucket_locks[index]);
    b->refcnt--;
    if (b->refcnt == 0) {
        //没有进程引用这块buffer, 则为空闲状态释放，记录最近使用时间
        b->LUtime = ticks;
    }
    release(&bcache.bucket_locks[index]);
}

void bpin(struct buf *b)
{

    uint index = hash(b->dev, b->blockno);
    acquire(&bcache.bucket_locks[index]);
    b->refcnt++;
    release(&bcache.bucket_locks[index]);
}

void bunpin(struct buf *b)
{

    uint index = hash(b->dev, b->blockno);
    acquire(&bcache.bucket_locks[index]);
    b->refcnt--;
    release(&bcache.bucket_locks[index]);
}