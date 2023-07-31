
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
    80000016:	1a3050ef          	jal	ra,800059b8 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	0001d797          	auipc	a5,0x1d
    80000034:	14078793          	addi	a5,a5,320 # 8001d170 <end>
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
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	8a090913          	addi	s2,s2,-1888 # 800088f0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	34a080e7          	jalr	842(ra) # 800063a4 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	3ea080e7          	jalr	1002(ra) # 80006458 <release>
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
    8000008e:	de2080e7          	jalr	-542(ra) # 80005e6c <panic>

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
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
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
    800000f2:	80250513          	addi	a0,a0,-2046 # 800088f0 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	21e080e7          	jalr	542(ra) # 80006314 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	0001d517          	auipc	a0,0x1d
    80000106:	06e50513          	addi	a0,a0,110 # 8001d170 <end>
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
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00008497          	auipc	s1,0x8
    80000128:	7cc48493          	addi	s1,s1,1996 # 800088f0 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	276080e7          	jalr	630(ra) # 800063a4 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00008517          	auipc	a0,0x8
    80000140:	7b450513          	addi	a0,a0,1972 # 800088f0 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	312080e7          	jalr	786(ra) # 80006458 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00008517          	auipc	a0,0x8
    8000016c:	78850513          	addi	a0,a0,1928 # 800088f0 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	2e8080e7          	jalr	744(ra) # 80006458 <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffe1e91>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	fef59ae3          	bne	a1,a5,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fee79ae3          	bne	a5,a4,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a809                	j	8000027c <strncmp+0x32>
    8000026c:	4501                	li	a0,0
    8000026e:	a039                	j	8000027c <strncmp+0x32>
  if(n == 0)
    80000270:	ca09                	beqz	a2,80000282 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000272:	00054503          	lbu	a0,0(a0)
    80000276:	0005c783          	lbu	a5,0(a1)
    8000027a:	9d1d                	subw	a0,a0,a5
}
    8000027c:	6422                	ld	s0,8(sp)
    8000027e:	0141                	addi	sp,sp,16
    80000280:	8082                	ret
    return 0;
    80000282:	4501                	li	a0,0
    80000284:	bfe5                	j	8000027c <strncmp+0x32>

0000000080000286 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028c:	872a                	mv	a4,a0
    8000028e:	8832                	mv	a6,a2
    80000290:	367d                	addiw	a2,a2,-1
    80000292:	01005963          	blez	a6,800002a4 <strncpy+0x1e>
    80000296:	0705                	addi	a4,a4,1
    80000298:	0005c783          	lbu	a5,0(a1)
    8000029c:	fef70fa3          	sb	a5,-1(a4)
    800002a0:	0585                	addi	a1,a1,1
    800002a2:	f7f5                	bnez	a5,8000028e <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a4:	86ba                	mv	a3,a4
    800002a6:	00c05c63          	blez	a2,800002be <strncpy+0x38>
    *s++ = 0;
    800002aa:	0685                	addi	a3,a3,1
    800002ac:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b0:	40d707bb          	subw	a5,a4,a3
    800002b4:	37fd                	addiw	a5,a5,-1
    800002b6:	010787bb          	addw	a5,a5,a6
    800002ba:	fef048e3          	bgtz	a5,800002aa <strncpy+0x24>
  return os;
}
    800002be:	6422                	ld	s0,8(sp)
    800002c0:	0141                	addi	sp,sp,16
    800002c2:	8082                	ret

00000000800002c4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c4:	1141                	addi	sp,sp,-16
    800002c6:	e422                	sd	s0,8(sp)
    800002c8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002ca:	02c05363          	blez	a2,800002f0 <safestrcpy+0x2c>
    800002ce:	fff6069b          	addiw	a3,a2,-1
    800002d2:	1682                	slli	a3,a3,0x20
    800002d4:	9281                	srli	a3,a3,0x20
    800002d6:	96ae                	add	a3,a3,a1
    800002d8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002da:	00d58963          	beq	a1,a3,800002ec <safestrcpy+0x28>
    800002de:	0585                	addi	a1,a1,1
    800002e0:	0785                	addi	a5,a5,1
    800002e2:	fff5c703          	lbu	a4,-1(a1)
    800002e6:	fee78fa3          	sb	a4,-1(a5)
    800002ea:	fb65                	bnez	a4,800002da <safestrcpy+0x16>
    ;
  *s = 0;
    800002ec:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f0:	6422                	ld	s0,8(sp)
    800002f2:	0141                	addi	sp,sp,16
    800002f4:	8082                	ret

00000000800002f6 <strlen>:

int
strlen(const char *s)
{
    800002f6:	1141                	addi	sp,sp,-16
    800002f8:	e422                	sd	s0,8(sp)
    800002fa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fc:	00054783          	lbu	a5,0(a0)
    80000300:	cf91                	beqz	a5,8000031c <strlen+0x26>
    80000302:	0505                	addi	a0,a0,1
    80000304:	87aa                	mv	a5,a0
    80000306:	4685                	li	a3,1
    80000308:	9e89                	subw	a3,a3,a0
    8000030a:	00f6853b          	addw	a0,a3,a5
    8000030e:	0785                	addi	a5,a5,1
    80000310:	fff7c703          	lbu	a4,-1(a5)
    80000314:	fb7d                	bnez	a4,8000030a <strlen+0x14>
    ;
  return n;
}
    80000316:	6422                	ld	s0,8(sp)
    80000318:	0141                	addi	sp,sp,16
    8000031a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031c:	4501                	li	a0,0
    8000031e:	bfe5                	j	80000316 <strlen+0x20>

0000000080000320 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000320:	1141                	addi	sp,sp,-16
    80000322:	e406                	sd	ra,8(sp)
    80000324:	e022                	sd	s0,0(sp)
    80000326:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000328:	00001097          	auipc	ra,0x1
    8000032c:	b00080e7          	jalr	-1280(ra) # 80000e28 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000330:	00008717          	auipc	a4,0x8
    80000334:	59070713          	addi	a4,a4,1424 # 800088c0 <started>
  if(cpuid() == 0){
    80000338:	c139                	beqz	a0,8000037e <main+0x5e>
    while(started == 0)
    8000033a:	431c                	lw	a5,0(a4)
    8000033c:	2781                	sext.w	a5,a5
    8000033e:	dff5                	beqz	a5,8000033a <main+0x1a>
      ;
    __sync_synchronize();
    80000340:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000344:	00001097          	auipc	ra,0x1
    80000348:	ae4080e7          	jalr	-1308(ra) # 80000e28 <cpuid>
    8000034c:	85aa                	mv	a1,a0
    8000034e:	00008517          	auipc	a0,0x8
    80000352:	cea50513          	addi	a0,a0,-790 # 80008038 <etext+0x38>
    80000356:	00006097          	auipc	ra,0x6
    8000035a:	b60080e7          	jalr	-1184(ra) # 80005eb6 <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00001097          	auipc	ra,0x1
    8000036a:	78c080e7          	jalr	1932(ra) # 80001af2 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	002080e7          	jalr	2(ra) # 80005370 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	fd4080e7          	jalr	-44(ra) # 8000134a <scheduler>
    consoleinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	9fe080e7          	jalr	-1538(ra) # 80005d7c <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	d10080e7          	jalr	-752(ra) # 80006096 <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	b20080e7          	jalr	-1248(ra) # 80005eb6 <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	b10080e7          	jalr	-1264(ra) # 80005eb6 <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	b00080e7          	jalr	-1280(ra) # 80005eb6 <printf>
    kinit();         // physical page allocator
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	d20080e7          	jalr	-736(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	326080e7          	jalr	806(ra) # 800006ec <kvminit>
    kvminithart();   // turn on paging
    800003ce:	00000097          	auipc	ra,0x0
    800003d2:	068080e7          	jalr	104(ra) # 80000436 <kvminithart>
    procinit();      // process table
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	99e080e7          	jalr	-1634(ra) # 80000d74 <procinit>
    trapinit();      // trap vectors
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	6ec080e7          	jalr	1772(ra) # 80001aca <trapinit>
    trapinithart();  // install kernel trap vector
    800003e6:	00001097          	auipc	ra,0x1
    800003ea:	70c080e7          	jalr	1804(ra) # 80001af2 <trapinithart>
    plicinit();      // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	f6c080e7          	jalr	-148(ra) # 8000535a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	f7a080e7          	jalr	-134(ra) # 80005370 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	e3e080e7          	jalr	-450(ra) # 8000223c <binit>
    iinit();         // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	5c0080e7          	jalr	1472(ra) # 800029c6 <iinit>
    fileinit();      // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	60e080e7          	jalr	1550(ra) # 80003a1c <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	062080e7          	jalr	98(ra) # 80005478 <virtio_disk_init>
    userinit();      // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	d0e080e7          	jalr	-754(ra) # 8000112c <userinit>
    __sync_synchronize();
    80000426:	0ff0000f          	fence
    started = 1;
    8000042a:	4785                	li	a5,1
    8000042c:	00008717          	auipc	a4,0x8
    80000430:	48f72a23          	sw	a5,1172(a4) # 800088c0 <started>
    80000434:	b789                	j	80000376 <main+0x56>

0000000080000436 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000436:	1141                	addi	sp,sp,-16
    80000438:	e422                	sd	s0,8(sp)
    8000043a:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000043c:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000440:	00008797          	auipc	a5,0x8
    80000444:	4887b783          	ld	a5,1160(a5) # 800088c8 <kernel_pagetable>
    80000448:	83b1                	srli	a5,a5,0xc
    8000044a:	577d                	li	a4,-1
    8000044c:	177e                	slli	a4,a4,0x3f
    8000044e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000450:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000454:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000458:	6422                	ld	s0,8(sp)
    8000045a:	0141                	addi	sp,sp,16
    8000045c:	8082                	ret

000000008000045e <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045e:	7139                	addi	sp,sp,-64
    80000460:	fc06                	sd	ra,56(sp)
    80000462:	f822                	sd	s0,48(sp)
    80000464:	f426                	sd	s1,40(sp)
    80000466:	f04a                	sd	s2,32(sp)
    80000468:	ec4e                	sd	s3,24(sp)
    8000046a:	e852                	sd	s4,16(sp)
    8000046c:	e456                	sd	s5,8(sp)
    8000046e:	e05a                	sd	s6,0(sp)
    80000470:	0080                	addi	s0,sp,64
    80000472:	84aa                	mv	s1,a0
    80000474:	89ae                	mv	s3,a1
    80000476:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000478:	57fd                	li	a5,-1
    8000047a:	83e9                	srli	a5,a5,0x1a
    8000047c:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047e:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000480:	04b7f263          	bgeu	a5,a1,800004c4 <walk+0x66>
    panic("walk");
    80000484:	00008517          	auipc	a0,0x8
    80000488:	bcc50513          	addi	a0,a0,-1076 # 80008050 <etext+0x50>
    8000048c:	00006097          	auipc	ra,0x6
    80000490:	9e0080e7          	jalr	-1568(ra) # 80005e6c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000494:	060a8663          	beqz	s5,80000500 <walk+0xa2>
    80000498:	00000097          	auipc	ra,0x0
    8000049c:	c82080e7          	jalr	-894(ra) # 8000011a <kalloc>
    800004a0:	84aa                	mv	s1,a0
    800004a2:	c529                	beqz	a0,800004ec <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a4:	6605                	lui	a2,0x1
    800004a6:	4581                	li	a1,0
    800004a8:	00000097          	auipc	ra,0x0
    800004ac:	cd2080e7          	jalr	-814(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b0:	00c4d793          	srli	a5,s1,0xc
    800004b4:	07aa                	slli	a5,a5,0xa
    800004b6:	0017e793          	ori	a5,a5,1
    800004ba:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004be:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffe1e87>
    800004c0:	036a0063          	beq	s4,s6,800004e0 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c4:	0149d933          	srl	s2,s3,s4
    800004c8:	1ff97913          	andi	s2,s2,511
    800004cc:	090e                	slli	s2,s2,0x3
    800004ce:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d0:	00093483          	ld	s1,0(s2)
    800004d4:	0014f793          	andi	a5,s1,1
    800004d8:	dfd5                	beqz	a5,80000494 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004da:	80a9                	srli	s1,s1,0xa
    800004dc:	04b2                	slli	s1,s1,0xc
    800004de:	b7c5                	j	800004be <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e0:	00c9d513          	srli	a0,s3,0xc
    800004e4:	1ff57513          	andi	a0,a0,511
    800004e8:	050e                	slli	a0,a0,0x3
    800004ea:	9526                	add	a0,a0,s1
}
    800004ec:	70e2                	ld	ra,56(sp)
    800004ee:	7442                	ld	s0,48(sp)
    800004f0:	74a2                	ld	s1,40(sp)
    800004f2:	7902                	ld	s2,32(sp)
    800004f4:	69e2                	ld	s3,24(sp)
    800004f6:	6a42                	ld	s4,16(sp)
    800004f8:	6aa2                	ld	s5,8(sp)
    800004fa:	6b02                	ld	s6,0(sp)
    800004fc:	6121                	addi	sp,sp,64
    800004fe:	8082                	ret
        return 0;
    80000500:	4501                	li	a0,0
    80000502:	b7ed                	j	800004ec <walk+0x8e>

0000000080000504 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000504:	57fd                	li	a5,-1
    80000506:	83e9                	srli	a5,a5,0x1a
    80000508:	00b7f463          	bgeu	a5,a1,80000510 <walkaddr+0xc>
    return 0;
    8000050c:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050e:	8082                	ret
{
    80000510:	1141                	addi	sp,sp,-16
    80000512:	e406                	sd	ra,8(sp)
    80000514:	e022                	sd	s0,0(sp)
    80000516:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000518:	4601                	li	a2,0
    8000051a:	00000097          	auipc	ra,0x0
    8000051e:	f44080e7          	jalr	-188(ra) # 8000045e <walk>
  if(pte == 0)
    80000522:	c105                	beqz	a0,80000542 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000524:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000526:	0117f693          	andi	a3,a5,17
    8000052a:	4745                	li	a4,17
    return 0;
    8000052c:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052e:	00e68663          	beq	a3,a4,8000053a <walkaddr+0x36>
}
    80000532:	60a2                	ld	ra,8(sp)
    80000534:	6402                	ld	s0,0(sp)
    80000536:	0141                	addi	sp,sp,16
    80000538:	8082                	ret
  pa = PTE2PA(*pte);
    8000053a:	83a9                	srli	a5,a5,0xa
    8000053c:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000540:	bfcd                	j	80000532 <walkaddr+0x2e>
    return 0;
    80000542:	4501                	li	a0,0
    80000544:	b7fd                	j	80000532 <walkaddr+0x2e>

0000000080000546 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000546:	715d                	addi	sp,sp,-80
    80000548:	e486                	sd	ra,72(sp)
    8000054a:	e0a2                	sd	s0,64(sp)
    8000054c:	fc26                	sd	s1,56(sp)
    8000054e:	f84a                	sd	s2,48(sp)
    80000550:	f44e                	sd	s3,40(sp)
    80000552:	f052                	sd	s4,32(sp)
    80000554:	ec56                	sd	s5,24(sp)
    80000556:	e85a                	sd	s6,16(sp)
    80000558:	e45e                	sd	s7,8(sp)
    8000055a:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055c:	c639                	beqz	a2,800005aa <mappages+0x64>
    8000055e:	8aaa                	mv	s5,a0
    80000560:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000562:	777d                	lui	a4,0xfffff
    80000564:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000568:	fff58993          	addi	s3,a1,-1
    8000056c:	99b2                	add	s3,s3,a2
    8000056e:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000572:	893e                	mv	s2,a5
    80000574:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000578:	6b85                	lui	s7,0x1
    8000057a:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057e:	4605                	li	a2,1
    80000580:	85ca                	mv	a1,s2
    80000582:	8556                	mv	a0,s5
    80000584:	00000097          	auipc	ra,0x0
    80000588:	eda080e7          	jalr	-294(ra) # 8000045e <walk>
    8000058c:	cd1d                	beqz	a0,800005ca <mappages+0x84>
    if(*pte & PTE_V)
    8000058e:	611c                	ld	a5,0(a0)
    80000590:	8b85                	andi	a5,a5,1
    80000592:	e785                	bnez	a5,800005ba <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000594:	80b1                	srli	s1,s1,0xc
    80000596:	04aa                	slli	s1,s1,0xa
    80000598:	0164e4b3          	or	s1,s1,s6
    8000059c:	0014e493          	ori	s1,s1,1
    800005a0:	e104                	sd	s1,0(a0)
    if(a == last)
    800005a2:	05390063          	beq	s2,s3,800005e2 <mappages+0x9c>
    a += PGSIZE;
    800005a6:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a8:	bfc9                	j	8000057a <mappages+0x34>
    panic("mappages: size");
    800005aa:	00008517          	auipc	a0,0x8
    800005ae:	aae50513          	addi	a0,a0,-1362 # 80008058 <etext+0x58>
    800005b2:	00006097          	auipc	ra,0x6
    800005b6:	8ba080e7          	jalr	-1862(ra) # 80005e6c <panic>
      panic("mappages: remap");
    800005ba:	00008517          	auipc	a0,0x8
    800005be:	aae50513          	addi	a0,a0,-1362 # 80008068 <etext+0x68>
    800005c2:	00006097          	auipc	ra,0x6
    800005c6:	8aa080e7          	jalr	-1878(ra) # 80005e6c <panic>
      return -1;
    800005ca:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005cc:	60a6                	ld	ra,72(sp)
    800005ce:	6406                	ld	s0,64(sp)
    800005d0:	74e2                	ld	s1,56(sp)
    800005d2:	7942                	ld	s2,48(sp)
    800005d4:	79a2                	ld	s3,40(sp)
    800005d6:	7a02                	ld	s4,32(sp)
    800005d8:	6ae2                	ld	s5,24(sp)
    800005da:	6b42                	ld	s6,16(sp)
    800005dc:	6ba2                	ld	s7,8(sp)
    800005de:	6161                	addi	sp,sp,80
    800005e0:	8082                	ret
  return 0;
    800005e2:	4501                	li	a0,0
    800005e4:	b7e5                	j	800005cc <mappages+0x86>

00000000800005e6 <kvmmap>:
{
    800005e6:	1141                	addi	sp,sp,-16
    800005e8:	e406                	sd	ra,8(sp)
    800005ea:	e022                	sd	s0,0(sp)
    800005ec:	0800                	addi	s0,sp,16
    800005ee:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f0:	86b2                	mv	a3,a2
    800005f2:	863e                	mv	a2,a5
    800005f4:	00000097          	auipc	ra,0x0
    800005f8:	f52080e7          	jalr	-174(ra) # 80000546 <mappages>
    800005fc:	e509                	bnez	a0,80000606 <kvmmap+0x20>
}
    800005fe:	60a2                	ld	ra,8(sp)
    80000600:	6402                	ld	s0,0(sp)
    80000602:	0141                	addi	sp,sp,16
    80000604:	8082                	ret
    panic("kvmmap");
    80000606:	00008517          	auipc	a0,0x8
    8000060a:	a7250513          	addi	a0,a0,-1422 # 80008078 <etext+0x78>
    8000060e:	00006097          	auipc	ra,0x6
    80000612:	85e080e7          	jalr	-1954(ra) # 80005e6c <panic>

0000000080000616 <kvmmake>:
{
    80000616:	1101                	addi	sp,sp,-32
    80000618:	ec06                	sd	ra,24(sp)
    8000061a:	e822                	sd	s0,16(sp)
    8000061c:	e426                	sd	s1,8(sp)
    8000061e:	e04a                	sd	s2,0(sp)
    80000620:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000622:	00000097          	auipc	ra,0x0
    80000626:	af8080e7          	jalr	-1288(ra) # 8000011a <kalloc>
    8000062a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062c:	6605                	lui	a2,0x1
    8000062e:	4581                	li	a1,0
    80000630:	00000097          	auipc	ra,0x0
    80000634:	b4a080e7          	jalr	-1206(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000638:	4719                	li	a4,6
    8000063a:	6685                	lui	a3,0x1
    8000063c:	10000637          	lui	a2,0x10000
    80000640:	100005b7          	lui	a1,0x10000
    80000644:	8526                	mv	a0,s1
    80000646:	00000097          	auipc	ra,0x0
    8000064a:	fa0080e7          	jalr	-96(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064e:	4719                	li	a4,6
    80000650:	6685                	lui	a3,0x1
    80000652:	10001637          	lui	a2,0x10001
    80000656:	100015b7          	lui	a1,0x10001
    8000065a:	8526                	mv	a0,s1
    8000065c:	00000097          	auipc	ra,0x0
    80000660:	f8a080e7          	jalr	-118(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000664:	4719                	li	a4,6
    80000666:	004006b7          	lui	a3,0x400
    8000066a:	0c000637          	lui	a2,0xc000
    8000066e:	0c0005b7          	lui	a1,0xc000
    80000672:	8526                	mv	a0,s1
    80000674:	00000097          	auipc	ra,0x0
    80000678:	f72080e7          	jalr	-142(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067c:	00008917          	auipc	s2,0x8
    80000680:	98490913          	addi	s2,s2,-1660 # 80008000 <etext>
    80000684:	4729                	li	a4,10
    80000686:	80008697          	auipc	a3,0x80008
    8000068a:	97a68693          	addi	a3,a3,-1670 # 8000 <_entry-0x7fff8000>
    8000068e:	4605                	li	a2,1
    80000690:	067e                	slli	a2,a2,0x1f
    80000692:	85b2                	mv	a1,a2
    80000694:	8526                	mv	a0,s1
    80000696:	00000097          	auipc	ra,0x0
    8000069a:	f50080e7          	jalr	-176(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000069e:	4719                	li	a4,6
    800006a0:	46c5                	li	a3,17
    800006a2:	06ee                	slli	a3,a3,0x1b
    800006a4:	412686b3          	sub	a3,a3,s2
    800006a8:	864a                	mv	a2,s2
    800006aa:	85ca                	mv	a1,s2
    800006ac:	8526                	mv	a0,s1
    800006ae:	00000097          	auipc	ra,0x0
    800006b2:	f38080e7          	jalr	-200(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b6:	4729                	li	a4,10
    800006b8:	6685                	lui	a3,0x1
    800006ba:	00007617          	auipc	a2,0x7
    800006be:	94660613          	addi	a2,a2,-1722 # 80007000 <_trampoline>
    800006c2:	040005b7          	lui	a1,0x4000
    800006c6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006c8:	05b2                	slli	a1,a1,0xc
    800006ca:	8526                	mv	a0,s1
    800006cc:	00000097          	auipc	ra,0x0
    800006d0:	f1a080e7          	jalr	-230(ra) # 800005e6 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d4:	8526                	mv	a0,s1
    800006d6:	00000097          	auipc	ra,0x0
    800006da:	608080e7          	jalr	1544(ra) # 80000cde <proc_mapstacks>
}
    800006de:	8526                	mv	a0,s1
    800006e0:	60e2                	ld	ra,24(sp)
    800006e2:	6442                	ld	s0,16(sp)
    800006e4:	64a2                	ld	s1,8(sp)
    800006e6:	6902                	ld	s2,0(sp)
    800006e8:	6105                	addi	sp,sp,32
    800006ea:	8082                	ret

00000000800006ec <kvminit>:
{
    800006ec:	1141                	addi	sp,sp,-16
    800006ee:	e406                	sd	ra,8(sp)
    800006f0:	e022                	sd	s0,0(sp)
    800006f2:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f4:	00000097          	auipc	ra,0x0
    800006f8:	f22080e7          	jalr	-222(ra) # 80000616 <kvmmake>
    800006fc:	00008797          	auipc	a5,0x8
    80000700:	1ca7b623          	sd	a0,460(a5) # 800088c8 <kernel_pagetable>
}
    80000704:	60a2                	ld	ra,8(sp)
    80000706:	6402                	ld	s0,0(sp)
    80000708:	0141                	addi	sp,sp,16
    8000070a:	8082                	ret

000000008000070c <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070c:	715d                	addi	sp,sp,-80
    8000070e:	e486                	sd	ra,72(sp)
    80000710:	e0a2                	sd	s0,64(sp)
    80000712:	fc26                	sd	s1,56(sp)
    80000714:	f84a                	sd	s2,48(sp)
    80000716:	f44e                	sd	s3,40(sp)
    80000718:	f052                	sd	s4,32(sp)
    8000071a:	ec56                	sd	s5,24(sp)
    8000071c:	e85a                	sd	s6,16(sp)
    8000071e:	e45e                	sd	s7,8(sp)
    80000720:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000722:	03459793          	slli	a5,a1,0x34
    80000726:	e795                	bnez	a5,80000752 <uvmunmap+0x46>
    80000728:	8a2a                	mv	s4,a0
    8000072a:	892e                	mv	s2,a1
    8000072c:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000072e:	0632                	slli	a2,a2,0xc
    80000730:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000734:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000736:	6b05                	lui	s6,0x1
    80000738:	0735e263          	bltu	a1,s3,8000079c <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073c:	60a6                	ld	ra,72(sp)
    8000073e:	6406                	ld	s0,64(sp)
    80000740:	74e2                	ld	s1,56(sp)
    80000742:	7942                	ld	s2,48(sp)
    80000744:	79a2                	ld	s3,40(sp)
    80000746:	7a02                	ld	s4,32(sp)
    80000748:	6ae2                	ld	s5,24(sp)
    8000074a:	6b42                	ld	s6,16(sp)
    8000074c:	6ba2                	ld	s7,8(sp)
    8000074e:	6161                	addi	sp,sp,80
    80000750:	8082                	ret
    panic("uvmunmap: not aligned");
    80000752:	00008517          	auipc	a0,0x8
    80000756:	92e50513          	addi	a0,a0,-1746 # 80008080 <etext+0x80>
    8000075a:	00005097          	auipc	ra,0x5
    8000075e:	712080e7          	jalr	1810(ra) # 80005e6c <panic>
      panic("uvmunmap: walk");
    80000762:	00008517          	auipc	a0,0x8
    80000766:	93650513          	addi	a0,a0,-1738 # 80008098 <etext+0x98>
    8000076a:	00005097          	auipc	ra,0x5
    8000076e:	702080e7          	jalr	1794(ra) # 80005e6c <panic>
      panic("uvmunmap: not mapped");
    80000772:	00008517          	auipc	a0,0x8
    80000776:	93650513          	addi	a0,a0,-1738 # 800080a8 <etext+0xa8>
    8000077a:	00005097          	auipc	ra,0x5
    8000077e:	6f2080e7          	jalr	1778(ra) # 80005e6c <panic>
      panic("uvmunmap: not a leaf");
    80000782:	00008517          	auipc	a0,0x8
    80000786:	93e50513          	addi	a0,a0,-1730 # 800080c0 <etext+0xc0>
    8000078a:	00005097          	auipc	ra,0x5
    8000078e:	6e2080e7          	jalr	1762(ra) # 80005e6c <panic>
    *pte = 0;
    80000792:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000796:	995a                	add	s2,s2,s6
    80000798:	fb3972e3          	bgeu	s2,s3,8000073c <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000079c:	4601                	li	a2,0
    8000079e:	85ca                	mv	a1,s2
    800007a0:	8552                	mv	a0,s4
    800007a2:	00000097          	auipc	ra,0x0
    800007a6:	cbc080e7          	jalr	-836(ra) # 8000045e <walk>
    800007aa:	84aa                	mv	s1,a0
    800007ac:	d95d                	beqz	a0,80000762 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007ae:	6108                	ld	a0,0(a0)
    800007b0:	00157793          	andi	a5,a0,1
    800007b4:	dfdd                	beqz	a5,80000772 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b6:	3ff57793          	andi	a5,a0,1023
    800007ba:	fd7784e3          	beq	a5,s7,80000782 <uvmunmap+0x76>
    if(do_free){
    800007be:	fc0a8ae3          	beqz	s5,80000792 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007c2:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007c4:	0532                	slli	a0,a0,0xc
    800007c6:	00000097          	auipc	ra,0x0
    800007ca:	856080e7          	jalr	-1962(ra) # 8000001c <kfree>
    800007ce:	b7d1                	j	80000792 <uvmunmap+0x86>

00000000800007d0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d0:	1101                	addi	sp,sp,-32
    800007d2:	ec06                	sd	ra,24(sp)
    800007d4:	e822                	sd	s0,16(sp)
    800007d6:	e426                	sd	s1,8(sp)
    800007d8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007da:	00000097          	auipc	ra,0x0
    800007de:	940080e7          	jalr	-1728(ra) # 8000011a <kalloc>
    800007e2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e4:	c519                	beqz	a0,800007f2 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e6:	6605                	lui	a2,0x1
    800007e8:	4581                	li	a1,0
    800007ea:	00000097          	auipc	ra,0x0
    800007ee:	990080e7          	jalr	-1648(ra) # 8000017a <memset>
  return pagetable;
}
    800007f2:	8526                	mv	a0,s1
    800007f4:	60e2                	ld	ra,24(sp)
    800007f6:	6442                	ld	s0,16(sp)
    800007f8:	64a2                	ld	s1,8(sp)
    800007fa:	6105                	addi	sp,sp,32
    800007fc:	8082                	ret

00000000800007fe <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800007fe:	7179                	addi	sp,sp,-48
    80000800:	f406                	sd	ra,40(sp)
    80000802:	f022                	sd	s0,32(sp)
    80000804:	ec26                	sd	s1,24(sp)
    80000806:	e84a                	sd	s2,16(sp)
    80000808:	e44e                	sd	s3,8(sp)
    8000080a:	e052                	sd	s4,0(sp)
    8000080c:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000080e:	6785                	lui	a5,0x1
    80000810:	04f67863          	bgeu	a2,a5,80000860 <uvmfirst+0x62>
    80000814:	8a2a                	mv	s4,a0
    80000816:	89ae                	mv	s3,a1
    80000818:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000081a:	00000097          	auipc	ra,0x0
    8000081e:	900080e7          	jalr	-1792(ra) # 8000011a <kalloc>
    80000822:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000824:	6605                	lui	a2,0x1
    80000826:	4581                	li	a1,0
    80000828:	00000097          	auipc	ra,0x0
    8000082c:	952080e7          	jalr	-1710(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000830:	4779                	li	a4,30
    80000832:	86ca                	mv	a3,s2
    80000834:	6605                	lui	a2,0x1
    80000836:	4581                	li	a1,0
    80000838:	8552                	mv	a0,s4
    8000083a:	00000097          	auipc	ra,0x0
    8000083e:	d0c080e7          	jalr	-756(ra) # 80000546 <mappages>
  memmove(mem, src, sz);
    80000842:	8626                	mv	a2,s1
    80000844:	85ce                	mv	a1,s3
    80000846:	854a                	mv	a0,s2
    80000848:	00000097          	auipc	ra,0x0
    8000084c:	98e080e7          	jalr	-1650(ra) # 800001d6 <memmove>
}
    80000850:	70a2                	ld	ra,40(sp)
    80000852:	7402                	ld	s0,32(sp)
    80000854:	64e2                	ld	s1,24(sp)
    80000856:	6942                	ld	s2,16(sp)
    80000858:	69a2                	ld	s3,8(sp)
    8000085a:	6a02                	ld	s4,0(sp)
    8000085c:	6145                	addi	sp,sp,48
    8000085e:	8082                	ret
    panic("uvmfirst: more than a page");
    80000860:	00008517          	auipc	a0,0x8
    80000864:	87850513          	addi	a0,a0,-1928 # 800080d8 <etext+0xd8>
    80000868:	00005097          	auipc	ra,0x5
    8000086c:	604080e7          	jalr	1540(ra) # 80005e6c <panic>

0000000080000870 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000870:	1101                	addi	sp,sp,-32
    80000872:	ec06                	sd	ra,24(sp)
    80000874:	e822                	sd	s0,16(sp)
    80000876:	e426                	sd	s1,8(sp)
    80000878:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000087a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087c:	00b67d63          	bgeu	a2,a1,80000896 <uvmdealloc+0x26>
    80000880:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000882:	6785                	lui	a5,0x1
    80000884:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000886:	00f60733          	add	a4,a2,a5
    8000088a:	76fd                	lui	a3,0xfffff
    8000088c:	8f75                	and	a4,a4,a3
    8000088e:	97ae                	add	a5,a5,a1
    80000890:	8ff5                	and	a5,a5,a3
    80000892:	00f76863          	bltu	a4,a5,800008a2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000896:	8526                	mv	a0,s1
    80000898:	60e2                	ld	ra,24(sp)
    8000089a:	6442                	ld	s0,16(sp)
    8000089c:	64a2                	ld	s1,8(sp)
    8000089e:	6105                	addi	sp,sp,32
    800008a0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a2:	8f99                	sub	a5,a5,a4
    800008a4:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a6:	4685                	li	a3,1
    800008a8:	0007861b          	sext.w	a2,a5
    800008ac:	85ba                	mv	a1,a4
    800008ae:	00000097          	auipc	ra,0x0
    800008b2:	e5e080e7          	jalr	-418(ra) # 8000070c <uvmunmap>
    800008b6:	b7c5                	j	80000896 <uvmdealloc+0x26>

00000000800008b8 <uvmalloc>:
  if(newsz < oldsz)
    800008b8:	0ab66563          	bltu	a2,a1,80000962 <uvmalloc+0xaa>
{
    800008bc:	7139                	addi	sp,sp,-64
    800008be:	fc06                	sd	ra,56(sp)
    800008c0:	f822                	sd	s0,48(sp)
    800008c2:	f426                	sd	s1,40(sp)
    800008c4:	f04a                	sd	s2,32(sp)
    800008c6:	ec4e                	sd	s3,24(sp)
    800008c8:	e852                	sd	s4,16(sp)
    800008ca:	e456                	sd	s5,8(sp)
    800008cc:	e05a                	sd	s6,0(sp)
    800008ce:	0080                	addi	s0,sp,64
    800008d0:	8aaa                	mv	s5,a0
    800008d2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d4:	6785                	lui	a5,0x1
    800008d6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d8:	95be                	add	a1,a1,a5
    800008da:	77fd                	lui	a5,0xfffff
    800008dc:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008e0:	08c9f363          	bgeu	s3,a2,80000966 <uvmalloc+0xae>
    800008e4:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008e6:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800008ea:	00000097          	auipc	ra,0x0
    800008ee:	830080e7          	jalr	-2000(ra) # 8000011a <kalloc>
    800008f2:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f4:	c51d                	beqz	a0,80000922 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800008f6:	6605                	lui	a2,0x1
    800008f8:	4581                	li	a1,0
    800008fa:	00000097          	auipc	ra,0x0
    800008fe:	880080e7          	jalr	-1920(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000902:	875a                	mv	a4,s6
    80000904:	86a6                	mv	a3,s1
    80000906:	6605                	lui	a2,0x1
    80000908:	85ca                	mv	a1,s2
    8000090a:	8556                	mv	a0,s5
    8000090c:	00000097          	auipc	ra,0x0
    80000910:	c3a080e7          	jalr	-966(ra) # 80000546 <mappages>
    80000914:	e90d                	bnez	a0,80000946 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000916:	6785                	lui	a5,0x1
    80000918:	993e                	add	s2,s2,a5
    8000091a:	fd4968e3          	bltu	s2,s4,800008ea <uvmalloc+0x32>
  return newsz;
    8000091e:	8552                	mv	a0,s4
    80000920:	a809                	j	80000932 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000922:	864e                	mv	a2,s3
    80000924:	85ca                	mv	a1,s2
    80000926:	8556                	mv	a0,s5
    80000928:	00000097          	auipc	ra,0x0
    8000092c:	f48080e7          	jalr	-184(ra) # 80000870 <uvmdealloc>
      return 0;
    80000930:	4501                	li	a0,0
}
    80000932:	70e2                	ld	ra,56(sp)
    80000934:	7442                	ld	s0,48(sp)
    80000936:	74a2                	ld	s1,40(sp)
    80000938:	7902                	ld	s2,32(sp)
    8000093a:	69e2                	ld	s3,24(sp)
    8000093c:	6a42                	ld	s4,16(sp)
    8000093e:	6aa2                	ld	s5,8(sp)
    80000940:	6b02                	ld	s6,0(sp)
    80000942:	6121                	addi	sp,sp,64
    80000944:	8082                	ret
      kfree(mem);
    80000946:	8526                	mv	a0,s1
    80000948:	fffff097          	auipc	ra,0xfffff
    8000094c:	6d4080e7          	jalr	1748(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000950:	864e                	mv	a2,s3
    80000952:	85ca                	mv	a1,s2
    80000954:	8556                	mv	a0,s5
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	f1a080e7          	jalr	-230(ra) # 80000870 <uvmdealloc>
      return 0;
    8000095e:	4501                	li	a0,0
    80000960:	bfc9                	j	80000932 <uvmalloc+0x7a>
    return oldsz;
    80000962:	852e                	mv	a0,a1
}
    80000964:	8082                	ret
  return newsz;
    80000966:	8532                	mv	a0,a2
    80000968:	b7e9                	j	80000932 <uvmalloc+0x7a>

000000008000096a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000096a:	7179                	addi	sp,sp,-48
    8000096c:	f406                	sd	ra,40(sp)
    8000096e:	f022                	sd	s0,32(sp)
    80000970:	ec26                	sd	s1,24(sp)
    80000972:	e84a                	sd	s2,16(sp)
    80000974:	e44e                	sd	s3,8(sp)
    80000976:	e052                	sd	s4,0(sp)
    80000978:	1800                	addi	s0,sp,48
    8000097a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000097c:	84aa                	mv	s1,a0
    8000097e:	6905                	lui	s2,0x1
    80000980:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000982:	4985                	li	s3,1
    80000984:	a829                	j	8000099e <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000986:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000988:	00c79513          	slli	a0,a5,0xc
    8000098c:	00000097          	auipc	ra,0x0
    80000990:	fde080e7          	jalr	-34(ra) # 8000096a <freewalk>
      pagetable[i] = 0;
    80000994:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000998:	04a1                	addi	s1,s1,8
    8000099a:	03248163          	beq	s1,s2,800009bc <freewalk+0x52>
    pte_t pte = pagetable[i];
    8000099e:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009a0:	00f7f713          	andi	a4,a5,15
    800009a4:	ff3701e3          	beq	a4,s3,80000986 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a8:	8b85                	andi	a5,a5,1
    800009aa:	d7fd                	beqz	a5,80000998 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009ac:	00007517          	auipc	a0,0x7
    800009b0:	74c50513          	addi	a0,a0,1868 # 800080f8 <etext+0xf8>
    800009b4:	00005097          	auipc	ra,0x5
    800009b8:	4b8080e7          	jalr	1208(ra) # 80005e6c <panic>
    }
  }
  kfree((void*)pagetable);
    800009bc:	8552                	mv	a0,s4
    800009be:	fffff097          	auipc	ra,0xfffff
    800009c2:	65e080e7          	jalr	1630(ra) # 8000001c <kfree>
}
    800009c6:	70a2                	ld	ra,40(sp)
    800009c8:	7402                	ld	s0,32(sp)
    800009ca:	64e2                	ld	s1,24(sp)
    800009cc:	6942                	ld	s2,16(sp)
    800009ce:	69a2                	ld	s3,8(sp)
    800009d0:	6a02                	ld	s4,0(sp)
    800009d2:	6145                	addi	sp,sp,48
    800009d4:	8082                	ret

00000000800009d6 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009d6:	1101                	addi	sp,sp,-32
    800009d8:	ec06                	sd	ra,24(sp)
    800009da:	e822                	sd	s0,16(sp)
    800009dc:	e426                	sd	s1,8(sp)
    800009de:	1000                	addi	s0,sp,32
    800009e0:	84aa                	mv	s1,a0
  if(sz > 0)
    800009e2:	e999                	bnez	a1,800009f8 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009e4:	8526                	mv	a0,s1
    800009e6:	00000097          	auipc	ra,0x0
    800009ea:	f84080e7          	jalr	-124(ra) # 8000096a <freewalk>
}
    800009ee:	60e2                	ld	ra,24(sp)
    800009f0:	6442                	ld	s0,16(sp)
    800009f2:	64a2                	ld	s1,8(sp)
    800009f4:	6105                	addi	sp,sp,32
    800009f6:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009f8:	6785                	lui	a5,0x1
    800009fa:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009fc:	95be                	add	a1,a1,a5
    800009fe:	4685                	li	a3,1
    80000a00:	00c5d613          	srli	a2,a1,0xc
    80000a04:	4581                	li	a1,0
    80000a06:	00000097          	auipc	ra,0x0
    80000a0a:	d06080e7          	jalr	-762(ra) # 8000070c <uvmunmap>
    80000a0e:	bfd9                	j	800009e4 <uvmfree+0xe>

0000000080000a10 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a10:	c679                	beqz	a2,80000ade <uvmcopy+0xce>
{
    80000a12:	715d                	addi	sp,sp,-80
    80000a14:	e486                	sd	ra,72(sp)
    80000a16:	e0a2                	sd	s0,64(sp)
    80000a18:	fc26                	sd	s1,56(sp)
    80000a1a:	f84a                	sd	s2,48(sp)
    80000a1c:	f44e                	sd	s3,40(sp)
    80000a1e:	f052                	sd	s4,32(sp)
    80000a20:	ec56                	sd	s5,24(sp)
    80000a22:	e85a                	sd	s6,16(sp)
    80000a24:	e45e                	sd	s7,8(sp)
    80000a26:	0880                	addi	s0,sp,80
    80000a28:	8b2a                	mv	s6,a0
    80000a2a:	8aae                	mv	s5,a1
    80000a2c:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a2e:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a30:	4601                	li	a2,0
    80000a32:	85ce                	mv	a1,s3
    80000a34:	855a                	mv	a0,s6
    80000a36:	00000097          	auipc	ra,0x0
    80000a3a:	a28080e7          	jalr	-1496(ra) # 8000045e <walk>
    80000a3e:	c531                	beqz	a0,80000a8a <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a40:	6118                	ld	a4,0(a0)
    80000a42:	00177793          	andi	a5,a4,1
    80000a46:	cbb1                	beqz	a5,80000a9a <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a48:	00a75593          	srli	a1,a4,0xa
    80000a4c:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a50:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a54:	fffff097          	auipc	ra,0xfffff
    80000a58:	6c6080e7          	jalr	1734(ra) # 8000011a <kalloc>
    80000a5c:	892a                	mv	s2,a0
    80000a5e:	c939                	beqz	a0,80000ab4 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a60:	6605                	lui	a2,0x1
    80000a62:	85de                	mv	a1,s7
    80000a64:	fffff097          	auipc	ra,0xfffff
    80000a68:	772080e7          	jalr	1906(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a6c:	8726                	mv	a4,s1
    80000a6e:	86ca                	mv	a3,s2
    80000a70:	6605                	lui	a2,0x1
    80000a72:	85ce                	mv	a1,s3
    80000a74:	8556                	mv	a0,s5
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	ad0080e7          	jalr	-1328(ra) # 80000546 <mappages>
    80000a7e:	e515                	bnez	a0,80000aaa <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a80:	6785                	lui	a5,0x1
    80000a82:	99be                	add	s3,s3,a5
    80000a84:	fb49e6e3          	bltu	s3,s4,80000a30 <uvmcopy+0x20>
    80000a88:	a081                	j	80000ac8 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a8a:	00007517          	auipc	a0,0x7
    80000a8e:	67e50513          	addi	a0,a0,1662 # 80008108 <etext+0x108>
    80000a92:	00005097          	auipc	ra,0x5
    80000a96:	3da080e7          	jalr	986(ra) # 80005e6c <panic>
      panic("uvmcopy: page not present");
    80000a9a:	00007517          	auipc	a0,0x7
    80000a9e:	68e50513          	addi	a0,a0,1678 # 80008128 <etext+0x128>
    80000aa2:	00005097          	auipc	ra,0x5
    80000aa6:	3ca080e7          	jalr	970(ra) # 80005e6c <panic>
      kfree(mem);
    80000aaa:	854a                	mv	a0,s2
    80000aac:	fffff097          	auipc	ra,0xfffff
    80000ab0:	570080e7          	jalr	1392(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ab4:	4685                	li	a3,1
    80000ab6:	00c9d613          	srli	a2,s3,0xc
    80000aba:	4581                	li	a1,0
    80000abc:	8556                	mv	a0,s5
    80000abe:	00000097          	auipc	ra,0x0
    80000ac2:	c4e080e7          	jalr	-946(ra) # 8000070c <uvmunmap>
  return -1;
    80000ac6:	557d                	li	a0,-1
}
    80000ac8:	60a6                	ld	ra,72(sp)
    80000aca:	6406                	ld	s0,64(sp)
    80000acc:	74e2                	ld	s1,56(sp)
    80000ace:	7942                	ld	s2,48(sp)
    80000ad0:	79a2                	ld	s3,40(sp)
    80000ad2:	7a02                	ld	s4,32(sp)
    80000ad4:	6ae2                	ld	s5,24(sp)
    80000ad6:	6b42                	ld	s6,16(sp)
    80000ad8:	6ba2                	ld	s7,8(sp)
    80000ada:	6161                	addi	sp,sp,80
    80000adc:	8082                	ret
  return 0;
    80000ade:	4501                	li	a0,0
}
    80000ae0:	8082                	ret

0000000080000ae2 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ae2:	1141                	addi	sp,sp,-16
    80000ae4:	e406                	sd	ra,8(sp)
    80000ae6:	e022                	sd	s0,0(sp)
    80000ae8:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000aea:	4601                	li	a2,0
    80000aec:	00000097          	auipc	ra,0x0
    80000af0:	972080e7          	jalr	-1678(ra) # 8000045e <walk>
  if(pte == 0)
    80000af4:	c901                	beqz	a0,80000b04 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000af6:	611c                	ld	a5,0(a0)
    80000af8:	9bbd                	andi	a5,a5,-17
    80000afa:	e11c                	sd	a5,0(a0)
}
    80000afc:	60a2                	ld	ra,8(sp)
    80000afe:	6402                	ld	s0,0(sp)
    80000b00:	0141                	addi	sp,sp,16
    80000b02:	8082                	ret
    panic("uvmclear");
    80000b04:	00007517          	auipc	a0,0x7
    80000b08:	64450513          	addi	a0,a0,1604 # 80008148 <etext+0x148>
    80000b0c:	00005097          	auipc	ra,0x5
    80000b10:	360080e7          	jalr	864(ra) # 80005e6c <panic>

0000000080000b14 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b14:	c6bd                	beqz	a3,80000b82 <copyout+0x6e>
{
    80000b16:	715d                	addi	sp,sp,-80
    80000b18:	e486                	sd	ra,72(sp)
    80000b1a:	e0a2                	sd	s0,64(sp)
    80000b1c:	fc26                	sd	s1,56(sp)
    80000b1e:	f84a                	sd	s2,48(sp)
    80000b20:	f44e                	sd	s3,40(sp)
    80000b22:	f052                	sd	s4,32(sp)
    80000b24:	ec56                	sd	s5,24(sp)
    80000b26:	e85a                	sd	s6,16(sp)
    80000b28:	e45e                	sd	s7,8(sp)
    80000b2a:	e062                	sd	s8,0(sp)
    80000b2c:	0880                	addi	s0,sp,80
    80000b2e:	8b2a                	mv	s6,a0
    80000b30:	8c2e                	mv	s8,a1
    80000b32:	8a32                	mv	s4,a2
    80000b34:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b36:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b38:	6a85                	lui	s5,0x1
    80000b3a:	a015                	j	80000b5e <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b3c:	9562                	add	a0,a0,s8
    80000b3e:	0004861b          	sext.w	a2,s1
    80000b42:	85d2                	mv	a1,s4
    80000b44:	41250533          	sub	a0,a0,s2
    80000b48:	fffff097          	auipc	ra,0xfffff
    80000b4c:	68e080e7          	jalr	1678(ra) # 800001d6 <memmove>

    len -= n;
    80000b50:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b54:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b56:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b5a:	02098263          	beqz	s3,80000b7e <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b5e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b62:	85ca                	mv	a1,s2
    80000b64:	855a                	mv	a0,s6
    80000b66:	00000097          	auipc	ra,0x0
    80000b6a:	99e080e7          	jalr	-1634(ra) # 80000504 <walkaddr>
    if(pa0 == 0)
    80000b6e:	cd01                	beqz	a0,80000b86 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b70:	418904b3          	sub	s1,s2,s8
    80000b74:	94d6                	add	s1,s1,s5
    80000b76:	fc99f3e3          	bgeu	s3,s1,80000b3c <copyout+0x28>
    80000b7a:	84ce                	mv	s1,s3
    80000b7c:	b7c1                	j	80000b3c <copyout+0x28>
  }
  return 0;
    80000b7e:	4501                	li	a0,0
    80000b80:	a021                	j	80000b88 <copyout+0x74>
    80000b82:	4501                	li	a0,0
}
    80000b84:	8082                	ret
      return -1;
    80000b86:	557d                	li	a0,-1
}
    80000b88:	60a6                	ld	ra,72(sp)
    80000b8a:	6406                	ld	s0,64(sp)
    80000b8c:	74e2                	ld	s1,56(sp)
    80000b8e:	7942                	ld	s2,48(sp)
    80000b90:	79a2                	ld	s3,40(sp)
    80000b92:	7a02                	ld	s4,32(sp)
    80000b94:	6ae2                	ld	s5,24(sp)
    80000b96:	6b42                	ld	s6,16(sp)
    80000b98:	6ba2                	ld	s7,8(sp)
    80000b9a:	6c02                	ld	s8,0(sp)
    80000b9c:	6161                	addi	sp,sp,80
    80000b9e:	8082                	ret

0000000080000ba0 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000ba0:	caa5                	beqz	a3,80000c10 <copyin+0x70>
{
    80000ba2:	715d                	addi	sp,sp,-80
    80000ba4:	e486                	sd	ra,72(sp)
    80000ba6:	e0a2                	sd	s0,64(sp)
    80000ba8:	fc26                	sd	s1,56(sp)
    80000baa:	f84a                	sd	s2,48(sp)
    80000bac:	f44e                	sd	s3,40(sp)
    80000bae:	f052                	sd	s4,32(sp)
    80000bb0:	ec56                	sd	s5,24(sp)
    80000bb2:	e85a                	sd	s6,16(sp)
    80000bb4:	e45e                	sd	s7,8(sp)
    80000bb6:	e062                	sd	s8,0(sp)
    80000bb8:	0880                	addi	s0,sp,80
    80000bba:	8b2a                	mv	s6,a0
    80000bbc:	8a2e                	mv	s4,a1
    80000bbe:	8c32                	mv	s8,a2
    80000bc0:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bc2:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bc4:	6a85                	lui	s5,0x1
    80000bc6:	a01d                	j	80000bec <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bc8:	018505b3          	add	a1,a0,s8
    80000bcc:	0004861b          	sext.w	a2,s1
    80000bd0:	412585b3          	sub	a1,a1,s2
    80000bd4:	8552                	mv	a0,s4
    80000bd6:	fffff097          	auipc	ra,0xfffff
    80000bda:	600080e7          	jalr	1536(ra) # 800001d6 <memmove>

    len -= n;
    80000bde:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000be2:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000be4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000be8:	02098263          	beqz	s3,80000c0c <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bec:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bf0:	85ca                	mv	a1,s2
    80000bf2:	855a                	mv	a0,s6
    80000bf4:	00000097          	auipc	ra,0x0
    80000bf8:	910080e7          	jalr	-1776(ra) # 80000504 <walkaddr>
    if(pa0 == 0)
    80000bfc:	cd01                	beqz	a0,80000c14 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bfe:	418904b3          	sub	s1,s2,s8
    80000c02:	94d6                	add	s1,s1,s5
    80000c04:	fc99f2e3          	bgeu	s3,s1,80000bc8 <copyin+0x28>
    80000c08:	84ce                	mv	s1,s3
    80000c0a:	bf7d                	j	80000bc8 <copyin+0x28>
  }
  return 0;
    80000c0c:	4501                	li	a0,0
    80000c0e:	a021                	j	80000c16 <copyin+0x76>
    80000c10:	4501                	li	a0,0
}
    80000c12:	8082                	ret
      return -1;
    80000c14:	557d                	li	a0,-1
}
    80000c16:	60a6                	ld	ra,72(sp)
    80000c18:	6406                	ld	s0,64(sp)
    80000c1a:	74e2                	ld	s1,56(sp)
    80000c1c:	7942                	ld	s2,48(sp)
    80000c1e:	79a2                	ld	s3,40(sp)
    80000c20:	7a02                	ld	s4,32(sp)
    80000c22:	6ae2                	ld	s5,24(sp)
    80000c24:	6b42                	ld	s6,16(sp)
    80000c26:	6ba2                	ld	s7,8(sp)
    80000c28:	6c02                	ld	s8,0(sp)
    80000c2a:	6161                	addi	sp,sp,80
    80000c2c:	8082                	ret

0000000080000c2e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c2e:	c2dd                	beqz	a3,80000cd4 <copyinstr+0xa6>
{
    80000c30:	715d                	addi	sp,sp,-80
    80000c32:	e486                	sd	ra,72(sp)
    80000c34:	e0a2                	sd	s0,64(sp)
    80000c36:	fc26                	sd	s1,56(sp)
    80000c38:	f84a                	sd	s2,48(sp)
    80000c3a:	f44e                	sd	s3,40(sp)
    80000c3c:	f052                	sd	s4,32(sp)
    80000c3e:	ec56                	sd	s5,24(sp)
    80000c40:	e85a                	sd	s6,16(sp)
    80000c42:	e45e                	sd	s7,8(sp)
    80000c44:	0880                	addi	s0,sp,80
    80000c46:	8a2a                	mv	s4,a0
    80000c48:	8b2e                	mv	s6,a1
    80000c4a:	8bb2                	mv	s7,a2
    80000c4c:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c4e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c50:	6985                	lui	s3,0x1
    80000c52:	a02d                	j	80000c7c <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c54:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c58:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c5a:	37fd                	addiw	a5,a5,-1
    80000c5c:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c60:	60a6                	ld	ra,72(sp)
    80000c62:	6406                	ld	s0,64(sp)
    80000c64:	74e2                	ld	s1,56(sp)
    80000c66:	7942                	ld	s2,48(sp)
    80000c68:	79a2                	ld	s3,40(sp)
    80000c6a:	7a02                	ld	s4,32(sp)
    80000c6c:	6ae2                	ld	s5,24(sp)
    80000c6e:	6b42                	ld	s6,16(sp)
    80000c70:	6ba2                	ld	s7,8(sp)
    80000c72:	6161                	addi	sp,sp,80
    80000c74:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c76:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c7a:	c8a9                	beqz	s1,80000ccc <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000c7c:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c80:	85ca                	mv	a1,s2
    80000c82:	8552                	mv	a0,s4
    80000c84:	00000097          	auipc	ra,0x0
    80000c88:	880080e7          	jalr	-1920(ra) # 80000504 <walkaddr>
    if(pa0 == 0)
    80000c8c:	c131                	beqz	a0,80000cd0 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000c8e:	417906b3          	sub	a3,s2,s7
    80000c92:	96ce                	add	a3,a3,s3
    80000c94:	00d4f363          	bgeu	s1,a3,80000c9a <copyinstr+0x6c>
    80000c98:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c9a:	955e                	add	a0,a0,s7
    80000c9c:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000ca0:	daf9                	beqz	a3,80000c76 <copyinstr+0x48>
    80000ca2:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000ca4:	41650633          	sub	a2,a0,s6
    80000ca8:	fff48593          	addi	a1,s1,-1
    80000cac:	95da                	add	a1,a1,s6
    while(n > 0){
    80000cae:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000cb0:	00f60733          	add	a4,a2,a5
    80000cb4:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffe1e90>
    80000cb8:	df51                	beqz	a4,80000c54 <copyinstr+0x26>
        *dst = *p;
    80000cba:	00e78023          	sb	a4,0(a5)
      --max;
    80000cbe:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000cc2:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cc4:	fed796e3          	bne	a5,a3,80000cb0 <copyinstr+0x82>
      dst++;
    80000cc8:	8b3e                	mv	s6,a5
    80000cca:	b775                	j	80000c76 <copyinstr+0x48>
    80000ccc:	4781                	li	a5,0
    80000cce:	b771                	j	80000c5a <copyinstr+0x2c>
      return -1;
    80000cd0:	557d                	li	a0,-1
    80000cd2:	b779                	j	80000c60 <copyinstr+0x32>
  int got_null = 0;
    80000cd4:	4781                	li	a5,0
  if(got_null){
    80000cd6:	37fd                	addiw	a5,a5,-1
    80000cd8:	0007851b          	sext.w	a0,a5
}
    80000cdc:	8082                	ret

0000000080000cde <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000cde:	7139                	addi	sp,sp,-64
    80000ce0:	fc06                	sd	ra,56(sp)
    80000ce2:	f822                	sd	s0,48(sp)
    80000ce4:	f426                	sd	s1,40(sp)
    80000ce6:	f04a                	sd	s2,32(sp)
    80000ce8:	ec4e                	sd	s3,24(sp)
    80000cea:	e852                	sd	s4,16(sp)
    80000cec:	e456                	sd	s5,8(sp)
    80000cee:	e05a                	sd	s6,0(sp)
    80000cf0:	0080                	addi	s0,sp,64
    80000cf2:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf4:	00008497          	auipc	s1,0x8
    80000cf8:	04c48493          	addi	s1,s1,76 # 80008d40 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cfc:	8b26                	mv	s6,s1
    80000cfe:	00007a97          	auipc	s5,0x7
    80000d02:	302a8a93          	addi	s5,s5,770 # 80008000 <etext>
    80000d06:	04000937          	lui	s2,0x4000
    80000d0a:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d0c:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d0e:	00009a17          	auipc	s4,0x9
    80000d12:	e42a0a13          	addi	s4,s4,-446 # 80009b50 <tickslock>
    char *pa = kalloc();
    80000d16:	fffff097          	auipc	ra,0xfffff
    80000d1a:	404080e7          	jalr	1028(ra) # 8000011a <kalloc>
    80000d1e:	862a                	mv	a2,a0
    if(pa == 0)
    80000d20:	c131                	beqz	a0,80000d64 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d22:	416485b3          	sub	a1,s1,s6
    80000d26:	858d                	srai	a1,a1,0x3
    80000d28:	000ab783          	ld	a5,0(s5)
    80000d2c:	02f585b3          	mul	a1,a1,a5
    80000d30:	2585                	addiw	a1,a1,1
    80000d32:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d36:	4719                	li	a4,6
    80000d38:	6685                	lui	a3,0x1
    80000d3a:	40b905b3          	sub	a1,s2,a1
    80000d3e:	854e                	mv	a0,s3
    80000d40:	00000097          	auipc	ra,0x0
    80000d44:	8a6080e7          	jalr	-1882(ra) # 800005e6 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d48:	16848493          	addi	s1,s1,360
    80000d4c:	fd4495e3          	bne	s1,s4,80000d16 <proc_mapstacks+0x38>
  }
}
    80000d50:	70e2                	ld	ra,56(sp)
    80000d52:	7442                	ld	s0,48(sp)
    80000d54:	74a2                	ld	s1,40(sp)
    80000d56:	7902                	ld	s2,32(sp)
    80000d58:	69e2                	ld	s3,24(sp)
    80000d5a:	6a42                	ld	s4,16(sp)
    80000d5c:	6aa2                	ld	s5,8(sp)
    80000d5e:	6b02                	ld	s6,0(sp)
    80000d60:	6121                	addi	sp,sp,64
    80000d62:	8082                	ret
      panic("kalloc");
    80000d64:	00007517          	auipc	a0,0x7
    80000d68:	3f450513          	addi	a0,a0,1012 # 80008158 <etext+0x158>
    80000d6c:	00005097          	auipc	ra,0x5
    80000d70:	100080e7          	jalr	256(ra) # 80005e6c <panic>

0000000080000d74 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000d74:	7139                	addi	sp,sp,-64
    80000d76:	fc06                	sd	ra,56(sp)
    80000d78:	f822                	sd	s0,48(sp)
    80000d7a:	f426                	sd	s1,40(sp)
    80000d7c:	f04a                	sd	s2,32(sp)
    80000d7e:	ec4e                	sd	s3,24(sp)
    80000d80:	e852                	sd	s4,16(sp)
    80000d82:	e456                	sd	s5,8(sp)
    80000d84:	e05a                	sd	s6,0(sp)
    80000d86:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d88:	00007597          	auipc	a1,0x7
    80000d8c:	3d858593          	addi	a1,a1,984 # 80008160 <etext+0x160>
    80000d90:	00008517          	auipc	a0,0x8
    80000d94:	b8050513          	addi	a0,a0,-1152 # 80008910 <pid_lock>
    80000d98:	00005097          	auipc	ra,0x5
    80000d9c:	57c080e7          	jalr	1404(ra) # 80006314 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000da0:	00007597          	auipc	a1,0x7
    80000da4:	3c858593          	addi	a1,a1,968 # 80008168 <etext+0x168>
    80000da8:	00008517          	auipc	a0,0x8
    80000dac:	b8050513          	addi	a0,a0,-1152 # 80008928 <wait_lock>
    80000db0:	00005097          	auipc	ra,0x5
    80000db4:	564080e7          	jalr	1380(ra) # 80006314 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db8:	00008497          	auipc	s1,0x8
    80000dbc:	f8848493          	addi	s1,s1,-120 # 80008d40 <proc>
      initlock(&p->lock, "proc");
    80000dc0:	00007b17          	auipc	s6,0x7
    80000dc4:	3b8b0b13          	addi	s6,s6,952 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000dc8:	8aa6                	mv	s5,s1
    80000dca:	00007a17          	auipc	s4,0x7
    80000dce:	236a0a13          	addi	s4,s4,566 # 80008000 <etext>
    80000dd2:	04000937          	lui	s2,0x4000
    80000dd6:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000dd8:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dda:	00009997          	auipc	s3,0x9
    80000dde:	d7698993          	addi	s3,s3,-650 # 80009b50 <tickslock>
      initlock(&p->lock, "proc");
    80000de2:	85da                	mv	a1,s6
    80000de4:	8526                	mv	a0,s1
    80000de6:	00005097          	auipc	ra,0x5
    80000dea:	52e080e7          	jalr	1326(ra) # 80006314 <initlock>
      p->state = UNUSED;
    80000dee:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000df2:	415487b3          	sub	a5,s1,s5
    80000df6:	878d                	srai	a5,a5,0x3
    80000df8:	000a3703          	ld	a4,0(s4)
    80000dfc:	02e787b3          	mul	a5,a5,a4
    80000e00:	2785                	addiw	a5,a5,1
    80000e02:	00d7979b          	slliw	a5,a5,0xd
    80000e06:	40f907b3          	sub	a5,s2,a5
    80000e0a:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e0c:	16848493          	addi	s1,s1,360
    80000e10:	fd3499e3          	bne	s1,s3,80000de2 <procinit+0x6e>
  }
}
    80000e14:	70e2                	ld	ra,56(sp)
    80000e16:	7442                	ld	s0,48(sp)
    80000e18:	74a2                	ld	s1,40(sp)
    80000e1a:	7902                	ld	s2,32(sp)
    80000e1c:	69e2                	ld	s3,24(sp)
    80000e1e:	6a42                	ld	s4,16(sp)
    80000e20:	6aa2                	ld	s5,8(sp)
    80000e22:	6b02                	ld	s6,0(sp)
    80000e24:	6121                	addi	sp,sp,64
    80000e26:	8082                	ret

0000000080000e28 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e28:	1141                	addi	sp,sp,-16
    80000e2a:	e422                	sd	s0,8(sp)
    80000e2c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e2e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e30:	2501                	sext.w	a0,a0
    80000e32:	6422                	ld	s0,8(sp)
    80000e34:	0141                	addi	sp,sp,16
    80000e36:	8082                	ret

0000000080000e38 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e38:	1141                	addi	sp,sp,-16
    80000e3a:	e422                	sd	s0,8(sp)
    80000e3c:	0800                	addi	s0,sp,16
    80000e3e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e40:	2781                	sext.w	a5,a5
    80000e42:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e44:	00008517          	auipc	a0,0x8
    80000e48:	afc50513          	addi	a0,a0,-1284 # 80008940 <cpus>
    80000e4c:	953e                	add	a0,a0,a5
    80000e4e:	6422                	ld	s0,8(sp)
    80000e50:	0141                	addi	sp,sp,16
    80000e52:	8082                	ret

0000000080000e54 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e54:	1101                	addi	sp,sp,-32
    80000e56:	ec06                	sd	ra,24(sp)
    80000e58:	e822                	sd	s0,16(sp)
    80000e5a:	e426                	sd	s1,8(sp)
    80000e5c:	1000                	addi	s0,sp,32
  push_off();
    80000e5e:	00005097          	auipc	ra,0x5
    80000e62:	4fa080e7          	jalr	1274(ra) # 80006358 <push_off>
    80000e66:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e68:	2781                	sext.w	a5,a5
    80000e6a:	079e                	slli	a5,a5,0x7
    80000e6c:	00008717          	auipc	a4,0x8
    80000e70:	aa470713          	addi	a4,a4,-1372 # 80008910 <pid_lock>
    80000e74:	97ba                	add	a5,a5,a4
    80000e76:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e78:	00005097          	auipc	ra,0x5
    80000e7c:	580080e7          	jalr	1408(ra) # 800063f8 <pop_off>
  return p;
}
    80000e80:	8526                	mv	a0,s1
    80000e82:	60e2                	ld	ra,24(sp)
    80000e84:	6442                	ld	s0,16(sp)
    80000e86:	64a2                	ld	s1,8(sp)
    80000e88:	6105                	addi	sp,sp,32
    80000e8a:	8082                	ret

0000000080000e8c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e8c:	1141                	addi	sp,sp,-16
    80000e8e:	e406                	sd	ra,8(sp)
    80000e90:	e022                	sd	s0,0(sp)
    80000e92:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e94:	00000097          	auipc	ra,0x0
    80000e98:	fc0080e7          	jalr	-64(ra) # 80000e54 <myproc>
    80000e9c:	00005097          	auipc	ra,0x5
    80000ea0:	5bc080e7          	jalr	1468(ra) # 80006458 <release>

  if (first) {
    80000ea4:	00008797          	auipc	a5,0x8
    80000ea8:	9ac7a783          	lw	a5,-1620(a5) # 80008850 <first.1>
    80000eac:	eb89                	bnez	a5,80000ebe <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000eae:	00001097          	auipc	ra,0x1
    80000eb2:	c5c080e7          	jalr	-932(ra) # 80001b0a <usertrapret>
}
    80000eb6:	60a2                	ld	ra,8(sp)
    80000eb8:	6402                	ld	s0,0(sp)
    80000eba:	0141                	addi	sp,sp,16
    80000ebc:	8082                	ret
    first = 0;
    80000ebe:	00008797          	auipc	a5,0x8
    80000ec2:	9807a923          	sw	zero,-1646(a5) # 80008850 <first.1>
    fsinit(ROOTDEV);
    80000ec6:	4505                	li	a0,1
    80000ec8:	00002097          	auipc	ra,0x2
    80000ecc:	a7e080e7          	jalr	-1410(ra) # 80002946 <fsinit>
    80000ed0:	bff9                	j	80000eae <forkret+0x22>

0000000080000ed2 <allocpid>:
{
    80000ed2:	1101                	addi	sp,sp,-32
    80000ed4:	ec06                	sd	ra,24(sp)
    80000ed6:	e822                	sd	s0,16(sp)
    80000ed8:	e426                	sd	s1,8(sp)
    80000eda:	e04a                	sd	s2,0(sp)
    80000edc:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ede:	00008917          	auipc	s2,0x8
    80000ee2:	a3290913          	addi	s2,s2,-1486 # 80008910 <pid_lock>
    80000ee6:	854a                	mv	a0,s2
    80000ee8:	00005097          	auipc	ra,0x5
    80000eec:	4bc080e7          	jalr	1212(ra) # 800063a4 <acquire>
  pid = nextpid;
    80000ef0:	00008797          	auipc	a5,0x8
    80000ef4:	96478793          	addi	a5,a5,-1692 # 80008854 <nextpid>
    80000ef8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000efa:	0014871b          	addiw	a4,s1,1
    80000efe:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f00:	854a                	mv	a0,s2
    80000f02:	00005097          	auipc	ra,0x5
    80000f06:	556080e7          	jalr	1366(ra) # 80006458 <release>
}
    80000f0a:	8526                	mv	a0,s1
    80000f0c:	60e2                	ld	ra,24(sp)
    80000f0e:	6442                	ld	s0,16(sp)
    80000f10:	64a2                	ld	s1,8(sp)
    80000f12:	6902                	ld	s2,0(sp)
    80000f14:	6105                	addi	sp,sp,32
    80000f16:	8082                	ret

0000000080000f18 <proc_pagetable>:
{
    80000f18:	1101                	addi	sp,sp,-32
    80000f1a:	ec06                	sd	ra,24(sp)
    80000f1c:	e822                	sd	s0,16(sp)
    80000f1e:	e426                	sd	s1,8(sp)
    80000f20:	e04a                	sd	s2,0(sp)
    80000f22:	1000                	addi	s0,sp,32
    80000f24:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f26:	00000097          	auipc	ra,0x0
    80000f2a:	8aa080e7          	jalr	-1878(ra) # 800007d0 <uvmcreate>
    80000f2e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f30:	c121                	beqz	a0,80000f70 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f32:	4729                	li	a4,10
    80000f34:	00006697          	auipc	a3,0x6
    80000f38:	0cc68693          	addi	a3,a3,204 # 80007000 <_trampoline>
    80000f3c:	6605                	lui	a2,0x1
    80000f3e:	040005b7          	lui	a1,0x4000
    80000f42:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f44:	05b2                	slli	a1,a1,0xc
    80000f46:	fffff097          	auipc	ra,0xfffff
    80000f4a:	600080e7          	jalr	1536(ra) # 80000546 <mappages>
    80000f4e:	02054863          	bltz	a0,80000f7e <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f52:	4719                	li	a4,6
    80000f54:	05893683          	ld	a3,88(s2)
    80000f58:	6605                	lui	a2,0x1
    80000f5a:	020005b7          	lui	a1,0x2000
    80000f5e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f60:	05b6                	slli	a1,a1,0xd
    80000f62:	8526                	mv	a0,s1
    80000f64:	fffff097          	auipc	ra,0xfffff
    80000f68:	5e2080e7          	jalr	1506(ra) # 80000546 <mappages>
    80000f6c:	02054163          	bltz	a0,80000f8e <proc_pagetable+0x76>
}
    80000f70:	8526                	mv	a0,s1
    80000f72:	60e2                	ld	ra,24(sp)
    80000f74:	6442                	ld	s0,16(sp)
    80000f76:	64a2                	ld	s1,8(sp)
    80000f78:	6902                	ld	s2,0(sp)
    80000f7a:	6105                	addi	sp,sp,32
    80000f7c:	8082                	ret
    uvmfree(pagetable, 0);
    80000f7e:	4581                	li	a1,0
    80000f80:	8526                	mv	a0,s1
    80000f82:	00000097          	auipc	ra,0x0
    80000f86:	a54080e7          	jalr	-1452(ra) # 800009d6 <uvmfree>
    return 0;
    80000f8a:	4481                	li	s1,0
    80000f8c:	b7d5                	j	80000f70 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f8e:	4681                	li	a3,0
    80000f90:	4605                	li	a2,1
    80000f92:	040005b7          	lui	a1,0x4000
    80000f96:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f98:	05b2                	slli	a1,a1,0xc
    80000f9a:	8526                	mv	a0,s1
    80000f9c:	fffff097          	auipc	ra,0xfffff
    80000fa0:	770080e7          	jalr	1904(ra) # 8000070c <uvmunmap>
    uvmfree(pagetable, 0);
    80000fa4:	4581                	li	a1,0
    80000fa6:	8526                	mv	a0,s1
    80000fa8:	00000097          	auipc	ra,0x0
    80000fac:	a2e080e7          	jalr	-1490(ra) # 800009d6 <uvmfree>
    return 0;
    80000fb0:	4481                	li	s1,0
    80000fb2:	bf7d                	j	80000f70 <proc_pagetable+0x58>

0000000080000fb4 <proc_freepagetable>:
{
    80000fb4:	1101                	addi	sp,sp,-32
    80000fb6:	ec06                	sd	ra,24(sp)
    80000fb8:	e822                	sd	s0,16(sp)
    80000fba:	e426                	sd	s1,8(sp)
    80000fbc:	e04a                	sd	s2,0(sp)
    80000fbe:	1000                	addi	s0,sp,32
    80000fc0:	84aa                	mv	s1,a0
    80000fc2:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fc4:	4681                	li	a3,0
    80000fc6:	4605                	li	a2,1
    80000fc8:	040005b7          	lui	a1,0x4000
    80000fcc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fce:	05b2                	slli	a1,a1,0xc
    80000fd0:	fffff097          	auipc	ra,0xfffff
    80000fd4:	73c080e7          	jalr	1852(ra) # 8000070c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fd8:	4681                	li	a3,0
    80000fda:	4605                	li	a2,1
    80000fdc:	020005b7          	lui	a1,0x2000
    80000fe0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fe2:	05b6                	slli	a1,a1,0xd
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	fffff097          	auipc	ra,0xfffff
    80000fea:	726080e7          	jalr	1830(ra) # 8000070c <uvmunmap>
  uvmfree(pagetable, sz);
    80000fee:	85ca                	mv	a1,s2
    80000ff0:	8526                	mv	a0,s1
    80000ff2:	00000097          	auipc	ra,0x0
    80000ff6:	9e4080e7          	jalr	-1564(ra) # 800009d6 <uvmfree>
}
    80000ffa:	60e2                	ld	ra,24(sp)
    80000ffc:	6442                	ld	s0,16(sp)
    80000ffe:	64a2                	ld	s1,8(sp)
    80001000:	6902                	ld	s2,0(sp)
    80001002:	6105                	addi	sp,sp,32
    80001004:	8082                	ret

0000000080001006 <freeproc>:
{
    80001006:	1101                	addi	sp,sp,-32
    80001008:	ec06                	sd	ra,24(sp)
    8000100a:	e822                	sd	s0,16(sp)
    8000100c:	e426                	sd	s1,8(sp)
    8000100e:	1000                	addi	s0,sp,32
    80001010:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001012:	6d28                	ld	a0,88(a0)
    80001014:	c509                	beqz	a0,8000101e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001016:	fffff097          	auipc	ra,0xfffff
    8000101a:	006080e7          	jalr	6(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000101e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001022:	68a8                	ld	a0,80(s1)
    80001024:	c511                	beqz	a0,80001030 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001026:	64ac                	ld	a1,72(s1)
    80001028:	00000097          	auipc	ra,0x0
    8000102c:	f8c080e7          	jalr	-116(ra) # 80000fb4 <proc_freepagetable>
  p->pagetable = 0;
    80001030:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001034:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001038:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000103c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001040:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001044:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001048:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000104c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001050:	0004ac23          	sw	zero,24(s1)
}
    80001054:	60e2                	ld	ra,24(sp)
    80001056:	6442                	ld	s0,16(sp)
    80001058:	64a2                	ld	s1,8(sp)
    8000105a:	6105                	addi	sp,sp,32
    8000105c:	8082                	ret

000000008000105e <allocproc>:
{
    8000105e:	1101                	addi	sp,sp,-32
    80001060:	ec06                	sd	ra,24(sp)
    80001062:	e822                	sd	s0,16(sp)
    80001064:	e426                	sd	s1,8(sp)
    80001066:	e04a                	sd	s2,0(sp)
    80001068:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000106a:	00008497          	auipc	s1,0x8
    8000106e:	cd648493          	addi	s1,s1,-810 # 80008d40 <proc>
    80001072:	00009917          	auipc	s2,0x9
    80001076:	ade90913          	addi	s2,s2,-1314 # 80009b50 <tickslock>
    acquire(&p->lock);
    8000107a:	8526                	mv	a0,s1
    8000107c:	00005097          	auipc	ra,0x5
    80001080:	328080e7          	jalr	808(ra) # 800063a4 <acquire>
    if(p->state == UNUSED) {
    80001084:	4c9c                	lw	a5,24(s1)
    80001086:	c395                	beqz	a5,800010aa <allocproc+0x4c>
      release(&p->lock);
    80001088:	8526                	mv	a0,s1
    8000108a:	00005097          	auipc	ra,0x5
    8000108e:	3ce080e7          	jalr	974(ra) # 80006458 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001092:	16848493          	addi	s1,s1,360
    80001096:	ff2492e3          	bne	s1,s2,8000107a <allocproc+0x1c>
  return 0;
    8000109a:	4481                	li	s1,0
}
    8000109c:	8526                	mv	a0,s1
    8000109e:	60e2                	ld	ra,24(sp)
    800010a0:	6442                	ld	s0,16(sp)
    800010a2:	64a2                	ld	s1,8(sp)
    800010a4:	6902                	ld	s2,0(sp)
    800010a6:	6105                	addi	sp,sp,32
    800010a8:	8082                	ret
  p->pid = allocpid();
    800010aa:	00000097          	auipc	ra,0x0
    800010ae:	e28080e7          	jalr	-472(ra) # 80000ed2 <allocpid>
    800010b2:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010b4:	4785                	li	a5,1
    800010b6:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010b8:	fffff097          	auipc	ra,0xfffff
    800010bc:	062080e7          	jalr	98(ra) # 8000011a <kalloc>
    800010c0:	892a                	mv	s2,a0
    800010c2:	eca8                	sd	a0,88(s1)
    800010c4:	cd05                	beqz	a0,800010fc <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010c6:	8526                	mv	a0,s1
    800010c8:	00000097          	auipc	ra,0x0
    800010cc:	e50080e7          	jalr	-432(ra) # 80000f18 <proc_pagetable>
    800010d0:	892a                	mv	s2,a0
    800010d2:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010d4:	c121                	beqz	a0,80001114 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010d6:	07000613          	li	a2,112
    800010da:	4581                	li	a1,0
    800010dc:	06048513          	addi	a0,s1,96
    800010e0:	fffff097          	auipc	ra,0xfffff
    800010e4:	09a080e7          	jalr	154(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800010e8:	00000797          	auipc	a5,0x0
    800010ec:	da478793          	addi	a5,a5,-604 # 80000e8c <forkret>
    800010f0:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010f2:	60bc                	ld	a5,64(s1)
    800010f4:	6705                	lui	a4,0x1
    800010f6:	97ba                	add	a5,a5,a4
    800010f8:	f4bc                	sd	a5,104(s1)
  return p;
    800010fa:	b74d                	j	8000109c <allocproc+0x3e>
    freeproc(p);
    800010fc:	8526                	mv	a0,s1
    800010fe:	00000097          	auipc	ra,0x0
    80001102:	f08080e7          	jalr	-248(ra) # 80001006 <freeproc>
    release(&p->lock);
    80001106:	8526                	mv	a0,s1
    80001108:	00005097          	auipc	ra,0x5
    8000110c:	350080e7          	jalr	848(ra) # 80006458 <release>
    return 0;
    80001110:	84ca                	mv	s1,s2
    80001112:	b769                	j	8000109c <allocproc+0x3e>
    freeproc(p);
    80001114:	8526                	mv	a0,s1
    80001116:	00000097          	auipc	ra,0x0
    8000111a:	ef0080e7          	jalr	-272(ra) # 80001006 <freeproc>
    release(&p->lock);
    8000111e:	8526                	mv	a0,s1
    80001120:	00005097          	auipc	ra,0x5
    80001124:	338080e7          	jalr	824(ra) # 80006458 <release>
    return 0;
    80001128:	84ca                	mv	s1,s2
    8000112a:	bf8d                	j	8000109c <allocproc+0x3e>

000000008000112c <userinit>:
{
    8000112c:	1101                	addi	sp,sp,-32
    8000112e:	ec06                	sd	ra,24(sp)
    80001130:	e822                	sd	s0,16(sp)
    80001132:	e426                	sd	s1,8(sp)
    80001134:	1000                	addi	s0,sp,32
  p = allocproc();
    80001136:	00000097          	auipc	ra,0x0
    8000113a:	f28080e7          	jalr	-216(ra) # 8000105e <allocproc>
    8000113e:	84aa                	mv	s1,a0
  initproc = p;
    80001140:	00007797          	auipc	a5,0x7
    80001144:	78a7b823          	sd	a0,1936(a5) # 800088d0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001148:	03400613          	li	a2,52
    8000114c:	00007597          	auipc	a1,0x7
    80001150:	71458593          	addi	a1,a1,1812 # 80008860 <initcode>
    80001154:	6928                	ld	a0,80(a0)
    80001156:	fffff097          	auipc	ra,0xfffff
    8000115a:	6a8080e7          	jalr	1704(ra) # 800007fe <uvmfirst>
  p->sz = PGSIZE;
    8000115e:	6785                	lui	a5,0x1
    80001160:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001162:	6cb8                	ld	a4,88(s1)
    80001164:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001168:	6cb8                	ld	a4,88(s1)
    8000116a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000116c:	4641                	li	a2,16
    8000116e:	00007597          	auipc	a1,0x7
    80001172:	01258593          	addi	a1,a1,18 # 80008180 <etext+0x180>
    80001176:	15848513          	addi	a0,s1,344
    8000117a:	fffff097          	auipc	ra,0xfffff
    8000117e:	14a080e7          	jalr	330(ra) # 800002c4 <safestrcpy>
  p->cwd = namei("/");
    80001182:	00007517          	auipc	a0,0x7
    80001186:	00e50513          	addi	a0,a0,14 # 80008190 <etext+0x190>
    8000118a:	00002097          	auipc	ra,0x2
    8000118e:	28e080e7          	jalr	654(ra) # 80003418 <namei>
    80001192:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001196:	478d                	li	a5,3
    80001198:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000119a:	8526                	mv	a0,s1
    8000119c:	00005097          	auipc	ra,0x5
    800011a0:	2bc080e7          	jalr	700(ra) # 80006458 <release>
}
    800011a4:	60e2                	ld	ra,24(sp)
    800011a6:	6442                	ld	s0,16(sp)
    800011a8:	64a2                	ld	s1,8(sp)
    800011aa:	6105                	addi	sp,sp,32
    800011ac:	8082                	ret

00000000800011ae <growproc>:
{
    800011ae:	1101                	addi	sp,sp,-32
    800011b0:	ec06                	sd	ra,24(sp)
    800011b2:	e822                	sd	s0,16(sp)
    800011b4:	e426                	sd	s1,8(sp)
    800011b6:	e04a                	sd	s2,0(sp)
    800011b8:	1000                	addi	s0,sp,32
    800011ba:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800011bc:	00000097          	auipc	ra,0x0
    800011c0:	c98080e7          	jalr	-872(ra) # 80000e54 <myproc>
    800011c4:	84aa                	mv	s1,a0
  sz = p->sz;
    800011c6:	652c                	ld	a1,72(a0)
  if(n > 0){
    800011c8:	01204c63          	bgtz	s2,800011e0 <growproc+0x32>
  } else if(n < 0){
    800011cc:	02094663          	bltz	s2,800011f8 <growproc+0x4a>
  p->sz = sz;
    800011d0:	e4ac                	sd	a1,72(s1)
  return 0;
    800011d2:	4501                	li	a0,0
}
    800011d4:	60e2                	ld	ra,24(sp)
    800011d6:	6442                	ld	s0,16(sp)
    800011d8:	64a2                	ld	s1,8(sp)
    800011da:	6902                	ld	s2,0(sp)
    800011dc:	6105                	addi	sp,sp,32
    800011de:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800011e0:	4691                	li	a3,4
    800011e2:	00b90633          	add	a2,s2,a1
    800011e6:	6928                	ld	a0,80(a0)
    800011e8:	fffff097          	auipc	ra,0xfffff
    800011ec:	6d0080e7          	jalr	1744(ra) # 800008b8 <uvmalloc>
    800011f0:	85aa                	mv	a1,a0
    800011f2:	fd79                	bnez	a0,800011d0 <growproc+0x22>
      return -1;
    800011f4:	557d                	li	a0,-1
    800011f6:	bff9                	j	800011d4 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011f8:	00b90633          	add	a2,s2,a1
    800011fc:	6928                	ld	a0,80(a0)
    800011fe:	fffff097          	auipc	ra,0xfffff
    80001202:	672080e7          	jalr	1650(ra) # 80000870 <uvmdealloc>
    80001206:	85aa                	mv	a1,a0
    80001208:	b7e1                	j	800011d0 <growproc+0x22>

000000008000120a <fork>:
{
    8000120a:	7139                	addi	sp,sp,-64
    8000120c:	fc06                	sd	ra,56(sp)
    8000120e:	f822                	sd	s0,48(sp)
    80001210:	f426                	sd	s1,40(sp)
    80001212:	f04a                	sd	s2,32(sp)
    80001214:	ec4e                	sd	s3,24(sp)
    80001216:	e852                	sd	s4,16(sp)
    80001218:	e456                	sd	s5,8(sp)
    8000121a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000121c:	00000097          	auipc	ra,0x0
    80001220:	c38080e7          	jalr	-968(ra) # 80000e54 <myproc>
    80001224:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001226:	00000097          	auipc	ra,0x0
    8000122a:	e38080e7          	jalr	-456(ra) # 8000105e <allocproc>
    8000122e:	10050c63          	beqz	a0,80001346 <fork+0x13c>
    80001232:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001234:	048ab603          	ld	a2,72(s5)
    80001238:	692c                	ld	a1,80(a0)
    8000123a:	050ab503          	ld	a0,80(s5)
    8000123e:	fffff097          	auipc	ra,0xfffff
    80001242:	7d2080e7          	jalr	2002(ra) # 80000a10 <uvmcopy>
    80001246:	04054863          	bltz	a0,80001296 <fork+0x8c>
  np->sz = p->sz;
    8000124a:	048ab783          	ld	a5,72(s5)
    8000124e:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001252:	058ab683          	ld	a3,88(s5)
    80001256:	87b6                	mv	a5,a3
    80001258:	058a3703          	ld	a4,88(s4)
    8000125c:	12068693          	addi	a3,a3,288
    80001260:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001264:	6788                	ld	a0,8(a5)
    80001266:	6b8c                	ld	a1,16(a5)
    80001268:	6f90                	ld	a2,24(a5)
    8000126a:	01073023          	sd	a6,0(a4)
    8000126e:	e708                	sd	a0,8(a4)
    80001270:	eb0c                	sd	a1,16(a4)
    80001272:	ef10                	sd	a2,24(a4)
    80001274:	02078793          	addi	a5,a5,32
    80001278:	02070713          	addi	a4,a4,32
    8000127c:	fed792e3          	bne	a5,a3,80001260 <fork+0x56>
  np->trapframe->a0 = 0;
    80001280:	058a3783          	ld	a5,88(s4)
    80001284:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001288:	0d0a8493          	addi	s1,s5,208
    8000128c:	0d0a0913          	addi	s2,s4,208
    80001290:	150a8993          	addi	s3,s5,336
    80001294:	a00d                	j	800012b6 <fork+0xac>
    freeproc(np);
    80001296:	8552                	mv	a0,s4
    80001298:	00000097          	auipc	ra,0x0
    8000129c:	d6e080e7          	jalr	-658(ra) # 80001006 <freeproc>
    release(&np->lock);
    800012a0:	8552                	mv	a0,s4
    800012a2:	00005097          	auipc	ra,0x5
    800012a6:	1b6080e7          	jalr	438(ra) # 80006458 <release>
    return -1;
    800012aa:	597d                	li	s2,-1
    800012ac:	a059                	j	80001332 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    800012ae:	04a1                	addi	s1,s1,8
    800012b0:	0921                	addi	s2,s2,8
    800012b2:	01348b63          	beq	s1,s3,800012c8 <fork+0xbe>
    if(p->ofile[i])
    800012b6:	6088                	ld	a0,0(s1)
    800012b8:	d97d                	beqz	a0,800012ae <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800012ba:	00002097          	auipc	ra,0x2
    800012be:	7f4080e7          	jalr	2036(ra) # 80003aae <filedup>
    800012c2:	00a93023          	sd	a0,0(s2)
    800012c6:	b7e5                	j	800012ae <fork+0xa4>
  np->cwd = idup(p->cwd);
    800012c8:	150ab503          	ld	a0,336(s5)
    800012cc:	00002097          	auipc	ra,0x2
    800012d0:	8ba080e7          	jalr	-1862(ra) # 80002b86 <idup>
    800012d4:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012d8:	4641                	li	a2,16
    800012da:	158a8593          	addi	a1,s5,344
    800012de:	158a0513          	addi	a0,s4,344
    800012e2:	fffff097          	auipc	ra,0xfffff
    800012e6:	fe2080e7          	jalr	-30(ra) # 800002c4 <safestrcpy>
  pid = np->pid;
    800012ea:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800012ee:	8552                	mv	a0,s4
    800012f0:	00005097          	auipc	ra,0x5
    800012f4:	168080e7          	jalr	360(ra) # 80006458 <release>
  acquire(&wait_lock);
    800012f8:	00007497          	auipc	s1,0x7
    800012fc:	63048493          	addi	s1,s1,1584 # 80008928 <wait_lock>
    80001300:	8526                	mv	a0,s1
    80001302:	00005097          	auipc	ra,0x5
    80001306:	0a2080e7          	jalr	162(ra) # 800063a4 <acquire>
  np->parent = p;
    8000130a:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000130e:	8526                	mv	a0,s1
    80001310:	00005097          	auipc	ra,0x5
    80001314:	148080e7          	jalr	328(ra) # 80006458 <release>
  acquire(&np->lock);
    80001318:	8552                	mv	a0,s4
    8000131a:	00005097          	auipc	ra,0x5
    8000131e:	08a080e7          	jalr	138(ra) # 800063a4 <acquire>
  np->state = RUNNABLE;
    80001322:	478d                	li	a5,3
    80001324:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001328:	8552                	mv	a0,s4
    8000132a:	00005097          	auipc	ra,0x5
    8000132e:	12e080e7          	jalr	302(ra) # 80006458 <release>
}
    80001332:	854a                	mv	a0,s2
    80001334:	70e2                	ld	ra,56(sp)
    80001336:	7442                	ld	s0,48(sp)
    80001338:	74a2                	ld	s1,40(sp)
    8000133a:	7902                	ld	s2,32(sp)
    8000133c:	69e2                	ld	s3,24(sp)
    8000133e:	6a42                	ld	s4,16(sp)
    80001340:	6aa2                	ld	s5,8(sp)
    80001342:	6121                	addi	sp,sp,64
    80001344:	8082                	ret
    return -1;
    80001346:	597d                	li	s2,-1
    80001348:	b7ed                	j	80001332 <fork+0x128>

000000008000134a <scheduler>:
{
    8000134a:	7139                	addi	sp,sp,-64
    8000134c:	fc06                	sd	ra,56(sp)
    8000134e:	f822                	sd	s0,48(sp)
    80001350:	f426                	sd	s1,40(sp)
    80001352:	f04a                	sd	s2,32(sp)
    80001354:	ec4e                	sd	s3,24(sp)
    80001356:	e852                	sd	s4,16(sp)
    80001358:	e456                	sd	s5,8(sp)
    8000135a:	e05a                	sd	s6,0(sp)
    8000135c:	0080                	addi	s0,sp,64
    8000135e:	8792                	mv	a5,tp
  int id = r_tp();
    80001360:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001362:	00779a93          	slli	s5,a5,0x7
    80001366:	00007717          	auipc	a4,0x7
    8000136a:	5aa70713          	addi	a4,a4,1450 # 80008910 <pid_lock>
    8000136e:	9756                	add	a4,a4,s5
    80001370:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001374:	00007717          	auipc	a4,0x7
    80001378:	5d470713          	addi	a4,a4,1492 # 80008948 <cpus+0x8>
    8000137c:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000137e:	498d                	li	s3,3
        p->state = RUNNING;
    80001380:	4b11                	li	s6,4
        c->proc = p;
    80001382:	079e                	slli	a5,a5,0x7
    80001384:	00007a17          	auipc	s4,0x7
    80001388:	58ca0a13          	addi	s4,s4,1420 # 80008910 <pid_lock>
    8000138c:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000138e:	00008917          	auipc	s2,0x8
    80001392:	7c290913          	addi	s2,s2,1986 # 80009b50 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001396:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000139a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000139e:	10079073          	csrw	sstatus,a5
    800013a2:	00008497          	auipc	s1,0x8
    800013a6:	99e48493          	addi	s1,s1,-1634 # 80008d40 <proc>
    800013aa:	a811                	j	800013be <scheduler+0x74>
      release(&p->lock);
    800013ac:	8526                	mv	a0,s1
    800013ae:	00005097          	auipc	ra,0x5
    800013b2:	0aa080e7          	jalr	170(ra) # 80006458 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013b6:	16848493          	addi	s1,s1,360
    800013ba:	fd248ee3          	beq	s1,s2,80001396 <scheduler+0x4c>
      acquire(&p->lock);
    800013be:	8526                	mv	a0,s1
    800013c0:	00005097          	auipc	ra,0x5
    800013c4:	fe4080e7          	jalr	-28(ra) # 800063a4 <acquire>
      if(p->state == RUNNABLE) {
    800013c8:	4c9c                	lw	a5,24(s1)
    800013ca:	ff3791e3          	bne	a5,s3,800013ac <scheduler+0x62>
        p->state = RUNNING;
    800013ce:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013d2:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013d6:	06048593          	addi	a1,s1,96
    800013da:	8556                	mv	a0,s5
    800013dc:	00000097          	auipc	ra,0x0
    800013e0:	684080e7          	jalr	1668(ra) # 80001a60 <swtch>
        c->proc = 0;
    800013e4:	020a3823          	sd	zero,48(s4)
    800013e8:	b7d1                	j	800013ac <scheduler+0x62>

00000000800013ea <sched>:
{
    800013ea:	7179                	addi	sp,sp,-48
    800013ec:	f406                	sd	ra,40(sp)
    800013ee:	f022                	sd	s0,32(sp)
    800013f0:	ec26                	sd	s1,24(sp)
    800013f2:	e84a                	sd	s2,16(sp)
    800013f4:	e44e                	sd	s3,8(sp)
    800013f6:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013f8:	00000097          	auipc	ra,0x0
    800013fc:	a5c080e7          	jalr	-1444(ra) # 80000e54 <myproc>
    80001400:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001402:	00005097          	auipc	ra,0x5
    80001406:	f28080e7          	jalr	-216(ra) # 8000632a <holding>
    8000140a:	c93d                	beqz	a0,80001480 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000140c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000140e:	2781                	sext.w	a5,a5
    80001410:	079e                	slli	a5,a5,0x7
    80001412:	00007717          	auipc	a4,0x7
    80001416:	4fe70713          	addi	a4,a4,1278 # 80008910 <pid_lock>
    8000141a:	97ba                	add	a5,a5,a4
    8000141c:	0a87a703          	lw	a4,168(a5)
    80001420:	4785                	li	a5,1
    80001422:	06f71763          	bne	a4,a5,80001490 <sched+0xa6>
  if(p->state == RUNNING)
    80001426:	4c98                	lw	a4,24(s1)
    80001428:	4791                	li	a5,4
    8000142a:	06f70b63          	beq	a4,a5,800014a0 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000142e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001432:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001434:	efb5                	bnez	a5,800014b0 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001436:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001438:	00007917          	auipc	s2,0x7
    8000143c:	4d890913          	addi	s2,s2,1240 # 80008910 <pid_lock>
    80001440:	2781                	sext.w	a5,a5
    80001442:	079e                	slli	a5,a5,0x7
    80001444:	97ca                	add	a5,a5,s2
    80001446:	0ac7a983          	lw	s3,172(a5)
    8000144a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000144c:	2781                	sext.w	a5,a5
    8000144e:	079e                	slli	a5,a5,0x7
    80001450:	00007597          	auipc	a1,0x7
    80001454:	4f858593          	addi	a1,a1,1272 # 80008948 <cpus+0x8>
    80001458:	95be                	add	a1,a1,a5
    8000145a:	06048513          	addi	a0,s1,96
    8000145e:	00000097          	auipc	ra,0x0
    80001462:	602080e7          	jalr	1538(ra) # 80001a60 <swtch>
    80001466:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001468:	2781                	sext.w	a5,a5
    8000146a:	079e                	slli	a5,a5,0x7
    8000146c:	993e                	add	s2,s2,a5
    8000146e:	0b392623          	sw	s3,172(s2)
}
    80001472:	70a2                	ld	ra,40(sp)
    80001474:	7402                	ld	s0,32(sp)
    80001476:	64e2                	ld	s1,24(sp)
    80001478:	6942                	ld	s2,16(sp)
    8000147a:	69a2                	ld	s3,8(sp)
    8000147c:	6145                	addi	sp,sp,48
    8000147e:	8082                	ret
    panic("sched p->lock");
    80001480:	00007517          	auipc	a0,0x7
    80001484:	d1850513          	addi	a0,a0,-744 # 80008198 <etext+0x198>
    80001488:	00005097          	auipc	ra,0x5
    8000148c:	9e4080e7          	jalr	-1564(ra) # 80005e6c <panic>
    panic("sched locks");
    80001490:	00007517          	auipc	a0,0x7
    80001494:	d1850513          	addi	a0,a0,-744 # 800081a8 <etext+0x1a8>
    80001498:	00005097          	auipc	ra,0x5
    8000149c:	9d4080e7          	jalr	-1580(ra) # 80005e6c <panic>
    panic("sched running");
    800014a0:	00007517          	auipc	a0,0x7
    800014a4:	d1850513          	addi	a0,a0,-744 # 800081b8 <etext+0x1b8>
    800014a8:	00005097          	auipc	ra,0x5
    800014ac:	9c4080e7          	jalr	-1596(ra) # 80005e6c <panic>
    panic("sched interruptible");
    800014b0:	00007517          	auipc	a0,0x7
    800014b4:	d1850513          	addi	a0,a0,-744 # 800081c8 <etext+0x1c8>
    800014b8:	00005097          	auipc	ra,0x5
    800014bc:	9b4080e7          	jalr	-1612(ra) # 80005e6c <panic>

00000000800014c0 <yield>:
{
    800014c0:	1101                	addi	sp,sp,-32
    800014c2:	ec06                	sd	ra,24(sp)
    800014c4:	e822                	sd	s0,16(sp)
    800014c6:	e426                	sd	s1,8(sp)
    800014c8:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014ca:	00000097          	auipc	ra,0x0
    800014ce:	98a080e7          	jalr	-1654(ra) # 80000e54 <myproc>
    800014d2:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014d4:	00005097          	auipc	ra,0x5
    800014d8:	ed0080e7          	jalr	-304(ra) # 800063a4 <acquire>
  p->state = RUNNABLE;
    800014dc:	478d                	li	a5,3
    800014de:	cc9c                	sw	a5,24(s1)
  sched();
    800014e0:	00000097          	auipc	ra,0x0
    800014e4:	f0a080e7          	jalr	-246(ra) # 800013ea <sched>
  release(&p->lock);
    800014e8:	8526                	mv	a0,s1
    800014ea:	00005097          	auipc	ra,0x5
    800014ee:	f6e080e7          	jalr	-146(ra) # 80006458 <release>
}
    800014f2:	60e2                	ld	ra,24(sp)
    800014f4:	6442                	ld	s0,16(sp)
    800014f6:	64a2                	ld	s1,8(sp)
    800014f8:	6105                	addi	sp,sp,32
    800014fa:	8082                	ret

00000000800014fc <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800014fc:	7179                	addi	sp,sp,-48
    800014fe:	f406                	sd	ra,40(sp)
    80001500:	f022                	sd	s0,32(sp)
    80001502:	ec26                	sd	s1,24(sp)
    80001504:	e84a                	sd	s2,16(sp)
    80001506:	e44e                	sd	s3,8(sp)
    80001508:	1800                	addi	s0,sp,48
    8000150a:	89aa                	mv	s3,a0
    8000150c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000150e:	00000097          	auipc	ra,0x0
    80001512:	946080e7          	jalr	-1722(ra) # 80000e54 <myproc>
    80001516:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001518:	00005097          	auipc	ra,0x5
    8000151c:	e8c080e7          	jalr	-372(ra) # 800063a4 <acquire>
  release(lk);
    80001520:	854a                	mv	a0,s2
    80001522:	00005097          	auipc	ra,0x5
    80001526:	f36080e7          	jalr	-202(ra) # 80006458 <release>

  // Go to sleep.
  p->chan = chan;
    8000152a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000152e:	4789                	li	a5,2
    80001530:	cc9c                	sw	a5,24(s1)

  sched();
    80001532:	00000097          	auipc	ra,0x0
    80001536:	eb8080e7          	jalr	-328(ra) # 800013ea <sched>

  // Tidy up.
  p->chan = 0;
    8000153a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000153e:	8526                	mv	a0,s1
    80001540:	00005097          	auipc	ra,0x5
    80001544:	f18080e7          	jalr	-232(ra) # 80006458 <release>
  acquire(lk);
    80001548:	854a                	mv	a0,s2
    8000154a:	00005097          	auipc	ra,0x5
    8000154e:	e5a080e7          	jalr	-422(ra) # 800063a4 <acquire>
}
    80001552:	70a2                	ld	ra,40(sp)
    80001554:	7402                	ld	s0,32(sp)
    80001556:	64e2                	ld	s1,24(sp)
    80001558:	6942                	ld	s2,16(sp)
    8000155a:	69a2                	ld	s3,8(sp)
    8000155c:	6145                	addi	sp,sp,48
    8000155e:	8082                	ret

0000000080001560 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001560:	7139                	addi	sp,sp,-64
    80001562:	fc06                	sd	ra,56(sp)
    80001564:	f822                	sd	s0,48(sp)
    80001566:	f426                	sd	s1,40(sp)
    80001568:	f04a                	sd	s2,32(sp)
    8000156a:	ec4e                	sd	s3,24(sp)
    8000156c:	e852                	sd	s4,16(sp)
    8000156e:	e456                	sd	s5,8(sp)
    80001570:	0080                	addi	s0,sp,64
    80001572:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001574:	00007497          	auipc	s1,0x7
    80001578:	7cc48493          	addi	s1,s1,1996 # 80008d40 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000157c:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000157e:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001580:	00008917          	auipc	s2,0x8
    80001584:	5d090913          	addi	s2,s2,1488 # 80009b50 <tickslock>
    80001588:	a811                	j	8000159c <wakeup+0x3c>
      }
      release(&p->lock);
    8000158a:	8526                	mv	a0,s1
    8000158c:	00005097          	auipc	ra,0x5
    80001590:	ecc080e7          	jalr	-308(ra) # 80006458 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001594:	16848493          	addi	s1,s1,360
    80001598:	03248663          	beq	s1,s2,800015c4 <wakeup+0x64>
    if(p != myproc()){
    8000159c:	00000097          	auipc	ra,0x0
    800015a0:	8b8080e7          	jalr	-1864(ra) # 80000e54 <myproc>
    800015a4:	fea488e3          	beq	s1,a0,80001594 <wakeup+0x34>
      acquire(&p->lock);
    800015a8:	8526                	mv	a0,s1
    800015aa:	00005097          	auipc	ra,0x5
    800015ae:	dfa080e7          	jalr	-518(ra) # 800063a4 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800015b2:	4c9c                	lw	a5,24(s1)
    800015b4:	fd379be3          	bne	a5,s3,8000158a <wakeup+0x2a>
    800015b8:	709c                	ld	a5,32(s1)
    800015ba:	fd4798e3          	bne	a5,s4,8000158a <wakeup+0x2a>
        p->state = RUNNABLE;
    800015be:	0154ac23          	sw	s5,24(s1)
    800015c2:	b7e1                	j	8000158a <wakeup+0x2a>
    }
  }
}
    800015c4:	70e2                	ld	ra,56(sp)
    800015c6:	7442                	ld	s0,48(sp)
    800015c8:	74a2                	ld	s1,40(sp)
    800015ca:	7902                	ld	s2,32(sp)
    800015cc:	69e2                	ld	s3,24(sp)
    800015ce:	6a42                	ld	s4,16(sp)
    800015d0:	6aa2                	ld	s5,8(sp)
    800015d2:	6121                	addi	sp,sp,64
    800015d4:	8082                	ret

00000000800015d6 <reparent>:
{
    800015d6:	7179                	addi	sp,sp,-48
    800015d8:	f406                	sd	ra,40(sp)
    800015da:	f022                	sd	s0,32(sp)
    800015dc:	ec26                	sd	s1,24(sp)
    800015de:	e84a                	sd	s2,16(sp)
    800015e0:	e44e                	sd	s3,8(sp)
    800015e2:	e052                	sd	s4,0(sp)
    800015e4:	1800                	addi	s0,sp,48
    800015e6:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015e8:	00007497          	auipc	s1,0x7
    800015ec:	75848493          	addi	s1,s1,1880 # 80008d40 <proc>
      pp->parent = initproc;
    800015f0:	00007a17          	auipc	s4,0x7
    800015f4:	2e0a0a13          	addi	s4,s4,736 # 800088d0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015f8:	00008997          	auipc	s3,0x8
    800015fc:	55898993          	addi	s3,s3,1368 # 80009b50 <tickslock>
    80001600:	a029                	j	8000160a <reparent+0x34>
    80001602:	16848493          	addi	s1,s1,360
    80001606:	01348d63          	beq	s1,s3,80001620 <reparent+0x4a>
    if(pp->parent == p){
    8000160a:	7c9c                	ld	a5,56(s1)
    8000160c:	ff279be3          	bne	a5,s2,80001602 <reparent+0x2c>
      pp->parent = initproc;
    80001610:	000a3503          	ld	a0,0(s4)
    80001614:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001616:	00000097          	auipc	ra,0x0
    8000161a:	f4a080e7          	jalr	-182(ra) # 80001560 <wakeup>
    8000161e:	b7d5                	j	80001602 <reparent+0x2c>
}
    80001620:	70a2                	ld	ra,40(sp)
    80001622:	7402                	ld	s0,32(sp)
    80001624:	64e2                	ld	s1,24(sp)
    80001626:	6942                	ld	s2,16(sp)
    80001628:	69a2                	ld	s3,8(sp)
    8000162a:	6a02                	ld	s4,0(sp)
    8000162c:	6145                	addi	sp,sp,48
    8000162e:	8082                	ret

0000000080001630 <exit>:
{
    80001630:	7179                	addi	sp,sp,-48
    80001632:	f406                	sd	ra,40(sp)
    80001634:	f022                	sd	s0,32(sp)
    80001636:	ec26                	sd	s1,24(sp)
    80001638:	e84a                	sd	s2,16(sp)
    8000163a:	e44e                	sd	s3,8(sp)
    8000163c:	e052                	sd	s4,0(sp)
    8000163e:	1800                	addi	s0,sp,48
    80001640:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001642:	00000097          	auipc	ra,0x0
    80001646:	812080e7          	jalr	-2030(ra) # 80000e54 <myproc>
    8000164a:	89aa                	mv	s3,a0
  if(p == initproc)
    8000164c:	00007797          	auipc	a5,0x7
    80001650:	2847b783          	ld	a5,644(a5) # 800088d0 <initproc>
    80001654:	0d050493          	addi	s1,a0,208
    80001658:	15050913          	addi	s2,a0,336
    8000165c:	02a79363          	bne	a5,a0,80001682 <exit+0x52>
    panic("init exiting");
    80001660:	00007517          	auipc	a0,0x7
    80001664:	b8050513          	addi	a0,a0,-1152 # 800081e0 <etext+0x1e0>
    80001668:	00005097          	auipc	ra,0x5
    8000166c:	804080e7          	jalr	-2044(ra) # 80005e6c <panic>
      fileclose(f);
    80001670:	00002097          	auipc	ra,0x2
    80001674:	490080e7          	jalr	1168(ra) # 80003b00 <fileclose>
      p->ofile[fd] = 0;
    80001678:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000167c:	04a1                	addi	s1,s1,8
    8000167e:	01248563          	beq	s1,s2,80001688 <exit+0x58>
    if(p->ofile[fd]){
    80001682:	6088                	ld	a0,0(s1)
    80001684:	f575                	bnez	a0,80001670 <exit+0x40>
    80001686:	bfdd                	j	8000167c <exit+0x4c>
  begin_op();
    80001688:	00002097          	auipc	ra,0x2
    8000168c:	fb0080e7          	jalr	-80(ra) # 80003638 <begin_op>
  iput(p->cwd);
    80001690:	1509b503          	ld	a0,336(s3)
    80001694:	00001097          	auipc	ra,0x1
    80001698:	790080e7          	jalr	1936(ra) # 80002e24 <iput>
  end_op();
    8000169c:	00002097          	auipc	ra,0x2
    800016a0:	01a080e7          	jalr	26(ra) # 800036b6 <end_op>
  p->cwd = 0;
    800016a4:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800016a8:	00007497          	auipc	s1,0x7
    800016ac:	28048493          	addi	s1,s1,640 # 80008928 <wait_lock>
    800016b0:	8526                	mv	a0,s1
    800016b2:	00005097          	auipc	ra,0x5
    800016b6:	cf2080e7          	jalr	-782(ra) # 800063a4 <acquire>
  reparent(p);
    800016ba:	854e                	mv	a0,s3
    800016bc:	00000097          	auipc	ra,0x0
    800016c0:	f1a080e7          	jalr	-230(ra) # 800015d6 <reparent>
  wakeup(p->parent);
    800016c4:	0389b503          	ld	a0,56(s3)
    800016c8:	00000097          	auipc	ra,0x0
    800016cc:	e98080e7          	jalr	-360(ra) # 80001560 <wakeup>
  acquire(&p->lock);
    800016d0:	854e                	mv	a0,s3
    800016d2:	00005097          	auipc	ra,0x5
    800016d6:	cd2080e7          	jalr	-814(ra) # 800063a4 <acquire>
  p->xstate = status;
    800016da:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800016de:	4795                	li	a5,5
    800016e0:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800016e4:	8526                	mv	a0,s1
    800016e6:	00005097          	auipc	ra,0x5
    800016ea:	d72080e7          	jalr	-654(ra) # 80006458 <release>
  sched();
    800016ee:	00000097          	auipc	ra,0x0
    800016f2:	cfc080e7          	jalr	-772(ra) # 800013ea <sched>
  panic("zombie exit");
    800016f6:	00007517          	auipc	a0,0x7
    800016fa:	afa50513          	addi	a0,a0,-1286 # 800081f0 <etext+0x1f0>
    800016fe:	00004097          	auipc	ra,0x4
    80001702:	76e080e7          	jalr	1902(ra) # 80005e6c <panic>

0000000080001706 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001706:	7179                	addi	sp,sp,-48
    80001708:	f406                	sd	ra,40(sp)
    8000170a:	f022                	sd	s0,32(sp)
    8000170c:	ec26                	sd	s1,24(sp)
    8000170e:	e84a                	sd	s2,16(sp)
    80001710:	e44e                	sd	s3,8(sp)
    80001712:	1800                	addi	s0,sp,48
    80001714:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001716:	00007497          	auipc	s1,0x7
    8000171a:	62a48493          	addi	s1,s1,1578 # 80008d40 <proc>
    8000171e:	00008997          	auipc	s3,0x8
    80001722:	43298993          	addi	s3,s3,1074 # 80009b50 <tickslock>
    acquire(&p->lock);
    80001726:	8526                	mv	a0,s1
    80001728:	00005097          	auipc	ra,0x5
    8000172c:	c7c080e7          	jalr	-900(ra) # 800063a4 <acquire>
    if(p->pid == pid){
    80001730:	589c                	lw	a5,48(s1)
    80001732:	03278363          	beq	a5,s2,80001758 <kill+0x52>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001736:	8526                	mv	a0,s1
    80001738:	00005097          	auipc	ra,0x5
    8000173c:	d20080e7          	jalr	-736(ra) # 80006458 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001740:	16848493          	addi	s1,s1,360
    80001744:	ff3491e3          	bne	s1,s3,80001726 <kill+0x20>
  }
  return -1;
    80001748:	557d                	li	a0,-1
}
    8000174a:	70a2                	ld	ra,40(sp)
    8000174c:	7402                	ld	s0,32(sp)
    8000174e:	64e2                	ld	s1,24(sp)
    80001750:	6942                	ld	s2,16(sp)
    80001752:	69a2                	ld	s3,8(sp)
    80001754:	6145                	addi	sp,sp,48
    80001756:	8082                	ret
      p->killed = 1;
    80001758:	4785                	li	a5,1
    8000175a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000175c:	4c98                	lw	a4,24(s1)
    8000175e:	4789                	li	a5,2
    80001760:	00f70963          	beq	a4,a5,80001772 <kill+0x6c>
      release(&p->lock);
    80001764:	8526                	mv	a0,s1
    80001766:	00005097          	auipc	ra,0x5
    8000176a:	cf2080e7          	jalr	-782(ra) # 80006458 <release>
      return 0;
    8000176e:	4501                	li	a0,0
    80001770:	bfe9                	j	8000174a <kill+0x44>
        p->state = RUNNABLE;
    80001772:	478d                	li	a5,3
    80001774:	cc9c                	sw	a5,24(s1)
    80001776:	b7fd                	j	80001764 <kill+0x5e>

0000000080001778 <setkilled>:

void
setkilled(struct proc *p)
{
    80001778:	1101                	addi	sp,sp,-32
    8000177a:	ec06                	sd	ra,24(sp)
    8000177c:	e822                	sd	s0,16(sp)
    8000177e:	e426                	sd	s1,8(sp)
    80001780:	1000                	addi	s0,sp,32
    80001782:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001784:	00005097          	auipc	ra,0x5
    80001788:	c20080e7          	jalr	-992(ra) # 800063a4 <acquire>
  p->killed = 1;
    8000178c:	4785                	li	a5,1
    8000178e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001790:	8526                	mv	a0,s1
    80001792:	00005097          	auipc	ra,0x5
    80001796:	cc6080e7          	jalr	-826(ra) # 80006458 <release>
}
    8000179a:	60e2                	ld	ra,24(sp)
    8000179c:	6442                	ld	s0,16(sp)
    8000179e:	64a2                	ld	s1,8(sp)
    800017a0:	6105                	addi	sp,sp,32
    800017a2:	8082                	ret

00000000800017a4 <killed>:

int
killed(struct proc *p)
{
    800017a4:	1101                	addi	sp,sp,-32
    800017a6:	ec06                	sd	ra,24(sp)
    800017a8:	e822                	sd	s0,16(sp)
    800017aa:	e426                	sd	s1,8(sp)
    800017ac:	e04a                	sd	s2,0(sp)
    800017ae:	1000                	addi	s0,sp,32
    800017b0:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800017b2:	00005097          	auipc	ra,0x5
    800017b6:	bf2080e7          	jalr	-1038(ra) # 800063a4 <acquire>
  k = p->killed;
    800017ba:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017be:	8526                	mv	a0,s1
    800017c0:	00005097          	auipc	ra,0x5
    800017c4:	c98080e7          	jalr	-872(ra) # 80006458 <release>
  return k;
}
    800017c8:	854a                	mv	a0,s2
    800017ca:	60e2                	ld	ra,24(sp)
    800017cc:	6442                	ld	s0,16(sp)
    800017ce:	64a2                	ld	s1,8(sp)
    800017d0:	6902                	ld	s2,0(sp)
    800017d2:	6105                	addi	sp,sp,32
    800017d4:	8082                	ret

00000000800017d6 <wait>:
{
    800017d6:	715d                	addi	sp,sp,-80
    800017d8:	e486                	sd	ra,72(sp)
    800017da:	e0a2                	sd	s0,64(sp)
    800017dc:	fc26                	sd	s1,56(sp)
    800017de:	f84a                	sd	s2,48(sp)
    800017e0:	f44e                	sd	s3,40(sp)
    800017e2:	f052                	sd	s4,32(sp)
    800017e4:	ec56                	sd	s5,24(sp)
    800017e6:	e85a                	sd	s6,16(sp)
    800017e8:	e45e                	sd	s7,8(sp)
    800017ea:	e062                	sd	s8,0(sp)
    800017ec:	0880                	addi	s0,sp,80
    800017ee:	8aaa                	mv	s5,a0
  struct proc *p = myproc();
    800017f0:	fffff097          	auipc	ra,0xfffff
    800017f4:	664080e7          	jalr	1636(ra) # 80000e54 <myproc>
    800017f8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800017fa:	00007517          	auipc	a0,0x7
    800017fe:	12e50513          	addi	a0,a0,302 # 80008928 <wait_lock>
    80001802:	00005097          	auipc	ra,0x5
    80001806:	ba2080e7          	jalr	-1118(ra) # 800063a4 <acquire>
    havekids = 0;
    8000180a:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000180c:	4a15                	li	s4,5
        havekids = 1;
    8000180e:	4b05                	li	s6,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001810:	00008997          	auipc	s3,0x8
    80001814:	34098993          	addi	s3,s3,832 # 80009b50 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001818:	00007c17          	auipc	s8,0x7
    8000181c:	110c0c13          	addi	s8,s8,272 # 80008928 <wait_lock>
    havekids = 0;
    80001820:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001822:	00007497          	auipc	s1,0x7
    80001826:	51e48493          	addi	s1,s1,1310 # 80008d40 <proc>
    8000182a:	a0bd                	j	80001898 <wait+0xc2>
          pid = pp->pid;
    8000182c:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001830:	000a8e63          	beqz	s5,8000184c <wait+0x76>
    80001834:	4691                	li	a3,4
    80001836:	02c48613          	addi	a2,s1,44
    8000183a:	85d6                	mv	a1,s5
    8000183c:	05093503          	ld	a0,80(s2)
    80001840:	fffff097          	auipc	ra,0xfffff
    80001844:	2d4080e7          	jalr	724(ra) # 80000b14 <copyout>
    80001848:	02054563          	bltz	a0,80001872 <wait+0x9c>
          freeproc(pp);
    8000184c:	8526                	mv	a0,s1
    8000184e:	fffff097          	auipc	ra,0xfffff
    80001852:	7b8080e7          	jalr	1976(ra) # 80001006 <freeproc>
          release(&pp->lock);
    80001856:	8526                	mv	a0,s1
    80001858:	00005097          	auipc	ra,0x5
    8000185c:	c00080e7          	jalr	-1024(ra) # 80006458 <release>
          release(&wait_lock);
    80001860:	00007517          	auipc	a0,0x7
    80001864:	0c850513          	addi	a0,a0,200 # 80008928 <wait_lock>
    80001868:	00005097          	auipc	ra,0x5
    8000186c:	bf0080e7          	jalr	-1040(ra) # 80006458 <release>
          return pid;
    80001870:	a0b5                	j	800018dc <wait+0x106>
            release(&pp->lock);
    80001872:	8526                	mv	a0,s1
    80001874:	00005097          	auipc	ra,0x5
    80001878:	be4080e7          	jalr	-1052(ra) # 80006458 <release>
            release(&wait_lock);
    8000187c:	00007517          	auipc	a0,0x7
    80001880:	0ac50513          	addi	a0,a0,172 # 80008928 <wait_lock>
    80001884:	00005097          	auipc	ra,0x5
    80001888:	bd4080e7          	jalr	-1068(ra) # 80006458 <release>
            return -1;
    8000188c:	59fd                	li	s3,-1
    8000188e:	a0b9                	j	800018dc <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001890:	16848493          	addi	s1,s1,360
    80001894:	03348463          	beq	s1,s3,800018bc <wait+0xe6>
      if(pp->parent == p){
    80001898:	7c9c                	ld	a5,56(s1)
    8000189a:	ff279be3          	bne	a5,s2,80001890 <wait+0xba>
        acquire(&pp->lock);
    8000189e:	8526                	mv	a0,s1
    800018a0:	00005097          	auipc	ra,0x5
    800018a4:	b04080e7          	jalr	-1276(ra) # 800063a4 <acquire>
        if(pp->state == ZOMBIE){
    800018a8:	4c9c                	lw	a5,24(s1)
    800018aa:	f94781e3          	beq	a5,s4,8000182c <wait+0x56>
        release(&pp->lock);
    800018ae:	8526                	mv	a0,s1
    800018b0:	00005097          	auipc	ra,0x5
    800018b4:	ba8080e7          	jalr	-1112(ra) # 80006458 <release>
        havekids = 1;
    800018b8:	875a                	mv	a4,s6
    800018ba:	bfd9                	j	80001890 <wait+0xba>
    if(!havekids || killed(p)){
    800018bc:	c719                	beqz	a4,800018ca <wait+0xf4>
    800018be:	854a                	mv	a0,s2
    800018c0:	00000097          	auipc	ra,0x0
    800018c4:	ee4080e7          	jalr	-284(ra) # 800017a4 <killed>
    800018c8:	c51d                	beqz	a0,800018f6 <wait+0x120>
      release(&wait_lock);
    800018ca:	00007517          	auipc	a0,0x7
    800018ce:	05e50513          	addi	a0,a0,94 # 80008928 <wait_lock>
    800018d2:	00005097          	auipc	ra,0x5
    800018d6:	b86080e7          	jalr	-1146(ra) # 80006458 <release>
      return -1;
    800018da:	59fd                	li	s3,-1
}
    800018dc:	854e                	mv	a0,s3
    800018de:	60a6                	ld	ra,72(sp)
    800018e0:	6406                	ld	s0,64(sp)
    800018e2:	74e2                	ld	s1,56(sp)
    800018e4:	7942                	ld	s2,48(sp)
    800018e6:	79a2                	ld	s3,40(sp)
    800018e8:	7a02                	ld	s4,32(sp)
    800018ea:	6ae2                	ld	s5,24(sp)
    800018ec:	6b42                	ld	s6,16(sp)
    800018ee:	6ba2                	ld	s7,8(sp)
    800018f0:	6c02                	ld	s8,0(sp)
    800018f2:	6161                	addi	sp,sp,80
    800018f4:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018f6:	85e2                	mv	a1,s8
    800018f8:	854a                	mv	a0,s2
    800018fa:	00000097          	auipc	ra,0x0
    800018fe:	c02080e7          	jalr	-1022(ra) # 800014fc <sleep>
    havekids = 0;
    80001902:	bf39                	j	80001820 <wait+0x4a>

0000000080001904 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001904:	7179                	addi	sp,sp,-48
    80001906:	f406                	sd	ra,40(sp)
    80001908:	f022                	sd	s0,32(sp)
    8000190a:	ec26                	sd	s1,24(sp)
    8000190c:	e84a                	sd	s2,16(sp)
    8000190e:	e44e                	sd	s3,8(sp)
    80001910:	e052                	sd	s4,0(sp)
    80001912:	1800                	addi	s0,sp,48
    80001914:	84aa                	mv	s1,a0
    80001916:	892e                	mv	s2,a1
    80001918:	89b2                	mv	s3,a2
    8000191a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000191c:	fffff097          	auipc	ra,0xfffff
    80001920:	538080e7          	jalr	1336(ra) # 80000e54 <myproc>
  if(user_dst){
    80001924:	c08d                	beqz	s1,80001946 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001926:	86d2                	mv	a3,s4
    80001928:	864e                	mv	a2,s3
    8000192a:	85ca                	mv	a1,s2
    8000192c:	6928                	ld	a0,80(a0)
    8000192e:	fffff097          	auipc	ra,0xfffff
    80001932:	1e6080e7          	jalr	486(ra) # 80000b14 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001936:	70a2                	ld	ra,40(sp)
    80001938:	7402                	ld	s0,32(sp)
    8000193a:	64e2                	ld	s1,24(sp)
    8000193c:	6942                	ld	s2,16(sp)
    8000193e:	69a2                	ld	s3,8(sp)
    80001940:	6a02                	ld	s4,0(sp)
    80001942:	6145                	addi	sp,sp,48
    80001944:	8082                	ret
    memmove((char *)dst, src, len);
    80001946:	000a061b          	sext.w	a2,s4
    8000194a:	85ce                	mv	a1,s3
    8000194c:	854a                	mv	a0,s2
    8000194e:	fffff097          	auipc	ra,0xfffff
    80001952:	888080e7          	jalr	-1912(ra) # 800001d6 <memmove>
    return 0;
    80001956:	8526                	mv	a0,s1
    80001958:	bff9                	j	80001936 <either_copyout+0x32>

000000008000195a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000195a:	7179                	addi	sp,sp,-48
    8000195c:	f406                	sd	ra,40(sp)
    8000195e:	f022                	sd	s0,32(sp)
    80001960:	ec26                	sd	s1,24(sp)
    80001962:	e84a                	sd	s2,16(sp)
    80001964:	e44e                	sd	s3,8(sp)
    80001966:	e052                	sd	s4,0(sp)
    80001968:	1800                	addi	s0,sp,48
    8000196a:	892a                	mv	s2,a0
    8000196c:	84ae                	mv	s1,a1
    8000196e:	89b2                	mv	s3,a2
    80001970:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001972:	fffff097          	auipc	ra,0xfffff
    80001976:	4e2080e7          	jalr	1250(ra) # 80000e54 <myproc>
  if(user_src){
    8000197a:	c08d                	beqz	s1,8000199c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000197c:	86d2                	mv	a3,s4
    8000197e:	864e                	mv	a2,s3
    80001980:	85ca                	mv	a1,s2
    80001982:	6928                	ld	a0,80(a0)
    80001984:	fffff097          	auipc	ra,0xfffff
    80001988:	21c080e7          	jalr	540(ra) # 80000ba0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000198c:	70a2                	ld	ra,40(sp)
    8000198e:	7402                	ld	s0,32(sp)
    80001990:	64e2                	ld	s1,24(sp)
    80001992:	6942                	ld	s2,16(sp)
    80001994:	69a2                	ld	s3,8(sp)
    80001996:	6a02                	ld	s4,0(sp)
    80001998:	6145                	addi	sp,sp,48
    8000199a:	8082                	ret
    memmove(dst, (char*)src, len);
    8000199c:	000a061b          	sext.w	a2,s4
    800019a0:	85ce                	mv	a1,s3
    800019a2:	854a                	mv	a0,s2
    800019a4:	fffff097          	auipc	ra,0xfffff
    800019a8:	832080e7          	jalr	-1998(ra) # 800001d6 <memmove>
    return 0;
    800019ac:	8526                	mv	a0,s1
    800019ae:	bff9                	j	8000198c <either_copyin+0x32>

00000000800019b0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019b0:	715d                	addi	sp,sp,-80
    800019b2:	e486                	sd	ra,72(sp)
    800019b4:	e0a2                	sd	s0,64(sp)
    800019b6:	fc26                	sd	s1,56(sp)
    800019b8:	f84a                	sd	s2,48(sp)
    800019ba:	f44e                	sd	s3,40(sp)
    800019bc:	f052                	sd	s4,32(sp)
    800019be:	ec56                	sd	s5,24(sp)
    800019c0:	e85a                	sd	s6,16(sp)
    800019c2:	e45e                	sd	s7,8(sp)
    800019c4:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019c6:	00006517          	auipc	a0,0x6
    800019ca:	68250513          	addi	a0,a0,1666 # 80008048 <etext+0x48>
    800019ce:	00004097          	auipc	ra,0x4
    800019d2:	4e8080e7          	jalr	1256(ra) # 80005eb6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019d6:	00007497          	auipc	s1,0x7
    800019da:	4c248493          	addi	s1,s1,1218 # 80008e98 <proc+0x158>
    800019de:	00008917          	auipc	s2,0x8
    800019e2:	2ca90913          	addi	s2,s2,714 # 80009ca8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e6:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019e8:	00007997          	auipc	s3,0x7
    800019ec:	81898993          	addi	s3,s3,-2024 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019f0:	00007a97          	auipc	s5,0x7
    800019f4:	818a8a93          	addi	s5,s5,-2024 # 80008208 <etext+0x208>
    printf("\n");
    800019f8:	00006a17          	auipc	s4,0x6
    800019fc:	650a0a13          	addi	s4,s4,1616 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a00:	00007b97          	auipc	s7,0x7
    80001a04:	848b8b93          	addi	s7,s7,-1976 # 80008248 <states.0>
    80001a08:	a00d                	j	80001a2a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a0a:	ed86a583          	lw	a1,-296(a3)
    80001a0e:	8556                	mv	a0,s5
    80001a10:	00004097          	auipc	ra,0x4
    80001a14:	4a6080e7          	jalr	1190(ra) # 80005eb6 <printf>
    printf("\n");
    80001a18:	8552                	mv	a0,s4
    80001a1a:	00004097          	auipc	ra,0x4
    80001a1e:	49c080e7          	jalr	1180(ra) # 80005eb6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a22:	16848493          	addi	s1,s1,360
    80001a26:	03248263          	beq	s1,s2,80001a4a <procdump+0x9a>
    if(p->state == UNUSED)
    80001a2a:	86a6                	mv	a3,s1
    80001a2c:	ec04a783          	lw	a5,-320(s1)
    80001a30:	dbed                	beqz	a5,80001a22 <procdump+0x72>
      state = "???";
    80001a32:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a34:	fcfb6be3          	bltu	s6,a5,80001a0a <procdump+0x5a>
    80001a38:	02079713          	slli	a4,a5,0x20
    80001a3c:	01d75793          	srli	a5,a4,0x1d
    80001a40:	97de                	add	a5,a5,s7
    80001a42:	6390                	ld	a2,0(a5)
    80001a44:	f279                	bnez	a2,80001a0a <procdump+0x5a>
      state = "???";
    80001a46:	864e                	mv	a2,s3
    80001a48:	b7c9                	j	80001a0a <procdump+0x5a>
  }
}
    80001a4a:	60a6                	ld	ra,72(sp)
    80001a4c:	6406                	ld	s0,64(sp)
    80001a4e:	74e2                	ld	s1,56(sp)
    80001a50:	7942                	ld	s2,48(sp)
    80001a52:	79a2                	ld	s3,40(sp)
    80001a54:	7a02                	ld	s4,32(sp)
    80001a56:	6ae2                	ld	s5,24(sp)
    80001a58:	6b42                	ld	s6,16(sp)
    80001a5a:	6ba2                	ld	s7,8(sp)
    80001a5c:	6161                	addi	sp,sp,80
    80001a5e:	8082                	ret

0000000080001a60 <swtch>:
    80001a60:	00153023          	sd	ra,0(a0)
    80001a64:	00253423          	sd	sp,8(a0)
    80001a68:	e900                	sd	s0,16(a0)
    80001a6a:	ed04                	sd	s1,24(a0)
    80001a6c:	03253023          	sd	s2,32(a0)
    80001a70:	03353423          	sd	s3,40(a0)
    80001a74:	03453823          	sd	s4,48(a0)
    80001a78:	03553c23          	sd	s5,56(a0)
    80001a7c:	05653023          	sd	s6,64(a0)
    80001a80:	05753423          	sd	s7,72(a0)
    80001a84:	05853823          	sd	s8,80(a0)
    80001a88:	05953c23          	sd	s9,88(a0)
    80001a8c:	07a53023          	sd	s10,96(a0)
    80001a90:	07b53423          	sd	s11,104(a0)
    80001a94:	0005b083          	ld	ra,0(a1)
    80001a98:	0085b103          	ld	sp,8(a1)
    80001a9c:	6980                	ld	s0,16(a1)
    80001a9e:	6d84                	ld	s1,24(a1)
    80001aa0:	0205b903          	ld	s2,32(a1)
    80001aa4:	0285b983          	ld	s3,40(a1)
    80001aa8:	0305ba03          	ld	s4,48(a1)
    80001aac:	0385ba83          	ld	s5,56(a1)
    80001ab0:	0405bb03          	ld	s6,64(a1)
    80001ab4:	0485bb83          	ld	s7,72(a1)
    80001ab8:	0505bc03          	ld	s8,80(a1)
    80001abc:	0585bc83          	ld	s9,88(a1)
    80001ac0:	0605bd03          	ld	s10,96(a1)
    80001ac4:	0685bd83          	ld	s11,104(a1)
    80001ac8:	8082                	ret

0000000080001aca <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001aca:	1141                	addi	sp,sp,-16
    80001acc:	e406                	sd	ra,8(sp)
    80001ace:	e022                	sd	s0,0(sp)
    80001ad0:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ad2:	00006597          	auipc	a1,0x6
    80001ad6:	7a658593          	addi	a1,a1,1958 # 80008278 <states.0+0x30>
    80001ada:	00008517          	auipc	a0,0x8
    80001ade:	07650513          	addi	a0,a0,118 # 80009b50 <tickslock>
    80001ae2:	00005097          	auipc	ra,0x5
    80001ae6:	832080e7          	jalr	-1998(ra) # 80006314 <initlock>
}
    80001aea:	60a2                	ld	ra,8(sp)
    80001aec:	6402                	ld	s0,0(sp)
    80001aee:	0141                	addi	sp,sp,16
    80001af0:	8082                	ret

0000000080001af2 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001af2:	1141                	addi	sp,sp,-16
    80001af4:	e422                	sd	s0,8(sp)
    80001af6:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001af8:	00003797          	auipc	a5,0x3
    80001afc:	7a878793          	addi	a5,a5,1960 # 800052a0 <kernelvec>
    80001b00:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b04:	6422                	ld	s0,8(sp)
    80001b06:	0141                	addi	sp,sp,16
    80001b08:	8082                	ret

0000000080001b0a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b0a:	1141                	addi	sp,sp,-16
    80001b0c:	e406                	sd	ra,8(sp)
    80001b0e:	e022                	sd	s0,0(sp)
    80001b10:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b12:	fffff097          	auipc	ra,0xfffff
    80001b16:	342080e7          	jalr	834(ra) # 80000e54 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b1a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b1e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b20:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b24:	00005697          	auipc	a3,0x5
    80001b28:	4dc68693          	addi	a3,a3,1244 # 80007000 <_trampoline>
    80001b2c:	00005717          	auipc	a4,0x5
    80001b30:	4d470713          	addi	a4,a4,1236 # 80007000 <_trampoline>
    80001b34:	8f15                	sub	a4,a4,a3
    80001b36:	040007b7          	lui	a5,0x4000
    80001b3a:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b3c:	07b2                	slli	a5,a5,0xc
    80001b3e:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b40:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b44:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b46:	18002673          	csrr	a2,satp
    80001b4a:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b4c:	6d30                	ld	a2,88(a0)
    80001b4e:	6138                	ld	a4,64(a0)
    80001b50:	6585                	lui	a1,0x1
    80001b52:	972e                	add	a4,a4,a1
    80001b54:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b56:	6d38                	ld	a4,88(a0)
    80001b58:	00000617          	auipc	a2,0x0
    80001b5c:	13060613          	addi	a2,a2,304 # 80001c88 <usertrap>
    80001b60:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b62:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b64:	8612                	mv	a2,tp
    80001b66:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b68:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b6c:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b70:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b74:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b78:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b7a:	6f18                	ld	a4,24(a4)
    80001b7c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b80:	6928                	ld	a0,80(a0)
    80001b82:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001b84:	00005717          	auipc	a4,0x5
    80001b88:	51870713          	addi	a4,a4,1304 # 8000709c <userret>
    80001b8c:	8f15                	sub	a4,a4,a3
    80001b8e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001b90:	577d                	li	a4,-1
    80001b92:	177e                	slli	a4,a4,0x3f
    80001b94:	8d59                	or	a0,a0,a4
    80001b96:	9782                	jalr	a5
}
    80001b98:	60a2                	ld	ra,8(sp)
    80001b9a:	6402                	ld	s0,0(sp)
    80001b9c:	0141                	addi	sp,sp,16
    80001b9e:	8082                	ret

0000000080001ba0 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001ba0:	1101                	addi	sp,sp,-32
    80001ba2:	ec06                	sd	ra,24(sp)
    80001ba4:	e822                	sd	s0,16(sp)
    80001ba6:	e426                	sd	s1,8(sp)
    80001ba8:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001baa:	00008497          	auipc	s1,0x8
    80001bae:	fa648493          	addi	s1,s1,-90 # 80009b50 <tickslock>
    80001bb2:	8526                	mv	a0,s1
    80001bb4:	00004097          	auipc	ra,0x4
    80001bb8:	7f0080e7          	jalr	2032(ra) # 800063a4 <acquire>
  ticks++;
    80001bbc:	00007517          	auipc	a0,0x7
    80001bc0:	d1c50513          	addi	a0,a0,-740 # 800088d8 <ticks>
    80001bc4:	411c                	lw	a5,0(a0)
    80001bc6:	2785                	addiw	a5,a5,1
    80001bc8:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bca:	00000097          	auipc	ra,0x0
    80001bce:	996080e7          	jalr	-1642(ra) # 80001560 <wakeup>
  release(&tickslock);
    80001bd2:	8526                	mv	a0,s1
    80001bd4:	00005097          	auipc	ra,0x5
    80001bd8:	884080e7          	jalr	-1916(ra) # 80006458 <release>
}
    80001bdc:	60e2                	ld	ra,24(sp)
    80001bde:	6442                	ld	s0,16(sp)
    80001be0:	64a2                	ld	s1,8(sp)
    80001be2:	6105                	addi	sp,sp,32
    80001be4:	8082                	ret

0000000080001be6 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001be6:	1101                	addi	sp,sp,-32
    80001be8:	ec06                	sd	ra,24(sp)
    80001bea:	e822                	sd	s0,16(sp)
    80001bec:	e426                	sd	s1,8(sp)
    80001bee:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bf0:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001bf4:	00074d63          	bltz	a4,80001c0e <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001bf8:	57fd                	li	a5,-1
    80001bfa:	17fe                	slli	a5,a5,0x3f
    80001bfc:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bfe:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c00:	06f70363          	beq	a4,a5,80001c66 <devintr+0x80>
  }
}
    80001c04:	60e2                	ld	ra,24(sp)
    80001c06:	6442                	ld	s0,16(sp)
    80001c08:	64a2                	ld	s1,8(sp)
    80001c0a:	6105                	addi	sp,sp,32
    80001c0c:	8082                	ret
     (scause & 0xff) == 9){
    80001c0e:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001c12:	46a5                	li	a3,9
    80001c14:	fed792e3          	bne	a5,a3,80001bf8 <devintr+0x12>
    int irq = plic_claim();
    80001c18:	00003097          	auipc	ra,0x3
    80001c1c:	790080e7          	jalr	1936(ra) # 800053a8 <plic_claim>
    80001c20:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c22:	47a9                	li	a5,10
    80001c24:	02f50763          	beq	a0,a5,80001c52 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c28:	4785                	li	a5,1
    80001c2a:	02f50963          	beq	a0,a5,80001c5c <devintr+0x76>
    return 1;
    80001c2e:	4505                	li	a0,1
    } else if(irq){
    80001c30:	d8f1                	beqz	s1,80001c04 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c32:	85a6                	mv	a1,s1
    80001c34:	00006517          	auipc	a0,0x6
    80001c38:	64c50513          	addi	a0,a0,1612 # 80008280 <states.0+0x38>
    80001c3c:	00004097          	auipc	ra,0x4
    80001c40:	27a080e7          	jalr	634(ra) # 80005eb6 <printf>
      plic_complete(irq);
    80001c44:	8526                	mv	a0,s1
    80001c46:	00003097          	auipc	ra,0x3
    80001c4a:	786080e7          	jalr	1926(ra) # 800053cc <plic_complete>
    return 1;
    80001c4e:	4505                	li	a0,1
    80001c50:	bf55                	j	80001c04 <devintr+0x1e>
      uartintr();
    80001c52:	00004097          	auipc	ra,0x4
    80001c56:	672080e7          	jalr	1650(ra) # 800062c4 <uartintr>
    80001c5a:	b7ed                	j	80001c44 <devintr+0x5e>
      virtio_disk_intr();
    80001c5c:	00004097          	auipc	ra,0x4
    80001c60:	c38080e7          	jalr	-968(ra) # 80005894 <virtio_disk_intr>
    80001c64:	b7c5                	j	80001c44 <devintr+0x5e>
    if(cpuid() == 0){
    80001c66:	fffff097          	auipc	ra,0xfffff
    80001c6a:	1c2080e7          	jalr	450(ra) # 80000e28 <cpuid>
    80001c6e:	c901                	beqz	a0,80001c7e <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c70:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c74:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c76:	14479073          	csrw	sip,a5
    return 2;
    80001c7a:	4509                	li	a0,2
    80001c7c:	b761                	j	80001c04 <devintr+0x1e>
      clockintr();
    80001c7e:	00000097          	auipc	ra,0x0
    80001c82:	f22080e7          	jalr	-222(ra) # 80001ba0 <clockintr>
    80001c86:	b7ed                	j	80001c70 <devintr+0x8a>

0000000080001c88 <usertrap>:
{
    80001c88:	1101                	addi	sp,sp,-32
    80001c8a:	ec06                	sd	ra,24(sp)
    80001c8c:	e822                	sd	s0,16(sp)
    80001c8e:	e426                	sd	s1,8(sp)
    80001c90:	e04a                	sd	s2,0(sp)
    80001c92:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c94:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c98:	1007f793          	andi	a5,a5,256
    80001c9c:	e3b1                	bnez	a5,80001ce0 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c9e:	00003797          	auipc	a5,0x3
    80001ca2:	60278793          	addi	a5,a5,1538 # 800052a0 <kernelvec>
    80001ca6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001caa:	fffff097          	auipc	ra,0xfffff
    80001cae:	1aa080e7          	jalr	426(ra) # 80000e54 <myproc>
    80001cb2:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cb4:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cb6:	14102773          	csrr	a4,sepc
    80001cba:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cbc:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cc0:	47a1                	li	a5,8
    80001cc2:	02f70763          	beq	a4,a5,80001cf0 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001cc6:	00000097          	auipc	ra,0x0
    80001cca:	f20080e7          	jalr	-224(ra) # 80001be6 <devintr>
    80001cce:	892a                	mv	s2,a0
    80001cd0:	c151                	beqz	a0,80001d54 <usertrap+0xcc>
  if(killed(p))
    80001cd2:	8526                	mv	a0,s1
    80001cd4:	00000097          	auipc	ra,0x0
    80001cd8:	ad0080e7          	jalr	-1328(ra) # 800017a4 <killed>
    80001cdc:	c929                	beqz	a0,80001d2e <usertrap+0xa6>
    80001cde:	a099                	j	80001d24 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001ce0:	00006517          	auipc	a0,0x6
    80001ce4:	5c050513          	addi	a0,a0,1472 # 800082a0 <states.0+0x58>
    80001ce8:	00004097          	auipc	ra,0x4
    80001cec:	184080e7          	jalr	388(ra) # 80005e6c <panic>
    if(killed(p))
    80001cf0:	00000097          	auipc	ra,0x0
    80001cf4:	ab4080e7          	jalr	-1356(ra) # 800017a4 <killed>
    80001cf8:	e921                	bnez	a0,80001d48 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001cfa:	6cb8                	ld	a4,88(s1)
    80001cfc:	6f1c                	ld	a5,24(a4)
    80001cfe:	0791                	addi	a5,a5,4
    80001d00:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d02:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d06:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d0a:	10079073          	csrw	sstatus,a5
    syscall();
    80001d0e:	00000097          	auipc	ra,0x0
    80001d12:	2d4080e7          	jalr	724(ra) # 80001fe2 <syscall>
  if(killed(p))
    80001d16:	8526                	mv	a0,s1
    80001d18:	00000097          	auipc	ra,0x0
    80001d1c:	a8c080e7          	jalr	-1396(ra) # 800017a4 <killed>
    80001d20:	c911                	beqz	a0,80001d34 <usertrap+0xac>
    80001d22:	4901                	li	s2,0
    exit(-1);
    80001d24:	557d                	li	a0,-1
    80001d26:	00000097          	auipc	ra,0x0
    80001d2a:	90a080e7          	jalr	-1782(ra) # 80001630 <exit>
  if(which_dev == 2)
    80001d2e:	4789                	li	a5,2
    80001d30:	04f90f63          	beq	s2,a5,80001d8e <usertrap+0x106>
  usertrapret();
    80001d34:	00000097          	auipc	ra,0x0
    80001d38:	dd6080e7          	jalr	-554(ra) # 80001b0a <usertrapret>
}
    80001d3c:	60e2                	ld	ra,24(sp)
    80001d3e:	6442                	ld	s0,16(sp)
    80001d40:	64a2                	ld	s1,8(sp)
    80001d42:	6902                	ld	s2,0(sp)
    80001d44:	6105                	addi	sp,sp,32
    80001d46:	8082                	ret
      exit(-1);
    80001d48:	557d                	li	a0,-1
    80001d4a:	00000097          	auipc	ra,0x0
    80001d4e:	8e6080e7          	jalr	-1818(ra) # 80001630 <exit>
    80001d52:	b765                	j	80001cfa <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d54:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d58:	5890                	lw	a2,48(s1)
    80001d5a:	00006517          	auipc	a0,0x6
    80001d5e:	56650513          	addi	a0,a0,1382 # 800082c0 <states.0+0x78>
    80001d62:	00004097          	auipc	ra,0x4
    80001d66:	154080e7          	jalr	340(ra) # 80005eb6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d6a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d6e:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d72:	00006517          	auipc	a0,0x6
    80001d76:	57e50513          	addi	a0,a0,1406 # 800082f0 <states.0+0xa8>
    80001d7a:	00004097          	auipc	ra,0x4
    80001d7e:	13c080e7          	jalr	316(ra) # 80005eb6 <printf>
    setkilled(p);
    80001d82:	8526                	mv	a0,s1
    80001d84:	00000097          	auipc	ra,0x0
    80001d88:	9f4080e7          	jalr	-1548(ra) # 80001778 <setkilled>
    80001d8c:	b769                	j	80001d16 <usertrap+0x8e>
    yield();
    80001d8e:	fffff097          	auipc	ra,0xfffff
    80001d92:	732080e7          	jalr	1842(ra) # 800014c0 <yield>
    80001d96:	bf79                	j	80001d34 <usertrap+0xac>

0000000080001d98 <kerneltrap>:
{
    80001d98:	7179                	addi	sp,sp,-48
    80001d9a:	f406                	sd	ra,40(sp)
    80001d9c:	f022                	sd	s0,32(sp)
    80001d9e:	ec26                	sd	s1,24(sp)
    80001da0:	e84a                	sd	s2,16(sp)
    80001da2:	e44e                	sd	s3,8(sp)
    80001da4:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001da6:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001daa:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dae:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001db2:	1004f793          	andi	a5,s1,256
    80001db6:	cb85                	beqz	a5,80001de6 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001db8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dbc:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dbe:	ef85                	bnez	a5,80001df6 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dc0:	00000097          	auipc	ra,0x0
    80001dc4:	e26080e7          	jalr	-474(ra) # 80001be6 <devintr>
    80001dc8:	cd1d                	beqz	a0,80001e06 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dca:	4789                	li	a5,2
    80001dcc:	06f50a63          	beq	a0,a5,80001e40 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dd0:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dd4:	10049073          	csrw	sstatus,s1
}
    80001dd8:	70a2                	ld	ra,40(sp)
    80001dda:	7402                	ld	s0,32(sp)
    80001ddc:	64e2                	ld	s1,24(sp)
    80001dde:	6942                	ld	s2,16(sp)
    80001de0:	69a2                	ld	s3,8(sp)
    80001de2:	6145                	addi	sp,sp,48
    80001de4:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001de6:	00006517          	auipc	a0,0x6
    80001dea:	52a50513          	addi	a0,a0,1322 # 80008310 <states.0+0xc8>
    80001dee:	00004097          	auipc	ra,0x4
    80001df2:	07e080e7          	jalr	126(ra) # 80005e6c <panic>
    panic("kerneltrap: interrupts enabled");
    80001df6:	00006517          	auipc	a0,0x6
    80001dfa:	54250513          	addi	a0,a0,1346 # 80008338 <states.0+0xf0>
    80001dfe:	00004097          	auipc	ra,0x4
    80001e02:	06e080e7          	jalr	110(ra) # 80005e6c <panic>
    printf("scause %p\n", scause);
    80001e06:	85ce                	mv	a1,s3
    80001e08:	00006517          	auipc	a0,0x6
    80001e0c:	55050513          	addi	a0,a0,1360 # 80008358 <states.0+0x110>
    80001e10:	00004097          	auipc	ra,0x4
    80001e14:	0a6080e7          	jalr	166(ra) # 80005eb6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e18:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e1c:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e20:	00006517          	auipc	a0,0x6
    80001e24:	54850513          	addi	a0,a0,1352 # 80008368 <states.0+0x120>
    80001e28:	00004097          	auipc	ra,0x4
    80001e2c:	08e080e7          	jalr	142(ra) # 80005eb6 <printf>
    panic("kerneltrap");
    80001e30:	00006517          	auipc	a0,0x6
    80001e34:	55050513          	addi	a0,a0,1360 # 80008380 <states.0+0x138>
    80001e38:	00004097          	auipc	ra,0x4
    80001e3c:	034080e7          	jalr	52(ra) # 80005e6c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e40:	fffff097          	auipc	ra,0xfffff
    80001e44:	014080e7          	jalr	20(ra) # 80000e54 <myproc>
    80001e48:	d541                	beqz	a0,80001dd0 <kerneltrap+0x38>
    80001e4a:	fffff097          	auipc	ra,0xfffff
    80001e4e:	00a080e7          	jalr	10(ra) # 80000e54 <myproc>
    80001e52:	4d18                	lw	a4,24(a0)
    80001e54:	4791                	li	a5,4
    80001e56:	f6f71de3          	bne	a4,a5,80001dd0 <kerneltrap+0x38>
    yield();
    80001e5a:	fffff097          	auipc	ra,0xfffff
    80001e5e:	666080e7          	jalr	1638(ra) # 800014c0 <yield>
    80001e62:	b7bd                	j	80001dd0 <kerneltrap+0x38>

0000000080001e64 <argraw>:
        return -1;
    return strlen(buf);
}

static uint64 argraw(int n)
{
    80001e64:	1101                	addi	sp,sp,-32
    80001e66:	ec06                	sd	ra,24(sp)
    80001e68:	e822                	sd	s0,16(sp)
    80001e6a:	e426                	sd	s1,8(sp)
    80001e6c:	1000                	addi	s0,sp,32
    80001e6e:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80001e70:	fffff097          	auipc	ra,0xfffff
    80001e74:	fe4080e7          	jalr	-28(ra) # 80000e54 <myproc>
    switch (n) {
    80001e78:	4795                	li	a5,5
    80001e7a:	0497e163          	bltu	a5,s1,80001ebc <argraw+0x58>
    80001e7e:	048a                	slli	s1,s1,0x2
    80001e80:	00006717          	auipc	a4,0x6
    80001e84:	53870713          	addi	a4,a4,1336 # 800083b8 <states.0+0x170>
    80001e88:	94ba                	add	s1,s1,a4
    80001e8a:	409c                	lw	a5,0(s1)
    80001e8c:	97ba                	add	a5,a5,a4
    80001e8e:	8782                	jr	a5
    case 0:
        return p->trapframe->a0;
    80001e90:	6d3c                	ld	a5,88(a0)
    80001e92:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80001e94:	60e2                	ld	ra,24(sp)
    80001e96:	6442                	ld	s0,16(sp)
    80001e98:	64a2                	ld	s1,8(sp)
    80001e9a:	6105                	addi	sp,sp,32
    80001e9c:	8082                	ret
        return p->trapframe->a1;
    80001e9e:	6d3c                	ld	a5,88(a0)
    80001ea0:	7fa8                	ld	a0,120(a5)
    80001ea2:	bfcd                	j	80001e94 <argraw+0x30>
        return p->trapframe->a2;
    80001ea4:	6d3c                	ld	a5,88(a0)
    80001ea6:	63c8                	ld	a0,128(a5)
    80001ea8:	b7f5                	j	80001e94 <argraw+0x30>
        return p->trapframe->a3;
    80001eaa:	6d3c                	ld	a5,88(a0)
    80001eac:	67c8                	ld	a0,136(a5)
    80001eae:	b7dd                	j	80001e94 <argraw+0x30>
        return p->trapframe->a4;
    80001eb0:	6d3c                	ld	a5,88(a0)
    80001eb2:	6bc8                	ld	a0,144(a5)
    80001eb4:	b7c5                	j	80001e94 <argraw+0x30>
        return p->trapframe->a5;
    80001eb6:	6d3c                	ld	a5,88(a0)
    80001eb8:	6fc8                	ld	a0,152(a5)
    80001eba:	bfe9                	j	80001e94 <argraw+0x30>
    panic("argraw");
    80001ebc:	00006517          	auipc	a0,0x6
    80001ec0:	4d450513          	addi	a0,a0,1236 # 80008390 <states.0+0x148>
    80001ec4:	00004097          	auipc	ra,0x4
    80001ec8:	fa8080e7          	jalr	-88(ra) # 80005e6c <panic>

0000000080001ecc <fetchaddr>:
{
    80001ecc:	1101                	addi	sp,sp,-32
    80001ece:	ec06                	sd	ra,24(sp)
    80001ed0:	e822                	sd	s0,16(sp)
    80001ed2:	e426                	sd	s1,8(sp)
    80001ed4:	e04a                	sd	s2,0(sp)
    80001ed6:	1000                	addi	s0,sp,32
    80001ed8:	84aa                	mv	s1,a0
    80001eda:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80001edc:	fffff097          	auipc	ra,0xfffff
    80001ee0:	f78080e7          	jalr	-136(ra) # 80000e54 <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001ee4:	653c                	ld	a5,72(a0)
    80001ee6:	02f4f863          	bgeu	s1,a5,80001f16 <fetchaddr+0x4a>
    80001eea:	00848713          	addi	a4,s1,8
    80001eee:	02e7e663          	bltu	a5,a4,80001f1a <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001ef2:	46a1                	li	a3,8
    80001ef4:	8626                	mv	a2,s1
    80001ef6:	85ca                	mv	a1,s2
    80001ef8:	6928                	ld	a0,80(a0)
    80001efa:	fffff097          	auipc	ra,0xfffff
    80001efe:	ca6080e7          	jalr	-858(ra) # 80000ba0 <copyin>
    80001f02:	00a03533          	snez	a0,a0
    80001f06:	40a00533          	neg	a0,a0
}
    80001f0a:	60e2                	ld	ra,24(sp)
    80001f0c:	6442                	ld	s0,16(sp)
    80001f0e:	64a2                	ld	s1,8(sp)
    80001f10:	6902                	ld	s2,0(sp)
    80001f12:	6105                	addi	sp,sp,32
    80001f14:	8082                	ret
        return -1;
    80001f16:	557d                	li	a0,-1
    80001f18:	bfcd                	j	80001f0a <fetchaddr+0x3e>
    80001f1a:	557d                	li	a0,-1
    80001f1c:	b7fd                	j	80001f0a <fetchaddr+0x3e>

0000000080001f1e <fetchstr>:
{
    80001f1e:	7179                	addi	sp,sp,-48
    80001f20:	f406                	sd	ra,40(sp)
    80001f22:	f022                	sd	s0,32(sp)
    80001f24:	ec26                	sd	s1,24(sp)
    80001f26:	e84a                	sd	s2,16(sp)
    80001f28:	e44e                	sd	s3,8(sp)
    80001f2a:	1800                	addi	s0,sp,48
    80001f2c:	892a                	mv	s2,a0
    80001f2e:	84ae                	mv	s1,a1
    80001f30:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    80001f32:	fffff097          	auipc	ra,0xfffff
    80001f36:	f22080e7          	jalr	-222(ra) # 80000e54 <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80001f3a:	86ce                	mv	a3,s3
    80001f3c:	864a                	mv	a2,s2
    80001f3e:	85a6                	mv	a1,s1
    80001f40:	6928                	ld	a0,80(a0)
    80001f42:	fffff097          	auipc	ra,0xfffff
    80001f46:	cec080e7          	jalr	-788(ra) # 80000c2e <copyinstr>
    80001f4a:	00054e63          	bltz	a0,80001f66 <fetchstr+0x48>
    return strlen(buf);
    80001f4e:	8526                	mv	a0,s1
    80001f50:	ffffe097          	auipc	ra,0xffffe
    80001f54:	3a6080e7          	jalr	934(ra) # 800002f6 <strlen>
}
    80001f58:	70a2                	ld	ra,40(sp)
    80001f5a:	7402                	ld	s0,32(sp)
    80001f5c:	64e2                	ld	s1,24(sp)
    80001f5e:	6942                	ld	s2,16(sp)
    80001f60:	69a2                	ld	s3,8(sp)
    80001f62:	6145                	addi	sp,sp,48
    80001f64:	8082                	ret
        return -1;
    80001f66:	557d                	li	a0,-1
    80001f68:	bfc5                	j	80001f58 <fetchstr+0x3a>

0000000080001f6a <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    80001f6a:	1101                	addi	sp,sp,-32
    80001f6c:	ec06                	sd	ra,24(sp)
    80001f6e:	e822                	sd	s0,16(sp)
    80001f70:	e426                	sd	s1,8(sp)
    80001f72:	1000                	addi	s0,sp,32
    80001f74:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80001f76:	00000097          	auipc	ra,0x0
    80001f7a:	eee080e7          	jalr	-274(ra) # 80001e64 <argraw>
    80001f7e:	c088                	sw	a0,0(s1)
}
    80001f80:	60e2                	ld	ra,24(sp)
    80001f82:	6442                	ld	s0,16(sp)
    80001f84:	64a2                	ld	s1,8(sp)
    80001f86:	6105                	addi	sp,sp,32
    80001f88:	8082                	ret

0000000080001f8a <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    80001f8a:	1101                	addi	sp,sp,-32
    80001f8c:	ec06                	sd	ra,24(sp)
    80001f8e:	e822                	sd	s0,16(sp)
    80001f90:	e426                	sd	s1,8(sp)
    80001f92:	1000                	addi	s0,sp,32
    80001f94:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80001f96:	00000097          	auipc	ra,0x0
    80001f9a:	ece080e7          	jalr	-306(ra) # 80001e64 <argraw>
    80001f9e:	e088                	sd	a0,0(s1)
}
    80001fa0:	60e2                	ld	ra,24(sp)
    80001fa2:	6442                	ld	s0,16(sp)
    80001fa4:	64a2                	ld	s1,8(sp)
    80001fa6:	6105                	addi	sp,sp,32
    80001fa8:	8082                	ret

0000000080001faa <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    80001faa:	7179                	addi	sp,sp,-48
    80001fac:	f406                	sd	ra,40(sp)
    80001fae:	f022                	sd	s0,32(sp)
    80001fb0:	ec26                	sd	s1,24(sp)
    80001fb2:	e84a                	sd	s2,16(sp)
    80001fb4:	1800                	addi	s0,sp,48
    80001fb6:	84ae                	mv	s1,a1
    80001fb8:	8932                	mv	s2,a2
    uint64 addr;
    argaddr(n, &addr);
    80001fba:	fd840593          	addi	a1,s0,-40
    80001fbe:	00000097          	auipc	ra,0x0
    80001fc2:	fcc080e7          	jalr	-52(ra) # 80001f8a <argaddr>
    return fetchstr(addr, buf, max);
    80001fc6:	864a                	mv	a2,s2
    80001fc8:	85a6                	mv	a1,s1
    80001fca:	fd843503          	ld	a0,-40(s0)
    80001fce:	00000097          	auipc	ra,0x0
    80001fd2:	f50080e7          	jalr	-176(ra) # 80001f1e <fetchstr>
}
    80001fd6:	70a2                	ld	ra,40(sp)
    80001fd8:	7402                	ld	s0,32(sp)
    80001fda:	64e2                	ld	s1,24(sp)
    80001fdc:	6942                	ld	s2,16(sp)
    80001fde:	6145                	addi	sp,sp,48
    80001fe0:	8082                	ret

0000000080001fe2 <syscall>:
    [SYS_exec] sys_exec,   [SYS_fstat] sys_fstat,   [SYS_chdir] sys_chdir, [SYS_dup] sys_dup,        [SYS_getpid] sys_getpid, [SYS_sbrk] sys_sbrk,
    [SYS_sleep] sys_sleep, [SYS_uptime] sys_uptime, [SYS_open] sys_open,   [SYS_write] sys_write,    [SYS_mknod] sys_mknod,   [SYS_unlink] sys_unlink,
    [SYS_link] sys_link,   [SYS_mkdir] sys_mkdir,   [SYS_close] sys_close, [SYS_symlink] sys_symlink};

void syscall(void)
{
    80001fe2:	1101                	addi	sp,sp,-32
    80001fe4:	ec06                	sd	ra,24(sp)
    80001fe6:	e822                	sd	s0,16(sp)
    80001fe8:	e426                	sd	s1,8(sp)
    80001fea:	e04a                	sd	s2,0(sp)
    80001fec:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    80001fee:	fffff097          	auipc	ra,0xfffff
    80001ff2:	e66080e7          	jalr	-410(ra) # 80000e54 <myproc>
    80001ff6:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    80001ff8:	05853903          	ld	s2,88(a0)
    80001ffc:	0a893783          	ld	a5,168(s2)
    80002000:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002004:	37fd                	addiw	a5,a5,-1
    80002006:	4755                	li	a4,21
    80002008:	00f76f63          	bltu	a4,a5,80002026 <syscall+0x44>
    8000200c:	00369713          	slli	a4,a3,0x3
    80002010:	00006797          	auipc	a5,0x6
    80002014:	3c078793          	addi	a5,a5,960 # 800083d0 <syscalls>
    80002018:	97ba                	add	a5,a5,a4
    8000201a:	639c                	ld	a5,0(a5)
    8000201c:	c789                	beqz	a5,80002026 <syscall+0x44>
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    8000201e:	9782                	jalr	a5
    80002020:	06a93823          	sd	a0,112(s2)
    80002024:	a839                	j	80002042 <syscall+0x60>
    }
    else {
        printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    80002026:	15848613          	addi	a2,s1,344
    8000202a:	588c                	lw	a1,48(s1)
    8000202c:	00006517          	auipc	a0,0x6
    80002030:	36c50513          	addi	a0,a0,876 # 80008398 <states.0+0x150>
    80002034:	00004097          	auipc	ra,0x4
    80002038:	e82080e7          	jalr	-382(ra) # 80005eb6 <printf>
        p->trapframe->a0 = -1;
    8000203c:	6cbc                	ld	a5,88(s1)
    8000203e:	577d                	li	a4,-1
    80002040:	fbb8                	sd	a4,112(a5)
    }
}
    80002042:	60e2                	ld	ra,24(sp)
    80002044:	6442                	ld	s0,16(sp)
    80002046:	64a2                	ld	s1,8(sp)
    80002048:	6902                	ld	s2,0(sp)
    8000204a:	6105                	addi	sp,sp,32
    8000204c:	8082                	ret

000000008000204e <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000204e:	1101                	addi	sp,sp,-32
    80002050:	ec06                	sd	ra,24(sp)
    80002052:	e822                	sd	s0,16(sp)
    80002054:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002056:	fec40593          	addi	a1,s0,-20
    8000205a:	4501                	li	a0,0
    8000205c:	00000097          	auipc	ra,0x0
    80002060:	f0e080e7          	jalr	-242(ra) # 80001f6a <argint>
  exit(n);
    80002064:	fec42503          	lw	a0,-20(s0)
    80002068:	fffff097          	auipc	ra,0xfffff
    8000206c:	5c8080e7          	jalr	1480(ra) # 80001630 <exit>
  return 0;  // not reached
}
    80002070:	4501                	li	a0,0
    80002072:	60e2                	ld	ra,24(sp)
    80002074:	6442                	ld	s0,16(sp)
    80002076:	6105                	addi	sp,sp,32
    80002078:	8082                	ret

000000008000207a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000207a:	1141                	addi	sp,sp,-16
    8000207c:	e406                	sd	ra,8(sp)
    8000207e:	e022                	sd	s0,0(sp)
    80002080:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002082:	fffff097          	auipc	ra,0xfffff
    80002086:	dd2080e7          	jalr	-558(ra) # 80000e54 <myproc>
}
    8000208a:	5908                	lw	a0,48(a0)
    8000208c:	60a2                	ld	ra,8(sp)
    8000208e:	6402                	ld	s0,0(sp)
    80002090:	0141                	addi	sp,sp,16
    80002092:	8082                	ret

0000000080002094 <sys_fork>:

uint64
sys_fork(void)
{
    80002094:	1141                	addi	sp,sp,-16
    80002096:	e406                	sd	ra,8(sp)
    80002098:	e022                	sd	s0,0(sp)
    8000209a:	0800                	addi	s0,sp,16
  return fork();
    8000209c:	fffff097          	auipc	ra,0xfffff
    800020a0:	16e080e7          	jalr	366(ra) # 8000120a <fork>
}
    800020a4:	60a2                	ld	ra,8(sp)
    800020a6:	6402                	ld	s0,0(sp)
    800020a8:	0141                	addi	sp,sp,16
    800020aa:	8082                	ret

00000000800020ac <sys_wait>:

uint64
sys_wait(void)
{
    800020ac:	1101                	addi	sp,sp,-32
    800020ae:	ec06                	sd	ra,24(sp)
    800020b0:	e822                	sd	s0,16(sp)
    800020b2:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800020b4:	fe840593          	addi	a1,s0,-24
    800020b8:	4501                	li	a0,0
    800020ba:	00000097          	auipc	ra,0x0
    800020be:	ed0080e7          	jalr	-304(ra) # 80001f8a <argaddr>
  return wait(p);
    800020c2:	fe843503          	ld	a0,-24(s0)
    800020c6:	fffff097          	auipc	ra,0xfffff
    800020ca:	710080e7          	jalr	1808(ra) # 800017d6 <wait>
}
    800020ce:	60e2                	ld	ra,24(sp)
    800020d0:	6442                	ld	s0,16(sp)
    800020d2:	6105                	addi	sp,sp,32
    800020d4:	8082                	ret

00000000800020d6 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020d6:	7179                	addi	sp,sp,-48
    800020d8:	f406                	sd	ra,40(sp)
    800020da:	f022                	sd	s0,32(sp)
    800020dc:	ec26                	sd	s1,24(sp)
    800020de:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800020e0:	fdc40593          	addi	a1,s0,-36
    800020e4:	4501                	li	a0,0
    800020e6:	00000097          	auipc	ra,0x0
    800020ea:	e84080e7          	jalr	-380(ra) # 80001f6a <argint>
  addr = myproc()->sz;
    800020ee:	fffff097          	auipc	ra,0xfffff
    800020f2:	d66080e7          	jalr	-666(ra) # 80000e54 <myproc>
    800020f6:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800020f8:	fdc42503          	lw	a0,-36(s0)
    800020fc:	fffff097          	auipc	ra,0xfffff
    80002100:	0b2080e7          	jalr	178(ra) # 800011ae <growproc>
    80002104:	00054863          	bltz	a0,80002114 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002108:	8526                	mv	a0,s1
    8000210a:	70a2                	ld	ra,40(sp)
    8000210c:	7402                	ld	s0,32(sp)
    8000210e:	64e2                	ld	s1,24(sp)
    80002110:	6145                	addi	sp,sp,48
    80002112:	8082                	ret
    return -1;
    80002114:	54fd                	li	s1,-1
    80002116:	bfcd                	j	80002108 <sys_sbrk+0x32>

0000000080002118 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002118:	7139                	addi	sp,sp,-64
    8000211a:	fc06                	sd	ra,56(sp)
    8000211c:	f822                	sd	s0,48(sp)
    8000211e:	f426                	sd	s1,40(sp)
    80002120:	f04a                	sd	s2,32(sp)
    80002122:	ec4e                	sd	s3,24(sp)
    80002124:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002126:	fcc40593          	addi	a1,s0,-52
    8000212a:	4501                	li	a0,0
    8000212c:	00000097          	auipc	ra,0x0
    80002130:	e3e080e7          	jalr	-450(ra) # 80001f6a <argint>
  if(n < 0)
    80002134:	fcc42783          	lw	a5,-52(s0)
    80002138:	0607cf63          	bltz	a5,800021b6 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    8000213c:	00008517          	auipc	a0,0x8
    80002140:	a1450513          	addi	a0,a0,-1516 # 80009b50 <tickslock>
    80002144:	00004097          	auipc	ra,0x4
    80002148:	260080e7          	jalr	608(ra) # 800063a4 <acquire>
  ticks0 = ticks;
    8000214c:	00006917          	auipc	s2,0x6
    80002150:	78c92903          	lw	s2,1932(s2) # 800088d8 <ticks>
  while(ticks - ticks0 < n){
    80002154:	fcc42783          	lw	a5,-52(s0)
    80002158:	cf9d                	beqz	a5,80002196 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000215a:	00008997          	auipc	s3,0x8
    8000215e:	9f698993          	addi	s3,s3,-1546 # 80009b50 <tickslock>
    80002162:	00006497          	auipc	s1,0x6
    80002166:	77648493          	addi	s1,s1,1910 # 800088d8 <ticks>
    if(killed(myproc())){
    8000216a:	fffff097          	auipc	ra,0xfffff
    8000216e:	cea080e7          	jalr	-790(ra) # 80000e54 <myproc>
    80002172:	fffff097          	auipc	ra,0xfffff
    80002176:	632080e7          	jalr	1586(ra) # 800017a4 <killed>
    8000217a:	e129                	bnez	a0,800021bc <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    8000217c:	85ce                	mv	a1,s3
    8000217e:	8526                	mv	a0,s1
    80002180:	fffff097          	auipc	ra,0xfffff
    80002184:	37c080e7          	jalr	892(ra) # 800014fc <sleep>
  while(ticks - ticks0 < n){
    80002188:	409c                	lw	a5,0(s1)
    8000218a:	412787bb          	subw	a5,a5,s2
    8000218e:	fcc42703          	lw	a4,-52(s0)
    80002192:	fce7ece3          	bltu	a5,a4,8000216a <sys_sleep+0x52>
  }
  release(&tickslock);
    80002196:	00008517          	auipc	a0,0x8
    8000219a:	9ba50513          	addi	a0,a0,-1606 # 80009b50 <tickslock>
    8000219e:	00004097          	auipc	ra,0x4
    800021a2:	2ba080e7          	jalr	698(ra) # 80006458 <release>
  return 0;
    800021a6:	4501                	li	a0,0
}
    800021a8:	70e2                	ld	ra,56(sp)
    800021aa:	7442                	ld	s0,48(sp)
    800021ac:	74a2                	ld	s1,40(sp)
    800021ae:	7902                	ld	s2,32(sp)
    800021b0:	69e2                	ld	s3,24(sp)
    800021b2:	6121                	addi	sp,sp,64
    800021b4:	8082                	ret
    n = 0;
    800021b6:	fc042623          	sw	zero,-52(s0)
    800021ba:	b749                	j	8000213c <sys_sleep+0x24>
      release(&tickslock);
    800021bc:	00008517          	auipc	a0,0x8
    800021c0:	99450513          	addi	a0,a0,-1644 # 80009b50 <tickslock>
    800021c4:	00004097          	auipc	ra,0x4
    800021c8:	294080e7          	jalr	660(ra) # 80006458 <release>
      return -1;
    800021cc:	557d                	li	a0,-1
    800021ce:	bfe9                	j	800021a8 <sys_sleep+0x90>

00000000800021d0 <sys_kill>:

uint64
sys_kill(void)
{
    800021d0:	1101                	addi	sp,sp,-32
    800021d2:	ec06                	sd	ra,24(sp)
    800021d4:	e822                	sd	s0,16(sp)
    800021d6:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800021d8:	fec40593          	addi	a1,s0,-20
    800021dc:	4501                	li	a0,0
    800021de:	00000097          	auipc	ra,0x0
    800021e2:	d8c080e7          	jalr	-628(ra) # 80001f6a <argint>
  return kill(pid);
    800021e6:	fec42503          	lw	a0,-20(s0)
    800021ea:	fffff097          	auipc	ra,0xfffff
    800021ee:	51c080e7          	jalr	1308(ra) # 80001706 <kill>
}
    800021f2:	60e2                	ld	ra,24(sp)
    800021f4:	6442                	ld	s0,16(sp)
    800021f6:	6105                	addi	sp,sp,32
    800021f8:	8082                	ret

00000000800021fa <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800021fa:	1101                	addi	sp,sp,-32
    800021fc:	ec06                	sd	ra,24(sp)
    800021fe:	e822                	sd	s0,16(sp)
    80002200:	e426                	sd	s1,8(sp)
    80002202:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002204:	00008517          	auipc	a0,0x8
    80002208:	94c50513          	addi	a0,a0,-1716 # 80009b50 <tickslock>
    8000220c:	00004097          	auipc	ra,0x4
    80002210:	198080e7          	jalr	408(ra) # 800063a4 <acquire>
  xticks = ticks;
    80002214:	00006497          	auipc	s1,0x6
    80002218:	6c44a483          	lw	s1,1732(s1) # 800088d8 <ticks>
  release(&tickslock);
    8000221c:	00008517          	auipc	a0,0x8
    80002220:	93450513          	addi	a0,a0,-1740 # 80009b50 <tickslock>
    80002224:	00004097          	auipc	ra,0x4
    80002228:	234080e7          	jalr	564(ra) # 80006458 <release>
  return xticks;
}
    8000222c:	02049513          	slli	a0,s1,0x20
    80002230:	9101                	srli	a0,a0,0x20
    80002232:	60e2                	ld	ra,24(sp)
    80002234:	6442                	ld	s0,16(sp)
    80002236:	64a2                	ld	s1,8(sp)
    80002238:	6105                	addi	sp,sp,32
    8000223a:	8082                	ret

000000008000223c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000223c:	7179                	addi	sp,sp,-48
    8000223e:	f406                	sd	ra,40(sp)
    80002240:	f022                	sd	s0,32(sp)
    80002242:	ec26                	sd	s1,24(sp)
    80002244:	e84a                	sd	s2,16(sp)
    80002246:	e44e                	sd	s3,8(sp)
    80002248:	e052                	sd	s4,0(sp)
    8000224a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000224c:	00006597          	auipc	a1,0x6
    80002250:	23c58593          	addi	a1,a1,572 # 80008488 <syscalls+0xb8>
    80002254:	00008517          	auipc	a0,0x8
    80002258:	91450513          	addi	a0,a0,-1772 # 80009b68 <bcache>
    8000225c:	00004097          	auipc	ra,0x4
    80002260:	0b8080e7          	jalr	184(ra) # 80006314 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002264:	00010797          	auipc	a5,0x10
    80002268:	90478793          	addi	a5,a5,-1788 # 80011b68 <bcache+0x8000>
    8000226c:	00010717          	auipc	a4,0x10
    80002270:	b6470713          	addi	a4,a4,-1180 # 80011dd0 <bcache+0x8268>
    80002274:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002278:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000227c:	00008497          	auipc	s1,0x8
    80002280:	90448493          	addi	s1,s1,-1788 # 80009b80 <bcache+0x18>
    b->next = bcache.head.next;
    80002284:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002286:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002288:	00006a17          	auipc	s4,0x6
    8000228c:	208a0a13          	addi	s4,s4,520 # 80008490 <syscalls+0xc0>
    b->next = bcache.head.next;
    80002290:	2b893783          	ld	a5,696(s2)
    80002294:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002296:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000229a:	85d2                	mv	a1,s4
    8000229c:	01048513          	addi	a0,s1,16
    800022a0:	00001097          	auipc	ra,0x1
    800022a4:	652080e7          	jalr	1618(ra) # 800038f2 <initsleeplock>
    bcache.head.next->prev = b;
    800022a8:	2b893783          	ld	a5,696(s2)
    800022ac:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800022ae:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022b2:	45848493          	addi	s1,s1,1112
    800022b6:	fd349de3          	bne	s1,s3,80002290 <binit+0x54>
  }
}
    800022ba:	70a2                	ld	ra,40(sp)
    800022bc:	7402                	ld	s0,32(sp)
    800022be:	64e2                	ld	s1,24(sp)
    800022c0:	6942                	ld	s2,16(sp)
    800022c2:	69a2                	ld	s3,8(sp)
    800022c4:	6a02                	ld	s4,0(sp)
    800022c6:	6145                	addi	sp,sp,48
    800022c8:	8082                	ret

00000000800022ca <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022ca:	7179                	addi	sp,sp,-48
    800022cc:	f406                	sd	ra,40(sp)
    800022ce:	f022                	sd	s0,32(sp)
    800022d0:	ec26                	sd	s1,24(sp)
    800022d2:	e84a                	sd	s2,16(sp)
    800022d4:	e44e                	sd	s3,8(sp)
    800022d6:	1800                	addi	s0,sp,48
    800022d8:	892a                	mv	s2,a0
    800022da:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800022dc:	00008517          	auipc	a0,0x8
    800022e0:	88c50513          	addi	a0,a0,-1908 # 80009b68 <bcache>
    800022e4:	00004097          	auipc	ra,0x4
    800022e8:	0c0080e7          	jalr	192(ra) # 800063a4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022ec:	00010497          	auipc	s1,0x10
    800022f0:	b344b483          	ld	s1,-1228(s1) # 80011e20 <bcache+0x82b8>
    800022f4:	00010797          	auipc	a5,0x10
    800022f8:	adc78793          	addi	a5,a5,-1316 # 80011dd0 <bcache+0x8268>
    800022fc:	02f48f63          	beq	s1,a5,8000233a <bread+0x70>
    80002300:	873e                	mv	a4,a5
    80002302:	a021                	j	8000230a <bread+0x40>
    80002304:	68a4                	ld	s1,80(s1)
    80002306:	02e48a63          	beq	s1,a4,8000233a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000230a:	449c                	lw	a5,8(s1)
    8000230c:	ff279ce3          	bne	a5,s2,80002304 <bread+0x3a>
    80002310:	44dc                	lw	a5,12(s1)
    80002312:	ff3799e3          	bne	a5,s3,80002304 <bread+0x3a>
      b->refcnt++;
    80002316:	40bc                	lw	a5,64(s1)
    80002318:	2785                	addiw	a5,a5,1
    8000231a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000231c:	00008517          	auipc	a0,0x8
    80002320:	84c50513          	addi	a0,a0,-1972 # 80009b68 <bcache>
    80002324:	00004097          	auipc	ra,0x4
    80002328:	134080e7          	jalr	308(ra) # 80006458 <release>
      acquiresleep(&b->lock);
    8000232c:	01048513          	addi	a0,s1,16
    80002330:	00001097          	auipc	ra,0x1
    80002334:	5fc080e7          	jalr	1532(ra) # 8000392c <acquiresleep>
      return b;
    80002338:	a8b9                	j	80002396 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000233a:	00010497          	auipc	s1,0x10
    8000233e:	ade4b483          	ld	s1,-1314(s1) # 80011e18 <bcache+0x82b0>
    80002342:	00010797          	auipc	a5,0x10
    80002346:	a8e78793          	addi	a5,a5,-1394 # 80011dd0 <bcache+0x8268>
    8000234a:	00f48863          	beq	s1,a5,8000235a <bread+0x90>
    8000234e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002350:	40bc                	lw	a5,64(s1)
    80002352:	cf81                	beqz	a5,8000236a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002354:	64a4                	ld	s1,72(s1)
    80002356:	fee49de3          	bne	s1,a4,80002350 <bread+0x86>
  panic("bget: no buffers");
    8000235a:	00006517          	auipc	a0,0x6
    8000235e:	13e50513          	addi	a0,a0,318 # 80008498 <syscalls+0xc8>
    80002362:	00004097          	auipc	ra,0x4
    80002366:	b0a080e7          	jalr	-1270(ra) # 80005e6c <panic>
      b->dev = dev;
    8000236a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000236e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002372:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002376:	4785                	li	a5,1
    80002378:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000237a:	00007517          	auipc	a0,0x7
    8000237e:	7ee50513          	addi	a0,a0,2030 # 80009b68 <bcache>
    80002382:	00004097          	auipc	ra,0x4
    80002386:	0d6080e7          	jalr	214(ra) # 80006458 <release>
      acquiresleep(&b->lock);
    8000238a:	01048513          	addi	a0,s1,16
    8000238e:	00001097          	auipc	ra,0x1
    80002392:	59e080e7          	jalr	1438(ra) # 8000392c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002396:	409c                	lw	a5,0(s1)
    80002398:	cb89                	beqz	a5,800023aa <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000239a:	8526                	mv	a0,s1
    8000239c:	70a2                	ld	ra,40(sp)
    8000239e:	7402                	ld	s0,32(sp)
    800023a0:	64e2                	ld	s1,24(sp)
    800023a2:	6942                	ld	s2,16(sp)
    800023a4:	69a2                	ld	s3,8(sp)
    800023a6:	6145                	addi	sp,sp,48
    800023a8:	8082                	ret
    virtio_disk_rw(b, 0);
    800023aa:	4581                	li	a1,0
    800023ac:	8526                	mv	a0,s1
    800023ae:	00003097          	auipc	ra,0x3
    800023b2:	2b4080e7          	jalr	692(ra) # 80005662 <virtio_disk_rw>
    b->valid = 1;
    800023b6:	4785                	li	a5,1
    800023b8:	c09c                	sw	a5,0(s1)
  return b;
    800023ba:	b7c5                	j	8000239a <bread+0xd0>

00000000800023bc <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800023bc:	1101                	addi	sp,sp,-32
    800023be:	ec06                	sd	ra,24(sp)
    800023c0:	e822                	sd	s0,16(sp)
    800023c2:	e426                	sd	s1,8(sp)
    800023c4:	1000                	addi	s0,sp,32
    800023c6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023c8:	0541                	addi	a0,a0,16
    800023ca:	00001097          	auipc	ra,0x1
    800023ce:	5fc080e7          	jalr	1532(ra) # 800039c6 <holdingsleep>
    800023d2:	cd01                	beqz	a0,800023ea <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023d4:	4585                	li	a1,1
    800023d6:	8526                	mv	a0,s1
    800023d8:	00003097          	auipc	ra,0x3
    800023dc:	28a080e7          	jalr	650(ra) # 80005662 <virtio_disk_rw>
}
    800023e0:	60e2                	ld	ra,24(sp)
    800023e2:	6442                	ld	s0,16(sp)
    800023e4:	64a2                	ld	s1,8(sp)
    800023e6:	6105                	addi	sp,sp,32
    800023e8:	8082                	ret
    panic("bwrite");
    800023ea:	00006517          	auipc	a0,0x6
    800023ee:	0c650513          	addi	a0,a0,198 # 800084b0 <syscalls+0xe0>
    800023f2:	00004097          	auipc	ra,0x4
    800023f6:	a7a080e7          	jalr	-1414(ra) # 80005e6c <panic>

00000000800023fa <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800023fa:	1101                	addi	sp,sp,-32
    800023fc:	ec06                	sd	ra,24(sp)
    800023fe:	e822                	sd	s0,16(sp)
    80002400:	e426                	sd	s1,8(sp)
    80002402:	e04a                	sd	s2,0(sp)
    80002404:	1000                	addi	s0,sp,32
    80002406:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002408:	01050913          	addi	s2,a0,16
    8000240c:	854a                	mv	a0,s2
    8000240e:	00001097          	auipc	ra,0x1
    80002412:	5b8080e7          	jalr	1464(ra) # 800039c6 <holdingsleep>
    80002416:	c92d                	beqz	a0,80002488 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002418:	854a                	mv	a0,s2
    8000241a:	00001097          	auipc	ra,0x1
    8000241e:	568080e7          	jalr	1384(ra) # 80003982 <releasesleep>

  acquire(&bcache.lock);
    80002422:	00007517          	auipc	a0,0x7
    80002426:	74650513          	addi	a0,a0,1862 # 80009b68 <bcache>
    8000242a:	00004097          	auipc	ra,0x4
    8000242e:	f7a080e7          	jalr	-134(ra) # 800063a4 <acquire>
  b->refcnt--;
    80002432:	40bc                	lw	a5,64(s1)
    80002434:	37fd                	addiw	a5,a5,-1
    80002436:	0007871b          	sext.w	a4,a5
    8000243a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000243c:	eb05                	bnez	a4,8000246c <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000243e:	68bc                	ld	a5,80(s1)
    80002440:	64b8                	ld	a4,72(s1)
    80002442:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002444:	64bc                	ld	a5,72(s1)
    80002446:	68b8                	ld	a4,80(s1)
    80002448:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000244a:	0000f797          	auipc	a5,0xf
    8000244e:	71e78793          	addi	a5,a5,1822 # 80011b68 <bcache+0x8000>
    80002452:	2b87b703          	ld	a4,696(a5)
    80002456:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002458:	00010717          	auipc	a4,0x10
    8000245c:	97870713          	addi	a4,a4,-1672 # 80011dd0 <bcache+0x8268>
    80002460:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002462:	2b87b703          	ld	a4,696(a5)
    80002466:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002468:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000246c:	00007517          	auipc	a0,0x7
    80002470:	6fc50513          	addi	a0,a0,1788 # 80009b68 <bcache>
    80002474:	00004097          	auipc	ra,0x4
    80002478:	fe4080e7          	jalr	-28(ra) # 80006458 <release>
}
    8000247c:	60e2                	ld	ra,24(sp)
    8000247e:	6442                	ld	s0,16(sp)
    80002480:	64a2                	ld	s1,8(sp)
    80002482:	6902                	ld	s2,0(sp)
    80002484:	6105                	addi	sp,sp,32
    80002486:	8082                	ret
    panic("brelse");
    80002488:	00006517          	auipc	a0,0x6
    8000248c:	03050513          	addi	a0,a0,48 # 800084b8 <syscalls+0xe8>
    80002490:	00004097          	auipc	ra,0x4
    80002494:	9dc080e7          	jalr	-1572(ra) # 80005e6c <panic>

0000000080002498 <bpin>:

void
bpin(struct buf *b) {
    80002498:	1101                	addi	sp,sp,-32
    8000249a:	ec06                	sd	ra,24(sp)
    8000249c:	e822                	sd	s0,16(sp)
    8000249e:	e426                	sd	s1,8(sp)
    800024a0:	1000                	addi	s0,sp,32
    800024a2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024a4:	00007517          	auipc	a0,0x7
    800024a8:	6c450513          	addi	a0,a0,1732 # 80009b68 <bcache>
    800024ac:	00004097          	auipc	ra,0x4
    800024b0:	ef8080e7          	jalr	-264(ra) # 800063a4 <acquire>
  b->refcnt++;
    800024b4:	40bc                	lw	a5,64(s1)
    800024b6:	2785                	addiw	a5,a5,1
    800024b8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024ba:	00007517          	auipc	a0,0x7
    800024be:	6ae50513          	addi	a0,a0,1710 # 80009b68 <bcache>
    800024c2:	00004097          	auipc	ra,0x4
    800024c6:	f96080e7          	jalr	-106(ra) # 80006458 <release>
}
    800024ca:	60e2                	ld	ra,24(sp)
    800024cc:	6442                	ld	s0,16(sp)
    800024ce:	64a2                	ld	s1,8(sp)
    800024d0:	6105                	addi	sp,sp,32
    800024d2:	8082                	ret

00000000800024d4 <bunpin>:

void
bunpin(struct buf *b) {
    800024d4:	1101                	addi	sp,sp,-32
    800024d6:	ec06                	sd	ra,24(sp)
    800024d8:	e822                	sd	s0,16(sp)
    800024da:	e426                	sd	s1,8(sp)
    800024dc:	1000                	addi	s0,sp,32
    800024de:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024e0:	00007517          	auipc	a0,0x7
    800024e4:	68850513          	addi	a0,a0,1672 # 80009b68 <bcache>
    800024e8:	00004097          	auipc	ra,0x4
    800024ec:	ebc080e7          	jalr	-324(ra) # 800063a4 <acquire>
  b->refcnt--;
    800024f0:	40bc                	lw	a5,64(s1)
    800024f2:	37fd                	addiw	a5,a5,-1
    800024f4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024f6:	00007517          	auipc	a0,0x7
    800024fa:	67250513          	addi	a0,a0,1650 # 80009b68 <bcache>
    800024fe:	00004097          	auipc	ra,0x4
    80002502:	f5a080e7          	jalr	-166(ra) # 80006458 <release>
}
    80002506:	60e2                	ld	ra,24(sp)
    80002508:	6442                	ld	s0,16(sp)
    8000250a:	64a2                	ld	s1,8(sp)
    8000250c:	6105                	addi	sp,sp,32
    8000250e:	8082                	ret

0000000080002510 <bfree>:
    return 0;
}

// Free a disk block.
static void bfree(int dev, uint b)
{
    80002510:	1101                	addi	sp,sp,-32
    80002512:	ec06                	sd	ra,24(sp)
    80002514:	e822                	sd	s0,16(sp)
    80002516:	e426                	sd	s1,8(sp)
    80002518:	e04a                	sd	s2,0(sp)
    8000251a:	1000                	addi	s0,sp,32
    8000251c:	84ae                	mv	s1,a1
    struct buf *bp;
    int bi, m;

    bp = bread(dev, BBLOCK(b, sb));
    8000251e:	00d5d59b          	srliw	a1,a1,0xd
    80002522:	00010797          	auipc	a5,0x10
    80002526:	d227a783          	lw	a5,-734(a5) # 80012244 <sb+0x1c>
    8000252a:	9dbd                	addw	a1,a1,a5
    8000252c:	00000097          	auipc	ra,0x0
    80002530:	d9e080e7          	jalr	-610(ra) # 800022ca <bread>
    bi = b % BPB;
    m = 1 << (bi % 8);
    80002534:	0074f713          	andi	a4,s1,7
    80002538:	4785                	li	a5,1
    8000253a:	00e797bb          	sllw	a5,a5,a4
    if ((bp->data[bi / 8] & m) == 0)
    8000253e:	14ce                	slli	s1,s1,0x33
    80002540:	90d9                	srli	s1,s1,0x36
    80002542:	00950733          	add	a4,a0,s1
    80002546:	05874703          	lbu	a4,88(a4)
    8000254a:	00e7f6b3          	and	a3,a5,a4
    8000254e:	c69d                	beqz	a3,8000257c <bfree+0x6c>
    80002550:	892a                	mv	s2,a0
        panic("freeing free block");
    bp->data[bi / 8] &= ~m;
    80002552:	94aa                	add	s1,s1,a0
    80002554:	fff7c793          	not	a5,a5
    80002558:	8f7d                	and	a4,a4,a5
    8000255a:	04e48c23          	sb	a4,88(s1)
    log_write(bp);
    8000255e:	00001097          	auipc	ra,0x1
    80002562:	2b0080e7          	jalr	688(ra) # 8000380e <log_write>
    brelse(bp);
    80002566:	854a                	mv	a0,s2
    80002568:	00000097          	auipc	ra,0x0
    8000256c:	e92080e7          	jalr	-366(ra) # 800023fa <brelse>
}
    80002570:	60e2                	ld	ra,24(sp)
    80002572:	6442                	ld	s0,16(sp)
    80002574:	64a2                	ld	s1,8(sp)
    80002576:	6902                	ld	s2,0(sp)
    80002578:	6105                	addi	sp,sp,32
    8000257a:	8082                	ret
        panic("freeing free block");
    8000257c:	00006517          	auipc	a0,0x6
    80002580:	f4450513          	addi	a0,a0,-188 # 800084c0 <syscalls+0xf0>
    80002584:	00004097          	auipc	ra,0x4
    80002588:	8e8080e7          	jalr	-1816(ra) # 80005e6c <panic>

000000008000258c <balloc>:
{
    8000258c:	711d                	addi	sp,sp,-96
    8000258e:	ec86                	sd	ra,88(sp)
    80002590:	e8a2                	sd	s0,80(sp)
    80002592:	e4a6                	sd	s1,72(sp)
    80002594:	e0ca                	sd	s2,64(sp)
    80002596:	fc4e                	sd	s3,56(sp)
    80002598:	f852                	sd	s4,48(sp)
    8000259a:	f456                	sd	s5,40(sp)
    8000259c:	f05a                	sd	s6,32(sp)
    8000259e:	ec5e                	sd	s7,24(sp)
    800025a0:	e862                	sd	s8,16(sp)
    800025a2:	e466                	sd	s9,8(sp)
    800025a4:	1080                	addi	s0,sp,96
    for (b = 0; b < sb.size; b += BPB) {
    800025a6:	00010797          	auipc	a5,0x10
    800025aa:	c867a783          	lw	a5,-890(a5) # 8001222c <sb+0x4>
    800025ae:	cff5                	beqz	a5,800026aa <balloc+0x11e>
    800025b0:	8baa                	mv	s7,a0
    800025b2:	4a81                	li	s5,0
        bp = bread(dev, BBLOCK(b, sb));
    800025b4:	00010b17          	auipc	s6,0x10
    800025b8:	c74b0b13          	addi	s6,s6,-908 # 80012228 <sb>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800025bc:	4c01                	li	s8,0
            m = 1 << (bi % 8);
    800025be:	4985                	li	s3,1
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800025c0:	6a09                	lui	s4,0x2
    for (b = 0; b < sb.size; b += BPB) {
    800025c2:	6c89                	lui	s9,0x2
    800025c4:	a061                	j	8000264c <balloc+0xc0>
                bp->data[bi / 8] |= m;         // Mark block in use.
    800025c6:	97ca                	add	a5,a5,s2
    800025c8:	8e55                	or	a2,a2,a3
    800025ca:	04c78c23          	sb	a2,88(a5)
                log_write(bp);
    800025ce:	854a                	mv	a0,s2
    800025d0:	00001097          	auipc	ra,0x1
    800025d4:	23e080e7          	jalr	574(ra) # 8000380e <log_write>
                brelse(bp);
    800025d8:	854a                	mv	a0,s2
    800025da:	00000097          	auipc	ra,0x0
    800025de:	e20080e7          	jalr	-480(ra) # 800023fa <brelse>
    bp = bread(dev, bno);
    800025e2:	85a6                	mv	a1,s1
    800025e4:	855e                	mv	a0,s7
    800025e6:	00000097          	auipc	ra,0x0
    800025ea:	ce4080e7          	jalr	-796(ra) # 800022ca <bread>
    800025ee:	892a                	mv	s2,a0
    memset(bp->data, 0, BSIZE);
    800025f0:	40000613          	li	a2,1024
    800025f4:	4581                	li	a1,0
    800025f6:	05850513          	addi	a0,a0,88
    800025fa:	ffffe097          	auipc	ra,0xffffe
    800025fe:	b80080e7          	jalr	-1152(ra) # 8000017a <memset>
    log_write(bp);
    80002602:	854a                	mv	a0,s2
    80002604:	00001097          	auipc	ra,0x1
    80002608:	20a080e7          	jalr	522(ra) # 8000380e <log_write>
    brelse(bp);
    8000260c:	854a                	mv	a0,s2
    8000260e:	00000097          	auipc	ra,0x0
    80002612:	dec080e7          	jalr	-532(ra) # 800023fa <brelse>
}
    80002616:	8526                	mv	a0,s1
    80002618:	60e6                	ld	ra,88(sp)
    8000261a:	6446                	ld	s0,80(sp)
    8000261c:	64a6                	ld	s1,72(sp)
    8000261e:	6906                	ld	s2,64(sp)
    80002620:	79e2                	ld	s3,56(sp)
    80002622:	7a42                	ld	s4,48(sp)
    80002624:	7aa2                	ld	s5,40(sp)
    80002626:	7b02                	ld	s6,32(sp)
    80002628:	6be2                	ld	s7,24(sp)
    8000262a:	6c42                	ld	s8,16(sp)
    8000262c:	6ca2                	ld	s9,8(sp)
    8000262e:	6125                	addi	sp,sp,96
    80002630:	8082                	ret
        brelse(bp);
    80002632:	854a                	mv	a0,s2
    80002634:	00000097          	auipc	ra,0x0
    80002638:	dc6080e7          	jalr	-570(ra) # 800023fa <brelse>
    for (b = 0; b < sb.size; b += BPB) {
    8000263c:	015c87bb          	addw	a5,s9,s5
    80002640:	00078a9b          	sext.w	s5,a5
    80002644:	004b2703          	lw	a4,4(s6)
    80002648:	06eaf163          	bgeu	s5,a4,800026aa <balloc+0x11e>
        bp = bread(dev, BBLOCK(b, sb));
    8000264c:	41fad79b          	sraiw	a5,s5,0x1f
    80002650:	0137d79b          	srliw	a5,a5,0x13
    80002654:	015787bb          	addw	a5,a5,s5
    80002658:	40d7d79b          	sraiw	a5,a5,0xd
    8000265c:	01cb2583          	lw	a1,28(s6)
    80002660:	9dbd                	addw	a1,a1,a5
    80002662:	855e                	mv	a0,s7
    80002664:	00000097          	auipc	ra,0x0
    80002668:	c66080e7          	jalr	-922(ra) # 800022ca <bread>
    8000266c:	892a                	mv	s2,a0
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    8000266e:	004b2503          	lw	a0,4(s6)
    80002672:	000a849b          	sext.w	s1,s5
    80002676:	8762                	mv	a4,s8
    80002678:	faa4fde3          	bgeu	s1,a0,80002632 <balloc+0xa6>
            m = 1 << (bi % 8);
    8000267c:	00777693          	andi	a3,a4,7
    80002680:	00d996bb          	sllw	a3,s3,a3
            if ((bp->data[bi / 8] & m) == 0) { // Is block free?
    80002684:	41f7579b          	sraiw	a5,a4,0x1f
    80002688:	01d7d79b          	srliw	a5,a5,0x1d
    8000268c:	9fb9                	addw	a5,a5,a4
    8000268e:	4037d79b          	sraiw	a5,a5,0x3
    80002692:	00f90633          	add	a2,s2,a5
    80002696:	05864603          	lbu	a2,88(a2)
    8000269a:	00c6f5b3          	and	a1,a3,a2
    8000269e:	d585                	beqz	a1,800025c6 <balloc+0x3a>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800026a0:	2705                	addiw	a4,a4,1
    800026a2:	2485                	addiw	s1,s1,1
    800026a4:	fd471ae3          	bne	a4,s4,80002678 <balloc+0xec>
    800026a8:	b769                	j	80002632 <balloc+0xa6>
    printf("balloc: out of blocks\n");
    800026aa:	00006517          	auipc	a0,0x6
    800026ae:	e2e50513          	addi	a0,a0,-466 # 800084d8 <syscalls+0x108>
    800026b2:	00004097          	auipc	ra,0x4
    800026b6:	804080e7          	jalr	-2044(ra) # 80005eb6 <printf>
    return 0;
    800026ba:	4481                	li	s1,0
    800026bc:	bfa9                	j	80002616 <balloc+0x8a>

00000000800026be <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint bmap(struct inode *ip, uint bn)
{
    800026be:	7139                	addi	sp,sp,-64
    800026c0:	fc06                	sd	ra,56(sp)
    800026c2:	f822                	sd	s0,48(sp)
    800026c4:	f426                	sd	s1,40(sp)
    800026c6:	f04a                	sd	s2,32(sp)
    800026c8:	ec4e                	sd	s3,24(sp)
    800026ca:	e852                	sd	s4,16(sp)
    800026cc:	e456                	sd	s5,8(sp)
    800026ce:	0080                	addi	s0,sp,64
    800026d0:	89aa                	mv	s3,a0

    uint addr, *a;
    struct buf *bp;

    // 直接块
    if (bn < NDIRECT) {
    800026d2:	47a9                	li	a5,10
    800026d4:	04b7e063          	bltu	a5,a1,80002714 <bmap+0x56>
        if ((addr = ip->addrs[bn]) == 0) {
    800026d8:	02059793          	slli	a5,a1,0x20
    800026dc:	01e7d593          	srli	a1,a5,0x1e
    800026e0:	00b50933          	add	s2,a0,a1
    800026e4:	05092483          	lw	s1,80(s2)
    800026e8:	c899                	beqz	s1,800026fe <bmap+0x40>
        brelse(bp);
        return addr;
    }

    panic("bmap: out of range");
}
    800026ea:	8526                	mv	a0,s1
    800026ec:	70e2                	ld	ra,56(sp)
    800026ee:	7442                	ld	s0,48(sp)
    800026f0:	74a2                	ld	s1,40(sp)
    800026f2:	7902                	ld	s2,32(sp)
    800026f4:	69e2                	ld	s3,24(sp)
    800026f6:	6a42                	ld	s4,16(sp)
    800026f8:	6aa2                	ld	s5,8(sp)
    800026fa:	6121                	addi	sp,sp,64
    800026fc:	8082                	ret
            addr = balloc(ip->dev);
    800026fe:	4108                	lw	a0,0(a0)
    80002700:	00000097          	auipc	ra,0x0
    80002704:	e8c080e7          	jalr	-372(ra) # 8000258c <balloc>
    80002708:	0005049b          	sext.w	s1,a0
            if (addr == 0) {
    8000270c:	dcf9                	beqz	s1,800026ea <bmap+0x2c>
            ip->addrs[bn] = addr;
    8000270e:	04992823          	sw	s1,80(s2)
    80002712:	bfe1                	j	800026ea <bmap+0x2c>
    bn -= NDIRECT; // 复位
    80002714:	ff55891b          	addiw	s2,a1,-11
    80002718:	0009071b          	sext.w	a4,s2
    if (bn < NINDIRECT) {
    8000271c:	0ff00793          	li	a5,255
    80002720:	06e7ec63          	bltu	a5,a4,80002798 <bmap+0xda>
        if ((addr = ip->addrs[NDIRECT]) == 0) {
    80002724:	5d64                	lw	s1,124(a0)
    80002726:	e899                	bnez	s1,8000273c <bmap+0x7e>
            addr = balloc(ip->dev);
    80002728:	4108                	lw	a0,0(a0)
    8000272a:	00000097          	auipc	ra,0x0
    8000272e:	e62080e7          	jalr	-414(ra) # 8000258c <balloc>
    80002732:	0005049b          	sext.w	s1,a0
            if (addr == 0) {
    80002736:	d8d5                	beqz	s1,800026ea <bmap+0x2c>
            ip->addrs[NDIRECT] = addr;
    80002738:	0699ae23          	sw	s1,124(s3)
        bp = bread(ip->dev, addr); // 读取块
    8000273c:	85a6                	mv	a1,s1
    8000273e:	0009a503          	lw	a0,0(s3)
    80002742:	00000097          	auipc	ra,0x0
    80002746:	b88080e7          	jalr	-1144(ra) # 800022ca <bread>
    8000274a:	8a2a                	mv	s4,a0
        a = (uint *)bp->data;
    8000274c:	05850793          	addi	a5,a0,88
        if ((addr = a[bn]) == 0) {
    80002750:	02091713          	slli	a4,s2,0x20
    80002754:	01e75913          	srli	s2,a4,0x1e
    80002758:	993e                	add	s2,s2,a5
    8000275a:	00092483          	lw	s1,0(s2)
    8000275e:	e49d                	bnez	s1,8000278c <bmap+0xce>
            addr = balloc(ip->dev);
    80002760:	0009a503          	lw	a0,0(s3)
    80002764:	00000097          	auipc	ra,0x0
    80002768:	e28080e7          	jalr	-472(ra) # 8000258c <balloc>
    8000276c:	0005049b          	sext.w	s1,a0
            if (addr == 0) {
    80002770:	e499                	bnez	s1,8000277e <bmap+0xc0>
                brelse(bp);
    80002772:	8552                	mv	a0,s4
    80002774:	00000097          	auipc	ra,0x0
    80002778:	c86080e7          	jalr	-890(ra) # 800023fa <brelse>
                return 0;
    8000277c:	b7bd                	j	800026ea <bmap+0x2c>
            a[bn] = addr;
    8000277e:	00992023          	sw	s1,0(s2)
            log_write(bp);
    80002782:	8552                	mv	a0,s4
    80002784:	00001097          	auipc	ra,0x1
    80002788:	08a080e7          	jalr	138(ra) # 8000380e <log_write>
        brelse(bp); // 释放块
    8000278c:	8552                	mv	a0,s4
    8000278e:	00000097          	auipc	ra,0x0
    80002792:	c6c080e7          	jalr	-916(ra) # 800023fa <brelse>
        return addr;
    80002796:	bf91                	j	800026ea <bmap+0x2c>
    bn -= NINDIRECT;
    80002798:	ef55891b          	addiw	s2,a1,-267
    8000279c:	0009071b          	sext.w	a4,s2
    if (bn < NINDIRECT * NINDIRECT) {
    800027a0:	67c1                	lui	a5,0x10
    800027a2:	0cf77c63          	bgeu	a4,a5,8000287a <bmap+0x1bc>
        uint iL1 = bn / NINDIRECT; // 一级索引
    800027a6:	00895a1b          	srliw	s4,s2,0x8
        if ((addr = ip->addrs[NDIRECT + 1]) == 0) {
    800027aa:	08052483          	lw	s1,128(a0)
    800027ae:	e899                	bnez	s1,800027c4 <bmap+0x106>
            addr = balloc(ip->dev);
    800027b0:	4108                	lw	a0,0(a0)
    800027b2:	00000097          	auipc	ra,0x0
    800027b6:	dda080e7          	jalr	-550(ra) # 8000258c <balloc>
    800027ba:	0005049b          	sext.w	s1,a0
            if (addr == 0) {
    800027be:	d495                	beqz	s1,800026ea <bmap+0x2c>
            ip->addrs[NDIRECT + 1] = addr;
    800027c0:	0899a023          	sw	s1,128(s3)
        bp = bread(ip->dev, addr); // 读取第一级索引目录
    800027c4:	85a6                	mv	a1,s1
    800027c6:	0009a503          	lw	a0,0(s3)
    800027ca:	00000097          	auipc	ra,0x0
    800027ce:	b00080e7          	jalr	-1280(ra) # 800022ca <bread>
    800027d2:	8aaa                	mv	s5,a0
        a = (uint *)bp->data;
    800027d4:	05850793          	addi	a5,a0,88
        if ((addr = a[iL1]) == 0) {
    800027d8:	1a02                	slli	s4,s4,0x20
    800027da:	020a5a13          	srli	s4,s4,0x20
    800027de:	0a0a                	slli	s4,s4,0x2
    800027e0:	9a3e                	add	s4,s4,a5
    800027e2:	000a2483          	lw	s1,0(s4) # 2000 <_entry-0x7fffe000>
    800027e6:	e08d                	bnez	s1,80002808 <bmap+0x14a>
            addr = balloc(ip->dev);
    800027e8:	0009a503          	lw	a0,0(s3)
    800027ec:	00000097          	auipc	ra,0x0
    800027f0:	da0080e7          	jalr	-608(ra) # 8000258c <balloc>
    800027f4:	0005049b          	sext.w	s1,a0
            if (addr == 0) {
    800027f8:	ccb1                	beqz	s1,80002854 <bmap+0x196>
            a[iL1] = addr;
    800027fa:	009a2023          	sw	s1,0(s4)
            log_write(bp);
    800027fe:	8556                	mv	a0,s5
    80002800:	00001097          	auipc	ra,0x1
    80002804:	00e080e7          	jalr	14(ra) # 8000380e <log_write>
        brelse(bp); // 使用了bp来读取，此时释放
    80002808:	8556                	mv	a0,s5
    8000280a:	00000097          	auipc	ra,0x0
    8000280e:	bf0080e7          	jalr	-1040(ra) # 800023fa <brelse>
        bp = bread(ip->dev, addr); // 读取二级索引目录
    80002812:	85a6                	mv	a1,s1
    80002814:	0009a503          	lw	a0,0(s3)
    80002818:	00000097          	auipc	ra,0x0
    8000281c:	ab2080e7          	jalr	-1358(ra) # 800022ca <bread>
    80002820:	8a2a                	mv	s4,a0
        a = (uint *)bp->data;
    80002822:	05850793          	addi	a5,a0,88
        if ((addr = a[iL2]) == 0) {
    80002826:	0ff97593          	zext.b	a1,s2
    8000282a:	058a                	slli	a1,a1,0x2
    8000282c:	00b78933          	add	s2,a5,a1
    80002830:	00092483          	lw	s1,0(s2)
    80002834:	ec8d                	bnez	s1,8000286e <bmap+0x1b0>
            addr = balloc(ip->dev);
    80002836:	0009a503          	lw	a0,0(s3)
    8000283a:	00000097          	auipc	ra,0x0
    8000283e:	d52080e7          	jalr	-686(ra) # 8000258c <balloc>
    80002842:	0005049b          	sext.w	s1,a0
            if (addr == 0) {
    80002846:	ec89                	bnez	s1,80002860 <bmap+0x1a2>
                brelse(bp);
    80002848:	8552                	mv	a0,s4
    8000284a:	00000097          	auipc	ra,0x0
    8000284e:	bb0080e7          	jalr	-1104(ra) # 800023fa <brelse>
                return 0;
    80002852:	bd61                	j	800026ea <bmap+0x2c>
                brelse(bp);
    80002854:	8556                	mv	a0,s5
    80002856:	00000097          	auipc	ra,0x0
    8000285a:	ba4080e7          	jalr	-1116(ra) # 800023fa <brelse>
                return 0;
    8000285e:	b571                	j	800026ea <bmap+0x2c>
            a[iL2] = addr;
    80002860:	00992023          	sw	s1,0(s2)
            log_write(bp);
    80002864:	8552                	mv	a0,s4
    80002866:	00001097          	auipc	ra,0x1
    8000286a:	fa8080e7          	jalr	-88(ra) # 8000380e <log_write>
        brelse(bp);
    8000286e:	8552                	mv	a0,s4
    80002870:	00000097          	auipc	ra,0x0
    80002874:	b8a080e7          	jalr	-1142(ra) # 800023fa <brelse>
        return addr;
    80002878:	bd8d                	j	800026ea <bmap+0x2c>
    panic("bmap: out of range");
    8000287a:	00006517          	auipc	a0,0x6
    8000287e:	c7650513          	addi	a0,a0,-906 # 800084f0 <syscalls+0x120>
    80002882:	00003097          	auipc	ra,0x3
    80002886:	5ea080e7          	jalr	1514(ra) # 80005e6c <panic>

000000008000288a <iget>:
{
    8000288a:	7179                	addi	sp,sp,-48
    8000288c:	f406                	sd	ra,40(sp)
    8000288e:	f022                	sd	s0,32(sp)
    80002890:	ec26                	sd	s1,24(sp)
    80002892:	e84a                	sd	s2,16(sp)
    80002894:	e44e                	sd	s3,8(sp)
    80002896:	e052                	sd	s4,0(sp)
    80002898:	1800                	addi	s0,sp,48
    8000289a:	89aa                	mv	s3,a0
    8000289c:	8a2e                	mv	s4,a1
    acquire(&itable.lock);
    8000289e:	00010517          	auipc	a0,0x10
    800028a2:	9aa50513          	addi	a0,a0,-1622 # 80012248 <itable>
    800028a6:	00004097          	auipc	ra,0x4
    800028aa:	afe080e7          	jalr	-1282(ra) # 800063a4 <acquire>
    empty = 0;
    800028ae:	4901                	li	s2,0
    for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    800028b0:	00010497          	auipc	s1,0x10
    800028b4:	9b048493          	addi	s1,s1,-1616 # 80012260 <itable+0x18>
    800028b8:	00011697          	auipc	a3,0x11
    800028bc:	43868693          	addi	a3,a3,1080 # 80013cf0 <log>
    800028c0:	a039                	j	800028ce <iget+0x44>
        if (empty == 0 && ip->ref == 0) // Remember empty slot.
    800028c2:	02090b63          	beqz	s2,800028f8 <iget+0x6e>
    for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    800028c6:	08848493          	addi	s1,s1,136
    800028ca:	02d48a63          	beq	s1,a3,800028fe <iget+0x74>
        if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    800028ce:	449c                	lw	a5,8(s1)
    800028d0:	fef059e3          	blez	a5,800028c2 <iget+0x38>
    800028d4:	4098                	lw	a4,0(s1)
    800028d6:	ff3716e3          	bne	a4,s3,800028c2 <iget+0x38>
    800028da:	40d8                	lw	a4,4(s1)
    800028dc:	ff4713e3          	bne	a4,s4,800028c2 <iget+0x38>
            ip->ref++;
    800028e0:	2785                	addiw	a5,a5,1 # 10001 <_entry-0x7ffeffff>
    800028e2:	c49c                	sw	a5,8(s1)
            release(&itable.lock);
    800028e4:	00010517          	auipc	a0,0x10
    800028e8:	96450513          	addi	a0,a0,-1692 # 80012248 <itable>
    800028ec:	00004097          	auipc	ra,0x4
    800028f0:	b6c080e7          	jalr	-1172(ra) # 80006458 <release>
            return ip;
    800028f4:	8926                	mv	s2,s1
    800028f6:	a03d                	j	80002924 <iget+0x9a>
        if (empty == 0 && ip->ref == 0) // Remember empty slot.
    800028f8:	f7f9                	bnez	a5,800028c6 <iget+0x3c>
    800028fa:	8926                	mv	s2,s1
    800028fc:	b7e9                	j	800028c6 <iget+0x3c>
    if (empty == 0)
    800028fe:	02090c63          	beqz	s2,80002936 <iget+0xac>
    ip->dev = dev;
    80002902:	01392023          	sw	s3,0(s2)
    ip->inum = inum;
    80002906:	01492223          	sw	s4,4(s2)
    ip->ref = 1;
    8000290a:	4785                	li	a5,1
    8000290c:	00f92423          	sw	a5,8(s2)
    ip->valid = 0;
    80002910:	04092023          	sw	zero,64(s2)
    release(&itable.lock);
    80002914:	00010517          	auipc	a0,0x10
    80002918:	93450513          	addi	a0,a0,-1740 # 80012248 <itable>
    8000291c:	00004097          	auipc	ra,0x4
    80002920:	b3c080e7          	jalr	-1220(ra) # 80006458 <release>
}
    80002924:	854a                	mv	a0,s2
    80002926:	70a2                	ld	ra,40(sp)
    80002928:	7402                	ld	s0,32(sp)
    8000292a:	64e2                	ld	s1,24(sp)
    8000292c:	6942                	ld	s2,16(sp)
    8000292e:	69a2                	ld	s3,8(sp)
    80002930:	6a02                	ld	s4,0(sp)
    80002932:	6145                	addi	sp,sp,48
    80002934:	8082                	ret
        panic("iget: no inodes");
    80002936:	00006517          	auipc	a0,0x6
    8000293a:	bd250513          	addi	a0,a0,-1070 # 80008508 <syscalls+0x138>
    8000293e:	00003097          	auipc	ra,0x3
    80002942:	52e080e7          	jalr	1326(ra) # 80005e6c <panic>

0000000080002946 <fsinit>:
{
    80002946:	7179                	addi	sp,sp,-48
    80002948:	f406                	sd	ra,40(sp)
    8000294a:	f022                	sd	s0,32(sp)
    8000294c:	ec26                	sd	s1,24(sp)
    8000294e:	e84a                	sd	s2,16(sp)
    80002950:	e44e                	sd	s3,8(sp)
    80002952:	1800                	addi	s0,sp,48
    80002954:	892a                	mv	s2,a0
    bp = bread(dev, 1);
    80002956:	4585                	li	a1,1
    80002958:	00000097          	auipc	ra,0x0
    8000295c:	972080e7          	jalr	-1678(ra) # 800022ca <bread>
    80002960:	84aa                	mv	s1,a0
    memmove(sb, bp->data, sizeof(*sb));
    80002962:	00010997          	auipc	s3,0x10
    80002966:	8c698993          	addi	s3,s3,-1850 # 80012228 <sb>
    8000296a:	02000613          	li	a2,32
    8000296e:	05850593          	addi	a1,a0,88
    80002972:	854e                	mv	a0,s3
    80002974:	ffffe097          	auipc	ra,0xffffe
    80002978:	862080e7          	jalr	-1950(ra) # 800001d6 <memmove>
    brelse(bp);
    8000297c:	8526                	mv	a0,s1
    8000297e:	00000097          	auipc	ra,0x0
    80002982:	a7c080e7          	jalr	-1412(ra) # 800023fa <brelse>
    if (sb.magic != FSMAGIC)
    80002986:	0009a703          	lw	a4,0(s3)
    8000298a:	102037b7          	lui	a5,0x10203
    8000298e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002992:	02f71263          	bne	a4,a5,800029b6 <fsinit+0x70>
    initlog(dev, &sb);
    80002996:	00010597          	auipc	a1,0x10
    8000299a:	89258593          	addi	a1,a1,-1902 # 80012228 <sb>
    8000299e:	854a                	mv	a0,s2
    800029a0:	00001097          	auipc	ra,0x1
    800029a4:	bf2080e7          	jalr	-1038(ra) # 80003592 <initlog>
}
    800029a8:	70a2                	ld	ra,40(sp)
    800029aa:	7402                	ld	s0,32(sp)
    800029ac:	64e2                	ld	s1,24(sp)
    800029ae:	6942                	ld	s2,16(sp)
    800029b0:	69a2                	ld	s3,8(sp)
    800029b2:	6145                	addi	sp,sp,48
    800029b4:	8082                	ret
        panic("invalid file system");
    800029b6:	00006517          	auipc	a0,0x6
    800029ba:	b6250513          	addi	a0,a0,-1182 # 80008518 <syscalls+0x148>
    800029be:	00003097          	auipc	ra,0x3
    800029c2:	4ae080e7          	jalr	1198(ra) # 80005e6c <panic>

00000000800029c6 <iinit>:
{
    800029c6:	7179                	addi	sp,sp,-48
    800029c8:	f406                	sd	ra,40(sp)
    800029ca:	f022                	sd	s0,32(sp)
    800029cc:	ec26                	sd	s1,24(sp)
    800029ce:	e84a                	sd	s2,16(sp)
    800029d0:	e44e                	sd	s3,8(sp)
    800029d2:	1800                	addi	s0,sp,48
    initlock(&itable.lock, "itable");
    800029d4:	00006597          	auipc	a1,0x6
    800029d8:	b5c58593          	addi	a1,a1,-1188 # 80008530 <syscalls+0x160>
    800029dc:	00010517          	auipc	a0,0x10
    800029e0:	86c50513          	addi	a0,a0,-1940 # 80012248 <itable>
    800029e4:	00004097          	auipc	ra,0x4
    800029e8:	930080e7          	jalr	-1744(ra) # 80006314 <initlock>
    for (i = 0; i < NINODE; i++) {
    800029ec:	00010497          	auipc	s1,0x10
    800029f0:	88448493          	addi	s1,s1,-1916 # 80012270 <itable+0x28>
    800029f4:	00011997          	auipc	s3,0x11
    800029f8:	30c98993          	addi	s3,s3,780 # 80013d00 <log+0x10>
        initsleeplock(&itable.inode[i].lock, "inode");
    800029fc:	00006917          	auipc	s2,0x6
    80002a00:	b3c90913          	addi	s2,s2,-1220 # 80008538 <syscalls+0x168>
    80002a04:	85ca                	mv	a1,s2
    80002a06:	8526                	mv	a0,s1
    80002a08:	00001097          	auipc	ra,0x1
    80002a0c:	eea080e7          	jalr	-278(ra) # 800038f2 <initsleeplock>
    for (i = 0; i < NINODE; i++) {
    80002a10:	08848493          	addi	s1,s1,136
    80002a14:	ff3498e3          	bne	s1,s3,80002a04 <iinit+0x3e>
}
    80002a18:	70a2                	ld	ra,40(sp)
    80002a1a:	7402                	ld	s0,32(sp)
    80002a1c:	64e2                	ld	s1,24(sp)
    80002a1e:	6942                	ld	s2,16(sp)
    80002a20:	69a2                	ld	s3,8(sp)
    80002a22:	6145                	addi	sp,sp,48
    80002a24:	8082                	ret

0000000080002a26 <ialloc>:
{
    80002a26:	715d                	addi	sp,sp,-80
    80002a28:	e486                	sd	ra,72(sp)
    80002a2a:	e0a2                	sd	s0,64(sp)
    80002a2c:	fc26                	sd	s1,56(sp)
    80002a2e:	f84a                	sd	s2,48(sp)
    80002a30:	f44e                	sd	s3,40(sp)
    80002a32:	f052                	sd	s4,32(sp)
    80002a34:	ec56                	sd	s5,24(sp)
    80002a36:	e85a                	sd	s6,16(sp)
    80002a38:	e45e                	sd	s7,8(sp)
    80002a3a:	0880                	addi	s0,sp,80
    for (inum = 1; inum < sb.ninodes; inum++) {
    80002a3c:	0000f717          	auipc	a4,0xf
    80002a40:	7f872703          	lw	a4,2040(a4) # 80012234 <sb+0xc>
    80002a44:	4785                	li	a5,1
    80002a46:	04e7fa63          	bgeu	a5,a4,80002a9a <ialloc+0x74>
    80002a4a:	8aaa                	mv	s5,a0
    80002a4c:	8bae                	mv	s7,a1
    80002a4e:	4485                	li	s1,1
        bp = bread(dev, IBLOCK(inum, sb));
    80002a50:	0000fa17          	auipc	s4,0xf
    80002a54:	7d8a0a13          	addi	s4,s4,2008 # 80012228 <sb>
    80002a58:	00048b1b          	sext.w	s6,s1
    80002a5c:	0044d593          	srli	a1,s1,0x4
    80002a60:	018a2783          	lw	a5,24(s4)
    80002a64:	9dbd                	addw	a1,a1,a5
    80002a66:	8556                	mv	a0,s5
    80002a68:	00000097          	auipc	ra,0x0
    80002a6c:	862080e7          	jalr	-1950(ra) # 800022ca <bread>
    80002a70:	892a                	mv	s2,a0
        dip = (struct dinode *)bp->data + inum % IPB;
    80002a72:	05850993          	addi	s3,a0,88
    80002a76:	00f4f793          	andi	a5,s1,15
    80002a7a:	079a                	slli	a5,a5,0x6
    80002a7c:	99be                	add	s3,s3,a5
        if (dip->type == 0) { // a free inode
    80002a7e:	00099783          	lh	a5,0(s3)
    80002a82:	c3a1                	beqz	a5,80002ac2 <ialloc+0x9c>
        brelse(bp);
    80002a84:	00000097          	auipc	ra,0x0
    80002a88:	976080e7          	jalr	-1674(ra) # 800023fa <brelse>
    for (inum = 1; inum < sb.ninodes; inum++) {
    80002a8c:	0485                	addi	s1,s1,1
    80002a8e:	00ca2703          	lw	a4,12(s4)
    80002a92:	0004879b          	sext.w	a5,s1
    80002a96:	fce7e1e3          	bltu	a5,a4,80002a58 <ialloc+0x32>
    printf("ialloc: no inodes\n");
    80002a9a:	00006517          	auipc	a0,0x6
    80002a9e:	aa650513          	addi	a0,a0,-1370 # 80008540 <syscalls+0x170>
    80002aa2:	00003097          	auipc	ra,0x3
    80002aa6:	414080e7          	jalr	1044(ra) # 80005eb6 <printf>
    return 0;
    80002aaa:	4501                	li	a0,0
}
    80002aac:	60a6                	ld	ra,72(sp)
    80002aae:	6406                	ld	s0,64(sp)
    80002ab0:	74e2                	ld	s1,56(sp)
    80002ab2:	7942                	ld	s2,48(sp)
    80002ab4:	79a2                	ld	s3,40(sp)
    80002ab6:	7a02                	ld	s4,32(sp)
    80002ab8:	6ae2                	ld	s5,24(sp)
    80002aba:	6b42                	ld	s6,16(sp)
    80002abc:	6ba2                	ld	s7,8(sp)
    80002abe:	6161                	addi	sp,sp,80
    80002ac0:	8082                	ret
            memset(dip, 0, sizeof(*dip));
    80002ac2:	04000613          	li	a2,64
    80002ac6:	4581                	li	a1,0
    80002ac8:	854e                	mv	a0,s3
    80002aca:	ffffd097          	auipc	ra,0xffffd
    80002ace:	6b0080e7          	jalr	1712(ra) # 8000017a <memset>
            dip->type = type;
    80002ad2:	01799023          	sh	s7,0(s3)
            log_write(bp); // mark it allocated on the disk
    80002ad6:	854a                	mv	a0,s2
    80002ad8:	00001097          	auipc	ra,0x1
    80002adc:	d36080e7          	jalr	-714(ra) # 8000380e <log_write>
            brelse(bp);
    80002ae0:	854a                	mv	a0,s2
    80002ae2:	00000097          	auipc	ra,0x0
    80002ae6:	918080e7          	jalr	-1768(ra) # 800023fa <brelse>
            return iget(dev, inum);
    80002aea:	85da                	mv	a1,s6
    80002aec:	8556                	mv	a0,s5
    80002aee:	00000097          	auipc	ra,0x0
    80002af2:	d9c080e7          	jalr	-612(ra) # 8000288a <iget>
    80002af6:	bf5d                	j	80002aac <ialloc+0x86>

0000000080002af8 <iupdate>:
{
    80002af8:	1101                	addi	sp,sp,-32
    80002afa:	ec06                	sd	ra,24(sp)
    80002afc:	e822                	sd	s0,16(sp)
    80002afe:	e426                	sd	s1,8(sp)
    80002b00:	e04a                	sd	s2,0(sp)
    80002b02:	1000                	addi	s0,sp,32
    80002b04:	84aa                	mv	s1,a0
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b06:	415c                	lw	a5,4(a0)
    80002b08:	0047d79b          	srliw	a5,a5,0x4
    80002b0c:	0000f597          	auipc	a1,0xf
    80002b10:	7345a583          	lw	a1,1844(a1) # 80012240 <sb+0x18>
    80002b14:	9dbd                	addw	a1,a1,a5
    80002b16:	4108                	lw	a0,0(a0)
    80002b18:	fffff097          	auipc	ra,0xfffff
    80002b1c:	7b2080e7          	jalr	1970(ra) # 800022ca <bread>
    80002b20:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002b22:	05850793          	addi	a5,a0,88
    80002b26:	40d8                	lw	a4,4(s1)
    80002b28:	8b3d                	andi	a4,a4,15
    80002b2a:	071a                	slli	a4,a4,0x6
    80002b2c:	97ba                	add	a5,a5,a4
    dip->type = ip->type;
    80002b2e:	04449703          	lh	a4,68(s1)
    80002b32:	00e79023          	sh	a4,0(a5)
    dip->major = ip->major;
    80002b36:	04649703          	lh	a4,70(s1)
    80002b3a:	00e79123          	sh	a4,2(a5)
    dip->minor = ip->minor;
    80002b3e:	04849703          	lh	a4,72(s1)
    80002b42:	00e79223          	sh	a4,4(a5)
    dip->nlink = ip->nlink;
    80002b46:	04a49703          	lh	a4,74(s1)
    80002b4a:	00e79323          	sh	a4,6(a5)
    dip->size = ip->size;
    80002b4e:	44f8                	lw	a4,76(s1)
    80002b50:	c798                	sw	a4,8(a5)
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b52:	03400613          	li	a2,52
    80002b56:	05048593          	addi	a1,s1,80
    80002b5a:	00c78513          	addi	a0,a5,12
    80002b5e:	ffffd097          	auipc	ra,0xffffd
    80002b62:	678080e7          	jalr	1656(ra) # 800001d6 <memmove>
    log_write(bp);
    80002b66:	854a                	mv	a0,s2
    80002b68:	00001097          	auipc	ra,0x1
    80002b6c:	ca6080e7          	jalr	-858(ra) # 8000380e <log_write>
    brelse(bp);
    80002b70:	854a                	mv	a0,s2
    80002b72:	00000097          	auipc	ra,0x0
    80002b76:	888080e7          	jalr	-1912(ra) # 800023fa <brelse>
}
    80002b7a:	60e2                	ld	ra,24(sp)
    80002b7c:	6442                	ld	s0,16(sp)
    80002b7e:	64a2                	ld	s1,8(sp)
    80002b80:	6902                	ld	s2,0(sp)
    80002b82:	6105                	addi	sp,sp,32
    80002b84:	8082                	ret

0000000080002b86 <idup>:
{
    80002b86:	1101                	addi	sp,sp,-32
    80002b88:	ec06                	sd	ra,24(sp)
    80002b8a:	e822                	sd	s0,16(sp)
    80002b8c:	e426                	sd	s1,8(sp)
    80002b8e:	1000                	addi	s0,sp,32
    80002b90:	84aa                	mv	s1,a0
    acquire(&itable.lock);
    80002b92:	0000f517          	auipc	a0,0xf
    80002b96:	6b650513          	addi	a0,a0,1718 # 80012248 <itable>
    80002b9a:	00004097          	auipc	ra,0x4
    80002b9e:	80a080e7          	jalr	-2038(ra) # 800063a4 <acquire>
    ip->ref++;
    80002ba2:	449c                	lw	a5,8(s1)
    80002ba4:	2785                	addiw	a5,a5,1
    80002ba6:	c49c                	sw	a5,8(s1)
    release(&itable.lock);
    80002ba8:	0000f517          	auipc	a0,0xf
    80002bac:	6a050513          	addi	a0,a0,1696 # 80012248 <itable>
    80002bb0:	00004097          	auipc	ra,0x4
    80002bb4:	8a8080e7          	jalr	-1880(ra) # 80006458 <release>
}
    80002bb8:	8526                	mv	a0,s1
    80002bba:	60e2                	ld	ra,24(sp)
    80002bbc:	6442                	ld	s0,16(sp)
    80002bbe:	64a2                	ld	s1,8(sp)
    80002bc0:	6105                	addi	sp,sp,32
    80002bc2:	8082                	ret

0000000080002bc4 <ilock>:
{
    80002bc4:	1101                	addi	sp,sp,-32
    80002bc6:	ec06                	sd	ra,24(sp)
    80002bc8:	e822                	sd	s0,16(sp)
    80002bca:	e426                	sd	s1,8(sp)
    80002bcc:	e04a                	sd	s2,0(sp)
    80002bce:	1000                	addi	s0,sp,32
    if (ip == 0 || ip->ref < 1)
    80002bd0:	c115                	beqz	a0,80002bf4 <ilock+0x30>
    80002bd2:	84aa                	mv	s1,a0
    80002bd4:	451c                	lw	a5,8(a0)
    80002bd6:	00f05f63          	blez	a5,80002bf4 <ilock+0x30>
    acquiresleep(&ip->lock);
    80002bda:	0541                	addi	a0,a0,16
    80002bdc:	00001097          	auipc	ra,0x1
    80002be0:	d50080e7          	jalr	-688(ra) # 8000392c <acquiresleep>
    if (ip->valid == 0) {
    80002be4:	40bc                	lw	a5,64(s1)
    80002be6:	cf99                	beqz	a5,80002c04 <ilock+0x40>
}
    80002be8:	60e2                	ld	ra,24(sp)
    80002bea:	6442                	ld	s0,16(sp)
    80002bec:	64a2                	ld	s1,8(sp)
    80002bee:	6902                	ld	s2,0(sp)
    80002bf0:	6105                	addi	sp,sp,32
    80002bf2:	8082                	ret
        panic("ilock");
    80002bf4:	00006517          	auipc	a0,0x6
    80002bf8:	96450513          	addi	a0,a0,-1692 # 80008558 <syscalls+0x188>
    80002bfc:	00003097          	auipc	ra,0x3
    80002c00:	270080e7          	jalr	624(ra) # 80005e6c <panic>
        bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c04:	40dc                	lw	a5,4(s1)
    80002c06:	0047d79b          	srliw	a5,a5,0x4
    80002c0a:	0000f597          	auipc	a1,0xf
    80002c0e:	6365a583          	lw	a1,1590(a1) # 80012240 <sb+0x18>
    80002c12:	9dbd                	addw	a1,a1,a5
    80002c14:	4088                	lw	a0,0(s1)
    80002c16:	fffff097          	auipc	ra,0xfffff
    80002c1a:	6b4080e7          	jalr	1716(ra) # 800022ca <bread>
    80002c1e:	892a                	mv	s2,a0
        dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002c20:	05850593          	addi	a1,a0,88
    80002c24:	40dc                	lw	a5,4(s1)
    80002c26:	8bbd                	andi	a5,a5,15
    80002c28:	079a                	slli	a5,a5,0x6
    80002c2a:	95be                	add	a1,a1,a5
        ip->type = dip->type;
    80002c2c:	00059783          	lh	a5,0(a1)
    80002c30:	04f49223          	sh	a5,68(s1)
        ip->major = dip->major;
    80002c34:	00259783          	lh	a5,2(a1)
    80002c38:	04f49323          	sh	a5,70(s1)
        ip->minor = dip->minor;
    80002c3c:	00459783          	lh	a5,4(a1)
    80002c40:	04f49423          	sh	a5,72(s1)
        ip->nlink = dip->nlink;
    80002c44:	00659783          	lh	a5,6(a1)
    80002c48:	04f49523          	sh	a5,74(s1)
        ip->size = dip->size;
    80002c4c:	459c                	lw	a5,8(a1)
    80002c4e:	c4fc                	sw	a5,76(s1)
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c50:	03400613          	li	a2,52
    80002c54:	05b1                	addi	a1,a1,12
    80002c56:	05048513          	addi	a0,s1,80
    80002c5a:	ffffd097          	auipc	ra,0xffffd
    80002c5e:	57c080e7          	jalr	1404(ra) # 800001d6 <memmove>
        brelse(bp);
    80002c62:	854a                	mv	a0,s2
    80002c64:	fffff097          	auipc	ra,0xfffff
    80002c68:	796080e7          	jalr	1942(ra) # 800023fa <brelse>
        ip->valid = 1;
    80002c6c:	4785                	li	a5,1
    80002c6e:	c0bc                	sw	a5,64(s1)
        if (ip->type == 0)
    80002c70:	04449783          	lh	a5,68(s1)
    80002c74:	fbb5                	bnez	a5,80002be8 <ilock+0x24>
            panic("ilock: no type");
    80002c76:	00006517          	auipc	a0,0x6
    80002c7a:	8ea50513          	addi	a0,a0,-1814 # 80008560 <syscalls+0x190>
    80002c7e:	00003097          	auipc	ra,0x3
    80002c82:	1ee080e7          	jalr	494(ra) # 80005e6c <panic>

0000000080002c86 <iunlock>:
{
    80002c86:	1101                	addi	sp,sp,-32
    80002c88:	ec06                	sd	ra,24(sp)
    80002c8a:	e822                	sd	s0,16(sp)
    80002c8c:	e426                	sd	s1,8(sp)
    80002c8e:	e04a                	sd	s2,0(sp)
    80002c90:	1000                	addi	s0,sp,32
    if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c92:	c905                	beqz	a0,80002cc2 <iunlock+0x3c>
    80002c94:	84aa                	mv	s1,a0
    80002c96:	01050913          	addi	s2,a0,16
    80002c9a:	854a                	mv	a0,s2
    80002c9c:	00001097          	auipc	ra,0x1
    80002ca0:	d2a080e7          	jalr	-726(ra) # 800039c6 <holdingsleep>
    80002ca4:	cd19                	beqz	a0,80002cc2 <iunlock+0x3c>
    80002ca6:	449c                	lw	a5,8(s1)
    80002ca8:	00f05d63          	blez	a5,80002cc2 <iunlock+0x3c>
    releasesleep(&ip->lock);
    80002cac:	854a                	mv	a0,s2
    80002cae:	00001097          	auipc	ra,0x1
    80002cb2:	cd4080e7          	jalr	-812(ra) # 80003982 <releasesleep>
}
    80002cb6:	60e2                	ld	ra,24(sp)
    80002cb8:	6442                	ld	s0,16(sp)
    80002cba:	64a2                	ld	s1,8(sp)
    80002cbc:	6902                	ld	s2,0(sp)
    80002cbe:	6105                	addi	sp,sp,32
    80002cc0:	8082                	ret
        panic("iunlock");
    80002cc2:	00006517          	auipc	a0,0x6
    80002cc6:	8ae50513          	addi	a0,a0,-1874 # 80008570 <syscalls+0x1a0>
    80002cca:	00003097          	auipc	ra,0x3
    80002cce:	1a2080e7          	jalr	418(ra) # 80005e6c <panic>

0000000080002cd2 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void itrunc(struct inode *ip)
{
    80002cd2:	715d                	addi	sp,sp,-80
    80002cd4:	e486                	sd	ra,72(sp)
    80002cd6:	e0a2                	sd	s0,64(sp)
    80002cd8:	fc26                	sd	s1,56(sp)
    80002cda:	f84a                	sd	s2,48(sp)
    80002cdc:	f44e                	sd	s3,40(sp)
    80002cde:	f052                	sd	s4,32(sp)
    80002ce0:	ec56                	sd	s5,24(sp)
    80002ce2:	e85a                	sd	s6,16(sp)
    80002ce4:	e45e                	sd	s7,8(sp)
    80002ce6:	e062                	sd	s8,0(sp)
    80002ce8:	0880                	addi	s0,sp,80
    80002cea:	89aa                	mv	s3,a0
    int i, j;
    struct buf *bp;
    uint *a;

    for (i = 0; i < NDIRECT; i++) {
    80002cec:	05050493          	addi	s1,a0,80
    80002cf0:	07c50913          	addi	s2,a0,124
    80002cf4:	a021                	j	80002cfc <itrunc+0x2a>
    80002cf6:	0491                	addi	s1,s1,4
    80002cf8:	01248d63          	beq	s1,s2,80002d12 <itrunc+0x40>
        if (ip->addrs[i]) {
    80002cfc:	408c                	lw	a1,0(s1)
    80002cfe:	dde5                	beqz	a1,80002cf6 <itrunc+0x24>
            bfree(ip->dev, ip->addrs[i]);
    80002d00:	0009a503          	lw	a0,0(s3)
    80002d04:	00000097          	auipc	ra,0x0
    80002d08:	80c080e7          	jalr	-2036(ra) # 80002510 <bfree>
            ip->addrs[i] = 0;
    80002d0c:	0004a023          	sw	zero,0(s1)
    80002d10:	b7dd                	j	80002cf6 <itrunc+0x24>
        }
    }

    // 释放一级索引目录对应的物理块
    if (ip->addrs[NDIRECT]) {
    80002d12:	07c9a583          	lw	a1,124(s3)
    80002d16:	e59d                	bnez	a1,80002d44 <itrunc+0x72>

    struct buf *bpL2;
    uint *b;
    int k;
    // 释放二级索引目录对应的物理块
    if (ip->addrs[NDIRECT + 1]) {
    80002d18:	0809a583          	lw	a1,128(s3)
    80002d1c:	eda5                	bnez	a1,80002d94 <itrunc+0xc2>
        }
        brelse(bp);
        bfree(ip->dev, ip->addrs[NDIRECT + 1]);
        ip->addrs[NDIRECT + 1] = 0;
    }
    ip->size = 0;
    80002d1e:	0409a623          	sw	zero,76(s3)
    iupdate(ip);
    80002d22:	854e                	mv	a0,s3
    80002d24:	00000097          	auipc	ra,0x0
    80002d28:	dd4080e7          	jalr	-556(ra) # 80002af8 <iupdate>
}
    80002d2c:	60a6                	ld	ra,72(sp)
    80002d2e:	6406                	ld	s0,64(sp)
    80002d30:	74e2                	ld	s1,56(sp)
    80002d32:	7942                	ld	s2,48(sp)
    80002d34:	79a2                	ld	s3,40(sp)
    80002d36:	7a02                	ld	s4,32(sp)
    80002d38:	6ae2                	ld	s5,24(sp)
    80002d3a:	6b42                	ld	s6,16(sp)
    80002d3c:	6ba2                	ld	s7,8(sp)
    80002d3e:	6c02                	ld	s8,0(sp)
    80002d40:	6161                	addi	sp,sp,80
    80002d42:	8082                	ret
        bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d44:	0009a503          	lw	a0,0(s3)
    80002d48:	fffff097          	auipc	ra,0xfffff
    80002d4c:	582080e7          	jalr	1410(ra) # 800022ca <bread>
    80002d50:	8a2a                	mv	s4,a0
        for (j = 0; j < NINDIRECT; j++) {
    80002d52:	05850493          	addi	s1,a0,88
    80002d56:	45850913          	addi	s2,a0,1112
    80002d5a:	a021                	j	80002d62 <itrunc+0x90>
    80002d5c:	0491                	addi	s1,s1,4
    80002d5e:	01248b63          	beq	s1,s2,80002d74 <itrunc+0xa2>
            if (a[j])
    80002d62:	408c                	lw	a1,0(s1)
    80002d64:	dde5                	beqz	a1,80002d5c <itrunc+0x8a>
                bfree(ip->dev, a[j]);
    80002d66:	0009a503          	lw	a0,0(s3)
    80002d6a:	fffff097          	auipc	ra,0xfffff
    80002d6e:	7a6080e7          	jalr	1958(ra) # 80002510 <bfree>
    80002d72:	b7ed                	j	80002d5c <itrunc+0x8a>
        brelse(bp);
    80002d74:	8552                	mv	a0,s4
    80002d76:	fffff097          	auipc	ra,0xfffff
    80002d7a:	684080e7          	jalr	1668(ra) # 800023fa <brelse>
        bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d7e:	07c9a583          	lw	a1,124(s3)
    80002d82:	0009a503          	lw	a0,0(s3)
    80002d86:	fffff097          	auipc	ra,0xfffff
    80002d8a:	78a080e7          	jalr	1930(ra) # 80002510 <bfree>
        ip->addrs[NDIRECT] = 0;
    80002d8e:	0609ae23          	sw	zero,124(s3)
    80002d92:	b759                	j	80002d18 <itrunc+0x46>
        bp = bread(ip->dev, ip->addrs[NDIRECT + 1]);
    80002d94:	0009a503          	lw	a0,0(s3)
    80002d98:	fffff097          	auipc	ra,0xfffff
    80002d9c:	532080e7          	jalr	1330(ra) # 800022ca <bread>
    80002da0:	8c2a                	mv	s8,a0
        for (j = 0; j < NINDIRECT; j++) {
    80002da2:	05850a13          	addi	s4,a0,88
    80002da6:	45850b13          	addi	s6,a0,1112
    80002daa:	a82d                	j	80002de4 <itrunc+0x112>
                for (k = 0; k < NINDIRECT; k++) {
    80002dac:	0491                	addi	s1,s1,4
    80002dae:	00990b63          	beq	s2,s1,80002dc4 <itrunc+0xf2>
                    if (b[k])
    80002db2:	408c                	lw	a1,0(s1)
    80002db4:	dde5                	beqz	a1,80002dac <itrunc+0xda>
                        bfree(ip->dev, b[k]);
    80002db6:	0009a503          	lw	a0,0(s3)
    80002dba:	fffff097          	auipc	ra,0xfffff
    80002dbe:	756080e7          	jalr	1878(ra) # 80002510 <bfree>
    80002dc2:	b7ed                	j	80002dac <itrunc+0xda>
                brelse(bpL2);
    80002dc4:	855e                	mv	a0,s7
    80002dc6:	fffff097          	auipc	ra,0xfffff
    80002dca:	634080e7          	jalr	1588(ra) # 800023fa <brelse>
                bfree(ip->dev, a[j]);
    80002dce:	000aa583          	lw	a1,0(s5)
    80002dd2:	0009a503          	lw	a0,0(s3)
    80002dd6:	fffff097          	auipc	ra,0xfffff
    80002dda:	73a080e7          	jalr	1850(ra) # 80002510 <bfree>
        for (j = 0; j < NINDIRECT; j++) {
    80002dde:	0a11                	addi	s4,s4,4
    80002de0:	034b0263          	beq	s6,s4,80002e04 <itrunc+0x132>
            if (a[j]) {
    80002de4:	8ad2                	mv	s5,s4
    80002de6:	000a2583          	lw	a1,0(s4)
    80002dea:	d9f5                	beqz	a1,80002dde <itrunc+0x10c>
                bpL2 = bread(ip->dev, a[j]);
    80002dec:	0009a503          	lw	a0,0(s3)
    80002df0:	fffff097          	auipc	ra,0xfffff
    80002df4:	4da080e7          	jalr	1242(ra) # 800022ca <bread>
    80002df8:	8baa                	mv	s7,a0
                for (k = 0; k < NINDIRECT; k++) {
    80002dfa:	05850493          	addi	s1,a0,88
    80002dfe:	45850913          	addi	s2,a0,1112
    80002e02:	bf45                	j	80002db2 <itrunc+0xe0>
        brelse(bp);
    80002e04:	8562                	mv	a0,s8
    80002e06:	fffff097          	auipc	ra,0xfffff
    80002e0a:	5f4080e7          	jalr	1524(ra) # 800023fa <brelse>
        bfree(ip->dev, ip->addrs[NDIRECT + 1]);
    80002e0e:	0809a583          	lw	a1,128(s3)
    80002e12:	0009a503          	lw	a0,0(s3)
    80002e16:	fffff097          	auipc	ra,0xfffff
    80002e1a:	6fa080e7          	jalr	1786(ra) # 80002510 <bfree>
        ip->addrs[NDIRECT + 1] = 0;
    80002e1e:	0809a023          	sw	zero,128(s3)
    80002e22:	bdf5                	j	80002d1e <itrunc+0x4c>

0000000080002e24 <iput>:
{
    80002e24:	1101                	addi	sp,sp,-32
    80002e26:	ec06                	sd	ra,24(sp)
    80002e28:	e822                	sd	s0,16(sp)
    80002e2a:	e426                	sd	s1,8(sp)
    80002e2c:	e04a                	sd	s2,0(sp)
    80002e2e:	1000                	addi	s0,sp,32
    80002e30:	84aa                	mv	s1,a0
    acquire(&itable.lock);
    80002e32:	0000f517          	auipc	a0,0xf
    80002e36:	41650513          	addi	a0,a0,1046 # 80012248 <itable>
    80002e3a:	00003097          	auipc	ra,0x3
    80002e3e:	56a080e7          	jalr	1386(ra) # 800063a4 <acquire>
    if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80002e42:	4498                	lw	a4,8(s1)
    80002e44:	4785                	li	a5,1
    80002e46:	02f70363          	beq	a4,a5,80002e6c <iput+0x48>
    ip->ref--;
    80002e4a:	449c                	lw	a5,8(s1)
    80002e4c:	37fd                	addiw	a5,a5,-1
    80002e4e:	c49c                	sw	a5,8(s1)
    release(&itable.lock);
    80002e50:	0000f517          	auipc	a0,0xf
    80002e54:	3f850513          	addi	a0,a0,1016 # 80012248 <itable>
    80002e58:	00003097          	auipc	ra,0x3
    80002e5c:	600080e7          	jalr	1536(ra) # 80006458 <release>
}
    80002e60:	60e2                	ld	ra,24(sp)
    80002e62:	6442                	ld	s0,16(sp)
    80002e64:	64a2                	ld	s1,8(sp)
    80002e66:	6902                	ld	s2,0(sp)
    80002e68:	6105                	addi	sp,sp,32
    80002e6a:	8082                	ret
    if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80002e6c:	40bc                	lw	a5,64(s1)
    80002e6e:	dff1                	beqz	a5,80002e4a <iput+0x26>
    80002e70:	04a49783          	lh	a5,74(s1)
    80002e74:	fbf9                	bnez	a5,80002e4a <iput+0x26>
        acquiresleep(&ip->lock);
    80002e76:	01048913          	addi	s2,s1,16
    80002e7a:	854a                	mv	a0,s2
    80002e7c:	00001097          	auipc	ra,0x1
    80002e80:	ab0080e7          	jalr	-1360(ra) # 8000392c <acquiresleep>
        release(&itable.lock);
    80002e84:	0000f517          	auipc	a0,0xf
    80002e88:	3c450513          	addi	a0,a0,964 # 80012248 <itable>
    80002e8c:	00003097          	auipc	ra,0x3
    80002e90:	5cc080e7          	jalr	1484(ra) # 80006458 <release>
        itrunc(ip);
    80002e94:	8526                	mv	a0,s1
    80002e96:	00000097          	auipc	ra,0x0
    80002e9a:	e3c080e7          	jalr	-452(ra) # 80002cd2 <itrunc>
        ip->type = 0;
    80002e9e:	04049223          	sh	zero,68(s1)
        iupdate(ip);
    80002ea2:	8526                	mv	a0,s1
    80002ea4:	00000097          	auipc	ra,0x0
    80002ea8:	c54080e7          	jalr	-940(ra) # 80002af8 <iupdate>
        ip->valid = 0;
    80002eac:	0404a023          	sw	zero,64(s1)
        releasesleep(&ip->lock);
    80002eb0:	854a                	mv	a0,s2
    80002eb2:	00001097          	auipc	ra,0x1
    80002eb6:	ad0080e7          	jalr	-1328(ra) # 80003982 <releasesleep>
        acquire(&itable.lock);
    80002eba:	0000f517          	auipc	a0,0xf
    80002ebe:	38e50513          	addi	a0,a0,910 # 80012248 <itable>
    80002ec2:	00003097          	auipc	ra,0x3
    80002ec6:	4e2080e7          	jalr	1250(ra) # 800063a4 <acquire>
    80002eca:	b741                	j	80002e4a <iput+0x26>

0000000080002ecc <iunlockput>:
{
    80002ecc:	1101                	addi	sp,sp,-32
    80002ece:	ec06                	sd	ra,24(sp)
    80002ed0:	e822                	sd	s0,16(sp)
    80002ed2:	e426                	sd	s1,8(sp)
    80002ed4:	1000                	addi	s0,sp,32
    80002ed6:	84aa                	mv	s1,a0
    iunlock(ip);
    80002ed8:	00000097          	auipc	ra,0x0
    80002edc:	dae080e7          	jalr	-594(ra) # 80002c86 <iunlock>
    iput(ip);
    80002ee0:	8526                	mv	a0,s1
    80002ee2:	00000097          	auipc	ra,0x0
    80002ee6:	f42080e7          	jalr	-190(ra) # 80002e24 <iput>
}
    80002eea:	60e2                	ld	ra,24(sp)
    80002eec:	6442                	ld	s0,16(sp)
    80002eee:	64a2                	ld	s1,8(sp)
    80002ef0:	6105                	addi	sp,sp,32
    80002ef2:	8082                	ret

0000000080002ef4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st)
{
    80002ef4:	1141                	addi	sp,sp,-16
    80002ef6:	e422                	sd	s0,8(sp)
    80002ef8:	0800                	addi	s0,sp,16
    st->dev = ip->dev;
    80002efa:	411c                	lw	a5,0(a0)
    80002efc:	c19c                	sw	a5,0(a1)
    st->ino = ip->inum;
    80002efe:	415c                	lw	a5,4(a0)
    80002f00:	c1dc                	sw	a5,4(a1)
    st->type = ip->type;
    80002f02:	04451783          	lh	a5,68(a0)
    80002f06:	00f59423          	sh	a5,8(a1)
    st->nlink = ip->nlink;
    80002f0a:	04a51783          	lh	a5,74(a0)
    80002f0e:	00f59523          	sh	a5,10(a1)
    st->size = ip->size;
    80002f12:	04c56783          	lwu	a5,76(a0)
    80002f16:	e99c                	sd	a5,16(a1)
}
    80002f18:	6422                	ld	s0,8(sp)
    80002f1a:	0141                	addi	sp,sp,16
    80002f1c:	8082                	ret

0000000080002f1e <readi>:
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
    uint tot, m;
    struct buf *bp;

    if (off > ip->size || off + n < off)
    80002f1e:	457c                	lw	a5,76(a0)
    80002f20:	0ed7e963          	bltu	a5,a3,80003012 <readi+0xf4>
{
    80002f24:	7159                	addi	sp,sp,-112
    80002f26:	f486                	sd	ra,104(sp)
    80002f28:	f0a2                	sd	s0,96(sp)
    80002f2a:	eca6                	sd	s1,88(sp)
    80002f2c:	e8ca                	sd	s2,80(sp)
    80002f2e:	e4ce                	sd	s3,72(sp)
    80002f30:	e0d2                	sd	s4,64(sp)
    80002f32:	fc56                	sd	s5,56(sp)
    80002f34:	f85a                	sd	s6,48(sp)
    80002f36:	f45e                	sd	s7,40(sp)
    80002f38:	f062                	sd	s8,32(sp)
    80002f3a:	ec66                	sd	s9,24(sp)
    80002f3c:	e86a                	sd	s10,16(sp)
    80002f3e:	e46e                	sd	s11,8(sp)
    80002f40:	1880                	addi	s0,sp,112
    80002f42:	8b2a                	mv	s6,a0
    80002f44:	8bae                	mv	s7,a1
    80002f46:	8a32                	mv	s4,a2
    80002f48:	84b6                	mv	s1,a3
    80002f4a:	8aba                	mv	s5,a4
    if (off > ip->size || off + n < off)
    80002f4c:	9f35                	addw	a4,a4,a3
        return 0;
    80002f4e:	4501                	li	a0,0
    if (off > ip->size || off + n < off)
    80002f50:	0ad76063          	bltu	a4,a3,80002ff0 <readi+0xd2>
    if (off + n > ip->size)
    80002f54:	00e7f463          	bgeu	a5,a4,80002f5c <readi+0x3e>
        n = ip->size - off;
    80002f58:	40d78abb          	subw	s5,a5,a3

    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80002f5c:	0a0a8963          	beqz	s5,8000300e <readi+0xf0>
    80002f60:	4981                	li	s3,0
        uint addr = bmap(ip, off / BSIZE);
        if (addr == 0)
            break;
        bp = bread(ip->dev, addr);
        m = min(n - tot, BSIZE - off % BSIZE);
    80002f62:	40000c93          	li	s9,1024
        if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f66:	5c7d                	li	s8,-1
    80002f68:	a82d                	j	80002fa2 <readi+0x84>
    80002f6a:	020d1d93          	slli	s11,s10,0x20
    80002f6e:	020ddd93          	srli	s11,s11,0x20
    80002f72:	05890613          	addi	a2,s2,88
    80002f76:	86ee                	mv	a3,s11
    80002f78:	963a                	add	a2,a2,a4
    80002f7a:	85d2                	mv	a1,s4
    80002f7c:	855e                	mv	a0,s7
    80002f7e:	fffff097          	auipc	ra,0xfffff
    80002f82:	986080e7          	jalr	-1658(ra) # 80001904 <either_copyout>
    80002f86:	05850d63          	beq	a0,s8,80002fe0 <readi+0xc2>
            brelse(bp);
            tot = -1;
            break;
        }
        brelse(bp);
    80002f8a:	854a                	mv	a0,s2
    80002f8c:	fffff097          	auipc	ra,0xfffff
    80002f90:	46e080e7          	jalr	1134(ra) # 800023fa <brelse>
    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80002f94:	013d09bb          	addw	s3,s10,s3
    80002f98:	009d04bb          	addw	s1,s10,s1
    80002f9c:	9a6e                	add	s4,s4,s11
    80002f9e:	0559f763          	bgeu	s3,s5,80002fec <readi+0xce>
        uint addr = bmap(ip, off / BSIZE);
    80002fa2:	00a4d59b          	srliw	a1,s1,0xa
    80002fa6:	855a                	mv	a0,s6
    80002fa8:	fffff097          	auipc	ra,0xfffff
    80002fac:	716080e7          	jalr	1814(ra) # 800026be <bmap>
    80002fb0:	0005059b          	sext.w	a1,a0
        if (addr == 0)
    80002fb4:	cd85                	beqz	a1,80002fec <readi+0xce>
        bp = bread(ip->dev, addr);
    80002fb6:	000b2503          	lw	a0,0(s6)
    80002fba:	fffff097          	auipc	ra,0xfffff
    80002fbe:	310080e7          	jalr	784(ra) # 800022ca <bread>
    80002fc2:	892a                	mv	s2,a0
        m = min(n - tot, BSIZE - off % BSIZE);
    80002fc4:	3ff4f713          	andi	a4,s1,1023
    80002fc8:	40ec87bb          	subw	a5,s9,a4
    80002fcc:	413a86bb          	subw	a3,s5,s3
    80002fd0:	8d3e                	mv	s10,a5
    80002fd2:	2781                	sext.w	a5,a5
    80002fd4:	0006861b          	sext.w	a2,a3
    80002fd8:	f8f679e3          	bgeu	a2,a5,80002f6a <readi+0x4c>
    80002fdc:	8d36                	mv	s10,a3
    80002fde:	b771                	j	80002f6a <readi+0x4c>
            brelse(bp);
    80002fe0:	854a                	mv	a0,s2
    80002fe2:	fffff097          	auipc	ra,0xfffff
    80002fe6:	418080e7          	jalr	1048(ra) # 800023fa <brelse>
            tot = -1;
    80002fea:	59fd                	li	s3,-1
    }
    return tot;
    80002fec:	0009851b          	sext.w	a0,s3
}
    80002ff0:	70a6                	ld	ra,104(sp)
    80002ff2:	7406                	ld	s0,96(sp)
    80002ff4:	64e6                	ld	s1,88(sp)
    80002ff6:	6946                	ld	s2,80(sp)
    80002ff8:	69a6                	ld	s3,72(sp)
    80002ffa:	6a06                	ld	s4,64(sp)
    80002ffc:	7ae2                	ld	s5,56(sp)
    80002ffe:	7b42                	ld	s6,48(sp)
    80003000:	7ba2                	ld	s7,40(sp)
    80003002:	7c02                	ld	s8,32(sp)
    80003004:	6ce2                	ld	s9,24(sp)
    80003006:	6d42                	ld	s10,16(sp)
    80003008:	6da2                	ld	s11,8(sp)
    8000300a:	6165                	addi	sp,sp,112
    8000300c:	8082                	ret
    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    8000300e:	89d6                	mv	s3,s5
    80003010:	bff1                	j	80002fec <readi+0xce>
        return 0;
    80003012:	4501                	li	a0,0
}
    80003014:	8082                	ret

0000000080003016 <writei>:
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
    uint tot, m;
    struct buf *bp;

    if (off > ip->size || off + n < off)
    80003016:	457c                	lw	a5,76(a0)
    80003018:	10d7e963          	bltu	a5,a3,8000312a <writei+0x114>
{
    8000301c:	7159                	addi	sp,sp,-112
    8000301e:	f486                	sd	ra,104(sp)
    80003020:	f0a2                	sd	s0,96(sp)
    80003022:	eca6                	sd	s1,88(sp)
    80003024:	e8ca                	sd	s2,80(sp)
    80003026:	e4ce                	sd	s3,72(sp)
    80003028:	e0d2                	sd	s4,64(sp)
    8000302a:	fc56                	sd	s5,56(sp)
    8000302c:	f85a                	sd	s6,48(sp)
    8000302e:	f45e                	sd	s7,40(sp)
    80003030:	f062                	sd	s8,32(sp)
    80003032:	ec66                	sd	s9,24(sp)
    80003034:	e86a                	sd	s10,16(sp)
    80003036:	e46e                	sd	s11,8(sp)
    80003038:	1880                	addi	s0,sp,112
    8000303a:	8aaa                	mv	s5,a0
    8000303c:	8bae                	mv	s7,a1
    8000303e:	8a32                	mv	s4,a2
    80003040:	8936                	mv	s2,a3
    80003042:	8b3a                	mv	s6,a4
    if (off > ip->size || off + n < off)
    80003044:	9f35                	addw	a4,a4,a3
    80003046:	0ed76463          	bltu	a4,a3,8000312e <writei+0x118>
        return -1;
    if (off + n > MAXFILE * BSIZE)
    8000304a:	040437b7          	lui	a5,0x4043
    8000304e:	c0078793          	addi	a5,a5,-1024 # 4042c00 <_entry-0x7bfbd400>
    80003052:	0ee7e063          	bltu	a5,a4,80003132 <writei+0x11c>
        return -1;

    for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003056:	0c0b0863          	beqz	s6,80003126 <writei+0x110>
    8000305a:	4981                	li	s3,0
        uint addr = bmap(ip, off / BSIZE);
        if (addr == 0)
            break;
        bp = bread(ip->dev, addr);
        m = min(n - tot, BSIZE - off % BSIZE);
    8000305c:	40000c93          	li	s9,1024
        if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003060:	5c7d                	li	s8,-1
    80003062:	a091                	j	800030a6 <writei+0x90>
    80003064:	020d1d93          	slli	s11,s10,0x20
    80003068:	020ddd93          	srli	s11,s11,0x20
    8000306c:	05848513          	addi	a0,s1,88
    80003070:	86ee                	mv	a3,s11
    80003072:	8652                	mv	a2,s4
    80003074:	85de                	mv	a1,s7
    80003076:	953a                	add	a0,a0,a4
    80003078:	fffff097          	auipc	ra,0xfffff
    8000307c:	8e2080e7          	jalr	-1822(ra) # 8000195a <either_copyin>
    80003080:	07850263          	beq	a0,s8,800030e4 <writei+0xce>
            brelse(bp);
            break;
        }
        log_write(bp);
    80003084:	8526                	mv	a0,s1
    80003086:	00000097          	auipc	ra,0x0
    8000308a:	788080e7          	jalr	1928(ra) # 8000380e <log_write>
        brelse(bp);
    8000308e:	8526                	mv	a0,s1
    80003090:	fffff097          	auipc	ra,0xfffff
    80003094:	36a080e7          	jalr	874(ra) # 800023fa <brelse>
    for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003098:	013d09bb          	addw	s3,s10,s3
    8000309c:	012d093b          	addw	s2,s10,s2
    800030a0:	9a6e                	add	s4,s4,s11
    800030a2:	0569f663          	bgeu	s3,s6,800030ee <writei+0xd8>
        uint addr = bmap(ip, off / BSIZE);
    800030a6:	00a9559b          	srliw	a1,s2,0xa
    800030aa:	8556                	mv	a0,s5
    800030ac:	fffff097          	auipc	ra,0xfffff
    800030b0:	612080e7          	jalr	1554(ra) # 800026be <bmap>
    800030b4:	0005059b          	sext.w	a1,a0
        if (addr == 0)
    800030b8:	c99d                	beqz	a1,800030ee <writei+0xd8>
        bp = bread(ip->dev, addr);
    800030ba:	000aa503          	lw	a0,0(s5)
    800030be:	fffff097          	auipc	ra,0xfffff
    800030c2:	20c080e7          	jalr	524(ra) # 800022ca <bread>
    800030c6:	84aa                	mv	s1,a0
        m = min(n - tot, BSIZE - off % BSIZE);
    800030c8:	3ff97713          	andi	a4,s2,1023
    800030cc:	40ec87bb          	subw	a5,s9,a4
    800030d0:	413b06bb          	subw	a3,s6,s3
    800030d4:	8d3e                	mv	s10,a5
    800030d6:	2781                	sext.w	a5,a5
    800030d8:	0006861b          	sext.w	a2,a3
    800030dc:	f8f674e3          	bgeu	a2,a5,80003064 <writei+0x4e>
    800030e0:	8d36                	mv	s10,a3
    800030e2:	b749                	j	80003064 <writei+0x4e>
            brelse(bp);
    800030e4:	8526                	mv	a0,s1
    800030e6:	fffff097          	auipc	ra,0xfffff
    800030ea:	314080e7          	jalr	788(ra) # 800023fa <brelse>
    }

    if (off > ip->size)
    800030ee:	04caa783          	lw	a5,76(s5)
    800030f2:	0127f463          	bgeu	a5,s2,800030fa <writei+0xe4>
        ip->size = off;
    800030f6:	052aa623          	sw	s2,76(s5)

    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    800030fa:	8556                	mv	a0,s5
    800030fc:	00000097          	auipc	ra,0x0
    80003100:	9fc080e7          	jalr	-1540(ra) # 80002af8 <iupdate>

    return tot;
    80003104:	0009851b          	sext.w	a0,s3
}
    80003108:	70a6                	ld	ra,104(sp)
    8000310a:	7406                	ld	s0,96(sp)
    8000310c:	64e6                	ld	s1,88(sp)
    8000310e:	6946                	ld	s2,80(sp)
    80003110:	69a6                	ld	s3,72(sp)
    80003112:	6a06                	ld	s4,64(sp)
    80003114:	7ae2                	ld	s5,56(sp)
    80003116:	7b42                	ld	s6,48(sp)
    80003118:	7ba2                	ld	s7,40(sp)
    8000311a:	7c02                	ld	s8,32(sp)
    8000311c:	6ce2                	ld	s9,24(sp)
    8000311e:	6d42                	ld	s10,16(sp)
    80003120:	6da2                	ld	s11,8(sp)
    80003122:	6165                	addi	sp,sp,112
    80003124:	8082                	ret
    for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003126:	89da                	mv	s3,s6
    80003128:	bfc9                	j	800030fa <writei+0xe4>
        return -1;
    8000312a:	557d                	li	a0,-1
}
    8000312c:	8082                	ret
        return -1;
    8000312e:	557d                	li	a0,-1
    80003130:	bfe1                	j	80003108 <writei+0xf2>
        return -1;
    80003132:	557d                	li	a0,-1
    80003134:	bfd1                	j	80003108 <writei+0xf2>

0000000080003136 <namecmp>:

// Directories

int namecmp(const char *s, const char *t)
{
    80003136:	1141                	addi	sp,sp,-16
    80003138:	e406                	sd	ra,8(sp)
    8000313a:	e022                	sd	s0,0(sp)
    8000313c:	0800                	addi	s0,sp,16
    return strncmp(s, t, DIRSIZ);
    8000313e:	4639                	li	a2,14
    80003140:	ffffd097          	auipc	ra,0xffffd
    80003144:	10a080e7          	jalr	266(ra) # 8000024a <strncmp>
}
    80003148:	60a2                	ld	ra,8(sp)
    8000314a:	6402                	ld	s0,0(sp)
    8000314c:	0141                	addi	sp,sp,16
    8000314e:	8082                	ret

0000000080003150 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003150:	7139                	addi	sp,sp,-64
    80003152:	fc06                	sd	ra,56(sp)
    80003154:	f822                	sd	s0,48(sp)
    80003156:	f426                	sd	s1,40(sp)
    80003158:	f04a                	sd	s2,32(sp)
    8000315a:	ec4e                	sd	s3,24(sp)
    8000315c:	e852                	sd	s4,16(sp)
    8000315e:	0080                	addi	s0,sp,64
    uint off, inum;
    struct dirent de;

    if (dp->type != T_DIR)
    80003160:	04451703          	lh	a4,68(a0)
    80003164:	4785                	li	a5,1
    80003166:	00f71a63          	bne	a4,a5,8000317a <dirlookup+0x2a>
    8000316a:	892a                	mv	s2,a0
    8000316c:	89ae                	mv	s3,a1
    8000316e:	8a32                	mv	s4,a2
        panic("dirlookup not DIR");

    for (off = 0; off < dp->size; off += sizeof(de)) {
    80003170:	457c                	lw	a5,76(a0)
    80003172:	4481                	li	s1,0
            inum = de.inum;
            return iget(dp->dev, inum);
        }
    }

    return 0;
    80003174:	4501                	li	a0,0
    for (off = 0; off < dp->size; off += sizeof(de)) {
    80003176:	e79d                	bnez	a5,800031a4 <dirlookup+0x54>
    80003178:	a8a5                	j	800031f0 <dirlookup+0xa0>
        panic("dirlookup not DIR");
    8000317a:	00005517          	auipc	a0,0x5
    8000317e:	3fe50513          	addi	a0,a0,1022 # 80008578 <syscalls+0x1a8>
    80003182:	00003097          	auipc	ra,0x3
    80003186:	cea080e7          	jalr	-790(ra) # 80005e6c <panic>
            panic("dirlookup read");
    8000318a:	00005517          	auipc	a0,0x5
    8000318e:	40650513          	addi	a0,a0,1030 # 80008590 <syscalls+0x1c0>
    80003192:	00003097          	auipc	ra,0x3
    80003196:	cda080e7          	jalr	-806(ra) # 80005e6c <panic>
    for (off = 0; off < dp->size; off += sizeof(de)) {
    8000319a:	24c1                	addiw	s1,s1,16
    8000319c:	04c92783          	lw	a5,76(s2)
    800031a0:	04f4f763          	bgeu	s1,a5,800031ee <dirlookup+0x9e>
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031a4:	4741                	li	a4,16
    800031a6:	86a6                	mv	a3,s1
    800031a8:	fc040613          	addi	a2,s0,-64
    800031ac:	4581                	li	a1,0
    800031ae:	854a                	mv	a0,s2
    800031b0:	00000097          	auipc	ra,0x0
    800031b4:	d6e080e7          	jalr	-658(ra) # 80002f1e <readi>
    800031b8:	47c1                	li	a5,16
    800031ba:	fcf518e3          	bne	a0,a5,8000318a <dirlookup+0x3a>
        if (de.inum == 0)
    800031be:	fc045783          	lhu	a5,-64(s0)
    800031c2:	dfe1                	beqz	a5,8000319a <dirlookup+0x4a>
        if (namecmp(name, de.name) == 0) {
    800031c4:	fc240593          	addi	a1,s0,-62
    800031c8:	854e                	mv	a0,s3
    800031ca:	00000097          	auipc	ra,0x0
    800031ce:	f6c080e7          	jalr	-148(ra) # 80003136 <namecmp>
    800031d2:	f561                	bnez	a0,8000319a <dirlookup+0x4a>
            if (poff)
    800031d4:	000a0463          	beqz	s4,800031dc <dirlookup+0x8c>
                *poff = off;
    800031d8:	009a2023          	sw	s1,0(s4)
            return iget(dp->dev, inum);
    800031dc:	fc045583          	lhu	a1,-64(s0)
    800031e0:	00092503          	lw	a0,0(s2)
    800031e4:	fffff097          	auipc	ra,0xfffff
    800031e8:	6a6080e7          	jalr	1702(ra) # 8000288a <iget>
    800031ec:	a011                	j	800031f0 <dirlookup+0xa0>
    return 0;
    800031ee:	4501                	li	a0,0
}
    800031f0:	70e2                	ld	ra,56(sp)
    800031f2:	7442                	ld	s0,48(sp)
    800031f4:	74a2                	ld	s1,40(sp)
    800031f6:	7902                	ld	s2,32(sp)
    800031f8:	69e2                	ld	s3,24(sp)
    800031fa:	6a42                	ld	s4,16(sp)
    800031fc:	6121                	addi	sp,sp,64
    800031fe:	8082                	ret

0000000080003200 <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *namex(char *path, int nameiparent, char *name)
{
    80003200:	711d                	addi	sp,sp,-96
    80003202:	ec86                	sd	ra,88(sp)
    80003204:	e8a2                	sd	s0,80(sp)
    80003206:	e4a6                	sd	s1,72(sp)
    80003208:	e0ca                	sd	s2,64(sp)
    8000320a:	fc4e                	sd	s3,56(sp)
    8000320c:	f852                	sd	s4,48(sp)
    8000320e:	f456                	sd	s5,40(sp)
    80003210:	f05a                	sd	s6,32(sp)
    80003212:	ec5e                	sd	s7,24(sp)
    80003214:	e862                	sd	s8,16(sp)
    80003216:	e466                	sd	s9,8(sp)
    80003218:	e06a                	sd	s10,0(sp)
    8000321a:	1080                	addi	s0,sp,96
    8000321c:	84aa                	mv	s1,a0
    8000321e:	8b2e                	mv	s6,a1
    80003220:	8ab2                	mv	s5,a2
    struct inode *ip, *next;

    if (*path == '/')
    80003222:	00054703          	lbu	a4,0(a0)
    80003226:	02f00793          	li	a5,47
    8000322a:	02f70363          	beq	a4,a5,80003250 <namex+0x50>
        ip = iget(ROOTDEV, ROOTINO);
    else
        ip = idup(myproc()->cwd);
    8000322e:	ffffe097          	auipc	ra,0xffffe
    80003232:	c26080e7          	jalr	-986(ra) # 80000e54 <myproc>
    80003236:	15053503          	ld	a0,336(a0)
    8000323a:	00000097          	auipc	ra,0x0
    8000323e:	94c080e7          	jalr	-1716(ra) # 80002b86 <idup>
    80003242:	8a2a                	mv	s4,a0
    while (*path == '/')
    80003244:	02f00913          	li	s2,47
    if (len >= DIRSIZ)
    80003248:	4cb5                	li	s9,13
    len = path - s;
    8000324a:	4b81                	li	s7,0

    while ((path = skipelem(path, name)) != 0) {
        ilock(ip);
        if (ip->type != T_DIR) {
    8000324c:	4c05                	li	s8,1
    8000324e:	a87d                	j	8000330c <namex+0x10c>
        ip = iget(ROOTDEV, ROOTINO);
    80003250:	4585                	li	a1,1
    80003252:	4505                	li	a0,1
    80003254:	fffff097          	auipc	ra,0xfffff
    80003258:	636080e7          	jalr	1590(ra) # 8000288a <iget>
    8000325c:	8a2a                	mv	s4,a0
    8000325e:	b7dd                	j	80003244 <namex+0x44>
            iunlockput(ip);
    80003260:	8552                	mv	a0,s4
    80003262:	00000097          	auipc	ra,0x0
    80003266:	c6a080e7          	jalr	-918(ra) # 80002ecc <iunlockput>
            return 0;
    8000326a:	4a01                	li	s4,0
    if (nameiparent) {
        iput(ip);
        return 0;
    }
    return ip;
}
    8000326c:	8552                	mv	a0,s4
    8000326e:	60e6                	ld	ra,88(sp)
    80003270:	6446                	ld	s0,80(sp)
    80003272:	64a6                	ld	s1,72(sp)
    80003274:	6906                	ld	s2,64(sp)
    80003276:	79e2                	ld	s3,56(sp)
    80003278:	7a42                	ld	s4,48(sp)
    8000327a:	7aa2                	ld	s5,40(sp)
    8000327c:	7b02                	ld	s6,32(sp)
    8000327e:	6be2                	ld	s7,24(sp)
    80003280:	6c42                	ld	s8,16(sp)
    80003282:	6ca2                	ld	s9,8(sp)
    80003284:	6d02                	ld	s10,0(sp)
    80003286:	6125                	addi	sp,sp,96
    80003288:	8082                	ret
            iunlock(ip);
    8000328a:	8552                	mv	a0,s4
    8000328c:	00000097          	auipc	ra,0x0
    80003290:	9fa080e7          	jalr	-1542(ra) # 80002c86 <iunlock>
            return ip;
    80003294:	bfe1                	j	8000326c <namex+0x6c>
            iunlockput(ip);
    80003296:	8552                	mv	a0,s4
    80003298:	00000097          	auipc	ra,0x0
    8000329c:	c34080e7          	jalr	-972(ra) # 80002ecc <iunlockput>
            return 0;
    800032a0:	8a4e                	mv	s4,s3
    800032a2:	b7e9                	j	8000326c <namex+0x6c>
    len = path - s;
    800032a4:	40998633          	sub	a2,s3,s1
    800032a8:	00060d1b          	sext.w	s10,a2
    if (len >= DIRSIZ)
    800032ac:	09acd863          	bge	s9,s10,8000333c <namex+0x13c>
        memmove(name, s, DIRSIZ);
    800032b0:	4639                	li	a2,14
    800032b2:	85a6                	mv	a1,s1
    800032b4:	8556                	mv	a0,s5
    800032b6:	ffffd097          	auipc	ra,0xffffd
    800032ba:	f20080e7          	jalr	-224(ra) # 800001d6 <memmove>
    800032be:	84ce                	mv	s1,s3
    while (*path == '/')
    800032c0:	0004c783          	lbu	a5,0(s1)
    800032c4:	01279763          	bne	a5,s2,800032d2 <namex+0xd2>
        path++;
    800032c8:	0485                	addi	s1,s1,1
    while (*path == '/')
    800032ca:	0004c783          	lbu	a5,0(s1)
    800032ce:	ff278de3          	beq	a5,s2,800032c8 <namex+0xc8>
        ilock(ip);
    800032d2:	8552                	mv	a0,s4
    800032d4:	00000097          	auipc	ra,0x0
    800032d8:	8f0080e7          	jalr	-1808(ra) # 80002bc4 <ilock>
        if (ip->type != T_DIR) {
    800032dc:	044a1783          	lh	a5,68(s4)
    800032e0:	f98790e3          	bne	a5,s8,80003260 <namex+0x60>
        if (nameiparent && *path == '\0') {
    800032e4:	000b0563          	beqz	s6,800032ee <namex+0xee>
    800032e8:	0004c783          	lbu	a5,0(s1)
    800032ec:	dfd9                	beqz	a5,8000328a <namex+0x8a>
        if ((next = dirlookup(ip, name, 0)) == 0) {
    800032ee:	865e                	mv	a2,s7
    800032f0:	85d6                	mv	a1,s5
    800032f2:	8552                	mv	a0,s4
    800032f4:	00000097          	auipc	ra,0x0
    800032f8:	e5c080e7          	jalr	-420(ra) # 80003150 <dirlookup>
    800032fc:	89aa                	mv	s3,a0
    800032fe:	dd41                	beqz	a0,80003296 <namex+0x96>
        iunlockput(ip);
    80003300:	8552                	mv	a0,s4
    80003302:	00000097          	auipc	ra,0x0
    80003306:	bca080e7          	jalr	-1078(ra) # 80002ecc <iunlockput>
        ip = next;
    8000330a:	8a4e                	mv	s4,s3
    while (*path == '/')
    8000330c:	0004c783          	lbu	a5,0(s1)
    80003310:	01279763          	bne	a5,s2,8000331e <namex+0x11e>
        path++;
    80003314:	0485                	addi	s1,s1,1
    while (*path == '/')
    80003316:	0004c783          	lbu	a5,0(s1)
    8000331a:	ff278de3          	beq	a5,s2,80003314 <namex+0x114>
    if (*path == 0)
    8000331e:	cb9d                	beqz	a5,80003354 <namex+0x154>
    while (*path != '/' && *path != 0)
    80003320:	0004c783          	lbu	a5,0(s1)
    80003324:	89a6                	mv	s3,s1
    len = path - s;
    80003326:	8d5e                	mv	s10,s7
    80003328:	865e                	mv	a2,s7
    while (*path != '/' && *path != 0)
    8000332a:	01278963          	beq	a5,s2,8000333c <namex+0x13c>
    8000332e:	dbbd                	beqz	a5,800032a4 <namex+0xa4>
        path++;
    80003330:	0985                	addi	s3,s3,1
    while (*path != '/' && *path != 0)
    80003332:	0009c783          	lbu	a5,0(s3)
    80003336:	ff279ce3          	bne	a5,s2,8000332e <namex+0x12e>
    8000333a:	b7ad                	j	800032a4 <namex+0xa4>
        memmove(name, s, len);
    8000333c:	2601                	sext.w	a2,a2
    8000333e:	85a6                	mv	a1,s1
    80003340:	8556                	mv	a0,s5
    80003342:	ffffd097          	auipc	ra,0xffffd
    80003346:	e94080e7          	jalr	-364(ra) # 800001d6 <memmove>
        name[len] = 0;
    8000334a:	9d56                	add	s10,s10,s5
    8000334c:	000d0023          	sb	zero,0(s10)
    80003350:	84ce                	mv	s1,s3
    80003352:	b7bd                	j	800032c0 <namex+0xc0>
    if (nameiparent) {
    80003354:	f00b0ce3          	beqz	s6,8000326c <namex+0x6c>
        iput(ip);
    80003358:	8552                	mv	a0,s4
    8000335a:	00000097          	auipc	ra,0x0
    8000335e:	aca080e7          	jalr	-1334(ra) # 80002e24 <iput>
        return 0;
    80003362:	4a01                	li	s4,0
    80003364:	b721                	j	8000326c <namex+0x6c>

0000000080003366 <dirlink>:
{
    80003366:	7139                	addi	sp,sp,-64
    80003368:	fc06                	sd	ra,56(sp)
    8000336a:	f822                	sd	s0,48(sp)
    8000336c:	f426                	sd	s1,40(sp)
    8000336e:	f04a                	sd	s2,32(sp)
    80003370:	ec4e                	sd	s3,24(sp)
    80003372:	e852                	sd	s4,16(sp)
    80003374:	0080                	addi	s0,sp,64
    80003376:	892a                	mv	s2,a0
    80003378:	8a2e                	mv	s4,a1
    8000337a:	89b2                	mv	s3,a2
    if ((ip = dirlookup(dp, name, 0)) != 0) {
    8000337c:	4601                	li	a2,0
    8000337e:	00000097          	auipc	ra,0x0
    80003382:	dd2080e7          	jalr	-558(ra) # 80003150 <dirlookup>
    80003386:	e93d                	bnez	a0,800033fc <dirlink+0x96>
    for (off = 0; off < dp->size; off += sizeof(de)) {
    80003388:	04c92483          	lw	s1,76(s2)
    8000338c:	c49d                	beqz	s1,800033ba <dirlink+0x54>
    8000338e:	4481                	li	s1,0
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003390:	4741                	li	a4,16
    80003392:	86a6                	mv	a3,s1
    80003394:	fc040613          	addi	a2,s0,-64
    80003398:	4581                	li	a1,0
    8000339a:	854a                	mv	a0,s2
    8000339c:	00000097          	auipc	ra,0x0
    800033a0:	b82080e7          	jalr	-1150(ra) # 80002f1e <readi>
    800033a4:	47c1                	li	a5,16
    800033a6:	06f51163          	bne	a0,a5,80003408 <dirlink+0xa2>
        if (de.inum == 0)
    800033aa:	fc045783          	lhu	a5,-64(s0)
    800033ae:	c791                	beqz	a5,800033ba <dirlink+0x54>
    for (off = 0; off < dp->size; off += sizeof(de)) {
    800033b0:	24c1                	addiw	s1,s1,16
    800033b2:	04c92783          	lw	a5,76(s2)
    800033b6:	fcf4ede3          	bltu	s1,a5,80003390 <dirlink+0x2a>
    strncpy(de.name, name, DIRSIZ);
    800033ba:	4639                	li	a2,14
    800033bc:	85d2                	mv	a1,s4
    800033be:	fc240513          	addi	a0,s0,-62
    800033c2:	ffffd097          	auipc	ra,0xffffd
    800033c6:	ec4080e7          	jalr	-316(ra) # 80000286 <strncpy>
    de.inum = inum;
    800033ca:	fd341023          	sh	s3,-64(s0)
    if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033ce:	4741                	li	a4,16
    800033d0:	86a6                	mv	a3,s1
    800033d2:	fc040613          	addi	a2,s0,-64
    800033d6:	4581                	li	a1,0
    800033d8:	854a                	mv	a0,s2
    800033da:	00000097          	auipc	ra,0x0
    800033de:	c3c080e7          	jalr	-964(ra) # 80003016 <writei>
    800033e2:	1541                	addi	a0,a0,-16
    800033e4:	00a03533          	snez	a0,a0
    800033e8:	40a00533          	neg	a0,a0
}
    800033ec:	70e2                	ld	ra,56(sp)
    800033ee:	7442                	ld	s0,48(sp)
    800033f0:	74a2                	ld	s1,40(sp)
    800033f2:	7902                	ld	s2,32(sp)
    800033f4:	69e2                	ld	s3,24(sp)
    800033f6:	6a42                	ld	s4,16(sp)
    800033f8:	6121                	addi	sp,sp,64
    800033fa:	8082                	ret
        iput(ip);
    800033fc:	00000097          	auipc	ra,0x0
    80003400:	a28080e7          	jalr	-1496(ra) # 80002e24 <iput>
        return -1;
    80003404:	557d                	li	a0,-1
    80003406:	b7dd                	j	800033ec <dirlink+0x86>
            panic("dirlink read");
    80003408:	00005517          	auipc	a0,0x5
    8000340c:	19850513          	addi	a0,a0,408 # 800085a0 <syscalls+0x1d0>
    80003410:	00003097          	auipc	ra,0x3
    80003414:	a5c080e7          	jalr	-1444(ra) # 80005e6c <panic>

0000000080003418 <namei>:

struct inode *namei(char *path)
{
    80003418:	1101                	addi	sp,sp,-32
    8000341a:	ec06                	sd	ra,24(sp)
    8000341c:	e822                	sd	s0,16(sp)
    8000341e:	1000                	addi	s0,sp,32
    char name[DIRSIZ];
    return namex(path, 0, name);
    80003420:	fe040613          	addi	a2,s0,-32
    80003424:	4581                	li	a1,0
    80003426:	00000097          	auipc	ra,0x0
    8000342a:	dda080e7          	jalr	-550(ra) # 80003200 <namex>
}
    8000342e:	60e2                	ld	ra,24(sp)
    80003430:	6442                	ld	s0,16(sp)
    80003432:	6105                	addi	sp,sp,32
    80003434:	8082                	ret

0000000080003436 <nameiparent>:

struct inode *nameiparent(char *path, char *name)
{
    80003436:	1141                	addi	sp,sp,-16
    80003438:	e406                	sd	ra,8(sp)
    8000343a:	e022                	sd	s0,0(sp)
    8000343c:	0800                	addi	s0,sp,16
    8000343e:	862e                	mv	a2,a1
    return namex(path, 1, name);
    80003440:	4585                	li	a1,1
    80003442:	00000097          	auipc	ra,0x0
    80003446:	dbe080e7          	jalr	-578(ra) # 80003200 <namex>
}
    8000344a:	60a2                	ld	ra,8(sp)
    8000344c:	6402                	ld	s0,0(sp)
    8000344e:	0141                	addi	sp,sp,16
    80003450:	8082                	ret

0000000080003452 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003452:	1101                	addi	sp,sp,-32
    80003454:	ec06                	sd	ra,24(sp)
    80003456:	e822                	sd	s0,16(sp)
    80003458:	e426                	sd	s1,8(sp)
    8000345a:	e04a                	sd	s2,0(sp)
    8000345c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000345e:	00011917          	auipc	s2,0x11
    80003462:	89290913          	addi	s2,s2,-1902 # 80013cf0 <log>
    80003466:	01892583          	lw	a1,24(s2)
    8000346a:	02892503          	lw	a0,40(s2)
    8000346e:	fffff097          	auipc	ra,0xfffff
    80003472:	e5c080e7          	jalr	-420(ra) # 800022ca <bread>
    80003476:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003478:	02c92683          	lw	a3,44(s2)
    8000347c:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000347e:	02d05863          	blez	a3,800034ae <write_head+0x5c>
    80003482:	00011797          	auipc	a5,0x11
    80003486:	89e78793          	addi	a5,a5,-1890 # 80013d20 <log+0x30>
    8000348a:	05c50713          	addi	a4,a0,92
    8000348e:	36fd                	addiw	a3,a3,-1
    80003490:	02069613          	slli	a2,a3,0x20
    80003494:	01e65693          	srli	a3,a2,0x1e
    80003498:	00011617          	auipc	a2,0x11
    8000349c:	88c60613          	addi	a2,a2,-1908 # 80013d24 <log+0x34>
    800034a0:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800034a2:	4390                	lw	a2,0(a5)
    800034a4:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034a6:	0791                	addi	a5,a5,4
    800034a8:	0711                	addi	a4,a4,4
    800034aa:	fed79ce3          	bne	a5,a3,800034a2 <write_head+0x50>
  }
  bwrite(buf);
    800034ae:	8526                	mv	a0,s1
    800034b0:	fffff097          	auipc	ra,0xfffff
    800034b4:	f0c080e7          	jalr	-244(ra) # 800023bc <bwrite>
  brelse(buf);
    800034b8:	8526                	mv	a0,s1
    800034ba:	fffff097          	auipc	ra,0xfffff
    800034be:	f40080e7          	jalr	-192(ra) # 800023fa <brelse>
}
    800034c2:	60e2                	ld	ra,24(sp)
    800034c4:	6442                	ld	s0,16(sp)
    800034c6:	64a2                	ld	s1,8(sp)
    800034c8:	6902                	ld	s2,0(sp)
    800034ca:	6105                	addi	sp,sp,32
    800034cc:	8082                	ret

00000000800034ce <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800034ce:	00011797          	auipc	a5,0x11
    800034d2:	84e7a783          	lw	a5,-1970(a5) # 80013d1c <log+0x2c>
    800034d6:	0af05d63          	blez	a5,80003590 <install_trans+0xc2>
{
    800034da:	7139                	addi	sp,sp,-64
    800034dc:	fc06                	sd	ra,56(sp)
    800034de:	f822                	sd	s0,48(sp)
    800034e0:	f426                	sd	s1,40(sp)
    800034e2:	f04a                	sd	s2,32(sp)
    800034e4:	ec4e                	sd	s3,24(sp)
    800034e6:	e852                	sd	s4,16(sp)
    800034e8:	e456                	sd	s5,8(sp)
    800034ea:	e05a                	sd	s6,0(sp)
    800034ec:	0080                	addi	s0,sp,64
    800034ee:	8b2a                	mv	s6,a0
    800034f0:	00011a97          	auipc	s5,0x11
    800034f4:	830a8a93          	addi	s5,s5,-2000 # 80013d20 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034f8:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034fa:	00010997          	auipc	s3,0x10
    800034fe:	7f698993          	addi	s3,s3,2038 # 80013cf0 <log>
    80003502:	a00d                	j	80003524 <install_trans+0x56>
    brelse(lbuf);
    80003504:	854a                	mv	a0,s2
    80003506:	fffff097          	auipc	ra,0xfffff
    8000350a:	ef4080e7          	jalr	-268(ra) # 800023fa <brelse>
    brelse(dbuf);
    8000350e:	8526                	mv	a0,s1
    80003510:	fffff097          	auipc	ra,0xfffff
    80003514:	eea080e7          	jalr	-278(ra) # 800023fa <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003518:	2a05                	addiw	s4,s4,1
    8000351a:	0a91                	addi	s5,s5,4
    8000351c:	02c9a783          	lw	a5,44(s3)
    80003520:	04fa5e63          	bge	s4,a5,8000357c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003524:	0189a583          	lw	a1,24(s3)
    80003528:	014585bb          	addw	a1,a1,s4
    8000352c:	2585                	addiw	a1,a1,1
    8000352e:	0289a503          	lw	a0,40(s3)
    80003532:	fffff097          	auipc	ra,0xfffff
    80003536:	d98080e7          	jalr	-616(ra) # 800022ca <bread>
    8000353a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000353c:	000aa583          	lw	a1,0(s5)
    80003540:	0289a503          	lw	a0,40(s3)
    80003544:	fffff097          	auipc	ra,0xfffff
    80003548:	d86080e7          	jalr	-634(ra) # 800022ca <bread>
    8000354c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000354e:	40000613          	li	a2,1024
    80003552:	05890593          	addi	a1,s2,88
    80003556:	05850513          	addi	a0,a0,88
    8000355a:	ffffd097          	auipc	ra,0xffffd
    8000355e:	c7c080e7          	jalr	-900(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003562:	8526                	mv	a0,s1
    80003564:	fffff097          	auipc	ra,0xfffff
    80003568:	e58080e7          	jalr	-424(ra) # 800023bc <bwrite>
    if(recovering == 0)
    8000356c:	f80b1ce3          	bnez	s6,80003504 <install_trans+0x36>
      bunpin(dbuf);
    80003570:	8526                	mv	a0,s1
    80003572:	fffff097          	auipc	ra,0xfffff
    80003576:	f62080e7          	jalr	-158(ra) # 800024d4 <bunpin>
    8000357a:	b769                	j	80003504 <install_trans+0x36>
}
    8000357c:	70e2                	ld	ra,56(sp)
    8000357e:	7442                	ld	s0,48(sp)
    80003580:	74a2                	ld	s1,40(sp)
    80003582:	7902                	ld	s2,32(sp)
    80003584:	69e2                	ld	s3,24(sp)
    80003586:	6a42                	ld	s4,16(sp)
    80003588:	6aa2                	ld	s5,8(sp)
    8000358a:	6b02                	ld	s6,0(sp)
    8000358c:	6121                	addi	sp,sp,64
    8000358e:	8082                	ret
    80003590:	8082                	ret

0000000080003592 <initlog>:
{
    80003592:	7179                	addi	sp,sp,-48
    80003594:	f406                	sd	ra,40(sp)
    80003596:	f022                	sd	s0,32(sp)
    80003598:	ec26                	sd	s1,24(sp)
    8000359a:	e84a                	sd	s2,16(sp)
    8000359c:	e44e                	sd	s3,8(sp)
    8000359e:	1800                	addi	s0,sp,48
    800035a0:	892a                	mv	s2,a0
    800035a2:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035a4:	00010497          	auipc	s1,0x10
    800035a8:	74c48493          	addi	s1,s1,1868 # 80013cf0 <log>
    800035ac:	00005597          	auipc	a1,0x5
    800035b0:	00458593          	addi	a1,a1,4 # 800085b0 <syscalls+0x1e0>
    800035b4:	8526                	mv	a0,s1
    800035b6:	00003097          	auipc	ra,0x3
    800035ba:	d5e080e7          	jalr	-674(ra) # 80006314 <initlock>
  log.start = sb->logstart;
    800035be:	0149a583          	lw	a1,20(s3)
    800035c2:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800035c4:	0109a783          	lw	a5,16(s3)
    800035c8:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800035ca:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800035ce:	854a                	mv	a0,s2
    800035d0:	fffff097          	auipc	ra,0xfffff
    800035d4:	cfa080e7          	jalr	-774(ra) # 800022ca <bread>
  log.lh.n = lh->n;
    800035d8:	4d34                	lw	a3,88(a0)
    800035da:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800035dc:	02d05663          	blez	a3,80003608 <initlog+0x76>
    800035e0:	05c50793          	addi	a5,a0,92
    800035e4:	00010717          	auipc	a4,0x10
    800035e8:	73c70713          	addi	a4,a4,1852 # 80013d20 <log+0x30>
    800035ec:	36fd                	addiw	a3,a3,-1
    800035ee:	02069613          	slli	a2,a3,0x20
    800035f2:	01e65693          	srli	a3,a2,0x1e
    800035f6:	06050613          	addi	a2,a0,96
    800035fa:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800035fc:	4390                	lw	a2,0(a5)
    800035fe:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003600:	0791                	addi	a5,a5,4
    80003602:	0711                	addi	a4,a4,4
    80003604:	fed79ce3          	bne	a5,a3,800035fc <initlog+0x6a>
  brelse(buf);
    80003608:	fffff097          	auipc	ra,0xfffff
    8000360c:	df2080e7          	jalr	-526(ra) # 800023fa <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003610:	4505                	li	a0,1
    80003612:	00000097          	auipc	ra,0x0
    80003616:	ebc080e7          	jalr	-324(ra) # 800034ce <install_trans>
  log.lh.n = 0;
    8000361a:	00010797          	auipc	a5,0x10
    8000361e:	7007a123          	sw	zero,1794(a5) # 80013d1c <log+0x2c>
  write_head(); // clear the log
    80003622:	00000097          	auipc	ra,0x0
    80003626:	e30080e7          	jalr	-464(ra) # 80003452 <write_head>
}
    8000362a:	70a2                	ld	ra,40(sp)
    8000362c:	7402                	ld	s0,32(sp)
    8000362e:	64e2                	ld	s1,24(sp)
    80003630:	6942                	ld	s2,16(sp)
    80003632:	69a2                	ld	s3,8(sp)
    80003634:	6145                	addi	sp,sp,48
    80003636:	8082                	ret

0000000080003638 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003638:	1101                	addi	sp,sp,-32
    8000363a:	ec06                	sd	ra,24(sp)
    8000363c:	e822                	sd	s0,16(sp)
    8000363e:	e426                	sd	s1,8(sp)
    80003640:	e04a                	sd	s2,0(sp)
    80003642:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003644:	00010517          	auipc	a0,0x10
    80003648:	6ac50513          	addi	a0,a0,1708 # 80013cf0 <log>
    8000364c:	00003097          	auipc	ra,0x3
    80003650:	d58080e7          	jalr	-680(ra) # 800063a4 <acquire>
  while(1){
    if(log.committing){
    80003654:	00010497          	auipc	s1,0x10
    80003658:	69c48493          	addi	s1,s1,1692 # 80013cf0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000365c:	4979                	li	s2,30
    8000365e:	a039                	j	8000366c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003660:	85a6                	mv	a1,s1
    80003662:	8526                	mv	a0,s1
    80003664:	ffffe097          	auipc	ra,0xffffe
    80003668:	e98080e7          	jalr	-360(ra) # 800014fc <sleep>
    if(log.committing){
    8000366c:	50dc                	lw	a5,36(s1)
    8000366e:	fbed                	bnez	a5,80003660 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003670:	5098                	lw	a4,32(s1)
    80003672:	2705                	addiw	a4,a4,1
    80003674:	0007069b          	sext.w	a3,a4
    80003678:	0027179b          	slliw	a5,a4,0x2
    8000367c:	9fb9                	addw	a5,a5,a4
    8000367e:	0017979b          	slliw	a5,a5,0x1
    80003682:	54d8                	lw	a4,44(s1)
    80003684:	9fb9                	addw	a5,a5,a4
    80003686:	00f95963          	bge	s2,a5,80003698 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000368a:	85a6                	mv	a1,s1
    8000368c:	8526                	mv	a0,s1
    8000368e:	ffffe097          	auipc	ra,0xffffe
    80003692:	e6e080e7          	jalr	-402(ra) # 800014fc <sleep>
    80003696:	bfd9                	j	8000366c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003698:	00010517          	auipc	a0,0x10
    8000369c:	65850513          	addi	a0,a0,1624 # 80013cf0 <log>
    800036a0:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800036a2:	00003097          	auipc	ra,0x3
    800036a6:	db6080e7          	jalr	-586(ra) # 80006458 <release>
      break;
    }
  }
}
    800036aa:	60e2                	ld	ra,24(sp)
    800036ac:	6442                	ld	s0,16(sp)
    800036ae:	64a2                	ld	s1,8(sp)
    800036b0:	6902                	ld	s2,0(sp)
    800036b2:	6105                	addi	sp,sp,32
    800036b4:	8082                	ret

00000000800036b6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036b6:	7139                	addi	sp,sp,-64
    800036b8:	fc06                	sd	ra,56(sp)
    800036ba:	f822                	sd	s0,48(sp)
    800036bc:	f426                	sd	s1,40(sp)
    800036be:	f04a                	sd	s2,32(sp)
    800036c0:	ec4e                	sd	s3,24(sp)
    800036c2:	e852                	sd	s4,16(sp)
    800036c4:	e456                	sd	s5,8(sp)
    800036c6:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800036c8:	00010497          	auipc	s1,0x10
    800036cc:	62848493          	addi	s1,s1,1576 # 80013cf0 <log>
    800036d0:	8526                	mv	a0,s1
    800036d2:	00003097          	auipc	ra,0x3
    800036d6:	cd2080e7          	jalr	-814(ra) # 800063a4 <acquire>
  log.outstanding -= 1;
    800036da:	509c                	lw	a5,32(s1)
    800036dc:	37fd                	addiw	a5,a5,-1
    800036de:	0007891b          	sext.w	s2,a5
    800036e2:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800036e4:	50dc                	lw	a5,36(s1)
    800036e6:	e7b9                	bnez	a5,80003734 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800036e8:	04091e63          	bnez	s2,80003744 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800036ec:	00010497          	auipc	s1,0x10
    800036f0:	60448493          	addi	s1,s1,1540 # 80013cf0 <log>
    800036f4:	4785                	li	a5,1
    800036f6:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036f8:	8526                	mv	a0,s1
    800036fa:	00003097          	auipc	ra,0x3
    800036fe:	d5e080e7          	jalr	-674(ra) # 80006458 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003702:	54dc                	lw	a5,44(s1)
    80003704:	06f04763          	bgtz	a5,80003772 <end_op+0xbc>
    acquire(&log.lock);
    80003708:	00010497          	auipc	s1,0x10
    8000370c:	5e848493          	addi	s1,s1,1512 # 80013cf0 <log>
    80003710:	8526                	mv	a0,s1
    80003712:	00003097          	auipc	ra,0x3
    80003716:	c92080e7          	jalr	-878(ra) # 800063a4 <acquire>
    log.committing = 0;
    8000371a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000371e:	8526                	mv	a0,s1
    80003720:	ffffe097          	auipc	ra,0xffffe
    80003724:	e40080e7          	jalr	-448(ra) # 80001560 <wakeup>
    release(&log.lock);
    80003728:	8526                	mv	a0,s1
    8000372a:	00003097          	auipc	ra,0x3
    8000372e:	d2e080e7          	jalr	-722(ra) # 80006458 <release>
}
    80003732:	a03d                	j	80003760 <end_op+0xaa>
    panic("log.committing");
    80003734:	00005517          	auipc	a0,0x5
    80003738:	e8450513          	addi	a0,a0,-380 # 800085b8 <syscalls+0x1e8>
    8000373c:	00002097          	auipc	ra,0x2
    80003740:	730080e7          	jalr	1840(ra) # 80005e6c <panic>
    wakeup(&log);
    80003744:	00010497          	auipc	s1,0x10
    80003748:	5ac48493          	addi	s1,s1,1452 # 80013cf0 <log>
    8000374c:	8526                	mv	a0,s1
    8000374e:	ffffe097          	auipc	ra,0xffffe
    80003752:	e12080e7          	jalr	-494(ra) # 80001560 <wakeup>
  release(&log.lock);
    80003756:	8526                	mv	a0,s1
    80003758:	00003097          	auipc	ra,0x3
    8000375c:	d00080e7          	jalr	-768(ra) # 80006458 <release>
}
    80003760:	70e2                	ld	ra,56(sp)
    80003762:	7442                	ld	s0,48(sp)
    80003764:	74a2                	ld	s1,40(sp)
    80003766:	7902                	ld	s2,32(sp)
    80003768:	69e2                	ld	s3,24(sp)
    8000376a:	6a42                	ld	s4,16(sp)
    8000376c:	6aa2                	ld	s5,8(sp)
    8000376e:	6121                	addi	sp,sp,64
    80003770:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003772:	00010a97          	auipc	s5,0x10
    80003776:	5aea8a93          	addi	s5,s5,1454 # 80013d20 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000377a:	00010a17          	auipc	s4,0x10
    8000377e:	576a0a13          	addi	s4,s4,1398 # 80013cf0 <log>
    80003782:	018a2583          	lw	a1,24(s4)
    80003786:	012585bb          	addw	a1,a1,s2
    8000378a:	2585                	addiw	a1,a1,1
    8000378c:	028a2503          	lw	a0,40(s4)
    80003790:	fffff097          	auipc	ra,0xfffff
    80003794:	b3a080e7          	jalr	-1222(ra) # 800022ca <bread>
    80003798:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000379a:	000aa583          	lw	a1,0(s5)
    8000379e:	028a2503          	lw	a0,40(s4)
    800037a2:	fffff097          	auipc	ra,0xfffff
    800037a6:	b28080e7          	jalr	-1240(ra) # 800022ca <bread>
    800037aa:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800037ac:	40000613          	li	a2,1024
    800037b0:	05850593          	addi	a1,a0,88
    800037b4:	05848513          	addi	a0,s1,88
    800037b8:	ffffd097          	auipc	ra,0xffffd
    800037bc:	a1e080e7          	jalr	-1506(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    800037c0:	8526                	mv	a0,s1
    800037c2:	fffff097          	auipc	ra,0xfffff
    800037c6:	bfa080e7          	jalr	-1030(ra) # 800023bc <bwrite>
    brelse(from);
    800037ca:	854e                	mv	a0,s3
    800037cc:	fffff097          	auipc	ra,0xfffff
    800037d0:	c2e080e7          	jalr	-978(ra) # 800023fa <brelse>
    brelse(to);
    800037d4:	8526                	mv	a0,s1
    800037d6:	fffff097          	auipc	ra,0xfffff
    800037da:	c24080e7          	jalr	-988(ra) # 800023fa <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037de:	2905                	addiw	s2,s2,1
    800037e0:	0a91                	addi	s5,s5,4
    800037e2:	02ca2783          	lw	a5,44(s4)
    800037e6:	f8f94ee3          	blt	s2,a5,80003782 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037ea:	00000097          	auipc	ra,0x0
    800037ee:	c68080e7          	jalr	-920(ra) # 80003452 <write_head>
    install_trans(0); // Now install writes to home locations
    800037f2:	4501                	li	a0,0
    800037f4:	00000097          	auipc	ra,0x0
    800037f8:	cda080e7          	jalr	-806(ra) # 800034ce <install_trans>
    log.lh.n = 0;
    800037fc:	00010797          	auipc	a5,0x10
    80003800:	5207a023          	sw	zero,1312(a5) # 80013d1c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003804:	00000097          	auipc	ra,0x0
    80003808:	c4e080e7          	jalr	-946(ra) # 80003452 <write_head>
    8000380c:	bdf5                	j	80003708 <end_op+0x52>

000000008000380e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000380e:	1101                	addi	sp,sp,-32
    80003810:	ec06                	sd	ra,24(sp)
    80003812:	e822                	sd	s0,16(sp)
    80003814:	e426                	sd	s1,8(sp)
    80003816:	e04a                	sd	s2,0(sp)
    80003818:	1000                	addi	s0,sp,32
    8000381a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000381c:	00010917          	auipc	s2,0x10
    80003820:	4d490913          	addi	s2,s2,1236 # 80013cf0 <log>
    80003824:	854a                	mv	a0,s2
    80003826:	00003097          	auipc	ra,0x3
    8000382a:	b7e080e7          	jalr	-1154(ra) # 800063a4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000382e:	02c92603          	lw	a2,44(s2)
    80003832:	47f5                	li	a5,29
    80003834:	06c7c563          	blt	a5,a2,8000389e <log_write+0x90>
    80003838:	00010797          	auipc	a5,0x10
    8000383c:	4d47a783          	lw	a5,1236(a5) # 80013d0c <log+0x1c>
    80003840:	37fd                	addiw	a5,a5,-1
    80003842:	04f65e63          	bge	a2,a5,8000389e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003846:	00010797          	auipc	a5,0x10
    8000384a:	4ca7a783          	lw	a5,1226(a5) # 80013d10 <log+0x20>
    8000384e:	06f05063          	blez	a5,800038ae <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003852:	4781                	li	a5,0
    80003854:	06c05563          	blez	a2,800038be <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003858:	44cc                	lw	a1,12(s1)
    8000385a:	00010717          	auipc	a4,0x10
    8000385e:	4c670713          	addi	a4,a4,1222 # 80013d20 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003862:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003864:	4314                	lw	a3,0(a4)
    80003866:	04b68c63          	beq	a3,a1,800038be <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000386a:	2785                	addiw	a5,a5,1
    8000386c:	0711                	addi	a4,a4,4
    8000386e:	fef61be3          	bne	a2,a5,80003864 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003872:	0621                	addi	a2,a2,8
    80003874:	060a                	slli	a2,a2,0x2
    80003876:	00010797          	auipc	a5,0x10
    8000387a:	47a78793          	addi	a5,a5,1146 # 80013cf0 <log>
    8000387e:	97b2                	add	a5,a5,a2
    80003880:	44d8                	lw	a4,12(s1)
    80003882:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003884:	8526                	mv	a0,s1
    80003886:	fffff097          	auipc	ra,0xfffff
    8000388a:	c12080e7          	jalr	-1006(ra) # 80002498 <bpin>
    log.lh.n++;
    8000388e:	00010717          	auipc	a4,0x10
    80003892:	46270713          	addi	a4,a4,1122 # 80013cf0 <log>
    80003896:	575c                	lw	a5,44(a4)
    80003898:	2785                	addiw	a5,a5,1
    8000389a:	d75c                	sw	a5,44(a4)
    8000389c:	a82d                	j	800038d6 <log_write+0xc8>
    panic("too big a transaction");
    8000389e:	00005517          	auipc	a0,0x5
    800038a2:	d2a50513          	addi	a0,a0,-726 # 800085c8 <syscalls+0x1f8>
    800038a6:	00002097          	auipc	ra,0x2
    800038aa:	5c6080e7          	jalr	1478(ra) # 80005e6c <panic>
    panic("log_write outside of trans");
    800038ae:	00005517          	auipc	a0,0x5
    800038b2:	d3250513          	addi	a0,a0,-718 # 800085e0 <syscalls+0x210>
    800038b6:	00002097          	auipc	ra,0x2
    800038ba:	5b6080e7          	jalr	1462(ra) # 80005e6c <panic>
  log.lh.block[i] = b->blockno;
    800038be:	00878693          	addi	a3,a5,8
    800038c2:	068a                	slli	a3,a3,0x2
    800038c4:	00010717          	auipc	a4,0x10
    800038c8:	42c70713          	addi	a4,a4,1068 # 80013cf0 <log>
    800038cc:	9736                	add	a4,a4,a3
    800038ce:	44d4                	lw	a3,12(s1)
    800038d0:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800038d2:	faf609e3          	beq	a2,a5,80003884 <log_write+0x76>
  }
  release(&log.lock);
    800038d6:	00010517          	auipc	a0,0x10
    800038da:	41a50513          	addi	a0,a0,1050 # 80013cf0 <log>
    800038de:	00003097          	auipc	ra,0x3
    800038e2:	b7a080e7          	jalr	-1158(ra) # 80006458 <release>
}
    800038e6:	60e2                	ld	ra,24(sp)
    800038e8:	6442                	ld	s0,16(sp)
    800038ea:	64a2                	ld	s1,8(sp)
    800038ec:	6902                	ld	s2,0(sp)
    800038ee:	6105                	addi	sp,sp,32
    800038f0:	8082                	ret

00000000800038f2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038f2:	1101                	addi	sp,sp,-32
    800038f4:	ec06                	sd	ra,24(sp)
    800038f6:	e822                	sd	s0,16(sp)
    800038f8:	e426                	sd	s1,8(sp)
    800038fa:	e04a                	sd	s2,0(sp)
    800038fc:	1000                	addi	s0,sp,32
    800038fe:	84aa                	mv	s1,a0
    80003900:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003902:	00005597          	auipc	a1,0x5
    80003906:	cfe58593          	addi	a1,a1,-770 # 80008600 <syscalls+0x230>
    8000390a:	0521                	addi	a0,a0,8
    8000390c:	00003097          	auipc	ra,0x3
    80003910:	a08080e7          	jalr	-1528(ra) # 80006314 <initlock>
  lk->name = name;
    80003914:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003918:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000391c:	0204a423          	sw	zero,40(s1)
}
    80003920:	60e2                	ld	ra,24(sp)
    80003922:	6442                	ld	s0,16(sp)
    80003924:	64a2                	ld	s1,8(sp)
    80003926:	6902                	ld	s2,0(sp)
    80003928:	6105                	addi	sp,sp,32
    8000392a:	8082                	ret

000000008000392c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000392c:	1101                	addi	sp,sp,-32
    8000392e:	ec06                	sd	ra,24(sp)
    80003930:	e822                	sd	s0,16(sp)
    80003932:	e426                	sd	s1,8(sp)
    80003934:	e04a                	sd	s2,0(sp)
    80003936:	1000                	addi	s0,sp,32
    80003938:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000393a:	00850913          	addi	s2,a0,8
    8000393e:	854a                	mv	a0,s2
    80003940:	00003097          	auipc	ra,0x3
    80003944:	a64080e7          	jalr	-1436(ra) # 800063a4 <acquire>
  while (lk->locked) {
    80003948:	409c                	lw	a5,0(s1)
    8000394a:	cb89                	beqz	a5,8000395c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000394c:	85ca                	mv	a1,s2
    8000394e:	8526                	mv	a0,s1
    80003950:	ffffe097          	auipc	ra,0xffffe
    80003954:	bac080e7          	jalr	-1108(ra) # 800014fc <sleep>
  while (lk->locked) {
    80003958:	409c                	lw	a5,0(s1)
    8000395a:	fbed                	bnez	a5,8000394c <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000395c:	4785                	li	a5,1
    8000395e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003960:	ffffd097          	auipc	ra,0xffffd
    80003964:	4f4080e7          	jalr	1268(ra) # 80000e54 <myproc>
    80003968:	591c                	lw	a5,48(a0)
    8000396a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000396c:	854a                	mv	a0,s2
    8000396e:	00003097          	auipc	ra,0x3
    80003972:	aea080e7          	jalr	-1302(ra) # 80006458 <release>
}
    80003976:	60e2                	ld	ra,24(sp)
    80003978:	6442                	ld	s0,16(sp)
    8000397a:	64a2                	ld	s1,8(sp)
    8000397c:	6902                	ld	s2,0(sp)
    8000397e:	6105                	addi	sp,sp,32
    80003980:	8082                	ret

0000000080003982 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003982:	1101                	addi	sp,sp,-32
    80003984:	ec06                	sd	ra,24(sp)
    80003986:	e822                	sd	s0,16(sp)
    80003988:	e426                	sd	s1,8(sp)
    8000398a:	e04a                	sd	s2,0(sp)
    8000398c:	1000                	addi	s0,sp,32
    8000398e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003990:	00850913          	addi	s2,a0,8
    80003994:	854a                	mv	a0,s2
    80003996:	00003097          	auipc	ra,0x3
    8000399a:	a0e080e7          	jalr	-1522(ra) # 800063a4 <acquire>
  lk->locked = 0;
    8000399e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039a2:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800039a6:	8526                	mv	a0,s1
    800039a8:	ffffe097          	auipc	ra,0xffffe
    800039ac:	bb8080e7          	jalr	-1096(ra) # 80001560 <wakeup>
  release(&lk->lk);
    800039b0:	854a                	mv	a0,s2
    800039b2:	00003097          	auipc	ra,0x3
    800039b6:	aa6080e7          	jalr	-1370(ra) # 80006458 <release>
}
    800039ba:	60e2                	ld	ra,24(sp)
    800039bc:	6442                	ld	s0,16(sp)
    800039be:	64a2                	ld	s1,8(sp)
    800039c0:	6902                	ld	s2,0(sp)
    800039c2:	6105                	addi	sp,sp,32
    800039c4:	8082                	ret

00000000800039c6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800039c6:	7179                	addi	sp,sp,-48
    800039c8:	f406                	sd	ra,40(sp)
    800039ca:	f022                	sd	s0,32(sp)
    800039cc:	ec26                	sd	s1,24(sp)
    800039ce:	e84a                	sd	s2,16(sp)
    800039d0:	e44e                	sd	s3,8(sp)
    800039d2:	1800                	addi	s0,sp,48
    800039d4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800039d6:	00850913          	addi	s2,a0,8
    800039da:	854a                	mv	a0,s2
    800039dc:	00003097          	auipc	ra,0x3
    800039e0:	9c8080e7          	jalr	-1592(ra) # 800063a4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039e4:	409c                	lw	a5,0(s1)
    800039e6:	ef99                	bnez	a5,80003a04 <holdingsleep+0x3e>
    800039e8:	4481                	li	s1,0
  release(&lk->lk);
    800039ea:	854a                	mv	a0,s2
    800039ec:	00003097          	auipc	ra,0x3
    800039f0:	a6c080e7          	jalr	-1428(ra) # 80006458 <release>
  return r;
}
    800039f4:	8526                	mv	a0,s1
    800039f6:	70a2                	ld	ra,40(sp)
    800039f8:	7402                	ld	s0,32(sp)
    800039fa:	64e2                	ld	s1,24(sp)
    800039fc:	6942                	ld	s2,16(sp)
    800039fe:	69a2                	ld	s3,8(sp)
    80003a00:	6145                	addi	sp,sp,48
    80003a02:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a04:	0284a983          	lw	s3,40(s1)
    80003a08:	ffffd097          	auipc	ra,0xffffd
    80003a0c:	44c080e7          	jalr	1100(ra) # 80000e54 <myproc>
    80003a10:	5904                	lw	s1,48(a0)
    80003a12:	413484b3          	sub	s1,s1,s3
    80003a16:	0014b493          	seqz	s1,s1
    80003a1a:	bfc1                	j	800039ea <holdingsleep+0x24>

0000000080003a1c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a1c:	1141                	addi	sp,sp,-16
    80003a1e:	e406                	sd	ra,8(sp)
    80003a20:	e022                	sd	s0,0(sp)
    80003a22:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a24:	00005597          	auipc	a1,0x5
    80003a28:	bec58593          	addi	a1,a1,-1044 # 80008610 <syscalls+0x240>
    80003a2c:	00010517          	auipc	a0,0x10
    80003a30:	40c50513          	addi	a0,a0,1036 # 80013e38 <ftable>
    80003a34:	00003097          	auipc	ra,0x3
    80003a38:	8e0080e7          	jalr	-1824(ra) # 80006314 <initlock>
}
    80003a3c:	60a2                	ld	ra,8(sp)
    80003a3e:	6402                	ld	s0,0(sp)
    80003a40:	0141                	addi	sp,sp,16
    80003a42:	8082                	ret

0000000080003a44 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a44:	1101                	addi	sp,sp,-32
    80003a46:	ec06                	sd	ra,24(sp)
    80003a48:	e822                	sd	s0,16(sp)
    80003a4a:	e426                	sd	s1,8(sp)
    80003a4c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a4e:	00010517          	auipc	a0,0x10
    80003a52:	3ea50513          	addi	a0,a0,1002 # 80013e38 <ftable>
    80003a56:	00003097          	auipc	ra,0x3
    80003a5a:	94e080e7          	jalr	-1714(ra) # 800063a4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a5e:	00010497          	auipc	s1,0x10
    80003a62:	3f248493          	addi	s1,s1,1010 # 80013e50 <ftable+0x18>
    80003a66:	00011717          	auipc	a4,0x11
    80003a6a:	38a70713          	addi	a4,a4,906 # 80014df0 <disk>
    if(f->ref == 0){
    80003a6e:	40dc                	lw	a5,4(s1)
    80003a70:	cf99                	beqz	a5,80003a8e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a72:	02848493          	addi	s1,s1,40
    80003a76:	fee49ce3          	bne	s1,a4,80003a6e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a7a:	00010517          	auipc	a0,0x10
    80003a7e:	3be50513          	addi	a0,a0,958 # 80013e38 <ftable>
    80003a82:	00003097          	auipc	ra,0x3
    80003a86:	9d6080e7          	jalr	-1578(ra) # 80006458 <release>
  return 0;
    80003a8a:	4481                	li	s1,0
    80003a8c:	a819                	j	80003aa2 <filealloc+0x5e>
      f->ref = 1;
    80003a8e:	4785                	li	a5,1
    80003a90:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a92:	00010517          	auipc	a0,0x10
    80003a96:	3a650513          	addi	a0,a0,934 # 80013e38 <ftable>
    80003a9a:	00003097          	auipc	ra,0x3
    80003a9e:	9be080e7          	jalr	-1602(ra) # 80006458 <release>
}
    80003aa2:	8526                	mv	a0,s1
    80003aa4:	60e2                	ld	ra,24(sp)
    80003aa6:	6442                	ld	s0,16(sp)
    80003aa8:	64a2                	ld	s1,8(sp)
    80003aaa:	6105                	addi	sp,sp,32
    80003aac:	8082                	ret

0000000080003aae <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003aae:	1101                	addi	sp,sp,-32
    80003ab0:	ec06                	sd	ra,24(sp)
    80003ab2:	e822                	sd	s0,16(sp)
    80003ab4:	e426                	sd	s1,8(sp)
    80003ab6:	1000                	addi	s0,sp,32
    80003ab8:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003aba:	00010517          	auipc	a0,0x10
    80003abe:	37e50513          	addi	a0,a0,894 # 80013e38 <ftable>
    80003ac2:	00003097          	auipc	ra,0x3
    80003ac6:	8e2080e7          	jalr	-1822(ra) # 800063a4 <acquire>
  if(f->ref < 1)
    80003aca:	40dc                	lw	a5,4(s1)
    80003acc:	02f05263          	blez	a5,80003af0 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003ad0:	2785                	addiw	a5,a5,1
    80003ad2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003ad4:	00010517          	auipc	a0,0x10
    80003ad8:	36450513          	addi	a0,a0,868 # 80013e38 <ftable>
    80003adc:	00003097          	auipc	ra,0x3
    80003ae0:	97c080e7          	jalr	-1668(ra) # 80006458 <release>
  return f;
}
    80003ae4:	8526                	mv	a0,s1
    80003ae6:	60e2                	ld	ra,24(sp)
    80003ae8:	6442                	ld	s0,16(sp)
    80003aea:	64a2                	ld	s1,8(sp)
    80003aec:	6105                	addi	sp,sp,32
    80003aee:	8082                	ret
    panic("filedup");
    80003af0:	00005517          	auipc	a0,0x5
    80003af4:	b2850513          	addi	a0,a0,-1240 # 80008618 <syscalls+0x248>
    80003af8:	00002097          	auipc	ra,0x2
    80003afc:	374080e7          	jalr	884(ra) # 80005e6c <panic>

0000000080003b00 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b00:	7139                	addi	sp,sp,-64
    80003b02:	fc06                	sd	ra,56(sp)
    80003b04:	f822                	sd	s0,48(sp)
    80003b06:	f426                	sd	s1,40(sp)
    80003b08:	f04a                	sd	s2,32(sp)
    80003b0a:	ec4e                	sd	s3,24(sp)
    80003b0c:	e852                	sd	s4,16(sp)
    80003b0e:	e456                	sd	s5,8(sp)
    80003b10:	0080                	addi	s0,sp,64
    80003b12:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b14:	00010517          	auipc	a0,0x10
    80003b18:	32450513          	addi	a0,a0,804 # 80013e38 <ftable>
    80003b1c:	00003097          	auipc	ra,0x3
    80003b20:	888080e7          	jalr	-1912(ra) # 800063a4 <acquire>
  if(f->ref < 1)
    80003b24:	40dc                	lw	a5,4(s1)
    80003b26:	06f05163          	blez	a5,80003b88 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b2a:	37fd                	addiw	a5,a5,-1
    80003b2c:	0007871b          	sext.w	a4,a5
    80003b30:	c0dc                	sw	a5,4(s1)
    80003b32:	06e04363          	bgtz	a4,80003b98 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b36:	0004a903          	lw	s2,0(s1)
    80003b3a:	0094ca83          	lbu	s5,9(s1)
    80003b3e:	0104ba03          	ld	s4,16(s1)
    80003b42:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b46:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b4a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b4e:	00010517          	auipc	a0,0x10
    80003b52:	2ea50513          	addi	a0,a0,746 # 80013e38 <ftable>
    80003b56:	00003097          	auipc	ra,0x3
    80003b5a:	902080e7          	jalr	-1790(ra) # 80006458 <release>

  if(ff.type == FD_PIPE){
    80003b5e:	4785                	li	a5,1
    80003b60:	04f90d63          	beq	s2,a5,80003bba <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b64:	3979                	addiw	s2,s2,-2
    80003b66:	4785                	li	a5,1
    80003b68:	0527e063          	bltu	a5,s2,80003ba8 <fileclose+0xa8>
    begin_op();
    80003b6c:	00000097          	auipc	ra,0x0
    80003b70:	acc080e7          	jalr	-1332(ra) # 80003638 <begin_op>
    iput(ff.ip);
    80003b74:	854e                	mv	a0,s3
    80003b76:	fffff097          	auipc	ra,0xfffff
    80003b7a:	2ae080e7          	jalr	686(ra) # 80002e24 <iput>
    end_op();
    80003b7e:	00000097          	auipc	ra,0x0
    80003b82:	b38080e7          	jalr	-1224(ra) # 800036b6 <end_op>
    80003b86:	a00d                	j	80003ba8 <fileclose+0xa8>
    panic("fileclose");
    80003b88:	00005517          	auipc	a0,0x5
    80003b8c:	a9850513          	addi	a0,a0,-1384 # 80008620 <syscalls+0x250>
    80003b90:	00002097          	auipc	ra,0x2
    80003b94:	2dc080e7          	jalr	732(ra) # 80005e6c <panic>
    release(&ftable.lock);
    80003b98:	00010517          	auipc	a0,0x10
    80003b9c:	2a050513          	addi	a0,a0,672 # 80013e38 <ftable>
    80003ba0:	00003097          	auipc	ra,0x3
    80003ba4:	8b8080e7          	jalr	-1864(ra) # 80006458 <release>
  }
}
    80003ba8:	70e2                	ld	ra,56(sp)
    80003baa:	7442                	ld	s0,48(sp)
    80003bac:	74a2                	ld	s1,40(sp)
    80003bae:	7902                	ld	s2,32(sp)
    80003bb0:	69e2                	ld	s3,24(sp)
    80003bb2:	6a42                	ld	s4,16(sp)
    80003bb4:	6aa2                	ld	s5,8(sp)
    80003bb6:	6121                	addi	sp,sp,64
    80003bb8:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003bba:	85d6                	mv	a1,s5
    80003bbc:	8552                	mv	a0,s4
    80003bbe:	00000097          	auipc	ra,0x0
    80003bc2:	34c080e7          	jalr	844(ra) # 80003f0a <pipeclose>
    80003bc6:	b7cd                	j	80003ba8 <fileclose+0xa8>

0000000080003bc8 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003bc8:	715d                	addi	sp,sp,-80
    80003bca:	e486                	sd	ra,72(sp)
    80003bcc:	e0a2                	sd	s0,64(sp)
    80003bce:	fc26                	sd	s1,56(sp)
    80003bd0:	f84a                	sd	s2,48(sp)
    80003bd2:	f44e                	sd	s3,40(sp)
    80003bd4:	0880                	addi	s0,sp,80
    80003bd6:	84aa                	mv	s1,a0
    80003bd8:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003bda:	ffffd097          	auipc	ra,0xffffd
    80003bde:	27a080e7          	jalr	634(ra) # 80000e54 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003be2:	409c                	lw	a5,0(s1)
    80003be4:	37f9                	addiw	a5,a5,-2
    80003be6:	4705                	li	a4,1
    80003be8:	04f76763          	bltu	a4,a5,80003c36 <filestat+0x6e>
    80003bec:	892a                	mv	s2,a0
    ilock(f->ip);
    80003bee:	6c88                	ld	a0,24(s1)
    80003bf0:	fffff097          	auipc	ra,0xfffff
    80003bf4:	fd4080e7          	jalr	-44(ra) # 80002bc4 <ilock>
    stati(f->ip, &st);
    80003bf8:	fb840593          	addi	a1,s0,-72
    80003bfc:	6c88                	ld	a0,24(s1)
    80003bfe:	fffff097          	auipc	ra,0xfffff
    80003c02:	2f6080e7          	jalr	758(ra) # 80002ef4 <stati>
    iunlock(f->ip);
    80003c06:	6c88                	ld	a0,24(s1)
    80003c08:	fffff097          	auipc	ra,0xfffff
    80003c0c:	07e080e7          	jalr	126(ra) # 80002c86 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c10:	46e1                	li	a3,24
    80003c12:	fb840613          	addi	a2,s0,-72
    80003c16:	85ce                	mv	a1,s3
    80003c18:	05093503          	ld	a0,80(s2)
    80003c1c:	ffffd097          	auipc	ra,0xffffd
    80003c20:	ef8080e7          	jalr	-264(ra) # 80000b14 <copyout>
    80003c24:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c28:	60a6                	ld	ra,72(sp)
    80003c2a:	6406                	ld	s0,64(sp)
    80003c2c:	74e2                	ld	s1,56(sp)
    80003c2e:	7942                	ld	s2,48(sp)
    80003c30:	79a2                	ld	s3,40(sp)
    80003c32:	6161                	addi	sp,sp,80
    80003c34:	8082                	ret
  return -1;
    80003c36:	557d                	li	a0,-1
    80003c38:	bfc5                	j	80003c28 <filestat+0x60>

0000000080003c3a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c3a:	7179                	addi	sp,sp,-48
    80003c3c:	f406                	sd	ra,40(sp)
    80003c3e:	f022                	sd	s0,32(sp)
    80003c40:	ec26                	sd	s1,24(sp)
    80003c42:	e84a                	sd	s2,16(sp)
    80003c44:	e44e                	sd	s3,8(sp)
    80003c46:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c48:	00854783          	lbu	a5,8(a0)
    80003c4c:	c3d5                	beqz	a5,80003cf0 <fileread+0xb6>
    80003c4e:	84aa                	mv	s1,a0
    80003c50:	89ae                	mv	s3,a1
    80003c52:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c54:	411c                	lw	a5,0(a0)
    80003c56:	4705                	li	a4,1
    80003c58:	04e78963          	beq	a5,a4,80003caa <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c5c:	470d                	li	a4,3
    80003c5e:	04e78d63          	beq	a5,a4,80003cb8 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c62:	4709                	li	a4,2
    80003c64:	06e79e63          	bne	a5,a4,80003ce0 <fileread+0xa6>
    ilock(f->ip);
    80003c68:	6d08                	ld	a0,24(a0)
    80003c6a:	fffff097          	auipc	ra,0xfffff
    80003c6e:	f5a080e7          	jalr	-166(ra) # 80002bc4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c72:	874a                	mv	a4,s2
    80003c74:	5094                	lw	a3,32(s1)
    80003c76:	864e                	mv	a2,s3
    80003c78:	4585                	li	a1,1
    80003c7a:	6c88                	ld	a0,24(s1)
    80003c7c:	fffff097          	auipc	ra,0xfffff
    80003c80:	2a2080e7          	jalr	674(ra) # 80002f1e <readi>
    80003c84:	892a                	mv	s2,a0
    80003c86:	00a05563          	blez	a0,80003c90 <fileread+0x56>
      f->off += r;
    80003c8a:	509c                	lw	a5,32(s1)
    80003c8c:	9fa9                	addw	a5,a5,a0
    80003c8e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c90:	6c88                	ld	a0,24(s1)
    80003c92:	fffff097          	auipc	ra,0xfffff
    80003c96:	ff4080e7          	jalr	-12(ra) # 80002c86 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c9a:	854a                	mv	a0,s2
    80003c9c:	70a2                	ld	ra,40(sp)
    80003c9e:	7402                	ld	s0,32(sp)
    80003ca0:	64e2                	ld	s1,24(sp)
    80003ca2:	6942                	ld	s2,16(sp)
    80003ca4:	69a2                	ld	s3,8(sp)
    80003ca6:	6145                	addi	sp,sp,48
    80003ca8:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003caa:	6908                	ld	a0,16(a0)
    80003cac:	00000097          	auipc	ra,0x0
    80003cb0:	3c6080e7          	jalr	966(ra) # 80004072 <piperead>
    80003cb4:	892a                	mv	s2,a0
    80003cb6:	b7d5                	j	80003c9a <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003cb8:	02451783          	lh	a5,36(a0)
    80003cbc:	03079693          	slli	a3,a5,0x30
    80003cc0:	92c1                	srli	a3,a3,0x30
    80003cc2:	4725                	li	a4,9
    80003cc4:	02d76863          	bltu	a4,a3,80003cf4 <fileread+0xba>
    80003cc8:	0792                	slli	a5,a5,0x4
    80003cca:	00010717          	auipc	a4,0x10
    80003cce:	0ce70713          	addi	a4,a4,206 # 80013d98 <devsw>
    80003cd2:	97ba                	add	a5,a5,a4
    80003cd4:	639c                	ld	a5,0(a5)
    80003cd6:	c38d                	beqz	a5,80003cf8 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003cd8:	4505                	li	a0,1
    80003cda:	9782                	jalr	a5
    80003cdc:	892a                	mv	s2,a0
    80003cde:	bf75                	j	80003c9a <fileread+0x60>
    panic("fileread");
    80003ce0:	00005517          	auipc	a0,0x5
    80003ce4:	95050513          	addi	a0,a0,-1712 # 80008630 <syscalls+0x260>
    80003ce8:	00002097          	auipc	ra,0x2
    80003cec:	184080e7          	jalr	388(ra) # 80005e6c <panic>
    return -1;
    80003cf0:	597d                	li	s2,-1
    80003cf2:	b765                	j	80003c9a <fileread+0x60>
      return -1;
    80003cf4:	597d                	li	s2,-1
    80003cf6:	b755                	j	80003c9a <fileread+0x60>
    80003cf8:	597d                	li	s2,-1
    80003cfa:	b745                	j	80003c9a <fileread+0x60>

0000000080003cfc <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003cfc:	715d                	addi	sp,sp,-80
    80003cfe:	e486                	sd	ra,72(sp)
    80003d00:	e0a2                	sd	s0,64(sp)
    80003d02:	fc26                	sd	s1,56(sp)
    80003d04:	f84a                	sd	s2,48(sp)
    80003d06:	f44e                	sd	s3,40(sp)
    80003d08:	f052                	sd	s4,32(sp)
    80003d0a:	ec56                	sd	s5,24(sp)
    80003d0c:	e85a                	sd	s6,16(sp)
    80003d0e:	e45e                	sd	s7,8(sp)
    80003d10:	e062                	sd	s8,0(sp)
    80003d12:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d14:	00954783          	lbu	a5,9(a0)
    80003d18:	10078663          	beqz	a5,80003e24 <filewrite+0x128>
    80003d1c:	892a                	mv	s2,a0
    80003d1e:	8b2e                	mv	s6,a1
    80003d20:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d22:	411c                	lw	a5,0(a0)
    80003d24:	4705                	li	a4,1
    80003d26:	02e78263          	beq	a5,a4,80003d4a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d2a:	470d                	li	a4,3
    80003d2c:	02e78663          	beq	a5,a4,80003d58 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d30:	4709                	li	a4,2
    80003d32:	0ee79163          	bne	a5,a4,80003e14 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d36:	0ac05d63          	blez	a2,80003df0 <filewrite+0xf4>
    int i = 0;
    80003d3a:	4981                	li	s3,0
    80003d3c:	6b85                	lui	s7,0x1
    80003d3e:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003d42:	6c05                	lui	s8,0x1
    80003d44:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003d48:	a861                	j	80003de0 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d4a:	6908                	ld	a0,16(a0)
    80003d4c:	00000097          	auipc	ra,0x0
    80003d50:	22e080e7          	jalr	558(ra) # 80003f7a <pipewrite>
    80003d54:	8a2a                	mv	s4,a0
    80003d56:	a045                	j	80003df6 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d58:	02451783          	lh	a5,36(a0)
    80003d5c:	03079693          	slli	a3,a5,0x30
    80003d60:	92c1                	srli	a3,a3,0x30
    80003d62:	4725                	li	a4,9
    80003d64:	0cd76263          	bltu	a4,a3,80003e28 <filewrite+0x12c>
    80003d68:	0792                	slli	a5,a5,0x4
    80003d6a:	00010717          	auipc	a4,0x10
    80003d6e:	02e70713          	addi	a4,a4,46 # 80013d98 <devsw>
    80003d72:	97ba                	add	a5,a5,a4
    80003d74:	679c                	ld	a5,8(a5)
    80003d76:	cbdd                	beqz	a5,80003e2c <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d78:	4505                	li	a0,1
    80003d7a:	9782                	jalr	a5
    80003d7c:	8a2a                	mv	s4,a0
    80003d7e:	a8a5                	j	80003df6 <filewrite+0xfa>
    80003d80:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d84:	00000097          	auipc	ra,0x0
    80003d88:	8b4080e7          	jalr	-1868(ra) # 80003638 <begin_op>
      ilock(f->ip);
    80003d8c:	01893503          	ld	a0,24(s2)
    80003d90:	fffff097          	auipc	ra,0xfffff
    80003d94:	e34080e7          	jalr	-460(ra) # 80002bc4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d98:	8756                	mv	a4,s5
    80003d9a:	02092683          	lw	a3,32(s2)
    80003d9e:	01698633          	add	a2,s3,s6
    80003da2:	4585                	li	a1,1
    80003da4:	01893503          	ld	a0,24(s2)
    80003da8:	fffff097          	auipc	ra,0xfffff
    80003dac:	26e080e7          	jalr	622(ra) # 80003016 <writei>
    80003db0:	84aa                	mv	s1,a0
    80003db2:	00a05763          	blez	a0,80003dc0 <filewrite+0xc4>
        f->off += r;
    80003db6:	02092783          	lw	a5,32(s2)
    80003dba:	9fa9                	addw	a5,a5,a0
    80003dbc:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003dc0:	01893503          	ld	a0,24(s2)
    80003dc4:	fffff097          	auipc	ra,0xfffff
    80003dc8:	ec2080e7          	jalr	-318(ra) # 80002c86 <iunlock>
      end_op();
    80003dcc:	00000097          	auipc	ra,0x0
    80003dd0:	8ea080e7          	jalr	-1814(ra) # 800036b6 <end_op>

      if(r != n1){
    80003dd4:	009a9f63          	bne	s5,s1,80003df2 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003dd8:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003ddc:	0149db63          	bge	s3,s4,80003df2 <filewrite+0xf6>
      int n1 = n - i;
    80003de0:	413a04bb          	subw	s1,s4,s3
    80003de4:	0004879b          	sext.w	a5,s1
    80003de8:	f8fbdce3          	bge	s7,a5,80003d80 <filewrite+0x84>
    80003dec:	84e2                	mv	s1,s8
    80003dee:	bf49                	j	80003d80 <filewrite+0x84>
    int i = 0;
    80003df0:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003df2:	013a1f63          	bne	s4,s3,80003e10 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003df6:	8552                	mv	a0,s4
    80003df8:	60a6                	ld	ra,72(sp)
    80003dfa:	6406                	ld	s0,64(sp)
    80003dfc:	74e2                	ld	s1,56(sp)
    80003dfe:	7942                	ld	s2,48(sp)
    80003e00:	79a2                	ld	s3,40(sp)
    80003e02:	7a02                	ld	s4,32(sp)
    80003e04:	6ae2                	ld	s5,24(sp)
    80003e06:	6b42                	ld	s6,16(sp)
    80003e08:	6ba2                	ld	s7,8(sp)
    80003e0a:	6c02                	ld	s8,0(sp)
    80003e0c:	6161                	addi	sp,sp,80
    80003e0e:	8082                	ret
    ret = (i == n ? n : -1);
    80003e10:	5a7d                	li	s4,-1
    80003e12:	b7d5                	j	80003df6 <filewrite+0xfa>
    panic("filewrite");
    80003e14:	00005517          	auipc	a0,0x5
    80003e18:	82c50513          	addi	a0,a0,-2004 # 80008640 <syscalls+0x270>
    80003e1c:	00002097          	auipc	ra,0x2
    80003e20:	050080e7          	jalr	80(ra) # 80005e6c <panic>
    return -1;
    80003e24:	5a7d                	li	s4,-1
    80003e26:	bfc1                	j	80003df6 <filewrite+0xfa>
      return -1;
    80003e28:	5a7d                	li	s4,-1
    80003e2a:	b7f1                	j	80003df6 <filewrite+0xfa>
    80003e2c:	5a7d                	li	s4,-1
    80003e2e:	b7e1                	j	80003df6 <filewrite+0xfa>

0000000080003e30 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e30:	7179                	addi	sp,sp,-48
    80003e32:	f406                	sd	ra,40(sp)
    80003e34:	f022                	sd	s0,32(sp)
    80003e36:	ec26                	sd	s1,24(sp)
    80003e38:	e84a                	sd	s2,16(sp)
    80003e3a:	e44e                	sd	s3,8(sp)
    80003e3c:	e052                	sd	s4,0(sp)
    80003e3e:	1800                	addi	s0,sp,48
    80003e40:	84aa                	mv	s1,a0
    80003e42:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e44:	0005b023          	sd	zero,0(a1)
    80003e48:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e4c:	00000097          	auipc	ra,0x0
    80003e50:	bf8080e7          	jalr	-1032(ra) # 80003a44 <filealloc>
    80003e54:	e088                	sd	a0,0(s1)
    80003e56:	c551                	beqz	a0,80003ee2 <pipealloc+0xb2>
    80003e58:	00000097          	auipc	ra,0x0
    80003e5c:	bec080e7          	jalr	-1044(ra) # 80003a44 <filealloc>
    80003e60:	00aa3023          	sd	a0,0(s4)
    80003e64:	c92d                	beqz	a0,80003ed6 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e66:	ffffc097          	auipc	ra,0xffffc
    80003e6a:	2b4080e7          	jalr	692(ra) # 8000011a <kalloc>
    80003e6e:	892a                	mv	s2,a0
    80003e70:	c125                	beqz	a0,80003ed0 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e72:	4985                	li	s3,1
    80003e74:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e78:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e7c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e80:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e84:	00004597          	auipc	a1,0x4
    80003e88:	7cc58593          	addi	a1,a1,1996 # 80008650 <syscalls+0x280>
    80003e8c:	00002097          	auipc	ra,0x2
    80003e90:	488080e7          	jalr	1160(ra) # 80006314 <initlock>
  (*f0)->type = FD_PIPE;
    80003e94:	609c                	ld	a5,0(s1)
    80003e96:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e9a:	609c                	ld	a5,0(s1)
    80003e9c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003ea0:	609c                	ld	a5,0(s1)
    80003ea2:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003ea6:	609c                	ld	a5,0(s1)
    80003ea8:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003eac:	000a3783          	ld	a5,0(s4)
    80003eb0:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003eb4:	000a3783          	ld	a5,0(s4)
    80003eb8:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003ebc:	000a3783          	ld	a5,0(s4)
    80003ec0:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003ec4:	000a3783          	ld	a5,0(s4)
    80003ec8:	0127b823          	sd	s2,16(a5)
  return 0;
    80003ecc:	4501                	li	a0,0
    80003ece:	a025                	j	80003ef6 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ed0:	6088                	ld	a0,0(s1)
    80003ed2:	e501                	bnez	a0,80003eda <pipealloc+0xaa>
    80003ed4:	a039                	j	80003ee2 <pipealloc+0xb2>
    80003ed6:	6088                	ld	a0,0(s1)
    80003ed8:	c51d                	beqz	a0,80003f06 <pipealloc+0xd6>
    fileclose(*f0);
    80003eda:	00000097          	auipc	ra,0x0
    80003ede:	c26080e7          	jalr	-986(ra) # 80003b00 <fileclose>
  if(*f1)
    80003ee2:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003ee6:	557d                	li	a0,-1
  if(*f1)
    80003ee8:	c799                	beqz	a5,80003ef6 <pipealloc+0xc6>
    fileclose(*f1);
    80003eea:	853e                	mv	a0,a5
    80003eec:	00000097          	auipc	ra,0x0
    80003ef0:	c14080e7          	jalr	-1004(ra) # 80003b00 <fileclose>
  return -1;
    80003ef4:	557d                	li	a0,-1
}
    80003ef6:	70a2                	ld	ra,40(sp)
    80003ef8:	7402                	ld	s0,32(sp)
    80003efa:	64e2                	ld	s1,24(sp)
    80003efc:	6942                	ld	s2,16(sp)
    80003efe:	69a2                	ld	s3,8(sp)
    80003f00:	6a02                	ld	s4,0(sp)
    80003f02:	6145                	addi	sp,sp,48
    80003f04:	8082                	ret
  return -1;
    80003f06:	557d                	li	a0,-1
    80003f08:	b7fd                	j	80003ef6 <pipealloc+0xc6>

0000000080003f0a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f0a:	1101                	addi	sp,sp,-32
    80003f0c:	ec06                	sd	ra,24(sp)
    80003f0e:	e822                	sd	s0,16(sp)
    80003f10:	e426                	sd	s1,8(sp)
    80003f12:	e04a                	sd	s2,0(sp)
    80003f14:	1000                	addi	s0,sp,32
    80003f16:	84aa                	mv	s1,a0
    80003f18:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f1a:	00002097          	auipc	ra,0x2
    80003f1e:	48a080e7          	jalr	1162(ra) # 800063a4 <acquire>
  if(writable){
    80003f22:	02090d63          	beqz	s2,80003f5c <pipeclose+0x52>
    pi->writeopen = 0;
    80003f26:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f2a:	21848513          	addi	a0,s1,536
    80003f2e:	ffffd097          	auipc	ra,0xffffd
    80003f32:	632080e7          	jalr	1586(ra) # 80001560 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f36:	2204b783          	ld	a5,544(s1)
    80003f3a:	eb95                	bnez	a5,80003f6e <pipeclose+0x64>
    release(&pi->lock);
    80003f3c:	8526                	mv	a0,s1
    80003f3e:	00002097          	auipc	ra,0x2
    80003f42:	51a080e7          	jalr	1306(ra) # 80006458 <release>
    kfree((char*)pi);
    80003f46:	8526                	mv	a0,s1
    80003f48:	ffffc097          	auipc	ra,0xffffc
    80003f4c:	0d4080e7          	jalr	212(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f50:	60e2                	ld	ra,24(sp)
    80003f52:	6442                	ld	s0,16(sp)
    80003f54:	64a2                	ld	s1,8(sp)
    80003f56:	6902                	ld	s2,0(sp)
    80003f58:	6105                	addi	sp,sp,32
    80003f5a:	8082                	ret
    pi->readopen = 0;
    80003f5c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f60:	21c48513          	addi	a0,s1,540
    80003f64:	ffffd097          	auipc	ra,0xffffd
    80003f68:	5fc080e7          	jalr	1532(ra) # 80001560 <wakeup>
    80003f6c:	b7e9                	j	80003f36 <pipeclose+0x2c>
    release(&pi->lock);
    80003f6e:	8526                	mv	a0,s1
    80003f70:	00002097          	auipc	ra,0x2
    80003f74:	4e8080e7          	jalr	1256(ra) # 80006458 <release>
}
    80003f78:	bfe1                	j	80003f50 <pipeclose+0x46>

0000000080003f7a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f7a:	711d                	addi	sp,sp,-96
    80003f7c:	ec86                	sd	ra,88(sp)
    80003f7e:	e8a2                	sd	s0,80(sp)
    80003f80:	e4a6                	sd	s1,72(sp)
    80003f82:	e0ca                	sd	s2,64(sp)
    80003f84:	fc4e                	sd	s3,56(sp)
    80003f86:	f852                	sd	s4,48(sp)
    80003f88:	f456                	sd	s5,40(sp)
    80003f8a:	f05a                	sd	s6,32(sp)
    80003f8c:	ec5e                	sd	s7,24(sp)
    80003f8e:	e862                	sd	s8,16(sp)
    80003f90:	1080                	addi	s0,sp,96
    80003f92:	84aa                	mv	s1,a0
    80003f94:	8aae                	mv	s5,a1
    80003f96:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f98:	ffffd097          	auipc	ra,0xffffd
    80003f9c:	ebc080e7          	jalr	-324(ra) # 80000e54 <myproc>
    80003fa0:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003fa2:	8526                	mv	a0,s1
    80003fa4:	00002097          	auipc	ra,0x2
    80003fa8:	400080e7          	jalr	1024(ra) # 800063a4 <acquire>
  while(i < n){
    80003fac:	0b405663          	blez	s4,80004058 <pipewrite+0xde>
  int i = 0;
    80003fb0:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fb2:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003fb4:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003fb8:	21c48b93          	addi	s7,s1,540
    80003fbc:	a089                	j	80003ffe <pipewrite+0x84>
      release(&pi->lock);
    80003fbe:	8526                	mv	a0,s1
    80003fc0:	00002097          	auipc	ra,0x2
    80003fc4:	498080e7          	jalr	1176(ra) # 80006458 <release>
      return -1;
    80003fc8:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fca:	854a                	mv	a0,s2
    80003fcc:	60e6                	ld	ra,88(sp)
    80003fce:	6446                	ld	s0,80(sp)
    80003fd0:	64a6                	ld	s1,72(sp)
    80003fd2:	6906                	ld	s2,64(sp)
    80003fd4:	79e2                	ld	s3,56(sp)
    80003fd6:	7a42                	ld	s4,48(sp)
    80003fd8:	7aa2                	ld	s5,40(sp)
    80003fda:	7b02                	ld	s6,32(sp)
    80003fdc:	6be2                	ld	s7,24(sp)
    80003fde:	6c42                	ld	s8,16(sp)
    80003fe0:	6125                	addi	sp,sp,96
    80003fe2:	8082                	ret
      wakeup(&pi->nread);
    80003fe4:	8562                	mv	a0,s8
    80003fe6:	ffffd097          	auipc	ra,0xffffd
    80003fea:	57a080e7          	jalr	1402(ra) # 80001560 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003fee:	85a6                	mv	a1,s1
    80003ff0:	855e                	mv	a0,s7
    80003ff2:	ffffd097          	auipc	ra,0xffffd
    80003ff6:	50a080e7          	jalr	1290(ra) # 800014fc <sleep>
  while(i < n){
    80003ffa:	07495063          	bge	s2,s4,8000405a <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003ffe:	2204a783          	lw	a5,544(s1)
    80004002:	dfd5                	beqz	a5,80003fbe <pipewrite+0x44>
    80004004:	854e                	mv	a0,s3
    80004006:	ffffd097          	auipc	ra,0xffffd
    8000400a:	79e080e7          	jalr	1950(ra) # 800017a4 <killed>
    8000400e:	f945                	bnez	a0,80003fbe <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004010:	2184a783          	lw	a5,536(s1)
    80004014:	21c4a703          	lw	a4,540(s1)
    80004018:	2007879b          	addiw	a5,a5,512
    8000401c:	fcf704e3          	beq	a4,a5,80003fe4 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004020:	4685                	li	a3,1
    80004022:	01590633          	add	a2,s2,s5
    80004026:	faf40593          	addi	a1,s0,-81
    8000402a:	0509b503          	ld	a0,80(s3)
    8000402e:	ffffd097          	auipc	ra,0xffffd
    80004032:	b72080e7          	jalr	-1166(ra) # 80000ba0 <copyin>
    80004036:	03650263          	beq	a0,s6,8000405a <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000403a:	21c4a783          	lw	a5,540(s1)
    8000403e:	0017871b          	addiw	a4,a5,1
    80004042:	20e4ae23          	sw	a4,540(s1)
    80004046:	1ff7f793          	andi	a5,a5,511
    8000404a:	97a6                	add	a5,a5,s1
    8000404c:	faf44703          	lbu	a4,-81(s0)
    80004050:	00e78c23          	sb	a4,24(a5)
      i++;
    80004054:	2905                	addiw	s2,s2,1
    80004056:	b755                	j	80003ffa <pipewrite+0x80>
  int i = 0;
    80004058:	4901                	li	s2,0
  wakeup(&pi->nread);
    8000405a:	21848513          	addi	a0,s1,536
    8000405e:	ffffd097          	auipc	ra,0xffffd
    80004062:	502080e7          	jalr	1282(ra) # 80001560 <wakeup>
  release(&pi->lock);
    80004066:	8526                	mv	a0,s1
    80004068:	00002097          	auipc	ra,0x2
    8000406c:	3f0080e7          	jalr	1008(ra) # 80006458 <release>
  return i;
    80004070:	bfa9                	j	80003fca <pipewrite+0x50>

0000000080004072 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004072:	715d                	addi	sp,sp,-80
    80004074:	e486                	sd	ra,72(sp)
    80004076:	e0a2                	sd	s0,64(sp)
    80004078:	fc26                	sd	s1,56(sp)
    8000407a:	f84a                	sd	s2,48(sp)
    8000407c:	f44e                	sd	s3,40(sp)
    8000407e:	f052                	sd	s4,32(sp)
    80004080:	ec56                	sd	s5,24(sp)
    80004082:	e85a                	sd	s6,16(sp)
    80004084:	0880                	addi	s0,sp,80
    80004086:	84aa                	mv	s1,a0
    80004088:	892e                	mv	s2,a1
    8000408a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000408c:	ffffd097          	auipc	ra,0xffffd
    80004090:	dc8080e7          	jalr	-568(ra) # 80000e54 <myproc>
    80004094:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004096:	8526                	mv	a0,s1
    80004098:	00002097          	auipc	ra,0x2
    8000409c:	30c080e7          	jalr	780(ra) # 800063a4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040a0:	2184a703          	lw	a4,536(s1)
    800040a4:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040a8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040ac:	02f71763          	bne	a4,a5,800040da <piperead+0x68>
    800040b0:	2244a783          	lw	a5,548(s1)
    800040b4:	c39d                	beqz	a5,800040da <piperead+0x68>
    if(killed(pr)){
    800040b6:	8552                	mv	a0,s4
    800040b8:	ffffd097          	auipc	ra,0xffffd
    800040bc:	6ec080e7          	jalr	1772(ra) # 800017a4 <killed>
    800040c0:	e949                	bnez	a0,80004152 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040c2:	85a6                	mv	a1,s1
    800040c4:	854e                	mv	a0,s3
    800040c6:	ffffd097          	auipc	ra,0xffffd
    800040ca:	436080e7          	jalr	1078(ra) # 800014fc <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040ce:	2184a703          	lw	a4,536(s1)
    800040d2:	21c4a783          	lw	a5,540(s1)
    800040d6:	fcf70de3          	beq	a4,a5,800040b0 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040da:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040dc:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040de:	05505463          	blez	s5,80004126 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    800040e2:	2184a783          	lw	a5,536(s1)
    800040e6:	21c4a703          	lw	a4,540(s1)
    800040ea:	02f70e63          	beq	a4,a5,80004126 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040ee:	0017871b          	addiw	a4,a5,1
    800040f2:	20e4ac23          	sw	a4,536(s1)
    800040f6:	1ff7f793          	andi	a5,a5,511
    800040fa:	97a6                	add	a5,a5,s1
    800040fc:	0187c783          	lbu	a5,24(a5)
    80004100:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004104:	4685                	li	a3,1
    80004106:	fbf40613          	addi	a2,s0,-65
    8000410a:	85ca                	mv	a1,s2
    8000410c:	050a3503          	ld	a0,80(s4)
    80004110:	ffffd097          	auipc	ra,0xffffd
    80004114:	a04080e7          	jalr	-1532(ra) # 80000b14 <copyout>
    80004118:	01650763          	beq	a0,s6,80004126 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000411c:	2985                	addiw	s3,s3,1
    8000411e:	0905                	addi	s2,s2,1
    80004120:	fd3a91e3          	bne	s5,s3,800040e2 <piperead+0x70>
    80004124:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004126:	21c48513          	addi	a0,s1,540
    8000412a:	ffffd097          	auipc	ra,0xffffd
    8000412e:	436080e7          	jalr	1078(ra) # 80001560 <wakeup>
  release(&pi->lock);
    80004132:	8526                	mv	a0,s1
    80004134:	00002097          	auipc	ra,0x2
    80004138:	324080e7          	jalr	804(ra) # 80006458 <release>
  return i;
}
    8000413c:	854e                	mv	a0,s3
    8000413e:	60a6                	ld	ra,72(sp)
    80004140:	6406                	ld	s0,64(sp)
    80004142:	74e2                	ld	s1,56(sp)
    80004144:	7942                	ld	s2,48(sp)
    80004146:	79a2                	ld	s3,40(sp)
    80004148:	7a02                	ld	s4,32(sp)
    8000414a:	6ae2                	ld	s5,24(sp)
    8000414c:	6b42                	ld	s6,16(sp)
    8000414e:	6161                	addi	sp,sp,80
    80004150:	8082                	ret
      release(&pi->lock);
    80004152:	8526                	mv	a0,s1
    80004154:	00002097          	auipc	ra,0x2
    80004158:	304080e7          	jalr	772(ra) # 80006458 <release>
      return -1;
    8000415c:	59fd                	li	s3,-1
    8000415e:	bff9                	j	8000413c <piperead+0xca>

0000000080004160 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004160:	1141                	addi	sp,sp,-16
    80004162:	e422                	sd	s0,8(sp)
    80004164:	0800                	addi	s0,sp,16
    80004166:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004168:	8905                	andi	a0,a0,1
    8000416a:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000416c:	8b89                	andi	a5,a5,2
    8000416e:	c399                	beqz	a5,80004174 <flags2perm+0x14>
      perm |= PTE_W;
    80004170:	00456513          	ori	a0,a0,4
    return perm;
}
    80004174:	6422                	ld	s0,8(sp)
    80004176:	0141                	addi	sp,sp,16
    80004178:	8082                	ret

000000008000417a <exec>:

int
exec(char *path, char **argv)
{
    8000417a:	de010113          	addi	sp,sp,-544
    8000417e:	20113c23          	sd	ra,536(sp)
    80004182:	20813823          	sd	s0,528(sp)
    80004186:	20913423          	sd	s1,520(sp)
    8000418a:	21213023          	sd	s2,512(sp)
    8000418e:	ffce                	sd	s3,504(sp)
    80004190:	fbd2                	sd	s4,496(sp)
    80004192:	f7d6                	sd	s5,488(sp)
    80004194:	f3da                	sd	s6,480(sp)
    80004196:	efde                	sd	s7,472(sp)
    80004198:	ebe2                	sd	s8,464(sp)
    8000419a:	e7e6                	sd	s9,456(sp)
    8000419c:	e3ea                	sd	s10,448(sp)
    8000419e:	ff6e                	sd	s11,440(sp)
    800041a0:	1400                	addi	s0,sp,544
    800041a2:	892a                	mv	s2,a0
    800041a4:	dea43423          	sd	a0,-536(s0)
    800041a8:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041ac:	ffffd097          	auipc	ra,0xffffd
    800041b0:	ca8080e7          	jalr	-856(ra) # 80000e54 <myproc>
    800041b4:	84aa                	mv	s1,a0

  begin_op();
    800041b6:	fffff097          	auipc	ra,0xfffff
    800041ba:	482080e7          	jalr	1154(ra) # 80003638 <begin_op>

  if((ip = namei(path)) == 0){
    800041be:	854a                	mv	a0,s2
    800041c0:	fffff097          	auipc	ra,0xfffff
    800041c4:	258080e7          	jalr	600(ra) # 80003418 <namei>
    800041c8:	c93d                	beqz	a0,8000423e <exec+0xc4>
    800041ca:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041cc:	fffff097          	auipc	ra,0xfffff
    800041d0:	9f8080e7          	jalr	-1544(ra) # 80002bc4 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041d4:	04000713          	li	a4,64
    800041d8:	4681                	li	a3,0
    800041da:	e5040613          	addi	a2,s0,-432
    800041de:	4581                	li	a1,0
    800041e0:	8556                	mv	a0,s5
    800041e2:	fffff097          	auipc	ra,0xfffff
    800041e6:	d3c080e7          	jalr	-708(ra) # 80002f1e <readi>
    800041ea:	04000793          	li	a5,64
    800041ee:	00f51a63          	bne	a0,a5,80004202 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800041f2:	e5042703          	lw	a4,-432(s0)
    800041f6:	464c47b7          	lui	a5,0x464c4
    800041fa:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041fe:	04f70663          	beq	a4,a5,8000424a <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004202:	8556                	mv	a0,s5
    80004204:	fffff097          	auipc	ra,0xfffff
    80004208:	cc8080e7          	jalr	-824(ra) # 80002ecc <iunlockput>
    end_op();
    8000420c:	fffff097          	auipc	ra,0xfffff
    80004210:	4aa080e7          	jalr	1194(ra) # 800036b6 <end_op>
  }
  return -1;
    80004214:	557d                	li	a0,-1
}
    80004216:	21813083          	ld	ra,536(sp)
    8000421a:	21013403          	ld	s0,528(sp)
    8000421e:	20813483          	ld	s1,520(sp)
    80004222:	20013903          	ld	s2,512(sp)
    80004226:	79fe                	ld	s3,504(sp)
    80004228:	7a5e                	ld	s4,496(sp)
    8000422a:	7abe                	ld	s5,488(sp)
    8000422c:	7b1e                	ld	s6,480(sp)
    8000422e:	6bfe                	ld	s7,472(sp)
    80004230:	6c5e                	ld	s8,464(sp)
    80004232:	6cbe                	ld	s9,456(sp)
    80004234:	6d1e                	ld	s10,448(sp)
    80004236:	7dfa                	ld	s11,440(sp)
    80004238:	22010113          	addi	sp,sp,544
    8000423c:	8082                	ret
    end_op();
    8000423e:	fffff097          	auipc	ra,0xfffff
    80004242:	478080e7          	jalr	1144(ra) # 800036b6 <end_op>
    return -1;
    80004246:	557d                	li	a0,-1
    80004248:	b7f9                	j	80004216 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    8000424a:	8526                	mv	a0,s1
    8000424c:	ffffd097          	auipc	ra,0xffffd
    80004250:	ccc080e7          	jalr	-820(ra) # 80000f18 <proc_pagetable>
    80004254:	8b2a                	mv	s6,a0
    80004256:	d555                	beqz	a0,80004202 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004258:	e7042783          	lw	a5,-400(s0)
    8000425c:	e8845703          	lhu	a4,-376(s0)
    80004260:	c735                	beqz	a4,800042cc <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004262:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004264:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004268:	6a05                	lui	s4,0x1
    8000426a:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000426e:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004272:	6d85                	lui	s11,0x1
    80004274:	7d7d                	lui	s10,0xfffff
    80004276:	ac3d                	j	800044b4 <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004278:	00004517          	auipc	a0,0x4
    8000427c:	3e050513          	addi	a0,a0,992 # 80008658 <syscalls+0x288>
    80004280:	00002097          	auipc	ra,0x2
    80004284:	bec080e7          	jalr	-1044(ra) # 80005e6c <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004288:	874a                	mv	a4,s2
    8000428a:	009c86bb          	addw	a3,s9,s1
    8000428e:	4581                	li	a1,0
    80004290:	8556                	mv	a0,s5
    80004292:	fffff097          	auipc	ra,0xfffff
    80004296:	c8c080e7          	jalr	-884(ra) # 80002f1e <readi>
    8000429a:	2501                	sext.w	a0,a0
    8000429c:	1aa91963          	bne	s2,a0,8000444e <exec+0x2d4>
  for(i = 0; i < sz; i += PGSIZE){
    800042a0:	009d84bb          	addw	s1,s11,s1
    800042a4:	013d09bb          	addw	s3,s10,s3
    800042a8:	1f74f663          	bgeu	s1,s7,80004494 <exec+0x31a>
    pa = walkaddr(pagetable, va + i);
    800042ac:	02049593          	slli	a1,s1,0x20
    800042b0:	9181                	srli	a1,a1,0x20
    800042b2:	95e2                	add	a1,a1,s8
    800042b4:	855a                	mv	a0,s6
    800042b6:	ffffc097          	auipc	ra,0xffffc
    800042ba:	24e080e7          	jalr	590(ra) # 80000504 <walkaddr>
    800042be:	862a                	mv	a2,a0
    if(pa == 0)
    800042c0:	dd45                	beqz	a0,80004278 <exec+0xfe>
      n = PGSIZE;
    800042c2:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800042c4:	fd49f2e3          	bgeu	s3,s4,80004288 <exec+0x10e>
      n = sz - i;
    800042c8:	894e                	mv	s2,s3
    800042ca:	bf7d                	j	80004288 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042cc:	4901                	li	s2,0
  iunlockput(ip);
    800042ce:	8556                	mv	a0,s5
    800042d0:	fffff097          	auipc	ra,0xfffff
    800042d4:	bfc080e7          	jalr	-1028(ra) # 80002ecc <iunlockput>
  end_op();
    800042d8:	fffff097          	auipc	ra,0xfffff
    800042dc:	3de080e7          	jalr	990(ra) # 800036b6 <end_op>
  p = myproc();
    800042e0:	ffffd097          	auipc	ra,0xffffd
    800042e4:	b74080e7          	jalr	-1164(ra) # 80000e54 <myproc>
    800042e8:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800042ea:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800042ee:	6785                	lui	a5,0x1
    800042f0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800042f2:	97ca                	add	a5,a5,s2
    800042f4:	777d                	lui	a4,0xfffff
    800042f6:	8ff9                	and	a5,a5,a4
    800042f8:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800042fc:	4691                	li	a3,4
    800042fe:	6609                	lui	a2,0x2
    80004300:	963e                	add	a2,a2,a5
    80004302:	85be                	mv	a1,a5
    80004304:	855a                	mv	a0,s6
    80004306:	ffffc097          	auipc	ra,0xffffc
    8000430a:	5b2080e7          	jalr	1458(ra) # 800008b8 <uvmalloc>
    8000430e:	8c2a                	mv	s8,a0
  ip = 0;
    80004310:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004312:	12050e63          	beqz	a0,8000444e <exec+0x2d4>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004316:	75f9                	lui	a1,0xffffe
    80004318:	95aa                	add	a1,a1,a0
    8000431a:	855a                	mv	a0,s6
    8000431c:	ffffc097          	auipc	ra,0xffffc
    80004320:	7c6080e7          	jalr	1990(ra) # 80000ae2 <uvmclear>
  stackbase = sp - PGSIZE;
    80004324:	7afd                	lui	s5,0xfffff
    80004326:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004328:	df043783          	ld	a5,-528(s0)
    8000432c:	6388                	ld	a0,0(a5)
    8000432e:	c925                	beqz	a0,8000439e <exec+0x224>
    80004330:	e9040993          	addi	s3,s0,-368
    80004334:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004338:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000433a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000433c:	ffffc097          	auipc	ra,0xffffc
    80004340:	fba080e7          	jalr	-70(ra) # 800002f6 <strlen>
    80004344:	0015079b          	addiw	a5,a0,1
    80004348:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000434c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004350:	13596663          	bltu	s2,s5,8000447c <exec+0x302>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004354:	df043d83          	ld	s11,-528(s0)
    80004358:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    8000435c:	8552                	mv	a0,s4
    8000435e:	ffffc097          	auipc	ra,0xffffc
    80004362:	f98080e7          	jalr	-104(ra) # 800002f6 <strlen>
    80004366:	0015069b          	addiw	a3,a0,1
    8000436a:	8652                	mv	a2,s4
    8000436c:	85ca                	mv	a1,s2
    8000436e:	855a                	mv	a0,s6
    80004370:	ffffc097          	auipc	ra,0xffffc
    80004374:	7a4080e7          	jalr	1956(ra) # 80000b14 <copyout>
    80004378:	10054663          	bltz	a0,80004484 <exec+0x30a>
    ustack[argc] = sp;
    8000437c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004380:	0485                	addi	s1,s1,1
    80004382:	008d8793          	addi	a5,s11,8
    80004386:	def43823          	sd	a5,-528(s0)
    8000438a:	008db503          	ld	a0,8(s11)
    8000438e:	c911                	beqz	a0,800043a2 <exec+0x228>
    if(argc >= MAXARG)
    80004390:	09a1                	addi	s3,s3,8
    80004392:	fb3c95e3          	bne	s9,s3,8000433c <exec+0x1c2>
  sz = sz1;
    80004396:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000439a:	4a81                	li	s5,0
    8000439c:	a84d                	j	8000444e <exec+0x2d4>
  sp = sz;
    8000439e:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800043a0:	4481                	li	s1,0
  ustack[argc] = 0;
    800043a2:	00349793          	slli	a5,s1,0x3
    800043a6:	f9078793          	addi	a5,a5,-112
    800043aa:	97a2                	add	a5,a5,s0
    800043ac:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800043b0:	00148693          	addi	a3,s1,1
    800043b4:	068e                	slli	a3,a3,0x3
    800043b6:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043ba:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800043be:	01597663          	bgeu	s2,s5,800043ca <exec+0x250>
  sz = sz1;
    800043c2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043c6:	4a81                	li	s5,0
    800043c8:	a059                	j	8000444e <exec+0x2d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043ca:	e9040613          	addi	a2,s0,-368
    800043ce:	85ca                	mv	a1,s2
    800043d0:	855a                	mv	a0,s6
    800043d2:	ffffc097          	auipc	ra,0xffffc
    800043d6:	742080e7          	jalr	1858(ra) # 80000b14 <copyout>
    800043da:	0a054963          	bltz	a0,8000448c <exec+0x312>
  p->trapframe->a1 = sp;
    800043de:	058bb783          	ld	a5,88(s7)
    800043e2:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043e6:	de843783          	ld	a5,-536(s0)
    800043ea:	0007c703          	lbu	a4,0(a5)
    800043ee:	cf11                	beqz	a4,8000440a <exec+0x290>
    800043f0:	0785                	addi	a5,a5,1
    if(*s == '/')
    800043f2:	02f00693          	li	a3,47
    800043f6:	a039                	j	80004404 <exec+0x28a>
      last = s+1;
    800043f8:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800043fc:	0785                	addi	a5,a5,1
    800043fe:	fff7c703          	lbu	a4,-1(a5)
    80004402:	c701                	beqz	a4,8000440a <exec+0x290>
    if(*s == '/')
    80004404:	fed71ce3          	bne	a4,a3,800043fc <exec+0x282>
    80004408:	bfc5                	j	800043f8 <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    8000440a:	4641                	li	a2,16
    8000440c:	de843583          	ld	a1,-536(s0)
    80004410:	158b8513          	addi	a0,s7,344
    80004414:	ffffc097          	auipc	ra,0xffffc
    80004418:	eb0080e7          	jalr	-336(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    8000441c:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004420:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004424:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004428:	058bb783          	ld	a5,88(s7)
    8000442c:	e6843703          	ld	a4,-408(s0)
    80004430:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004432:	058bb783          	ld	a5,88(s7)
    80004436:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000443a:	85ea                	mv	a1,s10
    8000443c:	ffffd097          	auipc	ra,0xffffd
    80004440:	b78080e7          	jalr	-1160(ra) # 80000fb4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004444:	0004851b          	sext.w	a0,s1
    80004448:	b3f9                	j	80004216 <exec+0x9c>
    8000444a:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000444e:	df843583          	ld	a1,-520(s0)
    80004452:	855a                	mv	a0,s6
    80004454:	ffffd097          	auipc	ra,0xffffd
    80004458:	b60080e7          	jalr	-1184(ra) # 80000fb4 <proc_freepagetable>
  if(ip){
    8000445c:	da0a93e3          	bnez	s5,80004202 <exec+0x88>
  return -1;
    80004460:	557d                	li	a0,-1
    80004462:	bb55                	j	80004216 <exec+0x9c>
    80004464:	df243c23          	sd	s2,-520(s0)
    80004468:	b7dd                	j	8000444e <exec+0x2d4>
    8000446a:	df243c23          	sd	s2,-520(s0)
    8000446e:	b7c5                	j	8000444e <exec+0x2d4>
    80004470:	df243c23          	sd	s2,-520(s0)
    80004474:	bfe9                	j	8000444e <exec+0x2d4>
    80004476:	df243c23          	sd	s2,-520(s0)
    8000447a:	bfd1                	j	8000444e <exec+0x2d4>
  sz = sz1;
    8000447c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004480:	4a81                	li	s5,0
    80004482:	b7f1                	j	8000444e <exec+0x2d4>
  sz = sz1;
    80004484:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004488:	4a81                	li	s5,0
    8000448a:	b7d1                	j	8000444e <exec+0x2d4>
  sz = sz1;
    8000448c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004490:	4a81                	li	s5,0
    80004492:	bf75                	j	8000444e <exec+0x2d4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004494:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004498:	e0843783          	ld	a5,-504(s0)
    8000449c:	0017869b          	addiw	a3,a5,1
    800044a0:	e0d43423          	sd	a3,-504(s0)
    800044a4:	e0043783          	ld	a5,-512(s0)
    800044a8:	0387879b          	addiw	a5,a5,56
    800044ac:	e8845703          	lhu	a4,-376(s0)
    800044b0:	e0e6dfe3          	bge	a3,a4,800042ce <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044b4:	2781                	sext.w	a5,a5
    800044b6:	e0f43023          	sd	a5,-512(s0)
    800044ba:	03800713          	li	a4,56
    800044be:	86be                	mv	a3,a5
    800044c0:	e1840613          	addi	a2,s0,-488
    800044c4:	4581                	li	a1,0
    800044c6:	8556                	mv	a0,s5
    800044c8:	fffff097          	auipc	ra,0xfffff
    800044cc:	a56080e7          	jalr	-1450(ra) # 80002f1e <readi>
    800044d0:	03800793          	li	a5,56
    800044d4:	f6f51be3          	bne	a0,a5,8000444a <exec+0x2d0>
    if(ph.type != ELF_PROG_LOAD)
    800044d8:	e1842783          	lw	a5,-488(s0)
    800044dc:	4705                	li	a4,1
    800044de:	fae79de3          	bne	a5,a4,80004498 <exec+0x31e>
    if(ph.memsz < ph.filesz)
    800044e2:	e4043483          	ld	s1,-448(s0)
    800044e6:	e3843783          	ld	a5,-456(s0)
    800044ea:	f6f4ede3          	bltu	s1,a5,80004464 <exec+0x2ea>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800044ee:	e2843783          	ld	a5,-472(s0)
    800044f2:	94be                	add	s1,s1,a5
    800044f4:	f6f4ebe3          	bltu	s1,a5,8000446a <exec+0x2f0>
    if(ph.vaddr % PGSIZE != 0)
    800044f8:	de043703          	ld	a4,-544(s0)
    800044fc:	8ff9                	and	a5,a5,a4
    800044fe:	fbad                	bnez	a5,80004470 <exec+0x2f6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004500:	e1c42503          	lw	a0,-484(s0)
    80004504:	00000097          	auipc	ra,0x0
    80004508:	c5c080e7          	jalr	-932(ra) # 80004160 <flags2perm>
    8000450c:	86aa                	mv	a3,a0
    8000450e:	8626                	mv	a2,s1
    80004510:	85ca                	mv	a1,s2
    80004512:	855a                	mv	a0,s6
    80004514:	ffffc097          	auipc	ra,0xffffc
    80004518:	3a4080e7          	jalr	932(ra) # 800008b8 <uvmalloc>
    8000451c:	dea43c23          	sd	a0,-520(s0)
    80004520:	d939                	beqz	a0,80004476 <exec+0x2fc>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004522:	e2843c03          	ld	s8,-472(s0)
    80004526:	e2042c83          	lw	s9,-480(s0)
    8000452a:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000452e:	f60b83e3          	beqz	s7,80004494 <exec+0x31a>
    80004532:	89de                	mv	s3,s7
    80004534:	4481                	li	s1,0
    80004536:	bb9d                	j	800042ac <exec+0x132>

0000000080004538 <argfd>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int argfd(int n, int *pfd, struct file **pf)
{
    80004538:	7179                	addi	sp,sp,-48
    8000453a:	f406                	sd	ra,40(sp)
    8000453c:	f022                	sd	s0,32(sp)
    8000453e:	ec26                	sd	s1,24(sp)
    80004540:	e84a                	sd	s2,16(sp)
    80004542:	1800                	addi	s0,sp,48
    80004544:	892e                	mv	s2,a1
    80004546:	84b2                	mv	s1,a2
    int fd;
    struct file *f;

    argint(n, &fd);
    80004548:	fdc40593          	addi	a1,s0,-36
    8000454c:	ffffe097          	auipc	ra,0xffffe
    80004550:	a1e080e7          	jalr	-1506(ra) # 80001f6a <argint>
    if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80004554:	fdc42703          	lw	a4,-36(s0)
    80004558:	47bd                	li	a5,15
    8000455a:	02e7eb63          	bltu	a5,a4,80004590 <argfd+0x58>
    8000455e:	ffffd097          	auipc	ra,0xffffd
    80004562:	8f6080e7          	jalr	-1802(ra) # 80000e54 <myproc>
    80004566:	fdc42703          	lw	a4,-36(s0)
    8000456a:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffe1eaa>
    8000456e:	078e                	slli	a5,a5,0x3
    80004570:	953e                	add	a0,a0,a5
    80004572:	611c                	ld	a5,0(a0)
    80004574:	c385                	beqz	a5,80004594 <argfd+0x5c>
        return -1;
    if (pfd)
    80004576:	00090463          	beqz	s2,8000457e <argfd+0x46>
        *pfd = fd;
    8000457a:	00e92023          	sw	a4,0(s2)
    if (pf)
        *pf = f;
    return 0;
    8000457e:	4501                	li	a0,0
    if (pf)
    80004580:	c091                	beqz	s1,80004584 <argfd+0x4c>
        *pf = f;
    80004582:	e09c                	sd	a5,0(s1)
}
    80004584:	70a2                	ld	ra,40(sp)
    80004586:	7402                	ld	s0,32(sp)
    80004588:	64e2                	ld	s1,24(sp)
    8000458a:	6942                	ld	s2,16(sp)
    8000458c:	6145                	addi	sp,sp,48
    8000458e:	8082                	ret
        return -1;
    80004590:	557d                	li	a0,-1
    80004592:	bfcd                	j	80004584 <argfd+0x4c>
    80004594:	557d                	li	a0,-1
    80004596:	b7fd                	j	80004584 <argfd+0x4c>

0000000080004598 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int fdalloc(struct file *f)
{
    80004598:	1101                	addi	sp,sp,-32
    8000459a:	ec06                	sd	ra,24(sp)
    8000459c:	e822                	sd	s0,16(sp)
    8000459e:	e426                	sd	s1,8(sp)
    800045a0:	1000                	addi	s0,sp,32
    800045a2:	84aa                	mv	s1,a0
    int fd;
    struct proc *p = myproc();
    800045a4:	ffffd097          	auipc	ra,0xffffd
    800045a8:	8b0080e7          	jalr	-1872(ra) # 80000e54 <myproc>
    800045ac:	862a                	mv	a2,a0

    for (fd = 0; fd < NOFILE; fd++) {
    800045ae:	0d050793          	addi	a5,a0,208
    800045b2:	4501                	li	a0,0
    800045b4:	46c1                	li	a3,16
        if (p->ofile[fd] == 0) {
    800045b6:	6398                	ld	a4,0(a5)
    800045b8:	cb19                	beqz	a4,800045ce <fdalloc+0x36>
    for (fd = 0; fd < NOFILE; fd++) {
    800045ba:	2505                	addiw	a0,a0,1
    800045bc:	07a1                	addi	a5,a5,8
    800045be:	fed51ce3          	bne	a0,a3,800045b6 <fdalloc+0x1e>
            p->ofile[fd] = f;
            return fd;
        }
    }
    return -1;
    800045c2:	557d                	li	a0,-1
}
    800045c4:	60e2                	ld	ra,24(sp)
    800045c6:	6442                	ld	s0,16(sp)
    800045c8:	64a2                	ld	s1,8(sp)
    800045ca:	6105                	addi	sp,sp,32
    800045cc:	8082                	ret
            p->ofile[fd] = f;
    800045ce:	01a50793          	addi	a5,a0,26
    800045d2:	078e                	slli	a5,a5,0x3
    800045d4:	963e                	add	a2,a2,a5
    800045d6:	e204                	sd	s1,0(a2)
            return fd;
    800045d8:	b7f5                	j	800045c4 <fdalloc+0x2c>

00000000800045da <create>:
    end_op();
    return -1;
}

static struct inode *create(char *path, short type, short major, short minor)
{
    800045da:	715d                	addi	sp,sp,-80
    800045dc:	e486                	sd	ra,72(sp)
    800045de:	e0a2                	sd	s0,64(sp)
    800045e0:	fc26                	sd	s1,56(sp)
    800045e2:	f84a                	sd	s2,48(sp)
    800045e4:	f44e                	sd	s3,40(sp)
    800045e6:	f052                	sd	s4,32(sp)
    800045e8:	ec56                	sd	s5,24(sp)
    800045ea:	e85a                	sd	s6,16(sp)
    800045ec:	0880                	addi	s0,sp,80
    800045ee:	8b2e                	mv	s6,a1
    800045f0:	89b2                	mv	s3,a2
    800045f2:	8936                	mv	s2,a3
    struct inode *ip, *dp;
    char name[DIRSIZ];

    if ((dp = nameiparent(path, name)) == 0)
    800045f4:	fb040593          	addi	a1,s0,-80
    800045f8:	fffff097          	auipc	ra,0xfffff
    800045fc:	e3e080e7          	jalr	-450(ra) # 80003436 <nameiparent>
    80004600:	84aa                	mv	s1,a0
    80004602:	14050f63          	beqz	a0,80004760 <create+0x186>
        return 0;

    ilock(dp);
    80004606:	ffffe097          	auipc	ra,0xffffe
    8000460a:	5be080e7          	jalr	1470(ra) # 80002bc4 <ilock>

    if ((ip = dirlookup(dp, name, 0)) != 0) {
    8000460e:	4601                	li	a2,0
    80004610:	fb040593          	addi	a1,s0,-80
    80004614:	8526                	mv	a0,s1
    80004616:	fffff097          	auipc	ra,0xfffff
    8000461a:	b3a080e7          	jalr	-1222(ra) # 80003150 <dirlookup>
    8000461e:	8aaa                	mv	s5,a0
    80004620:	c931                	beqz	a0,80004674 <create+0x9a>
        iunlockput(dp);
    80004622:	8526                	mv	a0,s1
    80004624:	fffff097          	auipc	ra,0xfffff
    80004628:	8a8080e7          	jalr	-1880(ra) # 80002ecc <iunlockput>
        ilock(ip);
    8000462c:	8556                	mv	a0,s5
    8000462e:	ffffe097          	auipc	ra,0xffffe
    80004632:	596080e7          	jalr	1430(ra) # 80002bc4 <ilock>
        if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004636:	000b059b          	sext.w	a1,s6
    8000463a:	4789                	li	a5,2
    8000463c:	02f59563          	bne	a1,a5,80004666 <create+0x8c>
    80004640:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffe1ed4>
    80004644:	37f9                	addiw	a5,a5,-2
    80004646:	17c2                	slli	a5,a5,0x30
    80004648:	93c1                	srli	a5,a5,0x30
    8000464a:	4705                	li	a4,1
    8000464c:	00f76d63          	bltu	a4,a5,80004666 <create+0x8c>
    ip->nlink = 0;
    iupdate(ip);
    iunlockput(ip);
    iunlockput(dp);
    return 0;
}
    80004650:	8556                	mv	a0,s5
    80004652:	60a6                	ld	ra,72(sp)
    80004654:	6406                	ld	s0,64(sp)
    80004656:	74e2                	ld	s1,56(sp)
    80004658:	7942                	ld	s2,48(sp)
    8000465a:	79a2                	ld	s3,40(sp)
    8000465c:	7a02                	ld	s4,32(sp)
    8000465e:	6ae2                	ld	s5,24(sp)
    80004660:	6b42                	ld	s6,16(sp)
    80004662:	6161                	addi	sp,sp,80
    80004664:	8082                	ret
        iunlockput(ip);
    80004666:	8556                	mv	a0,s5
    80004668:	fffff097          	auipc	ra,0xfffff
    8000466c:	864080e7          	jalr	-1948(ra) # 80002ecc <iunlockput>
        return 0;
    80004670:	4a81                	li	s5,0
    80004672:	bff9                	j	80004650 <create+0x76>
    if ((ip = ialloc(dp->dev, type)) == 0) {
    80004674:	85da                	mv	a1,s6
    80004676:	4088                	lw	a0,0(s1)
    80004678:	ffffe097          	auipc	ra,0xffffe
    8000467c:	3ae080e7          	jalr	942(ra) # 80002a26 <ialloc>
    80004680:	8a2a                	mv	s4,a0
    80004682:	c539                	beqz	a0,800046d0 <create+0xf6>
    ilock(ip);
    80004684:	ffffe097          	auipc	ra,0xffffe
    80004688:	540080e7          	jalr	1344(ra) # 80002bc4 <ilock>
    ip->major = major;
    8000468c:	053a1323          	sh	s3,70(s4)
    ip->minor = minor;
    80004690:	052a1423          	sh	s2,72(s4)
    ip->nlink = 1;
    80004694:	4905                	li	s2,1
    80004696:	052a1523          	sh	s2,74(s4)
    iupdate(ip);
    8000469a:	8552                	mv	a0,s4
    8000469c:	ffffe097          	auipc	ra,0xffffe
    800046a0:	45c080e7          	jalr	1116(ra) # 80002af8 <iupdate>
    if (type == T_DIR) { // Create . and .. entries.
    800046a4:	000b059b          	sext.w	a1,s6
    800046a8:	03258b63          	beq	a1,s2,800046de <create+0x104>
    if (dirlink(dp, name, ip->inum) < 0)
    800046ac:	004a2603          	lw	a2,4(s4)
    800046b0:	fb040593          	addi	a1,s0,-80
    800046b4:	8526                	mv	a0,s1
    800046b6:	fffff097          	auipc	ra,0xfffff
    800046ba:	cb0080e7          	jalr	-848(ra) # 80003366 <dirlink>
    800046be:	06054f63          	bltz	a0,8000473c <create+0x162>
    iunlockput(dp);
    800046c2:	8526                	mv	a0,s1
    800046c4:	fffff097          	auipc	ra,0xfffff
    800046c8:	808080e7          	jalr	-2040(ra) # 80002ecc <iunlockput>
    return ip;
    800046cc:	8ad2                	mv	s5,s4
    800046ce:	b749                	j	80004650 <create+0x76>
        iunlockput(dp);
    800046d0:	8526                	mv	a0,s1
    800046d2:	ffffe097          	auipc	ra,0xffffe
    800046d6:	7fa080e7          	jalr	2042(ra) # 80002ecc <iunlockput>
        return 0;
    800046da:	8ad2                	mv	s5,s4
    800046dc:	bf95                	j	80004650 <create+0x76>
        if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046de:	004a2603          	lw	a2,4(s4)
    800046e2:	00004597          	auipc	a1,0x4
    800046e6:	f9658593          	addi	a1,a1,-106 # 80008678 <syscalls+0x2a8>
    800046ea:	8552                	mv	a0,s4
    800046ec:	fffff097          	auipc	ra,0xfffff
    800046f0:	c7a080e7          	jalr	-902(ra) # 80003366 <dirlink>
    800046f4:	04054463          	bltz	a0,8000473c <create+0x162>
    800046f8:	40d0                	lw	a2,4(s1)
    800046fa:	00004597          	auipc	a1,0x4
    800046fe:	f8658593          	addi	a1,a1,-122 # 80008680 <syscalls+0x2b0>
    80004702:	8552                	mv	a0,s4
    80004704:	fffff097          	auipc	ra,0xfffff
    80004708:	c62080e7          	jalr	-926(ra) # 80003366 <dirlink>
    8000470c:	02054863          	bltz	a0,8000473c <create+0x162>
    if (dirlink(dp, name, ip->inum) < 0)
    80004710:	004a2603          	lw	a2,4(s4)
    80004714:	fb040593          	addi	a1,s0,-80
    80004718:	8526                	mv	a0,s1
    8000471a:	fffff097          	auipc	ra,0xfffff
    8000471e:	c4c080e7          	jalr	-948(ra) # 80003366 <dirlink>
    80004722:	00054d63          	bltz	a0,8000473c <create+0x162>
        dp->nlink++; // for ".."
    80004726:	04a4d783          	lhu	a5,74(s1)
    8000472a:	2785                	addiw	a5,a5,1
    8000472c:	04f49523          	sh	a5,74(s1)
        iupdate(dp);
    80004730:	8526                	mv	a0,s1
    80004732:	ffffe097          	auipc	ra,0xffffe
    80004736:	3c6080e7          	jalr	966(ra) # 80002af8 <iupdate>
    8000473a:	b761                	j	800046c2 <create+0xe8>
    ip->nlink = 0;
    8000473c:	040a1523          	sh	zero,74(s4)
    iupdate(ip);
    80004740:	8552                	mv	a0,s4
    80004742:	ffffe097          	auipc	ra,0xffffe
    80004746:	3b6080e7          	jalr	950(ra) # 80002af8 <iupdate>
    iunlockput(ip);
    8000474a:	8552                	mv	a0,s4
    8000474c:	ffffe097          	auipc	ra,0xffffe
    80004750:	780080e7          	jalr	1920(ra) # 80002ecc <iunlockput>
    iunlockput(dp);
    80004754:	8526                	mv	a0,s1
    80004756:	ffffe097          	auipc	ra,0xffffe
    8000475a:	776080e7          	jalr	1910(ra) # 80002ecc <iunlockput>
    return 0;
    8000475e:	bdcd                	j	80004650 <create+0x76>
        return 0;
    80004760:	8aaa                	mv	s5,a0
    80004762:	b5fd                	j	80004650 <create+0x76>

0000000080004764 <sys_dup>:
{
    80004764:	7179                	addi	sp,sp,-48
    80004766:	f406                	sd	ra,40(sp)
    80004768:	f022                	sd	s0,32(sp)
    8000476a:	ec26                	sd	s1,24(sp)
    8000476c:	e84a                	sd	s2,16(sp)
    8000476e:	1800                	addi	s0,sp,48
    if (argfd(0, 0, &f) < 0)
    80004770:	fd840613          	addi	a2,s0,-40
    80004774:	4581                	li	a1,0
    80004776:	4501                	li	a0,0
    80004778:	00000097          	auipc	ra,0x0
    8000477c:	dc0080e7          	jalr	-576(ra) # 80004538 <argfd>
        return -1;
    80004780:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0)
    80004782:	02054363          	bltz	a0,800047a8 <sys_dup+0x44>
    if ((fd = fdalloc(f)) < 0)
    80004786:	fd843903          	ld	s2,-40(s0)
    8000478a:	854a                	mv	a0,s2
    8000478c:	00000097          	auipc	ra,0x0
    80004790:	e0c080e7          	jalr	-500(ra) # 80004598 <fdalloc>
    80004794:	84aa                	mv	s1,a0
        return -1;
    80004796:	57fd                	li	a5,-1
    if ((fd = fdalloc(f)) < 0)
    80004798:	00054863          	bltz	a0,800047a8 <sys_dup+0x44>
    filedup(f);
    8000479c:	854a                	mv	a0,s2
    8000479e:	fffff097          	auipc	ra,0xfffff
    800047a2:	310080e7          	jalr	784(ra) # 80003aae <filedup>
    return fd;
    800047a6:	87a6                	mv	a5,s1
}
    800047a8:	853e                	mv	a0,a5
    800047aa:	70a2                	ld	ra,40(sp)
    800047ac:	7402                	ld	s0,32(sp)
    800047ae:	64e2                	ld	s1,24(sp)
    800047b0:	6942                	ld	s2,16(sp)
    800047b2:	6145                	addi	sp,sp,48
    800047b4:	8082                	ret

00000000800047b6 <sys_read>:
{
    800047b6:	7179                	addi	sp,sp,-48
    800047b8:	f406                	sd	ra,40(sp)
    800047ba:	f022                	sd	s0,32(sp)
    800047bc:	1800                	addi	s0,sp,48
    argaddr(1, &p);
    800047be:	fd840593          	addi	a1,s0,-40
    800047c2:	4505                	li	a0,1
    800047c4:	ffffd097          	auipc	ra,0xffffd
    800047c8:	7c6080e7          	jalr	1990(ra) # 80001f8a <argaddr>
    argint(2, &n);
    800047cc:	fe440593          	addi	a1,s0,-28
    800047d0:	4509                	li	a0,2
    800047d2:	ffffd097          	auipc	ra,0xffffd
    800047d6:	798080e7          	jalr	1944(ra) # 80001f6a <argint>
    if (argfd(0, 0, &f) < 0)
    800047da:	fe840613          	addi	a2,s0,-24
    800047de:	4581                	li	a1,0
    800047e0:	4501                	li	a0,0
    800047e2:	00000097          	auipc	ra,0x0
    800047e6:	d56080e7          	jalr	-682(ra) # 80004538 <argfd>
    800047ea:	87aa                	mv	a5,a0
        return -1;
    800047ec:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    800047ee:	0007cc63          	bltz	a5,80004806 <sys_read+0x50>
    return fileread(f, p, n);
    800047f2:	fe442603          	lw	a2,-28(s0)
    800047f6:	fd843583          	ld	a1,-40(s0)
    800047fa:	fe843503          	ld	a0,-24(s0)
    800047fe:	fffff097          	auipc	ra,0xfffff
    80004802:	43c080e7          	jalr	1084(ra) # 80003c3a <fileread>
}
    80004806:	70a2                	ld	ra,40(sp)
    80004808:	7402                	ld	s0,32(sp)
    8000480a:	6145                	addi	sp,sp,48
    8000480c:	8082                	ret

000000008000480e <sys_write>:
{
    8000480e:	7179                	addi	sp,sp,-48
    80004810:	f406                	sd	ra,40(sp)
    80004812:	f022                	sd	s0,32(sp)
    80004814:	1800                	addi	s0,sp,48
    argaddr(1, &p);
    80004816:	fd840593          	addi	a1,s0,-40
    8000481a:	4505                	li	a0,1
    8000481c:	ffffd097          	auipc	ra,0xffffd
    80004820:	76e080e7          	jalr	1902(ra) # 80001f8a <argaddr>
    argint(2, &n);
    80004824:	fe440593          	addi	a1,s0,-28
    80004828:	4509                	li	a0,2
    8000482a:	ffffd097          	auipc	ra,0xffffd
    8000482e:	740080e7          	jalr	1856(ra) # 80001f6a <argint>
    if (argfd(0, 0, &f) < 0)
    80004832:	fe840613          	addi	a2,s0,-24
    80004836:	4581                	li	a1,0
    80004838:	4501                	li	a0,0
    8000483a:	00000097          	auipc	ra,0x0
    8000483e:	cfe080e7          	jalr	-770(ra) # 80004538 <argfd>
    80004842:	87aa                	mv	a5,a0
        return -1;
    80004844:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    80004846:	0007cc63          	bltz	a5,8000485e <sys_write+0x50>
    return filewrite(f, p, n);
    8000484a:	fe442603          	lw	a2,-28(s0)
    8000484e:	fd843583          	ld	a1,-40(s0)
    80004852:	fe843503          	ld	a0,-24(s0)
    80004856:	fffff097          	auipc	ra,0xfffff
    8000485a:	4a6080e7          	jalr	1190(ra) # 80003cfc <filewrite>
}
    8000485e:	70a2                	ld	ra,40(sp)
    80004860:	7402                	ld	s0,32(sp)
    80004862:	6145                	addi	sp,sp,48
    80004864:	8082                	ret

0000000080004866 <sys_close>:
{
    80004866:	1101                	addi	sp,sp,-32
    80004868:	ec06                	sd	ra,24(sp)
    8000486a:	e822                	sd	s0,16(sp)
    8000486c:	1000                	addi	s0,sp,32
    if (argfd(0, &fd, &f) < 0)
    8000486e:	fe040613          	addi	a2,s0,-32
    80004872:	fec40593          	addi	a1,s0,-20
    80004876:	4501                	li	a0,0
    80004878:	00000097          	auipc	ra,0x0
    8000487c:	cc0080e7          	jalr	-832(ra) # 80004538 <argfd>
        return -1;
    80004880:	57fd                	li	a5,-1
    if (argfd(0, &fd, &f) < 0)
    80004882:	02054463          	bltz	a0,800048aa <sys_close+0x44>
    myproc()->ofile[fd] = 0;
    80004886:	ffffc097          	auipc	ra,0xffffc
    8000488a:	5ce080e7          	jalr	1486(ra) # 80000e54 <myproc>
    8000488e:	fec42783          	lw	a5,-20(s0)
    80004892:	07e9                	addi	a5,a5,26
    80004894:	078e                	slli	a5,a5,0x3
    80004896:	953e                	add	a0,a0,a5
    80004898:	00053023          	sd	zero,0(a0)
    fileclose(f);
    8000489c:	fe043503          	ld	a0,-32(s0)
    800048a0:	fffff097          	auipc	ra,0xfffff
    800048a4:	260080e7          	jalr	608(ra) # 80003b00 <fileclose>
    return 0;
    800048a8:	4781                	li	a5,0
}
    800048aa:	853e                	mv	a0,a5
    800048ac:	60e2                	ld	ra,24(sp)
    800048ae:	6442                	ld	s0,16(sp)
    800048b0:	6105                	addi	sp,sp,32
    800048b2:	8082                	ret

00000000800048b4 <sys_fstat>:
{
    800048b4:	1101                	addi	sp,sp,-32
    800048b6:	ec06                	sd	ra,24(sp)
    800048b8:	e822                	sd	s0,16(sp)
    800048ba:	1000                	addi	s0,sp,32
    argaddr(1, &st);
    800048bc:	fe040593          	addi	a1,s0,-32
    800048c0:	4505                	li	a0,1
    800048c2:	ffffd097          	auipc	ra,0xffffd
    800048c6:	6c8080e7          	jalr	1736(ra) # 80001f8a <argaddr>
    if (argfd(0, 0, &f) < 0)
    800048ca:	fe840613          	addi	a2,s0,-24
    800048ce:	4581                	li	a1,0
    800048d0:	4501                	li	a0,0
    800048d2:	00000097          	auipc	ra,0x0
    800048d6:	c66080e7          	jalr	-922(ra) # 80004538 <argfd>
    800048da:	87aa                	mv	a5,a0
        return -1;
    800048dc:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    800048de:	0007ca63          	bltz	a5,800048f2 <sys_fstat+0x3e>
    return filestat(f, st);
    800048e2:	fe043583          	ld	a1,-32(s0)
    800048e6:	fe843503          	ld	a0,-24(s0)
    800048ea:	fffff097          	auipc	ra,0xfffff
    800048ee:	2de080e7          	jalr	734(ra) # 80003bc8 <filestat>
}
    800048f2:	60e2                	ld	ra,24(sp)
    800048f4:	6442                	ld	s0,16(sp)
    800048f6:	6105                	addi	sp,sp,32
    800048f8:	8082                	ret

00000000800048fa <sys_link>:
{
    800048fa:	7169                	addi	sp,sp,-304
    800048fc:	f606                	sd	ra,296(sp)
    800048fe:	f222                	sd	s0,288(sp)
    80004900:	ee26                	sd	s1,280(sp)
    80004902:	ea4a                	sd	s2,272(sp)
    80004904:	1a00                	addi	s0,sp,304
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004906:	08000613          	li	a2,128
    8000490a:	ed040593          	addi	a1,s0,-304
    8000490e:	4501                	li	a0,0
    80004910:	ffffd097          	auipc	ra,0xffffd
    80004914:	69a080e7          	jalr	1690(ra) # 80001faa <argstr>
        return -1;
    80004918:	57fd                	li	a5,-1
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000491a:	10054e63          	bltz	a0,80004a36 <sys_link+0x13c>
    8000491e:	08000613          	li	a2,128
    80004922:	f5040593          	addi	a1,s0,-176
    80004926:	4505                	li	a0,1
    80004928:	ffffd097          	auipc	ra,0xffffd
    8000492c:	682080e7          	jalr	1666(ra) # 80001faa <argstr>
        return -1;
    80004930:	57fd                	li	a5,-1
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004932:	10054263          	bltz	a0,80004a36 <sys_link+0x13c>
    begin_op();
    80004936:	fffff097          	auipc	ra,0xfffff
    8000493a:	d02080e7          	jalr	-766(ra) # 80003638 <begin_op>
    if ((ip = namei(old)) == 0) {
    8000493e:	ed040513          	addi	a0,s0,-304
    80004942:	fffff097          	auipc	ra,0xfffff
    80004946:	ad6080e7          	jalr	-1322(ra) # 80003418 <namei>
    8000494a:	84aa                	mv	s1,a0
    8000494c:	c551                	beqz	a0,800049d8 <sys_link+0xde>
    ilock(ip);
    8000494e:	ffffe097          	auipc	ra,0xffffe
    80004952:	276080e7          	jalr	630(ra) # 80002bc4 <ilock>
    if (ip->type == T_DIR) {
    80004956:	04449703          	lh	a4,68(s1)
    8000495a:	4785                	li	a5,1
    8000495c:	08f70463          	beq	a4,a5,800049e4 <sys_link+0xea>
    ip->nlink++;
    80004960:	04a4d783          	lhu	a5,74(s1)
    80004964:	2785                	addiw	a5,a5,1
    80004966:	04f49523          	sh	a5,74(s1)
    iupdate(ip);
    8000496a:	8526                	mv	a0,s1
    8000496c:	ffffe097          	auipc	ra,0xffffe
    80004970:	18c080e7          	jalr	396(ra) # 80002af8 <iupdate>
    iunlock(ip);
    80004974:	8526                	mv	a0,s1
    80004976:	ffffe097          	auipc	ra,0xffffe
    8000497a:	310080e7          	jalr	784(ra) # 80002c86 <iunlock>
    if ((dp = nameiparent(new, name)) == 0)
    8000497e:	fd040593          	addi	a1,s0,-48
    80004982:	f5040513          	addi	a0,s0,-176
    80004986:	fffff097          	auipc	ra,0xfffff
    8000498a:	ab0080e7          	jalr	-1360(ra) # 80003436 <nameiparent>
    8000498e:	892a                	mv	s2,a0
    80004990:	c935                	beqz	a0,80004a04 <sys_link+0x10a>
    ilock(dp);
    80004992:	ffffe097          	auipc	ra,0xffffe
    80004996:	232080e7          	jalr	562(ra) # 80002bc4 <ilock>
    if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    8000499a:	00092703          	lw	a4,0(s2)
    8000499e:	409c                	lw	a5,0(s1)
    800049a0:	04f71d63          	bne	a4,a5,800049fa <sys_link+0x100>
    800049a4:	40d0                	lw	a2,4(s1)
    800049a6:	fd040593          	addi	a1,s0,-48
    800049aa:	854a                	mv	a0,s2
    800049ac:	fffff097          	auipc	ra,0xfffff
    800049b0:	9ba080e7          	jalr	-1606(ra) # 80003366 <dirlink>
    800049b4:	04054363          	bltz	a0,800049fa <sys_link+0x100>
    iunlockput(dp);
    800049b8:	854a                	mv	a0,s2
    800049ba:	ffffe097          	auipc	ra,0xffffe
    800049be:	512080e7          	jalr	1298(ra) # 80002ecc <iunlockput>
    iput(ip);
    800049c2:	8526                	mv	a0,s1
    800049c4:	ffffe097          	auipc	ra,0xffffe
    800049c8:	460080e7          	jalr	1120(ra) # 80002e24 <iput>
    end_op();
    800049cc:	fffff097          	auipc	ra,0xfffff
    800049d0:	cea080e7          	jalr	-790(ra) # 800036b6 <end_op>
    return 0;
    800049d4:	4781                	li	a5,0
    800049d6:	a085                	j	80004a36 <sys_link+0x13c>
        end_op();
    800049d8:	fffff097          	auipc	ra,0xfffff
    800049dc:	cde080e7          	jalr	-802(ra) # 800036b6 <end_op>
        return -1;
    800049e0:	57fd                	li	a5,-1
    800049e2:	a891                	j	80004a36 <sys_link+0x13c>
        iunlockput(ip);
    800049e4:	8526                	mv	a0,s1
    800049e6:	ffffe097          	auipc	ra,0xffffe
    800049ea:	4e6080e7          	jalr	1254(ra) # 80002ecc <iunlockput>
        end_op();
    800049ee:	fffff097          	auipc	ra,0xfffff
    800049f2:	cc8080e7          	jalr	-824(ra) # 800036b6 <end_op>
        return -1;
    800049f6:	57fd                	li	a5,-1
    800049f8:	a83d                	j	80004a36 <sys_link+0x13c>
        iunlockput(dp);
    800049fa:	854a                	mv	a0,s2
    800049fc:	ffffe097          	auipc	ra,0xffffe
    80004a00:	4d0080e7          	jalr	1232(ra) # 80002ecc <iunlockput>
    ilock(ip);
    80004a04:	8526                	mv	a0,s1
    80004a06:	ffffe097          	auipc	ra,0xffffe
    80004a0a:	1be080e7          	jalr	446(ra) # 80002bc4 <ilock>
    ip->nlink--;
    80004a0e:	04a4d783          	lhu	a5,74(s1)
    80004a12:	37fd                	addiw	a5,a5,-1
    80004a14:	04f49523          	sh	a5,74(s1)
    iupdate(ip);
    80004a18:	8526                	mv	a0,s1
    80004a1a:	ffffe097          	auipc	ra,0xffffe
    80004a1e:	0de080e7          	jalr	222(ra) # 80002af8 <iupdate>
    iunlockput(ip);
    80004a22:	8526                	mv	a0,s1
    80004a24:	ffffe097          	auipc	ra,0xffffe
    80004a28:	4a8080e7          	jalr	1192(ra) # 80002ecc <iunlockput>
    end_op();
    80004a2c:	fffff097          	auipc	ra,0xfffff
    80004a30:	c8a080e7          	jalr	-886(ra) # 800036b6 <end_op>
    return -1;
    80004a34:	57fd                	li	a5,-1
}
    80004a36:	853e                	mv	a0,a5
    80004a38:	70b2                	ld	ra,296(sp)
    80004a3a:	7412                	ld	s0,288(sp)
    80004a3c:	64f2                	ld	s1,280(sp)
    80004a3e:	6952                	ld	s2,272(sp)
    80004a40:	6155                	addi	sp,sp,304
    80004a42:	8082                	ret

0000000080004a44 <sys_unlink>:
{
    80004a44:	7151                	addi	sp,sp,-240
    80004a46:	f586                	sd	ra,232(sp)
    80004a48:	f1a2                	sd	s0,224(sp)
    80004a4a:	eda6                	sd	s1,216(sp)
    80004a4c:	e9ca                	sd	s2,208(sp)
    80004a4e:	e5ce                	sd	s3,200(sp)
    80004a50:	1980                	addi	s0,sp,240
    if (argstr(0, path, MAXPATH) < 0)
    80004a52:	08000613          	li	a2,128
    80004a56:	f3040593          	addi	a1,s0,-208
    80004a5a:	4501                	li	a0,0
    80004a5c:	ffffd097          	auipc	ra,0xffffd
    80004a60:	54e080e7          	jalr	1358(ra) # 80001faa <argstr>
    80004a64:	18054163          	bltz	a0,80004be6 <sys_unlink+0x1a2>
    begin_op();
    80004a68:	fffff097          	auipc	ra,0xfffff
    80004a6c:	bd0080e7          	jalr	-1072(ra) # 80003638 <begin_op>
    if ((dp = nameiparent(path, name)) == 0) {
    80004a70:	fb040593          	addi	a1,s0,-80
    80004a74:	f3040513          	addi	a0,s0,-208
    80004a78:	fffff097          	auipc	ra,0xfffff
    80004a7c:	9be080e7          	jalr	-1602(ra) # 80003436 <nameiparent>
    80004a80:	84aa                	mv	s1,a0
    80004a82:	c979                	beqz	a0,80004b58 <sys_unlink+0x114>
    ilock(dp);
    80004a84:	ffffe097          	auipc	ra,0xffffe
    80004a88:	140080e7          	jalr	320(ra) # 80002bc4 <ilock>
    if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a8c:	00004597          	auipc	a1,0x4
    80004a90:	bec58593          	addi	a1,a1,-1044 # 80008678 <syscalls+0x2a8>
    80004a94:	fb040513          	addi	a0,s0,-80
    80004a98:	ffffe097          	auipc	ra,0xffffe
    80004a9c:	69e080e7          	jalr	1694(ra) # 80003136 <namecmp>
    80004aa0:	14050a63          	beqz	a0,80004bf4 <sys_unlink+0x1b0>
    80004aa4:	00004597          	auipc	a1,0x4
    80004aa8:	bdc58593          	addi	a1,a1,-1060 # 80008680 <syscalls+0x2b0>
    80004aac:	fb040513          	addi	a0,s0,-80
    80004ab0:	ffffe097          	auipc	ra,0xffffe
    80004ab4:	686080e7          	jalr	1670(ra) # 80003136 <namecmp>
    80004ab8:	12050e63          	beqz	a0,80004bf4 <sys_unlink+0x1b0>
    if ((ip = dirlookup(dp, name, &off)) == 0)
    80004abc:	f2c40613          	addi	a2,s0,-212
    80004ac0:	fb040593          	addi	a1,s0,-80
    80004ac4:	8526                	mv	a0,s1
    80004ac6:	ffffe097          	auipc	ra,0xffffe
    80004aca:	68a080e7          	jalr	1674(ra) # 80003150 <dirlookup>
    80004ace:	892a                	mv	s2,a0
    80004ad0:	12050263          	beqz	a0,80004bf4 <sys_unlink+0x1b0>
    ilock(ip);
    80004ad4:	ffffe097          	auipc	ra,0xffffe
    80004ad8:	0f0080e7          	jalr	240(ra) # 80002bc4 <ilock>
    if (ip->nlink < 1)
    80004adc:	04a91783          	lh	a5,74(s2)
    80004ae0:	08f05263          	blez	a5,80004b64 <sys_unlink+0x120>
    if (ip->type == T_DIR && !isdirempty(ip)) {
    80004ae4:	04491703          	lh	a4,68(s2)
    80004ae8:	4785                	li	a5,1
    80004aea:	08f70563          	beq	a4,a5,80004b74 <sys_unlink+0x130>
    memset(&de, 0, sizeof(de));
    80004aee:	4641                	li	a2,16
    80004af0:	4581                	li	a1,0
    80004af2:	fc040513          	addi	a0,s0,-64
    80004af6:	ffffb097          	auipc	ra,0xffffb
    80004afa:	684080e7          	jalr	1668(ra) # 8000017a <memset>
    if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004afe:	4741                	li	a4,16
    80004b00:	f2c42683          	lw	a3,-212(s0)
    80004b04:	fc040613          	addi	a2,s0,-64
    80004b08:	4581                	li	a1,0
    80004b0a:	8526                	mv	a0,s1
    80004b0c:	ffffe097          	auipc	ra,0xffffe
    80004b10:	50a080e7          	jalr	1290(ra) # 80003016 <writei>
    80004b14:	47c1                	li	a5,16
    80004b16:	0af51563          	bne	a0,a5,80004bc0 <sys_unlink+0x17c>
    if (ip->type == T_DIR) {
    80004b1a:	04491703          	lh	a4,68(s2)
    80004b1e:	4785                	li	a5,1
    80004b20:	0af70863          	beq	a4,a5,80004bd0 <sys_unlink+0x18c>
    iunlockput(dp);
    80004b24:	8526                	mv	a0,s1
    80004b26:	ffffe097          	auipc	ra,0xffffe
    80004b2a:	3a6080e7          	jalr	934(ra) # 80002ecc <iunlockput>
    ip->nlink--;
    80004b2e:	04a95783          	lhu	a5,74(s2)
    80004b32:	37fd                	addiw	a5,a5,-1
    80004b34:	04f91523          	sh	a5,74(s2)
    iupdate(ip);
    80004b38:	854a                	mv	a0,s2
    80004b3a:	ffffe097          	auipc	ra,0xffffe
    80004b3e:	fbe080e7          	jalr	-66(ra) # 80002af8 <iupdate>
    iunlockput(ip);
    80004b42:	854a                	mv	a0,s2
    80004b44:	ffffe097          	auipc	ra,0xffffe
    80004b48:	388080e7          	jalr	904(ra) # 80002ecc <iunlockput>
    end_op();
    80004b4c:	fffff097          	auipc	ra,0xfffff
    80004b50:	b6a080e7          	jalr	-1174(ra) # 800036b6 <end_op>
    return 0;
    80004b54:	4501                	li	a0,0
    80004b56:	a84d                	j	80004c08 <sys_unlink+0x1c4>
        end_op();
    80004b58:	fffff097          	auipc	ra,0xfffff
    80004b5c:	b5e080e7          	jalr	-1186(ra) # 800036b6 <end_op>
        return -1;
    80004b60:	557d                	li	a0,-1
    80004b62:	a05d                	j	80004c08 <sys_unlink+0x1c4>
        panic("unlink: nlink < 1");
    80004b64:	00004517          	auipc	a0,0x4
    80004b68:	b2450513          	addi	a0,a0,-1244 # 80008688 <syscalls+0x2b8>
    80004b6c:	00001097          	auipc	ra,0x1
    80004b70:	300080e7          	jalr	768(ra) # 80005e6c <panic>
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004b74:	04c92703          	lw	a4,76(s2)
    80004b78:	02000793          	li	a5,32
    80004b7c:	f6e7f9e3          	bgeu	a5,a4,80004aee <sys_unlink+0xaa>
    80004b80:	02000993          	li	s3,32
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b84:	4741                	li	a4,16
    80004b86:	86ce                	mv	a3,s3
    80004b88:	f1840613          	addi	a2,s0,-232
    80004b8c:	4581                	li	a1,0
    80004b8e:	854a                	mv	a0,s2
    80004b90:	ffffe097          	auipc	ra,0xffffe
    80004b94:	38e080e7          	jalr	910(ra) # 80002f1e <readi>
    80004b98:	47c1                	li	a5,16
    80004b9a:	00f51b63          	bne	a0,a5,80004bb0 <sys_unlink+0x16c>
        if (de.inum != 0)
    80004b9e:	f1845783          	lhu	a5,-232(s0)
    80004ba2:	e7a1                	bnez	a5,80004bea <sys_unlink+0x1a6>
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004ba4:	29c1                	addiw	s3,s3,16
    80004ba6:	04c92783          	lw	a5,76(s2)
    80004baa:	fcf9ede3          	bltu	s3,a5,80004b84 <sys_unlink+0x140>
    80004bae:	b781                	j	80004aee <sys_unlink+0xaa>
            panic("isdirempty: readi");
    80004bb0:	00004517          	auipc	a0,0x4
    80004bb4:	af050513          	addi	a0,a0,-1296 # 800086a0 <syscalls+0x2d0>
    80004bb8:	00001097          	auipc	ra,0x1
    80004bbc:	2b4080e7          	jalr	692(ra) # 80005e6c <panic>
        panic("unlink: writei");
    80004bc0:	00004517          	auipc	a0,0x4
    80004bc4:	af850513          	addi	a0,a0,-1288 # 800086b8 <syscalls+0x2e8>
    80004bc8:	00001097          	auipc	ra,0x1
    80004bcc:	2a4080e7          	jalr	676(ra) # 80005e6c <panic>
        dp->nlink--;
    80004bd0:	04a4d783          	lhu	a5,74(s1)
    80004bd4:	37fd                	addiw	a5,a5,-1
    80004bd6:	04f49523          	sh	a5,74(s1)
        iupdate(dp);
    80004bda:	8526                	mv	a0,s1
    80004bdc:	ffffe097          	auipc	ra,0xffffe
    80004be0:	f1c080e7          	jalr	-228(ra) # 80002af8 <iupdate>
    80004be4:	b781                	j	80004b24 <sys_unlink+0xe0>
        return -1;
    80004be6:	557d                	li	a0,-1
    80004be8:	a005                	j	80004c08 <sys_unlink+0x1c4>
        iunlockput(ip);
    80004bea:	854a                	mv	a0,s2
    80004bec:	ffffe097          	auipc	ra,0xffffe
    80004bf0:	2e0080e7          	jalr	736(ra) # 80002ecc <iunlockput>
    iunlockput(dp);
    80004bf4:	8526                	mv	a0,s1
    80004bf6:	ffffe097          	auipc	ra,0xffffe
    80004bfa:	2d6080e7          	jalr	726(ra) # 80002ecc <iunlockput>
    end_op();
    80004bfe:	fffff097          	auipc	ra,0xfffff
    80004c02:	ab8080e7          	jalr	-1352(ra) # 800036b6 <end_op>
    return -1;
    80004c06:	557d                	li	a0,-1
}
    80004c08:	70ae                	ld	ra,232(sp)
    80004c0a:	740e                	ld	s0,224(sp)
    80004c0c:	64ee                	ld	s1,216(sp)
    80004c0e:	694e                	ld	s2,208(sp)
    80004c10:	69ae                	ld	s3,200(sp)
    80004c12:	616d                	addi	sp,sp,240
    80004c14:	8082                	ret

0000000080004c16 <sys_open>:

uint64 sys_open(void)
{
    80004c16:	7129                	addi	sp,sp,-320
    80004c18:	fe06                	sd	ra,312(sp)
    80004c1a:	fa22                	sd	s0,304(sp)
    80004c1c:	f626                	sd	s1,296(sp)
    80004c1e:	f24a                	sd	s2,288(sp)
    80004c20:	ee4e                	sd	s3,280(sp)
    80004c22:	ea52                	sd	s4,272(sp)
    80004c24:	0280                	addi	s0,sp,320
    int fd, omode;
    struct file *f;
    struct inode *ip;
    int n;

    argint(1, &omode);
    80004c26:	f4c40593          	addi	a1,s0,-180
    80004c2a:	4505                	li	a0,1
    80004c2c:	ffffd097          	auipc	ra,0xffffd
    80004c30:	33e080e7          	jalr	830(ra) # 80001f6a <argint>
    if ((n = argstr(0, path, MAXPATH)) < 0)
    80004c34:	08000613          	li	a2,128
    80004c38:	f5040593          	addi	a1,s0,-176
    80004c3c:	4501                	li	a0,0
    80004c3e:	ffffd097          	auipc	ra,0xffffd
    80004c42:	36c080e7          	jalr	876(ra) # 80001faa <argstr>
    80004c46:	87aa                	mv	a5,a0
        return -1;
    80004c48:	557d                	li	a0,-1
    if ((n = argstr(0, path, MAXPATH)) < 0)
    80004c4a:	0a07ce63          	bltz	a5,80004d06 <sys_open+0xf0>

    begin_op();
    80004c4e:	fffff097          	auipc	ra,0xfffff
    80004c52:	9ea080e7          	jalr	-1558(ra) # 80003638 <begin_op>

    if (omode & O_CREATE) {
    80004c56:	f4c42783          	lw	a5,-180(s0)
    80004c5a:	2007f793          	andi	a5,a5,512
    80004c5e:	c3f1                	beqz	a5,80004d22 <sys_open+0x10c>
        ip = create(path, T_FILE, 0, 0);
    80004c60:	4681                	li	a3,0
    80004c62:	4601                	li	a2,0
    80004c64:	4589                	li	a1,2
    80004c66:	f5040513          	addi	a0,s0,-176
    80004c6a:	00000097          	auipc	ra,0x0
    80004c6e:	970080e7          	jalr	-1680(ra) # 800045da <create>
    80004c72:	84aa                	mv	s1,a0
        if (ip == 0) {
    80004c74:	c14d                	beqz	a0,80004d16 <sys_open+0x100>
            return -1;
        }
    }

    // 文件类型是SYMLINK，并且O_NOFOLLOW是false，应该递归寻找到不是软链接的文件（否则按照正常文件打开）
    if (!(omode & O_NOFOLLOW) && ip->type == T_SYMLINK) {
    80004c76:	f4c42783          	lw	a5,-180(s0)
    80004c7a:	83ad                	srli	a5,a5,0xb
    80004c7c:	8b85                	andi	a5,a5,1
    80004c7e:	c7fd                	beqz	a5,80004d6c <sys_open+0x156>
            end_op();
            return -1;
        }
    }

    if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    80004c80:	04449703          	lh	a4,68(s1)
    80004c84:	478d                	li	a5,3
    80004c86:	00f71763          	bne	a4,a5,80004c94 <sys_open+0x7e>
    80004c8a:	0464d703          	lhu	a4,70(s1)
    80004c8e:	47a5                	li	a5,9
    80004c90:	16e7e663          	bltu	a5,a4,80004dfc <sys_open+0x1e6>
        iunlockput(ip);
        end_op();
        return -1;
    }

    if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80004c94:	fffff097          	auipc	ra,0xfffff
    80004c98:	db0080e7          	jalr	-592(ra) # 80003a44 <filealloc>
    80004c9c:	89aa                	mv	s3,a0
    80004c9e:	18050c63          	beqz	a0,80004e36 <sys_open+0x220>
    80004ca2:	00000097          	auipc	ra,0x0
    80004ca6:	8f6080e7          	jalr	-1802(ra) # 80004598 <fdalloc>
    80004caa:	892a                	mv	s2,a0
    80004cac:	18054063          	bltz	a0,80004e2c <sys_open+0x216>
        iunlockput(ip);
        end_op();
        return -1;
    }

    if (ip->type == T_DEVICE) {
    80004cb0:	04449703          	lh	a4,68(s1)
    80004cb4:	478d                	li	a5,3
    80004cb6:	14f70e63          	beq	a4,a5,80004e12 <sys_open+0x1fc>
        f->type = FD_DEVICE;
        f->major = ip->major;
    }
    else {
        f->type = FD_INODE;
    80004cba:	4789                	li	a5,2
    80004cbc:	00f9a023          	sw	a5,0(s3)
        f->off = 0;
    80004cc0:	0209a023          	sw	zero,32(s3)
    }
    f->ip = ip;
    80004cc4:	0099bc23          	sd	s1,24(s3)
    f->readable = !(omode & O_WRONLY);
    80004cc8:	f4c42783          	lw	a5,-180(s0)
    80004ccc:	0017c713          	xori	a4,a5,1
    80004cd0:	8b05                	andi	a4,a4,1
    80004cd2:	00e98423          	sb	a4,8(s3)
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004cd6:	0037f713          	andi	a4,a5,3
    80004cda:	00e03733          	snez	a4,a4
    80004cde:	00e984a3          	sb	a4,9(s3)

    if ((omode & O_TRUNC) && ip->type == T_FILE) {
    80004ce2:	4007f793          	andi	a5,a5,1024
    80004ce6:	c791                	beqz	a5,80004cf2 <sys_open+0xdc>
    80004ce8:	04449703          	lh	a4,68(s1)
    80004cec:	4789                	li	a5,2
    80004cee:	12f70963          	beq	a4,a5,80004e20 <sys_open+0x20a>
        itrunc(ip);
    }

    iunlock(ip);
    80004cf2:	8526                	mv	a0,s1
    80004cf4:	ffffe097          	auipc	ra,0xffffe
    80004cf8:	f92080e7          	jalr	-110(ra) # 80002c86 <iunlock>
    end_op();
    80004cfc:	fffff097          	auipc	ra,0xfffff
    80004d00:	9ba080e7          	jalr	-1606(ra) # 800036b6 <end_op>

    return fd;
    80004d04:	854a                	mv	a0,s2
}
    80004d06:	70f2                	ld	ra,312(sp)
    80004d08:	7452                	ld	s0,304(sp)
    80004d0a:	74b2                	ld	s1,296(sp)
    80004d0c:	7912                	ld	s2,288(sp)
    80004d0e:	69f2                	ld	s3,280(sp)
    80004d10:	6a52                	ld	s4,272(sp)
    80004d12:	6131                	addi	sp,sp,320
    80004d14:	8082                	ret
            end_op();
    80004d16:	fffff097          	auipc	ra,0xfffff
    80004d1a:	9a0080e7          	jalr	-1632(ra) # 800036b6 <end_op>
            return -1;
    80004d1e:	557d                	li	a0,-1
    80004d20:	b7dd                	j	80004d06 <sys_open+0xf0>
        if ((ip = namei(path)) == 0) {
    80004d22:	f5040513          	addi	a0,s0,-176
    80004d26:	ffffe097          	auipc	ra,0xffffe
    80004d2a:	6f2080e7          	jalr	1778(ra) # 80003418 <namei>
    80004d2e:	84aa                	mv	s1,a0
    80004d30:	c905                	beqz	a0,80004d60 <sys_open+0x14a>
        ilock(ip);
    80004d32:	ffffe097          	auipc	ra,0xffffe
    80004d36:	e92080e7          	jalr	-366(ra) # 80002bc4 <ilock>
        if (ip->type == T_DIR && omode != O_RDONLY) {
    80004d3a:	04449703          	lh	a4,68(s1)
    80004d3e:	4785                	li	a5,1
    80004d40:	f2f71be3          	bne	a4,a5,80004c76 <sys_open+0x60>
    80004d44:	f4c42783          	lw	a5,-180(s0)
    80004d48:	df85                	beqz	a5,80004c80 <sys_open+0x6a>
            iunlockput(ip);
    80004d4a:	8526                	mv	a0,s1
    80004d4c:	ffffe097          	auipc	ra,0xffffe
    80004d50:	180080e7          	jalr	384(ra) # 80002ecc <iunlockput>
            end_op();
    80004d54:	fffff097          	auipc	ra,0xfffff
    80004d58:	962080e7          	jalr	-1694(ra) # 800036b6 <end_op>
            return -1;
    80004d5c:	557d                	li	a0,-1
    80004d5e:	b765                	j	80004d06 <sys_open+0xf0>
            end_op();
    80004d60:	fffff097          	auipc	ra,0xfffff
    80004d64:	956080e7          	jalr	-1706(ra) # 800036b6 <end_op>
            return -1;
    80004d68:	557d                	li	a0,-1
    80004d6a:	bf71                	j	80004d06 <sys_open+0xf0>
    if (!(omode & O_NOFOLLOW) && ip->type == T_SYMLINK) {
    80004d6c:	04449703          	lh	a4,68(s1)
    80004d70:	4791                	li	a5,4
    80004d72:	f0f717e3          	bne	a4,a5,80004c80 <sys_open+0x6a>
    80004d76:	4931                	li	s2,12
            if (readi(ip, 0, (uint64)path, 0, MAXPATH) < MAXPATH) { // #define MAXPATH 128
    80004d78:	07f00993          	li	s3,127
            if (ip->type != T_SYMLINK) // 找到不是软链接类型的文件inode，继续正常打开
    80004d7c:	4a11                	li	s4,4
            if (readi(ip, 0, (uint64)path, 0, MAXPATH) < MAXPATH) { // #define MAXPATH 128
    80004d7e:	08000713          	li	a4,128
    80004d82:	4681                	li	a3,0
    80004d84:	ec840613          	addi	a2,s0,-312
    80004d88:	4581                	li	a1,0
    80004d8a:	8526                	mv	a0,s1
    80004d8c:	ffffe097          	auipc	ra,0xffffe
    80004d90:	192080e7          	jalr	402(ra) # 80002f1e <readi>
    80004d94:	04a9d463          	bge	s3,a0,80004ddc <sys_open+0x1c6>
            iunlockput(ip);
    80004d98:	8526                	mv	a0,s1
    80004d9a:	ffffe097          	auipc	ra,0xffffe
    80004d9e:	132080e7          	jalr	306(ra) # 80002ecc <iunlockput>
            if ((ip = namei(path)) == 0) {
    80004da2:	ec840513          	addi	a0,s0,-312
    80004da6:	ffffe097          	auipc	ra,0xffffe
    80004daa:	672080e7          	jalr	1650(ra) # 80003418 <namei>
    80004dae:	84aa                	mv	s1,a0
    80004db0:	c129                	beqz	a0,80004df2 <sys_open+0x1dc>
            ilock(ip);
    80004db2:	ffffe097          	auipc	ra,0xffffe
    80004db6:	e12080e7          	jalr	-494(ra) # 80002bc4 <ilock>
            if (ip->type != T_SYMLINK) // 找到不是软链接类型的文件inode，继续正常打开
    80004dba:	04449783          	lh	a5,68(s1)
    80004dbe:	ed4791e3          	bne	a5,s4,80004c80 <sys_open+0x6a>
        for (int i = 0; i < 12; i++) { // 【设定12是最大递归次数】
    80004dc2:	397d                	addiw	s2,s2,-1
    80004dc4:	fa091de3          	bnez	s2,80004d7e <sys_open+0x168>
            iunlockput(ip);
    80004dc8:	8526                	mv	a0,s1
    80004dca:	ffffe097          	auipc	ra,0xffffe
    80004dce:	102080e7          	jalr	258(ra) # 80002ecc <iunlockput>
            end_op();
    80004dd2:	fffff097          	auipc	ra,0xfffff
    80004dd6:	8e4080e7          	jalr	-1820(ra) # 800036b6 <end_op>
            return -1;
    80004dda:	a811                	j	80004dee <sys_open+0x1d8>
                iunlockput(ip);
    80004ddc:	8526                	mv	a0,s1
    80004dde:	ffffe097          	auipc	ra,0xffffe
    80004de2:	0ee080e7          	jalr	238(ra) # 80002ecc <iunlockput>
                end_op();
    80004de6:	fffff097          	auipc	ra,0xfffff
    80004dea:	8d0080e7          	jalr	-1840(ra) # 800036b6 <end_op>
                return -1;
    80004dee:	557d                	li	a0,-1
    80004df0:	bf19                	j	80004d06 <sys_open+0xf0>
                end_op();
    80004df2:	fffff097          	auipc	ra,0xfffff
    80004df6:	8c4080e7          	jalr	-1852(ra) # 800036b6 <end_op>
                return -1;
    80004dfa:	bfd5                	j	80004dee <sys_open+0x1d8>
        iunlockput(ip);
    80004dfc:	8526                	mv	a0,s1
    80004dfe:	ffffe097          	auipc	ra,0xffffe
    80004e02:	0ce080e7          	jalr	206(ra) # 80002ecc <iunlockput>
        end_op();
    80004e06:	fffff097          	auipc	ra,0xfffff
    80004e0a:	8b0080e7          	jalr	-1872(ra) # 800036b6 <end_op>
        return -1;
    80004e0e:	557d                	li	a0,-1
    80004e10:	bddd                	j	80004d06 <sys_open+0xf0>
        f->type = FD_DEVICE;
    80004e12:	00f9a023          	sw	a5,0(s3)
        f->major = ip->major;
    80004e16:	04649783          	lh	a5,70(s1)
    80004e1a:	02f99223          	sh	a5,36(s3)
    80004e1e:	b55d                	j	80004cc4 <sys_open+0xae>
        itrunc(ip);
    80004e20:	8526                	mv	a0,s1
    80004e22:	ffffe097          	auipc	ra,0xffffe
    80004e26:	eb0080e7          	jalr	-336(ra) # 80002cd2 <itrunc>
    80004e2a:	b5e1                	j	80004cf2 <sys_open+0xdc>
            fileclose(f);
    80004e2c:	854e                	mv	a0,s3
    80004e2e:	fffff097          	auipc	ra,0xfffff
    80004e32:	cd2080e7          	jalr	-814(ra) # 80003b00 <fileclose>
        iunlockput(ip);
    80004e36:	8526                	mv	a0,s1
    80004e38:	ffffe097          	auipc	ra,0xffffe
    80004e3c:	094080e7          	jalr	148(ra) # 80002ecc <iunlockput>
        end_op();
    80004e40:	fffff097          	auipc	ra,0xfffff
    80004e44:	876080e7          	jalr	-1930(ra) # 800036b6 <end_op>
        return -1;
    80004e48:	557d                	li	a0,-1
    80004e4a:	bd75                	j	80004d06 <sys_open+0xf0>

0000000080004e4c <sys_mkdir>:

uint64 sys_mkdir(void)
{
    80004e4c:	7175                	addi	sp,sp,-144
    80004e4e:	e506                	sd	ra,136(sp)
    80004e50:	e122                	sd	s0,128(sp)
    80004e52:	0900                	addi	s0,sp,144
    char path[MAXPATH];
    struct inode *ip;

    begin_op();
    80004e54:	ffffe097          	auipc	ra,0xffffe
    80004e58:	7e4080e7          	jalr	2020(ra) # 80003638 <begin_op>
    if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    80004e5c:	08000613          	li	a2,128
    80004e60:	f7040593          	addi	a1,s0,-144
    80004e64:	4501                	li	a0,0
    80004e66:	ffffd097          	auipc	ra,0xffffd
    80004e6a:	144080e7          	jalr	324(ra) # 80001faa <argstr>
    80004e6e:	02054963          	bltz	a0,80004ea0 <sys_mkdir+0x54>
    80004e72:	4681                	li	a3,0
    80004e74:	4601                	li	a2,0
    80004e76:	4585                	li	a1,1
    80004e78:	f7040513          	addi	a0,s0,-144
    80004e7c:	fffff097          	auipc	ra,0xfffff
    80004e80:	75e080e7          	jalr	1886(ra) # 800045da <create>
    80004e84:	cd11                	beqz	a0,80004ea0 <sys_mkdir+0x54>
        end_op();
        return -1;
    }
    iunlockput(ip);
    80004e86:	ffffe097          	auipc	ra,0xffffe
    80004e8a:	046080e7          	jalr	70(ra) # 80002ecc <iunlockput>
    end_op();
    80004e8e:	fffff097          	auipc	ra,0xfffff
    80004e92:	828080e7          	jalr	-2008(ra) # 800036b6 <end_op>
    return 0;
    80004e96:	4501                	li	a0,0
}
    80004e98:	60aa                	ld	ra,136(sp)
    80004e9a:	640a                	ld	s0,128(sp)
    80004e9c:	6149                	addi	sp,sp,144
    80004e9e:	8082                	ret
        end_op();
    80004ea0:	fffff097          	auipc	ra,0xfffff
    80004ea4:	816080e7          	jalr	-2026(ra) # 800036b6 <end_op>
        return -1;
    80004ea8:	557d                	li	a0,-1
    80004eaa:	b7fd                	j	80004e98 <sys_mkdir+0x4c>

0000000080004eac <sys_mknod>:

uint64 sys_mknod(void)
{
    80004eac:	7135                	addi	sp,sp,-160
    80004eae:	ed06                	sd	ra,152(sp)
    80004eb0:	e922                	sd	s0,144(sp)
    80004eb2:	1100                	addi	s0,sp,160
    struct inode *ip;
    char path[MAXPATH];
    int major, minor;

    begin_op();
    80004eb4:	ffffe097          	auipc	ra,0xffffe
    80004eb8:	784080e7          	jalr	1924(ra) # 80003638 <begin_op>
    argint(1, &major);
    80004ebc:	f6c40593          	addi	a1,s0,-148
    80004ec0:	4505                	li	a0,1
    80004ec2:	ffffd097          	auipc	ra,0xffffd
    80004ec6:	0a8080e7          	jalr	168(ra) # 80001f6a <argint>
    argint(2, &minor);
    80004eca:	f6840593          	addi	a1,s0,-152
    80004ece:	4509                	li	a0,2
    80004ed0:	ffffd097          	auipc	ra,0xffffd
    80004ed4:	09a080e7          	jalr	154(ra) # 80001f6a <argint>
    if ((argstr(0, path, MAXPATH)) < 0 || (ip = create(path, T_DEVICE, major, minor)) == 0) {
    80004ed8:	08000613          	li	a2,128
    80004edc:	f7040593          	addi	a1,s0,-144
    80004ee0:	4501                	li	a0,0
    80004ee2:	ffffd097          	auipc	ra,0xffffd
    80004ee6:	0c8080e7          	jalr	200(ra) # 80001faa <argstr>
    80004eea:	02054b63          	bltz	a0,80004f20 <sys_mknod+0x74>
    80004eee:	f6841683          	lh	a3,-152(s0)
    80004ef2:	f6c41603          	lh	a2,-148(s0)
    80004ef6:	458d                	li	a1,3
    80004ef8:	f7040513          	addi	a0,s0,-144
    80004efc:	fffff097          	auipc	ra,0xfffff
    80004f00:	6de080e7          	jalr	1758(ra) # 800045da <create>
    80004f04:	cd11                	beqz	a0,80004f20 <sys_mknod+0x74>
        end_op();
        return -1;
    }
    iunlockput(ip);
    80004f06:	ffffe097          	auipc	ra,0xffffe
    80004f0a:	fc6080e7          	jalr	-58(ra) # 80002ecc <iunlockput>
    end_op();
    80004f0e:	ffffe097          	auipc	ra,0xffffe
    80004f12:	7a8080e7          	jalr	1960(ra) # 800036b6 <end_op>
    return 0;
    80004f16:	4501                	li	a0,0
}
    80004f18:	60ea                	ld	ra,152(sp)
    80004f1a:	644a                	ld	s0,144(sp)
    80004f1c:	610d                	addi	sp,sp,160
    80004f1e:	8082                	ret
        end_op();
    80004f20:	ffffe097          	auipc	ra,0xffffe
    80004f24:	796080e7          	jalr	1942(ra) # 800036b6 <end_op>
        return -1;
    80004f28:	557d                	li	a0,-1
    80004f2a:	b7fd                	j	80004f18 <sys_mknod+0x6c>

0000000080004f2c <sys_chdir>:

uint64 sys_chdir(void)
{
    80004f2c:	7135                	addi	sp,sp,-160
    80004f2e:	ed06                	sd	ra,152(sp)
    80004f30:	e922                	sd	s0,144(sp)
    80004f32:	e526                	sd	s1,136(sp)
    80004f34:	e14a                	sd	s2,128(sp)
    80004f36:	1100                	addi	s0,sp,160
    char path[MAXPATH];
    struct inode *ip;
    struct proc *p = myproc();
    80004f38:	ffffc097          	auipc	ra,0xffffc
    80004f3c:	f1c080e7          	jalr	-228(ra) # 80000e54 <myproc>
    80004f40:	892a                	mv	s2,a0

    begin_op();
    80004f42:	ffffe097          	auipc	ra,0xffffe
    80004f46:	6f6080e7          	jalr	1782(ra) # 80003638 <begin_op>
    if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    80004f4a:	08000613          	li	a2,128
    80004f4e:	f6040593          	addi	a1,s0,-160
    80004f52:	4501                	li	a0,0
    80004f54:	ffffd097          	auipc	ra,0xffffd
    80004f58:	056080e7          	jalr	86(ra) # 80001faa <argstr>
    80004f5c:	04054b63          	bltz	a0,80004fb2 <sys_chdir+0x86>
    80004f60:	f6040513          	addi	a0,s0,-160
    80004f64:	ffffe097          	auipc	ra,0xffffe
    80004f68:	4b4080e7          	jalr	1204(ra) # 80003418 <namei>
    80004f6c:	84aa                	mv	s1,a0
    80004f6e:	c131                	beqz	a0,80004fb2 <sys_chdir+0x86>
        end_op();
        return -1;
    }
    ilock(ip);
    80004f70:	ffffe097          	auipc	ra,0xffffe
    80004f74:	c54080e7          	jalr	-940(ra) # 80002bc4 <ilock>
    if (ip->type != T_DIR) {
    80004f78:	04449703          	lh	a4,68(s1)
    80004f7c:	4785                	li	a5,1
    80004f7e:	04f71063          	bne	a4,a5,80004fbe <sys_chdir+0x92>
        iunlockput(ip);
        end_op();
        return -1;
    }
    iunlock(ip);
    80004f82:	8526                	mv	a0,s1
    80004f84:	ffffe097          	auipc	ra,0xffffe
    80004f88:	d02080e7          	jalr	-766(ra) # 80002c86 <iunlock>
    iput(p->cwd);
    80004f8c:	15093503          	ld	a0,336(s2)
    80004f90:	ffffe097          	auipc	ra,0xffffe
    80004f94:	e94080e7          	jalr	-364(ra) # 80002e24 <iput>
    end_op();
    80004f98:	ffffe097          	auipc	ra,0xffffe
    80004f9c:	71e080e7          	jalr	1822(ra) # 800036b6 <end_op>
    p->cwd = ip;
    80004fa0:	14993823          	sd	s1,336(s2)
    return 0;
    80004fa4:	4501                	li	a0,0
}
    80004fa6:	60ea                	ld	ra,152(sp)
    80004fa8:	644a                	ld	s0,144(sp)
    80004faa:	64aa                	ld	s1,136(sp)
    80004fac:	690a                	ld	s2,128(sp)
    80004fae:	610d                	addi	sp,sp,160
    80004fb0:	8082                	ret
        end_op();
    80004fb2:	ffffe097          	auipc	ra,0xffffe
    80004fb6:	704080e7          	jalr	1796(ra) # 800036b6 <end_op>
        return -1;
    80004fba:	557d                	li	a0,-1
    80004fbc:	b7ed                	j	80004fa6 <sys_chdir+0x7a>
        iunlockput(ip);
    80004fbe:	8526                	mv	a0,s1
    80004fc0:	ffffe097          	auipc	ra,0xffffe
    80004fc4:	f0c080e7          	jalr	-244(ra) # 80002ecc <iunlockput>
        end_op();
    80004fc8:	ffffe097          	auipc	ra,0xffffe
    80004fcc:	6ee080e7          	jalr	1774(ra) # 800036b6 <end_op>
        return -1;
    80004fd0:	557d                	li	a0,-1
    80004fd2:	bfd1                	j	80004fa6 <sys_chdir+0x7a>

0000000080004fd4 <sys_exec>:

uint64 sys_exec(void)
{
    80004fd4:	7145                	addi	sp,sp,-464
    80004fd6:	e786                	sd	ra,456(sp)
    80004fd8:	e3a2                	sd	s0,448(sp)
    80004fda:	ff26                	sd	s1,440(sp)
    80004fdc:	fb4a                	sd	s2,432(sp)
    80004fde:	f74e                	sd	s3,424(sp)
    80004fe0:	f352                	sd	s4,416(sp)
    80004fe2:	ef56                	sd	s5,408(sp)
    80004fe4:	0b80                	addi	s0,sp,464
    char path[MAXPATH], *argv[MAXARG];
    int i;
    uint64 uargv, uarg;

    argaddr(1, &uargv);
    80004fe6:	e3840593          	addi	a1,s0,-456
    80004fea:	4505                	li	a0,1
    80004fec:	ffffd097          	auipc	ra,0xffffd
    80004ff0:	f9e080e7          	jalr	-98(ra) # 80001f8a <argaddr>
    if (argstr(0, path, MAXPATH) < 0) {
    80004ff4:	08000613          	li	a2,128
    80004ff8:	f4040593          	addi	a1,s0,-192
    80004ffc:	4501                	li	a0,0
    80004ffe:	ffffd097          	auipc	ra,0xffffd
    80005002:	fac080e7          	jalr	-84(ra) # 80001faa <argstr>
    80005006:	87aa                	mv	a5,a0
        return -1;
    80005008:	557d                	li	a0,-1
    if (argstr(0, path, MAXPATH) < 0) {
    8000500a:	0c07c363          	bltz	a5,800050d0 <sys_exec+0xfc>
    }
    memset(argv, 0, sizeof(argv));
    8000500e:	10000613          	li	a2,256
    80005012:	4581                	li	a1,0
    80005014:	e4040513          	addi	a0,s0,-448
    80005018:	ffffb097          	auipc	ra,0xffffb
    8000501c:	162080e7          	jalr	354(ra) # 8000017a <memset>
    for (i = 0;; i++) {
        if (i >= NELEM(argv)) {
    80005020:	e4040493          	addi	s1,s0,-448
    memset(argv, 0, sizeof(argv));
    80005024:	89a6                	mv	s3,s1
    80005026:	4901                	li	s2,0
        if (i >= NELEM(argv)) {
    80005028:	02000a13          	li	s4,32
    8000502c:	00090a9b          	sext.w	s5,s2
            goto bad;
        }
        if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    80005030:	00391513          	slli	a0,s2,0x3
    80005034:	e3040593          	addi	a1,s0,-464
    80005038:	e3843783          	ld	a5,-456(s0)
    8000503c:	953e                	add	a0,a0,a5
    8000503e:	ffffd097          	auipc	ra,0xffffd
    80005042:	e8e080e7          	jalr	-370(ra) # 80001ecc <fetchaddr>
    80005046:	02054a63          	bltz	a0,8000507a <sys_exec+0xa6>
            goto bad;
        }
        if (uarg == 0) {
    8000504a:	e3043783          	ld	a5,-464(s0)
    8000504e:	c3b9                	beqz	a5,80005094 <sys_exec+0xc0>
            argv[i] = 0;
            break;
        }
        argv[i] = kalloc();
    80005050:	ffffb097          	auipc	ra,0xffffb
    80005054:	0ca080e7          	jalr	202(ra) # 8000011a <kalloc>
    80005058:	85aa                	mv	a1,a0
    8000505a:	00a9b023          	sd	a0,0(s3)
        if (argv[i] == 0)
    8000505e:	cd11                	beqz	a0,8000507a <sys_exec+0xa6>
            goto bad;
        if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005060:	6605                	lui	a2,0x1
    80005062:	e3043503          	ld	a0,-464(s0)
    80005066:	ffffd097          	auipc	ra,0xffffd
    8000506a:	eb8080e7          	jalr	-328(ra) # 80001f1e <fetchstr>
    8000506e:	00054663          	bltz	a0,8000507a <sys_exec+0xa6>
        if (i >= NELEM(argv)) {
    80005072:	0905                	addi	s2,s2,1
    80005074:	09a1                	addi	s3,s3,8
    80005076:	fb491be3          	bne	s2,s4,8000502c <sys_exec+0x58>
        kfree(argv[i]);

    return ret;

bad:
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000507a:	f4040913          	addi	s2,s0,-192
    8000507e:	6088                	ld	a0,0(s1)
    80005080:	c539                	beqz	a0,800050ce <sys_exec+0xfa>
        kfree(argv[i]);
    80005082:	ffffb097          	auipc	ra,0xffffb
    80005086:	f9a080e7          	jalr	-102(ra) # 8000001c <kfree>
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000508a:	04a1                	addi	s1,s1,8
    8000508c:	ff2499e3          	bne	s1,s2,8000507e <sys_exec+0xaa>
    return -1;
    80005090:	557d                	li	a0,-1
    80005092:	a83d                	j	800050d0 <sys_exec+0xfc>
            argv[i] = 0;
    80005094:	0a8e                	slli	s5,s5,0x3
    80005096:	fc0a8793          	addi	a5,s5,-64
    8000509a:	00878ab3          	add	s5,a5,s0
    8000509e:	e80ab023          	sd	zero,-384(s5)
    int ret = exec(path, argv);
    800050a2:	e4040593          	addi	a1,s0,-448
    800050a6:	f4040513          	addi	a0,s0,-192
    800050aa:	fffff097          	auipc	ra,0xfffff
    800050ae:	0d0080e7          	jalr	208(ra) # 8000417a <exec>
    800050b2:	892a                	mv	s2,a0
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050b4:	f4040993          	addi	s3,s0,-192
    800050b8:	6088                	ld	a0,0(s1)
    800050ba:	c901                	beqz	a0,800050ca <sys_exec+0xf6>
        kfree(argv[i]);
    800050bc:	ffffb097          	auipc	ra,0xffffb
    800050c0:	f60080e7          	jalr	-160(ra) # 8000001c <kfree>
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050c4:	04a1                	addi	s1,s1,8
    800050c6:	ff3499e3          	bne	s1,s3,800050b8 <sys_exec+0xe4>
    return ret;
    800050ca:	854a                	mv	a0,s2
    800050cc:	a011                	j	800050d0 <sys_exec+0xfc>
    return -1;
    800050ce:	557d                	li	a0,-1
}
    800050d0:	60be                	ld	ra,456(sp)
    800050d2:	641e                	ld	s0,448(sp)
    800050d4:	74fa                	ld	s1,440(sp)
    800050d6:	795a                	ld	s2,432(sp)
    800050d8:	79ba                	ld	s3,424(sp)
    800050da:	7a1a                	ld	s4,416(sp)
    800050dc:	6afa                	ld	s5,408(sp)
    800050de:	6179                	addi	sp,sp,464
    800050e0:	8082                	ret

00000000800050e2 <sys_pipe>:

uint64 sys_pipe(void)
{
    800050e2:	7139                	addi	sp,sp,-64
    800050e4:	fc06                	sd	ra,56(sp)
    800050e6:	f822                	sd	s0,48(sp)
    800050e8:	f426                	sd	s1,40(sp)
    800050ea:	0080                	addi	s0,sp,64
    uint64 fdarray; // user pointer to array of two integers
    struct file *rf, *wf;
    int fd0, fd1;
    struct proc *p = myproc();
    800050ec:	ffffc097          	auipc	ra,0xffffc
    800050f0:	d68080e7          	jalr	-664(ra) # 80000e54 <myproc>
    800050f4:	84aa                	mv	s1,a0

    argaddr(0, &fdarray);
    800050f6:	fd840593          	addi	a1,s0,-40
    800050fa:	4501                	li	a0,0
    800050fc:	ffffd097          	auipc	ra,0xffffd
    80005100:	e8e080e7          	jalr	-370(ra) # 80001f8a <argaddr>
    if (pipealloc(&rf, &wf) < 0)
    80005104:	fc840593          	addi	a1,s0,-56
    80005108:	fd040513          	addi	a0,s0,-48
    8000510c:	fffff097          	auipc	ra,0xfffff
    80005110:	d24080e7          	jalr	-732(ra) # 80003e30 <pipealloc>
        return -1;
    80005114:	57fd                	li	a5,-1
    if (pipealloc(&rf, &wf) < 0)
    80005116:	0c054463          	bltz	a0,800051de <sys_pipe+0xfc>
    fd0 = -1;
    8000511a:	fcf42223          	sw	a5,-60(s0)
    if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    8000511e:	fd043503          	ld	a0,-48(s0)
    80005122:	fffff097          	auipc	ra,0xfffff
    80005126:	476080e7          	jalr	1142(ra) # 80004598 <fdalloc>
    8000512a:	fca42223          	sw	a0,-60(s0)
    8000512e:	08054b63          	bltz	a0,800051c4 <sys_pipe+0xe2>
    80005132:	fc843503          	ld	a0,-56(s0)
    80005136:	fffff097          	auipc	ra,0xfffff
    8000513a:	462080e7          	jalr	1122(ra) # 80004598 <fdalloc>
    8000513e:	fca42023          	sw	a0,-64(s0)
    80005142:	06054863          	bltz	a0,800051b2 <sys_pipe+0xd0>
            p->ofile[fd0] = 0;
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 || copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0) {
    80005146:	4691                	li	a3,4
    80005148:	fc440613          	addi	a2,s0,-60
    8000514c:	fd843583          	ld	a1,-40(s0)
    80005150:	68a8                	ld	a0,80(s1)
    80005152:	ffffc097          	auipc	ra,0xffffc
    80005156:	9c2080e7          	jalr	-1598(ra) # 80000b14 <copyout>
    8000515a:	02054063          	bltz	a0,8000517a <sys_pipe+0x98>
    8000515e:	4691                	li	a3,4
    80005160:	fc040613          	addi	a2,s0,-64
    80005164:	fd843583          	ld	a1,-40(s0)
    80005168:	0591                	addi	a1,a1,4
    8000516a:	68a8                	ld	a0,80(s1)
    8000516c:	ffffc097          	auipc	ra,0xffffc
    80005170:	9a8080e7          	jalr	-1624(ra) # 80000b14 <copyout>
        p->ofile[fd1] = 0;
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    return 0;
    80005174:	4781                	li	a5,0
    if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 || copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0) {
    80005176:	06055463          	bgez	a0,800051de <sys_pipe+0xfc>
        p->ofile[fd0] = 0;
    8000517a:	fc442783          	lw	a5,-60(s0)
    8000517e:	07e9                	addi	a5,a5,26
    80005180:	078e                	slli	a5,a5,0x3
    80005182:	97a6                	add	a5,a5,s1
    80005184:	0007b023          	sd	zero,0(a5)
        p->ofile[fd1] = 0;
    80005188:	fc042783          	lw	a5,-64(s0)
    8000518c:	07e9                	addi	a5,a5,26
    8000518e:	078e                	slli	a5,a5,0x3
    80005190:	94be                	add	s1,s1,a5
    80005192:	0004b023          	sd	zero,0(s1)
        fileclose(rf);
    80005196:	fd043503          	ld	a0,-48(s0)
    8000519a:	fffff097          	auipc	ra,0xfffff
    8000519e:	966080e7          	jalr	-1690(ra) # 80003b00 <fileclose>
        fileclose(wf);
    800051a2:	fc843503          	ld	a0,-56(s0)
    800051a6:	fffff097          	auipc	ra,0xfffff
    800051aa:	95a080e7          	jalr	-1702(ra) # 80003b00 <fileclose>
        return -1;
    800051ae:	57fd                	li	a5,-1
    800051b0:	a03d                	j	800051de <sys_pipe+0xfc>
        if (fd0 >= 0)
    800051b2:	fc442783          	lw	a5,-60(s0)
    800051b6:	0007c763          	bltz	a5,800051c4 <sys_pipe+0xe2>
            p->ofile[fd0] = 0;
    800051ba:	07e9                	addi	a5,a5,26
    800051bc:	078e                	slli	a5,a5,0x3
    800051be:	97a6                	add	a5,a5,s1
    800051c0:	0007b023          	sd	zero,0(a5)
        fileclose(rf);
    800051c4:	fd043503          	ld	a0,-48(s0)
    800051c8:	fffff097          	auipc	ra,0xfffff
    800051cc:	938080e7          	jalr	-1736(ra) # 80003b00 <fileclose>
        fileclose(wf);
    800051d0:	fc843503          	ld	a0,-56(s0)
    800051d4:	fffff097          	auipc	ra,0xfffff
    800051d8:	92c080e7          	jalr	-1748(ra) # 80003b00 <fileclose>
        return -1;
    800051dc:	57fd                	li	a5,-1
}
    800051de:	853e                	mv	a0,a5
    800051e0:	70e2                	ld	ra,56(sp)
    800051e2:	7442                	ld	s0,48(sp)
    800051e4:	74a2                	ld	s1,40(sp)
    800051e6:	6121                	addi	sp,sp,64
    800051e8:	8082                	ret

00000000800051ea <sys_symlink>:

uint64 sys_symlink(void)
{
    800051ea:	712d                	addi	sp,sp,-288
    800051ec:	ee06                	sd	ra,280(sp)
    800051ee:	ea22                	sd	s0,272(sp)
    800051f0:	e626                	sd	s1,264(sp)
    800051f2:	1200                	addi	s0,sp,288
    char target[MAXPATH];
    char path[MAXPATH];
    argstr(0, target, MAXPATH);
    800051f4:	08000613          	li	a2,128
    800051f8:	f6040593          	addi	a1,s0,-160
    800051fc:	4501                	li	a0,0
    800051fe:	ffffd097          	auipc	ra,0xffffd
    80005202:	dac080e7          	jalr	-596(ra) # 80001faa <argstr>
    argstr(1, path, MAXPATH);
    80005206:	08000613          	li	a2,128
    8000520a:	ee040593          	addi	a1,s0,-288
    8000520e:	4505                	li	a0,1
    80005210:	ffffd097          	auipc	ra,0xffffd
    80005214:	d9a080e7          	jalr	-614(ra) # 80001faa <argstr>

    // begin_op一直保持等待直到日志系统当前未处于提交中
    // 并且直到有足够的未被占用的日志空间来保存此调用的写入
    begin_op();
    80005218:	ffffe097          	auipc	ra,0xffffe
    8000521c:	420080e7          	jalr	1056(ra) # 80003638 <begin_op>
    struct inode *ip = create(path, T_SYMLINK, 0, 0);
    80005220:	4681                	li	a3,0
    80005222:	4601                	li	a2,0
    80005224:	4591                	li	a1,4
    80005226:	ee040513          	addi	a0,s0,-288
    8000522a:	fffff097          	auipc	ra,0xfffff
    8000522e:	3b0080e7          	jalr	944(ra) # 800045da <create>
    if (ip == 0) {
    80005232:	cd1d                	beqz	a0,80005270 <sys_symlink+0x86>
    80005234:	84aa                	mv	s1,a0
        end_op();
        return -1;
    }

    if (writei(ip, 0, (uint64)target, 0, MAXPATH) < MAXPATH) //将目标地址存在inode的磁盘块里
    80005236:	08000713          	li	a4,128
    8000523a:	4681                	li	a3,0
    8000523c:	f6040613          	addi	a2,s0,-160
    80005240:	4581                	li	a1,0
    80005242:	ffffe097          	auipc	ra,0xffffe
    80005246:	dd4080e7          	jalr	-556(ra) # 80003016 <writei>
    8000524a:	07f00793          	li	a5,127
    8000524e:	02a7d763          	bge	a5,a0,8000527c <sys_symlink+0x92>
        iunlockput(ip);
        end_op(); // called at the end of each FS system call.
        return -1;
    }

    iunlockput(ip);
    80005252:	8526                	mv	a0,s1
    80005254:	ffffe097          	auipc	ra,0xffffe
    80005258:	c78080e7          	jalr	-904(ra) # 80002ecc <iunlockput>
    end_op();
    8000525c:	ffffe097          	auipc	ra,0xffffe
    80005260:	45a080e7          	jalr	1114(ra) # 800036b6 <end_op>
    return 0;
    80005264:	4501                	li	a0,0
    80005266:	60f2                	ld	ra,280(sp)
    80005268:	6452                	ld	s0,272(sp)
    8000526a:	64b2                	ld	s1,264(sp)
    8000526c:	6115                	addi	sp,sp,288
    8000526e:	8082                	ret
        end_op();
    80005270:	ffffe097          	auipc	ra,0xffffe
    80005274:	446080e7          	jalr	1094(ra) # 800036b6 <end_op>
        return -1;
    80005278:	557d                	li	a0,-1
    8000527a:	b7f5                	j	80005266 <sys_symlink+0x7c>
        iunlockput(ip);
    8000527c:	8526                	mv	a0,s1
    8000527e:	ffffe097          	auipc	ra,0xffffe
    80005282:	c4e080e7          	jalr	-946(ra) # 80002ecc <iunlockput>
        end_op(); // called at the end of each FS system call.
    80005286:	ffffe097          	auipc	ra,0xffffe
    8000528a:	430080e7          	jalr	1072(ra) # 800036b6 <end_op>
        return -1;
    8000528e:	557d                	li	a0,-1
    80005290:	bfd9                	j	80005266 <sys_symlink+0x7c>
	...

00000000800052a0 <kernelvec>:
    800052a0:	7111                	addi	sp,sp,-256
    800052a2:	e006                	sd	ra,0(sp)
    800052a4:	e40a                	sd	sp,8(sp)
    800052a6:	e80e                	sd	gp,16(sp)
    800052a8:	ec12                	sd	tp,24(sp)
    800052aa:	f016                	sd	t0,32(sp)
    800052ac:	f41a                	sd	t1,40(sp)
    800052ae:	f81e                	sd	t2,48(sp)
    800052b0:	fc22                	sd	s0,56(sp)
    800052b2:	e0a6                	sd	s1,64(sp)
    800052b4:	e4aa                	sd	a0,72(sp)
    800052b6:	e8ae                	sd	a1,80(sp)
    800052b8:	ecb2                	sd	a2,88(sp)
    800052ba:	f0b6                	sd	a3,96(sp)
    800052bc:	f4ba                	sd	a4,104(sp)
    800052be:	f8be                	sd	a5,112(sp)
    800052c0:	fcc2                	sd	a6,120(sp)
    800052c2:	e146                	sd	a7,128(sp)
    800052c4:	e54a                	sd	s2,136(sp)
    800052c6:	e94e                	sd	s3,144(sp)
    800052c8:	ed52                	sd	s4,152(sp)
    800052ca:	f156                	sd	s5,160(sp)
    800052cc:	f55a                	sd	s6,168(sp)
    800052ce:	f95e                	sd	s7,176(sp)
    800052d0:	fd62                	sd	s8,184(sp)
    800052d2:	e1e6                	sd	s9,192(sp)
    800052d4:	e5ea                	sd	s10,200(sp)
    800052d6:	e9ee                	sd	s11,208(sp)
    800052d8:	edf2                	sd	t3,216(sp)
    800052da:	f1f6                	sd	t4,224(sp)
    800052dc:	f5fa                	sd	t5,232(sp)
    800052de:	f9fe                	sd	t6,240(sp)
    800052e0:	ab9fc0ef          	jal	ra,80001d98 <kerneltrap>
    800052e4:	6082                	ld	ra,0(sp)
    800052e6:	6122                	ld	sp,8(sp)
    800052e8:	61c2                	ld	gp,16(sp)
    800052ea:	7282                	ld	t0,32(sp)
    800052ec:	7322                	ld	t1,40(sp)
    800052ee:	73c2                	ld	t2,48(sp)
    800052f0:	7462                	ld	s0,56(sp)
    800052f2:	6486                	ld	s1,64(sp)
    800052f4:	6526                	ld	a0,72(sp)
    800052f6:	65c6                	ld	a1,80(sp)
    800052f8:	6666                	ld	a2,88(sp)
    800052fa:	7686                	ld	a3,96(sp)
    800052fc:	7726                	ld	a4,104(sp)
    800052fe:	77c6                	ld	a5,112(sp)
    80005300:	7866                	ld	a6,120(sp)
    80005302:	688a                	ld	a7,128(sp)
    80005304:	692a                	ld	s2,136(sp)
    80005306:	69ca                	ld	s3,144(sp)
    80005308:	6a6a                	ld	s4,152(sp)
    8000530a:	7a8a                	ld	s5,160(sp)
    8000530c:	7b2a                	ld	s6,168(sp)
    8000530e:	7bca                	ld	s7,176(sp)
    80005310:	7c6a                	ld	s8,184(sp)
    80005312:	6c8e                	ld	s9,192(sp)
    80005314:	6d2e                	ld	s10,200(sp)
    80005316:	6dce                	ld	s11,208(sp)
    80005318:	6e6e                	ld	t3,216(sp)
    8000531a:	7e8e                	ld	t4,224(sp)
    8000531c:	7f2e                	ld	t5,232(sp)
    8000531e:	7fce                	ld	t6,240(sp)
    80005320:	6111                	addi	sp,sp,256
    80005322:	10200073          	sret
    80005326:	00000013          	nop
    8000532a:	00000013          	nop
    8000532e:	0001                	nop

0000000080005330 <timervec>:
    80005330:	34051573          	csrrw	a0,mscratch,a0
    80005334:	e10c                	sd	a1,0(a0)
    80005336:	e510                	sd	a2,8(a0)
    80005338:	e914                	sd	a3,16(a0)
    8000533a:	6d0c                	ld	a1,24(a0)
    8000533c:	7110                	ld	a2,32(a0)
    8000533e:	6194                	ld	a3,0(a1)
    80005340:	96b2                	add	a3,a3,a2
    80005342:	e194                	sd	a3,0(a1)
    80005344:	4589                	li	a1,2
    80005346:	14459073          	csrw	sip,a1
    8000534a:	6914                	ld	a3,16(a0)
    8000534c:	6510                	ld	a2,8(a0)
    8000534e:	610c                	ld	a1,0(a0)
    80005350:	34051573          	csrrw	a0,mscratch,a0
    80005354:	30200073          	mret
	...

000000008000535a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000535a:	1141                	addi	sp,sp,-16
    8000535c:	e422                	sd	s0,8(sp)
    8000535e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005360:	0c0007b7          	lui	a5,0xc000
    80005364:	4705                	li	a4,1
    80005366:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005368:	c3d8                	sw	a4,4(a5)
}
    8000536a:	6422                	ld	s0,8(sp)
    8000536c:	0141                	addi	sp,sp,16
    8000536e:	8082                	ret

0000000080005370 <plicinithart>:

void
plicinithart(void)
{
    80005370:	1141                	addi	sp,sp,-16
    80005372:	e406                	sd	ra,8(sp)
    80005374:	e022                	sd	s0,0(sp)
    80005376:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005378:	ffffc097          	auipc	ra,0xffffc
    8000537c:	ab0080e7          	jalr	-1360(ra) # 80000e28 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005380:	0085171b          	slliw	a4,a0,0x8
    80005384:	0c0027b7          	lui	a5,0xc002
    80005388:	97ba                	add	a5,a5,a4
    8000538a:	40200713          	li	a4,1026
    8000538e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005392:	00d5151b          	slliw	a0,a0,0xd
    80005396:	0c2017b7          	lui	a5,0xc201
    8000539a:	97aa                	add	a5,a5,a0
    8000539c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800053a0:	60a2                	ld	ra,8(sp)
    800053a2:	6402                	ld	s0,0(sp)
    800053a4:	0141                	addi	sp,sp,16
    800053a6:	8082                	ret

00000000800053a8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800053a8:	1141                	addi	sp,sp,-16
    800053aa:	e406                	sd	ra,8(sp)
    800053ac:	e022                	sd	s0,0(sp)
    800053ae:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053b0:	ffffc097          	auipc	ra,0xffffc
    800053b4:	a78080e7          	jalr	-1416(ra) # 80000e28 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800053b8:	00d5151b          	slliw	a0,a0,0xd
    800053bc:	0c2017b7          	lui	a5,0xc201
    800053c0:	97aa                	add	a5,a5,a0
  return irq;
}
    800053c2:	43c8                	lw	a0,4(a5)
    800053c4:	60a2                	ld	ra,8(sp)
    800053c6:	6402                	ld	s0,0(sp)
    800053c8:	0141                	addi	sp,sp,16
    800053ca:	8082                	ret

00000000800053cc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800053cc:	1101                	addi	sp,sp,-32
    800053ce:	ec06                	sd	ra,24(sp)
    800053d0:	e822                	sd	s0,16(sp)
    800053d2:	e426                	sd	s1,8(sp)
    800053d4:	1000                	addi	s0,sp,32
    800053d6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800053d8:	ffffc097          	auipc	ra,0xffffc
    800053dc:	a50080e7          	jalr	-1456(ra) # 80000e28 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800053e0:	00d5151b          	slliw	a0,a0,0xd
    800053e4:	0c2017b7          	lui	a5,0xc201
    800053e8:	97aa                	add	a5,a5,a0
    800053ea:	c3c4                	sw	s1,4(a5)
}
    800053ec:	60e2                	ld	ra,24(sp)
    800053ee:	6442                	ld	s0,16(sp)
    800053f0:	64a2                	ld	s1,8(sp)
    800053f2:	6105                	addi	sp,sp,32
    800053f4:	8082                	ret

00000000800053f6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800053f6:	1141                	addi	sp,sp,-16
    800053f8:	e406                	sd	ra,8(sp)
    800053fa:	e022                	sd	s0,0(sp)
    800053fc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800053fe:	479d                	li	a5,7
    80005400:	04a7cc63          	blt	a5,a0,80005458 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005404:	00010797          	auipc	a5,0x10
    80005408:	9ec78793          	addi	a5,a5,-1556 # 80014df0 <disk>
    8000540c:	97aa                	add	a5,a5,a0
    8000540e:	0187c783          	lbu	a5,24(a5)
    80005412:	ebb9                	bnez	a5,80005468 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005414:	00451693          	slli	a3,a0,0x4
    80005418:	00010797          	auipc	a5,0x10
    8000541c:	9d878793          	addi	a5,a5,-1576 # 80014df0 <disk>
    80005420:	6398                	ld	a4,0(a5)
    80005422:	9736                	add	a4,a4,a3
    80005424:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005428:	6398                	ld	a4,0(a5)
    8000542a:	9736                	add	a4,a4,a3
    8000542c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005430:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005434:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005438:	97aa                	add	a5,a5,a0
    8000543a:	4705                	li	a4,1
    8000543c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005440:	00010517          	auipc	a0,0x10
    80005444:	9c850513          	addi	a0,a0,-1592 # 80014e08 <disk+0x18>
    80005448:	ffffc097          	auipc	ra,0xffffc
    8000544c:	118080e7          	jalr	280(ra) # 80001560 <wakeup>
}
    80005450:	60a2                	ld	ra,8(sp)
    80005452:	6402                	ld	s0,0(sp)
    80005454:	0141                	addi	sp,sp,16
    80005456:	8082                	ret
    panic("free_desc 1");
    80005458:	00003517          	auipc	a0,0x3
    8000545c:	27050513          	addi	a0,a0,624 # 800086c8 <syscalls+0x2f8>
    80005460:	00001097          	auipc	ra,0x1
    80005464:	a0c080e7          	jalr	-1524(ra) # 80005e6c <panic>
    panic("free_desc 2");
    80005468:	00003517          	auipc	a0,0x3
    8000546c:	27050513          	addi	a0,a0,624 # 800086d8 <syscalls+0x308>
    80005470:	00001097          	auipc	ra,0x1
    80005474:	9fc080e7          	jalr	-1540(ra) # 80005e6c <panic>

0000000080005478 <virtio_disk_init>:
{
    80005478:	1101                	addi	sp,sp,-32
    8000547a:	ec06                	sd	ra,24(sp)
    8000547c:	e822                	sd	s0,16(sp)
    8000547e:	e426                	sd	s1,8(sp)
    80005480:	e04a                	sd	s2,0(sp)
    80005482:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005484:	00003597          	auipc	a1,0x3
    80005488:	26458593          	addi	a1,a1,612 # 800086e8 <syscalls+0x318>
    8000548c:	00010517          	auipc	a0,0x10
    80005490:	a8c50513          	addi	a0,a0,-1396 # 80014f18 <disk+0x128>
    80005494:	00001097          	auipc	ra,0x1
    80005498:	e80080e7          	jalr	-384(ra) # 80006314 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000549c:	100017b7          	lui	a5,0x10001
    800054a0:	4398                	lw	a4,0(a5)
    800054a2:	2701                	sext.w	a4,a4
    800054a4:	747277b7          	lui	a5,0x74727
    800054a8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800054ac:	14f71b63          	bne	a4,a5,80005602 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800054b0:	100017b7          	lui	a5,0x10001
    800054b4:	43dc                	lw	a5,4(a5)
    800054b6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054b8:	4709                	li	a4,2
    800054ba:	14e79463          	bne	a5,a4,80005602 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054be:	100017b7          	lui	a5,0x10001
    800054c2:	479c                	lw	a5,8(a5)
    800054c4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800054c6:	12e79e63          	bne	a5,a4,80005602 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800054ca:	100017b7          	lui	a5,0x10001
    800054ce:	47d8                	lw	a4,12(a5)
    800054d0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054d2:	554d47b7          	lui	a5,0x554d4
    800054d6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800054da:	12f71463          	bne	a4,a5,80005602 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054de:	100017b7          	lui	a5,0x10001
    800054e2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054e6:	4705                	li	a4,1
    800054e8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054ea:	470d                	li	a4,3
    800054ec:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800054ee:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800054f0:	c7ffe6b7          	lui	a3,0xc7ffe
    800054f4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fe15ef>
    800054f8:	8f75                	and	a4,a4,a3
    800054fa:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054fc:	472d                	li	a4,11
    800054fe:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005500:	5bbc                	lw	a5,112(a5)
    80005502:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005506:	8ba1                	andi	a5,a5,8
    80005508:	10078563          	beqz	a5,80005612 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000550c:	100017b7          	lui	a5,0x10001
    80005510:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005514:	43fc                	lw	a5,68(a5)
    80005516:	2781                	sext.w	a5,a5
    80005518:	10079563          	bnez	a5,80005622 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000551c:	100017b7          	lui	a5,0x10001
    80005520:	5bdc                	lw	a5,52(a5)
    80005522:	2781                	sext.w	a5,a5
  if(max == 0)
    80005524:	10078763          	beqz	a5,80005632 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005528:	471d                	li	a4,7
    8000552a:	10f77c63          	bgeu	a4,a5,80005642 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000552e:	ffffb097          	auipc	ra,0xffffb
    80005532:	bec080e7          	jalr	-1044(ra) # 8000011a <kalloc>
    80005536:	00010497          	auipc	s1,0x10
    8000553a:	8ba48493          	addi	s1,s1,-1862 # 80014df0 <disk>
    8000553e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005540:	ffffb097          	auipc	ra,0xffffb
    80005544:	bda080e7          	jalr	-1062(ra) # 8000011a <kalloc>
    80005548:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000554a:	ffffb097          	auipc	ra,0xffffb
    8000554e:	bd0080e7          	jalr	-1072(ra) # 8000011a <kalloc>
    80005552:	87aa                	mv	a5,a0
    80005554:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005556:	6088                	ld	a0,0(s1)
    80005558:	cd6d                	beqz	a0,80005652 <virtio_disk_init+0x1da>
    8000555a:	00010717          	auipc	a4,0x10
    8000555e:	89e73703          	ld	a4,-1890(a4) # 80014df8 <disk+0x8>
    80005562:	cb65                	beqz	a4,80005652 <virtio_disk_init+0x1da>
    80005564:	c7fd                	beqz	a5,80005652 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005566:	6605                	lui	a2,0x1
    80005568:	4581                	li	a1,0
    8000556a:	ffffb097          	auipc	ra,0xffffb
    8000556e:	c10080e7          	jalr	-1008(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    80005572:	00010497          	auipc	s1,0x10
    80005576:	87e48493          	addi	s1,s1,-1922 # 80014df0 <disk>
    8000557a:	6605                	lui	a2,0x1
    8000557c:	4581                	li	a1,0
    8000557e:	6488                	ld	a0,8(s1)
    80005580:	ffffb097          	auipc	ra,0xffffb
    80005584:	bfa080e7          	jalr	-1030(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    80005588:	6605                	lui	a2,0x1
    8000558a:	4581                	li	a1,0
    8000558c:	6888                	ld	a0,16(s1)
    8000558e:	ffffb097          	auipc	ra,0xffffb
    80005592:	bec080e7          	jalr	-1044(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005596:	100017b7          	lui	a5,0x10001
    8000559a:	4721                	li	a4,8
    8000559c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000559e:	4098                	lw	a4,0(s1)
    800055a0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800055a4:	40d8                	lw	a4,4(s1)
    800055a6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800055aa:	6498                	ld	a4,8(s1)
    800055ac:	0007069b          	sext.w	a3,a4
    800055b0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800055b4:	9701                	srai	a4,a4,0x20
    800055b6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800055ba:	6898                	ld	a4,16(s1)
    800055bc:	0007069b          	sext.w	a3,a4
    800055c0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800055c4:	9701                	srai	a4,a4,0x20
    800055c6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800055ca:	4705                	li	a4,1
    800055cc:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800055ce:	00e48c23          	sb	a4,24(s1)
    800055d2:	00e48ca3          	sb	a4,25(s1)
    800055d6:	00e48d23          	sb	a4,26(s1)
    800055da:	00e48da3          	sb	a4,27(s1)
    800055de:	00e48e23          	sb	a4,28(s1)
    800055e2:	00e48ea3          	sb	a4,29(s1)
    800055e6:	00e48f23          	sb	a4,30(s1)
    800055ea:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800055ee:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800055f2:	0727a823          	sw	s2,112(a5)
}
    800055f6:	60e2                	ld	ra,24(sp)
    800055f8:	6442                	ld	s0,16(sp)
    800055fa:	64a2                	ld	s1,8(sp)
    800055fc:	6902                	ld	s2,0(sp)
    800055fe:	6105                	addi	sp,sp,32
    80005600:	8082                	ret
    panic("could not find virtio disk");
    80005602:	00003517          	auipc	a0,0x3
    80005606:	0f650513          	addi	a0,a0,246 # 800086f8 <syscalls+0x328>
    8000560a:	00001097          	auipc	ra,0x1
    8000560e:	862080e7          	jalr	-1950(ra) # 80005e6c <panic>
    panic("virtio disk FEATURES_OK unset");
    80005612:	00003517          	auipc	a0,0x3
    80005616:	10650513          	addi	a0,a0,262 # 80008718 <syscalls+0x348>
    8000561a:	00001097          	auipc	ra,0x1
    8000561e:	852080e7          	jalr	-1966(ra) # 80005e6c <panic>
    panic("virtio disk should not be ready");
    80005622:	00003517          	auipc	a0,0x3
    80005626:	11650513          	addi	a0,a0,278 # 80008738 <syscalls+0x368>
    8000562a:	00001097          	auipc	ra,0x1
    8000562e:	842080e7          	jalr	-1982(ra) # 80005e6c <panic>
    panic("virtio disk has no queue 0");
    80005632:	00003517          	auipc	a0,0x3
    80005636:	12650513          	addi	a0,a0,294 # 80008758 <syscalls+0x388>
    8000563a:	00001097          	auipc	ra,0x1
    8000563e:	832080e7          	jalr	-1998(ra) # 80005e6c <panic>
    panic("virtio disk max queue too short");
    80005642:	00003517          	auipc	a0,0x3
    80005646:	13650513          	addi	a0,a0,310 # 80008778 <syscalls+0x3a8>
    8000564a:	00001097          	auipc	ra,0x1
    8000564e:	822080e7          	jalr	-2014(ra) # 80005e6c <panic>
    panic("virtio disk kalloc");
    80005652:	00003517          	auipc	a0,0x3
    80005656:	14650513          	addi	a0,a0,326 # 80008798 <syscalls+0x3c8>
    8000565a:	00001097          	auipc	ra,0x1
    8000565e:	812080e7          	jalr	-2030(ra) # 80005e6c <panic>

0000000080005662 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005662:	7119                	addi	sp,sp,-128
    80005664:	fc86                	sd	ra,120(sp)
    80005666:	f8a2                	sd	s0,112(sp)
    80005668:	f4a6                	sd	s1,104(sp)
    8000566a:	f0ca                	sd	s2,96(sp)
    8000566c:	ecce                	sd	s3,88(sp)
    8000566e:	e8d2                	sd	s4,80(sp)
    80005670:	e4d6                	sd	s5,72(sp)
    80005672:	e0da                	sd	s6,64(sp)
    80005674:	fc5e                	sd	s7,56(sp)
    80005676:	f862                	sd	s8,48(sp)
    80005678:	f466                	sd	s9,40(sp)
    8000567a:	f06a                	sd	s10,32(sp)
    8000567c:	ec6e                	sd	s11,24(sp)
    8000567e:	0100                	addi	s0,sp,128
    80005680:	8aaa                	mv	s5,a0
    80005682:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005684:	00c52d03          	lw	s10,12(a0)
    80005688:	001d1d1b          	slliw	s10,s10,0x1
    8000568c:	1d02                	slli	s10,s10,0x20
    8000568e:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80005692:	00010517          	auipc	a0,0x10
    80005696:	88650513          	addi	a0,a0,-1914 # 80014f18 <disk+0x128>
    8000569a:	00001097          	auipc	ra,0x1
    8000569e:	d0a080e7          	jalr	-758(ra) # 800063a4 <acquire>
  for(int i = 0; i < 3; i++){
    800056a2:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800056a4:	44a1                	li	s1,8
      disk.free[i] = 0;
    800056a6:	0000fb97          	auipc	s7,0xf
    800056aa:	74ab8b93          	addi	s7,s7,1866 # 80014df0 <disk>
  for(int i = 0; i < 3; i++){
    800056ae:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056b0:	00010c97          	auipc	s9,0x10
    800056b4:	868c8c93          	addi	s9,s9,-1944 # 80014f18 <disk+0x128>
    800056b8:	a08d                	j	8000571a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800056ba:	00fb8733          	add	a4,s7,a5
    800056be:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800056c2:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800056c4:	0207c563          	bltz	a5,800056ee <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800056c8:	2905                	addiw	s2,s2,1
    800056ca:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800056cc:	05690c63          	beq	s2,s6,80005724 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800056d0:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800056d2:	0000f717          	auipc	a4,0xf
    800056d6:	71e70713          	addi	a4,a4,1822 # 80014df0 <disk>
    800056da:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800056dc:	01874683          	lbu	a3,24(a4)
    800056e0:	fee9                	bnez	a3,800056ba <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800056e2:	2785                	addiw	a5,a5,1
    800056e4:	0705                	addi	a4,a4,1
    800056e6:	fe979be3          	bne	a5,s1,800056dc <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800056ea:	57fd                	li	a5,-1
    800056ec:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800056ee:	01205d63          	blez	s2,80005708 <virtio_disk_rw+0xa6>
    800056f2:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800056f4:	000a2503          	lw	a0,0(s4)
    800056f8:	00000097          	auipc	ra,0x0
    800056fc:	cfe080e7          	jalr	-770(ra) # 800053f6 <free_desc>
      for(int j = 0; j < i; j++)
    80005700:	2d85                	addiw	s11,s11,1
    80005702:	0a11                	addi	s4,s4,4
    80005704:	ff2d98e3          	bne	s11,s2,800056f4 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005708:	85e6                	mv	a1,s9
    8000570a:	0000f517          	auipc	a0,0xf
    8000570e:	6fe50513          	addi	a0,a0,1790 # 80014e08 <disk+0x18>
    80005712:	ffffc097          	auipc	ra,0xffffc
    80005716:	dea080e7          	jalr	-534(ra) # 800014fc <sleep>
  for(int i = 0; i < 3; i++){
    8000571a:	f8040a13          	addi	s4,s0,-128
{
    8000571e:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005720:	894e                	mv	s2,s3
    80005722:	b77d                	j	800056d0 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005724:	f8042503          	lw	a0,-128(s0)
    80005728:	00a50713          	addi	a4,a0,10
    8000572c:	0712                	slli	a4,a4,0x4

  if(write)
    8000572e:	0000f797          	auipc	a5,0xf
    80005732:	6c278793          	addi	a5,a5,1730 # 80014df0 <disk>
    80005736:	00e786b3          	add	a3,a5,a4
    8000573a:	01803633          	snez	a2,s8
    8000573e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005740:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005744:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005748:	f6070613          	addi	a2,a4,-160
    8000574c:	6394                	ld	a3,0(a5)
    8000574e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005750:	00870593          	addi	a1,a4,8
    80005754:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005756:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005758:	0007b803          	ld	a6,0(a5)
    8000575c:	9642                	add	a2,a2,a6
    8000575e:	46c1                	li	a3,16
    80005760:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005762:	4585                	li	a1,1
    80005764:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005768:	f8442683          	lw	a3,-124(s0)
    8000576c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005770:	0692                	slli	a3,a3,0x4
    80005772:	9836                	add	a6,a6,a3
    80005774:	058a8613          	addi	a2,s5,88
    80005778:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000577c:	0007b803          	ld	a6,0(a5)
    80005780:	96c2                	add	a3,a3,a6
    80005782:	40000613          	li	a2,1024
    80005786:	c690                	sw	a2,8(a3)
  if(write)
    80005788:	001c3613          	seqz	a2,s8
    8000578c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005790:	00166613          	ori	a2,a2,1
    80005794:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005798:	f8842603          	lw	a2,-120(s0)
    8000579c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800057a0:	00250693          	addi	a3,a0,2
    800057a4:	0692                	slli	a3,a3,0x4
    800057a6:	96be                	add	a3,a3,a5
    800057a8:	58fd                	li	a7,-1
    800057aa:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800057ae:	0612                	slli	a2,a2,0x4
    800057b0:	9832                	add	a6,a6,a2
    800057b2:	f9070713          	addi	a4,a4,-112
    800057b6:	973e                	add	a4,a4,a5
    800057b8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800057bc:	6398                	ld	a4,0(a5)
    800057be:	9732                	add	a4,a4,a2
    800057c0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800057c2:	4609                	li	a2,2
    800057c4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800057c8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800057cc:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    800057d0:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800057d4:	6794                	ld	a3,8(a5)
    800057d6:	0026d703          	lhu	a4,2(a3)
    800057da:	8b1d                	andi	a4,a4,7
    800057dc:	0706                	slli	a4,a4,0x1
    800057de:	96ba                	add	a3,a3,a4
    800057e0:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800057e4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800057e8:	6798                	ld	a4,8(a5)
    800057ea:	00275783          	lhu	a5,2(a4)
    800057ee:	2785                	addiw	a5,a5,1
    800057f0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800057f4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057f8:	100017b7          	lui	a5,0x10001
    800057fc:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005800:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    80005804:	0000f917          	auipc	s2,0xf
    80005808:	71490913          	addi	s2,s2,1812 # 80014f18 <disk+0x128>
  while(b->disk == 1) {
    8000580c:	4485                	li	s1,1
    8000580e:	00b79c63          	bne	a5,a1,80005826 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005812:	85ca                	mv	a1,s2
    80005814:	8556                	mv	a0,s5
    80005816:	ffffc097          	auipc	ra,0xffffc
    8000581a:	ce6080e7          	jalr	-794(ra) # 800014fc <sleep>
  while(b->disk == 1) {
    8000581e:	004aa783          	lw	a5,4(s5)
    80005822:	fe9788e3          	beq	a5,s1,80005812 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005826:	f8042903          	lw	s2,-128(s0)
    8000582a:	00290713          	addi	a4,s2,2
    8000582e:	0712                	slli	a4,a4,0x4
    80005830:	0000f797          	auipc	a5,0xf
    80005834:	5c078793          	addi	a5,a5,1472 # 80014df0 <disk>
    80005838:	97ba                	add	a5,a5,a4
    8000583a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000583e:	0000f997          	auipc	s3,0xf
    80005842:	5b298993          	addi	s3,s3,1458 # 80014df0 <disk>
    80005846:	00491713          	slli	a4,s2,0x4
    8000584a:	0009b783          	ld	a5,0(s3)
    8000584e:	97ba                	add	a5,a5,a4
    80005850:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005854:	854a                	mv	a0,s2
    80005856:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000585a:	00000097          	auipc	ra,0x0
    8000585e:	b9c080e7          	jalr	-1124(ra) # 800053f6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005862:	8885                	andi	s1,s1,1
    80005864:	f0ed                	bnez	s1,80005846 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005866:	0000f517          	auipc	a0,0xf
    8000586a:	6b250513          	addi	a0,a0,1714 # 80014f18 <disk+0x128>
    8000586e:	00001097          	auipc	ra,0x1
    80005872:	bea080e7          	jalr	-1046(ra) # 80006458 <release>
}
    80005876:	70e6                	ld	ra,120(sp)
    80005878:	7446                	ld	s0,112(sp)
    8000587a:	74a6                	ld	s1,104(sp)
    8000587c:	7906                	ld	s2,96(sp)
    8000587e:	69e6                	ld	s3,88(sp)
    80005880:	6a46                	ld	s4,80(sp)
    80005882:	6aa6                	ld	s5,72(sp)
    80005884:	6b06                	ld	s6,64(sp)
    80005886:	7be2                	ld	s7,56(sp)
    80005888:	7c42                	ld	s8,48(sp)
    8000588a:	7ca2                	ld	s9,40(sp)
    8000588c:	7d02                	ld	s10,32(sp)
    8000588e:	6de2                	ld	s11,24(sp)
    80005890:	6109                	addi	sp,sp,128
    80005892:	8082                	ret

0000000080005894 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005894:	1101                	addi	sp,sp,-32
    80005896:	ec06                	sd	ra,24(sp)
    80005898:	e822                	sd	s0,16(sp)
    8000589a:	e426                	sd	s1,8(sp)
    8000589c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000589e:	0000f497          	auipc	s1,0xf
    800058a2:	55248493          	addi	s1,s1,1362 # 80014df0 <disk>
    800058a6:	0000f517          	auipc	a0,0xf
    800058aa:	67250513          	addi	a0,a0,1650 # 80014f18 <disk+0x128>
    800058ae:	00001097          	auipc	ra,0x1
    800058b2:	af6080e7          	jalr	-1290(ra) # 800063a4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800058b6:	10001737          	lui	a4,0x10001
    800058ba:	533c                	lw	a5,96(a4)
    800058bc:	8b8d                	andi	a5,a5,3
    800058be:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800058c0:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800058c4:	689c                	ld	a5,16(s1)
    800058c6:	0204d703          	lhu	a4,32(s1)
    800058ca:	0027d783          	lhu	a5,2(a5)
    800058ce:	04f70863          	beq	a4,a5,8000591e <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800058d2:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058d6:	6898                	ld	a4,16(s1)
    800058d8:	0204d783          	lhu	a5,32(s1)
    800058dc:	8b9d                	andi	a5,a5,7
    800058de:	078e                	slli	a5,a5,0x3
    800058e0:	97ba                	add	a5,a5,a4
    800058e2:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800058e4:	00278713          	addi	a4,a5,2
    800058e8:	0712                	slli	a4,a4,0x4
    800058ea:	9726                	add	a4,a4,s1
    800058ec:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800058f0:	e721                	bnez	a4,80005938 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800058f2:	0789                	addi	a5,a5,2
    800058f4:	0792                	slli	a5,a5,0x4
    800058f6:	97a6                	add	a5,a5,s1
    800058f8:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800058fa:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800058fe:	ffffc097          	auipc	ra,0xffffc
    80005902:	c62080e7          	jalr	-926(ra) # 80001560 <wakeup>

    disk.used_idx += 1;
    80005906:	0204d783          	lhu	a5,32(s1)
    8000590a:	2785                	addiw	a5,a5,1
    8000590c:	17c2                	slli	a5,a5,0x30
    8000590e:	93c1                	srli	a5,a5,0x30
    80005910:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005914:	6898                	ld	a4,16(s1)
    80005916:	00275703          	lhu	a4,2(a4)
    8000591a:	faf71ce3          	bne	a4,a5,800058d2 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000591e:	0000f517          	auipc	a0,0xf
    80005922:	5fa50513          	addi	a0,a0,1530 # 80014f18 <disk+0x128>
    80005926:	00001097          	auipc	ra,0x1
    8000592a:	b32080e7          	jalr	-1230(ra) # 80006458 <release>
}
    8000592e:	60e2                	ld	ra,24(sp)
    80005930:	6442                	ld	s0,16(sp)
    80005932:	64a2                	ld	s1,8(sp)
    80005934:	6105                	addi	sp,sp,32
    80005936:	8082                	ret
      panic("virtio_disk_intr status");
    80005938:	00003517          	auipc	a0,0x3
    8000593c:	e7850513          	addi	a0,a0,-392 # 800087b0 <syscalls+0x3e0>
    80005940:	00000097          	auipc	ra,0x0
    80005944:	52c080e7          	jalr	1324(ra) # 80005e6c <panic>

0000000080005948 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005948:	1141                	addi	sp,sp,-16
    8000594a:	e422                	sd	s0,8(sp)
    8000594c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000594e:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005952:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005956:	0037979b          	slliw	a5,a5,0x3
    8000595a:	02004737          	lui	a4,0x2004
    8000595e:	97ba                	add	a5,a5,a4
    80005960:	0200c737          	lui	a4,0x200c
    80005964:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005968:	000f4637          	lui	a2,0xf4
    8000596c:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005970:	9732                	add	a4,a4,a2
    80005972:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005974:	00259693          	slli	a3,a1,0x2
    80005978:	96ae                	add	a3,a3,a1
    8000597a:	068e                	slli	a3,a3,0x3
    8000597c:	0000f717          	auipc	a4,0xf
    80005980:	5b470713          	addi	a4,a4,1460 # 80014f30 <timer_scratch>
    80005984:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005986:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005988:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000598a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000598e:	00000797          	auipc	a5,0x0
    80005992:	9a278793          	addi	a5,a5,-1630 # 80005330 <timervec>
    80005996:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000599a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000599e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059a2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800059a6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800059aa:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800059ae:	30479073          	csrw	mie,a5
}
    800059b2:	6422                	ld	s0,8(sp)
    800059b4:	0141                	addi	sp,sp,16
    800059b6:	8082                	ret

00000000800059b8 <start>:
{
    800059b8:	1141                	addi	sp,sp,-16
    800059ba:	e406                	sd	ra,8(sp)
    800059bc:	e022                	sd	s0,0(sp)
    800059be:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800059c0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800059c4:	7779                	lui	a4,0xffffe
    800059c6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffe168f>
    800059ca:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800059cc:	6705                	lui	a4,0x1
    800059ce:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800059d2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059d4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800059d8:	ffffb797          	auipc	a5,0xffffb
    800059dc:	94878793          	addi	a5,a5,-1720 # 80000320 <main>
    800059e0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800059e4:	4781                	li	a5,0
    800059e6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800059ea:	67c1                	lui	a5,0x10
    800059ec:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800059ee:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800059f2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800059f6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800059fa:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800059fe:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005a02:	57fd                	li	a5,-1
    80005a04:	83a9                	srli	a5,a5,0xa
    80005a06:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005a0a:	47bd                	li	a5,15
    80005a0c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005a10:	00000097          	auipc	ra,0x0
    80005a14:	f38080e7          	jalr	-200(ra) # 80005948 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005a18:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005a1c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005a1e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005a20:	30200073          	mret
}
    80005a24:	60a2                	ld	ra,8(sp)
    80005a26:	6402                	ld	s0,0(sp)
    80005a28:	0141                	addi	sp,sp,16
    80005a2a:	8082                	ret

0000000080005a2c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005a2c:	715d                	addi	sp,sp,-80
    80005a2e:	e486                	sd	ra,72(sp)
    80005a30:	e0a2                	sd	s0,64(sp)
    80005a32:	fc26                	sd	s1,56(sp)
    80005a34:	f84a                	sd	s2,48(sp)
    80005a36:	f44e                	sd	s3,40(sp)
    80005a38:	f052                	sd	s4,32(sp)
    80005a3a:	ec56                	sd	s5,24(sp)
    80005a3c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005a3e:	04c05763          	blez	a2,80005a8c <consolewrite+0x60>
    80005a42:	8a2a                	mv	s4,a0
    80005a44:	84ae                	mv	s1,a1
    80005a46:	89b2                	mv	s3,a2
    80005a48:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005a4a:	5afd                	li	s5,-1
    80005a4c:	4685                	li	a3,1
    80005a4e:	8626                	mv	a2,s1
    80005a50:	85d2                	mv	a1,s4
    80005a52:	fbf40513          	addi	a0,s0,-65
    80005a56:	ffffc097          	auipc	ra,0xffffc
    80005a5a:	f04080e7          	jalr	-252(ra) # 8000195a <either_copyin>
    80005a5e:	01550d63          	beq	a0,s5,80005a78 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005a62:	fbf44503          	lbu	a0,-65(s0)
    80005a66:	00000097          	auipc	ra,0x0
    80005a6a:	784080e7          	jalr	1924(ra) # 800061ea <uartputc>
  for(i = 0; i < n; i++){
    80005a6e:	2905                	addiw	s2,s2,1
    80005a70:	0485                	addi	s1,s1,1
    80005a72:	fd299de3          	bne	s3,s2,80005a4c <consolewrite+0x20>
    80005a76:	894e                	mv	s2,s3
  }

  return i;
}
    80005a78:	854a                	mv	a0,s2
    80005a7a:	60a6                	ld	ra,72(sp)
    80005a7c:	6406                	ld	s0,64(sp)
    80005a7e:	74e2                	ld	s1,56(sp)
    80005a80:	7942                	ld	s2,48(sp)
    80005a82:	79a2                	ld	s3,40(sp)
    80005a84:	7a02                	ld	s4,32(sp)
    80005a86:	6ae2                	ld	s5,24(sp)
    80005a88:	6161                	addi	sp,sp,80
    80005a8a:	8082                	ret
  for(i = 0; i < n; i++){
    80005a8c:	4901                	li	s2,0
    80005a8e:	b7ed                	j	80005a78 <consolewrite+0x4c>

0000000080005a90 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005a90:	7159                	addi	sp,sp,-112
    80005a92:	f486                	sd	ra,104(sp)
    80005a94:	f0a2                	sd	s0,96(sp)
    80005a96:	eca6                	sd	s1,88(sp)
    80005a98:	e8ca                	sd	s2,80(sp)
    80005a9a:	e4ce                	sd	s3,72(sp)
    80005a9c:	e0d2                	sd	s4,64(sp)
    80005a9e:	fc56                	sd	s5,56(sp)
    80005aa0:	f85a                	sd	s6,48(sp)
    80005aa2:	f45e                	sd	s7,40(sp)
    80005aa4:	f062                	sd	s8,32(sp)
    80005aa6:	ec66                	sd	s9,24(sp)
    80005aa8:	e86a                	sd	s10,16(sp)
    80005aaa:	1880                	addi	s0,sp,112
    80005aac:	8aaa                	mv	s5,a0
    80005aae:	8a2e                	mv	s4,a1
    80005ab0:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005ab2:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005ab6:	00017517          	auipc	a0,0x17
    80005aba:	5ba50513          	addi	a0,a0,1466 # 8001d070 <cons>
    80005abe:	00001097          	auipc	ra,0x1
    80005ac2:	8e6080e7          	jalr	-1818(ra) # 800063a4 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005ac6:	00017497          	auipc	s1,0x17
    80005aca:	5aa48493          	addi	s1,s1,1450 # 8001d070 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005ace:	00017917          	auipc	s2,0x17
    80005ad2:	63a90913          	addi	s2,s2,1594 # 8001d108 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005ad6:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005ad8:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005ada:	4ca9                	li	s9,10
  while(n > 0){
    80005adc:	07305b63          	blez	s3,80005b52 <consoleread+0xc2>
    while(cons.r == cons.w){
    80005ae0:	0984a783          	lw	a5,152(s1)
    80005ae4:	09c4a703          	lw	a4,156(s1)
    80005ae8:	02f71763          	bne	a4,a5,80005b16 <consoleread+0x86>
      if(killed(myproc())){
    80005aec:	ffffb097          	auipc	ra,0xffffb
    80005af0:	368080e7          	jalr	872(ra) # 80000e54 <myproc>
    80005af4:	ffffc097          	auipc	ra,0xffffc
    80005af8:	cb0080e7          	jalr	-848(ra) # 800017a4 <killed>
    80005afc:	e535                	bnez	a0,80005b68 <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    80005afe:	85a6                	mv	a1,s1
    80005b00:	854a                	mv	a0,s2
    80005b02:	ffffc097          	auipc	ra,0xffffc
    80005b06:	9fa080e7          	jalr	-1542(ra) # 800014fc <sleep>
    while(cons.r == cons.w){
    80005b0a:	0984a783          	lw	a5,152(s1)
    80005b0e:	09c4a703          	lw	a4,156(s1)
    80005b12:	fcf70de3          	beq	a4,a5,80005aec <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005b16:	0017871b          	addiw	a4,a5,1
    80005b1a:	08e4ac23          	sw	a4,152(s1)
    80005b1e:	07f7f713          	andi	a4,a5,127
    80005b22:	9726                	add	a4,a4,s1
    80005b24:	01874703          	lbu	a4,24(a4)
    80005b28:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005b2c:	077d0563          	beq	s10,s7,80005b96 <consoleread+0x106>
    cbuf = c;
    80005b30:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b34:	4685                	li	a3,1
    80005b36:	f9f40613          	addi	a2,s0,-97
    80005b3a:	85d2                	mv	a1,s4
    80005b3c:	8556                	mv	a0,s5
    80005b3e:	ffffc097          	auipc	ra,0xffffc
    80005b42:	dc6080e7          	jalr	-570(ra) # 80001904 <either_copyout>
    80005b46:	01850663          	beq	a0,s8,80005b52 <consoleread+0xc2>
    dst++;
    80005b4a:	0a05                	addi	s4,s4,1
    --n;
    80005b4c:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005b4e:	f99d17e3          	bne	s10,s9,80005adc <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005b52:	00017517          	auipc	a0,0x17
    80005b56:	51e50513          	addi	a0,a0,1310 # 8001d070 <cons>
    80005b5a:	00001097          	auipc	ra,0x1
    80005b5e:	8fe080e7          	jalr	-1794(ra) # 80006458 <release>

  return target - n;
    80005b62:	413b053b          	subw	a0,s6,s3
    80005b66:	a811                	j	80005b7a <consoleread+0xea>
        release(&cons.lock);
    80005b68:	00017517          	auipc	a0,0x17
    80005b6c:	50850513          	addi	a0,a0,1288 # 8001d070 <cons>
    80005b70:	00001097          	auipc	ra,0x1
    80005b74:	8e8080e7          	jalr	-1816(ra) # 80006458 <release>
        return -1;
    80005b78:	557d                	li	a0,-1
}
    80005b7a:	70a6                	ld	ra,104(sp)
    80005b7c:	7406                	ld	s0,96(sp)
    80005b7e:	64e6                	ld	s1,88(sp)
    80005b80:	6946                	ld	s2,80(sp)
    80005b82:	69a6                	ld	s3,72(sp)
    80005b84:	6a06                	ld	s4,64(sp)
    80005b86:	7ae2                	ld	s5,56(sp)
    80005b88:	7b42                	ld	s6,48(sp)
    80005b8a:	7ba2                	ld	s7,40(sp)
    80005b8c:	7c02                	ld	s8,32(sp)
    80005b8e:	6ce2                	ld	s9,24(sp)
    80005b90:	6d42                	ld	s10,16(sp)
    80005b92:	6165                	addi	sp,sp,112
    80005b94:	8082                	ret
      if(n < target){
    80005b96:	0009871b          	sext.w	a4,s3
    80005b9a:	fb677ce3          	bgeu	a4,s6,80005b52 <consoleread+0xc2>
        cons.r--;
    80005b9e:	00017717          	auipc	a4,0x17
    80005ba2:	56f72523          	sw	a5,1386(a4) # 8001d108 <cons+0x98>
    80005ba6:	b775                	j	80005b52 <consoleread+0xc2>

0000000080005ba8 <consputc>:
{
    80005ba8:	1141                	addi	sp,sp,-16
    80005baa:	e406                	sd	ra,8(sp)
    80005bac:	e022                	sd	s0,0(sp)
    80005bae:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005bb0:	10000793          	li	a5,256
    80005bb4:	00f50a63          	beq	a0,a5,80005bc8 <consputc+0x20>
    uartputc_sync(c);
    80005bb8:	00000097          	auipc	ra,0x0
    80005bbc:	560080e7          	jalr	1376(ra) # 80006118 <uartputc_sync>
}
    80005bc0:	60a2                	ld	ra,8(sp)
    80005bc2:	6402                	ld	s0,0(sp)
    80005bc4:	0141                	addi	sp,sp,16
    80005bc6:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005bc8:	4521                	li	a0,8
    80005bca:	00000097          	auipc	ra,0x0
    80005bce:	54e080e7          	jalr	1358(ra) # 80006118 <uartputc_sync>
    80005bd2:	02000513          	li	a0,32
    80005bd6:	00000097          	auipc	ra,0x0
    80005bda:	542080e7          	jalr	1346(ra) # 80006118 <uartputc_sync>
    80005bde:	4521                	li	a0,8
    80005be0:	00000097          	auipc	ra,0x0
    80005be4:	538080e7          	jalr	1336(ra) # 80006118 <uartputc_sync>
    80005be8:	bfe1                	j	80005bc0 <consputc+0x18>

0000000080005bea <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005bea:	1101                	addi	sp,sp,-32
    80005bec:	ec06                	sd	ra,24(sp)
    80005bee:	e822                	sd	s0,16(sp)
    80005bf0:	e426                	sd	s1,8(sp)
    80005bf2:	e04a                	sd	s2,0(sp)
    80005bf4:	1000                	addi	s0,sp,32
    80005bf6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005bf8:	00017517          	auipc	a0,0x17
    80005bfc:	47850513          	addi	a0,a0,1144 # 8001d070 <cons>
    80005c00:	00000097          	auipc	ra,0x0
    80005c04:	7a4080e7          	jalr	1956(ra) # 800063a4 <acquire>

  switch(c){
    80005c08:	47d5                	li	a5,21
    80005c0a:	0af48663          	beq	s1,a5,80005cb6 <consoleintr+0xcc>
    80005c0e:	0297ca63          	blt	a5,s1,80005c42 <consoleintr+0x58>
    80005c12:	47a1                	li	a5,8
    80005c14:	0ef48763          	beq	s1,a5,80005d02 <consoleintr+0x118>
    80005c18:	47c1                	li	a5,16
    80005c1a:	10f49a63          	bne	s1,a5,80005d2e <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005c1e:	ffffc097          	auipc	ra,0xffffc
    80005c22:	d92080e7          	jalr	-622(ra) # 800019b0 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005c26:	00017517          	auipc	a0,0x17
    80005c2a:	44a50513          	addi	a0,a0,1098 # 8001d070 <cons>
    80005c2e:	00001097          	auipc	ra,0x1
    80005c32:	82a080e7          	jalr	-2006(ra) # 80006458 <release>
}
    80005c36:	60e2                	ld	ra,24(sp)
    80005c38:	6442                	ld	s0,16(sp)
    80005c3a:	64a2                	ld	s1,8(sp)
    80005c3c:	6902                	ld	s2,0(sp)
    80005c3e:	6105                	addi	sp,sp,32
    80005c40:	8082                	ret
  switch(c){
    80005c42:	07f00793          	li	a5,127
    80005c46:	0af48e63          	beq	s1,a5,80005d02 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c4a:	00017717          	auipc	a4,0x17
    80005c4e:	42670713          	addi	a4,a4,1062 # 8001d070 <cons>
    80005c52:	0a072783          	lw	a5,160(a4)
    80005c56:	09872703          	lw	a4,152(a4)
    80005c5a:	9f99                	subw	a5,a5,a4
    80005c5c:	07f00713          	li	a4,127
    80005c60:	fcf763e3          	bltu	a4,a5,80005c26 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005c64:	47b5                	li	a5,13
    80005c66:	0cf48763          	beq	s1,a5,80005d34 <consoleintr+0x14a>
      consputc(c);
    80005c6a:	8526                	mv	a0,s1
    80005c6c:	00000097          	auipc	ra,0x0
    80005c70:	f3c080e7          	jalr	-196(ra) # 80005ba8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c74:	00017797          	auipc	a5,0x17
    80005c78:	3fc78793          	addi	a5,a5,1020 # 8001d070 <cons>
    80005c7c:	0a07a683          	lw	a3,160(a5)
    80005c80:	0016871b          	addiw	a4,a3,1
    80005c84:	0007061b          	sext.w	a2,a4
    80005c88:	0ae7a023          	sw	a4,160(a5)
    80005c8c:	07f6f693          	andi	a3,a3,127
    80005c90:	97b6                	add	a5,a5,a3
    80005c92:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005c96:	47a9                	li	a5,10
    80005c98:	0cf48563          	beq	s1,a5,80005d62 <consoleintr+0x178>
    80005c9c:	4791                	li	a5,4
    80005c9e:	0cf48263          	beq	s1,a5,80005d62 <consoleintr+0x178>
    80005ca2:	00017797          	auipc	a5,0x17
    80005ca6:	4667a783          	lw	a5,1126(a5) # 8001d108 <cons+0x98>
    80005caa:	9f1d                	subw	a4,a4,a5
    80005cac:	08000793          	li	a5,128
    80005cb0:	f6f71be3          	bne	a4,a5,80005c26 <consoleintr+0x3c>
    80005cb4:	a07d                	j	80005d62 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005cb6:	00017717          	auipc	a4,0x17
    80005cba:	3ba70713          	addi	a4,a4,954 # 8001d070 <cons>
    80005cbe:	0a072783          	lw	a5,160(a4)
    80005cc2:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005cc6:	00017497          	auipc	s1,0x17
    80005cca:	3aa48493          	addi	s1,s1,938 # 8001d070 <cons>
    while(cons.e != cons.w &&
    80005cce:	4929                	li	s2,10
    80005cd0:	f4f70be3          	beq	a4,a5,80005c26 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005cd4:	37fd                	addiw	a5,a5,-1
    80005cd6:	07f7f713          	andi	a4,a5,127
    80005cda:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005cdc:	01874703          	lbu	a4,24(a4)
    80005ce0:	f52703e3          	beq	a4,s2,80005c26 <consoleintr+0x3c>
      cons.e--;
    80005ce4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005ce8:	10000513          	li	a0,256
    80005cec:	00000097          	auipc	ra,0x0
    80005cf0:	ebc080e7          	jalr	-324(ra) # 80005ba8 <consputc>
    while(cons.e != cons.w &&
    80005cf4:	0a04a783          	lw	a5,160(s1)
    80005cf8:	09c4a703          	lw	a4,156(s1)
    80005cfc:	fcf71ce3          	bne	a4,a5,80005cd4 <consoleintr+0xea>
    80005d00:	b71d                	j	80005c26 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005d02:	00017717          	auipc	a4,0x17
    80005d06:	36e70713          	addi	a4,a4,878 # 8001d070 <cons>
    80005d0a:	0a072783          	lw	a5,160(a4)
    80005d0e:	09c72703          	lw	a4,156(a4)
    80005d12:	f0f70ae3          	beq	a4,a5,80005c26 <consoleintr+0x3c>
      cons.e--;
    80005d16:	37fd                	addiw	a5,a5,-1
    80005d18:	00017717          	auipc	a4,0x17
    80005d1c:	3ef72c23          	sw	a5,1016(a4) # 8001d110 <cons+0xa0>
      consputc(BACKSPACE);
    80005d20:	10000513          	li	a0,256
    80005d24:	00000097          	auipc	ra,0x0
    80005d28:	e84080e7          	jalr	-380(ra) # 80005ba8 <consputc>
    80005d2c:	bded                	j	80005c26 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005d2e:	ee048ce3          	beqz	s1,80005c26 <consoleintr+0x3c>
    80005d32:	bf21                	j	80005c4a <consoleintr+0x60>
      consputc(c);
    80005d34:	4529                	li	a0,10
    80005d36:	00000097          	auipc	ra,0x0
    80005d3a:	e72080e7          	jalr	-398(ra) # 80005ba8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005d3e:	00017797          	auipc	a5,0x17
    80005d42:	33278793          	addi	a5,a5,818 # 8001d070 <cons>
    80005d46:	0a07a703          	lw	a4,160(a5)
    80005d4a:	0017069b          	addiw	a3,a4,1
    80005d4e:	0006861b          	sext.w	a2,a3
    80005d52:	0ad7a023          	sw	a3,160(a5)
    80005d56:	07f77713          	andi	a4,a4,127
    80005d5a:	97ba                	add	a5,a5,a4
    80005d5c:	4729                	li	a4,10
    80005d5e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005d62:	00017797          	auipc	a5,0x17
    80005d66:	3ac7a523          	sw	a2,938(a5) # 8001d10c <cons+0x9c>
        wakeup(&cons.r);
    80005d6a:	00017517          	auipc	a0,0x17
    80005d6e:	39e50513          	addi	a0,a0,926 # 8001d108 <cons+0x98>
    80005d72:	ffffb097          	auipc	ra,0xffffb
    80005d76:	7ee080e7          	jalr	2030(ra) # 80001560 <wakeup>
    80005d7a:	b575                	j	80005c26 <consoleintr+0x3c>

0000000080005d7c <consoleinit>:

void
consoleinit(void)
{
    80005d7c:	1141                	addi	sp,sp,-16
    80005d7e:	e406                	sd	ra,8(sp)
    80005d80:	e022                	sd	s0,0(sp)
    80005d82:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005d84:	00003597          	auipc	a1,0x3
    80005d88:	a4458593          	addi	a1,a1,-1468 # 800087c8 <syscalls+0x3f8>
    80005d8c:	00017517          	auipc	a0,0x17
    80005d90:	2e450513          	addi	a0,a0,740 # 8001d070 <cons>
    80005d94:	00000097          	auipc	ra,0x0
    80005d98:	580080e7          	jalr	1408(ra) # 80006314 <initlock>

  uartinit();
    80005d9c:	00000097          	auipc	ra,0x0
    80005da0:	32c080e7          	jalr	812(ra) # 800060c8 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005da4:	0000e797          	auipc	a5,0xe
    80005da8:	ff478793          	addi	a5,a5,-12 # 80013d98 <devsw>
    80005dac:	00000717          	auipc	a4,0x0
    80005db0:	ce470713          	addi	a4,a4,-796 # 80005a90 <consoleread>
    80005db4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005db6:	00000717          	auipc	a4,0x0
    80005dba:	c7670713          	addi	a4,a4,-906 # 80005a2c <consolewrite>
    80005dbe:	ef98                	sd	a4,24(a5)
}
    80005dc0:	60a2                	ld	ra,8(sp)
    80005dc2:	6402                	ld	s0,0(sp)
    80005dc4:	0141                	addi	sp,sp,16
    80005dc6:	8082                	ret

0000000080005dc8 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005dc8:	7179                	addi	sp,sp,-48
    80005dca:	f406                	sd	ra,40(sp)
    80005dcc:	f022                	sd	s0,32(sp)
    80005dce:	ec26                	sd	s1,24(sp)
    80005dd0:	e84a                	sd	s2,16(sp)
    80005dd2:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005dd4:	c219                	beqz	a2,80005dda <printint+0x12>
    80005dd6:	08054763          	bltz	a0,80005e64 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005dda:	2501                	sext.w	a0,a0
    80005ddc:	4881                	li	a7,0
    80005dde:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005de2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005de4:	2581                	sext.w	a1,a1
    80005de6:	00003617          	auipc	a2,0x3
    80005dea:	a1260613          	addi	a2,a2,-1518 # 800087f8 <digits>
    80005dee:	883a                	mv	a6,a4
    80005df0:	2705                	addiw	a4,a4,1
    80005df2:	02b577bb          	remuw	a5,a0,a1
    80005df6:	1782                	slli	a5,a5,0x20
    80005df8:	9381                	srli	a5,a5,0x20
    80005dfa:	97b2                	add	a5,a5,a2
    80005dfc:	0007c783          	lbu	a5,0(a5)
    80005e00:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005e04:	0005079b          	sext.w	a5,a0
    80005e08:	02b5553b          	divuw	a0,a0,a1
    80005e0c:	0685                	addi	a3,a3,1
    80005e0e:	feb7f0e3          	bgeu	a5,a1,80005dee <printint+0x26>

  if(sign)
    80005e12:	00088c63          	beqz	a7,80005e2a <printint+0x62>
    buf[i++] = '-';
    80005e16:	fe070793          	addi	a5,a4,-32
    80005e1a:	00878733          	add	a4,a5,s0
    80005e1e:	02d00793          	li	a5,45
    80005e22:	fef70823          	sb	a5,-16(a4)
    80005e26:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005e2a:	02e05763          	blez	a4,80005e58 <printint+0x90>
    80005e2e:	fd040793          	addi	a5,s0,-48
    80005e32:	00e784b3          	add	s1,a5,a4
    80005e36:	fff78913          	addi	s2,a5,-1
    80005e3a:	993a                	add	s2,s2,a4
    80005e3c:	377d                	addiw	a4,a4,-1
    80005e3e:	1702                	slli	a4,a4,0x20
    80005e40:	9301                	srli	a4,a4,0x20
    80005e42:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005e46:	fff4c503          	lbu	a0,-1(s1)
    80005e4a:	00000097          	auipc	ra,0x0
    80005e4e:	d5e080e7          	jalr	-674(ra) # 80005ba8 <consputc>
  while(--i >= 0)
    80005e52:	14fd                	addi	s1,s1,-1
    80005e54:	ff2499e3          	bne	s1,s2,80005e46 <printint+0x7e>
}
    80005e58:	70a2                	ld	ra,40(sp)
    80005e5a:	7402                	ld	s0,32(sp)
    80005e5c:	64e2                	ld	s1,24(sp)
    80005e5e:	6942                	ld	s2,16(sp)
    80005e60:	6145                	addi	sp,sp,48
    80005e62:	8082                	ret
    x = -xx;
    80005e64:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005e68:	4885                	li	a7,1
    x = -xx;
    80005e6a:	bf95                	j	80005dde <printint+0x16>

0000000080005e6c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005e6c:	1101                	addi	sp,sp,-32
    80005e6e:	ec06                	sd	ra,24(sp)
    80005e70:	e822                	sd	s0,16(sp)
    80005e72:	e426                	sd	s1,8(sp)
    80005e74:	1000                	addi	s0,sp,32
    80005e76:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005e78:	00017797          	auipc	a5,0x17
    80005e7c:	2a07ac23          	sw	zero,696(a5) # 8001d130 <pr+0x18>
  printf("panic: ");
    80005e80:	00003517          	auipc	a0,0x3
    80005e84:	95050513          	addi	a0,a0,-1712 # 800087d0 <syscalls+0x400>
    80005e88:	00000097          	auipc	ra,0x0
    80005e8c:	02e080e7          	jalr	46(ra) # 80005eb6 <printf>
  printf(s);
    80005e90:	8526                	mv	a0,s1
    80005e92:	00000097          	auipc	ra,0x0
    80005e96:	024080e7          	jalr	36(ra) # 80005eb6 <printf>
  printf("\n");
    80005e9a:	00002517          	auipc	a0,0x2
    80005e9e:	1ae50513          	addi	a0,a0,430 # 80008048 <etext+0x48>
    80005ea2:	00000097          	auipc	ra,0x0
    80005ea6:	014080e7          	jalr	20(ra) # 80005eb6 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005eaa:	4785                	li	a5,1
    80005eac:	00003717          	auipc	a4,0x3
    80005eb0:	a2f72823          	sw	a5,-1488(a4) # 800088dc <panicked>
  for(;;)
    80005eb4:	a001                	j	80005eb4 <panic+0x48>

0000000080005eb6 <printf>:
{
    80005eb6:	7131                	addi	sp,sp,-192
    80005eb8:	fc86                	sd	ra,120(sp)
    80005eba:	f8a2                	sd	s0,112(sp)
    80005ebc:	f4a6                	sd	s1,104(sp)
    80005ebe:	f0ca                	sd	s2,96(sp)
    80005ec0:	ecce                	sd	s3,88(sp)
    80005ec2:	e8d2                	sd	s4,80(sp)
    80005ec4:	e4d6                	sd	s5,72(sp)
    80005ec6:	e0da                	sd	s6,64(sp)
    80005ec8:	fc5e                	sd	s7,56(sp)
    80005eca:	f862                	sd	s8,48(sp)
    80005ecc:	f466                	sd	s9,40(sp)
    80005ece:	f06a                	sd	s10,32(sp)
    80005ed0:	ec6e                	sd	s11,24(sp)
    80005ed2:	0100                	addi	s0,sp,128
    80005ed4:	8a2a                	mv	s4,a0
    80005ed6:	e40c                	sd	a1,8(s0)
    80005ed8:	e810                	sd	a2,16(s0)
    80005eda:	ec14                	sd	a3,24(s0)
    80005edc:	f018                	sd	a4,32(s0)
    80005ede:	f41c                	sd	a5,40(s0)
    80005ee0:	03043823          	sd	a6,48(s0)
    80005ee4:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005ee8:	00017d97          	auipc	s11,0x17
    80005eec:	248dad83          	lw	s11,584(s11) # 8001d130 <pr+0x18>
  if(locking)
    80005ef0:	020d9b63          	bnez	s11,80005f26 <printf+0x70>
  if (fmt == 0)
    80005ef4:	040a0263          	beqz	s4,80005f38 <printf+0x82>
  va_start(ap, fmt);
    80005ef8:	00840793          	addi	a5,s0,8
    80005efc:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f00:	000a4503          	lbu	a0,0(s4)
    80005f04:	14050f63          	beqz	a0,80006062 <printf+0x1ac>
    80005f08:	4981                	li	s3,0
    if(c != '%'){
    80005f0a:	02500a93          	li	s5,37
    switch(c){
    80005f0e:	07000b93          	li	s7,112
  consputc('x');
    80005f12:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f14:	00003b17          	auipc	s6,0x3
    80005f18:	8e4b0b13          	addi	s6,s6,-1820 # 800087f8 <digits>
    switch(c){
    80005f1c:	07300c93          	li	s9,115
    80005f20:	06400c13          	li	s8,100
    80005f24:	a82d                	j	80005f5e <printf+0xa8>
    acquire(&pr.lock);
    80005f26:	00017517          	auipc	a0,0x17
    80005f2a:	1f250513          	addi	a0,a0,498 # 8001d118 <pr>
    80005f2e:	00000097          	auipc	ra,0x0
    80005f32:	476080e7          	jalr	1142(ra) # 800063a4 <acquire>
    80005f36:	bf7d                	j	80005ef4 <printf+0x3e>
    panic("null fmt");
    80005f38:	00003517          	auipc	a0,0x3
    80005f3c:	8a850513          	addi	a0,a0,-1880 # 800087e0 <syscalls+0x410>
    80005f40:	00000097          	auipc	ra,0x0
    80005f44:	f2c080e7          	jalr	-212(ra) # 80005e6c <panic>
      consputc(c);
    80005f48:	00000097          	auipc	ra,0x0
    80005f4c:	c60080e7          	jalr	-928(ra) # 80005ba8 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f50:	2985                	addiw	s3,s3,1
    80005f52:	013a07b3          	add	a5,s4,s3
    80005f56:	0007c503          	lbu	a0,0(a5)
    80005f5a:	10050463          	beqz	a0,80006062 <printf+0x1ac>
    if(c != '%'){
    80005f5e:	ff5515e3          	bne	a0,s5,80005f48 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005f62:	2985                	addiw	s3,s3,1
    80005f64:	013a07b3          	add	a5,s4,s3
    80005f68:	0007c783          	lbu	a5,0(a5)
    80005f6c:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005f70:	cbed                	beqz	a5,80006062 <printf+0x1ac>
    switch(c){
    80005f72:	05778a63          	beq	a5,s7,80005fc6 <printf+0x110>
    80005f76:	02fbf663          	bgeu	s7,a5,80005fa2 <printf+0xec>
    80005f7a:	09978863          	beq	a5,s9,8000600a <printf+0x154>
    80005f7e:	07800713          	li	a4,120
    80005f82:	0ce79563          	bne	a5,a4,8000604c <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005f86:	f8843783          	ld	a5,-120(s0)
    80005f8a:	00878713          	addi	a4,a5,8
    80005f8e:	f8e43423          	sd	a4,-120(s0)
    80005f92:	4605                	li	a2,1
    80005f94:	85ea                	mv	a1,s10
    80005f96:	4388                	lw	a0,0(a5)
    80005f98:	00000097          	auipc	ra,0x0
    80005f9c:	e30080e7          	jalr	-464(ra) # 80005dc8 <printint>
      break;
    80005fa0:	bf45                	j	80005f50 <printf+0x9a>
    switch(c){
    80005fa2:	09578f63          	beq	a5,s5,80006040 <printf+0x18a>
    80005fa6:	0b879363          	bne	a5,s8,8000604c <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005faa:	f8843783          	ld	a5,-120(s0)
    80005fae:	00878713          	addi	a4,a5,8
    80005fb2:	f8e43423          	sd	a4,-120(s0)
    80005fb6:	4605                	li	a2,1
    80005fb8:	45a9                	li	a1,10
    80005fba:	4388                	lw	a0,0(a5)
    80005fbc:	00000097          	auipc	ra,0x0
    80005fc0:	e0c080e7          	jalr	-500(ra) # 80005dc8 <printint>
      break;
    80005fc4:	b771                	j	80005f50 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005fc6:	f8843783          	ld	a5,-120(s0)
    80005fca:	00878713          	addi	a4,a5,8
    80005fce:	f8e43423          	sd	a4,-120(s0)
    80005fd2:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005fd6:	03000513          	li	a0,48
    80005fda:	00000097          	auipc	ra,0x0
    80005fde:	bce080e7          	jalr	-1074(ra) # 80005ba8 <consputc>
  consputc('x');
    80005fe2:	07800513          	li	a0,120
    80005fe6:	00000097          	auipc	ra,0x0
    80005fea:	bc2080e7          	jalr	-1086(ra) # 80005ba8 <consputc>
    80005fee:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ff0:	03c95793          	srli	a5,s2,0x3c
    80005ff4:	97da                	add	a5,a5,s6
    80005ff6:	0007c503          	lbu	a0,0(a5)
    80005ffa:	00000097          	auipc	ra,0x0
    80005ffe:	bae080e7          	jalr	-1106(ra) # 80005ba8 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006002:	0912                	slli	s2,s2,0x4
    80006004:	34fd                	addiw	s1,s1,-1
    80006006:	f4ed                	bnez	s1,80005ff0 <printf+0x13a>
    80006008:	b7a1                	j	80005f50 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    8000600a:	f8843783          	ld	a5,-120(s0)
    8000600e:	00878713          	addi	a4,a5,8
    80006012:	f8e43423          	sd	a4,-120(s0)
    80006016:	6384                	ld	s1,0(a5)
    80006018:	cc89                	beqz	s1,80006032 <printf+0x17c>
      for(; *s; s++)
    8000601a:	0004c503          	lbu	a0,0(s1)
    8000601e:	d90d                	beqz	a0,80005f50 <printf+0x9a>
        consputc(*s);
    80006020:	00000097          	auipc	ra,0x0
    80006024:	b88080e7          	jalr	-1144(ra) # 80005ba8 <consputc>
      for(; *s; s++)
    80006028:	0485                	addi	s1,s1,1
    8000602a:	0004c503          	lbu	a0,0(s1)
    8000602e:	f96d                	bnez	a0,80006020 <printf+0x16a>
    80006030:	b705                	j	80005f50 <printf+0x9a>
        s = "(null)";
    80006032:	00002497          	auipc	s1,0x2
    80006036:	7a648493          	addi	s1,s1,1958 # 800087d8 <syscalls+0x408>
      for(; *s; s++)
    8000603a:	02800513          	li	a0,40
    8000603e:	b7cd                	j	80006020 <printf+0x16a>
      consputc('%');
    80006040:	8556                	mv	a0,s5
    80006042:	00000097          	auipc	ra,0x0
    80006046:	b66080e7          	jalr	-1178(ra) # 80005ba8 <consputc>
      break;
    8000604a:	b719                	j	80005f50 <printf+0x9a>
      consputc('%');
    8000604c:	8556                	mv	a0,s5
    8000604e:	00000097          	auipc	ra,0x0
    80006052:	b5a080e7          	jalr	-1190(ra) # 80005ba8 <consputc>
      consputc(c);
    80006056:	8526                	mv	a0,s1
    80006058:	00000097          	auipc	ra,0x0
    8000605c:	b50080e7          	jalr	-1200(ra) # 80005ba8 <consputc>
      break;
    80006060:	bdc5                	j	80005f50 <printf+0x9a>
  if(locking)
    80006062:	020d9163          	bnez	s11,80006084 <printf+0x1ce>
}
    80006066:	70e6                	ld	ra,120(sp)
    80006068:	7446                	ld	s0,112(sp)
    8000606a:	74a6                	ld	s1,104(sp)
    8000606c:	7906                	ld	s2,96(sp)
    8000606e:	69e6                	ld	s3,88(sp)
    80006070:	6a46                	ld	s4,80(sp)
    80006072:	6aa6                	ld	s5,72(sp)
    80006074:	6b06                	ld	s6,64(sp)
    80006076:	7be2                	ld	s7,56(sp)
    80006078:	7c42                	ld	s8,48(sp)
    8000607a:	7ca2                	ld	s9,40(sp)
    8000607c:	7d02                	ld	s10,32(sp)
    8000607e:	6de2                	ld	s11,24(sp)
    80006080:	6129                	addi	sp,sp,192
    80006082:	8082                	ret
    release(&pr.lock);
    80006084:	00017517          	auipc	a0,0x17
    80006088:	09450513          	addi	a0,a0,148 # 8001d118 <pr>
    8000608c:	00000097          	auipc	ra,0x0
    80006090:	3cc080e7          	jalr	972(ra) # 80006458 <release>
}
    80006094:	bfc9                	j	80006066 <printf+0x1b0>

0000000080006096 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006096:	1101                	addi	sp,sp,-32
    80006098:	ec06                	sd	ra,24(sp)
    8000609a:	e822                	sd	s0,16(sp)
    8000609c:	e426                	sd	s1,8(sp)
    8000609e:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800060a0:	00017497          	auipc	s1,0x17
    800060a4:	07848493          	addi	s1,s1,120 # 8001d118 <pr>
    800060a8:	00002597          	auipc	a1,0x2
    800060ac:	74858593          	addi	a1,a1,1864 # 800087f0 <syscalls+0x420>
    800060b0:	8526                	mv	a0,s1
    800060b2:	00000097          	auipc	ra,0x0
    800060b6:	262080e7          	jalr	610(ra) # 80006314 <initlock>
  pr.locking = 1;
    800060ba:	4785                	li	a5,1
    800060bc:	cc9c                	sw	a5,24(s1)
}
    800060be:	60e2                	ld	ra,24(sp)
    800060c0:	6442                	ld	s0,16(sp)
    800060c2:	64a2                	ld	s1,8(sp)
    800060c4:	6105                	addi	sp,sp,32
    800060c6:	8082                	ret

00000000800060c8 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800060c8:	1141                	addi	sp,sp,-16
    800060ca:	e406                	sd	ra,8(sp)
    800060cc:	e022                	sd	s0,0(sp)
    800060ce:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800060d0:	100007b7          	lui	a5,0x10000
    800060d4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800060d8:	f8000713          	li	a4,-128
    800060dc:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800060e0:	470d                	li	a4,3
    800060e2:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800060e6:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800060ea:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800060ee:	469d                	li	a3,7
    800060f0:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800060f4:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800060f8:	00002597          	auipc	a1,0x2
    800060fc:	71858593          	addi	a1,a1,1816 # 80008810 <digits+0x18>
    80006100:	00017517          	auipc	a0,0x17
    80006104:	03850513          	addi	a0,a0,56 # 8001d138 <uart_tx_lock>
    80006108:	00000097          	auipc	ra,0x0
    8000610c:	20c080e7          	jalr	524(ra) # 80006314 <initlock>
}
    80006110:	60a2                	ld	ra,8(sp)
    80006112:	6402                	ld	s0,0(sp)
    80006114:	0141                	addi	sp,sp,16
    80006116:	8082                	ret

0000000080006118 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006118:	1101                	addi	sp,sp,-32
    8000611a:	ec06                	sd	ra,24(sp)
    8000611c:	e822                	sd	s0,16(sp)
    8000611e:	e426                	sd	s1,8(sp)
    80006120:	1000                	addi	s0,sp,32
    80006122:	84aa                	mv	s1,a0
  push_off();
    80006124:	00000097          	auipc	ra,0x0
    80006128:	234080e7          	jalr	564(ra) # 80006358 <push_off>

  if(panicked){
    8000612c:	00002797          	auipc	a5,0x2
    80006130:	7b07a783          	lw	a5,1968(a5) # 800088dc <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006134:	10000737          	lui	a4,0x10000
  if(panicked){
    80006138:	c391                	beqz	a5,8000613c <uartputc_sync+0x24>
    for(;;)
    8000613a:	a001                	j	8000613a <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000613c:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006140:	0207f793          	andi	a5,a5,32
    80006144:	dfe5                	beqz	a5,8000613c <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006146:	0ff4f513          	zext.b	a0,s1
    8000614a:	100007b7          	lui	a5,0x10000
    8000614e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006152:	00000097          	auipc	ra,0x0
    80006156:	2a6080e7          	jalr	678(ra) # 800063f8 <pop_off>
}
    8000615a:	60e2                	ld	ra,24(sp)
    8000615c:	6442                	ld	s0,16(sp)
    8000615e:	64a2                	ld	s1,8(sp)
    80006160:	6105                	addi	sp,sp,32
    80006162:	8082                	ret

0000000080006164 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006164:	00002797          	auipc	a5,0x2
    80006168:	77c7b783          	ld	a5,1916(a5) # 800088e0 <uart_tx_r>
    8000616c:	00002717          	auipc	a4,0x2
    80006170:	77c73703          	ld	a4,1916(a4) # 800088e8 <uart_tx_w>
    80006174:	06f70a63          	beq	a4,a5,800061e8 <uartstart+0x84>
{
    80006178:	7139                	addi	sp,sp,-64
    8000617a:	fc06                	sd	ra,56(sp)
    8000617c:	f822                	sd	s0,48(sp)
    8000617e:	f426                	sd	s1,40(sp)
    80006180:	f04a                	sd	s2,32(sp)
    80006182:	ec4e                	sd	s3,24(sp)
    80006184:	e852                	sd	s4,16(sp)
    80006186:	e456                	sd	s5,8(sp)
    80006188:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000618a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000618e:	00017a17          	auipc	s4,0x17
    80006192:	faaa0a13          	addi	s4,s4,-86 # 8001d138 <uart_tx_lock>
    uart_tx_r += 1;
    80006196:	00002497          	auipc	s1,0x2
    8000619a:	74a48493          	addi	s1,s1,1866 # 800088e0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000619e:	00002997          	auipc	s3,0x2
    800061a2:	74a98993          	addi	s3,s3,1866 # 800088e8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061a6:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800061aa:	02077713          	andi	a4,a4,32
    800061ae:	c705                	beqz	a4,800061d6 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061b0:	01f7f713          	andi	a4,a5,31
    800061b4:	9752                	add	a4,a4,s4
    800061b6:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800061ba:	0785                	addi	a5,a5,1
    800061bc:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800061be:	8526                	mv	a0,s1
    800061c0:	ffffb097          	auipc	ra,0xffffb
    800061c4:	3a0080e7          	jalr	928(ra) # 80001560 <wakeup>
    
    WriteReg(THR, c);
    800061c8:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800061cc:	609c                	ld	a5,0(s1)
    800061ce:	0009b703          	ld	a4,0(s3)
    800061d2:	fcf71ae3          	bne	a4,a5,800061a6 <uartstart+0x42>
  }
}
    800061d6:	70e2                	ld	ra,56(sp)
    800061d8:	7442                	ld	s0,48(sp)
    800061da:	74a2                	ld	s1,40(sp)
    800061dc:	7902                	ld	s2,32(sp)
    800061de:	69e2                	ld	s3,24(sp)
    800061e0:	6a42                	ld	s4,16(sp)
    800061e2:	6aa2                	ld	s5,8(sp)
    800061e4:	6121                	addi	sp,sp,64
    800061e6:	8082                	ret
    800061e8:	8082                	ret

00000000800061ea <uartputc>:
{
    800061ea:	7179                	addi	sp,sp,-48
    800061ec:	f406                	sd	ra,40(sp)
    800061ee:	f022                	sd	s0,32(sp)
    800061f0:	ec26                	sd	s1,24(sp)
    800061f2:	e84a                	sd	s2,16(sp)
    800061f4:	e44e                	sd	s3,8(sp)
    800061f6:	e052                	sd	s4,0(sp)
    800061f8:	1800                	addi	s0,sp,48
    800061fa:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800061fc:	00017517          	auipc	a0,0x17
    80006200:	f3c50513          	addi	a0,a0,-196 # 8001d138 <uart_tx_lock>
    80006204:	00000097          	auipc	ra,0x0
    80006208:	1a0080e7          	jalr	416(ra) # 800063a4 <acquire>
  if(panicked){
    8000620c:	00002797          	auipc	a5,0x2
    80006210:	6d07a783          	lw	a5,1744(a5) # 800088dc <panicked>
    80006214:	e7c9                	bnez	a5,8000629e <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006216:	00002717          	auipc	a4,0x2
    8000621a:	6d273703          	ld	a4,1746(a4) # 800088e8 <uart_tx_w>
    8000621e:	00002797          	auipc	a5,0x2
    80006222:	6c27b783          	ld	a5,1730(a5) # 800088e0 <uart_tx_r>
    80006226:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000622a:	00017997          	auipc	s3,0x17
    8000622e:	f0e98993          	addi	s3,s3,-242 # 8001d138 <uart_tx_lock>
    80006232:	00002497          	auipc	s1,0x2
    80006236:	6ae48493          	addi	s1,s1,1710 # 800088e0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000623a:	00002917          	auipc	s2,0x2
    8000623e:	6ae90913          	addi	s2,s2,1710 # 800088e8 <uart_tx_w>
    80006242:	00e79f63          	bne	a5,a4,80006260 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006246:	85ce                	mv	a1,s3
    80006248:	8526                	mv	a0,s1
    8000624a:	ffffb097          	auipc	ra,0xffffb
    8000624e:	2b2080e7          	jalr	690(ra) # 800014fc <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006252:	00093703          	ld	a4,0(s2)
    80006256:	609c                	ld	a5,0(s1)
    80006258:	02078793          	addi	a5,a5,32
    8000625c:	fee785e3          	beq	a5,a4,80006246 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006260:	00017497          	auipc	s1,0x17
    80006264:	ed848493          	addi	s1,s1,-296 # 8001d138 <uart_tx_lock>
    80006268:	01f77793          	andi	a5,a4,31
    8000626c:	97a6                	add	a5,a5,s1
    8000626e:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006272:	0705                	addi	a4,a4,1
    80006274:	00002797          	auipc	a5,0x2
    80006278:	66e7ba23          	sd	a4,1652(a5) # 800088e8 <uart_tx_w>
  uartstart();
    8000627c:	00000097          	auipc	ra,0x0
    80006280:	ee8080e7          	jalr	-280(ra) # 80006164 <uartstart>
  release(&uart_tx_lock);
    80006284:	8526                	mv	a0,s1
    80006286:	00000097          	auipc	ra,0x0
    8000628a:	1d2080e7          	jalr	466(ra) # 80006458 <release>
}
    8000628e:	70a2                	ld	ra,40(sp)
    80006290:	7402                	ld	s0,32(sp)
    80006292:	64e2                	ld	s1,24(sp)
    80006294:	6942                	ld	s2,16(sp)
    80006296:	69a2                	ld	s3,8(sp)
    80006298:	6a02                	ld	s4,0(sp)
    8000629a:	6145                	addi	sp,sp,48
    8000629c:	8082                	ret
    for(;;)
    8000629e:	a001                	j	8000629e <uartputc+0xb4>

00000000800062a0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800062a0:	1141                	addi	sp,sp,-16
    800062a2:	e422                	sd	s0,8(sp)
    800062a4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800062a6:	100007b7          	lui	a5,0x10000
    800062aa:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800062ae:	8b85                	andi	a5,a5,1
    800062b0:	cb81                	beqz	a5,800062c0 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800062b2:	100007b7          	lui	a5,0x10000
    800062b6:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800062ba:	6422                	ld	s0,8(sp)
    800062bc:	0141                	addi	sp,sp,16
    800062be:	8082                	ret
    return -1;
    800062c0:	557d                	li	a0,-1
    800062c2:	bfe5                	j	800062ba <uartgetc+0x1a>

00000000800062c4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800062c4:	1101                	addi	sp,sp,-32
    800062c6:	ec06                	sd	ra,24(sp)
    800062c8:	e822                	sd	s0,16(sp)
    800062ca:	e426                	sd	s1,8(sp)
    800062cc:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800062ce:	54fd                	li	s1,-1
    800062d0:	a029                	j	800062da <uartintr+0x16>
      break;
    consoleintr(c);
    800062d2:	00000097          	auipc	ra,0x0
    800062d6:	918080e7          	jalr	-1768(ra) # 80005bea <consoleintr>
    int c = uartgetc();
    800062da:	00000097          	auipc	ra,0x0
    800062de:	fc6080e7          	jalr	-58(ra) # 800062a0 <uartgetc>
    if(c == -1)
    800062e2:	fe9518e3          	bne	a0,s1,800062d2 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800062e6:	00017497          	auipc	s1,0x17
    800062ea:	e5248493          	addi	s1,s1,-430 # 8001d138 <uart_tx_lock>
    800062ee:	8526                	mv	a0,s1
    800062f0:	00000097          	auipc	ra,0x0
    800062f4:	0b4080e7          	jalr	180(ra) # 800063a4 <acquire>
  uartstart();
    800062f8:	00000097          	auipc	ra,0x0
    800062fc:	e6c080e7          	jalr	-404(ra) # 80006164 <uartstart>
  release(&uart_tx_lock);
    80006300:	8526                	mv	a0,s1
    80006302:	00000097          	auipc	ra,0x0
    80006306:	156080e7          	jalr	342(ra) # 80006458 <release>
}
    8000630a:	60e2                	ld	ra,24(sp)
    8000630c:	6442                	ld	s0,16(sp)
    8000630e:	64a2                	ld	s1,8(sp)
    80006310:	6105                	addi	sp,sp,32
    80006312:	8082                	ret

0000000080006314 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006314:	1141                	addi	sp,sp,-16
    80006316:	e422                	sd	s0,8(sp)
    80006318:	0800                	addi	s0,sp,16
  lk->name = name;
    8000631a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000631c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006320:	00053823          	sd	zero,16(a0)
}
    80006324:	6422                	ld	s0,8(sp)
    80006326:	0141                	addi	sp,sp,16
    80006328:	8082                	ret

000000008000632a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000632a:	411c                	lw	a5,0(a0)
    8000632c:	e399                	bnez	a5,80006332 <holding+0x8>
    8000632e:	4501                	li	a0,0
  return r;
}
    80006330:	8082                	ret
{
    80006332:	1101                	addi	sp,sp,-32
    80006334:	ec06                	sd	ra,24(sp)
    80006336:	e822                	sd	s0,16(sp)
    80006338:	e426                	sd	s1,8(sp)
    8000633a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000633c:	6904                	ld	s1,16(a0)
    8000633e:	ffffb097          	auipc	ra,0xffffb
    80006342:	afa080e7          	jalr	-1286(ra) # 80000e38 <mycpu>
    80006346:	40a48533          	sub	a0,s1,a0
    8000634a:	00153513          	seqz	a0,a0
}
    8000634e:	60e2                	ld	ra,24(sp)
    80006350:	6442                	ld	s0,16(sp)
    80006352:	64a2                	ld	s1,8(sp)
    80006354:	6105                	addi	sp,sp,32
    80006356:	8082                	ret

0000000080006358 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006358:	1101                	addi	sp,sp,-32
    8000635a:	ec06                	sd	ra,24(sp)
    8000635c:	e822                	sd	s0,16(sp)
    8000635e:	e426                	sd	s1,8(sp)
    80006360:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006362:	100024f3          	csrr	s1,sstatus
    80006366:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000636a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000636c:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006370:	ffffb097          	auipc	ra,0xffffb
    80006374:	ac8080e7          	jalr	-1336(ra) # 80000e38 <mycpu>
    80006378:	5d3c                	lw	a5,120(a0)
    8000637a:	cf89                	beqz	a5,80006394 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000637c:	ffffb097          	auipc	ra,0xffffb
    80006380:	abc080e7          	jalr	-1348(ra) # 80000e38 <mycpu>
    80006384:	5d3c                	lw	a5,120(a0)
    80006386:	2785                	addiw	a5,a5,1
    80006388:	dd3c                	sw	a5,120(a0)
}
    8000638a:	60e2                	ld	ra,24(sp)
    8000638c:	6442                	ld	s0,16(sp)
    8000638e:	64a2                	ld	s1,8(sp)
    80006390:	6105                	addi	sp,sp,32
    80006392:	8082                	ret
    mycpu()->intena = old;
    80006394:	ffffb097          	auipc	ra,0xffffb
    80006398:	aa4080e7          	jalr	-1372(ra) # 80000e38 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000639c:	8085                	srli	s1,s1,0x1
    8000639e:	8885                	andi	s1,s1,1
    800063a0:	dd64                	sw	s1,124(a0)
    800063a2:	bfe9                	j	8000637c <push_off+0x24>

00000000800063a4 <acquire>:
{
    800063a4:	1101                	addi	sp,sp,-32
    800063a6:	ec06                	sd	ra,24(sp)
    800063a8:	e822                	sd	s0,16(sp)
    800063aa:	e426                	sd	s1,8(sp)
    800063ac:	1000                	addi	s0,sp,32
    800063ae:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800063b0:	00000097          	auipc	ra,0x0
    800063b4:	fa8080e7          	jalr	-88(ra) # 80006358 <push_off>
  if(holding(lk))
    800063b8:	8526                	mv	a0,s1
    800063ba:	00000097          	auipc	ra,0x0
    800063be:	f70080e7          	jalr	-144(ra) # 8000632a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063c2:	4705                	li	a4,1
  if(holding(lk))
    800063c4:	e115                	bnez	a0,800063e8 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063c6:	87ba                	mv	a5,a4
    800063c8:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800063cc:	2781                	sext.w	a5,a5
    800063ce:	ffe5                	bnez	a5,800063c6 <acquire+0x22>
  __sync_synchronize();
    800063d0:	0ff0000f          	fence
  lk->cpu = mycpu();
    800063d4:	ffffb097          	auipc	ra,0xffffb
    800063d8:	a64080e7          	jalr	-1436(ra) # 80000e38 <mycpu>
    800063dc:	e888                	sd	a0,16(s1)
}
    800063de:	60e2                	ld	ra,24(sp)
    800063e0:	6442                	ld	s0,16(sp)
    800063e2:	64a2                	ld	s1,8(sp)
    800063e4:	6105                	addi	sp,sp,32
    800063e6:	8082                	ret
    panic("acquire");
    800063e8:	00002517          	auipc	a0,0x2
    800063ec:	43050513          	addi	a0,a0,1072 # 80008818 <digits+0x20>
    800063f0:	00000097          	auipc	ra,0x0
    800063f4:	a7c080e7          	jalr	-1412(ra) # 80005e6c <panic>

00000000800063f8 <pop_off>:

void
pop_off(void)
{
    800063f8:	1141                	addi	sp,sp,-16
    800063fa:	e406                	sd	ra,8(sp)
    800063fc:	e022                	sd	s0,0(sp)
    800063fe:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006400:	ffffb097          	auipc	ra,0xffffb
    80006404:	a38080e7          	jalr	-1480(ra) # 80000e38 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006408:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000640c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000640e:	e78d                	bnez	a5,80006438 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006410:	5d3c                	lw	a5,120(a0)
    80006412:	02f05b63          	blez	a5,80006448 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006416:	37fd                	addiw	a5,a5,-1
    80006418:	0007871b          	sext.w	a4,a5
    8000641c:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000641e:	eb09                	bnez	a4,80006430 <pop_off+0x38>
    80006420:	5d7c                	lw	a5,124(a0)
    80006422:	c799                	beqz	a5,80006430 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006424:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006428:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000642c:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006430:	60a2                	ld	ra,8(sp)
    80006432:	6402                	ld	s0,0(sp)
    80006434:	0141                	addi	sp,sp,16
    80006436:	8082                	ret
    panic("pop_off - interruptible");
    80006438:	00002517          	auipc	a0,0x2
    8000643c:	3e850513          	addi	a0,a0,1000 # 80008820 <digits+0x28>
    80006440:	00000097          	auipc	ra,0x0
    80006444:	a2c080e7          	jalr	-1492(ra) # 80005e6c <panic>
    panic("pop_off");
    80006448:	00002517          	auipc	a0,0x2
    8000644c:	3f050513          	addi	a0,a0,1008 # 80008838 <digits+0x40>
    80006450:	00000097          	auipc	ra,0x0
    80006454:	a1c080e7          	jalr	-1508(ra) # 80005e6c <panic>

0000000080006458 <release>:
{
    80006458:	1101                	addi	sp,sp,-32
    8000645a:	ec06                	sd	ra,24(sp)
    8000645c:	e822                	sd	s0,16(sp)
    8000645e:	e426                	sd	s1,8(sp)
    80006460:	1000                	addi	s0,sp,32
    80006462:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006464:	00000097          	auipc	ra,0x0
    80006468:	ec6080e7          	jalr	-314(ra) # 8000632a <holding>
    8000646c:	c115                	beqz	a0,80006490 <release+0x38>
  lk->cpu = 0;
    8000646e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006472:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006476:	0f50000f          	fence	iorw,ow
    8000647a:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000647e:	00000097          	auipc	ra,0x0
    80006482:	f7a080e7          	jalr	-134(ra) # 800063f8 <pop_off>
}
    80006486:	60e2                	ld	ra,24(sp)
    80006488:	6442                	ld	s0,16(sp)
    8000648a:	64a2                	ld	s1,8(sp)
    8000648c:	6105                	addi	sp,sp,32
    8000648e:	8082                	ret
    panic("release");
    80006490:	00002517          	auipc	a0,0x2
    80006494:	3b050513          	addi	a0,a0,944 # 80008840 <digits+0x48>
    80006498:	00000097          	auipc	ra,0x0
    8000649c:	9d4080e7          	jalr	-1580(ra) # 80005e6c <panic>
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
