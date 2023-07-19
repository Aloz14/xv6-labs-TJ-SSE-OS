
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	a5013103          	ld	sp,-1456(sp) # 80008a50 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	7e2050ef          	jal	ra,800057f8 <start>

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
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	0e078793          	addi	a5,a5,224 # 80022110 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
        panic("kfree");

    // Fill with junk to catch dangling refs.
    memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	156080e7          	jalr	342(ra) # 8000019e <memset>

    r = (struct run *)pa;

    acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	a5090913          	addi	s2,s2,-1456 # 80008aa0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	18a080e7          	jalr	394(ra) # 800061e4 <acquire>
    r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
    kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
    release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	22a080e7          	jalr	554(ra) # 80006298 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
        panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	c22080e7          	jalr	-990(ra) # 80005cac <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
    p = (char *)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
        kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
        kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
    initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	addi	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	9b250513          	addi	a0,a0,-1614 # 80008aa0 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	05e080e7          	jalr	94(ra) # 80006154 <initlock>
    freerange(end, (void *)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00022517          	auipc	a0,0x22
    80000106:	00e50513          	addi	a0,a0,14 # 80022110 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
    struct run *r;

    acquire(&kmem.lock);
    80000124:	00009497          	auipc	s1,0x9
    80000128:	97c48493          	addi	s1,s1,-1668 # 80008aa0 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	0b6080e7          	jalr	182(ra) # 800061e4 <acquire>
    r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
    if (r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
        kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	96450513          	addi	a0,a0,-1692 # 80008aa0 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
    release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	152080e7          	jalr	338(ra) # 80006298 <release>

    if (r)
        memset((char *)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	04a080e7          	jalr	74(ra) # 8000019e <memset>
    return (void *)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
    release(&kmem.lock);
    80000168:	00009517          	auipc	a0,0x9
    8000016c:	93850513          	addi	a0,a0,-1736 # 80008aa0 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	128080e7          	jalr	296(ra) # 80006298 <release>
    if (r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <countMEM>:

uint64 countMEM()
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
    struct run *p = kmem.freelist;
    80000180:	00009797          	auipc	a5,0x9
    80000184:	9387b783          	ld	a5,-1736(a5) # 80008ab8 <kmem+0x18>
    uint64 count = 0;
    while (p) {
    80000188:	cb89                	beqz	a5,8000019a <countMEM+0x20>
    uint64 count = 0;
    8000018a:	4501                	li	a0,0
        count++;
    8000018c:	0505                	addi	a0,a0,1
        p = p->next;
    8000018e:	639c                	ld	a5,0(a5)
    while (p) {
    80000190:	fff5                	bnez	a5,8000018c <countMEM+0x12>
    }
    return count * PGSIZE;
}
    80000192:	0532                	slli	a0,a0,0xc
    80000194:	6422                	ld	s0,8(sp)
    80000196:	0141                	addi	sp,sp,16
    80000198:	8082                	ret
    uint64 count = 0;
    8000019a:	4501                	li	a0,0
    8000019c:	bfdd                	j	80000192 <countMEM+0x18>

000000008000019e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001a4:	ca19                	beqz	a2,800001ba <memset+0x1c>
    800001a6:	87aa                	mv	a5,a0
    800001a8:	1602                	slli	a2,a2,0x20
    800001aa:	9201                	srli	a2,a2,0x20
    800001ac:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800001b0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001b4:	0785                	addi	a5,a5,1
    800001b6:	fee79de3          	bne	a5,a4,800001b0 <memset+0x12>
  }
  return dst;
}
    800001ba:	6422                	ld	s0,8(sp)
    800001bc:	0141                	addi	sp,sp,16
    800001be:	8082                	ret

00000000800001c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001c0:	1141                	addi	sp,sp,-16
    800001c2:	e422                	sd	s0,8(sp)
    800001c4:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001c6:	ca05                	beqz	a2,800001f6 <memcmp+0x36>
    800001c8:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001cc:	1682                	slli	a3,a3,0x20
    800001ce:	9281                	srli	a3,a3,0x20
    800001d0:	0685                	addi	a3,a3,1
    800001d2:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001d4:	00054783          	lbu	a5,0(a0)
    800001d8:	0005c703          	lbu	a4,0(a1)
    800001dc:	00e79863          	bne	a5,a4,800001ec <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001e0:	0505                	addi	a0,a0,1
    800001e2:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001e4:	fed518e3          	bne	a0,a3,800001d4 <memcmp+0x14>
  }

  return 0;
    800001e8:	4501                	li	a0,0
    800001ea:	a019                	j	800001f0 <memcmp+0x30>
      return *s1 - *s2;
    800001ec:	40e7853b          	subw	a0,a5,a4
}
    800001f0:	6422                	ld	s0,8(sp)
    800001f2:	0141                	addi	sp,sp,16
    800001f4:	8082                	ret
  return 0;
    800001f6:	4501                	li	a0,0
    800001f8:	bfe5                	j	800001f0 <memcmp+0x30>

00000000800001fa <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001fa:	1141                	addi	sp,sp,-16
    800001fc:	e422                	sd	s0,8(sp)
    800001fe:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000200:	c205                	beqz	a2,80000220 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000202:	02a5e263          	bltu	a1,a0,80000226 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000206:	1602                	slli	a2,a2,0x20
    80000208:	9201                	srli	a2,a2,0x20
    8000020a:	00c587b3          	add	a5,a1,a2
{
    8000020e:	872a                	mv	a4,a0
      *d++ = *s++;
    80000210:	0585                	addi	a1,a1,1
    80000212:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdcef1>
    80000214:	fff5c683          	lbu	a3,-1(a1)
    80000218:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000021c:	fef59ae3          	bne	a1,a5,80000210 <memmove+0x16>

  return dst;
}
    80000220:	6422                	ld	s0,8(sp)
    80000222:	0141                	addi	sp,sp,16
    80000224:	8082                	ret
  if(s < d && s + n > d){
    80000226:	02061693          	slli	a3,a2,0x20
    8000022a:	9281                	srli	a3,a3,0x20
    8000022c:	00d58733          	add	a4,a1,a3
    80000230:	fce57be3          	bgeu	a0,a4,80000206 <memmove+0xc>
    d += n;
    80000234:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000236:	fff6079b          	addiw	a5,a2,-1
    8000023a:	1782                	slli	a5,a5,0x20
    8000023c:	9381                	srli	a5,a5,0x20
    8000023e:	fff7c793          	not	a5,a5
    80000242:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000244:	177d                	addi	a4,a4,-1
    80000246:	16fd                	addi	a3,a3,-1
    80000248:	00074603          	lbu	a2,0(a4)
    8000024c:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000250:	fee79ae3          	bne	a5,a4,80000244 <memmove+0x4a>
    80000254:	b7f1                	j	80000220 <memmove+0x26>

0000000080000256 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000256:	1141                	addi	sp,sp,-16
    80000258:	e406                	sd	ra,8(sp)
    8000025a:	e022                	sd	s0,0(sp)
    8000025c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000025e:	00000097          	auipc	ra,0x0
    80000262:	f9c080e7          	jalr	-100(ra) # 800001fa <memmove>
}
    80000266:	60a2                	ld	ra,8(sp)
    80000268:	6402                	ld	s0,0(sp)
    8000026a:	0141                	addi	sp,sp,16
    8000026c:	8082                	ret

000000008000026e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000026e:	1141                	addi	sp,sp,-16
    80000270:	e422                	sd	s0,8(sp)
    80000272:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000274:	ce11                	beqz	a2,80000290 <strncmp+0x22>
    80000276:	00054783          	lbu	a5,0(a0)
    8000027a:	cf89                	beqz	a5,80000294 <strncmp+0x26>
    8000027c:	0005c703          	lbu	a4,0(a1)
    80000280:	00f71a63          	bne	a4,a5,80000294 <strncmp+0x26>
    n--, p++, q++;
    80000284:	367d                	addiw	a2,a2,-1
    80000286:	0505                	addi	a0,a0,1
    80000288:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000028a:	f675                	bnez	a2,80000276 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000028c:	4501                	li	a0,0
    8000028e:	a809                	j	800002a0 <strncmp+0x32>
    80000290:	4501                	li	a0,0
    80000292:	a039                	j	800002a0 <strncmp+0x32>
  if(n == 0)
    80000294:	ca09                	beqz	a2,800002a6 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000296:	00054503          	lbu	a0,0(a0)
    8000029a:	0005c783          	lbu	a5,0(a1)
    8000029e:	9d1d                	subw	a0,a0,a5
}
    800002a0:	6422                	ld	s0,8(sp)
    800002a2:	0141                	addi	sp,sp,16
    800002a4:	8082                	ret
    return 0;
    800002a6:	4501                	li	a0,0
    800002a8:	bfe5                	j	800002a0 <strncmp+0x32>

00000000800002aa <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002aa:	1141                	addi	sp,sp,-16
    800002ac:	e422                	sd	s0,8(sp)
    800002ae:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002b0:	872a                	mv	a4,a0
    800002b2:	8832                	mv	a6,a2
    800002b4:	367d                	addiw	a2,a2,-1
    800002b6:	01005963          	blez	a6,800002c8 <strncpy+0x1e>
    800002ba:	0705                	addi	a4,a4,1
    800002bc:	0005c783          	lbu	a5,0(a1)
    800002c0:	fef70fa3          	sb	a5,-1(a4)
    800002c4:	0585                	addi	a1,a1,1
    800002c6:	f7f5                	bnez	a5,800002b2 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002c8:	86ba                	mv	a3,a4
    800002ca:	00c05c63          	blez	a2,800002e2 <strncpy+0x38>
    *s++ = 0;
    800002ce:	0685                	addi	a3,a3,1
    800002d0:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002d4:	40d707bb          	subw	a5,a4,a3
    800002d8:	37fd                	addiw	a5,a5,-1
    800002da:	010787bb          	addw	a5,a5,a6
    800002de:	fef048e3          	bgtz	a5,800002ce <strncpy+0x24>
  return os;
}
    800002e2:	6422                	ld	s0,8(sp)
    800002e4:	0141                	addi	sp,sp,16
    800002e6:	8082                	ret

00000000800002e8 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002e8:	1141                	addi	sp,sp,-16
    800002ea:	e422                	sd	s0,8(sp)
    800002ec:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002ee:	02c05363          	blez	a2,80000314 <safestrcpy+0x2c>
    800002f2:	fff6069b          	addiw	a3,a2,-1
    800002f6:	1682                	slli	a3,a3,0x20
    800002f8:	9281                	srli	a3,a3,0x20
    800002fa:	96ae                	add	a3,a3,a1
    800002fc:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002fe:	00d58963          	beq	a1,a3,80000310 <safestrcpy+0x28>
    80000302:	0585                	addi	a1,a1,1
    80000304:	0785                	addi	a5,a5,1
    80000306:	fff5c703          	lbu	a4,-1(a1)
    8000030a:	fee78fa3          	sb	a4,-1(a5)
    8000030e:	fb65                	bnez	a4,800002fe <safestrcpy+0x16>
    ;
  *s = 0;
    80000310:	00078023          	sb	zero,0(a5)
  return os;
}
    80000314:	6422                	ld	s0,8(sp)
    80000316:	0141                	addi	sp,sp,16
    80000318:	8082                	ret

000000008000031a <strlen>:

int
strlen(const char *s)
{
    8000031a:	1141                	addi	sp,sp,-16
    8000031c:	e422                	sd	s0,8(sp)
    8000031e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000320:	00054783          	lbu	a5,0(a0)
    80000324:	cf91                	beqz	a5,80000340 <strlen+0x26>
    80000326:	0505                	addi	a0,a0,1
    80000328:	87aa                	mv	a5,a0
    8000032a:	4685                	li	a3,1
    8000032c:	9e89                	subw	a3,a3,a0
    8000032e:	00f6853b          	addw	a0,a3,a5
    80000332:	0785                	addi	a5,a5,1
    80000334:	fff7c703          	lbu	a4,-1(a5)
    80000338:	fb7d                	bnez	a4,8000032e <strlen+0x14>
    ;
  return n;
}
    8000033a:	6422                	ld	s0,8(sp)
    8000033c:	0141                	addi	sp,sp,16
    8000033e:	8082                	ret
  for(n = 0; s[n]; n++)
    80000340:	4501                	li	a0,0
    80000342:	bfe5                	j	8000033a <strlen+0x20>

0000000080000344 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000344:	1141                	addi	sp,sp,-16
    80000346:	e406                	sd	ra,8(sp)
    80000348:	e022                	sd	s0,0(sp)
    8000034a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000034c:	00001097          	auipc	ra,0x1
    80000350:	b00080e7          	jalr	-1280(ra) # 80000e4c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000354:	00008717          	auipc	a4,0x8
    80000358:	71c70713          	addi	a4,a4,1820 # 80008a70 <started>
  if(cpuid() == 0){
    8000035c:	c139                	beqz	a0,800003a2 <main+0x5e>
    while(started == 0)
    8000035e:	431c                	lw	a5,0(a4)
    80000360:	2781                	sext.w	a5,a5
    80000362:	dff5                	beqz	a5,8000035e <main+0x1a>
      ;
    __sync_synchronize();
    80000364:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000368:	00001097          	auipc	ra,0x1
    8000036c:	ae4080e7          	jalr	-1308(ra) # 80000e4c <cpuid>
    80000370:	85aa                	mv	a1,a0
    80000372:	00008517          	auipc	a0,0x8
    80000376:	cc650513          	addi	a0,a0,-826 # 80008038 <etext+0x38>
    8000037a:	00006097          	auipc	ra,0x6
    8000037e:	97c080e7          	jalr	-1668(ra) # 80005cf6 <printf>
    kvminithart();    // turn on paging
    80000382:	00000097          	auipc	ra,0x0
    80000386:	0d8080e7          	jalr	216(ra) # 8000045a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000038a:	00001097          	auipc	ra,0x1
    8000038e:	7c2080e7          	jalr	1986(ra) # 80001b4c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000392:	00005097          	auipc	ra,0x5
    80000396:	e1e080e7          	jalr	-482(ra) # 800051b0 <plicinithart>
  }

  scheduler();        
    8000039a:	00001097          	auipc	ra,0x1
    8000039e:	fdc080e7          	jalr	-36(ra) # 80001376 <scheduler>
    consoleinit();
    800003a2:	00006097          	auipc	ra,0x6
    800003a6:	81a080e7          	jalr	-2022(ra) # 80005bbc <consoleinit>
    printfinit();
    800003aa:	00006097          	auipc	ra,0x6
    800003ae:	b2c080e7          	jalr	-1236(ra) # 80005ed6 <printfinit>
    printf("\n");
    800003b2:	00008517          	auipc	a0,0x8
    800003b6:	c9650513          	addi	a0,a0,-874 # 80008048 <etext+0x48>
    800003ba:	00006097          	auipc	ra,0x6
    800003be:	93c080e7          	jalr	-1732(ra) # 80005cf6 <printf>
    printf("xv6 kernel is booting\n");
    800003c2:	00008517          	auipc	a0,0x8
    800003c6:	c5e50513          	addi	a0,a0,-930 # 80008020 <etext+0x20>
    800003ca:	00006097          	auipc	ra,0x6
    800003ce:	92c080e7          	jalr	-1748(ra) # 80005cf6 <printf>
    printf("\n");
    800003d2:	00008517          	auipc	a0,0x8
    800003d6:	c7650513          	addi	a0,a0,-906 # 80008048 <etext+0x48>
    800003da:	00006097          	auipc	ra,0x6
    800003de:	91c080e7          	jalr	-1764(ra) # 80005cf6 <printf>
    kinit();         // physical page allocator
    800003e2:	00000097          	auipc	ra,0x0
    800003e6:	cfc080e7          	jalr	-772(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003ea:	00000097          	auipc	ra,0x0
    800003ee:	326080e7          	jalr	806(ra) # 80000710 <kvminit>
    kvminithart();   // turn on paging
    800003f2:	00000097          	auipc	ra,0x0
    800003f6:	068080e7          	jalr	104(ra) # 8000045a <kvminithart>
    procinit();      // process table
    800003fa:	00001097          	auipc	ra,0x1
    800003fe:	99e080e7          	jalr	-1634(ra) # 80000d98 <procinit>
    trapinit();      // trap vectors
    80000402:	00001097          	auipc	ra,0x1
    80000406:	722080e7          	jalr	1826(ra) # 80001b24 <trapinit>
    trapinithart();  // install kernel trap vector
    8000040a:	00001097          	auipc	ra,0x1
    8000040e:	742080e7          	jalr	1858(ra) # 80001b4c <trapinithart>
    plicinit();      // set up interrupt controller
    80000412:	00005097          	auipc	ra,0x5
    80000416:	d88080e7          	jalr	-632(ra) # 8000519a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000041a:	00005097          	auipc	ra,0x5
    8000041e:	d96080e7          	jalr	-618(ra) # 800051b0 <plicinithart>
    binit();         // buffer cache
    80000422:	00002097          	auipc	ra,0x2
    80000426:	f2e080e7          	jalr	-210(ra) # 80002350 <binit>
    iinit();         // inode table
    8000042a:	00002097          	auipc	ra,0x2
    8000042e:	5ce080e7          	jalr	1486(ra) # 800029f8 <iinit>
    fileinit();      // file table
    80000432:	00003097          	auipc	ra,0x3
    80000436:	574080e7          	jalr	1396(ra) # 800039a6 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000043a:	00005097          	auipc	ra,0x5
    8000043e:	e7e080e7          	jalr	-386(ra) # 800052b8 <virtio_disk_init>
    userinit();      // first user process
    80000442:	00001097          	auipc	ra,0x1
    80000446:	d0e080e7          	jalr	-754(ra) # 80001150 <userinit>
    __sync_synchronize();
    8000044a:	0ff0000f          	fence
    started = 1;
    8000044e:	4785                	li	a5,1
    80000450:	00008717          	auipc	a4,0x8
    80000454:	62f72023          	sw	a5,1568(a4) # 80008a70 <started>
    80000458:	b789                	j	8000039a <main+0x56>

000000008000045a <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000045a:	1141                	addi	sp,sp,-16
    8000045c:	e422                	sd	s0,8(sp)
    8000045e:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000460:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000464:	00008797          	auipc	a5,0x8
    80000468:	6147b783          	ld	a5,1556(a5) # 80008a78 <kernel_pagetable>
    8000046c:	83b1                	srli	a5,a5,0xc
    8000046e:	577d                	li	a4,-1
    80000470:	177e                	slli	a4,a4,0x3f
    80000472:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000474:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000478:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000047c:	6422                	ld	s0,8(sp)
    8000047e:	0141                	addi	sp,sp,16
    80000480:	8082                	ret

0000000080000482 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000482:	7139                	addi	sp,sp,-64
    80000484:	fc06                	sd	ra,56(sp)
    80000486:	f822                	sd	s0,48(sp)
    80000488:	f426                	sd	s1,40(sp)
    8000048a:	f04a                	sd	s2,32(sp)
    8000048c:	ec4e                	sd	s3,24(sp)
    8000048e:	e852                	sd	s4,16(sp)
    80000490:	e456                	sd	s5,8(sp)
    80000492:	e05a                	sd	s6,0(sp)
    80000494:	0080                	addi	s0,sp,64
    80000496:	84aa                	mv	s1,a0
    80000498:	89ae                	mv	s3,a1
    8000049a:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000049c:	57fd                	li	a5,-1
    8000049e:	83e9                	srli	a5,a5,0x1a
    800004a0:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004a2:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004a4:	04b7f263          	bgeu	a5,a1,800004e8 <walk+0x66>
    panic("walk");
    800004a8:	00008517          	auipc	a0,0x8
    800004ac:	ba850513          	addi	a0,a0,-1112 # 80008050 <etext+0x50>
    800004b0:	00005097          	auipc	ra,0x5
    800004b4:	7fc080e7          	jalr	2044(ra) # 80005cac <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004b8:	060a8663          	beqz	s5,80000524 <walk+0xa2>
    800004bc:	00000097          	auipc	ra,0x0
    800004c0:	c5e080e7          	jalr	-930(ra) # 8000011a <kalloc>
    800004c4:	84aa                	mv	s1,a0
    800004c6:	c529                	beqz	a0,80000510 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004c8:	6605                	lui	a2,0x1
    800004ca:	4581                	li	a1,0
    800004cc:	00000097          	auipc	ra,0x0
    800004d0:	cd2080e7          	jalr	-814(ra) # 8000019e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004d4:	00c4d793          	srli	a5,s1,0xc
    800004d8:	07aa                	slli	a5,a5,0xa
    800004da:	0017e793          	ori	a5,a5,1
    800004de:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004e2:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdcee7>
    800004e4:	036a0063          	beq	s4,s6,80000504 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004e8:	0149d933          	srl	s2,s3,s4
    800004ec:	1ff97913          	andi	s2,s2,511
    800004f0:	090e                	slli	s2,s2,0x3
    800004f2:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004f4:	00093483          	ld	s1,0(s2)
    800004f8:	0014f793          	andi	a5,s1,1
    800004fc:	dfd5                	beqz	a5,800004b8 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004fe:	80a9                	srli	s1,s1,0xa
    80000500:	04b2                	slli	s1,s1,0xc
    80000502:	b7c5                	j	800004e2 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000504:	00c9d513          	srli	a0,s3,0xc
    80000508:	1ff57513          	andi	a0,a0,511
    8000050c:	050e                	slli	a0,a0,0x3
    8000050e:	9526                	add	a0,a0,s1
}
    80000510:	70e2                	ld	ra,56(sp)
    80000512:	7442                	ld	s0,48(sp)
    80000514:	74a2                	ld	s1,40(sp)
    80000516:	7902                	ld	s2,32(sp)
    80000518:	69e2                	ld	s3,24(sp)
    8000051a:	6a42                	ld	s4,16(sp)
    8000051c:	6aa2                	ld	s5,8(sp)
    8000051e:	6b02                	ld	s6,0(sp)
    80000520:	6121                	addi	sp,sp,64
    80000522:	8082                	ret
        return 0;
    80000524:	4501                	li	a0,0
    80000526:	b7ed                	j	80000510 <walk+0x8e>

0000000080000528 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000528:	57fd                	li	a5,-1
    8000052a:	83e9                	srli	a5,a5,0x1a
    8000052c:	00b7f463          	bgeu	a5,a1,80000534 <walkaddr+0xc>
    return 0;
    80000530:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000532:	8082                	ret
{
    80000534:	1141                	addi	sp,sp,-16
    80000536:	e406                	sd	ra,8(sp)
    80000538:	e022                	sd	s0,0(sp)
    8000053a:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000053c:	4601                	li	a2,0
    8000053e:	00000097          	auipc	ra,0x0
    80000542:	f44080e7          	jalr	-188(ra) # 80000482 <walk>
  if(pte == 0)
    80000546:	c105                	beqz	a0,80000566 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000548:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000054a:	0117f693          	andi	a3,a5,17
    8000054e:	4745                	li	a4,17
    return 0;
    80000550:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000552:	00e68663          	beq	a3,a4,8000055e <walkaddr+0x36>
}
    80000556:	60a2                	ld	ra,8(sp)
    80000558:	6402                	ld	s0,0(sp)
    8000055a:	0141                	addi	sp,sp,16
    8000055c:	8082                	ret
  pa = PTE2PA(*pte);
    8000055e:	83a9                	srli	a5,a5,0xa
    80000560:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000564:	bfcd                	j	80000556 <walkaddr+0x2e>
    return 0;
    80000566:	4501                	li	a0,0
    80000568:	b7fd                	j	80000556 <walkaddr+0x2e>

000000008000056a <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000056a:	715d                	addi	sp,sp,-80
    8000056c:	e486                	sd	ra,72(sp)
    8000056e:	e0a2                	sd	s0,64(sp)
    80000570:	fc26                	sd	s1,56(sp)
    80000572:	f84a                	sd	s2,48(sp)
    80000574:	f44e                	sd	s3,40(sp)
    80000576:	f052                	sd	s4,32(sp)
    80000578:	ec56                	sd	s5,24(sp)
    8000057a:	e85a                	sd	s6,16(sp)
    8000057c:	e45e                	sd	s7,8(sp)
    8000057e:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000580:	c639                	beqz	a2,800005ce <mappages+0x64>
    80000582:	8aaa                	mv	s5,a0
    80000584:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000586:	777d                	lui	a4,0xfffff
    80000588:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000058c:	fff58993          	addi	s3,a1,-1
    80000590:	99b2                	add	s3,s3,a2
    80000592:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000596:	893e                	mv	s2,a5
    80000598:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000059c:	6b85                	lui	s7,0x1
    8000059e:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a2:	4605                	li	a2,1
    800005a4:	85ca                	mv	a1,s2
    800005a6:	8556                	mv	a0,s5
    800005a8:	00000097          	auipc	ra,0x0
    800005ac:	eda080e7          	jalr	-294(ra) # 80000482 <walk>
    800005b0:	cd1d                	beqz	a0,800005ee <mappages+0x84>
    if(*pte & PTE_V)
    800005b2:	611c                	ld	a5,0(a0)
    800005b4:	8b85                	andi	a5,a5,1
    800005b6:	e785                	bnez	a5,800005de <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005b8:	80b1                	srli	s1,s1,0xc
    800005ba:	04aa                	slli	s1,s1,0xa
    800005bc:	0164e4b3          	or	s1,s1,s6
    800005c0:	0014e493          	ori	s1,s1,1
    800005c4:	e104                	sd	s1,0(a0)
    if(a == last)
    800005c6:	05390063          	beq	s2,s3,80000606 <mappages+0x9c>
    a += PGSIZE;
    800005ca:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005cc:	bfc9                	j	8000059e <mappages+0x34>
    panic("mappages: size");
    800005ce:	00008517          	auipc	a0,0x8
    800005d2:	a8a50513          	addi	a0,a0,-1398 # 80008058 <etext+0x58>
    800005d6:	00005097          	auipc	ra,0x5
    800005da:	6d6080e7          	jalr	1750(ra) # 80005cac <panic>
      panic("mappages: remap");
    800005de:	00008517          	auipc	a0,0x8
    800005e2:	a8a50513          	addi	a0,a0,-1398 # 80008068 <etext+0x68>
    800005e6:	00005097          	auipc	ra,0x5
    800005ea:	6c6080e7          	jalr	1734(ra) # 80005cac <panic>
      return -1;
    800005ee:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005f0:	60a6                	ld	ra,72(sp)
    800005f2:	6406                	ld	s0,64(sp)
    800005f4:	74e2                	ld	s1,56(sp)
    800005f6:	7942                	ld	s2,48(sp)
    800005f8:	79a2                	ld	s3,40(sp)
    800005fa:	7a02                	ld	s4,32(sp)
    800005fc:	6ae2                	ld	s5,24(sp)
    800005fe:	6b42                	ld	s6,16(sp)
    80000600:	6ba2                	ld	s7,8(sp)
    80000602:	6161                	addi	sp,sp,80
    80000604:	8082                	ret
  return 0;
    80000606:	4501                	li	a0,0
    80000608:	b7e5                	j	800005f0 <mappages+0x86>

000000008000060a <kvmmap>:
{
    8000060a:	1141                	addi	sp,sp,-16
    8000060c:	e406                	sd	ra,8(sp)
    8000060e:	e022                	sd	s0,0(sp)
    80000610:	0800                	addi	s0,sp,16
    80000612:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000614:	86b2                	mv	a3,a2
    80000616:	863e                	mv	a2,a5
    80000618:	00000097          	auipc	ra,0x0
    8000061c:	f52080e7          	jalr	-174(ra) # 8000056a <mappages>
    80000620:	e509                	bnez	a0,8000062a <kvmmap+0x20>
}
    80000622:	60a2                	ld	ra,8(sp)
    80000624:	6402                	ld	s0,0(sp)
    80000626:	0141                	addi	sp,sp,16
    80000628:	8082                	ret
    panic("kvmmap");
    8000062a:	00008517          	auipc	a0,0x8
    8000062e:	a4e50513          	addi	a0,a0,-1458 # 80008078 <etext+0x78>
    80000632:	00005097          	auipc	ra,0x5
    80000636:	67a080e7          	jalr	1658(ra) # 80005cac <panic>

000000008000063a <kvmmake>:
{
    8000063a:	1101                	addi	sp,sp,-32
    8000063c:	ec06                	sd	ra,24(sp)
    8000063e:	e822                	sd	s0,16(sp)
    80000640:	e426                	sd	s1,8(sp)
    80000642:	e04a                	sd	s2,0(sp)
    80000644:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000646:	00000097          	auipc	ra,0x0
    8000064a:	ad4080e7          	jalr	-1324(ra) # 8000011a <kalloc>
    8000064e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000650:	6605                	lui	a2,0x1
    80000652:	4581                	li	a1,0
    80000654:	00000097          	auipc	ra,0x0
    80000658:	b4a080e7          	jalr	-1206(ra) # 8000019e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000065c:	4719                	li	a4,6
    8000065e:	6685                	lui	a3,0x1
    80000660:	10000637          	lui	a2,0x10000
    80000664:	100005b7          	lui	a1,0x10000
    80000668:	8526                	mv	a0,s1
    8000066a:	00000097          	auipc	ra,0x0
    8000066e:	fa0080e7          	jalr	-96(ra) # 8000060a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000672:	4719                	li	a4,6
    80000674:	6685                	lui	a3,0x1
    80000676:	10001637          	lui	a2,0x10001
    8000067a:	100015b7          	lui	a1,0x10001
    8000067e:	8526                	mv	a0,s1
    80000680:	00000097          	auipc	ra,0x0
    80000684:	f8a080e7          	jalr	-118(ra) # 8000060a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000688:	4719                	li	a4,6
    8000068a:	004006b7          	lui	a3,0x400
    8000068e:	0c000637          	lui	a2,0xc000
    80000692:	0c0005b7          	lui	a1,0xc000
    80000696:	8526                	mv	a0,s1
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	f72080e7          	jalr	-142(ra) # 8000060a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006a0:	00008917          	auipc	s2,0x8
    800006a4:	96090913          	addi	s2,s2,-1696 # 80008000 <etext>
    800006a8:	4729                	li	a4,10
    800006aa:	80008697          	auipc	a3,0x80008
    800006ae:	95668693          	addi	a3,a3,-1706 # 8000 <_entry-0x7fff8000>
    800006b2:	4605                	li	a2,1
    800006b4:	067e                	slli	a2,a2,0x1f
    800006b6:	85b2                	mv	a1,a2
    800006b8:	8526                	mv	a0,s1
    800006ba:	00000097          	auipc	ra,0x0
    800006be:	f50080e7          	jalr	-176(ra) # 8000060a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006c2:	4719                	li	a4,6
    800006c4:	46c5                	li	a3,17
    800006c6:	06ee                	slli	a3,a3,0x1b
    800006c8:	412686b3          	sub	a3,a3,s2
    800006cc:	864a                	mv	a2,s2
    800006ce:	85ca                	mv	a1,s2
    800006d0:	8526                	mv	a0,s1
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	f38080e7          	jalr	-200(ra) # 8000060a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006da:	4729                	li	a4,10
    800006dc:	6685                	lui	a3,0x1
    800006de:	00007617          	auipc	a2,0x7
    800006e2:	92260613          	addi	a2,a2,-1758 # 80007000 <_trampoline>
    800006e6:	040005b7          	lui	a1,0x4000
    800006ea:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006ec:	05b2                	slli	a1,a1,0xc
    800006ee:	8526                	mv	a0,s1
    800006f0:	00000097          	auipc	ra,0x0
    800006f4:	f1a080e7          	jalr	-230(ra) # 8000060a <kvmmap>
  proc_mapstacks(kpgtbl);
    800006f8:	8526                	mv	a0,s1
    800006fa:	00000097          	auipc	ra,0x0
    800006fe:	608080e7          	jalr	1544(ra) # 80000d02 <proc_mapstacks>
}
    80000702:	8526                	mv	a0,s1
    80000704:	60e2                	ld	ra,24(sp)
    80000706:	6442                	ld	s0,16(sp)
    80000708:	64a2                	ld	s1,8(sp)
    8000070a:	6902                	ld	s2,0(sp)
    8000070c:	6105                	addi	sp,sp,32
    8000070e:	8082                	ret

0000000080000710 <kvminit>:
{
    80000710:	1141                	addi	sp,sp,-16
    80000712:	e406                	sd	ra,8(sp)
    80000714:	e022                	sd	s0,0(sp)
    80000716:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000718:	00000097          	auipc	ra,0x0
    8000071c:	f22080e7          	jalr	-222(ra) # 8000063a <kvmmake>
    80000720:	00008797          	auipc	a5,0x8
    80000724:	34a7bc23          	sd	a0,856(a5) # 80008a78 <kernel_pagetable>
}
    80000728:	60a2                	ld	ra,8(sp)
    8000072a:	6402                	ld	s0,0(sp)
    8000072c:	0141                	addi	sp,sp,16
    8000072e:	8082                	ret

0000000080000730 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000730:	715d                	addi	sp,sp,-80
    80000732:	e486                	sd	ra,72(sp)
    80000734:	e0a2                	sd	s0,64(sp)
    80000736:	fc26                	sd	s1,56(sp)
    80000738:	f84a                	sd	s2,48(sp)
    8000073a:	f44e                	sd	s3,40(sp)
    8000073c:	f052                	sd	s4,32(sp)
    8000073e:	ec56                	sd	s5,24(sp)
    80000740:	e85a                	sd	s6,16(sp)
    80000742:	e45e                	sd	s7,8(sp)
    80000744:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000746:	03459793          	slli	a5,a1,0x34
    8000074a:	e795                	bnez	a5,80000776 <uvmunmap+0x46>
    8000074c:	8a2a                	mv	s4,a0
    8000074e:	892e                	mv	s2,a1
    80000750:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000752:	0632                	slli	a2,a2,0xc
    80000754:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000758:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000075a:	6b05                	lui	s6,0x1
    8000075c:	0735e263          	bltu	a1,s3,800007c0 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000760:	60a6                	ld	ra,72(sp)
    80000762:	6406                	ld	s0,64(sp)
    80000764:	74e2                	ld	s1,56(sp)
    80000766:	7942                	ld	s2,48(sp)
    80000768:	79a2                	ld	s3,40(sp)
    8000076a:	7a02                	ld	s4,32(sp)
    8000076c:	6ae2                	ld	s5,24(sp)
    8000076e:	6b42                	ld	s6,16(sp)
    80000770:	6ba2                	ld	s7,8(sp)
    80000772:	6161                	addi	sp,sp,80
    80000774:	8082                	ret
    panic("uvmunmap: not aligned");
    80000776:	00008517          	auipc	a0,0x8
    8000077a:	90a50513          	addi	a0,a0,-1782 # 80008080 <etext+0x80>
    8000077e:	00005097          	auipc	ra,0x5
    80000782:	52e080e7          	jalr	1326(ra) # 80005cac <panic>
      panic("uvmunmap: walk");
    80000786:	00008517          	auipc	a0,0x8
    8000078a:	91250513          	addi	a0,a0,-1774 # 80008098 <etext+0x98>
    8000078e:	00005097          	auipc	ra,0x5
    80000792:	51e080e7          	jalr	1310(ra) # 80005cac <panic>
      panic("uvmunmap: not mapped");
    80000796:	00008517          	auipc	a0,0x8
    8000079a:	91250513          	addi	a0,a0,-1774 # 800080a8 <etext+0xa8>
    8000079e:	00005097          	auipc	ra,0x5
    800007a2:	50e080e7          	jalr	1294(ra) # 80005cac <panic>
      panic("uvmunmap: not a leaf");
    800007a6:	00008517          	auipc	a0,0x8
    800007aa:	91a50513          	addi	a0,a0,-1766 # 800080c0 <etext+0xc0>
    800007ae:	00005097          	auipc	ra,0x5
    800007b2:	4fe080e7          	jalr	1278(ra) # 80005cac <panic>
    *pte = 0;
    800007b6:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007ba:	995a                	add	s2,s2,s6
    800007bc:	fb3972e3          	bgeu	s2,s3,80000760 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007c0:	4601                	li	a2,0
    800007c2:	85ca                	mv	a1,s2
    800007c4:	8552                	mv	a0,s4
    800007c6:	00000097          	auipc	ra,0x0
    800007ca:	cbc080e7          	jalr	-836(ra) # 80000482 <walk>
    800007ce:	84aa                	mv	s1,a0
    800007d0:	d95d                	beqz	a0,80000786 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007d2:	6108                	ld	a0,0(a0)
    800007d4:	00157793          	andi	a5,a0,1
    800007d8:	dfdd                	beqz	a5,80000796 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007da:	3ff57793          	andi	a5,a0,1023
    800007de:	fd7784e3          	beq	a5,s7,800007a6 <uvmunmap+0x76>
    if(do_free){
    800007e2:	fc0a8ae3          	beqz	s5,800007b6 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007e6:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007e8:	0532                	slli	a0,a0,0xc
    800007ea:	00000097          	auipc	ra,0x0
    800007ee:	832080e7          	jalr	-1998(ra) # 8000001c <kfree>
    800007f2:	b7d1                	j	800007b6 <uvmunmap+0x86>

00000000800007f4 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007f4:	1101                	addi	sp,sp,-32
    800007f6:	ec06                	sd	ra,24(sp)
    800007f8:	e822                	sd	s0,16(sp)
    800007fa:	e426                	sd	s1,8(sp)
    800007fc:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007fe:	00000097          	auipc	ra,0x0
    80000802:	91c080e7          	jalr	-1764(ra) # 8000011a <kalloc>
    80000806:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000808:	c519                	beqz	a0,80000816 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000080a:	6605                	lui	a2,0x1
    8000080c:	4581                	li	a1,0
    8000080e:	00000097          	auipc	ra,0x0
    80000812:	990080e7          	jalr	-1648(ra) # 8000019e <memset>
  return pagetable;
}
    80000816:	8526                	mv	a0,s1
    80000818:	60e2                	ld	ra,24(sp)
    8000081a:	6442                	ld	s0,16(sp)
    8000081c:	64a2                	ld	s1,8(sp)
    8000081e:	6105                	addi	sp,sp,32
    80000820:	8082                	ret

0000000080000822 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000822:	7179                	addi	sp,sp,-48
    80000824:	f406                	sd	ra,40(sp)
    80000826:	f022                	sd	s0,32(sp)
    80000828:	ec26                	sd	s1,24(sp)
    8000082a:	e84a                	sd	s2,16(sp)
    8000082c:	e44e                	sd	s3,8(sp)
    8000082e:	e052                	sd	s4,0(sp)
    80000830:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000832:	6785                	lui	a5,0x1
    80000834:	04f67863          	bgeu	a2,a5,80000884 <uvmfirst+0x62>
    80000838:	8a2a                	mv	s4,a0
    8000083a:	89ae                	mv	s3,a1
    8000083c:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000083e:	00000097          	auipc	ra,0x0
    80000842:	8dc080e7          	jalr	-1828(ra) # 8000011a <kalloc>
    80000846:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000848:	6605                	lui	a2,0x1
    8000084a:	4581                	li	a1,0
    8000084c:	00000097          	auipc	ra,0x0
    80000850:	952080e7          	jalr	-1710(ra) # 8000019e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000854:	4779                	li	a4,30
    80000856:	86ca                	mv	a3,s2
    80000858:	6605                	lui	a2,0x1
    8000085a:	4581                	li	a1,0
    8000085c:	8552                	mv	a0,s4
    8000085e:	00000097          	auipc	ra,0x0
    80000862:	d0c080e7          	jalr	-756(ra) # 8000056a <mappages>
  memmove(mem, src, sz);
    80000866:	8626                	mv	a2,s1
    80000868:	85ce                	mv	a1,s3
    8000086a:	854a                	mv	a0,s2
    8000086c:	00000097          	auipc	ra,0x0
    80000870:	98e080e7          	jalr	-1650(ra) # 800001fa <memmove>
}
    80000874:	70a2                	ld	ra,40(sp)
    80000876:	7402                	ld	s0,32(sp)
    80000878:	64e2                	ld	s1,24(sp)
    8000087a:	6942                	ld	s2,16(sp)
    8000087c:	69a2                	ld	s3,8(sp)
    8000087e:	6a02                	ld	s4,0(sp)
    80000880:	6145                	addi	sp,sp,48
    80000882:	8082                	ret
    panic("uvmfirst: more than a page");
    80000884:	00008517          	auipc	a0,0x8
    80000888:	85450513          	addi	a0,a0,-1964 # 800080d8 <etext+0xd8>
    8000088c:	00005097          	auipc	ra,0x5
    80000890:	420080e7          	jalr	1056(ra) # 80005cac <panic>

0000000080000894 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000894:	1101                	addi	sp,sp,-32
    80000896:	ec06                	sd	ra,24(sp)
    80000898:	e822                	sd	s0,16(sp)
    8000089a:	e426                	sd	s1,8(sp)
    8000089c:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000089e:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008a0:	00b67d63          	bgeu	a2,a1,800008ba <uvmdealloc+0x26>
    800008a4:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008a6:	6785                	lui	a5,0x1
    800008a8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008aa:	00f60733          	add	a4,a2,a5
    800008ae:	76fd                	lui	a3,0xfffff
    800008b0:	8f75                	and	a4,a4,a3
    800008b2:	97ae                	add	a5,a5,a1
    800008b4:	8ff5                	and	a5,a5,a3
    800008b6:	00f76863          	bltu	a4,a5,800008c6 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008ba:	8526                	mv	a0,s1
    800008bc:	60e2                	ld	ra,24(sp)
    800008be:	6442                	ld	s0,16(sp)
    800008c0:	64a2                	ld	s1,8(sp)
    800008c2:	6105                	addi	sp,sp,32
    800008c4:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008c6:	8f99                	sub	a5,a5,a4
    800008c8:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008ca:	4685                	li	a3,1
    800008cc:	0007861b          	sext.w	a2,a5
    800008d0:	85ba                	mv	a1,a4
    800008d2:	00000097          	auipc	ra,0x0
    800008d6:	e5e080e7          	jalr	-418(ra) # 80000730 <uvmunmap>
    800008da:	b7c5                	j	800008ba <uvmdealloc+0x26>

00000000800008dc <uvmalloc>:
  if(newsz < oldsz)
    800008dc:	0ab66563          	bltu	a2,a1,80000986 <uvmalloc+0xaa>
{
    800008e0:	7139                	addi	sp,sp,-64
    800008e2:	fc06                	sd	ra,56(sp)
    800008e4:	f822                	sd	s0,48(sp)
    800008e6:	f426                	sd	s1,40(sp)
    800008e8:	f04a                	sd	s2,32(sp)
    800008ea:	ec4e                	sd	s3,24(sp)
    800008ec:	e852                	sd	s4,16(sp)
    800008ee:	e456                	sd	s5,8(sp)
    800008f0:	e05a                	sd	s6,0(sp)
    800008f2:	0080                	addi	s0,sp,64
    800008f4:	8aaa                	mv	s5,a0
    800008f6:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008f8:	6785                	lui	a5,0x1
    800008fa:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008fc:	95be                	add	a1,a1,a5
    800008fe:	77fd                	lui	a5,0xfffff
    80000900:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000904:	08c9f363          	bgeu	s3,a2,8000098a <uvmalloc+0xae>
    80000908:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000090a:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    8000090e:	00000097          	auipc	ra,0x0
    80000912:	80c080e7          	jalr	-2036(ra) # 8000011a <kalloc>
    80000916:	84aa                	mv	s1,a0
    if(mem == 0){
    80000918:	c51d                	beqz	a0,80000946 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    8000091a:	6605                	lui	a2,0x1
    8000091c:	4581                	li	a1,0
    8000091e:	00000097          	auipc	ra,0x0
    80000922:	880080e7          	jalr	-1920(ra) # 8000019e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000926:	875a                	mv	a4,s6
    80000928:	86a6                	mv	a3,s1
    8000092a:	6605                	lui	a2,0x1
    8000092c:	85ca                	mv	a1,s2
    8000092e:	8556                	mv	a0,s5
    80000930:	00000097          	auipc	ra,0x0
    80000934:	c3a080e7          	jalr	-966(ra) # 8000056a <mappages>
    80000938:	e90d                	bnez	a0,8000096a <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000093a:	6785                	lui	a5,0x1
    8000093c:	993e                	add	s2,s2,a5
    8000093e:	fd4968e3          	bltu	s2,s4,8000090e <uvmalloc+0x32>
  return newsz;
    80000942:	8552                	mv	a0,s4
    80000944:	a809                	j	80000956 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000946:	864e                	mv	a2,s3
    80000948:	85ca                	mv	a1,s2
    8000094a:	8556                	mv	a0,s5
    8000094c:	00000097          	auipc	ra,0x0
    80000950:	f48080e7          	jalr	-184(ra) # 80000894 <uvmdealloc>
      return 0;
    80000954:	4501                	li	a0,0
}
    80000956:	70e2                	ld	ra,56(sp)
    80000958:	7442                	ld	s0,48(sp)
    8000095a:	74a2                	ld	s1,40(sp)
    8000095c:	7902                	ld	s2,32(sp)
    8000095e:	69e2                	ld	s3,24(sp)
    80000960:	6a42                	ld	s4,16(sp)
    80000962:	6aa2                	ld	s5,8(sp)
    80000964:	6b02                	ld	s6,0(sp)
    80000966:	6121                	addi	sp,sp,64
    80000968:	8082                	ret
      kfree(mem);
    8000096a:	8526                	mv	a0,s1
    8000096c:	fffff097          	auipc	ra,0xfffff
    80000970:	6b0080e7          	jalr	1712(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000974:	864e                	mv	a2,s3
    80000976:	85ca                	mv	a1,s2
    80000978:	8556                	mv	a0,s5
    8000097a:	00000097          	auipc	ra,0x0
    8000097e:	f1a080e7          	jalr	-230(ra) # 80000894 <uvmdealloc>
      return 0;
    80000982:	4501                	li	a0,0
    80000984:	bfc9                	j	80000956 <uvmalloc+0x7a>
    return oldsz;
    80000986:	852e                	mv	a0,a1
}
    80000988:	8082                	ret
  return newsz;
    8000098a:	8532                	mv	a0,a2
    8000098c:	b7e9                	j	80000956 <uvmalloc+0x7a>

000000008000098e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000098e:	7179                	addi	sp,sp,-48
    80000990:	f406                	sd	ra,40(sp)
    80000992:	f022                	sd	s0,32(sp)
    80000994:	ec26                	sd	s1,24(sp)
    80000996:	e84a                	sd	s2,16(sp)
    80000998:	e44e                	sd	s3,8(sp)
    8000099a:	e052                	sd	s4,0(sp)
    8000099c:	1800                	addi	s0,sp,48
    8000099e:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009a0:	84aa                	mv	s1,a0
    800009a2:	6905                	lui	s2,0x1
    800009a4:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009a6:	4985                	li	s3,1
    800009a8:	a829                	j	800009c2 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009aa:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009ac:	00c79513          	slli	a0,a5,0xc
    800009b0:	00000097          	auipc	ra,0x0
    800009b4:	fde080e7          	jalr	-34(ra) # 8000098e <freewalk>
      pagetable[i] = 0;
    800009b8:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009bc:	04a1                	addi	s1,s1,8
    800009be:	03248163          	beq	s1,s2,800009e0 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009c2:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009c4:	00f7f713          	andi	a4,a5,15
    800009c8:	ff3701e3          	beq	a4,s3,800009aa <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009cc:	8b85                	andi	a5,a5,1
    800009ce:	d7fd                	beqz	a5,800009bc <freewalk+0x2e>
      panic("freewalk: leaf");
    800009d0:	00007517          	auipc	a0,0x7
    800009d4:	72850513          	addi	a0,a0,1832 # 800080f8 <etext+0xf8>
    800009d8:	00005097          	auipc	ra,0x5
    800009dc:	2d4080e7          	jalr	724(ra) # 80005cac <panic>
    }
  }
  kfree((void*)pagetable);
    800009e0:	8552                	mv	a0,s4
    800009e2:	fffff097          	auipc	ra,0xfffff
    800009e6:	63a080e7          	jalr	1594(ra) # 8000001c <kfree>
}
    800009ea:	70a2                	ld	ra,40(sp)
    800009ec:	7402                	ld	s0,32(sp)
    800009ee:	64e2                	ld	s1,24(sp)
    800009f0:	6942                	ld	s2,16(sp)
    800009f2:	69a2                	ld	s3,8(sp)
    800009f4:	6a02                	ld	s4,0(sp)
    800009f6:	6145                	addi	sp,sp,48
    800009f8:	8082                	ret

00000000800009fa <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009fa:	1101                	addi	sp,sp,-32
    800009fc:	ec06                	sd	ra,24(sp)
    800009fe:	e822                	sd	s0,16(sp)
    80000a00:	e426                	sd	s1,8(sp)
    80000a02:	1000                	addi	s0,sp,32
    80000a04:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a06:	e999                	bnez	a1,80000a1c <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a08:	8526                	mv	a0,s1
    80000a0a:	00000097          	auipc	ra,0x0
    80000a0e:	f84080e7          	jalr	-124(ra) # 8000098e <freewalk>
}
    80000a12:	60e2                	ld	ra,24(sp)
    80000a14:	6442                	ld	s0,16(sp)
    80000a16:	64a2                	ld	s1,8(sp)
    80000a18:	6105                	addi	sp,sp,32
    80000a1a:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a1c:	6785                	lui	a5,0x1
    80000a1e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a20:	95be                	add	a1,a1,a5
    80000a22:	4685                	li	a3,1
    80000a24:	00c5d613          	srli	a2,a1,0xc
    80000a28:	4581                	li	a1,0
    80000a2a:	00000097          	auipc	ra,0x0
    80000a2e:	d06080e7          	jalr	-762(ra) # 80000730 <uvmunmap>
    80000a32:	bfd9                	j	80000a08 <uvmfree+0xe>

0000000080000a34 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a34:	c679                	beqz	a2,80000b02 <uvmcopy+0xce>
{
    80000a36:	715d                	addi	sp,sp,-80
    80000a38:	e486                	sd	ra,72(sp)
    80000a3a:	e0a2                	sd	s0,64(sp)
    80000a3c:	fc26                	sd	s1,56(sp)
    80000a3e:	f84a                	sd	s2,48(sp)
    80000a40:	f44e                	sd	s3,40(sp)
    80000a42:	f052                	sd	s4,32(sp)
    80000a44:	ec56                	sd	s5,24(sp)
    80000a46:	e85a                	sd	s6,16(sp)
    80000a48:	e45e                	sd	s7,8(sp)
    80000a4a:	0880                	addi	s0,sp,80
    80000a4c:	8b2a                	mv	s6,a0
    80000a4e:	8aae                	mv	s5,a1
    80000a50:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a52:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a54:	4601                	li	a2,0
    80000a56:	85ce                	mv	a1,s3
    80000a58:	855a                	mv	a0,s6
    80000a5a:	00000097          	auipc	ra,0x0
    80000a5e:	a28080e7          	jalr	-1496(ra) # 80000482 <walk>
    80000a62:	c531                	beqz	a0,80000aae <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a64:	6118                	ld	a4,0(a0)
    80000a66:	00177793          	andi	a5,a4,1
    80000a6a:	cbb1                	beqz	a5,80000abe <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a6c:	00a75593          	srli	a1,a4,0xa
    80000a70:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a74:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a78:	fffff097          	auipc	ra,0xfffff
    80000a7c:	6a2080e7          	jalr	1698(ra) # 8000011a <kalloc>
    80000a80:	892a                	mv	s2,a0
    80000a82:	c939                	beqz	a0,80000ad8 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a84:	6605                	lui	a2,0x1
    80000a86:	85de                	mv	a1,s7
    80000a88:	fffff097          	auipc	ra,0xfffff
    80000a8c:	772080e7          	jalr	1906(ra) # 800001fa <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a90:	8726                	mv	a4,s1
    80000a92:	86ca                	mv	a3,s2
    80000a94:	6605                	lui	a2,0x1
    80000a96:	85ce                	mv	a1,s3
    80000a98:	8556                	mv	a0,s5
    80000a9a:	00000097          	auipc	ra,0x0
    80000a9e:	ad0080e7          	jalr	-1328(ra) # 8000056a <mappages>
    80000aa2:	e515                	bnez	a0,80000ace <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000aa4:	6785                	lui	a5,0x1
    80000aa6:	99be                	add	s3,s3,a5
    80000aa8:	fb49e6e3          	bltu	s3,s4,80000a54 <uvmcopy+0x20>
    80000aac:	a081                	j	80000aec <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000aae:	00007517          	auipc	a0,0x7
    80000ab2:	65a50513          	addi	a0,a0,1626 # 80008108 <etext+0x108>
    80000ab6:	00005097          	auipc	ra,0x5
    80000aba:	1f6080e7          	jalr	502(ra) # 80005cac <panic>
      panic("uvmcopy: page not present");
    80000abe:	00007517          	auipc	a0,0x7
    80000ac2:	66a50513          	addi	a0,a0,1642 # 80008128 <etext+0x128>
    80000ac6:	00005097          	auipc	ra,0x5
    80000aca:	1e6080e7          	jalr	486(ra) # 80005cac <panic>
      kfree(mem);
    80000ace:	854a                	mv	a0,s2
    80000ad0:	fffff097          	auipc	ra,0xfffff
    80000ad4:	54c080e7          	jalr	1356(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ad8:	4685                	li	a3,1
    80000ada:	00c9d613          	srli	a2,s3,0xc
    80000ade:	4581                	li	a1,0
    80000ae0:	8556                	mv	a0,s5
    80000ae2:	00000097          	auipc	ra,0x0
    80000ae6:	c4e080e7          	jalr	-946(ra) # 80000730 <uvmunmap>
  return -1;
    80000aea:	557d                	li	a0,-1
}
    80000aec:	60a6                	ld	ra,72(sp)
    80000aee:	6406                	ld	s0,64(sp)
    80000af0:	74e2                	ld	s1,56(sp)
    80000af2:	7942                	ld	s2,48(sp)
    80000af4:	79a2                	ld	s3,40(sp)
    80000af6:	7a02                	ld	s4,32(sp)
    80000af8:	6ae2                	ld	s5,24(sp)
    80000afa:	6b42                	ld	s6,16(sp)
    80000afc:	6ba2                	ld	s7,8(sp)
    80000afe:	6161                	addi	sp,sp,80
    80000b00:	8082                	ret
  return 0;
    80000b02:	4501                	li	a0,0
}
    80000b04:	8082                	ret

0000000080000b06 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b06:	1141                	addi	sp,sp,-16
    80000b08:	e406                	sd	ra,8(sp)
    80000b0a:	e022                	sd	s0,0(sp)
    80000b0c:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b0e:	4601                	li	a2,0
    80000b10:	00000097          	auipc	ra,0x0
    80000b14:	972080e7          	jalr	-1678(ra) # 80000482 <walk>
  if(pte == 0)
    80000b18:	c901                	beqz	a0,80000b28 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b1a:	611c                	ld	a5,0(a0)
    80000b1c:	9bbd                	andi	a5,a5,-17
    80000b1e:	e11c                	sd	a5,0(a0)
}
    80000b20:	60a2                	ld	ra,8(sp)
    80000b22:	6402                	ld	s0,0(sp)
    80000b24:	0141                	addi	sp,sp,16
    80000b26:	8082                	ret
    panic("uvmclear");
    80000b28:	00007517          	auipc	a0,0x7
    80000b2c:	62050513          	addi	a0,a0,1568 # 80008148 <etext+0x148>
    80000b30:	00005097          	auipc	ra,0x5
    80000b34:	17c080e7          	jalr	380(ra) # 80005cac <panic>

0000000080000b38 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b38:	c6bd                	beqz	a3,80000ba6 <copyout+0x6e>
{
    80000b3a:	715d                	addi	sp,sp,-80
    80000b3c:	e486                	sd	ra,72(sp)
    80000b3e:	e0a2                	sd	s0,64(sp)
    80000b40:	fc26                	sd	s1,56(sp)
    80000b42:	f84a                	sd	s2,48(sp)
    80000b44:	f44e                	sd	s3,40(sp)
    80000b46:	f052                	sd	s4,32(sp)
    80000b48:	ec56                	sd	s5,24(sp)
    80000b4a:	e85a                	sd	s6,16(sp)
    80000b4c:	e45e                	sd	s7,8(sp)
    80000b4e:	e062                	sd	s8,0(sp)
    80000b50:	0880                	addi	s0,sp,80
    80000b52:	8b2a                	mv	s6,a0
    80000b54:	8c2e                	mv	s8,a1
    80000b56:	8a32                	mv	s4,a2
    80000b58:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b5a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b5c:	6a85                	lui	s5,0x1
    80000b5e:	a015                	j	80000b82 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b60:	9562                	add	a0,a0,s8
    80000b62:	0004861b          	sext.w	a2,s1
    80000b66:	85d2                	mv	a1,s4
    80000b68:	41250533          	sub	a0,a0,s2
    80000b6c:	fffff097          	auipc	ra,0xfffff
    80000b70:	68e080e7          	jalr	1678(ra) # 800001fa <memmove>

    len -= n;
    80000b74:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b78:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b7a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b7e:	02098263          	beqz	s3,80000ba2 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b82:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b86:	85ca                	mv	a1,s2
    80000b88:	855a                	mv	a0,s6
    80000b8a:	00000097          	auipc	ra,0x0
    80000b8e:	99e080e7          	jalr	-1634(ra) # 80000528 <walkaddr>
    if(pa0 == 0)
    80000b92:	cd01                	beqz	a0,80000baa <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b94:	418904b3          	sub	s1,s2,s8
    80000b98:	94d6                	add	s1,s1,s5
    80000b9a:	fc99f3e3          	bgeu	s3,s1,80000b60 <copyout+0x28>
    80000b9e:	84ce                	mv	s1,s3
    80000ba0:	b7c1                	j	80000b60 <copyout+0x28>
  }
  return 0;
    80000ba2:	4501                	li	a0,0
    80000ba4:	a021                	j	80000bac <copyout+0x74>
    80000ba6:	4501                	li	a0,0
}
    80000ba8:	8082                	ret
      return -1;
    80000baa:	557d                	li	a0,-1
}
    80000bac:	60a6                	ld	ra,72(sp)
    80000bae:	6406                	ld	s0,64(sp)
    80000bb0:	74e2                	ld	s1,56(sp)
    80000bb2:	7942                	ld	s2,48(sp)
    80000bb4:	79a2                	ld	s3,40(sp)
    80000bb6:	7a02                	ld	s4,32(sp)
    80000bb8:	6ae2                	ld	s5,24(sp)
    80000bba:	6b42                	ld	s6,16(sp)
    80000bbc:	6ba2                	ld	s7,8(sp)
    80000bbe:	6c02                	ld	s8,0(sp)
    80000bc0:	6161                	addi	sp,sp,80
    80000bc2:	8082                	ret

0000000080000bc4 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bc4:	caa5                	beqz	a3,80000c34 <copyin+0x70>
{
    80000bc6:	715d                	addi	sp,sp,-80
    80000bc8:	e486                	sd	ra,72(sp)
    80000bca:	e0a2                	sd	s0,64(sp)
    80000bcc:	fc26                	sd	s1,56(sp)
    80000bce:	f84a                	sd	s2,48(sp)
    80000bd0:	f44e                	sd	s3,40(sp)
    80000bd2:	f052                	sd	s4,32(sp)
    80000bd4:	ec56                	sd	s5,24(sp)
    80000bd6:	e85a                	sd	s6,16(sp)
    80000bd8:	e45e                	sd	s7,8(sp)
    80000bda:	e062                	sd	s8,0(sp)
    80000bdc:	0880                	addi	s0,sp,80
    80000bde:	8b2a                	mv	s6,a0
    80000be0:	8a2e                	mv	s4,a1
    80000be2:	8c32                	mv	s8,a2
    80000be4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000be6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000be8:	6a85                	lui	s5,0x1
    80000bea:	a01d                	j	80000c10 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bec:	018505b3          	add	a1,a0,s8
    80000bf0:	0004861b          	sext.w	a2,s1
    80000bf4:	412585b3          	sub	a1,a1,s2
    80000bf8:	8552                	mv	a0,s4
    80000bfa:	fffff097          	auipc	ra,0xfffff
    80000bfe:	600080e7          	jalr	1536(ra) # 800001fa <memmove>

    len -= n;
    80000c02:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c06:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c08:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c0c:	02098263          	beqz	s3,80000c30 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c10:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c14:	85ca                	mv	a1,s2
    80000c16:	855a                	mv	a0,s6
    80000c18:	00000097          	auipc	ra,0x0
    80000c1c:	910080e7          	jalr	-1776(ra) # 80000528 <walkaddr>
    if(pa0 == 0)
    80000c20:	cd01                	beqz	a0,80000c38 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c22:	418904b3          	sub	s1,s2,s8
    80000c26:	94d6                	add	s1,s1,s5
    80000c28:	fc99f2e3          	bgeu	s3,s1,80000bec <copyin+0x28>
    80000c2c:	84ce                	mv	s1,s3
    80000c2e:	bf7d                	j	80000bec <copyin+0x28>
  }
  return 0;
    80000c30:	4501                	li	a0,0
    80000c32:	a021                	j	80000c3a <copyin+0x76>
    80000c34:	4501                	li	a0,0
}
    80000c36:	8082                	ret
      return -1;
    80000c38:	557d                	li	a0,-1
}
    80000c3a:	60a6                	ld	ra,72(sp)
    80000c3c:	6406                	ld	s0,64(sp)
    80000c3e:	74e2                	ld	s1,56(sp)
    80000c40:	7942                	ld	s2,48(sp)
    80000c42:	79a2                	ld	s3,40(sp)
    80000c44:	7a02                	ld	s4,32(sp)
    80000c46:	6ae2                	ld	s5,24(sp)
    80000c48:	6b42                	ld	s6,16(sp)
    80000c4a:	6ba2                	ld	s7,8(sp)
    80000c4c:	6c02                	ld	s8,0(sp)
    80000c4e:	6161                	addi	sp,sp,80
    80000c50:	8082                	ret

0000000080000c52 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c52:	c2dd                	beqz	a3,80000cf8 <copyinstr+0xa6>
{
    80000c54:	715d                	addi	sp,sp,-80
    80000c56:	e486                	sd	ra,72(sp)
    80000c58:	e0a2                	sd	s0,64(sp)
    80000c5a:	fc26                	sd	s1,56(sp)
    80000c5c:	f84a                	sd	s2,48(sp)
    80000c5e:	f44e                	sd	s3,40(sp)
    80000c60:	f052                	sd	s4,32(sp)
    80000c62:	ec56                	sd	s5,24(sp)
    80000c64:	e85a                	sd	s6,16(sp)
    80000c66:	e45e                	sd	s7,8(sp)
    80000c68:	0880                	addi	s0,sp,80
    80000c6a:	8a2a                	mv	s4,a0
    80000c6c:	8b2e                	mv	s6,a1
    80000c6e:	8bb2                	mv	s7,a2
    80000c70:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c72:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c74:	6985                	lui	s3,0x1
    80000c76:	a02d                	j	80000ca0 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c78:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c7c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c7e:	37fd                	addiw	a5,a5,-1
    80000c80:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c84:	60a6                	ld	ra,72(sp)
    80000c86:	6406                	ld	s0,64(sp)
    80000c88:	74e2                	ld	s1,56(sp)
    80000c8a:	7942                	ld	s2,48(sp)
    80000c8c:	79a2                	ld	s3,40(sp)
    80000c8e:	7a02                	ld	s4,32(sp)
    80000c90:	6ae2                	ld	s5,24(sp)
    80000c92:	6b42                	ld	s6,16(sp)
    80000c94:	6ba2                	ld	s7,8(sp)
    80000c96:	6161                	addi	sp,sp,80
    80000c98:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c9a:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c9e:	c8a9                	beqz	s1,80000cf0 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000ca0:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000ca4:	85ca                	mv	a1,s2
    80000ca6:	8552                	mv	a0,s4
    80000ca8:	00000097          	auipc	ra,0x0
    80000cac:	880080e7          	jalr	-1920(ra) # 80000528 <walkaddr>
    if(pa0 == 0)
    80000cb0:	c131                	beqz	a0,80000cf4 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000cb2:	417906b3          	sub	a3,s2,s7
    80000cb6:	96ce                	add	a3,a3,s3
    80000cb8:	00d4f363          	bgeu	s1,a3,80000cbe <copyinstr+0x6c>
    80000cbc:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cbe:	955e                	add	a0,a0,s7
    80000cc0:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cc4:	daf9                	beqz	a3,80000c9a <copyinstr+0x48>
    80000cc6:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000cc8:	41650633          	sub	a2,a0,s6
    80000ccc:	fff48593          	addi	a1,s1,-1
    80000cd0:	95da                	add	a1,a1,s6
    while(n > 0){
    80000cd2:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000cd4:	00f60733          	add	a4,a2,a5
    80000cd8:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdcef0>
    80000cdc:	df51                	beqz	a4,80000c78 <copyinstr+0x26>
        *dst = *p;
    80000cde:	00e78023          	sb	a4,0(a5)
      --max;
    80000ce2:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000ce6:	0785                	addi	a5,a5,1
    while(n > 0){
    80000ce8:	fed796e3          	bne	a5,a3,80000cd4 <copyinstr+0x82>
      dst++;
    80000cec:	8b3e                	mv	s6,a5
    80000cee:	b775                	j	80000c9a <copyinstr+0x48>
    80000cf0:	4781                	li	a5,0
    80000cf2:	b771                	j	80000c7e <copyinstr+0x2c>
      return -1;
    80000cf4:	557d                	li	a0,-1
    80000cf6:	b779                	j	80000c84 <copyinstr+0x32>
  int got_null = 0;
    80000cf8:	4781                	li	a5,0
  if(got_null){
    80000cfa:	37fd                	addiw	a5,a5,-1
    80000cfc:	0007851b          	sext.w	a0,a5
}
    80000d00:	8082                	ret

0000000080000d02 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    80000d02:	7139                	addi	sp,sp,-64
    80000d04:	fc06                	sd	ra,56(sp)
    80000d06:	f822                	sd	s0,48(sp)
    80000d08:	f426                	sd	s1,40(sp)
    80000d0a:	f04a                	sd	s2,32(sp)
    80000d0c:	ec4e                	sd	s3,24(sp)
    80000d0e:	e852                	sd	s4,16(sp)
    80000d10:	e456                	sd	s5,8(sp)
    80000d12:	e05a                	sd	s6,0(sp)
    80000d14:	0080                	addi	s0,sp,64
    80000d16:	89aa                	mv	s3,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++) {
    80000d18:	00008497          	auipc	s1,0x8
    80000d1c:	1d848493          	addi	s1,s1,472 # 80008ef0 <proc>
        char *pa = kalloc();
        if (pa == 0)
            panic("kalloc");
        uint64 va = KSTACK((int)(p - proc));
    80000d20:	8b26                	mv	s6,s1
    80000d22:	00007a97          	auipc	s5,0x7
    80000d26:	2dea8a93          	addi	s5,s5,734 # 80008000 <etext>
    80000d2a:	04000937          	lui	s2,0x4000
    80000d2e:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d30:	0932                	slli	s2,s2,0xc
    for (p = proc; p < &proc[NPROC]; p++) {
    80000d32:	0000ea17          	auipc	s4,0xe
    80000d36:	dbea0a13          	addi	s4,s4,-578 # 8000eaf0 <tickslock>
        char *pa = kalloc();
    80000d3a:	fffff097          	auipc	ra,0xfffff
    80000d3e:	3e0080e7          	jalr	992(ra) # 8000011a <kalloc>
    80000d42:	862a                	mv	a2,a0
        if (pa == 0)
    80000d44:	c131                	beqz	a0,80000d88 <proc_mapstacks+0x86>
        uint64 va = KSTACK((int)(p - proc));
    80000d46:	416485b3          	sub	a1,s1,s6
    80000d4a:	8591                	srai	a1,a1,0x4
    80000d4c:	000ab783          	ld	a5,0(s5)
    80000d50:	02f585b3          	mul	a1,a1,a5
    80000d54:	2585                	addiw	a1,a1,1
    80000d56:	00d5959b          	slliw	a1,a1,0xd
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d5a:	4719                	li	a4,6
    80000d5c:	6685                	lui	a3,0x1
    80000d5e:	40b905b3          	sub	a1,s2,a1
    80000d62:	854e                	mv	a0,s3
    80000d64:	00000097          	auipc	ra,0x0
    80000d68:	8a6080e7          	jalr	-1882(ra) # 8000060a <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++) {
    80000d6c:	17048493          	addi	s1,s1,368
    80000d70:	fd4495e3          	bne	s1,s4,80000d3a <proc_mapstacks+0x38>
    }
}
    80000d74:	70e2                	ld	ra,56(sp)
    80000d76:	7442                	ld	s0,48(sp)
    80000d78:	74a2                	ld	s1,40(sp)
    80000d7a:	7902                	ld	s2,32(sp)
    80000d7c:	69e2                	ld	s3,24(sp)
    80000d7e:	6a42                	ld	s4,16(sp)
    80000d80:	6aa2                	ld	s5,8(sp)
    80000d82:	6b02                	ld	s6,0(sp)
    80000d84:	6121                	addi	sp,sp,64
    80000d86:	8082                	ret
            panic("kalloc");
    80000d88:	00007517          	auipc	a0,0x7
    80000d8c:	3d050513          	addi	a0,a0,976 # 80008158 <etext+0x158>
    80000d90:	00005097          	auipc	ra,0x5
    80000d94:	f1c080e7          	jalr	-228(ra) # 80005cac <panic>

0000000080000d98 <procinit>:

// initialize the proc table.
void procinit(void)
{
    80000d98:	7139                	addi	sp,sp,-64
    80000d9a:	fc06                	sd	ra,56(sp)
    80000d9c:	f822                	sd	s0,48(sp)
    80000d9e:	f426                	sd	s1,40(sp)
    80000da0:	f04a                	sd	s2,32(sp)
    80000da2:	ec4e                	sd	s3,24(sp)
    80000da4:	e852                	sd	s4,16(sp)
    80000da6:	e456                	sd	s5,8(sp)
    80000da8:	e05a                	sd	s6,0(sp)
    80000daa:	0080                	addi	s0,sp,64
    struct proc *p;

    initlock(&pid_lock, "nextpid");
    80000dac:	00007597          	auipc	a1,0x7
    80000db0:	3b458593          	addi	a1,a1,948 # 80008160 <etext+0x160>
    80000db4:	00008517          	auipc	a0,0x8
    80000db8:	d0c50513          	addi	a0,a0,-756 # 80008ac0 <pid_lock>
    80000dbc:	00005097          	auipc	ra,0x5
    80000dc0:	398080e7          	jalr	920(ra) # 80006154 <initlock>
    initlock(&wait_lock, "wait_lock");
    80000dc4:	00007597          	auipc	a1,0x7
    80000dc8:	3a458593          	addi	a1,a1,932 # 80008168 <etext+0x168>
    80000dcc:	00008517          	auipc	a0,0x8
    80000dd0:	d0c50513          	addi	a0,a0,-756 # 80008ad8 <wait_lock>
    80000dd4:	00005097          	auipc	ra,0x5
    80000dd8:	380080e7          	jalr	896(ra) # 80006154 <initlock>
    for (p = proc; p < &proc[NPROC]; p++) {
    80000ddc:	00008497          	auipc	s1,0x8
    80000de0:	11448493          	addi	s1,s1,276 # 80008ef0 <proc>
        initlock(&p->lock, "proc");
    80000de4:	00007b17          	auipc	s6,0x7
    80000de8:	394b0b13          	addi	s6,s6,916 # 80008178 <etext+0x178>
        p->state = UNUSED;
        p->kstack = KSTACK((int)(p - proc));
    80000dec:	8aa6                	mv	s5,s1
    80000dee:	00007a17          	auipc	s4,0x7
    80000df2:	212a0a13          	addi	s4,s4,530 # 80008000 <etext>
    80000df6:	04000937          	lui	s2,0x4000
    80000dfa:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000dfc:	0932                	slli	s2,s2,0xc
    for (p = proc; p < &proc[NPROC]; p++) {
    80000dfe:	0000e997          	auipc	s3,0xe
    80000e02:	cf298993          	addi	s3,s3,-782 # 8000eaf0 <tickslock>
        initlock(&p->lock, "proc");
    80000e06:	85da                	mv	a1,s6
    80000e08:	8526                	mv	a0,s1
    80000e0a:	00005097          	auipc	ra,0x5
    80000e0e:	34a080e7          	jalr	842(ra) # 80006154 <initlock>
        p->state = UNUSED;
    80000e12:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int)(p - proc));
    80000e16:	415487b3          	sub	a5,s1,s5
    80000e1a:	8791                	srai	a5,a5,0x4
    80000e1c:	000a3703          	ld	a4,0(s4)
    80000e20:	02e787b3          	mul	a5,a5,a4
    80000e24:	2785                	addiw	a5,a5,1
    80000e26:	00d7979b          	slliw	a5,a5,0xd
    80000e2a:	40f907b3          	sub	a5,s2,a5
    80000e2e:	e0bc                	sd	a5,64(s1)
    for (p = proc; p < &proc[NPROC]; p++) {
    80000e30:	17048493          	addi	s1,s1,368
    80000e34:	fd3499e3          	bne	s1,s3,80000e06 <procinit+0x6e>
    }
}
    80000e38:	70e2                	ld	ra,56(sp)
    80000e3a:	7442                	ld	s0,48(sp)
    80000e3c:	74a2                	ld	s1,40(sp)
    80000e3e:	7902                	ld	s2,32(sp)
    80000e40:	69e2                	ld	s3,24(sp)
    80000e42:	6a42                	ld	s4,16(sp)
    80000e44:	6aa2                	ld	s5,8(sp)
    80000e46:	6b02                	ld	s6,0(sp)
    80000e48:	6121                	addi	sp,sp,64
    80000e4a:	8082                	ret

0000000080000e4c <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80000e4c:	1141                	addi	sp,sp,-16
    80000e4e:	e422                	sd	s0,8(sp)
    80000e50:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e52:	8512                	mv	a0,tp
    int id = r_tp();
    return id;
}
    80000e54:	2501                	sext.w	a0,a0
    80000e56:	6422                	ld	s0,8(sp)
    80000e58:	0141                	addi	sp,sp,16
    80000e5a:	8082                	ret

0000000080000e5c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *mycpu(void)
{
    80000e5c:	1141                	addi	sp,sp,-16
    80000e5e:	e422                	sd	s0,8(sp)
    80000e60:	0800                	addi	s0,sp,16
    80000e62:	8792                	mv	a5,tp
    int id = cpuid();
    struct cpu *c = &cpus[id];
    80000e64:	2781                	sext.w	a5,a5
    80000e66:	079e                	slli	a5,a5,0x7
    return c;
}
    80000e68:	00008517          	auipc	a0,0x8
    80000e6c:	c8850513          	addi	a0,a0,-888 # 80008af0 <cpus>
    80000e70:	953e                	add	a0,a0,a5
    80000e72:	6422                	ld	s0,8(sp)
    80000e74:	0141                	addi	sp,sp,16
    80000e76:	8082                	ret

0000000080000e78 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *myproc(void)
{
    80000e78:	1101                	addi	sp,sp,-32
    80000e7a:	ec06                	sd	ra,24(sp)
    80000e7c:	e822                	sd	s0,16(sp)
    80000e7e:	e426                	sd	s1,8(sp)
    80000e80:	1000                	addi	s0,sp,32
    push_off();
    80000e82:	00005097          	auipc	ra,0x5
    80000e86:	316080e7          	jalr	790(ra) # 80006198 <push_off>
    80000e8a:	8792                	mv	a5,tp
    struct cpu *c = mycpu();
    struct proc *p = c->proc;
    80000e8c:	2781                	sext.w	a5,a5
    80000e8e:	079e                	slli	a5,a5,0x7
    80000e90:	00008717          	auipc	a4,0x8
    80000e94:	c3070713          	addi	a4,a4,-976 # 80008ac0 <pid_lock>
    80000e98:	97ba                	add	a5,a5,a4
    80000e9a:	7b84                	ld	s1,48(a5)
    pop_off();
    80000e9c:	00005097          	auipc	ra,0x5
    80000ea0:	39c080e7          	jalr	924(ra) # 80006238 <pop_off>
    return p;
}
    80000ea4:	8526                	mv	a0,s1
    80000ea6:	60e2                	ld	ra,24(sp)
    80000ea8:	6442                	ld	s0,16(sp)
    80000eaa:	64a2                	ld	s1,8(sp)
    80000eac:	6105                	addi	sp,sp,32
    80000eae:	8082                	ret

0000000080000eb0 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80000eb0:	1141                	addi	sp,sp,-16
    80000eb2:	e406                	sd	ra,8(sp)
    80000eb4:	e022                	sd	s0,0(sp)
    80000eb6:	0800                	addi	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80000eb8:	00000097          	auipc	ra,0x0
    80000ebc:	fc0080e7          	jalr	-64(ra) # 80000e78 <myproc>
    80000ec0:	00005097          	auipc	ra,0x5
    80000ec4:	3d8080e7          	jalr	984(ra) # 80006298 <release>

    if (first) {
    80000ec8:	00008797          	auipc	a5,0x8
    80000ecc:	a487a783          	lw	a5,-1464(a5) # 80008910 <first.1>
    80000ed0:	eb89                	bnez	a5,80000ee2 <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80000ed2:	00001097          	auipc	ra,0x1
    80000ed6:	c92080e7          	jalr	-878(ra) # 80001b64 <usertrapret>
}
    80000eda:	60a2                	ld	ra,8(sp)
    80000edc:	6402                	ld	s0,0(sp)
    80000ede:	0141                	addi	sp,sp,16
    80000ee0:	8082                	ret
        first = 0;
    80000ee2:	00008797          	auipc	a5,0x8
    80000ee6:	a207a723          	sw	zero,-1490(a5) # 80008910 <first.1>
        fsinit(ROOTDEV);
    80000eea:	4505                	li	a0,1
    80000eec:	00002097          	auipc	ra,0x2
    80000ef0:	a8c080e7          	jalr	-1396(ra) # 80002978 <fsinit>
    80000ef4:	bff9                	j	80000ed2 <forkret+0x22>

0000000080000ef6 <allocpid>:
{
    80000ef6:	1101                	addi	sp,sp,-32
    80000ef8:	ec06                	sd	ra,24(sp)
    80000efa:	e822                	sd	s0,16(sp)
    80000efc:	e426                	sd	s1,8(sp)
    80000efe:	e04a                	sd	s2,0(sp)
    80000f00:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80000f02:	00008917          	auipc	s2,0x8
    80000f06:	bbe90913          	addi	s2,s2,-1090 # 80008ac0 <pid_lock>
    80000f0a:	854a                	mv	a0,s2
    80000f0c:	00005097          	auipc	ra,0x5
    80000f10:	2d8080e7          	jalr	728(ra) # 800061e4 <acquire>
    pid = nextpid;
    80000f14:	00008797          	auipc	a5,0x8
    80000f18:	a0078793          	addi	a5,a5,-1536 # 80008914 <nextpid>
    80000f1c:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80000f1e:	0014871b          	addiw	a4,s1,1
    80000f22:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80000f24:	854a                	mv	a0,s2
    80000f26:	00005097          	auipc	ra,0x5
    80000f2a:	372080e7          	jalr	882(ra) # 80006298 <release>
}
    80000f2e:	8526                	mv	a0,s1
    80000f30:	60e2                	ld	ra,24(sp)
    80000f32:	6442                	ld	s0,16(sp)
    80000f34:	64a2                	ld	s1,8(sp)
    80000f36:	6902                	ld	s2,0(sp)
    80000f38:	6105                	addi	sp,sp,32
    80000f3a:	8082                	ret

0000000080000f3c <proc_pagetable>:
{
    80000f3c:	1101                	addi	sp,sp,-32
    80000f3e:	ec06                	sd	ra,24(sp)
    80000f40:	e822                	sd	s0,16(sp)
    80000f42:	e426                	sd	s1,8(sp)
    80000f44:	e04a                	sd	s2,0(sp)
    80000f46:	1000                	addi	s0,sp,32
    80000f48:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80000f4a:	00000097          	auipc	ra,0x0
    80000f4e:	8aa080e7          	jalr	-1878(ra) # 800007f4 <uvmcreate>
    80000f52:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80000f54:	c121                	beqz	a0,80000f94 <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline, PTE_R | PTE_X) < 0) {
    80000f56:	4729                	li	a4,10
    80000f58:	00006697          	auipc	a3,0x6
    80000f5c:	0a868693          	addi	a3,a3,168 # 80007000 <_trampoline>
    80000f60:	6605                	lui	a2,0x1
    80000f62:	040005b7          	lui	a1,0x4000
    80000f66:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f68:	05b2                	slli	a1,a1,0xc
    80000f6a:	fffff097          	auipc	ra,0xfffff
    80000f6e:	600080e7          	jalr	1536(ra) # 8000056a <mappages>
    80000f72:	02054863          	bltz	a0,80000fa2 <proc_pagetable+0x66>
    if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe), PTE_R | PTE_W) < 0) {
    80000f76:	4719                	li	a4,6
    80000f78:	05893683          	ld	a3,88(s2)
    80000f7c:	6605                	lui	a2,0x1
    80000f7e:	020005b7          	lui	a1,0x2000
    80000f82:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f84:	05b6                	slli	a1,a1,0xd
    80000f86:	8526                	mv	a0,s1
    80000f88:	fffff097          	auipc	ra,0xfffff
    80000f8c:	5e2080e7          	jalr	1506(ra) # 8000056a <mappages>
    80000f90:	02054163          	bltz	a0,80000fb2 <proc_pagetable+0x76>
}
    80000f94:	8526                	mv	a0,s1
    80000f96:	60e2                	ld	ra,24(sp)
    80000f98:	6442                	ld	s0,16(sp)
    80000f9a:	64a2                	ld	s1,8(sp)
    80000f9c:	6902                	ld	s2,0(sp)
    80000f9e:	6105                	addi	sp,sp,32
    80000fa0:	8082                	ret
        uvmfree(pagetable, 0);
    80000fa2:	4581                	li	a1,0
    80000fa4:	8526                	mv	a0,s1
    80000fa6:	00000097          	auipc	ra,0x0
    80000faa:	a54080e7          	jalr	-1452(ra) # 800009fa <uvmfree>
        return 0;
    80000fae:	4481                	li	s1,0
    80000fb0:	b7d5                	j	80000f94 <proc_pagetable+0x58>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb2:	4681                	li	a3,0
    80000fb4:	4605                	li	a2,1
    80000fb6:	040005b7          	lui	a1,0x4000
    80000fba:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fbc:	05b2                	slli	a1,a1,0xc
    80000fbe:	8526                	mv	a0,s1
    80000fc0:	fffff097          	auipc	ra,0xfffff
    80000fc4:	770080e7          	jalr	1904(ra) # 80000730 <uvmunmap>
        uvmfree(pagetable, 0);
    80000fc8:	4581                	li	a1,0
    80000fca:	8526                	mv	a0,s1
    80000fcc:	00000097          	auipc	ra,0x0
    80000fd0:	a2e080e7          	jalr	-1490(ra) # 800009fa <uvmfree>
        return 0;
    80000fd4:	4481                	li	s1,0
    80000fd6:	bf7d                	j	80000f94 <proc_pagetable+0x58>

0000000080000fd8 <proc_freepagetable>:
{
    80000fd8:	1101                	addi	sp,sp,-32
    80000fda:	ec06                	sd	ra,24(sp)
    80000fdc:	e822                	sd	s0,16(sp)
    80000fde:	e426                	sd	s1,8(sp)
    80000fe0:	e04a                	sd	s2,0(sp)
    80000fe2:	1000                	addi	s0,sp,32
    80000fe4:	84aa                	mv	s1,a0
    80000fe6:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fe8:	4681                	li	a3,0
    80000fea:	4605                	li	a2,1
    80000fec:	040005b7          	lui	a1,0x4000
    80000ff0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ff2:	05b2                	slli	a1,a1,0xc
    80000ff4:	fffff097          	auipc	ra,0xfffff
    80000ff8:	73c080e7          	jalr	1852(ra) # 80000730 <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000ffc:	4681                	li	a3,0
    80000ffe:	4605                	li	a2,1
    80001000:	020005b7          	lui	a1,0x2000
    80001004:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001006:	05b6                	slli	a1,a1,0xd
    80001008:	8526                	mv	a0,s1
    8000100a:	fffff097          	auipc	ra,0xfffff
    8000100e:	726080e7          	jalr	1830(ra) # 80000730 <uvmunmap>
    uvmfree(pagetable, sz);
    80001012:	85ca                	mv	a1,s2
    80001014:	8526                	mv	a0,s1
    80001016:	00000097          	auipc	ra,0x0
    8000101a:	9e4080e7          	jalr	-1564(ra) # 800009fa <uvmfree>
}
    8000101e:	60e2                	ld	ra,24(sp)
    80001020:	6442                	ld	s0,16(sp)
    80001022:	64a2                	ld	s1,8(sp)
    80001024:	6902                	ld	s2,0(sp)
    80001026:	6105                	addi	sp,sp,32
    80001028:	8082                	ret

000000008000102a <freeproc>:
{
    8000102a:	1101                	addi	sp,sp,-32
    8000102c:	ec06                	sd	ra,24(sp)
    8000102e:	e822                	sd	s0,16(sp)
    80001030:	e426                	sd	s1,8(sp)
    80001032:	1000                	addi	s0,sp,32
    80001034:	84aa                	mv	s1,a0
    if (p->trapframe)
    80001036:	6d28                	ld	a0,88(a0)
    80001038:	c509                	beqz	a0,80001042 <freeproc+0x18>
        kfree((void *)p->trapframe);
    8000103a:	fffff097          	auipc	ra,0xfffff
    8000103e:	fe2080e7          	jalr	-30(ra) # 8000001c <kfree>
    p->trapframe = 0;
    80001042:	0404bc23          	sd	zero,88(s1)
    if (p->pagetable)
    80001046:	68a8                	ld	a0,80(s1)
    80001048:	c511                	beqz	a0,80001054 <freeproc+0x2a>
        proc_freepagetable(p->pagetable, p->sz);
    8000104a:	64ac                	ld	a1,72(s1)
    8000104c:	00000097          	auipc	ra,0x0
    80001050:	f8c080e7          	jalr	-116(ra) # 80000fd8 <proc_freepagetable>
    p->pagetable = 0;
    80001054:	0404b823          	sd	zero,80(s1)
    p->sz = 0;
    80001058:	0404b423          	sd	zero,72(s1)
    p->pid = 0;
    8000105c:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    80001060:	0204bc23          	sd	zero,56(s1)
    p->name[0] = 0;
    80001064:	14048c23          	sb	zero,344(s1)
    p->chan = 0;
    80001068:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    8000106c:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    80001070:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    80001074:	0004ac23          	sw	zero,24(s1)
}
    80001078:	60e2                	ld	ra,24(sp)
    8000107a:	6442                	ld	s0,16(sp)
    8000107c:	64a2                	ld	s1,8(sp)
    8000107e:	6105                	addi	sp,sp,32
    80001080:	8082                	ret

0000000080001082 <allocproc>:
{
    80001082:	1101                	addi	sp,sp,-32
    80001084:	ec06                	sd	ra,24(sp)
    80001086:	e822                	sd	s0,16(sp)
    80001088:	e426                	sd	s1,8(sp)
    8000108a:	e04a                	sd	s2,0(sp)
    8000108c:	1000                	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++) {
    8000108e:	00008497          	auipc	s1,0x8
    80001092:	e6248493          	addi	s1,s1,-414 # 80008ef0 <proc>
    80001096:	0000e917          	auipc	s2,0xe
    8000109a:	a5a90913          	addi	s2,s2,-1446 # 8000eaf0 <tickslock>
        acquire(&p->lock);
    8000109e:	8526                	mv	a0,s1
    800010a0:	00005097          	auipc	ra,0x5
    800010a4:	144080e7          	jalr	324(ra) # 800061e4 <acquire>
        if (p->state == UNUSED) {
    800010a8:	4c9c                	lw	a5,24(s1)
    800010aa:	cf81                	beqz	a5,800010c2 <allocproc+0x40>
            release(&p->lock);
    800010ac:	8526                	mv	a0,s1
    800010ae:	00005097          	auipc	ra,0x5
    800010b2:	1ea080e7          	jalr	490(ra) # 80006298 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    800010b6:	17048493          	addi	s1,s1,368
    800010ba:	ff2492e3          	bne	s1,s2,8000109e <allocproc+0x1c>
    return 0;
    800010be:	4481                	li	s1,0
    800010c0:	a889                	j	80001112 <allocproc+0x90>
    p->pid = allocpid();
    800010c2:	00000097          	auipc	ra,0x0
    800010c6:	e34080e7          	jalr	-460(ra) # 80000ef6 <allocpid>
    800010ca:	d888                	sw	a0,48(s1)
    p->state = USED;
    800010cc:	4785                	li	a5,1
    800010ce:	cc9c                	sw	a5,24(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    800010d0:	fffff097          	auipc	ra,0xfffff
    800010d4:	04a080e7          	jalr	74(ra) # 8000011a <kalloc>
    800010d8:	892a                	mv	s2,a0
    800010da:	eca8                	sd	a0,88(s1)
    800010dc:	c131                	beqz	a0,80001120 <allocproc+0x9e>
    p->pagetable = proc_pagetable(p);
    800010de:	8526                	mv	a0,s1
    800010e0:	00000097          	auipc	ra,0x0
    800010e4:	e5c080e7          	jalr	-420(ra) # 80000f3c <proc_pagetable>
    800010e8:	892a                	mv	s2,a0
    800010ea:	e8a8                	sd	a0,80(s1)
    if (p->pagetable == 0) {
    800010ec:	c531                	beqz	a0,80001138 <allocproc+0xb6>
    memset(&p->context, 0, sizeof(p->context));
    800010ee:	07000613          	li	a2,112
    800010f2:	4581                	li	a1,0
    800010f4:	06048513          	addi	a0,s1,96
    800010f8:	fffff097          	auipc	ra,0xfffff
    800010fc:	0a6080e7          	jalr	166(ra) # 8000019e <memset>
    p->context.ra = (uint64)forkret;
    80001100:	00000797          	auipc	a5,0x0
    80001104:	db078793          	addi	a5,a5,-592 # 80000eb0 <forkret>
    80001108:	f0bc                	sd	a5,96(s1)
    p->context.sp = p->kstack + PGSIZE;
    8000110a:	60bc                	ld	a5,64(s1)
    8000110c:	6705                	lui	a4,0x1
    8000110e:	97ba                	add	a5,a5,a4
    80001110:	f4bc                	sd	a5,104(s1)
}
    80001112:	8526                	mv	a0,s1
    80001114:	60e2                	ld	ra,24(sp)
    80001116:	6442                	ld	s0,16(sp)
    80001118:	64a2                	ld	s1,8(sp)
    8000111a:	6902                	ld	s2,0(sp)
    8000111c:	6105                	addi	sp,sp,32
    8000111e:	8082                	ret
        freeproc(p);
    80001120:	8526                	mv	a0,s1
    80001122:	00000097          	auipc	ra,0x0
    80001126:	f08080e7          	jalr	-248(ra) # 8000102a <freeproc>
        release(&p->lock);
    8000112a:	8526                	mv	a0,s1
    8000112c:	00005097          	auipc	ra,0x5
    80001130:	16c080e7          	jalr	364(ra) # 80006298 <release>
        return 0;
    80001134:	84ca                	mv	s1,s2
    80001136:	bff1                	j	80001112 <allocproc+0x90>
        freeproc(p);
    80001138:	8526                	mv	a0,s1
    8000113a:	00000097          	auipc	ra,0x0
    8000113e:	ef0080e7          	jalr	-272(ra) # 8000102a <freeproc>
        release(&p->lock);
    80001142:	8526                	mv	a0,s1
    80001144:	00005097          	auipc	ra,0x5
    80001148:	154080e7          	jalr	340(ra) # 80006298 <release>
        return 0;
    8000114c:	84ca                	mv	s1,s2
    8000114e:	b7d1                	j	80001112 <allocproc+0x90>

0000000080001150 <userinit>:
{
    80001150:	1101                	addi	sp,sp,-32
    80001152:	ec06                	sd	ra,24(sp)
    80001154:	e822                	sd	s0,16(sp)
    80001156:	e426                	sd	s1,8(sp)
    80001158:	1000                	addi	s0,sp,32
    p = allocproc();
    8000115a:	00000097          	auipc	ra,0x0
    8000115e:	f28080e7          	jalr	-216(ra) # 80001082 <allocproc>
    80001162:	84aa                	mv	s1,a0
    initproc = p;
    80001164:	00008797          	auipc	a5,0x8
    80001168:	90a7be23          	sd	a0,-1764(a5) # 80008a80 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000116c:	03400613          	li	a2,52
    80001170:	00007597          	auipc	a1,0x7
    80001174:	7b058593          	addi	a1,a1,1968 # 80008920 <initcode>
    80001178:	6928                	ld	a0,80(a0)
    8000117a:	fffff097          	auipc	ra,0xfffff
    8000117e:	6a8080e7          	jalr	1704(ra) # 80000822 <uvmfirst>
    p->sz = PGSIZE;
    80001182:	6785                	lui	a5,0x1
    80001184:	e4bc                	sd	a5,72(s1)
    p->trapframe->epc = 0;     // user program counter
    80001186:	6cb8                	ld	a4,88(s1)
    80001188:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    8000118c:	6cb8                	ld	a4,88(s1)
    8000118e:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    80001190:	4641                	li	a2,16
    80001192:	00007597          	auipc	a1,0x7
    80001196:	fee58593          	addi	a1,a1,-18 # 80008180 <etext+0x180>
    8000119a:	15848513          	addi	a0,s1,344
    8000119e:	fffff097          	auipc	ra,0xfffff
    800011a2:	14a080e7          	jalr	330(ra) # 800002e8 <safestrcpy>
    p->cwd = namei("/");
    800011a6:	00007517          	auipc	a0,0x7
    800011aa:	fea50513          	addi	a0,a0,-22 # 80008190 <etext+0x190>
    800011ae:	00002097          	auipc	ra,0x2
    800011b2:	1f4080e7          	jalr	500(ra) # 800033a2 <namei>
    800011b6:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    800011ba:	478d                	li	a5,3
    800011bc:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    800011be:	8526                	mv	a0,s1
    800011c0:	00005097          	auipc	ra,0x5
    800011c4:	0d8080e7          	jalr	216(ra) # 80006298 <release>
}
    800011c8:	60e2                	ld	ra,24(sp)
    800011ca:	6442                	ld	s0,16(sp)
    800011cc:	64a2                	ld	s1,8(sp)
    800011ce:	6105                	addi	sp,sp,32
    800011d0:	8082                	ret

00000000800011d2 <growproc>:
{
    800011d2:	1101                	addi	sp,sp,-32
    800011d4:	ec06                	sd	ra,24(sp)
    800011d6:	e822                	sd	s0,16(sp)
    800011d8:	e426                	sd	s1,8(sp)
    800011da:	e04a                	sd	s2,0(sp)
    800011dc:	1000                	addi	s0,sp,32
    800011de:	892a                	mv	s2,a0
    struct proc *p = myproc();
    800011e0:	00000097          	auipc	ra,0x0
    800011e4:	c98080e7          	jalr	-872(ra) # 80000e78 <myproc>
    800011e8:	84aa                	mv	s1,a0
    sz = p->sz;
    800011ea:	652c                	ld	a1,72(a0)
    if (n > 0) {
    800011ec:	01204c63          	bgtz	s2,80001204 <growproc+0x32>
    else if (n < 0) {
    800011f0:	02094663          	bltz	s2,8000121c <growproc+0x4a>
    p->sz = sz;
    800011f4:	e4ac                	sd	a1,72(s1)
    return 0;
    800011f6:	4501                	li	a0,0
}
    800011f8:	60e2                	ld	ra,24(sp)
    800011fa:	6442                	ld	s0,16(sp)
    800011fc:	64a2                	ld	s1,8(sp)
    800011fe:	6902                	ld	s2,0(sp)
    80001200:	6105                	addi	sp,sp,32
    80001202:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001204:	4691                	li	a3,4
    80001206:	00b90633          	add	a2,s2,a1
    8000120a:	6928                	ld	a0,80(a0)
    8000120c:	fffff097          	auipc	ra,0xfffff
    80001210:	6d0080e7          	jalr	1744(ra) # 800008dc <uvmalloc>
    80001214:	85aa                	mv	a1,a0
    80001216:	fd79                	bnez	a0,800011f4 <growproc+0x22>
            return -1;
    80001218:	557d                	li	a0,-1
    8000121a:	bff9                	j	800011f8 <growproc+0x26>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000121c:	00b90633          	add	a2,s2,a1
    80001220:	6928                	ld	a0,80(a0)
    80001222:	fffff097          	auipc	ra,0xfffff
    80001226:	672080e7          	jalr	1650(ra) # 80000894 <uvmdealloc>
    8000122a:	85aa                	mv	a1,a0
    8000122c:	b7e1                	j	800011f4 <growproc+0x22>

000000008000122e <fork>:
{
    8000122e:	7139                	addi	sp,sp,-64
    80001230:	fc06                	sd	ra,56(sp)
    80001232:	f822                	sd	s0,48(sp)
    80001234:	f426                	sd	s1,40(sp)
    80001236:	f04a                	sd	s2,32(sp)
    80001238:	ec4e                	sd	s3,24(sp)
    8000123a:	e852                	sd	s4,16(sp)
    8000123c:	e456                	sd	s5,8(sp)
    8000123e:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    80001240:	00000097          	auipc	ra,0x0
    80001244:	c38080e7          	jalr	-968(ra) # 80000e78 <myproc>
    80001248:	8aaa                	mv	s5,a0
    if ((np = allocproc()) == 0) {
    8000124a:	00000097          	auipc	ra,0x0
    8000124e:	e38080e7          	jalr	-456(ra) # 80001082 <allocproc>
    80001252:	12050063          	beqz	a0,80001372 <fork+0x144>
    80001256:	89aa                	mv	s3,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    80001258:	048ab603          	ld	a2,72(s5)
    8000125c:	692c                	ld	a1,80(a0)
    8000125e:	050ab503          	ld	a0,80(s5)
    80001262:	fffff097          	auipc	ra,0xfffff
    80001266:	7d2080e7          	jalr	2002(ra) # 80000a34 <uvmcopy>
    8000126a:	04054863          	bltz	a0,800012ba <fork+0x8c>
    np->sz = p->sz;
    8000126e:	048ab783          	ld	a5,72(s5)
    80001272:	04f9b423          	sd	a5,72(s3)
    *(np->trapframe) = *(p->trapframe);
    80001276:	058ab683          	ld	a3,88(s5)
    8000127a:	87b6                	mv	a5,a3
    8000127c:	0589b703          	ld	a4,88(s3)
    80001280:	12068693          	addi	a3,a3,288
    80001284:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001288:	6788                	ld	a0,8(a5)
    8000128a:	6b8c                	ld	a1,16(a5)
    8000128c:	6f90                	ld	a2,24(a5)
    8000128e:	01073023          	sd	a6,0(a4)
    80001292:	e708                	sd	a0,8(a4)
    80001294:	eb0c                	sd	a1,16(a4)
    80001296:	ef10                	sd	a2,24(a4)
    80001298:	02078793          	addi	a5,a5,32
    8000129c:	02070713          	addi	a4,a4,32
    800012a0:	fed792e3          	bne	a5,a3,80001284 <fork+0x56>
    np->trapframe->a0 = 0;
    800012a4:	0589b783          	ld	a5,88(s3)
    800012a8:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++)
    800012ac:	0d0a8493          	addi	s1,s5,208
    800012b0:	0d098913          	addi	s2,s3,208
    800012b4:	150a8a13          	addi	s4,s5,336
    800012b8:	a00d                	j	800012da <fork+0xac>
        freeproc(np);
    800012ba:	854e                	mv	a0,s3
    800012bc:	00000097          	auipc	ra,0x0
    800012c0:	d6e080e7          	jalr	-658(ra) # 8000102a <freeproc>
        release(&np->lock);
    800012c4:	854e                	mv	a0,s3
    800012c6:	00005097          	auipc	ra,0x5
    800012ca:	fd2080e7          	jalr	-46(ra) # 80006298 <release>
        return -1;
    800012ce:	597d                	li	s2,-1
    800012d0:	a079                	j	8000135e <fork+0x130>
    for (i = 0; i < NOFILE; i++)
    800012d2:	04a1                	addi	s1,s1,8
    800012d4:	0921                	addi	s2,s2,8
    800012d6:	01448b63          	beq	s1,s4,800012ec <fork+0xbe>
        if (p->ofile[i])
    800012da:	6088                	ld	a0,0(s1)
    800012dc:	d97d                	beqz	a0,800012d2 <fork+0xa4>
            np->ofile[i] = filedup(p->ofile[i]);
    800012de:	00002097          	auipc	ra,0x2
    800012e2:	75a080e7          	jalr	1882(ra) # 80003a38 <filedup>
    800012e6:	00a93023          	sd	a0,0(s2)
    800012ea:	b7e5                	j	800012d2 <fork+0xa4>
    np->cwd = idup(p->cwd);
    800012ec:	150ab503          	ld	a0,336(s5)
    800012f0:	00002097          	auipc	ra,0x2
    800012f4:	8c8080e7          	jalr	-1848(ra) # 80002bb8 <idup>
    800012f8:	14a9b823          	sd	a0,336(s3)
    safestrcpy(np->name, p->name, sizeof(p->name));
    800012fc:	4641                	li	a2,16
    800012fe:	158a8593          	addi	a1,s5,344
    80001302:	15898513          	addi	a0,s3,344
    80001306:	fffff097          	auipc	ra,0xfffff
    8000130a:	fe2080e7          	jalr	-30(ra) # 800002e8 <safestrcpy>
    pid = np->pid;
    8000130e:	0309a903          	lw	s2,48(s3)
    np->mask = p->mask;
    80001312:	168aa783          	lw	a5,360(s5)
    80001316:	16f9a423          	sw	a5,360(s3)
    release(&np->lock);
    8000131a:	854e                	mv	a0,s3
    8000131c:	00005097          	auipc	ra,0x5
    80001320:	f7c080e7          	jalr	-132(ra) # 80006298 <release>
    acquire(&wait_lock);
    80001324:	00007497          	auipc	s1,0x7
    80001328:	7b448493          	addi	s1,s1,1972 # 80008ad8 <wait_lock>
    8000132c:	8526                	mv	a0,s1
    8000132e:	00005097          	auipc	ra,0x5
    80001332:	eb6080e7          	jalr	-330(ra) # 800061e4 <acquire>
    np->parent = p;
    80001336:	0359bc23          	sd	s5,56(s3)
    release(&wait_lock);
    8000133a:	8526                	mv	a0,s1
    8000133c:	00005097          	auipc	ra,0x5
    80001340:	f5c080e7          	jalr	-164(ra) # 80006298 <release>
    acquire(&np->lock);
    80001344:	854e                	mv	a0,s3
    80001346:	00005097          	auipc	ra,0x5
    8000134a:	e9e080e7          	jalr	-354(ra) # 800061e4 <acquire>
    np->state = RUNNABLE;
    8000134e:	478d                	li	a5,3
    80001350:	00f9ac23          	sw	a5,24(s3)
    release(&np->lock);
    80001354:	854e                	mv	a0,s3
    80001356:	00005097          	auipc	ra,0x5
    8000135a:	f42080e7          	jalr	-190(ra) # 80006298 <release>
}
    8000135e:	854a                	mv	a0,s2
    80001360:	70e2                	ld	ra,56(sp)
    80001362:	7442                	ld	s0,48(sp)
    80001364:	74a2                	ld	s1,40(sp)
    80001366:	7902                	ld	s2,32(sp)
    80001368:	69e2                	ld	s3,24(sp)
    8000136a:	6a42                	ld	s4,16(sp)
    8000136c:	6aa2                	ld	s5,8(sp)
    8000136e:	6121                	addi	sp,sp,64
    80001370:	8082                	ret
        return -1;
    80001372:	597d                	li	s2,-1
    80001374:	b7ed                	j	8000135e <fork+0x130>

0000000080001376 <scheduler>:
{
    80001376:	7139                	addi	sp,sp,-64
    80001378:	fc06                	sd	ra,56(sp)
    8000137a:	f822                	sd	s0,48(sp)
    8000137c:	f426                	sd	s1,40(sp)
    8000137e:	f04a                	sd	s2,32(sp)
    80001380:	ec4e                	sd	s3,24(sp)
    80001382:	e852                	sd	s4,16(sp)
    80001384:	e456                	sd	s5,8(sp)
    80001386:	e05a                	sd	s6,0(sp)
    80001388:	0080                	addi	s0,sp,64
    8000138a:	8792                	mv	a5,tp
    int id = r_tp();
    8000138c:	2781                	sext.w	a5,a5
    c->proc = 0;
    8000138e:	00779a93          	slli	s5,a5,0x7
    80001392:	00007717          	auipc	a4,0x7
    80001396:	72e70713          	addi	a4,a4,1838 # 80008ac0 <pid_lock>
    8000139a:	9756                	add	a4,a4,s5
    8000139c:	02073823          	sd	zero,48(a4)
                swtch(&c->context, &p->context);
    800013a0:	00007717          	auipc	a4,0x7
    800013a4:	75870713          	addi	a4,a4,1880 # 80008af8 <cpus+0x8>
    800013a8:	9aba                	add	s5,s5,a4
            if (p->state == RUNNABLE) {
    800013aa:	498d                	li	s3,3
                p->state = RUNNING;
    800013ac:	4b11                	li	s6,4
                c->proc = p;
    800013ae:	079e                	slli	a5,a5,0x7
    800013b0:	00007a17          	auipc	s4,0x7
    800013b4:	710a0a13          	addi	s4,s4,1808 # 80008ac0 <pid_lock>
    800013b8:	9a3e                	add	s4,s4,a5
        for (p = proc; p < &proc[NPROC]; p++) {
    800013ba:	0000d917          	auipc	s2,0xd
    800013be:	73690913          	addi	s2,s2,1846 # 8000eaf0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013c2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013c6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013ca:	10079073          	csrw	sstatus,a5
    800013ce:	00008497          	auipc	s1,0x8
    800013d2:	b2248493          	addi	s1,s1,-1246 # 80008ef0 <proc>
    800013d6:	a811                	j	800013ea <scheduler+0x74>
            release(&p->lock);
    800013d8:	8526                	mv	a0,s1
    800013da:	00005097          	auipc	ra,0x5
    800013de:	ebe080e7          	jalr	-322(ra) # 80006298 <release>
        for (p = proc; p < &proc[NPROC]; p++) {
    800013e2:	17048493          	addi	s1,s1,368
    800013e6:	fd248ee3          	beq	s1,s2,800013c2 <scheduler+0x4c>
            acquire(&p->lock);
    800013ea:	8526                	mv	a0,s1
    800013ec:	00005097          	auipc	ra,0x5
    800013f0:	df8080e7          	jalr	-520(ra) # 800061e4 <acquire>
            if (p->state == RUNNABLE) {
    800013f4:	4c9c                	lw	a5,24(s1)
    800013f6:	ff3791e3          	bne	a5,s3,800013d8 <scheduler+0x62>
                p->state = RUNNING;
    800013fa:	0164ac23          	sw	s6,24(s1)
                c->proc = p;
    800013fe:	029a3823          	sd	s1,48(s4)
                swtch(&c->context, &p->context);
    80001402:	06048593          	addi	a1,s1,96
    80001406:	8556                	mv	a0,s5
    80001408:	00000097          	auipc	ra,0x0
    8000140c:	6b2080e7          	jalr	1714(ra) # 80001aba <swtch>
                c->proc = 0;
    80001410:	020a3823          	sd	zero,48(s4)
    80001414:	b7d1                	j	800013d8 <scheduler+0x62>

0000000080001416 <sched>:
{
    80001416:	7179                	addi	sp,sp,-48
    80001418:	f406                	sd	ra,40(sp)
    8000141a:	f022                	sd	s0,32(sp)
    8000141c:	ec26                	sd	s1,24(sp)
    8000141e:	e84a                	sd	s2,16(sp)
    80001420:	e44e                	sd	s3,8(sp)
    80001422:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80001424:	00000097          	auipc	ra,0x0
    80001428:	a54080e7          	jalr	-1452(ra) # 80000e78 <myproc>
    8000142c:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    8000142e:	00005097          	auipc	ra,0x5
    80001432:	d3c080e7          	jalr	-708(ra) # 8000616a <holding>
    80001436:	c93d                	beqz	a0,800014ac <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001438:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    8000143a:	2781                	sext.w	a5,a5
    8000143c:	079e                	slli	a5,a5,0x7
    8000143e:	00007717          	auipc	a4,0x7
    80001442:	68270713          	addi	a4,a4,1666 # 80008ac0 <pid_lock>
    80001446:	97ba                	add	a5,a5,a4
    80001448:	0a87a703          	lw	a4,168(a5)
    8000144c:	4785                	li	a5,1
    8000144e:	06f71763          	bne	a4,a5,800014bc <sched+0xa6>
    if (p->state == RUNNING)
    80001452:	4c98                	lw	a4,24(s1)
    80001454:	4791                	li	a5,4
    80001456:	06f70b63          	beq	a4,a5,800014cc <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000145a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000145e:	8b89                	andi	a5,a5,2
    if (intr_get())
    80001460:	efb5                	bnez	a5,800014dc <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001462:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    80001464:	00007917          	auipc	s2,0x7
    80001468:	65c90913          	addi	s2,s2,1628 # 80008ac0 <pid_lock>
    8000146c:	2781                	sext.w	a5,a5
    8000146e:	079e                	slli	a5,a5,0x7
    80001470:	97ca                	add	a5,a5,s2
    80001472:	0ac7a983          	lw	s3,172(a5)
    80001476:	8792                	mv	a5,tp
    swtch(&p->context, &mycpu()->context);
    80001478:	2781                	sext.w	a5,a5
    8000147a:	079e                	slli	a5,a5,0x7
    8000147c:	00007597          	auipc	a1,0x7
    80001480:	67c58593          	addi	a1,a1,1660 # 80008af8 <cpus+0x8>
    80001484:	95be                	add	a1,a1,a5
    80001486:	06048513          	addi	a0,s1,96
    8000148a:	00000097          	auipc	ra,0x0
    8000148e:	630080e7          	jalr	1584(ra) # 80001aba <swtch>
    80001492:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    80001494:	2781                	sext.w	a5,a5
    80001496:	079e                	slli	a5,a5,0x7
    80001498:	993e                	add	s2,s2,a5
    8000149a:	0b392623          	sw	s3,172(s2)
}
    8000149e:	70a2                	ld	ra,40(sp)
    800014a0:	7402                	ld	s0,32(sp)
    800014a2:	64e2                	ld	s1,24(sp)
    800014a4:	6942                	ld	s2,16(sp)
    800014a6:	69a2                	ld	s3,8(sp)
    800014a8:	6145                	addi	sp,sp,48
    800014aa:	8082                	ret
        panic("sched p->lock");
    800014ac:	00007517          	auipc	a0,0x7
    800014b0:	cec50513          	addi	a0,a0,-788 # 80008198 <etext+0x198>
    800014b4:	00004097          	auipc	ra,0x4
    800014b8:	7f8080e7          	jalr	2040(ra) # 80005cac <panic>
        panic("sched locks");
    800014bc:	00007517          	auipc	a0,0x7
    800014c0:	cec50513          	addi	a0,a0,-788 # 800081a8 <etext+0x1a8>
    800014c4:	00004097          	auipc	ra,0x4
    800014c8:	7e8080e7          	jalr	2024(ra) # 80005cac <panic>
        panic("sched running");
    800014cc:	00007517          	auipc	a0,0x7
    800014d0:	cec50513          	addi	a0,a0,-788 # 800081b8 <etext+0x1b8>
    800014d4:	00004097          	auipc	ra,0x4
    800014d8:	7d8080e7          	jalr	2008(ra) # 80005cac <panic>
        panic("sched interruptible");
    800014dc:	00007517          	auipc	a0,0x7
    800014e0:	cec50513          	addi	a0,a0,-788 # 800081c8 <etext+0x1c8>
    800014e4:	00004097          	auipc	ra,0x4
    800014e8:	7c8080e7          	jalr	1992(ra) # 80005cac <panic>

00000000800014ec <yield>:
{
    800014ec:	1101                	addi	sp,sp,-32
    800014ee:	ec06                	sd	ra,24(sp)
    800014f0:	e822                	sd	s0,16(sp)
    800014f2:	e426                	sd	s1,8(sp)
    800014f4:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    800014f6:	00000097          	auipc	ra,0x0
    800014fa:	982080e7          	jalr	-1662(ra) # 80000e78 <myproc>
    800014fe:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80001500:	00005097          	auipc	ra,0x5
    80001504:	ce4080e7          	jalr	-796(ra) # 800061e4 <acquire>
    p->state = RUNNABLE;
    80001508:	478d                	li	a5,3
    8000150a:	cc9c                	sw	a5,24(s1)
    sched();
    8000150c:	00000097          	auipc	ra,0x0
    80001510:	f0a080e7          	jalr	-246(ra) # 80001416 <sched>
    release(&p->lock);
    80001514:	8526                	mv	a0,s1
    80001516:	00005097          	auipc	ra,0x5
    8000151a:	d82080e7          	jalr	-638(ra) # 80006298 <release>
}
    8000151e:	60e2                	ld	ra,24(sp)
    80001520:	6442                	ld	s0,16(sp)
    80001522:	64a2                	ld	s1,8(sp)
    80001524:	6105                	addi	sp,sp,32
    80001526:	8082                	ret

0000000080001528 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    80001528:	7179                	addi	sp,sp,-48
    8000152a:	f406                	sd	ra,40(sp)
    8000152c:	f022                	sd	s0,32(sp)
    8000152e:	ec26                	sd	s1,24(sp)
    80001530:	e84a                	sd	s2,16(sp)
    80001532:	e44e                	sd	s3,8(sp)
    80001534:	1800                	addi	s0,sp,48
    80001536:	89aa                	mv	s3,a0
    80001538:	892e                	mv	s2,a1
    struct proc *p = myproc();
    8000153a:	00000097          	auipc	ra,0x0
    8000153e:	93e080e7          	jalr	-1730(ra) # 80000e78 <myproc>
    80001542:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    80001544:	00005097          	auipc	ra,0x5
    80001548:	ca0080e7          	jalr	-864(ra) # 800061e4 <acquire>
    release(lk);
    8000154c:	854a                	mv	a0,s2
    8000154e:	00005097          	auipc	ra,0x5
    80001552:	d4a080e7          	jalr	-694(ra) # 80006298 <release>

    // Go to sleep.
    p->chan = chan;
    80001556:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    8000155a:	4789                	li	a5,2
    8000155c:	cc9c                	sw	a5,24(s1)

    sched();
    8000155e:	00000097          	auipc	ra,0x0
    80001562:	eb8080e7          	jalr	-328(ra) # 80001416 <sched>

    // Tidy up.
    p->chan = 0;
    80001566:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    8000156a:	8526                	mv	a0,s1
    8000156c:	00005097          	auipc	ra,0x5
    80001570:	d2c080e7          	jalr	-724(ra) # 80006298 <release>
    acquire(lk);
    80001574:	854a                	mv	a0,s2
    80001576:	00005097          	auipc	ra,0x5
    8000157a:	c6e080e7          	jalr	-914(ra) # 800061e4 <acquire>
}
    8000157e:	70a2                	ld	ra,40(sp)
    80001580:	7402                	ld	s0,32(sp)
    80001582:	64e2                	ld	s1,24(sp)
    80001584:	6942                	ld	s2,16(sp)
    80001586:	69a2                	ld	s3,8(sp)
    80001588:	6145                	addi	sp,sp,48
    8000158a:	8082                	ret

000000008000158c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    8000158c:	7139                	addi	sp,sp,-64
    8000158e:	fc06                	sd	ra,56(sp)
    80001590:	f822                	sd	s0,48(sp)
    80001592:	f426                	sd	s1,40(sp)
    80001594:	f04a                	sd	s2,32(sp)
    80001596:	ec4e                	sd	s3,24(sp)
    80001598:	e852                	sd	s4,16(sp)
    8000159a:	e456                	sd	s5,8(sp)
    8000159c:	0080                	addi	s0,sp,64
    8000159e:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++) {
    800015a0:	00008497          	auipc	s1,0x8
    800015a4:	95048493          	addi	s1,s1,-1712 # 80008ef0 <proc>
        if (p != myproc()) {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan) {
    800015a8:	4989                	li	s3,2
                p->state = RUNNABLE;
    800015aa:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++) {
    800015ac:	0000d917          	auipc	s2,0xd
    800015b0:	54490913          	addi	s2,s2,1348 # 8000eaf0 <tickslock>
    800015b4:	a811                	j	800015c8 <wakeup+0x3c>
            }
            release(&p->lock);
    800015b6:	8526                	mv	a0,s1
    800015b8:	00005097          	auipc	ra,0x5
    800015bc:	ce0080e7          	jalr	-800(ra) # 80006298 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    800015c0:	17048493          	addi	s1,s1,368
    800015c4:	03248663          	beq	s1,s2,800015f0 <wakeup+0x64>
        if (p != myproc()) {
    800015c8:	00000097          	auipc	ra,0x0
    800015cc:	8b0080e7          	jalr	-1872(ra) # 80000e78 <myproc>
    800015d0:	fea488e3          	beq	s1,a0,800015c0 <wakeup+0x34>
            acquire(&p->lock);
    800015d4:	8526                	mv	a0,s1
    800015d6:	00005097          	auipc	ra,0x5
    800015da:	c0e080e7          	jalr	-1010(ra) # 800061e4 <acquire>
            if (p->state == SLEEPING && p->chan == chan) {
    800015de:	4c9c                	lw	a5,24(s1)
    800015e0:	fd379be3          	bne	a5,s3,800015b6 <wakeup+0x2a>
    800015e4:	709c                	ld	a5,32(s1)
    800015e6:	fd4798e3          	bne	a5,s4,800015b6 <wakeup+0x2a>
                p->state = RUNNABLE;
    800015ea:	0154ac23          	sw	s5,24(s1)
    800015ee:	b7e1                	j	800015b6 <wakeup+0x2a>
        }
    }
}
    800015f0:	70e2                	ld	ra,56(sp)
    800015f2:	7442                	ld	s0,48(sp)
    800015f4:	74a2                	ld	s1,40(sp)
    800015f6:	7902                	ld	s2,32(sp)
    800015f8:	69e2                	ld	s3,24(sp)
    800015fa:	6a42                	ld	s4,16(sp)
    800015fc:	6aa2                	ld	s5,8(sp)
    800015fe:	6121                	addi	sp,sp,64
    80001600:	8082                	ret

0000000080001602 <reparent>:
{
    80001602:	7179                	addi	sp,sp,-48
    80001604:	f406                	sd	ra,40(sp)
    80001606:	f022                	sd	s0,32(sp)
    80001608:	ec26                	sd	s1,24(sp)
    8000160a:	e84a                	sd	s2,16(sp)
    8000160c:	e44e                	sd	s3,8(sp)
    8000160e:	e052                	sd	s4,0(sp)
    80001610:	1800                	addi	s0,sp,48
    80001612:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001614:	00008497          	auipc	s1,0x8
    80001618:	8dc48493          	addi	s1,s1,-1828 # 80008ef0 <proc>
            pp->parent = initproc;
    8000161c:	00007a17          	auipc	s4,0x7
    80001620:	464a0a13          	addi	s4,s4,1124 # 80008a80 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001624:	0000d997          	auipc	s3,0xd
    80001628:	4cc98993          	addi	s3,s3,1228 # 8000eaf0 <tickslock>
    8000162c:	a029                	j	80001636 <reparent+0x34>
    8000162e:	17048493          	addi	s1,s1,368
    80001632:	01348d63          	beq	s1,s3,8000164c <reparent+0x4a>
        if (pp->parent == p) {
    80001636:	7c9c                	ld	a5,56(s1)
    80001638:	ff279be3          	bne	a5,s2,8000162e <reparent+0x2c>
            pp->parent = initproc;
    8000163c:	000a3503          	ld	a0,0(s4)
    80001640:	fc88                	sd	a0,56(s1)
            wakeup(initproc);
    80001642:	00000097          	auipc	ra,0x0
    80001646:	f4a080e7          	jalr	-182(ra) # 8000158c <wakeup>
    8000164a:	b7d5                	j	8000162e <reparent+0x2c>
}
    8000164c:	70a2                	ld	ra,40(sp)
    8000164e:	7402                	ld	s0,32(sp)
    80001650:	64e2                	ld	s1,24(sp)
    80001652:	6942                	ld	s2,16(sp)
    80001654:	69a2                	ld	s3,8(sp)
    80001656:	6a02                	ld	s4,0(sp)
    80001658:	6145                	addi	sp,sp,48
    8000165a:	8082                	ret

000000008000165c <exit>:
{
    8000165c:	7179                	addi	sp,sp,-48
    8000165e:	f406                	sd	ra,40(sp)
    80001660:	f022                	sd	s0,32(sp)
    80001662:	ec26                	sd	s1,24(sp)
    80001664:	e84a                	sd	s2,16(sp)
    80001666:	e44e                	sd	s3,8(sp)
    80001668:	e052                	sd	s4,0(sp)
    8000166a:	1800                	addi	s0,sp,48
    8000166c:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    8000166e:	00000097          	auipc	ra,0x0
    80001672:	80a080e7          	jalr	-2038(ra) # 80000e78 <myproc>
    80001676:	89aa                	mv	s3,a0
    if (p == initproc)
    80001678:	00007797          	auipc	a5,0x7
    8000167c:	4087b783          	ld	a5,1032(a5) # 80008a80 <initproc>
    80001680:	0d050493          	addi	s1,a0,208
    80001684:	15050913          	addi	s2,a0,336
    80001688:	02a79363          	bne	a5,a0,800016ae <exit+0x52>
        panic("init exiting");
    8000168c:	00007517          	auipc	a0,0x7
    80001690:	b5450513          	addi	a0,a0,-1196 # 800081e0 <etext+0x1e0>
    80001694:	00004097          	auipc	ra,0x4
    80001698:	618080e7          	jalr	1560(ra) # 80005cac <panic>
            fileclose(f);
    8000169c:	00002097          	auipc	ra,0x2
    800016a0:	3ee080e7          	jalr	1006(ra) # 80003a8a <fileclose>
            p->ofile[fd] = 0;
    800016a4:	0004b023          	sd	zero,0(s1)
    for (int fd = 0; fd < NOFILE; fd++) {
    800016a8:	04a1                	addi	s1,s1,8
    800016aa:	01248563          	beq	s1,s2,800016b4 <exit+0x58>
        if (p->ofile[fd]) {
    800016ae:	6088                	ld	a0,0(s1)
    800016b0:	f575                	bnez	a0,8000169c <exit+0x40>
    800016b2:	bfdd                	j	800016a8 <exit+0x4c>
    begin_op();
    800016b4:	00002097          	auipc	ra,0x2
    800016b8:	f0e080e7          	jalr	-242(ra) # 800035c2 <begin_op>
    iput(p->cwd);
    800016bc:	1509b503          	ld	a0,336(s3)
    800016c0:	00001097          	auipc	ra,0x1
    800016c4:	6f0080e7          	jalr	1776(ra) # 80002db0 <iput>
    end_op();
    800016c8:	00002097          	auipc	ra,0x2
    800016cc:	f78080e7          	jalr	-136(ra) # 80003640 <end_op>
    p->cwd = 0;
    800016d0:	1409b823          	sd	zero,336(s3)
    acquire(&wait_lock);
    800016d4:	00007497          	auipc	s1,0x7
    800016d8:	40448493          	addi	s1,s1,1028 # 80008ad8 <wait_lock>
    800016dc:	8526                	mv	a0,s1
    800016de:	00005097          	auipc	ra,0x5
    800016e2:	b06080e7          	jalr	-1274(ra) # 800061e4 <acquire>
    reparent(p);
    800016e6:	854e                	mv	a0,s3
    800016e8:	00000097          	auipc	ra,0x0
    800016ec:	f1a080e7          	jalr	-230(ra) # 80001602 <reparent>
    wakeup(p->parent);
    800016f0:	0389b503          	ld	a0,56(s3)
    800016f4:	00000097          	auipc	ra,0x0
    800016f8:	e98080e7          	jalr	-360(ra) # 8000158c <wakeup>
    acquire(&p->lock);
    800016fc:	854e                	mv	a0,s3
    800016fe:	00005097          	auipc	ra,0x5
    80001702:	ae6080e7          	jalr	-1306(ra) # 800061e4 <acquire>
    p->xstate = status;
    80001706:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    8000170a:	4795                	li	a5,5
    8000170c:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    80001710:	8526                	mv	a0,s1
    80001712:	00005097          	auipc	ra,0x5
    80001716:	b86080e7          	jalr	-1146(ra) # 80006298 <release>
    sched();
    8000171a:	00000097          	auipc	ra,0x0
    8000171e:	cfc080e7          	jalr	-772(ra) # 80001416 <sched>
    panic("zombie exit");
    80001722:	00007517          	auipc	a0,0x7
    80001726:	ace50513          	addi	a0,a0,-1330 # 800081f0 <etext+0x1f0>
    8000172a:	00004097          	auipc	ra,0x4
    8000172e:	582080e7          	jalr	1410(ra) # 80005cac <panic>

0000000080001732 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    80001732:	7179                	addi	sp,sp,-48
    80001734:	f406                	sd	ra,40(sp)
    80001736:	f022                	sd	s0,32(sp)
    80001738:	ec26                	sd	s1,24(sp)
    8000173a:	e84a                	sd	s2,16(sp)
    8000173c:	e44e                	sd	s3,8(sp)
    8000173e:	1800                	addi	s0,sp,48
    80001740:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++) {
    80001742:	00007497          	auipc	s1,0x7
    80001746:	7ae48493          	addi	s1,s1,1966 # 80008ef0 <proc>
    8000174a:	0000d997          	auipc	s3,0xd
    8000174e:	3a698993          	addi	s3,s3,934 # 8000eaf0 <tickslock>
        acquire(&p->lock);
    80001752:	8526                	mv	a0,s1
    80001754:	00005097          	auipc	ra,0x5
    80001758:	a90080e7          	jalr	-1392(ra) # 800061e4 <acquire>
        if (p->pid == pid) {
    8000175c:	589c                	lw	a5,48(s1)
    8000175e:	01278d63          	beq	a5,s2,80001778 <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    80001762:	8526                	mv	a0,s1
    80001764:	00005097          	auipc	ra,0x5
    80001768:	b34080e7          	jalr	-1228(ra) # 80006298 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    8000176c:	17048493          	addi	s1,s1,368
    80001770:	ff3491e3          	bne	s1,s3,80001752 <kill+0x20>
    }
    return -1;
    80001774:	557d                	li	a0,-1
    80001776:	a829                	j	80001790 <kill+0x5e>
            p->killed = 1;
    80001778:	4785                	li	a5,1
    8000177a:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING) {
    8000177c:	4c98                	lw	a4,24(s1)
    8000177e:	4789                	li	a5,2
    80001780:	00f70f63          	beq	a4,a5,8000179e <kill+0x6c>
            release(&p->lock);
    80001784:	8526                	mv	a0,s1
    80001786:	00005097          	auipc	ra,0x5
    8000178a:	b12080e7          	jalr	-1262(ra) # 80006298 <release>
            return 0;
    8000178e:	4501                	li	a0,0
}
    80001790:	70a2                	ld	ra,40(sp)
    80001792:	7402                	ld	s0,32(sp)
    80001794:	64e2                	ld	s1,24(sp)
    80001796:	6942                	ld	s2,16(sp)
    80001798:	69a2                	ld	s3,8(sp)
    8000179a:	6145                	addi	sp,sp,48
    8000179c:	8082                	ret
                p->state = RUNNABLE;
    8000179e:	478d                	li	a5,3
    800017a0:	cc9c                	sw	a5,24(s1)
    800017a2:	b7cd                	j	80001784 <kill+0x52>

00000000800017a4 <setkilled>:

void setkilled(struct proc *p)
{
    800017a4:	1101                	addi	sp,sp,-32
    800017a6:	ec06                	sd	ra,24(sp)
    800017a8:	e822                	sd	s0,16(sp)
    800017aa:	e426                	sd	s1,8(sp)
    800017ac:	1000                	addi	s0,sp,32
    800017ae:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800017b0:	00005097          	auipc	ra,0x5
    800017b4:	a34080e7          	jalr	-1484(ra) # 800061e4 <acquire>
    p->killed = 1;
    800017b8:	4785                	li	a5,1
    800017ba:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    800017bc:	8526                	mv	a0,s1
    800017be:	00005097          	auipc	ra,0x5
    800017c2:	ada080e7          	jalr	-1318(ra) # 80006298 <release>
}
    800017c6:	60e2                	ld	ra,24(sp)
    800017c8:	6442                	ld	s0,16(sp)
    800017ca:	64a2                	ld	s1,8(sp)
    800017cc:	6105                	addi	sp,sp,32
    800017ce:	8082                	ret

00000000800017d0 <killed>:

int killed(struct proc *p)
{
    800017d0:	1101                	addi	sp,sp,-32
    800017d2:	ec06                	sd	ra,24(sp)
    800017d4:	e822                	sd	s0,16(sp)
    800017d6:	e426                	sd	s1,8(sp)
    800017d8:	e04a                	sd	s2,0(sp)
    800017da:	1000                	addi	s0,sp,32
    800017dc:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    800017de:	00005097          	auipc	ra,0x5
    800017e2:	a06080e7          	jalr	-1530(ra) # 800061e4 <acquire>
    k = p->killed;
    800017e6:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    800017ea:	8526                	mv	a0,s1
    800017ec:	00005097          	auipc	ra,0x5
    800017f0:	aac080e7          	jalr	-1364(ra) # 80006298 <release>
    return k;
}
    800017f4:	854a                	mv	a0,s2
    800017f6:	60e2                	ld	ra,24(sp)
    800017f8:	6442                	ld	s0,16(sp)
    800017fa:	64a2                	ld	s1,8(sp)
    800017fc:	6902                	ld	s2,0(sp)
    800017fe:	6105                	addi	sp,sp,32
    80001800:	8082                	ret

0000000080001802 <wait>:
{
    80001802:	715d                	addi	sp,sp,-80
    80001804:	e486                	sd	ra,72(sp)
    80001806:	e0a2                	sd	s0,64(sp)
    80001808:	fc26                	sd	s1,56(sp)
    8000180a:	f84a                	sd	s2,48(sp)
    8000180c:	f44e                	sd	s3,40(sp)
    8000180e:	f052                	sd	s4,32(sp)
    80001810:	ec56                	sd	s5,24(sp)
    80001812:	e85a                	sd	s6,16(sp)
    80001814:	e45e                	sd	s7,8(sp)
    80001816:	e062                	sd	s8,0(sp)
    80001818:	0880                	addi	s0,sp,80
    8000181a:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    8000181c:	fffff097          	auipc	ra,0xfffff
    80001820:	65c080e7          	jalr	1628(ra) # 80000e78 <myproc>
    80001824:	892a                	mv	s2,a0
    acquire(&wait_lock);
    80001826:	00007517          	auipc	a0,0x7
    8000182a:	2b250513          	addi	a0,a0,690 # 80008ad8 <wait_lock>
    8000182e:	00005097          	auipc	ra,0x5
    80001832:	9b6080e7          	jalr	-1610(ra) # 800061e4 <acquire>
        havekids = 0;
    80001836:	4b81                	li	s7,0
                if (pp->state == ZOMBIE) {
    80001838:	4a15                	li	s4,5
                havekids = 1;
    8000183a:	4a85                	li	s5,1
        for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000183c:	0000d997          	auipc	s3,0xd
    80001840:	2b498993          	addi	s3,s3,692 # 8000eaf0 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    80001844:	00007c17          	auipc	s8,0x7
    80001848:	294c0c13          	addi	s8,s8,660 # 80008ad8 <wait_lock>
        havekids = 0;
    8000184c:	875e                	mv	a4,s7
        for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000184e:	00007497          	auipc	s1,0x7
    80001852:	6a248493          	addi	s1,s1,1698 # 80008ef0 <proc>
    80001856:	a0bd                	j	800018c4 <wait+0xc2>
                    pid = pp->pid;
    80001858:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate, sizeof(pp->xstate)) < 0) {
    8000185c:	000b0e63          	beqz	s6,80001878 <wait+0x76>
    80001860:	4691                	li	a3,4
    80001862:	02c48613          	addi	a2,s1,44
    80001866:	85da                	mv	a1,s6
    80001868:	05093503          	ld	a0,80(s2)
    8000186c:	fffff097          	auipc	ra,0xfffff
    80001870:	2cc080e7          	jalr	716(ra) # 80000b38 <copyout>
    80001874:	02054563          	bltz	a0,8000189e <wait+0x9c>
                    freeproc(pp);
    80001878:	8526                	mv	a0,s1
    8000187a:	fffff097          	auipc	ra,0xfffff
    8000187e:	7b0080e7          	jalr	1968(ra) # 8000102a <freeproc>
                    release(&pp->lock);
    80001882:	8526                	mv	a0,s1
    80001884:	00005097          	auipc	ra,0x5
    80001888:	a14080e7          	jalr	-1516(ra) # 80006298 <release>
                    release(&wait_lock);
    8000188c:	00007517          	auipc	a0,0x7
    80001890:	24c50513          	addi	a0,a0,588 # 80008ad8 <wait_lock>
    80001894:	00005097          	auipc	ra,0x5
    80001898:	a04080e7          	jalr	-1532(ra) # 80006298 <release>
                    return pid;
    8000189c:	a0b5                	j	80001908 <wait+0x106>
                        release(&pp->lock);
    8000189e:	8526                	mv	a0,s1
    800018a0:	00005097          	auipc	ra,0x5
    800018a4:	9f8080e7          	jalr	-1544(ra) # 80006298 <release>
                        release(&wait_lock);
    800018a8:	00007517          	auipc	a0,0x7
    800018ac:	23050513          	addi	a0,a0,560 # 80008ad8 <wait_lock>
    800018b0:	00005097          	auipc	ra,0x5
    800018b4:	9e8080e7          	jalr	-1560(ra) # 80006298 <release>
                        return -1;
    800018b8:	59fd                	li	s3,-1
    800018ba:	a0b9                	j	80001908 <wait+0x106>
        for (pp = proc; pp < &proc[NPROC]; pp++) {
    800018bc:	17048493          	addi	s1,s1,368
    800018c0:	03348463          	beq	s1,s3,800018e8 <wait+0xe6>
            if (pp->parent == p) {
    800018c4:	7c9c                	ld	a5,56(s1)
    800018c6:	ff279be3          	bne	a5,s2,800018bc <wait+0xba>
                acquire(&pp->lock);
    800018ca:	8526                	mv	a0,s1
    800018cc:	00005097          	auipc	ra,0x5
    800018d0:	918080e7          	jalr	-1768(ra) # 800061e4 <acquire>
                if (pp->state == ZOMBIE) {
    800018d4:	4c9c                	lw	a5,24(s1)
    800018d6:	f94781e3          	beq	a5,s4,80001858 <wait+0x56>
                release(&pp->lock);
    800018da:	8526                	mv	a0,s1
    800018dc:	00005097          	auipc	ra,0x5
    800018e0:	9bc080e7          	jalr	-1604(ra) # 80006298 <release>
                havekids = 1;
    800018e4:	8756                	mv	a4,s5
    800018e6:	bfd9                	j	800018bc <wait+0xba>
        if (!havekids || killed(p)) {
    800018e8:	c719                	beqz	a4,800018f6 <wait+0xf4>
    800018ea:	854a                	mv	a0,s2
    800018ec:	00000097          	auipc	ra,0x0
    800018f0:	ee4080e7          	jalr	-284(ra) # 800017d0 <killed>
    800018f4:	c51d                	beqz	a0,80001922 <wait+0x120>
            release(&wait_lock);
    800018f6:	00007517          	auipc	a0,0x7
    800018fa:	1e250513          	addi	a0,a0,482 # 80008ad8 <wait_lock>
    800018fe:	00005097          	auipc	ra,0x5
    80001902:	99a080e7          	jalr	-1638(ra) # 80006298 <release>
            return -1;
    80001906:	59fd                	li	s3,-1
}
    80001908:	854e                	mv	a0,s3
    8000190a:	60a6                	ld	ra,72(sp)
    8000190c:	6406                	ld	s0,64(sp)
    8000190e:	74e2                	ld	s1,56(sp)
    80001910:	7942                	ld	s2,48(sp)
    80001912:	79a2                	ld	s3,40(sp)
    80001914:	7a02                	ld	s4,32(sp)
    80001916:	6ae2                	ld	s5,24(sp)
    80001918:	6b42                	ld	s6,16(sp)
    8000191a:	6ba2                	ld	s7,8(sp)
    8000191c:	6c02                	ld	s8,0(sp)
    8000191e:	6161                	addi	sp,sp,80
    80001920:	8082                	ret
        sleep(p, &wait_lock); // DOC: wait-sleep
    80001922:	85e2                	mv	a1,s8
    80001924:	854a                	mv	a0,s2
    80001926:	00000097          	auipc	ra,0x0
    8000192a:	c02080e7          	jalr	-1022(ra) # 80001528 <sleep>
        havekids = 0;
    8000192e:	bf39                	j	8000184c <wait+0x4a>

0000000080001930 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001930:	7179                	addi	sp,sp,-48
    80001932:	f406                	sd	ra,40(sp)
    80001934:	f022                	sd	s0,32(sp)
    80001936:	ec26                	sd	s1,24(sp)
    80001938:	e84a                	sd	s2,16(sp)
    8000193a:	e44e                	sd	s3,8(sp)
    8000193c:	e052                	sd	s4,0(sp)
    8000193e:	1800                	addi	s0,sp,48
    80001940:	84aa                	mv	s1,a0
    80001942:	892e                	mv	s2,a1
    80001944:	89b2                	mv	s3,a2
    80001946:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80001948:	fffff097          	auipc	ra,0xfffff
    8000194c:	530080e7          	jalr	1328(ra) # 80000e78 <myproc>
    if (user_dst) {
    80001950:	c08d                	beqz	s1,80001972 <either_copyout+0x42>
        return copyout(p->pagetable, dst, src, len);
    80001952:	86d2                	mv	a3,s4
    80001954:	864e                	mv	a2,s3
    80001956:	85ca                	mv	a1,s2
    80001958:	6928                	ld	a0,80(a0)
    8000195a:	fffff097          	auipc	ra,0xfffff
    8000195e:	1de080e7          	jalr	478(ra) # 80000b38 <copyout>
    }
    else {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    80001962:	70a2                	ld	ra,40(sp)
    80001964:	7402                	ld	s0,32(sp)
    80001966:	64e2                	ld	s1,24(sp)
    80001968:	6942                	ld	s2,16(sp)
    8000196a:	69a2                	ld	s3,8(sp)
    8000196c:	6a02                	ld	s4,0(sp)
    8000196e:	6145                	addi	sp,sp,48
    80001970:	8082                	ret
        memmove((char *)dst, src, len);
    80001972:	000a061b          	sext.w	a2,s4
    80001976:	85ce                	mv	a1,s3
    80001978:	854a                	mv	a0,s2
    8000197a:	fffff097          	auipc	ra,0xfffff
    8000197e:	880080e7          	jalr	-1920(ra) # 800001fa <memmove>
        return 0;
    80001982:	8526                	mv	a0,s1
    80001984:	bff9                	j	80001962 <either_copyout+0x32>

0000000080001986 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001986:	7179                	addi	sp,sp,-48
    80001988:	f406                	sd	ra,40(sp)
    8000198a:	f022                	sd	s0,32(sp)
    8000198c:	ec26                	sd	s1,24(sp)
    8000198e:	e84a                	sd	s2,16(sp)
    80001990:	e44e                	sd	s3,8(sp)
    80001992:	e052                	sd	s4,0(sp)
    80001994:	1800                	addi	s0,sp,48
    80001996:	892a                	mv	s2,a0
    80001998:	84ae                	mv	s1,a1
    8000199a:	89b2                	mv	s3,a2
    8000199c:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    8000199e:	fffff097          	auipc	ra,0xfffff
    800019a2:	4da080e7          	jalr	1242(ra) # 80000e78 <myproc>
    if (user_src) {
    800019a6:	c08d                	beqz	s1,800019c8 <either_copyin+0x42>
        return copyin(p->pagetable, dst, src, len);
    800019a8:	86d2                	mv	a3,s4
    800019aa:	864e                	mv	a2,s3
    800019ac:	85ca                	mv	a1,s2
    800019ae:	6928                	ld	a0,80(a0)
    800019b0:	fffff097          	auipc	ra,0xfffff
    800019b4:	214080e7          	jalr	532(ra) # 80000bc4 <copyin>
    }
    else {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    800019b8:	70a2                	ld	ra,40(sp)
    800019ba:	7402                	ld	s0,32(sp)
    800019bc:	64e2                	ld	s1,24(sp)
    800019be:	6942                	ld	s2,16(sp)
    800019c0:	69a2                	ld	s3,8(sp)
    800019c2:	6a02                	ld	s4,0(sp)
    800019c4:	6145                	addi	sp,sp,48
    800019c6:	8082                	ret
        memmove(dst, (char *)src, len);
    800019c8:	000a061b          	sext.w	a2,s4
    800019cc:	85ce                	mv	a1,s3
    800019ce:	854a                	mv	a0,s2
    800019d0:	fffff097          	auipc	ra,0xfffff
    800019d4:	82a080e7          	jalr	-2006(ra) # 800001fa <memmove>
        return 0;
    800019d8:	8526                	mv	a0,s1
    800019da:	bff9                	j	800019b8 <either_copyin+0x32>

00000000800019dc <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    800019dc:	715d                	addi	sp,sp,-80
    800019de:	e486                	sd	ra,72(sp)
    800019e0:	e0a2                	sd	s0,64(sp)
    800019e2:	fc26                	sd	s1,56(sp)
    800019e4:	f84a                	sd	s2,48(sp)
    800019e6:	f44e                	sd	s3,40(sp)
    800019e8:	f052                	sd	s4,32(sp)
    800019ea:	ec56                	sd	s5,24(sp)
    800019ec:	e85a                	sd	s6,16(sp)
    800019ee:	e45e                	sd	s7,8(sp)
    800019f0:	0880                	addi	s0,sp,80
    static char *states[] = {[UNUSED] "unused", [USED] "used", [SLEEPING] "sleep ", [RUNNABLE] "runble", [RUNNING] "run   ", [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    800019f2:	00006517          	auipc	a0,0x6
    800019f6:	65650513          	addi	a0,a0,1622 # 80008048 <etext+0x48>
    800019fa:	00004097          	auipc	ra,0x4
    800019fe:	2fc080e7          	jalr	764(ra) # 80005cf6 <printf>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001a02:	00007497          	auipc	s1,0x7
    80001a06:	64648493          	addi	s1,s1,1606 # 80009048 <proc+0x158>
    80001a0a:	0000d917          	auipc	s2,0xd
    80001a0e:	23e90913          	addi	s2,s2,574 # 8000ec48 <bcache+0x140>
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a12:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    80001a14:	00006997          	auipc	s3,0x6
    80001a18:	7ec98993          	addi	s3,s3,2028 # 80008200 <etext+0x200>
        printf("%d %s %s", p->pid, state, p->name);
    80001a1c:	00006a97          	auipc	s5,0x6
    80001a20:	7eca8a93          	addi	s5,s5,2028 # 80008208 <etext+0x208>
        printf("\n");
    80001a24:	00006a17          	auipc	s4,0x6
    80001a28:	624a0a13          	addi	s4,s4,1572 # 80008048 <etext+0x48>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a2c:	00007b97          	auipc	s7,0x7
    80001a30:	81cb8b93          	addi	s7,s7,-2020 # 80008248 <states.0>
    80001a34:	a00d                	j	80001a56 <procdump+0x7a>
        printf("%d %s %s", p->pid, state, p->name);
    80001a36:	ed86a583          	lw	a1,-296(a3)
    80001a3a:	8556                	mv	a0,s5
    80001a3c:	00004097          	auipc	ra,0x4
    80001a40:	2ba080e7          	jalr	698(ra) # 80005cf6 <printf>
        printf("\n");
    80001a44:	8552                	mv	a0,s4
    80001a46:	00004097          	auipc	ra,0x4
    80001a4a:	2b0080e7          	jalr	688(ra) # 80005cf6 <printf>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001a4e:	17048493          	addi	s1,s1,368
    80001a52:	03248263          	beq	s1,s2,80001a76 <procdump+0x9a>
        if (p->state == UNUSED)
    80001a56:	86a6                	mv	a3,s1
    80001a58:	ec04a783          	lw	a5,-320(s1)
    80001a5c:	dbed                	beqz	a5,80001a4e <procdump+0x72>
            state = "???";
    80001a5e:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a60:	fcfb6be3          	bltu	s6,a5,80001a36 <procdump+0x5a>
    80001a64:	02079713          	slli	a4,a5,0x20
    80001a68:	01d75793          	srli	a5,a4,0x1d
    80001a6c:	97de                	add	a5,a5,s7
    80001a6e:	6390                	ld	a2,0(a5)
    80001a70:	f279                	bnez	a2,80001a36 <procdump+0x5a>
            state = "???";
    80001a72:	864e                	mv	a2,s3
    80001a74:	b7c9                	j	80001a36 <procdump+0x5a>
    }
}
    80001a76:	60a6                	ld	ra,72(sp)
    80001a78:	6406                	ld	s0,64(sp)
    80001a7a:	74e2                	ld	s1,56(sp)
    80001a7c:	7942                	ld	s2,48(sp)
    80001a7e:	79a2                	ld	s3,40(sp)
    80001a80:	7a02                	ld	s4,32(sp)
    80001a82:	6ae2                	ld	s5,24(sp)
    80001a84:	6b42                	ld	s6,16(sp)
    80001a86:	6ba2                	ld	s7,8(sp)
    80001a88:	6161                	addi	sp,sp,80
    80001a8a:	8082                	ret

0000000080001a8c <countProc>:

uint64 countProc()
{
    80001a8c:	1141                	addi	sp,sp,-16
    80001a8e:	e422                	sd	s0,8(sp)
    80001a90:	0800                	addi	s0,sp,16
    uint64 count = 0;
    for (int i = 0; i < NPROC; i++) {
    80001a92:	00007797          	auipc	a5,0x7
    80001a96:	47678793          	addi	a5,a5,1142 # 80008f08 <proc+0x18>
    80001a9a:	0000d697          	auipc	a3,0xd
    80001a9e:	06e68693          	addi	a3,a3,110 # 8000eb08 <bcache>
    uint64 count = 0;
    80001aa2:	4501                	li	a0,0
        if (proc[i].state != UNUSED)
    80001aa4:	4398                	lw	a4,0(a5)
            count++;
    80001aa6:	00e03733          	snez	a4,a4
    80001aaa:	953a                	add	a0,a0,a4
    for (int i = 0; i < NPROC; i++) {
    80001aac:	17078793          	addi	a5,a5,368
    80001ab0:	fed79ae3          	bne	a5,a3,80001aa4 <countProc+0x18>
    }
    return count;
    80001ab4:	6422                	ld	s0,8(sp)
    80001ab6:	0141                	addi	sp,sp,16
    80001ab8:	8082                	ret

0000000080001aba <swtch>:
    80001aba:	00153023          	sd	ra,0(a0)
    80001abe:	00253423          	sd	sp,8(a0)
    80001ac2:	e900                	sd	s0,16(a0)
    80001ac4:	ed04                	sd	s1,24(a0)
    80001ac6:	03253023          	sd	s2,32(a0)
    80001aca:	03353423          	sd	s3,40(a0)
    80001ace:	03453823          	sd	s4,48(a0)
    80001ad2:	03553c23          	sd	s5,56(a0)
    80001ad6:	05653023          	sd	s6,64(a0)
    80001ada:	05753423          	sd	s7,72(a0)
    80001ade:	05853823          	sd	s8,80(a0)
    80001ae2:	05953c23          	sd	s9,88(a0)
    80001ae6:	07a53023          	sd	s10,96(a0)
    80001aea:	07b53423          	sd	s11,104(a0)
    80001aee:	0005b083          	ld	ra,0(a1)
    80001af2:	0085b103          	ld	sp,8(a1)
    80001af6:	6980                	ld	s0,16(a1)
    80001af8:	6d84                	ld	s1,24(a1)
    80001afa:	0205b903          	ld	s2,32(a1)
    80001afe:	0285b983          	ld	s3,40(a1)
    80001b02:	0305ba03          	ld	s4,48(a1)
    80001b06:	0385ba83          	ld	s5,56(a1)
    80001b0a:	0405bb03          	ld	s6,64(a1)
    80001b0e:	0485bb83          	ld	s7,72(a1)
    80001b12:	0505bc03          	ld	s8,80(a1)
    80001b16:	0585bc83          	ld	s9,88(a1)
    80001b1a:	0605bd03          	ld	s10,96(a1)
    80001b1e:	0685bd83          	ld	s11,104(a1)
    80001b22:	8082                	ret

0000000080001b24 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b24:	1141                	addi	sp,sp,-16
    80001b26:	e406                	sd	ra,8(sp)
    80001b28:	e022                	sd	s0,0(sp)
    80001b2a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b2c:	00006597          	auipc	a1,0x6
    80001b30:	74c58593          	addi	a1,a1,1868 # 80008278 <states.0+0x30>
    80001b34:	0000d517          	auipc	a0,0xd
    80001b38:	fbc50513          	addi	a0,a0,-68 # 8000eaf0 <tickslock>
    80001b3c:	00004097          	auipc	ra,0x4
    80001b40:	618080e7          	jalr	1560(ra) # 80006154 <initlock>
}
    80001b44:	60a2                	ld	ra,8(sp)
    80001b46:	6402                	ld	s0,0(sp)
    80001b48:	0141                	addi	sp,sp,16
    80001b4a:	8082                	ret

0000000080001b4c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b4c:	1141                	addi	sp,sp,-16
    80001b4e:	e422                	sd	s0,8(sp)
    80001b50:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b52:	00003797          	auipc	a5,0x3
    80001b56:	58e78793          	addi	a5,a5,1422 # 800050e0 <kernelvec>
    80001b5a:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b5e:	6422                	ld	s0,8(sp)
    80001b60:	0141                	addi	sp,sp,16
    80001b62:	8082                	ret

0000000080001b64 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b64:	1141                	addi	sp,sp,-16
    80001b66:	e406                	sd	ra,8(sp)
    80001b68:	e022                	sd	s0,0(sp)
    80001b6a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b6c:	fffff097          	auipc	ra,0xfffff
    80001b70:	30c080e7          	jalr	780(ra) # 80000e78 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b74:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b78:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b7a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b7e:	00005697          	auipc	a3,0x5
    80001b82:	48268693          	addi	a3,a3,1154 # 80007000 <_trampoline>
    80001b86:	00005717          	auipc	a4,0x5
    80001b8a:	47a70713          	addi	a4,a4,1146 # 80007000 <_trampoline>
    80001b8e:	8f15                	sub	a4,a4,a3
    80001b90:	040007b7          	lui	a5,0x4000
    80001b94:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b96:	07b2                	slli	a5,a5,0xc
    80001b98:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b9a:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b9e:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001ba0:	18002673          	csrr	a2,satp
    80001ba4:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001ba6:	6d30                	ld	a2,88(a0)
    80001ba8:	6138                	ld	a4,64(a0)
    80001baa:	6585                	lui	a1,0x1
    80001bac:	972e                	add	a4,a4,a1
    80001bae:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bb0:	6d38                	ld	a4,88(a0)
    80001bb2:	00000617          	auipc	a2,0x0
    80001bb6:	13060613          	addi	a2,a2,304 # 80001ce2 <usertrap>
    80001bba:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bbc:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bbe:	8612                	mv	a2,tp
    80001bc0:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bc2:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bc6:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bca:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bce:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bd2:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bd4:	6f18                	ld	a4,24(a4)
    80001bd6:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bda:	6928                	ld	a0,80(a0)
    80001bdc:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001bde:	00005717          	auipc	a4,0x5
    80001be2:	4be70713          	addi	a4,a4,1214 # 8000709c <userret>
    80001be6:	8f15                	sub	a4,a4,a3
    80001be8:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001bea:	577d                	li	a4,-1
    80001bec:	177e                	slli	a4,a4,0x3f
    80001bee:	8d59                	or	a0,a0,a4
    80001bf0:	9782                	jalr	a5
}
    80001bf2:	60a2                	ld	ra,8(sp)
    80001bf4:	6402                	ld	s0,0(sp)
    80001bf6:	0141                	addi	sp,sp,16
    80001bf8:	8082                	ret

0000000080001bfa <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bfa:	1101                	addi	sp,sp,-32
    80001bfc:	ec06                	sd	ra,24(sp)
    80001bfe:	e822                	sd	s0,16(sp)
    80001c00:	e426                	sd	s1,8(sp)
    80001c02:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c04:	0000d497          	auipc	s1,0xd
    80001c08:	eec48493          	addi	s1,s1,-276 # 8000eaf0 <tickslock>
    80001c0c:	8526                	mv	a0,s1
    80001c0e:	00004097          	auipc	ra,0x4
    80001c12:	5d6080e7          	jalr	1494(ra) # 800061e4 <acquire>
  ticks++;
    80001c16:	00007517          	auipc	a0,0x7
    80001c1a:	e7250513          	addi	a0,a0,-398 # 80008a88 <ticks>
    80001c1e:	411c                	lw	a5,0(a0)
    80001c20:	2785                	addiw	a5,a5,1
    80001c22:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c24:	00000097          	auipc	ra,0x0
    80001c28:	968080e7          	jalr	-1688(ra) # 8000158c <wakeup>
  release(&tickslock);
    80001c2c:	8526                	mv	a0,s1
    80001c2e:	00004097          	auipc	ra,0x4
    80001c32:	66a080e7          	jalr	1642(ra) # 80006298 <release>
}
    80001c36:	60e2                	ld	ra,24(sp)
    80001c38:	6442                	ld	s0,16(sp)
    80001c3a:	64a2                	ld	s1,8(sp)
    80001c3c:	6105                	addi	sp,sp,32
    80001c3e:	8082                	ret

0000000080001c40 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c40:	1101                	addi	sp,sp,-32
    80001c42:	ec06                	sd	ra,24(sp)
    80001c44:	e822                	sd	s0,16(sp)
    80001c46:	e426                	sd	s1,8(sp)
    80001c48:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c4a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c4e:	00074d63          	bltz	a4,80001c68 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c52:	57fd                	li	a5,-1
    80001c54:	17fe                	slli	a5,a5,0x3f
    80001c56:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c58:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c5a:	06f70363          	beq	a4,a5,80001cc0 <devintr+0x80>
  }
}
    80001c5e:	60e2                	ld	ra,24(sp)
    80001c60:	6442                	ld	s0,16(sp)
    80001c62:	64a2                	ld	s1,8(sp)
    80001c64:	6105                	addi	sp,sp,32
    80001c66:	8082                	ret
     (scause & 0xff) == 9){
    80001c68:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001c6c:	46a5                	li	a3,9
    80001c6e:	fed792e3          	bne	a5,a3,80001c52 <devintr+0x12>
    int irq = plic_claim();
    80001c72:	00003097          	auipc	ra,0x3
    80001c76:	576080e7          	jalr	1398(ra) # 800051e8 <plic_claim>
    80001c7a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c7c:	47a9                	li	a5,10
    80001c7e:	02f50763          	beq	a0,a5,80001cac <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c82:	4785                	li	a5,1
    80001c84:	02f50963          	beq	a0,a5,80001cb6 <devintr+0x76>
    return 1;
    80001c88:	4505                	li	a0,1
    } else if(irq){
    80001c8a:	d8f1                	beqz	s1,80001c5e <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c8c:	85a6                	mv	a1,s1
    80001c8e:	00006517          	auipc	a0,0x6
    80001c92:	5f250513          	addi	a0,a0,1522 # 80008280 <states.0+0x38>
    80001c96:	00004097          	auipc	ra,0x4
    80001c9a:	060080e7          	jalr	96(ra) # 80005cf6 <printf>
      plic_complete(irq);
    80001c9e:	8526                	mv	a0,s1
    80001ca0:	00003097          	auipc	ra,0x3
    80001ca4:	56c080e7          	jalr	1388(ra) # 8000520c <plic_complete>
    return 1;
    80001ca8:	4505                	li	a0,1
    80001caa:	bf55                	j	80001c5e <devintr+0x1e>
      uartintr();
    80001cac:	00004097          	auipc	ra,0x4
    80001cb0:	458080e7          	jalr	1112(ra) # 80006104 <uartintr>
    80001cb4:	b7ed                	j	80001c9e <devintr+0x5e>
      virtio_disk_intr();
    80001cb6:	00004097          	auipc	ra,0x4
    80001cba:	a1e080e7          	jalr	-1506(ra) # 800056d4 <virtio_disk_intr>
    80001cbe:	b7c5                	j	80001c9e <devintr+0x5e>
    if(cpuid() == 0){
    80001cc0:	fffff097          	auipc	ra,0xfffff
    80001cc4:	18c080e7          	jalr	396(ra) # 80000e4c <cpuid>
    80001cc8:	c901                	beqz	a0,80001cd8 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cca:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cce:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cd0:	14479073          	csrw	sip,a5
    return 2;
    80001cd4:	4509                	li	a0,2
    80001cd6:	b761                	j	80001c5e <devintr+0x1e>
      clockintr();
    80001cd8:	00000097          	auipc	ra,0x0
    80001cdc:	f22080e7          	jalr	-222(ra) # 80001bfa <clockintr>
    80001ce0:	b7ed                	j	80001cca <devintr+0x8a>

0000000080001ce2 <usertrap>:
{
    80001ce2:	1101                	addi	sp,sp,-32
    80001ce4:	ec06                	sd	ra,24(sp)
    80001ce6:	e822                	sd	s0,16(sp)
    80001ce8:	e426                	sd	s1,8(sp)
    80001cea:	e04a                	sd	s2,0(sp)
    80001cec:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cee:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cf2:	1007f793          	andi	a5,a5,256
    80001cf6:	e3b1                	bnez	a5,80001d3a <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cf8:	00003797          	auipc	a5,0x3
    80001cfc:	3e878793          	addi	a5,a5,1000 # 800050e0 <kernelvec>
    80001d00:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d04:	fffff097          	auipc	ra,0xfffff
    80001d08:	174080e7          	jalr	372(ra) # 80000e78 <myproc>
    80001d0c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d0e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d10:	14102773          	csrr	a4,sepc
    80001d14:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d16:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d1a:	47a1                	li	a5,8
    80001d1c:	02f70763          	beq	a4,a5,80001d4a <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001d20:	00000097          	auipc	ra,0x0
    80001d24:	f20080e7          	jalr	-224(ra) # 80001c40 <devintr>
    80001d28:	892a                	mv	s2,a0
    80001d2a:	c151                	beqz	a0,80001dae <usertrap+0xcc>
  if(killed(p))
    80001d2c:	8526                	mv	a0,s1
    80001d2e:	00000097          	auipc	ra,0x0
    80001d32:	aa2080e7          	jalr	-1374(ra) # 800017d0 <killed>
    80001d36:	c929                	beqz	a0,80001d88 <usertrap+0xa6>
    80001d38:	a099                	j	80001d7e <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001d3a:	00006517          	auipc	a0,0x6
    80001d3e:	56650513          	addi	a0,a0,1382 # 800082a0 <states.0+0x58>
    80001d42:	00004097          	auipc	ra,0x4
    80001d46:	f6a080e7          	jalr	-150(ra) # 80005cac <panic>
    if(killed(p))
    80001d4a:	00000097          	auipc	ra,0x0
    80001d4e:	a86080e7          	jalr	-1402(ra) # 800017d0 <killed>
    80001d52:	e921                	bnez	a0,80001da2 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001d54:	6cb8                	ld	a4,88(s1)
    80001d56:	6f1c                	ld	a5,24(a4)
    80001d58:	0791                	addi	a5,a5,4
    80001d5a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d5c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d60:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d64:	10079073          	csrw	sstatus,a5
    syscall();
    80001d68:	00000097          	auipc	ra,0x0
    80001d6c:	2d4080e7          	jalr	724(ra) # 8000203c <syscall>
  if(killed(p))
    80001d70:	8526                	mv	a0,s1
    80001d72:	00000097          	auipc	ra,0x0
    80001d76:	a5e080e7          	jalr	-1442(ra) # 800017d0 <killed>
    80001d7a:	c911                	beqz	a0,80001d8e <usertrap+0xac>
    80001d7c:	4901                	li	s2,0
    exit(-1);
    80001d7e:	557d                	li	a0,-1
    80001d80:	00000097          	auipc	ra,0x0
    80001d84:	8dc080e7          	jalr	-1828(ra) # 8000165c <exit>
  if(which_dev == 2)
    80001d88:	4789                	li	a5,2
    80001d8a:	04f90f63          	beq	s2,a5,80001de8 <usertrap+0x106>
  usertrapret();
    80001d8e:	00000097          	auipc	ra,0x0
    80001d92:	dd6080e7          	jalr	-554(ra) # 80001b64 <usertrapret>
}
    80001d96:	60e2                	ld	ra,24(sp)
    80001d98:	6442                	ld	s0,16(sp)
    80001d9a:	64a2                	ld	s1,8(sp)
    80001d9c:	6902                	ld	s2,0(sp)
    80001d9e:	6105                	addi	sp,sp,32
    80001da0:	8082                	ret
      exit(-1);
    80001da2:	557d                	li	a0,-1
    80001da4:	00000097          	auipc	ra,0x0
    80001da8:	8b8080e7          	jalr	-1864(ra) # 8000165c <exit>
    80001dac:	b765                	j	80001d54 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dae:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001db2:	5890                	lw	a2,48(s1)
    80001db4:	00006517          	auipc	a0,0x6
    80001db8:	50c50513          	addi	a0,a0,1292 # 800082c0 <states.0+0x78>
    80001dbc:	00004097          	auipc	ra,0x4
    80001dc0:	f3a080e7          	jalr	-198(ra) # 80005cf6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dc4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dc8:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dcc:	00006517          	auipc	a0,0x6
    80001dd0:	52450513          	addi	a0,a0,1316 # 800082f0 <states.0+0xa8>
    80001dd4:	00004097          	auipc	ra,0x4
    80001dd8:	f22080e7          	jalr	-222(ra) # 80005cf6 <printf>
    setkilled(p);
    80001ddc:	8526                	mv	a0,s1
    80001dde:	00000097          	auipc	ra,0x0
    80001de2:	9c6080e7          	jalr	-1594(ra) # 800017a4 <setkilled>
    80001de6:	b769                	j	80001d70 <usertrap+0x8e>
    yield();
    80001de8:	fffff097          	auipc	ra,0xfffff
    80001dec:	704080e7          	jalr	1796(ra) # 800014ec <yield>
    80001df0:	bf79                	j	80001d8e <usertrap+0xac>

0000000080001df2 <kerneltrap>:
{
    80001df2:	7179                	addi	sp,sp,-48
    80001df4:	f406                	sd	ra,40(sp)
    80001df6:	f022                	sd	s0,32(sp)
    80001df8:	ec26                	sd	s1,24(sp)
    80001dfa:	e84a                	sd	s2,16(sp)
    80001dfc:	e44e                	sd	s3,8(sp)
    80001dfe:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e00:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e04:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e08:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e0c:	1004f793          	andi	a5,s1,256
    80001e10:	cb85                	beqz	a5,80001e40 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e12:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e16:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e18:	ef85                	bnez	a5,80001e50 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e1a:	00000097          	auipc	ra,0x0
    80001e1e:	e26080e7          	jalr	-474(ra) # 80001c40 <devintr>
    80001e22:	cd1d                	beqz	a0,80001e60 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e24:	4789                	li	a5,2
    80001e26:	06f50a63          	beq	a0,a5,80001e9a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e2a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e2e:	10049073          	csrw	sstatus,s1
}
    80001e32:	70a2                	ld	ra,40(sp)
    80001e34:	7402                	ld	s0,32(sp)
    80001e36:	64e2                	ld	s1,24(sp)
    80001e38:	6942                	ld	s2,16(sp)
    80001e3a:	69a2                	ld	s3,8(sp)
    80001e3c:	6145                	addi	sp,sp,48
    80001e3e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e40:	00006517          	auipc	a0,0x6
    80001e44:	4d050513          	addi	a0,a0,1232 # 80008310 <states.0+0xc8>
    80001e48:	00004097          	auipc	ra,0x4
    80001e4c:	e64080e7          	jalr	-412(ra) # 80005cac <panic>
    panic("kerneltrap: interrupts enabled");
    80001e50:	00006517          	auipc	a0,0x6
    80001e54:	4e850513          	addi	a0,a0,1256 # 80008338 <states.0+0xf0>
    80001e58:	00004097          	auipc	ra,0x4
    80001e5c:	e54080e7          	jalr	-428(ra) # 80005cac <panic>
    printf("scause %p\n", scause);
    80001e60:	85ce                	mv	a1,s3
    80001e62:	00006517          	auipc	a0,0x6
    80001e66:	4f650513          	addi	a0,a0,1270 # 80008358 <states.0+0x110>
    80001e6a:	00004097          	auipc	ra,0x4
    80001e6e:	e8c080e7          	jalr	-372(ra) # 80005cf6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e72:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e76:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e7a:	00006517          	auipc	a0,0x6
    80001e7e:	4ee50513          	addi	a0,a0,1262 # 80008368 <states.0+0x120>
    80001e82:	00004097          	auipc	ra,0x4
    80001e86:	e74080e7          	jalr	-396(ra) # 80005cf6 <printf>
    panic("kerneltrap");
    80001e8a:	00006517          	auipc	a0,0x6
    80001e8e:	4f650513          	addi	a0,a0,1270 # 80008380 <states.0+0x138>
    80001e92:	00004097          	auipc	ra,0x4
    80001e96:	e1a080e7          	jalr	-486(ra) # 80005cac <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e9a:	fffff097          	auipc	ra,0xfffff
    80001e9e:	fde080e7          	jalr	-34(ra) # 80000e78 <myproc>
    80001ea2:	d541                	beqz	a0,80001e2a <kerneltrap+0x38>
    80001ea4:	fffff097          	auipc	ra,0xfffff
    80001ea8:	fd4080e7          	jalr	-44(ra) # 80000e78 <myproc>
    80001eac:	4d18                	lw	a4,24(a0)
    80001eae:	4791                	li	a5,4
    80001eb0:	f6f71de3          	bne	a4,a5,80001e2a <kerneltrap+0x38>
    yield();
    80001eb4:	fffff097          	auipc	ra,0xfffff
    80001eb8:	638080e7          	jalr	1592(ra) # 800014ec <yield>
    80001ebc:	b7bd                	j	80001e2a <kerneltrap+0x38>

0000000080001ebe <argraw>:
        return -1;
    return strlen(buf);
}

static uint64 argraw(int n)
{
    80001ebe:	1101                	addi	sp,sp,-32
    80001ec0:	ec06                	sd	ra,24(sp)
    80001ec2:	e822                	sd	s0,16(sp)
    80001ec4:	e426                	sd	s1,8(sp)
    80001ec6:	1000                	addi	s0,sp,32
    80001ec8:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80001eca:	fffff097          	auipc	ra,0xfffff
    80001ece:	fae080e7          	jalr	-82(ra) # 80000e78 <myproc>
    switch (n) {
    80001ed2:	4795                	li	a5,5
    80001ed4:	0497e163          	bltu	a5,s1,80001f16 <argraw+0x58>
    80001ed8:	048a                	slli	s1,s1,0x2
    80001eda:	00006717          	auipc	a4,0x6
    80001ede:	5a670713          	addi	a4,a4,1446 # 80008480 <states.0+0x238>
    80001ee2:	94ba                	add	s1,s1,a4
    80001ee4:	409c                	lw	a5,0(s1)
    80001ee6:	97ba                	add	a5,a5,a4
    80001ee8:	8782                	jr	a5
    case 0:
        return p->trapframe->a0;
    80001eea:	6d3c                	ld	a5,88(a0)
    80001eec:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80001eee:	60e2                	ld	ra,24(sp)
    80001ef0:	6442                	ld	s0,16(sp)
    80001ef2:	64a2                	ld	s1,8(sp)
    80001ef4:	6105                	addi	sp,sp,32
    80001ef6:	8082                	ret
        return p->trapframe->a1;
    80001ef8:	6d3c                	ld	a5,88(a0)
    80001efa:	7fa8                	ld	a0,120(a5)
    80001efc:	bfcd                	j	80001eee <argraw+0x30>
        return p->trapframe->a2;
    80001efe:	6d3c                	ld	a5,88(a0)
    80001f00:	63c8                	ld	a0,128(a5)
    80001f02:	b7f5                	j	80001eee <argraw+0x30>
        return p->trapframe->a3;
    80001f04:	6d3c                	ld	a5,88(a0)
    80001f06:	67c8                	ld	a0,136(a5)
    80001f08:	b7dd                	j	80001eee <argraw+0x30>
        return p->trapframe->a4;
    80001f0a:	6d3c                	ld	a5,88(a0)
    80001f0c:	6bc8                	ld	a0,144(a5)
    80001f0e:	b7c5                	j	80001eee <argraw+0x30>
        return p->trapframe->a5;
    80001f10:	6d3c                	ld	a5,88(a0)
    80001f12:	6fc8                	ld	a0,152(a5)
    80001f14:	bfe9                	j	80001eee <argraw+0x30>
    panic("argraw");
    80001f16:	00006517          	auipc	a0,0x6
    80001f1a:	47a50513          	addi	a0,a0,1146 # 80008390 <states.0+0x148>
    80001f1e:	00004097          	auipc	ra,0x4
    80001f22:	d8e080e7          	jalr	-626(ra) # 80005cac <panic>

0000000080001f26 <fetchaddr>:
{
    80001f26:	1101                	addi	sp,sp,-32
    80001f28:	ec06                	sd	ra,24(sp)
    80001f2a:	e822                	sd	s0,16(sp)
    80001f2c:	e426                	sd	s1,8(sp)
    80001f2e:	e04a                	sd	s2,0(sp)
    80001f30:	1000                	addi	s0,sp,32
    80001f32:	84aa                	mv	s1,a0
    80001f34:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80001f36:	fffff097          	auipc	ra,0xfffff
    80001f3a:	f42080e7          	jalr	-190(ra) # 80000e78 <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001f3e:	653c                	ld	a5,72(a0)
    80001f40:	02f4f863          	bgeu	s1,a5,80001f70 <fetchaddr+0x4a>
    80001f44:	00848713          	addi	a4,s1,8
    80001f48:	02e7e663          	bltu	a5,a4,80001f74 <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f4c:	46a1                	li	a3,8
    80001f4e:	8626                	mv	a2,s1
    80001f50:	85ca                	mv	a1,s2
    80001f52:	6928                	ld	a0,80(a0)
    80001f54:	fffff097          	auipc	ra,0xfffff
    80001f58:	c70080e7          	jalr	-912(ra) # 80000bc4 <copyin>
    80001f5c:	00a03533          	snez	a0,a0
    80001f60:	40a00533          	neg	a0,a0
}
    80001f64:	60e2                	ld	ra,24(sp)
    80001f66:	6442                	ld	s0,16(sp)
    80001f68:	64a2                	ld	s1,8(sp)
    80001f6a:	6902                	ld	s2,0(sp)
    80001f6c:	6105                	addi	sp,sp,32
    80001f6e:	8082                	ret
        return -1;
    80001f70:	557d                	li	a0,-1
    80001f72:	bfcd                	j	80001f64 <fetchaddr+0x3e>
    80001f74:	557d                	li	a0,-1
    80001f76:	b7fd                	j	80001f64 <fetchaddr+0x3e>

0000000080001f78 <fetchstr>:
{
    80001f78:	7179                	addi	sp,sp,-48
    80001f7a:	f406                	sd	ra,40(sp)
    80001f7c:	f022                	sd	s0,32(sp)
    80001f7e:	ec26                	sd	s1,24(sp)
    80001f80:	e84a                	sd	s2,16(sp)
    80001f82:	e44e                	sd	s3,8(sp)
    80001f84:	1800                	addi	s0,sp,48
    80001f86:	892a                	mv	s2,a0
    80001f88:	84ae                	mv	s1,a1
    80001f8a:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    80001f8c:	fffff097          	auipc	ra,0xfffff
    80001f90:	eec080e7          	jalr	-276(ra) # 80000e78 <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80001f94:	86ce                	mv	a3,s3
    80001f96:	864a                	mv	a2,s2
    80001f98:	85a6                	mv	a1,s1
    80001f9a:	6928                	ld	a0,80(a0)
    80001f9c:	fffff097          	auipc	ra,0xfffff
    80001fa0:	cb6080e7          	jalr	-842(ra) # 80000c52 <copyinstr>
    80001fa4:	00054e63          	bltz	a0,80001fc0 <fetchstr+0x48>
    return strlen(buf);
    80001fa8:	8526                	mv	a0,s1
    80001faa:	ffffe097          	auipc	ra,0xffffe
    80001fae:	370080e7          	jalr	880(ra) # 8000031a <strlen>
}
    80001fb2:	70a2                	ld	ra,40(sp)
    80001fb4:	7402                	ld	s0,32(sp)
    80001fb6:	64e2                	ld	s1,24(sp)
    80001fb8:	6942                	ld	s2,16(sp)
    80001fba:	69a2                	ld	s3,8(sp)
    80001fbc:	6145                	addi	sp,sp,48
    80001fbe:	8082                	ret
        return -1;
    80001fc0:	557d                	li	a0,-1
    80001fc2:	bfc5                	j	80001fb2 <fetchstr+0x3a>

0000000080001fc4 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    80001fc4:	1101                	addi	sp,sp,-32
    80001fc6:	ec06                	sd	ra,24(sp)
    80001fc8:	e822                	sd	s0,16(sp)
    80001fca:	e426                	sd	s1,8(sp)
    80001fcc:	1000                	addi	s0,sp,32
    80001fce:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80001fd0:	00000097          	auipc	ra,0x0
    80001fd4:	eee080e7          	jalr	-274(ra) # 80001ebe <argraw>
    80001fd8:	c088                	sw	a0,0(s1)
}
    80001fda:	60e2                	ld	ra,24(sp)
    80001fdc:	6442                	ld	s0,16(sp)
    80001fde:	64a2                	ld	s1,8(sp)
    80001fe0:	6105                	addi	sp,sp,32
    80001fe2:	8082                	ret

0000000080001fe4 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    80001fe4:	1101                	addi	sp,sp,-32
    80001fe6:	ec06                	sd	ra,24(sp)
    80001fe8:	e822                	sd	s0,16(sp)
    80001fea:	e426                	sd	s1,8(sp)
    80001fec:	1000                	addi	s0,sp,32
    80001fee:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80001ff0:	00000097          	auipc	ra,0x0
    80001ff4:	ece080e7          	jalr	-306(ra) # 80001ebe <argraw>
    80001ff8:	e088                	sd	a0,0(s1)
}
    80001ffa:	60e2                	ld	ra,24(sp)
    80001ffc:	6442                	ld	s0,16(sp)
    80001ffe:	64a2                	ld	s1,8(sp)
    80002000:	6105                	addi	sp,sp,32
    80002002:	8082                	ret

0000000080002004 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    80002004:	7179                	addi	sp,sp,-48
    80002006:	f406                	sd	ra,40(sp)
    80002008:	f022                	sd	s0,32(sp)
    8000200a:	ec26                	sd	s1,24(sp)
    8000200c:	e84a                	sd	s2,16(sp)
    8000200e:	1800                	addi	s0,sp,48
    80002010:	84ae                	mv	s1,a1
    80002012:	8932                	mv	s2,a2
    uint64 addr;
    argaddr(n, &addr);
    80002014:	fd840593          	addi	a1,s0,-40
    80002018:	00000097          	auipc	ra,0x0
    8000201c:	fcc080e7          	jalr	-52(ra) # 80001fe4 <argaddr>
    return fetchstr(addr, buf, max);
    80002020:	864a                	mv	a2,s2
    80002022:	85a6                	mv	a1,s1
    80002024:	fd843503          	ld	a0,-40(s0)
    80002028:	00000097          	auipc	ra,0x0
    8000202c:	f50080e7          	jalr	-176(ra) # 80001f78 <fetchstr>
}
    80002030:	70a2                	ld	ra,40(sp)
    80002032:	7402                	ld	s0,32(sp)
    80002034:	64e2                	ld	s1,24(sp)
    80002036:	6942                	ld	s2,16(sp)
    80002038:	6145                	addi	sp,sp,48
    8000203a:	8082                	ret

000000008000203c <syscall>:
    "",     "fork",  "exit",   "wait", "pipe",  "read",  "kill",   "exec", "fstat", "chdir", "dup",   "getpid",
    "sbrk", "sleep", "uptime", "open", "write", "mknod", "unlink", "link", "mkdir", "close", "trace", "sysinfo",
};

void syscall(void)
{
    8000203c:	7179                	addi	sp,sp,-48
    8000203e:	f406                	sd	ra,40(sp)
    80002040:	f022                	sd	s0,32(sp)
    80002042:	ec26                	sd	s1,24(sp)
    80002044:	e84a                	sd	s2,16(sp)
    80002046:	e44e                	sd	s3,8(sp)
    80002048:	1800                	addi	s0,sp,48
    int num;
    struct proc *p = myproc();
    8000204a:	fffff097          	auipc	ra,0xfffff
    8000204e:	e2e080e7          	jalr	-466(ra) # 80000e78 <myproc>
    80002052:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    80002054:	05853903          	ld	s2,88(a0)
    80002058:	0a893783          	ld	a5,168(s2)
    8000205c:	0007899b          	sext.w	s3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002060:	37fd                	addiw	a5,a5,-1
    80002062:	4759                	li	a4,22
    80002064:	04f76763          	bltu	a4,a5,800020b2 <syscall+0x76>
    80002068:	00399713          	slli	a4,s3,0x3
    8000206c:	00006797          	auipc	a5,0x6
    80002070:	42c78793          	addi	a5,a5,1068 # 80008498 <syscalls>
    80002074:	97ba                	add	a5,a5,a4
    80002076:	639c                	ld	a5,0(a5)
    80002078:	cf8d                	beqz	a5,800020b2 <syscall+0x76>
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0

        p->trapframe->a0 = syscalls[num]();
    8000207a:	9782                	jalr	a5
    8000207c:	06a93823          	sd	a0,112(s2)
        if (p->mask & (1 << num)) {
    80002080:	1684a783          	lw	a5,360(s1)
    80002084:	4137d7bb          	sraw	a5,a5,s3
    80002088:	8b85                	andi	a5,a5,1
    8000208a:	c3b9                	beqz	a5,800020d0 <syscall+0x94>
            printf("%d: syscall %s -> %d\n", p->pid, syscalls_name[num], p->trapframe->a0);
    8000208c:	6cb8                	ld	a4,88(s1)
    8000208e:	098e                	slli	s3,s3,0x3
    80002090:	00007797          	auipc	a5,0x7
    80002094:	8c878793          	addi	a5,a5,-1848 # 80008958 <syscalls_name>
    80002098:	97ce                	add	a5,a5,s3
    8000209a:	7b34                	ld	a3,112(a4)
    8000209c:	6390                	ld	a2,0(a5)
    8000209e:	588c                	lw	a1,48(s1)
    800020a0:	00006517          	auipc	a0,0x6
    800020a4:	2f850513          	addi	a0,a0,760 # 80008398 <states.0+0x150>
    800020a8:	00004097          	auipc	ra,0x4
    800020ac:	c4e080e7          	jalr	-946(ra) # 80005cf6 <printf>
    800020b0:	a005                	j	800020d0 <syscall+0x94>
        }
    }
    else {
        printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    800020b2:	86ce                	mv	a3,s3
    800020b4:	15848613          	addi	a2,s1,344
    800020b8:	588c                	lw	a1,48(s1)
    800020ba:	00006517          	auipc	a0,0x6
    800020be:	2f650513          	addi	a0,a0,758 # 800083b0 <states.0+0x168>
    800020c2:	00004097          	auipc	ra,0x4
    800020c6:	c34080e7          	jalr	-972(ra) # 80005cf6 <printf>
        p->trapframe->a0 = -1;
    800020ca:	6cbc                	ld	a5,88(s1)
    800020cc:	577d                	li	a4,-1
    800020ce:	fbb8                	sd	a4,112(a5)
    }
}
    800020d0:	70a2                	ld	ra,40(sp)
    800020d2:	7402                	ld	s0,32(sp)
    800020d4:	64e2                	ld	s1,24(sp)
    800020d6:	6942                	ld	s2,16(sp)
    800020d8:	69a2                	ld	s3,8(sp)
    800020da:	6145                	addi	sp,sp,48
    800020dc:	8082                	ret

00000000800020de <sys_exit>:
#include "spinlock.h"
#include "proc.h"
#include "sysinfo.h"

uint64 sys_exit(void)
{
    800020de:	1101                	addi	sp,sp,-32
    800020e0:	ec06                	sd	ra,24(sp)
    800020e2:	e822                	sd	s0,16(sp)
    800020e4:	1000                	addi	s0,sp,32
    int n;
    argint(0, &n);
    800020e6:	fec40593          	addi	a1,s0,-20
    800020ea:	4501                	li	a0,0
    800020ec:	00000097          	auipc	ra,0x0
    800020f0:	ed8080e7          	jalr	-296(ra) # 80001fc4 <argint>
    exit(n);
    800020f4:	fec42503          	lw	a0,-20(s0)
    800020f8:	fffff097          	auipc	ra,0xfffff
    800020fc:	564080e7          	jalr	1380(ra) # 8000165c <exit>
    return 0; // not reached
}
    80002100:	4501                	li	a0,0
    80002102:	60e2                	ld	ra,24(sp)
    80002104:	6442                	ld	s0,16(sp)
    80002106:	6105                	addi	sp,sp,32
    80002108:	8082                	ret

000000008000210a <sys_getpid>:

uint64 sys_getpid(void)
{
    8000210a:	1141                	addi	sp,sp,-16
    8000210c:	e406                	sd	ra,8(sp)
    8000210e:	e022                	sd	s0,0(sp)
    80002110:	0800                	addi	s0,sp,16
    return myproc()->pid;
    80002112:	fffff097          	auipc	ra,0xfffff
    80002116:	d66080e7          	jalr	-666(ra) # 80000e78 <myproc>
}
    8000211a:	5908                	lw	a0,48(a0)
    8000211c:	60a2                	ld	ra,8(sp)
    8000211e:	6402                	ld	s0,0(sp)
    80002120:	0141                	addi	sp,sp,16
    80002122:	8082                	ret

0000000080002124 <sys_fork>:

uint64 sys_fork(void)
{
    80002124:	1141                	addi	sp,sp,-16
    80002126:	e406                	sd	ra,8(sp)
    80002128:	e022                	sd	s0,0(sp)
    8000212a:	0800                	addi	s0,sp,16
    return fork();
    8000212c:	fffff097          	auipc	ra,0xfffff
    80002130:	102080e7          	jalr	258(ra) # 8000122e <fork>
}
    80002134:	60a2                	ld	ra,8(sp)
    80002136:	6402                	ld	s0,0(sp)
    80002138:	0141                	addi	sp,sp,16
    8000213a:	8082                	ret

000000008000213c <sys_wait>:

uint64 sys_wait(void)
{
    8000213c:	1101                	addi	sp,sp,-32
    8000213e:	ec06                	sd	ra,24(sp)
    80002140:	e822                	sd	s0,16(sp)
    80002142:	1000                	addi	s0,sp,32
    uint64 p;
    argaddr(0, &p);
    80002144:	fe840593          	addi	a1,s0,-24
    80002148:	4501                	li	a0,0
    8000214a:	00000097          	auipc	ra,0x0
    8000214e:	e9a080e7          	jalr	-358(ra) # 80001fe4 <argaddr>
    return wait(p);
    80002152:	fe843503          	ld	a0,-24(s0)
    80002156:	fffff097          	auipc	ra,0xfffff
    8000215a:	6ac080e7          	jalr	1708(ra) # 80001802 <wait>
}
    8000215e:	60e2                	ld	ra,24(sp)
    80002160:	6442                	ld	s0,16(sp)
    80002162:	6105                	addi	sp,sp,32
    80002164:	8082                	ret

0000000080002166 <sys_sbrk>:

uint64 sys_sbrk(void)
{
    80002166:	7179                	addi	sp,sp,-48
    80002168:	f406                	sd	ra,40(sp)
    8000216a:	f022                	sd	s0,32(sp)
    8000216c:	ec26                	sd	s1,24(sp)
    8000216e:	1800                	addi	s0,sp,48
    uint64 addr;
    int n;

    argint(0, &n);
    80002170:	fdc40593          	addi	a1,s0,-36
    80002174:	4501                	li	a0,0
    80002176:	00000097          	auipc	ra,0x0
    8000217a:	e4e080e7          	jalr	-434(ra) # 80001fc4 <argint>
    addr = myproc()->sz;
    8000217e:	fffff097          	auipc	ra,0xfffff
    80002182:	cfa080e7          	jalr	-774(ra) # 80000e78 <myproc>
    80002186:	6524                	ld	s1,72(a0)
    if (growproc(n) < 0)
    80002188:	fdc42503          	lw	a0,-36(s0)
    8000218c:	fffff097          	auipc	ra,0xfffff
    80002190:	046080e7          	jalr	70(ra) # 800011d2 <growproc>
    80002194:	00054863          	bltz	a0,800021a4 <sys_sbrk+0x3e>
        return -1;
    return addr;
}
    80002198:	8526                	mv	a0,s1
    8000219a:	70a2                	ld	ra,40(sp)
    8000219c:	7402                	ld	s0,32(sp)
    8000219e:	64e2                	ld	s1,24(sp)
    800021a0:	6145                	addi	sp,sp,48
    800021a2:	8082                	ret
        return -1;
    800021a4:	54fd                	li	s1,-1
    800021a6:	bfcd                	j	80002198 <sys_sbrk+0x32>

00000000800021a8 <sys_sleep>:

uint64 sys_sleep(void)
{
    800021a8:	7139                	addi	sp,sp,-64
    800021aa:	fc06                	sd	ra,56(sp)
    800021ac:	f822                	sd	s0,48(sp)
    800021ae:	f426                	sd	s1,40(sp)
    800021b0:	f04a                	sd	s2,32(sp)
    800021b2:	ec4e                	sd	s3,24(sp)
    800021b4:	0080                	addi	s0,sp,64
    int n;
    uint ticks0;

    argint(0, &n);
    800021b6:	fcc40593          	addi	a1,s0,-52
    800021ba:	4501                	li	a0,0
    800021bc:	00000097          	auipc	ra,0x0
    800021c0:	e08080e7          	jalr	-504(ra) # 80001fc4 <argint>
    if (n < 0)
    800021c4:	fcc42783          	lw	a5,-52(s0)
    800021c8:	0607cf63          	bltz	a5,80002246 <sys_sleep+0x9e>
        n = 0;
    acquire(&tickslock);
    800021cc:	0000d517          	auipc	a0,0xd
    800021d0:	92450513          	addi	a0,a0,-1756 # 8000eaf0 <tickslock>
    800021d4:	00004097          	auipc	ra,0x4
    800021d8:	010080e7          	jalr	16(ra) # 800061e4 <acquire>
    ticks0 = ticks;
    800021dc:	00007917          	auipc	s2,0x7
    800021e0:	8ac92903          	lw	s2,-1876(s2) # 80008a88 <ticks>
    while (ticks - ticks0 < n) {
    800021e4:	fcc42783          	lw	a5,-52(s0)
    800021e8:	cf9d                	beqz	a5,80002226 <sys_sleep+0x7e>
        if (killed(myproc())) {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    800021ea:	0000d997          	auipc	s3,0xd
    800021ee:	90698993          	addi	s3,s3,-1786 # 8000eaf0 <tickslock>
    800021f2:	00007497          	auipc	s1,0x7
    800021f6:	89648493          	addi	s1,s1,-1898 # 80008a88 <ticks>
        if (killed(myproc())) {
    800021fa:	fffff097          	auipc	ra,0xfffff
    800021fe:	c7e080e7          	jalr	-898(ra) # 80000e78 <myproc>
    80002202:	fffff097          	auipc	ra,0xfffff
    80002206:	5ce080e7          	jalr	1486(ra) # 800017d0 <killed>
    8000220a:	e129                	bnez	a0,8000224c <sys_sleep+0xa4>
        sleep(&ticks, &tickslock);
    8000220c:	85ce                	mv	a1,s3
    8000220e:	8526                	mv	a0,s1
    80002210:	fffff097          	auipc	ra,0xfffff
    80002214:	318080e7          	jalr	792(ra) # 80001528 <sleep>
    while (ticks - ticks0 < n) {
    80002218:	409c                	lw	a5,0(s1)
    8000221a:	412787bb          	subw	a5,a5,s2
    8000221e:	fcc42703          	lw	a4,-52(s0)
    80002222:	fce7ece3          	bltu	a5,a4,800021fa <sys_sleep+0x52>
    }
    release(&tickslock);
    80002226:	0000d517          	auipc	a0,0xd
    8000222a:	8ca50513          	addi	a0,a0,-1846 # 8000eaf0 <tickslock>
    8000222e:	00004097          	auipc	ra,0x4
    80002232:	06a080e7          	jalr	106(ra) # 80006298 <release>
    return 0;
    80002236:	4501                	li	a0,0
}
    80002238:	70e2                	ld	ra,56(sp)
    8000223a:	7442                	ld	s0,48(sp)
    8000223c:	74a2                	ld	s1,40(sp)
    8000223e:	7902                	ld	s2,32(sp)
    80002240:	69e2                	ld	s3,24(sp)
    80002242:	6121                	addi	sp,sp,64
    80002244:	8082                	ret
        n = 0;
    80002246:	fc042623          	sw	zero,-52(s0)
    8000224a:	b749                	j	800021cc <sys_sleep+0x24>
            release(&tickslock);
    8000224c:	0000d517          	auipc	a0,0xd
    80002250:	8a450513          	addi	a0,a0,-1884 # 8000eaf0 <tickslock>
    80002254:	00004097          	auipc	ra,0x4
    80002258:	044080e7          	jalr	68(ra) # 80006298 <release>
            return -1;
    8000225c:	557d                	li	a0,-1
    8000225e:	bfe9                	j	80002238 <sys_sleep+0x90>

0000000080002260 <sys_kill>:

uint64 sys_kill(void)
{
    80002260:	1101                	addi	sp,sp,-32
    80002262:	ec06                	sd	ra,24(sp)
    80002264:	e822                	sd	s0,16(sp)
    80002266:	1000                	addi	s0,sp,32
    int pid;

    argint(0, &pid);
    80002268:	fec40593          	addi	a1,s0,-20
    8000226c:	4501                	li	a0,0
    8000226e:	00000097          	auipc	ra,0x0
    80002272:	d56080e7          	jalr	-682(ra) # 80001fc4 <argint>
    return kill(pid);
    80002276:	fec42503          	lw	a0,-20(s0)
    8000227a:	fffff097          	auipc	ra,0xfffff
    8000227e:	4b8080e7          	jalr	1208(ra) # 80001732 <kill>
}
    80002282:	60e2                	ld	ra,24(sp)
    80002284:	6442                	ld	s0,16(sp)
    80002286:	6105                	addi	sp,sp,32
    80002288:	8082                	ret

000000008000228a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void)
{
    8000228a:	1101                	addi	sp,sp,-32
    8000228c:	ec06                	sd	ra,24(sp)
    8000228e:	e822                	sd	s0,16(sp)
    80002290:	e426                	sd	s1,8(sp)
    80002292:	1000                	addi	s0,sp,32
    uint xticks;

    acquire(&tickslock);
    80002294:	0000d517          	auipc	a0,0xd
    80002298:	85c50513          	addi	a0,a0,-1956 # 8000eaf0 <tickslock>
    8000229c:	00004097          	auipc	ra,0x4
    800022a0:	f48080e7          	jalr	-184(ra) # 800061e4 <acquire>
    xticks = ticks;
    800022a4:	00006497          	auipc	s1,0x6
    800022a8:	7e44a483          	lw	s1,2020(s1) # 80008a88 <ticks>
    release(&tickslock);
    800022ac:	0000d517          	auipc	a0,0xd
    800022b0:	84450513          	addi	a0,a0,-1980 # 8000eaf0 <tickslock>
    800022b4:	00004097          	auipc	ra,0x4
    800022b8:	fe4080e7          	jalr	-28(ra) # 80006298 <release>
    return xticks;
}
    800022bc:	02049513          	slli	a0,s1,0x20
    800022c0:	9101                	srli	a0,a0,0x20
    800022c2:	60e2                	ld	ra,24(sp)
    800022c4:	6442                	ld	s0,16(sp)
    800022c6:	64a2                	ld	s1,8(sp)
    800022c8:	6105                	addi	sp,sp,32
    800022ca:	8082                	ret

00000000800022cc <sys_trace>:

uint64 sys_trace(void)
{
    800022cc:	1101                	addi	sp,sp,-32
    800022ce:	ec06                	sd	ra,24(sp)
    800022d0:	e822                	sd	s0,16(sp)
    800022d2:	1000                	addi	s0,sp,32
    int mask;
    argint(0, &mask);
    800022d4:	fec40593          	addi	a1,s0,-20
    800022d8:	4501                	li	a0,0
    800022da:	00000097          	auipc	ra,0x0
    800022de:	cea080e7          	jalr	-790(ra) # 80001fc4 <argint>
    myproc()->mask = mask;
    800022e2:	fffff097          	auipc	ra,0xfffff
    800022e6:	b96080e7          	jalr	-1130(ra) # 80000e78 <myproc>
    800022ea:	fec42783          	lw	a5,-20(s0)
    800022ee:	16f52423          	sw	a5,360(a0)
    return 0;
}
    800022f2:	4501                	li	a0,0
    800022f4:	60e2                	ld	ra,24(sp)
    800022f6:	6442                	ld	s0,16(sp)
    800022f8:	6105                	addi	sp,sp,32
    800022fa:	8082                	ret

00000000800022fc <sys_sysinfo>:

uint64 sys_sysinfo(void)
{
    800022fc:	7179                	addi	sp,sp,-48
    800022fe:	f406                	sd	ra,40(sp)
    80002300:	f022                	sd	s0,32(sp)
    80002302:	1800                	addi	s0,sp,48
    uint64 addr;
    argaddr(0, &addr);
    80002304:	fe840593          	addi	a1,s0,-24
    80002308:	4501                	li	a0,0
    8000230a:	00000097          	auipc	ra,0x0
    8000230e:	cda080e7          	jalr	-806(ra) # 80001fe4 <argaddr>
    struct sysinfo info;
    info.freemem = countMEM();
    80002312:	ffffe097          	auipc	ra,0xffffe
    80002316:	e68080e7          	jalr	-408(ra) # 8000017a <countMEM>
    8000231a:	fca43c23          	sd	a0,-40(s0)
    info.nproc = countProc();
    8000231e:	fffff097          	auipc	ra,0xfffff
    80002322:	76e080e7          	jalr	1902(ra) # 80001a8c <countProc>
    80002326:	fea43023          	sd	a0,-32(s0)

    if (copyout(myproc()->pagetable, addr, (char *)&info, sizeof(info)) < 0) {
    8000232a:	fffff097          	auipc	ra,0xfffff
    8000232e:	b4e080e7          	jalr	-1202(ra) # 80000e78 <myproc>
    80002332:	46c1                	li	a3,16
    80002334:	fd840613          	addi	a2,s0,-40
    80002338:	fe843583          	ld	a1,-24(s0)
    8000233c:	6928                	ld	a0,80(a0)
    8000233e:	ffffe097          	auipc	ra,0xffffe
    80002342:	7fa080e7          	jalr	2042(ra) # 80000b38 <copyout>
        return -1;
    }
    return 0;
}
    80002346:	957d                	srai	a0,a0,0x3f
    80002348:	70a2                	ld	ra,40(sp)
    8000234a:	7402                	ld	s0,32(sp)
    8000234c:	6145                	addi	sp,sp,48
    8000234e:	8082                	ret

0000000080002350 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002350:	7179                	addi	sp,sp,-48
    80002352:	f406                	sd	ra,40(sp)
    80002354:	f022                	sd	s0,32(sp)
    80002356:	ec26                	sd	s1,24(sp)
    80002358:	e84a                	sd	s2,16(sp)
    8000235a:	e44e                	sd	s3,8(sp)
    8000235c:	e052                	sd	s4,0(sp)
    8000235e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002360:	00006597          	auipc	a1,0x6
    80002364:	1f858593          	addi	a1,a1,504 # 80008558 <syscalls+0xc0>
    80002368:	0000c517          	auipc	a0,0xc
    8000236c:	7a050513          	addi	a0,a0,1952 # 8000eb08 <bcache>
    80002370:	00004097          	auipc	ra,0x4
    80002374:	de4080e7          	jalr	-540(ra) # 80006154 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002378:	00014797          	auipc	a5,0x14
    8000237c:	79078793          	addi	a5,a5,1936 # 80016b08 <bcache+0x8000>
    80002380:	00015717          	auipc	a4,0x15
    80002384:	9f070713          	addi	a4,a4,-1552 # 80016d70 <bcache+0x8268>
    80002388:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000238c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002390:	0000c497          	auipc	s1,0xc
    80002394:	79048493          	addi	s1,s1,1936 # 8000eb20 <bcache+0x18>
    b->next = bcache.head.next;
    80002398:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000239a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000239c:	00006a17          	auipc	s4,0x6
    800023a0:	1c4a0a13          	addi	s4,s4,452 # 80008560 <syscalls+0xc8>
    b->next = bcache.head.next;
    800023a4:	2b893783          	ld	a5,696(s2)
    800023a8:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023aa:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023ae:	85d2                	mv	a1,s4
    800023b0:	01048513          	addi	a0,s1,16
    800023b4:	00001097          	auipc	ra,0x1
    800023b8:	4c8080e7          	jalr	1224(ra) # 8000387c <initsleeplock>
    bcache.head.next->prev = b;
    800023bc:	2b893783          	ld	a5,696(s2)
    800023c0:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023c2:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023c6:	45848493          	addi	s1,s1,1112
    800023ca:	fd349de3          	bne	s1,s3,800023a4 <binit+0x54>
  }
}
    800023ce:	70a2                	ld	ra,40(sp)
    800023d0:	7402                	ld	s0,32(sp)
    800023d2:	64e2                	ld	s1,24(sp)
    800023d4:	6942                	ld	s2,16(sp)
    800023d6:	69a2                	ld	s3,8(sp)
    800023d8:	6a02                	ld	s4,0(sp)
    800023da:	6145                	addi	sp,sp,48
    800023dc:	8082                	ret

00000000800023de <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023de:	7179                	addi	sp,sp,-48
    800023e0:	f406                	sd	ra,40(sp)
    800023e2:	f022                	sd	s0,32(sp)
    800023e4:	ec26                	sd	s1,24(sp)
    800023e6:	e84a                	sd	s2,16(sp)
    800023e8:	e44e                	sd	s3,8(sp)
    800023ea:	1800                	addi	s0,sp,48
    800023ec:	892a                	mv	s2,a0
    800023ee:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800023f0:	0000c517          	auipc	a0,0xc
    800023f4:	71850513          	addi	a0,a0,1816 # 8000eb08 <bcache>
    800023f8:	00004097          	auipc	ra,0x4
    800023fc:	dec080e7          	jalr	-532(ra) # 800061e4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002400:	00015497          	auipc	s1,0x15
    80002404:	9c04b483          	ld	s1,-1600(s1) # 80016dc0 <bcache+0x82b8>
    80002408:	00015797          	auipc	a5,0x15
    8000240c:	96878793          	addi	a5,a5,-1688 # 80016d70 <bcache+0x8268>
    80002410:	02f48f63          	beq	s1,a5,8000244e <bread+0x70>
    80002414:	873e                	mv	a4,a5
    80002416:	a021                	j	8000241e <bread+0x40>
    80002418:	68a4                	ld	s1,80(s1)
    8000241a:	02e48a63          	beq	s1,a4,8000244e <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000241e:	449c                	lw	a5,8(s1)
    80002420:	ff279ce3          	bne	a5,s2,80002418 <bread+0x3a>
    80002424:	44dc                	lw	a5,12(s1)
    80002426:	ff3799e3          	bne	a5,s3,80002418 <bread+0x3a>
      b->refcnt++;
    8000242a:	40bc                	lw	a5,64(s1)
    8000242c:	2785                	addiw	a5,a5,1
    8000242e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002430:	0000c517          	auipc	a0,0xc
    80002434:	6d850513          	addi	a0,a0,1752 # 8000eb08 <bcache>
    80002438:	00004097          	auipc	ra,0x4
    8000243c:	e60080e7          	jalr	-416(ra) # 80006298 <release>
      acquiresleep(&b->lock);
    80002440:	01048513          	addi	a0,s1,16
    80002444:	00001097          	auipc	ra,0x1
    80002448:	472080e7          	jalr	1138(ra) # 800038b6 <acquiresleep>
      return b;
    8000244c:	a8b9                	j	800024aa <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000244e:	00015497          	auipc	s1,0x15
    80002452:	96a4b483          	ld	s1,-1686(s1) # 80016db8 <bcache+0x82b0>
    80002456:	00015797          	auipc	a5,0x15
    8000245a:	91a78793          	addi	a5,a5,-1766 # 80016d70 <bcache+0x8268>
    8000245e:	00f48863          	beq	s1,a5,8000246e <bread+0x90>
    80002462:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002464:	40bc                	lw	a5,64(s1)
    80002466:	cf81                	beqz	a5,8000247e <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002468:	64a4                	ld	s1,72(s1)
    8000246a:	fee49de3          	bne	s1,a4,80002464 <bread+0x86>
  panic("bget: no buffers");
    8000246e:	00006517          	auipc	a0,0x6
    80002472:	0fa50513          	addi	a0,a0,250 # 80008568 <syscalls+0xd0>
    80002476:	00004097          	auipc	ra,0x4
    8000247a:	836080e7          	jalr	-1994(ra) # 80005cac <panic>
      b->dev = dev;
    8000247e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002482:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002486:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000248a:	4785                	li	a5,1
    8000248c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000248e:	0000c517          	auipc	a0,0xc
    80002492:	67a50513          	addi	a0,a0,1658 # 8000eb08 <bcache>
    80002496:	00004097          	auipc	ra,0x4
    8000249a:	e02080e7          	jalr	-510(ra) # 80006298 <release>
      acquiresleep(&b->lock);
    8000249e:	01048513          	addi	a0,s1,16
    800024a2:	00001097          	auipc	ra,0x1
    800024a6:	414080e7          	jalr	1044(ra) # 800038b6 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024aa:	409c                	lw	a5,0(s1)
    800024ac:	cb89                	beqz	a5,800024be <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024ae:	8526                	mv	a0,s1
    800024b0:	70a2                	ld	ra,40(sp)
    800024b2:	7402                	ld	s0,32(sp)
    800024b4:	64e2                	ld	s1,24(sp)
    800024b6:	6942                	ld	s2,16(sp)
    800024b8:	69a2                	ld	s3,8(sp)
    800024ba:	6145                	addi	sp,sp,48
    800024bc:	8082                	ret
    virtio_disk_rw(b, 0);
    800024be:	4581                	li	a1,0
    800024c0:	8526                	mv	a0,s1
    800024c2:	00003097          	auipc	ra,0x3
    800024c6:	fe0080e7          	jalr	-32(ra) # 800054a2 <virtio_disk_rw>
    b->valid = 1;
    800024ca:	4785                	li	a5,1
    800024cc:	c09c                	sw	a5,0(s1)
  return b;
    800024ce:	b7c5                	j	800024ae <bread+0xd0>

00000000800024d0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024d0:	1101                	addi	sp,sp,-32
    800024d2:	ec06                	sd	ra,24(sp)
    800024d4:	e822                	sd	s0,16(sp)
    800024d6:	e426                	sd	s1,8(sp)
    800024d8:	1000                	addi	s0,sp,32
    800024da:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024dc:	0541                	addi	a0,a0,16
    800024de:	00001097          	auipc	ra,0x1
    800024e2:	472080e7          	jalr	1138(ra) # 80003950 <holdingsleep>
    800024e6:	cd01                	beqz	a0,800024fe <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024e8:	4585                	li	a1,1
    800024ea:	8526                	mv	a0,s1
    800024ec:	00003097          	auipc	ra,0x3
    800024f0:	fb6080e7          	jalr	-74(ra) # 800054a2 <virtio_disk_rw>
}
    800024f4:	60e2                	ld	ra,24(sp)
    800024f6:	6442                	ld	s0,16(sp)
    800024f8:	64a2                	ld	s1,8(sp)
    800024fa:	6105                	addi	sp,sp,32
    800024fc:	8082                	ret
    panic("bwrite");
    800024fe:	00006517          	auipc	a0,0x6
    80002502:	08250513          	addi	a0,a0,130 # 80008580 <syscalls+0xe8>
    80002506:	00003097          	auipc	ra,0x3
    8000250a:	7a6080e7          	jalr	1958(ra) # 80005cac <panic>

000000008000250e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000250e:	1101                	addi	sp,sp,-32
    80002510:	ec06                	sd	ra,24(sp)
    80002512:	e822                	sd	s0,16(sp)
    80002514:	e426                	sd	s1,8(sp)
    80002516:	e04a                	sd	s2,0(sp)
    80002518:	1000                	addi	s0,sp,32
    8000251a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000251c:	01050913          	addi	s2,a0,16
    80002520:	854a                	mv	a0,s2
    80002522:	00001097          	auipc	ra,0x1
    80002526:	42e080e7          	jalr	1070(ra) # 80003950 <holdingsleep>
    8000252a:	c92d                	beqz	a0,8000259c <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000252c:	854a                	mv	a0,s2
    8000252e:	00001097          	auipc	ra,0x1
    80002532:	3de080e7          	jalr	990(ra) # 8000390c <releasesleep>

  acquire(&bcache.lock);
    80002536:	0000c517          	auipc	a0,0xc
    8000253a:	5d250513          	addi	a0,a0,1490 # 8000eb08 <bcache>
    8000253e:	00004097          	auipc	ra,0x4
    80002542:	ca6080e7          	jalr	-858(ra) # 800061e4 <acquire>
  b->refcnt--;
    80002546:	40bc                	lw	a5,64(s1)
    80002548:	37fd                	addiw	a5,a5,-1
    8000254a:	0007871b          	sext.w	a4,a5
    8000254e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002550:	eb05                	bnez	a4,80002580 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002552:	68bc                	ld	a5,80(s1)
    80002554:	64b8                	ld	a4,72(s1)
    80002556:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002558:	64bc                	ld	a5,72(s1)
    8000255a:	68b8                	ld	a4,80(s1)
    8000255c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000255e:	00014797          	auipc	a5,0x14
    80002562:	5aa78793          	addi	a5,a5,1450 # 80016b08 <bcache+0x8000>
    80002566:	2b87b703          	ld	a4,696(a5)
    8000256a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000256c:	00015717          	auipc	a4,0x15
    80002570:	80470713          	addi	a4,a4,-2044 # 80016d70 <bcache+0x8268>
    80002574:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002576:	2b87b703          	ld	a4,696(a5)
    8000257a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000257c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002580:	0000c517          	auipc	a0,0xc
    80002584:	58850513          	addi	a0,a0,1416 # 8000eb08 <bcache>
    80002588:	00004097          	auipc	ra,0x4
    8000258c:	d10080e7          	jalr	-752(ra) # 80006298 <release>
}
    80002590:	60e2                	ld	ra,24(sp)
    80002592:	6442                	ld	s0,16(sp)
    80002594:	64a2                	ld	s1,8(sp)
    80002596:	6902                	ld	s2,0(sp)
    80002598:	6105                	addi	sp,sp,32
    8000259a:	8082                	ret
    panic("brelse");
    8000259c:	00006517          	auipc	a0,0x6
    800025a0:	fec50513          	addi	a0,a0,-20 # 80008588 <syscalls+0xf0>
    800025a4:	00003097          	auipc	ra,0x3
    800025a8:	708080e7          	jalr	1800(ra) # 80005cac <panic>

00000000800025ac <bpin>:

void
bpin(struct buf *b) {
    800025ac:	1101                	addi	sp,sp,-32
    800025ae:	ec06                	sd	ra,24(sp)
    800025b0:	e822                	sd	s0,16(sp)
    800025b2:	e426                	sd	s1,8(sp)
    800025b4:	1000                	addi	s0,sp,32
    800025b6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025b8:	0000c517          	auipc	a0,0xc
    800025bc:	55050513          	addi	a0,a0,1360 # 8000eb08 <bcache>
    800025c0:	00004097          	auipc	ra,0x4
    800025c4:	c24080e7          	jalr	-988(ra) # 800061e4 <acquire>
  b->refcnt++;
    800025c8:	40bc                	lw	a5,64(s1)
    800025ca:	2785                	addiw	a5,a5,1
    800025cc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025ce:	0000c517          	auipc	a0,0xc
    800025d2:	53a50513          	addi	a0,a0,1338 # 8000eb08 <bcache>
    800025d6:	00004097          	auipc	ra,0x4
    800025da:	cc2080e7          	jalr	-830(ra) # 80006298 <release>
}
    800025de:	60e2                	ld	ra,24(sp)
    800025e0:	6442                	ld	s0,16(sp)
    800025e2:	64a2                	ld	s1,8(sp)
    800025e4:	6105                	addi	sp,sp,32
    800025e6:	8082                	ret

00000000800025e8 <bunpin>:

void
bunpin(struct buf *b) {
    800025e8:	1101                	addi	sp,sp,-32
    800025ea:	ec06                	sd	ra,24(sp)
    800025ec:	e822                	sd	s0,16(sp)
    800025ee:	e426                	sd	s1,8(sp)
    800025f0:	1000                	addi	s0,sp,32
    800025f2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025f4:	0000c517          	auipc	a0,0xc
    800025f8:	51450513          	addi	a0,a0,1300 # 8000eb08 <bcache>
    800025fc:	00004097          	auipc	ra,0x4
    80002600:	be8080e7          	jalr	-1048(ra) # 800061e4 <acquire>
  b->refcnt--;
    80002604:	40bc                	lw	a5,64(s1)
    80002606:	37fd                	addiw	a5,a5,-1
    80002608:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000260a:	0000c517          	auipc	a0,0xc
    8000260e:	4fe50513          	addi	a0,a0,1278 # 8000eb08 <bcache>
    80002612:	00004097          	auipc	ra,0x4
    80002616:	c86080e7          	jalr	-890(ra) # 80006298 <release>
}
    8000261a:	60e2                	ld	ra,24(sp)
    8000261c:	6442                	ld	s0,16(sp)
    8000261e:	64a2                	ld	s1,8(sp)
    80002620:	6105                	addi	sp,sp,32
    80002622:	8082                	ret

0000000080002624 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002624:	1101                	addi	sp,sp,-32
    80002626:	ec06                	sd	ra,24(sp)
    80002628:	e822                	sd	s0,16(sp)
    8000262a:	e426                	sd	s1,8(sp)
    8000262c:	e04a                	sd	s2,0(sp)
    8000262e:	1000                	addi	s0,sp,32
    80002630:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002632:	00d5d59b          	srliw	a1,a1,0xd
    80002636:	00015797          	auipc	a5,0x15
    8000263a:	bae7a783          	lw	a5,-1106(a5) # 800171e4 <sb+0x1c>
    8000263e:	9dbd                	addw	a1,a1,a5
    80002640:	00000097          	auipc	ra,0x0
    80002644:	d9e080e7          	jalr	-610(ra) # 800023de <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002648:	0074f713          	andi	a4,s1,7
    8000264c:	4785                	li	a5,1
    8000264e:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002652:	14ce                	slli	s1,s1,0x33
    80002654:	90d9                	srli	s1,s1,0x36
    80002656:	00950733          	add	a4,a0,s1
    8000265a:	05874703          	lbu	a4,88(a4)
    8000265e:	00e7f6b3          	and	a3,a5,a4
    80002662:	c69d                	beqz	a3,80002690 <bfree+0x6c>
    80002664:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002666:	94aa                	add	s1,s1,a0
    80002668:	fff7c793          	not	a5,a5
    8000266c:	8f7d                	and	a4,a4,a5
    8000266e:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002672:	00001097          	auipc	ra,0x1
    80002676:	126080e7          	jalr	294(ra) # 80003798 <log_write>
  brelse(bp);
    8000267a:	854a                	mv	a0,s2
    8000267c:	00000097          	auipc	ra,0x0
    80002680:	e92080e7          	jalr	-366(ra) # 8000250e <brelse>
}
    80002684:	60e2                	ld	ra,24(sp)
    80002686:	6442                	ld	s0,16(sp)
    80002688:	64a2                	ld	s1,8(sp)
    8000268a:	6902                	ld	s2,0(sp)
    8000268c:	6105                	addi	sp,sp,32
    8000268e:	8082                	ret
    panic("freeing free block");
    80002690:	00006517          	auipc	a0,0x6
    80002694:	f0050513          	addi	a0,a0,-256 # 80008590 <syscalls+0xf8>
    80002698:	00003097          	auipc	ra,0x3
    8000269c:	614080e7          	jalr	1556(ra) # 80005cac <panic>

00000000800026a0 <balloc>:
{
    800026a0:	711d                	addi	sp,sp,-96
    800026a2:	ec86                	sd	ra,88(sp)
    800026a4:	e8a2                	sd	s0,80(sp)
    800026a6:	e4a6                	sd	s1,72(sp)
    800026a8:	e0ca                	sd	s2,64(sp)
    800026aa:	fc4e                	sd	s3,56(sp)
    800026ac:	f852                	sd	s4,48(sp)
    800026ae:	f456                	sd	s5,40(sp)
    800026b0:	f05a                	sd	s6,32(sp)
    800026b2:	ec5e                	sd	s7,24(sp)
    800026b4:	e862                	sd	s8,16(sp)
    800026b6:	e466                	sd	s9,8(sp)
    800026b8:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026ba:	00015797          	auipc	a5,0x15
    800026be:	b127a783          	lw	a5,-1262(a5) # 800171cc <sb+0x4>
    800026c2:	cff5                	beqz	a5,800027be <balloc+0x11e>
    800026c4:	8baa                	mv	s7,a0
    800026c6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026c8:	00015b17          	auipc	s6,0x15
    800026cc:	b00b0b13          	addi	s6,s6,-1280 # 800171c8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026d0:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026d2:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026d4:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026d6:	6c89                	lui	s9,0x2
    800026d8:	a061                	j	80002760 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    800026da:	97ca                	add	a5,a5,s2
    800026dc:	8e55                	or	a2,a2,a3
    800026de:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800026e2:	854a                	mv	a0,s2
    800026e4:	00001097          	auipc	ra,0x1
    800026e8:	0b4080e7          	jalr	180(ra) # 80003798 <log_write>
        brelse(bp);
    800026ec:	854a                	mv	a0,s2
    800026ee:	00000097          	auipc	ra,0x0
    800026f2:	e20080e7          	jalr	-480(ra) # 8000250e <brelse>
  bp = bread(dev, bno);
    800026f6:	85a6                	mv	a1,s1
    800026f8:	855e                	mv	a0,s7
    800026fa:	00000097          	auipc	ra,0x0
    800026fe:	ce4080e7          	jalr	-796(ra) # 800023de <bread>
    80002702:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002704:	40000613          	li	a2,1024
    80002708:	4581                	li	a1,0
    8000270a:	05850513          	addi	a0,a0,88
    8000270e:	ffffe097          	auipc	ra,0xffffe
    80002712:	a90080e7          	jalr	-1392(ra) # 8000019e <memset>
  log_write(bp);
    80002716:	854a                	mv	a0,s2
    80002718:	00001097          	auipc	ra,0x1
    8000271c:	080080e7          	jalr	128(ra) # 80003798 <log_write>
  brelse(bp);
    80002720:	854a                	mv	a0,s2
    80002722:	00000097          	auipc	ra,0x0
    80002726:	dec080e7          	jalr	-532(ra) # 8000250e <brelse>
}
    8000272a:	8526                	mv	a0,s1
    8000272c:	60e6                	ld	ra,88(sp)
    8000272e:	6446                	ld	s0,80(sp)
    80002730:	64a6                	ld	s1,72(sp)
    80002732:	6906                	ld	s2,64(sp)
    80002734:	79e2                	ld	s3,56(sp)
    80002736:	7a42                	ld	s4,48(sp)
    80002738:	7aa2                	ld	s5,40(sp)
    8000273a:	7b02                	ld	s6,32(sp)
    8000273c:	6be2                	ld	s7,24(sp)
    8000273e:	6c42                	ld	s8,16(sp)
    80002740:	6ca2                	ld	s9,8(sp)
    80002742:	6125                	addi	sp,sp,96
    80002744:	8082                	ret
    brelse(bp);
    80002746:	854a                	mv	a0,s2
    80002748:	00000097          	auipc	ra,0x0
    8000274c:	dc6080e7          	jalr	-570(ra) # 8000250e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002750:	015c87bb          	addw	a5,s9,s5
    80002754:	00078a9b          	sext.w	s5,a5
    80002758:	004b2703          	lw	a4,4(s6)
    8000275c:	06eaf163          	bgeu	s5,a4,800027be <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    80002760:	41fad79b          	sraiw	a5,s5,0x1f
    80002764:	0137d79b          	srliw	a5,a5,0x13
    80002768:	015787bb          	addw	a5,a5,s5
    8000276c:	40d7d79b          	sraiw	a5,a5,0xd
    80002770:	01cb2583          	lw	a1,28(s6)
    80002774:	9dbd                	addw	a1,a1,a5
    80002776:	855e                	mv	a0,s7
    80002778:	00000097          	auipc	ra,0x0
    8000277c:	c66080e7          	jalr	-922(ra) # 800023de <bread>
    80002780:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002782:	004b2503          	lw	a0,4(s6)
    80002786:	000a849b          	sext.w	s1,s5
    8000278a:	8762                	mv	a4,s8
    8000278c:	faa4fde3          	bgeu	s1,a0,80002746 <balloc+0xa6>
      m = 1 << (bi % 8);
    80002790:	00777693          	andi	a3,a4,7
    80002794:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002798:	41f7579b          	sraiw	a5,a4,0x1f
    8000279c:	01d7d79b          	srliw	a5,a5,0x1d
    800027a0:	9fb9                	addw	a5,a5,a4
    800027a2:	4037d79b          	sraiw	a5,a5,0x3
    800027a6:	00f90633          	add	a2,s2,a5
    800027aa:	05864603          	lbu	a2,88(a2)
    800027ae:	00c6f5b3          	and	a1,a3,a2
    800027b2:	d585                	beqz	a1,800026da <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027b4:	2705                	addiw	a4,a4,1
    800027b6:	2485                	addiw	s1,s1,1
    800027b8:	fd471ae3          	bne	a4,s4,8000278c <balloc+0xec>
    800027bc:	b769                	j	80002746 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    800027be:	00006517          	auipc	a0,0x6
    800027c2:	dea50513          	addi	a0,a0,-534 # 800085a8 <syscalls+0x110>
    800027c6:	00003097          	auipc	ra,0x3
    800027ca:	530080e7          	jalr	1328(ra) # 80005cf6 <printf>
  return 0;
    800027ce:	4481                	li	s1,0
    800027d0:	bfa9                	j	8000272a <balloc+0x8a>

00000000800027d2 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800027d2:	7179                	addi	sp,sp,-48
    800027d4:	f406                	sd	ra,40(sp)
    800027d6:	f022                	sd	s0,32(sp)
    800027d8:	ec26                	sd	s1,24(sp)
    800027da:	e84a                	sd	s2,16(sp)
    800027dc:	e44e                	sd	s3,8(sp)
    800027de:	e052                	sd	s4,0(sp)
    800027e0:	1800                	addi	s0,sp,48
    800027e2:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027e4:	47ad                	li	a5,11
    800027e6:	02b7e863          	bltu	a5,a1,80002816 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    800027ea:	02059793          	slli	a5,a1,0x20
    800027ee:	01e7d593          	srli	a1,a5,0x1e
    800027f2:	00b504b3          	add	s1,a0,a1
    800027f6:	0504a903          	lw	s2,80(s1)
    800027fa:	06091e63          	bnez	s2,80002876 <bmap+0xa4>
      addr = balloc(ip->dev);
    800027fe:	4108                	lw	a0,0(a0)
    80002800:	00000097          	auipc	ra,0x0
    80002804:	ea0080e7          	jalr	-352(ra) # 800026a0 <balloc>
    80002808:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000280c:	06090563          	beqz	s2,80002876 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    80002810:	0524a823          	sw	s2,80(s1)
    80002814:	a08d                	j	80002876 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002816:	ff45849b          	addiw	s1,a1,-12
    8000281a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000281e:	0ff00793          	li	a5,255
    80002822:	08e7e563          	bltu	a5,a4,800028ac <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002826:	08052903          	lw	s2,128(a0)
    8000282a:	00091d63          	bnez	s2,80002844 <bmap+0x72>
      addr = balloc(ip->dev);
    8000282e:	4108                	lw	a0,0(a0)
    80002830:	00000097          	auipc	ra,0x0
    80002834:	e70080e7          	jalr	-400(ra) # 800026a0 <balloc>
    80002838:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000283c:	02090d63          	beqz	s2,80002876 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002840:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002844:	85ca                	mv	a1,s2
    80002846:	0009a503          	lw	a0,0(s3)
    8000284a:	00000097          	auipc	ra,0x0
    8000284e:	b94080e7          	jalr	-1132(ra) # 800023de <bread>
    80002852:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002854:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002858:	02049713          	slli	a4,s1,0x20
    8000285c:	01e75593          	srli	a1,a4,0x1e
    80002860:	00b784b3          	add	s1,a5,a1
    80002864:	0004a903          	lw	s2,0(s1)
    80002868:	02090063          	beqz	s2,80002888 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000286c:	8552                	mv	a0,s4
    8000286e:	00000097          	auipc	ra,0x0
    80002872:	ca0080e7          	jalr	-864(ra) # 8000250e <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002876:	854a                	mv	a0,s2
    80002878:	70a2                	ld	ra,40(sp)
    8000287a:	7402                	ld	s0,32(sp)
    8000287c:	64e2                	ld	s1,24(sp)
    8000287e:	6942                	ld	s2,16(sp)
    80002880:	69a2                	ld	s3,8(sp)
    80002882:	6a02                	ld	s4,0(sp)
    80002884:	6145                	addi	sp,sp,48
    80002886:	8082                	ret
      addr = balloc(ip->dev);
    80002888:	0009a503          	lw	a0,0(s3)
    8000288c:	00000097          	auipc	ra,0x0
    80002890:	e14080e7          	jalr	-492(ra) # 800026a0 <balloc>
    80002894:	0005091b          	sext.w	s2,a0
      if(addr){
    80002898:	fc090ae3          	beqz	s2,8000286c <bmap+0x9a>
        a[bn] = addr;
    8000289c:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800028a0:	8552                	mv	a0,s4
    800028a2:	00001097          	auipc	ra,0x1
    800028a6:	ef6080e7          	jalr	-266(ra) # 80003798 <log_write>
    800028aa:	b7c9                	j	8000286c <bmap+0x9a>
  panic("bmap: out of range");
    800028ac:	00006517          	auipc	a0,0x6
    800028b0:	d1450513          	addi	a0,a0,-748 # 800085c0 <syscalls+0x128>
    800028b4:	00003097          	auipc	ra,0x3
    800028b8:	3f8080e7          	jalr	1016(ra) # 80005cac <panic>

00000000800028bc <iget>:
{
    800028bc:	7179                	addi	sp,sp,-48
    800028be:	f406                	sd	ra,40(sp)
    800028c0:	f022                	sd	s0,32(sp)
    800028c2:	ec26                	sd	s1,24(sp)
    800028c4:	e84a                	sd	s2,16(sp)
    800028c6:	e44e                	sd	s3,8(sp)
    800028c8:	e052                	sd	s4,0(sp)
    800028ca:	1800                	addi	s0,sp,48
    800028cc:	89aa                	mv	s3,a0
    800028ce:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028d0:	00015517          	auipc	a0,0x15
    800028d4:	91850513          	addi	a0,a0,-1768 # 800171e8 <itable>
    800028d8:	00004097          	auipc	ra,0x4
    800028dc:	90c080e7          	jalr	-1780(ra) # 800061e4 <acquire>
  empty = 0;
    800028e0:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028e2:	00015497          	auipc	s1,0x15
    800028e6:	91e48493          	addi	s1,s1,-1762 # 80017200 <itable+0x18>
    800028ea:	00016697          	auipc	a3,0x16
    800028ee:	3a668693          	addi	a3,a3,934 # 80018c90 <log>
    800028f2:	a039                	j	80002900 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028f4:	02090b63          	beqz	s2,8000292a <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028f8:	08848493          	addi	s1,s1,136
    800028fc:	02d48a63          	beq	s1,a3,80002930 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002900:	449c                	lw	a5,8(s1)
    80002902:	fef059e3          	blez	a5,800028f4 <iget+0x38>
    80002906:	4098                	lw	a4,0(s1)
    80002908:	ff3716e3          	bne	a4,s3,800028f4 <iget+0x38>
    8000290c:	40d8                	lw	a4,4(s1)
    8000290e:	ff4713e3          	bne	a4,s4,800028f4 <iget+0x38>
      ip->ref++;
    80002912:	2785                	addiw	a5,a5,1
    80002914:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002916:	00015517          	auipc	a0,0x15
    8000291a:	8d250513          	addi	a0,a0,-1838 # 800171e8 <itable>
    8000291e:	00004097          	auipc	ra,0x4
    80002922:	97a080e7          	jalr	-1670(ra) # 80006298 <release>
      return ip;
    80002926:	8926                	mv	s2,s1
    80002928:	a03d                	j	80002956 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000292a:	f7f9                	bnez	a5,800028f8 <iget+0x3c>
    8000292c:	8926                	mv	s2,s1
    8000292e:	b7e9                	j	800028f8 <iget+0x3c>
  if(empty == 0)
    80002930:	02090c63          	beqz	s2,80002968 <iget+0xac>
  ip->dev = dev;
    80002934:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002938:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000293c:	4785                	li	a5,1
    8000293e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002942:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002946:	00015517          	auipc	a0,0x15
    8000294a:	8a250513          	addi	a0,a0,-1886 # 800171e8 <itable>
    8000294e:	00004097          	auipc	ra,0x4
    80002952:	94a080e7          	jalr	-1718(ra) # 80006298 <release>
}
    80002956:	854a                	mv	a0,s2
    80002958:	70a2                	ld	ra,40(sp)
    8000295a:	7402                	ld	s0,32(sp)
    8000295c:	64e2                	ld	s1,24(sp)
    8000295e:	6942                	ld	s2,16(sp)
    80002960:	69a2                	ld	s3,8(sp)
    80002962:	6a02                	ld	s4,0(sp)
    80002964:	6145                	addi	sp,sp,48
    80002966:	8082                	ret
    panic("iget: no inodes");
    80002968:	00006517          	auipc	a0,0x6
    8000296c:	c7050513          	addi	a0,a0,-912 # 800085d8 <syscalls+0x140>
    80002970:	00003097          	auipc	ra,0x3
    80002974:	33c080e7          	jalr	828(ra) # 80005cac <panic>

0000000080002978 <fsinit>:
fsinit(int dev) {
    80002978:	7179                	addi	sp,sp,-48
    8000297a:	f406                	sd	ra,40(sp)
    8000297c:	f022                	sd	s0,32(sp)
    8000297e:	ec26                	sd	s1,24(sp)
    80002980:	e84a                	sd	s2,16(sp)
    80002982:	e44e                	sd	s3,8(sp)
    80002984:	1800                	addi	s0,sp,48
    80002986:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002988:	4585                	li	a1,1
    8000298a:	00000097          	auipc	ra,0x0
    8000298e:	a54080e7          	jalr	-1452(ra) # 800023de <bread>
    80002992:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002994:	00015997          	auipc	s3,0x15
    80002998:	83498993          	addi	s3,s3,-1996 # 800171c8 <sb>
    8000299c:	02000613          	li	a2,32
    800029a0:	05850593          	addi	a1,a0,88
    800029a4:	854e                	mv	a0,s3
    800029a6:	ffffe097          	auipc	ra,0xffffe
    800029aa:	854080e7          	jalr	-1964(ra) # 800001fa <memmove>
  brelse(bp);
    800029ae:	8526                	mv	a0,s1
    800029b0:	00000097          	auipc	ra,0x0
    800029b4:	b5e080e7          	jalr	-1186(ra) # 8000250e <brelse>
  if(sb.magic != FSMAGIC)
    800029b8:	0009a703          	lw	a4,0(s3)
    800029bc:	102037b7          	lui	a5,0x10203
    800029c0:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029c4:	02f71263          	bne	a4,a5,800029e8 <fsinit+0x70>
  initlog(dev, &sb);
    800029c8:	00015597          	auipc	a1,0x15
    800029cc:	80058593          	addi	a1,a1,-2048 # 800171c8 <sb>
    800029d0:	854a                	mv	a0,s2
    800029d2:	00001097          	auipc	ra,0x1
    800029d6:	b4a080e7          	jalr	-1206(ra) # 8000351c <initlog>
}
    800029da:	70a2                	ld	ra,40(sp)
    800029dc:	7402                	ld	s0,32(sp)
    800029de:	64e2                	ld	s1,24(sp)
    800029e0:	6942                	ld	s2,16(sp)
    800029e2:	69a2                	ld	s3,8(sp)
    800029e4:	6145                	addi	sp,sp,48
    800029e6:	8082                	ret
    panic("invalid file system");
    800029e8:	00006517          	auipc	a0,0x6
    800029ec:	c0050513          	addi	a0,a0,-1024 # 800085e8 <syscalls+0x150>
    800029f0:	00003097          	auipc	ra,0x3
    800029f4:	2bc080e7          	jalr	700(ra) # 80005cac <panic>

00000000800029f8 <iinit>:
{
    800029f8:	7179                	addi	sp,sp,-48
    800029fa:	f406                	sd	ra,40(sp)
    800029fc:	f022                	sd	s0,32(sp)
    800029fe:	ec26                	sd	s1,24(sp)
    80002a00:	e84a                	sd	s2,16(sp)
    80002a02:	e44e                	sd	s3,8(sp)
    80002a04:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a06:	00006597          	auipc	a1,0x6
    80002a0a:	bfa58593          	addi	a1,a1,-1030 # 80008600 <syscalls+0x168>
    80002a0e:	00014517          	auipc	a0,0x14
    80002a12:	7da50513          	addi	a0,a0,2010 # 800171e8 <itable>
    80002a16:	00003097          	auipc	ra,0x3
    80002a1a:	73e080e7          	jalr	1854(ra) # 80006154 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a1e:	00014497          	auipc	s1,0x14
    80002a22:	7f248493          	addi	s1,s1,2034 # 80017210 <itable+0x28>
    80002a26:	00016997          	auipc	s3,0x16
    80002a2a:	27a98993          	addi	s3,s3,634 # 80018ca0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a2e:	00006917          	auipc	s2,0x6
    80002a32:	bda90913          	addi	s2,s2,-1062 # 80008608 <syscalls+0x170>
    80002a36:	85ca                	mv	a1,s2
    80002a38:	8526                	mv	a0,s1
    80002a3a:	00001097          	auipc	ra,0x1
    80002a3e:	e42080e7          	jalr	-446(ra) # 8000387c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a42:	08848493          	addi	s1,s1,136
    80002a46:	ff3498e3          	bne	s1,s3,80002a36 <iinit+0x3e>
}
    80002a4a:	70a2                	ld	ra,40(sp)
    80002a4c:	7402                	ld	s0,32(sp)
    80002a4e:	64e2                	ld	s1,24(sp)
    80002a50:	6942                	ld	s2,16(sp)
    80002a52:	69a2                	ld	s3,8(sp)
    80002a54:	6145                	addi	sp,sp,48
    80002a56:	8082                	ret

0000000080002a58 <ialloc>:
{
    80002a58:	715d                	addi	sp,sp,-80
    80002a5a:	e486                	sd	ra,72(sp)
    80002a5c:	e0a2                	sd	s0,64(sp)
    80002a5e:	fc26                	sd	s1,56(sp)
    80002a60:	f84a                	sd	s2,48(sp)
    80002a62:	f44e                	sd	s3,40(sp)
    80002a64:	f052                	sd	s4,32(sp)
    80002a66:	ec56                	sd	s5,24(sp)
    80002a68:	e85a                	sd	s6,16(sp)
    80002a6a:	e45e                	sd	s7,8(sp)
    80002a6c:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a6e:	00014717          	auipc	a4,0x14
    80002a72:	76672703          	lw	a4,1894(a4) # 800171d4 <sb+0xc>
    80002a76:	4785                	li	a5,1
    80002a78:	04e7fa63          	bgeu	a5,a4,80002acc <ialloc+0x74>
    80002a7c:	8aaa                	mv	s5,a0
    80002a7e:	8bae                	mv	s7,a1
    80002a80:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a82:	00014a17          	auipc	s4,0x14
    80002a86:	746a0a13          	addi	s4,s4,1862 # 800171c8 <sb>
    80002a8a:	00048b1b          	sext.w	s6,s1
    80002a8e:	0044d593          	srli	a1,s1,0x4
    80002a92:	018a2783          	lw	a5,24(s4)
    80002a96:	9dbd                	addw	a1,a1,a5
    80002a98:	8556                	mv	a0,s5
    80002a9a:	00000097          	auipc	ra,0x0
    80002a9e:	944080e7          	jalr	-1724(ra) # 800023de <bread>
    80002aa2:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002aa4:	05850993          	addi	s3,a0,88
    80002aa8:	00f4f793          	andi	a5,s1,15
    80002aac:	079a                	slli	a5,a5,0x6
    80002aae:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002ab0:	00099783          	lh	a5,0(s3)
    80002ab4:	c3a1                	beqz	a5,80002af4 <ialloc+0x9c>
    brelse(bp);
    80002ab6:	00000097          	auipc	ra,0x0
    80002aba:	a58080e7          	jalr	-1448(ra) # 8000250e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002abe:	0485                	addi	s1,s1,1
    80002ac0:	00ca2703          	lw	a4,12(s4)
    80002ac4:	0004879b          	sext.w	a5,s1
    80002ac8:	fce7e1e3          	bltu	a5,a4,80002a8a <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002acc:	00006517          	auipc	a0,0x6
    80002ad0:	b4450513          	addi	a0,a0,-1212 # 80008610 <syscalls+0x178>
    80002ad4:	00003097          	auipc	ra,0x3
    80002ad8:	222080e7          	jalr	546(ra) # 80005cf6 <printf>
  return 0;
    80002adc:	4501                	li	a0,0
}
    80002ade:	60a6                	ld	ra,72(sp)
    80002ae0:	6406                	ld	s0,64(sp)
    80002ae2:	74e2                	ld	s1,56(sp)
    80002ae4:	7942                	ld	s2,48(sp)
    80002ae6:	79a2                	ld	s3,40(sp)
    80002ae8:	7a02                	ld	s4,32(sp)
    80002aea:	6ae2                	ld	s5,24(sp)
    80002aec:	6b42                	ld	s6,16(sp)
    80002aee:	6ba2                	ld	s7,8(sp)
    80002af0:	6161                	addi	sp,sp,80
    80002af2:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002af4:	04000613          	li	a2,64
    80002af8:	4581                	li	a1,0
    80002afa:	854e                	mv	a0,s3
    80002afc:	ffffd097          	auipc	ra,0xffffd
    80002b00:	6a2080e7          	jalr	1698(ra) # 8000019e <memset>
      dip->type = type;
    80002b04:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b08:	854a                	mv	a0,s2
    80002b0a:	00001097          	auipc	ra,0x1
    80002b0e:	c8e080e7          	jalr	-882(ra) # 80003798 <log_write>
      brelse(bp);
    80002b12:	854a                	mv	a0,s2
    80002b14:	00000097          	auipc	ra,0x0
    80002b18:	9fa080e7          	jalr	-1542(ra) # 8000250e <brelse>
      return iget(dev, inum);
    80002b1c:	85da                	mv	a1,s6
    80002b1e:	8556                	mv	a0,s5
    80002b20:	00000097          	auipc	ra,0x0
    80002b24:	d9c080e7          	jalr	-612(ra) # 800028bc <iget>
    80002b28:	bf5d                	j	80002ade <ialloc+0x86>

0000000080002b2a <iupdate>:
{
    80002b2a:	1101                	addi	sp,sp,-32
    80002b2c:	ec06                	sd	ra,24(sp)
    80002b2e:	e822                	sd	s0,16(sp)
    80002b30:	e426                	sd	s1,8(sp)
    80002b32:	e04a                	sd	s2,0(sp)
    80002b34:	1000                	addi	s0,sp,32
    80002b36:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b38:	415c                	lw	a5,4(a0)
    80002b3a:	0047d79b          	srliw	a5,a5,0x4
    80002b3e:	00014597          	auipc	a1,0x14
    80002b42:	6a25a583          	lw	a1,1698(a1) # 800171e0 <sb+0x18>
    80002b46:	9dbd                	addw	a1,a1,a5
    80002b48:	4108                	lw	a0,0(a0)
    80002b4a:	00000097          	auipc	ra,0x0
    80002b4e:	894080e7          	jalr	-1900(ra) # 800023de <bread>
    80002b52:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b54:	05850793          	addi	a5,a0,88
    80002b58:	40d8                	lw	a4,4(s1)
    80002b5a:	8b3d                	andi	a4,a4,15
    80002b5c:	071a                	slli	a4,a4,0x6
    80002b5e:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b60:	04449703          	lh	a4,68(s1)
    80002b64:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b68:	04649703          	lh	a4,70(s1)
    80002b6c:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b70:	04849703          	lh	a4,72(s1)
    80002b74:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b78:	04a49703          	lh	a4,74(s1)
    80002b7c:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002b80:	44f8                	lw	a4,76(s1)
    80002b82:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b84:	03400613          	li	a2,52
    80002b88:	05048593          	addi	a1,s1,80
    80002b8c:	00c78513          	addi	a0,a5,12
    80002b90:	ffffd097          	auipc	ra,0xffffd
    80002b94:	66a080e7          	jalr	1642(ra) # 800001fa <memmove>
  log_write(bp);
    80002b98:	854a                	mv	a0,s2
    80002b9a:	00001097          	auipc	ra,0x1
    80002b9e:	bfe080e7          	jalr	-1026(ra) # 80003798 <log_write>
  brelse(bp);
    80002ba2:	854a                	mv	a0,s2
    80002ba4:	00000097          	auipc	ra,0x0
    80002ba8:	96a080e7          	jalr	-1686(ra) # 8000250e <brelse>
}
    80002bac:	60e2                	ld	ra,24(sp)
    80002bae:	6442                	ld	s0,16(sp)
    80002bb0:	64a2                	ld	s1,8(sp)
    80002bb2:	6902                	ld	s2,0(sp)
    80002bb4:	6105                	addi	sp,sp,32
    80002bb6:	8082                	ret

0000000080002bb8 <idup>:
{
    80002bb8:	1101                	addi	sp,sp,-32
    80002bba:	ec06                	sd	ra,24(sp)
    80002bbc:	e822                	sd	s0,16(sp)
    80002bbe:	e426                	sd	s1,8(sp)
    80002bc0:	1000                	addi	s0,sp,32
    80002bc2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bc4:	00014517          	auipc	a0,0x14
    80002bc8:	62450513          	addi	a0,a0,1572 # 800171e8 <itable>
    80002bcc:	00003097          	auipc	ra,0x3
    80002bd0:	618080e7          	jalr	1560(ra) # 800061e4 <acquire>
  ip->ref++;
    80002bd4:	449c                	lw	a5,8(s1)
    80002bd6:	2785                	addiw	a5,a5,1
    80002bd8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bda:	00014517          	auipc	a0,0x14
    80002bde:	60e50513          	addi	a0,a0,1550 # 800171e8 <itable>
    80002be2:	00003097          	auipc	ra,0x3
    80002be6:	6b6080e7          	jalr	1718(ra) # 80006298 <release>
}
    80002bea:	8526                	mv	a0,s1
    80002bec:	60e2                	ld	ra,24(sp)
    80002bee:	6442                	ld	s0,16(sp)
    80002bf0:	64a2                	ld	s1,8(sp)
    80002bf2:	6105                	addi	sp,sp,32
    80002bf4:	8082                	ret

0000000080002bf6 <ilock>:
{
    80002bf6:	1101                	addi	sp,sp,-32
    80002bf8:	ec06                	sd	ra,24(sp)
    80002bfa:	e822                	sd	s0,16(sp)
    80002bfc:	e426                	sd	s1,8(sp)
    80002bfe:	e04a                	sd	s2,0(sp)
    80002c00:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c02:	c115                	beqz	a0,80002c26 <ilock+0x30>
    80002c04:	84aa                	mv	s1,a0
    80002c06:	451c                	lw	a5,8(a0)
    80002c08:	00f05f63          	blez	a5,80002c26 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c0c:	0541                	addi	a0,a0,16
    80002c0e:	00001097          	auipc	ra,0x1
    80002c12:	ca8080e7          	jalr	-856(ra) # 800038b6 <acquiresleep>
  if(ip->valid == 0){
    80002c16:	40bc                	lw	a5,64(s1)
    80002c18:	cf99                	beqz	a5,80002c36 <ilock+0x40>
}
    80002c1a:	60e2                	ld	ra,24(sp)
    80002c1c:	6442                	ld	s0,16(sp)
    80002c1e:	64a2                	ld	s1,8(sp)
    80002c20:	6902                	ld	s2,0(sp)
    80002c22:	6105                	addi	sp,sp,32
    80002c24:	8082                	ret
    panic("ilock");
    80002c26:	00006517          	auipc	a0,0x6
    80002c2a:	a0250513          	addi	a0,a0,-1534 # 80008628 <syscalls+0x190>
    80002c2e:	00003097          	auipc	ra,0x3
    80002c32:	07e080e7          	jalr	126(ra) # 80005cac <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c36:	40dc                	lw	a5,4(s1)
    80002c38:	0047d79b          	srliw	a5,a5,0x4
    80002c3c:	00014597          	auipc	a1,0x14
    80002c40:	5a45a583          	lw	a1,1444(a1) # 800171e0 <sb+0x18>
    80002c44:	9dbd                	addw	a1,a1,a5
    80002c46:	4088                	lw	a0,0(s1)
    80002c48:	fffff097          	auipc	ra,0xfffff
    80002c4c:	796080e7          	jalr	1942(ra) # 800023de <bread>
    80002c50:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c52:	05850593          	addi	a1,a0,88
    80002c56:	40dc                	lw	a5,4(s1)
    80002c58:	8bbd                	andi	a5,a5,15
    80002c5a:	079a                	slli	a5,a5,0x6
    80002c5c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c5e:	00059783          	lh	a5,0(a1)
    80002c62:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c66:	00259783          	lh	a5,2(a1)
    80002c6a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c6e:	00459783          	lh	a5,4(a1)
    80002c72:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c76:	00659783          	lh	a5,6(a1)
    80002c7a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c7e:	459c                	lw	a5,8(a1)
    80002c80:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c82:	03400613          	li	a2,52
    80002c86:	05b1                	addi	a1,a1,12
    80002c88:	05048513          	addi	a0,s1,80
    80002c8c:	ffffd097          	auipc	ra,0xffffd
    80002c90:	56e080e7          	jalr	1390(ra) # 800001fa <memmove>
    brelse(bp);
    80002c94:	854a                	mv	a0,s2
    80002c96:	00000097          	auipc	ra,0x0
    80002c9a:	878080e7          	jalr	-1928(ra) # 8000250e <brelse>
    ip->valid = 1;
    80002c9e:	4785                	li	a5,1
    80002ca0:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002ca2:	04449783          	lh	a5,68(s1)
    80002ca6:	fbb5                	bnez	a5,80002c1a <ilock+0x24>
      panic("ilock: no type");
    80002ca8:	00006517          	auipc	a0,0x6
    80002cac:	98850513          	addi	a0,a0,-1656 # 80008630 <syscalls+0x198>
    80002cb0:	00003097          	auipc	ra,0x3
    80002cb4:	ffc080e7          	jalr	-4(ra) # 80005cac <panic>

0000000080002cb8 <iunlock>:
{
    80002cb8:	1101                	addi	sp,sp,-32
    80002cba:	ec06                	sd	ra,24(sp)
    80002cbc:	e822                	sd	s0,16(sp)
    80002cbe:	e426                	sd	s1,8(sp)
    80002cc0:	e04a                	sd	s2,0(sp)
    80002cc2:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002cc4:	c905                	beqz	a0,80002cf4 <iunlock+0x3c>
    80002cc6:	84aa                	mv	s1,a0
    80002cc8:	01050913          	addi	s2,a0,16
    80002ccc:	854a                	mv	a0,s2
    80002cce:	00001097          	auipc	ra,0x1
    80002cd2:	c82080e7          	jalr	-894(ra) # 80003950 <holdingsleep>
    80002cd6:	cd19                	beqz	a0,80002cf4 <iunlock+0x3c>
    80002cd8:	449c                	lw	a5,8(s1)
    80002cda:	00f05d63          	blez	a5,80002cf4 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002cde:	854a                	mv	a0,s2
    80002ce0:	00001097          	auipc	ra,0x1
    80002ce4:	c2c080e7          	jalr	-980(ra) # 8000390c <releasesleep>
}
    80002ce8:	60e2                	ld	ra,24(sp)
    80002cea:	6442                	ld	s0,16(sp)
    80002cec:	64a2                	ld	s1,8(sp)
    80002cee:	6902                	ld	s2,0(sp)
    80002cf0:	6105                	addi	sp,sp,32
    80002cf2:	8082                	ret
    panic("iunlock");
    80002cf4:	00006517          	auipc	a0,0x6
    80002cf8:	94c50513          	addi	a0,a0,-1716 # 80008640 <syscalls+0x1a8>
    80002cfc:	00003097          	auipc	ra,0x3
    80002d00:	fb0080e7          	jalr	-80(ra) # 80005cac <panic>

0000000080002d04 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d04:	7179                	addi	sp,sp,-48
    80002d06:	f406                	sd	ra,40(sp)
    80002d08:	f022                	sd	s0,32(sp)
    80002d0a:	ec26                	sd	s1,24(sp)
    80002d0c:	e84a                	sd	s2,16(sp)
    80002d0e:	e44e                	sd	s3,8(sp)
    80002d10:	e052                	sd	s4,0(sp)
    80002d12:	1800                	addi	s0,sp,48
    80002d14:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d16:	05050493          	addi	s1,a0,80
    80002d1a:	08050913          	addi	s2,a0,128
    80002d1e:	a021                	j	80002d26 <itrunc+0x22>
    80002d20:	0491                	addi	s1,s1,4
    80002d22:	01248d63          	beq	s1,s2,80002d3c <itrunc+0x38>
    if(ip->addrs[i]){
    80002d26:	408c                	lw	a1,0(s1)
    80002d28:	dde5                	beqz	a1,80002d20 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d2a:	0009a503          	lw	a0,0(s3)
    80002d2e:	00000097          	auipc	ra,0x0
    80002d32:	8f6080e7          	jalr	-1802(ra) # 80002624 <bfree>
      ip->addrs[i] = 0;
    80002d36:	0004a023          	sw	zero,0(s1)
    80002d3a:	b7dd                	j	80002d20 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d3c:	0809a583          	lw	a1,128(s3)
    80002d40:	e185                	bnez	a1,80002d60 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d42:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d46:	854e                	mv	a0,s3
    80002d48:	00000097          	auipc	ra,0x0
    80002d4c:	de2080e7          	jalr	-542(ra) # 80002b2a <iupdate>
}
    80002d50:	70a2                	ld	ra,40(sp)
    80002d52:	7402                	ld	s0,32(sp)
    80002d54:	64e2                	ld	s1,24(sp)
    80002d56:	6942                	ld	s2,16(sp)
    80002d58:	69a2                	ld	s3,8(sp)
    80002d5a:	6a02                	ld	s4,0(sp)
    80002d5c:	6145                	addi	sp,sp,48
    80002d5e:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d60:	0009a503          	lw	a0,0(s3)
    80002d64:	fffff097          	auipc	ra,0xfffff
    80002d68:	67a080e7          	jalr	1658(ra) # 800023de <bread>
    80002d6c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d6e:	05850493          	addi	s1,a0,88
    80002d72:	45850913          	addi	s2,a0,1112
    80002d76:	a021                	j	80002d7e <itrunc+0x7a>
    80002d78:	0491                	addi	s1,s1,4
    80002d7a:	01248b63          	beq	s1,s2,80002d90 <itrunc+0x8c>
      if(a[j])
    80002d7e:	408c                	lw	a1,0(s1)
    80002d80:	dde5                	beqz	a1,80002d78 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002d82:	0009a503          	lw	a0,0(s3)
    80002d86:	00000097          	auipc	ra,0x0
    80002d8a:	89e080e7          	jalr	-1890(ra) # 80002624 <bfree>
    80002d8e:	b7ed                	j	80002d78 <itrunc+0x74>
    brelse(bp);
    80002d90:	8552                	mv	a0,s4
    80002d92:	fffff097          	auipc	ra,0xfffff
    80002d96:	77c080e7          	jalr	1916(ra) # 8000250e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d9a:	0809a583          	lw	a1,128(s3)
    80002d9e:	0009a503          	lw	a0,0(s3)
    80002da2:	00000097          	auipc	ra,0x0
    80002da6:	882080e7          	jalr	-1918(ra) # 80002624 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002daa:	0809a023          	sw	zero,128(s3)
    80002dae:	bf51                	j	80002d42 <itrunc+0x3e>

0000000080002db0 <iput>:
{
    80002db0:	1101                	addi	sp,sp,-32
    80002db2:	ec06                	sd	ra,24(sp)
    80002db4:	e822                	sd	s0,16(sp)
    80002db6:	e426                	sd	s1,8(sp)
    80002db8:	e04a                	sd	s2,0(sp)
    80002dba:	1000                	addi	s0,sp,32
    80002dbc:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dbe:	00014517          	auipc	a0,0x14
    80002dc2:	42a50513          	addi	a0,a0,1066 # 800171e8 <itable>
    80002dc6:	00003097          	auipc	ra,0x3
    80002dca:	41e080e7          	jalr	1054(ra) # 800061e4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dce:	4498                	lw	a4,8(s1)
    80002dd0:	4785                	li	a5,1
    80002dd2:	02f70363          	beq	a4,a5,80002df8 <iput+0x48>
  ip->ref--;
    80002dd6:	449c                	lw	a5,8(s1)
    80002dd8:	37fd                	addiw	a5,a5,-1
    80002dda:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ddc:	00014517          	auipc	a0,0x14
    80002de0:	40c50513          	addi	a0,a0,1036 # 800171e8 <itable>
    80002de4:	00003097          	auipc	ra,0x3
    80002de8:	4b4080e7          	jalr	1204(ra) # 80006298 <release>
}
    80002dec:	60e2                	ld	ra,24(sp)
    80002dee:	6442                	ld	s0,16(sp)
    80002df0:	64a2                	ld	s1,8(sp)
    80002df2:	6902                	ld	s2,0(sp)
    80002df4:	6105                	addi	sp,sp,32
    80002df6:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002df8:	40bc                	lw	a5,64(s1)
    80002dfa:	dff1                	beqz	a5,80002dd6 <iput+0x26>
    80002dfc:	04a49783          	lh	a5,74(s1)
    80002e00:	fbf9                	bnez	a5,80002dd6 <iput+0x26>
    acquiresleep(&ip->lock);
    80002e02:	01048913          	addi	s2,s1,16
    80002e06:	854a                	mv	a0,s2
    80002e08:	00001097          	auipc	ra,0x1
    80002e0c:	aae080e7          	jalr	-1362(ra) # 800038b6 <acquiresleep>
    release(&itable.lock);
    80002e10:	00014517          	auipc	a0,0x14
    80002e14:	3d850513          	addi	a0,a0,984 # 800171e8 <itable>
    80002e18:	00003097          	auipc	ra,0x3
    80002e1c:	480080e7          	jalr	1152(ra) # 80006298 <release>
    itrunc(ip);
    80002e20:	8526                	mv	a0,s1
    80002e22:	00000097          	auipc	ra,0x0
    80002e26:	ee2080e7          	jalr	-286(ra) # 80002d04 <itrunc>
    ip->type = 0;
    80002e2a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e2e:	8526                	mv	a0,s1
    80002e30:	00000097          	auipc	ra,0x0
    80002e34:	cfa080e7          	jalr	-774(ra) # 80002b2a <iupdate>
    ip->valid = 0;
    80002e38:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e3c:	854a                	mv	a0,s2
    80002e3e:	00001097          	auipc	ra,0x1
    80002e42:	ace080e7          	jalr	-1330(ra) # 8000390c <releasesleep>
    acquire(&itable.lock);
    80002e46:	00014517          	auipc	a0,0x14
    80002e4a:	3a250513          	addi	a0,a0,930 # 800171e8 <itable>
    80002e4e:	00003097          	auipc	ra,0x3
    80002e52:	396080e7          	jalr	918(ra) # 800061e4 <acquire>
    80002e56:	b741                	j	80002dd6 <iput+0x26>

0000000080002e58 <iunlockput>:
{
    80002e58:	1101                	addi	sp,sp,-32
    80002e5a:	ec06                	sd	ra,24(sp)
    80002e5c:	e822                	sd	s0,16(sp)
    80002e5e:	e426                	sd	s1,8(sp)
    80002e60:	1000                	addi	s0,sp,32
    80002e62:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e64:	00000097          	auipc	ra,0x0
    80002e68:	e54080e7          	jalr	-428(ra) # 80002cb8 <iunlock>
  iput(ip);
    80002e6c:	8526                	mv	a0,s1
    80002e6e:	00000097          	auipc	ra,0x0
    80002e72:	f42080e7          	jalr	-190(ra) # 80002db0 <iput>
}
    80002e76:	60e2                	ld	ra,24(sp)
    80002e78:	6442                	ld	s0,16(sp)
    80002e7a:	64a2                	ld	s1,8(sp)
    80002e7c:	6105                	addi	sp,sp,32
    80002e7e:	8082                	ret

0000000080002e80 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e80:	1141                	addi	sp,sp,-16
    80002e82:	e422                	sd	s0,8(sp)
    80002e84:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e86:	411c                	lw	a5,0(a0)
    80002e88:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e8a:	415c                	lw	a5,4(a0)
    80002e8c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e8e:	04451783          	lh	a5,68(a0)
    80002e92:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e96:	04a51783          	lh	a5,74(a0)
    80002e9a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e9e:	04c56783          	lwu	a5,76(a0)
    80002ea2:	e99c                	sd	a5,16(a1)
}
    80002ea4:	6422                	ld	s0,8(sp)
    80002ea6:	0141                	addi	sp,sp,16
    80002ea8:	8082                	ret

0000000080002eaa <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002eaa:	457c                	lw	a5,76(a0)
    80002eac:	0ed7e963          	bltu	a5,a3,80002f9e <readi+0xf4>
{
    80002eb0:	7159                	addi	sp,sp,-112
    80002eb2:	f486                	sd	ra,104(sp)
    80002eb4:	f0a2                	sd	s0,96(sp)
    80002eb6:	eca6                	sd	s1,88(sp)
    80002eb8:	e8ca                	sd	s2,80(sp)
    80002eba:	e4ce                	sd	s3,72(sp)
    80002ebc:	e0d2                	sd	s4,64(sp)
    80002ebe:	fc56                	sd	s5,56(sp)
    80002ec0:	f85a                	sd	s6,48(sp)
    80002ec2:	f45e                	sd	s7,40(sp)
    80002ec4:	f062                	sd	s8,32(sp)
    80002ec6:	ec66                	sd	s9,24(sp)
    80002ec8:	e86a                	sd	s10,16(sp)
    80002eca:	e46e                	sd	s11,8(sp)
    80002ecc:	1880                	addi	s0,sp,112
    80002ece:	8b2a                	mv	s6,a0
    80002ed0:	8bae                	mv	s7,a1
    80002ed2:	8a32                	mv	s4,a2
    80002ed4:	84b6                	mv	s1,a3
    80002ed6:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002ed8:	9f35                	addw	a4,a4,a3
    return 0;
    80002eda:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002edc:	0ad76063          	bltu	a4,a3,80002f7c <readi+0xd2>
  if(off + n > ip->size)
    80002ee0:	00e7f463          	bgeu	a5,a4,80002ee8 <readi+0x3e>
    n = ip->size - off;
    80002ee4:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ee8:	0a0a8963          	beqz	s5,80002f9a <readi+0xf0>
    80002eec:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002eee:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ef2:	5c7d                	li	s8,-1
    80002ef4:	a82d                	j	80002f2e <readi+0x84>
    80002ef6:	020d1d93          	slli	s11,s10,0x20
    80002efa:	020ddd93          	srli	s11,s11,0x20
    80002efe:	05890613          	addi	a2,s2,88
    80002f02:	86ee                	mv	a3,s11
    80002f04:	963a                	add	a2,a2,a4
    80002f06:	85d2                	mv	a1,s4
    80002f08:	855e                	mv	a0,s7
    80002f0a:	fffff097          	auipc	ra,0xfffff
    80002f0e:	a26080e7          	jalr	-1498(ra) # 80001930 <either_copyout>
    80002f12:	05850d63          	beq	a0,s8,80002f6c <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f16:	854a                	mv	a0,s2
    80002f18:	fffff097          	auipc	ra,0xfffff
    80002f1c:	5f6080e7          	jalr	1526(ra) # 8000250e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f20:	013d09bb          	addw	s3,s10,s3
    80002f24:	009d04bb          	addw	s1,s10,s1
    80002f28:	9a6e                	add	s4,s4,s11
    80002f2a:	0559f763          	bgeu	s3,s5,80002f78 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002f2e:	00a4d59b          	srliw	a1,s1,0xa
    80002f32:	855a                	mv	a0,s6
    80002f34:	00000097          	auipc	ra,0x0
    80002f38:	89e080e7          	jalr	-1890(ra) # 800027d2 <bmap>
    80002f3c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f40:	cd85                	beqz	a1,80002f78 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002f42:	000b2503          	lw	a0,0(s6)
    80002f46:	fffff097          	auipc	ra,0xfffff
    80002f4a:	498080e7          	jalr	1176(ra) # 800023de <bread>
    80002f4e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f50:	3ff4f713          	andi	a4,s1,1023
    80002f54:	40ec87bb          	subw	a5,s9,a4
    80002f58:	413a86bb          	subw	a3,s5,s3
    80002f5c:	8d3e                	mv	s10,a5
    80002f5e:	2781                	sext.w	a5,a5
    80002f60:	0006861b          	sext.w	a2,a3
    80002f64:	f8f679e3          	bgeu	a2,a5,80002ef6 <readi+0x4c>
    80002f68:	8d36                	mv	s10,a3
    80002f6a:	b771                	j	80002ef6 <readi+0x4c>
      brelse(bp);
    80002f6c:	854a                	mv	a0,s2
    80002f6e:	fffff097          	auipc	ra,0xfffff
    80002f72:	5a0080e7          	jalr	1440(ra) # 8000250e <brelse>
      tot = -1;
    80002f76:	59fd                	li	s3,-1
  }
  return tot;
    80002f78:	0009851b          	sext.w	a0,s3
}
    80002f7c:	70a6                	ld	ra,104(sp)
    80002f7e:	7406                	ld	s0,96(sp)
    80002f80:	64e6                	ld	s1,88(sp)
    80002f82:	6946                	ld	s2,80(sp)
    80002f84:	69a6                	ld	s3,72(sp)
    80002f86:	6a06                	ld	s4,64(sp)
    80002f88:	7ae2                	ld	s5,56(sp)
    80002f8a:	7b42                	ld	s6,48(sp)
    80002f8c:	7ba2                	ld	s7,40(sp)
    80002f8e:	7c02                	ld	s8,32(sp)
    80002f90:	6ce2                	ld	s9,24(sp)
    80002f92:	6d42                	ld	s10,16(sp)
    80002f94:	6da2                	ld	s11,8(sp)
    80002f96:	6165                	addi	sp,sp,112
    80002f98:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f9a:	89d6                	mv	s3,s5
    80002f9c:	bff1                	j	80002f78 <readi+0xce>
    return 0;
    80002f9e:	4501                	li	a0,0
}
    80002fa0:	8082                	ret

0000000080002fa2 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fa2:	457c                	lw	a5,76(a0)
    80002fa4:	10d7e863          	bltu	a5,a3,800030b4 <writei+0x112>
{
    80002fa8:	7159                	addi	sp,sp,-112
    80002faa:	f486                	sd	ra,104(sp)
    80002fac:	f0a2                	sd	s0,96(sp)
    80002fae:	eca6                	sd	s1,88(sp)
    80002fb0:	e8ca                	sd	s2,80(sp)
    80002fb2:	e4ce                	sd	s3,72(sp)
    80002fb4:	e0d2                	sd	s4,64(sp)
    80002fb6:	fc56                	sd	s5,56(sp)
    80002fb8:	f85a                	sd	s6,48(sp)
    80002fba:	f45e                	sd	s7,40(sp)
    80002fbc:	f062                	sd	s8,32(sp)
    80002fbe:	ec66                	sd	s9,24(sp)
    80002fc0:	e86a                	sd	s10,16(sp)
    80002fc2:	e46e                	sd	s11,8(sp)
    80002fc4:	1880                	addi	s0,sp,112
    80002fc6:	8aaa                	mv	s5,a0
    80002fc8:	8bae                	mv	s7,a1
    80002fca:	8a32                	mv	s4,a2
    80002fcc:	8936                	mv	s2,a3
    80002fce:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002fd0:	00e687bb          	addw	a5,a3,a4
    80002fd4:	0ed7e263          	bltu	a5,a3,800030b8 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fd8:	00043737          	lui	a4,0x43
    80002fdc:	0ef76063          	bltu	a4,a5,800030bc <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fe0:	0c0b0863          	beqz	s6,800030b0 <writei+0x10e>
    80002fe4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fe6:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fea:	5c7d                	li	s8,-1
    80002fec:	a091                	j	80003030 <writei+0x8e>
    80002fee:	020d1d93          	slli	s11,s10,0x20
    80002ff2:	020ddd93          	srli	s11,s11,0x20
    80002ff6:	05848513          	addi	a0,s1,88
    80002ffa:	86ee                	mv	a3,s11
    80002ffc:	8652                	mv	a2,s4
    80002ffe:	85de                	mv	a1,s7
    80003000:	953a                	add	a0,a0,a4
    80003002:	fffff097          	auipc	ra,0xfffff
    80003006:	984080e7          	jalr	-1660(ra) # 80001986 <either_copyin>
    8000300a:	07850263          	beq	a0,s8,8000306e <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000300e:	8526                	mv	a0,s1
    80003010:	00000097          	auipc	ra,0x0
    80003014:	788080e7          	jalr	1928(ra) # 80003798 <log_write>
    brelse(bp);
    80003018:	8526                	mv	a0,s1
    8000301a:	fffff097          	auipc	ra,0xfffff
    8000301e:	4f4080e7          	jalr	1268(ra) # 8000250e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003022:	013d09bb          	addw	s3,s10,s3
    80003026:	012d093b          	addw	s2,s10,s2
    8000302a:	9a6e                	add	s4,s4,s11
    8000302c:	0569f663          	bgeu	s3,s6,80003078 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003030:	00a9559b          	srliw	a1,s2,0xa
    80003034:	8556                	mv	a0,s5
    80003036:	fffff097          	auipc	ra,0xfffff
    8000303a:	79c080e7          	jalr	1948(ra) # 800027d2 <bmap>
    8000303e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003042:	c99d                	beqz	a1,80003078 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003044:	000aa503          	lw	a0,0(s5)
    80003048:	fffff097          	auipc	ra,0xfffff
    8000304c:	396080e7          	jalr	918(ra) # 800023de <bread>
    80003050:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003052:	3ff97713          	andi	a4,s2,1023
    80003056:	40ec87bb          	subw	a5,s9,a4
    8000305a:	413b06bb          	subw	a3,s6,s3
    8000305e:	8d3e                	mv	s10,a5
    80003060:	2781                	sext.w	a5,a5
    80003062:	0006861b          	sext.w	a2,a3
    80003066:	f8f674e3          	bgeu	a2,a5,80002fee <writei+0x4c>
    8000306a:	8d36                	mv	s10,a3
    8000306c:	b749                	j	80002fee <writei+0x4c>
      brelse(bp);
    8000306e:	8526                	mv	a0,s1
    80003070:	fffff097          	auipc	ra,0xfffff
    80003074:	49e080e7          	jalr	1182(ra) # 8000250e <brelse>
  }

  if(off > ip->size)
    80003078:	04caa783          	lw	a5,76(s5)
    8000307c:	0127f463          	bgeu	a5,s2,80003084 <writei+0xe2>
    ip->size = off;
    80003080:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003084:	8556                	mv	a0,s5
    80003086:	00000097          	auipc	ra,0x0
    8000308a:	aa4080e7          	jalr	-1372(ra) # 80002b2a <iupdate>

  return tot;
    8000308e:	0009851b          	sext.w	a0,s3
}
    80003092:	70a6                	ld	ra,104(sp)
    80003094:	7406                	ld	s0,96(sp)
    80003096:	64e6                	ld	s1,88(sp)
    80003098:	6946                	ld	s2,80(sp)
    8000309a:	69a6                	ld	s3,72(sp)
    8000309c:	6a06                	ld	s4,64(sp)
    8000309e:	7ae2                	ld	s5,56(sp)
    800030a0:	7b42                	ld	s6,48(sp)
    800030a2:	7ba2                	ld	s7,40(sp)
    800030a4:	7c02                	ld	s8,32(sp)
    800030a6:	6ce2                	ld	s9,24(sp)
    800030a8:	6d42                	ld	s10,16(sp)
    800030aa:	6da2                	ld	s11,8(sp)
    800030ac:	6165                	addi	sp,sp,112
    800030ae:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030b0:	89da                	mv	s3,s6
    800030b2:	bfc9                	j	80003084 <writei+0xe2>
    return -1;
    800030b4:	557d                	li	a0,-1
}
    800030b6:	8082                	ret
    return -1;
    800030b8:	557d                	li	a0,-1
    800030ba:	bfe1                	j	80003092 <writei+0xf0>
    return -1;
    800030bc:	557d                	li	a0,-1
    800030be:	bfd1                	j	80003092 <writei+0xf0>

00000000800030c0 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030c0:	1141                	addi	sp,sp,-16
    800030c2:	e406                	sd	ra,8(sp)
    800030c4:	e022                	sd	s0,0(sp)
    800030c6:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030c8:	4639                	li	a2,14
    800030ca:	ffffd097          	auipc	ra,0xffffd
    800030ce:	1a4080e7          	jalr	420(ra) # 8000026e <strncmp>
}
    800030d2:	60a2                	ld	ra,8(sp)
    800030d4:	6402                	ld	s0,0(sp)
    800030d6:	0141                	addi	sp,sp,16
    800030d8:	8082                	ret

00000000800030da <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030da:	7139                	addi	sp,sp,-64
    800030dc:	fc06                	sd	ra,56(sp)
    800030de:	f822                	sd	s0,48(sp)
    800030e0:	f426                	sd	s1,40(sp)
    800030e2:	f04a                	sd	s2,32(sp)
    800030e4:	ec4e                	sd	s3,24(sp)
    800030e6:	e852                	sd	s4,16(sp)
    800030e8:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030ea:	04451703          	lh	a4,68(a0)
    800030ee:	4785                	li	a5,1
    800030f0:	00f71a63          	bne	a4,a5,80003104 <dirlookup+0x2a>
    800030f4:	892a                	mv	s2,a0
    800030f6:	89ae                	mv	s3,a1
    800030f8:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030fa:	457c                	lw	a5,76(a0)
    800030fc:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030fe:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003100:	e79d                	bnez	a5,8000312e <dirlookup+0x54>
    80003102:	a8a5                	j	8000317a <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003104:	00005517          	auipc	a0,0x5
    80003108:	54450513          	addi	a0,a0,1348 # 80008648 <syscalls+0x1b0>
    8000310c:	00003097          	auipc	ra,0x3
    80003110:	ba0080e7          	jalr	-1120(ra) # 80005cac <panic>
      panic("dirlookup read");
    80003114:	00005517          	auipc	a0,0x5
    80003118:	54c50513          	addi	a0,a0,1356 # 80008660 <syscalls+0x1c8>
    8000311c:	00003097          	auipc	ra,0x3
    80003120:	b90080e7          	jalr	-1136(ra) # 80005cac <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003124:	24c1                	addiw	s1,s1,16
    80003126:	04c92783          	lw	a5,76(s2)
    8000312a:	04f4f763          	bgeu	s1,a5,80003178 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000312e:	4741                	li	a4,16
    80003130:	86a6                	mv	a3,s1
    80003132:	fc040613          	addi	a2,s0,-64
    80003136:	4581                	li	a1,0
    80003138:	854a                	mv	a0,s2
    8000313a:	00000097          	auipc	ra,0x0
    8000313e:	d70080e7          	jalr	-656(ra) # 80002eaa <readi>
    80003142:	47c1                	li	a5,16
    80003144:	fcf518e3          	bne	a0,a5,80003114 <dirlookup+0x3a>
    if(de.inum == 0)
    80003148:	fc045783          	lhu	a5,-64(s0)
    8000314c:	dfe1                	beqz	a5,80003124 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000314e:	fc240593          	addi	a1,s0,-62
    80003152:	854e                	mv	a0,s3
    80003154:	00000097          	auipc	ra,0x0
    80003158:	f6c080e7          	jalr	-148(ra) # 800030c0 <namecmp>
    8000315c:	f561                	bnez	a0,80003124 <dirlookup+0x4a>
      if(poff)
    8000315e:	000a0463          	beqz	s4,80003166 <dirlookup+0x8c>
        *poff = off;
    80003162:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003166:	fc045583          	lhu	a1,-64(s0)
    8000316a:	00092503          	lw	a0,0(s2)
    8000316e:	fffff097          	auipc	ra,0xfffff
    80003172:	74e080e7          	jalr	1870(ra) # 800028bc <iget>
    80003176:	a011                	j	8000317a <dirlookup+0xa0>
  return 0;
    80003178:	4501                	li	a0,0
}
    8000317a:	70e2                	ld	ra,56(sp)
    8000317c:	7442                	ld	s0,48(sp)
    8000317e:	74a2                	ld	s1,40(sp)
    80003180:	7902                	ld	s2,32(sp)
    80003182:	69e2                	ld	s3,24(sp)
    80003184:	6a42                	ld	s4,16(sp)
    80003186:	6121                	addi	sp,sp,64
    80003188:	8082                	ret

000000008000318a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000318a:	711d                	addi	sp,sp,-96
    8000318c:	ec86                	sd	ra,88(sp)
    8000318e:	e8a2                	sd	s0,80(sp)
    80003190:	e4a6                	sd	s1,72(sp)
    80003192:	e0ca                	sd	s2,64(sp)
    80003194:	fc4e                	sd	s3,56(sp)
    80003196:	f852                	sd	s4,48(sp)
    80003198:	f456                	sd	s5,40(sp)
    8000319a:	f05a                	sd	s6,32(sp)
    8000319c:	ec5e                	sd	s7,24(sp)
    8000319e:	e862                	sd	s8,16(sp)
    800031a0:	e466                	sd	s9,8(sp)
    800031a2:	e06a                	sd	s10,0(sp)
    800031a4:	1080                	addi	s0,sp,96
    800031a6:	84aa                	mv	s1,a0
    800031a8:	8b2e                	mv	s6,a1
    800031aa:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031ac:	00054703          	lbu	a4,0(a0)
    800031b0:	02f00793          	li	a5,47
    800031b4:	02f70363          	beq	a4,a5,800031da <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031b8:	ffffe097          	auipc	ra,0xffffe
    800031bc:	cc0080e7          	jalr	-832(ra) # 80000e78 <myproc>
    800031c0:	15053503          	ld	a0,336(a0)
    800031c4:	00000097          	auipc	ra,0x0
    800031c8:	9f4080e7          	jalr	-1548(ra) # 80002bb8 <idup>
    800031cc:	8a2a                	mv	s4,a0
  while(*path == '/')
    800031ce:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800031d2:	4cb5                	li	s9,13
  len = path - s;
    800031d4:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031d6:	4c05                	li	s8,1
    800031d8:	a87d                	j	80003296 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800031da:	4585                	li	a1,1
    800031dc:	4505                	li	a0,1
    800031de:	fffff097          	auipc	ra,0xfffff
    800031e2:	6de080e7          	jalr	1758(ra) # 800028bc <iget>
    800031e6:	8a2a                	mv	s4,a0
    800031e8:	b7dd                	j	800031ce <namex+0x44>
      iunlockput(ip);
    800031ea:	8552                	mv	a0,s4
    800031ec:	00000097          	auipc	ra,0x0
    800031f0:	c6c080e7          	jalr	-916(ra) # 80002e58 <iunlockput>
      return 0;
    800031f4:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031f6:	8552                	mv	a0,s4
    800031f8:	60e6                	ld	ra,88(sp)
    800031fa:	6446                	ld	s0,80(sp)
    800031fc:	64a6                	ld	s1,72(sp)
    800031fe:	6906                	ld	s2,64(sp)
    80003200:	79e2                	ld	s3,56(sp)
    80003202:	7a42                	ld	s4,48(sp)
    80003204:	7aa2                	ld	s5,40(sp)
    80003206:	7b02                	ld	s6,32(sp)
    80003208:	6be2                	ld	s7,24(sp)
    8000320a:	6c42                	ld	s8,16(sp)
    8000320c:	6ca2                	ld	s9,8(sp)
    8000320e:	6d02                	ld	s10,0(sp)
    80003210:	6125                	addi	sp,sp,96
    80003212:	8082                	ret
      iunlock(ip);
    80003214:	8552                	mv	a0,s4
    80003216:	00000097          	auipc	ra,0x0
    8000321a:	aa2080e7          	jalr	-1374(ra) # 80002cb8 <iunlock>
      return ip;
    8000321e:	bfe1                	j	800031f6 <namex+0x6c>
      iunlockput(ip);
    80003220:	8552                	mv	a0,s4
    80003222:	00000097          	auipc	ra,0x0
    80003226:	c36080e7          	jalr	-970(ra) # 80002e58 <iunlockput>
      return 0;
    8000322a:	8a4e                	mv	s4,s3
    8000322c:	b7e9                	j	800031f6 <namex+0x6c>
  len = path - s;
    8000322e:	40998633          	sub	a2,s3,s1
    80003232:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003236:	09acd863          	bge	s9,s10,800032c6 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    8000323a:	4639                	li	a2,14
    8000323c:	85a6                	mv	a1,s1
    8000323e:	8556                	mv	a0,s5
    80003240:	ffffd097          	auipc	ra,0xffffd
    80003244:	fba080e7          	jalr	-70(ra) # 800001fa <memmove>
    80003248:	84ce                	mv	s1,s3
  while(*path == '/')
    8000324a:	0004c783          	lbu	a5,0(s1)
    8000324e:	01279763          	bne	a5,s2,8000325c <namex+0xd2>
    path++;
    80003252:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003254:	0004c783          	lbu	a5,0(s1)
    80003258:	ff278de3          	beq	a5,s2,80003252 <namex+0xc8>
    ilock(ip);
    8000325c:	8552                	mv	a0,s4
    8000325e:	00000097          	auipc	ra,0x0
    80003262:	998080e7          	jalr	-1640(ra) # 80002bf6 <ilock>
    if(ip->type != T_DIR){
    80003266:	044a1783          	lh	a5,68(s4)
    8000326a:	f98790e3          	bne	a5,s8,800031ea <namex+0x60>
    if(nameiparent && *path == '\0'){
    8000326e:	000b0563          	beqz	s6,80003278 <namex+0xee>
    80003272:	0004c783          	lbu	a5,0(s1)
    80003276:	dfd9                	beqz	a5,80003214 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003278:	865e                	mv	a2,s7
    8000327a:	85d6                	mv	a1,s5
    8000327c:	8552                	mv	a0,s4
    8000327e:	00000097          	auipc	ra,0x0
    80003282:	e5c080e7          	jalr	-420(ra) # 800030da <dirlookup>
    80003286:	89aa                	mv	s3,a0
    80003288:	dd41                	beqz	a0,80003220 <namex+0x96>
    iunlockput(ip);
    8000328a:	8552                	mv	a0,s4
    8000328c:	00000097          	auipc	ra,0x0
    80003290:	bcc080e7          	jalr	-1076(ra) # 80002e58 <iunlockput>
    ip = next;
    80003294:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003296:	0004c783          	lbu	a5,0(s1)
    8000329a:	01279763          	bne	a5,s2,800032a8 <namex+0x11e>
    path++;
    8000329e:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032a0:	0004c783          	lbu	a5,0(s1)
    800032a4:	ff278de3          	beq	a5,s2,8000329e <namex+0x114>
  if(*path == 0)
    800032a8:	cb9d                	beqz	a5,800032de <namex+0x154>
  while(*path != '/' && *path != 0)
    800032aa:	0004c783          	lbu	a5,0(s1)
    800032ae:	89a6                	mv	s3,s1
  len = path - s;
    800032b0:	8d5e                	mv	s10,s7
    800032b2:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800032b4:	01278963          	beq	a5,s2,800032c6 <namex+0x13c>
    800032b8:	dbbd                	beqz	a5,8000322e <namex+0xa4>
    path++;
    800032ba:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800032bc:	0009c783          	lbu	a5,0(s3)
    800032c0:	ff279ce3          	bne	a5,s2,800032b8 <namex+0x12e>
    800032c4:	b7ad                	j	8000322e <namex+0xa4>
    memmove(name, s, len);
    800032c6:	2601                	sext.w	a2,a2
    800032c8:	85a6                	mv	a1,s1
    800032ca:	8556                	mv	a0,s5
    800032cc:	ffffd097          	auipc	ra,0xffffd
    800032d0:	f2e080e7          	jalr	-210(ra) # 800001fa <memmove>
    name[len] = 0;
    800032d4:	9d56                	add	s10,s10,s5
    800032d6:	000d0023          	sb	zero,0(s10)
    800032da:	84ce                	mv	s1,s3
    800032dc:	b7bd                	j	8000324a <namex+0xc0>
  if(nameiparent){
    800032de:	f00b0ce3          	beqz	s6,800031f6 <namex+0x6c>
    iput(ip);
    800032e2:	8552                	mv	a0,s4
    800032e4:	00000097          	auipc	ra,0x0
    800032e8:	acc080e7          	jalr	-1332(ra) # 80002db0 <iput>
    return 0;
    800032ec:	4a01                	li	s4,0
    800032ee:	b721                	j	800031f6 <namex+0x6c>

00000000800032f0 <dirlink>:
{
    800032f0:	7139                	addi	sp,sp,-64
    800032f2:	fc06                	sd	ra,56(sp)
    800032f4:	f822                	sd	s0,48(sp)
    800032f6:	f426                	sd	s1,40(sp)
    800032f8:	f04a                	sd	s2,32(sp)
    800032fa:	ec4e                	sd	s3,24(sp)
    800032fc:	e852                	sd	s4,16(sp)
    800032fe:	0080                	addi	s0,sp,64
    80003300:	892a                	mv	s2,a0
    80003302:	8a2e                	mv	s4,a1
    80003304:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003306:	4601                	li	a2,0
    80003308:	00000097          	auipc	ra,0x0
    8000330c:	dd2080e7          	jalr	-558(ra) # 800030da <dirlookup>
    80003310:	e93d                	bnez	a0,80003386 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003312:	04c92483          	lw	s1,76(s2)
    80003316:	c49d                	beqz	s1,80003344 <dirlink+0x54>
    80003318:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000331a:	4741                	li	a4,16
    8000331c:	86a6                	mv	a3,s1
    8000331e:	fc040613          	addi	a2,s0,-64
    80003322:	4581                	li	a1,0
    80003324:	854a                	mv	a0,s2
    80003326:	00000097          	auipc	ra,0x0
    8000332a:	b84080e7          	jalr	-1148(ra) # 80002eaa <readi>
    8000332e:	47c1                	li	a5,16
    80003330:	06f51163          	bne	a0,a5,80003392 <dirlink+0xa2>
    if(de.inum == 0)
    80003334:	fc045783          	lhu	a5,-64(s0)
    80003338:	c791                	beqz	a5,80003344 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000333a:	24c1                	addiw	s1,s1,16
    8000333c:	04c92783          	lw	a5,76(s2)
    80003340:	fcf4ede3          	bltu	s1,a5,8000331a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003344:	4639                	li	a2,14
    80003346:	85d2                	mv	a1,s4
    80003348:	fc240513          	addi	a0,s0,-62
    8000334c:	ffffd097          	auipc	ra,0xffffd
    80003350:	f5e080e7          	jalr	-162(ra) # 800002aa <strncpy>
  de.inum = inum;
    80003354:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003358:	4741                	li	a4,16
    8000335a:	86a6                	mv	a3,s1
    8000335c:	fc040613          	addi	a2,s0,-64
    80003360:	4581                	li	a1,0
    80003362:	854a                	mv	a0,s2
    80003364:	00000097          	auipc	ra,0x0
    80003368:	c3e080e7          	jalr	-962(ra) # 80002fa2 <writei>
    8000336c:	1541                	addi	a0,a0,-16
    8000336e:	00a03533          	snez	a0,a0
    80003372:	40a00533          	neg	a0,a0
}
    80003376:	70e2                	ld	ra,56(sp)
    80003378:	7442                	ld	s0,48(sp)
    8000337a:	74a2                	ld	s1,40(sp)
    8000337c:	7902                	ld	s2,32(sp)
    8000337e:	69e2                	ld	s3,24(sp)
    80003380:	6a42                	ld	s4,16(sp)
    80003382:	6121                	addi	sp,sp,64
    80003384:	8082                	ret
    iput(ip);
    80003386:	00000097          	auipc	ra,0x0
    8000338a:	a2a080e7          	jalr	-1494(ra) # 80002db0 <iput>
    return -1;
    8000338e:	557d                	li	a0,-1
    80003390:	b7dd                	j	80003376 <dirlink+0x86>
      panic("dirlink read");
    80003392:	00005517          	auipc	a0,0x5
    80003396:	2de50513          	addi	a0,a0,734 # 80008670 <syscalls+0x1d8>
    8000339a:	00003097          	auipc	ra,0x3
    8000339e:	912080e7          	jalr	-1774(ra) # 80005cac <panic>

00000000800033a2 <namei>:

struct inode*
namei(char *path)
{
    800033a2:	1101                	addi	sp,sp,-32
    800033a4:	ec06                	sd	ra,24(sp)
    800033a6:	e822                	sd	s0,16(sp)
    800033a8:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033aa:	fe040613          	addi	a2,s0,-32
    800033ae:	4581                	li	a1,0
    800033b0:	00000097          	auipc	ra,0x0
    800033b4:	dda080e7          	jalr	-550(ra) # 8000318a <namex>
}
    800033b8:	60e2                	ld	ra,24(sp)
    800033ba:	6442                	ld	s0,16(sp)
    800033bc:	6105                	addi	sp,sp,32
    800033be:	8082                	ret

00000000800033c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033c0:	1141                	addi	sp,sp,-16
    800033c2:	e406                	sd	ra,8(sp)
    800033c4:	e022                	sd	s0,0(sp)
    800033c6:	0800                	addi	s0,sp,16
    800033c8:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033ca:	4585                	li	a1,1
    800033cc:	00000097          	auipc	ra,0x0
    800033d0:	dbe080e7          	jalr	-578(ra) # 8000318a <namex>
}
    800033d4:	60a2                	ld	ra,8(sp)
    800033d6:	6402                	ld	s0,0(sp)
    800033d8:	0141                	addi	sp,sp,16
    800033da:	8082                	ret

00000000800033dc <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033dc:	1101                	addi	sp,sp,-32
    800033de:	ec06                	sd	ra,24(sp)
    800033e0:	e822                	sd	s0,16(sp)
    800033e2:	e426                	sd	s1,8(sp)
    800033e4:	e04a                	sd	s2,0(sp)
    800033e6:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033e8:	00016917          	auipc	s2,0x16
    800033ec:	8a890913          	addi	s2,s2,-1880 # 80018c90 <log>
    800033f0:	01892583          	lw	a1,24(s2)
    800033f4:	02892503          	lw	a0,40(s2)
    800033f8:	fffff097          	auipc	ra,0xfffff
    800033fc:	fe6080e7          	jalr	-26(ra) # 800023de <bread>
    80003400:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003402:	02c92683          	lw	a3,44(s2)
    80003406:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003408:	02d05863          	blez	a3,80003438 <write_head+0x5c>
    8000340c:	00016797          	auipc	a5,0x16
    80003410:	8b478793          	addi	a5,a5,-1868 # 80018cc0 <log+0x30>
    80003414:	05c50713          	addi	a4,a0,92
    80003418:	36fd                	addiw	a3,a3,-1
    8000341a:	02069613          	slli	a2,a3,0x20
    8000341e:	01e65693          	srli	a3,a2,0x1e
    80003422:	00016617          	auipc	a2,0x16
    80003426:	8a260613          	addi	a2,a2,-1886 # 80018cc4 <log+0x34>
    8000342a:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000342c:	4390                	lw	a2,0(a5)
    8000342e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003430:	0791                	addi	a5,a5,4
    80003432:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    80003434:	fed79ce3          	bne	a5,a3,8000342c <write_head+0x50>
  }
  bwrite(buf);
    80003438:	8526                	mv	a0,s1
    8000343a:	fffff097          	auipc	ra,0xfffff
    8000343e:	096080e7          	jalr	150(ra) # 800024d0 <bwrite>
  brelse(buf);
    80003442:	8526                	mv	a0,s1
    80003444:	fffff097          	auipc	ra,0xfffff
    80003448:	0ca080e7          	jalr	202(ra) # 8000250e <brelse>
}
    8000344c:	60e2                	ld	ra,24(sp)
    8000344e:	6442                	ld	s0,16(sp)
    80003450:	64a2                	ld	s1,8(sp)
    80003452:	6902                	ld	s2,0(sp)
    80003454:	6105                	addi	sp,sp,32
    80003456:	8082                	ret

0000000080003458 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003458:	00016797          	auipc	a5,0x16
    8000345c:	8647a783          	lw	a5,-1948(a5) # 80018cbc <log+0x2c>
    80003460:	0af05d63          	blez	a5,8000351a <install_trans+0xc2>
{
    80003464:	7139                	addi	sp,sp,-64
    80003466:	fc06                	sd	ra,56(sp)
    80003468:	f822                	sd	s0,48(sp)
    8000346a:	f426                	sd	s1,40(sp)
    8000346c:	f04a                	sd	s2,32(sp)
    8000346e:	ec4e                	sd	s3,24(sp)
    80003470:	e852                	sd	s4,16(sp)
    80003472:	e456                	sd	s5,8(sp)
    80003474:	e05a                	sd	s6,0(sp)
    80003476:	0080                	addi	s0,sp,64
    80003478:	8b2a                	mv	s6,a0
    8000347a:	00016a97          	auipc	s5,0x16
    8000347e:	846a8a93          	addi	s5,s5,-1978 # 80018cc0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003482:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003484:	00016997          	auipc	s3,0x16
    80003488:	80c98993          	addi	s3,s3,-2036 # 80018c90 <log>
    8000348c:	a00d                	j	800034ae <install_trans+0x56>
    brelse(lbuf);
    8000348e:	854a                	mv	a0,s2
    80003490:	fffff097          	auipc	ra,0xfffff
    80003494:	07e080e7          	jalr	126(ra) # 8000250e <brelse>
    brelse(dbuf);
    80003498:	8526                	mv	a0,s1
    8000349a:	fffff097          	auipc	ra,0xfffff
    8000349e:	074080e7          	jalr	116(ra) # 8000250e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034a2:	2a05                	addiw	s4,s4,1
    800034a4:	0a91                	addi	s5,s5,4
    800034a6:	02c9a783          	lw	a5,44(s3)
    800034aa:	04fa5e63          	bge	s4,a5,80003506 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034ae:	0189a583          	lw	a1,24(s3)
    800034b2:	014585bb          	addw	a1,a1,s4
    800034b6:	2585                	addiw	a1,a1,1
    800034b8:	0289a503          	lw	a0,40(s3)
    800034bc:	fffff097          	auipc	ra,0xfffff
    800034c0:	f22080e7          	jalr	-222(ra) # 800023de <bread>
    800034c4:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034c6:	000aa583          	lw	a1,0(s5)
    800034ca:	0289a503          	lw	a0,40(s3)
    800034ce:	fffff097          	auipc	ra,0xfffff
    800034d2:	f10080e7          	jalr	-240(ra) # 800023de <bread>
    800034d6:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034d8:	40000613          	li	a2,1024
    800034dc:	05890593          	addi	a1,s2,88
    800034e0:	05850513          	addi	a0,a0,88
    800034e4:	ffffd097          	auipc	ra,0xffffd
    800034e8:	d16080e7          	jalr	-746(ra) # 800001fa <memmove>
    bwrite(dbuf);  // write dst to disk
    800034ec:	8526                	mv	a0,s1
    800034ee:	fffff097          	auipc	ra,0xfffff
    800034f2:	fe2080e7          	jalr	-30(ra) # 800024d0 <bwrite>
    if(recovering == 0)
    800034f6:	f80b1ce3          	bnez	s6,8000348e <install_trans+0x36>
      bunpin(dbuf);
    800034fa:	8526                	mv	a0,s1
    800034fc:	fffff097          	auipc	ra,0xfffff
    80003500:	0ec080e7          	jalr	236(ra) # 800025e8 <bunpin>
    80003504:	b769                	j	8000348e <install_trans+0x36>
}
    80003506:	70e2                	ld	ra,56(sp)
    80003508:	7442                	ld	s0,48(sp)
    8000350a:	74a2                	ld	s1,40(sp)
    8000350c:	7902                	ld	s2,32(sp)
    8000350e:	69e2                	ld	s3,24(sp)
    80003510:	6a42                	ld	s4,16(sp)
    80003512:	6aa2                	ld	s5,8(sp)
    80003514:	6b02                	ld	s6,0(sp)
    80003516:	6121                	addi	sp,sp,64
    80003518:	8082                	ret
    8000351a:	8082                	ret

000000008000351c <initlog>:
{
    8000351c:	7179                	addi	sp,sp,-48
    8000351e:	f406                	sd	ra,40(sp)
    80003520:	f022                	sd	s0,32(sp)
    80003522:	ec26                	sd	s1,24(sp)
    80003524:	e84a                	sd	s2,16(sp)
    80003526:	e44e                	sd	s3,8(sp)
    80003528:	1800                	addi	s0,sp,48
    8000352a:	892a                	mv	s2,a0
    8000352c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000352e:	00015497          	auipc	s1,0x15
    80003532:	76248493          	addi	s1,s1,1890 # 80018c90 <log>
    80003536:	00005597          	auipc	a1,0x5
    8000353a:	14a58593          	addi	a1,a1,330 # 80008680 <syscalls+0x1e8>
    8000353e:	8526                	mv	a0,s1
    80003540:	00003097          	auipc	ra,0x3
    80003544:	c14080e7          	jalr	-1004(ra) # 80006154 <initlock>
  log.start = sb->logstart;
    80003548:	0149a583          	lw	a1,20(s3)
    8000354c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000354e:	0109a783          	lw	a5,16(s3)
    80003552:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003554:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003558:	854a                	mv	a0,s2
    8000355a:	fffff097          	auipc	ra,0xfffff
    8000355e:	e84080e7          	jalr	-380(ra) # 800023de <bread>
  log.lh.n = lh->n;
    80003562:	4d34                	lw	a3,88(a0)
    80003564:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003566:	02d05663          	blez	a3,80003592 <initlog+0x76>
    8000356a:	05c50793          	addi	a5,a0,92
    8000356e:	00015717          	auipc	a4,0x15
    80003572:	75270713          	addi	a4,a4,1874 # 80018cc0 <log+0x30>
    80003576:	36fd                	addiw	a3,a3,-1
    80003578:	02069613          	slli	a2,a3,0x20
    8000357c:	01e65693          	srli	a3,a2,0x1e
    80003580:	06050613          	addi	a2,a0,96
    80003584:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003586:	4390                	lw	a2,0(a5)
    80003588:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000358a:	0791                	addi	a5,a5,4
    8000358c:	0711                	addi	a4,a4,4
    8000358e:	fed79ce3          	bne	a5,a3,80003586 <initlog+0x6a>
  brelse(buf);
    80003592:	fffff097          	auipc	ra,0xfffff
    80003596:	f7c080e7          	jalr	-132(ra) # 8000250e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000359a:	4505                	li	a0,1
    8000359c:	00000097          	auipc	ra,0x0
    800035a0:	ebc080e7          	jalr	-324(ra) # 80003458 <install_trans>
  log.lh.n = 0;
    800035a4:	00015797          	auipc	a5,0x15
    800035a8:	7007ac23          	sw	zero,1816(a5) # 80018cbc <log+0x2c>
  write_head(); // clear the log
    800035ac:	00000097          	auipc	ra,0x0
    800035b0:	e30080e7          	jalr	-464(ra) # 800033dc <write_head>
}
    800035b4:	70a2                	ld	ra,40(sp)
    800035b6:	7402                	ld	s0,32(sp)
    800035b8:	64e2                	ld	s1,24(sp)
    800035ba:	6942                	ld	s2,16(sp)
    800035bc:	69a2                	ld	s3,8(sp)
    800035be:	6145                	addi	sp,sp,48
    800035c0:	8082                	ret

00000000800035c2 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035c2:	1101                	addi	sp,sp,-32
    800035c4:	ec06                	sd	ra,24(sp)
    800035c6:	e822                	sd	s0,16(sp)
    800035c8:	e426                	sd	s1,8(sp)
    800035ca:	e04a                	sd	s2,0(sp)
    800035cc:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035ce:	00015517          	auipc	a0,0x15
    800035d2:	6c250513          	addi	a0,a0,1730 # 80018c90 <log>
    800035d6:	00003097          	auipc	ra,0x3
    800035da:	c0e080e7          	jalr	-1010(ra) # 800061e4 <acquire>
  while(1){
    if(log.committing){
    800035de:	00015497          	auipc	s1,0x15
    800035e2:	6b248493          	addi	s1,s1,1714 # 80018c90 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035e6:	4979                	li	s2,30
    800035e8:	a039                	j	800035f6 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035ea:	85a6                	mv	a1,s1
    800035ec:	8526                	mv	a0,s1
    800035ee:	ffffe097          	auipc	ra,0xffffe
    800035f2:	f3a080e7          	jalr	-198(ra) # 80001528 <sleep>
    if(log.committing){
    800035f6:	50dc                	lw	a5,36(s1)
    800035f8:	fbed                	bnez	a5,800035ea <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035fa:	5098                	lw	a4,32(s1)
    800035fc:	2705                	addiw	a4,a4,1
    800035fe:	0007069b          	sext.w	a3,a4
    80003602:	0027179b          	slliw	a5,a4,0x2
    80003606:	9fb9                	addw	a5,a5,a4
    80003608:	0017979b          	slliw	a5,a5,0x1
    8000360c:	54d8                	lw	a4,44(s1)
    8000360e:	9fb9                	addw	a5,a5,a4
    80003610:	00f95963          	bge	s2,a5,80003622 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003614:	85a6                	mv	a1,s1
    80003616:	8526                	mv	a0,s1
    80003618:	ffffe097          	auipc	ra,0xffffe
    8000361c:	f10080e7          	jalr	-240(ra) # 80001528 <sleep>
    80003620:	bfd9                	j	800035f6 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003622:	00015517          	auipc	a0,0x15
    80003626:	66e50513          	addi	a0,a0,1646 # 80018c90 <log>
    8000362a:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000362c:	00003097          	auipc	ra,0x3
    80003630:	c6c080e7          	jalr	-916(ra) # 80006298 <release>
      break;
    }
  }
}
    80003634:	60e2                	ld	ra,24(sp)
    80003636:	6442                	ld	s0,16(sp)
    80003638:	64a2                	ld	s1,8(sp)
    8000363a:	6902                	ld	s2,0(sp)
    8000363c:	6105                	addi	sp,sp,32
    8000363e:	8082                	ret

0000000080003640 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003640:	7139                	addi	sp,sp,-64
    80003642:	fc06                	sd	ra,56(sp)
    80003644:	f822                	sd	s0,48(sp)
    80003646:	f426                	sd	s1,40(sp)
    80003648:	f04a                	sd	s2,32(sp)
    8000364a:	ec4e                	sd	s3,24(sp)
    8000364c:	e852                	sd	s4,16(sp)
    8000364e:	e456                	sd	s5,8(sp)
    80003650:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003652:	00015497          	auipc	s1,0x15
    80003656:	63e48493          	addi	s1,s1,1598 # 80018c90 <log>
    8000365a:	8526                	mv	a0,s1
    8000365c:	00003097          	auipc	ra,0x3
    80003660:	b88080e7          	jalr	-1144(ra) # 800061e4 <acquire>
  log.outstanding -= 1;
    80003664:	509c                	lw	a5,32(s1)
    80003666:	37fd                	addiw	a5,a5,-1
    80003668:	0007891b          	sext.w	s2,a5
    8000366c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000366e:	50dc                	lw	a5,36(s1)
    80003670:	e7b9                	bnez	a5,800036be <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003672:	04091e63          	bnez	s2,800036ce <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003676:	00015497          	auipc	s1,0x15
    8000367a:	61a48493          	addi	s1,s1,1562 # 80018c90 <log>
    8000367e:	4785                	li	a5,1
    80003680:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003682:	8526                	mv	a0,s1
    80003684:	00003097          	auipc	ra,0x3
    80003688:	c14080e7          	jalr	-1004(ra) # 80006298 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000368c:	54dc                	lw	a5,44(s1)
    8000368e:	06f04763          	bgtz	a5,800036fc <end_op+0xbc>
    acquire(&log.lock);
    80003692:	00015497          	auipc	s1,0x15
    80003696:	5fe48493          	addi	s1,s1,1534 # 80018c90 <log>
    8000369a:	8526                	mv	a0,s1
    8000369c:	00003097          	auipc	ra,0x3
    800036a0:	b48080e7          	jalr	-1208(ra) # 800061e4 <acquire>
    log.committing = 0;
    800036a4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036a8:	8526                	mv	a0,s1
    800036aa:	ffffe097          	auipc	ra,0xffffe
    800036ae:	ee2080e7          	jalr	-286(ra) # 8000158c <wakeup>
    release(&log.lock);
    800036b2:	8526                	mv	a0,s1
    800036b4:	00003097          	auipc	ra,0x3
    800036b8:	be4080e7          	jalr	-1052(ra) # 80006298 <release>
}
    800036bc:	a03d                	j	800036ea <end_op+0xaa>
    panic("log.committing");
    800036be:	00005517          	auipc	a0,0x5
    800036c2:	fca50513          	addi	a0,a0,-54 # 80008688 <syscalls+0x1f0>
    800036c6:	00002097          	auipc	ra,0x2
    800036ca:	5e6080e7          	jalr	1510(ra) # 80005cac <panic>
    wakeup(&log);
    800036ce:	00015497          	auipc	s1,0x15
    800036d2:	5c248493          	addi	s1,s1,1474 # 80018c90 <log>
    800036d6:	8526                	mv	a0,s1
    800036d8:	ffffe097          	auipc	ra,0xffffe
    800036dc:	eb4080e7          	jalr	-332(ra) # 8000158c <wakeup>
  release(&log.lock);
    800036e0:	8526                	mv	a0,s1
    800036e2:	00003097          	auipc	ra,0x3
    800036e6:	bb6080e7          	jalr	-1098(ra) # 80006298 <release>
}
    800036ea:	70e2                	ld	ra,56(sp)
    800036ec:	7442                	ld	s0,48(sp)
    800036ee:	74a2                	ld	s1,40(sp)
    800036f0:	7902                	ld	s2,32(sp)
    800036f2:	69e2                	ld	s3,24(sp)
    800036f4:	6a42                	ld	s4,16(sp)
    800036f6:	6aa2                	ld	s5,8(sp)
    800036f8:	6121                	addi	sp,sp,64
    800036fa:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800036fc:	00015a97          	auipc	s5,0x15
    80003700:	5c4a8a93          	addi	s5,s5,1476 # 80018cc0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003704:	00015a17          	auipc	s4,0x15
    80003708:	58ca0a13          	addi	s4,s4,1420 # 80018c90 <log>
    8000370c:	018a2583          	lw	a1,24(s4)
    80003710:	012585bb          	addw	a1,a1,s2
    80003714:	2585                	addiw	a1,a1,1
    80003716:	028a2503          	lw	a0,40(s4)
    8000371a:	fffff097          	auipc	ra,0xfffff
    8000371e:	cc4080e7          	jalr	-828(ra) # 800023de <bread>
    80003722:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003724:	000aa583          	lw	a1,0(s5)
    80003728:	028a2503          	lw	a0,40(s4)
    8000372c:	fffff097          	auipc	ra,0xfffff
    80003730:	cb2080e7          	jalr	-846(ra) # 800023de <bread>
    80003734:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003736:	40000613          	li	a2,1024
    8000373a:	05850593          	addi	a1,a0,88
    8000373e:	05848513          	addi	a0,s1,88
    80003742:	ffffd097          	auipc	ra,0xffffd
    80003746:	ab8080e7          	jalr	-1352(ra) # 800001fa <memmove>
    bwrite(to);  // write the log
    8000374a:	8526                	mv	a0,s1
    8000374c:	fffff097          	auipc	ra,0xfffff
    80003750:	d84080e7          	jalr	-636(ra) # 800024d0 <bwrite>
    brelse(from);
    80003754:	854e                	mv	a0,s3
    80003756:	fffff097          	auipc	ra,0xfffff
    8000375a:	db8080e7          	jalr	-584(ra) # 8000250e <brelse>
    brelse(to);
    8000375e:	8526                	mv	a0,s1
    80003760:	fffff097          	auipc	ra,0xfffff
    80003764:	dae080e7          	jalr	-594(ra) # 8000250e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003768:	2905                	addiw	s2,s2,1
    8000376a:	0a91                	addi	s5,s5,4
    8000376c:	02ca2783          	lw	a5,44(s4)
    80003770:	f8f94ee3          	blt	s2,a5,8000370c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003774:	00000097          	auipc	ra,0x0
    80003778:	c68080e7          	jalr	-920(ra) # 800033dc <write_head>
    install_trans(0); // Now install writes to home locations
    8000377c:	4501                	li	a0,0
    8000377e:	00000097          	auipc	ra,0x0
    80003782:	cda080e7          	jalr	-806(ra) # 80003458 <install_trans>
    log.lh.n = 0;
    80003786:	00015797          	auipc	a5,0x15
    8000378a:	5207ab23          	sw	zero,1334(a5) # 80018cbc <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000378e:	00000097          	auipc	ra,0x0
    80003792:	c4e080e7          	jalr	-946(ra) # 800033dc <write_head>
    80003796:	bdf5                	j	80003692 <end_op+0x52>

0000000080003798 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003798:	1101                	addi	sp,sp,-32
    8000379a:	ec06                	sd	ra,24(sp)
    8000379c:	e822                	sd	s0,16(sp)
    8000379e:	e426                	sd	s1,8(sp)
    800037a0:	e04a                	sd	s2,0(sp)
    800037a2:	1000                	addi	s0,sp,32
    800037a4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037a6:	00015917          	auipc	s2,0x15
    800037aa:	4ea90913          	addi	s2,s2,1258 # 80018c90 <log>
    800037ae:	854a                	mv	a0,s2
    800037b0:	00003097          	auipc	ra,0x3
    800037b4:	a34080e7          	jalr	-1484(ra) # 800061e4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037b8:	02c92603          	lw	a2,44(s2)
    800037bc:	47f5                	li	a5,29
    800037be:	06c7c563          	blt	a5,a2,80003828 <log_write+0x90>
    800037c2:	00015797          	auipc	a5,0x15
    800037c6:	4ea7a783          	lw	a5,1258(a5) # 80018cac <log+0x1c>
    800037ca:	37fd                	addiw	a5,a5,-1
    800037cc:	04f65e63          	bge	a2,a5,80003828 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037d0:	00015797          	auipc	a5,0x15
    800037d4:	4e07a783          	lw	a5,1248(a5) # 80018cb0 <log+0x20>
    800037d8:	06f05063          	blez	a5,80003838 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037dc:	4781                	li	a5,0
    800037de:	06c05563          	blez	a2,80003848 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037e2:	44cc                	lw	a1,12(s1)
    800037e4:	00015717          	auipc	a4,0x15
    800037e8:	4dc70713          	addi	a4,a4,1244 # 80018cc0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037ec:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037ee:	4314                	lw	a3,0(a4)
    800037f0:	04b68c63          	beq	a3,a1,80003848 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037f4:	2785                	addiw	a5,a5,1
    800037f6:	0711                	addi	a4,a4,4
    800037f8:	fef61be3          	bne	a2,a5,800037ee <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037fc:	0621                	addi	a2,a2,8
    800037fe:	060a                	slli	a2,a2,0x2
    80003800:	00015797          	auipc	a5,0x15
    80003804:	49078793          	addi	a5,a5,1168 # 80018c90 <log>
    80003808:	97b2                	add	a5,a5,a2
    8000380a:	44d8                	lw	a4,12(s1)
    8000380c:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000380e:	8526                	mv	a0,s1
    80003810:	fffff097          	auipc	ra,0xfffff
    80003814:	d9c080e7          	jalr	-612(ra) # 800025ac <bpin>
    log.lh.n++;
    80003818:	00015717          	auipc	a4,0x15
    8000381c:	47870713          	addi	a4,a4,1144 # 80018c90 <log>
    80003820:	575c                	lw	a5,44(a4)
    80003822:	2785                	addiw	a5,a5,1
    80003824:	d75c                	sw	a5,44(a4)
    80003826:	a82d                	j	80003860 <log_write+0xc8>
    panic("too big a transaction");
    80003828:	00005517          	auipc	a0,0x5
    8000382c:	e7050513          	addi	a0,a0,-400 # 80008698 <syscalls+0x200>
    80003830:	00002097          	auipc	ra,0x2
    80003834:	47c080e7          	jalr	1148(ra) # 80005cac <panic>
    panic("log_write outside of trans");
    80003838:	00005517          	auipc	a0,0x5
    8000383c:	e7850513          	addi	a0,a0,-392 # 800086b0 <syscalls+0x218>
    80003840:	00002097          	auipc	ra,0x2
    80003844:	46c080e7          	jalr	1132(ra) # 80005cac <panic>
  log.lh.block[i] = b->blockno;
    80003848:	00878693          	addi	a3,a5,8
    8000384c:	068a                	slli	a3,a3,0x2
    8000384e:	00015717          	auipc	a4,0x15
    80003852:	44270713          	addi	a4,a4,1090 # 80018c90 <log>
    80003856:	9736                	add	a4,a4,a3
    80003858:	44d4                	lw	a3,12(s1)
    8000385a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000385c:	faf609e3          	beq	a2,a5,8000380e <log_write+0x76>
  }
  release(&log.lock);
    80003860:	00015517          	auipc	a0,0x15
    80003864:	43050513          	addi	a0,a0,1072 # 80018c90 <log>
    80003868:	00003097          	auipc	ra,0x3
    8000386c:	a30080e7          	jalr	-1488(ra) # 80006298 <release>
}
    80003870:	60e2                	ld	ra,24(sp)
    80003872:	6442                	ld	s0,16(sp)
    80003874:	64a2                	ld	s1,8(sp)
    80003876:	6902                	ld	s2,0(sp)
    80003878:	6105                	addi	sp,sp,32
    8000387a:	8082                	ret

000000008000387c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000387c:	1101                	addi	sp,sp,-32
    8000387e:	ec06                	sd	ra,24(sp)
    80003880:	e822                	sd	s0,16(sp)
    80003882:	e426                	sd	s1,8(sp)
    80003884:	e04a                	sd	s2,0(sp)
    80003886:	1000                	addi	s0,sp,32
    80003888:	84aa                	mv	s1,a0
    8000388a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000388c:	00005597          	auipc	a1,0x5
    80003890:	e4458593          	addi	a1,a1,-444 # 800086d0 <syscalls+0x238>
    80003894:	0521                	addi	a0,a0,8
    80003896:	00003097          	auipc	ra,0x3
    8000389a:	8be080e7          	jalr	-1858(ra) # 80006154 <initlock>
  lk->name = name;
    8000389e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038a2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038a6:	0204a423          	sw	zero,40(s1)
}
    800038aa:	60e2                	ld	ra,24(sp)
    800038ac:	6442                	ld	s0,16(sp)
    800038ae:	64a2                	ld	s1,8(sp)
    800038b0:	6902                	ld	s2,0(sp)
    800038b2:	6105                	addi	sp,sp,32
    800038b4:	8082                	ret

00000000800038b6 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038b6:	1101                	addi	sp,sp,-32
    800038b8:	ec06                	sd	ra,24(sp)
    800038ba:	e822                	sd	s0,16(sp)
    800038bc:	e426                	sd	s1,8(sp)
    800038be:	e04a                	sd	s2,0(sp)
    800038c0:	1000                	addi	s0,sp,32
    800038c2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038c4:	00850913          	addi	s2,a0,8
    800038c8:	854a                	mv	a0,s2
    800038ca:	00003097          	auipc	ra,0x3
    800038ce:	91a080e7          	jalr	-1766(ra) # 800061e4 <acquire>
  while (lk->locked) {
    800038d2:	409c                	lw	a5,0(s1)
    800038d4:	cb89                	beqz	a5,800038e6 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038d6:	85ca                	mv	a1,s2
    800038d8:	8526                	mv	a0,s1
    800038da:	ffffe097          	auipc	ra,0xffffe
    800038de:	c4e080e7          	jalr	-946(ra) # 80001528 <sleep>
  while (lk->locked) {
    800038e2:	409c                	lw	a5,0(s1)
    800038e4:	fbed                	bnez	a5,800038d6 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038e6:	4785                	li	a5,1
    800038e8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038ea:	ffffd097          	auipc	ra,0xffffd
    800038ee:	58e080e7          	jalr	1422(ra) # 80000e78 <myproc>
    800038f2:	591c                	lw	a5,48(a0)
    800038f4:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038f6:	854a                	mv	a0,s2
    800038f8:	00003097          	auipc	ra,0x3
    800038fc:	9a0080e7          	jalr	-1632(ra) # 80006298 <release>
}
    80003900:	60e2                	ld	ra,24(sp)
    80003902:	6442                	ld	s0,16(sp)
    80003904:	64a2                	ld	s1,8(sp)
    80003906:	6902                	ld	s2,0(sp)
    80003908:	6105                	addi	sp,sp,32
    8000390a:	8082                	ret

000000008000390c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000390c:	1101                	addi	sp,sp,-32
    8000390e:	ec06                	sd	ra,24(sp)
    80003910:	e822                	sd	s0,16(sp)
    80003912:	e426                	sd	s1,8(sp)
    80003914:	e04a                	sd	s2,0(sp)
    80003916:	1000                	addi	s0,sp,32
    80003918:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000391a:	00850913          	addi	s2,a0,8
    8000391e:	854a                	mv	a0,s2
    80003920:	00003097          	auipc	ra,0x3
    80003924:	8c4080e7          	jalr	-1852(ra) # 800061e4 <acquire>
  lk->locked = 0;
    80003928:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000392c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003930:	8526                	mv	a0,s1
    80003932:	ffffe097          	auipc	ra,0xffffe
    80003936:	c5a080e7          	jalr	-934(ra) # 8000158c <wakeup>
  release(&lk->lk);
    8000393a:	854a                	mv	a0,s2
    8000393c:	00003097          	auipc	ra,0x3
    80003940:	95c080e7          	jalr	-1700(ra) # 80006298 <release>
}
    80003944:	60e2                	ld	ra,24(sp)
    80003946:	6442                	ld	s0,16(sp)
    80003948:	64a2                	ld	s1,8(sp)
    8000394a:	6902                	ld	s2,0(sp)
    8000394c:	6105                	addi	sp,sp,32
    8000394e:	8082                	ret

0000000080003950 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003950:	7179                	addi	sp,sp,-48
    80003952:	f406                	sd	ra,40(sp)
    80003954:	f022                	sd	s0,32(sp)
    80003956:	ec26                	sd	s1,24(sp)
    80003958:	e84a                	sd	s2,16(sp)
    8000395a:	e44e                	sd	s3,8(sp)
    8000395c:	1800                	addi	s0,sp,48
    8000395e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003960:	00850913          	addi	s2,a0,8
    80003964:	854a                	mv	a0,s2
    80003966:	00003097          	auipc	ra,0x3
    8000396a:	87e080e7          	jalr	-1922(ra) # 800061e4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000396e:	409c                	lw	a5,0(s1)
    80003970:	ef99                	bnez	a5,8000398e <holdingsleep+0x3e>
    80003972:	4481                	li	s1,0
  release(&lk->lk);
    80003974:	854a                	mv	a0,s2
    80003976:	00003097          	auipc	ra,0x3
    8000397a:	922080e7          	jalr	-1758(ra) # 80006298 <release>
  return r;
}
    8000397e:	8526                	mv	a0,s1
    80003980:	70a2                	ld	ra,40(sp)
    80003982:	7402                	ld	s0,32(sp)
    80003984:	64e2                	ld	s1,24(sp)
    80003986:	6942                	ld	s2,16(sp)
    80003988:	69a2                	ld	s3,8(sp)
    8000398a:	6145                	addi	sp,sp,48
    8000398c:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000398e:	0284a983          	lw	s3,40(s1)
    80003992:	ffffd097          	auipc	ra,0xffffd
    80003996:	4e6080e7          	jalr	1254(ra) # 80000e78 <myproc>
    8000399a:	5904                	lw	s1,48(a0)
    8000399c:	413484b3          	sub	s1,s1,s3
    800039a0:	0014b493          	seqz	s1,s1
    800039a4:	bfc1                	j	80003974 <holdingsleep+0x24>

00000000800039a6 <fileinit>:
    struct spinlock lock;
    struct file file[NFILE];
} ftable;

void fileinit(void)
{
    800039a6:	1141                	addi	sp,sp,-16
    800039a8:	e406                	sd	ra,8(sp)
    800039aa:	e022                	sd	s0,0(sp)
    800039ac:	0800                	addi	s0,sp,16
    initlock(&ftable.lock, "ftable");
    800039ae:	00005597          	auipc	a1,0x5
    800039b2:	d3258593          	addi	a1,a1,-718 # 800086e0 <syscalls+0x248>
    800039b6:	00015517          	auipc	a0,0x15
    800039ba:	42250513          	addi	a0,a0,1058 # 80018dd8 <ftable>
    800039be:	00002097          	auipc	ra,0x2
    800039c2:	796080e7          	jalr	1942(ra) # 80006154 <initlock>
}
    800039c6:	60a2                	ld	ra,8(sp)
    800039c8:	6402                	ld	s0,0(sp)
    800039ca:	0141                	addi	sp,sp,16
    800039cc:	8082                	ret

00000000800039ce <filealloc>:

// Allocate a file structure.
struct file *filealloc(void)
{
    800039ce:	1101                	addi	sp,sp,-32
    800039d0:	ec06                	sd	ra,24(sp)
    800039d2:	e822                	sd	s0,16(sp)
    800039d4:	e426                	sd	s1,8(sp)
    800039d6:	1000                	addi	s0,sp,32
    struct file *f;

    acquire(&ftable.lock);
    800039d8:	00015517          	auipc	a0,0x15
    800039dc:	40050513          	addi	a0,a0,1024 # 80018dd8 <ftable>
    800039e0:	00003097          	auipc	ra,0x3
    800039e4:	804080e7          	jalr	-2044(ra) # 800061e4 <acquire>
    for (f = ftable.file; f < ftable.file + NFILE; f++) {
    800039e8:	00015497          	auipc	s1,0x15
    800039ec:	40848493          	addi	s1,s1,1032 # 80018df0 <ftable+0x18>
    800039f0:	00016717          	auipc	a4,0x16
    800039f4:	3a070713          	addi	a4,a4,928 # 80019d90 <disk>
        if (f->ref == 0) {
    800039f8:	40dc                	lw	a5,4(s1)
    800039fa:	cf99                	beqz	a5,80003a18 <filealloc+0x4a>
    for (f = ftable.file; f < ftable.file + NFILE; f++) {
    800039fc:	02848493          	addi	s1,s1,40
    80003a00:	fee49ce3          	bne	s1,a4,800039f8 <filealloc+0x2a>
            f->ref = 1;
            release(&ftable.lock);
            return f;
        }
    }
    release(&ftable.lock);
    80003a04:	00015517          	auipc	a0,0x15
    80003a08:	3d450513          	addi	a0,a0,980 # 80018dd8 <ftable>
    80003a0c:	00003097          	auipc	ra,0x3
    80003a10:	88c080e7          	jalr	-1908(ra) # 80006298 <release>
    return 0;
    80003a14:	4481                	li	s1,0
    80003a16:	a819                	j	80003a2c <filealloc+0x5e>
            f->ref = 1;
    80003a18:	4785                	li	a5,1
    80003a1a:	c0dc                	sw	a5,4(s1)
            release(&ftable.lock);
    80003a1c:	00015517          	auipc	a0,0x15
    80003a20:	3bc50513          	addi	a0,a0,956 # 80018dd8 <ftable>
    80003a24:	00003097          	auipc	ra,0x3
    80003a28:	874080e7          	jalr	-1932(ra) # 80006298 <release>
}
    80003a2c:	8526                	mv	a0,s1
    80003a2e:	60e2                	ld	ra,24(sp)
    80003a30:	6442                	ld	s0,16(sp)
    80003a32:	64a2                	ld	s1,8(sp)
    80003a34:	6105                	addi	sp,sp,32
    80003a36:	8082                	ret

0000000080003a38 <filedup>:

// Increment ref count for file f.
struct file *filedup(struct file *f)
{
    80003a38:	1101                	addi	sp,sp,-32
    80003a3a:	ec06                	sd	ra,24(sp)
    80003a3c:	e822                	sd	s0,16(sp)
    80003a3e:	e426                	sd	s1,8(sp)
    80003a40:	1000                	addi	s0,sp,32
    80003a42:	84aa                	mv	s1,a0
    acquire(&ftable.lock);
    80003a44:	00015517          	auipc	a0,0x15
    80003a48:	39450513          	addi	a0,a0,916 # 80018dd8 <ftable>
    80003a4c:	00002097          	auipc	ra,0x2
    80003a50:	798080e7          	jalr	1944(ra) # 800061e4 <acquire>
    if (f->ref < 1)
    80003a54:	40dc                	lw	a5,4(s1)
    80003a56:	02f05263          	blez	a5,80003a7a <filedup+0x42>
        panic("filedup");
    f->ref++;
    80003a5a:	2785                	addiw	a5,a5,1
    80003a5c:	c0dc                	sw	a5,4(s1)
    release(&ftable.lock);
    80003a5e:	00015517          	auipc	a0,0x15
    80003a62:	37a50513          	addi	a0,a0,890 # 80018dd8 <ftable>
    80003a66:	00003097          	auipc	ra,0x3
    80003a6a:	832080e7          	jalr	-1998(ra) # 80006298 <release>
    return f;
}
    80003a6e:	8526                	mv	a0,s1
    80003a70:	60e2                	ld	ra,24(sp)
    80003a72:	6442                	ld	s0,16(sp)
    80003a74:	64a2                	ld	s1,8(sp)
    80003a76:	6105                	addi	sp,sp,32
    80003a78:	8082                	ret
        panic("filedup");
    80003a7a:	00005517          	auipc	a0,0x5
    80003a7e:	c6e50513          	addi	a0,a0,-914 # 800086e8 <syscalls+0x250>
    80003a82:	00002097          	auipc	ra,0x2
    80003a86:	22a080e7          	jalr	554(ra) # 80005cac <panic>

0000000080003a8a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f)
{
    80003a8a:	7139                	addi	sp,sp,-64
    80003a8c:	fc06                	sd	ra,56(sp)
    80003a8e:	f822                	sd	s0,48(sp)
    80003a90:	f426                	sd	s1,40(sp)
    80003a92:	f04a                	sd	s2,32(sp)
    80003a94:	ec4e                	sd	s3,24(sp)
    80003a96:	e852                	sd	s4,16(sp)
    80003a98:	e456                	sd	s5,8(sp)
    80003a9a:	0080                	addi	s0,sp,64
    80003a9c:	84aa                	mv	s1,a0
    struct file ff;

    acquire(&ftable.lock);
    80003a9e:	00015517          	auipc	a0,0x15
    80003aa2:	33a50513          	addi	a0,a0,826 # 80018dd8 <ftable>
    80003aa6:	00002097          	auipc	ra,0x2
    80003aaa:	73e080e7          	jalr	1854(ra) # 800061e4 <acquire>
    if (f->ref < 1)
    80003aae:	40dc                	lw	a5,4(s1)
    80003ab0:	06f05163          	blez	a5,80003b12 <fileclose+0x88>
        panic("fileclose");
    if (--f->ref > 0) {
    80003ab4:	37fd                	addiw	a5,a5,-1
    80003ab6:	0007871b          	sext.w	a4,a5
    80003aba:	c0dc                	sw	a5,4(s1)
    80003abc:	06e04363          	bgtz	a4,80003b22 <fileclose+0x98>
        release(&ftable.lock);
        return;
    }
    ff = *f;
    80003ac0:	0004a903          	lw	s2,0(s1)
    80003ac4:	0094ca83          	lbu	s5,9(s1)
    80003ac8:	0104ba03          	ld	s4,16(s1)
    80003acc:	0184b983          	ld	s3,24(s1)
    f->ref = 0;
    80003ad0:	0004a223          	sw	zero,4(s1)
    f->type = FD_NONE;
    80003ad4:	0004a023          	sw	zero,0(s1)
    release(&ftable.lock);
    80003ad8:	00015517          	auipc	a0,0x15
    80003adc:	30050513          	addi	a0,a0,768 # 80018dd8 <ftable>
    80003ae0:	00002097          	auipc	ra,0x2
    80003ae4:	7b8080e7          	jalr	1976(ra) # 80006298 <release>

    if (ff.type == FD_PIPE) {
    80003ae8:	4785                	li	a5,1
    80003aea:	04f90d63          	beq	s2,a5,80003b44 <fileclose+0xba>
        pipeclose(ff.pipe, ff.writable);
    }
    else if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
    80003aee:	3979                	addiw	s2,s2,-2
    80003af0:	4785                	li	a5,1
    80003af2:	0527e063          	bltu	a5,s2,80003b32 <fileclose+0xa8>
        begin_op();
    80003af6:	00000097          	auipc	ra,0x0
    80003afa:	acc080e7          	jalr	-1332(ra) # 800035c2 <begin_op>
        iput(ff.ip);
    80003afe:	854e                	mv	a0,s3
    80003b00:	fffff097          	auipc	ra,0xfffff
    80003b04:	2b0080e7          	jalr	688(ra) # 80002db0 <iput>
        end_op();
    80003b08:	00000097          	auipc	ra,0x0
    80003b0c:	b38080e7          	jalr	-1224(ra) # 80003640 <end_op>
    80003b10:	a00d                	j	80003b32 <fileclose+0xa8>
        panic("fileclose");
    80003b12:	00005517          	auipc	a0,0x5
    80003b16:	bde50513          	addi	a0,a0,-1058 # 800086f0 <syscalls+0x258>
    80003b1a:	00002097          	auipc	ra,0x2
    80003b1e:	192080e7          	jalr	402(ra) # 80005cac <panic>
        release(&ftable.lock);
    80003b22:	00015517          	auipc	a0,0x15
    80003b26:	2b650513          	addi	a0,a0,694 # 80018dd8 <ftable>
    80003b2a:	00002097          	auipc	ra,0x2
    80003b2e:	76e080e7          	jalr	1902(ra) # 80006298 <release>
    }
}
    80003b32:	70e2                	ld	ra,56(sp)
    80003b34:	7442                	ld	s0,48(sp)
    80003b36:	74a2                	ld	s1,40(sp)
    80003b38:	7902                	ld	s2,32(sp)
    80003b3a:	69e2                	ld	s3,24(sp)
    80003b3c:	6a42                	ld	s4,16(sp)
    80003b3e:	6aa2                	ld	s5,8(sp)
    80003b40:	6121                	addi	sp,sp,64
    80003b42:	8082                	ret
        pipeclose(ff.pipe, ff.writable);
    80003b44:	85d6                	mv	a1,s5
    80003b46:	8552                	mv	a0,s4
    80003b48:	00000097          	auipc	ra,0x0
    80003b4c:	34c080e7          	jalr	844(ra) # 80003e94 <pipeclose>
    80003b50:	b7cd                	j	80003b32 <fileclose+0xa8>

0000000080003b52 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int filestat(struct file *f, uint64 addr)
{
    80003b52:	715d                	addi	sp,sp,-80
    80003b54:	e486                	sd	ra,72(sp)
    80003b56:	e0a2                	sd	s0,64(sp)
    80003b58:	fc26                	sd	s1,56(sp)
    80003b5a:	f84a                	sd	s2,48(sp)
    80003b5c:	f44e                	sd	s3,40(sp)
    80003b5e:	0880                	addi	s0,sp,80
    80003b60:	84aa                	mv	s1,a0
    80003b62:	89ae                	mv	s3,a1
    struct proc *p = myproc();
    80003b64:	ffffd097          	auipc	ra,0xffffd
    80003b68:	314080e7          	jalr	788(ra) # 80000e78 <myproc>
    struct stat st;

    if (f->type == FD_INODE || f->type == FD_DEVICE) {
    80003b6c:	409c                	lw	a5,0(s1)
    80003b6e:	37f9                	addiw	a5,a5,-2
    80003b70:	4705                	li	a4,1
    80003b72:	04f76763          	bltu	a4,a5,80003bc0 <filestat+0x6e>
    80003b76:	892a                	mv	s2,a0
        ilock(f->ip);
    80003b78:	6c88                	ld	a0,24(s1)
    80003b7a:	fffff097          	auipc	ra,0xfffff
    80003b7e:	07c080e7          	jalr	124(ra) # 80002bf6 <ilock>
        stati(f->ip, &st);
    80003b82:	fb840593          	addi	a1,s0,-72
    80003b86:	6c88                	ld	a0,24(s1)
    80003b88:	fffff097          	auipc	ra,0xfffff
    80003b8c:	2f8080e7          	jalr	760(ra) # 80002e80 <stati>
        iunlock(f->ip);
    80003b90:	6c88                	ld	a0,24(s1)
    80003b92:	fffff097          	auipc	ra,0xfffff
    80003b96:	126080e7          	jalr	294(ra) # 80002cb8 <iunlock>
        if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b9a:	46e1                	li	a3,24
    80003b9c:	fb840613          	addi	a2,s0,-72
    80003ba0:	85ce                	mv	a1,s3
    80003ba2:	05093503          	ld	a0,80(s2)
    80003ba6:	ffffd097          	auipc	ra,0xffffd
    80003baa:	f92080e7          	jalr	-110(ra) # 80000b38 <copyout>
    80003bae:	41f5551b          	sraiw	a0,a0,0x1f
            return -1;
        return 0;
    }
    return -1;
}
    80003bb2:	60a6                	ld	ra,72(sp)
    80003bb4:	6406                	ld	s0,64(sp)
    80003bb6:	74e2                	ld	s1,56(sp)
    80003bb8:	7942                	ld	s2,48(sp)
    80003bba:	79a2                	ld	s3,40(sp)
    80003bbc:	6161                	addi	sp,sp,80
    80003bbe:	8082                	ret
    return -1;
    80003bc0:	557d                	li	a0,-1
    80003bc2:	bfc5                	j	80003bb2 <filestat+0x60>

0000000080003bc4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int fileread(struct file *f, uint64 addr, int n)
{
    80003bc4:	7179                	addi	sp,sp,-48
    80003bc6:	f406                	sd	ra,40(sp)
    80003bc8:	f022                	sd	s0,32(sp)
    80003bca:	ec26                	sd	s1,24(sp)
    80003bcc:	e84a                	sd	s2,16(sp)
    80003bce:	e44e                	sd	s3,8(sp)
    80003bd0:	1800                	addi	s0,sp,48
    int r = 0;

    if (f->readable == 0)
    80003bd2:	00854783          	lbu	a5,8(a0)
    80003bd6:	c3d5                	beqz	a5,80003c7a <fileread+0xb6>
    80003bd8:	84aa                	mv	s1,a0
    80003bda:	89ae                	mv	s3,a1
    80003bdc:	8932                	mv	s2,a2
        return -1;

    if (f->type == FD_PIPE) {
    80003bde:	411c                	lw	a5,0(a0)
    80003be0:	4705                	li	a4,1
    80003be2:	04e78963          	beq	a5,a4,80003c34 <fileread+0x70>
        r = piperead(f->pipe, addr, n);
    }
    else if (f->type == FD_DEVICE) {
    80003be6:	470d                	li	a4,3
    80003be8:	04e78d63          	beq	a5,a4,80003c42 <fileread+0x7e>
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
            return -1;
        r = devsw[f->major].read(1, addr, n);
    }
    else if (f->type == FD_INODE) {
    80003bec:	4709                	li	a4,2
    80003bee:	06e79e63          	bne	a5,a4,80003c6a <fileread+0xa6>
        ilock(f->ip);
    80003bf2:	6d08                	ld	a0,24(a0)
    80003bf4:	fffff097          	auipc	ra,0xfffff
    80003bf8:	002080e7          	jalr	2(ra) # 80002bf6 <ilock>
        if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bfc:	874a                	mv	a4,s2
    80003bfe:	5094                	lw	a3,32(s1)
    80003c00:	864e                	mv	a2,s3
    80003c02:	4585                	li	a1,1
    80003c04:	6c88                	ld	a0,24(s1)
    80003c06:	fffff097          	auipc	ra,0xfffff
    80003c0a:	2a4080e7          	jalr	676(ra) # 80002eaa <readi>
    80003c0e:	892a                	mv	s2,a0
    80003c10:	00a05563          	blez	a0,80003c1a <fileread+0x56>
            f->off += r;
    80003c14:	509c                	lw	a5,32(s1)
    80003c16:	9fa9                	addw	a5,a5,a0
    80003c18:	d09c                	sw	a5,32(s1)
        iunlock(f->ip);
    80003c1a:	6c88                	ld	a0,24(s1)
    80003c1c:	fffff097          	auipc	ra,0xfffff
    80003c20:	09c080e7          	jalr	156(ra) # 80002cb8 <iunlock>
    else {
        panic("fileread");
    }

    return r;
}
    80003c24:	854a                	mv	a0,s2
    80003c26:	70a2                	ld	ra,40(sp)
    80003c28:	7402                	ld	s0,32(sp)
    80003c2a:	64e2                	ld	s1,24(sp)
    80003c2c:	6942                	ld	s2,16(sp)
    80003c2e:	69a2                	ld	s3,8(sp)
    80003c30:	6145                	addi	sp,sp,48
    80003c32:	8082                	ret
        r = piperead(f->pipe, addr, n);
    80003c34:	6908                	ld	a0,16(a0)
    80003c36:	00000097          	auipc	ra,0x0
    80003c3a:	3c6080e7          	jalr	966(ra) # 80003ffc <piperead>
    80003c3e:	892a                	mv	s2,a0
    80003c40:	b7d5                	j	80003c24 <fileread+0x60>
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c42:	02451783          	lh	a5,36(a0)
    80003c46:	03079693          	slli	a3,a5,0x30
    80003c4a:	92c1                	srli	a3,a3,0x30
    80003c4c:	4725                	li	a4,9
    80003c4e:	02d76863          	bltu	a4,a3,80003c7e <fileread+0xba>
    80003c52:	0792                	slli	a5,a5,0x4
    80003c54:	00015717          	auipc	a4,0x15
    80003c58:	0e470713          	addi	a4,a4,228 # 80018d38 <devsw>
    80003c5c:	97ba                	add	a5,a5,a4
    80003c5e:	639c                	ld	a5,0(a5)
    80003c60:	c38d                	beqz	a5,80003c82 <fileread+0xbe>
        r = devsw[f->major].read(1, addr, n);
    80003c62:	4505                	li	a0,1
    80003c64:	9782                	jalr	a5
    80003c66:	892a                	mv	s2,a0
    80003c68:	bf75                	j	80003c24 <fileread+0x60>
        panic("fileread");
    80003c6a:	00005517          	auipc	a0,0x5
    80003c6e:	a9650513          	addi	a0,a0,-1386 # 80008700 <syscalls+0x268>
    80003c72:	00002097          	auipc	ra,0x2
    80003c76:	03a080e7          	jalr	58(ra) # 80005cac <panic>
        return -1;
    80003c7a:	597d                	li	s2,-1
    80003c7c:	b765                	j	80003c24 <fileread+0x60>
            return -1;
    80003c7e:	597d                	li	s2,-1
    80003c80:	b755                	j	80003c24 <fileread+0x60>
    80003c82:	597d                	li	s2,-1
    80003c84:	b745                	j	80003c24 <fileread+0x60>

0000000080003c86 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int filewrite(struct file *f, uint64 addr, int n)
{
    80003c86:	715d                	addi	sp,sp,-80
    80003c88:	e486                	sd	ra,72(sp)
    80003c8a:	e0a2                	sd	s0,64(sp)
    80003c8c:	fc26                	sd	s1,56(sp)
    80003c8e:	f84a                	sd	s2,48(sp)
    80003c90:	f44e                	sd	s3,40(sp)
    80003c92:	f052                	sd	s4,32(sp)
    80003c94:	ec56                	sd	s5,24(sp)
    80003c96:	e85a                	sd	s6,16(sp)
    80003c98:	e45e                	sd	s7,8(sp)
    80003c9a:	e062                	sd	s8,0(sp)
    80003c9c:	0880                	addi	s0,sp,80
    int r, ret = 0;

    if (f->writable == 0)
    80003c9e:	00954783          	lbu	a5,9(a0)
    80003ca2:	10078663          	beqz	a5,80003dae <filewrite+0x128>
    80003ca6:	892a                	mv	s2,a0
    80003ca8:	8b2e                	mv	s6,a1
    80003caa:	8a32                	mv	s4,a2
        return -1;

    if (f->type == FD_PIPE) {
    80003cac:	411c                	lw	a5,0(a0)
    80003cae:	4705                	li	a4,1
    80003cb0:	02e78263          	beq	a5,a4,80003cd4 <filewrite+0x4e>
        ret = pipewrite(f->pipe, addr, n);
    }
    else if (f->type == FD_DEVICE) {
    80003cb4:	470d                	li	a4,3
    80003cb6:	02e78663          	beq	a5,a4,80003ce2 <filewrite+0x5c>
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
            return -1;
        ret = devsw[f->major].write(1, addr, n);
    }
    else if (f->type == FD_INODE) {
    80003cba:	4709                	li	a4,2
    80003cbc:	0ee79163          	bne	a5,a4,80003d9e <filewrite+0x118>
        // and 2 blocks of slop for non-aligned writes.
        // this really belongs lower down, since writei()
        // might be writing a device like the console.
        int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
        int i = 0;
        while (i < n) {
    80003cc0:	0ac05d63          	blez	a2,80003d7a <filewrite+0xf4>
        int i = 0;
    80003cc4:	4981                	li	s3,0
    80003cc6:	6b85                	lui	s7,0x1
    80003cc8:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003ccc:	6c05                	lui	s8,0x1
    80003cce:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003cd2:	a861                	j	80003d6a <filewrite+0xe4>
        ret = pipewrite(f->pipe, addr, n);
    80003cd4:	6908                	ld	a0,16(a0)
    80003cd6:	00000097          	auipc	ra,0x0
    80003cda:	22e080e7          	jalr	558(ra) # 80003f04 <pipewrite>
    80003cde:	8a2a                	mv	s4,a0
    80003ce0:	a045                	j	80003d80 <filewrite+0xfa>
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003ce2:	02451783          	lh	a5,36(a0)
    80003ce6:	03079693          	slli	a3,a5,0x30
    80003cea:	92c1                	srli	a3,a3,0x30
    80003cec:	4725                	li	a4,9
    80003cee:	0cd76263          	bltu	a4,a3,80003db2 <filewrite+0x12c>
    80003cf2:	0792                	slli	a5,a5,0x4
    80003cf4:	00015717          	auipc	a4,0x15
    80003cf8:	04470713          	addi	a4,a4,68 # 80018d38 <devsw>
    80003cfc:	97ba                	add	a5,a5,a4
    80003cfe:	679c                	ld	a5,8(a5)
    80003d00:	cbdd                	beqz	a5,80003db6 <filewrite+0x130>
        ret = devsw[f->major].write(1, addr, n);
    80003d02:	4505                	li	a0,1
    80003d04:	9782                	jalr	a5
    80003d06:	8a2a                	mv	s4,a0
    80003d08:	a8a5                	j	80003d80 <filewrite+0xfa>
    80003d0a:	00048a9b          	sext.w	s5,s1
            int n1 = n - i;
            if (n1 > max)
                n1 = max;

            begin_op();
    80003d0e:	00000097          	auipc	ra,0x0
    80003d12:	8b4080e7          	jalr	-1868(ra) # 800035c2 <begin_op>
            ilock(f->ip);
    80003d16:	01893503          	ld	a0,24(s2)
    80003d1a:	fffff097          	auipc	ra,0xfffff
    80003d1e:	edc080e7          	jalr	-292(ra) # 80002bf6 <ilock>
            if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d22:	8756                	mv	a4,s5
    80003d24:	02092683          	lw	a3,32(s2)
    80003d28:	01698633          	add	a2,s3,s6
    80003d2c:	4585                	li	a1,1
    80003d2e:	01893503          	ld	a0,24(s2)
    80003d32:	fffff097          	auipc	ra,0xfffff
    80003d36:	270080e7          	jalr	624(ra) # 80002fa2 <writei>
    80003d3a:	84aa                	mv	s1,a0
    80003d3c:	00a05763          	blez	a0,80003d4a <filewrite+0xc4>
                f->off += r;
    80003d40:	02092783          	lw	a5,32(s2)
    80003d44:	9fa9                	addw	a5,a5,a0
    80003d46:	02f92023          	sw	a5,32(s2)
            iunlock(f->ip);
    80003d4a:	01893503          	ld	a0,24(s2)
    80003d4e:	fffff097          	auipc	ra,0xfffff
    80003d52:	f6a080e7          	jalr	-150(ra) # 80002cb8 <iunlock>
            end_op();
    80003d56:	00000097          	auipc	ra,0x0
    80003d5a:	8ea080e7          	jalr	-1814(ra) # 80003640 <end_op>

            if (r != n1) {
    80003d5e:	009a9f63          	bne	s5,s1,80003d7c <filewrite+0xf6>
                // error from writei
                break;
            }
            i += r;
    80003d62:	013489bb          	addw	s3,s1,s3
        while (i < n) {
    80003d66:	0149db63          	bge	s3,s4,80003d7c <filewrite+0xf6>
            int n1 = n - i;
    80003d6a:	413a04bb          	subw	s1,s4,s3
    80003d6e:	0004879b          	sext.w	a5,s1
    80003d72:	f8fbdce3          	bge	s7,a5,80003d0a <filewrite+0x84>
    80003d76:	84e2                	mv	s1,s8
    80003d78:	bf49                	j	80003d0a <filewrite+0x84>
        int i = 0;
    80003d7a:	4981                	li	s3,0
        }
        ret = (i == n ? n : -1);
    80003d7c:	013a1f63          	bne	s4,s3,80003d9a <filewrite+0x114>
    else {
        panic("filewrite");
    }

    return ret;
}
    80003d80:	8552                	mv	a0,s4
    80003d82:	60a6                	ld	ra,72(sp)
    80003d84:	6406                	ld	s0,64(sp)
    80003d86:	74e2                	ld	s1,56(sp)
    80003d88:	7942                	ld	s2,48(sp)
    80003d8a:	79a2                	ld	s3,40(sp)
    80003d8c:	7a02                	ld	s4,32(sp)
    80003d8e:	6ae2                	ld	s5,24(sp)
    80003d90:	6b42                	ld	s6,16(sp)
    80003d92:	6ba2                	ld	s7,8(sp)
    80003d94:	6c02                	ld	s8,0(sp)
    80003d96:	6161                	addi	sp,sp,80
    80003d98:	8082                	ret
        ret = (i == n ? n : -1);
    80003d9a:	5a7d                	li	s4,-1
    80003d9c:	b7d5                	j	80003d80 <filewrite+0xfa>
        panic("filewrite");
    80003d9e:	00005517          	auipc	a0,0x5
    80003da2:	97250513          	addi	a0,a0,-1678 # 80008710 <syscalls+0x278>
    80003da6:	00002097          	auipc	ra,0x2
    80003daa:	f06080e7          	jalr	-250(ra) # 80005cac <panic>
        return -1;
    80003dae:	5a7d                	li	s4,-1
    80003db0:	bfc1                	j	80003d80 <filewrite+0xfa>
            return -1;
    80003db2:	5a7d                	li	s4,-1
    80003db4:	b7f1                	j	80003d80 <filewrite+0xfa>
    80003db6:	5a7d                	li	s4,-1
    80003db8:	b7e1                	j	80003d80 <filewrite+0xfa>

0000000080003dba <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003dba:	7179                	addi	sp,sp,-48
    80003dbc:	f406                	sd	ra,40(sp)
    80003dbe:	f022                	sd	s0,32(sp)
    80003dc0:	ec26                	sd	s1,24(sp)
    80003dc2:	e84a                	sd	s2,16(sp)
    80003dc4:	e44e                	sd	s3,8(sp)
    80003dc6:	e052                	sd	s4,0(sp)
    80003dc8:	1800                	addi	s0,sp,48
    80003dca:	84aa                	mv	s1,a0
    80003dcc:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003dce:	0005b023          	sd	zero,0(a1)
    80003dd2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003dd6:	00000097          	auipc	ra,0x0
    80003dda:	bf8080e7          	jalr	-1032(ra) # 800039ce <filealloc>
    80003dde:	e088                	sd	a0,0(s1)
    80003de0:	c551                	beqz	a0,80003e6c <pipealloc+0xb2>
    80003de2:	00000097          	auipc	ra,0x0
    80003de6:	bec080e7          	jalr	-1044(ra) # 800039ce <filealloc>
    80003dea:	00aa3023          	sd	a0,0(s4)
    80003dee:	c92d                	beqz	a0,80003e60 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003df0:	ffffc097          	auipc	ra,0xffffc
    80003df4:	32a080e7          	jalr	810(ra) # 8000011a <kalloc>
    80003df8:	892a                	mv	s2,a0
    80003dfa:	c125                	beqz	a0,80003e5a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003dfc:	4985                	li	s3,1
    80003dfe:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e02:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e06:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e0a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e0e:	00004597          	auipc	a1,0x4
    80003e12:	5da58593          	addi	a1,a1,1498 # 800083e8 <states.0+0x1a0>
    80003e16:	00002097          	auipc	ra,0x2
    80003e1a:	33e080e7          	jalr	830(ra) # 80006154 <initlock>
  (*f0)->type = FD_PIPE;
    80003e1e:	609c                	ld	a5,0(s1)
    80003e20:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e24:	609c                	ld	a5,0(s1)
    80003e26:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e2a:	609c                	ld	a5,0(s1)
    80003e2c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e30:	609c                	ld	a5,0(s1)
    80003e32:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e36:	000a3783          	ld	a5,0(s4)
    80003e3a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e3e:	000a3783          	ld	a5,0(s4)
    80003e42:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e46:	000a3783          	ld	a5,0(s4)
    80003e4a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e4e:	000a3783          	ld	a5,0(s4)
    80003e52:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e56:	4501                	li	a0,0
    80003e58:	a025                	j	80003e80 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e5a:	6088                	ld	a0,0(s1)
    80003e5c:	e501                	bnez	a0,80003e64 <pipealloc+0xaa>
    80003e5e:	a039                	j	80003e6c <pipealloc+0xb2>
    80003e60:	6088                	ld	a0,0(s1)
    80003e62:	c51d                	beqz	a0,80003e90 <pipealloc+0xd6>
    fileclose(*f0);
    80003e64:	00000097          	auipc	ra,0x0
    80003e68:	c26080e7          	jalr	-986(ra) # 80003a8a <fileclose>
  if(*f1)
    80003e6c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e70:	557d                	li	a0,-1
  if(*f1)
    80003e72:	c799                	beqz	a5,80003e80 <pipealloc+0xc6>
    fileclose(*f1);
    80003e74:	853e                	mv	a0,a5
    80003e76:	00000097          	auipc	ra,0x0
    80003e7a:	c14080e7          	jalr	-1004(ra) # 80003a8a <fileclose>
  return -1;
    80003e7e:	557d                	li	a0,-1
}
    80003e80:	70a2                	ld	ra,40(sp)
    80003e82:	7402                	ld	s0,32(sp)
    80003e84:	64e2                	ld	s1,24(sp)
    80003e86:	6942                	ld	s2,16(sp)
    80003e88:	69a2                	ld	s3,8(sp)
    80003e8a:	6a02                	ld	s4,0(sp)
    80003e8c:	6145                	addi	sp,sp,48
    80003e8e:	8082                	ret
  return -1;
    80003e90:	557d                	li	a0,-1
    80003e92:	b7fd                	j	80003e80 <pipealloc+0xc6>

0000000080003e94 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e94:	1101                	addi	sp,sp,-32
    80003e96:	ec06                	sd	ra,24(sp)
    80003e98:	e822                	sd	s0,16(sp)
    80003e9a:	e426                	sd	s1,8(sp)
    80003e9c:	e04a                	sd	s2,0(sp)
    80003e9e:	1000                	addi	s0,sp,32
    80003ea0:	84aa                	mv	s1,a0
    80003ea2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003ea4:	00002097          	auipc	ra,0x2
    80003ea8:	340080e7          	jalr	832(ra) # 800061e4 <acquire>
  if(writable){
    80003eac:	02090d63          	beqz	s2,80003ee6 <pipeclose+0x52>
    pi->writeopen = 0;
    80003eb0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003eb4:	21848513          	addi	a0,s1,536
    80003eb8:	ffffd097          	auipc	ra,0xffffd
    80003ebc:	6d4080e7          	jalr	1748(ra) # 8000158c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ec0:	2204b783          	ld	a5,544(s1)
    80003ec4:	eb95                	bnez	a5,80003ef8 <pipeclose+0x64>
    release(&pi->lock);
    80003ec6:	8526                	mv	a0,s1
    80003ec8:	00002097          	auipc	ra,0x2
    80003ecc:	3d0080e7          	jalr	976(ra) # 80006298 <release>
    kfree((char*)pi);
    80003ed0:	8526                	mv	a0,s1
    80003ed2:	ffffc097          	auipc	ra,0xffffc
    80003ed6:	14a080e7          	jalr	330(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003eda:	60e2                	ld	ra,24(sp)
    80003edc:	6442                	ld	s0,16(sp)
    80003ede:	64a2                	ld	s1,8(sp)
    80003ee0:	6902                	ld	s2,0(sp)
    80003ee2:	6105                	addi	sp,sp,32
    80003ee4:	8082                	ret
    pi->readopen = 0;
    80003ee6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003eea:	21c48513          	addi	a0,s1,540
    80003eee:	ffffd097          	auipc	ra,0xffffd
    80003ef2:	69e080e7          	jalr	1694(ra) # 8000158c <wakeup>
    80003ef6:	b7e9                	j	80003ec0 <pipeclose+0x2c>
    release(&pi->lock);
    80003ef8:	8526                	mv	a0,s1
    80003efa:	00002097          	auipc	ra,0x2
    80003efe:	39e080e7          	jalr	926(ra) # 80006298 <release>
}
    80003f02:	bfe1                	j	80003eda <pipeclose+0x46>

0000000080003f04 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f04:	711d                	addi	sp,sp,-96
    80003f06:	ec86                	sd	ra,88(sp)
    80003f08:	e8a2                	sd	s0,80(sp)
    80003f0a:	e4a6                	sd	s1,72(sp)
    80003f0c:	e0ca                	sd	s2,64(sp)
    80003f0e:	fc4e                	sd	s3,56(sp)
    80003f10:	f852                	sd	s4,48(sp)
    80003f12:	f456                	sd	s5,40(sp)
    80003f14:	f05a                	sd	s6,32(sp)
    80003f16:	ec5e                	sd	s7,24(sp)
    80003f18:	e862                	sd	s8,16(sp)
    80003f1a:	1080                	addi	s0,sp,96
    80003f1c:	84aa                	mv	s1,a0
    80003f1e:	8aae                	mv	s5,a1
    80003f20:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f22:	ffffd097          	auipc	ra,0xffffd
    80003f26:	f56080e7          	jalr	-170(ra) # 80000e78 <myproc>
    80003f2a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f2c:	8526                	mv	a0,s1
    80003f2e:	00002097          	auipc	ra,0x2
    80003f32:	2b6080e7          	jalr	694(ra) # 800061e4 <acquire>
  while(i < n){
    80003f36:	0b405663          	blez	s4,80003fe2 <pipewrite+0xde>
  int i = 0;
    80003f3a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f3c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f3e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f42:	21c48b93          	addi	s7,s1,540
    80003f46:	a089                	j	80003f88 <pipewrite+0x84>
      release(&pi->lock);
    80003f48:	8526                	mv	a0,s1
    80003f4a:	00002097          	auipc	ra,0x2
    80003f4e:	34e080e7          	jalr	846(ra) # 80006298 <release>
      return -1;
    80003f52:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f54:	854a                	mv	a0,s2
    80003f56:	60e6                	ld	ra,88(sp)
    80003f58:	6446                	ld	s0,80(sp)
    80003f5a:	64a6                	ld	s1,72(sp)
    80003f5c:	6906                	ld	s2,64(sp)
    80003f5e:	79e2                	ld	s3,56(sp)
    80003f60:	7a42                	ld	s4,48(sp)
    80003f62:	7aa2                	ld	s5,40(sp)
    80003f64:	7b02                	ld	s6,32(sp)
    80003f66:	6be2                	ld	s7,24(sp)
    80003f68:	6c42                	ld	s8,16(sp)
    80003f6a:	6125                	addi	sp,sp,96
    80003f6c:	8082                	ret
      wakeup(&pi->nread);
    80003f6e:	8562                	mv	a0,s8
    80003f70:	ffffd097          	auipc	ra,0xffffd
    80003f74:	61c080e7          	jalr	1564(ra) # 8000158c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f78:	85a6                	mv	a1,s1
    80003f7a:	855e                	mv	a0,s7
    80003f7c:	ffffd097          	auipc	ra,0xffffd
    80003f80:	5ac080e7          	jalr	1452(ra) # 80001528 <sleep>
  while(i < n){
    80003f84:	07495063          	bge	s2,s4,80003fe4 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003f88:	2204a783          	lw	a5,544(s1)
    80003f8c:	dfd5                	beqz	a5,80003f48 <pipewrite+0x44>
    80003f8e:	854e                	mv	a0,s3
    80003f90:	ffffe097          	auipc	ra,0xffffe
    80003f94:	840080e7          	jalr	-1984(ra) # 800017d0 <killed>
    80003f98:	f945                	bnez	a0,80003f48 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f9a:	2184a783          	lw	a5,536(s1)
    80003f9e:	21c4a703          	lw	a4,540(s1)
    80003fa2:	2007879b          	addiw	a5,a5,512
    80003fa6:	fcf704e3          	beq	a4,a5,80003f6e <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003faa:	4685                	li	a3,1
    80003fac:	01590633          	add	a2,s2,s5
    80003fb0:	faf40593          	addi	a1,s0,-81
    80003fb4:	0509b503          	ld	a0,80(s3)
    80003fb8:	ffffd097          	auipc	ra,0xffffd
    80003fbc:	c0c080e7          	jalr	-1012(ra) # 80000bc4 <copyin>
    80003fc0:	03650263          	beq	a0,s6,80003fe4 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003fc4:	21c4a783          	lw	a5,540(s1)
    80003fc8:	0017871b          	addiw	a4,a5,1
    80003fcc:	20e4ae23          	sw	a4,540(s1)
    80003fd0:	1ff7f793          	andi	a5,a5,511
    80003fd4:	97a6                	add	a5,a5,s1
    80003fd6:	faf44703          	lbu	a4,-81(s0)
    80003fda:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fde:	2905                	addiw	s2,s2,1
    80003fe0:	b755                	j	80003f84 <pipewrite+0x80>
  int i = 0;
    80003fe2:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003fe4:	21848513          	addi	a0,s1,536
    80003fe8:	ffffd097          	auipc	ra,0xffffd
    80003fec:	5a4080e7          	jalr	1444(ra) # 8000158c <wakeup>
  release(&pi->lock);
    80003ff0:	8526                	mv	a0,s1
    80003ff2:	00002097          	auipc	ra,0x2
    80003ff6:	2a6080e7          	jalr	678(ra) # 80006298 <release>
  return i;
    80003ffa:	bfa9                	j	80003f54 <pipewrite+0x50>

0000000080003ffc <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003ffc:	715d                	addi	sp,sp,-80
    80003ffe:	e486                	sd	ra,72(sp)
    80004000:	e0a2                	sd	s0,64(sp)
    80004002:	fc26                	sd	s1,56(sp)
    80004004:	f84a                	sd	s2,48(sp)
    80004006:	f44e                	sd	s3,40(sp)
    80004008:	f052                	sd	s4,32(sp)
    8000400a:	ec56                	sd	s5,24(sp)
    8000400c:	e85a                	sd	s6,16(sp)
    8000400e:	0880                	addi	s0,sp,80
    80004010:	84aa                	mv	s1,a0
    80004012:	892e                	mv	s2,a1
    80004014:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004016:	ffffd097          	auipc	ra,0xffffd
    8000401a:	e62080e7          	jalr	-414(ra) # 80000e78 <myproc>
    8000401e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004020:	8526                	mv	a0,s1
    80004022:	00002097          	auipc	ra,0x2
    80004026:	1c2080e7          	jalr	450(ra) # 800061e4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000402a:	2184a703          	lw	a4,536(s1)
    8000402e:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004032:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004036:	02f71763          	bne	a4,a5,80004064 <piperead+0x68>
    8000403a:	2244a783          	lw	a5,548(s1)
    8000403e:	c39d                	beqz	a5,80004064 <piperead+0x68>
    if(killed(pr)){
    80004040:	8552                	mv	a0,s4
    80004042:	ffffd097          	auipc	ra,0xffffd
    80004046:	78e080e7          	jalr	1934(ra) # 800017d0 <killed>
    8000404a:	e949                	bnez	a0,800040dc <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000404c:	85a6                	mv	a1,s1
    8000404e:	854e                	mv	a0,s3
    80004050:	ffffd097          	auipc	ra,0xffffd
    80004054:	4d8080e7          	jalr	1240(ra) # 80001528 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004058:	2184a703          	lw	a4,536(s1)
    8000405c:	21c4a783          	lw	a5,540(s1)
    80004060:	fcf70de3          	beq	a4,a5,8000403a <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004064:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004066:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004068:	05505463          	blez	s5,800040b0 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    8000406c:	2184a783          	lw	a5,536(s1)
    80004070:	21c4a703          	lw	a4,540(s1)
    80004074:	02f70e63          	beq	a4,a5,800040b0 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004078:	0017871b          	addiw	a4,a5,1
    8000407c:	20e4ac23          	sw	a4,536(s1)
    80004080:	1ff7f793          	andi	a5,a5,511
    80004084:	97a6                	add	a5,a5,s1
    80004086:	0187c783          	lbu	a5,24(a5)
    8000408a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000408e:	4685                	li	a3,1
    80004090:	fbf40613          	addi	a2,s0,-65
    80004094:	85ca                	mv	a1,s2
    80004096:	050a3503          	ld	a0,80(s4)
    8000409a:	ffffd097          	auipc	ra,0xffffd
    8000409e:	a9e080e7          	jalr	-1378(ra) # 80000b38 <copyout>
    800040a2:	01650763          	beq	a0,s6,800040b0 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040a6:	2985                	addiw	s3,s3,1
    800040a8:	0905                	addi	s2,s2,1
    800040aa:	fd3a91e3          	bne	s5,s3,8000406c <piperead+0x70>
    800040ae:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040b0:	21c48513          	addi	a0,s1,540
    800040b4:	ffffd097          	auipc	ra,0xffffd
    800040b8:	4d8080e7          	jalr	1240(ra) # 8000158c <wakeup>
  release(&pi->lock);
    800040bc:	8526                	mv	a0,s1
    800040be:	00002097          	auipc	ra,0x2
    800040c2:	1da080e7          	jalr	474(ra) # 80006298 <release>
  return i;
}
    800040c6:	854e                	mv	a0,s3
    800040c8:	60a6                	ld	ra,72(sp)
    800040ca:	6406                	ld	s0,64(sp)
    800040cc:	74e2                	ld	s1,56(sp)
    800040ce:	7942                	ld	s2,48(sp)
    800040d0:	79a2                	ld	s3,40(sp)
    800040d2:	7a02                	ld	s4,32(sp)
    800040d4:	6ae2                	ld	s5,24(sp)
    800040d6:	6b42                	ld	s6,16(sp)
    800040d8:	6161                	addi	sp,sp,80
    800040da:	8082                	ret
      release(&pi->lock);
    800040dc:	8526                	mv	a0,s1
    800040de:	00002097          	auipc	ra,0x2
    800040e2:	1ba080e7          	jalr	442(ra) # 80006298 <release>
      return -1;
    800040e6:	59fd                	li	s3,-1
    800040e8:	bff9                	j	800040c6 <piperead+0xca>

00000000800040ea <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800040ea:	1141                	addi	sp,sp,-16
    800040ec:	e422                	sd	s0,8(sp)
    800040ee:	0800                	addi	s0,sp,16
    800040f0:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800040f2:	8905                	andi	a0,a0,1
    800040f4:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800040f6:	8b89                	andi	a5,a5,2
    800040f8:	c399                	beqz	a5,800040fe <flags2perm+0x14>
      perm |= PTE_W;
    800040fa:	00456513          	ori	a0,a0,4
    return perm;
}
    800040fe:	6422                	ld	s0,8(sp)
    80004100:	0141                	addi	sp,sp,16
    80004102:	8082                	ret

0000000080004104 <exec>:

int
exec(char *path, char **argv)
{
    80004104:	de010113          	addi	sp,sp,-544
    80004108:	20113c23          	sd	ra,536(sp)
    8000410c:	20813823          	sd	s0,528(sp)
    80004110:	20913423          	sd	s1,520(sp)
    80004114:	21213023          	sd	s2,512(sp)
    80004118:	ffce                	sd	s3,504(sp)
    8000411a:	fbd2                	sd	s4,496(sp)
    8000411c:	f7d6                	sd	s5,488(sp)
    8000411e:	f3da                	sd	s6,480(sp)
    80004120:	efde                	sd	s7,472(sp)
    80004122:	ebe2                	sd	s8,464(sp)
    80004124:	e7e6                	sd	s9,456(sp)
    80004126:	e3ea                	sd	s10,448(sp)
    80004128:	ff6e                	sd	s11,440(sp)
    8000412a:	1400                	addi	s0,sp,544
    8000412c:	892a                	mv	s2,a0
    8000412e:	dea43423          	sd	a0,-536(s0)
    80004132:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004136:	ffffd097          	auipc	ra,0xffffd
    8000413a:	d42080e7          	jalr	-702(ra) # 80000e78 <myproc>
    8000413e:	84aa                	mv	s1,a0

  begin_op();
    80004140:	fffff097          	auipc	ra,0xfffff
    80004144:	482080e7          	jalr	1154(ra) # 800035c2 <begin_op>

  if((ip = namei(path)) == 0){
    80004148:	854a                	mv	a0,s2
    8000414a:	fffff097          	auipc	ra,0xfffff
    8000414e:	258080e7          	jalr	600(ra) # 800033a2 <namei>
    80004152:	c93d                	beqz	a0,800041c8 <exec+0xc4>
    80004154:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004156:	fffff097          	auipc	ra,0xfffff
    8000415a:	aa0080e7          	jalr	-1376(ra) # 80002bf6 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000415e:	04000713          	li	a4,64
    80004162:	4681                	li	a3,0
    80004164:	e5040613          	addi	a2,s0,-432
    80004168:	4581                	li	a1,0
    8000416a:	8556                	mv	a0,s5
    8000416c:	fffff097          	auipc	ra,0xfffff
    80004170:	d3e080e7          	jalr	-706(ra) # 80002eaa <readi>
    80004174:	04000793          	li	a5,64
    80004178:	00f51a63          	bne	a0,a5,8000418c <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000417c:	e5042703          	lw	a4,-432(s0)
    80004180:	464c47b7          	lui	a5,0x464c4
    80004184:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004188:	04f70663          	beq	a4,a5,800041d4 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000418c:	8556                	mv	a0,s5
    8000418e:	fffff097          	auipc	ra,0xfffff
    80004192:	cca080e7          	jalr	-822(ra) # 80002e58 <iunlockput>
    end_op();
    80004196:	fffff097          	auipc	ra,0xfffff
    8000419a:	4aa080e7          	jalr	1194(ra) # 80003640 <end_op>
  }
  return -1;
    8000419e:	557d                	li	a0,-1
}
    800041a0:	21813083          	ld	ra,536(sp)
    800041a4:	21013403          	ld	s0,528(sp)
    800041a8:	20813483          	ld	s1,520(sp)
    800041ac:	20013903          	ld	s2,512(sp)
    800041b0:	79fe                	ld	s3,504(sp)
    800041b2:	7a5e                	ld	s4,496(sp)
    800041b4:	7abe                	ld	s5,488(sp)
    800041b6:	7b1e                	ld	s6,480(sp)
    800041b8:	6bfe                	ld	s7,472(sp)
    800041ba:	6c5e                	ld	s8,464(sp)
    800041bc:	6cbe                	ld	s9,456(sp)
    800041be:	6d1e                	ld	s10,448(sp)
    800041c0:	7dfa                	ld	s11,440(sp)
    800041c2:	22010113          	addi	sp,sp,544
    800041c6:	8082                	ret
    end_op();
    800041c8:	fffff097          	auipc	ra,0xfffff
    800041cc:	478080e7          	jalr	1144(ra) # 80003640 <end_op>
    return -1;
    800041d0:	557d                	li	a0,-1
    800041d2:	b7f9                	j	800041a0 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800041d4:	8526                	mv	a0,s1
    800041d6:	ffffd097          	auipc	ra,0xffffd
    800041da:	d66080e7          	jalr	-666(ra) # 80000f3c <proc_pagetable>
    800041de:	8b2a                	mv	s6,a0
    800041e0:	d555                	beqz	a0,8000418c <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041e2:	e7042783          	lw	a5,-400(s0)
    800041e6:	e8845703          	lhu	a4,-376(s0)
    800041ea:	c735                	beqz	a4,80004256 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041ec:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041ee:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    800041f2:	6a05                	lui	s4,0x1
    800041f4:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800041f8:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800041fc:	6d85                	lui	s11,0x1
    800041fe:	7d7d                	lui	s10,0xfffff
    80004200:	ac3d                	j	8000443e <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004202:	00004517          	auipc	a0,0x4
    80004206:	51e50513          	addi	a0,a0,1310 # 80008720 <syscalls+0x288>
    8000420a:	00002097          	auipc	ra,0x2
    8000420e:	aa2080e7          	jalr	-1374(ra) # 80005cac <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004212:	874a                	mv	a4,s2
    80004214:	009c86bb          	addw	a3,s9,s1
    80004218:	4581                	li	a1,0
    8000421a:	8556                	mv	a0,s5
    8000421c:	fffff097          	auipc	ra,0xfffff
    80004220:	c8e080e7          	jalr	-882(ra) # 80002eaa <readi>
    80004224:	2501                	sext.w	a0,a0
    80004226:	1aa91963          	bne	s2,a0,800043d8 <exec+0x2d4>
  for(i = 0; i < sz; i += PGSIZE){
    8000422a:	009d84bb          	addw	s1,s11,s1
    8000422e:	013d09bb          	addw	s3,s10,s3
    80004232:	1f74f663          	bgeu	s1,s7,8000441e <exec+0x31a>
    pa = walkaddr(pagetable, va + i);
    80004236:	02049593          	slli	a1,s1,0x20
    8000423a:	9181                	srli	a1,a1,0x20
    8000423c:	95e2                	add	a1,a1,s8
    8000423e:	855a                	mv	a0,s6
    80004240:	ffffc097          	auipc	ra,0xffffc
    80004244:	2e8080e7          	jalr	744(ra) # 80000528 <walkaddr>
    80004248:	862a                	mv	a2,a0
    if(pa == 0)
    8000424a:	dd45                	beqz	a0,80004202 <exec+0xfe>
      n = PGSIZE;
    8000424c:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000424e:	fd49f2e3          	bgeu	s3,s4,80004212 <exec+0x10e>
      n = sz - i;
    80004252:	894e                	mv	s2,s3
    80004254:	bf7d                	j	80004212 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004256:	4901                	li	s2,0
  iunlockput(ip);
    80004258:	8556                	mv	a0,s5
    8000425a:	fffff097          	auipc	ra,0xfffff
    8000425e:	bfe080e7          	jalr	-1026(ra) # 80002e58 <iunlockput>
  end_op();
    80004262:	fffff097          	auipc	ra,0xfffff
    80004266:	3de080e7          	jalr	990(ra) # 80003640 <end_op>
  p = myproc();
    8000426a:	ffffd097          	auipc	ra,0xffffd
    8000426e:	c0e080e7          	jalr	-1010(ra) # 80000e78 <myproc>
    80004272:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004274:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004278:	6785                	lui	a5,0x1
    8000427a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000427c:	97ca                	add	a5,a5,s2
    8000427e:	777d                	lui	a4,0xfffff
    80004280:	8ff9                	and	a5,a5,a4
    80004282:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004286:	4691                	li	a3,4
    80004288:	6609                	lui	a2,0x2
    8000428a:	963e                	add	a2,a2,a5
    8000428c:	85be                	mv	a1,a5
    8000428e:	855a                	mv	a0,s6
    80004290:	ffffc097          	auipc	ra,0xffffc
    80004294:	64c080e7          	jalr	1612(ra) # 800008dc <uvmalloc>
    80004298:	8c2a                	mv	s8,a0
  ip = 0;
    8000429a:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000429c:	12050e63          	beqz	a0,800043d8 <exec+0x2d4>
  uvmclear(pagetable, sz-2*PGSIZE);
    800042a0:	75f9                	lui	a1,0xffffe
    800042a2:	95aa                	add	a1,a1,a0
    800042a4:	855a                	mv	a0,s6
    800042a6:	ffffd097          	auipc	ra,0xffffd
    800042aa:	860080e7          	jalr	-1952(ra) # 80000b06 <uvmclear>
  stackbase = sp - PGSIZE;
    800042ae:	7afd                	lui	s5,0xfffff
    800042b0:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800042b2:	df043783          	ld	a5,-528(s0)
    800042b6:	6388                	ld	a0,0(a5)
    800042b8:	c925                	beqz	a0,80004328 <exec+0x224>
    800042ba:	e9040993          	addi	s3,s0,-368
    800042be:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800042c2:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800042c4:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800042c6:	ffffc097          	auipc	ra,0xffffc
    800042ca:	054080e7          	jalr	84(ra) # 8000031a <strlen>
    800042ce:	0015079b          	addiw	a5,a0,1
    800042d2:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042d6:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800042da:	13596663          	bltu	s2,s5,80004406 <exec+0x302>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042de:	df043d83          	ld	s11,-528(s0)
    800042e2:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800042e6:	8552                	mv	a0,s4
    800042e8:	ffffc097          	auipc	ra,0xffffc
    800042ec:	032080e7          	jalr	50(ra) # 8000031a <strlen>
    800042f0:	0015069b          	addiw	a3,a0,1
    800042f4:	8652                	mv	a2,s4
    800042f6:	85ca                	mv	a1,s2
    800042f8:	855a                	mv	a0,s6
    800042fa:	ffffd097          	auipc	ra,0xffffd
    800042fe:	83e080e7          	jalr	-1986(ra) # 80000b38 <copyout>
    80004302:	10054663          	bltz	a0,8000440e <exec+0x30a>
    ustack[argc] = sp;
    80004306:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000430a:	0485                	addi	s1,s1,1
    8000430c:	008d8793          	addi	a5,s11,8
    80004310:	def43823          	sd	a5,-528(s0)
    80004314:	008db503          	ld	a0,8(s11)
    80004318:	c911                	beqz	a0,8000432c <exec+0x228>
    if(argc >= MAXARG)
    8000431a:	09a1                	addi	s3,s3,8
    8000431c:	fb3c95e3          	bne	s9,s3,800042c6 <exec+0x1c2>
  sz = sz1;
    80004320:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004324:	4a81                	li	s5,0
    80004326:	a84d                	j	800043d8 <exec+0x2d4>
  sp = sz;
    80004328:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000432a:	4481                	li	s1,0
  ustack[argc] = 0;
    8000432c:	00349793          	slli	a5,s1,0x3
    80004330:	f9078793          	addi	a5,a5,-112
    80004334:	97a2                	add	a5,a5,s0
    80004336:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000433a:	00148693          	addi	a3,s1,1
    8000433e:	068e                	slli	a3,a3,0x3
    80004340:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004344:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004348:	01597663          	bgeu	s2,s5,80004354 <exec+0x250>
  sz = sz1;
    8000434c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004350:	4a81                	li	s5,0
    80004352:	a059                	j	800043d8 <exec+0x2d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004354:	e9040613          	addi	a2,s0,-368
    80004358:	85ca                	mv	a1,s2
    8000435a:	855a                	mv	a0,s6
    8000435c:	ffffc097          	auipc	ra,0xffffc
    80004360:	7dc080e7          	jalr	2012(ra) # 80000b38 <copyout>
    80004364:	0a054963          	bltz	a0,80004416 <exec+0x312>
  p->trapframe->a1 = sp;
    80004368:	058bb783          	ld	a5,88(s7)
    8000436c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004370:	de843783          	ld	a5,-536(s0)
    80004374:	0007c703          	lbu	a4,0(a5)
    80004378:	cf11                	beqz	a4,80004394 <exec+0x290>
    8000437a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000437c:	02f00693          	li	a3,47
    80004380:	a039                	j	8000438e <exec+0x28a>
      last = s+1;
    80004382:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004386:	0785                	addi	a5,a5,1
    80004388:	fff7c703          	lbu	a4,-1(a5)
    8000438c:	c701                	beqz	a4,80004394 <exec+0x290>
    if(*s == '/')
    8000438e:	fed71ce3          	bne	a4,a3,80004386 <exec+0x282>
    80004392:	bfc5                	j	80004382 <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    80004394:	4641                	li	a2,16
    80004396:	de843583          	ld	a1,-536(s0)
    8000439a:	158b8513          	addi	a0,s7,344
    8000439e:	ffffc097          	auipc	ra,0xffffc
    800043a2:	f4a080e7          	jalr	-182(ra) # 800002e8 <safestrcpy>
  oldpagetable = p->pagetable;
    800043a6:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    800043aa:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800043ae:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800043b2:	058bb783          	ld	a5,88(s7)
    800043b6:	e6843703          	ld	a4,-408(s0)
    800043ba:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800043bc:	058bb783          	ld	a5,88(s7)
    800043c0:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800043c4:	85ea                	mv	a1,s10
    800043c6:	ffffd097          	auipc	ra,0xffffd
    800043ca:	c12080e7          	jalr	-1006(ra) # 80000fd8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800043ce:	0004851b          	sext.w	a0,s1
    800043d2:	b3f9                	j	800041a0 <exec+0x9c>
    800043d4:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    800043d8:	df843583          	ld	a1,-520(s0)
    800043dc:	855a                	mv	a0,s6
    800043de:	ffffd097          	auipc	ra,0xffffd
    800043e2:	bfa080e7          	jalr	-1030(ra) # 80000fd8 <proc_freepagetable>
  if(ip){
    800043e6:	da0a93e3          	bnez	s5,8000418c <exec+0x88>
  return -1;
    800043ea:	557d                	li	a0,-1
    800043ec:	bb55                	j	800041a0 <exec+0x9c>
    800043ee:	df243c23          	sd	s2,-520(s0)
    800043f2:	b7dd                	j	800043d8 <exec+0x2d4>
    800043f4:	df243c23          	sd	s2,-520(s0)
    800043f8:	b7c5                	j	800043d8 <exec+0x2d4>
    800043fa:	df243c23          	sd	s2,-520(s0)
    800043fe:	bfe9                	j	800043d8 <exec+0x2d4>
    80004400:	df243c23          	sd	s2,-520(s0)
    80004404:	bfd1                	j	800043d8 <exec+0x2d4>
  sz = sz1;
    80004406:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000440a:	4a81                	li	s5,0
    8000440c:	b7f1                	j	800043d8 <exec+0x2d4>
  sz = sz1;
    8000440e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004412:	4a81                	li	s5,0
    80004414:	b7d1                	j	800043d8 <exec+0x2d4>
  sz = sz1;
    80004416:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000441a:	4a81                	li	s5,0
    8000441c:	bf75                	j	800043d8 <exec+0x2d4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000441e:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004422:	e0843783          	ld	a5,-504(s0)
    80004426:	0017869b          	addiw	a3,a5,1
    8000442a:	e0d43423          	sd	a3,-504(s0)
    8000442e:	e0043783          	ld	a5,-512(s0)
    80004432:	0387879b          	addiw	a5,a5,56
    80004436:	e8845703          	lhu	a4,-376(s0)
    8000443a:	e0e6dfe3          	bge	a3,a4,80004258 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000443e:	2781                	sext.w	a5,a5
    80004440:	e0f43023          	sd	a5,-512(s0)
    80004444:	03800713          	li	a4,56
    80004448:	86be                	mv	a3,a5
    8000444a:	e1840613          	addi	a2,s0,-488
    8000444e:	4581                	li	a1,0
    80004450:	8556                	mv	a0,s5
    80004452:	fffff097          	auipc	ra,0xfffff
    80004456:	a58080e7          	jalr	-1448(ra) # 80002eaa <readi>
    8000445a:	03800793          	li	a5,56
    8000445e:	f6f51be3          	bne	a0,a5,800043d4 <exec+0x2d0>
    if(ph.type != ELF_PROG_LOAD)
    80004462:	e1842783          	lw	a5,-488(s0)
    80004466:	4705                	li	a4,1
    80004468:	fae79de3          	bne	a5,a4,80004422 <exec+0x31e>
    if(ph.memsz < ph.filesz)
    8000446c:	e4043483          	ld	s1,-448(s0)
    80004470:	e3843783          	ld	a5,-456(s0)
    80004474:	f6f4ede3          	bltu	s1,a5,800043ee <exec+0x2ea>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004478:	e2843783          	ld	a5,-472(s0)
    8000447c:	94be                	add	s1,s1,a5
    8000447e:	f6f4ebe3          	bltu	s1,a5,800043f4 <exec+0x2f0>
    if(ph.vaddr % PGSIZE != 0)
    80004482:	de043703          	ld	a4,-544(s0)
    80004486:	8ff9                	and	a5,a5,a4
    80004488:	fbad                	bnez	a5,800043fa <exec+0x2f6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000448a:	e1c42503          	lw	a0,-484(s0)
    8000448e:	00000097          	auipc	ra,0x0
    80004492:	c5c080e7          	jalr	-932(ra) # 800040ea <flags2perm>
    80004496:	86aa                	mv	a3,a0
    80004498:	8626                	mv	a2,s1
    8000449a:	85ca                	mv	a1,s2
    8000449c:	855a                	mv	a0,s6
    8000449e:	ffffc097          	auipc	ra,0xffffc
    800044a2:	43e080e7          	jalr	1086(ra) # 800008dc <uvmalloc>
    800044a6:	dea43c23          	sd	a0,-520(s0)
    800044aa:	d939                	beqz	a0,80004400 <exec+0x2fc>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800044ac:	e2843c03          	ld	s8,-472(s0)
    800044b0:	e2042c83          	lw	s9,-480(s0)
    800044b4:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800044b8:	f60b83e3          	beqz	s7,8000441e <exec+0x31a>
    800044bc:	89de                	mv	s3,s7
    800044be:	4481                	li	s1,0
    800044c0:	bb9d                	j	80004236 <exec+0x132>

00000000800044c2 <argfd>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int argfd(int n, int *pfd, struct file **pf)
{
    800044c2:	7179                	addi	sp,sp,-48
    800044c4:	f406                	sd	ra,40(sp)
    800044c6:	f022                	sd	s0,32(sp)
    800044c8:	ec26                	sd	s1,24(sp)
    800044ca:	e84a                	sd	s2,16(sp)
    800044cc:	1800                	addi	s0,sp,48
    800044ce:	892e                	mv	s2,a1
    800044d0:	84b2                	mv	s1,a2
    int fd;
    struct file *f;

    argint(n, &fd);
    800044d2:	fdc40593          	addi	a1,s0,-36
    800044d6:	ffffe097          	auipc	ra,0xffffe
    800044da:	aee080e7          	jalr	-1298(ra) # 80001fc4 <argint>
    if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    800044de:	fdc42703          	lw	a4,-36(s0)
    800044e2:	47bd                	li	a5,15
    800044e4:	02e7eb63          	bltu	a5,a4,8000451a <argfd+0x58>
    800044e8:	ffffd097          	auipc	ra,0xffffd
    800044ec:	990080e7          	jalr	-1648(ra) # 80000e78 <myproc>
    800044f0:	fdc42703          	lw	a4,-36(s0)
    800044f4:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffdcf0a>
    800044f8:	078e                	slli	a5,a5,0x3
    800044fa:	953e                	add	a0,a0,a5
    800044fc:	611c                	ld	a5,0(a0)
    800044fe:	c385                	beqz	a5,8000451e <argfd+0x5c>
        return -1;
    if (pfd)
    80004500:	00090463          	beqz	s2,80004508 <argfd+0x46>
        *pfd = fd;
    80004504:	00e92023          	sw	a4,0(s2)
    if (pf)
        *pf = f;
    return 0;
    80004508:	4501                	li	a0,0
    if (pf)
    8000450a:	c091                	beqz	s1,8000450e <argfd+0x4c>
        *pf = f;
    8000450c:	e09c                	sd	a5,0(s1)
}
    8000450e:	70a2                	ld	ra,40(sp)
    80004510:	7402                	ld	s0,32(sp)
    80004512:	64e2                	ld	s1,24(sp)
    80004514:	6942                	ld	s2,16(sp)
    80004516:	6145                	addi	sp,sp,48
    80004518:	8082                	ret
        return -1;
    8000451a:	557d                	li	a0,-1
    8000451c:	bfcd                	j	8000450e <argfd+0x4c>
    8000451e:	557d                	li	a0,-1
    80004520:	b7fd                	j	8000450e <argfd+0x4c>

0000000080004522 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int fdalloc(struct file *f)
{
    80004522:	1101                	addi	sp,sp,-32
    80004524:	ec06                	sd	ra,24(sp)
    80004526:	e822                	sd	s0,16(sp)
    80004528:	e426                	sd	s1,8(sp)
    8000452a:	1000                	addi	s0,sp,32
    8000452c:	84aa                	mv	s1,a0
    int fd;
    struct proc *p = myproc();
    8000452e:	ffffd097          	auipc	ra,0xffffd
    80004532:	94a080e7          	jalr	-1718(ra) # 80000e78 <myproc>
    80004536:	862a                	mv	a2,a0

    for (fd = 0; fd < NOFILE; fd++) {
    80004538:	0d050793          	addi	a5,a0,208
    8000453c:	4501                	li	a0,0
    8000453e:	46c1                	li	a3,16
        if (p->ofile[fd] == 0) {
    80004540:	6398                	ld	a4,0(a5)
    80004542:	cb19                	beqz	a4,80004558 <fdalloc+0x36>
    for (fd = 0; fd < NOFILE; fd++) {
    80004544:	2505                	addiw	a0,a0,1
    80004546:	07a1                	addi	a5,a5,8
    80004548:	fed51ce3          	bne	a0,a3,80004540 <fdalloc+0x1e>
            p->ofile[fd] = f;
            return fd;
        }
    }
    return -1;
    8000454c:	557d                	li	a0,-1
}
    8000454e:	60e2                	ld	ra,24(sp)
    80004550:	6442                	ld	s0,16(sp)
    80004552:	64a2                	ld	s1,8(sp)
    80004554:	6105                	addi	sp,sp,32
    80004556:	8082                	ret
            p->ofile[fd] = f;
    80004558:	01a50793          	addi	a5,a0,26
    8000455c:	078e                	slli	a5,a5,0x3
    8000455e:	963e                	add	a2,a2,a5
    80004560:	e204                	sd	s1,0(a2)
            return fd;
    80004562:	b7f5                	j	8000454e <fdalloc+0x2c>

0000000080004564 <create>:
    end_op();
    return -1;
}

static struct inode *create(char *path, short type, short major, short minor)
{
    80004564:	715d                	addi	sp,sp,-80
    80004566:	e486                	sd	ra,72(sp)
    80004568:	e0a2                	sd	s0,64(sp)
    8000456a:	fc26                	sd	s1,56(sp)
    8000456c:	f84a                	sd	s2,48(sp)
    8000456e:	f44e                	sd	s3,40(sp)
    80004570:	f052                	sd	s4,32(sp)
    80004572:	ec56                	sd	s5,24(sp)
    80004574:	e85a                	sd	s6,16(sp)
    80004576:	0880                	addi	s0,sp,80
    80004578:	8b2e                	mv	s6,a1
    8000457a:	89b2                	mv	s3,a2
    8000457c:	8936                	mv	s2,a3
    struct inode *ip, *dp;
    char name[DIRSIZ];

    if ((dp = nameiparent(path, name)) == 0)
    8000457e:	fb040593          	addi	a1,s0,-80
    80004582:	fffff097          	auipc	ra,0xfffff
    80004586:	e3e080e7          	jalr	-450(ra) # 800033c0 <nameiparent>
    8000458a:	84aa                	mv	s1,a0
    8000458c:	14050f63          	beqz	a0,800046ea <create+0x186>
        return 0;

    ilock(dp);
    80004590:	ffffe097          	auipc	ra,0xffffe
    80004594:	666080e7          	jalr	1638(ra) # 80002bf6 <ilock>

    if ((ip = dirlookup(dp, name, 0)) != 0) {
    80004598:	4601                	li	a2,0
    8000459a:	fb040593          	addi	a1,s0,-80
    8000459e:	8526                	mv	a0,s1
    800045a0:	fffff097          	auipc	ra,0xfffff
    800045a4:	b3a080e7          	jalr	-1222(ra) # 800030da <dirlookup>
    800045a8:	8aaa                	mv	s5,a0
    800045aa:	c931                	beqz	a0,800045fe <create+0x9a>
        iunlockput(dp);
    800045ac:	8526                	mv	a0,s1
    800045ae:	fffff097          	auipc	ra,0xfffff
    800045b2:	8aa080e7          	jalr	-1878(ra) # 80002e58 <iunlockput>
        ilock(ip);
    800045b6:	8556                	mv	a0,s5
    800045b8:	ffffe097          	auipc	ra,0xffffe
    800045bc:	63e080e7          	jalr	1598(ra) # 80002bf6 <ilock>
        if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800045c0:	000b059b          	sext.w	a1,s6
    800045c4:	4789                	li	a5,2
    800045c6:	02f59563          	bne	a1,a5,800045f0 <create+0x8c>
    800045ca:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdcf34>
    800045ce:	37f9                	addiw	a5,a5,-2
    800045d0:	17c2                	slli	a5,a5,0x30
    800045d2:	93c1                	srli	a5,a5,0x30
    800045d4:	4705                	li	a4,1
    800045d6:	00f76d63          	bltu	a4,a5,800045f0 <create+0x8c>
    ip->nlink = 0;
    iupdate(ip);
    iunlockput(ip);
    iunlockput(dp);
    return 0;
}
    800045da:	8556                	mv	a0,s5
    800045dc:	60a6                	ld	ra,72(sp)
    800045de:	6406                	ld	s0,64(sp)
    800045e0:	74e2                	ld	s1,56(sp)
    800045e2:	7942                	ld	s2,48(sp)
    800045e4:	79a2                	ld	s3,40(sp)
    800045e6:	7a02                	ld	s4,32(sp)
    800045e8:	6ae2                	ld	s5,24(sp)
    800045ea:	6b42                	ld	s6,16(sp)
    800045ec:	6161                	addi	sp,sp,80
    800045ee:	8082                	ret
        iunlockput(ip);
    800045f0:	8556                	mv	a0,s5
    800045f2:	fffff097          	auipc	ra,0xfffff
    800045f6:	866080e7          	jalr	-1946(ra) # 80002e58 <iunlockput>
        return 0;
    800045fa:	4a81                	li	s5,0
    800045fc:	bff9                	j	800045da <create+0x76>
    if ((ip = ialloc(dp->dev, type)) == 0) {
    800045fe:	85da                	mv	a1,s6
    80004600:	4088                	lw	a0,0(s1)
    80004602:	ffffe097          	auipc	ra,0xffffe
    80004606:	456080e7          	jalr	1110(ra) # 80002a58 <ialloc>
    8000460a:	8a2a                	mv	s4,a0
    8000460c:	c539                	beqz	a0,8000465a <create+0xf6>
    ilock(ip);
    8000460e:	ffffe097          	auipc	ra,0xffffe
    80004612:	5e8080e7          	jalr	1512(ra) # 80002bf6 <ilock>
    ip->major = major;
    80004616:	053a1323          	sh	s3,70(s4)
    ip->minor = minor;
    8000461a:	052a1423          	sh	s2,72(s4)
    ip->nlink = 1;
    8000461e:	4905                	li	s2,1
    80004620:	052a1523          	sh	s2,74(s4)
    iupdate(ip);
    80004624:	8552                	mv	a0,s4
    80004626:	ffffe097          	auipc	ra,0xffffe
    8000462a:	504080e7          	jalr	1284(ra) # 80002b2a <iupdate>
    if (type == T_DIR) { // Create . and .. entries.
    8000462e:	000b059b          	sext.w	a1,s6
    80004632:	03258b63          	beq	a1,s2,80004668 <create+0x104>
    if (dirlink(dp, name, ip->inum) < 0)
    80004636:	004a2603          	lw	a2,4(s4)
    8000463a:	fb040593          	addi	a1,s0,-80
    8000463e:	8526                	mv	a0,s1
    80004640:	fffff097          	auipc	ra,0xfffff
    80004644:	cb0080e7          	jalr	-848(ra) # 800032f0 <dirlink>
    80004648:	06054f63          	bltz	a0,800046c6 <create+0x162>
    iunlockput(dp);
    8000464c:	8526                	mv	a0,s1
    8000464e:	fffff097          	auipc	ra,0xfffff
    80004652:	80a080e7          	jalr	-2038(ra) # 80002e58 <iunlockput>
    return ip;
    80004656:	8ad2                	mv	s5,s4
    80004658:	b749                	j	800045da <create+0x76>
        iunlockput(dp);
    8000465a:	8526                	mv	a0,s1
    8000465c:	ffffe097          	auipc	ra,0xffffe
    80004660:	7fc080e7          	jalr	2044(ra) # 80002e58 <iunlockput>
        return 0;
    80004664:	8ad2                	mv	s5,s4
    80004666:	bf95                	j	800045da <create+0x76>
        if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004668:	004a2603          	lw	a2,4(s4)
    8000466c:	00004597          	auipc	a1,0x4
    80004670:	0d458593          	addi	a1,a1,212 # 80008740 <syscalls+0x2a8>
    80004674:	8552                	mv	a0,s4
    80004676:	fffff097          	auipc	ra,0xfffff
    8000467a:	c7a080e7          	jalr	-902(ra) # 800032f0 <dirlink>
    8000467e:	04054463          	bltz	a0,800046c6 <create+0x162>
    80004682:	40d0                	lw	a2,4(s1)
    80004684:	00004597          	auipc	a1,0x4
    80004688:	0c458593          	addi	a1,a1,196 # 80008748 <syscalls+0x2b0>
    8000468c:	8552                	mv	a0,s4
    8000468e:	fffff097          	auipc	ra,0xfffff
    80004692:	c62080e7          	jalr	-926(ra) # 800032f0 <dirlink>
    80004696:	02054863          	bltz	a0,800046c6 <create+0x162>
    if (dirlink(dp, name, ip->inum) < 0)
    8000469a:	004a2603          	lw	a2,4(s4)
    8000469e:	fb040593          	addi	a1,s0,-80
    800046a2:	8526                	mv	a0,s1
    800046a4:	fffff097          	auipc	ra,0xfffff
    800046a8:	c4c080e7          	jalr	-948(ra) # 800032f0 <dirlink>
    800046ac:	00054d63          	bltz	a0,800046c6 <create+0x162>
        dp->nlink++; // for ".."
    800046b0:	04a4d783          	lhu	a5,74(s1)
    800046b4:	2785                	addiw	a5,a5,1
    800046b6:	04f49523          	sh	a5,74(s1)
        iupdate(dp);
    800046ba:	8526                	mv	a0,s1
    800046bc:	ffffe097          	auipc	ra,0xffffe
    800046c0:	46e080e7          	jalr	1134(ra) # 80002b2a <iupdate>
    800046c4:	b761                	j	8000464c <create+0xe8>
    ip->nlink = 0;
    800046c6:	040a1523          	sh	zero,74(s4)
    iupdate(ip);
    800046ca:	8552                	mv	a0,s4
    800046cc:	ffffe097          	auipc	ra,0xffffe
    800046d0:	45e080e7          	jalr	1118(ra) # 80002b2a <iupdate>
    iunlockput(ip);
    800046d4:	8552                	mv	a0,s4
    800046d6:	ffffe097          	auipc	ra,0xffffe
    800046da:	782080e7          	jalr	1922(ra) # 80002e58 <iunlockput>
    iunlockput(dp);
    800046de:	8526                	mv	a0,s1
    800046e0:	ffffe097          	auipc	ra,0xffffe
    800046e4:	778080e7          	jalr	1912(ra) # 80002e58 <iunlockput>
    return 0;
    800046e8:	bdcd                	j	800045da <create+0x76>
        return 0;
    800046ea:	8aaa                	mv	s5,a0
    800046ec:	b5fd                	j	800045da <create+0x76>

00000000800046ee <sys_dup>:
{
    800046ee:	7179                	addi	sp,sp,-48
    800046f0:	f406                	sd	ra,40(sp)
    800046f2:	f022                	sd	s0,32(sp)
    800046f4:	ec26                	sd	s1,24(sp)
    800046f6:	e84a                	sd	s2,16(sp)
    800046f8:	1800                	addi	s0,sp,48
    if (argfd(0, 0, &f) < 0)
    800046fa:	fd840613          	addi	a2,s0,-40
    800046fe:	4581                	li	a1,0
    80004700:	4501                	li	a0,0
    80004702:	00000097          	auipc	ra,0x0
    80004706:	dc0080e7          	jalr	-576(ra) # 800044c2 <argfd>
        return -1;
    8000470a:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0)
    8000470c:	02054363          	bltz	a0,80004732 <sys_dup+0x44>
    if ((fd = fdalloc(f)) < 0)
    80004710:	fd843903          	ld	s2,-40(s0)
    80004714:	854a                	mv	a0,s2
    80004716:	00000097          	auipc	ra,0x0
    8000471a:	e0c080e7          	jalr	-500(ra) # 80004522 <fdalloc>
    8000471e:	84aa                	mv	s1,a0
        return -1;
    80004720:	57fd                	li	a5,-1
    if ((fd = fdalloc(f)) < 0)
    80004722:	00054863          	bltz	a0,80004732 <sys_dup+0x44>
    filedup(f);
    80004726:	854a                	mv	a0,s2
    80004728:	fffff097          	auipc	ra,0xfffff
    8000472c:	310080e7          	jalr	784(ra) # 80003a38 <filedup>
    return fd;
    80004730:	87a6                	mv	a5,s1
}
    80004732:	853e                	mv	a0,a5
    80004734:	70a2                	ld	ra,40(sp)
    80004736:	7402                	ld	s0,32(sp)
    80004738:	64e2                	ld	s1,24(sp)
    8000473a:	6942                	ld	s2,16(sp)
    8000473c:	6145                	addi	sp,sp,48
    8000473e:	8082                	ret

0000000080004740 <sys_read>:
{
    80004740:	7179                	addi	sp,sp,-48
    80004742:	f406                	sd	ra,40(sp)
    80004744:	f022                	sd	s0,32(sp)
    80004746:	1800                	addi	s0,sp,48
    argaddr(1, &p);
    80004748:	fd840593          	addi	a1,s0,-40
    8000474c:	4505                	li	a0,1
    8000474e:	ffffe097          	auipc	ra,0xffffe
    80004752:	896080e7          	jalr	-1898(ra) # 80001fe4 <argaddr>
    argint(2, &n);
    80004756:	fe440593          	addi	a1,s0,-28
    8000475a:	4509                	li	a0,2
    8000475c:	ffffe097          	auipc	ra,0xffffe
    80004760:	868080e7          	jalr	-1944(ra) # 80001fc4 <argint>
    if (argfd(0, 0, &f) < 0)
    80004764:	fe840613          	addi	a2,s0,-24
    80004768:	4581                	li	a1,0
    8000476a:	4501                	li	a0,0
    8000476c:	00000097          	auipc	ra,0x0
    80004770:	d56080e7          	jalr	-682(ra) # 800044c2 <argfd>
    80004774:	87aa                	mv	a5,a0
        return -1;
    80004776:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    80004778:	0007cc63          	bltz	a5,80004790 <sys_read+0x50>
    return fileread(f, p, n);
    8000477c:	fe442603          	lw	a2,-28(s0)
    80004780:	fd843583          	ld	a1,-40(s0)
    80004784:	fe843503          	ld	a0,-24(s0)
    80004788:	fffff097          	auipc	ra,0xfffff
    8000478c:	43c080e7          	jalr	1084(ra) # 80003bc4 <fileread>
}
    80004790:	70a2                	ld	ra,40(sp)
    80004792:	7402                	ld	s0,32(sp)
    80004794:	6145                	addi	sp,sp,48
    80004796:	8082                	ret

0000000080004798 <sys_write>:
{
    80004798:	7179                	addi	sp,sp,-48
    8000479a:	f406                	sd	ra,40(sp)
    8000479c:	f022                	sd	s0,32(sp)
    8000479e:	1800                	addi	s0,sp,48
    argaddr(1, &p);
    800047a0:	fd840593          	addi	a1,s0,-40
    800047a4:	4505                	li	a0,1
    800047a6:	ffffe097          	auipc	ra,0xffffe
    800047aa:	83e080e7          	jalr	-1986(ra) # 80001fe4 <argaddr>
    argint(2, &n);
    800047ae:	fe440593          	addi	a1,s0,-28
    800047b2:	4509                	li	a0,2
    800047b4:	ffffe097          	auipc	ra,0xffffe
    800047b8:	810080e7          	jalr	-2032(ra) # 80001fc4 <argint>
    if (argfd(0, 0, &f) < 0)
    800047bc:	fe840613          	addi	a2,s0,-24
    800047c0:	4581                	li	a1,0
    800047c2:	4501                	li	a0,0
    800047c4:	00000097          	auipc	ra,0x0
    800047c8:	cfe080e7          	jalr	-770(ra) # 800044c2 <argfd>
    800047cc:	87aa                	mv	a5,a0
        return -1;
    800047ce:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    800047d0:	0007cc63          	bltz	a5,800047e8 <sys_write+0x50>
    return filewrite(f, p, n);
    800047d4:	fe442603          	lw	a2,-28(s0)
    800047d8:	fd843583          	ld	a1,-40(s0)
    800047dc:	fe843503          	ld	a0,-24(s0)
    800047e0:	fffff097          	auipc	ra,0xfffff
    800047e4:	4a6080e7          	jalr	1190(ra) # 80003c86 <filewrite>
}
    800047e8:	70a2                	ld	ra,40(sp)
    800047ea:	7402                	ld	s0,32(sp)
    800047ec:	6145                	addi	sp,sp,48
    800047ee:	8082                	ret

00000000800047f0 <sys_close>:
{
    800047f0:	1101                	addi	sp,sp,-32
    800047f2:	ec06                	sd	ra,24(sp)
    800047f4:	e822                	sd	s0,16(sp)
    800047f6:	1000                	addi	s0,sp,32
    if (argfd(0, &fd, &f) < 0)
    800047f8:	fe040613          	addi	a2,s0,-32
    800047fc:	fec40593          	addi	a1,s0,-20
    80004800:	4501                	li	a0,0
    80004802:	00000097          	auipc	ra,0x0
    80004806:	cc0080e7          	jalr	-832(ra) # 800044c2 <argfd>
        return -1;
    8000480a:	57fd                	li	a5,-1
    if (argfd(0, &fd, &f) < 0)
    8000480c:	02054463          	bltz	a0,80004834 <sys_close+0x44>
    myproc()->ofile[fd] = 0;
    80004810:	ffffc097          	auipc	ra,0xffffc
    80004814:	668080e7          	jalr	1640(ra) # 80000e78 <myproc>
    80004818:	fec42783          	lw	a5,-20(s0)
    8000481c:	07e9                	addi	a5,a5,26
    8000481e:	078e                	slli	a5,a5,0x3
    80004820:	953e                	add	a0,a0,a5
    80004822:	00053023          	sd	zero,0(a0)
    fileclose(f);
    80004826:	fe043503          	ld	a0,-32(s0)
    8000482a:	fffff097          	auipc	ra,0xfffff
    8000482e:	260080e7          	jalr	608(ra) # 80003a8a <fileclose>
    return 0;
    80004832:	4781                	li	a5,0
}
    80004834:	853e                	mv	a0,a5
    80004836:	60e2                	ld	ra,24(sp)
    80004838:	6442                	ld	s0,16(sp)
    8000483a:	6105                	addi	sp,sp,32
    8000483c:	8082                	ret

000000008000483e <sys_fstat>:
{
    8000483e:	1101                	addi	sp,sp,-32
    80004840:	ec06                	sd	ra,24(sp)
    80004842:	e822                	sd	s0,16(sp)
    80004844:	1000                	addi	s0,sp,32
    argaddr(1, &st);
    80004846:	fe040593          	addi	a1,s0,-32
    8000484a:	4505                	li	a0,1
    8000484c:	ffffd097          	auipc	ra,0xffffd
    80004850:	798080e7          	jalr	1944(ra) # 80001fe4 <argaddr>
    if (argfd(0, 0, &f) < 0)
    80004854:	fe840613          	addi	a2,s0,-24
    80004858:	4581                	li	a1,0
    8000485a:	4501                	li	a0,0
    8000485c:	00000097          	auipc	ra,0x0
    80004860:	c66080e7          	jalr	-922(ra) # 800044c2 <argfd>
    80004864:	87aa                	mv	a5,a0
        return -1;
    80004866:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    80004868:	0007ca63          	bltz	a5,8000487c <sys_fstat+0x3e>
    return filestat(f, st);
    8000486c:	fe043583          	ld	a1,-32(s0)
    80004870:	fe843503          	ld	a0,-24(s0)
    80004874:	fffff097          	auipc	ra,0xfffff
    80004878:	2de080e7          	jalr	734(ra) # 80003b52 <filestat>
}
    8000487c:	60e2                	ld	ra,24(sp)
    8000487e:	6442                	ld	s0,16(sp)
    80004880:	6105                	addi	sp,sp,32
    80004882:	8082                	ret

0000000080004884 <sys_link>:
{
    80004884:	7169                	addi	sp,sp,-304
    80004886:	f606                	sd	ra,296(sp)
    80004888:	f222                	sd	s0,288(sp)
    8000488a:	ee26                	sd	s1,280(sp)
    8000488c:	ea4a                	sd	s2,272(sp)
    8000488e:	1a00                	addi	s0,sp,304
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004890:	08000613          	li	a2,128
    80004894:	ed040593          	addi	a1,s0,-304
    80004898:	4501                	li	a0,0
    8000489a:	ffffd097          	auipc	ra,0xffffd
    8000489e:	76a080e7          	jalr	1898(ra) # 80002004 <argstr>
        return -1;
    800048a2:	57fd                	li	a5,-1
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048a4:	10054e63          	bltz	a0,800049c0 <sys_link+0x13c>
    800048a8:	08000613          	li	a2,128
    800048ac:	f5040593          	addi	a1,s0,-176
    800048b0:	4505                	li	a0,1
    800048b2:	ffffd097          	auipc	ra,0xffffd
    800048b6:	752080e7          	jalr	1874(ra) # 80002004 <argstr>
        return -1;
    800048ba:	57fd                	li	a5,-1
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048bc:	10054263          	bltz	a0,800049c0 <sys_link+0x13c>
    begin_op();
    800048c0:	fffff097          	auipc	ra,0xfffff
    800048c4:	d02080e7          	jalr	-766(ra) # 800035c2 <begin_op>
    if ((ip = namei(old)) == 0) {
    800048c8:	ed040513          	addi	a0,s0,-304
    800048cc:	fffff097          	auipc	ra,0xfffff
    800048d0:	ad6080e7          	jalr	-1322(ra) # 800033a2 <namei>
    800048d4:	84aa                	mv	s1,a0
    800048d6:	c551                	beqz	a0,80004962 <sys_link+0xde>
    ilock(ip);
    800048d8:	ffffe097          	auipc	ra,0xffffe
    800048dc:	31e080e7          	jalr	798(ra) # 80002bf6 <ilock>
    if (ip->type == T_DIR) {
    800048e0:	04449703          	lh	a4,68(s1)
    800048e4:	4785                	li	a5,1
    800048e6:	08f70463          	beq	a4,a5,8000496e <sys_link+0xea>
    ip->nlink++;
    800048ea:	04a4d783          	lhu	a5,74(s1)
    800048ee:	2785                	addiw	a5,a5,1
    800048f0:	04f49523          	sh	a5,74(s1)
    iupdate(ip);
    800048f4:	8526                	mv	a0,s1
    800048f6:	ffffe097          	auipc	ra,0xffffe
    800048fa:	234080e7          	jalr	564(ra) # 80002b2a <iupdate>
    iunlock(ip);
    800048fe:	8526                	mv	a0,s1
    80004900:	ffffe097          	auipc	ra,0xffffe
    80004904:	3b8080e7          	jalr	952(ra) # 80002cb8 <iunlock>
    if ((dp = nameiparent(new, name)) == 0)
    80004908:	fd040593          	addi	a1,s0,-48
    8000490c:	f5040513          	addi	a0,s0,-176
    80004910:	fffff097          	auipc	ra,0xfffff
    80004914:	ab0080e7          	jalr	-1360(ra) # 800033c0 <nameiparent>
    80004918:	892a                	mv	s2,a0
    8000491a:	c935                	beqz	a0,8000498e <sys_link+0x10a>
    ilock(dp);
    8000491c:	ffffe097          	auipc	ra,0xffffe
    80004920:	2da080e7          	jalr	730(ra) # 80002bf6 <ilock>
    if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    80004924:	00092703          	lw	a4,0(s2)
    80004928:	409c                	lw	a5,0(s1)
    8000492a:	04f71d63          	bne	a4,a5,80004984 <sys_link+0x100>
    8000492e:	40d0                	lw	a2,4(s1)
    80004930:	fd040593          	addi	a1,s0,-48
    80004934:	854a                	mv	a0,s2
    80004936:	fffff097          	auipc	ra,0xfffff
    8000493a:	9ba080e7          	jalr	-1606(ra) # 800032f0 <dirlink>
    8000493e:	04054363          	bltz	a0,80004984 <sys_link+0x100>
    iunlockput(dp);
    80004942:	854a                	mv	a0,s2
    80004944:	ffffe097          	auipc	ra,0xffffe
    80004948:	514080e7          	jalr	1300(ra) # 80002e58 <iunlockput>
    iput(ip);
    8000494c:	8526                	mv	a0,s1
    8000494e:	ffffe097          	auipc	ra,0xffffe
    80004952:	462080e7          	jalr	1122(ra) # 80002db0 <iput>
    end_op();
    80004956:	fffff097          	auipc	ra,0xfffff
    8000495a:	cea080e7          	jalr	-790(ra) # 80003640 <end_op>
    return 0;
    8000495e:	4781                	li	a5,0
    80004960:	a085                	j	800049c0 <sys_link+0x13c>
        end_op();
    80004962:	fffff097          	auipc	ra,0xfffff
    80004966:	cde080e7          	jalr	-802(ra) # 80003640 <end_op>
        return -1;
    8000496a:	57fd                	li	a5,-1
    8000496c:	a891                	j	800049c0 <sys_link+0x13c>
        iunlockput(ip);
    8000496e:	8526                	mv	a0,s1
    80004970:	ffffe097          	auipc	ra,0xffffe
    80004974:	4e8080e7          	jalr	1256(ra) # 80002e58 <iunlockput>
        end_op();
    80004978:	fffff097          	auipc	ra,0xfffff
    8000497c:	cc8080e7          	jalr	-824(ra) # 80003640 <end_op>
        return -1;
    80004980:	57fd                	li	a5,-1
    80004982:	a83d                	j	800049c0 <sys_link+0x13c>
        iunlockput(dp);
    80004984:	854a                	mv	a0,s2
    80004986:	ffffe097          	auipc	ra,0xffffe
    8000498a:	4d2080e7          	jalr	1234(ra) # 80002e58 <iunlockput>
    ilock(ip);
    8000498e:	8526                	mv	a0,s1
    80004990:	ffffe097          	auipc	ra,0xffffe
    80004994:	266080e7          	jalr	614(ra) # 80002bf6 <ilock>
    ip->nlink--;
    80004998:	04a4d783          	lhu	a5,74(s1)
    8000499c:	37fd                	addiw	a5,a5,-1
    8000499e:	04f49523          	sh	a5,74(s1)
    iupdate(ip);
    800049a2:	8526                	mv	a0,s1
    800049a4:	ffffe097          	auipc	ra,0xffffe
    800049a8:	186080e7          	jalr	390(ra) # 80002b2a <iupdate>
    iunlockput(ip);
    800049ac:	8526                	mv	a0,s1
    800049ae:	ffffe097          	auipc	ra,0xffffe
    800049b2:	4aa080e7          	jalr	1194(ra) # 80002e58 <iunlockput>
    end_op();
    800049b6:	fffff097          	auipc	ra,0xfffff
    800049ba:	c8a080e7          	jalr	-886(ra) # 80003640 <end_op>
    return -1;
    800049be:	57fd                	li	a5,-1
}
    800049c0:	853e                	mv	a0,a5
    800049c2:	70b2                	ld	ra,296(sp)
    800049c4:	7412                	ld	s0,288(sp)
    800049c6:	64f2                	ld	s1,280(sp)
    800049c8:	6952                	ld	s2,272(sp)
    800049ca:	6155                	addi	sp,sp,304
    800049cc:	8082                	ret

00000000800049ce <sys_unlink>:
{
    800049ce:	7151                	addi	sp,sp,-240
    800049d0:	f586                	sd	ra,232(sp)
    800049d2:	f1a2                	sd	s0,224(sp)
    800049d4:	eda6                	sd	s1,216(sp)
    800049d6:	e9ca                	sd	s2,208(sp)
    800049d8:	e5ce                	sd	s3,200(sp)
    800049da:	1980                	addi	s0,sp,240
    if (argstr(0, path, MAXPATH) < 0)
    800049dc:	08000613          	li	a2,128
    800049e0:	f3040593          	addi	a1,s0,-208
    800049e4:	4501                	li	a0,0
    800049e6:	ffffd097          	auipc	ra,0xffffd
    800049ea:	61e080e7          	jalr	1566(ra) # 80002004 <argstr>
    800049ee:	18054163          	bltz	a0,80004b70 <sys_unlink+0x1a2>
    begin_op();
    800049f2:	fffff097          	auipc	ra,0xfffff
    800049f6:	bd0080e7          	jalr	-1072(ra) # 800035c2 <begin_op>
    if ((dp = nameiparent(path, name)) == 0) {
    800049fa:	fb040593          	addi	a1,s0,-80
    800049fe:	f3040513          	addi	a0,s0,-208
    80004a02:	fffff097          	auipc	ra,0xfffff
    80004a06:	9be080e7          	jalr	-1602(ra) # 800033c0 <nameiparent>
    80004a0a:	84aa                	mv	s1,a0
    80004a0c:	c979                	beqz	a0,80004ae2 <sys_unlink+0x114>
    ilock(dp);
    80004a0e:	ffffe097          	auipc	ra,0xffffe
    80004a12:	1e8080e7          	jalr	488(ra) # 80002bf6 <ilock>
    if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a16:	00004597          	auipc	a1,0x4
    80004a1a:	d2a58593          	addi	a1,a1,-726 # 80008740 <syscalls+0x2a8>
    80004a1e:	fb040513          	addi	a0,s0,-80
    80004a22:	ffffe097          	auipc	ra,0xffffe
    80004a26:	69e080e7          	jalr	1694(ra) # 800030c0 <namecmp>
    80004a2a:	14050a63          	beqz	a0,80004b7e <sys_unlink+0x1b0>
    80004a2e:	00004597          	auipc	a1,0x4
    80004a32:	d1a58593          	addi	a1,a1,-742 # 80008748 <syscalls+0x2b0>
    80004a36:	fb040513          	addi	a0,s0,-80
    80004a3a:	ffffe097          	auipc	ra,0xffffe
    80004a3e:	686080e7          	jalr	1670(ra) # 800030c0 <namecmp>
    80004a42:	12050e63          	beqz	a0,80004b7e <sys_unlink+0x1b0>
    if ((ip = dirlookup(dp, name, &off)) == 0)
    80004a46:	f2c40613          	addi	a2,s0,-212
    80004a4a:	fb040593          	addi	a1,s0,-80
    80004a4e:	8526                	mv	a0,s1
    80004a50:	ffffe097          	auipc	ra,0xffffe
    80004a54:	68a080e7          	jalr	1674(ra) # 800030da <dirlookup>
    80004a58:	892a                	mv	s2,a0
    80004a5a:	12050263          	beqz	a0,80004b7e <sys_unlink+0x1b0>
    ilock(ip);
    80004a5e:	ffffe097          	auipc	ra,0xffffe
    80004a62:	198080e7          	jalr	408(ra) # 80002bf6 <ilock>
    if (ip->nlink < 1)
    80004a66:	04a91783          	lh	a5,74(s2)
    80004a6a:	08f05263          	blez	a5,80004aee <sys_unlink+0x120>
    if (ip->type == T_DIR && !isdirempty(ip)) {
    80004a6e:	04491703          	lh	a4,68(s2)
    80004a72:	4785                	li	a5,1
    80004a74:	08f70563          	beq	a4,a5,80004afe <sys_unlink+0x130>
    memset(&de, 0, sizeof(de));
    80004a78:	4641                	li	a2,16
    80004a7a:	4581                	li	a1,0
    80004a7c:	fc040513          	addi	a0,s0,-64
    80004a80:	ffffb097          	auipc	ra,0xffffb
    80004a84:	71e080e7          	jalr	1822(ra) # 8000019e <memset>
    if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a88:	4741                	li	a4,16
    80004a8a:	f2c42683          	lw	a3,-212(s0)
    80004a8e:	fc040613          	addi	a2,s0,-64
    80004a92:	4581                	li	a1,0
    80004a94:	8526                	mv	a0,s1
    80004a96:	ffffe097          	auipc	ra,0xffffe
    80004a9a:	50c080e7          	jalr	1292(ra) # 80002fa2 <writei>
    80004a9e:	47c1                	li	a5,16
    80004aa0:	0af51563          	bne	a0,a5,80004b4a <sys_unlink+0x17c>
    if (ip->type == T_DIR) {
    80004aa4:	04491703          	lh	a4,68(s2)
    80004aa8:	4785                	li	a5,1
    80004aaa:	0af70863          	beq	a4,a5,80004b5a <sys_unlink+0x18c>
    iunlockput(dp);
    80004aae:	8526                	mv	a0,s1
    80004ab0:	ffffe097          	auipc	ra,0xffffe
    80004ab4:	3a8080e7          	jalr	936(ra) # 80002e58 <iunlockput>
    ip->nlink--;
    80004ab8:	04a95783          	lhu	a5,74(s2)
    80004abc:	37fd                	addiw	a5,a5,-1
    80004abe:	04f91523          	sh	a5,74(s2)
    iupdate(ip);
    80004ac2:	854a                	mv	a0,s2
    80004ac4:	ffffe097          	auipc	ra,0xffffe
    80004ac8:	066080e7          	jalr	102(ra) # 80002b2a <iupdate>
    iunlockput(ip);
    80004acc:	854a                	mv	a0,s2
    80004ace:	ffffe097          	auipc	ra,0xffffe
    80004ad2:	38a080e7          	jalr	906(ra) # 80002e58 <iunlockput>
    end_op();
    80004ad6:	fffff097          	auipc	ra,0xfffff
    80004ada:	b6a080e7          	jalr	-1174(ra) # 80003640 <end_op>
    return 0;
    80004ade:	4501                	li	a0,0
    80004ae0:	a84d                	j	80004b92 <sys_unlink+0x1c4>
        end_op();
    80004ae2:	fffff097          	auipc	ra,0xfffff
    80004ae6:	b5e080e7          	jalr	-1186(ra) # 80003640 <end_op>
        return -1;
    80004aea:	557d                	li	a0,-1
    80004aec:	a05d                	j	80004b92 <sys_unlink+0x1c4>
        panic("unlink: nlink < 1");
    80004aee:	00004517          	auipc	a0,0x4
    80004af2:	c6250513          	addi	a0,a0,-926 # 80008750 <syscalls+0x2b8>
    80004af6:	00001097          	auipc	ra,0x1
    80004afa:	1b6080e7          	jalr	438(ra) # 80005cac <panic>
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004afe:	04c92703          	lw	a4,76(s2)
    80004b02:	02000793          	li	a5,32
    80004b06:	f6e7f9e3          	bgeu	a5,a4,80004a78 <sys_unlink+0xaa>
    80004b0a:	02000993          	li	s3,32
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b0e:	4741                	li	a4,16
    80004b10:	86ce                	mv	a3,s3
    80004b12:	f1840613          	addi	a2,s0,-232
    80004b16:	4581                	li	a1,0
    80004b18:	854a                	mv	a0,s2
    80004b1a:	ffffe097          	auipc	ra,0xffffe
    80004b1e:	390080e7          	jalr	912(ra) # 80002eaa <readi>
    80004b22:	47c1                	li	a5,16
    80004b24:	00f51b63          	bne	a0,a5,80004b3a <sys_unlink+0x16c>
        if (de.inum != 0)
    80004b28:	f1845783          	lhu	a5,-232(s0)
    80004b2c:	e7a1                	bnez	a5,80004b74 <sys_unlink+0x1a6>
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004b2e:	29c1                	addiw	s3,s3,16
    80004b30:	04c92783          	lw	a5,76(s2)
    80004b34:	fcf9ede3          	bltu	s3,a5,80004b0e <sys_unlink+0x140>
    80004b38:	b781                	j	80004a78 <sys_unlink+0xaa>
            panic("isdirempty: readi");
    80004b3a:	00004517          	auipc	a0,0x4
    80004b3e:	c2e50513          	addi	a0,a0,-978 # 80008768 <syscalls+0x2d0>
    80004b42:	00001097          	auipc	ra,0x1
    80004b46:	16a080e7          	jalr	362(ra) # 80005cac <panic>
        panic("unlink: writei");
    80004b4a:	00004517          	auipc	a0,0x4
    80004b4e:	c3650513          	addi	a0,a0,-970 # 80008780 <syscalls+0x2e8>
    80004b52:	00001097          	auipc	ra,0x1
    80004b56:	15a080e7          	jalr	346(ra) # 80005cac <panic>
        dp->nlink--;
    80004b5a:	04a4d783          	lhu	a5,74(s1)
    80004b5e:	37fd                	addiw	a5,a5,-1
    80004b60:	04f49523          	sh	a5,74(s1)
        iupdate(dp);
    80004b64:	8526                	mv	a0,s1
    80004b66:	ffffe097          	auipc	ra,0xffffe
    80004b6a:	fc4080e7          	jalr	-60(ra) # 80002b2a <iupdate>
    80004b6e:	b781                	j	80004aae <sys_unlink+0xe0>
        return -1;
    80004b70:	557d                	li	a0,-1
    80004b72:	a005                	j	80004b92 <sys_unlink+0x1c4>
        iunlockput(ip);
    80004b74:	854a                	mv	a0,s2
    80004b76:	ffffe097          	auipc	ra,0xffffe
    80004b7a:	2e2080e7          	jalr	738(ra) # 80002e58 <iunlockput>
    iunlockput(dp);
    80004b7e:	8526                	mv	a0,s1
    80004b80:	ffffe097          	auipc	ra,0xffffe
    80004b84:	2d8080e7          	jalr	728(ra) # 80002e58 <iunlockput>
    end_op();
    80004b88:	fffff097          	auipc	ra,0xfffff
    80004b8c:	ab8080e7          	jalr	-1352(ra) # 80003640 <end_op>
    return -1;
    80004b90:	557d                	li	a0,-1
}
    80004b92:	70ae                	ld	ra,232(sp)
    80004b94:	740e                	ld	s0,224(sp)
    80004b96:	64ee                	ld	s1,216(sp)
    80004b98:	694e                	ld	s2,208(sp)
    80004b9a:	69ae                	ld	s3,200(sp)
    80004b9c:	616d                	addi	sp,sp,240
    80004b9e:	8082                	ret

0000000080004ba0 <sys_open>:

uint64 sys_open(void)
{
    80004ba0:	7131                	addi	sp,sp,-192
    80004ba2:	fd06                	sd	ra,184(sp)
    80004ba4:	f922                	sd	s0,176(sp)
    80004ba6:	f526                	sd	s1,168(sp)
    80004ba8:	f14a                	sd	s2,160(sp)
    80004baa:	ed4e                	sd	s3,152(sp)
    80004bac:	0180                	addi	s0,sp,192
    int fd, omode;
    struct file *f;
    struct inode *ip;
    int n;

    argint(1, &omode);
    80004bae:	f4c40593          	addi	a1,s0,-180
    80004bb2:	4505                	li	a0,1
    80004bb4:	ffffd097          	auipc	ra,0xffffd
    80004bb8:	410080e7          	jalr	1040(ra) # 80001fc4 <argint>
    if ((n = argstr(0, path, MAXPATH)) < 0)
    80004bbc:	08000613          	li	a2,128
    80004bc0:	f5040593          	addi	a1,s0,-176
    80004bc4:	4501                	li	a0,0
    80004bc6:	ffffd097          	auipc	ra,0xffffd
    80004bca:	43e080e7          	jalr	1086(ra) # 80002004 <argstr>
    80004bce:	87aa                	mv	a5,a0
        return -1;
    80004bd0:	557d                	li	a0,-1
    if ((n = argstr(0, path, MAXPATH)) < 0)
    80004bd2:	0a07c963          	bltz	a5,80004c84 <sys_open+0xe4>

    begin_op();
    80004bd6:	fffff097          	auipc	ra,0xfffff
    80004bda:	9ec080e7          	jalr	-1556(ra) # 800035c2 <begin_op>

    if (omode & O_CREATE) {
    80004bde:	f4c42783          	lw	a5,-180(s0)
    80004be2:	2007f793          	andi	a5,a5,512
    80004be6:	cfc5                	beqz	a5,80004c9e <sys_open+0xfe>
        ip = create(path, T_FILE, 0, 0);
    80004be8:	4681                	li	a3,0
    80004bea:	4601                	li	a2,0
    80004bec:	4589                	li	a1,2
    80004bee:	f5040513          	addi	a0,s0,-176
    80004bf2:	00000097          	auipc	ra,0x0
    80004bf6:	972080e7          	jalr	-1678(ra) # 80004564 <create>
    80004bfa:	84aa                	mv	s1,a0
        if (ip == 0) {
    80004bfc:	c959                	beqz	a0,80004c92 <sys_open+0xf2>
            end_op();
            return -1;
        }
    }

    if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    80004bfe:	04449703          	lh	a4,68(s1)
    80004c02:	478d                	li	a5,3
    80004c04:	00f71763          	bne	a4,a5,80004c12 <sys_open+0x72>
    80004c08:	0464d703          	lhu	a4,70(s1)
    80004c0c:	47a5                	li	a5,9
    80004c0e:	0ce7ed63          	bltu	a5,a4,80004ce8 <sys_open+0x148>
        iunlockput(ip);
        end_op();
        return -1;
    }

    if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80004c12:	fffff097          	auipc	ra,0xfffff
    80004c16:	dbc080e7          	jalr	-580(ra) # 800039ce <filealloc>
    80004c1a:	89aa                	mv	s3,a0
    80004c1c:	10050363          	beqz	a0,80004d22 <sys_open+0x182>
    80004c20:	00000097          	auipc	ra,0x0
    80004c24:	902080e7          	jalr	-1790(ra) # 80004522 <fdalloc>
    80004c28:	892a                	mv	s2,a0
    80004c2a:	0e054763          	bltz	a0,80004d18 <sys_open+0x178>
        iunlockput(ip);
        end_op();
        return -1;
    }

    if (ip->type == T_DEVICE) {
    80004c2e:	04449703          	lh	a4,68(s1)
    80004c32:	478d                	li	a5,3
    80004c34:	0cf70563          	beq	a4,a5,80004cfe <sys_open+0x15e>
        f->type = FD_DEVICE;
        f->major = ip->major;
    }
    else {
        f->type = FD_INODE;
    80004c38:	4789                	li	a5,2
    80004c3a:	00f9a023          	sw	a5,0(s3)
        f->off = 0;
    80004c3e:	0209a023          	sw	zero,32(s3)
    }
    f->ip = ip;
    80004c42:	0099bc23          	sd	s1,24(s3)
    f->readable = !(omode & O_WRONLY);
    80004c46:	f4c42783          	lw	a5,-180(s0)
    80004c4a:	0017c713          	xori	a4,a5,1
    80004c4e:	8b05                	andi	a4,a4,1
    80004c50:	00e98423          	sb	a4,8(s3)
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c54:	0037f713          	andi	a4,a5,3
    80004c58:	00e03733          	snez	a4,a4
    80004c5c:	00e984a3          	sb	a4,9(s3)

    if ((omode & O_TRUNC) && ip->type == T_FILE) {
    80004c60:	4007f793          	andi	a5,a5,1024
    80004c64:	c791                	beqz	a5,80004c70 <sys_open+0xd0>
    80004c66:	04449703          	lh	a4,68(s1)
    80004c6a:	4789                	li	a5,2
    80004c6c:	0af70063          	beq	a4,a5,80004d0c <sys_open+0x16c>
        itrunc(ip);
    }

    iunlock(ip);
    80004c70:	8526                	mv	a0,s1
    80004c72:	ffffe097          	auipc	ra,0xffffe
    80004c76:	046080e7          	jalr	70(ra) # 80002cb8 <iunlock>
    end_op();
    80004c7a:	fffff097          	auipc	ra,0xfffff
    80004c7e:	9c6080e7          	jalr	-1594(ra) # 80003640 <end_op>

    return fd;
    80004c82:	854a                	mv	a0,s2
}
    80004c84:	70ea                	ld	ra,184(sp)
    80004c86:	744a                	ld	s0,176(sp)
    80004c88:	74aa                	ld	s1,168(sp)
    80004c8a:	790a                	ld	s2,160(sp)
    80004c8c:	69ea                	ld	s3,152(sp)
    80004c8e:	6129                	addi	sp,sp,192
    80004c90:	8082                	ret
            end_op();
    80004c92:	fffff097          	auipc	ra,0xfffff
    80004c96:	9ae080e7          	jalr	-1618(ra) # 80003640 <end_op>
            return -1;
    80004c9a:	557d                	li	a0,-1
    80004c9c:	b7e5                	j	80004c84 <sys_open+0xe4>
        if ((ip = namei(path)) == 0) {
    80004c9e:	f5040513          	addi	a0,s0,-176
    80004ca2:	ffffe097          	auipc	ra,0xffffe
    80004ca6:	700080e7          	jalr	1792(ra) # 800033a2 <namei>
    80004caa:	84aa                	mv	s1,a0
    80004cac:	c905                	beqz	a0,80004cdc <sys_open+0x13c>
        ilock(ip);
    80004cae:	ffffe097          	auipc	ra,0xffffe
    80004cb2:	f48080e7          	jalr	-184(ra) # 80002bf6 <ilock>
        if (ip->type == T_DIR && omode != O_RDONLY) {
    80004cb6:	04449703          	lh	a4,68(s1)
    80004cba:	4785                	li	a5,1
    80004cbc:	f4f711e3          	bne	a4,a5,80004bfe <sys_open+0x5e>
    80004cc0:	f4c42783          	lw	a5,-180(s0)
    80004cc4:	d7b9                	beqz	a5,80004c12 <sys_open+0x72>
            iunlockput(ip);
    80004cc6:	8526                	mv	a0,s1
    80004cc8:	ffffe097          	auipc	ra,0xffffe
    80004ccc:	190080e7          	jalr	400(ra) # 80002e58 <iunlockput>
            end_op();
    80004cd0:	fffff097          	auipc	ra,0xfffff
    80004cd4:	970080e7          	jalr	-1680(ra) # 80003640 <end_op>
            return -1;
    80004cd8:	557d                	li	a0,-1
    80004cda:	b76d                	j	80004c84 <sys_open+0xe4>
            end_op();
    80004cdc:	fffff097          	auipc	ra,0xfffff
    80004ce0:	964080e7          	jalr	-1692(ra) # 80003640 <end_op>
            return -1;
    80004ce4:	557d                	li	a0,-1
    80004ce6:	bf79                	j	80004c84 <sys_open+0xe4>
        iunlockput(ip);
    80004ce8:	8526                	mv	a0,s1
    80004cea:	ffffe097          	auipc	ra,0xffffe
    80004cee:	16e080e7          	jalr	366(ra) # 80002e58 <iunlockput>
        end_op();
    80004cf2:	fffff097          	auipc	ra,0xfffff
    80004cf6:	94e080e7          	jalr	-1714(ra) # 80003640 <end_op>
        return -1;
    80004cfa:	557d                	li	a0,-1
    80004cfc:	b761                	j	80004c84 <sys_open+0xe4>
        f->type = FD_DEVICE;
    80004cfe:	00f9a023          	sw	a5,0(s3)
        f->major = ip->major;
    80004d02:	04649783          	lh	a5,70(s1)
    80004d06:	02f99223          	sh	a5,36(s3)
    80004d0a:	bf25                	j	80004c42 <sys_open+0xa2>
        itrunc(ip);
    80004d0c:	8526                	mv	a0,s1
    80004d0e:	ffffe097          	auipc	ra,0xffffe
    80004d12:	ff6080e7          	jalr	-10(ra) # 80002d04 <itrunc>
    80004d16:	bfa9                	j	80004c70 <sys_open+0xd0>
            fileclose(f);
    80004d18:	854e                	mv	a0,s3
    80004d1a:	fffff097          	auipc	ra,0xfffff
    80004d1e:	d70080e7          	jalr	-656(ra) # 80003a8a <fileclose>
        iunlockput(ip);
    80004d22:	8526                	mv	a0,s1
    80004d24:	ffffe097          	auipc	ra,0xffffe
    80004d28:	134080e7          	jalr	308(ra) # 80002e58 <iunlockput>
        end_op();
    80004d2c:	fffff097          	auipc	ra,0xfffff
    80004d30:	914080e7          	jalr	-1772(ra) # 80003640 <end_op>
        return -1;
    80004d34:	557d                	li	a0,-1
    80004d36:	b7b9                	j	80004c84 <sys_open+0xe4>

0000000080004d38 <sys_mkdir>:

uint64 sys_mkdir(void)
{
    80004d38:	7175                	addi	sp,sp,-144
    80004d3a:	e506                	sd	ra,136(sp)
    80004d3c:	e122                	sd	s0,128(sp)
    80004d3e:	0900                	addi	s0,sp,144
    char path[MAXPATH];
    struct inode *ip;

    begin_op();
    80004d40:	fffff097          	auipc	ra,0xfffff
    80004d44:	882080e7          	jalr	-1918(ra) # 800035c2 <begin_op>
    if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    80004d48:	08000613          	li	a2,128
    80004d4c:	f7040593          	addi	a1,s0,-144
    80004d50:	4501                	li	a0,0
    80004d52:	ffffd097          	auipc	ra,0xffffd
    80004d56:	2b2080e7          	jalr	690(ra) # 80002004 <argstr>
    80004d5a:	02054963          	bltz	a0,80004d8c <sys_mkdir+0x54>
    80004d5e:	4681                	li	a3,0
    80004d60:	4601                	li	a2,0
    80004d62:	4585                	li	a1,1
    80004d64:	f7040513          	addi	a0,s0,-144
    80004d68:	fffff097          	auipc	ra,0xfffff
    80004d6c:	7fc080e7          	jalr	2044(ra) # 80004564 <create>
    80004d70:	cd11                	beqz	a0,80004d8c <sys_mkdir+0x54>
        end_op();
        return -1;
    }
    iunlockput(ip);
    80004d72:	ffffe097          	auipc	ra,0xffffe
    80004d76:	0e6080e7          	jalr	230(ra) # 80002e58 <iunlockput>
    end_op();
    80004d7a:	fffff097          	auipc	ra,0xfffff
    80004d7e:	8c6080e7          	jalr	-1850(ra) # 80003640 <end_op>
    return 0;
    80004d82:	4501                	li	a0,0
}
    80004d84:	60aa                	ld	ra,136(sp)
    80004d86:	640a                	ld	s0,128(sp)
    80004d88:	6149                	addi	sp,sp,144
    80004d8a:	8082                	ret
        end_op();
    80004d8c:	fffff097          	auipc	ra,0xfffff
    80004d90:	8b4080e7          	jalr	-1868(ra) # 80003640 <end_op>
        return -1;
    80004d94:	557d                	li	a0,-1
    80004d96:	b7fd                	j	80004d84 <sys_mkdir+0x4c>

0000000080004d98 <sys_mknod>:

uint64 sys_mknod(void)
{
    80004d98:	7135                	addi	sp,sp,-160
    80004d9a:	ed06                	sd	ra,152(sp)
    80004d9c:	e922                	sd	s0,144(sp)
    80004d9e:	1100                	addi	s0,sp,160
    struct inode *ip;
    char path[MAXPATH];
    int major, minor;

    begin_op();
    80004da0:	fffff097          	auipc	ra,0xfffff
    80004da4:	822080e7          	jalr	-2014(ra) # 800035c2 <begin_op>
    argint(1, &major);
    80004da8:	f6c40593          	addi	a1,s0,-148
    80004dac:	4505                	li	a0,1
    80004dae:	ffffd097          	auipc	ra,0xffffd
    80004db2:	216080e7          	jalr	534(ra) # 80001fc4 <argint>
    argint(2, &minor);
    80004db6:	f6840593          	addi	a1,s0,-152
    80004dba:	4509                	li	a0,2
    80004dbc:	ffffd097          	auipc	ra,0xffffd
    80004dc0:	208080e7          	jalr	520(ra) # 80001fc4 <argint>
    if ((argstr(0, path, MAXPATH)) < 0 || (ip = create(path, T_DEVICE, major, minor)) == 0) {
    80004dc4:	08000613          	li	a2,128
    80004dc8:	f7040593          	addi	a1,s0,-144
    80004dcc:	4501                	li	a0,0
    80004dce:	ffffd097          	auipc	ra,0xffffd
    80004dd2:	236080e7          	jalr	566(ra) # 80002004 <argstr>
    80004dd6:	02054b63          	bltz	a0,80004e0c <sys_mknod+0x74>
    80004dda:	f6841683          	lh	a3,-152(s0)
    80004dde:	f6c41603          	lh	a2,-148(s0)
    80004de2:	458d                	li	a1,3
    80004de4:	f7040513          	addi	a0,s0,-144
    80004de8:	fffff097          	auipc	ra,0xfffff
    80004dec:	77c080e7          	jalr	1916(ra) # 80004564 <create>
    80004df0:	cd11                	beqz	a0,80004e0c <sys_mknod+0x74>
        end_op();
        return -1;
    }
    iunlockput(ip);
    80004df2:	ffffe097          	auipc	ra,0xffffe
    80004df6:	066080e7          	jalr	102(ra) # 80002e58 <iunlockput>
    end_op();
    80004dfa:	fffff097          	auipc	ra,0xfffff
    80004dfe:	846080e7          	jalr	-1978(ra) # 80003640 <end_op>
    return 0;
    80004e02:	4501                	li	a0,0
}
    80004e04:	60ea                	ld	ra,152(sp)
    80004e06:	644a                	ld	s0,144(sp)
    80004e08:	610d                	addi	sp,sp,160
    80004e0a:	8082                	ret
        end_op();
    80004e0c:	fffff097          	auipc	ra,0xfffff
    80004e10:	834080e7          	jalr	-1996(ra) # 80003640 <end_op>
        return -1;
    80004e14:	557d                	li	a0,-1
    80004e16:	b7fd                	j	80004e04 <sys_mknod+0x6c>

0000000080004e18 <sys_chdir>:

uint64 sys_chdir(void)
{
    80004e18:	7135                	addi	sp,sp,-160
    80004e1a:	ed06                	sd	ra,152(sp)
    80004e1c:	e922                	sd	s0,144(sp)
    80004e1e:	e526                	sd	s1,136(sp)
    80004e20:	e14a                	sd	s2,128(sp)
    80004e22:	1100                	addi	s0,sp,160
    char path[MAXPATH];
    struct inode *ip;
    struct proc *p = myproc();
    80004e24:	ffffc097          	auipc	ra,0xffffc
    80004e28:	054080e7          	jalr	84(ra) # 80000e78 <myproc>
    80004e2c:	892a                	mv	s2,a0

    begin_op();
    80004e2e:	ffffe097          	auipc	ra,0xffffe
    80004e32:	794080e7          	jalr	1940(ra) # 800035c2 <begin_op>
    if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    80004e36:	08000613          	li	a2,128
    80004e3a:	f6040593          	addi	a1,s0,-160
    80004e3e:	4501                	li	a0,0
    80004e40:	ffffd097          	auipc	ra,0xffffd
    80004e44:	1c4080e7          	jalr	452(ra) # 80002004 <argstr>
    80004e48:	04054b63          	bltz	a0,80004e9e <sys_chdir+0x86>
    80004e4c:	f6040513          	addi	a0,s0,-160
    80004e50:	ffffe097          	auipc	ra,0xffffe
    80004e54:	552080e7          	jalr	1362(ra) # 800033a2 <namei>
    80004e58:	84aa                	mv	s1,a0
    80004e5a:	c131                	beqz	a0,80004e9e <sys_chdir+0x86>
        end_op();
        return -1;
    }
    ilock(ip);
    80004e5c:	ffffe097          	auipc	ra,0xffffe
    80004e60:	d9a080e7          	jalr	-614(ra) # 80002bf6 <ilock>
    if (ip->type != T_DIR) {
    80004e64:	04449703          	lh	a4,68(s1)
    80004e68:	4785                	li	a5,1
    80004e6a:	04f71063          	bne	a4,a5,80004eaa <sys_chdir+0x92>
        iunlockput(ip);
        end_op();
        return -1;
    }
    iunlock(ip);
    80004e6e:	8526                	mv	a0,s1
    80004e70:	ffffe097          	auipc	ra,0xffffe
    80004e74:	e48080e7          	jalr	-440(ra) # 80002cb8 <iunlock>
    iput(p->cwd);
    80004e78:	15093503          	ld	a0,336(s2)
    80004e7c:	ffffe097          	auipc	ra,0xffffe
    80004e80:	f34080e7          	jalr	-204(ra) # 80002db0 <iput>
    end_op();
    80004e84:	ffffe097          	auipc	ra,0xffffe
    80004e88:	7bc080e7          	jalr	1980(ra) # 80003640 <end_op>
    p->cwd = ip;
    80004e8c:	14993823          	sd	s1,336(s2)
    return 0;
    80004e90:	4501                	li	a0,0
}
    80004e92:	60ea                	ld	ra,152(sp)
    80004e94:	644a                	ld	s0,144(sp)
    80004e96:	64aa                	ld	s1,136(sp)
    80004e98:	690a                	ld	s2,128(sp)
    80004e9a:	610d                	addi	sp,sp,160
    80004e9c:	8082                	ret
        end_op();
    80004e9e:	ffffe097          	auipc	ra,0xffffe
    80004ea2:	7a2080e7          	jalr	1954(ra) # 80003640 <end_op>
        return -1;
    80004ea6:	557d                	li	a0,-1
    80004ea8:	b7ed                	j	80004e92 <sys_chdir+0x7a>
        iunlockput(ip);
    80004eaa:	8526                	mv	a0,s1
    80004eac:	ffffe097          	auipc	ra,0xffffe
    80004eb0:	fac080e7          	jalr	-84(ra) # 80002e58 <iunlockput>
        end_op();
    80004eb4:	ffffe097          	auipc	ra,0xffffe
    80004eb8:	78c080e7          	jalr	1932(ra) # 80003640 <end_op>
        return -1;
    80004ebc:	557d                	li	a0,-1
    80004ebe:	bfd1                	j	80004e92 <sys_chdir+0x7a>

0000000080004ec0 <sys_exec>:

uint64 sys_exec(void)
{
    80004ec0:	7145                	addi	sp,sp,-464
    80004ec2:	e786                	sd	ra,456(sp)
    80004ec4:	e3a2                	sd	s0,448(sp)
    80004ec6:	ff26                	sd	s1,440(sp)
    80004ec8:	fb4a                	sd	s2,432(sp)
    80004eca:	f74e                	sd	s3,424(sp)
    80004ecc:	f352                	sd	s4,416(sp)
    80004ece:	ef56                	sd	s5,408(sp)
    80004ed0:	0b80                	addi	s0,sp,464
    char path[MAXPATH], *argv[MAXARG];
    int i;
    uint64 uargv, uarg;

    argaddr(1, &uargv);
    80004ed2:	e3840593          	addi	a1,s0,-456
    80004ed6:	4505                	li	a0,1
    80004ed8:	ffffd097          	auipc	ra,0xffffd
    80004edc:	10c080e7          	jalr	268(ra) # 80001fe4 <argaddr>
    if (argstr(0, path, MAXPATH) < 0) {
    80004ee0:	08000613          	li	a2,128
    80004ee4:	f4040593          	addi	a1,s0,-192
    80004ee8:	4501                	li	a0,0
    80004eea:	ffffd097          	auipc	ra,0xffffd
    80004eee:	11a080e7          	jalr	282(ra) # 80002004 <argstr>
    80004ef2:	87aa                	mv	a5,a0
        return -1;
    80004ef4:	557d                	li	a0,-1
    if (argstr(0, path, MAXPATH) < 0) {
    80004ef6:	0c07c363          	bltz	a5,80004fbc <sys_exec+0xfc>
    }
    memset(argv, 0, sizeof(argv));
    80004efa:	10000613          	li	a2,256
    80004efe:	4581                	li	a1,0
    80004f00:	e4040513          	addi	a0,s0,-448
    80004f04:	ffffb097          	auipc	ra,0xffffb
    80004f08:	29a080e7          	jalr	666(ra) # 8000019e <memset>
    for (i = 0;; i++) {
        if (i >= NELEM(argv)) {
    80004f0c:	e4040493          	addi	s1,s0,-448
    memset(argv, 0, sizeof(argv));
    80004f10:	89a6                	mv	s3,s1
    80004f12:	4901                	li	s2,0
        if (i >= NELEM(argv)) {
    80004f14:	02000a13          	li	s4,32
    80004f18:	00090a9b          	sext.w	s5,s2
            goto bad;
        }
        if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    80004f1c:	00391513          	slli	a0,s2,0x3
    80004f20:	e3040593          	addi	a1,s0,-464
    80004f24:	e3843783          	ld	a5,-456(s0)
    80004f28:	953e                	add	a0,a0,a5
    80004f2a:	ffffd097          	auipc	ra,0xffffd
    80004f2e:	ffc080e7          	jalr	-4(ra) # 80001f26 <fetchaddr>
    80004f32:	02054a63          	bltz	a0,80004f66 <sys_exec+0xa6>
            goto bad;
        }
        if (uarg == 0) {
    80004f36:	e3043783          	ld	a5,-464(s0)
    80004f3a:	c3b9                	beqz	a5,80004f80 <sys_exec+0xc0>
            argv[i] = 0;
            break;
        }
        argv[i] = kalloc();
    80004f3c:	ffffb097          	auipc	ra,0xffffb
    80004f40:	1de080e7          	jalr	478(ra) # 8000011a <kalloc>
    80004f44:	85aa                	mv	a1,a0
    80004f46:	00a9b023          	sd	a0,0(s3)
        if (argv[i] == 0)
    80004f4a:	cd11                	beqz	a0,80004f66 <sys_exec+0xa6>
            goto bad;
        if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f4c:	6605                	lui	a2,0x1
    80004f4e:	e3043503          	ld	a0,-464(s0)
    80004f52:	ffffd097          	auipc	ra,0xffffd
    80004f56:	026080e7          	jalr	38(ra) # 80001f78 <fetchstr>
    80004f5a:	00054663          	bltz	a0,80004f66 <sys_exec+0xa6>
        if (i >= NELEM(argv)) {
    80004f5e:	0905                	addi	s2,s2,1
    80004f60:	09a1                	addi	s3,s3,8
    80004f62:	fb491be3          	bne	s2,s4,80004f18 <sys_exec+0x58>
        kfree(argv[i]);

    return ret;

bad:
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f66:	f4040913          	addi	s2,s0,-192
    80004f6a:	6088                	ld	a0,0(s1)
    80004f6c:	c539                	beqz	a0,80004fba <sys_exec+0xfa>
        kfree(argv[i]);
    80004f6e:	ffffb097          	auipc	ra,0xffffb
    80004f72:	0ae080e7          	jalr	174(ra) # 8000001c <kfree>
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f76:	04a1                	addi	s1,s1,8
    80004f78:	ff2499e3          	bne	s1,s2,80004f6a <sys_exec+0xaa>
    return -1;
    80004f7c:	557d                	li	a0,-1
    80004f7e:	a83d                	j	80004fbc <sys_exec+0xfc>
            argv[i] = 0;
    80004f80:	0a8e                	slli	s5,s5,0x3
    80004f82:	fc0a8793          	addi	a5,s5,-64
    80004f86:	00878ab3          	add	s5,a5,s0
    80004f8a:	e80ab023          	sd	zero,-384(s5)
    int ret = exec(path, argv);
    80004f8e:	e4040593          	addi	a1,s0,-448
    80004f92:	f4040513          	addi	a0,s0,-192
    80004f96:	fffff097          	auipc	ra,0xfffff
    80004f9a:	16e080e7          	jalr	366(ra) # 80004104 <exec>
    80004f9e:	892a                	mv	s2,a0
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fa0:	f4040993          	addi	s3,s0,-192
    80004fa4:	6088                	ld	a0,0(s1)
    80004fa6:	c901                	beqz	a0,80004fb6 <sys_exec+0xf6>
        kfree(argv[i]);
    80004fa8:	ffffb097          	auipc	ra,0xffffb
    80004fac:	074080e7          	jalr	116(ra) # 8000001c <kfree>
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fb0:	04a1                	addi	s1,s1,8
    80004fb2:	ff3499e3          	bne	s1,s3,80004fa4 <sys_exec+0xe4>
    return ret;
    80004fb6:	854a                	mv	a0,s2
    80004fb8:	a011                	j	80004fbc <sys_exec+0xfc>
    return -1;
    80004fba:	557d                	li	a0,-1
}
    80004fbc:	60be                	ld	ra,456(sp)
    80004fbe:	641e                	ld	s0,448(sp)
    80004fc0:	74fa                	ld	s1,440(sp)
    80004fc2:	795a                	ld	s2,432(sp)
    80004fc4:	79ba                	ld	s3,424(sp)
    80004fc6:	7a1a                	ld	s4,416(sp)
    80004fc8:	6afa                	ld	s5,408(sp)
    80004fca:	6179                	addi	sp,sp,464
    80004fcc:	8082                	ret

0000000080004fce <sys_pipe>:

uint64 sys_pipe(void)
{
    80004fce:	7139                	addi	sp,sp,-64
    80004fd0:	fc06                	sd	ra,56(sp)
    80004fd2:	f822                	sd	s0,48(sp)
    80004fd4:	f426                	sd	s1,40(sp)
    80004fd6:	0080                	addi	s0,sp,64
    uint64 fdarray; // user pointer to array of two integers
    struct file *rf, *wf;
    int fd0, fd1;
    struct proc *p = myproc();
    80004fd8:	ffffc097          	auipc	ra,0xffffc
    80004fdc:	ea0080e7          	jalr	-352(ra) # 80000e78 <myproc>
    80004fe0:	84aa                	mv	s1,a0

    argaddr(0, &fdarray);
    80004fe2:	fd840593          	addi	a1,s0,-40
    80004fe6:	4501                	li	a0,0
    80004fe8:	ffffd097          	auipc	ra,0xffffd
    80004fec:	ffc080e7          	jalr	-4(ra) # 80001fe4 <argaddr>
    if (pipealloc(&rf, &wf) < 0)
    80004ff0:	fc840593          	addi	a1,s0,-56
    80004ff4:	fd040513          	addi	a0,s0,-48
    80004ff8:	fffff097          	auipc	ra,0xfffff
    80004ffc:	dc2080e7          	jalr	-574(ra) # 80003dba <pipealloc>
        return -1;
    80005000:	57fd                	li	a5,-1
    if (pipealloc(&rf, &wf) < 0)
    80005002:	0c054463          	bltz	a0,800050ca <sys_pipe+0xfc>
    fd0 = -1;
    80005006:	fcf42223          	sw	a5,-60(s0)
    if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    8000500a:	fd043503          	ld	a0,-48(s0)
    8000500e:	fffff097          	auipc	ra,0xfffff
    80005012:	514080e7          	jalr	1300(ra) # 80004522 <fdalloc>
    80005016:	fca42223          	sw	a0,-60(s0)
    8000501a:	08054b63          	bltz	a0,800050b0 <sys_pipe+0xe2>
    8000501e:	fc843503          	ld	a0,-56(s0)
    80005022:	fffff097          	auipc	ra,0xfffff
    80005026:	500080e7          	jalr	1280(ra) # 80004522 <fdalloc>
    8000502a:	fca42023          	sw	a0,-64(s0)
    8000502e:	06054863          	bltz	a0,8000509e <sys_pipe+0xd0>
            p->ofile[fd0] = 0;
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 || copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0) {
    80005032:	4691                	li	a3,4
    80005034:	fc440613          	addi	a2,s0,-60
    80005038:	fd843583          	ld	a1,-40(s0)
    8000503c:	68a8                	ld	a0,80(s1)
    8000503e:	ffffc097          	auipc	ra,0xffffc
    80005042:	afa080e7          	jalr	-1286(ra) # 80000b38 <copyout>
    80005046:	02054063          	bltz	a0,80005066 <sys_pipe+0x98>
    8000504a:	4691                	li	a3,4
    8000504c:	fc040613          	addi	a2,s0,-64
    80005050:	fd843583          	ld	a1,-40(s0)
    80005054:	0591                	addi	a1,a1,4
    80005056:	68a8                	ld	a0,80(s1)
    80005058:	ffffc097          	auipc	ra,0xffffc
    8000505c:	ae0080e7          	jalr	-1312(ra) # 80000b38 <copyout>
        p->ofile[fd1] = 0;
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    return 0;
    80005060:	4781                	li	a5,0
    if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 || copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0) {
    80005062:	06055463          	bgez	a0,800050ca <sys_pipe+0xfc>
        p->ofile[fd0] = 0;
    80005066:	fc442783          	lw	a5,-60(s0)
    8000506a:	07e9                	addi	a5,a5,26
    8000506c:	078e                	slli	a5,a5,0x3
    8000506e:	97a6                	add	a5,a5,s1
    80005070:	0007b023          	sd	zero,0(a5)
        p->ofile[fd1] = 0;
    80005074:	fc042783          	lw	a5,-64(s0)
    80005078:	07e9                	addi	a5,a5,26
    8000507a:	078e                	slli	a5,a5,0x3
    8000507c:	94be                	add	s1,s1,a5
    8000507e:	0004b023          	sd	zero,0(s1)
        fileclose(rf);
    80005082:	fd043503          	ld	a0,-48(s0)
    80005086:	fffff097          	auipc	ra,0xfffff
    8000508a:	a04080e7          	jalr	-1532(ra) # 80003a8a <fileclose>
        fileclose(wf);
    8000508e:	fc843503          	ld	a0,-56(s0)
    80005092:	fffff097          	auipc	ra,0xfffff
    80005096:	9f8080e7          	jalr	-1544(ra) # 80003a8a <fileclose>
        return -1;
    8000509a:	57fd                	li	a5,-1
    8000509c:	a03d                	j	800050ca <sys_pipe+0xfc>
        if (fd0 >= 0)
    8000509e:	fc442783          	lw	a5,-60(s0)
    800050a2:	0007c763          	bltz	a5,800050b0 <sys_pipe+0xe2>
            p->ofile[fd0] = 0;
    800050a6:	07e9                	addi	a5,a5,26
    800050a8:	078e                	slli	a5,a5,0x3
    800050aa:	97a6                	add	a5,a5,s1
    800050ac:	0007b023          	sd	zero,0(a5)
        fileclose(rf);
    800050b0:	fd043503          	ld	a0,-48(s0)
    800050b4:	fffff097          	auipc	ra,0xfffff
    800050b8:	9d6080e7          	jalr	-1578(ra) # 80003a8a <fileclose>
        fileclose(wf);
    800050bc:	fc843503          	ld	a0,-56(s0)
    800050c0:	fffff097          	auipc	ra,0xfffff
    800050c4:	9ca080e7          	jalr	-1590(ra) # 80003a8a <fileclose>
        return -1;
    800050c8:	57fd                	li	a5,-1
}
    800050ca:	853e                	mv	a0,a5
    800050cc:	70e2                	ld	ra,56(sp)
    800050ce:	7442                	ld	s0,48(sp)
    800050d0:	74a2                	ld	s1,40(sp)
    800050d2:	6121                	addi	sp,sp,64
    800050d4:	8082                	ret
	...

00000000800050e0 <kernelvec>:
    800050e0:	7111                	addi	sp,sp,-256
    800050e2:	e006                	sd	ra,0(sp)
    800050e4:	e40a                	sd	sp,8(sp)
    800050e6:	e80e                	sd	gp,16(sp)
    800050e8:	ec12                	sd	tp,24(sp)
    800050ea:	f016                	sd	t0,32(sp)
    800050ec:	f41a                	sd	t1,40(sp)
    800050ee:	f81e                	sd	t2,48(sp)
    800050f0:	fc22                	sd	s0,56(sp)
    800050f2:	e0a6                	sd	s1,64(sp)
    800050f4:	e4aa                	sd	a0,72(sp)
    800050f6:	e8ae                	sd	a1,80(sp)
    800050f8:	ecb2                	sd	a2,88(sp)
    800050fa:	f0b6                	sd	a3,96(sp)
    800050fc:	f4ba                	sd	a4,104(sp)
    800050fe:	f8be                	sd	a5,112(sp)
    80005100:	fcc2                	sd	a6,120(sp)
    80005102:	e146                	sd	a7,128(sp)
    80005104:	e54a                	sd	s2,136(sp)
    80005106:	e94e                	sd	s3,144(sp)
    80005108:	ed52                	sd	s4,152(sp)
    8000510a:	f156                	sd	s5,160(sp)
    8000510c:	f55a                	sd	s6,168(sp)
    8000510e:	f95e                	sd	s7,176(sp)
    80005110:	fd62                	sd	s8,184(sp)
    80005112:	e1e6                	sd	s9,192(sp)
    80005114:	e5ea                	sd	s10,200(sp)
    80005116:	e9ee                	sd	s11,208(sp)
    80005118:	edf2                	sd	t3,216(sp)
    8000511a:	f1f6                	sd	t4,224(sp)
    8000511c:	f5fa                	sd	t5,232(sp)
    8000511e:	f9fe                	sd	t6,240(sp)
    80005120:	cd3fc0ef          	jal	ra,80001df2 <kerneltrap>
    80005124:	6082                	ld	ra,0(sp)
    80005126:	6122                	ld	sp,8(sp)
    80005128:	61c2                	ld	gp,16(sp)
    8000512a:	7282                	ld	t0,32(sp)
    8000512c:	7322                	ld	t1,40(sp)
    8000512e:	73c2                	ld	t2,48(sp)
    80005130:	7462                	ld	s0,56(sp)
    80005132:	6486                	ld	s1,64(sp)
    80005134:	6526                	ld	a0,72(sp)
    80005136:	65c6                	ld	a1,80(sp)
    80005138:	6666                	ld	a2,88(sp)
    8000513a:	7686                	ld	a3,96(sp)
    8000513c:	7726                	ld	a4,104(sp)
    8000513e:	77c6                	ld	a5,112(sp)
    80005140:	7866                	ld	a6,120(sp)
    80005142:	688a                	ld	a7,128(sp)
    80005144:	692a                	ld	s2,136(sp)
    80005146:	69ca                	ld	s3,144(sp)
    80005148:	6a6a                	ld	s4,152(sp)
    8000514a:	7a8a                	ld	s5,160(sp)
    8000514c:	7b2a                	ld	s6,168(sp)
    8000514e:	7bca                	ld	s7,176(sp)
    80005150:	7c6a                	ld	s8,184(sp)
    80005152:	6c8e                	ld	s9,192(sp)
    80005154:	6d2e                	ld	s10,200(sp)
    80005156:	6dce                	ld	s11,208(sp)
    80005158:	6e6e                	ld	t3,216(sp)
    8000515a:	7e8e                	ld	t4,224(sp)
    8000515c:	7f2e                	ld	t5,232(sp)
    8000515e:	7fce                	ld	t6,240(sp)
    80005160:	6111                	addi	sp,sp,256
    80005162:	10200073          	sret
    80005166:	00000013          	nop
    8000516a:	00000013          	nop
    8000516e:	0001                	nop

0000000080005170 <timervec>:
    80005170:	34051573          	csrrw	a0,mscratch,a0
    80005174:	e10c                	sd	a1,0(a0)
    80005176:	e510                	sd	a2,8(a0)
    80005178:	e914                	sd	a3,16(a0)
    8000517a:	6d0c                	ld	a1,24(a0)
    8000517c:	7110                	ld	a2,32(a0)
    8000517e:	6194                	ld	a3,0(a1)
    80005180:	96b2                	add	a3,a3,a2
    80005182:	e194                	sd	a3,0(a1)
    80005184:	4589                	li	a1,2
    80005186:	14459073          	csrw	sip,a1
    8000518a:	6914                	ld	a3,16(a0)
    8000518c:	6510                	ld	a2,8(a0)
    8000518e:	610c                	ld	a1,0(a0)
    80005190:	34051573          	csrrw	a0,mscratch,a0
    80005194:	30200073          	mret
	...

000000008000519a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000519a:	1141                	addi	sp,sp,-16
    8000519c:	e422                	sd	s0,8(sp)
    8000519e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800051a0:	0c0007b7          	lui	a5,0xc000
    800051a4:	4705                	li	a4,1
    800051a6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800051a8:	c3d8                	sw	a4,4(a5)
}
    800051aa:	6422                	ld	s0,8(sp)
    800051ac:	0141                	addi	sp,sp,16
    800051ae:	8082                	ret

00000000800051b0 <plicinithart>:

void
plicinithart(void)
{
    800051b0:	1141                	addi	sp,sp,-16
    800051b2:	e406                	sd	ra,8(sp)
    800051b4:	e022                	sd	s0,0(sp)
    800051b6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051b8:	ffffc097          	auipc	ra,0xffffc
    800051bc:	c94080e7          	jalr	-876(ra) # 80000e4c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800051c0:	0085171b          	slliw	a4,a0,0x8
    800051c4:	0c0027b7          	lui	a5,0xc002
    800051c8:	97ba                	add	a5,a5,a4
    800051ca:	40200713          	li	a4,1026
    800051ce:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800051d2:	00d5151b          	slliw	a0,a0,0xd
    800051d6:	0c2017b7          	lui	a5,0xc201
    800051da:	97aa                	add	a5,a5,a0
    800051dc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800051e0:	60a2                	ld	ra,8(sp)
    800051e2:	6402                	ld	s0,0(sp)
    800051e4:	0141                	addi	sp,sp,16
    800051e6:	8082                	ret

00000000800051e8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800051e8:	1141                	addi	sp,sp,-16
    800051ea:	e406                	sd	ra,8(sp)
    800051ec:	e022                	sd	s0,0(sp)
    800051ee:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051f0:	ffffc097          	auipc	ra,0xffffc
    800051f4:	c5c080e7          	jalr	-932(ra) # 80000e4c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051f8:	00d5151b          	slliw	a0,a0,0xd
    800051fc:	0c2017b7          	lui	a5,0xc201
    80005200:	97aa                	add	a5,a5,a0
  return irq;
}
    80005202:	43c8                	lw	a0,4(a5)
    80005204:	60a2                	ld	ra,8(sp)
    80005206:	6402                	ld	s0,0(sp)
    80005208:	0141                	addi	sp,sp,16
    8000520a:	8082                	ret

000000008000520c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000520c:	1101                	addi	sp,sp,-32
    8000520e:	ec06                	sd	ra,24(sp)
    80005210:	e822                	sd	s0,16(sp)
    80005212:	e426                	sd	s1,8(sp)
    80005214:	1000                	addi	s0,sp,32
    80005216:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005218:	ffffc097          	auipc	ra,0xffffc
    8000521c:	c34080e7          	jalr	-972(ra) # 80000e4c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005220:	00d5151b          	slliw	a0,a0,0xd
    80005224:	0c2017b7          	lui	a5,0xc201
    80005228:	97aa                	add	a5,a5,a0
    8000522a:	c3c4                	sw	s1,4(a5)
}
    8000522c:	60e2                	ld	ra,24(sp)
    8000522e:	6442                	ld	s0,16(sp)
    80005230:	64a2                	ld	s1,8(sp)
    80005232:	6105                	addi	sp,sp,32
    80005234:	8082                	ret

0000000080005236 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005236:	1141                	addi	sp,sp,-16
    80005238:	e406                	sd	ra,8(sp)
    8000523a:	e022                	sd	s0,0(sp)
    8000523c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000523e:	479d                	li	a5,7
    80005240:	04a7cc63          	blt	a5,a0,80005298 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005244:	00015797          	auipc	a5,0x15
    80005248:	b4c78793          	addi	a5,a5,-1204 # 80019d90 <disk>
    8000524c:	97aa                	add	a5,a5,a0
    8000524e:	0187c783          	lbu	a5,24(a5)
    80005252:	ebb9                	bnez	a5,800052a8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005254:	00451693          	slli	a3,a0,0x4
    80005258:	00015797          	auipc	a5,0x15
    8000525c:	b3878793          	addi	a5,a5,-1224 # 80019d90 <disk>
    80005260:	6398                	ld	a4,0(a5)
    80005262:	9736                	add	a4,a4,a3
    80005264:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005268:	6398                	ld	a4,0(a5)
    8000526a:	9736                	add	a4,a4,a3
    8000526c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005270:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005274:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005278:	97aa                	add	a5,a5,a0
    8000527a:	4705                	li	a4,1
    8000527c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005280:	00015517          	auipc	a0,0x15
    80005284:	b2850513          	addi	a0,a0,-1240 # 80019da8 <disk+0x18>
    80005288:	ffffc097          	auipc	ra,0xffffc
    8000528c:	304080e7          	jalr	772(ra) # 8000158c <wakeup>
}
    80005290:	60a2                	ld	ra,8(sp)
    80005292:	6402                	ld	s0,0(sp)
    80005294:	0141                	addi	sp,sp,16
    80005296:	8082                	ret
    panic("free_desc 1");
    80005298:	00003517          	auipc	a0,0x3
    8000529c:	4f850513          	addi	a0,a0,1272 # 80008790 <syscalls+0x2f8>
    800052a0:	00001097          	auipc	ra,0x1
    800052a4:	a0c080e7          	jalr	-1524(ra) # 80005cac <panic>
    panic("free_desc 2");
    800052a8:	00003517          	auipc	a0,0x3
    800052ac:	4f850513          	addi	a0,a0,1272 # 800087a0 <syscalls+0x308>
    800052b0:	00001097          	auipc	ra,0x1
    800052b4:	9fc080e7          	jalr	-1540(ra) # 80005cac <panic>

00000000800052b8 <virtio_disk_init>:
{
    800052b8:	1101                	addi	sp,sp,-32
    800052ba:	ec06                	sd	ra,24(sp)
    800052bc:	e822                	sd	s0,16(sp)
    800052be:	e426                	sd	s1,8(sp)
    800052c0:	e04a                	sd	s2,0(sp)
    800052c2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800052c4:	00003597          	auipc	a1,0x3
    800052c8:	4ec58593          	addi	a1,a1,1260 # 800087b0 <syscalls+0x318>
    800052cc:	00015517          	auipc	a0,0x15
    800052d0:	bec50513          	addi	a0,a0,-1044 # 80019eb8 <disk+0x128>
    800052d4:	00001097          	auipc	ra,0x1
    800052d8:	e80080e7          	jalr	-384(ra) # 80006154 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052dc:	100017b7          	lui	a5,0x10001
    800052e0:	4398                	lw	a4,0(a5)
    800052e2:	2701                	sext.w	a4,a4
    800052e4:	747277b7          	lui	a5,0x74727
    800052e8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052ec:	14f71b63          	bne	a4,a5,80005442 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052f0:	100017b7          	lui	a5,0x10001
    800052f4:	43dc                	lw	a5,4(a5)
    800052f6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052f8:	4709                	li	a4,2
    800052fa:	14e79463          	bne	a5,a4,80005442 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052fe:	100017b7          	lui	a5,0x10001
    80005302:	479c                	lw	a5,8(a5)
    80005304:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005306:	12e79e63          	bne	a5,a4,80005442 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000530a:	100017b7          	lui	a5,0x10001
    8000530e:	47d8                	lw	a4,12(a5)
    80005310:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005312:	554d47b7          	lui	a5,0x554d4
    80005316:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000531a:	12f71463          	bne	a4,a5,80005442 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000531e:	100017b7          	lui	a5,0x10001
    80005322:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005326:	4705                	li	a4,1
    80005328:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000532a:	470d                	li	a4,3
    8000532c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000532e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005330:	c7ffe6b7          	lui	a3,0xc7ffe
    80005334:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc64f>
    80005338:	8f75                	and	a4,a4,a3
    8000533a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000533c:	472d                	li	a4,11
    8000533e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005340:	5bbc                	lw	a5,112(a5)
    80005342:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005346:	8ba1                	andi	a5,a5,8
    80005348:	10078563          	beqz	a5,80005452 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000534c:	100017b7          	lui	a5,0x10001
    80005350:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005354:	43fc                	lw	a5,68(a5)
    80005356:	2781                	sext.w	a5,a5
    80005358:	10079563          	bnez	a5,80005462 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000535c:	100017b7          	lui	a5,0x10001
    80005360:	5bdc                	lw	a5,52(a5)
    80005362:	2781                	sext.w	a5,a5
  if(max == 0)
    80005364:	10078763          	beqz	a5,80005472 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005368:	471d                	li	a4,7
    8000536a:	10f77c63          	bgeu	a4,a5,80005482 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000536e:	ffffb097          	auipc	ra,0xffffb
    80005372:	dac080e7          	jalr	-596(ra) # 8000011a <kalloc>
    80005376:	00015497          	auipc	s1,0x15
    8000537a:	a1a48493          	addi	s1,s1,-1510 # 80019d90 <disk>
    8000537e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005380:	ffffb097          	auipc	ra,0xffffb
    80005384:	d9a080e7          	jalr	-614(ra) # 8000011a <kalloc>
    80005388:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000538a:	ffffb097          	auipc	ra,0xffffb
    8000538e:	d90080e7          	jalr	-624(ra) # 8000011a <kalloc>
    80005392:	87aa                	mv	a5,a0
    80005394:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005396:	6088                	ld	a0,0(s1)
    80005398:	cd6d                	beqz	a0,80005492 <virtio_disk_init+0x1da>
    8000539a:	00015717          	auipc	a4,0x15
    8000539e:	9fe73703          	ld	a4,-1538(a4) # 80019d98 <disk+0x8>
    800053a2:	cb65                	beqz	a4,80005492 <virtio_disk_init+0x1da>
    800053a4:	c7fd                	beqz	a5,80005492 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    800053a6:	6605                	lui	a2,0x1
    800053a8:	4581                	li	a1,0
    800053aa:	ffffb097          	auipc	ra,0xffffb
    800053ae:	df4080e7          	jalr	-524(ra) # 8000019e <memset>
  memset(disk.avail, 0, PGSIZE);
    800053b2:	00015497          	auipc	s1,0x15
    800053b6:	9de48493          	addi	s1,s1,-1570 # 80019d90 <disk>
    800053ba:	6605                	lui	a2,0x1
    800053bc:	4581                	li	a1,0
    800053be:	6488                	ld	a0,8(s1)
    800053c0:	ffffb097          	auipc	ra,0xffffb
    800053c4:	dde080e7          	jalr	-546(ra) # 8000019e <memset>
  memset(disk.used, 0, PGSIZE);
    800053c8:	6605                	lui	a2,0x1
    800053ca:	4581                	li	a1,0
    800053cc:	6888                	ld	a0,16(s1)
    800053ce:	ffffb097          	auipc	ra,0xffffb
    800053d2:	dd0080e7          	jalr	-560(ra) # 8000019e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800053d6:	100017b7          	lui	a5,0x10001
    800053da:	4721                	li	a4,8
    800053dc:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800053de:	4098                	lw	a4,0(s1)
    800053e0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800053e4:	40d8                	lw	a4,4(s1)
    800053e6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800053ea:	6498                	ld	a4,8(s1)
    800053ec:	0007069b          	sext.w	a3,a4
    800053f0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800053f4:	9701                	srai	a4,a4,0x20
    800053f6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800053fa:	6898                	ld	a4,16(s1)
    800053fc:	0007069b          	sext.w	a3,a4
    80005400:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005404:	9701                	srai	a4,a4,0x20
    80005406:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000540a:	4705                	li	a4,1
    8000540c:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    8000540e:	00e48c23          	sb	a4,24(s1)
    80005412:	00e48ca3          	sb	a4,25(s1)
    80005416:	00e48d23          	sb	a4,26(s1)
    8000541a:	00e48da3          	sb	a4,27(s1)
    8000541e:	00e48e23          	sb	a4,28(s1)
    80005422:	00e48ea3          	sb	a4,29(s1)
    80005426:	00e48f23          	sb	a4,30(s1)
    8000542a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000542e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005432:	0727a823          	sw	s2,112(a5)
}
    80005436:	60e2                	ld	ra,24(sp)
    80005438:	6442                	ld	s0,16(sp)
    8000543a:	64a2                	ld	s1,8(sp)
    8000543c:	6902                	ld	s2,0(sp)
    8000543e:	6105                	addi	sp,sp,32
    80005440:	8082                	ret
    panic("could not find virtio disk");
    80005442:	00003517          	auipc	a0,0x3
    80005446:	37e50513          	addi	a0,a0,894 # 800087c0 <syscalls+0x328>
    8000544a:	00001097          	auipc	ra,0x1
    8000544e:	862080e7          	jalr	-1950(ra) # 80005cac <panic>
    panic("virtio disk FEATURES_OK unset");
    80005452:	00003517          	auipc	a0,0x3
    80005456:	38e50513          	addi	a0,a0,910 # 800087e0 <syscalls+0x348>
    8000545a:	00001097          	auipc	ra,0x1
    8000545e:	852080e7          	jalr	-1966(ra) # 80005cac <panic>
    panic("virtio disk should not be ready");
    80005462:	00003517          	auipc	a0,0x3
    80005466:	39e50513          	addi	a0,a0,926 # 80008800 <syscalls+0x368>
    8000546a:	00001097          	auipc	ra,0x1
    8000546e:	842080e7          	jalr	-1982(ra) # 80005cac <panic>
    panic("virtio disk has no queue 0");
    80005472:	00003517          	auipc	a0,0x3
    80005476:	3ae50513          	addi	a0,a0,942 # 80008820 <syscalls+0x388>
    8000547a:	00001097          	auipc	ra,0x1
    8000547e:	832080e7          	jalr	-1998(ra) # 80005cac <panic>
    panic("virtio disk max queue too short");
    80005482:	00003517          	auipc	a0,0x3
    80005486:	3be50513          	addi	a0,a0,958 # 80008840 <syscalls+0x3a8>
    8000548a:	00001097          	auipc	ra,0x1
    8000548e:	822080e7          	jalr	-2014(ra) # 80005cac <panic>
    panic("virtio disk kalloc");
    80005492:	00003517          	auipc	a0,0x3
    80005496:	3ce50513          	addi	a0,a0,974 # 80008860 <syscalls+0x3c8>
    8000549a:	00001097          	auipc	ra,0x1
    8000549e:	812080e7          	jalr	-2030(ra) # 80005cac <panic>

00000000800054a2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800054a2:	7119                	addi	sp,sp,-128
    800054a4:	fc86                	sd	ra,120(sp)
    800054a6:	f8a2                	sd	s0,112(sp)
    800054a8:	f4a6                	sd	s1,104(sp)
    800054aa:	f0ca                	sd	s2,96(sp)
    800054ac:	ecce                	sd	s3,88(sp)
    800054ae:	e8d2                	sd	s4,80(sp)
    800054b0:	e4d6                	sd	s5,72(sp)
    800054b2:	e0da                	sd	s6,64(sp)
    800054b4:	fc5e                	sd	s7,56(sp)
    800054b6:	f862                	sd	s8,48(sp)
    800054b8:	f466                	sd	s9,40(sp)
    800054ba:	f06a                	sd	s10,32(sp)
    800054bc:	ec6e                	sd	s11,24(sp)
    800054be:	0100                	addi	s0,sp,128
    800054c0:	8aaa                	mv	s5,a0
    800054c2:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800054c4:	00c52d03          	lw	s10,12(a0)
    800054c8:	001d1d1b          	slliw	s10,s10,0x1
    800054cc:	1d02                	slli	s10,s10,0x20
    800054ce:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    800054d2:	00015517          	auipc	a0,0x15
    800054d6:	9e650513          	addi	a0,a0,-1562 # 80019eb8 <disk+0x128>
    800054da:	00001097          	auipc	ra,0x1
    800054de:	d0a080e7          	jalr	-758(ra) # 800061e4 <acquire>
  for(int i = 0; i < 3; i++){
    800054e2:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800054e4:	44a1                	li	s1,8
      disk.free[i] = 0;
    800054e6:	00015b97          	auipc	s7,0x15
    800054ea:	8aab8b93          	addi	s7,s7,-1878 # 80019d90 <disk>
  for(int i = 0; i < 3; i++){
    800054ee:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054f0:	00015c97          	auipc	s9,0x15
    800054f4:	9c8c8c93          	addi	s9,s9,-1592 # 80019eb8 <disk+0x128>
    800054f8:	a08d                	j	8000555a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800054fa:	00fb8733          	add	a4,s7,a5
    800054fe:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005502:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005504:	0207c563          	bltz	a5,8000552e <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    80005508:	2905                	addiw	s2,s2,1
    8000550a:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000550c:	05690c63          	beq	s2,s6,80005564 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80005510:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005512:	00015717          	auipc	a4,0x15
    80005516:	87e70713          	addi	a4,a4,-1922 # 80019d90 <disk>
    8000551a:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000551c:	01874683          	lbu	a3,24(a4)
    80005520:	fee9                	bnez	a3,800054fa <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005522:	2785                	addiw	a5,a5,1
    80005524:	0705                	addi	a4,a4,1
    80005526:	fe979be3          	bne	a5,s1,8000551c <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000552a:	57fd                	li	a5,-1
    8000552c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000552e:	01205d63          	blez	s2,80005548 <virtio_disk_rw+0xa6>
    80005532:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005534:	000a2503          	lw	a0,0(s4)
    80005538:	00000097          	auipc	ra,0x0
    8000553c:	cfe080e7          	jalr	-770(ra) # 80005236 <free_desc>
      for(int j = 0; j < i; j++)
    80005540:	2d85                	addiw	s11,s11,1
    80005542:	0a11                	addi	s4,s4,4
    80005544:	ff2d98e3          	bne	s11,s2,80005534 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005548:	85e6                	mv	a1,s9
    8000554a:	00015517          	auipc	a0,0x15
    8000554e:	85e50513          	addi	a0,a0,-1954 # 80019da8 <disk+0x18>
    80005552:	ffffc097          	auipc	ra,0xffffc
    80005556:	fd6080e7          	jalr	-42(ra) # 80001528 <sleep>
  for(int i = 0; i < 3; i++){
    8000555a:	f8040a13          	addi	s4,s0,-128
{
    8000555e:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005560:	894e                	mv	s2,s3
    80005562:	b77d                	j	80005510 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005564:	f8042503          	lw	a0,-128(s0)
    80005568:	00a50713          	addi	a4,a0,10
    8000556c:	0712                	slli	a4,a4,0x4

  if(write)
    8000556e:	00015797          	auipc	a5,0x15
    80005572:	82278793          	addi	a5,a5,-2014 # 80019d90 <disk>
    80005576:	00e786b3          	add	a3,a5,a4
    8000557a:	01803633          	snez	a2,s8
    8000557e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005580:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005584:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005588:	f6070613          	addi	a2,a4,-160
    8000558c:	6394                	ld	a3,0(a5)
    8000558e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005590:	00870593          	addi	a1,a4,8
    80005594:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005596:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005598:	0007b803          	ld	a6,0(a5)
    8000559c:	9642                	add	a2,a2,a6
    8000559e:	46c1                	li	a3,16
    800055a0:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055a2:	4585                	li	a1,1
    800055a4:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    800055a8:	f8442683          	lw	a3,-124(s0)
    800055ac:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800055b0:	0692                	slli	a3,a3,0x4
    800055b2:	9836                	add	a6,a6,a3
    800055b4:	058a8613          	addi	a2,s5,88
    800055b8:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    800055bc:	0007b803          	ld	a6,0(a5)
    800055c0:	96c2                	add	a3,a3,a6
    800055c2:	40000613          	li	a2,1024
    800055c6:	c690                	sw	a2,8(a3)
  if(write)
    800055c8:	001c3613          	seqz	a2,s8
    800055cc:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055d0:	00166613          	ori	a2,a2,1
    800055d4:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800055d8:	f8842603          	lw	a2,-120(s0)
    800055dc:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800055e0:	00250693          	addi	a3,a0,2
    800055e4:	0692                	slli	a3,a3,0x4
    800055e6:	96be                	add	a3,a3,a5
    800055e8:	58fd                	li	a7,-1
    800055ea:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800055ee:	0612                	slli	a2,a2,0x4
    800055f0:	9832                	add	a6,a6,a2
    800055f2:	f9070713          	addi	a4,a4,-112
    800055f6:	973e                	add	a4,a4,a5
    800055f8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800055fc:	6398                	ld	a4,0(a5)
    800055fe:	9732                	add	a4,a4,a2
    80005600:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005602:	4609                	li	a2,2
    80005604:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80005608:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000560c:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    80005610:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005614:	6794                	ld	a3,8(a5)
    80005616:	0026d703          	lhu	a4,2(a3)
    8000561a:	8b1d                	andi	a4,a4,7
    8000561c:	0706                	slli	a4,a4,0x1
    8000561e:	96ba                	add	a3,a3,a4
    80005620:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005624:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005628:	6798                	ld	a4,8(a5)
    8000562a:	00275783          	lhu	a5,2(a4)
    8000562e:	2785                	addiw	a5,a5,1
    80005630:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005634:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005638:	100017b7          	lui	a5,0x10001
    8000563c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005640:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    80005644:	00015917          	auipc	s2,0x15
    80005648:	87490913          	addi	s2,s2,-1932 # 80019eb8 <disk+0x128>
  while(b->disk == 1) {
    8000564c:	4485                	li	s1,1
    8000564e:	00b79c63          	bne	a5,a1,80005666 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005652:	85ca                	mv	a1,s2
    80005654:	8556                	mv	a0,s5
    80005656:	ffffc097          	auipc	ra,0xffffc
    8000565a:	ed2080e7          	jalr	-302(ra) # 80001528 <sleep>
  while(b->disk == 1) {
    8000565e:	004aa783          	lw	a5,4(s5)
    80005662:	fe9788e3          	beq	a5,s1,80005652 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005666:	f8042903          	lw	s2,-128(s0)
    8000566a:	00290713          	addi	a4,s2,2
    8000566e:	0712                	slli	a4,a4,0x4
    80005670:	00014797          	auipc	a5,0x14
    80005674:	72078793          	addi	a5,a5,1824 # 80019d90 <disk>
    80005678:	97ba                	add	a5,a5,a4
    8000567a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000567e:	00014997          	auipc	s3,0x14
    80005682:	71298993          	addi	s3,s3,1810 # 80019d90 <disk>
    80005686:	00491713          	slli	a4,s2,0x4
    8000568a:	0009b783          	ld	a5,0(s3)
    8000568e:	97ba                	add	a5,a5,a4
    80005690:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005694:	854a                	mv	a0,s2
    80005696:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000569a:	00000097          	auipc	ra,0x0
    8000569e:	b9c080e7          	jalr	-1124(ra) # 80005236 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056a2:	8885                	andi	s1,s1,1
    800056a4:	f0ed                	bnez	s1,80005686 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056a6:	00015517          	auipc	a0,0x15
    800056aa:	81250513          	addi	a0,a0,-2030 # 80019eb8 <disk+0x128>
    800056ae:	00001097          	auipc	ra,0x1
    800056b2:	bea080e7          	jalr	-1046(ra) # 80006298 <release>
}
    800056b6:	70e6                	ld	ra,120(sp)
    800056b8:	7446                	ld	s0,112(sp)
    800056ba:	74a6                	ld	s1,104(sp)
    800056bc:	7906                	ld	s2,96(sp)
    800056be:	69e6                	ld	s3,88(sp)
    800056c0:	6a46                	ld	s4,80(sp)
    800056c2:	6aa6                	ld	s5,72(sp)
    800056c4:	6b06                	ld	s6,64(sp)
    800056c6:	7be2                	ld	s7,56(sp)
    800056c8:	7c42                	ld	s8,48(sp)
    800056ca:	7ca2                	ld	s9,40(sp)
    800056cc:	7d02                	ld	s10,32(sp)
    800056ce:	6de2                	ld	s11,24(sp)
    800056d0:	6109                	addi	sp,sp,128
    800056d2:	8082                	ret

00000000800056d4 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800056d4:	1101                	addi	sp,sp,-32
    800056d6:	ec06                	sd	ra,24(sp)
    800056d8:	e822                	sd	s0,16(sp)
    800056da:	e426                	sd	s1,8(sp)
    800056dc:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800056de:	00014497          	auipc	s1,0x14
    800056e2:	6b248493          	addi	s1,s1,1714 # 80019d90 <disk>
    800056e6:	00014517          	auipc	a0,0x14
    800056ea:	7d250513          	addi	a0,a0,2002 # 80019eb8 <disk+0x128>
    800056ee:	00001097          	auipc	ra,0x1
    800056f2:	af6080e7          	jalr	-1290(ra) # 800061e4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056f6:	10001737          	lui	a4,0x10001
    800056fa:	533c                	lw	a5,96(a4)
    800056fc:	8b8d                	andi	a5,a5,3
    800056fe:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005700:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005704:	689c                	ld	a5,16(s1)
    80005706:	0204d703          	lhu	a4,32(s1)
    8000570a:	0027d783          	lhu	a5,2(a5)
    8000570e:	04f70863          	beq	a4,a5,8000575e <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005712:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005716:	6898                	ld	a4,16(s1)
    80005718:	0204d783          	lhu	a5,32(s1)
    8000571c:	8b9d                	andi	a5,a5,7
    8000571e:	078e                	slli	a5,a5,0x3
    80005720:	97ba                	add	a5,a5,a4
    80005722:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005724:	00278713          	addi	a4,a5,2
    80005728:	0712                	slli	a4,a4,0x4
    8000572a:	9726                	add	a4,a4,s1
    8000572c:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005730:	e721                	bnez	a4,80005778 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005732:	0789                	addi	a5,a5,2
    80005734:	0792                	slli	a5,a5,0x4
    80005736:	97a6                	add	a5,a5,s1
    80005738:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000573a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000573e:	ffffc097          	auipc	ra,0xffffc
    80005742:	e4e080e7          	jalr	-434(ra) # 8000158c <wakeup>

    disk.used_idx += 1;
    80005746:	0204d783          	lhu	a5,32(s1)
    8000574a:	2785                	addiw	a5,a5,1
    8000574c:	17c2                	slli	a5,a5,0x30
    8000574e:	93c1                	srli	a5,a5,0x30
    80005750:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005754:	6898                	ld	a4,16(s1)
    80005756:	00275703          	lhu	a4,2(a4)
    8000575a:	faf71ce3          	bne	a4,a5,80005712 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000575e:	00014517          	auipc	a0,0x14
    80005762:	75a50513          	addi	a0,a0,1882 # 80019eb8 <disk+0x128>
    80005766:	00001097          	auipc	ra,0x1
    8000576a:	b32080e7          	jalr	-1230(ra) # 80006298 <release>
}
    8000576e:	60e2                	ld	ra,24(sp)
    80005770:	6442                	ld	s0,16(sp)
    80005772:	64a2                	ld	s1,8(sp)
    80005774:	6105                	addi	sp,sp,32
    80005776:	8082                	ret
      panic("virtio_disk_intr status");
    80005778:	00003517          	auipc	a0,0x3
    8000577c:	10050513          	addi	a0,a0,256 # 80008878 <syscalls+0x3e0>
    80005780:	00000097          	auipc	ra,0x0
    80005784:	52c080e7          	jalr	1324(ra) # 80005cac <panic>

0000000080005788 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005788:	1141                	addi	sp,sp,-16
    8000578a:	e422                	sd	s0,8(sp)
    8000578c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000578e:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005792:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005796:	0037979b          	slliw	a5,a5,0x3
    8000579a:	02004737          	lui	a4,0x2004
    8000579e:	97ba                	add	a5,a5,a4
    800057a0:	0200c737          	lui	a4,0x200c
    800057a4:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800057a8:	000f4637          	lui	a2,0xf4
    800057ac:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800057b0:	9732                	add	a4,a4,a2
    800057b2:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800057b4:	00259693          	slli	a3,a1,0x2
    800057b8:	96ae                	add	a3,a3,a1
    800057ba:	068e                	slli	a3,a3,0x3
    800057bc:	00014717          	auipc	a4,0x14
    800057c0:	71470713          	addi	a4,a4,1812 # 80019ed0 <timer_scratch>
    800057c4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800057c6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800057c8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800057ca:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800057ce:	00000797          	auipc	a5,0x0
    800057d2:	9a278793          	addi	a5,a5,-1630 # 80005170 <timervec>
    800057d6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057da:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800057de:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057e2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800057e6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800057ea:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800057ee:	30479073          	csrw	mie,a5
}
    800057f2:	6422                	ld	s0,8(sp)
    800057f4:	0141                	addi	sp,sp,16
    800057f6:	8082                	ret

00000000800057f8 <start>:
{
    800057f8:	1141                	addi	sp,sp,-16
    800057fa:	e406                	sd	ra,8(sp)
    800057fc:	e022                	sd	s0,0(sp)
    800057fe:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005800:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005804:	7779                	lui	a4,0xffffe
    80005806:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc6ef>
    8000580a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000580c:	6705                	lui	a4,0x1
    8000580e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005812:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005814:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005818:	ffffb797          	auipc	a5,0xffffb
    8000581c:	b2c78793          	addi	a5,a5,-1236 # 80000344 <main>
    80005820:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005824:	4781                	li	a5,0
    80005826:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000582a:	67c1                	lui	a5,0x10
    8000582c:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000582e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005832:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005836:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000583a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000583e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005842:	57fd                	li	a5,-1
    80005844:	83a9                	srli	a5,a5,0xa
    80005846:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000584a:	47bd                	li	a5,15
    8000584c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005850:	00000097          	auipc	ra,0x0
    80005854:	f38080e7          	jalr	-200(ra) # 80005788 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005858:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000585c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000585e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005860:	30200073          	mret
}
    80005864:	60a2                	ld	ra,8(sp)
    80005866:	6402                	ld	s0,0(sp)
    80005868:	0141                	addi	sp,sp,16
    8000586a:	8082                	ret

000000008000586c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000586c:	715d                	addi	sp,sp,-80
    8000586e:	e486                	sd	ra,72(sp)
    80005870:	e0a2                	sd	s0,64(sp)
    80005872:	fc26                	sd	s1,56(sp)
    80005874:	f84a                	sd	s2,48(sp)
    80005876:	f44e                	sd	s3,40(sp)
    80005878:	f052                	sd	s4,32(sp)
    8000587a:	ec56                	sd	s5,24(sp)
    8000587c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000587e:	04c05763          	blez	a2,800058cc <consolewrite+0x60>
    80005882:	8a2a                	mv	s4,a0
    80005884:	84ae                	mv	s1,a1
    80005886:	89b2                	mv	s3,a2
    80005888:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000588a:	5afd                	li	s5,-1
    8000588c:	4685                	li	a3,1
    8000588e:	8626                	mv	a2,s1
    80005890:	85d2                	mv	a1,s4
    80005892:	fbf40513          	addi	a0,s0,-65
    80005896:	ffffc097          	auipc	ra,0xffffc
    8000589a:	0f0080e7          	jalr	240(ra) # 80001986 <either_copyin>
    8000589e:	01550d63          	beq	a0,s5,800058b8 <consolewrite+0x4c>
      break;
    uartputc(c);
    800058a2:	fbf44503          	lbu	a0,-65(s0)
    800058a6:	00000097          	auipc	ra,0x0
    800058aa:	784080e7          	jalr	1924(ra) # 8000602a <uartputc>
  for(i = 0; i < n; i++){
    800058ae:	2905                	addiw	s2,s2,1
    800058b0:	0485                	addi	s1,s1,1
    800058b2:	fd299de3          	bne	s3,s2,8000588c <consolewrite+0x20>
    800058b6:	894e                	mv	s2,s3
  }

  return i;
}
    800058b8:	854a                	mv	a0,s2
    800058ba:	60a6                	ld	ra,72(sp)
    800058bc:	6406                	ld	s0,64(sp)
    800058be:	74e2                	ld	s1,56(sp)
    800058c0:	7942                	ld	s2,48(sp)
    800058c2:	79a2                	ld	s3,40(sp)
    800058c4:	7a02                	ld	s4,32(sp)
    800058c6:	6ae2                	ld	s5,24(sp)
    800058c8:	6161                	addi	sp,sp,80
    800058ca:	8082                	ret
  for(i = 0; i < n; i++){
    800058cc:	4901                	li	s2,0
    800058ce:	b7ed                	j	800058b8 <consolewrite+0x4c>

00000000800058d0 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800058d0:	7159                	addi	sp,sp,-112
    800058d2:	f486                	sd	ra,104(sp)
    800058d4:	f0a2                	sd	s0,96(sp)
    800058d6:	eca6                	sd	s1,88(sp)
    800058d8:	e8ca                	sd	s2,80(sp)
    800058da:	e4ce                	sd	s3,72(sp)
    800058dc:	e0d2                	sd	s4,64(sp)
    800058de:	fc56                	sd	s5,56(sp)
    800058e0:	f85a                	sd	s6,48(sp)
    800058e2:	f45e                	sd	s7,40(sp)
    800058e4:	f062                	sd	s8,32(sp)
    800058e6:	ec66                	sd	s9,24(sp)
    800058e8:	e86a                	sd	s10,16(sp)
    800058ea:	1880                	addi	s0,sp,112
    800058ec:	8aaa                	mv	s5,a0
    800058ee:	8a2e                	mv	s4,a1
    800058f0:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058f2:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800058f6:	0001c517          	auipc	a0,0x1c
    800058fa:	71a50513          	addi	a0,a0,1818 # 80022010 <cons>
    800058fe:	00001097          	auipc	ra,0x1
    80005902:	8e6080e7          	jalr	-1818(ra) # 800061e4 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005906:	0001c497          	auipc	s1,0x1c
    8000590a:	70a48493          	addi	s1,s1,1802 # 80022010 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000590e:	0001c917          	auipc	s2,0x1c
    80005912:	79a90913          	addi	s2,s2,1946 # 800220a8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005916:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005918:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000591a:	4ca9                	li	s9,10
  while(n > 0){
    8000591c:	07305b63          	blez	s3,80005992 <consoleread+0xc2>
    while(cons.r == cons.w){
    80005920:	0984a783          	lw	a5,152(s1)
    80005924:	09c4a703          	lw	a4,156(s1)
    80005928:	02f71763          	bne	a4,a5,80005956 <consoleread+0x86>
      if(killed(myproc())){
    8000592c:	ffffb097          	auipc	ra,0xffffb
    80005930:	54c080e7          	jalr	1356(ra) # 80000e78 <myproc>
    80005934:	ffffc097          	auipc	ra,0xffffc
    80005938:	e9c080e7          	jalr	-356(ra) # 800017d0 <killed>
    8000593c:	e535                	bnez	a0,800059a8 <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    8000593e:	85a6                	mv	a1,s1
    80005940:	854a                	mv	a0,s2
    80005942:	ffffc097          	auipc	ra,0xffffc
    80005946:	be6080e7          	jalr	-1050(ra) # 80001528 <sleep>
    while(cons.r == cons.w){
    8000594a:	0984a783          	lw	a5,152(s1)
    8000594e:	09c4a703          	lw	a4,156(s1)
    80005952:	fcf70de3          	beq	a4,a5,8000592c <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005956:	0017871b          	addiw	a4,a5,1
    8000595a:	08e4ac23          	sw	a4,152(s1)
    8000595e:	07f7f713          	andi	a4,a5,127
    80005962:	9726                	add	a4,a4,s1
    80005964:	01874703          	lbu	a4,24(a4)
    80005968:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    8000596c:	077d0563          	beq	s10,s7,800059d6 <consoleread+0x106>
    cbuf = c;
    80005970:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005974:	4685                	li	a3,1
    80005976:	f9f40613          	addi	a2,s0,-97
    8000597a:	85d2                	mv	a1,s4
    8000597c:	8556                	mv	a0,s5
    8000597e:	ffffc097          	auipc	ra,0xffffc
    80005982:	fb2080e7          	jalr	-78(ra) # 80001930 <either_copyout>
    80005986:	01850663          	beq	a0,s8,80005992 <consoleread+0xc2>
    dst++;
    8000598a:	0a05                	addi	s4,s4,1
    --n;
    8000598c:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    8000598e:	f99d17e3          	bne	s10,s9,8000591c <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005992:	0001c517          	auipc	a0,0x1c
    80005996:	67e50513          	addi	a0,a0,1662 # 80022010 <cons>
    8000599a:	00001097          	auipc	ra,0x1
    8000599e:	8fe080e7          	jalr	-1794(ra) # 80006298 <release>

  return target - n;
    800059a2:	413b053b          	subw	a0,s6,s3
    800059a6:	a811                	j	800059ba <consoleread+0xea>
        release(&cons.lock);
    800059a8:	0001c517          	auipc	a0,0x1c
    800059ac:	66850513          	addi	a0,a0,1640 # 80022010 <cons>
    800059b0:	00001097          	auipc	ra,0x1
    800059b4:	8e8080e7          	jalr	-1816(ra) # 80006298 <release>
        return -1;
    800059b8:	557d                	li	a0,-1
}
    800059ba:	70a6                	ld	ra,104(sp)
    800059bc:	7406                	ld	s0,96(sp)
    800059be:	64e6                	ld	s1,88(sp)
    800059c0:	6946                	ld	s2,80(sp)
    800059c2:	69a6                	ld	s3,72(sp)
    800059c4:	6a06                	ld	s4,64(sp)
    800059c6:	7ae2                	ld	s5,56(sp)
    800059c8:	7b42                	ld	s6,48(sp)
    800059ca:	7ba2                	ld	s7,40(sp)
    800059cc:	7c02                	ld	s8,32(sp)
    800059ce:	6ce2                	ld	s9,24(sp)
    800059d0:	6d42                	ld	s10,16(sp)
    800059d2:	6165                	addi	sp,sp,112
    800059d4:	8082                	ret
      if(n < target){
    800059d6:	0009871b          	sext.w	a4,s3
    800059da:	fb677ce3          	bgeu	a4,s6,80005992 <consoleread+0xc2>
        cons.r--;
    800059de:	0001c717          	auipc	a4,0x1c
    800059e2:	6cf72523          	sw	a5,1738(a4) # 800220a8 <cons+0x98>
    800059e6:	b775                	j	80005992 <consoleread+0xc2>

00000000800059e8 <consputc>:
{
    800059e8:	1141                	addi	sp,sp,-16
    800059ea:	e406                	sd	ra,8(sp)
    800059ec:	e022                	sd	s0,0(sp)
    800059ee:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800059f0:	10000793          	li	a5,256
    800059f4:	00f50a63          	beq	a0,a5,80005a08 <consputc+0x20>
    uartputc_sync(c);
    800059f8:	00000097          	auipc	ra,0x0
    800059fc:	560080e7          	jalr	1376(ra) # 80005f58 <uartputc_sync>
}
    80005a00:	60a2                	ld	ra,8(sp)
    80005a02:	6402                	ld	s0,0(sp)
    80005a04:	0141                	addi	sp,sp,16
    80005a06:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005a08:	4521                	li	a0,8
    80005a0a:	00000097          	auipc	ra,0x0
    80005a0e:	54e080e7          	jalr	1358(ra) # 80005f58 <uartputc_sync>
    80005a12:	02000513          	li	a0,32
    80005a16:	00000097          	auipc	ra,0x0
    80005a1a:	542080e7          	jalr	1346(ra) # 80005f58 <uartputc_sync>
    80005a1e:	4521                	li	a0,8
    80005a20:	00000097          	auipc	ra,0x0
    80005a24:	538080e7          	jalr	1336(ra) # 80005f58 <uartputc_sync>
    80005a28:	bfe1                	j	80005a00 <consputc+0x18>

0000000080005a2a <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a2a:	1101                	addi	sp,sp,-32
    80005a2c:	ec06                	sd	ra,24(sp)
    80005a2e:	e822                	sd	s0,16(sp)
    80005a30:	e426                	sd	s1,8(sp)
    80005a32:	e04a                	sd	s2,0(sp)
    80005a34:	1000                	addi	s0,sp,32
    80005a36:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a38:	0001c517          	auipc	a0,0x1c
    80005a3c:	5d850513          	addi	a0,a0,1496 # 80022010 <cons>
    80005a40:	00000097          	auipc	ra,0x0
    80005a44:	7a4080e7          	jalr	1956(ra) # 800061e4 <acquire>

  switch(c){
    80005a48:	47d5                	li	a5,21
    80005a4a:	0af48663          	beq	s1,a5,80005af6 <consoleintr+0xcc>
    80005a4e:	0297ca63          	blt	a5,s1,80005a82 <consoleintr+0x58>
    80005a52:	47a1                	li	a5,8
    80005a54:	0ef48763          	beq	s1,a5,80005b42 <consoleintr+0x118>
    80005a58:	47c1                	li	a5,16
    80005a5a:	10f49a63          	bne	s1,a5,80005b6e <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a5e:	ffffc097          	auipc	ra,0xffffc
    80005a62:	f7e080e7          	jalr	-130(ra) # 800019dc <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a66:	0001c517          	auipc	a0,0x1c
    80005a6a:	5aa50513          	addi	a0,a0,1450 # 80022010 <cons>
    80005a6e:	00001097          	auipc	ra,0x1
    80005a72:	82a080e7          	jalr	-2006(ra) # 80006298 <release>
}
    80005a76:	60e2                	ld	ra,24(sp)
    80005a78:	6442                	ld	s0,16(sp)
    80005a7a:	64a2                	ld	s1,8(sp)
    80005a7c:	6902                	ld	s2,0(sp)
    80005a7e:	6105                	addi	sp,sp,32
    80005a80:	8082                	ret
  switch(c){
    80005a82:	07f00793          	li	a5,127
    80005a86:	0af48e63          	beq	s1,a5,80005b42 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005a8a:	0001c717          	auipc	a4,0x1c
    80005a8e:	58670713          	addi	a4,a4,1414 # 80022010 <cons>
    80005a92:	0a072783          	lw	a5,160(a4)
    80005a96:	09872703          	lw	a4,152(a4)
    80005a9a:	9f99                	subw	a5,a5,a4
    80005a9c:	07f00713          	li	a4,127
    80005aa0:	fcf763e3          	bltu	a4,a5,80005a66 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005aa4:	47b5                	li	a5,13
    80005aa6:	0cf48763          	beq	s1,a5,80005b74 <consoleintr+0x14a>
      consputc(c);
    80005aaa:	8526                	mv	a0,s1
    80005aac:	00000097          	auipc	ra,0x0
    80005ab0:	f3c080e7          	jalr	-196(ra) # 800059e8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005ab4:	0001c797          	auipc	a5,0x1c
    80005ab8:	55c78793          	addi	a5,a5,1372 # 80022010 <cons>
    80005abc:	0a07a683          	lw	a3,160(a5)
    80005ac0:	0016871b          	addiw	a4,a3,1
    80005ac4:	0007061b          	sext.w	a2,a4
    80005ac8:	0ae7a023          	sw	a4,160(a5)
    80005acc:	07f6f693          	andi	a3,a3,127
    80005ad0:	97b6                	add	a5,a5,a3
    80005ad2:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005ad6:	47a9                	li	a5,10
    80005ad8:	0cf48563          	beq	s1,a5,80005ba2 <consoleintr+0x178>
    80005adc:	4791                	li	a5,4
    80005ade:	0cf48263          	beq	s1,a5,80005ba2 <consoleintr+0x178>
    80005ae2:	0001c797          	auipc	a5,0x1c
    80005ae6:	5c67a783          	lw	a5,1478(a5) # 800220a8 <cons+0x98>
    80005aea:	9f1d                	subw	a4,a4,a5
    80005aec:	08000793          	li	a5,128
    80005af0:	f6f71be3          	bne	a4,a5,80005a66 <consoleintr+0x3c>
    80005af4:	a07d                	j	80005ba2 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005af6:	0001c717          	auipc	a4,0x1c
    80005afa:	51a70713          	addi	a4,a4,1306 # 80022010 <cons>
    80005afe:	0a072783          	lw	a5,160(a4)
    80005b02:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b06:	0001c497          	auipc	s1,0x1c
    80005b0a:	50a48493          	addi	s1,s1,1290 # 80022010 <cons>
    while(cons.e != cons.w &&
    80005b0e:	4929                	li	s2,10
    80005b10:	f4f70be3          	beq	a4,a5,80005a66 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b14:	37fd                	addiw	a5,a5,-1
    80005b16:	07f7f713          	andi	a4,a5,127
    80005b1a:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005b1c:	01874703          	lbu	a4,24(a4)
    80005b20:	f52703e3          	beq	a4,s2,80005a66 <consoleintr+0x3c>
      cons.e--;
    80005b24:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b28:	10000513          	li	a0,256
    80005b2c:	00000097          	auipc	ra,0x0
    80005b30:	ebc080e7          	jalr	-324(ra) # 800059e8 <consputc>
    while(cons.e != cons.w &&
    80005b34:	0a04a783          	lw	a5,160(s1)
    80005b38:	09c4a703          	lw	a4,156(s1)
    80005b3c:	fcf71ce3          	bne	a4,a5,80005b14 <consoleintr+0xea>
    80005b40:	b71d                	j	80005a66 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005b42:	0001c717          	auipc	a4,0x1c
    80005b46:	4ce70713          	addi	a4,a4,1230 # 80022010 <cons>
    80005b4a:	0a072783          	lw	a5,160(a4)
    80005b4e:	09c72703          	lw	a4,156(a4)
    80005b52:	f0f70ae3          	beq	a4,a5,80005a66 <consoleintr+0x3c>
      cons.e--;
    80005b56:	37fd                	addiw	a5,a5,-1
    80005b58:	0001c717          	auipc	a4,0x1c
    80005b5c:	54f72c23          	sw	a5,1368(a4) # 800220b0 <cons+0xa0>
      consputc(BACKSPACE);
    80005b60:	10000513          	li	a0,256
    80005b64:	00000097          	auipc	ra,0x0
    80005b68:	e84080e7          	jalr	-380(ra) # 800059e8 <consputc>
    80005b6c:	bded                	j	80005a66 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b6e:	ee048ce3          	beqz	s1,80005a66 <consoleintr+0x3c>
    80005b72:	bf21                	j	80005a8a <consoleintr+0x60>
      consputc(c);
    80005b74:	4529                	li	a0,10
    80005b76:	00000097          	auipc	ra,0x0
    80005b7a:	e72080e7          	jalr	-398(ra) # 800059e8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b7e:	0001c797          	auipc	a5,0x1c
    80005b82:	49278793          	addi	a5,a5,1170 # 80022010 <cons>
    80005b86:	0a07a703          	lw	a4,160(a5)
    80005b8a:	0017069b          	addiw	a3,a4,1
    80005b8e:	0006861b          	sext.w	a2,a3
    80005b92:	0ad7a023          	sw	a3,160(a5)
    80005b96:	07f77713          	andi	a4,a4,127
    80005b9a:	97ba                	add	a5,a5,a4
    80005b9c:	4729                	li	a4,10
    80005b9e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005ba2:	0001c797          	auipc	a5,0x1c
    80005ba6:	50c7a523          	sw	a2,1290(a5) # 800220ac <cons+0x9c>
        wakeup(&cons.r);
    80005baa:	0001c517          	auipc	a0,0x1c
    80005bae:	4fe50513          	addi	a0,a0,1278 # 800220a8 <cons+0x98>
    80005bb2:	ffffc097          	auipc	ra,0xffffc
    80005bb6:	9da080e7          	jalr	-1574(ra) # 8000158c <wakeup>
    80005bba:	b575                	j	80005a66 <consoleintr+0x3c>

0000000080005bbc <consoleinit>:

void
consoleinit(void)
{
    80005bbc:	1141                	addi	sp,sp,-16
    80005bbe:	e406                	sd	ra,8(sp)
    80005bc0:	e022                	sd	s0,0(sp)
    80005bc2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005bc4:	00003597          	auipc	a1,0x3
    80005bc8:	ccc58593          	addi	a1,a1,-820 # 80008890 <syscalls+0x3f8>
    80005bcc:	0001c517          	auipc	a0,0x1c
    80005bd0:	44450513          	addi	a0,a0,1092 # 80022010 <cons>
    80005bd4:	00000097          	auipc	ra,0x0
    80005bd8:	580080e7          	jalr	1408(ra) # 80006154 <initlock>

  uartinit();
    80005bdc:	00000097          	auipc	ra,0x0
    80005be0:	32c080e7          	jalr	812(ra) # 80005f08 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005be4:	00013797          	auipc	a5,0x13
    80005be8:	15478793          	addi	a5,a5,340 # 80018d38 <devsw>
    80005bec:	00000717          	auipc	a4,0x0
    80005bf0:	ce470713          	addi	a4,a4,-796 # 800058d0 <consoleread>
    80005bf4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005bf6:	00000717          	auipc	a4,0x0
    80005bfa:	c7670713          	addi	a4,a4,-906 # 8000586c <consolewrite>
    80005bfe:	ef98                	sd	a4,24(a5)
}
    80005c00:	60a2                	ld	ra,8(sp)
    80005c02:	6402                	ld	s0,0(sp)
    80005c04:	0141                	addi	sp,sp,16
    80005c06:	8082                	ret

0000000080005c08 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005c08:	7179                	addi	sp,sp,-48
    80005c0a:	f406                	sd	ra,40(sp)
    80005c0c:	f022                	sd	s0,32(sp)
    80005c0e:	ec26                	sd	s1,24(sp)
    80005c10:	e84a                	sd	s2,16(sp)
    80005c12:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005c14:	c219                	beqz	a2,80005c1a <printint+0x12>
    80005c16:	08054763          	bltz	a0,80005ca4 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005c1a:	2501                	sext.w	a0,a0
    80005c1c:	4881                	li	a7,0
    80005c1e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005c22:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005c24:	2581                	sext.w	a1,a1
    80005c26:	00003617          	auipc	a2,0x3
    80005c2a:	c9a60613          	addi	a2,a2,-870 # 800088c0 <digits>
    80005c2e:	883a                	mv	a6,a4
    80005c30:	2705                	addiw	a4,a4,1
    80005c32:	02b577bb          	remuw	a5,a0,a1
    80005c36:	1782                	slli	a5,a5,0x20
    80005c38:	9381                	srli	a5,a5,0x20
    80005c3a:	97b2                	add	a5,a5,a2
    80005c3c:	0007c783          	lbu	a5,0(a5)
    80005c40:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005c44:	0005079b          	sext.w	a5,a0
    80005c48:	02b5553b          	divuw	a0,a0,a1
    80005c4c:	0685                	addi	a3,a3,1
    80005c4e:	feb7f0e3          	bgeu	a5,a1,80005c2e <printint+0x26>

  if(sign)
    80005c52:	00088c63          	beqz	a7,80005c6a <printint+0x62>
    buf[i++] = '-';
    80005c56:	fe070793          	addi	a5,a4,-32
    80005c5a:	00878733          	add	a4,a5,s0
    80005c5e:	02d00793          	li	a5,45
    80005c62:	fef70823          	sb	a5,-16(a4)
    80005c66:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c6a:	02e05763          	blez	a4,80005c98 <printint+0x90>
    80005c6e:	fd040793          	addi	a5,s0,-48
    80005c72:	00e784b3          	add	s1,a5,a4
    80005c76:	fff78913          	addi	s2,a5,-1
    80005c7a:	993a                	add	s2,s2,a4
    80005c7c:	377d                	addiw	a4,a4,-1
    80005c7e:	1702                	slli	a4,a4,0x20
    80005c80:	9301                	srli	a4,a4,0x20
    80005c82:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c86:	fff4c503          	lbu	a0,-1(s1)
    80005c8a:	00000097          	auipc	ra,0x0
    80005c8e:	d5e080e7          	jalr	-674(ra) # 800059e8 <consputc>
  while(--i >= 0)
    80005c92:	14fd                	addi	s1,s1,-1
    80005c94:	ff2499e3          	bne	s1,s2,80005c86 <printint+0x7e>
}
    80005c98:	70a2                	ld	ra,40(sp)
    80005c9a:	7402                	ld	s0,32(sp)
    80005c9c:	64e2                	ld	s1,24(sp)
    80005c9e:	6942                	ld	s2,16(sp)
    80005ca0:	6145                	addi	sp,sp,48
    80005ca2:	8082                	ret
    x = -xx;
    80005ca4:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005ca8:	4885                	li	a7,1
    x = -xx;
    80005caa:	bf95                	j	80005c1e <printint+0x16>

0000000080005cac <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005cac:	1101                	addi	sp,sp,-32
    80005cae:	ec06                	sd	ra,24(sp)
    80005cb0:	e822                	sd	s0,16(sp)
    80005cb2:	e426                	sd	s1,8(sp)
    80005cb4:	1000                	addi	s0,sp,32
    80005cb6:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005cb8:	0001c797          	auipc	a5,0x1c
    80005cbc:	4007ac23          	sw	zero,1048(a5) # 800220d0 <pr+0x18>
  printf("panic: ");
    80005cc0:	00003517          	auipc	a0,0x3
    80005cc4:	bd850513          	addi	a0,a0,-1064 # 80008898 <syscalls+0x400>
    80005cc8:	00000097          	auipc	ra,0x0
    80005ccc:	02e080e7          	jalr	46(ra) # 80005cf6 <printf>
  printf(s);
    80005cd0:	8526                	mv	a0,s1
    80005cd2:	00000097          	auipc	ra,0x0
    80005cd6:	024080e7          	jalr	36(ra) # 80005cf6 <printf>
  printf("\n");
    80005cda:	00002517          	auipc	a0,0x2
    80005cde:	36e50513          	addi	a0,a0,878 # 80008048 <etext+0x48>
    80005ce2:	00000097          	auipc	ra,0x0
    80005ce6:	014080e7          	jalr	20(ra) # 80005cf6 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005cea:	4785                	li	a5,1
    80005cec:	00003717          	auipc	a4,0x3
    80005cf0:	daf72023          	sw	a5,-608(a4) # 80008a8c <panicked>
  for(;;)
    80005cf4:	a001                	j	80005cf4 <panic+0x48>

0000000080005cf6 <printf>:
{
    80005cf6:	7131                	addi	sp,sp,-192
    80005cf8:	fc86                	sd	ra,120(sp)
    80005cfa:	f8a2                	sd	s0,112(sp)
    80005cfc:	f4a6                	sd	s1,104(sp)
    80005cfe:	f0ca                	sd	s2,96(sp)
    80005d00:	ecce                	sd	s3,88(sp)
    80005d02:	e8d2                	sd	s4,80(sp)
    80005d04:	e4d6                	sd	s5,72(sp)
    80005d06:	e0da                	sd	s6,64(sp)
    80005d08:	fc5e                	sd	s7,56(sp)
    80005d0a:	f862                	sd	s8,48(sp)
    80005d0c:	f466                	sd	s9,40(sp)
    80005d0e:	f06a                	sd	s10,32(sp)
    80005d10:	ec6e                	sd	s11,24(sp)
    80005d12:	0100                	addi	s0,sp,128
    80005d14:	8a2a                	mv	s4,a0
    80005d16:	e40c                	sd	a1,8(s0)
    80005d18:	e810                	sd	a2,16(s0)
    80005d1a:	ec14                	sd	a3,24(s0)
    80005d1c:	f018                	sd	a4,32(s0)
    80005d1e:	f41c                	sd	a5,40(s0)
    80005d20:	03043823          	sd	a6,48(s0)
    80005d24:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d28:	0001cd97          	auipc	s11,0x1c
    80005d2c:	3a8dad83          	lw	s11,936(s11) # 800220d0 <pr+0x18>
  if(locking)
    80005d30:	020d9b63          	bnez	s11,80005d66 <printf+0x70>
  if (fmt == 0)
    80005d34:	040a0263          	beqz	s4,80005d78 <printf+0x82>
  va_start(ap, fmt);
    80005d38:	00840793          	addi	a5,s0,8
    80005d3c:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d40:	000a4503          	lbu	a0,0(s4)
    80005d44:	14050f63          	beqz	a0,80005ea2 <printf+0x1ac>
    80005d48:	4981                	li	s3,0
    if(c != '%'){
    80005d4a:	02500a93          	li	s5,37
    switch(c){
    80005d4e:	07000b93          	li	s7,112
  consputc('x');
    80005d52:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d54:	00003b17          	auipc	s6,0x3
    80005d58:	b6cb0b13          	addi	s6,s6,-1172 # 800088c0 <digits>
    switch(c){
    80005d5c:	07300c93          	li	s9,115
    80005d60:	06400c13          	li	s8,100
    80005d64:	a82d                	j	80005d9e <printf+0xa8>
    acquire(&pr.lock);
    80005d66:	0001c517          	auipc	a0,0x1c
    80005d6a:	35250513          	addi	a0,a0,850 # 800220b8 <pr>
    80005d6e:	00000097          	auipc	ra,0x0
    80005d72:	476080e7          	jalr	1142(ra) # 800061e4 <acquire>
    80005d76:	bf7d                	j	80005d34 <printf+0x3e>
    panic("null fmt");
    80005d78:	00003517          	auipc	a0,0x3
    80005d7c:	b3050513          	addi	a0,a0,-1232 # 800088a8 <syscalls+0x410>
    80005d80:	00000097          	auipc	ra,0x0
    80005d84:	f2c080e7          	jalr	-212(ra) # 80005cac <panic>
      consputc(c);
    80005d88:	00000097          	auipc	ra,0x0
    80005d8c:	c60080e7          	jalr	-928(ra) # 800059e8 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d90:	2985                	addiw	s3,s3,1
    80005d92:	013a07b3          	add	a5,s4,s3
    80005d96:	0007c503          	lbu	a0,0(a5)
    80005d9a:	10050463          	beqz	a0,80005ea2 <printf+0x1ac>
    if(c != '%'){
    80005d9e:	ff5515e3          	bne	a0,s5,80005d88 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005da2:	2985                	addiw	s3,s3,1
    80005da4:	013a07b3          	add	a5,s4,s3
    80005da8:	0007c783          	lbu	a5,0(a5)
    80005dac:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005db0:	cbed                	beqz	a5,80005ea2 <printf+0x1ac>
    switch(c){
    80005db2:	05778a63          	beq	a5,s7,80005e06 <printf+0x110>
    80005db6:	02fbf663          	bgeu	s7,a5,80005de2 <printf+0xec>
    80005dba:	09978863          	beq	a5,s9,80005e4a <printf+0x154>
    80005dbe:	07800713          	li	a4,120
    80005dc2:	0ce79563          	bne	a5,a4,80005e8c <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005dc6:	f8843783          	ld	a5,-120(s0)
    80005dca:	00878713          	addi	a4,a5,8
    80005dce:	f8e43423          	sd	a4,-120(s0)
    80005dd2:	4605                	li	a2,1
    80005dd4:	85ea                	mv	a1,s10
    80005dd6:	4388                	lw	a0,0(a5)
    80005dd8:	00000097          	auipc	ra,0x0
    80005ddc:	e30080e7          	jalr	-464(ra) # 80005c08 <printint>
      break;
    80005de0:	bf45                	j	80005d90 <printf+0x9a>
    switch(c){
    80005de2:	09578f63          	beq	a5,s5,80005e80 <printf+0x18a>
    80005de6:	0b879363          	bne	a5,s8,80005e8c <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005dea:	f8843783          	ld	a5,-120(s0)
    80005dee:	00878713          	addi	a4,a5,8
    80005df2:	f8e43423          	sd	a4,-120(s0)
    80005df6:	4605                	li	a2,1
    80005df8:	45a9                	li	a1,10
    80005dfa:	4388                	lw	a0,0(a5)
    80005dfc:	00000097          	auipc	ra,0x0
    80005e00:	e0c080e7          	jalr	-500(ra) # 80005c08 <printint>
      break;
    80005e04:	b771                	j	80005d90 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005e06:	f8843783          	ld	a5,-120(s0)
    80005e0a:	00878713          	addi	a4,a5,8
    80005e0e:	f8e43423          	sd	a4,-120(s0)
    80005e12:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005e16:	03000513          	li	a0,48
    80005e1a:	00000097          	auipc	ra,0x0
    80005e1e:	bce080e7          	jalr	-1074(ra) # 800059e8 <consputc>
  consputc('x');
    80005e22:	07800513          	li	a0,120
    80005e26:	00000097          	auipc	ra,0x0
    80005e2a:	bc2080e7          	jalr	-1086(ra) # 800059e8 <consputc>
    80005e2e:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e30:	03c95793          	srli	a5,s2,0x3c
    80005e34:	97da                	add	a5,a5,s6
    80005e36:	0007c503          	lbu	a0,0(a5)
    80005e3a:	00000097          	auipc	ra,0x0
    80005e3e:	bae080e7          	jalr	-1106(ra) # 800059e8 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e42:	0912                	slli	s2,s2,0x4
    80005e44:	34fd                	addiw	s1,s1,-1
    80005e46:	f4ed                	bnez	s1,80005e30 <printf+0x13a>
    80005e48:	b7a1                	j	80005d90 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e4a:	f8843783          	ld	a5,-120(s0)
    80005e4e:	00878713          	addi	a4,a5,8
    80005e52:	f8e43423          	sd	a4,-120(s0)
    80005e56:	6384                	ld	s1,0(a5)
    80005e58:	cc89                	beqz	s1,80005e72 <printf+0x17c>
      for(; *s; s++)
    80005e5a:	0004c503          	lbu	a0,0(s1)
    80005e5e:	d90d                	beqz	a0,80005d90 <printf+0x9a>
        consputc(*s);
    80005e60:	00000097          	auipc	ra,0x0
    80005e64:	b88080e7          	jalr	-1144(ra) # 800059e8 <consputc>
      for(; *s; s++)
    80005e68:	0485                	addi	s1,s1,1
    80005e6a:	0004c503          	lbu	a0,0(s1)
    80005e6e:	f96d                	bnez	a0,80005e60 <printf+0x16a>
    80005e70:	b705                	j	80005d90 <printf+0x9a>
        s = "(null)";
    80005e72:	00003497          	auipc	s1,0x3
    80005e76:	a2e48493          	addi	s1,s1,-1490 # 800088a0 <syscalls+0x408>
      for(; *s; s++)
    80005e7a:	02800513          	li	a0,40
    80005e7e:	b7cd                	j	80005e60 <printf+0x16a>
      consputc('%');
    80005e80:	8556                	mv	a0,s5
    80005e82:	00000097          	auipc	ra,0x0
    80005e86:	b66080e7          	jalr	-1178(ra) # 800059e8 <consputc>
      break;
    80005e8a:	b719                	j	80005d90 <printf+0x9a>
      consputc('%');
    80005e8c:	8556                	mv	a0,s5
    80005e8e:	00000097          	auipc	ra,0x0
    80005e92:	b5a080e7          	jalr	-1190(ra) # 800059e8 <consputc>
      consputc(c);
    80005e96:	8526                	mv	a0,s1
    80005e98:	00000097          	auipc	ra,0x0
    80005e9c:	b50080e7          	jalr	-1200(ra) # 800059e8 <consputc>
      break;
    80005ea0:	bdc5                	j	80005d90 <printf+0x9a>
  if(locking)
    80005ea2:	020d9163          	bnez	s11,80005ec4 <printf+0x1ce>
}
    80005ea6:	70e6                	ld	ra,120(sp)
    80005ea8:	7446                	ld	s0,112(sp)
    80005eaa:	74a6                	ld	s1,104(sp)
    80005eac:	7906                	ld	s2,96(sp)
    80005eae:	69e6                	ld	s3,88(sp)
    80005eb0:	6a46                	ld	s4,80(sp)
    80005eb2:	6aa6                	ld	s5,72(sp)
    80005eb4:	6b06                	ld	s6,64(sp)
    80005eb6:	7be2                	ld	s7,56(sp)
    80005eb8:	7c42                	ld	s8,48(sp)
    80005eba:	7ca2                	ld	s9,40(sp)
    80005ebc:	7d02                	ld	s10,32(sp)
    80005ebe:	6de2                	ld	s11,24(sp)
    80005ec0:	6129                	addi	sp,sp,192
    80005ec2:	8082                	ret
    release(&pr.lock);
    80005ec4:	0001c517          	auipc	a0,0x1c
    80005ec8:	1f450513          	addi	a0,a0,500 # 800220b8 <pr>
    80005ecc:	00000097          	auipc	ra,0x0
    80005ed0:	3cc080e7          	jalr	972(ra) # 80006298 <release>
}
    80005ed4:	bfc9                	j	80005ea6 <printf+0x1b0>

0000000080005ed6 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005ed6:	1101                	addi	sp,sp,-32
    80005ed8:	ec06                	sd	ra,24(sp)
    80005eda:	e822                	sd	s0,16(sp)
    80005edc:	e426                	sd	s1,8(sp)
    80005ede:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005ee0:	0001c497          	auipc	s1,0x1c
    80005ee4:	1d848493          	addi	s1,s1,472 # 800220b8 <pr>
    80005ee8:	00003597          	auipc	a1,0x3
    80005eec:	9d058593          	addi	a1,a1,-1584 # 800088b8 <syscalls+0x420>
    80005ef0:	8526                	mv	a0,s1
    80005ef2:	00000097          	auipc	ra,0x0
    80005ef6:	262080e7          	jalr	610(ra) # 80006154 <initlock>
  pr.locking = 1;
    80005efa:	4785                	li	a5,1
    80005efc:	cc9c                	sw	a5,24(s1)
}
    80005efe:	60e2                	ld	ra,24(sp)
    80005f00:	6442                	ld	s0,16(sp)
    80005f02:	64a2                	ld	s1,8(sp)
    80005f04:	6105                	addi	sp,sp,32
    80005f06:	8082                	ret

0000000080005f08 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f08:	1141                	addi	sp,sp,-16
    80005f0a:	e406                	sd	ra,8(sp)
    80005f0c:	e022                	sd	s0,0(sp)
    80005f0e:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f10:	100007b7          	lui	a5,0x10000
    80005f14:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f18:	f8000713          	li	a4,-128
    80005f1c:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f20:	470d                	li	a4,3
    80005f22:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f26:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f2a:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f2e:	469d                	li	a3,7
    80005f30:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f34:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f38:	00003597          	auipc	a1,0x3
    80005f3c:	9a058593          	addi	a1,a1,-1632 # 800088d8 <digits+0x18>
    80005f40:	0001c517          	auipc	a0,0x1c
    80005f44:	19850513          	addi	a0,a0,408 # 800220d8 <uart_tx_lock>
    80005f48:	00000097          	auipc	ra,0x0
    80005f4c:	20c080e7          	jalr	524(ra) # 80006154 <initlock>
}
    80005f50:	60a2                	ld	ra,8(sp)
    80005f52:	6402                	ld	s0,0(sp)
    80005f54:	0141                	addi	sp,sp,16
    80005f56:	8082                	ret

0000000080005f58 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f58:	1101                	addi	sp,sp,-32
    80005f5a:	ec06                	sd	ra,24(sp)
    80005f5c:	e822                	sd	s0,16(sp)
    80005f5e:	e426                	sd	s1,8(sp)
    80005f60:	1000                	addi	s0,sp,32
    80005f62:	84aa                	mv	s1,a0
  push_off();
    80005f64:	00000097          	auipc	ra,0x0
    80005f68:	234080e7          	jalr	564(ra) # 80006198 <push_off>

  if(panicked){
    80005f6c:	00003797          	auipc	a5,0x3
    80005f70:	b207a783          	lw	a5,-1248(a5) # 80008a8c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f74:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f78:	c391                	beqz	a5,80005f7c <uartputc_sync+0x24>
    for(;;)
    80005f7a:	a001                	j	80005f7a <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f7c:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f80:	0207f793          	andi	a5,a5,32
    80005f84:	dfe5                	beqz	a5,80005f7c <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f86:	0ff4f513          	zext.b	a0,s1
    80005f8a:	100007b7          	lui	a5,0x10000
    80005f8e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f92:	00000097          	auipc	ra,0x0
    80005f96:	2a6080e7          	jalr	678(ra) # 80006238 <pop_off>
}
    80005f9a:	60e2                	ld	ra,24(sp)
    80005f9c:	6442                	ld	s0,16(sp)
    80005f9e:	64a2                	ld	s1,8(sp)
    80005fa0:	6105                	addi	sp,sp,32
    80005fa2:	8082                	ret

0000000080005fa4 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005fa4:	00003797          	auipc	a5,0x3
    80005fa8:	aec7b783          	ld	a5,-1300(a5) # 80008a90 <uart_tx_r>
    80005fac:	00003717          	auipc	a4,0x3
    80005fb0:	aec73703          	ld	a4,-1300(a4) # 80008a98 <uart_tx_w>
    80005fb4:	06f70a63          	beq	a4,a5,80006028 <uartstart+0x84>
{
    80005fb8:	7139                	addi	sp,sp,-64
    80005fba:	fc06                	sd	ra,56(sp)
    80005fbc:	f822                	sd	s0,48(sp)
    80005fbe:	f426                	sd	s1,40(sp)
    80005fc0:	f04a                	sd	s2,32(sp)
    80005fc2:	ec4e                	sd	s3,24(sp)
    80005fc4:	e852                	sd	s4,16(sp)
    80005fc6:	e456                	sd	s5,8(sp)
    80005fc8:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fca:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fce:	0001ca17          	auipc	s4,0x1c
    80005fd2:	10aa0a13          	addi	s4,s4,266 # 800220d8 <uart_tx_lock>
    uart_tx_r += 1;
    80005fd6:	00003497          	auipc	s1,0x3
    80005fda:	aba48493          	addi	s1,s1,-1350 # 80008a90 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005fde:	00003997          	auipc	s3,0x3
    80005fe2:	aba98993          	addi	s3,s3,-1350 # 80008a98 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fe6:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005fea:	02077713          	andi	a4,a4,32
    80005fee:	c705                	beqz	a4,80006016 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005ff0:	01f7f713          	andi	a4,a5,31
    80005ff4:	9752                	add	a4,a4,s4
    80005ff6:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005ffa:	0785                	addi	a5,a5,1
    80005ffc:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005ffe:	8526                	mv	a0,s1
    80006000:	ffffb097          	auipc	ra,0xffffb
    80006004:	58c080e7          	jalr	1420(ra) # 8000158c <wakeup>
    
    WriteReg(THR, c);
    80006008:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000600c:	609c                	ld	a5,0(s1)
    8000600e:	0009b703          	ld	a4,0(s3)
    80006012:	fcf71ae3          	bne	a4,a5,80005fe6 <uartstart+0x42>
  }
}
    80006016:	70e2                	ld	ra,56(sp)
    80006018:	7442                	ld	s0,48(sp)
    8000601a:	74a2                	ld	s1,40(sp)
    8000601c:	7902                	ld	s2,32(sp)
    8000601e:	69e2                	ld	s3,24(sp)
    80006020:	6a42                	ld	s4,16(sp)
    80006022:	6aa2                	ld	s5,8(sp)
    80006024:	6121                	addi	sp,sp,64
    80006026:	8082                	ret
    80006028:	8082                	ret

000000008000602a <uartputc>:
{
    8000602a:	7179                	addi	sp,sp,-48
    8000602c:	f406                	sd	ra,40(sp)
    8000602e:	f022                	sd	s0,32(sp)
    80006030:	ec26                	sd	s1,24(sp)
    80006032:	e84a                	sd	s2,16(sp)
    80006034:	e44e                	sd	s3,8(sp)
    80006036:	e052                	sd	s4,0(sp)
    80006038:	1800                	addi	s0,sp,48
    8000603a:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000603c:	0001c517          	auipc	a0,0x1c
    80006040:	09c50513          	addi	a0,a0,156 # 800220d8 <uart_tx_lock>
    80006044:	00000097          	auipc	ra,0x0
    80006048:	1a0080e7          	jalr	416(ra) # 800061e4 <acquire>
  if(panicked){
    8000604c:	00003797          	auipc	a5,0x3
    80006050:	a407a783          	lw	a5,-1472(a5) # 80008a8c <panicked>
    80006054:	e7c9                	bnez	a5,800060de <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006056:	00003717          	auipc	a4,0x3
    8000605a:	a4273703          	ld	a4,-1470(a4) # 80008a98 <uart_tx_w>
    8000605e:	00003797          	auipc	a5,0x3
    80006062:	a327b783          	ld	a5,-1486(a5) # 80008a90 <uart_tx_r>
    80006066:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000606a:	0001c997          	auipc	s3,0x1c
    8000606e:	06e98993          	addi	s3,s3,110 # 800220d8 <uart_tx_lock>
    80006072:	00003497          	auipc	s1,0x3
    80006076:	a1e48493          	addi	s1,s1,-1506 # 80008a90 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000607a:	00003917          	auipc	s2,0x3
    8000607e:	a1e90913          	addi	s2,s2,-1506 # 80008a98 <uart_tx_w>
    80006082:	00e79f63          	bne	a5,a4,800060a0 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006086:	85ce                	mv	a1,s3
    80006088:	8526                	mv	a0,s1
    8000608a:	ffffb097          	auipc	ra,0xffffb
    8000608e:	49e080e7          	jalr	1182(ra) # 80001528 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006092:	00093703          	ld	a4,0(s2)
    80006096:	609c                	ld	a5,0(s1)
    80006098:	02078793          	addi	a5,a5,32
    8000609c:	fee785e3          	beq	a5,a4,80006086 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800060a0:	0001c497          	auipc	s1,0x1c
    800060a4:	03848493          	addi	s1,s1,56 # 800220d8 <uart_tx_lock>
    800060a8:	01f77793          	andi	a5,a4,31
    800060ac:	97a6                	add	a5,a5,s1
    800060ae:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800060b2:	0705                	addi	a4,a4,1
    800060b4:	00003797          	auipc	a5,0x3
    800060b8:	9ee7b223          	sd	a4,-1564(a5) # 80008a98 <uart_tx_w>
  uartstart();
    800060bc:	00000097          	auipc	ra,0x0
    800060c0:	ee8080e7          	jalr	-280(ra) # 80005fa4 <uartstart>
  release(&uart_tx_lock);
    800060c4:	8526                	mv	a0,s1
    800060c6:	00000097          	auipc	ra,0x0
    800060ca:	1d2080e7          	jalr	466(ra) # 80006298 <release>
}
    800060ce:	70a2                	ld	ra,40(sp)
    800060d0:	7402                	ld	s0,32(sp)
    800060d2:	64e2                	ld	s1,24(sp)
    800060d4:	6942                	ld	s2,16(sp)
    800060d6:	69a2                	ld	s3,8(sp)
    800060d8:	6a02                	ld	s4,0(sp)
    800060da:	6145                	addi	sp,sp,48
    800060dc:	8082                	ret
    for(;;)
    800060de:	a001                	j	800060de <uartputc+0xb4>

00000000800060e0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060e0:	1141                	addi	sp,sp,-16
    800060e2:	e422                	sd	s0,8(sp)
    800060e4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060e6:	100007b7          	lui	a5,0x10000
    800060ea:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060ee:	8b85                	andi	a5,a5,1
    800060f0:	cb81                	beqz	a5,80006100 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800060f2:	100007b7          	lui	a5,0x10000
    800060f6:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800060fa:	6422                	ld	s0,8(sp)
    800060fc:	0141                	addi	sp,sp,16
    800060fe:	8082                	ret
    return -1;
    80006100:	557d                	li	a0,-1
    80006102:	bfe5                	j	800060fa <uartgetc+0x1a>

0000000080006104 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80006104:	1101                	addi	sp,sp,-32
    80006106:	ec06                	sd	ra,24(sp)
    80006108:	e822                	sd	s0,16(sp)
    8000610a:	e426                	sd	s1,8(sp)
    8000610c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000610e:	54fd                	li	s1,-1
    80006110:	a029                	j	8000611a <uartintr+0x16>
      break;
    consoleintr(c);
    80006112:	00000097          	auipc	ra,0x0
    80006116:	918080e7          	jalr	-1768(ra) # 80005a2a <consoleintr>
    int c = uartgetc();
    8000611a:	00000097          	auipc	ra,0x0
    8000611e:	fc6080e7          	jalr	-58(ra) # 800060e0 <uartgetc>
    if(c == -1)
    80006122:	fe9518e3          	bne	a0,s1,80006112 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006126:	0001c497          	auipc	s1,0x1c
    8000612a:	fb248493          	addi	s1,s1,-78 # 800220d8 <uart_tx_lock>
    8000612e:	8526                	mv	a0,s1
    80006130:	00000097          	auipc	ra,0x0
    80006134:	0b4080e7          	jalr	180(ra) # 800061e4 <acquire>
  uartstart();
    80006138:	00000097          	auipc	ra,0x0
    8000613c:	e6c080e7          	jalr	-404(ra) # 80005fa4 <uartstart>
  release(&uart_tx_lock);
    80006140:	8526                	mv	a0,s1
    80006142:	00000097          	auipc	ra,0x0
    80006146:	156080e7          	jalr	342(ra) # 80006298 <release>
}
    8000614a:	60e2                	ld	ra,24(sp)
    8000614c:	6442                	ld	s0,16(sp)
    8000614e:	64a2                	ld	s1,8(sp)
    80006150:	6105                	addi	sp,sp,32
    80006152:	8082                	ret

0000000080006154 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006154:	1141                	addi	sp,sp,-16
    80006156:	e422                	sd	s0,8(sp)
    80006158:	0800                	addi	s0,sp,16
  lk->name = name;
    8000615a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000615c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006160:	00053823          	sd	zero,16(a0)
}
    80006164:	6422                	ld	s0,8(sp)
    80006166:	0141                	addi	sp,sp,16
    80006168:	8082                	ret

000000008000616a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000616a:	411c                	lw	a5,0(a0)
    8000616c:	e399                	bnez	a5,80006172 <holding+0x8>
    8000616e:	4501                	li	a0,0
  return r;
}
    80006170:	8082                	ret
{
    80006172:	1101                	addi	sp,sp,-32
    80006174:	ec06                	sd	ra,24(sp)
    80006176:	e822                	sd	s0,16(sp)
    80006178:	e426                	sd	s1,8(sp)
    8000617a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000617c:	6904                	ld	s1,16(a0)
    8000617e:	ffffb097          	auipc	ra,0xffffb
    80006182:	cde080e7          	jalr	-802(ra) # 80000e5c <mycpu>
    80006186:	40a48533          	sub	a0,s1,a0
    8000618a:	00153513          	seqz	a0,a0
}
    8000618e:	60e2                	ld	ra,24(sp)
    80006190:	6442                	ld	s0,16(sp)
    80006192:	64a2                	ld	s1,8(sp)
    80006194:	6105                	addi	sp,sp,32
    80006196:	8082                	ret

0000000080006198 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006198:	1101                	addi	sp,sp,-32
    8000619a:	ec06                	sd	ra,24(sp)
    8000619c:	e822                	sd	s0,16(sp)
    8000619e:	e426                	sd	s1,8(sp)
    800061a0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061a2:	100024f3          	csrr	s1,sstatus
    800061a6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800061aa:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061ac:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800061b0:	ffffb097          	auipc	ra,0xffffb
    800061b4:	cac080e7          	jalr	-852(ra) # 80000e5c <mycpu>
    800061b8:	5d3c                	lw	a5,120(a0)
    800061ba:	cf89                	beqz	a5,800061d4 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800061bc:	ffffb097          	auipc	ra,0xffffb
    800061c0:	ca0080e7          	jalr	-864(ra) # 80000e5c <mycpu>
    800061c4:	5d3c                	lw	a5,120(a0)
    800061c6:	2785                	addiw	a5,a5,1
    800061c8:	dd3c                	sw	a5,120(a0)
}
    800061ca:	60e2                	ld	ra,24(sp)
    800061cc:	6442                	ld	s0,16(sp)
    800061ce:	64a2                	ld	s1,8(sp)
    800061d0:	6105                	addi	sp,sp,32
    800061d2:	8082                	ret
    mycpu()->intena = old;
    800061d4:	ffffb097          	auipc	ra,0xffffb
    800061d8:	c88080e7          	jalr	-888(ra) # 80000e5c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061dc:	8085                	srli	s1,s1,0x1
    800061de:	8885                	andi	s1,s1,1
    800061e0:	dd64                	sw	s1,124(a0)
    800061e2:	bfe9                	j	800061bc <push_off+0x24>

00000000800061e4 <acquire>:
{
    800061e4:	1101                	addi	sp,sp,-32
    800061e6:	ec06                	sd	ra,24(sp)
    800061e8:	e822                	sd	s0,16(sp)
    800061ea:	e426                	sd	s1,8(sp)
    800061ec:	1000                	addi	s0,sp,32
    800061ee:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061f0:	00000097          	auipc	ra,0x0
    800061f4:	fa8080e7          	jalr	-88(ra) # 80006198 <push_off>
  if(holding(lk))
    800061f8:	8526                	mv	a0,s1
    800061fa:	00000097          	auipc	ra,0x0
    800061fe:	f70080e7          	jalr	-144(ra) # 8000616a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006202:	4705                	li	a4,1
  if(holding(lk))
    80006204:	e115                	bnez	a0,80006228 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006206:	87ba                	mv	a5,a4
    80006208:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000620c:	2781                	sext.w	a5,a5
    8000620e:	ffe5                	bnez	a5,80006206 <acquire+0x22>
  __sync_synchronize();
    80006210:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006214:	ffffb097          	auipc	ra,0xffffb
    80006218:	c48080e7          	jalr	-952(ra) # 80000e5c <mycpu>
    8000621c:	e888                	sd	a0,16(s1)
}
    8000621e:	60e2                	ld	ra,24(sp)
    80006220:	6442                	ld	s0,16(sp)
    80006222:	64a2                	ld	s1,8(sp)
    80006224:	6105                	addi	sp,sp,32
    80006226:	8082                	ret
    panic("acquire");
    80006228:	00002517          	auipc	a0,0x2
    8000622c:	6b850513          	addi	a0,a0,1720 # 800088e0 <digits+0x20>
    80006230:	00000097          	auipc	ra,0x0
    80006234:	a7c080e7          	jalr	-1412(ra) # 80005cac <panic>

0000000080006238 <pop_off>:

void
pop_off(void)
{
    80006238:	1141                	addi	sp,sp,-16
    8000623a:	e406                	sd	ra,8(sp)
    8000623c:	e022                	sd	s0,0(sp)
    8000623e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006240:	ffffb097          	auipc	ra,0xffffb
    80006244:	c1c080e7          	jalr	-996(ra) # 80000e5c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006248:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000624c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000624e:	e78d                	bnez	a5,80006278 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006250:	5d3c                	lw	a5,120(a0)
    80006252:	02f05b63          	blez	a5,80006288 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006256:	37fd                	addiw	a5,a5,-1
    80006258:	0007871b          	sext.w	a4,a5
    8000625c:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000625e:	eb09                	bnez	a4,80006270 <pop_off+0x38>
    80006260:	5d7c                	lw	a5,124(a0)
    80006262:	c799                	beqz	a5,80006270 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006264:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006268:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000626c:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006270:	60a2                	ld	ra,8(sp)
    80006272:	6402                	ld	s0,0(sp)
    80006274:	0141                	addi	sp,sp,16
    80006276:	8082                	ret
    panic("pop_off - interruptible");
    80006278:	00002517          	auipc	a0,0x2
    8000627c:	67050513          	addi	a0,a0,1648 # 800088e8 <digits+0x28>
    80006280:	00000097          	auipc	ra,0x0
    80006284:	a2c080e7          	jalr	-1492(ra) # 80005cac <panic>
    panic("pop_off");
    80006288:	00002517          	auipc	a0,0x2
    8000628c:	67850513          	addi	a0,a0,1656 # 80008900 <digits+0x40>
    80006290:	00000097          	auipc	ra,0x0
    80006294:	a1c080e7          	jalr	-1508(ra) # 80005cac <panic>

0000000080006298 <release>:
{
    80006298:	1101                	addi	sp,sp,-32
    8000629a:	ec06                	sd	ra,24(sp)
    8000629c:	e822                	sd	s0,16(sp)
    8000629e:	e426                	sd	s1,8(sp)
    800062a0:	1000                	addi	s0,sp,32
    800062a2:	84aa                	mv	s1,a0
  if(!holding(lk))
    800062a4:	00000097          	auipc	ra,0x0
    800062a8:	ec6080e7          	jalr	-314(ra) # 8000616a <holding>
    800062ac:	c115                	beqz	a0,800062d0 <release+0x38>
  lk->cpu = 0;
    800062ae:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800062b2:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800062b6:	0f50000f          	fence	iorw,ow
    800062ba:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800062be:	00000097          	auipc	ra,0x0
    800062c2:	f7a080e7          	jalr	-134(ra) # 80006238 <pop_off>
}
    800062c6:	60e2                	ld	ra,24(sp)
    800062c8:	6442                	ld	s0,16(sp)
    800062ca:	64a2                	ld	s1,8(sp)
    800062cc:	6105                	addi	sp,sp,32
    800062ce:	8082                	ret
    panic("release");
    800062d0:	00002517          	auipc	a0,0x2
    800062d4:	63850513          	addi	a0,a0,1592 # 80008908 <digits+0x48>
    800062d8:	00000097          	auipc	ra,0x0
    800062dc:	9d4080e7          	jalr	-1580(ra) # 80005cac <panic>
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
