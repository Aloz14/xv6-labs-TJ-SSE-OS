#include "types.h"
#include "riscv.h"
#include "param.h"
#include "defs.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64 sys_exit(void)
{
    int n;
    argint(0, &n);
    exit(n);
    return 0; // not reached
}

uint64 sys_getpid(void)
{
    return myproc()->pid;
}

uint64 sys_fork(void)
{
    return fork();
}

uint64 sys_wait(void)
{
    uint64 p;
    argaddr(0, &p);
    return wait(p);
}

uint64 sys_sbrk(void)
{
    uint64 addr;
    int n;

    argint(0, &n);
    addr = myproc()->sz;
    if (growproc(n) < 0)
        return -1;
    return addr;
}

uint64 sys_sleep(void)
{
    int n;
    uint ticks0;

    argint(0, &n);
    acquire(&tickslock);
    ticks0 = ticks;
    while (ticks - ticks0 < n) {
        if (killed(myproc())) {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    }
    release(&tickslock);
    return 0;
}

#ifdef LAB_PGTBL
#define PGACCESS_MAX_PAGE 32
int sys_pgaccess(void)
{
    // lab pgtbl: your code here.
    uint64 va, buf;
    int pgnum;
    argaddr(0, &va);
    argint(1, &pgnum);
    argaddr(2, &buf);

    if (pgnum > PGACCESS_MAX_PAGE)
        pgnum = PGACCESS_MAX_PAGE;

    struct proc *p = myproc();
    if (!p) {
        return -1;
    }

    pagetable_t pgtbl = p->pagetable;
    if (!pgtbl) {
        return -1;
    }

    uint64 mask = 0;
    for (int i = 0; i < pgnum; i++) {
        pte_t *pte = walk(pgtbl, va + i * PGSIZE, 0);
        if (*pte & PTE_A) {
            *pte &= (~PTE_A); // 复位
            mask |= (1 << i); // 标注第i个页是否被访问过
        }
    }

    copyout(p->pagetable, buf, (char *)&mask, sizeof(mask));

    return 0;
}
#endif

uint64 sys_kill(void)
{
    int pid;

    argint(0, &pid);
    return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void)
{
    uint xticks;

    acquire(&tickslock);
    xticks = ticks;
    release(&tickslock);
    return xticks;
}
