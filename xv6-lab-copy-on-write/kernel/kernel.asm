
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8a013103          	ld	sp,-1888(sp) # 800088a0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	193050ef          	jal	ra,800059a8 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
    struct run *r;

    if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebd9                	bnez	a5,800000c2 <kfree+0xa6>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00242797          	auipc	a5,0x242
    80000034:	d5078793          	addi	a5,a5,-688 # 80241d80 <end>
    80000038:	08f56563          	bltu	a0,a5,800000c2 <kfree+0xa6>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	08f57163          	bgeu	a0,a5,800000c2 <kfree+0xa6>
        panic("kfree");

    acquire(&PGRefCount.lock);
    80000044:	00009517          	auipc	a0,0x9
    80000048:	8cc50513          	addi	a0,a0,-1844 # 80008910 <PGRefCount>
    8000004c:	00006097          	auipc	ra,0x6
    80000050:	348080e7          	jalr	840(ra) # 80006394 <acquire>
    PGRefCount.PGCount[(uint64)pa / PGSIZE]--;
    80000054:	00c4d793          	srli	a5,s1,0xc
    80000058:	0791                	addi	a5,a5,4
    8000005a:	078a                	slli	a5,a5,0x2
    8000005c:	00009717          	auipc	a4,0x9
    80000060:	8b470713          	addi	a4,a4,-1868 # 80008910 <PGRefCount>
    80000064:	97ba                	add	a5,a5,a4
    80000066:	4798                	lw	a4,8(a5)
    80000068:	377d                	addiw	a4,a4,-1
    8000006a:	0007069b          	sext.w	a3,a4
    8000006e:	c798                	sw	a4,8(a5)

    if (PGRefCount.PGCount[(uint64)pa / PGSIZE] != 0) {
    80000070:	e2ad                	bnez	a3,800000d2 <kfree+0xb6>
        release(&PGRefCount.lock);
        return;
    }
    release(&PGRefCount.lock);
    80000072:	00009517          	auipc	a0,0x9
    80000076:	89e50513          	addi	a0,a0,-1890 # 80008910 <PGRefCount>
    8000007a:	00006097          	auipc	ra,0x6
    8000007e:	3ce080e7          	jalr	974(ra) # 80006448 <release>

    // Fill with junk to catch dangling refs.
    memset(pa, 1, PGSIZE);
    80000082:	6605                	lui	a2,0x1
    80000084:	4585                	li	a1,1
    80000086:	8526                	mv	a0,s1
    80000088:	00000097          	auipc	ra,0x0
    8000008c:	236080e7          	jalr	566(ra) # 800002be <memset>

    r = (struct run *)pa;

    acquire(&kmem.lock);
    80000090:	00009917          	auipc	s2,0x9
    80000094:	86090913          	addi	s2,s2,-1952 # 800088f0 <kmem>
    80000098:	854a                	mv	a0,s2
    8000009a:	00006097          	auipc	ra,0x6
    8000009e:	2fa080e7          	jalr	762(ra) # 80006394 <acquire>
    r->next = kmem.freelist;
    800000a2:	01893783          	ld	a5,24(s2)
    800000a6:	e09c                	sd	a5,0(s1)
    kmem.freelist = r;
    800000a8:	00993c23          	sd	s1,24(s2)
    release(&kmem.lock);
    800000ac:	854a                	mv	a0,s2
    800000ae:	00006097          	auipc	ra,0x6
    800000b2:	39a080e7          	jalr	922(ra) # 80006448 <release>
}
    800000b6:	60e2                	ld	ra,24(sp)
    800000b8:	6442                	ld	s0,16(sp)
    800000ba:	64a2                	ld	s1,8(sp)
    800000bc:	6902                	ld	s2,0(sp)
    800000be:	6105                	addi	sp,sp,32
    800000c0:	8082                	ret
        panic("kfree");
    800000c2:	00008517          	auipc	a0,0x8
    800000c6:	f4e50513          	addi	a0,a0,-178 # 80008010 <etext+0x10>
    800000ca:	00006097          	auipc	ra,0x6
    800000ce:	d92080e7          	jalr	-622(ra) # 80005e5c <panic>
        release(&PGRefCount.lock);
    800000d2:	00009517          	auipc	a0,0x9
    800000d6:	83e50513          	addi	a0,a0,-1986 # 80008910 <PGRefCount>
    800000da:	00006097          	auipc	ra,0x6
    800000de:	36e080e7          	jalr	878(ra) # 80006448 <release>
        return;
    800000e2:	bfd1                	j	800000b6 <kfree+0x9a>

00000000800000e4 <freerange>:
{
    800000e4:	7139                	addi	sp,sp,-64
    800000e6:	fc06                	sd	ra,56(sp)
    800000e8:	f822                	sd	s0,48(sp)
    800000ea:	f426                	sd	s1,40(sp)
    800000ec:	f04a                	sd	s2,32(sp)
    800000ee:	ec4e                	sd	s3,24(sp)
    800000f0:	e852                	sd	s4,16(sp)
    800000f2:	e456                	sd	s5,8(sp)
    800000f4:	e05a                	sd	s6,0(sp)
    800000f6:	0080                	addi	s0,sp,64
    p = (char *)PGROUNDUP((uint64)pa_start);
    800000f8:	6785                	lui	a5,0x1
    800000fa:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000fe:	953a                	add	a0,a0,a4
    80000100:	777d                	lui	a4,0xfffff
    80000102:	00e574b3          	and	s1,a0,a4
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE) {
    80000106:	97a6                	add	a5,a5,s1
    80000108:	02f5eb63          	bltu	a1,a5,8000013e <freerange+0x5a>
    8000010c:	892e                	mv	s2,a1
        PGRefCount.PGCount[(uint64)p / PGSIZE] = 1;
    8000010e:	00009b17          	auipc	s6,0x9
    80000112:	802b0b13          	addi	s6,s6,-2046 # 80008910 <PGRefCount>
    80000116:	4a85                	li	s5,1
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE) {
    80000118:	6a05                	lui	s4,0x1
    8000011a:	6989                	lui	s3,0x2
        PGRefCount.PGCount[(uint64)p / PGSIZE] = 1;
    8000011c:	00c4d793          	srli	a5,s1,0xc
    80000120:	0791                	addi	a5,a5,4
    80000122:	078a                	slli	a5,a5,0x2
    80000124:	97da                	add	a5,a5,s6
    80000126:	0157a423          	sw	s5,8(a5)
        kfree(p);
    8000012a:	8526                	mv	a0,s1
    8000012c:	00000097          	auipc	ra,0x0
    80000130:	ef0080e7          	jalr	-272(ra) # 8000001c <kfree>
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE) {
    80000134:	87a6                	mv	a5,s1
    80000136:	94d2                	add	s1,s1,s4
    80000138:	97ce                	add	a5,a5,s3
    8000013a:	fef971e3          	bgeu	s2,a5,8000011c <freerange+0x38>
}
    8000013e:	70e2                	ld	ra,56(sp)
    80000140:	7442                	ld	s0,48(sp)
    80000142:	74a2                	ld	s1,40(sp)
    80000144:	7902                	ld	s2,32(sp)
    80000146:	69e2                	ld	s3,24(sp)
    80000148:	6a42                	ld	s4,16(sp)
    8000014a:	6aa2                	ld	s5,8(sp)
    8000014c:	6b02                	ld	s6,0(sp)
    8000014e:	6121                	addi	sp,sp,64
    80000150:	8082                	ret

0000000080000152 <kinit>:
{
    80000152:	1141                	addi	sp,sp,-16
    80000154:	e406                	sd	ra,8(sp)
    80000156:	e022                	sd	s0,0(sp)
    80000158:	0800                	addi	s0,sp,16
    initlock(&kmem.lock, "kmem");
    8000015a:	00008597          	auipc	a1,0x8
    8000015e:	ebe58593          	addi	a1,a1,-322 # 80008018 <etext+0x18>
    80000162:	00008517          	auipc	a0,0x8
    80000166:	78e50513          	addi	a0,a0,1934 # 800088f0 <kmem>
    8000016a:	00006097          	auipc	ra,0x6
    8000016e:	19a080e7          	jalr	410(ra) # 80006304 <initlock>
    initlock(&PGRefCount.lock, "PGRefCount"); // 初始化PGRefCount锁
    80000172:	00008597          	auipc	a1,0x8
    80000176:	eae58593          	addi	a1,a1,-338 # 80008020 <etext+0x20>
    8000017a:	00008517          	auipc	a0,0x8
    8000017e:	79650513          	addi	a0,a0,1942 # 80008910 <PGRefCount>
    80000182:	00006097          	auipc	ra,0x6
    80000186:	182080e7          	jalr	386(ra) # 80006304 <initlock>
    freerange(end, (void *)PHYSTOP);
    8000018a:	45c5                	li	a1,17
    8000018c:	05ee                	slli	a1,a1,0x1b
    8000018e:	00242517          	auipc	a0,0x242
    80000192:	bf250513          	addi	a0,a0,-1038 # 80241d80 <end>
    80000196:	00000097          	auipc	ra,0x0
    8000019a:	f4e080e7          	jalr	-178(ra) # 800000e4 <freerange>
}
    8000019e:	60a2                	ld	ra,8(sp)
    800001a0:	6402                	ld	s0,0(sp)
    800001a2:	0141                	addi	sp,sp,16
    800001a4:	8082                	ret

00000000800001a6 <kalloc>:

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc(void)
{
    800001a6:	1101                	addi	sp,sp,-32
    800001a8:	ec06                	sd	ra,24(sp)
    800001aa:	e822                	sd	s0,16(sp)
    800001ac:	e426                	sd	s1,8(sp)
    800001ae:	1000                	addi	s0,sp,32
    struct run *r;

    acquire(&kmem.lock);
    800001b0:	00008497          	auipc	s1,0x8
    800001b4:	74048493          	addi	s1,s1,1856 # 800088f0 <kmem>
    800001b8:	8526                	mv	a0,s1
    800001ba:	00006097          	auipc	ra,0x6
    800001be:	1da080e7          	jalr	474(ra) # 80006394 <acquire>
    r = kmem.freelist;
    800001c2:	6c84                	ld	s1,24(s1)
    if (r)
    800001c4:	ccb9                	beqz	s1,80000222 <kalloc+0x7c>
        kmem.freelist = r->next;
    800001c6:	609c                	ld	a5,0(s1)
    800001c8:	00008517          	auipc	a0,0x8
    800001cc:	72850513          	addi	a0,a0,1832 # 800088f0 <kmem>
    800001d0:	ed1c                	sd	a5,24(a0)
    release(&kmem.lock);
    800001d2:	00006097          	auipc	ra,0x6
    800001d6:	276080e7          	jalr	630(ra) # 80006448 <release>

    // pgcount初值赋为1
    if (r) {
        acquire(&PGRefCount.lock);
    800001da:	00008517          	auipc	a0,0x8
    800001de:	73650513          	addi	a0,a0,1846 # 80008910 <PGRefCount>
    800001e2:	00006097          	auipc	ra,0x6
    800001e6:	1b2080e7          	jalr	434(ra) # 80006394 <acquire>
        PGRefCount.PGCount[(uint64)r / PGSIZE] = 1;
    800001ea:	00008517          	auipc	a0,0x8
    800001ee:	72650513          	addi	a0,a0,1830 # 80008910 <PGRefCount>
    800001f2:	00c4d793          	srli	a5,s1,0xc
    800001f6:	0791                	addi	a5,a5,4
    800001f8:	078a                	slli	a5,a5,0x2
    800001fa:	97aa                	add	a5,a5,a0
    800001fc:	4705                	li	a4,1
    800001fe:	c798                	sw	a4,8(a5)
        release(&PGRefCount.lock);
    80000200:	00006097          	auipc	ra,0x6
    80000204:	248080e7          	jalr	584(ra) # 80006448 <release>
    }

    if (r)
        memset((char *)r, 5, PGSIZE); // fill with junk
    80000208:	6605                	lui	a2,0x1
    8000020a:	4595                	li	a1,5
    8000020c:	8526                	mv	a0,s1
    8000020e:	00000097          	auipc	ra,0x0
    80000212:	0b0080e7          	jalr	176(ra) # 800002be <memset>
    return (void *)r;
}
    80000216:	8526                	mv	a0,s1
    80000218:	60e2                	ld	ra,24(sp)
    8000021a:	6442                	ld	s0,16(sp)
    8000021c:	64a2                	ld	s1,8(sp)
    8000021e:	6105                	addi	sp,sp,32
    80000220:	8082                	ret
    release(&kmem.lock);
    80000222:	00008517          	auipc	a0,0x8
    80000226:	6ce50513          	addi	a0,a0,1742 # 800088f0 <kmem>
    8000022a:	00006097          	auipc	ra,0x6
    8000022e:	21e080e7          	jalr	542(ra) # 80006448 <release>
    if (r)
    80000232:	b7d5                	j	80000216 <kalloc+0x70>

0000000080000234 <AddPGRefCount>:

int AddPGRefCount(void *pa)
{
    if (((uint64)pa % PGSIZE)) {
    80000234:	03451793          	slli	a5,a0,0x34
    80000238:	efb1                	bnez	a5,80000294 <AddPGRefCount+0x60>
{
    8000023a:	1101                	addi	sp,sp,-32
    8000023c:	ec06                	sd	ra,24(sp)
    8000023e:	e822                	sd	s0,16(sp)
    80000240:	e426                	sd	s1,8(sp)
    80000242:	1000                	addi	s0,sp,32
    80000244:	84aa                	mv	s1,a0
        return -1;
    }
    if ((char *)pa < end || (uint64)pa >= PHYSTOP) {
    80000246:	00242797          	auipc	a5,0x242
    8000024a:	b3a78793          	addi	a5,a5,-1222 # 80241d80 <end>
    8000024e:	04f56563          	bltu	a0,a5,80000298 <AddPGRefCount+0x64>
    80000252:	47c5                	li	a5,17
    80000254:	07ee                	slli	a5,a5,0x1b
    80000256:	04f57363          	bgeu	a0,a5,8000029c <AddPGRefCount+0x68>
        return -1;
    }
    acquire(&PGRefCount.lock);
    8000025a:	00008517          	auipc	a0,0x8
    8000025e:	6b650513          	addi	a0,a0,1718 # 80008910 <PGRefCount>
    80000262:	00006097          	auipc	ra,0x6
    80000266:	132080e7          	jalr	306(ra) # 80006394 <acquire>
    PGRefCount.PGCount[(uint64)pa / PGSIZE]++;
    8000026a:	80b1                	srli	s1,s1,0xc
    8000026c:	00008517          	auipc	a0,0x8
    80000270:	6a450513          	addi	a0,a0,1700 # 80008910 <PGRefCount>
    80000274:	0491                	addi	s1,s1,4
    80000276:	048a                	slli	s1,s1,0x2
    80000278:	94aa                	add	s1,s1,a0
    8000027a:	449c                	lw	a5,8(s1)
    8000027c:	2785                	addiw	a5,a5,1
    8000027e:	c49c                	sw	a5,8(s1)
    release(&PGRefCount.lock);
    80000280:	00006097          	auipc	ra,0x6
    80000284:	1c8080e7          	jalr	456(ra) # 80006448 <release>
    return 0;
    80000288:	4501                	li	a0,0
}
    8000028a:	60e2                	ld	ra,24(sp)
    8000028c:	6442                	ld	s0,16(sp)
    8000028e:	64a2                	ld	s1,8(sp)
    80000290:	6105                	addi	sp,sp,32
    80000292:	8082                	ret
        return -1;
    80000294:	557d                	li	a0,-1
}
    80000296:	8082                	ret
        return -1;
    80000298:	557d                	li	a0,-1
    8000029a:	bfc5                	j	8000028a <AddPGRefCount+0x56>
    8000029c:	557d                	li	a0,-1
    8000029e:	b7f5                	j	8000028a <AddPGRefCount+0x56>

00000000800002a0 <GetPGRefCount>:

int GetPGRefCount(void *pa)
{
    800002a0:	1141                	addi	sp,sp,-16
    800002a2:	e422                	sd	s0,8(sp)
    800002a4:	0800                	addi	s0,sp,16
    return PGRefCount.PGCount[(uint64)pa / PGSIZE];
    800002a6:	8131                	srli	a0,a0,0xc
    800002a8:	0511                	addi	a0,a0,4
    800002aa:	050a                	slli	a0,a0,0x2
    800002ac:	00008797          	auipc	a5,0x8
    800002b0:	66478793          	addi	a5,a5,1636 # 80008910 <PGRefCount>
    800002b4:	97aa                	add	a5,a5,a0
}
    800002b6:	4788                	lw	a0,8(a5)
    800002b8:	6422                	ld	s0,8(sp)
    800002ba:	0141                	addi	sp,sp,16
    800002bc:	8082                	ret

00000000800002be <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800002be:	1141                	addi	sp,sp,-16
    800002c0:	e422                	sd	s0,8(sp)
    800002c2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800002c4:	ca19                	beqz	a2,800002da <memset+0x1c>
    800002c6:	87aa                	mv	a5,a0
    800002c8:	1602                	slli	a2,a2,0x20
    800002ca:	9201                	srli	a2,a2,0x20
    800002cc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800002d0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800002d4:	0785                	addi	a5,a5,1
    800002d6:	fee79de3          	bne	a5,a4,800002d0 <memset+0x12>
  }
  return dst;
}
    800002da:	6422                	ld	s0,8(sp)
    800002dc:	0141                	addi	sp,sp,16
    800002de:	8082                	ret

00000000800002e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800002e0:	1141                	addi	sp,sp,-16
    800002e2:	e422                	sd	s0,8(sp)
    800002e4:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800002e6:	ca05                	beqz	a2,80000316 <memcmp+0x36>
    800002e8:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800002ec:	1682                	slli	a3,a3,0x20
    800002ee:	9281                	srli	a3,a3,0x20
    800002f0:	0685                	addi	a3,a3,1
    800002f2:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800002f4:	00054783          	lbu	a5,0(a0)
    800002f8:	0005c703          	lbu	a4,0(a1)
    800002fc:	00e79863          	bne	a5,a4,8000030c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000300:	0505                	addi	a0,a0,1
    80000302:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000304:	fed518e3          	bne	a0,a3,800002f4 <memcmp+0x14>
  }

  return 0;
    80000308:	4501                	li	a0,0
    8000030a:	a019                	j	80000310 <memcmp+0x30>
      return *s1 - *s2;
    8000030c:	40e7853b          	subw	a0,a5,a4
}
    80000310:	6422                	ld	s0,8(sp)
    80000312:	0141                	addi	sp,sp,16
    80000314:	8082                	ret
  return 0;
    80000316:	4501                	li	a0,0
    80000318:	bfe5                	j	80000310 <memcmp+0x30>

000000008000031a <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    8000031a:	1141                	addi	sp,sp,-16
    8000031c:	e422                	sd	s0,8(sp)
    8000031e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000320:	c205                	beqz	a2,80000340 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000322:	02a5e263          	bltu	a1,a0,80000346 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000326:	1602                	slli	a2,a2,0x20
    80000328:	9201                	srli	a2,a2,0x20
    8000032a:	00c587b3          	add	a5,a1,a2
{
    8000032e:	872a                	mv	a4,a0
      *d++ = *s++;
    80000330:	0585                	addi	a1,a1,1
    80000332:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7fdbd281>
    80000334:	fff5c683          	lbu	a3,-1(a1)
    80000338:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000033c:	fef59ae3          	bne	a1,a5,80000330 <memmove+0x16>

  return dst;
}
    80000340:	6422                	ld	s0,8(sp)
    80000342:	0141                	addi	sp,sp,16
    80000344:	8082                	ret
  if(s < d && s + n > d){
    80000346:	02061693          	slli	a3,a2,0x20
    8000034a:	9281                	srli	a3,a3,0x20
    8000034c:	00d58733          	add	a4,a1,a3
    80000350:	fce57be3          	bgeu	a0,a4,80000326 <memmove+0xc>
    d += n;
    80000354:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000356:	fff6079b          	addiw	a5,a2,-1
    8000035a:	1782                	slli	a5,a5,0x20
    8000035c:	9381                	srli	a5,a5,0x20
    8000035e:	fff7c793          	not	a5,a5
    80000362:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000364:	177d                	addi	a4,a4,-1
    80000366:	16fd                	addi	a3,a3,-1
    80000368:	00074603          	lbu	a2,0(a4)
    8000036c:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000370:	fee79ae3          	bne	a5,a4,80000364 <memmove+0x4a>
    80000374:	b7f1                	j	80000340 <memmove+0x26>

0000000080000376 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000376:	1141                	addi	sp,sp,-16
    80000378:	e406                	sd	ra,8(sp)
    8000037a:	e022                	sd	s0,0(sp)
    8000037c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000037e:	00000097          	auipc	ra,0x0
    80000382:	f9c080e7          	jalr	-100(ra) # 8000031a <memmove>
}
    80000386:	60a2                	ld	ra,8(sp)
    80000388:	6402                	ld	s0,0(sp)
    8000038a:	0141                	addi	sp,sp,16
    8000038c:	8082                	ret

000000008000038e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000038e:	1141                	addi	sp,sp,-16
    80000390:	e422                	sd	s0,8(sp)
    80000392:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000394:	ce11                	beqz	a2,800003b0 <strncmp+0x22>
    80000396:	00054783          	lbu	a5,0(a0)
    8000039a:	cf89                	beqz	a5,800003b4 <strncmp+0x26>
    8000039c:	0005c703          	lbu	a4,0(a1)
    800003a0:	00f71a63          	bne	a4,a5,800003b4 <strncmp+0x26>
    n--, p++, q++;
    800003a4:	367d                	addiw	a2,a2,-1
    800003a6:	0505                	addi	a0,a0,1
    800003a8:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800003aa:	f675                	bnez	a2,80000396 <strncmp+0x8>
  if(n == 0)
    return 0;
    800003ac:	4501                	li	a0,0
    800003ae:	a809                	j	800003c0 <strncmp+0x32>
    800003b0:	4501                	li	a0,0
    800003b2:	a039                	j	800003c0 <strncmp+0x32>
  if(n == 0)
    800003b4:	ca09                	beqz	a2,800003c6 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800003b6:	00054503          	lbu	a0,0(a0)
    800003ba:	0005c783          	lbu	a5,0(a1)
    800003be:	9d1d                	subw	a0,a0,a5
}
    800003c0:	6422                	ld	s0,8(sp)
    800003c2:	0141                	addi	sp,sp,16
    800003c4:	8082                	ret
    return 0;
    800003c6:	4501                	li	a0,0
    800003c8:	bfe5                	j	800003c0 <strncmp+0x32>

00000000800003ca <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800003ca:	1141                	addi	sp,sp,-16
    800003cc:	e422                	sd	s0,8(sp)
    800003ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800003d0:	872a                	mv	a4,a0
    800003d2:	8832                	mv	a6,a2
    800003d4:	367d                	addiw	a2,a2,-1
    800003d6:	01005963          	blez	a6,800003e8 <strncpy+0x1e>
    800003da:	0705                	addi	a4,a4,1
    800003dc:	0005c783          	lbu	a5,0(a1)
    800003e0:	fef70fa3          	sb	a5,-1(a4)
    800003e4:	0585                	addi	a1,a1,1
    800003e6:	f7f5                	bnez	a5,800003d2 <strncpy+0x8>
    ;
  while(n-- > 0)
    800003e8:	86ba                	mv	a3,a4
    800003ea:	00c05c63          	blez	a2,80000402 <strncpy+0x38>
    *s++ = 0;
    800003ee:	0685                	addi	a3,a3,1
    800003f0:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800003f4:	40d707bb          	subw	a5,a4,a3
    800003f8:	37fd                	addiw	a5,a5,-1
    800003fa:	010787bb          	addw	a5,a5,a6
    800003fe:	fef048e3          	bgtz	a5,800003ee <strncpy+0x24>
  return os;
}
    80000402:	6422                	ld	s0,8(sp)
    80000404:	0141                	addi	sp,sp,16
    80000406:	8082                	ret

0000000080000408 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000408:	1141                	addi	sp,sp,-16
    8000040a:	e422                	sd	s0,8(sp)
    8000040c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000040e:	02c05363          	blez	a2,80000434 <safestrcpy+0x2c>
    80000412:	fff6069b          	addiw	a3,a2,-1
    80000416:	1682                	slli	a3,a3,0x20
    80000418:	9281                	srli	a3,a3,0x20
    8000041a:	96ae                	add	a3,a3,a1
    8000041c:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000041e:	00d58963          	beq	a1,a3,80000430 <safestrcpy+0x28>
    80000422:	0585                	addi	a1,a1,1
    80000424:	0785                	addi	a5,a5,1
    80000426:	fff5c703          	lbu	a4,-1(a1)
    8000042a:	fee78fa3          	sb	a4,-1(a5)
    8000042e:	fb65                	bnez	a4,8000041e <safestrcpy+0x16>
    ;
  *s = 0;
    80000430:	00078023          	sb	zero,0(a5)
  return os;
}
    80000434:	6422                	ld	s0,8(sp)
    80000436:	0141                	addi	sp,sp,16
    80000438:	8082                	ret

000000008000043a <strlen>:

int
strlen(const char *s)
{
    8000043a:	1141                	addi	sp,sp,-16
    8000043c:	e422                	sd	s0,8(sp)
    8000043e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000440:	00054783          	lbu	a5,0(a0)
    80000444:	cf91                	beqz	a5,80000460 <strlen+0x26>
    80000446:	0505                	addi	a0,a0,1
    80000448:	87aa                	mv	a5,a0
    8000044a:	4685                	li	a3,1
    8000044c:	9e89                	subw	a3,a3,a0
    8000044e:	00f6853b          	addw	a0,a3,a5
    80000452:	0785                	addi	a5,a5,1
    80000454:	fff7c703          	lbu	a4,-1(a5)
    80000458:	fb7d                	bnez	a4,8000044e <strlen+0x14>
    ;
  return n;
}
    8000045a:	6422                	ld	s0,8(sp)
    8000045c:	0141                	addi	sp,sp,16
    8000045e:	8082                	ret
  for(n = 0; s[n]; n++)
    80000460:	4501                	li	a0,0
    80000462:	bfe5                	j	8000045a <strlen+0x20>

0000000080000464 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000464:	1141                	addi	sp,sp,-16
    80000466:	e406                	sd	ra,8(sp)
    80000468:	e022                	sd	s0,0(sp)
    8000046a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000046c:	00001097          	auipc	ra,0x1
    80000470:	b16080e7          	jalr	-1258(ra) # 80000f82 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000474:	00008717          	auipc	a4,0x8
    80000478:	44c70713          	addi	a4,a4,1100 # 800088c0 <started>
  if(cpuid() == 0){
    8000047c:	c139                	beqz	a0,800004c2 <main+0x5e>
    while(started == 0)
    8000047e:	431c                	lw	a5,0(a4)
    80000480:	2781                	sext.w	a5,a5
    80000482:	dff5                	beqz	a5,8000047e <main+0x1a>
      ;
    __sync_synchronize();
    80000484:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000488:	00001097          	auipc	ra,0x1
    8000048c:	afa080e7          	jalr	-1286(ra) # 80000f82 <cpuid>
    80000490:	85aa                	mv	a1,a0
    80000492:	00008517          	auipc	a0,0x8
    80000496:	bb650513          	addi	a0,a0,-1098 # 80008048 <etext+0x48>
    8000049a:	00006097          	auipc	ra,0x6
    8000049e:	a0c080e7          	jalr	-1524(ra) # 80005ea6 <printf>
    kvminithart();    // turn on paging
    800004a2:	00000097          	auipc	ra,0x0
    800004a6:	0d8080e7          	jalr	216(ra) # 8000057a <kvminithart>
    trapinithart();   // install kernel trap vector
    800004aa:	00001097          	auipc	ra,0x1
    800004ae:	7a2080e7          	jalr	1954(ra) # 80001c4c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800004b2:	00005097          	auipc	ra,0x5
    800004b6:	eae080e7          	jalr	-338(ra) # 80005360 <plicinithart>
  }

  scheduler();        
    800004ba:	00001097          	auipc	ra,0x1
    800004be:	fea080e7          	jalr	-22(ra) # 800014a4 <scheduler>
    consoleinit();
    800004c2:	00006097          	auipc	ra,0x6
    800004c6:	8aa080e7          	jalr	-1878(ra) # 80005d6c <consoleinit>
    printfinit();
    800004ca:	00006097          	auipc	ra,0x6
    800004ce:	bbc080e7          	jalr	-1092(ra) # 80006086 <printfinit>
    printf("\n");
    800004d2:	00008517          	auipc	a0,0x8
    800004d6:	b8650513          	addi	a0,a0,-1146 # 80008058 <etext+0x58>
    800004da:	00006097          	auipc	ra,0x6
    800004de:	9cc080e7          	jalr	-1588(ra) # 80005ea6 <printf>
    printf("xv6 kernel is booting\n");
    800004e2:	00008517          	auipc	a0,0x8
    800004e6:	b4e50513          	addi	a0,a0,-1202 # 80008030 <etext+0x30>
    800004ea:	00006097          	auipc	ra,0x6
    800004ee:	9bc080e7          	jalr	-1604(ra) # 80005ea6 <printf>
    printf("\n");
    800004f2:	00008517          	auipc	a0,0x8
    800004f6:	b6650513          	addi	a0,a0,-1178 # 80008058 <etext+0x58>
    800004fa:	00006097          	auipc	ra,0x6
    800004fe:	9ac080e7          	jalr	-1620(ra) # 80005ea6 <printf>
    kinit();         // physical page allocator
    80000502:	00000097          	auipc	ra,0x0
    80000506:	c50080e7          	jalr	-944(ra) # 80000152 <kinit>
    kvminit();       // create kernel page table
    8000050a:	00000097          	auipc	ra,0x0
    8000050e:	326080e7          	jalr	806(ra) # 80000830 <kvminit>
    kvminithart();   // turn on paging
    80000512:	00000097          	auipc	ra,0x0
    80000516:	068080e7          	jalr	104(ra) # 8000057a <kvminithart>
    procinit();      // process table
    8000051a:	00001097          	auipc	ra,0x1
    8000051e:	9b4080e7          	jalr	-1612(ra) # 80000ece <procinit>
    trapinit();      // trap vectors
    80000522:	00001097          	auipc	ra,0x1
    80000526:	702080e7          	jalr	1794(ra) # 80001c24 <trapinit>
    trapinithart();  // install kernel trap vector
    8000052a:	00001097          	auipc	ra,0x1
    8000052e:	722080e7          	jalr	1826(ra) # 80001c4c <trapinithart>
    plicinit();      // set up interrupt controller
    80000532:	00005097          	auipc	ra,0x5
    80000536:	e18080e7          	jalr	-488(ra) # 8000534a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000053a:	00005097          	auipc	ra,0x5
    8000053e:	e26080e7          	jalr	-474(ra) # 80005360 <plicinithart>
    binit();         // buffer cache
    80000542:	00002097          	auipc	ra,0x2
    80000546:	fba080e7          	jalr	-70(ra) # 800024fc <binit>
    iinit();         // inode table
    8000054a:	00002097          	auipc	ra,0x2
    8000054e:	65a080e7          	jalr	1626(ra) # 80002ba4 <iinit>
    fileinit();      // file table
    80000552:	00003097          	auipc	ra,0x3
    80000556:	600080e7          	jalr	1536(ra) # 80003b52 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000055a:	00005097          	auipc	ra,0x5
    8000055e:	f0e080e7          	jalr	-242(ra) # 80005468 <virtio_disk_init>
    userinit();      // first user process
    80000562:	00001097          	auipc	ra,0x1
    80000566:	d24080e7          	jalr	-732(ra) # 80001286 <userinit>
    __sync_synchronize();
    8000056a:	0ff0000f          	fence
    started = 1;
    8000056e:	4785                	li	a5,1
    80000570:	00008717          	auipc	a4,0x8
    80000574:	34f72823          	sw	a5,848(a4) # 800088c0 <started>
    80000578:	b789                	j	800004ba <main+0x56>

000000008000057a <kvminithart>:
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart()
{
    8000057a:	1141                	addi	sp,sp,-16
    8000057c:	e422                	sd	s0,8(sp)
    8000057e:	0800                	addi	s0,sp,16

// flush the TLB.
static inline void sfence_vma()
{
    // the zero, zero means flush all TLB entries.
    asm volatile("sfence.vma zero, zero");
    80000580:	12000073          	sfence.vma
    // wait for any previous writes to the page table memory to finish.
    sfence_vma();

    w_satp(MAKE_SATP(kernel_pagetable));
    80000584:	00008797          	auipc	a5,0x8
    80000588:	3447b783          	ld	a5,836(a5) # 800088c8 <kernel_pagetable>
    8000058c:	83b1                	srli	a5,a5,0xc
    8000058e:	577d                	li	a4,-1
    80000590:	177e                	slli	a4,a4,0x3f
    80000592:	8fd9                	or	a5,a5,a4
    asm volatile("csrw satp, %0" : : "r"(x));
    80000594:	18079073          	csrw	satp,a5
    asm volatile("sfence.vma zero, zero");
    80000598:	12000073          	sfence.vma

    // flush stale entries from the TLB.
    sfence_vma();
}
    8000059c:	6422                	ld	s0,8(sp)
    8000059e:	0141                	addi	sp,sp,16
    800005a0:	8082                	ret

00000000800005a2 <walk>:
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800005a2:	7139                	addi	sp,sp,-64
    800005a4:	fc06                	sd	ra,56(sp)
    800005a6:	f822                	sd	s0,48(sp)
    800005a8:	f426                	sd	s1,40(sp)
    800005aa:	f04a                	sd	s2,32(sp)
    800005ac:	ec4e                	sd	s3,24(sp)
    800005ae:	e852                	sd	s4,16(sp)
    800005b0:	e456                	sd	s5,8(sp)
    800005b2:	e05a                	sd	s6,0(sp)
    800005b4:	0080                	addi	s0,sp,64
    800005b6:	84aa                	mv	s1,a0
    800005b8:	89ae                	mv	s3,a1
    800005ba:	8ab2                	mv	s5,a2
    if (va >= MAXVA)
    800005bc:	57fd                	li	a5,-1
    800005be:	83e9                	srli	a5,a5,0x1a
    800005c0:	4a79                	li	s4,30
        panic("walk");

    for (int level = 2; level > 0; level--) {
    800005c2:	4b31                	li	s6,12
    if (va >= MAXVA)
    800005c4:	04b7f263          	bgeu	a5,a1,80000608 <walk+0x66>
        panic("walk");
    800005c8:	00008517          	auipc	a0,0x8
    800005cc:	a9850513          	addi	a0,a0,-1384 # 80008060 <etext+0x60>
    800005d0:	00006097          	auipc	ra,0x6
    800005d4:	88c080e7          	jalr	-1908(ra) # 80005e5c <panic>
        pte_t *pte = &pagetable[PX(level, va)];
        if (*pte & PTE_V) {
            pagetable = (pagetable_t)PTE2PA(*pte);
        }
        else {
            if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    800005d8:	060a8663          	beqz	s5,80000644 <walk+0xa2>
    800005dc:	00000097          	auipc	ra,0x0
    800005e0:	bca080e7          	jalr	-1078(ra) # 800001a6 <kalloc>
    800005e4:	84aa                	mv	s1,a0
    800005e6:	c529                	beqz	a0,80000630 <walk+0x8e>
                return 0;
            memset(pagetable, 0, PGSIZE);
    800005e8:	6605                	lui	a2,0x1
    800005ea:	4581                	li	a1,0
    800005ec:	00000097          	auipc	ra,0x0
    800005f0:	cd2080e7          	jalr	-814(ra) # 800002be <memset>
            *pte = PA2PTE(pagetable) | PTE_V;
    800005f4:	00c4d793          	srli	a5,s1,0xc
    800005f8:	07aa                	slli	a5,a5,0xa
    800005fa:	0017e793          	ori	a5,a5,1
    800005fe:	00f93023          	sd	a5,0(s2)
    for (int level = 2; level > 0; level--) {
    80000602:	3a5d                	addiw	s4,s4,-9 # ff7 <_entry-0x7ffff009>
    80000604:	036a0063          	beq	s4,s6,80000624 <walk+0x82>
        pte_t *pte = &pagetable[PX(level, va)];
    80000608:	0149d933          	srl	s2,s3,s4
    8000060c:	1ff97913          	andi	s2,s2,511
    80000610:	090e                	slli	s2,s2,0x3
    80000612:	9926                	add	s2,s2,s1
        if (*pte & PTE_V) {
    80000614:	00093483          	ld	s1,0(s2)
    80000618:	0014f793          	andi	a5,s1,1
    8000061c:	dfd5                	beqz	a5,800005d8 <walk+0x36>
            pagetable = (pagetable_t)PTE2PA(*pte);
    8000061e:	80a9                	srli	s1,s1,0xa
    80000620:	04b2                	slli	s1,s1,0xc
    80000622:	b7c5                	j	80000602 <walk+0x60>
        }
    }
    return &pagetable[PX(0, va)];
    80000624:	00c9d513          	srli	a0,s3,0xc
    80000628:	1ff57513          	andi	a0,a0,511
    8000062c:	050e                	slli	a0,a0,0x3
    8000062e:	9526                	add	a0,a0,s1
}
    80000630:	70e2                	ld	ra,56(sp)
    80000632:	7442                	ld	s0,48(sp)
    80000634:	74a2                	ld	s1,40(sp)
    80000636:	7902                	ld	s2,32(sp)
    80000638:	69e2                	ld	s3,24(sp)
    8000063a:	6a42                	ld	s4,16(sp)
    8000063c:	6aa2                	ld	s5,8(sp)
    8000063e:	6b02                	ld	s6,0(sp)
    80000640:	6121                	addi	sp,sp,64
    80000642:	8082                	ret
                return 0;
    80000644:	4501                	li	a0,0
    80000646:	b7ed                	j	80000630 <walk+0x8e>

0000000080000648 <walkaddr>:
uint64 walkaddr(pagetable_t pagetable, uint64 va)
{
    pte_t *pte;
    uint64 pa;

    if (va >= MAXVA)
    80000648:	57fd                	li	a5,-1
    8000064a:	83e9                	srli	a5,a5,0x1a
    8000064c:	00b7f463          	bgeu	a5,a1,80000654 <walkaddr+0xc>
        return 0;
    80000650:	4501                	li	a0,0
        return 0;
    if ((*pte & PTE_U) == 0)
        return 0;
    pa = PTE2PA(*pte);
    return pa;
}
    80000652:	8082                	ret
{
    80000654:	1141                	addi	sp,sp,-16
    80000656:	e406                	sd	ra,8(sp)
    80000658:	e022                	sd	s0,0(sp)
    8000065a:	0800                	addi	s0,sp,16
    pte = walk(pagetable, va, 0);
    8000065c:	4601                	li	a2,0
    8000065e:	00000097          	auipc	ra,0x0
    80000662:	f44080e7          	jalr	-188(ra) # 800005a2 <walk>
    if (pte == 0)
    80000666:	c105                	beqz	a0,80000686 <walkaddr+0x3e>
    if ((*pte & PTE_V) == 0)
    80000668:	611c                	ld	a5,0(a0)
    if ((*pte & PTE_U) == 0)
    8000066a:	0117f693          	andi	a3,a5,17
    8000066e:	4745                	li	a4,17
        return 0;
    80000670:	4501                	li	a0,0
    if ((*pte & PTE_U) == 0)
    80000672:	00e68663          	beq	a3,a4,8000067e <walkaddr+0x36>
}
    80000676:	60a2                	ld	ra,8(sp)
    80000678:	6402                	ld	s0,0(sp)
    8000067a:	0141                	addi	sp,sp,16
    8000067c:	8082                	ret
    pa = PTE2PA(*pte);
    8000067e:	83a9                	srli	a5,a5,0xa
    80000680:	00c79513          	slli	a0,a5,0xc
    return pa;
    80000684:	bfcd                	j	80000676 <walkaddr+0x2e>
        return 0;
    80000686:	4501                	li	a0,0
    80000688:	b7fd                	j	80000676 <walkaddr+0x2e>

000000008000068a <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000068a:	715d                	addi	sp,sp,-80
    8000068c:	e486                	sd	ra,72(sp)
    8000068e:	e0a2                	sd	s0,64(sp)
    80000690:	fc26                	sd	s1,56(sp)
    80000692:	f84a                	sd	s2,48(sp)
    80000694:	f44e                	sd	s3,40(sp)
    80000696:	f052                	sd	s4,32(sp)
    80000698:	ec56                	sd	s5,24(sp)
    8000069a:	e85a                	sd	s6,16(sp)
    8000069c:	e45e                	sd	s7,8(sp)
    8000069e:	0880                	addi	s0,sp,80
    uint64 a, last;
    pte_t *pte;

    if (size == 0)
    800006a0:	c639                	beqz	a2,800006ee <mappages+0x64>
    800006a2:	8aaa                	mv	s5,a0
    800006a4:	8b3a                	mv	s6,a4
        panic("mappages: size");

    a = PGROUNDDOWN(va);
    800006a6:	777d                	lui	a4,0xfffff
    800006a8:	00e5f7b3          	and	a5,a1,a4
    last = PGROUNDDOWN(va + size - 1);
    800006ac:	fff58993          	addi	s3,a1,-1
    800006b0:	99b2                	add	s3,s3,a2
    800006b2:	00e9f9b3          	and	s3,s3,a4
    a = PGROUNDDOWN(va);
    800006b6:	893e                	mv	s2,a5
    800006b8:	40f68a33          	sub	s4,a3,a5
        if (*pte & PTE_V)
            panic("mappages: remap");
        *pte = PA2PTE(pa) | perm | PTE_V;
        if (a == last)
            break;
        a += PGSIZE;
    800006bc:	6b85                	lui	s7,0x1
    800006be:	012a04b3          	add	s1,s4,s2
        if ((pte = walk(pagetable, a, 1)) == 0)
    800006c2:	4605                	li	a2,1
    800006c4:	85ca                	mv	a1,s2
    800006c6:	8556                	mv	a0,s5
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	eda080e7          	jalr	-294(ra) # 800005a2 <walk>
    800006d0:	cd1d                	beqz	a0,8000070e <mappages+0x84>
        if (*pte & PTE_V)
    800006d2:	611c                	ld	a5,0(a0)
    800006d4:	8b85                	andi	a5,a5,1
    800006d6:	e785                	bnez	a5,800006fe <mappages+0x74>
        *pte = PA2PTE(pa) | perm | PTE_V;
    800006d8:	80b1                	srli	s1,s1,0xc
    800006da:	04aa                	slli	s1,s1,0xa
    800006dc:	0164e4b3          	or	s1,s1,s6
    800006e0:	0014e493          	ori	s1,s1,1
    800006e4:	e104                	sd	s1,0(a0)
        if (a == last)
    800006e6:	05390063          	beq	s2,s3,80000726 <mappages+0x9c>
        a += PGSIZE;
    800006ea:	995e                	add	s2,s2,s7
        if ((pte = walk(pagetable, a, 1)) == 0)
    800006ec:	bfc9                	j	800006be <mappages+0x34>
        panic("mappages: size");
    800006ee:	00008517          	auipc	a0,0x8
    800006f2:	97a50513          	addi	a0,a0,-1670 # 80008068 <etext+0x68>
    800006f6:	00005097          	auipc	ra,0x5
    800006fa:	766080e7          	jalr	1894(ra) # 80005e5c <panic>
            panic("mappages: remap");
    800006fe:	00008517          	auipc	a0,0x8
    80000702:	97a50513          	addi	a0,a0,-1670 # 80008078 <etext+0x78>
    80000706:	00005097          	auipc	ra,0x5
    8000070a:	756080e7          	jalr	1878(ra) # 80005e5c <panic>
            return -1;
    8000070e:	557d                	li	a0,-1
        pa += PGSIZE;
    }
    return 0;
}
    80000710:	60a6                	ld	ra,72(sp)
    80000712:	6406                	ld	s0,64(sp)
    80000714:	74e2                	ld	s1,56(sp)
    80000716:	7942                	ld	s2,48(sp)
    80000718:	79a2                	ld	s3,40(sp)
    8000071a:	7a02                	ld	s4,32(sp)
    8000071c:	6ae2                	ld	s5,24(sp)
    8000071e:	6b42                	ld	s6,16(sp)
    80000720:	6ba2                	ld	s7,8(sp)
    80000722:	6161                	addi	sp,sp,80
    80000724:	8082                	ret
    return 0;
    80000726:	4501                	li	a0,0
    80000728:	b7e5                	j	80000710 <mappages+0x86>

000000008000072a <kvmmap>:
{
    8000072a:	1141                	addi	sp,sp,-16
    8000072c:	e406                	sd	ra,8(sp)
    8000072e:	e022                	sd	s0,0(sp)
    80000730:	0800                	addi	s0,sp,16
    80000732:	87b6                	mv	a5,a3
    if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000734:	86b2                	mv	a3,a2
    80000736:	863e                	mv	a2,a5
    80000738:	00000097          	auipc	ra,0x0
    8000073c:	f52080e7          	jalr	-174(ra) # 8000068a <mappages>
    80000740:	e509                	bnez	a0,8000074a <kvmmap+0x20>
}
    80000742:	60a2                	ld	ra,8(sp)
    80000744:	6402                	ld	s0,0(sp)
    80000746:	0141                	addi	sp,sp,16
    80000748:	8082                	ret
        panic("kvmmap");
    8000074a:	00008517          	auipc	a0,0x8
    8000074e:	93e50513          	addi	a0,a0,-1730 # 80008088 <etext+0x88>
    80000752:	00005097          	auipc	ra,0x5
    80000756:	70a080e7          	jalr	1802(ra) # 80005e5c <panic>

000000008000075a <kvmmake>:
{
    8000075a:	1101                	addi	sp,sp,-32
    8000075c:	ec06                	sd	ra,24(sp)
    8000075e:	e822                	sd	s0,16(sp)
    80000760:	e426                	sd	s1,8(sp)
    80000762:	e04a                	sd	s2,0(sp)
    80000764:	1000                	addi	s0,sp,32
    kpgtbl = (pagetable_t)kalloc();
    80000766:	00000097          	auipc	ra,0x0
    8000076a:	a40080e7          	jalr	-1472(ra) # 800001a6 <kalloc>
    8000076e:	84aa                	mv	s1,a0
    memset(kpgtbl, 0, PGSIZE);
    80000770:	6605                	lui	a2,0x1
    80000772:	4581                	li	a1,0
    80000774:	00000097          	auipc	ra,0x0
    80000778:	b4a080e7          	jalr	-1206(ra) # 800002be <memset>
    kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000077c:	4719                	li	a4,6
    8000077e:	6685                	lui	a3,0x1
    80000780:	10000637          	lui	a2,0x10000
    80000784:	100005b7          	lui	a1,0x10000
    80000788:	8526                	mv	a0,s1
    8000078a:	00000097          	auipc	ra,0x0
    8000078e:	fa0080e7          	jalr	-96(ra) # 8000072a <kvmmap>
    kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000792:	4719                	li	a4,6
    80000794:	6685                	lui	a3,0x1
    80000796:	10001637          	lui	a2,0x10001
    8000079a:	100015b7          	lui	a1,0x10001
    8000079e:	8526                	mv	a0,s1
    800007a0:	00000097          	auipc	ra,0x0
    800007a4:	f8a080e7          	jalr	-118(ra) # 8000072a <kvmmap>
    kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800007a8:	4719                	li	a4,6
    800007aa:	004006b7          	lui	a3,0x400
    800007ae:	0c000637          	lui	a2,0xc000
    800007b2:	0c0005b7          	lui	a1,0xc000
    800007b6:	8526                	mv	a0,s1
    800007b8:	00000097          	auipc	ra,0x0
    800007bc:	f72080e7          	jalr	-142(ra) # 8000072a <kvmmap>
    kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    800007c0:	00008917          	auipc	s2,0x8
    800007c4:	84090913          	addi	s2,s2,-1984 # 80008000 <etext>
    800007c8:	4729                	li	a4,10
    800007ca:	80008697          	auipc	a3,0x80008
    800007ce:	83668693          	addi	a3,a3,-1994 # 8000 <_entry-0x7fff8000>
    800007d2:	4605                	li	a2,1
    800007d4:	067e                	slli	a2,a2,0x1f
    800007d6:	85b2                	mv	a1,a2
    800007d8:	8526                	mv	a0,s1
    800007da:	00000097          	auipc	ra,0x0
    800007de:	f50080e7          	jalr	-176(ra) # 8000072a <kvmmap>
    kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext, PTE_R | PTE_W);
    800007e2:	4719                	li	a4,6
    800007e4:	46c5                	li	a3,17
    800007e6:	06ee                	slli	a3,a3,0x1b
    800007e8:	412686b3          	sub	a3,a3,s2
    800007ec:	864a                	mv	a2,s2
    800007ee:	85ca                	mv	a1,s2
    800007f0:	8526                	mv	a0,s1
    800007f2:	00000097          	auipc	ra,0x0
    800007f6:	f38080e7          	jalr	-200(ra) # 8000072a <kvmmap>
    kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800007fa:	4729                	li	a4,10
    800007fc:	6685                	lui	a3,0x1
    800007fe:	00007617          	auipc	a2,0x7
    80000802:	80260613          	addi	a2,a2,-2046 # 80007000 <_trampoline>
    80000806:	040005b7          	lui	a1,0x4000
    8000080a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000080c:	05b2                	slli	a1,a1,0xc
    8000080e:	8526                	mv	a0,s1
    80000810:	00000097          	auipc	ra,0x0
    80000814:	f1a080e7          	jalr	-230(ra) # 8000072a <kvmmap>
    proc_mapstacks(kpgtbl);
    80000818:	8526                	mv	a0,s1
    8000081a:	00000097          	auipc	ra,0x0
    8000081e:	61e080e7          	jalr	1566(ra) # 80000e38 <proc_mapstacks>
}
    80000822:	8526                	mv	a0,s1
    80000824:	60e2                	ld	ra,24(sp)
    80000826:	6442                	ld	s0,16(sp)
    80000828:	64a2                	ld	s1,8(sp)
    8000082a:	6902                	ld	s2,0(sp)
    8000082c:	6105                	addi	sp,sp,32
    8000082e:	8082                	ret

0000000080000830 <kvminit>:
{
    80000830:	1141                	addi	sp,sp,-16
    80000832:	e406                	sd	ra,8(sp)
    80000834:	e022                	sd	s0,0(sp)
    80000836:	0800                	addi	s0,sp,16
    kernel_pagetable = kvmmake();
    80000838:	00000097          	auipc	ra,0x0
    8000083c:	f22080e7          	jalr	-222(ra) # 8000075a <kvmmake>
    80000840:	00008797          	auipc	a5,0x8
    80000844:	08a7b423          	sd	a0,136(a5) # 800088c8 <kernel_pagetable>
}
    80000848:	60a2                	ld	ra,8(sp)
    8000084a:	6402                	ld	s0,0(sp)
    8000084c:	0141                	addi	sp,sp,16
    8000084e:	8082                	ret

0000000080000850 <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000850:	715d                	addi	sp,sp,-80
    80000852:	e486                	sd	ra,72(sp)
    80000854:	e0a2                	sd	s0,64(sp)
    80000856:	fc26                	sd	s1,56(sp)
    80000858:	f84a                	sd	s2,48(sp)
    8000085a:	f44e                	sd	s3,40(sp)
    8000085c:	f052                	sd	s4,32(sp)
    8000085e:	ec56                	sd	s5,24(sp)
    80000860:	e85a                	sd	s6,16(sp)
    80000862:	e45e                	sd	s7,8(sp)
    80000864:	0880                	addi	s0,sp,80
    uint64 a;
    pte_t *pte;

    if ((va % PGSIZE) != 0)
    80000866:	03459793          	slli	a5,a1,0x34
    8000086a:	e795                	bnez	a5,80000896 <uvmunmap+0x46>
    8000086c:	8a2a                	mv	s4,a0
    8000086e:	892e                	mv	s2,a1
    80000870:	8ab6                	mv	s5,a3
        panic("uvmunmap: not aligned");

    for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80000872:	0632                	slli	a2,a2,0xc
    80000874:	00b609b3          	add	s3,a2,a1
        if ((pte = walk(pagetable, a, 0)) == 0)
            panic("uvmunmap: walk");
        if ((*pte & PTE_V) == 0)
            panic("uvmunmap: not mapped");
        if (PTE_FLAGS(*pte) == PTE_V)
    80000878:	4b85                	li	s7,1
    for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8000087a:	6b05                	lui	s6,0x1
    8000087c:	0735e263          	bltu	a1,s3,800008e0 <uvmunmap+0x90>
            uint64 pa = PTE2PA(*pte);
            kfree((void *)pa);
        }
        *pte = 0;
    }
}
    80000880:	60a6                	ld	ra,72(sp)
    80000882:	6406                	ld	s0,64(sp)
    80000884:	74e2                	ld	s1,56(sp)
    80000886:	7942                	ld	s2,48(sp)
    80000888:	79a2                	ld	s3,40(sp)
    8000088a:	7a02                	ld	s4,32(sp)
    8000088c:	6ae2                	ld	s5,24(sp)
    8000088e:	6b42                	ld	s6,16(sp)
    80000890:	6ba2                	ld	s7,8(sp)
    80000892:	6161                	addi	sp,sp,80
    80000894:	8082                	ret
        panic("uvmunmap: not aligned");
    80000896:	00007517          	auipc	a0,0x7
    8000089a:	7fa50513          	addi	a0,a0,2042 # 80008090 <etext+0x90>
    8000089e:	00005097          	auipc	ra,0x5
    800008a2:	5be080e7          	jalr	1470(ra) # 80005e5c <panic>
            panic("uvmunmap: walk");
    800008a6:	00008517          	auipc	a0,0x8
    800008aa:	80250513          	addi	a0,a0,-2046 # 800080a8 <etext+0xa8>
    800008ae:	00005097          	auipc	ra,0x5
    800008b2:	5ae080e7          	jalr	1454(ra) # 80005e5c <panic>
            panic("uvmunmap: not mapped");
    800008b6:	00008517          	auipc	a0,0x8
    800008ba:	80250513          	addi	a0,a0,-2046 # 800080b8 <etext+0xb8>
    800008be:	00005097          	auipc	ra,0x5
    800008c2:	59e080e7          	jalr	1438(ra) # 80005e5c <panic>
            panic("uvmunmap: not a leaf");
    800008c6:	00008517          	auipc	a0,0x8
    800008ca:	80a50513          	addi	a0,a0,-2038 # 800080d0 <etext+0xd0>
    800008ce:	00005097          	auipc	ra,0x5
    800008d2:	58e080e7          	jalr	1422(ra) # 80005e5c <panic>
        *pte = 0;
    800008d6:	0004b023          	sd	zero,0(s1)
    for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    800008da:	995a                	add	s2,s2,s6
    800008dc:	fb3972e3          	bgeu	s2,s3,80000880 <uvmunmap+0x30>
        if ((pte = walk(pagetable, a, 0)) == 0)
    800008e0:	4601                	li	a2,0
    800008e2:	85ca                	mv	a1,s2
    800008e4:	8552                	mv	a0,s4
    800008e6:	00000097          	auipc	ra,0x0
    800008ea:	cbc080e7          	jalr	-836(ra) # 800005a2 <walk>
    800008ee:	84aa                	mv	s1,a0
    800008f0:	d95d                	beqz	a0,800008a6 <uvmunmap+0x56>
        if ((*pte & PTE_V) == 0)
    800008f2:	6108                	ld	a0,0(a0)
    800008f4:	00157793          	andi	a5,a0,1
    800008f8:	dfdd                	beqz	a5,800008b6 <uvmunmap+0x66>
        if (PTE_FLAGS(*pte) == PTE_V)
    800008fa:	3ff57793          	andi	a5,a0,1023
    800008fe:	fd7784e3          	beq	a5,s7,800008c6 <uvmunmap+0x76>
        if (do_free) {
    80000902:	fc0a8ae3          	beqz	s5,800008d6 <uvmunmap+0x86>
            uint64 pa = PTE2PA(*pte);
    80000906:	8129                	srli	a0,a0,0xa
            kfree((void *)pa);
    80000908:	0532                	slli	a0,a0,0xc
    8000090a:	fffff097          	auipc	ra,0xfffff
    8000090e:	712080e7          	jalr	1810(ra) # 8000001c <kfree>
    80000912:	b7d1                	j	800008d6 <uvmunmap+0x86>

0000000080000914 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t uvmcreate()
{
    80000914:	1101                	addi	sp,sp,-32
    80000916:	ec06                	sd	ra,24(sp)
    80000918:	e822                	sd	s0,16(sp)
    8000091a:	e426                	sd	s1,8(sp)
    8000091c:	1000                	addi	s0,sp,32
    pagetable_t pagetable;
    pagetable = (pagetable_t)kalloc();
    8000091e:	00000097          	auipc	ra,0x0
    80000922:	888080e7          	jalr	-1912(ra) # 800001a6 <kalloc>
    80000926:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80000928:	c519                	beqz	a0,80000936 <uvmcreate+0x22>
        return 0;
    memset(pagetable, 0, PGSIZE);
    8000092a:	6605                	lui	a2,0x1
    8000092c:	4581                	li	a1,0
    8000092e:	00000097          	auipc	ra,0x0
    80000932:	990080e7          	jalr	-1648(ra) # 800002be <memset>
    return pagetable;
}
    80000936:	8526                	mv	a0,s1
    80000938:	60e2                	ld	ra,24(sp)
    8000093a:	6442                	ld	s0,16(sp)
    8000093c:	64a2                	ld	s1,8(sp)
    8000093e:	6105                	addi	sp,sp,32
    80000940:	8082                	ret

0000000080000942 <uvmfirst>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000942:	7179                	addi	sp,sp,-48
    80000944:	f406                	sd	ra,40(sp)
    80000946:	f022                	sd	s0,32(sp)
    80000948:	ec26                	sd	s1,24(sp)
    8000094a:	e84a                	sd	s2,16(sp)
    8000094c:	e44e                	sd	s3,8(sp)
    8000094e:	e052                	sd	s4,0(sp)
    80000950:	1800                	addi	s0,sp,48
    char *mem;

    if (sz >= PGSIZE)
    80000952:	6785                	lui	a5,0x1
    80000954:	04f67863          	bgeu	a2,a5,800009a4 <uvmfirst+0x62>
    80000958:	8a2a                	mv	s4,a0
    8000095a:	89ae                	mv	s3,a1
    8000095c:	84b2                	mv	s1,a2
        panic("uvmfirst: more than a page");
    mem = kalloc();
    8000095e:	00000097          	auipc	ra,0x0
    80000962:	848080e7          	jalr	-1976(ra) # 800001a6 <kalloc>
    80000966:	892a                	mv	s2,a0
    memset(mem, 0, PGSIZE);
    80000968:	6605                	lui	a2,0x1
    8000096a:	4581                	li	a1,0
    8000096c:	00000097          	auipc	ra,0x0
    80000970:	952080e7          	jalr	-1710(ra) # 800002be <memset>
    mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    80000974:	4779                	li	a4,30
    80000976:	86ca                	mv	a3,s2
    80000978:	6605                	lui	a2,0x1
    8000097a:	4581                	li	a1,0
    8000097c:	8552                	mv	a0,s4
    8000097e:	00000097          	auipc	ra,0x0
    80000982:	d0c080e7          	jalr	-756(ra) # 8000068a <mappages>
    memmove(mem, src, sz);
    80000986:	8626                	mv	a2,s1
    80000988:	85ce                	mv	a1,s3
    8000098a:	854a                	mv	a0,s2
    8000098c:	00000097          	auipc	ra,0x0
    80000990:	98e080e7          	jalr	-1650(ra) # 8000031a <memmove>
}
    80000994:	70a2                	ld	ra,40(sp)
    80000996:	7402                	ld	s0,32(sp)
    80000998:	64e2                	ld	s1,24(sp)
    8000099a:	6942                	ld	s2,16(sp)
    8000099c:	69a2                	ld	s3,8(sp)
    8000099e:	6a02                	ld	s4,0(sp)
    800009a0:	6145                	addi	sp,sp,48
    800009a2:	8082                	ret
        panic("uvmfirst: more than a page");
    800009a4:	00007517          	auipc	a0,0x7
    800009a8:	74450513          	addi	a0,a0,1860 # 800080e8 <etext+0xe8>
    800009ac:	00005097          	auipc	ra,0x5
    800009b0:	4b0080e7          	jalr	1200(ra) # 80005e5c <panic>

00000000800009b4 <uvmdealloc>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64 uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800009b4:	1101                	addi	sp,sp,-32
    800009b6:	ec06                	sd	ra,24(sp)
    800009b8:	e822                	sd	s0,16(sp)
    800009ba:	e426                	sd	s1,8(sp)
    800009bc:	1000                	addi	s0,sp,32
    if (newsz >= oldsz)
        return oldsz;
    800009be:	84ae                	mv	s1,a1
    if (newsz >= oldsz)
    800009c0:	00b67d63          	bgeu	a2,a1,800009da <uvmdealloc+0x26>
    800009c4:	84b2                	mv	s1,a2

    if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    800009c6:	6785                	lui	a5,0x1
    800009c8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009ca:	00f60733          	add	a4,a2,a5
    800009ce:	76fd                	lui	a3,0xfffff
    800009d0:	8f75                	and	a4,a4,a3
    800009d2:	97ae                	add	a5,a5,a1
    800009d4:	8ff5                	and	a5,a5,a3
    800009d6:	00f76863          	bltu	a4,a5,800009e6 <uvmdealloc+0x32>
        int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
        uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    }

    return newsz;
}
    800009da:	8526                	mv	a0,s1
    800009dc:	60e2                	ld	ra,24(sp)
    800009de:	6442                	ld	s0,16(sp)
    800009e0:	64a2                	ld	s1,8(sp)
    800009e2:	6105                	addi	sp,sp,32
    800009e4:	8082                	ret
        int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800009e6:	8f99                	sub	a5,a5,a4
    800009e8:	83b1                	srli	a5,a5,0xc
        uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800009ea:	4685                	li	a3,1
    800009ec:	0007861b          	sext.w	a2,a5
    800009f0:	85ba                	mv	a1,a4
    800009f2:	00000097          	auipc	ra,0x0
    800009f6:	e5e080e7          	jalr	-418(ra) # 80000850 <uvmunmap>
    800009fa:	b7c5                	j	800009da <uvmdealloc+0x26>

00000000800009fc <uvmalloc>:
    if (newsz < oldsz)
    800009fc:	0ab66563          	bltu	a2,a1,80000aa6 <uvmalloc+0xaa>
{
    80000a00:	7139                	addi	sp,sp,-64
    80000a02:	fc06                	sd	ra,56(sp)
    80000a04:	f822                	sd	s0,48(sp)
    80000a06:	f426                	sd	s1,40(sp)
    80000a08:	f04a                	sd	s2,32(sp)
    80000a0a:	ec4e                	sd	s3,24(sp)
    80000a0c:	e852                	sd	s4,16(sp)
    80000a0e:	e456                	sd	s5,8(sp)
    80000a10:	e05a                	sd	s6,0(sp)
    80000a12:	0080                	addi	s0,sp,64
    80000a14:	8aaa                	mv	s5,a0
    80000a16:	8a32                	mv	s4,a2
    oldsz = PGROUNDUP(oldsz);
    80000a18:	6785                	lui	a5,0x1
    80000a1a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a1c:	95be                	add	a1,a1,a5
    80000a1e:	77fd                	lui	a5,0xfffff
    80000a20:	00f5f9b3          	and	s3,a1,a5
    for (a = oldsz; a < newsz; a += PGSIZE) {
    80000a24:	08c9f363          	bgeu	s3,a2,80000aaa <uvmalloc+0xae>
    80000a28:	894e                	mv	s2,s3
        if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) != 0) {
    80000a2a:	0126eb13          	ori	s6,a3,18
        mem = kalloc();
    80000a2e:	fffff097          	auipc	ra,0xfffff
    80000a32:	778080e7          	jalr	1912(ra) # 800001a6 <kalloc>
    80000a36:	84aa                	mv	s1,a0
        if (mem == 0) {
    80000a38:	c51d                	beqz	a0,80000a66 <uvmalloc+0x6a>
        memset(mem, 0, PGSIZE);
    80000a3a:	6605                	lui	a2,0x1
    80000a3c:	4581                	li	a1,0
    80000a3e:	00000097          	auipc	ra,0x0
    80000a42:	880080e7          	jalr	-1920(ra) # 800002be <memset>
        if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) != 0) {
    80000a46:	875a                	mv	a4,s6
    80000a48:	86a6                	mv	a3,s1
    80000a4a:	6605                	lui	a2,0x1
    80000a4c:	85ca                	mv	a1,s2
    80000a4e:	8556                	mv	a0,s5
    80000a50:	00000097          	auipc	ra,0x0
    80000a54:	c3a080e7          	jalr	-966(ra) # 8000068a <mappages>
    80000a58:	e90d                	bnez	a0,80000a8a <uvmalloc+0x8e>
    for (a = oldsz; a < newsz; a += PGSIZE) {
    80000a5a:	6785                	lui	a5,0x1
    80000a5c:	993e                	add	s2,s2,a5
    80000a5e:	fd4968e3          	bltu	s2,s4,80000a2e <uvmalloc+0x32>
    return newsz;
    80000a62:	8552                	mv	a0,s4
    80000a64:	a809                	j	80000a76 <uvmalloc+0x7a>
            uvmdealloc(pagetable, a, oldsz);
    80000a66:	864e                	mv	a2,s3
    80000a68:	85ca                	mv	a1,s2
    80000a6a:	8556                	mv	a0,s5
    80000a6c:	00000097          	auipc	ra,0x0
    80000a70:	f48080e7          	jalr	-184(ra) # 800009b4 <uvmdealloc>
            return 0;
    80000a74:	4501                	li	a0,0
}
    80000a76:	70e2                	ld	ra,56(sp)
    80000a78:	7442                	ld	s0,48(sp)
    80000a7a:	74a2                	ld	s1,40(sp)
    80000a7c:	7902                	ld	s2,32(sp)
    80000a7e:	69e2                	ld	s3,24(sp)
    80000a80:	6a42                	ld	s4,16(sp)
    80000a82:	6aa2                	ld	s5,8(sp)
    80000a84:	6b02                	ld	s6,0(sp)
    80000a86:	6121                	addi	sp,sp,64
    80000a88:	8082                	ret
            kfree(mem);
    80000a8a:	8526                	mv	a0,s1
    80000a8c:	fffff097          	auipc	ra,0xfffff
    80000a90:	590080e7          	jalr	1424(ra) # 8000001c <kfree>
            uvmdealloc(pagetable, a, oldsz);
    80000a94:	864e                	mv	a2,s3
    80000a96:	85ca                	mv	a1,s2
    80000a98:	8556                	mv	a0,s5
    80000a9a:	00000097          	auipc	ra,0x0
    80000a9e:	f1a080e7          	jalr	-230(ra) # 800009b4 <uvmdealloc>
            return 0;
    80000aa2:	4501                	li	a0,0
    80000aa4:	bfc9                	j	80000a76 <uvmalloc+0x7a>
        return oldsz;
    80000aa6:	852e                	mv	a0,a1
}
    80000aa8:	8082                	ret
    return newsz;
    80000aaa:	8532                	mv	a0,a2
    80000aac:	b7e9                	j	80000a76 <uvmalloc+0x7a>

0000000080000aae <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
    80000aae:	7179                	addi	sp,sp,-48
    80000ab0:	f406                	sd	ra,40(sp)
    80000ab2:	f022                	sd	s0,32(sp)
    80000ab4:	ec26                	sd	s1,24(sp)
    80000ab6:	e84a                	sd	s2,16(sp)
    80000ab8:	e44e                	sd	s3,8(sp)
    80000aba:	e052                	sd	s4,0(sp)
    80000abc:	1800                	addi	s0,sp,48
    80000abe:	8a2a                	mv	s4,a0
    // there are 2^9 = 512 PTEs in a page table.
    for (int i = 0; i < 512; i++) {
    80000ac0:	84aa                	mv	s1,a0
    80000ac2:	6905                	lui	s2,0x1
    80000ac4:	992a                	add	s2,s2,a0
        pte_t pte = pagetable[i];
        if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000ac6:	4985                	li	s3,1
    80000ac8:	a829                	j	80000ae2 <freewalk+0x34>
            // this PTE points to a lower-level page table.
            uint64 child = PTE2PA(pte);
    80000aca:	83a9                	srli	a5,a5,0xa
            freewalk((pagetable_t)child);
    80000acc:	00c79513          	slli	a0,a5,0xc
    80000ad0:	00000097          	auipc	ra,0x0
    80000ad4:	fde080e7          	jalr	-34(ra) # 80000aae <freewalk>
            pagetable[i] = 0;
    80000ad8:	0004b023          	sd	zero,0(s1)
    for (int i = 0; i < 512; i++) {
    80000adc:	04a1                	addi	s1,s1,8
    80000ade:	03248163          	beq	s1,s2,80000b00 <freewalk+0x52>
        pte_t pte = pagetable[i];
    80000ae2:	609c                	ld	a5,0(s1)
        if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000ae4:	00f7f713          	andi	a4,a5,15
    80000ae8:	ff3701e3          	beq	a4,s3,80000aca <freewalk+0x1c>
        }
        else if (pte & PTE_V) {
    80000aec:	8b85                	andi	a5,a5,1
    80000aee:	d7fd                	beqz	a5,80000adc <freewalk+0x2e>
            panic("freewalk: leaf");
    80000af0:	00007517          	auipc	a0,0x7
    80000af4:	61850513          	addi	a0,a0,1560 # 80008108 <etext+0x108>
    80000af8:	00005097          	auipc	ra,0x5
    80000afc:	364080e7          	jalr	868(ra) # 80005e5c <panic>
        }
    }
    kfree((void *)pagetable);
    80000b00:	8552                	mv	a0,s4
    80000b02:	fffff097          	auipc	ra,0xfffff
    80000b06:	51a080e7          	jalr	1306(ra) # 8000001c <kfree>
}
    80000b0a:	70a2                	ld	ra,40(sp)
    80000b0c:	7402                	ld	s0,32(sp)
    80000b0e:	64e2                	ld	s1,24(sp)
    80000b10:	6942                	ld	s2,16(sp)
    80000b12:	69a2                	ld	s3,8(sp)
    80000b14:	6a02                	ld	s4,0(sp)
    80000b16:	6145                	addi	sp,sp,48
    80000b18:	8082                	ret

0000000080000b1a <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000b1a:	1101                	addi	sp,sp,-32
    80000b1c:	ec06                	sd	ra,24(sp)
    80000b1e:	e822                	sd	s0,16(sp)
    80000b20:	e426                	sd	s1,8(sp)
    80000b22:	1000                	addi	s0,sp,32
    80000b24:	84aa                	mv	s1,a0
    if (sz > 0)
    80000b26:	e999                	bnez	a1,80000b3c <uvmfree+0x22>
        uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    freewalk(pagetable);
    80000b28:	8526                	mv	a0,s1
    80000b2a:	00000097          	auipc	ra,0x0
    80000b2e:	f84080e7          	jalr	-124(ra) # 80000aae <freewalk>
}
    80000b32:	60e2                	ld	ra,24(sp)
    80000b34:	6442                	ld	s0,16(sp)
    80000b36:	64a2                	ld	s1,8(sp)
    80000b38:	6105                	addi	sp,sp,32
    80000b3a:	8082                	ret
        uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000b3c:	6785                	lui	a5,0x1
    80000b3e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000b40:	95be                	add	a1,a1,a5
    80000b42:	4685                	li	a3,1
    80000b44:	00c5d613          	srli	a2,a1,0xc
    80000b48:	4581                	li	a1,0
    80000b4a:	00000097          	auipc	ra,0x0
    80000b4e:	d06080e7          	jalr	-762(ra) # 80000850 <uvmunmap>
    80000b52:	bfd9                	j	80000b28 <uvmfree+0xe>

0000000080000b54 <uvmcopy>:
{
    pte_t *pte;
    uint64 pa, i;
    uint flags;

    for (i = 0; i < sz; i += PGSIZE) {
    80000b54:	ca5d                	beqz	a2,80000c0a <uvmcopy+0xb6>
{
    80000b56:	7139                	addi	sp,sp,-64
    80000b58:	fc06                	sd	ra,56(sp)
    80000b5a:	f822                	sd	s0,48(sp)
    80000b5c:	f426                	sd	s1,40(sp)
    80000b5e:	f04a                	sd	s2,32(sp)
    80000b60:	ec4e                	sd	s3,24(sp)
    80000b62:	e852                	sd	s4,16(sp)
    80000b64:	e456                	sd	s5,8(sp)
    80000b66:	0080                	addi	s0,sp,64
    80000b68:	8aaa                	mv	s5,a0
    80000b6a:	89ae                	mv	s3,a1
    80000b6c:	8a32                	mv	s4,a2
    for (i = 0; i < sz; i += PGSIZE) {
    80000b6e:	4901                	li	s2,0
        if ((pte = walk(old, i, 0)) == 0)
    80000b70:	4601                	li	a2,0
    80000b72:	85ca                	mv	a1,s2
    80000b74:	8556                	mv	a0,s5
    80000b76:	00000097          	auipc	ra,0x0
    80000b7a:	a2c080e7          	jalr	-1492(ra) # 800005a2 <walk>
    80000b7e:	c139                	beqz	a0,80000bc4 <uvmcopy+0x70>
            panic("uvmcopy: pte should exist");
        if ((*pte & PTE_V) == 0)
    80000b80:	6118                	ld	a4,0(a0)
    80000b82:	00177793          	andi	a5,a4,1
    80000b86:	c7b9                	beqz	a5,80000bd4 <uvmcopy+0x80>
            panic("uvmcopy: page not present");

        pa = PTE2PA(*pte);
    80000b88:	00a75493          	srli	s1,a4,0xa
    80000b8c:	04b2                	slli	s1,s1,0xc

        *pte = (*pte & ~PTE_W) | PTE_COW; // 将所有的pte的写权限都设置为0，PTE_COW设置为1
    80000b8e:	efb77713          	andi	a4,a4,-261
    80000b92:	10076713          	ori	a4,a4,256
    80000b96:	e118                	sd	a4,0(a0)

        flags = PTE_FLAGS(*pte);

        if (mappages(new, i, PGSIZE, pa, flags) != 0) {
    80000b98:	3fb77713          	andi	a4,a4,1019
    80000b9c:	86a6                	mv	a3,s1
    80000b9e:	6605                	lui	a2,0x1
    80000ba0:	85ca                	mv	a1,s2
    80000ba2:	854e                	mv	a0,s3
    80000ba4:	00000097          	auipc	ra,0x0
    80000ba8:	ae6080e7          	jalr	-1306(ra) # 8000068a <mappages>
    80000bac:	ed05                	bnez	a0,80000be4 <uvmcopy+0x90>
            goto err;
        }

        // 索引计数加1
        if (AddPGRefCount((void *)pa)) {
    80000bae:	8526                	mv	a0,s1
    80000bb0:	fffff097          	auipc	ra,0xfffff
    80000bb4:	684080e7          	jalr	1668(ra) # 80000234 <AddPGRefCount>
    80000bb8:	e515                	bnez	a0,80000be4 <uvmcopy+0x90>
    for (i = 0; i < sz; i += PGSIZE) {
    80000bba:	6785                	lui	a5,0x1
    80000bbc:	993e                	add	s2,s2,a5
    80000bbe:	fb4969e3          	bltu	s2,s4,80000b70 <uvmcopy+0x1c>
    80000bc2:	a81d                	j	80000bf8 <uvmcopy+0xa4>
            panic("uvmcopy: pte should exist");
    80000bc4:	00007517          	auipc	a0,0x7
    80000bc8:	55450513          	addi	a0,a0,1364 # 80008118 <etext+0x118>
    80000bcc:	00005097          	auipc	ra,0x5
    80000bd0:	290080e7          	jalr	656(ra) # 80005e5c <panic>
            panic("uvmcopy: page not present");
    80000bd4:	00007517          	auipc	a0,0x7
    80000bd8:	56450513          	addi	a0,a0,1380 # 80008138 <etext+0x138>
    80000bdc:	00005097          	auipc	ra,0x5
    80000be0:	280080e7          	jalr	640(ra) # 80005e5c <panic>
        }
    }
    return 0;

err:
    uvmunmap(new, 0, i / PGSIZE, 1);
    80000be4:	4685                	li	a3,1
    80000be6:	00c95613          	srli	a2,s2,0xc
    80000bea:	4581                	li	a1,0
    80000bec:	854e                	mv	a0,s3
    80000bee:	00000097          	auipc	ra,0x0
    80000bf2:	c62080e7          	jalr	-926(ra) # 80000850 <uvmunmap>
    return -1;
    80000bf6:	557d                	li	a0,-1
}
    80000bf8:	70e2                	ld	ra,56(sp)
    80000bfa:	7442                	ld	s0,48(sp)
    80000bfc:	74a2                	ld	s1,40(sp)
    80000bfe:	7902                	ld	s2,32(sp)
    80000c00:	69e2                	ld	s3,24(sp)
    80000c02:	6a42                	ld	s4,16(sp)
    80000c04:	6aa2                	ld	s5,8(sp)
    80000c06:	6121                	addi	sp,sp,64
    80000c08:	8082                	ret
    return 0;
    80000c0a:	4501                	li	a0,0
}
    80000c0c:	8082                	ret

0000000080000c0e <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va)
{
    80000c0e:	1141                	addi	sp,sp,-16
    80000c10:	e406                	sd	ra,8(sp)
    80000c12:	e022                	sd	s0,0(sp)
    80000c14:	0800                	addi	s0,sp,16
    pte_t *pte;

    pte = walk(pagetable, va, 0);
    80000c16:	4601                	li	a2,0
    80000c18:	00000097          	auipc	ra,0x0
    80000c1c:	98a080e7          	jalr	-1654(ra) # 800005a2 <walk>
    if (pte == 0)
    80000c20:	c901                	beqz	a0,80000c30 <uvmclear+0x22>
        panic("uvmclear");
    *pte &= ~PTE_U;
    80000c22:	611c                	ld	a5,0(a0)
    80000c24:	9bbd                	andi	a5,a5,-17
    80000c26:	e11c                	sd	a5,0(a0)
}
    80000c28:	60a2                	ld	ra,8(sp)
    80000c2a:	6402                	ld	s0,0(sp)
    80000c2c:	0141                	addi	sp,sp,16
    80000c2e:	8082                	ret
        panic("uvmclear");
    80000c30:	00007517          	auipc	a0,0x7
    80000c34:	52850513          	addi	a0,a0,1320 # 80008158 <etext+0x158>
    80000c38:	00005097          	auipc	ra,0x5
    80000c3c:	224080e7          	jalr	548(ra) # 80005e5c <panic>

0000000080000c40 <copyout>:
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
    uint64 n, va0, pa0;

    while (len > 0) {
    80000c40:	cec1                	beqz	a3,80000cd8 <copyout+0x98>
{
    80000c42:	711d                	addi	sp,sp,-96
    80000c44:	ec86                	sd	ra,88(sp)
    80000c46:	e8a2                	sd	s0,80(sp)
    80000c48:	e4a6                	sd	s1,72(sp)
    80000c4a:	e0ca                	sd	s2,64(sp)
    80000c4c:	fc4e                	sd	s3,56(sp)
    80000c4e:	f852                	sd	s4,48(sp)
    80000c50:	f456                	sd	s5,40(sp)
    80000c52:	f05a                	sd	s6,32(sp)
    80000c54:	ec5e                	sd	s7,24(sp)
    80000c56:	e862                	sd	s8,16(sp)
    80000c58:	e466                	sd	s9,8(sp)
    80000c5a:	e06a                	sd	s10,0(sp)
    80000c5c:	1080                	addi	s0,sp,96
    80000c5e:	8baa                	mv	s7,a0
    80000c60:	892e                	mv	s2,a1
    80000c62:	8b32                	mv	s6,a2
    80000c64:	8ab6                	mv	s5,a3
        va0 = PGROUNDDOWN(dstva);
    80000c66:	7d7d                	lui	s10,0xfffff
        pa0 = walkaddr(pagetable, va0);

        // 若是COW页，则要分配新的物理页再复制
        if (isCOWPG(pagetable, va0) == 1) {
    80000c68:	4c85                	li	s9,1
            pa0 = (uint64)allocCOWPG(pagetable, va0);
        }

        if (pa0 == 0)
            return -1;
        n = PGSIZE - (dstva - va0);
    80000c6a:	6c05                	lui	s8,0x1
    80000c6c:	a815                	j	80000ca0 <copyout+0x60>
            pa0 = (uint64)allocCOWPG(pagetable, va0);
    80000c6e:	85ce                	mv	a1,s3
    80000c70:	855e                	mv	a0,s7
    80000c72:	00001097          	auipc	ra,0x1
    80000c76:	276080e7          	jalr	630(ra) # 80001ee8 <allocCOWPG>
    80000c7a:	8a2a                	mv	s4,a0
    80000c7c:	a099                	j	80000cc2 <copyout+0x82>
        if (n > len)
            n = len;
        memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c7e:	41390533          	sub	a0,s2,s3
    80000c82:	0004861b          	sext.w	a2,s1
    80000c86:	85da                	mv	a1,s6
    80000c88:	9552                	add	a0,a0,s4
    80000c8a:	fffff097          	auipc	ra,0xfffff
    80000c8e:	690080e7          	jalr	1680(ra) # 8000031a <memmove>

        len -= n;
    80000c92:	409a8ab3          	sub	s5,s5,s1
        src += n;
    80000c96:	9b26                	add	s6,s6,s1
        dstva = va0 + PGSIZE;
    80000c98:	01898933          	add	s2,s3,s8
    while (len > 0) {
    80000c9c:	020a8c63          	beqz	s5,80000cd4 <copyout+0x94>
        va0 = PGROUNDDOWN(dstva);
    80000ca0:	01a979b3          	and	s3,s2,s10
        pa0 = walkaddr(pagetable, va0);
    80000ca4:	85ce                	mv	a1,s3
    80000ca6:	855e                	mv	a0,s7
    80000ca8:	00000097          	auipc	ra,0x0
    80000cac:	9a0080e7          	jalr	-1632(ra) # 80000648 <walkaddr>
    80000cb0:	8a2a                	mv	s4,a0
        if (isCOWPG(pagetable, va0) == 1) {
    80000cb2:	85ce                	mv	a1,s3
    80000cb4:	855e                	mv	a0,s7
    80000cb6:	00001097          	auipc	ra,0x1
    80000cba:	1f8080e7          	jalr	504(ra) # 80001eae <isCOWPG>
    80000cbe:	fb9508e3          	beq	a0,s9,80000c6e <copyout+0x2e>
        if (pa0 == 0)
    80000cc2:	000a0d63          	beqz	s4,80000cdc <copyout+0x9c>
        n = PGSIZE - (dstva - va0);
    80000cc6:	412984b3          	sub	s1,s3,s2
    80000cca:	94e2                	add	s1,s1,s8
    80000ccc:	fa9af9e3          	bgeu	s5,s1,80000c7e <copyout+0x3e>
    80000cd0:	84d6                	mv	s1,s5
    80000cd2:	b775                	j	80000c7e <copyout+0x3e>
    }
    return 0;
    80000cd4:	4501                	li	a0,0
    80000cd6:	a021                	j	80000cde <copyout+0x9e>
    80000cd8:	4501                	li	a0,0
}
    80000cda:	8082                	ret
            return -1;
    80000cdc:	557d                	li	a0,-1
}
    80000cde:	60e6                	ld	ra,88(sp)
    80000ce0:	6446                	ld	s0,80(sp)
    80000ce2:	64a6                	ld	s1,72(sp)
    80000ce4:	6906                	ld	s2,64(sp)
    80000ce6:	79e2                	ld	s3,56(sp)
    80000ce8:	7a42                	ld	s4,48(sp)
    80000cea:	7aa2                	ld	s5,40(sp)
    80000cec:	7b02                	ld	s6,32(sp)
    80000cee:	6be2                	ld	s7,24(sp)
    80000cf0:	6c42                	ld	s8,16(sp)
    80000cf2:	6ca2                	ld	s9,8(sp)
    80000cf4:	6d02                	ld	s10,0(sp)
    80000cf6:	6125                	addi	sp,sp,96
    80000cf8:	8082                	ret

0000000080000cfa <copyin>:
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
    uint64 n, va0, pa0;

    while (len > 0) {
    80000cfa:	caa5                	beqz	a3,80000d6a <copyin+0x70>
{
    80000cfc:	715d                	addi	sp,sp,-80
    80000cfe:	e486                	sd	ra,72(sp)
    80000d00:	e0a2                	sd	s0,64(sp)
    80000d02:	fc26                	sd	s1,56(sp)
    80000d04:	f84a                	sd	s2,48(sp)
    80000d06:	f44e                	sd	s3,40(sp)
    80000d08:	f052                	sd	s4,32(sp)
    80000d0a:	ec56                	sd	s5,24(sp)
    80000d0c:	e85a                	sd	s6,16(sp)
    80000d0e:	e45e                	sd	s7,8(sp)
    80000d10:	e062                	sd	s8,0(sp)
    80000d12:	0880                	addi	s0,sp,80
    80000d14:	8b2a                	mv	s6,a0
    80000d16:	8a2e                	mv	s4,a1
    80000d18:	8c32                	mv	s8,a2
    80000d1a:	89b6                	mv	s3,a3
        va0 = PGROUNDDOWN(srcva);
    80000d1c:	7bfd                	lui	s7,0xfffff
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0)
            return -1;
        n = PGSIZE - (srcva - va0);
    80000d1e:	6a85                	lui	s5,0x1
    80000d20:	a01d                	j	80000d46 <copyin+0x4c>
        if (n > len)
            n = len;
        memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000d22:	018505b3          	add	a1,a0,s8
    80000d26:	0004861b          	sext.w	a2,s1
    80000d2a:	412585b3          	sub	a1,a1,s2
    80000d2e:	8552                	mv	a0,s4
    80000d30:	fffff097          	auipc	ra,0xfffff
    80000d34:	5ea080e7          	jalr	1514(ra) # 8000031a <memmove>

        len -= n;
    80000d38:	409989b3          	sub	s3,s3,s1
        dst += n;
    80000d3c:	9a26                	add	s4,s4,s1
        srcva = va0 + PGSIZE;
    80000d3e:	01590c33          	add	s8,s2,s5
    while (len > 0) {
    80000d42:	02098263          	beqz	s3,80000d66 <copyin+0x6c>
        va0 = PGROUNDDOWN(srcva);
    80000d46:	017c7933          	and	s2,s8,s7
        pa0 = walkaddr(pagetable, va0);
    80000d4a:	85ca                	mv	a1,s2
    80000d4c:	855a                	mv	a0,s6
    80000d4e:	00000097          	auipc	ra,0x0
    80000d52:	8fa080e7          	jalr	-1798(ra) # 80000648 <walkaddr>
        if (pa0 == 0)
    80000d56:	cd01                	beqz	a0,80000d6e <copyin+0x74>
        n = PGSIZE - (srcva - va0);
    80000d58:	418904b3          	sub	s1,s2,s8
    80000d5c:	94d6                	add	s1,s1,s5
    80000d5e:	fc99f2e3          	bgeu	s3,s1,80000d22 <copyin+0x28>
    80000d62:	84ce                	mv	s1,s3
    80000d64:	bf7d                	j	80000d22 <copyin+0x28>
    }
    return 0;
    80000d66:	4501                	li	a0,0
    80000d68:	a021                	j	80000d70 <copyin+0x76>
    80000d6a:	4501                	li	a0,0
}
    80000d6c:	8082                	ret
            return -1;
    80000d6e:	557d                	li	a0,-1
}
    80000d70:	60a6                	ld	ra,72(sp)
    80000d72:	6406                	ld	s0,64(sp)
    80000d74:	74e2                	ld	s1,56(sp)
    80000d76:	7942                	ld	s2,48(sp)
    80000d78:	79a2                	ld	s3,40(sp)
    80000d7a:	7a02                	ld	s4,32(sp)
    80000d7c:	6ae2                	ld	s5,24(sp)
    80000d7e:	6b42                	ld	s6,16(sp)
    80000d80:	6ba2                	ld	s7,8(sp)
    80000d82:	6c02                	ld	s8,0(sp)
    80000d84:	6161                	addi	sp,sp,80
    80000d86:	8082                	ret

0000000080000d88 <copyinstr>:
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    uint64 n, va0, pa0;
    int got_null = 0;

    while (got_null == 0 && max > 0) {
    80000d88:	c2dd                	beqz	a3,80000e2e <copyinstr+0xa6>
{
    80000d8a:	715d                	addi	sp,sp,-80
    80000d8c:	e486                	sd	ra,72(sp)
    80000d8e:	e0a2                	sd	s0,64(sp)
    80000d90:	fc26                	sd	s1,56(sp)
    80000d92:	f84a                	sd	s2,48(sp)
    80000d94:	f44e                	sd	s3,40(sp)
    80000d96:	f052                	sd	s4,32(sp)
    80000d98:	ec56                	sd	s5,24(sp)
    80000d9a:	e85a                	sd	s6,16(sp)
    80000d9c:	e45e                	sd	s7,8(sp)
    80000d9e:	0880                	addi	s0,sp,80
    80000da0:	8a2a                	mv	s4,a0
    80000da2:	8b2e                	mv	s6,a1
    80000da4:	8bb2                	mv	s7,a2
    80000da6:	84b6                	mv	s1,a3
        va0 = PGROUNDDOWN(srcva);
    80000da8:	7afd                	lui	s5,0xfffff
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0)
            return -1;
        n = PGSIZE - (srcva - va0);
    80000daa:	6985                	lui	s3,0x1
    80000dac:	a02d                	j	80000dd6 <copyinstr+0x4e>
            n = max;

        char *p = (char *)(pa0 + (srcva - va0));
        while (n > 0) {
            if (*p == '\0') {
                *dst = '\0';
    80000dae:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000db2:	4785                	li	a5,1
            dst++;
        }

        srcva = va0 + PGSIZE;
    }
    if (got_null) {
    80000db4:	37fd                	addiw	a5,a5,-1
    80000db6:	0007851b          	sext.w	a0,a5
        return 0;
    }
    else {
        return -1;
    }
}
    80000dba:	60a6                	ld	ra,72(sp)
    80000dbc:	6406                	ld	s0,64(sp)
    80000dbe:	74e2                	ld	s1,56(sp)
    80000dc0:	7942                	ld	s2,48(sp)
    80000dc2:	79a2                	ld	s3,40(sp)
    80000dc4:	7a02                	ld	s4,32(sp)
    80000dc6:	6ae2                	ld	s5,24(sp)
    80000dc8:	6b42                	ld	s6,16(sp)
    80000dca:	6ba2                	ld	s7,8(sp)
    80000dcc:	6161                	addi	sp,sp,80
    80000dce:	8082                	ret
        srcva = va0 + PGSIZE;
    80000dd0:	01390bb3          	add	s7,s2,s3
    while (got_null == 0 && max > 0) {
    80000dd4:	c8a9                	beqz	s1,80000e26 <copyinstr+0x9e>
        va0 = PGROUNDDOWN(srcva);
    80000dd6:	015bf933          	and	s2,s7,s5
        pa0 = walkaddr(pagetable, va0);
    80000dda:	85ca                	mv	a1,s2
    80000ddc:	8552                	mv	a0,s4
    80000dde:	00000097          	auipc	ra,0x0
    80000de2:	86a080e7          	jalr	-1942(ra) # 80000648 <walkaddr>
        if (pa0 == 0)
    80000de6:	c131                	beqz	a0,80000e2a <copyinstr+0xa2>
        n = PGSIZE - (srcva - va0);
    80000de8:	417906b3          	sub	a3,s2,s7
    80000dec:	96ce                	add	a3,a3,s3
    80000dee:	00d4f363          	bgeu	s1,a3,80000df4 <copyinstr+0x6c>
    80000df2:	86a6                	mv	a3,s1
        char *p = (char *)(pa0 + (srcva - va0));
    80000df4:	955e                	add	a0,a0,s7
    80000df6:	41250533          	sub	a0,a0,s2
        while (n > 0) {
    80000dfa:	daf9                	beqz	a3,80000dd0 <copyinstr+0x48>
    80000dfc:	87da                	mv	a5,s6
            if (*p == '\0') {
    80000dfe:	41650633          	sub	a2,a0,s6
    80000e02:	fff48593          	addi	a1,s1,-1
    80000e06:	95da                	add	a1,a1,s6
        while (n > 0) {
    80000e08:	96da                	add	a3,a3,s6
            if (*p == '\0') {
    80000e0a:	00f60733          	add	a4,a2,a5
    80000e0e:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7fdbd280>
    80000e12:	df51                	beqz	a4,80000dae <copyinstr+0x26>
                *dst = *p;
    80000e14:	00e78023          	sb	a4,0(a5)
            --max;
    80000e18:	40f584b3          	sub	s1,a1,a5
            dst++;
    80000e1c:	0785                	addi	a5,a5,1
        while (n > 0) {
    80000e1e:	fed796e3          	bne	a5,a3,80000e0a <copyinstr+0x82>
            dst++;
    80000e22:	8b3e                	mv	s6,a5
    80000e24:	b775                	j	80000dd0 <copyinstr+0x48>
    80000e26:	4781                	li	a5,0
    80000e28:	b771                	j	80000db4 <copyinstr+0x2c>
            return -1;
    80000e2a:	557d                	li	a0,-1
    80000e2c:	b779                	j	80000dba <copyinstr+0x32>
    int got_null = 0;
    80000e2e:	4781                	li	a5,0
    if (got_null) {
    80000e30:	37fd                	addiw	a5,a5,-1
    80000e32:	0007851b          	sext.w	a0,a5
}
    80000e36:	8082                	ret

0000000080000e38 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    80000e38:	7139                	addi	sp,sp,-64
    80000e3a:	fc06                	sd	ra,56(sp)
    80000e3c:	f822                	sd	s0,48(sp)
    80000e3e:	f426                	sd	s1,40(sp)
    80000e40:	f04a                	sd	s2,32(sp)
    80000e42:	ec4e                	sd	s3,24(sp)
    80000e44:	e852                	sd	s4,16(sp)
    80000e46:	e456                	sd	s5,8(sp)
    80000e48:	e05a                	sd	s6,0(sp)
    80000e4a:	0080                	addi	s0,sp,64
    80000e4c:	89aa                	mv	s3,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++) {
    80000e4e:	00228497          	auipc	s1,0x228
    80000e52:	f0a48493          	addi	s1,s1,-246 # 80228d58 <proc>
        char *pa = kalloc();
        if (pa == 0)
            panic("kalloc");
        uint64 va = KSTACK((int)(p - proc));
    80000e56:	8b26                	mv	s6,s1
    80000e58:	00007a97          	auipc	s5,0x7
    80000e5c:	1a8a8a93          	addi	s5,s5,424 # 80008000 <etext>
    80000e60:	04000937          	lui	s2,0x4000
    80000e64:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000e66:	0932                	slli	s2,s2,0xc
    for (p = proc; p < &proc[NPROC]; p++) {
    80000e68:	0022ea17          	auipc	s4,0x22e
    80000e6c:	8f0a0a13          	addi	s4,s4,-1808 # 8022e758 <tickslock>
        char *pa = kalloc();
    80000e70:	fffff097          	auipc	ra,0xfffff
    80000e74:	336080e7          	jalr	822(ra) # 800001a6 <kalloc>
    80000e78:	862a                	mv	a2,a0
        if (pa == 0)
    80000e7a:	c131                	beqz	a0,80000ebe <proc_mapstacks+0x86>
        uint64 va = KSTACK((int)(p - proc));
    80000e7c:	416485b3          	sub	a1,s1,s6
    80000e80:	858d                	srai	a1,a1,0x3
    80000e82:	000ab783          	ld	a5,0(s5)
    80000e86:	02f585b3          	mul	a1,a1,a5
    80000e8a:	2585                	addiw	a1,a1,1
    80000e8c:	00d5959b          	slliw	a1,a1,0xd
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e90:	4719                	li	a4,6
    80000e92:	6685                	lui	a3,0x1
    80000e94:	40b905b3          	sub	a1,s2,a1
    80000e98:	854e                	mv	a0,s3
    80000e9a:	00000097          	auipc	ra,0x0
    80000e9e:	890080e7          	jalr	-1904(ra) # 8000072a <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++) {
    80000ea2:	16848493          	addi	s1,s1,360
    80000ea6:	fd4495e3          	bne	s1,s4,80000e70 <proc_mapstacks+0x38>
    }
}
    80000eaa:	70e2                	ld	ra,56(sp)
    80000eac:	7442                	ld	s0,48(sp)
    80000eae:	74a2                	ld	s1,40(sp)
    80000eb0:	7902                	ld	s2,32(sp)
    80000eb2:	69e2                	ld	s3,24(sp)
    80000eb4:	6a42                	ld	s4,16(sp)
    80000eb6:	6aa2                	ld	s5,8(sp)
    80000eb8:	6b02                	ld	s6,0(sp)
    80000eba:	6121                	addi	sp,sp,64
    80000ebc:	8082                	ret
            panic("kalloc");
    80000ebe:	00007517          	auipc	a0,0x7
    80000ec2:	2aa50513          	addi	a0,a0,682 # 80008168 <etext+0x168>
    80000ec6:	00005097          	auipc	ra,0x5
    80000eca:	f96080e7          	jalr	-106(ra) # 80005e5c <panic>

0000000080000ece <procinit>:

// initialize the proc table.
void procinit(void)
{
    80000ece:	7139                	addi	sp,sp,-64
    80000ed0:	fc06                	sd	ra,56(sp)
    80000ed2:	f822                	sd	s0,48(sp)
    80000ed4:	f426                	sd	s1,40(sp)
    80000ed6:	f04a                	sd	s2,32(sp)
    80000ed8:	ec4e                	sd	s3,24(sp)
    80000eda:	e852                	sd	s4,16(sp)
    80000edc:	e456                	sd	s5,8(sp)
    80000ede:	e05a                	sd	s6,0(sp)
    80000ee0:	0080                	addi	s0,sp,64
    struct proc *p;

    initlock(&pid_lock, "nextpid");
    80000ee2:	00007597          	auipc	a1,0x7
    80000ee6:	28e58593          	addi	a1,a1,654 # 80008170 <etext+0x170>
    80000eea:	00228517          	auipc	a0,0x228
    80000eee:	a3e50513          	addi	a0,a0,-1474 # 80228928 <pid_lock>
    80000ef2:	00005097          	auipc	ra,0x5
    80000ef6:	412080e7          	jalr	1042(ra) # 80006304 <initlock>
    initlock(&wait_lock, "wait_lock");
    80000efa:	00007597          	auipc	a1,0x7
    80000efe:	27e58593          	addi	a1,a1,638 # 80008178 <etext+0x178>
    80000f02:	00228517          	auipc	a0,0x228
    80000f06:	a3e50513          	addi	a0,a0,-1474 # 80228940 <wait_lock>
    80000f0a:	00005097          	auipc	ra,0x5
    80000f0e:	3fa080e7          	jalr	1018(ra) # 80006304 <initlock>
    for (p = proc; p < &proc[NPROC]; p++) {
    80000f12:	00228497          	auipc	s1,0x228
    80000f16:	e4648493          	addi	s1,s1,-442 # 80228d58 <proc>
        initlock(&p->lock, "proc");
    80000f1a:	00007b17          	auipc	s6,0x7
    80000f1e:	26eb0b13          	addi	s6,s6,622 # 80008188 <etext+0x188>
        p->state = UNUSED;
        p->kstack = KSTACK((int)(p - proc));
    80000f22:	8aa6                	mv	s5,s1
    80000f24:	00007a17          	auipc	s4,0x7
    80000f28:	0dca0a13          	addi	s4,s4,220 # 80008000 <etext>
    80000f2c:	04000937          	lui	s2,0x4000
    80000f30:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000f32:	0932                	slli	s2,s2,0xc
    for (p = proc; p < &proc[NPROC]; p++) {
    80000f34:	0022e997          	auipc	s3,0x22e
    80000f38:	82498993          	addi	s3,s3,-2012 # 8022e758 <tickslock>
        initlock(&p->lock, "proc");
    80000f3c:	85da                	mv	a1,s6
    80000f3e:	8526                	mv	a0,s1
    80000f40:	00005097          	auipc	ra,0x5
    80000f44:	3c4080e7          	jalr	964(ra) # 80006304 <initlock>
        p->state = UNUSED;
    80000f48:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int)(p - proc));
    80000f4c:	415487b3          	sub	a5,s1,s5
    80000f50:	878d                	srai	a5,a5,0x3
    80000f52:	000a3703          	ld	a4,0(s4)
    80000f56:	02e787b3          	mul	a5,a5,a4
    80000f5a:	2785                	addiw	a5,a5,1
    80000f5c:	00d7979b          	slliw	a5,a5,0xd
    80000f60:	40f907b3          	sub	a5,s2,a5
    80000f64:	e0bc                	sd	a5,64(s1)
    for (p = proc; p < &proc[NPROC]; p++) {
    80000f66:	16848493          	addi	s1,s1,360
    80000f6a:	fd3499e3          	bne	s1,s3,80000f3c <procinit+0x6e>
    }
}
    80000f6e:	70e2                	ld	ra,56(sp)
    80000f70:	7442                	ld	s0,48(sp)
    80000f72:	74a2                	ld	s1,40(sp)
    80000f74:	7902                	ld	s2,32(sp)
    80000f76:	69e2                	ld	s3,24(sp)
    80000f78:	6a42                	ld	s4,16(sp)
    80000f7a:	6aa2                	ld	s5,8(sp)
    80000f7c:	6b02                	ld	s6,0(sp)
    80000f7e:	6121                	addi	sp,sp,64
    80000f80:	8082                	ret

0000000080000f82 <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80000f82:	1141                	addi	sp,sp,-16
    80000f84:	e422                	sd	s0,8(sp)
    80000f86:	0800                	addi	s0,sp,16
    asm volatile("mv %0, tp" : "=r"(x));
    80000f88:	8512                	mv	a0,tp
    int id = r_tp();
    return id;
}
    80000f8a:	2501                	sext.w	a0,a0
    80000f8c:	6422                	ld	s0,8(sp)
    80000f8e:	0141                	addi	sp,sp,16
    80000f90:	8082                	ret

0000000080000f92 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *mycpu(void)
{
    80000f92:	1141                	addi	sp,sp,-16
    80000f94:	e422                	sd	s0,8(sp)
    80000f96:	0800                	addi	s0,sp,16
    80000f98:	8792                	mv	a5,tp
    int id = cpuid();
    struct cpu *c = &cpus[id];
    80000f9a:	2781                	sext.w	a5,a5
    80000f9c:	079e                	slli	a5,a5,0x7
    return c;
}
    80000f9e:	00228517          	auipc	a0,0x228
    80000fa2:	9ba50513          	addi	a0,a0,-1606 # 80228958 <cpus>
    80000fa6:	953e                	add	a0,a0,a5
    80000fa8:	6422                	ld	s0,8(sp)
    80000faa:	0141                	addi	sp,sp,16
    80000fac:	8082                	ret

0000000080000fae <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *myproc(void)
{
    80000fae:	1101                	addi	sp,sp,-32
    80000fb0:	ec06                	sd	ra,24(sp)
    80000fb2:	e822                	sd	s0,16(sp)
    80000fb4:	e426                	sd	s1,8(sp)
    80000fb6:	1000                	addi	s0,sp,32
    push_off();
    80000fb8:	00005097          	auipc	ra,0x5
    80000fbc:	390080e7          	jalr	912(ra) # 80006348 <push_off>
    80000fc0:	8792                	mv	a5,tp
    struct cpu *c = mycpu();
    struct proc *p = c->proc;
    80000fc2:	2781                	sext.w	a5,a5
    80000fc4:	079e                	slli	a5,a5,0x7
    80000fc6:	00228717          	auipc	a4,0x228
    80000fca:	96270713          	addi	a4,a4,-1694 # 80228928 <pid_lock>
    80000fce:	97ba                	add	a5,a5,a4
    80000fd0:	7b84                	ld	s1,48(a5)
    pop_off();
    80000fd2:	00005097          	auipc	ra,0x5
    80000fd6:	416080e7          	jalr	1046(ra) # 800063e8 <pop_off>
    return p;
}
    80000fda:	8526                	mv	a0,s1
    80000fdc:	60e2                	ld	ra,24(sp)
    80000fde:	6442                	ld	s0,16(sp)
    80000fe0:	64a2                	ld	s1,8(sp)
    80000fe2:	6105                	addi	sp,sp,32
    80000fe4:	8082                	ret

0000000080000fe6 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80000fe6:	1141                	addi	sp,sp,-16
    80000fe8:	e406                	sd	ra,8(sp)
    80000fea:	e022                	sd	s0,0(sp)
    80000fec:	0800                	addi	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80000fee:	00000097          	auipc	ra,0x0
    80000ff2:	fc0080e7          	jalr	-64(ra) # 80000fae <myproc>
    80000ff6:	00005097          	auipc	ra,0x5
    80000ffa:	452080e7          	jalr	1106(ra) # 80006448 <release>

    if (first) {
    80000ffe:	00008797          	auipc	a5,0x8
    80001002:	8527a783          	lw	a5,-1966(a5) # 80008850 <first.1>
    80001006:	eb89                	bnez	a5,80001018 <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80001008:	00001097          	auipc	ra,0x1
    8000100c:	c5c080e7          	jalr	-932(ra) # 80001c64 <usertrapret>
}
    80001010:	60a2                	ld	ra,8(sp)
    80001012:	6402                	ld	s0,0(sp)
    80001014:	0141                	addi	sp,sp,16
    80001016:	8082                	ret
        first = 0;
    80001018:	00008797          	auipc	a5,0x8
    8000101c:	8207ac23          	sw	zero,-1992(a5) # 80008850 <first.1>
        fsinit(ROOTDEV);
    80001020:	4505                	li	a0,1
    80001022:	00002097          	auipc	ra,0x2
    80001026:	b02080e7          	jalr	-1278(ra) # 80002b24 <fsinit>
    8000102a:	bff9                	j	80001008 <forkret+0x22>

000000008000102c <allocpid>:
{
    8000102c:	1101                	addi	sp,sp,-32
    8000102e:	ec06                	sd	ra,24(sp)
    80001030:	e822                	sd	s0,16(sp)
    80001032:	e426                	sd	s1,8(sp)
    80001034:	e04a                	sd	s2,0(sp)
    80001036:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80001038:	00228917          	auipc	s2,0x228
    8000103c:	8f090913          	addi	s2,s2,-1808 # 80228928 <pid_lock>
    80001040:	854a                	mv	a0,s2
    80001042:	00005097          	auipc	ra,0x5
    80001046:	352080e7          	jalr	850(ra) # 80006394 <acquire>
    pid = nextpid;
    8000104a:	00008797          	auipc	a5,0x8
    8000104e:	80a78793          	addi	a5,a5,-2038 # 80008854 <nextpid>
    80001052:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80001054:	0014871b          	addiw	a4,s1,1
    80001058:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    8000105a:	854a                	mv	a0,s2
    8000105c:	00005097          	auipc	ra,0x5
    80001060:	3ec080e7          	jalr	1004(ra) # 80006448 <release>
}
    80001064:	8526                	mv	a0,s1
    80001066:	60e2                	ld	ra,24(sp)
    80001068:	6442                	ld	s0,16(sp)
    8000106a:	64a2                	ld	s1,8(sp)
    8000106c:	6902                	ld	s2,0(sp)
    8000106e:	6105                	addi	sp,sp,32
    80001070:	8082                	ret

0000000080001072 <proc_pagetable>:
{
    80001072:	1101                	addi	sp,sp,-32
    80001074:	ec06                	sd	ra,24(sp)
    80001076:	e822                	sd	s0,16(sp)
    80001078:	e426                	sd	s1,8(sp)
    8000107a:	e04a                	sd	s2,0(sp)
    8000107c:	1000                	addi	s0,sp,32
    8000107e:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80001080:	00000097          	auipc	ra,0x0
    80001084:	894080e7          	jalr	-1900(ra) # 80000914 <uvmcreate>
    80001088:	84aa                	mv	s1,a0
    if (pagetable == 0)
    8000108a:	c121                	beqz	a0,800010ca <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline, PTE_R | PTE_X) < 0) {
    8000108c:	4729                	li	a4,10
    8000108e:	00006697          	auipc	a3,0x6
    80001092:	f7268693          	addi	a3,a3,-142 # 80007000 <_trampoline>
    80001096:	6605                	lui	a2,0x1
    80001098:	040005b7          	lui	a1,0x4000
    8000109c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000109e:	05b2                	slli	a1,a1,0xc
    800010a0:	fffff097          	auipc	ra,0xfffff
    800010a4:	5ea080e7          	jalr	1514(ra) # 8000068a <mappages>
    800010a8:	02054863          	bltz	a0,800010d8 <proc_pagetable+0x66>
    if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe), PTE_R | PTE_W) < 0) {
    800010ac:	4719                	li	a4,6
    800010ae:	05893683          	ld	a3,88(s2)
    800010b2:	6605                	lui	a2,0x1
    800010b4:	020005b7          	lui	a1,0x2000
    800010b8:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800010ba:	05b6                	slli	a1,a1,0xd
    800010bc:	8526                	mv	a0,s1
    800010be:	fffff097          	auipc	ra,0xfffff
    800010c2:	5cc080e7          	jalr	1484(ra) # 8000068a <mappages>
    800010c6:	02054163          	bltz	a0,800010e8 <proc_pagetable+0x76>
}
    800010ca:	8526                	mv	a0,s1
    800010cc:	60e2                	ld	ra,24(sp)
    800010ce:	6442                	ld	s0,16(sp)
    800010d0:	64a2                	ld	s1,8(sp)
    800010d2:	6902                	ld	s2,0(sp)
    800010d4:	6105                	addi	sp,sp,32
    800010d6:	8082                	ret
        uvmfree(pagetable, 0);
    800010d8:	4581                	li	a1,0
    800010da:	8526                	mv	a0,s1
    800010dc:	00000097          	auipc	ra,0x0
    800010e0:	a3e080e7          	jalr	-1474(ra) # 80000b1a <uvmfree>
        return 0;
    800010e4:	4481                	li	s1,0
    800010e6:	b7d5                	j	800010ca <proc_pagetable+0x58>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010e8:	4681                	li	a3,0
    800010ea:	4605                	li	a2,1
    800010ec:	040005b7          	lui	a1,0x4000
    800010f0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010f2:	05b2                	slli	a1,a1,0xc
    800010f4:	8526                	mv	a0,s1
    800010f6:	fffff097          	auipc	ra,0xfffff
    800010fa:	75a080e7          	jalr	1882(ra) # 80000850 <uvmunmap>
        uvmfree(pagetable, 0);
    800010fe:	4581                	li	a1,0
    80001100:	8526                	mv	a0,s1
    80001102:	00000097          	auipc	ra,0x0
    80001106:	a18080e7          	jalr	-1512(ra) # 80000b1a <uvmfree>
        return 0;
    8000110a:	4481                	li	s1,0
    8000110c:	bf7d                	j	800010ca <proc_pagetable+0x58>

000000008000110e <proc_freepagetable>:
{
    8000110e:	1101                	addi	sp,sp,-32
    80001110:	ec06                	sd	ra,24(sp)
    80001112:	e822                	sd	s0,16(sp)
    80001114:	e426                	sd	s1,8(sp)
    80001116:	e04a                	sd	s2,0(sp)
    80001118:	1000                	addi	s0,sp,32
    8000111a:	84aa                	mv	s1,a0
    8000111c:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000111e:	4681                	li	a3,0
    80001120:	4605                	li	a2,1
    80001122:	040005b7          	lui	a1,0x4000
    80001126:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001128:	05b2                	slli	a1,a1,0xc
    8000112a:	fffff097          	auipc	ra,0xfffff
    8000112e:	726080e7          	jalr	1830(ra) # 80000850 <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001132:	4681                	li	a3,0
    80001134:	4605                	li	a2,1
    80001136:	020005b7          	lui	a1,0x2000
    8000113a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000113c:	05b6                	slli	a1,a1,0xd
    8000113e:	8526                	mv	a0,s1
    80001140:	fffff097          	auipc	ra,0xfffff
    80001144:	710080e7          	jalr	1808(ra) # 80000850 <uvmunmap>
    uvmfree(pagetable, sz);
    80001148:	85ca                	mv	a1,s2
    8000114a:	8526                	mv	a0,s1
    8000114c:	00000097          	auipc	ra,0x0
    80001150:	9ce080e7          	jalr	-1586(ra) # 80000b1a <uvmfree>
}
    80001154:	60e2                	ld	ra,24(sp)
    80001156:	6442                	ld	s0,16(sp)
    80001158:	64a2                	ld	s1,8(sp)
    8000115a:	6902                	ld	s2,0(sp)
    8000115c:	6105                	addi	sp,sp,32
    8000115e:	8082                	ret

0000000080001160 <freeproc>:
{
    80001160:	1101                	addi	sp,sp,-32
    80001162:	ec06                	sd	ra,24(sp)
    80001164:	e822                	sd	s0,16(sp)
    80001166:	e426                	sd	s1,8(sp)
    80001168:	1000                	addi	s0,sp,32
    8000116a:	84aa                	mv	s1,a0
    if (p->trapframe)
    8000116c:	6d28                	ld	a0,88(a0)
    8000116e:	c509                	beqz	a0,80001178 <freeproc+0x18>
        kfree((void *)p->trapframe);
    80001170:	fffff097          	auipc	ra,0xfffff
    80001174:	eac080e7          	jalr	-340(ra) # 8000001c <kfree>
    p->trapframe = 0;
    80001178:	0404bc23          	sd	zero,88(s1)
    if (p->pagetable)
    8000117c:	68a8                	ld	a0,80(s1)
    8000117e:	c511                	beqz	a0,8000118a <freeproc+0x2a>
        proc_freepagetable(p->pagetable, p->sz);
    80001180:	64ac                	ld	a1,72(s1)
    80001182:	00000097          	auipc	ra,0x0
    80001186:	f8c080e7          	jalr	-116(ra) # 8000110e <proc_freepagetable>
    p->pagetable = 0;
    8000118a:	0404b823          	sd	zero,80(s1)
    p->sz = 0;
    8000118e:	0404b423          	sd	zero,72(s1)
    p->pid = 0;
    80001192:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    80001196:	0204bc23          	sd	zero,56(s1)
    p->name[0] = 0;
    8000119a:	14048c23          	sb	zero,344(s1)
    p->chan = 0;
    8000119e:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    800011a2:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    800011a6:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    800011aa:	0004ac23          	sw	zero,24(s1)
}
    800011ae:	60e2                	ld	ra,24(sp)
    800011b0:	6442                	ld	s0,16(sp)
    800011b2:	64a2                	ld	s1,8(sp)
    800011b4:	6105                	addi	sp,sp,32
    800011b6:	8082                	ret

00000000800011b8 <allocproc>:
{
    800011b8:	1101                	addi	sp,sp,-32
    800011ba:	ec06                	sd	ra,24(sp)
    800011bc:	e822                	sd	s0,16(sp)
    800011be:	e426                	sd	s1,8(sp)
    800011c0:	e04a                	sd	s2,0(sp)
    800011c2:	1000                	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++) {
    800011c4:	00228497          	auipc	s1,0x228
    800011c8:	b9448493          	addi	s1,s1,-1132 # 80228d58 <proc>
    800011cc:	0022d917          	auipc	s2,0x22d
    800011d0:	58c90913          	addi	s2,s2,1420 # 8022e758 <tickslock>
        acquire(&p->lock);
    800011d4:	8526                	mv	a0,s1
    800011d6:	00005097          	auipc	ra,0x5
    800011da:	1be080e7          	jalr	446(ra) # 80006394 <acquire>
        if (p->state == UNUSED) {
    800011de:	4c9c                	lw	a5,24(s1)
    800011e0:	cf81                	beqz	a5,800011f8 <allocproc+0x40>
            release(&p->lock);
    800011e2:	8526                	mv	a0,s1
    800011e4:	00005097          	auipc	ra,0x5
    800011e8:	264080e7          	jalr	612(ra) # 80006448 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    800011ec:	16848493          	addi	s1,s1,360
    800011f0:	ff2492e3          	bne	s1,s2,800011d4 <allocproc+0x1c>
    return 0;
    800011f4:	4481                	li	s1,0
    800011f6:	a889                	j	80001248 <allocproc+0x90>
    p->pid = allocpid();
    800011f8:	00000097          	auipc	ra,0x0
    800011fc:	e34080e7          	jalr	-460(ra) # 8000102c <allocpid>
    80001200:	d888                	sw	a0,48(s1)
    p->state = USED;
    80001202:	4785                	li	a5,1
    80001204:	cc9c                	sw	a5,24(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    80001206:	fffff097          	auipc	ra,0xfffff
    8000120a:	fa0080e7          	jalr	-96(ra) # 800001a6 <kalloc>
    8000120e:	892a                	mv	s2,a0
    80001210:	eca8                	sd	a0,88(s1)
    80001212:	c131                	beqz	a0,80001256 <allocproc+0x9e>
    p->pagetable = proc_pagetable(p);
    80001214:	8526                	mv	a0,s1
    80001216:	00000097          	auipc	ra,0x0
    8000121a:	e5c080e7          	jalr	-420(ra) # 80001072 <proc_pagetable>
    8000121e:	892a                	mv	s2,a0
    80001220:	e8a8                	sd	a0,80(s1)
    if (p->pagetable == 0) {
    80001222:	c531                	beqz	a0,8000126e <allocproc+0xb6>
    memset(&p->context, 0, sizeof(p->context));
    80001224:	07000613          	li	a2,112
    80001228:	4581                	li	a1,0
    8000122a:	06048513          	addi	a0,s1,96
    8000122e:	fffff097          	auipc	ra,0xfffff
    80001232:	090080e7          	jalr	144(ra) # 800002be <memset>
    p->context.ra = (uint64)forkret;
    80001236:	00000797          	auipc	a5,0x0
    8000123a:	db078793          	addi	a5,a5,-592 # 80000fe6 <forkret>
    8000123e:	f0bc                	sd	a5,96(s1)
    p->context.sp = p->kstack + PGSIZE;
    80001240:	60bc                	ld	a5,64(s1)
    80001242:	6705                	lui	a4,0x1
    80001244:	97ba                	add	a5,a5,a4
    80001246:	f4bc                	sd	a5,104(s1)
}
    80001248:	8526                	mv	a0,s1
    8000124a:	60e2                	ld	ra,24(sp)
    8000124c:	6442                	ld	s0,16(sp)
    8000124e:	64a2                	ld	s1,8(sp)
    80001250:	6902                	ld	s2,0(sp)
    80001252:	6105                	addi	sp,sp,32
    80001254:	8082                	ret
        freeproc(p);
    80001256:	8526                	mv	a0,s1
    80001258:	00000097          	auipc	ra,0x0
    8000125c:	f08080e7          	jalr	-248(ra) # 80001160 <freeproc>
        release(&p->lock);
    80001260:	8526                	mv	a0,s1
    80001262:	00005097          	auipc	ra,0x5
    80001266:	1e6080e7          	jalr	486(ra) # 80006448 <release>
        return 0;
    8000126a:	84ca                	mv	s1,s2
    8000126c:	bff1                	j	80001248 <allocproc+0x90>
        freeproc(p);
    8000126e:	8526                	mv	a0,s1
    80001270:	00000097          	auipc	ra,0x0
    80001274:	ef0080e7          	jalr	-272(ra) # 80001160 <freeproc>
        release(&p->lock);
    80001278:	8526                	mv	a0,s1
    8000127a:	00005097          	auipc	ra,0x5
    8000127e:	1ce080e7          	jalr	462(ra) # 80006448 <release>
        return 0;
    80001282:	84ca                	mv	s1,s2
    80001284:	b7d1                	j	80001248 <allocproc+0x90>

0000000080001286 <userinit>:
{
    80001286:	1101                	addi	sp,sp,-32
    80001288:	ec06                	sd	ra,24(sp)
    8000128a:	e822                	sd	s0,16(sp)
    8000128c:	e426                	sd	s1,8(sp)
    8000128e:	1000                	addi	s0,sp,32
    p = allocproc();
    80001290:	00000097          	auipc	ra,0x0
    80001294:	f28080e7          	jalr	-216(ra) # 800011b8 <allocproc>
    80001298:	84aa                	mv	s1,a0
    initproc = p;
    8000129a:	00007797          	auipc	a5,0x7
    8000129e:	62a7bb23          	sd	a0,1590(a5) # 800088d0 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800012a2:	03400613          	li	a2,52
    800012a6:	00007597          	auipc	a1,0x7
    800012aa:	5ba58593          	addi	a1,a1,1466 # 80008860 <initcode>
    800012ae:	6928                	ld	a0,80(a0)
    800012b0:	fffff097          	auipc	ra,0xfffff
    800012b4:	692080e7          	jalr	1682(ra) # 80000942 <uvmfirst>
    p->sz = PGSIZE;
    800012b8:	6785                	lui	a5,0x1
    800012ba:	e4bc                	sd	a5,72(s1)
    p->trapframe->epc = 0;     // user program counter
    800012bc:	6cb8                	ld	a4,88(s1)
    800012be:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    800012c2:	6cb8                	ld	a4,88(s1)
    800012c4:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    800012c6:	4641                	li	a2,16
    800012c8:	00007597          	auipc	a1,0x7
    800012cc:	ec858593          	addi	a1,a1,-312 # 80008190 <etext+0x190>
    800012d0:	15848513          	addi	a0,s1,344
    800012d4:	fffff097          	auipc	ra,0xfffff
    800012d8:	134080e7          	jalr	308(ra) # 80000408 <safestrcpy>
    p->cwd = namei("/");
    800012dc:	00007517          	auipc	a0,0x7
    800012e0:	ec450513          	addi	a0,a0,-316 # 800081a0 <etext+0x1a0>
    800012e4:	00002097          	auipc	ra,0x2
    800012e8:	26a080e7          	jalr	618(ra) # 8000354e <namei>
    800012ec:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    800012f0:	478d                	li	a5,3
    800012f2:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    800012f4:	8526                	mv	a0,s1
    800012f6:	00005097          	auipc	ra,0x5
    800012fa:	152080e7          	jalr	338(ra) # 80006448 <release>
}
    800012fe:	60e2                	ld	ra,24(sp)
    80001300:	6442                	ld	s0,16(sp)
    80001302:	64a2                	ld	s1,8(sp)
    80001304:	6105                	addi	sp,sp,32
    80001306:	8082                	ret

0000000080001308 <growproc>:
{
    80001308:	1101                	addi	sp,sp,-32
    8000130a:	ec06                	sd	ra,24(sp)
    8000130c:	e822                	sd	s0,16(sp)
    8000130e:	e426                	sd	s1,8(sp)
    80001310:	e04a                	sd	s2,0(sp)
    80001312:	1000                	addi	s0,sp,32
    80001314:	892a                	mv	s2,a0
    struct proc *p = myproc();
    80001316:	00000097          	auipc	ra,0x0
    8000131a:	c98080e7          	jalr	-872(ra) # 80000fae <myproc>
    8000131e:	84aa                	mv	s1,a0
    sz = p->sz;
    80001320:	652c                	ld	a1,72(a0)
    if (n > 0) {
    80001322:	01204c63          	bgtz	s2,8000133a <growproc+0x32>
    else if (n < 0) {
    80001326:	02094663          	bltz	s2,80001352 <growproc+0x4a>
    p->sz = sz;
    8000132a:	e4ac                	sd	a1,72(s1)
    return 0;
    8000132c:	4501                	li	a0,0
}
    8000132e:	60e2                	ld	ra,24(sp)
    80001330:	6442                	ld	s0,16(sp)
    80001332:	64a2                	ld	s1,8(sp)
    80001334:	6902                	ld	s2,0(sp)
    80001336:	6105                	addi	sp,sp,32
    80001338:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000133a:	4691                	li	a3,4
    8000133c:	00b90633          	add	a2,s2,a1
    80001340:	6928                	ld	a0,80(a0)
    80001342:	fffff097          	auipc	ra,0xfffff
    80001346:	6ba080e7          	jalr	1722(ra) # 800009fc <uvmalloc>
    8000134a:	85aa                	mv	a1,a0
    8000134c:	fd79                	bnez	a0,8000132a <growproc+0x22>
            return -1;
    8000134e:	557d                	li	a0,-1
    80001350:	bff9                	j	8000132e <growproc+0x26>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001352:	00b90633          	add	a2,s2,a1
    80001356:	6928                	ld	a0,80(a0)
    80001358:	fffff097          	auipc	ra,0xfffff
    8000135c:	65c080e7          	jalr	1628(ra) # 800009b4 <uvmdealloc>
    80001360:	85aa                	mv	a1,a0
    80001362:	b7e1                	j	8000132a <growproc+0x22>

0000000080001364 <fork>:
{
    80001364:	7139                	addi	sp,sp,-64
    80001366:	fc06                	sd	ra,56(sp)
    80001368:	f822                	sd	s0,48(sp)
    8000136a:	f426                	sd	s1,40(sp)
    8000136c:	f04a                	sd	s2,32(sp)
    8000136e:	ec4e                	sd	s3,24(sp)
    80001370:	e852                	sd	s4,16(sp)
    80001372:	e456                	sd	s5,8(sp)
    80001374:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    80001376:	00000097          	auipc	ra,0x0
    8000137a:	c38080e7          	jalr	-968(ra) # 80000fae <myproc>
    8000137e:	8aaa                	mv	s5,a0
    if ((np = allocproc()) == 0) {
    80001380:	00000097          	auipc	ra,0x0
    80001384:	e38080e7          	jalr	-456(ra) # 800011b8 <allocproc>
    80001388:	10050c63          	beqz	a0,800014a0 <fork+0x13c>
    8000138c:	8a2a                	mv	s4,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    8000138e:	048ab603          	ld	a2,72(s5)
    80001392:	692c                	ld	a1,80(a0)
    80001394:	050ab503          	ld	a0,80(s5)
    80001398:	fffff097          	auipc	ra,0xfffff
    8000139c:	7bc080e7          	jalr	1980(ra) # 80000b54 <uvmcopy>
    800013a0:	04054863          	bltz	a0,800013f0 <fork+0x8c>
    np->sz = p->sz;
    800013a4:	048ab783          	ld	a5,72(s5)
    800013a8:	04fa3423          	sd	a5,72(s4)
    *(np->trapframe) = *(p->trapframe);
    800013ac:	058ab683          	ld	a3,88(s5)
    800013b0:	87b6                	mv	a5,a3
    800013b2:	058a3703          	ld	a4,88(s4)
    800013b6:	12068693          	addi	a3,a3,288
    800013ba:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800013be:	6788                	ld	a0,8(a5)
    800013c0:	6b8c                	ld	a1,16(a5)
    800013c2:	6f90                	ld	a2,24(a5)
    800013c4:	01073023          	sd	a6,0(a4)
    800013c8:	e708                	sd	a0,8(a4)
    800013ca:	eb0c                	sd	a1,16(a4)
    800013cc:	ef10                	sd	a2,24(a4)
    800013ce:	02078793          	addi	a5,a5,32
    800013d2:	02070713          	addi	a4,a4,32
    800013d6:	fed792e3          	bne	a5,a3,800013ba <fork+0x56>
    np->trapframe->a0 = 0;
    800013da:	058a3783          	ld	a5,88(s4)
    800013de:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++)
    800013e2:	0d0a8493          	addi	s1,s5,208
    800013e6:	0d0a0913          	addi	s2,s4,208
    800013ea:	150a8993          	addi	s3,s5,336
    800013ee:	a00d                	j	80001410 <fork+0xac>
        freeproc(np);
    800013f0:	8552                	mv	a0,s4
    800013f2:	00000097          	auipc	ra,0x0
    800013f6:	d6e080e7          	jalr	-658(ra) # 80001160 <freeproc>
        release(&np->lock);
    800013fa:	8552                	mv	a0,s4
    800013fc:	00005097          	auipc	ra,0x5
    80001400:	04c080e7          	jalr	76(ra) # 80006448 <release>
        return -1;
    80001404:	597d                	li	s2,-1
    80001406:	a059                	j	8000148c <fork+0x128>
    for (i = 0; i < NOFILE; i++)
    80001408:	04a1                	addi	s1,s1,8
    8000140a:	0921                	addi	s2,s2,8
    8000140c:	01348b63          	beq	s1,s3,80001422 <fork+0xbe>
        if (p->ofile[i])
    80001410:	6088                	ld	a0,0(s1)
    80001412:	d97d                	beqz	a0,80001408 <fork+0xa4>
            np->ofile[i] = filedup(p->ofile[i]);
    80001414:	00002097          	auipc	ra,0x2
    80001418:	7d0080e7          	jalr	2000(ra) # 80003be4 <filedup>
    8000141c:	00a93023          	sd	a0,0(s2)
    80001420:	b7e5                	j	80001408 <fork+0xa4>
    np->cwd = idup(p->cwd);
    80001422:	150ab503          	ld	a0,336(s5)
    80001426:	00002097          	auipc	ra,0x2
    8000142a:	93e080e7          	jalr	-1730(ra) # 80002d64 <idup>
    8000142e:	14aa3823          	sd	a0,336(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    80001432:	4641                	li	a2,16
    80001434:	158a8593          	addi	a1,s5,344
    80001438:	158a0513          	addi	a0,s4,344
    8000143c:	fffff097          	auipc	ra,0xfffff
    80001440:	fcc080e7          	jalr	-52(ra) # 80000408 <safestrcpy>
    pid = np->pid;
    80001444:	030a2903          	lw	s2,48(s4)
    release(&np->lock);
    80001448:	8552                	mv	a0,s4
    8000144a:	00005097          	auipc	ra,0x5
    8000144e:	ffe080e7          	jalr	-2(ra) # 80006448 <release>
    acquire(&wait_lock);
    80001452:	00227497          	auipc	s1,0x227
    80001456:	4ee48493          	addi	s1,s1,1262 # 80228940 <wait_lock>
    8000145a:	8526                	mv	a0,s1
    8000145c:	00005097          	auipc	ra,0x5
    80001460:	f38080e7          	jalr	-200(ra) # 80006394 <acquire>
    np->parent = p;
    80001464:	035a3c23          	sd	s5,56(s4)
    release(&wait_lock);
    80001468:	8526                	mv	a0,s1
    8000146a:	00005097          	auipc	ra,0x5
    8000146e:	fde080e7          	jalr	-34(ra) # 80006448 <release>
    acquire(&np->lock);
    80001472:	8552                	mv	a0,s4
    80001474:	00005097          	auipc	ra,0x5
    80001478:	f20080e7          	jalr	-224(ra) # 80006394 <acquire>
    np->state = RUNNABLE;
    8000147c:	478d                	li	a5,3
    8000147e:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    80001482:	8552                	mv	a0,s4
    80001484:	00005097          	auipc	ra,0x5
    80001488:	fc4080e7          	jalr	-60(ra) # 80006448 <release>
}
    8000148c:	854a                	mv	a0,s2
    8000148e:	70e2                	ld	ra,56(sp)
    80001490:	7442                	ld	s0,48(sp)
    80001492:	74a2                	ld	s1,40(sp)
    80001494:	7902                	ld	s2,32(sp)
    80001496:	69e2                	ld	s3,24(sp)
    80001498:	6a42                	ld	s4,16(sp)
    8000149a:	6aa2                	ld	s5,8(sp)
    8000149c:	6121                	addi	sp,sp,64
    8000149e:	8082                	ret
        return -1;
    800014a0:	597d                	li	s2,-1
    800014a2:	b7ed                	j	8000148c <fork+0x128>

00000000800014a4 <scheduler>:
{
    800014a4:	7139                	addi	sp,sp,-64
    800014a6:	fc06                	sd	ra,56(sp)
    800014a8:	f822                	sd	s0,48(sp)
    800014aa:	f426                	sd	s1,40(sp)
    800014ac:	f04a                	sd	s2,32(sp)
    800014ae:	ec4e                	sd	s3,24(sp)
    800014b0:	e852                	sd	s4,16(sp)
    800014b2:	e456                	sd	s5,8(sp)
    800014b4:	e05a                	sd	s6,0(sp)
    800014b6:	0080                	addi	s0,sp,64
    800014b8:	8792                	mv	a5,tp
    int id = r_tp();
    800014ba:	2781                	sext.w	a5,a5
    c->proc = 0;
    800014bc:	00779a93          	slli	s5,a5,0x7
    800014c0:	00227717          	auipc	a4,0x227
    800014c4:	46870713          	addi	a4,a4,1128 # 80228928 <pid_lock>
    800014c8:	9756                	add	a4,a4,s5
    800014ca:	02073823          	sd	zero,48(a4)
                swtch(&c->context, &p->context);
    800014ce:	00227717          	auipc	a4,0x227
    800014d2:	49270713          	addi	a4,a4,1170 # 80228960 <cpus+0x8>
    800014d6:	9aba                	add	s5,s5,a4
            if (p->state == RUNNABLE) {
    800014d8:	498d                	li	s3,3
                p->state = RUNNING;
    800014da:	4b11                	li	s6,4
                c->proc = p;
    800014dc:	079e                	slli	a5,a5,0x7
    800014de:	00227a17          	auipc	s4,0x227
    800014e2:	44aa0a13          	addi	s4,s4,1098 # 80228928 <pid_lock>
    800014e6:	9a3e                	add	s4,s4,a5
        for (p = proc; p < &proc[NPROC]; p++) {
    800014e8:	0022d917          	auipc	s2,0x22d
    800014ec:	27090913          	addi	s2,s2,624 # 8022e758 <tickslock>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    800014f0:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    800014f4:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    800014f8:	10079073          	csrw	sstatus,a5
    800014fc:	00228497          	auipc	s1,0x228
    80001500:	85c48493          	addi	s1,s1,-1956 # 80228d58 <proc>
    80001504:	a811                	j	80001518 <scheduler+0x74>
            release(&p->lock);
    80001506:	8526                	mv	a0,s1
    80001508:	00005097          	auipc	ra,0x5
    8000150c:	f40080e7          	jalr	-192(ra) # 80006448 <release>
        for (p = proc; p < &proc[NPROC]; p++) {
    80001510:	16848493          	addi	s1,s1,360
    80001514:	fd248ee3          	beq	s1,s2,800014f0 <scheduler+0x4c>
            acquire(&p->lock);
    80001518:	8526                	mv	a0,s1
    8000151a:	00005097          	auipc	ra,0x5
    8000151e:	e7a080e7          	jalr	-390(ra) # 80006394 <acquire>
            if (p->state == RUNNABLE) {
    80001522:	4c9c                	lw	a5,24(s1)
    80001524:	ff3791e3          	bne	a5,s3,80001506 <scheduler+0x62>
                p->state = RUNNING;
    80001528:	0164ac23          	sw	s6,24(s1)
                c->proc = p;
    8000152c:	029a3823          	sd	s1,48(s4)
                swtch(&c->context, &p->context);
    80001530:	06048593          	addi	a1,s1,96
    80001534:	8556                	mv	a0,s5
    80001536:	00000097          	auipc	ra,0x0
    8000153a:	684080e7          	jalr	1668(ra) # 80001bba <swtch>
                c->proc = 0;
    8000153e:	020a3823          	sd	zero,48(s4)
    80001542:	b7d1                	j	80001506 <scheduler+0x62>

0000000080001544 <sched>:
{
    80001544:	7179                	addi	sp,sp,-48
    80001546:	f406                	sd	ra,40(sp)
    80001548:	f022                	sd	s0,32(sp)
    8000154a:	ec26                	sd	s1,24(sp)
    8000154c:	e84a                	sd	s2,16(sp)
    8000154e:	e44e                	sd	s3,8(sp)
    80001550:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80001552:	00000097          	auipc	ra,0x0
    80001556:	a5c080e7          	jalr	-1444(ra) # 80000fae <myproc>
    8000155a:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    8000155c:	00005097          	auipc	ra,0x5
    80001560:	dbe080e7          	jalr	-578(ra) # 8000631a <holding>
    80001564:	c93d                	beqz	a0,800015da <sched+0x96>
    asm volatile("mv %0, tp" : "=r"(x));
    80001566:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    80001568:	2781                	sext.w	a5,a5
    8000156a:	079e                	slli	a5,a5,0x7
    8000156c:	00227717          	auipc	a4,0x227
    80001570:	3bc70713          	addi	a4,a4,956 # 80228928 <pid_lock>
    80001574:	97ba                	add	a5,a5,a4
    80001576:	0a87a703          	lw	a4,168(a5)
    8000157a:	4785                	li	a5,1
    8000157c:	06f71763          	bne	a4,a5,800015ea <sched+0xa6>
    if (p->state == RUNNING)
    80001580:	4c98                	lw	a4,24(s1)
    80001582:	4791                	li	a5,4
    80001584:	06f70b63          	beq	a4,a5,800015fa <sched+0xb6>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80001588:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    8000158c:	8b89                	andi	a5,a5,2
    if (intr_get())
    8000158e:	efb5                	bnez	a5,8000160a <sched+0xc6>
    asm volatile("mv %0, tp" : "=r"(x));
    80001590:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    80001592:	00227917          	auipc	s2,0x227
    80001596:	39690913          	addi	s2,s2,918 # 80228928 <pid_lock>
    8000159a:	2781                	sext.w	a5,a5
    8000159c:	079e                	slli	a5,a5,0x7
    8000159e:	97ca                	add	a5,a5,s2
    800015a0:	0ac7a983          	lw	s3,172(a5)
    800015a4:	8792                	mv	a5,tp
    swtch(&p->context, &mycpu()->context);
    800015a6:	2781                	sext.w	a5,a5
    800015a8:	079e                	slli	a5,a5,0x7
    800015aa:	00227597          	auipc	a1,0x227
    800015ae:	3b658593          	addi	a1,a1,950 # 80228960 <cpus+0x8>
    800015b2:	95be                	add	a1,a1,a5
    800015b4:	06048513          	addi	a0,s1,96
    800015b8:	00000097          	auipc	ra,0x0
    800015bc:	602080e7          	jalr	1538(ra) # 80001bba <swtch>
    800015c0:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    800015c2:	2781                	sext.w	a5,a5
    800015c4:	079e                	slli	a5,a5,0x7
    800015c6:	993e                	add	s2,s2,a5
    800015c8:	0b392623          	sw	s3,172(s2)
}
    800015cc:	70a2                	ld	ra,40(sp)
    800015ce:	7402                	ld	s0,32(sp)
    800015d0:	64e2                	ld	s1,24(sp)
    800015d2:	6942                	ld	s2,16(sp)
    800015d4:	69a2                	ld	s3,8(sp)
    800015d6:	6145                	addi	sp,sp,48
    800015d8:	8082                	ret
        panic("sched p->lock");
    800015da:	00007517          	auipc	a0,0x7
    800015de:	bce50513          	addi	a0,a0,-1074 # 800081a8 <etext+0x1a8>
    800015e2:	00005097          	auipc	ra,0x5
    800015e6:	87a080e7          	jalr	-1926(ra) # 80005e5c <panic>
        panic("sched locks");
    800015ea:	00007517          	auipc	a0,0x7
    800015ee:	bce50513          	addi	a0,a0,-1074 # 800081b8 <etext+0x1b8>
    800015f2:	00005097          	auipc	ra,0x5
    800015f6:	86a080e7          	jalr	-1942(ra) # 80005e5c <panic>
        panic("sched running");
    800015fa:	00007517          	auipc	a0,0x7
    800015fe:	bce50513          	addi	a0,a0,-1074 # 800081c8 <etext+0x1c8>
    80001602:	00005097          	auipc	ra,0x5
    80001606:	85a080e7          	jalr	-1958(ra) # 80005e5c <panic>
        panic("sched interruptible");
    8000160a:	00007517          	auipc	a0,0x7
    8000160e:	bce50513          	addi	a0,a0,-1074 # 800081d8 <etext+0x1d8>
    80001612:	00005097          	auipc	ra,0x5
    80001616:	84a080e7          	jalr	-1974(ra) # 80005e5c <panic>

000000008000161a <yield>:
{
    8000161a:	1101                	addi	sp,sp,-32
    8000161c:	ec06                	sd	ra,24(sp)
    8000161e:	e822                	sd	s0,16(sp)
    80001620:	e426                	sd	s1,8(sp)
    80001622:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80001624:	00000097          	auipc	ra,0x0
    80001628:	98a080e7          	jalr	-1654(ra) # 80000fae <myproc>
    8000162c:	84aa                	mv	s1,a0
    acquire(&p->lock);
    8000162e:	00005097          	auipc	ra,0x5
    80001632:	d66080e7          	jalr	-666(ra) # 80006394 <acquire>
    p->state = RUNNABLE;
    80001636:	478d                	li	a5,3
    80001638:	cc9c                	sw	a5,24(s1)
    sched();
    8000163a:	00000097          	auipc	ra,0x0
    8000163e:	f0a080e7          	jalr	-246(ra) # 80001544 <sched>
    release(&p->lock);
    80001642:	8526                	mv	a0,s1
    80001644:	00005097          	auipc	ra,0x5
    80001648:	e04080e7          	jalr	-508(ra) # 80006448 <release>
}
    8000164c:	60e2                	ld	ra,24(sp)
    8000164e:	6442                	ld	s0,16(sp)
    80001650:	64a2                	ld	s1,8(sp)
    80001652:	6105                	addi	sp,sp,32
    80001654:	8082                	ret

0000000080001656 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    80001656:	7179                	addi	sp,sp,-48
    80001658:	f406                	sd	ra,40(sp)
    8000165a:	f022                	sd	s0,32(sp)
    8000165c:	ec26                	sd	s1,24(sp)
    8000165e:	e84a                	sd	s2,16(sp)
    80001660:	e44e                	sd	s3,8(sp)
    80001662:	1800                	addi	s0,sp,48
    80001664:	89aa                	mv	s3,a0
    80001666:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80001668:	00000097          	auipc	ra,0x0
    8000166c:	946080e7          	jalr	-1722(ra) # 80000fae <myproc>
    80001670:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    80001672:	00005097          	auipc	ra,0x5
    80001676:	d22080e7          	jalr	-734(ra) # 80006394 <acquire>
    release(lk);
    8000167a:	854a                	mv	a0,s2
    8000167c:	00005097          	auipc	ra,0x5
    80001680:	dcc080e7          	jalr	-564(ra) # 80006448 <release>

    // Go to sleep.
    p->chan = chan;
    80001684:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    80001688:	4789                	li	a5,2
    8000168a:	cc9c                	sw	a5,24(s1)

    sched();
    8000168c:	00000097          	auipc	ra,0x0
    80001690:	eb8080e7          	jalr	-328(ra) # 80001544 <sched>

    // Tidy up.
    p->chan = 0;
    80001694:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    80001698:	8526                	mv	a0,s1
    8000169a:	00005097          	auipc	ra,0x5
    8000169e:	dae080e7          	jalr	-594(ra) # 80006448 <release>
    acquire(lk);
    800016a2:	854a                	mv	a0,s2
    800016a4:	00005097          	auipc	ra,0x5
    800016a8:	cf0080e7          	jalr	-784(ra) # 80006394 <acquire>
}
    800016ac:	70a2                	ld	ra,40(sp)
    800016ae:	7402                	ld	s0,32(sp)
    800016b0:	64e2                	ld	s1,24(sp)
    800016b2:	6942                	ld	s2,16(sp)
    800016b4:	69a2                	ld	s3,8(sp)
    800016b6:	6145                	addi	sp,sp,48
    800016b8:	8082                	ret

00000000800016ba <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    800016ba:	7139                	addi	sp,sp,-64
    800016bc:	fc06                	sd	ra,56(sp)
    800016be:	f822                	sd	s0,48(sp)
    800016c0:	f426                	sd	s1,40(sp)
    800016c2:	f04a                	sd	s2,32(sp)
    800016c4:	ec4e                	sd	s3,24(sp)
    800016c6:	e852                	sd	s4,16(sp)
    800016c8:	e456                	sd	s5,8(sp)
    800016ca:	0080                	addi	s0,sp,64
    800016cc:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++) {
    800016ce:	00227497          	auipc	s1,0x227
    800016d2:	68a48493          	addi	s1,s1,1674 # 80228d58 <proc>
        if (p != myproc()) {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan) {
    800016d6:	4989                	li	s3,2
                p->state = RUNNABLE;
    800016d8:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++) {
    800016da:	0022d917          	auipc	s2,0x22d
    800016de:	07e90913          	addi	s2,s2,126 # 8022e758 <tickslock>
    800016e2:	a811                	j	800016f6 <wakeup+0x3c>
            }
            release(&p->lock);
    800016e4:	8526                	mv	a0,s1
    800016e6:	00005097          	auipc	ra,0x5
    800016ea:	d62080e7          	jalr	-670(ra) # 80006448 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    800016ee:	16848493          	addi	s1,s1,360
    800016f2:	03248663          	beq	s1,s2,8000171e <wakeup+0x64>
        if (p != myproc()) {
    800016f6:	00000097          	auipc	ra,0x0
    800016fa:	8b8080e7          	jalr	-1864(ra) # 80000fae <myproc>
    800016fe:	fea488e3          	beq	s1,a0,800016ee <wakeup+0x34>
            acquire(&p->lock);
    80001702:	8526                	mv	a0,s1
    80001704:	00005097          	auipc	ra,0x5
    80001708:	c90080e7          	jalr	-880(ra) # 80006394 <acquire>
            if (p->state == SLEEPING && p->chan == chan) {
    8000170c:	4c9c                	lw	a5,24(s1)
    8000170e:	fd379be3          	bne	a5,s3,800016e4 <wakeup+0x2a>
    80001712:	709c                	ld	a5,32(s1)
    80001714:	fd4798e3          	bne	a5,s4,800016e4 <wakeup+0x2a>
                p->state = RUNNABLE;
    80001718:	0154ac23          	sw	s5,24(s1)
    8000171c:	b7e1                	j	800016e4 <wakeup+0x2a>
        }
    }
}
    8000171e:	70e2                	ld	ra,56(sp)
    80001720:	7442                	ld	s0,48(sp)
    80001722:	74a2                	ld	s1,40(sp)
    80001724:	7902                	ld	s2,32(sp)
    80001726:	69e2                	ld	s3,24(sp)
    80001728:	6a42                	ld	s4,16(sp)
    8000172a:	6aa2                	ld	s5,8(sp)
    8000172c:	6121                	addi	sp,sp,64
    8000172e:	8082                	ret

0000000080001730 <reparent>:
{
    80001730:	7179                	addi	sp,sp,-48
    80001732:	f406                	sd	ra,40(sp)
    80001734:	f022                	sd	s0,32(sp)
    80001736:	ec26                	sd	s1,24(sp)
    80001738:	e84a                	sd	s2,16(sp)
    8000173a:	e44e                	sd	s3,8(sp)
    8000173c:	e052                	sd	s4,0(sp)
    8000173e:	1800                	addi	s0,sp,48
    80001740:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001742:	00227497          	auipc	s1,0x227
    80001746:	61648493          	addi	s1,s1,1558 # 80228d58 <proc>
            pp->parent = initproc;
    8000174a:	00007a17          	auipc	s4,0x7
    8000174e:	186a0a13          	addi	s4,s4,390 # 800088d0 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001752:	0022d997          	auipc	s3,0x22d
    80001756:	00698993          	addi	s3,s3,6 # 8022e758 <tickslock>
    8000175a:	a029                	j	80001764 <reparent+0x34>
    8000175c:	16848493          	addi	s1,s1,360
    80001760:	01348d63          	beq	s1,s3,8000177a <reparent+0x4a>
        if (pp->parent == p) {
    80001764:	7c9c                	ld	a5,56(s1)
    80001766:	ff279be3          	bne	a5,s2,8000175c <reparent+0x2c>
            pp->parent = initproc;
    8000176a:	000a3503          	ld	a0,0(s4)
    8000176e:	fc88                	sd	a0,56(s1)
            wakeup(initproc);
    80001770:	00000097          	auipc	ra,0x0
    80001774:	f4a080e7          	jalr	-182(ra) # 800016ba <wakeup>
    80001778:	b7d5                	j	8000175c <reparent+0x2c>
}
    8000177a:	70a2                	ld	ra,40(sp)
    8000177c:	7402                	ld	s0,32(sp)
    8000177e:	64e2                	ld	s1,24(sp)
    80001780:	6942                	ld	s2,16(sp)
    80001782:	69a2                	ld	s3,8(sp)
    80001784:	6a02                	ld	s4,0(sp)
    80001786:	6145                	addi	sp,sp,48
    80001788:	8082                	ret

000000008000178a <exit>:
{
    8000178a:	7179                	addi	sp,sp,-48
    8000178c:	f406                	sd	ra,40(sp)
    8000178e:	f022                	sd	s0,32(sp)
    80001790:	ec26                	sd	s1,24(sp)
    80001792:	e84a                	sd	s2,16(sp)
    80001794:	e44e                	sd	s3,8(sp)
    80001796:	e052                	sd	s4,0(sp)
    80001798:	1800                	addi	s0,sp,48
    8000179a:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    8000179c:	00000097          	auipc	ra,0x0
    800017a0:	812080e7          	jalr	-2030(ra) # 80000fae <myproc>
    800017a4:	89aa                	mv	s3,a0
    if (p == initproc)
    800017a6:	00007797          	auipc	a5,0x7
    800017aa:	12a7b783          	ld	a5,298(a5) # 800088d0 <initproc>
    800017ae:	0d050493          	addi	s1,a0,208
    800017b2:	15050913          	addi	s2,a0,336
    800017b6:	02a79363          	bne	a5,a0,800017dc <exit+0x52>
        panic("init exiting");
    800017ba:	00007517          	auipc	a0,0x7
    800017be:	a3650513          	addi	a0,a0,-1482 # 800081f0 <etext+0x1f0>
    800017c2:	00004097          	auipc	ra,0x4
    800017c6:	69a080e7          	jalr	1690(ra) # 80005e5c <panic>
            fileclose(f);
    800017ca:	00002097          	auipc	ra,0x2
    800017ce:	46c080e7          	jalr	1132(ra) # 80003c36 <fileclose>
            p->ofile[fd] = 0;
    800017d2:	0004b023          	sd	zero,0(s1)
    for (int fd = 0; fd < NOFILE; fd++) {
    800017d6:	04a1                	addi	s1,s1,8
    800017d8:	01248563          	beq	s1,s2,800017e2 <exit+0x58>
        if (p->ofile[fd]) {
    800017dc:	6088                	ld	a0,0(s1)
    800017de:	f575                	bnez	a0,800017ca <exit+0x40>
    800017e0:	bfdd                	j	800017d6 <exit+0x4c>
    begin_op();
    800017e2:	00002097          	auipc	ra,0x2
    800017e6:	f8c080e7          	jalr	-116(ra) # 8000376e <begin_op>
    iput(p->cwd);
    800017ea:	1509b503          	ld	a0,336(s3)
    800017ee:	00001097          	auipc	ra,0x1
    800017f2:	76e080e7          	jalr	1902(ra) # 80002f5c <iput>
    end_op();
    800017f6:	00002097          	auipc	ra,0x2
    800017fa:	ff6080e7          	jalr	-10(ra) # 800037ec <end_op>
    p->cwd = 0;
    800017fe:	1409b823          	sd	zero,336(s3)
    acquire(&wait_lock);
    80001802:	00227497          	auipc	s1,0x227
    80001806:	13e48493          	addi	s1,s1,318 # 80228940 <wait_lock>
    8000180a:	8526                	mv	a0,s1
    8000180c:	00005097          	auipc	ra,0x5
    80001810:	b88080e7          	jalr	-1144(ra) # 80006394 <acquire>
    reparent(p);
    80001814:	854e                	mv	a0,s3
    80001816:	00000097          	auipc	ra,0x0
    8000181a:	f1a080e7          	jalr	-230(ra) # 80001730 <reparent>
    wakeup(p->parent);
    8000181e:	0389b503          	ld	a0,56(s3)
    80001822:	00000097          	auipc	ra,0x0
    80001826:	e98080e7          	jalr	-360(ra) # 800016ba <wakeup>
    acquire(&p->lock);
    8000182a:	854e                	mv	a0,s3
    8000182c:	00005097          	auipc	ra,0x5
    80001830:	b68080e7          	jalr	-1176(ra) # 80006394 <acquire>
    p->xstate = status;
    80001834:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    80001838:	4795                	li	a5,5
    8000183a:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    8000183e:	8526                	mv	a0,s1
    80001840:	00005097          	auipc	ra,0x5
    80001844:	c08080e7          	jalr	-1016(ra) # 80006448 <release>
    sched();
    80001848:	00000097          	auipc	ra,0x0
    8000184c:	cfc080e7          	jalr	-772(ra) # 80001544 <sched>
    panic("zombie exit");
    80001850:	00007517          	auipc	a0,0x7
    80001854:	9b050513          	addi	a0,a0,-1616 # 80008200 <etext+0x200>
    80001858:	00004097          	auipc	ra,0x4
    8000185c:	604080e7          	jalr	1540(ra) # 80005e5c <panic>

0000000080001860 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    80001860:	7179                	addi	sp,sp,-48
    80001862:	f406                	sd	ra,40(sp)
    80001864:	f022                	sd	s0,32(sp)
    80001866:	ec26                	sd	s1,24(sp)
    80001868:	e84a                	sd	s2,16(sp)
    8000186a:	e44e                	sd	s3,8(sp)
    8000186c:	1800                	addi	s0,sp,48
    8000186e:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++) {
    80001870:	00227497          	auipc	s1,0x227
    80001874:	4e848493          	addi	s1,s1,1256 # 80228d58 <proc>
    80001878:	0022d997          	auipc	s3,0x22d
    8000187c:	ee098993          	addi	s3,s3,-288 # 8022e758 <tickslock>
        acquire(&p->lock);
    80001880:	8526                	mv	a0,s1
    80001882:	00005097          	auipc	ra,0x5
    80001886:	b12080e7          	jalr	-1262(ra) # 80006394 <acquire>
        if (p->pid == pid) {
    8000188a:	589c                	lw	a5,48(s1)
    8000188c:	01278d63          	beq	a5,s2,800018a6 <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    80001890:	8526                	mv	a0,s1
    80001892:	00005097          	auipc	ra,0x5
    80001896:	bb6080e7          	jalr	-1098(ra) # 80006448 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    8000189a:	16848493          	addi	s1,s1,360
    8000189e:	ff3491e3          	bne	s1,s3,80001880 <kill+0x20>
    }
    return -1;
    800018a2:	557d                	li	a0,-1
    800018a4:	a829                	j	800018be <kill+0x5e>
            p->killed = 1;
    800018a6:	4785                	li	a5,1
    800018a8:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING) {
    800018aa:	4c98                	lw	a4,24(s1)
    800018ac:	4789                	li	a5,2
    800018ae:	00f70f63          	beq	a4,a5,800018cc <kill+0x6c>
            release(&p->lock);
    800018b2:	8526                	mv	a0,s1
    800018b4:	00005097          	auipc	ra,0x5
    800018b8:	b94080e7          	jalr	-1132(ra) # 80006448 <release>
            return 0;
    800018bc:	4501                	li	a0,0
}
    800018be:	70a2                	ld	ra,40(sp)
    800018c0:	7402                	ld	s0,32(sp)
    800018c2:	64e2                	ld	s1,24(sp)
    800018c4:	6942                	ld	s2,16(sp)
    800018c6:	69a2                	ld	s3,8(sp)
    800018c8:	6145                	addi	sp,sp,48
    800018ca:	8082                	ret
                p->state = RUNNABLE;
    800018cc:	478d                	li	a5,3
    800018ce:	cc9c                	sw	a5,24(s1)
    800018d0:	b7cd                	j	800018b2 <kill+0x52>

00000000800018d2 <setkilled>:

void setkilled(struct proc *p)
{
    800018d2:	1101                	addi	sp,sp,-32
    800018d4:	ec06                	sd	ra,24(sp)
    800018d6:	e822                	sd	s0,16(sp)
    800018d8:	e426                	sd	s1,8(sp)
    800018da:	1000                	addi	s0,sp,32
    800018dc:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800018de:	00005097          	auipc	ra,0x5
    800018e2:	ab6080e7          	jalr	-1354(ra) # 80006394 <acquire>
    p->killed = 1;
    800018e6:	4785                	li	a5,1
    800018e8:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    800018ea:	8526                	mv	a0,s1
    800018ec:	00005097          	auipc	ra,0x5
    800018f0:	b5c080e7          	jalr	-1188(ra) # 80006448 <release>
}
    800018f4:	60e2                	ld	ra,24(sp)
    800018f6:	6442                	ld	s0,16(sp)
    800018f8:	64a2                	ld	s1,8(sp)
    800018fa:	6105                	addi	sp,sp,32
    800018fc:	8082                	ret

00000000800018fe <killed>:

int killed(struct proc *p)
{
    800018fe:	1101                	addi	sp,sp,-32
    80001900:	ec06                	sd	ra,24(sp)
    80001902:	e822                	sd	s0,16(sp)
    80001904:	e426                	sd	s1,8(sp)
    80001906:	e04a                	sd	s2,0(sp)
    80001908:	1000                	addi	s0,sp,32
    8000190a:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    8000190c:	00005097          	auipc	ra,0x5
    80001910:	a88080e7          	jalr	-1400(ra) # 80006394 <acquire>
    k = p->killed;
    80001914:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    80001918:	8526                	mv	a0,s1
    8000191a:	00005097          	auipc	ra,0x5
    8000191e:	b2e080e7          	jalr	-1234(ra) # 80006448 <release>
    return k;
}
    80001922:	854a                	mv	a0,s2
    80001924:	60e2                	ld	ra,24(sp)
    80001926:	6442                	ld	s0,16(sp)
    80001928:	64a2                	ld	s1,8(sp)
    8000192a:	6902                	ld	s2,0(sp)
    8000192c:	6105                	addi	sp,sp,32
    8000192e:	8082                	ret

0000000080001930 <wait>:
{
    80001930:	715d                	addi	sp,sp,-80
    80001932:	e486                	sd	ra,72(sp)
    80001934:	e0a2                	sd	s0,64(sp)
    80001936:	fc26                	sd	s1,56(sp)
    80001938:	f84a                	sd	s2,48(sp)
    8000193a:	f44e                	sd	s3,40(sp)
    8000193c:	f052                	sd	s4,32(sp)
    8000193e:	ec56                	sd	s5,24(sp)
    80001940:	e85a                	sd	s6,16(sp)
    80001942:	e45e                	sd	s7,8(sp)
    80001944:	e062                	sd	s8,0(sp)
    80001946:	0880                	addi	s0,sp,80
    80001948:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    8000194a:	fffff097          	auipc	ra,0xfffff
    8000194e:	664080e7          	jalr	1636(ra) # 80000fae <myproc>
    80001952:	892a                	mv	s2,a0
    acquire(&wait_lock);
    80001954:	00227517          	auipc	a0,0x227
    80001958:	fec50513          	addi	a0,a0,-20 # 80228940 <wait_lock>
    8000195c:	00005097          	auipc	ra,0x5
    80001960:	a38080e7          	jalr	-1480(ra) # 80006394 <acquire>
        havekids = 0;
    80001964:	4b81                	li	s7,0
                if (pp->state == ZOMBIE) {
    80001966:	4a15                	li	s4,5
                havekids = 1;
    80001968:	4a85                	li	s5,1
        for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000196a:	0022d997          	auipc	s3,0x22d
    8000196e:	dee98993          	addi	s3,s3,-530 # 8022e758 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    80001972:	00227c17          	auipc	s8,0x227
    80001976:	fcec0c13          	addi	s8,s8,-50 # 80228940 <wait_lock>
        havekids = 0;
    8000197a:	875e                	mv	a4,s7
        for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000197c:	00227497          	auipc	s1,0x227
    80001980:	3dc48493          	addi	s1,s1,988 # 80228d58 <proc>
    80001984:	a0bd                	j	800019f2 <wait+0xc2>
                    pid = pp->pid;
    80001986:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate, sizeof(pp->xstate)) < 0) {
    8000198a:	000b0e63          	beqz	s6,800019a6 <wait+0x76>
    8000198e:	4691                	li	a3,4
    80001990:	02c48613          	addi	a2,s1,44
    80001994:	85da                	mv	a1,s6
    80001996:	05093503          	ld	a0,80(s2)
    8000199a:	fffff097          	auipc	ra,0xfffff
    8000199e:	2a6080e7          	jalr	678(ra) # 80000c40 <copyout>
    800019a2:	02054563          	bltz	a0,800019cc <wait+0x9c>
                    freeproc(pp);
    800019a6:	8526                	mv	a0,s1
    800019a8:	fffff097          	auipc	ra,0xfffff
    800019ac:	7b8080e7          	jalr	1976(ra) # 80001160 <freeproc>
                    release(&pp->lock);
    800019b0:	8526                	mv	a0,s1
    800019b2:	00005097          	auipc	ra,0x5
    800019b6:	a96080e7          	jalr	-1386(ra) # 80006448 <release>
                    release(&wait_lock);
    800019ba:	00227517          	auipc	a0,0x227
    800019be:	f8650513          	addi	a0,a0,-122 # 80228940 <wait_lock>
    800019c2:	00005097          	auipc	ra,0x5
    800019c6:	a86080e7          	jalr	-1402(ra) # 80006448 <release>
                    return pid;
    800019ca:	a0b5                	j	80001a36 <wait+0x106>
                        release(&pp->lock);
    800019cc:	8526                	mv	a0,s1
    800019ce:	00005097          	auipc	ra,0x5
    800019d2:	a7a080e7          	jalr	-1414(ra) # 80006448 <release>
                        release(&wait_lock);
    800019d6:	00227517          	auipc	a0,0x227
    800019da:	f6a50513          	addi	a0,a0,-150 # 80228940 <wait_lock>
    800019de:	00005097          	auipc	ra,0x5
    800019e2:	a6a080e7          	jalr	-1430(ra) # 80006448 <release>
                        return -1;
    800019e6:	59fd                	li	s3,-1
    800019e8:	a0b9                	j	80001a36 <wait+0x106>
        for (pp = proc; pp < &proc[NPROC]; pp++) {
    800019ea:	16848493          	addi	s1,s1,360
    800019ee:	03348463          	beq	s1,s3,80001a16 <wait+0xe6>
            if (pp->parent == p) {
    800019f2:	7c9c                	ld	a5,56(s1)
    800019f4:	ff279be3          	bne	a5,s2,800019ea <wait+0xba>
                acquire(&pp->lock);
    800019f8:	8526                	mv	a0,s1
    800019fa:	00005097          	auipc	ra,0x5
    800019fe:	99a080e7          	jalr	-1638(ra) # 80006394 <acquire>
                if (pp->state == ZOMBIE) {
    80001a02:	4c9c                	lw	a5,24(s1)
    80001a04:	f94781e3          	beq	a5,s4,80001986 <wait+0x56>
                release(&pp->lock);
    80001a08:	8526                	mv	a0,s1
    80001a0a:	00005097          	auipc	ra,0x5
    80001a0e:	a3e080e7          	jalr	-1474(ra) # 80006448 <release>
                havekids = 1;
    80001a12:	8756                	mv	a4,s5
    80001a14:	bfd9                	j	800019ea <wait+0xba>
        if (!havekids || killed(p)) {
    80001a16:	c719                	beqz	a4,80001a24 <wait+0xf4>
    80001a18:	854a                	mv	a0,s2
    80001a1a:	00000097          	auipc	ra,0x0
    80001a1e:	ee4080e7          	jalr	-284(ra) # 800018fe <killed>
    80001a22:	c51d                	beqz	a0,80001a50 <wait+0x120>
            release(&wait_lock);
    80001a24:	00227517          	auipc	a0,0x227
    80001a28:	f1c50513          	addi	a0,a0,-228 # 80228940 <wait_lock>
    80001a2c:	00005097          	auipc	ra,0x5
    80001a30:	a1c080e7          	jalr	-1508(ra) # 80006448 <release>
            return -1;
    80001a34:	59fd                	li	s3,-1
}
    80001a36:	854e                	mv	a0,s3
    80001a38:	60a6                	ld	ra,72(sp)
    80001a3a:	6406                	ld	s0,64(sp)
    80001a3c:	74e2                	ld	s1,56(sp)
    80001a3e:	7942                	ld	s2,48(sp)
    80001a40:	79a2                	ld	s3,40(sp)
    80001a42:	7a02                	ld	s4,32(sp)
    80001a44:	6ae2                	ld	s5,24(sp)
    80001a46:	6b42                	ld	s6,16(sp)
    80001a48:	6ba2                	ld	s7,8(sp)
    80001a4a:	6c02                	ld	s8,0(sp)
    80001a4c:	6161                	addi	sp,sp,80
    80001a4e:	8082                	ret
        sleep(p, &wait_lock); // DOC: wait-sleep
    80001a50:	85e2                	mv	a1,s8
    80001a52:	854a                	mv	a0,s2
    80001a54:	00000097          	auipc	ra,0x0
    80001a58:	c02080e7          	jalr	-1022(ra) # 80001656 <sleep>
        havekids = 0;
    80001a5c:	bf39                	j	8000197a <wait+0x4a>

0000000080001a5e <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a5e:	7179                	addi	sp,sp,-48
    80001a60:	f406                	sd	ra,40(sp)
    80001a62:	f022                	sd	s0,32(sp)
    80001a64:	ec26                	sd	s1,24(sp)
    80001a66:	e84a                	sd	s2,16(sp)
    80001a68:	e44e                	sd	s3,8(sp)
    80001a6a:	e052                	sd	s4,0(sp)
    80001a6c:	1800                	addi	s0,sp,48
    80001a6e:	84aa                	mv	s1,a0
    80001a70:	892e                	mv	s2,a1
    80001a72:	89b2                	mv	s3,a2
    80001a74:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80001a76:	fffff097          	auipc	ra,0xfffff
    80001a7a:	538080e7          	jalr	1336(ra) # 80000fae <myproc>
    if (user_dst) {
    80001a7e:	c08d                	beqz	s1,80001aa0 <either_copyout+0x42>
        return copyout(p->pagetable, dst, src, len);
    80001a80:	86d2                	mv	a3,s4
    80001a82:	864e                	mv	a2,s3
    80001a84:	85ca                	mv	a1,s2
    80001a86:	6928                	ld	a0,80(a0)
    80001a88:	fffff097          	auipc	ra,0xfffff
    80001a8c:	1b8080e7          	jalr	440(ra) # 80000c40 <copyout>
    }
    else {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    80001a90:	70a2                	ld	ra,40(sp)
    80001a92:	7402                	ld	s0,32(sp)
    80001a94:	64e2                	ld	s1,24(sp)
    80001a96:	6942                	ld	s2,16(sp)
    80001a98:	69a2                	ld	s3,8(sp)
    80001a9a:	6a02                	ld	s4,0(sp)
    80001a9c:	6145                	addi	sp,sp,48
    80001a9e:	8082                	ret
        memmove((char *)dst, src, len);
    80001aa0:	000a061b          	sext.w	a2,s4
    80001aa4:	85ce                	mv	a1,s3
    80001aa6:	854a                	mv	a0,s2
    80001aa8:	fffff097          	auipc	ra,0xfffff
    80001aac:	872080e7          	jalr	-1934(ra) # 8000031a <memmove>
        return 0;
    80001ab0:	8526                	mv	a0,s1
    80001ab2:	bff9                	j	80001a90 <either_copyout+0x32>

0000000080001ab4 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001ab4:	7179                	addi	sp,sp,-48
    80001ab6:	f406                	sd	ra,40(sp)
    80001ab8:	f022                	sd	s0,32(sp)
    80001aba:	ec26                	sd	s1,24(sp)
    80001abc:	e84a                	sd	s2,16(sp)
    80001abe:	e44e                	sd	s3,8(sp)
    80001ac0:	e052                	sd	s4,0(sp)
    80001ac2:	1800                	addi	s0,sp,48
    80001ac4:	892a                	mv	s2,a0
    80001ac6:	84ae                	mv	s1,a1
    80001ac8:	89b2                	mv	s3,a2
    80001aca:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80001acc:	fffff097          	auipc	ra,0xfffff
    80001ad0:	4e2080e7          	jalr	1250(ra) # 80000fae <myproc>
    if (user_src) {
    80001ad4:	c08d                	beqz	s1,80001af6 <either_copyin+0x42>
        return copyin(p->pagetable, dst, src, len);
    80001ad6:	86d2                	mv	a3,s4
    80001ad8:	864e                	mv	a2,s3
    80001ada:	85ca                	mv	a1,s2
    80001adc:	6928                	ld	a0,80(a0)
    80001ade:	fffff097          	auipc	ra,0xfffff
    80001ae2:	21c080e7          	jalr	540(ra) # 80000cfa <copyin>
    }
    else {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    80001ae6:	70a2                	ld	ra,40(sp)
    80001ae8:	7402                	ld	s0,32(sp)
    80001aea:	64e2                	ld	s1,24(sp)
    80001aec:	6942                	ld	s2,16(sp)
    80001aee:	69a2                	ld	s3,8(sp)
    80001af0:	6a02                	ld	s4,0(sp)
    80001af2:	6145                	addi	sp,sp,48
    80001af4:	8082                	ret
        memmove(dst, (char *)src, len);
    80001af6:	000a061b          	sext.w	a2,s4
    80001afa:	85ce                	mv	a1,s3
    80001afc:	854a                	mv	a0,s2
    80001afe:	fffff097          	auipc	ra,0xfffff
    80001b02:	81c080e7          	jalr	-2020(ra) # 8000031a <memmove>
        return 0;
    80001b06:	8526                	mv	a0,s1
    80001b08:	bff9                	j	80001ae6 <either_copyin+0x32>

0000000080001b0a <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80001b0a:	715d                	addi	sp,sp,-80
    80001b0c:	e486                	sd	ra,72(sp)
    80001b0e:	e0a2                	sd	s0,64(sp)
    80001b10:	fc26                	sd	s1,56(sp)
    80001b12:	f84a                	sd	s2,48(sp)
    80001b14:	f44e                	sd	s3,40(sp)
    80001b16:	f052                	sd	s4,32(sp)
    80001b18:	ec56                	sd	s5,24(sp)
    80001b1a:	e85a                	sd	s6,16(sp)
    80001b1c:	e45e                	sd	s7,8(sp)
    80001b1e:	0880                	addi	s0,sp,80
    static char *states[] = {[UNUSED] "unused", [USED] "used", [SLEEPING] "sleep ", [RUNNABLE] "runble", [RUNNING] "run   ", [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    80001b20:	00006517          	auipc	a0,0x6
    80001b24:	53850513          	addi	a0,a0,1336 # 80008058 <etext+0x58>
    80001b28:	00004097          	auipc	ra,0x4
    80001b2c:	37e080e7          	jalr	894(ra) # 80005ea6 <printf>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001b30:	00227497          	auipc	s1,0x227
    80001b34:	38048493          	addi	s1,s1,896 # 80228eb0 <proc+0x158>
    80001b38:	0022d917          	auipc	s2,0x22d
    80001b3c:	d7890913          	addi	s2,s2,-648 # 8022e8b0 <bcache+0x140>
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b40:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    80001b42:	00006997          	auipc	s3,0x6
    80001b46:	6ce98993          	addi	s3,s3,1742 # 80008210 <etext+0x210>
        printf("%d %s %s", p->pid, state, p->name);
    80001b4a:	00006a97          	auipc	s5,0x6
    80001b4e:	6cea8a93          	addi	s5,s5,1742 # 80008218 <etext+0x218>
        printf("\n");
    80001b52:	00006a17          	auipc	s4,0x6
    80001b56:	506a0a13          	addi	s4,s4,1286 # 80008058 <etext+0x58>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b5a:	00006b97          	auipc	s7,0x6
    80001b5e:	6feb8b93          	addi	s7,s7,1790 # 80008258 <states.0>
    80001b62:	a00d                	j	80001b84 <procdump+0x7a>
        printf("%d %s %s", p->pid, state, p->name);
    80001b64:	ed86a583          	lw	a1,-296(a3)
    80001b68:	8556                	mv	a0,s5
    80001b6a:	00004097          	auipc	ra,0x4
    80001b6e:	33c080e7          	jalr	828(ra) # 80005ea6 <printf>
        printf("\n");
    80001b72:	8552                	mv	a0,s4
    80001b74:	00004097          	auipc	ra,0x4
    80001b78:	332080e7          	jalr	818(ra) # 80005ea6 <printf>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001b7c:	16848493          	addi	s1,s1,360
    80001b80:	03248263          	beq	s1,s2,80001ba4 <procdump+0x9a>
        if (p->state == UNUSED)
    80001b84:	86a6                	mv	a3,s1
    80001b86:	ec04a783          	lw	a5,-320(s1)
    80001b8a:	dbed                	beqz	a5,80001b7c <procdump+0x72>
            state = "???";
    80001b8c:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b8e:	fcfb6be3          	bltu	s6,a5,80001b64 <procdump+0x5a>
    80001b92:	02079713          	slli	a4,a5,0x20
    80001b96:	01d75793          	srli	a5,a4,0x1d
    80001b9a:	97de                	add	a5,a5,s7
    80001b9c:	6390                	ld	a2,0(a5)
    80001b9e:	f279                	bnez	a2,80001b64 <procdump+0x5a>
            state = "???";
    80001ba0:	864e                	mv	a2,s3
    80001ba2:	b7c9                	j	80001b64 <procdump+0x5a>
    }
}
    80001ba4:	60a6                	ld	ra,72(sp)
    80001ba6:	6406                	ld	s0,64(sp)
    80001ba8:	74e2                	ld	s1,56(sp)
    80001baa:	7942                	ld	s2,48(sp)
    80001bac:	79a2                	ld	s3,40(sp)
    80001bae:	7a02                	ld	s4,32(sp)
    80001bb0:	6ae2                	ld	s5,24(sp)
    80001bb2:	6b42                	ld	s6,16(sp)
    80001bb4:	6ba2                	ld	s7,8(sp)
    80001bb6:	6161                	addi	sp,sp,80
    80001bb8:	8082                	ret

0000000080001bba <swtch>:
    80001bba:	00153023          	sd	ra,0(a0)
    80001bbe:	00253423          	sd	sp,8(a0)
    80001bc2:	e900                	sd	s0,16(a0)
    80001bc4:	ed04                	sd	s1,24(a0)
    80001bc6:	03253023          	sd	s2,32(a0)
    80001bca:	03353423          	sd	s3,40(a0)
    80001bce:	03453823          	sd	s4,48(a0)
    80001bd2:	03553c23          	sd	s5,56(a0)
    80001bd6:	05653023          	sd	s6,64(a0)
    80001bda:	05753423          	sd	s7,72(a0)
    80001bde:	05853823          	sd	s8,80(a0)
    80001be2:	05953c23          	sd	s9,88(a0)
    80001be6:	07a53023          	sd	s10,96(a0)
    80001bea:	07b53423          	sd	s11,104(a0)
    80001bee:	0005b083          	ld	ra,0(a1)
    80001bf2:	0085b103          	ld	sp,8(a1)
    80001bf6:	6980                	ld	s0,16(a1)
    80001bf8:	6d84                	ld	s1,24(a1)
    80001bfa:	0205b903          	ld	s2,32(a1)
    80001bfe:	0285b983          	ld	s3,40(a1)
    80001c02:	0305ba03          	ld	s4,48(a1)
    80001c06:	0385ba83          	ld	s5,56(a1)
    80001c0a:	0405bb03          	ld	s6,64(a1)
    80001c0e:	0485bb83          	ld	s7,72(a1)
    80001c12:	0505bc03          	ld	s8,80(a1)
    80001c16:	0585bc83          	ld	s9,88(a1)
    80001c1a:	0605bd03          	ld	s10,96(a1)
    80001c1e:	0685bd83          	ld	s11,104(a1)
    80001c22:	8082                	ret

0000000080001c24 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80001c24:	1141                	addi	sp,sp,-16
    80001c26:	e406                	sd	ra,8(sp)
    80001c28:	e022                	sd	s0,0(sp)
    80001c2a:	0800                	addi	s0,sp,16
    initlock(&tickslock, "time");
    80001c2c:	00006597          	auipc	a1,0x6
    80001c30:	65c58593          	addi	a1,a1,1628 # 80008288 <states.0+0x30>
    80001c34:	0022d517          	auipc	a0,0x22d
    80001c38:	b2450513          	addi	a0,a0,-1244 # 8022e758 <tickslock>
    80001c3c:	00004097          	auipc	ra,0x4
    80001c40:	6c8080e7          	jalr	1736(ra) # 80006304 <initlock>
}
    80001c44:	60a2                	ld	ra,8(sp)
    80001c46:	6402                	ld	s0,0(sp)
    80001c48:	0141                	addi	sp,sp,16
    80001c4a:	8082                	ret

0000000080001c4c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80001c4c:	1141                	addi	sp,sp,-16
    80001c4e:	e422                	sd	s0,8(sp)
    80001c50:	0800                	addi	s0,sp,16
    asm volatile("csrw stvec, %0" : : "r"(x));
    80001c52:	00003797          	auipc	a5,0x3
    80001c56:	63e78793          	addi	a5,a5,1598 # 80005290 <kernelvec>
    80001c5a:	10579073          	csrw	stvec,a5
    w_stvec((uint64)kernelvec);
}
    80001c5e:	6422                	ld	s0,8(sp)
    80001c60:	0141                	addi	sp,sp,16
    80001c62:	8082                	ret

0000000080001c64 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80001c64:	1141                	addi	sp,sp,-16
    80001c66:	e406                	sd	ra,8(sp)
    80001c68:	e022                	sd	s0,0(sp)
    80001c6a:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80001c6c:	fffff097          	auipc	ra,0xfffff
    80001c70:	342080e7          	jalr	834(ra) # 80000fae <myproc>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80001c74:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c78:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80001c7a:	10079073          	csrw	sstatus,a5
    // kerneltrap() to usertrap(), so turn off interrupts until
    // we're back in user space, where usertrap() is correct.
    intr_off();

    // send syscalls, interrupts, and exceptions to uservec in trampoline.S
    uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001c7e:	00005697          	auipc	a3,0x5
    80001c82:	38268693          	addi	a3,a3,898 # 80007000 <_trampoline>
    80001c86:	00005717          	auipc	a4,0x5
    80001c8a:	37a70713          	addi	a4,a4,890 # 80007000 <_trampoline>
    80001c8e:	8f15                	sub	a4,a4,a3
    80001c90:	040007b7          	lui	a5,0x4000
    80001c94:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001c96:	07b2                	slli	a5,a5,0xc
    80001c98:	973e                	add	a4,a4,a5
    asm volatile("csrw stvec, %0" : : "r"(x));
    80001c9a:	10571073          	csrw	stvec,a4
    w_stvec(trampoline_uservec);

    // set up trapframe values that uservec will need when
    // the process next traps into the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c9e:	6d38                	ld	a4,88(a0)
    asm volatile("csrr %0, satp" : "=r"(x));
    80001ca0:	18002673          	csrr	a2,satp
    80001ca4:	e310                	sd	a2,0(a4)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001ca6:	6d30                	ld	a2,88(a0)
    80001ca8:	6138                	ld	a4,64(a0)
    80001caa:	6585                	lui	a1,0x1
    80001cac:	972e                	add	a4,a4,a1
    80001cae:	e618                	sd	a4,8(a2)
    p->trapframe->kernel_trap = (uint64)usertrap;
    80001cb0:	6d38                	ld	a4,88(a0)
    80001cb2:	00000617          	auipc	a2,0x0
    80001cb6:	31c60613          	addi	a2,a2,796 # 80001fce <usertrap>
    80001cba:	eb10                	sd	a2,16(a4)
    p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80001cbc:	6d38                	ld	a4,88(a0)
    asm volatile("mv %0, tp" : "=r"(x));
    80001cbe:	8612                	mv	a2,tp
    80001cc0:	f310                	sd	a2,32(a4)
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80001cc2:	10002773          	csrr	a4,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001cc6:	eff77713          	andi	a4,a4,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001cca:	02076713          	ori	a4,a4,32
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80001cce:	10071073          	csrw	sstatus,a4
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
    80001cd2:	6d38                	ld	a4,88(a0)
    asm volatile("csrw sepc, %0" : : "r"(x));
    80001cd4:	6f18                	ld	a4,24(a4)
    80001cd6:	14171073          	csrw	sepc,a4

    // tell trampoline.S the user page table to switch to.
    uint64 satp = MAKE_SATP(p->pagetable);
    80001cda:	6928                	ld	a0,80(a0)
    80001cdc:	8131                	srli	a0,a0,0xc

    // jump to userret in trampoline.S at the top of memory, which
    // switches to the user page table, restores user registers,
    // and switches to user mode with sret.
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001cde:	00005717          	auipc	a4,0x5
    80001ce2:	3be70713          	addi	a4,a4,958 # 8000709c <userret>
    80001ce6:	8f15                	sub	a4,a4,a3
    80001ce8:	97ba                	add	a5,a5,a4
    ((void (*)(uint64))trampoline_userret)(satp);
    80001cea:	577d                	li	a4,-1
    80001cec:	177e                	slli	a4,a4,0x3f
    80001cee:	8d59                	or	a0,a0,a4
    80001cf0:	9782                	jalr	a5
}
    80001cf2:	60a2                	ld	ra,8(sp)
    80001cf4:	6402                	ld	s0,0(sp)
    80001cf6:	0141                	addi	sp,sp,16
    80001cf8:	8082                	ret

0000000080001cfa <clockintr>:
    w_sepc(sepc);
    w_sstatus(sstatus);
}

void clockintr()
{
    80001cfa:	1101                	addi	sp,sp,-32
    80001cfc:	ec06                	sd	ra,24(sp)
    80001cfe:	e822                	sd	s0,16(sp)
    80001d00:	e426                	sd	s1,8(sp)
    80001d02:	1000                	addi	s0,sp,32
    acquire(&tickslock);
    80001d04:	0022d497          	auipc	s1,0x22d
    80001d08:	a5448493          	addi	s1,s1,-1452 # 8022e758 <tickslock>
    80001d0c:	8526                	mv	a0,s1
    80001d0e:	00004097          	auipc	ra,0x4
    80001d12:	686080e7          	jalr	1670(ra) # 80006394 <acquire>
    ticks++;
    80001d16:	00007517          	auipc	a0,0x7
    80001d1a:	bc250513          	addi	a0,a0,-1086 # 800088d8 <ticks>
    80001d1e:	411c                	lw	a5,0(a0)
    80001d20:	2785                	addiw	a5,a5,1
    80001d22:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001d24:	00000097          	auipc	ra,0x0
    80001d28:	996080e7          	jalr	-1642(ra) # 800016ba <wakeup>
    release(&tickslock);
    80001d2c:	8526                	mv	a0,s1
    80001d2e:	00004097          	auipc	ra,0x4
    80001d32:	71a080e7          	jalr	1818(ra) # 80006448 <release>
}
    80001d36:	60e2                	ld	ra,24(sp)
    80001d38:	6442                	ld	s0,16(sp)
    80001d3a:	64a2                	ld	s1,8(sp)
    80001d3c:	6105                	addi	sp,sp,32
    80001d3e:	8082                	ret

0000000080001d40 <devintr>:
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr()
{
    80001d40:	1101                	addi	sp,sp,-32
    80001d42:	ec06                	sd	ra,24(sp)
    80001d44:	e822                	sd	s0,16(sp)
    80001d46:	e426                	sd	s1,8(sp)
    80001d48:	1000                	addi	s0,sp,32
    asm volatile("csrr %0, scause" : "=r"(x));
    80001d4a:	14202773          	csrr	a4,scause
    uint64 scause = r_scause();

    if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001d4e:	00074d63          	bltz	a4,80001d68 <devintr+0x28>
        if (irq)
            plic_complete(irq);

        return 1;
    }
    else if (scause == 0x8000000000000001L) {
    80001d52:	57fd                	li	a5,-1
    80001d54:	17fe                	slli	a5,a5,0x3f
    80001d56:	0785                	addi	a5,a5,1
        w_sip(r_sip() & ~2);

        return 2;
    }
    else {
        return 0;
    80001d58:	4501                	li	a0,0
    else if (scause == 0x8000000000000001L) {
    80001d5a:	06f70363          	beq	a4,a5,80001dc0 <devintr+0x80>
    }
}
    80001d5e:	60e2                	ld	ra,24(sp)
    80001d60:	6442                	ld	s0,16(sp)
    80001d62:	64a2                	ld	s1,8(sp)
    80001d64:	6105                	addi	sp,sp,32
    80001d66:	8082                	ret
    if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001d68:	0ff77793          	zext.b	a5,a4
    80001d6c:	46a5                	li	a3,9
    80001d6e:	fed792e3          	bne	a5,a3,80001d52 <devintr+0x12>
        int irq = plic_claim();
    80001d72:	00003097          	auipc	ra,0x3
    80001d76:	626080e7          	jalr	1574(ra) # 80005398 <plic_claim>
    80001d7a:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ) {
    80001d7c:	47a9                	li	a5,10
    80001d7e:	02f50763          	beq	a0,a5,80001dac <devintr+0x6c>
        else if (irq == VIRTIO0_IRQ) {
    80001d82:	4785                	li	a5,1
    80001d84:	02f50963          	beq	a0,a5,80001db6 <devintr+0x76>
        return 1;
    80001d88:	4505                	li	a0,1
        else if (irq) {
    80001d8a:	d8f1                	beqz	s1,80001d5e <devintr+0x1e>
            printf("unexpected interrupt irq=%d\n", irq);
    80001d8c:	85a6                	mv	a1,s1
    80001d8e:	00006517          	auipc	a0,0x6
    80001d92:	50250513          	addi	a0,a0,1282 # 80008290 <states.0+0x38>
    80001d96:	00004097          	auipc	ra,0x4
    80001d9a:	110080e7          	jalr	272(ra) # 80005ea6 <printf>
            plic_complete(irq);
    80001d9e:	8526                	mv	a0,s1
    80001da0:	00003097          	auipc	ra,0x3
    80001da4:	61c080e7          	jalr	1564(ra) # 800053bc <plic_complete>
        return 1;
    80001da8:	4505                	li	a0,1
    80001daa:	bf55                	j	80001d5e <devintr+0x1e>
            uartintr();
    80001dac:	00004097          	auipc	ra,0x4
    80001db0:	508080e7          	jalr	1288(ra) # 800062b4 <uartintr>
    80001db4:	b7ed                	j	80001d9e <devintr+0x5e>
            virtio_disk_intr();
    80001db6:	00004097          	auipc	ra,0x4
    80001dba:	ace080e7          	jalr	-1330(ra) # 80005884 <virtio_disk_intr>
    80001dbe:	b7c5                	j	80001d9e <devintr+0x5e>
        if (cpuid() == 0) {
    80001dc0:	fffff097          	auipc	ra,0xfffff
    80001dc4:	1c2080e7          	jalr	450(ra) # 80000f82 <cpuid>
    80001dc8:	c901                	beqz	a0,80001dd8 <devintr+0x98>
    asm volatile("csrr %0, sip" : "=r"(x));
    80001dca:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    80001dce:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sip, %0" : : "r"(x));
    80001dd0:	14479073          	csrw	sip,a5
        return 2;
    80001dd4:	4509                	li	a0,2
    80001dd6:	b761                	j	80001d5e <devintr+0x1e>
            clockintr();
    80001dd8:	00000097          	auipc	ra,0x0
    80001ddc:	f22080e7          	jalr	-222(ra) # 80001cfa <clockintr>
    80001de0:	b7ed                	j	80001dca <devintr+0x8a>

0000000080001de2 <kerneltrap>:
{
    80001de2:	7179                	addi	sp,sp,-48
    80001de4:	f406                	sd	ra,40(sp)
    80001de6:	f022                	sd	s0,32(sp)
    80001de8:	ec26                	sd	s1,24(sp)
    80001dea:	e84a                	sd	s2,16(sp)
    80001dec:	e44e                	sd	s3,8(sp)
    80001dee:	1800                	addi	s0,sp,48
    asm volatile("csrr %0, sepc" : "=r"(x));
    80001df0:	14102973          	csrr	s2,sepc
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80001df4:	100024f3          	csrr	s1,sstatus
    asm volatile("csrr %0, scause" : "=r"(x));
    80001df8:	142029f3          	csrr	s3,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    80001dfc:	1004f793          	andi	a5,s1,256
    80001e00:	cb85                	beqz	a5,80001e30 <kerneltrap+0x4e>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e02:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    80001e06:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    80001e08:	ef85                	bnez	a5,80001e40 <kerneltrap+0x5e>
    if ((which_dev = devintr()) == 0) {
    80001e0a:	00000097          	auipc	ra,0x0
    80001e0e:	f36080e7          	jalr	-202(ra) # 80001d40 <devintr>
    80001e12:	cd1d                	beqz	a0,80001e50 <kerneltrap+0x6e>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e14:	4789                	li	a5,2
    80001e16:	06f50a63          	beq	a0,a5,80001e8a <kerneltrap+0xa8>
    asm volatile("csrw sepc, %0" : : "r"(x));
    80001e1a:	14191073          	csrw	sepc,s2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80001e1e:	10049073          	csrw	sstatus,s1
}
    80001e22:	70a2                	ld	ra,40(sp)
    80001e24:	7402                	ld	s0,32(sp)
    80001e26:	64e2                	ld	s1,24(sp)
    80001e28:	6942                	ld	s2,16(sp)
    80001e2a:	69a2                	ld	s3,8(sp)
    80001e2c:	6145                	addi	sp,sp,48
    80001e2e:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80001e30:	00006517          	auipc	a0,0x6
    80001e34:	48050513          	addi	a0,a0,1152 # 800082b0 <states.0+0x58>
    80001e38:	00004097          	auipc	ra,0x4
    80001e3c:	024080e7          	jalr	36(ra) # 80005e5c <panic>
        panic("kerneltrap: interrupts enabled");
    80001e40:	00006517          	auipc	a0,0x6
    80001e44:	49850513          	addi	a0,a0,1176 # 800082d8 <states.0+0x80>
    80001e48:	00004097          	auipc	ra,0x4
    80001e4c:	014080e7          	jalr	20(ra) # 80005e5c <panic>
        printf("scause %p\n", scause);
    80001e50:	85ce                	mv	a1,s3
    80001e52:	00006517          	auipc	a0,0x6
    80001e56:	4a650513          	addi	a0,a0,1190 # 800082f8 <states.0+0xa0>
    80001e5a:	00004097          	auipc	ra,0x4
    80001e5e:	04c080e7          	jalr	76(ra) # 80005ea6 <printf>
    asm volatile("csrr %0, sepc" : "=r"(x));
    80001e62:	141025f3          	csrr	a1,sepc
    asm volatile("csrr %0, stval" : "=r"(x));
    80001e66:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e6a:	00006517          	auipc	a0,0x6
    80001e6e:	49e50513          	addi	a0,a0,1182 # 80008308 <states.0+0xb0>
    80001e72:	00004097          	auipc	ra,0x4
    80001e76:	034080e7          	jalr	52(ra) # 80005ea6 <printf>
        panic("kerneltrap");
    80001e7a:	00006517          	auipc	a0,0x6
    80001e7e:	4a650513          	addi	a0,a0,1190 # 80008320 <states.0+0xc8>
    80001e82:	00004097          	auipc	ra,0x4
    80001e86:	fda080e7          	jalr	-38(ra) # 80005e5c <panic>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e8a:	fffff097          	auipc	ra,0xfffff
    80001e8e:	124080e7          	jalr	292(ra) # 80000fae <myproc>
    80001e92:	d541                	beqz	a0,80001e1a <kerneltrap+0x38>
    80001e94:	fffff097          	auipc	ra,0xfffff
    80001e98:	11a080e7          	jalr	282(ra) # 80000fae <myproc>
    80001e9c:	4d18                	lw	a4,24(a0)
    80001e9e:	4791                	li	a5,4
    80001ea0:	f6f71de3          	bne	a4,a5,80001e1a <kerneltrap+0x38>
        yield();
    80001ea4:	fffff097          	auipc	ra,0xfffff
    80001ea8:	776080e7          	jalr	1910(ra) # 8000161a <yield>
    80001eac:	b7bd                	j	80001e1a <kerneltrap+0x38>

0000000080001eae <isCOWPG>:

int isCOWPG(pagetable_t pg, uint64 va)
{
    if (va > MAXVA)
    80001eae:	4785                	li	a5,1
    80001eb0:	179a                	slli	a5,a5,0x26
    80001eb2:	00b7f463          	bgeu	a5,a1,80001eba <isCOWPG+0xc>
        return -1;
    80001eb6:	557d                	li	a0,-1
    if ((*pte & PTE_V) == 0)
        return 0;
    if ((*pte & PTE_COW))
        return 1;
    return 0;
}
    80001eb8:	8082                	ret
{
    80001eba:	1141                	addi	sp,sp,-16
    80001ebc:	e406                	sd	ra,8(sp)
    80001ebe:	e022                	sd	s0,0(sp)
    80001ec0:	0800                	addi	s0,sp,16
    pte_t *pte = walk(pg, va, 0);
    80001ec2:	4601                	li	a2,0
    80001ec4:	ffffe097          	auipc	ra,0xffffe
    80001ec8:	6de080e7          	jalr	1758(ra) # 800005a2 <walk>
    if (pte == 0)
    80001ecc:	cd01                	beqz	a0,80001ee4 <isCOWPG+0x36>
    if ((*pte & PTE_COW))
    80001ece:	6108                	ld	a0,0(a0)
    80001ed0:	10157513          	andi	a0,a0,257
    80001ed4:	eff50513          	addi	a0,a0,-257
        return -1;
    80001ed8:	00153513          	seqz	a0,a0
}
    80001edc:	60a2                	ld	ra,8(sp)
    80001ede:	6402                	ld	s0,0(sp)
    80001ee0:	0141                	addi	sp,sp,16
    80001ee2:	8082                	ret
        return 0;
    80001ee4:	4501                	li	a0,0
    80001ee6:	bfdd                	j	80001edc <isCOWPG+0x2e>

0000000080001ee8 <allocCOWPG>:

void *allocCOWPG(pagetable_t pg, uint64 va)
{
    80001ee8:	7139                	addi	sp,sp,-64
    80001eea:	fc06                	sd	ra,56(sp)
    80001eec:	f822                	sd	s0,48(sp)
    80001eee:	f426                	sd	s1,40(sp)
    80001ef0:	f04a                	sd	s2,32(sp)
    80001ef2:	ec4e                	sd	s3,24(sp)
    80001ef4:	e852                	sd	s4,16(sp)
    80001ef6:	e456                	sd	s5,8(sp)
    80001ef8:	0080                	addi	s0,sp,64
    va = PGROUNDDOWN(va);
    80001efa:	77fd                	lui	a5,0xfffff
    80001efc:	00f5f4b3          	and	s1,a1,a5
    if (va % PGSIZE != 0 || va > MAXVA)
    80001f00:	4785                	li	a5,1
    80001f02:	179a                	slli	a5,a5,0x26
        return 0;
    80001f04:	4901                	li	s2,0
    if (va % PGSIZE != 0 || va > MAXVA)
    80001f06:	0897e163          	bltu	a5,s1,80001f88 <allocCOWPG+0xa0>
    80001f0a:	8aaa                	mv	s5,a0

    uint64 pa = walkaddr(pg, va);
    80001f0c:	85a6                	mv	a1,s1
    80001f0e:	ffffe097          	auipc	ra,0xffffe
    80001f12:	73a080e7          	jalr	1850(ra) # 80000648 <walkaddr>
    80001f16:	89aa                	mv	s3,a0
    if (pa == 0)
        return 0;
    80001f18:	4901                	li	s2,0
    if (pa == 0)
    80001f1a:	c53d                	beqz	a0,80001f88 <allocCOWPG+0xa0>

    pte_t *pte = walk(pg, va, 0);
    80001f1c:	4601                	li	a2,0
    80001f1e:	85a6                	mv	a1,s1
    80001f20:	8556                	mv	a0,s5
    80001f22:	ffffe097          	auipc	ra,0xffffe
    80001f26:	680080e7          	jalr	1664(ra) # 800005a2 <walk>
    80001f2a:	8a2a                	mv	s4,a0
    if (pte == 0)
    80001f2c:	cd59                	beqz	a0,80001fca <allocCOWPG+0xe2>
        return 0;

    int count = GetPGRefCount((void *)pa);
    80001f2e:	854e                	mv	a0,s3
    80001f30:	ffffe097          	auipc	ra,0xffffe
    80001f34:	370080e7          	jalr	880(ra) # 800002a0 <GetPGRefCount>
    if (count == 1) { // 只有一个进程在使用当前页，设置为可写并将COW标志位复位
    80001f38:	4785                	li	a5,1
    80001f3a:	06f50163          	beq	a0,a5,80001f9c <allocCOWPG+0xb4>
        *pte = (*pte & ~PTE_COW) | PTE_W;
        return (void *)pa;
    }
    else {
        // 有多个进程在使用当前页，需要分配新的物理页
        char *mem = kalloc();
    80001f3e:	ffffe097          	auipc	ra,0xffffe
    80001f42:	268080e7          	jalr	616(ra) # 800001a6 <kalloc>
    80001f46:	892a                	mv	s2,a0
        if (mem == 0)
    80001f48:	c121                	beqz	a0,80001f88 <allocCOWPG+0xa0>
            return 0;

        memmove(mem, (char *)pa, PGSIZE);
    80001f4a:	6605                	lui	a2,0x1
    80001f4c:	85ce                	mv	a1,s3
    80001f4e:	ffffe097          	auipc	ra,0xffffe
    80001f52:	3cc080e7          	jalr	972(ra) # 8000031a <memmove>

        // 清除有效位PTE_V，否则在mappagges中会判定为remap
        *pte = (*pte) & ~PTE_V;
    80001f56:	000a3703          	ld	a4,0(s4)
    80001f5a:	9b79                	andi	a4,a4,-2
    80001f5c:	00ea3023          	sd	a4,0(s4)

        if (mappages(pg, va, PGSIZE, (uint64)mem, (PTE_FLAGS(*pte) & ~PTE_COW) | PTE_W) != 0) {
    80001f60:	2fb77713          	andi	a4,a4,763
    80001f64:	00476713          	ori	a4,a4,4
    80001f68:	86ca                	mv	a3,s2
    80001f6a:	6605                	lui	a2,0x1
    80001f6c:	85a6                	mv	a1,s1
    80001f6e:	8556                	mv	a0,s5
    80001f70:	ffffe097          	auipc	ra,0xffffe
    80001f74:	71a080e7          	jalr	1818(ra) # 8000068a <mappages>
    80001f78:	ed05                	bnez	a0,80001fb0 <allocCOWPG+0xc8>
            kfree(mem);
            *pte = (*pte) | PTE_V;
            return 0;
        }

        kfree((void *)PGROUNDDOWN(pa));
    80001f7a:	757d                	lui	a0,0xfffff
    80001f7c:	00a9f533          	and	a0,s3,a0
    80001f80:	ffffe097          	auipc	ra,0xffffe
    80001f84:	09c080e7          	jalr	156(ra) # 8000001c <kfree>

        return (void *)mem;
    }
}
    80001f88:	854a                	mv	a0,s2
    80001f8a:	70e2                	ld	ra,56(sp)
    80001f8c:	7442                	ld	s0,48(sp)
    80001f8e:	74a2                	ld	s1,40(sp)
    80001f90:	7902                	ld	s2,32(sp)
    80001f92:	69e2                	ld	s3,24(sp)
    80001f94:	6a42                	ld	s4,16(sp)
    80001f96:	6aa2                	ld	s5,8(sp)
    80001f98:	6121                	addi	sp,sp,64
    80001f9a:	8082                	ret
        *pte = (*pte & ~PTE_COW) | PTE_W;
    80001f9c:	000a3783          	ld	a5,0(s4)
    80001fa0:	efb7f793          	andi	a5,a5,-261
    80001fa4:	0047e793          	ori	a5,a5,4
    80001fa8:	00fa3023          	sd	a5,0(s4)
        return (void *)pa;
    80001fac:	894e                	mv	s2,s3
    80001fae:	bfe9                	j	80001f88 <allocCOWPG+0xa0>
            kfree(mem);
    80001fb0:	854a                	mv	a0,s2
    80001fb2:	ffffe097          	auipc	ra,0xffffe
    80001fb6:	06a080e7          	jalr	106(ra) # 8000001c <kfree>
            *pte = (*pte) | PTE_V;
    80001fba:	000a3783          	ld	a5,0(s4)
    80001fbe:	0017e793          	ori	a5,a5,1
    80001fc2:	00fa3023          	sd	a5,0(s4)
            return 0;
    80001fc6:	4901                	li	s2,0
    80001fc8:	b7c1                	j	80001f88 <allocCOWPG+0xa0>
        return 0;
    80001fca:	892a                	mv	s2,a0
    80001fcc:	bf75                	j	80001f88 <allocCOWPG+0xa0>

0000000080001fce <usertrap>:
{
    80001fce:	1101                	addi	sp,sp,-32
    80001fd0:	ec06                	sd	ra,24(sp)
    80001fd2:	e822                	sd	s0,16(sp)
    80001fd4:	e426                	sd	s1,8(sp)
    80001fd6:	e04a                	sd	s2,0(sp)
    80001fd8:	1000                	addi	s0,sp,32
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80001fda:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    80001fde:	1007f793          	andi	a5,a5,256
    80001fe2:	e7b5                	bnez	a5,8000204e <usertrap+0x80>
    asm volatile("csrw stvec, %0" : : "r"(x));
    80001fe4:	00003797          	auipc	a5,0x3
    80001fe8:	2ac78793          	addi	a5,a5,684 # 80005290 <kernelvec>
    80001fec:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80001ff0:	fffff097          	auipc	ra,0xfffff
    80001ff4:	fbe080e7          	jalr	-66(ra) # 80000fae <myproc>
    80001ff8:	84aa                	mv	s1,a0
    p->trapframe->epc = r_sepc();
    80001ffa:	6d3c                	ld	a5,88(a0)
    asm volatile("csrr %0, sepc" : "=r"(x));
    80001ffc:	14102773          	csrr	a4,sepc
    80002000:	ef98                	sd	a4,24(a5)
    asm volatile("csrr %0, scause" : "=r"(x));
    80002002:	14202773          	csrr	a4,scause
    if (r_scause() == 8) {
    80002006:	47a1                	li	a5,8
    80002008:	04f70b63          	beq	a4,a5,8000205e <usertrap+0x90>
    8000200c:	14202773          	csrr	a4,scause
    else if (r_scause() == 13 || r_scause() == 15) {
    80002010:	47b5                	li	a5,13
    80002012:	00f70763          	beq	a4,a5,80002020 <usertrap+0x52>
    80002016:	14202773          	csrr	a4,scause
    8000201a:	47bd                	li	a5,15
    8000201c:	08f71c63          	bne	a4,a5,800020b4 <usertrap+0xe6>
    asm volatile("csrr %0, stval" : "=r"(x));
    80002020:	14302973          	csrr	s2,stval
        if (va >= p->sz || isCOWPG(p->pagetable, va) != 1 || allocCOWPG(p->pagetable, va) == 0)
    80002024:	64bc                	ld	a5,72(s1)
    80002026:	06f96663          	bltu	s2,a5,80002092 <usertrap+0xc4>
            p->killed = 1;
    8000202a:	4785                	li	a5,1
    8000202c:	d49c                	sw	a5,40(s1)
    if (killed(p))
    8000202e:	8526                	mv	a0,s1
    80002030:	00000097          	auipc	ra,0x0
    80002034:	8ce080e7          	jalr	-1842(ra) # 800018fe <killed>
    80002038:	e961                	bnez	a0,80002108 <usertrap+0x13a>
    usertrapret();
    8000203a:	00000097          	auipc	ra,0x0
    8000203e:	c2a080e7          	jalr	-982(ra) # 80001c64 <usertrapret>
}
    80002042:	60e2                	ld	ra,24(sp)
    80002044:	6442                	ld	s0,16(sp)
    80002046:	64a2                	ld	s1,8(sp)
    80002048:	6902                	ld	s2,0(sp)
    8000204a:	6105                	addi	sp,sp,32
    8000204c:	8082                	ret
        panic("usertrap: not from user mode");
    8000204e:	00006517          	auipc	a0,0x6
    80002052:	2e250513          	addi	a0,a0,738 # 80008330 <states.0+0xd8>
    80002056:	00004097          	auipc	ra,0x4
    8000205a:	e06080e7          	jalr	-506(ra) # 80005e5c <panic>
        if (killed(p))
    8000205e:	00000097          	auipc	ra,0x0
    80002062:	8a0080e7          	jalr	-1888(ra) # 800018fe <killed>
    80002066:	e105                	bnez	a0,80002086 <usertrap+0xb8>
        p->trapframe->epc += 4;
    80002068:	6cb8                	ld	a4,88(s1)
    8000206a:	6f1c                	ld	a5,24(a4)
    8000206c:	0791                	addi	a5,a5,4
    8000206e:	ef1c                	sd	a5,24(a4)
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002070:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002074:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80002078:	10079073          	csrw	sstatus,a5
        syscall();
    8000207c:	00000097          	auipc	ra,0x0
    80002080:	226080e7          	jalr	550(ra) # 800022a2 <syscall>
    80002084:	b76d                	j	8000202e <usertrap+0x60>
            exit(-1);
    80002086:	557d                	li	a0,-1
    80002088:	fffff097          	auipc	ra,0xfffff
    8000208c:	702080e7          	jalr	1794(ra) # 8000178a <exit>
    80002090:	bfe1                	j	80002068 <usertrap+0x9a>
        if (va >= p->sz || isCOWPG(p->pagetable, va) != 1 || allocCOWPG(p->pagetable, va) == 0)
    80002092:	85ca                	mv	a1,s2
    80002094:	68a8                	ld	a0,80(s1)
    80002096:	00000097          	auipc	ra,0x0
    8000209a:	e18080e7          	jalr	-488(ra) # 80001eae <isCOWPG>
    8000209e:	4785                	li	a5,1
    800020a0:	f8f515e3          	bne	a0,a5,8000202a <usertrap+0x5c>
    800020a4:	85ca                	mv	a1,s2
    800020a6:	68a8                	ld	a0,80(s1)
    800020a8:	00000097          	auipc	ra,0x0
    800020ac:	e40080e7          	jalr	-448(ra) # 80001ee8 <allocCOWPG>
    800020b0:	fd3d                	bnez	a0,8000202e <usertrap+0x60>
    800020b2:	bfa5                	j	8000202a <usertrap+0x5c>
    else if ((which_dev = devintr()) != 0) {
    800020b4:	00000097          	auipc	ra,0x0
    800020b8:	c8c080e7          	jalr	-884(ra) # 80001d40 <devintr>
    800020bc:	892a                	mv	s2,a0
    800020be:	c901                	beqz	a0,800020ce <usertrap+0x100>
    if (killed(p))
    800020c0:	8526                	mv	a0,s1
    800020c2:	00000097          	auipc	ra,0x0
    800020c6:	83c080e7          	jalr	-1988(ra) # 800018fe <killed>
    800020ca:	c529                	beqz	a0,80002114 <usertrap+0x146>
    800020cc:	a83d                	j	8000210a <usertrap+0x13c>
    asm volatile("csrr %0, scause" : "=r"(x));
    800020ce:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    800020d2:	5890                	lw	a2,48(s1)
    800020d4:	00006517          	auipc	a0,0x6
    800020d8:	27c50513          	addi	a0,a0,636 # 80008350 <states.0+0xf8>
    800020dc:	00004097          	auipc	ra,0x4
    800020e0:	dca080e7          	jalr	-566(ra) # 80005ea6 <printf>
    asm volatile("csrr %0, sepc" : "=r"(x));
    800020e4:	141025f3          	csrr	a1,sepc
    asm volatile("csrr %0, stval" : "=r"(x));
    800020e8:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800020ec:	00006517          	auipc	a0,0x6
    800020f0:	29450513          	addi	a0,a0,660 # 80008380 <states.0+0x128>
    800020f4:	00004097          	auipc	ra,0x4
    800020f8:	db2080e7          	jalr	-590(ra) # 80005ea6 <printf>
        setkilled(p);
    800020fc:	8526                	mv	a0,s1
    800020fe:	fffff097          	auipc	ra,0xfffff
    80002102:	7d4080e7          	jalr	2004(ra) # 800018d2 <setkilled>
    80002106:	b725                	j	8000202e <usertrap+0x60>
    if (killed(p))
    80002108:	4901                	li	s2,0
        exit(-1);
    8000210a:	557d                	li	a0,-1
    8000210c:	fffff097          	auipc	ra,0xfffff
    80002110:	67e080e7          	jalr	1662(ra) # 8000178a <exit>
    if (which_dev == 2)
    80002114:	4789                	li	a5,2
    80002116:	f2f912e3          	bne	s2,a5,8000203a <usertrap+0x6c>
        yield();
    8000211a:	fffff097          	auipc	ra,0xfffff
    8000211e:	500080e7          	jalr	1280(ra) # 8000161a <yield>
    80002122:	bf21                	j	8000203a <usertrap+0x6c>

0000000080002124 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002124:	1101                	addi	sp,sp,-32
    80002126:	ec06                	sd	ra,24(sp)
    80002128:	e822                	sd	s0,16(sp)
    8000212a:	e426                	sd	s1,8(sp)
    8000212c:	1000                	addi	s0,sp,32
    8000212e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002130:	fffff097          	auipc	ra,0xfffff
    80002134:	e7e080e7          	jalr	-386(ra) # 80000fae <myproc>
  switch (n) {
    80002138:	4795                	li	a5,5
    8000213a:	0497e163          	bltu	a5,s1,8000217c <argraw+0x58>
    8000213e:	048a                	slli	s1,s1,0x2
    80002140:	00006717          	auipc	a4,0x6
    80002144:	28870713          	addi	a4,a4,648 # 800083c8 <states.0+0x170>
    80002148:	94ba                	add	s1,s1,a4
    8000214a:	409c                	lw	a5,0(s1)
    8000214c:	97ba                	add	a5,a5,a4
    8000214e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002150:	6d3c                	ld	a5,88(a0)
    80002152:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002154:	60e2                	ld	ra,24(sp)
    80002156:	6442                	ld	s0,16(sp)
    80002158:	64a2                	ld	s1,8(sp)
    8000215a:	6105                	addi	sp,sp,32
    8000215c:	8082                	ret
    return p->trapframe->a1;
    8000215e:	6d3c                	ld	a5,88(a0)
    80002160:	7fa8                	ld	a0,120(a5)
    80002162:	bfcd                	j	80002154 <argraw+0x30>
    return p->trapframe->a2;
    80002164:	6d3c                	ld	a5,88(a0)
    80002166:	63c8                	ld	a0,128(a5)
    80002168:	b7f5                	j	80002154 <argraw+0x30>
    return p->trapframe->a3;
    8000216a:	6d3c                	ld	a5,88(a0)
    8000216c:	67c8                	ld	a0,136(a5)
    8000216e:	b7dd                	j	80002154 <argraw+0x30>
    return p->trapframe->a4;
    80002170:	6d3c                	ld	a5,88(a0)
    80002172:	6bc8                	ld	a0,144(a5)
    80002174:	b7c5                	j	80002154 <argraw+0x30>
    return p->trapframe->a5;
    80002176:	6d3c                	ld	a5,88(a0)
    80002178:	6fc8                	ld	a0,152(a5)
    8000217a:	bfe9                	j	80002154 <argraw+0x30>
  panic("argraw");
    8000217c:	00006517          	auipc	a0,0x6
    80002180:	22450513          	addi	a0,a0,548 # 800083a0 <states.0+0x148>
    80002184:	00004097          	auipc	ra,0x4
    80002188:	cd8080e7          	jalr	-808(ra) # 80005e5c <panic>

000000008000218c <fetchaddr>:
{
    8000218c:	1101                	addi	sp,sp,-32
    8000218e:	ec06                	sd	ra,24(sp)
    80002190:	e822                	sd	s0,16(sp)
    80002192:	e426                	sd	s1,8(sp)
    80002194:	e04a                	sd	s2,0(sp)
    80002196:	1000                	addi	s0,sp,32
    80002198:	84aa                	mv	s1,a0
    8000219a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000219c:	fffff097          	auipc	ra,0xfffff
    800021a0:	e12080e7          	jalr	-494(ra) # 80000fae <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800021a4:	653c                	ld	a5,72(a0)
    800021a6:	02f4f863          	bgeu	s1,a5,800021d6 <fetchaddr+0x4a>
    800021aa:	00848713          	addi	a4,s1,8
    800021ae:	02e7e663          	bltu	a5,a4,800021da <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800021b2:	46a1                	li	a3,8
    800021b4:	8626                	mv	a2,s1
    800021b6:	85ca                	mv	a1,s2
    800021b8:	6928                	ld	a0,80(a0)
    800021ba:	fffff097          	auipc	ra,0xfffff
    800021be:	b40080e7          	jalr	-1216(ra) # 80000cfa <copyin>
    800021c2:	00a03533          	snez	a0,a0
    800021c6:	40a00533          	neg	a0,a0
}
    800021ca:	60e2                	ld	ra,24(sp)
    800021cc:	6442                	ld	s0,16(sp)
    800021ce:	64a2                	ld	s1,8(sp)
    800021d0:	6902                	ld	s2,0(sp)
    800021d2:	6105                	addi	sp,sp,32
    800021d4:	8082                	ret
    return -1;
    800021d6:	557d                	li	a0,-1
    800021d8:	bfcd                	j	800021ca <fetchaddr+0x3e>
    800021da:	557d                	li	a0,-1
    800021dc:	b7fd                	j	800021ca <fetchaddr+0x3e>

00000000800021de <fetchstr>:
{
    800021de:	7179                	addi	sp,sp,-48
    800021e0:	f406                	sd	ra,40(sp)
    800021e2:	f022                	sd	s0,32(sp)
    800021e4:	ec26                	sd	s1,24(sp)
    800021e6:	e84a                	sd	s2,16(sp)
    800021e8:	e44e                	sd	s3,8(sp)
    800021ea:	1800                	addi	s0,sp,48
    800021ec:	892a                	mv	s2,a0
    800021ee:	84ae                	mv	s1,a1
    800021f0:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800021f2:	fffff097          	auipc	ra,0xfffff
    800021f6:	dbc080e7          	jalr	-580(ra) # 80000fae <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800021fa:	86ce                	mv	a3,s3
    800021fc:	864a                	mv	a2,s2
    800021fe:	85a6                	mv	a1,s1
    80002200:	6928                	ld	a0,80(a0)
    80002202:	fffff097          	auipc	ra,0xfffff
    80002206:	b86080e7          	jalr	-1146(ra) # 80000d88 <copyinstr>
    8000220a:	00054e63          	bltz	a0,80002226 <fetchstr+0x48>
  return strlen(buf);
    8000220e:	8526                	mv	a0,s1
    80002210:	ffffe097          	auipc	ra,0xffffe
    80002214:	22a080e7          	jalr	554(ra) # 8000043a <strlen>
}
    80002218:	70a2                	ld	ra,40(sp)
    8000221a:	7402                	ld	s0,32(sp)
    8000221c:	64e2                	ld	s1,24(sp)
    8000221e:	6942                	ld	s2,16(sp)
    80002220:	69a2                	ld	s3,8(sp)
    80002222:	6145                	addi	sp,sp,48
    80002224:	8082                	ret
    return -1;
    80002226:	557d                	li	a0,-1
    80002228:	bfc5                	j	80002218 <fetchstr+0x3a>

000000008000222a <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000222a:	1101                	addi	sp,sp,-32
    8000222c:	ec06                	sd	ra,24(sp)
    8000222e:	e822                	sd	s0,16(sp)
    80002230:	e426                	sd	s1,8(sp)
    80002232:	1000                	addi	s0,sp,32
    80002234:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002236:	00000097          	auipc	ra,0x0
    8000223a:	eee080e7          	jalr	-274(ra) # 80002124 <argraw>
    8000223e:	c088                	sw	a0,0(s1)
}
    80002240:	60e2                	ld	ra,24(sp)
    80002242:	6442                	ld	s0,16(sp)
    80002244:	64a2                	ld	s1,8(sp)
    80002246:	6105                	addi	sp,sp,32
    80002248:	8082                	ret

000000008000224a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000224a:	1101                	addi	sp,sp,-32
    8000224c:	ec06                	sd	ra,24(sp)
    8000224e:	e822                	sd	s0,16(sp)
    80002250:	e426                	sd	s1,8(sp)
    80002252:	1000                	addi	s0,sp,32
    80002254:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002256:	00000097          	auipc	ra,0x0
    8000225a:	ece080e7          	jalr	-306(ra) # 80002124 <argraw>
    8000225e:	e088                	sd	a0,0(s1)
}
    80002260:	60e2                	ld	ra,24(sp)
    80002262:	6442                	ld	s0,16(sp)
    80002264:	64a2                	ld	s1,8(sp)
    80002266:	6105                	addi	sp,sp,32
    80002268:	8082                	ret

000000008000226a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000226a:	7179                	addi	sp,sp,-48
    8000226c:	f406                	sd	ra,40(sp)
    8000226e:	f022                	sd	s0,32(sp)
    80002270:	ec26                	sd	s1,24(sp)
    80002272:	e84a                	sd	s2,16(sp)
    80002274:	1800                	addi	s0,sp,48
    80002276:	84ae                	mv	s1,a1
    80002278:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000227a:	fd840593          	addi	a1,s0,-40
    8000227e:	00000097          	auipc	ra,0x0
    80002282:	fcc080e7          	jalr	-52(ra) # 8000224a <argaddr>
  return fetchstr(addr, buf, max);
    80002286:	864a                	mv	a2,s2
    80002288:	85a6                	mv	a1,s1
    8000228a:	fd843503          	ld	a0,-40(s0)
    8000228e:	00000097          	auipc	ra,0x0
    80002292:	f50080e7          	jalr	-176(ra) # 800021de <fetchstr>
}
    80002296:	70a2                	ld	ra,40(sp)
    80002298:	7402                	ld	s0,32(sp)
    8000229a:	64e2                	ld	s1,24(sp)
    8000229c:	6942                	ld	s2,16(sp)
    8000229e:	6145                	addi	sp,sp,48
    800022a0:	8082                	ret

00000000800022a2 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    800022a2:	1101                	addi	sp,sp,-32
    800022a4:	ec06                	sd	ra,24(sp)
    800022a6:	e822                	sd	s0,16(sp)
    800022a8:	e426                	sd	s1,8(sp)
    800022aa:	e04a                	sd	s2,0(sp)
    800022ac:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800022ae:	fffff097          	auipc	ra,0xfffff
    800022b2:	d00080e7          	jalr	-768(ra) # 80000fae <myproc>
    800022b6:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800022b8:	05853903          	ld	s2,88(a0)
    800022bc:	0a893783          	ld	a5,168(s2)
    800022c0:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800022c4:	37fd                	addiw	a5,a5,-1
    800022c6:	4751                	li	a4,20
    800022c8:	00f76f63          	bltu	a4,a5,800022e6 <syscall+0x44>
    800022cc:	00369713          	slli	a4,a3,0x3
    800022d0:	00006797          	auipc	a5,0x6
    800022d4:	11078793          	addi	a5,a5,272 # 800083e0 <syscalls>
    800022d8:	97ba                	add	a5,a5,a4
    800022da:	639c                	ld	a5,0(a5)
    800022dc:	c789                	beqz	a5,800022e6 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800022de:	9782                	jalr	a5
    800022e0:	06a93823          	sd	a0,112(s2)
    800022e4:	a839                	j	80002302 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800022e6:	15848613          	addi	a2,s1,344
    800022ea:	588c                	lw	a1,48(s1)
    800022ec:	00006517          	auipc	a0,0x6
    800022f0:	0bc50513          	addi	a0,a0,188 # 800083a8 <states.0+0x150>
    800022f4:	00004097          	auipc	ra,0x4
    800022f8:	bb2080e7          	jalr	-1102(ra) # 80005ea6 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800022fc:	6cbc                	ld	a5,88(s1)
    800022fe:	577d                	li	a4,-1
    80002300:	fbb8                	sd	a4,112(a5)
  }
}
    80002302:	60e2                	ld	ra,24(sp)
    80002304:	6442                	ld	s0,16(sp)
    80002306:	64a2                	ld	s1,8(sp)
    80002308:	6902                	ld	s2,0(sp)
    8000230a:	6105                	addi	sp,sp,32
    8000230c:	8082                	ret

000000008000230e <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000230e:	1101                	addi	sp,sp,-32
    80002310:	ec06                	sd	ra,24(sp)
    80002312:	e822                	sd	s0,16(sp)
    80002314:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002316:	fec40593          	addi	a1,s0,-20
    8000231a:	4501                	li	a0,0
    8000231c:	00000097          	auipc	ra,0x0
    80002320:	f0e080e7          	jalr	-242(ra) # 8000222a <argint>
  exit(n);
    80002324:	fec42503          	lw	a0,-20(s0)
    80002328:	fffff097          	auipc	ra,0xfffff
    8000232c:	462080e7          	jalr	1122(ra) # 8000178a <exit>
  return 0;  // not reached
}
    80002330:	4501                	li	a0,0
    80002332:	60e2                	ld	ra,24(sp)
    80002334:	6442                	ld	s0,16(sp)
    80002336:	6105                	addi	sp,sp,32
    80002338:	8082                	ret

000000008000233a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000233a:	1141                	addi	sp,sp,-16
    8000233c:	e406                	sd	ra,8(sp)
    8000233e:	e022                	sd	s0,0(sp)
    80002340:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002342:	fffff097          	auipc	ra,0xfffff
    80002346:	c6c080e7          	jalr	-916(ra) # 80000fae <myproc>
}
    8000234a:	5908                	lw	a0,48(a0)
    8000234c:	60a2                	ld	ra,8(sp)
    8000234e:	6402                	ld	s0,0(sp)
    80002350:	0141                	addi	sp,sp,16
    80002352:	8082                	ret

0000000080002354 <sys_fork>:

uint64
sys_fork(void)
{
    80002354:	1141                	addi	sp,sp,-16
    80002356:	e406                	sd	ra,8(sp)
    80002358:	e022                	sd	s0,0(sp)
    8000235a:	0800                	addi	s0,sp,16
  return fork();
    8000235c:	fffff097          	auipc	ra,0xfffff
    80002360:	008080e7          	jalr	8(ra) # 80001364 <fork>
}
    80002364:	60a2                	ld	ra,8(sp)
    80002366:	6402                	ld	s0,0(sp)
    80002368:	0141                	addi	sp,sp,16
    8000236a:	8082                	ret

000000008000236c <sys_wait>:

uint64
sys_wait(void)
{
    8000236c:	1101                	addi	sp,sp,-32
    8000236e:	ec06                	sd	ra,24(sp)
    80002370:	e822                	sd	s0,16(sp)
    80002372:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002374:	fe840593          	addi	a1,s0,-24
    80002378:	4501                	li	a0,0
    8000237a:	00000097          	auipc	ra,0x0
    8000237e:	ed0080e7          	jalr	-304(ra) # 8000224a <argaddr>
  return wait(p);
    80002382:	fe843503          	ld	a0,-24(s0)
    80002386:	fffff097          	auipc	ra,0xfffff
    8000238a:	5aa080e7          	jalr	1450(ra) # 80001930 <wait>
}
    8000238e:	60e2                	ld	ra,24(sp)
    80002390:	6442                	ld	s0,16(sp)
    80002392:	6105                	addi	sp,sp,32
    80002394:	8082                	ret

0000000080002396 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002396:	7179                	addi	sp,sp,-48
    80002398:	f406                	sd	ra,40(sp)
    8000239a:	f022                	sd	s0,32(sp)
    8000239c:	ec26                	sd	s1,24(sp)
    8000239e:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800023a0:	fdc40593          	addi	a1,s0,-36
    800023a4:	4501                	li	a0,0
    800023a6:	00000097          	auipc	ra,0x0
    800023aa:	e84080e7          	jalr	-380(ra) # 8000222a <argint>
  addr = myproc()->sz;
    800023ae:	fffff097          	auipc	ra,0xfffff
    800023b2:	c00080e7          	jalr	-1024(ra) # 80000fae <myproc>
    800023b6:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800023b8:	fdc42503          	lw	a0,-36(s0)
    800023bc:	fffff097          	auipc	ra,0xfffff
    800023c0:	f4c080e7          	jalr	-180(ra) # 80001308 <growproc>
    800023c4:	00054863          	bltz	a0,800023d4 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800023c8:	8526                	mv	a0,s1
    800023ca:	70a2                	ld	ra,40(sp)
    800023cc:	7402                	ld	s0,32(sp)
    800023ce:	64e2                	ld	s1,24(sp)
    800023d0:	6145                	addi	sp,sp,48
    800023d2:	8082                	ret
    return -1;
    800023d4:	54fd                	li	s1,-1
    800023d6:	bfcd                	j	800023c8 <sys_sbrk+0x32>

00000000800023d8 <sys_sleep>:

uint64
sys_sleep(void)
{
    800023d8:	7139                	addi	sp,sp,-64
    800023da:	fc06                	sd	ra,56(sp)
    800023dc:	f822                	sd	s0,48(sp)
    800023de:	f426                	sd	s1,40(sp)
    800023e0:	f04a                	sd	s2,32(sp)
    800023e2:	ec4e                	sd	s3,24(sp)
    800023e4:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800023e6:	fcc40593          	addi	a1,s0,-52
    800023ea:	4501                	li	a0,0
    800023ec:	00000097          	auipc	ra,0x0
    800023f0:	e3e080e7          	jalr	-450(ra) # 8000222a <argint>
  if(n < 0)
    800023f4:	fcc42783          	lw	a5,-52(s0)
    800023f8:	0607cf63          	bltz	a5,80002476 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    800023fc:	0022c517          	auipc	a0,0x22c
    80002400:	35c50513          	addi	a0,a0,860 # 8022e758 <tickslock>
    80002404:	00004097          	auipc	ra,0x4
    80002408:	f90080e7          	jalr	-112(ra) # 80006394 <acquire>
  ticks0 = ticks;
    8000240c:	00006917          	auipc	s2,0x6
    80002410:	4cc92903          	lw	s2,1228(s2) # 800088d8 <ticks>
  while(ticks - ticks0 < n){
    80002414:	fcc42783          	lw	a5,-52(s0)
    80002418:	cf9d                	beqz	a5,80002456 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000241a:	0022c997          	auipc	s3,0x22c
    8000241e:	33e98993          	addi	s3,s3,830 # 8022e758 <tickslock>
    80002422:	00006497          	auipc	s1,0x6
    80002426:	4b648493          	addi	s1,s1,1206 # 800088d8 <ticks>
    if(killed(myproc())){
    8000242a:	fffff097          	auipc	ra,0xfffff
    8000242e:	b84080e7          	jalr	-1148(ra) # 80000fae <myproc>
    80002432:	fffff097          	auipc	ra,0xfffff
    80002436:	4cc080e7          	jalr	1228(ra) # 800018fe <killed>
    8000243a:	e129                	bnez	a0,8000247c <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    8000243c:	85ce                	mv	a1,s3
    8000243e:	8526                	mv	a0,s1
    80002440:	fffff097          	auipc	ra,0xfffff
    80002444:	216080e7          	jalr	534(ra) # 80001656 <sleep>
  while(ticks - ticks0 < n){
    80002448:	409c                	lw	a5,0(s1)
    8000244a:	412787bb          	subw	a5,a5,s2
    8000244e:	fcc42703          	lw	a4,-52(s0)
    80002452:	fce7ece3          	bltu	a5,a4,8000242a <sys_sleep+0x52>
  }
  release(&tickslock);
    80002456:	0022c517          	auipc	a0,0x22c
    8000245a:	30250513          	addi	a0,a0,770 # 8022e758 <tickslock>
    8000245e:	00004097          	auipc	ra,0x4
    80002462:	fea080e7          	jalr	-22(ra) # 80006448 <release>
  return 0;
    80002466:	4501                	li	a0,0
}
    80002468:	70e2                	ld	ra,56(sp)
    8000246a:	7442                	ld	s0,48(sp)
    8000246c:	74a2                	ld	s1,40(sp)
    8000246e:	7902                	ld	s2,32(sp)
    80002470:	69e2                	ld	s3,24(sp)
    80002472:	6121                	addi	sp,sp,64
    80002474:	8082                	ret
    n = 0;
    80002476:	fc042623          	sw	zero,-52(s0)
    8000247a:	b749                	j	800023fc <sys_sleep+0x24>
      release(&tickslock);
    8000247c:	0022c517          	auipc	a0,0x22c
    80002480:	2dc50513          	addi	a0,a0,732 # 8022e758 <tickslock>
    80002484:	00004097          	auipc	ra,0x4
    80002488:	fc4080e7          	jalr	-60(ra) # 80006448 <release>
      return -1;
    8000248c:	557d                	li	a0,-1
    8000248e:	bfe9                	j	80002468 <sys_sleep+0x90>

0000000080002490 <sys_kill>:

uint64
sys_kill(void)
{
    80002490:	1101                	addi	sp,sp,-32
    80002492:	ec06                	sd	ra,24(sp)
    80002494:	e822                	sd	s0,16(sp)
    80002496:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002498:	fec40593          	addi	a1,s0,-20
    8000249c:	4501                	li	a0,0
    8000249e:	00000097          	auipc	ra,0x0
    800024a2:	d8c080e7          	jalr	-628(ra) # 8000222a <argint>
  return kill(pid);
    800024a6:	fec42503          	lw	a0,-20(s0)
    800024aa:	fffff097          	auipc	ra,0xfffff
    800024ae:	3b6080e7          	jalr	950(ra) # 80001860 <kill>
}
    800024b2:	60e2                	ld	ra,24(sp)
    800024b4:	6442                	ld	s0,16(sp)
    800024b6:	6105                	addi	sp,sp,32
    800024b8:	8082                	ret

00000000800024ba <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800024ba:	1101                	addi	sp,sp,-32
    800024bc:	ec06                	sd	ra,24(sp)
    800024be:	e822                	sd	s0,16(sp)
    800024c0:	e426                	sd	s1,8(sp)
    800024c2:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800024c4:	0022c517          	auipc	a0,0x22c
    800024c8:	29450513          	addi	a0,a0,660 # 8022e758 <tickslock>
    800024cc:	00004097          	auipc	ra,0x4
    800024d0:	ec8080e7          	jalr	-312(ra) # 80006394 <acquire>
  xticks = ticks;
    800024d4:	00006497          	auipc	s1,0x6
    800024d8:	4044a483          	lw	s1,1028(s1) # 800088d8 <ticks>
  release(&tickslock);
    800024dc:	0022c517          	auipc	a0,0x22c
    800024e0:	27c50513          	addi	a0,a0,636 # 8022e758 <tickslock>
    800024e4:	00004097          	auipc	ra,0x4
    800024e8:	f64080e7          	jalr	-156(ra) # 80006448 <release>
  return xticks;
}
    800024ec:	02049513          	slli	a0,s1,0x20
    800024f0:	9101                	srli	a0,a0,0x20
    800024f2:	60e2                	ld	ra,24(sp)
    800024f4:	6442                	ld	s0,16(sp)
    800024f6:	64a2                	ld	s1,8(sp)
    800024f8:	6105                	addi	sp,sp,32
    800024fa:	8082                	ret

00000000800024fc <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800024fc:	7179                	addi	sp,sp,-48
    800024fe:	f406                	sd	ra,40(sp)
    80002500:	f022                	sd	s0,32(sp)
    80002502:	ec26                	sd	s1,24(sp)
    80002504:	e84a                	sd	s2,16(sp)
    80002506:	e44e                	sd	s3,8(sp)
    80002508:	e052                	sd	s4,0(sp)
    8000250a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000250c:	00006597          	auipc	a1,0x6
    80002510:	f8458593          	addi	a1,a1,-124 # 80008490 <syscalls+0xb0>
    80002514:	0022c517          	auipc	a0,0x22c
    80002518:	25c50513          	addi	a0,a0,604 # 8022e770 <bcache>
    8000251c:	00004097          	auipc	ra,0x4
    80002520:	de8080e7          	jalr	-536(ra) # 80006304 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002524:	00234797          	auipc	a5,0x234
    80002528:	24c78793          	addi	a5,a5,588 # 80236770 <bcache+0x8000>
    8000252c:	00234717          	auipc	a4,0x234
    80002530:	4ac70713          	addi	a4,a4,1196 # 802369d8 <bcache+0x8268>
    80002534:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002538:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000253c:	0022c497          	auipc	s1,0x22c
    80002540:	24c48493          	addi	s1,s1,588 # 8022e788 <bcache+0x18>
    b->next = bcache.head.next;
    80002544:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002546:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002548:	00006a17          	auipc	s4,0x6
    8000254c:	f50a0a13          	addi	s4,s4,-176 # 80008498 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002550:	2b893783          	ld	a5,696(s2)
    80002554:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002556:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000255a:	85d2                	mv	a1,s4
    8000255c:	01048513          	addi	a0,s1,16
    80002560:	00001097          	auipc	ra,0x1
    80002564:	4c8080e7          	jalr	1224(ra) # 80003a28 <initsleeplock>
    bcache.head.next->prev = b;
    80002568:	2b893783          	ld	a5,696(s2)
    8000256c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000256e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002572:	45848493          	addi	s1,s1,1112
    80002576:	fd349de3          	bne	s1,s3,80002550 <binit+0x54>
  }
}
    8000257a:	70a2                	ld	ra,40(sp)
    8000257c:	7402                	ld	s0,32(sp)
    8000257e:	64e2                	ld	s1,24(sp)
    80002580:	6942                	ld	s2,16(sp)
    80002582:	69a2                	ld	s3,8(sp)
    80002584:	6a02                	ld	s4,0(sp)
    80002586:	6145                	addi	sp,sp,48
    80002588:	8082                	ret

000000008000258a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000258a:	7179                	addi	sp,sp,-48
    8000258c:	f406                	sd	ra,40(sp)
    8000258e:	f022                	sd	s0,32(sp)
    80002590:	ec26                	sd	s1,24(sp)
    80002592:	e84a                	sd	s2,16(sp)
    80002594:	e44e                	sd	s3,8(sp)
    80002596:	1800                	addi	s0,sp,48
    80002598:	892a                	mv	s2,a0
    8000259a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000259c:	0022c517          	auipc	a0,0x22c
    800025a0:	1d450513          	addi	a0,a0,468 # 8022e770 <bcache>
    800025a4:	00004097          	auipc	ra,0x4
    800025a8:	df0080e7          	jalr	-528(ra) # 80006394 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800025ac:	00234497          	auipc	s1,0x234
    800025b0:	47c4b483          	ld	s1,1148(s1) # 80236a28 <bcache+0x82b8>
    800025b4:	00234797          	auipc	a5,0x234
    800025b8:	42478793          	addi	a5,a5,1060 # 802369d8 <bcache+0x8268>
    800025bc:	02f48f63          	beq	s1,a5,800025fa <bread+0x70>
    800025c0:	873e                	mv	a4,a5
    800025c2:	a021                	j	800025ca <bread+0x40>
    800025c4:	68a4                	ld	s1,80(s1)
    800025c6:	02e48a63          	beq	s1,a4,800025fa <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800025ca:	449c                	lw	a5,8(s1)
    800025cc:	ff279ce3          	bne	a5,s2,800025c4 <bread+0x3a>
    800025d0:	44dc                	lw	a5,12(s1)
    800025d2:	ff3799e3          	bne	a5,s3,800025c4 <bread+0x3a>
      b->refcnt++;
    800025d6:	40bc                	lw	a5,64(s1)
    800025d8:	2785                	addiw	a5,a5,1
    800025da:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025dc:	0022c517          	auipc	a0,0x22c
    800025e0:	19450513          	addi	a0,a0,404 # 8022e770 <bcache>
    800025e4:	00004097          	auipc	ra,0x4
    800025e8:	e64080e7          	jalr	-412(ra) # 80006448 <release>
      acquiresleep(&b->lock);
    800025ec:	01048513          	addi	a0,s1,16
    800025f0:	00001097          	auipc	ra,0x1
    800025f4:	472080e7          	jalr	1138(ra) # 80003a62 <acquiresleep>
      return b;
    800025f8:	a8b9                	j	80002656 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025fa:	00234497          	auipc	s1,0x234
    800025fe:	4264b483          	ld	s1,1062(s1) # 80236a20 <bcache+0x82b0>
    80002602:	00234797          	auipc	a5,0x234
    80002606:	3d678793          	addi	a5,a5,982 # 802369d8 <bcache+0x8268>
    8000260a:	00f48863          	beq	s1,a5,8000261a <bread+0x90>
    8000260e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002610:	40bc                	lw	a5,64(s1)
    80002612:	cf81                	beqz	a5,8000262a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002614:	64a4                	ld	s1,72(s1)
    80002616:	fee49de3          	bne	s1,a4,80002610 <bread+0x86>
  panic("bget: no buffers");
    8000261a:	00006517          	auipc	a0,0x6
    8000261e:	e8650513          	addi	a0,a0,-378 # 800084a0 <syscalls+0xc0>
    80002622:	00004097          	auipc	ra,0x4
    80002626:	83a080e7          	jalr	-1990(ra) # 80005e5c <panic>
      b->dev = dev;
    8000262a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000262e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002632:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002636:	4785                	li	a5,1
    80002638:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000263a:	0022c517          	auipc	a0,0x22c
    8000263e:	13650513          	addi	a0,a0,310 # 8022e770 <bcache>
    80002642:	00004097          	auipc	ra,0x4
    80002646:	e06080e7          	jalr	-506(ra) # 80006448 <release>
      acquiresleep(&b->lock);
    8000264a:	01048513          	addi	a0,s1,16
    8000264e:	00001097          	auipc	ra,0x1
    80002652:	414080e7          	jalr	1044(ra) # 80003a62 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002656:	409c                	lw	a5,0(s1)
    80002658:	cb89                	beqz	a5,8000266a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000265a:	8526                	mv	a0,s1
    8000265c:	70a2                	ld	ra,40(sp)
    8000265e:	7402                	ld	s0,32(sp)
    80002660:	64e2                	ld	s1,24(sp)
    80002662:	6942                	ld	s2,16(sp)
    80002664:	69a2                	ld	s3,8(sp)
    80002666:	6145                	addi	sp,sp,48
    80002668:	8082                	ret
    virtio_disk_rw(b, 0);
    8000266a:	4581                	li	a1,0
    8000266c:	8526                	mv	a0,s1
    8000266e:	00003097          	auipc	ra,0x3
    80002672:	fe4080e7          	jalr	-28(ra) # 80005652 <virtio_disk_rw>
    b->valid = 1;
    80002676:	4785                	li	a5,1
    80002678:	c09c                	sw	a5,0(s1)
  return b;
    8000267a:	b7c5                	j	8000265a <bread+0xd0>

000000008000267c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000267c:	1101                	addi	sp,sp,-32
    8000267e:	ec06                	sd	ra,24(sp)
    80002680:	e822                	sd	s0,16(sp)
    80002682:	e426                	sd	s1,8(sp)
    80002684:	1000                	addi	s0,sp,32
    80002686:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002688:	0541                	addi	a0,a0,16
    8000268a:	00001097          	auipc	ra,0x1
    8000268e:	472080e7          	jalr	1138(ra) # 80003afc <holdingsleep>
    80002692:	cd01                	beqz	a0,800026aa <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002694:	4585                	li	a1,1
    80002696:	8526                	mv	a0,s1
    80002698:	00003097          	auipc	ra,0x3
    8000269c:	fba080e7          	jalr	-70(ra) # 80005652 <virtio_disk_rw>
}
    800026a0:	60e2                	ld	ra,24(sp)
    800026a2:	6442                	ld	s0,16(sp)
    800026a4:	64a2                	ld	s1,8(sp)
    800026a6:	6105                	addi	sp,sp,32
    800026a8:	8082                	ret
    panic("bwrite");
    800026aa:	00006517          	auipc	a0,0x6
    800026ae:	e0e50513          	addi	a0,a0,-498 # 800084b8 <syscalls+0xd8>
    800026b2:	00003097          	auipc	ra,0x3
    800026b6:	7aa080e7          	jalr	1962(ra) # 80005e5c <panic>

00000000800026ba <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800026ba:	1101                	addi	sp,sp,-32
    800026bc:	ec06                	sd	ra,24(sp)
    800026be:	e822                	sd	s0,16(sp)
    800026c0:	e426                	sd	s1,8(sp)
    800026c2:	e04a                	sd	s2,0(sp)
    800026c4:	1000                	addi	s0,sp,32
    800026c6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800026c8:	01050913          	addi	s2,a0,16
    800026cc:	854a                	mv	a0,s2
    800026ce:	00001097          	auipc	ra,0x1
    800026d2:	42e080e7          	jalr	1070(ra) # 80003afc <holdingsleep>
    800026d6:	c92d                	beqz	a0,80002748 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800026d8:	854a                	mv	a0,s2
    800026da:	00001097          	auipc	ra,0x1
    800026de:	3de080e7          	jalr	990(ra) # 80003ab8 <releasesleep>

  acquire(&bcache.lock);
    800026e2:	0022c517          	auipc	a0,0x22c
    800026e6:	08e50513          	addi	a0,a0,142 # 8022e770 <bcache>
    800026ea:	00004097          	auipc	ra,0x4
    800026ee:	caa080e7          	jalr	-854(ra) # 80006394 <acquire>
  b->refcnt--;
    800026f2:	40bc                	lw	a5,64(s1)
    800026f4:	37fd                	addiw	a5,a5,-1
    800026f6:	0007871b          	sext.w	a4,a5
    800026fa:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800026fc:	eb05                	bnez	a4,8000272c <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800026fe:	68bc                	ld	a5,80(s1)
    80002700:	64b8                	ld	a4,72(s1)
    80002702:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002704:	64bc                	ld	a5,72(s1)
    80002706:	68b8                	ld	a4,80(s1)
    80002708:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000270a:	00234797          	auipc	a5,0x234
    8000270e:	06678793          	addi	a5,a5,102 # 80236770 <bcache+0x8000>
    80002712:	2b87b703          	ld	a4,696(a5)
    80002716:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002718:	00234717          	auipc	a4,0x234
    8000271c:	2c070713          	addi	a4,a4,704 # 802369d8 <bcache+0x8268>
    80002720:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002722:	2b87b703          	ld	a4,696(a5)
    80002726:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002728:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000272c:	0022c517          	auipc	a0,0x22c
    80002730:	04450513          	addi	a0,a0,68 # 8022e770 <bcache>
    80002734:	00004097          	auipc	ra,0x4
    80002738:	d14080e7          	jalr	-748(ra) # 80006448 <release>
}
    8000273c:	60e2                	ld	ra,24(sp)
    8000273e:	6442                	ld	s0,16(sp)
    80002740:	64a2                	ld	s1,8(sp)
    80002742:	6902                	ld	s2,0(sp)
    80002744:	6105                	addi	sp,sp,32
    80002746:	8082                	ret
    panic("brelse");
    80002748:	00006517          	auipc	a0,0x6
    8000274c:	d7850513          	addi	a0,a0,-648 # 800084c0 <syscalls+0xe0>
    80002750:	00003097          	auipc	ra,0x3
    80002754:	70c080e7          	jalr	1804(ra) # 80005e5c <panic>

0000000080002758 <bpin>:

void
bpin(struct buf *b) {
    80002758:	1101                	addi	sp,sp,-32
    8000275a:	ec06                	sd	ra,24(sp)
    8000275c:	e822                	sd	s0,16(sp)
    8000275e:	e426                	sd	s1,8(sp)
    80002760:	1000                	addi	s0,sp,32
    80002762:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002764:	0022c517          	auipc	a0,0x22c
    80002768:	00c50513          	addi	a0,a0,12 # 8022e770 <bcache>
    8000276c:	00004097          	auipc	ra,0x4
    80002770:	c28080e7          	jalr	-984(ra) # 80006394 <acquire>
  b->refcnt++;
    80002774:	40bc                	lw	a5,64(s1)
    80002776:	2785                	addiw	a5,a5,1
    80002778:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000277a:	0022c517          	auipc	a0,0x22c
    8000277e:	ff650513          	addi	a0,a0,-10 # 8022e770 <bcache>
    80002782:	00004097          	auipc	ra,0x4
    80002786:	cc6080e7          	jalr	-826(ra) # 80006448 <release>
}
    8000278a:	60e2                	ld	ra,24(sp)
    8000278c:	6442                	ld	s0,16(sp)
    8000278e:	64a2                	ld	s1,8(sp)
    80002790:	6105                	addi	sp,sp,32
    80002792:	8082                	ret

0000000080002794 <bunpin>:

void
bunpin(struct buf *b) {
    80002794:	1101                	addi	sp,sp,-32
    80002796:	ec06                	sd	ra,24(sp)
    80002798:	e822                	sd	s0,16(sp)
    8000279a:	e426                	sd	s1,8(sp)
    8000279c:	1000                	addi	s0,sp,32
    8000279e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800027a0:	0022c517          	auipc	a0,0x22c
    800027a4:	fd050513          	addi	a0,a0,-48 # 8022e770 <bcache>
    800027a8:	00004097          	auipc	ra,0x4
    800027ac:	bec080e7          	jalr	-1044(ra) # 80006394 <acquire>
  b->refcnt--;
    800027b0:	40bc                	lw	a5,64(s1)
    800027b2:	37fd                	addiw	a5,a5,-1
    800027b4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800027b6:	0022c517          	auipc	a0,0x22c
    800027ba:	fba50513          	addi	a0,a0,-70 # 8022e770 <bcache>
    800027be:	00004097          	auipc	ra,0x4
    800027c2:	c8a080e7          	jalr	-886(ra) # 80006448 <release>
}
    800027c6:	60e2                	ld	ra,24(sp)
    800027c8:	6442                	ld	s0,16(sp)
    800027ca:	64a2                	ld	s1,8(sp)
    800027cc:	6105                	addi	sp,sp,32
    800027ce:	8082                	ret

00000000800027d0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800027d0:	1101                	addi	sp,sp,-32
    800027d2:	ec06                	sd	ra,24(sp)
    800027d4:	e822                	sd	s0,16(sp)
    800027d6:	e426                	sd	s1,8(sp)
    800027d8:	e04a                	sd	s2,0(sp)
    800027da:	1000                	addi	s0,sp,32
    800027dc:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800027de:	00d5d59b          	srliw	a1,a1,0xd
    800027e2:	00234797          	auipc	a5,0x234
    800027e6:	66a7a783          	lw	a5,1642(a5) # 80236e4c <sb+0x1c>
    800027ea:	9dbd                	addw	a1,a1,a5
    800027ec:	00000097          	auipc	ra,0x0
    800027f0:	d9e080e7          	jalr	-610(ra) # 8000258a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800027f4:	0074f713          	andi	a4,s1,7
    800027f8:	4785                	li	a5,1
    800027fa:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800027fe:	14ce                	slli	s1,s1,0x33
    80002800:	90d9                	srli	s1,s1,0x36
    80002802:	00950733          	add	a4,a0,s1
    80002806:	05874703          	lbu	a4,88(a4)
    8000280a:	00e7f6b3          	and	a3,a5,a4
    8000280e:	c69d                	beqz	a3,8000283c <bfree+0x6c>
    80002810:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002812:	94aa                	add	s1,s1,a0
    80002814:	fff7c793          	not	a5,a5
    80002818:	8f7d                	and	a4,a4,a5
    8000281a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000281e:	00001097          	auipc	ra,0x1
    80002822:	126080e7          	jalr	294(ra) # 80003944 <log_write>
  brelse(bp);
    80002826:	854a                	mv	a0,s2
    80002828:	00000097          	auipc	ra,0x0
    8000282c:	e92080e7          	jalr	-366(ra) # 800026ba <brelse>
}
    80002830:	60e2                	ld	ra,24(sp)
    80002832:	6442                	ld	s0,16(sp)
    80002834:	64a2                	ld	s1,8(sp)
    80002836:	6902                	ld	s2,0(sp)
    80002838:	6105                	addi	sp,sp,32
    8000283a:	8082                	ret
    panic("freeing free block");
    8000283c:	00006517          	auipc	a0,0x6
    80002840:	c8c50513          	addi	a0,a0,-884 # 800084c8 <syscalls+0xe8>
    80002844:	00003097          	auipc	ra,0x3
    80002848:	618080e7          	jalr	1560(ra) # 80005e5c <panic>

000000008000284c <balloc>:
{
    8000284c:	711d                	addi	sp,sp,-96
    8000284e:	ec86                	sd	ra,88(sp)
    80002850:	e8a2                	sd	s0,80(sp)
    80002852:	e4a6                	sd	s1,72(sp)
    80002854:	e0ca                	sd	s2,64(sp)
    80002856:	fc4e                	sd	s3,56(sp)
    80002858:	f852                	sd	s4,48(sp)
    8000285a:	f456                	sd	s5,40(sp)
    8000285c:	f05a                	sd	s6,32(sp)
    8000285e:	ec5e                	sd	s7,24(sp)
    80002860:	e862                	sd	s8,16(sp)
    80002862:	e466                	sd	s9,8(sp)
    80002864:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002866:	00234797          	auipc	a5,0x234
    8000286a:	5ce7a783          	lw	a5,1486(a5) # 80236e34 <sb+0x4>
    8000286e:	cff5                	beqz	a5,8000296a <balloc+0x11e>
    80002870:	8baa                	mv	s7,a0
    80002872:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002874:	00234b17          	auipc	s6,0x234
    80002878:	5bcb0b13          	addi	s6,s6,1468 # 80236e30 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000287c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000287e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002880:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002882:	6c89                	lui	s9,0x2
    80002884:	a061                	j	8000290c <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002886:	97ca                	add	a5,a5,s2
    80002888:	8e55                	or	a2,a2,a3
    8000288a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000288e:	854a                	mv	a0,s2
    80002890:	00001097          	auipc	ra,0x1
    80002894:	0b4080e7          	jalr	180(ra) # 80003944 <log_write>
        brelse(bp);
    80002898:	854a                	mv	a0,s2
    8000289a:	00000097          	auipc	ra,0x0
    8000289e:	e20080e7          	jalr	-480(ra) # 800026ba <brelse>
  bp = bread(dev, bno);
    800028a2:	85a6                	mv	a1,s1
    800028a4:	855e                	mv	a0,s7
    800028a6:	00000097          	auipc	ra,0x0
    800028aa:	ce4080e7          	jalr	-796(ra) # 8000258a <bread>
    800028ae:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800028b0:	40000613          	li	a2,1024
    800028b4:	4581                	li	a1,0
    800028b6:	05850513          	addi	a0,a0,88
    800028ba:	ffffe097          	auipc	ra,0xffffe
    800028be:	a04080e7          	jalr	-1532(ra) # 800002be <memset>
  log_write(bp);
    800028c2:	854a                	mv	a0,s2
    800028c4:	00001097          	auipc	ra,0x1
    800028c8:	080080e7          	jalr	128(ra) # 80003944 <log_write>
  brelse(bp);
    800028cc:	854a                	mv	a0,s2
    800028ce:	00000097          	auipc	ra,0x0
    800028d2:	dec080e7          	jalr	-532(ra) # 800026ba <brelse>
}
    800028d6:	8526                	mv	a0,s1
    800028d8:	60e6                	ld	ra,88(sp)
    800028da:	6446                	ld	s0,80(sp)
    800028dc:	64a6                	ld	s1,72(sp)
    800028de:	6906                	ld	s2,64(sp)
    800028e0:	79e2                	ld	s3,56(sp)
    800028e2:	7a42                	ld	s4,48(sp)
    800028e4:	7aa2                	ld	s5,40(sp)
    800028e6:	7b02                	ld	s6,32(sp)
    800028e8:	6be2                	ld	s7,24(sp)
    800028ea:	6c42                	ld	s8,16(sp)
    800028ec:	6ca2                	ld	s9,8(sp)
    800028ee:	6125                	addi	sp,sp,96
    800028f0:	8082                	ret
    brelse(bp);
    800028f2:	854a                	mv	a0,s2
    800028f4:	00000097          	auipc	ra,0x0
    800028f8:	dc6080e7          	jalr	-570(ra) # 800026ba <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800028fc:	015c87bb          	addw	a5,s9,s5
    80002900:	00078a9b          	sext.w	s5,a5
    80002904:	004b2703          	lw	a4,4(s6)
    80002908:	06eaf163          	bgeu	s5,a4,8000296a <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    8000290c:	41fad79b          	sraiw	a5,s5,0x1f
    80002910:	0137d79b          	srliw	a5,a5,0x13
    80002914:	015787bb          	addw	a5,a5,s5
    80002918:	40d7d79b          	sraiw	a5,a5,0xd
    8000291c:	01cb2583          	lw	a1,28(s6)
    80002920:	9dbd                	addw	a1,a1,a5
    80002922:	855e                	mv	a0,s7
    80002924:	00000097          	auipc	ra,0x0
    80002928:	c66080e7          	jalr	-922(ra) # 8000258a <bread>
    8000292c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000292e:	004b2503          	lw	a0,4(s6)
    80002932:	000a849b          	sext.w	s1,s5
    80002936:	8762                	mv	a4,s8
    80002938:	faa4fde3          	bgeu	s1,a0,800028f2 <balloc+0xa6>
      m = 1 << (bi % 8);
    8000293c:	00777693          	andi	a3,a4,7
    80002940:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002944:	41f7579b          	sraiw	a5,a4,0x1f
    80002948:	01d7d79b          	srliw	a5,a5,0x1d
    8000294c:	9fb9                	addw	a5,a5,a4
    8000294e:	4037d79b          	sraiw	a5,a5,0x3
    80002952:	00f90633          	add	a2,s2,a5
    80002956:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    8000295a:	00c6f5b3          	and	a1,a3,a2
    8000295e:	d585                	beqz	a1,80002886 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002960:	2705                	addiw	a4,a4,1
    80002962:	2485                	addiw	s1,s1,1
    80002964:	fd471ae3          	bne	a4,s4,80002938 <balloc+0xec>
    80002968:	b769                	j	800028f2 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    8000296a:	00006517          	auipc	a0,0x6
    8000296e:	b7650513          	addi	a0,a0,-1162 # 800084e0 <syscalls+0x100>
    80002972:	00003097          	auipc	ra,0x3
    80002976:	534080e7          	jalr	1332(ra) # 80005ea6 <printf>
  return 0;
    8000297a:	4481                	li	s1,0
    8000297c:	bfa9                	j	800028d6 <balloc+0x8a>

000000008000297e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000297e:	7179                	addi	sp,sp,-48
    80002980:	f406                	sd	ra,40(sp)
    80002982:	f022                	sd	s0,32(sp)
    80002984:	ec26                	sd	s1,24(sp)
    80002986:	e84a                	sd	s2,16(sp)
    80002988:	e44e                	sd	s3,8(sp)
    8000298a:	e052                	sd	s4,0(sp)
    8000298c:	1800                	addi	s0,sp,48
    8000298e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002990:	47ad                	li	a5,11
    80002992:	02b7e863          	bltu	a5,a1,800029c2 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80002996:	02059793          	slli	a5,a1,0x20
    8000299a:	01e7d593          	srli	a1,a5,0x1e
    8000299e:	00b504b3          	add	s1,a0,a1
    800029a2:	0504a903          	lw	s2,80(s1)
    800029a6:	06091e63          	bnez	s2,80002a22 <bmap+0xa4>
      addr = balloc(ip->dev);
    800029aa:	4108                	lw	a0,0(a0)
    800029ac:	00000097          	auipc	ra,0x0
    800029b0:	ea0080e7          	jalr	-352(ra) # 8000284c <balloc>
    800029b4:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800029b8:	06090563          	beqz	s2,80002a22 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    800029bc:	0524a823          	sw	s2,80(s1)
    800029c0:	a08d                	j	80002a22 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800029c2:	ff45849b          	addiw	s1,a1,-12
    800029c6:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800029ca:	0ff00793          	li	a5,255
    800029ce:	08e7e563          	bltu	a5,a4,80002a58 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800029d2:	08052903          	lw	s2,128(a0)
    800029d6:	00091d63          	bnez	s2,800029f0 <bmap+0x72>
      addr = balloc(ip->dev);
    800029da:	4108                	lw	a0,0(a0)
    800029dc:	00000097          	auipc	ra,0x0
    800029e0:	e70080e7          	jalr	-400(ra) # 8000284c <balloc>
    800029e4:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800029e8:	02090d63          	beqz	s2,80002a22 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800029ec:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800029f0:	85ca                	mv	a1,s2
    800029f2:	0009a503          	lw	a0,0(s3)
    800029f6:	00000097          	auipc	ra,0x0
    800029fa:	b94080e7          	jalr	-1132(ra) # 8000258a <bread>
    800029fe:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002a00:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002a04:	02049713          	slli	a4,s1,0x20
    80002a08:	01e75593          	srli	a1,a4,0x1e
    80002a0c:	00b784b3          	add	s1,a5,a1
    80002a10:	0004a903          	lw	s2,0(s1)
    80002a14:	02090063          	beqz	s2,80002a34 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002a18:	8552                	mv	a0,s4
    80002a1a:	00000097          	auipc	ra,0x0
    80002a1e:	ca0080e7          	jalr	-864(ra) # 800026ba <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002a22:	854a                	mv	a0,s2
    80002a24:	70a2                	ld	ra,40(sp)
    80002a26:	7402                	ld	s0,32(sp)
    80002a28:	64e2                	ld	s1,24(sp)
    80002a2a:	6942                	ld	s2,16(sp)
    80002a2c:	69a2                	ld	s3,8(sp)
    80002a2e:	6a02                	ld	s4,0(sp)
    80002a30:	6145                	addi	sp,sp,48
    80002a32:	8082                	ret
      addr = balloc(ip->dev);
    80002a34:	0009a503          	lw	a0,0(s3)
    80002a38:	00000097          	auipc	ra,0x0
    80002a3c:	e14080e7          	jalr	-492(ra) # 8000284c <balloc>
    80002a40:	0005091b          	sext.w	s2,a0
      if(addr){
    80002a44:	fc090ae3          	beqz	s2,80002a18 <bmap+0x9a>
        a[bn] = addr;
    80002a48:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002a4c:	8552                	mv	a0,s4
    80002a4e:	00001097          	auipc	ra,0x1
    80002a52:	ef6080e7          	jalr	-266(ra) # 80003944 <log_write>
    80002a56:	b7c9                	j	80002a18 <bmap+0x9a>
  panic("bmap: out of range");
    80002a58:	00006517          	auipc	a0,0x6
    80002a5c:	aa050513          	addi	a0,a0,-1376 # 800084f8 <syscalls+0x118>
    80002a60:	00003097          	auipc	ra,0x3
    80002a64:	3fc080e7          	jalr	1020(ra) # 80005e5c <panic>

0000000080002a68 <iget>:
{
    80002a68:	7179                	addi	sp,sp,-48
    80002a6a:	f406                	sd	ra,40(sp)
    80002a6c:	f022                	sd	s0,32(sp)
    80002a6e:	ec26                	sd	s1,24(sp)
    80002a70:	e84a                	sd	s2,16(sp)
    80002a72:	e44e                	sd	s3,8(sp)
    80002a74:	e052                	sd	s4,0(sp)
    80002a76:	1800                	addi	s0,sp,48
    80002a78:	89aa                	mv	s3,a0
    80002a7a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a7c:	00234517          	auipc	a0,0x234
    80002a80:	3d450513          	addi	a0,a0,980 # 80236e50 <itable>
    80002a84:	00004097          	auipc	ra,0x4
    80002a88:	910080e7          	jalr	-1776(ra) # 80006394 <acquire>
  empty = 0;
    80002a8c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a8e:	00234497          	auipc	s1,0x234
    80002a92:	3da48493          	addi	s1,s1,986 # 80236e68 <itable+0x18>
    80002a96:	00236697          	auipc	a3,0x236
    80002a9a:	e6268693          	addi	a3,a3,-414 # 802388f8 <log>
    80002a9e:	a039                	j	80002aac <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002aa0:	02090b63          	beqz	s2,80002ad6 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002aa4:	08848493          	addi	s1,s1,136
    80002aa8:	02d48a63          	beq	s1,a3,80002adc <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002aac:	449c                	lw	a5,8(s1)
    80002aae:	fef059e3          	blez	a5,80002aa0 <iget+0x38>
    80002ab2:	4098                	lw	a4,0(s1)
    80002ab4:	ff3716e3          	bne	a4,s3,80002aa0 <iget+0x38>
    80002ab8:	40d8                	lw	a4,4(s1)
    80002aba:	ff4713e3          	bne	a4,s4,80002aa0 <iget+0x38>
      ip->ref++;
    80002abe:	2785                	addiw	a5,a5,1
    80002ac0:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002ac2:	00234517          	auipc	a0,0x234
    80002ac6:	38e50513          	addi	a0,a0,910 # 80236e50 <itable>
    80002aca:	00004097          	auipc	ra,0x4
    80002ace:	97e080e7          	jalr	-1666(ra) # 80006448 <release>
      return ip;
    80002ad2:	8926                	mv	s2,s1
    80002ad4:	a03d                	j	80002b02 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002ad6:	f7f9                	bnez	a5,80002aa4 <iget+0x3c>
    80002ad8:	8926                	mv	s2,s1
    80002ada:	b7e9                	j	80002aa4 <iget+0x3c>
  if(empty == 0)
    80002adc:	02090c63          	beqz	s2,80002b14 <iget+0xac>
  ip->dev = dev;
    80002ae0:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002ae4:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002ae8:	4785                	li	a5,1
    80002aea:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002aee:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002af2:	00234517          	auipc	a0,0x234
    80002af6:	35e50513          	addi	a0,a0,862 # 80236e50 <itable>
    80002afa:	00004097          	auipc	ra,0x4
    80002afe:	94e080e7          	jalr	-1714(ra) # 80006448 <release>
}
    80002b02:	854a                	mv	a0,s2
    80002b04:	70a2                	ld	ra,40(sp)
    80002b06:	7402                	ld	s0,32(sp)
    80002b08:	64e2                	ld	s1,24(sp)
    80002b0a:	6942                	ld	s2,16(sp)
    80002b0c:	69a2                	ld	s3,8(sp)
    80002b0e:	6a02                	ld	s4,0(sp)
    80002b10:	6145                	addi	sp,sp,48
    80002b12:	8082                	ret
    panic("iget: no inodes");
    80002b14:	00006517          	auipc	a0,0x6
    80002b18:	9fc50513          	addi	a0,a0,-1540 # 80008510 <syscalls+0x130>
    80002b1c:	00003097          	auipc	ra,0x3
    80002b20:	340080e7          	jalr	832(ra) # 80005e5c <panic>

0000000080002b24 <fsinit>:
fsinit(int dev) {
    80002b24:	7179                	addi	sp,sp,-48
    80002b26:	f406                	sd	ra,40(sp)
    80002b28:	f022                	sd	s0,32(sp)
    80002b2a:	ec26                	sd	s1,24(sp)
    80002b2c:	e84a                	sd	s2,16(sp)
    80002b2e:	e44e                	sd	s3,8(sp)
    80002b30:	1800                	addi	s0,sp,48
    80002b32:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b34:	4585                	li	a1,1
    80002b36:	00000097          	auipc	ra,0x0
    80002b3a:	a54080e7          	jalr	-1452(ra) # 8000258a <bread>
    80002b3e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b40:	00234997          	auipc	s3,0x234
    80002b44:	2f098993          	addi	s3,s3,752 # 80236e30 <sb>
    80002b48:	02000613          	li	a2,32
    80002b4c:	05850593          	addi	a1,a0,88
    80002b50:	854e                	mv	a0,s3
    80002b52:	ffffd097          	auipc	ra,0xffffd
    80002b56:	7c8080e7          	jalr	1992(ra) # 8000031a <memmove>
  brelse(bp);
    80002b5a:	8526                	mv	a0,s1
    80002b5c:	00000097          	auipc	ra,0x0
    80002b60:	b5e080e7          	jalr	-1186(ra) # 800026ba <brelse>
  if(sb.magic != FSMAGIC)
    80002b64:	0009a703          	lw	a4,0(s3)
    80002b68:	102037b7          	lui	a5,0x10203
    80002b6c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b70:	02f71263          	bne	a4,a5,80002b94 <fsinit+0x70>
  initlog(dev, &sb);
    80002b74:	00234597          	auipc	a1,0x234
    80002b78:	2bc58593          	addi	a1,a1,700 # 80236e30 <sb>
    80002b7c:	854a                	mv	a0,s2
    80002b7e:	00001097          	auipc	ra,0x1
    80002b82:	b4a080e7          	jalr	-1206(ra) # 800036c8 <initlog>
}
    80002b86:	70a2                	ld	ra,40(sp)
    80002b88:	7402                	ld	s0,32(sp)
    80002b8a:	64e2                	ld	s1,24(sp)
    80002b8c:	6942                	ld	s2,16(sp)
    80002b8e:	69a2                	ld	s3,8(sp)
    80002b90:	6145                	addi	sp,sp,48
    80002b92:	8082                	ret
    panic("invalid file system");
    80002b94:	00006517          	auipc	a0,0x6
    80002b98:	98c50513          	addi	a0,a0,-1652 # 80008520 <syscalls+0x140>
    80002b9c:	00003097          	auipc	ra,0x3
    80002ba0:	2c0080e7          	jalr	704(ra) # 80005e5c <panic>

0000000080002ba4 <iinit>:
{
    80002ba4:	7179                	addi	sp,sp,-48
    80002ba6:	f406                	sd	ra,40(sp)
    80002ba8:	f022                	sd	s0,32(sp)
    80002baa:	ec26                	sd	s1,24(sp)
    80002bac:	e84a                	sd	s2,16(sp)
    80002bae:	e44e                	sd	s3,8(sp)
    80002bb0:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002bb2:	00006597          	auipc	a1,0x6
    80002bb6:	98658593          	addi	a1,a1,-1658 # 80008538 <syscalls+0x158>
    80002bba:	00234517          	auipc	a0,0x234
    80002bbe:	29650513          	addi	a0,a0,662 # 80236e50 <itable>
    80002bc2:	00003097          	auipc	ra,0x3
    80002bc6:	742080e7          	jalr	1858(ra) # 80006304 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002bca:	00234497          	auipc	s1,0x234
    80002bce:	2ae48493          	addi	s1,s1,686 # 80236e78 <itable+0x28>
    80002bd2:	00236997          	auipc	s3,0x236
    80002bd6:	d3698993          	addi	s3,s3,-714 # 80238908 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002bda:	00006917          	auipc	s2,0x6
    80002bde:	96690913          	addi	s2,s2,-1690 # 80008540 <syscalls+0x160>
    80002be2:	85ca                	mv	a1,s2
    80002be4:	8526                	mv	a0,s1
    80002be6:	00001097          	auipc	ra,0x1
    80002bea:	e42080e7          	jalr	-446(ra) # 80003a28 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002bee:	08848493          	addi	s1,s1,136
    80002bf2:	ff3498e3          	bne	s1,s3,80002be2 <iinit+0x3e>
}
    80002bf6:	70a2                	ld	ra,40(sp)
    80002bf8:	7402                	ld	s0,32(sp)
    80002bfa:	64e2                	ld	s1,24(sp)
    80002bfc:	6942                	ld	s2,16(sp)
    80002bfe:	69a2                	ld	s3,8(sp)
    80002c00:	6145                	addi	sp,sp,48
    80002c02:	8082                	ret

0000000080002c04 <ialloc>:
{
    80002c04:	715d                	addi	sp,sp,-80
    80002c06:	e486                	sd	ra,72(sp)
    80002c08:	e0a2                	sd	s0,64(sp)
    80002c0a:	fc26                	sd	s1,56(sp)
    80002c0c:	f84a                	sd	s2,48(sp)
    80002c0e:	f44e                	sd	s3,40(sp)
    80002c10:	f052                	sd	s4,32(sp)
    80002c12:	ec56                	sd	s5,24(sp)
    80002c14:	e85a                	sd	s6,16(sp)
    80002c16:	e45e                	sd	s7,8(sp)
    80002c18:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c1a:	00234717          	auipc	a4,0x234
    80002c1e:	22272703          	lw	a4,546(a4) # 80236e3c <sb+0xc>
    80002c22:	4785                	li	a5,1
    80002c24:	04e7fa63          	bgeu	a5,a4,80002c78 <ialloc+0x74>
    80002c28:	8aaa                	mv	s5,a0
    80002c2a:	8bae                	mv	s7,a1
    80002c2c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002c2e:	00234a17          	auipc	s4,0x234
    80002c32:	202a0a13          	addi	s4,s4,514 # 80236e30 <sb>
    80002c36:	00048b1b          	sext.w	s6,s1
    80002c3a:	0044d593          	srli	a1,s1,0x4
    80002c3e:	018a2783          	lw	a5,24(s4)
    80002c42:	9dbd                	addw	a1,a1,a5
    80002c44:	8556                	mv	a0,s5
    80002c46:	00000097          	auipc	ra,0x0
    80002c4a:	944080e7          	jalr	-1724(ra) # 8000258a <bread>
    80002c4e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c50:	05850993          	addi	s3,a0,88
    80002c54:	00f4f793          	andi	a5,s1,15
    80002c58:	079a                	slli	a5,a5,0x6
    80002c5a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c5c:	00099783          	lh	a5,0(s3)
    80002c60:	c3a1                	beqz	a5,80002ca0 <ialloc+0x9c>
    brelse(bp);
    80002c62:	00000097          	auipc	ra,0x0
    80002c66:	a58080e7          	jalr	-1448(ra) # 800026ba <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c6a:	0485                	addi	s1,s1,1
    80002c6c:	00ca2703          	lw	a4,12(s4)
    80002c70:	0004879b          	sext.w	a5,s1
    80002c74:	fce7e1e3          	bltu	a5,a4,80002c36 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002c78:	00006517          	auipc	a0,0x6
    80002c7c:	8d050513          	addi	a0,a0,-1840 # 80008548 <syscalls+0x168>
    80002c80:	00003097          	auipc	ra,0x3
    80002c84:	226080e7          	jalr	550(ra) # 80005ea6 <printf>
  return 0;
    80002c88:	4501                	li	a0,0
}
    80002c8a:	60a6                	ld	ra,72(sp)
    80002c8c:	6406                	ld	s0,64(sp)
    80002c8e:	74e2                	ld	s1,56(sp)
    80002c90:	7942                	ld	s2,48(sp)
    80002c92:	79a2                	ld	s3,40(sp)
    80002c94:	7a02                	ld	s4,32(sp)
    80002c96:	6ae2                	ld	s5,24(sp)
    80002c98:	6b42                	ld	s6,16(sp)
    80002c9a:	6ba2                	ld	s7,8(sp)
    80002c9c:	6161                	addi	sp,sp,80
    80002c9e:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002ca0:	04000613          	li	a2,64
    80002ca4:	4581                	li	a1,0
    80002ca6:	854e                	mv	a0,s3
    80002ca8:	ffffd097          	auipc	ra,0xffffd
    80002cac:	616080e7          	jalr	1558(ra) # 800002be <memset>
      dip->type = type;
    80002cb0:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002cb4:	854a                	mv	a0,s2
    80002cb6:	00001097          	auipc	ra,0x1
    80002cba:	c8e080e7          	jalr	-882(ra) # 80003944 <log_write>
      brelse(bp);
    80002cbe:	854a                	mv	a0,s2
    80002cc0:	00000097          	auipc	ra,0x0
    80002cc4:	9fa080e7          	jalr	-1542(ra) # 800026ba <brelse>
      return iget(dev, inum);
    80002cc8:	85da                	mv	a1,s6
    80002cca:	8556                	mv	a0,s5
    80002ccc:	00000097          	auipc	ra,0x0
    80002cd0:	d9c080e7          	jalr	-612(ra) # 80002a68 <iget>
    80002cd4:	bf5d                	j	80002c8a <ialloc+0x86>

0000000080002cd6 <iupdate>:
{
    80002cd6:	1101                	addi	sp,sp,-32
    80002cd8:	ec06                	sd	ra,24(sp)
    80002cda:	e822                	sd	s0,16(sp)
    80002cdc:	e426                	sd	s1,8(sp)
    80002cde:	e04a                	sd	s2,0(sp)
    80002ce0:	1000                	addi	s0,sp,32
    80002ce2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ce4:	415c                	lw	a5,4(a0)
    80002ce6:	0047d79b          	srliw	a5,a5,0x4
    80002cea:	00234597          	auipc	a1,0x234
    80002cee:	15e5a583          	lw	a1,350(a1) # 80236e48 <sb+0x18>
    80002cf2:	9dbd                	addw	a1,a1,a5
    80002cf4:	4108                	lw	a0,0(a0)
    80002cf6:	00000097          	auipc	ra,0x0
    80002cfa:	894080e7          	jalr	-1900(ra) # 8000258a <bread>
    80002cfe:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d00:	05850793          	addi	a5,a0,88
    80002d04:	40d8                	lw	a4,4(s1)
    80002d06:	8b3d                	andi	a4,a4,15
    80002d08:	071a                	slli	a4,a4,0x6
    80002d0a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002d0c:	04449703          	lh	a4,68(s1)
    80002d10:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002d14:	04649703          	lh	a4,70(s1)
    80002d18:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002d1c:	04849703          	lh	a4,72(s1)
    80002d20:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002d24:	04a49703          	lh	a4,74(s1)
    80002d28:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002d2c:	44f8                	lw	a4,76(s1)
    80002d2e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002d30:	03400613          	li	a2,52
    80002d34:	05048593          	addi	a1,s1,80
    80002d38:	00c78513          	addi	a0,a5,12
    80002d3c:	ffffd097          	auipc	ra,0xffffd
    80002d40:	5de080e7          	jalr	1502(ra) # 8000031a <memmove>
  log_write(bp);
    80002d44:	854a                	mv	a0,s2
    80002d46:	00001097          	auipc	ra,0x1
    80002d4a:	bfe080e7          	jalr	-1026(ra) # 80003944 <log_write>
  brelse(bp);
    80002d4e:	854a                	mv	a0,s2
    80002d50:	00000097          	auipc	ra,0x0
    80002d54:	96a080e7          	jalr	-1686(ra) # 800026ba <brelse>
}
    80002d58:	60e2                	ld	ra,24(sp)
    80002d5a:	6442                	ld	s0,16(sp)
    80002d5c:	64a2                	ld	s1,8(sp)
    80002d5e:	6902                	ld	s2,0(sp)
    80002d60:	6105                	addi	sp,sp,32
    80002d62:	8082                	ret

0000000080002d64 <idup>:
{
    80002d64:	1101                	addi	sp,sp,-32
    80002d66:	ec06                	sd	ra,24(sp)
    80002d68:	e822                	sd	s0,16(sp)
    80002d6a:	e426                	sd	s1,8(sp)
    80002d6c:	1000                	addi	s0,sp,32
    80002d6e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d70:	00234517          	auipc	a0,0x234
    80002d74:	0e050513          	addi	a0,a0,224 # 80236e50 <itable>
    80002d78:	00003097          	auipc	ra,0x3
    80002d7c:	61c080e7          	jalr	1564(ra) # 80006394 <acquire>
  ip->ref++;
    80002d80:	449c                	lw	a5,8(s1)
    80002d82:	2785                	addiw	a5,a5,1
    80002d84:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d86:	00234517          	auipc	a0,0x234
    80002d8a:	0ca50513          	addi	a0,a0,202 # 80236e50 <itable>
    80002d8e:	00003097          	auipc	ra,0x3
    80002d92:	6ba080e7          	jalr	1722(ra) # 80006448 <release>
}
    80002d96:	8526                	mv	a0,s1
    80002d98:	60e2                	ld	ra,24(sp)
    80002d9a:	6442                	ld	s0,16(sp)
    80002d9c:	64a2                	ld	s1,8(sp)
    80002d9e:	6105                	addi	sp,sp,32
    80002da0:	8082                	ret

0000000080002da2 <ilock>:
{
    80002da2:	1101                	addi	sp,sp,-32
    80002da4:	ec06                	sd	ra,24(sp)
    80002da6:	e822                	sd	s0,16(sp)
    80002da8:	e426                	sd	s1,8(sp)
    80002daa:	e04a                	sd	s2,0(sp)
    80002dac:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002dae:	c115                	beqz	a0,80002dd2 <ilock+0x30>
    80002db0:	84aa                	mv	s1,a0
    80002db2:	451c                	lw	a5,8(a0)
    80002db4:	00f05f63          	blez	a5,80002dd2 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002db8:	0541                	addi	a0,a0,16
    80002dba:	00001097          	auipc	ra,0x1
    80002dbe:	ca8080e7          	jalr	-856(ra) # 80003a62 <acquiresleep>
  if(ip->valid == 0){
    80002dc2:	40bc                	lw	a5,64(s1)
    80002dc4:	cf99                	beqz	a5,80002de2 <ilock+0x40>
}
    80002dc6:	60e2                	ld	ra,24(sp)
    80002dc8:	6442                	ld	s0,16(sp)
    80002dca:	64a2                	ld	s1,8(sp)
    80002dcc:	6902                	ld	s2,0(sp)
    80002dce:	6105                	addi	sp,sp,32
    80002dd0:	8082                	ret
    panic("ilock");
    80002dd2:	00005517          	auipc	a0,0x5
    80002dd6:	78e50513          	addi	a0,a0,1934 # 80008560 <syscalls+0x180>
    80002dda:	00003097          	auipc	ra,0x3
    80002dde:	082080e7          	jalr	130(ra) # 80005e5c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002de2:	40dc                	lw	a5,4(s1)
    80002de4:	0047d79b          	srliw	a5,a5,0x4
    80002de8:	00234597          	auipc	a1,0x234
    80002dec:	0605a583          	lw	a1,96(a1) # 80236e48 <sb+0x18>
    80002df0:	9dbd                	addw	a1,a1,a5
    80002df2:	4088                	lw	a0,0(s1)
    80002df4:	fffff097          	auipc	ra,0xfffff
    80002df8:	796080e7          	jalr	1942(ra) # 8000258a <bread>
    80002dfc:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002dfe:	05850593          	addi	a1,a0,88
    80002e02:	40dc                	lw	a5,4(s1)
    80002e04:	8bbd                	andi	a5,a5,15
    80002e06:	079a                	slli	a5,a5,0x6
    80002e08:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002e0a:	00059783          	lh	a5,0(a1)
    80002e0e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002e12:	00259783          	lh	a5,2(a1)
    80002e16:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002e1a:	00459783          	lh	a5,4(a1)
    80002e1e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002e22:	00659783          	lh	a5,6(a1)
    80002e26:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002e2a:	459c                	lw	a5,8(a1)
    80002e2c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002e2e:	03400613          	li	a2,52
    80002e32:	05b1                	addi	a1,a1,12
    80002e34:	05048513          	addi	a0,s1,80
    80002e38:	ffffd097          	auipc	ra,0xffffd
    80002e3c:	4e2080e7          	jalr	1250(ra) # 8000031a <memmove>
    brelse(bp);
    80002e40:	854a                	mv	a0,s2
    80002e42:	00000097          	auipc	ra,0x0
    80002e46:	878080e7          	jalr	-1928(ra) # 800026ba <brelse>
    ip->valid = 1;
    80002e4a:	4785                	li	a5,1
    80002e4c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e4e:	04449783          	lh	a5,68(s1)
    80002e52:	fbb5                	bnez	a5,80002dc6 <ilock+0x24>
      panic("ilock: no type");
    80002e54:	00005517          	auipc	a0,0x5
    80002e58:	71450513          	addi	a0,a0,1812 # 80008568 <syscalls+0x188>
    80002e5c:	00003097          	auipc	ra,0x3
    80002e60:	000080e7          	jalr	ra # 80005e5c <panic>

0000000080002e64 <iunlock>:
{
    80002e64:	1101                	addi	sp,sp,-32
    80002e66:	ec06                	sd	ra,24(sp)
    80002e68:	e822                	sd	s0,16(sp)
    80002e6a:	e426                	sd	s1,8(sp)
    80002e6c:	e04a                	sd	s2,0(sp)
    80002e6e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e70:	c905                	beqz	a0,80002ea0 <iunlock+0x3c>
    80002e72:	84aa                	mv	s1,a0
    80002e74:	01050913          	addi	s2,a0,16
    80002e78:	854a                	mv	a0,s2
    80002e7a:	00001097          	auipc	ra,0x1
    80002e7e:	c82080e7          	jalr	-894(ra) # 80003afc <holdingsleep>
    80002e82:	cd19                	beqz	a0,80002ea0 <iunlock+0x3c>
    80002e84:	449c                	lw	a5,8(s1)
    80002e86:	00f05d63          	blez	a5,80002ea0 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e8a:	854a                	mv	a0,s2
    80002e8c:	00001097          	auipc	ra,0x1
    80002e90:	c2c080e7          	jalr	-980(ra) # 80003ab8 <releasesleep>
}
    80002e94:	60e2                	ld	ra,24(sp)
    80002e96:	6442                	ld	s0,16(sp)
    80002e98:	64a2                	ld	s1,8(sp)
    80002e9a:	6902                	ld	s2,0(sp)
    80002e9c:	6105                	addi	sp,sp,32
    80002e9e:	8082                	ret
    panic("iunlock");
    80002ea0:	00005517          	auipc	a0,0x5
    80002ea4:	6d850513          	addi	a0,a0,1752 # 80008578 <syscalls+0x198>
    80002ea8:	00003097          	auipc	ra,0x3
    80002eac:	fb4080e7          	jalr	-76(ra) # 80005e5c <panic>

0000000080002eb0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002eb0:	7179                	addi	sp,sp,-48
    80002eb2:	f406                	sd	ra,40(sp)
    80002eb4:	f022                	sd	s0,32(sp)
    80002eb6:	ec26                	sd	s1,24(sp)
    80002eb8:	e84a                	sd	s2,16(sp)
    80002eba:	e44e                	sd	s3,8(sp)
    80002ebc:	e052                	sd	s4,0(sp)
    80002ebe:	1800                	addi	s0,sp,48
    80002ec0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002ec2:	05050493          	addi	s1,a0,80
    80002ec6:	08050913          	addi	s2,a0,128
    80002eca:	a021                	j	80002ed2 <itrunc+0x22>
    80002ecc:	0491                	addi	s1,s1,4
    80002ece:	01248d63          	beq	s1,s2,80002ee8 <itrunc+0x38>
    if(ip->addrs[i]){
    80002ed2:	408c                	lw	a1,0(s1)
    80002ed4:	dde5                	beqz	a1,80002ecc <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002ed6:	0009a503          	lw	a0,0(s3)
    80002eda:	00000097          	auipc	ra,0x0
    80002ede:	8f6080e7          	jalr	-1802(ra) # 800027d0 <bfree>
      ip->addrs[i] = 0;
    80002ee2:	0004a023          	sw	zero,0(s1)
    80002ee6:	b7dd                	j	80002ecc <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002ee8:	0809a583          	lw	a1,128(s3)
    80002eec:	e185                	bnez	a1,80002f0c <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002eee:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002ef2:	854e                	mv	a0,s3
    80002ef4:	00000097          	auipc	ra,0x0
    80002ef8:	de2080e7          	jalr	-542(ra) # 80002cd6 <iupdate>
}
    80002efc:	70a2                	ld	ra,40(sp)
    80002efe:	7402                	ld	s0,32(sp)
    80002f00:	64e2                	ld	s1,24(sp)
    80002f02:	6942                	ld	s2,16(sp)
    80002f04:	69a2                	ld	s3,8(sp)
    80002f06:	6a02                	ld	s4,0(sp)
    80002f08:	6145                	addi	sp,sp,48
    80002f0a:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002f0c:	0009a503          	lw	a0,0(s3)
    80002f10:	fffff097          	auipc	ra,0xfffff
    80002f14:	67a080e7          	jalr	1658(ra) # 8000258a <bread>
    80002f18:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002f1a:	05850493          	addi	s1,a0,88
    80002f1e:	45850913          	addi	s2,a0,1112
    80002f22:	a021                	j	80002f2a <itrunc+0x7a>
    80002f24:	0491                	addi	s1,s1,4
    80002f26:	01248b63          	beq	s1,s2,80002f3c <itrunc+0x8c>
      if(a[j])
    80002f2a:	408c                	lw	a1,0(s1)
    80002f2c:	dde5                	beqz	a1,80002f24 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002f2e:	0009a503          	lw	a0,0(s3)
    80002f32:	00000097          	auipc	ra,0x0
    80002f36:	89e080e7          	jalr	-1890(ra) # 800027d0 <bfree>
    80002f3a:	b7ed                	j	80002f24 <itrunc+0x74>
    brelse(bp);
    80002f3c:	8552                	mv	a0,s4
    80002f3e:	fffff097          	auipc	ra,0xfffff
    80002f42:	77c080e7          	jalr	1916(ra) # 800026ba <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f46:	0809a583          	lw	a1,128(s3)
    80002f4a:	0009a503          	lw	a0,0(s3)
    80002f4e:	00000097          	auipc	ra,0x0
    80002f52:	882080e7          	jalr	-1918(ra) # 800027d0 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f56:	0809a023          	sw	zero,128(s3)
    80002f5a:	bf51                	j	80002eee <itrunc+0x3e>

0000000080002f5c <iput>:
{
    80002f5c:	1101                	addi	sp,sp,-32
    80002f5e:	ec06                	sd	ra,24(sp)
    80002f60:	e822                	sd	s0,16(sp)
    80002f62:	e426                	sd	s1,8(sp)
    80002f64:	e04a                	sd	s2,0(sp)
    80002f66:	1000                	addi	s0,sp,32
    80002f68:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f6a:	00234517          	auipc	a0,0x234
    80002f6e:	ee650513          	addi	a0,a0,-282 # 80236e50 <itable>
    80002f72:	00003097          	auipc	ra,0x3
    80002f76:	422080e7          	jalr	1058(ra) # 80006394 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f7a:	4498                	lw	a4,8(s1)
    80002f7c:	4785                	li	a5,1
    80002f7e:	02f70363          	beq	a4,a5,80002fa4 <iput+0x48>
  ip->ref--;
    80002f82:	449c                	lw	a5,8(s1)
    80002f84:	37fd                	addiw	a5,a5,-1
    80002f86:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f88:	00234517          	auipc	a0,0x234
    80002f8c:	ec850513          	addi	a0,a0,-312 # 80236e50 <itable>
    80002f90:	00003097          	auipc	ra,0x3
    80002f94:	4b8080e7          	jalr	1208(ra) # 80006448 <release>
}
    80002f98:	60e2                	ld	ra,24(sp)
    80002f9a:	6442                	ld	s0,16(sp)
    80002f9c:	64a2                	ld	s1,8(sp)
    80002f9e:	6902                	ld	s2,0(sp)
    80002fa0:	6105                	addi	sp,sp,32
    80002fa2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002fa4:	40bc                	lw	a5,64(s1)
    80002fa6:	dff1                	beqz	a5,80002f82 <iput+0x26>
    80002fa8:	04a49783          	lh	a5,74(s1)
    80002fac:	fbf9                	bnez	a5,80002f82 <iput+0x26>
    acquiresleep(&ip->lock);
    80002fae:	01048913          	addi	s2,s1,16
    80002fb2:	854a                	mv	a0,s2
    80002fb4:	00001097          	auipc	ra,0x1
    80002fb8:	aae080e7          	jalr	-1362(ra) # 80003a62 <acquiresleep>
    release(&itable.lock);
    80002fbc:	00234517          	auipc	a0,0x234
    80002fc0:	e9450513          	addi	a0,a0,-364 # 80236e50 <itable>
    80002fc4:	00003097          	auipc	ra,0x3
    80002fc8:	484080e7          	jalr	1156(ra) # 80006448 <release>
    itrunc(ip);
    80002fcc:	8526                	mv	a0,s1
    80002fce:	00000097          	auipc	ra,0x0
    80002fd2:	ee2080e7          	jalr	-286(ra) # 80002eb0 <itrunc>
    ip->type = 0;
    80002fd6:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002fda:	8526                	mv	a0,s1
    80002fdc:	00000097          	auipc	ra,0x0
    80002fe0:	cfa080e7          	jalr	-774(ra) # 80002cd6 <iupdate>
    ip->valid = 0;
    80002fe4:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002fe8:	854a                	mv	a0,s2
    80002fea:	00001097          	auipc	ra,0x1
    80002fee:	ace080e7          	jalr	-1330(ra) # 80003ab8 <releasesleep>
    acquire(&itable.lock);
    80002ff2:	00234517          	auipc	a0,0x234
    80002ff6:	e5e50513          	addi	a0,a0,-418 # 80236e50 <itable>
    80002ffa:	00003097          	auipc	ra,0x3
    80002ffe:	39a080e7          	jalr	922(ra) # 80006394 <acquire>
    80003002:	b741                	j	80002f82 <iput+0x26>

0000000080003004 <iunlockput>:
{
    80003004:	1101                	addi	sp,sp,-32
    80003006:	ec06                	sd	ra,24(sp)
    80003008:	e822                	sd	s0,16(sp)
    8000300a:	e426                	sd	s1,8(sp)
    8000300c:	1000                	addi	s0,sp,32
    8000300e:	84aa                	mv	s1,a0
  iunlock(ip);
    80003010:	00000097          	auipc	ra,0x0
    80003014:	e54080e7          	jalr	-428(ra) # 80002e64 <iunlock>
  iput(ip);
    80003018:	8526                	mv	a0,s1
    8000301a:	00000097          	auipc	ra,0x0
    8000301e:	f42080e7          	jalr	-190(ra) # 80002f5c <iput>
}
    80003022:	60e2                	ld	ra,24(sp)
    80003024:	6442                	ld	s0,16(sp)
    80003026:	64a2                	ld	s1,8(sp)
    80003028:	6105                	addi	sp,sp,32
    8000302a:	8082                	ret

000000008000302c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000302c:	1141                	addi	sp,sp,-16
    8000302e:	e422                	sd	s0,8(sp)
    80003030:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003032:	411c                	lw	a5,0(a0)
    80003034:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003036:	415c                	lw	a5,4(a0)
    80003038:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000303a:	04451783          	lh	a5,68(a0)
    8000303e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003042:	04a51783          	lh	a5,74(a0)
    80003046:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000304a:	04c56783          	lwu	a5,76(a0)
    8000304e:	e99c                	sd	a5,16(a1)
}
    80003050:	6422                	ld	s0,8(sp)
    80003052:	0141                	addi	sp,sp,16
    80003054:	8082                	ret

0000000080003056 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003056:	457c                	lw	a5,76(a0)
    80003058:	0ed7e963          	bltu	a5,a3,8000314a <readi+0xf4>
{
    8000305c:	7159                	addi	sp,sp,-112
    8000305e:	f486                	sd	ra,104(sp)
    80003060:	f0a2                	sd	s0,96(sp)
    80003062:	eca6                	sd	s1,88(sp)
    80003064:	e8ca                	sd	s2,80(sp)
    80003066:	e4ce                	sd	s3,72(sp)
    80003068:	e0d2                	sd	s4,64(sp)
    8000306a:	fc56                	sd	s5,56(sp)
    8000306c:	f85a                	sd	s6,48(sp)
    8000306e:	f45e                	sd	s7,40(sp)
    80003070:	f062                	sd	s8,32(sp)
    80003072:	ec66                	sd	s9,24(sp)
    80003074:	e86a                	sd	s10,16(sp)
    80003076:	e46e                	sd	s11,8(sp)
    80003078:	1880                	addi	s0,sp,112
    8000307a:	8b2a                	mv	s6,a0
    8000307c:	8bae                	mv	s7,a1
    8000307e:	8a32                	mv	s4,a2
    80003080:	84b6                	mv	s1,a3
    80003082:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003084:	9f35                	addw	a4,a4,a3
    return 0;
    80003086:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003088:	0ad76063          	bltu	a4,a3,80003128 <readi+0xd2>
  if(off + n > ip->size)
    8000308c:	00e7f463          	bgeu	a5,a4,80003094 <readi+0x3e>
    n = ip->size - off;
    80003090:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003094:	0a0a8963          	beqz	s5,80003146 <readi+0xf0>
    80003098:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000309a:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000309e:	5c7d                	li	s8,-1
    800030a0:	a82d                	j	800030da <readi+0x84>
    800030a2:	020d1d93          	slli	s11,s10,0x20
    800030a6:	020ddd93          	srli	s11,s11,0x20
    800030aa:	05890613          	addi	a2,s2,88
    800030ae:	86ee                	mv	a3,s11
    800030b0:	963a                	add	a2,a2,a4
    800030b2:	85d2                	mv	a1,s4
    800030b4:	855e                	mv	a0,s7
    800030b6:	fffff097          	auipc	ra,0xfffff
    800030ba:	9a8080e7          	jalr	-1624(ra) # 80001a5e <either_copyout>
    800030be:	05850d63          	beq	a0,s8,80003118 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800030c2:	854a                	mv	a0,s2
    800030c4:	fffff097          	auipc	ra,0xfffff
    800030c8:	5f6080e7          	jalr	1526(ra) # 800026ba <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030cc:	013d09bb          	addw	s3,s10,s3
    800030d0:	009d04bb          	addw	s1,s10,s1
    800030d4:	9a6e                	add	s4,s4,s11
    800030d6:	0559f763          	bgeu	s3,s5,80003124 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    800030da:	00a4d59b          	srliw	a1,s1,0xa
    800030de:	855a                	mv	a0,s6
    800030e0:	00000097          	auipc	ra,0x0
    800030e4:	89e080e7          	jalr	-1890(ra) # 8000297e <bmap>
    800030e8:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800030ec:	cd85                	beqz	a1,80003124 <readi+0xce>
    bp = bread(ip->dev, addr);
    800030ee:	000b2503          	lw	a0,0(s6)
    800030f2:	fffff097          	auipc	ra,0xfffff
    800030f6:	498080e7          	jalr	1176(ra) # 8000258a <bread>
    800030fa:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030fc:	3ff4f713          	andi	a4,s1,1023
    80003100:	40ec87bb          	subw	a5,s9,a4
    80003104:	413a86bb          	subw	a3,s5,s3
    80003108:	8d3e                	mv	s10,a5
    8000310a:	2781                	sext.w	a5,a5
    8000310c:	0006861b          	sext.w	a2,a3
    80003110:	f8f679e3          	bgeu	a2,a5,800030a2 <readi+0x4c>
    80003114:	8d36                	mv	s10,a3
    80003116:	b771                	j	800030a2 <readi+0x4c>
      brelse(bp);
    80003118:	854a                	mv	a0,s2
    8000311a:	fffff097          	auipc	ra,0xfffff
    8000311e:	5a0080e7          	jalr	1440(ra) # 800026ba <brelse>
      tot = -1;
    80003122:	59fd                	li	s3,-1
  }
  return tot;
    80003124:	0009851b          	sext.w	a0,s3
}
    80003128:	70a6                	ld	ra,104(sp)
    8000312a:	7406                	ld	s0,96(sp)
    8000312c:	64e6                	ld	s1,88(sp)
    8000312e:	6946                	ld	s2,80(sp)
    80003130:	69a6                	ld	s3,72(sp)
    80003132:	6a06                	ld	s4,64(sp)
    80003134:	7ae2                	ld	s5,56(sp)
    80003136:	7b42                	ld	s6,48(sp)
    80003138:	7ba2                	ld	s7,40(sp)
    8000313a:	7c02                	ld	s8,32(sp)
    8000313c:	6ce2                	ld	s9,24(sp)
    8000313e:	6d42                	ld	s10,16(sp)
    80003140:	6da2                	ld	s11,8(sp)
    80003142:	6165                	addi	sp,sp,112
    80003144:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003146:	89d6                	mv	s3,s5
    80003148:	bff1                	j	80003124 <readi+0xce>
    return 0;
    8000314a:	4501                	li	a0,0
}
    8000314c:	8082                	ret

000000008000314e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000314e:	457c                	lw	a5,76(a0)
    80003150:	10d7e863          	bltu	a5,a3,80003260 <writei+0x112>
{
    80003154:	7159                	addi	sp,sp,-112
    80003156:	f486                	sd	ra,104(sp)
    80003158:	f0a2                	sd	s0,96(sp)
    8000315a:	eca6                	sd	s1,88(sp)
    8000315c:	e8ca                	sd	s2,80(sp)
    8000315e:	e4ce                	sd	s3,72(sp)
    80003160:	e0d2                	sd	s4,64(sp)
    80003162:	fc56                	sd	s5,56(sp)
    80003164:	f85a                	sd	s6,48(sp)
    80003166:	f45e                	sd	s7,40(sp)
    80003168:	f062                	sd	s8,32(sp)
    8000316a:	ec66                	sd	s9,24(sp)
    8000316c:	e86a                	sd	s10,16(sp)
    8000316e:	e46e                	sd	s11,8(sp)
    80003170:	1880                	addi	s0,sp,112
    80003172:	8aaa                	mv	s5,a0
    80003174:	8bae                	mv	s7,a1
    80003176:	8a32                	mv	s4,a2
    80003178:	8936                	mv	s2,a3
    8000317a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000317c:	00e687bb          	addw	a5,a3,a4
    80003180:	0ed7e263          	bltu	a5,a3,80003264 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003184:	00043737          	lui	a4,0x43
    80003188:	0ef76063          	bltu	a4,a5,80003268 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000318c:	0c0b0863          	beqz	s6,8000325c <writei+0x10e>
    80003190:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003192:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003196:	5c7d                	li	s8,-1
    80003198:	a091                	j	800031dc <writei+0x8e>
    8000319a:	020d1d93          	slli	s11,s10,0x20
    8000319e:	020ddd93          	srli	s11,s11,0x20
    800031a2:	05848513          	addi	a0,s1,88
    800031a6:	86ee                	mv	a3,s11
    800031a8:	8652                	mv	a2,s4
    800031aa:	85de                	mv	a1,s7
    800031ac:	953a                	add	a0,a0,a4
    800031ae:	fffff097          	auipc	ra,0xfffff
    800031b2:	906080e7          	jalr	-1786(ra) # 80001ab4 <either_copyin>
    800031b6:	07850263          	beq	a0,s8,8000321a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800031ba:	8526                	mv	a0,s1
    800031bc:	00000097          	auipc	ra,0x0
    800031c0:	788080e7          	jalr	1928(ra) # 80003944 <log_write>
    brelse(bp);
    800031c4:	8526                	mv	a0,s1
    800031c6:	fffff097          	auipc	ra,0xfffff
    800031ca:	4f4080e7          	jalr	1268(ra) # 800026ba <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031ce:	013d09bb          	addw	s3,s10,s3
    800031d2:	012d093b          	addw	s2,s10,s2
    800031d6:	9a6e                	add	s4,s4,s11
    800031d8:	0569f663          	bgeu	s3,s6,80003224 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800031dc:	00a9559b          	srliw	a1,s2,0xa
    800031e0:	8556                	mv	a0,s5
    800031e2:	fffff097          	auipc	ra,0xfffff
    800031e6:	79c080e7          	jalr	1948(ra) # 8000297e <bmap>
    800031ea:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800031ee:	c99d                	beqz	a1,80003224 <writei+0xd6>
    bp = bread(ip->dev, addr);
    800031f0:	000aa503          	lw	a0,0(s5)
    800031f4:	fffff097          	auipc	ra,0xfffff
    800031f8:	396080e7          	jalr	918(ra) # 8000258a <bread>
    800031fc:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031fe:	3ff97713          	andi	a4,s2,1023
    80003202:	40ec87bb          	subw	a5,s9,a4
    80003206:	413b06bb          	subw	a3,s6,s3
    8000320a:	8d3e                	mv	s10,a5
    8000320c:	2781                	sext.w	a5,a5
    8000320e:	0006861b          	sext.w	a2,a3
    80003212:	f8f674e3          	bgeu	a2,a5,8000319a <writei+0x4c>
    80003216:	8d36                	mv	s10,a3
    80003218:	b749                	j	8000319a <writei+0x4c>
      brelse(bp);
    8000321a:	8526                	mv	a0,s1
    8000321c:	fffff097          	auipc	ra,0xfffff
    80003220:	49e080e7          	jalr	1182(ra) # 800026ba <brelse>
  }

  if(off > ip->size)
    80003224:	04caa783          	lw	a5,76(s5)
    80003228:	0127f463          	bgeu	a5,s2,80003230 <writei+0xe2>
    ip->size = off;
    8000322c:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003230:	8556                	mv	a0,s5
    80003232:	00000097          	auipc	ra,0x0
    80003236:	aa4080e7          	jalr	-1372(ra) # 80002cd6 <iupdate>

  return tot;
    8000323a:	0009851b          	sext.w	a0,s3
}
    8000323e:	70a6                	ld	ra,104(sp)
    80003240:	7406                	ld	s0,96(sp)
    80003242:	64e6                	ld	s1,88(sp)
    80003244:	6946                	ld	s2,80(sp)
    80003246:	69a6                	ld	s3,72(sp)
    80003248:	6a06                	ld	s4,64(sp)
    8000324a:	7ae2                	ld	s5,56(sp)
    8000324c:	7b42                	ld	s6,48(sp)
    8000324e:	7ba2                	ld	s7,40(sp)
    80003250:	7c02                	ld	s8,32(sp)
    80003252:	6ce2                	ld	s9,24(sp)
    80003254:	6d42                	ld	s10,16(sp)
    80003256:	6da2                	ld	s11,8(sp)
    80003258:	6165                	addi	sp,sp,112
    8000325a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000325c:	89da                	mv	s3,s6
    8000325e:	bfc9                	j	80003230 <writei+0xe2>
    return -1;
    80003260:	557d                	li	a0,-1
}
    80003262:	8082                	ret
    return -1;
    80003264:	557d                	li	a0,-1
    80003266:	bfe1                	j	8000323e <writei+0xf0>
    return -1;
    80003268:	557d                	li	a0,-1
    8000326a:	bfd1                	j	8000323e <writei+0xf0>

000000008000326c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000326c:	1141                	addi	sp,sp,-16
    8000326e:	e406                	sd	ra,8(sp)
    80003270:	e022                	sd	s0,0(sp)
    80003272:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003274:	4639                	li	a2,14
    80003276:	ffffd097          	auipc	ra,0xffffd
    8000327a:	118080e7          	jalr	280(ra) # 8000038e <strncmp>
}
    8000327e:	60a2                	ld	ra,8(sp)
    80003280:	6402                	ld	s0,0(sp)
    80003282:	0141                	addi	sp,sp,16
    80003284:	8082                	ret

0000000080003286 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003286:	7139                	addi	sp,sp,-64
    80003288:	fc06                	sd	ra,56(sp)
    8000328a:	f822                	sd	s0,48(sp)
    8000328c:	f426                	sd	s1,40(sp)
    8000328e:	f04a                	sd	s2,32(sp)
    80003290:	ec4e                	sd	s3,24(sp)
    80003292:	e852                	sd	s4,16(sp)
    80003294:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003296:	04451703          	lh	a4,68(a0)
    8000329a:	4785                	li	a5,1
    8000329c:	00f71a63          	bne	a4,a5,800032b0 <dirlookup+0x2a>
    800032a0:	892a                	mv	s2,a0
    800032a2:	89ae                	mv	s3,a1
    800032a4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800032a6:	457c                	lw	a5,76(a0)
    800032a8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800032aa:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032ac:	e79d                	bnez	a5,800032da <dirlookup+0x54>
    800032ae:	a8a5                	j	80003326 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800032b0:	00005517          	auipc	a0,0x5
    800032b4:	2d050513          	addi	a0,a0,720 # 80008580 <syscalls+0x1a0>
    800032b8:	00003097          	auipc	ra,0x3
    800032bc:	ba4080e7          	jalr	-1116(ra) # 80005e5c <panic>
      panic("dirlookup read");
    800032c0:	00005517          	auipc	a0,0x5
    800032c4:	2d850513          	addi	a0,a0,728 # 80008598 <syscalls+0x1b8>
    800032c8:	00003097          	auipc	ra,0x3
    800032cc:	b94080e7          	jalr	-1132(ra) # 80005e5c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032d0:	24c1                	addiw	s1,s1,16
    800032d2:	04c92783          	lw	a5,76(s2)
    800032d6:	04f4f763          	bgeu	s1,a5,80003324 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032da:	4741                	li	a4,16
    800032dc:	86a6                	mv	a3,s1
    800032de:	fc040613          	addi	a2,s0,-64
    800032e2:	4581                	li	a1,0
    800032e4:	854a                	mv	a0,s2
    800032e6:	00000097          	auipc	ra,0x0
    800032ea:	d70080e7          	jalr	-656(ra) # 80003056 <readi>
    800032ee:	47c1                	li	a5,16
    800032f0:	fcf518e3          	bne	a0,a5,800032c0 <dirlookup+0x3a>
    if(de.inum == 0)
    800032f4:	fc045783          	lhu	a5,-64(s0)
    800032f8:	dfe1                	beqz	a5,800032d0 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800032fa:	fc240593          	addi	a1,s0,-62
    800032fe:	854e                	mv	a0,s3
    80003300:	00000097          	auipc	ra,0x0
    80003304:	f6c080e7          	jalr	-148(ra) # 8000326c <namecmp>
    80003308:	f561                	bnez	a0,800032d0 <dirlookup+0x4a>
      if(poff)
    8000330a:	000a0463          	beqz	s4,80003312 <dirlookup+0x8c>
        *poff = off;
    8000330e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003312:	fc045583          	lhu	a1,-64(s0)
    80003316:	00092503          	lw	a0,0(s2)
    8000331a:	fffff097          	auipc	ra,0xfffff
    8000331e:	74e080e7          	jalr	1870(ra) # 80002a68 <iget>
    80003322:	a011                	j	80003326 <dirlookup+0xa0>
  return 0;
    80003324:	4501                	li	a0,0
}
    80003326:	70e2                	ld	ra,56(sp)
    80003328:	7442                	ld	s0,48(sp)
    8000332a:	74a2                	ld	s1,40(sp)
    8000332c:	7902                	ld	s2,32(sp)
    8000332e:	69e2                	ld	s3,24(sp)
    80003330:	6a42                	ld	s4,16(sp)
    80003332:	6121                	addi	sp,sp,64
    80003334:	8082                	ret

0000000080003336 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003336:	711d                	addi	sp,sp,-96
    80003338:	ec86                	sd	ra,88(sp)
    8000333a:	e8a2                	sd	s0,80(sp)
    8000333c:	e4a6                	sd	s1,72(sp)
    8000333e:	e0ca                	sd	s2,64(sp)
    80003340:	fc4e                	sd	s3,56(sp)
    80003342:	f852                	sd	s4,48(sp)
    80003344:	f456                	sd	s5,40(sp)
    80003346:	f05a                	sd	s6,32(sp)
    80003348:	ec5e                	sd	s7,24(sp)
    8000334a:	e862                	sd	s8,16(sp)
    8000334c:	e466                	sd	s9,8(sp)
    8000334e:	e06a                	sd	s10,0(sp)
    80003350:	1080                	addi	s0,sp,96
    80003352:	84aa                	mv	s1,a0
    80003354:	8b2e                	mv	s6,a1
    80003356:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003358:	00054703          	lbu	a4,0(a0)
    8000335c:	02f00793          	li	a5,47
    80003360:	02f70363          	beq	a4,a5,80003386 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003364:	ffffe097          	auipc	ra,0xffffe
    80003368:	c4a080e7          	jalr	-950(ra) # 80000fae <myproc>
    8000336c:	15053503          	ld	a0,336(a0)
    80003370:	00000097          	auipc	ra,0x0
    80003374:	9f4080e7          	jalr	-1548(ra) # 80002d64 <idup>
    80003378:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000337a:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000337e:	4cb5                	li	s9,13
  len = path - s;
    80003380:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003382:	4c05                	li	s8,1
    80003384:	a87d                	j	80003442 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003386:	4585                	li	a1,1
    80003388:	4505                	li	a0,1
    8000338a:	fffff097          	auipc	ra,0xfffff
    8000338e:	6de080e7          	jalr	1758(ra) # 80002a68 <iget>
    80003392:	8a2a                	mv	s4,a0
    80003394:	b7dd                	j	8000337a <namex+0x44>
      iunlockput(ip);
    80003396:	8552                	mv	a0,s4
    80003398:	00000097          	auipc	ra,0x0
    8000339c:	c6c080e7          	jalr	-916(ra) # 80003004 <iunlockput>
      return 0;
    800033a0:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800033a2:	8552                	mv	a0,s4
    800033a4:	60e6                	ld	ra,88(sp)
    800033a6:	6446                	ld	s0,80(sp)
    800033a8:	64a6                	ld	s1,72(sp)
    800033aa:	6906                	ld	s2,64(sp)
    800033ac:	79e2                	ld	s3,56(sp)
    800033ae:	7a42                	ld	s4,48(sp)
    800033b0:	7aa2                	ld	s5,40(sp)
    800033b2:	7b02                	ld	s6,32(sp)
    800033b4:	6be2                	ld	s7,24(sp)
    800033b6:	6c42                	ld	s8,16(sp)
    800033b8:	6ca2                	ld	s9,8(sp)
    800033ba:	6d02                	ld	s10,0(sp)
    800033bc:	6125                	addi	sp,sp,96
    800033be:	8082                	ret
      iunlock(ip);
    800033c0:	8552                	mv	a0,s4
    800033c2:	00000097          	auipc	ra,0x0
    800033c6:	aa2080e7          	jalr	-1374(ra) # 80002e64 <iunlock>
      return ip;
    800033ca:	bfe1                	j	800033a2 <namex+0x6c>
      iunlockput(ip);
    800033cc:	8552                	mv	a0,s4
    800033ce:	00000097          	auipc	ra,0x0
    800033d2:	c36080e7          	jalr	-970(ra) # 80003004 <iunlockput>
      return 0;
    800033d6:	8a4e                	mv	s4,s3
    800033d8:	b7e9                	j	800033a2 <namex+0x6c>
  len = path - s;
    800033da:	40998633          	sub	a2,s3,s1
    800033de:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800033e2:	09acd863          	bge	s9,s10,80003472 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800033e6:	4639                	li	a2,14
    800033e8:	85a6                	mv	a1,s1
    800033ea:	8556                	mv	a0,s5
    800033ec:	ffffd097          	auipc	ra,0xffffd
    800033f0:	f2e080e7          	jalr	-210(ra) # 8000031a <memmove>
    800033f4:	84ce                	mv	s1,s3
  while(*path == '/')
    800033f6:	0004c783          	lbu	a5,0(s1)
    800033fa:	01279763          	bne	a5,s2,80003408 <namex+0xd2>
    path++;
    800033fe:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003400:	0004c783          	lbu	a5,0(s1)
    80003404:	ff278de3          	beq	a5,s2,800033fe <namex+0xc8>
    ilock(ip);
    80003408:	8552                	mv	a0,s4
    8000340a:	00000097          	auipc	ra,0x0
    8000340e:	998080e7          	jalr	-1640(ra) # 80002da2 <ilock>
    if(ip->type != T_DIR){
    80003412:	044a1783          	lh	a5,68(s4)
    80003416:	f98790e3          	bne	a5,s8,80003396 <namex+0x60>
    if(nameiparent && *path == '\0'){
    8000341a:	000b0563          	beqz	s6,80003424 <namex+0xee>
    8000341e:	0004c783          	lbu	a5,0(s1)
    80003422:	dfd9                	beqz	a5,800033c0 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003424:	865e                	mv	a2,s7
    80003426:	85d6                	mv	a1,s5
    80003428:	8552                	mv	a0,s4
    8000342a:	00000097          	auipc	ra,0x0
    8000342e:	e5c080e7          	jalr	-420(ra) # 80003286 <dirlookup>
    80003432:	89aa                	mv	s3,a0
    80003434:	dd41                	beqz	a0,800033cc <namex+0x96>
    iunlockput(ip);
    80003436:	8552                	mv	a0,s4
    80003438:	00000097          	auipc	ra,0x0
    8000343c:	bcc080e7          	jalr	-1076(ra) # 80003004 <iunlockput>
    ip = next;
    80003440:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003442:	0004c783          	lbu	a5,0(s1)
    80003446:	01279763          	bne	a5,s2,80003454 <namex+0x11e>
    path++;
    8000344a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000344c:	0004c783          	lbu	a5,0(s1)
    80003450:	ff278de3          	beq	a5,s2,8000344a <namex+0x114>
  if(*path == 0)
    80003454:	cb9d                	beqz	a5,8000348a <namex+0x154>
  while(*path != '/' && *path != 0)
    80003456:	0004c783          	lbu	a5,0(s1)
    8000345a:	89a6                	mv	s3,s1
  len = path - s;
    8000345c:	8d5e                	mv	s10,s7
    8000345e:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003460:	01278963          	beq	a5,s2,80003472 <namex+0x13c>
    80003464:	dbbd                	beqz	a5,800033da <namex+0xa4>
    path++;
    80003466:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003468:	0009c783          	lbu	a5,0(s3)
    8000346c:	ff279ce3          	bne	a5,s2,80003464 <namex+0x12e>
    80003470:	b7ad                	j	800033da <namex+0xa4>
    memmove(name, s, len);
    80003472:	2601                	sext.w	a2,a2
    80003474:	85a6                	mv	a1,s1
    80003476:	8556                	mv	a0,s5
    80003478:	ffffd097          	auipc	ra,0xffffd
    8000347c:	ea2080e7          	jalr	-350(ra) # 8000031a <memmove>
    name[len] = 0;
    80003480:	9d56                	add	s10,s10,s5
    80003482:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7fdbd280>
    80003486:	84ce                	mv	s1,s3
    80003488:	b7bd                	j	800033f6 <namex+0xc0>
  if(nameiparent){
    8000348a:	f00b0ce3          	beqz	s6,800033a2 <namex+0x6c>
    iput(ip);
    8000348e:	8552                	mv	a0,s4
    80003490:	00000097          	auipc	ra,0x0
    80003494:	acc080e7          	jalr	-1332(ra) # 80002f5c <iput>
    return 0;
    80003498:	4a01                	li	s4,0
    8000349a:	b721                	j	800033a2 <namex+0x6c>

000000008000349c <dirlink>:
{
    8000349c:	7139                	addi	sp,sp,-64
    8000349e:	fc06                	sd	ra,56(sp)
    800034a0:	f822                	sd	s0,48(sp)
    800034a2:	f426                	sd	s1,40(sp)
    800034a4:	f04a                	sd	s2,32(sp)
    800034a6:	ec4e                	sd	s3,24(sp)
    800034a8:	e852                	sd	s4,16(sp)
    800034aa:	0080                	addi	s0,sp,64
    800034ac:	892a                	mv	s2,a0
    800034ae:	8a2e                	mv	s4,a1
    800034b0:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800034b2:	4601                	li	a2,0
    800034b4:	00000097          	auipc	ra,0x0
    800034b8:	dd2080e7          	jalr	-558(ra) # 80003286 <dirlookup>
    800034bc:	e93d                	bnez	a0,80003532 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034be:	04c92483          	lw	s1,76(s2)
    800034c2:	c49d                	beqz	s1,800034f0 <dirlink+0x54>
    800034c4:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034c6:	4741                	li	a4,16
    800034c8:	86a6                	mv	a3,s1
    800034ca:	fc040613          	addi	a2,s0,-64
    800034ce:	4581                	li	a1,0
    800034d0:	854a                	mv	a0,s2
    800034d2:	00000097          	auipc	ra,0x0
    800034d6:	b84080e7          	jalr	-1148(ra) # 80003056 <readi>
    800034da:	47c1                	li	a5,16
    800034dc:	06f51163          	bne	a0,a5,8000353e <dirlink+0xa2>
    if(de.inum == 0)
    800034e0:	fc045783          	lhu	a5,-64(s0)
    800034e4:	c791                	beqz	a5,800034f0 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034e6:	24c1                	addiw	s1,s1,16
    800034e8:	04c92783          	lw	a5,76(s2)
    800034ec:	fcf4ede3          	bltu	s1,a5,800034c6 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800034f0:	4639                	li	a2,14
    800034f2:	85d2                	mv	a1,s4
    800034f4:	fc240513          	addi	a0,s0,-62
    800034f8:	ffffd097          	auipc	ra,0xffffd
    800034fc:	ed2080e7          	jalr	-302(ra) # 800003ca <strncpy>
  de.inum = inum;
    80003500:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003504:	4741                	li	a4,16
    80003506:	86a6                	mv	a3,s1
    80003508:	fc040613          	addi	a2,s0,-64
    8000350c:	4581                	li	a1,0
    8000350e:	854a                	mv	a0,s2
    80003510:	00000097          	auipc	ra,0x0
    80003514:	c3e080e7          	jalr	-962(ra) # 8000314e <writei>
    80003518:	1541                	addi	a0,a0,-16
    8000351a:	00a03533          	snez	a0,a0
    8000351e:	40a00533          	neg	a0,a0
}
    80003522:	70e2                	ld	ra,56(sp)
    80003524:	7442                	ld	s0,48(sp)
    80003526:	74a2                	ld	s1,40(sp)
    80003528:	7902                	ld	s2,32(sp)
    8000352a:	69e2                	ld	s3,24(sp)
    8000352c:	6a42                	ld	s4,16(sp)
    8000352e:	6121                	addi	sp,sp,64
    80003530:	8082                	ret
    iput(ip);
    80003532:	00000097          	auipc	ra,0x0
    80003536:	a2a080e7          	jalr	-1494(ra) # 80002f5c <iput>
    return -1;
    8000353a:	557d                	li	a0,-1
    8000353c:	b7dd                	j	80003522 <dirlink+0x86>
      panic("dirlink read");
    8000353e:	00005517          	auipc	a0,0x5
    80003542:	06a50513          	addi	a0,a0,106 # 800085a8 <syscalls+0x1c8>
    80003546:	00003097          	auipc	ra,0x3
    8000354a:	916080e7          	jalr	-1770(ra) # 80005e5c <panic>

000000008000354e <namei>:

struct inode*
namei(char *path)
{
    8000354e:	1101                	addi	sp,sp,-32
    80003550:	ec06                	sd	ra,24(sp)
    80003552:	e822                	sd	s0,16(sp)
    80003554:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003556:	fe040613          	addi	a2,s0,-32
    8000355a:	4581                	li	a1,0
    8000355c:	00000097          	auipc	ra,0x0
    80003560:	dda080e7          	jalr	-550(ra) # 80003336 <namex>
}
    80003564:	60e2                	ld	ra,24(sp)
    80003566:	6442                	ld	s0,16(sp)
    80003568:	6105                	addi	sp,sp,32
    8000356a:	8082                	ret

000000008000356c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000356c:	1141                	addi	sp,sp,-16
    8000356e:	e406                	sd	ra,8(sp)
    80003570:	e022                	sd	s0,0(sp)
    80003572:	0800                	addi	s0,sp,16
    80003574:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003576:	4585                	li	a1,1
    80003578:	00000097          	auipc	ra,0x0
    8000357c:	dbe080e7          	jalr	-578(ra) # 80003336 <namex>
}
    80003580:	60a2                	ld	ra,8(sp)
    80003582:	6402                	ld	s0,0(sp)
    80003584:	0141                	addi	sp,sp,16
    80003586:	8082                	ret

0000000080003588 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003588:	1101                	addi	sp,sp,-32
    8000358a:	ec06                	sd	ra,24(sp)
    8000358c:	e822                	sd	s0,16(sp)
    8000358e:	e426                	sd	s1,8(sp)
    80003590:	e04a                	sd	s2,0(sp)
    80003592:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003594:	00235917          	auipc	s2,0x235
    80003598:	36490913          	addi	s2,s2,868 # 802388f8 <log>
    8000359c:	01892583          	lw	a1,24(s2)
    800035a0:	02892503          	lw	a0,40(s2)
    800035a4:	fffff097          	auipc	ra,0xfffff
    800035a8:	fe6080e7          	jalr	-26(ra) # 8000258a <bread>
    800035ac:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800035ae:	02c92683          	lw	a3,44(s2)
    800035b2:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800035b4:	02d05863          	blez	a3,800035e4 <write_head+0x5c>
    800035b8:	00235797          	auipc	a5,0x235
    800035bc:	37078793          	addi	a5,a5,880 # 80238928 <log+0x30>
    800035c0:	05c50713          	addi	a4,a0,92
    800035c4:	36fd                	addiw	a3,a3,-1
    800035c6:	02069613          	slli	a2,a3,0x20
    800035ca:	01e65693          	srli	a3,a2,0x1e
    800035ce:	00235617          	auipc	a2,0x235
    800035d2:	35e60613          	addi	a2,a2,862 # 8023892c <log+0x34>
    800035d6:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800035d8:	4390                	lw	a2,0(a5)
    800035da:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035dc:	0791                	addi	a5,a5,4
    800035de:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    800035e0:	fed79ce3          	bne	a5,a3,800035d8 <write_head+0x50>
  }
  bwrite(buf);
    800035e4:	8526                	mv	a0,s1
    800035e6:	fffff097          	auipc	ra,0xfffff
    800035ea:	096080e7          	jalr	150(ra) # 8000267c <bwrite>
  brelse(buf);
    800035ee:	8526                	mv	a0,s1
    800035f0:	fffff097          	auipc	ra,0xfffff
    800035f4:	0ca080e7          	jalr	202(ra) # 800026ba <brelse>
}
    800035f8:	60e2                	ld	ra,24(sp)
    800035fa:	6442                	ld	s0,16(sp)
    800035fc:	64a2                	ld	s1,8(sp)
    800035fe:	6902                	ld	s2,0(sp)
    80003600:	6105                	addi	sp,sp,32
    80003602:	8082                	ret

0000000080003604 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003604:	00235797          	auipc	a5,0x235
    80003608:	3207a783          	lw	a5,800(a5) # 80238924 <log+0x2c>
    8000360c:	0af05d63          	blez	a5,800036c6 <install_trans+0xc2>
{
    80003610:	7139                	addi	sp,sp,-64
    80003612:	fc06                	sd	ra,56(sp)
    80003614:	f822                	sd	s0,48(sp)
    80003616:	f426                	sd	s1,40(sp)
    80003618:	f04a                	sd	s2,32(sp)
    8000361a:	ec4e                	sd	s3,24(sp)
    8000361c:	e852                	sd	s4,16(sp)
    8000361e:	e456                	sd	s5,8(sp)
    80003620:	e05a                	sd	s6,0(sp)
    80003622:	0080                	addi	s0,sp,64
    80003624:	8b2a                	mv	s6,a0
    80003626:	00235a97          	auipc	s5,0x235
    8000362a:	302a8a93          	addi	s5,s5,770 # 80238928 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000362e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003630:	00235997          	auipc	s3,0x235
    80003634:	2c898993          	addi	s3,s3,712 # 802388f8 <log>
    80003638:	a00d                	j	8000365a <install_trans+0x56>
    brelse(lbuf);
    8000363a:	854a                	mv	a0,s2
    8000363c:	fffff097          	auipc	ra,0xfffff
    80003640:	07e080e7          	jalr	126(ra) # 800026ba <brelse>
    brelse(dbuf);
    80003644:	8526                	mv	a0,s1
    80003646:	fffff097          	auipc	ra,0xfffff
    8000364a:	074080e7          	jalr	116(ra) # 800026ba <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000364e:	2a05                	addiw	s4,s4,1
    80003650:	0a91                	addi	s5,s5,4
    80003652:	02c9a783          	lw	a5,44(s3)
    80003656:	04fa5e63          	bge	s4,a5,800036b2 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000365a:	0189a583          	lw	a1,24(s3)
    8000365e:	014585bb          	addw	a1,a1,s4
    80003662:	2585                	addiw	a1,a1,1
    80003664:	0289a503          	lw	a0,40(s3)
    80003668:	fffff097          	auipc	ra,0xfffff
    8000366c:	f22080e7          	jalr	-222(ra) # 8000258a <bread>
    80003670:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003672:	000aa583          	lw	a1,0(s5)
    80003676:	0289a503          	lw	a0,40(s3)
    8000367a:	fffff097          	auipc	ra,0xfffff
    8000367e:	f10080e7          	jalr	-240(ra) # 8000258a <bread>
    80003682:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003684:	40000613          	li	a2,1024
    80003688:	05890593          	addi	a1,s2,88
    8000368c:	05850513          	addi	a0,a0,88
    80003690:	ffffd097          	auipc	ra,0xffffd
    80003694:	c8a080e7          	jalr	-886(ra) # 8000031a <memmove>
    bwrite(dbuf);  // write dst to disk
    80003698:	8526                	mv	a0,s1
    8000369a:	fffff097          	auipc	ra,0xfffff
    8000369e:	fe2080e7          	jalr	-30(ra) # 8000267c <bwrite>
    if(recovering == 0)
    800036a2:	f80b1ce3          	bnez	s6,8000363a <install_trans+0x36>
      bunpin(dbuf);
    800036a6:	8526                	mv	a0,s1
    800036a8:	fffff097          	auipc	ra,0xfffff
    800036ac:	0ec080e7          	jalr	236(ra) # 80002794 <bunpin>
    800036b0:	b769                	j	8000363a <install_trans+0x36>
}
    800036b2:	70e2                	ld	ra,56(sp)
    800036b4:	7442                	ld	s0,48(sp)
    800036b6:	74a2                	ld	s1,40(sp)
    800036b8:	7902                	ld	s2,32(sp)
    800036ba:	69e2                	ld	s3,24(sp)
    800036bc:	6a42                	ld	s4,16(sp)
    800036be:	6aa2                	ld	s5,8(sp)
    800036c0:	6b02                	ld	s6,0(sp)
    800036c2:	6121                	addi	sp,sp,64
    800036c4:	8082                	ret
    800036c6:	8082                	ret

00000000800036c8 <initlog>:
{
    800036c8:	7179                	addi	sp,sp,-48
    800036ca:	f406                	sd	ra,40(sp)
    800036cc:	f022                	sd	s0,32(sp)
    800036ce:	ec26                	sd	s1,24(sp)
    800036d0:	e84a                	sd	s2,16(sp)
    800036d2:	e44e                	sd	s3,8(sp)
    800036d4:	1800                	addi	s0,sp,48
    800036d6:	892a                	mv	s2,a0
    800036d8:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800036da:	00235497          	auipc	s1,0x235
    800036de:	21e48493          	addi	s1,s1,542 # 802388f8 <log>
    800036e2:	00005597          	auipc	a1,0x5
    800036e6:	ed658593          	addi	a1,a1,-298 # 800085b8 <syscalls+0x1d8>
    800036ea:	8526                	mv	a0,s1
    800036ec:	00003097          	auipc	ra,0x3
    800036f0:	c18080e7          	jalr	-1000(ra) # 80006304 <initlock>
  log.start = sb->logstart;
    800036f4:	0149a583          	lw	a1,20(s3)
    800036f8:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800036fa:	0109a783          	lw	a5,16(s3)
    800036fe:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003700:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003704:	854a                	mv	a0,s2
    80003706:	fffff097          	auipc	ra,0xfffff
    8000370a:	e84080e7          	jalr	-380(ra) # 8000258a <bread>
  log.lh.n = lh->n;
    8000370e:	4d34                	lw	a3,88(a0)
    80003710:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003712:	02d05663          	blez	a3,8000373e <initlog+0x76>
    80003716:	05c50793          	addi	a5,a0,92
    8000371a:	00235717          	auipc	a4,0x235
    8000371e:	20e70713          	addi	a4,a4,526 # 80238928 <log+0x30>
    80003722:	36fd                	addiw	a3,a3,-1
    80003724:	02069613          	slli	a2,a3,0x20
    80003728:	01e65693          	srli	a3,a2,0x1e
    8000372c:	06050613          	addi	a2,a0,96
    80003730:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003732:	4390                	lw	a2,0(a5)
    80003734:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003736:	0791                	addi	a5,a5,4
    80003738:	0711                	addi	a4,a4,4
    8000373a:	fed79ce3          	bne	a5,a3,80003732 <initlog+0x6a>
  brelse(buf);
    8000373e:	fffff097          	auipc	ra,0xfffff
    80003742:	f7c080e7          	jalr	-132(ra) # 800026ba <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003746:	4505                	li	a0,1
    80003748:	00000097          	auipc	ra,0x0
    8000374c:	ebc080e7          	jalr	-324(ra) # 80003604 <install_trans>
  log.lh.n = 0;
    80003750:	00235797          	auipc	a5,0x235
    80003754:	1c07aa23          	sw	zero,468(a5) # 80238924 <log+0x2c>
  write_head(); // clear the log
    80003758:	00000097          	auipc	ra,0x0
    8000375c:	e30080e7          	jalr	-464(ra) # 80003588 <write_head>
}
    80003760:	70a2                	ld	ra,40(sp)
    80003762:	7402                	ld	s0,32(sp)
    80003764:	64e2                	ld	s1,24(sp)
    80003766:	6942                	ld	s2,16(sp)
    80003768:	69a2                	ld	s3,8(sp)
    8000376a:	6145                	addi	sp,sp,48
    8000376c:	8082                	ret

000000008000376e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000376e:	1101                	addi	sp,sp,-32
    80003770:	ec06                	sd	ra,24(sp)
    80003772:	e822                	sd	s0,16(sp)
    80003774:	e426                	sd	s1,8(sp)
    80003776:	e04a                	sd	s2,0(sp)
    80003778:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000377a:	00235517          	auipc	a0,0x235
    8000377e:	17e50513          	addi	a0,a0,382 # 802388f8 <log>
    80003782:	00003097          	auipc	ra,0x3
    80003786:	c12080e7          	jalr	-1006(ra) # 80006394 <acquire>
  while(1){
    if(log.committing){
    8000378a:	00235497          	auipc	s1,0x235
    8000378e:	16e48493          	addi	s1,s1,366 # 802388f8 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003792:	4979                	li	s2,30
    80003794:	a039                	j	800037a2 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003796:	85a6                	mv	a1,s1
    80003798:	8526                	mv	a0,s1
    8000379a:	ffffe097          	auipc	ra,0xffffe
    8000379e:	ebc080e7          	jalr	-324(ra) # 80001656 <sleep>
    if(log.committing){
    800037a2:	50dc                	lw	a5,36(s1)
    800037a4:	fbed                	bnez	a5,80003796 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800037a6:	5098                	lw	a4,32(s1)
    800037a8:	2705                	addiw	a4,a4,1
    800037aa:	0007069b          	sext.w	a3,a4
    800037ae:	0027179b          	slliw	a5,a4,0x2
    800037b2:	9fb9                	addw	a5,a5,a4
    800037b4:	0017979b          	slliw	a5,a5,0x1
    800037b8:	54d8                	lw	a4,44(s1)
    800037ba:	9fb9                	addw	a5,a5,a4
    800037bc:	00f95963          	bge	s2,a5,800037ce <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800037c0:	85a6                	mv	a1,s1
    800037c2:	8526                	mv	a0,s1
    800037c4:	ffffe097          	auipc	ra,0xffffe
    800037c8:	e92080e7          	jalr	-366(ra) # 80001656 <sleep>
    800037cc:	bfd9                	j	800037a2 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800037ce:	00235517          	auipc	a0,0x235
    800037d2:	12a50513          	addi	a0,a0,298 # 802388f8 <log>
    800037d6:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800037d8:	00003097          	auipc	ra,0x3
    800037dc:	c70080e7          	jalr	-912(ra) # 80006448 <release>
      break;
    }
  }
}
    800037e0:	60e2                	ld	ra,24(sp)
    800037e2:	6442                	ld	s0,16(sp)
    800037e4:	64a2                	ld	s1,8(sp)
    800037e6:	6902                	ld	s2,0(sp)
    800037e8:	6105                	addi	sp,sp,32
    800037ea:	8082                	ret

00000000800037ec <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800037ec:	7139                	addi	sp,sp,-64
    800037ee:	fc06                	sd	ra,56(sp)
    800037f0:	f822                	sd	s0,48(sp)
    800037f2:	f426                	sd	s1,40(sp)
    800037f4:	f04a                	sd	s2,32(sp)
    800037f6:	ec4e                	sd	s3,24(sp)
    800037f8:	e852                	sd	s4,16(sp)
    800037fa:	e456                	sd	s5,8(sp)
    800037fc:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800037fe:	00235497          	auipc	s1,0x235
    80003802:	0fa48493          	addi	s1,s1,250 # 802388f8 <log>
    80003806:	8526                	mv	a0,s1
    80003808:	00003097          	auipc	ra,0x3
    8000380c:	b8c080e7          	jalr	-1140(ra) # 80006394 <acquire>
  log.outstanding -= 1;
    80003810:	509c                	lw	a5,32(s1)
    80003812:	37fd                	addiw	a5,a5,-1
    80003814:	0007891b          	sext.w	s2,a5
    80003818:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000381a:	50dc                	lw	a5,36(s1)
    8000381c:	e7b9                	bnez	a5,8000386a <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000381e:	04091e63          	bnez	s2,8000387a <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003822:	00235497          	auipc	s1,0x235
    80003826:	0d648493          	addi	s1,s1,214 # 802388f8 <log>
    8000382a:	4785                	li	a5,1
    8000382c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000382e:	8526                	mv	a0,s1
    80003830:	00003097          	auipc	ra,0x3
    80003834:	c18080e7          	jalr	-1000(ra) # 80006448 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003838:	54dc                	lw	a5,44(s1)
    8000383a:	06f04763          	bgtz	a5,800038a8 <end_op+0xbc>
    acquire(&log.lock);
    8000383e:	00235497          	auipc	s1,0x235
    80003842:	0ba48493          	addi	s1,s1,186 # 802388f8 <log>
    80003846:	8526                	mv	a0,s1
    80003848:	00003097          	auipc	ra,0x3
    8000384c:	b4c080e7          	jalr	-1204(ra) # 80006394 <acquire>
    log.committing = 0;
    80003850:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003854:	8526                	mv	a0,s1
    80003856:	ffffe097          	auipc	ra,0xffffe
    8000385a:	e64080e7          	jalr	-412(ra) # 800016ba <wakeup>
    release(&log.lock);
    8000385e:	8526                	mv	a0,s1
    80003860:	00003097          	auipc	ra,0x3
    80003864:	be8080e7          	jalr	-1048(ra) # 80006448 <release>
}
    80003868:	a03d                	j	80003896 <end_op+0xaa>
    panic("log.committing");
    8000386a:	00005517          	auipc	a0,0x5
    8000386e:	d5650513          	addi	a0,a0,-682 # 800085c0 <syscalls+0x1e0>
    80003872:	00002097          	auipc	ra,0x2
    80003876:	5ea080e7          	jalr	1514(ra) # 80005e5c <panic>
    wakeup(&log);
    8000387a:	00235497          	auipc	s1,0x235
    8000387e:	07e48493          	addi	s1,s1,126 # 802388f8 <log>
    80003882:	8526                	mv	a0,s1
    80003884:	ffffe097          	auipc	ra,0xffffe
    80003888:	e36080e7          	jalr	-458(ra) # 800016ba <wakeup>
  release(&log.lock);
    8000388c:	8526                	mv	a0,s1
    8000388e:	00003097          	auipc	ra,0x3
    80003892:	bba080e7          	jalr	-1094(ra) # 80006448 <release>
}
    80003896:	70e2                	ld	ra,56(sp)
    80003898:	7442                	ld	s0,48(sp)
    8000389a:	74a2                	ld	s1,40(sp)
    8000389c:	7902                	ld	s2,32(sp)
    8000389e:	69e2                	ld	s3,24(sp)
    800038a0:	6a42                	ld	s4,16(sp)
    800038a2:	6aa2                	ld	s5,8(sp)
    800038a4:	6121                	addi	sp,sp,64
    800038a6:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800038a8:	00235a97          	auipc	s5,0x235
    800038ac:	080a8a93          	addi	s5,s5,128 # 80238928 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800038b0:	00235a17          	auipc	s4,0x235
    800038b4:	048a0a13          	addi	s4,s4,72 # 802388f8 <log>
    800038b8:	018a2583          	lw	a1,24(s4)
    800038bc:	012585bb          	addw	a1,a1,s2
    800038c0:	2585                	addiw	a1,a1,1
    800038c2:	028a2503          	lw	a0,40(s4)
    800038c6:	fffff097          	auipc	ra,0xfffff
    800038ca:	cc4080e7          	jalr	-828(ra) # 8000258a <bread>
    800038ce:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800038d0:	000aa583          	lw	a1,0(s5)
    800038d4:	028a2503          	lw	a0,40(s4)
    800038d8:	fffff097          	auipc	ra,0xfffff
    800038dc:	cb2080e7          	jalr	-846(ra) # 8000258a <bread>
    800038e0:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800038e2:	40000613          	li	a2,1024
    800038e6:	05850593          	addi	a1,a0,88
    800038ea:	05848513          	addi	a0,s1,88
    800038ee:	ffffd097          	auipc	ra,0xffffd
    800038f2:	a2c080e7          	jalr	-1492(ra) # 8000031a <memmove>
    bwrite(to);  // write the log
    800038f6:	8526                	mv	a0,s1
    800038f8:	fffff097          	auipc	ra,0xfffff
    800038fc:	d84080e7          	jalr	-636(ra) # 8000267c <bwrite>
    brelse(from);
    80003900:	854e                	mv	a0,s3
    80003902:	fffff097          	auipc	ra,0xfffff
    80003906:	db8080e7          	jalr	-584(ra) # 800026ba <brelse>
    brelse(to);
    8000390a:	8526                	mv	a0,s1
    8000390c:	fffff097          	auipc	ra,0xfffff
    80003910:	dae080e7          	jalr	-594(ra) # 800026ba <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003914:	2905                	addiw	s2,s2,1
    80003916:	0a91                	addi	s5,s5,4
    80003918:	02ca2783          	lw	a5,44(s4)
    8000391c:	f8f94ee3          	blt	s2,a5,800038b8 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003920:	00000097          	auipc	ra,0x0
    80003924:	c68080e7          	jalr	-920(ra) # 80003588 <write_head>
    install_trans(0); // Now install writes to home locations
    80003928:	4501                	li	a0,0
    8000392a:	00000097          	auipc	ra,0x0
    8000392e:	cda080e7          	jalr	-806(ra) # 80003604 <install_trans>
    log.lh.n = 0;
    80003932:	00235797          	auipc	a5,0x235
    80003936:	fe07a923          	sw	zero,-14(a5) # 80238924 <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000393a:	00000097          	auipc	ra,0x0
    8000393e:	c4e080e7          	jalr	-946(ra) # 80003588 <write_head>
    80003942:	bdf5                	j	8000383e <end_op+0x52>

0000000080003944 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003944:	1101                	addi	sp,sp,-32
    80003946:	ec06                	sd	ra,24(sp)
    80003948:	e822                	sd	s0,16(sp)
    8000394a:	e426                	sd	s1,8(sp)
    8000394c:	e04a                	sd	s2,0(sp)
    8000394e:	1000                	addi	s0,sp,32
    80003950:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003952:	00235917          	auipc	s2,0x235
    80003956:	fa690913          	addi	s2,s2,-90 # 802388f8 <log>
    8000395a:	854a                	mv	a0,s2
    8000395c:	00003097          	auipc	ra,0x3
    80003960:	a38080e7          	jalr	-1480(ra) # 80006394 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003964:	02c92603          	lw	a2,44(s2)
    80003968:	47f5                	li	a5,29
    8000396a:	06c7c563          	blt	a5,a2,800039d4 <log_write+0x90>
    8000396e:	00235797          	auipc	a5,0x235
    80003972:	fa67a783          	lw	a5,-90(a5) # 80238914 <log+0x1c>
    80003976:	37fd                	addiw	a5,a5,-1
    80003978:	04f65e63          	bge	a2,a5,800039d4 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000397c:	00235797          	auipc	a5,0x235
    80003980:	f9c7a783          	lw	a5,-100(a5) # 80238918 <log+0x20>
    80003984:	06f05063          	blez	a5,800039e4 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003988:	4781                	li	a5,0
    8000398a:	06c05563          	blez	a2,800039f4 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000398e:	44cc                	lw	a1,12(s1)
    80003990:	00235717          	auipc	a4,0x235
    80003994:	f9870713          	addi	a4,a4,-104 # 80238928 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003998:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000399a:	4314                	lw	a3,0(a4)
    8000399c:	04b68c63          	beq	a3,a1,800039f4 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800039a0:	2785                	addiw	a5,a5,1
    800039a2:	0711                	addi	a4,a4,4
    800039a4:	fef61be3          	bne	a2,a5,8000399a <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800039a8:	0621                	addi	a2,a2,8
    800039aa:	060a                	slli	a2,a2,0x2
    800039ac:	00235797          	auipc	a5,0x235
    800039b0:	f4c78793          	addi	a5,a5,-180 # 802388f8 <log>
    800039b4:	97b2                	add	a5,a5,a2
    800039b6:	44d8                	lw	a4,12(s1)
    800039b8:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800039ba:	8526                	mv	a0,s1
    800039bc:	fffff097          	auipc	ra,0xfffff
    800039c0:	d9c080e7          	jalr	-612(ra) # 80002758 <bpin>
    log.lh.n++;
    800039c4:	00235717          	auipc	a4,0x235
    800039c8:	f3470713          	addi	a4,a4,-204 # 802388f8 <log>
    800039cc:	575c                	lw	a5,44(a4)
    800039ce:	2785                	addiw	a5,a5,1
    800039d0:	d75c                	sw	a5,44(a4)
    800039d2:	a82d                	j	80003a0c <log_write+0xc8>
    panic("too big a transaction");
    800039d4:	00005517          	auipc	a0,0x5
    800039d8:	bfc50513          	addi	a0,a0,-1028 # 800085d0 <syscalls+0x1f0>
    800039dc:	00002097          	auipc	ra,0x2
    800039e0:	480080e7          	jalr	1152(ra) # 80005e5c <panic>
    panic("log_write outside of trans");
    800039e4:	00005517          	auipc	a0,0x5
    800039e8:	c0450513          	addi	a0,a0,-1020 # 800085e8 <syscalls+0x208>
    800039ec:	00002097          	auipc	ra,0x2
    800039f0:	470080e7          	jalr	1136(ra) # 80005e5c <panic>
  log.lh.block[i] = b->blockno;
    800039f4:	00878693          	addi	a3,a5,8
    800039f8:	068a                	slli	a3,a3,0x2
    800039fa:	00235717          	auipc	a4,0x235
    800039fe:	efe70713          	addi	a4,a4,-258 # 802388f8 <log>
    80003a02:	9736                	add	a4,a4,a3
    80003a04:	44d4                	lw	a3,12(s1)
    80003a06:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003a08:	faf609e3          	beq	a2,a5,800039ba <log_write+0x76>
  }
  release(&log.lock);
    80003a0c:	00235517          	auipc	a0,0x235
    80003a10:	eec50513          	addi	a0,a0,-276 # 802388f8 <log>
    80003a14:	00003097          	auipc	ra,0x3
    80003a18:	a34080e7          	jalr	-1484(ra) # 80006448 <release>
}
    80003a1c:	60e2                	ld	ra,24(sp)
    80003a1e:	6442                	ld	s0,16(sp)
    80003a20:	64a2                	ld	s1,8(sp)
    80003a22:	6902                	ld	s2,0(sp)
    80003a24:	6105                	addi	sp,sp,32
    80003a26:	8082                	ret

0000000080003a28 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003a28:	1101                	addi	sp,sp,-32
    80003a2a:	ec06                	sd	ra,24(sp)
    80003a2c:	e822                	sd	s0,16(sp)
    80003a2e:	e426                	sd	s1,8(sp)
    80003a30:	e04a                	sd	s2,0(sp)
    80003a32:	1000                	addi	s0,sp,32
    80003a34:	84aa                	mv	s1,a0
    80003a36:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a38:	00005597          	auipc	a1,0x5
    80003a3c:	bd058593          	addi	a1,a1,-1072 # 80008608 <syscalls+0x228>
    80003a40:	0521                	addi	a0,a0,8
    80003a42:	00003097          	auipc	ra,0x3
    80003a46:	8c2080e7          	jalr	-1854(ra) # 80006304 <initlock>
  lk->name = name;
    80003a4a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003a4e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a52:	0204a423          	sw	zero,40(s1)
}
    80003a56:	60e2                	ld	ra,24(sp)
    80003a58:	6442                	ld	s0,16(sp)
    80003a5a:	64a2                	ld	s1,8(sp)
    80003a5c:	6902                	ld	s2,0(sp)
    80003a5e:	6105                	addi	sp,sp,32
    80003a60:	8082                	ret

0000000080003a62 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003a62:	1101                	addi	sp,sp,-32
    80003a64:	ec06                	sd	ra,24(sp)
    80003a66:	e822                	sd	s0,16(sp)
    80003a68:	e426                	sd	s1,8(sp)
    80003a6a:	e04a                	sd	s2,0(sp)
    80003a6c:	1000                	addi	s0,sp,32
    80003a6e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a70:	00850913          	addi	s2,a0,8
    80003a74:	854a                	mv	a0,s2
    80003a76:	00003097          	auipc	ra,0x3
    80003a7a:	91e080e7          	jalr	-1762(ra) # 80006394 <acquire>
  while (lk->locked) {
    80003a7e:	409c                	lw	a5,0(s1)
    80003a80:	cb89                	beqz	a5,80003a92 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a82:	85ca                	mv	a1,s2
    80003a84:	8526                	mv	a0,s1
    80003a86:	ffffe097          	auipc	ra,0xffffe
    80003a8a:	bd0080e7          	jalr	-1072(ra) # 80001656 <sleep>
  while (lk->locked) {
    80003a8e:	409c                	lw	a5,0(s1)
    80003a90:	fbed                	bnez	a5,80003a82 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a92:	4785                	li	a5,1
    80003a94:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a96:	ffffd097          	auipc	ra,0xffffd
    80003a9a:	518080e7          	jalr	1304(ra) # 80000fae <myproc>
    80003a9e:	591c                	lw	a5,48(a0)
    80003aa0:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003aa2:	854a                	mv	a0,s2
    80003aa4:	00003097          	auipc	ra,0x3
    80003aa8:	9a4080e7          	jalr	-1628(ra) # 80006448 <release>
}
    80003aac:	60e2                	ld	ra,24(sp)
    80003aae:	6442                	ld	s0,16(sp)
    80003ab0:	64a2                	ld	s1,8(sp)
    80003ab2:	6902                	ld	s2,0(sp)
    80003ab4:	6105                	addi	sp,sp,32
    80003ab6:	8082                	ret

0000000080003ab8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003ab8:	1101                	addi	sp,sp,-32
    80003aba:	ec06                	sd	ra,24(sp)
    80003abc:	e822                	sd	s0,16(sp)
    80003abe:	e426                	sd	s1,8(sp)
    80003ac0:	e04a                	sd	s2,0(sp)
    80003ac2:	1000                	addi	s0,sp,32
    80003ac4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003ac6:	00850913          	addi	s2,a0,8
    80003aca:	854a                	mv	a0,s2
    80003acc:	00003097          	auipc	ra,0x3
    80003ad0:	8c8080e7          	jalr	-1848(ra) # 80006394 <acquire>
  lk->locked = 0;
    80003ad4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003ad8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003adc:	8526                	mv	a0,s1
    80003ade:	ffffe097          	auipc	ra,0xffffe
    80003ae2:	bdc080e7          	jalr	-1060(ra) # 800016ba <wakeup>
  release(&lk->lk);
    80003ae6:	854a                	mv	a0,s2
    80003ae8:	00003097          	auipc	ra,0x3
    80003aec:	960080e7          	jalr	-1696(ra) # 80006448 <release>
}
    80003af0:	60e2                	ld	ra,24(sp)
    80003af2:	6442                	ld	s0,16(sp)
    80003af4:	64a2                	ld	s1,8(sp)
    80003af6:	6902                	ld	s2,0(sp)
    80003af8:	6105                	addi	sp,sp,32
    80003afa:	8082                	ret

0000000080003afc <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003afc:	7179                	addi	sp,sp,-48
    80003afe:	f406                	sd	ra,40(sp)
    80003b00:	f022                	sd	s0,32(sp)
    80003b02:	ec26                	sd	s1,24(sp)
    80003b04:	e84a                	sd	s2,16(sp)
    80003b06:	e44e                	sd	s3,8(sp)
    80003b08:	1800                	addi	s0,sp,48
    80003b0a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003b0c:	00850913          	addi	s2,a0,8
    80003b10:	854a                	mv	a0,s2
    80003b12:	00003097          	auipc	ra,0x3
    80003b16:	882080e7          	jalr	-1918(ra) # 80006394 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b1a:	409c                	lw	a5,0(s1)
    80003b1c:	ef99                	bnez	a5,80003b3a <holdingsleep+0x3e>
    80003b1e:	4481                	li	s1,0
  release(&lk->lk);
    80003b20:	854a                	mv	a0,s2
    80003b22:	00003097          	auipc	ra,0x3
    80003b26:	926080e7          	jalr	-1754(ra) # 80006448 <release>
  return r;
}
    80003b2a:	8526                	mv	a0,s1
    80003b2c:	70a2                	ld	ra,40(sp)
    80003b2e:	7402                	ld	s0,32(sp)
    80003b30:	64e2                	ld	s1,24(sp)
    80003b32:	6942                	ld	s2,16(sp)
    80003b34:	69a2                	ld	s3,8(sp)
    80003b36:	6145                	addi	sp,sp,48
    80003b38:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b3a:	0284a983          	lw	s3,40(s1)
    80003b3e:	ffffd097          	auipc	ra,0xffffd
    80003b42:	470080e7          	jalr	1136(ra) # 80000fae <myproc>
    80003b46:	5904                	lw	s1,48(a0)
    80003b48:	413484b3          	sub	s1,s1,s3
    80003b4c:	0014b493          	seqz	s1,s1
    80003b50:	bfc1                	j	80003b20 <holdingsleep+0x24>

0000000080003b52 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b52:	1141                	addi	sp,sp,-16
    80003b54:	e406                	sd	ra,8(sp)
    80003b56:	e022                	sd	s0,0(sp)
    80003b58:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b5a:	00005597          	auipc	a1,0x5
    80003b5e:	abe58593          	addi	a1,a1,-1346 # 80008618 <syscalls+0x238>
    80003b62:	00235517          	auipc	a0,0x235
    80003b66:	ede50513          	addi	a0,a0,-290 # 80238a40 <ftable>
    80003b6a:	00002097          	auipc	ra,0x2
    80003b6e:	79a080e7          	jalr	1946(ra) # 80006304 <initlock>
}
    80003b72:	60a2                	ld	ra,8(sp)
    80003b74:	6402                	ld	s0,0(sp)
    80003b76:	0141                	addi	sp,sp,16
    80003b78:	8082                	ret

0000000080003b7a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b7a:	1101                	addi	sp,sp,-32
    80003b7c:	ec06                	sd	ra,24(sp)
    80003b7e:	e822                	sd	s0,16(sp)
    80003b80:	e426                	sd	s1,8(sp)
    80003b82:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b84:	00235517          	auipc	a0,0x235
    80003b88:	ebc50513          	addi	a0,a0,-324 # 80238a40 <ftable>
    80003b8c:	00003097          	auipc	ra,0x3
    80003b90:	808080e7          	jalr	-2040(ra) # 80006394 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b94:	00235497          	auipc	s1,0x235
    80003b98:	ec448493          	addi	s1,s1,-316 # 80238a58 <ftable+0x18>
    80003b9c:	00236717          	auipc	a4,0x236
    80003ba0:	e5c70713          	addi	a4,a4,-420 # 802399f8 <disk>
    if(f->ref == 0){
    80003ba4:	40dc                	lw	a5,4(s1)
    80003ba6:	cf99                	beqz	a5,80003bc4 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ba8:	02848493          	addi	s1,s1,40
    80003bac:	fee49ce3          	bne	s1,a4,80003ba4 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003bb0:	00235517          	auipc	a0,0x235
    80003bb4:	e9050513          	addi	a0,a0,-368 # 80238a40 <ftable>
    80003bb8:	00003097          	auipc	ra,0x3
    80003bbc:	890080e7          	jalr	-1904(ra) # 80006448 <release>
  return 0;
    80003bc0:	4481                	li	s1,0
    80003bc2:	a819                	j	80003bd8 <filealloc+0x5e>
      f->ref = 1;
    80003bc4:	4785                	li	a5,1
    80003bc6:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003bc8:	00235517          	auipc	a0,0x235
    80003bcc:	e7850513          	addi	a0,a0,-392 # 80238a40 <ftable>
    80003bd0:	00003097          	auipc	ra,0x3
    80003bd4:	878080e7          	jalr	-1928(ra) # 80006448 <release>
}
    80003bd8:	8526                	mv	a0,s1
    80003bda:	60e2                	ld	ra,24(sp)
    80003bdc:	6442                	ld	s0,16(sp)
    80003bde:	64a2                	ld	s1,8(sp)
    80003be0:	6105                	addi	sp,sp,32
    80003be2:	8082                	ret

0000000080003be4 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003be4:	1101                	addi	sp,sp,-32
    80003be6:	ec06                	sd	ra,24(sp)
    80003be8:	e822                	sd	s0,16(sp)
    80003bea:	e426                	sd	s1,8(sp)
    80003bec:	1000                	addi	s0,sp,32
    80003bee:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003bf0:	00235517          	auipc	a0,0x235
    80003bf4:	e5050513          	addi	a0,a0,-432 # 80238a40 <ftable>
    80003bf8:	00002097          	auipc	ra,0x2
    80003bfc:	79c080e7          	jalr	1948(ra) # 80006394 <acquire>
  if(f->ref < 1)
    80003c00:	40dc                	lw	a5,4(s1)
    80003c02:	02f05263          	blez	a5,80003c26 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003c06:	2785                	addiw	a5,a5,1
    80003c08:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003c0a:	00235517          	auipc	a0,0x235
    80003c0e:	e3650513          	addi	a0,a0,-458 # 80238a40 <ftable>
    80003c12:	00003097          	auipc	ra,0x3
    80003c16:	836080e7          	jalr	-1994(ra) # 80006448 <release>
  return f;
}
    80003c1a:	8526                	mv	a0,s1
    80003c1c:	60e2                	ld	ra,24(sp)
    80003c1e:	6442                	ld	s0,16(sp)
    80003c20:	64a2                	ld	s1,8(sp)
    80003c22:	6105                	addi	sp,sp,32
    80003c24:	8082                	ret
    panic("filedup");
    80003c26:	00005517          	auipc	a0,0x5
    80003c2a:	9fa50513          	addi	a0,a0,-1542 # 80008620 <syscalls+0x240>
    80003c2e:	00002097          	auipc	ra,0x2
    80003c32:	22e080e7          	jalr	558(ra) # 80005e5c <panic>

0000000080003c36 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003c36:	7139                	addi	sp,sp,-64
    80003c38:	fc06                	sd	ra,56(sp)
    80003c3a:	f822                	sd	s0,48(sp)
    80003c3c:	f426                	sd	s1,40(sp)
    80003c3e:	f04a                	sd	s2,32(sp)
    80003c40:	ec4e                	sd	s3,24(sp)
    80003c42:	e852                	sd	s4,16(sp)
    80003c44:	e456                	sd	s5,8(sp)
    80003c46:	0080                	addi	s0,sp,64
    80003c48:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c4a:	00235517          	auipc	a0,0x235
    80003c4e:	df650513          	addi	a0,a0,-522 # 80238a40 <ftable>
    80003c52:	00002097          	auipc	ra,0x2
    80003c56:	742080e7          	jalr	1858(ra) # 80006394 <acquire>
  if(f->ref < 1)
    80003c5a:	40dc                	lw	a5,4(s1)
    80003c5c:	06f05163          	blez	a5,80003cbe <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003c60:	37fd                	addiw	a5,a5,-1
    80003c62:	0007871b          	sext.w	a4,a5
    80003c66:	c0dc                	sw	a5,4(s1)
    80003c68:	06e04363          	bgtz	a4,80003cce <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c6c:	0004a903          	lw	s2,0(s1)
    80003c70:	0094ca83          	lbu	s5,9(s1)
    80003c74:	0104ba03          	ld	s4,16(s1)
    80003c78:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c7c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c80:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c84:	00235517          	auipc	a0,0x235
    80003c88:	dbc50513          	addi	a0,a0,-580 # 80238a40 <ftable>
    80003c8c:	00002097          	auipc	ra,0x2
    80003c90:	7bc080e7          	jalr	1980(ra) # 80006448 <release>

  if(ff.type == FD_PIPE){
    80003c94:	4785                	li	a5,1
    80003c96:	04f90d63          	beq	s2,a5,80003cf0 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c9a:	3979                	addiw	s2,s2,-2
    80003c9c:	4785                	li	a5,1
    80003c9e:	0527e063          	bltu	a5,s2,80003cde <fileclose+0xa8>
    begin_op();
    80003ca2:	00000097          	auipc	ra,0x0
    80003ca6:	acc080e7          	jalr	-1332(ra) # 8000376e <begin_op>
    iput(ff.ip);
    80003caa:	854e                	mv	a0,s3
    80003cac:	fffff097          	auipc	ra,0xfffff
    80003cb0:	2b0080e7          	jalr	688(ra) # 80002f5c <iput>
    end_op();
    80003cb4:	00000097          	auipc	ra,0x0
    80003cb8:	b38080e7          	jalr	-1224(ra) # 800037ec <end_op>
    80003cbc:	a00d                	j	80003cde <fileclose+0xa8>
    panic("fileclose");
    80003cbe:	00005517          	auipc	a0,0x5
    80003cc2:	96a50513          	addi	a0,a0,-1686 # 80008628 <syscalls+0x248>
    80003cc6:	00002097          	auipc	ra,0x2
    80003cca:	196080e7          	jalr	406(ra) # 80005e5c <panic>
    release(&ftable.lock);
    80003cce:	00235517          	auipc	a0,0x235
    80003cd2:	d7250513          	addi	a0,a0,-654 # 80238a40 <ftable>
    80003cd6:	00002097          	auipc	ra,0x2
    80003cda:	772080e7          	jalr	1906(ra) # 80006448 <release>
  }
}
    80003cde:	70e2                	ld	ra,56(sp)
    80003ce0:	7442                	ld	s0,48(sp)
    80003ce2:	74a2                	ld	s1,40(sp)
    80003ce4:	7902                	ld	s2,32(sp)
    80003ce6:	69e2                	ld	s3,24(sp)
    80003ce8:	6a42                	ld	s4,16(sp)
    80003cea:	6aa2                	ld	s5,8(sp)
    80003cec:	6121                	addi	sp,sp,64
    80003cee:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003cf0:	85d6                	mv	a1,s5
    80003cf2:	8552                	mv	a0,s4
    80003cf4:	00000097          	auipc	ra,0x0
    80003cf8:	34c080e7          	jalr	844(ra) # 80004040 <pipeclose>
    80003cfc:	b7cd                	j	80003cde <fileclose+0xa8>

0000000080003cfe <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003cfe:	715d                	addi	sp,sp,-80
    80003d00:	e486                	sd	ra,72(sp)
    80003d02:	e0a2                	sd	s0,64(sp)
    80003d04:	fc26                	sd	s1,56(sp)
    80003d06:	f84a                	sd	s2,48(sp)
    80003d08:	f44e                	sd	s3,40(sp)
    80003d0a:	0880                	addi	s0,sp,80
    80003d0c:	84aa                	mv	s1,a0
    80003d0e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003d10:	ffffd097          	auipc	ra,0xffffd
    80003d14:	29e080e7          	jalr	670(ra) # 80000fae <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003d18:	409c                	lw	a5,0(s1)
    80003d1a:	37f9                	addiw	a5,a5,-2
    80003d1c:	4705                	li	a4,1
    80003d1e:	04f76763          	bltu	a4,a5,80003d6c <filestat+0x6e>
    80003d22:	892a                	mv	s2,a0
    ilock(f->ip);
    80003d24:	6c88                	ld	a0,24(s1)
    80003d26:	fffff097          	auipc	ra,0xfffff
    80003d2a:	07c080e7          	jalr	124(ra) # 80002da2 <ilock>
    stati(f->ip, &st);
    80003d2e:	fb840593          	addi	a1,s0,-72
    80003d32:	6c88                	ld	a0,24(s1)
    80003d34:	fffff097          	auipc	ra,0xfffff
    80003d38:	2f8080e7          	jalr	760(ra) # 8000302c <stati>
    iunlock(f->ip);
    80003d3c:	6c88                	ld	a0,24(s1)
    80003d3e:	fffff097          	auipc	ra,0xfffff
    80003d42:	126080e7          	jalr	294(ra) # 80002e64 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d46:	46e1                	li	a3,24
    80003d48:	fb840613          	addi	a2,s0,-72
    80003d4c:	85ce                	mv	a1,s3
    80003d4e:	05093503          	ld	a0,80(s2)
    80003d52:	ffffd097          	auipc	ra,0xffffd
    80003d56:	eee080e7          	jalr	-274(ra) # 80000c40 <copyout>
    80003d5a:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003d5e:	60a6                	ld	ra,72(sp)
    80003d60:	6406                	ld	s0,64(sp)
    80003d62:	74e2                	ld	s1,56(sp)
    80003d64:	7942                	ld	s2,48(sp)
    80003d66:	79a2                	ld	s3,40(sp)
    80003d68:	6161                	addi	sp,sp,80
    80003d6a:	8082                	ret
  return -1;
    80003d6c:	557d                	li	a0,-1
    80003d6e:	bfc5                	j	80003d5e <filestat+0x60>

0000000080003d70 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d70:	7179                	addi	sp,sp,-48
    80003d72:	f406                	sd	ra,40(sp)
    80003d74:	f022                	sd	s0,32(sp)
    80003d76:	ec26                	sd	s1,24(sp)
    80003d78:	e84a                	sd	s2,16(sp)
    80003d7a:	e44e                	sd	s3,8(sp)
    80003d7c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d7e:	00854783          	lbu	a5,8(a0)
    80003d82:	c3d5                	beqz	a5,80003e26 <fileread+0xb6>
    80003d84:	84aa                	mv	s1,a0
    80003d86:	89ae                	mv	s3,a1
    80003d88:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d8a:	411c                	lw	a5,0(a0)
    80003d8c:	4705                	li	a4,1
    80003d8e:	04e78963          	beq	a5,a4,80003de0 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d92:	470d                	li	a4,3
    80003d94:	04e78d63          	beq	a5,a4,80003dee <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d98:	4709                	li	a4,2
    80003d9a:	06e79e63          	bne	a5,a4,80003e16 <fileread+0xa6>
    ilock(f->ip);
    80003d9e:	6d08                	ld	a0,24(a0)
    80003da0:	fffff097          	auipc	ra,0xfffff
    80003da4:	002080e7          	jalr	2(ra) # 80002da2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003da8:	874a                	mv	a4,s2
    80003daa:	5094                	lw	a3,32(s1)
    80003dac:	864e                	mv	a2,s3
    80003dae:	4585                	li	a1,1
    80003db0:	6c88                	ld	a0,24(s1)
    80003db2:	fffff097          	auipc	ra,0xfffff
    80003db6:	2a4080e7          	jalr	676(ra) # 80003056 <readi>
    80003dba:	892a                	mv	s2,a0
    80003dbc:	00a05563          	blez	a0,80003dc6 <fileread+0x56>
      f->off += r;
    80003dc0:	509c                	lw	a5,32(s1)
    80003dc2:	9fa9                	addw	a5,a5,a0
    80003dc4:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003dc6:	6c88                	ld	a0,24(s1)
    80003dc8:	fffff097          	auipc	ra,0xfffff
    80003dcc:	09c080e7          	jalr	156(ra) # 80002e64 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003dd0:	854a                	mv	a0,s2
    80003dd2:	70a2                	ld	ra,40(sp)
    80003dd4:	7402                	ld	s0,32(sp)
    80003dd6:	64e2                	ld	s1,24(sp)
    80003dd8:	6942                	ld	s2,16(sp)
    80003dda:	69a2                	ld	s3,8(sp)
    80003ddc:	6145                	addi	sp,sp,48
    80003dde:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003de0:	6908                	ld	a0,16(a0)
    80003de2:	00000097          	auipc	ra,0x0
    80003de6:	3c6080e7          	jalr	966(ra) # 800041a8 <piperead>
    80003dea:	892a                	mv	s2,a0
    80003dec:	b7d5                	j	80003dd0 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003dee:	02451783          	lh	a5,36(a0)
    80003df2:	03079693          	slli	a3,a5,0x30
    80003df6:	92c1                	srli	a3,a3,0x30
    80003df8:	4725                	li	a4,9
    80003dfa:	02d76863          	bltu	a4,a3,80003e2a <fileread+0xba>
    80003dfe:	0792                	slli	a5,a5,0x4
    80003e00:	00235717          	auipc	a4,0x235
    80003e04:	ba070713          	addi	a4,a4,-1120 # 802389a0 <devsw>
    80003e08:	97ba                	add	a5,a5,a4
    80003e0a:	639c                	ld	a5,0(a5)
    80003e0c:	c38d                	beqz	a5,80003e2e <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003e0e:	4505                	li	a0,1
    80003e10:	9782                	jalr	a5
    80003e12:	892a                	mv	s2,a0
    80003e14:	bf75                	j	80003dd0 <fileread+0x60>
    panic("fileread");
    80003e16:	00005517          	auipc	a0,0x5
    80003e1a:	82250513          	addi	a0,a0,-2014 # 80008638 <syscalls+0x258>
    80003e1e:	00002097          	auipc	ra,0x2
    80003e22:	03e080e7          	jalr	62(ra) # 80005e5c <panic>
    return -1;
    80003e26:	597d                	li	s2,-1
    80003e28:	b765                	j	80003dd0 <fileread+0x60>
      return -1;
    80003e2a:	597d                	li	s2,-1
    80003e2c:	b755                	j	80003dd0 <fileread+0x60>
    80003e2e:	597d                	li	s2,-1
    80003e30:	b745                	j	80003dd0 <fileread+0x60>

0000000080003e32 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003e32:	715d                	addi	sp,sp,-80
    80003e34:	e486                	sd	ra,72(sp)
    80003e36:	e0a2                	sd	s0,64(sp)
    80003e38:	fc26                	sd	s1,56(sp)
    80003e3a:	f84a                	sd	s2,48(sp)
    80003e3c:	f44e                	sd	s3,40(sp)
    80003e3e:	f052                	sd	s4,32(sp)
    80003e40:	ec56                	sd	s5,24(sp)
    80003e42:	e85a                	sd	s6,16(sp)
    80003e44:	e45e                	sd	s7,8(sp)
    80003e46:	e062                	sd	s8,0(sp)
    80003e48:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003e4a:	00954783          	lbu	a5,9(a0)
    80003e4e:	10078663          	beqz	a5,80003f5a <filewrite+0x128>
    80003e52:	892a                	mv	s2,a0
    80003e54:	8b2e                	mv	s6,a1
    80003e56:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e58:	411c                	lw	a5,0(a0)
    80003e5a:	4705                	li	a4,1
    80003e5c:	02e78263          	beq	a5,a4,80003e80 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e60:	470d                	li	a4,3
    80003e62:	02e78663          	beq	a5,a4,80003e8e <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e66:	4709                	li	a4,2
    80003e68:	0ee79163          	bne	a5,a4,80003f4a <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e6c:	0ac05d63          	blez	a2,80003f26 <filewrite+0xf4>
    int i = 0;
    80003e70:	4981                	li	s3,0
    80003e72:	6b85                	lui	s7,0x1
    80003e74:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003e78:	6c05                	lui	s8,0x1
    80003e7a:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003e7e:	a861                	j	80003f16 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003e80:	6908                	ld	a0,16(a0)
    80003e82:	00000097          	auipc	ra,0x0
    80003e86:	22e080e7          	jalr	558(ra) # 800040b0 <pipewrite>
    80003e8a:	8a2a                	mv	s4,a0
    80003e8c:	a045                	j	80003f2c <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e8e:	02451783          	lh	a5,36(a0)
    80003e92:	03079693          	slli	a3,a5,0x30
    80003e96:	92c1                	srli	a3,a3,0x30
    80003e98:	4725                	li	a4,9
    80003e9a:	0cd76263          	bltu	a4,a3,80003f5e <filewrite+0x12c>
    80003e9e:	0792                	slli	a5,a5,0x4
    80003ea0:	00235717          	auipc	a4,0x235
    80003ea4:	b0070713          	addi	a4,a4,-1280 # 802389a0 <devsw>
    80003ea8:	97ba                	add	a5,a5,a4
    80003eaa:	679c                	ld	a5,8(a5)
    80003eac:	cbdd                	beqz	a5,80003f62 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003eae:	4505                	li	a0,1
    80003eb0:	9782                	jalr	a5
    80003eb2:	8a2a                	mv	s4,a0
    80003eb4:	a8a5                	j	80003f2c <filewrite+0xfa>
    80003eb6:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003eba:	00000097          	auipc	ra,0x0
    80003ebe:	8b4080e7          	jalr	-1868(ra) # 8000376e <begin_op>
      ilock(f->ip);
    80003ec2:	01893503          	ld	a0,24(s2)
    80003ec6:	fffff097          	auipc	ra,0xfffff
    80003eca:	edc080e7          	jalr	-292(ra) # 80002da2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003ece:	8756                	mv	a4,s5
    80003ed0:	02092683          	lw	a3,32(s2)
    80003ed4:	01698633          	add	a2,s3,s6
    80003ed8:	4585                	li	a1,1
    80003eda:	01893503          	ld	a0,24(s2)
    80003ede:	fffff097          	auipc	ra,0xfffff
    80003ee2:	270080e7          	jalr	624(ra) # 8000314e <writei>
    80003ee6:	84aa                	mv	s1,a0
    80003ee8:	00a05763          	blez	a0,80003ef6 <filewrite+0xc4>
        f->off += r;
    80003eec:	02092783          	lw	a5,32(s2)
    80003ef0:	9fa9                	addw	a5,a5,a0
    80003ef2:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003ef6:	01893503          	ld	a0,24(s2)
    80003efa:	fffff097          	auipc	ra,0xfffff
    80003efe:	f6a080e7          	jalr	-150(ra) # 80002e64 <iunlock>
      end_op();
    80003f02:	00000097          	auipc	ra,0x0
    80003f06:	8ea080e7          	jalr	-1814(ra) # 800037ec <end_op>

      if(r != n1){
    80003f0a:	009a9f63          	bne	s5,s1,80003f28 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003f0e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003f12:	0149db63          	bge	s3,s4,80003f28 <filewrite+0xf6>
      int n1 = n - i;
    80003f16:	413a04bb          	subw	s1,s4,s3
    80003f1a:	0004879b          	sext.w	a5,s1
    80003f1e:	f8fbdce3          	bge	s7,a5,80003eb6 <filewrite+0x84>
    80003f22:	84e2                	mv	s1,s8
    80003f24:	bf49                	j	80003eb6 <filewrite+0x84>
    int i = 0;
    80003f26:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003f28:	013a1f63          	bne	s4,s3,80003f46 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003f2c:	8552                	mv	a0,s4
    80003f2e:	60a6                	ld	ra,72(sp)
    80003f30:	6406                	ld	s0,64(sp)
    80003f32:	74e2                	ld	s1,56(sp)
    80003f34:	7942                	ld	s2,48(sp)
    80003f36:	79a2                	ld	s3,40(sp)
    80003f38:	7a02                	ld	s4,32(sp)
    80003f3a:	6ae2                	ld	s5,24(sp)
    80003f3c:	6b42                	ld	s6,16(sp)
    80003f3e:	6ba2                	ld	s7,8(sp)
    80003f40:	6c02                	ld	s8,0(sp)
    80003f42:	6161                	addi	sp,sp,80
    80003f44:	8082                	ret
    ret = (i == n ? n : -1);
    80003f46:	5a7d                	li	s4,-1
    80003f48:	b7d5                	j	80003f2c <filewrite+0xfa>
    panic("filewrite");
    80003f4a:	00004517          	auipc	a0,0x4
    80003f4e:	6fe50513          	addi	a0,a0,1790 # 80008648 <syscalls+0x268>
    80003f52:	00002097          	auipc	ra,0x2
    80003f56:	f0a080e7          	jalr	-246(ra) # 80005e5c <panic>
    return -1;
    80003f5a:	5a7d                	li	s4,-1
    80003f5c:	bfc1                	j	80003f2c <filewrite+0xfa>
      return -1;
    80003f5e:	5a7d                	li	s4,-1
    80003f60:	b7f1                	j	80003f2c <filewrite+0xfa>
    80003f62:	5a7d                	li	s4,-1
    80003f64:	b7e1                	j	80003f2c <filewrite+0xfa>

0000000080003f66 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f66:	7179                	addi	sp,sp,-48
    80003f68:	f406                	sd	ra,40(sp)
    80003f6a:	f022                	sd	s0,32(sp)
    80003f6c:	ec26                	sd	s1,24(sp)
    80003f6e:	e84a                	sd	s2,16(sp)
    80003f70:	e44e                	sd	s3,8(sp)
    80003f72:	e052                	sd	s4,0(sp)
    80003f74:	1800                	addi	s0,sp,48
    80003f76:	84aa                	mv	s1,a0
    80003f78:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f7a:	0005b023          	sd	zero,0(a1)
    80003f7e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f82:	00000097          	auipc	ra,0x0
    80003f86:	bf8080e7          	jalr	-1032(ra) # 80003b7a <filealloc>
    80003f8a:	e088                	sd	a0,0(s1)
    80003f8c:	c551                	beqz	a0,80004018 <pipealloc+0xb2>
    80003f8e:	00000097          	auipc	ra,0x0
    80003f92:	bec080e7          	jalr	-1044(ra) # 80003b7a <filealloc>
    80003f96:	00aa3023          	sd	a0,0(s4)
    80003f9a:	c92d                	beqz	a0,8000400c <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f9c:	ffffc097          	auipc	ra,0xffffc
    80003fa0:	20a080e7          	jalr	522(ra) # 800001a6 <kalloc>
    80003fa4:	892a                	mv	s2,a0
    80003fa6:	c125                	beqz	a0,80004006 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003fa8:	4985                	li	s3,1
    80003faa:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003fae:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003fb2:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003fb6:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003fba:	00004597          	auipc	a1,0x4
    80003fbe:	69e58593          	addi	a1,a1,1694 # 80008658 <syscalls+0x278>
    80003fc2:	00002097          	auipc	ra,0x2
    80003fc6:	342080e7          	jalr	834(ra) # 80006304 <initlock>
  (*f0)->type = FD_PIPE;
    80003fca:	609c                	ld	a5,0(s1)
    80003fcc:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003fd0:	609c                	ld	a5,0(s1)
    80003fd2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003fd6:	609c                	ld	a5,0(s1)
    80003fd8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003fdc:	609c                	ld	a5,0(s1)
    80003fde:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003fe2:	000a3783          	ld	a5,0(s4)
    80003fe6:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003fea:	000a3783          	ld	a5,0(s4)
    80003fee:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003ff2:	000a3783          	ld	a5,0(s4)
    80003ff6:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003ffa:	000a3783          	ld	a5,0(s4)
    80003ffe:	0127b823          	sd	s2,16(a5)
  return 0;
    80004002:	4501                	li	a0,0
    80004004:	a025                	j	8000402c <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004006:	6088                	ld	a0,0(s1)
    80004008:	e501                	bnez	a0,80004010 <pipealloc+0xaa>
    8000400a:	a039                	j	80004018 <pipealloc+0xb2>
    8000400c:	6088                	ld	a0,0(s1)
    8000400e:	c51d                	beqz	a0,8000403c <pipealloc+0xd6>
    fileclose(*f0);
    80004010:	00000097          	auipc	ra,0x0
    80004014:	c26080e7          	jalr	-986(ra) # 80003c36 <fileclose>
  if(*f1)
    80004018:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000401c:	557d                	li	a0,-1
  if(*f1)
    8000401e:	c799                	beqz	a5,8000402c <pipealloc+0xc6>
    fileclose(*f1);
    80004020:	853e                	mv	a0,a5
    80004022:	00000097          	auipc	ra,0x0
    80004026:	c14080e7          	jalr	-1004(ra) # 80003c36 <fileclose>
  return -1;
    8000402a:	557d                	li	a0,-1
}
    8000402c:	70a2                	ld	ra,40(sp)
    8000402e:	7402                	ld	s0,32(sp)
    80004030:	64e2                	ld	s1,24(sp)
    80004032:	6942                	ld	s2,16(sp)
    80004034:	69a2                	ld	s3,8(sp)
    80004036:	6a02                	ld	s4,0(sp)
    80004038:	6145                	addi	sp,sp,48
    8000403a:	8082                	ret
  return -1;
    8000403c:	557d                	li	a0,-1
    8000403e:	b7fd                	j	8000402c <pipealloc+0xc6>

0000000080004040 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004040:	1101                	addi	sp,sp,-32
    80004042:	ec06                	sd	ra,24(sp)
    80004044:	e822                	sd	s0,16(sp)
    80004046:	e426                	sd	s1,8(sp)
    80004048:	e04a                	sd	s2,0(sp)
    8000404a:	1000                	addi	s0,sp,32
    8000404c:	84aa                	mv	s1,a0
    8000404e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004050:	00002097          	auipc	ra,0x2
    80004054:	344080e7          	jalr	836(ra) # 80006394 <acquire>
  if(writable){
    80004058:	02090d63          	beqz	s2,80004092 <pipeclose+0x52>
    pi->writeopen = 0;
    8000405c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004060:	21848513          	addi	a0,s1,536
    80004064:	ffffd097          	auipc	ra,0xffffd
    80004068:	656080e7          	jalr	1622(ra) # 800016ba <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000406c:	2204b783          	ld	a5,544(s1)
    80004070:	eb95                	bnez	a5,800040a4 <pipeclose+0x64>
    release(&pi->lock);
    80004072:	8526                	mv	a0,s1
    80004074:	00002097          	auipc	ra,0x2
    80004078:	3d4080e7          	jalr	980(ra) # 80006448 <release>
    kfree((char*)pi);
    8000407c:	8526                	mv	a0,s1
    8000407e:	ffffc097          	auipc	ra,0xffffc
    80004082:	f9e080e7          	jalr	-98(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004086:	60e2                	ld	ra,24(sp)
    80004088:	6442                	ld	s0,16(sp)
    8000408a:	64a2                	ld	s1,8(sp)
    8000408c:	6902                	ld	s2,0(sp)
    8000408e:	6105                	addi	sp,sp,32
    80004090:	8082                	ret
    pi->readopen = 0;
    80004092:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004096:	21c48513          	addi	a0,s1,540
    8000409a:	ffffd097          	auipc	ra,0xffffd
    8000409e:	620080e7          	jalr	1568(ra) # 800016ba <wakeup>
    800040a2:	b7e9                	j	8000406c <pipeclose+0x2c>
    release(&pi->lock);
    800040a4:	8526                	mv	a0,s1
    800040a6:	00002097          	auipc	ra,0x2
    800040aa:	3a2080e7          	jalr	930(ra) # 80006448 <release>
}
    800040ae:	bfe1                	j	80004086 <pipeclose+0x46>

00000000800040b0 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800040b0:	711d                	addi	sp,sp,-96
    800040b2:	ec86                	sd	ra,88(sp)
    800040b4:	e8a2                	sd	s0,80(sp)
    800040b6:	e4a6                	sd	s1,72(sp)
    800040b8:	e0ca                	sd	s2,64(sp)
    800040ba:	fc4e                	sd	s3,56(sp)
    800040bc:	f852                	sd	s4,48(sp)
    800040be:	f456                	sd	s5,40(sp)
    800040c0:	f05a                	sd	s6,32(sp)
    800040c2:	ec5e                	sd	s7,24(sp)
    800040c4:	e862                	sd	s8,16(sp)
    800040c6:	1080                	addi	s0,sp,96
    800040c8:	84aa                	mv	s1,a0
    800040ca:	8aae                	mv	s5,a1
    800040cc:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800040ce:	ffffd097          	auipc	ra,0xffffd
    800040d2:	ee0080e7          	jalr	-288(ra) # 80000fae <myproc>
    800040d6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800040d8:	8526                	mv	a0,s1
    800040da:	00002097          	auipc	ra,0x2
    800040de:	2ba080e7          	jalr	698(ra) # 80006394 <acquire>
  while(i < n){
    800040e2:	0b405663          	blez	s4,8000418e <pipewrite+0xde>
  int i = 0;
    800040e6:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040e8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800040ea:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800040ee:	21c48b93          	addi	s7,s1,540
    800040f2:	a089                	j	80004134 <pipewrite+0x84>
      release(&pi->lock);
    800040f4:	8526                	mv	a0,s1
    800040f6:	00002097          	auipc	ra,0x2
    800040fa:	352080e7          	jalr	850(ra) # 80006448 <release>
      return -1;
    800040fe:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004100:	854a                	mv	a0,s2
    80004102:	60e6                	ld	ra,88(sp)
    80004104:	6446                	ld	s0,80(sp)
    80004106:	64a6                	ld	s1,72(sp)
    80004108:	6906                	ld	s2,64(sp)
    8000410a:	79e2                	ld	s3,56(sp)
    8000410c:	7a42                	ld	s4,48(sp)
    8000410e:	7aa2                	ld	s5,40(sp)
    80004110:	7b02                	ld	s6,32(sp)
    80004112:	6be2                	ld	s7,24(sp)
    80004114:	6c42                	ld	s8,16(sp)
    80004116:	6125                	addi	sp,sp,96
    80004118:	8082                	ret
      wakeup(&pi->nread);
    8000411a:	8562                	mv	a0,s8
    8000411c:	ffffd097          	auipc	ra,0xffffd
    80004120:	59e080e7          	jalr	1438(ra) # 800016ba <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004124:	85a6                	mv	a1,s1
    80004126:	855e                	mv	a0,s7
    80004128:	ffffd097          	auipc	ra,0xffffd
    8000412c:	52e080e7          	jalr	1326(ra) # 80001656 <sleep>
  while(i < n){
    80004130:	07495063          	bge	s2,s4,80004190 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004134:	2204a783          	lw	a5,544(s1)
    80004138:	dfd5                	beqz	a5,800040f4 <pipewrite+0x44>
    8000413a:	854e                	mv	a0,s3
    8000413c:	ffffd097          	auipc	ra,0xffffd
    80004140:	7c2080e7          	jalr	1986(ra) # 800018fe <killed>
    80004144:	f945                	bnez	a0,800040f4 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004146:	2184a783          	lw	a5,536(s1)
    8000414a:	21c4a703          	lw	a4,540(s1)
    8000414e:	2007879b          	addiw	a5,a5,512
    80004152:	fcf704e3          	beq	a4,a5,8000411a <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004156:	4685                	li	a3,1
    80004158:	01590633          	add	a2,s2,s5
    8000415c:	faf40593          	addi	a1,s0,-81
    80004160:	0509b503          	ld	a0,80(s3)
    80004164:	ffffd097          	auipc	ra,0xffffd
    80004168:	b96080e7          	jalr	-1130(ra) # 80000cfa <copyin>
    8000416c:	03650263          	beq	a0,s6,80004190 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004170:	21c4a783          	lw	a5,540(s1)
    80004174:	0017871b          	addiw	a4,a5,1
    80004178:	20e4ae23          	sw	a4,540(s1)
    8000417c:	1ff7f793          	andi	a5,a5,511
    80004180:	97a6                	add	a5,a5,s1
    80004182:	faf44703          	lbu	a4,-81(s0)
    80004186:	00e78c23          	sb	a4,24(a5)
      i++;
    8000418a:	2905                	addiw	s2,s2,1
    8000418c:	b755                	j	80004130 <pipewrite+0x80>
  int i = 0;
    8000418e:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004190:	21848513          	addi	a0,s1,536
    80004194:	ffffd097          	auipc	ra,0xffffd
    80004198:	526080e7          	jalr	1318(ra) # 800016ba <wakeup>
  release(&pi->lock);
    8000419c:	8526                	mv	a0,s1
    8000419e:	00002097          	auipc	ra,0x2
    800041a2:	2aa080e7          	jalr	682(ra) # 80006448 <release>
  return i;
    800041a6:	bfa9                	j	80004100 <pipewrite+0x50>

00000000800041a8 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800041a8:	715d                	addi	sp,sp,-80
    800041aa:	e486                	sd	ra,72(sp)
    800041ac:	e0a2                	sd	s0,64(sp)
    800041ae:	fc26                	sd	s1,56(sp)
    800041b0:	f84a                	sd	s2,48(sp)
    800041b2:	f44e                	sd	s3,40(sp)
    800041b4:	f052                	sd	s4,32(sp)
    800041b6:	ec56                	sd	s5,24(sp)
    800041b8:	e85a                	sd	s6,16(sp)
    800041ba:	0880                	addi	s0,sp,80
    800041bc:	84aa                	mv	s1,a0
    800041be:	892e                	mv	s2,a1
    800041c0:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800041c2:	ffffd097          	auipc	ra,0xffffd
    800041c6:	dec080e7          	jalr	-532(ra) # 80000fae <myproc>
    800041ca:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800041cc:	8526                	mv	a0,s1
    800041ce:	00002097          	auipc	ra,0x2
    800041d2:	1c6080e7          	jalr	454(ra) # 80006394 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041d6:	2184a703          	lw	a4,536(s1)
    800041da:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041de:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041e2:	02f71763          	bne	a4,a5,80004210 <piperead+0x68>
    800041e6:	2244a783          	lw	a5,548(s1)
    800041ea:	c39d                	beqz	a5,80004210 <piperead+0x68>
    if(killed(pr)){
    800041ec:	8552                	mv	a0,s4
    800041ee:	ffffd097          	auipc	ra,0xffffd
    800041f2:	710080e7          	jalr	1808(ra) # 800018fe <killed>
    800041f6:	e949                	bnez	a0,80004288 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041f8:	85a6                	mv	a1,s1
    800041fa:	854e                	mv	a0,s3
    800041fc:	ffffd097          	auipc	ra,0xffffd
    80004200:	45a080e7          	jalr	1114(ra) # 80001656 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004204:	2184a703          	lw	a4,536(s1)
    80004208:	21c4a783          	lw	a5,540(s1)
    8000420c:	fcf70de3          	beq	a4,a5,800041e6 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004210:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004212:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004214:	05505463          	blez	s5,8000425c <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004218:	2184a783          	lw	a5,536(s1)
    8000421c:	21c4a703          	lw	a4,540(s1)
    80004220:	02f70e63          	beq	a4,a5,8000425c <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004224:	0017871b          	addiw	a4,a5,1
    80004228:	20e4ac23          	sw	a4,536(s1)
    8000422c:	1ff7f793          	andi	a5,a5,511
    80004230:	97a6                	add	a5,a5,s1
    80004232:	0187c783          	lbu	a5,24(a5)
    80004236:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000423a:	4685                	li	a3,1
    8000423c:	fbf40613          	addi	a2,s0,-65
    80004240:	85ca                	mv	a1,s2
    80004242:	050a3503          	ld	a0,80(s4)
    80004246:	ffffd097          	auipc	ra,0xffffd
    8000424a:	9fa080e7          	jalr	-1542(ra) # 80000c40 <copyout>
    8000424e:	01650763          	beq	a0,s6,8000425c <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004252:	2985                	addiw	s3,s3,1
    80004254:	0905                	addi	s2,s2,1
    80004256:	fd3a91e3          	bne	s5,s3,80004218 <piperead+0x70>
    8000425a:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000425c:	21c48513          	addi	a0,s1,540
    80004260:	ffffd097          	auipc	ra,0xffffd
    80004264:	45a080e7          	jalr	1114(ra) # 800016ba <wakeup>
  release(&pi->lock);
    80004268:	8526                	mv	a0,s1
    8000426a:	00002097          	auipc	ra,0x2
    8000426e:	1de080e7          	jalr	478(ra) # 80006448 <release>
  return i;
}
    80004272:	854e                	mv	a0,s3
    80004274:	60a6                	ld	ra,72(sp)
    80004276:	6406                	ld	s0,64(sp)
    80004278:	74e2                	ld	s1,56(sp)
    8000427a:	7942                	ld	s2,48(sp)
    8000427c:	79a2                	ld	s3,40(sp)
    8000427e:	7a02                	ld	s4,32(sp)
    80004280:	6ae2                	ld	s5,24(sp)
    80004282:	6b42                	ld	s6,16(sp)
    80004284:	6161                	addi	sp,sp,80
    80004286:	8082                	ret
      release(&pi->lock);
    80004288:	8526                	mv	a0,s1
    8000428a:	00002097          	auipc	ra,0x2
    8000428e:	1be080e7          	jalr	446(ra) # 80006448 <release>
      return -1;
    80004292:	59fd                	li	s3,-1
    80004294:	bff9                	j	80004272 <piperead+0xca>

0000000080004296 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004296:	1141                	addi	sp,sp,-16
    80004298:	e422                	sd	s0,8(sp)
    8000429a:	0800                	addi	s0,sp,16
    8000429c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000429e:	8905                	andi	a0,a0,1
    800042a0:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800042a2:	8b89                	andi	a5,a5,2
    800042a4:	c399                	beqz	a5,800042aa <flags2perm+0x14>
      perm |= PTE_W;
    800042a6:	00456513          	ori	a0,a0,4
    return perm;
}
    800042aa:	6422                	ld	s0,8(sp)
    800042ac:	0141                	addi	sp,sp,16
    800042ae:	8082                	ret

00000000800042b0 <exec>:

int
exec(char *path, char **argv)
{
    800042b0:	de010113          	addi	sp,sp,-544
    800042b4:	20113c23          	sd	ra,536(sp)
    800042b8:	20813823          	sd	s0,528(sp)
    800042bc:	20913423          	sd	s1,520(sp)
    800042c0:	21213023          	sd	s2,512(sp)
    800042c4:	ffce                	sd	s3,504(sp)
    800042c6:	fbd2                	sd	s4,496(sp)
    800042c8:	f7d6                	sd	s5,488(sp)
    800042ca:	f3da                	sd	s6,480(sp)
    800042cc:	efde                	sd	s7,472(sp)
    800042ce:	ebe2                	sd	s8,464(sp)
    800042d0:	e7e6                	sd	s9,456(sp)
    800042d2:	e3ea                	sd	s10,448(sp)
    800042d4:	ff6e                	sd	s11,440(sp)
    800042d6:	1400                	addi	s0,sp,544
    800042d8:	892a                	mv	s2,a0
    800042da:	dea43423          	sd	a0,-536(s0)
    800042de:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800042e2:	ffffd097          	auipc	ra,0xffffd
    800042e6:	ccc080e7          	jalr	-820(ra) # 80000fae <myproc>
    800042ea:	84aa                	mv	s1,a0

  begin_op();
    800042ec:	fffff097          	auipc	ra,0xfffff
    800042f0:	482080e7          	jalr	1154(ra) # 8000376e <begin_op>

  if((ip = namei(path)) == 0){
    800042f4:	854a                	mv	a0,s2
    800042f6:	fffff097          	auipc	ra,0xfffff
    800042fa:	258080e7          	jalr	600(ra) # 8000354e <namei>
    800042fe:	c93d                	beqz	a0,80004374 <exec+0xc4>
    80004300:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004302:	fffff097          	auipc	ra,0xfffff
    80004306:	aa0080e7          	jalr	-1376(ra) # 80002da2 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000430a:	04000713          	li	a4,64
    8000430e:	4681                	li	a3,0
    80004310:	e5040613          	addi	a2,s0,-432
    80004314:	4581                	li	a1,0
    80004316:	8556                	mv	a0,s5
    80004318:	fffff097          	auipc	ra,0xfffff
    8000431c:	d3e080e7          	jalr	-706(ra) # 80003056 <readi>
    80004320:	04000793          	li	a5,64
    80004324:	00f51a63          	bne	a0,a5,80004338 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004328:	e5042703          	lw	a4,-432(s0)
    8000432c:	464c47b7          	lui	a5,0x464c4
    80004330:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004334:	04f70663          	beq	a4,a5,80004380 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004338:	8556                	mv	a0,s5
    8000433a:	fffff097          	auipc	ra,0xfffff
    8000433e:	cca080e7          	jalr	-822(ra) # 80003004 <iunlockput>
    end_op();
    80004342:	fffff097          	auipc	ra,0xfffff
    80004346:	4aa080e7          	jalr	1194(ra) # 800037ec <end_op>
  }
  return -1;
    8000434a:	557d                	li	a0,-1
}
    8000434c:	21813083          	ld	ra,536(sp)
    80004350:	21013403          	ld	s0,528(sp)
    80004354:	20813483          	ld	s1,520(sp)
    80004358:	20013903          	ld	s2,512(sp)
    8000435c:	79fe                	ld	s3,504(sp)
    8000435e:	7a5e                	ld	s4,496(sp)
    80004360:	7abe                	ld	s5,488(sp)
    80004362:	7b1e                	ld	s6,480(sp)
    80004364:	6bfe                	ld	s7,472(sp)
    80004366:	6c5e                	ld	s8,464(sp)
    80004368:	6cbe                	ld	s9,456(sp)
    8000436a:	6d1e                	ld	s10,448(sp)
    8000436c:	7dfa                	ld	s11,440(sp)
    8000436e:	22010113          	addi	sp,sp,544
    80004372:	8082                	ret
    end_op();
    80004374:	fffff097          	auipc	ra,0xfffff
    80004378:	478080e7          	jalr	1144(ra) # 800037ec <end_op>
    return -1;
    8000437c:	557d                	li	a0,-1
    8000437e:	b7f9                	j	8000434c <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004380:	8526                	mv	a0,s1
    80004382:	ffffd097          	auipc	ra,0xffffd
    80004386:	cf0080e7          	jalr	-784(ra) # 80001072 <proc_pagetable>
    8000438a:	8b2a                	mv	s6,a0
    8000438c:	d555                	beqz	a0,80004338 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000438e:	e7042783          	lw	a5,-400(s0)
    80004392:	e8845703          	lhu	a4,-376(s0)
    80004396:	c735                	beqz	a4,80004402 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004398:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000439a:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    8000439e:	6a05                	lui	s4,0x1
    800043a0:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800043a4:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800043a8:	6d85                	lui	s11,0x1
    800043aa:	7d7d                	lui	s10,0xfffff
    800043ac:	ac3d                	j	800045ea <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800043ae:	00004517          	auipc	a0,0x4
    800043b2:	2b250513          	addi	a0,a0,690 # 80008660 <syscalls+0x280>
    800043b6:	00002097          	auipc	ra,0x2
    800043ba:	aa6080e7          	jalr	-1370(ra) # 80005e5c <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800043be:	874a                	mv	a4,s2
    800043c0:	009c86bb          	addw	a3,s9,s1
    800043c4:	4581                	li	a1,0
    800043c6:	8556                	mv	a0,s5
    800043c8:	fffff097          	auipc	ra,0xfffff
    800043cc:	c8e080e7          	jalr	-882(ra) # 80003056 <readi>
    800043d0:	2501                	sext.w	a0,a0
    800043d2:	1aa91963          	bne	s2,a0,80004584 <exec+0x2d4>
  for(i = 0; i < sz; i += PGSIZE){
    800043d6:	009d84bb          	addw	s1,s11,s1
    800043da:	013d09bb          	addw	s3,s10,s3
    800043de:	1f74f663          	bgeu	s1,s7,800045ca <exec+0x31a>
    pa = walkaddr(pagetable, va + i);
    800043e2:	02049593          	slli	a1,s1,0x20
    800043e6:	9181                	srli	a1,a1,0x20
    800043e8:	95e2                	add	a1,a1,s8
    800043ea:	855a                	mv	a0,s6
    800043ec:	ffffc097          	auipc	ra,0xffffc
    800043f0:	25c080e7          	jalr	604(ra) # 80000648 <walkaddr>
    800043f4:	862a                	mv	a2,a0
    if(pa == 0)
    800043f6:	dd45                	beqz	a0,800043ae <exec+0xfe>
      n = PGSIZE;
    800043f8:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800043fa:	fd49f2e3          	bgeu	s3,s4,800043be <exec+0x10e>
      n = sz - i;
    800043fe:	894e                	mv	s2,s3
    80004400:	bf7d                	j	800043be <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004402:	4901                	li	s2,0
  iunlockput(ip);
    80004404:	8556                	mv	a0,s5
    80004406:	fffff097          	auipc	ra,0xfffff
    8000440a:	bfe080e7          	jalr	-1026(ra) # 80003004 <iunlockput>
  end_op();
    8000440e:	fffff097          	auipc	ra,0xfffff
    80004412:	3de080e7          	jalr	990(ra) # 800037ec <end_op>
  p = myproc();
    80004416:	ffffd097          	auipc	ra,0xffffd
    8000441a:	b98080e7          	jalr	-1128(ra) # 80000fae <myproc>
    8000441e:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004420:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004424:	6785                	lui	a5,0x1
    80004426:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004428:	97ca                	add	a5,a5,s2
    8000442a:	777d                	lui	a4,0xfffff
    8000442c:	8ff9                	and	a5,a5,a4
    8000442e:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004432:	4691                	li	a3,4
    80004434:	6609                	lui	a2,0x2
    80004436:	963e                	add	a2,a2,a5
    80004438:	85be                	mv	a1,a5
    8000443a:	855a                	mv	a0,s6
    8000443c:	ffffc097          	auipc	ra,0xffffc
    80004440:	5c0080e7          	jalr	1472(ra) # 800009fc <uvmalloc>
    80004444:	8c2a                	mv	s8,a0
  ip = 0;
    80004446:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004448:	12050e63          	beqz	a0,80004584 <exec+0x2d4>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000444c:	75f9                	lui	a1,0xffffe
    8000444e:	95aa                	add	a1,a1,a0
    80004450:	855a                	mv	a0,s6
    80004452:	ffffc097          	auipc	ra,0xffffc
    80004456:	7bc080e7          	jalr	1980(ra) # 80000c0e <uvmclear>
  stackbase = sp - PGSIZE;
    8000445a:	7afd                	lui	s5,0xfffff
    8000445c:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    8000445e:	df043783          	ld	a5,-528(s0)
    80004462:	6388                	ld	a0,0(a5)
    80004464:	c925                	beqz	a0,800044d4 <exec+0x224>
    80004466:	e9040993          	addi	s3,s0,-368
    8000446a:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000446e:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004470:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004472:	ffffc097          	auipc	ra,0xffffc
    80004476:	fc8080e7          	jalr	-56(ra) # 8000043a <strlen>
    8000447a:	0015079b          	addiw	a5,a0,1
    8000447e:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004482:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004486:	13596663          	bltu	s2,s5,800045b2 <exec+0x302>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000448a:	df043d83          	ld	s11,-528(s0)
    8000448e:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004492:	8552                	mv	a0,s4
    80004494:	ffffc097          	auipc	ra,0xffffc
    80004498:	fa6080e7          	jalr	-90(ra) # 8000043a <strlen>
    8000449c:	0015069b          	addiw	a3,a0,1
    800044a0:	8652                	mv	a2,s4
    800044a2:	85ca                	mv	a1,s2
    800044a4:	855a                	mv	a0,s6
    800044a6:	ffffc097          	auipc	ra,0xffffc
    800044aa:	79a080e7          	jalr	1946(ra) # 80000c40 <copyout>
    800044ae:	10054663          	bltz	a0,800045ba <exec+0x30a>
    ustack[argc] = sp;
    800044b2:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800044b6:	0485                	addi	s1,s1,1
    800044b8:	008d8793          	addi	a5,s11,8
    800044bc:	def43823          	sd	a5,-528(s0)
    800044c0:	008db503          	ld	a0,8(s11)
    800044c4:	c911                	beqz	a0,800044d8 <exec+0x228>
    if(argc >= MAXARG)
    800044c6:	09a1                	addi	s3,s3,8
    800044c8:	fb3c95e3          	bne	s9,s3,80004472 <exec+0x1c2>
  sz = sz1;
    800044cc:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800044d0:	4a81                	li	s5,0
    800044d2:	a84d                	j	80004584 <exec+0x2d4>
  sp = sz;
    800044d4:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800044d6:	4481                	li	s1,0
  ustack[argc] = 0;
    800044d8:	00349793          	slli	a5,s1,0x3
    800044dc:	f9078793          	addi	a5,a5,-112
    800044e0:	97a2                	add	a5,a5,s0
    800044e2:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800044e6:	00148693          	addi	a3,s1,1
    800044ea:	068e                	slli	a3,a3,0x3
    800044ec:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800044f0:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800044f4:	01597663          	bgeu	s2,s5,80004500 <exec+0x250>
  sz = sz1;
    800044f8:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800044fc:	4a81                	li	s5,0
    800044fe:	a059                	j	80004584 <exec+0x2d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004500:	e9040613          	addi	a2,s0,-368
    80004504:	85ca                	mv	a1,s2
    80004506:	855a                	mv	a0,s6
    80004508:	ffffc097          	auipc	ra,0xffffc
    8000450c:	738080e7          	jalr	1848(ra) # 80000c40 <copyout>
    80004510:	0a054963          	bltz	a0,800045c2 <exec+0x312>
  p->trapframe->a1 = sp;
    80004514:	058bb783          	ld	a5,88(s7)
    80004518:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000451c:	de843783          	ld	a5,-536(s0)
    80004520:	0007c703          	lbu	a4,0(a5)
    80004524:	cf11                	beqz	a4,80004540 <exec+0x290>
    80004526:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004528:	02f00693          	li	a3,47
    8000452c:	a039                	j	8000453a <exec+0x28a>
      last = s+1;
    8000452e:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004532:	0785                	addi	a5,a5,1
    80004534:	fff7c703          	lbu	a4,-1(a5)
    80004538:	c701                	beqz	a4,80004540 <exec+0x290>
    if(*s == '/')
    8000453a:	fed71ce3          	bne	a4,a3,80004532 <exec+0x282>
    8000453e:	bfc5                	j	8000452e <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    80004540:	4641                	li	a2,16
    80004542:	de843583          	ld	a1,-536(s0)
    80004546:	158b8513          	addi	a0,s7,344
    8000454a:	ffffc097          	auipc	ra,0xffffc
    8000454e:	ebe080e7          	jalr	-322(ra) # 80000408 <safestrcpy>
  oldpagetable = p->pagetable;
    80004552:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004556:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    8000455a:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000455e:	058bb783          	ld	a5,88(s7)
    80004562:	e6843703          	ld	a4,-408(s0)
    80004566:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004568:	058bb783          	ld	a5,88(s7)
    8000456c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004570:	85ea                	mv	a1,s10
    80004572:	ffffd097          	auipc	ra,0xffffd
    80004576:	b9c080e7          	jalr	-1124(ra) # 8000110e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000457a:	0004851b          	sext.w	a0,s1
    8000457e:	b3f9                	j	8000434c <exec+0x9c>
    80004580:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004584:	df843583          	ld	a1,-520(s0)
    80004588:	855a                	mv	a0,s6
    8000458a:	ffffd097          	auipc	ra,0xffffd
    8000458e:	b84080e7          	jalr	-1148(ra) # 8000110e <proc_freepagetable>
  if(ip){
    80004592:	da0a93e3          	bnez	s5,80004338 <exec+0x88>
  return -1;
    80004596:	557d                	li	a0,-1
    80004598:	bb55                	j	8000434c <exec+0x9c>
    8000459a:	df243c23          	sd	s2,-520(s0)
    8000459e:	b7dd                	j	80004584 <exec+0x2d4>
    800045a0:	df243c23          	sd	s2,-520(s0)
    800045a4:	b7c5                	j	80004584 <exec+0x2d4>
    800045a6:	df243c23          	sd	s2,-520(s0)
    800045aa:	bfe9                	j	80004584 <exec+0x2d4>
    800045ac:	df243c23          	sd	s2,-520(s0)
    800045b0:	bfd1                	j	80004584 <exec+0x2d4>
  sz = sz1;
    800045b2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800045b6:	4a81                	li	s5,0
    800045b8:	b7f1                	j	80004584 <exec+0x2d4>
  sz = sz1;
    800045ba:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800045be:	4a81                	li	s5,0
    800045c0:	b7d1                	j	80004584 <exec+0x2d4>
  sz = sz1;
    800045c2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800045c6:	4a81                	li	s5,0
    800045c8:	bf75                	j	80004584 <exec+0x2d4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800045ca:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800045ce:	e0843783          	ld	a5,-504(s0)
    800045d2:	0017869b          	addiw	a3,a5,1
    800045d6:	e0d43423          	sd	a3,-504(s0)
    800045da:	e0043783          	ld	a5,-512(s0)
    800045de:	0387879b          	addiw	a5,a5,56
    800045e2:	e8845703          	lhu	a4,-376(s0)
    800045e6:	e0e6dfe3          	bge	a3,a4,80004404 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800045ea:	2781                	sext.w	a5,a5
    800045ec:	e0f43023          	sd	a5,-512(s0)
    800045f0:	03800713          	li	a4,56
    800045f4:	86be                	mv	a3,a5
    800045f6:	e1840613          	addi	a2,s0,-488
    800045fa:	4581                	li	a1,0
    800045fc:	8556                	mv	a0,s5
    800045fe:	fffff097          	auipc	ra,0xfffff
    80004602:	a58080e7          	jalr	-1448(ra) # 80003056 <readi>
    80004606:	03800793          	li	a5,56
    8000460a:	f6f51be3          	bne	a0,a5,80004580 <exec+0x2d0>
    if(ph.type != ELF_PROG_LOAD)
    8000460e:	e1842783          	lw	a5,-488(s0)
    80004612:	4705                	li	a4,1
    80004614:	fae79de3          	bne	a5,a4,800045ce <exec+0x31e>
    if(ph.memsz < ph.filesz)
    80004618:	e4043483          	ld	s1,-448(s0)
    8000461c:	e3843783          	ld	a5,-456(s0)
    80004620:	f6f4ede3          	bltu	s1,a5,8000459a <exec+0x2ea>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004624:	e2843783          	ld	a5,-472(s0)
    80004628:	94be                	add	s1,s1,a5
    8000462a:	f6f4ebe3          	bltu	s1,a5,800045a0 <exec+0x2f0>
    if(ph.vaddr % PGSIZE != 0)
    8000462e:	de043703          	ld	a4,-544(s0)
    80004632:	8ff9                	and	a5,a5,a4
    80004634:	fbad                	bnez	a5,800045a6 <exec+0x2f6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004636:	e1c42503          	lw	a0,-484(s0)
    8000463a:	00000097          	auipc	ra,0x0
    8000463e:	c5c080e7          	jalr	-932(ra) # 80004296 <flags2perm>
    80004642:	86aa                	mv	a3,a0
    80004644:	8626                	mv	a2,s1
    80004646:	85ca                	mv	a1,s2
    80004648:	855a                	mv	a0,s6
    8000464a:	ffffc097          	auipc	ra,0xffffc
    8000464e:	3b2080e7          	jalr	946(ra) # 800009fc <uvmalloc>
    80004652:	dea43c23          	sd	a0,-520(s0)
    80004656:	d939                	beqz	a0,800045ac <exec+0x2fc>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004658:	e2843c03          	ld	s8,-472(s0)
    8000465c:	e2042c83          	lw	s9,-480(s0)
    80004660:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004664:	f60b83e3          	beqz	s7,800045ca <exec+0x31a>
    80004668:	89de                	mv	s3,s7
    8000466a:	4481                	li	s1,0
    8000466c:	bb9d                	j	800043e2 <exec+0x132>

000000008000466e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000466e:	7179                	addi	sp,sp,-48
    80004670:	f406                	sd	ra,40(sp)
    80004672:	f022                	sd	s0,32(sp)
    80004674:	ec26                	sd	s1,24(sp)
    80004676:	e84a                	sd	s2,16(sp)
    80004678:	1800                	addi	s0,sp,48
    8000467a:	892e                	mv	s2,a1
    8000467c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000467e:	fdc40593          	addi	a1,s0,-36
    80004682:	ffffe097          	auipc	ra,0xffffe
    80004686:	ba8080e7          	jalr	-1112(ra) # 8000222a <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000468a:	fdc42703          	lw	a4,-36(s0)
    8000468e:	47bd                	li	a5,15
    80004690:	02e7eb63          	bltu	a5,a4,800046c6 <argfd+0x58>
    80004694:	ffffd097          	auipc	ra,0xffffd
    80004698:	91a080e7          	jalr	-1766(ra) # 80000fae <myproc>
    8000469c:	fdc42703          	lw	a4,-36(s0)
    800046a0:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7fdbd29a>
    800046a4:	078e                	slli	a5,a5,0x3
    800046a6:	953e                	add	a0,a0,a5
    800046a8:	611c                	ld	a5,0(a0)
    800046aa:	c385                	beqz	a5,800046ca <argfd+0x5c>
    return -1;
  if(pfd)
    800046ac:	00090463          	beqz	s2,800046b4 <argfd+0x46>
    *pfd = fd;
    800046b0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800046b4:	4501                	li	a0,0
  if(pf)
    800046b6:	c091                	beqz	s1,800046ba <argfd+0x4c>
    *pf = f;
    800046b8:	e09c                	sd	a5,0(s1)
}
    800046ba:	70a2                	ld	ra,40(sp)
    800046bc:	7402                	ld	s0,32(sp)
    800046be:	64e2                	ld	s1,24(sp)
    800046c0:	6942                	ld	s2,16(sp)
    800046c2:	6145                	addi	sp,sp,48
    800046c4:	8082                	ret
    return -1;
    800046c6:	557d                	li	a0,-1
    800046c8:	bfcd                	j	800046ba <argfd+0x4c>
    800046ca:	557d                	li	a0,-1
    800046cc:	b7fd                	j	800046ba <argfd+0x4c>

00000000800046ce <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800046ce:	1101                	addi	sp,sp,-32
    800046d0:	ec06                	sd	ra,24(sp)
    800046d2:	e822                	sd	s0,16(sp)
    800046d4:	e426                	sd	s1,8(sp)
    800046d6:	1000                	addi	s0,sp,32
    800046d8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800046da:	ffffd097          	auipc	ra,0xffffd
    800046de:	8d4080e7          	jalr	-1836(ra) # 80000fae <myproc>
    800046e2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800046e4:	0d050793          	addi	a5,a0,208
    800046e8:	4501                	li	a0,0
    800046ea:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800046ec:	6398                	ld	a4,0(a5)
    800046ee:	cb19                	beqz	a4,80004704 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800046f0:	2505                	addiw	a0,a0,1
    800046f2:	07a1                	addi	a5,a5,8
    800046f4:	fed51ce3          	bne	a0,a3,800046ec <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800046f8:	557d                	li	a0,-1
}
    800046fa:	60e2                	ld	ra,24(sp)
    800046fc:	6442                	ld	s0,16(sp)
    800046fe:	64a2                	ld	s1,8(sp)
    80004700:	6105                	addi	sp,sp,32
    80004702:	8082                	ret
      p->ofile[fd] = f;
    80004704:	01a50793          	addi	a5,a0,26
    80004708:	078e                	slli	a5,a5,0x3
    8000470a:	963e                	add	a2,a2,a5
    8000470c:	e204                	sd	s1,0(a2)
      return fd;
    8000470e:	b7f5                	j	800046fa <fdalloc+0x2c>

0000000080004710 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004710:	715d                	addi	sp,sp,-80
    80004712:	e486                	sd	ra,72(sp)
    80004714:	e0a2                	sd	s0,64(sp)
    80004716:	fc26                	sd	s1,56(sp)
    80004718:	f84a                	sd	s2,48(sp)
    8000471a:	f44e                	sd	s3,40(sp)
    8000471c:	f052                	sd	s4,32(sp)
    8000471e:	ec56                	sd	s5,24(sp)
    80004720:	e85a                	sd	s6,16(sp)
    80004722:	0880                	addi	s0,sp,80
    80004724:	8b2e                	mv	s6,a1
    80004726:	89b2                	mv	s3,a2
    80004728:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000472a:	fb040593          	addi	a1,s0,-80
    8000472e:	fffff097          	auipc	ra,0xfffff
    80004732:	e3e080e7          	jalr	-450(ra) # 8000356c <nameiparent>
    80004736:	84aa                	mv	s1,a0
    80004738:	14050f63          	beqz	a0,80004896 <create+0x186>
    return 0;

  ilock(dp);
    8000473c:	ffffe097          	auipc	ra,0xffffe
    80004740:	666080e7          	jalr	1638(ra) # 80002da2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004744:	4601                	li	a2,0
    80004746:	fb040593          	addi	a1,s0,-80
    8000474a:	8526                	mv	a0,s1
    8000474c:	fffff097          	auipc	ra,0xfffff
    80004750:	b3a080e7          	jalr	-1222(ra) # 80003286 <dirlookup>
    80004754:	8aaa                	mv	s5,a0
    80004756:	c931                	beqz	a0,800047aa <create+0x9a>
    iunlockput(dp);
    80004758:	8526                	mv	a0,s1
    8000475a:	fffff097          	auipc	ra,0xfffff
    8000475e:	8aa080e7          	jalr	-1878(ra) # 80003004 <iunlockput>
    ilock(ip);
    80004762:	8556                	mv	a0,s5
    80004764:	ffffe097          	auipc	ra,0xffffe
    80004768:	63e080e7          	jalr	1598(ra) # 80002da2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000476c:	000b059b          	sext.w	a1,s6
    80004770:	4789                	li	a5,2
    80004772:	02f59563          	bne	a1,a5,8000479c <create+0x8c>
    80004776:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7fdbd2c4>
    8000477a:	37f9                	addiw	a5,a5,-2
    8000477c:	17c2                	slli	a5,a5,0x30
    8000477e:	93c1                	srli	a5,a5,0x30
    80004780:	4705                	li	a4,1
    80004782:	00f76d63          	bltu	a4,a5,8000479c <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004786:	8556                	mv	a0,s5
    80004788:	60a6                	ld	ra,72(sp)
    8000478a:	6406                	ld	s0,64(sp)
    8000478c:	74e2                	ld	s1,56(sp)
    8000478e:	7942                	ld	s2,48(sp)
    80004790:	79a2                	ld	s3,40(sp)
    80004792:	7a02                	ld	s4,32(sp)
    80004794:	6ae2                	ld	s5,24(sp)
    80004796:	6b42                	ld	s6,16(sp)
    80004798:	6161                	addi	sp,sp,80
    8000479a:	8082                	ret
    iunlockput(ip);
    8000479c:	8556                	mv	a0,s5
    8000479e:	fffff097          	auipc	ra,0xfffff
    800047a2:	866080e7          	jalr	-1946(ra) # 80003004 <iunlockput>
    return 0;
    800047a6:	4a81                	li	s5,0
    800047a8:	bff9                	j	80004786 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800047aa:	85da                	mv	a1,s6
    800047ac:	4088                	lw	a0,0(s1)
    800047ae:	ffffe097          	auipc	ra,0xffffe
    800047b2:	456080e7          	jalr	1110(ra) # 80002c04 <ialloc>
    800047b6:	8a2a                	mv	s4,a0
    800047b8:	c539                	beqz	a0,80004806 <create+0xf6>
  ilock(ip);
    800047ba:	ffffe097          	auipc	ra,0xffffe
    800047be:	5e8080e7          	jalr	1512(ra) # 80002da2 <ilock>
  ip->major = major;
    800047c2:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800047c6:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800047ca:	4905                	li	s2,1
    800047cc:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800047d0:	8552                	mv	a0,s4
    800047d2:	ffffe097          	auipc	ra,0xffffe
    800047d6:	504080e7          	jalr	1284(ra) # 80002cd6 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800047da:	000b059b          	sext.w	a1,s6
    800047de:	03258b63          	beq	a1,s2,80004814 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    800047e2:	004a2603          	lw	a2,4(s4)
    800047e6:	fb040593          	addi	a1,s0,-80
    800047ea:	8526                	mv	a0,s1
    800047ec:	fffff097          	auipc	ra,0xfffff
    800047f0:	cb0080e7          	jalr	-848(ra) # 8000349c <dirlink>
    800047f4:	06054f63          	bltz	a0,80004872 <create+0x162>
  iunlockput(dp);
    800047f8:	8526                	mv	a0,s1
    800047fa:	fffff097          	auipc	ra,0xfffff
    800047fe:	80a080e7          	jalr	-2038(ra) # 80003004 <iunlockput>
  return ip;
    80004802:	8ad2                	mv	s5,s4
    80004804:	b749                	j	80004786 <create+0x76>
    iunlockput(dp);
    80004806:	8526                	mv	a0,s1
    80004808:	ffffe097          	auipc	ra,0xffffe
    8000480c:	7fc080e7          	jalr	2044(ra) # 80003004 <iunlockput>
    return 0;
    80004810:	8ad2                	mv	s5,s4
    80004812:	bf95                	j	80004786 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004814:	004a2603          	lw	a2,4(s4)
    80004818:	00004597          	auipc	a1,0x4
    8000481c:	e6858593          	addi	a1,a1,-408 # 80008680 <syscalls+0x2a0>
    80004820:	8552                	mv	a0,s4
    80004822:	fffff097          	auipc	ra,0xfffff
    80004826:	c7a080e7          	jalr	-902(ra) # 8000349c <dirlink>
    8000482a:	04054463          	bltz	a0,80004872 <create+0x162>
    8000482e:	40d0                	lw	a2,4(s1)
    80004830:	00004597          	auipc	a1,0x4
    80004834:	e5858593          	addi	a1,a1,-424 # 80008688 <syscalls+0x2a8>
    80004838:	8552                	mv	a0,s4
    8000483a:	fffff097          	auipc	ra,0xfffff
    8000483e:	c62080e7          	jalr	-926(ra) # 8000349c <dirlink>
    80004842:	02054863          	bltz	a0,80004872 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    80004846:	004a2603          	lw	a2,4(s4)
    8000484a:	fb040593          	addi	a1,s0,-80
    8000484e:	8526                	mv	a0,s1
    80004850:	fffff097          	auipc	ra,0xfffff
    80004854:	c4c080e7          	jalr	-948(ra) # 8000349c <dirlink>
    80004858:	00054d63          	bltz	a0,80004872 <create+0x162>
    dp->nlink++;  // for ".."
    8000485c:	04a4d783          	lhu	a5,74(s1)
    80004860:	2785                	addiw	a5,a5,1
    80004862:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004866:	8526                	mv	a0,s1
    80004868:	ffffe097          	auipc	ra,0xffffe
    8000486c:	46e080e7          	jalr	1134(ra) # 80002cd6 <iupdate>
    80004870:	b761                	j	800047f8 <create+0xe8>
  ip->nlink = 0;
    80004872:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004876:	8552                	mv	a0,s4
    80004878:	ffffe097          	auipc	ra,0xffffe
    8000487c:	45e080e7          	jalr	1118(ra) # 80002cd6 <iupdate>
  iunlockput(ip);
    80004880:	8552                	mv	a0,s4
    80004882:	ffffe097          	auipc	ra,0xffffe
    80004886:	782080e7          	jalr	1922(ra) # 80003004 <iunlockput>
  iunlockput(dp);
    8000488a:	8526                	mv	a0,s1
    8000488c:	ffffe097          	auipc	ra,0xffffe
    80004890:	778080e7          	jalr	1912(ra) # 80003004 <iunlockput>
  return 0;
    80004894:	bdcd                	j	80004786 <create+0x76>
    return 0;
    80004896:	8aaa                	mv	s5,a0
    80004898:	b5fd                	j	80004786 <create+0x76>

000000008000489a <sys_dup>:
{
    8000489a:	7179                	addi	sp,sp,-48
    8000489c:	f406                	sd	ra,40(sp)
    8000489e:	f022                	sd	s0,32(sp)
    800048a0:	ec26                	sd	s1,24(sp)
    800048a2:	e84a                	sd	s2,16(sp)
    800048a4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800048a6:	fd840613          	addi	a2,s0,-40
    800048aa:	4581                	li	a1,0
    800048ac:	4501                	li	a0,0
    800048ae:	00000097          	auipc	ra,0x0
    800048b2:	dc0080e7          	jalr	-576(ra) # 8000466e <argfd>
    return -1;
    800048b6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800048b8:	02054363          	bltz	a0,800048de <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800048bc:	fd843903          	ld	s2,-40(s0)
    800048c0:	854a                	mv	a0,s2
    800048c2:	00000097          	auipc	ra,0x0
    800048c6:	e0c080e7          	jalr	-500(ra) # 800046ce <fdalloc>
    800048ca:	84aa                	mv	s1,a0
    return -1;
    800048cc:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800048ce:	00054863          	bltz	a0,800048de <sys_dup+0x44>
  filedup(f);
    800048d2:	854a                	mv	a0,s2
    800048d4:	fffff097          	auipc	ra,0xfffff
    800048d8:	310080e7          	jalr	784(ra) # 80003be4 <filedup>
  return fd;
    800048dc:	87a6                	mv	a5,s1
}
    800048de:	853e                	mv	a0,a5
    800048e0:	70a2                	ld	ra,40(sp)
    800048e2:	7402                	ld	s0,32(sp)
    800048e4:	64e2                	ld	s1,24(sp)
    800048e6:	6942                	ld	s2,16(sp)
    800048e8:	6145                	addi	sp,sp,48
    800048ea:	8082                	ret

00000000800048ec <sys_read>:
{
    800048ec:	7179                	addi	sp,sp,-48
    800048ee:	f406                	sd	ra,40(sp)
    800048f0:	f022                	sd	s0,32(sp)
    800048f2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800048f4:	fd840593          	addi	a1,s0,-40
    800048f8:	4505                	li	a0,1
    800048fa:	ffffe097          	auipc	ra,0xffffe
    800048fe:	950080e7          	jalr	-1712(ra) # 8000224a <argaddr>
  argint(2, &n);
    80004902:	fe440593          	addi	a1,s0,-28
    80004906:	4509                	li	a0,2
    80004908:	ffffe097          	auipc	ra,0xffffe
    8000490c:	922080e7          	jalr	-1758(ra) # 8000222a <argint>
  if(argfd(0, 0, &f) < 0)
    80004910:	fe840613          	addi	a2,s0,-24
    80004914:	4581                	li	a1,0
    80004916:	4501                	li	a0,0
    80004918:	00000097          	auipc	ra,0x0
    8000491c:	d56080e7          	jalr	-682(ra) # 8000466e <argfd>
    80004920:	87aa                	mv	a5,a0
    return -1;
    80004922:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004924:	0007cc63          	bltz	a5,8000493c <sys_read+0x50>
  return fileread(f, p, n);
    80004928:	fe442603          	lw	a2,-28(s0)
    8000492c:	fd843583          	ld	a1,-40(s0)
    80004930:	fe843503          	ld	a0,-24(s0)
    80004934:	fffff097          	auipc	ra,0xfffff
    80004938:	43c080e7          	jalr	1084(ra) # 80003d70 <fileread>
}
    8000493c:	70a2                	ld	ra,40(sp)
    8000493e:	7402                	ld	s0,32(sp)
    80004940:	6145                	addi	sp,sp,48
    80004942:	8082                	ret

0000000080004944 <sys_write>:
{
    80004944:	7179                	addi	sp,sp,-48
    80004946:	f406                	sd	ra,40(sp)
    80004948:	f022                	sd	s0,32(sp)
    8000494a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000494c:	fd840593          	addi	a1,s0,-40
    80004950:	4505                	li	a0,1
    80004952:	ffffe097          	auipc	ra,0xffffe
    80004956:	8f8080e7          	jalr	-1800(ra) # 8000224a <argaddr>
  argint(2, &n);
    8000495a:	fe440593          	addi	a1,s0,-28
    8000495e:	4509                	li	a0,2
    80004960:	ffffe097          	auipc	ra,0xffffe
    80004964:	8ca080e7          	jalr	-1846(ra) # 8000222a <argint>
  if(argfd(0, 0, &f) < 0)
    80004968:	fe840613          	addi	a2,s0,-24
    8000496c:	4581                	li	a1,0
    8000496e:	4501                	li	a0,0
    80004970:	00000097          	auipc	ra,0x0
    80004974:	cfe080e7          	jalr	-770(ra) # 8000466e <argfd>
    80004978:	87aa                	mv	a5,a0
    return -1;
    8000497a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000497c:	0007cc63          	bltz	a5,80004994 <sys_write+0x50>
  return filewrite(f, p, n);
    80004980:	fe442603          	lw	a2,-28(s0)
    80004984:	fd843583          	ld	a1,-40(s0)
    80004988:	fe843503          	ld	a0,-24(s0)
    8000498c:	fffff097          	auipc	ra,0xfffff
    80004990:	4a6080e7          	jalr	1190(ra) # 80003e32 <filewrite>
}
    80004994:	70a2                	ld	ra,40(sp)
    80004996:	7402                	ld	s0,32(sp)
    80004998:	6145                	addi	sp,sp,48
    8000499a:	8082                	ret

000000008000499c <sys_close>:
{
    8000499c:	1101                	addi	sp,sp,-32
    8000499e:	ec06                	sd	ra,24(sp)
    800049a0:	e822                	sd	s0,16(sp)
    800049a2:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800049a4:	fe040613          	addi	a2,s0,-32
    800049a8:	fec40593          	addi	a1,s0,-20
    800049ac:	4501                	li	a0,0
    800049ae:	00000097          	auipc	ra,0x0
    800049b2:	cc0080e7          	jalr	-832(ra) # 8000466e <argfd>
    return -1;
    800049b6:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800049b8:	02054463          	bltz	a0,800049e0 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800049bc:	ffffc097          	auipc	ra,0xffffc
    800049c0:	5f2080e7          	jalr	1522(ra) # 80000fae <myproc>
    800049c4:	fec42783          	lw	a5,-20(s0)
    800049c8:	07e9                	addi	a5,a5,26
    800049ca:	078e                	slli	a5,a5,0x3
    800049cc:	953e                	add	a0,a0,a5
    800049ce:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800049d2:	fe043503          	ld	a0,-32(s0)
    800049d6:	fffff097          	auipc	ra,0xfffff
    800049da:	260080e7          	jalr	608(ra) # 80003c36 <fileclose>
  return 0;
    800049de:	4781                	li	a5,0
}
    800049e0:	853e                	mv	a0,a5
    800049e2:	60e2                	ld	ra,24(sp)
    800049e4:	6442                	ld	s0,16(sp)
    800049e6:	6105                	addi	sp,sp,32
    800049e8:	8082                	ret

00000000800049ea <sys_fstat>:
{
    800049ea:	1101                	addi	sp,sp,-32
    800049ec:	ec06                	sd	ra,24(sp)
    800049ee:	e822                	sd	s0,16(sp)
    800049f0:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800049f2:	fe040593          	addi	a1,s0,-32
    800049f6:	4505                	li	a0,1
    800049f8:	ffffe097          	auipc	ra,0xffffe
    800049fc:	852080e7          	jalr	-1966(ra) # 8000224a <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004a00:	fe840613          	addi	a2,s0,-24
    80004a04:	4581                	li	a1,0
    80004a06:	4501                	li	a0,0
    80004a08:	00000097          	auipc	ra,0x0
    80004a0c:	c66080e7          	jalr	-922(ra) # 8000466e <argfd>
    80004a10:	87aa                	mv	a5,a0
    return -1;
    80004a12:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a14:	0007ca63          	bltz	a5,80004a28 <sys_fstat+0x3e>
  return filestat(f, st);
    80004a18:	fe043583          	ld	a1,-32(s0)
    80004a1c:	fe843503          	ld	a0,-24(s0)
    80004a20:	fffff097          	auipc	ra,0xfffff
    80004a24:	2de080e7          	jalr	734(ra) # 80003cfe <filestat>
}
    80004a28:	60e2                	ld	ra,24(sp)
    80004a2a:	6442                	ld	s0,16(sp)
    80004a2c:	6105                	addi	sp,sp,32
    80004a2e:	8082                	ret

0000000080004a30 <sys_link>:
{
    80004a30:	7169                	addi	sp,sp,-304
    80004a32:	f606                	sd	ra,296(sp)
    80004a34:	f222                	sd	s0,288(sp)
    80004a36:	ee26                	sd	s1,280(sp)
    80004a38:	ea4a                	sd	s2,272(sp)
    80004a3a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a3c:	08000613          	li	a2,128
    80004a40:	ed040593          	addi	a1,s0,-304
    80004a44:	4501                	li	a0,0
    80004a46:	ffffe097          	auipc	ra,0xffffe
    80004a4a:	824080e7          	jalr	-2012(ra) # 8000226a <argstr>
    return -1;
    80004a4e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a50:	10054e63          	bltz	a0,80004b6c <sys_link+0x13c>
    80004a54:	08000613          	li	a2,128
    80004a58:	f5040593          	addi	a1,s0,-176
    80004a5c:	4505                	li	a0,1
    80004a5e:	ffffe097          	auipc	ra,0xffffe
    80004a62:	80c080e7          	jalr	-2036(ra) # 8000226a <argstr>
    return -1;
    80004a66:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a68:	10054263          	bltz	a0,80004b6c <sys_link+0x13c>
  begin_op();
    80004a6c:	fffff097          	auipc	ra,0xfffff
    80004a70:	d02080e7          	jalr	-766(ra) # 8000376e <begin_op>
  if((ip = namei(old)) == 0){
    80004a74:	ed040513          	addi	a0,s0,-304
    80004a78:	fffff097          	auipc	ra,0xfffff
    80004a7c:	ad6080e7          	jalr	-1322(ra) # 8000354e <namei>
    80004a80:	84aa                	mv	s1,a0
    80004a82:	c551                	beqz	a0,80004b0e <sys_link+0xde>
  ilock(ip);
    80004a84:	ffffe097          	auipc	ra,0xffffe
    80004a88:	31e080e7          	jalr	798(ra) # 80002da2 <ilock>
  if(ip->type == T_DIR){
    80004a8c:	04449703          	lh	a4,68(s1)
    80004a90:	4785                	li	a5,1
    80004a92:	08f70463          	beq	a4,a5,80004b1a <sys_link+0xea>
  ip->nlink++;
    80004a96:	04a4d783          	lhu	a5,74(s1)
    80004a9a:	2785                	addiw	a5,a5,1
    80004a9c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004aa0:	8526                	mv	a0,s1
    80004aa2:	ffffe097          	auipc	ra,0xffffe
    80004aa6:	234080e7          	jalr	564(ra) # 80002cd6 <iupdate>
  iunlock(ip);
    80004aaa:	8526                	mv	a0,s1
    80004aac:	ffffe097          	auipc	ra,0xffffe
    80004ab0:	3b8080e7          	jalr	952(ra) # 80002e64 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004ab4:	fd040593          	addi	a1,s0,-48
    80004ab8:	f5040513          	addi	a0,s0,-176
    80004abc:	fffff097          	auipc	ra,0xfffff
    80004ac0:	ab0080e7          	jalr	-1360(ra) # 8000356c <nameiparent>
    80004ac4:	892a                	mv	s2,a0
    80004ac6:	c935                	beqz	a0,80004b3a <sys_link+0x10a>
  ilock(dp);
    80004ac8:	ffffe097          	auipc	ra,0xffffe
    80004acc:	2da080e7          	jalr	730(ra) # 80002da2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004ad0:	00092703          	lw	a4,0(s2)
    80004ad4:	409c                	lw	a5,0(s1)
    80004ad6:	04f71d63          	bne	a4,a5,80004b30 <sys_link+0x100>
    80004ada:	40d0                	lw	a2,4(s1)
    80004adc:	fd040593          	addi	a1,s0,-48
    80004ae0:	854a                	mv	a0,s2
    80004ae2:	fffff097          	auipc	ra,0xfffff
    80004ae6:	9ba080e7          	jalr	-1606(ra) # 8000349c <dirlink>
    80004aea:	04054363          	bltz	a0,80004b30 <sys_link+0x100>
  iunlockput(dp);
    80004aee:	854a                	mv	a0,s2
    80004af0:	ffffe097          	auipc	ra,0xffffe
    80004af4:	514080e7          	jalr	1300(ra) # 80003004 <iunlockput>
  iput(ip);
    80004af8:	8526                	mv	a0,s1
    80004afa:	ffffe097          	auipc	ra,0xffffe
    80004afe:	462080e7          	jalr	1122(ra) # 80002f5c <iput>
  end_op();
    80004b02:	fffff097          	auipc	ra,0xfffff
    80004b06:	cea080e7          	jalr	-790(ra) # 800037ec <end_op>
  return 0;
    80004b0a:	4781                	li	a5,0
    80004b0c:	a085                	j	80004b6c <sys_link+0x13c>
    end_op();
    80004b0e:	fffff097          	auipc	ra,0xfffff
    80004b12:	cde080e7          	jalr	-802(ra) # 800037ec <end_op>
    return -1;
    80004b16:	57fd                	li	a5,-1
    80004b18:	a891                	j	80004b6c <sys_link+0x13c>
    iunlockput(ip);
    80004b1a:	8526                	mv	a0,s1
    80004b1c:	ffffe097          	auipc	ra,0xffffe
    80004b20:	4e8080e7          	jalr	1256(ra) # 80003004 <iunlockput>
    end_op();
    80004b24:	fffff097          	auipc	ra,0xfffff
    80004b28:	cc8080e7          	jalr	-824(ra) # 800037ec <end_op>
    return -1;
    80004b2c:	57fd                	li	a5,-1
    80004b2e:	a83d                	j	80004b6c <sys_link+0x13c>
    iunlockput(dp);
    80004b30:	854a                	mv	a0,s2
    80004b32:	ffffe097          	auipc	ra,0xffffe
    80004b36:	4d2080e7          	jalr	1234(ra) # 80003004 <iunlockput>
  ilock(ip);
    80004b3a:	8526                	mv	a0,s1
    80004b3c:	ffffe097          	auipc	ra,0xffffe
    80004b40:	266080e7          	jalr	614(ra) # 80002da2 <ilock>
  ip->nlink--;
    80004b44:	04a4d783          	lhu	a5,74(s1)
    80004b48:	37fd                	addiw	a5,a5,-1
    80004b4a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b4e:	8526                	mv	a0,s1
    80004b50:	ffffe097          	auipc	ra,0xffffe
    80004b54:	186080e7          	jalr	390(ra) # 80002cd6 <iupdate>
  iunlockput(ip);
    80004b58:	8526                	mv	a0,s1
    80004b5a:	ffffe097          	auipc	ra,0xffffe
    80004b5e:	4aa080e7          	jalr	1194(ra) # 80003004 <iunlockput>
  end_op();
    80004b62:	fffff097          	auipc	ra,0xfffff
    80004b66:	c8a080e7          	jalr	-886(ra) # 800037ec <end_op>
  return -1;
    80004b6a:	57fd                	li	a5,-1
}
    80004b6c:	853e                	mv	a0,a5
    80004b6e:	70b2                	ld	ra,296(sp)
    80004b70:	7412                	ld	s0,288(sp)
    80004b72:	64f2                	ld	s1,280(sp)
    80004b74:	6952                	ld	s2,272(sp)
    80004b76:	6155                	addi	sp,sp,304
    80004b78:	8082                	ret

0000000080004b7a <sys_unlink>:
{
    80004b7a:	7151                	addi	sp,sp,-240
    80004b7c:	f586                	sd	ra,232(sp)
    80004b7e:	f1a2                	sd	s0,224(sp)
    80004b80:	eda6                	sd	s1,216(sp)
    80004b82:	e9ca                	sd	s2,208(sp)
    80004b84:	e5ce                	sd	s3,200(sp)
    80004b86:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b88:	08000613          	li	a2,128
    80004b8c:	f3040593          	addi	a1,s0,-208
    80004b90:	4501                	li	a0,0
    80004b92:	ffffd097          	auipc	ra,0xffffd
    80004b96:	6d8080e7          	jalr	1752(ra) # 8000226a <argstr>
    80004b9a:	18054163          	bltz	a0,80004d1c <sys_unlink+0x1a2>
  begin_op();
    80004b9e:	fffff097          	auipc	ra,0xfffff
    80004ba2:	bd0080e7          	jalr	-1072(ra) # 8000376e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004ba6:	fb040593          	addi	a1,s0,-80
    80004baa:	f3040513          	addi	a0,s0,-208
    80004bae:	fffff097          	auipc	ra,0xfffff
    80004bb2:	9be080e7          	jalr	-1602(ra) # 8000356c <nameiparent>
    80004bb6:	84aa                	mv	s1,a0
    80004bb8:	c979                	beqz	a0,80004c8e <sys_unlink+0x114>
  ilock(dp);
    80004bba:	ffffe097          	auipc	ra,0xffffe
    80004bbe:	1e8080e7          	jalr	488(ra) # 80002da2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004bc2:	00004597          	auipc	a1,0x4
    80004bc6:	abe58593          	addi	a1,a1,-1346 # 80008680 <syscalls+0x2a0>
    80004bca:	fb040513          	addi	a0,s0,-80
    80004bce:	ffffe097          	auipc	ra,0xffffe
    80004bd2:	69e080e7          	jalr	1694(ra) # 8000326c <namecmp>
    80004bd6:	14050a63          	beqz	a0,80004d2a <sys_unlink+0x1b0>
    80004bda:	00004597          	auipc	a1,0x4
    80004bde:	aae58593          	addi	a1,a1,-1362 # 80008688 <syscalls+0x2a8>
    80004be2:	fb040513          	addi	a0,s0,-80
    80004be6:	ffffe097          	auipc	ra,0xffffe
    80004bea:	686080e7          	jalr	1670(ra) # 8000326c <namecmp>
    80004bee:	12050e63          	beqz	a0,80004d2a <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004bf2:	f2c40613          	addi	a2,s0,-212
    80004bf6:	fb040593          	addi	a1,s0,-80
    80004bfa:	8526                	mv	a0,s1
    80004bfc:	ffffe097          	auipc	ra,0xffffe
    80004c00:	68a080e7          	jalr	1674(ra) # 80003286 <dirlookup>
    80004c04:	892a                	mv	s2,a0
    80004c06:	12050263          	beqz	a0,80004d2a <sys_unlink+0x1b0>
  ilock(ip);
    80004c0a:	ffffe097          	auipc	ra,0xffffe
    80004c0e:	198080e7          	jalr	408(ra) # 80002da2 <ilock>
  if(ip->nlink < 1)
    80004c12:	04a91783          	lh	a5,74(s2)
    80004c16:	08f05263          	blez	a5,80004c9a <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c1a:	04491703          	lh	a4,68(s2)
    80004c1e:	4785                	li	a5,1
    80004c20:	08f70563          	beq	a4,a5,80004caa <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004c24:	4641                	li	a2,16
    80004c26:	4581                	li	a1,0
    80004c28:	fc040513          	addi	a0,s0,-64
    80004c2c:	ffffb097          	auipc	ra,0xffffb
    80004c30:	692080e7          	jalr	1682(ra) # 800002be <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c34:	4741                	li	a4,16
    80004c36:	f2c42683          	lw	a3,-212(s0)
    80004c3a:	fc040613          	addi	a2,s0,-64
    80004c3e:	4581                	li	a1,0
    80004c40:	8526                	mv	a0,s1
    80004c42:	ffffe097          	auipc	ra,0xffffe
    80004c46:	50c080e7          	jalr	1292(ra) # 8000314e <writei>
    80004c4a:	47c1                	li	a5,16
    80004c4c:	0af51563          	bne	a0,a5,80004cf6 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004c50:	04491703          	lh	a4,68(s2)
    80004c54:	4785                	li	a5,1
    80004c56:	0af70863          	beq	a4,a5,80004d06 <sys_unlink+0x18c>
  iunlockput(dp);
    80004c5a:	8526                	mv	a0,s1
    80004c5c:	ffffe097          	auipc	ra,0xffffe
    80004c60:	3a8080e7          	jalr	936(ra) # 80003004 <iunlockput>
  ip->nlink--;
    80004c64:	04a95783          	lhu	a5,74(s2)
    80004c68:	37fd                	addiw	a5,a5,-1
    80004c6a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c6e:	854a                	mv	a0,s2
    80004c70:	ffffe097          	auipc	ra,0xffffe
    80004c74:	066080e7          	jalr	102(ra) # 80002cd6 <iupdate>
  iunlockput(ip);
    80004c78:	854a                	mv	a0,s2
    80004c7a:	ffffe097          	auipc	ra,0xffffe
    80004c7e:	38a080e7          	jalr	906(ra) # 80003004 <iunlockput>
  end_op();
    80004c82:	fffff097          	auipc	ra,0xfffff
    80004c86:	b6a080e7          	jalr	-1174(ra) # 800037ec <end_op>
  return 0;
    80004c8a:	4501                	li	a0,0
    80004c8c:	a84d                	j	80004d3e <sys_unlink+0x1c4>
    end_op();
    80004c8e:	fffff097          	auipc	ra,0xfffff
    80004c92:	b5e080e7          	jalr	-1186(ra) # 800037ec <end_op>
    return -1;
    80004c96:	557d                	li	a0,-1
    80004c98:	a05d                	j	80004d3e <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004c9a:	00004517          	auipc	a0,0x4
    80004c9e:	9f650513          	addi	a0,a0,-1546 # 80008690 <syscalls+0x2b0>
    80004ca2:	00001097          	auipc	ra,0x1
    80004ca6:	1ba080e7          	jalr	442(ra) # 80005e5c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004caa:	04c92703          	lw	a4,76(s2)
    80004cae:	02000793          	li	a5,32
    80004cb2:	f6e7f9e3          	bgeu	a5,a4,80004c24 <sys_unlink+0xaa>
    80004cb6:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cba:	4741                	li	a4,16
    80004cbc:	86ce                	mv	a3,s3
    80004cbe:	f1840613          	addi	a2,s0,-232
    80004cc2:	4581                	li	a1,0
    80004cc4:	854a                	mv	a0,s2
    80004cc6:	ffffe097          	auipc	ra,0xffffe
    80004cca:	390080e7          	jalr	912(ra) # 80003056 <readi>
    80004cce:	47c1                	li	a5,16
    80004cd0:	00f51b63          	bne	a0,a5,80004ce6 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004cd4:	f1845783          	lhu	a5,-232(s0)
    80004cd8:	e7a1                	bnez	a5,80004d20 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004cda:	29c1                	addiw	s3,s3,16
    80004cdc:	04c92783          	lw	a5,76(s2)
    80004ce0:	fcf9ede3          	bltu	s3,a5,80004cba <sys_unlink+0x140>
    80004ce4:	b781                	j	80004c24 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004ce6:	00004517          	auipc	a0,0x4
    80004cea:	9c250513          	addi	a0,a0,-1598 # 800086a8 <syscalls+0x2c8>
    80004cee:	00001097          	auipc	ra,0x1
    80004cf2:	16e080e7          	jalr	366(ra) # 80005e5c <panic>
    panic("unlink: writei");
    80004cf6:	00004517          	auipc	a0,0x4
    80004cfa:	9ca50513          	addi	a0,a0,-1590 # 800086c0 <syscalls+0x2e0>
    80004cfe:	00001097          	auipc	ra,0x1
    80004d02:	15e080e7          	jalr	350(ra) # 80005e5c <panic>
    dp->nlink--;
    80004d06:	04a4d783          	lhu	a5,74(s1)
    80004d0a:	37fd                	addiw	a5,a5,-1
    80004d0c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d10:	8526                	mv	a0,s1
    80004d12:	ffffe097          	auipc	ra,0xffffe
    80004d16:	fc4080e7          	jalr	-60(ra) # 80002cd6 <iupdate>
    80004d1a:	b781                	j	80004c5a <sys_unlink+0xe0>
    return -1;
    80004d1c:	557d                	li	a0,-1
    80004d1e:	a005                	j	80004d3e <sys_unlink+0x1c4>
    iunlockput(ip);
    80004d20:	854a                	mv	a0,s2
    80004d22:	ffffe097          	auipc	ra,0xffffe
    80004d26:	2e2080e7          	jalr	738(ra) # 80003004 <iunlockput>
  iunlockput(dp);
    80004d2a:	8526                	mv	a0,s1
    80004d2c:	ffffe097          	auipc	ra,0xffffe
    80004d30:	2d8080e7          	jalr	728(ra) # 80003004 <iunlockput>
  end_op();
    80004d34:	fffff097          	auipc	ra,0xfffff
    80004d38:	ab8080e7          	jalr	-1352(ra) # 800037ec <end_op>
  return -1;
    80004d3c:	557d                	li	a0,-1
}
    80004d3e:	70ae                	ld	ra,232(sp)
    80004d40:	740e                	ld	s0,224(sp)
    80004d42:	64ee                	ld	s1,216(sp)
    80004d44:	694e                	ld	s2,208(sp)
    80004d46:	69ae                	ld	s3,200(sp)
    80004d48:	616d                	addi	sp,sp,240
    80004d4a:	8082                	ret

0000000080004d4c <sys_open>:

uint64
sys_open(void)
{
    80004d4c:	7131                	addi	sp,sp,-192
    80004d4e:	fd06                	sd	ra,184(sp)
    80004d50:	f922                	sd	s0,176(sp)
    80004d52:	f526                	sd	s1,168(sp)
    80004d54:	f14a                	sd	s2,160(sp)
    80004d56:	ed4e                	sd	s3,152(sp)
    80004d58:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004d5a:	f4c40593          	addi	a1,s0,-180
    80004d5e:	4505                	li	a0,1
    80004d60:	ffffd097          	auipc	ra,0xffffd
    80004d64:	4ca080e7          	jalr	1226(ra) # 8000222a <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d68:	08000613          	li	a2,128
    80004d6c:	f5040593          	addi	a1,s0,-176
    80004d70:	4501                	li	a0,0
    80004d72:	ffffd097          	auipc	ra,0xffffd
    80004d76:	4f8080e7          	jalr	1272(ra) # 8000226a <argstr>
    80004d7a:	87aa                	mv	a5,a0
    return -1;
    80004d7c:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d7e:	0a07c963          	bltz	a5,80004e30 <sys_open+0xe4>

  begin_op();
    80004d82:	fffff097          	auipc	ra,0xfffff
    80004d86:	9ec080e7          	jalr	-1556(ra) # 8000376e <begin_op>

  if(omode & O_CREATE){
    80004d8a:	f4c42783          	lw	a5,-180(s0)
    80004d8e:	2007f793          	andi	a5,a5,512
    80004d92:	cfc5                	beqz	a5,80004e4a <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d94:	4681                	li	a3,0
    80004d96:	4601                	li	a2,0
    80004d98:	4589                	li	a1,2
    80004d9a:	f5040513          	addi	a0,s0,-176
    80004d9e:	00000097          	auipc	ra,0x0
    80004da2:	972080e7          	jalr	-1678(ra) # 80004710 <create>
    80004da6:	84aa                	mv	s1,a0
    if(ip == 0){
    80004da8:	c959                	beqz	a0,80004e3e <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004daa:	04449703          	lh	a4,68(s1)
    80004dae:	478d                	li	a5,3
    80004db0:	00f71763          	bne	a4,a5,80004dbe <sys_open+0x72>
    80004db4:	0464d703          	lhu	a4,70(s1)
    80004db8:	47a5                	li	a5,9
    80004dba:	0ce7ed63          	bltu	a5,a4,80004e94 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004dbe:	fffff097          	auipc	ra,0xfffff
    80004dc2:	dbc080e7          	jalr	-580(ra) # 80003b7a <filealloc>
    80004dc6:	89aa                	mv	s3,a0
    80004dc8:	10050363          	beqz	a0,80004ece <sys_open+0x182>
    80004dcc:	00000097          	auipc	ra,0x0
    80004dd0:	902080e7          	jalr	-1790(ra) # 800046ce <fdalloc>
    80004dd4:	892a                	mv	s2,a0
    80004dd6:	0e054763          	bltz	a0,80004ec4 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004dda:	04449703          	lh	a4,68(s1)
    80004dde:	478d                	li	a5,3
    80004de0:	0cf70563          	beq	a4,a5,80004eaa <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004de4:	4789                	li	a5,2
    80004de6:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004dea:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004dee:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004df2:	f4c42783          	lw	a5,-180(s0)
    80004df6:	0017c713          	xori	a4,a5,1
    80004dfa:	8b05                	andi	a4,a4,1
    80004dfc:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e00:	0037f713          	andi	a4,a5,3
    80004e04:	00e03733          	snez	a4,a4
    80004e08:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e0c:	4007f793          	andi	a5,a5,1024
    80004e10:	c791                	beqz	a5,80004e1c <sys_open+0xd0>
    80004e12:	04449703          	lh	a4,68(s1)
    80004e16:	4789                	li	a5,2
    80004e18:	0af70063          	beq	a4,a5,80004eb8 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004e1c:	8526                	mv	a0,s1
    80004e1e:	ffffe097          	auipc	ra,0xffffe
    80004e22:	046080e7          	jalr	70(ra) # 80002e64 <iunlock>
  end_op();
    80004e26:	fffff097          	auipc	ra,0xfffff
    80004e2a:	9c6080e7          	jalr	-1594(ra) # 800037ec <end_op>

  return fd;
    80004e2e:	854a                	mv	a0,s2
}
    80004e30:	70ea                	ld	ra,184(sp)
    80004e32:	744a                	ld	s0,176(sp)
    80004e34:	74aa                	ld	s1,168(sp)
    80004e36:	790a                	ld	s2,160(sp)
    80004e38:	69ea                	ld	s3,152(sp)
    80004e3a:	6129                	addi	sp,sp,192
    80004e3c:	8082                	ret
      end_op();
    80004e3e:	fffff097          	auipc	ra,0xfffff
    80004e42:	9ae080e7          	jalr	-1618(ra) # 800037ec <end_op>
      return -1;
    80004e46:	557d                	li	a0,-1
    80004e48:	b7e5                	j	80004e30 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004e4a:	f5040513          	addi	a0,s0,-176
    80004e4e:	ffffe097          	auipc	ra,0xffffe
    80004e52:	700080e7          	jalr	1792(ra) # 8000354e <namei>
    80004e56:	84aa                	mv	s1,a0
    80004e58:	c905                	beqz	a0,80004e88 <sys_open+0x13c>
    ilock(ip);
    80004e5a:	ffffe097          	auipc	ra,0xffffe
    80004e5e:	f48080e7          	jalr	-184(ra) # 80002da2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e62:	04449703          	lh	a4,68(s1)
    80004e66:	4785                	li	a5,1
    80004e68:	f4f711e3          	bne	a4,a5,80004daa <sys_open+0x5e>
    80004e6c:	f4c42783          	lw	a5,-180(s0)
    80004e70:	d7b9                	beqz	a5,80004dbe <sys_open+0x72>
      iunlockput(ip);
    80004e72:	8526                	mv	a0,s1
    80004e74:	ffffe097          	auipc	ra,0xffffe
    80004e78:	190080e7          	jalr	400(ra) # 80003004 <iunlockput>
      end_op();
    80004e7c:	fffff097          	auipc	ra,0xfffff
    80004e80:	970080e7          	jalr	-1680(ra) # 800037ec <end_op>
      return -1;
    80004e84:	557d                	li	a0,-1
    80004e86:	b76d                	j	80004e30 <sys_open+0xe4>
      end_op();
    80004e88:	fffff097          	auipc	ra,0xfffff
    80004e8c:	964080e7          	jalr	-1692(ra) # 800037ec <end_op>
      return -1;
    80004e90:	557d                	li	a0,-1
    80004e92:	bf79                	j	80004e30 <sys_open+0xe4>
    iunlockput(ip);
    80004e94:	8526                	mv	a0,s1
    80004e96:	ffffe097          	auipc	ra,0xffffe
    80004e9a:	16e080e7          	jalr	366(ra) # 80003004 <iunlockput>
    end_op();
    80004e9e:	fffff097          	auipc	ra,0xfffff
    80004ea2:	94e080e7          	jalr	-1714(ra) # 800037ec <end_op>
    return -1;
    80004ea6:	557d                	li	a0,-1
    80004ea8:	b761                	j	80004e30 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004eaa:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004eae:	04649783          	lh	a5,70(s1)
    80004eb2:	02f99223          	sh	a5,36(s3)
    80004eb6:	bf25                	j	80004dee <sys_open+0xa2>
    itrunc(ip);
    80004eb8:	8526                	mv	a0,s1
    80004eba:	ffffe097          	auipc	ra,0xffffe
    80004ebe:	ff6080e7          	jalr	-10(ra) # 80002eb0 <itrunc>
    80004ec2:	bfa9                	j	80004e1c <sys_open+0xd0>
      fileclose(f);
    80004ec4:	854e                	mv	a0,s3
    80004ec6:	fffff097          	auipc	ra,0xfffff
    80004eca:	d70080e7          	jalr	-656(ra) # 80003c36 <fileclose>
    iunlockput(ip);
    80004ece:	8526                	mv	a0,s1
    80004ed0:	ffffe097          	auipc	ra,0xffffe
    80004ed4:	134080e7          	jalr	308(ra) # 80003004 <iunlockput>
    end_op();
    80004ed8:	fffff097          	auipc	ra,0xfffff
    80004edc:	914080e7          	jalr	-1772(ra) # 800037ec <end_op>
    return -1;
    80004ee0:	557d                	li	a0,-1
    80004ee2:	b7b9                	j	80004e30 <sys_open+0xe4>

0000000080004ee4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ee4:	7175                	addi	sp,sp,-144
    80004ee6:	e506                	sd	ra,136(sp)
    80004ee8:	e122                	sd	s0,128(sp)
    80004eea:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004eec:	fffff097          	auipc	ra,0xfffff
    80004ef0:	882080e7          	jalr	-1918(ra) # 8000376e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004ef4:	08000613          	li	a2,128
    80004ef8:	f7040593          	addi	a1,s0,-144
    80004efc:	4501                	li	a0,0
    80004efe:	ffffd097          	auipc	ra,0xffffd
    80004f02:	36c080e7          	jalr	876(ra) # 8000226a <argstr>
    80004f06:	02054963          	bltz	a0,80004f38 <sys_mkdir+0x54>
    80004f0a:	4681                	li	a3,0
    80004f0c:	4601                	li	a2,0
    80004f0e:	4585                	li	a1,1
    80004f10:	f7040513          	addi	a0,s0,-144
    80004f14:	fffff097          	auipc	ra,0xfffff
    80004f18:	7fc080e7          	jalr	2044(ra) # 80004710 <create>
    80004f1c:	cd11                	beqz	a0,80004f38 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f1e:	ffffe097          	auipc	ra,0xffffe
    80004f22:	0e6080e7          	jalr	230(ra) # 80003004 <iunlockput>
  end_op();
    80004f26:	fffff097          	auipc	ra,0xfffff
    80004f2a:	8c6080e7          	jalr	-1850(ra) # 800037ec <end_op>
  return 0;
    80004f2e:	4501                	li	a0,0
}
    80004f30:	60aa                	ld	ra,136(sp)
    80004f32:	640a                	ld	s0,128(sp)
    80004f34:	6149                	addi	sp,sp,144
    80004f36:	8082                	ret
    end_op();
    80004f38:	fffff097          	auipc	ra,0xfffff
    80004f3c:	8b4080e7          	jalr	-1868(ra) # 800037ec <end_op>
    return -1;
    80004f40:	557d                	li	a0,-1
    80004f42:	b7fd                	j	80004f30 <sys_mkdir+0x4c>

0000000080004f44 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f44:	7135                	addi	sp,sp,-160
    80004f46:	ed06                	sd	ra,152(sp)
    80004f48:	e922                	sd	s0,144(sp)
    80004f4a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f4c:	fffff097          	auipc	ra,0xfffff
    80004f50:	822080e7          	jalr	-2014(ra) # 8000376e <begin_op>
  argint(1, &major);
    80004f54:	f6c40593          	addi	a1,s0,-148
    80004f58:	4505                	li	a0,1
    80004f5a:	ffffd097          	auipc	ra,0xffffd
    80004f5e:	2d0080e7          	jalr	720(ra) # 8000222a <argint>
  argint(2, &minor);
    80004f62:	f6840593          	addi	a1,s0,-152
    80004f66:	4509                	li	a0,2
    80004f68:	ffffd097          	auipc	ra,0xffffd
    80004f6c:	2c2080e7          	jalr	706(ra) # 8000222a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f70:	08000613          	li	a2,128
    80004f74:	f7040593          	addi	a1,s0,-144
    80004f78:	4501                	li	a0,0
    80004f7a:	ffffd097          	auipc	ra,0xffffd
    80004f7e:	2f0080e7          	jalr	752(ra) # 8000226a <argstr>
    80004f82:	02054b63          	bltz	a0,80004fb8 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f86:	f6841683          	lh	a3,-152(s0)
    80004f8a:	f6c41603          	lh	a2,-148(s0)
    80004f8e:	458d                	li	a1,3
    80004f90:	f7040513          	addi	a0,s0,-144
    80004f94:	fffff097          	auipc	ra,0xfffff
    80004f98:	77c080e7          	jalr	1916(ra) # 80004710 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f9c:	cd11                	beqz	a0,80004fb8 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f9e:	ffffe097          	auipc	ra,0xffffe
    80004fa2:	066080e7          	jalr	102(ra) # 80003004 <iunlockput>
  end_op();
    80004fa6:	fffff097          	auipc	ra,0xfffff
    80004faa:	846080e7          	jalr	-1978(ra) # 800037ec <end_op>
  return 0;
    80004fae:	4501                	li	a0,0
}
    80004fb0:	60ea                	ld	ra,152(sp)
    80004fb2:	644a                	ld	s0,144(sp)
    80004fb4:	610d                	addi	sp,sp,160
    80004fb6:	8082                	ret
    end_op();
    80004fb8:	fffff097          	auipc	ra,0xfffff
    80004fbc:	834080e7          	jalr	-1996(ra) # 800037ec <end_op>
    return -1;
    80004fc0:	557d                	li	a0,-1
    80004fc2:	b7fd                	j	80004fb0 <sys_mknod+0x6c>

0000000080004fc4 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004fc4:	7135                	addi	sp,sp,-160
    80004fc6:	ed06                	sd	ra,152(sp)
    80004fc8:	e922                	sd	s0,144(sp)
    80004fca:	e526                	sd	s1,136(sp)
    80004fcc:	e14a                	sd	s2,128(sp)
    80004fce:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004fd0:	ffffc097          	auipc	ra,0xffffc
    80004fd4:	fde080e7          	jalr	-34(ra) # 80000fae <myproc>
    80004fd8:	892a                	mv	s2,a0
  
  begin_op();
    80004fda:	ffffe097          	auipc	ra,0xffffe
    80004fde:	794080e7          	jalr	1940(ra) # 8000376e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004fe2:	08000613          	li	a2,128
    80004fe6:	f6040593          	addi	a1,s0,-160
    80004fea:	4501                	li	a0,0
    80004fec:	ffffd097          	auipc	ra,0xffffd
    80004ff0:	27e080e7          	jalr	638(ra) # 8000226a <argstr>
    80004ff4:	04054b63          	bltz	a0,8000504a <sys_chdir+0x86>
    80004ff8:	f6040513          	addi	a0,s0,-160
    80004ffc:	ffffe097          	auipc	ra,0xffffe
    80005000:	552080e7          	jalr	1362(ra) # 8000354e <namei>
    80005004:	84aa                	mv	s1,a0
    80005006:	c131                	beqz	a0,8000504a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005008:	ffffe097          	auipc	ra,0xffffe
    8000500c:	d9a080e7          	jalr	-614(ra) # 80002da2 <ilock>
  if(ip->type != T_DIR){
    80005010:	04449703          	lh	a4,68(s1)
    80005014:	4785                	li	a5,1
    80005016:	04f71063          	bne	a4,a5,80005056 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000501a:	8526                	mv	a0,s1
    8000501c:	ffffe097          	auipc	ra,0xffffe
    80005020:	e48080e7          	jalr	-440(ra) # 80002e64 <iunlock>
  iput(p->cwd);
    80005024:	15093503          	ld	a0,336(s2)
    80005028:	ffffe097          	auipc	ra,0xffffe
    8000502c:	f34080e7          	jalr	-204(ra) # 80002f5c <iput>
  end_op();
    80005030:	ffffe097          	auipc	ra,0xffffe
    80005034:	7bc080e7          	jalr	1980(ra) # 800037ec <end_op>
  p->cwd = ip;
    80005038:	14993823          	sd	s1,336(s2)
  return 0;
    8000503c:	4501                	li	a0,0
}
    8000503e:	60ea                	ld	ra,152(sp)
    80005040:	644a                	ld	s0,144(sp)
    80005042:	64aa                	ld	s1,136(sp)
    80005044:	690a                	ld	s2,128(sp)
    80005046:	610d                	addi	sp,sp,160
    80005048:	8082                	ret
    end_op();
    8000504a:	ffffe097          	auipc	ra,0xffffe
    8000504e:	7a2080e7          	jalr	1954(ra) # 800037ec <end_op>
    return -1;
    80005052:	557d                	li	a0,-1
    80005054:	b7ed                	j	8000503e <sys_chdir+0x7a>
    iunlockput(ip);
    80005056:	8526                	mv	a0,s1
    80005058:	ffffe097          	auipc	ra,0xffffe
    8000505c:	fac080e7          	jalr	-84(ra) # 80003004 <iunlockput>
    end_op();
    80005060:	ffffe097          	auipc	ra,0xffffe
    80005064:	78c080e7          	jalr	1932(ra) # 800037ec <end_op>
    return -1;
    80005068:	557d                	li	a0,-1
    8000506a:	bfd1                	j	8000503e <sys_chdir+0x7a>

000000008000506c <sys_exec>:

uint64
sys_exec(void)
{
    8000506c:	7145                	addi	sp,sp,-464
    8000506e:	e786                	sd	ra,456(sp)
    80005070:	e3a2                	sd	s0,448(sp)
    80005072:	ff26                	sd	s1,440(sp)
    80005074:	fb4a                	sd	s2,432(sp)
    80005076:	f74e                	sd	s3,424(sp)
    80005078:	f352                	sd	s4,416(sp)
    8000507a:	ef56                	sd	s5,408(sp)
    8000507c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000507e:	e3840593          	addi	a1,s0,-456
    80005082:	4505                	li	a0,1
    80005084:	ffffd097          	auipc	ra,0xffffd
    80005088:	1c6080e7          	jalr	454(ra) # 8000224a <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000508c:	08000613          	li	a2,128
    80005090:	f4040593          	addi	a1,s0,-192
    80005094:	4501                	li	a0,0
    80005096:	ffffd097          	auipc	ra,0xffffd
    8000509a:	1d4080e7          	jalr	468(ra) # 8000226a <argstr>
    8000509e:	87aa                	mv	a5,a0
    return -1;
    800050a0:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800050a2:	0c07c363          	bltz	a5,80005168 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    800050a6:	10000613          	li	a2,256
    800050aa:	4581                	li	a1,0
    800050ac:	e4040513          	addi	a0,s0,-448
    800050b0:	ffffb097          	auipc	ra,0xffffb
    800050b4:	20e080e7          	jalr	526(ra) # 800002be <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800050b8:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    800050bc:	89a6                	mv	s3,s1
    800050be:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800050c0:	02000a13          	li	s4,32
    800050c4:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800050c8:	00391513          	slli	a0,s2,0x3
    800050cc:	e3040593          	addi	a1,s0,-464
    800050d0:	e3843783          	ld	a5,-456(s0)
    800050d4:	953e                	add	a0,a0,a5
    800050d6:	ffffd097          	auipc	ra,0xffffd
    800050da:	0b6080e7          	jalr	182(ra) # 8000218c <fetchaddr>
    800050de:	02054a63          	bltz	a0,80005112 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    800050e2:	e3043783          	ld	a5,-464(s0)
    800050e6:	c3b9                	beqz	a5,8000512c <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800050e8:	ffffb097          	auipc	ra,0xffffb
    800050ec:	0be080e7          	jalr	190(ra) # 800001a6 <kalloc>
    800050f0:	85aa                	mv	a1,a0
    800050f2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800050f6:	cd11                	beqz	a0,80005112 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800050f8:	6605                	lui	a2,0x1
    800050fa:	e3043503          	ld	a0,-464(s0)
    800050fe:	ffffd097          	auipc	ra,0xffffd
    80005102:	0e0080e7          	jalr	224(ra) # 800021de <fetchstr>
    80005106:	00054663          	bltz	a0,80005112 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    8000510a:	0905                	addi	s2,s2,1
    8000510c:	09a1                	addi	s3,s3,8
    8000510e:	fb491be3          	bne	s2,s4,800050c4 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005112:	f4040913          	addi	s2,s0,-192
    80005116:	6088                	ld	a0,0(s1)
    80005118:	c539                	beqz	a0,80005166 <sys_exec+0xfa>
    kfree(argv[i]);
    8000511a:	ffffb097          	auipc	ra,0xffffb
    8000511e:	f02080e7          	jalr	-254(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005122:	04a1                	addi	s1,s1,8
    80005124:	ff2499e3          	bne	s1,s2,80005116 <sys_exec+0xaa>
  return -1;
    80005128:	557d                	li	a0,-1
    8000512a:	a83d                	j	80005168 <sys_exec+0xfc>
      argv[i] = 0;
    8000512c:	0a8e                	slli	s5,s5,0x3
    8000512e:	fc0a8793          	addi	a5,s5,-64
    80005132:	00878ab3          	add	s5,a5,s0
    80005136:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000513a:	e4040593          	addi	a1,s0,-448
    8000513e:	f4040513          	addi	a0,s0,-192
    80005142:	fffff097          	auipc	ra,0xfffff
    80005146:	16e080e7          	jalr	366(ra) # 800042b0 <exec>
    8000514a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000514c:	f4040993          	addi	s3,s0,-192
    80005150:	6088                	ld	a0,0(s1)
    80005152:	c901                	beqz	a0,80005162 <sys_exec+0xf6>
    kfree(argv[i]);
    80005154:	ffffb097          	auipc	ra,0xffffb
    80005158:	ec8080e7          	jalr	-312(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000515c:	04a1                	addi	s1,s1,8
    8000515e:	ff3499e3          	bne	s1,s3,80005150 <sys_exec+0xe4>
  return ret;
    80005162:	854a                	mv	a0,s2
    80005164:	a011                	j	80005168 <sys_exec+0xfc>
  return -1;
    80005166:	557d                	li	a0,-1
}
    80005168:	60be                	ld	ra,456(sp)
    8000516a:	641e                	ld	s0,448(sp)
    8000516c:	74fa                	ld	s1,440(sp)
    8000516e:	795a                	ld	s2,432(sp)
    80005170:	79ba                	ld	s3,424(sp)
    80005172:	7a1a                	ld	s4,416(sp)
    80005174:	6afa                	ld	s5,408(sp)
    80005176:	6179                	addi	sp,sp,464
    80005178:	8082                	ret

000000008000517a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000517a:	7139                	addi	sp,sp,-64
    8000517c:	fc06                	sd	ra,56(sp)
    8000517e:	f822                	sd	s0,48(sp)
    80005180:	f426                	sd	s1,40(sp)
    80005182:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005184:	ffffc097          	auipc	ra,0xffffc
    80005188:	e2a080e7          	jalr	-470(ra) # 80000fae <myproc>
    8000518c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000518e:	fd840593          	addi	a1,s0,-40
    80005192:	4501                	li	a0,0
    80005194:	ffffd097          	auipc	ra,0xffffd
    80005198:	0b6080e7          	jalr	182(ra) # 8000224a <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000519c:	fc840593          	addi	a1,s0,-56
    800051a0:	fd040513          	addi	a0,s0,-48
    800051a4:	fffff097          	auipc	ra,0xfffff
    800051a8:	dc2080e7          	jalr	-574(ra) # 80003f66 <pipealloc>
    return -1;
    800051ac:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800051ae:	0c054463          	bltz	a0,80005276 <sys_pipe+0xfc>
  fd0 = -1;
    800051b2:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800051b6:	fd043503          	ld	a0,-48(s0)
    800051ba:	fffff097          	auipc	ra,0xfffff
    800051be:	514080e7          	jalr	1300(ra) # 800046ce <fdalloc>
    800051c2:	fca42223          	sw	a0,-60(s0)
    800051c6:	08054b63          	bltz	a0,8000525c <sys_pipe+0xe2>
    800051ca:	fc843503          	ld	a0,-56(s0)
    800051ce:	fffff097          	auipc	ra,0xfffff
    800051d2:	500080e7          	jalr	1280(ra) # 800046ce <fdalloc>
    800051d6:	fca42023          	sw	a0,-64(s0)
    800051da:	06054863          	bltz	a0,8000524a <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051de:	4691                	li	a3,4
    800051e0:	fc440613          	addi	a2,s0,-60
    800051e4:	fd843583          	ld	a1,-40(s0)
    800051e8:	68a8                	ld	a0,80(s1)
    800051ea:	ffffc097          	auipc	ra,0xffffc
    800051ee:	a56080e7          	jalr	-1450(ra) # 80000c40 <copyout>
    800051f2:	02054063          	bltz	a0,80005212 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800051f6:	4691                	li	a3,4
    800051f8:	fc040613          	addi	a2,s0,-64
    800051fc:	fd843583          	ld	a1,-40(s0)
    80005200:	0591                	addi	a1,a1,4
    80005202:	68a8                	ld	a0,80(s1)
    80005204:	ffffc097          	auipc	ra,0xffffc
    80005208:	a3c080e7          	jalr	-1476(ra) # 80000c40 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000520c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000520e:	06055463          	bgez	a0,80005276 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005212:	fc442783          	lw	a5,-60(s0)
    80005216:	07e9                	addi	a5,a5,26
    80005218:	078e                	slli	a5,a5,0x3
    8000521a:	97a6                	add	a5,a5,s1
    8000521c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005220:	fc042783          	lw	a5,-64(s0)
    80005224:	07e9                	addi	a5,a5,26
    80005226:	078e                	slli	a5,a5,0x3
    80005228:	94be                	add	s1,s1,a5
    8000522a:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000522e:	fd043503          	ld	a0,-48(s0)
    80005232:	fffff097          	auipc	ra,0xfffff
    80005236:	a04080e7          	jalr	-1532(ra) # 80003c36 <fileclose>
    fileclose(wf);
    8000523a:	fc843503          	ld	a0,-56(s0)
    8000523e:	fffff097          	auipc	ra,0xfffff
    80005242:	9f8080e7          	jalr	-1544(ra) # 80003c36 <fileclose>
    return -1;
    80005246:	57fd                	li	a5,-1
    80005248:	a03d                	j	80005276 <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000524a:	fc442783          	lw	a5,-60(s0)
    8000524e:	0007c763          	bltz	a5,8000525c <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005252:	07e9                	addi	a5,a5,26
    80005254:	078e                	slli	a5,a5,0x3
    80005256:	97a6                	add	a5,a5,s1
    80005258:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000525c:	fd043503          	ld	a0,-48(s0)
    80005260:	fffff097          	auipc	ra,0xfffff
    80005264:	9d6080e7          	jalr	-1578(ra) # 80003c36 <fileclose>
    fileclose(wf);
    80005268:	fc843503          	ld	a0,-56(s0)
    8000526c:	fffff097          	auipc	ra,0xfffff
    80005270:	9ca080e7          	jalr	-1590(ra) # 80003c36 <fileclose>
    return -1;
    80005274:	57fd                	li	a5,-1
}
    80005276:	853e                	mv	a0,a5
    80005278:	70e2                	ld	ra,56(sp)
    8000527a:	7442                	ld	s0,48(sp)
    8000527c:	74a2                	ld	s1,40(sp)
    8000527e:	6121                	addi	sp,sp,64
    80005280:	8082                	ret
	...

0000000080005290 <kernelvec>:
    80005290:	7111                	addi	sp,sp,-256
    80005292:	e006                	sd	ra,0(sp)
    80005294:	e40a                	sd	sp,8(sp)
    80005296:	e80e                	sd	gp,16(sp)
    80005298:	ec12                	sd	tp,24(sp)
    8000529a:	f016                	sd	t0,32(sp)
    8000529c:	f41a                	sd	t1,40(sp)
    8000529e:	f81e                	sd	t2,48(sp)
    800052a0:	fc22                	sd	s0,56(sp)
    800052a2:	e0a6                	sd	s1,64(sp)
    800052a4:	e4aa                	sd	a0,72(sp)
    800052a6:	e8ae                	sd	a1,80(sp)
    800052a8:	ecb2                	sd	a2,88(sp)
    800052aa:	f0b6                	sd	a3,96(sp)
    800052ac:	f4ba                	sd	a4,104(sp)
    800052ae:	f8be                	sd	a5,112(sp)
    800052b0:	fcc2                	sd	a6,120(sp)
    800052b2:	e146                	sd	a7,128(sp)
    800052b4:	e54a                	sd	s2,136(sp)
    800052b6:	e94e                	sd	s3,144(sp)
    800052b8:	ed52                	sd	s4,152(sp)
    800052ba:	f156                	sd	s5,160(sp)
    800052bc:	f55a                	sd	s6,168(sp)
    800052be:	f95e                	sd	s7,176(sp)
    800052c0:	fd62                	sd	s8,184(sp)
    800052c2:	e1e6                	sd	s9,192(sp)
    800052c4:	e5ea                	sd	s10,200(sp)
    800052c6:	e9ee                	sd	s11,208(sp)
    800052c8:	edf2                	sd	t3,216(sp)
    800052ca:	f1f6                	sd	t4,224(sp)
    800052cc:	f5fa                	sd	t5,232(sp)
    800052ce:	f9fe                	sd	t6,240(sp)
    800052d0:	b13fc0ef          	jal	ra,80001de2 <kerneltrap>
    800052d4:	6082                	ld	ra,0(sp)
    800052d6:	6122                	ld	sp,8(sp)
    800052d8:	61c2                	ld	gp,16(sp)
    800052da:	7282                	ld	t0,32(sp)
    800052dc:	7322                	ld	t1,40(sp)
    800052de:	73c2                	ld	t2,48(sp)
    800052e0:	7462                	ld	s0,56(sp)
    800052e2:	6486                	ld	s1,64(sp)
    800052e4:	6526                	ld	a0,72(sp)
    800052e6:	65c6                	ld	a1,80(sp)
    800052e8:	6666                	ld	a2,88(sp)
    800052ea:	7686                	ld	a3,96(sp)
    800052ec:	7726                	ld	a4,104(sp)
    800052ee:	77c6                	ld	a5,112(sp)
    800052f0:	7866                	ld	a6,120(sp)
    800052f2:	688a                	ld	a7,128(sp)
    800052f4:	692a                	ld	s2,136(sp)
    800052f6:	69ca                	ld	s3,144(sp)
    800052f8:	6a6a                	ld	s4,152(sp)
    800052fa:	7a8a                	ld	s5,160(sp)
    800052fc:	7b2a                	ld	s6,168(sp)
    800052fe:	7bca                	ld	s7,176(sp)
    80005300:	7c6a                	ld	s8,184(sp)
    80005302:	6c8e                	ld	s9,192(sp)
    80005304:	6d2e                	ld	s10,200(sp)
    80005306:	6dce                	ld	s11,208(sp)
    80005308:	6e6e                	ld	t3,216(sp)
    8000530a:	7e8e                	ld	t4,224(sp)
    8000530c:	7f2e                	ld	t5,232(sp)
    8000530e:	7fce                	ld	t6,240(sp)
    80005310:	6111                	addi	sp,sp,256
    80005312:	10200073          	sret
    80005316:	00000013          	nop
    8000531a:	00000013          	nop
    8000531e:	0001                	nop

0000000080005320 <timervec>:
    80005320:	34051573          	csrrw	a0,mscratch,a0
    80005324:	e10c                	sd	a1,0(a0)
    80005326:	e510                	sd	a2,8(a0)
    80005328:	e914                	sd	a3,16(a0)
    8000532a:	6d0c                	ld	a1,24(a0)
    8000532c:	7110                	ld	a2,32(a0)
    8000532e:	6194                	ld	a3,0(a1)
    80005330:	96b2                	add	a3,a3,a2
    80005332:	e194                	sd	a3,0(a1)
    80005334:	4589                	li	a1,2
    80005336:	14459073          	csrw	sip,a1
    8000533a:	6914                	ld	a3,16(a0)
    8000533c:	6510                	ld	a2,8(a0)
    8000533e:	610c                	ld	a1,0(a0)
    80005340:	34051573          	csrrw	a0,mscratch,a0
    80005344:	30200073          	mret
	...

000000008000534a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000534a:	1141                	addi	sp,sp,-16
    8000534c:	e422                	sd	s0,8(sp)
    8000534e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005350:	0c0007b7          	lui	a5,0xc000
    80005354:	4705                	li	a4,1
    80005356:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005358:	c3d8                	sw	a4,4(a5)
}
    8000535a:	6422                	ld	s0,8(sp)
    8000535c:	0141                	addi	sp,sp,16
    8000535e:	8082                	ret

0000000080005360 <plicinithart>:

void
plicinithart(void)
{
    80005360:	1141                	addi	sp,sp,-16
    80005362:	e406                	sd	ra,8(sp)
    80005364:	e022                	sd	s0,0(sp)
    80005366:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005368:	ffffc097          	auipc	ra,0xffffc
    8000536c:	c1a080e7          	jalr	-998(ra) # 80000f82 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005370:	0085171b          	slliw	a4,a0,0x8
    80005374:	0c0027b7          	lui	a5,0xc002
    80005378:	97ba                	add	a5,a5,a4
    8000537a:	40200713          	li	a4,1026
    8000537e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005382:	00d5151b          	slliw	a0,a0,0xd
    80005386:	0c2017b7          	lui	a5,0xc201
    8000538a:	97aa                	add	a5,a5,a0
    8000538c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005390:	60a2                	ld	ra,8(sp)
    80005392:	6402                	ld	s0,0(sp)
    80005394:	0141                	addi	sp,sp,16
    80005396:	8082                	ret

0000000080005398 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005398:	1141                	addi	sp,sp,-16
    8000539a:	e406                	sd	ra,8(sp)
    8000539c:	e022                	sd	s0,0(sp)
    8000539e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053a0:	ffffc097          	auipc	ra,0xffffc
    800053a4:	be2080e7          	jalr	-1054(ra) # 80000f82 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800053a8:	00d5151b          	slliw	a0,a0,0xd
    800053ac:	0c2017b7          	lui	a5,0xc201
    800053b0:	97aa                	add	a5,a5,a0
  return irq;
}
    800053b2:	43c8                	lw	a0,4(a5)
    800053b4:	60a2                	ld	ra,8(sp)
    800053b6:	6402                	ld	s0,0(sp)
    800053b8:	0141                	addi	sp,sp,16
    800053ba:	8082                	ret

00000000800053bc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800053bc:	1101                	addi	sp,sp,-32
    800053be:	ec06                	sd	ra,24(sp)
    800053c0:	e822                	sd	s0,16(sp)
    800053c2:	e426                	sd	s1,8(sp)
    800053c4:	1000                	addi	s0,sp,32
    800053c6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800053c8:	ffffc097          	auipc	ra,0xffffc
    800053cc:	bba080e7          	jalr	-1094(ra) # 80000f82 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800053d0:	00d5151b          	slliw	a0,a0,0xd
    800053d4:	0c2017b7          	lui	a5,0xc201
    800053d8:	97aa                	add	a5,a5,a0
    800053da:	c3c4                	sw	s1,4(a5)
}
    800053dc:	60e2                	ld	ra,24(sp)
    800053de:	6442                	ld	s0,16(sp)
    800053e0:	64a2                	ld	s1,8(sp)
    800053e2:	6105                	addi	sp,sp,32
    800053e4:	8082                	ret

00000000800053e6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800053e6:	1141                	addi	sp,sp,-16
    800053e8:	e406                	sd	ra,8(sp)
    800053ea:	e022                	sd	s0,0(sp)
    800053ec:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800053ee:	479d                	li	a5,7
    800053f0:	04a7cc63          	blt	a5,a0,80005448 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800053f4:	00234797          	auipc	a5,0x234
    800053f8:	60478793          	addi	a5,a5,1540 # 802399f8 <disk>
    800053fc:	97aa                	add	a5,a5,a0
    800053fe:	0187c783          	lbu	a5,24(a5)
    80005402:	ebb9                	bnez	a5,80005458 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005404:	00451693          	slli	a3,a0,0x4
    80005408:	00234797          	auipc	a5,0x234
    8000540c:	5f078793          	addi	a5,a5,1520 # 802399f8 <disk>
    80005410:	6398                	ld	a4,0(a5)
    80005412:	9736                	add	a4,a4,a3
    80005414:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005418:	6398                	ld	a4,0(a5)
    8000541a:	9736                	add	a4,a4,a3
    8000541c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005420:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005424:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005428:	97aa                	add	a5,a5,a0
    8000542a:	4705                	li	a4,1
    8000542c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005430:	00234517          	auipc	a0,0x234
    80005434:	5e050513          	addi	a0,a0,1504 # 80239a10 <disk+0x18>
    80005438:	ffffc097          	auipc	ra,0xffffc
    8000543c:	282080e7          	jalr	642(ra) # 800016ba <wakeup>
}
    80005440:	60a2                	ld	ra,8(sp)
    80005442:	6402                	ld	s0,0(sp)
    80005444:	0141                	addi	sp,sp,16
    80005446:	8082                	ret
    panic("free_desc 1");
    80005448:	00003517          	auipc	a0,0x3
    8000544c:	28850513          	addi	a0,a0,648 # 800086d0 <syscalls+0x2f0>
    80005450:	00001097          	auipc	ra,0x1
    80005454:	a0c080e7          	jalr	-1524(ra) # 80005e5c <panic>
    panic("free_desc 2");
    80005458:	00003517          	auipc	a0,0x3
    8000545c:	28850513          	addi	a0,a0,648 # 800086e0 <syscalls+0x300>
    80005460:	00001097          	auipc	ra,0x1
    80005464:	9fc080e7          	jalr	-1540(ra) # 80005e5c <panic>

0000000080005468 <virtio_disk_init>:
{
    80005468:	1101                	addi	sp,sp,-32
    8000546a:	ec06                	sd	ra,24(sp)
    8000546c:	e822                	sd	s0,16(sp)
    8000546e:	e426                	sd	s1,8(sp)
    80005470:	e04a                	sd	s2,0(sp)
    80005472:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005474:	00003597          	auipc	a1,0x3
    80005478:	27c58593          	addi	a1,a1,636 # 800086f0 <syscalls+0x310>
    8000547c:	00234517          	auipc	a0,0x234
    80005480:	6a450513          	addi	a0,a0,1700 # 80239b20 <disk+0x128>
    80005484:	00001097          	auipc	ra,0x1
    80005488:	e80080e7          	jalr	-384(ra) # 80006304 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000548c:	100017b7          	lui	a5,0x10001
    80005490:	4398                	lw	a4,0(a5)
    80005492:	2701                	sext.w	a4,a4
    80005494:	747277b7          	lui	a5,0x74727
    80005498:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000549c:	14f71b63          	bne	a4,a5,800055f2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800054a0:	100017b7          	lui	a5,0x10001
    800054a4:	43dc                	lw	a5,4(a5)
    800054a6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054a8:	4709                	li	a4,2
    800054aa:	14e79463          	bne	a5,a4,800055f2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054ae:	100017b7          	lui	a5,0x10001
    800054b2:	479c                	lw	a5,8(a5)
    800054b4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800054b6:	12e79e63          	bne	a5,a4,800055f2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800054ba:	100017b7          	lui	a5,0x10001
    800054be:	47d8                	lw	a4,12(a5)
    800054c0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054c2:	554d47b7          	lui	a5,0x554d4
    800054c6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800054ca:	12f71463          	bne	a4,a5,800055f2 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054ce:	100017b7          	lui	a5,0x10001
    800054d2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054d6:	4705                	li	a4,1
    800054d8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054da:	470d                	li	a4,3
    800054dc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800054de:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800054e0:	c7ffe6b7          	lui	a3,0xc7ffe
    800054e4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47dbc9df>
    800054e8:	8f75                	and	a4,a4,a3
    800054ea:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054ec:	472d                	li	a4,11
    800054ee:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800054f0:	5bbc                	lw	a5,112(a5)
    800054f2:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800054f6:	8ba1                	andi	a5,a5,8
    800054f8:	10078563          	beqz	a5,80005602 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800054fc:	100017b7          	lui	a5,0x10001
    80005500:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005504:	43fc                	lw	a5,68(a5)
    80005506:	2781                	sext.w	a5,a5
    80005508:	10079563          	bnez	a5,80005612 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000550c:	100017b7          	lui	a5,0x10001
    80005510:	5bdc                	lw	a5,52(a5)
    80005512:	2781                	sext.w	a5,a5
  if(max == 0)
    80005514:	10078763          	beqz	a5,80005622 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005518:	471d                	li	a4,7
    8000551a:	10f77c63          	bgeu	a4,a5,80005632 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000551e:	ffffb097          	auipc	ra,0xffffb
    80005522:	c88080e7          	jalr	-888(ra) # 800001a6 <kalloc>
    80005526:	00234497          	auipc	s1,0x234
    8000552a:	4d248493          	addi	s1,s1,1234 # 802399f8 <disk>
    8000552e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005530:	ffffb097          	auipc	ra,0xffffb
    80005534:	c76080e7          	jalr	-906(ra) # 800001a6 <kalloc>
    80005538:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000553a:	ffffb097          	auipc	ra,0xffffb
    8000553e:	c6c080e7          	jalr	-916(ra) # 800001a6 <kalloc>
    80005542:	87aa                	mv	a5,a0
    80005544:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005546:	6088                	ld	a0,0(s1)
    80005548:	cd6d                	beqz	a0,80005642 <virtio_disk_init+0x1da>
    8000554a:	00234717          	auipc	a4,0x234
    8000554e:	4b673703          	ld	a4,1206(a4) # 80239a00 <disk+0x8>
    80005552:	cb65                	beqz	a4,80005642 <virtio_disk_init+0x1da>
    80005554:	c7fd                	beqz	a5,80005642 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005556:	6605                	lui	a2,0x1
    80005558:	4581                	li	a1,0
    8000555a:	ffffb097          	auipc	ra,0xffffb
    8000555e:	d64080e7          	jalr	-668(ra) # 800002be <memset>
  memset(disk.avail, 0, PGSIZE);
    80005562:	00234497          	auipc	s1,0x234
    80005566:	49648493          	addi	s1,s1,1174 # 802399f8 <disk>
    8000556a:	6605                	lui	a2,0x1
    8000556c:	4581                	li	a1,0
    8000556e:	6488                	ld	a0,8(s1)
    80005570:	ffffb097          	auipc	ra,0xffffb
    80005574:	d4e080e7          	jalr	-690(ra) # 800002be <memset>
  memset(disk.used, 0, PGSIZE);
    80005578:	6605                	lui	a2,0x1
    8000557a:	4581                	li	a1,0
    8000557c:	6888                	ld	a0,16(s1)
    8000557e:	ffffb097          	auipc	ra,0xffffb
    80005582:	d40080e7          	jalr	-704(ra) # 800002be <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005586:	100017b7          	lui	a5,0x10001
    8000558a:	4721                	li	a4,8
    8000558c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000558e:	4098                	lw	a4,0(s1)
    80005590:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005594:	40d8                	lw	a4,4(s1)
    80005596:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000559a:	6498                	ld	a4,8(s1)
    8000559c:	0007069b          	sext.w	a3,a4
    800055a0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800055a4:	9701                	srai	a4,a4,0x20
    800055a6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800055aa:	6898                	ld	a4,16(s1)
    800055ac:	0007069b          	sext.w	a3,a4
    800055b0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800055b4:	9701                	srai	a4,a4,0x20
    800055b6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800055ba:	4705                	li	a4,1
    800055bc:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800055be:	00e48c23          	sb	a4,24(s1)
    800055c2:	00e48ca3          	sb	a4,25(s1)
    800055c6:	00e48d23          	sb	a4,26(s1)
    800055ca:	00e48da3          	sb	a4,27(s1)
    800055ce:	00e48e23          	sb	a4,28(s1)
    800055d2:	00e48ea3          	sb	a4,29(s1)
    800055d6:	00e48f23          	sb	a4,30(s1)
    800055da:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800055de:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800055e2:	0727a823          	sw	s2,112(a5)
}
    800055e6:	60e2                	ld	ra,24(sp)
    800055e8:	6442                	ld	s0,16(sp)
    800055ea:	64a2                	ld	s1,8(sp)
    800055ec:	6902                	ld	s2,0(sp)
    800055ee:	6105                	addi	sp,sp,32
    800055f0:	8082                	ret
    panic("could not find virtio disk");
    800055f2:	00003517          	auipc	a0,0x3
    800055f6:	10e50513          	addi	a0,a0,270 # 80008700 <syscalls+0x320>
    800055fa:	00001097          	auipc	ra,0x1
    800055fe:	862080e7          	jalr	-1950(ra) # 80005e5c <panic>
    panic("virtio disk FEATURES_OK unset");
    80005602:	00003517          	auipc	a0,0x3
    80005606:	11e50513          	addi	a0,a0,286 # 80008720 <syscalls+0x340>
    8000560a:	00001097          	auipc	ra,0x1
    8000560e:	852080e7          	jalr	-1966(ra) # 80005e5c <panic>
    panic("virtio disk should not be ready");
    80005612:	00003517          	auipc	a0,0x3
    80005616:	12e50513          	addi	a0,a0,302 # 80008740 <syscalls+0x360>
    8000561a:	00001097          	auipc	ra,0x1
    8000561e:	842080e7          	jalr	-1982(ra) # 80005e5c <panic>
    panic("virtio disk has no queue 0");
    80005622:	00003517          	auipc	a0,0x3
    80005626:	13e50513          	addi	a0,a0,318 # 80008760 <syscalls+0x380>
    8000562a:	00001097          	auipc	ra,0x1
    8000562e:	832080e7          	jalr	-1998(ra) # 80005e5c <panic>
    panic("virtio disk max queue too short");
    80005632:	00003517          	auipc	a0,0x3
    80005636:	14e50513          	addi	a0,a0,334 # 80008780 <syscalls+0x3a0>
    8000563a:	00001097          	auipc	ra,0x1
    8000563e:	822080e7          	jalr	-2014(ra) # 80005e5c <panic>
    panic("virtio disk kalloc");
    80005642:	00003517          	auipc	a0,0x3
    80005646:	15e50513          	addi	a0,a0,350 # 800087a0 <syscalls+0x3c0>
    8000564a:	00001097          	auipc	ra,0x1
    8000564e:	812080e7          	jalr	-2030(ra) # 80005e5c <panic>

0000000080005652 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005652:	7119                	addi	sp,sp,-128
    80005654:	fc86                	sd	ra,120(sp)
    80005656:	f8a2                	sd	s0,112(sp)
    80005658:	f4a6                	sd	s1,104(sp)
    8000565a:	f0ca                	sd	s2,96(sp)
    8000565c:	ecce                	sd	s3,88(sp)
    8000565e:	e8d2                	sd	s4,80(sp)
    80005660:	e4d6                	sd	s5,72(sp)
    80005662:	e0da                	sd	s6,64(sp)
    80005664:	fc5e                	sd	s7,56(sp)
    80005666:	f862                	sd	s8,48(sp)
    80005668:	f466                	sd	s9,40(sp)
    8000566a:	f06a                	sd	s10,32(sp)
    8000566c:	ec6e                	sd	s11,24(sp)
    8000566e:	0100                	addi	s0,sp,128
    80005670:	8aaa                	mv	s5,a0
    80005672:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005674:	00c52d03          	lw	s10,12(a0)
    80005678:	001d1d1b          	slliw	s10,s10,0x1
    8000567c:	1d02                	slli	s10,s10,0x20
    8000567e:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80005682:	00234517          	auipc	a0,0x234
    80005686:	49e50513          	addi	a0,a0,1182 # 80239b20 <disk+0x128>
    8000568a:	00001097          	auipc	ra,0x1
    8000568e:	d0a080e7          	jalr	-758(ra) # 80006394 <acquire>
  for(int i = 0; i < 3; i++){
    80005692:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005694:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005696:	00234b97          	auipc	s7,0x234
    8000569a:	362b8b93          	addi	s7,s7,866 # 802399f8 <disk>
  for(int i = 0; i < 3; i++){
    8000569e:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056a0:	00234c97          	auipc	s9,0x234
    800056a4:	480c8c93          	addi	s9,s9,1152 # 80239b20 <disk+0x128>
    800056a8:	a08d                	j	8000570a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800056aa:	00fb8733          	add	a4,s7,a5
    800056ae:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800056b2:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800056b4:	0207c563          	bltz	a5,800056de <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800056b8:	2905                	addiw	s2,s2,1
    800056ba:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800056bc:	05690c63          	beq	s2,s6,80005714 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800056c0:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800056c2:	00234717          	auipc	a4,0x234
    800056c6:	33670713          	addi	a4,a4,822 # 802399f8 <disk>
    800056ca:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800056cc:	01874683          	lbu	a3,24(a4)
    800056d0:	fee9                	bnez	a3,800056aa <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800056d2:	2785                	addiw	a5,a5,1
    800056d4:	0705                	addi	a4,a4,1
    800056d6:	fe979be3          	bne	a5,s1,800056cc <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800056da:	57fd                	li	a5,-1
    800056dc:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800056de:	01205d63          	blez	s2,800056f8 <virtio_disk_rw+0xa6>
    800056e2:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800056e4:	000a2503          	lw	a0,0(s4)
    800056e8:	00000097          	auipc	ra,0x0
    800056ec:	cfe080e7          	jalr	-770(ra) # 800053e6 <free_desc>
      for(int j = 0; j < i; j++)
    800056f0:	2d85                	addiw	s11,s11,1
    800056f2:	0a11                	addi	s4,s4,4
    800056f4:	ff2d98e3          	bne	s11,s2,800056e4 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056f8:	85e6                	mv	a1,s9
    800056fa:	00234517          	auipc	a0,0x234
    800056fe:	31650513          	addi	a0,a0,790 # 80239a10 <disk+0x18>
    80005702:	ffffc097          	auipc	ra,0xffffc
    80005706:	f54080e7          	jalr	-172(ra) # 80001656 <sleep>
  for(int i = 0; i < 3; i++){
    8000570a:	f8040a13          	addi	s4,s0,-128
{
    8000570e:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005710:	894e                	mv	s2,s3
    80005712:	b77d                	j	800056c0 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005714:	f8042503          	lw	a0,-128(s0)
    80005718:	00a50713          	addi	a4,a0,10
    8000571c:	0712                	slli	a4,a4,0x4

  if(write)
    8000571e:	00234797          	auipc	a5,0x234
    80005722:	2da78793          	addi	a5,a5,730 # 802399f8 <disk>
    80005726:	00e786b3          	add	a3,a5,a4
    8000572a:	01803633          	snez	a2,s8
    8000572e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005730:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005734:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005738:	f6070613          	addi	a2,a4,-160
    8000573c:	6394                	ld	a3,0(a5)
    8000573e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005740:	00870593          	addi	a1,a4,8
    80005744:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005746:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005748:	0007b803          	ld	a6,0(a5)
    8000574c:	9642                	add	a2,a2,a6
    8000574e:	46c1                	li	a3,16
    80005750:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005752:	4585                	li	a1,1
    80005754:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005758:	f8442683          	lw	a3,-124(s0)
    8000575c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005760:	0692                	slli	a3,a3,0x4
    80005762:	9836                	add	a6,a6,a3
    80005764:	058a8613          	addi	a2,s5,88
    80005768:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000576c:	0007b803          	ld	a6,0(a5)
    80005770:	96c2                	add	a3,a3,a6
    80005772:	40000613          	li	a2,1024
    80005776:	c690                	sw	a2,8(a3)
  if(write)
    80005778:	001c3613          	seqz	a2,s8
    8000577c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005780:	00166613          	ori	a2,a2,1
    80005784:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005788:	f8842603          	lw	a2,-120(s0)
    8000578c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005790:	00250693          	addi	a3,a0,2
    80005794:	0692                	slli	a3,a3,0x4
    80005796:	96be                	add	a3,a3,a5
    80005798:	58fd                	li	a7,-1
    8000579a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000579e:	0612                	slli	a2,a2,0x4
    800057a0:	9832                	add	a6,a6,a2
    800057a2:	f9070713          	addi	a4,a4,-112
    800057a6:	973e                	add	a4,a4,a5
    800057a8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800057ac:	6398                	ld	a4,0(a5)
    800057ae:	9732                	add	a4,a4,a2
    800057b0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800057b2:	4609                	li	a2,2
    800057b4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800057b8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800057bc:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    800057c0:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800057c4:	6794                	ld	a3,8(a5)
    800057c6:	0026d703          	lhu	a4,2(a3)
    800057ca:	8b1d                	andi	a4,a4,7
    800057cc:	0706                	slli	a4,a4,0x1
    800057ce:	96ba                	add	a3,a3,a4
    800057d0:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800057d4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800057d8:	6798                	ld	a4,8(a5)
    800057da:	00275783          	lhu	a5,2(a4)
    800057de:	2785                	addiw	a5,a5,1
    800057e0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800057e4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057e8:	100017b7          	lui	a5,0x10001
    800057ec:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800057f0:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    800057f4:	00234917          	auipc	s2,0x234
    800057f8:	32c90913          	addi	s2,s2,812 # 80239b20 <disk+0x128>
  while(b->disk == 1) {
    800057fc:	4485                	li	s1,1
    800057fe:	00b79c63          	bne	a5,a1,80005816 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005802:	85ca                	mv	a1,s2
    80005804:	8556                	mv	a0,s5
    80005806:	ffffc097          	auipc	ra,0xffffc
    8000580a:	e50080e7          	jalr	-432(ra) # 80001656 <sleep>
  while(b->disk == 1) {
    8000580e:	004aa783          	lw	a5,4(s5)
    80005812:	fe9788e3          	beq	a5,s1,80005802 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005816:	f8042903          	lw	s2,-128(s0)
    8000581a:	00290713          	addi	a4,s2,2
    8000581e:	0712                	slli	a4,a4,0x4
    80005820:	00234797          	auipc	a5,0x234
    80005824:	1d878793          	addi	a5,a5,472 # 802399f8 <disk>
    80005828:	97ba                	add	a5,a5,a4
    8000582a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000582e:	00234997          	auipc	s3,0x234
    80005832:	1ca98993          	addi	s3,s3,458 # 802399f8 <disk>
    80005836:	00491713          	slli	a4,s2,0x4
    8000583a:	0009b783          	ld	a5,0(s3)
    8000583e:	97ba                	add	a5,a5,a4
    80005840:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005844:	854a                	mv	a0,s2
    80005846:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000584a:	00000097          	auipc	ra,0x0
    8000584e:	b9c080e7          	jalr	-1124(ra) # 800053e6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005852:	8885                	andi	s1,s1,1
    80005854:	f0ed                	bnez	s1,80005836 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005856:	00234517          	auipc	a0,0x234
    8000585a:	2ca50513          	addi	a0,a0,714 # 80239b20 <disk+0x128>
    8000585e:	00001097          	auipc	ra,0x1
    80005862:	bea080e7          	jalr	-1046(ra) # 80006448 <release>
}
    80005866:	70e6                	ld	ra,120(sp)
    80005868:	7446                	ld	s0,112(sp)
    8000586a:	74a6                	ld	s1,104(sp)
    8000586c:	7906                	ld	s2,96(sp)
    8000586e:	69e6                	ld	s3,88(sp)
    80005870:	6a46                	ld	s4,80(sp)
    80005872:	6aa6                	ld	s5,72(sp)
    80005874:	6b06                	ld	s6,64(sp)
    80005876:	7be2                	ld	s7,56(sp)
    80005878:	7c42                	ld	s8,48(sp)
    8000587a:	7ca2                	ld	s9,40(sp)
    8000587c:	7d02                	ld	s10,32(sp)
    8000587e:	6de2                	ld	s11,24(sp)
    80005880:	6109                	addi	sp,sp,128
    80005882:	8082                	ret

0000000080005884 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005884:	1101                	addi	sp,sp,-32
    80005886:	ec06                	sd	ra,24(sp)
    80005888:	e822                	sd	s0,16(sp)
    8000588a:	e426                	sd	s1,8(sp)
    8000588c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000588e:	00234497          	auipc	s1,0x234
    80005892:	16a48493          	addi	s1,s1,362 # 802399f8 <disk>
    80005896:	00234517          	auipc	a0,0x234
    8000589a:	28a50513          	addi	a0,a0,650 # 80239b20 <disk+0x128>
    8000589e:	00001097          	auipc	ra,0x1
    800058a2:	af6080e7          	jalr	-1290(ra) # 80006394 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800058a6:	10001737          	lui	a4,0x10001
    800058aa:	533c                	lw	a5,96(a4)
    800058ac:	8b8d                	andi	a5,a5,3
    800058ae:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800058b0:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800058b4:	689c                	ld	a5,16(s1)
    800058b6:	0204d703          	lhu	a4,32(s1)
    800058ba:	0027d783          	lhu	a5,2(a5)
    800058be:	04f70863          	beq	a4,a5,8000590e <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800058c2:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058c6:	6898                	ld	a4,16(s1)
    800058c8:	0204d783          	lhu	a5,32(s1)
    800058cc:	8b9d                	andi	a5,a5,7
    800058ce:	078e                	slli	a5,a5,0x3
    800058d0:	97ba                	add	a5,a5,a4
    800058d2:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800058d4:	00278713          	addi	a4,a5,2
    800058d8:	0712                	slli	a4,a4,0x4
    800058da:	9726                	add	a4,a4,s1
    800058dc:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800058e0:	e721                	bnez	a4,80005928 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800058e2:	0789                	addi	a5,a5,2
    800058e4:	0792                	slli	a5,a5,0x4
    800058e6:	97a6                	add	a5,a5,s1
    800058e8:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800058ea:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800058ee:	ffffc097          	auipc	ra,0xffffc
    800058f2:	dcc080e7          	jalr	-564(ra) # 800016ba <wakeup>

    disk.used_idx += 1;
    800058f6:	0204d783          	lhu	a5,32(s1)
    800058fa:	2785                	addiw	a5,a5,1
    800058fc:	17c2                	slli	a5,a5,0x30
    800058fe:	93c1                	srli	a5,a5,0x30
    80005900:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005904:	6898                	ld	a4,16(s1)
    80005906:	00275703          	lhu	a4,2(a4)
    8000590a:	faf71ce3          	bne	a4,a5,800058c2 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000590e:	00234517          	auipc	a0,0x234
    80005912:	21250513          	addi	a0,a0,530 # 80239b20 <disk+0x128>
    80005916:	00001097          	auipc	ra,0x1
    8000591a:	b32080e7          	jalr	-1230(ra) # 80006448 <release>
}
    8000591e:	60e2                	ld	ra,24(sp)
    80005920:	6442                	ld	s0,16(sp)
    80005922:	64a2                	ld	s1,8(sp)
    80005924:	6105                	addi	sp,sp,32
    80005926:	8082                	ret
      panic("virtio_disk_intr status");
    80005928:	00003517          	auipc	a0,0x3
    8000592c:	e9050513          	addi	a0,a0,-368 # 800087b8 <syscalls+0x3d8>
    80005930:	00000097          	auipc	ra,0x0
    80005934:	52c080e7          	jalr	1324(ra) # 80005e5c <panic>

0000000080005938 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005938:	1141                	addi	sp,sp,-16
    8000593a:	e422                	sd	s0,8(sp)
    8000593c:	0800                	addi	s0,sp,16
    asm volatile("csrr %0, mhartid" : "=r"(x));
    8000593e:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005942:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005946:	0037979b          	slliw	a5,a5,0x3
    8000594a:	02004737          	lui	a4,0x2004
    8000594e:	97ba                	add	a5,a5,a4
    80005950:	0200c737          	lui	a4,0x200c
    80005954:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005958:	000f4637          	lui	a2,0xf4
    8000595c:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005960:	9732                	add	a4,a4,a2
    80005962:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005964:	00259693          	slli	a3,a1,0x2
    80005968:	96ae                	add	a3,a3,a1
    8000596a:	068e                	slli	a3,a3,0x3
    8000596c:	00234717          	auipc	a4,0x234
    80005970:	1d470713          	addi	a4,a4,468 # 80239b40 <timer_scratch>
    80005974:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005976:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005978:	f310                	sd	a2,32(a4)
    asm volatile("csrw mscratch, %0" : : "r"(x));
    8000597a:	34071073          	csrw	mscratch,a4
    asm volatile("csrw mtvec, %0" : : "r"(x));
    8000597e:	00000797          	auipc	a5,0x0
    80005982:	9a278793          	addi	a5,a5,-1630 # 80005320 <timervec>
    80005986:	30579073          	csrw	mtvec,a5
    asm volatile("csrr %0, mstatus" : "=r"(x));
    8000598a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000598e:	0087e793          	ori	a5,a5,8
    asm volatile("csrw mstatus, %0" : : "r"(x));
    80005992:	30079073          	csrw	mstatus,a5
    asm volatile("csrr %0, mie" : "=r"(x));
    80005996:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000599a:	0807e793          	ori	a5,a5,128
    asm volatile("csrw mie, %0" : : "r"(x));
    8000599e:	30479073          	csrw	mie,a5
}
    800059a2:	6422                	ld	s0,8(sp)
    800059a4:	0141                	addi	sp,sp,16
    800059a6:	8082                	ret

00000000800059a8 <start>:
{
    800059a8:	1141                	addi	sp,sp,-16
    800059aa:	e406                	sd	ra,8(sp)
    800059ac:	e022                	sd	s0,0(sp)
    800059ae:	0800                	addi	s0,sp,16
    asm volatile("csrr %0, mstatus" : "=r"(x));
    800059b0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800059b4:	7779                	lui	a4,0xffffe
    800059b6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdbca7f>
    800059ba:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800059bc:	6705                	lui	a4,0x1
    800059be:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800059c2:	8fd9                	or	a5,a5,a4
    asm volatile("csrw mstatus, %0" : : "r"(x));
    800059c4:	30079073          	csrw	mstatus,a5
    asm volatile("csrw mepc, %0" : : "r"(x));
    800059c8:	ffffb797          	auipc	a5,0xffffb
    800059cc:	a9c78793          	addi	a5,a5,-1380 # 80000464 <main>
    800059d0:	34179073          	csrw	mepc,a5
    asm volatile("csrw satp, %0" : : "r"(x));
    800059d4:	4781                	li	a5,0
    800059d6:	18079073          	csrw	satp,a5
    asm volatile("csrw medeleg, %0" : : "r"(x));
    800059da:	67c1                	lui	a5,0x10
    800059dc:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800059de:	30279073          	csrw	medeleg,a5
    asm volatile("csrw mideleg, %0" : : "r"(x));
    800059e2:	30379073          	csrw	mideleg,a5
    asm volatile("csrr %0, sie" : "=r"(x));
    800059e6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800059ea:	2227e793          	ori	a5,a5,546
    asm volatile("csrw sie, %0" : : "r"(x));
    800059ee:	10479073          	csrw	sie,a5
    asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    800059f2:	57fd                	li	a5,-1
    800059f4:	83a9                	srli	a5,a5,0xa
    800059f6:	3b079073          	csrw	pmpaddr0,a5
    asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    800059fa:	47bd                	li	a5,15
    800059fc:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005a00:	00000097          	auipc	ra,0x0
    80005a04:	f38080e7          	jalr	-200(ra) # 80005938 <timerinit>
    asm volatile("csrr %0, mhartid" : "=r"(x));
    80005a08:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005a0c:	2781                	sext.w	a5,a5
    asm volatile("mv tp, %0" : : "r"(x));
    80005a0e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005a10:	30200073          	mret
}
    80005a14:	60a2                	ld	ra,8(sp)
    80005a16:	6402                	ld	s0,0(sp)
    80005a18:	0141                	addi	sp,sp,16
    80005a1a:	8082                	ret

0000000080005a1c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005a1c:	715d                	addi	sp,sp,-80
    80005a1e:	e486                	sd	ra,72(sp)
    80005a20:	e0a2                	sd	s0,64(sp)
    80005a22:	fc26                	sd	s1,56(sp)
    80005a24:	f84a                	sd	s2,48(sp)
    80005a26:	f44e                	sd	s3,40(sp)
    80005a28:	f052                	sd	s4,32(sp)
    80005a2a:	ec56                	sd	s5,24(sp)
    80005a2c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005a2e:	04c05763          	blez	a2,80005a7c <consolewrite+0x60>
    80005a32:	8a2a                	mv	s4,a0
    80005a34:	84ae                	mv	s1,a1
    80005a36:	89b2                	mv	s3,a2
    80005a38:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005a3a:	5afd                	li	s5,-1
    80005a3c:	4685                	li	a3,1
    80005a3e:	8626                	mv	a2,s1
    80005a40:	85d2                	mv	a1,s4
    80005a42:	fbf40513          	addi	a0,s0,-65
    80005a46:	ffffc097          	auipc	ra,0xffffc
    80005a4a:	06e080e7          	jalr	110(ra) # 80001ab4 <either_copyin>
    80005a4e:	01550d63          	beq	a0,s5,80005a68 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005a52:	fbf44503          	lbu	a0,-65(s0)
    80005a56:	00000097          	auipc	ra,0x0
    80005a5a:	784080e7          	jalr	1924(ra) # 800061da <uartputc>
  for(i = 0; i < n; i++){
    80005a5e:	2905                	addiw	s2,s2,1
    80005a60:	0485                	addi	s1,s1,1
    80005a62:	fd299de3          	bne	s3,s2,80005a3c <consolewrite+0x20>
    80005a66:	894e                	mv	s2,s3
  }

  return i;
}
    80005a68:	854a                	mv	a0,s2
    80005a6a:	60a6                	ld	ra,72(sp)
    80005a6c:	6406                	ld	s0,64(sp)
    80005a6e:	74e2                	ld	s1,56(sp)
    80005a70:	7942                	ld	s2,48(sp)
    80005a72:	79a2                	ld	s3,40(sp)
    80005a74:	7a02                	ld	s4,32(sp)
    80005a76:	6ae2                	ld	s5,24(sp)
    80005a78:	6161                	addi	sp,sp,80
    80005a7a:	8082                	ret
  for(i = 0; i < n; i++){
    80005a7c:	4901                	li	s2,0
    80005a7e:	b7ed                	j	80005a68 <consolewrite+0x4c>

0000000080005a80 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005a80:	7159                	addi	sp,sp,-112
    80005a82:	f486                	sd	ra,104(sp)
    80005a84:	f0a2                	sd	s0,96(sp)
    80005a86:	eca6                	sd	s1,88(sp)
    80005a88:	e8ca                	sd	s2,80(sp)
    80005a8a:	e4ce                	sd	s3,72(sp)
    80005a8c:	e0d2                	sd	s4,64(sp)
    80005a8e:	fc56                	sd	s5,56(sp)
    80005a90:	f85a                	sd	s6,48(sp)
    80005a92:	f45e                	sd	s7,40(sp)
    80005a94:	f062                	sd	s8,32(sp)
    80005a96:	ec66                	sd	s9,24(sp)
    80005a98:	e86a                	sd	s10,16(sp)
    80005a9a:	1880                	addi	s0,sp,112
    80005a9c:	8aaa                	mv	s5,a0
    80005a9e:	8a2e                	mv	s4,a1
    80005aa0:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005aa2:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005aa6:	0023c517          	auipc	a0,0x23c
    80005aaa:	1da50513          	addi	a0,a0,474 # 80241c80 <cons>
    80005aae:	00001097          	auipc	ra,0x1
    80005ab2:	8e6080e7          	jalr	-1818(ra) # 80006394 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005ab6:	0023c497          	auipc	s1,0x23c
    80005aba:	1ca48493          	addi	s1,s1,458 # 80241c80 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005abe:	0023c917          	auipc	s2,0x23c
    80005ac2:	25a90913          	addi	s2,s2,602 # 80241d18 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005ac6:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005ac8:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005aca:	4ca9                	li	s9,10
  while(n > 0){
    80005acc:	07305b63          	blez	s3,80005b42 <consoleread+0xc2>
    while(cons.r == cons.w){
    80005ad0:	0984a783          	lw	a5,152(s1)
    80005ad4:	09c4a703          	lw	a4,156(s1)
    80005ad8:	02f71763          	bne	a4,a5,80005b06 <consoleread+0x86>
      if(killed(myproc())){
    80005adc:	ffffb097          	auipc	ra,0xffffb
    80005ae0:	4d2080e7          	jalr	1234(ra) # 80000fae <myproc>
    80005ae4:	ffffc097          	auipc	ra,0xffffc
    80005ae8:	e1a080e7          	jalr	-486(ra) # 800018fe <killed>
    80005aec:	e535                	bnez	a0,80005b58 <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    80005aee:	85a6                	mv	a1,s1
    80005af0:	854a                	mv	a0,s2
    80005af2:	ffffc097          	auipc	ra,0xffffc
    80005af6:	b64080e7          	jalr	-1180(ra) # 80001656 <sleep>
    while(cons.r == cons.w){
    80005afa:	0984a783          	lw	a5,152(s1)
    80005afe:	09c4a703          	lw	a4,156(s1)
    80005b02:	fcf70de3          	beq	a4,a5,80005adc <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005b06:	0017871b          	addiw	a4,a5,1
    80005b0a:	08e4ac23          	sw	a4,152(s1)
    80005b0e:	07f7f713          	andi	a4,a5,127
    80005b12:	9726                	add	a4,a4,s1
    80005b14:	01874703          	lbu	a4,24(a4)
    80005b18:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005b1c:	077d0563          	beq	s10,s7,80005b86 <consoleread+0x106>
    cbuf = c;
    80005b20:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b24:	4685                	li	a3,1
    80005b26:	f9f40613          	addi	a2,s0,-97
    80005b2a:	85d2                	mv	a1,s4
    80005b2c:	8556                	mv	a0,s5
    80005b2e:	ffffc097          	auipc	ra,0xffffc
    80005b32:	f30080e7          	jalr	-208(ra) # 80001a5e <either_copyout>
    80005b36:	01850663          	beq	a0,s8,80005b42 <consoleread+0xc2>
    dst++;
    80005b3a:	0a05                	addi	s4,s4,1
    --n;
    80005b3c:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005b3e:	f99d17e3          	bne	s10,s9,80005acc <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005b42:	0023c517          	auipc	a0,0x23c
    80005b46:	13e50513          	addi	a0,a0,318 # 80241c80 <cons>
    80005b4a:	00001097          	auipc	ra,0x1
    80005b4e:	8fe080e7          	jalr	-1794(ra) # 80006448 <release>

  return target - n;
    80005b52:	413b053b          	subw	a0,s6,s3
    80005b56:	a811                	j	80005b6a <consoleread+0xea>
        release(&cons.lock);
    80005b58:	0023c517          	auipc	a0,0x23c
    80005b5c:	12850513          	addi	a0,a0,296 # 80241c80 <cons>
    80005b60:	00001097          	auipc	ra,0x1
    80005b64:	8e8080e7          	jalr	-1816(ra) # 80006448 <release>
        return -1;
    80005b68:	557d                	li	a0,-1
}
    80005b6a:	70a6                	ld	ra,104(sp)
    80005b6c:	7406                	ld	s0,96(sp)
    80005b6e:	64e6                	ld	s1,88(sp)
    80005b70:	6946                	ld	s2,80(sp)
    80005b72:	69a6                	ld	s3,72(sp)
    80005b74:	6a06                	ld	s4,64(sp)
    80005b76:	7ae2                	ld	s5,56(sp)
    80005b78:	7b42                	ld	s6,48(sp)
    80005b7a:	7ba2                	ld	s7,40(sp)
    80005b7c:	7c02                	ld	s8,32(sp)
    80005b7e:	6ce2                	ld	s9,24(sp)
    80005b80:	6d42                	ld	s10,16(sp)
    80005b82:	6165                	addi	sp,sp,112
    80005b84:	8082                	ret
      if(n < target){
    80005b86:	0009871b          	sext.w	a4,s3
    80005b8a:	fb677ce3          	bgeu	a4,s6,80005b42 <consoleread+0xc2>
        cons.r--;
    80005b8e:	0023c717          	auipc	a4,0x23c
    80005b92:	18f72523          	sw	a5,394(a4) # 80241d18 <cons+0x98>
    80005b96:	b775                	j	80005b42 <consoleread+0xc2>

0000000080005b98 <consputc>:
{
    80005b98:	1141                	addi	sp,sp,-16
    80005b9a:	e406                	sd	ra,8(sp)
    80005b9c:	e022                	sd	s0,0(sp)
    80005b9e:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005ba0:	10000793          	li	a5,256
    80005ba4:	00f50a63          	beq	a0,a5,80005bb8 <consputc+0x20>
    uartputc_sync(c);
    80005ba8:	00000097          	auipc	ra,0x0
    80005bac:	560080e7          	jalr	1376(ra) # 80006108 <uartputc_sync>
}
    80005bb0:	60a2                	ld	ra,8(sp)
    80005bb2:	6402                	ld	s0,0(sp)
    80005bb4:	0141                	addi	sp,sp,16
    80005bb6:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005bb8:	4521                	li	a0,8
    80005bba:	00000097          	auipc	ra,0x0
    80005bbe:	54e080e7          	jalr	1358(ra) # 80006108 <uartputc_sync>
    80005bc2:	02000513          	li	a0,32
    80005bc6:	00000097          	auipc	ra,0x0
    80005bca:	542080e7          	jalr	1346(ra) # 80006108 <uartputc_sync>
    80005bce:	4521                	li	a0,8
    80005bd0:	00000097          	auipc	ra,0x0
    80005bd4:	538080e7          	jalr	1336(ra) # 80006108 <uartputc_sync>
    80005bd8:	bfe1                	j	80005bb0 <consputc+0x18>

0000000080005bda <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005bda:	1101                	addi	sp,sp,-32
    80005bdc:	ec06                	sd	ra,24(sp)
    80005bde:	e822                	sd	s0,16(sp)
    80005be0:	e426                	sd	s1,8(sp)
    80005be2:	e04a                	sd	s2,0(sp)
    80005be4:	1000                	addi	s0,sp,32
    80005be6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005be8:	0023c517          	auipc	a0,0x23c
    80005bec:	09850513          	addi	a0,a0,152 # 80241c80 <cons>
    80005bf0:	00000097          	auipc	ra,0x0
    80005bf4:	7a4080e7          	jalr	1956(ra) # 80006394 <acquire>

  switch(c){
    80005bf8:	47d5                	li	a5,21
    80005bfa:	0af48663          	beq	s1,a5,80005ca6 <consoleintr+0xcc>
    80005bfe:	0297ca63          	blt	a5,s1,80005c32 <consoleintr+0x58>
    80005c02:	47a1                	li	a5,8
    80005c04:	0ef48763          	beq	s1,a5,80005cf2 <consoleintr+0x118>
    80005c08:	47c1                	li	a5,16
    80005c0a:	10f49a63          	bne	s1,a5,80005d1e <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005c0e:	ffffc097          	auipc	ra,0xffffc
    80005c12:	efc080e7          	jalr	-260(ra) # 80001b0a <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005c16:	0023c517          	auipc	a0,0x23c
    80005c1a:	06a50513          	addi	a0,a0,106 # 80241c80 <cons>
    80005c1e:	00001097          	auipc	ra,0x1
    80005c22:	82a080e7          	jalr	-2006(ra) # 80006448 <release>
}
    80005c26:	60e2                	ld	ra,24(sp)
    80005c28:	6442                	ld	s0,16(sp)
    80005c2a:	64a2                	ld	s1,8(sp)
    80005c2c:	6902                	ld	s2,0(sp)
    80005c2e:	6105                	addi	sp,sp,32
    80005c30:	8082                	ret
  switch(c){
    80005c32:	07f00793          	li	a5,127
    80005c36:	0af48e63          	beq	s1,a5,80005cf2 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c3a:	0023c717          	auipc	a4,0x23c
    80005c3e:	04670713          	addi	a4,a4,70 # 80241c80 <cons>
    80005c42:	0a072783          	lw	a5,160(a4)
    80005c46:	09872703          	lw	a4,152(a4)
    80005c4a:	9f99                	subw	a5,a5,a4
    80005c4c:	07f00713          	li	a4,127
    80005c50:	fcf763e3          	bltu	a4,a5,80005c16 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005c54:	47b5                	li	a5,13
    80005c56:	0cf48763          	beq	s1,a5,80005d24 <consoleintr+0x14a>
      consputc(c);
    80005c5a:	8526                	mv	a0,s1
    80005c5c:	00000097          	auipc	ra,0x0
    80005c60:	f3c080e7          	jalr	-196(ra) # 80005b98 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c64:	0023c797          	auipc	a5,0x23c
    80005c68:	01c78793          	addi	a5,a5,28 # 80241c80 <cons>
    80005c6c:	0a07a683          	lw	a3,160(a5)
    80005c70:	0016871b          	addiw	a4,a3,1
    80005c74:	0007061b          	sext.w	a2,a4
    80005c78:	0ae7a023          	sw	a4,160(a5)
    80005c7c:	07f6f693          	andi	a3,a3,127
    80005c80:	97b6                	add	a5,a5,a3
    80005c82:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005c86:	47a9                	li	a5,10
    80005c88:	0cf48563          	beq	s1,a5,80005d52 <consoleintr+0x178>
    80005c8c:	4791                	li	a5,4
    80005c8e:	0cf48263          	beq	s1,a5,80005d52 <consoleintr+0x178>
    80005c92:	0023c797          	auipc	a5,0x23c
    80005c96:	0867a783          	lw	a5,134(a5) # 80241d18 <cons+0x98>
    80005c9a:	9f1d                	subw	a4,a4,a5
    80005c9c:	08000793          	li	a5,128
    80005ca0:	f6f71be3          	bne	a4,a5,80005c16 <consoleintr+0x3c>
    80005ca4:	a07d                	j	80005d52 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005ca6:	0023c717          	auipc	a4,0x23c
    80005caa:	fda70713          	addi	a4,a4,-38 # 80241c80 <cons>
    80005cae:	0a072783          	lw	a5,160(a4)
    80005cb2:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005cb6:	0023c497          	auipc	s1,0x23c
    80005cba:	fca48493          	addi	s1,s1,-54 # 80241c80 <cons>
    while(cons.e != cons.w &&
    80005cbe:	4929                	li	s2,10
    80005cc0:	f4f70be3          	beq	a4,a5,80005c16 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005cc4:	37fd                	addiw	a5,a5,-1
    80005cc6:	07f7f713          	andi	a4,a5,127
    80005cca:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005ccc:	01874703          	lbu	a4,24(a4)
    80005cd0:	f52703e3          	beq	a4,s2,80005c16 <consoleintr+0x3c>
      cons.e--;
    80005cd4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005cd8:	10000513          	li	a0,256
    80005cdc:	00000097          	auipc	ra,0x0
    80005ce0:	ebc080e7          	jalr	-324(ra) # 80005b98 <consputc>
    while(cons.e != cons.w &&
    80005ce4:	0a04a783          	lw	a5,160(s1)
    80005ce8:	09c4a703          	lw	a4,156(s1)
    80005cec:	fcf71ce3          	bne	a4,a5,80005cc4 <consoleintr+0xea>
    80005cf0:	b71d                	j	80005c16 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005cf2:	0023c717          	auipc	a4,0x23c
    80005cf6:	f8e70713          	addi	a4,a4,-114 # 80241c80 <cons>
    80005cfa:	0a072783          	lw	a5,160(a4)
    80005cfe:	09c72703          	lw	a4,156(a4)
    80005d02:	f0f70ae3          	beq	a4,a5,80005c16 <consoleintr+0x3c>
      cons.e--;
    80005d06:	37fd                	addiw	a5,a5,-1
    80005d08:	0023c717          	auipc	a4,0x23c
    80005d0c:	00f72c23          	sw	a5,24(a4) # 80241d20 <cons+0xa0>
      consputc(BACKSPACE);
    80005d10:	10000513          	li	a0,256
    80005d14:	00000097          	auipc	ra,0x0
    80005d18:	e84080e7          	jalr	-380(ra) # 80005b98 <consputc>
    80005d1c:	bded                	j	80005c16 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005d1e:	ee048ce3          	beqz	s1,80005c16 <consoleintr+0x3c>
    80005d22:	bf21                	j	80005c3a <consoleintr+0x60>
      consputc(c);
    80005d24:	4529                	li	a0,10
    80005d26:	00000097          	auipc	ra,0x0
    80005d2a:	e72080e7          	jalr	-398(ra) # 80005b98 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005d2e:	0023c797          	auipc	a5,0x23c
    80005d32:	f5278793          	addi	a5,a5,-174 # 80241c80 <cons>
    80005d36:	0a07a703          	lw	a4,160(a5)
    80005d3a:	0017069b          	addiw	a3,a4,1
    80005d3e:	0006861b          	sext.w	a2,a3
    80005d42:	0ad7a023          	sw	a3,160(a5)
    80005d46:	07f77713          	andi	a4,a4,127
    80005d4a:	97ba                	add	a5,a5,a4
    80005d4c:	4729                	li	a4,10
    80005d4e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005d52:	0023c797          	auipc	a5,0x23c
    80005d56:	fcc7a523          	sw	a2,-54(a5) # 80241d1c <cons+0x9c>
        wakeup(&cons.r);
    80005d5a:	0023c517          	auipc	a0,0x23c
    80005d5e:	fbe50513          	addi	a0,a0,-66 # 80241d18 <cons+0x98>
    80005d62:	ffffc097          	auipc	ra,0xffffc
    80005d66:	958080e7          	jalr	-1704(ra) # 800016ba <wakeup>
    80005d6a:	b575                	j	80005c16 <consoleintr+0x3c>

0000000080005d6c <consoleinit>:

void
consoleinit(void)
{
    80005d6c:	1141                	addi	sp,sp,-16
    80005d6e:	e406                	sd	ra,8(sp)
    80005d70:	e022                	sd	s0,0(sp)
    80005d72:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005d74:	00003597          	auipc	a1,0x3
    80005d78:	a5c58593          	addi	a1,a1,-1444 # 800087d0 <syscalls+0x3f0>
    80005d7c:	0023c517          	auipc	a0,0x23c
    80005d80:	f0450513          	addi	a0,a0,-252 # 80241c80 <cons>
    80005d84:	00000097          	auipc	ra,0x0
    80005d88:	580080e7          	jalr	1408(ra) # 80006304 <initlock>

  uartinit();
    80005d8c:	00000097          	auipc	ra,0x0
    80005d90:	32c080e7          	jalr	812(ra) # 800060b8 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005d94:	00233797          	auipc	a5,0x233
    80005d98:	c0c78793          	addi	a5,a5,-1012 # 802389a0 <devsw>
    80005d9c:	00000717          	auipc	a4,0x0
    80005da0:	ce470713          	addi	a4,a4,-796 # 80005a80 <consoleread>
    80005da4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005da6:	00000717          	auipc	a4,0x0
    80005daa:	c7670713          	addi	a4,a4,-906 # 80005a1c <consolewrite>
    80005dae:	ef98                	sd	a4,24(a5)
}
    80005db0:	60a2                	ld	ra,8(sp)
    80005db2:	6402                	ld	s0,0(sp)
    80005db4:	0141                	addi	sp,sp,16
    80005db6:	8082                	ret

0000000080005db8 <printint>:
} pr;

static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign)
{
    80005db8:	7179                	addi	sp,sp,-48
    80005dba:	f406                	sd	ra,40(sp)
    80005dbc:	f022                	sd	s0,32(sp)
    80005dbe:	ec26                	sd	s1,24(sp)
    80005dc0:	e84a                	sd	s2,16(sp)
    80005dc2:	1800                	addi	s0,sp,48
    char buf[16];
    int i;
    uint x;

    if (sign && (sign = xx < 0))
    80005dc4:	c219                	beqz	a2,80005dca <printint+0x12>
    80005dc6:	08054763          	bltz	a0,80005e54 <printint+0x9c>
        x = -xx;
    else
        x = xx;
    80005dca:	2501                	sext.w	a0,a0
    80005dcc:	4881                	li	a7,0
    80005dce:	fd040693          	addi	a3,s0,-48

    i = 0;
    80005dd2:	4701                	li	a4,0
    do {
        buf[i++] = digits[x % base];
    80005dd4:	2581                	sext.w	a1,a1
    80005dd6:	00003617          	auipc	a2,0x3
    80005dda:	a2a60613          	addi	a2,a2,-1494 # 80008800 <digits>
    80005dde:	883a                	mv	a6,a4
    80005de0:	2705                	addiw	a4,a4,1
    80005de2:	02b577bb          	remuw	a5,a0,a1
    80005de6:	1782                	slli	a5,a5,0x20
    80005de8:	9381                	srli	a5,a5,0x20
    80005dea:	97b2                	add	a5,a5,a2
    80005dec:	0007c783          	lbu	a5,0(a5)
    80005df0:	00f68023          	sb	a5,0(a3)
    } while ((x /= base) != 0);
    80005df4:	0005079b          	sext.w	a5,a0
    80005df8:	02b5553b          	divuw	a0,a0,a1
    80005dfc:	0685                	addi	a3,a3,1
    80005dfe:	feb7f0e3          	bgeu	a5,a1,80005dde <printint+0x26>

    if (sign)
    80005e02:	00088c63          	beqz	a7,80005e1a <printint+0x62>
        buf[i++] = '-';
    80005e06:	fe070793          	addi	a5,a4,-32
    80005e0a:	00878733          	add	a4,a5,s0
    80005e0e:	02d00793          	li	a5,45
    80005e12:	fef70823          	sb	a5,-16(a4)
    80005e16:	0028071b          	addiw	a4,a6,2

    while (--i >= 0)
    80005e1a:	02e05763          	blez	a4,80005e48 <printint+0x90>
    80005e1e:	fd040793          	addi	a5,s0,-48
    80005e22:	00e784b3          	add	s1,a5,a4
    80005e26:	fff78913          	addi	s2,a5,-1
    80005e2a:	993a                	add	s2,s2,a4
    80005e2c:	377d                	addiw	a4,a4,-1
    80005e2e:	1702                	slli	a4,a4,0x20
    80005e30:	9301                	srli	a4,a4,0x20
    80005e32:	40e90933          	sub	s2,s2,a4
        consputc(buf[i]);
    80005e36:	fff4c503          	lbu	a0,-1(s1)
    80005e3a:	00000097          	auipc	ra,0x0
    80005e3e:	d5e080e7          	jalr	-674(ra) # 80005b98 <consputc>
    while (--i >= 0)
    80005e42:	14fd                	addi	s1,s1,-1
    80005e44:	ff2499e3          	bne	s1,s2,80005e36 <printint+0x7e>
}
    80005e48:	70a2                	ld	ra,40(sp)
    80005e4a:	7402                	ld	s0,32(sp)
    80005e4c:	64e2                	ld	s1,24(sp)
    80005e4e:	6942                	ld	s2,16(sp)
    80005e50:	6145                	addi	sp,sp,48
    80005e52:	8082                	ret
        x = -xx;
    80005e54:	40a0053b          	negw	a0,a0
    if (sign && (sign = xx < 0))
    80005e58:	4885                	li	a7,1
        x = -xx;
    80005e5a:	bf95                	j	80005dce <printint+0x16>

0000000080005e5c <panic>:
    if (locking)
        release(&pr.lock);
}

void panic(char *s)
{
    80005e5c:	1101                	addi	sp,sp,-32
    80005e5e:	ec06                	sd	ra,24(sp)
    80005e60:	e822                	sd	s0,16(sp)
    80005e62:	e426                	sd	s1,8(sp)
    80005e64:	1000                	addi	s0,sp,32
    80005e66:	84aa                	mv	s1,a0
    pr.locking = 0;
    80005e68:	0023c797          	auipc	a5,0x23c
    80005e6c:	ec07ac23          	sw	zero,-296(a5) # 80241d40 <pr+0x18>
    printf("panic: ");
    80005e70:	00003517          	auipc	a0,0x3
    80005e74:	96850513          	addi	a0,a0,-1688 # 800087d8 <syscalls+0x3f8>
    80005e78:	00000097          	auipc	ra,0x0
    80005e7c:	02e080e7          	jalr	46(ra) # 80005ea6 <printf>
    printf(s);
    80005e80:	8526                	mv	a0,s1
    80005e82:	00000097          	auipc	ra,0x0
    80005e86:	024080e7          	jalr	36(ra) # 80005ea6 <printf>
    printf("\n");
    80005e8a:	00002517          	auipc	a0,0x2
    80005e8e:	1ce50513          	addi	a0,a0,462 # 80008058 <etext+0x58>
    80005e92:	00000097          	auipc	ra,0x0
    80005e96:	014080e7          	jalr	20(ra) # 80005ea6 <printf>
    panicked = 1; // freeze uart output from other CPUs
    80005e9a:	4785                	li	a5,1
    80005e9c:	00003717          	auipc	a4,0x3
    80005ea0:	a4f72023          	sw	a5,-1472(a4) # 800088dc <panicked>
    for (;;)
    80005ea4:	a001                	j	80005ea4 <panic+0x48>

0000000080005ea6 <printf>:
{
    80005ea6:	7131                	addi	sp,sp,-192
    80005ea8:	fc86                	sd	ra,120(sp)
    80005eaa:	f8a2                	sd	s0,112(sp)
    80005eac:	f4a6                	sd	s1,104(sp)
    80005eae:	f0ca                	sd	s2,96(sp)
    80005eb0:	ecce                	sd	s3,88(sp)
    80005eb2:	e8d2                	sd	s4,80(sp)
    80005eb4:	e4d6                	sd	s5,72(sp)
    80005eb6:	e0da                	sd	s6,64(sp)
    80005eb8:	fc5e                	sd	s7,56(sp)
    80005eba:	f862                	sd	s8,48(sp)
    80005ebc:	f466                	sd	s9,40(sp)
    80005ebe:	f06a                	sd	s10,32(sp)
    80005ec0:	ec6e                	sd	s11,24(sp)
    80005ec2:	0100                	addi	s0,sp,128
    80005ec4:	8a2a                	mv	s4,a0
    80005ec6:	e40c                	sd	a1,8(s0)
    80005ec8:	e810                	sd	a2,16(s0)
    80005eca:	ec14                	sd	a3,24(s0)
    80005ecc:	f018                	sd	a4,32(s0)
    80005ece:	f41c                	sd	a5,40(s0)
    80005ed0:	03043823          	sd	a6,48(s0)
    80005ed4:	03143c23          	sd	a7,56(s0)
    locking = pr.locking;
    80005ed8:	0023cd97          	auipc	s11,0x23c
    80005edc:	e68dad83          	lw	s11,-408(s11) # 80241d40 <pr+0x18>
    if (locking)
    80005ee0:	020d9b63          	bnez	s11,80005f16 <printf+0x70>
    if (fmt == 0)
    80005ee4:	040a0263          	beqz	s4,80005f28 <printf+0x82>
    va_start(ap, fmt);
    80005ee8:	00840793          	addi	a5,s0,8
    80005eec:	f8f43423          	sd	a5,-120(s0)
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80005ef0:	000a4503          	lbu	a0,0(s4)
    80005ef4:	14050f63          	beqz	a0,80006052 <printf+0x1ac>
    80005ef8:	4981                	li	s3,0
        if (c != '%') {
    80005efa:	02500a93          	li	s5,37
        switch (c) {
    80005efe:	07000b93          	li	s7,112
    consputc('x');
    80005f02:	4d41                	li	s10,16
        consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f04:	00003b17          	auipc	s6,0x3
    80005f08:	8fcb0b13          	addi	s6,s6,-1796 # 80008800 <digits>
        switch (c) {
    80005f0c:	07300c93          	li	s9,115
    80005f10:	06400c13          	li	s8,100
    80005f14:	a82d                	j	80005f4e <printf+0xa8>
        acquire(&pr.lock);
    80005f16:	0023c517          	auipc	a0,0x23c
    80005f1a:	e1250513          	addi	a0,a0,-494 # 80241d28 <pr>
    80005f1e:	00000097          	auipc	ra,0x0
    80005f22:	476080e7          	jalr	1142(ra) # 80006394 <acquire>
    80005f26:	bf7d                	j	80005ee4 <printf+0x3e>
        panic("null fmt");
    80005f28:	00003517          	auipc	a0,0x3
    80005f2c:	8c050513          	addi	a0,a0,-1856 # 800087e8 <syscalls+0x408>
    80005f30:	00000097          	auipc	ra,0x0
    80005f34:	f2c080e7          	jalr	-212(ra) # 80005e5c <panic>
            consputc(c);
    80005f38:	00000097          	auipc	ra,0x0
    80005f3c:	c60080e7          	jalr	-928(ra) # 80005b98 <consputc>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80005f40:	2985                	addiw	s3,s3,1
    80005f42:	013a07b3          	add	a5,s4,s3
    80005f46:	0007c503          	lbu	a0,0(a5)
    80005f4a:	10050463          	beqz	a0,80006052 <printf+0x1ac>
        if (c != '%') {
    80005f4e:	ff5515e3          	bne	a0,s5,80005f38 <printf+0x92>
        c = fmt[++i] & 0xff;
    80005f52:	2985                	addiw	s3,s3,1
    80005f54:	013a07b3          	add	a5,s4,s3
    80005f58:	0007c783          	lbu	a5,0(a5)
    80005f5c:	0007849b          	sext.w	s1,a5
        if (c == 0)
    80005f60:	cbed                	beqz	a5,80006052 <printf+0x1ac>
        switch (c) {
    80005f62:	05778a63          	beq	a5,s7,80005fb6 <printf+0x110>
    80005f66:	02fbf663          	bgeu	s7,a5,80005f92 <printf+0xec>
    80005f6a:	09978863          	beq	a5,s9,80005ffa <printf+0x154>
    80005f6e:	07800713          	li	a4,120
    80005f72:	0ce79563          	bne	a5,a4,8000603c <printf+0x196>
            printint(va_arg(ap, int), 16, 1);
    80005f76:	f8843783          	ld	a5,-120(s0)
    80005f7a:	00878713          	addi	a4,a5,8
    80005f7e:	f8e43423          	sd	a4,-120(s0)
    80005f82:	4605                	li	a2,1
    80005f84:	85ea                	mv	a1,s10
    80005f86:	4388                	lw	a0,0(a5)
    80005f88:	00000097          	auipc	ra,0x0
    80005f8c:	e30080e7          	jalr	-464(ra) # 80005db8 <printint>
            break;
    80005f90:	bf45                	j	80005f40 <printf+0x9a>
        switch (c) {
    80005f92:	09578f63          	beq	a5,s5,80006030 <printf+0x18a>
    80005f96:	0b879363          	bne	a5,s8,8000603c <printf+0x196>
            printint(va_arg(ap, int), 10, 1);
    80005f9a:	f8843783          	ld	a5,-120(s0)
    80005f9e:	00878713          	addi	a4,a5,8
    80005fa2:	f8e43423          	sd	a4,-120(s0)
    80005fa6:	4605                	li	a2,1
    80005fa8:	45a9                	li	a1,10
    80005faa:	4388                	lw	a0,0(a5)
    80005fac:	00000097          	auipc	ra,0x0
    80005fb0:	e0c080e7          	jalr	-500(ra) # 80005db8 <printint>
            break;
    80005fb4:	b771                	j	80005f40 <printf+0x9a>
            printptr(va_arg(ap, uint64));
    80005fb6:	f8843783          	ld	a5,-120(s0)
    80005fba:	00878713          	addi	a4,a5,8
    80005fbe:	f8e43423          	sd	a4,-120(s0)
    80005fc2:	0007b903          	ld	s2,0(a5)
    consputc('0');
    80005fc6:	03000513          	li	a0,48
    80005fca:	00000097          	auipc	ra,0x0
    80005fce:	bce080e7          	jalr	-1074(ra) # 80005b98 <consputc>
    consputc('x');
    80005fd2:	07800513          	li	a0,120
    80005fd6:	00000097          	auipc	ra,0x0
    80005fda:	bc2080e7          	jalr	-1086(ra) # 80005b98 <consputc>
    80005fde:	84ea                	mv	s1,s10
        consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005fe0:	03c95793          	srli	a5,s2,0x3c
    80005fe4:	97da                	add	a5,a5,s6
    80005fe6:	0007c503          	lbu	a0,0(a5)
    80005fea:	00000097          	auipc	ra,0x0
    80005fee:	bae080e7          	jalr	-1106(ra) # 80005b98 <consputc>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005ff2:	0912                	slli	s2,s2,0x4
    80005ff4:	34fd                	addiw	s1,s1,-1
    80005ff6:	f4ed                	bnez	s1,80005fe0 <printf+0x13a>
    80005ff8:	b7a1                	j	80005f40 <printf+0x9a>
            if ((s = va_arg(ap, char *)) == 0)
    80005ffa:	f8843783          	ld	a5,-120(s0)
    80005ffe:	00878713          	addi	a4,a5,8
    80006002:	f8e43423          	sd	a4,-120(s0)
    80006006:	6384                	ld	s1,0(a5)
    80006008:	cc89                	beqz	s1,80006022 <printf+0x17c>
            for (; *s; s++)
    8000600a:	0004c503          	lbu	a0,0(s1)
    8000600e:	d90d                	beqz	a0,80005f40 <printf+0x9a>
                consputc(*s);
    80006010:	00000097          	auipc	ra,0x0
    80006014:	b88080e7          	jalr	-1144(ra) # 80005b98 <consputc>
            for (; *s; s++)
    80006018:	0485                	addi	s1,s1,1
    8000601a:	0004c503          	lbu	a0,0(s1)
    8000601e:	f96d                	bnez	a0,80006010 <printf+0x16a>
    80006020:	b705                	j	80005f40 <printf+0x9a>
                s = "(null)";
    80006022:	00002497          	auipc	s1,0x2
    80006026:	7be48493          	addi	s1,s1,1982 # 800087e0 <syscalls+0x400>
            for (; *s; s++)
    8000602a:	02800513          	li	a0,40
    8000602e:	b7cd                	j	80006010 <printf+0x16a>
            consputc('%');
    80006030:	8556                	mv	a0,s5
    80006032:	00000097          	auipc	ra,0x0
    80006036:	b66080e7          	jalr	-1178(ra) # 80005b98 <consputc>
            break;
    8000603a:	b719                	j	80005f40 <printf+0x9a>
            consputc('%');
    8000603c:	8556                	mv	a0,s5
    8000603e:	00000097          	auipc	ra,0x0
    80006042:	b5a080e7          	jalr	-1190(ra) # 80005b98 <consputc>
            consputc(c);
    80006046:	8526                	mv	a0,s1
    80006048:	00000097          	auipc	ra,0x0
    8000604c:	b50080e7          	jalr	-1200(ra) # 80005b98 <consputc>
            break;
    80006050:	bdc5                	j	80005f40 <printf+0x9a>
    if (locking)
    80006052:	020d9163          	bnez	s11,80006074 <printf+0x1ce>
}
    80006056:	70e6                	ld	ra,120(sp)
    80006058:	7446                	ld	s0,112(sp)
    8000605a:	74a6                	ld	s1,104(sp)
    8000605c:	7906                	ld	s2,96(sp)
    8000605e:	69e6                	ld	s3,88(sp)
    80006060:	6a46                	ld	s4,80(sp)
    80006062:	6aa6                	ld	s5,72(sp)
    80006064:	6b06                	ld	s6,64(sp)
    80006066:	7be2                	ld	s7,56(sp)
    80006068:	7c42                	ld	s8,48(sp)
    8000606a:	7ca2                	ld	s9,40(sp)
    8000606c:	7d02                	ld	s10,32(sp)
    8000606e:	6de2                	ld	s11,24(sp)
    80006070:	6129                	addi	sp,sp,192
    80006072:	8082                	ret
        release(&pr.lock);
    80006074:	0023c517          	auipc	a0,0x23c
    80006078:	cb450513          	addi	a0,a0,-844 # 80241d28 <pr>
    8000607c:	00000097          	auipc	ra,0x0
    80006080:	3cc080e7          	jalr	972(ra) # 80006448 <release>
}
    80006084:	bfc9                	j	80006056 <printf+0x1b0>

0000000080006086 <printfinit>:
        ;
}

void printfinit(void)
{
    80006086:	1101                	addi	sp,sp,-32
    80006088:	ec06                	sd	ra,24(sp)
    8000608a:	e822                	sd	s0,16(sp)
    8000608c:	e426                	sd	s1,8(sp)
    8000608e:	1000                	addi	s0,sp,32
    initlock(&pr.lock, "pr");
    80006090:	0023c497          	auipc	s1,0x23c
    80006094:	c9848493          	addi	s1,s1,-872 # 80241d28 <pr>
    80006098:	00002597          	auipc	a1,0x2
    8000609c:	76058593          	addi	a1,a1,1888 # 800087f8 <syscalls+0x418>
    800060a0:	8526                	mv	a0,s1
    800060a2:	00000097          	auipc	ra,0x0
    800060a6:	262080e7          	jalr	610(ra) # 80006304 <initlock>
    pr.locking = 1;
    800060aa:	4785                	li	a5,1
    800060ac:	cc9c                	sw	a5,24(s1)
}
    800060ae:	60e2                	ld	ra,24(sp)
    800060b0:	6442                	ld	s0,16(sp)
    800060b2:	64a2                	ld	s1,8(sp)
    800060b4:	6105                	addi	sp,sp,32
    800060b6:	8082                	ret

00000000800060b8 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800060b8:	1141                	addi	sp,sp,-16
    800060ba:	e406                	sd	ra,8(sp)
    800060bc:	e022                	sd	s0,0(sp)
    800060be:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800060c0:	100007b7          	lui	a5,0x10000
    800060c4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800060c8:	f8000713          	li	a4,-128
    800060cc:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800060d0:	470d                	li	a4,3
    800060d2:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800060d6:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800060da:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800060de:	469d                	li	a3,7
    800060e0:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800060e4:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800060e8:	00002597          	auipc	a1,0x2
    800060ec:	73058593          	addi	a1,a1,1840 # 80008818 <digits+0x18>
    800060f0:	0023c517          	auipc	a0,0x23c
    800060f4:	c5850513          	addi	a0,a0,-936 # 80241d48 <uart_tx_lock>
    800060f8:	00000097          	auipc	ra,0x0
    800060fc:	20c080e7          	jalr	524(ra) # 80006304 <initlock>
}
    80006100:	60a2                	ld	ra,8(sp)
    80006102:	6402                	ld	s0,0(sp)
    80006104:	0141                	addi	sp,sp,16
    80006106:	8082                	ret

0000000080006108 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006108:	1101                	addi	sp,sp,-32
    8000610a:	ec06                	sd	ra,24(sp)
    8000610c:	e822                	sd	s0,16(sp)
    8000610e:	e426                	sd	s1,8(sp)
    80006110:	1000                	addi	s0,sp,32
    80006112:	84aa                	mv	s1,a0
  push_off();
    80006114:	00000097          	auipc	ra,0x0
    80006118:	234080e7          	jalr	564(ra) # 80006348 <push_off>

  if(panicked){
    8000611c:	00002797          	auipc	a5,0x2
    80006120:	7c07a783          	lw	a5,1984(a5) # 800088dc <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006124:	10000737          	lui	a4,0x10000
  if(panicked){
    80006128:	c391                	beqz	a5,8000612c <uartputc_sync+0x24>
    for(;;)
    8000612a:	a001                	j	8000612a <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000612c:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006130:	0207f793          	andi	a5,a5,32
    80006134:	dfe5                	beqz	a5,8000612c <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006136:	0ff4f513          	zext.b	a0,s1
    8000613a:	100007b7          	lui	a5,0x10000
    8000613e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006142:	00000097          	auipc	ra,0x0
    80006146:	2a6080e7          	jalr	678(ra) # 800063e8 <pop_off>
}
    8000614a:	60e2                	ld	ra,24(sp)
    8000614c:	6442                	ld	s0,16(sp)
    8000614e:	64a2                	ld	s1,8(sp)
    80006150:	6105                	addi	sp,sp,32
    80006152:	8082                	ret

0000000080006154 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006154:	00002797          	auipc	a5,0x2
    80006158:	78c7b783          	ld	a5,1932(a5) # 800088e0 <uart_tx_r>
    8000615c:	00002717          	auipc	a4,0x2
    80006160:	78c73703          	ld	a4,1932(a4) # 800088e8 <uart_tx_w>
    80006164:	06f70a63          	beq	a4,a5,800061d8 <uartstart+0x84>
{
    80006168:	7139                	addi	sp,sp,-64
    8000616a:	fc06                	sd	ra,56(sp)
    8000616c:	f822                	sd	s0,48(sp)
    8000616e:	f426                	sd	s1,40(sp)
    80006170:	f04a                	sd	s2,32(sp)
    80006172:	ec4e                	sd	s3,24(sp)
    80006174:	e852                	sd	s4,16(sp)
    80006176:	e456                	sd	s5,8(sp)
    80006178:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000617a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000617e:	0023ca17          	auipc	s4,0x23c
    80006182:	bcaa0a13          	addi	s4,s4,-1078 # 80241d48 <uart_tx_lock>
    uart_tx_r += 1;
    80006186:	00002497          	auipc	s1,0x2
    8000618a:	75a48493          	addi	s1,s1,1882 # 800088e0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000618e:	00002997          	auipc	s3,0x2
    80006192:	75a98993          	addi	s3,s3,1882 # 800088e8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006196:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000619a:	02077713          	andi	a4,a4,32
    8000619e:	c705                	beqz	a4,800061c6 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061a0:	01f7f713          	andi	a4,a5,31
    800061a4:	9752                	add	a4,a4,s4
    800061a6:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800061aa:	0785                	addi	a5,a5,1
    800061ac:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800061ae:	8526                	mv	a0,s1
    800061b0:	ffffb097          	auipc	ra,0xffffb
    800061b4:	50a080e7          	jalr	1290(ra) # 800016ba <wakeup>
    
    WriteReg(THR, c);
    800061b8:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800061bc:	609c                	ld	a5,0(s1)
    800061be:	0009b703          	ld	a4,0(s3)
    800061c2:	fcf71ae3          	bne	a4,a5,80006196 <uartstart+0x42>
  }
}
    800061c6:	70e2                	ld	ra,56(sp)
    800061c8:	7442                	ld	s0,48(sp)
    800061ca:	74a2                	ld	s1,40(sp)
    800061cc:	7902                	ld	s2,32(sp)
    800061ce:	69e2                	ld	s3,24(sp)
    800061d0:	6a42                	ld	s4,16(sp)
    800061d2:	6aa2                	ld	s5,8(sp)
    800061d4:	6121                	addi	sp,sp,64
    800061d6:	8082                	ret
    800061d8:	8082                	ret

00000000800061da <uartputc>:
{
    800061da:	7179                	addi	sp,sp,-48
    800061dc:	f406                	sd	ra,40(sp)
    800061de:	f022                	sd	s0,32(sp)
    800061e0:	ec26                	sd	s1,24(sp)
    800061e2:	e84a                	sd	s2,16(sp)
    800061e4:	e44e                	sd	s3,8(sp)
    800061e6:	e052                	sd	s4,0(sp)
    800061e8:	1800                	addi	s0,sp,48
    800061ea:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800061ec:	0023c517          	auipc	a0,0x23c
    800061f0:	b5c50513          	addi	a0,a0,-1188 # 80241d48 <uart_tx_lock>
    800061f4:	00000097          	auipc	ra,0x0
    800061f8:	1a0080e7          	jalr	416(ra) # 80006394 <acquire>
  if(panicked){
    800061fc:	00002797          	auipc	a5,0x2
    80006200:	6e07a783          	lw	a5,1760(a5) # 800088dc <panicked>
    80006204:	e7c9                	bnez	a5,8000628e <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006206:	00002717          	auipc	a4,0x2
    8000620a:	6e273703          	ld	a4,1762(a4) # 800088e8 <uart_tx_w>
    8000620e:	00002797          	auipc	a5,0x2
    80006212:	6d27b783          	ld	a5,1746(a5) # 800088e0 <uart_tx_r>
    80006216:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000621a:	0023c997          	auipc	s3,0x23c
    8000621e:	b2e98993          	addi	s3,s3,-1234 # 80241d48 <uart_tx_lock>
    80006222:	00002497          	auipc	s1,0x2
    80006226:	6be48493          	addi	s1,s1,1726 # 800088e0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000622a:	00002917          	auipc	s2,0x2
    8000622e:	6be90913          	addi	s2,s2,1726 # 800088e8 <uart_tx_w>
    80006232:	00e79f63          	bne	a5,a4,80006250 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006236:	85ce                	mv	a1,s3
    80006238:	8526                	mv	a0,s1
    8000623a:	ffffb097          	auipc	ra,0xffffb
    8000623e:	41c080e7          	jalr	1052(ra) # 80001656 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006242:	00093703          	ld	a4,0(s2)
    80006246:	609c                	ld	a5,0(s1)
    80006248:	02078793          	addi	a5,a5,32
    8000624c:	fee785e3          	beq	a5,a4,80006236 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006250:	0023c497          	auipc	s1,0x23c
    80006254:	af848493          	addi	s1,s1,-1288 # 80241d48 <uart_tx_lock>
    80006258:	01f77793          	andi	a5,a4,31
    8000625c:	97a6                	add	a5,a5,s1
    8000625e:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006262:	0705                	addi	a4,a4,1
    80006264:	00002797          	auipc	a5,0x2
    80006268:	68e7b223          	sd	a4,1668(a5) # 800088e8 <uart_tx_w>
  uartstart();
    8000626c:	00000097          	auipc	ra,0x0
    80006270:	ee8080e7          	jalr	-280(ra) # 80006154 <uartstart>
  release(&uart_tx_lock);
    80006274:	8526                	mv	a0,s1
    80006276:	00000097          	auipc	ra,0x0
    8000627a:	1d2080e7          	jalr	466(ra) # 80006448 <release>
}
    8000627e:	70a2                	ld	ra,40(sp)
    80006280:	7402                	ld	s0,32(sp)
    80006282:	64e2                	ld	s1,24(sp)
    80006284:	6942                	ld	s2,16(sp)
    80006286:	69a2                	ld	s3,8(sp)
    80006288:	6a02                	ld	s4,0(sp)
    8000628a:	6145                	addi	sp,sp,48
    8000628c:	8082                	ret
    for(;;)
    8000628e:	a001                	j	8000628e <uartputc+0xb4>

0000000080006290 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006290:	1141                	addi	sp,sp,-16
    80006292:	e422                	sd	s0,8(sp)
    80006294:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006296:	100007b7          	lui	a5,0x10000
    8000629a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000629e:	8b85                	andi	a5,a5,1
    800062a0:	cb81                	beqz	a5,800062b0 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800062a2:	100007b7          	lui	a5,0x10000
    800062a6:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800062aa:	6422                	ld	s0,8(sp)
    800062ac:	0141                	addi	sp,sp,16
    800062ae:	8082                	ret
    return -1;
    800062b0:	557d                	li	a0,-1
    800062b2:	bfe5                	j	800062aa <uartgetc+0x1a>

00000000800062b4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800062b4:	1101                	addi	sp,sp,-32
    800062b6:	ec06                	sd	ra,24(sp)
    800062b8:	e822                	sd	s0,16(sp)
    800062ba:	e426                	sd	s1,8(sp)
    800062bc:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800062be:	54fd                	li	s1,-1
    800062c0:	a029                	j	800062ca <uartintr+0x16>
      break;
    consoleintr(c);
    800062c2:	00000097          	auipc	ra,0x0
    800062c6:	918080e7          	jalr	-1768(ra) # 80005bda <consoleintr>
    int c = uartgetc();
    800062ca:	00000097          	auipc	ra,0x0
    800062ce:	fc6080e7          	jalr	-58(ra) # 80006290 <uartgetc>
    if(c == -1)
    800062d2:	fe9518e3          	bne	a0,s1,800062c2 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800062d6:	0023c497          	auipc	s1,0x23c
    800062da:	a7248493          	addi	s1,s1,-1422 # 80241d48 <uart_tx_lock>
    800062de:	8526                	mv	a0,s1
    800062e0:	00000097          	auipc	ra,0x0
    800062e4:	0b4080e7          	jalr	180(ra) # 80006394 <acquire>
  uartstart();
    800062e8:	00000097          	auipc	ra,0x0
    800062ec:	e6c080e7          	jalr	-404(ra) # 80006154 <uartstart>
  release(&uart_tx_lock);
    800062f0:	8526                	mv	a0,s1
    800062f2:	00000097          	auipc	ra,0x0
    800062f6:	156080e7          	jalr	342(ra) # 80006448 <release>
}
    800062fa:	60e2                	ld	ra,24(sp)
    800062fc:	6442                	ld	s0,16(sp)
    800062fe:	64a2                	ld	s1,8(sp)
    80006300:	6105                	addi	sp,sp,32
    80006302:	8082                	ret

0000000080006304 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006304:	1141                	addi	sp,sp,-16
    80006306:	e422                	sd	s0,8(sp)
    80006308:	0800                	addi	s0,sp,16
  lk->name = name;
    8000630a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000630c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006310:	00053823          	sd	zero,16(a0)
}
    80006314:	6422                	ld	s0,8(sp)
    80006316:	0141                	addi	sp,sp,16
    80006318:	8082                	ret

000000008000631a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000631a:	411c                	lw	a5,0(a0)
    8000631c:	e399                	bnez	a5,80006322 <holding+0x8>
    8000631e:	4501                	li	a0,0
  return r;
}
    80006320:	8082                	ret
{
    80006322:	1101                	addi	sp,sp,-32
    80006324:	ec06                	sd	ra,24(sp)
    80006326:	e822                	sd	s0,16(sp)
    80006328:	e426                	sd	s1,8(sp)
    8000632a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000632c:	6904                	ld	s1,16(a0)
    8000632e:	ffffb097          	auipc	ra,0xffffb
    80006332:	c64080e7          	jalr	-924(ra) # 80000f92 <mycpu>
    80006336:	40a48533          	sub	a0,s1,a0
    8000633a:	00153513          	seqz	a0,a0
}
    8000633e:	60e2                	ld	ra,24(sp)
    80006340:	6442                	ld	s0,16(sp)
    80006342:	64a2                	ld	s1,8(sp)
    80006344:	6105                	addi	sp,sp,32
    80006346:	8082                	ret

0000000080006348 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006348:	1101                	addi	sp,sp,-32
    8000634a:	ec06                	sd	ra,24(sp)
    8000634c:	e822                	sd	s0,16(sp)
    8000634e:	e426                	sd	s1,8(sp)
    80006350:	1000                	addi	s0,sp,32
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80006352:	100024f3          	csrr	s1,sstatus
    80006356:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000635a:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sstatus, %0" : : "r"(x));
    8000635c:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006360:	ffffb097          	auipc	ra,0xffffb
    80006364:	c32080e7          	jalr	-974(ra) # 80000f92 <mycpu>
    80006368:	5d3c                	lw	a5,120(a0)
    8000636a:	cf89                	beqz	a5,80006384 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000636c:	ffffb097          	auipc	ra,0xffffb
    80006370:	c26080e7          	jalr	-986(ra) # 80000f92 <mycpu>
    80006374:	5d3c                	lw	a5,120(a0)
    80006376:	2785                	addiw	a5,a5,1
    80006378:	dd3c                	sw	a5,120(a0)
}
    8000637a:	60e2                	ld	ra,24(sp)
    8000637c:	6442                	ld	s0,16(sp)
    8000637e:	64a2                	ld	s1,8(sp)
    80006380:	6105                	addi	sp,sp,32
    80006382:	8082                	ret
    mycpu()->intena = old;
    80006384:	ffffb097          	auipc	ra,0xffffb
    80006388:	c0e080e7          	jalr	-1010(ra) # 80000f92 <mycpu>
    return (x & SSTATUS_SIE) != 0;
    8000638c:	8085                	srli	s1,s1,0x1
    8000638e:	8885                	andi	s1,s1,1
    80006390:	dd64                	sw	s1,124(a0)
    80006392:	bfe9                	j	8000636c <push_off+0x24>

0000000080006394 <acquire>:
{
    80006394:	1101                	addi	sp,sp,-32
    80006396:	ec06                	sd	ra,24(sp)
    80006398:	e822                	sd	s0,16(sp)
    8000639a:	e426                	sd	s1,8(sp)
    8000639c:	1000                	addi	s0,sp,32
    8000639e:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800063a0:	00000097          	auipc	ra,0x0
    800063a4:	fa8080e7          	jalr	-88(ra) # 80006348 <push_off>
  if(holding(lk))
    800063a8:	8526                	mv	a0,s1
    800063aa:	00000097          	auipc	ra,0x0
    800063ae:	f70080e7          	jalr	-144(ra) # 8000631a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063b2:	4705                	li	a4,1
  if(holding(lk))
    800063b4:	e115                	bnez	a0,800063d8 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063b6:	87ba                	mv	a5,a4
    800063b8:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800063bc:	2781                	sext.w	a5,a5
    800063be:	ffe5                	bnez	a5,800063b6 <acquire+0x22>
  __sync_synchronize();
    800063c0:	0ff0000f          	fence
  lk->cpu = mycpu();
    800063c4:	ffffb097          	auipc	ra,0xffffb
    800063c8:	bce080e7          	jalr	-1074(ra) # 80000f92 <mycpu>
    800063cc:	e888                	sd	a0,16(s1)
}
    800063ce:	60e2                	ld	ra,24(sp)
    800063d0:	6442                	ld	s0,16(sp)
    800063d2:	64a2                	ld	s1,8(sp)
    800063d4:	6105                	addi	sp,sp,32
    800063d6:	8082                	ret
    panic("acquire");
    800063d8:	00002517          	auipc	a0,0x2
    800063dc:	44850513          	addi	a0,a0,1096 # 80008820 <digits+0x20>
    800063e0:	00000097          	auipc	ra,0x0
    800063e4:	a7c080e7          	jalr	-1412(ra) # 80005e5c <panic>

00000000800063e8 <pop_off>:

void
pop_off(void)
{
    800063e8:	1141                	addi	sp,sp,-16
    800063ea:	e406                	sd	ra,8(sp)
    800063ec:	e022                	sd	s0,0(sp)
    800063ee:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800063f0:	ffffb097          	auipc	ra,0xffffb
    800063f4:	ba2080e7          	jalr	-1118(ra) # 80000f92 <mycpu>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    800063f8:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    800063fc:	8b89                	andi	a5,a5,2
  if(intr_get())
    800063fe:	e78d                	bnez	a5,80006428 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006400:	5d3c                	lw	a5,120(a0)
    80006402:	02f05b63          	blez	a5,80006438 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006406:	37fd                	addiw	a5,a5,-1
    80006408:	0007871b          	sext.w	a4,a5
    8000640c:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000640e:	eb09                	bnez	a4,80006420 <pop_off+0x38>
    80006410:	5d7c                	lw	a5,124(a0)
    80006412:	c799                	beqz	a5,80006420 <pop_off+0x38>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80006414:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006418:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    8000641c:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006420:	60a2                	ld	ra,8(sp)
    80006422:	6402                	ld	s0,0(sp)
    80006424:	0141                	addi	sp,sp,16
    80006426:	8082                	ret
    panic("pop_off - interruptible");
    80006428:	00002517          	auipc	a0,0x2
    8000642c:	40050513          	addi	a0,a0,1024 # 80008828 <digits+0x28>
    80006430:	00000097          	auipc	ra,0x0
    80006434:	a2c080e7          	jalr	-1492(ra) # 80005e5c <panic>
    panic("pop_off");
    80006438:	00002517          	auipc	a0,0x2
    8000643c:	40850513          	addi	a0,a0,1032 # 80008840 <digits+0x40>
    80006440:	00000097          	auipc	ra,0x0
    80006444:	a1c080e7          	jalr	-1508(ra) # 80005e5c <panic>

0000000080006448 <release>:
{
    80006448:	1101                	addi	sp,sp,-32
    8000644a:	ec06                	sd	ra,24(sp)
    8000644c:	e822                	sd	s0,16(sp)
    8000644e:	e426                	sd	s1,8(sp)
    80006450:	1000                	addi	s0,sp,32
    80006452:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006454:	00000097          	auipc	ra,0x0
    80006458:	ec6080e7          	jalr	-314(ra) # 8000631a <holding>
    8000645c:	c115                	beqz	a0,80006480 <release+0x38>
  lk->cpu = 0;
    8000645e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006462:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006466:	0f50000f          	fence	iorw,ow
    8000646a:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000646e:	00000097          	auipc	ra,0x0
    80006472:	f7a080e7          	jalr	-134(ra) # 800063e8 <pop_off>
}
    80006476:	60e2                	ld	ra,24(sp)
    80006478:	6442                	ld	s0,16(sp)
    8000647a:	64a2                	ld	s1,8(sp)
    8000647c:	6105                	addi	sp,sp,32
    8000647e:	8082                	ret
    panic("release");
    80006480:	00002517          	auipc	a0,0x2
    80006484:	3c850513          	addi	a0,a0,968 # 80008848 <digits+0x48>
    80006488:	00000097          	auipc	ra,0x0
    8000648c:	9d4080e7          	jalr	-1580(ra) # 80005e5c <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
