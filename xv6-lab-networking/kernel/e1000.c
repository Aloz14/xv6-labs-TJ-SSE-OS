#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"
#include "e1000_dev.h"
#include "net.h"

#define TX_RING_SIZE 16
static struct tx_desc tx_ring[TX_RING_SIZE] __attribute__((aligned(16)));
static struct mbuf *tx_mbufs[TX_RING_SIZE];

#define RX_RING_SIZE 16
static struct rx_desc rx_ring[RX_RING_SIZE] __attribute__((aligned(16)));
static struct mbuf *rx_mbufs[RX_RING_SIZE];

// remember where the e1000's registers live.
static volatile uint32 *regs;

struct spinlock e1000_lock;

// called by pci_init().
// xregs is the memory address at which the
// e1000's registers are mapped.
void e1000_init(uint32 *xregs)
{
    int i;

    initlock(&e1000_lock, "e1000");

    regs = xregs;

    // Reset the device
    regs[E1000_IMS] = 0; // disable interrupts
    regs[E1000_CTL] |= E1000_CTL_RST;
    regs[E1000_IMS] = 0; // redisable interrupts
    __sync_synchronize();

    // [E1000 14.5] Transmit initialization
    memset(tx_ring, 0, sizeof(tx_ring));
    for (i = 0; i < TX_RING_SIZE; i++) {
        tx_ring[i].status = E1000_TXD_STAT_DD;
        tx_mbufs[i] = 0;
    }
    regs[E1000_TDBAL] = (uint64)tx_ring;
    if (sizeof(tx_ring) % 128 != 0)
        panic("e1000");
    regs[E1000_TDLEN] = sizeof(tx_ring);
    regs[E1000_TDH] = regs[E1000_TDT] = 0;

    // [E1000 14.4] Receive initialization
    memset(rx_ring, 0, sizeof(rx_ring));
    for (i = 0; i < RX_RING_SIZE; i++) {
        rx_mbufs[i] = mbufalloc(0);
        if (!rx_mbufs[i])
            panic("e1000");
        rx_ring[i].addr = (uint64)rx_mbufs[i]->head;
    }
    regs[E1000_RDBAL] = (uint64)rx_ring;
    if (sizeof(rx_ring) % 128 != 0)
        panic("e1000");
    regs[E1000_RDH] = 0;
    regs[E1000_RDT] = RX_RING_SIZE - 1;
    regs[E1000_RDLEN] = sizeof(rx_ring);

    // filter by qemu's MAC address, 52:54:00:12:34:56
    regs[E1000_RA] = 0x12005452;
    regs[E1000_RA + 1] = 0x5634 | (1 << 31);
    // multicast table
    for (int i = 0; i < 4096 / 32; i++)
        regs[E1000_MTA + i] = 0;

    // transmitter control bits.
    regs[E1000_TCTL] = E1000_TCTL_EN |                 // enable
                       E1000_TCTL_PSP |                // pad short packets
                       (0x10 << E1000_TCTL_CT_SHIFT) | // collision stuff
                       (0x40 << E1000_TCTL_COLD_SHIFT);
    regs[E1000_TIPG] = 10 | (8 << 10) | (6 << 20); // inter-pkt gap

    // receiver control bits.
    regs[E1000_RCTL] = E1000_RCTL_EN |      // enable receiver
                       E1000_RCTL_BAM |     // enable broadcast
                       E1000_RCTL_SZ_2048 | // 2048-byte rx buffers
                       E1000_RCTL_SECRC;    // strip CRC

    // ask e1000 for receive interrupts.
    regs[E1000_RDTR] = 0;       // interrupt after every received packet (no timer)
    regs[E1000_RADV] = 0;       // interrupt after every packet (no timer)
    regs[E1000_IMS] = (1 << 7); // RXDW -- Receiver Descriptor Write Back
}

int e1000_transmit(struct mbuf *m)
{
    // 对于包m，将其放入发送环中等待
    // tx_mbufs 发送缓冲区
    // tx_ring 发送环缓冲区
    // E1000_TDT 发送环索引
    // E1000_TXD_STAT_DD 发送环状态位，表示该数据包已经发送完毕

    acquire(&e1000_lock); // 锁

    int index = regs[E1000_TDT]; // 读取E1000_TDT控制寄存器，获取下一个数据包的TX环索引

    if ((tx_ring[index].status & E1000_TXD_STAT_DD) == 0) { // 仍在发送
        release(&e1000_lock);
        return -1;
    }

    if (tx_mbufs[index]) // 释放上一个数据包
        mbuffree(tx_mbufs[index]);

    tx_mbufs[index] = m;
    tx_ring[index].length = m->len;
    tx_ring[index].addr = (uint64)m->head;

    // E1000_TXD_CMD_RS表示报告状态位，表示当发送完该数据包时会产生一个中断报告状态
    // E1000_TXD_CMD_EOP表示结束位，表示这是该数据包的最后一个描述符。
    tx_ring[index].cmd = E1000_TXD_CMD_RS | E1000_TXD_CMD_EOP;

    // 更新E1000_TDT控制寄存器，指向下一个数据包的发送环索引
    // 因其是一个环状结构，故取模

    regs[E1000_TDT] = (index + 1) % TX_RING_SIZE;
    release(&e1000_lock);
    return 0;
}

static void e1000_recv(void)
{
    // 遍历发送环状缓冲区, 把其中所有的Packet交由网络上层处理
    while (1) {

        int index = (regs[E1000_RDT] + 1) % RX_RING_SIZE;

        if ((rx_ring[index].status & E1000_RXD_STAT_DD) == 0) {
            // 已处理完
            return;
        }
        rx_mbufs[index]->len = rx_ring[index].length;

        // 向上传输
        net_rx(rx_mbufs[index]);

        // 置空
        rx_mbufs[index] = mbufalloc(0);
        rx_ring[index].status = 0;
        rx_ring[index].addr = (uint64)rx_mbufs[index]->head;
        regs[E1000_RDT] = index;
    }
}

void e1000_intr(void)
{
    // tell the e1000 we've seen this interrupt;
    // without this the e1000 won't raise any
    // further interrupts.
    regs[E1000_ICR] = 0xffffffff;

    e1000_recv();
}
