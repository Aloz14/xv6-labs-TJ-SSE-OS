
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8c013103          	ld	sp,-1856(sp) # 800088c0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	7c2050ef          	jal	ra,800057d8 <start>

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
    80000030:	00022797          	auipc	a5,0x22
    80000034:	35078793          	addi	a5,a5,848 # 80022380 <end>
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
    80000054:	8c090913          	addi	s2,s2,-1856 # 80008910 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	1ce080e7          	jalr	462(ra) # 80006228 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	26e080e7          	jalr	622(ra) # 800062dc <release>
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
    8000008e:	c90080e7          	jalr	-880(ra) # 80005d1a <panic>

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
    800000f2:	82250513          	addi	a0,a0,-2014 # 80008910 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	0a2080e7          	jalr	162(ra) # 80006198 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00022517          	auipc	a0,0x22
    80000106:	27e50513          	addi	a0,a0,638 # 80022380 <end>
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
    80000128:	7ec48493          	addi	s1,s1,2028 # 80008910 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	0fa080e7          	jalr	250(ra) # 80006228 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00008517          	auipc	a0,0x8
    80000140:	7d450513          	addi	a0,a0,2004 # 80008910 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	196080e7          	jalr	406(ra) # 800062dc <release>

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
    8000016c:	7a850513          	addi	a0,a0,1960 # 80008910 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	16c080e7          	jalr	364(ra) # 800062dc <release>
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
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdcc81>
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
    80000334:	5b070713          	addi	a4,a4,1456 # 800088e0 <started>
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
    8000035a:	a16080e7          	jalr	-1514(ra) # 80005d6c <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00001097          	auipc	ra,0x1
    8000036a:	798080e7          	jalr	1944(ra) # 80001afe <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	e22080e7          	jalr	-478(ra) # 80005190 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	fe0080e7          	jalr	-32(ra) # 80001356 <scheduler>
    consoleinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	81e080e7          	jalr	-2018(ra) # 80005b9c <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	906080e7          	jalr	-1786(ra) # 80005c8c <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	9d6080e7          	jalr	-1578(ra) # 80005d6c <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	9c6080e7          	jalr	-1594(ra) # 80005d6c <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	9b6080e7          	jalr	-1610(ra) # 80005d6c <printf>
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
    800003e2:	6f8080e7          	jalr	1784(ra) # 80001ad6 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e6:	00001097          	auipc	ra,0x1
    800003ea:	718080e7          	jalr	1816(ra) # 80001afe <trapinithart>
    plicinit();      // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	d8c080e7          	jalr	-628(ra) # 8000517a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	d9a080e7          	jalr	-614(ra) # 80005190 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	f2e080e7          	jalr	-210(ra) # 8000232c <binit>
    iinit();         // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	5ce080e7          	jalr	1486(ra) # 800029d4 <iinit>
    fileinit();      // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	574080e7          	jalr	1396(ra) # 80003982 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	e82080e7          	jalr	-382(ra) # 80005298 <virtio_disk_init>
    userinit();      // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	d1a080e7          	jalr	-742(ra) # 80001138 <userinit>
    __sync_synchronize();
    80000426:	0ff0000f          	fence
    started = 1;
    8000042a:	4785                	li	a5,1
    8000042c:	00008717          	auipc	a4,0x8
    80000430:	4af72a23          	sw	a5,1204(a4) # 800088e0 <started>
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
static inline void sfence_vma()
{
    // the zero, zero means flush all TLB entries.
    asm volatile("sfence.vma zero, zero");
    8000043c:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000440:	00008797          	auipc	a5,0x8
    80000444:	4a87b783          	ld	a5,1192(a5) # 800088e8 <kernel_pagetable>
    80000448:	83b1                	srli	a5,a5,0xc
    8000044a:	577d                	li	a4,-1
    8000044c:	177e                	slli	a4,a4,0x3f
    8000044e:	8fd9                	or	a5,a5,a4
    asm volatile("csrw satp, %0" : : "r"(x));
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
    80000490:	88e080e7          	jalr	-1906(ra) # 80005d1a <panic>
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
    800004be:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdcc77>
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
    800005b2:	00005097          	auipc	ra,0x5
    800005b6:	768080e7          	jalr	1896(ra) # 80005d1a <panic>
      panic("mappages: remap");
    800005ba:	00008517          	auipc	a0,0x8
    800005be:	aae50513          	addi	a0,a0,-1362 # 80008068 <etext+0x68>
    800005c2:	00005097          	auipc	ra,0x5
    800005c6:	758080e7          	jalr	1880(ra) # 80005d1a <panic>
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
    8000060e:	00005097          	auipc	ra,0x5
    80000612:	70c080e7          	jalr	1804(ra) # 80005d1a <panic>

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
    80000700:	1ea7b623          	sd	a0,492(a5) # 800088e8 <kernel_pagetable>
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
    8000075e:	5c0080e7          	jalr	1472(ra) # 80005d1a <panic>
      panic("uvmunmap: walk");
    80000762:	00008517          	auipc	a0,0x8
    80000766:	93650513          	addi	a0,a0,-1738 # 80008098 <etext+0x98>
    8000076a:	00005097          	auipc	ra,0x5
    8000076e:	5b0080e7          	jalr	1456(ra) # 80005d1a <panic>
      panic("uvmunmap: not mapped");
    80000772:	00008517          	auipc	a0,0x8
    80000776:	93650513          	addi	a0,a0,-1738 # 800080a8 <etext+0xa8>
    8000077a:	00005097          	auipc	ra,0x5
    8000077e:	5a0080e7          	jalr	1440(ra) # 80005d1a <panic>
      panic("uvmunmap: not a leaf");
    80000782:	00008517          	auipc	a0,0x8
    80000786:	93e50513          	addi	a0,a0,-1730 # 800080c0 <etext+0xc0>
    8000078a:	00005097          	auipc	ra,0x5
    8000078e:	590080e7          	jalr	1424(ra) # 80005d1a <panic>
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
    8000086c:	4b2080e7          	jalr	1202(ra) # 80005d1a <panic>

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
    800009b8:	366080e7          	jalr	870(ra) # 80005d1a <panic>
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
    80000a96:	288080e7          	jalr	648(ra) # 80005d1a <panic>
      panic("uvmcopy: page not present");
    80000a9a:	00007517          	auipc	a0,0x7
    80000a9e:	68e50513          	addi	a0,a0,1678 # 80008128 <etext+0x128>
    80000aa2:	00005097          	auipc	ra,0x5
    80000aa6:	278080e7          	jalr	632(ra) # 80005d1a <panic>
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
    80000b10:	20e080e7          	jalr	526(ra) # 80005d1a <panic>

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
    80000cb4:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdcc80>
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
void proc_mapstacks(pagetable_t kpgtbl)
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

    for (p = proc; p < &proc[NPROC]; p++) {
    80000cf4:	00008497          	auipc	s1,0x8
    80000cf8:	06c48493          	addi	s1,s1,108 # 80008d60 <proc>
        char *pa = kalloc();
        if (pa == 0)
            panic("kalloc");
        uint64 va = KSTACK((int)(p - proc));
    80000cfc:	8b26                	mv	s6,s1
    80000cfe:	00007a97          	auipc	s5,0x7
    80000d02:	302a8a93          	addi	s5,s5,770 # 80008000 <etext>
    80000d06:	04000937          	lui	s2,0x4000
    80000d0a:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d0c:	0932                	slli	s2,s2,0xc
    for (p = proc; p < &proc[NPROC]; p++) {
    80000d0e:	0000ea17          	auipc	s4,0xe
    80000d12:	052a0a13          	addi	s4,s4,82 # 8000ed60 <tickslock>
        char *pa = kalloc();
    80000d16:	fffff097          	auipc	ra,0xfffff
    80000d1a:	404080e7          	jalr	1028(ra) # 8000011a <kalloc>
    80000d1e:	862a                	mv	a2,a0
        if (pa == 0)
    80000d20:	c131                	beqz	a0,80000d64 <proc_mapstacks+0x86>
        uint64 va = KSTACK((int)(p - proc));
    80000d22:	416485b3          	sub	a1,s1,s6
    80000d26:	859d                	srai	a1,a1,0x7
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
    for (p = proc; p < &proc[NPROC]; p++) {
    80000d48:	18048493          	addi	s1,s1,384
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
    80000d70:	fae080e7          	jalr	-82(ra) # 80005d1a <panic>

0000000080000d74 <procinit>:

// initialize the proc table.
void procinit(void)
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
    80000d94:	ba050513          	addi	a0,a0,-1120 # 80008930 <pid_lock>
    80000d98:	00005097          	auipc	ra,0x5
    80000d9c:	400080e7          	jalr	1024(ra) # 80006198 <initlock>
    initlock(&wait_lock, "wait_lock");
    80000da0:	00007597          	auipc	a1,0x7
    80000da4:	3c858593          	addi	a1,a1,968 # 80008168 <etext+0x168>
    80000da8:	00008517          	auipc	a0,0x8
    80000dac:	ba050513          	addi	a0,a0,-1120 # 80008948 <wait_lock>
    80000db0:	00005097          	auipc	ra,0x5
    80000db4:	3e8080e7          	jalr	1000(ra) # 80006198 <initlock>
    for (p = proc; p < &proc[NPROC]; p++) {
    80000db8:	00008497          	auipc	s1,0x8
    80000dbc:	fa848493          	addi	s1,s1,-88 # 80008d60 <proc>
        initlock(&p->lock, "proc");
    80000dc0:	00007b17          	auipc	s6,0x7
    80000dc4:	3b8b0b13          	addi	s6,s6,952 # 80008178 <etext+0x178>
        p->state = UNUSED;
        p->kstack = KSTACK((int)(p - proc));
    80000dc8:	8aa6                	mv	s5,s1
    80000dca:	00007a17          	auipc	s4,0x7
    80000dce:	236a0a13          	addi	s4,s4,566 # 80008000 <etext>
    80000dd2:	04000937          	lui	s2,0x4000
    80000dd6:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000dd8:	0932                	slli	s2,s2,0xc
    for (p = proc; p < &proc[NPROC]; p++) {
    80000dda:	0000e997          	auipc	s3,0xe
    80000dde:	f8698993          	addi	s3,s3,-122 # 8000ed60 <tickslock>
        initlock(&p->lock, "proc");
    80000de2:	85da                	mv	a1,s6
    80000de4:	8526                	mv	a0,s1
    80000de6:	00005097          	auipc	ra,0x5
    80000dea:	3b2080e7          	jalr	946(ra) # 80006198 <initlock>
        p->state = UNUSED;
    80000dee:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int)(p - proc));
    80000df2:	415487b3          	sub	a5,s1,s5
    80000df6:	879d                	srai	a5,a5,0x7
    80000df8:	000a3703          	ld	a4,0(s4)
    80000dfc:	02e787b3          	mul	a5,a5,a4
    80000e00:	2785                	addiw	a5,a5,1
    80000e02:	00d7979b          	slliw	a5,a5,0xd
    80000e06:	40f907b3          	sub	a5,s2,a5
    80000e0a:	e0bc                	sd	a5,64(s1)
    for (p = proc; p < &proc[NPROC]; p++) {
    80000e0c:	18048493          	addi	s1,s1,384
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
int cpuid()
{
    80000e28:	1141                	addi	sp,sp,-16
    80000e2a:	e422                	sd	s0,8(sp)
    80000e2c:	0800                	addi	s0,sp,16
    asm volatile("mv %0, tp" : "=r"(x));
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
struct cpu *mycpu(void)
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
    80000e48:	b1c50513          	addi	a0,a0,-1252 # 80008960 <cpus>
    80000e4c:	953e                	add	a0,a0,a5
    80000e4e:	6422                	ld	s0,8(sp)
    80000e50:	0141                	addi	sp,sp,16
    80000e52:	8082                	ret

0000000080000e54 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *myproc(void)
{
    80000e54:	1101                	addi	sp,sp,-32
    80000e56:	ec06                	sd	ra,24(sp)
    80000e58:	e822                	sd	s0,16(sp)
    80000e5a:	e426                	sd	s1,8(sp)
    80000e5c:	1000                	addi	s0,sp,32
    push_off();
    80000e5e:	00005097          	auipc	ra,0x5
    80000e62:	37e080e7          	jalr	894(ra) # 800061dc <push_off>
    80000e66:	8792                	mv	a5,tp
    struct cpu *c = mycpu();
    struct proc *p = c->proc;
    80000e68:	2781                	sext.w	a5,a5
    80000e6a:	079e                	slli	a5,a5,0x7
    80000e6c:	00008717          	auipc	a4,0x8
    80000e70:	ac470713          	addi	a4,a4,-1340 # 80008930 <pid_lock>
    80000e74:	97ba                	add	a5,a5,a4
    80000e76:	7b84                	ld	s1,48(a5)
    pop_off();
    80000e78:	00005097          	auipc	ra,0x5
    80000e7c:	404080e7          	jalr	1028(ra) # 8000627c <pop_off>
    return p;
}
    80000e80:	8526                	mv	a0,s1
    80000e82:	60e2                	ld	ra,24(sp)
    80000e84:	6442                	ld	s0,16(sp)
    80000e86:	64a2                	ld	s1,8(sp)
    80000e88:	6105                	addi	sp,sp,32
    80000e8a:	8082                	ret

0000000080000e8c <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
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
    80000ea0:	440080e7          	jalr	1088(ra) # 800062dc <release>

    if (first) {
    80000ea4:	00008797          	auipc	a5,0x8
    80000ea8:	9cc7a783          	lw	a5,-1588(a5) # 80008870 <first.1>
    80000eac:	eb89                	bnez	a5,80000ebe <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80000eae:	00001097          	auipc	ra,0x1
    80000eb2:	c68080e7          	jalr	-920(ra) # 80001b16 <usertrapret>
}
    80000eb6:	60a2                	ld	ra,8(sp)
    80000eb8:	6402                	ld	s0,0(sp)
    80000eba:	0141                	addi	sp,sp,16
    80000ebc:	8082                	ret
        first = 0;
    80000ebe:	00008797          	auipc	a5,0x8
    80000ec2:	9a07a923          	sw	zero,-1614(a5) # 80008870 <first.1>
        fsinit(ROOTDEV);
    80000ec6:	4505                	li	a0,1
    80000ec8:	00002097          	auipc	ra,0x2
    80000ecc:	a8c080e7          	jalr	-1396(ra) # 80002954 <fsinit>
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
    80000ee2:	a5290913          	addi	s2,s2,-1454 # 80008930 <pid_lock>
    80000ee6:	854a                	mv	a0,s2
    80000ee8:	00005097          	auipc	ra,0x5
    80000eec:	340080e7          	jalr	832(ra) # 80006228 <acquire>
    pid = nextpid;
    80000ef0:	00008797          	auipc	a5,0x8
    80000ef4:	98478793          	addi	a5,a5,-1660 # 80008874 <nextpid>
    80000ef8:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80000efa:	0014871b          	addiw	a4,s1,1
    80000efe:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80000f00:	854a                	mv	a0,s2
    80000f02:	00005097          	auipc	ra,0x5
    80000f06:	3da080e7          	jalr	986(ra) # 800062dc <release>
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
    if (pagetable == 0)
    80000f30:	c121                	beqz	a0,80000f70 <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline, PTE_R | PTE_X) < 0) {
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
    if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe), PTE_R | PTE_W) < 0) {
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
    if (p->trapframe)
    80001012:	6d28                	ld	a0,88(a0)
    80001014:	c509                	beqz	a0,8000101e <freeproc+0x18>
        kfree((void *)p->trapframe);
    80001016:	fffff097          	auipc	ra,0xfffff
    8000101a:	006080e7          	jalr	6(ra) # 8000001c <kfree>
    p->trapframe = 0;
    8000101e:	0404bc23          	sd	zero,88(s1)
    if (p->pagetable)
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
    for (p = proc; p < &proc[NPROC]; p++) {
    8000106a:	00008497          	auipc	s1,0x8
    8000106e:	cf648493          	addi	s1,s1,-778 # 80008d60 <proc>
    80001072:	0000e917          	auipc	s2,0xe
    80001076:	cee90913          	addi	s2,s2,-786 # 8000ed60 <tickslock>
        acquire(&p->lock);
    8000107a:	8526                	mv	a0,s1
    8000107c:	00005097          	auipc	ra,0x5
    80001080:	1ac080e7          	jalr	428(ra) # 80006228 <acquire>
        if (p->state == UNUSED) {
    80001084:	4c9c                	lw	a5,24(s1)
    80001086:	cf81                	beqz	a5,8000109e <allocproc+0x40>
            release(&p->lock);
    80001088:	8526                	mv	a0,s1
    8000108a:	00005097          	auipc	ra,0x5
    8000108e:	252080e7          	jalr	594(ra) # 800062dc <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001092:	18048493          	addi	s1,s1,384
    80001096:	ff2492e3          	bne	s1,s2,8000107a <allocproc+0x1c>
    return 0;
    8000109a:	4481                	li	s1,0
    8000109c:	a8b9                	j	800010fa <allocproc+0x9c>
    p->pid = allocpid();
    8000109e:	00000097          	auipc	ra,0x0
    800010a2:	e34080e7          	jalr	-460(ra) # 80000ed2 <allocpid>
    800010a6:	d888                	sw	a0,48(s1)
    p->state = USED;
    800010a8:	4785                	li	a5,1
    800010aa:	cc9c                	sw	a5,24(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    800010ac:	fffff097          	auipc	ra,0xfffff
    800010b0:	06e080e7          	jalr	110(ra) # 8000011a <kalloc>
    800010b4:	892a                	mv	s2,a0
    800010b6:	eca8                	sd	a0,88(s1)
    800010b8:	c921                	beqz	a0,80001108 <allocproc+0xaa>
    p->pagetable = proc_pagetable(p);
    800010ba:	8526                	mv	a0,s1
    800010bc:	00000097          	auipc	ra,0x0
    800010c0:	e5c080e7          	jalr	-420(ra) # 80000f18 <proc_pagetable>
    800010c4:	892a                	mv	s2,a0
    800010c6:	e8a8                	sd	a0,80(s1)
    if (p->pagetable == 0) {
    800010c8:	cd21                	beqz	a0,80001120 <allocproc+0xc2>
    memset(&p->context, 0, sizeof(p->context));
    800010ca:	07000613          	li	a2,112
    800010ce:	4581                	li	a1,0
    800010d0:	06048513          	addi	a0,s1,96
    800010d4:	fffff097          	auipc	ra,0xfffff
    800010d8:	0a6080e7          	jalr	166(ra) # 8000017a <memset>
    p->context.ra = (uint64)forkret;
    800010dc:	00000797          	auipc	a5,0x0
    800010e0:	db078793          	addi	a5,a5,-592 # 80000e8c <forkret>
    800010e4:	f0bc                	sd	a5,96(s1)
    p->context.sp = p->kstack + PGSIZE;
    800010e6:	60bc                	ld	a5,64(s1)
    800010e8:	6705                	lui	a4,0x1
    800010ea:	97ba                	add	a5,a5,a4
    800010ec:	f4bc                	sd	a5,104(s1)
    p->interval = 0;
    800010ee:	1604a423          	sw	zero,360(s1)
    p->ticks = 0;
    800010f2:	1604a623          	sw	zero,364(s1)
    p->handler = 0;
    800010f6:	1604b823          	sd	zero,368(s1)
}
    800010fa:	8526                	mv	a0,s1
    800010fc:	60e2                	ld	ra,24(sp)
    800010fe:	6442                	ld	s0,16(sp)
    80001100:	64a2                	ld	s1,8(sp)
    80001102:	6902                	ld	s2,0(sp)
    80001104:	6105                	addi	sp,sp,32
    80001106:	8082                	ret
        freeproc(p);
    80001108:	8526                	mv	a0,s1
    8000110a:	00000097          	auipc	ra,0x0
    8000110e:	efc080e7          	jalr	-260(ra) # 80001006 <freeproc>
        release(&p->lock);
    80001112:	8526                	mv	a0,s1
    80001114:	00005097          	auipc	ra,0x5
    80001118:	1c8080e7          	jalr	456(ra) # 800062dc <release>
        return 0;
    8000111c:	84ca                	mv	s1,s2
    8000111e:	bff1                	j	800010fa <allocproc+0x9c>
        freeproc(p);
    80001120:	8526                	mv	a0,s1
    80001122:	00000097          	auipc	ra,0x0
    80001126:	ee4080e7          	jalr	-284(ra) # 80001006 <freeproc>
        release(&p->lock);
    8000112a:	8526                	mv	a0,s1
    8000112c:	00005097          	auipc	ra,0x5
    80001130:	1b0080e7          	jalr	432(ra) # 800062dc <release>
        return 0;
    80001134:	84ca                	mv	s1,s2
    80001136:	b7d1                	j	800010fa <allocproc+0x9c>

0000000080001138 <userinit>:
{
    80001138:	1101                	addi	sp,sp,-32
    8000113a:	ec06                	sd	ra,24(sp)
    8000113c:	e822                	sd	s0,16(sp)
    8000113e:	e426                	sd	s1,8(sp)
    80001140:	1000                	addi	s0,sp,32
    p = allocproc();
    80001142:	00000097          	auipc	ra,0x0
    80001146:	f1c080e7          	jalr	-228(ra) # 8000105e <allocproc>
    8000114a:	84aa                	mv	s1,a0
    initproc = p;
    8000114c:	00007797          	auipc	a5,0x7
    80001150:	7aa7b223          	sd	a0,1956(a5) # 800088f0 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001154:	03400613          	li	a2,52
    80001158:	00007597          	auipc	a1,0x7
    8000115c:	72858593          	addi	a1,a1,1832 # 80008880 <initcode>
    80001160:	6928                	ld	a0,80(a0)
    80001162:	fffff097          	auipc	ra,0xfffff
    80001166:	69c080e7          	jalr	1692(ra) # 800007fe <uvmfirst>
    p->sz = PGSIZE;
    8000116a:	6785                	lui	a5,0x1
    8000116c:	e4bc                	sd	a5,72(s1)
    p->trapframe->epc = 0;     // user program counter
    8000116e:	6cb8                	ld	a4,88(s1)
    80001170:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    80001174:	6cb8                	ld	a4,88(s1)
    80001176:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    80001178:	4641                	li	a2,16
    8000117a:	00007597          	auipc	a1,0x7
    8000117e:	00658593          	addi	a1,a1,6 # 80008180 <etext+0x180>
    80001182:	15848513          	addi	a0,s1,344
    80001186:	fffff097          	auipc	ra,0xfffff
    8000118a:	13e080e7          	jalr	318(ra) # 800002c4 <safestrcpy>
    p->cwd = namei("/");
    8000118e:	00007517          	auipc	a0,0x7
    80001192:	00250513          	addi	a0,a0,2 # 80008190 <etext+0x190>
    80001196:	00002097          	auipc	ra,0x2
    8000119a:	1e8080e7          	jalr	488(ra) # 8000337e <namei>
    8000119e:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    800011a2:	478d                	li	a5,3
    800011a4:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    800011a6:	8526                	mv	a0,s1
    800011a8:	00005097          	auipc	ra,0x5
    800011ac:	134080e7          	jalr	308(ra) # 800062dc <release>
}
    800011b0:	60e2                	ld	ra,24(sp)
    800011b2:	6442                	ld	s0,16(sp)
    800011b4:	64a2                	ld	s1,8(sp)
    800011b6:	6105                	addi	sp,sp,32
    800011b8:	8082                	ret

00000000800011ba <growproc>:
{
    800011ba:	1101                	addi	sp,sp,-32
    800011bc:	ec06                	sd	ra,24(sp)
    800011be:	e822                	sd	s0,16(sp)
    800011c0:	e426                	sd	s1,8(sp)
    800011c2:	e04a                	sd	s2,0(sp)
    800011c4:	1000                	addi	s0,sp,32
    800011c6:	892a                	mv	s2,a0
    struct proc *p = myproc();
    800011c8:	00000097          	auipc	ra,0x0
    800011cc:	c8c080e7          	jalr	-884(ra) # 80000e54 <myproc>
    800011d0:	84aa                	mv	s1,a0
    sz = p->sz;
    800011d2:	652c                	ld	a1,72(a0)
    if (n > 0) {
    800011d4:	01204c63          	bgtz	s2,800011ec <growproc+0x32>
    else if (n < 0) {
    800011d8:	02094663          	bltz	s2,80001204 <growproc+0x4a>
    p->sz = sz;
    800011dc:	e4ac                	sd	a1,72(s1)
    return 0;
    800011de:	4501                	li	a0,0
}
    800011e0:	60e2                	ld	ra,24(sp)
    800011e2:	6442                	ld	s0,16(sp)
    800011e4:	64a2                	ld	s1,8(sp)
    800011e6:	6902                	ld	s2,0(sp)
    800011e8:	6105                	addi	sp,sp,32
    800011ea:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800011ec:	4691                	li	a3,4
    800011ee:	00b90633          	add	a2,s2,a1
    800011f2:	6928                	ld	a0,80(a0)
    800011f4:	fffff097          	auipc	ra,0xfffff
    800011f8:	6c4080e7          	jalr	1732(ra) # 800008b8 <uvmalloc>
    800011fc:	85aa                	mv	a1,a0
    800011fe:	fd79                	bnez	a0,800011dc <growproc+0x22>
            return -1;
    80001200:	557d                	li	a0,-1
    80001202:	bff9                	j	800011e0 <growproc+0x26>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001204:	00b90633          	add	a2,s2,a1
    80001208:	6928                	ld	a0,80(a0)
    8000120a:	fffff097          	auipc	ra,0xfffff
    8000120e:	666080e7          	jalr	1638(ra) # 80000870 <uvmdealloc>
    80001212:	85aa                	mv	a1,a0
    80001214:	b7e1                	j	800011dc <growproc+0x22>

0000000080001216 <fork>:
{
    80001216:	7139                	addi	sp,sp,-64
    80001218:	fc06                	sd	ra,56(sp)
    8000121a:	f822                	sd	s0,48(sp)
    8000121c:	f426                	sd	s1,40(sp)
    8000121e:	f04a                	sd	s2,32(sp)
    80001220:	ec4e                	sd	s3,24(sp)
    80001222:	e852                	sd	s4,16(sp)
    80001224:	e456                	sd	s5,8(sp)
    80001226:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    80001228:	00000097          	auipc	ra,0x0
    8000122c:	c2c080e7          	jalr	-980(ra) # 80000e54 <myproc>
    80001230:	8aaa                	mv	s5,a0
    if ((np = allocproc()) == 0) {
    80001232:	00000097          	auipc	ra,0x0
    80001236:	e2c080e7          	jalr	-468(ra) # 8000105e <allocproc>
    8000123a:	10050c63          	beqz	a0,80001352 <fork+0x13c>
    8000123e:	8a2a                	mv	s4,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    80001240:	048ab603          	ld	a2,72(s5)
    80001244:	692c                	ld	a1,80(a0)
    80001246:	050ab503          	ld	a0,80(s5)
    8000124a:	fffff097          	auipc	ra,0xfffff
    8000124e:	7c6080e7          	jalr	1990(ra) # 80000a10 <uvmcopy>
    80001252:	04054863          	bltz	a0,800012a2 <fork+0x8c>
    np->sz = p->sz;
    80001256:	048ab783          	ld	a5,72(s5)
    8000125a:	04fa3423          	sd	a5,72(s4)
    *(np->trapframe) = *(p->trapframe);
    8000125e:	058ab683          	ld	a3,88(s5)
    80001262:	87b6                	mv	a5,a3
    80001264:	058a3703          	ld	a4,88(s4)
    80001268:	12068693          	addi	a3,a3,288
    8000126c:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001270:	6788                	ld	a0,8(a5)
    80001272:	6b8c                	ld	a1,16(a5)
    80001274:	6f90                	ld	a2,24(a5)
    80001276:	01073023          	sd	a6,0(a4)
    8000127a:	e708                	sd	a0,8(a4)
    8000127c:	eb0c                	sd	a1,16(a4)
    8000127e:	ef10                	sd	a2,24(a4)
    80001280:	02078793          	addi	a5,a5,32
    80001284:	02070713          	addi	a4,a4,32
    80001288:	fed792e3          	bne	a5,a3,8000126c <fork+0x56>
    np->trapframe->a0 = 0;
    8000128c:	058a3783          	ld	a5,88(s4)
    80001290:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++)
    80001294:	0d0a8493          	addi	s1,s5,208
    80001298:	0d0a0913          	addi	s2,s4,208
    8000129c:	150a8993          	addi	s3,s5,336
    800012a0:	a00d                	j	800012c2 <fork+0xac>
        freeproc(np);
    800012a2:	8552                	mv	a0,s4
    800012a4:	00000097          	auipc	ra,0x0
    800012a8:	d62080e7          	jalr	-670(ra) # 80001006 <freeproc>
        release(&np->lock);
    800012ac:	8552                	mv	a0,s4
    800012ae:	00005097          	auipc	ra,0x5
    800012b2:	02e080e7          	jalr	46(ra) # 800062dc <release>
        return -1;
    800012b6:	597d                	li	s2,-1
    800012b8:	a059                	j	8000133e <fork+0x128>
    for (i = 0; i < NOFILE; i++)
    800012ba:	04a1                	addi	s1,s1,8
    800012bc:	0921                	addi	s2,s2,8
    800012be:	01348b63          	beq	s1,s3,800012d4 <fork+0xbe>
        if (p->ofile[i])
    800012c2:	6088                	ld	a0,0(s1)
    800012c4:	d97d                	beqz	a0,800012ba <fork+0xa4>
            np->ofile[i] = filedup(p->ofile[i]);
    800012c6:	00002097          	auipc	ra,0x2
    800012ca:	74e080e7          	jalr	1870(ra) # 80003a14 <filedup>
    800012ce:	00a93023          	sd	a0,0(s2)
    800012d2:	b7e5                	j	800012ba <fork+0xa4>
    np->cwd = idup(p->cwd);
    800012d4:	150ab503          	ld	a0,336(s5)
    800012d8:	00002097          	auipc	ra,0x2
    800012dc:	8bc080e7          	jalr	-1860(ra) # 80002b94 <idup>
    800012e0:	14aa3823          	sd	a0,336(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    800012e4:	4641                	li	a2,16
    800012e6:	158a8593          	addi	a1,s5,344
    800012ea:	158a0513          	addi	a0,s4,344
    800012ee:	fffff097          	auipc	ra,0xfffff
    800012f2:	fd6080e7          	jalr	-42(ra) # 800002c4 <safestrcpy>
    pid = np->pid;
    800012f6:	030a2903          	lw	s2,48(s4)
    release(&np->lock);
    800012fa:	8552                	mv	a0,s4
    800012fc:	00005097          	auipc	ra,0x5
    80001300:	fe0080e7          	jalr	-32(ra) # 800062dc <release>
    acquire(&wait_lock);
    80001304:	00007497          	auipc	s1,0x7
    80001308:	64448493          	addi	s1,s1,1604 # 80008948 <wait_lock>
    8000130c:	8526                	mv	a0,s1
    8000130e:	00005097          	auipc	ra,0x5
    80001312:	f1a080e7          	jalr	-230(ra) # 80006228 <acquire>
    np->parent = p;
    80001316:	035a3c23          	sd	s5,56(s4)
    release(&wait_lock);
    8000131a:	8526                	mv	a0,s1
    8000131c:	00005097          	auipc	ra,0x5
    80001320:	fc0080e7          	jalr	-64(ra) # 800062dc <release>
    acquire(&np->lock);
    80001324:	8552                	mv	a0,s4
    80001326:	00005097          	auipc	ra,0x5
    8000132a:	f02080e7          	jalr	-254(ra) # 80006228 <acquire>
    np->state = RUNNABLE;
    8000132e:	478d                	li	a5,3
    80001330:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    80001334:	8552                	mv	a0,s4
    80001336:	00005097          	auipc	ra,0x5
    8000133a:	fa6080e7          	jalr	-90(ra) # 800062dc <release>
}
    8000133e:	854a                	mv	a0,s2
    80001340:	70e2                	ld	ra,56(sp)
    80001342:	7442                	ld	s0,48(sp)
    80001344:	74a2                	ld	s1,40(sp)
    80001346:	7902                	ld	s2,32(sp)
    80001348:	69e2                	ld	s3,24(sp)
    8000134a:	6a42                	ld	s4,16(sp)
    8000134c:	6aa2                	ld	s5,8(sp)
    8000134e:	6121                	addi	sp,sp,64
    80001350:	8082                	ret
        return -1;
    80001352:	597d                	li	s2,-1
    80001354:	b7ed                	j	8000133e <fork+0x128>

0000000080001356 <scheduler>:
{
    80001356:	7139                	addi	sp,sp,-64
    80001358:	fc06                	sd	ra,56(sp)
    8000135a:	f822                	sd	s0,48(sp)
    8000135c:	f426                	sd	s1,40(sp)
    8000135e:	f04a                	sd	s2,32(sp)
    80001360:	ec4e                	sd	s3,24(sp)
    80001362:	e852                	sd	s4,16(sp)
    80001364:	e456                	sd	s5,8(sp)
    80001366:	e05a                	sd	s6,0(sp)
    80001368:	0080                	addi	s0,sp,64
    8000136a:	8792                	mv	a5,tp
    int id = r_tp();
    8000136c:	2781                	sext.w	a5,a5
    c->proc = 0;
    8000136e:	00779a93          	slli	s5,a5,0x7
    80001372:	00007717          	auipc	a4,0x7
    80001376:	5be70713          	addi	a4,a4,1470 # 80008930 <pid_lock>
    8000137a:	9756                	add	a4,a4,s5
    8000137c:	02073823          	sd	zero,48(a4)
                swtch(&c->context, &p->context);
    80001380:	00007717          	auipc	a4,0x7
    80001384:	5e870713          	addi	a4,a4,1512 # 80008968 <cpus+0x8>
    80001388:	9aba                	add	s5,s5,a4
            if (p->state == RUNNABLE) {
    8000138a:	498d                	li	s3,3
                p->state = RUNNING;
    8000138c:	4b11                	li	s6,4
                c->proc = p;
    8000138e:	079e                	slli	a5,a5,0x7
    80001390:	00007a17          	auipc	s4,0x7
    80001394:	5a0a0a13          	addi	s4,s4,1440 # 80008930 <pid_lock>
    80001398:	9a3e                	add	s4,s4,a5
        for (p = proc; p < &proc[NPROC]; p++) {
    8000139a:	0000e917          	auipc	s2,0xe
    8000139e:	9c690913          	addi	s2,s2,-1594 # 8000ed60 <tickslock>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    800013a2:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013a6:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    800013aa:	10079073          	csrw	sstatus,a5
    800013ae:	00008497          	auipc	s1,0x8
    800013b2:	9b248493          	addi	s1,s1,-1614 # 80008d60 <proc>
    800013b6:	a811                	j	800013ca <scheduler+0x74>
            release(&p->lock);
    800013b8:	8526                	mv	a0,s1
    800013ba:	00005097          	auipc	ra,0x5
    800013be:	f22080e7          	jalr	-222(ra) # 800062dc <release>
        for (p = proc; p < &proc[NPROC]; p++) {
    800013c2:	18048493          	addi	s1,s1,384
    800013c6:	fd248ee3          	beq	s1,s2,800013a2 <scheduler+0x4c>
            acquire(&p->lock);
    800013ca:	8526                	mv	a0,s1
    800013cc:	00005097          	auipc	ra,0x5
    800013d0:	e5c080e7          	jalr	-420(ra) # 80006228 <acquire>
            if (p->state == RUNNABLE) {
    800013d4:	4c9c                	lw	a5,24(s1)
    800013d6:	ff3791e3          	bne	a5,s3,800013b8 <scheduler+0x62>
                p->state = RUNNING;
    800013da:	0164ac23          	sw	s6,24(s1)
                c->proc = p;
    800013de:	029a3823          	sd	s1,48(s4)
                swtch(&c->context, &p->context);
    800013e2:	06048593          	addi	a1,s1,96
    800013e6:	8556                	mv	a0,s5
    800013e8:	00000097          	auipc	ra,0x0
    800013ec:	684080e7          	jalr	1668(ra) # 80001a6c <swtch>
                c->proc = 0;
    800013f0:	020a3823          	sd	zero,48(s4)
    800013f4:	b7d1                	j	800013b8 <scheduler+0x62>

00000000800013f6 <sched>:
{
    800013f6:	7179                	addi	sp,sp,-48
    800013f8:	f406                	sd	ra,40(sp)
    800013fa:	f022                	sd	s0,32(sp)
    800013fc:	ec26                	sd	s1,24(sp)
    800013fe:	e84a                	sd	s2,16(sp)
    80001400:	e44e                	sd	s3,8(sp)
    80001402:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80001404:	00000097          	auipc	ra,0x0
    80001408:	a50080e7          	jalr	-1456(ra) # 80000e54 <myproc>
    8000140c:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    8000140e:	00005097          	auipc	ra,0x5
    80001412:	da0080e7          	jalr	-608(ra) # 800061ae <holding>
    80001416:	c93d                	beqz	a0,8000148c <sched+0x96>
    asm volatile("mv %0, tp" : "=r"(x));
    80001418:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    8000141a:	2781                	sext.w	a5,a5
    8000141c:	079e                	slli	a5,a5,0x7
    8000141e:	00007717          	auipc	a4,0x7
    80001422:	51270713          	addi	a4,a4,1298 # 80008930 <pid_lock>
    80001426:	97ba                	add	a5,a5,a4
    80001428:	0a87a703          	lw	a4,168(a5)
    8000142c:	4785                	li	a5,1
    8000142e:	06f71763          	bne	a4,a5,8000149c <sched+0xa6>
    if (p->state == RUNNING)
    80001432:	4c98                	lw	a4,24(s1)
    80001434:	4791                	li	a5,4
    80001436:	06f70b63          	beq	a4,a5,800014ac <sched+0xb6>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    8000143a:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    8000143e:	8b89                	andi	a5,a5,2
    if (intr_get())
    80001440:	efb5                	bnez	a5,800014bc <sched+0xc6>
    asm volatile("mv %0, tp" : "=r"(x));
    80001442:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    80001444:	00007917          	auipc	s2,0x7
    80001448:	4ec90913          	addi	s2,s2,1260 # 80008930 <pid_lock>
    8000144c:	2781                	sext.w	a5,a5
    8000144e:	079e                	slli	a5,a5,0x7
    80001450:	97ca                	add	a5,a5,s2
    80001452:	0ac7a983          	lw	s3,172(a5)
    80001456:	8792                	mv	a5,tp
    swtch(&p->context, &mycpu()->context);
    80001458:	2781                	sext.w	a5,a5
    8000145a:	079e                	slli	a5,a5,0x7
    8000145c:	00007597          	auipc	a1,0x7
    80001460:	50c58593          	addi	a1,a1,1292 # 80008968 <cpus+0x8>
    80001464:	95be                	add	a1,a1,a5
    80001466:	06048513          	addi	a0,s1,96
    8000146a:	00000097          	auipc	ra,0x0
    8000146e:	602080e7          	jalr	1538(ra) # 80001a6c <swtch>
    80001472:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    80001474:	2781                	sext.w	a5,a5
    80001476:	079e                	slli	a5,a5,0x7
    80001478:	993e                	add	s2,s2,a5
    8000147a:	0b392623          	sw	s3,172(s2)
}
    8000147e:	70a2                	ld	ra,40(sp)
    80001480:	7402                	ld	s0,32(sp)
    80001482:	64e2                	ld	s1,24(sp)
    80001484:	6942                	ld	s2,16(sp)
    80001486:	69a2                	ld	s3,8(sp)
    80001488:	6145                	addi	sp,sp,48
    8000148a:	8082                	ret
        panic("sched p->lock");
    8000148c:	00007517          	auipc	a0,0x7
    80001490:	d0c50513          	addi	a0,a0,-756 # 80008198 <etext+0x198>
    80001494:	00005097          	auipc	ra,0x5
    80001498:	886080e7          	jalr	-1914(ra) # 80005d1a <panic>
        panic("sched locks");
    8000149c:	00007517          	auipc	a0,0x7
    800014a0:	d0c50513          	addi	a0,a0,-756 # 800081a8 <etext+0x1a8>
    800014a4:	00005097          	auipc	ra,0x5
    800014a8:	876080e7          	jalr	-1930(ra) # 80005d1a <panic>
        panic("sched running");
    800014ac:	00007517          	auipc	a0,0x7
    800014b0:	d0c50513          	addi	a0,a0,-756 # 800081b8 <etext+0x1b8>
    800014b4:	00005097          	auipc	ra,0x5
    800014b8:	866080e7          	jalr	-1946(ra) # 80005d1a <panic>
        panic("sched interruptible");
    800014bc:	00007517          	auipc	a0,0x7
    800014c0:	d0c50513          	addi	a0,a0,-756 # 800081c8 <etext+0x1c8>
    800014c4:	00005097          	auipc	ra,0x5
    800014c8:	856080e7          	jalr	-1962(ra) # 80005d1a <panic>

00000000800014cc <yield>:
{
    800014cc:	1101                	addi	sp,sp,-32
    800014ce:	ec06                	sd	ra,24(sp)
    800014d0:	e822                	sd	s0,16(sp)
    800014d2:	e426                	sd	s1,8(sp)
    800014d4:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    800014d6:	00000097          	auipc	ra,0x0
    800014da:	97e080e7          	jalr	-1666(ra) # 80000e54 <myproc>
    800014de:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800014e0:	00005097          	auipc	ra,0x5
    800014e4:	d48080e7          	jalr	-696(ra) # 80006228 <acquire>
    p->state = RUNNABLE;
    800014e8:	478d                	li	a5,3
    800014ea:	cc9c                	sw	a5,24(s1)
    sched();
    800014ec:	00000097          	auipc	ra,0x0
    800014f0:	f0a080e7          	jalr	-246(ra) # 800013f6 <sched>
    release(&p->lock);
    800014f4:	8526                	mv	a0,s1
    800014f6:	00005097          	auipc	ra,0x5
    800014fa:	de6080e7          	jalr	-538(ra) # 800062dc <release>
}
    800014fe:	60e2                	ld	ra,24(sp)
    80001500:	6442                	ld	s0,16(sp)
    80001502:	64a2                	ld	s1,8(sp)
    80001504:	6105                	addi	sp,sp,32
    80001506:	8082                	ret

0000000080001508 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    80001508:	7179                	addi	sp,sp,-48
    8000150a:	f406                	sd	ra,40(sp)
    8000150c:	f022                	sd	s0,32(sp)
    8000150e:	ec26                	sd	s1,24(sp)
    80001510:	e84a                	sd	s2,16(sp)
    80001512:	e44e                	sd	s3,8(sp)
    80001514:	1800                	addi	s0,sp,48
    80001516:	89aa                	mv	s3,a0
    80001518:	892e                	mv	s2,a1
    struct proc *p = myproc();
    8000151a:	00000097          	auipc	ra,0x0
    8000151e:	93a080e7          	jalr	-1734(ra) # 80000e54 <myproc>
    80001522:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    80001524:	00005097          	auipc	ra,0x5
    80001528:	d04080e7          	jalr	-764(ra) # 80006228 <acquire>
    release(lk);
    8000152c:	854a                	mv	a0,s2
    8000152e:	00005097          	auipc	ra,0x5
    80001532:	dae080e7          	jalr	-594(ra) # 800062dc <release>

    // Go to sleep.
    p->chan = chan;
    80001536:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    8000153a:	4789                	li	a5,2
    8000153c:	cc9c                	sw	a5,24(s1)

    sched();
    8000153e:	00000097          	auipc	ra,0x0
    80001542:	eb8080e7          	jalr	-328(ra) # 800013f6 <sched>

    // Tidy up.
    p->chan = 0;
    80001546:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    8000154a:	8526                	mv	a0,s1
    8000154c:	00005097          	auipc	ra,0x5
    80001550:	d90080e7          	jalr	-624(ra) # 800062dc <release>
    acquire(lk);
    80001554:	854a                	mv	a0,s2
    80001556:	00005097          	auipc	ra,0x5
    8000155a:	cd2080e7          	jalr	-814(ra) # 80006228 <acquire>
}
    8000155e:	70a2                	ld	ra,40(sp)
    80001560:	7402                	ld	s0,32(sp)
    80001562:	64e2                	ld	s1,24(sp)
    80001564:	6942                	ld	s2,16(sp)
    80001566:	69a2                	ld	s3,8(sp)
    80001568:	6145                	addi	sp,sp,48
    8000156a:	8082                	ret

000000008000156c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    8000156c:	7139                	addi	sp,sp,-64
    8000156e:	fc06                	sd	ra,56(sp)
    80001570:	f822                	sd	s0,48(sp)
    80001572:	f426                	sd	s1,40(sp)
    80001574:	f04a                	sd	s2,32(sp)
    80001576:	ec4e                	sd	s3,24(sp)
    80001578:	e852                	sd	s4,16(sp)
    8000157a:	e456                	sd	s5,8(sp)
    8000157c:	0080                	addi	s0,sp,64
    8000157e:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++) {
    80001580:	00007497          	auipc	s1,0x7
    80001584:	7e048493          	addi	s1,s1,2016 # 80008d60 <proc>
        if (p != myproc()) {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan) {
    80001588:	4989                	li	s3,2
                p->state = RUNNABLE;
    8000158a:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++) {
    8000158c:	0000d917          	auipc	s2,0xd
    80001590:	7d490913          	addi	s2,s2,2004 # 8000ed60 <tickslock>
    80001594:	a811                	j	800015a8 <wakeup+0x3c>
            }
            release(&p->lock);
    80001596:	8526                	mv	a0,s1
    80001598:	00005097          	auipc	ra,0x5
    8000159c:	d44080e7          	jalr	-700(ra) # 800062dc <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    800015a0:	18048493          	addi	s1,s1,384
    800015a4:	03248663          	beq	s1,s2,800015d0 <wakeup+0x64>
        if (p != myproc()) {
    800015a8:	00000097          	auipc	ra,0x0
    800015ac:	8ac080e7          	jalr	-1876(ra) # 80000e54 <myproc>
    800015b0:	fea488e3          	beq	s1,a0,800015a0 <wakeup+0x34>
            acquire(&p->lock);
    800015b4:	8526                	mv	a0,s1
    800015b6:	00005097          	auipc	ra,0x5
    800015ba:	c72080e7          	jalr	-910(ra) # 80006228 <acquire>
            if (p->state == SLEEPING && p->chan == chan) {
    800015be:	4c9c                	lw	a5,24(s1)
    800015c0:	fd379be3          	bne	a5,s3,80001596 <wakeup+0x2a>
    800015c4:	709c                	ld	a5,32(s1)
    800015c6:	fd4798e3          	bne	a5,s4,80001596 <wakeup+0x2a>
                p->state = RUNNABLE;
    800015ca:	0154ac23          	sw	s5,24(s1)
    800015ce:	b7e1                	j	80001596 <wakeup+0x2a>
        }
    }
}
    800015d0:	70e2                	ld	ra,56(sp)
    800015d2:	7442                	ld	s0,48(sp)
    800015d4:	74a2                	ld	s1,40(sp)
    800015d6:	7902                	ld	s2,32(sp)
    800015d8:	69e2                	ld	s3,24(sp)
    800015da:	6a42                	ld	s4,16(sp)
    800015dc:	6aa2                	ld	s5,8(sp)
    800015de:	6121                	addi	sp,sp,64
    800015e0:	8082                	ret

00000000800015e2 <reparent>:
{
    800015e2:	7179                	addi	sp,sp,-48
    800015e4:	f406                	sd	ra,40(sp)
    800015e6:	f022                	sd	s0,32(sp)
    800015e8:	ec26                	sd	s1,24(sp)
    800015ea:	e84a                	sd	s2,16(sp)
    800015ec:	e44e                	sd	s3,8(sp)
    800015ee:	e052                	sd	s4,0(sp)
    800015f0:	1800                	addi	s0,sp,48
    800015f2:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    800015f4:	00007497          	auipc	s1,0x7
    800015f8:	76c48493          	addi	s1,s1,1900 # 80008d60 <proc>
            pp->parent = initproc;
    800015fc:	00007a17          	auipc	s4,0x7
    80001600:	2f4a0a13          	addi	s4,s4,756 # 800088f0 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001604:	0000d997          	auipc	s3,0xd
    80001608:	75c98993          	addi	s3,s3,1884 # 8000ed60 <tickslock>
    8000160c:	a029                	j	80001616 <reparent+0x34>
    8000160e:	18048493          	addi	s1,s1,384
    80001612:	01348d63          	beq	s1,s3,8000162c <reparent+0x4a>
        if (pp->parent == p) {
    80001616:	7c9c                	ld	a5,56(s1)
    80001618:	ff279be3          	bne	a5,s2,8000160e <reparent+0x2c>
            pp->parent = initproc;
    8000161c:	000a3503          	ld	a0,0(s4)
    80001620:	fc88                	sd	a0,56(s1)
            wakeup(initproc);
    80001622:	00000097          	auipc	ra,0x0
    80001626:	f4a080e7          	jalr	-182(ra) # 8000156c <wakeup>
    8000162a:	b7d5                	j	8000160e <reparent+0x2c>
}
    8000162c:	70a2                	ld	ra,40(sp)
    8000162e:	7402                	ld	s0,32(sp)
    80001630:	64e2                	ld	s1,24(sp)
    80001632:	6942                	ld	s2,16(sp)
    80001634:	69a2                	ld	s3,8(sp)
    80001636:	6a02                	ld	s4,0(sp)
    80001638:	6145                	addi	sp,sp,48
    8000163a:	8082                	ret

000000008000163c <exit>:
{
    8000163c:	7179                	addi	sp,sp,-48
    8000163e:	f406                	sd	ra,40(sp)
    80001640:	f022                	sd	s0,32(sp)
    80001642:	ec26                	sd	s1,24(sp)
    80001644:	e84a                	sd	s2,16(sp)
    80001646:	e44e                	sd	s3,8(sp)
    80001648:	e052                	sd	s4,0(sp)
    8000164a:	1800                	addi	s0,sp,48
    8000164c:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    8000164e:	00000097          	auipc	ra,0x0
    80001652:	806080e7          	jalr	-2042(ra) # 80000e54 <myproc>
    80001656:	89aa                	mv	s3,a0
    if (p == initproc)
    80001658:	00007797          	auipc	a5,0x7
    8000165c:	2987b783          	ld	a5,664(a5) # 800088f0 <initproc>
    80001660:	0d050493          	addi	s1,a0,208
    80001664:	15050913          	addi	s2,a0,336
    80001668:	02a79363          	bne	a5,a0,8000168e <exit+0x52>
        panic("init exiting");
    8000166c:	00007517          	auipc	a0,0x7
    80001670:	b7450513          	addi	a0,a0,-1164 # 800081e0 <etext+0x1e0>
    80001674:	00004097          	auipc	ra,0x4
    80001678:	6a6080e7          	jalr	1702(ra) # 80005d1a <panic>
            fileclose(f);
    8000167c:	00002097          	auipc	ra,0x2
    80001680:	3ea080e7          	jalr	1002(ra) # 80003a66 <fileclose>
            p->ofile[fd] = 0;
    80001684:	0004b023          	sd	zero,0(s1)
    for (int fd = 0; fd < NOFILE; fd++) {
    80001688:	04a1                	addi	s1,s1,8
    8000168a:	01248563          	beq	s1,s2,80001694 <exit+0x58>
        if (p->ofile[fd]) {
    8000168e:	6088                	ld	a0,0(s1)
    80001690:	f575                	bnez	a0,8000167c <exit+0x40>
    80001692:	bfdd                	j	80001688 <exit+0x4c>
    begin_op();
    80001694:	00002097          	auipc	ra,0x2
    80001698:	f0a080e7          	jalr	-246(ra) # 8000359e <begin_op>
    iput(p->cwd);
    8000169c:	1509b503          	ld	a0,336(s3)
    800016a0:	00001097          	auipc	ra,0x1
    800016a4:	6ec080e7          	jalr	1772(ra) # 80002d8c <iput>
    end_op();
    800016a8:	00002097          	auipc	ra,0x2
    800016ac:	f74080e7          	jalr	-140(ra) # 8000361c <end_op>
    p->cwd = 0;
    800016b0:	1409b823          	sd	zero,336(s3)
    acquire(&wait_lock);
    800016b4:	00007497          	auipc	s1,0x7
    800016b8:	29448493          	addi	s1,s1,660 # 80008948 <wait_lock>
    800016bc:	8526                	mv	a0,s1
    800016be:	00005097          	auipc	ra,0x5
    800016c2:	b6a080e7          	jalr	-1174(ra) # 80006228 <acquire>
    reparent(p);
    800016c6:	854e                	mv	a0,s3
    800016c8:	00000097          	auipc	ra,0x0
    800016cc:	f1a080e7          	jalr	-230(ra) # 800015e2 <reparent>
    wakeup(p->parent);
    800016d0:	0389b503          	ld	a0,56(s3)
    800016d4:	00000097          	auipc	ra,0x0
    800016d8:	e98080e7          	jalr	-360(ra) # 8000156c <wakeup>
    acquire(&p->lock);
    800016dc:	854e                	mv	a0,s3
    800016de:	00005097          	auipc	ra,0x5
    800016e2:	b4a080e7          	jalr	-1206(ra) # 80006228 <acquire>
    p->xstate = status;
    800016e6:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    800016ea:	4795                	li	a5,5
    800016ec:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    800016f0:	8526                	mv	a0,s1
    800016f2:	00005097          	auipc	ra,0x5
    800016f6:	bea080e7          	jalr	-1046(ra) # 800062dc <release>
    sched();
    800016fa:	00000097          	auipc	ra,0x0
    800016fe:	cfc080e7          	jalr	-772(ra) # 800013f6 <sched>
    panic("zombie exit");
    80001702:	00007517          	auipc	a0,0x7
    80001706:	aee50513          	addi	a0,a0,-1298 # 800081f0 <etext+0x1f0>
    8000170a:	00004097          	auipc	ra,0x4
    8000170e:	610080e7          	jalr	1552(ra) # 80005d1a <panic>

0000000080001712 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    80001712:	7179                	addi	sp,sp,-48
    80001714:	f406                	sd	ra,40(sp)
    80001716:	f022                	sd	s0,32(sp)
    80001718:	ec26                	sd	s1,24(sp)
    8000171a:	e84a                	sd	s2,16(sp)
    8000171c:	e44e                	sd	s3,8(sp)
    8000171e:	1800                	addi	s0,sp,48
    80001720:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++) {
    80001722:	00007497          	auipc	s1,0x7
    80001726:	63e48493          	addi	s1,s1,1598 # 80008d60 <proc>
    8000172a:	0000d997          	auipc	s3,0xd
    8000172e:	63698993          	addi	s3,s3,1590 # 8000ed60 <tickslock>
        acquire(&p->lock);
    80001732:	8526                	mv	a0,s1
    80001734:	00005097          	auipc	ra,0x5
    80001738:	af4080e7          	jalr	-1292(ra) # 80006228 <acquire>
        if (p->pid == pid) {
    8000173c:	589c                	lw	a5,48(s1)
    8000173e:	01278d63          	beq	a5,s2,80001758 <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    80001742:	8526                	mv	a0,s1
    80001744:	00005097          	auipc	ra,0x5
    80001748:	b98080e7          	jalr	-1128(ra) # 800062dc <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    8000174c:	18048493          	addi	s1,s1,384
    80001750:	ff3491e3          	bne	s1,s3,80001732 <kill+0x20>
    }
    return -1;
    80001754:	557d                	li	a0,-1
    80001756:	a829                	j	80001770 <kill+0x5e>
            p->killed = 1;
    80001758:	4785                	li	a5,1
    8000175a:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING) {
    8000175c:	4c98                	lw	a4,24(s1)
    8000175e:	4789                	li	a5,2
    80001760:	00f70f63          	beq	a4,a5,8000177e <kill+0x6c>
            release(&p->lock);
    80001764:	8526                	mv	a0,s1
    80001766:	00005097          	auipc	ra,0x5
    8000176a:	b76080e7          	jalr	-1162(ra) # 800062dc <release>
            return 0;
    8000176e:	4501                	li	a0,0
}
    80001770:	70a2                	ld	ra,40(sp)
    80001772:	7402                	ld	s0,32(sp)
    80001774:	64e2                	ld	s1,24(sp)
    80001776:	6942                	ld	s2,16(sp)
    80001778:	69a2                	ld	s3,8(sp)
    8000177a:	6145                	addi	sp,sp,48
    8000177c:	8082                	ret
                p->state = RUNNABLE;
    8000177e:	478d                	li	a5,3
    80001780:	cc9c                	sw	a5,24(s1)
    80001782:	b7cd                	j	80001764 <kill+0x52>

0000000080001784 <setkilled>:

void setkilled(struct proc *p)
{
    80001784:	1101                	addi	sp,sp,-32
    80001786:	ec06                	sd	ra,24(sp)
    80001788:	e822                	sd	s0,16(sp)
    8000178a:	e426                	sd	s1,8(sp)
    8000178c:	1000                	addi	s0,sp,32
    8000178e:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80001790:	00005097          	auipc	ra,0x5
    80001794:	a98080e7          	jalr	-1384(ra) # 80006228 <acquire>
    p->killed = 1;
    80001798:	4785                	li	a5,1
    8000179a:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    8000179c:	8526                	mv	a0,s1
    8000179e:	00005097          	auipc	ra,0x5
    800017a2:	b3e080e7          	jalr	-1218(ra) # 800062dc <release>
}
    800017a6:	60e2                	ld	ra,24(sp)
    800017a8:	6442                	ld	s0,16(sp)
    800017aa:	64a2                	ld	s1,8(sp)
    800017ac:	6105                	addi	sp,sp,32
    800017ae:	8082                	ret

00000000800017b0 <killed>:

int killed(struct proc *p)
{
    800017b0:	1101                	addi	sp,sp,-32
    800017b2:	ec06                	sd	ra,24(sp)
    800017b4:	e822                	sd	s0,16(sp)
    800017b6:	e426                	sd	s1,8(sp)
    800017b8:	e04a                	sd	s2,0(sp)
    800017ba:	1000                	addi	s0,sp,32
    800017bc:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    800017be:	00005097          	auipc	ra,0x5
    800017c2:	a6a080e7          	jalr	-1430(ra) # 80006228 <acquire>
    k = p->killed;
    800017c6:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    800017ca:	8526                	mv	a0,s1
    800017cc:	00005097          	auipc	ra,0x5
    800017d0:	b10080e7          	jalr	-1264(ra) # 800062dc <release>
    return k;
}
    800017d4:	854a                	mv	a0,s2
    800017d6:	60e2                	ld	ra,24(sp)
    800017d8:	6442                	ld	s0,16(sp)
    800017da:	64a2                	ld	s1,8(sp)
    800017dc:	6902                	ld	s2,0(sp)
    800017de:	6105                	addi	sp,sp,32
    800017e0:	8082                	ret

00000000800017e2 <wait>:
{
    800017e2:	715d                	addi	sp,sp,-80
    800017e4:	e486                	sd	ra,72(sp)
    800017e6:	e0a2                	sd	s0,64(sp)
    800017e8:	fc26                	sd	s1,56(sp)
    800017ea:	f84a                	sd	s2,48(sp)
    800017ec:	f44e                	sd	s3,40(sp)
    800017ee:	f052                	sd	s4,32(sp)
    800017f0:	ec56                	sd	s5,24(sp)
    800017f2:	e85a                	sd	s6,16(sp)
    800017f4:	e45e                	sd	s7,8(sp)
    800017f6:	e062                	sd	s8,0(sp)
    800017f8:	0880                	addi	s0,sp,80
    800017fa:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    800017fc:	fffff097          	auipc	ra,0xfffff
    80001800:	658080e7          	jalr	1624(ra) # 80000e54 <myproc>
    80001804:	892a                	mv	s2,a0
    acquire(&wait_lock);
    80001806:	00007517          	auipc	a0,0x7
    8000180a:	14250513          	addi	a0,a0,322 # 80008948 <wait_lock>
    8000180e:	00005097          	auipc	ra,0x5
    80001812:	a1a080e7          	jalr	-1510(ra) # 80006228 <acquire>
        havekids = 0;
    80001816:	4b81                	li	s7,0
                if (pp->state == ZOMBIE) {
    80001818:	4a15                	li	s4,5
                havekids = 1;
    8000181a:	4a85                	li	s5,1
        for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000181c:	0000d997          	auipc	s3,0xd
    80001820:	54498993          	addi	s3,s3,1348 # 8000ed60 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    80001824:	00007c17          	auipc	s8,0x7
    80001828:	124c0c13          	addi	s8,s8,292 # 80008948 <wait_lock>
        havekids = 0;
    8000182c:	875e                	mv	a4,s7
        for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000182e:	00007497          	auipc	s1,0x7
    80001832:	53248493          	addi	s1,s1,1330 # 80008d60 <proc>
    80001836:	a0bd                	j	800018a4 <wait+0xc2>
                    pid = pp->pid;
    80001838:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate, sizeof(pp->xstate)) < 0) {
    8000183c:	000b0e63          	beqz	s6,80001858 <wait+0x76>
    80001840:	4691                	li	a3,4
    80001842:	02c48613          	addi	a2,s1,44
    80001846:	85da                	mv	a1,s6
    80001848:	05093503          	ld	a0,80(s2)
    8000184c:	fffff097          	auipc	ra,0xfffff
    80001850:	2c8080e7          	jalr	712(ra) # 80000b14 <copyout>
    80001854:	02054563          	bltz	a0,8000187e <wait+0x9c>
                    freeproc(pp);
    80001858:	8526                	mv	a0,s1
    8000185a:	fffff097          	auipc	ra,0xfffff
    8000185e:	7ac080e7          	jalr	1964(ra) # 80001006 <freeproc>
                    release(&pp->lock);
    80001862:	8526                	mv	a0,s1
    80001864:	00005097          	auipc	ra,0x5
    80001868:	a78080e7          	jalr	-1416(ra) # 800062dc <release>
                    release(&wait_lock);
    8000186c:	00007517          	auipc	a0,0x7
    80001870:	0dc50513          	addi	a0,a0,220 # 80008948 <wait_lock>
    80001874:	00005097          	auipc	ra,0x5
    80001878:	a68080e7          	jalr	-1432(ra) # 800062dc <release>
                    return pid;
    8000187c:	a0b5                	j	800018e8 <wait+0x106>
                        release(&pp->lock);
    8000187e:	8526                	mv	a0,s1
    80001880:	00005097          	auipc	ra,0x5
    80001884:	a5c080e7          	jalr	-1444(ra) # 800062dc <release>
                        release(&wait_lock);
    80001888:	00007517          	auipc	a0,0x7
    8000188c:	0c050513          	addi	a0,a0,192 # 80008948 <wait_lock>
    80001890:	00005097          	auipc	ra,0x5
    80001894:	a4c080e7          	jalr	-1460(ra) # 800062dc <release>
                        return -1;
    80001898:	59fd                	li	s3,-1
    8000189a:	a0b9                	j	800018e8 <wait+0x106>
        for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000189c:	18048493          	addi	s1,s1,384
    800018a0:	03348463          	beq	s1,s3,800018c8 <wait+0xe6>
            if (pp->parent == p) {
    800018a4:	7c9c                	ld	a5,56(s1)
    800018a6:	ff279be3          	bne	a5,s2,8000189c <wait+0xba>
                acquire(&pp->lock);
    800018aa:	8526                	mv	a0,s1
    800018ac:	00005097          	auipc	ra,0x5
    800018b0:	97c080e7          	jalr	-1668(ra) # 80006228 <acquire>
                if (pp->state == ZOMBIE) {
    800018b4:	4c9c                	lw	a5,24(s1)
    800018b6:	f94781e3          	beq	a5,s4,80001838 <wait+0x56>
                release(&pp->lock);
    800018ba:	8526                	mv	a0,s1
    800018bc:	00005097          	auipc	ra,0x5
    800018c0:	a20080e7          	jalr	-1504(ra) # 800062dc <release>
                havekids = 1;
    800018c4:	8756                	mv	a4,s5
    800018c6:	bfd9                	j	8000189c <wait+0xba>
        if (!havekids || killed(p)) {
    800018c8:	c719                	beqz	a4,800018d6 <wait+0xf4>
    800018ca:	854a                	mv	a0,s2
    800018cc:	00000097          	auipc	ra,0x0
    800018d0:	ee4080e7          	jalr	-284(ra) # 800017b0 <killed>
    800018d4:	c51d                	beqz	a0,80001902 <wait+0x120>
            release(&wait_lock);
    800018d6:	00007517          	auipc	a0,0x7
    800018da:	07250513          	addi	a0,a0,114 # 80008948 <wait_lock>
    800018de:	00005097          	auipc	ra,0x5
    800018e2:	9fe080e7          	jalr	-1538(ra) # 800062dc <release>
            return -1;
    800018e6:	59fd                	li	s3,-1
}
    800018e8:	854e                	mv	a0,s3
    800018ea:	60a6                	ld	ra,72(sp)
    800018ec:	6406                	ld	s0,64(sp)
    800018ee:	74e2                	ld	s1,56(sp)
    800018f0:	7942                	ld	s2,48(sp)
    800018f2:	79a2                	ld	s3,40(sp)
    800018f4:	7a02                	ld	s4,32(sp)
    800018f6:	6ae2                	ld	s5,24(sp)
    800018f8:	6b42                	ld	s6,16(sp)
    800018fa:	6ba2                	ld	s7,8(sp)
    800018fc:	6c02                	ld	s8,0(sp)
    800018fe:	6161                	addi	sp,sp,80
    80001900:	8082                	ret
        sleep(p, &wait_lock); // DOC: wait-sleep
    80001902:	85e2                	mv	a1,s8
    80001904:	854a                	mv	a0,s2
    80001906:	00000097          	auipc	ra,0x0
    8000190a:	c02080e7          	jalr	-1022(ra) # 80001508 <sleep>
        havekids = 0;
    8000190e:	bf39                	j	8000182c <wait+0x4a>

0000000080001910 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001910:	7179                	addi	sp,sp,-48
    80001912:	f406                	sd	ra,40(sp)
    80001914:	f022                	sd	s0,32(sp)
    80001916:	ec26                	sd	s1,24(sp)
    80001918:	e84a                	sd	s2,16(sp)
    8000191a:	e44e                	sd	s3,8(sp)
    8000191c:	e052                	sd	s4,0(sp)
    8000191e:	1800                	addi	s0,sp,48
    80001920:	84aa                	mv	s1,a0
    80001922:	892e                	mv	s2,a1
    80001924:	89b2                	mv	s3,a2
    80001926:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80001928:	fffff097          	auipc	ra,0xfffff
    8000192c:	52c080e7          	jalr	1324(ra) # 80000e54 <myproc>
    if (user_dst) {
    80001930:	c08d                	beqz	s1,80001952 <either_copyout+0x42>
        return copyout(p->pagetable, dst, src, len);
    80001932:	86d2                	mv	a3,s4
    80001934:	864e                	mv	a2,s3
    80001936:	85ca                	mv	a1,s2
    80001938:	6928                	ld	a0,80(a0)
    8000193a:	fffff097          	auipc	ra,0xfffff
    8000193e:	1da080e7          	jalr	474(ra) # 80000b14 <copyout>
    }
    else {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    80001942:	70a2                	ld	ra,40(sp)
    80001944:	7402                	ld	s0,32(sp)
    80001946:	64e2                	ld	s1,24(sp)
    80001948:	6942                	ld	s2,16(sp)
    8000194a:	69a2                	ld	s3,8(sp)
    8000194c:	6a02                	ld	s4,0(sp)
    8000194e:	6145                	addi	sp,sp,48
    80001950:	8082                	ret
        memmove((char *)dst, src, len);
    80001952:	000a061b          	sext.w	a2,s4
    80001956:	85ce                	mv	a1,s3
    80001958:	854a                	mv	a0,s2
    8000195a:	fffff097          	auipc	ra,0xfffff
    8000195e:	87c080e7          	jalr	-1924(ra) # 800001d6 <memmove>
        return 0;
    80001962:	8526                	mv	a0,s1
    80001964:	bff9                	j	80001942 <either_copyout+0x32>

0000000080001966 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001966:	7179                	addi	sp,sp,-48
    80001968:	f406                	sd	ra,40(sp)
    8000196a:	f022                	sd	s0,32(sp)
    8000196c:	ec26                	sd	s1,24(sp)
    8000196e:	e84a                	sd	s2,16(sp)
    80001970:	e44e                	sd	s3,8(sp)
    80001972:	e052                	sd	s4,0(sp)
    80001974:	1800                	addi	s0,sp,48
    80001976:	892a                	mv	s2,a0
    80001978:	84ae                	mv	s1,a1
    8000197a:	89b2                	mv	s3,a2
    8000197c:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    8000197e:	fffff097          	auipc	ra,0xfffff
    80001982:	4d6080e7          	jalr	1238(ra) # 80000e54 <myproc>
    if (user_src) {
    80001986:	c08d                	beqz	s1,800019a8 <either_copyin+0x42>
        return copyin(p->pagetable, dst, src, len);
    80001988:	86d2                	mv	a3,s4
    8000198a:	864e                	mv	a2,s3
    8000198c:	85ca                	mv	a1,s2
    8000198e:	6928                	ld	a0,80(a0)
    80001990:	fffff097          	auipc	ra,0xfffff
    80001994:	210080e7          	jalr	528(ra) # 80000ba0 <copyin>
    }
    else {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    80001998:	70a2                	ld	ra,40(sp)
    8000199a:	7402                	ld	s0,32(sp)
    8000199c:	64e2                	ld	s1,24(sp)
    8000199e:	6942                	ld	s2,16(sp)
    800019a0:	69a2                	ld	s3,8(sp)
    800019a2:	6a02                	ld	s4,0(sp)
    800019a4:	6145                	addi	sp,sp,48
    800019a6:	8082                	ret
        memmove(dst, (char *)src, len);
    800019a8:	000a061b          	sext.w	a2,s4
    800019ac:	85ce                	mv	a1,s3
    800019ae:	854a                	mv	a0,s2
    800019b0:	fffff097          	auipc	ra,0xfffff
    800019b4:	826080e7          	jalr	-2010(ra) # 800001d6 <memmove>
        return 0;
    800019b8:	8526                	mv	a0,s1
    800019ba:	bff9                	j	80001998 <either_copyin+0x32>

00000000800019bc <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    800019bc:	715d                	addi	sp,sp,-80
    800019be:	e486                	sd	ra,72(sp)
    800019c0:	e0a2                	sd	s0,64(sp)
    800019c2:	fc26                	sd	s1,56(sp)
    800019c4:	f84a                	sd	s2,48(sp)
    800019c6:	f44e                	sd	s3,40(sp)
    800019c8:	f052                	sd	s4,32(sp)
    800019ca:	ec56                	sd	s5,24(sp)
    800019cc:	e85a                	sd	s6,16(sp)
    800019ce:	e45e                	sd	s7,8(sp)
    800019d0:	0880                	addi	s0,sp,80
    static char *states[] = {[UNUSED] "unused", [USED] "used", [SLEEPING] "sleep ", [RUNNABLE] "runble", [RUNNING] "run   ", [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    800019d2:	00006517          	auipc	a0,0x6
    800019d6:	67650513          	addi	a0,a0,1654 # 80008048 <etext+0x48>
    800019da:	00004097          	auipc	ra,0x4
    800019de:	392080e7          	jalr	914(ra) # 80005d6c <printf>
    for (p = proc; p < &proc[NPROC]; p++) {
    800019e2:	00007497          	auipc	s1,0x7
    800019e6:	4d648493          	addi	s1,s1,1238 # 80008eb8 <proc+0x158>
    800019ea:	0000d917          	auipc	s2,0xd
    800019ee:	4ce90913          	addi	s2,s2,1230 # 8000eeb8 <bcache+0x140>
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019f2:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    800019f4:	00007997          	auipc	s3,0x7
    800019f8:	80c98993          	addi	s3,s3,-2036 # 80008200 <etext+0x200>
        printf("%d %s %s", p->pid, state, p->name);
    800019fc:	00007a97          	auipc	s5,0x7
    80001a00:	80ca8a93          	addi	s5,s5,-2036 # 80008208 <etext+0x208>
        printf("\n");
    80001a04:	00006a17          	auipc	s4,0x6
    80001a08:	644a0a13          	addi	s4,s4,1604 # 80008048 <etext+0x48>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a0c:	00007b97          	auipc	s7,0x7
    80001a10:	83cb8b93          	addi	s7,s7,-1988 # 80008248 <states.0>
    80001a14:	a00d                	j	80001a36 <procdump+0x7a>
        printf("%d %s %s", p->pid, state, p->name);
    80001a16:	ed86a583          	lw	a1,-296(a3)
    80001a1a:	8556                	mv	a0,s5
    80001a1c:	00004097          	auipc	ra,0x4
    80001a20:	350080e7          	jalr	848(ra) # 80005d6c <printf>
        printf("\n");
    80001a24:	8552                	mv	a0,s4
    80001a26:	00004097          	auipc	ra,0x4
    80001a2a:	346080e7          	jalr	838(ra) # 80005d6c <printf>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001a2e:	18048493          	addi	s1,s1,384
    80001a32:	03248263          	beq	s1,s2,80001a56 <procdump+0x9a>
        if (p->state == UNUSED)
    80001a36:	86a6                	mv	a3,s1
    80001a38:	ec04a783          	lw	a5,-320(s1)
    80001a3c:	dbed                	beqz	a5,80001a2e <procdump+0x72>
            state = "???";
    80001a3e:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a40:	fcfb6be3          	bltu	s6,a5,80001a16 <procdump+0x5a>
    80001a44:	02079713          	slli	a4,a5,0x20
    80001a48:	01d75793          	srli	a5,a4,0x1d
    80001a4c:	97de                	add	a5,a5,s7
    80001a4e:	6390                	ld	a2,0(a5)
    80001a50:	f279                	bnez	a2,80001a16 <procdump+0x5a>
            state = "???";
    80001a52:	864e                	mv	a2,s3
    80001a54:	b7c9                	j	80001a16 <procdump+0x5a>
    }
}
    80001a56:	60a6                	ld	ra,72(sp)
    80001a58:	6406                	ld	s0,64(sp)
    80001a5a:	74e2                	ld	s1,56(sp)
    80001a5c:	7942                	ld	s2,48(sp)
    80001a5e:	79a2                	ld	s3,40(sp)
    80001a60:	7a02                	ld	s4,32(sp)
    80001a62:	6ae2                	ld	s5,24(sp)
    80001a64:	6b42                	ld	s6,16(sp)
    80001a66:	6ba2                	ld	s7,8(sp)
    80001a68:	6161                	addi	sp,sp,80
    80001a6a:	8082                	ret

0000000080001a6c <swtch>:
    80001a6c:	00153023          	sd	ra,0(a0)
    80001a70:	00253423          	sd	sp,8(a0)
    80001a74:	e900                	sd	s0,16(a0)
    80001a76:	ed04                	sd	s1,24(a0)
    80001a78:	03253023          	sd	s2,32(a0)
    80001a7c:	03353423          	sd	s3,40(a0)
    80001a80:	03453823          	sd	s4,48(a0)
    80001a84:	03553c23          	sd	s5,56(a0)
    80001a88:	05653023          	sd	s6,64(a0)
    80001a8c:	05753423          	sd	s7,72(a0)
    80001a90:	05853823          	sd	s8,80(a0)
    80001a94:	05953c23          	sd	s9,88(a0)
    80001a98:	07a53023          	sd	s10,96(a0)
    80001a9c:	07b53423          	sd	s11,104(a0)
    80001aa0:	0005b083          	ld	ra,0(a1)
    80001aa4:	0085b103          	ld	sp,8(a1)
    80001aa8:	6980                	ld	s0,16(a1)
    80001aaa:	6d84                	ld	s1,24(a1)
    80001aac:	0205b903          	ld	s2,32(a1)
    80001ab0:	0285b983          	ld	s3,40(a1)
    80001ab4:	0305ba03          	ld	s4,48(a1)
    80001ab8:	0385ba83          	ld	s5,56(a1)
    80001abc:	0405bb03          	ld	s6,64(a1)
    80001ac0:	0485bb83          	ld	s7,72(a1)
    80001ac4:	0505bc03          	ld	s8,80(a1)
    80001ac8:	0585bc83          	ld	s9,88(a1)
    80001acc:	0605bd03          	ld	s10,96(a1)
    80001ad0:	0685bd83          	ld	s11,104(a1)
    80001ad4:	8082                	ret

0000000080001ad6 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80001ad6:	1141                	addi	sp,sp,-16
    80001ad8:	e406                	sd	ra,8(sp)
    80001ada:	e022                	sd	s0,0(sp)
    80001adc:	0800                	addi	s0,sp,16
    initlock(&tickslock, "time");
    80001ade:	00006597          	auipc	a1,0x6
    80001ae2:	79a58593          	addi	a1,a1,1946 # 80008278 <states.0+0x30>
    80001ae6:	0000d517          	auipc	a0,0xd
    80001aea:	27a50513          	addi	a0,a0,634 # 8000ed60 <tickslock>
    80001aee:	00004097          	auipc	ra,0x4
    80001af2:	6aa080e7          	jalr	1706(ra) # 80006198 <initlock>
}
    80001af6:	60a2                	ld	ra,8(sp)
    80001af8:	6402                	ld	s0,0(sp)
    80001afa:	0141                	addi	sp,sp,16
    80001afc:	8082                	ret

0000000080001afe <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80001afe:	1141                	addi	sp,sp,-16
    80001b00:	e422                	sd	s0,8(sp)
    80001b02:	0800                	addi	s0,sp,16
    asm volatile("csrw stvec, %0" : : "r"(x));
    80001b04:	00003797          	auipc	a5,0x3
    80001b08:	5bc78793          	addi	a5,a5,1468 # 800050c0 <kernelvec>
    80001b0c:	10579073          	csrw	stvec,a5
    w_stvec((uint64)kernelvec);
}
    80001b10:	6422                	ld	s0,8(sp)
    80001b12:	0141                	addi	sp,sp,16
    80001b14:	8082                	ret

0000000080001b16 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80001b16:	1141                	addi	sp,sp,-16
    80001b18:	e406                	sd	ra,8(sp)
    80001b1a:	e022                	sd	s0,0(sp)
    80001b1c:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80001b1e:	fffff097          	auipc	ra,0xfffff
    80001b22:	336080e7          	jalr	822(ra) # 80000e54 <myproc>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80001b26:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b2a:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80001b2c:	10079073          	csrw	sstatus,a5
    // kerneltrap() to usertrap(), so turn off interrupts until
    // we're back in user space, where usertrap() is correct.
    intr_off();

    // send syscalls, interrupts, and exceptions to uservec in trampoline.S
    uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b30:	00005697          	auipc	a3,0x5
    80001b34:	4d068693          	addi	a3,a3,1232 # 80007000 <_trampoline>
    80001b38:	00005717          	auipc	a4,0x5
    80001b3c:	4c870713          	addi	a4,a4,1224 # 80007000 <_trampoline>
    80001b40:	8f15                	sub	a4,a4,a3
    80001b42:	040007b7          	lui	a5,0x4000
    80001b46:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b48:	07b2                	slli	a5,a5,0xc
    80001b4a:	973e                	add	a4,a4,a5
    asm volatile("csrw stvec, %0" : : "r"(x));
    80001b4c:	10571073          	csrw	stvec,a4
    w_stvec(trampoline_uservec);

    // set up trapframe values that uservec will need when
    // the process next traps into the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b50:	6d38                	ld	a4,88(a0)
    asm volatile("csrr %0, satp" : "=r"(x));
    80001b52:	18002673          	csrr	a2,satp
    80001b56:	e310                	sd	a2,0(a4)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b58:	6d30                	ld	a2,88(a0)
    80001b5a:	6138                	ld	a4,64(a0)
    80001b5c:	6585                	lui	a1,0x1
    80001b5e:	972e                	add	a4,a4,a1
    80001b60:	e618                	sd	a4,8(a2)
    p->trapframe->kernel_trap = (uint64)usertrap;
    80001b62:	6d38                	ld	a4,88(a0)
    80001b64:	00000617          	auipc	a2,0x0
    80001b68:	13060613          	addi	a2,a2,304 # 80001c94 <usertrap>
    80001b6c:	eb10                	sd	a2,16(a4)
    p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80001b6e:	6d38                	ld	a4,88(a0)
    asm volatile("mv %0, tp" : "=r"(x));
    80001b70:	8612                	mv	a2,tp
    80001b72:	f310                	sd	a2,32(a4)
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80001b74:	10002773          	csrr	a4,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b78:	eff77713          	andi	a4,a4,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b7c:	02076713          	ori	a4,a4,32
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80001b80:	10071073          	csrw	sstatus,a4
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
    80001b84:	6d38                	ld	a4,88(a0)
    asm volatile("csrw sepc, %0" : : "r"(x));
    80001b86:	6f18                	ld	a4,24(a4)
    80001b88:	14171073          	csrw	sepc,a4

    // tell trampoline.S the user page table to switch to.
    uint64 satp = MAKE_SATP(p->pagetable);
    80001b8c:	6928                	ld	a0,80(a0)
    80001b8e:	8131                	srli	a0,a0,0xc

    // jump to userret in trampoline.S at the top of memory, which
    // switches to the user page table, restores user registers,
    // and switches to user mode with sret.
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001b90:	00005717          	auipc	a4,0x5
    80001b94:	50c70713          	addi	a4,a4,1292 # 8000709c <userret>
    80001b98:	8f15                	sub	a4,a4,a3
    80001b9a:	97ba                	add	a5,a5,a4
    ((void (*)(uint64))trampoline_userret)(satp);
    80001b9c:	577d                	li	a4,-1
    80001b9e:	177e                	slli	a4,a4,0x3f
    80001ba0:	8d59                	or	a0,a0,a4
    80001ba2:	9782                	jalr	a5
}
    80001ba4:	60a2                	ld	ra,8(sp)
    80001ba6:	6402                	ld	s0,0(sp)
    80001ba8:	0141                	addi	sp,sp,16
    80001baa:	8082                	ret

0000000080001bac <clockintr>:
    w_sepc(sepc);
    w_sstatus(sstatus);
}

void clockintr()
{
    80001bac:	1101                	addi	sp,sp,-32
    80001bae:	ec06                	sd	ra,24(sp)
    80001bb0:	e822                	sd	s0,16(sp)
    80001bb2:	e426                	sd	s1,8(sp)
    80001bb4:	1000                	addi	s0,sp,32
    acquire(&tickslock);
    80001bb6:	0000d497          	auipc	s1,0xd
    80001bba:	1aa48493          	addi	s1,s1,426 # 8000ed60 <tickslock>
    80001bbe:	8526                	mv	a0,s1
    80001bc0:	00004097          	auipc	ra,0x4
    80001bc4:	668080e7          	jalr	1640(ra) # 80006228 <acquire>
    ticks++;
    80001bc8:	00007517          	auipc	a0,0x7
    80001bcc:	d3050513          	addi	a0,a0,-720 # 800088f8 <ticks>
    80001bd0:	411c                	lw	a5,0(a0)
    80001bd2:	2785                	addiw	a5,a5,1
    80001bd4:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001bd6:	00000097          	auipc	ra,0x0
    80001bda:	996080e7          	jalr	-1642(ra) # 8000156c <wakeup>
    release(&tickslock);
    80001bde:	8526                	mv	a0,s1
    80001be0:	00004097          	auipc	ra,0x4
    80001be4:	6fc080e7          	jalr	1788(ra) # 800062dc <release>
}
    80001be8:	60e2                	ld	ra,24(sp)
    80001bea:	6442                	ld	s0,16(sp)
    80001bec:	64a2                	ld	s1,8(sp)
    80001bee:	6105                	addi	sp,sp,32
    80001bf0:	8082                	ret

0000000080001bf2 <devintr>:
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr()
{
    80001bf2:	1101                	addi	sp,sp,-32
    80001bf4:	ec06                	sd	ra,24(sp)
    80001bf6:	e822                	sd	s0,16(sp)
    80001bf8:	e426                	sd	s1,8(sp)
    80001bfa:	1000                	addi	s0,sp,32
    asm volatile("csrr %0, scause" : "=r"(x));
    80001bfc:	14202773          	csrr	a4,scause
    uint64 scause = r_scause();

    if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001c00:	00074d63          	bltz	a4,80001c1a <devintr+0x28>
        if (irq)
            plic_complete(irq);

        return 1;
    }
    else if (scause == 0x8000000000000001L) {
    80001c04:	57fd                	li	a5,-1
    80001c06:	17fe                	slli	a5,a5,0x3f
    80001c08:	0785                	addi	a5,a5,1
        w_sip(r_sip() & ~2);

        return 2;
    }
    else {
        return 0;
    80001c0a:	4501                	li	a0,0
    else if (scause == 0x8000000000000001L) {
    80001c0c:	06f70363          	beq	a4,a5,80001c72 <devintr+0x80>
    }
}
    80001c10:	60e2                	ld	ra,24(sp)
    80001c12:	6442                	ld	s0,16(sp)
    80001c14:	64a2                	ld	s1,8(sp)
    80001c16:	6105                	addi	sp,sp,32
    80001c18:	8082                	ret
    if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001c1a:	0ff77793          	zext.b	a5,a4
    80001c1e:	46a5                	li	a3,9
    80001c20:	fed792e3          	bne	a5,a3,80001c04 <devintr+0x12>
        int irq = plic_claim();
    80001c24:	00003097          	auipc	ra,0x3
    80001c28:	5a4080e7          	jalr	1444(ra) # 800051c8 <plic_claim>
    80001c2c:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ) {
    80001c2e:	47a9                	li	a5,10
    80001c30:	02f50763          	beq	a0,a5,80001c5e <devintr+0x6c>
        else if (irq == VIRTIO0_IRQ) {
    80001c34:	4785                	li	a5,1
    80001c36:	02f50963          	beq	a0,a5,80001c68 <devintr+0x76>
        return 1;
    80001c3a:	4505                	li	a0,1
        else if (irq) {
    80001c3c:	d8f1                	beqz	s1,80001c10 <devintr+0x1e>
            printf("unexpected interrupt irq=%d\n", irq);
    80001c3e:	85a6                	mv	a1,s1
    80001c40:	00006517          	auipc	a0,0x6
    80001c44:	64050513          	addi	a0,a0,1600 # 80008280 <states.0+0x38>
    80001c48:	00004097          	auipc	ra,0x4
    80001c4c:	124080e7          	jalr	292(ra) # 80005d6c <printf>
            plic_complete(irq);
    80001c50:	8526                	mv	a0,s1
    80001c52:	00003097          	auipc	ra,0x3
    80001c56:	59a080e7          	jalr	1434(ra) # 800051ec <plic_complete>
        return 1;
    80001c5a:	4505                	li	a0,1
    80001c5c:	bf55                	j	80001c10 <devintr+0x1e>
            uartintr();
    80001c5e:	00004097          	auipc	ra,0x4
    80001c62:	4ea080e7          	jalr	1258(ra) # 80006148 <uartintr>
    80001c66:	b7ed                	j	80001c50 <devintr+0x5e>
            virtio_disk_intr();
    80001c68:	00004097          	auipc	ra,0x4
    80001c6c:	a4c080e7          	jalr	-1460(ra) # 800056b4 <virtio_disk_intr>
    80001c70:	b7c5                	j	80001c50 <devintr+0x5e>
        if (cpuid() == 0) {
    80001c72:	fffff097          	auipc	ra,0xfffff
    80001c76:	1b6080e7          	jalr	438(ra) # 80000e28 <cpuid>
    80001c7a:	c901                	beqz	a0,80001c8a <devintr+0x98>
    asm volatile("csrr %0, sip" : "=r"(x));
    80001c7c:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    80001c80:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sip, %0" : : "r"(x));
    80001c82:	14479073          	csrw	sip,a5
        return 2;
    80001c86:	4509                	li	a0,2
    80001c88:	b761                	j	80001c10 <devintr+0x1e>
            clockintr();
    80001c8a:	00000097          	auipc	ra,0x0
    80001c8e:	f22080e7          	jalr	-222(ra) # 80001bac <clockintr>
    80001c92:	b7ed                	j	80001c7c <devintr+0x8a>

0000000080001c94 <usertrap>:
{
    80001c94:	1101                	addi	sp,sp,-32
    80001c96:	ec06                	sd	ra,24(sp)
    80001c98:	e822                	sd	s0,16(sp)
    80001c9a:	e426                	sd	s1,8(sp)
    80001c9c:	e04a                	sd	s2,0(sp)
    80001c9e:	1000                	addi	s0,sp,32
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80001ca0:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    80001ca4:	1007f793          	andi	a5,a5,256
    80001ca8:	e3b1                	bnez	a5,80001cec <usertrap+0x58>
    asm volatile("csrw stvec, %0" : : "r"(x));
    80001caa:	00003797          	auipc	a5,0x3
    80001cae:	41678793          	addi	a5,a5,1046 # 800050c0 <kernelvec>
    80001cb2:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80001cb6:	fffff097          	auipc	ra,0xfffff
    80001cba:	19e080e7          	jalr	414(ra) # 80000e54 <myproc>
    80001cbe:	84aa                	mv	s1,a0
    p->trapframe->epc = r_sepc();
    80001cc0:	6d3c                	ld	a5,88(a0)
    asm volatile("csrr %0, sepc" : "=r"(x));
    80001cc2:	14102773          	csrr	a4,sepc
    80001cc6:	ef98                	sd	a4,24(a5)
    asm volatile("csrr %0, scause" : "=r"(x));
    80001cc8:	14202773          	csrr	a4,scause
    if (r_scause() == 8) {
    80001ccc:	47a1                	li	a5,8
    80001cce:	02f70763          	beq	a4,a5,80001cfc <usertrap+0x68>
    else if ((which_dev = devintr()) != 0) {
    80001cd2:	00000097          	auipc	ra,0x0
    80001cd6:	f20080e7          	jalr	-224(ra) # 80001bf2 <devintr>
    80001cda:	892a                	mv	s2,a0
    80001cdc:	c92d                	beqz	a0,80001d4e <usertrap+0xba>
    if (killed(p))
    80001cde:	8526                	mv	a0,s1
    80001ce0:	00000097          	auipc	ra,0x0
    80001ce4:	ad0080e7          	jalr	-1328(ra) # 800017b0 <killed>
    80001ce8:	c555                	beqz	a0,80001d94 <usertrap+0x100>
    80001cea:	a045                	j	80001d8a <usertrap+0xf6>
        panic("usertrap: not from user mode");
    80001cec:	00006517          	auipc	a0,0x6
    80001cf0:	5b450513          	addi	a0,a0,1460 # 800082a0 <states.0+0x58>
    80001cf4:	00004097          	auipc	ra,0x4
    80001cf8:	026080e7          	jalr	38(ra) # 80005d1a <panic>
        if (killed(p))
    80001cfc:	00000097          	auipc	ra,0x0
    80001d00:	ab4080e7          	jalr	-1356(ra) # 800017b0 <killed>
    80001d04:	ed1d                	bnez	a0,80001d42 <usertrap+0xae>
        p->trapframe->epc += 4;
    80001d06:	6cb8                	ld	a4,88(s1)
    80001d08:	6f1c                	ld	a5,24(a4)
    80001d0a:	0791                	addi	a5,a5,4
    80001d0c:	ef1c                	sd	a5,24(a4)
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80001d0e:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d12:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80001d16:	10079073          	csrw	sstatus,a5
        syscall();
    80001d1a:	00000097          	auipc	ra,0x0
    80001d1e:	31a080e7          	jalr	794(ra) # 80002034 <syscall>
    if (killed(p))
    80001d22:	8526                	mv	a0,s1
    80001d24:	00000097          	auipc	ra,0x0
    80001d28:	a8c080e7          	jalr	-1396(ra) # 800017b0 <killed>
    80001d2c:	ed31                	bnez	a0,80001d88 <usertrap+0xf4>
    usertrapret();
    80001d2e:	00000097          	auipc	ra,0x0
    80001d32:	de8080e7          	jalr	-536(ra) # 80001b16 <usertrapret>
}
    80001d36:	60e2                	ld	ra,24(sp)
    80001d38:	6442                	ld	s0,16(sp)
    80001d3a:	64a2                	ld	s1,8(sp)
    80001d3c:	6902                	ld	s2,0(sp)
    80001d3e:	6105                	addi	sp,sp,32
    80001d40:	8082                	ret
            exit(-1);
    80001d42:	557d                	li	a0,-1
    80001d44:	00000097          	auipc	ra,0x0
    80001d48:	8f8080e7          	jalr	-1800(ra) # 8000163c <exit>
    80001d4c:	bf6d                	j	80001d06 <usertrap+0x72>
    asm volatile("csrr %0, scause" : "=r"(x));
    80001d4e:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d52:	5890                	lw	a2,48(s1)
    80001d54:	00006517          	auipc	a0,0x6
    80001d58:	56c50513          	addi	a0,a0,1388 # 800082c0 <states.0+0x78>
    80001d5c:	00004097          	auipc	ra,0x4
    80001d60:	010080e7          	jalr	16(ra) # 80005d6c <printf>
    asm volatile("csrr %0, sepc" : "=r"(x));
    80001d64:	141025f3          	csrr	a1,sepc
    asm volatile("csrr %0, stval" : "=r"(x));
    80001d68:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d6c:	00006517          	auipc	a0,0x6
    80001d70:	58450513          	addi	a0,a0,1412 # 800082f0 <states.0+0xa8>
    80001d74:	00004097          	auipc	ra,0x4
    80001d78:	ff8080e7          	jalr	-8(ra) # 80005d6c <printf>
        setkilled(p);
    80001d7c:	8526                	mv	a0,s1
    80001d7e:	00000097          	auipc	ra,0x0
    80001d82:	a06080e7          	jalr	-1530(ra) # 80001784 <setkilled>
    80001d86:	bf71                	j	80001d22 <usertrap+0x8e>
    if (killed(p))
    80001d88:	4901                	li	s2,0
        exit(-1);
    80001d8a:	557d                	li	a0,-1
    80001d8c:	00000097          	auipc	ra,0x0
    80001d90:	8b0080e7          	jalr	-1872(ra) # 8000163c <exit>
    if (which_dev == 2) {
    80001d94:	4789                	li	a5,2
    80001d96:	f8f91ce3          	bne	s2,a5,80001d2e <usertrap+0x9a>
        if (p->interval != 0) {
    80001d9a:	1684a783          	lw	a5,360(s1)
    80001d9e:	cb91                	beqz	a5,80001db2 <usertrap+0x11e>
            p->ticks += 1;
    80001da0:	16c4a703          	lw	a4,364(s1)
    80001da4:	2705                	addiw	a4,a4,1
    80001da6:	0007069b          	sext.w	a3,a4
            if (p->ticks == p->interval) {
    80001daa:	00d78963          	beq	a5,a3,80001dbc <usertrap+0x128>
            p->ticks += 1;
    80001dae:	16e4a623          	sw	a4,364(s1)
        yield();
    80001db2:	fffff097          	auipc	ra,0xfffff
    80001db6:	71a080e7          	jalr	1818(ra) # 800014cc <yield>
    80001dba:	bf95                	j	80001d2e <usertrap+0x9a>
                p->ticks = 0;
    80001dbc:	1604a623          	sw	zero,364(s1)
                if (p->trapframe_saved == 0) {
    80001dc0:	1784b783          	ld	a5,376(s1)
    80001dc4:	f7fd                	bnez	a5,80001db2 <usertrap+0x11e>
                    p->trapframe_saved = (struct trapframe *)kalloc();
    80001dc6:	ffffe097          	auipc	ra,0xffffe
    80001dca:	354080e7          	jalr	852(ra) # 8000011a <kalloc>
    80001dce:	16a4bc23          	sd	a0,376(s1)
                    memmove(p->trapframe_saved, p->trapframe, sizeof(*p->trapframe_saved));
    80001dd2:	12000613          	li	a2,288
    80001dd6:	6cac                	ld	a1,88(s1)
    80001dd8:	ffffe097          	auipc	ra,0xffffe
    80001ddc:	3fe080e7          	jalr	1022(ra) # 800001d6 <memmove>
                    p->trapframe->epc = p->handler;
    80001de0:	6cbc                	ld	a5,88(s1)
    80001de2:	1704b703          	ld	a4,368(s1)
    80001de6:	ef98                	sd	a4,24(a5)
    80001de8:	b7e9                	j	80001db2 <usertrap+0x11e>

0000000080001dea <kerneltrap>:
{
    80001dea:	7179                	addi	sp,sp,-48
    80001dec:	f406                	sd	ra,40(sp)
    80001dee:	f022                	sd	s0,32(sp)
    80001df0:	ec26                	sd	s1,24(sp)
    80001df2:	e84a                	sd	s2,16(sp)
    80001df4:	e44e                	sd	s3,8(sp)
    80001df6:	1800                	addi	s0,sp,48
    asm volatile("csrr %0, sepc" : "=r"(x));
    80001df8:	14102973          	csrr	s2,sepc
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80001dfc:	100024f3          	csrr	s1,sstatus
    asm volatile("csrr %0, scause" : "=r"(x));
    80001e00:	142029f3          	csrr	s3,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    80001e04:	1004f793          	andi	a5,s1,256
    80001e08:	cb85                	beqz	a5,80001e38 <kerneltrap+0x4e>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e0a:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    80001e0e:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    80001e10:	ef85                	bnez	a5,80001e48 <kerneltrap+0x5e>
    if ((which_dev = devintr()) == 0) {
    80001e12:	00000097          	auipc	ra,0x0
    80001e16:	de0080e7          	jalr	-544(ra) # 80001bf2 <devintr>
    80001e1a:	cd1d                	beqz	a0,80001e58 <kerneltrap+0x6e>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e1c:	4789                	li	a5,2
    80001e1e:	06f50a63          	beq	a0,a5,80001e92 <kerneltrap+0xa8>
    asm volatile("csrw sepc, %0" : : "r"(x));
    80001e22:	14191073          	csrw	sepc,s2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80001e26:	10049073          	csrw	sstatus,s1
}
    80001e2a:	70a2                	ld	ra,40(sp)
    80001e2c:	7402                	ld	s0,32(sp)
    80001e2e:	64e2                	ld	s1,24(sp)
    80001e30:	6942                	ld	s2,16(sp)
    80001e32:	69a2                	ld	s3,8(sp)
    80001e34:	6145                	addi	sp,sp,48
    80001e36:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80001e38:	00006517          	auipc	a0,0x6
    80001e3c:	4d850513          	addi	a0,a0,1240 # 80008310 <states.0+0xc8>
    80001e40:	00004097          	auipc	ra,0x4
    80001e44:	eda080e7          	jalr	-294(ra) # 80005d1a <panic>
        panic("kerneltrap: interrupts enabled");
    80001e48:	00006517          	auipc	a0,0x6
    80001e4c:	4f050513          	addi	a0,a0,1264 # 80008338 <states.0+0xf0>
    80001e50:	00004097          	auipc	ra,0x4
    80001e54:	eca080e7          	jalr	-310(ra) # 80005d1a <panic>
        printf("scause %p\n", scause);
    80001e58:	85ce                	mv	a1,s3
    80001e5a:	00006517          	auipc	a0,0x6
    80001e5e:	4fe50513          	addi	a0,a0,1278 # 80008358 <states.0+0x110>
    80001e62:	00004097          	auipc	ra,0x4
    80001e66:	f0a080e7          	jalr	-246(ra) # 80005d6c <printf>
    asm volatile("csrr %0, sepc" : "=r"(x));
    80001e6a:	141025f3          	csrr	a1,sepc
    asm volatile("csrr %0, stval" : "=r"(x));
    80001e6e:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e72:	00006517          	auipc	a0,0x6
    80001e76:	4f650513          	addi	a0,a0,1270 # 80008368 <states.0+0x120>
    80001e7a:	00004097          	auipc	ra,0x4
    80001e7e:	ef2080e7          	jalr	-270(ra) # 80005d6c <printf>
        panic("kerneltrap");
    80001e82:	00006517          	auipc	a0,0x6
    80001e86:	4fe50513          	addi	a0,a0,1278 # 80008380 <states.0+0x138>
    80001e8a:	00004097          	auipc	ra,0x4
    80001e8e:	e90080e7          	jalr	-368(ra) # 80005d1a <panic>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e92:	fffff097          	auipc	ra,0xfffff
    80001e96:	fc2080e7          	jalr	-62(ra) # 80000e54 <myproc>
    80001e9a:	d541                	beqz	a0,80001e22 <kerneltrap+0x38>
    80001e9c:	fffff097          	auipc	ra,0xfffff
    80001ea0:	fb8080e7          	jalr	-72(ra) # 80000e54 <myproc>
    80001ea4:	4d18                	lw	a4,24(a0)
    80001ea6:	4791                	li	a5,4
    80001ea8:	f6f71de3          	bne	a4,a5,80001e22 <kerneltrap+0x38>
        yield();
    80001eac:	fffff097          	auipc	ra,0xfffff
    80001eb0:	620080e7          	jalr	1568(ra) # 800014cc <yield>
    80001eb4:	b7bd                	j	80001e22 <kerneltrap+0x38>

0000000080001eb6 <argraw>:
        return -1;
    return strlen(buf);
}

static uint64 argraw(int n)
{
    80001eb6:	1101                	addi	sp,sp,-32
    80001eb8:	ec06                	sd	ra,24(sp)
    80001eba:	e822                	sd	s0,16(sp)
    80001ebc:	e426                	sd	s1,8(sp)
    80001ebe:	1000                	addi	s0,sp,32
    80001ec0:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80001ec2:	fffff097          	auipc	ra,0xfffff
    80001ec6:	f92080e7          	jalr	-110(ra) # 80000e54 <myproc>
    switch (n) {
    80001eca:	4795                	li	a5,5
    80001ecc:	0497e163          	bltu	a5,s1,80001f0e <argraw+0x58>
    80001ed0:	048a                	slli	s1,s1,0x2
    80001ed2:	00006717          	auipc	a4,0x6
    80001ed6:	4e670713          	addi	a4,a4,1254 # 800083b8 <states.0+0x170>
    80001eda:	94ba                	add	s1,s1,a4
    80001edc:	409c                	lw	a5,0(s1)
    80001ede:	97ba                	add	a5,a5,a4
    80001ee0:	8782                	jr	a5
    case 0:
        return p->trapframe->a0;
    80001ee2:	6d3c                	ld	a5,88(a0)
    80001ee4:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80001ee6:	60e2                	ld	ra,24(sp)
    80001ee8:	6442                	ld	s0,16(sp)
    80001eea:	64a2                	ld	s1,8(sp)
    80001eec:	6105                	addi	sp,sp,32
    80001eee:	8082                	ret
        return p->trapframe->a1;
    80001ef0:	6d3c                	ld	a5,88(a0)
    80001ef2:	7fa8                	ld	a0,120(a5)
    80001ef4:	bfcd                	j	80001ee6 <argraw+0x30>
        return p->trapframe->a2;
    80001ef6:	6d3c                	ld	a5,88(a0)
    80001ef8:	63c8                	ld	a0,128(a5)
    80001efa:	b7f5                	j	80001ee6 <argraw+0x30>
        return p->trapframe->a3;
    80001efc:	6d3c                	ld	a5,88(a0)
    80001efe:	67c8                	ld	a0,136(a5)
    80001f00:	b7dd                	j	80001ee6 <argraw+0x30>
        return p->trapframe->a4;
    80001f02:	6d3c                	ld	a5,88(a0)
    80001f04:	6bc8                	ld	a0,144(a5)
    80001f06:	b7c5                	j	80001ee6 <argraw+0x30>
        return p->trapframe->a5;
    80001f08:	6d3c                	ld	a5,88(a0)
    80001f0a:	6fc8                	ld	a0,152(a5)
    80001f0c:	bfe9                	j	80001ee6 <argraw+0x30>
    panic("argraw");
    80001f0e:	00006517          	auipc	a0,0x6
    80001f12:	48250513          	addi	a0,a0,1154 # 80008390 <states.0+0x148>
    80001f16:	00004097          	auipc	ra,0x4
    80001f1a:	e04080e7          	jalr	-508(ra) # 80005d1a <panic>

0000000080001f1e <fetchaddr>:
{
    80001f1e:	1101                	addi	sp,sp,-32
    80001f20:	ec06                	sd	ra,24(sp)
    80001f22:	e822                	sd	s0,16(sp)
    80001f24:	e426                	sd	s1,8(sp)
    80001f26:	e04a                	sd	s2,0(sp)
    80001f28:	1000                	addi	s0,sp,32
    80001f2a:	84aa                	mv	s1,a0
    80001f2c:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80001f2e:	fffff097          	auipc	ra,0xfffff
    80001f32:	f26080e7          	jalr	-218(ra) # 80000e54 <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001f36:	653c                	ld	a5,72(a0)
    80001f38:	02f4f863          	bgeu	s1,a5,80001f68 <fetchaddr+0x4a>
    80001f3c:	00848713          	addi	a4,s1,8
    80001f40:	02e7e663          	bltu	a5,a4,80001f6c <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f44:	46a1                	li	a3,8
    80001f46:	8626                	mv	a2,s1
    80001f48:	85ca                	mv	a1,s2
    80001f4a:	6928                	ld	a0,80(a0)
    80001f4c:	fffff097          	auipc	ra,0xfffff
    80001f50:	c54080e7          	jalr	-940(ra) # 80000ba0 <copyin>
    80001f54:	00a03533          	snez	a0,a0
    80001f58:	40a00533          	neg	a0,a0
}
    80001f5c:	60e2                	ld	ra,24(sp)
    80001f5e:	6442                	ld	s0,16(sp)
    80001f60:	64a2                	ld	s1,8(sp)
    80001f62:	6902                	ld	s2,0(sp)
    80001f64:	6105                	addi	sp,sp,32
    80001f66:	8082                	ret
        return -1;
    80001f68:	557d                	li	a0,-1
    80001f6a:	bfcd                	j	80001f5c <fetchaddr+0x3e>
    80001f6c:	557d                	li	a0,-1
    80001f6e:	b7fd                	j	80001f5c <fetchaddr+0x3e>

0000000080001f70 <fetchstr>:
{
    80001f70:	7179                	addi	sp,sp,-48
    80001f72:	f406                	sd	ra,40(sp)
    80001f74:	f022                	sd	s0,32(sp)
    80001f76:	ec26                	sd	s1,24(sp)
    80001f78:	e84a                	sd	s2,16(sp)
    80001f7a:	e44e                	sd	s3,8(sp)
    80001f7c:	1800                	addi	s0,sp,48
    80001f7e:	892a                	mv	s2,a0
    80001f80:	84ae                	mv	s1,a1
    80001f82:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    80001f84:	fffff097          	auipc	ra,0xfffff
    80001f88:	ed0080e7          	jalr	-304(ra) # 80000e54 <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80001f8c:	86ce                	mv	a3,s3
    80001f8e:	864a                	mv	a2,s2
    80001f90:	85a6                	mv	a1,s1
    80001f92:	6928                	ld	a0,80(a0)
    80001f94:	fffff097          	auipc	ra,0xfffff
    80001f98:	c9a080e7          	jalr	-870(ra) # 80000c2e <copyinstr>
    80001f9c:	00054e63          	bltz	a0,80001fb8 <fetchstr+0x48>
    return strlen(buf);
    80001fa0:	8526                	mv	a0,s1
    80001fa2:	ffffe097          	auipc	ra,0xffffe
    80001fa6:	354080e7          	jalr	852(ra) # 800002f6 <strlen>
}
    80001faa:	70a2                	ld	ra,40(sp)
    80001fac:	7402                	ld	s0,32(sp)
    80001fae:	64e2                	ld	s1,24(sp)
    80001fb0:	6942                	ld	s2,16(sp)
    80001fb2:	69a2                	ld	s3,8(sp)
    80001fb4:	6145                	addi	sp,sp,48
    80001fb6:	8082                	ret
        return -1;
    80001fb8:	557d                	li	a0,-1
    80001fba:	bfc5                	j	80001faa <fetchstr+0x3a>

0000000080001fbc <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    80001fbc:	1101                	addi	sp,sp,-32
    80001fbe:	ec06                	sd	ra,24(sp)
    80001fc0:	e822                	sd	s0,16(sp)
    80001fc2:	e426                	sd	s1,8(sp)
    80001fc4:	1000                	addi	s0,sp,32
    80001fc6:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80001fc8:	00000097          	auipc	ra,0x0
    80001fcc:	eee080e7          	jalr	-274(ra) # 80001eb6 <argraw>
    80001fd0:	c088                	sw	a0,0(s1)
}
    80001fd2:	60e2                	ld	ra,24(sp)
    80001fd4:	6442                	ld	s0,16(sp)
    80001fd6:	64a2                	ld	s1,8(sp)
    80001fd8:	6105                	addi	sp,sp,32
    80001fda:	8082                	ret

0000000080001fdc <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    80001fdc:	1101                	addi	sp,sp,-32
    80001fde:	ec06                	sd	ra,24(sp)
    80001fe0:	e822                	sd	s0,16(sp)
    80001fe2:	e426                	sd	s1,8(sp)
    80001fe4:	1000                	addi	s0,sp,32
    80001fe6:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80001fe8:	00000097          	auipc	ra,0x0
    80001fec:	ece080e7          	jalr	-306(ra) # 80001eb6 <argraw>
    80001ff0:	e088                	sd	a0,0(s1)
}
    80001ff2:	60e2                	ld	ra,24(sp)
    80001ff4:	6442                	ld	s0,16(sp)
    80001ff6:	64a2                	ld	s1,8(sp)
    80001ff8:	6105                	addi	sp,sp,32
    80001ffa:	8082                	ret

0000000080001ffc <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    80001ffc:	7179                	addi	sp,sp,-48
    80001ffe:	f406                	sd	ra,40(sp)
    80002000:	f022                	sd	s0,32(sp)
    80002002:	ec26                	sd	s1,24(sp)
    80002004:	e84a                	sd	s2,16(sp)
    80002006:	1800                	addi	s0,sp,48
    80002008:	84ae                	mv	s1,a1
    8000200a:	8932                	mv	s2,a2
    uint64 addr;
    argaddr(n, &addr);
    8000200c:	fd840593          	addi	a1,s0,-40
    80002010:	00000097          	auipc	ra,0x0
    80002014:	fcc080e7          	jalr	-52(ra) # 80001fdc <argaddr>
    return fetchstr(addr, buf, max);
    80002018:	864a                	mv	a2,s2
    8000201a:	85a6                	mv	a1,s1
    8000201c:	fd843503          	ld	a0,-40(s0)
    80002020:	00000097          	auipc	ra,0x0
    80002024:	f50080e7          	jalr	-176(ra) # 80001f70 <fetchstr>
}
    80002028:	70a2                	ld	ra,40(sp)
    8000202a:	7402                	ld	s0,32(sp)
    8000202c:	64e2                	ld	s1,24(sp)
    8000202e:	6942                	ld	s2,16(sp)
    80002030:	6145                	addi	sp,sp,48
    80002032:	8082                	ret

0000000080002034 <syscall>:
    [SYS_sleep] sys_sleep, [SYS_uptime] sys_uptime, [SYS_open] sys_open,   [SYS_write] sys_write,       [SYS_mknod] sys_mknod,         [SYS_unlink] sys_unlink,
    [SYS_link] sys_link,   [SYS_mkdir] sys_mkdir,   [SYS_close] sys_close, [SYS_sigalarm] sys_sigalarm, [SYS_sigreturn] sys_sigreturn,
};

void syscall(void)
{
    80002034:	1101                	addi	sp,sp,-32
    80002036:	ec06                	sd	ra,24(sp)
    80002038:	e822                	sd	s0,16(sp)
    8000203a:	e426                	sd	s1,8(sp)
    8000203c:	e04a                	sd	s2,0(sp)
    8000203e:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    80002040:	fffff097          	auipc	ra,0xfffff
    80002044:	e14080e7          	jalr	-492(ra) # 80000e54 <myproc>
    80002048:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    8000204a:	05853903          	ld	s2,88(a0)
    8000204e:	0a893783          	ld	a5,168(s2)
    80002052:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002056:	37fd                	addiw	a5,a5,-1
    80002058:	4759                	li	a4,22
    8000205a:	00f76f63          	bltu	a4,a5,80002078 <syscall+0x44>
    8000205e:	00369713          	slli	a4,a3,0x3
    80002062:	00006797          	auipc	a5,0x6
    80002066:	36e78793          	addi	a5,a5,878 # 800083d0 <syscalls>
    8000206a:	97ba                	add	a5,a5,a4
    8000206c:	639c                	ld	a5,0(a5)
    8000206e:	c789                	beqz	a5,80002078 <syscall+0x44>
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    80002070:	9782                	jalr	a5
    80002072:	06a93823          	sd	a0,112(s2)
    80002076:	a839                	j	80002094 <syscall+0x60>
    }
    else {
        printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    80002078:	15848613          	addi	a2,s1,344
    8000207c:	588c                	lw	a1,48(s1)
    8000207e:	00006517          	auipc	a0,0x6
    80002082:	31a50513          	addi	a0,a0,794 # 80008398 <states.0+0x150>
    80002086:	00004097          	auipc	ra,0x4
    8000208a:	ce6080e7          	jalr	-794(ra) # 80005d6c <printf>
        p->trapframe->a0 = -1;
    8000208e:	6cbc                	ld	a5,88(s1)
    80002090:	577d                	li	a4,-1
    80002092:	fbb8                	sd	a4,112(a5)
    }
}
    80002094:	60e2                	ld	ra,24(sp)
    80002096:	6442                	ld	s0,16(sp)
    80002098:	64a2                	ld	s1,8(sp)
    8000209a:	6902                	ld	s2,0(sp)
    8000209c:	6105                	addi	sp,sp,32
    8000209e:	8082                	ret

00000000800020a0 <sys_exit>:
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64 sys_exit(void)
{
    800020a0:	1101                	addi	sp,sp,-32
    800020a2:	ec06                	sd	ra,24(sp)
    800020a4:	e822                	sd	s0,16(sp)
    800020a6:	1000                	addi	s0,sp,32
    int n;
    argint(0, &n);
    800020a8:	fec40593          	addi	a1,s0,-20
    800020ac:	4501                	li	a0,0
    800020ae:	00000097          	auipc	ra,0x0
    800020b2:	f0e080e7          	jalr	-242(ra) # 80001fbc <argint>
    exit(n);
    800020b6:	fec42503          	lw	a0,-20(s0)
    800020ba:	fffff097          	auipc	ra,0xfffff
    800020be:	582080e7          	jalr	1410(ra) # 8000163c <exit>
    return 0; // not reached
}
    800020c2:	4501                	li	a0,0
    800020c4:	60e2                	ld	ra,24(sp)
    800020c6:	6442                	ld	s0,16(sp)
    800020c8:	6105                	addi	sp,sp,32
    800020ca:	8082                	ret

00000000800020cc <sys_getpid>:

uint64 sys_getpid(void)
{
    800020cc:	1141                	addi	sp,sp,-16
    800020ce:	e406                	sd	ra,8(sp)
    800020d0:	e022                	sd	s0,0(sp)
    800020d2:	0800                	addi	s0,sp,16
    return myproc()->pid;
    800020d4:	fffff097          	auipc	ra,0xfffff
    800020d8:	d80080e7          	jalr	-640(ra) # 80000e54 <myproc>
}
    800020dc:	5908                	lw	a0,48(a0)
    800020de:	60a2                	ld	ra,8(sp)
    800020e0:	6402                	ld	s0,0(sp)
    800020e2:	0141                	addi	sp,sp,16
    800020e4:	8082                	ret

00000000800020e6 <sys_fork>:

uint64 sys_fork(void)
{
    800020e6:	1141                	addi	sp,sp,-16
    800020e8:	e406                	sd	ra,8(sp)
    800020ea:	e022                	sd	s0,0(sp)
    800020ec:	0800                	addi	s0,sp,16
    return fork();
    800020ee:	fffff097          	auipc	ra,0xfffff
    800020f2:	128080e7          	jalr	296(ra) # 80001216 <fork>
}
    800020f6:	60a2                	ld	ra,8(sp)
    800020f8:	6402                	ld	s0,0(sp)
    800020fa:	0141                	addi	sp,sp,16
    800020fc:	8082                	ret

00000000800020fe <sys_wait>:

uint64 sys_wait(void)
{
    800020fe:	1101                	addi	sp,sp,-32
    80002100:	ec06                	sd	ra,24(sp)
    80002102:	e822                	sd	s0,16(sp)
    80002104:	1000                	addi	s0,sp,32
    uint64 p;
    argaddr(0, &p);
    80002106:	fe840593          	addi	a1,s0,-24
    8000210a:	4501                	li	a0,0
    8000210c:	00000097          	auipc	ra,0x0
    80002110:	ed0080e7          	jalr	-304(ra) # 80001fdc <argaddr>
    return wait(p);
    80002114:	fe843503          	ld	a0,-24(s0)
    80002118:	fffff097          	auipc	ra,0xfffff
    8000211c:	6ca080e7          	jalr	1738(ra) # 800017e2 <wait>
}
    80002120:	60e2                	ld	ra,24(sp)
    80002122:	6442                	ld	s0,16(sp)
    80002124:	6105                	addi	sp,sp,32
    80002126:	8082                	ret

0000000080002128 <sys_sbrk>:

uint64 sys_sbrk(void)
{
    80002128:	7179                	addi	sp,sp,-48
    8000212a:	f406                	sd	ra,40(sp)
    8000212c:	f022                	sd	s0,32(sp)
    8000212e:	ec26                	sd	s1,24(sp)
    80002130:	1800                	addi	s0,sp,48
    uint64 addr;
    int n;

    argint(0, &n);
    80002132:	fdc40593          	addi	a1,s0,-36
    80002136:	4501                	li	a0,0
    80002138:	00000097          	auipc	ra,0x0
    8000213c:	e84080e7          	jalr	-380(ra) # 80001fbc <argint>
    addr = myproc()->sz;
    80002140:	fffff097          	auipc	ra,0xfffff
    80002144:	d14080e7          	jalr	-748(ra) # 80000e54 <myproc>
    80002148:	6524                	ld	s1,72(a0)
    if (growproc(n) < 0)
    8000214a:	fdc42503          	lw	a0,-36(s0)
    8000214e:	fffff097          	auipc	ra,0xfffff
    80002152:	06c080e7          	jalr	108(ra) # 800011ba <growproc>
    80002156:	00054863          	bltz	a0,80002166 <sys_sbrk+0x3e>
        return -1;
    return addr;
}
    8000215a:	8526                	mv	a0,s1
    8000215c:	70a2                	ld	ra,40(sp)
    8000215e:	7402                	ld	s0,32(sp)
    80002160:	64e2                	ld	s1,24(sp)
    80002162:	6145                	addi	sp,sp,48
    80002164:	8082                	ret
        return -1;
    80002166:	54fd                	li	s1,-1
    80002168:	bfcd                	j	8000215a <sys_sbrk+0x32>

000000008000216a <sys_sleep>:

uint64 sys_sleep(void)
{
    8000216a:	7139                	addi	sp,sp,-64
    8000216c:	fc06                	sd	ra,56(sp)
    8000216e:	f822                	sd	s0,48(sp)
    80002170:	f426                	sd	s1,40(sp)
    80002172:	f04a                	sd	s2,32(sp)
    80002174:	ec4e                	sd	s3,24(sp)
    80002176:	0080                	addi	s0,sp,64
    int n;
    uint ticks0;
    backtrace();
    80002178:	00004097          	auipc	ra,0x4
    8000217c:	b46080e7          	jalr	-1210(ra) # 80005cbe <backtrace>
    argint(0, &n);
    80002180:	fcc40593          	addi	a1,s0,-52
    80002184:	4501                	li	a0,0
    80002186:	00000097          	auipc	ra,0x0
    8000218a:	e36080e7          	jalr	-458(ra) # 80001fbc <argint>
    if (n < 0)
    8000218e:	fcc42783          	lw	a5,-52(s0)
    80002192:	0607cf63          	bltz	a5,80002210 <sys_sleep+0xa6>
        n = 0;
    acquire(&tickslock);
    80002196:	0000d517          	auipc	a0,0xd
    8000219a:	bca50513          	addi	a0,a0,-1078 # 8000ed60 <tickslock>
    8000219e:	00004097          	auipc	ra,0x4
    800021a2:	08a080e7          	jalr	138(ra) # 80006228 <acquire>
    ticks0 = ticks;
    800021a6:	00006917          	auipc	s2,0x6
    800021aa:	75292903          	lw	s2,1874(s2) # 800088f8 <ticks>
    while (ticks - ticks0 < n) {
    800021ae:	fcc42783          	lw	a5,-52(s0)
    800021b2:	cf9d                	beqz	a5,800021f0 <sys_sleep+0x86>
        if (killed(myproc())) {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    800021b4:	0000d997          	auipc	s3,0xd
    800021b8:	bac98993          	addi	s3,s3,-1108 # 8000ed60 <tickslock>
    800021bc:	00006497          	auipc	s1,0x6
    800021c0:	73c48493          	addi	s1,s1,1852 # 800088f8 <ticks>
        if (killed(myproc())) {
    800021c4:	fffff097          	auipc	ra,0xfffff
    800021c8:	c90080e7          	jalr	-880(ra) # 80000e54 <myproc>
    800021cc:	fffff097          	auipc	ra,0xfffff
    800021d0:	5e4080e7          	jalr	1508(ra) # 800017b0 <killed>
    800021d4:	e129                	bnez	a0,80002216 <sys_sleep+0xac>
        sleep(&ticks, &tickslock);
    800021d6:	85ce                	mv	a1,s3
    800021d8:	8526                	mv	a0,s1
    800021da:	fffff097          	auipc	ra,0xfffff
    800021de:	32e080e7          	jalr	814(ra) # 80001508 <sleep>
    while (ticks - ticks0 < n) {
    800021e2:	409c                	lw	a5,0(s1)
    800021e4:	412787bb          	subw	a5,a5,s2
    800021e8:	fcc42703          	lw	a4,-52(s0)
    800021ec:	fce7ece3          	bltu	a5,a4,800021c4 <sys_sleep+0x5a>
    }
    release(&tickslock);
    800021f0:	0000d517          	auipc	a0,0xd
    800021f4:	b7050513          	addi	a0,a0,-1168 # 8000ed60 <tickslock>
    800021f8:	00004097          	auipc	ra,0x4
    800021fc:	0e4080e7          	jalr	228(ra) # 800062dc <release>
    return 0;
    80002200:	4501                	li	a0,0
}
    80002202:	70e2                	ld	ra,56(sp)
    80002204:	7442                	ld	s0,48(sp)
    80002206:	74a2                	ld	s1,40(sp)
    80002208:	7902                	ld	s2,32(sp)
    8000220a:	69e2                	ld	s3,24(sp)
    8000220c:	6121                	addi	sp,sp,64
    8000220e:	8082                	ret
        n = 0;
    80002210:	fc042623          	sw	zero,-52(s0)
    80002214:	b749                	j	80002196 <sys_sleep+0x2c>
            release(&tickslock);
    80002216:	0000d517          	auipc	a0,0xd
    8000221a:	b4a50513          	addi	a0,a0,-1206 # 8000ed60 <tickslock>
    8000221e:	00004097          	auipc	ra,0x4
    80002222:	0be080e7          	jalr	190(ra) # 800062dc <release>
            return -1;
    80002226:	557d                	li	a0,-1
    80002228:	bfe9                	j	80002202 <sys_sleep+0x98>

000000008000222a <sys_kill>:

uint64 sys_kill(void)
{
    8000222a:	1101                	addi	sp,sp,-32
    8000222c:	ec06                	sd	ra,24(sp)
    8000222e:	e822                	sd	s0,16(sp)
    80002230:	1000                	addi	s0,sp,32
    int pid;

    argint(0, &pid);
    80002232:	fec40593          	addi	a1,s0,-20
    80002236:	4501                	li	a0,0
    80002238:	00000097          	auipc	ra,0x0
    8000223c:	d84080e7          	jalr	-636(ra) # 80001fbc <argint>
    return kill(pid);
    80002240:	fec42503          	lw	a0,-20(s0)
    80002244:	fffff097          	auipc	ra,0xfffff
    80002248:	4ce080e7          	jalr	1230(ra) # 80001712 <kill>
}
    8000224c:	60e2                	ld	ra,24(sp)
    8000224e:	6442                	ld	s0,16(sp)
    80002250:	6105                	addi	sp,sp,32
    80002252:	8082                	ret

0000000080002254 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void)
{
    80002254:	1101                	addi	sp,sp,-32
    80002256:	ec06                	sd	ra,24(sp)
    80002258:	e822                	sd	s0,16(sp)
    8000225a:	e426                	sd	s1,8(sp)
    8000225c:	1000                	addi	s0,sp,32
    uint xticks;

    acquire(&tickslock);
    8000225e:	0000d517          	auipc	a0,0xd
    80002262:	b0250513          	addi	a0,a0,-1278 # 8000ed60 <tickslock>
    80002266:	00004097          	auipc	ra,0x4
    8000226a:	fc2080e7          	jalr	-62(ra) # 80006228 <acquire>
    xticks = ticks;
    8000226e:	00006497          	auipc	s1,0x6
    80002272:	68a4a483          	lw	s1,1674(s1) # 800088f8 <ticks>
    release(&tickslock);
    80002276:	0000d517          	auipc	a0,0xd
    8000227a:	aea50513          	addi	a0,a0,-1302 # 8000ed60 <tickslock>
    8000227e:	00004097          	auipc	ra,0x4
    80002282:	05e080e7          	jalr	94(ra) # 800062dc <release>
    return xticks;
}
    80002286:	02049513          	slli	a0,s1,0x20
    8000228a:	9101                	srli	a0,a0,0x20
    8000228c:	60e2                	ld	ra,24(sp)
    8000228e:	6442                	ld	s0,16(sp)
    80002290:	64a2                	ld	s1,8(sp)
    80002292:	6105                	addi	sp,sp,32
    80002294:	8082                	ret

0000000080002296 <sys_sigalarm>:

uint64 sys_sigalarm(void)
{
    80002296:	7179                	addi	sp,sp,-48
    80002298:	f406                	sd	ra,40(sp)
    8000229a:	f022                	sd	s0,32(sp)
    8000229c:	ec26                	sd	s1,24(sp)
    8000229e:	1800                	addi	s0,sp,48
    int interval;
    uint64 handler;
    struct proc *p = myproc();
    800022a0:	fffff097          	auipc	ra,0xfffff
    800022a4:	bb4080e7          	jalr	-1100(ra) # 80000e54 <myproc>
    800022a8:	84aa                	mv	s1,a0
    argint(0, &interval);
    800022aa:	fdc40593          	addi	a1,s0,-36
    800022ae:	4501                	li	a0,0
    800022b0:	00000097          	auipc	ra,0x0
    800022b4:	d0c080e7          	jalr	-756(ra) # 80001fbc <argint>
    argaddr(1, &handler);
    800022b8:	fd040593          	addi	a1,s0,-48
    800022bc:	4505                	li	a0,1
    800022be:	00000097          	auipc	ra,0x0
    800022c2:	d1e080e7          	jalr	-738(ra) # 80001fdc <argaddr>

    p->interval = interval;
    800022c6:	fdc42783          	lw	a5,-36(s0)
    800022ca:	16f4a423          	sw	a5,360(s1)
    p->handler = handler;
    800022ce:	fd043783          	ld	a5,-48(s0)
    800022d2:	16f4b823          	sd	a5,368(s1)
    return 0;
}
    800022d6:	4501                	li	a0,0
    800022d8:	70a2                	ld	ra,40(sp)
    800022da:	7402                	ld	s0,32(sp)
    800022dc:	64e2                	ld	s1,24(sp)
    800022de:	6145                	addi	sp,sp,48
    800022e0:	8082                	ret

00000000800022e2 <sys_sigreturn>:

uint64 sys_sigreturn(void)
{
    800022e2:	1101                	addi	sp,sp,-32
    800022e4:	ec06                	sd	ra,24(sp)
    800022e6:	e822                	sd	s0,16(sp)
    800022e8:	e426                	sd	s1,8(sp)
    800022ea:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    800022ec:	fffff097          	auipc	ra,0xfffff
    800022f0:	b68080e7          	jalr	-1176(ra) # 80000e54 <myproc>
    800022f4:	84aa                	mv	s1,a0
    if (p->trapframe_saved) {
    800022f6:	17853583          	ld	a1,376(a0)
    800022fa:	c185                	beqz	a1,8000231a <sys_sigreturn+0x38>
        memmove(p->trapframe, p->trapframe_saved, sizeof(*p->trapframe_saved));
    800022fc:	12000613          	li	a2,288
    80002300:	6d28                	ld	a0,88(a0)
    80002302:	ffffe097          	auipc	ra,0xffffe
    80002306:	ed4080e7          	jalr	-300(ra) # 800001d6 <memmove>
        kfree((void *)p->trapframe_saved);
    8000230a:	1784b503          	ld	a0,376(s1)
    8000230e:	ffffe097          	auipc	ra,0xffffe
    80002312:	d0e080e7          	jalr	-754(ra) # 8000001c <kfree>
        p->trapframe_saved = 0;
    80002316:	1604bc23          	sd	zero,376(s1)
    }
    p->ticks = 0;
    8000231a:	1604a623          	sw	zero,364(s1)
    return p->trapframe->a0;
    8000231e:	6cbc                	ld	a5,88(s1)
}
    80002320:	7ba8                	ld	a0,112(a5)
    80002322:	60e2                	ld	ra,24(sp)
    80002324:	6442                	ld	s0,16(sp)
    80002326:	64a2                	ld	s1,8(sp)
    80002328:	6105                	addi	sp,sp,32
    8000232a:	8082                	ret

000000008000232c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000232c:	7179                	addi	sp,sp,-48
    8000232e:	f406                	sd	ra,40(sp)
    80002330:	f022                	sd	s0,32(sp)
    80002332:	ec26                	sd	s1,24(sp)
    80002334:	e84a                	sd	s2,16(sp)
    80002336:	e44e                	sd	s3,8(sp)
    80002338:	e052                	sd	s4,0(sp)
    8000233a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000233c:	00006597          	auipc	a1,0x6
    80002340:	15458593          	addi	a1,a1,340 # 80008490 <syscalls+0xc0>
    80002344:	0000d517          	auipc	a0,0xd
    80002348:	a3450513          	addi	a0,a0,-1484 # 8000ed78 <bcache>
    8000234c:	00004097          	auipc	ra,0x4
    80002350:	e4c080e7          	jalr	-436(ra) # 80006198 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002354:	00015797          	auipc	a5,0x15
    80002358:	a2478793          	addi	a5,a5,-1500 # 80016d78 <bcache+0x8000>
    8000235c:	00015717          	auipc	a4,0x15
    80002360:	c8470713          	addi	a4,a4,-892 # 80016fe0 <bcache+0x8268>
    80002364:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002368:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000236c:	0000d497          	auipc	s1,0xd
    80002370:	a2448493          	addi	s1,s1,-1500 # 8000ed90 <bcache+0x18>
    b->next = bcache.head.next;
    80002374:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002376:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002378:	00006a17          	auipc	s4,0x6
    8000237c:	120a0a13          	addi	s4,s4,288 # 80008498 <syscalls+0xc8>
    b->next = bcache.head.next;
    80002380:	2b893783          	ld	a5,696(s2)
    80002384:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002386:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000238a:	85d2                	mv	a1,s4
    8000238c:	01048513          	addi	a0,s1,16
    80002390:	00001097          	auipc	ra,0x1
    80002394:	4c8080e7          	jalr	1224(ra) # 80003858 <initsleeplock>
    bcache.head.next->prev = b;
    80002398:	2b893783          	ld	a5,696(s2)
    8000239c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000239e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023a2:	45848493          	addi	s1,s1,1112
    800023a6:	fd349de3          	bne	s1,s3,80002380 <binit+0x54>
  }
}
    800023aa:	70a2                	ld	ra,40(sp)
    800023ac:	7402                	ld	s0,32(sp)
    800023ae:	64e2                	ld	s1,24(sp)
    800023b0:	6942                	ld	s2,16(sp)
    800023b2:	69a2                	ld	s3,8(sp)
    800023b4:	6a02                	ld	s4,0(sp)
    800023b6:	6145                	addi	sp,sp,48
    800023b8:	8082                	ret

00000000800023ba <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023ba:	7179                	addi	sp,sp,-48
    800023bc:	f406                	sd	ra,40(sp)
    800023be:	f022                	sd	s0,32(sp)
    800023c0:	ec26                	sd	s1,24(sp)
    800023c2:	e84a                	sd	s2,16(sp)
    800023c4:	e44e                	sd	s3,8(sp)
    800023c6:	1800                	addi	s0,sp,48
    800023c8:	892a                	mv	s2,a0
    800023ca:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800023cc:	0000d517          	auipc	a0,0xd
    800023d0:	9ac50513          	addi	a0,a0,-1620 # 8000ed78 <bcache>
    800023d4:	00004097          	auipc	ra,0x4
    800023d8:	e54080e7          	jalr	-428(ra) # 80006228 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023dc:	00015497          	auipc	s1,0x15
    800023e0:	c544b483          	ld	s1,-940(s1) # 80017030 <bcache+0x82b8>
    800023e4:	00015797          	auipc	a5,0x15
    800023e8:	bfc78793          	addi	a5,a5,-1028 # 80016fe0 <bcache+0x8268>
    800023ec:	02f48f63          	beq	s1,a5,8000242a <bread+0x70>
    800023f0:	873e                	mv	a4,a5
    800023f2:	a021                	j	800023fa <bread+0x40>
    800023f4:	68a4                	ld	s1,80(s1)
    800023f6:	02e48a63          	beq	s1,a4,8000242a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800023fa:	449c                	lw	a5,8(s1)
    800023fc:	ff279ce3          	bne	a5,s2,800023f4 <bread+0x3a>
    80002400:	44dc                	lw	a5,12(s1)
    80002402:	ff3799e3          	bne	a5,s3,800023f4 <bread+0x3a>
      b->refcnt++;
    80002406:	40bc                	lw	a5,64(s1)
    80002408:	2785                	addiw	a5,a5,1
    8000240a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000240c:	0000d517          	auipc	a0,0xd
    80002410:	96c50513          	addi	a0,a0,-1684 # 8000ed78 <bcache>
    80002414:	00004097          	auipc	ra,0x4
    80002418:	ec8080e7          	jalr	-312(ra) # 800062dc <release>
      acquiresleep(&b->lock);
    8000241c:	01048513          	addi	a0,s1,16
    80002420:	00001097          	auipc	ra,0x1
    80002424:	472080e7          	jalr	1138(ra) # 80003892 <acquiresleep>
      return b;
    80002428:	a8b9                	j	80002486 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000242a:	00015497          	auipc	s1,0x15
    8000242e:	bfe4b483          	ld	s1,-1026(s1) # 80017028 <bcache+0x82b0>
    80002432:	00015797          	auipc	a5,0x15
    80002436:	bae78793          	addi	a5,a5,-1106 # 80016fe0 <bcache+0x8268>
    8000243a:	00f48863          	beq	s1,a5,8000244a <bread+0x90>
    8000243e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002440:	40bc                	lw	a5,64(s1)
    80002442:	cf81                	beqz	a5,8000245a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002444:	64a4                	ld	s1,72(s1)
    80002446:	fee49de3          	bne	s1,a4,80002440 <bread+0x86>
  panic("bget: no buffers");
    8000244a:	00006517          	auipc	a0,0x6
    8000244e:	05650513          	addi	a0,a0,86 # 800084a0 <syscalls+0xd0>
    80002452:	00004097          	auipc	ra,0x4
    80002456:	8c8080e7          	jalr	-1848(ra) # 80005d1a <panic>
      b->dev = dev;
    8000245a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000245e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002462:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002466:	4785                	li	a5,1
    80002468:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000246a:	0000d517          	auipc	a0,0xd
    8000246e:	90e50513          	addi	a0,a0,-1778 # 8000ed78 <bcache>
    80002472:	00004097          	auipc	ra,0x4
    80002476:	e6a080e7          	jalr	-406(ra) # 800062dc <release>
      acquiresleep(&b->lock);
    8000247a:	01048513          	addi	a0,s1,16
    8000247e:	00001097          	auipc	ra,0x1
    80002482:	414080e7          	jalr	1044(ra) # 80003892 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002486:	409c                	lw	a5,0(s1)
    80002488:	cb89                	beqz	a5,8000249a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000248a:	8526                	mv	a0,s1
    8000248c:	70a2                	ld	ra,40(sp)
    8000248e:	7402                	ld	s0,32(sp)
    80002490:	64e2                	ld	s1,24(sp)
    80002492:	6942                	ld	s2,16(sp)
    80002494:	69a2                	ld	s3,8(sp)
    80002496:	6145                	addi	sp,sp,48
    80002498:	8082                	ret
    virtio_disk_rw(b, 0);
    8000249a:	4581                	li	a1,0
    8000249c:	8526                	mv	a0,s1
    8000249e:	00003097          	auipc	ra,0x3
    800024a2:	fe4080e7          	jalr	-28(ra) # 80005482 <virtio_disk_rw>
    b->valid = 1;
    800024a6:	4785                	li	a5,1
    800024a8:	c09c                	sw	a5,0(s1)
  return b;
    800024aa:	b7c5                	j	8000248a <bread+0xd0>

00000000800024ac <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024ac:	1101                	addi	sp,sp,-32
    800024ae:	ec06                	sd	ra,24(sp)
    800024b0:	e822                	sd	s0,16(sp)
    800024b2:	e426                	sd	s1,8(sp)
    800024b4:	1000                	addi	s0,sp,32
    800024b6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024b8:	0541                	addi	a0,a0,16
    800024ba:	00001097          	auipc	ra,0x1
    800024be:	472080e7          	jalr	1138(ra) # 8000392c <holdingsleep>
    800024c2:	cd01                	beqz	a0,800024da <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024c4:	4585                	li	a1,1
    800024c6:	8526                	mv	a0,s1
    800024c8:	00003097          	auipc	ra,0x3
    800024cc:	fba080e7          	jalr	-70(ra) # 80005482 <virtio_disk_rw>
}
    800024d0:	60e2                	ld	ra,24(sp)
    800024d2:	6442                	ld	s0,16(sp)
    800024d4:	64a2                	ld	s1,8(sp)
    800024d6:	6105                	addi	sp,sp,32
    800024d8:	8082                	ret
    panic("bwrite");
    800024da:	00006517          	auipc	a0,0x6
    800024de:	fde50513          	addi	a0,a0,-34 # 800084b8 <syscalls+0xe8>
    800024e2:	00004097          	auipc	ra,0x4
    800024e6:	838080e7          	jalr	-1992(ra) # 80005d1a <panic>

00000000800024ea <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024ea:	1101                	addi	sp,sp,-32
    800024ec:	ec06                	sd	ra,24(sp)
    800024ee:	e822                	sd	s0,16(sp)
    800024f0:	e426                	sd	s1,8(sp)
    800024f2:	e04a                	sd	s2,0(sp)
    800024f4:	1000                	addi	s0,sp,32
    800024f6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024f8:	01050913          	addi	s2,a0,16
    800024fc:	854a                	mv	a0,s2
    800024fe:	00001097          	auipc	ra,0x1
    80002502:	42e080e7          	jalr	1070(ra) # 8000392c <holdingsleep>
    80002506:	c92d                	beqz	a0,80002578 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002508:	854a                	mv	a0,s2
    8000250a:	00001097          	auipc	ra,0x1
    8000250e:	3de080e7          	jalr	990(ra) # 800038e8 <releasesleep>

  acquire(&bcache.lock);
    80002512:	0000d517          	auipc	a0,0xd
    80002516:	86650513          	addi	a0,a0,-1946 # 8000ed78 <bcache>
    8000251a:	00004097          	auipc	ra,0x4
    8000251e:	d0e080e7          	jalr	-754(ra) # 80006228 <acquire>
  b->refcnt--;
    80002522:	40bc                	lw	a5,64(s1)
    80002524:	37fd                	addiw	a5,a5,-1
    80002526:	0007871b          	sext.w	a4,a5
    8000252a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000252c:	eb05                	bnez	a4,8000255c <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000252e:	68bc                	ld	a5,80(s1)
    80002530:	64b8                	ld	a4,72(s1)
    80002532:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002534:	64bc                	ld	a5,72(s1)
    80002536:	68b8                	ld	a4,80(s1)
    80002538:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000253a:	00015797          	auipc	a5,0x15
    8000253e:	83e78793          	addi	a5,a5,-1986 # 80016d78 <bcache+0x8000>
    80002542:	2b87b703          	ld	a4,696(a5)
    80002546:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002548:	00015717          	auipc	a4,0x15
    8000254c:	a9870713          	addi	a4,a4,-1384 # 80016fe0 <bcache+0x8268>
    80002550:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002552:	2b87b703          	ld	a4,696(a5)
    80002556:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002558:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000255c:	0000d517          	auipc	a0,0xd
    80002560:	81c50513          	addi	a0,a0,-2020 # 8000ed78 <bcache>
    80002564:	00004097          	auipc	ra,0x4
    80002568:	d78080e7          	jalr	-648(ra) # 800062dc <release>
}
    8000256c:	60e2                	ld	ra,24(sp)
    8000256e:	6442                	ld	s0,16(sp)
    80002570:	64a2                	ld	s1,8(sp)
    80002572:	6902                	ld	s2,0(sp)
    80002574:	6105                	addi	sp,sp,32
    80002576:	8082                	ret
    panic("brelse");
    80002578:	00006517          	auipc	a0,0x6
    8000257c:	f4850513          	addi	a0,a0,-184 # 800084c0 <syscalls+0xf0>
    80002580:	00003097          	auipc	ra,0x3
    80002584:	79a080e7          	jalr	1946(ra) # 80005d1a <panic>

0000000080002588 <bpin>:

void
bpin(struct buf *b) {
    80002588:	1101                	addi	sp,sp,-32
    8000258a:	ec06                	sd	ra,24(sp)
    8000258c:	e822                	sd	s0,16(sp)
    8000258e:	e426                	sd	s1,8(sp)
    80002590:	1000                	addi	s0,sp,32
    80002592:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002594:	0000c517          	auipc	a0,0xc
    80002598:	7e450513          	addi	a0,a0,2020 # 8000ed78 <bcache>
    8000259c:	00004097          	auipc	ra,0x4
    800025a0:	c8c080e7          	jalr	-884(ra) # 80006228 <acquire>
  b->refcnt++;
    800025a4:	40bc                	lw	a5,64(s1)
    800025a6:	2785                	addiw	a5,a5,1
    800025a8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025aa:	0000c517          	auipc	a0,0xc
    800025ae:	7ce50513          	addi	a0,a0,1998 # 8000ed78 <bcache>
    800025b2:	00004097          	auipc	ra,0x4
    800025b6:	d2a080e7          	jalr	-726(ra) # 800062dc <release>
}
    800025ba:	60e2                	ld	ra,24(sp)
    800025bc:	6442                	ld	s0,16(sp)
    800025be:	64a2                	ld	s1,8(sp)
    800025c0:	6105                	addi	sp,sp,32
    800025c2:	8082                	ret

00000000800025c4 <bunpin>:

void
bunpin(struct buf *b) {
    800025c4:	1101                	addi	sp,sp,-32
    800025c6:	ec06                	sd	ra,24(sp)
    800025c8:	e822                	sd	s0,16(sp)
    800025ca:	e426                	sd	s1,8(sp)
    800025cc:	1000                	addi	s0,sp,32
    800025ce:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025d0:	0000c517          	auipc	a0,0xc
    800025d4:	7a850513          	addi	a0,a0,1960 # 8000ed78 <bcache>
    800025d8:	00004097          	auipc	ra,0x4
    800025dc:	c50080e7          	jalr	-944(ra) # 80006228 <acquire>
  b->refcnt--;
    800025e0:	40bc                	lw	a5,64(s1)
    800025e2:	37fd                	addiw	a5,a5,-1
    800025e4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025e6:	0000c517          	auipc	a0,0xc
    800025ea:	79250513          	addi	a0,a0,1938 # 8000ed78 <bcache>
    800025ee:	00004097          	auipc	ra,0x4
    800025f2:	cee080e7          	jalr	-786(ra) # 800062dc <release>
}
    800025f6:	60e2                	ld	ra,24(sp)
    800025f8:	6442                	ld	s0,16(sp)
    800025fa:	64a2                	ld	s1,8(sp)
    800025fc:	6105                	addi	sp,sp,32
    800025fe:	8082                	ret

0000000080002600 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002600:	1101                	addi	sp,sp,-32
    80002602:	ec06                	sd	ra,24(sp)
    80002604:	e822                	sd	s0,16(sp)
    80002606:	e426                	sd	s1,8(sp)
    80002608:	e04a                	sd	s2,0(sp)
    8000260a:	1000                	addi	s0,sp,32
    8000260c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000260e:	00d5d59b          	srliw	a1,a1,0xd
    80002612:	00015797          	auipc	a5,0x15
    80002616:	e427a783          	lw	a5,-446(a5) # 80017454 <sb+0x1c>
    8000261a:	9dbd                	addw	a1,a1,a5
    8000261c:	00000097          	auipc	ra,0x0
    80002620:	d9e080e7          	jalr	-610(ra) # 800023ba <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002624:	0074f713          	andi	a4,s1,7
    80002628:	4785                	li	a5,1
    8000262a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000262e:	14ce                	slli	s1,s1,0x33
    80002630:	90d9                	srli	s1,s1,0x36
    80002632:	00950733          	add	a4,a0,s1
    80002636:	05874703          	lbu	a4,88(a4)
    8000263a:	00e7f6b3          	and	a3,a5,a4
    8000263e:	c69d                	beqz	a3,8000266c <bfree+0x6c>
    80002640:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002642:	94aa                	add	s1,s1,a0
    80002644:	fff7c793          	not	a5,a5
    80002648:	8f7d                	and	a4,a4,a5
    8000264a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000264e:	00001097          	auipc	ra,0x1
    80002652:	126080e7          	jalr	294(ra) # 80003774 <log_write>
  brelse(bp);
    80002656:	854a                	mv	a0,s2
    80002658:	00000097          	auipc	ra,0x0
    8000265c:	e92080e7          	jalr	-366(ra) # 800024ea <brelse>
}
    80002660:	60e2                	ld	ra,24(sp)
    80002662:	6442                	ld	s0,16(sp)
    80002664:	64a2                	ld	s1,8(sp)
    80002666:	6902                	ld	s2,0(sp)
    80002668:	6105                	addi	sp,sp,32
    8000266a:	8082                	ret
    panic("freeing free block");
    8000266c:	00006517          	auipc	a0,0x6
    80002670:	e5c50513          	addi	a0,a0,-420 # 800084c8 <syscalls+0xf8>
    80002674:	00003097          	auipc	ra,0x3
    80002678:	6a6080e7          	jalr	1702(ra) # 80005d1a <panic>

000000008000267c <balloc>:
{
    8000267c:	711d                	addi	sp,sp,-96
    8000267e:	ec86                	sd	ra,88(sp)
    80002680:	e8a2                	sd	s0,80(sp)
    80002682:	e4a6                	sd	s1,72(sp)
    80002684:	e0ca                	sd	s2,64(sp)
    80002686:	fc4e                	sd	s3,56(sp)
    80002688:	f852                	sd	s4,48(sp)
    8000268a:	f456                	sd	s5,40(sp)
    8000268c:	f05a                	sd	s6,32(sp)
    8000268e:	ec5e                	sd	s7,24(sp)
    80002690:	e862                	sd	s8,16(sp)
    80002692:	e466                	sd	s9,8(sp)
    80002694:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002696:	00015797          	auipc	a5,0x15
    8000269a:	da67a783          	lw	a5,-602(a5) # 8001743c <sb+0x4>
    8000269e:	cff5                	beqz	a5,8000279a <balloc+0x11e>
    800026a0:	8baa                	mv	s7,a0
    800026a2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026a4:	00015b17          	auipc	s6,0x15
    800026a8:	d94b0b13          	addi	s6,s6,-620 # 80017438 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026ac:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026ae:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026b0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026b2:	6c89                	lui	s9,0x2
    800026b4:	a061                	j	8000273c <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    800026b6:	97ca                	add	a5,a5,s2
    800026b8:	8e55                	or	a2,a2,a3
    800026ba:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800026be:	854a                	mv	a0,s2
    800026c0:	00001097          	auipc	ra,0x1
    800026c4:	0b4080e7          	jalr	180(ra) # 80003774 <log_write>
        brelse(bp);
    800026c8:	854a                	mv	a0,s2
    800026ca:	00000097          	auipc	ra,0x0
    800026ce:	e20080e7          	jalr	-480(ra) # 800024ea <brelse>
  bp = bread(dev, bno);
    800026d2:	85a6                	mv	a1,s1
    800026d4:	855e                	mv	a0,s7
    800026d6:	00000097          	auipc	ra,0x0
    800026da:	ce4080e7          	jalr	-796(ra) # 800023ba <bread>
    800026de:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800026e0:	40000613          	li	a2,1024
    800026e4:	4581                	li	a1,0
    800026e6:	05850513          	addi	a0,a0,88
    800026ea:	ffffe097          	auipc	ra,0xffffe
    800026ee:	a90080e7          	jalr	-1392(ra) # 8000017a <memset>
  log_write(bp);
    800026f2:	854a                	mv	a0,s2
    800026f4:	00001097          	auipc	ra,0x1
    800026f8:	080080e7          	jalr	128(ra) # 80003774 <log_write>
  brelse(bp);
    800026fc:	854a                	mv	a0,s2
    800026fe:	00000097          	auipc	ra,0x0
    80002702:	dec080e7          	jalr	-532(ra) # 800024ea <brelse>
}
    80002706:	8526                	mv	a0,s1
    80002708:	60e6                	ld	ra,88(sp)
    8000270a:	6446                	ld	s0,80(sp)
    8000270c:	64a6                	ld	s1,72(sp)
    8000270e:	6906                	ld	s2,64(sp)
    80002710:	79e2                	ld	s3,56(sp)
    80002712:	7a42                	ld	s4,48(sp)
    80002714:	7aa2                	ld	s5,40(sp)
    80002716:	7b02                	ld	s6,32(sp)
    80002718:	6be2                	ld	s7,24(sp)
    8000271a:	6c42                	ld	s8,16(sp)
    8000271c:	6ca2                	ld	s9,8(sp)
    8000271e:	6125                	addi	sp,sp,96
    80002720:	8082                	ret
    brelse(bp);
    80002722:	854a                	mv	a0,s2
    80002724:	00000097          	auipc	ra,0x0
    80002728:	dc6080e7          	jalr	-570(ra) # 800024ea <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000272c:	015c87bb          	addw	a5,s9,s5
    80002730:	00078a9b          	sext.w	s5,a5
    80002734:	004b2703          	lw	a4,4(s6)
    80002738:	06eaf163          	bgeu	s5,a4,8000279a <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    8000273c:	41fad79b          	sraiw	a5,s5,0x1f
    80002740:	0137d79b          	srliw	a5,a5,0x13
    80002744:	015787bb          	addw	a5,a5,s5
    80002748:	40d7d79b          	sraiw	a5,a5,0xd
    8000274c:	01cb2583          	lw	a1,28(s6)
    80002750:	9dbd                	addw	a1,a1,a5
    80002752:	855e                	mv	a0,s7
    80002754:	00000097          	auipc	ra,0x0
    80002758:	c66080e7          	jalr	-922(ra) # 800023ba <bread>
    8000275c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000275e:	004b2503          	lw	a0,4(s6)
    80002762:	000a849b          	sext.w	s1,s5
    80002766:	8762                	mv	a4,s8
    80002768:	faa4fde3          	bgeu	s1,a0,80002722 <balloc+0xa6>
      m = 1 << (bi % 8);
    8000276c:	00777693          	andi	a3,a4,7
    80002770:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002774:	41f7579b          	sraiw	a5,a4,0x1f
    80002778:	01d7d79b          	srliw	a5,a5,0x1d
    8000277c:	9fb9                	addw	a5,a5,a4
    8000277e:	4037d79b          	sraiw	a5,a5,0x3
    80002782:	00f90633          	add	a2,s2,a5
    80002786:	05864603          	lbu	a2,88(a2)
    8000278a:	00c6f5b3          	and	a1,a3,a2
    8000278e:	d585                	beqz	a1,800026b6 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002790:	2705                	addiw	a4,a4,1
    80002792:	2485                	addiw	s1,s1,1
    80002794:	fd471ae3          	bne	a4,s4,80002768 <balloc+0xec>
    80002798:	b769                	j	80002722 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    8000279a:	00006517          	auipc	a0,0x6
    8000279e:	d4650513          	addi	a0,a0,-698 # 800084e0 <syscalls+0x110>
    800027a2:	00003097          	auipc	ra,0x3
    800027a6:	5ca080e7          	jalr	1482(ra) # 80005d6c <printf>
  return 0;
    800027aa:	4481                	li	s1,0
    800027ac:	bfa9                	j	80002706 <balloc+0x8a>

00000000800027ae <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800027ae:	7179                	addi	sp,sp,-48
    800027b0:	f406                	sd	ra,40(sp)
    800027b2:	f022                	sd	s0,32(sp)
    800027b4:	ec26                	sd	s1,24(sp)
    800027b6:	e84a                	sd	s2,16(sp)
    800027b8:	e44e                	sd	s3,8(sp)
    800027ba:	e052                	sd	s4,0(sp)
    800027bc:	1800                	addi	s0,sp,48
    800027be:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027c0:	47ad                	li	a5,11
    800027c2:	02b7e863          	bltu	a5,a1,800027f2 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    800027c6:	02059793          	slli	a5,a1,0x20
    800027ca:	01e7d593          	srli	a1,a5,0x1e
    800027ce:	00b504b3          	add	s1,a0,a1
    800027d2:	0504a903          	lw	s2,80(s1)
    800027d6:	06091e63          	bnez	s2,80002852 <bmap+0xa4>
      addr = balloc(ip->dev);
    800027da:	4108                	lw	a0,0(a0)
    800027dc:	00000097          	auipc	ra,0x0
    800027e0:	ea0080e7          	jalr	-352(ra) # 8000267c <balloc>
    800027e4:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800027e8:	06090563          	beqz	s2,80002852 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    800027ec:	0524a823          	sw	s2,80(s1)
    800027f0:	a08d                	j	80002852 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800027f2:	ff45849b          	addiw	s1,a1,-12
    800027f6:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027fa:	0ff00793          	li	a5,255
    800027fe:	08e7e563          	bltu	a5,a4,80002888 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002802:	08052903          	lw	s2,128(a0)
    80002806:	00091d63          	bnez	s2,80002820 <bmap+0x72>
      addr = balloc(ip->dev);
    8000280a:	4108                	lw	a0,0(a0)
    8000280c:	00000097          	auipc	ra,0x0
    80002810:	e70080e7          	jalr	-400(ra) # 8000267c <balloc>
    80002814:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002818:	02090d63          	beqz	s2,80002852 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000281c:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002820:	85ca                	mv	a1,s2
    80002822:	0009a503          	lw	a0,0(s3)
    80002826:	00000097          	auipc	ra,0x0
    8000282a:	b94080e7          	jalr	-1132(ra) # 800023ba <bread>
    8000282e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002830:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002834:	02049713          	slli	a4,s1,0x20
    80002838:	01e75593          	srli	a1,a4,0x1e
    8000283c:	00b784b3          	add	s1,a5,a1
    80002840:	0004a903          	lw	s2,0(s1)
    80002844:	02090063          	beqz	s2,80002864 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002848:	8552                	mv	a0,s4
    8000284a:	00000097          	auipc	ra,0x0
    8000284e:	ca0080e7          	jalr	-864(ra) # 800024ea <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002852:	854a                	mv	a0,s2
    80002854:	70a2                	ld	ra,40(sp)
    80002856:	7402                	ld	s0,32(sp)
    80002858:	64e2                	ld	s1,24(sp)
    8000285a:	6942                	ld	s2,16(sp)
    8000285c:	69a2                	ld	s3,8(sp)
    8000285e:	6a02                	ld	s4,0(sp)
    80002860:	6145                	addi	sp,sp,48
    80002862:	8082                	ret
      addr = balloc(ip->dev);
    80002864:	0009a503          	lw	a0,0(s3)
    80002868:	00000097          	auipc	ra,0x0
    8000286c:	e14080e7          	jalr	-492(ra) # 8000267c <balloc>
    80002870:	0005091b          	sext.w	s2,a0
      if(addr){
    80002874:	fc090ae3          	beqz	s2,80002848 <bmap+0x9a>
        a[bn] = addr;
    80002878:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000287c:	8552                	mv	a0,s4
    8000287e:	00001097          	auipc	ra,0x1
    80002882:	ef6080e7          	jalr	-266(ra) # 80003774 <log_write>
    80002886:	b7c9                	j	80002848 <bmap+0x9a>
  panic("bmap: out of range");
    80002888:	00006517          	auipc	a0,0x6
    8000288c:	c7050513          	addi	a0,a0,-912 # 800084f8 <syscalls+0x128>
    80002890:	00003097          	auipc	ra,0x3
    80002894:	48a080e7          	jalr	1162(ra) # 80005d1a <panic>

0000000080002898 <iget>:
{
    80002898:	7179                	addi	sp,sp,-48
    8000289a:	f406                	sd	ra,40(sp)
    8000289c:	f022                	sd	s0,32(sp)
    8000289e:	ec26                	sd	s1,24(sp)
    800028a0:	e84a                	sd	s2,16(sp)
    800028a2:	e44e                	sd	s3,8(sp)
    800028a4:	e052                	sd	s4,0(sp)
    800028a6:	1800                	addi	s0,sp,48
    800028a8:	89aa                	mv	s3,a0
    800028aa:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028ac:	00015517          	auipc	a0,0x15
    800028b0:	bac50513          	addi	a0,a0,-1108 # 80017458 <itable>
    800028b4:	00004097          	auipc	ra,0x4
    800028b8:	974080e7          	jalr	-1676(ra) # 80006228 <acquire>
  empty = 0;
    800028bc:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028be:	00015497          	auipc	s1,0x15
    800028c2:	bb248493          	addi	s1,s1,-1102 # 80017470 <itable+0x18>
    800028c6:	00016697          	auipc	a3,0x16
    800028ca:	63a68693          	addi	a3,a3,1594 # 80018f00 <log>
    800028ce:	a039                	j	800028dc <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028d0:	02090b63          	beqz	s2,80002906 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028d4:	08848493          	addi	s1,s1,136
    800028d8:	02d48a63          	beq	s1,a3,8000290c <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028dc:	449c                	lw	a5,8(s1)
    800028de:	fef059e3          	blez	a5,800028d0 <iget+0x38>
    800028e2:	4098                	lw	a4,0(s1)
    800028e4:	ff3716e3          	bne	a4,s3,800028d0 <iget+0x38>
    800028e8:	40d8                	lw	a4,4(s1)
    800028ea:	ff4713e3          	bne	a4,s4,800028d0 <iget+0x38>
      ip->ref++;
    800028ee:	2785                	addiw	a5,a5,1
    800028f0:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028f2:	00015517          	auipc	a0,0x15
    800028f6:	b6650513          	addi	a0,a0,-1178 # 80017458 <itable>
    800028fa:	00004097          	auipc	ra,0x4
    800028fe:	9e2080e7          	jalr	-1566(ra) # 800062dc <release>
      return ip;
    80002902:	8926                	mv	s2,s1
    80002904:	a03d                	j	80002932 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002906:	f7f9                	bnez	a5,800028d4 <iget+0x3c>
    80002908:	8926                	mv	s2,s1
    8000290a:	b7e9                	j	800028d4 <iget+0x3c>
  if(empty == 0)
    8000290c:	02090c63          	beqz	s2,80002944 <iget+0xac>
  ip->dev = dev;
    80002910:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002914:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002918:	4785                	li	a5,1
    8000291a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000291e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002922:	00015517          	auipc	a0,0x15
    80002926:	b3650513          	addi	a0,a0,-1226 # 80017458 <itable>
    8000292a:	00004097          	auipc	ra,0x4
    8000292e:	9b2080e7          	jalr	-1614(ra) # 800062dc <release>
}
    80002932:	854a                	mv	a0,s2
    80002934:	70a2                	ld	ra,40(sp)
    80002936:	7402                	ld	s0,32(sp)
    80002938:	64e2                	ld	s1,24(sp)
    8000293a:	6942                	ld	s2,16(sp)
    8000293c:	69a2                	ld	s3,8(sp)
    8000293e:	6a02                	ld	s4,0(sp)
    80002940:	6145                	addi	sp,sp,48
    80002942:	8082                	ret
    panic("iget: no inodes");
    80002944:	00006517          	auipc	a0,0x6
    80002948:	bcc50513          	addi	a0,a0,-1076 # 80008510 <syscalls+0x140>
    8000294c:	00003097          	auipc	ra,0x3
    80002950:	3ce080e7          	jalr	974(ra) # 80005d1a <panic>

0000000080002954 <fsinit>:
fsinit(int dev) {
    80002954:	7179                	addi	sp,sp,-48
    80002956:	f406                	sd	ra,40(sp)
    80002958:	f022                	sd	s0,32(sp)
    8000295a:	ec26                	sd	s1,24(sp)
    8000295c:	e84a                	sd	s2,16(sp)
    8000295e:	e44e                	sd	s3,8(sp)
    80002960:	1800                	addi	s0,sp,48
    80002962:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002964:	4585                	li	a1,1
    80002966:	00000097          	auipc	ra,0x0
    8000296a:	a54080e7          	jalr	-1452(ra) # 800023ba <bread>
    8000296e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002970:	00015997          	auipc	s3,0x15
    80002974:	ac898993          	addi	s3,s3,-1336 # 80017438 <sb>
    80002978:	02000613          	li	a2,32
    8000297c:	05850593          	addi	a1,a0,88
    80002980:	854e                	mv	a0,s3
    80002982:	ffffe097          	auipc	ra,0xffffe
    80002986:	854080e7          	jalr	-1964(ra) # 800001d6 <memmove>
  brelse(bp);
    8000298a:	8526                	mv	a0,s1
    8000298c:	00000097          	auipc	ra,0x0
    80002990:	b5e080e7          	jalr	-1186(ra) # 800024ea <brelse>
  if(sb.magic != FSMAGIC)
    80002994:	0009a703          	lw	a4,0(s3)
    80002998:	102037b7          	lui	a5,0x10203
    8000299c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029a0:	02f71263          	bne	a4,a5,800029c4 <fsinit+0x70>
  initlog(dev, &sb);
    800029a4:	00015597          	auipc	a1,0x15
    800029a8:	a9458593          	addi	a1,a1,-1388 # 80017438 <sb>
    800029ac:	854a                	mv	a0,s2
    800029ae:	00001097          	auipc	ra,0x1
    800029b2:	b4a080e7          	jalr	-1206(ra) # 800034f8 <initlog>
}
    800029b6:	70a2                	ld	ra,40(sp)
    800029b8:	7402                	ld	s0,32(sp)
    800029ba:	64e2                	ld	s1,24(sp)
    800029bc:	6942                	ld	s2,16(sp)
    800029be:	69a2                	ld	s3,8(sp)
    800029c0:	6145                	addi	sp,sp,48
    800029c2:	8082                	ret
    panic("invalid file system");
    800029c4:	00006517          	auipc	a0,0x6
    800029c8:	b5c50513          	addi	a0,a0,-1188 # 80008520 <syscalls+0x150>
    800029cc:	00003097          	auipc	ra,0x3
    800029d0:	34e080e7          	jalr	846(ra) # 80005d1a <panic>

00000000800029d4 <iinit>:
{
    800029d4:	7179                	addi	sp,sp,-48
    800029d6:	f406                	sd	ra,40(sp)
    800029d8:	f022                	sd	s0,32(sp)
    800029da:	ec26                	sd	s1,24(sp)
    800029dc:	e84a                	sd	s2,16(sp)
    800029de:	e44e                	sd	s3,8(sp)
    800029e0:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029e2:	00006597          	auipc	a1,0x6
    800029e6:	b5658593          	addi	a1,a1,-1194 # 80008538 <syscalls+0x168>
    800029ea:	00015517          	auipc	a0,0x15
    800029ee:	a6e50513          	addi	a0,a0,-1426 # 80017458 <itable>
    800029f2:	00003097          	auipc	ra,0x3
    800029f6:	7a6080e7          	jalr	1958(ra) # 80006198 <initlock>
  for(i = 0; i < NINODE; i++) {
    800029fa:	00015497          	auipc	s1,0x15
    800029fe:	a8648493          	addi	s1,s1,-1402 # 80017480 <itable+0x28>
    80002a02:	00016997          	auipc	s3,0x16
    80002a06:	50e98993          	addi	s3,s3,1294 # 80018f10 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a0a:	00006917          	auipc	s2,0x6
    80002a0e:	b3690913          	addi	s2,s2,-1226 # 80008540 <syscalls+0x170>
    80002a12:	85ca                	mv	a1,s2
    80002a14:	8526                	mv	a0,s1
    80002a16:	00001097          	auipc	ra,0x1
    80002a1a:	e42080e7          	jalr	-446(ra) # 80003858 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a1e:	08848493          	addi	s1,s1,136
    80002a22:	ff3498e3          	bne	s1,s3,80002a12 <iinit+0x3e>
}
    80002a26:	70a2                	ld	ra,40(sp)
    80002a28:	7402                	ld	s0,32(sp)
    80002a2a:	64e2                	ld	s1,24(sp)
    80002a2c:	6942                	ld	s2,16(sp)
    80002a2e:	69a2                	ld	s3,8(sp)
    80002a30:	6145                	addi	sp,sp,48
    80002a32:	8082                	ret

0000000080002a34 <ialloc>:
{
    80002a34:	715d                	addi	sp,sp,-80
    80002a36:	e486                	sd	ra,72(sp)
    80002a38:	e0a2                	sd	s0,64(sp)
    80002a3a:	fc26                	sd	s1,56(sp)
    80002a3c:	f84a                	sd	s2,48(sp)
    80002a3e:	f44e                	sd	s3,40(sp)
    80002a40:	f052                	sd	s4,32(sp)
    80002a42:	ec56                	sd	s5,24(sp)
    80002a44:	e85a                	sd	s6,16(sp)
    80002a46:	e45e                	sd	s7,8(sp)
    80002a48:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a4a:	00015717          	auipc	a4,0x15
    80002a4e:	9fa72703          	lw	a4,-1542(a4) # 80017444 <sb+0xc>
    80002a52:	4785                	li	a5,1
    80002a54:	04e7fa63          	bgeu	a5,a4,80002aa8 <ialloc+0x74>
    80002a58:	8aaa                	mv	s5,a0
    80002a5a:	8bae                	mv	s7,a1
    80002a5c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a5e:	00015a17          	auipc	s4,0x15
    80002a62:	9daa0a13          	addi	s4,s4,-1574 # 80017438 <sb>
    80002a66:	00048b1b          	sext.w	s6,s1
    80002a6a:	0044d593          	srli	a1,s1,0x4
    80002a6e:	018a2783          	lw	a5,24(s4)
    80002a72:	9dbd                	addw	a1,a1,a5
    80002a74:	8556                	mv	a0,s5
    80002a76:	00000097          	auipc	ra,0x0
    80002a7a:	944080e7          	jalr	-1724(ra) # 800023ba <bread>
    80002a7e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a80:	05850993          	addi	s3,a0,88
    80002a84:	00f4f793          	andi	a5,s1,15
    80002a88:	079a                	slli	a5,a5,0x6
    80002a8a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a8c:	00099783          	lh	a5,0(s3)
    80002a90:	c3a1                	beqz	a5,80002ad0 <ialloc+0x9c>
    brelse(bp);
    80002a92:	00000097          	auipc	ra,0x0
    80002a96:	a58080e7          	jalr	-1448(ra) # 800024ea <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a9a:	0485                	addi	s1,s1,1
    80002a9c:	00ca2703          	lw	a4,12(s4)
    80002aa0:	0004879b          	sext.w	a5,s1
    80002aa4:	fce7e1e3          	bltu	a5,a4,80002a66 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002aa8:	00006517          	auipc	a0,0x6
    80002aac:	aa050513          	addi	a0,a0,-1376 # 80008548 <syscalls+0x178>
    80002ab0:	00003097          	auipc	ra,0x3
    80002ab4:	2bc080e7          	jalr	700(ra) # 80005d6c <printf>
  return 0;
    80002ab8:	4501                	li	a0,0
}
    80002aba:	60a6                	ld	ra,72(sp)
    80002abc:	6406                	ld	s0,64(sp)
    80002abe:	74e2                	ld	s1,56(sp)
    80002ac0:	7942                	ld	s2,48(sp)
    80002ac2:	79a2                	ld	s3,40(sp)
    80002ac4:	7a02                	ld	s4,32(sp)
    80002ac6:	6ae2                	ld	s5,24(sp)
    80002ac8:	6b42                	ld	s6,16(sp)
    80002aca:	6ba2                	ld	s7,8(sp)
    80002acc:	6161                	addi	sp,sp,80
    80002ace:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002ad0:	04000613          	li	a2,64
    80002ad4:	4581                	li	a1,0
    80002ad6:	854e                	mv	a0,s3
    80002ad8:	ffffd097          	auipc	ra,0xffffd
    80002adc:	6a2080e7          	jalr	1698(ra) # 8000017a <memset>
      dip->type = type;
    80002ae0:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002ae4:	854a                	mv	a0,s2
    80002ae6:	00001097          	auipc	ra,0x1
    80002aea:	c8e080e7          	jalr	-882(ra) # 80003774 <log_write>
      brelse(bp);
    80002aee:	854a                	mv	a0,s2
    80002af0:	00000097          	auipc	ra,0x0
    80002af4:	9fa080e7          	jalr	-1542(ra) # 800024ea <brelse>
      return iget(dev, inum);
    80002af8:	85da                	mv	a1,s6
    80002afa:	8556                	mv	a0,s5
    80002afc:	00000097          	auipc	ra,0x0
    80002b00:	d9c080e7          	jalr	-612(ra) # 80002898 <iget>
    80002b04:	bf5d                	j	80002aba <ialloc+0x86>

0000000080002b06 <iupdate>:
{
    80002b06:	1101                	addi	sp,sp,-32
    80002b08:	ec06                	sd	ra,24(sp)
    80002b0a:	e822                	sd	s0,16(sp)
    80002b0c:	e426                	sd	s1,8(sp)
    80002b0e:	e04a                	sd	s2,0(sp)
    80002b10:	1000                	addi	s0,sp,32
    80002b12:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b14:	415c                	lw	a5,4(a0)
    80002b16:	0047d79b          	srliw	a5,a5,0x4
    80002b1a:	00015597          	auipc	a1,0x15
    80002b1e:	9365a583          	lw	a1,-1738(a1) # 80017450 <sb+0x18>
    80002b22:	9dbd                	addw	a1,a1,a5
    80002b24:	4108                	lw	a0,0(a0)
    80002b26:	00000097          	auipc	ra,0x0
    80002b2a:	894080e7          	jalr	-1900(ra) # 800023ba <bread>
    80002b2e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b30:	05850793          	addi	a5,a0,88
    80002b34:	40d8                	lw	a4,4(s1)
    80002b36:	8b3d                	andi	a4,a4,15
    80002b38:	071a                	slli	a4,a4,0x6
    80002b3a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b3c:	04449703          	lh	a4,68(s1)
    80002b40:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b44:	04649703          	lh	a4,70(s1)
    80002b48:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b4c:	04849703          	lh	a4,72(s1)
    80002b50:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b54:	04a49703          	lh	a4,74(s1)
    80002b58:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002b5c:	44f8                	lw	a4,76(s1)
    80002b5e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b60:	03400613          	li	a2,52
    80002b64:	05048593          	addi	a1,s1,80
    80002b68:	00c78513          	addi	a0,a5,12
    80002b6c:	ffffd097          	auipc	ra,0xffffd
    80002b70:	66a080e7          	jalr	1642(ra) # 800001d6 <memmove>
  log_write(bp);
    80002b74:	854a                	mv	a0,s2
    80002b76:	00001097          	auipc	ra,0x1
    80002b7a:	bfe080e7          	jalr	-1026(ra) # 80003774 <log_write>
  brelse(bp);
    80002b7e:	854a                	mv	a0,s2
    80002b80:	00000097          	auipc	ra,0x0
    80002b84:	96a080e7          	jalr	-1686(ra) # 800024ea <brelse>
}
    80002b88:	60e2                	ld	ra,24(sp)
    80002b8a:	6442                	ld	s0,16(sp)
    80002b8c:	64a2                	ld	s1,8(sp)
    80002b8e:	6902                	ld	s2,0(sp)
    80002b90:	6105                	addi	sp,sp,32
    80002b92:	8082                	ret

0000000080002b94 <idup>:
{
    80002b94:	1101                	addi	sp,sp,-32
    80002b96:	ec06                	sd	ra,24(sp)
    80002b98:	e822                	sd	s0,16(sp)
    80002b9a:	e426                	sd	s1,8(sp)
    80002b9c:	1000                	addi	s0,sp,32
    80002b9e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ba0:	00015517          	auipc	a0,0x15
    80002ba4:	8b850513          	addi	a0,a0,-1864 # 80017458 <itable>
    80002ba8:	00003097          	auipc	ra,0x3
    80002bac:	680080e7          	jalr	1664(ra) # 80006228 <acquire>
  ip->ref++;
    80002bb0:	449c                	lw	a5,8(s1)
    80002bb2:	2785                	addiw	a5,a5,1
    80002bb4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bb6:	00015517          	auipc	a0,0x15
    80002bba:	8a250513          	addi	a0,a0,-1886 # 80017458 <itable>
    80002bbe:	00003097          	auipc	ra,0x3
    80002bc2:	71e080e7          	jalr	1822(ra) # 800062dc <release>
}
    80002bc6:	8526                	mv	a0,s1
    80002bc8:	60e2                	ld	ra,24(sp)
    80002bca:	6442                	ld	s0,16(sp)
    80002bcc:	64a2                	ld	s1,8(sp)
    80002bce:	6105                	addi	sp,sp,32
    80002bd0:	8082                	ret

0000000080002bd2 <ilock>:
{
    80002bd2:	1101                	addi	sp,sp,-32
    80002bd4:	ec06                	sd	ra,24(sp)
    80002bd6:	e822                	sd	s0,16(sp)
    80002bd8:	e426                	sd	s1,8(sp)
    80002bda:	e04a                	sd	s2,0(sp)
    80002bdc:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bde:	c115                	beqz	a0,80002c02 <ilock+0x30>
    80002be0:	84aa                	mv	s1,a0
    80002be2:	451c                	lw	a5,8(a0)
    80002be4:	00f05f63          	blez	a5,80002c02 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002be8:	0541                	addi	a0,a0,16
    80002bea:	00001097          	auipc	ra,0x1
    80002bee:	ca8080e7          	jalr	-856(ra) # 80003892 <acquiresleep>
  if(ip->valid == 0){
    80002bf2:	40bc                	lw	a5,64(s1)
    80002bf4:	cf99                	beqz	a5,80002c12 <ilock+0x40>
}
    80002bf6:	60e2                	ld	ra,24(sp)
    80002bf8:	6442                	ld	s0,16(sp)
    80002bfa:	64a2                	ld	s1,8(sp)
    80002bfc:	6902                	ld	s2,0(sp)
    80002bfe:	6105                	addi	sp,sp,32
    80002c00:	8082                	ret
    panic("ilock");
    80002c02:	00006517          	auipc	a0,0x6
    80002c06:	95e50513          	addi	a0,a0,-1698 # 80008560 <syscalls+0x190>
    80002c0a:	00003097          	auipc	ra,0x3
    80002c0e:	110080e7          	jalr	272(ra) # 80005d1a <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c12:	40dc                	lw	a5,4(s1)
    80002c14:	0047d79b          	srliw	a5,a5,0x4
    80002c18:	00015597          	auipc	a1,0x15
    80002c1c:	8385a583          	lw	a1,-1992(a1) # 80017450 <sb+0x18>
    80002c20:	9dbd                	addw	a1,a1,a5
    80002c22:	4088                	lw	a0,0(s1)
    80002c24:	fffff097          	auipc	ra,0xfffff
    80002c28:	796080e7          	jalr	1942(ra) # 800023ba <bread>
    80002c2c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c2e:	05850593          	addi	a1,a0,88
    80002c32:	40dc                	lw	a5,4(s1)
    80002c34:	8bbd                	andi	a5,a5,15
    80002c36:	079a                	slli	a5,a5,0x6
    80002c38:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c3a:	00059783          	lh	a5,0(a1)
    80002c3e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c42:	00259783          	lh	a5,2(a1)
    80002c46:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c4a:	00459783          	lh	a5,4(a1)
    80002c4e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c52:	00659783          	lh	a5,6(a1)
    80002c56:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c5a:	459c                	lw	a5,8(a1)
    80002c5c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c5e:	03400613          	li	a2,52
    80002c62:	05b1                	addi	a1,a1,12
    80002c64:	05048513          	addi	a0,s1,80
    80002c68:	ffffd097          	auipc	ra,0xffffd
    80002c6c:	56e080e7          	jalr	1390(ra) # 800001d6 <memmove>
    brelse(bp);
    80002c70:	854a                	mv	a0,s2
    80002c72:	00000097          	auipc	ra,0x0
    80002c76:	878080e7          	jalr	-1928(ra) # 800024ea <brelse>
    ip->valid = 1;
    80002c7a:	4785                	li	a5,1
    80002c7c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c7e:	04449783          	lh	a5,68(s1)
    80002c82:	fbb5                	bnez	a5,80002bf6 <ilock+0x24>
      panic("ilock: no type");
    80002c84:	00006517          	auipc	a0,0x6
    80002c88:	8e450513          	addi	a0,a0,-1820 # 80008568 <syscalls+0x198>
    80002c8c:	00003097          	auipc	ra,0x3
    80002c90:	08e080e7          	jalr	142(ra) # 80005d1a <panic>

0000000080002c94 <iunlock>:
{
    80002c94:	1101                	addi	sp,sp,-32
    80002c96:	ec06                	sd	ra,24(sp)
    80002c98:	e822                	sd	s0,16(sp)
    80002c9a:	e426                	sd	s1,8(sp)
    80002c9c:	e04a                	sd	s2,0(sp)
    80002c9e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002ca0:	c905                	beqz	a0,80002cd0 <iunlock+0x3c>
    80002ca2:	84aa                	mv	s1,a0
    80002ca4:	01050913          	addi	s2,a0,16
    80002ca8:	854a                	mv	a0,s2
    80002caa:	00001097          	auipc	ra,0x1
    80002cae:	c82080e7          	jalr	-894(ra) # 8000392c <holdingsleep>
    80002cb2:	cd19                	beqz	a0,80002cd0 <iunlock+0x3c>
    80002cb4:	449c                	lw	a5,8(s1)
    80002cb6:	00f05d63          	blez	a5,80002cd0 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002cba:	854a                	mv	a0,s2
    80002cbc:	00001097          	auipc	ra,0x1
    80002cc0:	c2c080e7          	jalr	-980(ra) # 800038e8 <releasesleep>
}
    80002cc4:	60e2                	ld	ra,24(sp)
    80002cc6:	6442                	ld	s0,16(sp)
    80002cc8:	64a2                	ld	s1,8(sp)
    80002cca:	6902                	ld	s2,0(sp)
    80002ccc:	6105                	addi	sp,sp,32
    80002cce:	8082                	ret
    panic("iunlock");
    80002cd0:	00006517          	auipc	a0,0x6
    80002cd4:	8a850513          	addi	a0,a0,-1880 # 80008578 <syscalls+0x1a8>
    80002cd8:	00003097          	auipc	ra,0x3
    80002cdc:	042080e7          	jalr	66(ra) # 80005d1a <panic>

0000000080002ce0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002ce0:	7179                	addi	sp,sp,-48
    80002ce2:	f406                	sd	ra,40(sp)
    80002ce4:	f022                	sd	s0,32(sp)
    80002ce6:	ec26                	sd	s1,24(sp)
    80002ce8:	e84a                	sd	s2,16(sp)
    80002cea:	e44e                	sd	s3,8(sp)
    80002cec:	e052                	sd	s4,0(sp)
    80002cee:	1800                	addi	s0,sp,48
    80002cf0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002cf2:	05050493          	addi	s1,a0,80
    80002cf6:	08050913          	addi	s2,a0,128
    80002cfa:	a021                	j	80002d02 <itrunc+0x22>
    80002cfc:	0491                	addi	s1,s1,4
    80002cfe:	01248d63          	beq	s1,s2,80002d18 <itrunc+0x38>
    if(ip->addrs[i]){
    80002d02:	408c                	lw	a1,0(s1)
    80002d04:	dde5                	beqz	a1,80002cfc <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d06:	0009a503          	lw	a0,0(s3)
    80002d0a:	00000097          	auipc	ra,0x0
    80002d0e:	8f6080e7          	jalr	-1802(ra) # 80002600 <bfree>
      ip->addrs[i] = 0;
    80002d12:	0004a023          	sw	zero,0(s1)
    80002d16:	b7dd                	j	80002cfc <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d18:	0809a583          	lw	a1,128(s3)
    80002d1c:	e185                	bnez	a1,80002d3c <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d1e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d22:	854e                	mv	a0,s3
    80002d24:	00000097          	auipc	ra,0x0
    80002d28:	de2080e7          	jalr	-542(ra) # 80002b06 <iupdate>
}
    80002d2c:	70a2                	ld	ra,40(sp)
    80002d2e:	7402                	ld	s0,32(sp)
    80002d30:	64e2                	ld	s1,24(sp)
    80002d32:	6942                	ld	s2,16(sp)
    80002d34:	69a2                	ld	s3,8(sp)
    80002d36:	6a02                	ld	s4,0(sp)
    80002d38:	6145                	addi	sp,sp,48
    80002d3a:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d3c:	0009a503          	lw	a0,0(s3)
    80002d40:	fffff097          	auipc	ra,0xfffff
    80002d44:	67a080e7          	jalr	1658(ra) # 800023ba <bread>
    80002d48:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d4a:	05850493          	addi	s1,a0,88
    80002d4e:	45850913          	addi	s2,a0,1112
    80002d52:	a021                	j	80002d5a <itrunc+0x7a>
    80002d54:	0491                	addi	s1,s1,4
    80002d56:	01248b63          	beq	s1,s2,80002d6c <itrunc+0x8c>
      if(a[j])
    80002d5a:	408c                	lw	a1,0(s1)
    80002d5c:	dde5                	beqz	a1,80002d54 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002d5e:	0009a503          	lw	a0,0(s3)
    80002d62:	00000097          	auipc	ra,0x0
    80002d66:	89e080e7          	jalr	-1890(ra) # 80002600 <bfree>
    80002d6a:	b7ed                	j	80002d54 <itrunc+0x74>
    brelse(bp);
    80002d6c:	8552                	mv	a0,s4
    80002d6e:	fffff097          	auipc	ra,0xfffff
    80002d72:	77c080e7          	jalr	1916(ra) # 800024ea <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d76:	0809a583          	lw	a1,128(s3)
    80002d7a:	0009a503          	lw	a0,0(s3)
    80002d7e:	00000097          	auipc	ra,0x0
    80002d82:	882080e7          	jalr	-1918(ra) # 80002600 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d86:	0809a023          	sw	zero,128(s3)
    80002d8a:	bf51                	j	80002d1e <itrunc+0x3e>

0000000080002d8c <iput>:
{
    80002d8c:	1101                	addi	sp,sp,-32
    80002d8e:	ec06                	sd	ra,24(sp)
    80002d90:	e822                	sd	s0,16(sp)
    80002d92:	e426                	sd	s1,8(sp)
    80002d94:	e04a                	sd	s2,0(sp)
    80002d96:	1000                	addi	s0,sp,32
    80002d98:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d9a:	00014517          	auipc	a0,0x14
    80002d9e:	6be50513          	addi	a0,a0,1726 # 80017458 <itable>
    80002da2:	00003097          	auipc	ra,0x3
    80002da6:	486080e7          	jalr	1158(ra) # 80006228 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002daa:	4498                	lw	a4,8(s1)
    80002dac:	4785                	li	a5,1
    80002dae:	02f70363          	beq	a4,a5,80002dd4 <iput+0x48>
  ip->ref--;
    80002db2:	449c                	lw	a5,8(s1)
    80002db4:	37fd                	addiw	a5,a5,-1
    80002db6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002db8:	00014517          	auipc	a0,0x14
    80002dbc:	6a050513          	addi	a0,a0,1696 # 80017458 <itable>
    80002dc0:	00003097          	auipc	ra,0x3
    80002dc4:	51c080e7          	jalr	1308(ra) # 800062dc <release>
}
    80002dc8:	60e2                	ld	ra,24(sp)
    80002dca:	6442                	ld	s0,16(sp)
    80002dcc:	64a2                	ld	s1,8(sp)
    80002dce:	6902                	ld	s2,0(sp)
    80002dd0:	6105                	addi	sp,sp,32
    80002dd2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dd4:	40bc                	lw	a5,64(s1)
    80002dd6:	dff1                	beqz	a5,80002db2 <iput+0x26>
    80002dd8:	04a49783          	lh	a5,74(s1)
    80002ddc:	fbf9                	bnez	a5,80002db2 <iput+0x26>
    acquiresleep(&ip->lock);
    80002dde:	01048913          	addi	s2,s1,16
    80002de2:	854a                	mv	a0,s2
    80002de4:	00001097          	auipc	ra,0x1
    80002de8:	aae080e7          	jalr	-1362(ra) # 80003892 <acquiresleep>
    release(&itable.lock);
    80002dec:	00014517          	auipc	a0,0x14
    80002df0:	66c50513          	addi	a0,a0,1644 # 80017458 <itable>
    80002df4:	00003097          	auipc	ra,0x3
    80002df8:	4e8080e7          	jalr	1256(ra) # 800062dc <release>
    itrunc(ip);
    80002dfc:	8526                	mv	a0,s1
    80002dfe:	00000097          	auipc	ra,0x0
    80002e02:	ee2080e7          	jalr	-286(ra) # 80002ce0 <itrunc>
    ip->type = 0;
    80002e06:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e0a:	8526                	mv	a0,s1
    80002e0c:	00000097          	auipc	ra,0x0
    80002e10:	cfa080e7          	jalr	-774(ra) # 80002b06 <iupdate>
    ip->valid = 0;
    80002e14:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e18:	854a                	mv	a0,s2
    80002e1a:	00001097          	auipc	ra,0x1
    80002e1e:	ace080e7          	jalr	-1330(ra) # 800038e8 <releasesleep>
    acquire(&itable.lock);
    80002e22:	00014517          	auipc	a0,0x14
    80002e26:	63650513          	addi	a0,a0,1590 # 80017458 <itable>
    80002e2a:	00003097          	auipc	ra,0x3
    80002e2e:	3fe080e7          	jalr	1022(ra) # 80006228 <acquire>
    80002e32:	b741                	j	80002db2 <iput+0x26>

0000000080002e34 <iunlockput>:
{
    80002e34:	1101                	addi	sp,sp,-32
    80002e36:	ec06                	sd	ra,24(sp)
    80002e38:	e822                	sd	s0,16(sp)
    80002e3a:	e426                	sd	s1,8(sp)
    80002e3c:	1000                	addi	s0,sp,32
    80002e3e:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e40:	00000097          	auipc	ra,0x0
    80002e44:	e54080e7          	jalr	-428(ra) # 80002c94 <iunlock>
  iput(ip);
    80002e48:	8526                	mv	a0,s1
    80002e4a:	00000097          	auipc	ra,0x0
    80002e4e:	f42080e7          	jalr	-190(ra) # 80002d8c <iput>
}
    80002e52:	60e2                	ld	ra,24(sp)
    80002e54:	6442                	ld	s0,16(sp)
    80002e56:	64a2                	ld	s1,8(sp)
    80002e58:	6105                	addi	sp,sp,32
    80002e5a:	8082                	ret

0000000080002e5c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e5c:	1141                	addi	sp,sp,-16
    80002e5e:	e422                	sd	s0,8(sp)
    80002e60:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e62:	411c                	lw	a5,0(a0)
    80002e64:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e66:	415c                	lw	a5,4(a0)
    80002e68:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e6a:	04451783          	lh	a5,68(a0)
    80002e6e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e72:	04a51783          	lh	a5,74(a0)
    80002e76:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e7a:	04c56783          	lwu	a5,76(a0)
    80002e7e:	e99c                	sd	a5,16(a1)
}
    80002e80:	6422                	ld	s0,8(sp)
    80002e82:	0141                	addi	sp,sp,16
    80002e84:	8082                	ret

0000000080002e86 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e86:	457c                	lw	a5,76(a0)
    80002e88:	0ed7e963          	bltu	a5,a3,80002f7a <readi+0xf4>
{
    80002e8c:	7159                	addi	sp,sp,-112
    80002e8e:	f486                	sd	ra,104(sp)
    80002e90:	f0a2                	sd	s0,96(sp)
    80002e92:	eca6                	sd	s1,88(sp)
    80002e94:	e8ca                	sd	s2,80(sp)
    80002e96:	e4ce                	sd	s3,72(sp)
    80002e98:	e0d2                	sd	s4,64(sp)
    80002e9a:	fc56                	sd	s5,56(sp)
    80002e9c:	f85a                	sd	s6,48(sp)
    80002e9e:	f45e                	sd	s7,40(sp)
    80002ea0:	f062                	sd	s8,32(sp)
    80002ea2:	ec66                	sd	s9,24(sp)
    80002ea4:	e86a                	sd	s10,16(sp)
    80002ea6:	e46e                	sd	s11,8(sp)
    80002ea8:	1880                	addi	s0,sp,112
    80002eaa:	8b2a                	mv	s6,a0
    80002eac:	8bae                	mv	s7,a1
    80002eae:	8a32                	mv	s4,a2
    80002eb0:	84b6                	mv	s1,a3
    80002eb2:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002eb4:	9f35                	addw	a4,a4,a3
    return 0;
    80002eb6:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002eb8:	0ad76063          	bltu	a4,a3,80002f58 <readi+0xd2>
  if(off + n > ip->size)
    80002ebc:	00e7f463          	bgeu	a5,a4,80002ec4 <readi+0x3e>
    n = ip->size - off;
    80002ec0:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ec4:	0a0a8963          	beqz	s5,80002f76 <readi+0xf0>
    80002ec8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002eca:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ece:	5c7d                	li	s8,-1
    80002ed0:	a82d                	j	80002f0a <readi+0x84>
    80002ed2:	020d1d93          	slli	s11,s10,0x20
    80002ed6:	020ddd93          	srli	s11,s11,0x20
    80002eda:	05890613          	addi	a2,s2,88
    80002ede:	86ee                	mv	a3,s11
    80002ee0:	963a                	add	a2,a2,a4
    80002ee2:	85d2                	mv	a1,s4
    80002ee4:	855e                	mv	a0,s7
    80002ee6:	fffff097          	auipc	ra,0xfffff
    80002eea:	a2a080e7          	jalr	-1494(ra) # 80001910 <either_copyout>
    80002eee:	05850d63          	beq	a0,s8,80002f48 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ef2:	854a                	mv	a0,s2
    80002ef4:	fffff097          	auipc	ra,0xfffff
    80002ef8:	5f6080e7          	jalr	1526(ra) # 800024ea <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002efc:	013d09bb          	addw	s3,s10,s3
    80002f00:	009d04bb          	addw	s1,s10,s1
    80002f04:	9a6e                	add	s4,s4,s11
    80002f06:	0559f763          	bgeu	s3,s5,80002f54 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002f0a:	00a4d59b          	srliw	a1,s1,0xa
    80002f0e:	855a                	mv	a0,s6
    80002f10:	00000097          	auipc	ra,0x0
    80002f14:	89e080e7          	jalr	-1890(ra) # 800027ae <bmap>
    80002f18:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f1c:	cd85                	beqz	a1,80002f54 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002f1e:	000b2503          	lw	a0,0(s6)
    80002f22:	fffff097          	auipc	ra,0xfffff
    80002f26:	498080e7          	jalr	1176(ra) # 800023ba <bread>
    80002f2a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f2c:	3ff4f713          	andi	a4,s1,1023
    80002f30:	40ec87bb          	subw	a5,s9,a4
    80002f34:	413a86bb          	subw	a3,s5,s3
    80002f38:	8d3e                	mv	s10,a5
    80002f3a:	2781                	sext.w	a5,a5
    80002f3c:	0006861b          	sext.w	a2,a3
    80002f40:	f8f679e3          	bgeu	a2,a5,80002ed2 <readi+0x4c>
    80002f44:	8d36                	mv	s10,a3
    80002f46:	b771                	j	80002ed2 <readi+0x4c>
      brelse(bp);
    80002f48:	854a                	mv	a0,s2
    80002f4a:	fffff097          	auipc	ra,0xfffff
    80002f4e:	5a0080e7          	jalr	1440(ra) # 800024ea <brelse>
      tot = -1;
    80002f52:	59fd                	li	s3,-1
  }
  return tot;
    80002f54:	0009851b          	sext.w	a0,s3
}
    80002f58:	70a6                	ld	ra,104(sp)
    80002f5a:	7406                	ld	s0,96(sp)
    80002f5c:	64e6                	ld	s1,88(sp)
    80002f5e:	6946                	ld	s2,80(sp)
    80002f60:	69a6                	ld	s3,72(sp)
    80002f62:	6a06                	ld	s4,64(sp)
    80002f64:	7ae2                	ld	s5,56(sp)
    80002f66:	7b42                	ld	s6,48(sp)
    80002f68:	7ba2                	ld	s7,40(sp)
    80002f6a:	7c02                	ld	s8,32(sp)
    80002f6c:	6ce2                	ld	s9,24(sp)
    80002f6e:	6d42                	ld	s10,16(sp)
    80002f70:	6da2                	ld	s11,8(sp)
    80002f72:	6165                	addi	sp,sp,112
    80002f74:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f76:	89d6                	mv	s3,s5
    80002f78:	bff1                	j	80002f54 <readi+0xce>
    return 0;
    80002f7a:	4501                	li	a0,0
}
    80002f7c:	8082                	ret

0000000080002f7e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f7e:	457c                	lw	a5,76(a0)
    80002f80:	10d7e863          	bltu	a5,a3,80003090 <writei+0x112>
{
    80002f84:	7159                	addi	sp,sp,-112
    80002f86:	f486                	sd	ra,104(sp)
    80002f88:	f0a2                	sd	s0,96(sp)
    80002f8a:	eca6                	sd	s1,88(sp)
    80002f8c:	e8ca                	sd	s2,80(sp)
    80002f8e:	e4ce                	sd	s3,72(sp)
    80002f90:	e0d2                	sd	s4,64(sp)
    80002f92:	fc56                	sd	s5,56(sp)
    80002f94:	f85a                	sd	s6,48(sp)
    80002f96:	f45e                	sd	s7,40(sp)
    80002f98:	f062                	sd	s8,32(sp)
    80002f9a:	ec66                	sd	s9,24(sp)
    80002f9c:	e86a                	sd	s10,16(sp)
    80002f9e:	e46e                	sd	s11,8(sp)
    80002fa0:	1880                	addi	s0,sp,112
    80002fa2:	8aaa                	mv	s5,a0
    80002fa4:	8bae                	mv	s7,a1
    80002fa6:	8a32                	mv	s4,a2
    80002fa8:	8936                	mv	s2,a3
    80002faa:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002fac:	00e687bb          	addw	a5,a3,a4
    80002fb0:	0ed7e263          	bltu	a5,a3,80003094 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fb4:	00043737          	lui	a4,0x43
    80002fb8:	0ef76063          	bltu	a4,a5,80003098 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fbc:	0c0b0863          	beqz	s6,8000308c <writei+0x10e>
    80002fc0:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fc2:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fc6:	5c7d                	li	s8,-1
    80002fc8:	a091                	j	8000300c <writei+0x8e>
    80002fca:	020d1d93          	slli	s11,s10,0x20
    80002fce:	020ddd93          	srli	s11,s11,0x20
    80002fd2:	05848513          	addi	a0,s1,88
    80002fd6:	86ee                	mv	a3,s11
    80002fd8:	8652                	mv	a2,s4
    80002fda:	85de                	mv	a1,s7
    80002fdc:	953a                	add	a0,a0,a4
    80002fde:	fffff097          	auipc	ra,0xfffff
    80002fe2:	988080e7          	jalr	-1656(ra) # 80001966 <either_copyin>
    80002fe6:	07850263          	beq	a0,s8,8000304a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fea:	8526                	mv	a0,s1
    80002fec:	00000097          	auipc	ra,0x0
    80002ff0:	788080e7          	jalr	1928(ra) # 80003774 <log_write>
    brelse(bp);
    80002ff4:	8526                	mv	a0,s1
    80002ff6:	fffff097          	auipc	ra,0xfffff
    80002ffa:	4f4080e7          	jalr	1268(ra) # 800024ea <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ffe:	013d09bb          	addw	s3,s10,s3
    80003002:	012d093b          	addw	s2,s10,s2
    80003006:	9a6e                	add	s4,s4,s11
    80003008:	0569f663          	bgeu	s3,s6,80003054 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    8000300c:	00a9559b          	srliw	a1,s2,0xa
    80003010:	8556                	mv	a0,s5
    80003012:	fffff097          	auipc	ra,0xfffff
    80003016:	79c080e7          	jalr	1948(ra) # 800027ae <bmap>
    8000301a:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000301e:	c99d                	beqz	a1,80003054 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003020:	000aa503          	lw	a0,0(s5)
    80003024:	fffff097          	auipc	ra,0xfffff
    80003028:	396080e7          	jalr	918(ra) # 800023ba <bread>
    8000302c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000302e:	3ff97713          	andi	a4,s2,1023
    80003032:	40ec87bb          	subw	a5,s9,a4
    80003036:	413b06bb          	subw	a3,s6,s3
    8000303a:	8d3e                	mv	s10,a5
    8000303c:	2781                	sext.w	a5,a5
    8000303e:	0006861b          	sext.w	a2,a3
    80003042:	f8f674e3          	bgeu	a2,a5,80002fca <writei+0x4c>
    80003046:	8d36                	mv	s10,a3
    80003048:	b749                	j	80002fca <writei+0x4c>
      brelse(bp);
    8000304a:	8526                	mv	a0,s1
    8000304c:	fffff097          	auipc	ra,0xfffff
    80003050:	49e080e7          	jalr	1182(ra) # 800024ea <brelse>
  }

  if(off > ip->size)
    80003054:	04caa783          	lw	a5,76(s5)
    80003058:	0127f463          	bgeu	a5,s2,80003060 <writei+0xe2>
    ip->size = off;
    8000305c:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003060:	8556                	mv	a0,s5
    80003062:	00000097          	auipc	ra,0x0
    80003066:	aa4080e7          	jalr	-1372(ra) # 80002b06 <iupdate>

  return tot;
    8000306a:	0009851b          	sext.w	a0,s3
}
    8000306e:	70a6                	ld	ra,104(sp)
    80003070:	7406                	ld	s0,96(sp)
    80003072:	64e6                	ld	s1,88(sp)
    80003074:	6946                	ld	s2,80(sp)
    80003076:	69a6                	ld	s3,72(sp)
    80003078:	6a06                	ld	s4,64(sp)
    8000307a:	7ae2                	ld	s5,56(sp)
    8000307c:	7b42                	ld	s6,48(sp)
    8000307e:	7ba2                	ld	s7,40(sp)
    80003080:	7c02                	ld	s8,32(sp)
    80003082:	6ce2                	ld	s9,24(sp)
    80003084:	6d42                	ld	s10,16(sp)
    80003086:	6da2                	ld	s11,8(sp)
    80003088:	6165                	addi	sp,sp,112
    8000308a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000308c:	89da                	mv	s3,s6
    8000308e:	bfc9                	j	80003060 <writei+0xe2>
    return -1;
    80003090:	557d                	li	a0,-1
}
    80003092:	8082                	ret
    return -1;
    80003094:	557d                	li	a0,-1
    80003096:	bfe1                	j	8000306e <writei+0xf0>
    return -1;
    80003098:	557d                	li	a0,-1
    8000309a:	bfd1                	j	8000306e <writei+0xf0>

000000008000309c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000309c:	1141                	addi	sp,sp,-16
    8000309e:	e406                	sd	ra,8(sp)
    800030a0:	e022                	sd	s0,0(sp)
    800030a2:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030a4:	4639                	li	a2,14
    800030a6:	ffffd097          	auipc	ra,0xffffd
    800030aa:	1a4080e7          	jalr	420(ra) # 8000024a <strncmp>
}
    800030ae:	60a2                	ld	ra,8(sp)
    800030b0:	6402                	ld	s0,0(sp)
    800030b2:	0141                	addi	sp,sp,16
    800030b4:	8082                	ret

00000000800030b6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030b6:	7139                	addi	sp,sp,-64
    800030b8:	fc06                	sd	ra,56(sp)
    800030ba:	f822                	sd	s0,48(sp)
    800030bc:	f426                	sd	s1,40(sp)
    800030be:	f04a                	sd	s2,32(sp)
    800030c0:	ec4e                	sd	s3,24(sp)
    800030c2:	e852                	sd	s4,16(sp)
    800030c4:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030c6:	04451703          	lh	a4,68(a0)
    800030ca:	4785                	li	a5,1
    800030cc:	00f71a63          	bne	a4,a5,800030e0 <dirlookup+0x2a>
    800030d0:	892a                	mv	s2,a0
    800030d2:	89ae                	mv	s3,a1
    800030d4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030d6:	457c                	lw	a5,76(a0)
    800030d8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030da:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030dc:	e79d                	bnez	a5,8000310a <dirlookup+0x54>
    800030de:	a8a5                	j	80003156 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030e0:	00005517          	auipc	a0,0x5
    800030e4:	4a050513          	addi	a0,a0,1184 # 80008580 <syscalls+0x1b0>
    800030e8:	00003097          	auipc	ra,0x3
    800030ec:	c32080e7          	jalr	-974(ra) # 80005d1a <panic>
      panic("dirlookup read");
    800030f0:	00005517          	auipc	a0,0x5
    800030f4:	4a850513          	addi	a0,a0,1192 # 80008598 <syscalls+0x1c8>
    800030f8:	00003097          	auipc	ra,0x3
    800030fc:	c22080e7          	jalr	-990(ra) # 80005d1a <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003100:	24c1                	addiw	s1,s1,16
    80003102:	04c92783          	lw	a5,76(s2)
    80003106:	04f4f763          	bgeu	s1,a5,80003154 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000310a:	4741                	li	a4,16
    8000310c:	86a6                	mv	a3,s1
    8000310e:	fc040613          	addi	a2,s0,-64
    80003112:	4581                	li	a1,0
    80003114:	854a                	mv	a0,s2
    80003116:	00000097          	auipc	ra,0x0
    8000311a:	d70080e7          	jalr	-656(ra) # 80002e86 <readi>
    8000311e:	47c1                	li	a5,16
    80003120:	fcf518e3          	bne	a0,a5,800030f0 <dirlookup+0x3a>
    if(de.inum == 0)
    80003124:	fc045783          	lhu	a5,-64(s0)
    80003128:	dfe1                	beqz	a5,80003100 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000312a:	fc240593          	addi	a1,s0,-62
    8000312e:	854e                	mv	a0,s3
    80003130:	00000097          	auipc	ra,0x0
    80003134:	f6c080e7          	jalr	-148(ra) # 8000309c <namecmp>
    80003138:	f561                	bnez	a0,80003100 <dirlookup+0x4a>
      if(poff)
    8000313a:	000a0463          	beqz	s4,80003142 <dirlookup+0x8c>
        *poff = off;
    8000313e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003142:	fc045583          	lhu	a1,-64(s0)
    80003146:	00092503          	lw	a0,0(s2)
    8000314a:	fffff097          	auipc	ra,0xfffff
    8000314e:	74e080e7          	jalr	1870(ra) # 80002898 <iget>
    80003152:	a011                	j	80003156 <dirlookup+0xa0>
  return 0;
    80003154:	4501                	li	a0,0
}
    80003156:	70e2                	ld	ra,56(sp)
    80003158:	7442                	ld	s0,48(sp)
    8000315a:	74a2                	ld	s1,40(sp)
    8000315c:	7902                	ld	s2,32(sp)
    8000315e:	69e2                	ld	s3,24(sp)
    80003160:	6a42                	ld	s4,16(sp)
    80003162:	6121                	addi	sp,sp,64
    80003164:	8082                	ret

0000000080003166 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003166:	711d                	addi	sp,sp,-96
    80003168:	ec86                	sd	ra,88(sp)
    8000316a:	e8a2                	sd	s0,80(sp)
    8000316c:	e4a6                	sd	s1,72(sp)
    8000316e:	e0ca                	sd	s2,64(sp)
    80003170:	fc4e                	sd	s3,56(sp)
    80003172:	f852                	sd	s4,48(sp)
    80003174:	f456                	sd	s5,40(sp)
    80003176:	f05a                	sd	s6,32(sp)
    80003178:	ec5e                	sd	s7,24(sp)
    8000317a:	e862                	sd	s8,16(sp)
    8000317c:	e466                	sd	s9,8(sp)
    8000317e:	e06a                	sd	s10,0(sp)
    80003180:	1080                	addi	s0,sp,96
    80003182:	84aa                	mv	s1,a0
    80003184:	8b2e                	mv	s6,a1
    80003186:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003188:	00054703          	lbu	a4,0(a0)
    8000318c:	02f00793          	li	a5,47
    80003190:	02f70363          	beq	a4,a5,800031b6 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003194:	ffffe097          	auipc	ra,0xffffe
    80003198:	cc0080e7          	jalr	-832(ra) # 80000e54 <myproc>
    8000319c:	15053503          	ld	a0,336(a0)
    800031a0:	00000097          	auipc	ra,0x0
    800031a4:	9f4080e7          	jalr	-1548(ra) # 80002b94 <idup>
    800031a8:	8a2a                	mv	s4,a0
  while(*path == '/')
    800031aa:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800031ae:	4cb5                	li	s9,13
  len = path - s;
    800031b0:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031b2:	4c05                	li	s8,1
    800031b4:	a87d                	j	80003272 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800031b6:	4585                	li	a1,1
    800031b8:	4505                	li	a0,1
    800031ba:	fffff097          	auipc	ra,0xfffff
    800031be:	6de080e7          	jalr	1758(ra) # 80002898 <iget>
    800031c2:	8a2a                	mv	s4,a0
    800031c4:	b7dd                	j	800031aa <namex+0x44>
      iunlockput(ip);
    800031c6:	8552                	mv	a0,s4
    800031c8:	00000097          	auipc	ra,0x0
    800031cc:	c6c080e7          	jalr	-916(ra) # 80002e34 <iunlockput>
      return 0;
    800031d0:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031d2:	8552                	mv	a0,s4
    800031d4:	60e6                	ld	ra,88(sp)
    800031d6:	6446                	ld	s0,80(sp)
    800031d8:	64a6                	ld	s1,72(sp)
    800031da:	6906                	ld	s2,64(sp)
    800031dc:	79e2                	ld	s3,56(sp)
    800031de:	7a42                	ld	s4,48(sp)
    800031e0:	7aa2                	ld	s5,40(sp)
    800031e2:	7b02                	ld	s6,32(sp)
    800031e4:	6be2                	ld	s7,24(sp)
    800031e6:	6c42                	ld	s8,16(sp)
    800031e8:	6ca2                	ld	s9,8(sp)
    800031ea:	6d02                	ld	s10,0(sp)
    800031ec:	6125                	addi	sp,sp,96
    800031ee:	8082                	ret
      iunlock(ip);
    800031f0:	8552                	mv	a0,s4
    800031f2:	00000097          	auipc	ra,0x0
    800031f6:	aa2080e7          	jalr	-1374(ra) # 80002c94 <iunlock>
      return ip;
    800031fa:	bfe1                	j	800031d2 <namex+0x6c>
      iunlockput(ip);
    800031fc:	8552                	mv	a0,s4
    800031fe:	00000097          	auipc	ra,0x0
    80003202:	c36080e7          	jalr	-970(ra) # 80002e34 <iunlockput>
      return 0;
    80003206:	8a4e                	mv	s4,s3
    80003208:	b7e9                	j	800031d2 <namex+0x6c>
  len = path - s;
    8000320a:	40998633          	sub	a2,s3,s1
    8000320e:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003212:	09acd863          	bge	s9,s10,800032a2 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003216:	4639                	li	a2,14
    80003218:	85a6                	mv	a1,s1
    8000321a:	8556                	mv	a0,s5
    8000321c:	ffffd097          	auipc	ra,0xffffd
    80003220:	fba080e7          	jalr	-70(ra) # 800001d6 <memmove>
    80003224:	84ce                	mv	s1,s3
  while(*path == '/')
    80003226:	0004c783          	lbu	a5,0(s1)
    8000322a:	01279763          	bne	a5,s2,80003238 <namex+0xd2>
    path++;
    8000322e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003230:	0004c783          	lbu	a5,0(s1)
    80003234:	ff278de3          	beq	a5,s2,8000322e <namex+0xc8>
    ilock(ip);
    80003238:	8552                	mv	a0,s4
    8000323a:	00000097          	auipc	ra,0x0
    8000323e:	998080e7          	jalr	-1640(ra) # 80002bd2 <ilock>
    if(ip->type != T_DIR){
    80003242:	044a1783          	lh	a5,68(s4)
    80003246:	f98790e3          	bne	a5,s8,800031c6 <namex+0x60>
    if(nameiparent && *path == '\0'){
    8000324a:	000b0563          	beqz	s6,80003254 <namex+0xee>
    8000324e:	0004c783          	lbu	a5,0(s1)
    80003252:	dfd9                	beqz	a5,800031f0 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003254:	865e                	mv	a2,s7
    80003256:	85d6                	mv	a1,s5
    80003258:	8552                	mv	a0,s4
    8000325a:	00000097          	auipc	ra,0x0
    8000325e:	e5c080e7          	jalr	-420(ra) # 800030b6 <dirlookup>
    80003262:	89aa                	mv	s3,a0
    80003264:	dd41                	beqz	a0,800031fc <namex+0x96>
    iunlockput(ip);
    80003266:	8552                	mv	a0,s4
    80003268:	00000097          	auipc	ra,0x0
    8000326c:	bcc080e7          	jalr	-1076(ra) # 80002e34 <iunlockput>
    ip = next;
    80003270:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003272:	0004c783          	lbu	a5,0(s1)
    80003276:	01279763          	bne	a5,s2,80003284 <namex+0x11e>
    path++;
    8000327a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000327c:	0004c783          	lbu	a5,0(s1)
    80003280:	ff278de3          	beq	a5,s2,8000327a <namex+0x114>
  if(*path == 0)
    80003284:	cb9d                	beqz	a5,800032ba <namex+0x154>
  while(*path != '/' && *path != 0)
    80003286:	0004c783          	lbu	a5,0(s1)
    8000328a:	89a6                	mv	s3,s1
  len = path - s;
    8000328c:	8d5e                	mv	s10,s7
    8000328e:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003290:	01278963          	beq	a5,s2,800032a2 <namex+0x13c>
    80003294:	dbbd                	beqz	a5,8000320a <namex+0xa4>
    path++;
    80003296:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003298:	0009c783          	lbu	a5,0(s3)
    8000329c:	ff279ce3          	bne	a5,s2,80003294 <namex+0x12e>
    800032a0:	b7ad                	j	8000320a <namex+0xa4>
    memmove(name, s, len);
    800032a2:	2601                	sext.w	a2,a2
    800032a4:	85a6                	mv	a1,s1
    800032a6:	8556                	mv	a0,s5
    800032a8:	ffffd097          	auipc	ra,0xffffd
    800032ac:	f2e080e7          	jalr	-210(ra) # 800001d6 <memmove>
    name[len] = 0;
    800032b0:	9d56                	add	s10,s10,s5
    800032b2:	000d0023          	sb	zero,0(s10)
    800032b6:	84ce                	mv	s1,s3
    800032b8:	b7bd                	j	80003226 <namex+0xc0>
  if(nameiparent){
    800032ba:	f00b0ce3          	beqz	s6,800031d2 <namex+0x6c>
    iput(ip);
    800032be:	8552                	mv	a0,s4
    800032c0:	00000097          	auipc	ra,0x0
    800032c4:	acc080e7          	jalr	-1332(ra) # 80002d8c <iput>
    return 0;
    800032c8:	4a01                	li	s4,0
    800032ca:	b721                	j	800031d2 <namex+0x6c>

00000000800032cc <dirlink>:
{
    800032cc:	7139                	addi	sp,sp,-64
    800032ce:	fc06                	sd	ra,56(sp)
    800032d0:	f822                	sd	s0,48(sp)
    800032d2:	f426                	sd	s1,40(sp)
    800032d4:	f04a                	sd	s2,32(sp)
    800032d6:	ec4e                	sd	s3,24(sp)
    800032d8:	e852                	sd	s4,16(sp)
    800032da:	0080                	addi	s0,sp,64
    800032dc:	892a                	mv	s2,a0
    800032de:	8a2e                	mv	s4,a1
    800032e0:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032e2:	4601                	li	a2,0
    800032e4:	00000097          	auipc	ra,0x0
    800032e8:	dd2080e7          	jalr	-558(ra) # 800030b6 <dirlookup>
    800032ec:	e93d                	bnez	a0,80003362 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032ee:	04c92483          	lw	s1,76(s2)
    800032f2:	c49d                	beqz	s1,80003320 <dirlink+0x54>
    800032f4:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032f6:	4741                	li	a4,16
    800032f8:	86a6                	mv	a3,s1
    800032fa:	fc040613          	addi	a2,s0,-64
    800032fe:	4581                	li	a1,0
    80003300:	854a                	mv	a0,s2
    80003302:	00000097          	auipc	ra,0x0
    80003306:	b84080e7          	jalr	-1148(ra) # 80002e86 <readi>
    8000330a:	47c1                	li	a5,16
    8000330c:	06f51163          	bne	a0,a5,8000336e <dirlink+0xa2>
    if(de.inum == 0)
    80003310:	fc045783          	lhu	a5,-64(s0)
    80003314:	c791                	beqz	a5,80003320 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003316:	24c1                	addiw	s1,s1,16
    80003318:	04c92783          	lw	a5,76(s2)
    8000331c:	fcf4ede3          	bltu	s1,a5,800032f6 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003320:	4639                	li	a2,14
    80003322:	85d2                	mv	a1,s4
    80003324:	fc240513          	addi	a0,s0,-62
    80003328:	ffffd097          	auipc	ra,0xffffd
    8000332c:	f5e080e7          	jalr	-162(ra) # 80000286 <strncpy>
  de.inum = inum;
    80003330:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003334:	4741                	li	a4,16
    80003336:	86a6                	mv	a3,s1
    80003338:	fc040613          	addi	a2,s0,-64
    8000333c:	4581                	li	a1,0
    8000333e:	854a                	mv	a0,s2
    80003340:	00000097          	auipc	ra,0x0
    80003344:	c3e080e7          	jalr	-962(ra) # 80002f7e <writei>
    80003348:	1541                	addi	a0,a0,-16
    8000334a:	00a03533          	snez	a0,a0
    8000334e:	40a00533          	neg	a0,a0
}
    80003352:	70e2                	ld	ra,56(sp)
    80003354:	7442                	ld	s0,48(sp)
    80003356:	74a2                	ld	s1,40(sp)
    80003358:	7902                	ld	s2,32(sp)
    8000335a:	69e2                	ld	s3,24(sp)
    8000335c:	6a42                	ld	s4,16(sp)
    8000335e:	6121                	addi	sp,sp,64
    80003360:	8082                	ret
    iput(ip);
    80003362:	00000097          	auipc	ra,0x0
    80003366:	a2a080e7          	jalr	-1494(ra) # 80002d8c <iput>
    return -1;
    8000336a:	557d                	li	a0,-1
    8000336c:	b7dd                	j	80003352 <dirlink+0x86>
      panic("dirlink read");
    8000336e:	00005517          	auipc	a0,0x5
    80003372:	23a50513          	addi	a0,a0,570 # 800085a8 <syscalls+0x1d8>
    80003376:	00003097          	auipc	ra,0x3
    8000337a:	9a4080e7          	jalr	-1628(ra) # 80005d1a <panic>

000000008000337e <namei>:

struct inode*
namei(char *path)
{
    8000337e:	1101                	addi	sp,sp,-32
    80003380:	ec06                	sd	ra,24(sp)
    80003382:	e822                	sd	s0,16(sp)
    80003384:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003386:	fe040613          	addi	a2,s0,-32
    8000338a:	4581                	li	a1,0
    8000338c:	00000097          	auipc	ra,0x0
    80003390:	dda080e7          	jalr	-550(ra) # 80003166 <namex>
}
    80003394:	60e2                	ld	ra,24(sp)
    80003396:	6442                	ld	s0,16(sp)
    80003398:	6105                	addi	sp,sp,32
    8000339a:	8082                	ret

000000008000339c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000339c:	1141                	addi	sp,sp,-16
    8000339e:	e406                	sd	ra,8(sp)
    800033a0:	e022                	sd	s0,0(sp)
    800033a2:	0800                	addi	s0,sp,16
    800033a4:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033a6:	4585                	li	a1,1
    800033a8:	00000097          	auipc	ra,0x0
    800033ac:	dbe080e7          	jalr	-578(ra) # 80003166 <namex>
}
    800033b0:	60a2                	ld	ra,8(sp)
    800033b2:	6402                	ld	s0,0(sp)
    800033b4:	0141                	addi	sp,sp,16
    800033b6:	8082                	ret

00000000800033b8 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033b8:	1101                	addi	sp,sp,-32
    800033ba:	ec06                	sd	ra,24(sp)
    800033bc:	e822                	sd	s0,16(sp)
    800033be:	e426                	sd	s1,8(sp)
    800033c0:	e04a                	sd	s2,0(sp)
    800033c2:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033c4:	00016917          	auipc	s2,0x16
    800033c8:	b3c90913          	addi	s2,s2,-1220 # 80018f00 <log>
    800033cc:	01892583          	lw	a1,24(s2)
    800033d0:	02892503          	lw	a0,40(s2)
    800033d4:	fffff097          	auipc	ra,0xfffff
    800033d8:	fe6080e7          	jalr	-26(ra) # 800023ba <bread>
    800033dc:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033de:	02c92683          	lw	a3,44(s2)
    800033e2:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033e4:	02d05863          	blez	a3,80003414 <write_head+0x5c>
    800033e8:	00016797          	auipc	a5,0x16
    800033ec:	b4878793          	addi	a5,a5,-1208 # 80018f30 <log+0x30>
    800033f0:	05c50713          	addi	a4,a0,92
    800033f4:	36fd                	addiw	a3,a3,-1
    800033f6:	02069613          	slli	a2,a3,0x20
    800033fa:	01e65693          	srli	a3,a2,0x1e
    800033fe:	00016617          	auipc	a2,0x16
    80003402:	b3660613          	addi	a2,a2,-1226 # 80018f34 <log+0x34>
    80003406:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003408:	4390                	lw	a2,0(a5)
    8000340a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000340c:	0791                	addi	a5,a5,4
    8000340e:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    80003410:	fed79ce3          	bne	a5,a3,80003408 <write_head+0x50>
  }
  bwrite(buf);
    80003414:	8526                	mv	a0,s1
    80003416:	fffff097          	auipc	ra,0xfffff
    8000341a:	096080e7          	jalr	150(ra) # 800024ac <bwrite>
  brelse(buf);
    8000341e:	8526                	mv	a0,s1
    80003420:	fffff097          	auipc	ra,0xfffff
    80003424:	0ca080e7          	jalr	202(ra) # 800024ea <brelse>
}
    80003428:	60e2                	ld	ra,24(sp)
    8000342a:	6442                	ld	s0,16(sp)
    8000342c:	64a2                	ld	s1,8(sp)
    8000342e:	6902                	ld	s2,0(sp)
    80003430:	6105                	addi	sp,sp,32
    80003432:	8082                	ret

0000000080003434 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003434:	00016797          	auipc	a5,0x16
    80003438:	af87a783          	lw	a5,-1288(a5) # 80018f2c <log+0x2c>
    8000343c:	0af05d63          	blez	a5,800034f6 <install_trans+0xc2>
{
    80003440:	7139                	addi	sp,sp,-64
    80003442:	fc06                	sd	ra,56(sp)
    80003444:	f822                	sd	s0,48(sp)
    80003446:	f426                	sd	s1,40(sp)
    80003448:	f04a                	sd	s2,32(sp)
    8000344a:	ec4e                	sd	s3,24(sp)
    8000344c:	e852                	sd	s4,16(sp)
    8000344e:	e456                	sd	s5,8(sp)
    80003450:	e05a                	sd	s6,0(sp)
    80003452:	0080                	addi	s0,sp,64
    80003454:	8b2a                	mv	s6,a0
    80003456:	00016a97          	auipc	s5,0x16
    8000345a:	adaa8a93          	addi	s5,s5,-1318 # 80018f30 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000345e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003460:	00016997          	auipc	s3,0x16
    80003464:	aa098993          	addi	s3,s3,-1376 # 80018f00 <log>
    80003468:	a00d                	j	8000348a <install_trans+0x56>
    brelse(lbuf);
    8000346a:	854a                	mv	a0,s2
    8000346c:	fffff097          	auipc	ra,0xfffff
    80003470:	07e080e7          	jalr	126(ra) # 800024ea <brelse>
    brelse(dbuf);
    80003474:	8526                	mv	a0,s1
    80003476:	fffff097          	auipc	ra,0xfffff
    8000347a:	074080e7          	jalr	116(ra) # 800024ea <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000347e:	2a05                	addiw	s4,s4,1
    80003480:	0a91                	addi	s5,s5,4
    80003482:	02c9a783          	lw	a5,44(s3)
    80003486:	04fa5e63          	bge	s4,a5,800034e2 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000348a:	0189a583          	lw	a1,24(s3)
    8000348e:	014585bb          	addw	a1,a1,s4
    80003492:	2585                	addiw	a1,a1,1
    80003494:	0289a503          	lw	a0,40(s3)
    80003498:	fffff097          	auipc	ra,0xfffff
    8000349c:	f22080e7          	jalr	-222(ra) # 800023ba <bread>
    800034a0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034a2:	000aa583          	lw	a1,0(s5)
    800034a6:	0289a503          	lw	a0,40(s3)
    800034aa:	fffff097          	auipc	ra,0xfffff
    800034ae:	f10080e7          	jalr	-240(ra) # 800023ba <bread>
    800034b2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034b4:	40000613          	li	a2,1024
    800034b8:	05890593          	addi	a1,s2,88
    800034bc:	05850513          	addi	a0,a0,88
    800034c0:	ffffd097          	auipc	ra,0xffffd
    800034c4:	d16080e7          	jalr	-746(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034c8:	8526                	mv	a0,s1
    800034ca:	fffff097          	auipc	ra,0xfffff
    800034ce:	fe2080e7          	jalr	-30(ra) # 800024ac <bwrite>
    if(recovering == 0)
    800034d2:	f80b1ce3          	bnez	s6,8000346a <install_trans+0x36>
      bunpin(dbuf);
    800034d6:	8526                	mv	a0,s1
    800034d8:	fffff097          	auipc	ra,0xfffff
    800034dc:	0ec080e7          	jalr	236(ra) # 800025c4 <bunpin>
    800034e0:	b769                	j	8000346a <install_trans+0x36>
}
    800034e2:	70e2                	ld	ra,56(sp)
    800034e4:	7442                	ld	s0,48(sp)
    800034e6:	74a2                	ld	s1,40(sp)
    800034e8:	7902                	ld	s2,32(sp)
    800034ea:	69e2                	ld	s3,24(sp)
    800034ec:	6a42                	ld	s4,16(sp)
    800034ee:	6aa2                	ld	s5,8(sp)
    800034f0:	6b02                	ld	s6,0(sp)
    800034f2:	6121                	addi	sp,sp,64
    800034f4:	8082                	ret
    800034f6:	8082                	ret

00000000800034f8 <initlog>:
{
    800034f8:	7179                	addi	sp,sp,-48
    800034fa:	f406                	sd	ra,40(sp)
    800034fc:	f022                	sd	s0,32(sp)
    800034fe:	ec26                	sd	s1,24(sp)
    80003500:	e84a                	sd	s2,16(sp)
    80003502:	e44e                	sd	s3,8(sp)
    80003504:	1800                	addi	s0,sp,48
    80003506:	892a                	mv	s2,a0
    80003508:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000350a:	00016497          	auipc	s1,0x16
    8000350e:	9f648493          	addi	s1,s1,-1546 # 80018f00 <log>
    80003512:	00005597          	auipc	a1,0x5
    80003516:	0a658593          	addi	a1,a1,166 # 800085b8 <syscalls+0x1e8>
    8000351a:	8526                	mv	a0,s1
    8000351c:	00003097          	auipc	ra,0x3
    80003520:	c7c080e7          	jalr	-900(ra) # 80006198 <initlock>
  log.start = sb->logstart;
    80003524:	0149a583          	lw	a1,20(s3)
    80003528:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000352a:	0109a783          	lw	a5,16(s3)
    8000352e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003530:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003534:	854a                	mv	a0,s2
    80003536:	fffff097          	auipc	ra,0xfffff
    8000353a:	e84080e7          	jalr	-380(ra) # 800023ba <bread>
  log.lh.n = lh->n;
    8000353e:	4d34                	lw	a3,88(a0)
    80003540:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003542:	02d05663          	blez	a3,8000356e <initlog+0x76>
    80003546:	05c50793          	addi	a5,a0,92
    8000354a:	00016717          	auipc	a4,0x16
    8000354e:	9e670713          	addi	a4,a4,-1562 # 80018f30 <log+0x30>
    80003552:	36fd                	addiw	a3,a3,-1
    80003554:	02069613          	slli	a2,a3,0x20
    80003558:	01e65693          	srli	a3,a2,0x1e
    8000355c:	06050613          	addi	a2,a0,96
    80003560:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003562:	4390                	lw	a2,0(a5)
    80003564:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003566:	0791                	addi	a5,a5,4
    80003568:	0711                	addi	a4,a4,4
    8000356a:	fed79ce3          	bne	a5,a3,80003562 <initlog+0x6a>
  brelse(buf);
    8000356e:	fffff097          	auipc	ra,0xfffff
    80003572:	f7c080e7          	jalr	-132(ra) # 800024ea <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003576:	4505                	li	a0,1
    80003578:	00000097          	auipc	ra,0x0
    8000357c:	ebc080e7          	jalr	-324(ra) # 80003434 <install_trans>
  log.lh.n = 0;
    80003580:	00016797          	auipc	a5,0x16
    80003584:	9a07a623          	sw	zero,-1620(a5) # 80018f2c <log+0x2c>
  write_head(); // clear the log
    80003588:	00000097          	auipc	ra,0x0
    8000358c:	e30080e7          	jalr	-464(ra) # 800033b8 <write_head>
}
    80003590:	70a2                	ld	ra,40(sp)
    80003592:	7402                	ld	s0,32(sp)
    80003594:	64e2                	ld	s1,24(sp)
    80003596:	6942                	ld	s2,16(sp)
    80003598:	69a2                	ld	s3,8(sp)
    8000359a:	6145                	addi	sp,sp,48
    8000359c:	8082                	ret

000000008000359e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000359e:	1101                	addi	sp,sp,-32
    800035a0:	ec06                	sd	ra,24(sp)
    800035a2:	e822                	sd	s0,16(sp)
    800035a4:	e426                	sd	s1,8(sp)
    800035a6:	e04a                	sd	s2,0(sp)
    800035a8:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035aa:	00016517          	auipc	a0,0x16
    800035ae:	95650513          	addi	a0,a0,-1706 # 80018f00 <log>
    800035b2:	00003097          	auipc	ra,0x3
    800035b6:	c76080e7          	jalr	-906(ra) # 80006228 <acquire>
  while(1){
    if(log.committing){
    800035ba:	00016497          	auipc	s1,0x16
    800035be:	94648493          	addi	s1,s1,-1722 # 80018f00 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035c2:	4979                	li	s2,30
    800035c4:	a039                	j	800035d2 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035c6:	85a6                	mv	a1,s1
    800035c8:	8526                	mv	a0,s1
    800035ca:	ffffe097          	auipc	ra,0xffffe
    800035ce:	f3e080e7          	jalr	-194(ra) # 80001508 <sleep>
    if(log.committing){
    800035d2:	50dc                	lw	a5,36(s1)
    800035d4:	fbed                	bnez	a5,800035c6 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035d6:	5098                	lw	a4,32(s1)
    800035d8:	2705                	addiw	a4,a4,1
    800035da:	0007069b          	sext.w	a3,a4
    800035de:	0027179b          	slliw	a5,a4,0x2
    800035e2:	9fb9                	addw	a5,a5,a4
    800035e4:	0017979b          	slliw	a5,a5,0x1
    800035e8:	54d8                	lw	a4,44(s1)
    800035ea:	9fb9                	addw	a5,a5,a4
    800035ec:	00f95963          	bge	s2,a5,800035fe <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035f0:	85a6                	mv	a1,s1
    800035f2:	8526                	mv	a0,s1
    800035f4:	ffffe097          	auipc	ra,0xffffe
    800035f8:	f14080e7          	jalr	-236(ra) # 80001508 <sleep>
    800035fc:	bfd9                	j	800035d2 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035fe:	00016517          	auipc	a0,0x16
    80003602:	90250513          	addi	a0,a0,-1790 # 80018f00 <log>
    80003606:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003608:	00003097          	auipc	ra,0x3
    8000360c:	cd4080e7          	jalr	-812(ra) # 800062dc <release>
      break;
    }
  }
}
    80003610:	60e2                	ld	ra,24(sp)
    80003612:	6442                	ld	s0,16(sp)
    80003614:	64a2                	ld	s1,8(sp)
    80003616:	6902                	ld	s2,0(sp)
    80003618:	6105                	addi	sp,sp,32
    8000361a:	8082                	ret

000000008000361c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000361c:	7139                	addi	sp,sp,-64
    8000361e:	fc06                	sd	ra,56(sp)
    80003620:	f822                	sd	s0,48(sp)
    80003622:	f426                	sd	s1,40(sp)
    80003624:	f04a                	sd	s2,32(sp)
    80003626:	ec4e                	sd	s3,24(sp)
    80003628:	e852                	sd	s4,16(sp)
    8000362a:	e456                	sd	s5,8(sp)
    8000362c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000362e:	00016497          	auipc	s1,0x16
    80003632:	8d248493          	addi	s1,s1,-1838 # 80018f00 <log>
    80003636:	8526                	mv	a0,s1
    80003638:	00003097          	auipc	ra,0x3
    8000363c:	bf0080e7          	jalr	-1040(ra) # 80006228 <acquire>
  log.outstanding -= 1;
    80003640:	509c                	lw	a5,32(s1)
    80003642:	37fd                	addiw	a5,a5,-1
    80003644:	0007891b          	sext.w	s2,a5
    80003648:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000364a:	50dc                	lw	a5,36(s1)
    8000364c:	e7b9                	bnez	a5,8000369a <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000364e:	04091e63          	bnez	s2,800036aa <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003652:	00016497          	auipc	s1,0x16
    80003656:	8ae48493          	addi	s1,s1,-1874 # 80018f00 <log>
    8000365a:	4785                	li	a5,1
    8000365c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000365e:	8526                	mv	a0,s1
    80003660:	00003097          	auipc	ra,0x3
    80003664:	c7c080e7          	jalr	-900(ra) # 800062dc <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003668:	54dc                	lw	a5,44(s1)
    8000366a:	06f04763          	bgtz	a5,800036d8 <end_op+0xbc>
    acquire(&log.lock);
    8000366e:	00016497          	auipc	s1,0x16
    80003672:	89248493          	addi	s1,s1,-1902 # 80018f00 <log>
    80003676:	8526                	mv	a0,s1
    80003678:	00003097          	auipc	ra,0x3
    8000367c:	bb0080e7          	jalr	-1104(ra) # 80006228 <acquire>
    log.committing = 0;
    80003680:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003684:	8526                	mv	a0,s1
    80003686:	ffffe097          	auipc	ra,0xffffe
    8000368a:	ee6080e7          	jalr	-282(ra) # 8000156c <wakeup>
    release(&log.lock);
    8000368e:	8526                	mv	a0,s1
    80003690:	00003097          	auipc	ra,0x3
    80003694:	c4c080e7          	jalr	-948(ra) # 800062dc <release>
}
    80003698:	a03d                	j	800036c6 <end_op+0xaa>
    panic("log.committing");
    8000369a:	00005517          	auipc	a0,0x5
    8000369e:	f2650513          	addi	a0,a0,-218 # 800085c0 <syscalls+0x1f0>
    800036a2:	00002097          	auipc	ra,0x2
    800036a6:	678080e7          	jalr	1656(ra) # 80005d1a <panic>
    wakeup(&log);
    800036aa:	00016497          	auipc	s1,0x16
    800036ae:	85648493          	addi	s1,s1,-1962 # 80018f00 <log>
    800036b2:	8526                	mv	a0,s1
    800036b4:	ffffe097          	auipc	ra,0xffffe
    800036b8:	eb8080e7          	jalr	-328(ra) # 8000156c <wakeup>
  release(&log.lock);
    800036bc:	8526                	mv	a0,s1
    800036be:	00003097          	auipc	ra,0x3
    800036c2:	c1e080e7          	jalr	-994(ra) # 800062dc <release>
}
    800036c6:	70e2                	ld	ra,56(sp)
    800036c8:	7442                	ld	s0,48(sp)
    800036ca:	74a2                	ld	s1,40(sp)
    800036cc:	7902                	ld	s2,32(sp)
    800036ce:	69e2                	ld	s3,24(sp)
    800036d0:	6a42                	ld	s4,16(sp)
    800036d2:	6aa2                	ld	s5,8(sp)
    800036d4:	6121                	addi	sp,sp,64
    800036d6:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800036d8:	00016a97          	auipc	s5,0x16
    800036dc:	858a8a93          	addi	s5,s5,-1960 # 80018f30 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036e0:	00016a17          	auipc	s4,0x16
    800036e4:	820a0a13          	addi	s4,s4,-2016 # 80018f00 <log>
    800036e8:	018a2583          	lw	a1,24(s4)
    800036ec:	012585bb          	addw	a1,a1,s2
    800036f0:	2585                	addiw	a1,a1,1
    800036f2:	028a2503          	lw	a0,40(s4)
    800036f6:	fffff097          	auipc	ra,0xfffff
    800036fa:	cc4080e7          	jalr	-828(ra) # 800023ba <bread>
    800036fe:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003700:	000aa583          	lw	a1,0(s5)
    80003704:	028a2503          	lw	a0,40(s4)
    80003708:	fffff097          	auipc	ra,0xfffff
    8000370c:	cb2080e7          	jalr	-846(ra) # 800023ba <bread>
    80003710:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003712:	40000613          	li	a2,1024
    80003716:	05850593          	addi	a1,a0,88
    8000371a:	05848513          	addi	a0,s1,88
    8000371e:	ffffd097          	auipc	ra,0xffffd
    80003722:	ab8080e7          	jalr	-1352(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003726:	8526                	mv	a0,s1
    80003728:	fffff097          	auipc	ra,0xfffff
    8000372c:	d84080e7          	jalr	-636(ra) # 800024ac <bwrite>
    brelse(from);
    80003730:	854e                	mv	a0,s3
    80003732:	fffff097          	auipc	ra,0xfffff
    80003736:	db8080e7          	jalr	-584(ra) # 800024ea <brelse>
    brelse(to);
    8000373a:	8526                	mv	a0,s1
    8000373c:	fffff097          	auipc	ra,0xfffff
    80003740:	dae080e7          	jalr	-594(ra) # 800024ea <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003744:	2905                	addiw	s2,s2,1
    80003746:	0a91                	addi	s5,s5,4
    80003748:	02ca2783          	lw	a5,44(s4)
    8000374c:	f8f94ee3          	blt	s2,a5,800036e8 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003750:	00000097          	auipc	ra,0x0
    80003754:	c68080e7          	jalr	-920(ra) # 800033b8 <write_head>
    install_trans(0); // Now install writes to home locations
    80003758:	4501                	li	a0,0
    8000375a:	00000097          	auipc	ra,0x0
    8000375e:	cda080e7          	jalr	-806(ra) # 80003434 <install_trans>
    log.lh.n = 0;
    80003762:	00015797          	auipc	a5,0x15
    80003766:	7c07a523          	sw	zero,1994(a5) # 80018f2c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000376a:	00000097          	auipc	ra,0x0
    8000376e:	c4e080e7          	jalr	-946(ra) # 800033b8 <write_head>
    80003772:	bdf5                	j	8000366e <end_op+0x52>

0000000080003774 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003774:	1101                	addi	sp,sp,-32
    80003776:	ec06                	sd	ra,24(sp)
    80003778:	e822                	sd	s0,16(sp)
    8000377a:	e426                	sd	s1,8(sp)
    8000377c:	e04a                	sd	s2,0(sp)
    8000377e:	1000                	addi	s0,sp,32
    80003780:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003782:	00015917          	auipc	s2,0x15
    80003786:	77e90913          	addi	s2,s2,1918 # 80018f00 <log>
    8000378a:	854a                	mv	a0,s2
    8000378c:	00003097          	auipc	ra,0x3
    80003790:	a9c080e7          	jalr	-1380(ra) # 80006228 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003794:	02c92603          	lw	a2,44(s2)
    80003798:	47f5                	li	a5,29
    8000379a:	06c7c563          	blt	a5,a2,80003804 <log_write+0x90>
    8000379e:	00015797          	auipc	a5,0x15
    800037a2:	77e7a783          	lw	a5,1918(a5) # 80018f1c <log+0x1c>
    800037a6:	37fd                	addiw	a5,a5,-1
    800037a8:	04f65e63          	bge	a2,a5,80003804 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037ac:	00015797          	auipc	a5,0x15
    800037b0:	7747a783          	lw	a5,1908(a5) # 80018f20 <log+0x20>
    800037b4:	06f05063          	blez	a5,80003814 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037b8:	4781                	li	a5,0
    800037ba:	06c05563          	blez	a2,80003824 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037be:	44cc                	lw	a1,12(s1)
    800037c0:	00015717          	auipc	a4,0x15
    800037c4:	77070713          	addi	a4,a4,1904 # 80018f30 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037c8:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037ca:	4314                	lw	a3,0(a4)
    800037cc:	04b68c63          	beq	a3,a1,80003824 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037d0:	2785                	addiw	a5,a5,1
    800037d2:	0711                	addi	a4,a4,4
    800037d4:	fef61be3          	bne	a2,a5,800037ca <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037d8:	0621                	addi	a2,a2,8
    800037da:	060a                	slli	a2,a2,0x2
    800037dc:	00015797          	auipc	a5,0x15
    800037e0:	72478793          	addi	a5,a5,1828 # 80018f00 <log>
    800037e4:	97b2                	add	a5,a5,a2
    800037e6:	44d8                	lw	a4,12(s1)
    800037e8:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037ea:	8526                	mv	a0,s1
    800037ec:	fffff097          	auipc	ra,0xfffff
    800037f0:	d9c080e7          	jalr	-612(ra) # 80002588 <bpin>
    log.lh.n++;
    800037f4:	00015717          	auipc	a4,0x15
    800037f8:	70c70713          	addi	a4,a4,1804 # 80018f00 <log>
    800037fc:	575c                	lw	a5,44(a4)
    800037fe:	2785                	addiw	a5,a5,1
    80003800:	d75c                	sw	a5,44(a4)
    80003802:	a82d                	j	8000383c <log_write+0xc8>
    panic("too big a transaction");
    80003804:	00005517          	auipc	a0,0x5
    80003808:	dcc50513          	addi	a0,a0,-564 # 800085d0 <syscalls+0x200>
    8000380c:	00002097          	auipc	ra,0x2
    80003810:	50e080e7          	jalr	1294(ra) # 80005d1a <panic>
    panic("log_write outside of trans");
    80003814:	00005517          	auipc	a0,0x5
    80003818:	dd450513          	addi	a0,a0,-556 # 800085e8 <syscalls+0x218>
    8000381c:	00002097          	auipc	ra,0x2
    80003820:	4fe080e7          	jalr	1278(ra) # 80005d1a <panic>
  log.lh.block[i] = b->blockno;
    80003824:	00878693          	addi	a3,a5,8
    80003828:	068a                	slli	a3,a3,0x2
    8000382a:	00015717          	auipc	a4,0x15
    8000382e:	6d670713          	addi	a4,a4,1750 # 80018f00 <log>
    80003832:	9736                	add	a4,a4,a3
    80003834:	44d4                	lw	a3,12(s1)
    80003836:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003838:	faf609e3          	beq	a2,a5,800037ea <log_write+0x76>
  }
  release(&log.lock);
    8000383c:	00015517          	auipc	a0,0x15
    80003840:	6c450513          	addi	a0,a0,1732 # 80018f00 <log>
    80003844:	00003097          	auipc	ra,0x3
    80003848:	a98080e7          	jalr	-1384(ra) # 800062dc <release>
}
    8000384c:	60e2                	ld	ra,24(sp)
    8000384e:	6442                	ld	s0,16(sp)
    80003850:	64a2                	ld	s1,8(sp)
    80003852:	6902                	ld	s2,0(sp)
    80003854:	6105                	addi	sp,sp,32
    80003856:	8082                	ret

0000000080003858 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003858:	1101                	addi	sp,sp,-32
    8000385a:	ec06                	sd	ra,24(sp)
    8000385c:	e822                	sd	s0,16(sp)
    8000385e:	e426                	sd	s1,8(sp)
    80003860:	e04a                	sd	s2,0(sp)
    80003862:	1000                	addi	s0,sp,32
    80003864:	84aa                	mv	s1,a0
    80003866:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003868:	00005597          	auipc	a1,0x5
    8000386c:	da058593          	addi	a1,a1,-608 # 80008608 <syscalls+0x238>
    80003870:	0521                	addi	a0,a0,8
    80003872:	00003097          	auipc	ra,0x3
    80003876:	926080e7          	jalr	-1754(ra) # 80006198 <initlock>
  lk->name = name;
    8000387a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000387e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003882:	0204a423          	sw	zero,40(s1)
}
    80003886:	60e2                	ld	ra,24(sp)
    80003888:	6442                	ld	s0,16(sp)
    8000388a:	64a2                	ld	s1,8(sp)
    8000388c:	6902                	ld	s2,0(sp)
    8000388e:	6105                	addi	sp,sp,32
    80003890:	8082                	ret

0000000080003892 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003892:	1101                	addi	sp,sp,-32
    80003894:	ec06                	sd	ra,24(sp)
    80003896:	e822                	sd	s0,16(sp)
    80003898:	e426                	sd	s1,8(sp)
    8000389a:	e04a                	sd	s2,0(sp)
    8000389c:	1000                	addi	s0,sp,32
    8000389e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038a0:	00850913          	addi	s2,a0,8
    800038a4:	854a                	mv	a0,s2
    800038a6:	00003097          	auipc	ra,0x3
    800038aa:	982080e7          	jalr	-1662(ra) # 80006228 <acquire>
  while (lk->locked) {
    800038ae:	409c                	lw	a5,0(s1)
    800038b0:	cb89                	beqz	a5,800038c2 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038b2:	85ca                	mv	a1,s2
    800038b4:	8526                	mv	a0,s1
    800038b6:	ffffe097          	auipc	ra,0xffffe
    800038ba:	c52080e7          	jalr	-942(ra) # 80001508 <sleep>
  while (lk->locked) {
    800038be:	409c                	lw	a5,0(s1)
    800038c0:	fbed                	bnez	a5,800038b2 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038c2:	4785                	li	a5,1
    800038c4:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038c6:	ffffd097          	auipc	ra,0xffffd
    800038ca:	58e080e7          	jalr	1422(ra) # 80000e54 <myproc>
    800038ce:	591c                	lw	a5,48(a0)
    800038d0:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038d2:	854a                	mv	a0,s2
    800038d4:	00003097          	auipc	ra,0x3
    800038d8:	a08080e7          	jalr	-1528(ra) # 800062dc <release>
}
    800038dc:	60e2                	ld	ra,24(sp)
    800038de:	6442                	ld	s0,16(sp)
    800038e0:	64a2                	ld	s1,8(sp)
    800038e2:	6902                	ld	s2,0(sp)
    800038e4:	6105                	addi	sp,sp,32
    800038e6:	8082                	ret

00000000800038e8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038e8:	1101                	addi	sp,sp,-32
    800038ea:	ec06                	sd	ra,24(sp)
    800038ec:	e822                	sd	s0,16(sp)
    800038ee:	e426                	sd	s1,8(sp)
    800038f0:	e04a                	sd	s2,0(sp)
    800038f2:	1000                	addi	s0,sp,32
    800038f4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038f6:	00850913          	addi	s2,a0,8
    800038fa:	854a                	mv	a0,s2
    800038fc:	00003097          	auipc	ra,0x3
    80003900:	92c080e7          	jalr	-1748(ra) # 80006228 <acquire>
  lk->locked = 0;
    80003904:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003908:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000390c:	8526                	mv	a0,s1
    8000390e:	ffffe097          	auipc	ra,0xffffe
    80003912:	c5e080e7          	jalr	-930(ra) # 8000156c <wakeup>
  release(&lk->lk);
    80003916:	854a                	mv	a0,s2
    80003918:	00003097          	auipc	ra,0x3
    8000391c:	9c4080e7          	jalr	-1596(ra) # 800062dc <release>
}
    80003920:	60e2                	ld	ra,24(sp)
    80003922:	6442                	ld	s0,16(sp)
    80003924:	64a2                	ld	s1,8(sp)
    80003926:	6902                	ld	s2,0(sp)
    80003928:	6105                	addi	sp,sp,32
    8000392a:	8082                	ret

000000008000392c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000392c:	7179                	addi	sp,sp,-48
    8000392e:	f406                	sd	ra,40(sp)
    80003930:	f022                	sd	s0,32(sp)
    80003932:	ec26                	sd	s1,24(sp)
    80003934:	e84a                	sd	s2,16(sp)
    80003936:	e44e                	sd	s3,8(sp)
    80003938:	1800                	addi	s0,sp,48
    8000393a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000393c:	00850913          	addi	s2,a0,8
    80003940:	854a                	mv	a0,s2
    80003942:	00003097          	auipc	ra,0x3
    80003946:	8e6080e7          	jalr	-1818(ra) # 80006228 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000394a:	409c                	lw	a5,0(s1)
    8000394c:	ef99                	bnez	a5,8000396a <holdingsleep+0x3e>
    8000394e:	4481                	li	s1,0
  release(&lk->lk);
    80003950:	854a                	mv	a0,s2
    80003952:	00003097          	auipc	ra,0x3
    80003956:	98a080e7          	jalr	-1654(ra) # 800062dc <release>
  return r;
}
    8000395a:	8526                	mv	a0,s1
    8000395c:	70a2                	ld	ra,40(sp)
    8000395e:	7402                	ld	s0,32(sp)
    80003960:	64e2                	ld	s1,24(sp)
    80003962:	6942                	ld	s2,16(sp)
    80003964:	69a2                	ld	s3,8(sp)
    80003966:	6145                	addi	sp,sp,48
    80003968:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000396a:	0284a983          	lw	s3,40(s1)
    8000396e:	ffffd097          	auipc	ra,0xffffd
    80003972:	4e6080e7          	jalr	1254(ra) # 80000e54 <myproc>
    80003976:	5904                	lw	s1,48(a0)
    80003978:	413484b3          	sub	s1,s1,s3
    8000397c:	0014b493          	seqz	s1,s1
    80003980:	bfc1                	j	80003950 <holdingsleep+0x24>

0000000080003982 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003982:	1141                	addi	sp,sp,-16
    80003984:	e406                	sd	ra,8(sp)
    80003986:	e022                	sd	s0,0(sp)
    80003988:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000398a:	00005597          	auipc	a1,0x5
    8000398e:	c8e58593          	addi	a1,a1,-882 # 80008618 <syscalls+0x248>
    80003992:	00015517          	auipc	a0,0x15
    80003996:	6b650513          	addi	a0,a0,1718 # 80019048 <ftable>
    8000399a:	00002097          	auipc	ra,0x2
    8000399e:	7fe080e7          	jalr	2046(ra) # 80006198 <initlock>
}
    800039a2:	60a2                	ld	ra,8(sp)
    800039a4:	6402                	ld	s0,0(sp)
    800039a6:	0141                	addi	sp,sp,16
    800039a8:	8082                	ret

00000000800039aa <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039aa:	1101                	addi	sp,sp,-32
    800039ac:	ec06                	sd	ra,24(sp)
    800039ae:	e822                	sd	s0,16(sp)
    800039b0:	e426                	sd	s1,8(sp)
    800039b2:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039b4:	00015517          	auipc	a0,0x15
    800039b8:	69450513          	addi	a0,a0,1684 # 80019048 <ftable>
    800039bc:	00003097          	auipc	ra,0x3
    800039c0:	86c080e7          	jalr	-1940(ra) # 80006228 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039c4:	00015497          	auipc	s1,0x15
    800039c8:	69c48493          	addi	s1,s1,1692 # 80019060 <ftable+0x18>
    800039cc:	00016717          	auipc	a4,0x16
    800039d0:	63470713          	addi	a4,a4,1588 # 8001a000 <disk>
    if(f->ref == 0){
    800039d4:	40dc                	lw	a5,4(s1)
    800039d6:	cf99                	beqz	a5,800039f4 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039d8:	02848493          	addi	s1,s1,40
    800039dc:	fee49ce3          	bne	s1,a4,800039d4 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039e0:	00015517          	auipc	a0,0x15
    800039e4:	66850513          	addi	a0,a0,1640 # 80019048 <ftable>
    800039e8:	00003097          	auipc	ra,0x3
    800039ec:	8f4080e7          	jalr	-1804(ra) # 800062dc <release>
  return 0;
    800039f0:	4481                	li	s1,0
    800039f2:	a819                	j	80003a08 <filealloc+0x5e>
      f->ref = 1;
    800039f4:	4785                	li	a5,1
    800039f6:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039f8:	00015517          	auipc	a0,0x15
    800039fc:	65050513          	addi	a0,a0,1616 # 80019048 <ftable>
    80003a00:	00003097          	auipc	ra,0x3
    80003a04:	8dc080e7          	jalr	-1828(ra) # 800062dc <release>
}
    80003a08:	8526                	mv	a0,s1
    80003a0a:	60e2                	ld	ra,24(sp)
    80003a0c:	6442                	ld	s0,16(sp)
    80003a0e:	64a2                	ld	s1,8(sp)
    80003a10:	6105                	addi	sp,sp,32
    80003a12:	8082                	ret

0000000080003a14 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a14:	1101                	addi	sp,sp,-32
    80003a16:	ec06                	sd	ra,24(sp)
    80003a18:	e822                	sd	s0,16(sp)
    80003a1a:	e426                	sd	s1,8(sp)
    80003a1c:	1000                	addi	s0,sp,32
    80003a1e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a20:	00015517          	auipc	a0,0x15
    80003a24:	62850513          	addi	a0,a0,1576 # 80019048 <ftable>
    80003a28:	00003097          	auipc	ra,0x3
    80003a2c:	800080e7          	jalr	-2048(ra) # 80006228 <acquire>
  if(f->ref < 1)
    80003a30:	40dc                	lw	a5,4(s1)
    80003a32:	02f05263          	blez	a5,80003a56 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a36:	2785                	addiw	a5,a5,1
    80003a38:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a3a:	00015517          	auipc	a0,0x15
    80003a3e:	60e50513          	addi	a0,a0,1550 # 80019048 <ftable>
    80003a42:	00003097          	auipc	ra,0x3
    80003a46:	89a080e7          	jalr	-1894(ra) # 800062dc <release>
  return f;
}
    80003a4a:	8526                	mv	a0,s1
    80003a4c:	60e2                	ld	ra,24(sp)
    80003a4e:	6442                	ld	s0,16(sp)
    80003a50:	64a2                	ld	s1,8(sp)
    80003a52:	6105                	addi	sp,sp,32
    80003a54:	8082                	ret
    panic("filedup");
    80003a56:	00005517          	auipc	a0,0x5
    80003a5a:	bca50513          	addi	a0,a0,-1078 # 80008620 <syscalls+0x250>
    80003a5e:	00002097          	auipc	ra,0x2
    80003a62:	2bc080e7          	jalr	700(ra) # 80005d1a <panic>

0000000080003a66 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a66:	7139                	addi	sp,sp,-64
    80003a68:	fc06                	sd	ra,56(sp)
    80003a6a:	f822                	sd	s0,48(sp)
    80003a6c:	f426                	sd	s1,40(sp)
    80003a6e:	f04a                	sd	s2,32(sp)
    80003a70:	ec4e                	sd	s3,24(sp)
    80003a72:	e852                	sd	s4,16(sp)
    80003a74:	e456                	sd	s5,8(sp)
    80003a76:	0080                	addi	s0,sp,64
    80003a78:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a7a:	00015517          	auipc	a0,0x15
    80003a7e:	5ce50513          	addi	a0,a0,1486 # 80019048 <ftable>
    80003a82:	00002097          	auipc	ra,0x2
    80003a86:	7a6080e7          	jalr	1958(ra) # 80006228 <acquire>
  if(f->ref < 1)
    80003a8a:	40dc                	lw	a5,4(s1)
    80003a8c:	06f05163          	blez	a5,80003aee <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a90:	37fd                	addiw	a5,a5,-1
    80003a92:	0007871b          	sext.w	a4,a5
    80003a96:	c0dc                	sw	a5,4(s1)
    80003a98:	06e04363          	bgtz	a4,80003afe <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a9c:	0004a903          	lw	s2,0(s1)
    80003aa0:	0094ca83          	lbu	s5,9(s1)
    80003aa4:	0104ba03          	ld	s4,16(s1)
    80003aa8:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003aac:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ab0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ab4:	00015517          	auipc	a0,0x15
    80003ab8:	59450513          	addi	a0,a0,1428 # 80019048 <ftable>
    80003abc:	00003097          	auipc	ra,0x3
    80003ac0:	820080e7          	jalr	-2016(ra) # 800062dc <release>

  if(ff.type == FD_PIPE){
    80003ac4:	4785                	li	a5,1
    80003ac6:	04f90d63          	beq	s2,a5,80003b20 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003aca:	3979                	addiw	s2,s2,-2
    80003acc:	4785                	li	a5,1
    80003ace:	0527e063          	bltu	a5,s2,80003b0e <fileclose+0xa8>
    begin_op();
    80003ad2:	00000097          	auipc	ra,0x0
    80003ad6:	acc080e7          	jalr	-1332(ra) # 8000359e <begin_op>
    iput(ff.ip);
    80003ada:	854e                	mv	a0,s3
    80003adc:	fffff097          	auipc	ra,0xfffff
    80003ae0:	2b0080e7          	jalr	688(ra) # 80002d8c <iput>
    end_op();
    80003ae4:	00000097          	auipc	ra,0x0
    80003ae8:	b38080e7          	jalr	-1224(ra) # 8000361c <end_op>
    80003aec:	a00d                	j	80003b0e <fileclose+0xa8>
    panic("fileclose");
    80003aee:	00005517          	auipc	a0,0x5
    80003af2:	b3a50513          	addi	a0,a0,-1222 # 80008628 <syscalls+0x258>
    80003af6:	00002097          	auipc	ra,0x2
    80003afa:	224080e7          	jalr	548(ra) # 80005d1a <panic>
    release(&ftable.lock);
    80003afe:	00015517          	auipc	a0,0x15
    80003b02:	54a50513          	addi	a0,a0,1354 # 80019048 <ftable>
    80003b06:	00002097          	auipc	ra,0x2
    80003b0a:	7d6080e7          	jalr	2006(ra) # 800062dc <release>
  }
}
    80003b0e:	70e2                	ld	ra,56(sp)
    80003b10:	7442                	ld	s0,48(sp)
    80003b12:	74a2                	ld	s1,40(sp)
    80003b14:	7902                	ld	s2,32(sp)
    80003b16:	69e2                	ld	s3,24(sp)
    80003b18:	6a42                	ld	s4,16(sp)
    80003b1a:	6aa2                	ld	s5,8(sp)
    80003b1c:	6121                	addi	sp,sp,64
    80003b1e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b20:	85d6                	mv	a1,s5
    80003b22:	8552                	mv	a0,s4
    80003b24:	00000097          	auipc	ra,0x0
    80003b28:	34c080e7          	jalr	844(ra) # 80003e70 <pipeclose>
    80003b2c:	b7cd                	j	80003b0e <fileclose+0xa8>

0000000080003b2e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b2e:	715d                	addi	sp,sp,-80
    80003b30:	e486                	sd	ra,72(sp)
    80003b32:	e0a2                	sd	s0,64(sp)
    80003b34:	fc26                	sd	s1,56(sp)
    80003b36:	f84a                	sd	s2,48(sp)
    80003b38:	f44e                	sd	s3,40(sp)
    80003b3a:	0880                	addi	s0,sp,80
    80003b3c:	84aa                	mv	s1,a0
    80003b3e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b40:	ffffd097          	auipc	ra,0xffffd
    80003b44:	314080e7          	jalr	788(ra) # 80000e54 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b48:	409c                	lw	a5,0(s1)
    80003b4a:	37f9                	addiw	a5,a5,-2
    80003b4c:	4705                	li	a4,1
    80003b4e:	04f76763          	bltu	a4,a5,80003b9c <filestat+0x6e>
    80003b52:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b54:	6c88                	ld	a0,24(s1)
    80003b56:	fffff097          	auipc	ra,0xfffff
    80003b5a:	07c080e7          	jalr	124(ra) # 80002bd2 <ilock>
    stati(f->ip, &st);
    80003b5e:	fb840593          	addi	a1,s0,-72
    80003b62:	6c88                	ld	a0,24(s1)
    80003b64:	fffff097          	auipc	ra,0xfffff
    80003b68:	2f8080e7          	jalr	760(ra) # 80002e5c <stati>
    iunlock(f->ip);
    80003b6c:	6c88                	ld	a0,24(s1)
    80003b6e:	fffff097          	auipc	ra,0xfffff
    80003b72:	126080e7          	jalr	294(ra) # 80002c94 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b76:	46e1                	li	a3,24
    80003b78:	fb840613          	addi	a2,s0,-72
    80003b7c:	85ce                	mv	a1,s3
    80003b7e:	05093503          	ld	a0,80(s2)
    80003b82:	ffffd097          	auipc	ra,0xffffd
    80003b86:	f92080e7          	jalr	-110(ra) # 80000b14 <copyout>
    80003b8a:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b8e:	60a6                	ld	ra,72(sp)
    80003b90:	6406                	ld	s0,64(sp)
    80003b92:	74e2                	ld	s1,56(sp)
    80003b94:	7942                	ld	s2,48(sp)
    80003b96:	79a2                	ld	s3,40(sp)
    80003b98:	6161                	addi	sp,sp,80
    80003b9a:	8082                	ret
  return -1;
    80003b9c:	557d                	li	a0,-1
    80003b9e:	bfc5                	j	80003b8e <filestat+0x60>

0000000080003ba0 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003ba0:	7179                	addi	sp,sp,-48
    80003ba2:	f406                	sd	ra,40(sp)
    80003ba4:	f022                	sd	s0,32(sp)
    80003ba6:	ec26                	sd	s1,24(sp)
    80003ba8:	e84a                	sd	s2,16(sp)
    80003baa:	e44e                	sd	s3,8(sp)
    80003bac:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bae:	00854783          	lbu	a5,8(a0)
    80003bb2:	c3d5                	beqz	a5,80003c56 <fileread+0xb6>
    80003bb4:	84aa                	mv	s1,a0
    80003bb6:	89ae                	mv	s3,a1
    80003bb8:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bba:	411c                	lw	a5,0(a0)
    80003bbc:	4705                	li	a4,1
    80003bbe:	04e78963          	beq	a5,a4,80003c10 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bc2:	470d                	li	a4,3
    80003bc4:	04e78d63          	beq	a5,a4,80003c1e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bc8:	4709                	li	a4,2
    80003bca:	06e79e63          	bne	a5,a4,80003c46 <fileread+0xa6>
    ilock(f->ip);
    80003bce:	6d08                	ld	a0,24(a0)
    80003bd0:	fffff097          	auipc	ra,0xfffff
    80003bd4:	002080e7          	jalr	2(ra) # 80002bd2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bd8:	874a                	mv	a4,s2
    80003bda:	5094                	lw	a3,32(s1)
    80003bdc:	864e                	mv	a2,s3
    80003bde:	4585                	li	a1,1
    80003be0:	6c88                	ld	a0,24(s1)
    80003be2:	fffff097          	auipc	ra,0xfffff
    80003be6:	2a4080e7          	jalr	676(ra) # 80002e86 <readi>
    80003bea:	892a                	mv	s2,a0
    80003bec:	00a05563          	blez	a0,80003bf6 <fileread+0x56>
      f->off += r;
    80003bf0:	509c                	lw	a5,32(s1)
    80003bf2:	9fa9                	addw	a5,a5,a0
    80003bf4:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003bf6:	6c88                	ld	a0,24(s1)
    80003bf8:	fffff097          	auipc	ra,0xfffff
    80003bfc:	09c080e7          	jalr	156(ra) # 80002c94 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c00:	854a                	mv	a0,s2
    80003c02:	70a2                	ld	ra,40(sp)
    80003c04:	7402                	ld	s0,32(sp)
    80003c06:	64e2                	ld	s1,24(sp)
    80003c08:	6942                	ld	s2,16(sp)
    80003c0a:	69a2                	ld	s3,8(sp)
    80003c0c:	6145                	addi	sp,sp,48
    80003c0e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c10:	6908                	ld	a0,16(a0)
    80003c12:	00000097          	auipc	ra,0x0
    80003c16:	3c6080e7          	jalr	966(ra) # 80003fd8 <piperead>
    80003c1a:	892a                	mv	s2,a0
    80003c1c:	b7d5                	j	80003c00 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c1e:	02451783          	lh	a5,36(a0)
    80003c22:	03079693          	slli	a3,a5,0x30
    80003c26:	92c1                	srli	a3,a3,0x30
    80003c28:	4725                	li	a4,9
    80003c2a:	02d76863          	bltu	a4,a3,80003c5a <fileread+0xba>
    80003c2e:	0792                	slli	a5,a5,0x4
    80003c30:	00015717          	auipc	a4,0x15
    80003c34:	37870713          	addi	a4,a4,888 # 80018fa8 <devsw>
    80003c38:	97ba                	add	a5,a5,a4
    80003c3a:	639c                	ld	a5,0(a5)
    80003c3c:	c38d                	beqz	a5,80003c5e <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c3e:	4505                	li	a0,1
    80003c40:	9782                	jalr	a5
    80003c42:	892a                	mv	s2,a0
    80003c44:	bf75                	j	80003c00 <fileread+0x60>
    panic("fileread");
    80003c46:	00005517          	auipc	a0,0x5
    80003c4a:	9f250513          	addi	a0,a0,-1550 # 80008638 <syscalls+0x268>
    80003c4e:	00002097          	auipc	ra,0x2
    80003c52:	0cc080e7          	jalr	204(ra) # 80005d1a <panic>
    return -1;
    80003c56:	597d                	li	s2,-1
    80003c58:	b765                	j	80003c00 <fileread+0x60>
      return -1;
    80003c5a:	597d                	li	s2,-1
    80003c5c:	b755                	j	80003c00 <fileread+0x60>
    80003c5e:	597d                	li	s2,-1
    80003c60:	b745                	j	80003c00 <fileread+0x60>

0000000080003c62 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c62:	715d                	addi	sp,sp,-80
    80003c64:	e486                	sd	ra,72(sp)
    80003c66:	e0a2                	sd	s0,64(sp)
    80003c68:	fc26                	sd	s1,56(sp)
    80003c6a:	f84a                	sd	s2,48(sp)
    80003c6c:	f44e                	sd	s3,40(sp)
    80003c6e:	f052                	sd	s4,32(sp)
    80003c70:	ec56                	sd	s5,24(sp)
    80003c72:	e85a                	sd	s6,16(sp)
    80003c74:	e45e                	sd	s7,8(sp)
    80003c76:	e062                	sd	s8,0(sp)
    80003c78:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c7a:	00954783          	lbu	a5,9(a0)
    80003c7e:	10078663          	beqz	a5,80003d8a <filewrite+0x128>
    80003c82:	892a                	mv	s2,a0
    80003c84:	8b2e                	mv	s6,a1
    80003c86:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c88:	411c                	lw	a5,0(a0)
    80003c8a:	4705                	li	a4,1
    80003c8c:	02e78263          	beq	a5,a4,80003cb0 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c90:	470d                	li	a4,3
    80003c92:	02e78663          	beq	a5,a4,80003cbe <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c96:	4709                	li	a4,2
    80003c98:	0ee79163          	bne	a5,a4,80003d7a <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c9c:	0ac05d63          	blez	a2,80003d56 <filewrite+0xf4>
    int i = 0;
    80003ca0:	4981                	li	s3,0
    80003ca2:	6b85                	lui	s7,0x1
    80003ca4:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003ca8:	6c05                	lui	s8,0x1
    80003caa:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003cae:	a861                	j	80003d46 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003cb0:	6908                	ld	a0,16(a0)
    80003cb2:	00000097          	auipc	ra,0x0
    80003cb6:	22e080e7          	jalr	558(ra) # 80003ee0 <pipewrite>
    80003cba:	8a2a                	mv	s4,a0
    80003cbc:	a045                	j	80003d5c <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cbe:	02451783          	lh	a5,36(a0)
    80003cc2:	03079693          	slli	a3,a5,0x30
    80003cc6:	92c1                	srli	a3,a3,0x30
    80003cc8:	4725                	li	a4,9
    80003cca:	0cd76263          	bltu	a4,a3,80003d8e <filewrite+0x12c>
    80003cce:	0792                	slli	a5,a5,0x4
    80003cd0:	00015717          	auipc	a4,0x15
    80003cd4:	2d870713          	addi	a4,a4,728 # 80018fa8 <devsw>
    80003cd8:	97ba                	add	a5,a5,a4
    80003cda:	679c                	ld	a5,8(a5)
    80003cdc:	cbdd                	beqz	a5,80003d92 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003cde:	4505                	li	a0,1
    80003ce0:	9782                	jalr	a5
    80003ce2:	8a2a                	mv	s4,a0
    80003ce4:	a8a5                	j	80003d5c <filewrite+0xfa>
    80003ce6:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003cea:	00000097          	auipc	ra,0x0
    80003cee:	8b4080e7          	jalr	-1868(ra) # 8000359e <begin_op>
      ilock(f->ip);
    80003cf2:	01893503          	ld	a0,24(s2)
    80003cf6:	fffff097          	auipc	ra,0xfffff
    80003cfa:	edc080e7          	jalr	-292(ra) # 80002bd2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003cfe:	8756                	mv	a4,s5
    80003d00:	02092683          	lw	a3,32(s2)
    80003d04:	01698633          	add	a2,s3,s6
    80003d08:	4585                	li	a1,1
    80003d0a:	01893503          	ld	a0,24(s2)
    80003d0e:	fffff097          	auipc	ra,0xfffff
    80003d12:	270080e7          	jalr	624(ra) # 80002f7e <writei>
    80003d16:	84aa                	mv	s1,a0
    80003d18:	00a05763          	blez	a0,80003d26 <filewrite+0xc4>
        f->off += r;
    80003d1c:	02092783          	lw	a5,32(s2)
    80003d20:	9fa9                	addw	a5,a5,a0
    80003d22:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d26:	01893503          	ld	a0,24(s2)
    80003d2a:	fffff097          	auipc	ra,0xfffff
    80003d2e:	f6a080e7          	jalr	-150(ra) # 80002c94 <iunlock>
      end_op();
    80003d32:	00000097          	auipc	ra,0x0
    80003d36:	8ea080e7          	jalr	-1814(ra) # 8000361c <end_op>

      if(r != n1){
    80003d3a:	009a9f63          	bne	s5,s1,80003d58 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d3e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d42:	0149db63          	bge	s3,s4,80003d58 <filewrite+0xf6>
      int n1 = n - i;
    80003d46:	413a04bb          	subw	s1,s4,s3
    80003d4a:	0004879b          	sext.w	a5,s1
    80003d4e:	f8fbdce3          	bge	s7,a5,80003ce6 <filewrite+0x84>
    80003d52:	84e2                	mv	s1,s8
    80003d54:	bf49                	j	80003ce6 <filewrite+0x84>
    int i = 0;
    80003d56:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d58:	013a1f63          	bne	s4,s3,80003d76 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d5c:	8552                	mv	a0,s4
    80003d5e:	60a6                	ld	ra,72(sp)
    80003d60:	6406                	ld	s0,64(sp)
    80003d62:	74e2                	ld	s1,56(sp)
    80003d64:	7942                	ld	s2,48(sp)
    80003d66:	79a2                	ld	s3,40(sp)
    80003d68:	7a02                	ld	s4,32(sp)
    80003d6a:	6ae2                	ld	s5,24(sp)
    80003d6c:	6b42                	ld	s6,16(sp)
    80003d6e:	6ba2                	ld	s7,8(sp)
    80003d70:	6c02                	ld	s8,0(sp)
    80003d72:	6161                	addi	sp,sp,80
    80003d74:	8082                	ret
    ret = (i == n ? n : -1);
    80003d76:	5a7d                	li	s4,-1
    80003d78:	b7d5                	j	80003d5c <filewrite+0xfa>
    panic("filewrite");
    80003d7a:	00005517          	auipc	a0,0x5
    80003d7e:	8ce50513          	addi	a0,a0,-1842 # 80008648 <syscalls+0x278>
    80003d82:	00002097          	auipc	ra,0x2
    80003d86:	f98080e7          	jalr	-104(ra) # 80005d1a <panic>
    return -1;
    80003d8a:	5a7d                	li	s4,-1
    80003d8c:	bfc1                	j	80003d5c <filewrite+0xfa>
      return -1;
    80003d8e:	5a7d                	li	s4,-1
    80003d90:	b7f1                	j	80003d5c <filewrite+0xfa>
    80003d92:	5a7d                	li	s4,-1
    80003d94:	b7e1                	j	80003d5c <filewrite+0xfa>

0000000080003d96 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d96:	7179                	addi	sp,sp,-48
    80003d98:	f406                	sd	ra,40(sp)
    80003d9a:	f022                	sd	s0,32(sp)
    80003d9c:	ec26                	sd	s1,24(sp)
    80003d9e:	e84a                	sd	s2,16(sp)
    80003da0:	e44e                	sd	s3,8(sp)
    80003da2:	e052                	sd	s4,0(sp)
    80003da4:	1800                	addi	s0,sp,48
    80003da6:	84aa                	mv	s1,a0
    80003da8:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003daa:	0005b023          	sd	zero,0(a1)
    80003dae:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003db2:	00000097          	auipc	ra,0x0
    80003db6:	bf8080e7          	jalr	-1032(ra) # 800039aa <filealloc>
    80003dba:	e088                	sd	a0,0(s1)
    80003dbc:	c551                	beqz	a0,80003e48 <pipealloc+0xb2>
    80003dbe:	00000097          	auipc	ra,0x0
    80003dc2:	bec080e7          	jalr	-1044(ra) # 800039aa <filealloc>
    80003dc6:	00aa3023          	sd	a0,0(s4)
    80003dca:	c92d                	beqz	a0,80003e3c <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003dcc:	ffffc097          	auipc	ra,0xffffc
    80003dd0:	34e080e7          	jalr	846(ra) # 8000011a <kalloc>
    80003dd4:	892a                	mv	s2,a0
    80003dd6:	c125                	beqz	a0,80003e36 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003dd8:	4985                	li	s3,1
    80003dda:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003dde:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003de2:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003de6:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003dea:	00005597          	auipc	a1,0x5
    80003dee:	86e58593          	addi	a1,a1,-1938 # 80008658 <syscalls+0x288>
    80003df2:	00002097          	auipc	ra,0x2
    80003df6:	3a6080e7          	jalr	934(ra) # 80006198 <initlock>
  (*f0)->type = FD_PIPE;
    80003dfa:	609c                	ld	a5,0(s1)
    80003dfc:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e00:	609c                	ld	a5,0(s1)
    80003e02:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e06:	609c                	ld	a5,0(s1)
    80003e08:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e0c:	609c                	ld	a5,0(s1)
    80003e0e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e12:	000a3783          	ld	a5,0(s4)
    80003e16:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e1a:	000a3783          	ld	a5,0(s4)
    80003e1e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e22:	000a3783          	ld	a5,0(s4)
    80003e26:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e2a:	000a3783          	ld	a5,0(s4)
    80003e2e:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e32:	4501                	li	a0,0
    80003e34:	a025                	j	80003e5c <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e36:	6088                	ld	a0,0(s1)
    80003e38:	e501                	bnez	a0,80003e40 <pipealloc+0xaa>
    80003e3a:	a039                	j	80003e48 <pipealloc+0xb2>
    80003e3c:	6088                	ld	a0,0(s1)
    80003e3e:	c51d                	beqz	a0,80003e6c <pipealloc+0xd6>
    fileclose(*f0);
    80003e40:	00000097          	auipc	ra,0x0
    80003e44:	c26080e7          	jalr	-986(ra) # 80003a66 <fileclose>
  if(*f1)
    80003e48:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e4c:	557d                	li	a0,-1
  if(*f1)
    80003e4e:	c799                	beqz	a5,80003e5c <pipealloc+0xc6>
    fileclose(*f1);
    80003e50:	853e                	mv	a0,a5
    80003e52:	00000097          	auipc	ra,0x0
    80003e56:	c14080e7          	jalr	-1004(ra) # 80003a66 <fileclose>
  return -1;
    80003e5a:	557d                	li	a0,-1
}
    80003e5c:	70a2                	ld	ra,40(sp)
    80003e5e:	7402                	ld	s0,32(sp)
    80003e60:	64e2                	ld	s1,24(sp)
    80003e62:	6942                	ld	s2,16(sp)
    80003e64:	69a2                	ld	s3,8(sp)
    80003e66:	6a02                	ld	s4,0(sp)
    80003e68:	6145                	addi	sp,sp,48
    80003e6a:	8082                	ret
  return -1;
    80003e6c:	557d                	li	a0,-1
    80003e6e:	b7fd                	j	80003e5c <pipealloc+0xc6>

0000000080003e70 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e70:	1101                	addi	sp,sp,-32
    80003e72:	ec06                	sd	ra,24(sp)
    80003e74:	e822                	sd	s0,16(sp)
    80003e76:	e426                	sd	s1,8(sp)
    80003e78:	e04a                	sd	s2,0(sp)
    80003e7a:	1000                	addi	s0,sp,32
    80003e7c:	84aa                	mv	s1,a0
    80003e7e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e80:	00002097          	auipc	ra,0x2
    80003e84:	3a8080e7          	jalr	936(ra) # 80006228 <acquire>
  if(writable){
    80003e88:	02090d63          	beqz	s2,80003ec2 <pipeclose+0x52>
    pi->writeopen = 0;
    80003e8c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e90:	21848513          	addi	a0,s1,536
    80003e94:	ffffd097          	auipc	ra,0xffffd
    80003e98:	6d8080e7          	jalr	1752(ra) # 8000156c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e9c:	2204b783          	ld	a5,544(s1)
    80003ea0:	eb95                	bnez	a5,80003ed4 <pipeclose+0x64>
    release(&pi->lock);
    80003ea2:	8526                	mv	a0,s1
    80003ea4:	00002097          	auipc	ra,0x2
    80003ea8:	438080e7          	jalr	1080(ra) # 800062dc <release>
    kfree((char*)pi);
    80003eac:	8526                	mv	a0,s1
    80003eae:	ffffc097          	auipc	ra,0xffffc
    80003eb2:	16e080e7          	jalr	366(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003eb6:	60e2                	ld	ra,24(sp)
    80003eb8:	6442                	ld	s0,16(sp)
    80003eba:	64a2                	ld	s1,8(sp)
    80003ebc:	6902                	ld	s2,0(sp)
    80003ebe:	6105                	addi	sp,sp,32
    80003ec0:	8082                	ret
    pi->readopen = 0;
    80003ec2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ec6:	21c48513          	addi	a0,s1,540
    80003eca:	ffffd097          	auipc	ra,0xffffd
    80003ece:	6a2080e7          	jalr	1698(ra) # 8000156c <wakeup>
    80003ed2:	b7e9                	j	80003e9c <pipeclose+0x2c>
    release(&pi->lock);
    80003ed4:	8526                	mv	a0,s1
    80003ed6:	00002097          	auipc	ra,0x2
    80003eda:	406080e7          	jalr	1030(ra) # 800062dc <release>
}
    80003ede:	bfe1                	j	80003eb6 <pipeclose+0x46>

0000000080003ee0 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003ee0:	711d                	addi	sp,sp,-96
    80003ee2:	ec86                	sd	ra,88(sp)
    80003ee4:	e8a2                	sd	s0,80(sp)
    80003ee6:	e4a6                	sd	s1,72(sp)
    80003ee8:	e0ca                	sd	s2,64(sp)
    80003eea:	fc4e                	sd	s3,56(sp)
    80003eec:	f852                	sd	s4,48(sp)
    80003eee:	f456                	sd	s5,40(sp)
    80003ef0:	f05a                	sd	s6,32(sp)
    80003ef2:	ec5e                	sd	s7,24(sp)
    80003ef4:	e862                	sd	s8,16(sp)
    80003ef6:	1080                	addi	s0,sp,96
    80003ef8:	84aa                	mv	s1,a0
    80003efa:	8aae                	mv	s5,a1
    80003efc:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003efe:	ffffd097          	auipc	ra,0xffffd
    80003f02:	f56080e7          	jalr	-170(ra) # 80000e54 <myproc>
    80003f06:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f08:	8526                	mv	a0,s1
    80003f0a:	00002097          	auipc	ra,0x2
    80003f0e:	31e080e7          	jalr	798(ra) # 80006228 <acquire>
  while(i < n){
    80003f12:	0b405663          	blez	s4,80003fbe <pipewrite+0xde>
  int i = 0;
    80003f16:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f18:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f1a:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f1e:	21c48b93          	addi	s7,s1,540
    80003f22:	a089                	j	80003f64 <pipewrite+0x84>
      release(&pi->lock);
    80003f24:	8526                	mv	a0,s1
    80003f26:	00002097          	auipc	ra,0x2
    80003f2a:	3b6080e7          	jalr	950(ra) # 800062dc <release>
      return -1;
    80003f2e:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f30:	854a                	mv	a0,s2
    80003f32:	60e6                	ld	ra,88(sp)
    80003f34:	6446                	ld	s0,80(sp)
    80003f36:	64a6                	ld	s1,72(sp)
    80003f38:	6906                	ld	s2,64(sp)
    80003f3a:	79e2                	ld	s3,56(sp)
    80003f3c:	7a42                	ld	s4,48(sp)
    80003f3e:	7aa2                	ld	s5,40(sp)
    80003f40:	7b02                	ld	s6,32(sp)
    80003f42:	6be2                	ld	s7,24(sp)
    80003f44:	6c42                	ld	s8,16(sp)
    80003f46:	6125                	addi	sp,sp,96
    80003f48:	8082                	ret
      wakeup(&pi->nread);
    80003f4a:	8562                	mv	a0,s8
    80003f4c:	ffffd097          	auipc	ra,0xffffd
    80003f50:	620080e7          	jalr	1568(ra) # 8000156c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f54:	85a6                	mv	a1,s1
    80003f56:	855e                	mv	a0,s7
    80003f58:	ffffd097          	auipc	ra,0xffffd
    80003f5c:	5b0080e7          	jalr	1456(ra) # 80001508 <sleep>
  while(i < n){
    80003f60:	07495063          	bge	s2,s4,80003fc0 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003f64:	2204a783          	lw	a5,544(s1)
    80003f68:	dfd5                	beqz	a5,80003f24 <pipewrite+0x44>
    80003f6a:	854e                	mv	a0,s3
    80003f6c:	ffffe097          	auipc	ra,0xffffe
    80003f70:	844080e7          	jalr	-1980(ra) # 800017b0 <killed>
    80003f74:	f945                	bnez	a0,80003f24 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f76:	2184a783          	lw	a5,536(s1)
    80003f7a:	21c4a703          	lw	a4,540(s1)
    80003f7e:	2007879b          	addiw	a5,a5,512
    80003f82:	fcf704e3          	beq	a4,a5,80003f4a <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f86:	4685                	li	a3,1
    80003f88:	01590633          	add	a2,s2,s5
    80003f8c:	faf40593          	addi	a1,s0,-81
    80003f90:	0509b503          	ld	a0,80(s3)
    80003f94:	ffffd097          	auipc	ra,0xffffd
    80003f98:	c0c080e7          	jalr	-1012(ra) # 80000ba0 <copyin>
    80003f9c:	03650263          	beq	a0,s6,80003fc0 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003fa0:	21c4a783          	lw	a5,540(s1)
    80003fa4:	0017871b          	addiw	a4,a5,1
    80003fa8:	20e4ae23          	sw	a4,540(s1)
    80003fac:	1ff7f793          	andi	a5,a5,511
    80003fb0:	97a6                	add	a5,a5,s1
    80003fb2:	faf44703          	lbu	a4,-81(s0)
    80003fb6:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fba:	2905                	addiw	s2,s2,1
    80003fbc:	b755                	j	80003f60 <pipewrite+0x80>
  int i = 0;
    80003fbe:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003fc0:	21848513          	addi	a0,s1,536
    80003fc4:	ffffd097          	auipc	ra,0xffffd
    80003fc8:	5a8080e7          	jalr	1448(ra) # 8000156c <wakeup>
  release(&pi->lock);
    80003fcc:	8526                	mv	a0,s1
    80003fce:	00002097          	auipc	ra,0x2
    80003fd2:	30e080e7          	jalr	782(ra) # 800062dc <release>
  return i;
    80003fd6:	bfa9                	j	80003f30 <pipewrite+0x50>

0000000080003fd8 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fd8:	715d                	addi	sp,sp,-80
    80003fda:	e486                	sd	ra,72(sp)
    80003fdc:	e0a2                	sd	s0,64(sp)
    80003fde:	fc26                	sd	s1,56(sp)
    80003fe0:	f84a                	sd	s2,48(sp)
    80003fe2:	f44e                	sd	s3,40(sp)
    80003fe4:	f052                	sd	s4,32(sp)
    80003fe6:	ec56                	sd	s5,24(sp)
    80003fe8:	e85a                	sd	s6,16(sp)
    80003fea:	0880                	addi	s0,sp,80
    80003fec:	84aa                	mv	s1,a0
    80003fee:	892e                	mv	s2,a1
    80003ff0:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003ff2:	ffffd097          	auipc	ra,0xffffd
    80003ff6:	e62080e7          	jalr	-414(ra) # 80000e54 <myproc>
    80003ffa:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003ffc:	8526                	mv	a0,s1
    80003ffe:	00002097          	auipc	ra,0x2
    80004002:	22a080e7          	jalr	554(ra) # 80006228 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004006:	2184a703          	lw	a4,536(s1)
    8000400a:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000400e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004012:	02f71763          	bne	a4,a5,80004040 <piperead+0x68>
    80004016:	2244a783          	lw	a5,548(s1)
    8000401a:	c39d                	beqz	a5,80004040 <piperead+0x68>
    if(killed(pr)){
    8000401c:	8552                	mv	a0,s4
    8000401e:	ffffd097          	auipc	ra,0xffffd
    80004022:	792080e7          	jalr	1938(ra) # 800017b0 <killed>
    80004026:	e949                	bnez	a0,800040b8 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004028:	85a6                	mv	a1,s1
    8000402a:	854e                	mv	a0,s3
    8000402c:	ffffd097          	auipc	ra,0xffffd
    80004030:	4dc080e7          	jalr	1244(ra) # 80001508 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004034:	2184a703          	lw	a4,536(s1)
    80004038:	21c4a783          	lw	a5,540(s1)
    8000403c:	fcf70de3          	beq	a4,a5,80004016 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004040:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004042:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004044:	05505463          	blez	s5,8000408c <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004048:	2184a783          	lw	a5,536(s1)
    8000404c:	21c4a703          	lw	a4,540(s1)
    80004050:	02f70e63          	beq	a4,a5,8000408c <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004054:	0017871b          	addiw	a4,a5,1
    80004058:	20e4ac23          	sw	a4,536(s1)
    8000405c:	1ff7f793          	andi	a5,a5,511
    80004060:	97a6                	add	a5,a5,s1
    80004062:	0187c783          	lbu	a5,24(a5)
    80004066:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000406a:	4685                	li	a3,1
    8000406c:	fbf40613          	addi	a2,s0,-65
    80004070:	85ca                	mv	a1,s2
    80004072:	050a3503          	ld	a0,80(s4)
    80004076:	ffffd097          	auipc	ra,0xffffd
    8000407a:	a9e080e7          	jalr	-1378(ra) # 80000b14 <copyout>
    8000407e:	01650763          	beq	a0,s6,8000408c <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004082:	2985                	addiw	s3,s3,1
    80004084:	0905                	addi	s2,s2,1
    80004086:	fd3a91e3          	bne	s5,s3,80004048 <piperead+0x70>
    8000408a:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000408c:	21c48513          	addi	a0,s1,540
    80004090:	ffffd097          	auipc	ra,0xffffd
    80004094:	4dc080e7          	jalr	1244(ra) # 8000156c <wakeup>
  release(&pi->lock);
    80004098:	8526                	mv	a0,s1
    8000409a:	00002097          	auipc	ra,0x2
    8000409e:	242080e7          	jalr	578(ra) # 800062dc <release>
  return i;
}
    800040a2:	854e                	mv	a0,s3
    800040a4:	60a6                	ld	ra,72(sp)
    800040a6:	6406                	ld	s0,64(sp)
    800040a8:	74e2                	ld	s1,56(sp)
    800040aa:	7942                	ld	s2,48(sp)
    800040ac:	79a2                	ld	s3,40(sp)
    800040ae:	7a02                	ld	s4,32(sp)
    800040b0:	6ae2                	ld	s5,24(sp)
    800040b2:	6b42                	ld	s6,16(sp)
    800040b4:	6161                	addi	sp,sp,80
    800040b6:	8082                	ret
      release(&pi->lock);
    800040b8:	8526                	mv	a0,s1
    800040ba:	00002097          	auipc	ra,0x2
    800040be:	222080e7          	jalr	546(ra) # 800062dc <release>
      return -1;
    800040c2:	59fd                	li	s3,-1
    800040c4:	bff9                	j	800040a2 <piperead+0xca>

00000000800040c6 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800040c6:	1141                	addi	sp,sp,-16
    800040c8:	e422                	sd	s0,8(sp)
    800040ca:	0800                	addi	s0,sp,16
    800040cc:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800040ce:	8905                	andi	a0,a0,1
    800040d0:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800040d2:	8b89                	andi	a5,a5,2
    800040d4:	c399                	beqz	a5,800040da <flags2perm+0x14>
      perm |= PTE_W;
    800040d6:	00456513          	ori	a0,a0,4
    return perm;
}
    800040da:	6422                	ld	s0,8(sp)
    800040dc:	0141                	addi	sp,sp,16
    800040de:	8082                	ret

00000000800040e0 <exec>:

int
exec(char *path, char **argv)
{
    800040e0:	de010113          	addi	sp,sp,-544
    800040e4:	20113c23          	sd	ra,536(sp)
    800040e8:	20813823          	sd	s0,528(sp)
    800040ec:	20913423          	sd	s1,520(sp)
    800040f0:	21213023          	sd	s2,512(sp)
    800040f4:	ffce                	sd	s3,504(sp)
    800040f6:	fbd2                	sd	s4,496(sp)
    800040f8:	f7d6                	sd	s5,488(sp)
    800040fa:	f3da                	sd	s6,480(sp)
    800040fc:	efde                	sd	s7,472(sp)
    800040fe:	ebe2                	sd	s8,464(sp)
    80004100:	e7e6                	sd	s9,456(sp)
    80004102:	e3ea                	sd	s10,448(sp)
    80004104:	ff6e                	sd	s11,440(sp)
    80004106:	1400                	addi	s0,sp,544
    80004108:	892a                	mv	s2,a0
    8000410a:	dea43423          	sd	a0,-536(s0)
    8000410e:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004112:	ffffd097          	auipc	ra,0xffffd
    80004116:	d42080e7          	jalr	-702(ra) # 80000e54 <myproc>
    8000411a:	84aa                	mv	s1,a0

  begin_op();
    8000411c:	fffff097          	auipc	ra,0xfffff
    80004120:	482080e7          	jalr	1154(ra) # 8000359e <begin_op>

  if((ip = namei(path)) == 0){
    80004124:	854a                	mv	a0,s2
    80004126:	fffff097          	auipc	ra,0xfffff
    8000412a:	258080e7          	jalr	600(ra) # 8000337e <namei>
    8000412e:	c93d                	beqz	a0,800041a4 <exec+0xc4>
    80004130:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004132:	fffff097          	auipc	ra,0xfffff
    80004136:	aa0080e7          	jalr	-1376(ra) # 80002bd2 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000413a:	04000713          	li	a4,64
    8000413e:	4681                	li	a3,0
    80004140:	e5040613          	addi	a2,s0,-432
    80004144:	4581                	li	a1,0
    80004146:	8556                	mv	a0,s5
    80004148:	fffff097          	auipc	ra,0xfffff
    8000414c:	d3e080e7          	jalr	-706(ra) # 80002e86 <readi>
    80004150:	04000793          	li	a5,64
    80004154:	00f51a63          	bne	a0,a5,80004168 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004158:	e5042703          	lw	a4,-432(s0)
    8000415c:	464c47b7          	lui	a5,0x464c4
    80004160:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004164:	04f70663          	beq	a4,a5,800041b0 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004168:	8556                	mv	a0,s5
    8000416a:	fffff097          	auipc	ra,0xfffff
    8000416e:	cca080e7          	jalr	-822(ra) # 80002e34 <iunlockput>
    end_op();
    80004172:	fffff097          	auipc	ra,0xfffff
    80004176:	4aa080e7          	jalr	1194(ra) # 8000361c <end_op>
  }
  return -1;
    8000417a:	557d                	li	a0,-1
}
    8000417c:	21813083          	ld	ra,536(sp)
    80004180:	21013403          	ld	s0,528(sp)
    80004184:	20813483          	ld	s1,520(sp)
    80004188:	20013903          	ld	s2,512(sp)
    8000418c:	79fe                	ld	s3,504(sp)
    8000418e:	7a5e                	ld	s4,496(sp)
    80004190:	7abe                	ld	s5,488(sp)
    80004192:	7b1e                	ld	s6,480(sp)
    80004194:	6bfe                	ld	s7,472(sp)
    80004196:	6c5e                	ld	s8,464(sp)
    80004198:	6cbe                	ld	s9,456(sp)
    8000419a:	6d1e                	ld	s10,448(sp)
    8000419c:	7dfa                	ld	s11,440(sp)
    8000419e:	22010113          	addi	sp,sp,544
    800041a2:	8082                	ret
    end_op();
    800041a4:	fffff097          	auipc	ra,0xfffff
    800041a8:	478080e7          	jalr	1144(ra) # 8000361c <end_op>
    return -1;
    800041ac:	557d                	li	a0,-1
    800041ae:	b7f9                	j	8000417c <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800041b0:	8526                	mv	a0,s1
    800041b2:	ffffd097          	auipc	ra,0xffffd
    800041b6:	d66080e7          	jalr	-666(ra) # 80000f18 <proc_pagetable>
    800041ba:	8b2a                	mv	s6,a0
    800041bc:	d555                	beqz	a0,80004168 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041be:	e7042783          	lw	a5,-400(s0)
    800041c2:	e8845703          	lhu	a4,-376(s0)
    800041c6:	c735                	beqz	a4,80004232 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041c8:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041ca:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    800041ce:	6a05                	lui	s4,0x1
    800041d0:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800041d4:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800041d8:	6d85                	lui	s11,0x1
    800041da:	7d7d                	lui	s10,0xfffff
    800041dc:	ac3d                	j	8000441a <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041de:	00004517          	auipc	a0,0x4
    800041e2:	48250513          	addi	a0,a0,1154 # 80008660 <syscalls+0x290>
    800041e6:	00002097          	auipc	ra,0x2
    800041ea:	b34080e7          	jalr	-1228(ra) # 80005d1a <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041ee:	874a                	mv	a4,s2
    800041f0:	009c86bb          	addw	a3,s9,s1
    800041f4:	4581                	li	a1,0
    800041f6:	8556                	mv	a0,s5
    800041f8:	fffff097          	auipc	ra,0xfffff
    800041fc:	c8e080e7          	jalr	-882(ra) # 80002e86 <readi>
    80004200:	2501                	sext.w	a0,a0
    80004202:	1aa91963          	bne	s2,a0,800043b4 <exec+0x2d4>
  for(i = 0; i < sz; i += PGSIZE){
    80004206:	009d84bb          	addw	s1,s11,s1
    8000420a:	013d09bb          	addw	s3,s10,s3
    8000420e:	1f74f663          	bgeu	s1,s7,800043fa <exec+0x31a>
    pa = walkaddr(pagetable, va + i);
    80004212:	02049593          	slli	a1,s1,0x20
    80004216:	9181                	srli	a1,a1,0x20
    80004218:	95e2                	add	a1,a1,s8
    8000421a:	855a                	mv	a0,s6
    8000421c:	ffffc097          	auipc	ra,0xffffc
    80004220:	2e8080e7          	jalr	744(ra) # 80000504 <walkaddr>
    80004224:	862a                	mv	a2,a0
    if(pa == 0)
    80004226:	dd45                	beqz	a0,800041de <exec+0xfe>
      n = PGSIZE;
    80004228:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000422a:	fd49f2e3          	bgeu	s3,s4,800041ee <exec+0x10e>
      n = sz - i;
    8000422e:	894e                	mv	s2,s3
    80004230:	bf7d                	j	800041ee <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004232:	4901                	li	s2,0
  iunlockput(ip);
    80004234:	8556                	mv	a0,s5
    80004236:	fffff097          	auipc	ra,0xfffff
    8000423a:	bfe080e7          	jalr	-1026(ra) # 80002e34 <iunlockput>
  end_op();
    8000423e:	fffff097          	auipc	ra,0xfffff
    80004242:	3de080e7          	jalr	990(ra) # 8000361c <end_op>
  p = myproc();
    80004246:	ffffd097          	auipc	ra,0xffffd
    8000424a:	c0e080e7          	jalr	-1010(ra) # 80000e54 <myproc>
    8000424e:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004250:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004254:	6785                	lui	a5,0x1
    80004256:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004258:	97ca                	add	a5,a5,s2
    8000425a:	777d                	lui	a4,0xfffff
    8000425c:	8ff9                	and	a5,a5,a4
    8000425e:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004262:	4691                	li	a3,4
    80004264:	6609                	lui	a2,0x2
    80004266:	963e                	add	a2,a2,a5
    80004268:	85be                	mv	a1,a5
    8000426a:	855a                	mv	a0,s6
    8000426c:	ffffc097          	auipc	ra,0xffffc
    80004270:	64c080e7          	jalr	1612(ra) # 800008b8 <uvmalloc>
    80004274:	8c2a                	mv	s8,a0
  ip = 0;
    80004276:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004278:	12050e63          	beqz	a0,800043b4 <exec+0x2d4>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000427c:	75f9                	lui	a1,0xffffe
    8000427e:	95aa                	add	a1,a1,a0
    80004280:	855a                	mv	a0,s6
    80004282:	ffffd097          	auipc	ra,0xffffd
    80004286:	860080e7          	jalr	-1952(ra) # 80000ae2 <uvmclear>
  stackbase = sp - PGSIZE;
    8000428a:	7afd                	lui	s5,0xfffff
    8000428c:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    8000428e:	df043783          	ld	a5,-528(s0)
    80004292:	6388                	ld	a0,0(a5)
    80004294:	c925                	beqz	a0,80004304 <exec+0x224>
    80004296:	e9040993          	addi	s3,s0,-368
    8000429a:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000429e:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800042a0:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800042a2:	ffffc097          	auipc	ra,0xffffc
    800042a6:	054080e7          	jalr	84(ra) # 800002f6 <strlen>
    800042aa:	0015079b          	addiw	a5,a0,1
    800042ae:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042b2:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800042b6:	13596663          	bltu	s2,s5,800043e2 <exec+0x302>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042ba:	df043d83          	ld	s11,-528(s0)
    800042be:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800042c2:	8552                	mv	a0,s4
    800042c4:	ffffc097          	auipc	ra,0xffffc
    800042c8:	032080e7          	jalr	50(ra) # 800002f6 <strlen>
    800042cc:	0015069b          	addiw	a3,a0,1
    800042d0:	8652                	mv	a2,s4
    800042d2:	85ca                	mv	a1,s2
    800042d4:	855a                	mv	a0,s6
    800042d6:	ffffd097          	auipc	ra,0xffffd
    800042da:	83e080e7          	jalr	-1986(ra) # 80000b14 <copyout>
    800042de:	10054663          	bltz	a0,800043ea <exec+0x30a>
    ustack[argc] = sp;
    800042e2:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042e6:	0485                	addi	s1,s1,1
    800042e8:	008d8793          	addi	a5,s11,8
    800042ec:	def43823          	sd	a5,-528(s0)
    800042f0:	008db503          	ld	a0,8(s11)
    800042f4:	c911                	beqz	a0,80004308 <exec+0x228>
    if(argc >= MAXARG)
    800042f6:	09a1                	addi	s3,s3,8
    800042f8:	fb3c95e3          	bne	s9,s3,800042a2 <exec+0x1c2>
  sz = sz1;
    800042fc:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004300:	4a81                	li	s5,0
    80004302:	a84d                	j	800043b4 <exec+0x2d4>
  sp = sz;
    80004304:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004306:	4481                	li	s1,0
  ustack[argc] = 0;
    80004308:	00349793          	slli	a5,s1,0x3
    8000430c:	f9078793          	addi	a5,a5,-112
    80004310:	97a2                	add	a5,a5,s0
    80004312:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004316:	00148693          	addi	a3,s1,1
    8000431a:	068e                	slli	a3,a3,0x3
    8000431c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004320:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004324:	01597663          	bgeu	s2,s5,80004330 <exec+0x250>
  sz = sz1;
    80004328:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000432c:	4a81                	li	s5,0
    8000432e:	a059                	j	800043b4 <exec+0x2d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004330:	e9040613          	addi	a2,s0,-368
    80004334:	85ca                	mv	a1,s2
    80004336:	855a                	mv	a0,s6
    80004338:	ffffc097          	auipc	ra,0xffffc
    8000433c:	7dc080e7          	jalr	2012(ra) # 80000b14 <copyout>
    80004340:	0a054963          	bltz	a0,800043f2 <exec+0x312>
  p->trapframe->a1 = sp;
    80004344:	058bb783          	ld	a5,88(s7)
    80004348:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000434c:	de843783          	ld	a5,-536(s0)
    80004350:	0007c703          	lbu	a4,0(a5)
    80004354:	cf11                	beqz	a4,80004370 <exec+0x290>
    80004356:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004358:	02f00693          	li	a3,47
    8000435c:	a039                	j	8000436a <exec+0x28a>
      last = s+1;
    8000435e:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004362:	0785                	addi	a5,a5,1
    80004364:	fff7c703          	lbu	a4,-1(a5)
    80004368:	c701                	beqz	a4,80004370 <exec+0x290>
    if(*s == '/')
    8000436a:	fed71ce3          	bne	a4,a3,80004362 <exec+0x282>
    8000436e:	bfc5                	j	8000435e <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    80004370:	4641                	li	a2,16
    80004372:	de843583          	ld	a1,-536(s0)
    80004376:	158b8513          	addi	a0,s7,344
    8000437a:	ffffc097          	auipc	ra,0xffffc
    8000437e:	f4a080e7          	jalr	-182(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    80004382:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004386:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    8000438a:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000438e:	058bb783          	ld	a5,88(s7)
    80004392:	e6843703          	ld	a4,-408(s0)
    80004396:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004398:	058bb783          	ld	a5,88(s7)
    8000439c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800043a0:	85ea                	mv	a1,s10
    800043a2:	ffffd097          	auipc	ra,0xffffd
    800043a6:	c12080e7          	jalr	-1006(ra) # 80000fb4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800043aa:	0004851b          	sext.w	a0,s1
    800043ae:	b3f9                	j	8000417c <exec+0x9c>
    800043b0:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    800043b4:	df843583          	ld	a1,-520(s0)
    800043b8:	855a                	mv	a0,s6
    800043ba:	ffffd097          	auipc	ra,0xffffd
    800043be:	bfa080e7          	jalr	-1030(ra) # 80000fb4 <proc_freepagetable>
  if(ip){
    800043c2:	da0a93e3          	bnez	s5,80004168 <exec+0x88>
  return -1;
    800043c6:	557d                	li	a0,-1
    800043c8:	bb55                	j	8000417c <exec+0x9c>
    800043ca:	df243c23          	sd	s2,-520(s0)
    800043ce:	b7dd                	j	800043b4 <exec+0x2d4>
    800043d0:	df243c23          	sd	s2,-520(s0)
    800043d4:	b7c5                	j	800043b4 <exec+0x2d4>
    800043d6:	df243c23          	sd	s2,-520(s0)
    800043da:	bfe9                	j	800043b4 <exec+0x2d4>
    800043dc:	df243c23          	sd	s2,-520(s0)
    800043e0:	bfd1                	j	800043b4 <exec+0x2d4>
  sz = sz1;
    800043e2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043e6:	4a81                	li	s5,0
    800043e8:	b7f1                	j	800043b4 <exec+0x2d4>
  sz = sz1;
    800043ea:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043ee:	4a81                	li	s5,0
    800043f0:	b7d1                	j	800043b4 <exec+0x2d4>
  sz = sz1;
    800043f2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043f6:	4a81                	li	s5,0
    800043f8:	bf75                	j	800043b4 <exec+0x2d4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800043fa:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043fe:	e0843783          	ld	a5,-504(s0)
    80004402:	0017869b          	addiw	a3,a5,1
    80004406:	e0d43423          	sd	a3,-504(s0)
    8000440a:	e0043783          	ld	a5,-512(s0)
    8000440e:	0387879b          	addiw	a5,a5,56
    80004412:	e8845703          	lhu	a4,-376(s0)
    80004416:	e0e6dfe3          	bge	a3,a4,80004234 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000441a:	2781                	sext.w	a5,a5
    8000441c:	e0f43023          	sd	a5,-512(s0)
    80004420:	03800713          	li	a4,56
    80004424:	86be                	mv	a3,a5
    80004426:	e1840613          	addi	a2,s0,-488
    8000442a:	4581                	li	a1,0
    8000442c:	8556                	mv	a0,s5
    8000442e:	fffff097          	auipc	ra,0xfffff
    80004432:	a58080e7          	jalr	-1448(ra) # 80002e86 <readi>
    80004436:	03800793          	li	a5,56
    8000443a:	f6f51be3          	bne	a0,a5,800043b0 <exec+0x2d0>
    if(ph.type != ELF_PROG_LOAD)
    8000443e:	e1842783          	lw	a5,-488(s0)
    80004442:	4705                	li	a4,1
    80004444:	fae79de3          	bne	a5,a4,800043fe <exec+0x31e>
    if(ph.memsz < ph.filesz)
    80004448:	e4043483          	ld	s1,-448(s0)
    8000444c:	e3843783          	ld	a5,-456(s0)
    80004450:	f6f4ede3          	bltu	s1,a5,800043ca <exec+0x2ea>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004454:	e2843783          	ld	a5,-472(s0)
    80004458:	94be                	add	s1,s1,a5
    8000445a:	f6f4ebe3          	bltu	s1,a5,800043d0 <exec+0x2f0>
    if(ph.vaddr % PGSIZE != 0)
    8000445e:	de043703          	ld	a4,-544(s0)
    80004462:	8ff9                	and	a5,a5,a4
    80004464:	fbad                	bnez	a5,800043d6 <exec+0x2f6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004466:	e1c42503          	lw	a0,-484(s0)
    8000446a:	00000097          	auipc	ra,0x0
    8000446e:	c5c080e7          	jalr	-932(ra) # 800040c6 <flags2perm>
    80004472:	86aa                	mv	a3,a0
    80004474:	8626                	mv	a2,s1
    80004476:	85ca                	mv	a1,s2
    80004478:	855a                	mv	a0,s6
    8000447a:	ffffc097          	auipc	ra,0xffffc
    8000447e:	43e080e7          	jalr	1086(ra) # 800008b8 <uvmalloc>
    80004482:	dea43c23          	sd	a0,-520(s0)
    80004486:	d939                	beqz	a0,800043dc <exec+0x2fc>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004488:	e2843c03          	ld	s8,-472(s0)
    8000448c:	e2042c83          	lw	s9,-480(s0)
    80004490:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004494:	f60b83e3          	beqz	s7,800043fa <exec+0x31a>
    80004498:	89de                	mv	s3,s7
    8000449a:	4481                	li	s1,0
    8000449c:	bb9d                	j	80004212 <exec+0x132>

000000008000449e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000449e:	7179                	addi	sp,sp,-48
    800044a0:	f406                	sd	ra,40(sp)
    800044a2:	f022                	sd	s0,32(sp)
    800044a4:	ec26                	sd	s1,24(sp)
    800044a6:	e84a                	sd	s2,16(sp)
    800044a8:	1800                	addi	s0,sp,48
    800044aa:	892e                	mv	s2,a1
    800044ac:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800044ae:	fdc40593          	addi	a1,s0,-36
    800044b2:	ffffe097          	auipc	ra,0xffffe
    800044b6:	b0a080e7          	jalr	-1270(ra) # 80001fbc <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800044ba:	fdc42703          	lw	a4,-36(s0)
    800044be:	47bd                	li	a5,15
    800044c0:	02e7eb63          	bltu	a5,a4,800044f6 <argfd+0x58>
    800044c4:	ffffd097          	auipc	ra,0xffffd
    800044c8:	990080e7          	jalr	-1648(ra) # 80000e54 <myproc>
    800044cc:	fdc42703          	lw	a4,-36(s0)
    800044d0:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffdcc9a>
    800044d4:	078e                	slli	a5,a5,0x3
    800044d6:	953e                	add	a0,a0,a5
    800044d8:	611c                	ld	a5,0(a0)
    800044da:	c385                	beqz	a5,800044fa <argfd+0x5c>
    return -1;
  if(pfd)
    800044dc:	00090463          	beqz	s2,800044e4 <argfd+0x46>
    *pfd = fd;
    800044e0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044e4:	4501                	li	a0,0
  if(pf)
    800044e6:	c091                	beqz	s1,800044ea <argfd+0x4c>
    *pf = f;
    800044e8:	e09c                	sd	a5,0(s1)
}
    800044ea:	70a2                	ld	ra,40(sp)
    800044ec:	7402                	ld	s0,32(sp)
    800044ee:	64e2                	ld	s1,24(sp)
    800044f0:	6942                	ld	s2,16(sp)
    800044f2:	6145                	addi	sp,sp,48
    800044f4:	8082                	ret
    return -1;
    800044f6:	557d                	li	a0,-1
    800044f8:	bfcd                	j	800044ea <argfd+0x4c>
    800044fa:	557d                	li	a0,-1
    800044fc:	b7fd                	j	800044ea <argfd+0x4c>

00000000800044fe <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044fe:	1101                	addi	sp,sp,-32
    80004500:	ec06                	sd	ra,24(sp)
    80004502:	e822                	sd	s0,16(sp)
    80004504:	e426                	sd	s1,8(sp)
    80004506:	1000                	addi	s0,sp,32
    80004508:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000450a:	ffffd097          	auipc	ra,0xffffd
    8000450e:	94a080e7          	jalr	-1718(ra) # 80000e54 <myproc>
    80004512:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004514:	0d050793          	addi	a5,a0,208
    80004518:	4501                	li	a0,0
    8000451a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000451c:	6398                	ld	a4,0(a5)
    8000451e:	cb19                	beqz	a4,80004534 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004520:	2505                	addiw	a0,a0,1
    80004522:	07a1                	addi	a5,a5,8
    80004524:	fed51ce3          	bne	a0,a3,8000451c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004528:	557d                	li	a0,-1
}
    8000452a:	60e2                	ld	ra,24(sp)
    8000452c:	6442                	ld	s0,16(sp)
    8000452e:	64a2                	ld	s1,8(sp)
    80004530:	6105                	addi	sp,sp,32
    80004532:	8082                	ret
      p->ofile[fd] = f;
    80004534:	01a50793          	addi	a5,a0,26
    80004538:	078e                	slli	a5,a5,0x3
    8000453a:	963e                	add	a2,a2,a5
    8000453c:	e204                	sd	s1,0(a2)
      return fd;
    8000453e:	b7f5                	j	8000452a <fdalloc+0x2c>

0000000080004540 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004540:	715d                	addi	sp,sp,-80
    80004542:	e486                	sd	ra,72(sp)
    80004544:	e0a2                	sd	s0,64(sp)
    80004546:	fc26                	sd	s1,56(sp)
    80004548:	f84a                	sd	s2,48(sp)
    8000454a:	f44e                	sd	s3,40(sp)
    8000454c:	f052                	sd	s4,32(sp)
    8000454e:	ec56                	sd	s5,24(sp)
    80004550:	e85a                	sd	s6,16(sp)
    80004552:	0880                	addi	s0,sp,80
    80004554:	8b2e                	mv	s6,a1
    80004556:	89b2                	mv	s3,a2
    80004558:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000455a:	fb040593          	addi	a1,s0,-80
    8000455e:	fffff097          	auipc	ra,0xfffff
    80004562:	e3e080e7          	jalr	-450(ra) # 8000339c <nameiparent>
    80004566:	84aa                	mv	s1,a0
    80004568:	14050f63          	beqz	a0,800046c6 <create+0x186>
    return 0;

  ilock(dp);
    8000456c:	ffffe097          	auipc	ra,0xffffe
    80004570:	666080e7          	jalr	1638(ra) # 80002bd2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004574:	4601                	li	a2,0
    80004576:	fb040593          	addi	a1,s0,-80
    8000457a:	8526                	mv	a0,s1
    8000457c:	fffff097          	auipc	ra,0xfffff
    80004580:	b3a080e7          	jalr	-1222(ra) # 800030b6 <dirlookup>
    80004584:	8aaa                	mv	s5,a0
    80004586:	c931                	beqz	a0,800045da <create+0x9a>
    iunlockput(dp);
    80004588:	8526                	mv	a0,s1
    8000458a:	fffff097          	auipc	ra,0xfffff
    8000458e:	8aa080e7          	jalr	-1878(ra) # 80002e34 <iunlockput>
    ilock(ip);
    80004592:	8556                	mv	a0,s5
    80004594:	ffffe097          	auipc	ra,0xffffe
    80004598:	63e080e7          	jalr	1598(ra) # 80002bd2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000459c:	000b059b          	sext.w	a1,s6
    800045a0:	4789                	li	a5,2
    800045a2:	02f59563          	bne	a1,a5,800045cc <create+0x8c>
    800045a6:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdccc4>
    800045aa:	37f9                	addiw	a5,a5,-2
    800045ac:	17c2                	slli	a5,a5,0x30
    800045ae:	93c1                	srli	a5,a5,0x30
    800045b0:	4705                	li	a4,1
    800045b2:	00f76d63          	bltu	a4,a5,800045cc <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800045b6:	8556                	mv	a0,s5
    800045b8:	60a6                	ld	ra,72(sp)
    800045ba:	6406                	ld	s0,64(sp)
    800045bc:	74e2                	ld	s1,56(sp)
    800045be:	7942                	ld	s2,48(sp)
    800045c0:	79a2                	ld	s3,40(sp)
    800045c2:	7a02                	ld	s4,32(sp)
    800045c4:	6ae2                	ld	s5,24(sp)
    800045c6:	6b42                	ld	s6,16(sp)
    800045c8:	6161                	addi	sp,sp,80
    800045ca:	8082                	ret
    iunlockput(ip);
    800045cc:	8556                	mv	a0,s5
    800045ce:	fffff097          	auipc	ra,0xfffff
    800045d2:	866080e7          	jalr	-1946(ra) # 80002e34 <iunlockput>
    return 0;
    800045d6:	4a81                	li	s5,0
    800045d8:	bff9                	j	800045b6 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800045da:	85da                	mv	a1,s6
    800045dc:	4088                	lw	a0,0(s1)
    800045de:	ffffe097          	auipc	ra,0xffffe
    800045e2:	456080e7          	jalr	1110(ra) # 80002a34 <ialloc>
    800045e6:	8a2a                	mv	s4,a0
    800045e8:	c539                	beqz	a0,80004636 <create+0xf6>
  ilock(ip);
    800045ea:	ffffe097          	auipc	ra,0xffffe
    800045ee:	5e8080e7          	jalr	1512(ra) # 80002bd2 <ilock>
  ip->major = major;
    800045f2:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800045f6:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800045fa:	4905                	li	s2,1
    800045fc:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004600:	8552                	mv	a0,s4
    80004602:	ffffe097          	auipc	ra,0xffffe
    80004606:	504080e7          	jalr	1284(ra) # 80002b06 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000460a:	000b059b          	sext.w	a1,s6
    8000460e:	03258b63          	beq	a1,s2,80004644 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    80004612:	004a2603          	lw	a2,4(s4)
    80004616:	fb040593          	addi	a1,s0,-80
    8000461a:	8526                	mv	a0,s1
    8000461c:	fffff097          	auipc	ra,0xfffff
    80004620:	cb0080e7          	jalr	-848(ra) # 800032cc <dirlink>
    80004624:	06054f63          	bltz	a0,800046a2 <create+0x162>
  iunlockput(dp);
    80004628:	8526                	mv	a0,s1
    8000462a:	fffff097          	auipc	ra,0xfffff
    8000462e:	80a080e7          	jalr	-2038(ra) # 80002e34 <iunlockput>
  return ip;
    80004632:	8ad2                	mv	s5,s4
    80004634:	b749                	j	800045b6 <create+0x76>
    iunlockput(dp);
    80004636:	8526                	mv	a0,s1
    80004638:	ffffe097          	auipc	ra,0xffffe
    8000463c:	7fc080e7          	jalr	2044(ra) # 80002e34 <iunlockput>
    return 0;
    80004640:	8ad2                	mv	s5,s4
    80004642:	bf95                	j	800045b6 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004644:	004a2603          	lw	a2,4(s4)
    80004648:	00004597          	auipc	a1,0x4
    8000464c:	03858593          	addi	a1,a1,56 # 80008680 <syscalls+0x2b0>
    80004650:	8552                	mv	a0,s4
    80004652:	fffff097          	auipc	ra,0xfffff
    80004656:	c7a080e7          	jalr	-902(ra) # 800032cc <dirlink>
    8000465a:	04054463          	bltz	a0,800046a2 <create+0x162>
    8000465e:	40d0                	lw	a2,4(s1)
    80004660:	00004597          	auipc	a1,0x4
    80004664:	02858593          	addi	a1,a1,40 # 80008688 <syscalls+0x2b8>
    80004668:	8552                	mv	a0,s4
    8000466a:	fffff097          	auipc	ra,0xfffff
    8000466e:	c62080e7          	jalr	-926(ra) # 800032cc <dirlink>
    80004672:	02054863          	bltz	a0,800046a2 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    80004676:	004a2603          	lw	a2,4(s4)
    8000467a:	fb040593          	addi	a1,s0,-80
    8000467e:	8526                	mv	a0,s1
    80004680:	fffff097          	auipc	ra,0xfffff
    80004684:	c4c080e7          	jalr	-948(ra) # 800032cc <dirlink>
    80004688:	00054d63          	bltz	a0,800046a2 <create+0x162>
    dp->nlink++;  // for ".."
    8000468c:	04a4d783          	lhu	a5,74(s1)
    80004690:	2785                	addiw	a5,a5,1
    80004692:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004696:	8526                	mv	a0,s1
    80004698:	ffffe097          	auipc	ra,0xffffe
    8000469c:	46e080e7          	jalr	1134(ra) # 80002b06 <iupdate>
    800046a0:	b761                	j	80004628 <create+0xe8>
  ip->nlink = 0;
    800046a2:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800046a6:	8552                	mv	a0,s4
    800046a8:	ffffe097          	auipc	ra,0xffffe
    800046ac:	45e080e7          	jalr	1118(ra) # 80002b06 <iupdate>
  iunlockput(ip);
    800046b0:	8552                	mv	a0,s4
    800046b2:	ffffe097          	auipc	ra,0xffffe
    800046b6:	782080e7          	jalr	1922(ra) # 80002e34 <iunlockput>
  iunlockput(dp);
    800046ba:	8526                	mv	a0,s1
    800046bc:	ffffe097          	auipc	ra,0xffffe
    800046c0:	778080e7          	jalr	1912(ra) # 80002e34 <iunlockput>
  return 0;
    800046c4:	bdcd                	j	800045b6 <create+0x76>
    return 0;
    800046c6:	8aaa                	mv	s5,a0
    800046c8:	b5fd                	j	800045b6 <create+0x76>

00000000800046ca <sys_dup>:
{
    800046ca:	7179                	addi	sp,sp,-48
    800046cc:	f406                	sd	ra,40(sp)
    800046ce:	f022                	sd	s0,32(sp)
    800046d0:	ec26                	sd	s1,24(sp)
    800046d2:	e84a                	sd	s2,16(sp)
    800046d4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800046d6:	fd840613          	addi	a2,s0,-40
    800046da:	4581                	li	a1,0
    800046dc:	4501                	li	a0,0
    800046de:	00000097          	auipc	ra,0x0
    800046e2:	dc0080e7          	jalr	-576(ra) # 8000449e <argfd>
    return -1;
    800046e6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800046e8:	02054363          	bltz	a0,8000470e <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800046ec:	fd843903          	ld	s2,-40(s0)
    800046f0:	854a                	mv	a0,s2
    800046f2:	00000097          	auipc	ra,0x0
    800046f6:	e0c080e7          	jalr	-500(ra) # 800044fe <fdalloc>
    800046fa:	84aa                	mv	s1,a0
    return -1;
    800046fc:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046fe:	00054863          	bltz	a0,8000470e <sys_dup+0x44>
  filedup(f);
    80004702:	854a                	mv	a0,s2
    80004704:	fffff097          	auipc	ra,0xfffff
    80004708:	310080e7          	jalr	784(ra) # 80003a14 <filedup>
  return fd;
    8000470c:	87a6                	mv	a5,s1
}
    8000470e:	853e                	mv	a0,a5
    80004710:	70a2                	ld	ra,40(sp)
    80004712:	7402                	ld	s0,32(sp)
    80004714:	64e2                	ld	s1,24(sp)
    80004716:	6942                	ld	s2,16(sp)
    80004718:	6145                	addi	sp,sp,48
    8000471a:	8082                	ret

000000008000471c <sys_read>:
{
    8000471c:	7179                	addi	sp,sp,-48
    8000471e:	f406                	sd	ra,40(sp)
    80004720:	f022                	sd	s0,32(sp)
    80004722:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004724:	fd840593          	addi	a1,s0,-40
    80004728:	4505                	li	a0,1
    8000472a:	ffffe097          	auipc	ra,0xffffe
    8000472e:	8b2080e7          	jalr	-1870(ra) # 80001fdc <argaddr>
  argint(2, &n);
    80004732:	fe440593          	addi	a1,s0,-28
    80004736:	4509                	li	a0,2
    80004738:	ffffe097          	auipc	ra,0xffffe
    8000473c:	884080e7          	jalr	-1916(ra) # 80001fbc <argint>
  if(argfd(0, 0, &f) < 0)
    80004740:	fe840613          	addi	a2,s0,-24
    80004744:	4581                	li	a1,0
    80004746:	4501                	li	a0,0
    80004748:	00000097          	auipc	ra,0x0
    8000474c:	d56080e7          	jalr	-682(ra) # 8000449e <argfd>
    80004750:	87aa                	mv	a5,a0
    return -1;
    80004752:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004754:	0007cc63          	bltz	a5,8000476c <sys_read+0x50>
  return fileread(f, p, n);
    80004758:	fe442603          	lw	a2,-28(s0)
    8000475c:	fd843583          	ld	a1,-40(s0)
    80004760:	fe843503          	ld	a0,-24(s0)
    80004764:	fffff097          	auipc	ra,0xfffff
    80004768:	43c080e7          	jalr	1084(ra) # 80003ba0 <fileread>
}
    8000476c:	70a2                	ld	ra,40(sp)
    8000476e:	7402                	ld	s0,32(sp)
    80004770:	6145                	addi	sp,sp,48
    80004772:	8082                	ret

0000000080004774 <sys_write>:
{
    80004774:	7179                	addi	sp,sp,-48
    80004776:	f406                	sd	ra,40(sp)
    80004778:	f022                	sd	s0,32(sp)
    8000477a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000477c:	fd840593          	addi	a1,s0,-40
    80004780:	4505                	li	a0,1
    80004782:	ffffe097          	auipc	ra,0xffffe
    80004786:	85a080e7          	jalr	-1958(ra) # 80001fdc <argaddr>
  argint(2, &n);
    8000478a:	fe440593          	addi	a1,s0,-28
    8000478e:	4509                	li	a0,2
    80004790:	ffffe097          	auipc	ra,0xffffe
    80004794:	82c080e7          	jalr	-2004(ra) # 80001fbc <argint>
  if(argfd(0, 0, &f) < 0)
    80004798:	fe840613          	addi	a2,s0,-24
    8000479c:	4581                	li	a1,0
    8000479e:	4501                	li	a0,0
    800047a0:	00000097          	auipc	ra,0x0
    800047a4:	cfe080e7          	jalr	-770(ra) # 8000449e <argfd>
    800047a8:	87aa                	mv	a5,a0
    return -1;
    800047aa:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047ac:	0007cc63          	bltz	a5,800047c4 <sys_write+0x50>
  return filewrite(f, p, n);
    800047b0:	fe442603          	lw	a2,-28(s0)
    800047b4:	fd843583          	ld	a1,-40(s0)
    800047b8:	fe843503          	ld	a0,-24(s0)
    800047bc:	fffff097          	auipc	ra,0xfffff
    800047c0:	4a6080e7          	jalr	1190(ra) # 80003c62 <filewrite>
}
    800047c4:	70a2                	ld	ra,40(sp)
    800047c6:	7402                	ld	s0,32(sp)
    800047c8:	6145                	addi	sp,sp,48
    800047ca:	8082                	ret

00000000800047cc <sys_close>:
{
    800047cc:	1101                	addi	sp,sp,-32
    800047ce:	ec06                	sd	ra,24(sp)
    800047d0:	e822                	sd	s0,16(sp)
    800047d2:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047d4:	fe040613          	addi	a2,s0,-32
    800047d8:	fec40593          	addi	a1,s0,-20
    800047dc:	4501                	li	a0,0
    800047de:	00000097          	auipc	ra,0x0
    800047e2:	cc0080e7          	jalr	-832(ra) # 8000449e <argfd>
    return -1;
    800047e6:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047e8:	02054463          	bltz	a0,80004810 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047ec:	ffffc097          	auipc	ra,0xffffc
    800047f0:	668080e7          	jalr	1640(ra) # 80000e54 <myproc>
    800047f4:	fec42783          	lw	a5,-20(s0)
    800047f8:	07e9                	addi	a5,a5,26
    800047fa:	078e                	slli	a5,a5,0x3
    800047fc:	953e                	add	a0,a0,a5
    800047fe:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004802:	fe043503          	ld	a0,-32(s0)
    80004806:	fffff097          	auipc	ra,0xfffff
    8000480a:	260080e7          	jalr	608(ra) # 80003a66 <fileclose>
  return 0;
    8000480e:	4781                	li	a5,0
}
    80004810:	853e                	mv	a0,a5
    80004812:	60e2                	ld	ra,24(sp)
    80004814:	6442                	ld	s0,16(sp)
    80004816:	6105                	addi	sp,sp,32
    80004818:	8082                	ret

000000008000481a <sys_fstat>:
{
    8000481a:	1101                	addi	sp,sp,-32
    8000481c:	ec06                	sd	ra,24(sp)
    8000481e:	e822                	sd	s0,16(sp)
    80004820:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004822:	fe040593          	addi	a1,s0,-32
    80004826:	4505                	li	a0,1
    80004828:	ffffd097          	auipc	ra,0xffffd
    8000482c:	7b4080e7          	jalr	1972(ra) # 80001fdc <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004830:	fe840613          	addi	a2,s0,-24
    80004834:	4581                	li	a1,0
    80004836:	4501                	li	a0,0
    80004838:	00000097          	auipc	ra,0x0
    8000483c:	c66080e7          	jalr	-922(ra) # 8000449e <argfd>
    80004840:	87aa                	mv	a5,a0
    return -1;
    80004842:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004844:	0007ca63          	bltz	a5,80004858 <sys_fstat+0x3e>
  return filestat(f, st);
    80004848:	fe043583          	ld	a1,-32(s0)
    8000484c:	fe843503          	ld	a0,-24(s0)
    80004850:	fffff097          	auipc	ra,0xfffff
    80004854:	2de080e7          	jalr	734(ra) # 80003b2e <filestat>
}
    80004858:	60e2                	ld	ra,24(sp)
    8000485a:	6442                	ld	s0,16(sp)
    8000485c:	6105                	addi	sp,sp,32
    8000485e:	8082                	ret

0000000080004860 <sys_link>:
{
    80004860:	7169                	addi	sp,sp,-304
    80004862:	f606                	sd	ra,296(sp)
    80004864:	f222                	sd	s0,288(sp)
    80004866:	ee26                	sd	s1,280(sp)
    80004868:	ea4a                	sd	s2,272(sp)
    8000486a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000486c:	08000613          	li	a2,128
    80004870:	ed040593          	addi	a1,s0,-304
    80004874:	4501                	li	a0,0
    80004876:	ffffd097          	auipc	ra,0xffffd
    8000487a:	786080e7          	jalr	1926(ra) # 80001ffc <argstr>
    return -1;
    8000487e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004880:	10054e63          	bltz	a0,8000499c <sys_link+0x13c>
    80004884:	08000613          	li	a2,128
    80004888:	f5040593          	addi	a1,s0,-176
    8000488c:	4505                	li	a0,1
    8000488e:	ffffd097          	auipc	ra,0xffffd
    80004892:	76e080e7          	jalr	1902(ra) # 80001ffc <argstr>
    return -1;
    80004896:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004898:	10054263          	bltz	a0,8000499c <sys_link+0x13c>
  begin_op();
    8000489c:	fffff097          	auipc	ra,0xfffff
    800048a0:	d02080e7          	jalr	-766(ra) # 8000359e <begin_op>
  if((ip = namei(old)) == 0){
    800048a4:	ed040513          	addi	a0,s0,-304
    800048a8:	fffff097          	auipc	ra,0xfffff
    800048ac:	ad6080e7          	jalr	-1322(ra) # 8000337e <namei>
    800048b0:	84aa                	mv	s1,a0
    800048b2:	c551                	beqz	a0,8000493e <sys_link+0xde>
  ilock(ip);
    800048b4:	ffffe097          	auipc	ra,0xffffe
    800048b8:	31e080e7          	jalr	798(ra) # 80002bd2 <ilock>
  if(ip->type == T_DIR){
    800048bc:	04449703          	lh	a4,68(s1)
    800048c0:	4785                	li	a5,1
    800048c2:	08f70463          	beq	a4,a5,8000494a <sys_link+0xea>
  ip->nlink++;
    800048c6:	04a4d783          	lhu	a5,74(s1)
    800048ca:	2785                	addiw	a5,a5,1
    800048cc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048d0:	8526                	mv	a0,s1
    800048d2:	ffffe097          	auipc	ra,0xffffe
    800048d6:	234080e7          	jalr	564(ra) # 80002b06 <iupdate>
  iunlock(ip);
    800048da:	8526                	mv	a0,s1
    800048dc:	ffffe097          	auipc	ra,0xffffe
    800048e0:	3b8080e7          	jalr	952(ra) # 80002c94 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048e4:	fd040593          	addi	a1,s0,-48
    800048e8:	f5040513          	addi	a0,s0,-176
    800048ec:	fffff097          	auipc	ra,0xfffff
    800048f0:	ab0080e7          	jalr	-1360(ra) # 8000339c <nameiparent>
    800048f4:	892a                	mv	s2,a0
    800048f6:	c935                	beqz	a0,8000496a <sys_link+0x10a>
  ilock(dp);
    800048f8:	ffffe097          	auipc	ra,0xffffe
    800048fc:	2da080e7          	jalr	730(ra) # 80002bd2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004900:	00092703          	lw	a4,0(s2)
    80004904:	409c                	lw	a5,0(s1)
    80004906:	04f71d63          	bne	a4,a5,80004960 <sys_link+0x100>
    8000490a:	40d0                	lw	a2,4(s1)
    8000490c:	fd040593          	addi	a1,s0,-48
    80004910:	854a                	mv	a0,s2
    80004912:	fffff097          	auipc	ra,0xfffff
    80004916:	9ba080e7          	jalr	-1606(ra) # 800032cc <dirlink>
    8000491a:	04054363          	bltz	a0,80004960 <sys_link+0x100>
  iunlockput(dp);
    8000491e:	854a                	mv	a0,s2
    80004920:	ffffe097          	auipc	ra,0xffffe
    80004924:	514080e7          	jalr	1300(ra) # 80002e34 <iunlockput>
  iput(ip);
    80004928:	8526                	mv	a0,s1
    8000492a:	ffffe097          	auipc	ra,0xffffe
    8000492e:	462080e7          	jalr	1122(ra) # 80002d8c <iput>
  end_op();
    80004932:	fffff097          	auipc	ra,0xfffff
    80004936:	cea080e7          	jalr	-790(ra) # 8000361c <end_op>
  return 0;
    8000493a:	4781                	li	a5,0
    8000493c:	a085                	j	8000499c <sys_link+0x13c>
    end_op();
    8000493e:	fffff097          	auipc	ra,0xfffff
    80004942:	cde080e7          	jalr	-802(ra) # 8000361c <end_op>
    return -1;
    80004946:	57fd                	li	a5,-1
    80004948:	a891                	j	8000499c <sys_link+0x13c>
    iunlockput(ip);
    8000494a:	8526                	mv	a0,s1
    8000494c:	ffffe097          	auipc	ra,0xffffe
    80004950:	4e8080e7          	jalr	1256(ra) # 80002e34 <iunlockput>
    end_op();
    80004954:	fffff097          	auipc	ra,0xfffff
    80004958:	cc8080e7          	jalr	-824(ra) # 8000361c <end_op>
    return -1;
    8000495c:	57fd                	li	a5,-1
    8000495e:	a83d                	j	8000499c <sys_link+0x13c>
    iunlockput(dp);
    80004960:	854a                	mv	a0,s2
    80004962:	ffffe097          	auipc	ra,0xffffe
    80004966:	4d2080e7          	jalr	1234(ra) # 80002e34 <iunlockput>
  ilock(ip);
    8000496a:	8526                	mv	a0,s1
    8000496c:	ffffe097          	auipc	ra,0xffffe
    80004970:	266080e7          	jalr	614(ra) # 80002bd2 <ilock>
  ip->nlink--;
    80004974:	04a4d783          	lhu	a5,74(s1)
    80004978:	37fd                	addiw	a5,a5,-1
    8000497a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000497e:	8526                	mv	a0,s1
    80004980:	ffffe097          	auipc	ra,0xffffe
    80004984:	186080e7          	jalr	390(ra) # 80002b06 <iupdate>
  iunlockput(ip);
    80004988:	8526                	mv	a0,s1
    8000498a:	ffffe097          	auipc	ra,0xffffe
    8000498e:	4aa080e7          	jalr	1194(ra) # 80002e34 <iunlockput>
  end_op();
    80004992:	fffff097          	auipc	ra,0xfffff
    80004996:	c8a080e7          	jalr	-886(ra) # 8000361c <end_op>
  return -1;
    8000499a:	57fd                	li	a5,-1
}
    8000499c:	853e                	mv	a0,a5
    8000499e:	70b2                	ld	ra,296(sp)
    800049a0:	7412                	ld	s0,288(sp)
    800049a2:	64f2                	ld	s1,280(sp)
    800049a4:	6952                	ld	s2,272(sp)
    800049a6:	6155                	addi	sp,sp,304
    800049a8:	8082                	ret

00000000800049aa <sys_unlink>:
{
    800049aa:	7151                	addi	sp,sp,-240
    800049ac:	f586                	sd	ra,232(sp)
    800049ae:	f1a2                	sd	s0,224(sp)
    800049b0:	eda6                	sd	s1,216(sp)
    800049b2:	e9ca                	sd	s2,208(sp)
    800049b4:	e5ce                	sd	s3,200(sp)
    800049b6:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800049b8:	08000613          	li	a2,128
    800049bc:	f3040593          	addi	a1,s0,-208
    800049c0:	4501                	li	a0,0
    800049c2:	ffffd097          	auipc	ra,0xffffd
    800049c6:	63a080e7          	jalr	1594(ra) # 80001ffc <argstr>
    800049ca:	18054163          	bltz	a0,80004b4c <sys_unlink+0x1a2>
  begin_op();
    800049ce:	fffff097          	auipc	ra,0xfffff
    800049d2:	bd0080e7          	jalr	-1072(ra) # 8000359e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049d6:	fb040593          	addi	a1,s0,-80
    800049da:	f3040513          	addi	a0,s0,-208
    800049de:	fffff097          	auipc	ra,0xfffff
    800049e2:	9be080e7          	jalr	-1602(ra) # 8000339c <nameiparent>
    800049e6:	84aa                	mv	s1,a0
    800049e8:	c979                	beqz	a0,80004abe <sys_unlink+0x114>
  ilock(dp);
    800049ea:	ffffe097          	auipc	ra,0xffffe
    800049ee:	1e8080e7          	jalr	488(ra) # 80002bd2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049f2:	00004597          	auipc	a1,0x4
    800049f6:	c8e58593          	addi	a1,a1,-882 # 80008680 <syscalls+0x2b0>
    800049fa:	fb040513          	addi	a0,s0,-80
    800049fe:	ffffe097          	auipc	ra,0xffffe
    80004a02:	69e080e7          	jalr	1694(ra) # 8000309c <namecmp>
    80004a06:	14050a63          	beqz	a0,80004b5a <sys_unlink+0x1b0>
    80004a0a:	00004597          	auipc	a1,0x4
    80004a0e:	c7e58593          	addi	a1,a1,-898 # 80008688 <syscalls+0x2b8>
    80004a12:	fb040513          	addi	a0,s0,-80
    80004a16:	ffffe097          	auipc	ra,0xffffe
    80004a1a:	686080e7          	jalr	1670(ra) # 8000309c <namecmp>
    80004a1e:	12050e63          	beqz	a0,80004b5a <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a22:	f2c40613          	addi	a2,s0,-212
    80004a26:	fb040593          	addi	a1,s0,-80
    80004a2a:	8526                	mv	a0,s1
    80004a2c:	ffffe097          	auipc	ra,0xffffe
    80004a30:	68a080e7          	jalr	1674(ra) # 800030b6 <dirlookup>
    80004a34:	892a                	mv	s2,a0
    80004a36:	12050263          	beqz	a0,80004b5a <sys_unlink+0x1b0>
  ilock(ip);
    80004a3a:	ffffe097          	auipc	ra,0xffffe
    80004a3e:	198080e7          	jalr	408(ra) # 80002bd2 <ilock>
  if(ip->nlink < 1)
    80004a42:	04a91783          	lh	a5,74(s2)
    80004a46:	08f05263          	blez	a5,80004aca <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a4a:	04491703          	lh	a4,68(s2)
    80004a4e:	4785                	li	a5,1
    80004a50:	08f70563          	beq	a4,a5,80004ada <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a54:	4641                	li	a2,16
    80004a56:	4581                	li	a1,0
    80004a58:	fc040513          	addi	a0,s0,-64
    80004a5c:	ffffb097          	auipc	ra,0xffffb
    80004a60:	71e080e7          	jalr	1822(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a64:	4741                	li	a4,16
    80004a66:	f2c42683          	lw	a3,-212(s0)
    80004a6a:	fc040613          	addi	a2,s0,-64
    80004a6e:	4581                	li	a1,0
    80004a70:	8526                	mv	a0,s1
    80004a72:	ffffe097          	auipc	ra,0xffffe
    80004a76:	50c080e7          	jalr	1292(ra) # 80002f7e <writei>
    80004a7a:	47c1                	li	a5,16
    80004a7c:	0af51563          	bne	a0,a5,80004b26 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a80:	04491703          	lh	a4,68(s2)
    80004a84:	4785                	li	a5,1
    80004a86:	0af70863          	beq	a4,a5,80004b36 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a8a:	8526                	mv	a0,s1
    80004a8c:	ffffe097          	auipc	ra,0xffffe
    80004a90:	3a8080e7          	jalr	936(ra) # 80002e34 <iunlockput>
  ip->nlink--;
    80004a94:	04a95783          	lhu	a5,74(s2)
    80004a98:	37fd                	addiw	a5,a5,-1
    80004a9a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a9e:	854a                	mv	a0,s2
    80004aa0:	ffffe097          	auipc	ra,0xffffe
    80004aa4:	066080e7          	jalr	102(ra) # 80002b06 <iupdate>
  iunlockput(ip);
    80004aa8:	854a                	mv	a0,s2
    80004aaa:	ffffe097          	auipc	ra,0xffffe
    80004aae:	38a080e7          	jalr	906(ra) # 80002e34 <iunlockput>
  end_op();
    80004ab2:	fffff097          	auipc	ra,0xfffff
    80004ab6:	b6a080e7          	jalr	-1174(ra) # 8000361c <end_op>
  return 0;
    80004aba:	4501                	li	a0,0
    80004abc:	a84d                	j	80004b6e <sys_unlink+0x1c4>
    end_op();
    80004abe:	fffff097          	auipc	ra,0xfffff
    80004ac2:	b5e080e7          	jalr	-1186(ra) # 8000361c <end_op>
    return -1;
    80004ac6:	557d                	li	a0,-1
    80004ac8:	a05d                	j	80004b6e <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004aca:	00004517          	auipc	a0,0x4
    80004ace:	bc650513          	addi	a0,a0,-1082 # 80008690 <syscalls+0x2c0>
    80004ad2:	00001097          	auipc	ra,0x1
    80004ad6:	248080e7          	jalr	584(ra) # 80005d1a <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ada:	04c92703          	lw	a4,76(s2)
    80004ade:	02000793          	li	a5,32
    80004ae2:	f6e7f9e3          	bgeu	a5,a4,80004a54 <sys_unlink+0xaa>
    80004ae6:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004aea:	4741                	li	a4,16
    80004aec:	86ce                	mv	a3,s3
    80004aee:	f1840613          	addi	a2,s0,-232
    80004af2:	4581                	li	a1,0
    80004af4:	854a                	mv	a0,s2
    80004af6:	ffffe097          	auipc	ra,0xffffe
    80004afa:	390080e7          	jalr	912(ra) # 80002e86 <readi>
    80004afe:	47c1                	li	a5,16
    80004b00:	00f51b63          	bne	a0,a5,80004b16 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004b04:	f1845783          	lhu	a5,-232(s0)
    80004b08:	e7a1                	bnez	a5,80004b50 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b0a:	29c1                	addiw	s3,s3,16
    80004b0c:	04c92783          	lw	a5,76(s2)
    80004b10:	fcf9ede3          	bltu	s3,a5,80004aea <sys_unlink+0x140>
    80004b14:	b781                	j	80004a54 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b16:	00004517          	auipc	a0,0x4
    80004b1a:	b9250513          	addi	a0,a0,-1134 # 800086a8 <syscalls+0x2d8>
    80004b1e:	00001097          	auipc	ra,0x1
    80004b22:	1fc080e7          	jalr	508(ra) # 80005d1a <panic>
    panic("unlink: writei");
    80004b26:	00004517          	auipc	a0,0x4
    80004b2a:	b9a50513          	addi	a0,a0,-1126 # 800086c0 <syscalls+0x2f0>
    80004b2e:	00001097          	auipc	ra,0x1
    80004b32:	1ec080e7          	jalr	492(ra) # 80005d1a <panic>
    dp->nlink--;
    80004b36:	04a4d783          	lhu	a5,74(s1)
    80004b3a:	37fd                	addiw	a5,a5,-1
    80004b3c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b40:	8526                	mv	a0,s1
    80004b42:	ffffe097          	auipc	ra,0xffffe
    80004b46:	fc4080e7          	jalr	-60(ra) # 80002b06 <iupdate>
    80004b4a:	b781                	j	80004a8a <sys_unlink+0xe0>
    return -1;
    80004b4c:	557d                	li	a0,-1
    80004b4e:	a005                	j	80004b6e <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b50:	854a                	mv	a0,s2
    80004b52:	ffffe097          	auipc	ra,0xffffe
    80004b56:	2e2080e7          	jalr	738(ra) # 80002e34 <iunlockput>
  iunlockput(dp);
    80004b5a:	8526                	mv	a0,s1
    80004b5c:	ffffe097          	auipc	ra,0xffffe
    80004b60:	2d8080e7          	jalr	728(ra) # 80002e34 <iunlockput>
  end_op();
    80004b64:	fffff097          	auipc	ra,0xfffff
    80004b68:	ab8080e7          	jalr	-1352(ra) # 8000361c <end_op>
  return -1;
    80004b6c:	557d                	li	a0,-1
}
    80004b6e:	70ae                	ld	ra,232(sp)
    80004b70:	740e                	ld	s0,224(sp)
    80004b72:	64ee                	ld	s1,216(sp)
    80004b74:	694e                	ld	s2,208(sp)
    80004b76:	69ae                	ld	s3,200(sp)
    80004b78:	616d                	addi	sp,sp,240
    80004b7a:	8082                	ret

0000000080004b7c <sys_open>:

uint64
sys_open(void)
{
    80004b7c:	7131                	addi	sp,sp,-192
    80004b7e:	fd06                	sd	ra,184(sp)
    80004b80:	f922                	sd	s0,176(sp)
    80004b82:	f526                	sd	s1,168(sp)
    80004b84:	f14a                	sd	s2,160(sp)
    80004b86:	ed4e                	sd	s3,152(sp)
    80004b88:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004b8a:	f4c40593          	addi	a1,s0,-180
    80004b8e:	4505                	li	a0,1
    80004b90:	ffffd097          	auipc	ra,0xffffd
    80004b94:	42c080e7          	jalr	1068(ra) # 80001fbc <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b98:	08000613          	li	a2,128
    80004b9c:	f5040593          	addi	a1,s0,-176
    80004ba0:	4501                	li	a0,0
    80004ba2:	ffffd097          	auipc	ra,0xffffd
    80004ba6:	45a080e7          	jalr	1114(ra) # 80001ffc <argstr>
    80004baa:	87aa                	mv	a5,a0
    return -1;
    80004bac:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004bae:	0a07c963          	bltz	a5,80004c60 <sys_open+0xe4>

  begin_op();
    80004bb2:	fffff097          	auipc	ra,0xfffff
    80004bb6:	9ec080e7          	jalr	-1556(ra) # 8000359e <begin_op>

  if(omode & O_CREATE){
    80004bba:	f4c42783          	lw	a5,-180(s0)
    80004bbe:	2007f793          	andi	a5,a5,512
    80004bc2:	cfc5                	beqz	a5,80004c7a <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004bc4:	4681                	li	a3,0
    80004bc6:	4601                	li	a2,0
    80004bc8:	4589                	li	a1,2
    80004bca:	f5040513          	addi	a0,s0,-176
    80004bce:	00000097          	auipc	ra,0x0
    80004bd2:	972080e7          	jalr	-1678(ra) # 80004540 <create>
    80004bd6:	84aa                	mv	s1,a0
    if(ip == 0){
    80004bd8:	c959                	beqz	a0,80004c6e <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004bda:	04449703          	lh	a4,68(s1)
    80004bde:	478d                	li	a5,3
    80004be0:	00f71763          	bne	a4,a5,80004bee <sys_open+0x72>
    80004be4:	0464d703          	lhu	a4,70(s1)
    80004be8:	47a5                	li	a5,9
    80004bea:	0ce7ed63          	bltu	a5,a4,80004cc4 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bee:	fffff097          	auipc	ra,0xfffff
    80004bf2:	dbc080e7          	jalr	-580(ra) # 800039aa <filealloc>
    80004bf6:	89aa                	mv	s3,a0
    80004bf8:	10050363          	beqz	a0,80004cfe <sys_open+0x182>
    80004bfc:	00000097          	auipc	ra,0x0
    80004c00:	902080e7          	jalr	-1790(ra) # 800044fe <fdalloc>
    80004c04:	892a                	mv	s2,a0
    80004c06:	0e054763          	bltz	a0,80004cf4 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c0a:	04449703          	lh	a4,68(s1)
    80004c0e:	478d                	li	a5,3
    80004c10:	0cf70563          	beq	a4,a5,80004cda <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c14:	4789                	li	a5,2
    80004c16:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c1a:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004c1e:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c22:	f4c42783          	lw	a5,-180(s0)
    80004c26:	0017c713          	xori	a4,a5,1
    80004c2a:	8b05                	andi	a4,a4,1
    80004c2c:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c30:	0037f713          	andi	a4,a5,3
    80004c34:	00e03733          	snez	a4,a4
    80004c38:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c3c:	4007f793          	andi	a5,a5,1024
    80004c40:	c791                	beqz	a5,80004c4c <sys_open+0xd0>
    80004c42:	04449703          	lh	a4,68(s1)
    80004c46:	4789                	li	a5,2
    80004c48:	0af70063          	beq	a4,a5,80004ce8 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c4c:	8526                	mv	a0,s1
    80004c4e:	ffffe097          	auipc	ra,0xffffe
    80004c52:	046080e7          	jalr	70(ra) # 80002c94 <iunlock>
  end_op();
    80004c56:	fffff097          	auipc	ra,0xfffff
    80004c5a:	9c6080e7          	jalr	-1594(ra) # 8000361c <end_op>

  return fd;
    80004c5e:	854a                	mv	a0,s2
}
    80004c60:	70ea                	ld	ra,184(sp)
    80004c62:	744a                	ld	s0,176(sp)
    80004c64:	74aa                	ld	s1,168(sp)
    80004c66:	790a                	ld	s2,160(sp)
    80004c68:	69ea                	ld	s3,152(sp)
    80004c6a:	6129                	addi	sp,sp,192
    80004c6c:	8082                	ret
      end_op();
    80004c6e:	fffff097          	auipc	ra,0xfffff
    80004c72:	9ae080e7          	jalr	-1618(ra) # 8000361c <end_op>
      return -1;
    80004c76:	557d                	li	a0,-1
    80004c78:	b7e5                	j	80004c60 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c7a:	f5040513          	addi	a0,s0,-176
    80004c7e:	ffffe097          	auipc	ra,0xffffe
    80004c82:	700080e7          	jalr	1792(ra) # 8000337e <namei>
    80004c86:	84aa                	mv	s1,a0
    80004c88:	c905                	beqz	a0,80004cb8 <sys_open+0x13c>
    ilock(ip);
    80004c8a:	ffffe097          	auipc	ra,0xffffe
    80004c8e:	f48080e7          	jalr	-184(ra) # 80002bd2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c92:	04449703          	lh	a4,68(s1)
    80004c96:	4785                	li	a5,1
    80004c98:	f4f711e3          	bne	a4,a5,80004bda <sys_open+0x5e>
    80004c9c:	f4c42783          	lw	a5,-180(s0)
    80004ca0:	d7b9                	beqz	a5,80004bee <sys_open+0x72>
      iunlockput(ip);
    80004ca2:	8526                	mv	a0,s1
    80004ca4:	ffffe097          	auipc	ra,0xffffe
    80004ca8:	190080e7          	jalr	400(ra) # 80002e34 <iunlockput>
      end_op();
    80004cac:	fffff097          	auipc	ra,0xfffff
    80004cb0:	970080e7          	jalr	-1680(ra) # 8000361c <end_op>
      return -1;
    80004cb4:	557d                	li	a0,-1
    80004cb6:	b76d                	j	80004c60 <sys_open+0xe4>
      end_op();
    80004cb8:	fffff097          	auipc	ra,0xfffff
    80004cbc:	964080e7          	jalr	-1692(ra) # 8000361c <end_op>
      return -1;
    80004cc0:	557d                	li	a0,-1
    80004cc2:	bf79                	j	80004c60 <sys_open+0xe4>
    iunlockput(ip);
    80004cc4:	8526                	mv	a0,s1
    80004cc6:	ffffe097          	auipc	ra,0xffffe
    80004cca:	16e080e7          	jalr	366(ra) # 80002e34 <iunlockput>
    end_op();
    80004cce:	fffff097          	auipc	ra,0xfffff
    80004cd2:	94e080e7          	jalr	-1714(ra) # 8000361c <end_op>
    return -1;
    80004cd6:	557d                	li	a0,-1
    80004cd8:	b761                	j	80004c60 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004cda:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004cde:	04649783          	lh	a5,70(s1)
    80004ce2:	02f99223          	sh	a5,36(s3)
    80004ce6:	bf25                	j	80004c1e <sys_open+0xa2>
    itrunc(ip);
    80004ce8:	8526                	mv	a0,s1
    80004cea:	ffffe097          	auipc	ra,0xffffe
    80004cee:	ff6080e7          	jalr	-10(ra) # 80002ce0 <itrunc>
    80004cf2:	bfa9                	j	80004c4c <sys_open+0xd0>
      fileclose(f);
    80004cf4:	854e                	mv	a0,s3
    80004cf6:	fffff097          	auipc	ra,0xfffff
    80004cfa:	d70080e7          	jalr	-656(ra) # 80003a66 <fileclose>
    iunlockput(ip);
    80004cfe:	8526                	mv	a0,s1
    80004d00:	ffffe097          	auipc	ra,0xffffe
    80004d04:	134080e7          	jalr	308(ra) # 80002e34 <iunlockput>
    end_op();
    80004d08:	fffff097          	auipc	ra,0xfffff
    80004d0c:	914080e7          	jalr	-1772(ra) # 8000361c <end_op>
    return -1;
    80004d10:	557d                	li	a0,-1
    80004d12:	b7b9                	j	80004c60 <sys_open+0xe4>

0000000080004d14 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d14:	7175                	addi	sp,sp,-144
    80004d16:	e506                	sd	ra,136(sp)
    80004d18:	e122                	sd	s0,128(sp)
    80004d1a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d1c:	fffff097          	auipc	ra,0xfffff
    80004d20:	882080e7          	jalr	-1918(ra) # 8000359e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d24:	08000613          	li	a2,128
    80004d28:	f7040593          	addi	a1,s0,-144
    80004d2c:	4501                	li	a0,0
    80004d2e:	ffffd097          	auipc	ra,0xffffd
    80004d32:	2ce080e7          	jalr	718(ra) # 80001ffc <argstr>
    80004d36:	02054963          	bltz	a0,80004d68 <sys_mkdir+0x54>
    80004d3a:	4681                	li	a3,0
    80004d3c:	4601                	li	a2,0
    80004d3e:	4585                	li	a1,1
    80004d40:	f7040513          	addi	a0,s0,-144
    80004d44:	fffff097          	auipc	ra,0xfffff
    80004d48:	7fc080e7          	jalr	2044(ra) # 80004540 <create>
    80004d4c:	cd11                	beqz	a0,80004d68 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d4e:	ffffe097          	auipc	ra,0xffffe
    80004d52:	0e6080e7          	jalr	230(ra) # 80002e34 <iunlockput>
  end_op();
    80004d56:	fffff097          	auipc	ra,0xfffff
    80004d5a:	8c6080e7          	jalr	-1850(ra) # 8000361c <end_op>
  return 0;
    80004d5e:	4501                	li	a0,0
}
    80004d60:	60aa                	ld	ra,136(sp)
    80004d62:	640a                	ld	s0,128(sp)
    80004d64:	6149                	addi	sp,sp,144
    80004d66:	8082                	ret
    end_op();
    80004d68:	fffff097          	auipc	ra,0xfffff
    80004d6c:	8b4080e7          	jalr	-1868(ra) # 8000361c <end_op>
    return -1;
    80004d70:	557d                	li	a0,-1
    80004d72:	b7fd                	j	80004d60 <sys_mkdir+0x4c>

0000000080004d74 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d74:	7135                	addi	sp,sp,-160
    80004d76:	ed06                	sd	ra,152(sp)
    80004d78:	e922                	sd	s0,144(sp)
    80004d7a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d7c:	fffff097          	auipc	ra,0xfffff
    80004d80:	822080e7          	jalr	-2014(ra) # 8000359e <begin_op>
  argint(1, &major);
    80004d84:	f6c40593          	addi	a1,s0,-148
    80004d88:	4505                	li	a0,1
    80004d8a:	ffffd097          	auipc	ra,0xffffd
    80004d8e:	232080e7          	jalr	562(ra) # 80001fbc <argint>
  argint(2, &minor);
    80004d92:	f6840593          	addi	a1,s0,-152
    80004d96:	4509                	li	a0,2
    80004d98:	ffffd097          	auipc	ra,0xffffd
    80004d9c:	224080e7          	jalr	548(ra) # 80001fbc <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004da0:	08000613          	li	a2,128
    80004da4:	f7040593          	addi	a1,s0,-144
    80004da8:	4501                	li	a0,0
    80004daa:	ffffd097          	auipc	ra,0xffffd
    80004dae:	252080e7          	jalr	594(ra) # 80001ffc <argstr>
    80004db2:	02054b63          	bltz	a0,80004de8 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004db6:	f6841683          	lh	a3,-152(s0)
    80004dba:	f6c41603          	lh	a2,-148(s0)
    80004dbe:	458d                	li	a1,3
    80004dc0:	f7040513          	addi	a0,s0,-144
    80004dc4:	fffff097          	auipc	ra,0xfffff
    80004dc8:	77c080e7          	jalr	1916(ra) # 80004540 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004dcc:	cd11                	beqz	a0,80004de8 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dce:	ffffe097          	auipc	ra,0xffffe
    80004dd2:	066080e7          	jalr	102(ra) # 80002e34 <iunlockput>
  end_op();
    80004dd6:	fffff097          	auipc	ra,0xfffff
    80004dda:	846080e7          	jalr	-1978(ra) # 8000361c <end_op>
  return 0;
    80004dde:	4501                	li	a0,0
}
    80004de0:	60ea                	ld	ra,152(sp)
    80004de2:	644a                	ld	s0,144(sp)
    80004de4:	610d                	addi	sp,sp,160
    80004de6:	8082                	ret
    end_op();
    80004de8:	fffff097          	auipc	ra,0xfffff
    80004dec:	834080e7          	jalr	-1996(ra) # 8000361c <end_op>
    return -1;
    80004df0:	557d                	li	a0,-1
    80004df2:	b7fd                	j	80004de0 <sys_mknod+0x6c>

0000000080004df4 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004df4:	7135                	addi	sp,sp,-160
    80004df6:	ed06                	sd	ra,152(sp)
    80004df8:	e922                	sd	s0,144(sp)
    80004dfa:	e526                	sd	s1,136(sp)
    80004dfc:	e14a                	sd	s2,128(sp)
    80004dfe:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e00:	ffffc097          	auipc	ra,0xffffc
    80004e04:	054080e7          	jalr	84(ra) # 80000e54 <myproc>
    80004e08:	892a                	mv	s2,a0
  
  begin_op();
    80004e0a:	ffffe097          	auipc	ra,0xffffe
    80004e0e:	794080e7          	jalr	1940(ra) # 8000359e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e12:	08000613          	li	a2,128
    80004e16:	f6040593          	addi	a1,s0,-160
    80004e1a:	4501                	li	a0,0
    80004e1c:	ffffd097          	auipc	ra,0xffffd
    80004e20:	1e0080e7          	jalr	480(ra) # 80001ffc <argstr>
    80004e24:	04054b63          	bltz	a0,80004e7a <sys_chdir+0x86>
    80004e28:	f6040513          	addi	a0,s0,-160
    80004e2c:	ffffe097          	auipc	ra,0xffffe
    80004e30:	552080e7          	jalr	1362(ra) # 8000337e <namei>
    80004e34:	84aa                	mv	s1,a0
    80004e36:	c131                	beqz	a0,80004e7a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e38:	ffffe097          	auipc	ra,0xffffe
    80004e3c:	d9a080e7          	jalr	-614(ra) # 80002bd2 <ilock>
  if(ip->type != T_DIR){
    80004e40:	04449703          	lh	a4,68(s1)
    80004e44:	4785                	li	a5,1
    80004e46:	04f71063          	bne	a4,a5,80004e86 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e4a:	8526                	mv	a0,s1
    80004e4c:	ffffe097          	auipc	ra,0xffffe
    80004e50:	e48080e7          	jalr	-440(ra) # 80002c94 <iunlock>
  iput(p->cwd);
    80004e54:	15093503          	ld	a0,336(s2)
    80004e58:	ffffe097          	auipc	ra,0xffffe
    80004e5c:	f34080e7          	jalr	-204(ra) # 80002d8c <iput>
  end_op();
    80004e60:	ffffe097          	auipc	ra,0xffffe
    80004e64:	7bc080e7          	jalr	1980(ra) # 8000361c <end_op>
  p->cwd = ip;
    80004e68:	14993823          	sd	s1,336(s2)
  return 0;
    80004e6c:	4501                	li	a0,0
}
    80004e6e:	60ea                	ld	ra,152(sp)
    80004e70:	644a                	ld	s0,144(sp)
    80004e72:	64aa                	ld	s1,136(sp)
    80004e74:	690a                	ld	s2,128(sp)
    80004e76:	610d                	addi	sp,sp,160
    80004e78:	8082                	ret
    end_op();
    80004e7a:	ffffe097          	auipc	ra,0xffffe
    80004e7e:	7a2080e7          	jalr	1954(ra) # 8000361c <end_op>
    return -1;
    80004e82:	557d                	li	a0,-1
    80004e84:	b7ed                	j	80004e6e <sys_chdir+0x7a>
    iunlockput(ip);
    80004e86:	8526                	mv	a0,s1
    80004e88:	ffffe097          	auipc	ra,0xffffe
    80004e8c:	fac080e7          	jalr	-84(ra) # 80002e34 <iunlockput>
    end_op();
    80004e90:	ffffe097          	auipc	ra,0xffffe
    80004e94:	78c080e7          	jalr	1932(ra) # 8000361c <end_op>
    return -1;
    80004e98:	557d                	li	a0,-1
    80004e9a:	bfd1                	j	80004e6e <sys_chdir+0x7a>

0000000080004e9c <sys_exec>:

uint64
sys_exec(void)
{
    80004e9c:	7145                	addi	sp,sp,-464
    80004e9e:	e786                	sd	ra,456(sp)
    80004ea0:	e3a2                	sd	s0,448(sp)
    80004ea2:	ff26                	sd	s1,440(sp)
    80004ea4:	fb4a                	sd	s2,432(sp)
    80004ea6:	f74e                	sd	s3,424(sp)
    80004ea8:	f352                	sd	s4,416(sp)
    80004eaa:	ef56                	sd	s5,408(sp)
    80004eac:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004eae:	e3840593          	addi	a1,s0,-456
    80004eb2:	4505                	li	a0,1
    80004eb4:	ffffd097          	auipc	ra,0xffffd
    80004eb8:	128080e7          	jalr	296(ra) # 80001fdc <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004ebc:	08000613          	li	a2,128
    80004ec0:	f4040593          	addi	a1,s0,-192
    80004ec4:	4501                	li	a0,0
    80004ec6:	ffffd097          	auipc	ra,0xffffd
    80004eca:	136080e7          	jalr	310(ra) # 80001ffc <argstr>
    80004ece:	87aa                	mv	a5,a0
    return -1;
    80004ed0:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004ed2:	0c07c363          	bltz	a5,80004f98 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004ed6:	10000613          	li	a2,256
    80004eda:	4581                	li	a1,0
    80004edc:	e4040513          	addi	a0,s0,-448
    80004ee0:	ffffb097          	auipc	ra,0xffffb
    80004ee4:	29a080e7          	jalr	666(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ee8:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004eec:	89a6                	mv	s3,s1
    80004eee:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004ef0:	02000a13          	li	s4,32
    80004ef4:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004ef8:	00391513          	slli	a0,s2,0x3
    80004efc:	e3040593          	addi	a1,s0,-464
    80004f00:	e3843783          	ld	a5,-456(s0)
    80004f04:	953e                	add	a0,a0,a5
    80004f06:	ffffd097          	auipc	ra,0xffffd
    80004f0a:	018080e7          	jalr	24(ra) # 80001f1e <fetchaddr>
    80004f0e:	02054a63          	bltz	a0,80004f42 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004f12:	e3043783          	ld	a5,-464(s0)
    80004f16:	c3b9                	beqz	a5,80004f5c <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f18:	ffffb097          	auipc	ra,0xffffb
    80004f1c:	202080e7          	jalr	514(ra) # 8000011a <kalloc>
    80004f20:	85aa                	mv	a1,a0
    80004f22:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f26:	cd11                	beqz	a0,80004f42 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f28:	6605                	lui	a2,0x1
    80004f2a:	e3043503          	ld	a0,-464(s0)
    80004f2e:	ffffd097          	auipc	ra,0xffffd
    80004f32:	042080e7          	jalr	66(ra) # 80001f70 <fetchstr>
    80004f36:	00054663          	bltz	a0,80004f42 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004f3a:	0905                	addi	s2,s2,1
    80004f3c:	09a1                	addi	s3,s3,8
    80004f3e:	fb491be3          	bne	s2,s4,80004ef4 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f42:	f4040913          	addi	s2,s0,-192
    80004f46:	6088                	ld	a0,0(s1)
    80004f48:	c539                	beqz	a0,80004f96 <sys_exec+0xfa>
    kfree(argv[i]);
    80004f4a:	ffffb097          	auipc	ra,0xffffb
    80004f4e:	0d2080e7          	jalr	210(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f52:	04a1                	addi	s1,s1,8
    80004f54:	ff2499e3          	bne	s1,s2,80004f46 <sys_exec+0xaa>
  return -1;
    80004f58:	557d                	li	a0,-1
    80004f5a:	a83d                	j	80004f98 <sys_exec+0xfc>
      argv[i] = 0;
    80004f5c:	0a8e                	slli	s5,s5,0x3
    80004f5e:	fc0a8793          	addi	a5,s5,-64
    80004f62:	00878ab3          	add	s5,a5,s0
    80004f66:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f6a:	e4040593          	addi	a1,s0,-448
    80004f6e:	f4040513          	addi	a0,s0,-192
    80004f72:	fffff097          	auipc	ra,0xfffff
    80004f76:	16e080e7          	jalr	366(ra) # 800040e0 <exec>
    80004f7a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f7c:	f4040993          	addi	s3,s0,-192
    80004f80:	6088                	ld	a0,0(s1)
    80004f82:	c901                	beqz	a0,80004f92 <sys_exec+0xf6>
    kfree(argv[i]);
    80004f84:	ffffb097          	auipc	ra,0xffffb
    80004f88:	098080e7          	jalr	152(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f8c:	04a1                	addi	s1,s1,8
    80004f8e:	ff3499e3          	bne	s1,s3,80004f80 <sys_exec+0xe4>
  return ret;
    80004f92:	854a                	mv	a0,s2
    80004f94:	a011                	j	80004f98 <sys_exec+0xfc>
  return -1;
    80004f96:	557d                	li	a0,-1
}
    80004f98:	60be                	ld	ra,456(sp)
    80004f9a:	641e                	ld	s0,448(sp)
    80004f9c:	74fa                	ld	s1,440(sp)
    80004f9e:	795a                	ld	s2,432(sp)
    80004fa0:	79ba                	ld	s3,424(sp)
    80004fa2:	7a1a                	ld	s4,416(sp)
    80004fa4:	6afa                	ld	s5,408(sp)
    80004fa6:	6179                	addi	sp,sp,464
    80004fa8:	8082                	ret

0000000080004faa <sys_pipe>:

uint64
sys_pipe(void)
{
    80004faa:	7139                	addi	sp,sp,-64
    80004fac:	fc06                	sd	ra,56(sp)
    80004fae:	f822                	sd	s0,48(sp)
    80004fb0:	f426                	sd	s1,40(sp)
    80004fb2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004fb4:	ffffc097          	auipc	ra,0xffffc
    80004fb8:	ea0080e7          	jalr	-352(ra) # 80000e54 <myproc>
    80004fbc:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004fbe:	fd840593          	addi	a1,s0,-40
    80004fc2:	4501                	li	a0,0
    80004fc4:	ffffd097          	auipc	ra,0xffffd
    80004fc8:	018080e7          	jalr	24(ra) # 80001fdc <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004fcc:	fc840593          	addi	a1,s0,-56
    80004fd0:	fd040513          	addi	a0,s0,-48
    80004fd4:	fffff097          	auipc	ra,0xfffff
    80004fd8:	dc2080e7          	jalr	-574(ra) # 80003d96 <pipealloc>
    return -1;
    80004fdc:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fde:	0c054463          	bltz	a0,800050a6 <sys_pipe+0xfc>
  fd0 = -1;
    80004fe2:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fe6:	fd043503          	ld	a0,-48(s0)
    80004fea:	fffff097          	auipc	ra,0xfffff
    80004fee:	514080e7          	jalr	1300(ra) # 800044fe <fdalloc>
    80004ff2:	fca42223          	sw	a0,-60(s0)
    80004ff6:	08054b63          	bltz	a0,8000508c <sys_pipe+0xe2>
    80004ffa:	fc843503          	ld	a0,-56(s0)
    80004ffe:	fffff097          	auipc	ra,0xfffff
    80005002:	500080e7          	jalr	1280(ra) # 800044fe <fdalloc>
    80005006:	fca42023          	sw	a0,-64(s0)
    8000500a:	06054863          	bltz	a0,8000507a <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000500e:	4691                	li	a3,4
    80005010:	fc440613          	addi	a2,s0,-60
    80005014:	fd843583          	ld	a1,-40(s0)
    80005018:	68a8                	ld	a0,80(s1)
    8000501a:	ffffc097          	auipc	ra,0xffffc
    8000501e:	afa080e7          	jalr	-1286(ra) # 80000b14 <copyout>
    80005022:	02054063          	bltz	a0,80005042 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005026:	4691                	li	a3,4
    80005028:	fc040613          	addi	a2,s0,-64
    8000502c:	fd843583          	ld	a1,-40(s0)
    80005030:	0591                	addi	a1,a1,4
    80005032:	68a8                	ld	a0,80(s1)
    80005034:	ffffc097          	auipc	ra,0xffffc
    80005038:	ae0080e7          	jalr	-1312(ra) # 80000b14 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000503c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000503e:	06055463          	bgez	a0,800050a6 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005042:	fc442783          	lw	a5,-60(s0)
    80005046:	07e9                	addi	a5,a5,26
    80005048:	078e                	slli	a5,a5,0x3
    8000504a:	97a6                	add	a5,a5,s1
    8000504c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005050:	fc042783          	lw	a5,-64(s0)
    80005054:	07e9                	addi	a5,a5,26
    80005056:	078e                	slli	a5,a5,0x3
    80005058:	94be                	add	s1,s1,a5
    8000505a:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000505e:	fd043503          	ld	a0,-48(s0)
    80005062:	fffff097          	auipc	ra,0xfffff
    80005066:	a04080e7          	jalr	-1532(ra) # 80003a66 <fileclose>
    fileclose(wf);
    8000506a:	fc843503          	ld	a0,-56(s0)
    8000506e:	fffff097          	auipc	ra,0xfffff
    80005072:	9f8080e7          	jalr	-1544(ra) # 80003a66 <fileclose>
    return -1;
    80005076:	57fd                	li	a5,-1
    80005078:	a03d                	j	800050a6 <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000507a:	fc442783          	lw	a5,-60(s0)
    8000507e:	0007c763          	bltz	a5,8000508c <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005082:	07e9                	addi	a5,a5,26
    80005084:	078e                	slli	a5,a5,0x3
    80005086:	97a6                	add	a5,a5,s1
    80005088:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000508c:	fd043503          	ld	a0,-48(s0)
    80005090:	fffff097          	auipc	ra,0xfffff
    80005094:	9d6080e7          	jalr	-1578(ra) # 80003a66 <fileclose>
    fileclose(wf);
    80005098:	fc843503          	ld	a0,-56(s0)
    8000509c:	fffff097          	auipc	ra,0xfffff
    800050a0:	9ca080e7          	jalr	-1590(ra) # 80003a66 <fileclose>
    return -1;
    800050a4:	57fd                	li	a5,-1
}
    800050a6:	853e                	mv	a0,a5
    800050a8:	70e2                	ld	ra,56(sp)
    800050aa:	7442                	ld	s0,48(sp)
    800050ac:	74a2                	ld	s1,40(sp)
    800050ae:	6121                	addi	sp,sp,64
    800050b0:	8082                	ret
	...

00000000800050c0 <kernelvec>:
    800050c0:	7111                	addi	sp,sp,-256
    800050c2:	e006                	sd	ra,0(sp)
    800050c4:	e40a                	sd	sp,8(sp)
    800050c6:	e80e                	sd	gp,16(sp)
    800050c8:	ec12                	sd	tp,24(sp)
    800050ca:	f016                	sd	t0,32(sp)
    800050cc:	f41a                	sd	t1,40(sp)
    800050ce:	f81e                	sd	t2,48(sp)
    800050d0:	fc22                	sd	s0,56(sp)
    800050d2:	e0a6                	sd	s1,64(sp)
    800050d4:	e4aa                	sd	a0,72(sp)
    800050d6:	e8ae                	sd	a1,80(sp)
    800050d8:	ecb2                	sd	a2,88(sp)
    800050da:	f0b6                	sd	a3,96(sp)
    800050dc:	f4ba                	sd	a4,104(sp)
    800050de:	f8be                	sd	a5,112(sp)
    800050e0:	fcc2                	sd	a6,120(sp)
    800050e2:	e146                	sd	a7,128(sp)
    800050e4:	e54a                	sd	s2,136(sp)
    800050e6:	e94e                	sd	s3,144(sp)
    800050e8:	ed52                	sd	s4,152(sp)
    800050ea:	f156                	sd	s5,160(sp)
    800050ec:	f55a                	sd	s6,168(sp)
    800050ee:	f95e                	sd	s7,176(sp)
    800050f0:	fd62                	sd	s8,184(sp)
    800050f2:	e1e6                	sd	s9,192(sp)
    800050f4:	e5ea                	sd	s10,200(sp)
    800050f6:	e9ee                	sd	s11,208(sp)
    800050f8:	edf2                	sd	t3,216(sp)
    800050fa:	f1f6                	sd	t4,224(sp)
    800050fc:	f5fa                	sd	t5,232(sp)
    800050fe:	f9fe                	sd	t6,240(sp)
    80005100:	cebfc0ef          	jal	ra,80001dea <kerneltrap>
    80005104:	6082                	ld	ra,0(sp)
    80005106:	6122                	ld	sp,8(sp)
    80005108:	61c2                	ld	gp,16(sp)
    8000510a:	7282                	ld	t0,32(sp)
    8000510c:	7322                	ld	t1,40(sp)
    8000510e:	73c2                	ld	t2,48(sp)
    80005110:	7462                	ld	s0,56(sp)
    80005112:	6486                	ld	s1,64(sp)
    80005114:	6526                	ld	a0,72(sp)
    80005116:	65c6                	ld	a1,80(sp)
    80005118:	6666                	ld	a2,88(sp)
    8000511a:	7686                	ld	a3,96(sp)
    8000511c:	7726                	ld	a4,104(sp)
    8000511e:	77c6                	ld	a5,112(sp)
    80005120:	7866                	ld	a6,120(sp)
    80005122:	688a                	ld	a7,128(sp)
    80005124:	692a                	ld	s2,136(sp)
    80005126:	69ca                	ld	s3,144(sp)
    80005128:	6a6a                	ld	s4,152(sp)
    8000512a:	7a8a                	ld	s5,160(sp)
    8000512c:	7b2a                	ld	s6,168(sp)
    8000512e:	7bca                	ld	s7,176(sp)
    80005130:	7c6a                	ld	s8,184(sp)
    80005132:	6c8e                	ld	s9,192(sp)
    80005134:	6d2e                	ld	s10,200(sp)
    80005136:	6dce                	ld	s11,208(sp)
    80005138:	6e6e                	ld	t3,216(sp)
    8000513a:	7e8e                	ld	t4,224(sp)
    8000513c:	7f2e                	ld	t5,232(sp)
    8000513e:	7fce                	ld	t6,240(sp)
    80005140:	6111                	addi	sp,sp,256
    80005142:	10200073          	sret
    80005146:	00000013          	nop
    8000514a:	00000013          	nop
    8000514e:	0001                	nop

0000000080005150 <timervec>:
    80005150:	34051573          	csrrw	a0,mscratch,a0
    80005154:	e10c                	sd	a1,0(a0)
    80005156:	e510                	sd	a2,8(a0)
    80005158:	e914                	sd	a3,16(a0)
    8000515a:	6d0c                	ld	a1,24(a0)
    8000515c:	7110                	ld	a2,32(a0)
    8000515e:	6194                	ld	a3,0(a1)
    80005160:	96b2                	add	a3,a3,a2
    80005162:	e194                	sd	a3,0(a1)
    80005164:	4589                	li	a1,2
    80005166:	14459073          	csrw	sip,a1
    8000516a:	6914                	ld	a3,16(a0)
    8000516c:	6510                	ld	a2,8(a0)
    8000516e:	610c                	ld	a1,0(a0)
    80005170:	34051573          	csrrw	a0,mscratch,a0
    80005174:	30200073          	mret
	...

000000008000517a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000517a:	1141                	addi	sp,sp,-16
    8000517c:	e422                	sd	s0,8(sp)
    8000517e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005180:	0c0007b7          	lui	a5,0xc000
    80005184:	4705                	li	a4,1
    80005186:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005188:	c3d8                	sw	a4,4(a5)
}
    8000518a:	6422                	ld	s0,8(sp)
    8000518c:	0141                	addi	sp,sp,16
    8000518e:	8082                	ret

0000000080005190 <plicinithart>:

void
plicinithart(void)
{
    80005190:	1141                	addi	sp,sp,-16
    80005192:	e406                	sd	ra,8(sp)
    80005194:	e022                	sd	s0,0(sp)
    80005196:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005198:	ffffc097          	auipc	ra,0xffffc
    8000519c:	c90080e7          	jalr	-880(ra) # 80000e28 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800051a0:	0085171b          	slliw	a4,a0,0x8
    800051a4:	0c0027b7          	lui	a5,0xc002
    800051a8:	97ba                	add	a5,a5,a4
    800051aa:	40200713          	li	a4,1026
    800051ae:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800051b2:	00d5151b          	slliw	a0,a0,0xd
    800051b6:	0c2017b7          	lui	a5,0xc201
    800051ba:	97aa                	add	a5,a5,a0
    800051bc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800051c0:	60a2                	ld	ra,8(sp)
    800051c2:	6402                	ld	s0,0(sp)
    800051c4:	0141                	addi	sp,sp,16
    800051c6:	8082                	ret

00000000800051c8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800051c8:	1141                	addi	sp,sp,-16
    800051ca:	e406                	sd	ra,8(sp)
    800051cc:	e022                	sd	s0,0(sp)
    800051ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051d0:	ffffc097          	auipc	ra,0xffffc
    800051d4:	c58080e7          	jalr	-936(ra) # 80000e28 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051d8:	00d5151b          	slliw	a0,a0,0xd
    800051dc:	0c2017b7          	lui	a5,0xc201
    800051e0:	97aa                	add	a5,a5,a0
  return irq;
}
    800051e2:	43c8                	lw	a0,4(a5)
    800051e4:	60a2                	ld	ra,8(sp)
    800051e6:	6402                	ld	s0,0(sp)
    800051e8:	0141                	addi	sp,sp,16
    800051ea:	8082                	ret

00000000800051ec <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051ec:	1101                	addi	sp,sp,-32
    800051ee:	ec06                	sd	ra,24(sp)
    800051f0:	e822                	sd	s0,16(sp)
    800051f2:	e426                	sd	s1,8(sp)
    800051f4:	1000                	addi	s0,sp,32
    800051f6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051f8:	ffffc097          	auipc	ra,0xffffc
    800051fc:	c30080e7          	jalr	-976(ra) # 80000e28 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005200:	00d5151b          	slliw	a0,a0,0xd
    80005204:	0c2017b7          	lui	a5,0xc201
    80005208:	97aa                	add	a5,a5,a0
    8000520a:	c3c4                	sw	s1,4(a5)
}
    8000520c:	60e2                	ld	ra,24(sp)
    8000520e:	6442                	ld	s0,16(sp)
    80005210:	64a2                	ld	s1,8(sp)
    80005212:	6105                	addi	sp,sp,32
    80005214:	8082                	ret

0000000080005216 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005216:	1141                	addi	sp,sp,-16
    80005218:	e406                	sd	ra,8(sp)
    8000521a:	e022                	sd	s0,0(sp)
    8000521c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000521e:	479d                	li	a5,7
    80005220:	04a7cc63          	blt	a5,a0,80005278 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005224:	00015797          	auipc	a5,0x15
    80005228:	ddc78793          	addi	a5,a5,-548 # 8001a000 <disk>
    8000522c:	97aa                	add	a5,a5,a0
    8000522e:	0187c783          	lbu	a5,24(a5)
    80005232:	ebb9                	bnez	a5,80005288 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005234:	00451693          	slli	a3,a0,0x4
    80005238:	00015797          	auipc	a5,0x15
    8000523c:	dc878793          	addi	a5,a5,-568 # 8001a000 <disk>
    80005240:	6398                	ld	a4,0(a5)
    80005242:	9736                	add	a4,a4,a3
    80005244:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005248:	6398                	ld	a4,0(a5)
    8000524a:	9736                	add	a4,a4,a3
    8000524c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005250:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005254:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005258:	97aa                	add	a5,a5,a0
    8000525a:	4705                	li	a4,1
    8000525c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005260:	00015517          	auipc	a0,0x15
    80005264:	db850513          	addi	a0,a0,-584 # 8001a018 <disk+0x18>
    80005268:	ffffc097          	auipc	ra,0xffffc
    8000526c:	304080e7          	jalr	772(ra) # 8000156c <wakeup>
}
    80005270:	60a2                	ld	ra,8(sp)
    80005272:	6402                	ld	s0,0(sp)
    80005274:	0141                	addi	sp,sp,16
    80005276:	8082                	ret
    panic("free_desc 1");
    80005278:	00003517          	auipc	a0,0x3
    8000527c:	45850513          	addi	a0,a0,1112 # 800086d0 <syscalls+0x300>
    80005280:	00001097          	auipc	ra,0x1
    80005284:	a9a080e7          	jalr	-1382(ra) # 80005d1a <panic>
    panic("free_desc 2");
    80005288:	00003517          	auipc	a0,0x3
    8000528c:	45850513          	addi	a0,a0,1112 # 800086e0 <syscalls+0x310>
    80005290:	00001097          	auipc	ra,0x1
    80005294:	a8a080e7          	jalr	-1398(ra) # 80005d1a <panic>

0000000080005298 <virtio_disk_init>:
{
    80005298:	1101                	addi	sp,sp,-32
    8000529a:	ec06                	sd	ra,24(sp)
    8000529c:	e822                	sd	s0,16(sp)
    8000529e:	e426                	sd	s1,8(sp)
    800052a0:	e04a                	sd	s2,0(sp)
    800052a2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800052a4:	00003597          	auipc	a1,0x3
    800052a8:	44c58593          	addi	a1,a1,1100 # 800086f0 <syscalls+0x320>
    800052ac:	00015517          	auipc	a0,0x15
    800052b0:	e7c50513          	addi	a0,a0,-388 # 8001a128 <disk+0x128>
    800052b4:	00001097          	auipc	ra,0x1
    800052b8:	ee4080e7          	jalr	-284(ra) # 80006198 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052bc:	100017b7          	lui	a5,0x10001
    800052c0:	4398                	lw	a4,0(a5)
    800052c2:	2701                	sext.w	a4,a4
    800052c4:	747277b7          	lui	a5,0x74727
    800052c8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052cc:	14f71b63          	bne	a4,a5,80005422 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052d0:	100017b7          	lui	a5,0x10001
    800052d4:	43dc                	lw	a5,4(a5)
    800052d6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052d8:	4709                	li	a4,2
    800052da:	14e79463          	bne	a5,a4,80005422 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052de:	100017b7          	lui	a5,0x10001
    800052e2:	479c                	lw	a5,8(a5)
    800052e4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052e6:	12e79e63          	bne	a5,a4,80005422 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052ea:	100017b7          	lui	a5,0x10001
    800052ee:	47d8                	lw	a4,12(a5)
    800052f0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052f2:	554d47b7          	lui	a5,0x554d4
    800052f6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052fa:	12f71463          	bne	a4,a5,80005422 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052fe:	100017b7          	lui	a5,0x10001
    80005302:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005306:	4705                	li	a4,1
    80005308:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000530a:	470d                	li	a4,3
    8000530c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000530e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005310:	c7ffe6b7          	lui	a3,0xc7ffe
    80005314:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc3df>
    80005318:	8f75                	and	a4,a4,a3
    8000531a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000531c:	472d                	li	a4,11
    8000531e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005320:	5bbc                	lw	a5,112(a5)
    80005322:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005326:	8ba1                	andi	a5,a5,8
    80005328:	10078563          	beqz	a5,80005432 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000532c:	100017b7          	lui	a5,0x10001
    80005330:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005334:	43fc                	lw	a5,68(a5)
    80005336:	2781                	sext.w	a5,a5
    80005338:	10079563          	bnez	a5,80005442 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000533c:	100017b7          	lui	a5,0x10001
    80005340:	5bdc                	lw	a5,52(a5)
    80005342:	2781                	sext.w	a5,a5
  if(max == 0)
    80005344:	10078763          	beqz	a5,80005452 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005348:	471d                	li	a4,7
    8000534a:	10f77c63          	bgeu	a4,a5,80005462 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000534e:	ffffb097          	auipc	ra,0xffffb
    80005352:	dcc080e7          	jalr	-564(ra) # 8000011a <kalloc>
    80005356:	00015497          	auipc	s1,0x15
    8000535a:	caa48493          	addi	s1,s1,-854 # 8001a000 <disk>
    8000535e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005360:	ffffb097          	auipc	ra,0xffffb
    80005364:	dba080e7          	jalr	-582(ra) # 8000011a <kalloc>
    80005368:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000536a:	ffffb097          	auipc	ra,0xffffb
    8000536e:	db0080e7          	jalr	-592(ra) # 8000011a <kalloc>
    80005372:	87aa                	mv	a5,a0
    80005374:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005376:	6088                	ld	a0,0(s1)
    80005378:	cd6d                	beqz	a0,80005472 <virtio_disk_init+0x1da>
    8000537a:	00015717          	auipc	a4,0x15
    8000537e:	c8e73703          	ld	a4,-882(a4) # 8001a008 <disk+0x8>
    80005382:	cb65                	beqz	a4,80005472 <virtio_disk_init+0x1da>
    80005384:	c7fd                	beqz	a5,80005472 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005386:	6605                	lui	a2,0x1
    80005388:	4581                	li	a1,0
    8000538a:	ffffb097          	auipc	ra,0xffffb
    8000538e:	df0080e7          	jalr	-528(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    80005392:	00015497          	auipc	s1,0x15
    80005396:	c6e48493          	addi	s1,s1,-914 # 8001a000 <disk>
    8000539a:	6605                	lui	a2,0x1
    8000539c:	4581                	li	a1,0
    8000539e:	6488                	ld	a0,8(s1)
    800053a0:	ffffb097          	auipc	ra,0xffffb
    800053a4:	dda080e7          	jalr	-550(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    800053a8:	6605                	lui	a2,0x1
    800053aa:	4581                	li	a1,0
    800053ac:	6888                	ld	a0,16(s1)
    800053ae:	ffffb097          	auipc	ra,0xffffb
    800053b2:	dcc080e7          	jalr	-564(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800053b6:	100017b7          	lui	a5,0x10001
    800053ba:	4721                	li	a4,8
    800053bc:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800053be:	4098                	lw	a4,0(s1)
    800053c0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800053c4:	40d8                	lw	a4,4(s1)
    800053c6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800053ca:	6498                	ld	a4,8(s1)
    800053cc:	0007069b          	sext.w	a3,a4
    800053d0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800053d4:	9701                	srai	a4,a4,0x20
    800053d6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800053da:	6898                	ld	a4,16(s1)
    800053dc:	0007069b          	sext.w	a3,a4
    800053e0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800053e4:	9701                	srai	a4,a4,0x20
    800053e6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800053ea:	4705                	li	a4,1
    800053ec:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800053ee:	00e48c23          	sb	a4,24(s1)
    800053f2:	00e48ca3          	sb	a4,25(s1)
    800053f6:	00e48d23          	sb	a4,26(s1)
    800053fa:	00e48da3          	sb	a4,27(s1)
    800053fe:	00e48e23          	sb	a4,28(s1)
    80005402:	00e48ea3          	sb	a4,29(s1)
    80005406:	00e48f23          	sb	a4,30(s1)
    8000540a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000540e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005412:	0727a823          	sw	s2,112(a5)
}
    80005416:	60e2                	ld	ra,24(sp)
    80005418:	6442                	ld	s0,16(sp)
    8000541a:	64a2                	ld	s1,8(sp)
    8000541c:	6902                	ld	s2,0(sp)
    8000541e:	6105                	addi	sp,sp,32
    80005420:	8082                	ret
    panic("could not find virtio disk");
    80005422:	00003517          	auipc	a0,0x3
    80005426:	2de50513          	addi	a0,a0,734 # 80008700 <syscalls+0x330>
    8000542a:	00001097          	auipc	ra,0x1
    8000542e:	8f0080e7          	jalr	-1808(ra) # 80005d1a <panic>
    panic("virtio disk FEATURES_OK unset");
    80005432:	00003517          	auipc	a0,0x3
    80005436:	2ee50513          	addi	a0,a0,750 # 80008720 <syscalls+0x350>
    8000543a:	00001097          	auipc	ra,0x1
    8000543e:	8e0080e7          	jalr	-1824(ra) # 80005d1a <panic>
    panic("virtio disk should not be ready");
    80005442:	00003517          	auipc	a0,0x3
    80005446:	2fe50513          	addi	a0,a0,766 # 80008740 <syscalls+0x370>
    8000544a:	00001097          	auipc	ra,0x1
    8000544e:	8d0080e7          	jalr	-1840(ra) # 80005d1a <panic>
    panic("virtio disk has no queue 0");
    80005452:	00003517          	auipc	a0,0x3
    80005456:	30e50513          	addi	a0,a0,782 # 80008760 <syscalls+0x390>
    8000545a:	00001097          	auipc	ra,0x1
    8000545e:	8c0080e7          	jalr	-1856(ra) # 80005d1a <panic>
    panic("virtio disk max queue too short");
    80005462:	00003517          	auipc	a0,0x3
    80005466:	31e50513          	addi	a0,a0,798 # 80008780 <syscalls+0x3b0>
    8000546a:	00001097          	auipc	ra,0x1
    8000546e:	8b0080e7          	jalr	-1872(ra) # 80005d1a <panic>
    panic("virtio disk kalloc");
    80005472:	00003517          	auipc	a0,0x3
    80005476:	32e50513          	addi	a0,a0,814 # 800087a0 <syscalls+0x3d0>
    8000547a:	00001097          	auipc	ra,0x1
    8000547e:	8a0080e7          	jalr	-1888(ra) # 80005d1a <panic>

0000000080005482 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005482:	7119                	addi	sp,sp,-128
    80005484:	fc86                	sd	ra,120(sp)
    80005486:	f8a2                	sd	s0,112(sp)
    80005488:	f4a6                	sd	s1,104(sp)
    8000548a:	f0ca                	sd	s2,96(sp)
    8000548c:	ecce                	sd	s3,88(sp)
    8000548e:	e8d2                	sd	s4,80(sp)
    80005490:	e4d6                	sd	s5,72(sp)
    80005492:	e0da                	sd	s6,64(sp)
    80005494:	fc5e                	sd	s7,56(sp)
    80005496:	f862                	sd	s8,48(sp)
    80005498:	f466                	sd	s9,40(sp)
    8000549a:	f06a                	sd	s10,32(sp)
    8000549c:	ec6e                	sd	s11,24(sp)
    8000549e:	0100                	addi	s0,sp,128
    800054a0:	8aaa                	mv	s5,a0
    800054a2:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800054a4:	00c52d03          	lw	s10,12(a0)
    800054a8:	001d1d1b          	slliw	s10,s10,0x1
    800054ac:	1d02                	slli	s10,s10,0x20
    800054ae:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    800054b2:	00015517          	auipc	a0,0x15
    800054b6:	c7650513          	addi	a0,a0,-906 # 8001a128 <disk+0x128>
    800054ba:	00001097          	auipc	ra,0x1
    800054be:	d6e080e7          	jalr	-658(ra) # 80006228 <acquire>
  for(int i = 0; i < 3; i++){
    800054c2:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800054c4:	44a1                	li	s1,8
      disk.free[i] = 0;
    800054c6:	00015b97          	auipc	s7,0x15
    800054ca:	b3ab8b93          	addi	s7,s7,-1222 # 8001a000 <disk>
  for(int i = 0; i < 3; i++){
    800054ce:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054d0:	00015c97          	auipc	s9,0x15
    800054d4:	c58c8c93          	addi	s9,s9,-936 # 8001a128 <disk+0x128>
    800054d8:	a08d                	j	8000553a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800054da:	00fb8733          	add	a4,s7,a5
    800054de:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800054e2:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800054e4:	0207c563          	bltz	a5,8000550e <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800054e8:	2905                	addiw	s2,s2,1
    800054ea:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800054ec:	05690c63          	beq	s2,s6,80005544 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800054f0:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800054f2:	00015717          	auipc	a4,0x15
    800054f6:	b0e70713          	addi	a4,a4,-1266 # 8001a000 <disk>
    800054fa:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800054fc:	01874683          	lbu	a3,24(a4)
    80005500:	fee9                	bnez	a3,800054da <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005502:	2785                	addiw	a5,a5,1
    80005504:	0705                	addi	a4,a4,1
    80005506:	fe979be3          	bne	a5,s1,800054fc <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000550a:	57fd                	li	a5,-1
    8000550c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000550e:	01205d63          	blez	s2,80005528 <virtio_disk_rw+0xa6>
    80005512:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005514:	000a2503          	lw	a0,0(s4)
    80005518:	00000097          	auipc	ra,0x0
    8000551c:	cfe080e7          	jalr	-770(ra) # 80005216 <free_desc>
      for(int j = 0; j < i; j++)
    80005520:	2d85                	addiw	s11,s11,1
    80005522:	0a11                	addi	s4,s4,4
    80005524:	ff2d98e3          	bne	s11,s2,80005514 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005528:	85e6                	mv	a1,s9
    8000552a:	00015517          	auipc	a0,0x15
    8000552e:	aee50513          	addi	a0,a0,-1298 # 8001a018 <disk+0x18>
    80005532:	ffffc097          	auipc	ra,0xffffc
    80005536:	fd6080e7          	jalr	-42(ra) # 80001508 <sleep>
  for(int i = 0; i < 3; i++){
    8000553a:	f8040a13          	addi	s4,s0,-128
{
    8000553e:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005540:	894e                	mv	s2,s3
    80005542:	b77d                	j	800054f0 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005544:	f8042503          	lw	a0,-128(s0)
    80005548:	00a50713          	addi	a4,a0,10
    8000554c:	0712                	slli	a4,a4,0x4

  if(write)
    8000554e:	00015797          	auipc	a5,0x15
    80005552:	ab278793          	addi	a5,a5,-1358 # 8001a000 <disk>
    80005556:	00e786b3          	add	a3,a5,a4
    8000555a:	01803633          	snez	a2,s8
    8000555e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005560:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005564:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005568:	f6070613          	addi	a2,a4,-160
    8000556c:	6394                	ld	a3,0(a5)
    8000556e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005570:	00870593          	addi	a1,a4,8
    80005574:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005576:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005578:	0007b803          	ld	a6,0(a5)
    8000557c:	9642                	add	a2,a2,a6
    8000557e:	46c1                	li	a3,16
    80005580:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005582:	4585                	li	a1,1
    80005584:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005588:	f8442683          	lw	a3,-124(s0)
    8000558c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005590:	0692                	slli	a3,a3,0x4
    80005592:	9836                	add	a6,a6,a3
    80005594:	058a8613          	addi	a2,s5,88
    80005598:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000559c:	0007b803          	ld	a6,0(a5)
    800055a0:	96c2                	add	a3,a3,a6
    800055a2:	40000613          	li	a2,1024
    800055a6:	c690                	sw	a2,8(a3)
  if(write)
    800055a8:	001c3613          	seqz	a2,s8
    800055ac:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055b0:	00166613          	ori	a2,a2,1
    800055b4:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800055b8:	f8842603          	lw	a2,-120(s0)
    800055bc:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800055c0:	00250693          	addi	a3,a0,2
    800055c4:	0692                	slli	a3,a3,0x4
    800055c6:	96be                	add	a3,a3,a5
    800055c8:	58fd                	li	a7,-1
    800055ca:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800055ce:	0612                	slli	a2,a2,0x4
    800055d0:	9832                	add	a6,a6,a2
    800055d2:	f9070713          	addi	a4,a4,-112
    800055d6:	973e                	add	a4,a4,a5
    800055d8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800055dc:	6398                	ld	a4,0(a5)
    800055de:	9732                	add	a4,a4,a2
    800055e0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800055e2:	4609                	li	a2,2
    800055e4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800055e8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800055ec:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    800055f0:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800055f4:	6794                	ld	a3,8(a5)
    800055f6:	0026d703          	lhu	a4,2(a3)
    800055fa:	8b1d                	andi	a4,a4,7
    800055fc:	0706                	slli	a4,a4,0x1
    800055fe:	96ba                	add	a3,a3,a4
    80005600:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005604:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005608:	6798                	ld	a4,8(a5)
    8000560a:	00275783          	lhu	a5,2(a4)
    8000560e:	2785                	addiw	a5,a5,1
    80005610:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005614:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005618:	100017b7          	lui	a5,0x10001
    8000561c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005620:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    80005624:	00015917          	auipc	s2,0x15
    80005628:	b0490913          	addi	s2,s2,-1276 # 8001a128 <disk+0x128>
  while(b->disk == 1) {
    8000562c:	4485                	li	s1,1
    8000562e:	00b79c63          	bne	a5,a1,80005646 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005632:	85ca                	mv	a1,s2
    80005634:	8556                	mv	a0,s5
    80005636:	ffffc097          	auipc	ra,0xffffc
    8000563a:	ed2080e7          	jalr	-302(ra) # 80001508 <sleep>
  while(b->disk == 1) {
    8000563e:	004aa783          	lw	a5,4(s5)
    80005642:	fe9788e3          	beq	a5,s1,80005632 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005646:	f8042903          	lw	s2,-128(s0)
    8000564a:	00290713          	addi	a4,s2,2
    8000564e:	0712                	slli	a4,a4,0x4
    80005650:	00015797          	auipc	a5,0x15
    80005654:	9b078793          	addi	a5,a5,-1616 # 8001a000 <disk>
    80005658:	97ba                	add	a5,a5,a4
    8000565a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000565e:	00015997          	auipc	s3,0x15
    80005662:	9a298993          	addi	s3,s3,-1630 # 8001a000 <disk>
    80005666:	00491713          	slli	a4,s2,0x4
    8000566a:	0009b783          	ld	a5,0(s3)
    8000566e:	97ba                	add	a5,a5,a4
    80005670:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005674:	854a                	mv	a0,s2
    80005676:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000567a:	00000097          	auipc	ra,0x0
    8000567e:	b9c080e7          	jalr	-1124(ra) # 80005216 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005682:	8885                	andi	s1,s1,1
    80005684:	f0ed                	bnez	s1,80005666 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005686:	00015517          	auipc	a0,0x15
    8000568a:	aa250513          	addi	a0,a0,-1374 # 8001a128 <disk+0x128>
    8000568e:	00001097          	auipc	ra,0x1
    80005692:	c4e080e7          	jalr	-946(ra) # 800062dc <release>
}
    80005696:	70e6                	ld	ra,120(sp)
    80005698:	7446                	ld	s0,112(sp)
    8000569a:	74a6                	ld	s1,104(sp)
    8000569c:	7906                	ld	s2,96(sp)
    8000569e:	69e6                	ld	s3,88(sp)
    800056a0:	6a46                	ld	s4,80(sp)
    800056a2:	6aa6                	ld	s5,72(sp)
    800056a4:	6b06                	ld	s6,64(sp)
    800056a6:	7be2                	ld	s7,56(sp)
    800056a8:	7c42                	ld	s8,48(sp)
    800056aa:	7ca2                	ld	s9,40(sp)
    800056ac:	7d02                	ld	s10,32(sp)
    800056ae:	6de2                	ld	s11,24(sp)
    800056b0:	6109                	addi	sp,sp,128
    800056b2:	8082                	ret

00000000800056b4 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800056b4:	1101                	addi	sp,sp,-32
    800056b6:	ec06                	sd	ra,24(sp)
    800056b8:	e822                	sd	s0,16(sp)
    800056ba:	e426                	sd	s1,8(sp)
    800056bc:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800056be:	00015497          	auipc	s1,0x15
    800056c2:	94248493          	addi	s1,s1,-1726 # 8001a000 <disk>
    800056c6:	00015517          	auipc	a0,0x15
    800056ca:	a6250513          	addi	a0,a0,-1438 # 8001a128 <disk+0x128>
    800056ce:	00001097          	auipc	ra,0x1
    800056d2:	b5a080e7          	jalr	-1190(ra) # 80006228 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056d6:	10001737          	lui	a4,0x10001
    800056da:	533c                	lw	a5,96(a4)
    800056dc:	8b8d                	andi	a5,a5,3
    800056de:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800056e0:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800056e4:	689c                	ld	a5,16(s1)
    800056e6:	0204d703          	lhu	a4,32(s1)
    800056ea:	0027d783          	lhu	a5,2(a5)
    800056ee:	04f70863          	beq	a4,a5,8000573e <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800056f2:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056f6:	6898                	ld	a4,16(s1)
    800056f8:	0204d783          	lhu	a5,32(s1)
    800056fc:	8b9d                	andi	a5,a5,7
    800056fe:	078e                	slli	a5,a5,0x3
    80005700:	97ba                	add	a5,a5,a4
    80005702:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005704:	00278713          	addi	a4,a5,2
    80005708:	0712                	slli	a4,a4,0x4
    8000570a:	9726                	add	a4,a4,s1
    8000570c:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005710:	e721                	bnez	a4,80005758 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005712:	0789                	addi	a5,a5,2
    80005714:	0792                	slli	a5,a5,0x4
    80005716:	97a6                	add	a5,a5,s1
    80005718:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000571a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000571e:	ffffc097          	auipc	ra,0xffffc
    80005722:	e4e080e7          	jalr	-434(ra) # 8000156c <wakeup>

    disk.used_idx += 1;
    80005726:	0204d783          	lhu	a5,32(s1)
    8000572a:	2785                	addiw	a5,a5,1
    8000572c:	17c2                	slli	a5,a5,0x30
    8000572e:	93c1                	srli	a5,a5,0x30
    80005730:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005734:	6898                	ld	a4,16(s1)
    80005736:	00275703          	lhu	a4,2(a4)
    8000573a:	faf71ce3          	bne	a4,a5,800056f2 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000573e:	00015517          	auipc	a0,0x15
    80005742:	9ea50513          	addi	a0,a0,-1558 # 8001a128 <disk+0x128>
    80005746:	00001097          	auipc	ra,0x1
    8000574a:	b96080e7          	jalr	-1130(ra) # 800062dc <release>
}
    8000574e:	60e2                	ld	ra,24(sp)
    80005750:	6442                	ld	s0,16(sp)
    80005752:	64a2                	ld	s1,8(sp)
    80005754:	6105                	addi	sp,sp,32
    80005756:	8082                	ret
      panic("virtio_disk_intr status");
    80005758:	00003517          	auipc	a0,0x3
    8000575c:	06050513          	addi	a0,a0,96 # 800087b8 <syscalls+0x3e8>
    80005760:	00000097          	auipc	ra,0x0
    80005764:	5ba080e7          	jalr	1466(ra) # 80005d1a <panic>

0000000080005768 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005768:	1141                	addi	sp,sp,-16
    8000576a:	e422                	sd	s0,8(sp)
    8000576c:	0800                	addi	s0,sp,16
    asm volatile("csrr %0, mhartid" : "=r"(x));
    8000576e:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005772:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005776:	0037979b          	slliw	a5,a5,0x3
    8000577a:	02004737          	lui	a4,0x2004
    8000577e:	97ba                	add	a5,a5,a4
    80005780:	0200c737          	lui	a4,0x200c
    80005784:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005788:	000f4637          	lui	a2,0xf4
    8000578c:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005790:	9732                	add	a4,a4,a2
    80005792:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005794:	00259693          	slli	a3,a1,0x2
    80005798:	96ae                	add	a3,a3,a1
    8000579a:	068e                	slli	a3,a3,0x3
    8000579c:	00015717          	auipc	a4,0x15
    800057a0:	9a470713          	addi	a4,a4,-1628 # 8001a140 <timer_scratch>
    800057a4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800057a6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800057a8:	f310                	sd	a2,32(a4)
    asm volatile("csrw mscratch, %0" : : "r"(x));
    800057aa:	34071073          	csrw	mscratch,a4
    asm volatile("csrw mtvec, %0" : : "r"(x));
    800057ae:	00000797          	auipc	a5,0x0
    800057b2:	9a278793          	addi	a5,a5,-1630 # 80005150 <timervec>
    800057b6:	30579073          	csrw	mtvec,a5
    asm volatile("csrr %0, mstatus" : "=r"(x));
    800057ba:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800057be:	0087e793          	ori	a5,a5,8
    asm volatile("csrw mstatus, %0" : : "r"(x));
    800057c2:	30079073          	csrw	mstatus,a5
    asm volatile("csrr %0, mie" : "=r"(x));
    800057c6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800057ca:	0807e793          	ori	a5,a5,128
    asm volatile("csrw mie, %0" : : "r"(x));
    800057ce:	30479073          	csrw	mie,a5
}
    800057d2:	6422                	ld	s0,8(sp)
    800057d4:	0141                	addi	sp,sp,16
    800057d6:	8082                	ret

00000000800057d8 <start>:
{
    800057d8:	1141                	addi	sp,sp,-16
    800057da:	e406                	sd	ra,8(sp)
    800057dc:	e022                	sd	s0,0(sp)
    800057de:	0800                	addi	s0,sp,16
    asm volatile("csrr %0, mstatus" : "=r"(x));
    800057e0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057e4:	7779                	lui	a4,0xffffe
    800057e6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc47f>
    800057ea:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057ec:	6705                	lui	a4,0x1
    800057ee:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057f2:	8fd9                	or	a5,a5,a4
    asm volatile("csrw mstatus, %0" : : "r"(x));
    800057f4:	30079073          	csrw	mstatus,a5
    asm volatile("csrw mepc, %0" : : "r"(x));
    800057f8:	ffffb797          	auipc	a5,0xffffb
    800057fc:	b2878793          	addi	a5,a5,-1240 # 80000320 <main>
    80005800:	34179073          	csrw	mepc,a5
    asm volatile("csrw satp, %0" : : "r"(x));
    80005804:	4781                	li	a5,0
    80005806:	18079073          	csrw	satp,a5
    asm volatile("csrw medeleg, %0" : : "r"(x));
    8000580a:	67c1                	lui	a5,0x10
    8000580c:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000580e:	30279073          	csrw	medeleg,a5
    asm volatile("csrw mideleg, %0" : : "r"(x));
    80005812:	30379073          	csrw	mideleg,a5
    asm volatile("csrr %0, sie" : "=r"(x));
    80005816:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000581a:	2227e793          	ori	a5,a5,546
    asm volatile("csrw sie, %0" : : "r"(x));
    8000581e:	10479073          	csrw	sie,a5
    asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    80005822:	57fd                	li	a5,-1
    80005824:	83a9                	srli	a5,a5,0xa
    80005826:	3b079073          	csrw	pmpaddr0,a5
    asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    8000582a:	47bd                	li	a5,15
    8000582c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005830:	00000097          	auipc	ra,0x0
    80005834:	f38080e7          	jalr	-200(ra) # 80005768 <timerinit>
    asm volatile("csrr %0, mhartid" : "=r"(x));
    80005838:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000583c:	2781                	sext.w	a5,a5
    asm volatile("mv tp, %0" : : "r"(x));
    8000583e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005840:	30200073          	mret
}
    80005844:	60a2                	ld	ra,8(sp)
    80005846:	6402                	ld	s0,0(sp)
    80005848:	0141                	addi	sp,sp,16
    8000584a:	8082                	ret

000000008000584c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000584c:	715d                	addi	sp,sp,-80
    8000584e:	e486                	sd	ra,72(sp)
    80005850:	e0a2                	sd	s0,64(sp)
    80005852:	fc26                	sd	s1,56(sp)
    80005854:	f84a                	sd	s2,48(sp)
    80005856:	f44e                	sd	s3,40(sp)
    80005858:	f052                	sd	s4,32(sp)
    8000585a:	ec56                	sd	s5,24(sp)
    8000585c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000585e:	04c05763          	blez	a2,800058ac <consolewrite+0x60>
    80005862:	8a2a                	mv	s4,a0
    80005864:	84ae                	mv	s1,a1
    80005866:	89b2                	mv	s3,a2
    80005868:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000586a:	5afd                	li	s5,-1
    8000586c:	4685                	li	a3,1
    8000586e:	8626                	mv	a2,s1
    80005870:	85d2                	mv	a1,s4
    80005872:	fbf40513          	addi	a0,s0,-65
    80005876:	ffffc097          	auipc	ra,0xffffc
    8000587a:	0f0080e7          	jalr	240(ra) # 80001966 <either_copyin>
    8000587e:	01550d63          	beq	a0,s5,80005898 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005882:	fbf44503          	lbu	a0,-65(s0)
    80005886:	00000097          	auipc	ra,0x0
    8000588a:	7e8080e7          	jalr	2024(ra) # 8000606e <uartputc>
  for(i = 0; i < n; i++){
    8000588e:	2905                	addiw	s2,s2,1
    80005890:	0485                	addi	s1,s1,1
    80005892:	fd299de3          	bne	s3,s2,8000586c <consolewrite+0x20>
    80005896:	894e                	mv	s2,s3
  }

  return i;
}
    80005898:	854a                	mv	a0,s2
    8000589a:	60a6                	ld	ra,72(sp)
    8000589c:	6406                	ld	s0,64(sp)
    8000589e:	74e2                	ld	s1,56(sp)
    800058a0:	7942                	ld	s2,48(sp)
    800058a2:	79a2                	ld	s3,40(sp)
    800058a4:	7a02                	ld	s4,32(sp)
    800058a6:	6ae2                	ld	s5,24(sp)
    800058a8:	6161                	addi	sp,sp,80
    800058aa:	8082                	ret
  for(i = 0; i < n; i++){
    800058ac:	4901                	li	s2,0
    800058ae:	b7ed                	j	80005898 <consolewrite+0x4c>

00000000800058b0 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800058b0:	7159                	addi	sp,sp,-112
    800058b2:	f486                	sd	ra,104(sp)
    800058b4:	f0a2                	sd	s0,96(sp)
    800058b6:	eca6                	sd	s1,88(sp)
    800058b8:	e8ca                	sd	s2,80(sp)
    800058ba:	e4ce                	sd	s3,72(sp)
    800058bc:	e0d2                	sd	s4,64(sp)
    800058be:	fc56                	sd	s5,56(sp)
    800058c0:	f85a                	sd	s6,48(sp)
    800058c2:	f45e                	sd	s7,40(sp)
    800058c4:	f062                	sd	s8,32(sp)
    800058c6:	ec66                	sd	s9,24(sp)
    800058c8:	e86a                	sd	s10,16(sp)
    800058ca:	1880                	addi	s0,sp,112
    800058cc:	8aaa                	mv	s5,a0
    800058ce:	8a2e                	mv	s4,a1
    800058d0:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058d2:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800058d6:	0001d517          	auipc	a0,0x1d
    800058da:	9aa50513          	addi	a0,a0,-1622 # 80022280 <cons>
    800058de:	00001097          	auipc	ra,0x1
    800058e2:	94a080e7          	jalr	-1718(ra) # 80006228 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058e6:	0001d497          	auipc	s1,0x1d
    800058ea:	99a48493          	addi	s1,s1,-1638 # 80022280 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058ee:	0001d917          	auipc	s2,0x1d
    800058f2:	a2a90913          	addi	s2,s2,-1494 # 80022318 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800058f6:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058f8:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800058fa:	4ca9                	li	s9,10
  while(n > 0){
    800058fc:	07305b63          	blez	s3,80005972 <consoleread+0xc2>
    while(cons.r == cons.w){
    80005900:	0984a783          	lw	a5,152(s1)
    80005904:	09c4a703          	lw	a4,156(s1)
    80005908:	02f71763          	bne	a4,a5,80005936 <consoleread+0x86>
      if(killed(myproc())){
    8000590c:	ffffb097          	auipc	ra,0xffffb
    80005910:	548080e7          	jalr	1352(ra) # 80000e54 <myproc>
    80005914:	ffffc097          	auipc	ra,0xffffc
    80005918:	e9c080e7          	jalr	-356(ra) # 800017b0 <killed>
    8000591c:	e535                	bnez	a0,80005988 <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    8000591e:	85a6                	mv	a1,s1
    80005920:	854a                	mv	a0,s2
    80005922:	ffffc097          	auipc	ra,0xffffc
    80005926:	be6080e7          	jalr	-1050(ra) # 80001508 <sleep>
    while(cons.r == cons.w){
    8000592a:	0984a783          	lw	a5,152(s1)
    8000592e:	09c4a703          	lw	a4,156(s1)
    80005932:	fcf70de3          	beq	a4,a5,8000590c <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005936:	0017871b          	addiw	a4,a5,1
    8000593a:	08e4ac23          	sw	a4,152(s1)
    8000593e:	07f7f713          	andi	a4,a5,127
    80005942:	9726                	add	a4,a4,s1
    80005944:	01874703          	lbu	a4,24(a4)
    80005948:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    8000594c:	077d0563          	beq	s10,s7,800059b6 <consoleread+0x106>
    cbuf = c;
    80005950:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005954:	4685                	li	a3,1
    80005956:	f9f40613          	addi	a2,s0,-97
    8000595a:	85d2                	mv	a1,s4
    8000595c:	8556                	mv	a0,s5
    8000595e:	ffffc097          	auipc	ra,0xffffc
    80005962:	fb2080e7          	jalr	-78(ra) # 80001910 <either_copyout>
    80005966:	01850663          	beq	a0,s8,80005972 <consoleread+0xc2>
    dst++;
    8000596a:	0a05                	addi	s4,s4,1
    --n;
    8000596c:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    8000596e:	f99d17e3          	bne	s10,s9,800058fc <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005972:	0001d517          	auipc	a0,0x1d
    80005976:	90e50513          	addi	a0,a0,-1778 # 80022280 <cons>
    8000597a:	00001097          	auipc	ra,0x1
    8000597e:	962080e7          	jalr	-1694(ra) # 800062dc <release>

  return target - n;
    80005982:	413b053b          	subw	a0,s6,s3
    80005986:	a811                	j	8000599a <consoleread+0xea>
        release(&cons.lock);
    80005988:	0001d517          	auipc	a0,0x1d
    8000598c:	8f850513          	addi	a0,a0,-1800 # 80022280 <cons>
    80005990:	00001097          	auipc	ra,0x1
    80005994:	94c080e7          	jalr	-1716(ra) # 800062dc <release>
        return -1;
    80005998:	557d                	li	a0,-1
}
    8000599a:	70a6                	ld	ra,104(sp)
    8000599c:	7406                	ld	s0,96(sp)
    8000599e:	64e6                	ld	s1,88(sp)
    800059a0:	6946                	ld	s2,80(sp)
    800059a2:	69a6                	ld	s3,72(sp)
    800059a4:	6a06                	ld	s4,64(sp)
    800059a6:	7ae2                	ld	s5,56(sp)
    800059a8:	7b42                	ld	s6,48(sp)
    800059aa:	7ba2                	ld	s7,40(sp)
    800059ac:	7c02                	ld	s8,32(sp)
    800059ae:	6ce2                	ld	s9,24(sp)
    800059b0:	6d42                	ld	s10,16(sp)
    800059b2:	6165                	addi	sp,sp,112
    800059b4:	8082                	ret
      if(n < target){
    800059b6:	0009871b          	sext.w	a4,s3
    800059ba:	fb677ce3          	bgeu	a4,s6,80005972 <consoleread+0xc2>
        cons.r--;
    800059be:	0001d717          	auipc	a4,0x1d
    800059c2:	94f72d23          	sw	a5,-1702(a4) # 80022318 <cons+0x98>
    800059c6:	b775                	j	80005972 <consoleread+0xc2>

00000000800059c8 <consputc>:
{
    800059c8:	1141                	addi	sp,sp,-16
    800059ca:	e406                	sd	ra,8(sp)
    800059cc:	e022                	sd	s0,0(sp)
    800059ce:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800059d0:	10000793          	li	a5,256
    800059d4:	00f50a63          	beq	a0,a5,800059e8 <consputc+0x20>
    uartputc_sync(c);
    800059d8:	00000097          	auipc	ra,0x0
    800059dc:	5c4080e7          	jalr	1476(ra) # 80005f9c <uartputc_sync>
}
    800059e0:	60a2                	ld	ra,8(sp)
    800059e2:	6402                	ld	s0,0(sp)
    800059e4:	0141                	addi	sp,sp,16
    800059e6:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059e8:	4521                	li	a0,8
    800059ea:	00000097          	auipc	ra,0x0
    800059ee:	5b2080e7          	jalr	1458(ra) # 80005f9c <uartputc_sync>
    800059f2:	02000513          	li	a0,32
    800059f6:	00000097          	auipc	ra,0x0
    800059fa:	5a6080e7          	jalr	1446(ra) # 80005f9c <uartputc_sync>
    800059fe:	4521                	li	a0,8
    80005a00:	00000097          	auipc	ra,0x0
    80005a04:	59c080e7          	jalr	1436(ra) # 80005f9c <uartputc_sync>
    80005a08:	bfe1                	j	800059e0 <consputc+0x18>

0000000080005a0a <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a0a:	1101                	addi	sp,sp,-32
    80005a0c:	ec06                	sd	ra,24(sp)
    80005a0e:	e822                	sd	s0,16(sp)
    80005a10:	e426                	sd	s1,8(sp)
    80005a12:	e04a                	sd	s2,0(sp)
    80005a14:	1000                	addi	s0,sp,32
    80005a16:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a18:	0001d517          	auipc	a0,0x1d
    80005a1c:	86850513          	addi	a0,a0,-1944 # 80022280 <cons>
    80005a20:	00001097          	auipc	ra,0x1
    80005a24:	808080e7          	jalr	-2040(ra) # 80006228 <acquire>

  switch(c){
    80005a28:	47d5                	li	a5,21
    80005a2a:	0af48663          	beq	s1,a5,80005ad6 <consoleintr+0xcc>
    80005a2e:	0297ca63          	blt	a5,s1,80005a62 <consoleintr+0x58>
    80005a32:	47a1                	li	a5,8
    80005a34:	0ef48763          	beq	s1,a5,80005b22 <consoleintr+0x118>
    80005a38:	47c1                	li	a5,16
    80005a3a:	10f49a63          	bne	s1,a5,80005b4e <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a3e:	ffffc097          	auipc	ra,0xffffc
    80005a42:	f7e080e7          	jalr	-130(ra) # 800019bc <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a46:	0001d517          	auipc	a0,0x1d
    80005a4a:	83a50513          	addi	a0,a0,-1990 # 80022280 <cons>
    80005a4e:	00001097          	auipc	ra,0x1
    80005a52:	88e080e7          	jalr	-1906(ra) # 800062dc <release>
}
    80005a56:	60e2                	ld	ra,24(sp)
    80005a58:	6442                	ld	s0,16(sp)
    80005a5a:	64a2                	ld	s1,8(sp)
    80005a5c:	6902                	ld	s2,0(sp)
    80005a5e:	6105                	addi	sp,sp,32
    80005a60:	8082                	ret
  switch(c){
    80005a62:	07f00793          	li	a5,127
    80005a66:	0af48e63          	beq	s1,a5,80005b22 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005a6a:	0001d717          	auipc	a4,0x1d
    80005a6e:	81670713          	addi	a4,a4,-2026 # 80022280 <cons>
    80005a72:	0a072783          	lw	a5,160(a4)
    80005a76:	09872703          	lw	a4,152(a4)
    80005a7a:	9f99                	subw	a5,a5,a4
    80005a7c:	07f00713          	li	a4,127
    80005a80:	fcf763e3          	bltu	a4,a5,80005a46 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a84:	47b5                	li	a5,13
    80005a86:	0cf48763          	beq	s1,a5,80005b54 <consoleintr+0x14a>
      consputc(c);
    80005a8a:	8526                	mv	a0,s1
    80005a8c:	00000097          	auipc	ra,0x0
    80005a90:	f3c080e7          	jalr	-196(ra) # 800059c8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005a94:	0001c797          	auipc	a5,0x1c
    80005a98:	7ec78793          	addi	a5,a5,2028 # 80022280 <cons>
    80005a9c:	0a07a683          	lw	a3,160(a5)
    80005aa0:	0016871b          	addiw	a4,a3,1
    80005aa4:	0007061b          	sext.w	a2,a4
    80005aa8:	0ae7a023          	sw	a4,160(a5)
    80005aac:	07f6f693          	andi	a3,a3,127
    80005ab0:	97b6                	add	a5,a5,a3
    80005ab2:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005ab6:	47a9                	li	a5,10
    80005ab8:	0cf48563          	beq	s1,a5,80005b82 <consoleintr+0x178>
    80005abc:	4791                	li	a5,4
    80005abe:	0cf48263          	beq	s1,a5,80005b82 <consoleintr+0x178>
    80005ac2:	0001d797          	auipc	a5,0x1d
    80005ac6:	8567a783          	lw	a5,-1962(a5) # 80022318 <cons+0x98>
    80005aca:	9f1d                	subw	a4,a4,a5
    80005acc:	08000793          	li	a5,128
    80005ad0:	f6f71be3          	bne	a4,a5,80005a46 <consoleintr+0x3c>
    80005ad4:	a07d                	j	80005b82 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005ad6:	0001c717          	auipc	a4,0x1c
    80005ada:	7aa70713          	addi	a4,a4,1962 # 80022280 <cons>
    80005ade:	0a072783          	lw	a5,160(a4)
    80005ae2:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005ae6:	0001c497          	auipc	s1,0x1c
    80005aea:	79a48493          	addi	s1,s1,1946 # 80022280 <cons>
    while(cons.e != cons.w &&
    80005aee:	4929                	li	s2,10
    80005af0:	f4f70be3          	beq	a4,a5,80005a46 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005af4:	37fd                	addiw	a5,a5,-1
    80005af6:	07f7f713          	andi	a4,a5,127
    80005afa:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005afc:	01874703          	lbu	a4,24(a4)
    80005b00:	f52703e3          	beq	a4,s2,80005a46 <consoleintr+0x3c>
      cons.e--;
    80005b04:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b08:	10000513          	li	a0,256
    80005b0c:	00000097          	auipc	ra,0x0
    80005b10:	ebc080e7          	jalr	-324(ra) # 800059c8 <consputc>
    while(cons.e != cons.w &&
    80005b14:	0a04a783          	lw	a5,160(s1)
    80005b18:	09c4a703          	lw	a4,156(s1)
    80005b1c:	fcf71ce3          	bne	a4,a5,80005af4 <consoleintr+0xea>
    80005b20:	b71d                	j	80005a46 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005b22:	0001c717          	auipc	a4,0x1c
    80005b26:	75e70713          	addi	a4,a4,1886 # 80022280 <cons>
    80005b2a:	0a072783          	lw	a5,160(a4)
    80005b2e:	09c72703          	lw	a4,156(a4)
    80005b32:	f0f70ae3          	beq	a4,a5,80005a46 <consoleintr+0x3c>
      cons.e--;
    80005b36:	37fd                	addiw	a5,a5,-1
    80005b38:	0001c717          	auipc	a4,0x1c
    80005b3c:	7ef72423          	sw	a5,2024(a4) # 80022320 <cons+0xa0>
      consputc(BACKSPACE);
    80005b40:	10000513          	li	a0,256
    80005b44:	00000097          	auipc	ra,0x0
    80005b48:	e84080e7          	jalr	-380(ra) # 800059c8 <consputc>
    80005b4c:	bded                	j	80005a46 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b4e:	ee048ce3          	beqz	s1,80005a46 <consoleintr+0x3c>
    80005b52:	bf21                	j	80005a6a <consoleintr+0x60>
      consputc(c);
    80005b54:	4529                	li	a0,10
    80005b56:	00000097          	auipc	ra,0x0
    80005b5a:	e72080e7          	jalr	-398(ra) # 800059c8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b5e:	0001c797          	auipc	a5,0x1c
    80005b62:	72278793          	addi	a5,a5,1826 # 80022280 <cons>
    80005b66:	0a07a703          	lw	a4,160(a5)
    80005b6a:	0017069b          	addiw	a3,a4,1
    80005b6e:	0006861b          	sext.w	a2,a3
    80005b72:	0ad7a023          	sw	a3,160(a5)
    80005b76:	07f77713          	andi	a4,a4,127
    80005b7a:	97ba                	add	a5,a5,a4
    80005b7c:	4729                	li	a4,10
    80005b7e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b82:	0001c797          	auipc	a5,0x1c
    80005b86:	78c7ad23          	sw	a2,1946(a5) # 8002231c <cons+0x9c>
        wakeup(&cons.r);
    80005b8a:	0001c517          	auipc	a0,0x1c
    80005b8e:	78e50513          	addi	a0,a0,1934 # 80022318 <cons+0x98>
    80005b92:	ffffc097          	auipc	ra,0xffffc
    80005b96:	9da080e7          	jalr	-1574(ra) # 8000156c <wakeup>
    80005b9a:	b575                	j	80005a46 <consoleintr+0x3c>

0000000080005b9c <consoleinit>:

void
consoleinit(void)
{
    80005b9c:	1141                	addi	sp,sp,-16
    80005b9e:	e406                	sd	ra,8(sp)
    80005ba0:	e022                	sd	s0,0(sp)
    80005ba2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005ba4:	00003597          	auipc	a1,0x3
    80005ba8:	c2c58593          	addi	a1,a1,-980 # 800087d0 <syscalls+0x400>
    80005bac:	0001c517          	auipc	a0,0x1c
    80005bb0:	6d450513          	addi	a0,a0,1748 # 80022280 <cons>
    80005bb4:	00000097          	auipc	ra,0x0
    80005bb8:	5e4080e7          	jalr	1508(ra) # 80006198 <initlock>

  uartinit();
    80005bbc:	00000097          	auipc	ra,0x0
    80005bc0:	390080e7          	jalr	912(ra) # 80005f4c <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005bc4:	00013797          	auipc	a5,0x13
    80005bc8:	3e478793          	addi	a5,a5,996 # 80018fa8 <devsw>
    80005bcc:	00000717          	auipc	a4,0x0
    80005bd0:	ce470713          	addi	a4,a4,-796 # 800058b0 <consoleread>
    80005bd4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005bd6:	00000717          	auipc	a4,0x0
    80005bda:	c7670713          	addi	a4,a4,-906 # 8000584c <consolewrite>
    80005bde:	ef98                	sd	a4,24(a5)
}
    80005be0:	60a2                	ld	ra,8(sp)
    80005be2:	6402                	ld	s0,0(sp)
    80005be4:	0141                	addi	sp,sp,16
    80005be6:	8082                	ret

0000000080005be8 <printint>:
} pr;

static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign)
{
    80005be8:	7179                	addi	sp,sp,-48
    80005bea:	f406                	sd	ra,40(sp)
    80005bec:	f022                	sd	s0,32(sp)
    80005bee:	ec26                	sd	s1,24(sp)
    80005bf0:	e84a                	sd	s2,16(sp)
    80005bf2:	1800                	addi	s0,sp,48
    char buf[16];
    int i;
    uint x;

    if (sign && (sign = xx < 0))
    80005bf4:	c219                	beqz	a2,80005bfa <printint+0x12>
    80005bf6:	08054763          	bltz	a0,80005c84 <printint+0x9c>
        x = -xx;
    else
        x = xx;
    80005bfa:	2501                	sext.w	a0,a0
    80005bfc:	4881                	li	a7,0
    80005bfe:	fd040693          	addi	a3,s0,-48

    i = 0;
    80005c02:	4701                	li	a4,0
    do {
        buf[i++] = digits[x % base];
    80005c04:	2581                	sext.w	a1,a1
    80005c06:	00003617          	auipc	a2,0x3
    80005c0a:	c1260613          	addi	a2,a2,-1006 # 80008818 <digits>
    80005c0e:	883a                	mv	a6,a4
    80005c10:	2705                	addiw	a4,a4,1
    80005c12:	02b577bb          	remuw	a5,a0,a1
    80005c16:	1782                	slli	a5,a5,0x20
    80005c18:	9381                	srli	a5,a5,0x20
    80005c1a:	97b2                	add	a5,a5,a2
    80005c1c:	0007c783          	lbu	a5,0(a5)
    80005c20:	00f68023          	sb	a5,0(a3)
    } while ((x /= base) != 0);
    80005c24:	0005079b          	sext.w	a5,a0
    80005c28:	02b5553b          	divuw	a0,a0,a1
    80005c2c:	0685                	addi	a3,a3,1
    80005c2e:	feb7f0e3          	bgeu	a5,a1,80005c0e <printint+0x26>

    if (sign)
    80005c32:	00088c63          	beqz	a7,80005c4a <printint+0x62>
        buf[i++] = '-';
    80005c36:	fe070793          	addi	a5,a4,-32
    80005c3a:	00878733          	add	a4,a5,s0
    80005c3e:	02d00793          	li	a5,45
    80005c42:	fef70823          	sb	a5,-16(a4)
    80005c46:	0028071b          	addiw	a4,a6,2

    while (--i >= 0)
    80005c4a:	02e05763          	blez	a4,80005c78 <printint+0x90>
    80005c4e:	fd040793          	addi	a5,s0,-48
    80005c52:	00e784b3          	add	s1,a5,a4
    80005c56:	fff78913          	addi	s2,a5,-1
    80005c5a:	993a                	add	s2,s2,a4
    80005c5c:	377d                	addiw	a4,a4,-1
    80005c5e:	1702                	slli	a4,a4,0x20
    80005c60:	9301                	srli	a4,a4,0x20
    80005c62:	40e90933          	sub	s2,s2,a4
        consputc(buf[i]);
    80005c66:	fff4c503          	lbu	a0,-1(s1)
    80005c6a:	00000097          	auipc	ra,0x0
    80005c6e:	d5e080e7          	jalr	-674(ra) # 800059c8 <consputc>
    while (--i >= 0)
    80005c72:	14fd                	addi	s1,s1,-1
    80005c74:	ff2499e3          	bne	s1,s2,80005c66 <printint+0x7e>
}
    80005c78:	70a2                	ld	ra,40(sp)
    80005c7a:	7402                	ld	s0,32(sp)
    80005c7c:	64e2                	ld	s1,24(sp)
    80005c7e:	6942                	ld	s2,16(sp)
    80005c80:	6145                	addi	sp,sp,48
    80005c82:	8082                	ret
        x = -xx;
    80005c84:	40a0053b          	negw	a0,a0
    if (sign && (sign = xx < 0))
    80005c88:	4885                	li	a7,1
        x = -xx;
    80005c8a:	bf95                	j	80005bfe <printint+0x16>

0000000080005c8c <printfinit>:
    for (;;)
        ;
}

void printfinit(void)
{
    80005c8c:	1101                	addi	sp,sp,-32
    80005c8e:	ec06                	sd	ra,24(sp)
    80005c90:	e822                	sd	s0,16(sp)
    80005c92:	e426                	sd	s1,8(sp)
    80005c94:	1000                	addi	s0,sp,32
    initlock(&pr.lock, "pr");
    80005c96:	0001c497          	auipc	s1,0x1c
    80005c9a:	69248493          	addi	s1,s1,1682 # 80022328 <pr>
    80005c9e:	00003597          	auipc	a1,0x3
    80005ca2:	b3a58593          	addi	a1,a1,-1222 # 800087d8 <syscalls+0x408>
    80005ca6:	8526                	mv	a0,s1
    80005ca8:	00000097          	auipc	ra,0x0
    80005cac:	4f0080e7          	jalr	1264(ra) # 80006198 <initlock>
    pr.locking = 1;
    80005cb0:	4785                	li	a5,1
    80005cb2:	cc9c                	sw	a5,24(s1)
}
    80005cb4:	60e2                	ld	ra,24(sp)
    80005cb6:	6442                	ld	s0,16(sp)
    80005cb8:	64a2                	ld	s1,8(sp)
    80005cba:	6105                	addi	sp,sp,32
    80005cbc:	8082                	ret

0000000080005cbe <backtrace>:
void backtrace(void)
{
    80005cbe:	7179                	addi	sp,sp,-48
    80005cc0:	f406                	sd	ra,40(sp)
    80005cc2:	f022                	sd	s0,32(sp)
    80005cc4:	ec26                	sd	s1,24(sp)
    80005cc6:	e84a                	sd	s2,16(sp)
    80005cc8:	e44e                	sd	s3,8(sp)
    80005cca:	1800                	addi	s0,sp,48
    asm volatile("mv %0, s0" : "=r"(x));
    80005ccc:	84a2                	mv	s1,s0
    uint64 fp = r_fp();
    uint64 boundary = PGROUNDUP(fp);
    80005cce:	6905                	lui	s2,0x1
    80005cd0:	197d                	addi	s2,s2,-1 # fff <_entry-0x7ffff001>
    80005cd2:	9926                	add	s2,s2,s1
    80005cd4:	77fd                	lui	a5,0xfffff
    80005cd6:	00f97933          	and	s2,s2,a5
    printf("backtrace:\n");
    80005cda:	00003517          	auipc	a0,0x3
    80005cde:	b0650513          	addi	a0,a0,-1274 # 800087e0 <syscalls+0x410>
    80005ce2:	00000097          	auipc	ra,0x0
    80005ce6:	08a080e7          	jalr	138(ra) # 80005d6c <printf>
    while (fp < boundary) {
    80005cea:	0324f163          	bgeu	s1,s2,80005d0c <backtrace+0x4e>
        printf("%p\n", *((uint64 *)(fp - 8)));
    80005cee:	00003997          	auipc	s3,0x3
    80005cf2:	b0298993          	addi	s3,s3,-1278 # 800087f0 <syscalls+0x420>
    80005cf6:	ff84b583          	ld	a1,-8(s1)
    80005cfa:	854e                	mv	a0,s3
    80005cfc:	00000097          	auipc	ra,0x0
    80005d00:	070080e7          	jalr	112(ra) # 80005d6c <printf>
        fp = *((uint64 *)(fp - 16));
    80005d04:	ff04b483          	ld	s1,-16(s1)
    while (fp < boundary) {
    80005d08:	ff24e7e3          	bltu	s1,s2,80005cf6 <backtrace+0x38>
    }
    80005d0c:	70a2                	ld	ra,40(sp)
    80005d0e:	7402                	ld	s0,32(sp)
    80005d10:	64e2                	ld	s1,24(sp)
    80005d12:	6942                	ld	s2,16(sp)
    80005d14:	69a2                	ld	s3,8(sp)
    80005d16:	6145                	addi	sp,sp,48
    80005d18:	8082                	ret

0000000080005d1a <panic>:
{
    80005d1a:	1101                	addi	sp,sp,-32
    80005d1c:	ec06                	sd	ra,24(sp)
    80005d1e:	e822                	sd	s0,16(sp)
    80005d20:	e426                	sd	s1,8(sp)
    80005d22:	1000                	addi	s0,sp,32
    80005d24:	84aa                	mv	s1,a0
    backtrace();
    80005d26:	00000097          	auipc	ra,0x0
    80005d2a:	f98080e7          	jalr	-104(ra) # 80005cbe <backtrace>
    pr.locking = 0;
    80005d2e:	0001c797          	auipc	a5,0x1c
    80005d32:	6007a923          	sw	zero,1554(a5) # 80022340 <pr+0x18>
    printf("panic: ");
    80005d36:	00003517          	auipc	a0,0x3
    80005d3a:	ac250513          	addi	a0,a0,-1342 # 800087f8 <syscalls+0x428>
    80005d3e:	00000097          	auipc	ra,0x0
    80005d42:	02e080e7          	jalr	46(ra) # 80005d6c <printf>
    printf(s);
    80005d46:	8526                	mv	a0,s1
    80005d48:	00000097          	auipc	ra,0x0
    80005d4c:	024080e7          	jalr	36(ra) # 80005d6c <printf>
    printf("\n");
    80005d50:	00002517          	auipc	a0,0x2
    80005d54:	2f850513          	addi	a0,a0,760 # 80008048 <etext+0x48>
    80005d58:	00000097          	auipc	ra,0x0
    80005d5c:	014080e7          	jalr	20(ra) # 80005d6c <printf>
    panicked = 1; // freeze uart output from other CPUs
    80005d60:	4785                	li	a5,1
    80005d62:	00003717          	auipc	a4,0x3
    80005d66:	b8f72d23          	sw	a5,-1126(a4) # 800088fc <panicked>
    for (;;)
    80005d6a:	a001                	j	80005d6a <panic+0x50>

0000000080005d6c <printf>:
{
    80005d6c:	7131                	addi	sp,sp,-192
    80005d6e:	fc86                	sd	ra,120(sp)
    80005d70:	f8a2                	sd	s0,112(sp)
    80005d72:	f4a6                	sd	s1,104(sp)
    80005d74:	f0ca                	sd	s2,96(sp)
    80005d76:	ecce                	sd	s3,88(sp)
    80005d78:	e8d2                	sd	s4,80(sp)
    80005d7a:	e4d6                	sd	s5,72(sp)
    80005d7c:	e0da                	sd	s6,64(sp)
    80005d7e:	fc5e                	sd	s7,56(sp)
    80005d80:	f862                	sd	s8,48(sp)
    80005d82:	f466                	sd	s9,40(sp)
    80005d84:	f06a                	sd	s10,32(sp)
    80005d86:	ec6e                	sd	s11,24(sp)
    80005d88:	0100                	addi	s0,sp,128
    80005d8a:	8a2a                	mv	s4,a0
    80005d8c:	e40c                	sd	a1,8(s0)
    80005d8e:	e810                	sd	a2,16(s0)
    80005d90:	ec14                	sd	a3,24(s0)
    80005d92:	f018                	sd	a4,32(s0)
    80005d94:	f41c                	sd	a5,40(s0)
    80005d96:	03043823          	sd	a6,48(s0)
    80005d9a:	03143c23          	sd	a7,56(s0)
    locking = pr.locking;
    80005d9e:	0001cd97          	auipc	s11,0x1c
    80005da2:	5a2dad83          	lw	s11,1442(s11) # 80022340 <pr+0x18>
    if (locking)
    80005da6:	020d9b63          	bnez	s11,80005ddc <printf+0x70>
    if (fmt == 0)
    80005daa:	040a0263          	beqz	s4,80005dee <printf+0x82>
    va_start(ap, fmt);
    80005dae:	00840793          	addi	a5,s0,8
    80005db2:	f8f43423          	sd	a5,-120(s0)
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80005db6:	000a4503          	lbu	a0,0(s4)
    80005dba:	14050f63          	beqz	a0,80005f18 <printf+0x1ac>
    80005dbe:	4981                	li	s3,0
        if (c != '%') {
    80005dc0:	02500a93          	li	s5,37
        switch (c) {
    80005dc4:	07000b93          	li	s7,112
    consputc('x');
    80005dc8:	4d41                	li	s10,16
        consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005dca:	00003b17          	auipc	s6,0x3
    80005dce:	a4eb0b13          	addi	s6,s6,-1458 # 80008818 <digits>
        switch (c) {
    80005dd2:	07300c93          	li	s9,115
    80005dd6:	06400c13          	li	s8,100
    80005dda:	a82d                	j	80005e14 <printf+0xa8>
        acquire(&pr.lock);
    80005ddc:	0001c517          	auipc	a0,0x1c
    80005de0:	54c50513          	addi	a0,a0,1356 # 80022328 <pr>
    80005de4:	00000097          	auipc	ra,0x0
    80005de8:	444080e7          	jalr	1092(ra) # 80006228 <acquire>
    80005dec:	bf7d                	j	80005daa <printf+0x3e>
        panic("null fmt");
    80005dee:	00003517          	auipc	a0,0x3
    80005df2:	a1a50513          	addi	a0,a0,-1510 # 80008808 <syscalls+0x438>
    80005df6:	00000097          	auipc	ra,0x0
    80005dfa:	f24080e7          	jalr	-220(ra) # 80005d1a <panic>
            consputc(c);
    80005dfe:	00000097          	auipc	ra,0x0
    80005e02:	bca080e7          	jalr	-1078(ra) # 800059c8 <consputc>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80005e06:	2985                	addiw	s3,s3,1
    80005e08:	013a07b3          	add	a5,s4,s3
    80005e0c:	0007c503          	lbu	a0,0(a5)
    80005e10:	10050463          	beqz	a0,80005f18 <printf+0x1ac>
        if (c != '%') {
    80005e14:	ff5515e3          	bne	a0,s5,80005dfe <printf+0x92>
        c = fmt[++i] & 0xff;
    80005e18:	2985                	addiw	s3,s3,1
    80005e1a:	013a07b3          	add	a5,s4,s3
    80005e1e:	0007c783          	lbu	a5,0(a5)
    80005e22:	0007849b          	sext.w	s1,a5
        if (c == 0)
    80005e26:	cbed                	beqz	a5,80005f18 <printf+0x1ac>
        switch (c) {
    80005e28:	05778a63          	beq	a5,s7,80005e7c <printf+0x110>
    80005e2c:	02fbf663          	bgeu	s7,a5,80005e58 <printf+0xec>
    80005e30:	09978863          	beq	a5,s9,80005ec0 <printf+0x154>
    80005e34:	07800713          	li	a4,120
    80005e38:	0ce79563          	bne	a5,a4,80005f02 <printf+0x196>
            printint(va_arg(ap, int), 16, 1);
    80005e3c:	f8843783          	ld	a5,-120(s0)
    80005e40:	00878713          	addi	a4,a5,8
    80005e44:	f8e43423          	sd	a4,-120(s0)
    80005e48:	4605                	li	a2,1
    80005e4a:	85ea                	mv	a1,s10
    80005e4c:	4388                	lw	a0,0(a5)
    80005e4e:	00000097          	auipc	ra,0x0
    80005e52:	d9a080e7          	jalr	-614(ra) # 80005be8 <printint>
            break;
    80005e56:	bf45                	j	80005e06 <printf+0x9a>
        switch (c) {
    80005e58:	09578f63          	beq	a5,s5,80005ef6 <printf+0x18a>
    80005e5c:	0b879363          	bne	a5,s8,80005f02 <printf+0x196>
            printint(va_arg(ap, int), 10, 1);
    80005e60:	f8843783          	ld	a5,-120(s0)
    80005e64:	00878713          	addi	a4,a5,8
    80005e68:	f8e43423          	sd	a4,-120(s0)
    80005e6c:	4605                	li	a2,1
    80005e6e:	45a9                	li	a1,10
    80005e70:	4388                	lw	a0,0(a5)
    80005e72:	00000097          	auipc	ra,0x0
    80005e76:	d76080e7          	jalr	-650(ra) # 80005be8 <printint>
            break;
    80005e7a:	b771                	j	80005e06 <printf+0x9a>
            printptr(va_arg(ap, uint64));
    80005e7c:	f8843783          	ld	a5,-120(s0)
    80005e80:	00878713          	addi	a4,a5,8
    80005e84:	f8e43423          	sd	a4,-120(s0)
    80005e88:	0007b903          	ld	s2,0(a5)
    consputc('0');
    80005e8c:	03000513          	li	a0,48
    80005e90:	00000097          	auipc	ra,0x0
    80005e94:	b38080e7          	jalr	-1224(ra) # 800059c8 <consputc>
    consputc('x');
    80005e98:	07800513          	li	a0,120
    80005e9c:	00000097          	auipc	ra,0x0
    80005ea0:	b2c080e7          	jalr	-1236(ra) # 800059c8 <consputc>
    80005ea4:	84ea                	mv	s1,s10
        consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ea6:	03c95793          	srli	a5,s2,0x3c
    80005eaa:	97da                	add	a5,a5,s6
    80005eac:	0007c503          	lbu	a0,0(a5)
    80005eb0:	00000097          	auipc	ra,0x0
    80005eb4:	b18080e7          	jalr	-1256(ra) # 800059c8 <consputc>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005eb8:	0912                	slli	s2,s2,0x4
    80005eba:	34fd                	addiw	s1,s1,-1
    80005ebc:	f4ed                	bnez	s1,80005ea6 <printf+0x13a>
    80005ebe:	b7a1                	j	80005e06 <printf+0x9a>
            if ((s = va_arg(ap, char *)) == 0)
    80005ec0:	f8843783          	ld	a5,-120(s0)
    80005ec4:	00878713          	addi	a4,a5,8
    80005ec8:	f8e43423          	sd	a4,-120(s0)
    80005ecc:	6384                	ld	s1,0(a5)
    80005ece:	cc89                	beqz	s1,80005ee8 <printf+0x17c>
            for (; *s; s++)
    80005ed0:	0004c503          	lbu	a0,0(s1)
    80005ed4:	d90d                	beqz	a0,80005e06 <printf+0x9a>
                consputc(*s);
    80005ed6:	00000097          	auipc	ra,0x0
    80005eda:	af2080e7          	jalr	-1294(ra) # 800059c8 <consputc>
            for (; *s; s++)
    80005ede:	0485                	addi	s1,s1,1
    80005ee0:	0004c503          	lbu	a0,0(s1)
    80005ee4:	f96d                	bnez	a0,80005ed6 <printf+0x16a>
    80005ee6:	b705                	j	80005e06 <printf+0x9a>
                s = "(null)";
    80005ee8:	00003497          	auipc	s1,0x3
    80005eec:	91848493          	addi	s1,s1,-1768 # 80008800 <syscalls+0x430>
            for (; *s; s++)
    80005ef0:	02800513          	li	a0,40
    80005ef4:	b7cd                	j	80005ed6 <printf+0x16a>
            consputc('%');
    80005ef6:	8556                	mv	a0,s5
    80005ef8:	00000097          	auipc	ra,0x0
    80005efc:	ad0080e7          	jalr	-1328(ra) # 800059c8 <consputc>
            break;
    80005f00:	b719                	j	80005e06 <printf+0x9a>
            consputc('%');
    80005f02:	8556                	mv	a0,s5
    80005f04:	00000097          	auipc	ra,0x0
    80005f08:	ac4080e7          	jalr	-1340(ra) # 800059c8 <consputc>
            consputc(c);
    80005f0c:	8526                	mv	a0,s1
    80005f0e:	00000097          	auipc	ra,0x0
    80005f12:	aba080e7          	jalr	-1350(ra) # 800059c8 <consputc>
            break;
    80005f16:	bdc5                	j	80005e06 <printf+0x9a>
    if (locking)
    80005f18:	020d9163          	bnez	s11,80005f3a <printf+0x1ce>
}
    80005f1c:	70e6                	ld	ra,120(sp)
    80005f1e:	7446                	ld	s0,112(sp)
    80005f20:	74a6                	ld	s1,104(sp)
    80005f22:	7906                	ld	s2,96(sp)
    80005f24:	69e6                	ld	s3,88(sp)
    80005f26:	6a46                	ld	s4,80(sp)
    80005f28:	6aa6                	ld	s5,72(sp)
    80005f2a:	6b06                	ld	s6,64(sp)
    80005f2c:	7be2                	ld	s7,56(sp)
    80005f2e:	7c42                	ld	s8,48(sp)
    80005f30:	7ca2                	ld	s9,40(sp)
    80005f32:	7d02                	ld	s10,32(sp)
    80005f34:	6de2                	ld	s11,24(sp)
    80005f36:	6129                	addi	sp,sp,192
    80005f38:	8082                	ret
        release(&pr.lock);
    80005f3a:	0001c517          	auipc	a0,0x1c
    80005f3e:	3ee50513          	addi	a0,a0,1006 # 80022328 <pr>
    80005f42:	00000097          	auipc	ra,0x0
    80005f46:	39a080e7          	jalr	922(ra) # 800062dc <release>
}
    80005f4a:	bfc9                	j	80005f1c <printf+0x1b0>

0000000080005f4c <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f4c:	1141                	addi	sp,sp,-16
    80005f4e:	e406                	sd	ra,8(sp)
    80005f50:	e022                	sd	s0,0(sp)
    80005f52:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f54:	100007b7          	lui	a5,0x10000
    80005f58:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f5c:	f8000713          	li	a4,-128
    80005f60:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f64:	470d                	li	a4,3
    80005f66:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f6a:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f6e:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f72:	469d                	li	a3,7
    80005f74:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f78:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f7c:	00003597          	auipc	a1,0x3
    80005f80:	8b458593          	addi	a1,a1,-1868 # 80008830 <digits+0x18>
    80005f84:	0001c517          	auipc	a0,0x1c
    80005f88:	3c450513          	addi	a0,a0,964 # 80022348 <uart_tx_lock>
    80005f8c:	00000097          	auipc	ra,0x0
    80005f90:	20c080e7          	jalr	524(ra) # 80006198 <initlock>
}
    80005f94:	60a2                	ld	ra,8(sp)
    80005f96:	6402                	ld	s0,0(sp)
    80005f98:	0141                	addi	sp,sp,16
    80005f9a:	8082                	ret

0000000080005f9c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f9c:	1101                	addi	sp,sp,-32
    80005f9e:	ec06                	sd	ra,24(sp)
    80005fa0:	e822                	sd	s0,16(sp)
    80005fa2:	e426                	sd	s1,8(sp)
    80005fa4:	1000                	addi	s0,sp,32
    80005fa6:	84aa                	mv	s1,a0
  push_off();
    80005fa8:	00000097          	auipc	ra,0x0
    80005fac:	234080e7          	jalr	564(ra) # 800061dc <push_off>

  if(panicked){
    80005fb0:	00003797          	auipc	a5,0x3
    80005fb4:	94c7a783          	lw	a5,-1716(a5) # 800088fc <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005fb8:	10000737          	lui	a4,0x10000
  if(panicked){
    80005fbc:	c391                	beqz	a5,80005fc0 <uartputc_sync+0x24>
    for(;;)
    80005fbe:	a001                	j	80005fbe <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005fc0:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005fc4:	0207f793          	andi	a5,a5,32
    80005fc8:	dfe5                	beqz	a5,80005fc0 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005fca:	0ff4f513          	zext.b	a0,s1
    80005fce:	100007b7          	lui	a5,0x10000
    80005fd2:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005fd6:	00000097          	auipc	ra,0x0
    80005fda:	2a6080e7          	jalr	678(ra) # 8000627c <pop_off>
}
    80005fde:	60e2                	ld	ra,24(sp)
    80005fe0:	6442                	ld	s0,16(sp)
    80005fe2:	64a2                	ld	s1,8(sp)
    80005fe4:	6105                	addi	sp,sp,32
    80005fe6:	8082                	ret

0000000080005fe8 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005fe8:	00003797          	auipc	a5,0x3
    80005fec:	9187b783          	ld	a5,-1768(a5) # 80008900 <uart_tx_r>
    80005ff0:	00003717          	auipc	a4,0x3
    80005ff4:	91873703          	ld	a4,-1768(a4) # 80008908 <uart_tx_w>
    80005ff8:	06f70a63          	beq	a4,a5,8000606c <uartstart+0x84>
{
    80005ffc:	7139                	addi	sp,sp,-64
    80005ffe:	fc06                	sd	ra,56(sp)
    80006000:	f822                	sd	s0,48(sp)
    80006002:	f426                	sd	s1,40(sp)
    80006004:	f04a                	sd	s2,32(sp)
    80006006:	ec4e                	sd	s3,24(sp)
    80006008:	e852                	sd	s4,16(sp)
    8000600a:	e456                	sd	s5,8(sp)
    8000600c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000600e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006012:	0001ca17          	auipc	s4,0x1c
    80006016:	336a0a13          	addi	s4,s4,822 # 80022348 <uart_tx_lock>
    uart_tx_r += 1;
    8000601a:	00003497          	auipc	s1,0x3
    8000601e:	8e648493          	addi	s1,s1,-1818 # 80008900 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006022:	00003997          	auipc	s3,0x3
    80006026:	8e698993          	addi	s3,s3,-1818 # 80008908 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000602a:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000602e:	02077713          	andi	a4,a4,32
    80006032:	c705                	beqz	a4,8000605a <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006034:	01f7f713          	andi	a4,a5,31
    80006038:	9752                	add	a4,a4,s4
    8000603a:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000603e:	0785                	addi	a5,a5,1
    80006040:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006042:	8526                	mv	a0,s1
    80006044:	ffffb097          	auipc	ra,0xffffb
    80006048:	528080e7          	jalr	1320(ra) # 8000156c <wakeup>
    
    WriteReg(THR, c);
    8000604c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006050:	609c                	ld	a5,0(s1)
    80006052:	0009b703          	ld	a4,0(s3)
    80006056:	fcf71ae3          	bne	a4,a5,8000602a <uartstart+0x42>
  }
}
    8000605a:	70e2                	ld	ra,56(sp)
    8000605c:	7442                	ld	s0,48(sp)
    8000605e:	74a2                	ld	s1,40(sp)
    80006060:	7902                	ld	s2,32(sp)
    80006062:	69e2                	ld	s3,24(sp)
    80006064:	6a42                	ld	s4,16(sp)
    80006066:	6aa2                	ld	s5,8(sp)
    80006068:	6121                	addi	sp,sp,64
    8000606a:	8082                	ret
    8000606c:	8082                	ret

000000008000606e <uartputc>:
{
    8000606e:	7179                	addi	sp,sp,-48
    80006070:	f406                	sd	ra,40(sp)
    80006072:	f022                	sd	s0,32(sp)
    80006074:	ec26                	sd	s1,24(sp)
    80006076:	e84a                	sd	s2,16(sp)
    80006078:	e44e                	sd	s3,8(sp)
    8000607a:	e052                	sd	s4,0(sp)
    8000607c:	1800                	addi	s0,sp,48
    8000607e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006080:	0001c517          	auipc	a0,0x1c
    80006084:	2c850513          	addi	a0,a0,712 # 80022348 <uart_tx_lock>
    80006088:	00000097          	auipc	ra,0x0
    8000608c:	1a0080e7          	jalr	416(ra) # 80006228 <acquire>
  if(panicked){
    80006090:	00003797          	auipc	a5,0x3
    80006094:	86c7a783          	lw	a5,-1940(a5) # 800088fc <panicked>
    80006098:	e7c9                	bnez	a5,80006122 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000609a:	00003717          	auipc	a4,0x3
    8000609e:	86e73703          	ld	a4,-1938(a4) # 80008908 <uart_tx_w>
    800060a2:	00003797          	auipc	a5,0x3
    800060a6:	85e7b783          	ld	a5,-1954(a5) # 80008900 <uart_tx_r>
    800060aa:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800060ae:	0001c997          	auipc	s3,0x1c
    800060b2:	29a98993          	addi	s3,s3,666 # 80022348 <uart_tx_lock>
    800060b6:	00003497          	auipc	s1,0x3
    800060ba:	84a48493          	addi	s1,s1,-1974 # 80008900 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060be:	00003917          	auipc	s2,0x3
    800060c2:	84a90913          	addi	s2,s2,-1974 # 80008908 <uart_tx_w>
    800060c6:	00e79f63          	bne	a5,a4,800060e4 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    800060ca:	85ce                	mv	a1,s3
    800060cc:	8526                	mv	a0,s1
    800060ce:	ffffb097          	auipc	ra,0xffffb
    800060d2:	43a080e7          	jalr	1082(ra) # 80001508 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060d6:	00093703          	ld	a4,0(s2)
    800060da:	609c                	ld	a5,0(s1)
    800060dc:	02078793          	addi	a5,a5,32
    800060e0:	fee785e3          	beq	a5,a4,800060ca <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800060e4:	0001c497          	auipc	s1,0x1c
    800060e8:	26448493          	addi	s1,s1,612 # 80022348 <uart_tx_lock>
    800060ec:	01f77793          	andi	a5,a4,31
    800060f0:	97a6                	add	a5,a5,s1
    800060f2:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800060f6:	0705                	addi	a4,a4,1
    800060f8:	00003797          	auipc	a5,0x3
    800060fc:	80e7b823          	sd	a4,-2032(a5) # 80008908 <uart_tx_w>
  uartstart();
    80006100:	00000097          	auipc	ra,0x0
    80006104:	ee8080e7          	jalr	-280(ra) # 80005fe8 <uartstart>
  release(&uart_tx_lock);
    80006108:	8526                	mv	a0,s1
    8000610a:	00000097          	auipc	ra,0x0
    8000610e:	1d2080e7          	jalr	466(ra) # 800062dc <release>
}
    80006112:	70a2                	ld	ra,40(sp)
    80006114:	7402                	ld	s0,32(sp)
    80006116:	64e2                	ld	s1,24(sp)
    80006118:	6942                	ld	s2,16(sp)
    8000611a:	69a2                	ld	s3,8(sp)
    8000611c:	6a02                	ld	s4,0(sp)
    8000611e:	6145                	addi	sp,sp,48
    80006120:	8082                	ret
    for(;;)
    80006122:	a001                	j	80006122 <uartputc+0xb4>

0000000080006124 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006124:	1141                	addi	sp,sp,-16
    80006126:	e422                	sd	s0,8(sp)
    80006128:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000612a:	100007b7          	lui	a5,0x10000
    8000612e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006132:	8b85                	andi	a5,a5,1
    80006134:	cb81                	beqz	a5,80006144 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80006136:	100007b7          	lui	a5,0x10000
    8000613a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000613e:	6422                	ld	s0,8(sp)
    80006140:	0141                	addi	sp,sp,16
    80006142:	8082                	ret
    return -1;
    80006144:	557d                	li	a0,-1
    80006146:	bfe5                	j	8000613e <uartgetc+0x1a>

0000000080006148 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80006148:	1101                	addi	sp,sp,-32
    8000614a:	ec06                	sd	ra,24(sp)
    8000614c:	e822                	sd	s0,16(sp)
    8000614e:	e426                	sd	s1,8(sp)
    80006150:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006152:	54fd                	li	s1,-1
    80006154:	a029                	j	8000615e <uartintr+0x16>
      break;
    consoleintr(c);
    80006156:	00000097          	auipc	ra,0x0
    8000615a:	8b4080e7          	jalr	-1868(ra) # 80005a0a <consoleintr>
    int c = uartgetc();
    8000615e:	00000097          	auipc	ra,0x0
    80006162:	fc6080e7          	jalr	-58(ra) # 80006124 <uartgetc>
    if(c == -1)
    80006166:	fe9518e3          	bne	a0,s1,80006156 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000616a:	0001c497          	auipc	s1,0x1c
    8000616e:	1de48493          	addi	s1,s1,478 # 80022348 <uart_tx_lock>
    80006172:	8526                	mv	a0,s1
    80006174:	00000097          	auipc	ra,0x0
    80006178:	0b4080e7          	jalr	180(ra) # 80006228 <acquire>
  uartstart();
    8000617c:	00000097          	auipc	ra,0x0
    80006180:	e6c080e7          	jalr	-404(ra) # 80005fe8 <uartstart>
  release(&uart_tx_lock);
    80006184:	8526                	mv	a0,s1
    80006186:	00000097          	auipc	ra,0x0
    8000618a:	156080e7          	jalr	342(ra) # 800062dc <release>
}
    8000618e:	60e2                	ld	ra,24(sp)
    80006190:	6442                	ld	s0,16(sp)
    80006192:	64a2                	ld	s1,8(sp)
    80006194:	6105                	addi	sp,sp,32
    80006196:	8082                	ret

0000000080006198 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006198:	1141                	addi	sp,sp,-16
    8000619a:	e422                	sd	s0,8(sp)
    8000619c:	0800                	addi	s0,sp,16
  lk->name = name;
    8000619e:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800061a0:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800061a4:	00053823          	sd	zero,16(a0)
}
    800061a8:	6422                	ld	s0,8(sp)
    800061aa:	0141                	addi	sp,sp,16
    800061ac:	8082                	ret

00000000800061ae <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800061ae:	411c                	lw	a5,0(a0)
    800061b0:	e399                	bnez	a5,800061b6 <holding+0x8>
    800061b2:	4501                	li	a0,0
  return r;
}
    800061b4:	8082                	ret
{
    800061b6:	1101                	addi	sp,sp,-32
    800061b8:	ec06                	sd	ra,24(sp)
    800061ba:	e822                	sd	s0,16(sp)
    800061bc:	e426                	sd	s1,8(sp)
    800061be:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800061c0:	6904                	ld	s1,16(a0)
    800061c2:	ffffb097          	auipc	ra,0xffffb
    800061c6:	c76080e7          	jalr	-906(ra) # 80000e38 <mycpu>
    800061ca:	40a48533          	sub	a0,s1,a0
    800061ce:	00153513          	seqz	a0,a0
}
    800061d2:	60e2                	ld	ra,24(sp)
    800061d4:	6442                	ld	s0,16(sp)
    800061d6:	64a2                	ld	s1,8(sp)
    800061d8:	6105                	addi	sp,sp,32
    800061da:	8082                	ret

00000000800061dc <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800061dc:	1101                	addi	sp,sp,-32
    800061de:	ec06                	sd	ra,24(sp)
    800061e0:	e822                	sd	s0,16(sp)
    800061e2:	e426                	sd	s1,8(sp)
    800061e4:	1000                	addi	s0,sp,32
    asm volatile("csrr %0, sstatus" : "=r"(x));
    800061e6:	100024f3          	csrr	s1,sstatus
    800061ea:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800061ee:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sstatus, %0" : : "r"(x));
    800061f0:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800061f4:	ffffb097          	auipc	ra,0xffffb
    800061f8:	c44080e7          	jalr	-956(ra) # 80000e38 <mycpu>
    800061fc:	5d3c                	lw	a5,120(a0)
    800061fe:	cf89                	beqz	a5,80006218 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006200:	ffffb097          	auipc	ra,0xffffb
    80006204:	c38080e7          	jalr	-968(ra) # 80000e38 <mycpu>
    80006208:	5d3c                	lw	a5,120(a0)
    8000620a:	2785                	addiw	a5,a5,1
    8000620c:	dd3c                	sw	a5,120(a0)
}
    8000620e:	60e2                	ld	ra,24(sp)
    80006210:	6442                	ld	s0,16(sp)
    80006212:	64a2                	ld	s1,8(sp)
    80006214:	6105                	addi	sp,sp,32
    80006216:	8082                	ret
    mycpu()->intena = old;
    80006218:	ffffb097          	auipc	ra,0xffffb
    8000621c:	c20080e7          	jalr	-992(ra) # 80000e38 <mycpu>
    return (x & SSTATUS_SIE) != 0;
    80006220:	8085                	srli	s1,s1,0x1
    80006222:	8885                	andi	s1,s1,1
    80006224:	dd64                	sw	s1,124(a0)
    80006226:	bfe9                	j	80006200 <push_off+0x24>

0000000080006228 <acquire>:
{
    80006228:	1101                	addi	sp,sp,-32
    8000622a:	ec06                	sd	ra,24(sp)
    8000622c:	e822                	sd	s0,16(sp)
    8000622e:	e426                	sd	s1,8(sp)
    80006230:	1000                	addi	s0,sp,32
    80006232:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006234:	00000097          	auipc	ra,0x0
    80006238:	fa8080e7          	jalr	-88(ra) # 800061dc <push_off>
  if(holding(lk))
    8000623c:	8526                	mv	a0,s1
    8000623e:	00000097          	auipc	ra,0x0
    80006242:	f70080e7          	jalr	-144(ra) # 800061ae <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006246:	4705                	li	a4,1
  if(holding(lk))
    80006248:	e115                	bnez	a0,8000626c <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000624a:	87ba                	mv	a5,a4
    8000624c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006250:	2781                	sext.w	a5,a5
    80006252:	ffe5                	bnez	a5,8000624a <acquire+0x22>
  __sync_synchronize();
    80006254:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006258:	ffffb097          	auipc	ra,0xffffb
    8000625c:	be0080e7          	jalr	-1056(ra) # 80000e38 <mycpu>
    80006260:	e888                	sd	a0,16(s1)
}
    80006262:	60e2                	ld	ra,24(sp)
    80006264:	6442                	ld	s0,16(sp)
    80006266:	64a2                	ld	s1,8(sp)
    80006268:	6105                	addi	sp,sp,32
    8000626a:	8082                	ret
    panic("acquire");
    8000626c:	00002517          	auipc	a0,0x2
    80006270:	5cc50513          	addi	a0,a0,1484 # 80008838 <digits+0x20>
    80006274:	00000097          	auipc	ra,0x0
    80006278:	aa6080e7          	jalr	-1370(ra) # 80005d1a <panic>

000000008000627c <pop_off>:

void
pop_off(void)
{
    8000627c:	1141                	addi	sp,sp,-16
    8000627e:	e406                	sd	ra,8(sp)
    80006280:	e022                	sd	s0,0(sp)
    80006282:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006284:	ffffb097          	auipc	ra,0xffffb
    80006288:	bb4080e7          	jalr	-1100(ra) # 80000e38 <mycpu>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    8000628c:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    80006290:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006292:	e78d                	bnez	a5,800062bc <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006294:	5d3c                	lw	a5,120(a0)
    80006296:	02f05b63          	blez	a5,800062cc <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000629a:	37fd                	addiw	a5,a5,-1
    8000629c:	0007871b          	sext.w	a4,a5
    800062a0:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800062a2:	eb09                	bnez	a4,800062b4 <pop_off+0x38>
    800062a4:	5d7c                	lw	a5,124(a0)
    800062a6:	c799                	beqz	a5,800062b4 <pop_off+0x38>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    800062a8:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    800062ac:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    800062b0:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800062b4:	60a2                	ld	ra,8(sp)
    800062b6:	6402                	ld	s0,0(sp)
    800062b8:	0141                	addi	sp,sp,16
    800062ba:	8082                	ret
    panic("pop_off - interruptible");
    800062bc:	00002517          	auipc	a0,0x2
    800062c0:	58450513          	addi	a0,a0,1412 # 80008840 <digits+0x28>
    800062c4:	00000097          	auipc	ra,0x0
    800062c8:	a56080e7          	jalr	-1450(ra) # 80005d1a <panic>
    panic("pop_off");
    800062cc:	00002517          	auipc	a0,0x2
    800062d0:	58c50513          	addi	a0,a0,1420 # 80008858 <digits+0x40>
    800062d4:	00000097          	auipc	ra,0x0
    800062d8:	a46080e7          	jalr	-1466(ra) # 80005d1a <panic>

00000000800062dc <release>:
{
    800062dc:	1101                	addi	sp,sp,-32
    800062de:	ec06                	sd	ra,24(sp)
    800062e0:	e822                	sd	s0,16(sp)
    800062e2:	e426                	sd	s1,8(sp)
    800062e4:	1000                	addi	s0,sp,32
    800062e6:	84aa                	mv	s1,a0
  if(!holding(lk))
    800062e8:	00000097          	auipc	ra,0x0
    800062ec:	ec6080e7          	jalr	-314(ra) # 800061ae <holding>
    800062f0:	c115                	beqz	a0,80006314 <release+0x38>
  lk->cpu = 0;
    800062f2:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800062f6:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800062fa:	0f50000f          	fence	iorw,ow
    800062fe:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006302:	00000097          	auipc	ra,0x0
    80006306:	f7a080e7          	jalr	-134(ra) # 8000627c <pop_off>
}
    8000630a:	60e2                	ld	ra,24(sp)
    8000630c:	6442                	ld	s0,16(sp)
    8000630e:	64a2                	ld	s1,8(sp)
    80006310:	6105                	addi	sp,sp,32
    80006312:	8082                	ret
    panic("release");
    80006314:	00002517          	auipc	a0,0x2
    80006318:	54c50513          	addi	a0,a0,1356 # 80008860 <digits+0x48>
    8000631c:	00000097          	auipc	ra,0x0
    80006320:	9fe080e7          	jalr	-1538(ra) # 80005d1a <panic>
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
