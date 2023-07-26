
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	92013103          	ld	sp,-1760(sp) # 80009920 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	710060ef          	jal	ra,80006726 <start>

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
    80000030:	00023797          	auipc	a5,0x23
    80000034:	43078793          	addi	a5,a5,1072 # 80023460 <end>
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
    80000050:	0000a917          	auipc	s2,0xa
    80000054:	94090913          	addi	s2,s2,-1728 # 80009990 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00007097          	auipc	ra,0x7
    8000005e:	0b8080e7          	jalr	184(ra) # 80007112 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00007097          	auipc	ra,0x7
    80000072:	158080e7          	jalr	344(ra) # 800071c6 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00009517          	auipc	a0,0x9
    80000086:	f8e50513          	addi	a0,a0,-114 # 80009010 <etext+0x10>
    8000008a:	00007097          	auipc	ra,0x7
    8000008e:	b50080e7          	jalr	-1200(ra) # 80006bda <panic>

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
    800000e6:	00009597          	auipc	a1,0x9
    800000ea:	f3258593          	addi	a1,a1,-206 # 80009018 <etext+0x18>
    800000ee:	0000a517          	auipc	a0,0xa
    800000f2:	8a250513          	addi	a0,a0,-1886 # 80009990 <kmem>
    800000f6:	00007097          	auipc	ra,0x7
    800000fa:	f8c080e7          	jalr	-116(ra) # 80007082 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00023517          	auipc	a0,0x23
    80000106:	35e50513          	addi	a0,a0,862 # 80023460 <end>
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
    80000124:	0000a497          	auipc	s1,0xa
    80000128:	86c48493          	addi	s1,s1,-1940 # 80009990 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00007097          	auipc	ra,0x7
    80000132:	fe4080e7          	jalr	-28(ra) # 80007112 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	0000a517          	auipc	a0,0xa
    80000140:	85450513          	addi	a0,a0,-1964 # 80009990 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00007097          	auipc	ra,0x7
    8000014a:	080080e7          	jalr	128(ra) # 800071c6 <release>

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
    80000168:	0000a517          	auipc	a0,0xa
    8000016c:	82850513          	addi	a0,a0,-2008 # 80009990 <kmem>
    80000170:	00007097          	auipc	ra,0x7
    80000174:	056080e7          	jalr	86(ra) # 800071c6 <release>
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
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdbba1>
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
    80000320:	1101                	addi	sp,sp,-32
    80000322:	ec06                	sd	ra,24(sp)
    80000324:	e822                	sd	s0,16(sp)
    80000326:	e426                	sd	s1,8(sp)
    80000328:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    8000032a:	00001097          	auipc	ra,0x1
    8000032e:	b56080e7          	jalr	-1194(ra) # 80000e80 <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(lockfree_read4((int *) &started) == 0)
    80000332:	00009497          	auipc	s1,0x9
    80000336:	60e48493          	addi	s1,s1,1550 # 80009940 <started>
  if(cpuid() == 0){
    8000033a:	c531                	beqz	a0,80000386 <main+0x66>
    while(lockfree_read4((int *) &started) == 0)
    8000033c:	8526                	mv	a0,s1
    8000033e:	00007097          	auipc	ra,0x7
    80000342:	ee6080e7          	jalr	-282(ra) # 80007224 <lockfree_read4>
    80000346:	d97d                	beqz	a0,8000033c <main+0x1c>
      ;
    __sync_synchronize();
    80000348:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034c:	00001097          	auipc	ra,0x1
    80000350:	b34080e7          	jalr	-1228(ra) # 80000e80 <cpuid>
    80000354:	85aa                	mv	a1,a0
    80000356:	00009517          	auipc	a0,0x9
    8000035a:	ce250513          	addi	a0,a0,-798 # 80009038 <etext+0x38>
    8000035e:	00007097          	auipc	ra,0x7
    80000362:	8c6080e7          	jalr	-1850(ra) # 80006c24 <printf>
    kvminithart();    // turn on paging
    80000366:	00000097          	auipc	ra,0x0
    8000036a:	0e8080e7          	jalr	232(ra) # 8000044e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	7dc080e7          	jalr	2012(ra) # 80001b4a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000376:	00005097          	auipc	ra,0x5
    8000037a:	e4e080e7          	jalr	-434(ra) # 800051c4 <plicinithart>
  }

  scheduler();        
    8000037e:	00001097          	auipc	ra,0x1
    80000382:	024080e7          	jalr	36(ra) # 800013a2 <scheduler>
    consoleinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	764080e7          	jalr	1892(ra) # 80006aea <consoleinit>
    printfinit();
    8000038e:	00007097          	auipc	ra,0x7
    80000392:	a76080e7          	jalr	-1418(ra) # 80006e04 <printfinit>
    printf("\n");
    80000396:	00009517          	auipc	a0,0x9
    8000039a:	cb250513          	addi	a0,a0,-846 # 80009048 <etext+0x48>
    8000039e:	00007097          	auipc	ra,0x7
    800003a2:	886080e7          	jalr	-1914(ra) # 80006c24 <printf>
    printf("xv6 kernel is booting\n");
    800003a6:	00009517          	auipc	a0,0x9
    800003aa:	c7a50513          	addi	a0,a0,-902 # 80009020 <etext+0x20>
    800003ae:	00007097          	auipc	ra,0x7
    800003b2:	876080e7          	jalr	-1930(ra) # 80006c24 <printf>
    printf("\n");
    800003b6:	00009517          	auipc	a0,0x9
    800003ba:	c9250513          	addi	a0,a0,-878 # 80009048 <etext+0x48>
    800003be:	00007097          	auipc	ra,0x7
    800003c2:	866080e7          	jalr	-1946(ra) # 80006c24 <printf>
    kinit();         // physical page allocator
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	d18080e7          	jalr	-744(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003ce:	00000097          	auipc	ra,0x0
    800003d2:	366080e7          	jalr	870(ra) # 80000734 <kvminit>
    kvminithart();   // turn on paging
    800003d6:	00000097          	auipc	ra,0x0
    800003da:	078080e7          	jalr	120(ra) # 8000044e <kvminithart>
    procinit();      // process table
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	9f0080e7          	jalr	-1552(ra) # 80000dce <procinit>
    trapinit();      // trap vectors
    800003e6:	00001097          	auipc	ra,0x1
    800003ea:	73c080e7          	jalr	1852(ra) # 80001b22 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ee:	00001097          	auipc	ra,0x1
    800003f2:	75c080e7          	jalr	1884(ra) # 80001b4a <trapinithart>
    plicinit();      // set up interrupt controller
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	da4080e7          	jalr	-604(ra) # 8000519a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fe:	00005097          	auipc	ra,0x5
    80000402:	dc6080e7          	jalr	-570(ra) # 800051c4 <plicinithart>
    binit();         // buffer cache
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	ea0080e7          	jalr	-352(ra) # 800022a6 <binit>
    iinit();         // inode table
    8000040e:	00002097          	auipc	ra,0x2
    80000412:	540080e7          	jalr	1344(ra) # 8000294e <iinit>
    fileinit();      // file table
    80000416:	00003097          	auipc	ra,0x3
    8000041a:	4e6080e7          	jalr	1254(ra) # 800038fc <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041e:	00005097          	auipc	ra,0x5
    80000422:	eb4080e7          	jalr	-332(ra) # 800052d2 <virtio_disk_init>
    pci_init();
    80000426:	00006097          	auipc	ra,0x6
    8000042a:	204080e7          	jalr	516(ra) # 8000662a <pci_init>
    sockinit();
    8000042e:	00006097          	auipc	ra,0x6
    80000432:	df0080e7          	jalr	-528(ra) # 8000621e <sockinit>
    userinit();      // first user process
    80000436:	00001097          	auipc	ra,0x1
    8000043a:	d4e080e7          	jalr	-690(ra) # 80001184 <userinit>
    __sync_synchronize();
    8000043e:	0ff0000f          	fence
    started = 1;
    80000442:	4785                	li	a5,1
    80000444:	00009717          	auipc	a4,0x9
    80000448:	4ef72e23          	sw	a5,1276(a4) # 80009940 <started>
    8000044c:	bf0d                	j	8000037e <main+0x5e>

000000008000044e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000044e:	1141                	addi	sp,sp,-16
    80000450:	e422                	sd	s0,8(sp)
    80000452:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000454:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000458:	00009797          	auipc	a5,0x9
    8000045c:	4f07b783          	ld	a5,1264(a5) # 80009948 <kernel_pagetable>
    80000460:	83b1                	srli	a5,a5,0xc
    80000462:	577d                	li	a4,-1
    80000464:	177e                	slli	a4,a4,0x3f
    80000466:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000468:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000046c:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000470:	6422                	ld	s0,8(sp)
    80000472:	0141                	addi	sp,sp,16
    80000474:	8082                	ret

0000000080000476 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000476:	7139                	addi	sp,sp,-64
    80000478:	fc06                	sd	ra,56(sp)
    8000047a:	f822                	sd	s0,48(sp)
    8000047c:	f426                	sd	s1,40(sp)
    8000047e:	f04a                	sd	s2,32(sp)
    80000480:	ec4e                	sd	s3,24(sp)
    80000482:	e852                	sd	s4,16(sp)
    80000484:	e456                	sd	s5,8(sp)
    80000486:	e05a                	sd	s6,0(sp)
    80000488:	0080                	addi	s0,sp,64
    8000048a:	84aa                	mv	s1,a0
    8000048c:	89ae                	mv	s3,a1
    8000048e:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000490:	57fd                	li	a5,-1
    80000492:	83e9                	srli	a5,a5,0x1a
    80000494:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000496:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000498:	04b7f263          	bgeu	a5,a1,800004dc <walk+0x66>
    panic("walk");
    8000049c:	00009517          	auipc	a0,0x9
    800004a0:	bb450513          	addi	a0,a0,-1100 # 80009050 <etext+0x50>
    800004a4:	00006097          	auipc	ra,0x6
    800004a8:	736080e7          	jalr	1846(ra) # 80006bda <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004ac:	060a8663          	beqz	s5,80000518 <walk+0xa2>
    800004b0:	00000097          	auipc	ra,0x0
    800004b4:	c6a080e7          	jalr	-918(ra) # 8000011a <kalloc>
    800004b8:	84aa                	mv	s1,a0
    800004ba:	c529                	beqz	a0,80000504 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004bc:	6605                	lui	a2,0x1
    800004be:	4581                	li	a1,0
    800004c0:	00000097          	auipc	ra,0x0
    800004c4:	cba080e7          	jalr	-838(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004c8:	00c4d793          	srli	a5,s1,0xc
    800004cc:	07aa                	slli	a5,a5,0xa
    800004ce:	0017e793          	ori	a5,a5,1
    800004d2:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004d6:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdbb97>
    800004d8:	036a0063          	beq	s4,s6,800004f8 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004dc:	0149d933          	srl	s2,s3,s4
    800004e0:	1ff97913          	andi	s2,s2,511
    800004e4:	090e                	slli	s2,s2,0x3
    800004e6:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004e8:	00093483          	ld	s1,0(s2)
    800004ec:	0014f793          	andi	a5,s1,1
    800004f0:	dfd5                	beqz	a5,800004ac <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004f2:	80a9                	srli	s1,s1,0xa
    800004f4:	04b2                	slli	s1,s1,0xc
    800004f6:	b7c5                	j	800004d6 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004f8:	00c9d513          	srli	a0,s3,0xc
    800004fc:	1ff57513          	andi	a0,a0,511
    80000500:	050e                	slli	a0,a0,0x3
    80000502:	9526                	add	a0,a0,s1
}
    80000504:	70e2                	ld	ra,56(sp)
    80000506:	7442                	ld	s0,48(sp)
    80000508:	74a2                	ld	s1,40(sp)
    8000050a:	7902                	ld	s2,32(sp)
    8000050c:	69e2                	ld	s3,24(sp)
    8000050e:	6a42                	ld	s4,16(sp)
    80000510:	6aa2                	ld	s5,8(sp)
    80000512:	6b02                	ld	s6,0(sp)
    80000514:	6121                	addi	sp,sp,64
    80000516:	8082                	ret
        return 0;
    80000518:	4501                	li	a0,0
    8000051a:	b7ed                	j	80000504 <walk+0x8e>

000000008000051c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000051c:	57fd                	li	a5,-1
    8000051e:	83e9                	srli	a5,a5,0x1a
    80000520:	00b7f463          	bgeu	a5,a1,80000528 <walkaddr+0xc>
    return 0;
    80000524:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000526:	8082                	ret
{
    80000528:	1141                	addi	sp,sp,-16
    8000052a:	e406                	sd	ra,8(sp)
    8000052c:	e022                	sd	s0,0(sp)
    8000052e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000530:	4601                	li	a2,0
    80000532:	00000097          	auipc	ra,0x0
    80000536:	f44080e7          	jalr	-188(ra) # 80000476 <walk>
  if(pte == 0)
    8000053a:	c105                	beqz	a0,8000055a <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000053c:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000053e:	0117f693          	andi	a3,a5,17
    80000542:	4745                	li	a4,17
    return 0;
    80000544:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000546:	00e68663          	beq	a3,a4,80000552 <walkaddr+0x36>
}
    8000054a:	60a2                	ld	ra,8(sp)
    8000054c:	6402                	ld	s0,0(sp)
    8000054e:	0141                	addi	sp,sp,16
    80000550:	8082                	ret
  pa = PTE2PA(*pte);
    80000552:	83a9                	srli	a5,a5,0xa
    80000554:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000558:	bfcd                	j	8000054a <walkaddr+0x2e>
    return 0;
    8000055a:	4501                	li	a0,0
    8000055c:	b7fd                	j	8000054a <walkaddr+0x2e>

000000008000055e <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000055e:	715d                	addi	sp,sp,-80
    80000560:	e486                	sd	ra,72(sp)
    80000562:	e0a2                	sd	s0,64(sp)
    80000564:	fc26                	sd	s1,56(sp)
    80000566:	f84a                	sd	s2,48(sp)
    80000568:	f44e                	sd	s3,40(sp)
    8000056a:	f052                	sd	s4,32(sp)
    8000056c:	ec56                	sd	s5,24(sp)
    8000056e:	e85a                	sd	s6,16(sp)
    80000570:	e45e                	sd	s7,8(sp)
    80000572:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000574:	c639                	beqz	a2,800005c2 <mappages+0x64>
    80000576:	8aaa                	mv	s5,a0
    80000578:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000057a:	777d                	lui	a4,0xfffff
    8000057c:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000580:	fff58993          	addi	s3,a1,-1
    80000584:	99b2                	add	s3,s3,a2
    80000586:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000058a:	893e                	mv	s2,a5
    8000058c:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000590:	6b85                	lui	s7,0x1
    80000592:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000596:	4605                	li	a2,1
    80000598:	85ca                	mv	a1,s2
    8000059a:	8556                	mv	a0,s5
    8000059c:	00000097          	auipc	ra,0x0
    800005a0:	eda080e7          	jalr	-294(ra) # 80000476 <walk>
    800005a4:	cd1d                	beqz	a0,800005e2 <mappages+0x84>
    if(*pte & PTE_V)
    800005a6:	611c                	ld	a5,0(a0)
    800005a8:	8b85                	andi	a5,a5,1
    800005aa:	e785                	bnez	a5,800005d2 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005ac:	80b1                	srli	s1,s1,0xc
    800005ae:	04aa                	slli	s1,s1,0xa
    800005b0:	0164e4b3          	or	s1,s1,s6
    800005b4:	0014e493          	ori	s1,s1,1
    800005b8:	e104                	sd	s1,0(a0)
    if(a == last)
    800005ba:	05390063          	beq	s2,s3,800005fa <mappages+0x9c>
    a += PGSIZE;
    800005be:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005c0:	bfc9                	j	80000592 <mappages+0x34>
    panic("mappages: size");
    800005c2:	00009517          	auipc	a0,0x9
    800005c6:	a9650513          	addi	a0,a0,-1386 # 80009058 <etext+0x58>
    800005ca:	00006097          	auipc	ra,0x6
    800005ce:	610080e7          	jalr	1552(ra) # 80006bda <panic>
      panic("mappages: remap");
    800005d2:	00009517          	auipc	a0,0x9
    800005d6:	a9650513          	addi	a0,a0,-1386 # 80009068 <etext+0x68>
    800005da:	00006097          	auipc	ra,0x6
    800005de:	600080e7          	jalr	1536(ra) # 80006bda <panic>
      return -1;
    800005e2:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005e4:	60a6                	ld	ra,72(sp)
    800005e6:	6406                	ld	s0,64(sp)
    800005e8:	74e2                	ld	s1,56(sp)
    800005ea:	7942                	ld	s2,48(sp)
    800005ec:	79a2                	ld	s3,40(sp)
    800005ee:	7a02                	ld	s4,32(sp)
    800005f0:	6ae2                	ld	s5,24(sp)
    800005f2:	6b42                	ld	s6,16(sp)
    800005f4:	6ba2                	ld	s7,8(sp)
    800005f6:	6161                	addi	sp,sp,80
    800005f8:	8082                	ret
  return 0;
    800005fa:	4501                	li	a0,0
    800005fc:	b7e5                	j	800005e4 <mappages+0x86>

00000000800005fe <kvmmap>:
{
    800005fe:	1141                	addi	sp,sp,-16
    80000600:	e406                	sd	ra,8(sp)
    80000602:	e022                	sd	s0,0(sp)
    80000604:	0800                	addi	s0,sp,16
    80000606:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000608:	86b2                	mv	a3,a2
    8000060a:	863e                	mv	a2,a5
    8000060c:	00000097          	auipc	ra,0x0
    80000610:	f52080e7          	jalr	-174(ra) # 8000055e <mappages>
    80000614:	e509                	bnez	a0,8000061e <kvmmap+0x20>
}
    80000616:	60a2                	ld	ra,8(sp)
    80000618:	6402                	ld	s0,0(sp)
    8000061a:	0141                	addi	sp,sp,16
    8000061c:	8082                	ret
    panic("kvmmap");
    8000061e:	00009517          	auipc	a0,0x9
    80000622:	a5a50513          	addi	a0,a0,-1446 # 80009078 <etext+0x78>
    80000626:	00006097          	auipc	ra,0x6
    8000062a:	5b4080e7          	jalr	1460(ra) # 80006bda <panic>

000000008000062e <kvmmake>:
{
    8000062e:	1101                	addi	sp,sp,-32
    80000630:	ec06                	sd	ra,24(sp)
    80000632:	e822                	sd	s0,16(sp)
    80000634:	e426                	sd	s1,8(sp)
    80000636:	e04a                	sd	s2,0(sp)
    80000638:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000063a:	00000097          	auipc	ra,0x0
    8000063e:	ae0080e7          	jalr	-1312(ra) # 8000011a <kalloc>
    80000642:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000644:	6605                	lui	a2,0x1
    80000646:	4581                	li	a1,0
    80000648:	00000097          	auipc	ra,0x0
    8000064c:	b32080e7          	jalr	-1230(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000650:	4719                	li	a4,6
    80000652:	6685                	lui	a3,0x1
    80000654:	10000637          	lui	a2,0x10000
    80000658:	100005b7          	lui	a1,0x10000
    8000065c:	8526                	mv	a0,s1
    8000065e:	00000097          	auipc	ra,0x0
    80000662:	fa0080e7          	jalr	-96(ra) # 800005fe <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000666:	4719                	li	a4,6
    80000668:	6685                	lui	a3,0x1
    8000066a:	10001637          	lui	a2,0x10001
    8000066e:	100015b7          	lui	a1,0x10001
    80000672:	8526                	mv	a0,s1
    80000674:	00000097          	auipc	ra,0x0
    80000678:	f8a080e7          	jalr	-118(ra) # 800005fe <kvmmap>
  kvmmap(kpgtbl, 0x30000000L, 0x30000000L, 0x10000000, PTE_R | PTE_W);
    8000067c:	4719                	li	a4,6
    8000067e:	100006b7          	lui	a3,0x10000
    80000682:	30000637          	lui	a2,0x30000
    80000686:	300005b7          	lui	a1,0x30000
    8000068a:	8526                	mv	a0,s1
    8000068c:	00000097          	auipc	ra,0x0
    80000690:	f72080e7          	jalr	-142(ra) # 800005fe <kvmmap>
  kvmmap(kpgtbl, 0x40000000L, 0x40000000L, 0x20000, PTE_R | PTE_W);
    80000694:	4719                	li	a4,6
    80000696:	000206b7          	lui	a3,0x20
    8000069a:	40000637          	lui	a2,0x40000
    8000069e:	400005b7          	lui	a1,0x40000
    800006a2:	8526                	mv	a0,s1
    800006a4:	00000097          	auipc	ra,0x0
    800006a8:	f5a080e7          	jalr	-166(ra) # 800005fe <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006ac:	4719                	li	a4,6
    800006ae:	004006b7          	lui	a3,0x400
    800006b2:	0c000637          	lui	a2,0xc000
    800006b6:	0c0005b7          	lui	a1,0xc000
    800006ba:	8526                	mv	a0,s1
    800006bc:	00000097          	auipc	ra,0x0
    800006c0:	f42080e7          	jalr	-190(ra) # 800005fe <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006c4:	00009917          	auipc	s2,0x9
    800006c8:	93c90913          	addi	s2,s2,-1732 # 80009000 <etext>
    800006cc:	4729                	li	a4,10
    800006ce:	80009697          	auipc	a3,0x80009
    800006d2:	93268693          	addi	a3,a3,-1742 # 9000 <_entry-0x7fff7000>
    800006d6:	4605                	li	a2,1
    800006d8:	067e                	slli	a2,a2,0x1f
    800006da:	85b2                	mv	a1,a2
    800006dc:	8526                	mv	a0,s1
    800006de:	00000097          	auipc	ra,0x0
    800006e2:	f20080e7          	jalr	-224(ra) # 800005fe <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006e6:	4719                	li	a4,6
    800006e8:	46c5                	li	a3,17
    800006ea:	06ee                	slli	a3,a3,0x1b
    800006ec:	412686b3          	sub	a3,a3,s2
    800006f0:	864a                	mv	a2,s2
    800006f2:	85ca                	mv	a1,s2
    800006f4:	8526                	mv	a0,s1
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	f08080e7          	jalr	-248(ra) # 800005fe <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006fe:	4729                	li	a4,10
    80000700:	6685                	lui	a3,0x1
    80000702:	00008617          	auipc	a2,0x8
    80000706:	8fe60613          	addi	a2,a2,-1794 # 80008000 <_trampoline>
    8000070a:	040005b7          	lui	a1,0x4000
    8000070e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000710:	05b2                	slli	a1,a1,0xc
    80000712:	8526                	mv	a0,s1
    80000714:	00000097          	auipc	ra,0x0
    80000718:	eea080e7          	jalr	-278(ra) # 800005fe <kvmmap>
  proc_mapstacks(kpgtbl);
    8000071c:	8526                	mv	a0,s1
    8000071e:	00000097          	auipc	ra,0x0
    80000722:	61c080e7          	jalr	1564(ra) # 80000d3a <proc_mapstacks>
}
    80000726:	8526                	mv	a0,s1
    80000728:	60e2                	ld	ra,24(sp)
    8000072a:	6442                	ld	s0,16(sp)
    8000072c:	64a2                	ld	s1,8(sp)
    8000072e:	6902                	ld	s2,0(sp)
    80000730:	6105                	addi	sp,sp,32
    80000732:	8082                	ret

0000000080000734 <kvminit>:
{
    80000734:	1141                	addi	sp,sp,-16
    80000736:	e406                	sd	ra,8(sp)
    80000738:	e022                	sd	s0,0(sp)
    8000073a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000073c:	00000097          	auipc	ra,0x0
    80000740:	ef2080e7          	jalr	-270(ra) # 8000062e <kvmmake>
    80000744:	00009797          	auipc	a5,0x9
    80000748:	20a7b223          	sd	a0,516(a5) # 80009948 <kernel_pagetable>
}
    8000074c:	60a2                	ld	ra,8(sp)
    8000074e:	6402                	ld	s0,0(sp)
    80000750:	0141                	addi	sp,sp,16
    80000752:	8082                	ret

0000000080000754 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000754:	715d                	addi	sp,sp,-80
    80000756:	e486                	sd	ra,72(sp)
    80000758:	e0a2                	sd	s0,64(sp)
    8000075a:	fc26                	sd	s1,56(sp)
    8000075c:	f84a                	sd	s2,48(sp)
    8000075e:	f44e                	sd	s3,40(sp)
    80000760:	f052                	sd	s4,32(sp)
    80000762:	ec56                	sd	s5,24(sp)
    80000764:	e85a                	sd	s6,16(sp)
    80000766:	e45e                	sd	s7,8(sp)
    80000768:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000076a:	03459793          	slli	a5,a1,0x34
    8000076e:	e795                	bnez	a5,8000079a <uvmunmap+0x46>
    80000770:	8a2a                	mv	s4,a0
    80000772:	892e                	mv	s2,a1
    80000774:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000776:	0632                	slli	a2,a2,0xc
    80000778:	00b609b3          	add	s3,a2,a1
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0) {
      printf("va=%p pte=%p\n", a, *pte);
      panic("uvmunmap: not mapped");
    }
    if(PTE_FLAGS(*pte) == PTE_V)
    8000077c:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000077e:	6b05                	lui	s6,0x1
    80000780:	0735eb63          	bltu	a1,s3,800007f6 <uvmunmap+0xa2>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000784:	60a6                	ld	ra,72(sp)
    80000786:	6406                	ld	s0,64(sp)
    80000788:	74e2                	ld	s1,56(sp)
    8000078a:	7942                	ld	s2,48(sp)
    8000078c:	79a2                	ld	s3,40(sp)
    8000078e:	7a02                	ld	s4,32(sp)
    80000790:	6ae2                	ld	s5,24(sp)
    80000792:	6b42                	ld	s6,16(sp)
    80000794:	6ba2                	ld	s7,8(sp)
    80000796:	6161                	addi	sp,sp,80
    80000798:	8082                	ret
    panic("uvmunmap: not aligned");
    8000079a:	00009517          	auipc	a0,0x9
    8000079e:	8e650513          	addi	a0,a0,-1818 # 80009080 <etext+0x80>
    800007a2:	00006097          	auipc	ra,0x6
    800007a6:	438080e7          	jalr	1080(ra) # 80006bda <panic>
      panic("uvmunmap: walk");
    800007aa:	00009517          	auipc	a0,0x9
    800007ae:	8ee50513          	addi	a0,a0,-1810 # 80009098 <etext+0x98>
    800007b2:	00006097          	auipc	ra,0x6
    800007b6:	428080e7          	jalr	1064(ra) # 80006bda <panic>
      printf("va=%p pte=%p\n", a, *pte);
    800007ba:	85ca                	mv	a1,s2
    800007bc:	00009517          	auipc	a0,0x9
    800007c0:	8ec50513          	addi	a0,a0,-1812 # 800090a8 <etext+0xa8>
    800007c4:	00006097          	auipc	ra,0x6
    800007c8:	460080e7          	jalr	1120(ra) # 80006c24 <printf>
      panic("uvmunmap: not mapped");
    800007cc:	00009517          	auipc	a0,0x9
    800007d0:	8ec50513          	addi	a0,a0,-1812 # 800090b8 <etext+0xb8>
    800007d4:	00006097          	auipc	ra,0x6
    800007d8:	406080e7          	jalr	1030(ra) # 80006bda <panic>
      panic("uvmunmap: not a leaf");
    800007dc:	00009517          	auipc	a0,0x9
    800007e0:	8f450513          	addi	a0,a0,-1804 # 800090d0 <etext+0xd0>
    800007e4:	00006097          	auipc	ra,0x6
    800007e8:	3f6080e7          	jalr	1014(ra) # 80006bda <panic>
    *pte = 0;
    800007ec:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007f0:	995a                	add	s2,s2,s6
    800007f2:	f93979e3          	bgeu	s2,s3,80000784 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007f6:	4601                	li	a2,0
    800007f8:	85ca                	mv	a1,s2
    800007fa:	8552                	mv	a0,s4
    800007fc:	00000097          	auipc	ra,0x0
    80000800:	c7a080e7          	jalr	-902(ra) # 80000476 <walk>
    80000804:	84aa                	mv	s1,a0
    80000806:	d155                	beqz	a0,800007aa <uvmunmap+0x56>
    if((*pte & PTE_V) == 0) {
    80000808:	6110                	ld	a2,0(a0)
    8000080a:	00167793          	andi	a5,a2,1
    8000080e:	d7d5                	beqz	a5,800007ba <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000810:	3ff67793          	andi	a5,a2,1023
    80000814:	fd7784e3          	beq	a5,s7,800007dc <uvmunmap+0x88>
    if(do_free){
    80000818:	fc0a8ae3          	beqz	s5,800007ec <uvmunmap+0x98>
      uint64 pa = PTE2PA(*pte);
    8000081c:	8229                	srli	a2,a2,0xa
      kfree((void*)pa);
    8000081e:	00c61513          	slli	a0,a2,0xc
    80000822:	fffff097          	auipc	ra,0xfffff
    80000826:	7fa080e7          	jalr	2042(ra) # 8000001c <kfree>
    8000082a:	b7c9                	j	800007ec <uvmunmap+0x98>

000000008000082c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000082c:	1101                	addi	sp,sp,-32
    8000082e:	ec06                	sd	ra,24(sp)
    80000830:	e822                	sd	s0,16(sp)
    80000832:	e426                	sd	s1,8(sp)
    80000834:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000836:	00000097          	auipc	ra,0x0
    8000083a:	8e4080e7          	jalr	-1820(ra) # 8000011a <kalloc>
    8000083e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000840:	c519                	beqz	a0,8000084e <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000842:	6605                	lui	a2,0x1
    80000844:	4581                	li	a1,0
    80000846:	00000097          	auipc	ra,0x0
    8000084a:	934080e7          	jalr	-1740(ra) # 8000017a <memset>
  return pagetable;
}
    8000084e:	8526                	mv	a0,s1
    80000850:	60e2                	ld	ra,24(sp)
    80000852:	6442                	ld	s0,16(sp)
    80000854:	64a2                	ld	s1,8(sp)
    80000856:	6105                	addi	sp,sp,32
    80000858:	8082                	ret

000000008000085a <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000085a:	7179                	addi	sp,sp,-48
    8000085c:	f406                	sd	ra,40(sp)
    8000085e:	f022                	sd	s0,32(sp)
    80000860:	ec26                	sd	s1,24(sp)
    80000862:	e84a                	sd	s2,16(sp)
    80000864:	e44e                	sd	s3,8(sp)
    80000866:	e052                	sd	s4,0(sp)
    80000868:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000086a:	6785                	lui	a5,0x1
    8000086c:	04f67863          	bgeu	a2,a5,800008bc <uvmfirst+0x62>
    80000870:	8a2a                	mv	s4,a0
    80000872:	89ae                	mv	s3,a1
    80000874:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000876:	00000097          	auipc	ra,0x0
    8000087a:	8a4080e7          	jalr	-1884(ra) # 8000011a <kalloc>
    8000087e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000880:	6605                	lui	a2,0x1
    80000882:	4581                	li	a1,0
    80000884:	00000097          	auipc	ra,0x0
    80000888:	8f6080e7          	jalr	-1802(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000088c:	4779                	li	a4,30
    8000088e:	86ca                	mv	a3,s2
    80000890:	6605                	lui	a2,0x1
    80000892:	4581                	li	a1,0
    80000894:	8552                	mv	a0,s4
    80000896:	00000097          	auipc	ra,0x0
    8000089a:	cc8080e7          	jalr	-824(ra) # 8000055e <mappages>
  memmove(mem, src, sz);
    8000089e:	8626                	mv	a2,s1
    800008a0:	85ce                	mv	a1,s3
    800008a2:	854a                	mv	a0,s2
    800008a4:	00000097          	auipc	ra,0x0
    800008a8:	932080e7          	jalr	-1742(ra) # 800001d6 <memmove>
}
    800008ac:	70a2                	ld	ra,40(sp)
    800008ae:	7402                	ld	s0,32(sp)
    800008b0:	64e2                	ld	s1,24(sp)
    800008b2:	6942                	ld	s2,16(sp)
    800008b4:	69a2                	ld	s3,8(sp)
    800008b6:	6a02                	ld	s4,0(sp)
    800008b8:	6145                	addi	sp,sp,48
    800008ba:	8082                	ret
    panic("uvmfirst: more than a page");
    800008bc:	00009517          	auipc	a0,0x9
    800008c0:	82c50513          	addi	a0,a0,-2004 # 800090e8 <etext+0xe8>
    800008c4:	00006097          	auipc	ra,0x6
    800008c8:	316080e7          	jalr	790(ra) # 80006bda <panic>

00000000800008cc <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008cc:	1101                	addi	sp,sp,-32
    800008ce:	ec06                	sd	ra,24(sp)
    800008d0:	e822                	sd	s0,16(sp)
    800008d2:	e426                	sd	s1,8(sp)
    800008d4:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008d6:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008d8:	00b67d63          	bgeu	a2,a1,800008f2 <uvmdealloc+0x26>
    800008dc:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008de:	6785                	lui	a5,0x1
    800008e0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008e2:	00f60733          	add	a4,a2,a5
    800008e6:	76fd                	lui	a3,0xfffff
    800008e8:	8f75                	and	a4,a4,a3
    800008ea:	97ae                	add	a5,a5,a1
    800008ec:	8ff5                	and	a5,a5,a3
    800008ee:	00f76863          	bltu	a4,a5,800008fe <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008f2:	8526                	mv	a0,s1
    800008f4:	60e2                	ld	ra,24(sp)
    800008f6:	6442                	ld	s0,16(sp)
    800008f8:	64a2                	ld	s1,8(sp)
    800008fa:	6105                	addi	sp,sp,32
    800008fc:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008fe:	8f99                	sub	a5,a5,a4
    80000900:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000902:	4685                	li	a3,1
    80000904:	0007861b          	sext.w	a2,a5
    80000908:	85ba                	mv	a1,a4
    8000090a:	00000097          	auipc	ra,0x0
    8000090e:	e4a080e7          	jalr	-438(ra) # 80000754 <uvmunmap>
    80000912:	b7c5                	j	800008f2 <uvmdealloc+0x26>

0000000080000914 <uvmalloc>:
  if(newsz < oldsz)
    80000914:	0ab66563          	bltu	a2,a1,800009be <uvmalloc+0xaa>
{
    80000918:	7139                	addi	sp,sp,-64
    8000091a:	fc06                	sd	ra,56(sp)
    8000091c:	f822                	sd	s0,48(sp)
    8000091e:	f426                	sd	s1,40(sp)
    80000920:	f04a                	sd	s2,32(sp)
    80000922:	ec4e                	sd	s3,24(sp)
    80000924:	e852                	sd	s4,16(sp)
    80000926:	e456                	sd	s5,8(sp)
    80000928:	e05a                	sd	s6,0(sp)
    8000092a:	0080                	addi	s0,sp,64
    8000092c:	8aaa                	mv	s5,a0
    8000092e:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000930:	6785                	lui	a5,0x1
    80000932:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000934:	95be                	add	a1,a1,a5
    80000936:	77fd                	lui	a5,0xfffff
    80000938:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000093c:	08c9f363          	bgeu	s3,a2,800009c2 <uvmalloc+0xae>
    80000940:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000942:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000946:	fffff097          	auipc	ra,0xfffff
    8000094a:	7d4080e7          	jalr	2004(ra) # 8000011a <kalloc>
    8000094e:	84aa                	mv	s1,a0
    if(mem == 0){
    80000950:	c51d                	beqz	a0,8000097e <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80000952:	6605                	lui	a2,0x1
    80000954:	4581                	li	a1,0
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	824080e7          	jalr	-2012(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000095e:	875a                	mv	a4,s6
    80000960:	86a6                	mv	a3,s1
    80000962:	6605                	lui	a2,0x1
    80000964:	85ca                	mv	a1,s2
    80000966:	8556                	mv	a0,s5
    80000968:	00000097          	auipc	ra,0x0
    8000096c:	bf6080e7          	jalr	-1034(ra) # 8000055e <mappages>
    80000970:	e90d                	bnez	a0,800009a2 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000972:	6785                	lui	a5,0x1
    80000974:	993e                	add	s2,s2,a5
    80000976:	fd4968e3          	bltu	s2,s4,80000946 <uvmalloc+0x32>
  return newsz;
    8000097a:	8552                	mv	a0,s4
    8000097c:	a809                	j	8000098e <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    8000097e:	864e                	mv	a2,s3
    80000980:	85ca                	mv	a1,s2
    80000982:	8556                	mv	a0,s5
    80000984:	00000097          	auipc	ra,0x0
    80000988:	f48080e7          	jalr	-184(ra) # 800008cc <uvmdealloc>
      return 0;
    8000098c:	4501                	li	a0,0
}
    8000098e:	70e2                	ld	ra,56(sp)
    80000990:	7442                	ld	s0,48(sp)
    80000992:	74a2                	ld	s1,40(sp)
    80000994:	7902                	ld	s2,32(sp)
    80000996:	69e2                	ld	s3,24(sp)
    80000998:	6a42                	ld	s4,16(sp)
    8000099a:	6aa2                	ld	s5,8(sp)
    8000099c:	6b02                	ld	s6,0(sp)
    8000099e:	6121                	addi	sp,sp,64
    800009a0:	8082                	ret
      kfree(mem);
    800009a2:	8526                	mv	a0,s1
    800009a4:	fffff097          	auipc	ra,0xfffff
    800009a8:	678080e7          	jalr	1656(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800009ac:	864e                	mv	a2,s3
    800009ae:	85ca                	mv	a1,s2
    800009b0:	8556                	mv	a0,s5
    800009b2:	00000097          	auipc	ra,0x0
    800009b6:	f1a080e7          	jalr	-230(ra) # 800008cc <uvmdealloc>
      return 0;
    800009ba:	4501                	li	a0,0
    800009bc:	bfc9                	j	8000098e <uvmalloc+0x7a>
    return oldsz;
    800009be:	852e                	mv	a0,a1
}
    800009c0:	8082                	ret
  return newsz;
    800009c2:	8532                	mv	a0,a2
    800009c4:	b7e9                	j	8000098e <uvmalloc+0x7a>

00000000800009c6 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009c6:	7179                	addi	sp,sp,-48
    800009c8:	f406                	sd	ra,40(sp)
    800009ca:	f022                	sd	s0,32(sp)
    800009cc:	ec26                	sd	s1,24(sp)
    800009ce:	e84a                	sd	s2,16(sp)
    800009d0:	e44e                	sd	s3,8(sp)
    800009d2:	e052                	sd	s4,0(sp)
    800009d4:	1800                	addi	s0,sp,48
    800009d6:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009d8:	84aa                	mv	s1,a0
    800009da:	6905                	lui	s2,0x1
    800009dc:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009de:	4985                	li	s3,1
    800009e0:	a829                	j	800009fa <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009e2:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009e4:	00c79513          	slli	a0,a5,0xc
    800009e8:	00000097          	auipc	ra,0x0
    800009ec:	fde080e7          	jalr	-34(ra) # 800009c6 <freewalk>
      pagetable[i] = 0;
    800009f0:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009f4:	04a1                	addi	s1,s1,8
    800009f6:	03248163          	beq	s1,s2,80000a18 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009fa:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009fc:	00f7f713          	andi	a4,a5,15
    80000a00:	ff3701e3          	beq	a4,s3,800009e2 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000a04:	8b85                	andi	a5,a5,1
    80000a06:	d7fd                	beqz	a5,800009f4 <freewalk+0x2e>
      panic("freewalk: leaf");
    80000a08:	00008517          	auipc	a0,0x8
    80000a0c:	70050513          	addi	a0,a0,1792 # 80009108 <etext+0x108>
    80000a10:	00006097          	auipc	ra,0x6
    80000a14:	1ca080e7          	jalr	458(ra) # 80006bda <panic>
    }
  }
  kfree((void*)pagetable);
    80000a18:	8552                	mv	a0,s4
    80000a1a:	fffff097          	auipc	ra,0xfffff
    80000a1e:	602080e7          	jalr	1538(ra) # 8000001c <kfree>
}
    80000a22:	70a2                	ld	ra,40(sp)
    80000a24:	7402                	ld	s0,32(sp)
    80000a26:	64e2                	ld	s1,24(sp)
    80000a28:	6942                	ld	s2,16(sp)
    80000a2a:	69a2                	ld	s3,8(sp)
    80000a2c:	6a02                	ld	s4,0(sp)
    80000a2e:	6145                	addi	sp,sp,48
    80000a30:	8082                	ret

0000000080000a32 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a32:	1101                	addi	sp,sp,-32
    80000a34:	ec06                	sd	ra,24(sp)
    80000a36:	e822                	sd	s0,16(sp)
    80000a38:	e426                	sd	s1,8(sp)
    80000a3a:	1000                	addi	s0,sp,32
    80000a3c:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a3e:	e999                	bnez	a1,80000a54 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a40:	8526                	mv	a0,s1
    80000a42:	00000097          	auipc	ra,0x0
    80000a46:	f84080e7          	jalr	-124(ra) # 800009c6 <freewalk>
}
    80000a4a:	60e2                	ld	ra,24(sp)
    80000a4c:	6442                	ld	s0,16(sp)
    80000a4e:	64a2                	ld	s1,8(sp)
    80000a50:	6105                	addi	sp,sp,32
    80000a52:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a54:	6785                	lui	a5,0x1
    80000a56:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a58:	95be                	add	a1,a1,a5
    80000a5a:	4685                	li	a3,1
    80000a5c:	00c5d613          	srli	a2,a1,0xc
    80000a60:	4581                	li	a1,0
    80000a62:	00000097          	auipc	ra,0x0
    80000a66:	cf2080e7          	jalr	-782(ra) # 80000754 <uvmunmap>
    80000a6a:	bfd9                	j	80000a40 <uvmfree+0xe>

0000000080000a6c <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a6c:	c679                	beqz	a2,80000b3a <uvmcopy+0xce>
{
    80000a6e:	715d                	addi	sp,sp,-80
    80000a70:	e486                	sd	ra,72(sp)
    80000a72:	e0a2                	sd	s0,64(sp)
    80000a74:	fc26                	sd	s1,56(sp)
    80000a76:	f84a                	sd	s2,48(sp)
    80000a78:	f44e                	sd	s3,40(sp)
    80000a7a:	f052                	sd	s4,32(sp)
    80000a7c:	ec56                	sd	s5,24(sp)
    80000a7e:	e85a                	sd	s6,16(sp)
    80000a80:	e45e                	sd	s7,8(sp)
    80000a82:	0880                	addi	s0,sp,80
    80000a84:	8b2a                	mv	s6,a0
    80000a86:	8aae                	mv	s5,a1
    80000a88:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a8a:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a8c:	4601                	li	a2,0
    80000a8e:	85ce                	mv	a1,s3
    80000a90:	855a                	mv	a0,s6
    80000a92:	00000097          	auipc	ra,0x0
    80000a96:	9e4080e7          	jalr	-1564(ra) # 80000476 <walk>
    80000a9a:	c531                	beqz	a0,80000ae6 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a9c:	6118                	ld	a4,0(a0)
    80000a9e:	00177793          	andi	a5,a4,1
    80000aa2:	cbb1                	beqz	a5,80000af6 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000aa4:	00a75593          	srli	a1,a4,0xa
    80000aa8:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000aac:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000ab0:	fffff097          	auipc	ra,0xfffff
    80000ab4:	66a080e7          	jalr	1642(ra) # 8000011a <kalloc>
    80000ab8:	892a                	mv	s2,a0
    80000aba:	c939                	beqz	a0,80000b10 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000abc:	6605                	lui	a2,0x1
    80000abe:	85de                	mv	a1,s7
    80000ac0:	fffff097          	auipc	ra,0xfffff
    80000ac4:	716080e7          	jalr	1814(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000ac8:	8726                	mv	a4,s1
    80000aca:	86ca                	mv	a3,s2
    80000acc:	6605                	lui	a2,0x1
    80000ace:	85ce                	mv	a1,s3
    80000ad0:	8556                	mv	a0,s5
    80000ad2:	00000097          	auipc	ra,0x0
    80000ad6:	a8c080e7          	jalr	-1396(ra) # 8000055e <mappages>
    80000ada:	e515                	bnez	a0,80000b06 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000adc:	6785                	lui	a5,0x1
    80000ade:	99be                	add	s3,s3,a5
    80000ae0:	fb49e6e3          	bltu	s3,s4,80000a8c <uvmcopy+0x20>
    80000ae4:	a081                	j	80000b24 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ae6:	00008517          	auipc	a0,0x8
    80000aea:	63250513          	addi	a0,a0,1586 # 80009118 <etext+0x118>
    80000aee:	00006097          	auipc	ra,0x6
    80000af2:	0ec080e7          	jalr	236(ra) # 80006bda <panic>
      panic("uvmcopy: page not present");
    80000af6:	00008517          	auipc	a0,0x8
    80000afa:	64250513          	addi	a0,a0,1602 # 80009138 <etext+0x138>
    80000afe:	00006097          	auipc	ra,0x6
    80000b02:	0dc080e7          	jalr	220(ra) # 80006bda <panic>
      kfree(mem);
    80000b06:	854a                	mv	a0,s2
    80000b08:	fffff097          	auipc	ra,0xfffff
    80000b0c:	514080e7          	jalr	1300(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b10:	4685                	li	a3,1
    80000b12:	00c9d613          	srli	a2,s3,0xc
    80000b16:	4581                	li	a1,0
    80000b18:	8556                	mv	a0,s5
    80000b1a:	00000097          	auipc	ra,0x0
    80000b1e:	c3a080e7          	jalr	-966(ra) # 80000754 <uvmunmap>
  return -1;
    80000b22:	557d                	li	a0,-1
}
    80000b24:	60a6                	ld	ra,72(sp)
    80000b26:	6406                	ld	s0,64(sp)
    80000b28:	74e2                	ld	s1,56(sp)
    80000b2a:	7942                	ld	s2,48(sp)
    80000b2c:	79a2                	ld	s3,40(sp)
    80000b2e:	7a02                	ld	s4,32(sp)
    80000b30:	6ae2                	ld	s5,24(sp)
    80000b32:	6b42                	ld	s6,16(sp)
    80000b34:	6ba2                	ld	s7,8(sp)
    80000b36:	6161                	addi	sp,sp,80
    80000b38:	8082                	ret
  return 0;
    80000b3a:	4501                	li	a0,0
}
    80000b3c:	8082                	ret

0000000080000b3e <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b3e:	1141                	addi	sp,sp,-16
    80000b40:	e406                	sd	ra,8(sp)
    80000b42:	e022                	sd	s0,0(sp)
    80000b44:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b46:	4601                	li	a2,0
    80000b48:	00000097          	auipc	ra,0x0
    80000b4c:	92e080e7          	jalr	-1746(ra) # 80000476 <walk>
  if(pte == 0)
    80000b50:	c901                	beqz	a0,80000b60 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b52:	611c                	ld	a5,0(a0)
    80000b54:	9bbd                	andi	a5,a5,-17
    80000b56:	e11c                	sd	a5,0(a0)
}
    80000b58:	60a2                	ld	ra,8(sp)
    80000b5a:	6402                	ld	s0,0(sp)
    80000b5c:	0141                	addi	sp,sp,16
    80000b5e:	8082                	ret
    panic("uvmclear");
    80000b60:	00008517          	auipc	a0,0x8
    80000b64:	5f850513          	addi	a0,a0,1528 # 80009158 <etext+0x158>
    80000b68:	00006097          	auipc	ra,0x6
    80000b6c:	072080e7          	jalr	114(ra) # 80006bda <panic>

0000000080000b70 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b70:	c6bd                	beqz	a3,80000bde <copyout+0x6e>
{
    80000b72:	715d                	addi	sp,sp,-80
    80000b74:	e486                	sd	ra,72(sp)
    80000b76:	e0a2                	sd	s0,64(sp)
    80000b78:	fc26                	sd	s1,56(sp)
    80000b7a:	f84a                	sd	s2,48(sp)
    80000b7c:	f44e                	sd	s3,40(sp)
    80000b7e:	f052                	sd	s4,32(sp)
    80000b80:	ec56                	sd	s5,24(sp)
    80000b82:	e85a                	sd	s6,16(sp)
    80000b84:	e45e                	sd	s7,8(sp)
    80000b86:	e062                	sd	s8,0(sp)
    80000b88:	0880                	addi	s0,sp,80
    80000b8a:	8b2a                	mv	s6,a0
    80000b8c:	8c2e                	mv	s8,a1
    80000b8e:	8a32                	mv	s4,a2
    80000b90:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b92:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b94:	6a85                	lui	s5,0x1
    80000b96:	a015                	j	80000bba <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b98:	9562                	add	a0,a0,s8
    80000b9a:	0004861b          	sext.w	a2,s1
    80000b9e:	85d2                	mv	a1,s4
    80000ba0:	41250533          	sub	a0,a0,s2
    80000ba4:	fffff097          	auipc	ra,0xfffff
    80000ba8:	632080e7          	jalr	1586(ra) # 800001d6 <memmove>

    len -= n;
    80000bac:	409989b3          	sub	s3,s3,s1
    src += n;
    80000bb0:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000bb2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bb6:	02098263          	beqz	s3,80000bda <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000bba:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bbe:	85ca                	mv	a1,s2
    80000bc0:	855a                	mv	a0,s6
    80000bc2:	00000097          	auipc	ra,0x0
    80000bc6:	95a080e7          	jalr	-1702(ra) # 8000051c <walkaddr>
    if(pa0 == 0)
    80000bca:	cd01                	beqz	a0,80000be2 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bcc:	418904b3          	sub	s1,s2,s8
    80000bd0:	94d6                	add	s1,s1,s5
    80000bd2:	fc99f3e3          	bgeu	s3,s1,80000b98 <copyout+0x28>
    80000bd6:	84ce                	mv	s1,s3
    80000bd8:	b7c1                	j	80000b98 <copyout+0x28>
  }
  return 0;
    80000bda:	4501                	li	a0,0
    80000bdc:	a021                	j	80000be4 <copyout+0x74>
    80000bde:	4501                	li	a0,0
}
    80000be0:	8082                	ret
      return -1;
    80000be2:	557d                	li	a0,-1
}
    80000be4:	60a6                	ld	ra,72(sp)
    80000be6:	6406                	ld	s0,64(sp)
    80000be8:	74e2                	ld	s1,56(sp)
    80000bea:	7942                	ld	s2,48(sp)
    80000bec:	79a2                	ld	s3,40(sp)
    80000bee:	7a02                	ld	s4,32(sp)
    80000bf0:	6ae2                	ld	s5,24(sp)
    80000bf2:	6b42                	ld	s6,16(sp)
    80000bf4:	6ba2                	ld	s7,8(sp)
    80000bf6:	6c02                	ld	s8,0(sp)
    80000bf8:	6161                	addi	sp,sp,80
    80000bfa:	8082                	ret

0000000080000bfc <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;
  
  while(len > 0){
    80000bfc:	caa5                	beqz	a3,80000c6c <copyin+0x70>
{
    80000bfe:	715d                	addi	sp,sp,-80
    80000c00:	e486                	sd	ra,72(sp)
    80000c02:	e0a2                	sd	s0,64(sp)
    80000c04:	fc26                	sd	s1,56(sp)
    80000c06:	f84a                	sd	s2,48(sp)
    80000c08:	f44e                	sd	s3,40(sp)
    80000c0a:	f052                	sd	s4,32(sp)
    80000c0c:	ec56                	sd	s5,24(sp)
    80000c0e:	e85a                	sd	s6,16(sp)
    80000c10:	e45e                	sd	s7,8(sp)
    80000c12:	e062                	sd	s8,0(sp)
    80000c14:	0880                	addi	s0,sp,80
    80000c16:	8b2a                	mv	s6,a0
    80000c18:	8a2e                	mv	s4,a1
    80000c1a:	8c32                	mv	s8,a2
    80000c1c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c1e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c20:	6a85                	lui	s5,0x1
    80000c22:	a01d                	j	80000c48 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c24:	018505b3          	add	a1,a0,s8
    80000c28:	0004861b          	sext.w	a2,s1
    80000c2c:	412585b3          	sub	a1,a1,s2
    80000c30:	8552                	mv	a0,s4
    80000c32:	fffff097          	auipc	ra,0xfffff
    80000c36:	5a4080e7          	jalr	1444(ra) # 800001d6 <memmove>

    len -= n;
    80000c3a:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c3e:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c40:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c44:	02098263          	beqz	s3,80000c68 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c48:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c4c:	85ca                	mv	a1,s2
    80000c4e:	855a                	mv	a0,s6
    80000c50:	00000097          	auipc	ra,0x0
    80000c54:	8cc080e7          	jalr	-1844(ra) # 8000051c <walkaddr>
    if(pa0 == 0)
    80000c58:	cd01                	beqz	a0,80000c70 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c5a:	418904b3          	sub	s1,s2,s8
    80000c5e:	94d6                	add	s1,s1,s5
    80000c60:	fc99f2e3          	bgeu	s3,s1,80000c24 <copyin+0x28>
    80000c64:	84ce                	mv	s1,s3
    80000c66:	bf7d                	j	80000c24 <copyin+0x28>
  }
  return 0;
    80000c68:	4501                	li	a0,0
    80000c6a:	a021                	j	80000c72 <copyin+0x76>
    80000c6c:	4501                	li	a0,0
}
    80000c6e:	8082                	ret
      return -1;
    80000c70:	557d                	li	a0,-1
}
    80000c72:	60a6                	ld	ra,72(sp)
    80000c74:	6406                	ld	s0,64(sp)
    80000c76:	74e2                	ld	s1,56(sp)
    80000c78:	7942                	ld	s2,48(sp)
    80000c7a:	79a2                	ld	s3,40(sp)
    80000c7c:	7a02                	ld	s4,32(sp)
    80000c7e:	6ae2                	ld	s5,24(sp)
    80000c80:	6b42                	ld	s6,16(sp)
    80000c82:	6ba2                	ld	s7,8(sp)
    80000c84:	6c02                	ld	s8,0(sp)
    80000c86:	6161                	addi	sp,sp,80
    80000c88:	8082                	ret

0000000080000c8a <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c8a:	c2dd                	beqz	a3,80000d30 <copyinstr+0xa6>
{
    80000c8c:	715d                	addi	sp,sp,-80
    80000c8e:	e486                	sd	ra,72(sp)
    80000c90:	e0a2                	sd	s0,64(sp)
    80000c92:	fc26                	sd	s1,56(sp)
    80000c94:	f84a                	sd	s2,48(sp)
    80000c96:	f44e                	sd	s3,40(sp)
    80000c98:	f052                	sd	s4,32(sp)
    80000c9a:	ec56                	sd	s5,24(sp)
    80000c9c:	e85a                	sd	s6,16(sp)
    80000c9e:	e45e                	sd	s7,8(sp)
    80000ca0:	0880                	addi	s0,sp,80
    80000ca2:	8a2a                	mv	s4,a0
    80000ca4:	8b2e                	mv	s6,a1
    80000ca6:	8bb2                	mv	s7,a2
    80000ca8:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000caa:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000cac:	6985                	lui	s3,0x1
    80000cae:	a02d                	j	80000cd8 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000cb0:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000cb4:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000cb6:	37fd                	addiw	a5,a5,-1
    80000cb8:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cbc:	60a6                	ld	ra,72(sp)
    80000cbe:	6406                	ld	s0,64(sp)
    80000cc0:	74e2                	ld	s1,56(sp)
    80000cc2:	7942                	ld	s2,48(sp)
    80000cc4:	79a2                	ld	s3,40(sp)
    80000cc6:	7a02                	ld	s4,32(sp)
    80000cc8:	6ae2                	ld	s5,24(sp)
    80000cca:	6b42                	ld	s6,16(sp)
    80000ccc:	6ba2                	ld	s7,8(sp)
    80000cce:	6161                	addi	sp,sp,80
    80000cd0:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cd2:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cd6:	c8a9                	beqz	s1,80000d28 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000cd8:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cdc:	85ca                	mv	a1,s2
    80000cde:	8552                	mv	a0,s4
    80000ce0:	00000097          	auipc	ra,0x0
    80000ce4:	83c080e7          	jalr	-1988(ra) # 8000051c <walkaddr>
    if(pa0 == 0)
    80000ce8:	c131                	beqz	a0,80000d2c <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000cea:	417906b3          	sub	a3,s2,s7
    80000cee:	96ce                	add	a3,a3,s3
    80000cf0:	00d4f363          	bgeu	s1,a3,80000cf6 <copyinstr+0x6c>
    80000cf4:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cf6:	955e                	add	a0,a0,s7
    80000cf8:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cfc:	daf9                	beqz	a3,80000cd2 <copyinstr+0x48>
    80000cfe:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000d00:	41650633          	sub	a2,a0,s6
    80000d04:	fff48593          	addi	a1,s1,-1
    80000d08:	95da                	add	a1,a1,s6
    while(n > 0){
    80000d0a:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000d0c:	00f60733          	add	a4,a2,a5
    80000d10:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdbba0>
    80000d14:	df51                	beqz	a4,80000cb0 <copyinstr+0x26>
        *dst = *p;
    80000d16:	00e78023          	sb	a4,0(a5)
      --max;
    80000d1a:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000d1e:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d20:	fed796e3          	bne	a5,a3,80000d0c <copyinstr+0x82>
      dst++;
    80000d24:	8b3e                	mv	s6,a5
    80000d26:	b775                	j	80000cd2 <copyinstr+0x48>
    80000d28:	4781                	li	a5,0
    80000d2a:	b771                	j	80000cb6 <copyinstr+0x2c>
      return -1;
    80000d2c:	557d                	li	a0,-1
    80000d2e:	b779                	j	80000cbc <copyinstr+0x32>
  int got_null = 0;
    80000d30:	4781                	li	a5,0
  if(got_null){
    80000d32:	37fd                	addiw	a5,a5,-1
    80000d34:	0007851b          	sext.w	a0,a5
}
    80000d38:	8082                	ret

0000000080000d3a <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000d3a:	7139                	addi	sp,sp,-64
    80000d3c:	fc06                	sd	ra,56(sp)
    80000d3e:	f822                	sd	s0,48(sp)
    80000d40:	f426                	sd	s1,40(sp)
    80000d42:	f04a                	sd	s2,32(sp)
    80000d44:	ec4e                	sd	s3,24(sp)
    80000d46:	e852                	sd	s4,16(sp)
    80000d48:	e456                	sd	s5,8(sp)
    80000d4a:	e05a                	sd	s6,0(sp)
    80000d4c:	0080                	addi	s0,sp,64
    80000d4e:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d50:	00009497          	auipc	s1,0x9
    80000d54:	09048493          	addi	s1,s1,144 # 80009de0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d58:	8b26                	mv	s6,s1
    80000d5a:	00008a97          	auipc	s5,0x8
    80000d5e:	2a6a8a93          	addi	s5,s5,678 # 80009000 <etext>
    80000d62:	01000937          	lui	s2,0x1000
    80000d66:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000d68:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d6a:	0000fa17          	auipc	s4,0xf
    80000d6e:	a76a0a13          	addi	s4,s4,-1418 # 8000f7e0 <tickslock>
    char *pa = kalloc();
    80000d72:	fffff097          	auipc	ra,0xfffff
    80000d76:	3a8080e7          	jalr	936(ra) # 8000011a <kalloc>
    80000d7a:	862a                	mv	a2,a0
    if(pa == 0)
    80000d7c:	c129                	beqz	a0,80000dbe <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000d7e:	416485b3          	sub	a1,s1,s6
    80000d82:	858d                	srai	a1,a1,0x3
    80000d84:	000ab783          	ld	a5,0(s5)
    80000d88:	02f585b3          	mul	a1,a1,a5
    80000d8c:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d90:	4719                	li	a4,6
    80000d92:	6685                	lui	a3,0x1
    80000d94:	40b905b3          	sub	a1,s2,a1
    80000d98:	854e                	mv	a0,s3
    80000d9a:	00000097          	auipc	ra,0x0
    80000d9e:	864080e7          	jalr	-1948(ra) # 800005fe <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000da2:	16848493          	addi	s1,s1,360
    80000da6:	fd4496e3          	bne	s1,s4,80000d72 <proc_mapstacks+0x38>
  }
}
    80000daa:	70e2                	ld	ra,56(sp)
    80000dac:	7442                	ld	s0,48(sp)
    80000dae:	74a2                	ld	s1,40(sp)
    80000db0:	7902                	ld	s2,32(sp)
    80000db2:	69e2                	ld	s3,24(sp)
    80000db4:	6a42                	ld	s4,16(sp)
    80000db6:	6aa2                	ld	s5,8(sp)
    80000db8:	6b02                	ld	s6,0(sp)
    80000dba:	6121                	addi	sp,sp,64
    80000dbc:	8082                	ret
      panic("kalloc");
    80000dbe:	00008517          	auipc	a0,0x8
    80000dc2:	3aa50513          	addi	a0,a0,938 # 80009168 <etext+0x168>
    80000dc6:	00006097          	auipc	ra,0x6
    80000dca:	e14080e7          	jalr	-492(ra) # 80006bda <panic>

0000000080000dce <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000dce:	7139                	addi	sp,sp,-64
    80000dd0:	fc06                	sd	ra,56(sp)
    80000dd2:	f822                	sd	s0,48(sp)
    80000dd4:	f426                	sd	s1,40(sp)
    80000dd6:	f04a                	sd	s2,32(sp)
    80000dd8:	ec4e                	sd	s3,24(sp)
    80000dda:	e852                	sd	s4,16(sp)
    80000ddc:	e456                	sd	s5,8(sp)
    80000dde:	e05a                	sd	s6,0(sp)
    80000de0:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000de2:	00008597          	auipc	a1,0x8
    80000de6:	38e58593          	addi	a1,a1,910 # 80009170 <etext+0x170>
    80000dea:	00009517          	auipc	a0,0x9
    80000dee:	bc650513          	addi	a0,a0,-1082 # 800099b0 <pid_lock>
    80000df2:	00006097          	auipc	ra,0x6
    80000df6:	290080e7          	jalr	656(ra) # 80007082 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dfa:	00008597          	auipc	a1,0x8
    80000dfe:	37e58593          	addi	a1,a1,894 # 80009178 <etext+0x178>
    80000e02:	00009517          	auipc	a0,0x9
    80000e06:	bc650513          	addi	a0,a0,-1082 # 800099c8 <wait_lock>
    80000e0a:	00006097          	auipc	ra,0x6
    80000e0e:	278080e7          	jalr	632(ra) # 80007082 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e12:	00009497          	auipc	s1,0x9
    80000e16:	fce48493          	addi	s1,s1,-50 # 80009de0 <proc>
      initlock(&p->lock, "proc");
    80000e1a:	00008b17          	auipc	s6,0x8
    80000e1e:	36eb0b13          	addi	s6,s6,878 # 80009188 <etext+0x188>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000e22:	8aa6                	mv	s5,s1
    80000e24:	00008a17          	auipc	s4,0x8
    80000e28:	1dca0a13          	addi	s4,s4,476 # 80009000 <etext>
    80000e2c:	01000937          	lui	s2,0x1000
    80000e30:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000e32:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e34:	0000f997          	auipc	s3,0xf
    80000e38:	9ac98993          	addi	s3,s3,-1620 # 8000f7e0 <tickslock>
      initlock(&p->lock, "proc");
    80000e3c:	85da                	mv	a1,s6
    80000e3e:	8526                	mv	a0,s1
    80000e40:	00006097          	auipc	ra,0x6
    80000e44:	242080e7          	jalr	578(ra) # 80007082 <initlock>
      p->state = UNUSED;
    80000e48:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000e4c:	415487b3          	sub	a5,s1,s5
    80000e50:	878d                	srai	a5,a5,0x3
    80000e52:	000a3703          	ld	a4,0(s4)
    80000e56:	02e787b3          	mul	a5,a5,a4
    80000e5a:	00d7979b          	slliw	a5,a5,0xd
    80000e5e:	40f907b3          	sub	a5,s2,a5
    80000e62:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e64:	16848493          	addi	s1,s1,360
    80000e68:	fd349ae3          	bne	s1,s3,80000e3c <procinit+0x6e>
  }
}
    80000e6c:	70e2                	ld	ra,56(sp)
    80000e6e:	7442                	ld	s0,48(sp)
    80000e70:	74a2                	ld	s1,40(sp)
    80000e72:	7902                	ld	s2,32(sp)
    80000e74:	69e2                	ld	s3,24(sp)
    80000e76:	6a42                	ld	s4,16(sp)
    80000e78:	6aa2                	ld	s5,8(sp)
    80000e7a:	6b02                	ld	s6,0(sp)
    80000e7c:	6121                	addi	sp,sp,64
    80000e7e:	8082                	ret

0000000080000e80 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e80:	1141                	addi	sp,sp,-16
    80000e82:	e422                	sd	s0,8(sp)
    80000e84:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e86:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e88:	2501                	sext.w	a0,a0
    80000e8a:	6422                	ld	s0,8(sp)
    80000e8c:	0141                	addi	sp,sp,16
    80000e8e:	8082                	ret

0000000080000e90 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e90:	1141                	addi	sp,sp,-16
    80000e92:	e422                	sd	s0,8(sp)
    80000e94:	0800                	addi	s0,sp,16
    80000e96:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e98:	2781                	sext.w	a5,a5
    80000e9a:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e9c:	00009517          	auipc	a0,0x9
    80000ea0:	b4450513          	addi	a0,a0,-1212 # 800099e0 <cpus>
    80000ea4:	953e                	add	a0,a0,a5
    80000ea6:	6422                	ld	s0,8(sp)
    80000ea8:	0141                	addi	sp,sp,16
    80000eaa:	8082                	ret

0000000080000eac <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000eac:	1101                	addi	sp,sp,-32
    80000eae:	ec06                	sd	ra,24(sp)
    80000eb0:	e822                	sd	s0,16(sp)
    80000eb2:	e426                	sd	s1,8(sp)
    80000eb4:	1000                	addi	s0,sp,32
  push_off();
    80000eb6:	00006097          	auipc	ra,0x6
    80000eba:	210080e7          	jalr	528(ra) # 800070c6 <push_off>
    80000ebe:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ec0:	2781                	sext.w	a5,a5
    80000ec2:	079e                	slli	a5,a5,0x7
    80000ec4:	00009717          	auipc	a4,0x9
    80000ec8:	aec70713          	addi	a4,a4,-1300 # 800099b0 <pid_lock>
    80000ecc:	97ba                	add	a5,a5,a4
    80000ece:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ed0:	00006097          	auipc	ra,0x6
    80000ed4:	296080e7          	jalr	662(ra) # 80007166 <pop_off>
  return p;
}
    80000ed8:	8526                	mv	a0,s1
    80000eda:	60e2                	ld	ra,24(sp)
    80000edc:	6442                	ld	s0,16(sp)
    80000ede:	64a2                	ld	s1,8(sp)
    80000ee0:	6105                	addi	sp,sp,32
    80000ee2:	8082                	ret

0000000080000ee4 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ee4:	1141                	addi	sp,sp,-16
    80000ee6:	e406                	sd	ra,8(sp)
    80000ee8:	e022                	sd	s0,0(sp)
    80000eea:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000eec:	00000097          	auipc	ra,0x0
    80000ef0:	fc0080e7          	jalr	-64(ra) # 80000eac <myproc>
    80000ef4:	00006097          	auipc	ra,0x6
    80000ef8:	2d2080e7          	jalr	722(ra) # 800071c6 <release>

  if (first) {
    80000efc:	00009797          	auipc	a5,0x9
    80000f00:	9c47a783          	lw	a5,-1596(a5) # 800098c0 <first.1>
    80000f04:	eb89                	bnez	a5,80000f16 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000f06:	00001097          	auipc	ra,0x1
    80000f0a:	c5c080e7          	jalr	-932(ra) # 80001b62 <usertrapret>
}
    80000f0e:	60a2                	ld	ra,8(sp)
    80000f10:	6402                	ld	s0,0(sp)
    80000f12:	0141                	addi	sp,sp,16
    80000f14:	8082                	ret
    first = 0;
    80000f16:	00009797          	auipc	a5,0x9
    80000f1a:	9a07a523          	sw	zero,-1622(a5) # 800098c0 <first.1>
    fsinit(ROOTDEV);
    80000f1e:	4505                	li	a0,1
    80000f20:	00002097          	auipc	ra,0x2
    80000f24:	9ae080e7          	jalr	-1618(ra) # 800028ce <fsinit>
    80000f28:	bff9                	j	80000f06 <forkret+0x22>

0000000080000f2a <allocpid>:
{
    80000f2a:	1101                	addi	sp,sp,-32
    80000f2c:	ec06                	sd	ra,24(sp)
    80000f2e:	e822                	sd	s0,16(sp)
    80000f30:	e426                	sd	s1,8(sp)
    80000f32:	e04a                	sd	s2,0(sp)
    80000f34:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f36:	00009917          	auipc	s2,0x9
    80000f3a:	a7a90913          	addi	s2,s2,-1414 # 800099b0 <pid_lock>
    80000f3e:	854a                	mv	a0,s2
    80000f40:	00006097          	auipc	ra,0x6
    80000f44:	1d2080e7          	jalr	466(ra) # 80007112 <acquire>
  pid = nextpid;
    80000f48:	00009797          	auipc	a5,0x9
    80000f4c:	97c78793          	addi	a5,a5,-1668 # 800098c4 <nextpid>
    80000f50:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f52:	0014871b          	addiw	a4,s1,1
    80000f56:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f58:	854a                	mv	a0,s2
    80000f5a:	00006097          	auipc	ra,0x6
    80000f5e:	26c080e7          	jalr	620(ra) # 800071c6 <release>
}
    80000f62:	8526                	mv	a0,s1
    80000f64:	60e2                	ld	ra,24(sp)
    80000f66:	6442                	ld	s0,16(sp)
    80000f68:	64a2                	ld	s1,8(sp)
    80000f6a:	6902                	ld	s2,0(sp)
    80000f6c:	6105                	addi	sp,sp,32
    80000f6e:	8082                	ret

0000000080000f70 <proc_pagetable>:
{
    80000f70:	1101                	addi	sp,sp,-32
    80000f72:	ec06                	sd	ra,24(sp)
    80000f74:	e822                	sd	s0,16(sp)
    80000f76:	e426                	sd	s1,8(sp)
    80000f78:	e04a                	sd	s2,0(sp)
    80000f7a:	1000                	addi	s0,sp,32
    80000f7c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f7e:	00000097          	auipc	ra,0x0
    80000f82:	8ae080e7          	jalr	-1874(ra) # 8000082c <uvmcreate>
    80000f86:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f88:	c121                	beqz	a0,80000fc8 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f8a:	4729                	li	a4,10
    80000f8c:	00007697          	auipc	a3,0x7
    80000f90:	07468693          	addi	a3,a3,116 # 80008000 <_trampoline>
    80000f94:	6605                	lui	a2,0x1
    80000f96:	040005b7          	lui	a1,0x4000
    80000f9a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f9c:	05b2                	slli	a1,a1,0xc
    80000f9e:	fffff097          	auipc	ra,0xfffff
    80000fa2:	5c0080e7          	jalr	1472(ra) # 8000055e <mappages>
    80000fa6:	02054863          	bltz	a0,80000fd6 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000faa:	4719                	li	a4,6
    80000fac:	05893683          	ld	a3,88(s2)
    80000fb0:	6605                	lui	a2,0x1
    80000fb2:	020005b7          	lui	a1,0x2000
    80000fb6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fb8:	05b6                	slli	a1,a1,0xd
    80000fba:	8526                	mv	a0,s1
    80000fbc:	fffff097          	auipc	ra,0xfffff
    80000fc0:	5a2080e7          	jalr	1442(ra) # 8000055e <mappages>
    80000fc4:	02054163          	bltz	a0,80000fe6 <proc_pagetable+0x76>
}
    80000fc8:	8526                	mv	a0,s1
    80000fca:	60e2                	ld	ra,24(sp)
    80000fcc:	6442                	ld	s0,16(sp)
    80000fce:	64a2                	ld	s1,8(sp)
    80000fd0:	6902                	ld	s2,0(sp)
    80000fd2:	6105                	addi	sp,sp,32
    80000fd4:	8082                	ret
    uvmfree(pagetable, 0);
    80000fd6:	4581                	li	a1,0
    80000fd8:	8526                	mv	a0,s1
    80000fda:	00000097          	auipc	ra,0x0
    80000fde:	a58080e7          	jalr	-1448(ra) # 80000a32 <uvmfree>
    return 0;
    80000fe2:	4481                	li	s1,0
    80000fe4:	b7d5                	j	80000fc8 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fe6:	4681                	li	a3,0
    80000fe8:	4605                	li	a2,1
    80000fea:	040005b7          	lui	a1,0x4000
    80000fee:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ff0:	05b2                	slli	a1,a1,0xc
    80000ff2:	8526                	mv	a0,s1
    80000ff4:	fffff097          	auipc	ra,0xfffff
    80000ff8:	760080e7          	jalr	1888(ra) # 80000754 <uvmunmap>
    uvmfree(pagetable, 0);
    80000ffc:	4581                	li	a1,0
    80000ffe:	8526                	mv	a0,s1
    80001000:	00000097          	auipc	ra,0x0
    80001004:	a32080e7          	jalr	-1486(ra) # 80000a32 <uvmfree>
    return 0;
    80001008:	4481                	li	s1,0
    8000100a:	bf7d                	j	80000fc8 <proc_pagetable+0x58>

000000008000100c <proc_freepagetable>:
{
    8000100c:	1101                	addi	sp,sp,-32
    8000100e:	ec06                	sd	ra,24(sp)
    80001010:	e822                	sd	s0,16(sp)
    80001012:	e426                	sd	s1,8(sp)
    80001014:	e04a                	sd	s2,0(sp)
    80001016:	1000                	addi	s0,sp,32
    80001018:	84aa                	mv	s1,a0
    8000101a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000101c:	4681                	li	a3,0
    8000101e:	4605                	li	a2,1
    80001020:	040005b7          	lui	a1,0x4000
    80001024:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001026:	05b2                	slli	a1,a1,0xc
    80001028:	fffff097          	auipc	ra,0xfffff
    8000102c:	72c080e7          	jalr	1836(ra) # 80000754 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001030:	4681                	li	a3,0
    80001032:	4605                	li	a2,1
    80001034:	020005b7          	lui	a1,0x2000
    80001038:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000103a:	05b6                	slli	a1,a1,0xd
    8000103c:	8526                	mv	a0,s1
    8000103e:	fffff097          	auipc	ra,0xfffff
    80001042:	716080e7          	jalr	1814(ra) # 80000754 <uvmunmap>
  uvmfree(pagetable, sz);
    80001046:	85ca                	mv	a1,s2
    80001048:	8526                	mv	a0,s1
    8000104a:	00000097          	auipc	ra,0x0
    8000104e:	9e8080e7          	jalr	-1560(ra) # 80000a32 <uvmfree>
}
    80001052:	60e2                	ld	ra,24(sp)
    80001054:	6442                	ld	s0,16(sp)
    80001056:	64a2                	ld	s1,8(sp)
    80001058:	6902                	ld	s2,0(sp)
    8000105a:	6105                	addi	sp,sp,32
    8000105c:	8082                	ret

000000008000105e <freeproc>:
{
    8000105e:	1101                	addi	sp,sp,-32
    80001060:	ec06                	sd	ra,24(sp)
    80001062:	e822                	sd	s0,16(sp)
    80001064:	e426                	sd	s1,8(sp)
    80001066:	1000                	addi	s0,sp,32
    80001068:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000106a:	6d28                	ld	a0,88(a0)
    8000106c:	c509                	beqz	a0,80001076 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000106e:	fffff097          	auipc	ra,0xfffff
    80001072:	fae080e7          	jalr	-82(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001076:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000107a:	68a8                	ld	a0,80(s1)
    8000107c:	c511                	beqz	a0,80001088 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000107e:	64ac                	ld	a1,72(s1)
    80001080:	00000097          	auipc	ra,0x0
    80001084:	f8c080e7          	jalr	-116(ra) # 8000100c <proc_freepagetable>
  p->pagetable = 0;
    80001088:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000108c:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001090:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001094:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001098:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000109c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800010a0:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800010a4:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800010a8:	0004ac23          	sw	zero,24(s1)
}
    800010ac:	60e2                	ld	ra,24(sp)
    800010ae:	6442                	ld	s0,16(sp)
    800010b0:	64a2                	ld	s1,8(sp)
    800010b2:	6105                	addi	sp,sp,32
    800010b4:	8082                	ret

00000000800010b6 <allocproc>:
{
    800010b6:	1101                	addi	sp,sp,-32
    800010b8:	ec06                	sd	ra,24(sp)
    800010ba:	e822                	sd	s0,16(sp)
    800010bc:	e426                	sd	s1,8(sp)
    800010be:	e04a                	sd	s2,0(sp)
    800010c0:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010c2:	00009497          	auipc	s1,0x9
    800010c6:	d1e48493          	addi	s1,s1,-738 # 80009de0 <proc>
    800010ca:	0000e917          	auipc	s2,0xe
    800010ce:	71690913          	addi	s2,s2,1814 # 8000f7e0 <tickslock>
    acquire(&p->lock);
    800010d2:	8526                	mv	a0,s1
    800010d4:	00006097          	auipc	ra,0x6
    800010d8:	03e080e7          	jalr	62(ra) # 80007112 <acquire>
    if(p->state == UNUSED) {
    800010dc:	4c9c                	lw	a5,24(s1)
    800010de:	cf81                	beqz	a5,800010f6 <allocproc+0x40>
      release(&p->lock);
    800010e0:	8526                	mv	a0,s1
    800010e2:	00006097          	auipc	ra,0x6
    800010e6:	0e4080e7          	jalr	228(ra) # 800071c6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ea:	16848493          	addi	s1,s1,360
    800010ee:	ff2492e3          	bne	s1,s2,800010d2 <allocproc+0x1c>
  return 0;
    800010f2:	4481                	li	s1,0
    800010f4:	a889                	j	80001146 <allocproc+0x90>
  p->pid = allocpid();
    800010f6:	00000097          	auipc	ra,0x0
    800010fa:	e34080e7          	jalr	-460(ra) # 80000f2a <allocpid>
    800010fe:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001100:	4785                	li	a5,1
    80001102:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001104:	fffff097          	auipc	ra,0xfffff
    80001108:	016080e7          	jalr	22(ra) # 8000011a <kalloc>
    8000110c:	892a                	mv	s2,a0
    8000110e:	eca8                	sd	a0,88(s1)
    80001110:	c131                	beqz	a0,80001154 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001112:	8526                	mv	a0,s1
    80001114:	00000097          	auipc	ra,0x0
    80001118:	e5c080e7          	jalr	-420(ra) # 80000f70 <proc_pagetable>
    8000111c:	892a                	mv	s2,a0
    8000111e:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001120:	c531                	beqz	a0,8000116c <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001122:	07000613          	li	a2,112
    80001126:	4581                	li	a1,0
    80001128:	06048513          	addi	a0,s1,96
    8000112c:	fffff097          	auipc	ra,0xfffff
    80001130:	04e080e7          	jalr	78(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    80001134:	00000797          	auipc	a5,0x0
    80001138:	db078793          	addi	a5,a5,-592 # 80000ee4 <forkret>
    8000113c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000113e:	60bc                	ld	a5,64(s1)
    80001140:	6705                	lui	a4,0x1
    80001142:	97ba                	add	a5,a5,a4
    80001144:	f4bc                	sd	a5,104(s1)
}
    80001146:	8526                	mv	a0,s1
    80001148:	60e2                	ld	ra,24(sp)
    8000114a:	6442                	ld	s0,16(sp)
    8000114c:	64a2                	ld	s1,8(sp)
    8000114e:	6902                	ld	s2,0(sp)
    80001150:	6105                	addi	sp,sp,32
    80001152:	8082                	ret
    freeproc(p);
    80001154:	8526                	mv	a0,s1
    80001156:	00000097          	auipc	ra,0x0
    8000115a:	f08080e7          	jalr	-248(ra) # 8000105e <freeproc>
    release(&p->lock);
    8000115e:	8526                	mv	a0,s1
    80001160:	00006097          	auipc	ra,0x6
    80001164:	066080e7          	jalr	102(ra) # 800071c6 <release>
    return 0;
    80001168:	84ca                	mv	s1,s2
    8000116a:	bff1                	j	80001146 <allocproc+0x90>
    freeproc(p);
    8000116c:	8526                	mv	a0,s1
    8000116e:	00000097          	auipc	ra,0x0
    80001172:	ef0080e7          	jalr	-272(ra) # 8000105e <freeproc>
    release(&p->lock);
    80001176:	8526                	mv	a0,s1
    80001178:	00006097          	auipc	ra,0x6
    8000117c:	04e080e7          	jalr	78(ra) # 800071c6 <release>
    return 0;
    80001180:	84ca                	mv	s1,s2
    80001182:	b7d1                	j	80001146 <allocproc+0x90>

0000000080001184 <userinit>:
{
    80001184:	1101                	addi	sp,sp,-32
    80001186:	ec06                	sd	ra,24(sp)
    80001188:	e822                	sd	s0,16(sp)
    8000118a:	e426                	sd	s1,8(sp)
    8000118c:	1000                	addi	s0,sp,32
  p = allocproc();
    8000118e:	00000097          	auipc	ra,0x0
    80001192:	f28080e7          	jalr	-216(ra) # 800010b6 <allocproc>
    80001196:	84aa                	mv	s1,a0
  initproc = p;
    80001198:	00008797          	auipc	a5,0x8
    8000119c:	7aa7bc23          	sd	a0,1976(a5) # 80009950 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800011a0:	03400613          	li	a2,52
    800011a4:	00008597          	auipc	a1,0x8
    800011a8:	73c58593          	addi	a1,a1,1852 # 800098e0 <initcode>
    800011ac:	6928                	ld	a0,80(a0)
    800011ae:	fffff097          	auipc	ra,0xfffff
    800011b2:	6ac080e7          	jalr	1708(ra) # 8000085a <uvmfirst>
  p->sz = PGSIZE;
    800011b6:	6785                	lui	a5,0x1
    800011b8:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011ba:	6cb8                	ld	a4,88(s1)
    800011bc:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011c0:	6cb8                	ld	a4,88(s1)
    800011c2:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011c4:	4641                	li	a2,16
    800011c6:	00008597          	auipc	a1,0x8
    800011ca:	fca58593          	addi	a1,a1,-54 # 80009190 <etext+0x190>
    800011ce:	15848513          	addi	a0,s1,344
    800011d2:	fffff097          	auipc	ra,0xfffff
    800011d6:	0f2080e7          	jalr	242(ra) # 800002c4 <safestrcpy>
  p->cwd = namei("/");
    800011da:	00008517          	auipc	a0,0x8
    800011de:	fc650513          	addi	a0,a0,-58 # 800091a0 <etext+0x1a0>
    800011e2:	00002097          	auipc	ra,0x2
    800011e6:	116080e7          	jalr	278(ra) # 800032f8 <namei>
    800011ea:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011ee:	478d                	li	a5,3
    800011f0:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011f2:	8526                	mv	a0,s1
    800011f4:	00006097          	auipc	ra,0x6
    800011f8:	fd2080e7          	jalr	-46(ra) # 800071c6 <release>
}
    800011fc:	60e2                	ld	ra,24(sp)
    800011fe:	6442                	ld	s0,16(sp)
    80001200:	64a2                	ld	s1,8(sp)
    80001202:	6105                	addi	sp,sp,32
    80001204:	8082                	ret

0000000080001206 <growproc>:
{
    80001206:	1101                	addi	sp,sp,-32
    80001208:	ec06                	sd	ra,24(sp)
    8000120a:	e822                	sd	s0,16(sp)
    8000120c:	e426                	sd	s1,8(sp)
    8000120e:	e04a                	sd	s2,0(sp)
    80001210:	1000                	addi	s0,sp,32
    80001212:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001214:	00000097          	auipc	ra,0x0
    80001218:	c98080e7          	jalr	-872(ra) # 80000eac <myproc>
    8000121c:	84aa                	mv	s1,a0
  sz = p->sz;
    8000121e:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001220:	01204c63          	bgtz	s2,80001238 <growproc+0x32>
  } else if(n < 0){
    80001224:	02094663          	bltz	s2,80001250 <growproc+0x4a>
  p->sz = sz;
    80001228:	e4ac                	sd	a1,72(s1)
  return 0;
    8000122a:	4501                	li	a0,0
}
    8000122c:	60e2                	ld	ra,24(sp)
    8000122e:	6442                	ld	s0,16(sp)
    80001230:	64a2                	ld	s1,8(sp)
    80001232:	6902                	ld	s2,0(sp)
    80001234:	6105                	addi	sp,sp,32
    80001236:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001238:	4691                	li	a3,4
    8000123a:	00b90633          	add	a2,s2,a1
    8000123e:	6928                	ld	a0,80(a0)
    80001240:	fffff097          	auipc	ra,0xfffff
    80001244:	6d4080e7          	jalr	1748(ra) # 80000914 <uvmalloc>
    80001248:	85aa                	mv	a1,a0
    8000124a:	fd79                	bnez	a0,80001228 <growproc+0x22>
      return -1;
    8000124c:	557d                	li	a0,-1
    8000124e:	bff9                	j	8000122c <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001250:	00b90633          	add	a2,s2,a1
    80001254:	6928                	ld	a0,80(a0)
    80001256:	fffff097          	auipc	ra,0xfffff
    8000125a:	676080e7          	jalr	1654(ra) # 800008cc <uvmdealloc>
    8000125e:	85aa                	mv	a1,a0
    80001260:	b7e1                	j	80001228 <growproc+0x22>

0000000080001262 <fork>:
{
    80001262:	7139                	addi	sp,sp,-64
    80001264:	fc06                	sd	ra,56(sp)
    80001266:	f822                	sd	s0,48(sp)
    80001268:	f426                	sd	s1,40(sp)
    8000126a:	f04a                	sd	s2,32(sp)
    8000126c:	ec4e                	sd	s3,24(sp)
    8000126e:	e852                	sd	s4,16(sp)
    80001270:	e456                	sd	s5,8(sp)
    80001272:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001274:	00000097          	auipc	ra,0x0
    80001278:	c38080e7          	jalr	-968(ra) # 80000eac <myproc>
    8000127c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000127e:	00000097          	auipc	ra,0x0
    80001282:	e38080e7          	jalr	-456(ra) # 800010b6 <allocproc>
    80001286:	10050c63          	beqz	a0,8000139e <fork+0x13c>
    8000128a:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000128c:	048ab603          	ld	a2,72(s5)
    80001290:	692c                	ld	a1,80(a0)
    80001292:	050ab503          	ld	a0,80(s5)
    80001296:	fffff097          	auipc	ra,0xfffff
    8000129a:	7d6080e7          	jalr	2006(ra) # 80000a6c <uvmcopy>
    8000129e:	04054863          	bltz	a0,800012ee <fork+0x8c>
  np->sz = p->sz;
    800012a2:	048ab783          	ld	a5,72(s5)
    800012a6:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800012aa:	058ab683          	ld	a3,88(s5)
    800012ae:	87b6                	mv	a5,a3
    800012b0:	058a3703          	ld	a4,88(s4)
    800012b4:	12068693          	addi	a3,a3,288
    800012b8:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012bc:	6788                	ld	a0,8(a5)
    800012be:	6b8c                	ld	a1,16(a5)
    800012c0:	6f90                	ld	a2,24(a5)
    800012c2:	01073023          	sd	a6,0(a4)
    800012c6:	e708                	sd	a0,8(a4)
    800012c8:	eb0c                	sd	a1,16(a4)
    800012ca:	ef10                	sd	a2,24(a4)
    800012cc:	02078793          	addi	a5,a5,32
    800012d0:	02070713          	addi	a4,a4,32
    800012d4:	fed792e3          	bne	a5,a3,800012b8 <fork+0x56>
  np->trapframe->a0 = 0;
    800012d8:	058a3783          	ld	a5,88(s4)
    800012dc:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012e0:	0d0a8493          	addi	s1,s5,208
    800012e4:	0d0a0913          	addi	s2,s4,208
    800012e8:	150a8993          	addi	s3,s5,336
    800012ec:	a00d                	j	8000130e <fork+0xac>
    freeproc(np);
    800012ee:	8552                	mv	a0,s4
    800012f0:	00000097          	auipc	ra,0x0
    800012f4:	d6e080e7          	jalr	-658(ra) # 8000105e <freeproc>
    release(&np->lock);
    800012f8:	8552                	mv	a0,s4
    800012fa:	00006097          	auipc	ra,0x6
    800012fe:	ecc080e7          	jalr	-308(ra) # 800071c6 <release>
    return -1;
    80001302:	597d                	li	s2,-1
    80001304:	a059                	j	8000138a <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001306:	04a1                	addi	s1,s1,8
    80001308:	0921                	addi	s2,s2,8
    8000130a:	01348b63          	beq	s1,s3,80001320 <fork+0xbe>
    if(p->ofile[i])
    8000130e:	6088                	ld	a0,0(s1)
    80001310:	d97d                	beqz	a0,80001306 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001312:	00002097          	auipc	ra,0x2
    80001316:	67c080e7          	jalr	1660(ra) # 8000398e <filedup>
    8000131a:	00a93023          	sd	a0,0(s2)
    8000131e:	b7e5                	j	80001306 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001320:	150ab503          	ld	a0,336(s5)
    80001324:	00001097          	auipc	ra,0x1
    80001328:	7ea080e7          	jalr	2026(ra) # 80002b0e <idup>
    8000132c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001330:	4641                	li	a2,16
    80001332:	158a8593          	addi	a1,s5,344
    80001336:	158a0513          	addi	a0,s4,344
    8000133a:	fffff097          	auipc	ra,0xfffff
    8000133e:	f8a080e7          	jalr	-118(ra) # 800002c4 <safestrcpy>
  pid = np->pid;
    80001342:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001346:	8552                	mv	a0,s4
    80001348:	00006097          	auipc	ra,0x6
    8000134c:	e7e080e7          	jalr	-386(ra) # 800071c6 <release>
  acquire(&wait_lock);
    80001350:	00008497          	auipc	s1,0x8
    80001354:	67848493          	addi	s1,s1,1656 # 800099c8 <wait_lock>
    80001358:	8526                	mv	a0,s1
    8000135a:	00006097          	auipc	ra,0x6
    8000135e:	db8080e7          	jalr	-584(ra) # 80007112 <acquire>
  np->parent = p;
    80001362:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001366:	8526                	mv	a0,s1
    80001368:	00006097          	auipc	ra,0x6
    8000136c:	e5e080e7          	jalr	-418(ra) # 800071c6 <release>
  acquire(&np->lock);
    80001370:	8552                	mv	a0,s4
    80001372:	00006097          	auipc	ra,0x6
    80001376:	da0080e7          	jalr	-608(ra) # 80007112 <acquire>
  np->state = RUNNABLE;
    8000137a:	478d                	li	a5,3
    8000137c:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001380:	8552                	mv	a0,s4
    80001382:	00006097          	auipc	ra,0x6
    80001386:	e44080e7          	jalr	-444(ra) # 800071c6 <release>
}
    8000138a:	854a                	mv	a0,s2
    8000138c:	70e2                	ld	ra,56(sp)
    8000138e:	7442                	ld	s0,48(sp)
    80001390:	74a2                	ld	s1,40(sp)
    80001392:	7902                	ld	s2,32(sp)
    80001394:	69e2                	ld	s3,24(sp)
    80001396:	6a42                	ld	s4,16(sp)
    80001398:	6aa2                	ld	s5,8(sp)
    8000139a:	6121                	addi	sp,sp,64
    8000139c:	8082                	ret
    return -1;
    8000139e:	597d                	li	s2,-1
    800013a0:	b7ed                	j	8000138a <fork+0x128>

00000000800013a2 <scheduler>:
{
    800013a2:	7139                	addi	sp,sp,-64
    800013a4:	fc06                	sd	ra,56(sp)
    800013a6:	f822                	sd	s0,48(sp)
    800013a8:	f426                	sd	s1,40(sp)
    800013aa:	f04a                	sd	s2,32(sp)
    800013ac:	ec4e                	sd	s3,24(sp)
    800013ae:	e852                	sd	s4,16(sp)
    800013b0:	e456                	sd	s5,8(sp)
    800013b2:	e05a                	sd	s6,0(sp)
    800013b4:	0080                	addi	s0,sp,64
    800013b6:	8792                	mv	a5,tp
  int id = r_tp();
    800013b8:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013ba:	00779a93          	slli	s5,a5,0x7
    800013be:	00008717          	auipc	a4,0x8
    800013c2:	5f270713          	addi	a4,a4,1522 # 800099b0 <pid_lock>
    800013c6:	9756                	add	a4,a4,s5
    800013c8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013cc:	00008717          	auipc	a4,0x8
    800013d0:	61c70713          	addi	a4,a4,1564 # 800099e8 <cpus+0x8>
    800013d4:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013d6:	498d                	li	s3,3
        p->state = RUNNING;
    800013d8:	4b11                	li	s6,4
        c->proc = p;
    800013da:	079e                	slli	a5,a5,0x7
    800013dc:	00008a17          	auipc	s4,0x8
    800013e0:	5d4a0a13          	addi	s4,s4,1492 # 800099b0 <pid_lock>
    800013e4:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013e6:	0000e917          	auipc	s2,0xe
    800013ea:	3fa90913          	addi	s2,s2,1018 # 8000f7e0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013ee:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013f2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013f6:	10079073          	csrw	sstatus,a5
    800013fa:	00009497          	auipc	s1,0x9
    800013fe:	9e648493          	addi	s1,s1,-1562 # 80009de0 <proc>
    80001402:	a811                	j	80001416 <scheduler+0x74>
      release(&p->lock);
    80001404:	8526                	mv	a0,s1
    80001406:	00006097          	auipc	ra,0x6
    8000140a:	dc0080e7          	jalr	-576(ra) # 800071c6 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000140e:	16848493          	addi	s1,s1,360
    80001412:	fd248ee3          	beq	s1,s2,800013ee <scheduler+0x4c>
      acquire(&p->lock);
    80001416:	8526                	mv	a0,s1
    80001418:	00006097          	auipc	ra,0x6
    8000141c:	cfa080e7          	jalr	-774(ra) # 80007112 <acquire>
      if(p->state == RUNNABLE) {
    80001420:	4c9c                	lw	a5,24(s1)
    80001422:	ff3791e3          	bne	a5,s3,80001404 <scheduler+0x62>
        p->state = RUNNING;
    80001426:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000142a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000142e:	06048593          	addi	a1,s1,96
    80001432:	8556                	mv	a0,s5
    80001434:	00000097          	auipc	ra,0x0
    80001438:	684080e7          	jalr	1668(ra) # 80001ab8 <swtch>
        c->proc = 0;
    8000143c:	020a3823          	sd	zero,48(s4)
    80001440:	b7d1                	j	80001404 <scheduler+0x62>

0000000080001442 <sched>:
{
    80001442:	7179                	addi	sp,sp,-48
    80001444:	f406                	sd	ra,40(sp)
    80001446:	f022                	sd	s0,32(sp)
    80001448:	ec26                	sd	s1,24(sp)
    8000144a:	e84a                	sd	s2,16(sp)
    8000144c:	e44e                	sd	s3,8(sp)
    8000144e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001450:	00000097          	auipc	ra,0x0
    80001454:	a5c080e7          	jalr	-1444(ra) # 80000eac <myproc>
    80001458:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000145a:	00006097          	auipc	ra,0x6
    8000145e:	c3e080e7          	jalr	-962(ra) # 80007098 <holding>
    80001462:	c93d                	beqz	a0,800014d8 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001464:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001466:	2781                	sext.w	a5,a5
    80001468:	079e                	slli	a5,a5,0x7
    8000146a:	00008717          	auipc	a4,0x8
    8000146e:	54670713          	addi	a4,a4,1350 # 800099b0 <pid_lock>
    80001472:	97ba                	add	a5,a5,a4
    80001474:	0a87a703          	lw	a4,168(a5)
    80001478:	4785                	li	a5,1
    8000147a:	06f71763          	bne	a4,a5,800014e8 <sched+0xa6>
  if(p->state == RUNNING)
    8000147e:	4c98                	lw	a4,24(s1)
    80001480:	4791                	li	a5,4
    80001482:	06f70b63          	beq	a4,a5,800014f8 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001486:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000148a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000148c:	efb5                	bnez	a5,80001508 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000148e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001490:	00008917          	auipc	s2,0x8
    80001494:	52090913          	addi	s2,s2,1312 # 800099b0 <pid_lock>
    80001498:	2781                	sext.w	a5,a5
    8000149a:	079e                	slli	a5,a5,0x7
    8000149c:	97ca                	add	a5,a5,s2
    8000149e:	0ac7a983          	lw	s3,172(a5)
    800014a2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014a4:	2781                	sext.w	a5,a5
    800014a6:	079e                	slli	a5,a5,0x7
    800014a8:	00008597          	auipc	a1,0x8
    800014ac:	54058593          	addi	a1,a1,1344 # 800099e8 <cpus+0x8>
    800014b0:	95be                	add	a1,a1,a5
    800014b2:	06048513          	addi	a0,s1,96
    800014b6:	00000097          	auipc	ra,0x0
    800014ba:	602080e7          	jalr	1538(ra) # 80001ab8 <swtch>
    800014be:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014c0:	2781                	sext.w	a5,a5
    800014c2:	079e                	slli	a5,a5,0x7
    800014c4:	993e                	add	s2,s2,a5
    800014c6:	0b392623          	sw	s3,172(s2)
}
    800014ca:	70a2                	ld	ra,40(sp)
    800014cc:	7402                	ld	s0,32(sp)
    800014ce:	64e2                	ld	s1,24(sp)
    800014d0:	6942                	ld	s2,16(sp)
    800014d2:	69a2                	ld	s3,8(sp)
    800014d4:	6145                	addi	sp,sp,48
    800014d6:	8082                	ret
    panic("sched p->lock");
    800014d8:	00008517          	auipc	a0,0x8
    800014dc:	cd050513          	addi	a0,a0,-816 # 800091a8 <etext+0x1a8>
    800014e0:	00005097          	auipc	ra,0x5
    800014e4:	6fa080e7          	jalr	1786(ra) # 80006bda <panic>
    panic("sched locks");
    800014e8:	00008517          	auipc	a0,0x8
    800014ec:	cd050513          	addi	a0,a0,-816 # 800091b8 <etext+0x1b8>
    800014f0:	00005097          	auipc	ra,0x5
    800014f4:	6ea080e7          	jalr	1770(ra) # 80006bda <panic>
    panic("sched running");
    800014f8:	00008517          	auipc	a0,0x8
    800014fc:	cd050513          	addi	a0,a0,-816 # 800091c8 <etext+0x1c8>
    80001500:	00005097          	auipc	ra,0x5
    80001504:	6da080e7          	jalr	1754(ra) # 80006bda <panic>
    panic("sched interruptible");
    80001508:	00008517          	auipc	a0,0x8
    8000150c:	cd050513          	addi	a0,a0,-816 # 800091d8 <etext+0x1d8>
    80001510:	00005097          	auipc	ra,0x5
    80001514:	6ca080e7          	jalr	1738(ra) # 80006bda <panic>

0000000080001518 <yield>:
{
    80001518:	1101                	addi	sp,sp,-32
    8000151a:	ec06                	sd	ra,24(sp)
    8000151c:	e822                	sd	s0,16(sp)
    8000151e:	e426                	sd	s1,8(sp)
    80001520:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001522:	00000097          	auipc	ra,0x0
    80001526:	98a080e7          	jalr	-1654(ra) # 80000eac <myproc>
    8000152a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000152c:	00006097          	auipc	ra,0x6
    80001530:	be6080e7          	jalr	-1050(ra) # 80007112 <acquire>
  p->state = RUNNABLE;
    80001534:	478d                	li	a5,3
    80001536:	cc9c                	sw	a5,24(s1)
  sched();
    80001538:	00000097          	auipc	ra,0x0
    8000153c:	f0a080e7          	jalr	-246(ra) # 80001442 <sched>
  release(&p->lock);
    80001540:	8526                	mv	a0,s1
    80001542:	00006097          	auipc	ra,0x6
    80001546:	c84080e7          	jalr	-892(ra) # 800071c6 <release>
}
    8000154a:	60e2                	ld	ra,24(sp)
    8000154c:	6442                	ld	s0,16(sp)
    8000154e:	64a2                	ld	s1,8(sp)
    80001550:	6105                	addi	sp,sp,32
    80001552:	8082                	ret

0000000080001554 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001554:	7179                	addi	sp,sp,-48
    80001556:	f406                	sd	ra,40(sp)
    80001558:	f022                	sd	s0,32(sp)
    8000155a:	ec26                	sd	s1,24(sp)
    8000155c:	e84a                	sd	s2,16(sp)
    8000155e:	e44e                	sd	s3,8(sp)
    80001560:	1800                	addi	s0,sp,48
    80001562:	89aa                	mv	s3,a0
    80001564:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001566:	00000097          	auipc	ra,0x0
    8000156a:	946080e7          	jalr	-1722(ra) # 80000eac <myproc>
    8000156e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001570:	00006097          	auipc	ra,0x6
    80001574:	ba2080e7          	jalr	-1118(ra) # 80007112 <acquire>
  release(lk);
    80001578:	854a                	mv	a0,s2
    8000157a:	00006097          	auipc	ra,0x6
    8000157e:	c4c080e7          	jalr	-948(ra) # 800071c6 <release>

  // Go to sleep.
  p->chan = chan;
    80001582:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001586:	4789                	li	a5,2
    80001588:	cc9c                	sw	a5,24(s1)

  sched();
    8000158a:	00000097          	auipc	ra,0x0
    8000158e:	eb8080e7          	jalr	-328(ra) # 80001442 <sched>

  // Tidy up.
  p->chan = 0;
    80001592:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001596:	8526                	mv	a0,s1
    80001598:	00006097          	auipc	ra,0x6
    8000159c:	c2e080e7          	jalr	-978(ra) # 800071c6 <release>
  acquire(lk);
    800015a0:	854a                	mv	a0,s2
    800015a2:	00006097          	auipc	ra,0x6
    800015a6:	b70080e7          	jalr	-1168(ra) # 80007112 <acquire>
}
    800015aa:	70a2                	ld	ra,40(sp)
    800015ac:	7402                	ld	s0,32(sp)
    800015ae:	64e2                	ld	s1,24(sp)
    800015b0:	6942                	ld	s2,16(sp)
    800015b2:	69a2                	ld	s3,8(sp)
    800015b4:	6145                	addi	sp,sp,48
    800015b6:	8082                	ret

00000000800015b8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800015b8:	7139                	addi	sp,sp,-64
    800015ba:	fc06                	sd	ra,56(sp)
    800015bc:	f822                	sd	s0,48(sp)
    800015be:	f426                	sd	s1,40(sp)
    800015c0:	f04a                	sd	s2,32(sp)
    800015c2:	ec4e                	sd	s3,24(sp)
    800015c4:	e852                	sd	s4,16(sp)
    800015c6:	e456                	sd	s5,8(sp)
    800015c8:	0080                	addi	s0,sp,64
    800015ca:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800015cc:	00009497          	auipc	s1,0x9
    800015d0:	81448493          	addi	s1,s1,-2028 # 80009de0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800015d4:	4989                	li	s3,2
        p->state = RUNNABLE;
    800015d6:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800015d8:	0000e917          	auipc	s2,0xe
    800015dc:	20890913          	addi	s2,s2,520 # 8000f7e0 <tickslock>
    800015e0:	a811                	j	800015f4 <wakeup+0x3c>
      }
      release(&p->lock);
    800015e2:	8526                	mv	a0,s1
    800015e4:	00006097          	auipc	ra,0x6
    800015e8:	be2080e7          	jalr	-1054(ra) # 800071c6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800015ec:	16848493          	addi	s1,s1,360
    800015f0:	03248663          	beq	s1,s2,8000161c <wakeup+0x64>
    if(p != myproc()){
    800015f4:	00000097          	auipc	ra,0x0
    800015f8:	8b8080e7          	jalr	-1864(ra) # 80000eac <myproc>
    800015fc:	fea488e3          	beq	s1,a0,800015ec <wakeup+0x34>
      acquire(&p->lock);
    80001600:	8526                	mv	a0,s1
    80001602:	00006097          	auipc	ra,0x6
    80001606:	b10080e7          	jalr	-1264(ra) # 80007112 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000160a:	4c9c                	lw	a5,24(s1)
    8000160c:	fd379be3          	bne	a5,s3,800015e2 <wakeup+0x2a>
    80001610:	709c                	ld	a5,32(s1)
    80001612:	fd4798e3          	bne	a5,s4,800015e2 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001616:	0154ac23          	sw	s5,24(s1)
    8000161a:	b7e1                	j	800015e2 <wakeup+0x2a>
    }
  }
}
    8000161c:	70e2                	ld	ra,56(sp)
    8000161e:	7442                	ld	s0,48(sp)
    80001620:	74a2                	ld	s1,40(sp)
    80001622:	7902                	ld	s2,32(sp)
    80001624:	69e2                	ld	s3,24(sp)
    80001626:	6a42                	ld	s4,16(sp)
    80001628:	6aa2                	ld	s5,8(sp)
    8000162a:	6121                	addi	sp,sp,64
    8000162c:	8082                	ret

000000008000162e <reparent>:
{
    8000162e:	7179                	addi	sp,sp,-48
    80001630:	f406                	sd	ra,40(sp)
    80001632:	f022                	sd	s0,32(sp)
    80001634:	ec26                	sd	s1,24(sp)
    80001636:	e84a                	sd	s2,16(sp)
    80001638:	e44e                	sd	s3,8(sp)
    8000163a:	e052                	sd	s4,0(sp)
    8000163c:	1800                	addi	s0,sp,48
    8000163e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001640:	00008497          	auipc	s1,0x8
    80001644:	7a048493          	addi	s1,s1,1952 # 80009de0 <proc>
      pp->parent = initproc;
    80001648:	00008a17          	auipc	s4,0x8
    8000164c:	308a0a13          	addi	s4,s4,776 # 80009950 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001650:	0000e997          	auipc	s3,0xe
    80001654:	19098993          	addi	s3,s3,400 # 8000f7e0 <tickslock>
    80001658:	a029                	j	80001662 <reparent+0x34>
    8000165a:	16848493          	addi	s1,s1,360
    8000165e:	01348d63          	beq	s1,s3,80001678 <reparent+0x4a>
    if(pp->parent == p){
    80001662:	7c9c                	ld	a5,56(s1)
    80001664:	ff279be3          	bne	a5,s2,8000165a <reparent+0x2c>
      pp->parent = initproc;
    80001668:	000a3503          	ld	a0,0(s4)
    8000166c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000166e:	00000097          	auipc	ra,0x0
    80001672:	f4a080e7          	jalr	-182(ra) # 800015b8 <wakeup>
    80001676:	b7d5                	j	8000165a <reparent+0x2c>
}
    80001678:	70a2                	ld	ra,40(sp)
    8000167a:	7402                	ld	s0,32(sp)
    8000167c:	64e2                	ld	s1,24(sp)
    8000167e:	6942                	ld	s2,16(sp)
    80001680:	69a2                	ld	s3,8(sp)
    80001682:	6a02                	ld	s4,0(sp)
    80001684:	6145                	addi	sp,sp,48
    80001686:	8082                	ret

0000000080001688 <exit>:
{
    80001688:	7179                	addi	sp,sp,-48
    8000168a:	f406                	sd	ra,40(sp)
    8000168c:	f022                	sd	s0,32(sp)
    8000168e:	ec26                	sd	s1,24(sp)
    80001690:	e84a                	sd	s2,16(sp)
    80001692:	e44e                	sd	s3,8(sp)
    80001694:	e052                	sd	s4,0(sp)
    80001696:	1800                	addi	s0,sp,48
    80001698:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000169a:	00000097          	auipc	ra,0x0
    8000169e:	812080e7          	jalr	-2030(ra) # 80000eac <myproc>
    800016a2:	89aa                	mv	s3,a0
  if(p == initproc)
    800016a4:	00008797          	auipc	a5,0x8
    800016a8:	2ac7b783          	ld	a5,684(a5) # 80009950 <initproc>
    800016ac:	0d050493          	addi	s1,a0,208
    800016b0:	15050913          	addi	s2,a0,336
    800016b4:	02a79363          	bne	a5,a0,800016da <exit+0x52>
    panic("init exiting");
    800016b8:	00008517          	auipc	a0,0x8
    800016bc:	b3850513          	addi	a0,a0,-1224 # 800091f0 <etext+0x1f0>
    800016c0:	00005097          	auipc	ra,0x5
    800016c4:	51a080e7          	jalr	1306(ra) # 80006bda <panic>
      fileclose(f);
    800016c8:	00002097          	auipc	ra,0x2
    800016cc:	318080e7          	jalr	792(ra) # 800039e0 <fileclose>
      p->ofile[fd] = 0;
    800016d0:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800016d4:	04a1                	addi	s1,s1,8
    800016d6:	01248563          	beq	s1,s2,800016e0 <exit+0x58>
    if(p->ofile[fd]){
    800016da:	6088                	ld	a0,0(s1)
    800016dc:	f575                	bnez	a0,800016c8 <exit+0x40>
    800016de:	bfdd                	j	800016d4 <exit+0x4c>
  begin_op();
    800016e0:	00002097          	auipc	ra,0x2
    800016e4:	e38080e7          	jalr	-456(ra) # 80003518 <begin_op>
  iput(p->cwd);
    800016e8:	1509b503          	ld	a0,336(s3)
    800016ec:	00001097          	auipc	ra,0x1
    800016f0:	61a080e7          	jalr	1562(ra) # 80002d06 <iput>
  end_op();
    800016f4:	00002097          	auipc	ra,0x2
    800016f8:	ea2080e7          	jalr	-350(ra) # 80003596 <end_op>
  p->cwd = 0;
    800016fc:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001700:	00008497          	auipc	s1,0x8
    80001704:	2c848493          	addi	s1,s1,712 # 800099c8 <wait_lock>
    80001708:	8526                	mv	a0,s1
    8000170a:	00006097          	auipc	ra,0x6
    8000170e:	a08080e7          	jalr	-1528(ra) # 80007112 <acquire>
  reparent(p);
    80001712:	854e                	mv	a0,s3
    80001714:	00000097          	auipc	ra,0x0
    80001718:	f1a080e7          	jalr	-230(ra) # 8000162e <reparent>
  wakeup(p->parent);
    8000171c:	0389b503          	ld	a0,56(s3)
    80001720:	00000097          	auipc	ra,0x0
    80001724:	e98080e7          	jalr	-360(ra) # 800015b8 <wakeup>
  acquire(&p->lock);
    80001728:	854e                	mv	a0,s3
    8000172a:	00006097          	auipc	ra,0x6
    8000172e:	9e8080e7          	jalr	-1560(ra) # 80007112 <acquire>
  p->xstate = status;
    80001732:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001736:	4795                	li	a5,5
    80001738:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000173c:	8526                	mv	a0,s1
    8000173e:	00006097          	auipc	ra,0x6
    80001742:	a88080e7          	jalr	-1400(ra) # 800071c6 <release>
  sched();
    80001746:	00000097          	auipc	ra,0x0
    8000174a:	cfc080e7          	jalr	-772(ra) # 80001442 <sched>
  panic("zombie exit");
    8000174e:	00008517          	auipc	a0,0x8
    80001752:	ab250513          	addi	a0,a0,-1358 # 80009200 <etext+0x200>
    80001756:	00005097          	auipc	ra,0x5
    8000175a:	484080e7          	jalr	1156(ra) # 80006bda <panic>

000000008000175e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000175e:	7179                	addi	sp,sp,-48
    80001760:	f406                	sd	ra,40(sp)
    80001762:	f022                	sd	s0,32(sp)
    80001764:	ec26                	sd	s1,24(sp)
    80001766:	e84a                	sd	s2,16(sp)
    80001768:	e44e                	sd	s3,8(sp)
    8000176a:	1800                	addi	s0,sp,48
    8000176c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000176e:	00008497          	auipc	s1,0x8
    80001772:	67248493          	addi	s1,s1,1650 # 80009de0 <proc>
    80001776:	0000e997          	auipc	s3,0xe
    8000177a:	06a98993          	addi	s3,s3,106 # 8000f7e0 <tickslock>
    acquire(&p->lock);
    8000177e:	8526                	mv	a0,s1
    80001780:	00006097          	auipc	ra,0x6
    80001784:	992080e7          	jalr	-1646(ra) # 80007112 <acquire>
    if(p->pid == pid){
    80001788:	589c                	lw	a5,48(s1)
    8000178a:	01278d63          	beq	a5,s2,800017a4 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000178e:	8526                	mv	a0,s1
    80001790:	00006097          	auipc	ra,0x6
    80001794:	a36080e7          	jalr	-1482(ra) # 800071c6 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001798:	16848493          	addi	s1,s1,360
    8000179c:	ff3491e3          	bne	s1,s3,8000177e <kill+0x20>
  }
  return -1;
    800017a0:	557d                	li	a0,-1
    800017a2:	a829                	j	800017bc <kill+0x5e>
      p->killed = 1;
    800017a4:	4785                	li	a5,1
    800017a6:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800017a8:	4c98                	lw	a4,24(s1)
    800017aa:	4789                	li	a5,2
    800017ac:	00f70f63          	beq	a4,a5,800017ca <kill+0x6c>
      release(&p->lock);
    800017b0:	8526                	mv	a0,s1
    800017b2:	00006097          	auipc	ra,0x6
    800017b6:	a14080e7          	jalr	-1516(ra) # 800071c6 <release>
      return 0;
    800017ba:	4501                	li	a0,0
}
    800017bc:	70a2                	ld	ra,40(sp)
    800017be:	7402                	ld	s0,32(sp)
    800017c0:	64e2                	ld	s1,24(sp)
    800017c2:	6942                	ld	s2,16(sp)
    800017c4:	69a2                	ld	s3,8(sp)
    800017c6:	6145                	addi	sp,sp,48
    800017c8:	8082                	ret
        p->state = RUNNABLE;
    800017ca:	478d                	li	a5,3
    800017cc:	cc9c                	sw	a5,24(s1)
    800017ce:	b7cd                	j	800017b0 <kill+0x52>

00000000800017d0 <setkilled>:

void
setkilled(struct proc *p)
{
    800017d0:	1101                	addi	sp,sp,-32
    800017d2:	ec06                	sd	ra,24(sp)
    800017d4:	e822                	sd	s0,16(sp)
    800017d6:	e426                	sd	s1,8(sp)
    800017d8:	1000                	addi	s0,sp,32
    800017da:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800017dc:	00006097          	auipc	ra,0x6
    800017e0:	936080e7          	jalr	-1738(ra) # 80007112 <acquire>
  p->killed = 1;
    800017e4:	4785                	li	a5,1
    800017e6:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800017e8:	8526                	mv	a0,s1
    800017ea:	00006097          	auipc	ra,0x6
    800017ee:	9dc080e7          	jalr	-1572(ra) # 800071c6 <release>
}
    800017f2:	60e2                	ld	ra,24(sp)
    800017f4:	6442                	ld	s0,16(sp)
    800017f6:	64a2                	ld	s1,8(sp)
    800017f8:	6105                	addi	sp,sp,32
    800017fa:	8082                	ret

00000000800017fc <killed>:

int
killed(struct proc *p)
{
    800017fc:	1101                	addi	sp,sp,-32
    800017fe:	ec06                	sd	ra,24(sp)
    80001800:	e822                	sd	s0,16(sp)
    80001802:	e426                	sd	s1,8(sp)
    80001804:	e04a                	sd	s2,0(sp)
    80001806:	1000                	addi	s0,sp,32
    80001808:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000180a:	00006097          	auipc	ra,0x6
    8000180e:	908080e7          	jalr	-1784(ra) # 80007112 <acquire>
  k = p->killed;
    80001812:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001816:	8526                	mv	a0,s1
    80001818:	00006097          	auipc	ra,0x6
    8000181c:	9ae080e7          	jalr	-1618(ra) # 800071c6 <release>
  return k;
}
    80001820:	854a                	mv	a0,s2
    80001822:	60e2                	ld	ra,24(sp)
    80001824:	6442                	ld	s0,16(sp)
    80001826:	64a2                	ld	s1,8(sp)
    80001828:	6902                	ld	s2,0(sp)
    8000182a:	6105                	addi	sp,sp,32
    8000182c:	8082                	ret

000000008000182e <wait>:
{
    8000182e:	715d                	addi	sp,sp,-80
    80001830:	e486                	sd	ra,72(sp)
    80001832:	e0a2                	sd	s0,64(sp)
    80001834:	fc26                	sd	s1,56(sp)
    80001836:	f84a                	sd	s2,48(sp)
    80001838:	f44e                	sd	s3,40(sp)
    8000183a:	f052                	sd	s4,32(sp)
    8000183c:	ec56                	sd	s5,24(sp)
    8000183e:	e85a                	sd	s6,16(sp)
    80001840:	e45e                	sd	s7,8(sp)
    80001842:	e062                	sd	s8,0(sp)
    80001844:	0880                	addi	s0,sp,80
    80001846:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001848:	fffff097          	auipc	ra,0xfffff
    8000184c:	664080e7          	jalr	1636(ra) # 80000eac <myproc>
    80001850:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001852:	00008517          	auipc	a0,0x8
    80001856:	17650513          	addi	a0,a0,374 # 800099c8 <wait_lock>
    8000185a:	00006097          	auipc	ra,0x6
    8000185e:	8b8080e7          	jalr	-1864(ra) # 80007112 <acquire>
    havekids = 0;
    80001862:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001864:	4a15                	li	s4,5
        havekids = 1;
    80001866:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001868:	0000e997          	auipc	s3,0xe
    8000186c:	f7898993          	addi	s3,s3,-136 # 8000f7e0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001870:	00008c17          	auipc	s8,0x8
    80001874:	158c0c13          	addi	s8,s8,344 # 800099c8 <wait_lock>
    havekids = 0;
    80001878:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000187a:	00008497          	auipc	s1,0x8
    8000187e:	56648493          	addi	s1,s1,1382 # 80009de0 <proc>
    80001882:	a0bd                	j	800018f0 <wait+0xc2>
          pid = pp->pid;
    80001884:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001888:	000b0e63          	beqz	s6,800018a4 <wait+0x76>
    8000188c:	4691                	li	a3,4
    8000188e:	02c48613          	addi	a2,s1,44
    80001892:	85da                	mv	a1,s6
    80001894:	05093503          	ld	a0,80(s2)
    80001898:	fffff097          	auipc	ra,0xfffff
    8000189c:	2d8080e7          	jalr	728(ra) # 80000b70 <copyout>
    800018a0:	02054563          	bltz	a0,800018ca <wait+0x9c>
          freeproc(pp);
    800018a4:	8526                	mv	a0,s1
    800018a6:	fffff097          	auipc	ra,0xfffff
    800018aa:	7b8080e7          	jalr	1976(ra) # 8000105e <freeproc>
          release(&pp->lock);
    800018ae:	8526                	mv	a0,s1
    800018b0:	00006097          	auipc	ra,0x6
    800018b4:	916080e7          	jalr	-1770(ra) # 800071c6 <release>
          release(&wait_lock);
    800018b8:	00008517          	auipc	a0,0x8
    800018bc:	11050513          	addi	a0,a0,272 # 800099c8 <wait_lock>
    800018c0:	00006097          	auipc	ra,0x6
    800018c4:	906080e7          	jalr	-1786(ra) # 800071c6 <release>
          return pid;
    800018c8:	a0b5                	j	80001934 <wait+0x106>
            release(&pp->lock);
    800018ca:	8526                	mv	a0,s1
    800018cc:	00006097          	auipc	ra,0x6
    800018d0:	8fa080e7          	jalr	-1798(ra) # 800071c6 <release>
            release(&wait_lock);
    800018d4:	00008517          	auipc	a0,0x8
    800018d8:	0f450513          	addi	a0,a0,244 # 800099c8 <wait_lock>
    800018dc:	00006097          	auipc	ra,0x6
    800018e0:	8ea080e7          	jalr	-1814(ra) # 800071c6 <release>
            return -1;
    800018e4:	59fd                	li	s3,-1
    800018e6:	a0b9                	j	80001934 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018e8:	16848493          	addi	s1,s1,360
    800018ec:	03348463          	beq	s1,s3,80001914 <wait+0xe6>
      if(pp->parent == p){
    800018f0:	7c9c                	ld	a5,56(s1)
    800018f2:	ff279be3          	bne	a5,s2,800018e8 <wait+0xba>
        acquire(&pp->lock);
    800018f6:	8526                	mv	a0,s1
    800018f8:	00006097          	auipc	ra,0x6
    800018fc:	81a080e7          	jalr	-2022(ra) # 80007112 <acquire>
        if(pp->state == ZOMBIE){
    80001900:	4c9c                	lw	a5,24(s1)
    80001902:	f94781e3          	beq	a5,s4,80001884 <wait+0x56>
        release(&pp->lock);
    80001906:	8526                	mv	a0,s1
    80001908:	00006097          	auipc	ra,0x6
    8000190c:	8be080e7          	jalr	-1858(ra) # 800071c6 <release>
        havekids = 1;
    80001910:	8756                	mv	a4,s5
    80001912:	bfd9                	j	800018e8 <wait+0xba>
    if(!havekids || killed(p)){
    80001914:	c719                	beqz	a4,80001922 <wait+0xf4>
    80001916:	854a                	mv	a0,s2
    80001918:	00000097          	auipc	ra,0x0
    8000191c:	ee4080e7          	jalr	-284(ra) # 800017fc <killed>
    80001920:	c51d                	beqz	a0,8000194e <wait+0x120>
      release(&wait_lock);
    80001922:	00008517          	auipc	a0,0x8
    80001926:	0a650513          	addi	a0,a0,166 # 800099c8 <wait_lock>
    8000192a:	00006097          	auipc	ra,0x6
    8000192e:	89c080e7          	jalr	-1892(ra) # 800071c6 <release>
      return -1;
    80001932:	59fd                	li	s3,-1
}
    80001934:	854e                	mv	a0,s3
    80001936:	60a6                	ld	ra,72(sp)
    80001938:	6406                	ld	s0,64(sp)
    8000193a:	74e2                	ld	s1,56(sp)
    8000193c:	7942                	ld	s2,48(sp)
    8000193e:	79a2                	ld	s3,40(sp)
    80001940:	7a02                	ld	s4,32(sp)
    80001942:	6ae2                	ld	s5,24(sp)
    80001944:	6b42                	ld	s6,16(sp)
    80001946:	6ba2                	ld	s7,8(sp)
    80001948:	6c02                	ld	s8,0(sp)
    8000194a:	6161                	addi	sp,sp,80
    8000194c:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000194e:	85e2                	mv	a1,s8
    80001950:	854a                	mv	a0,s2
    80001952:	00000097          	auipc	ra,0x0
    80001956:	c02080e7          	jalr	-1022(ra) # 80001554 <sleep>
    havekids = 0;
    8000195a:	bf39                	j	80001878 <wait+0x4a>

000000008000195c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000195c:	7179                	addi	sp,sp,-48
    8000195e:	f406                	sd	ra,40(sp)
    80001960:	f022                	sd	s0,32(sp)
    80001962:	ec26                	sd	s1,24(sp)
    80001964:	e84a                	sd	s2,16(sp)
    80001966:	e44e                	sd	s3,8(sp)
    80001968:	e052                	sd	s4,0(sp)
    8000196a:	1800                	addi	s0,sp,48
    8000196c:	84aa                	mv	s1,a0
    8000196e:	892e                	mv	s2,a1
    80001970:	89b2                	mv	s3,a2
    80001972:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001974:	fffff097          	auipc	ra,0xfffff
    80001978:	538080e7          	jalr	1336(ra) # 80000eac <myproc>
  if(user_dst){
    8000197c:	c08d                	beqz	s1,8000199e <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000197e:	86d2                	mv	a3,s4
    80001980:	864e                	mv	a2,s3
    80001982:	85ca                	mv	a1,s2
    80001984:	6928                	ld	a0,80(a0)
    80001986:	fffff097          	auipc	ra,0xfffff
    8000198a:	1ea080e7          	jalr	490(ra) # 80000b70 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000198e:	70a2                	ld	ra,40(sp)
    80001990:	7402                	ld	s0,32(sp)
    80001992:	64e2                	ld	s1,24(sp)
    80001994:	6942                	ld	s2,16(sp)
    80001996:	69a2                	ld	s3,8(sp)
    80001998:	6a02                	ld	s4,0(sp)
    8000199a:	6145                	addi	sp,sp,48
    8000199c:	8082                	ret
    memmove((char *)dst, src, len);
    8000199e:	000a061b          	sext.w	a2,s4
    800019a2:	85ce                	mv	a1,s3
    800019a4:	854a                	mv	a0,s2
    800019a6:	fffff097          	auipc	ra,0xfffff
    800019aa:	830080e7          	jalr	-2000(ra) # 800001d6 <memmove>
    return 0;
    800019ae:	8526                	mv	a0,s1
    800019b0:	bff9                	j	8000198e <either_copyout+0x32>

00000000800019b2 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019b2:	7179                	addi	sp,sp,-48
    800019b4:	f406                	sd	ra,40(sp)
    800019b6:	f022                	sd	s0,32(sp)
    800019b8:	ec26                	sd	s1,24(sp)
    800019ba:	e84a                	sd	s2,16(sp)
    800019bc:	e44e                	sd	s3,8(sp)
    800019be:	e052                	sd	s4,0(sp)
    800019c0:	1800                	addi	s0,sp,48
    800019c2:	892a                	mv	s2,a0
    800019c4:	84ae                	mv	s1,a1
    800019c6:	89b2                	mv	s3,a2
    800019c8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019ca:	fffff097          	auipc	ra,0xfffff
    800019ce:	4e2080e7          	jalr	1250(ra) # 80000eac <myproc>
  if(user_src){
    800019d2:	c08d                	beqz	s1,800019f4 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019d4:	86d2                	mv	a3,s4
    800019d6:	864e                	mv	a2,s3
    800019d8:	85ca                	mv	a1,s2
    800019da:	6928                	ld	a0,80(a0)
    800019dc:	fffff097          	auipc	ra,0xfffff
    800019e0:	220080e7          	jalr	544(ra) # 80000bfc <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019e4:	70a2                	ld	ra,40(sp)
    800019e6:	7402                	ld	s0,32(sp)
    800019e8:	64e2                	ld	s1,24(sp)
    800019ea:	6942                	ld	s2,16(sp)
    800019ec:	69a2                	ld	s3,8(sp)
    800019ee:	6a02                	ld	s4,0(sp)
    800019f0:	6145                	addi	sp,sp,48
    800019f2:	8082                	ret
    memmove(dst, (char*)src, len);
    800019f4:	000a061b          	sext.w	a2,s4
    800019f8:	85ce                	mv	a1,s3
    800019fa:	854a                	mv	a0,s2
    800019fc:	ffffe097          	auipc	ra,0xffffe
    80001a00:	7da080e7          	jalr	2010(ra) # 800001d6 <memmove>
    return 0;
    80001a04:	8526                	mv	a0,s1
    80001a06:	bff9                	j	800019e4 <either_copyin+0x32>

0000000080001a08 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a08:	715d                	addi	sp,sp,-80
    80001a0a:	e486                	sd	ra,72(sp)
    80001a0c:	e0a2                	sd	s0,64(sp)
    80001a0e:	fc26                	sd	s1,56(sp)
    80001a10:	f84a                	sd	s2,48(sp)
    80001a12:	f44e                	sd	s3,40(sp)
    80001a14:	f052                	sd	s4,32(sp)
    80001a16:	ec56                	sd	s5,24(sp)
    80001a18:	e85a                	sd	s6,16(sp)
    80001a1a:	e45e                	sd	s7,8(sp)
    80001a1c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a1e:	00007517          	auipc	a0,0x7
    80001a22:	62a50513          	addi	a0,a0,1578 # 80009048 <etext+0x48>
    80001a26:	00005097          	auipc	ra,0x5
    80001a2a:	1fe080e7          	jalr	510(ra) # 80006c24 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a2e:	00008497          	auipc	s1,0x8
    80001a32:	50a48493          	addi	s1,s1,1290 # 80009f38 <proc+0x158>
    80001a36:	0000e917          	auipc	s2,0xe
    80001a3a:	f0290913          	addi	s2,s2,-254 # 8000f938 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a3e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a40:	00007997          	auipc	s3,0x7
    80001a44:	7d098993          	addi	s3,s3,2000 # 80009210 <etext+0x210>
    printf("%d %s %s", p->pid, state, p->name);
    80001a48:	00007a97          	auipc	s5,0x7
    80001a4c:	7d0a8a93          	addi	s5,s5,2000 # 80009218 <etext+0x218>
    printf("\n");
    80001a50:	00007a17          	auipc	s4,0x7
    80001a54:	5f8a0a13          	addi	s4,s4,1528 # 80009048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a58:	00008b97          	auipc	s7,0x8
    80001a5c:	800b8b93          	addi	s7,s7,-2048 # 80009258 <states.0>
    80001a60:	a00d                	j	80001a82 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a62:	ed86a583          	lw	a1,-296(a3)
    80001a66:	8556                	mv	a0,s5
    80001a68:	00005097          	auipc	ra,0x5
    80001a6c:	1bc080e7          	jalr	444(ra) # 80006c24 <printf>
    printf("\n");
    80001a70:	8552                	mv	a0,s4
    80001a72:	00005097          	auipc	ra,0x5
    80001a76:	1b2080e7          	jalr	434(ra) # 80006c24 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a7a:	16848493          	addi	s1,s1,360
    80001a7e:	03248263          	beq	s1,s2,80001aa2 <procdump+0x9a>
    if(p->state == UNUSED)
    80001a82:	86a6                	mv	a3,s1
    80001a84:	ec04a783          	lw	a5,-320(s1)
    80001a88:	dbed                	beqz	a5,80001a7a <procdump+0x72>
      state = "???";
    80001a8a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a8c:	fcfb6be3          	bltu	s6,a5,80001a62 <procdump+0x5a>
    80001a90:	02079713          	slli	a4,a5,0x20
    80001a94:	01d75793          	srli	a5,a4,0x1d
    80001a98:	97de                	add	a5,a5,s7
    80001a9a:	6390                	ld	a2,0(a5)
    80001a9c:	f279                	bnez	a2,80001a62 <procdump+0x5a>
      state = "???";
    80001a9e:	864e                	mv	a2,s3
    80001aa0:	b7c9                	j	80001a62 <procdump+0x5a>
  }
}
    80001aa2:	60a6                	ld	ra,72(sp)
    80001aa4:	6406                	ld	s0,64(sp)
    80001aa6:	74e2                	ld	s1,56(sp)
    80001aa8:	7942                	ld	s2,48(sp)
    80001aaa:	79a2                	ld	s3,40(sp)
    80001aac:	7a02                	ld	s4,32(sp)
    80001aae:	6ae2                	ld	s5,24(sp)
    80001ab0:	6b42                	ld	s6,16(sp)
    80001ab2:	6ba2                	ld	s7,8(sp)
    80001ab4:	6161                	addi	sp,sp,80
    80001ab6:	8082                	ret

0000000080001ab8 <swtch>:
    80001ab8:	00153023          	sd	ra,0(a0)
    80001abc:	00253423          	sd	sp,8(a0)
    80001ac0:	e900                	sd	s0,16(a0)
    80001ac2:	ed04                	sd	s1,24(a0)
    80001ac4:	03253023          	sd	s2,32(a0)
    80001ac8:	03353423          	sd	s3,40(a0)
    80001acc:	03453823          	sd	s4,48(a0)
    80001ad0:	03553c23          	sd	s5,56(a0)
    80001ad4:	05653023          	sd	s6,64(a0)
    80001ad8:	05753423          	sd	s7,72(a0)
    80001adc:	05853823          	sd	s8,80(a0)
    80001ae0:	05953c23          	sd	s9,88(a0)
    80001ae4:	07a53023          	sd	s10,96(a0)
    80001ae8:	07b53423          	sd	s11,104(a0)
    80001aec:	0005b083          	ld	ra,0(a1)
    80001af0:	0085b103          	ld	sp,8(a1)
    80001af4:	6980                	ld	s0,16(a1)
    80001af6:	6d84                	ld	s1,24(a1)
    80001af8:	0205b903          	ld	s2,32(a1)
    80001afc:	0285b983          	ld	s3,40(a1)
    80001b00:	0305ba03          	ld	s4,48(a1)
    80001b04:	0385ba83          	ld	s5,56(a1)
    80001b08:	0405bb03          	ld	s6,64(a1)
    80001b0c:	0485bb83          	ld	s7,72(a1)
    80001b10:	0505bc03          	ld	s8,80(a1)
    80001b14:	0585bc83          	ld	s9,88(a1)
    80001b18:	0605bd03          	ld	s10,96(a1)
    80001b1c:	0685bd83          	ld	s11,104(a1)
    80001b20:	8082                	ret

0000000080001b22 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b22:	1141                	addi	sp,sp,-16
    80001b24:	e406                	sd	ra,8(sp)
    80001b26:	e022                	sd	s0,0(sp)
    80001b28:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b2a:	00007597          	auipc	a1,0x7
    80001b2e:	75e58593          	addi	a1,a1,1886 # 80009288 <states.0+0x30>
    80001b32:	0000e517          	auipc	a0,0xe
    80001b36:	cae50513          	addi	a0,a0,-850 # 8000f7e0 <tickslock>
    80001b3a:	00005097          	auipc	ra,0x5
    80001b3e:	548080e7          	jalr	1352(ra) # 80007082 <initlock>
}
    80001b42:	60a2                	ld	ra,8(sp)
    80001b44:	6402                	ld	s0,0(sp)
    80001b46:	0141                	addi	sp,sp,16
    80001b48:	8082                	ret

0000000080001b4a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b4a:	1141                	addi	sp,sp,-16
    80001b4c:	e422                	sd	s0,8(sp)
    80001b4e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b50:	00003797          	auipc	a5,0x3
    80001b54:	59078793          	addi	a5,a5,1424 # 800050e0 <kernelvec>
    80001b58:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b5c:	6422                	ld	s0,8(sp)
    80001b5e:	0141                	addi	sp,sp,16
    80001b60:	8082                	ret

0000000080001b62 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b62:	1141                	addi	sp,sp,-16
    80001b64:	e406                	sd	ra,8(sp)
    80001b66:	e022                	sd	s0,0(sp)
    80001b68:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b6a:	fffff097          	auipc	ra,0xfffff
    80001b6e:	342080e7          	jalr	834(ra) # 80000eac <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b72:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b76:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b78:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b7c:	00006697          	auipc	a3,0x6
    80001b80:	48468693          	addi	a3,a3,1156 # 80008000 <_trampoline>
    80001b84:	00006717          	auipc	a4,0x6
    80001b88:	47c70713          	addi	a4,a4,1148 # 80008000 <_trampoline>
    80001b8c:	8f15                	sub	a4,a4,a3
    80001b8e:	040007b7          	lui	a5,0x4000
    80001b92:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b94:	07b2                	slli	a5,a5,0xc
    80001b96:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b98:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b9c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b9e:	18002673          	csrr	a2,satp
    80001ba2:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001ba4:	6d30                	ld	a2,88(a0)
    80001ba6:	6138                	ld	a4,64(a0)
    80001ba8:	6585                	lui	a1,0x1
    80001baa:	972e                	add	a4,a4,a1
    80001bac:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bae:	6d38                	ld	a4,88(a0)
    80001bb0:	00000617          	auipc	a2,0x0
    80001bb4:	14260613          	addi	a2,a2,322 # 80001cf2 <usertrap>
    80001bb8:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bba:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bbc:	8612                	mv	a2,tp
    80001bbe:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bc0:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bc4:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bc8:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bcc:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bd0:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bd2:	6f18                	ld	a4,24(a4)
    80001bd4:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bd8:	6928                	ld	a0,80(a0)
    80001bda:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001bdc:	00006717          	auipc	a4,0x6
    80001be0:	4c070713          	addi	a4,a4,1216 # 8000809c <userret>
    80001be4:	8f15                	sub	a4,a4,a3
    80001be6:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001be8:	577d                	li	a4,-1
    80001bea:	177e                	slli	a4,a4,0x3f
    80001bec:	8d59                	or	a0,a0,a4
    80001bee:	9782                	jalr	a5
}
    80001bf0:	60a2                	ld	ra,8(sp)
    80001bf2:	6402                	ld	s0,0(sp)
    80001bf4:	0141                	addi	sp,sp,16
    80001bf6:	8082                	ret

0000000080001bf8 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bf8:	1101                	addi	sp,sp,-32
    80001bfa:	ec06                	sd	ra,24(sp)
    80001bfc:	e822                	sd	s0,16(sp)
    80001bfe:	e426                	sd	s1,8(sp)
    80001c00:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c02:	0000e497          	auipc	s1,0xe
    80001c06:	bde48493          	addi	s1,s1,-1058 # 8000f7e0 <tickslock>
    80001c0a:	8526                	mv	a0,s1
    80001c0c:	00005097          	auipc	ra,0x5
    80001c10:	506080e7          	jalr	1286(ra) # 80007112 <acquire>
  ticks++;
    80001c14:	00008517          	auipc	a0,0x8
    80001c18:	d4450513          	addi	a0,a0,-700 # 80009958 <ticks>
    80001c1c:	411c                	lw	a5,0(a0)
    80001c1e:	2785                	addiw	a5,a5,1
    80001c20:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c22:	00000097          	auipc	ra,0x0
    80001c26:	996080e7          	jalr	-1642(ra) # 800015b8 <wakeup>
  release(&tickslock);
    80001c2a:	8526                	mv	a0,s1
    80001c2c:	00005097          	auipc	ra,0x5
    80001c30:	59a080e7          	jalr	1434(ra) # 800071c6 <release>
}
    80001c34:	60e2                	ld	ra,24(sp)
    80001c36:	6442                	ld	s0,16(sp)
    80001c38:	64a2                	ld	s1,8(sp)
    80001c3a:	6105                	addi	sp,sp,32
    80001c3c:	8082                	ret

0000000080001c3e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c3e:	1101                	addi	sp,sp,-32
    80001c40:	ec06                	sd	ra,24(sp)
    80001c42:	e822                	sd	s0,16(sp)
    80001c44:	e426                	sd	s1,8(sp)
    80001c46:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c48:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c4c:	00074d63          	bltz	a4,80001c66 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c50:	57fd                	li	a5,-1
    80001c52:	17fe                	slli	a5,a5,0x3f
    80001c54:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c56:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c58:	06f70c63          	beq	a4,a5,80001cd0 <devintr+0x92>
  }
}
    80001c5c:	60e2                	ld	ra,24(sp)
    80001c5e:	6442                	ld	s0,16(sp)
    80001c60:	64a2                	ld	s1,8(sp)
    80001c62:	6105                	addi	sp,sp,32
    80001c64:	8082                	ret
     (scause & 0xff) == 9){
    80001c66:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001c6a:	46a5                	li	a3,9
    80001c6c:	fed792e3          	bne	a5,a3,80001c50 <devintr+0x12>
    int irq = plic_claim();
    80001c70:	00003097          	auipc	ra,0x3
    80001c74:	592080e7          	jalr	1426(ra) # 80005202 <plic_claim>
    80001c78:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c7a:	47a9                	li	a5,10
    80001c7c:	02f50563          	beq	a0,a5,80001ca6 <devintr+0x68>
    } else if(irq == VIRTIO0_IRQ){
    80001c80:	4785                	li	a5,1
    80001c82:	02f50d63          	beq	a0,a5,80001cbc <devintr+0x7e>
    else if(irq == E1000_IRQ){
    80001c86:	02100793          	li	a5,33
    80001c8a:	02f50e63          	beq	a0,a5,80001cc6 <devintr+0x88>
    return 1;
    80001c8e:	4505                	li	a0,1
    else if(irq){
    80001c90:	d4f1                	beqz	s1,80001c5c <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c92:	85a6                	mv	a1,s1
    80001c94:	00007517          	auipc	a0,0x7
    80001c98:	5fc50513          	addi	a0,a0,1532 # 80009290 <states.0+0x38>
    80001c9c:	00005097          	auipc	ra,0x5
    80001ca0:	f88080e7          	jalr	-120(ra) # 80006c24 <printf>
    80001ca4:	a029                	j	80001cae <devintr+0x70>
      uartintr();
    80001ca6:	00005097          	auipc	ra,0x5
    80001caa:	38c080e7          	jalr	908(ra) # 80007032 <uartintr>
      plic_complete(irq);
    80001cae:	8526                	mv	a0,s1
    80001cb0:	00003097          	auipc	ra,0x3
    80001cb4:	576080e7          	jalr	1398(ra) # 80005226 <plic_complete>
    return 1;
    80001cb8:	4505                	li	a0,1
    80001cba:	b74d                	j	80001c5c <devintr+0x1e>
      virtio_disk_intr();
    80001cbc:	00004097          	auipc	ra,0x4
    80001cc0:	a32080e7          	jalr	-1486(ra) # 800056ee <virtio_disk_intr>
    80001cc4:	b7ed                	j	80001cae <devintr+0x70>
      e1000_intr();
    80001cc6:	00004097          	auipc	ra,0x4
    80001cca:	d52080e7          	jalr	-686(ra) # 80005a18 <e1000_intr>
    80001cce:	b7c5                	j	80001cae <devintr+0x70>
    if(cpuid() == 0){
    80001cd0:	fffff097          	auipc	ra,0xfffff
    80001cd4:	1b0080e7          	jalr	432(ra) # 80000e80 <cpuid>
    80001cd8:	c901                	beqz	a0,80001ce8 <devintr+0xaa>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cda:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cde:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001ce0:	14479073          	csrw	sip,a5
    return 2;
    80001ce4:	4509                	li	a0,2
    80001ce6:	bf9d                	j	80001c5c <devintr+0x1e>
      clockintr();
    80001ce8:	00000097          	auipc	ra,0x0
    80001cec:	f10080e7          	jalr	-240(ra) # 80001bf8 <clockintr>
    80001cf0:	b7ed                	j	80001cda <devintr+0x9c>

0000000080001cf2 <usertrap>:
{
    80001cf2:	1101                	addi	sp,sp,-32
    80001cf4:	ec06                	sd	ra,24(sp)
    80001cf6:	e822                	sd	s0,16(sp)
    80001cf8:	e426                	sd	s1,8(sp)
    80001cfa:	e04a                	sd	s2,0(sp)
    80001cfc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cfe:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d02:	1007f793          	andi	a5,a5,256
    80001d06:	e3b1                	bnez	a5,80001d4a <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d08:	00003797          	auipc	a5,0x3
    80001d0c:	3d878793          	addi	a5,a5,984 # 800050e0 <kernelvec>
    80001d10:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d14:	fffff097          	auipc	ra,0xfffff
    80001d18:	198080e7          	jalr	408(ra) # 80000eac <myproc>
    80001d1c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d1e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d20:	14102773          	csrr	a4,sepc
    80001d24:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d26:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d2a:	47a1                	li	a5,8
    80001d2c:	02f70763          	beq	a4,a5,80001d5a <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001d30:	00000097          	auipc	ra,0x0
    80001d34:	f0e080e7          	jalr	-242(ra) # 80001c3e <devintr>
    80001d38:	892a                	mv	s2,a0
    80001d3a:	c151                	beqz	a0,80001dbe <usertrap+0xcc>
  if(killed(p))
    80001d3c:	8526                	mv	a0,s1
    80001d3e:	00000097          	auipc	ra,0x0
    80001d42:	abe080e7          	jalr	-1346(ra) # 800017fc <killed>
    80001d46:	c929                	beqz	a0,80001d98 <usertrap+0xa6>
    80001d48:	a099                	j	80001d8e <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001d4a:	00007517          	auipc	a0,0x7
    80001d4e:	56650513          	addi	a0,a0,1382 # 800092b0 <states.0+0x58>
    80001d52:	00005097          	auipc	ra,0x5
    80001d56:	e88080e7          	jalr	-376(ra) # 80006bda <panic>
    if(killed(p))
    80001d5a:	00000097          	auipc	ra,0x0
    80001d5e:	aa2080e7          	jalr	-1374(ra) # 800017fc <killed>
    80001d62:	e921                	bnez	a0,80001db2 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001d64:	6cb8                	ld	a4,88(s1)
    80001d66:	6f1c                	ld	a5,24(a4)
    80001d68:	0791                	addi	a5,a5,4
    80001d6a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d6c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d70:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d74:	10079073          	csrw	sstatus,a5
    syscall();
    80001d78:	00000097          	auipc	ra,0x0
    80001d7c:	2d4080e7          	jalr	724(ra) # 8000204c <syscall>
  if(killed(p))
    80001d80:	8526                	mv	a0,s1
    80001d82:	00000097          	auipc	ra,0x0
    80001d86:	a7a080e7          	jalr	-1414(ra) # 800017fc <killed>
    80001d8a:	c911                	beqz	a0,80001d9e <usertrap+0xac>
    80001d8c:	4901                	li	s2,0
    exit(-1);
    80001d8e:	557d                	li	a0,-1
    80001d90:	00000097          	auipc	ra,0x0
    80001d94:	8f8080e7          	jalr	-1800(ra) # 80001688 <exit>
  if(which_dev == 2)
    80001d98:	4789                	li	a5,2
    80001d9a:	04f90f63          	beq	s2,a5,80001df8 <usertrap+0x106>
  usertrapret();
    80001d9e:	00000097          	auipc	ra,0x0
    80001da2:	dc4080e7          	jalr	-572(ra) # 80001b62 <usertrapret>
}
    80001da6:	60e2                	ld	ra,24(sp)
    80001da8:	6442                	ld	s0,16(sp)
    80001daa:	64a2                	ld	s1,8(sp)
    80001dac:	6902                	ld	s2,0(sp)
    80001dae:	6105                	addi	sp,sp,32
    80001db0:	8082                	ret
      exit(-1);
    80001db2:	557d                	li	a0,-1
    80001db4:	00000097          	auipc	ra,0x0
    80001db8:	8d4080e7          	jalr	-1836(ra) # 80001688 <exit>
    80001dbc:	b765                	j	80001d64 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dbe:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001dc2:	5890                	lw	a2,48(s1)
    80001dc4:	00007517          	auipc	a0,0x7
    80001dc8:	50c50513          	addi	a0,a0,1292 # 800092d0 <states.0+0x78>
    80001dcc:	00005097          	auipc	ra,0x5
    80001dd0:	e58080e7          	jalr	-424(ra) # 80006c24 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dd4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dd8:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ddc:	00007517          	auipc	a0,0x7
    80001de0:	52450513          	addi	a0,a0,1316 # 80009300 <states.0+0xa8>
    80001de4:	00005097          	auipc	ra,0x5
    80001de8:	e40080e7          	jalr	-448(ra) # 80006c24 <printf>
    setkilled(p);
    80001dec:	8526                	mv	a0,s1
    80001dee:	00000097          	auipc	ra,0x0
    80001df2:	9e2080e7          	jalr	-1566(ra) # 800017d0 <setkilled>
    80001df6:	b769                	j	80001d80 <usertrap+0x8e>
    yield();
    80001df8:	fffff097          	auipc	ra,0xfffff
    80001dfc:	720080e7          	jalr	1824(ra) # 80001518 <yield>
    80001e00:	bf79                	j	80001d9e <usertrap+0xac>

0000000080001e02 <kerneltrap>:
{
    80001e02:	7179                	addi	sp,sp,-48
    80001e04:	f406                	sd	ra,40(sp)
    80001e06:	f022                	sd	s0,32(sp)
    80001e08:	ec26                	sd	s1,24(sp)
    80001e0a:	e84a                	sd	s2,16(sp)
    80001e0c:	e44e                	sd	s3,8(sp)
    80001e0e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e10:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e14:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e18:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e1c:	1004f793          	andi	a5,s1,256
    80001e20:	cb85                	beqz	a5,80001e50 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e22:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e26:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e28:	ef85                	bnez	a5,80001e60 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e2a:	00000097          	auipc	ra,0x0
    80001e2e:	e14080e7          	jalr	-492(ra) # 80001c3e <devintr>
    80001e32:	cd1d                	beqz	a0,80001e70 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e34:	4789                	li	a5,2
    80001e36:	06f50a63          	beq	a0,a5,80001eaa <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e3a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e3e:	10049073          	csrw	sstatus,s1
}
    80001e42:	70a2                	ld	ra,40(sp)
    80001e44:	7402                	ld	s0,32(sp)
    80001e46:	64e2                	ld	s1,24(sp)
    80001e48:	6942                	ld	s2,16(sp)
    80001e4a:	69a2                	ld	s3,8(sp)
    80001e4c:	6145                	addi	sp,sp,48
    80001e4e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e50:	00007517          	auipc	a0,0x7
    80001e54:	4d050513          	addi	a0,a0,1232 # 80009320 <states.0+0xc8>
    80001e58:	00005097          	auipc	ra,0x5
    80001e5c:	d82080e7          	jalr	-638(ra) # 80006bda <panic>
    panic("kerneltrap: interrupts enabled");
    80001e60:	00007517          	auipc	a0,0x7
    80001e64:	4e850513          	addi	a0,a0,1256 # 80009348 <states.0+0xf0>
    80001e68:	00005097          	auipc	ra,0x5
    80001e6c:	d72080e7          	jalr	-654(ra) # 80006bda <panic>
    printf("scause %p\n", scause);
    80001e70:	85ce                	mv	a1,s3
    80001e72:	00007517          	auipc	a0,0x7
    80001e76:	4f650513          	addi	a0,a0,1270 # 80009368 <states.0+0x110>
    80001e7a:	00005097          	auipc	ra,0x5
    80001e7e:	daa080e7          	jalr	-598(ra) # 80006c24 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e82:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e86:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e8a:	00007517          	auipc	a0,0x7
    80001e8e:	4ee50513          	addi	a0,a0,1262 # 80009378 <states.0+0x120>
    80001e92:	00005097          	auipc	ra,0x5
    80001e96:	d92080e7          	jalr	-622(ra) # 80006c24 <printf>
    panic("kerneltrap");
    80001e9a:	00007517          	auipc	a0,0x7
    80001e9e:	4f650513          	addi	a0,a0,1270 # 80009390 <states.0+0x138>
    80001ea2:	00005097          	auipc	ra,0x5
    80001ea6:	d38080e7          	jalr	-712(ra) # 80006bda <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001eaa:	fffff097          	auipc	ra,0xfffff
    80001eae:	002080e7          	jalr	2(ra) # 80000eac <myproc>
    80001eb2:	d541                	beqz	a0,80001e3a <kerneltrap+0x38>
    80001eb4:	fffff097          	auipc	ra,0xfffff
    80001eb8:	ff8080e7          	jalr	-8(ra) # 80000eac <myproc>
    80001ebc:	4d18                	lw	a4,24(a0)
    80001ebe:	4791                	li	a5,4
    80001ec0:	f6f71de3          	bne	a4,a5,80001e3a <kerneltrap+0x38>
    yield();
    80001ec4:	fffff097          	auipc	ra,0xfffff
    80001ec8:	654080e7          	jalr	1620(ra) # 80001518 <yield>
    80001ecc:	b7bd                	j	80001e3a <kerneltrap+0x38>

0000000080001ece <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ece:	1101                	addi	sp,sp,-32
    80001ed0:	ec06                	sd	ra,24(sp)
    80001ed2:	e822                	sd	s0,16(sp)
    80001ed4:	e426                	sd	s1,8(sp)
    80001ed6:	1000                	addi	s0,sp,32
    80001ed8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001eda:	fffff097          	auipc	ra,0xfffff
    80001ede:	fd2080e7          	jalr	-46(ra) # 80000eac <myproc>
  switch (n) {
    80001ee2:	4795                	li	a5,5
    80001ee4:	0497e163          	bltu	a5,s1,80001f26 <argraw+0x58>
    80001ee8:	048a                	slli	s1,s1,0x2
    80001eea:	00007717          	auipc	a4,0x7
    80001eee:	4de70713          	addi	a4,a4,1246 # 800093c8 <states.0+0x170>
    80001ef2:	94ba                	add	s1,s1,a4
    80001ef4:	409c                	lw	a5,0(s1)
    80001ef6:	97ba                	add	a5,a5,a4
    80001ef8:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001efa:	6d3c                	ld	a5,88(a0)
    80001efc:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001efe:	60e2                	ld	ra,24(sp)
    80001f00:	6442                	ld	s0,16(sp)
    80001f02:	64a2                	ld	s1,8(sp)
    80001f04:	6105                	addi	sp,sp,32
    80001f06:	8082                	ret
    return p->trapframe->a1;
    80001f08:	6d3c                	ld	a5,88(a0)
    80001f0a:	7fa8                	ld	a0,120(a5)
    80001f0c:	bfcd                	j	80001efe <argraw+0x30>
    return p->trapframe->a2;
    80001f0e:	6d3c                	ld	a5,88(a0)
    80001f10:	63c8                	ld	a0,128(a5)
    80001f12:	b7f5                	j	80001efe <argraw+0x30>
    return p->trapframe->a3;
    80001f14:	6d3c                	ld	a5,88(a0)
    80001f16:	67c8                	ld	a0,136(a5)
    80001f18:	b7dd                	j	80001efe <argraw+0x30>
    return p->trapframe->a4;
    80001f1a:	6d3c                	ld	a5,88(a0)
    80001f1c:	6bc8                	ld	a0,144(a5)
    80001f1e:	b7c5                	j	80001efe <argraw+0x30>
    return p->trapframe->a5;
    80001f20:	6d3c                	ld	a5,88(a0)
    80001f22:	6fc8                	ld	a0,152(a5)
    80001f24:	bfe9                	j	80001efe <argraw+0x30>
  panic("argraw");
    80001f26:	00007517          	auipc	a0,0x7
    80001f2a:	47a50513          	addi	a0,a0,1146 # 800093a0 <states.0+0x148>
    80001f2e:	00005097          	auipc	ra,0x5
    80001f32:	cac080e7          	jalr	-852(ra) # 80006bda <panic>

0000000080001f36 <fetchaddr>:
{
    80001f36:	1101                	addi	sp,sp,-32
    80001f38:	ec06                	sd	ra,24(sp)
    80001f3a:	e822                	sd	s0,16(sp)
    80001f3c:	e426                	sd	s1,8(sp)
    80001f3e:	e04a                	sd	s2,0(sp)
    80001f40:	1000                	addi	s0,sp,32
    80001f42:	84aa                	mv	s1,a0
    80001f44:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f46:	fffff097          	auipc	ra,0xfffff
    80001f4a:	f66080e7          	jalr	-154(ra) # 80000eac <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001f4e:	653c                	ld	a5,72(a0)
    80001f50:	02f4f863          	bgeu	s1,a5,80001f80 <fetchaddr+0x4a>
    80001f54:	00848713          	addi	a4,s1,8
    80001f58:	02e7e663          	bltu	a5,a4,80001f84 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f5c:	46a1                	li	a3,8
    80001f5e:	8626                	mv	a2,s1
    80001f60:	85ca                	mv	a1,s2
    80001f62:	6928                	ld	a0,80(a0)
    80001f64:	fffff097          	auipc	ra,0xfffff
    80001f68:	c98080e7          	jalr	-872(ra) # 80000bfc <copyin>
    80001f6c:	00a03533          	snez	a0,a0
    80001f70:	40a00533          	neg	a0,a0
}
    80001f74:	60e2                	ld	ra,24(sp)
    80001f76:	6442                	ld	s0,16(sp)
    80001f78:	64a2                	ld	s1,8(sp)
    80001f7a:	6902                	ld	s2,0(sp)
    80001f7c:	6105                	addi	sp,sp,32
    80001f7e:	8082                	ret
    return -1;
    80001f80:	557d                	li	a0,-1
    80001f82:	bfcd                	j	80001f74 <fetchaddr+0x3e>
    80001f84:	557d                	li	a0,-1
    80001f86:	b7fd                	j	80001f74 <fetchaddr+0x3e>

0000000080001f88 <fetchstr>:
{
    80001f88:	7179                	addi	sp,sp,-48
    80001f8a:	f406                	sd	ra,40(sp)
    80001f8c:	f022                	sd	s0,32(sp)
    80001f8e:	ec26                	sd	s1,24(sp)
    80001f90:	e84a                	sd	s2,16(sp)
    80001f92:	e44e                	sd	s3,8(sp)
    80001f94:	1800                	addi	s0,sp,48
    80001f96:	892a                	mv	s2,a0
    80001f98:	84ae                	mv	s1,a1
    80001f9a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f9c:	fffff097          	auipc	ra,0xfffff
    80001fa0:	f10080e7          	jalr	-240(ra) # 80000eac <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001fa4:	86ce                	mv	a3,s3
    80001fa6:	864a                	mv	a2,s2
    80001fa8:	85a6                	mv	a1,s1
    80001faa:	6928                	ld	a0,80(a0)
    80001fac:	fffff097          	auipc	ra,0xfffff
    80001fb0:	cde080e7          	jalr	-802(ra) # 80000c8a <copyinstr>
    80001fb4:	00054e63          	bltz	a0,80001fd0 <fetchstr+0x48>
  return strlen(buf);
    80001fb8:	8526                	mv	a0,s1
    80001fba:	ffffe097          	auipc	ra,0xffffe
    80001fbe:	33c080e7          	jalr	828(ra) # 800002f6 <strlen>
}
    80001fc2:	70a2                	ld	ra,40(sp)
    80001fc4:	7402                	ld	s0,32(sp)
    80001fc6:	64e2                	ld	s1,24(sp)
    80001fc8:	6942                	ld	s2,16(sp)
    80001fca:	69a2                	ld	s3,8(sp)
    80001fcc:	6145                	addi	sp,sp,48
    80001fce:	8082                	ret
    return -1;
    80001fd0:	557d                	li	a0,-1
    80001fd2:	bfc5                	j	80001fc2 <fetchstr+0x3a>

0000000080001fd4 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001fd4:	1101                	addi	sp,sp,-32
    80001fd6:	ec06                	sd	ra,24(sp)
    80001fd8:	e822                	sd	s0,16(sp)
    80001fda:	e426                	sd	s1,8(sp)
    80001fdc:	1000                	addi	s0,sp,32
    80001fde:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fe0:	00000097          	auipc	ra,0x0
    80001fe4:	eee080e7          	jalr	-274(ra) # 80001ece <argraw>
    80001fe8:	c088                	sw	a0,0(s1)
}
    80001fea:	60e2                	ld	ra,24(sp)
    80001fec:	6442                	ld	s0,16(sp)
    80001fee:	64a2                	ld	s1,8(sp)
    80001ff0:	6105                	addi	sp,sp,32
    80001ff2:	8082                	ret

0000000080001ff4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001ff4:	1101                	addi	sp,sp,-32
    80001ff6:	ec06                	sd	ra,24(sp)
    80001ff8:	e822                	sd	s0,16(sp)
    80001ffa:	e426                	sd	s1,8(sp)
    80001ffc:	1000                	addi	s0,sp,32
    80001ffe:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002000:	00000097          	auipc	ra,0x0
    80002004:	ece080e7          	jalr	-306(ra) # 80001ece <argraw>
    80002008:	e088                	sd	a0,0(s1)
}
    8000200a:	60e2                	ld	ra,24(sp)
    8000200c:	6442                	ld	s0,16(sp)
    8000200e:	64a2                	ld	s1,8(sp)
    80002010:	6105                	addi	sp,sp,32
    80002012:	8082                	ret

0000000080002014 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002014:	7179                	addi	sp,sp,-48
    80002016:	f406                	sd	ra,40(sp)
    80002018:	f022                	sd	s0,32(sp)
    8000201a:	ec26                	sd	s1,24(sp)
    8000201c:	e84a                	sd	s2,16(sp)
    8000201e:	1800                	addi	s0,sp,48
    80002020:	84ae                	mv	s1,a1
    80002022:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002024:	fd840593          	addi	a1,s0,-40
    80002028:	00000097          	auipc	ra,0x0
    8000202c:	fcc080e7          	jalr	-52(ra) # 80001ff4 <argaddr>
  return fetchstr(addr, buf, max);
    80002030:	864a                	mv	a2,s2
    80002032:	85a6                	mv	a1,s1
    80002034:	fd843503          	ld	a0,-40(s0)
    80002038:	00000097          	auipc	ra,0x0
    8000203c:	f50080e7          	jalr	-176(ra) # 80001f88 <fetchstr>
}
    80002040:	70a2                	ld	ra,40(sp)
    80002042:	7402                	ld	s0,32(sp)
    80002044:	64e2                	ld	s1,24(sp)
    80002046:	6942                	ld	s2,16(sp)
    80002048:	6145                	addi	sp,sp,48
    8000204a:	8082                	ret

000000008000204c <syscall>:



void
syscall(void)
{
    8000204c:	1101                	addi	sp,sp,-32
    8000204e:	ec06                	sd	ra,24(sp)
    80002050:	e822                	sd	s0,16(sp)
    80002052:	e426                	sd	s1,8(sp)
    80002054:	e04a                	sd	s2,0(sp)
    80002056:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002058:	fffff097          	auipc	ra,0xfffff
    8000205c:	e54080e7          	jalr	-428(ra) # 80000eac <myproc>
    80002060:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002062:	05853903          	ld	s2,88(a0)
    80002066:	0a893783          	ld	a5,168(s2)
    8000206a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000206e:	37fd                	addiw	a5,a5,-1
    80002070:	4771                	li	a4,28
    80002072:	00f76f63          	bltu	a4,a5,80002090 <syscall+0x44>
    80002076:	00369713          	slli	a4,a3,0x3
    8000207a:	00007797          	auipc	a5,0x7
    8000207e:	36678793          	addi	a5,a5,870 # 800093e0 <syscalls>
    80002082:	97ba                	add	a5,a5,a4
    80002084:	639c                	ld	a5,0(a5)
    80002086:	c789                	beqz	a5,80002090 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002088:	9782                	jalr	a5
    8000208a:	06a93823          	sd	a0,112(s2)
    8000208e:	a839                	j	800020ac <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002090:	15848613          	addi	a2,s1,344
    80002094:	588c                	lw	a1,48(s1)
    80002096:	00007517          	auipc	a0,0x7
    8000209a:	31250513          	addi	a0,a0,786 # 800093a8 <states.0+0x150>
    8000209e:	00005097          	auipc	ra,0x5
    800020a2:	b86080e7          	jalr	-1146(ra) # 80006c24 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020a6:	6cbc                	ld	a5,88(s1)
    800020a8:	577d                	li	a4,-1
    800020aa:	fbb8                	sd	a4,112(a5)
  }
}
    800020ac:	60e2                	ld	ra,24(sp)
    800020ae:	6442                	ld	s0,16(sp)
    800020b0:	64a2                	ld	s1,8(sp)
    800020b2:	6902                	ld	s2,0(sp)
    800020b4:	6105                	addi	sp,sp,32
    800020b6:	8082                	ret

00000000800020b8 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800020b8:	1101                	addi	sp,sp,-32
    800020ba:	ec06                	sd	ra,24(sp)
    800020bc:	e822                	sd	s0,16(sp)
    800020be:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800020c0:	fec40593          	addi	a1,s0,-20
    800020c4:	4501                	li	a0,0
    800020c6:	00000097          	auipc	ra,0x0
    800020ca:	f0e080e7          	jalr	-242(ra) # 80001fd4 <argint>
  exit(n);
    800020ce:	fec42503          	lw	a0,-20(s0)
    800020d2:	fffff097          	auipc	ra,0xfffff
    800020d6:	5b6080e7          	jalr	1462(ra) # 80001688 <exit>
  return 0;  // not reached
}
    800020da:	4501                	li	a0,0
    800020dc:	60e2                	ld	ra,24(sp)
    800020de:	6442                	ld	s0,16(sp)
    800020e0:	6105                	addi	sp,sp,32
    800020e2:	8082                	ret

00000000800020e4 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020e4:	1141                	addi	sp,sp,-16
    800020e6:	e406                	sd	ra,8(sp)
    800020e8:	e022                	sd	s0,0(sp)
    800020ea:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020ec:	fffff097          	auipc	ra,0xfffff
    800020f0:	dc0080e7          	jalr	-576(ra) # 80000eac <myproc>
}
    800020f4:	5908                	lw	a0,48(a0)
    800020f6:	60a2                	ld	ra,8(sp)
    800020f8:	6402                	ld	s0,0(sp)
    800020fa:	0141                	addi	sp,sp,16
    800020fc:	8082                	ret

00000000800020fe <sys_fork>:

uint64
sys_fork(void)
{
    800020fe:	1141                	addi	sp,sp,-16
    80002100:	e406                	sd	ra,8(sp)
    80002102:	e022                	sd	s0,0(sp)
    80002104:	0800                	addi	s0,sp,16
  return fork();
    80002106:	fffff097          	auipc	ra,0xfffff
    8000210a:	15c080e7          	jalr	348(ra) # 80001262 <fork>
}
    8000210e:	60a2                	ld	ra,8(sp)
    80002110:	6402                	ld	s0,0(sp)
    80002112:	0141                	addi	sp,sp,16
    80002114:	8082                	ret

0000000080002116 <sys_wait>:

uint64
sys_wait(void)
{
    80002116:	1101                	addi	sp,sp,-32
    80002118:	ec06                	sd	ra,24(sp)
    8000211a:	e822                	sd	s0,16(sp)
    8000211c:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000211e:	fe840593          	addi	a1,s0,-24
    80002122:	4501                	li	a0,0
    80002124:	00000097          	auipc	ra,0x0
    80002128:	ed0080e7          	jalr	-304(ra) # 80001ff4 <argaddr>
  return wait(p);
    8000212c:	fe843503          	ld	a0,-24(s0)
    80002130:	fffff097          	auipc	ra,0xfffff
    80002134:	6fe080e7          	jalr	1790(ra) # 8000182e <wait>
}
    80002138:	60e2                	ld	ra,24(sp)
    8000213a:	6442                	ld	s0,16(sp)
    8000213c:	6105                	addi	sp,sp,32
    8000213e:	8082                	ret

0000000080002140 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002140:	7179                	addi	sp,sp,-48
    80002142:	f406                	sd	ra,40(sp)
    80002144:	f022                	sd	s0,32(sp)
    80002146:	ec26                	sd	s1,24(sp)
    80002148:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000214a:	fdc40593          	addi	a1,s0,-36
    8000214e:	4501                	li	a0,0
    80002150:	00000097          	auipc	ra,0x0
    80002154:	e84080e7          	jalr	-380(ra) # 80001fd4 <argint>
  addr = myproc()->sz;
    80002158:	fffff097          	auipc	ra,0xfffff
    8000215c:	d54080e7          	jalr	-684(ra) # 80000eac <myproc>
    80002160:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002162:	fdc42503          	lw	a0,-36(s0)
    80002166:	fffff097          	auipc	ra,0xfffff
    8000216a:	0a0080e7          	jalr	160(ra) # 80001206 <growproc>
    8000216e:	00054863          	bltz	a0,8000217e <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002172:	8526                	mv	a0,s1
    80002174:	70a2                	ld	ra,40(sp)
    80002176:	7402                	ld	s0,32(sp)
    80002178:	64e2                	ld	s1,24(sp)
    8000217a:	6145                	addi	sp,sp,48
    8000217c:	8082                	ret
    return -1;
    8000217e:	54fd                	li	s1,-1
    80002180:	bfcd                	j	80002172 <sys_sbrk+0x32>

0000000080002182 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002182:	7139                	addi	sp,sp,-64
    80002184:	fc06                	sd	ra,56(sp)
    80002186:	f822                	sd	s0,48(sp)
    80002188:	f426                	sd	s1,40(sp)
    8000218a:	f04a                	sd	s2,32(sp)
    8000218c:	ec4e                	sd	s3,24(sp)
    8000218e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002190:	fcc40593          	addi	a1,s0,-52
    80002194:	4501                	li	a0,0
    80002196:	00000097          	auipc	ra,0x0
    8000219a:	e3e080e7          	jalr	-450(ra) # 80001fd4 <argint>
  if(n < 0)
    8000219e:	fcc42783          	lw	a5,-52(s0)
    800021a2:	0607cf63          	bltz	a5,80002220 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    800021a6:	0000d517          	auipc	a0,0xd
    800021aa:	63a50513          	addi	a0,a0,1594 # 8000f7e0 <tickslock>
    800021ae:	00005097          	auipc	ra,0x5
    800021b2:	f64080e7          	jalr	-156(ra) # 80007112 <acquire>
  ticks0 = ticks;
    800021b6:	00007917          	auipc	s2,0x7
    800021ba:	7a292903          	lw	s2,1954(s2) # 80009958 <ticks>
  while(ticks - ticks0 < n){
    800021be:	fcc42783          	lw	a5,-52(s0)
    800021c2:	cf9d                	beqz	a5,80002200 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021c4:	0000d997          	auipc	s3,0xd
    800021c8:	61c98993          	addi	s3,s3,1564 # 8000f7e0 <tickslock>
    800021cc:	00007497          	auipc	s1,0x7
    800021d0:	78c48493          	addi	s1,s1,1932 # 80009958 <ticks>
    if(killed(myproc())){
    800021d4:	fffff097          	auipc	ra,0xfffff
    800021d8:	cd8080e7          	jalr	-808(ra) # 80000eac <myproc>
    800021dc:	fffff097          	auipc	ra,0xfffff
    800021e0:	620080e7          	jalr	1568(ra) # 800017fc <killed>
    800021e4:	e129                	bnez	a0,80002226 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    800021e6:	85ce                	mv	a1,s3
    800021e8:	8526                	mv	a0,s1
    800021ea:	fffff097          	auipc	ra,0xfffff
    800021ee:	36a080e7          	jalr	874(ra) # 80001554 <sleep>
  while(ticks - ticks0 < n){
    800021f2:	409c                	lw	a5,0(s1)
    800021f4:	412787bb          	subw	a5,a5,s2
    800021f8:	fcc42703          	lw	a4,-52(s0)
    800021fc:	fce7ece3          	bltu	a5,a4,800021d4 <sys_sleep+0x52>
  }
  release(&tickslock);
    80002200:	0000d517          	auipc	a0,0xd
    80002204:	5e050513          	addi	a0,a0,1504 # 8000f7e0 <tickslock>
    80002208:	00005097          	auipc	ra,0x5
    8000220c:	fbe080e7          	jalr	-66(ra) # 800071c6 <release>
  return 0;
    80002210:	4501                	li	a0,0
}
    80002212:	70e2                	ld	ra,56(sp)
    80002214:	7442                	ld	s0,48(sp)
    80002216:	74a2                	ld	s1,40(sp)
    80002218:	7902                	ld	s2,32(sp)
    8000221a:	69e2                	ld	s3,24(sp)
    8000221c:	6121                	addi	sp,sp,64
    8000221e:	8082                	ret
    n = 0;
    80002220:	fc042623          	sw	zero,-52(s0)
    80002224:	b749                	j	800021a6 <sys_sleep+0x24>
      release(&tickslock);
    80002226:	0000d517          	auipc	a0,0xd
    8000222a:	5ba50513          	addi	a0,a0,1466 # 8000f7e0 <tickslock>
    8000222e:	00005097          	auipc	ra,0x5
    80002232:	f98080e7          	jalr	-104(ra) # 800071c6 <release>
      return -1;
    80002236:	557d                	li	a0,-1
    80002238:	bfe9                	j	80002212 <sys_sleep+0x90>

000000008000223a <sys_kill>:

uint64
sys_kill(void)
{
    8000223a:	1101                	addi	sp,sp,-32
    8000223c:	ec06                	sd	ra,24(sp)
    8000223e:	e822                	sd	s0,16(sp)
    80002240:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002242:	fec40593          	addi	a1,s0,-20
    80002246:	4501                	li	a0,0
    80002248:	00000097          	auipc	ra,0x0
    8000224c:	d8c080e7          	jalr	-628(ra) # 80001fd4 <argint>
  return kill(pid);
    80002250:	fec42503          	lw	a0,-20(s0)
    80002254:	fffff097          	auipc	ra,0xfffff
    80002258:	50a080e7          	jalr	1290(ra) # 8000175e <kill>
}
    8000225c:	60e2                	ld	ra,24(sp)
    8000225e:	6442                	ld	s0,16(sp)
    80002260:	6105                	addi	sp,sp,32
    80002262:	8082                	ret

0000000080002264 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002264:	1101                	addi	sp,sp,-32
    80002266:	ec06                	sd	ra,24(sp)
    80002268:	e822                	sd	s0,16(sp)
    8000226a:	e426                	sd	s1,8(sp)
    8000226c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000226e:	0000d517          	auipc	a0,0xd
    80002272:	57250513          	addi	a0,a0,1394 # 8000f7e0 <tickslock>
    80002276:	00005097          	auipc	ra,0x5
    8000227a:	e9c080e7          	jalr	-356(ra) # 80007112 <acquire>
  xticks = ticks;
    8000227e:	00007497          	auipc	s1,0x7
    80002282:	6da4a483          	lw	s1,1754(s1) # 80009958 <ticks>
  release(&tickslock);
    80002286:	0000d517          	auipc	a0,0xd
    8000228a:	55a50513          	addi	a0,a0,1370 # 8000f7e0 <tickslock>
    8000228e:	00005097          	auipc	ra,0x5
    80002292:	f38080e7          	jalr	-200(ra) # 800071c6 <release>
  return xticks;
}
    80002296:	02049513          	slli	a0,s1,0x20
    8000229a:	9101                	srli	a0,a0,0x20
    8000229c:	60e2                	ld	ra,24(sp)
    8000229e:	6442                	ld	s0,16(sp)
    800022a0:	64a2                	ld	s1,8(sp)
    800022a2:	6105                	addi	sp,sp,32
    800022a4:	8082                	ret

00000000800022a6 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800022a6:	7179                	addi	sp,sp,-48
    800022a8:	f406                	sd	ra,40(sp)
    800022aa:	f022                	sd	s0,32(sp)
    800022ac:	ec26                	sd	s1,24(sp)
    800022ae:	e84a                	sd	s2,16(sp)
    800022b0:	e44e                	sd	s3,8(sp)
    800022b2:	e052                	sd	s4,0(sp)
    800022b4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800022b6:	00007597          	auipc	a1,0x7
    800022ba:	21a58593          	addi	a1,a1,538 # 800094d0 <syscalls+0xf0>
    800022be:	0000d517          	auipc	a0,0xd
    800022c2:	53a50513          	addi	a0,a0,1338 # 8000f7f8 <bcache>
    800022c6:	00005097          	auipc	ra,0x5
    800022ca:	dbc080e7          	jalr	-580(ra) # 80007082 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800022ce:	00015797          	auipc	a5,0x15
    800022d2:	52a78793          	addi	a5,a5,1322 # 800177f8 <bcache+0x8000>
    800022d6:	00015717          	auipc	a4,0x15
    800022da:	78a70713          	addi	a4,a4,1930 # 80017a60 <bcache+0x8268>
    800022de:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800022e2:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022e6:	0000d497          	auipc	s1,0xd
    800022ea:	52a48493          	addi	s1,s1,1322 # 8000f810 <bcache+0x18>
    b->next = bcache.head.next;
    800022ee:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800022f0:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800022f2:	00007a17          	auipc	s4,0x7
    800022f6:	1e6a0a13          	addi	s4,s4,486 # 800094d8 <syscalls+0xf8>
    b->next = bcache.head.next;
    800022fa:	2b893783          	ld	a5,696(s2)
    800022fe:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002300:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002304:	85d2                	mv	a1,s4
    80002306:	01048513          	addi	a0,s1,16
    8000230a:	00001097          	auipc	ra,0x1
    8000230e:	4c8080e7          	jalr	1224(ra) # 800037d2 <initsleeplock>
    bcache.head.next->prev = b;
    80002312:	2b893783          	ld	a5,696(s2)
    80002316:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002318:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000231c:	45848493          	addi	s1,s1,1112
    80002320:	fd349de3          	bne	s1,s3,800022fa <binit+0x54>
  }
}
    80002324:	70a2                	ld	ra,40(sp)
    80002326:	7402                	ld	s0,32(sp)
    80002328:	64e2                	ld	s1,24(sp)
    8000232a:	6942                	ld	s2,16(sp)
    8000232c:	69a2                	ld	s3,8(sp)
    8000232e:	6a02                	ld	s4,0(sp)
    80002330:	6145                	addi	sp,sp,48
    80002332:	8082                	ret

0000000080002334 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002334:	7179                	addi	sp,sp,-48
    80002336:	f406                	sd	ra,40(sp)
    80002338:	f022                	sd	s0,32(sp)
    8000233a:	ec26                	sd	s1,24(sp)
    8000233c:	e84a                	sd	s2,16(sp)
    8000233e:	e44e                	sd	s3,8(sp)
    80002340:	1800                	addi	s0,sp,48
    80002342:	892a                	mv	s2,a0
    80002344:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002346:	0000d517          	auipc	a0,0xd
    8000234a:	4b250513          	addi	a0,a0,1202 # 8000f7f8 <bcache>
    8000234e:	00005097          	auipc	ra,0x5
    80002352:	dc4080e7          	jalr	-572(ra) # 80007112 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002356:	00015497          	auipc	s1,0x15
    8000235a:	75a4b483          	ld	s1,1882(s1) # 80017ab0 <bcache+0x82b8>
    8000235e:	00015797          	auipc	a5,0x15
    80002362:	70278793          	addi	a5,a5,1794 # 80017a60 <bcache+0x8268>
    80002366:	02f48f63          	beq	s1,a5,800023a4 <bread+0x70>
    8000236a:	873e                	mv	a4,a5
    8000236c:	a021                	j	80002374 <bread+0x40>
    8000236e:	68a4                	ld	s1,80(s1)
    80002370:	02e48a63          	beq	s1,a4,800023a4 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002374:	449c                	lw	a5,8(s1)
    80002376:	ff279ce3          	bne	a5,s2,8000236e <bread+0x3a>
    8000237a:	44dc                	lw	a5,12(s1)
    8000237c:	ff3799e3          	bne	a5,s3,8000236e <bread+0x3a>
      b->refcnt++;
    80002380:	40bc                	lw	a5,64(s1)
    80002382:	2785                	addiw	a5,a5,1
    80002384:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002386:	0000d517          	auipc	a0,0xd
    8000238a:	47250513          	addi	a0,a0,1138 # 8000f7f8 <bcache>
    8000238e:	00005097          	auipc	ra,0x5
    80002392:	e38080e7          	jalr	-456(ra) # 800071c6 <release>
      acquiresleep(&b->lock);
    80002396:	01048513          	addi	a0,s1,16
    8000239a:	00001097          	auipc	ra,0x1
    8000239e:	472080e7          	jalr	1138(ra) # 8000380c <acquiresleep>
      return b;
    800023a2:	a8b9                	j	80002400 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023a4:	00015497          	auipc	s1,0x15
    800023a8:	7044b483          	ld	s1,1796(s1) # 80017aa8 <bcache+0x82b0>
    800023ac:	00015797          	auipc	a5,0x15
    800023b0:	6b478793          	addi	a5,a5,1716 # 80017a60 <bcache+0x8268>
    800023b4:	00f48863          	beq	s1,a5,800023c4 <bread+0x90>
    800023b8:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800023ba:	40bc                	lw	a5,64(s1)
    800023bc:	cf81                	beqz	a5,800023d4 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023be:	64a4                	ld	s1,72(s1)
    800023c0:	fee49de3          	bne	s1,a4,800023ba <bread+0x86>
  panic("bget: no buffers");
    800023c4:	00007517          	auipc	a0,0x7
    800023c8:	11c50513          	addi	a0,a0,284 # 800094e0 <syscalls+0x100>
    800023cc:	00005097          	auipc	ra,0x5
    800023d0:	80e080e7          	jalr	-2034(ra) # 80006bda <panic>
      b->dev = dev;
    800023d4:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800023d8:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800023dc:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800023e0:	4785                	li	a5,1
    800023e2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023e4:	0000d517          	auipc	a0,0xd
    800023e8:	41450513          	addi	a0,a0,1044 # 8000f7f8 <bcache>
    800023ec:	00005097          	auipc	ra,0x5
    800023f0:	dda080e7          	jalr	-550(ra) # 800071c6 <release>
      acquiresleep(&b->lock);
    800023f4:	01048513          	addi	a0,s1,16
    800023f8:	00001097          	auipc	ra,0x1
    800023fc:	414080e7          	jalr	1044(ra) # 8000380c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002400:	409c                	lw	a5,0(s1)
    80002402:	cb89                	beqz	a5,80002414 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002404:	8526                	mv	a0,s1
    80002406:	70a2                	ld	ra,40(sp)
    80002408:	7402                	ld	s0,32(sp)
    8000240a:	64e2                	ld	s1,24(sp)
    8000240c:	6942                	ld	s2,16(sp)
    8000240e:	69a2                	ld	s3,8(sp)
    80002410:	6145                	addi	sp,sp,48
    80002412:	8082                	ret
    virtio_disk_rw(b, 0);
    80002414:	4581                	li	a1,0
    80002416:	8526                	mv	a0,s1
    80002418:	00003097          	auipc	ra,0x3
    8000241c:	0a4080e7          	jalr	164(ra) # 800054bc <virtio_disk_rw>
    b->valid = 1;
    80002420:	4785                	li	a5,1
    80002422:	c09c                	sw	a5,0(s1)
  return b;
    80002424:	b7c5                	j	80002404 <bread+0xd0>

0000000080002426 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002426:	1101                	addi	sp,sp,-32
    80002428:	ec06                	sd	ra,24(sp)
    8000242a:	e822                	sd	s0,16(sp)
    8000242c:	e426                	sd	s1,8(sp)
    8000242e:	1000                	addi	s0,sp,32
    80002430:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002432:	0541                	addi	a0,a0,16
    80002434:	00001097          	auipc	ra,0x1
    80002438:	472080e7          	jalr	1138(ra) # 800038a6 <holdingsleep>
    8000243c:	cd01                	beqz	a0,80002454 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000243e:	4585                	li	a1,1
    80002440:	8526                	mv	a0,s1
    80002442:	00003097          	auipc	ra,0x3
    80002446:	07a080e7          	jalr	122(ra) # 800054bc <virtio_disk_rw>
}
    8000244a:	60e2                	ld	ra,24(sp)
    8000244c:	6442                	ld	s0,16(sp)
    8000244e:	64a2                	ld	s1,8(sp)
    80002450:	6105                	addi	sp,sp,32
    80002452:	8082                	ret
    panic("bwrite");
    80002454:	00007517          	auipc	a0,0x7
    80002458:	0a450513          	addi	a0,a0,164 # 800094f8 <syscalls+0x118>
    8000245c:	00004097          	auipc	ra,0x4
    80002460:	77e080e7          	jalr	1918(ra) # 80006bda <panic>

0000000080002464 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002464:	1101                	addi	sp,sp,-32
    80002466:	ec06                	sd	ra,24(sp)
    80002468:	e822                	sd	s0,16(sp)
    8000246a:	e426                	sd	s1,8(sp)
    8000246c:	e04a                	sd	s2,0(sp)
    8000246e:	1000                	addi	s0,sp,32
    80002470:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002472:	01050913          	addi	s2,a0,16
    80002476:	854a                	mv	a0,s2
    80002478:	00001097          	auipc	ra,0x1
    8000247c:	42e080e7          	jalr	1070(ra) # 800038a6 <holdingsleep>
    80002480:	c92d                	beqz	a0,800024f2 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002482:	854a                	mv	a0,s2
    80002484:	00001097          	auipc	ra,0x1
    80002488:	3de080e7          	jalr	990(ra) # 80003862 <releasesleep>

  acquire(&bcache.lock);
    8000248c:	0000d517          	auipc	a0,0xd
    80002490:	36c50513          	addi	a0,a0,876 # 8000f7f8 <bcache>
    80002494:	00005097          	auipc	ra,0x5
    80002498:	c7e080e7          	jalr	-898(ra) # 80007112 <acquire>
  b->refcnt--;
    8000249c:	40bc                	lw	a5,64(s1)
    8000249e:	37fd                	addiw	a5,a5,-1
    800024a0:	0007871b          	sext.w	a4,a5
    800024a4:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800024a6:	eb05                	bnez	a4,800024d6 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800024a8:	68bc                	ld	a5,80(s1)
    800024aa:	64b8                	ld	a4,72(s1)
    800024ac:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800024ae:	64bc                	ld	a5,72(s1)
    800024b0:	68b8                	ld	a4,80(s1)
    800024b2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800024b4:	00015797          	auipc	a5,0x15
    800024b8:	34478793          	addi	a5,a5,836 # 800177f8 <bcache+0x8000>
    800024bc:	2b87b703          	ld	a4,696(a5)
    800024c0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800024c2:	00015717          	auipc	a4,0x15
    800024c6:	59e70713          	addi	a4,a4,1438 # 80017a60 <bcache+0x8268>
    800024ca:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800024cc:	2b87b703          	ld	a4,696(a5)
    800024d0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800024d2:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800024d6:	0000d517          	auipc	a0,0xd
    800024da:	32250513          	addi	a0,a0,802 # 8000f7f8 <bcache>
    800024de:	00005097          	auipc	ra,0x5
    800024e2:	ce8080e7          	jalr	-792(ra) # 800071c6 <release>
}
    800024e6:	60e2                	ld	ra,24(sp)
    800024e8:	6442                	ld	s0,16(sp)
    800024ea:	64a2                	ld	s1,8(sp)
    800024ec:	6902                	ld	s2,0(sp)
    800024ee:	6105                	addi	sp,sp,32
    800024f0:	8082                	ret
    panic("brelse");
    800024f2:	00007517          	auipc	a0,0x7
    800024f6:	00e50513          	addi	a0,a0,14 # 80009500 <syscalls+0x120>
    800024fa:	00004097          	auipc	ra,0x4
    800024fe:	6e0080e7          	jalr	1760(ra) # 80006bda <panic>

0000000080002502 <bpin>:

void
bpin(struct buf *b) {
    80002502:	1101                	addi	sp,sp,-32
    80002504:	ec06                	sd	ra,24(sp)
    80002506:	e822                	sd	s0,16(sp)
    80002508:	e426                	sd	s1,8(sp)
    8000250a:	1000                	addi	s0,sp,32
    8000250c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000250e:	0000d517          	auipc	a0,0xd
    80002512:	2ea50513          	addi	a0,a0,746 # 8000f7f8 <bcache>
    80002516:	00005097          	auipc	ra,0x5
    8000251a:	bfc080e7          	jalr	-1028(ra) # 80007112 <acquire>
  b->refcnt++;
    8000251e:	40bc                	lw	a5,64(s1)
    80002520:	2785                	addiw	a5,a5,1
    80002522:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002524:	0000d517          	auipc	a0,0xd
    80002528:	2d450513          	addi	a0,a0,724 # 8000f7f8 <bcache>
    8000252c:	00005097          	auipc	ra,0x5
    80002530:	c9a080e7          	jalr	-870(ra) # 800071c6 <release>
}
    80002534:	60e2                	ld	ra,24(sp)
    80002536:	6442                	ld	s0,16(sp)
    80002538:	64a2                	ld	s1,8(sp)
    8000253a:	6105                	addi	sp,sp,32
    8000253c:	8082                	ret

000000008000253e <bunpin>:

void
bunpin(struct buf *b) {
    8000253e:	1101                	addi	sp,sp,-32
    80002540:	ec06                	sd	ra,24(sp)
    80002542:	e822                	sd	s0,16(sp)
    80002544:	e426                	sd	s1,8(sp)
    80002546:	1000                	addi	s0,sp,32
    80002548:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000254a:	0000d517          	auipc	a0,0xd
    8000254e:	2ae50513          	addi	a0,a0,686 # 8000f7f8 <bcache>
    80002552:	00005097          	auipc	ra,0x5
    80002556:	bc0080e7          	jalr	-1088(ra) # 80007112 <acquire>
  b->refcnt--;
    8000255a:	40bc                	lw	a5,64(s1)
    8000255c:	37fd                	addiw	a5,a5,-1
    8000255e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002560:	0000d517          	auipc	a0,0xd
    80002564:	29850513          	addi	a0,a0,664 # 8000f7f8 <bcache>
    80002568:	00005097          	auipc	ra,0x5
    8000256c:	c5e080e7          	jalr	-930(ra) # 800071c6 <release>
}
    80002570:	60e2                	ld	ra,24(sp)
    80002572:	6442                	ld	s0,16(sp)
    80002574:	64a2                	ld	s1,8(sp)
    80002576:	6105                	addi	sp,sp,32
    80002578:	8082                	ret

000000008000257a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000257a:	1101                	addi	sp,sp,-32
    8000257c:	ec06                	sd	ra,24(sp)
    8000257e:	e822                	sd	s0,16(sp)
    80002580:	e426                	sd	s1,8(sp)
    80002582:	e04a                	sd	s2,0(sp)
    80002584:	1000                	addi	s0,sp,32
    80002586:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002588:	00d5d59b          	srliw	a1,a1,0xd
    8000258c:	00016797          	auipc	a5,0x16
    80002590:	9487a783          	lw	a5,-1720(a5) # 80017ed4 <sb+0x1c>
    80002594:	9dbd                	addw	a1,a1,a5
    80002596:	00000097          	auipc	ra,0x0
    8000259a:	d9e080e7          	jalr	-610(ra) # 80002334 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000259e:	0074f713          	andi	a4,s1,7
    800025a2:	4785                	li	a5,1
    800025a4:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800025a8:	14ce                	slli	s1,s1,0x33
    800025aa:	90d9                	srli	s1,s1,0x36
    800025ac:	00950733          	add	a4,a0,s1
    800025b0:	05874703          	lbu	a4,88(a4)
    800025b4:	00e7f6b3          	and	a3,a5,a4
    800025b8:	c69d                	beqz	a3,800025e6 <bfree+0x6c>
    800025ba:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800025bc:	94aa                	add	s1,s1,a0
    800025be:	fff7c793          	not	a5,a5
    800025c2:	8f7d                	and	a4,a4,a5
    800025c4:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800025c8:	00001097          	auipc	ra,0x1
    800025cc:	126080e7          	jalr	294(ra) # 800036ee <log_write>
  brelse(bp);
    800025d0:	854a                	mv	a0,s2
    800025d2:	00000097          	auipc	ra,0x0
    800025d6:	e92080e7          	jalr	-366(ra) # 80002464 <brelse>
}
    800025da:	60e2                	ld	ra,24(sp)
    800025dc:	6442                	ld	s0,16(sp)
    800025de:	64a2                	ld	s1,8(sp)
    800025e0:	6902                	ld	s2,0(sp)
    800025e2:	6105                	addi	sp,sp,32
    800025e4:	8082                	ret
    panic("freeing free block");
    800025e6:	00007517          	auipc	a0,0x7
    800025ea:	f2250513          	addi	a0,a0,-222 # 80009508 <syscalls+0x128>
    800025ee:	00004097          	auipc	ra,0x4
    800025f2:	5ec080e7          	jalr	1516(ra) # 80006bda <panic>

00000000800025f6 <balloc>:
{
    800025f6:	711d                	addi	sp,sp,-96
    800025f8:	ec86                	sd	ra,88(sp)
    800025fa:	e8a2                	sd	s0,80(sp)
    800025fc:	e4a6                	sd	s1,72(sp)
    800025fe:	e0ca                	sd	s2,64(sp)
    80002600:	fc4e                	sd	s3,56(sp)
    80002602:	f852                	sd	s4,48(sp)
    80002604:	f456                	sd	s5,40(sp)
    80002606:	f05a                	sd	s6,32(sp)
    80002608:	ec5e                	sd	s7,24(sp)
    8000260a:	e862                	sd	s8,16(sp)
    8000260c:	e466                	sd	s9,8(sp)
    8000260e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002610:	00016797          	auipc	a5,0x16
    80002614:	8ac7a783          	lw	a5,-1876(a5) # 80017ebc <sb+0x4>
    80002618:	cff5                	beqz	a5,80002714 <balloc+0x11e>
    8000261a:	8baa                	mv	s7,a0
    8000261c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000261e:	00016b17          	auipc	s6,0x16
    80002622:	89ab0b13          	addi	s6,s6,-1894 # 80017eb8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002626:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002628:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000262a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000262c:	6c89                	lui	s9,0x2
    8000262e:	a061                	j	800026b6 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002630:	97ca                	add	a5,a5,s2
    80002632:	8e55                	or	a2,a2,a3
    80002634:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002638:	854a                	mv	a0,s2
    8000263a:	00001097          	auipc	ra,0x1
    8000263e:	0b4080e7          	jalr	180(ra) # 800036ee <log_write>
        brelse(bp);
    80002642:	854a                	mv	a0,s2
    80002644:	00000097          	auipc	ra,0x0
    80002648:	e20080e7          	jalr	-480(ra) # 80002464 <brelse>
  bp = bread(dev, bno);
    8000264c:	85a6                	mv	a1,s1
    8000264e:	855e                	mv	a0,s7
    80002650:	00000097          	auipc	ra,0x0
    80002654:	ce4080e7          	jalr	-796(ra) # 80002334 <bread>
    80002658:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000265a:	40000613          	li	a2,1024
    8000265e:	4581                	li	a1,0
    80002660:	05850513          	addi	a0,a0,88
    80002664:	ffffe097          	auipc	ra,0xffffe
    80002668:	b16080e7          	jalr	-1258(ra) # 8000017a <memset>
  log_write(bp);
    8000266c:	854a                	mv	a0,s2
    8000266e:	00001097          	auipc	ra,0x1
    80002672:	080080e7          	jalr	128(ra) # 800036ee <log_write>
  brelse(bp);
    80002676:	854a                	mv	a0,s2
    80002678:	00000097          	auipc	ra,0x0
    8000267c:	dec080e7          	jalr	-532(ra) # 80002464 <brelse>
}
    80002680:	8526                	mv	a0,s1
    80002682:	60e6                	ld	ra,88(sp)
    80002684:	6446                	ld	s0,80(sp)
    80002686:	64a6                	ld	s1,72(sp)
    80002688:	6906                	ld	s2,64(sp)
    8000268a:	79e2                	ld	s3,56(sp)
    8000268c:	7a42                	ld	s4,48(sp)
    8000268e:	7aa2                	ld	s5,40(sp)
    80002690:	7b02                	ld	s6,32(sp)
    80002692:	6be2                	ld	s7,24(sp)
    80002694:	6c42                	ld	s8,16(sp)
    80002696:	6ca2                	ld	s9,8(sp)
    80002698:	6125                	addi	sp,sp,96
    8000269a:	8082                	ret
    brelse(bp);
    8000269c:	854a                	mv	a0,s2
    8000269e:	00000097          	auipc	ra,0x0
    800026a2:	dc6080e7          	jalr	-570(ra) # 80002464 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026a6:	015c87bb          	addw	a5,s9,s5
    800026aa:	00078a9b          	sext.w	s5,a5
    800026ae:	004b2703          	lw	a4,4(s6)
    800026b2:	06eaf163          	bgeu	s5,a4,80002714 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    800026b6:	41fad79b          	sraiw	a5,s5,0x1f
    800026ba:	0137d79b          	srliw	a5,a5,0x13
    800026be:	015787bb          	addw	a5,a5,s5
    800026c2:	40d7d79b          	sraiw	a5,a5,0xd
    800026c6:	01cb2583          	lw	a1,28(s6)
    800026ca:	9dbd                	addw	a1,a1,a5
    800026cc:	855e                	mv	a0,s7
    800026ce:	00000097          	auipc	ra,0x0
    800026d2:	c66080e7          	jalr	-922(ra) # 80002334 <bread>
    800026d6:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026d8:	004b2503          	lw	a0,4(s6)
    800026dc:	000a849b          	sext.w	s1,s5
    800026e0:	8762                	mv	a4,s8
    800026e2:	faa4fde3          	bgeu	s1,a0,8000269c <balloc+0xa6>
      m = 1 << (bi % 8);
    800026e6:	00777693          	andi	a3,a4,7
    800026ea:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800026ee:	41f7579b          	sraiw	a5,a4,0x1f
    800026f2:	01d7d79b          	srliw	a5,a5,0x1d
    800026f6:	9fb9                	addw	a5,a5,a4
    800026f8:	4037d79b          	sraiw	a5,a5,0x3
    800026fc:	00f90633          	add	a2,s2,a5
    80002700:	05864603          	lbu	a2,88(a2)
    80002704:	00c6f5b3          	and	a1,a3,a2
    80002708:	d585                	beqz	a1,80002630 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000270a:	2705                	addiw	a4,a4,1
    8000270c:	2485                	addiw	s1,s1,1
    8000270e:	fd471ae3          	bne	a4,s4,800026e2 <balloc+0xec>
    80002712:	b769                	j	8000269c <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80002714:	00007517          	auipc	a0,0x7
    80002718:	e0c50513          	addi	a0,a0,-500 # 80009520 <syscalls+0x140>
    8000271c:	00004097          	auipc	ra,0x4
    80002720:	508080e7          	jalr	1288(ra) # 80006c24 <printf>
  return 0;
    80002724:	4481                	li	s1,0
    80002726:	bfa9                	j	80002680 <balloc+0x8a>

0000000080002728 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002728:	7179                	addi	sp,sp,-48
    8000272a:	f406                	sd	ra,40(sp)
    8000272c:	f022                	sd	s0,32(sp)
    8000272e:	ec26                	sd	s1,24(sp)
    80002730:	e84a                	sd	s2,16(sp)
    80002732:	e44e                	sd	s3,8(sp)
    80002734:	e052                	sd	s4,0(sp)
    80002736:	1800                	addi	s0,sp,48
    80002738:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000273a:	47ad                	li	a5,11
    8000273c:	02b7e863          	bltu	a5,a1,8000276c <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80002740:	02059793          	slli	a5,a1,0x20
    80002744:	01e7d593          	srli	a1,a5,0x1e
    80002748:	00b504b3          	add	s1,a0,a1
    8000274c:	0504a903          	lw	s2,80(s1)
    80002750:	06091e63          	bnez	s2,800027cc <bmap+0xa4>
      addr = balloc(ip->dev);
    80002754:	4108                	lw	a0,0(a0)
    80002756:	00000097          	auipc	ra,0x0
    8000275a:	ea0080e7          	jalr	-352(ra) # 800025f6 <balloc>
    8000275e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002762:	06090563          	beqz	s2,800027cc <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    80002766:	0524a823          	sw	s2,80(s1)
    8000276a:	a08d                	j	800027cc <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000276c:	ff45849b          	addiw	s1,a1,-12
    80002770:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002774:	0ff00793          	li	a5,255
    80002778:	08e7e563          	bltu	a5,a4,80002802 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000277c:	08052903          	lw	s2,128(a0)
    80002780:	00091d63          	bnez	s2,8000279a <bmap+0x72>
      addr = balloc(ip->dev);
    80002784:	4108                	lw	a0,0(a0)
    80002786:	00000097          	auipc	ra,0x0
    8000278a:	e70080e7          	jalr	-400(ra) # 800025f6 <balloc>
    8000278e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002792:	02090d63          	beqz	s2,800027cc <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002796:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000279a:	85ca                	mv	a1,s2
    8000279c:	0009a503          	lw	a0,0(s3)
    800027a0:	00000097          	auipc	ra,0x0
    800027a4:	b94080e7          	jalr	-1132(ra) # 80002334 <bread>
    800027a8:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800027aa:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800027ae:	02049713          	slli	a4,s1,0x20
    800027b2:	01e75593          	srli	a1,a4,0x1e
    800027b6:	00b784b3          	add	s1,a5,a1
    800027ba:	0004a903          	lw	s2,0(s1)
    800027be:	02090063          	beqz	s2,800027de <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800027c2:	8552                	mv	a0,s4
    800027c4:	00000097          	auipc	ra,0x0
    800027c8:	ca0080e7          	jalr	-864(ra) # 80002464 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800027cc:	854a                	mv	a0,s2
    800027ce:	70a2                	ld	ra,40(sp)
    800027d0:	7402                	ld	s0,32(sp)
    800027d2:	64e2                	ld	s1,24(sp)
    800027d4:	6942                	ld	s2,16(sp)
    800027d6:	69a2                	ld	s3,8(sp)
    800027d8:	6a02                	ld	s4,0(sp)
    800027da:	6145                	addi	sp,sp,48
    800027dc:	8082                	ret
      addr = balloc(ip->dev);
    800027de:	0009a503          	lw	a0,0(s3)
    800027e2:	00000097          	auipc	ra,0x0
    800027e6:	e14080e7          	jalr	-492(ra) # 800025f6 <balloc>
    800027ea:	0005091b          	sext.w	s2,a0
      if(addr){
    800027ee:	fc090ae3          	beqz	s2,800027c2 <bmap+0x9a>
        a[bn] = addr;
    800027f2:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800027f6:	8552                	mv	a0,s4
    800027f8:	00001097          	auipc	ra,0x1
    800027fc:	ef6080e7          	jalr	-266(ra) # 800036ee <log_write>
    80002800:	b7c9                	j	800027c2 <bmap+0x9a>
  panic("bmap: out of range");
    80002802:	00007517          	auipc	a0,0x7
    80002806:	d3650513          	addi	a0,a0,-714 # 80009538 <syscalls+0x158>
    8000280a:	00004097          	auipc	ra,0x4
    8000280e:	3d0080e7          	jalr	976(ra) # 80006bda <panic>

0000000080002812 <iget>:
{
    80002812:	7179                	addi	sp,sp,-48
    80002814:	f406                	sd	ra,40(sp)
    80002816:	f022                	sd	s0,32(sp)
    80002818:	ec26                	sd	s1,24(sp)
    8000281a:	e84a                	sd	s2,16(sp)
    8000281c:	e44e                	sd	s3,8(sp)
    8000281e:	e052                	sd	s4,0(sp)
    80002820:	1800                	addi	s0,sp,48
    80002822:	89aa                	mv	s3,a0
    80002824:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002826:	00015517          	auipc	a0,0x15
    8000282a:	6b250513          	addi	a0,a0,1714 # 80017ed8 <itable>
    8000282e:	00005097          	auipc	ra,0x5
    80002832:	8e4080e7          	jalr	-1820(ra) # 80007112 <acquire>
  empty = 0;
    80002836:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002838:	00015497          	auipc	s1,0x15
    8000283c:	6b848493          	addi	s1,s1,1720 # 80017ef0 <itable+0x18>
    80002840:	00017697          	auipc	a3,0x17
    80002844:	14068693          	addi	a3,a3,320 # 80019980 <log>
    80002848:	a039                	j	80002856 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000284a:	02090b63          	beqz	s2,80002880 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000284e:	08848493          	addi	s1,s1,136
    80002852:	02d48a63          	beq	s1,a3,80002886 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002856:	449c                	lw	a5,8(s1)
    80002858:	fef059e3          	blez	a5,8000284a <iget+0x38>
    8000285c:	4098                	lw	a4,0(s1)
    8000285e:	ff3716e3          	bne	a4,s3,8000284a <iget+0x38>
    80002862:	40d8                	lw	a4,4(s1)
    80002864:	ff4713e3          	bne	a4,s4,8000284a <iget+0x38>
      ip->ref++;
    80002868:	2785                	addiw	a5,a5,1
    8000286a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000286c:	00015517          	auipc	a0,0x15
    80002870:	66c50513          	addi	a0,a0,1644 # 80017ed8 <itable>
    80002874:	00005097          	auipc	ra,0x5
    80002878:	952080e7          	jalr	-1710(ra) # 800071c6 <release>
      return ip;
    8000287c:	8926                	mv	s2,s1
    8000287e:	a03d                	j	800028ac <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002880:	f7f9                	bnez	a5,8000284e <iget+0x3c>
    80002882:	8926                	mv	s2,s1
    80002884:	b7e9                	j	8000284e <iget+0x3c>
  if(empty == 0)
    80002886:	02090c63          	beqz	s2,800028be <iget+0xac>
  ip->dev = dev;
    8000288a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000288e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002892:	4785                	li	a5,1
    80002894:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002898:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000289c:	00015517          	auipc	a0,0x15
    800028a0:	63c50513          	addi	a0,a0,1596 # 80017ed8 <itable>
    800028a4:	00005097          	auipc	ra,0x5
    800028a8:	922080e7          	jalr	-1758(ra) # 800071c6 <release>
}
    800028ac:	854a                	mv	a0,s2
    800028ae:	70a2                	ld	ra,40(sp)
    800028b0:	7402                	ld	s0,32(sp)
    800028b2:	64e2                	ld	s1,24(sp)
    800028b4:	6942                	ld	s2,16(sp)
    800028b6:	69a2                	ld	s3,8(sp)
    800028b8:	6a02                	ld	s4,0(sp)
    800028ba:	6145                	addi	sp,sp,48
    800028bc:	8082                	ret
    panic("iget: no inodes");
    800028be:	00007517          	auipc	a0,0x7
    800028c2:	c9250513          	addi	a0,a0,-878 # 80009550 <syscalls+0x170>
    800028c6:	00004097          	auipc	ra,0x4
    800028ca:	314080e7          	jalr	788(ra) # 80006bda <panic>

00000000800028ce <fsinit>:
fsinit(int dev) {
    800028ce:	7179                	addi	sp,sp,-48
    800028d0:	f406                	sd	ra,40(sp)
    800028d2:	f022                	sd	s0,32(sp)
    800028d4:	ec26                	sd	s1,24(sp)
    800028d6:	e84a                	sd	s2,16(sp)
    800028d8:	e44e                	sd	s3,8(sp)
    800028da:	1800                	addi	s0,sp,48
    800028dc:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800028de:	4585                	li	a1,1
    800028e0:	00000097          	auipc	ra,0x0
    800028e4:	a54080e7          	jalr	-1452(ra) # 80002334 <bread>
    800028e8:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800028ea:	00015997          	auipc	s3,0x15
    800028ee:	5ce98993          	addi	s3,s3,1486 # 80017eb8 <sb>
    800028f2:	02000613          	li	a2,32
    800028f6:	05850593          	addi	a1,a0,88
    800028fa:	854e                	mv	a0,s3
    800028fc:	ffffe097          	auipc	ra,0xffffe
    80002900:	8da080e7          	jalr	-1830(ra) # 800001d6 <memmove>
  brelse(bp);
    80002904:	8526                	mv	a0,s1
    80002906:	00000097          	auipc	ra,0x0
    8000290a:	b5e080e7          	jalr	-1186(ra) # 80002464 <brelse>
  if(sb.magic != FSMAGIC)
    8000290e:	0009a703          	lw	a4,0(s3)
    80002912:	102037b7          	lui	a5,0x10203
    80002916:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000291a:	02f71263          	bne	a4,a5,8000293e <fsinit+0x70>
  initlog(dev, &sb);
    8000291e:	00015597          	auipc	a1,0x15
    80002922:	59a58593          	addi	a1,a1,1434 # 80017eb8 <sb>
    80002926:	854a                	mv	a0,s2
    80002928:	00001097          	auipc	ra,0x1
    8000292c:	b4a080e7          	jalr	-1206(ra) # 80003472 <initlog>
}
    80002930:	70a2                	ld	ra,40(sp)
    80002932:	7402                	ld	s0,32(sp)
    80002934:	64e2                	ld	s1,24(sp)
    80002936:	6942                	ld	s2,16(sp)
    80002938:	69a2                	ld	s3,8(sp)
    8000293a:	6145                	addi	sp,sp,48
    8000293c:	8082                	ret
    panic("invalid file system");
    8000293e:	00007517          	auipc	a0,0x7
    80002942:	c2250513          	addi	a0,a0,-990 # 80009560 <syscalls+0x180>
    80002946:	00004097          	auipc	ra,0x4
    8000294a:	294080e7          	jalr	660(ra) # 80006bda <panic>

000000008000294e <iinit>:
{
    8000294e:	7179                	addi	sp,sp,-48
    80002950:	f406                	sd	ra,40(sp)
    80002952:	f022                	sd	s0,32(sp)
    80002954:	ec26                	sd	s1,24(sp)
    80002956:	e84a                	sd	s2,16(sp)
    80002958:	e44e                	sd	s3,8(sp)
    8000295a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000295c:	00007597          	auipc	a1,0x7
    80002960:	c1c58593          	addi	a1,a1,-996 # 80009578 <syscalls+0x198>
    80002964:	00015517          	auipc	a0,0x15
    80002968:	57450513          	addi	a0,a0,1396 # 80017ed8 <itable>
    8000296c:	00004097          	auipc	ra,0x4
    80002970:	716080e7          	jalr	1814(ra) # 80007082 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002974:	00015497          	auipc	s1,0x15
    80002978:	58c48493          	addi	s1,s1,1420 # 80017f00 <itable+0x28>
    8000297c:	00017997          	auipc	s3,0x17
    80002980:	01498993          	addi	s3,s3,20 # 80019990 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002984:	00007917          	auipc	s2,0x7
    80002988:	bfc90913          	addi	s2,s2,-1028 # 80009580 <syscalls+0x1a0>
    8000298c:	85ca                	mv	a1,s2
    8000298e:	8526                	mv	a0,s1
    80002990:	00001097          	auipc	ra,0x1
    80002994:	e42080e7          	jalr	-446(ra) # 800037d2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002998:	08848493          	addi	s1,s1,136
    8000299c:	ff3498e3          	bne	s1,s3,8000298c <iinit+0x3e>
}
    800029a0:	70a2                	ld	ra,40(sp)
    800029a2:	7402                	ld	s0,32(sp)
    800029a4:	64e2                	ld	s1,24(sp)
    800029a6:	6942                	ld	s2,16(sp)
    800029a8:	69a2                	ld	s3,8(sp)
    800029aa:	6145                	addi	sp,sp,48
    800029ac:	8082                	ret

00000000800029ae <ialloc>:
{
    800029ae:	715d                	addi	sp,sp,-80
    800029b0:	e486                	sd	ra,72(sp)
    800029b2:	e0a2                	sd	s0,64(sp)
    800029b4:	fc26                	sd	s1,56(sp)
    800029b6:	f84a                	sd	s2,48(sp)
    800029b8:	f44e                	sd	s3,40(sp)
    800029ba:	f052                	sd	s4,32(sp)
    800029bc:	ec56                	sd	s5,24(sp)
    800029be:	e85a                	sd	s6,16(sp)
    800029c0:	e45e                	sd	s7,8(sp)
    800029c2:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800029c4:	00015717          	auipc	a4,0x15
    800029c8:	50072703          	lw	a4,1280(a4) # 80017ec4 <sb+0xc>
    800029cc:	4785                	li	a5,1
    800029ce:	04e7fa63          	bgeu	a5,a4,80002a22 <ialloc+0x74>
    800029d2:	8aaa                	mv	s5,a0
    800029d4:	8bae                	mv	s7,a1
    800029d6:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800029d8:	00015a17          	auipc	s4,0x15
    800029dc:	4e0a0a13          	addi	s4,s4,1248 # 80017eb8 <sb>
    800029e0:	00048b1b          	sext.w	s6,s1
    800029e4:	0044d593          	srli	a1,s1,0x4
    800029e8:	018a2783          	lw	a5,24(s4)
    800029ec:	9dbd                	addw	a1,a1,a5
    800029ee:	8556                	mv	a0,s5
    800029f0:	00000097          	auipc	ra,0x0
    800029f4:	944080e7          	jalr	-1724(ra) # 80002334 <bread>
    800029f8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800029fa:	05850993          	addi	s3,a0,88
    800029fe:	00f4f793          	andi	a5,s1,15
    80002a02:	079a                	slli	a5,a5,0x6
    80002a04:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a06:	00099783          	lh	a5,0(s3)
    80002a0a:	c3a1                	beqz	a5,80002a4a <ialloc+0x9c>
    brelse(bp);
    80002a0c:	00000097          	auipc	ra,0x0
    80002a10:	a58080e7          	jalr	-1448(ra) # 80002464 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a14:	0485                	addi	s1,s1,1
    80002a16:	00ca2703          	lw	a4,12(s4)
    80002a1a:	0004879b          	sext.w	a5,s1
    80002a1e:	fce7e1e3          	bltu	a5,a4,800029e0 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002a22:	00007517          	auipc	a0,0x7
    80002a26:	b6650513          	addi	a0,a0,-1178 # 80009588 <syscalls+0x1a8>
    80002a2a:	00004097          	auipc	ra,0x4
    80002a2e:	1fa080e7          	jalr	506(ra) # 80006c24 <printf>
  return 0;
    80002a32:	4501                	li	a0,0
}
    80002a34:	60a6                	ld	ra,72(sp)
    80002a36:	6406                	ld	s0,64(sp)
    80002a38:	74e2                	ld	s1,56(sp)
    80002a3a:	7942                	ld	s2,48(sp)
    80002a3c:	79a2                	ld	s3,40(sp)
    80002a3e:	7a02                	ld	s4,32(sp)
    80002a40:	6ae2                	ld	s5,24(sp)
    80002a42:	6b42                	ld	s6,16(sp)
    80002a44:	6ba2                	ld	s7,8(sp)
    80002a46:	6161                	addi	sp,sp,80
    80002a48:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002a4a:	04000613          	li	a2,64
    80002a4e:	4581                	li	a1,0
    80002a50:	854e                	mv	a0,s3
    80002a52:	ffffd097          	auipc	ra,0xffffd
    80002a56:	728080e7          	jalr	1832(ra) # 8000017a <memset>
      dip->type = type;
    80002a5a:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a5e:	854a                	mv	a0,s2
    80002a60:	00001097          	auipc	ra,0x1
    80002a64:	c8e080e7          	jalr	-882(ra) # 800036ee <log_write>
      brelse(bp);
    80002a68:	854a                	mv	a0,s2
    80002a6a:	00000097          	auipc	ra,0x0
    80002a6e:	9fa080e7          	jalr	-1542(ra) # 80002464 <brelse>
      return iget(dev, inum);
    80002a72:	85da                	mv	a1,s6
    80002a74:	8556                	mv	a0,s5
    80002a76:	00000097          	auipc	ra,0x0
    80002a7a:	d9c080e7          	jalr	-612(ra) # 80002812 <iget>
    80002a7e:	bf5d                	j	80002a34 <ialloc+0x86>

0000000080002a80 <iupdate>:
{
    80002a80:	1101                	addi	sp,sp,-32
    80002a82:	ec06                	sd	ra,24(sp)
    80002a84:	e822                	sd	s0,16(sp)
    80002a86:	e426                	sd	s1,8(sp)
    80002a88:	e04a                	sd	s2,0(sp)
    80002a8a:	1000                	addi	s0,sp,32
    80002a8c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a8e:	415c                	lw	a5,4(a0)
    80002a90:	0047d79b          	srliw	a5,a5,0x4
    80002a94:	00015597          	auipc	a1,0x15
    80002a98:	43c5a583          	lw	a1,1084(a1) # 80017ed0 <sb+0x18>
    80002a9c:	9dbd                	addw	a1,a1,a5
    80002a9e:	4108                	lw	a0,0(a0)
    80002aa0:	00000097          	auipc	ra,0x0
    80002aa4:	894080e7          	jalr	-1900(ra) # 80002334 <bread>
    80002aa8:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002aaa:	05850793          	addi	a5,a0,88
    80002aae:	40d8                	lw	a4,4(s1)
    80002ab0:	8b3d                	andi	a4,a4,15
    80002ab2:	071a                	slli	a4,a4,0x6
    80002ab4:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002ab6:	04449703          	lh	a4,68(s1)
    80002aba:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002abe:	04649703          	lh	a4,70(s1)
    80002ac2:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002ac6:	04849703          	lh	a4,72(s1)
    80002aca:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002ace:	04a49703          	lh	a4,74(s1)
    80002ad2:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002ad6:	44f8                	lw	a4,76(s1)
    80002ad8:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002ada:	03400613          	li	a2,52
    80002ade:	05048593          	addi	a1,s1,80
    80002ae2:	00c78513          	addi	a0,a5,12
    80002ae6:	ffffd097          	auipc	ra,0xffffd
    80002aea:	6f0080e7          	jalr	1776(ra) # 800001d6 <memmove>
  log_write(bp);
    80002aee:	854a                	mv	a0,s2
    80002af0:	00001097          	auipc	ra,0x1
    80002af4:	bfe080e7          	jalr	-1026(ra) # 800036ee <log_write>
  brelse(bp);
    80002af8:	854a                	mv	a0,s2
    80002afa:	00000097          	auipc	ra,0x0
    80002afe:	96a080e7          	jalr	-1686(ra) # 80002464 <brelse>
}
    80002b02:	60e2                	ld	ra,24(sp)
    80002b04:	6442                	ld	s0,16(sp)
    80002b06:	64a2                	ld	s1,8(sp)
    80002b08:	6902                	ld	s2,0(sp)
    80002b0a:	6105                	addi	sp,sp,32
    80002b0c:	8082                	ret

0000000080002b0e <idup>:
{
    80002b0e:	1101                	addi	sp,sp,-32
    80002b10:	ec06                	sd	ra,24(sp)
    80002b12:	e822                	sd	s0,16(sp)
    80002b14:	e426                	sd	s1,8(sp)
    80002b16:	1000                	addi	s0,sp,32
    80002b18:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b1a:	00015517          	auipc	a0,0x15
    80002b1e:	3be50513          	addi	a0,a0,958 # 80017ed8 <itable>
    80002b22:	00004097          	auipc	ra,0x4
    80002b26:	5f0080e7          	jalr	1520(ra) # 80007112 <acquire>
  ip->ref++;
    80002b2a:	449c                	lw	a5,8(s1)
    80002b2c:	2785                	addiw	a5,a5,1
    80002b2e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b30:	00015517          	auipc	a0,0x15
    80002b34:	3a850513          	addi	a0,a0,936 # 80017ed8 <itable>
    80002b38:	00004097          	auipc	ra,0x4
    80002b3c:	68e080e7          	jalr	1678(ra) # 800071c6 <release>
}
    80002b40:	8526                	mv	a0,s1
    80002b42:	60e2                	ld	ra,24(sp)
    80002b44:	6442                	ld	s0,16(sp)
    80002b46:	64a2                	ld	s1,8(sp)
    80002b48:	6105                	addi	sp,sp,32
    80002b4a:	8082                	ret

0000000080002b4c <ilock>:
{
    80002b4c:	1101                	addi	sp,sp,-32
    80002b4e:	ec06                	sd	ra,24(sp)
    80002b50:	e822                	sd	s0,16(sp)
    80002b52:	e426                	sd	s1,8(sp)
    80002b54:	e04a                	sd	s2,0(sp)
    80002b56:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002b58:	c115                	beqz	a0,80002b7c <ilock+0x30>
    80002b5a:	84aa                	mv	s1,a0
    80002b5c:	451c                	lw	a5,8(a0)
    80002b5e:	00f05f63          	blez	a5,80002b7c <ilock+0x30>
  acquiresleep(&ip->lock);
    80002b62:	0541                	addi	a0,a0,16
    80002b64:	00001097          	auipc	ra,0x1
    80002b68:	ca8080e7          	jalr	-856(ra) # 8000380c <acquiresleep>
  if(ip->valid == 0){
    80002b6c:	40bc                	lw	a5,64(s1)
    80002b6e:	cf99                	beqz	a5,80002b8c <ilock+0x40>
}
    80002b70:	60e2                	ld	ra,24(sp)
    80002b72:	6442                	ld	s0,16(sp)
    80002b74:	64a2                	ld	s1,8(sp)
    80002b76:	6902                	ld	s2,0(sp)
    80002b78:	6105                	addi	sp,sp,32
    80002b7a:	8082                	ret
    panic("ilock");
    80002b7c:	00007517          	auipc	a0,0x7
    80002b80:	a2450513          	addi	a0,a0,-1500 # 800095a0 <syscalls+0x1c0>
    80002b84:	00004097          	auipc	ra,0x4
    80002b88:	056080e7          	jalr	86(ra) # 80006bda <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b8c:	40dc                	lw	a5,4(s1)
    80002b8e:	0047d79b          	srliw	a5,a5,0x4
    80002b92:	00015597          	auipc	a1,0x15
    80002b96:	33e5a583          	lw	a1,830(a1) # 80017ed0 <sb+0x18>
    80002b9a:	9dbd                	addw	a1,a1,a5
    80002b9c:	4088                	lw	a0,0(s1)
    80002b9e:	fffff097          	auipc	ra,0xfffff
    80002ba2:	796080e7          	jalr	1942(ra) # 80002334 <bread>
    80002ba6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002ba8:	05850593          	addi	a1,a0,88
    80002bac:	40dc                	lw	a5,4(s1)
    80002bae:	8bbd                	andi	a5,a5,15
    80002bb0:	079a                	slli	a5,a5,0x6
    80002bb2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002bb4:	00059783          	lh	a5,0(a1)
    80002bb8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002bbc:	00259783          	lh	a5,2(a1)
    80002bc0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002bc4:	00459783          	lh	a5,4(a1)
    80002bc8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002bcc:	00659783          	lh	a5,6(a1)
    80002bd0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002bd4:	459c                	lw	a5,8(a1)
    80002bd6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002bd8:	03400613          	li	a2,52
    80002bdc:	05b1                	addi	a1,a1,12
    80002bde:	05048513          	addi	a0,s1,80
    80002be2:	ffffd097          	auipc	ra,0xffffd
    80002be6:	5f4080e7          	jalr	1524(ra) # 800001d6 <memmove>
    brelse(bp);
    80002bea:	854a                	mv	a0,s2
    80002bec:	00000097          	auipc	ra,0x0
    80002bf0:	878080e7          	jalr	-1928(ra) # 80002464 <brelse>
    ip->valid = 1;
    80002bf4:	4785                	li	a5,1
    80002bf6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002bf8:	04449783          	lh	a5,68(s1)
    80002bfc:	fbb5                	bnez	a5,80002b70 <ilock+0x24>
      panic("ilock: no type");
    80002bfe:	00007517          	auipc	a0,0x7
    80002c02:	9aa50513          	addi	a0,a0,-1622 # 800095a8 <syscalls+0x1c8>
    80002c06:	00004097          	auipc	ra,0x4
    80002c0a:	fd4080e7          	jalr	-44(ra) # 80006bda <panic>

0000000080002c0e <iunlock>:
{
    80002c0e:	1101                	addi	sp,sp,-32
    80002c10:	ec06                	sd	ra,24(sp)
    80002c12:	e822                	sd	s0,16(sp)
    80002c14:	e426                	sd	s1,8(sp)
    80002c16:	e04a                	sd	s2,0(sp)
    80002c18:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c1a:	c905                	beqz	a0,80002c4a <iunlock+0x3c>
    80002c1c:	84aa                	mv	s1,a0
    80002c1e:	01050913          	addi	s2,a0,16
    80002c22:	854a                	mv	a0,s2
    80002c24:	00001097          	auipc	ra,0x1
    80002c28:	c82080e7          	jalr	-894(ra) # 800038a6 <holdingsleep>
    80002c2c:	cd19                	beqz	a0,80002c4a <iunlock+0x3c>
    80002c2e:	449c                	lw	a5,8(s1)
    80002c30:	00f05d63          	blez	a5,80002c4a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c34:	854a                	mv	a0,s2
    80002c36:	00001097          	auipc	ra,0x1
    80002c3a:	c2c080e7          	jalr	-980(ra) # 80003862 <releasesleep>
}
    80002c3e:	60e2                	ld	ra,24(sp)
    80002c40:	6442                	ld	s0,16(sp)
    80002c42:	64a2                	ld	s1,8(sp)
    80002c44:	6902                	ld	s2,0(sp)
    80002c46:	6105                	addi	sp,sp,32
    80002c48:	8082                	ret
    panic("iunlock");
    80002c4a:	00007517          	auipc	a0,0x7
    80002c4e:	96e50513          	addi	a0,a0,-1682 # 800095b8 <syscalls+0x1d8>
    80002c52:	00004097          	auipc	ra,0x4
    80002c56:	f88080e7          	jalr	-120(ra) # 80006bda <panic>

0000000080002c5a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002c5a:	7179                	addi	sp,sp,-48
    80002c5c:	f406                	sd	ra,40(sp)
    80002c5e:	f022                	sd	s0,32(sp)
    80002c60:	ec26                	sd	s1,24(sp)
    80002c62:	e84a                	sd	s2,16(sp)
    80002c64:	e44e                	sd	s3,8(sp)
    80002c66:	e052                	sd	s4,0(sp)
    80002c68:	1800                	addi	s0,sp,48
    80002c6a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c6c:	05050493          	addi	s1,a0,80
    80002c70:	08050913          	addi	s2,a0,128
    80002c74:	a021                	j	80002c7c <itrunc+0x22>
    80002c76:	0491                	addi	s1,s1,4
    80002c78:	01248d63          	beq	s1,s2,80002c92 <itrunc+0x38>
    if(ip->addrs[i]){
    80002c7c:	408c                	lw	a1,0(s1)
    80002c7e:	dde5                	beqz	a1,80002c76 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c80:	0009a503          	lw	a0,0(s3)
    80002c84:	00000097          	auipc	ra,0x0
    80002c88:	8f6080e7          	jalr	-1802(ra) # 8000257a <bfree>
      ip->addrs[i] = 0;
    80002c8c:	0004a023          	sw	zero,0(s1)
    80002c90:	b7dd                	j	80002c76 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c92:	0809a583          	lw	a1,128(s3)
    80002c96:	e185                	bnez	a1,80002cb6 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c98:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c9c:	854e                	mv	a0,s3
    80002c9e:	00000097          	auipc	ra,0x0
    80002ca2:	de2080e7          	jalr	-542(ra) # 80002a80 <iupdate>
}
    80002ca6:	70a2                	ld	ra,40(sp)
    80002ca8:	7402                	ld	s0,32(sp)
    80002caa:	64e2                	ld	s1,24(sp)
    80002cac:	6942                	ld	s2,16(sp)
    80002cae:	69a2                	ld	s3,8(sp)
    80002cb0:	6a02                	ld	s4,0(sp)
    80002cb2:	6145                	addi	sp,sp,48
    80002cb4:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002cb6:	0009a503          	lw	a0,0(s3)
    80002cba:	fffff097          	auipc	ra,0xfffff
    80002cbe:	67a080e7          	jalr	1658(ra) # 80002334 <bread>
    80002cc2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002cc4:	05850493          	addi	s1,a0,88
    80002cc8:	45850913          	addi	s2,a0,1112
    80002ccc:	a021                	j	80002cd4 <itrunc+0x7a>
    80002cce:	0491                	addi	s1,s1,4
    80002cd0:	01248b63          	beq	s1,s2,80002ce6 <itrunc+0x8c>
      if(a[j])
    80002cd4:	408c                	lw	a1,0(s1)
    80002cd6:	dde5                	beqz	a1,80002cce <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002cd8:	0009a503          	lw	a0,0(s3)
    80002cdc:	00000097          	auipc	ra,0x0
    80002ce0:	89e080e7          	jalr	-1890(ra) # 8000257a <bfree>
    80002ce4:	b7ed                	j	80002cce <itrunc+0x74>
    brelse(bp);
    80002ce6:	8552                	mv	a0,s4
    80002ce8:	fffff097          	auipc	ra,0xfffff
    80002cec:	77c080e7          	jalr	1916(ra) # 80002464 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002cf0:	0809a583          	lw	a1,128(s3)
    80002cf4:	0009a503          	lw	a0,0(s3)
    80002cf8:	00000097          	auipc	ra,0x0
    80002cfc:	882080e7          	jalr	-1918(ra) # 8000257a <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d00:	0809a023          	sw	zero,128(s3)
    80002d04:	bf51                	j	80002c98 <itrunc+0x3e>

0000000080002d06 <iput>:
{
    80002d06:	1101                	addi	sp,sp,-32
    80002d08:	ec06                	sd	ra,24(sp)
    80002d0a:	e822                	sd	s0,16(sp)
    80002d0c:	e426                	sd	s1,8(sp)
    80002d0e:	e04a                	sd	s2,0(sp)
    80002d10:	1000                	addi	s0,sp,32
    80002d12:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d14:	00015517          	auipc	a0,0x15
    80002d18:	1c450513          	addi	a0,a0,452 # 80017ed8 <itable>
    80002d1c:	00004097          	auipc	ra,0x4
    80002d20:	3f6080e7          	jalr	1014(ra) # 80007112 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d24:	4498                	lw	a4,8(s1)
    80002d26:	4785                	li	a5,1
    80002d28:	02f70363          	beq	a4,a5,80002d4e <iput+0x48>
  ip->ref--;
    80002d2c:	449c                	lw	a5,8(s1)
    80002d2e:	37fd                	addiw	a5,a5,-1
    80002d30:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d32:	00015517          	auipc	a0,0x15
    80002d36:	1a650513          	addi	a0,a0,422 # 80017ed8 <itable>
    80002d3a:	00004097          	auipc	ra,0x4
    80002d3e:	48c080e7          	jalr	1164(ra) # 800071c6 <release>
}
    80002d42:	60e2                	ld	ra,24(sp)
    80002d44:	6442                	ld	s0,16(sp)
    80002d46:	64a2                	ld	s1,8(sp)
    80002d48:	6902                	ld	s2,0(sp)
    80002d4a:	6105                	addi	sp,sp,32
    80002d4c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d4e:	40bc                	lw	a5,64(s1)
    80002d50:	dff1                	beqz	a5,80002d2c <iput+0x26>
    80002d52:	04a49783          	lh	a5,74(s1)
    80002d56:	fbf9                	bnez	a5,80002d2c <iput+0x26>
    acquiresleep(&ip->lock);
    80002d58:	01048913          	addi	s2,s1,16
    80002d5c:	854a                	mv	a0,s2
    80002d5e:	00001097          	auipc	ra,0x1
    80002d62:	aae080e7          	jalr	-1362(ra) # 8000380c <acquiresleep>
    release(&itable.lock);
    80002d66:	00015517          	auipc	a0,0x15
    80002d6a:	17250513          	addi	a0,a0,370 # 80017ed8 <itable>
    80002d6e:	00004097          	auipc	ra,0x4
    80002d72:	458080e7          	jalr	1112(ra) # 800071c6 <release>
    itrunc(ip);
    80002d76:	8526                	mv	a0,s1
    80002d78:	00000097          	auipc	ra,0x0
    80002d7c:	ee2080e7          	jalr	-286(ra) # 80002c5a <itrunc>
    ip->type = 0;
    80002d80:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d84:	8526                	mv	a0,s1
    80002d86:	00000097          	auipc	ra,0x0
    80002d8a:	cfa080e7          	jalr	-774(ra) # 80002a80 <iupdate>
    ip->valid = 0;
    80002d8e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d92:	854a                	mv	a0,s2
    80002d94:	00001097          	auipc	ra,0x1
    80002d98:	ace080e7          	jalr	-1330(ra) # 80003862 <releasesleep>
    acquire(&itable.lock);
    80002d9c:	00015517          	auipc	a0,0x15
    80002da0:	13c50513          	addi	a0,a0,316 # 80017ed8 <itable>
    80002da4:	00004097          	auipc	ra,0x4
    80002da8:	36e080e7          	jalr	878(ra) # 80007112 <acquire>
    80002dac:	b741                	j	80002d2c <iput+0x26>

0000000080002dae <iunlockput>:
{
    80002dae:	1101                	addi	sp,sp,-32
    80002db0:	ec06                	sd	ra,24(sp)
    80002db2:	e822                	sd	s0,16(sp)
    80002db4:	e426                	sd	s1,8(sp)
    80002db6:	1000                	addi	s0,sp,32
    80002db8:	84aa                	mv	s1,a0
  iunlock(ip);
    80002dba:	00000097          	auipc	ra,0x0
    80002dbe:	e54080e7          	jalr	-428(ra) # 80002c0e <iunlock>
  iput(ip);
    80002dc2:	8526                	mv	a0,s1
    80002dc4:	00000097          	auipc	ra,0x0
    80002dc8:	f42080e7          	jalr	-190(ra) # 80002d06 <iput>
}
    80002dcc:	60e2                	ld	ra,24(sp)
    80002dce:	6442                	ld	s0,16(sp)
    80002dd0:	64a2                	ld	s1,8(sp)
    80002dd2:	6105                	addi	sp,sp,32
    80002dd4:	8082                	ret

0000000080002dd6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002dd6:	1141                	addi	sp,sp,-16
    80002dd8:	e422                	sd	s0,8(sp)
    80002dda:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002ddc:	411c                	lw	a5,0(a0)
    80002dde:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002de0:	415c                	lw	a5,4(a0)
    80002de2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002de4:	04451783          	lh	a5,68(a0)
    80002de8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002dec:	04a51783          	lh	a5,74(a0)
    80002df0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002df4:	04c56783          	lwu	a5,76(a0)
    80002df8:	e99c                	sd	a5,16(a1)
}
    80002dfa:	6422                	ld	s0,8(sp)
    80002dfc:	0141                	addi	sp,sp,16
    80002dfe:	8082                	ret

0000000080002e00 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e00:	457c                	lw	a5,76(a0)
    80002e02:	0ed7e963          	bltu	a5,a3,80002ef4 <readi+0xf4>
{
    80002e06:	7159                	addi	sp,sp,-112
    80002e08:	f486                	sd	ra,104(sp)
    80002e0a:	f0a2                	sd	s0,96(sp)
    80002e0c:	eca6                	sd	s1,88(sp)
    80002e0e:	e8ca                	sd	s2,80(sp)
    80002e10:	e4ce                	sd	s3,72(sp)
    80002e12:	e0d2                	sd	s4,64(sp)
    80002e14:	fc56                	sd	s5,56(sp)
    80002e16:	f85a                	sd	s6,48(sp)
    80002e18:	f45e                	sd	s7,40(sp)
    80002e1a:	f062                	sd	s8,32(sp)
    80002e1c:	ec66                	sd	s9,24(sp)
    80002e1e:	e86a                	sd	s10,16(sp)
    80002e20:	e46e                	sd	s11,8(sp)
    80002e22:	1880                	addi	s0,sp,112
    80002e24:	8b2a                	mv	s6,a0
    80002e26:	8bae                	mv	s7,a1
    80002e28:	8a32                	mv	s4,a2
    80002e2a:	84b6                	mv	s1,a3
    80002e2c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002e2e:	9f35                	addw	a4,a4,a3
    return 0;
    80002e30:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e32:	0ad76063          	bltu	a4,a3,80002ed2 <readi+0xd2>
  if(off + n > ip->size)
    80002e36:	00e7f463          	bgeu	a5,a4,80002e3e <readi+0x3e>
    n = ip->size - off;
    80002e3a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e3e:	0a0a8963          	beqz	s5,80002ef0 <readi+0xf0>
    80002e42:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e44:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002e48:	5c7d                	li	s8,-1
    80002e4a:	a82d                	j	80002e84 <readi+0x84>
    80002e4c:	020d1d93          	slli	s11,s10,0x20
    80002e50:	020ddd93          	srli	s11,s11,0x20
    80002e54:	05890613          	addi	a2,s2,88
    80002e58:	86ee                	mv	a3,s11
    80002e5a:	963a                	add	a2,a2,a4
    80002e5c:	85d2                	mv	a1,s4
    80002e5e:	855e                	mv	a0,s7
    80002e60:	fffff097          	auipc	ra,0xfffff
    80002e64:	afc080e7          	jalr	-1284(ra) # 8000195c <either_copyout>
    80002e68:	05850d63          	beq	a0,s8,80002ec2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e6c:	854a                	mv	a0,s2
    80002e6e:	fffff097          	auipc	ra,0xfffff
    80002e72:	5f6080e7          	jalr	1526(ra) # 80002464 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e76:	013d09bb          	addw	s3,s10,s3
    80002e7a:	009d04bb          	addw	s1,s10,s1
    80002e7e:	9a6e                	add	s4,s4,s11
    80002e80:	0559f763          	bgeu	s3,s5,80002ece <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002e84:	00a4d59b          	srliw	a1,s1,0xa
    80002e88:	855a                	mv	a0,s6
    80002e8a:	00000097          	auipc	ra,0x0
    80002e8e:	89e080e7          	jalr	-1890(ra) # 80002728 <bmap>
    80002e92:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002e96:	cd85                	beqz	a1,80002ece <readi+0xce>
    bp = bread(ip->dev, addr);
    80002e98:	000b2503          	lw	a0,0(s6)
    80002e9c:	fffff097          	auipc	ra,0xfffff
    80002ea0:	498080e7          	jalr	1176(ra) # 80002334 <bread>
    80002ea4:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ea6:	3ff4f713          	andi	a4,s1,1023
    80002eaa:	40ec87bb          	subw	a5,s9,a4
    80002eae:	413a86bb          	subw	a3,s5,s3
    80002eb2:	8d3e                	mv	s10,a5
    80002eb4:	2781                	sext.w	a5,a5
    80002eb6:	0006861b          	sext.w	a2,a3
    80002eba:	f8f679e3          	bgeu	a2,a5,80002e4c <readi+0x4c>
    80002ebe:	8d36                	mv	s10,a3
    80002ec0:	b771                	j	80002e4c <readi+0x4c>
      brelse(bp);
    80002ec2:	854a                	mv	a0,s2
    80002ec4:	fffff097          	auipc	ra,0xfffff
    80002ec8:	5a0080e7          	jalr	1440(ra) # 80002464 <brelse>
      tot = -1;
    80002ecc:	59fd                	li	s3,-1
  }
  return tot;
    80002ece:	0009851b          	sext.w	a0,s3
}
    80002ed2:	70a6                	ld	ra,104(sp)
    80002ed4:	7406                	ld	s0,96(sp)
    80002ed6:	64e6                	ld	s1,88(sp)
    80002ed8:	6946                	ld	s2,80(sp)
    80002eda:	69a6                	ld	s3,72(sp)
    80002edc:	6a06                	ld	s4,64(sp)
    80002ede:	7ae2                	ld	s5,56(sp)
    80002ee0:	7b42                	ld	s6,48(sp)
    80002ee2:	7ba2                	ld	s7,40(sp)
    80002ee4:	7c02                	ld	s8,32(sp)
    80002ee6:	6ce2                	ld	s9,24(sp)
    80002ee8:	6d42                	ld	s10,16(sp)
    80002eea:	6da2                	ld	s11,8(sp)
    80002eec:	6165                	addi	sp,sp,112
    80002eee:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ef0:	89d6                	mv	s3,s5
    80002ef2:	bff1                	j	80002ece <readi+0xce>
    return 0;
    80002ef4:	4501                	li	a0,0
}
    80002ef6:	8082                	ret

0000000080002ef8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ef8:	457c                	lw	a5,76(a0)
    80002efa:	10d7e863          	bltu	a5,a3,8000300a <writei+0x112>
{
    80002efe:	7159                	addi	sp,sp,-112
    80002f00:	f486                	sd	ra,104(sp)
    80002f02:	f0a2                	sd	s0,96(sp)
    80002f04:	eca6                	sd	s1,88(sp)
    80002f06:	e8ca                	sd	s2,80(sp)
    80002f08:	e4ce                	sd	s3,72(sp)
    80002f0a:	e0d2                	sd	s4,64(sp)
    80002f0c:	fc56                	sd	s5,56(sp)
    80002f0e:	f85a                	sd	s6,48(sp)
    80002f10:	f45e                	sd	s7,40(sp)
    80002f12:	f062                	sd	s8,32(sp)
    80002f14:	ec66                	sd	s9,24(sp)
    80002f16:	e86a                	sd	s10,16(sp)
    80002f18:	e46e                	sd	s11,8(sp)
    80002f1a:	1880                	addi	s0,sp,112
    80002f1c:	8aaa                	mv	s5,a0
    80002f1e:	8bae                	mv	s7,a1
    80002f20:	8a32                	mv	s4,a2
    80002f22:	8936                	mv	s2,a3
    80002f24:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f26:	00e687bb          	addw	a5,a3,a4
    80002f2a:	0ed7e263          	bltu	a5,a3,8000300e <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f2e:	00043737          	lui	a4,0x43
    80002f32:	0ef76063          	bltu	a4,a5,80003012 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f36:	0c0b0863          	beqz	s6,80003006 <writei+0x10e>
    80002f3a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f3c:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f40:	5c7d                	li	s8,-1
    80002f42:	a091                	j	80002f86 <writei+0x8e>
    80002f44:	020d1d93          	slli	s11,s10,0x20
    80002f48:	020ddd93          	srli	s11,s11,0x20
    80002f4c:	05848513          	addi	a0,s1,88
    80002f50:	86ee                	mv	a3,s11
    80002f52:	8652                	mv	a2,s4
    80002f54:	85de                	mv	a1,s7
    80002f56:	953a                	add	a0,a0,a4
    80002f58:	fffff097          	auipc	ra,0xfffff
    80002f5c:	a5a080e7          	jalr	-1446(ra) # 800019b2 <either_copyin>
    80002f60:	07850263          	beq	a0,s8,80002fc4 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002f64:	8526                	mv	a0,s1
    80002f66:	00000097          	auipc	ra,0x0
    80002f6a:	788080e7          	jalr	1928(ra) # 800036ee <log_write>
    brelse(bp);
    80002f6e:	8526                	mv	a0,s1
    80002f70:	fffff097          	auipc	ra,0xfffff
    80002f74:	4f4080e7          	jalr	1268(ra) # 80002464 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f78:	013d09bb          	addw	s3,s10,s3
    80002f7c:	012d093b          	addw	s2,s10,s2
    80002f80:	9a6e                	add	s4,s4,s11
    80002f82:	0569f663          	bgeu	s3,s6,80002fce <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80002f86:	00a9559b          	srliw	a1,s2,0xa
    80002f8a:	8556                	mv	a0,s5
    80002f8c:	fffff097          	auipc	ra,0xfffff
    80002f90:	79c080e7          	jalr	1948(ra) # 80002728 <bmap>
    80002f94:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f98:	c99d                	beqz	a1,80002fce <writei+0xd6>
    bp = bread(ip->dev, addr);
    80002f9a:	000aa503          	lw	a0,0(s5)
    80002f9e:	fffff097          	auipc	ra,0xfffff
    80002fa2:	396080e7          	jalr	918(ra) # 80002334 <bread>
    80002fa6:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fa8:	3ff97713          	andi	a4,s2,1023
    80002fac:	40ec87bb          	subw	a5,s9,a4
    80002fb0:	413b06bb          	subw	a3,s6,s3
    80002fb4:	8d3e                	mv	s10,a5
    80002fb6:	2781                	sext.w	a5,a5
    80002fb8:	0006861b          	sext.w	a2,a3
    80002fbc:	f8f674e3          	bgeu	a2,a5,80002f44 <writei+0x4c>
    80002fc0:	8d36                	mv	s10,a3
    80002fc2:	b749                	j	80002f44 <writei+0x4c>
      brelse(bp);
    80002fc4:	8526                	mv	a0,s1
    80002fc6:	fffff097          	auipc	ra,0xfffff
    80002fca:	49e080e7          	jalr	1182(ra) # 80002464 <brelse>
  }

  if(off > ip->size)
    80002fce:	04caa783          	lw	a5,76(s5)
    80002fd2:	0127f463          	bgeu	a5,s2,80002fda <writei+0xe2>
    ip->size = off;
    80002fd6:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002fda:	8556                	mv	a0,s5
    80002fdc:	00000097          	auipc	ra,0x0
    80002fe0:	aa4080e7          	jalr	-1372(ra) # 80002a80 <iupdate>

  return tot;
    80002fe4:	0009851b          	sext.w	a0,s3
}
    80002fe8:	70a6                	ld	ra,104(sp)
    80002fea:	7406                	ld	s0,96(sp)
    80002fec:	64e6                	ld	s1,88(sp)
    80002fee:	6946                	ld	s2,80(sp)
    80002ff0:	69a6                	ld	s3,72(sp)
    80002ff2:	6a06                	ld	s4,64(sp)
    80002ff4:	7ae2                	ld	s5,56(sp)
    80002ff6:	7b42                	ld	s6,48(sp)
    80002ff8:	7ba2                	ld	s7,40(sp)
    80002ffa:	7c02                	ld	s8,32(sp)
    80002ffc:	6ce2                	ld	s9,24(sp)
    80002ffe:	6d42                	ld	s10,16(sp)
    80003000:	6da2                	ld	s11,8(sp)
    80003002:	6165                	addi	sp,sp,112
    80003004:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003006:	89da                	mv	s3,s6
    80003008:	bfc9                	j	80002fda <writei+0xe2>
    return -1;
    8000300a:	557d                	li	a0,-1
}
    8000300c:	8082                	ret
    return -1;
    8000300e:	557d                	li	a0,-1
    80003010:	bfe1                	j	80002fe8 <writei+0xf0>
    return -1;
    80003012:	557d                	li	a0,-1
    80003014:	bfd1                	j	80002fe8 <writei+0xf0>

0000000080003016 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003016:	1141                	addi	sp,sp,-16
    80003018:	e406                	sd	ra,8(sp)
    8000301a:	e022                	sd	s0,0(sp)
    8000301c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000301e:	4639                	li	a2,14
    80003020:	ffffd097          	auipc	ra,0xffffd
    80003024:	22a080e7          	jalr	554(ra) # 8000024a <strncmp>
}
    80003028:	60a2                	ld	ra,8(sp)
    8000302a:	6402                	ld	s0,0(sp)
    8000302c:	0141                	addi	sp,sp,16
    8000302e:	8082                	ret

0000000080003030 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003030:	7139                	addi	sp,sp,-64
    80003032:	fc06                	sd	ra,56(sp)
    80003034:	f822                	sd	s0,48(sp)
    80003036:	f426                	sd	s1,40(sp)
    80003038:	f04a                	sd	s2,32(sp)
    8000303a:	ec4e                	sd	s3,24(sp)
    8000303c:	e852                	sd	s4,16(sp)
    8000303e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003040:	04451703          	lh	a4,68(a0)
    80003044:	4785                	li	a5,1
    80003046:	00f71a63          	bne	a4,a5,8000305a <dirlookup+0x2a>
    8000304a:	892a                	mv	s2,a0
    8000304c:	89ae                	mv	s3,a1
    8000304e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003050:	457c                	lw	a5,76(a0)
    80003052:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003054:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003056:	e79d                	bnez	a5,80003084 <dirlookup+0x54>
    80003058:	a8a5                	j	800030d0 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000305a:	00006517          	auipc	a0,0x6
    8000305e:	56650513          	addi	a0,a0,1382 # 800095c0 <syscalls+0x1e0>
    80003062:	00004097          	auipc	ra,0x4
    80003066:	b78080e7          	jalr	-1160(ra) # 80006bda <panic>
      panic("dirlookup read");
    8000306a:	00006517          	auipc	a0,0x6
    8000306e:	56e50513          	addi	a0,a0,1390 # 800095d8 <syscalls+0x1f8>
    80003072:	00004097          	auipc	ra,0x4
    80003076:	b68080e7          	jalr	-1176(ra) # 80006bda <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000307a:	24c1                	addiw	s1,s1,16
    8000307c:	04c92783          	lw	a5,76(s2)
    80003080:	04f4f763          	bgeu	s1,a5,800030ce <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003084:	4741                	li	a4,16
    80003086:	86a6                	mv	a3,s1
    80003088:	fc040613          	addi	a2,s0,-64
    8000308c:	4581                	li	a1,0
    8000308e:	854a                	mv	a0,s2
    80003090:	00000097          	auipc	ra,0x0
    80003094:	d70080e7          	jalr	-656(ra) # 80002e00 <readi>
    80003098:	47c1                	li	a5,16
    8000309a:	fcf518e3          	bne	a0,a5,8000306a <dirlookup+0x3a>
    if(de.inum == 0)
    8000309e:	fc045783          	lhu	a5,-64(s0)
    800030a2:	dfe1                	beqz	a5,8000307a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800030a4:	fc240593          	addi	a1,s0,-62
    800030a8:	854e                	mv	a0,s3
    800030aa:	00000097          	auipc	ra,0x0
    800030ae:	f6c080e7          	jalr	-148(ra) # 80003016 <namecmp>
    800030b2:	f561                	bnez	a0,8000307a <dirlookup+0x4a>
      if(poff)
    800030b4:	000a0463          	beqz	s4,800030bc <dirlookup+0x8c>
        *poff = off;
    800030b8:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800030bc:	fc045583          	lhu	a1,-64(s0)
    800030c0:	00092503          	lw	a0,0(s2)
    800030c4:	fffff097          	auipc	ra,0xfffff
    800030c8:	74e080e7          	jalr	1870(ra) # 80002812 <iget>
    800030cc:	a011                	j	800030d0 <dirlookup+0xa0>
  return 0;
    800030ce:	4501                	li	a0,0
}
    800030d0:	70e2                	ld	ra,56(sp)
    800030d2:	7442                	ld	s0,48(sp)
    800030d4:	74a2                	ld	s1,40(sp)
    800030d6:	7902                	ld	s2,32(sp)
    800030d8:	69e2                	ld	s3,24(sp)
    800030da:	6a42                	ld	s4,16(sp)
    800030dc:	6121                	addi	sp,sp,64
    800030de:	8082                	ret

00000000800030e0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800030e0:	711d                	addi	sp,sp,-96
    800030e2:	ec86                	sd	ra,88(sp)
    800030e4:	e8a2                	sd	s0,80(sp)
    800030e6:	e4a6                	sd	s1,72(sp)
    800030e8:	e0ca                	sd	s2,64(sp)
    800030ea:	fc4e                	sd	s3,56(sp)
    800030ec:	f852                	sd	s4,48(sp)
    800030ee:	f456                	sd	s5,40(sp)
    800030f0:	f05a                	sd	s6,32(sp)
    800030f2:	ec5e                	sd	s7,24(sp)
    800030f4:	e862                	sd	s8,16(sp)
    800030f6:	e466                	sd	s9,8(sp)
    800030f8:	e06a                	sd	s10,0(sp)
    800030fa:	1080                	addi	s0,sp,96
    800030fc:	84aa                	mv	s1,a0
    800030fe:	8b2e                	mv	s6,a1
    80003100:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003102:	00054703          	lbu	a4,0(a0)
    80003106:	02f00793          	li	a5,47
    8000310a:	02f70363          	beq	a4,a5,80003130 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000310e:	ffffe097          	auipc	ra,0xffffe
    80003112:	d9e080e7          	jalr	-610(ra) # 80000eac <myproc>
    80003116:	15053503          	ld	a0,336(a0)
    8000311a:	00000097          	auipc	ra,0x0
    8000311e:	9f4080e7          	jalr	-1548(ra) # 80002b0e <idup>
    80003122:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003124:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003128:	4cb5                	li	s9,13
  len = path - s;
    8000312a:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000312c:	4c05                	li	s8,1
    8000312e:	a87d                	j	800031ec <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003130:	4585                	li	a1,1
    80003132:	4505                	li	a0,1
    80003134:	fffff097          	auipc	ra,0xfffff
    80003138:	6de080e7          	jalr	1758(ra) # 80002812 <iget>
    8000313c:	8a2a                	mv	s4,a0
    8000313e:	b7dd                	j	80003124 <namex+0x44>
      iunlockput(ip);
    80003140:	8552                	mv	a0,s4
    80003142:	00000097          	auipc	ra,0x0
    80003146:	c6c080e7          	jalr	-916(ra) # 80002dae <iunlockput>
      return 0;
    8000314a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000314c:	8552                	mv	a0,s4
    8000314e:	60e6                	ld	ra,88(sp)
    80003150:	6446                	ld	s0,80(sp)
    80003152:	64a6                	ld	s1,72(sp)
    80003154:	6906                	ld	s2,64(sp)
    80003156:	79e2                	ld	s3,56(sp)
    80003158:	7a42                	ld	s4,48(sp)
    8000315a:	7aa2                	ld	s5,40(sp)
    8000315c:	7b02                	ld	s6,32(sp)
    8000315e:	6be2                	ld	s7,24(sp)
    80003160:	6c42                	ld	s8,16(sp)
    80003162:	6ca2                	ld	s9,8(sp)
    80003164:	6d02                	ld	s10,0(sp)
    80003166:	6125                	addi	sp,sp,96
    80003168:	8082                	ret
      iunlock(ip);
    8000316a:	8552                	mv	a0,s4
    8000316c:	00000097          	auipc	ra,0x0
    80003170:	aa2080e7          	jalr	-1374(ra) # 80002c0e <iunlock>
      return ip;
    80003174:	bfe1                	j	8000314c <namex+0x6c>
      iunlockput(ip);
    80003176:	8552                	mv	a0,s4
    80003178:	00000097          	auipc	ra,0x0
    8000317c:	c36080e7          	jalr	-970(ra) # 80002dae <iunlockput>
      return 0;
    80003180:	8a4e                	mv	s4,s3
    80003182:	b7e9                	j	8000314c <namex+0x6c>
  len = path - s;
    80003184:	40998633          	sub	a2,s3,s1
    80003188:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    8000318c:	09acd863          	bge	s9,s10,8000321c <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003190:	4639                	li	a2,14
    80003192:	85a6                	mv	a1,s1
    80003194:	8556                	mv	a0,s5
    80003196:	ffffd097          	auipc	ra,0xffffd
    8000319a:	040080e7          	jalr	64(ra) # 800001d6 <memmove>
    8000319e:	84ce                	mv	s1,s3
  while(*path == '/')
    800031a0:	0004c783          	lbu	a5,0(s1)
    800031a4:	01279763          	bne	a5,s2,800031b2 <namex+0xd2>
    path++;
    800031a8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031aa:	0004c783          	lbu	a5,0(s1)
    800031ae:	ff278de3          	beq	a5,s2,800031a8 <namex+0xc8>
    ilock(ip);
    800031b2:	8552                	mv	a0,s4
    800031b4:	00000097          	auipc	ra,0x0
    800031b8:	998080e7          	jalr	-1640(ra) # 80002b4c <ilock>
    if(ip->type != T_DIR){
    800031bc:	044a1783          	lh	a5,68(s4)
    800031c0:	f98790e3          	bne	a5,s8,80003140 <namex+0x60>
    if(nameiparent && *path == '\0'){
    800031c4:	000b0563          	beqz	s6,800031ce <namex+0xee>
    800031c8:	0004c783          	lbu	a5,0(s1)
    800031cc:	dfd9                	beqz	a5,8000316a <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800031ce:	865e                	mv	a2,s7
    800031d0:	85d6                	mv	a1,s5
    800031d2:	8552                	mv	a0,s4
    800031d4:	00000097          	auipc	ra,0x0
    800031d8:	e5c080e7          	jalr	-420(ra) # 80003030 <dirlookup>
    800031dc:	89aa                	mv	s3,a0
    800031de:	dd41                	beqz	a0,80003176 <namex+0x96>
    iunlockput(ip);
    800031e0:	8552                	mv	a0,s4
    800031e2:	00000097          	auipc	ra,0x0
    800031e6:	bcc080e7          	jalr	-1076(ra) # 80002dae <iunlockput>
    ip = next;
    800031ea:	8a4e                	mv	s4,s3
  while(*path == '/')
    800031ec:	0004c783          	lbu	a5,0(s1)
    800031f0:	01279763          	bne	a5,s2,800031fe <namex+0x11e>
    path++;
    800031f4:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031f6:	0004c783          	lbu	a5,0(s1)
    800031fa:	ff278de3          	beq	a5,s2,800031f4 <namex+0x114>
  if(*path == 0)
    800031fe:	cb9d                	beqz	a5,80003234 <namex+0x154>
  while(*path != '/' && *path != 0)
    80003200:	0004c783          	lbu	a5,0(s1)
    80003204:	89a6                	mv	s3,s1
  len = path - s;
    80003206:	8d5e                	mv	s10,s7
    80003208:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000320a:	01278963          	beq	a5,s2,8000321c <namex+0x13c>
    8000320e:	dbbd                	beqz	a5,80003184 <namex+0xa4>
    path++;
    80003210:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003212:	0009c783          	lbu	a5,0(s3)
    80003216:	ff279ce3          	bne	a5,s2,8000320e <namex+0x12e>
    8000321a:	b7ad                	j	80003184 <namex+0xa4>
    memmove(name, s, len);
    8000321c:	2601                	sext.w	a2,a2
    8000321e:	85a6                	mv	a1,s1
    80003220:	8556                	mv	a0,s5
    80003222:	ffffd097          	auipc	ra,0xffffd
    80003226:	fb4080e7          	jalr	-76(ra) # 800001d6 <memmove>
    name[len] = 0;
    8000322a:	9d56                	add	s10,s10,s5
    8000322c:	000d0023          	sb	zero,0(s10)
    80003230:	84ce                	mv	s1,s3
    80003232:	b7bd                	j	800031a0 <namex+0xc0>
  if(nameiparent){
    80003234:	f00b0ce3          	beqz	s6,8000314c <namex+0x6c>
    iput(ip);
    80003238:	8552                	mv	a0,s4
    8000323a:	00000097          	auipc	ra,0x0
    8000323e:	acc080e7          	jalr	-1332(ra) # 80002d06 <iput>
    return 0;
    80003242:	4a01                	li	s4,0
    80003244:	b721                	j	8000314c <namex+0x6c>

0000000080003246 <dirlink>:
{
    80003246:	7139                	addi	sp,sp,-64
    80003248:	fc06                	sd	ra,56(sp)
    8000324a:	f822                	sd	s0,48(sp)
    8000324c:	f426                	sd	s1,40(sp)
    8000324e:	f04a                	sd	s2,32(sp)
    80003250:	ec4e                	sd	s3,24(sp)
    80003252:	e852                	sd	s4,16(sp)
    80003254:	0080                	addi	s0,sp,64
    80003256:	892a                	mv	s2,a0
    80003258:	8a2e                	mv	s4,a1
    8000325a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000325c:	4601                	li	a2,0
    8000325e:	00000097          	auipc	ra,0x0
    80003262:	dd2080e7          	jalr	-558(ra) # 80003030 <dirlookup>
    80003266:	e93d                	bnez	a0,800032dc <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003268:	04c92483          	lw	s1,76(s2)
    8000326c:	c49d                	beqz	s1,8000329a <dirlink+0x54>
    8000326e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003270:	4741                	li	a4,16
    80003272:	86a6                	mv	a3,s1
    80003274:	fc040613          	addi	a2,s0,-64
    80003278:	4581                	li	a1,0
    8000327a:	854a                	mv	a0,s2
    8000327c:	00000097          	auipc	ra,0x0
    80003280:	b84080e7          	jalr	-1148(ra) # 80002e00 <readi>
    80003284:	47c1                	li	a5,16
    80003286:	06f51163          	bne	a0,a5,800032e8 <dirlink+0xa2>
    if(de.inum == 0)
    8000328a:	fc045783          	lhu	a5,-64(s0)
    8000328e:	c791                	beqz	a5,8000329a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003290:	24c1                	addiw	s1,s1,16
    80003292:	04c92783          	lw	a5,76(s2)
    80003296:	fcf4ede3          	bltu	s1,a5,80003270 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000329a:	4639                	li	a2,14
    8000329c:	85d2                	mv	a1,s4
    8000329e:	fc240513          	addi	a0,s0,-62
    800032a2:	ffffd097          	auipc	ra,0xffffd
    800032a6:	fe4080e7          	jalr	-28(ra) # 80000286 <strncpy>
  de.inum = inum;
    800032aa:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032ae:	4741                	li	a4,16
    800032b0:	86a6                	mv	a3,s1
    800032b2:	fc040613          	addi	a2,s0,-64
    800032b6:	4581                	li	a1,0
    800032b8:	854a                	mv	a0,s2
    800032ba:	00000097          	auipc	ra,0x0
    800032be:	c3e080e7          	jalr	-962(ra) # 80002ef8 <writei>
    800032c2:	1541                	addi	a0,a0,-16
    800032c4:	00a03533          	snez	a0,a0
    800032c8:	40a00533          	neg	a0,a0
}
    800032cc:	70e2                	ld	ra,56(sp)
    800032ce:	7442                	ld	s0,48(sp)
    800032d0:	74a2                	ld	s1,40(sp)
    800032d2:	7902                	ld	s2,32(sp)
    800032d4:	69e2                	ld	s3,24(sp)
    800032d6:	6a42                	ld	s4,16(sp)
    800032d8:	6121                	addi	sp,sp,64
    800032da:	8082                	ret
    iput(ip);
    800032dc:	00000097          	auipc	ra,0x0
    800032e0:	a2a080e7          	jalr	-1494(ra) # 80002d06 <iput>
    return -1;
    800032e4:	557d                	li	a0,-1
    800032e6:	b7dd                	j	800032cc <dirlink+0x86>
      panic("dirlink read");
    800032e8:	00006517          	auipc	a0,0x6
    800032ec:	30050513          	addi	a0,a0,768 # 800095e8 <syscalls+0x208>
    800032f0:	00004097          	auipc	ra,0x4
    800032f4:	8ea080e7          	jalr	-1814(ra) # 80006bda <panic>

00000000800032f8 <namei>:

struct inode*
namei(char *path)
{
    800032f8:	1101                	addi	sp,sp,-32
    800032fa:	ec06                	sd	ra,24(sp)
    800032fc:	e822                	sd	s0,16(sp)
    800032fe:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003300:	fe040613          	addi	a2,s0,-32
    80003304:	4581                	li	a1,0
    80003306:	00000097          	auipc	ra,0x0
    8000330a:	dda080e7          	jalr	-550(ra) # 800030e0 <namex>
}
    8000330e:	60e2                	ld	ra,24(sp)
    80003310:	6442                	ld	s0,16(sp)
    80003312:	6105                	addi	sp,sp,32
    80003314:	8082                	ret

0000000080003316 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003316:	1141                	addi	sp,sp,-16
    80003318:	e406                	sd	ra,8(sp)
    8000331a:	e022                	sd	s0,0(sp)
    8000331c:	0800                	addi	s0,sp,16
    8000331e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003320:	4585                	li	a1,1
    80003322:	00000097          	auipc	ra,0x0
    80003326:	dbe080e7          	jalr	-578(ra) # 800030e0 <namex>
}
    8000332a:	60a2                	ld	ra,8(sp)
    8000332c:	6402                	ld	s0,0(sp)
    8000332e:	0141                	addi	sp,sp,16
    80003330:	8082                	ret

0000000080003332 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003332:	1101                	addi	sp,sp,-32
    80003334:	ec06                	sd	ra,24(sp)
    80003336:	e822                	sd	s0,16(sp)
    80003338:	e426                	sd	s1,8(sp)
    8000333a:	e04a                	sd	s2,0(sp)
    8000333c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000333e:	00016917          	auipc	s2,0x16
    80003342:	64290913          	addi	s2,s2,1602 # 80019980 <log>
    80003346:	01892583          	lw	a1,24(s2)
    8000334a:	02892503          	lw	a0,40(s2)
    8000334e:	fffff097          	auipc	ra,0xfffff
    80003352:	fe6080e7          	jalr	-26(ra) # 80002334 <bread>
    80003356:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003358:	02c92683          	lw	a3,44(s2)
    8000335c:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000335e:	02d05863          	blez	a3,8000338e <write_head+0x5c>
    80003362:	00016797          	auipc	a5,0x16
    80003366:	64e78793          	addi	a5,a5,1614 # 800199b0 <log+0x30>
    8000336a:	05c50713          	addi	a4,a0,92
    8000336e:	36fd                	addiw	a3,a3,-1
    80003370:	02069613          	slli	a2,a3,0x20
    80003374:	01e65693          	srli	a3,a2,0x1e
    80003378:	00016617          	auipc	a2,0x16
    8000337c:	63c60613          	addi	a2,a2,1596 # 800199b4 <log+0x34>
    80003380:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003382:	4390                	lw	a2,0(a5)
    80003384:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003386:	0791                	addi	a5,a5,4
    80003388:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    8000338a:	fed79ce3          	bne	a5,a3,80003382 <write_head+0x50>
  }
  bwrite(buf);
    8000338e:	8526                	mv	a0,s1
    80003390:	fffff097          	auipc	ra,0xfffff
    80003394:	096080e7          	jalr	150(ra) # 80002426 <bwrite>
  brelse(buf);
    80003398:	8526                	mv	a0,s1
    8000339a:	fffff097          	auipc	ra,0xfffff
    8000339e:	0ca080e7          	jalr	202(ra) # 80002464 <brelse>
}
    800033a2:	60e2                	ld	ra,24(sp)
    800033a4:	6442                	ld	s0,16(sp)
    800033a6:	64a2                	ld	s1,8(sp)
    800033a8:	6902                	ld	s2,0(sp)
    800033aa:	6105                	addi	sp,sp,32
    800033ac:	8082                	ret

00000000800033ae <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800033ae:	00016797          	auipc	a5,0x16
    800033b2:	5fe7a783          	lw	a5,1534(a5) # 800199ac <log+0x2c>
    800033b6:	0af05d63          	blez	a5,80003470 <install_trans+0xc2>
{
    800033ba:	7139                	addi	sp,sp,-64
    800033bc:	fc06                	sd	ra,56(sp)
    800033be:	f822                	sd	s0,48(sp)
    800033c0:	f426                	sd	s1,40(sp)
    800033c2:	f04a                	sd	s2,32(sp)
    800033c4:	ec4e                	sd	s3,24(sp)
    800033c6:	e852                	sd	s4,16(sp)
    800033c8:	e456                	sd	s5,8(sp)
    800033ca:	e05a                	sd	s6,0(sp)
    800033cc:	0080                	addi	s0,sp,64
    800033ce:	8b2a                	mv	s6,a0
    800033d0:	00016a97          	auipc	s5,0x16
    800033d4:	5e0a8a93          	addi	s5,s5,1504 # 800199b0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033d8:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033da:	00016997          	auipc	s3,0x16
    800033de:	5a698993          	addi	s3,s3,1446 # 80019980 <log>
    800033e2:	a00d                	j	80003404 <install_trans+0x56>
    brelse(lbuf);
    800033e4:	854a                	mv	a0,s2
    800033e6:	fffff097          	auipc	ra,0xfffff
    800033ea:	07e080e7          	jalr	126(ra) # 80002464 <brelse>
    brelse(dbuf);
    800033ee:	8526                	mv	a0,s1
    800033f0:	fffff097          	auipc	ra,0xfffff
    800033f4:	074080e7          	jalr	116(ra) # 80002464 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033f8:	2a05                	addiw	s4,s4,1
    800033fa:	0a91                	addi	s5,s5,4
    800033fc:	02c9a783          	lw	a5,44(s3)
    80003400:	04fa5e63          	bge	s4,a5,8000345c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003404:	0189a583          	lw	a1,24(s3)
    80003408:	014585bb          	addw	a1,a1,s4
    8000340c:	2585                	addiw	a1,a1,1
    8000340e:	0289a503          	lw	a0,40(s3)
    80003412:	fffff097          	auipc	ra,0xfffff
    80003416:	f22080e7          	jalr	-222(ra) # 80002334 <bread>
    8000341a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000341c:	000aa583          	lw	a1,0(s5)
    80003420:	0289a503          	lw	a0,40(s3)
    80003424:	fffff097          	auipc	ra,0xfffff
    80003428:	f10080e7          	jalr	-240(ra) # 80002334 <bread>
    8000342c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000342e:	40000613          	li	a2,1024
    80003432:	05890593          	addi	a1,s2,88
    80003436:	05850513          	addi	a0,a0,88
    8000343a:	ffffd097          	auipc	ra,0xffffd
    8000343e:	d9c080e7          	jalr	-612(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003442:	8526                	mv	a0,s1
    80003444:	fffff097          	auipc	ra,0xfffff
    80003448:	fe2080e7          	jalr	-30(ra) # 80002426 <bwrite>
    if(recovering == 0)
    8000344c:	f80b1ce3          	bnez	s6,800033e4 <install_trans+0x36>
      bunpin(dbuf);
    80003450:	8526                	mv	a0,s1
    80003452:	fffff097          	auipc	ra,0xfffff
    80003456:	0ec080e7          	jalr	236(ra) # 8000253e <bunpin>
    8000345a:	b769                	j	800033e4 <install_trans+0x36>
}
    8000345c:	70e2                	ld	ra,56(sp)
    8000345e:	7442                	ld	s0,48(sp)
    80003460:	74a2                	ld	s1,40(sp)
    80003462:	7902                	ld	s2,32(sp)
    80003464:	69e2                	ld	s3,24(sp)
    80003466:	6a42                	ld	s4,16(sp)
    80003468:	6aa2                	ld	s5,8(sp)
    8000346a:	6b02                	ld	s6,0(sp)
    8000346c:	6121                	addi	sp,sp,64
    8000346e:	8082                	ret
    80003470:	8082                	ret

0000000080003472 <initlog>:
{
    80003472:	7179                	addi	sp,sp,-48
    80003474:	f406                	sd	ra,40(sp)
    80003476:	f022                	sd	s0,32(sp)
    80003478:	ec26                	sd	s1,24(sp)
    8000347a:	e84a                	sd	s2,16(sp)
    8000347c:	e44e                	sd	s3,8(sp)
    8000347e:	1800                	addi	s0,sp,48
    80003480:	892a                	mv	s2,a0
    80003482:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003484:	00016497          	auipc	s1,0x16
    80003488:	4fc48493          	addi	s1,s1,1276 # 80019980 <log>
    8000348c:	00006597          	auipc	a1,0x6
    80003490:	16c58593          	addi	a1,a1,364 # 800095f8 <syscalls+0x218>
    80003494:	8526                	mv	a0,s1
    80003496:	00004097          	auipc	ra,0x4
    8000349a:	bec080e7          	jalr	-1044(ra) # 80007082 <initlock>
  log.start = sb->logstart;
    8000349e:	0149a583          	lw	a1,20(s3)
    800034a2:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800034a4:	0109a783          	lw	a5,16(s3)
    800034a8:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800034aa:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800034ae:	854a                	mv	a0,s2
    800034b0:	fffff097          	auipc	ra,0xfffff
    800034b4:	e84080e7          	jalr	-380(ra) # 80002334 <bread>
  log.lh.n = lh->n;
    800034b8:	4d34                	lw	a3,88(a0)
    800034ba:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800034bc:	02d05663          	blez	a3,800034e8 <initlog+0x76>
    800034c0:	05c50793          	addi	a5,a0,92
    800034c4:	00016717          	auipc	a4,0x16
    800034c8:	4ec70713          	addi	a4,a4,1260 # 800199b0 <log+0x30>
    800034cc:	36fd                	addiw	a3,a3,-1
    800034ce:	02069613          	slli	a2,a3,0x20
    800034d2:	01e65693          	srli	a3,a2,0x1e
    800034d6:	06050613          	addi	a2,a0,96
    800034da:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800034dc:	4390                	lw	a2,0(a5)
    800034de:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034e0:	0791                	addi	a5,a5,4
    800034e2:	0711                	addi	a4,a4,4
    800034e4:	fed79ce3          	bne	a5,a3,800034dc <initlog+0x6a>
  brelse(buf);
    800034e8:	fffff097          	auipc	ra,0xfffff
    800034ec:	f7c080e7          	jalr	-132(ra) # 80002464 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800034f0:	4505                	li	a0,1
    800034f2:	00000097          	auipc	ra,0x0
    800034f6:	ebc080e7          	jalr	-324(ra) # 800033ae <install_trans>
  log.lh.n = 0;
    800034fa:	00016797          	auipc	a5,0x16
    800034fe:	4a07a923          	sw	zero,1202(a5) # 800199ac <log+0x2c>
  write_head(); // clear the log
    80003502:	00000097          	auipc	ra,0x0
    80003506:	e30080e7          	jalr	-464(ra) # 80003332 <write_head>
}
    8000350a:	70a2                	ld	ra,40(sp)
    8000350c:	7402                	ld	s0,32(sp)
    8000350e:	64e2                	ld	s1,24(sp)
    80003510:	6942                	ld	s2,16(sp)
    80003512:	69a2                	ld	s3,8(sp)
    80003514:	6145                	addi	sp,sp,48
    80003516:	8082                	ret

0000000080003518 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003518:	1101                	addi	sp,sp,-32
    8000351a:	ec06                	sd	ra,24(sp)
    8000351c:	e822                	sd	s0,16(sp)
    8000351e:	e426                	sd	s1,8(sp)
    80003520:	e04a                	sd	s2,0(sp)
    80003522:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003524:	00016517          	auipc	a0,0x16
    80003528:	45c50513          	addi	a0,a0,1116 # 80019980 <log>
    8000352c:	00004097          	auipc	ra,0x4
    80003530:	be6080e7          	jalr	-1050(ra) # 80007112 <acquire>
  while(1){
    if(log.committing){
    80003534:	00016497          	auipc	s1,0x16
    80003538:	44c48493          	addi	s1,s1,1100 # 80019980 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000353c:	4979                	li	s2,30
    8000353e:	a039                	j	8000354c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003540:	85a6                	mv	a1,s1
    80003542:	8526                	mv	a0,s1
    80003544:	ffffe097          	auipc	ra,0xffffe
    80003548:	010080e7          	jalr	16(ra) # 80001554 <sleep>
    if(log.committing){
    8000354c:	50dc                	lw	a5,36(s1)
    8000354e:	fbed                	bnez	a5,80003540 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003550:	5098                	lw	a4,32(s1)
    80003552:	2705                	addiw	a4,a4,1
    80003554:	0007069b          	sext.w	a3,a4
    80003558:	0027179b          	slliw	a5,a4,0x2
    8000355c:	9fb9                	addw	a5,a5,a4
    8000355e:	0017979b          	slliw	a5,a5,0x1
    80003562:	54d8                	lw	a4,44(s1)
    80003564:	9fb9                	addw	a5,a5,a4
    80003566:	00f95963          	bge	s2,a5,80003578 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000356a:	85a6                	mv	a1,s1
    8000356c:	8526                	mv	a0,s1
    8000356e:	ffffe097          	auipc	ra,0xffffe
    80003572:	fe6080e7          	jalr	-26(ra) # 80001554 <sleep>
    80003576:	bfd9                	j	8000354c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003578:	00016517          	auipc	a0,0x16
    8000357c:	40850513          	addi	a0,a0,1032 # 80019980 <log>
    80003580:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003582:	00004097          	auipc	ra,0x4
    80003586:	c44080e7          	jalr	-956(ra) # 800071c6 <release>
      break;
    }
  }
}
    8000358a:	60e2                	ld	ra,24(sp)
    8000358c:	6442                	ld	s0,16(sp)
    8000358e:	64a2                	ld	s1,8(sp)
    80003590:	6902                	ld	s2,0(sp)
    80003592:	6105                	addi	sp,sp,32
    80003594:	8082                	ret

0000000080003596 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003596:	7139                	addi	sp,sp,-64
    80003598:	fc06                	sd	ra,56(sp)
    8000359a:	f822                	sd	s0,48(sp)
    8000359c:	f426                	sd	s1,40(sp)
    8000359e:	f04a                	sd	s2,32(sp)
    800035a0:	ec4e                	sd	s3,24(sp)
    800035a2:	e852                	sd	s4,16(sp)
    800035a4:	e456                	sd	s5,8(sp)
    800035a6:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800035a8:	00016497          	auipc	s1,0x16
    800035ac:	3d848493          	addi	s1,s1,984 # 80019980 <log>
    800035b0:	8526                	mv	a0,s1
    800035b2:	00004097          	auipc	ra,0x4
    800035b6:	b60080e7          	jalr	-1184(ra) # 80007112 <acquire>
  log.outstanding -= 1;
    800035ba:	509c                	lw	a5,32(s1)
    800035bc:	37fd                	addiw	a5,a5,-1
    800035be:	0007891b          	sext.w	s2,a5
    800035c2:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800035c4:	50dc                	lw	a5,36(s1)
    800035c6:	e7b9                	bnez	a5,80003614 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800035c8:	04091e63          	bnez	s2,80003624 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800035cc:	00016497          	auipc	s1,0x16
    800035d0:	3b448493          	addi	s1,s1,948 # 80019980 <log>
    800035d4:	4785                	li	a5,1
    800035d6:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800035d8:	8526                	mv	a0,s1
    800035da:	00004097          	auipc	ra,0x4
    800035de:	bec080e7          	jalr	-1044(ra) # 800071c6 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800035e2:	54dc                	lw	a5,44(s1)
    800035e4:	06f04763          	bgtz	a5,80003652 <end_op+0xbc>
    acquire(&log.lock);
    800035e8:	00016497          	auipc	s1,0x16
    800035ec:	39848493          	addi	s1,s1,920 # 80019980 <log>
    800035f0:	8526                	mv	a0,s1
    800035f2:	00004097          	auipc	ra,0x4
    800035f6:	b20080e7          	jalr	-1248(ra) # 80007112 <acquire>
    log.committing = 0;
    800035fa:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800035fe:	8526                	mv	a0,s1
    80003600:	ffffe097          	auipc	ra,0xffffe
    80003604:	fb8080e7          	jalr	-72(ra) # 800015b8 <wakeup>
    release(&log.lock);
    80003608:	8526                	mv	a0,s1
    8000360a:	00004097          	auipc	ra,0x4
    8000360e:	bbc080e7          	jalr	-1092(ra) # 800071c6 <release>
}
    80003612:	a03d                	j	80003640 <end_op+0xaa>
    panic("log.committing");
    80003614:	00006517          	auipc	a0,0x6
    80003618:	fec50513          	addi	a0,a0,-20 # 80009600 <syscalls+0x220>
    8000361c:	00003097          	auipc	ra,0x3
    80003620:	5be080e7          	jalr	1470(ra) # 80006bda <panic>
    wakeup(&log);
    80003624:	00016497          	auipc	s1,0x16
    80003628:	35c48493          	addi	s1,s1,860 # 80019980 <log>
    8000362c:	8526                	mv	a0,s1
    8000362e:	ffffe097          	auipc	ra,0xffffe
    80003632:	f8a080e7          	jalr	-118(ra) # 800015b8 <wakeup>
  release(&log.lock);
    80003636:	8526                	mv	a0,s1
    80003638:	00004097          	auipc	ra,0x4
    8000363c:	b8e080e7          	jalr	-1138(ra) # 800071c6 <release>
}
    80003640:	70e2                	ld	ra,56(sp)
    80003642:	7442                	ld	s0,48(sp)
    80003644:	74a2                	ld	s1,40(sp)
    80003646:	7902                	ld	s2,32(sp)
    80003648:	69e2                	ld	s3,24(sp)
    8000364a:	6a42                	ld	s4,16(sp)
    8000364c:	6aa2                	ld	s5,8(sp)
    8000364e:	6121                	addi	sp,sp,64
    80003650:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003652:	00016a97          	auipc	s5,0x16
    80003656:	35ea8a93          	addi	s5,s5,862 # 800199b0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000365a:	00016a17          	auipc	s4,0x16
    8000365e:	326a0a13          	addi	s4,s4,806 # 80019980 <log>
    80003662:	018a2583          	lw	a1,24(s4)
    80003666:	012585bb          	addw	a1,a1,s2
    8000366a:	2585                	addiw	a1,a1,1
    8000366c:	028a2503          	lw	a0,40(s4)
    80003670:	fffff097          	auipc	ra,0xfffff
    80003674:	cc4080e7          	jalr	-828(ra) # 80002334 <bread>
    80003678:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000367a:	000aa583          	lw	a1,0(s5)
    8000367e:	028a2503          	lw	a0,40(s4)
    80003682:	fffff097          	auipc	ra,0xfffff
    80003686:	cb2080e7          	jalr	-846(ra) # 80002334 <bread>
    8000368a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000368c:	40000613          	li	a2,1024
    80003690:	05850593          	addi	a1,a0,88
    80003694:	05848513          	addi	a0,s1,88
    80003698:	ffffd097          	auipc	ra,0xffffd
    8000369c:	b3e080e7          	jalr	-1218(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    800036a0:	8526                	mv	a0,s1
    800036a2:	fffff097          	auipc	ra,0xfffff
    800036a6:	d84080e7          	jalr	-636(ra) # 80002426 <bwrite>
    brelse(from);
    800036aa:	854e                	mv	a0,s3
    800036ac:	fffff097          	auipc	ra,0xfffff
    800036b0:	db8080e7          	jalr	-584(ra) # 80002464 <brelse>
    brelse(to);
    800036b4:	8526                	mv	a0,s1
    800036b6:	fffff097          	auipc	ra,0xfffff
    800036ba:	dae080e7          	jalr	-594(ra) # 80002464 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036be:	2905                	addiw	s2,s2,1
    800036c0:	0a91                	addi	s5,s5,4
    800036c2:	02ca2783          	lw	a5,44(s4)
    800036c6:	f8f94ee3          	blt	s2,a5,80003662 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800036ca:	00000097          	auipc	ra,0x0
    800036ce:	c68080e7          	jalr	-920(ra) # 80003332 <write_head>
    install_trans(0); // Now install writes to home locations
    800036d2:	4501                	li	a0,0
    800036d4:	00000097          	auipc	ra,0x0
    800036d8:	cda080e7          	jalr	-806(ra) # 800033ae <install_trans>
    log.lh.n = 0;
    800036dc:	00016797          	auipc	a5,0x16
    800036e0:	2c07a823          	sw	zero,720(a5) # 800199ac <log+0x2c>
    write_head();    // Erase the transaction from the log
    800036e4:	00000097          	auipc	ra,0x0
    800036e8:	c4e080e7          	jalr	-946(ra) # 80003332 <write_head>
    800036ec:	bdf5                	j	800035e8 <end_op+0x52>

00000000800036ee <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800036ee:	1101                	addi	sp,sp,-32
    800036f0:	ec06                	sd	ra,24(sp)
    800036f2:	e822                	sd	s0,16(sp)
    800036f4:	e426                	sd	s1,8(sp)
    800036f6:	e04a                	sd	s2,0(sp)
    800036f8:	1000                	addi	s0,sp,32
    800036fa:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800036fc:	00016917          	auipc	s2,0x16
    80003700:	28490913          	addi	s2,s2,644 # 80019980 <log>
    80003704:	854a                	mv	a0,s2
    80003706:	00004097          	auipc	ra,0x4
    8000370a:	a0c080e7          	jalr	-1524(ra) # 80007112 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000370e:	02c92603          	lw	a2,44(s2)
    80003712:	47f5                	li	a5,29
    80003714:	06c7c563          	blt	a5,a2,8000377e <log_write+0x90>
    80003718:	00016797          	auipc	a5,0x16
    8000371c:	2847a783          	lw	a5,644(a5) # 8001999c <log+0x1c>
    80003720:	37fd                	addiw	a5,a5,-1
    80003722:	04f65e63          	bge	a2,a5,8000377e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003726:	00016797          	auipc	a5,0x16
    8000372a:	27a7a783          	lw	a5,634(a5) # 800199a0 <log+0x20>
    8000372e:	06f05063          	blez	a5,8000378e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003732:	4781                	li	a5,0
    80003734:	06c05563          	blez	a2,8000379e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003738:	44cc                	lw	a1,12(s1)
    8000373a:	00016717          	auipc	a4,0x16
    8000373e:	27670713          	addi	a4,a4,630 # 800199b0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003742:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003744:	4314                	lw	a3,0(a4)
    80003746:	04b68c63          	beq	a3,a1,8000379e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000374a:	2785                	addiw	a5,a5,1
    8000374c:	0711                	addi	a4,a4,4
    8000374e:	fef61be3          	bne	a2,a5,80003744 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003752:	0621                	addi	a2,a2,8
    80003754:	060a                	slli	a2,a2,0x2
    80003756:	00016797          	auipc	a5,0x16
    8000375a:	22a78793          	addi	a5,a5,554 # 80019980 <log>
    8000375e:	97b2                	add	a5,a5,a2
    80003760:	44d8                	lw	a4,12(s1)
    80003762:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003764:	8526                	mv	a0,s1
    80003766:	fffff097          	auipc	ra,0xfffff
    8000376a:	d9c080e7          	jalr	-612(ra) # 80002502 <bpin>
    log.lh.n++;
    8000376e:	00016717          	auipc	a4,0x16
    80003772:	21270713          	addi	a4,a4,530 # 80019980 <log>
    80003776:	575c                	lw	a5,44(a4)
    80003778:	2785                	addiw	a5,a5,1
    8000377a:	d75c                	sw	a5,44(a4)
    8000377c:	a82d                	j	800037b6 <log_write+0xc8>
    panic("too big a transaction");
    8000377e:	00006517          	auipc	a0,0x6
    80003782:	e9250513          	addi	a0,a0,-366 # 80009610 <syscalls+0x230>
    80003786:	00003097          	auipc	ra,0x3
    8000378a:	454080e7          	jalr	1108(ra) # 80006bda <panic>
    panic("log_write outside of trans");
    8000378e:	00006517          	auipc	a0,0x6
    80003792:	e9a50513          	addi	a0,a0,-358 # 80009628 <syscalls+0x248>
    80003796:	00003097          	auipc	ra,0x3
    8000379a:	444080e7          	jalr	1092(ra) # 80006bda <panic>
  log.lh.block[i] = b->blockno;
    8000379e:	00878693          	addi	a3,a5,8
    800037a2:	068a                	slli	a3,a3,0x2
    800037a4:	00016717          	auipc	a4,0x16
    800037a8:	1dc70713          	addi	a4,a4,476 # 80019980 <log>
    800037ac:	9736                	add	a4,a4,a3
    800037ae:	44d4                	lw	a3,12(s1)
    800037b0:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800037b2:	faf609e3          	beq	a2,a5,80003764 <log_write+0x76>
  }
  release(&log.lock);
    800037b6:	00016517          	auipc	a0,0x16
    800037ba:	1ca50513          	addi	a0,a0,458 # 80019980 <log>
    800037be:	00004097          	auipc	ra,0x4
    800037c2:	a08080e7          	jalr	-1528(ra) # 800071c6 <release>
}
    800037c6:	60e2                	ld	ra,24(sp)
    800037c8:	6442                	ld	s0,16(sp)
    800037ca:	64a2                	ld	s1,8(sp)
    800037cc:	6902                	ld	s2,0(sp)
    800037ce:	6105                	addi	sp,sp,32
    800037d0:	8082                	ret

00000000800037d2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800037d2:	1101                	addi	sp,sp,-32
    800037d4:	ec06                	sd	ra,24(sp)
    800037d6:	e822                	sd	s0,16(sp)
    800037d8:	e426                	sd	s1,8(sp)
    800037da:	e04a                	sd	s2,0(sp)
    800037dc:	1000                	addi	s0,sp,32
    800037de:	84aa                	mv	s1,a0
    800037e0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800037e2:	00006597          	auipc	a1,0x6
    800037e6:	e6658593          	addi	a1,a1,-410 # 80009648 <syscalls+0x268>
    800037ea:	0521                	addi	a0,a0,8
    800037ec:	00004097          	auipc	ra,0x4
    800037f0:	896080e7          	jalr	-1898(ra) # 80007082 <initlock>
  lk->name = name;
    800037f4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800037f8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800037fc:	0204a423          	sw	zero,40(s1)
}
    80003800:	60e2                	ld	ra,24(sp)
    80003802:	6442                	ld	s0,16(sp)
    80003804:	64a2                	ld	s1,8(sp)
    80003806:	6902                	ld	s2,0(sp)
    80003808:	6105                	addi	sp,sp,32
    8000380a:	8082                	ret

000000008000380c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000380c:	1101                	addi	sp,sp,-32
    8000380e:	ec06                	sd	ra,24(sp)
    80003810:	e822                	sd	s0,16(sp)
    80003812:	e426                	sd	s1,8(sp)
    80003814:	e04a                	sd	s2,0(sp)
    80003816:	1000                	addi	s0,sp,32
    80003818:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000381a:	00850913          	addi	s2,a0,8
    8000381e:	854a                	mv	a0,s2
    80003820:	00004097          	auipc	ra,0x4
    80003824:	8f2080e7          	jalr	-1806(ra) # 80007112 <acquire>
  while (lk->locked) {
    80003828:	409c                	lw	a5,0(s1)
    8000382a:	cb89                	beqz	a5,8000383c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000382c:	85ca                	mv	a1,s2
    8000382e:	8526                	mv	a0,s1
    80003830:	ffffe097          	auipc	ra,0xffffe
    80003834:	d24080e7          	jalr	-732(ra) # 80001554 <sleep>
  while (lk->locked) {
    80003838:	409c                	lw	a5,0(s1)
    8000383a:	fbed                	bnez	a5,8000382c <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000383c:	4785                	li	a5,1
    8000383e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003840:	ffffd097          	auipc	ra,0xffffd
    80003844:	66c080e7          	jalr	1644(ra) # 80000eac <myproc>
    80003848:	591c                	lw	a5,48(a0)
    8000384a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000384c:	854a                	mv	a0,s2
    8000384e:	00004097          	auipc	ra,0x4
    80003852:	978080e7          	jalr	-1672(ra) # 800071c6 <release>
}
    80003856:	60e2                	ld	ra,24(sp)
    80003858:	6442                	ld	s0,16(sp)
    8000385a:	64a2                	ld	s1,8(sp)
    8000385c:	6902                	ld	s2,0(sp)
    8000385e:	6105                	addi	sp,sp,32
    80003860:	8082                	ret

0000000080003862 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003862:	1101                	addi	sp,sp,-32
    80003864:	ec06                	sd	ra,24(sp)
    80003866:	e822                	sd	s0,16(sp)
    80003868:	e426                	sd	s1,8(sp)
    8000386a:	e04a                	sd	s2,0(sp)
    8000386c:	1000                	addi	s0,sp,32
    8000386e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003870:	00850913          	addi	s2,a0,8
    80003874:	854a                	mv	a0,s2
    80003876:	00004097          	auipc	ra,0x4
    8000387a:	89c080e7          	jalr	-1892(ra) # 80007112 <acquire>
  lk->locked = 0;
    8000387e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003882:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003886:	8526                	mv	a0,s1
    80003888:	ffffe097          	auipc	ra,0xffffe
    8000388c:	d30080e7          	jalr	-720(ra) # 800015b8 <wakeup>
  release(&lk->lk);
    80003890:	854a                	mv	a0,s2
    80003892:	00004097          	auipc	ra,0x4
    80003896:	934080e7          	jalr	-1740(ra) # 800071c6 <release>
}
    8000389a:	60e2                	ld	ra,24(sp)
    8000389c:	6442                	ld	s0,16(sp)
    8000389e:	64a2                	ld	s1,8(sp)
    800038a0:	6902                	ld	s2,0(sp)
    800038a2:	6105                	addi	sp,sp,32
    800038a4:	8082                	ret

00000000800038a6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800038a6:	7179                	addi	sp,sp,-48
    800038a8:	f406                	sd	ra,40(sp)
    800038aa:	f022                	sd	s0,32(sp)
    800038ac:	ec26                	sd	s1,24(sp)
    800038ae:	e84a                	sd	s2,16(sp)
    800038b0:	e44e                	sd	s3,8(sp)
    800038b2:	1800                	addi	s0,sp,48
    800038b4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800038b6:	00850913          	addi	s2,a0,8
    800038ba:	854a                	mv	a0,s2
    800038bc:	00004097          	auipc	ra,0x4
    800038c0:	856080e7          	jalr	-1962(ra) # 80007112 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800038c4:	409c                	lw	a5,0(s1)
    800038c6:	ef99                	bnez	a5,800038e4 <holdingsleep+0x3e>
    800038c8:	4481                	li	s1,0
  release(&lk->lk);
    800038ca:	854a                	mv	a0,s2
    800038cc:	00004097          	auipc	ra,0x4
    800038d0:	8fa080e7          	jalr	-1798(ra) # 800071c6 <release>
  return r;
}
    800038d4:	8526                	mv	a0,s1
    800038d6:	70a2                	ld	ra,40(sp)
    800038d8:	7402                	ld	s0,32(sp)
    800038da:	64e2                	ld	s1,24(sp)
    800038dc:	6942                	ld	s2,16(sp)
    800038de:	69a2                	ld	s3,8(sp)
    800038e0:	6145                	addi	sp,sp,48
    800038e2:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800038e4:	0284a983          	lw	s3,40(s1)
    800038e8:	ffffd097          	auipc	ra,0xffffd
    800038ec:	5c4080e7          	jalr	1476(ra) # 80000eac <myproc>
    800038f0:	5904                	lw	s1,48(a0)
    800038f2:	413484b3          	sub	s1,s1,s3
    800038f6:	0014b493          	seqz	s1,s1
    800038fa:	bfc1                	j	800038ca <holdingsleep+0x24>

00000000800038fc <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800038fc:	1141                	addi	sp,sp,-16
    800038fe:	e406                	sd	ra,8(sp)
    80003900:	e022                	sd	s0,0(sp)
    80003902:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003904:	00006597          	auipc	a1,0x6
    80003908:	d5458593          	addi	a1,a1,-684 # 80009658 <syscalls+0x278>
    8000390c:	00016517          	auipc	a0,0x16
    80003910:	1bc50513          	addi	a0,a0,444 # 80019ac8 <ftable>
    80003914:	00003097          	auipc	ra,0x3
    80003918:	76e080e7          	jalr	1902(ra) # 80007082 <initlock>
}
    8000391c:	60a2                	ld	ra,8(sp)
    8000391e:	6402                	ld	s0,0(sp)
    80003920:	0141                	addi	sp,sp,16
    80003922:	8082                	ret

0000000080003924 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003924:	1101                	addi	sp,sp,-32
    80003926:	ec06                	sd	ra,24(sp)
    80003928:	e822                	sd	s0,16(sp)
    8000392a:	e426                	sd	s1,8(sp)
    8000392c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000392e:	00016517          	auipc	a0,0x16
    80003932:	19a50513          	addi	a0,a0,410 # 80019ac8 <ftable>
    80003936:	00003097          	auipc	ra,0x3
    8000393a:	7dc080e7          	jalr	2012(ra) # 80007112 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000393e:	00016497          	auipc	s1,0x16
    80003942:	1a248493          	addi	s1,s1,418 # 80019ae0 <ftable+0x18>
    80003946:	00017717          	auipc	a4,0x17
    8000394a:	45a70713          	addi	a4,a4,1114 # 8001ada0 <disk>
    if(f->ref == 0){
    8000394e:	40dc                	lw	a5,4(s1)
    80003950:	cf99                	beqz	a5,8000396e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003952:	03048493          	addi	s1,s1,48
    80003956:	fee49ce3          	bne	s1,a4,8000394e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000395a:	00016517          	auipc	a0,0x16
    8000395e:	16e50513          	addi	a0,a0,366 # 80019ac8 <ftable>
    80003962:	00004097          	auipc	ra,0x4
    80003966:	864080e7          	jalr	-1948(ra) # 800071c6 <release>
  return 0;
    8000396a:	4481                	li	s1,0
    8000396c:	a819                	j	80003982 <filealloc+0x5e>
      f->ref = 1;
    8000396e:	4785                	li	a5,1
    80003970:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003972:	00016517          	auipc	a0,0x16
    80003976:	15650513          	addi	a0,a0,342 # 80019ac8 <ftable>
    8000397a:	00004097          	auipc	ra,0x4
    8000397e:	84c080e7          	jalr	-1972(ra) # 800071c6 <release>
}
    80003982:	8526                	mv	a0,s1
    80003984:	60e2                	ld	ra,24(sp)
    80003986:	6442                	ld	s0,16(sp)
    80003988:	64a2                	ld	s1,8(sp)
    8000398a:	6105                	addi	sp,sp,32
    8000398c:	8082                	ret

000000008000398e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000398e:	1101                	addi	sp,sp,-32
    80003990:	ec06                	sd	ra,24(sp)
    80003992:	e822                	sd	s0,16(sp)
    80003994:	e426                	sd	s1,8(sp)
    80003996:	1000                	addi	s0,sp,32
    80003998:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000399a:	00016517          	auipc	a0,0x16
    8000399e:	12e50513          	addi	a0,a0,302 # 80019ac8 <ftable>
    800039a2:	00003097          	auipc	ra,0x3
    800039a6:	770080e7          	jalr	1904(ra) # 80007112 <acquire>
  if(f->ref < 1)
    800039aa:	40dc                	lw	a5,4(s1)
    800039ac:	02f05263          	blez	a5,800039d0 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800039b0:	2785                	addiw	a5,a5,1
    800039b2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800039b4:	00016517          	auipc	a0,0x16
    800039b8:	11450513          	addi	a0,a0,276 # 80019ac8 <ftable>
    800039bc:	00004097          	auipc	ra,0x4
    800039c0:	80a080e7          	jalr	-2038(ra) # 800071c6 <release>
  return f;
}
    800039c4:	8526                	mv	a0,s1
    800039c6:	60e2                	ld	ra,24(sp)
    800039c8:	6442                	ld	s0,16(sp)
    800039ca:	64a2                	ld	s1,8(sp)
    800039cc:	6105                	addi	sp,sp,32
    800039ce:	8082                	ret
    panic("filedup");
    800039d0:	00006517          	auipc	a0,0x6
    800039d4:	c9050513          	addi	a0,a0,-880 # 80009660 <syscalls+0x280>
    800039d8:	00003097          	auipc	ra,0x3
    800039dc:	202080e7          	jalr	514(ra) # 80006bda <panic>

00000000800039e0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800039e0:	7139                	addi	sp,sp,-64
    800039e2:	fc06                	sd	ra,56(sp)
    800039e4:	f822                	sd	s0,48(sp)
    800039e6:	f426                	sd	s1,40(sp)
    800039e8:	f04a                	sd	s2,32(sp)
    800039ea:	ec4e                	sd	s3,24(sp)
    800039ec:	e852                	sd	s4,16(sp)
    800039ee:	e456                	sd	s5,8(sp)
    800039f0:	e05a                	sd	s6,0(sp)
    800039f2:	0080                	addi	s0,sp,64
    800039f4:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800039f6:	00016517          	auipc	a0,0x16
    800039fa:	0d250513          	addi	a0,a0,210 # 80019ac8 <ftable>
    800039fe:	00003097          	auipc	ra,0x3
    80003a02:	714080e7          	jalr	1812(ra) # 80007112 <acquire>
  if(f->ref < 1)
    80003a06:	40dc                	lw	a5,4(s1)
    80003a08:	04f05f63          	blez	a5,80003a66 <fileclose+0x86>
    panic("fileclose");
  if(--f->ref > 0){
    80003a0c:	37fd                	addiw	a5,a5,-1
    80003a0e:	0007871b          	sext.w	a4,a5
    80003a12:	c0dc                	sw	a5,4(s1)
    80003a14:	06e04163          	bgtz	a4,80003a76 <fileclose+0x96>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a18:	0004a903          	lw	s2,0(s1)
    80003a1c:	0094ca83          	lbu	s5,9(s1)
    80003a20:	0104ba03          	ld	s4,16(s1)
    80003a24:	0184b983          	ld	s3,24(s1)
    80003a28:	0204bb03          	ld	s6,32(s1)
  f->ref = 0;
    80003a2c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a30:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a34:	00016517          	auipc	a0,0x16
    80003a38:	09450513          	addi	a0,a0,148 # 80019ac8 <ftable>
    80003a3c:	00003097          	auipc	ra,0x3
    80003a40:	78a080e7          	jalr	1930(ra) # 800071c6 <release>

  if(ff.type == FD_PIPE){
    80003a44:	4785                	li	a5,1
    80003a46:	04f90a63          	beq	s2,a5,80003a9a <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a4a:	ffe9079b          	addiw	a5,s2,-2
    80003a4e:	4705                	li	a4,1
    80003a50:	04f77c63          	bgeu	a4,a5,80003aa8 <fileclose+0xc8>
    begin_op();
    iput(ff.ip);
    end_op();
  }
#ifdef LAB_NET
  else if(ff.type == FD_SOCK){
    80003a54:	4791                	li	a5,4
    80003a56:	02f91863          	bne	s2,a5,80003a86 <fileclose+0xa6>
    sockclose(ff.sock);
    80003a5a:	855a                	mv	a0,s6
    80003a5c:	00003097          	auipc	ra,0x3
    80003a60:	910080e7          	jalr	-1776(ra) # 8000636c <sockclose>
    80003a64:	a00d                	j	80003a86 <fileclose+0xa6>
    panic("fileclose");
    80003a66:	00006517          	auipc	a0,0x6
    80003a6a:	c0250513          	addi	a0,a0,-1022 # 80009668 <syscalls+0x288>
    80003a6e:	00003097          	auipc	ra,0x3
    80003a72:	16c080e7          	jalr	364(ra) # 80006bda <panic>
    release(&ftable.lock);
    80003a76:	00016517          	auipc	a0,0x16
    80003a7a:	05250513          	addi	a0,a0,82 # 80019ac8 <ftable>
    80003a7e:	00003097          	auipc	ra,0x3
    80003a82:	748080e7          	jalr	1864(ra) # 800071c6 <release>
  }
#endif
}
    80003a86:	70e2                	ld	ra,56(sp)
    80003a88:	7442                	ld	s0,48(sp)
    80003a8a:	74a2                	ld	s1,40(sp)
    80003a8c:	7902                	ld	s2,32(sp)
    80003a8e:	69e2                	ld	s3,24(sp)
    80003a90:	6a42                	ld	s4,16(sp)
    80003a92:	6aa2                	ld	s5,8(sp)
    80003a94:	6b02                	ld	s6,0(sp)
    80003a96:	6121                	addi	sp,sp,64
    80003a98:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a9a:	85d6                	mv	a1,s5
    80003a9c:	8552                	mv	a0,s4
    80003a9e:	00000097          	auipc	ra,0x0
    80003aa2:	37c080e7          	jalr	892(ra) # 80003e1a <pipeclose>
    80003aa6:	b7c5                	j	80003a86 <fileclose+0xa6>
    begin_op();
    80003aa8:	00000097          	auipc	ra,0x0
    80003aac:	a70080e7          	jalr	-1424(ra) # 80003518 <begin_op>
    iput(ff.ip);
    80003ab0:	854e                	mv	a0,s3
    80003ab2:	fffff097          	auipc	ra,0xfffff
    80003ab6:	254080e7          	jalr	596(ra) # 80002d06 <iput>
    end_op();
    80003aba:	00000097          	auipc	ra,0x0
    80003abe:	adc080e7          	jalr	-1316(ra) # 80003596 <end_op>
    80003ac2:	b7d1                	j	80003a86 <fileclose+0xa6>

0000000080003ac4 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003ac4:	715d                	addi	sp,sp,-80
    80003ac6:	e486                	sd	ra,72(sp)
    80003ac8:	e0a2                	sd	s0,64(sp)
    80003aca:	fc26                	sd	s1,56(sp)
    80003acc:	f84a                	sd	s2,48(sp)
    80003ace:	f44e                	sd	s3,40(sp)
    80003ad0:	0880                	addi	s0,sp,80
    80003ad2:	84aa                	mv	s1,a0
    80003ad4:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003ad6:	ffffd097          	auipc	ra,0xffffd
    80003ada:	3d6080e7          	jalr	982(ra) # 80000eac <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003ade:	409c                	lw	a5,0(s1)
    80003ae0:	37f9                	addiw	a5,a5,-2
    80003ae2:	4705                	li	a4,1
    80003ae4:	04f76763          	bltu	a4,a5,80003b32 <filestat+0x6e>
    80003ae8:	892a                	mv	s2,a0
    ilock(f->ip);
    80003aea:	6c88                	ld	a0,24(s1)
    80003aec:	fffff097          	auipc	ra,0xfffff
    80003af0:	060080e7          	jalr	96(ra) # 80002b4c <ilock>
    stati(f->ip, &st);
    80003af4:	fb840593          	addi	a1,s0,-72
    80003af8:	6c88                	ld	a0,24(s1)
    80003afa:	fffff097          	auipc	ra,0xfffff
    80003afe:	2dc080e7          	jalr	732(ra) # 80002dd6 <stati>
    iunlock(f->ip);
    80003b02:	6c88                	ld	a0,24(s1)
    80003b04:	fffff097          	auipc	ra,0xfffff
    80003b08:	10a080e7          	jalr	266(ra) # 80002c0e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b0c:	46e1                	li	a3,24
    80003b0e:	fb840613          	addi	a2,s0,-72
    80003b12:	85ce                	mv	a1,s3
    80003b14:	05093503          	ld	a0,80(s2)
    80003b18:	ffffd097          	auipc	ra,0xffffd
    80003b1c:	058080e7          	jalr	88(ra) # 80000b70 <copyout>
    80003b20:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b24:	60a6                	ld	ra,72(sp)
    80003b26:	6406                	ld	s0,64(sp)
    80003b28:	74e2                	ld	s1,56(sp)
    80003b2a:	7942                	ld	s2,48(sp)
    80003b2c:	79a2                	ld	s3,40(sp)
    80003b2e:	6161                	addi	sp,sp,80
    80003b30:	8082                	ret
  return -1;
    80003b32:	557d                	li	a0,-1
    80003b34:	bfc5                	j	80003b24 <filestat+0x60>

0000000080003b36 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b36:	7179                	addi	sp,sp,-48
    80003b38:	f406                	sd	ra,40(sp)
    80003b3a:	f022                	sd	s0,32(sp)
    80003b3c:	ec26                	sd	s1,24(sp)
    80003b3e:	e84a                	sd	s2,16(sp)
    80003b40:	e44e                	sd	s3,8(sp)
    80003b42:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b44:	00854783          	lbu	a5,8(a0)
    80003b48:	cfc5                	beqz	a5,80003c00 <fileread+0xca>
    80003b4a:	84aa                	mv	s1,a0
    80003b4c:	89ae                	mv	s3,a1
    80003b4e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b50:	411c                	lw	a5,0(a0)
    80003b52:	4705                	li	a4,1
    80003b54:	02e78963          	beq	a5,a4,80003b86 <fileread+0x50>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b58:	470d                	li	a4,3
    80003b5a:	02e78d63          	beq	a5,a4,80003b94 <fileread+0x5e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b5e:	4709                	li	a4,2
    80003b60:	04e78e63          	beq	a5,a4,80003bbc <fileread+0x86>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
  }
#ifdef LAB_NET
  else if(f->type == FD_SOCK){
    80003b64:	4711                	li	a4,4
    80003b66:	08e79563          	bne	a5,a4,80003bf0 <fileread+0xba>
    r = sockread(f->sock, addr, n);
    80003b6a:	7108                	ld	a0,32(a0)
    80003b6c:	00003097          	auipc	ra,0x3
    80003b70:	890080e7          	jalr	-1904(ra) # 800063fc <sockread>
    80003b74:	892a                	mv	s2,a0
  else {
    panic("fileread");
  }

  return r;
}
    80003b76:	854a                	mv	a0,s2
    80003b78:	70a2                	ld	ra,40(sp)
    80003b7a:	7402                	ld	s0,32(sp)
    80003b7c:	64e2                	ld	s1,24(sp)
    80003b7e:	6942                	ld	s2,16(sp)
    80003b80:	69a2                	ld	s3,8(sp)
    80003b82:	6145                	addi	sp,sp,48
    80003b84:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b86:	6908                	ld	a0,16(a0)
    80003b88:	00000097          	auipc	ra,0x0
    80003b8c:	3fa080e7          	jalr	1018(ra) # 80003f82 <piperead>
    80003b90:	892a                	mv	s2,a0
    80003b92:	b7d5                	j	80003b76 <fileread+0x40>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b94:	02c51783          	lh	a5,44(a0)
    80003b98:	03079693          	slli	a3,a5,0x30
    80003b9c:	92c1                	srli	a3,a3,0x30
    80003b9e:	4725                	li	a4,9
    80003ba0:	06d76263          	bltu	a4,a3,80003c04 <fileread+0xce>
    80003ba4:	0792                	slli	a5,a5,0x4
    80003ba6:	00016717          	auipc	a4,0x16
    80003baa:	e8270713          	addi	a4,a4,-382 # 80019a28 <devsw>
    80003bae:	97ba                	add	a5,a5,a4
    80003bb0:	639c                	ld	a5,0(a5)
    80003bb2:	cbb9                	beqz	a5,80003c08 <fileread+0xd2>
    r = devsw[f->major].read(1, addr, n);
    80003bb4:	4505                	li	a0,1
    80003bb6:	9782                	jalr	a5
    80003bb8:	892a                	mv	s2,a0
    80003bba:	bf75                	j	80003b76 <fileread+0x40>
    ilock(f->ip);
    80003bbc:	6d08                	ld	a0,24(a0)
    80003bbe:	fffff097          	auipc	ra,0xfffff
    80003bc2:	f8e080e7          	jalr	-114(ra) # 80002b4c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bc6:	874a                	mv	a4,s2
    80003bc8:	5494                	lw	a3,40(s1)
    80003bca:	864e                	mv	a2,s3
    80003bcc:	4585                	li	a1,1
    80003bce:	6c88                	ld	a0,24(s1)
    80003bd0:	fffff097          	auipc	ra,0xfffff
    80003bd4:	230080e7          	jalr	560(ra) # 80002e00 <readi>
    80003bd8:	892a                	mv	s2,a0
    80003bda:	00a05563          	blez	a0,80003be4 <fileread+0xae>
      f->off += r;
    80003bde:	549c                	lw	a5,40(s1)
    80003be0:	9fa9                	addw	a5,a5,a0
    80003be2:	d49c                	sw	a5,40(s1)
    iunlock(f->ip);
    80003be4:	6c88                	ld	a0,24(s1)
    80003be6:	fffff097          	auipc	ra,0xfffff
    80003bea:	028080e7          	jalr	40(ra) # 80002c0e <iunlock>
    80003bee:	b761                	j	80003b76 <fileread+0x40>
    panic("fileread");
    80003bf0:	00006517          	auipc	a0,0x6
    80003bf4:	a8850513          	addi	a0,a0,-1400 # 80009678 <syscalls+0x298>
    80003bf8:	00003097          	auipc	ra,0x3
    80003bfc:	fe2080e7          	jalr	-30(ra) # 80006bda <panic>
    return -1;
    80003c00:	597d                	li	s2,-1
    80003c02:	bf95                	j	80003b76 <fileread+0x40>
      return -1;
    80003c04:	597d                	li	s2,-1
    80003c06:	bf85                	j	80003b76 <fileread+0x40>
    80003c08:	597d                	li	s2,-1
    80003c0a:	b7b5                	j	80003b76 <fileread+0x40>

0000000080003c0c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003c0c:	00954783          	lbu	a5,9(a0)
    80003c10:	12078263          	beqz	a5,80003d34 <filewrite+0x128>
{
    80003c14:	715d                	addi	sp,sp,-80
    80003c16:	e486                	sd	ra,72(sp)
    80003c18:	e0a2                	sd	s0,64(sp)
    80003c1a:	fc26                	sd	s1,56(sp)
    80003c1c:	f84a                	sd	s2,48(sp)
    80003c1e:	f44e                	sd	s3,40(sp)
    80003c20:	f052                	sd	s4,32(sp)
    80003c22:	ec56                	sd	s5,24(sp)
    80003c24:	e85a                	sd	s6,16(sp)
    80003c26:	e45e                	sd	s7,8(sp)
    80003c28:	e062                	sd	s8,0(sp)
    80003c2a:	0880                	addi	s0,sp,80
    80003c2c:	84aa                	mv	s1,a0
    80003c2e:	8aae                	mv	s5,a1
    80003c30:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c32:	411c                	lw	a5,0(a0)
    80003c34:	4705                	li	a4,1
    80003c36:	02e78c63          	beq	a5,a4,80003c6e <filewrite+0x62>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c3a:	470d                	li	a4,3
    80003c3c:	02e78f63          	beq	a5,a4,80003c7a <filewrite+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c40:	4709                	li	a4,2
    80003c42:	04e78f63          	beq	a5,a4,80003ca0 <filewrite+0x94>
      i += r;
    }
    ret = (i == n ? n : -1);
  }
#ifdef LAB_NET
  else if(f->type == FD_SOCK){
    80003c46:	4711                	li	a4,4
    80003c48:	0ce79e63          	bne	a5,a4,80003d24 <filewrite+0x118>
    ret = sockwrite(f->sock, addr, n);
    80003c4c:	7108                	ld	a0,32(a0)
    80003c4e:	00003097          	auipc	ra,0x3
    80003c52:	880080e7          	jalr	-1920(ra) # 800064ce <sockwrite>
  else {
    panic("filewrite");
  }

  return ret;
}
    80003c56:	60a6                	ld	ra,72(sp)
    80003c58:	6406                	ld	s0,64(sp)
    80003c5a:	74e2                	ld	s1,56(sp)
    80003c5c:	7942                	ld	s2,48(sp)
    80003c5e:	79a2                	ld	s3,40(sp)
    80003c60:	7a02                	ld	s4,32(sp)
    80003c62:	6ae2                	ld	s5,24(sp)
    80003c64:	6b42                	ld	s6,16(sp)
    80003c66:	6ba2                	ld	s7,8(sp)
    80003c68:	6c02                	ld	s8,0(sp)
    80003c6a:	6161                	addi	sp,sp,80
    80003c6c:	8082                	ret
    ret = pipewrite(f->pipe, addr, n);
    80003c6e:	6908                	ld	a0,16(a0)
    80003c70:	00000097          	auipc	ra,0x0
    80003c74:	21a080e7          	jalr	538(ra) # 80003e8a <pipewrite>
    80003c78:	bff9                	j	80003c56 <filewrite+0x4a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c7a:	02c51783          	lh	a5,44(a0)
    80003c7e:	03079693          	slli	a3,a5,0x30
    80003c82:	92c1                	srli	a3,a3,0x30
    80003c84:	4725                	li	a4,9
    80003c86:	0ad76963          	bltu	a4,a3,80003d38 <filewrite+0x12c>
    80003c8a:	0792                	slli	a5,a5,0x4
    80003c8c:	00016717          	auipc	a4,0x16
    80003c90:	d9c70713          	addi	a4,a4,-612 # 80019a28 <devsw>
    80003c94:	97ba                	add	a5,a5,a4
    80003c96:	679c                	ld	a5,8(a5)
    80003c98:	c3d5                	beqz	a5,80003d3c <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003c9a:	4505                	li	a0,1
    80003c9c:	9782                	jalr	a5
    80003c9e:	bf65                	j	80003c56 <filewrite+0x4a>
    while(i < n){
    80003ca0:	06c05c63          	blez	a2,80003d18 <filewrite+0x10c>
    int i = 0;
    80003ca4:	4981                	li	s3,0
    80003ca6:	6b85                	lui	s7,0x1
    80003ca8:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003cac:	6c05                	lui	s8,0x1
    80003cae:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003cb2:	a899                	j	80003d08 <filewrite+0xfc>
    80003cb4:	00090b1b          	sext.w	s6,s2
      begin_op();
    80003cb8:	00000097          	auipc	ra,0x0
    80003cbc:	860080e7          	jalr	-1952(ra) # 80003518 <begin_op>
      ilock(f->ip);
    80003cc0:	6c88                	ld	a0,24(s1)
    80003cc2:	fffff097          	auipc	ra,0xfffff
    80003cc6:	e8a080e7          	jalr	-374(ra) # 80002b4c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003cca:	875a                	mv	a4,s6
    80003ccc:	5494                	lw	a3,40(s1)
    80003cce:	01598633          	add	a2,s3,s5
    80003cd2:	4585                	li	a1,1
    80003cd4:	6c88                	ld	a0,24(s1)
    80003cd6:	fffff097          	auipc	ra,0xfffff
    80003cda:	222080e7          	jalr	546(ra) # 80002ef8 <writei>
    80003cde:	892a                	mv	s2,a0
    80003ce0:	00a05563          	blez	a0,80003cea <filewrite+0xde>
        f->off += r;
    80003ce4:	549c                	lw	a5,40(s1)
    80003ce6:	9fa9                	addw	a5,a5,a0
    80003ce8:	d49c                	sw	a5,40(s1)
      iunlock(f->ip);
    80003cea:	6c88                	ld	a0,24(s1)
    80003cec:	fffff097          	auipc	ra,0xfffff
    80003cf0:	f22080e7          	jalr	-222(ra) # 80002c0e <iunlock>
      end_op();
    80003cf4:	00000097          	auipc	ra,0x0
    80003cf8:	8a2080e7          	jalr	-1886(ra) # 80003596 <end_op>
      if(r != n1){
    80003cfc:	012b1f63          	bne	s6,s2,80003d1a <filewrite+0x10e>
      i += r;
    80003d00:	013909bb          	addw	s3,s2,s3
    while(i < n){
    80003d04:	0149db63          	bge	s3,s4,80003d1a <filewrite+0x10e>
      int n1 = n - i;
    80003d08:	413a093b          	subw	s2,s4,s3
    80003d0c:	0009079b          	sext.w	a5,s2
    80003d10:	fafbd2e3          	bge	s7,a5,80003cb4 <filewrite+0xa8>
    80003d14:	8962                	mv	s2,s8
    80003d16:	bf79                	j	80003cb4 <filewrite+0xa8>
    int i = 0;
    80003d18:	4981                	li	s3,0
    ret = (i == n ? n : -1);
    80003d1a:	8552                	mv	a0,s4
    80003d1c:	f33a0de3          	beq	s4,s3,80003c56 <filewrite+0x4a>
    80003d20:	557d                	li	a0,-1
    80003d22:	bf15                	j	80003c56 <filewrite+0x4a>
    panic("filewrite");
    80003d24:	00006517          	auipc	a0,0x6
    80003d28:	96450513          	addi	a0,a0,-1692 # 80009688 <syscalls+0x2a8>
    80003d2c:	00003097          	auipc	ra,0x3
    80003d30:	eae080e7          	jalr	-338(ra) # 80006bda <panic>
    return -1;
    80003d34:	557d                	li	a0,-1
}
    80003d36:	8082                	ret
      return -1;
    80003d38:	557d                	li	a0,-1
    80003d3a:	bf31                	j	80003c56 <filewrite+0x4a>
    80003d3c:	557d                	li	a0,-1
    80003d3e:	bf21                	j	80003c56 <filewrite+0x4a>

0000000080003d40 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d40:	7179                	addi	sp,sp,-48
    80003d42:	f406                	sd	ra,40(sp)
    80003d44:	f022                	sd	s0,32(sp)
    80003d46:	ec26                	sd	s1,24(sp)
    80003d48:	e84a                	sd	s2,16(sp)
    80003d4a:	e44e                	sd	s3,8(sp)
    80003d4c:	e052                	sd	s4,0(sp)
    80003d4e:	1800                	addi	s0,sp,48
    80003d50:	84aa                	mv	s1,a0
    80003d52:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d54:	0005b023          	sd	zero,0(a1)
    80003d58:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d5c:	00000097          	auipc	ra,0x0
    80003d60:	bc8080e7          	jalr	-1080(ra) # 80003924 <filealloc>
    80003d64:	e088                	sd	a0,0(s1)
    80003d66:	c551                	beqz	a0,80003df2 <pipealloc+0xb2>
    80003d68:	00000097          	auipc	ra,0x0
    80003d6c:	bbc080e7          	jalr	-1092(ra) # 80003924 <filealloc>
    80003d70:	00aa3023          	sd	a0,0(s4)
    80003d74:	c92d                	beqz	a0,80003de6 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d76:	ffffc097          	auipc	ra,0xffffc
    80003d7a:	3a4080e7          	jalr	932(ra) # 8000011a <kalloc>
    80003d7e:	892a                	mv	s2,a0
    80003d80:	c125                	beqz	a0,80003de0 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003d82:	4985                	li	s3,1
    80003d84:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003d88:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003d8c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003d90:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003d94:	00006597          	auipc	a1,0x6
    80003d98:	90458593          	addi	a1,a1,-1788 # 80009698 <syscalls+0x2b8>
    80003d9c:	00003097          	auipc	ra,0x3
    80003da0:	2e6080e7          	jalr	742(ra) # 80007082 <initlock>
  (*f0)->type = FD_PIPE;
    80003da4:	609c                	ld	a5,0(s1)
    80003da6:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003daa:	609c                	ld	a5,0(s1)
    80003dac:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003db0:	609c                	ld	a5,0(s1)
    80003db2:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003db6:	609c                	ld	a5,0(s1)
    80003db8:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003dbc:	000a3783          	ld	a5,0(s4)
    80003dc0:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003dc4:	000a3783          	ld	a5,0(s4)
    80003dc8:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003dcc:	000a3783          	ld	a5,0(s4)
    80003dd0:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003dd4:	000a3783          	ld	a5,0(s4)
    80003dd8:	0127b823          	sd	s2,16(a5)
  return 0;
    80003ddc:	4501                	li	a0,0
    80003dde:	a025                	j	80003e06 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003de0:	6088                	ld	a0,0(s1)
    80003de2:	e501                	bnez	a0,80003dea <pipealloc+0xaa>
    80003de4:	a039                	j	80003df2 <pipealloc+0xb2>
    80003de6:	6088                	ld	a0,0(s1)
    80003de8:	c51d                	beqz	a0,80003e16 <pipealloc+0xd6>
    fileclose(*f0);
    80003dea:	00000097          	auipc	ra,0x0
    80003dee:	bf6080e7          	jalr	-1034(ra) # 800039e0 <fileclose>
  if(*f1)
    80003df2:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003df6:	557d                	li	a0,-1
  if(*f1)
    80003df8:	c799                	beqz	a5,80003e06 <pipealloc+0xc6>
    fileclose(*f1);
    80003dfa:	853e                	mv	a0,a5
    80003dfc:	00000097          	auipc	ra,0x0
    80003e00:	be4080e7          	jalr	-1052(ra) # 800039e0 <fileclose>
  return -1;
    80003e04:	557d                	li	a0,-1
}
    80003e06:	70a2                	ld	ra,40(sp)
    80003e08:	7402                	ld	s0,32(sp)
    80003e0a:	64e2                	ld	s1,24(sp)
    80003e0c:	6942                	ld	s2,16(sp)
    80003e0e:	69a2                	ld	s3,8(sp)
    80003e10:	6a02                	ld	s4,0(sp)
    80003e12:	6145                	addi	sp,sp,48
    80003e14:	8082                	ret
  return -1;
    80003e16:	557d                	li	a0,-1
    80003e18:	b7fd                	j	80003e06 <pipealloc+0xc6>

0000000080003e1a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e1a:	1101                	addi	sp,sp,-32
    80003e1c:	ec06                	sd	ra,24(sp)
    80003e1e:	e822                	sd	s0,16(sp)
    80003e20:	e426                	sd	s1,8(sp)
    80003e22:	e04a                	sd	s2,0(sp)
    80003e24:	1000                	addi	s0,sp,32
    80003e26:	84aa                	mv	s1,a0
    80003e28:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e2a:	00003097          	auipc	ra,0x3
    80003e2e:	2e8080e7          	jalr	744(ra) # 80007112 <acquire>
  if(writable){
    80003e32:	02090d63          	beqz	s2,80003e6c <pipeclose+0x52>
    pi->writeopen = 0;
    80003e36:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e3a:	21848513          	addi	a0,s1,536
    80003e3e:	ffffd097          	auipc	ra,0xffffd
    80003e42:	77a080e7          	jalr	1914(ra) # 800015b8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e46:	2204b783          	ld	a5,544(s1)
    80003e4a:	eb95                	bnez	a5,80003e7e <pipeclose+0x64>
    release(&pi->lock);
    80003e4c:	8526                	mv	a0,s1
    80003e4e:	00003097          	auipc	ra,0x3
    80003e52:	378080e7          	jalr	888(ra) # 800071c6 <release>
    kfree((char*)pi);
    80003e56:	8526                	mv	a0,s1
    80003e58:	ffffc097          	auipc	ra,0xffffc
    80003e5c:	1c4080e7          	jalr	452(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e60:	60e2                	ld	ra,24(sp)
    80003e62:	6442                	ld	s0,16(sp)
    80003e64:	64a2                	ld	s1,8(sp)
    80003e66:	6902                	ld	s2,0(sp)
    80003e68:	6105                	addi	sp,sp,32
    80003e6a:	8082                	ret
    pi->readopen = 0;
    80003e6c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e70:	21c48513          	addi	a0,s1,540
    80003e74:	ffffd097          	auipc	ra,0xffffd
    80003e78:	744080e7          	jalr	1860(ra) # 800015b8 <wakeup>
    80003e7c:	b7e9                	j	80003e46 <pipeclose+0x2c>
    release(&pi->lock);
    80003e7e:	8526                	mv	a0,s1
    80003e80:	00003097          	auipc	ra,0x3
    80003e84:	346080e7          	jalr	838(ra) # 800071c6 <release>
}
    80003e88:	bfe1                	j	80003e60 <pipeclose+0x46>

0000000080003e8a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003e8a:	711d                	addi	sp,sp,-96
    80003e8c:	ec86                	sd	ra,88(sp)
    80003e8e:	e8a2                	sd	s0,80(sp)
    80003e90:	e4a6                	sd	s1,72(sp)
    80003e92:	e0ca                	sd	s2,64(sp)
    80003e94:	fc4e                	sd	s3,56(sp)
    80003e96:	f852                	sd	s4,48(sp)
    80003e98:	f456                	sd	s5,40(sp)
    80003e9a:	f05a                	sd	s6,32(sp)
    80003e9c:	ec5e                	sd	s7,24(sp)
    80003e9e:	e862                	sd	s8,16(sp)
    80003ea0:	1080                	addi	s0,sp,96
    80003ea2:	84aa                	mv	s1,a0
    80003ea4:	8aae                	mv	s5,a1
    80003ea6:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ea8:	ffffd097          	auipc	ra,0xffffd
    80003eac:	004080e7          	jalr	4(ra) # 80000eac <myproc>
    80003eb0:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003eb2:	8526                	mv	a0,s1
    80003eb4:	00003097          	auipc	ra,0x3
    80003eb8:	25e080e7          	jalr	606(ra) # 80007112 <acquire>
  while(i < n){
    80003ebc:	0b405663          	blez	s4,80003f68 <pipewrite+0xde>
  int i = 0;
    80003ec0:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ec2:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003ec4:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003ec8:	21c48b93          	addi	s7,s1,540
    80003ecc:	a089                	j	80003f0e <pipewrite+0x84>
      release(&pi->lock);
    80003ece:	8526                	mv	a0,s1
    80003ed0:	00003097          	auipc	ra,0x3
    80003ed4:	2f6080e7          	jalr	758(ra) # 800071c6 <release>
      return -1;
    80003ed8:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003eda:	854a                	mv	a0,s2
    80003edc:	60e6                	ld	ra,88(sp)
    80003ede:	6446                	ld	s0,80(sp)
    80003ee0:	64a6                	ld	s1,72(sp)
    80003ee2:	6906                	ld	s2,64(sp)
    80003ee4:	79e2                	ld	s3,56(sp)
    80003ee6:	7a42                	ld	s4,48(sp)
    80003ee8:	7aa2                	ld	s5,40(sp)
    80003eea:	7b02                	ld	s6,32(sp)
    80003eec:	6be2                	ld	s7,24(sp)
    80003eee:	6c42                	ld	s8,16(sp)
    80003ef0:	6125                	addi	sp,sp,96
    80003ef2:	8082                	ret
      wakeup(&pi->nread);
    80003ef4:	8562                	mv	a0,s8
    80003ef6:	ffffd097          	auipc	ra,0xffffd
    80003efa:	6c2080e7          	jalr	1730(ra) # 800015b8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003efe:	85a6                	mv	a1,s1
    80003f00:	855e                	mv	a0,s7
    80003f02:	ffffd097          	auipc	ra,0xffffd
    80003f06:	652080e7          	jalr	1618(ra) # 80001554 <sleep>
  while(i < n){
    80003f0a:	07495063          	bge	s2,s4,80003f6a <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003f0e:	2204a783          	lw	a5,544(s1)
    80003f12:	dfd5                	beqz	a5,80003ece <pipewrite+0x44>
    80003f14:	854e                	mv	a0,s3
    80003f16:	ffffe097          	auipc	ra,0xffffe
    80003f1a:	8e6080e7          	jalr	-1818(ra) # 800017fc <killed>
    80003f1e:	f945                	bnez	a0,80003ece <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f20:	2184a783          	lw	a5,536(s1)
    80003f24:	21c4a703          	lw	a4,540(s1)
    80003f28:	2007879b          	addiw	a5,a5,512
    80003f2c:	fcf704e3          	beq	a4,a5,80003ef4 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f30:	4685                	li	a3,1
    80003f32:	01590633          	add	a2,s2,s5
    80003f36:	faf40593          	addi	a1,s0,-81
    80003f3a:	0509b503          	ld	a0,80(s3)
    80003f3e:	ffffd097          	auipc	ra,0xffffd
    80003f42:	cbe080e7          	jalr	-834(ra) # 80000bfc <copyin>
    80003f46:	03650263          	beq	a0,s6,80003f6a <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f4a:	21c4a783          	lw	a5,540(s1)
    80003f4e:	0017871b          	addiw	a4,a5,1
    80003f52:	20e4ae23          	sw	a4,540(s1)
    80003f56:	1ff7f793          	andi	a5,a5,511
    80003f5a:	97a6                	add	a5,a5,s1
    80003f5c:	faf44703          	lbu	a4,-81(s0)
    80003f60:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f64:	2905                	addiw	s2,s2,1
    80003f66:	b755                	j	80003f0a <pipewrite+0x80>
  int i = 0;
    80003f68:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003f6a:	21848513          	addi	a0,s1,536
    80003f6e:	ffffd097          	auipc	ra,0xffffd
    80003f72:	64a080e7          	jalr	1610(ra) # 800015b8 <wakeup>
  release(&pi->lock);
    80003f76:	8526                	mv	a0,s1
    80003f78:	00003097          	auipc	ra,0x3
    80003f7c:	24e080e7          	jalr	590(ra) # 800071c6 <release>
  return i;
    80003f80:	bfa9                	j	80003eda <pipewrite+0x50>

0000000080003f82 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003f82:	715d                	addi	sp,sp,-80
    80003f84:	e486                	sd	ra,72(sp)
    80003f86:	e0a2                	sd	s0,64(sp)
    80003f88:	fc26                	sd	s1,56(sp)
    80003f8a:	f84a                	sd	s2,48(sp)
    80003f8c:	f44e                	sd	s3,40(sp)
    80003f8e:	f052                	sd	s4,32(sp)
    80003f90:	ec56                	sd	s5,24(sp)
    80003f92:	e85a                	sd	s6,16(sp)
    80003f94:	0880                	addi	s0,sp,80
    80003f96:	84aa                	mv	s1,a0
    80003f98:	892e                	mv	s2,a1
    80003f9a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f9c:	ffffd097          	auipc	ra,0xffffd
    80003fa0:	f10080e7          	jalr	-240(ra) # 80000eac <myproc>
    80003fa4:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003fa6:	8526                	mv	a0,s1
    80003fa8:	00003097          	auipc	ra,0x3
    80003fac:	16a080e7          	jalr	362(ra) # 80007112 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fb0:	2184a703          	lw	a4,536(s1)
    80003fb4:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fb8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fbc:	02f71763          	bne	a4,a5,80003fea <piperead+0x68>
    80003fc0:	2244a783          	lw	a5,548(s1)
    80003fc4:	c39d                	beqz	a5,80003fea <piperead+0x68>
    if(killed(pr)){
    80003fc6:	8552                	mv	a0,s4
    80003fc8:	ffffe097          	auipc	ra,0xffffe
    80003fcc:	834080e7          	jalr	-1996(ra) # 800017fc <killed>
    80003fd0:	e949                	bnez	a0,80004062 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fd2:	85a6                	mv	a1,s1
    80003fd4:	854e                	mv	a0,s3
    80003fd6:	ffffd097          	auipc	ra,0xffffd
    80003fda:	57e080e7          	jalr	1406(ra) # 80001554 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fde:	2184a703          	lw	a4,536(s1)
    80003fe2:	21c4a783          	lw	a5,540(s1)
    80003fe6:	fcf70de3          	beq	a4,a5,80003fc0 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fea:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fec:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fee:	05505463          	blez	s5,80004036 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80003ff2:	2184a783          	lw	a5,536(s1)
    80003ff6:	21c4a703          	lw	a4,540(s1)
    80003ffa:	02f70e63          	beq	a4,a5,80004036 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003ffe:	0017871b          	addiw	a4,a5,1
    80004002:	20e4ac23          	sw	a4,536(s1)
    80004006:	1ff7f793          	andi	a5,a5,511
    8000400a:	97a6                	add	a5,a5,s1
    8000400c:	0187c783          	lbu	a5,24(a5)
    80004010:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004014:	4685                	li	a3,1
    80004016:	fbf40613          	addi	a2,s0,-65
    8000401a:	85ca                	mv	a1,s2
    8000401c:	050a3503          	ld	a0,80(s4)
    80004020:	ffffd097          	auipc	ra,0xffffd
    80004024:	b50080e7          	jalr	-1200(ra) # 80000b70 <copyout>
    80004028:	01650763          	beq	a0,s6,80004036 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000402c:	2985                	addiw	s3,s3,1
    8000402e:	0905                	addi	s2,s2,1
    80004030:	fd3a91e3          	bne	s5,s3,80003ff2 <piperead+0x70>
    80004034:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004036:	21c48513          	addi	a0,s1,540
    8000403a:	ffffd097          	auipc	ra,0xffffd
    8000403e:	57e080e7          	jalr	1406(ra) # 800015b8 <wakeup>
  release(&pi->lock);
    80004042:	8526                	mv	a0,s1
    80004044:	00003097          	auipc	ra,0x3
    80004048:	182080e7          	jalr	386(ra) # 800071c6 <release>
  return i;
}
    8000404c:	854e                	mv	a0,s3
    8000404e:	60a6                	ld	ra,72(sp)
    80004050:	6406                	ld	s0,64(sp)
    80004052:	74e2                	ld	s1,56(sp)
    80004054:	7942                	ld	s2,48(sp)
    80004056:	79a2                	ld	s3,40(sp)
    80004058:	7a02                	ld	s4,32(sp)
    8000405a:	6ae2                	ld	s5,24(sp)
    8000405c:	6b42                	ld	s6,16(sp)
    8000405e:	6161                	addi	sp,sp,80
    80004060:	8082                	ret
      release(&pi->lock);
    80004062:	8526                	mv	a0,s1
    80004064:	00003097          	auipc	ra,0x3
    80004068:	162080e7          	jalr	354(ra) # 800071c6 <release>
      return -1;
    8000406c:	59fd                	li	s3,-1
    8000406e:	bff9                	j	8000404c <piperead+0xca>

0000000080004070 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004070:	1141                	addi	sp,sp,-16
    80004072:	e422                	sd	s0,8(sp)
    80004074:	0800                	addi	s0,sp,16
    80004076:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004078:	8905                	andi	a0,a0,1
    8000407a:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000407c:	8b89                	andi	a5,a5,2
    8000407e:	c399                	beqz	a5,80004084 <flags2perm+0x14>
      perm |= PTE_W;
    80004080:	00456513          	ori	a0,a0,4
    return perm;
}
    80004084:	6422                	ld	s0,8(sp)
    80004086:	0141                	addi	sp,sp,16
    80004088:	8082                	ret

000000008000408a <exec>:

int
exec(char *path, char **argv)
{
    8000408a:	de010113          	addi	sp,sp,-544
    8000408e:	20113c23          	sd	ra,536(sp)
    80004092:	20813823          	sd	s0,528(sp)
    80004096:	20913423          	sd	s1,520(sp)
    8000409a:	21213023          	sd	s2,512(sp)
    8000409e:	ffce                	sd	s3,504(sp)
    800040a0:	fbd2                	sd	s4,496(sp)
    800040a2:	f7d6                	sd	s5,488(sp)
    800040a4:	f3da                	sd	s6,480(sp)
    800040a6:	efde                	sd	s7,472(sp)
    800040a8:	ebe2                	sd	s8,464(sp)
    800040aa:	e7e6                	sd	s9,456(sp)
    800040ac:	e3ea                	sd	s10,448(sp)
    800040ae:	ff6e                	sd	s11,440(sp)
    800040b0:	1400                	addi	s0,sp,544
    800040b2:	892a                	mv	s2,a0
    800040b4:	dea43423          	sd	a0,-536(s0)
    800040b8:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040bc:	ffffd097          	auipc	ra,0xffffd
    800040c0:	df0080e7          	jalr	-528(ra) # 80000eac <myproc>
    800040c4:	84aa                	mv	s1,a0

  begin_op();
    800040c6:	fffff097          	auipc	ra,0xfffff
    800040ca:	452080e7          	jalr	1106(ra) # 80003518 <begin_op>

  if((ip = namei(path)) == 0){
    800040ce:	854a                	mv	a0,s2
    800040d0:	fffff097          	auipc	ra,0xfffff
    800040d4:	228080e7          	jalr	552(ra) # 800032f8 <namei>
    800040d8:	c93d                	beqz	a0,8000414e <exec+0xc4>
    800040da:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800040dc:	fffff097          	auipc	ra,0xfffff
    800040e0:	a70080e7          	jalr	-1424(ra) # 80002b4c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800040e4:	04000713          	li	a4,64
    800040e8:	4681                	li	a3,0
    800040ea:	e5040613          	addi	a2,s0,-432
    800040ee:	4581                	li	a1,0
    800040f0:	8556                	mv	a0,s5
    800040f2:	fffff097          	auipc	ra,0xfffff
    800040f6:	d0e080e7          	jalr	-754(ra) # 80002e00 <readi>
    800040fa:	04000793          	li	a5,64
    800040fe:	00f51a63          	bne	a0,a5,80004112 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004102:	e5042703          	lw	a4,-432(s0)
    80004106:	464c47b7          	lui	a5,0x464c4
    8000410a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000410e:	04f70663          	beq	a4,a5,8000415a <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004112:	8556                	mv	a0,s5
    80004114:	fffff097          	auipc	ra,0xfffff
    80004118:	c9a080e7          	jalr	-870(ra) # 80002dae <iunlockput>
    end_op();
    8000411c:	fffff097          	auipc	ra,0xfffff
    80004120:	47a080e7          	jalr	1146(ra) # 80003596 <end_op>
  }
  return -1;
    80004124:	557d                	li	a0,-1
}
    80004126:	21813083          	ld	ra,536(sp)
    8000412a:	21013403          	ld	s0,528(sp)
    8000412e:	20813483          	ld	s1,520(sp)
    80004132:	20013903          	ld	s2,512(sp)
    80004136:	79fe                	ld	s3,504(sp)
    80004138:	7a5e                	ld	s4,496(sp)
    8000413a:	7abe                	ld	s5,488(sp)
    8000413c:	7b1e                	ld	s6,480(sp)
    8000413e:	6bfe                	ld	s7,472(sp)
    80004140:	6c5e                	ld	s8,464(sp)
    80004142:	6cbe                	ld	s9,456(sp)
    80004144:	6d1e                	ld	s10,448(sp)
    80004146:	7dfa                	ld	s11,440(sp)
    80004148:	22010113          	addi	sp,sp,544
    8000414c:	8082                	ret
    end_op();
    8000414e:	fffff097          	auipc	ra,0xfffff
    80004152:	448080e7          	jalr	1096(ra) # 80003596 <end_op>
    return -1;
    80004156:	557d                	li	a0,-1
    80004158:	b7f9                	j	80004126 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    8000415a:	8526                	mv	a0,s1
    8000415c:	ffffd097          	auipc	ra,0xffffd
    80004160:	e14080e7          	jalr	-492(ra) # 80000f70 <proc_pagetable>
    80004164:	8b2a                	mv	s6,a0
    80004166:	d555                	beqz	a0,80004112 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004168:	e7042783          	lw	a5,-400(s0)
    8000416c:	e8845703          	lhu	a4,-376(s0)
    80004170:	c735                	beqz	a4,800041dc <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004172:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004174:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004178:	6a05                	lui	s4,0x1
    8000417a:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000417e:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004182:	6d85                	lui	s11,0x1
    80004184:	7d7d                	lui	s10,0xfffff
    80004186:	ac3d                	j	800043c4 <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004188:	00005517          	auipc	a0,0x5
    8000418c:	51850513          	addi	a0,a0,1304 # 800096a0 <syscalls+0x2c0>
    80004190:	00003097          	auipc	ra,0x3
    80004194:	a4a080e7          	jalr	-1462(ra) # 80006bda <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004198:	874a                	mv	a4,s2
    8000419a:	009c86bb          	addw	a3,s9,s1
    8000419e:	4581                	li	a1,0
    800041a0:	8556                	mv	a0,s5
    800041a2:	fffff097          	auipc	ra,0xfffff
    800041a6:	c5e080e7          	jalr	-930(ra) # 80002e00 <readi>
    800041aa:	2501                	sext.w	a0,a0
    800041ac:	1aa91963          	bne	s2,a0,8000435e <exec+0x2d4>
  for(i = 0; i < sz; i += PGSIZE){
    800041b0:	009d84bb          	addw	s1,s11,s1
    800041b4:	013d09bb          	addw	s3,s10,s3
    800041b8:	1f74f663          	bgeu	s1,s7,800043a4 <exec+0x31a>
    pa = walkaddr(pagetable, va + i);
    800041bc:	02049593          	slli	a1,s1,0x20
    800041c0:	9181                	srli	a1,a1,0x20
    800041c2:	95e2                	add	a1,a1,s8
    800041c4:	855a                	mv	a0,s6
    800041c6:	ffffc097          	auipc	ra,0xffffc
    800041ca:	356080e7          	jalr	854(ra) # 8000051c <walkaddr>
    800041ce:	862a                	mv	a2,a0
    if(pa == 0)
    800041d0:	dd45                	beqz	a0,80004188 <exec+0xfe>
      n = PGSIZE;
    800041d2:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800041d4:	fd49f2e3          	bgeu	s3,s4,80004198 <exec+0x10e>
      n = sz - i;
    800041d8:	894e                	mv	s2,s3
    800041da:	bf7d                	j	80004198 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041dc:	4901                	li	s2,0
  iunlockput(ip);
    800041de:	8556                	mv	a0,s5
    800041e0:	fffff097          	auipc	ra,0xfffff
    800041e4:	bce080e7          	jalr	-1074(ra) # 80002dae <iunlockput>
  end_op();
    800041e8:	fffff097          	auipc	ra,0xfffff
    800041ec:	3ae080e7          	jalr	942(ra) # 80003596 <end_op>
  p = myproc();
    800041f0:	ffffd097          	auipc	ra,0xffffd
    800041f4:	cbc080e7          	jalr	-836(ra) # 80000eac <myproc>
    800041f8:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800041fa:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800041fe:	6785                	lui	a5,0x1
    80004200:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004202:	97ca                	add	a5,a5,s2
    80004204:	777d                	lui	a4,0xfffff
    80004206:	8ff9                	and	a5,a5,a4
    80004208:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000420c:	4691                	li	a3,4
    8000420e:	6609                	lui	a2,0x2
    80004210:	963e                	add	a2,a2,a5
    80004212:	85be                	mv	a1,a5
    80004214:	855a                	mv	a0,s6
    80004216:	ffffc097          	auipc	ra,0xffffc
    8000421a:	6fe080e7          	jalr	1790(ra) # 80000914 <uvmalloc>
    8000421e:	8c2a                	mv	s8,a0
  ip = 0;
    80004220:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004222:	12050e63          	beqz	a0,8000435e <exec+0x2d4>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004226:	75f9                	lui	a1,0xffffe
    80004228:	95aa                	add	a1,a1,a0
    8000422a:	855a                	mv	a0,s6
    8000422c:	ffffd097          	auipc	ra,0xffffd
    80004230:	912080e7          	jalr	-1774(ra) # 80000b3e <uvmclear>
  stackbase = sp - PGSIZE;
    80004234:	7afd                	lui	s5,0xfffff
    80004236:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004238:	df043783          	ld	a5,-528(s0)
    8000423c:	6388                	ld	a0,0(a5)
    8000423e:	c925                	beqz	a0,800042ae <exec+0x224>
    80004240:	e9040993          	addi	s3,s0,-368
    80004244:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004248:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000424a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000424c:	ffffc097          	auipc	ra,0xffffc
    80004250:	0aa080e7          	jalr	170(ra) # 800002f6 <strlen>
    80004254:	0015079b          	addiw	a5,a0,1
    80004258:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000425c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004260:	13596663          	bltu	s2,s5,8000438c <exec+0x302>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004264:	df043d83          	ld	s11,-528(s0)
    80004268:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    8000426c:	8552                	mv	a0,s4
    8000426e:	ffffc097          	auipc	ra,0xffffc
    80004272:	088080e7          	jalr	136(ra) # 800002f6 <strlen>
    80004276:	0015069b          	addiw	a3,a0,1
    8000427a:	8652                	mv	a2,s4
    8000427c:	85ca                	mv	a1,s2
    8000427e:	855a                	mv	a0,s6
    80004280:	ffffd097          	auipc	ra,0xffffd
    80004284:	8f0080e7          	jalr	-1808(ra) # 80000b70 <copyout>
    80004288:	10054663          	bltz	a0,80004394 <exec+0x30a>
    ustack[argc] = sp;
    8000428c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004290:	0485                	addi	s1,s1,1
    80004292:	008d8793          	addi	a5,s11,8
    80004296:	def43823          	sd	a5,-528(s0)
    8000429a:	008db503          	ld	a0,8(s11)
    8000429e:	c911                	beqz	a0,800042b2 <exec+0x228>
    if(argc >= MAXARG)
    800042a0:	09a1                	addi	s3,s3,8
    800042a2:	fb3c95e3          	bne	s9,s3,8000424c <exec+0x1c2>
  sz = sz1;
    800042a6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042aa:	4a81                	li	s5,0
    800042ac:	a84d                	j	8000435e <exec+0x2d4>
  sp = sz;
    800042ae:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800042b0:	4481                	li	s1,0
  ustack[argc] = 0;
    800042b2:	00349793          	slli	a5,s1,0x3
    800042b6:	f9078793          	addi	a5,a5,-112
    800042ba:	97a2                	add	a5,a5,s0
    800042bc:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800042c0:	00148693          	addi	a3,s1,1
    800042c4:	068e                	slli	a3,a3,0x3
    800042c6:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800042ca:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800042ce:	01597663          	bgeu	s2,s5,800042da <exec+0x250>
  sz = sz1;
    800042d2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042d6:	4a81                	li	s5,0
    800042d8:	a059                	j	8000435e <exec+0x2d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800042da:	e9040613          	addi	a2,s0,-368
    800042de:	85ca                	mv	a1,s2
    800042e0:	855a                	mv	a0,s6
    800042e2:	ffffd097          	auipc	ra,0xffffd
    800042e6:	88e080e7          	jalr	-1906(ra) # 80000b70 <copyout>
    800042ea:	0a054963          	bltz	a0,8000439c <exec+0x312>
  p->trapframe->a1 = sp;
    800042ee:	058bb783          	ld	a5,88(s7)
    800042f2:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800042f6:	de843783          	ld	a5,-536(s0)
    800042fa:	0007c703          	lbu	a4,0(a5)
    800042fe:	cf11                	beqz	a4,8000431a <exec+0x290>
    80004300:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004302:	02f00693          	li	a3,47
    80004306:	a039                	j	80004314 <exec+0x28a>
      last = s+1;
    80004308:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    8000430c:	0785                	addi	a5,a5,1
    8000430e:	fff7c703          	lbu	a4,-1(a5)
    80004312:	c701                	beqz	a4,8000431a <exec+0x290>
    if(*s == '/')
    80004314:	fed71ce3          	bne	a4,a3,8000430c <exec+0x282>
    80004318:	bfc5                	j	80004308 <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    8000431a:	4641                	li	a2,16
    8000431c:	de843583          	ld	a1,-536(s0)
    80004320:	158b8513          	addi	a0,s7,344
    80004324:	ffffc097          	auipc	ra,0xffffc
    80004328:	fa0080e7          	jalr	-96(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    8000432c:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004330:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004334:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004338:	058bb783          	ld	a5,88(s7)
    8000433c:	e6843703          	ld	a4,-408(s0)
    80004340:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004342:	058bb783          	ld	a5,88(s7)
    80004346:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000434a:	85ea                	mv	a1,s10
    8000434c:	ffffd097          	auipc	ra,0xffffd
    80004350:	cc0080e7          	jalr	-832(ra) # 8000100c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004354:	0004851b          	sext.w	a0,s1
    80004358:	b3f9                	j	80004126 <exec+0x9c>
    8000435a:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000435e:	df843583          	ld	a1,-520(s0)
    80004362:	855a                	mv	a0,s6
    80004364:	ffffd097          	auipc	ra,0xffffd
    80004368:	ca8080e7          	jalr	-856(ra) # 8000100c <proc_freepagetable>
  if(ip){
    8000436c:	da0a93e3          	bnez	s5,80004112 <exec+0x88>
  return -1;
    80004370:	557d                	li	a0,-1
    80004372:	bb55                	j	80004126 <exec+0x9c>
    80004374:	df243c23          	sd	s2,-520(s0)
    80004378:	b7dd                	j	8000435e <exec+0x2d4>
    8000437a:	df243c23          	sd	s2,-520(s0)
    8000437e:	b7c5                	j	8000435e <exec+0x2d4>
    80004380:	df243c23          	sd	s2,-520(s0)
    80004384:	bfe9                	j	8000435e <exec+0x2d4>
    80004386:	df243c23          	sd	s2,-520(s0)
    8000438a:	bfd1                	j	8000435e <exec+0x2d4>
  sz = sz1;
    8000438c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004390:	4a81                	li	s5,0
    80004392:	b7f1                	j	8000435e <exec+0x2d4>
  sz = sz1;
    80004394:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004398:	4a81                	li	s5,0
    8000439a:	b7d1                	j	8000435e <exec+0x2d4>
  sz = sz1;
    8000439c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043a0:	4a81                	li	s5,0
    800043a2:	bf75                	j	8000435e <exec+0x2d4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800043a4:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043a8:	e0843783          	ld	a5,-504(s0)
    800043ac:	0017869b          	addiw	a3,a5,1
    800043b0:	e0d43423          	sd	a3,-504(s0)
    800043b4:	e0043783          	ld	a5,-512(s0)
    800043b8:	0387879b          	addiw	a5,a5,56
    800043bc:	e8845703          	lhu	a4,-376(s0)
    800043c0:	e0e6dfe3          	bge	a3,a4,800041de <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043c4:	2781                	sext.w	a5,a5
    800043c6:	e0f43023          	sd	a5,-512(s0)
    800043ca:	03800713          	li	a4,56
    800043ce:	86be                	mv	a3,a5
    800043d0:	e1840613          	addi	a2,s0,-488
    800043d4:	4581                	li	a1,0
    800043d6:	8556                	mv	a0,s5
    800043d8:	fffff097          	auipc	ra,0xfffff
    800043dc:	a28080e7          	jalr	-1496(ra) # 80002e00 <readi>
    800043e0:	03800793          	li	a5,56
    800043e4:	f6f51be3          	bne	a0,a5,8000435a <exec+0x2d0>
    if(ph.type != ELF_PROG_LOAD)
    800043e8:	e1842783          	lw	a5,-488(s0)
    800043ec:	4705                	li	a4,1
    800043ee:	fae79de3          	bne	a5,a4,800043a8 <exec+0x31e>
    if(ph.memsz < ph.filesz)
    800043f2:	e4043483          	ld	s1,-448(s0)
    800043f6:	e3843783          	ld	a5,-456(s0)
    800043fa:	f6f4ede3          	bltu	s1,a5,80004374 <exec+0x2ea>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800043fe:	e2843783          	ld	a5,-472(s0)
    80004402:	94be                	add	s1,s1,a5
    80004404:	f6f4ebe3          	bltu	s1,a5,8000437a <exec+0x2f0>
    if(ph.vaddr % PGSIZE != 0)
    80004408:	de043703          	ld	a4,-544(s0)
    8000440c:	8ff9                	and	a5,a5,a4
    8000440e:	fbad                	bnez	a5,80004380 <exec+0x2f6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004410:	e1c42503          	lw	a0,-484(s0)
    80004414:	00000097          	auipc	ra,0x0
    80004418:	c5c080e7          	jalr	-932(ra) # 80004070 <flags2perm>
    8000441c:	86aa                	mv	a3,a0
    8000441e:	8626                	mv	a2,s1
    80004420:	85ca                	mv	a1,s2
    80004422:	855a                	mv	a0,s6
    80004424:	ffffc097          	auipc	ra,0xffffc
    80004428:	4f0080e7          	jalr	1264(ra) # 80000914 <uvmalloc>
    8000442c:	dea43c23          	sd	a0,-520(s0)
    80004430:	d939                	beqz	a0,80004386 <exec+0x2fc>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004432:	e2843c03          	ld	s8,-472(s0)
    80004436:	e2042c83          	lw	s9,-480(s0)
    8000443a:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000443e:	f60b83e3          	beqz	s7,800043a4 <exec+0x31a>
    80004442:	89de                	mv	s3,s7
    80004444:	4481                	li	s1,0
    80004446:	bb9d                	j	800041bc <exec+0x132>

0000000080004448 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004448:	7179                	addi	sp,sp,-48
    8000444a:	f406                	sd	ra,40(sp)
    8000444c:	f022                	sd	s0,32(sp)
    8000444e:	ec26                	sd	s1,24(sp)
    80004450:	e84a                	sd	s2,16(sp)
    80004452:	1800                	addi	s0,sp,48
    80004454:	892e                	mv	s2,a1
    80004456:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004458:	fdc40593          	addi	a1,s0,-36
    8000445c:	ffffe097          	auipc	ra,0xffffe
    80004460:	b78080e7          	jalr	-1160(ra) # 80001fd4 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004464:	fdc42703          	lw	a4,-36(s0)
    80004468:	47bd                	li	a5,15
    8000446a:	02e7eb63          	bltu	a5,a4,800044a0 <argfd+0x58>
    8000446e:	ffffd097          	auipc	ra,0xffffd
    80004472:	a3e080e7          	jalr	-1474(ra) # 80000eac <myproc>
    80004476:	fdc42703          	lw	a4,-36(s0)
    8000447a:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffdbbba>
    8000447e:	078e                	slli	a5,a5,0x3
    80004480:	953e                	add	a0,a0,a5
    80004482:	611c                	ld	a5,0(a0)
    80004484:	c385                	beqz	a5,800044a4 <argfd+0x5c>
    return -1;
  if(pfd)
    80004486:	00090463          	beqz	s2,8000448e <argfd+0x46>
    *pfd = fd;
    8000448a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000448e:	4501                	li	a0,0
  if(pf)
    80004490:	c091                	beqz	s1,80004494 <argfd+0x4c>
    *pf = f;
    80004492:	e09c                	sd	a5,0(s1)
}
    80004494:	70a2                	ld	ra,40(sp)
    80004496:	7402                	ld	s0,32(sp)
    80004498:	64e2                	ld	s1,24(sp)
    8000449a:	6942                	ld	s2,16(sp)
    8000449c:	6145                	addi	sp,sp,48
    8000449e:	8082                	ret
    return -1;
    800044a0:	557d                	li	a0,-1
    800044a2:	bfcd                	j	80004494 <argfd+0x4c>
    800044a4:	557d                	li	a0,-1
    800044a6:	b7fd                	j	80004494 <argfd+0x4c>

00000000800044a8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044a8:	1101                	addi	sp,sp,-32
    800044aa:	ec06                	sd	ra,24(sp)
    800044ac:	e822                	sd	s0,16(sp)
    800044ae:	e426                	sd	s1,8(sp)
    800044b0:	1000                	addi	s0,sp,32
    800044b2:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044b4:	ffffd097          	auipc	ra,0xffffd
    800044b8:	9f8080e7          	jalr	-1544(ra) # 80000eac <myproc>
    800044bc:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044be:	0d050793          	addi	a5,a0,208
    800044c2:	4501                	li	a0,0
    800044c4:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044c6:	6398                	ld	a4,0(a5)
    800044c8:	cb19                	beqz	a4,800044de <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044ca:	2505                	addiw	a0,a0,1
    800044cc:	07a1                	addi	a5,a5,8
    800044ce:	fed51ce3          	bne	a0,a3,800044c6 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044d2:	557d                	li	a0,-1
}
    800044d4:	60e2                	ld	ra,24(sp)
    800044d6:	6442                	ld	s0,16(sp)
    800044d8:	64a2                	ld	s1,8(sp)
    800044da:	6105                	addi	sp,sp,32
    800044dc:	8082                	ret
      p->ofile[fd] = f;
    800044de:	01a50793          	addi	a5,a0,26
    800044e2:	078e                	slli	a5,a5,0x3
    800044e4:	963e                	add	a2,a2,a5
    800044e6:	e204                	sd	s1,0(a2)
      return fd;
    800044e8:	b7f5                	j	800044d4 <fdalloc+0x2c>

00000000800044ea <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800044ea:	715d                	addi	sp,sp,-80
    800044ec:	e486                	sd	ra,72(sp)
    800044ee:	e0a2                	sd	s0,64(sp)
    800044f0:	fc26                	sd	s1,56(sp)
    800044f2:	f84a                	sd	s2,48(sp)
    800044f4:	f44e                	sd	s3,40(sp)
    800044f6:	f052                	sd	s4,32(sp)
    800044f8:	ec56                	sd	s5,24(sp)
    800044fa:	e85a                	sd	s6,16(sp)
    800044fc:	0880                	addi	s0,sp,80
    800044fe:	8b2e                	mv	s6,a1
    80004500:	89b2                	mv	s3,a2
    80004502:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004504:	fb040593          	addi	a1,s0,-80
    80004508:	fffff097          	auipc	ra,0xfffff
    8000450c:	e0e080e7          	jalr	-498(ra) # 80003316 <nameiparent>
    80004510:	84aa                	mv	s1,a0
    80004512:	14050f63          	beqz	a0,80004670 <create+0x186>
    return 0;

  ilock(dp);
    80004516:	ffffe097          	auipc	ra,0xffffe
    8000451a:	636080e7          	jalr	1590(ra) # 80002b4c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000451e:	4601                	li	a2,0
    80004520:	fb040593          	addi	a1,s0,-80
    80004524:	8526                	mv	a0,s1
    80004526:	fffff097          	auipc	ra,0xfffff
    8000452a:	b0a080e7          	jalr	-1270(ra) # 80003030 <dirlookup>
    8000452e:	8aaa                	mv	s5,a0
    80004530:	c931                	beqz	a0,80004584 <create+0x9a>
    iunlockput(dp);
    80004532:	8526                	mv	a0,s1
    80004534:	fffff097          	auipc	ra,0xfffff
    80004538:	87a080e7          	jalr	-1926(ra) # 80002dae <iunlockput>
    ilock(ip);
    8000453c:	8556                	mv	a0,s5
    8000453e:	ffffe097          	auipc	ra,0xffffe
    80004542:	60e080e7          	jalr	1550(ra) # 80002b4c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004546:	000b059b          	sext.w	a1,s6
    8000454a:	4789                	li	a5,2
    8000454c:	02f59563          	bne	a1,a5,80004576 <create+0x8c>
    80004550:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdbbe4>
    80004554:	37f9                	addiw	a5,a5,-2
    80004556:	17c2                	slli	a5,a5,0x30
    80004558:	93c1                	srli	a5,a5,0x30
    8000455a:	4705                	li	a4,1
    8000455c:	00f76d63          	bltu	a4,a5,80004576 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004560:	8556                	mv	a0,s5
    80004562:	60a6                	ld	ra,72(sp)
    80004564:	6406                	ld	s0,64(sp)
    80004566:	74e2                	ld	s1,56(sp)
    80004568:	7942                	ld	s2,48(sp)
    8000456a:	79a2                	ld	s3,40(sp)
    8000456c:	7a02                	ld	s4,32(sp)
    8000456e:	6ae2                	ld	s5,24(sp)
    80004570:	6b42                	ld	s6,16(sp)
    80004572:	6161                	addi	sp,sp,80
    80004574:	8082                	ret
    iunlockput(ip);
    80004576:	8556                	mv	a0,s5
    80004578:	fffff097          	auipc	ra,0xfffff
    8000457c:	836080e7          	jalr	-1994(ra) # 80002dae <iunlockput>
    return 0;
    80004580:	4a81                	li	s5,0
    80004582:	bff9                	j	80004560 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004584:	85da                	mv	a1,s6
    80004586:	4088                	lw	a0,0(s1)
    80004588:	ffffe097          	auipc	ra,0xffffe
    8000458c:	426080e7          	jalr	1062(ra) # 800029ae <ialloc>
    80004590:	8a2a                	mv	s4,a0
    80004592:	c539                	beqz	a0,800045e0 <create+0xf6>
  ilock(ip);
    80004594:	ffffe097          	auipc	ra,0xffffe
    80004598:	5b8080e7          	jalr	1464(ra) # 80002b4c <ilock>
  ip->major = major;
    8000459c:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800045a0:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800045a4:	4905                	li	s2,1
    800045a6:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800045aa:	8552                	mv	a0,s4
    800045ac:	ffffe097          	auipc	ra,0xffffe
    800045b0:	4d4080e7          	jalr	1236(ra) # 80002a80 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045b4:	000b059b          	sext.w	a1,s6
    800045b8:	03258b63          	beq	a1,s2,800045ee <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    800045bc:	004a2603          	lw	a2,4(s4)
    800045c0:	fb040593          	addi	a1,s0,-80
    800045c4:	8526                	mv	a0,s1
    800045c6:	fffff097          	auipc	ra,0xfffff
    800045ca:	c80080e7          	jalr	-896(ra) # 80003246 <dirlink>
    800045ce:	06054f63          	bltz	a0,8000464c <create+0x162>
  iunlockput(dp);
    800045d2:	8526                	mv	a0,s1
    800045d4:	ffffe097          	auipc	ra,0xffffe
    800045d8:	7da080e7          	jalr	2010(ra) # 80002dae <iunlockput>
  return ip;
    800045dc:	8ad2                	mv	s5,s4
    800045de:	b749                	j	80004560 <create+0x76>
    iunlockput(dp);
    800045e0:	8526                	mv	a0,s1
    800045e2:	ffffe097          	auipc	ra,0xffffe
    800045e6:	7cc080e7          	jalr	1996(ra) # 80002dae <iunlockput>
    return 0;
    800045ea:	8ad2                	mv	s5,s4
    800045ec:	bf95                	j	80004560 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800045ee:	004a2603          	lw	a2,4(s4)
    800045f2:	00005597          	auipc	a1,0x5
    800045f6:	0ce58593          	addi	a1,a1,206 # 800096c0 <syscalls+0x2e0>
    800045fa:	8552                	mv	a0,s4
    800045fc:	fffff097          	auipc	ra,0xfffff
    80004600:	c4a080e7          	jalr	-950(ra) # 80003246 <dirlink>
    80004604:	04054463          	bltz	a0,8000464c <create+0x162>
    80004608:	40d0                	lw	a2,4(s1)
    8000460a:	00005597          	auipc	a1,0x5
    8000460e:	0be58593          	addi	a1,a1,190 # 800096c8 <syscalls+0x2e8>
    80004612:	8552                	mv	a0,s4
    80004614:	fffff097          	auipc	ra,0xfffff
    80004618:	c32080e7          	jalr	-974(ra) # 80003246 <dirlink>
    8000461c:	02054863          	bltz	a0,8000464c <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    80004620:	004a2603          	lw	a2,4(s4)
    80004624:	fb040593          	addi	a1,s0,-80
    80004628:	8526                	mv	a0,s1
    8000462a:	fffff097          	auipc	ra,0xfffff
    8000462e:	c1c080e7          	jalr	-996(ra) # 80003246 <dirlink>
    80004632:	00054d63          	bltz	a0,8000464c <create+0x162>
    dp->nlink++;  // for ".."
    80004636:	04a4d783          	lhu	a5,74(s1)
    8000463a:	2785                	addiw	a5,a5,1
    8000463c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004640:	8526                	mv	a0,s1
    80004642:	ffffe097          	auipc	ra,0xffffe
    80004646:	43e080e7          	jalr	1086(ra) # 80002a80 <iupdate>
    8000464a:	b761                	j	800045d2 <create+0xe8>
  ip->nlink = 0;
    8000464c:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004650:	8552                	mv	a0,s4
    80004652:	ffffe097          	auipc	ra,0xffffe
    80004656:	42e080e7          	jalr	1070(ra) # 80002a80 <iupdate>
  iunlockput(ip);
    8000465a:	8552                	mv	a0,s4
    8000465c:	ffffe097          	auipc	ra,0xffffe
    80004660:	752080e7          	jalr	1874(ra) # 80002dae <iunlockput>
  iunlockput(dp);
    80004664:	8526                	mv	a0,s1
    80004666:	ffffe097          	auipc	ra,0xffffe
    8000466a:	748080e7          	jalr	1864(ra) # 80002dae <iunlockput>
  return 0;
    8000466e:	bdcd                	j	80004560 <create+0x76>
    return 0;
    80004670:	8aaa                	mv	s5,a0
    80004672:	b5fd                	j	80004560 <create+0x76>

0000000080004674 <sys_dup>:
{
    80004674:	7179                	addi	sp,sp,-48
    80004676:	f406                	sd	ra,40(sp)
    80004678:	f022                	sd	s0,32(sp)
    8000467a:	ec26                	sd	s1,24(sp)
    8000467c:	e84a                	sd	s2,16(sp)
    8000467e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004680:	fd840613          	addi	a2,s0,-40
    80004684:	4581                	li	a1,0
    80004686:	4501                	li	a0,0
    80004688:	00000097          	auipc	ra,0x0
    8000468c:	dc0080e7          	jalr	-576(ra) # 80004448 <argfd>
    return -1;
    80004690:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004692:	02054363          	bltz	a0,800046b8 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80004696:	fd843903          	ld	s2,-40(s0)
    8000469a:	854a                	mv	a0,s2
    8000469c:	00000097          	auipc	ra,0x0
    800046a0:	e0c080e7          	jalr	-500(ra) # 800044a8 <fdalloc>
    800046a4:	84aa                	mv	s1,a0
    return -1;
    800046a6:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046a8:	00054863          	bltz	a0,800046b8 <sys_dup+0x44>
  filedup(f);
    800046ac:	854a                	mv	a0,s2
    800046ae:	fffff097          	auipc	ra,0xfffff
    800046b2:	2e0080e7          	jalr	736(ra) # 8000398e <filedup>
  return fd;
    800046b6:	87a6                	mv	a5,s1
}
    800046b8:	853e                	mv	a0,a5
    800046ba:	70a2                	ld	ra,40(sp)
    800046bc:	7402                	ld	s0,32(sp)
    800046be:	64e2                	ld	s1,24(sp)
    800046c0:	6942                	ld	s2,16(sp)
    800046c2:	6145                	addi	sp,sp,48
    800046c4:	8082                	ret

00000000800046c6 <sys_read>:
{
    800046c6:	7179                	addi	sp,sp,-48
    800046c8:	f406                	sd	ra,40(sp)
    800046ca:	f022                	sd	s0,32(sp)
    800046cc:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800046ce:	fd840593          	addi	a1,s0,-40
    800046d2:	4505                	li	a0,1
    800046d4:	ffffe097          	auipc	ra,0xffffe
    800046d8:	920080e7          	jalr	-1760(ra) # 80001ff4 <argaddr>
  argint(2, &n);
    800046dc:	fe440593          	addi	a1,s0,-28
    800046e0:	4509                	li	a0,2
    800046e2:	ffffe097          	auipc	ra,0xffffe
    800046e6:	8f2080e7          	jalr	-1806(ra) # 80001fd4 <argint>
  if(argfd(0, 0, &f) < 0)
    800046ea:	fe840613          	addi	a2,s0,-24
    800046ee:	4581                	li	a1,0
    800046f0:	4501                	li	a0,0
    800046f2:	00000097          	auipc	ra,0x0
    800046f6:	d56080e7          	jalr	-682(ra) # 80004448 <argfd>
    800046fa:	87aa                	mv	a5,a0
    return -1;
    800046fc:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800046fe:	0007cc63          	bltz	a5,80004716 <sys_read+0x50>
  return fileread(f, p, n);
    80004702:	fe442603          	lw	a2,-28(s0)
    80004706:	fd843583          	ld	a1,-40(s0)
    8000470a:	fe843503          	ld	a0,-24(s0)
    8000470e:	fffff097          	auipc	ra,0xfffff
    80004712:	428080e7          	jalr	1064(ra) # 80003b36 <fileread>
}
    80004716:	70a2                	ld	ra,40(sp)
    80004718:	7402                	ld	s0,32(sp)
    8000471a:	6145                	addi	sp,sp,48
    8000471c:	8082                	ret

000000008000471e <sys_write>:
{
    8000471e:	7179                	addi	sp,sp,-48
    80004720:	f406                	sd	ra,40(sp)
    80004722:	f022                	sd	s0,32(sp)
    80004724:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004726:	fd840593          	addi	a1,s0,-40
    8000472a:	4505                	li	a0,1
    8000472c:	ffffe097          	auipc	ra,0xffffe
    80004730:	8c8080e7          	jalr	-1848(ra) # 80001ff4 <argaddr>
  argint(2, &n);
    80004734:	fe440593          	addi	a1,s0,-28
    80004738:	4509                	li	a0,2
    8000473a:	ffffe097          	auipc	ra,0xffffe
    8000473e:	89a080e7          	jalr	-1894(ra) # 80001fd4 <argint>
  if(argfd(0, 0, &f) < 0)
    80004742:	fe840613          	addi	a2,s0,-24
    80004746:	4581                	li	a1,0
    80004748:	4501                	li	a0,0
    8000474a:	00000097          	auipc	ra,0x0
    8000474e:	cfe080e7          	jalr	-770(ra) # 80004448 <argfd>
    80004752:	87aa                	mv	a5,a0
    return -1;
    80004754:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004756:	0007cc63          	bltz	a5,8000476e <sys_write+0x50>
  return filewrite(f, p, n);
    8000475a:	fe442603          	lw	a2,-28(s0)
    8000475e:	fd843583          	ld	a1,-40(s0)
    80004762:	fe843503          	ld	a0,-24(s0)
    80004766:	fffff097          	auipc	ra,0xfffff
    8000476a:	4a6080e7          	jalr	1190(ra) # 80003c0c <filewrite>
}
    8000476e:	70a2                	ld	ra,40(sp)
    80004770:	7402                	ld	s0,32(sp)
    80004772:	6145                	addi	sp,sp,48
    80004774:	8082                	ret

0000000080004776 <sys_close>:
{
    80004776:	1101                	addi	sp,sp,-32
    80004778:	ec06                	sd	ra,24(sp)
    8000477a:	e822                	sd	s0,16(sp)
    8000477c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000477e:	fe040613          	addi	a2,s0,-32
    80004782:	fec40593          	addi	a1,s0,-20
    80004786:	4501                	li	a0,0
    80004788:	00000097          	auipc	ra,0x0
    8000478c:	cc0080e7          	jalr	-832(ra) # 80004448 <argfd>
    return -1;
    80004790:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004792:	02054463          	bltz	a0,800047ba <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004796:	ffffc097          	auipc	ra,0xffffc
    8000479a:	716080e7          	jalr	1814(ra) # 80000eac <myproc>
    8000479e:	fec42783          	lw	a5,-20(s0)
    800047a2:	07e9                	addi	a5,a5,26
    800047a4:	078e                	slli	a5,a5,0x3
    800047a6:	953e                	add	a0,a0,a5
    800047a8:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800047ac:	fe043503          	ld	a0,-32(s0)
    800047b0:	fffff097          	auipc	ra,0xfffff
    800047b4:	230080e7          	jalr	560(ra) # 800039e0 <fileclose>
  return 0;
    800047b8:	4781                	li	a5,0
}
    800047ba:	853e                	mv	a0,a5
    800047bc:	60e2                	ld	ra,24(sp)
    800047be:	6442                	ld	s0,16(sp)
    800047c0:	6105                	addi	sp,sp,32
    800047c2:	8082                	ret

00000000800047c4 <sys_fstat>:
{
    800047c4:	1101                	addi	sp,sp,-32
    800047c6:	ec06                	sd	ra,24(sp)
    800047c8:	e822                	sd	s0,16(sp)
    800047ca:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800047cc:	fe040593          	addi	a1,s0,-32
    800047d0:	4505                	li	a0,1
    800047d2:	ffffe097          	auipc	ra,0xffffe
    800047d6:	822080e7          	jalr	-2014(ra) # 80001ff4 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800047da:	fe840613          	addi	a2,s0,-24
    800047de:	4581                	li	a1,0
    800047e0:	4501                	li	a0,0
    800047e2:	00000097          	auipc	ra,0x0
    800047e6:	c66080e7          	jalr	-922(ra) # 80004448 <argfd>
    800047ea:	87aa                	mv	a5,a0
    return -1;
    800047ec:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047ee:	0007ca63          	bltz	a5,80004802 <sys_fstat+0x3e>
  return filestat(f, st);
    800047f2:	fe043583          	ld	a1,-32(s0)
    800047f6:	fe843503          	ld	a0,-24(s0)
    800047fa:	fffff097          	auipc	ra,0xfffff
    800047fe:	2ca080e7          	jalr	714(ra) # 80003ac4 <filestat>
}
    80004802:	60e2                	ld	ra,24(sp)
    80004804:	6442                	ld	s0,16(sp)
    80004806:	6105                	addi	sp,sp,32
    80004808:	8082                	ret

000000008000480a <sys_link>:
{
    8000480a:	7169                	addi	sp,sp,-304
    8000480c:	f606                	sd	ra,296(sp)
    8000480e:	f222                	sd	s0,288(sp)
    80004810:	ee26                	sd	s1,280(sp)
    80004812:	ea4a                	sd	s2,272(sp)
    80004814:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004816:	08000613          	li	a2,128
    8000481a:	ed040593          	addi	a1,s0,-304
    8000481e:	4501                	li	a0,0
    80004820:	ffffd097          	auipc	ra,0xffffd
    80004824:	7f4080e7          	jalr	2036(ra) # 80002014 <argstr>
    return -1;
    80004828:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000482a:	10054e63          	bltz	a0,80004946 <sys_link+0x13c>
    8000482e:	08000613          	li	a2,128
    80004832:	f5040593          	addi	a1,s0,-176
    80004836:	4505                	li	a0,1
    80004838:	ffffd097          	auipc	ra,0xffffd
    8000483c:	7dc080e7          	jalr	2012(ra) # 80002014 <argstr>
    return -1;
    80004840:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004842:	10054263          	bltz	a0,80004946 <sys_link+0x13c>
  begin_op();
    80004846:	fffff097          	auipc	ra,0xfffff
    8000484a:	cd2080e7          	jalr	-814(ra) # 80003518 <begin_op>
  if((ip = namei(old)) == 0){
    8000484e:	ed040513          	addi	a0,s0,-304
    80004852:	fffff097          	auipc	ra,0xfffff
    80004856:	aa6080e7          	jalr	-1370(ra) # 800032f8 <namei>
    8000485a:	84aa                	mv	s1,a0
    8000485c:	c551                	beqz	a0,800048e8 <sys_link+0xde>
  ilock(ip);
    8000485e:	ffffe097          	auipc	ra,0xffffe
    80004862:	2ee080e7          	jalr	750(ra) # 80002b4c <ilock>
  if(ip->type == T_DIR){
    80004866:	04449703          	lh	a4,68(s1)
    8000486a:	4785                	li	a5,1
    8000486c:	08f70463          	beq	a4,a5,800048f4 <sys_link+0xea>
  ip->nlink++;
    80004870:	04a4d783          	lhu	a5,74(s1)
    80004874:	2785                	addiw	a5,a5,1
    80004876:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000487a:	8526                	mv	a0,s1
    8000487c:	ffffe097          	auipc	ra,0xffffe
    80004880:	204080e7          	jalr	516(ra) # 80002a80 <iupdate>
  iunlock(ip);
    80004884:	8526                	mv	a0,s1
    80004886:	ffffe097          	auipc	ra,0xffffe
    8000488a:	388080e7          	jalr	904(ra) # 80002c0e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000488e:	fd040593          	addi	a1,s0,-48
    80004892:	f5040513          	addi	a0,s0,-176
    80004896:	fffff097          	auipc	ra,0xfffff
    8000489a:	a80080e7          	jalr	-1408(ra) # 80003316 <nameiparent>
    8000489e:	892a                	mv	s2,a0
    800048a0:	c935                	beqz	a0,80004914 <sys_link+0x10a>
  ilock(dp);
    800048a2:	ffffe097          	auipc	ra,0xffffe
    800048a6:	2aa080e7          	jalr	682(ra) # 80002b4c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048aa:	00092703          	lw	a4,0(s2)
    800048ae:	409c                	lw	a5,0(s1)
    800048b0:	04f71d63          	bne	a4,a5,8000490a <sys_link+0x100>
    800048b4:	40d0                	lw	a2,4(s1)
    800048b6:	fd040593          	addi	a1,s0,-48
    800048ba:	854a                	mv	a0,s2
    800048bc:	fffff097          	auipc	ra,0xfffff
    800048c0:	98a080e7          	jalr	-1654(ra) # 80003246 <dirlink>
    800048c4:	04054363          	bltz	a0,8000490a <sys_link+0x100>
  iunlockput(dp);
    800048c8:	854a                	mv	a0,s2
    800048ca:	ffffe097          	auipc	ra,0xffffe
    800048ce:	4e4080e7          	jalr	1252(ra) # 80002dae <iunlockput>
  iput(ip);
    800048d2:	8526                	mv	a0,s1
    800048d4:	ffffe097          	auipc	ra,0xffffe
    800048d8:	432080e7          	jalr	1074(ra) # 80002d06 <iput>
  end_op();
    800048dc:	fffff097          	auipc	ra,0xfffff
    800048e0:	cba080e7          	jalr	-838(ra) # 80003596 <end_op>
  return 0;
    800048e4:	4781                	li	a5,0
    800048e6:	a085                	j	80004946 <sys_link+0x13c>
    end_op();
    800048e8:	fffff097          	auipc	ra,0xfffff
    800048ec:	cae080e7          	jalr	-850(ra) # 80003596 <end_op>
    return -1;
    800048f0:	57fd                	li	a5,-1
    800048f2:	a891                	j	80004946 <sys_link+0x13c>
    iunlockput(ip);
    800048f4:	8526                	mv	a0,s1
    800048f6:	ffffe097          	auipc	ra,0xffffe
    800048fa:	4b8080e7          	jalr	1208(ra) # 80002dae <iunlockput>
    end_op();
    800048fe:	fffff097          	auipc	ra,0xfffff
    80004902:	c98080e7          	jalr	-872(ra) # 80003596 <end_op>
    return -1;
    80004906:	57fd                	li	a5,-1
    80004908:	a83d                	j	80004946 <sys_link+0x13c>
    iunlockput(dp);
    8000490a:	854a                	mv	a0,s2
    8000490c:	ffffe097          	auipc	ra,0xffffe
    80004910:	4a2080e7          	jalr	1186(ra) # 80002dae <iunlockput>
  ilock(ip);
    80004914:	8526                	mv	a0,s1
    80004916:	ffffe097          	auipc	ra,0xffffe
    8000491a:	236080e7          	jalr	566(ra) # 80002b4c <ilock>
  ip->nlink--;
    8000491e:	04a4d783          	lhu	a5,74(s1)
    80004922:	37fd                	addiw	a5,a5,-1
    80004924:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004928:	8526                	mv	a0,s1
    8000492a:	ffffe097          	auipc	ra,0xffffe
    8000492e:	156080e7          	jalr	342(ra) # 80002a80 <iupdate>
  iunlockput(ip);
    80004932:	8526                	mv	a0,s1
    80004934:	ffffe097          	auipc	ra,0xffffe
    80004938:	47a080e7          	jalr	1146(ra) # 80002dae <iunlockput>
  end_op();
    8000493c:	fffff097          	auipc	ra,0xfffff
    80004940:	c5a080e7          	jalr	-934(ra) # 80003596 <end_op>
  return -1;
    80004944:	57fd                	li	a5,-1
}
    80004946:	853e                	mv	a0,a5
    80004948:	70b2                	ld	ra,296(sp)
    8000494a:	7412                	ld	s0,288(sp)
    8000494c:	64f2                	ld	s1,280(sp)
    8000494e:	6952                	ld	s2,272(sp)
    80004950:	6155                	addi	sp,sp,304
    80004952:	8082                	ret

0000000080004954 <sys_unlink>:
{
    80004954:	7151                	addi	sp,sp,-240
    80004956:	f586                	sd	ra,232(sp)
    80004958:	f1a2                	sd	s0,224(sp)
    8000495a:	eda6                	sd	s1,216(sp)
    8000495c:	e9ca                	sd	s2,208(sp)
    8000495e:	e5ce                	sd	s3,200(sp)
    80004960:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004962:	08000613          	li	a2,128
    80004966:	f3040593          	addi	a1,s0,-208
    8000496a:	4501                	li	a0,0
    8000496c:	ffffd097          	auipc	ra,0xffffd
    80004970:	6a8080e7          	jalr	1704(ra) # 80002014 <argstr>
    80004974:	18054163          	bltz	a0,80004af6 <sys_unlink+0x1a2>
  begin_op();
    80004978:	fffff097          	auipc	ra,0xfffff
    8000497c:	ba0080e7          	jalr	-1120(ra) # 80003518 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004980:	fb040593          	addi	a1,s0,-80
    80004984:	f3040513          	addi	a0,s0,-208
    80004988:	fffff097          	auipc	ra,0xfffff
    8000498c:	98e080e7          	jalr	-1650(ra) # 80003316 <nameiparent>
    80004990:	84aa                	mv	s1,a0
    80004992:	c979                	beqz	a0,80004a68 <sys_unlink+0x114>
  ilock(dp);
    80004994:	ffffe097          	auipc	ra,0xffffe
    80004998:	1b8080e7          	jalr	440(ra) # 80002b4c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000499c:	00005597          	auipc	a1,0x5
    800049a0:	d2458593          	addi	a1,a1,-732 # 800096c0 <syscalls+0x2e0>
    800049a4:	fb040513          	addi	a0,s0,-80
    800049a8:	ffffe097          	auipc	ra,0xffffe
    800049ac:	66e080e7          	jalr	1646(ra) # 80003016 <namecmp>
    800049b0:	14050a63          	beqz	a0,80004b04 <sys_unlink+0x1b0>
    800049b4:	00005597          	auipc	a1,0x5
    800049b8:	d1458593          	addi	a1,a1,-748 # 800096c8 <syscalls+0x2e8>
    800049bc:	fb040513          	addi	a0,s0,-80
    800049c0:	ffffe097          	auipc	ra,0xffffe
    800049c4:	656080e7          	jalr	1622(ra) # 80003016 <namecmp>
    800049c8:	12050e63          	beqz	a0,80004b04 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049cc:	f2c40613          	addi	a2,s0,-212
    800049d0:	fb040593          	addi	a1,s0,-80
    800049d4:	8526                	mv	a0,s1
    800049d6:	ffffe097          	auipc	ra,0xffffe
    800049da:	65a080e7          	jalr	1626(ra) # 80003030 <dirlookup>
    800049de:	892a                	mv	s2,a0
    800049e0:	12050263          	beqz	a0,80004b04 <sys_unlink+0x1b0>
  ilock(ip);
    800049e4:	ffffe097          	auipc	ra,0xffffe
    800049e8:	168080e7          	jalr	360(ra) # 80002b4c <ilock>
  if(ip->nlink < 1)
    800049ec:	04a91783          	lh	a5,74(s2)
    800049f0:	08f05263          	blez	a5,80004a74 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800049f4:	04491703          	lh	a4,68(s2)
    800049f8:	4785                	li	a5,1
    800049fa:	08f70563          	beq	a4,a5,80004a84 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800049fe:	4641                	li	a2,16
    80004a00:	4581                	li	a1,0
    80004a02:	fc040513          	addi	a0,s0,-64
    80004a06:	ffffb097          	auipc	ra,0xffffb
    80004a0a:	774080e7          	jalr	1908(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a0e:	4741                	li	a4,16
    80004a10:	f2c42683          	lw	a3,-212(s0)
    80004a14:	fc040613          	addi	a2,s0,-64
    80004a18:	4581                	li	a1,0
    80004a1a:	8526                	mv	a0,s1
    80004a1c:	ffffe097          	auipc	ra,0xffffe
    80004a20:	4dc080e7          	jalr	1244(ra) # 80002ef8 <writei>
    80004a24:	47c1                	li	a5,16
    80004a26:	0af51563          	bne	a0,a5,80004ad0 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a2a:	04491703          	lh	a4,68(s2)
    80004a2e:	4785                	li	a5,1
    80004a30:	0af70863          	beq	a4,a5,80004ae0 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a34:	8526                	mv	a0,s1
    80004a36:	ffffe097          	auipc	ra,0xffffe
    80004a3a:	378080e7          	jalr	888(ra) # 80002dae <iunlockput>
  ip->nlink--;
    80004a3e:	04a95783          	lhu	a5,74(s2)
    80004a42:	37fd                	addiw	a5,a5,-1
    80004a44:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a48:	854a                	mv	a0,s2
    80004a4a:	ffffe097          	auipc	ra,0xffffe
    80004a4e:	036080e7          	jalr	54(ra) # 80002a80 <iupdate>
  iunlockput(ip);
    80004a52:	854a                	mv	a0,s2
    80004a54:	ffffe097          	auipc	ra,0xffffe
    80004a58:	35a080e7          	jalr	858(ra) # 80002dae <iunlockput>
  end_op();
    80004a5c:	fffff097          	auipc	ra,0xfffff
    80004a60:	b3a080e7          	jalr	-1222(ra) # 80003596 <end_op>
  return 0;
    80004a64:	4501                	li	a0,0
    80004a66:	a84d                	j	80004b18 <sys_unlink+0x1c4>
    end_op();
    80004a68:	fffff097          	auipc	ra,0xfffff
    80004a6c:	b2e080e7          	jalr	-1234(ra) # 80003596 <end_op>
    return -1;
    80004a70:	557d                	li	a0,-1
    80004a72:	a05d                	j	80004b18 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a74:	00005517          	auipc	a0,0x5
    80004a78:	c5c50513          	addi	a0,a0,-932 # 800096d0 <syscalls+0x2f0>
    80004a7c:	00002097          	auipc	ra,0x2
    80004a80:	15e080e7          	jalr	350(ra) # 80006bda <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a84:	04c92703          	lw	a4,76(s2)
    80004a88:	02000793          	li	a5,32
    80004a8c:	f6e7f9e3          	bgeu	a5,a4,800049fe <sys_unlink+0xaa>
    80004a90:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a94:	4741                	li	a4,16
    80004a96:	86ce                	mv	a3,s3
    80004a98:	f1840613          	addi	a2,s0,-232
    80004a9c:	4581                	li	a1,0
    80004a9e:	854a                	mv	a0,s2
    80004aa0:	ffffe097          	auipc	ra,0xffffe
    80004aa4:	360080e7          	jalr	864(ra) # 80002e00 <readi>
    80004aa8:	47c1                	li	a5,16
    80004aaa:	00f51b63          	bne	a0,a5,80004ac0 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004aae:	f1845783          	lhu	a5,-232(s0)
    80004ab2:	e7a1                	bnez	a5,80004afa <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ab4:	29c1                	addiw	s3,s3,16
    80004ab6:	04c92783          	lw	a5,76(s2)
    80004aba:	fcf9ede3          	bltu	s3,a5,80004a94 <sys_unlink+0x140>
    80004abe:	b781                	j	800049fe <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004ac0:	00005517          	auipc	a0,0x5
    80004ac4:	c2850513          	addi	a0,a0,-984 # 800096e8 <syscalls+0x308>
    80004ac8:	00002097          	auipc	ra,0x2
    80004acc:	112080e7          	jalr	274(ra) # 80006bda <panic>
    panic("unlink: writei");
    80004ad0:	00005517          	auipc	a0,0x5
    80004ad4:	c3050513          	addi	a0,a0,-976 # 80009700 <syscalls+0x320>
    80004ad8:	00002097          	auipc	ra,0x2
    80004adc:	102080e7          	jalr	258(ra) # 80006bda <panic>
    dp->nlink--;
    80004ae0:	04a4d783          	lhu	a5,74(s1)
    80004ae4:	37fd                	addiw	a5,a5,-1
    80004ae6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004aea:	8526                	mv	a0,s1
    80004aec:	ffffe097          	auipc	ra,0xffffe
    80004af0:	f94080e7          	jalr	-108(ra) # 80002a80 <iupdate>
    80004af4:	b781                	j	80004a34 <sys_unlink+0xe0>
    return -1;
    80004af6:	557d                	li	a0,-1
    80004af8:	a005                	j	80004b18 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004afa:	854a                	mv	a0,s2
    80004afc:	ffffe097          	auipc	ra,0xffffe
    80004b00:	2b2080e7          	jalr	690(ra) # 80002dae <iunlockput>
  iunlockput(dp);
    80004b04:	8526                	mv	a0,s1
    80004b06:	ffffe097          	auipc	ra,0xffffe
    80004b0a:	2a8080e7          	jalr	680(ra) # 80002dae <iunlockput>
  end_op();
    80004b0e:	fffff097          	auipc	ra,0xfffff
    80004b12:	a88080e7          	jalr	-1400(ra) # 80003596 <end_op>
  return -1;
    80004b16:	557d                	li	a0,-1
}
    80004b18:	70ae                	ld	ra,232(sp)
    80004b1a:	740e                	ld	s0,224(sp)
    80004b1c:	64ee                	ld	s1,216(sp)
    80004b1e:	694e                	ld	s2,208(sp)
    80004b20:	69ae                	ld	s3,200(sp)
    80004b22:	616d                	addi	sp,sp,240
    80004b24:	8082                	ret

0000000080004b26 <sys_open>:

uint64
sys_open(void)
{
    80004b26:	7131                	addi	sp,sp,-192
    80004b28:	fd06                	sd	ra,184(sp)
    80004b2a:	f922                	sd	s0,176(sp)
    80004b2c:	f526                	sd	s1,168(sp)
    80004b2e:	f14a                	sd	s2,160(sp)
    80004b30:	ed4e                	sd	s3,152(sp)
    80004b32:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004b34:	f4c40593          	addi	a1,s0,-180
    80004b38:	4505                	li	a0,1
    80004b3a:	ffffd097          	auipc	ra,0xffffd
    80004b3e:	49a080e7          	jalr	1178(ra) # 80001fd4 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b42:	08000613          	li	a2,128
    80004b46:	f5040593          	addi	a1,s0,-176
    80004b4a:	4501                	li	a0,0
    80004b4c:	ffffd097          	auipc	ra,0xffffd
    80004b50:	4c8080e7          	jalr	1224(ra) # 80002014 <argstr>
    80004b54:	87aa                	mv	a5,a0
    return -1;
    80004b56:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b58:	0a07c963          	bltz	a5,80004c0a <sys_open+0xe4>

  begin_op();
    80004b5c:	fffff097          	auipc	ra,0xfffff
    80004b60:	9bc080e7          	jalr	-1604(ra) # 80003518 <begin_op>

  if(omode & O_CREATE){
    80004b64:	f4c42783          	lw	a5,-180(s0)
    80004b68:	2007f793          	andi	a5,a5,512
    80004b6c:	cfc5                	beqz	a5,80004c24 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b6e:	4681                	li	a3,0
    80004b70:	4601                	li	a2,0
    80004b72:	4589                	li	a1,2
    80004b74:	f5040513          	addi	a0,s0,-176
    80004b78:	00000097          	auipc	ra,0x0
    80004b7c:	972080e7          	jalr	-1678(ra) # 800044ea <create>
    80004b80:	84aa                	mv	s1,a0
    if(ip == 0){
    80004b82:	c959                	beqz	a0,80004c18 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b84:	04449703          	lh	a4,68(s1)
    80004b88:	478d                	li	a5,3
    80004b8a:	00f71763          	bne	a4,a5,80004b98 <sys_open+0x72>
    80004b8e:	0464d703          	lhu	a4,70(s1)
    80004b92:	47a5                	li	a5,9
    80004b94:	0ce7ed63          	bltu	a5,a4,80004c6e <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b98:	fffff097          	auipc	ra,0xfffff
    80004b9c:	d8c080e7          	jalr	-628(ra) # 80003924 <filealloc>
    80004ba0:	89aa                	mv	s3,a0
    80004ba2:	10050363          	beqz	a0,80004ca8 <sys_open+0x182>
    80004ba6:	00000097          	auipc	ra,0x0
    80004baa:	902080e7          	jalr	-1790(ra) # 800044a8 <fdalloc>
    80004bae:	892a                	mv	s2,a0
    80004bb0:	0e054763          	bltz	a0,80004c9e <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004bb4:	04449703          	lh	a4,68(s1)
    80004bb8:	478d                	li	a5,3
    80004bba:	0cf70563          	beq	a4,a5,80004c84 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bbe:	4789                	li	a5,2
    80004bc0:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004bc4:	0209a423          	sw	zero,40(s3)
  }
  f->ip = ip;
    80004bc8:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004bcc:	f4c42783          	lw	a5,-180(s0)
    80004bd0:	0017c713          	xori	a4,a5,1
    80004bd4:	8b05                	andi	a4,a4,1
    80004bd6:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004bda:	0037f713          	andi	a4,a5,3
    80004bde:	00e03733          	snez	a4,a4
    80004be2:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004be6:	4007f793          	andi	a5,a5,1024
    80004bea:	c791                	beqz	a5,80004bf6 <sys_open+0xd0>
    80004bec:	04449703          	lh	a4,68(s1)
    80004bf0:	4789                	li	a5,2
    80004bf2:	0af70063          	beq	a4,a5,80004c92 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004bf6:	8526                	mv	a0,s1
    80004bf8:	ffffe097          	auipc	ra,0xffffe
    80004bfc:	016080e7          	jalr	22(ra) # 80002c0e <iunlock>
  end_op();
    80004c00:	fffff097          	auipc	ra,0xfffff
    80004c04:	996080e7          	jalr	-1642(ra) # 80003596 <end_op>

  return fd;
    80004c08:	854a                	mv	a0,s2
}
    80004c0a:	70ea                	ld	ra,184(sp)
    80004c0c:	744a                	ld	s0,176(sp)
    80004c0e:	74aa                	ld	s1,168(sp)
    80004c10:	790a                	ld	s2,160(sp)
    80004c12:	69ea                	ld	s3,152(sp)
    80004c14:	6129                	addi	sp,sp,192
    80004c16:	8082                	ret
      end_op();
    80004c18:	fffff097          	auipc	ra,0xfffff
    80004c1c:	97e080e7          	jalr	-1666(ra) # 80003596 <end_op>
      return -1;
    80004c20:	557d                	li	a0,-1
    80004c22:	b7e5                	j	80004c0a <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c24:	f5040513          	addi	a0,s0,-176
    80004c28:	ffffe097          	auipc	ra,0xffffe
    80004c2c:	6d0080e7          	jalr	1744(ra) # 800032f8 <namei>
    80004c30:	84aa                	mv	s1,a0
    80004c32:	c905                	beqz	a0,80004c62 <sys_open+0x13c>
    ilock(ip);
    80004c34:	ffffe097          	auipc	ra,0xffffe
    80004c38:	f18080e7          	jalr	-232(ra) # 80002b4c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c3c:	04449703          	lh	a4,68(s1)
    80004c40:	4785                	li	a5,1
    80004c42:	f4f711e3          	bne	a4,a5,80004b84 <sys_open+0x5e>
    80004c46:	f4c42783          	lw	a5,-180(s0)
    80004c4a:	d7b9                	beqz	a5,80004b98 <sys_open+0x72>
      iunlockput(ip);
    80004c4c:	8526                	mv	a0,s1
    80004c4e:	ffffe097          	auipc	ra,0xffffe
    80004c52:	160080e7          	jalr	352(ra) # 80002dae <iunlockput>
      end_op();
    80004c56:	fffff097          	auipc	ra,0xfffff
    80004c5a:	940080e7          	jalr	-1728(ra) # 80003596 <end_op>
      return -1;
    80004c5e:	557d                	li	a0,-1
    80004c60:	b76d                	j	80004c0a <sys_open+0xe4>
      end_op();
    80004c62:	fffff097          	auipc	ra,0xfffff
    80004c66:	934080e7          	jalr	-1740(ra) # 80003596 <end_op>
      return -1;
    80004c6a:	557d                	li	a0,-1
    80004c6c:	bf79                	j	80004c0a <sys_open+0xe4>
    iunlockput(ip);
    80004c6e:	8526                	mv	a0,s1
    80004c70:	ffffe097          	auipc	ra,0xffffe
    80004c74:	13e080e7          	jalr	318(ra) # 80002dae <iunlockput>
    end_op();
    80004c78:	fffff097          	auipc	ra,0xfffff
    80004c7c:	91e080e7          	jalr	-1762(ra) # 80003596 <end_op>
    return -1;
    80004c80:	557d                	li	a0,-1
    80004c82:	b761                	j	80004c0a <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c84:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c88:	04649783          	lh	a5,70(s1)
    80004c8c:	02f99623          	sh	a5,44(s3)
    80004c90:	bf25                	j	80004bc8 <sys_open+0xa2>
    itrunc(ip);
    80004c92:	8526                	mv	a0,s1
    80004c94:	ffffe097          	auipc	ra,0xffffe
    80004c98:	fc6080e7          	jalr	-58(ra) # 80002c5a <itrunc>
    80004c9c:	bfa9                	j	80004bf6 <sys_open+0xd0>
      fileclose(f);
    80004c9e:	854e                	mv	a0,s3
    80004ca0:	fffff097          	auipc	ra,0xfffff
    80004ca4:	d40080e7          	jalr	-704(ra) # 800039e0 <fileclose>
    iunlockput(ip);
    80004ca8:	8526                	mv	a0,s1
    80004caa:	ffffe097          	auipc	ra,0xffffe
    80004cae:	104080e7          	jalr	260(ra) # 80002dae <iunlockput>
    end_op();
    80004cb2:	fffff097          	auipc	ra,0xfffff
    80004cb6:	8e4080e7          	jalr	-1820(ra) # 80003596 <end_op>
    return -1;
    80004cba:	557d                	li	a0,-1
    80004cbc:	b7b9                	j	80004c0a <sys_open+0xe4>

0000000080004cbe <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004cbe:	7175                	addi	sp,sp,-144
    80004cc0:	e506                	sd	ra,136(sp)
    80004cc2:	e122                	sd	s0,128(sp)
    80004cc4:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cc6:	fffff097          	auipc	ra,0xfffff
    80004cca:	852080e7          	jalr	-1966(ra) # 80003518 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004cce:	08000613          	li	a2,128
    80004cd2:	f7040593          	addi	a1,s0,-144
    80004cd6:	4501                	li	a0,0
    80004cd8:	ffffd097          	auipc	ra,0xffffd
    80004cdc:	33c080e7          	jalr	828(ra) # 80002014 <argstr>
    80004ce0:	02054963          	bltz	a0,80004d12 <sys_mkdir+0x54>
    80004ce4:	4681                	li	a3,0
    80004ce6:	4601                	li	a2,0
    80004ce8:	4585                	li	a1,1
    80004cea:	f7040513          	addi	a0,s0,-144
    80004cee:	fffff097          	auipc	ra,0xfffff
    80004cf2:	7fc080e7          	jalr	2044(ra) # 800044ea <create>
    80004cf6:	cd11                	beqz	a0,80004d12 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cf8:	ffffe097          	auipc	ra,0xffffe
    80004cfc:	0b6080e7          	jalr	182(ra) # 80002dae <iunlockput>
  end_op();
    80004d00:	fffff097          	auipc	ra,0xfffff
    80004d04:	896080e7          	jalr	-1898(ra) # 80003596 <end_op>
  return 0;
    80004d08:	4501                	li	a0,0
}
    80004d0a:	60aa                	ld	ra,136(sp)
    80004d0c:	640a                	ld	s0,128(sp)
    80004d0e:	6149                	addi	sp,sp,144
    80004d10:	8082                	ret
    end_op();
    80004d12:	fffff097          	auipc	ra,0xfffff
    80004d16:	884080e7          	jalr	-1916(ra) # 80003596 <end_op>
    return -1;
    80004d1a:	557d                	li	a0,-1
    80004d1c:	b7fd                	j	80004d0a <sys_mkdir+0x4c>

0000000080004d1e <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d1e:	7135                	addi	sp,sp,-160
    80004d20:	ed06                	sd	ra,152(sp)
    80004d22:	e922                	sd	s0,144(sp)
    80004d24:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d26:	ffffe097          	auipc	ra,0xffffe
    80004d2a:	7f2080e7          	jalr	2034(ra) # 80003518 <begin_op>
  argint(1, &major);
    80004d2e:	f6c40593          	addi	a1,s0,-148
    80004d32:	4505                	li	a0,1
    80004d34:	ffffd097          	auipc	ra,0xffffd
    80004d38:	2a0080e7          	jalr	672(ra) # 80001fd4 <argint>
  argint(2, &minor);
    80004d3c:	f6840593          	addi	a1,s0,-152
    80004d40:	4509                	li	a0,2
    80004d42:	ffffd097          	auipc	ra,0xffffd
    80004d46:	292080e7          	jalr	658(ra) # 80001fd4 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d4a:	08000613          	li	a2,128
    80004d4e:	f7040593          	addi	a1,s0,-144
    80004d52:	4501                	li	a0,0
    80004d54:	ffffd097          	auipc	ra,0xffffd
    80004d58:	2c0080e7          	jalr	704(ra) # 80002014 <argstr>
    80004d5c:	02054b63          	bltz	a0,80004d92 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d60:	f6841683          	lh	a3,-152(s0)
    80004d64:	f6c41603          	lh	a2,-148(s0)
    80004d68:	458d                	li	a1,3
    80004d6a:	f7040513          	addi	a0,s0,-144
    80004d6e:	fffff097          	auipc	ra,0xfffff
    80004d72:	77c080e7          	jalr	1916(ra) # 800044ea <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d76:	cd11                	beqz	a0,80004d92 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d78:	ffffe097          	auipc	ra,0xffffe
    80004d7c:	036080e7          	jalr	54(ra) # 80002dae <iunlockput>
  end_op();
    80004d80:	fffff097          	auipc	ra,0xfffff
    80004d84:	816080e7          	jalr	-2026(ra) # 80003596 <end_op>
  return 0;
    80004d88:	4501                	li	a0,0
}
    80004d8a:	60ea                	ld	ra,152(sp)
    80004d8c:	644a                	ld	s0,144(sp)
    80004d8e:	610d                	addi	sp,sp,160
    80004d90:	8082                	ret
    end_op();
    80004d92:	fffff097          	auipc	ra,0xfffff
    80004d96:	804080e7          	jalr	-2044(ra) # 80003596 <end_op>
    return -1;
    80004d9a:	557d                	li	a0,-1
    80004d9c:	b7fd                	j	80004d8a <sys_mknod+0x6c>

0000000080004d9e <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d9e:	7135                	addi	sp,sp,-160
    80004da0:	ed06                	sd	ra,152(sp)
    80004da2:	e922                	sd	s0,144(sp)
    80004da4:	e526                	sd	s1,136(sp)
    80004da6:	e14a                	sd	s2,128(sp)
    80004da8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004daa:	ffffc097          	auipc	ra,0xffffc
    80004dae:	102080e7          	jalr	258(ra) # 80000eac <myproc>
    80004db2:	892a                	mv	s2,a0
  
  begin_op();
    80004db4:	ffffe097          	auipc	ra,0xffffe
    80004db8:	764080e7          	jalr	1892(ra) # 80003518 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004dbc:	08000613          	li	a2,128
    80004dc0:	f6040593          	addi	a1,s0,-160
    80004dc4:	4501                	li	a0,0
    80004dc6:	ffffd097          	auipc	ra,0xffffd
    80004dca:	24e080e7          	jalr	590(ra) # 80002014 <argstr>
    80004dce:	04054b63          	bltz	a0,80004e24 <sys_chdir+0x86>
    80004dd2:	f6040513          	addi	a0,s0,-160
    80004dd6:	ffffe097          	auipc	ra,0xffffe
    80004dda:	522080e7          	jalr	1314(ra) # 800032f8 <namei>
    80004dde:	84aa                	mv	s1,a0
    80004de0:	c131                	beqz	a0,80004e24 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004de2:	ffffe097          	auipc	ra,0xffffe
    80004de6:	d6a080e7          	jalr	-662(ra) # 80002b4c <ilock>
  if(ip->type != T_DIR){
    80004dea:	04449703          	lh	a4,68(s1)
    80004dee:	4785                	li	a5,1
    80004df0:	04f71063          	bne	a4,a5,80004e30 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004df4:	8526                	mv	a0,s1
    80004df6:	ffffe097          	auipc	ra,0xffffe
    80004dfa:	e18080e7          	jalr	-488(ra) # 80002c0e <iunlock>
  iput(p->cwd);
    80004dfe:	15093503          	ld	a0,336(s2)
    80004e02:	ffffe097          	auipc	ra,0xffffe
    80004e06:	f04080e7          	jalr	-252(ra) # 80002d06 <iput>
  end_op();
    80004e0a:	ffffe097          	auipc	ra,0xffffe
    80004e0e:	78c080e7          	jalr	1932(ra) # 80003596 <end_op>
  p->cwd = ip;
    80004e12:	14993823          	sd	s1,336(s2)
  return 0;
    80004e16:	4501                	li	a0,0
}
    80004e18:	60ea                	ld	ra,152(sp)
    80004e1a:	644a                	ld	s0,144(sp)
    80004e1c:	64aa                	ld	s1,136(sp)
    80004e1e:	690a                	ld	s2,128(sp)
    80004e20:	610d                	addi	sp,sp,160
    80004e22:	8082                	ret
    end_op();
    80004e24:	ffffe097          	auipc	ra,0xffffe
    80004e28:	772080e7          	jalr	1906(ra) # 80003596 <end_op>
    return -1;
    80004e2c:	557d                	li	a0,-1
    80004e2e:	b7ed                	j	80004e18 <sys_chdir+0x7a>
    iunlockput(ip);
    80004e30:	8526                	mv	a0,s1
    80004e32:	ffffe097          	auipc	ra,0xffffe
    80004e36:	f7c080e7          	jalr	-132(ra) # 80002dae <iunlockput>
    end_op();
    80004e3a:	ffffe097          	auipc	ra,0xffffe
    80004e3e:	75c080e7          	jalr	1884(ra) # 80003596 <end_op>
    return -1;
    80004e42:	557d                	li	a0,-1
    80004e44:	bfd1                	j	80004e18 <sys_chdir+0x7a>

0000000080004e46 <sys_exec>:

uint64
sys_exec(void)
{
    80004e46:	7145                	addi	sp,sp,-464
    80004e48:	e786                	sd	ra,456(sp)
    80004e4a:	e3a2                	sd	s0,448(sp)
    80004e4c:	ff26                	sd	s1,440(sp)
    80004e4e:	fb4a                	sd	s2,432(sp)
    80004e50:	f74e                	sd	s3,424(sp)
    80004e52:	f352                	sd	s4,416(sp)
    80004e54:	ef56                	sd	s5,408(sp)
    80004e56:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004e58:	e3840593          	addi	a1,s0,-456
    80004e5c:	4505                	li	a0,1
    80004e5e:	ffffd097          	auipc	ra,0xffffd
    80004e62:	196080e7          	jalr	406(ra) # 80001ff4 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004e66:	08000613          	li	a2,128
    80004e6a:	f4040593          	addi	a1,s0,-192
    80004e6e:	4501                	li	a0,0
    80004e70:	ffffd097          	auipc	ra,0xffffd
    80004e74:	1a4080e7          	jalr	420(ra) # 80002014 <argstr>
    80004e78:	87aa                	mv	a5,a0
    return -1;
    80004e7a:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004e7c:	0c07c363          	bltz	a5,80004f42 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004e80:	10000613          	li	a2,256
    80004e84:	4581                	li	a1,0
    80004e86:	e4040513          	addi	a0,s0,-448
    80004e8a:	ffffb097          	auipc	ra,0xffffb
    80004e8e:	2f0080e7          	jalr	752(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e92:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004e96:	89a6                	mv	s3,s1
    80004e98:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e9a:	02000a13          	li	s4,32
    80004e9e:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004ea2:	00391513          	slli	a0,s2,0x3
    80004ea6:	e3040593          	addi	a1,s0,-464
    80004eaa:	e3843783          	ld	a5,-456(s0)
    80004eae:	953e                	add	a0,a0,a5
    80004eb0:	ffffd097          	auipc	ra,0xffffd
    80004eb4:	086080e7          	jalr	134(ra) # 80001f36 <fetchaddr>
    80004eb8:	02054a63          	bltz	a0,80004eec <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004ebc:	e3043783          	ld	a5,-464(s0)
    80004ec0:	c3b9                	beqz	a5,80004f06 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ec2:	ffffb097          	auipc	ra,0xffffb
    80004ec6:	258080e7          	jalr	600(ra) # 8000011a <kalloc>
    80004eca:	85aa                	mv	a1,a0
    80004ecc:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004ed0:	cd11                	beqz	a0,80004eec <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ed2:	6605                	lui	a2,0x1
    80004ed4:	e3043503          	ld	a0,-464(s0)
    80004ed8:	ffffd097          	auipc	ra,0xffffd
    80004edc:	0b0080e7          	jalr	176(ra) # 80001f88 <fetchstr>
    80004ee0:	00054663          	bltz	a0,80004eec <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004ee4:	0905                	addi	s2,s2,1
    80004ee6:	09a1                	addi	s3,s3,8
    80004ee8:	fb491be3          	bne	s2,s4,80004e9e <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004eec:	f4040913          	addi	s2,s0,-192
    80004ef0:	6088                	ld	a0,0(s1)
    80004ef2:	c539                	beqz	a0,80004f40 <sys_exec+0xfa>
    kfree(argv[i]);
    80004ef4:	ffffb097          	auipc	ra,0xffffb
    80004ef8:	128080e7          	jalr	296(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004efc:	04a1                	addi	s1,s1,8
    80004efe:	ff2499e3          	bne	s1,s2,80004ef0 <sys_exec+0xaa>
  return -1;
    80004f02:	557d                	li	a0,-1
    80004f04:	a83d                	j	80004f42 <sys_exec+0xfc>
      argv[i] = 0;
    80004f06:	0a8e                	slli	s5,s5,0x3
    80004f08:	fc0a8793          	addi	a5,s5,-64
    80004f0c:	00878ab3          	add	s5,a5,s0
    80004f10:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f14:	e4040593          	addi	a1,s0,-448
    80004f18:	f4040513          	addi	a0,s0,-192
    80004f1c:	fffff097          	auipc	ra,0xfffff
    80004f20:	16e080e7          	jalr	366(ra) # 8000408a <exec>
    80004f24:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f26:	f4040993          	addi	s3,s0,-192
    80004f2a:	6088                	ld	a0,0(s1)
    80004f2c:	c901                	beqz	a0,80004f3c <sys_exec+0xf6>
    kfree(argv[i]);
    80004f2e:	ffffb097          	auipc	ra,0xffffb
    80004f32:	0ee080e7          	jalr	238(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f36:	04a1                	addi	s1,s1,8
    80004f38:	ff3499e3          	bne	s1,s3,80004f2a <sys_exec+0xe4>
  return ret;
    80004f3c:	854a                	mv	a0,s2
    80004f3e:	a011                	j	80004f42 <sys_exec+0xfc>
  return -1;
    80004f40:	557d                	li	a0,-1
}
    80004f42:	60be                	ld	ra,456(sp)
    80004f44:	641e                	ld	s0,448(sp)
    80004f46:	74fa                	ld	s1,440(sp)
    80004f48:	795a                	ld	s2,432(sp)
    80004f4a:	79ba                	ld	s3,424(sp)
    80004f4c:	7a1a                	ld	s4,416(sp)
    80004f4e:	6afa                	ld	s5,408(sp)
    80004f50:	6179                	addi	sp,sp,464
    80004f52:	8082                	ret

0000000080004f54 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f54:	7139                	addi	sp,sp,-64
    80004f56:	fc06                	sd	ra,56(sp)
    80004f58:	f822                	sd	s0,48(sp)
    80004f5a:	f426                	sd	s1,40(sp)
    80004f5c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f5e:	ffffc097          	auipc	ra,0xffffc
    80004f62:	f4e080e7          	jalr	-178(ra) # 80000eac <myproc>
    80004f66:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004f68:	fd840593          	addi	a1,s0,-40
    80004f6c:	4501                	li	a0,0
    80004f6e:	ffffd097          	auipc	ra,0xffffd
    80004f72:	086080e7          	jalr	134(ra) # 80001ff4 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004f76:	fc840593          	addi	a1,s0,-56
    80004f7a:	fd040513          	addi	a0,s0,-48
    80004f7e:	fffff097          	auipc	ra,0xfffff
    80004f82:	dc2080e7          	jalr	-574(ra) # 80003d40 <pipealloc>
    return -1;
    80004f86:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f88:	0c054463          	bltz	a0,80005050 <sys_pipe+0xfc>
  fd0 = -1;
    80004f8c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f90:	fd043503          	ld	a0,-48(s0)
    80004f94:	fffff097          	auipc	ra,0xfffff
    80004f98:	514080e7          	jalr	1300(ra) # 800044a8 <fdalloc>
    80004f9c:	fca42223          	sw	a0,-60(s0)
    80004fa0:	08054b63          	bltz	a0,80005036 <sys_pipe+0xe2>
    80004fa4:	fc843503          	ld	a0,-56(s0)
    80004fa8:	fffff097          	auipc	ra,0xfffff
    80004fac:	500080e7          	jalr	1280(ra) # 800044a8 <fdalloc>
    80004fb0:	fca42023          	sw	a0,-64(s0)
    80004fb4:	06054863          	bltz	a0,80005024 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fb8:	4691                	li	a3,4
    80004fba:	fc440613          	addi	a2,s0,-60
    80004fbe:	fd843583          	ld	a1,-40(s0)
    80004fc2:	68a8                	ld	a0,80(s1)
    80004fc4:	ffffc097          	auipc	ra,0xffffc
    80004fc8:	bac080e7          	jalr	-1108(ra) # 80000b70 <copyout>
    80004fcc:	02054063          	bltz	a0,80004fec <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004fd0:	4691                	li	a3,4
    80004fd2:	fc040613          	addi	a2,s0,-64
    80004fd6:	fd843583          	ld	a1,-40(s0)
    80004fda:	0591                	addi	a1,a1,4
    80004fdc:	68a8                	ld	a0,80(s1)
    80004fde:	ffffc097          	auipc	ra,0xffffc
    80004fe2:	b92080e7          	jalr	-1134(ra) # 80000b70 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004fe6:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fe8:	06055463          	bgez	a0,80005050 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80004fec:	fc442783          	lw	a5,-60(s0)
    80004ff0:	07e9                	addi	a5,a5,26
    80004ff2:	078e                	slli	a5,a5,0x3
    80004ff4:	97a6                	add	a5,a5,s1
    80004ff6:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004ffa:	fc042783          	lw	a5,-64(s0)
    80004ffe:	07e9                	addi	a5,a5,26
    80005000:	078e                	slli	a5,a5,0x3
    80005002:	94be                	add	s1,s1,a5
    80005004:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005008:	fd043503          	ld	a0,-48(s0)
    8000500c:	fffff097          	auipc	ra,0xfffff
    80005010:	9d4080e7          	jalr	-1580(ra) # 800039e0 <fileclose>
    fileclose(wf);
    80005014:	fc843503          	ld	a0,-56(s0)
    80005018:	fffff097          	auipc	ra,0xfffff
    8000501c:	9c8080e7          	jalr	-1592(ra) # 800039e0 <fileclose>
    return -1;
    80005020:	57fd                	li	a5,-1
    80005022:	a03d                	j	80005050 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005024:	fc442783          	lw	a5,-60(s0)
    80005028:	0007c763          	bltz	a5,80005036 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    8000502c:	07e9                	addi	a5,a5,26
    8000502e:	078e                	slli	a5,a5,0x3
    80005030:	97a6                	add	a5,a5,s1
    80005032:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005036:	fd043503          	ld	a0,-48(s0)
    8000503a:	fffff097          	auipc	ra,0xfffff
    8000503e:	9a6080e7          	jalr	-1626(ra) # 800039e0 <fileclose>
    fileclose(wf);
    80005042:	fc843503          	ld	a0,-56(s0)
    80005046:	fffff097          	auipc	ra,0xfffff
    8000504a:	99a080e7          	jalr	-1638(ra) # 800039e0 <fileclose>
    return -1;
    8000504e:	57fd                	li	a5,-1
}
    80005050:	853e                	mv	a0,a5
    80005052:	70e2                	ld	ra,56(sp)
    80005054:	7442                	ld	s0,48(sp)
    80005056:	74a2                	ld	s1,40(sp)
    80005058:	6121                	addi	sp,sp,64
    8000505a:	8082                	ret

000000008000505c <sys_connect>:


#ifdef LAB_NET
int
sys_connect(void)
{
    8000505c:	7179                	addi	sp,sp,-48
    8000505e:	f406                	sd	ra,40(sp)
    80005060:	f022                	sd	s0,32(sp)
    80005062:	1800                	addi	s0,sp,48
  int fd;
  uint32 raddr;
  uint32 rport;
  uint32 lport;

  argint(0, (int*)&raddr);
    80005064:	fe440593          	addi	a1,s0,-28
    80005068:	4501                	li	a0,0
    8000506a:	ffffd097          	auipc	ra,0xffffd
    8000506e:	f6a080e7          	jalr	-150(ra) # 80001fd4 <argint>
  argint(1, (int*)&lport);
    80005072:	fdc40593          	addi	a1,s0,-36
    80005076:	4505                	li	a0,1
    80005078:	ffffd097          	auipc	ra,0xffffd
    8000507c:	f5c080e7          	jalr	-164(ra) # 80001fd4 <argint>
  argint(2, (int*)&rport);
    80005080:	fe040593          	addi	a1,s0,-32
    80005084:	4509                	li	a0,2
    80005086:	ffffd097          	auipc	ra,0xffffd
    8000508a:	f4e080e7          	jalr	-178(ra) # 80001fd4 <argint>

  if(sockalloc(&f, raddr, lport, rport) < 0)
    8000508e:	fe045683          	lhu	a3,-32(s0)
    80005092:	fdc45603          	lhu	a2,-36(s0)
    80005096:	fe442583          	lw	a1,-28(s0)
    8000509a:	fe840513          	addi	a0,s0,-24
    8000509e:	00001097          	auipc	ra,0x1
    800050a2:	1a8080e7          	jalr	424(ra) # 80006246 <sockalloc>
    800050a6:	02054663          	bltz	a0,800050d2 <sys_connect+0x76>
    return -1;
  if((fd=fdalloc(f)) < 0){
    800050aa:	fe843503          	ld	a0,-24(s0)
    800050ae:	fffff097          	auipc	ra,0xfffff
    800050b2:	3fa080e7          	jalr	1018(ra) # 800044a8 <fdalloc>
    800050b6:	00054663          	bltz	a0,800050c2 <sys_connect+0x66>
    fileclose(f);
    return -1;
  }

  return fd;
}
    800050ba:	70a2                	ld	ra,40(sp)
    800050bc:	7402                	ld	s0,32(sp)
    800050be:	6145                	addi	sp,sp,48
    800050c0:	8082                	ret
    fileclose(f);
    800050c2:	fe843503          	ld	a0,-24(s0)
    800050c6:	fffff097          	auipc	ra,0xfffff
    800050ca:	91a080e7          	jalr	-1766(ra) # 800039e0 <fileclose>
    return -1;
    800050ce:	557d                	li	a0,-1
    800050d0:	b7ed                	j	800050ba <sys_connect+0x5e>
    return -1;
    800050d2:	557d                	li	a0,-1
    800050d4:	b7dd                	j	800050ba <sys_connect+0x5e>
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
    80005120:	ce3fc0ef          	jal	ra,80001e02 <kerneltrap>
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
    800051aa:	0791                	addi	a5,a5,4 # c000004 <_entry-0x73fffffc>
  
#ifdef LAB_NET
  // PCIE IRQs are 32 to 35
  for(int irq = 1; irq < 0x35; irq++){
    *(uint32*)(PLIC + irq*4) = 1;
    800051ac:	4685                	li	a3,1
  for(int irq = 1; irq < 0x35; irq++){
    800051ae:	0c000737          	lui	a4,0xc000
    800051b2:	0d470713          	addi	a4,a4,212 # c0000d4 <_entry-0x73ffff2c>
    *(uint32*)(PLIC + irq*4) = 1;
    800051b6:	c394                	sw	a3,0(a5)
  for(int irq = 1; irq < 0x35; irq++){
    800051b8:	0791                	addi	a5,a5,4
    800051ba:	fee79ee3          	bne	a5,a4,800051b6 <plicinit+0x1c>
  }
#endif  
}
    800051be:	6422                	ld	s0,8(sp)
    800051c0:	0141                	addi	sp,sp,16
    800051c2:	8082                	ret

00000000800051c4 <plicinithart>:

void
plicinithart(void)
{
    800051c4:	1141                	addi	sp,sp,-16
    800051c6:	e406                	sd	ra,8(sp)
    800051c8:	e022                	sd	s0,0(sp)
    800051ca:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051cc:	ffffc097          	auipc	ra,0xffffc
    800051d0:	cb4080e7          	jalr	-844(ra) # 80000e80 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800051d4:	0085171b          	slliw	a4,a0,0x8
    800051d8:	0c0027b7          	lui	a5,0xc002
    800051dc:	97ba                	add	a5,a5,a4
    800051de:	40200713          	li	a4,1026
    800051e2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

#ifdef LAB_NET
  // hack to get at next 32 IRQs for e1000
  *(uint32*)(PLIC_SENABLE(hart)+4) = 0xffffffff;
    800051e6:	577d                	li	a4,-1
    800051e8:	08e7a223          	sw	a4,132(a5)
#endif
  
  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800051ec:	00d5151b          	slliw	a0,a0,0xd
    800051f0:	0c2017b7          	lui	a5,0xc201
    800051f4:	97aa                	add	a5,a5,a0
    800051f6:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800051fa:	60a2                	ld	ra,8(sp)
    800051fc:	6402                	ld	s0,0(sp)
    800051fe:	0141                	addi	sp,sp,16
    80005200:	8082                	ret

0000000080005202 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005202:	1141                	addi	sp,sp,-16
    80005204:	e406                	sd	ra,8(sp)
    80005206:	e022                	sd	s0,0(sp)
    80005208:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000520a:	ffffc097          	auipc	ra,0xffffc
    8000520e:	c76080e7          	jalr	-906(ra) # 80000e80 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005212:	00d5151b          	slliw	a0,a0,0xd
    80005216:	0c2017b7          	lui	a5,0xc201
    8000521a:	97aa                	add	a5,a5,a0
  return irq;
}
    8000521c:	43c8                	lw	a0,4(a5)
    8000521e:	60a2                	ld	ra,8(sp)
    80005220:	6402                	ld	s0,0(sp)
    80005222:	0141                	addi	sp,sp,16
    80005224:	8082                	ret

0000000080005226 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005226:	1101                	addi	sp,sp,-32
    80005228:	ec06                	sd	ra,24(sp)
    8000522a:	e822                	sd	s0,16(sp)
    8000522c:	e426                	sd	s1,8(sp)
    8000522e:	1000                	addi	s0,sp,32
    80005230:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005232:	ffffc097          	auipc	ra,0xffffc
    80005236:	c4e080e7          	jalr	-946(ra) # 80000e80 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000523a:	00d5151b          	slliw	a0,a0,0xd
    8000523e:	0c2017b7          	lui	a5,0xc201
    80005242:	97aa                	add	a5,a5,a0
    80005244:	c3c4                	sw	s1,4(a5)
}
    80005246:	60e2                	ld	ra,24(sp)
    80005248:	6442                	ld	s0,16(sp)
    8000524a:	64a2                	ld	s1,8(sp)
    8000524c:	6105                	addi	sp,sp,32
    8000524e:	8082                	ret

0000000080005250 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005250:	1141                	addi	sp,sp,-16
    80005252:	e406                	sd	ra,8(sp)
    80005254:	e022                	sd	s0,0(sp)
    80005256:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005258:	479d                	li	a5,7
    8000525a:	04a7cc63          	blt	a5,a0,800052b2 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    8000525e:	00016797          	auipc	a5,0x16
    80005262:	b4278793          	addi	a5,a5,-1214 # 8001ada0 <disk>
    80005266:	97aa                	add	a5,a5,a0
    80005268:	0187c783          	lbu	a5,24(a5)
    8000526c:	ebb9                	bnez	a5,800052c2 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000526e:	00451693          	slli	a3,a0,0x4
    80005272:	00016797          	auipc	a5,0x16
    80005276:	b2e78793          	addi	a5,a5,-1234 # 8001ada0 <disk>
    8000527a:	6398                	ld	a4,0(a5)
    8000527c:	9736                	add	a4,a4,a3
    8000527e:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005282:	6398                	ld	a4,0(a5)
    80005284:	9736                	add	a4,a4,a3
    80005286:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000528a:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    8000528e:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005292:	97aa                	add	a5,a5,a0
    80005294:	4705                	li	a4,1
    80005296:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000529a:	00016517          	auipc	a0,0x16
    8000529e:	b1e50513          	addi	a0,a0,-1250 # 8001adb8 <disk+0x18>
    800052a2:	ffffc097          	auipc	ra,0xffffc
    800052a6:	316080e7          	jalr	790(ra) # 800015b8 <wakeup>
}
    800052aa:	60a2                	ld	ra,8(sp)
    800052ac:	6402                	ld	s0,0(sp)
    800052ae:	0141                	addi	sp,sp,16
    800052b0:	8082                	ret
    panic("free_desc 1");
    800052b2:	00004517          	auipc	a0,0x4
    800052b6:	45e50513          	addi	a0,a0,1118 # 80009710 <syscalls+0x330>
    800052ba:	00002097          	auipc	ra,0x2
    800052be:	920080e7          	jalr	-1760(ra) # 80006bda <panic>
    panic("free_desc 2");
    800052c2:	00004517          	auipc	a0,0x4
    800052c6:	45e50513          	addi	a0,a0,1118 # 80009720 <syscalls+0x340>
    800052ca:	00002097          	auipc	ra,0x2
    800052ce:	910080e7          	jalr	-1776(ra) # 80006bda <panic>

00000000800052d2 <virtio_disk_init>:
{
    800052d2:	1101                	addi	sp,sp,-32
    800052d4:	ec06                	sd	ra,24(sp)
    800052d6:	e822                	sd	s0,16(sp)
    800052d8:	e426                	sd	s1,8(sp)
    800052da:	e04a                	sd	s2,0(sp)
    800052dc:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800052de:	00004597          	auipc	a1,0x4
    800052e2:	45258593          	addi	a1,a1,1106 # 80009730 <syscalls+0x350>
    800052e6:	00016517          	auipc	a0,0x16
    800052ea:	be250513          	addi	a0,a0,-1054 # 8001aec8 <disk+0x128>
    800052ee:	00002097          	auipc	ra,0x2
    800052f2:	d94080e7          	jalr	-620(ra) # 80007082 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052f6:	100017b7          	lui	a5,0x10001
    800052fa:	4398                	lw	a4,0(a5)
    800052fc:	2701                	sext.w	a4,a4
    800052fe:	747277b7          	lui	a5,0x74727
    80005302:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005306:	14f71b63          	bne	a4,a5,8000545c <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000530a:	100017b7          	lui	a5,0x10001
    8000530e:	43dc                	lw	a5,4(a5)
    80005310:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005312:	4709                	li	a4,2
    80005314:	14e79463          	bne	a5,a4,8000545c <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005318:	100017b7          	lui	a5,0x10001
    8000531c:	479c                	lw	a5,8(a5)
    8000531e:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005320:	12e79e63          	bne	a5,a4,8000545c <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005324:	100017b7          	lui	a5,0x10001
    80005328:	47d8                	lw	a4,12(a5)
    8000532a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000532c:	554d47b7          	lui	a5,0x554d4
    80005330:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005334:	12f71463          	bne	a4,a5,8000545c <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005338:	100017b7          	lui	a5,0x10001
    8000533c:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005340:	4705                	li	a4,1
    80005342:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005344:	470d                	li	a4,3
    80005346:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005348:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000534a:	c7ffe6b7          	lui	a3,0xc7ffe
    8000534e:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb2ff>
    80005352:	8f75                	and	a4,a4,a3
    80005354:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005356:	472d                	li	a4,11
    80005358:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    8000535a:	5bbc                	lw	a5,112(a5)
    8000535c:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005360:	8ba1                	andi	a5,a5,8
    80005362:	10078563          	beqz	a5,8000546c <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005366:	100017b7          	lui	a5,0x10001
    8000536a:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8000536e:	43fc                	lw	a5,68(a5)
    80005370:	2781                	sext.w	a5,a5
    80005372:	10079563          	bnez	a5,8000547c <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005376:	100017b7          	lui	a5,0x10001
    8000537a:	5bdc                	lw	a5,52(a5)
    8000537c:	2781                	sext.w	a5,a5
  if(max == 0)
    8000537e:	10078763          	beqz	a5,8000548c <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005382:	471d                	li	a4,7
    80005384:	10f77c63          	bgeu	a4,a5,8000549c <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    80005388:	ffffb097          	auipc	ra,0xffffb
    8000538c:	d92080e7          	jalr	-622(ra) # 8000011a <kalloc>
    80005390:	00016497          	auipc	s1,0x16
    80005394:	a1048493          	addi	s1,s1,-1520 # 8001ada0 <disk>
    80005398:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    8000539a:	ffffb097          	auipc	ra,0xffffb
    8000539e:	d80080e7          	jalr	-640(ra) # 8000011a <kalloc>
    800053a2:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800053a4:	ffffb097          	auipc	ra,0xffffb
    800053a8:	d76080e7          	jalr	-650(ra) # 8000011a <kalloc>
    800053ac:	87aa                	mv	a5,a0
    800053ae:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800053b0:	6088                	ld	a0,0(s1)
    800053b2:	cd6d                	beqz	a0,800054ac <virtio_disk_init+0x1da>
    800053b4:	00016717          	auipc	a4,0x16
    800053b8:	9f473703          	ld	a4,-1548(a4) # 8001ada8 <disk+0x8>
    800053bc:	cb65                	beqz	a4,800054ac <virtio_disk_init+0x1da>
    800053be:	c7fd                	beqz	a5,800054ac <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    800053c0:	6605                	lui	a2,0x1
    800053c2:	4581                	li	a1,0
    800053c4:	ffffb097          	auipc	ra,0xffffb
    800053c8:	db6080e7          	jalr	-586(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    800053cc:	00016497          	auipc	s1,0x16
    800053d0:	9d448493          	addi	s1,s1,-1580 # 8001ada0 <disk>
    800053d4:	6605                	lui	a2,0x1
    800053d6:	4581                	li	a1,0
    800053d8:	6488                	ld	a0,8(s1)
    800053da:	ffffb097          	auipc	ra,0xffffb
    800053de:	da0080e7          	jalr	-608(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    800053e2:	6605                	lui	a2,0x1
    800053e4:	4581                	li	a1,0
    800053e6:	6888                	ld	a0,16(s1)
    800053e8:	ffffb097          	auipc	ra,0xffffb
    800053ec:	d92080e7          	jalr	-622(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800053f0:	100017b7          	lui	a5,0x10001
    800053f4:	4721                	li	a4,8
    800053f6:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800053f8:	4098                	lw	a4,0(s1)
    800053fa:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800053fe:	40d8                	lw	a4,4(s1)
    80005400:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005404:	6498                	ld	a4,8(s1)
    80005406:	0007069b          	sext.w	a3,a4
    8000540a:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    8000540e:	9701                	srai	a4,a4,0x20
    80005410:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005414:	6898                	ld	a4,16(s1)
    80005416:	0007069b          	sext.w	a3,a4
    8000541a:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000541e:	9701                	srai	a4,a4,0x20
    80005420:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005424:	4705                	li	a4,1
    80005426:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80005428:	00e48c23          	sb	a4,24(s1)
    8000542c:	00e48ca3          	sb	a4,25(s1)
    80005430:	00e48d23          	sb	a4,26(s1)
    80005434:	00e48da3          	sb	a4,27(s1)
    80005438:	00e48e23          	sb	a4,28(s1)
    8000543c:	00e48ea3          	sb	a4,29(s1)
    80005440:	00e48f23          	sb	a4,30(s1)
    80005444:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005448:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    8000544c:	0727a823          	sw	s2,112(a5)
}
    80005450:	60e2                	ld	ra,24(sp)
    80005452:	6442                	ld	s0,16(sp)
    80005454:	64a2                	ld	s1,8(sp)
    80005456:	6902                	ld	s2,0(sp)
    80005458:	6105                	addi	sp,sp,32
    8000545a:	8082                	ret
    panic("could not find virtio disk");
    8000545c:	00004517          	auipc	a0,0x4
    80005460:	2e450513          	addi	a0,a0,740 # 80009740 <syscalls+0x360>
    80005464:	00001097          	auipc	ra,0x1
    80005468:	776080e7          	jalr	1910(ra) # 80006bda <panic>
    panic("virtio disk FEATURES_OK unset");
    8000546c:	00004517          	auipc	a0,0x4
    80005470:	2f450513          	addi	a0,a0,756 # 80009760 <syscalls+0x380>
    80005474:	00001097          	auipc	ra,0x1
    80005478:	766080e7          	jalr	1894(ra) # 80006bda <panic>
    panic("virtio disk should not be ready");
    8000547c:	00004517          	auipc	a0,0x4
    80005480:	30450513          	addi	a0,a0,772 # 80009780 <syscalls+0x3a0>
    80005484:	00001097          	auipc	ra,0x1
    80005488:	756080e7          	jalr	1878(ra) # 80006bda <panic>
    panic("virtio disk has no queue 0");
    8000548c:	00004517          	auipc	a0,0x4
    80005490:	31450513          	addi	a0,a0,788 # 800097a0 <syscalls+0x3c0>
    80005494:	00001097          	auipc	ra,0x1
    80005498:	746080e7          	jalr	1862(ra) # 80006bda <panic>
    panic("virtio disk max queue too short");
    8000549c:	00004517          	auipc	a0,0x4
    800054a0:	32450513          	addi	a0,a0,804 # 800097c0 <syscalls+0x3e0>
    800054a4:	00001097          	auipc	ra,0x1
    800054a8:	736080e7          	jalr	1846(ra) # 80006bda <panic>
    panic("virtio disk kalloc");
    800054ac:	00004517          	auipc	a0,0x4
    800054b0:	33450513          	addi	a0,a0,820 # 800097e0 <syscalls+0x400>
    800054b4:	00001097          	auipc	ra,0x1
    800054b8:	726080e7          	jalr	1830(ra) # 80006bda <panic>

00000000800054bc <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800054bc:	7119                	addi	sp,sp,-128
    800054be:	fc86                	sd	ra,120(sp)
    800054c0:	f8a2                	sd	s0,112(sp)
    800054c2:	f4a6                	sd	s1,104(sp)
    800054c4:	f0ca                	sd	s2,96(sp)
    800054c6:	ecce                	sd	s3,88(sp)
    800054c8:	e8d2                	sd	s4,80(sp)
    800054ca:	e4d6                	sd	s5,72(sp)
    800054cc:	e0da                	sd	s6,64(sp)
    800054ce:	fc5e                	sd	s7,56(sp)
    800054d0:	f862                	sd	s8,48(sp)
    800054d2:	f466                	sd	s9,40(sp)
    800054d4:	f06a                	sd	s10,32(sp)
    800054d6:	ec6e                	sd	s11,24(sp)
    800054d8:	0100                	addi	s0,sp,128
    800054da:	8aaa                	mv	s5,a0
    800054dc:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800054de:	00c52d03          	lw	s10,12(a0)
    800054e2:	001d1d1b          	slliw	s10,s10,0x1
    800054e6:	1d02                	slli	s10,s10,0x20
    800054e8:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    800054ec:	00016517          	auipc	a0,0x16
    800054f0:	9dc50513          	addi	a0,a0,-1572 # 8001aec8 <disk+0x128>
    800054f4:	00002097          	auipc	ra,0x2
    800054f8:	c1e080e7          	jalr	-994(ra) # 80007112 <acquire>
  for(int i = 0; i < 3; i++){
    800054fc:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800054fe:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005500:	00016b97          	auipc	s7,0x16
    80005504:	8a0b8b93          	addi	s7,s7,-1888 # 8001ada0 <disk>
  for(int i = 0; i < 3; i++){
    80005508:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000550a:	00016c97          	auipc	s9,0x16
    8000550e:	9bec8c93          	addi	s9,s9,-1602 # 8001aec8 <disk+0x128>
    80005512:	a08d                	j	80005574 <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80005514:	00fb8733          	add	a4,s7,a5
    80005518:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000551c:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000551e:	0207c563          	bltz	a5,80005548 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    80005522:	2905                	addiw	s2,s2,1
    80005524:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005526:	05690c63          	beq	s2,s6,8000557e <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    8000552a:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000552c:	00016717          	auipc	a4,0x16
    80005530:	87470713          	addi	a4,a4,-1932 # 8001ada0 <disk>
    80005534:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005536:	01874683          	lbu	a3,24(a4)
    8000553a:	fee9                	bnez	a3,80005514 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    8000553c:	2785                	addiw	a5,a5,1
    8000553e:	0705                	addi	a4,a4,1
    80005540:	fe979be3          	bne	a5,s1,80005536 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    80005544:	57fd                	li	a5,-1
    80005546:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005548:	01205d63          	blez	s2,80005562 <virtio_disk_rw+0xa6>
    8000554c:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    8000554e:	000a2503          	lw	a0,0(s4)
    80005552:	00000097          	auipc	ra,0x0
    80005556:	cfe080e7          	jalr	-770(ra) # 80005250 <free_desc>
      for(int j = 0; j < i; j++)
    8000555a:	2d85                	addiw	s11,s11,1
    8000555c:	0a11                	addi	s4,s4,4
    8000555e:	ff2d98e3          	bne	s11,s2,8000554e <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005562:	85e6                	mv	a1,s9
    80005564:	00016517          	auipc	a0,0x16
    80005568:	85450513          	addi	a0,a0,-1964 # 8001adb8 <disk+0x18>
    8000556c:	ffffc097          	auipc	ra,0xffffc
    80005570:	fe8080e7          	jalr	-24(ra) # 80001554 <sleep>
  for(int i = 0; i < 3; i++){
    80005574:	f8040a13          	addi	s4,s0,-128
{
    80005578:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    8000557a:	894e                	mv	s2,s3
    8000557c:	b77d                	j	8000552a <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000557e:	f8042503          	lw	a0,-128(s0)
    80005582:	00a50713          	addi	a4,a0,10
    80005586:	0712                	slli	a4,a4,0x4

  if(write)
    80005588:	00016797          	auipc	a5,0x16
    8000558c:	81878793          	addi	a5,a5,-2024 # 8001ada0 <disk>
    80005590:	00e786b3          	add	a3,a5,a4
    80005594:	01803633          	snez	a2,s8
    80005598:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000559a:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    8000559e:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800055a2:	f6070613          	addi	a2,a4,-160
    800055a6:	6394                	ld	a3,0(a5)
    800055a8:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055aa:	00870593          	addi	a1,a4,8
    800055ae:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800055b0:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055b2:	0007b803          	ld	a6,0(a5)
    800055b6:	9642                	add	a2,a2,a6
    800055b8:	46c1                	li	a3,16
    800055ba:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055bc:	4585                	li	a1,1
    800055be:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    800055c2:	f8442683          	lw	a3,-124(s0)
    800055c6:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800055ca:	0692                	slli	a3,a3,0x4
    800055cc:	9836                	add	a6,a6,a3
    800055ce:	058a8613          	addi	a2,s5,88
    800055d2:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    800055d6:	0007b803          	ld	a6,0(a5)
    800055da:	96c2                	add	a3,a3,a6
    800055dc:	40000613          	li	a2,1024
    800055e0:	c690                	sw	a2,8(a3)
  if(write)
    800055e2:	001c3613          	seqz	a2,s8
    800055e6:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055ea:	00166613          	ori	a2,a2,1
    800055ee:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800055f2:	f8842603          	lw	a2,-120(s0)
    800055f6:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800055fa:	00250693          	addi	a3,a0,2
    800055fe:	0692                	slli	a3,a3,0x4
    80005600:	96be                	add	a3,a3,a5
    80005602:	58fd                	li	a7,-1
    80005604:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005608:	0612                	slli	a2,a2,0x4
    8000560a:	9832                	add	a6,a6,a2
    8000560c:	f9070713          	addi	a4,a4,-112
    80005610:	973e                	add	a4,a4,a5
    80005612:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    80005616:	6398                	ld	a4,0(a5)
    80005618:	9732                	add	a4,a4,a2
    8000561a:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000561c:	4609                	li	a2,2
    8000561e:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80005622:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005626:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    8000562a:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000562e:	6794                	ld	a3,8(a5)
    80005630:	0026d703          	lhu	a4,2(a3)
    80005634:	8b1d                	andi	a4,a4,7
    80005636:	0706                	slli	a4,a4,0x1
    80005638:	96ba                	add	a3,a3,a4
    8000563a:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000563e:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005642:	6798                	ld	a4,8(a5)
    80005644:	00275783          	lhu	a5,2(a4)
    80005648:	2785                	addiw	a5,a5,1
    8000564a:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000564e:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005652:	100017b7          	lui	a5,0x10001
    80005656:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000565a:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    8000565e:	00016917          	auipc	s2,0x16
    80005662:	86a90913          	addi	s2,s2,-1942 # 8001aec8 <disk+0x128>
  while(b->disk == 1) {
    80005666:	4485                	li	s1,1
    80005668:	00b79c63          	bne	a5,a1,80005680 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    8000566c:	85ca                	mv	a1,s2
    8000566e:	8556                	mv	a0,s5
    80005670:	ffffc097          	auipc	ra,0xffffc
    80005674:	ee4080e7          	jalr	-284(ra) # 80001554 <sleep>
  while(b->disk == 1) {
    80005678:	004aa783          	lw	a5,4(s5)
    8000567c:	fe9788e3          	beq	a5,s1,8000566c <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005680:	f8042903          	lw	s2,-128(s0)
    80005684:	00290713          	addi	a4,s2,2
    80005688:	0712                	slli	a4,a4,0x4
    8000568a:	00015797          	auipc	a5,0x15
    8000568e:	71678793          	addi	a5,a5,1814 # 8001ada0 <disk>
    80005692:	97ba                	add	a5,a5,a4
    80005694:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005698:	00015997          	auipc	s3,0x15
    8000569c:	70898993          	addi	s3,s3,1800 # 8001ada0 <disk>
    800056a0:	00491713          	slli	a4,s2,0x4
    800056a4:	0009b783          	ld	a5,0(s3)
    800056a8:	97ba                	add	a5,a5,a4
    800056aa:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056ae:	854a                	mv	a0,s2
    800056b0:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056b4:	00000097          	auipc	ra,0x0
    800056b8:	b9c080e7          	jalr	-1124(ra) # 80005250 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056bc:	8885                	andi	s1,s1,1
    800056be:	f0ed                	bnez	s1,800056a0 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056c0:	00016517          	auipc	a0,0x16
    800056c4:	80850513          	addi	a0,a0,-2040 # 8001aec8 <disk+0x128>
    800056c8:	00002097          	auipc	ra,0x2
    800056cc:	afe080e7          	jalr	-1282(ra) # 800071c6 <release>
}
    800056d0:	70e6                	ld	ra,120(sp)
    800056d2:	7446                	ld	s0,112(sp)
    800056d4:	74a6                	ld	s1,104(sp)
    800056d6:	7906                	ld	s2,96(sp)
    800056d8:	69e6                	ld	s3,88(sp)
    800056da:	6a46                	ld	s4,80(sp)
    800056dc:	6aa6                	ld	s5,72(sp)
    800056de:	6b06                	ld	s6,64(sp)
    800056e0:	7be2                	ld	s7,56(sp)
    800056e2:	7c42                	ld	s8,48(sp)
    800056e4:	7ca2                	ld	s9,40(sp)
    800056e6:	7d02                	ld	s10,32(sp)
    800056e8:	6de2                	ld	s11,24(sp)
    800056ea:	6109                	addi	sp,sp,128
    800056ec:	8082                	ret

00000000800056ee <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800056ee:	1101                	addi	sp,sp,-32
    800056f0:	ec06                	sd	ra,24(sp)
    800056f2:	e822                	sd	s0,16(sp)
    800056f4:	e426                	sd	s1,8(sp)
    800056f6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800056f8:	00015497          	auipc	s1,0x15
    800056fc:	6a848493          	addi	s1,s1,1704 # 8001ada0 <disk>
    80005700:	00015517          	auipc	a0,0x15
    80005704:	7c850513          	addi	a0,a0,1992 # 8001aec8 <disk+0x128>
    80005708:	00002097          	auipc	ra,0x2
    8000570c:	a0a080e7          	jalr	-1526(ra) # 80007112 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005710:	10001737          	lui	a4,0x10001
    80005714:	533c                	lw	a5,96(a4)
    80005716:	8b8d                	andi	a5,a5,3
    80005718:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000571a:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000571e:	689c                	ld	a5,16(s1)
    80005720:	0204d703          	lhu	a4,32(s1)
    80005724:	0027d783          	lhu	a5,2(a5)
    80005728:	04f70863          	beq	a4,a5,80005778 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    8000572c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005730:	6898                	ld	a4,16(s1)
    80005732:	0204d783          	lhu	a5,32(s1)
    80005736:	8b9d                	andi	a5,a5,7
    80005738:	078e                	slli	a5,a5,0x3
    8000573a:	97ba                	add	a5,a5,a4
    8000573c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000573e:	00278713          	addi	a4,a5,2
    80005742:	0712                	slli	a4,a4,0x4
    80005744:	9726                	add	a4,a4,s1
    80005746:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    8000574a:	e721                	bnez	a4,80005792 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000574c:	0789                	addi	a5,a5,2
    8000574e:	0792                	slli	a5,a5,0x4
    80005750:	97a6                	add	a5,a5,s1
    80005752:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005754:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005758:	ffffc097          	auipc	ra,0xffffc
    8000575c:	e60080e7          	jalr	-416(ra) # 800015b8 <wakeup>

    disk.used_idx += 1;
    80005760:	0204d783          	lhu	a5,32(s1)
    80005764:	2785                	addiw	a5,a5,1
    80005766:	17c2                	slli	a5,a5,0x30
    80005768:	93c1                	srli	a5,a5,0x30
    8000576a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000576e:	6898                	ld	a4,16(s1)
    80005770:	00275703          	lhu	a4,2(a4)
    80005774:	faf71ce3          	bne	a4,a5,8000572c <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005778:	00015517          	auipc	a0,0x15
    8000577c:	75050513          	addi	a0,a0,1872 # 8001aec8 <disk+0x128>
    80005780:	00002097          	auipc	ra,0x2
    80005784:	a46080e7          	jalr	-1466(ra) # 800071c6 <release>
}
    80005788:	60e2                	ld	ra,24(sp)
    8000578a:	6442                	ld	s0,16(sp)
    8000578c:	64a2                	ld	s1,8(sp)
    8000578e:	6105                	addi	sp,sp,32
    80005790:	8082                	ret
      panic("virtio_disk_intr status");
    80005792:	00004517          	auipc	a0,0x4
    80005796:	06650513          	addi	a0,a0,102 # 800097f8 <syscalls+0x418>
    8000579a:	00001097          	auipc	ra,0x1
    8000579e:	440080e7          	jalr	1088(ra) # 80006bda <panic>

00000000800057a2 <e1000_init>:

// called by pci_init().
// xregs is the memory address at which the
// e1000's registers are mapped.
void e1000_init(uint32 *xregs)
{
    800057a2:	7179                	addi	sp,sp,-48
    800057a4:	f406                	sd	ra,40(sp)
    800057a6:	f022                	sd	s0,32(sp)
    800057a8:	ec26                	sd	s1,24(sp)
    800057aa:	e84a                	sd	s2,16(sp)
    800057ac:	e44e                	sd	s3,8(sp)
    800057ae:	1800                	addi	s0,sp,48
    800057b0:	84aa                	mv	s1,a0
    int i;

    initlock(&e1000_lock, "e1000");
    800057b2:	00004597          	auipc	a1,0x4
    800057b6:	05e58593          	addi	a1,a1,94 # 80009810 <syscalls+0x430>
    800057ba:	00015517          	auipc	a0,0x15
    800057be:	72650513          	addi	a0,a0,1830 # 8001aee0 <e1000_lock>
    800057c2:	00002097          	auipc	ra,0x2
    800057c6:	8c0080e7          	jalr	-1856(ra) # 80007082 <initlock>

    regs = xregs;
    800057ca:	00004797          	auipc	a5,0x4
    800057ce:	1897bb23          	sd	s1,406(a5) # 80009960 <regs>

    // Reset the device
    regs[E1000_IMS] = 0; // disable interrupts
    800057d2:	0c04a823          	sw	zero,208(s1)
    regs[E1000_CTL] |= E1000_CTL_RST;
    800057d6:	409c                	lw	a5,0(s1)
    800057d8:	00400737          	lui	a4,0x400
    800057dc:	8fd9                	or	a5,a5,a4
    800057de:	c09c                	sw	a5,0(s1)
    regs[E1000_IMS] = 0; // redisable interrupts
    800057e0:	0c04a823          	sw	zero,208(s1)
    __sync_synchronize();
    800057e4:	0ff0000f          	fence

    // [E1000 14.5] Transmit initialization
    memset(tx_ring, 0, sizeof(tx_ring));
    800057e8:	10000613          	li	a2,256
    800057ec:	4581                	li	a1,0
    800057ee:	00015517          	auipc	a0,0x15
    800057f2:	71250513          	addi	a0,a0,1810 # 8001af00 <tx_ring>
    800057f6:	ffffb097          	auipc	ra,0xffffb
    800057fa:	984080e7          	jalr	-1660(ra) # 8000017a <memset>
    for (i = 0; i < TX_RING_SIZE; i++) {
    800057fe:	00015717          	auipc	a4,0x15
    80005802:	70e70713          	addi	a4,a4,1806 # 8001af0c <tx_ring+0xc>
    80005806:	00015797          	auipc	a5,0x15
    8000580a:	7fa78793          	addi	a5,a5,2042 # 8001b000 <tx_mbufs>
    8000580e:	00016617          	auipc	a2,0x16
    80005812:	87260613          	addi	a2,a2,-1934 # 8001b080 <rx_ring>
        tx_ring[i].status = E1000_TXD_STAT_DD;
    80005816:	4685                	li	a3,1
    80005818:	00d70023          	sb	a3,0(a4)
        tx_mbufs[i] = 0;
    8000581c:	0007b023          	sd	zero,0(a5)
    for (i = 0; i < TX_RING_SIZE; i++) {
    80005820:	0741                	addi	a4,a4,16
    80005822:	07a1                	addi	a5,a5,8
    80005824:	fec79ae3          	bne	a5,a2,80005818 <e1000_init+0x76>
    }
    regs[E1000_TDBAL] = (uint64)tx_ring;
    80005828:	00015717          	auipc	a4,0x15
    8000582c:	6d870713          	addi	a4,a4,1752 # 8001af00 <tx_ring>
    80005830:	00004797          	auipc	a5,0x4
    80005834:	1307b783          	ld	a5,304(a5) # 80009960 <regs>
    80005838:	6691                	lui	a3,0x4
    8000583a:	97b6                	add	a5,a5,a3
    8000583c:	80e7a023          	sw	a4,-2048(a5)
    if (sizeof(tx_ring) % 128 != 0)
        panic("e1000");
    regs[E1000_TDLEN] = sizeof(tx_ring);
    80005840:	10000713          	li	a4,256
    80005844:	80e7a423          	sw	a4,-2040(a5)
    regs[E1000_TDH] = regs[E1000_TDT] = 0;
    80005848:	8007ac23          	sw	zero,-2024(a5)
    8000584c:	8007a823          	sw	zero,-2032(a5)

    // [E1000 14.4] Receive initialization
    memset(rx_ring, 0, sizeof(rx_ring));
    80005850:	00016917          	auipc	s2,0x16
    80005854:	83090913          	addi	s2,s2,-2000 # 8001b080 <rx_ring>
    80005858:	10000613          	li	a2,256
    8000585c:	4581                	li	a1,0
    8000585e:	854a                	mv	a0,s2
    80005860:	ffffb097          	auipc	ra,0xffffb
    80005864:	91a080e7          	jalr	-1766(ra) # 8000017a <memset>
    for (i = 0; i < RX_RING_SIZE; i++) {
    80005868:	00016497          	auipc	s1,0x16
    8000586c:	91848493          	addi	s1,s1,-1768 # 8001b180 <rx_mbufs>
    80005870:	00016997          	auipc	s3,0x16
    80005874:	99098993          	addi	s3,s3,-1648 # 8001b200 <lock>
        rx_mbufs[i] = mbufalloc(0);
    80005878:	4501                	li	a0,0
    8000587a:	00000097          	auipc	ra,0x0
    8000587e:	400080e7          	jalr	1024(ra) # 80005c7a <mbufalloc>
    80005882:	e088                	sd	a0,0(s1)
        if (!rx_mbufs[i])
    80005884:	c945                	beqz	a0,80005934 <e1000_init+0x192>
            panic("e1000");
        rx_ring[i].addr = (uint64)rx_mbufs[i]->head;
    80005886:	651c                	ld	a5,8(a0)
    80005888:	00f93023          	sd	a5,0(s2)
    for (i = 0; i < RX_RING_SIZE; i++) {
    8000588c:	04a1                	addi	s1,s1,8
    8000588e:	0941                	addi	s2,s2,16
    80005890:	ff3494e3          	bne	s1,s3,80005878 <e1000_init+0xd6>
    }
    regs[E1000_RDBAL] = (uint64)rx_ring;
    80005894:	00004697          	auipc	a3,0x4
    80005898:	0cc6b683          	ld	a3,204(a3) # 80009960 <regs>
    8000589c:	00015717          	auipc	a4,0x15
    800058a0:	7e470713          	addi	a4,a4,2020 # 8001b080 <rx_ring>
    800058a4:	678d                	lui	a5,0x3
    800058a6:	97b6                	add	a5,a5,a3
    800058a8:	80e7a023          	sw	a4,-2048(a5) # 2800 <_entry-0x7fffd800>
    if (sizeof(rx_ring) % 128 != 0)
        panic("e1000");
    regs[E1000_RDH] = 0;
    800058ac:	8007a823          	sw	zero,-2032(a5)
    regs[E1000_RDT] = RX_RING_SIZE - 1;
    800058b0:	473d                	li	a4,15
    800058b2:	80e7ac23          	sw	a4,-2024(a5)
    regs[E1000_RDLEN] = sizeof(rx_ring);
    800058b6:	10000713          	li	a4,256
    800058ba:	80e7a423          	sw	a4,-2040(a5)

    // filter by qemu's MAC address, 52:54:00:12:34:56
    regs[E1000_RA] = 0x12005452;
    800058be:	6715                	lui	a4,0x5
    800058c0:	00e68633          	add	a2,a3,a4
    800058c4:	120057b7          	lui	a5,0x12005
    800058c8:	45278793          	addi	a5,a5,1106 # 12005452 <_entry-0x6dffabae>
    800058cc:	40f62023          	sw	a5,1024(a2)
    regs[E1000_RA + 1] = 0x5634 | (1 << 31);
    800058d0:	800057b7          	lui	a5,0x80005
    800058d4:	63478793          	addi	a5,a5,1588 # ffffffff80005634 <end+0xfffffffefffe21d4>
    800058d8:	40f62223          	sw	a5,1028(a2)
    // multicast table
    for (int i = 0; i < 4096 / 32; i++)
    800058dc:	20070793          	addi	a5,a4,512 # 5200 <_entry-0x7fffae00>
    800058e0:	97b6                	add	a5,a5,a3
    800058e2:	40070713          	addi	a4,a4,1024
    800058e6:	9736                	add	a4,a4,a3
        regs[E1000_MTA + i] = 0;
    800058e8:	0007a023          	sw	zero,0(a5)
    for (int i = 0; i < 4096 / 32; i++)
    800058ec:	0791                	addi	a5,a5,4
    800058ee:	fee79de3          	bne	a5,a4,800058e8 <e1000_init+0x146>

    // transmitter control bits.
    regs[E1000_TCTL] = E1000_TCTL_EN |                 // enable
    800058f2:	000407b7          	lui	a5,0x40
    800058f6:	10a78793          	addi	a5,a5,266 # 4010a <_entry-0x7ffbfef6>
    800058fa:	40f6a023          	sw	a5,1024(a3)
                       E1000_TCTL_PSP |                // pad short packets
                       (0x10 << E1000_TCTL_CT_SHIFT) | // collision stuff
                       (0x40 << E1000_TCTL_COLD_SHIFT);
    regs[E1000_TIPG] = 10 | (8 << 10) | (6 << 20); // inter-pkt gap
    800058fe:	006027b7          	lui	a5,0x602
    80005902:	07a9                	addi	a5,a5,10 # 60200a <_entry-0x7f9fdff6>
    80005904:	40f6a823          	sw	a5,1040(a3)

    // receiver control bits.
    regs[E1000_RCTL] = E1000_RCTL_EN |      // enable receiver
    80005908:	040087b7          	lui	a5,0x4008
    8000590c:	0789                	addi	a5,a5,2 # 4008002 <_entry-0x7bff7ffe>
    8000590e:	10f6a023          	sw	a5,256(a3)
                       E1000_RCTL_BAM |     // enable broadcast
                       E1000_RCTL_SZ_2048 | // 2048-byte rx buffers
                       E1000_RCTL_SECRC;    // strip CRC

    // ask e1000 for receive interrupts.
    regs[E1000_RDTR] = 0;       // interrupt after every received packet (no timer)
    80005912:	678d                	lui	a5,0x3
    80005914:	97b6                	add	a5,a5,a3
    80005916:	8207a023          	sw	zero,-2016(a5) # 2820 <_entry-0x7fffd7e0>
    regs[E1000_RADV] = 0;       // interrupt after every packet (no timer)
    8000591a:	8207a623          	sw	zero,-2004(a5)
    regs[E1000_IMS] = (1 << 7); // RXDW -- Receiver Descriptor Write Back
    8000591e:	08000793          	li	a5,128
    80005922:	0cf6a823          	sw	a5,208(a3)
}
    80005926:	70a2                	ld	ra,40(sp)
    80005928:	7402                	ld	s0,32(sp)
    8000592a:	64e2                	ld	s1,24(sp)
    8000592c:	6942                	ld	s2,16(sp)
    8000592e:	69a2                	ld	s3,8(sp)
    80005930:	6145                	addi	sp,sp,48
    80005932:	8082                	ret
            panic("e1000");
    80005934:	00004517          	auipc	a0,0x4
    80005938:	edc50513          	addi	a0,a0,-292 # 80009810 <syscalls+0x430>
    8000593c:	00001097          	auipc	ra,0x1
    80005940:	29e080e7          	jalr	670(ra) # 80006bda <panic>

0000000080005944 <e1000_transmit>:

int e1000_transmit(struct mbuf *m)
{
    80005944:	7179                	addi	sp,sp,-48
    80005946:	f406                	sd	ra,40(sp)
    80005948:	f022                	sd	s0,32(sp)
    8000594a:	ec26                	sd	s1,24(sp)
    8000594c:	e84a                	sd	s2,16(sp)
    8000594e:	e44e                	sd	s3,8(sp)
    80005950:	1800                	addi	s0,sp,48
    80005952:	892a                	mv	s2,a0
    // tx_mbufs 发送缓冲区
    // tx_ring 发送环缓冲区
    // E1000_TDT 发送环索引
    // E1000_TXD_STAT_DD 发送环状态位，表示该数据包已经发送完毕

    acquire(&e1000_lock); // 锁
    80005954:	00015997          	auipc	s3,0x15
    80005958:	58c98993          	addi	s3,s3,1420 # 8001aee0 <e1000_lock>
    8000595c:	854e                	mv	a0,s3
    8000595e:	00001097          	auipc	ra,0x1
    80005962:	7b4080e7          	jalr	1972(ra) # 80007112 <acquire>

    int index = regs[E1000_TDT]; // 读取E1000_TDT控制寄存器，获取下一个数据包的TX环索引
    80005966:	00004797          	auipc	a5,0x4
    8000596a:	ffa7b783          	ld	a5,-6(a5) # 80009960 <regs>
    8000596e:	6711                	lui	a4,0x4
    80005970:	97ba                	add	a5,a5,a4
    80005972:	8187a483          	lw	s1,-2024(a5)

    if ((tx_ring[index].status & E1000_TXD_STAT_DD) == 0) { // 仍在发送
    80005976:	00449793          	slli	a5,s1,0x4
    8000597a:	99be                	add	s3,s3,a5
    8000597c:	02c9c783          	lbu	a5,44(s3)
    80005980:	8b85                	andi	a5,a5,1
    80005982:	c3c9                	beqz	a5,80005a04 <e1000_transmit+0xc0>
        release(&e1000_lock);
        return -1;
    }

    if (tx_mbufs[index]) // 释放上一个数据包
    80005984:	00349713          	slli	a4,s1,0x3
    80005988:	00015797          	auipc	a5,0x15
    8000598c:	55878793          	addi	a5,a5,1368 # 8001aee0 <e1000_lock>
    80005990:	97ba                	add	a5,a5,a4
    80005992:	1207b503          	ld	a0,288(a5)
    80005996:	c509                	beqz	a0,800059a0 <e1000_transmit+0x5c>
        mbuffree(tx_mbufs[index]);
    80005998:	00000097          	auipc	ra,0x0
    8000599c:	33a080e7          	jalr	826(ra) # 80005cd2 <mbuffree>

    tx_mbufs[index] = m;
    800059a0:	00015517          	auipc	a0,0x15
    800059a4:	54050513          	addi	a0,a0,1344 # 8001aee0 <e1000_lock>
    800059a8:	00349793          	slli	a5,s1,0x3
    800059ac:	97aa                	add	a5,a5,a0
    800059ae:	1327b023          	sd	s2,288(a5)
    tx_ring[index].length = m->len;
    800059b2:	00449793          	slli	a5,s1,0x4
    800059b6:	97aa                	add	a5,a5,a0
    800059b8:	01092703          	lw	a4,16(s2)
    800059bc:	02e79423          	sh	a4,40(a5)
    tx_ring[index].addr = (uint64)m->head;
    800059c0:	00893703          	ld	a4,8(s2)
    800059c4:	f398                	sd	a4,32(a5)

    // E1000_TXD_CMD_RS表示报告状态位，表示当发送完该数据包时会产生一个中断报告状态
    // E1000_TXD_CMD_EOP表示结束位，表示这是该数据包的最后一个描述符。
    tx_ring[index].cmd = E1000_TXD_CMD_RS | E1000_TXD_CMD_EOP;
    800059c6:	4725                	li	a4,9
    800059c8:	02e785a3          	sb	a4,43(a5)

    // 更新E1000_TDT控制寄存器，指向下一个数据包的发送环索引
    // 因其是一个环状结构，故取模

    regs[E1000_TDT] = (index + 1) % TX_RING_SIZE;
    800059cc:	2485                	addiw	s1,s1,1
    800059ce:	41f4d79b          	sraiw	a5,s1,0x1f
    800059d2:	01c7d79b          	srliw	a5,a5,0x1c
    800059d6:	9cbd                	addw	s1,s1,a5
    800059d8:	88bd                	andi	s1,s1,15
    800059da:	9c9d                	subw	s1,s1,a5
    800059dc:	00004797          	auipc	a5,0x4
    800059e0:	f847b783          	ld	a5,-124(a5) # 80009960 <regs>
    800059e4:	6711                	lui	a4,0x4
    800059e6:	97ba                	add	a5,a5,a4
    800059e8:	8097ac23          	sw	s1,-2024(a5)
    release(&e1000_lock);
    800059ec:	00001097          	auipc	ra,0x1
    800059f0:	7da080e7          	jalr	2010(ra) # 800071c6 <release>
    return 0;
    800059f4:	4501                	li	a0,0
}
    800059f6:	70a2                	ld	ra,40(sp)
    800059f8:	7402                	ld	s0,32(sp)
    800059fa:	64e2                	ld	s1,24(sp)
    800059fc:	6942                	ld	s2,16(sp)
    800059fe:	69a2                	ld	s3,8(sp)
    80005a00:	6145                	addi	sp,sp,48
    80005a02:	8082                	ret
        release(&e1000_lock);
    80005a04:	00015517          	auipc	a0,0x15
    80005a08:	4dc50513          	addi	a0,a0,1244 # 8001aee0 <e1000_lock>
    80005a0c:	00001097          	auipc	ra,0x1
    80005a10:	7ba080e7          	jalr	1978(ra) # 800071c6 <release>
        return -1;
    80005a14:	557d                	li	a0,-1
    80005a16:	b7c5                	j	800059f6 <e1000_transmit+0xb2>

0000000080005a18 <e1000_intr>:
        regs[E1000_RDT] = index;
    }
}

void e1000_intr(void)
{
    80005a18:	7139                	addi	sp,sp,-64
    80005a1a:	fc06                	sd	ra,56(sp)
    80005a1c:	f822                	sd	s0,48(sp)
    80005a1e:	f426                	sd	s1,40(sp)
    80005a20:	f04a                	sd	s2,32(sp)
    80005a22:	ec4e                	sd	s3,24(sp)
    80005a24:	e852                	sd	s4,16(sp)
    80005a26:	e456                	sd	s5,8(sp)
    80005a28:	e05a                	sd	s6,0(sp)
    80005a2a:	0080                	addi	s0,sp,64
    // tell the e1000 we've seen this interrupt;
    // without this the e1000 won't raise any
    // further interrupts.
    regs[E1000_ICR] = 0xffffffff;
    80005a2c:	00004797          	auipc	a5,0x4
    80005a30:	f347b783          	ld	a5,-204(a5) # 80009960 <regs>
    80005a34:	577d                	li	a4,-1
    80005a36:	0ce7a023          	sw	a4,192(a5)
        int index = (regs[E1000_RDT] + 1) % RX_RING_SIZE;
    80005a3a:	670d                	lui	a4,0x3
    80005a3c:	97ba                	add	a5,a5,a4
    80005a3e:	8187a483          	lw	s1,-2024(a5)
    80005a42:	2485                	addiw	s1,s1,1
    80005a44:	88bd                	andi	s1,s1,15
        if ((rx_ring[index].status & E1000_RXD_STAT_DD) == 0) {
    80005a46:	00449713          	slli	a4,s1,0x4
    80005a4a:	00015797          	auipc	a5,0x15
    80005a4e:	49678793          	addi	a5,a5,1174 # 8001aee0 <e1000_lock>
    80005a52:	97ba                	add	a5,a5,a4
    80005a54:	1ac7c783          	lbu	a5,428(a5)
    80005a58:	8b85                	andi	a5,a5,1
    80005a5a:	cba5                	beqz	a5,80005aca <e1000_intr+0xb2>
        rx_mbufs[index]->len = rx_ring[index].length;
    80005a5c:	00015a17          	auipc	s4,0x15
    80005a60:	484a0a13          	addi	s4,s4,1156 # 8001aee0 <e1000_lock>
        regs[E1000_RDT] = index;
    80005a64:	00004b17          	auipc	s6,0x4
    80005a68:	efcb0b13          	addi	s6,s6,-260 # 80009960 <regs>
    80005a6c:	6a8d                	lui	s5,0x3
        rx_mbufs[index]->len = rx_ring[index].length;
    80005a6e:	00349993          	slli	s3,s1,0x3
    80005a72:	99d2                	add	s3,s3,s4
    80005a74:	2a09b783          	ld	a5,672(s3)
    80005a78:	00449913          	slli	s2,s1,0x4
    80005a7c:	9952                	add	s2,s2,s4
    80005a7e:	1a895703          	lhu	a4,424(s2)
    80005a82:	cb98                	sw	a4,16(a5)
        net_rx(rx_mbufs[index]);
    80005a84:	2a09b503          	ld	a0,672(s3)
    80005a88:	00000097          	auipc	ra,0x0
    80005a8c:	3c4080e7          	jalr	964(ra) # 80005e4c <net_rx>
        rx_mbufs[index] = mbufalloc(0);
    80005a90:	4501                	li	a0,0
    80005a92:	00000097          	auipc	ra,0x0
    80005a96:	1e8080e7          	jalr	488(ra) # 80005c7a <mbufalloc>
    80005a9a:	2aa9b023          	sd	a0,672(s3)
        rx_ring[index].status = 0;
    80005a9e:	1a090623          	sb	zero,428(s2)
        rx_ring[index].addr = (uint64)rx_mbufs[index]->head;
    80005aa2:	651c                	ld	a5,8(a0)
    80005aa4:	1af93023          	sd	a5,416(s2)
        regs[E1000_RDT] = index;
    80005aa8:	000b3783          	ld	a5,0(s6)
    80005aac:	2481                	sext.w	s1,s1
    80005aae:	97d6                	add	a5,a5,s5
    80005ab0:	8097ac23          	sw	s1,-2024(a5)
        int index = (regs[E1000_RDT] + 1) % RX_RING_SIZE;
    80005ab4:	8187a483          	lw	s1,-2024(a5)
    80005ab8:	2485                	addiw	s1,s1,1
    80005aba:	88bd                	andi	s1,s1,15
        if ((rx_ring[index].status & E1000_RXD_STAT_DD) == 0) {
    80005abc:	00449793          	slli	a5,s1,0x4
    80005ac0:	97d2                	add	a5,a5,s4
    80005ac2:	1ac7c783          	lbu	a5,428(a5)
    80005ac6:	8b85                	andi	a5,a5,1
    80005ac8:	f3dd                	bnez	a5,80005a6e <e1000_intr+0x56>

    e1000_recv();
}
    80005aca:	70e2                	ld	ra,56(sp)
    80005acc:	7442                	ld	s0,48(sp)
    80005ace:	74a2                	ld	s1,40(sp)
    80005ad0:	7902                	ld	s2,32(sp)
    80005ad2:	69e2                	ld	s3,24(sp)
    80005ad4:	6a42                	ld	s4,16(sp)
    80005ad6:	6aa2                	ld	s5,8(sp)
    80005ad8:	6b02                	ld	s6,0(sp)
    80005ada:	6121                	addi	sp,sp,64
    80005adc:	8082                	ret

0000000080005ade <in_cksum>:

// This code is lifted from FreeBSD's ping.c, and is copyright by the Regents
// of the University of California.
static unsigned short
in_cksum(const unsigned char *addr, int len)
{
    80005ade:	1141                	addi	sp,sp,-16
    80005ae0:	e422                	sd	s0,8(sp)
    80005ae2:	0800                	addi	s0,sp,16
  /*
   * Our algorithm is simple, using a 32 bit accumulator (sum), we add
   * sequential 16 bit words to it, and at the end, fold back all the
   * carry bits from the top 16 bits into the lower 16 bits.
   */
  while (nleft > 1)  {
    80005ae4:	4785                	li	a5,1
    80005ae6:	04b7db63          	bge	a5,a1,80005b3c <in_cksum+0x5e>
    80005aea:	ffe5861b          	addiw	a2,a1,-2
    80005aee:	0016561b          	srliw	a2,a2,0x1
    80005af2:	0016069b          	addiw	a3,a2,1
    80005af6:	02069793          	slli	a5,a3,0x20
    80005afa:	01f7d693          	srli	a3,a5,0x1f
    80005afe:	96aa                	add	a3,a3,a0
  unsigned int sum = 0;
    80005b00:	4781                	li	a5,0
    sum += *w++;
    80005b02:	0509                	addi	a0,a0,2
    80005b04:	ffe55703          	lhu	a4,-2(a0)
    80005b08:	9fb9                	addw	a5,a5,a4
  while (nleft > 1)  {
    80005b0a:	fed51ce3          	bne	a0,a3,80005b02 <in_cksum+0x24>
    nleft -= 2;
    80005b0e:	35f9                	addiw	a1,a1,-2
    80005b10:	0016161b          	slliw	a2,a2,0x1
    80005b14:	9d91                	subw	a1,a1,a2
  }

  /* mop up an odd byte, if necessary */
  if (nleft == 1) {
    80005b16:	4705                	li	a4,1
    80005b18:	02e58563          	beq	a1,a4,80005b42 <in_cksum+0x64>
    *(unsigned char *)(&answer) = *(const unsigned char *)w;
    sum += answer;
  }

  /* add back carry outs from top 16 bits to low 16 bits */
  sum = (sum & 0xffff) + (sum >> 16);
    80005b1c:	03079713          	slli	a4,a5,0x30
    80005b20:	9341                	srli	a4,a4,0x30
    80005b22:	0107d79b          	srliw	a5,a5,0x10
    80005b26:	9fb9                	addw	a5,a5,a4
  sum += (sum >> 16);
    80005b28:	0107d51b          	srliw	a0,a5,0x10
    80005b2c:	9d3d                	addw	a0,a0,a5
  /* guaranteed now that the lower 16 bits of sum are correct */

  answer = ~sum; /* truncate to 16 bits */
    80005b2e:	fff54513          	not	a0,a0
  return answer;
}
    80005b32:	1542                	slli	a0,a0,0x30
    80005b34:	9141                	srli	a0,a0,0x30
    80005b36:	6422                	ld	s0,8(sp)
    80005b38:	0141                	addi	sp,sp,16
    80005b3a:	8082                	ret
  const unsigned short *w = (const unsigned short *)addr;
    80005b3c:	86aa                	mv	a3,a0
  unsigned int sum = 0;
    80005b3e:	4781                	li	a5,0
    80005b40:	bfd9                	j	80005b16 <in_cksum+0x38>
    *(unsigned char *)(&answer) = *(const unsigned char *)w;
    80005b42:	0006c703          	lbu	a4,0(a3)
    sum += answer;
    80005b46:	9fb9                	addw	a5,a5,a4
    80005b48:	bfd1                	j	80005b1c <in_cksum+0x3e>

0000000080005b4a <mbufpull>:
{
    80005b4a:	1141                	addi	sp,sp,-16
    80005b4c:	e422                	sd	s0,8(sp)
    80005b4e:	0800                	addi	s0,sp,16
    80005b50:	87aa                	mv	a5,a0
  char *tmp = m->head;
    80005b52:	6508                	ld	a0,8(a0)
  if (m->len < len)
    80005b54:	4b98                	lw	a4,16(a5)
    80005b56:	00b76b63          	bltu	a4,a1,80005b6c <mbufpull+0x22>
  m->len -= len;
    80005b5a:	9f0d                	subw	a4,a4,a1
    80005b5c:	cb98                	sw	a4,16(a5)
  m->head += len;
    80005b5e:	1582                	slli	a1,a1,0x20
    80005b60:	9181                	srli	a1,a1,0x20
    80005b62:	95aa                	add	a1,a1,a0
    80005b64:	e78c                	sd	a1,8(a5)
}
    80005b66:	6422                	ld	s0,8(sp)
    80005b68:	0141                	addi	sp,sp,16
    80005b6a:	8082                	ret
    return 0;
    80005b6c:	4501                	li	a0,0
    80005b6e:	bfe5                	j	80005b66 <mbufpull+0x1c>

0000000080005b70 <mbufpush>:
{
    80005b70:	87aa                	mv	a5,a0
  m->head -= len;
    80005b72:	02059713          	slli	a4,a1,0x20
    80005b76:	9301                	srli	a4,a4,0x20
    80005b78:	6508                	ld	a0,8(a0)
    80005b7a:	8d19                	sub	a0,a0,a4
    80005b7c:	e788                	sd	a0,8(a5)
  if (m->head < m->buf)
    80005b7e:	01478713          	addi	a4,a5,20
    80005b82:	00e56663          	bltu	a0,a4,80005b8e <mbufpush+0x1e>
  m->len += len;
    80005b86:	4b98                	lw	a4,16(a5)
    80005b88:	9f2d                	addw	a4,a4,a1
    80005b8a:	cb98                	sw	a4,16(a5)
}
    80005b8c:	8082                	ret
{
    80005b8e:	1141                	addi	sp,sp,-16
    80005b90:	e406                	sd	ra,8(sp)
    80005b92:	e022                	sd	s0,0(sp)
    80005b94:	0800                	addi	s0,sp,16
    panic("mbufpush");
    80005b96:	00004517          	auipc	a0,0x4
    80005b9a:	c8250513          	addi	a0,a0,-894 # 80009818 <syscalls+0x438>
    80005b9e:	00001097          	auipc	ra,0x1
    80005ba2:	03c080e7          	jalr	60(ra) # 80006bda <panic>

0000000080005ba6 <net_tx_eth>:

// sends an ethernet packet
static void
net_tx_eth(struct mbuf *m, uint16 ethtype)
{
    80005ba6:	7179                	addi	sp,sp,-48
    80005ba8:	f406                	sd	ra,40(sp)
    80005baa:	f022                	sd	s0,32(sp)
    80005bac:	ec26                	sd	s1,24(sp)
    80005bae:	e84a                	sd	s2,16(sp)
    80005bb0:	e44e                	sd	s3,8(sp)
    80005bb2:	1800                	addi	s0,sp,48
    80005bb4:	89aa                	mv	s3,a0
    80005bb6:	892e                	mv	s2,a1
  struct eth *ethhdr;

  ethhdr = mbufpushhdr(m, *ethhdr);
    80005bb8:	45b9                	li	a1,14
    80005bba:	00000097          	auipc	ra,0x0
    80005bbe:	fb6080e7          	jalr	-74(ra) # 80005b70 <mbufpush>
    80005bc2:	84aa                	mv	s1,a0
  memmove(ethhdr->shost, local_mac, ETHADDR_LEN);
    80005bc4:	4619                	li	a2,6
    80005bc6:	00004597          	auipc	a1,0x4
    80005bca:	d0a58593          	addi	a1,a1,-758 # 800098d0 <local_mac>
    80005bce:	0519                	addi	a0,a0,6
    80005bd0:	ffffa097          	auipc	ra,0xffffa
    80005bd4:	606080e7          	jalr	1542(ra) # 800001d6 <memmove>
  // In a real networking stack, dhost would be set to the address discovered
  // through ARP. Because we don't support enough of the ARP protocol, set it
  // to broadcast instead.
  memmove(ethhdr->dhost, broadcast_mac, ETHADDR_LEN);
    80005bd8:	4619                	li	a2,6
    80005bda:	00004597          	auipc	a1,0x4
    80005bde:	cee58593          	addi	a1,a1,-786 # 800098c8 <broadcast_mac>
    80005be2:	8526                	mv	a0,s1
    80005be4:	ffffa097          	auipc	ra,0xffffa
    80005be8:	5f2080e7          	jalr	1522(ra) # 800001d6 <memmove>
// endianness support
//

static inline uint16 bswaps(uint16 val)
{
  return (((val & 0x00ffU) << 8) |
    80005bec:	0089579b          	srliw	a5,s2,0x8
  ethhdr->type = htons(ethtype);
    80005bf0:	00f48623          	sb	a5,12(s1)
    80005bf4:	012486a3          	sb	s2,13(s1)
  if (e1000_transmit(m)) {
    80005bf8:	854e                	mv	a0,s3
    80005bfa:	00000097          	auipc	ra,0x0
    80005bfe:	d4a080e7          	jalr	-694(ra) # 80005944 <e1000_transmit>
    80005c02:	e901                	bnez	a0,80005c12 <net_tx_eth+0x6c>
    mbuffree(m);
  }
}
    80005c04:	70a2                	ld	ra,40(sp)
    80005c06:	7402                	ld	s0,32(sp)
    80005c08:	64e2                	ld	s1,24(sp)
    80005c0a:	6942                	ld	s2,16(sp)
    80005c0c:	69a2                	ld	s3,8(sp)
    80005c0e:	6145                	addi	sp,sp,48
    80005c10:	8082                	ret
  kfree(m);
    80005c12:	854e                	mv	a0,s3
    80005c14:	ffffa097          	auipc	ra,0xffffa
    80005c18:	408080e7          	jalr	1032(ra) # 8000001c <kfree>
}
    80005c1c:	b7e5                	j	80005c04 <net_tx_eth+0x5e>

0000000080005c1e <mbufput>:
{
    80005c1e:	87aa                	mv	a5,a0
  char *tmp = m->head + m->len;
    80005c20:	4918                	lw	a4,16(a0)
    80005c22:	02071693          	slli	a3,a4,0x20
    80005c26:	9281                	srli	a3,a3,0x20
    80005c28:	6508                	ld	a0,8(a0)
    80005c2a:	9536                	add	a0,a0,a3
  m->len += len;
    80005c2c:	9f2d                	addw	a4,a4,a1
    80005c2e:	0007069b          	sext.w	a3,a4
    80005c32:	cb98                	sw	a4,16(a5)
  if (m->len > MBUF_SIZE)
    80005c34:	6785                	lui	a5,0x1
    80005c36:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x7ffff800>
    80005c3a:	00d7e363          	bltu	a5,a3,80005c40 <mbufput+0x22>
}
    80005c3e:	8082                	ret
{
    80005c40:	1141                	addi	sp,sp,-16
    80005c42:	e406                	sd	ra,8(sp)
    80005c44:	e022                	sd	s0,0(sp)
    80005c46:	0800                	addi	s0,sp,16
    panic("mbufput");
    80005c48:	00004517          	auipc	a0,0x4
    80005c4c:	be050513          	addi	a0,a0,-1056 # 80009828 <syscalls+0x448>
    80005c50:	00001097          	auipc	ra,0x1
    80005c54:	f8a080e7          	jalr	-118(ra) # 80006bda <panic>

0000000080005c58 <mbuftrim>:
{
    80005c58:	1141                	addi	sp,sp,-16
    80005c5a:	e422                	sd	s0,8(sp)
    80005c5c:	0800                	addi	s0,sp,16
  if (len > m->len)
    80005c5e:	491c                	lw	a5,16(a0)
    80005c60:	00b7eb63          	bltu	a5,a1,80005c76 <mbuftrim+0x1e>
  m->len -= len;
    80005c64:	9f8d                	subw	a5,a5,a1
    80005c66:	c91c                	sw	a5,16(a0)
  return m->head + m->len;
    80005c68:	1782                	slli	a5,a5,0x20
    80005c6a:	9381                	srli	a5,a5,0x20
    80005c6c:	6508                	ld	a0,8(a0)
    80005c6e:	953e                	add	a0,a0,a5
}
    80005c70:	6422                	ld	s0,8(sp)
    80005c72:	0141                	addi	sp,sp,16
    80005c74:	8082                	ret
    return 0;
    80005c76:	4501                	li	a0,0
    80005c78:	bfe5                	j	80005c70 <mbuftrim+0x18>

0000000080005c7a <mbufalloc>:
{
    80005c7a:	1101                	addi	sp,sp,-32
    80005c7c:	ec06                	sd	ra,24(sp)
    80005c7e:	e822                	sd	s0,16(sp)
    80005c80:	e426                	sd	s1,8(sp)
    80005c82:	e04a                	sd	s2,0(sp)
    80005c84:	1000                	addi	s0,sp,32
  if (headroom > MBUF_SIZE)
    80005c86:	6785                	lui	a5,0x1
    80005c88:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x7ffff800>
    return 0;
    80005c8c:	4901                	li	s2,0
  if (headroom > MBUF_SIZE)
    80005c8e:	02a7eb63          	bltu	a5,a0,80005cc4 <mbufalloc+0x4a>
    80005c92:	84aa                	mv	s1,a0
  m = kalloc();
    80005c94:	ffffa097          	auipc	ra,0xffffa
    80005c98:	486080e7          	jalr	1158(ra) # 8000011a <kalloc>
    80005c9c:	892a                	mv	s2,a0
  if (m == 0)
    80005c9e:	c11d                	beqz	a0,80005cc4 <mbufalloc+0x4a>
  m->next = 0;
    80005ca0:	00053023          	sd	zero,0(a0)
  m->head = (char *)m->buf + headroom;
    80005ca4:	0551                	addi	a0,a0,20
    80005ca6:	1482                	slli	s1,s1,0x20
    80005ca8:	9081                	srli	s1,s1,0x20
    80005caa:	94aa                	add	s1,s1,a0
    80005cac:	00993423          	sd	s1,8(s2)
  m->len = 0;
    80005cb0:	00092823          	sw	zero,16(s2)
  memset(m->buf, 0, sizeof(m->buf));
    80005cb4:	6605                	lui	a2,0x1
    80005cb6:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    80005cba:	4581                	li	a1,0
    80005cbc:	ffffa097          	auipc	ra,0xffffa
    80005cc0:	4be080e7          	jalr	1214(ra) # 8000017a <memset>
}
    80005cc4:	854a                	mv	a0,s2
    80005cc6:	60e2                	ld	ra,24(sp)
    80005cc8:	6442                	ld	s0,16(sp)
    80005cca:	64a2                	ld	s1,8(sp)
    80005ccc:	6902                	ld	s2,0(sp)
    80005cce:	6105                	addi	sp,sp,32
    80005cd0:	8082                	ret

0000000080005cd2 <mbuffree>:
{
    80005cd2:	1141                	addi	sp,sp,-16
    80005cd4:	e406                	sd	ra,8(sp)
    80005cd6:	e022                	sd	s0,0(sp)
    80005cd8:	0800                	addi	s0,sp,16
  kfree(m);
    80005cda:	ffffa097          	auipc	ra,0xffffa
    80005cde:	342080e7          	jalr	834(ra) # 8000001c <kfree>
}
    80005ce2:	60a2                	ld	ra,8(sp)
    80005ce4:	6402                	ld	s0,0(sp)
    80005ce6:	0141                	addi	sp,sp,16
    80005ce8:	8082                	ret

0000000080005cea <mbufq_pushtail>:
{
    80005cea:	1141                	addi	sp,sp,-16
    80005cec:	e422                	sd	s0,8(sp)
    80005cee:	0800                	addi	s0,sp,16
  m->next = 0;
    80005cf0:	0005b023          	sd	zero,0(a1)
  if (!q->head){
    80005cf4:	611c                	ld	a5,0(a0)
    80005cf6:	c799                	beqz	a5,80005d04 <mbufq_pushtail+0x1a>
  q->tail->next = m;
    80005cf8:	651c                	ld	a5,8(a0)
    80005cfa:	e38c                	sd	a1,0(a5)
  q->tail = m;
    80005cfc:	e50c                	sd	a1,8(a0)
}
    80005cfe:	6422                	ld	s0,8(sp)
    80005d00:	0141                	addi	sp,sp,16
    80005d02:	8082                	ret
    q->head = q->tail = m;
    80005d04:	e50c                	sd	a1,8(a0)
    80005d06:	e10c                	sd	a1,0(a0)
    return;
    80005d08:	bfdd                	j	80005cfe <mbufq_pushtail+0x14>

0000000080005d0a <mbufq_pophead>:
{
    80005d0a:	1141                	addi	sp,sp,-16
    80005d0c:	e422                	sd	s0,8(sp)
    80005d0e:	0800                	addi	s0,sp,16
    80005d10:	87aa                	mv	a5,a0
  struct mbuf *head = q->head;
    80005d12:	6108                	ld	a0,0(a0)
  if (!head)
    80005d14:	c119                	beqz	a0,80005d1a <mbufq_pophead+0x10>
  q->head = head->next;
    80005d16:	6118                	ld	a4,0(a0)
    80005d18:	e398                	sd	a4,0(a5)
}
    80005d1a:	6422                	ld	s0,8(sp)
    80005d1c:	0141                	addi	sp,sp,16
    80005d1e:	8082                	ret

0000000080005d20 <mbufq_empty>:
{
    80005d20:	1141                	addi	sp,sp,-16
    80005d22:	e422                	sd	s0,8(sp)
    80005d24:	0800                	addi	s0,sp,16
  return q->head == 0;
    80005d26:	6108                	ld	a0,0(a0)
}
    80005d28:	00153513          	seqz	a0,a0
    80005d2c:	6422                	ld	s0,8(sp)
    80005d2e:	0141                	addi	sp,sp,16
    80005d30:	8082                	ret

0000000080005d32 <mbufq_init>:
{
    80005d32:	1141                	addi	sp,sp,-16
    80005d34:	e422                	sd	s0,8(sp)
    80005d36:	0800                	addi	s0,sp,16
  q->head = 0;
    80005d38:	00053023          	sd	zero,0(a0)
}
    80005d3c:	6422                	ld	s0,8(sp)
    80005d3e:	0141                	addi	sp,sp,16
    80005d40:	8082                	ret

0000000080005d42 <net_tx_udp>:

// sends a UDP packet
void
net_tx_udp(struct mbuf *m, uint32 dip,
           uint16 sport, uint16 dport)
{
    80005d42:	7179                	addi	sp,sp,-48
    80005d44:	f406                	sd	ra,40(sp)
    80005d46:	f022                	sd	s0,32(sp)
    80005d48:	ec26                	sd	s1,24(sp)
    80005d4a:	e84a                	sd	s2,16(sp)
    80005d4c:	e44e                	sd	s3,8(sp)
    80005d4e:	e052                	sd	s4,0(sp)
    80005d50:	1800                	addi	s0,sp,48
    80005d52:	89aa                	mv	s3,a0
    80005d54:	892e                	mv	s2,a1
    80005d56:	8a32                	mv	s4,a2
    80005d58:	84b6                	mv	s1,a3
  struct udp *udphdr;

  // put the UDP header
  udphdr = mbufpushhdr(m, *udphdr);
    80005d5a:	45a1                	li	a1,8
    80005d5c:	00000097          	auipc	ra,0x0
    80005d60:	e14080e7          	jalr	-492(ra) # 80005b70 <mbufpush>
    80005d64:	008a179b          	slliw	a5,s4,0x8
    80005d68:	008a5a1b          	srliw	s4,s4,0x8
    80005d6c:	0147e7b3          	or	a5,a5,s4
  udphdr->sport = htons(sport);
    80005d70:	00f51023          	sh	a5,0(a0)
    80005d74:	0084979b          	slliw	a5,s1,0x8
    80005d78:	0084d49b          	srliw	s1,s1,0x8
    80005d7c:	8fc5                	or	a5,a5,s1
  udphdr->dport = htons(dport);
    80005d7e:	00f51123          	sh	a5,2(a0)
  udphdr->ulen = htons(m->len);
    80005d82:	0109a783          	lw	a5,16(s3)
    80005d86:	0087971b          	slliw	a4,a5,0x8
    80005d8a:	0107979b          	slliw	a5,a5,0x10
    80005d8e:	0107d79b          	srliw	a5,a5,0x10
    80005d92:	0087d79b          	srliw	a5,a5,0x8
    80005d96:	8fd9                	or	a5,a5,a4
    80005d98:	00f51223          	sh	a5,4(a0)
  udphdr->sum = 0; // zero means no checksum is provided
    80005d9c:	00051323          	sh	zero,6(a0)
  iphdr = mbufpushhdr(m, *iphdr);
    80005da0:	45d1                	li	a1,20
    80005da2:	854e                	mv	a0,s3
    80005da4:	00000097          	auipc	ra,0x0
    80005da8:	dcc080e7          	jalr	-564(ra) # 80005b70 <mbufpush>
    80005dac:	84aa                	mv	s1,a0
  memset(iphdr, 0, sizeof(*iphdr));
    80005dae:	4651                	li	a2,20
    80005db0:	4581                	li	a1,0
    80005db2:	ffffa097          	auipc	ra,0xffffa
    80005db6:	3c8080e7          	jalr	968(ra) # 8000017a <memset>
  iphdr->ip_vhl = (4 << 4) | (20 >> 2);
    80005dba:	04500793          	li	a5,69
    80005dbe:	00f48023          	sb	a5,0(s1)
  iphdr->ip_p = proto;
    80005dc2:	47c5                	li	a5,17
    80005dc4:	00f484a3          	sb	a5,9(s1)
  iphdr->ip_src = htonl(local_ip);
    80005dc8:	0f0207b7          	lui	a5,0xf020
    80005dcc:	07a9                	addi	a5,a5,10 # f02000a <_entry-0x70fdfff6>
    80005dce:	c4dc                	sw	a5,12(s1)
          ((val & 0xff00U) >> 8));
}

static inline uint32 bswapl(uint32 val)
{
  return (((val & 0x000000ffUL) << 24) |
    80005dd0:	0189179b          	slliw	a5,s2,0x18
          ((val & 0x0000ff00UL) << 8) |
          ((val & 0x00ff0000UL) >> 8) |
          ((val & 0xff000000UL) >> 24));
    80005dd4:	0189571b          	srliw	a4,s2,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005dd8:	8fd9                	or	a5,a5,a4
          ((val & 0x0000ff00UL) << 8) |
    80005dda:	0089171b          	slliw	a4,s2,0x8
    80005dde:	00ff06b7          	lui	a3,0xff0
    80005de2:	8f75                	and	a4,a4,a3
          ((val & 0x00ff0000UL) >> 8) |
    80005de4:	8fd9                	or	a5,a5,a4
    80005de6:	0089591b          	srliw	s2,s2,0x8
    80005dea:	6741                	lui	a4,0x10
    80005dec:	f0070713          	addi	a4,a4,-256 # ff00 <_entry-0x7fff0100>
    80005df0:	00e97933          	and	s2,s2,a4
    80005df4:	0127e7b3          	or	a5,a5,s2
  iphdr->ip_dst = htonl(dip);
    80005df8:	c89c                	sw	a5,16(s1)
  iphdr->ip_len = htons(m->len);
    80005dfa:	0109a783          	lw	a5,16(s3)
  return (((val & 0x00ffU) << 8) |
    80005dfe:	0087971b          	slliw	a4,a5,0x8
    80005e02:	0107979b          	slliw	a5,a5,0x10
    80005e06:	0107d79b          	srliw	a5,a5,0x10
    80005e0a:	0087d79b          	srliw	a5,a5,0x8
    80005e0e:	8fd9                	or	a5,a5,a4
    80005e10:	00f49123          	sh	a5,2(s1)
  iphdr->ip_ttl = 100;
    80005e14:	06400793          	li	a5,100
    80005e18:	00f48423          	sb	a5,8(s1)
  iphdr->ip_sum = in_cksum((unsigned char *)iphdr, sizeof(*iphdr));
    80005e1c:	45d1                	li	a1,20
    80005e1e:	8526                	mv	a0,s1
    80005e20:	00000097          	auipc	ra,0x0
    80005e24:	cbe080e7          	jalr	-834(ra) # 80005ade <in_cksum>
    80005e28:	00a49523          	sh	a0,10(s1)
  net_tx_eth(m, ETHTYPE_IP);
    80005e2c:	6585                	lui	a1,0x1
    80005e2e:	80058593          	addi	a1,a1,-2048 # 800 <_entry-0x7ffff800>
    80005e32:	854e                	mv	a0,s3
    80005e34:	00000097          	auipc	ra,0x0
    80005e38:	d72080e7          	jalr	-654(ra) # 80005ba6 <net_tx_eth>

  // now on to the IP layer
  net_tx_ip(m, IPPROTO_UDP, dip);
}
    80005e3c:	70a2                	ld	ra,40(sp)
    80005e3e:	7402                	ld	s0,32(sp)
    80005e40:	64e2                	ld	s1,24(sp)
    80005e42:	6942                	ld	s2,16(sp)
    80005e44:	69a2                	ld	s3,8(sp)
    80005e46:	6a02                	ld	s4,0(sp)
    80005e48:	6145                	addi	sp,sp,48
    80005e4a:	8082                	ret

0000000080005e4c <net_rx>:
}

// called by e1000 driver's interrupt handler to deliver a packet to the
// networking stack
void net_rx(struct mbuf *m)
{
    80005e4c:	715d                	addi	sp,sp,-80
    80005e4e:	e486                	sd	ra,72(sp)
    80005e50:	e0a2                	sd	s0,64(sp)
    80005e52:	fc26                	sd	s1,56(sp)
    80005e54:	f84a                	sd	s2,48(sp)
    80005e56:	f44e                	sd	s3,40(sp)
    80005e58:	f052                	sd	s4,32(sp)
    80005e5a:	ec56                	sd	s5,24(sp)
    80005e5c:	0880                	addi	s0,sp,80
    80005e5e:	84aa                	mv	s1,a0
  struct eth *ethhdr;
  uint16 type;

  ethhdr = mbufpullhdr(m, *ethhdr);
    80005e60:	45b9                	li	a1,14
    80005e62:	00000097          	auipc	ra,0x0
    80005e66:	ce8080e7          	jalr	-792(ra) # 80005b4a <mbufpull>
  if (!ethhdr) {
    80005e6a:	c521                	beqz	a0,80005eb2 <net_rx+0x66>
    mbuffree(m);
    return;
  }

  type = ntohs(ethhdr->type);
    80005e6c:	00c54703          	lbu	a4,12(a0)
    80005e70:	00d54783          	lbu	a5,13(a0)
    80005e74:	07a2                	slli	a5,a5,0x8
    80005e76:	8fd9                	or	a5,a5,a4
    80005e78:	0087971b          	slliw	a4,a5,0x8
    80005e7c:	83a1                	srli	a5,a5,0x8
    80005e7e:	8fd9                	or	a5,a5,a4
    80005e80:	17c2                	slli	a5,a5,0x30
    80005e82:	93c1                	srli	a5,a5,0x30
  if (type == ETHTYPE_IP)
    80005e84:	8007871b          	addiw	a4,a5,-2048
    80005e88:	cb1d                	beqz	a4,80005ebe <net_rx+0x72>
    net_rx_ip(m);
  else if (type == ETHTYPE_ARP)
    80005e8a:	2781                	sext.w	a5,a5
    80005e8c:	6705                	lui	a4,0x1
    80005e8e:	80670713          	addi	a4,a4,-2042 # 806 <_entry-0x7ffff7fa>
    80005e92:	16e78e63          	beq	a5,a4,8000600e <net_rx+0x1c2>
  kfree(m);
    80005e96:	8526                	mv	a0,s1
    80005e98:	ffffa097          	auipc	ra,0xffffa
    80005e9c:	184080e7          	jalr	388(ra) # 8000001c <kfree>
    net_rx_arp(m);
  else
    mbuffree(m);
}
    80005ea0:	60a6                	ld	ra,72(sp)
    80005ea2:	6406                	ld	s0,64(sp)
    80005ea4:	74e2                	ld	s1,56(sp)
    80005ea6:	7942                	ld	s2,48(sp)
    80005ea8:	79a2                	ld	s3,40(sp)
    80005eaa:	7a02                	ld	s4,32(sp)
    80005eac:	6ae2                	ld	s5,24(sp)
    80005eae:	6161                	addi	sp,sp,80
    80005eb0:	8082                	ret
  kfree(m);
    80005eb2:	8526                	mv	a0,s1
    80005eb4:	ffffa097          	auipc	ra,0xffffa
    80005eb8:	168080e7          	jalr	360(ra) # 8000001c <kfree>
}
    80005ebc:	b7d5                	j	80005ea0 <net_rx+0x54>
  iphdr = mbufpullhdr(m, *iphdr);
    80005ebe:	45d1                	li	a1,20
    80005ec0:	8526                	mv	a0,s1
    80005ec2:	00000097          	auipc	ra,0x0
    80005ec6:	c88080e7          	jalr	-888(ra) # 80005b4a <mbufpull>
    80005eca:	892a                	mv	s2,a0
  if (!iphdr)
    80005ecc:	c535                	beqz	a0,80005f38 <net_rx+0xec>
  if (iphdr->ip_vhl != ((4 << 4) | (20 >> 2)))
    80005ece:	00054703          	lbu	a4,0(a0)
    80005ed2:	04500793          	li	a5,69
    80005ed6:	06f71163          	bne	a4,a5,80005f38 <net_rx+0xec>
  if (in_cksum((unsigned char *)iphdr, sizeof(*iphdr)))
    80005eda:	45d1                	li	a1,20
    80005edc:	00000097          	auipc	ra,0x0
    80005ee0:	c02080e7          	jalr	-1022(ra) # 80005ade <in_cksum>
    80005ee4:	e931                	bnez	a0,80005f38 <net_rx+0xec>
    80005ee6:	00695783          	lhu	a5,6(s2)
    80005eea:	0087971b          	slliw	a4,a5,0x8
    80005eee:	83a1                	srli	a5,a5,0x8
    80005ef0:	8fd9                	or	a5,a5,a4
  if (htons(iphdr->ip_off) != 0)
    80005ef2:	17c2                	slli	a5,a5,0x30
    80005ef4:	93c1                	srli	a5,a5,0x30
    80005ef6:	e3a9                	bnez	a5,80005f38 <net_rx+0xec>
  if (htonl(iphdr->ip_dst) != local_ip)
    80005ef8:	01092703          	lw	a4,16(s2)
  return (((val & 0x000000ffUL) << 24) |
    80005efc:	0187179b          	slliw	a5,a4,0x18
          ((val & 0xff000000UL) >> 24));
    80005f00:	0187569b          	srliw	a3,a4,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005f04:	8fd5                	or	a5,a5,a3
          ((val & 0x0000ff00UL) << 8) |
    80005f06:	0087169b          	slliw	a3,a4,0x8
    80005f0a:	00ff0637          	lui	a2,0xff0
    80005f0e:	8ef1                	and	a3,a3,a2
          ((val & 0x00ff0000UL) >> 8) |
    80005f10:	8fd5                	or	a5,a5,a3
    80005f12:	0087571b          	srliw	a4,a4,0x8
    80005f16:	66c1                	lui	a3,0x10
    80005f18:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    80005f1c:	8f75                	and	a4,a4,a3
    80005f1e:	8fd9                	or	a5,a5,a4
    80005f20:	2781                	sext.w	a5,a5
    80005f22:	0a000737          	lui	a4,0xa000
    80005f26:	20f70713          	addi	a4,a4,527 # a00020f <_entry-0x75fffdf1>
    80005f2a:	00e79763          	bne	a5,a4,80005f38 <net_rx+0xec>
  if (iphdr->ip_p != IPPROTO_UDP)
    80005f2e:	00994703          	lbu	a4,9(s2)
    80005f32:	47c5                	li	a5,17
    80005f34:	00f70863          	beq	a4,a5,80005f44 <net_rx+0xf8>
  kfree(m);
    80005f38:	8526                	mv	a0,s1
    80005f3a:	ffffa097          	auipc	ra,0xffffa
    80005f3e:	0e2080e7          	jalr	226(ra) # 8000001c <kfree>
}
    80005f42:	bfb9                	j	80005ea0 <net_rx+0x54>
  return (((val & 0x00ffU) << 8) |
    80005f44:	00295783          	lhu	a5,2(s2)
    80005f48:	0087971b          	slliw	a4,a5,0x8
    80005f4c:	83a1                	srli	a5,a5,0x8
    80005f4e:	8fd9                	or	a5,a5,a4
    80005f50:	03079993          	slli	s3,a5,0x30
    80005f54:	0309d993          	srli	s3,s3,0x30
  len = ntohs(iphdr->ip_len) - sizeof(*iphdr);
    80005f58:	fec9879b          	addiw	a5,s3,-20
    80005f5c:	03079a13          	slli	s4,a5,0x30
    80005f60:	030a5a13          	srli	s4,s4,0x30
  udphdr = mbufpullhdr(m, *udphdr);
    80005f64:	45a1                	li	a1,8
    80005f66:	8526                	mv	a0,s1
    80005f68:	00000097          	auipc	ra,0x0
    80005f6c:	be2080e7          	jalr	-1054(ra) # 80005b4a <mbufpull>
    80005f70:	8aaa                	mv	s5,a0
  if (!udphdr)
    80005f72:	c51d                	beqz	a0,80005fa0 <net_rx+0x154>
    80005f74:	00455783          	lhu	a5,4(a0)
    80005f78:	0087971b          	slliw	a4,a5,0x8
    80005f7c:	83a1                	srli	a5,a5,0x8
    80005f7e:	8fd9                	or	a5,a5,a4
  if (ntohs(udphdr->ulen) != len)
    80005f80:	2a01                	sext.w	s4,s4
    80005f82:	17c2                	slli	a5,a5,0x30
    80005f84:	93c1                	srli	a5,a5,0x30
    80005f86:	00fa1d63          	bne	s4,a5,80005fa0 <net_rx+0x154>
  len -= sizeof(*udphdr);
    80005f8a:	fe49879b          	addiw	a5,s3,-28
  if (len > m->len)
    80005f8e:	0107979b          	slliw	a5,a5,0x10
    80005f92:	0107d79b          	srliw	a5,a5,0x10
    80005f96:	0007871b          	sext.w	a4,a5
    80005f9a:	488c                	lw	a1,16(s1)
    80005f9c:	00e5f863          	bgeu	a1,a4,80005fac <net_rx+0x160>
  kfree(m);
    80005fa0:	8526                	mv	a0,s1
    80005fa2:	ffffa097          	auipc	ra,0xffffa
    80005fa6:	07a080e7          	jalr	122(ra) # 8000001c <kfree>
}
    80005faa:	bddd                	j	80005ea0 <net_rx+0x54>
  mbuftrim(m, m->len - len);
    80005fac:	9d9d                	subw	a1,a1,a5
    80005fae:	8526                	mv	a0,s1
    80005fb0:	00000097          	auipc	ra,0x0
    80005fb4:	ca8080e7          	jalr	-856(ra) # 80005c58 <mbuftrim>
  sip = ntohl(iphdr->ip_src);
    80005fb8:	00c92783          	lw	a5,12(s2)
    80005fbc:	000ad703          	lhu	a4,0(s5) # 3000 <_entry-0x7fffd000>
    80005fc0:	0087169b          	slliw	a3,a4,0x8
    80005fc4:	8321                	srli	a4,a4,0x8
    80005fc6:	8ed9                	or	a3,a3,a4
    80005fc8:	002ad703          	lhu	a4,2(s5)
    80005fcc:	0087161b          	slliw	a2,a4,0x8
    80005fd0:	8321                	srli	a4,a4,0x8
    80005fd2:	8e59                	or	a2,a2,a4
  return (((val & 0x000000ffUL) << 24) |
    80005fd4:	0187959b          	slliw	a1,a5,0x18
          ((val & 0xff000000UL) >> 24));
    80005fd8:	0187d71b          	srliw	a4,a5,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005fdc:	8dd9                	or	a1,a1,a4
          ((val & 0x0000ff00UL) << 8) |
    80005fde:	0087971b          	slliw	a4,a5,0x8
    80005fe2:	00ff0537          	lui	a0,0xff0
    80005fe6:	8f69                	and	a4,a4,a0
          ((val & 0x00ff0000UL) >> 8) |
    80005fe8:	8dd9                	or	a1,a1,a4
    80005fea:	0087d79b          	srliw	a5,a5,0x8
    80005fee:	6741                	lui	a4,0x10
    80005ff0:	f0070713          	addi	a4,a4,-256 # ff00 <_entry-0x7fff0100>
    80005ff4:	8ff9                	and	a5,a5,a4
    80005ff6:	8ddd                	or	a1,a1,a5
  sockrecvudp(m, sip, dport, sport);
    80005ff8:	16c2                	slli	a3,a3,0x30
    80005ffa:	92c1                	srli	a3,a3,0x30
    80005ffc:	1642                	slli	a2,a2,0x30
    80005ffe:	9241                	srli	a2,a2,0x30
    80006000:	2581                	sext.w	a1,a1
    80006002:	8526                	mv	a0,s1
    80006004:	00000097          	auipc	ra,0x0
    80006008:	55e080e7          	jalr	1374(ra) # 80006562 <sockrecvudp>
  return;
    8000600c:	bd51                	j	80005ea0 <net_rx+0x54>
  arphdr = mbufpullhdr(m, *arphdr);
    8000600e:	45f1                	li	a1,28
    80006010:	8526                	mv	a0,s1
    80006012:	00000097          	auipc	ra,0x0
    80006016:	b38080e7          	jalr	-1224(ra) # 80005b4a <mbufpull>
    8000601a:	892a                	mv	s2,a0
  if (!arphdr)
    8000601c:	c179                	beqz	a0,800060e2 <net_rx+0x296>
  if (ntohs(arphdr->hrd) != ARP_HRD_ETHER ||
    8000601e:	00054703          	lbu	a4,0(a0) # ff0000 <_entry-0x7f010000>
    80006022:	00154783          	lbu	a5,1(a0)
    80006026:	07a2                	slli	a5,a5,0x8
    80006028:	8fd9                	or	a5,a5,a4
  return (((val & 0x00ffU) << 8) |
    8000602a:	0087971b          	slliw	a4,a5,0x8
    8000602e:	83a1                	srli	a5,a5,0x8
    80006030:	8fd9                	or	a5,a5,a4
    80006032:	17c2                	slli	a5,a5,0x30
    80006034:	93c1                	srli	a5,a5,0x30
    80006036:	4705                	li	a4,1
    80006038:	0ae79563          	bne	a5,a4,800060e2 <net_rx+0x296>
      ntohs(arphdr->pro) != ETHTYPE_IP ||
    8000603c:	00254703          	lbu	a4,2(a0)
    80006040:	00354783          	lbu	a5,3(a0)
    80006044:	07a2                	slli	a5,a5,0x8
    80006046:	8fd9                	or	a5,a5,a4
    80006048:	0087971b          	slliw	a4,a5,0x8
    8000604c:	83a1                	srli	a5,a5,0x8
    8000604e:	8fd9                	or	a5,a5,a4
  if (ntohs(arphdr->hrd) != ARP_HRD_ETHER ||
    80006050:	0107979b          	slliw	a5,a5,0x10
    80006054:	0107d79b          	srliw	a5,a5,0x10
    80006058:	8007879b          	addiw	a5,a5,-2048
    8000605c:	e3d9                	bnez	a5,800060e2 <net_rx+0x296>
      ntohs(arphdr->pro) != ETHTYPE_IP ||
    8000605e:	00454703          	lbu	a4,4(a0)
    80006062:	4799                	li	a5,6
    80006064:	06f71f63          	bne	a4,a5,800060e2 <net_rx+0x296>
      arphdr->hln != ETHADDR_LEN ||
    80006068:	00554703          	lbu	a4,5(a0)
    8000606c:	4791                	li	a5,4
    8000606e:	06f71a63          	bne	a4,a5,800060e2 <net_rx+0x296>
  if (ntohs(arphdr->op) != ARP_OP_REQUEST || tip != local_ip)
    80006072:	00654703          	lbu	a4,6(a0)
    80006076:	00754783          	lbu	a5,7(a0)
    8000607a:	07a2                	slli	a5,a5,0x8
    8000607c:	8fd9                	or	a5,a5,a4
    8000607e:	0087971b          	slliw	a4,a5,0x8
    80006082:	83a1                	srli	a5,a5,0x8
    80006084:	8fd9                	or	a5,a5,a4
    80006086:	17c2                	slli	a5,a5,0x30
    80006088:	93c1                	srli	a5,a5,0x30
    8000608a:	4705                	li	a4,1
    8000608c:	04e79b63          	bne	a5,a4,800060e2 <net_rx+0x296>
  tip = ntohl(arphdr->tip); // target IP address
    80006090:	01854703          	lbu	a4,24(a0)
    80006094:	01954783          	lbu	a5,25(a0)
    80006098:	07a2                	slli	a5,a5,0x8
    8000609a:	8fd9                	or	a5,a5,a4
    8000609c:	01a54703          	lbu	a4,26(a0)
    800060a0:	0742                	slli	a4,a4,0x10
    800060a2:	8f5d                	or	a4,a4,a5
    800060a4:	01b54783          	lbu	a5,27(a0)
    800060a8:	07e2                	slli	a5,a5,0x18
    800060aa:	8fd9                	or	a5,a5,a4
    800060ac:	0007871b          	sext.w	a4,a5
  return (((val & 0x000000ffUL) << 24) |
    800060b0:	0187979b          	slliw	a5,a5,0x18
          ((val & 0xff000000UL) >> 24));
    800060b4:	0187569b          	srliw	a3,a4,0x18
          ((val & 0x00ff0000UL) >> 8) |
    800060b8:	8fd5                	or	a5,a5,a3
          ((val & 0x0000ff00UL) << 8) |
    800060ba:	0087169b          	slliw	a3,a4,0x8
    800060be:	00ff0637          	lui	a2,0xff0
    800060c2:	8ef1                	and	a3,a3,a2
          ((val & 0x00ff0000UL) >> 8) |
    800060c4:	8fd5                	or	a5,a5,a3
    800060c6:	0087571b          	srliw	a4,a4,0x8
    800060ca:	66c1                	lui	a3,0x10
    800060cc:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    800060d0:	8f75                	and	a4,a4,a3
    800060d2:	8fd9                	or	a5,a5,a4
  if (ntohs(arphdr->op) != ARP_OP_REQUEST || tip != local_ip)
    800060d4:	2781                	sext.w	a5,a5
    800060d6:	0a000737          	lui	a4,0xa000
    800060da:	20f70713          	addi	a4,a4,527 # a00020f <_entry-0x75fffdf1>
    800060de:	00e78863          	beq	a5,a4,800060ee <net_rx+0x2a2>
  kfree(m);
    800060e2:	8526                	mv	a0,s1
    800060e4:	ffffa097          	auipc	ra,0xffffa
    800060e8:	f38080e7          	jalr	-200(ra) # 8000001c <kfree>
}
    800060ec:	bb55                	j	80005ea0 <net_rx+0x54>
  memmove(smac, arphdr->sha, ETHADDR_LEN); // sender's ethernet address
    800060ee:	4619                	li	a2,6
    800060f0:	00850593          	addi	a1,a0,8
    800060f4:	fb840513          	addi	a0,s0,-72
    800060f8:	ffffa097          	auipc	ra,0xffffa
    800060fc:	0de080e7          	jalr	222(ra) # 800001d6 <memmove>
  sip = ntohl(arphdr->sip); // sender's IP address (qemu's slirp)
    80006100:	00e94703          	lbu	a4,14(s2)
    80006104:	00f94783          	lbu	a5,15(s2)
    80006108:	07a2                	slli	a5,a5,0x8
    8000610a:	8fd9                	or	a5,a5,a4
    8000610c:	01094703          	lbu	a4,16(s2)
    80006110:	0742                	slli	a4,a4,0x10
    80006112:	8f5d                	or	a4,a4,a5
    80006114:	01194783          	lbu	a5,17(s2)
    80006118:	07e2                	slli	a5,a5,0x18
    8000611a:	8fd9                	or	a5,a5,a4
    8000611c:	0007871b          	sext.w	a4,a5
  return (((val & 0x000000ffUL) << 24) |
    80006120:	0187991b          	slliw	s2,a5,0x18
          ((val & 0xff000000UL) >> 24));
    80006124:	0187579b          	srliw	a5,a4,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80006128:	00f96933          	or	s2,s2,a5
          ((val & 0x0000ff00UL) << 8) |
    8000612c:	0087179b          	slliw	a5,a4,0x8
    80006130:	00ff06b7          	lui	a3,0xff0
    80006134:	8ff5                	and	a5,a5,a3
          ((val & 0x00ff0000UL) >> 8) |
    80006136:	00f96933          	or	s2,s2,a5
    8000613a:	0087579b          	srliw	a5,a4,0x8
    8000613e:	6741                	lui	a4,0x10
    80006140:	f0070713          	addi	a4,a4,-256 # ff00 <_entry-0x7fff0100>
    80006144:	8ff9                	and	a5,a5,a4
    80006146:	00f96933          	or	s2,s2,a5
    8000614a:	2901                	sext.w	s2,s2
  m = mbufalloc(MBUF_DEFAULT_HEADROOM);
    8000614c:	08000513          	li	a0,128
    80006150:	00000097          	auipc	ra,0x0
    80006154:	b2a080e7          	jalr	-1238(ra) # 80005c7a <mbufalloc>
    80006158:	8a2a                	mv	s4,a0
  if (!m)
    8000615a:	d541                	beqz	a0,800060e2 <net_rx+0x296>
  arphdr = mbufputhdr(m, *arphdr);
    8000615c:	45f1                	li	a1,28
    8000615e:	00000097          	auipc	ra,0x0
    80006162:	ac0080e7          	jalr	-1344(ra) # 80005c1e <mbufput>
    80006166:	89aa                	mv	s3,a0
  arphdr->hrd = htons(ARP_HRD_ETHER);
    80006168:	00050023          	sb	zero,0(a0)
    8000616c:	4785                	li	a5,1
    8000616e:	00f500a3          	sb	a5,1(a0)
  arphdr->pro = htons(ETHTYPE_IP);
    80006172:	47a1                	li	a5,8
    80006174:	00f50123          	sb	a5,2(a0)
    80006178:	000501a3          	sb	zero,3(a0)
  arphdr->hln = ETHADDR_LEN;
    8000617c:	4799                	li	a5,6
    8000617e:	00f50223          	sb	a5,4(a0)
  arphdr->pln = sizeof(uint32);
    80006182:	4791                	li	a5,4
    80006184:	00f502a3          	sb	a5,5(a0)
  arphdr->op = htons(op);
    80006188:	00050323          	sb	zero,6(a0)
    8000618c:	4a89                	li	s5,2
    8000618e:	015503a3          	sb	s5,7(a0)
  memmove(arphdr->sha, local_mac, ETHADDR_LEN);
    80006192:	4619                	li	a2,6
    80006194:	00003597          	auipc	a1,0x3
    80006198:	73c58593          	addi	a1,a1,1852 # 800098d0 <local_mac>
    8000619c:	0521                	addi	a0,a0,8
    8000619e:	ffffa097          	auipc	ra,0xffffa
    800061a2:	038080e7          	jalr	56(ra) # 800001d6 <memmove>
  arphdr->sip = htonl(local_ip);
    800061a6:	47a9                	li	a5,10
    800061a8:	00f98723          	sb	a5,14(s3)
    800061ac:	000987a3          	sb	zero,15(s3)
    800061b0:	01598823          	sb	s5,16(s3)
    800061b4:	47bd                	li	a5,15
    800061b6:	00f988a3          	sb	a5,17(s3)
  memmove(arphdr->tha, dmac, ETHADDR_LEN);
    800061ba:	4619                	li	a2,6
    800061bc:	fb840593          	addi	a1,s0,-72
    800061c0:	01298513          	addi	a0,s3,18
    800061c4:	ffffa097          	auipc	ra,0xffffa
    800061c8:	012080e7          	jalr	18(ra) # 800001d6 <memmove>
  return (((val & 0x000000ffUL) << 24) |
    800061cc:	0189171b          	slliw	a4,s2,0x18
          ((val & 0xff000000UL) >> 24));
    800061d0:	0189579b          	srliw	a5,s2,0x18
          ((val & 0x00ff0000UL) >> 8) |
    800061d4:	8f5d                	or	a4,a4,a5
          ((val & 0x0000ff00UL) << 8) |
    800061d6:	0089179b          	slliw	a5,s2,0x8
    800061da:	00ff06b7          	lui	a3,0xff0
    800061de:	8ff5                	and	a5,a5,a3
          ((val & 0x00ff0000UL) >> 8) |
    800061e0:	8f5d                	or	a4,a4,a5
    800061e2:	0089579b          	srliw	a5,s2,0x8
    800061e6:	66c1                	lui	a3,0x10
    800061e8:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    800061ec:	8ff5                	and	a5,a5,a3
    800061ee:	8fd9                	or	a5,a5,a4
  arphdr->tip = htonl(dip);
    800061f0:	00e98c23          	sb	a4,24(s3)
    800061f4:	0087d71b          	srliw	a4,a5,0x8
    800061f8:	00e98ca3          	sb	a4,25(s3)
    800061fc:	0107d71b          	srliw	a4,a5,0x10
    80006200:	00e98d23          	sb	a4,26(s3)
    80006204:	0187d79b          	srliw	a5,a5,0x18
    80006208:	00f98da3          	sb	a5,27(s3)
  net_tx_eth(m, ETHTYPE_ARP);
    8000620c:	6585                	lui	a1,0x1
    8000620e:	80658593          	addi	a1,a1,-2042 # 806 <_entry-0x7ffff7fa>
    80006212:	8552                	mv	a0,s4
    80006214:	00000097          	auipc	ra,0x0
    80006218:	992080e7          	jalr	-1646(ra) # 80005ba6 <net_tx_eth>
  return 0;
    8000621c:	b5d9                	j	800060e2 <net_rx+0x296>

000000008000621e <sockinit>:
static struct spinlock lock;
static struct sock *sockets;

void
sockinit(void)
{
    8000621e:	1141                	addi	sp,sp,-16
    80006220:	e406                	sd	ra,8(sp)
    80006222:	e022                	sd	s0,0(sp)
    80006224:	0800                	addi	s0,sp,16
  initlock(&lock, "socktbl");
    80006226:	00003597          	auipc	a1,0x3
    8000622a:	60a58593          	addi	a1,a1,1546 # 80009830 <syscalls+0x450>
    8000622e:	00015517          	auipc	a0,0x15
    80006232:	fd250513          	addi	a0,a0,-46 # 8001b200 <lock>
    80006236:	00001097          	auipc	ra,0x1
    8000623a:	e4c080e7          	jalr	-436(ra) # 80007082 <initlock>
}
    8000623e:	60a2                	ld	ra,8(sp)
    80006240:	6402                	ld	s0,0(sp)
    80006242:	0141                	addi	sp,sp,16
    80006244:	8082                	ret

0000000080006246 <sockalloc>:

int
sockalloc(struct file **f, uint32 raddr, uint16 lport, uint16 rport)
{
    80006246:	7139                	addi	sp,sp,-64
    80006248:	fc06                	sd	ra,56(sp)
    8000624a:	f822                	sd	s0,48(sp)
    8000624c:	f426                	sd	s1,40(sp)
    8000624e:	f04a                	sd	s2,32(sp)
    80006250:	ec4e                	sd	s3,24(sp)
    80006252:	e852                	sd	s4,16(sp)
    80006254:	e456                	sd	s5,8(sp)
    80006256:	0080                	addi	s0,sp,64
    80006258:	892a                	mv	s2,a0
    8000625a:	84ae                	mv	s1,a1
    8000625c:	8a32                	mv	s4,a2
    8000625e:	89b6                	mv	s3,a3
  struct sock *si, *pos;

  si = 0;
  *f = 0;
    80006260:	00053023          	sd	zero,0(a0)
  if ((*f = filealloc()) == 0)
    80006264:	ffffd097          	auipc	ra,0xffffd
    80006268:	6c0080e7          	jalr	1728(ra) # 80003924 <filealloc>
    8000626c:	00a93023          	sd	a0,0(s2)
    80006270:	c975                	beqz	a0,80006364 <sockalloc+0x11e>
    goto bad;
  if ((si = (struct sock*)kalloc()) == 0)
    80006272:	ffffa097          	auipc	ra,0xffffa
    80006276:	ea8080e7          	jalr	-344(ra) # 8000011a <kalloc>
    8000627a:	8aaa                	mv	s5,a0
    8000627c:	c15d                	beqz	a0,80006322 <sockalloc+0xdc>
    goto bad;

  // initialize objects
  si->raddr = raddr;
    8000627e:	c504                	sw	s1,8(a0)
  si->lport = lport;
    80006280:	01451623          	sh	s4,12(a0)
  si->rport = rport;
    80006284:	01351723          	sh	s3,14(a0)
  initlock(&si->lock, "sock");
    80006288:	00003597          	auipc	a1,0x3
    8000628c:	5b058593          	addi	a1,a1,1456 # 80009838 <syscalls+0x458>
    80006290:	0541                	addi	a0,a0,16
    80006292:	00001097          	auipc	ra,0x1
    80006296:	df0080e7          	jalr	-528(ra) # 80007082 <initlock>
  mbufq_init(&si->rxq);
    8000629a:	028a8513          	addi	a0,s5,40
    8000629e:	00000097          	auipc	ra,0x0
    800062a2:	a94080e7          	jalr	-1388(ra) # 80005d32 <mbufq_init>
  (*f)->type = FD_SOCK;
    800062a6:	00093783          	ld	a5,0(s2)
    800062aa:	4711                	li	a4,4
    800062ac:	c398                	sw	a4,0(a5)
  (*f)->readable = 1;
    800062ae:	00093703          	ld	a4,0(s2)
    800062b2:	4785                	li	a5,1
    800062b4:	00f70423          	sb	a5,8(a4)
  (*f)->writable = 1;
    800062b8:	00093703          	ld	a4,0(s2)
    800062bc:	00f704a3          	sb	a5,9(a4)
  (*f)->sock = si;
    800062c0:	00093783          	ld	a5,0(s2)
    800062c4:	0357b023          	sd	s5,32(a5)

  // add to list of sockets
  acquire(&lock);
    800062c8:	00015517          	auipc	a0,0x15
    800062cc:	f3850513          	addi	a0,a0,-200 # 8001b200 <lock>
    800062d0:	00001097          	auipc	ra,0x1
    800062d4:	e42080e7          	jalr	-446(ra) # 80007112 <acquire>
  pos = sockets;
    800062d8:	00003597          	auipc	a1,0x3
    800062dc:	6905b583          	ld	a1,1680(a1) # 80009968 <sockets>
  while (pos) {
    800062e0:	c9b1                	beqz	a1,80006334 <sockalloc+0xee>
  pos = sockets;
    800062e2:	87ae                	mv	a5,a1
    if (pos->raddr == raddr &&
    800062e4:	000a061b          	sext.w	a2,s4
        pos->lport == lport &&
    800062e8:	0009869b          	sext.w	a3,s3
    800062ec:	a019                	j	800062f2 <sockalloc+0xac>
	pos->rport == rport) {
      release(&lock);
      goto bad;
    }
    pos = pos->next;
    800062ee:	639c                	ld	a5,0(a5)
  while (pos) {
    800062f0:	c3b1                	beqz	a5,80006334 <sockalloc+0xee>
    if (pos->raddr == raddr &&
    800062f2:	4798                	lw	a4,8(a5)
    800062f4:	fe971de3          	bne	a4,s1,800062ee <sockalloc+0xa8>
    800062f8:	00c7d703          	lhu	a4,12(a5)
    800062fc:	fec719e3          	bne	a4,a2,800062ee <sockalloc+0xa8>
        pos->lport == lport &&
    80006300:	00e7d703          	lhu	a4,14(a5)
    80006304:	fed715e3          	bne	a4,a3,800062ee <sockalloc+0xa8>
      release(&lock);
    80006308:	00015517          	auipc	a0,0x15
    8000630c:	ef850513          	addi	a0,a0,-264 # 8001b200 <lock>
    80006310:	00001097          	auipc	ra,0x1
    80006314:	eb6080e7          	jalr	-330(ra) # 800071c6 <release>
  release(&lock);
  return 0;

bad:
  if (si)
    kfree((char*)si);
    80006318:	8556                	mv	a0,s5
    8000631a:	ffffa097          	auipc	ra,0xffffa
    8000631e:	d02080e7          	jalr	-766(ra) # 8000001c <kfree>
  if (*f)
    80006322:	00093503          	ld	a0,0(s2)
    80006326:	c129                	beqz	a0,80006368 <sockalloc+0x122>
    fileclose(*f);
    80006328:	ffffd097          	auipc	ra,0xffffd
    8000632c:	6b8080e7          	jalr	1720(ra) # 800039e0 <fileclose>
  return -1;
    80006330:	557d                	li	a0,-1
    80006332:	a005                	j	80006352 <sockalloc+0x10c>
  si->next = sockets;
    80006334:	00bab023          	sd	a1,0(s5)
  sockets = si;
    80006338:	00003797          	auipc	a5,0x3
    8000633c:	6357b823          	sd	s5,1584(a5) # 80009968 <sockets>
  release(&lock);
    80006340:	00015517          	auipc	a0,0x15
    80006344:	ec050513          	addi	a0,a0,-320 # 8001b200 <lock>
    80006348:	00001097          	auipc	ra,0x1
    8000634c:	e7e080e7          	jalr	-386(ra) # 800071c6 <release>
  return 0;
    80006350:	4501                	li	a0,0
}
    80006352:	70e2                	ld	ra,56(sp)
    80006354:	7442                	ld	s0,48(sp)
    80006356:	74a2                	ld	s1,40(sp)
    80006358:	7902                	ld	s2,32(sp)
    8000635a:	69e2                	ld	s3,24(sp)
    8000635c:	6a42                	ld	s4,16(sp)
    8000635e:	6aa2                	ld	s5,8(sp)
    80006360:	6121                	addi	sp,sp,64
    80006362:	8082                	ret
  return -1;
    80006364:	557d                	li	a0,-1
    80006366:	b7f5                	j	80006352 <sockalloc+0x10c>
    80006368:	557d                	li	a0,-1
    8000636a:	b7e5                	j	80006352 <sockalloc+0x10c>

000000008000636c <sockclose>:

void
sockclose(struct sock *si)
{
    8000636c:	1101                	addi	sp,sp,-32
    8000636e:	ec06                	sd	ra,24(sp)
    80006370:	e822                	sd	s0,16(sp)
    80006372:	e426                	sd	s1,8(sp)
    80006374:	e04a                	sd	s2,0(sp)
    80006376:	1000                	addi	s0,sp,32
    80006378:	892a                	mv	s2,a0
  struct sock **pos;
  struct mbuf *m;

  // remove from list of sockets
  acquire(&lock);
    8000637a:	00015517          	auipc	a0,0x15
    8000637e:	e8650513          	addi	a0,a0,-378 # 8001b200 <lock>
    80006382:	00001097          	auipc	ra,0x1
    80006386:	d90080e7          	jalr	-624(ra) # 80007112 <acquire>
  pos = &sockets;
    8000638a:	00003797          	auipc	a5,0x3
    8000638e:	5de7b783          	ld	a5,1502(a5) # 80009968 <sockets>
  while (*pos) {
    80006392:	cb99                	beqz	a5,800063a8 <sockclose+0x3c>
    if (*pos == si){
    80006394:	04f90463          	beq	s2,a5,800063dc <sockclose+0x70>
      *pos = si->next;
      break;
    }
    pos = &(*pos)->next;
    80006398:	873e                	mv	a4,a5
    8000639a:	639c                	ld	a5,0(a5)
  while (*pos) {
    8000639c:	c791                	beqz	a5,800063a8 <sockclose+0x3c>
    if (*pos == si){
    8000639e:	fef91de3          	bne	s2,a5,80006398 <sockclose+0x2c>
      *pos = si->next;
    800063a2:	00093783          	ld	a5,0(s2)
    800063a6:	e31c                	sd	a5,0(a4)
  }
  release(&lock);
    800063a8:	00015517          	auipc	a0,0x15
    800063ac:	e5850513          	addi	a0,a0,-424 # 8001b200 <lock>
    800063b0:	00001097          	auipc	ra,0x1
    800063b4:	e16080e7          	jalr	-490(ra) # 800071c6 <release>

  // free any pending mbufs
  while (!mbufq_empty(&si->rxq)) {
    800063b8:	02890493          	addi	s1,s2,40
    800063bc:	8526                	mv	a0,s1
    800063be:	00000097          	auipc	ra,0x0
    800063c2:	962080e7          	jalr	-1694(ra) # 80005d20 <mbufq_empty>
    800063c6:	e105                	bnez	a0,800063e6 <sockclose+0x7a>
    m = mbufq_pophead(&si->rxq);
    800063c8:	8526                	mv	a0,s1
    800063ca:	00000097          	auipc	ra,0x0
    800063ce:	940080e7          	jalr	-1728(ra) # 80005d0a <mbufq_pophead>
    mbuffree(m);
    800063d2:	00000097          	auipc	ra,0x0
    800063d6:	900080e7          	jalr	-1792(ra) # 80005cd2 <mbuffree>
    800063da:	b7cd                	j	800063bc <sockclose+0x50>
  pos = &sockets;
    800063dc:	00003717          	auipc	a4,0x3
    800063e0:	58c70713          	addi	a4,a4,1420 # 80009968 <sockets>
    800063e4:	bf7d                	j	800063a2 <sockclose+0x36>
  }

  kfree((char*)si);
    800063e6:	854a                	mv	a0,s2
    800063e8:	ffffa097          	auipc	ra,0xffffa
    800063ec:	c34080e7          	jalr	-972(ra) # 8000001c <kfree>
}
    800063f0:	60e2                	ld	ra,24(sp)
    800063f2:	6442                	ld	s0,16(sp)
    800063f4:	64a2                	ld	s1,8(sp)
    800063f6:	6902                	ld	s2,0(sp)
    800063f8:	6105                	addi	sp,sp,32
    800063fa:	8082                	ret

00000000800063fc <sockread>:

int
sockread(struct sock *si, uint64 addr, int n)
{
    800063fc:	7139                	addi	sp,sp,-64
    800063fe:	fc06                	sd	ra,56(sp)
    80006400:	f822                	sd	s0,48(sp)
    80006402:	f426                	sd	s1,40(sp)
    80006404:	f04a                	sd	s2,32(sp)
    80006406:	ec4e                	sd	s3,24(sp)
    80006408:	e852                	sd	s4,16(sp)
    8000640a:	e456                	sd	s5,8(sp)
    8000640c:	0080                	addi	s0,sp,64
    8000640e:	84aa                	mv	s1,a0
    80006410:	8a2e                	mv	s4,a1
    80006412:	8ab2                	mv	s5,a2
  struct proc *pr = myproc();
    80006414:	ffffb097          	auipc	ra,0xffffb
    80006418:	a98080e7          	jalr	-1384(ra) # 80000eac <myproc>
    8000641c:	892a                	mv	s2,a0
  struct mbuf *m;
  int len;

  acquire(&si->lock);
    8000641e:	01048993          	addi	s3,s1,16
    80006422:	854e                	mv	a0,s3
    80006424:	00001097          	auipc	ra,0x1
    80006428:	cee080e7          	jalr	-786(ra) # 80007112 <acquire>
  while (mbufq_empty(&si->rxq) && !pr->killed) {
    8000642c:	02848493          	addi	s1,s1,40
    80006430:	a039                	j	8000643e <sockread+0x42>
    sleep(&si->rxq, &si->lock);
    80006432:	85ce                	mv	a1,s3
    80006434:	8526                	mv	a0,s1
    80006436:	ffffb097          	auipc	ra,0xffffb
    8000643a:	11e080e7          	jalr	286(ra) # 80001554 <sleep>
  while (mbufq_empty(&si->rxq) && !pr->killed) {
    8000643e:	8526                	mv	a0,s1
    80006440:	00000097          	auipc	ra,0x0
    80006444:	8e0080e7          	jalr	-1824(ra) # 80005d20 <mbufq_empty>
    80006448:	c919                	beqz	a0,8000645e <sockread+0x62>
    8000644a:	02892783          	lw	a5,40(s2)
    8000644e:	d3f5                	beqz	a5,80006432 <sockread+0x36>
  }
  if (pr->killed) {
    release(&si->lock);
    80006450:	854e                	mv	a0,s3
    80006452:	00001097          	auipc	ra,0x1
    80006456:	d74080e7          	jalr	-652(ra) # 800071c6 <release>
    return -1;
    8000645a:	59fd                	li	s3,-1
    8000645c:	a881                	j	800064ac <sockread+0xb0>
  if (pr->killed) {
    8000645e:	02892783          	lw	a5,40(s2)
    80006462:	f7fd                	bnez	a5,80006450 <sockread+0x54>
  }
  m = mbufq_pophead(&si->rxq);
    80006464:	8526                	mv	a0,s1
    80006466:	00000097          	auipc	ra,0x0
    8000646a:	8a4080e7          	jalr	-1884(ra) # 80005d0a <mbufq_pophead>
    8000646e:	84aa                	mv	s1,a0
  release(&si->lock);
    80006470:	854e                	mv	a0,s3
    80006472:	00001097          	auipc	ra,0x1
    80006476:	d54080e7          	jalr	-684(ra) # 800071c6 <release>

  len = m->len;
  if (len > n)
    8000647a:	489c                	lw	a5,16(s1)
    8000647c:	89be                	mv	s3,a5
    8000647e:	2781                	sext.w	a5,a5
    80006480:	00fad363          	bge	s5,a5,80006486 <sockread+0x8a>
    80006484:	89d6                	mv	s3,s5
    80006486:	2981                	sext.w	s3,s3
    len = n;
  if (copyout(pr->pagetable, addr, m->head, len) == -1) {
    80006488:	86ce                	mv	a3,s3
    8000648a:	6490                	ld	a2,8(s1)
    8000648c:	85d2                	mv	a1,s4
    8000648e:	05093503          	ld	a0,80(s2)
    80006492:	ffffa097          	auipc	ra,0xffffa
    80006496:	6de080e7          	jalr	1758(ra) # 80000b70 <copyout>
    8000649a:	892a                	mv	s2,a0
    8000649c:	57fd                	li	a5,-1
    8000649e:	02f50163          	beq	a0,a5,800064c0 <sockread+0xc4>
    mbuffree(m);
    return -1;
  }
  mbuffree(m);
    800064a2:	8526                	mv	a0,s1
    800064a4:	00000097          	auipc	ra,0x0
    800064a8:	82e080e7          	jalr	-2002(ra) # 80005cd2 <mbuffree>
  return len;
}
    800064ac:	854e                	mv	a0,s3
    800064ae:	70e2                	ld	ra,56(sp)
    800064b0:	7442                	ld	s0,48(sp)
    800064b2:	74a2                	ld	s1,40(sp)
    800064b4:	7902                	ld	s2,32(sp)
    800064b6:	69e2                	ld	s3,24(sp)
    800064b8:	6a42                	ld	s4,16(sp)
    800064ba:	6aa2                	ld	s5,8(sp)
    800064bc:	6121                	addi	sp,sp,64
    800064be:	8082                	ret
    mbuffree(m);
    800064c0:	8526                	mv	a0,s1
    800064c2:	00000097          	auipc	ra,0x0
    800064c6:	810080e7          	jalr	-2032(ra) # 80005cd2 <mbuffree>
    return -1;
    800064ca:	89ca                	mv	s3,s2
    800064cc:	b7c5                	j	800064ac <sockread+0xb0>

00000000800064ce <sockwrite>:

int
sockwrite(struct sock *si, uint64 addr, int n)
{
    800064ce:	7139                	addi	sp,sp,-64
    800064d0:	fc06                	sd	ra,56(sp)
    800064d2:	f822                	sd	s0,48(sp)
    800064d4:	f426                	sd	s1,40(sp)
    800064d6:	f04a                	sd	s2,32(sp)
    800064d8:	ec4e                	sd	s3,24(sp)
    800064da:	e852                	sd	s4,16(sp)
    800064dc:	e456                	sd	s5,8(sp)
    800064de:	0080                	addi	s0,sp,64
    800064e0:	8aaa                	mv	s5,a0
    800064e2:	89ae                	mv	s3,a1
    800064e4:	8932                	mv	s2,a2
  struct proc *pr = myproc();
    800064e6:	ffffb097          	auipc	ra,0xffffb
    800064ea:	9c6080e7          	jalr	-1594(ra) # 80000eac <myproc>
    800064ee:	8a2a                	mv	s4,a0
  struct mbuf *m;

  m = mbufalloc(MBUF_DEFAULT_HEADROOM);
    800064f0:	08000513          	li	a0,128
    800064f4:	fffff097          	auipc	ra,0xfffff
    800064f8:	786080e7          	jalr	1926(ra) # 80005c7a <mbufalloc>
  if (!m)
    800064fc:	c12d                	beqz	a0,8000655e <sockwrite+0x90>
    800064fe:	84aa                	mv	s1,a0
    return -1;

  if (copyin(pr->pagetable, mbufput(m, n), addr, n) == -1) {
    80006500:	050a3a03          	ld	s4,80(s4)
    80006504:	85ca                	mv	a1,s2
    80006506:	fffff097          	auipc	ra,0xfffff
    8000650a:	718080e7          	jalr	1816(ra) # 80005c1e <mbufput>
    8000650e:	85aa                	mv	a1,a0
    80006510:	86ca                	mv	a3,s2
    80006512:	864e                	mv	a2,s3
    80006514:	8552                	mv	a0,s4
    80006516:	ffffa097          	auipc	ra,0xffffa
    8000651a:	6e6080e7          	jalr	1766(ra) # 80000bfc <copyin>
    8000651e:	89aa                	mv	s3,a0
    80006520:	57fd                	li	a5,-1
    80006522:	02f50863          	beq	a0,a5,80006552 <sockwrite+0x84>
    mbuffree(m);
    return -1;
  }
  net_tx_udp(m, si->raddr, si->lport, si->rport);
    80006526:	00ead683          	lhu	a3,14(s5)
    8000652a:	00cad603          	lhu	a2,12(s5)
    8000652e:	008aa583          	lw	a1,8(s5)
    80006532:	8526                	mv	a0,s1
    80006534:	00000097          	auipc	ra,0x0
    80006538:	80e080e7          	jalr	-2034(ra) # 80005d42 <net_tx_udp>
  return n;
    8000653c:	89ca                	mv	s3,s2
}
    8000653e:	854e                	mv	a0,s3
    80006540:	70e2                	ld	ra,56(sp)
    80006542:	7442                	ld	s0,48(sp)
    80006544:	74a2                	ld	s1,40(sp)
    80006546:	7902                	ld	s2,32(sp)
    80006548:	69e2                	ld	s3,24(sp)
    8000654a:	6a42                	ld	s4,16(sp)
    8000654c:	6aa2                	ld	s5,8(sp)
    8000654e:	6121                	addi	sp,sp,64
    80006550:	8082                	ret
    mbuffree(m);
    80006552:	8526                	mv	a0,s1
    80006554:	fffff097          	auipc	ra,0xfffff
    80006558:	77e080e7          	jalr	1918(ra) # 80005cd2 <mbuffree>
    return -1;
    8000655c:	b7cd                	j	8000653e <sockwrite+0x70>
    return -1;
    8000655e:	59fd                	li	s3,-1
    80006560:	bff9                	j	8000653e <sockwrite+0x70>

0000000080006562 <sockrecvudp>:

// called by protocol handler layer to deliver UDP packets
void
sockrecvudp(struct mbuf *m, uint32 raddr, uint16 lport, uint16 rport)
{
    80006562:	7139                	addi	sp,sp,-64
    80006564:	fc06                	sd	ra,56(sp)
    80006566:	f822                	sd	s0,48(sp)
    80006568:	f426                	sd	s1,40(sp)
    8000656a:	f04a                	sd	s2,32(sp)
    8000656c:	ec4e                	sd	s3,24(sp)
    8000656e:	e852                	sd	s4,16(sp)
    80006570:	e456                	sd	s5,8(sp)
    80006572:	0080                	addi	s0,sp,64
    80006574:	8a2a                	mv	s4,a0
    80006576:	892e                	mv	s2,a1
    80006578:	89b2                	mv	s3,a2
    8000657a:	8ab6                	mv	s5,a3
  // any sleeping reader. Free the mbuf if there are no sockets
  // registered to handle it.
  //
  struct sock *si;

  acquire(&lock);
    8000657c:	00015517          	auipc	a0,0x15
    80006580:	c8450513          	addi	a0,a0,-892 # 8001b200 <lock>
    80006584:	00001097          	auipc	ra,0x1
    80006588:	b8e080e7          	jalr	-1138(ra) # 80007112 <acquire>
  si = sockets;
    8000658c:	00003497          	auipc	s1,0x3
    80006590:	3dc4b483          	ld	s1,988(s1) # 80009968 <sockets>
  while (si) {
    80006594:	c4ad                	beqz	s1,800065fe <sockrecvudp+0x9c>
    if (si->raddr == raddr && si->lport == lport && si->rport == rport)
    80006596:	0009871b          	sext.w	a4,s3
    8000659a:	000a869b          	sext.w	a3,s5
    8000659e:	a019                	j	800065a4 <sockrecvudp+0x42>
      goto found;
    si = si->next;
    800065a0:	6084                	ld	s1,0(s1)
  while (si) {
    800065a2:	ccb1                	beqz	s1,800065fe <sockrecvudp+0x9c>
    if (si->raddr == raddr && si->lport == lport && si->rport == rport)
    800065a4:	449c                	lw	a5,8(s1)
    800065a6:	ff279de3          	bne	a5,s2,800065a0 <sockrecvudp+0x3e>
    800065aa:	00c4d783          	lhu	a5,12(s1)
    800065ae:	fee799e3          	bne	a5,a4,800065a0 <sockrecvudp+0x3e>
    800065b2:	00e4d783          	lhu	a5,14(s1)
    800065b6:	fed795e3          	bne	a5,a3,800065a0 <sockrecvudp+0x3e>
  release(&lock);
  mbuffree(m);
  return;

found:
  acquire(&si->lock);
    800065ba:	01048913          	addi	s2,s1,16
    800065be:	854a                	mv	a0,s2
    800065c0:	00001097          	auipc	ra,0x1
    800065c4:	b52080e7          	jalr	-1198(ra) # 80007112 <acquire>
  mbufq_pushtail(&si->rxq, m);
    800065c8:	02848493          	addi	s1,s1,40
    800065cc:	85d2                	mv	a1,s4
    800065ce:	8526                	mv	a0,s1
    800065d0:	fffff097          	auipc	ra,0xfffff
    800065d4:	71a080e7          	jalr	1818(ra) # 80005cea <mbufq_pushtail>
  wakeup(&si->rxq);
    800065d8:	8526                	mv	a0,s1
    800065da:	ffffb097          	auipc	ra,0xffffb
    800065de:	fde080e7          	jalr	-34(ra) # 800015b8 <wakeup>
  release(&si->lock);
    800065e2:	854a                	mv	a0,s2
    800065e4:	00001097          	auipc	ra,0x1
    800065e8:	be2080e7          	jalr	-1054(ra) # 800071c6 <release>
  release(&lock);
    800065ec:	00015517          	auipc	a0,0x15
    800065f0:	c1450513          	addi	a0,a0,-1004 # 8001b200 <lock>
    800065f4:	00001097          	auipc	ra,0x1
    800065f8:	bd2080e7          	jalr	-1070(ra) # 800071c6 <release>
    800065fc:	a831                	j	80006618 <sockrecvudp+0xb6>
  release(&lock);
    800065fe:	00015517          	auipc	a0,0x15
    80006602:	c0250513          	addi	a0,a0,-1022 # 8001b200 <lock>
    80006606:	00001097          	auipc	ra,0x1
    8000660a:	bc0080e7          	jalr	-1088(ra) # 800071c6 <release>
  mbuffree(m);
    8000660e:	8552                	mv	a0,s4
    80006610:	fffff097          	auipc	ra,0xfffff
    80006614:	6c2080e7          	jalr	1730(ra) # 80005cd2 <mbuffree>
}
    80006618:	70e2                	ld	ra,56(sp)
    8000661a:	7442                	ld	s0,48(sp)
    8000661c:	74a2                	ld	s1,40(sp)
    8000661e:	7902                	ld	s2,32(sp)
    80006620:	69e2                	ld	s3,24(sp)
    80006622:	6a42                	ld	s4,16(sp)
    80006624:	6aa2                	ld	s5,8(sp)
    80006626:	6121                	addi	sp,sp,64
    80006628:	8082                	ret

000000008000662a <pci_init>:
#include "proc.h"
#include "defs.h"

void
pci_init()
{
    8000662a:	715d                	addi	sp,sp,-80
    8000662c:	e486                	sd	ra,72(sp)
    8000662e:	e0a2                	sd	s0,64(sp)
    80006630:	fc26                	sd	s1,56(sp)
    80006632:	f84a                	sd	s2,48(sp)
    80006634:	f44e                	sd	s3,40(sp)
    80006636:	f052                	sd	s4,32(sp)
    80006638:	ec56                	sd	s5,24(sp)
    8000663a:	e85a                	sd	s6,16(sp)
    8000663c:	e45e                	sd	s7,8(sp)
    8000663e:	0880                	addi	s0,sp,80
    80006640:	300004b7          	lui	s1,0x30000
    uint32 off = (bus << 16) | (dev << 11) | (func << 8) | (offset);
    volatile uint32 *base = ecam + off;
    uint32 id = base[0];
    
    // 100e:8086 is an e1000
    if(id == 0x100e8086){
    80006644:	100e8937          	lui	s2,0x100e8
    80006648:	08690913          	addi	s2,s2,134 # 100e8086 <_entry-0x6ff17f7a>
      // command and status register.
      // bit 0 : I/O access enable
      // bit 1 : memory access enable
      // bit 2 : enable mastering
      base[1] = 7;
    8000664c:	4b9d                	li	s7,7
      for(int i = 0; i < 6; i++){
        uint32 old = base[4+i];

        // writing all 1's to the BAR causes it to be
        // replaced with its size.
        base[4+i] = 0xffffffff;
    8000664e:	5afd                	li	s5,-1
        base[4+i] = old;
      }

      // tell the e1000 to reveal its registers at
      // physical address 0x40000000.
      base[4+0] = e1000_regs;
    80006650:	40000b37          	lui	s6,0x40000
  for(int dev = 0; dev < 32; dev++){
    80006654:	6a09                	lui	s4,0x2
    80006656:	300409b7          	lui	s3,0x30040
    8000665a:	a819                	j	80006670 <pci_init+0x46>
      base[4+0] = e1000_regs;
    8000665c:	0166a823          	sw	s6,16(a3)

      e1000_init((uint32*)e1000_regs);
    80006660:	855a                	mv	a0,s6
    80006662:	fffff097          	auipc	ra,0xfffff
    80006666:	140080e7          	jalr	320(ra) # 800057a2 <e1000_init>
  for(int dev = 0; dev < 32; dev++){
    8000666a:	94d2                	add	s1,s1,s4
    8000666c:	03348a63          	beq	s1,s3,800066a0 <pci_init+0x76>
    volatile uint32 *base = ecam + off;
    80006670:	86a6                	mv	a3,s1
    uint32 id = base[0];
    80006672:	409c                	lw	a5,0(s1)
    80006674:	2781                	sext.w	a5,a5
    if(id == 0x100e8086){
    80006676:	ff279ae3          	bne	a5,s2,8000666a <pci_init+0x40>
      base[1] = 7;
    8000667a:	0174a223          	sw	s7,4(s1) # 30000004 <_entry-0x4ffffffc>
      __sync_synchronize();
    8000667e:	0ff0000f          	fence
      for(int i = 0; i < 6; i++){
    80006682:	01048793          	addi	a5,s1,16
    80006686:	02848613          	addi	a2,s1,40
        uint32 old = base[4+i];
    8000668a:	4398                	lw	a4,0(a5)
    8000668c:	2701                	sext.w	a4,a4
        base[4+i] = 0xffffffff;
    8000668e:	0157a023          	sw	s5,0(a5)
        __sync_synchronize();
    80006692:	0ff0000f          	fence
        base[4+i] = old;
    80006696:	c398                	sw	a4,0(a5)
      for(int i = 0; i < 6; i++){
    80006698:	0791                	addi	a5,a5,4
    8000669a:	fec798e3          	bne	a5,a2,8000668a <pci_init+0x60>
    8000669e:	bf7d                	j	8000665c <pci_init+0x32>
    }
  }
}
    800066a0:	60a6                	ld	ra,72(sp)
    800066a2:	6406                	ld	s0,64(sp)
    800066a4:	74e2                	ld	s1,56(sp)
    800066a6:	7942                	ld	s2,48(sp)
    800066a8:	79a2                	ld	s3,40(sp)
    800066aa:	7a02                	ld	s4,32(sp)
    800066ac:	6ae2                	ld	s5,24(sp)
    800066ae:	6b42                	ld	s6,16(sp)
    800066b0:	6ba2                	ld	s7,8(sp)
    800066b2:	6161                	addi	sp,sp,80
    800066b4:	8082                	ret

00000000800066b6 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800066b6:	1141                	addi	sp,sp,-16
    800066b8:	e422                	sd	s0,8(sp)
    800066ba:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800066bc:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800066c0:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800066c4:	0037979b          	slliw	a5,a5,0x3
    800066c8:	02004737          	lui	a4,0x2004
    800066cc:	97ba                	add	a5,a5,a4
    800066ce:	0200c737          	lui	a4,0x200c
    800066d2:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800066d6:	000f4637          	lui	a2,0xf4
    800066da:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800066de:	9732                	add	a4,a4,a2
    800066e0:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800066e2:	00259693          	slli	a3,a1,0x2
    800066e6:	96ae                	add	a3,a3,a1
    800066e8:	068e                	slli	a3,a3,0x3
    800066ea:	00015717          	auipc	a4,0x15
    800066ee:	b3670713          	addi	a4,a4,-1226 # 8001b220 <timer_scratch>
    800066f2:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800066f4:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800066f6:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800066f8:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800066fc:	fffff797          	auipc	a5,0xfffff
    80006700:	a7478793          	addi	a5,a5,-1420 # 80005170 <timervec>
    80006704:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80006708:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000670c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80006710:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80006714:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80006718:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000671c:	30479073          	csrw	mie,a5
}
    80006720:	6422                	ld	s0,8(sp)
    80006722:	0141                	addi	sp,sp,16
    80006724:	8082                	ret

0000000080006726 <start>:
{
    80006726:	1141                	addi	sp,sp,-16
    80006728:	e406                	sd	ra,8(sp)
    8000672a:	e022                	sd	s0,0(sp)
    8000672c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000672e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80006732:	7779                	lui	a4,0xffffe
    80006734:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb39f>
    80006738:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000673a:	6705                	lui	a4,0x1
    8000673c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80006740:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80006742:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80006746:	ffffa797          	auipc	a5,0xffffa
    8000674a:	bda78793          	addi	a5,a5,-1062 # 80000320 <main>
    8000674e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80006752:	4781                	li	a5,0
    80006754:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80006758:	67c1                	lui	a5,0x10
    8000675a:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000675c:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80006760:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80006764:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80006768:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000676c:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80006770:	57fd                	li	a5,-1
    80006772:	83a9                	srli	a5,a5,0xa
    80006774:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80006778:	47bd                	li	a5,15
    8000677a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000677e:	00000097          	auipc	ra,0x0
    80006782:	f38080e7          	jalr	-200(ra) # 800066b6 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80006786:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000678a:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000678c:	823e                	mv	tp,a5
  asm volatile("mret");
    8000678e:	30200073          	mret
}
    80006792:	60a2                	ld	ra,8(sp)
    80006794:	6402                	ld	s0,0(sp)
    80006796:	0141                	addi	sp,sp,16
    80006798:	8082                	ret

000000008000679a <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000679a:	715d                	addi	sp,sp,-80
    8000679c:	e486                	sd	ra,72(sp)
    8000679e:	e0a2                	sd	s0,64(sp)
    800067a0:	fc26                	sd	s1,56(sp)
    800067a2:	f84a                	sd	s2,48(sp)
    800067a4:	f44e                	sd	s3,40(sp)
    800067a6:	f052                	sd	s4,32(sp)
    800067a8:	ec56                	sd	s5,24(sp)
    800067aa:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800067ac:	04c05763          	blez	a2,800067fa <consolewrite+0x60>
    800067b0:	8a2a                	mv	s4,a0
    800067b2:	84ae                	mv	s1,a1
    800067b4:	89b2                	mv	s3,a2
    800067b6:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800067b8:	5afd                	li	s5,-1
    800067ba:	4685                	li	a3,1
    800067bc:	8626                	mv	a2,s1
    800067be:	85d2                	mv	a1,s4
    800067c0:	fbf40513          	addi	a0,s0,-65
    800067c4:	ffffb097          	auipc	ra,0xffffb
    800067c8:	1ee080e7          	jalr	494(ra) # 800019b2 <either_copyin>
    800067cc:	01550d63          	beq	a0,s5,800067e6 <consolewrite+0x4c>
      break;
    uartputc(c);
    800067d0:	fbf44503          	lbu	a0,-65(s0)
    800067d4:	00000097          	auipc	ra,0x0
    800067d8:	784080e7          	jalr	1924(ra) # 80006f58 <uartputc>
  for(i = 0; i < n; i++){
    800067dc:	2905                	addiw	s2,s2,1
    800067de:	0485                	addi	s1,s1,1
    800067e0:	fd299de3          	bne	s3,s2,800067ba <consolewrite+0x20>
    800067e4:	894e                	mv	s2,s3
  }

  return i;
}
    800067e6:	854a                	mv	a0,s2
    800067e8:	60a6                	ld	ra,72(sp)
    800067ea:	6406                	ld	s0,64(sp)
    800067ec:	74e2                	ld	s1,56(sp)
    800067ee:	7942                	ld	s2,48(sp)
    800067f0:	79a2                	ld	s3,40(sp)
    800067f2:	7a02                	ld	s4,32(sp)
    800067f4:	6ae2                	ld	s5,24(sp)
    800067f6:	6161                	addi	sp,sp,80
    800067f8:	8082                	ret
  for(i = 0; i < n; i++){
    800067fa:	4901                	li	s2,0
    800067fc:	b7ed                	j	800067e6 <consolewrite+0x4c>

00000000800067fe <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800067fe:	7159                	addi	sp,sp,-112
    80006800:	f486                	sd	ra,104(sp)
    80006802:	f0a2                	sd	s0,96(sp)
    80006804:	eca6                	sd	s1,88(sp)
    80006806:	e8ca                	sd	s2,80(sp)
    80006808:	e4ce                	sd	s3,72(sp)
    8000680a:	e0d2                	sd	s4,64(sp)
    8000680c:	fc56                	sd	s5,56(sp)
    8000680e:	f85a                	sd	s6,48(sp)
    80006810:	f45e                	sd	s7,40(sp)
    80006812:	f062                	sd	s8,32(sp)
    80006814:	ec66                	sd	s9,24(sp)
    80006816:	e86a                	sd	s10,16(sp)
    80006818:	1880                	addi	s0,sp,112
    8000681a:	8aaa                	mv	s5,a0
    8000681c:	8a2e                	mv	s4,a1
    8000681e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80006820:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80006824:	0001d517          	auipc	a0,0x1d
    80006828:	b3c50513          	addi	a0,a0,-1220 # 80023360 <cons>
    8000682c:	00001097          	auipc	ra,0x1
    80006830:	8e6080e7          	jalr	-1818(ra) # 80007112 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80006834:	0001d497          	auipc	s1,0x1d
    80006838:	b2c48493          	addi	s1,s1,-1236 # 80023360 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000683c:	0001d917          	auipc	s2,0x1d
    80006840:	bbc90913          	addi	s2,s2,-1092 # 800233f8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80006844:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80006846:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80006848:	4ca9                	li	s9,10
  while(n > 0){
    8000684a:	07305b63          	blez	s3,800068c0 <consoleread+0xc2>
    while(cons.r == cons.w){
    8000684e:	0984a783          	lw	a5,152(s1)
    80006852:	09c4a703          	lw	a4,156(s1)
    80006856:	02f71763          	bne	a4,a5,80006884 <consoleread+0x86>
      if(killed(myproc())){
    8000685a:	ffffa097          	auipc	ra,0xffffa
    8000685e:	652080e7          	jalr	1618(ra) # 80000eac <myproc>
    80006862:	ffffb097          	auipc	ra,0xffffb
    80006866:	f9a080e7          	jalr	-102(ra) # 800017fc <killed>
    8000686a:	e535                	bnez	a0,800068d6 <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    8000686c:	85a6                	mv	a1,s1
    8000686e:	854a                	mv	a0,s2
    80006870:	ffffb097          	auipc	ra,0xffffb
    80006874:	ce4080e7          	jalr	-796(ra) # 80001554 <sleep>
    while(cons.r == cons.w){
    80006878:	0984a783          	lw	a5,152(s1)
    8000687c:	09c4a703          	lw	a4,156(s1)
    80006880:	fcf70de3          	beq	a4,a5,8000685a <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80006884:	0017871b          	addiw	a4,a5,1
    80006888:	08e4ac23          	sw	a4,152(s1)
    8000688c:	07f7f713          	andi	a4,a5,127
    80006890:	9726                	add	a4,a4,s1
    80006892:	01874703          	lbu	a4,24(a4)
    80006896:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    8000689a:	077d0563          	beq	s10,s7,80006904 <consoleread+0x106>
    cbuf = c;
    8000689e:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800068a2:	4685                	li	a3,1
    800068a4:	f9f40613          	addi	a2,s0,-97
    800068a8:	85d2                	mv	a1,s4
    800068aa:	8556                	mv	a0,s5
    800068ac:	ffffb097          	auipc	ra,0xffffb
    800068b0:	0b0080e7          	jalr	176(ra) # 8000195c <either_copyout>
    800068b4:	01850663          	beq	a0,s8,800068c0 <consoleread+0xc2>
    dst++;
    800068b8:	0a05                	addi	s4,s4,1 # 2001 <_entry-0x7fffdfff>
    --n;
    800068ba:	39fd                	addiw	s3,s3,-1 # 3003ffff <_entry-0x4ffc0001>
    if(c == '\n'){
    800068bc:	f99d17e3          	bne	s10,s9,8000684a <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800068c0:	0001d517          	auipc	a0,0x1d
    800068c4:	aa050513          	addi	a0,a0,-1376 # 80023360 <cons>
    800068c8:	00001097          	auipc	ra,0x1
    800068cc:	8fe080e7          	jalr	-1794(ra) # 800071c6 <release>

  return target - n;
    800068d0:	413b053b          	subw	a0,s6,s3
    800068d4:	a811                	j	800068e8 <consoleread+0xea>
        release(&cons.lock);
    800068d6:	0001d517          	auipc	a0,0x1d
    800068da:	a8a50513          	addi	a0,a0,-1398 # 80023360 <cons>
    800068de:	00001097          	auipc	ra,0x1
    800068e2:	8e8080e7          	jalr	-1816(ra) # 800071c6 <release>
        return -1;
    800068e6:	557d                	li	a0,-1
}
    800068e8:	70a6                	ld	ra,104(sp)
    800068ea:	7406                	ld	s0,96(sp)
    800068ec:	64e6                	ld	s1,88(sp)
    800068ee:	6946                	ld	s2,80(sp)
    800068f0:	69a6                	ld	s3,72(sp)
    800068f2:	6a06                	ld	s4,64(sp)
    800068f4:	7ae2                	ld	s5,56(sp)
    800068f6:	7b42                	ld	s6,48(sp)
    800068f8:	7ba2                	ld	s7,40(sp)
    800068fa:	7c02                	ld	s8,32(sp)
    800068fc:	6ce2                	ld	s9,24(sp)
    800068fe:	6d42                	ld	s10,16(sp)
    80006900:	6165                	addi	sp,sp,112
    80006902:	8082                	ret
      if(n < target){
    80006904:	0009871b          	sext.w	a4,s3
    80006908:	fb677ce3          	bgeu	a4,s6,800068c0 <consoleread+0xc2>
        cons.r--;
    8000690c:	0001d717          	auipc	a4,0x1d
    80006910:	aef72623          	sw	a5,-1300(a4) # 800233f8 <cons+0x98>
    80006914:	b775                	j	800068c0 <consoleread+0xc2>

0000000080006916 <consputc>:
{
    80006916:	1141                	addi	sp,sp,-16
    80006918:	e406                	sd	ra,8(sp)
    8000691a:	e022                	sd	s0,0(sp)
    8000691c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000691e:	10000793          	li	a5,256
    80006922:	00f50a63          	beq	a0,a5,80006936 <consputc+0x20>
    uartputc_sync(c);
    80006926:	00000097          	auipc	ra,0x0
    8000692a:	560080e7          	jalr	1376(ra) # 80006e86 <uartputc_sync>
}
    8000692e:	60a2                	ld	ra,8(sp)
    80006930:	6402                	ld	s0,0(sp)
    80006932:	0141                	addi	sp,sp,16
    80006934:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80006936:	4521                	li	a0,8
    80006938:	00000097          	auipc	ra,0x0
    8000693c:	54e080e7          	jalr	1358(ra) # 80006e86 <uartputc_sync>
    80006940:	02000513          	li	a0,32
    80006944:	00000097          	auipc	ra,0x0
    80006948:	542080e7          	jalr	1346(ra) # 80006e86 <uartputc_sync>
    8000694c:	4521                	li	a0,8
    8000694e:	00000097          	auipc	ra,0x0
    80006952:	538080e7          	jalr	1336(ra) # 80006e86 <uartputc_sync>
    80006956:	bfe1                	j	8000692e <consputc+0x18>

0000000080006958 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80006958:	1101                	addi	sp,sp,-32
    8000695a:	ec06                	sd	ra,24(sp)
    8000695c:	e822                	sd	s0,16(sp)
    8000695e:	e426                	sd	s1,8(sp)
    80006960:	e04a                	sd	s2,0(sp)
    80006962:	1000                	addi	s0,sp,32
    80006964:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80006966:	0001d517          	auipc	a0,0x1d
    8000696a:	9fa50513          	addi	a0,a0,-1542 # 80023360 <cons>
    8000696e:	00000097          	auipc	ra,0x0
    80006972:	7a4080e7          	jalr	1956(ra) # 80007112 <acquire>

  switch(c){
    80006976:	47d5                	li	a5,21
    80006978:	0af48663          	beq	s1,a5,80006a24 <consoleintr+0xcc>
    8000697c:	0297ca63          	blt	a5,s1,800069b0 <consoleintr+0x58>
    80006980:	47a1                	li	a5,8
    80006982:	0ef48763          	beq	s1,a5,80006a70 <consoleintr+0x118>
    80006986:	47c1                	li	a5,16
    80006988:	10f49a63          	bne	s1,a5,80006a9c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    8000698c:	ffffb097          	auipc	ra,0xffffb
    80006990:	07c080e7          	jalr	124(ra) # 80001a08 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80006994:	0001d517          	auipc	a0,0x1d
    80006998:	9cc50513          	addi	a0,a0,-1588 # 80023360 <cons>
    8000699c:	00001097          	auipc	ra,0x1
    800069a0:	82a080e7          	jalr	-2006(ra) # 800071c6 <release>
}
    800069a4:	60e2                	ld	ra,24(sp)
    800069a6:	6442                	ld	s0,16(sp)
    800069a8:	64a2                	ld	s1,8(sp)
    800069aa:	6902                	ld	s2,0(sp)
    800069ac:	6105                	addi	sp,sp,32
    800069ae:	8082                	ret
  switch(c){
    800069b0:	07f00793          	li	a5,127
    800069b4:	0af48e63          	beq	s1,a5,80006a70 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800069b8:	0001d717          	auipc	a4,0x1d
    800069bc:	9a870713          	addi	a4,a4,-1624 # 80023360 <cons>
    800069c0:	0a072783          	lw	a5,160(a4)
    800069c4:	09872703          	lw	a4,152(a4)
    800069c8:	9f99                	subw	a5,a5,a4
    800069ca:	07f00713          	li	a4,127
    800069ce:	fcf763e3          	bltu	a4,a5,80006994 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    800069d2:	47b5                	li	a5,13
    800069d4:	0cf48763          	beq	s1,a5,80006aa2 <consoleintr+0x14a>
      consputc(c);
    800069d8:	8526                	mv	a0,s1
    800069da:	00000097          	auipc	ra,0x0
    800069de:	f3c080e7          	jalr	-196(ra) # 80006916 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800069e2:	0001d797          	auipc	a5,0x1d
    800069e6:	97e78793          	addi	a5,a5,-1666 # 80023360 <cons>
    800069ea:	0a07a683          	lw	a3,160(a5)
    800069ee:	0016871b          	addiw	a4,a3,1
    800069f2:	0007061b          	sext.w	a2,a4
    800069f6:	0ae7a023          	sw	a4,160(a5)
    800069fa:	07f6f693          	andi	a3,a3,127
    800069fe:	97b6                	add	a5,a5,a3
    80006a00:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80006a04:	47a9                	li	a5,10
    80006a06:	0cf48563          	beq	s1,a5,80006ad0 <consoleintr+0x178>
    80006a0a:	4791                	li	a5,4
    80006a0c:	0cf48263          	beq	s1,a5,80006ad0 <consoleintr+0x178>
    80006a10:	0001d797          	auipc	a5,0x1d
    80006a14:	9e87a783          	lw	a5,-1560(a5) # 800233f8 <cons+0x98>
    80006a18:	9f1d                	subw	a4,a4,a5
    80006a1a:	08000793          	li	a5,128
    80006a1e:	f6f71be3          	bne	a4,a5,80006994 <consoleintr+0x3c>
    80006a22:	a07d                	j	80006ad0 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80006a24:	0001d717          	auipc	a4,0x1d
    80006a28:	93c70713          	addi	a4,a4,-1732 # 80023360 <cons>
    80006a2c:	0a072783          	lw	a5,160(a4)
    80006a30:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80006a34:	0001d497          	auipc	s1,0x1d
    80006a38:	92c48493          	addi	s1,s1,-1748 # 80023360 <cons>
    while(cons.e != cons.w &&
    80006a3c:	4929                	li	s2,10
    80006a3e:	f4f70be3          	beq	a4,a5,80006994 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80006a42:	37fd                	addiw	a5,a5,-1
    80006a44:	07f7f713          	andi	a4,a5,127
    80006a48:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80006a4a:	01874703          	lbu	a4,24(a4)
    80006a4e:	f52703e3          	beq	a4,s2,80006994 <consoleintr+0x3c>
      cons.e--;
    80006a52:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80006a56:	10000513          	li	a0,256
    80006a5a:	00000097          	auipc	ra,0x0
    80006a5e:	ebc080e7          	jalr	-324(ra) # 80006916 <consputc>
    while(cons.e != cons.w &&
    80006a62:	0a04a783          	lw	a5,160(s1)
    80006a66:	09c4a703          	lw	a4,156(s1)
    80006a6a:	fcf71ce3          	bne	a4,a5,80006a42 <consoleintr+0xea>
    80006a6e:	b71d                	j	80006994 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80006a70:	0001d717          	auipc	a4,0x1d
    80006a74:	8f070713          	addi	a4,a4,-1808 # 80023360 <cons>
    80006a78:	0a072783          	lw	a5,160(a4)
    80006a7c:	09c72703          	lw	a4,156(a4)
    80006a80:	f0f70ae3          	beq	a4,a5,80006994 <consoleintr+0x3c>
      cons.e--;
    80006a84:	37fd                	addiw	a5,a5,-1
    80006a86:	0001d717          	auipc	a4,0x1d
    80006a8a:	96f72d23          	sw	a5,-1670(a4) # 80023400 <cons+0xa0>
      consputc(BACKSPACE);
    80006a8e:	10000513          	li	a0,256
    80006a92:	00000097          	auipc	ra,0x0
    80006a96:	e84080e7          	jalr	-380(ra) # 80006916 <consputc>
    80006a9a:	bded                	j	80006994 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80006a9c:	ee048ce3          	beqz	s1,80006994 <consoleintr+0x3c>
    80006aa0:	bf21                	j	800069b8 <consoleintr+0x60>
      consputc(c);
    80006aa2:	4529                	li	a0,10
    80006aa4:	00000097          	auipc	ra,0x0
    80006aa8:	e72080e7          	jalr	-398(ra) # 80006916 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80006aac:	0001d797          	auipc	a5,0x1d
    80006ab0:	8b478793          	addi	a5,a5,-1868 # 80023360 <cons>
    80006ab4:	0a07a703          	lw	a4,160(a5)
    80006ab8:	0017069b          	addiw	a3,a4,1
    80006abc:	0006861b          	sext.w	a2,a3
    80006ac0:	0ad7a023          	sw	a3,160(a5)
    80006ac4:	07f77713          	andi	a4,a4,127
    80006ac8:	97ba                	add	a5,a5,a4
    80006aca:	4729                	li	a4,10
    80006acc:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80006ad0:	0001d797          	auipc	a5,0x1d
    80006ad4:	92c7a623          	sw	a2,-1748(a5) # 800233fc <cons+0x9c>
        wakeup(&cons.r);
    80006ad8:	0001d517          	auipc	a0,0x1d
    80006adc:	92050513          	addi	a0,a0,-1760 # 800233f8 <cons+0x98>
    80006ae0:	ffffb097          	auipc	ra,0xffffb
    80006ae4:	ad8080e7          	jalr	-1320(ra) # 800015b8 <wakeup>
    80006ae8:	b575                	j	80006994 <consoleintr+0x3c>

0000000080006aea <consoleinit>:

void
consoleinit(void)
{
    80006aea:	1141                	addi	sp,sp,-16
    80006aec:	e406                	sd	ra,8(sp)
    80006aee:	e022                	sd	s0,0(sp)
    80006af0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80006af2:	00003597          	auipc	a1,0x3
    80006af6:	d4e58593          	addi	a1,a1,-690 # 80009840 <syscalls+0x460>
    80006afa:	0001d517          	auipc	a0,0x1d
    80006afe:	86650513          	addi	a0,a0,-1946 # 80023360 <cons>
    80006b02:	00000097          	auipc	ra,0x0
    80006b06:	580080e7          	jalr	1408(ra) # 80007082 <initlock>

  uartinit();
    80006b0a:	00000097          	auipc	ra,0x0
    80006b0e:	32c080e7          	jalr	812(ra) # 80006e36 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80006b12:	00013797          	auipc	a5,0x13
    80006b16:	f1678793          	addi	a5,a5,-234 # 80019a28 <devsw>
    80006b1a:	00000717          	auipc	a4,0x0
    80006b1e:	ce470713          	addi	a4,a4,-796 # 800067fe <consoleread>
    80006b22:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80006b24:	00000717          	auipc	a4,0x0
    80006b28:	c7670713          	addi	a4,a4,-906 # 8000679a <consolewrite>
    80006b2c:	ef98                	sd	a4,24(a5)
}
    80006b2e:	60a2                	ld	ra,8(sp)
    80006b30:	6402                	ld	s0,0(sp)
    80006b32:	0141                	addi	sp,sp,16
    80006b34:	8082                	ret

0000000080006b36 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80006b36:	7179                	addi	sp,sp,-48
    80006b38:	f406                	sd	ra,40(sp)
    80006b3a:	f022                	sd	s0,32(sp)
    80006b3c:	ec26                	sd	s1,24(sp)
    80006b3e:	e84a                	sd	s2,16(sp)
    80006b40:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80006b42:	c219                	beqz	a2,80006b48 <printint+0x12>
    80006b44:	08054763          	bltz	a0,80006bd2 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80006b48:	2501                	sext.w	a0,a0
    80006b4a:	4881                	li	a7,0
    80006b4c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80006b50:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80006b52:	2581                	sext.w	a1,a1
    80006b54:	00003617          	auipc	a2,0x3
    80006b58:	d1c60613          	addi	a2,a2,-740 # 80009870 <digits>
    80006b5c:	883a                	mv	a6,a4
    80006b5e:	2705                	addiw	a4,a4,1
    80006b60:	02b577bb          	remuw	a5,a0,a1
    80006b64:	1782                	slli	a5,a5,0x20
    80006b66:	9381                	srli	a5,a5,0x20
    80006b68:	97b2                	add	a5,a5,a2
    80006b6a:	0007c783          	lbu	a5,0(a5)
    80006b6e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80006b72:	0005079b          	sext.w	a5,a0
    80006b76:	02b5553b          	divuw	a0,a0,a1
    80006b7a:	0685                	addi	a3,a3,1
    80006b7c:	feb7f0e3          	bgeu	a5,a1,80006b5c <printint+0x26>

  if(sign)
    80006b80:	00088c63          	beqz	a7,80006b98 <printint+0x62>
    buf[i++] = '-';
    80006b84:	fe070793          	addi	a5,a4,-32
    80006b88:	00878733          	add	a4,a5,s0
    80006b8c:	02d00793          	li	a5,45
    80006b90:	fef70823          	sb	a5,-16(a4)
    80006b94:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80006b98:	02e05763          	blez	a4,80006bc6 <printint+0x90>
    80006b9c:	fd040793          	addi	a5,s0,-48
    80006ba0:	00e784b3          	add	s1,a5,a4
    80006ba4:	fff78913          	addi	s2,a5,-1
    80006ba8:	993a                	add	s2,s2,a4
    80006baa:	377d                	addiw	a4,a4,-1
    80006bac:	1702                	slli	a4,a4,0x20
    80006bae:	9301                	srli	a4,a4,0x20
    80006bb0:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80006bb4:	fff4c503          	lbu	a0,-1(s1)
    80006bb8:	00000097          	auipc	ra,0x0
    80006bbc:	d5e080e7          	jalr	-674(ra) # 80006916 <consputc>
  while(--i >= 0)
    80006bc0:	14fd                	addi	s1,s1,-1
    80006bc2:	ff2499e3          	bne	s1,s2,80006bb4 <printint+0x7e>
}
    80006bc6:	70a2                	ld	ra,40(sp)
    80006bc8:	7402                	ld	s0,32(sp)
    80006bca:	64e2                	ld	s1,24(sp)
    80006bcc:	6942                	ld	s2,16(sp)
    80006bce:	6145                	addi	sp,sp,48
    80006bd0:	8082                	ret
    x = -xx;
    80006bd2:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80006bd6:	4885                	li	a7,1
    x = -xx;
    80006bd8:	bf95                	j	80006b4c <printint+0x16>

0000000080006bda <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006bda:	1101                	addi	sp,sp,-32
    80006bdc:	ec06                	sd	ra,24(sp)
    80006bde:	e822                	sd	s0,16(sp)
    80006be0:	e426                	sd	s1,8(sp)
    80006be2:	1000                	addi	s0,sp,32
    80006be4:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006be6:	0001d797          	auipc	a5,0x1d
    80006bea:	8207ad23          	sw	zero,-1990(a5) # 80023420 <pr+0x18>
  printf("panic: ");
    80006bee:	00003517          	auipc	a0,0x3
    80006bf2:	c5a50513          	addi	a0,a0,-934 # 80009848 <syscalls+0x468>
    80006bf6:	00000097          	auipc	ra,0x0
    80006bfa:	02e080e7          	jalr	46(ra) # 80006c24 <printf>
  printf(s);
    80006bfe:	8526                	mv	a0,s1
    80006c00:	00000097          	auipc	ra,0x0
    80006c04:	024080e7          	jalr	36(ra) # 80006c24 <printf>
  printf("\n");
    80006c08:	00002517          	auipc	a0,0x2
    80006c0c:	44050513          	addi	a0,a0,1088 # 80009048 <etext+0x48>
    80006c10:	00000097          	auipc	ra,0x0
    80006c14:	014080e7          	jalr	20(ra) # 80006c24 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006c18:	4785                	li	a5,1
    80006c1a:	00003717          	auipc	a4,0x3
    80006c1e:	d4f72b23          	sw	a5,-682(a4) # 80009970 <panicked>
  for(;;)
    80006c22:	a001                	j	80006c22 <panic+0x48>

0000000080006c24 <printf>:
{
    80006c24:	7131                	addi	sp,sp,-192
    80006c26:	fc86                	sd	ra,120(sp)
    80006c28:	f8a2                	sd	s0,112(sp)
    80006c2a:	f4a6                	sd	s1,104(sp)
    80006c2c:	f0ca                	sd	s2,96(sp)
    80006c2e:	ecce                	sd	s3,88(sp)
    80006c30:	e8d2                	sd	s4,80(sp)
    80006c32:	e4d6                	sd	s5,72(sp)
    80006c34:	e0da                	sd	s6,64(sp)
    80006c36:	fc5e                	sd	s7,56(sp)
    80006c38:	f862                	sd	s8,48(sp)
    80006c3a:	f466                	sd	s9,40(sp)
    80006c3c:	f06a                	sd	s10,32(sp)
    80006c3e:	ec6e                	sd	s11,24(sp)
    80006c40:	0100                	addi	s0,sp,128
    80006c42:	8a2a                	mv	s4,a0
    80006c44:	e40c                	sd	a1,8(s0)
    80006c46:	e810                	sd	a2,16(s0)
    80006c48:	ec14                	sd	a3,24(s0)
    80006c4a:	f018                	sd	a4,32(s0)
    80006c4c:	f41c                	sd	a5,40(s0)
    80006c4e:	03043823          	sd	a6,48(s0)
    80006c52:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006c56:	0001cd97          	auipc	s11,0x1c
    80006c5a:	7cadad83          	lw	s11,1994(s11) # 80023420 <pr+0x18>
  if(locking)
    80006c5e:	020d9b63          	bnez	s11,80006c94 <printf+0x70>
  if (fmt == 0)
    80006c62:	040a0263          	beqz	s4,80006ca6 <printf+0x82>
  va_start(ap, fmt);
    80006c66:	00840793          	addi	a5,s0,8
    80006c6a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006c6e:	000a4503          	lbu	a0,0(s4)
    80006c72:	14050f63          	beqz	a0,80006dd0 <printf+0x1ac>
    80006c76:	4981                	li	s3,0
    if(c != '%'){
    80006c78:	02500a93          	li	s5,37
    switch(c){
    80006c7c:	07000b93          	li	s7,112
  consputc('x');
    80006c80:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006c82:	00003b17          	auipc	s6,0x3
    80006c86:	beeb0b13          	addi	s6,s6,-1042 # 80009870 <digits>
    switch(c){
    80006c8a:	07300c93          	li	s9,115
    80006c8e:	06400c13          	li	s8,100
    80006c92:	a82d                	j	80006ccc <printf+0xa8>
    acquire(&pr.lock);
    80006c94:	0001c517          	auipc	a0,0x1c
    80006c98:	77450513          	addi	a0,a0,1908 # 80023408 <pr>
    80006c9c:	00000097          	auipc	ra,0x0
    80006ca0:	476080e7          	jalr	1142(ra) # 80007112 <acquire>
    80006ca4:	bf7d                	j	80006c62 <printf+0x3e>
    panic("null fmt");
    80006ca6:	00003517          	auipc	a0,0x3
    80006caa:	bb250513          	addi	a0,a0,-1102 # 80009858 <syscalls+0x478>
    80006cae:	00000097          	auipc	ra,0x0
    80006cb2:	f2c080e7          	jalr	-212(ra) # 80006bda <panic>
      consputc(c);
    80006cb6:	00000097          	auipc	ra,0x0
    80006cba:	c60080e7          	jalr	-928(ra) # 80006916 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006cbe:	2985                	addiw	s3,s3,1
    80006cc0:	013a07b3          	add	a5,s4,s3
    80006cc4:	0007c503          	lbu	a0,0(a5)
    80006cc8:	10050463          	beqz	a0,80006dd0 <printf+0x1ac>
    if(c != '%'){
    80006ccc:	ff5515e3          	bne	a0,s5,80006cb6 <printf+0x92>
    c = fmt[++i] & 0xff;
    80006cd0:	2985                	addiw	s3,s3,1
    80006cd2:	013a07b3          	add	a5,s4,s3
    80006cd6:	0007c783          	lbu	a5,0(a5)
    80006cda:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006cde:	cbed                	beqz	a5,80006dd0 <printf+0x1ac>
    switch(c){
    80006ce0:	05778a63          	beq	a5,s7,80006d34 <printf+0x110>
    80006ce4:	02fbf663          	bgeu	s7,a5,80006d10 <printf+0xec>
    80006ce8:	09978863          	beq	a5,s9,80006d78 <printf+0x154>
    80006cec:	07800713          	li	a4,120
    80006cf0:	0ce79563          	bne	a5,a4,80006dba <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80006cf4:	f8843783          	ld	a5,-120(s0)
    80006cf8:	00878713          	addi	a4,a5,8
    80006cfc:	f8e43423          	sd	a4,-120(s0)
    80006d00:	4605                	li	a2,1
    80006d02:	85ea                	mv	a1,s10
    80006d04:	4388                	lw	a0,0(a5)
    80006d06:	00000097          	auipc	ra,0x0
    80006d0a:	e30080e7          	jalr	-464(ra) # 80006b36 <printint>
      break;
    80006d0e:	bf45                	j	80006cbe <printf+0x9a>
    switch(c){
    80006d10:	09578f63          	beq	a5,s5,80006dae <printf+0x18a>
    80006d14:	0b879363          	bne	a5,s8,80006dba <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80006d18:	f8843783          	ld	a5,-120(s0)
    80006d1c:	00878713          	addi	a4,a5,8
    80006d20:	f8e43423          	sd	a4,-120(s0)
    80006d24:	4605                	li	a2,1
    80006d26:	45a9                	li	a1,10
    80006d28:	4388                	lw	a0,0(a5)
    80006d2a:	00000097          	auipc	ra,0x0
    80006d2e:	e0c080e7          	jalr	-500(ra) # 80006b36 <printint>
      break;
    80006d32:	b771                	j	80006cbe <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80006d34:	f8843783          	ld	a5,-120(s0)
    80006d38:	00878713          	addi	a4,a5,8
    80006d3c:	f8e43423          	sd	a4,-120(s0)
    80006d40:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80006d44:	03000513          	li	a0,48
    80006d48:	00000097          	auipc	ra,0x0
    80006d4c:	bce080e7          	jalr	-1074(ra) # 80006916 <consputc>
  consputc('x');
    80006d50:	07800513          	li	a0,120
    80006d54:	00000097          	auipc	ra,0x0
    80006d58:	bc2080e7          	jalr	-1086(ra) # 80006916 <consputc>
    80006d5c:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006d5e:	03c95793          	srli	a5,s2,0x3c
    80006d62:	97da                	add	a5,a5,s6
    80006d64:	0007c503          	lbu	a0,0(a5)
    80006d68:	00000097          	auipc	ra,0x0
    80006d6c:	bae080e7          	jalr	-1106(ra) # 80006916 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006d70:	0912                	slli	s2,s2,0x4
    80006d72:	34fd                	addiw	s1,s1,-1
    80006d74:	f4ed                	bnez	s1,80006d5e <printf+0x13a>
    80006d76:	b7a1                	j	80006cbe <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006d78:	f8843783          	ld	a5,-120(s0)
    80006d7c:	00878713          	addi	a4,a5,8
    80006d80:	f8e43423          	sd	a4,-120(s0)
    80006d84:	6384                	ld	s1,0(a5)
    80006d86:	cc89                	beqz	s1,80006da0 <printf+0x17c>
      for(; *s; s++)
    80006d88:	0004c503          	lbu	a0,0(s1)
    80006d8c:	d90d                	beqz	a0,80006cbe <printf+0x9a>
        consputc(*s);
    80006d8e:	00000097          	auipc	ra,0x0
    80006d92:	b88080e7          	jalr	-1144(ra) # 80006916 <consputc>
      for(; *s; s++)
    80006d96:	0485                	addi	s1,s1,1
    80006d98:	0004c503          	lbu	a0,0(s1)
    80006d9c:	f96d                	bnez	a0,80006d8e <printf+0x16a>
    80006d9e:	b705                	j	80006cbe <printf+0x9a>
        s = "(null)";
    80006da0:	00003497          	auipc	s1,0x3
    80006da4:	ab048493          	addi	s1,s1,-1360 # 80009850 <syscalls+0x470>
      for(; *s; s++)
    80006da8:	02800513          	li	a0,40
    80006dac:	b7cd                	j	80006d8e <printf+0x16a>
      consputc('%');
    80006dae:	8556                	mv	a0,s5
    80006db0:	00000097          	auipc	ra,0x0
    80006db4:	b66080e7          	jalr	-1178(ra) # 80006916 <consputc>
      break;
    80006db8:	b719                	j	80006cbe <printf+0x9a>
      consputc('%');
    80006dba:	8556                	mv	a0,s5
    80006dbc:	00000097          	auipc	ra,0x0
    80006dc0:	b5a080e7          	jalr	-1190(ra) # 80006916 <consputc>
      consputc(c);
    80006dc4:	8526                	mv	a0,s1
    80006dc6:	00000097          	auipc	ra,0x0
    80006dca:	b50080e7          	jalr	-1200(ra) # 80006916 <consputc>
      break;
    80006dce:	bdc5                	j	80006cbe <printf+0x9a>
  if(locking)
    80006dd0:	020d9163          	bnez	s11,80006df2 <printf+0x1ce>
}
    80006dd4:	70e6                	ld	ra,120(sp)
    80006dd6:	7446                	ld	s0,112(sp)
    80006dd8:	74a6                	ld	s1,104(sp)
    80006dda:	7906                	ld	s2,96(sp)
    80006ddc:	69e6                	ld	s3,88(sp)
    80006dde:	6a46                	ld	s4,80(sp)
    80006de0:	6aa6                	ld	s5,72(sp)
    80006de2:	6b06                	ld	s6,64(sp)
    80006de4:	7be2                	ld	s7,56(sp)
    80006de6:	7c42                	ld	s8,48(sp)
    80006de8:	7ca2                	ld	s9,40(sp)
    80006dea:	7d02                	ld	s10,32(sp)
    80006dec:	6de2                	ld	s11,24(sp)
    80006dee:	6129                	addi	sp,sp,192
    80006df0:	8082                	ret
    release(&pr.lock);
    80006df2:	0001c517          	auipc	a0,0x1c
    80006df6:	61650513          	addi	a0,a0,1558 # 80023408 <pr>
    80006dfa:	00000097          	auipc	ra,0x0
    80006dfe:	3cc080e7          	jalr	972(ra) # 800071c6 <release>
}
    80006e02:	bfc9                	j	80006dd4 <printf+0x1b0>

0000000080006e04 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006e04:	1101                	addi	sp,sp,-32
    80006e06:	ec06                	sd	ra,24(sp)
    80006e08:	e822                	sd	s0,16(sp)
    80006e0a:	e426                	sd	s1,8(sp)
    80006e0c:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006e0e:	0001c497          	auipc	s1,0x1c
    80006e12:	5fa48493          	addi	s1,s1,1530 # 80023408 <pr>
    80006e16:	00003597          	auipc	a1,0x3
    80006e1a:	a5258593          	addi	a1,a1,-1454 # 80009868 <syscalls+0x488>
    80006e1e:	8526                	mv	a0,s1
    80006e20:	00000097          	auipc	ra,0x0
    80006e24:	262080e7          	jalr	610(ra) # 80007082 <initlock>
  pr.locking = 1;
    80006e28:	4785                	li	a5,1
    80006e2a:	cc9c                	sw	a5,24(s1)
}
    80006e2c:	60e2                	ld	ra,24(sp)
    80006e2e:	6442                	ld	s0,16(sp)
    80006e30:	64a2                	ld	s1,8(sp)
    80006e32:	6105                	addi	sp,sp,32
    80006e34:	8082                	ret

0000000080006e36 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006e36:	1141                	addi	sp,sp,-16
    80006e38:	e406                	sd	ra,8(sp)
    80006e3a:	e022                	sd	s0,0(sp)
    80006e3c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006e3e:	100007b7          	lui	a5,0x10000
    80006e42:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006e46:	f8000713          	li	a4,-128
    80006e4a:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006e4e:	470d                	li	a4,3
    80006e50:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006e54:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006e58:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006e5c:	469d                	li	a3,7
    80006e5e:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006e62:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006e66:	00003597          	auipc	a1,0x3
    80006e6a:	a2258593          	addi	a1,a1,-1502 # 80009888 <digits+0x18>
    80006e6e:	0001c517          	auipc	a0,0x1c
    80006e72:	5ba50513          	addi	a0,a0,1466 # 80023428 <uart_tx_lock>
    80006e76:	00000097          	auipc	ra,0x0
    80006e7a:	20c080e7          	jalr	524(ra) # 80007082 <initlock>
}
    80006e7e:	60a2                	ld	ra,8(sp)
    80006e80:	6402                	ld	s0,0(sp)
    80006e82:	0141                	addi	sp,sp,16
    80006e84:	8082                	ret

0000000080006e86 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006e86:	1101                	addi	sp,sp,-32
    80006e88:	ec06                	sd	ra,24(sp)
    80006e8a:	e822                	sd	s0,16(sp)
    80006e8c:	e426                	sd	s1,8(sp)
    80006e8e:	1000                	addi	s0,sp,32
    80006e90:	84aa                	mv	s1,a0
  push_off();
    80006e92:	00000097          	auipc	ra,0x0
    80006e96:	234080e7          	jalr	564(ra) # 800070c6 <push_off>

  if(panicked){
    80006e9a:	00003797          	auipc	a5,0x3
    80006e9e:	ad67a783          	lw	a5,-1322(a5) # 80009970 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006ea2:	10000737          	lui	a4,0x10000
  if(panicked){
    80006ea6:	c391                	beqz	a5,80006eaa <uartputc_sync+0x24>
    for(;;)
    80006ea8:	a001                	j	80006ea8 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006eaa:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006eae:	0207f793          	andi	a5,a5,32
    80006eb2:	dfe5                	beqz	a5,80006eaa <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006eb4:	0ff4f513          	zext.b	a0,s1
    80006eb8:	100007b7          	lui	a5,0x10000
    80006ebc:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006ec0:	00000097          	auipc	ra,0x0
    80006ec4:	2a6080e7          	jalr	678(ra) # 80007166 <pop_off>
}
    80006ec8:	60e2                	ld	ra,24(sp)
    80006eca:	6442                	ld	s0,16(sp)
    80006ecc:	64a2                	ld	s1,8(sp)
    80006ece:	6105                	addi	sp,sp,32
    80006ed0:	8082                	ret

0000000080006ed2 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006ed2:	00003797          	auipc	a5,0x3
    80006ed6:	aa67b783          	ld	a5,-1370(a5) # 80009978 <uart_tx_r>
    80006eda:	00003717          	auipc	a4,0x3
    80006ede:	aa673703          	ld	a4,-1370(a4) # 80009980 <uart_tx_w>
    80006ee2:	06f70a63          	beq	a4,a5,80006f56 <uartstart+0x84>
{
    80006ee6:	7139                	addi	sp,sp,-64
    80006ee8:	fc06                	sd	ra,56(sp)
    80006eea:	f822                	sd	s0,48(sp)
    80006eec:	f426                	sd	s1,40(sp)
    80006eee:	f04a                	sd	s2,32(sp)
    80006ef0:	ec4e                	sd	s3,24(sp)
    80006ef2:	e852                	sd	s4,16(sp)
    80006ef4:	e456                	sd	s5,8(sp)
    80006ef6:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006ef8:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006efc:	0001ca17          	auipc	s4,0x1c
    80006f00:	52ca0a13          	addi	s4,s4,1324 # 80023428 <uart_tx_lock>
    uart_tx_r += 1;
    80006f04:	00003497          	auipc	s1,0x3
    80006f08:	a7448493          	addi	s1,s1,-1420 # 80009978 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006f0c:	00003997          	auipc	s3,0x3
    80006f10:	a7498993          	addi	s3,s3,-1420 # 80009980 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006f14:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006f18:	02077713          	andi	a4,a4,32
    80006f1c:	c705                	beqz	a4,80006f44 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006f1e:	01f7f713          	andi	a4,a5,31
    80006f22:	9752                	add	a4,a4,s4
    80006f24:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80006f28:	0785                	addi	a5,a5,1
    80006f2a:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006f2c:	8526                	mv	a0,s1
    80006f2e:	ffffa097          	auipc	ra,0xffffa
    80006f32:	68a080e7          	jalr	1674(ra) # 800015b8 <wakeup>
    
    WriteReg(THR, c);
    80006f36:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006f3a:	609c                	ld	a5,0(s1)
    80006f3c:	0009b703          	ld	a4,0(s3)
    80006f40:	fcf71ae3          	bne	a4,a5,80006f14 <uartstart+0x42>
  }
}
    80006f44:	70e2                	ld	ra,56(sp)
    80006f46:	7442                	ld	s0,48(sp)
    80006f48:	74a2                	ld	s1,40(sp)
    80006f4a:	7902                	ld	s2,32(sp)
    80006f4c:	69e2                	ld	s3,24(sp)
    80006f4e:	6a42                	ld	s4,16(sp)
    80006f50:	6aa2                	ld	s5,8(sp)
    80006f52:	6121                	addi	sp,sp,64
    80006f54:	8082                	ret
    80006f56:	8082                	ret

0000000080006f58 <uartputc>:
{
    80006f58:	7179                	addi	sp,sp,-48
    80006f5a:	f406                	sd	ra,40(sp)
    80006f5c:	f022                	sd	s0,32(sp)
    80006f5e:	ec26                	sd	s1,24(sp)
    80006f60:	e84a                	sd	s2,16(sp)
    80006f62:	e44e                	sd	s3,8(sp)
    80006f64:	e052                	sd	s4,0(sp)
    80006f66:	1800                	addi	s0,sp,48
    80006f68:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006f6a:	0001c517          	auipc	a0,0x1c
    80006f6e:	4be50513          	addi	a0,a0,1214 # 80023428 <uart_tx_lock>
    80006f72:	00000097          	auipc	ra,0x0
    80006f76:	1a0080e7          	jalr	416(ra) # 80007112 <acquire>
  if(panicked){
    80006f7a:	00003797          	auipc	a5,0x3
    80006f7e:	9f67a783          	lw	a5,-1546(a5) # 80009970 <panicked>
    80006f82:	e7c9                	bnez	a5,8000700c <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006f84:	00003717          	auipc	a4,0x3
    80006f88:	9fc73703          	ld	a4,-1540(a4) # 80009980 <uart_tx_w>
    80006f8c:	00003797          	auipc	a5,0x3
    80006f90:	9ec7b783          	ld	a5,-1556(a5) # 80009978 <uart_tx_r>
    80006f94:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006f98:	0001c997          	auipc	s3,0x1c
    80006f9c:	49098993          	addi	s3,s3,1168 # 80023428 <uart_tx_lock>
    80006fa0:	00003497          	auipc	s1,0x3
    80006fa4:	9d848493          	addi	s1,s1,-1576 # 80009978 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006fa8:	00003917          	auipc	s2,0x3
    80006fac:	9d890913          	addi	s2,s2,-1576 # 80009980 <uart_tx_w>
    80006fb0:	00e79f63          	bne	a5,a4,80006fce <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006fb4:	85ce                	mv	a1,s3
    80006fb6:	8526                	mv	a0,s1
    80006fb8:	ffffa097          	auipc	ra,0xffffa
    80006fbc:	59c080e7          	jalr	1436(ra) # 80001554 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006fc0:	00093703          	ld	a4,0(s2)
    80006fc4:	609c                	ld	a5,0(s1)
    80006fc6:	02078793          	addi	a5,a5,32
    80006fca:	fee785e3          	beq	a5,a4,80006fb4 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006fce:	0001c497          	auipc	s1,0x1c
    80006fd2:	45a48493          	addi	s1,s1,1114 # 80023428 <uart_tx_lock>
    80006fd6:	01f77793          	andi	a5,a4,31
    80006fda:	97a6                	add	a5,a5,s1
    80006fdc:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006fe0:	0705                	addi	a4,a4,1
    80006fe2:	00003797          	auipc	a5,0x3
    80006fe6:	98e7bf23          	sd	a4,-1634(a5) # 80009980 <uart_tx_w>
  uartstart();
    80006fea:	00000097          	auipc	ra,0x0
    80006fee:	ee8080e7          	jalr	-280(ra) # 80006ed2 <uartstart>
  release(&uart_tx_lock);
    80006ff2:	8526                	mv	a0,s1
    80006ff4:	00000097          	auipc	ra,0x0
    80006ff8:	1d2080e7          	jalr	466(ra) # 800071c6 <release>
}
    80006ffc:	70a2                	ld	ra,40(sp)
    80006ffe:	7402                	ld	s0,32(sp)
    80007000:	64e2                	ld	s1,24(sp)
    80007002:	6942                	ld	s2,16(sp)
    80007004:	69a2                	ld	s3,8(sp)
    80007006:	6a02                	ld	s4,0(sp)
    80007008:	6145                	addi	sp,sp,48
    8000700a:	8082                	ret
    for(;;)
    8000700c:	a001                	j	8000700c <uartputc+0xb4>

000000008000700e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000700e:	1141                	addi	sp,sp,-16
    80007010:	e422                	sd	s0,8(sp)
    80007012:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80007014:	100007b7          	lui	a5,0x10000
    80007018:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000701c:	8b85                	andi	a5,a5,1
    8000701e:	cb81                	beqz	a5,8000702e <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80007020:	100007b7          	lui	a5,0x10000
    80007024:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80007028:	6422                	ld	s0,8(sp)
    8000702a:	0141                	addi	sp,sp,16
    8000702c:	8082                	ret
    return -1;
    8000702e:	557d                	li	a0,-1
    80007030:	bfe5                	j	80007028 <uartgetc+0x1a>

0000000080007032 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80007032:	1101                	addi	sp,sp,-32
    80007034:	ec06                	sd	ra,24(sp)
    80007036:	e822                	sd	s0,16(sp)
    80007038:	e426                	sd	s1,8(sp)
    8000703a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000703c:	54fd                	li	s1,-1
    8000703e:	a029                	j	80007048 <uartintr+0x16>
      break;
    consoleintr(c);
    80007040:	00000097          	auipc	ra,0x0
    80007044:	918080e7          	jalr	-1768(ra) # 80006958 <consoleintr>
    int c = uartgetc();
    80007048:	00000097          	auipc	ra,0x0
    8000704c:	fc6080e7          	jalr	-58(ra) # 8000700e <uartgetc>
    if(c == -1)
    80007050:	fe9518e3          	bne	a0,s1,80007040 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80007054:	0001c497          	auipc	s1,0x1c
    80007058:	3d448493          	addi	s1,s1,980 # 80023428 <uart_tx_lock>
    8000705c:	8526                	mv	a0,s1
    8000705e:	00000097          	auipc	ra,0x0
    80007062:	0b4080e7          	jalr	180(ra) # 80007112 <acquire>
  uartstart();
    80007066:	00000097          	auipc	ra,0x0
    8000706a:	e6c080e7          	jalr	-404(ra) # 80006ed2 <uartstart>
  release(&uart_tx_lock);
    8000706e:	8526                	mv	a0,s1
    80007070:	00000097          	auipc	ra,0x0
    80007074:	156080e7          	jalr	342(ra) # 800071c6 <release>
}
    80007078:	60e2                	ld	ra,24(sp)
    8000707a:	6442                	ld	s0,16(sp)
    8000707c:	64a2                	ld	s1,8(sp)
    8000707e:	6105                	addi	sp,sp,32
    80007080:	8082                	ret

0000000080007082 <initlock>:
}
#endif

void
initlock(struct spinlock *lk, char *name)
{
    80007082:	1141                	addi	sp,sp,-16
    80007084:	e422                	sd	s0,8(sp)
    80007086:	0800                	addi	s0,sp,16
  lk->name = name;
    80007088:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000708a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000708e:	00053823          	sd	zero,16(a0)
#ifdef LAB_LOCK
  lk->nts = 0;
  lk->n = 0;
  findslot(lk);
#endif  
}
    80007092:	6422                	ld	s0,8(sp)
    80007094:	0141                	addi	sp,sp,16
    80007096:	8082                	ret

0000000080007098 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80007098:	411c                	lw	a5,0(a0)
    8000709a:	e399                	bnez	a5,800070a0 <holding+0x8>
    8000709c:	4501                	li	a0,0
  return r;
}
    8000709e:	8082                	ret
{
    800070a0:	1101                	addi	sp,sp,-32
    800070a2:	ec06                	sd	ra,24(sp)
    800070a4:	e822                	sd	s0,16(sp)
    800070a6:	e426                	sd	s1,8(sp)
    800070a8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800070aa:	6904                	ld	s1,16(a0)
    800070ac:	ffffa097          	auipc	ra,0xffffa
    800070b0:	de4080e7          	jalr	-540(ra) # 80000e90 <mycpu>
    800070b4:	40a48533          	sub	a0,s1,a0
    800070b8:	00153513          	seqz	a0,a0
}
    800070bc:	60e2                	ld	ra,24(sp)
    800070be:	6442                	ld	s0,16(sp)
    800070c0:	64a2                	ld	s1,8(sp)
    800070c2:	6105                	addi	sp,sp,32
    800070c4:	8082                	ret

00000000800070c6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800070c6:	1101                	addi	sp,sp,-32
    800070c8:	ec06                	sd	ra,24(sp)
    800070ca:	e822                	sd	s0,16(sp)
    800070cc:	e426                	sd	s1,8(sp)
    800070ce:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800070d0:	100024f3          	csrr	s1,sstatus
    800070d4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800070d8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800070da:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800070de:	ffffa097          	auipc	ra,0xffffa
    800070e2:	db2080e7          	jalr	-590(ra) # 80000e90 <mycpu>
    800070e6:	5d3c                	lw	a5,120(a0)
    800070e8:	cf89                	beqz	a5,80007102 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800070ea:	ffffa097          	auipc	ra,0xffffa
    800070ee:	da6080e7          	jalr	-602(ra) # 80000e90 <mycpu>
    800070f2:	5d3c                	lw	a5,120(a0)
    800070f4:	2785                	addiw	a5,a5,1
    800070f6:	dd3c                	sw	a5,120(a0)
}
    800070f8:	60e2                	ld	ra,24(sp)
    800070fa:	6442                	ld	s0,16(sp)
    800070fc:	64a2                	ld	s1,8(sp)
    800070fe:	6105                	addi	sp,sp,32
    80007100:	8082                	ret
    mycpu()->intena = old;
    80007102:	ffffa097          	auipc	ra,0xffffa
    80007106:	d8e080e7          	jalr	-626(ra) # 80000e90 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000710a:	8085                	srli	s1,s1,0x1
    8000710c:	8885                	andi	s1,s1,1
    8000710e:	dd64                	sw	s1,124(a0)
    80007110:	bfe9                	j	800070ea <push_off+0x24>

0000000080007112 <acquire>:
{
    80007112:	1101                	addi	sp,sp,-32
    80007114:	ec06                	sd	ra,24(sp)
    80007116:	e822                	sd	s0,16(sp)
    80007118:	e426                	sd	s1,8(sp)
    8000711a:	1000                	addi	s0,sp,32
    8000711c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000711e:	00000097          	auipc	ra,0x0
    80007122:	fa8080e7          	jalr	-88(ra) # 800070c6 <push_off>
  if(holding(lk))
    80007126:	8526                	mv	a0,s1
    80007128:	00000097          	auipc	ra,0x0
    8000712c:	f70080e7          	jalr	-144(ra) # 80007098 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80007130:	4705                	li	a4,1
  if(holding(lk))
    80007132:	e115                	bnez	a0,80007156 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80007134:	87ba                	mv	a5,a4
    80007136:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000713a:	2781                	sext.w	a5,a5
    8000713c:	ffe5                	bnez	a5,80007134 <acquire+0x22>
  __sync_synchronize();
    8000713e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80007142:	ffffa097          	auipc	ra,0xffffa
    80007146:	d4e080e7          	jalr	-690(ra) # 80000e90 <mycpu>
    8000714a:	e888                	sd	a0,16(s1)
}
    8000714c:	60e2                	ld	ra,24(sp)
    8000714e:	6442                	ld	s0,16(sp)
    80007150:	64a2                	ld	s1,8(sp)
    80007152:	6105                	addi	sp,sp,32
    80007154:	8082                	ret
    panic("acquire");
    80007156:	00002517          	auipc	a0,0x2
    8000715a:	73a50513          	addi	a0,a0,1850 # 80009890 <digits+0x20>
    8000715e:	00000097          	auipc	ra,0x0
    80007162:	a7c080e7          	jalr	-1412(ra) # 80006bda <panic>

0000000080007166 <pop_off>:

void
pop_off(void)
{
    80007166:	1141                	addi	sp,sp,-16
    80007168:	e406                	sd	ra,8(sp)
    8000716a:	e022                	sd	s0,0(sp)
    8000716c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000716e:	ffffa097          	auipc	ra,0xffffa
    80007172:	d22080e7          	jalr	-734(ra) # 80000e90 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80007176:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000717a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000717c:	e78d                	bnez	a5,800071a6 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000717e:	5d3c                	lw	a5,120(a0)
    80007180:	02f05b63          	blez	a5,800071b6 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80007184:	37fd                	addiw	a5,a5,-1
    80007186:	0007871b          	sext.w	a4,a5
    8000718a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000718c:	eb09                	bnez	a4,8000719e <pop_off+0x38>
    8000718e:	5d7c                	lw	a5,124(a0)
    80007190:	c799                	beqz	a5,8000719e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80007192:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80007196:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000719a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000719e:	60a2                	ld	ra,8(sp)
    800071a0:	6402                	ld	s0,0(sp)
    800071a2:	0141                	addi	sp,sp,16
    800071a4:	8082                	ret
    panic("pop_off - interruptible");
    800071a6:	00002517          	auipc	a0,0x2
    800071aa:	6f250513          	addi	a0,a0,1778 # 80009898 <digits+0x28>
    800071ae:	00000097          	auipc	ra,0x0
    800071b2:	a2c080e7          	jalr	-1492(ra) # 80006bda <panic>
    panic("pop_off");
    800071b6:	00002517          	auipc	a0,0x2
    800071ba:	6fa50513          	addi	a0,a0,1786 # 800098b0 <digits+0x40>
    800071be:	00000097          	auipc	ra,0x0
    800071c2:	a1c080e7          	jalr	-1508(ra) # 80006bda <panic>

00000000800071c6 <release>:
{
    800071c6:	1101                	addi	sp,sp,-32
    800071c8:	ec06                	sd	ra,24(sp)
    800071ca:	e822                	sd	s0,16(sp)
    800071cc:	e426                	sd	s1,8(sp)
    800071ce:	1000                	addi	s0,sp,32
    800071d0:	84aa                	mv	s1,a0
  if(!holding(lk))
    800071d2:	00000097          	auipc	ra,0x0
    800071d6:	ec6080e7          	jalr	-314(ra) # 80007098 <holding>
    800071da:	c115                	beqz	a0,800071fe <release+0x38>
  lk->cpu = 0;
    800071dc:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800071e0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800071e4:	0f50000f          	fence	iorw,ow
    800071e8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800071ec:	00000097          	auipc	ra,0x0
    800071f0:	f7a080e7          	jalr	-134(ra) # 80007166 <pop_off>
}
    800071f4:	60e2                	ld	ra,24(sp)
    800071f6:	6442                	ld	s0,16(sp)
    800071f8:	64a2                	ld	s1,8(sp)
    800071fa:	6105                	addi	sp,sp,32
    800071fc:	8082                	ret
    panic("release");
    800071fe:	00002517          	auipc	a0,0x2
    80007202:	6ba50513          	addi	a0,a0,1722 # 800098b8 <digits+0x48>
    80007206:	00000097          	auipc	ra,0x0
    8000720a:	9d4080e7          	jalr	-1580(ra) # 80006bda <panic>

000000008000720e <lockfree_read8>:

// Read a shared 64-bit value without holding a lock
uint64
lockfree_read8(uint64 *addr) {
    8000720e:	1141                	addi	sp,sp,-16
    80007210:	e422                	sd	s0,8(sp)
    80007212:	0800                	addi	s0,sp,16
  uint64 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    80007214:	0ff0000f          	fence
    80007218:	6108                	ld	a0,0(a0)
    8000721a:	0ff0000f          	fence
  return val;
}
    8000721e:	6422                	ld	s0,8(sp)
    80007220:	0141                	addi	sp,sp,16
    80007222:	8082                	ret

0000000080007224 <lockfree_read4>:

// Read a shared 32-bit value without holding a lock
int
lockfree_read4(int *addr) {
    80007224:	1141                	addi	sp,sp,-16
    80007226:	e422                	sd	s0,8(sp)
    80007228:	0800                	addi	s0,sp,16
  uint32 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    8000722a:	0ff0000f          	fence
    8000722e:	4108                	lw	a0,0(a0)
    80007230:	0ff0000f          	fence
  return val;
}
    80007234:	6422                	ld	s0,8(sp)
    80007236:	0141                	addi	sp,sp,16
    80007238:	8082                	ret
	...

0000000080008000 <_trampoline>:
    80008000:	14051073          	csrw	sscratch,a0
    80008004:	02000537          	lui	a0,0x2000
    80008008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000800a:	0536                	slli	a0,a0,0xd
    8000800c:	02153423          	sd	ra,40(a0)
    80008010:	02253823          	sd	sp,48(a0)
    80008014:	02353c23          	sd	gp,56(a0)
    80008018:	04453023          	sd	tp,64(a0)
    8000801c:	04553423          	sd	t0,72(a0)
    80008020:	04653823          	sd	t1,80(a0)
    80008024:	04753c23          	sd	t2,88(a0)
    80008028:	f120                	sd	s0,96(a0)
    8000802a:	f524                	sd	s1,104(a0)
    8000802c:	fd2c                	sd	a1,120(a0)
    8000802e:	e150                	sd	a2,128(a0)
    80008030:	e554                	sd	a3,136(a0)
    80008032:	e958                	sd	a4,144(a0)
    80008034:	ed5c                	sd	a5,152(a0)
    80008036:	0b053023          	sd	a6,160(a0)
    8000803a:	0b153423          	sd	a7,168(a0)
    8000803e:	0b253823          	sd	s2,176(a0)
    80008042:	0b353c23          	sd	s3,184(a0)
    80008046:	0d453023          	sd	s4,192(a0)
    8000804a:	0d553423          	sd	s5,200(a0)
    8000804e:	0d653823          	sd	s6,208(a0)
    80008052:	0d753c23          	sd	s7,216(a0)
    80008056:	0f853023          	sd	s8,224(a0)
    8000805a:	0f953423          	sd	s9,232(a0)
    8000805e:	0fa53823          	sd	s10,240(a0)
    80008062:	0fb53c23          	sd	s11,248(a0)
    80008066:	11c53023          	sd	t3,256(a0)
    8000806a:	11d53423          	sd	t4,264(a0)
    8000806e:	11e53823          	sd	t5,272(a0)
    80008072:	11f53c23          	sd	t6,280(a0)
    80008076:	140022f3          	csrr	t0,sscratch
    8000807a:	06553823          	sd	t0,112(a0)
    8000807e:	00853103          	ld	sp,8(a0)
    80008082:	02053203          	ld	tp,32(a0)
    80008086:	01053283          	ld	t0,16(a0)
    8000808a:	00053303          	ld	t1,0(a0)
    8000808e:	12000073          	sfence.vma
    80008092:	18031073          	csrw	satp,t1
    80008096:	12000073          	sfence.vma
    8000809a:	8282                	jr	t0

000000008000809c <userret>:
    8000809c:	12000073          	sfence.vma
    800080a0:	18051073          	csrw	satp,a0
    800080a4:	12000073          	sfence.vma
    800080a8:	02000537          	lui	a0,0x2000
    800080ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800080ae:	0536                	slli	a0,a0,0xd
    800080b0:	02853083          	ld	ra,40(a0)
    800080b4:	03053103          	ld	sp,48(a0)
    800080b8:	03853183          	ld	gp,56(a0)
    800080bc:	04053203          	ld	tp,64(a0)
    800080c0:	04853283          	ld	t0,72(a0)
    800080c4:	05053303          	ld	t1,80(a0)
    800080c8:	05853383          	ld	t2,88(a0)
    800080cc:	7120                	ld	s0,96(a0)
    800080ce:	7524                	ld	s1,104(a0)
    800080d0:	7d2c                	ld	a1,120(a0)
    800080d2:	6150                	ld	a2,128(a0)
    800080d4:	6554                	ld	a3,136(a0)
    800080d6:	6958                	ld	a4,144(a0)
    800080d8:	6d5c                	ld	a5,152(a0)
    800080da:	0a053803          	ld	a6,160(a0)
    800080de:	0a853883          	ld	a7,168(a0)
    800080e2:	0b053903          	ld	s2,176(a0)
    800080e6:	0b853983          	ld	s3,184(a0)
    800080ea:	0c053a03          	ld	s4,192(a0)
    800080ee:	0c853a83          	ld	s5,200(a0)
    800080f2:	0d053b03          	ld	s6,208(a0)
    800080f6:	0d853b83          	ld	s7,216(a0)
    800080fa:	0e053c03          	ld	s8,224(a0)
    800080fe:	0e853c83          	ld	s9,232(a0)
    80008102:	0f053d03          	ld	s10,240(a0)
    80008106:	0f853d83          	ld	s11,248(a0)
    8000810a:	10053e03          	ld	t3,256(a0)
    8000810e:	10853e83          	ld	t4,264(a0)
    80008112:	11053f03          	ld	t5,272(a0)
    80008116:	11853f83          	ld	t6,280(a0)
    8000811a:	7928                	ld	a0,112(a0)
    8000811c:	10200073          	sret
	...
