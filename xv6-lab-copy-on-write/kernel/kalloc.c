// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
    struct run *next;
};

struct {
    struct spinlock lock;
    struct run *freelist;
} kmem;

struct refcnt {
    struct spinlock lock;
    int PGCount[PHYSTOP / PGSIZE]; // (最大页数 = 地址空间大小/页大小)
} PGRefCount;

void kinit()
{
    initlock(&kmem.lock, "kmem");
    initlock(&PGRefCount.lock, "PGRefCount"); // 初始化PGRefCount锁
    freerange(end, (void *)PHYSTOP);
}

void freerange(void *pa_start, void *pa_end)
{
    char *p;
    p = (char *)PGROUNDUP((uint64)pa_start);
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE) {
        // 对于所有页的count值设为1; 后续在kfree中减为0, 可以正常进行释放
        PGRefCount.PGCount[(uint64)p / PGSIZE] = 1;
        kfree(p);
    }
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    struct run *r;

    if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
        panic("kfree");

    acquire(&PGRefCount.lock);
    PGRefCount.PGCount[(uint64)pa / PGSIZE]--;

    if (PGRefCount.PGCount[(uint64)pa / PGSIZE] != 0) {
        release(&PGRefCount.lock);
        return;
    }
    release(&PGRefCount.lock);

    // Fill with junk to catch dangling refs.
    memset(pa, 1, PGSIZE);

    r = (struct run *)pa;

    acquire(&kmem.lock);
    r->next = kmem.freelist;
    kmem.freelist = r;
    release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc(void)
{
    struct run *r;

    acquire(&kmem.lock);
    r = kmem.freelist;
    if (r)
        kmem.freelist = r->next;
    release(&kmem.lock);

    // pgcount初值赋为1
    if (r) {
        acquire(&PGRefCount.lock);
        PGRefCount.PGCount[(uint64)r / PGSIZE] = 1;
        release(&PGRefCount.lock);
    }

    if (r)
        memset((char *)r, 5, PGSIZE); // fill with junk
    return (void *)r;
}

int AddPGRefCount(void *pa)
{
    if (((uint64)pa % PGSIZE)) {
        return -1;
    }
    if ((char *)pa < end || (uint64)pa >= PHYSTOP) {
        return -1;
    }
    acquire(&PGRefCount.lock);
    PGRefCount.PGCount[(uint64)pa / PGSIZE]++;
    release(&PGRefCount.lock);
    return 0;
}

int GetPGRefCount(void *pa)
{
    return PGRefCount.PGCount[(uint64)pa / PGSIZE];
}
