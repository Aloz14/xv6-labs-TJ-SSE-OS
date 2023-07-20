
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	90013103          	ld	sp,-1792(sp) # 80008900 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	093050ef          	jal	ra,800058a8 <start>

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
    80000034:	f9078793          	addi	a5,a5,-112 # 80021fc0 <end>
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

    r = (struct run *)pa;

    acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	90090913          	addi	s2,s2,-1792 # 80008950 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	23a080e7          	jalr	570(ra) # 80006294 <acquire>
    r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
    kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
    release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	2da080e7          	jalr	730(ra) # 80006348 <release>
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
    8000008e:	cd2080e7          	jalr	-814(ra) # 80005d5c <panic>

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
    800000f2:	86250513          	addi	a0,a0,-1950 # 80008950 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	10e080e7          	jalr	270(ra) # 80006204 <initlock>
    freerange(end, (void *)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00022517          	auipc	a0,0x22
    80000106:	ebe50513          	addi	a0,a0,-322 # 80021fc0 <end>
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
    80000128:	82c48493          	addi	s1,s1,-2004 # 80008950 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	166080e7          	jalr	358(ra) # 80006294 <acquire>
    r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
    if (r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
        kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	81450513          	addi	a0,a0,-2028 # 80008950 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
    release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	202080e7          	jalr	514(ra) # 80006348 <release>

    if (r)
        memset((char *)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
    return (void *)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
    release(&kmem.lock);
    80000168:	00008517          	auipc	a0,0x8
    8000016c:	7e850513          	addi	a0,a0,2024 # 80008950 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	1d8080e7          	jalr	472(ra) # 80006348 <release>
    if (r)
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
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdd041>
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
    8000032c:	be4080e7          	jalr	-1052(ra) # 80000f0c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000330:	00008717          	auipc	a4,0x8
    80000334:	5f070713          	addi	a4,a4,1520 # 80008920 <started>
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
    80000348:	bc8080e7          	jalr	-1080(ra) # 80000f0c <cpuid>
    8000034c:	85aa                	mv	a1,a0
    8000034e:	00008517          	auipc	a0,0x8
    80000352:	cea50513          	addi	a0,a0,-790 # 80008038 <etext+0x38>
    80000356:	00006097          	auipc	ra,0x6
    8000035a:	a50080e7          	jalr	-1456(ra) # 80005da6 <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00002097          	auipc	ra,0x2
    8000036a:	92c080e7          	jalr	-1748(ra) # 80001c92 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	ef2080e7          	jalr	-270(ra) # 80005260 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	174080e7          	jalr	372(ra) # 800014ea <scheduler>
    consoleinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	8ee080e7          	jalr	-1810(ra) # 80005c6c <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	c00080e7          	jalr	-1024(ra) # 80005f86 <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	a10080e7          	jalr	-1520(ra) # 80005da6 <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	a00080e7          	jalr	-1536(ra) # 80005da6 <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	9f0080e7          	jalr	-1552(ra) # 80005da6 <printf>
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
    800003da:	a84080e7          	jalr	-1404(ra) # 80000e5a <procinit>
    trapinit();      // trap vectors
    800003de:	00002097          	auipc	ra,0x2
    800003e2:	88c080e7          	jalr	-1908(ra) # 80001c6a <trapinit>
    trapinithart();  // install kernel trap vector
    800003e6:	00002097          	auipc	ra,0x2
    800003ea:	8ac080e7          	jalr	-1876(ra) # 80001c92 <trapinithart>
    plicinit();      // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	e5c080e7          	jalr	-420(ra) # 8000524a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	e6a080e7          	jalr	-406(ra) # 80005260 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	fde080e7          	jalr	-34(ra) # 800023dc <binit>
    iinit();         // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	67e080e7          	jalr	1662(ra) # 80002a84 <iinit>
    fileinit();      // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	624080e7          	jalr	1572(ra) # 80003a32 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	f52080e7          	jalr	-174(ra) # 80005368 <virtio_disk_init>
    userinit();      // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	eae080e7          	jalr	-338(ra) # 800012cc <userinit>
    __sync_synchronize();
    80000426:	0ff0000f          	fence
    started = 1;
    8000042a:	4785                	li	a5,1
    8000042c:	00008717          	auipc	a4,0x8
    80000430:	4ef72a23          	sw	a5,1268(a4) # 80008920 <started>
    80000434:	b789                	j	80000376 <main+0x56>

0000000080000436 <kvminithart>:
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart()
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
    80000444:	4e87b783          	ld	a5,1256(a5) # 80008928 <kernel_pagetable>
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
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc)
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
    if (va >= MAXVA)
    80000478:	57fd                	li	a5,-1
    8000047a:	83e9                	srli	a5,a5,0x1a
    8000047c:	4a79                	li	s4,30
        panic("walk");

    for (int level = 2; level > 0; level--) {
    8000047e:	4b31                	li	s6,12
    if (va >= MAXVA)
    80000480:	04b7f263          	bgeu	a5,a1,800004c4 <walk+0x66>
        panic("walk");
    80000484:	00008517          	auipc	a0,0x8
    80000488:	bcc50513          	addi	a0,a0,-1076 # 80008050 <etext+0x50>
    8000048c:	00006097          	auipc	ra,0x6
    80000490:	8d0080e7          	jalr	-1840(ra) # 80005d5c <panic>
        pte_t *pte = &pagetable[PX(level, va)];
        if (*pte & PTE_V) {
            pagetable = (pagetable_t)PTE2PA(*pte);
        }
        else {
            if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
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
    for (int level = 2; level > 0; level--) {
    800004be:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdd037>
    800004c0:	036a0063          	beq	s4,s6,800004e0 <walk+0x82>
        pte_t *pte = &pagetable[PX(level, va)];
    800004c4:	0149d933          	srl	s2,s3,s4
    800004c8:	1ff97913          	andi	s2,s2,511
    800004cc:	090e                	slli	s2,s2,0x3
    800004ce:	9926                	add	s2,s2,s1
        if (*pte & PTE_V) {
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
uint64 walkaddr(pagetable_t pagetable, uint64 va)
{
    pte_t *pte;
    uint64 pa;

    if (va >= MAXVA)
    80000504:	57fd                	li	a5,-1
    80000506:	83e9                	srli	a5,a5,0x1a
    80000508:	00b7f463          	bgeu	a5,a1,80000510 <walkaddr+0xc>
        return 0;
    8000050c:	4501                	li	a0,0
        return 0;
    if ((*pte & PTE_U) == 0)
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
    if (pte == 0)
    80000522:	c105                	beqz	a0,80000542 <walkaddr+0x3e>
    if ((*pte & PTE_V) == 0)
    80000524:	611c                	ld	a5,0(a0)
    if ((*pte & PTE_U) == 0)
    80000526:	0117f693          	andi	a3,a5,17
    8000052a:	4745                	li	a4,17
        return 0;
    8000052c:	4501                	li	a0,0
    if ((*pte & PTE_U) == 0)
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
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
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

    if (size == 0)
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
        if (*pte & PTE_V)
            panic("mappages: remap");
        *pte = PA2PTE(pa) | perm | PTE_V;
        if (a == last)
            break;
        a += PGSIZE;
    80000578:	6b85                	lui	s7,0x1
    8000057a:	012a04b3          	add	s1,s4,s2
        if ((pte = walk(pagetable, a, 1)) == 0)
    8000057e:	4605                	li	a2,1
    80000580:	85ca                	mv	a1,s2
    80000582:	8556                	mv	a0,s5
    80000584:	00000097          	auipc	ra,0x0
    80000588:	eda080e7          	jalr	-294(ra) # 8000045e <walk>
    8000058c:	cd1d                	beqz	a0,800005ca <mappages+0x84>
        if (*pte & PTE_V)
    8000058e:	611c                	ld	a5,0(a0)
    80000590:	8b85                	andi	a5,a5,1
    80000592:	e785                	bnez	a5,800005ba <mappages+0x74>
        *pte = PA2PTE(pa) | perm | PTE_V;
    80000594:	80b1                	srli	s1,s1,0xc
    80000596:	04aa                	slli	s1,s1,0xa
    80000598:	0164e4b3          	or	s1,s1,s6
    8000059c:	0014e493          	ori	s1,s1,1
    800005a0:	e104                	sd	s1,0(a0)
        if (a == last)
    800005a2:	05390063          	beq	s2,s3,800005e2 <mappages+0x9c>
        a += PGSIZE;
    800005a6:	995e                	add	s2,s2,s7
        if ((pte = walk(pagetable, a, 1)) == 0)
    800005a8:	bfc9                	j	8000057a <mappages+0x34>
        panic("mappages: size");
    800005aa:	00008517          	auipc	a0,0x8
    800005ae:	aae50513          	addi	a0,a0,-1362 # 80008058 <etext+0x58>
    800005b2:	00005097          	auipc	ra,0x5
    800005b6:	7aa080e7          	jalr	1962(ra) # 80005d5c <panic>
            panic("mappages: remap");
    800005ba:	00008517          	auipc	a0,0x8
    800005be:	aae50513          	addi	a0,a0,-1362 # 80008068 <etext+0x68>
    800005c2:	00005097          	auipc	ra,0x5
    800005c6:	79a080e7          	jalr	1946(ra) # 80005d5c <panic>
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
    if (mappages(kpgtbl, va, sz, pa, perm) != 0)
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
    80000612:	74e080e7          	jalr	1870(ra) # 80005d5c <panic>

0000000080000616 <kvmmake>:
{
    80000616:	1101                	addi	sp,sp,-32
    80000618:	ec06                	sd	ra,24(sp)
    8000061a:	e822                	sd	s0,16(sp)
    8000061c:	e426                	sd	s1,8(sp)
    8000061e:	e04a                	sd	s2,0(sp)
    80000620:	1000                	addi	s0,sp,32
    kpgtbl = (pagetable_t)kalloc();
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
    kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
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
    kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext, PTE_R | PTE_W);
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
    800006da:	6f0080e7          	jalr	1776(ra) # 80000dc6 <proc_mapstacks>
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
    80000700:	22a7b623          	sd	a0,556(a5) # 80008928 <kernel_pagetable>
}
    80000704:	60a2                	ld	ra,8(sp)
    80000706:	6402                	ld	s0,0(sp)
    80000708:	0141                	addi	sp,sp,16
    8000070a:	8082                	ret

000000008000070c <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
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

    if ((va % PGSIZE) != 0)
    80000722:	03459793          	slli	a5,a1,0x34
    80000726:	e795                	bnez	a5,80000752 <uvmunmap+0x46>
    80000728:	8a2a                	mv	s4,a0
    8000072a:	892e                	mv	s2,a1
    8000072c:	8ab6                	mv	s5,a3
        panic("uvmunmap: not aligned");

    for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8000072e:	0632                	slli	a2,a2,0xc
    80000730:	00b609b3          	add	s3,a2,a1
        if ((pte = walk(pagetable, a, 0)) == 0)
            panic("uvmunmap: walk");
        if ((*pte & PTE_V) == 0)
            panic("uvmunmap: not mapped");
        if (PTE_FLAGS(*pte) == PTE_V)
    80000734:	4b85                	li	s7,1
    for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80000736:	6b05                	lui	s6,0x1
    80000738:	0735e263          	bltu	a1,s3,8000079c <uvmunmap+0x90>
            uint64 pa = PTE2PA(*pte);
            kfree((void *)pa);
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
    8000075e:	602080e7          	jalr	1538(ra) # 80005d5c <panic>
            panic("uvmunmap: walk");
    80000762:	00008517          	auipc	a0,0x8
    80000766:	93650513          	addi	a0,a0,-1738 # 80008098 <etext+0x98>
    8000076a:	00005097          	auipc	ra,0x5
    8000076e:	5f2080e7          	jalr	1522(ra) # 80005d5c <panic>
            panic("uvmunmap: not mapped");
    80000772:	00008517          	auipc	a0,0x8
    80000776:	93650513          	addi	a0,a0,-1738 # 800080a8 <etext+0xa8>
    8000077a:	00005097          	auipc	ra,0x5
    8000077e:	5e2080e7          	jalr	1506(ra) # 80005d5c <panic>
            panic("uvmunmap: not a leaf");
    80000782:	00008517          	auipc	a0,0x8
    80000786:	93e50513          	addi	a0,a0,-1730 # 800080c0 <etext+0xc0>
    8000078a:	00005097          	auipc	ra,0x5
    8000078e:	5d2080e7          	jalr	1490(ra) # 80005d5c <panic>
        *pte = 0;
    80000792:	0004b023          	sd	zero,0(s1)
    for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80000796:	995a                	add	s2,s2,s6
    80000798:	fb3972e3          	bgeu	s2,s3,8000073c <uvmunmap+0x30>
        if ((pte = walk(pagetable, a, 0)) == 0)
    8000079c:	4601                	li	a2,0
    8000079e:	85ca                	mv	a1,s2
    800007a0:	8552                	mv	a0,s4
    800007a2:	00000097          	auipc	ra,0x0
    800007a6:	cbc080e7          	jalr	-836(ra) # 8000045e <walk>
    800007aa:	84aa                	mv	s1,a0
    800007ac:	d95d                	beqz	a0,80000762 <uvmunmap+0x56>
        if ((*pte & PTE_V) == 0)
    800007ae:	6108                	ld	a0,0(a0)
    800007b0:	00157793          	andi	a5,a0,1
    800007b4:	dfdd                	beqz	a5,80000772 <uvmunmap+0x66>
        if (PTE_FLAGS(*pte) == PTE_V)
    800007b6:	3ff57793          	andi	a5,a0,1023
    800007ba:	fd7784e3          	beq	a5,s7,80000782 <uvmunmap+0x76>
        if (do_free) {
    800007be:	fc0a8ae3          	beqz	s5,80000792 <uvmunmap+0x86>
            uint64 pa = PTE2PA(*pte);
    800007c2:	8129                	srli	a0,a0,0xa
            kfree((void *)pa);
    800007c4:	0532                	slli	a0,a0,0xc
    800007c6:	00000097          	auipc	ra,0x0
    800007ca:	856080e7          	jalr	-1962(ra) # 8000001c <kfree>
    800007ce:	b7d1                	j	80000792 <uvmunmap+0x86>

00000000800007d0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t uvmcreate()
{
    800007d0:	1101                	addi	sp,sp,-32
    800007d2:	ec06                	sd	ra,24(sp)
    800007d4:	e822                	sd	s0,16(sp)
    800007d6:	e426                	sd	s1,8(sp)
    800007d8:	1000                	addi	s0,sp,32
    pagetable_t pagetable;
    pagetable = (pagetable_t)kalloc();
    800007da:	00000097          	auipc	ra,0x0
    800007de:	940080e7          	jalr	-1728(ra) # 8000011a <kalloc>
    800007e2:	84aa                	mv	s1,a0
    if (pagetable == 0)
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
void uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
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

    if (sz >= PGSIZE)
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
    mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
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
    8000086c:	4f4080e7          	jalr	1268(ra) # 80005d5c <panic>

0000000080000870 <uvmdealloc>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64 uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000870:	1101                	addi	sp,sp,-32
    80000872:	ec06                	sd	ra,24(sp)
    80000874:	e822                	sd	s0,16(sp)
    80000876:	e426                	sd	s1,8(sp)
    80000878:	1000                	addi	s0,sp,32
    if (newsz >= oldsz)
        return oldsz;
    8000087a:	84ae                	mv	s1,a1
    if (newsz >= oldsz)
    8000087c:	00b67d63          	bgeu	a2,a1,80000896 <uvmdealloc+0x26>
    80000880:	84b2                	mv	s1,a2

    if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
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
    if (newsz < oldsz)
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
    for (a = oldsz; a < newsz; a += PGSIZE) {
    800008e0:	08c9f363          	bgeu	s3,a2,80000966 <uvmalloc+0xae>
    800008e4:	894e                	mv	s2,s3
        if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) != 0) {
    800008e6:	0126eb13          	ori	s6,a3,18
        mem = kalloc();
    800008ea:	00000097          	auipc	ra,0x0
    800008ee:	830080e7          	jalr	-2000(ra) # 8000011a <kalloc>
    800008f2:	84aa                	mv	s1,a0
        if (mem == 0) {
    800008f4:	c51d                	beqz	a0,80000922 <uvmalloc+0x6a>
        memset(mem, 0, PGSIZE);
    800008f6:	6605                	lui	a2,0x1
    800008f8:	4581                	li	a1,0
    800008fa:	00000097          	auipc	ra,0x0
    800008fe:	880080e7          	jalr	-1920(ra) # 8000017a <memset>
        if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) != 0) {
    80000902:	875a                	mv	a4,s6
    80000904:	86a6                	mv	a3,s1
    80000906:	6605                	lui	a2,0x1
    80000908:	85ca                	mv	a1,s2
    8000090a:	8556                	mv	a0,s5
    8000090c:	00000097          	auipc	ra,0x0
    80000910:	c3a080e7          	jalr	-966(ra) # 80000546 <mappages>
    80000914:	e90d                	bnez	a0,80000946 <uvmalloc+0x8e>
    for (a = oldsz; a < newsz; a += PGSIZE) {
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
void freewalk(pagetable_t pagetable)
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
    for (int i = 0; i < 512; i++) {
    8000097c:	84aa                	mv	s1,a0
    8000097e:	6905                	lui	s2,0x1
    80000980:	992a                	add	s2,s2,a0
        pte_t pte = pagetable[i];
        if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
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
    for (int i = 0; i < 512; i++) {
    80000998:	04a1                	addi	s1,s1,8
    8000099a:	03248163          	beq	s1,s2,800009bc <freewalk+0x52>
        pte_t pte = pagetable[i];
    8000099e:	609c                	ld	a5,0(s1)
        if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    800009a0:	00f7f713          	andi	a4,a5,15
    800009a4:	ff3701e3          	beq	a4,s3,80000986 <freewalk+0x1c>
        }
        else if (pte & PTE_V) {
    800009a8:	8b85                	andi	a5,a5,1
    800009aa:	d7fd                	beqz	a5,80000998 <freewalk+0x2e>
            panic("freewalk: leaf");
    800009ac:	00007517          	auipc	a0,0x7
    800009b0:	74c50513          	addi	a0,a0,1868 # 800080f8 <etext+0xf8>
    800009b4:	00005097          	auipc	ra,0x5
    800009b8:	3a8080e7          	jalr	936(ra) # 80005d5c <panic>
        }
    }
    kfree((void *)pagetable);
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
void uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009d6:	1101                	addi	sp,sp,-32
    800009d8:	ec06                	sd	ra,24(sp)
    800009da:	e822                	sd	s0,16(sp)
    800009dc:	e426                	sd	s1,8(sp)
    800009de:	1000                	addi	s0,sp,32
    800009e0:	84aa                	mv	s1,a0
    if (sz > 0)
    800009e2:	e999                	bnez	a1,800009f8 <uvmfree+0x22>
        uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
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
        uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
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

    for (i = 0; i < sz; i += PGSIZE) {
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
    for (i = 0; i < sz; i += PGSIZE) {
    80000a2e:	4981                	li	s3,0
        if ((pte = walk(old, i, 0)) == 0)
    80000a30:	4601                	li	a2,0
    80000a32:	85ce                	mv	a1,s3
    80000a34:	855a                	mv	a0,s6
    80000a36:	00000097          	auipc	ra,0x0
    80000a3a:	a28080e7          	jalr	-1496(ra) # 8000045e <walk>
    80000a3e:	c531                	beqz	a0,80000a8a <uvmcopy+0x7a>
            panic("uvmcopy: pte should exist");
        if ((*pte & PTE_V) == 0)
    80000a40:	6118                	ld	a4,0(a0)
    80000a42:	00177793          	andi	a5,a4,1
    80000a46:	cbb1                	beqz	a5,80000a9a <uvmcopy+0x8a>
            panic("uvmcopy: page not present");
        pa = PTE2PA(*pte);
    80000a48:	00a75593          	srli	a1,a4,0xa
    80000a4c:	00c59b93          	slli	s7,a1,0xc
        flags = PTE_FLAGS(*pte);
    80000a50:	3ff77493          	andi	s1,a4,1023
        if ((mem = kalloc()) == 0)
    80000a54:	fffff097          	auipc	ra,0xfffff
    80000a58:	6c6080e7          	jalr	1734(ra) # 8000011a <kalloc>
    80000a5c:	892a                	mv	s2,a0
    80000a5e:	c939                	beqz	a0,80000ab4 <uvmcopy+0xa4>
            goto err;
        memmove(mem, (char *)pa, PGSIZE);
    80000a60:	6605                	lui	a2,0x1
    80000a62:	85de                	mv	a1,s7
    80000a64:	fffff097          	auipc	ra,0xfffff
    80000a68:	772080e7          	jalr	1906(ra) # 800001d6 <memmove>
        if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    80000a6c:	8726                	mv	a4,s1
    80000a6e:	86ca                	mv	a3,s2
    80000a70:	6605                	lui	a2,0x1
    80000a72:	85ce                	mv	a1,s3
    80000a74:	8556                	mv	a0,s5
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	ad0080e7          	jalr	-1328(ra) # 80000546 <mappages>
    80000a7e:	e515                	bnez	a0,80000aaa <uvmcopy+0x9a>
    for (i = 0; i < sz; i += PGSIZE) {
    80000a80:	6785                	lui	a5,0x1
    80000a82:	99be                	add	s3,s3,a5
    80000a84:	fb49e6e3          	bltu	s3,s4,80000a30 <uvmcopy+0x20>
    80000a88:	a081                	j	80000ac8 <uvmcopy+0xb8>
            panic("uvmcopy: pte should exist");
    80000a8a:	00007517          	auipc	a0,0x7
    80000a8e:	67e50513          	addi	a0,a0,1662 # 80008108 <etext+0x108>
    80000a92:	00005097          	auipc	ra,0x5
    80000a96:	2ca080e7          	jalr	714(ra) # 80005d5c <panic>
            panic("uvmcopy: page not present");
    80000a9a:	00007517          	auipc	a0,0x7
    80000a9e:	68e50513          	addi	a0,a0,1678 # 80008128 <etext+0x128>
    80000aa2:	00005097          	auipc	ra,0x5
    80000aa6:	2ba080e7          	jalr	698(ra) # 80005d5c <panic>
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
void uvmclear(pagetable_t pagetable, uint64 va)
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
    if (pte == 0)
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
    80000b10:	250080e7          	jalr	592(ra) # 80005d5c <panic>

0000000080000b14 <copyout>:
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
    uint64 n, va0, pa0;

    while (len > 0) {
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
        if (pa0 == 0)
            return -1;
        n = PGSIZE - (dstva - va0);
    80000b38:	6a85                	lui	s5,0x1
    80000b3a:	a015                	j	80000b5e <copyout+0x4a>
        if (n > len)
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
    while (len > 0) {
    80000b5a:	02098263          	beqz	s3,80000b7e <copyout+0x6a>
        va0 = PGROUNDDOWN(dstva);
    80000b5e:	017c7933          	and	s2,s8,s7
        pa0 = walkaddr(pagetable, va0);
    80000b62:	85ca                	mv	a1,s2
    80000b64:	855a                	mv	a0,s6
    80000b66:	00000097          	auipc	ra,0x0
    80000b6a:	99e080e7          	jalr	-1634(ra) # 80000504 <walkaddr>
        if (pa0 == 0)
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
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
    uint64 n, va0, pa0;

    while (len > 0) {
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
        if (pa0 == 0)
            return -1;
        n = PGSIZE - (srcva - va0);
    80000bc4:	6a85                	lui	s5,0x1
    80000bc6:	a01d                	j	80000bec <copyin+0x4c>
        if (n > len)
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
    while (len > 0) {
    80000be8:	02098263          	beqz	s3,80000c0c <copyin+0x6c>
        va0 = PGROUNDDOWN(srcva);
    80000bec:	017c7933          	and	s2,s8,s7
        pa0 = walkaddr(pagetable, va0);
    80000bf0:	85ca                	mv	a1,s2
    80000bf2:	855a                	mv	a0,s6
    80000bf4:	00000097          	auipc	ra,0x0
    80000bf8:	910080e7          	jalr	-1776(ra) # 80000504 <walkaddr>
        if (pa0 == 0)
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
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    uint64 n, va0, pa0;
    int got_null = 0;

    while (got_null == 0 && max > 0) {
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
        if (pa0 == 0)
            return -1;
        n = PGSIZE - (srcva - va0);
    80000c50:	6985                	lui	s3,0x1
    80000c52:	a02d                	j	80000c7c <copyinstr+0x4e>
            n = max;

        char *p = (char *)(pa0 + (srcva - va0));
        while (n > 0) {
            if (*p == '\0') {
                *dst = '\0';
    80000c54:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c58:	4785                	li	a5,1
            dst++;
        }

        srcva = va0 + PGSIZE;
    }
    if (got_null) {
    80000c5a:	37fd                	addiw	a5,a5,-1
    80000c5c:	0007851b          	sext.w	a0,a5
        return 0;
    }
    else {
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
    while (got_null == 0 && max > 0) {
    80000c7a:	c8a9                	beqz	s1,80000ccc <copyinstr+0x9e>
        va0 = PGROUNDDOWN(srcva);
    80000c7c:	015bf933          	and	s2,s7,s5
        pa0 = walkaddr(pagetable, va0);
    80000c80:	85ca                	mv	a1,s2
    80000c82:	8552                	mv	a0,s4
    80000c84:	00000097          	auipc	ra,0x0
    80000c88:	880080e7          	jalr	-1920(ra) # 80000504 <walkaddr>
        if (pa0 == 0)
    80000c8c:	c131                	beqz	a0,80000cd0 <copyinstr+0xa2>
        n = PGSIZE - (srcva - va0);
    80000c8e:	417906b3          	sub	a3,s2,s7
    80000c92:	96ce                	add	a3,a3,s3
    80000c94:	00d4f363          	bgeu	s1,a3,80000c9a <copyinstr+0x6c>
    80000c98:	86a6                	mv	a3,s1
        char *p = (char *)(pa0 + (srcva - va0));
    80000c9a:	955e                	add	a0,a0,s7
    80000c9c:	41250533          	sub	a0,a0,s2
        while (n > 0) {
    80000ca0:	daf9                	beqz	a3,80000c76 <copyinstr+0x48>
    80000ca2:	87da                	mv	a5,s6
            if (*p == '\0') {
    80000ca4:	41650633          	sub	a2,a0,s6
    80000ca8:	fff48593          	addi	a1,s1,-1
    80000cac:	95da                	add	a1,a1,s6
        while (n > 0) {
    80000cae:	96da                	add	a3,a3,s6
            if (*p == '\0') {
    80000cb0:	00f60733          	add	a4,a2,a5
    80000cb4:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdd040>
    80000cb8:	df51                	beqz	a4,80000c54 <copyinstr+0x26>
                *dst = *p;
    80000cba:	00e78023          	sb	a4,0(a5)
            --max;
    80000cbe:	40f584b3          	sub	s1,a1,a5
            dst++;
    80000cc2:	0785                	addi	a5,a5,1
        while (n > 0) {
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
    if (got_null) {
    80000cd6:	37fd                	addiw	a5,a5,-1
    80000cd8:	0007851b          	sext.w	a0,a5
}
    80000cdc:	8082                	ret

0000000080000cde <vmprint>:

void vmprint(pagetable_t pgtbl, int level)
{
    80000cde:	7119                	addi	sp,sp,-128
    80000ce0:	fc86                	sd	ra,120(sp)
    80000ce2:	f8a2                	sd	s0,112(sp)
    80000ce4:	f4a6                	sd	s1,104(sp)
    80000ce6:	f0ca                	sd	s2,96(sp)
    80000ce8:	ecce                	sd	s3,88(sp)
    80000cea:	e8d2                	sd	s4,80(sp)
    80000cec:	e4d6                	sd	s5,72(sp)
    80000cee:	e0da                	sd	s6,64(sp)
    80000cf0:	fc5e                	sd	s7,56(sp)
    80000cf2:	f862                	sd	s8,48(sp)
    80000cf4:	f466                	sd	s9,40(sp)
    80000cf6:	f06a                	sd	s10,32(sp)
    80000cf8:	ec6e                	sd	s11,24(sp)
    80000cfa:	0100                	addi	s0,sp,128
    80000cfc:	892e                	mv	s2,a1
    // there are 2^9 = 512 PTEs in a page table.
    for (int i = 0; i < 512; i++) {
    80000cfe:	8b2a                	mv	s6,a0
    80000d00:	4a01                	li	s4,0

        pte_t pte = pgtbl[i];
        if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000d02:	4c05                	li	s8,1
        else if (pte & PTE_V) {
            uint64 child = PTE2PA(pte);
            for (int j = 0; j < level; j++) {
                printf("..");
            }
            printf("%d: pte %p pa %p\n", i, pte, child);
    80000d04:	00007d97          	auipc	s11,0x7
    80000d08:	45cd8d93          	addi	s11,s11,1116 # 80008160 <etext+0x160>
            for (int j = 0; j < level; j++) {
    80000d0c:	4d01                	li	s10,0
                printf("..");
    80000d0e:	00007a97          	auipc	s5,0x7
    80000d12:	44aa8a93          	addi	s5,s5,1098 # 80008158 <etext+0x158>
            vmprint((pagetable_t)child, level + 1);
    80000d16:	0015879b          	addiw	a5,a1,1
    80000d1a:	f8f43423          	sd	a5,-120(s0)
    for (int i = 0; i < 512; i++) {
    80000d1e:	20000b93          	li	s7,512
    80000d22:	a899                	j	80000d78 <vmprint+0x9a>
            for (int j = 0; j < level; j++) {
    80000d24:	01205b63          	blez	s2,80000d3a <vmprint+0x5c>
    80000d28:	84ea                	mv	s1,s10
                printf("..");
    80000d2a:	8556                	mv	a0,s5
    80000d2c:	00005097          	auipc	ra,0x5
    80000d30:	07a080e7          	jalr	122(ra) # 80005da6 <printf>
            for (int j = 0; j < level; j++) {
    80000d34:	2485                	addiw	s1,s1,1
    80000d36:	fe991ae3          	bne	s2,s1,80000d2a <vmprint+0x4c>
            uint64 child = PTE2PA(pte);
    80000d3a:	00a9d493          	srli	s1,s3,0xa
    80000d3e:	04b2                	slli	s1,s1,0xc
            printf("%d: pte %p pa %p\n", i, pte, child);
    80000d40:	86a6                	mv	a3,s1
    80000d42:	864e                	mv	a2,s3
    80000d44:	85d2                	mv	a1,s4
    80000d46:	856e                	mv	a0,s11
    80000d48:	00005097          	auipc	ra,0x5
    80000d4c:	05e080e7          	jalr	94(ra) # 80005da6 <printf>
            vmprint((pagetable_t)child, level + 1);
    80000d50:	f8843583          	ld	a1,-120(s0)
    80000d54:	8526                	mv	a0,s1
    80000d56:	00000097          	auipc	ra,0x0
    80000d5a:	f88080e7          	jalr	-120(ra) # 80000cde <vmprint>
    80000d5e:	a809                	j	80000d70 <vmprint+0x92>
            printf("%d: pte %p pa %p\n", i, pte, child);
    80000d60:	86e6                	mv	a3,s9
    80000d62:	864e                	mv	a2,s3
    80000d64:	85d2                	mv	a1,s4
    80000d66:	856e                	mv	a0,s11
    80000d68:	00005097          	auipc	ra,0x5
    80000d6c:	03e080e7          	jalr	62(ra) # 80005da6 <printf>
    for (int i = 0; i < 512; i++) {
    80000d70:	2a05                	addiw	s4,s4,1
    80000d72:	0b21                	addi	s6,s6,8 # 1008 <_entry-0x7fffeff8>
    80000d74:	037a0a63          	beq	s4,s7,80000da8 <vmprint+0xca>
        pte_t pte = pgtbl[i];
    80000d78:	000b3983          	ld	s3,0(s6)
        if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000d7c:	00f9f793          	andi	a5,s3,15
    80000d80:	fb8782e3          	beq	a5,s8,80000d24 <vmprint+0x46>
        else if (pte & PTE_V) {
    80000d84:	0019f793          	andi	a5,s3,1
    80000d88:	d7e5                	beqz	a5,80000d70 <vmprint+0x92>
            uint64 child = PTE2PA(pte);
    80000d8a:	00a9dc93          	srli	s9,s3,0xa
    80000d8e:	0cb2                	slli	s9,s9,0xc
            for (int j = 0; j < level; j++) {
    80000d90:	fd2058e3          	blez	s2,80000d60 <vmprint+0x82>
    80000d94:	84ea                	mv	s1,s10
                printf("..");
    80000d96:	8556                	mv	a0,s5
    80000d98:	00005097          	auipc	ra,0x5
    80000d9c:	00e080e7          	jalr	14(ra) # 80005da6 <printf>
            for (int j = 0; j < level; j++) {
    80000da0:	2485                	addiw	s1,s1,1
    80000da2:	fe991ae3          	bne	s2,s1,80000d96 <vmprint+0xb8>
    80000da6:	bf6d                	j	80000d60 <vmprint+0x82>
        }
    }
    80000da8:	70e6                	ld	ra,120(sp)
    80000daa:	7446                	ld	s0,112(sp)
    80000dac:	74a6                	ld	s1,104(sp)
    80000dae:	7906                	ld	s2,96(sp)
    80000db0:	69e6                	ld	s3,88(sp)
    80000db2:	6a46                	ld	s4,80(sp)
    80000db4:	6aa6                	ld	s5,72(sp)
    80000db6:	6b06                	ld	s6,64(sp)
    80000db8:	7be2                	ld	s7,56(sp)
    80000dba:	7c42                	ld	s8,48(sp)
    80000dbc:	7ca2                	ld	s9,40(sp)
    80000dbe:	7d02                	ld	s10,32(sp)
    80000dc0:	6de2                	ld	s11,24(sp)
    80000dc2:	6109                	addi	sp,sp,128
    80000dc4:	8082                	ret

0000000080000dc6 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    80000dc6:	7139                	addi	sp,sp,-64
    80000dc8:	fc06                	sd	ra,56(sp)
    80000dca:	f822                	sd	s0,48(sp)
    80000dcc:	f426                	sd	s1,40(sp)
    80000dce:	f04a                	sd	s2,32(sp)
    80000dd0:	ec4e                	sd	s3,24(sp)
    80000dd2:	e852                	sd	s4,16(sp)
    80000dd4:	e456                	sd	s5,8(sp)
    80000dd6:	e05a                	sd	s6,0(sp)
    80000dd8:	0080                	addi	s0,sp,64
    80000dda:	89aa                	mv	s3,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++) {
    80000ddc:	00008497          	auipc	s1,0x8
    80000de0:	fc448493          	addi	s1,s1,-60 # 80008da0 <proc>
        char *pa = kalloc();
        if (pa == 0)
            panic("kalloc");
        uint64 va = KSTACK((int)(p - proc));
    80000de4:	8b26                	mv	s6,s1
    80000de6:	00007a97          	auipc	s5,0x7
    80000dea:	21aa8a93          	addi	s5,s5,538 # 80008000 <etext>
    80000dee:	01000937          	lui	s2,0x1000
    80000df2:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000df4:	093a                	slli	s2,s2,0xe
    for (p = proc; p < &proc[NPROC]; p++) {
    80000df6:	0000ea17          	auipc	s4,0xe
    80000dfa:	baaa0a13          	addi	s4,s4,-1110 # 8000e9a0 <tickslock>
        char *pa = kalloc();
    80000dfe:	fffff097          	auipc	ra,0xfffff
    80000e02:	31c080e7          	jalr	796(ra) # 8000011a <kalloc>
    80000e06:	862a                	mv	a2,a0
        if (pa == 0)
    80000e08:	c129                	beqz	a0,80000e4a <proc_mapstacks+0x84>
        uint64 va = KSTACK((int)(p - proc));
    80000e0a:	416485b3          	sub	a1,s1,s6
    80000e0e:	8591                	srai	a1,a1,0x4
    80000e10:	000ab783          	ld	a5,0(s5)
    80000e14:	02f585b3          	mul	a1,a1,a5
    80000e18:	00d5959b          	slliw	a1,a1,0xd
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e1c:	4719                	li	a4,6
    80000e1e:	6685                	lui	a3,0x1
    80000e20:	40b905b3          	sub	a1,s2,a1
    80000e24:	854e                	mv	a0,s3
    80000e26:	fffff097          	auipc	ra,0xfffff
    80000e2a:	7c0080e7          	jalr	1984(ra) # 800005e6 <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++) {
    80000e2e:	17048493          	addi	s1,s1,368
    80000e32:	fd4496e3          	bne	s1,s4,80000dfe <proc_mapstacks+0x38>
    }
}
    80000e36:	70e2                	ld	ra,56(sp)
    80000e38:	7442                	ld	s0,48(sp)
    80000e3a:	74a2                	ld	s1,40(sp)
    80000e3c:	7902                	ld	s2,32(sp)
    80000e3e:	69e2                	ld	s3,24(sp)
    80000e40:	6a42                	ld	s4,16(sp)
    80000e42:	6aa2                	ld	s5,8(sp)
    80000e44:	6b02                	ld	s6,0(sp)
    80000e46:	6121                	addi	sp,sp,64
    80000e48:	8082                	ret
            panic("kalloc");
    80000e4a:	00007517          	auipc	a0,0x7
    80000e4e:	32e50513          	addi	a0,a0,814 # 80008178 <etext+0x178>
    80000e52:	00005097          	auipc	ra,0x5
    80000e56:	f0a080e7          	jalr	-246(ra) # 80005d5c <panic>

0000000080000e5a <procinit>:

// initialize the proc table.
void procinit(void)
{
    80000e5a:	7139                	addi	sp,sp,-64
    80000e5c:	fc06                	sd	ra,56(sp)
    80000e5e:	f822                	sd	s0,48(sp)
    80000e60:	f426                	sd	s1,40(sp)
    80000e62:	f04a                	sd	s2,32(sp)
    80000e64:	ec4e                	sd	s3,24(sp)
    80000e66:	e852                	sd	s4,16(sp)
    80000e68:	e456                	sd	s5,8(sp)
    80000e6a:	e05a                	sd	s6,0(sp)
    80000e6c:	0080                	addi	s0,sp,64
    struct proc *p;

    initlock(&pid_lock, "nextpid");
    80000e6e:	00007597          	auipc	a1,0x7
    80000e72:	31258593          	addi	a1,a1,786 # 80008180 <etext+0x180>
    80000e76:	00008517          	auipc	a0,0x8
    80000e7a:	afa50513          	addi	a0,a0,-1286 # 80008970 <pid_lock>
    80000e7e:	00005097          	auipc	ra,0x5
    80000e82:	386080e7          	jalr	902(ra) # 80006204 <initlock>
    initlock(&wait_lock, "wait_lock");
    80000e86:	00007597          	auipc	a1,0x7
    80000e8a:	30258593          	addi	a1,a1,770 # 80008188 <etext+0x188>
    80000e8e:	00008517          	auipc	a0,0x8
    80000e92:	afa50513          	addi	a0,a0,-1286 # 80008988 <wait_lock>
    80000e96:	00005097          	auipc	ra,0x5
    80000e9a:	36e080e7          	jalr	878(ra) # 80006204 <initlock>
    for (p = proc; p < &proc[NPROC]; p++) {
    80000e9e:	00008497          	auipc	s1,0x8
    80000ea2:	f0248493          	addi	s1,s1,-254 # 80008da0 <proc>
        initlock(&p->lock, "proc");
    80000ea6:	00007b17          	auipc	s6,0x7
    80000eaa:	2f2b0b13          	addi	s6,s6,754 # 80008198 <etext+0x198>
        p->state = UNUSED;
        p->kstack = KSTACK((int)(p - proc));
    80000eae:	8aa6                	mv	s5,s1
    80000eb0:	00007a17          	auipc	s4,0x7
    80000eb4:	150a0a13          	addi	s4,s4,336 # 80008000 <etext>
    80000eb8:	01000937          	lui	s2,0x1000
    80000ebc:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000ebe:	093a                	slli	s2,s2,0xe
    for (p = proc; p < &proc[NPROC]; p++) {
    80000ec0:	0000e997          	auipc	s3,0xe
    80000ec4:	ae098993          	addi	s3,s3,-1312 # 8000e9a0 <tickslock>
        initlock(&p->lock, "proc");
    80000ec8:	85da                	mv	a1,s6
    80000eca:	8526                	mv	a0,s1
    80000ecc:	00005097          	auipc	ra,0x5
    80000ed0:	338080e7          	jalr	824(ra) # 80006204 <initlock>
        p->state = UNUSED;
    80000ed4:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int)(p - proc));
    80000ed8:	415487b3          	sub	a5,s1,s5
    80000edc:	8791                	srai	a5,a5,0x4
    80000ede:	000a3703          	ld	a4,0(s4)
    80000ee2:	02e787b3          	mul	a5,a5,a4
    80000ee6:	00d7979b          	slliw	a5,a5,0xd
    80000eea:	40f907b3          	sub	a5,s2,a5
    80000eee:	e0bc                	sd	a5,64(s1)
    for (p = proc; p < &proc[NPROC]; p++) {
    80000ef0:	17048493          	addi	s1,s1,368
    80000ef4:	fd349ae3          	bne	s1,s3,80000ec8 <procinit+0x6e>
    }
}
    80000ef8:	70e2                	ld	ra,56(sp)
    80000efa:	7442                	ld	s0,48(sp)
    80000efc:	74a2                	ld	s1,40(sp)
    80000efe:	7902                	ld	s2,32(sp)
    80000f00:	69e2                	ld	s3,24(sp)
    80000f02:	6a42                	ld	s4,16(sp)
    80000f04:	6aa2                	ld	s5,8(sp)
    80000f06:	6b02                	ld	s6,0(sp)
    80000f08:	6121                	addi	sp,sp,64
    80000f0a:	8082                	ret

0000000080000f0c <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80000f0c:	1141                	addi	sp,sp,-16
    80000f0e:	e422                	sd	s0,8(sp)
    80000f10:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f12:	8512                	mv	a0,tp
    int id = r_tp();
    return id;
}
    80000f14:	2501                	sext.w	a0,a0
    80000f16:	6422                	ld	s0,8(sp)
    80000f18:	0141                	addi	sp,sp,16
    80000f1a:	8082                	ret

0000000080000f1c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *mycpu(void)
{
    80000f1c:	1141                	addi	sp,sp,-16
    80000f1e:	e422                	sd	s0,8(sp)
    80000f20:	0800                	addi	s0,sp,16
    80000f22:	8792                	mv	a5,tp
    int id = cpuid();
    struct cpu *c = &cpus[id];
    80000f24:	2781                	sext.w	a5,a5
    80000f26:	079e                	slli	a5,a5,0x7
    return c;
}
    80000f28:	00008517          	auipc	a0,0x8
    80000f2c:	a7850513          	addi	a0,a0,-1416 # 800089a0 <cpus>
    80000f30:	953e                	add	a0,a0,a5
    80000f32:	6422                	ld	s0,8(sp)
    80000f34:	0141                	addi	sp,sp,16
    80000f36:	8082                	ret

0000000080000f38 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *myproc(void)
{
    80000f38:	1101                	addi	sp,sp,-32
    80000f3a:	ec06                	sd	ra,24(sp)
    80000f3c:	e822                	sd	s0,16(sp)
    80000f3e:	e426                	sd	s1,8(sp)
    80000f40:	1000                	addi	s0,sp,32
    push_off();
    80000f42:	00005097          	auipc	ra,0x5
    80000f46:	306080e7          	jalr	774(ra) # 80006248 <push_off>
    80000f4a:	8792                	mv	a5,tp
    struct cpu *c = mycpu();
    struct proc *p = c->proc;
    80000f4c:	2781                	sext.w	a5,a5
    80000f4e:	079e                	slli	a5,a5,0x7
    80000f50:	00008717          	auipc	a4,0x8
    80000f54:	a2070713          	addi	a4,a4,-1504 # 80008970 <pid_lock>
    80000f58:	97ba                	add	a5,a5,a4
    80000f5a:	7b84                	ld	s1,48(a5)
    pop_off();
    80000f5c:	00005097          	auipc	ra,0x5
    80000f60:	38c080e7          	jalr	908(ra) # 800062e8 <pop_off>
    return p;
}
    80000f64:	8526                	mv	a0,s1
    80000f66:	60e2                	ld	ra,24(sp)
    80000f68:	6442                	ld	s0,16(sp)
    80000f6a:	64a2                	ld	s1,8(sp)
    80000f6c:	6105                	addi	sp,sp,32
    80000f6e:	8082                	ret

0000000080000f70 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80000f70:	1141                	addi	sp,sp,-16
    80000f72:	e406                	sd	ra,8(sp)
    80000f74:	e022                	sd	s0,0(sp)
    80000f76:	0800                	addi	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80000f78:	00000097          	auipc	ra,0x0
    80000f7c:	fc0080e7          	jalr	-64(ra) # 80000f38 <myproc>
    80000f80:	00005097          	auipc	ra,0x5
    80000f84:	3c8080e7          	jalr	968(ra) # 80006348 <release>

    if (first) {
    80000f88:	00008797          	auipc	a5,0x8
    80000f8c:	9287a783          	lw	a5,-1752(a5) # 800088b0 <first.1>
    80000f90:	eb89                	bnez	a5,80000fa2 <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80000f92:	00001097          	auipc	ra,0x1
    80000f96:	d18080e7          	jalr	-744(ra) # 80001caa <usertrapret>
}
    80000f9a:	60a2                	ld	ra,8(sp)
    80000f9c:	6402                	ld	s0,0(sp)
    80000f9e:	0141                	addi	sp,sp,16
    80000fa0:	8082                	ret
        first = 0;
    80000fa2:	00008797          	auipc	a5,0x8
    80000fa6:	9007a723          	sw	zero,-1778(a5) # 800088b0 <first.1>
        fsinit(ROOTDEV);
    80000faa:	4505                	li	a0,1
    80000fac:	00002097          	auipc	ra,0x2
    80000fb0:	a58080e7          	jalr	-1448(ra) # 80002a04 <fsinit>
    80000fb4:	bff9                	j	80000f92 <forkret+0x22>

0000000080000fb6 <allocpid>:
{
    80000fb6:	1101                	addi	sp,sp,-32
    80000fb8:	ec06                	sd	ra,24(sp)
    80000fba:	e822                	sd	s0,16(sp)
    80000fbc:	e426                	sd	s1,8(sp)
    80000fbe:	e04a                	sd	s2,0(sp)
    80000fc0:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80000fc2:	00008917          	auipc	s2,0x8
    80000fc6:	9ae90913          	addi	s2,s2,-1618 # 80008970 <pid_lock>
    80000fca:	854a                	mv	a0,s2
    80000fcc:	00005097          	auipc	ra,0x5
    80000fd0:	2c8080e7          	jalr	712(ra) # 80006294 <acquire>
    pid = nextpid;
    80000fd4:	00008797          	auipc	a5,0x8
    80000fd8:	8e078793          	addi	a5,a5,-1824 # 800088b4 <nextpid>
    80000fdc:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80000fde:	0014871b          	addiw	a4,s1,1
    80000fe2:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80000fe4:	854a                	mv	a0,s2
    80000fe6:	00005097          	auipc	ra,0x5
    80000fea:	362080e7          	jalr	866(ra) # 80006348 <release>
}
    80000fee:	8526                	mv	a0,s1
    80000ff0:	60e2                	ld	ra,24(sp)
    80000ff2:	6442                	ld	s0,16(sp)
    80000ff4:	64a2                	ld	s1,8(sp)
    80000ff6:	6902                	ld	s2,0(sp)
    80000ff8:	6105                	addi	sp,sp,32
    80000ffa:	8082                	ret

0000000080000ffc <proc_pagetable>:
{
    80000ffc:	1101                	addi	sp,sp,-32
    80000ffe:	ec06                	sd	ra,24(sp)
    80001000:	e822                	sd	s0,16(sp)
    80001002:	e426                	sd	s1,8(sp)
    80001004:	e04a                	sd	s2,0(sp)
    80001006:	1000                	addi	s0,sp,32
    80001008:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    8000100a:	fffff097          	auipc	ra,0xfffff
    8000100e:	7c6080e7          	jalr	1990(ra) # 800007d0 <uvmcreate>
    80001012:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80001014:	cd39                	beqz	a0,80001072 <proc_pagetable+0x76>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline, PTE_R | PTE_X) < 0) {
    80001016:	4729                	li	a4,10
    80001018:	00006697          	auipc	a3,0x6
    8000101c:	fe868693          	addi	a3,a3,-24 # 80007000 <_trampoline>
    80001020:	6605                	lui	a2,0x1
    80001022:	040005b7          	lui	a1,0x4000
    80001026:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001028:	05b2                	slli	a1,a1,0xc
    8000102a:	fffff097          	auipc	ra,0xfffff
    8000102e:	51c080e7          	jalr	1308(ra) # 80000546 <mappages>
    80001032:	04054763          	bltz	a0,80001080 <proc_pagetable+0x84>
    if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe), PTE_R | PTE_W) < 0) {
    80001036:	4719                	li	a4,6
    80001038:	05893683          	ld	a3,88(s2)
    8000103c:	6605                	lui	a2,0x1
    8000103e:	020005b7          	lui	a1,0x2000
    80001042:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001044:	05b6                	slli	a1,a1,0xd
    80001046:	8526                	mv	a0,s1
    80001048:	fffff097          	auipc	ra,0xfffff
    8000104c:	4fe080e7          	jalr	1278(ra) # 80000546 <mappages>
    80001050:	04054063          	bltz	a0,80001090 <proc_pagetable+0x94>
    if (mappages(pagetable, USYSCALL, PGSIZE, (uint64)(p->usys), PTE_R | PTE_U) < 0) {
    80001054:	4749                	li	a4,18
    80001056:	16893683          	ld	a3,360(s2)
    8000105a:	6605                	lui	a2,0x1
    8000105c:	040005b7          	lui	a1,0x4000
    80001060:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    80001062:	05b2                	slli	a1,a1,0xc
    80001064:	8526                	mv	a0,s1
    80001066:	fffff097          	auipc	ra,0xfffff
    8000106a:	4e0080e7          	jalr	1248(ra) # 80000546 <mappages>
    8000106e:	04054463          	bltz	a0,800010b6 <proc_pagetable+0xba>
}
    80001072:	8526                	mv	a0,s1
    80001074:	60e2                	ld	ra,24(sp)
    80001076:	6442                	ld	s0,16(sp)
    80001078:	64a2                	ld	s1,8(sp)
    8000107a:	6902                	ld	s2,0(sp)
    8000107c:	6105                	addi	sp,sp,32
    8000107e:	8082                	ret
        uvmfree(pagetable, 0);
    80001080:	4581                	li	a1,0
    80001082:	8526                	mv	a0,s1
    80001084:	00000097          	auipc	ra,0x0
    80001088:	952080e7          	jalr	-1710(ra) # 800009d6 <uvmfree>
        return 0;
    8000108c:	4481                	li	s1,0
    8000108e:	b7d5                	j	80001072 <proc_pagetable+0x76>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001090:	4681                	li	a3,0
    80001092:	4605                	li	a2,1
    80001094:	040005b7          	lui	a1,0x4000
    80001098:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000109a:	05b2                	slli	a1,a1,0xc
    8000109c:	8526                	mv	a0,s1
    8000109e:	fffff097          	auipc	ra,0xfffff
    800010a2:	66e080e7          	jalr	1646(ra) # 8000070c <uvmunmap>
        uvmfree(pagetable, 0);
    800010a6:	4581                	li	a1,0
    800010a8:	8526                	mv	a0,s1
    800010aa:	00000097          	auipc	ra,0x0
    800010ae:	92c080e7          	jalr	-1748(ra) # 800009d6 <uvmfree>
        return 0;
    800010b2:	4481                	li	s1,0
    800010b4:	bf7d                	j	80001072 <proc_pagetable+0x76>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010b6:	4681                	li	a3,0
    800010b8:	4605                	li	a2,1
    800010ba:	040005b7          	lui	a1,0x4000
    800010be:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010c0:	05b2                	slli	a1,a1,0xc
    800010c2:	8526                	mv	a0,s1
    800010c4:	fffff097          	auipc	ra,0xfffff
    800010c8:	648080e7          	jalr	1608(ra) # 8000070c <uvmunmap>
        uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010cc:	4681                	li	a3,0
    800010ce:	4605                	li	a2,1
    800010d0:	020005b7          	lui	a1,0x2000
    800010d4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800010d6:	05b6                	slli	a1,a1,0xd
    800010d8:	8526                	mv	a0,s1
    800010da:	fffff097          	auipc	ra,0xfffff
    800010de:	632080e7          	jalr	1586(ra) # 8000070c <uvmunmap>
        uvmfree(pagetable, 0);
    800010e2:	4581                	li	a1,0
    800010e4:	8526                	mv	a0,s1
    800010e6:	00000097          	auipc	ra,0x0
    800010ea:	8f0080e7          	jalr	-1808(ra) # 800009d6 <uvmfree>
        return 0;
    800010ee:	4481                	li	s1,0
    800010f0:	b749                	j	80001072 <proc_pagetable+0x76>

00000000800010f2 <proc_freepagetable>:
{
    800010f2:	7179                	addi	sp,sp,-48
    800010f4:	f406                	sd	ra,40(sp)
    800010f6:	f022                	sd	s0,32(sp)
    800010f8:	ec26                	sd	s1,24(sp)
    800010fa:	e84a                	sd	s2,16(sp)
    800010fc:	e44e                	sd	s3,8(sp)
    800010fe:	1800                	addi	s0,sp,48
    80001100:	84aa                	mv	s1,a0
    80001102:	89ae                	mv	s3,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001104:	4681                	li	a3,0
    80001106:	4605                	li	a2,1
    80001108:	04000937          	lui	s2,0x4000
    8000110c:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001110:	05b2                	slli	a1,a1,0xc
    80001112:	fffff097          	auipc	ra,0xfffff
    80001116:	5fa080e7          	jalr	1530(ra) # 8000070c <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000111a:	4681                	li	a3,0
    8000111c:	4605                	li	a2,1
    8000111e:	020005b7          	lui	a1,0x2000
    80001122:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001124:	05b6                	slli	a1,a1,0xd
    80001126:	8526                	mv	a0,s1
    80001128:	fffff097          	auipc	ra,0xfffff
    8000112c:	5e4080e7          	jalr	1508(ra) # 8000070c <uvmunmap>
    uvmunmap(pagetable, USYSCALL, 1, 0);
    80001130:	4681                	li	a3,0
    80001132:	4605                	li	a2,1
    80001134:	1975                	addi	s2,s2,-3
    80001136:	00c91593          	slli	a1,s2,0xc
    8000113a:	8526                	mv	a0,s1
    8000113c:	fffff097          	auipc	ra,0xfffff
    80001140:	5d0080e7          	jalr	1488(ra) # 8000070c <uvmunmap>
    uvmfree(pagetable, sz);
    80001144:	85ce                	mv	a1,s3
    80001146:	8526                	mv	a0,s1
    80001148:	00000097          	auipc	ra,0x0
    8000114c:	88e080e7          	jalr	-1906(ra) # 800009d6 <uvmfree>
}
    80001150:	70a2                	ld	ra,40(sp)
    80001152:	7402                	ld	s0,32(sp)
    80001154:	64e2                	ld	s1,24(sp)
    80001156:	6942                	ld	s2,16(sp)
    80001158:	69a2                	ld	s3,8(sp)
    8000115a:	6145                	addi	sp,sp,48
    8000115c:	8082                	ret

000000008000115e <freeproc>:
{
    8000115e:	1101                	addi	sp,sp,-32
    80001160:	ec06                	sd	ra,24(sp)
    80001162:	e822                	sd	s0,16(sp)
    80001164:	e426                	sd	s1,8(sp)
    80001166:	1000                	addi	s0,sp,32
    80001168:	84aa                	mv	s1,a0
    if (p->usys) {
    8000116a:	16853503          	ld	a0,360(a0)
    8000116e:	c509                	beqz	a0,80001178 <freeproc+0x1a>
        kfree((void *)p->usys);
    80001170:	fffff097          	auipc	ra,0xfffff
    80001174:	eac080e7          	jalr	-340(ra) # 8000001c <kfree>
    p->usys = 0;
    80001178:	1604b423          	sd	zero,360(s1)
    if (p->trapframe)
    8000117c:	6ca8                	ld	a0,88(s1)
    8000117e:	c509                	beqz	a0,80001188 <freeproc+0x2a>
        kfree((void *)p->trapframe);
    80001180:	fffff097          	auipc	ra,0xfffff
    80001184:	e9c080e7          	jalr	-356(ra) # 8000001c <kfree>
    p->trapframe = 0;
    80001188:	0404bc23          	sd	zero,88(s1)
    if (p->pagetable)
    8000118c:	68a8                	ld	a0,80(s1)
    8000118e:	c511                	beqz	a0,8000119a <freeproc+0x3c>
        proc_freepagetable(p->pagetable, p->sz);
    80001190:	64ac                	ld	a1,72(s1)
    80001192:	00000097          	auipc	ra,0x0
    80001196:	f60080e7          	jalr	-160(ra) # 800010f2 <proc_freepagetable>
    p->pagetable = 0;
    8000119a:	0404b823          	sd	zero,80(s1)
    p->sz = 0;
    8000119e:	0404b423          	sd	zero,72(s1)
    p->pid = 0;
    800011a2:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    800011a6:	0204bc23          	sd	zero,56(s1)
    p->name[0] = 0;
    800011aa:	14048c23          	sb	zero,344(s1)
    p->chan = 0;
    800011ae:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    800011b2:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    800011b6:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    800011ba:	0004ac23          	sw	zero,24(s1)
}
    800011be:	60e2                	ld	ra,24(sp)
    800011c0:	6442                	ld	s0,16(sp)
    800011c2:	64a2                	ld	s1,8(sp)
    800011c4:	6105                	addi	sp,sp,32
    800011c6:	8082                	ret

00000000800011c8 <allocproc>:
{
    800011c8:	1101                	addi	sp,sp,-32
    800011ca:	ec06                	sd	ra,24(sp)
    800011cc:	e822                	sd	s0,16(sp)
    800011ce:	e426                	sd	s1,8(sp)
    800011d0:	e04a                	sd	s2,0(sp)
    800011d2:	1000                	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++) {
    800011d4:	00008497          	auipc	s1,0x8
    800011d8:	bcc48493          	addi	s1,s1,-1076 # 80008da0 <proc>
    800011dc:	0000d917          	auipc	s2,0xd
    800011e0:	7c490913          	addi	s2,s2,1988 # 8000e9a0 <tickslock>
        acquire(&p->lock);
    800011e4:	8526                	mv	a0,s1
    800011e6:	00005097          	auipc	ra,0x5
    800011ea:	0ae080e7          	jalr	174(ra) # 80006294 <acquire>
        if (p->state == UNUSED) {
    800011ee:	4c9c                	lw	a5,24(s1)
    800011f0:	cf81                	beqz	a5,80001208 <allocproc+0x40>
            release(&p->lock);
    800011f2:	8526                	mv	a0,s1
    800011f4:	00005097          	auipc	ra,0x5
    800011f8:	154080e7          	jalr	340(ra) # 80006348 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    800011fc:	17048493          	addi	s1,s1,368
    80001200:	ff2492e3          	bne	s1,s2,800011e4 <allocproc+0x1c>
    return 0;
    80001204:	4481                	li	s1,0
    80001206:	a885                	j	80001276 <allocproc+0xae>
    p->pid = allocpid();
    80001208:	00000097          	auipc	ra,0x0
    8000120c:	dae080e7          	jalr	-594(ra) # 80000fb6 <allocpid>
    80001210:	d888                	sw	a0,48(s1)
    p->state = USED;
    80001212:	4785                	li	a5,1
    80001214:	cc9c                	sw	a5,24(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    80001216:	fffff097          	auipc	ra,0xfffff
    8000121a:	f04080e7          	jalr	-252(ra) # 8000011a <kalloc>
    8000121e:	892a                	mv	s2,a0
    80001220:	eca8                	sd	a0,88(s1)
    80001222:	c12d                	beqz	a0,80001284 <allocproc+0xbc>
    if ((p->usys = (struct usyscall *)kalloc()) == 0) {
    80001224:	fffff097          	auipc	ra,0xfffff
    80001228:	ef6080e7          	jalr	-266(ra) # 8000011a <kalloc>
    8000122c:	892a                	mv	s2,a0
    8000122e:	16a4b423          	sd	a0,360(s1)
    80001232:	c52d                	beqz	a0,8000129c <allocproc+0xd4>
    memmove(p->usys, &p->pid, sizeof(int));
    80001234:	4611                	li	a2,4
    80001236:	03048593          	addi	a1,s1,48
    8000123a:	fffff097          	auipc	ra,0xfffff
    8000123e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
    p->pagetable = proc_pagetable(p);
    80001242:	8526                	mv	a0,s1
    80001244:	00000097          	auipc	ra,0x0
    80001248:	db8080e7          	jalr	-584(ra) # 80000ffc <proc_pagetable>
    8000124c:	892a                	mv	s2,a0
    8000124e:	e8a8                	sd	a0,80(s1)
    if (p->pagetable == 0) {
    80001250:	c135                	beqz	a0,800012b4 <allocproc+0xec>
    memset(&p->context, 0, sizeof(p->context));
    80001252:	07000613          	li	a2,112
    80001256:	4581                	li	a1,0
    80001258:	06048513          	addi	a0,s1,96
    8000125c:	fffff097          	auipc	ra,0xfffff
    80001260:	f1e080e7          	jalr	-226(ra) # 8000017a <memset>
    p->context.ra = (uint64)forkret;
    80001264:	00000797          	auipc	a5,0x0
    80001268:	d0c78793          	addi	a5,a5,-756 # 80000f70 <forkret>
    8000126c:	f0bc                	sd	a5,96(s1)
    p->context.sp = p->kstack + PGSIZE;
    8000126e:	60bc                	ld	a5,64(s1)
    80001270:	6705                	lui	a4,0x1
    80001272:	97ba                	add	a5,a5,a4
    80001274:	f4bc                	sd	a5,104(s1)
}
    80001276:	8526                	mv	a0,s1
    80001278:	60e2                	ld	ra,24(sp)
    8000127a:	6442                	ld	s0,16(sp)
    8000127c:	64a2                	ld	s1,8(sp)
    8000127e:	6902                	ld	s2,0(sp)
    80001280:	6105                	addi	sp,sp,32
    80001282:	8082                	ret
        freeproc(p);
    80001284:	8526                	mv	a0,s1
    80001286:	00000097          	auipc	ra,0x0
    8000128a:	ed8080e7          	jalr	-296(ra) # 8000115e <freeproc>
        release(&p->lock);
    8000128e:	8526                	mv	a0,s1
    80001290:	00005097          	auipc	ra,0x5
    80001294:	0b8080e7          	jalr	184(ra) # 80006348 <release>
        return 0;
    80001298:	84ca                	mv	s1,s2
    8000129a:	bff1                	j	80001276 <allocproc+0xae>
        freeproc(p);
    8000129c:	8526                	mv	a0,s1
    8000129e:	00000097          	auipc	ra,0x0
    800012a2:	ec0080e7          	jalr	-320(ra) # 8000115e <freeproc>
        release(&p->lock);
    800012a6:	8526                	mv	a0,s1
    800012a8:	00005097          	auipc	ra,0x5
    800012ac:	0a0080e7          	jalr	160(ra) # 80006348 <release>
        return 0;
    800012b0:	84ca                	mv	s1,s2
    800012b2:	b7d1                	j	80001276 <allocproc+0xae>
        freeproc(p);
    800012b4:	8526                	mv	a0,s1
    800012b6:	00000097          	auipc	ra,0x0
    800012ba:	ea8080e7          	jalr	-344(ra) # 8000115e <freeproc>
        release(&p->lock);
    800012be:	8526                	mv	a0,s1
    800012c0:	00005097          	auipc	ra,0x5
    800012c4:	088080e7          	jalr	136(ra) # 80006348 <release>
        return 0;
    800012c8:	84ca                	mv	s1,s2
    800012ca:	b775                	j	80001276 <allocproc+0xae>

00000000800012cc <userinit>:
{
    800012cc:	1101                	addi	sp,sp,-32
    800012ce:	ec06                	sd	ra,24(sp)
    800012d0:	e822                	sd	s0,16(sp)
    800012d2:	e426                	sd	s1,8(sp)
    800012d4:	1000                	addi	s0,sp,32
    p = allocproc();
    800012d6:	00000097          	auipc	ra,0x0
    800012da:	ef2080e7          	jalr	-270(ra) # 800011c8 <allocproc>
    800012de:	84aa                	mv	s1,a0
    initproc = p;
    800012e0:	00007797          	auipc	a5,0x7
    800012e4:	64a7b823          	sd	a0,1616(a5) # 80008930 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800012e8:	03400613          	li	a2,52
    800012ec:	00007597          	auipc	a1,0x7
    800012f0:	5d458593          	addi	a1,a1,1492 # 800088c0 <initcode>
    800012f4:	6928                	ld	a0,80(a0)
    800012f6:	fffff097          	auipc	ra,0xfffff
    800012fa:	508080e7          	jalr	1288(ra) # 800007fe <uvmfirst>
    p->sz = PGSIZE;
    800012fe:	6785                	lui	a5,0x1
    80001300:	e4bc                	sd	a5,72(s1)
    p->trapframe->epc = 0;     // user program counter
    80001302:	6cb8                	ld	a4,88(s1)
    80001304:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    80001308:	6cb8                	ld	a4,88(s1)
    8000130a:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    8000130c:	4641                	li	a2,16
    8000130e:	00007597          	auipc	a1,0x7
    80001312:	e9258593          	addi	a1,a1,-366 # 800081a0 <etext+0x1a0>
    80001316:	15848513          	addi	a0,s1,344
    8000131a:	fffff097          	auipc	ra,0xfffff
    8000131e:	faa080e7          	jalr	-86(ra) # 800002c4 <safestrcpy>
    p->cwd = namei("/");
    80001322:	00007517          	auipc	a0,0x7
    80001326:	e8e50513          	addi	a0,a0,-370 # 800081b0 <etext+0x1b0>
    8000132a:	00002097          	auipc	ra,0x2
    8000132e:	104080e7          	jalr	260(ra) # 8000342e <namei>
    80001332:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    80001336:	478d                	li	a5,3
    80001338:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    8000133a:	8526                	mv	a0,s1
    8000133c:	00005097          	auipc	ra,0x5
    80001340:	00c080e7          	jalr	12(ra) # 80006348 <release>
}
    80001344:	60e2                	ld	ra,24(sp)
    80001346:	6442                	ld	s0,16(sp)
    80001348:	64a2                	ld	s1,8(sp)
    8000134a:	6105                	addi	sp,sp,32
    8000134c:	8082                	ret

000000008000134e <growproc>:
{
    8000134e:	1101                	addi	sp,sp,-32
    80001350:	ec06                	sd	ra,24(sp)
    80001352:	e822                	sd	s0,16(sp)
    80001354:	e426                	sd	s1,8(sp)
    80001356:	e04a                	sd	s2,0(sp)
    80001358:	1000                	addi	s0,sp,32
    8000135a:	892a                	mv	s2,a0
    struct proc *p = myproc();
    8000135c:	00000097          	auipc	ra,0x0
    80001360:	bdc080e7          	jalr	-1060(ra) # 80000f38 <myproc>
    80001364:	84aa                	mv	s1,a0
    sz = p->sz;
    80001366:	652c                	ld	a1,72(a0)
    if (n > 0) {
    80001368:	01204c63          	bgtz	s2,80001380 <growproc+0x32>
    else if (n < 0) {
    8000136c:	02094663          	bltz	s2,80001398 <growproc+0x4a>
    p->sz = sz;
    80001370:	e4ac                	sd	a1,72(s1)
    return 0;
    80001372:	4501                	li	a0,0
}
    80001374:	60e2                	ld	ra,24(sp)
    80001376:	6442                	ld	s0,16(sp)
    80001378:	64a2                	ld	s1,8(sp)
    8000137a:	6902                	ld	s2,0(sp)
    8000137c:	6105                	addi	sp,sp,32
    8000137e:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001380:	4691                	li	a3,4
    80001382:	00b90633          	add	a2,s2,a1
    80001386:	6928                	ld	a0,80(a0)
    80001388:	fffff097          	auipc	ra,0xfffff
    8000138c:	530080e7          	jalr	1328(ra) # 800008b8 <uvmalloc>
    80001390:	85aa                	mv	a1,a0
    80001392:	fd79                	bnez	a0,80001370 <growproc+0x22>
            return -1;
    80001394:	557d                	li	a0,-1
    80001396:	bff9                	j	80001374 <growproc+0x26>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001398:	00b90633          	add	a2,s2,a1
    8000139c:	6928                	ld	a0,80(a0)
    8000139e:	fffff097          	auipc	ra,0xfffff
    800013a2:	4d2080e7          	jalr	1234(ra) # 80000870 <uvmdealloc>
    800013a6:	85aa                	mv	a1,a0
    800013a8:	b7e1                	j	80001370 <growproc+0x22>

00000000800013aa <fork>:
{
    800013aa:	7139                	addi	sp,sp,-64
    800013ac:	fc06                	sd	ra,56(sp)
    800013ae:	f822                	sd	s0,48(sp)
    800013b0:	f426                	sd	s1,40(sp)
    800013b2:	f04a                	sd	s2,32(sp)
    800013b4:	ec4e                	sd	s3,24(sp)
    800013b6:	e852                	sd	s4,16(sp)
    800013b8:	e456                	sd	s5,8(sp)
    800013ba:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    800013bc:	00000097          	auipc	ra,0x0
    800013c0:	b7c080e7          	jalr	-1156(ra) # 80000f38 <myproc>
    800013c4:	8aaa                	mv	s5,a0
    if ((np = allocproc()) == 0) {
    800013c6:	00000097          	auipc	ra,0x0
    800013ca:	e02080e7          	jalr	-510(ra) # 800011c8 <allocproc>
    800013ce:	10050c63          	beqz	a0,800014e6 <fork+0x13c>
    800013d2:	8a2a                	mv	s4,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    800013d4:	048ab603          	ld	a2,72(s5)
    800013d8:	692c                	ld	a1,80(a0)
    800013da:	050ab503          	ld	a0,80(s5)
    800013de:	fffff097          	auipc	ra,0xfffff
    800013e2:	632080e7          	jalr	1586(ra) # 80000a10 <uvmcopy>
    800013e6:	04054863          	bltz	a0,80001436 <fork+0x8c>
    np->sz = p->sz;
    800013ea:	048ab783          	ld	a5,72(s5)
    800013ee:	04fa3423          	sd	a5,72(s4)
    *(np->trapframe) = *(p->trapframe);
    800013f2:	058ab683          	ld	a3,88(s5)
    800013f6:	87b6                	mv	a5,a3
    800013f8:	058a3703          	ld	a4,88(s4)
    800013fc:	12068693          	addi	a3,a3,288
    80001400:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001404:	6788                	ld	a0,8(a5)
    80001406:	6b8c                	ld	a1,16(a5)
    80001408:	6f90                	ld	a2,24(a5)
    8000140a:	01073023          	sd	a6,0(a4)
    8000140e:	e708                	sd	a0,8(a4)
    80001410:	eb0c                	sd	a1,16(a4)
    80001412:	ef10                	sd	a2,24(a4)
    80001414:	02078793          	addi	a5,a5,32
    80001418:	02070713          	addi	a4,a4,32
    8000141c:	fed792e3          	bne	a5,a3,80001400 <fork+0x56>
    np->trapframe->a0 = 0;
    80001420:	058a3783          	ld	a5,88(s4)
    80001424:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++)
    80001428:	0d0a8493          	addi	s1,s5,208
    8000142c:	0d0a0913          	addi	s2,s4,208
    80001430:	150a8993          	addi	s3,s5,336
    80001434:	a00d                	j	80001456 <fork+0xac>
        freeproc(np);
    80001436:	8552                	mv	a0,s4
    80001438:	00000097          	auipc	ra,0x0
    8000143c:	d26080e7          	jalr	-730(ra) # 8000115e <freeproc>
        release(&np->lock);
    80001440:	8552                	mv	a0,s4
    80001442:	00005097          	auipc	ra,0x5
    80001446:	f06080e7          	jalr	-250(ra) # 80006348 <release>
        return -1;
    8000144a:	597d                	li	s2,-1
    8000144c:	a059                	j	800014d2 <fork+0x128>
    for (i = 0; i < NOFILE; i++)
    8000144e:	04a1                	addi	s1,s1,8
    80001450:	0921                	addi	s2,s2,8
    80001452:	01348b63          	beq	s1,s3,80001468 <fork+0xbe>
        if (p->ofile[i])
    80001456:	6088                	ld	a0,0(s1)
    80001458:	d97d                	beqz	a0,8000144e <fork+0xa4>
            np->ofile[i] = filedup(p->ofile[i]);
    8000145a:	00002097          	auipc	ra,0x2
    8000145e:	66a080e7          	jalr	1642(ra) # 80003ac4 <filedup>
    80001462:	00a93023          	sd	a0,0(s2)
    80001466:	b7e5                	j	8000144e <fork+0xa4>
    np->cwd = idup(p->cwd);
    80001468:	150ab503          	ld	a0,336(s5)
    8000146c:	00001097          	auipc	ra,0x1
    80001470:	7d8080e7          	jalr	2008(ra) # 80002c44 <idup>
    80001474:	14aa3823          	sd	a0,336(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    80001478:	4641                	li	a2,16
    8000147a:	158a8593          	addi	a1,s5,344
    8000147e:	158a0513          	addi	a0,s4,344
    80001482:	fffff097          	auipc	ra,0xfffff
    80001486:	e42080e7          	jalr	-446(ra) # 800002c4 <safestrcpy>
    pid = np->pid;
    8000148a:	030a2903          	lw	s2,48(s4)
    release(&np->lock);
    8000148e:	8552                	mv	a0,s4
    80001490:	00005097          	auipc	ra,0x5
    80001494:	eb8080e7          	jalr	-328(ra) # 80006348 <release>
    acquire(&wait_lock);
    80001498:	00007497          	auipc	s1,0x7
    8000149c:	4f048493          	addi	s1,s1,1264 # 80008988 <wait_lock>
    800014a0:	8526                	mv	a0,s1
    800014a2:	00005097          	auipc	ra,0x5
    800014a6:	df2080e7          	jalr	-526(ra) # 80006294 <acquire>
    np->parent = p;
    800014aa:	035a3c23          	sd	s5,56(s4)
    release(&wait_lock);
    800014ae:	8526                	mv	a0,s1
    800014b0:	00005097          	auipc	ra,0x5
    800014b4:	e98080e7          	jalr	-360(ra) # 80006348 <release>
    acquire(&np->lock);
    800014b8:	8552                	mv	a0,s4
    800014ba:	00005097          	auipc	ra,0x5
    800014be:	dda080e7          	jalr	-550(ra) # 80006294 <acquire>
    np->state = RUNNABLE;
    800014c2:	478d                	li	a5,3
    800014c4:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    800014c8:	8552                	mv	a0,s4
    800014ca:	00005097          	auipc	ra,0x5
    800014ce:	e7e080e7          	jalr	-386(ra) # 80006348 <release>
}
    800014d2:	854a                	mv	a0,s2
    800014d4:	70e2                	ld	ra,56(sp)
    800014d6:	7442                	ld	s0,48(sp)
    800014d8:	74a2                	ld	s1,40(sp)
    800014da:	7902                	ld	s2,32(sp)
    800014dc:	69e2                	ld	s3,24(sp)
    800014de:	6a42                	ld	s4,16(sp)
    800014e0:	6aa2                	ld	s5,8(sp)
    800014e2:	6121                	addi	sp,sp,64
    800014e4:	8082                	ret
        return -1;
    800014e6:	597d                	li	s2,-1
    800014e8:	b7ed                	j	800014d2 <fork+0x128>

00000000800014ea <scheduler>:
{
    800014ea:	7139                	addi	sp,sp,-64
    800014ec:	fc06                	sd	ra,56(sp)
    800014ee:	f822                	sd	s0,48(sp)
    800014f0:	f426                	sd	s1,40(sp)
    800014f2:	f04a                	sd	s2,32(sp)
    800014f4:	ec4e                	sd	s3,24(sp)
    800014f6:	e852                	sd	s4,16(sp)
    800014f8:	e456                	sd	s5,8(sp)
    800014fa:	e05a                	sd	s6,0(sp)
    800014fc:	0080                	addi	s0,sp,64
    800014fe:	8792                	mv	a5,tp
    int id = r_tp();
    80001500:	2781                	sext.w	a5,a5
    c->proc = 0;
    80001502:	00779a93          	slli	s5,a5,0x7
    80001506:	00007717          	auipc	a4,0x7
    8000150a:	46a70713          	addi	a4,a4,1130 # 80008970 <pid_lock>
    8000150e:	9756                	add	a4,a4,s5
    80001510:	02073823          	sd	zero,48(a4)
                swtch(&c->context, &p->context);
    80001514:	00007717          	auipc	a4,0x7
    80001518:	49470713          	addi	a4,a4,1172 # 800089a8 <cpus+0x8>
    8000151c:	9aba                	add	s5,s5,a4
            if (p->state == RUNNABLE) {
    8000151e:	498d                	li	s3,3
                p->state = RUNNING;
    80001520:	4b11                	li	s6,4
                c->proc = p;
    80001522:	079e                	slli	a5,a5,0x7
    80001524:	00007a17          	auipc	s4,0x7
    80001528:	44ca0a13          	addi	s4,s4,1100 # 80008970 <pid_lock>
    8000152c:	9a3e                	add	s4,s4,a5
        for (p = proc; p < &proc[NPROC]; p++) {
    8000152e:	0000d917          	auipc	s2,0xd
    80001532:	47290913          	addi	s2,s2,1138 # 8000e9a0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001536:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000153a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000153e:	10079073          	csrw	sstatus,a5
    80001542:	00008497          	auipc	s1,0x8
    80001546:	85e48493          	addi	s1,s1,-1954 # 80008da0 <proc>
    8000154a:	a811                	j	8000155e <scheduler+0x74>
            release(&p->lock);
    8000154c:	8526                	mv	a0,s1
    8000154e:	00005097          	auipc	ra,0x5
    80001552:	dfa080e7          	jalr	-518(ra) # 80006348 <release>
        for (p = proc; p < &proc[NPROC]; p++) {
    80001556:	17048493          	addi	s1,s1,368
    8000155a:	fd248ee3          	beq	s1,s2,80001536 <scheduler+0x4c>
            acquire(&p->lock);
    8000155e:	8526                	mv	a0,s1
    80001560:	00005097          	auipc	ra,0x5
    80001564:	d34080e7          	jalr	-716(ra) # 80006294 <acquire>
            if (p->state == RUNNABLE) {
    80001568:	4c9c                	lw	a5,24(s1)
    8000156a:	ff3791e3          	bne	a5,s3,8000154c <scheduler+0x62>
                p->state = RUNNING;
    8000156e:	0164ac23          	sw	s6,24(s1)
                c->proc = p;
    80001572:	029a3823          	sd	s1,48(s4)
                swtch(&c->context, &p->context);
    80001576:	06048593          	addi	a1,s1,96
    8000157a:	8556                	mv	a0,s5
    8000157c:	00000097          	auipc	ra,0x0
    80001580:	684080e7          	jalr	1668(ra) # 80001c00 <swtch>
                c->proc = 0;
    80001584:	020a3823          	sd	zero,48(s4)
    80001588:	b7d1                	j	8000154c <scheduler+0x62>

000000008000158a <sched>:
{
    8000158a:	7179                	addi	sp,sp,-48
    8000158c:	f406                	sd	ra,40(sp)
    8000158e:	f022                	sd	s0,32(sp)
    80001590:	ec26                	sd	s1,24(sp)
    80001592:	e84a                	sd	s2,16(sp)
    80001594:	e44e                	sd	s3,8(sp)
    80001596:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80001598:	00000097          	auipc	ra,0x0
    8000159c:	9a0080e7          	jalr	-1632(ra) # 80000f38 <myproc>
    800015a0:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    800015a2:	00005097          	auipc	ra,0x5
    800015a6:	c78080e7          	jalr	-904(ra) # 8000621a <holding>
    800015aa:	c93d                	beqz	a0,80001620 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015ac:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    800015ae:	2781                	sext.w	a5,a5
    800015b0:	079e                	slli	a5,a5,0x7
    800015b2:	00007717          	auipc	a4,0x7
    800015b6:	3be70713          	addi	a4,a4,958 # 80008970 <pid_lock>
    800015ba:	97ba                	add	a5,a5,a4
    800015bc:	0a87a703          	lw	a4,168(a5)
    800015c0:	4785                	li	a5,1
    800015c2:	06f71763          	bne	a4,a5,80001630 <sched+0xa6>
    if (p->state == RUNNING)
    800015c6:	4c98                	lw	a4,24(s1)
    800015c8:	4791                	li	a5,4
    800015ca:	06f70b63          	beq	a4,a5,80001640 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015ce:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800015d2:	8b89                	andi	a5,a5,2
    if (intr_get())
    800015d4:	efb5                	bnez	a5,80001650 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015d6:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    800015d8:	00007917          	auipc	s2,0x7
    800015dc:	39890913          	addi	s2,s2,920 # 80008970 <pid_lock>
    800015e0:	2781                	sext.w	a5,a5
    800015e2:	079e                	slli	a5,a5,0x7
    800015e4:	97ca                	add	a5,a5,s2
    800015e6:	0ac7a983          	lw	s3,172(a5)
    800015ea:	8792                	mv	a5,tp
    swtch(&p->context, &mycpu()->context);
    800015ec:	2781                	sext.w	a5,a5
    800015ee:	079e                	slli	a5,a5,0x7
    800015f0:	00007597          	auipc	a1,0x7
    800015f4:	3b858593          	addi	a1,a1,952 # 800089a8 <cpus+0x8>
    800015f8:	95be                	add	a1,a1,a5
    800015fa:	06048513          	addi	a0,s1,96
    800015fe:	00000097          	auipc	ra,0x0
    80001602:	602080e7          	jalr	1538(ra) # 80001c00 <swtch>
    80001606:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    80001608:	2781                	sext.w	a5,a5
    8000160a:	079e                	slli	a5,a5,0x7
    8000160c:	993e                	add	s2,s2,a5
    8000160e:	0b392623          	sw	s3,172(s2)
}
    80001612:	70a2                	ld	ra,40(sp)
    80001614:	7402                	ld	s0,32(sp)
    80001616:	64e2                	ld	s1,24(sp)
    80001618:	6942                	ld	s2,16(sp)
    8000161a:	69a2                	ld	s3,8(sp)
    8000161c:	6145                	addi	sp,sp,48
    8000161e:	8082                	ret
        panic("sched p->lock");
    80001620:	00007517          	auipc	a0,0x7
    80001624:	b9850513          	addi	a0,a0,-1128 # 800081b8 <etext+0x1b8>
    80001628:	00004097          	auipc	ra,0x4
    8000162c:	734080e7          	jalr	1844(ra) # 80005d5c <panic>
        panic("sched locks");
    80001630:	00007517          	auipc	a0,0x7
    80001634:	b9850513          	addi	a0,a0,-1128 # 800081c8 <etext+0x1c8>
    80001638:	00004097          	auipc	ra,0x4
    8000163c:	724080e7          	jalr	1828(ra) # 80005d5c <panic>
        panic("sched running");
    80001640:	00007517          	auipc	a0,0x7
    80001644:	b9850513          	addi	a0,a0,-1128 # 800081d8 <etext+0x1d8>
    80001648:	00004097          	auipc	ra,0x4
    8000164c:	714080e7          	jalr	1812(ra) # 80005d5c <panic>
        panic("sched interruptible");
    80001650:	00007517          	auipc	a0,0x7
    80001654:	b9850513          	addi	a0,a0,-1128 # 800081e8 <etext+0x1e8>
    80001658:	00004097          	auipc	ra,0x4
    8000165c:	704080e7          	jalr	1796(ra) # 80005d5c <panic>

0000000080001660 <yield>:
{
    80001660:	1101                	addi	sp,sp,-32
    80001662:	ec06                	sd	ra,24(sp)
    80001664:	e822                	sd	s0,16(sp)
    80001666:	e426                	sd	s1,8(sp)
    80001668:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    8000166a:	00000097          	auipc	ra,0x0
    8000166e:	8ce080e7          	jalr	-1842(ra) # 80000f38 <myproc>
    80001672:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80001674:	00005097          	auipc	ra,0x5
    80001678:	c20080e7          	jalr	-992(ra) # 80006294 <acquire>
    p->state = RUNNABLE;
    8000167c:	478d                	li	a5,3
    8000167e:	cc9c                	sw	a5,24(s1)
    sched();
    80001680:	00000097          	auipc	ra,0x0
    80001684:	f0a080e7          	jalr	-246(ra) # 8000158a <sched>
    release(&p->lock);
    80001688:	8526                	mv	a0,s1
    8000168a:	00005097          	auipc	ra,0x5
    8000168e:	cbe080e7          	jalr	-834(ra) # 80006348 <release>
}
    80001692:	60e2                	ld	ra,24(sp)
    80001694:	6442                	ld	s0,16(sp)
    80001696:	64a2                	ld	s1,8(sp)
    80001698:	6105                	addi	sp,sp,32
    8000169a:	8082                	ret

000000008000169c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    8000169c:	7179                	addi	sp,sp,-48
    8000169e:	f406                	sd	ra,40(sp)
    800016a0:	f022                	sd	s0,32(sp)
    800016a2:	ec26                	sd	s1,24(sp)
    800016a4:	e84a                	sd	s2,16(sp)
    800016a6:	e44e                	sd	s3,8(sp)
    800016a8:	1800                	addi	s0,sp,48
    800016aa:	89aa                	mv	s3,a0
    800016ac:	892e                	mv	s2,a1
    struct proc *p = myproc();
    800016ae:	00000097          	auipc	ra,0x0
    800016b2:	88a080e7          	jalr	-1910(ra) # 80000f38 <myproc>
    800016b6:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    800016b8:	00005097          	auipc	ra,0x5
    800016bc:	bdc080e7          	jalr	-1060(ra) # 80006294 <acquire>
    release(lk);
    800016c0:	854a                	mv	a0,s2
    800016c2:	00005097          	auipc	ra,0x5
    800016c6:	c86080e7          	jalr	-890(ra) # 80006348 <release>

    // Go to sleep.
    p->chan = chan;
    800016ca:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    800016ce:	4789                	li	a5,2
    800016d0:	cc9c                	sw	a5,24(s1)

    sched();
    800016d2:	00000097          	auipc	ra,0x0
    800016d6:	eb8080e7          	jalr	-328(ra) # 8000158a <sched>

    // Tidy up.
    p->chan = 0;
    800016da:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    800016de:	8526                	mv	a0,s1
    800016e0:	00005097          	auipc	ra,0x5
    800016e4:	c68080e7          	jalr	-920(ra) # 80006348 <release>
    acquire(lk);
    800016e8:	854a                	mv	a0,s2
    800016ea:	00005097          	auipc	ra,0x5
    800016ee:	baa080e7          	jalr	-1110(ra) # 80006294 <acquire>
}
    800016f2:	70a2                	ld	ra,40(sp)
    800016f4:	7402                	ld	s0,32(sp)
    800016f6:	64e2                	ld	s1,24(sp)
    800016f8:	6942                	ld	s2,16(sp)
    800016fa:	69a2                	ld	s3,8(sp)
    800016fc:	6145                	addi	sp,sp,48
    800016fe:	8082                	ret

0000000080001700 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    80001700:	7139                	addi	sp,sp,-64
    80001702:	fc06                	sd	ra,56(sp)
    80001704:	f822                	sd	s0,48(sp)
    80001706:	f426                	sd	s1,40(sp)
    80001708:	f04a                	sd	s2,32(sp)
    8000170a:	ec4e                	sd	s3,24(sp)
    8000170c:	e852                	sd	s4,16(sp)
    8000170e:	e456                	sd	s5,8(sp)
    80001710:	0080                	addi	s0,sp,64
    80001712:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++) {
    80001714:	00007497          	auipc	s1,0x7
    80001718:	68c48493          	addi	s1,s1,1676 # 80008da0 <proc>
        if (p != myproc()) {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan) {
    8000171c:	4989                	li	s3,2
                p->state = RUNNABLE;
    8000171e:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++) {
    80001720:	0000d917          	auipc	s2,0xd
    80001724:	28090913          	addi	s2,s2,640 # 8000e9a0 <tickslock>
    80001728:	a811                	j	8000173c <wakeup+0x3c>
            }
            release(&p->lock);
    8000172a:	8526                	mv	a0,s1
    8000172c:	00005097          	auipc	ra,0x5
    80001730:	c1c080e7          	jalr	-996(ra) # 80006348 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001734:	17048493          	addi	s1,s1,368
    80001738:	03248663          	beq	s1,s2,80001764 <wakeup+0x64>
        if (p != myproc()) {
    8000173c:	fffff097          	auipc	ra,0xfffff
    80001740:	7fc080e7          	jalr	2044(ra) # 80000f38 <myproc>
    80001744:	fea488e3          	beq	s1,a0,80001734 <wakeup+0x34>
            acquire(&p->lock);
    80001748:	8526                	mv	a0,s1
    8000174a:	00005097          	auipc	ra,0x5
    8000174e:	b4a080e7          	jalr	-1206(ra) # 80006294 <acquire>
            if (p->state == SLEEPING && p->chan == chan) {
    80001752:	4c9c                	lw	a5,24(s1)
    80001754:	fd379be3          	bne	a5,s3,8000172a <wakeup+0x2a>
    80001758:	709c                	ld	a5,32(s1)
    8000175a:	fd4798e3          	bne	a5,s4,8000172a <wakeup+0x2a>
                p->state = RUNNABLE;
    8000175e:	0154ac23          	sw	s5,24(s1)
    80001762:	b7e1                	j	8000172a <wakeup+0x2a>
        }
    }
}
    80001764:	70e2                	ld	ra,56(sp)
    80001766:	7442                	ld	s0,48(sp)
    80001768:	74a2                	ld	s1,40(sp)
    8000176a:	7902                	ld	s2,32(sp)
    8000176c:	69e2                	ld	s3,24(sp)
    8000176e:	6a42                	ld	s4,16(sp)
    80001770:	6aa2                	ld	s5,8(sp)
    80001772:	6121                	addi	sp,sp,64
    80001774:	8082                	ret

0000000080001776 <reparent>:
{
    80001776:	7179                	addi	sp,sp,-48
    80001778:	f406                	sd	ra,40(sp)
    8000177a:	f022                	sd	s0,32(sp)
    8000177c:	ec26                	sd	s1,24(sp)
    8000177e:	e84a                	sd	s2,16(sp)
    80001780:	e44e                	sd	s3,8(sp)
    80001782:	e052                	sd	s4,0(sp)
    80001784:	1800                	addi	s0,sp,48
    80001786:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001788:	00007497          	auipc	s1,0x7
    8000178c:	61848493          	addi	s1,s1,1560 # 80008da0 <proc>
            pp->parent = initproc;
    80001790:	00007a17          	auipc	s4,0x7
    80001794:	1a0a0a13          	addi	s4,s4,416 # 80008930 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001798:	0000d997          	auipc	s3,0xd
    8000179c:	20898993          	addi	s3,s3,520 # 8000e9a0 <tickslock>
    800017a0:	a029                	j	800017aa <reparent+0x34>
    800017a2:	17048493          	addi	s1,s1,368
    800017a6:	01348d63          	beq	s1,s3,800017c0 <reparent+0x4a>
        if (pp->parent == p) {
    800017aa:	7c9c                	ld	a5,56(s1)
    800017ac:	ff279be3          	bne	a5,s2,800017a2 <reparent+0x2c>
            pp->parent = initproc;
    800017b0:	000a3503          	ld	a0,0(s4)
    800017b4:	fc88                	sd	a0,56(s1)
            wakeup(initproc);
    800017b6:	00000097          	auipc	ra,0x0
    800017ba:	f4a080e7          	jalr	-182(ra) # 80001700 <wakeup>
    800017be:	b7d5                	j	800017a2 <reparent+0x2c>
}
    800017c0:	70a2                	ld	ra,40(sp)
    800017c2:	7402                	ld	s0,32(sp)
    800017c4:	64e2                	ld	s1,24(sp)
    800017c6:	6942                	ld	s2,16(sp)
    800017c8:	69a2                	ld	s3,8(sp)
    800017ca:	6a02                	ld	s4,0(sp)
    800017cc:	6145                	addi	sp,sp,48
    800017ce:	8082                	ret

00000000800017d0 <exit>:
{
    800017d0:	7179                	addi	sp,sp,-48
    800017d2:	f406                	sd	ra,40(sp)
    800017d4:	f022                	sd	s0,32(sp)
    800017d6:	ec26                	sd	s1,24(sp)
    800017d8:	e84a                	sd	s2,16(sp)
    800017da:	e44e                	sd	s3,8(sp)
    800017dc:	e052                	sd	s4,0(sp)
    800017de:	1800                	addi	s0,sp,48
    800017e0:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    800017e2:	fffff097          	auipc	ra,0xfffff
    800017e6:	756080e7          	jalr	1878(ra) # 80000f38 <myproc>
    800017ea:	89aa                	mv	s3,a0
    if (p == initproc)
    800017ec:	00007797          	auipc	a5,0x7
    800017f0:	1447b783          	ld	a5,324(a5) # 80008930 <initproc>
    800017f4:	0d050493          	addi	s1,a0,208
    800017f8:	15050913          	addi	s2,a0,336
    800017fc:	02a79363          	bne	a5,a0,80001822 <exit+0x52>
        panic("init exiting");
    80001800:	00007517          	auipc	a0,0x7
    80001804:	a0050513          	addi	a0,a0,-1536 # 80008200 <etext+0x200>
    80001808:	00004097          	auipc	ra,0x4
    8000180c:	554080e7          	jalr	1364(ra) # 80005d5c <panic>
            fileclose(f);
    80001810:	00002097          	auipc	ra,0x2
    80001814:	306080e7          	jalr	774(ra) # 80003b16 <fileclose>
            p->ofile[fd] = 0;
    80001818:	0004b023          	sd	zero,0(s1)
    for (int fd = 0; fd < NOFILE; fd++) {
    8000181c:	04a1                	addi	s1,s1,8
    8000181e:	01248563          	beq	s1,s2,80001828 <exit+0x58>
        if (p->ofile[fd]) {
    80001822:	6088                	ld	a0,0(s1)
    80001824:	f575                	bnez	a0,80001810 <exit+0x40>
    80001826:	bfdd                	j	8000181c <exit+0x4c>
    begin_op();
    80001828:	00002097          	auipc	ra,0x2
    8000182c:	e26080e7          	jalr	-474(ra) # 8000364e <begin_op>
    iput(p->cwd);
    80001830:	1509b503          	ld	a0,336(s3)
    80001834:	00001097          	auipc	ra,0x1
    80001838:	608080e7          	jalr	1544(ra) # 80002e3c <iput>
    end_op();
    8000183c:	00002097          	auipc	ra,0x2
    80001840:	e90080e7          	jalr	-368(ra) # 800036cc <end_op>
    p->cwd = 0;
    80001844:	1409b823          	sd	zero,336(s3)
    acquire(&wait_lock);
    80001848:	00007497          	auipc	s1,0x7
    8000184c:	14048493          	addi	s1,s1,320 # 80008988 <wait_lock>
    80001850:	8526                	mv	a0,s1
    80001852:	00005097          	auipc	ra,0x5
    80001856:	a42080e7          	jalr	-1470(ra) # 80006294 <acquire>
    reparent(p);
    8000185a:	854e                	mv	a0,s3
    8000185c:	00000097          	auipc	ra,0x0
    80001860:	f1a080e7          	jalr	-230(ra) # 80001776 <reparent>
    wakeup(p->parent);
    80001864:	0389b503          	ld	a0,56(s3)
    80001868:	00000097          	auipc	ra,0x0
    8000186c:	e98080e7          	jalr	-360(ra) # 80001700 <wakeup>
    acquire(&p->lock);
    80001870:	854e                	mv	a0,s3
    80001872:	00005097          	auipc	ra,0x5
    80001876:	a22080e7          	jalr	-1502(ra) # 80006294 <acquire>
    p->xstate = status;
    8000187a:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    8000187e:	4795                	li	a5,5
    80001880:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    80001884:	8526                	mv	a0,s1
    80001886:	00005097          	auipc	ra,0x5
    8000188a:	ac2080e7          	jalr	-1342(ra) # 80006348 <release>
    sched();
    8000188e:	00000097          	auipc	ra,0x0
    80001892:	cfc080e7          	jalr	-772(ra) # 8000158a <sched>
    panic("zombie exit");
    80001896:	00007517          	auipc	a0,0x7
    8000189a:	97a50513          	addi	a0,a0,-1670 # 80008210 <etext+0x210>
    8000189e:	00004097          	auipc	ra,0x4
    800018a2:	4be080e7          	jalr	1214(ra) # 80005d5c <panic>

00000000800018a6 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    800018a6:	7179                	addi	sp,sp,-48
    800018a8:	f406                	sd	ra,40(sp)
    800018aa:	f022                	sd	s0,32(sp)
    800018ac:	ec26                	sd	s1,24(sp)
    800018ae:	e84a                	sd	s2,16(sp)
    800018b0:	e44e                	sd	s3,8(sp)
    800018b2:	1800                	addi	s0,sp,48
    800018b4:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++) {
    800018b6:	00007497          	auipc	s1,0x7
    800018ba:	4ea48493          	addi	s1,s1,1258 # 80008da0 <proc>
    800018be:	0000d997          	auipc	s3,0xd
    800018c2:	0e298993          	addi	s3,s3,226 # 8000e9a0 <tickslock>
        acquire(&p->lock);
    800018c6:	8526                	mv	a0,s1
    800018c8:	00005097          	auipc	ra,0x5
    800018cc:	9cc080e7          	jalr	-1588(ra) # 80006294 <acquire>
        if (p->pid == pid) {
    800018d0:	589c                	lw	a5,48(s1)
    800018d2:	01278d63          	beq	a5,s2,800018ec <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    800018d6:	8526                	mv	a0,s1
    800018d8:	00005097          	auipc	ra,0x5
    800018dc:	a70080e7          	jalr	-1424(ra) # 80006348 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    800018e0:	17048493          	addi	s1,s1,368
    800018e4:	ff3491e3          	bne	s1,s3,800018c6 <kill+0x20>
    }
    return -1;
    800018e8:	557d                	li	a0,-1
    800018ea:	a829                	j	80001904 <kill+0x5e>
            p->killed = 1;
    800018ec:	4785                	li	a5,1
    800018ee:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING) {
    800018f0:	4c98                	lw	a4,24(s1)
    800018f2:	4789                	li	a5,2
    800018f4:	00f70f63          	beq	a4,a5,80001912 <kill+0x6c>
            release(&p->lock);
    800018f8:	8526                	mv	a0,s1
    800018fa:	00005097          	auipc	ra,0x5
    800018fe:	a4e080e7          	jalr	-1458(ra) # 80006348 <release>
            return 0;
    80001902:	4501                	li	a0,0
}
    80001904:	70a2                	ld	ra,40(sp)
    80001906:	7402                	ld	s0,32(sp)
    80001908:	64e2                	ld	s1,24(sp)
    8000190a:	6942                	ld	s2,16(sp)
    8000190c:	69a2                	ld	s3,8(sp)
    8000190e:	6145                	addi	sp,sp,48
    80001910:	8082                	ret
                p->state = RUNNABLE;
    80001912:	478d                	li	a5,3
    80001914:	cc9c                	sw	a5,24(s1)
    80001916:	b7cd                	j	800018f8 <kill+0x52>

0000000080001918 <setkilled>:

void setkilled(struct proc *p)
{
    80001918:	1101                	addi	sp,sp,-32
    8000191a:	ec06                	sd	ra,24(sp)
    8000191c:	e822                	sd	s0,16(sp)
    8000191e:	e426                	sd	s1,8(sp)
    80001920:	1000                	addi	s0,sp,32
    80001922:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80001924:	00005097          	auipc	ra,0x5
    80001928:	970080e7          	jalr	-1680(ra) # 80006294 <acquire>
    p->killed = 1;
    8000192c:	4785                	li	a5,1
    8000192e:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    80001930:	8526                	mv	a0,s1
    80001932:	00005097          	auipc	ra,0x5
    80001936:	a16080e7          	jalr	-1514(ra) # 80006348 <release>
}
    8000193a:	60e2                	ld	ra,24(sp)
    8000193c:	6442                	ld	s0,16(sp)
    8000193e:	64a2                	ld	s1,8(sp)
    80001940:	6105                	addi	sp,sp,32
    80001942:	8082                	ret

0000000080001944 <killed>:

int killed(struct proc *p)
{
    80001944:	1101                	addi	sp,sp,-32
    80001946:	ec06                	sd	ra,24(sp)
    80001948:	e822                	sd	s0,16(sp)
    8000194a:	e426                	sd	s1,8(sp)
    8000194c:	e04a                	sd	s2,0(sp)
    8000194e:	1000                	addi	s0,sp,32
    80001950:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    80001952:	00005097          	auipc	ra,0x5
    80001956:	942080e7          	jalr	-1726(ra) # 80006294 <acquire>
    k = p->killed;
    8000195a:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    8000195e:	8526                	mv	a0,s1
    80001960:	00005097          	auipc	ra,0x5
    80001964:	9e8080e7          	jalr	-1560(ra) # 80006348 <release>
    return k;
}
    80001968:	854a                	mv	a0,s2
    8000196a:	60e2                	ld	ra,24(sp)
    8000196c:	6442                	ld	s0,16(sp)
    8000196e:	64a2                	ld	s1,8(sp)
    80001970:	6902                	ld	s2,0(sp)
    80001972:	6105                	addi	sp,sp,32
    80001974:	8082                	ret

0000000080001976 <wait>:
{
    80001976:	715d                	addi	sp,sp,-80
    80001978:	e486                	sd	ra,72(sp)
    8000197a:	e0a2                	sd	s0,64(sp)
    8000197c:	fc26                	sd	s1,56(sp)
    8000197e:	f84a                	sd	s2,48(sp)
    80001980:	f44e                	sd	s3,40(sp)
    80001982:	f052                	sd	s4,32(sp)
    80001984:	ec56                	sd	s5,24(sp)
    80001986:	e85a                	sd	s6,16(sp)
    80001988:	e45e                	sd	s7,8(sp)
    8000198a:	e062                	sd	s8,0(sp)
    8000198c:	0880                	addi	s0,sp,80
    8000198e:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    80001990:	fffff097          	auipc	ra,0xfffff
    80001994:	5a8080e7          	jalr	1448(ra) # 80000f38 <myproc>
    80001998:	892a                	mv	s2,a0
    acquire(&wait_lock);
    8000199a:	00007517          	auipc	a0,0x7
    8000199e:	fee50513          	addi	a0,a0,-18 # 80008988 <wait_lock>
    800019a2:	00005097          	auipc	ra,0x5
    800019a6:	8f2080e7          	jalr	-1806(ra) # 80006294 <acquire>
        havekids = 0;
    800019aa:	4b81                	li	s7,0
                if (pp->state == ZOMBIE) {
    800019ac:	4a15                	li	s4,5
                havekids = 1;
    800019ae:	4a85                	li	s5,1
        for (pp = proc; pp < &proc[NPROC]; pp++) {
    800019b0:	0000d997          	auipc	s3,0xd
    800019b4:	ff098993          	addi	s3,s3,-16 # 8000e9a0 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    800019b8:	00007c17          	auipc	s8,0x7
    800019bc:	fd0c0c13          	addi	s8,s8,-48 # 80008988 <wait_lock>
        havekids = 0;
    800019c0:	875e                	mv	a4,s7
        for (pp = proc; pp < &proc[NPROC]; pp++) {
    800019c2:	00007497          	auipc	s1,0x7
    800019c6:	3de48493          	addi	s1,s1,990 # 80008da0 <proc>
    800019ca:	a0bd                	j	80001a38 <wait+0xc2>
                    pid = pp->pid;
    800019cc:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate, sizeof(pp->xstate)) < 0) {
    800019d0:	000b0e63          	beqz	s6,800019ec <wait+0x76>
    800019d4:	4691                	li	a3,4
    800019d6:	02c48613          	addi	a2,s1,44
    800019da:	85da                	mv	a1,s6
    800019dc:	05093503          	ld	a0,80(s2)
    800019e0:	fffff097          	auipc	ra,0xfffff
    800019e4:	134080e7          	jalr	308(ra) # 80000b14 <copyout>
    800019e8:	02054563          	bltz	a0,80001a12 <wait+0x9c>
                    freeproc(pp);
    800019ec:	8526                	mv	a0,s1
    800019ee:	fffff097          	auipc	ra,0xfffff
    800019f2:	770080e7          	jalr	1904(ra) # 8000115e <freeproc>
                    release(&pp->lock);
    800019f6:	8526                	mv	a0,s1
    800019f8:	00005097          	auipc	ra,0x5
    800019fc:	950080e7          	jalr	-1712(ra) # 80006348 <release>
                    release(&wait_lock);
    80001a00:	00007517          	auipc	a0,0x7
    80001a04:	f8850513          	addi	a0,a0,-120 # 80008988 <wait_lock>
    80001a08:	00005097          	auipc	ra,0x5
    80001a0c:	940080e7          	jalr	-1728(ra) # 80006348 <release>
                    return pid;
    80001a10:	a0b5                	j	80001a7c <wait+0x106>
                        release(&pp->lock);
    80001a12:	8526                	mv	a0,s1
    80001a14:	00005097          	auipc	ra,0x5
    80001a18:	934080e7          	jalr	-1740(ra) # 80006348 <release>
                        release(&wait_lock);
    80001a1c:	00007517          	auipc	a0,0x7
    80001a20:	f6c50513          	addi	a0,a0,-148 # 80008988 <wait_lock>
    80001a24:	00005097          	auipc	ra,0x5
    80001a28:	924080e7          	jalr	-1756(ra) # 80006348 <release>
                        return -1;
    80001a2c:	59fd                	li	s3,-1
    80001a2e:	a0b9                	j	80001a7c <wait+0x106>
        for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001a30:	17048493          	addi	s1,s1,368
    80001a34:	03348463          	beq	s1,s3,80001a5c <wait+0xe6>
            if (pp->parent == p) {
    80001a38:	7c9c                	ld	a5,56(s1)
    80001a3a:	ff279be3          	bne	a5,s2,80001a30 <wait+0xba>
                acquire(&pp->lock);
    80001a3e:	8526                	mv	a0,s1
    80001a40:	00005097          	auipc	ra,0x5
    80001a44:	854080e7          	jalr	-1964(ra) # 80006294 <acquire>
                if (pp->state == ZOMBIE) {
    80001a48:	4c9c                	lw	a5,24(s1)
    80001a4a:	f94781e3          	beq	a5,s4,800019cc <wait+0x56>
                release(&pp->lock);
    80001a4e:	8526                	mv	a0,s1
    80001a50:	00005097          	auipc	ra,0x5
    80001a54:	8f8080e7          	jalr	-1800(ra) # 80006348 <release>
                havekids = 1;
    80001a58:	8756                	mv	a4,s5
    80001a5a:	bfd9                	j	80001a30 <wait+0xba>
        if (!havekids || killed(p)) {
    80001a5c:	c719                	beqz	a4,80001a6a <wait+0xf4>
    80001a5e:	854a                	mv	a0,s2
    80001a60:	00000097          	auipc	ra,0x0
    80001a64:	ee4080e7          	jalr	-284(ra) # 80001944 <killed>
    80001a68:	c51d                	beqz	a0,80001a96 <wait+0x120>
            release(&wait_lock);
    80001a6a:	00007517          	auipc	a0,0x7
    80001a6e:	f1e50513          	addi	a0,a0,-226 # 80008988 <wait_lock>
    80001a72:	00005097          	auipc	ra,0x5
    80001a76:	8d6080e7          	jalr	-1834(ra) # 80006348 <release>
            return -1;
    80001a7a:	59fd                	li	s3,-1
}
    80001a7c:	854e                	mv	a0,s3
    80001a7e:	60a6                	ld	ra,72(sp)
    80001a80:	6406                	ld	s0,64(sp)
    80001a82:	74e2                	ld	s1,56(sp)
    80001a84:	7942                	ld	s2,48(sp)
    80001a86:	79a2                	ld	s3,40(sp)
    80001a88:	7a02                	ld	s4,32(sp)
    80001a8a:	6ae2                	ld	s5,24(sp)
    80001a8c:	6b42                	ld	s6,16(sp)
    80001a8e:	6ba2                	ld	s7,8(sp)
    80001a90:	6c02                	ld	s8,0(sp)
    80001a92:	6161                	addi	sp,sp,80
    80001a94:	8082                	ret
        sleep(p, &wait_lock); // DOC: wait-sleep
    80001a96:	85e2                	mv	a1,s8
    80001a98:	854a                	mv	a0,s2
    80001a9a:	00000097          	auipc	ra,0x0
    80001a9e:	c02080e7          	jalr	-1022(ra) # 8000169c <sleep>
        havekids = 0;
    80001aa2:	bf39                	j	800019c0 <wait+0x4a>

0000000080001aa4 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001aa4:	7179                	addi	sp,sp,-48
    80001aa6:	f406                	sd	ra,40(sp)
    80001aa8:	f022                	sd	s0,32(sp)
    80001aaa:	ec26                	sd	s1,24(sp)
    80001aac:	e84a                	sd	s2,16(sp)
    80001aae:	e44e                	sd	s3,8(sp)
    80001ab0:	e052                	sd	s4,0(sp)
    80001ab2:	1800                	addi	s0,sp,48
    80001ab4:	84aa                	mv	s1,a0
    80001ab6:	892e                	mv	s2,a1
    80001ab8:	89b2                	mv	s3,a2
    80001aba:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80001abc:	fffff097          	auipc	ra,0xfffff
    80001ac0:	47c080e7          	jalr	1148(ra) # 80000f38 <myproc>
    if (user_dst) {
    80001ac4:	c08d                	beqz	s1,80001ae6 <either_copyout+0x42>
        return copyout(p->pagetable, dst, src, len);
    80001ac6:	86d2                	mv	a3,s4
    80001ac8:	864e                	mv	a2,s3
    80001aca:	85ca                	mv	a1,s2
    80001acc:	6928                	ld	a0,80(a0)
    80001ace:	fffff097          	auipc	ra,0xfffff
    80001ad2:	046080e7          	jalr	70(ra) # 80000b14 <copyout>
    }
    else {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    80001ad6:	70a2                	ld	ra,40(sp)
    80001ad8:	7402                	ld	s0,32(sp)
    80001ada:	64e2                	ld	s1,24(sp)
    80001adc:	6942                	ld	s2,16(sp)
    80001ade:	69a2                	ld	s3,8(sp)
    80001ae0:	6a02                	ld	s4,0(sp)
    80001ae2:	6145                	addi	sp,sp,48
    80001ae4:	8082                	ret
        memmove((char *)dst, src, len);
    80001ae6:	000a061b          	sext.w	a2,s4
    80001aea:	85ce                	mv	a1,s3
    80001aec:	854a                	mv	a0,s2
    80001aee:	ffffe097          	auipc	ra,0xffffe
    80001af2:	6e8080e7          	jalr	1768(ra) # 800001d6 <memmove>
        return 0;
    80001af6:	8526                	mv	a0,s1
    80001af8:	bff9                	j	80001ad6 <either_copyout+0x32>

0000000080001afa <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001afa:	7179                	addi	sp,sp,-48
    80001afc:	f406                	sd	ra,40(sp)
    80001afe:	f022                	sd	s0,32(sp)
    80001b00:	ec26                	sd	s1,24(sp)
    80001b02:	e84a                	sd	s2,16(sp)
    80001b04:	e44e                	sd	s3,8(sp)
    80001b06:	e052                	sd	s4,0(sp)
    80001b08:	1800                	addi	s0,sp,48
    80001b0a:	892a                	mv	s2,a0
    80001b0c:	84ae                	mv	s1,a1
    80001b0e:	89b2                	mv	s3,a2
    80001b10:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80001b12:	fffff097          	auipc	ra,0xfffff
    80001b16:	426080e7          	jalr	1062(ra) # 80000f38 <myproc>
    if (user_src) {
    80001b1a:	c08d                	beqz	s1,80001b3c <either_copyin+0x42>
        return copyin(p->pagetable, dst, src, len);
    80001b1c:	86d2                	mv	a3,s4
    80001b1e:	864e                	mv	a2,s3
    80001b20:	85ca                	mv	a1,s2
    80001b22:	6928                	ld	a0,80(a0)
    80001b24:	fffff097          	auipc	ra,0xfffff
    80001b28:	07c080e7          	jalr	124(ra) # 80000ba0 <copyin>
    }
    else {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    80001b2c:	70a2                	ld	ra,40(sp)
    80001b2e:	7402                	ld	s0,32(sp)
    80001b30:	64e2                	ld	s1,24(sp)
    80001b32:	6942                	ld	s2,16(sp)
    80001b34:	69a2                	ld	s3,8(sp)
    80001b36:	6a02                	ld	s4,0(sp)
    80001b38:	6145                	addi	sp,sp,48
    80001b3a:	8082                	ret
        memmove(dst, (char *)src, len);
    80001b3c:	000a061b          	sext.w	a2,s4
    80001b40:	85ce                	mv	a1,s3
    80001b42:	854a                	mv	a0,s2
    80001b44:	ffffe097          	auipc	ra,0xffffe
    80001b48:	692080e7          	jalr	1682(ra) # 800001d6 <memmove>
        return 0;
    80001b4c:	8526                	mv	a0,s1
    80001b4e:	bff9                	j	80001b2c <either_copyin+0x32>

0000000080001b50 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80001b50:	715d                	addi	sp,sp,-80
    80001b52:	e486                	sd	ra,72(sp)
    80001b54:	e0a2                	sd	s0,64(sp)
    80001b56:	fc26                	sd	s1,56(sp)
    80001b58:	f84a                	sd	s2,48(sp)
    80001b5a:	f44e                	sd	s3,40(sp)
    80001b5c:	f052                	sd	s4,32(sp)
    80001b5e:	ec56                	sd	s5,24(sp)
    80001b60:	e85a                	sd	s6,16(sp)
    80001b62:	e45e                	sd	s7,8(sp)
    80001b64:	0880                	addi	s0,sp,80
    static char *states[] = {[UNUSED] "unused", [USED] "used", [SLEEPING] "sleep ", [RUNNABLE] "runble", [RUNNING] "run   ", [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    80001b66:	00006517          	auipc	a0,0x6
    80001b6a:	4e250513          	addi	a0,a0,1250 # 80008048 <etext+0x48>
    80001b6e:	00004097          	auipc	ra,0x4
    80001b72:	238080e7          	jalr	568(ra) # 80005da6 <printf>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001b76:	00007497          	auipc	s1,0x7
    80001b7a:	38248493          	addi	s1,s1,898 # 80008ef8 <proc+0x158>
    80001b7e:	0000d917          	auipc	s2,0xd
    80001b82:	f7a90913          	addi	s2,s2,-134 # 8000eaf8 <bcache+0x140>
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b86:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    80001b88:	00006997          	auipc	s3,0x6
    80001b8c:	69898993          	addi	s3,s3,1688 # 80008220 <etext+0x220>
        printf("%d %s %s", p->pid, state, p->name);
    80001b90:	00006a97          	auipc	s5,0x6
    80001b94:	698a8a93          	addi	s5,s5,1688 # 80008228 <etext+0x228>
        printf("\n");
    80001b98:	00006a17          	auipc	s4,0x6
    80001b9c:	4b0a0a13          	addi	s4,s4,1200 # 80008048 <etext+0x48>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ba0:	00006b97          	auipc	s7,0x6
    80001ba4:	6c8b8b93          	addi	s7,s7,1736 # 80008268 <states.0>
    80001ba8:	a00d                	j	80001bca <procdump+0x7a>
        printf("%d %s %s", p->pid, state, p->name);
    80001baa:	ed86a583          	lw	a1,-296(a3)
    80001bae:	8556                	mv	a0,s5
    80001bb0:	00004097          	auipc	ra,0x4
    80001bb4:	1f6080e7          	jalr	502(ra) # 80005da6 <printf>
        printf("\n");
    80001bb8:	8552                	mv	a0,s4
    80001bba:	00004097          	auipc	ra,0x4
    80001bbe:	1ec080e7          	jalr	492(ra) # 80005da6 <printf>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001bc2:	17048493          	addi	s1,s1,368
    80001bc6:	03248263          	beq	s1,s2,80001bea <procdump+0x9a>
        if (p->state == UNUSED)
    80001bca:	86a6                	mv	a3,s1
    80001bcc:	ec04a783          	lw	a5,-320(s1)
    80001bd0:	dbed                	beqz	a5,80001bc2 <procdump+0x72>
            state = "???";
    80001bd2:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bd4:	fcfb6be3          	bltu	s6,a5,80001baa <procdump+0x5a>
    80001bd8:	02079713          	slli	a4,a5,0x20
    80001bdc:	01d75793          	srli	a5,a4,0x1d
    80001be0:	97de                	add	a5,a5,s7
    80001be2:	6390                	ld	a2,0(a5)
    80001be4:	f279                	bnez	a2,80001baa <procdump+0x5a>
            state = "???";
    80001be6:	864e                	mv	a2,s3
    80001be8:	b7c9                	j	80001baa <procdump+0x5a>
    }
}
    80001bea:	60a6                	ld	ra,72(sp)
    80001bec:	6406                	ld	s0,64(sp)
    80001bee:	74e2                	ld	s1,56(sp)
    80001bf0:	7942                	ld	s2,48(sp)
    80001bf2:	79a2                	ld	s3,40(sp)
    80001bf4:	7a02                	ld	s4,32(sp)
    80001bf6:	6ae2                	ld	s5,24(sp)
    80001bf8:	6b42                	ld	s6,16(sp)
    80001bfa:	6ba2                	ld	s7,8(sp)
    80001bfc:	6161                	addi	sp,sp,80
    80001bfe:	8082                	ret

0000000080001c00 <swtch>:
    80001c00:	00153023          	sd	ra,0(a0)
    80001c04:	00253423          	sd	sp,8(a0)
    80001c08:	e900                	sd	s0,16(a0)
    80001c0a:	ed04                	sd	s1,24(a0)
    80001c0c:	03253023          	sd	s2,32(a0)
    80001c10:	03353423          	sd	s3,40(a0)
    80001c14:	03453823          	sd	s4,48(a0)
    80001c18:	03553c23          	sd	s5,56(a0)
    80001c1c:	05653023          	sd	s6,64(a0)
    80001c20:	05753423          	sd	s7,72(a0)
    80001c24:	05853823          	sd	s8,80(a0)
    80001c28:	05953c23          	sd	s9,88(a0)
    80001c2c:	07a53023          	sd	s10,96(a0)
    80001c30:	07b53423          	sd	s11,104(a0)
    80001c34:	0005b083          	ld	ra,0(a1)
    80001c38:	0085b103          	ld	sp,8(a1)
    80001c3c:	6980                	ld	s0,16(a1)
    80001c3e:	6d84                	ld	s1,24(a1)
    80001c40:	0205b903          	ld	s2,32(a1)
    80001c44:	0285b983          	ld	s3,40(a1)
    80001c48:	0305ba03          	ld	s4,48(a1)
    80001c4c:	0385ba83          	ld	s5,56(a1)
    80001c50:	0405bb03          	ld	s6,64(a1)
    80001c54:	0485bb83          	ld	s7,72(a1)
    80001c58:	0505bc03          	ld	s8,80(a1)
    80001c5c:	0585bc83          	ld	s9,88(a1)
    80001c60:	0605bd03          	ld	s10,96(a1)
    80001c64:	0685bd83          	ld	s11,104(a1)
    80001c68:	8082                	ret

0000000080001c6a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c6a:	1141                	addi	sp,sp,-16
    80001c6c:	e406                	sd	ra,8(sp)
    80001c6e:	e022                	sd	s0,0(sp)
    80001c70:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c72:	00006597          	auipc	a1,0x6
    80001c76:	62658593          	addi	a1,a1,1574 # 80008298 <states.0+0x30>
    80001c7a:	0000d517          	auipc	a0,0xd
    80001c7e:	d2650513          	addi	a0,a0,-730 # 8000e9a0 <tickslock>
    80001c82:	00004097          	auipc	ra,0x4
    80001c86:	582080e7          	jalr	1410(ra) # 80006204 <initlock>
}
    80001c8a:	60a2                	ld	ra,8(sp)
    80001c8c:	6402                	ld	s0,0(sp)
    80001c8e:	0141                	addi	sp,sp,16
    80001c90:	8082                	ret

0000000080001c92 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c92:	1141                	addi	sp,sp,-16
    80001c94:	e422                	sd	s0,8(sp)
    80001c96:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c98:	00003797          	auipc	a5,0x3
    80001c9c:	4f878793          	addi	a5,a5,1272 # 80005190 <kernelvec>
    80001ca0:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001ca4:	6422                	ld	s0,8(sp)
    80001ca6:	0141                	addi	sp,sp,16
    80001ca8:	8082                	ret

0000000080001caa <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001caa:	1141                	addi	sp,sp,-16
    80001cac:	e406                	sd	ra,8(sp)
    80001cae:	e022                	sd	s0,0(sp)
    80001cb0:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001cb2:	fffff097          	auipc	ra,0xfffff
    80001cb6:	286080e7          	jalr	646(ra) # 80000f38 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cba:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001cbe:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cc0:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001cc4:	00005697          	auipc	a3,0x5
    80001cc8:	33c68693          	addi	a3,a3,828 # 80007000 <_trampoline>
    80001ccc:	00005717          	auipc	a4,0x5
    80001cd0:	33470713          	addi	a4,a4,820 # 80007000 <_trampoline>
    80001cd4:	8f15                	sub	a4,a4,a3
    80001cd6:	040007b7          	lui	a5,0x4000
    80001cda:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001cdc:	07b2                	slli	a5,a5,0xc
    80001cde:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ce0:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001ce4:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001ce6:	18002673          	csrr	a2,satp
    80001cea:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001cec:	6d30                	ld	a2,88(a0)
    80001cee:	6138                	ld	a4,64(a0)
    80001cf0:	6585                	lui	a1,0x1
    80001cf2:	972e                	add	a4,a4,a1
    80001cf4:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001cf6:	6d38                	ld	a4,88(a0)
    80001cf8:	00000617          	auipc	a2,0x0
    80001cfc:	13060613          	addi	a2,a2,304 # 80001e28 <usertrap>
    80001d00:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d02:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d04:	8612                	mv	a2,tp
    80001d06:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d08:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d0c:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d10:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d14:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d18:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d1a:	6f18                	ld	a4,24(a4)
    80001d1c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d20:	6928                	ld	a0,80(a0)
    80001d22:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001d24:	00005717          	auipc	a4,0x5
    80001d28:	37870713          	addi	a4,a4,888 # 8000709c <userret>
    80001d2c:	8f15                	sub	a4,a4,a3
    80001d2e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001d30:	577d                	li	a4,-1
    80001d32:	177e                	slli	a4,a4,0x3f
    80001d34:	8d59                	or	a0,a0,a4
    80001d36:	9782                	jalr	a5
}
    80001d38:	60a2                	ld	ra,8(sp)
    80001d3a:	6402                	ld	s0,0(sp)
    80001d3c:	0141                	addi	sp,sp,16
    80001d3e:	8082                	ret

0000000080001d40 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d40:	1101                	addi	sp,sp,-32
    80001d42:	ec06                	sd	ra,24(sp)
    80001d44:	e822                	sd	s0,16(sp)
    80001d46:	e426                	sd	s1,8(sp)
    80001d48:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d4a:	0000d497          	auipc	s1,0xd
    80001d4e:	c5648493          	addi	s1,s1,-938 # 8000e9a0 <tickslock>
    80001d52:	8526                	mv	a0,s1
    80001d54:	00004097          	auipc	ra,0x4
    80001d58:	540080e7          	jalr	1344(ra) # 80006294 <acquire>
  ticks++;
    80001d5c:	00007517          	auipc	a0,0x7
    80001d60:	bdc50513          	addi	a0,a0,-1060 # 80008938 <ticks>
    80001d64:	411c                	lw	a5,0(a0)
    80001d66:	2785                	addiw	a5,a5,1
    80001d68:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d6a:	00000097          	auipc	ra,0x0
    80001d6e:	996080e7          	jalr	-1642(ra) # 80001700 <wakeup>
  release(&tickslock);
    80001d72:	8526                	mv	a0,s1
    80001d74:	00004097          	auipc	ra,0x4
    80001d78:	5d4080e7          	jalr	1492(ra) # 80006348 <release>
}
    80001d7c:	60e2                	ld	ra,24(sp)
    80001d7e:	6442                	ld	s0,16(sp)
    80001d80:	64a2                	ld	s1,8(sp)
    80001d82:	6105                	addi	sp,sp,32
    80001d84:	8082                	ret

0000000080001d86 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d86:	1101                	addi	sp,sp,-32
    80001d88:	ec06                	sd	ra,24(sp)
    80001d8a:	e822                	sd	s0,16(sp)
    80001d8c:	e426                	sd	s1,8(sp)
    80001d8e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d90:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d94:	00074d63          	bltz	a4,80001dae <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d98:	57fd                	li	a5,-1
    80001d9a:	17fe                	slli	a5,a5,0x3f
    80001d9c:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d9e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001da0:	06f70363          	beq	a4,a5,80001e06 <devintr+0x80>
  }
}
    80001da4:	60e2                	ld	ra,24(sp)
    80001da6:	6442                	ld	s0,16(sp)
    80001da8:	64a2                	ld	s1,8(sp)
    80001daa:	6105                	addi	sp,sp,32
    80001dac:	8082                	ret
     (scause & 0xff) == 9){
    80001dae:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001db2:	46a5                	li	a3,9
    80001db4:	fed792e3          	bne	a5,a3,80001d98 <devintr+0x12>
    int irq = plic_claim();
    80001db8:	00003097          	auipc	ra,0x3
    80001dbc:	4e0080e7          	jalr	1248(ra) # 80005298 <plic_claim>
    80001dc0:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001dc2:	47a9                	li	a5,10
    80001dc4:	02f50763          	beq	a0,a5,80001df2 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001dc8:	4785                	li	a5,1
    80001dca:	02f50963          	beq	a0,a5,80001dfc <devintr+0x76>
    return 1;
    80001dce:	4505                	li	a0,1
    } else if(irq){
    80001dd0:	d8f1                	beqz	s1,80001da4 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001dd2:	85a6                	mv	a1,s1
    80001dd4:	00006517          	auipc	a0,0x6
    80001dd8:	4cc50513          	addi	a0,a0,1228 # 800082a0 <states.0+0x38>
    80001ddc:	00004097          	auipc	ra,0x4
    80001de0:	fca080e7          	jalr	-54(ra) # 80005da6 <printf>
      plic_complete(irq);
    80001de4:	8526                	mv	a0,s1
    80001de6:	00003097          	auipc	ra,0x3
    80001dea:	4d6080e7          	jalr	1238(ra) # 800052bc <plic_complete>
    return 1;
    80001dee:	4505                	li	a0,1
    80001df0:	bf55                	j	80001da4 <devintr+0x1e>
      uartintr();
    80001df2:	00004097          	auipc	ra,0x4
    80001df6:	3c2080e7          	jalr	962(ra) # 800061b4 <uartintr>
    80001dfa:	b7ed                	j	80001de4 <devintr+0x5e>
      virtio_disk_intr();
    80001dfc:	00004097          	auipc	ra,0x4
    80001e00:	988080e7          	jalr	-1656(ra) # 80005784 <virtio_disk_intr>
    80001e04:	b7c5                	j	80001de4 <devintr+0x5e>
    if(cpuid() == 0){
    80001e06:	fffff097          	auipc	ra,0xfffff
    80001e0a:	106080e7          	jalr	262(ra) # 80000f0c <cpuid>
    80001e0e:	c901                	beqz	a0,80001e1e <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e10:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e14:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e16:	14479073          	csrw	sip,a5
    return 2;
    80001e1a:	4509                	li	a0,2
    80001e1c:	b761                	j	80001da4 <devintr+0x1e>
      clockintr();
    80001e1e:	00000097          	auipc	ra,0x0
    80001e22:	f22080e7          	jalr	-222(ra) # 80001d40 <clockintr>
    80001e26:	b7ed                	j	80001e10 <devintr+0x8a>

0000000080001e28 <usertrap>:
{
    80001e28:	1101                	addi	sp,sp,-32
    80001e2a:	ec06                	sd	ra,24(sp)
    80001e2c:	e822                	sd	s0,16(sp)
    80001e2e:	e426                	sd	s1,8(sp)
    80001e30:	e04a                	sd	s2,0(sp)
    80001e32:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e34:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e38:	1007f793          	andi	a5,a5,256
    80001e3c:	e3b1                	bnez	a5,80001e80 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e3e:	00003797          	auipc	a5,0x3
    80001e42:	35278793          	addi	a5,a5,850 # 80005190 <kernelvec>
    80001e46:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e4a:	fffff097          	auipc	ra,0xfffff
    80001e4e:	0ee080e7          	jalr	238(ra) # 80000f38 <myproc>
    80001e52:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e54:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e56:	14102773          	csrr	a4,sepc
    80001e5a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e5c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e60:	47a1                	li	a5,8
    80001e62:	02f70763          	beq	a4,a5,80001e90 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001e66:	00000097          	auipc	ra,0x0
    80001e6a:	f20080e7          	jalr	-224(ra) # 80001d86 <devintr>
    80001e6e:	892a                	mv	s2,a0
    80001e70:	c151                	beqz	a0,80001ef4 <usertrap+0xcc>
  if(killed(p))
    80001e72:	8526                	mv	a0,s1
    80001e74:	00000097          	auipc	ra,0x0
    80001e78:	ad0080e7          	jalr	-1328(ra) # 80001944 <killed>
    80001e7c:	c929                	beqz	a0,80001ece <usertrap+0xa6>
    80001e7e:	a099                	j	80001ec4 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001e80:	00006517          	auipc	a0,0x6
    80001e84:	44050513          	addi	a0,a0,1088 # 800082c0 <states.0+0x58>
    80001e88:	00004097          	auipc	ra,0x4
    80001e8c:	ed4080e7          	jalr	-300(ra) # 80005d5c <panic>
    if(killed(p))
    80001e90:	00000097          	auipc	ra,0x0
    80001e94:	ab4080e7          	jalr	-1356(ra) # 80001944 <killed>
    80001e98:	e921                	bnez	a0,80001ee8 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001e9a:	6cb8                	ld	a4,88(s1)
    80001e9c:	6f1c                	ld	a5,24(a4)
    80001e9e:	0791                	addi	a5,a5,4
    80001ea0:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ea2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ea6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001eaa:	10079073          	csrw	sstatus,a5
    syscall();
    80001eae:	00000097          	auipc	ra,0x0
    80001eb2:	2d4080e7          	jalr	724(ra) # 80002182 <syscall>
  if(killed(p))
    80001eb6:	8526                	mv	a0,s1
    80001eb8:	00000097          	auipc	ra,0x0
    80001ebc:	a8c080e7          	jalr	-1396(ra) # 80001944 <killed>
    80001ec0:	c911                	beqz	a0,80001ed4 <usertrap+0xac>
    80001ec2:	4901                	li	s2,0
    exit(-1);
    80001ec4:	557d                	li	a0,-1
    80001ec6:	00000097          	auipc	ra,0x0
    80001eca:	90a080e7          	jalr	-1782(ra) # 800017d0 <exit>
  if(which_dev == 2)
    80001ece:	4789                	li	a5,2
    80001ed0:	04f90f63          	beq	s2,a5,80001f2e <usertrap+0x106>
  usertrapret();
    80001ed4:	00000097          	auipc	ra,0x0
    80001ed8:	dd6080e7          	jalr	-554(ra) # 80001caa <usertrapret>
}
    80001edc:	60e2                	ld	ra,24(sp)
    80001ede:	6442                	ld	s0,16(sp)
    80001ee0:	64a2                	ld	s1,8(sp)
    80001ee2:	6902                	ld	s2,0(sp)
    80001ee4:	6105                	addi	sp,sp,32
    80001ee6:	8082                	ret
      exit(-1);
    80001ee8:	557d                	li	a0,-1
    80001eea:	00000097          	auipc	ra,0x0
    80001eee:	8e6080e7          	jalr	-1818(ra) # 800017d0 <exit>
    80001ef2:	b765                	j	80001e9a <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ef4:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001ef8:	5890                	lw	a2,48(s1)
    80001efa:	00006517          	auipc	a0,0x6
    80001efe:	3e650513          	addi	a0,a0,998 # 800082e0 <states.0+0x78>
    80001f02:	00004097          	auipc	ra,0x4
    80001f06:	ea4080e7          	jalr	-348(ra) # 80005da6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f0a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f0e:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f12:	00006517          	auipc	a0,0x6
    80001f16:	3fe50513          	addi	a0,a0,1022 # 80008310 <states.0+0xa8>
    80001f1a:	00004097          	auipc	ra,0x4
    80001f1e:	e8c080e7          	jalr	-372(ra) # 80005da6 <printf>
    setkilled(p);
    80001f22:	8526                	mv	a0,s1
    80001f24:	00000097          	auipc	ra,0x0
    80001f28:	9f4080e7          	jalr	-1548(ra) # 80001918 <setkilled>
    80001f2c:	b769                	j	80001eb6 <usertrap+0x8e>
    yield();
    80001f2e:	fffff097          	auipc	ra,0xfffff
    80001f32:	732080e7          	jalr	1842(ra) # 80001660 <yield>
    80001f36:	bf79                	j	80001ed4 <usertrap+0xac>

0000000080001f38 <kerneltrap>:
{
    80001f38:	7179                	addi	sp,sp,-48
    80001f3a:	f406                	sd	ra,40(sp)
    80001f3c:	f022                	sd	s0,32(sp)
    80001f3e:	ec26                	sd	s1,24(sp)
    80001f40:	e84a                	sd	s2,16(sp)
    80001f42:	e44e                	sd	s3,8(sp)
    80001f44:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f46:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f4a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f4e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f52:	1004f793          	andi	a5,s1,256
    80001f56:	cb85                	beqz	a5,80001f86 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f58:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f5c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f5e:	ef85                	bnez	a5,80001f96 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f60:	00000097          	auipc	ra,0x0
    80001f64:	e26080e7          	jalr	-474(ra) # 80001d86 <devintr>
    80001f68:	cd1d                	beqz	a0,80001fa6 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f6a:	4789                	li	a5,2
    80001f6c:	06f50a63          	beq	a0,a5,80001fe0 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f70:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f74:	10049073          	csrw	sstatus,s1
}
    80001f78:	70a2                	ld	ra,40(sp)
    80001f7a:	7402                	ld	s0,32(sp)
    80001f7c:	64e2                	ld	s1,24(sp)
    80001f7e:	6942                	ld	s2,16(sp)
    80001f80:	69a2                	ld	s3,8(sp)
    80001f82:	6145                	addi	sp,sp,48
    80001f84:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f86:	00006517          	auipc	a0,0x6
    80001f8a:	3aa50513          	addi	a0,a0,938 # 80008330 <states.0+0xc8>
    80001f8e:	00004097          	auipc	ra,0x4
    80001f92:	dce080e7          	jalr	-562(ra) # 80005d5c <panic>
    panic("kerneltrap: interrupts enabled");
    80001f96:	00006517          	auipc	a0,0x6
    80001f9a:	3c250513          	addi	a0,a0,962 # 80008358 <states.0+0xf0>
    80001f9e:	00004097          	auipc	ra,0x4
    80001fa2:	dbe080e7          	jalr	-578(ra) # 80005d5c <panic>
    printf("scause %p\n", scause);
    80001fa6:	85ce                	mv	a1,s3
    80001fa8:	00006517          	auipc	a0,0x6
    80001fac:	3d050513          	addi	a0,a0,976 # 80008378 <states.0+0x110>
    80001fb0:	00004097          	auipc	ra,0x4
    80001fb4:	df6080e7          	jalr	-522(ra) # 80005da6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fb8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fbc:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fc0:	00006517          	auipc	a0,0x6
    80001fc4:	3c850513          	addi	a0,a0,968 # 80008388 <states.0+0x120>
    80001fc8:	00004097          	auipc	ra,0x4
    80001fcc:	dde080e7          	jalr	-546(ra) # 80005da6 <printf>
    panic("kerneltrap");
    80001fd0:	00006517          	auipc	a0,0x6
    80001fd4:	3d050513          	addi	a0,a0,976 # 800083a0 <states.0+0x138>
    80001fd8:	00004097          	auipc	ra,0x4
    80001fdc:	d84080e7          	jalr	-636(ra) # 80005d5c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fe0:	fffff097          	auipc	ra,0xfffff
    80001fe4:	f58080e7          	jalr	-168(ra) # 80000f38 <myproc>
    80001fe8:	d541                	beqz	a0,80001f70 <kerneltrap+0x38>
    80001fea:	fffff097          	auipc	ra,0xfffff
    80001fee:	f4e080e7          	jalr	-178(ra) # 80000f38 <myproc>
    80001ff2:	4d18                	lw	a4,24(a0)
    80001ff4:	4791                	li	a5,4
    80001ff6:	f6f71de3          	bne	a4,a5,80001f70 <kerneltrap+0x38>
    yield();
    80001ffa:	fffff097          	auipc	ra,0xfffff
    80001ffe:	666080e7          	jalr	1638(ra) # 80001660 <yield>
    80002002:	b7bd                	j	80001f70 <kerneltrap+0x38>

0000000080002004 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002004:	1101                	addi	sp,sp,-32
    80002006:	ec06                	sd	ra,24(sp)
    80002008:	e822                	sd	s0,16(sp)
    8000200a:	e426                	sd	s1,8(sp)
    8000200c:	1000                	addi	s0,sp,32
    8000200e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002010:	fffff097          	auipc	ra,0xfffff
    80002014:	f28080e7          	jalr	-216(ra) # 80000f38 <myproc>
  switch (n) {
    80002018:	4795                	li	a5,5
    8000201a:	0497e163          	bltu	a5,s1,8000205c <argraw+0x58>
    8000201e:	048a                	slli	s1,s1,0x2
    80002020:	00006717          	auipc	a4,0x6
    80002024:	3b870713          	addi	a4,a4,952 # 800083d8 <states.0+0x170>
    80002028:	94ba                	add	s1,s1,a4
    8000202a:	409c                	lw	a5,0(s1)
    8000202c:	97ba                	add	a5,a5,a4
    8000202e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002030:	6d3c                	ld	a5,88(a0)
    80002032:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002034:	60e2                	ld	ra,24(sp)
    80002036:	6442                	ld	s0,16(sp)
    80002038:	64a2                	ld	s1,8(sp)
    8000203a:	6105                	addi	sp,sp,32
    8000203c:	8082                	ret
    return p->trapframe->a1;
    8000203e:	6d3c                	ld	a5,88(a0)
    80002040:	7fa8                	ld	a0,120(a5)
    80002042:	bfcd                	j	80002034 <argraw+0x30>
    return p->trapframe->a2;
    80002044:	6d3c                	ld	a5,88(a0)
    80002046:	63c8                	ld	a0,128(a5)
    80002048:	b7f5                	j	80002034 <argraw+0x30>
    return p->trapframe->a3;
    8000204a:	6d3c                	ld	a5,88(a0)
    8000204c:	67c8                	ld	a0,136(a5)
    8000204e:	b7dd                	j	80002034 <argraw+0x30>
    return p->trapframe->a4;
    80002050:	6d3c                	ld	a5,88(a0)
    80002052:	6bc8                	ld	a0,144(a5)
    80002054:	b7c5                	j	80002034 <argraw+0x30>
    return p->trapframe->a5;
    80002056:	6d3c                	ld	a5,88(a0)
    80002058:	6fc8                	ld	a0,152(a5)
    8000205a:	bfe9                	j	80002034 <argraw+0x30>
  panic("argraw");
    8000205c:	00006517          	auipc	a0,0x6
    80002060:	35450513          	addi	a0,a0,852 # 800083b0 <states.0+0x148>
    80002064:	00004097          	auipc	ra,0x4
    80002068:	cf8080e7          	jalr	-776(ra) # 80005d5c <panic>

000000008000206c <fetchaddr>:
{
    8000206c:	1101                	addi	sp,sp,-32
    8000206e:	ec06                	sd	ra,24(sp)
    80002070:	e822                	sd	s0,16(sp)
    80002072:	e426                	sd	s1,8(sp)
    80002074:	e04a                	sd	s2,0(sp)
    80002076:	1000                	addi	s0,sp,32
    80002078:	84aa                	mv	s1,a0
    8000207a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000207c:	fffff097          	auipc	ra,0xfffff
    80002080:	ebc080e7          	jalr	-324(ra) # 80000f38 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002084:	653c                	ld	a5,72(a0)
    80002086:	02f4f863          	bgeu	s1,a5,800020b6 <fetchaddr+0x4a>
    8000208a:	00848713          	addi	a4,s1,8
    8000208e:	02e7e663          	bltu	a5,a4,800020ba <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002092:	46a1                	li	a3,8
    80002094:	8626                	mv	a2,s1
    80002096:	85ca                	mv	a1,s2
    80002098:	6928                	ld	a0,80(a0)
    8000209a:	fffff097          	auipc	ra,0xfffff
    8000209e:	b06080e7          	jalr	-1274(ra) # 80000ba0 <copyin>
    800020a2:	00a03533          	snez	a0,a0
    800020a6:	40a00533          	neg	a0,a0
}
    800020aa:	60e2                	ld	ra,24(sp)
    800020ac:	6442                	ld	s0,16(sp)
    800020ae:	64a2                	ld	s1,8(sp)
    800020b0:	6902                	ld	s2,0(sp)
    800020b2:	6105                	addi	sp,sp,32
    800020b4:	8082                	ret
    return -1;
    800020b6:	557d                	li	a0,-1
    800020b8:	bfcd                	j	800020aa <fetchaddr+0x3e>
    800020ba:	557d                	li	a0,-1
    800020bc:	b7fd                	j	800020aa <fetchaddr+0x3e>

00000000800020be <fetchstr>:
{
    800020be:	7179                	addi	sp,sp,-48
    800020c0:	f406                	sd	ra,40(sp)
    800020c2:	f022                	sd	s0,32(sp)
    800020c4:	ec26                	sd	s1,24(sp)
    800020c6:	e84a                	sd	s2,16(sp)
    800020c8:	e44e                	sd	s3,8(sp)
    800020ca:	1800                	addi	s0,sp,48
    800020cc:	892a                	mv	s2,a0
    800020ce:	84ae                	mv	s1,a1
    800020d0:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800020d2:	fffff097          	auipc	ra,0xfffff
    800020d6:	e66080e7          	jalr	-410(ra) # 80000f38 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800020da:	86ce                	mv	a3,s3
    800020dc:	864a                	mv	a2,s2
    800020de:	85a6                	mv	a1,s1
    800020e0:	6928                	ld	a0,80(a0)
    800020e2:	fffff097          	auipc	ra,0xfffff
    800020e6:	b4c080e7          	jalr	-1204(ra) # 80000c2e <copyinstr>
    800020ea:	00054e63          	bltz	a0,80002106 <fetchstr+0x48>
  return strlen(buf);
    800020ee:	8526                	mv	a0,s1
    800020f0:	ffffe097          	auipc	ra,0xffffe
    800020f4:	206080e7          	jalr	518(ra) # 800002f6 <strlen>
}
    800020f8:	70a2                	ld	ra,40(sp)
    800020fa:	7402                	ld	s0,32(sp)
    800020fc:	64e2                	ld	s1,24(sp)
    800020fe:	6942                	ld	s2,16(sp)
    80002100:	69a2                	ld	s3,8(sp)
    80002102:	6145                	addi	sp,sp,48
    80002104:	8082                	ret
    return -1;
    80002106:	557d                	li	a0,-1
    80002108:	bfc5                	j	800020f8 <fetchstr+0x3a>

000000008000210a <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000210a:	1101                	addi	sp,sp,-32
    8000210c:	ec06                	sd	ra,24(sp)
    8000210e:	e822                	sd	s0,16(sp)
    80002110:	e426                	sd	s1,8(sp)
    80002112:	1000                	addi	s0,sp,32
    80002114:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002116:	00000097          	auipc	ra,0x0
    8000211a:	eee080e7          	jalr	-274(ra) # 80002004 <argraw>
    8000211e:	c088                	sw	a0,0(s1)
}
    80002120:	60e2                	ld	ra,24(sp)
    80002122:	6442                	ld	s0,16(sp)
    80002124:	64a2                	ld	s1,8(sp)
    80002126:	6105                	addi	sp,sp,32
    80002128:	8082                	ret

000000008000212a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000212a:	1101                	addi	sp,sp,-32
    8000212c:	ec06                	sd	ra,24(sp)
    8000212e:	e822                	sd	s0,16(sp)
    80002130:	e426                	sd	s1,8(sp)
    80002132:	1000                	addi	s0,sp,32
    80002134:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002136:	00000097          	auipc	ra,0x0
    8000213a:	ece080e7          	jalr	-306(ra) # 80002004 <argraw>
    8000213e:	e088                	sd	a0,0(s1)
}
    80002140:	60e2                	ld	ra,24(sp)
    80002142:	6442                	ld	s0,16(sp)
    80002144:	64a2                	ld	s1,8(sp)
    80002146:	6105                	addi	sp,sp,32
    80002148:	8082                	ret

000000008000214a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000214a:	7179                	addi	sp,sp,-48
    8000214c:	f406                	sd	ra,40(sp)
    8000214e:	f022                	sd	s0,32(sp)
    80002150:	ec26                	sd	s1,24(sp)
    80002152:	e84a                	sd	s2,16(sp)
    80002154:	1800                	addi	s0,sp,48
    80002156:	84ae                	mv	s1,a1
    80002158:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000215a:	fd840593          	addi	a1,s0,-40
    8000215e:	00000097          	auipc	ra,0x0
    80002162:	fcc080e7          	jalr	-52(ra) # 8000212a <argaddr>
  return fetchstr(addr, buf, max);
    80002166:	864a                	mv	a2,s2
    80002168:	85a6                	mv	a1,s1
    8000216a:	fd843503          	ld	a0,-40(s0)
    8000216e:	00000097          	auipc	ra,0x0
    80002172:	f50080e7          	jalr	-176(ra) # 800020be <fetchstr>
}
    80002176:	70a2                	ld	ra,40(sp)
    80002178:	7402                	ld	s0,32(sp)
    8000217a:	64e2                	ld	s1,24(sp)
    8000217c:	6942                	ld	s2,16(sp)
    8000217e:	6145                	addi	sp,sp,48
    80002180:	8082                	ret

0000000080002182 <syscall>:



void
syscall(void)
{
    80002182:	1101                	addi	sp,sp,-32
    80002184:	ec06                	sd	ra,24(sp)
    80002186:	e822                	sd	s0,16(sp)
    80002188:	e426                	sd	s1,8(sp)
    8000218a:	e04a                	sd	s2,0(sp)
    8000218c:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000218e:	fffff097          	auipc	ra,0xfffff
    80002192:	daa080e7          	jalr	-598(ra) # 80000f38 <myproc>
    80002196:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002198:	05853903          	ld	s2,88(a0)
    8000219c:	0a893783          	ld	a5,168(s2)
    800021a0:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800021a4:	37fd                	addiw	a5,a5,-1
    800021a6:	4775                	li	a4,29
    800021a8:	00f76f63          	bltu	a4,a5,800021c6 <syscall+0x44>
    800021ac:	00369713          	slli	a4,a3,0x3
    800021b0:	00006797          	auipc	a5,0x6
    800021b4:	24078793          	addi	a5,a5,576 # 800083f0 <syscalls>
    800021b8:	97ba                	add	a5,a5,a4
    800021ba:	639c                	ld	a5,0(a5)
    800021bc:	c789                	beqz	a5,800021c6 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800021be:	9782                	jalr	a5
    800021c0:	06a93823          	sd	a0,112(s2)
    800021c4:	a839                	j	800021e2 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800021c6:	15848613          	addi	a2,s1,344
    800021ca:	588c                	lw	a1,48(s1)
    800021cc:	00006517          	auipc	a0,0x6
    800021d0:	1ec50513          	addi	a0,a0,492 # 800083b8 <states.0+0x150>
    800021d4:	00004097          	auipc	ra,0x4
    800021d8:	bd2080e7          	jalr	-1070(ra) # 80005da6 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800021dc:	6cbc                	ld	a5,88(s1)
    800021de:	577d                	li	a4,-1
    800021e0:	fbb8                	sd	a4,112(a5)
  }
}
    800021e2:	60e2                	ld	ra,24(sp)
    800021e4:	6442                	ld	s0,16(sp)
    800021e6:	64a2                	ld	s1,8(sp)
    800021e8:	6902                	ld	s2,0(sp)
    800021ea:	6105                	addi	sp,sp,32
    800021ec:	8082                	ret

00000000800021ee <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800021ee:	1101                	addi	sp,sp,-32
    800021f0:	ec06                	sd	ra,24(sp)
    800021f2:	e822                	sd	s0,16(sp)
    800021f4:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800021f6:	fec40593          	addi	a1,s0,-20
    800021fa:	4501                	li	a0,0
    800021fc:	00000097          	auipc	ra,0x0
    80002200:	f0e080e7          	jalr	-242(ra) # 8000210a <argint>
  exit(n);
    80002204:	fec42503          	lw	a0,-20(s0)
    80002208:	fffff097          	auipc	ra,0xfffff
    8000220c:	5c8080e7          	jalr	1480(ra) # 800017d0 <exit>
  return 0;  // not reached
}
    80002210:	4501                	li	a0,0
    80002212:	60e2                	ld	ra,24(sp)
    80002214:	6442                	ld	s0,16(sp)
    80002216:	6105                	addi	sp,sp,32
    80002218:	8082                	ret

000000008000221a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000221a:	1141                	addi	sp,sp,-16
    8000221c:	e406                	sd	ra,8(sp)
    8000221e:	e022                	sd	s0,0(sp)
    80002220:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002222:	fffff097          	auipc	ra,0xfffff
    80002226:	d16080e7          	jalr	-746(ra) # 80000f38 <myproc>
}
    8000222a:	5908                	lw	a0,48(a0)
    8000222c:	60a2                	ld	ra,8(sp)
    8000222e:	6402                	ld	s0,0(sp)
    80002230:	0141                	addi	sp,sp,16
    80002232:	8082                	ret

0000000080002234 <sys_fork>:

uint64
sys_fork(void)
{
    80002234:	1141                	addi	sp,sp,-16
    80002236:	e406                	sd	ra,8(sp)
    80002238:	e022                	sd	s0,0(sp)
    8000223a:	0800                	addi	s0,sp,16
  return fork();
    8000223c:	fffff097          	auipc	ra,0xfffff
    80002240:	16e080e7          	jalr	366(ra) # 800013aa <fork>
}
    80002244:	60a2                	ld	ra,8(sp)
    80002246:	6402                	ld	s0,0(sp)
    80002248:	0141                	addi	sp,sp,16
    8000224a:	8082                	ret

000000008000224c <sys_wait>:

uint64
sys_wait(void)
{
    8000224c:	1101                	addi	sp,sp,-32
    8000224e:	ec06                	sd	ra,24(sp)
    80002250:	e822                	sd	s0,16(sp)
    80002252:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002254:	fe840593          	addi	a1,s0,-24
    80002258:	4501                	li	a0,0
    8000225a:	00000097          	auipc	ra,0x0
    8000225e:	ed0080e7          	jalr	-304(ra) # 8000212a <argaddr>
  return wait(p);
    80002262:	fe843503          	ld	a0,-24(s0)
    80002266:	fffff097          	auipc	ra,0xfffff
    8000226a:	710080e7          	jalr	1808(ra) # 80001976 <wait>
}
    8000226e:	60e2                	ld	ra,24(sp)
    80002270:	6442                	ld	s0,16(sp)
    80002272:	6105                	addi	sp,sp,32
    80002274:	8082                	ret

0000000080002276 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002276:	7179                	addi	sp,sp,-48
    80002278:	f406                	sd	ra,40(sp)
    8000227a:	f022                	sd	s0,32(sp)
    8000227c:	ec26                	sd	s1,24(sp)
    8000227e:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002280:	fdc40593          	addi	a1,s0,-36
    80002284:	4501                	li	a0,0
    80002286:	00000097          	auipc	ra,0x0
    8000228a:	e84080e7          	jalr	-380(ra) # 8000210a <argint>
  addr = myproc()->sz;
    8000228e:	fffff097          	auipc	ra,0xfffff
    80002292:	caa080e7          	jalr	-854(ra) # 80000f38 <myproc>
    80002296:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002298:	fdc42503          	lw	a0,-36(s0)
    8000229c:	fffff097          	auipc	ra,0xfffff
    800022a0:	0b2080e7          	jalr	178(ra) # 8000134e <growproc>
    800022a4:	00054863          	bltz	a0,800022b4 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800022a8:	8526                	mv	a0,s1
    800022aa:	70a2                	ld	ra,40(sp)
    800022ac:	7402                	ld	s0,32(sp)
    800022ae:	64e2                	ld	s1,24(sp)
    800022b0:	6145                	addi	sp,sp,48
    800022b2:	8082                	ret
    return -1;
    800022b4:	54fd                	li	s1,-1
    800022b6:	bfcd                	j	800022a8 <sys_sbrk+0x32>

00000000800022b8 <sys_sleep>:

uint64
sys_sleep(void)
{
    800022b8:	7139                	addi	sp,sp,-64
    800022ba:	fc06                	sd	ra,56(sp)
    800022bc:	f822                	sd	s0,48(sp)
    800022be:	f426                	sd	s1,40(sp)
    800022c0:	f04a                	sd	s2,32(sp)
    800022c2:	ec4e                	sd	s3,24(sp)
    800022c4:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  argint(0, &n);
    800022c6:	fcc40593          	addi	a1,s0,-52
    800022ca:	4501                	li	a0,0
    800022cc:	00000097          	auipc	ra,0x0
    800022d0:	e3e080e7          	jalr	-450(ra) # 8000210a <argint>
  acquire(&tickslock);
    800022d4:	0000c517          	auipc	a0,0xc
    800022d8:	6cc50513          	addi	a0,a0,1740 # 8000e9a0 <tickslock>
    800022dc:	00004097          	auipc	ra,0x4
    800022e0:	fb8080e7          	jalr	-72(ra) # 80006294 <acquire>
  ticks0 = ticks;
    800022e4:	00006917          	auipc	s2,0x6
    800022e8:	65492903          	lw	s2,1620(s2) # 80008938 <ticks>
  while(ticks - ticks0 < n){
    800022ec:	fcc42783          	lw	a5,-52(s0)
    800022f0:	cf9d                	beqz	a5,8000232e <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022f2:	0000c997          	auipc	s3,0xc
    800022f6:	6ae98993          	addi	s3,s3,1710 # 8000e9a0 <tickslock>
    800022fa:	00006497          	auipc	s1,0x6
    800022fe:	63e48493          	addi	s1,s1,1598 # 80008938 <ticks>
    if(killed(myproc())){
    80002302:	fffff097          	auipc	ra,0xfffff
    80002306:	c36080e7          	jalr	-970(ra) # 80000f38 <myproc>
    8000230a:	fffff097          	auipc	ra,0xfffff
    8000230e:	63a080e7          	jalr	1594(ra) # 80001944 <killed>
    80002312:	ed15                	bnez	a0,8000234e <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80002314:	85ce                	mv	a1,s3
    80002316:	8526                	mv	a0,s1
    80002318:	fffff097          	auipc	ra,0xfffff
    8000231c:	384080e7          	jalr	900(ra) # 8000169c <sleep>
  while(ticks - ticks0 < n){
    80002320:	409c                	lw	a5,0(s1)
    80002322:	412787bb          	subw	a5,a5,s2
    80002326:	fcc42703          	lw	a4,-52(s0)
    8000232a:	fce7ece3          	bltu	a5,a4,80002302 <sys_sleep+0x4a>
  }
  release(&tickslock);
    8000232e:	0000c517          	auipc	a0,0xc
    80002332:	67250513          	addi	a0,a0,1650 # 8000e9a0 <tickslock>
    80002336:	00004097          	auipc	ra,0x4
    8000233a:	012080e7          	jalr	18(ra) # 80006348 <release>
  return 0;
    8000233e:	4501                	li	a0,0
}
    80002340:	70e2                	ld	ra,56(sp)
    80002342:	7442                	ld	s0,48(sp)
    80002344:	74a2                	ld	s1,40(sp)
    80002346:	7902                	ld	s2,32(sp)
    80002348:	69e2                	ld	s3,24(sp)
    8000234a:	6121                	addi	sp,sp,64
    8000234c:	8082                	ret
      release(&tickslock);
    8000234e:	0000c517          	auipc	a0,0xc
    80002352:	65250513          	addi	a0,a0,1618 # 8000e9a0 <tickslock>
    80002356:	00004097          	auipc	ra,0x4
    8000235a:	ff2080e7          	jalr	-14(ra) # 80006348 <release>
      return -1;
    8000235e:	557d                	li	a0,-1
    80002360:	b7c5                	j	80002340 <sys_sleep+0x88>

0000000080002362 <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    80002362:	1141                	addi	sp,sp,-16
    80002364:	e422                	sd	s0,8(sp)
    80002366:	0800                	addi	s0,sp,16
  // lab pgtbl: your code here.
  return 0;
}
    80002368:	4501                	li	a0,0
    8000236a:	6422                	ld	s0,8(sp)
    8000236c:	0141                	addi	sp,sp,16
    8000236e:	8082                	ret

0000000080002370 <sys_kill>:
#endif

uint64
sys_kill(void)
{
    80002370:	1101                	addi	sp,sp,-32
    80002372:	ec06                	sd	ra,24(sp)
    80002374:	e822                	sd	s0,16(sp)
    80002376:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002378:	fec40593          	addi	a1,s0,-20
    8000237c:	4501                	li	a0,0
    8000237e:	00000097          	auipc	ra,0x0
    80002382:	d8c080e7          	jalr	-628(ra) # 8000210a <argint>
  return kill(pid);
    80002386:	fec42503          	lw	a0,-20(s0)
    8000238a:	fffff097          	auipc	ra,0xfffff
    8000238e:	51c080e7          	jalr	1308(ra) # 800018a6 <kill>
}
    80002392:	60e2                	ld	ra,24(sp)
    80002394:	6442                	ld	s0,16(sp)
    80002396:	6105                	addi	sp,sp,32
    80002398:	8082                	ret

000000008000239a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000239a:	1101                	addi	sp,sp,-32
    8000239c:	ec06                	sd	ra,24(sp)
    8000239e:	e822                	sd	s0,16(sp)
    800023a0:	e426                	sd	s1,8(sp)
    800023a2:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800023a4:	0000c517          	auipc	a0,0xc
    800023a8:	5fc50513          	addi	a0,a0,1532 # 8000e9a0 <tickslock>
    800023ac:	00004097          	auipc	ra,0x4
    800023b0:	ee8080e7          	jalr	-280(ra) # 80006294 <acquire>
  xticks = ticks;
    800023b4:	00006497          	auipc	s1,0x6
    800023b8:	5844a483          	lw	s1,1412(s1) # 80008938 <ticks>
  release(&tickslock);
    800023bc:	0000c517          	auipc	a0,0xc
    800023c0:	5e450513          	addi	a0,a0,1508 # 8000e9a0 <tickslock>
    800023c4:	00004097          	auipc	ra,0x4
    800023c8:	f84080e7          	jalr	-124(ra) # 80006348 <release>
  return xticks;
}
    800023cc:	02049513          	slli	a0,s1,0x20
    800023d0:	9101                	srli	a0,a0,0x20
    800023d2:	60e2                	ld	ra,24(sp)
    800023d4:	6442                	ld	s0,16(sp)
    800023d6:	64a2                	ld	s1,8(sp)
    800023d8:	6105                	addi	sp,sp,32
    800023da:	8082                	ret

00000000800023dc <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800023dc:	7179                	addi	sp,sp,-48
    800023de:	f406                	sd	ra,40(sp)
    800023e0:	f022                	sd	s0,32(sp)
    800023e2:	ec26                	sd	s1,24(sp)
    800023e4:	e84a                	sd	s2,16(sp)
    800023e6:	e44e                	sd	s3,8(sp)
    800023e8:	e052                	sd	s4,0(sp)
    800023ea:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800023ec:	00006597          	auipc	a1,0x6
    800023f0:	0fc58593          	addi	a1,a1,252 # 800084e8 <syscalls+0xf8>
    800023f4:	0000c517          	auipc	a0,0xc
    800023f8:	5c450513          	addi	a0,a0,1476 # 8000e9b8 <bcache>
    800023fc:	00004097          	auipc	ra,0x4
    80002400:	e08080e7          	jalr	-504(ra) # 80006204 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002404:	00014797          	auipc	a5,0x14
    80002408:	5b478793          	addi	a5,a5,1460 # 800169b8 <bcache+0x8000>
    8000240c:	00015717          	auipc	a4,0x15
    80002410:	81470713          	addi	a4,a4,-2028 # 80016c20 <bcache+0x8268>
    80002414:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002418:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000241c:	0000c497          	auipc	s1,0xc
    80002420:	5b448493          	addi	s1,s1,1460 # 8000e9d0 <bcache+0x18>
    b->next = bcache.head.next;
    80002424:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002426:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002428:	00006a17          	auipc	s4,0x6
    8000242c:	0c8a0a13          	addi	s4,s4,200 # 800084f0 <syscalls+0x100>
    b->next = bcache.head.next;
    80002430:	2b893783          	ld	a5,696(s2)
    80002434:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002436:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000243a:	85d2                	mv	a1,s4
    8000243c:	01048513          	addi	a0,s1,16
    80002440:	00001097          	auipc	ra,0x1
    80002444:	4c8080e7          	jalr	1224(ra) # 80003908 <initsleeplock>
    bcache.head.next->prev = b;
    80002448:	2b893783          	ld	a5,696(s2)
    8000244c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000244e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002452:	45848493          	addi	s1,s1,1112
    80002456:	fd349de3          	bne	s1,s3,80002430 <binit+0x54>
  }
}
    8000245a:	70a2                	ld	ra,40(sp)
    8000245c:	7402                	ld	s0,32(sp)
    8000245e:	64e2                	ld	s1,24(sp)
    80002460:	6942                	ld	s2,16(sp)
    80002462:	69a2                	ld	s3,8(sp)
    80002464:	6a02                	ld	s4,0(sp)
    80002466:	6145                	addi	sp,sp,48
    80002468:	8082                	ret

000000008000246a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000246a:	7179                	addi	sp,sp,-48
    8000246c:	f406                	sd	ra,40(sp)
    8000246e:	f022                	sd	s0,32(sp)
    80002470:	ec26                	sd	s1,24(sp)
    80002472:	e84a                	sd	s2,16(sp)
    80002474:	e44e                	sd	s3,8(sp)
    80002476:	1800                	addi	s0,sp,48
    80002478:	892a                	mv	s2,a0
    8000247a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000247c:	0000c517          	auipc	a0,0xc
    80002480:	53c50513          	addi	a0,a0,1340 # 8000e9b8 <bcache>
    80002484:	00004097          	auipc	ra,0x4
    80002488:	e10080e7          	jalr	-496(ra) # 80006294 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000248c:	00014497          	auipc	s1,0x14
    80002490:	7e44b483          	ld	s1,2020(s1) # 80016c70 <bcache+0x82b8>
    80002494:	00014797          	auipc	a5,0x14
    80002498:	78c78793          	addi	a5,a5,1932 # 80016c20 <bcache+0x8268>
    8000249c:	02f48f63          	beq	s1,a5,800024da <bread+0x70>
    800024a0:	873e                	mv	a4,a5
    800024a2:	a021                	j	800024aa <bread+0x40>
    800024a4:	68a4                	ld	s1,80(s1)
    800024a6:	02e48a63          	beq	s1,a4,800024da <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800024aa:	449c                	lw	a5,8(s1)
    800024ac:	ff279ce3          	bne	a5,s2,800024a4 <bread+0x3a>
    800024b0:	44dc                	lw	a5,12(s1)
    800024b2:	ff3799e3          	bne	a5,s3,800024a4 <bread+0x3a>
      b->refcnt++;
    800024b6:	40bc                	lw	a5,64(s1)
    800024b8:	2785                	addiw	a5,a5,1
    800024ba:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024bc:	0000c517          	auipc	a0,0xc
    800024c0:	4fc50513          	addi	a0,a0,1276 # 8000e9b8 <bcache>
    800024c4:	00004097          	auipc	ra,0x4
    800024c8:	e84080e7          	jalr	-380(ra) # 80006348 <release>
      acquiresleep(&b->lock);
    800024cc:	01048513          	addi	a0,s1,16
    800024d0:	00001097          	auipc	ra,0x1
    800024d4:	472080e7          	jalr	1138(ra) # 80003942 <acquiresleep>
      return b;
    800024d8:	a8b9                	j	80002536 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024da:	00014497          	auipc	s1,0x14
    800024de:	78e4b483          	ld	s1,1934(s1) # 80016c68 <bcache+0x82b0>
    800024e2:	00014797          	auipc	a5,0x14
    800024e6:	73e78793          	addi	a5,a5,1854 # 80016c20 <bcache+0x8268>
    800024ea:	00f48863          	beq	s1,a5,800024fa <bread+0x90>
    800024ee:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800024f0:	40bc                	lw	a5,64(s1)
    800024f2:	cf81                	beqz	a5,8000250a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024f4:	64a4                	ld	s1,72(s1)
    800024f6:	fee49de3          	bne	s1,a4,800024f0 <bread+0x86>
  panic("bget: no buffers");
    800024fa:	00006517          	auipc	a0,0x6
    800024fe:	ffe50513          	addi	a0,a0,-2 # 800084f8 <syscalls+0x108>
    80002502:	00004097          	auipc	ra,0x4
    80002506:	85a080e7          	jalr	-1958(ra) # 80005d5c <panic>
      b->dev = dev;
    8000250a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000250e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002512:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002516:	4785                	li	a5,1
    80002518:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000251a:	0000c517          	auipc	a0,0xc
    8000251e:	49e50513          	addi	a0,a0,1182 # 8000e9b8 <bcache>
    80002522:	00004097          	auipc	ra,0x4
    80002526:	e26080e7          	jalr	-474(ra) # 80006348 <release>
      acquiresleep(&b->lock);
    8000252a:	01048513          	addi	a0,s1,16
    8000252e:	00001097          	auipc	ra,0x1
    80002532:	414080e7          	jalr	1044(ra) # 80003942 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002536:	409c                	lw	a5,0(s1)
    80002538:	cb89                	beqz	a5,8000254a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000253a:	8526                	mv	a0,s1
    8000253c:	70a2                	ld	ra,40(sp)
    8000253e:	7402                	ld	s0,32(sp)
    80002540:	64e2                	ld	s1,24(sp)
    80002542:	6942                	ld	s2,16(sp)
    80002544:	69a2                	ld	s3,8(sp)
    80002546:	6145                	addi	sp,sp,48
    80002548:	8082                	ret
    virtio_disk_rw(b, 0);
    8000254a:	4581                	li	a1,0
    8000254c:	8526                	mv	a0,s1
    8000254e:	00003097          	auipc	ra,0x3
    80002552:	004080e7          	jalr	4(ra) # 80005552 <virtio_disk_rw>
    b->valid = 1;
    80002556:	4785                	li	a5,1
    80002558:	c09c                	sw	a5,0(s1)
  return b;
    8000255a:	b7c5                	j	8000253a <bread+0xd0>

000000008000255c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000255c:	1101                	addi	sp,sp,-32
    8000255e:	ec06                	sd	ra,24(sp)
    80002560:	e822                	sd	s0,16(sp)
    80002562:	e426                	sd	s1,8(sp)
    80002564:	1000                	addi	s0,sp,32
    80002566:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002568:	0541                	addi	a0,a0,16
    8000256a:	00001097          	auipc	ra,0x1
    8000256e:	472080e7          	jalr	1138(ra) # 800039dc <holdingsleep>
    80002572:	cd01                	beqz	a0,8000258a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002574:	4585                	li	a1,1
    80002576:	8526                	mv	a0,s1
    80002578:	00003097          	auipc	ra,0x3
    8000257c:	fda080e7          	jalr	-38(ra) # 80005552 <virtio_disk_rw>
}
    80002580:	60e2                	ld	ra,24(sp)
    80002582:	6442                	ld	s0,16(sp)
    80002584:	64a2                	ld	s1,8(sp)
    80002586:	6105                	addi	sp,sp,32
    80002588:	8082                	ret
    panic("bwrite");
    8000258a:	00006517          	auipc	a0,0x6
    8000258e:	f8650513          	addi	a0,a0,-122 # 80008510 <syscalls+0x120>
    80002592:	00003097          	auipc	ra,0x3
    80002596:	7ca080e7          	jalr	1994(ra) # 80005d5c <panic>

000000008000259a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000259a:	1101                	addi	sp,sp,-32
    8000259c:	ec06                	sd	ra,24(sp)
    8000259e:	e822                	sd	s0,16(sp)
    800025a0:	e426                	sd	s1,8(sp)
    800025a2:	e04a                	sd	s2,0(sp)
    800025a4:	1000                	addi	s0,sp,32
    800025a6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025a8:	01050913          	addi	s2,a0,16
    800025ac:	854a                	mv	a0,s2
    800025ae:	00001097          	auipc	ra,0x1
    800025b2:	42e080e7          	jalr	1070(ra) # 800039dc <holdingsleep>
    800025b6:	c92d                	beqz	a0,80002628 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800025b8:	854a                	mv	a0,s2
    800025ba:	00001097          	auipc	ra,0x1
    800025be:	3de080e7          	jalr	990(ra) # 80003998 <releasesleep>

  acquire(&bcache.lock);
    800025c2:	0000c517          	auipc	a0,0xc
    800025c6:	3f650513          	addi	a0,a0,1014 # 8000e9b8 <bcache>
    800025ca:	00004097          	auipc	ra,0x4
    800025ce:	cca080e7          	jalr	-822(ra) # 80006294 <acquire>
  b->refcnt--;
    800025d2:	40bc                	lw	a5,64(s1)
    800025d4:	37fd                	addiw	a5,a5,-1
    800025d6:	0007871b          	sext.w	a4,a5
    800025da:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800025dc:	eb05                	bnez	a4,8000260c <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800025de:	68bc                	ld	a5,80(s1)
    800025e0:	64b8                	ld	a4,72(s1)
    800025e2:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800025e4:	64bc                	ld	a5,72(s1)
    800025e6:	68b8                	ld	a4,80(s1)
    800025e8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800025ea:	00014797          	auipc	a5,0x14
    800025ee:	3ce78793          	addi	a5,a5,974 # 800169b8 <bcache+0x8000>
    800025f2:	2b87b703          	ld	a4,696(a5)
    800025f6:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025f8:	00014717          	auipc	a4,0x14
    800025fc:	62870713          	addi	a4,a4,1576 # 80016c20 <bcache+0x8268>
    80002600:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002602:	2b87b703          	ld	a4,696(a5)
    80002606:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002608:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000260c:	0000c517          	auipc	a0,0xc
    80002610:	3ac50513          	addi	a0,a0,940 # 8000e9b8 <bcache>
    80002614:	00004097          	auipc	ra,0x4
    80002618:	d34080e7          	jalr	-716(ra) # 80006348 <release>
}
    8000261c:	60e2                	ld	ra,24(sp)
    8000261e:	6442                	ld	s0,16(sp)
    80002620:	64a2                	ld	s1,8(sp)
    80002622:	6902                	ld	s2,0(sp)
    80002624:	6105                	addi	sp,sp,32
    80002626:	8082                	ret
    panic("brelse");
    80002628:	00006517          	auipc	a0,0x6
    8000262c:	ef050513          	addi	a0,a0,-272 # 80008518 <syscalls+0x128>
    80002630:	00003097          	auipc	ra,0x3
    80002634:	72c080e7          	jalr	1836(ra) # 80005d5c <panic>

0000000080002638 <bpin>:

void
bpin(struct buf *b) {
    80002638:	1101                	addi	sp,sp,-32
    8000263a:	ec06                	sd	ra,24(sp)
    8000263c:	e822                	sd	s0,16(sp)
    8000263e:	e426                	sd	s1,8(sp)
    80002640:	1000                	addi	s0,sp,32
    80002642:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002644:	0000c517          	auipc	a0,0xc
    80002648:	37450513          	addi	a0,a0,884 # 8000e9b8 <bcache>
    8000264c:	00004097          	auipc	ra,0x4
    80002650:	c48080e7          	jalr	-952(ra) # 80006294 <acquire>
  b->refcnt++;
    80002654:	40bc                	lw	a5,64(s1)
    80002656:	2785                	addiw	a5,a5,1
    80002658:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000265a:	0000c517          	auipc	a0,0xc
    8000265e:	35e50513          	addi	a0,a0,862 # 8000e9b8 <bcache>
    80002662:	00004097          	auipc	ra,0x4
    80002666:	ce6080e7          	jalr	-794(ra) # 80006348 <release>
}
    8000266a:	60e2                	ld	ra,24(sp)
    8000266c:	6442                	ld	s0,16(sp)
    8000266e:	64a2                	ld	s1,8(sp)
    80002670:	6105                	addi	sp,sp,32
    80002672:	8082                	ret

0000000080002674 <bunpin>:

void
bunpin(struct buf *b) {
    80002674:	1101                	addi	sp,sp,-32
    80002676:	ec06                	sd	ra,24(sp)
    80002678:	e822                	sd	s0,16(sp)
    8000267a:	e426                	sd	s1,8(sp)
    8000267c:	1000                	addi	s0,sp,32
    8000267e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002680:	0000c517          	auipc	a0,0xc
    80002684:	33850513          	addi	a0,a0,824 # 8000e9b8 <bcache>
    80002688:	00004097          	auipc	ra,0x4
    8000268c:	c0c080e7          	jalr	-1012(ra) # 80006294 <acquire>
  b->refcnt--;
    80002690:	40bc                	lw	a5,64(s1)
    80002692:	37fd                	addiw	a5,a5,-1
    80002694:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002696:	0000c517          	auipc	a0,0xc
    8000269a:	32250513          	addi	a0,a0,802 # 8000e9b8 <bcache>
    8000269e:	00004097          	auipc	ra,0x4
    800026a2:	caa080e7          	jalr	-854(ra) # 80006348 <release>
}
    800026a6:	60e2                	ld	ra,24(sp)
    800026a8:	6442                	ld	s0,16(sp)
    800026aa:	64a2                	ld	s1,8(sp)
    800026ac:	6105                	addi	sp,sp,32
    800026ae:	8082                	ret

00000000800026b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800026b0:	1101                	addi	sp,sp,-32
    800026b2:	ec06                	sd	ra,24(sp)
    800026b4:	e822                	sd	s0,16(sp)
    800026b6:	e426                	sd	s1,8(sp)
    800026b8:	e04a                	sd	s2,0(sp)
    800026ba:	1000                	addi	s0,sp,32
    800026bc:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800026be:	00d5d59b          	srliw	a1,a1,0xd
    800026c2:	00015797          	auipc	a5,0x15
    800026c6:	9d27a783          	lw	a5,-1582(a5) # 80017094 <sb+0x1c>
    800026ca:	9dbd                	addw	a1,a1,a5
    800026cc:	00000097          	auipc	ra,0x0
    800026d0:	d9e080e7          	jalr	-610(ra) # 8000246a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800026d4:	0074f713          	andi	a4,s1,7
    800026d8:	4785                	li	a5,1
    800026da:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800026de:	14ce                	slli	s1,s1,0x33
    800026e0:	90d9                	srli	s1,s1,0x36
    800026e2:	00950733          	add	a4,a0,s1
    800026e6:	05874703          	lbu	a4,88(a4)
    800026ea:	00e7f6b3          	and	a3,a5,a4
    800026ee:	c69d                	beqz	a3,8000271c <bfree+0x6c>
    800026f0:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800026f2:	94aa                	add	s1,s1,a0
    800026f4:	fff7c793          	not	a5,a5
    800026f8:	8f7d                	and	a4,a4,a5
    800026fa:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800026fe:	00001097          	auipc	ra,0x1
    80002702:	126080e7          	jalr	294(ra) # 80003824 <log_write>
  brelse(bp);
    80002706:	854a                	mv	a0,s2
    80002708:	00000097          	auipc	ra,0x0
    8000270c:	e92080e7          	jalr	-366(ra) # 8000259a <brelse>
}
    80002710:	60e2                	ld	ra,24(sp)
    80002712:	6442                	ld	s0,16(sp)
    80002714:	64a2                	ld	s1,8(sp)
    80002716:	6902                	ld	s2,0(sp)
    80002718:	6105                	addi	sp,sp,32
    8000271a:	8082                	ret
    panic("freeing free block");
    8000271c:	00006517          	auipc	a0,0x6
    80002720:	e0450513          	addi	a0,a0,-508 # 80008520 <syscalls+0x130>
    80002724:	00003097          	auipc	ra,0x3
    80002728:	638080e7          	jalr	1592(ra) # 80005d5c <panic>

000000008000272c <balloc>:
{
    8000272c:	711d                	addi	sp,sp,-96
    8000272e:	ec86                	sd	ra,88(sp)
    80002730:	e8a2                	sd	s0,80(sp)
    80002732:	e4a6                	sd	s1,72(sp)
    80002734:	e0ca                	sd	s2,64(sp)
    80002736:	fc4e                	sd	s3,56(sp)
    80002738:	f852                	sd	s4,48(sp)
    8000273a:	f456                	sd	s5,40(sp)
    8000273c:	f05a                	sd	s6,32(sp)
    8000273e:	ec5e                	sd	s7,24(sp)
    80002740:	e862                	sd	s8,16(sp)
    80002742:	e466                	sd	s9,8(sp)
    80002744:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002746:	00015797          	auipc	a5,0x15
    8000274a:	9367a783          	lw	a5,-1738(a5) # 8001707c <sb+0x4>
    8000274e:	cff5                	beqz	a5,8000284a <balloc+0x11e>
    80002750:	8baa                	mv	s7,a0
    80002752:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002754:	00015b17          	auipc	s6,0x15
    80002758:	924b0b13          	addi	s6,s6,-1756 # 80017078 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000275c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000275e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002760:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002762:	6c89                	lui	s9,0x2
    80002764:	a061                	j	800027ec <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002766:	97ca                	add	a5,a5,s2
    80002768:	8e55                	or	a2,a2,a3
    8000276a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000276e:	854a                	mv	a0,s2
    80002770:	00001097          	auipc	ra,0x1
    80002774:	0b4080e7          	jalr	180(ra) # 80003824 <log_write>
        brelse(bp);
    80002778:	854a                	mv	a0,s2
    8000277a:	00000097          	auipc	ra,0x0
    8000277e:	e20080e7          	jalr	-480(ra) # 8000259a <brelse>
  bp = bread(dev, bno);
    80002782:	85a6                	mv	a1,s1
    80002784:	855e                	mv	a0,s7
    80002786:	00000097          	auipc	ra,0x0
    8000278a:	ce4080e7          	jalr	-796(ra) # 8000246a <bread>
    8000278e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002790:	40000613          	li	a2,1024
    80002794:	4581                	li	a1,0
    80002796:	05850513          	addi	a0,a0,88
    8000279a:	ffffe097          	auipc	ra,0xffffe
    8000279e:	9e0080e7          	jalr	-1568(ra) # 8000017a <memset>
  log_write(bp);
    800027a2:	854a                	mv	a0,s2
    800027a4:	00001097          	auipc	ra,0x1
    800027a8:	080080e7          	jalr	128(ra) # 80003824 <log_write>
  brelse(bp);
    800027ac:	854a                	mv	a0,s2
    800027ae:	00000097          	auipc	ra,0x0
    800027b2:	dec080e7          	jalr	-532(ra) # 8000259a <brelse>
}
    800027b6:	8526                	mv	a0,s1
    800027b8:	60e6                	ld	ra,88(sp)
    800027ba:	6446                	ld	s0,80(sp)
    800027bc:	64a6                	ld	s1,72(sp)
    800027be:	6906                	ld	s2,64(sp)
    800027c0:	79e2                	ld	s3,56(sp)
    800027c2:	7a42                	ld	s4,48(sp)
    800027c4:	7aa2                	ld	s5,40(sp)
    800027c6:	7b02                	ld	s6,32(sp)
    800027c8:	6be2                	ld	s7,24(sp)
    800027ca:	6c42                	ld	s8,16(sp)
    800027cc:	6ca2                	ld	s9,8(sp)
    800027ce:	6125                	addi	sp,sp,96
    800027d0:	8082                	ret
    brelse(bp);
    800027d2:	854a                	mv	a0,s2
    800027d4:	00000097          	auipc	ra,0x0
    800027d8:	dc6080e7          	jalr	-570(ra) # 8000259a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027dc:	015c87bb          	addw	a5,s9,s5
    800027e0:	00078a9b          	sext.w	s5,a5
    800027e4:	004b2703          	lw	a4,4(s6)
    800027e8:	06eaf163          	bgeu	s5,a4,8000284a <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    800027ec:	41fad79b          	sraiw	a5,s5,0x1f
    800027f0:	0137d79b          	srliw	a5,a5,0x13
    800027f4:	015787bb          	addw	a5,a5,s5
    800027f8:	40d7d79b          	sraiw	a5,a5,0xd
    800027fc:	01cb2583          	lw	a1,28(s6)
    80002800:	9dbd                	addw	a1,a1,a5
    80002802:	855e                	mv	a0,s7
    80002804:	00000097          	auipc	ra,0x0
    80002808:	c66080e7          	jalr	-922(ra) # 8000246a <bread>
    8000280c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000280e:	004b2503          	lw	a0,4(s6)
    80002812:	000a849b          	sext.w	s1,s5
    80002816:	8762                	mv	a4,s8
    80002818:	faa4fde3          	bgeu	s1,a0,800027d2 <balloc+0xa6>
      m = 1 << (bi % 8);
    8000281c:	00777693          	andi	a3,a4,7
    80002820:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002824:	41f7579b          	sraiw	a5,a4,0x1f
    80002828:	01d7d79b          	srliw	a5,a5,0x1d
    8000282c:	9fb9                	addw	a5,a5,a4
    8000282e:	4037d79b          	sraiw	a5,a5,0x3
    80002832:	00f90633          	add	a2,s2,a5
    80002836:	05864603          	lbu	a2,88(a2)
    8000283a:	00c6f5b3          	and	a1,a3,a2
    8000283e:	d585                	beqz	a1,80002766 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002840:	2705                	addiw	a4,a4,1
    80002842:	2485                	addiw	s1,s1,1
    80002844:	fd471ae3          	bne	a4,s4,80002818 <balloc+0xec>
    80002848:	b769                	j	800027d2 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    8000284a:	00006517          	auipc	a0,0x6
    8000284e:	cee50513          	addi	a0,a0,-786 # 80008538 <syscalls+0x148>
    80002852:	00003097          	auipc	ra,0x3
    80002856:	554080e7          	jalr	1364(ra) # 80005da6 <printf>
  return 0;
    8000285a:	4481                	li	s1,0
    8000285c:	bfa9                	j	800027b6 <balloc+0x8a>

000000008000285e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000285e:	7179                	addi	sp,sp,-48
    80002860:	f406                	sd	ra,40(sp)
    80002862:	f022                	sd	s0,32(sp)
    80002864:	ec26                	sd	s1,24(sp)
    80002866:	e84a                	sd	s2,16(sp)
    80002868:	e44e                	sd	s3,8(sp)
    8000286a:	e052                	sd	s4,0(sp)
    8000286c:	1800                	addi	s0,sp,48
    8000286e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002870:	47ad                	li	a5,11
    80002872:	02b7e863          	bltu	a5,a1,800028a2 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80002876:	02059793          	slli	a5,a1,0x20
    8000287a:	01e7d593          	srli	a1,a5,0x1e
    8000287e:	00b504b3          	add	s1,a0,a1
    80002882:	0504a903          	lw	s2,80(s1)
    80002886:	06091e63          	bnez	s2,80002902 <bmap+0xa4>
      addr = balloc(ip->dev);
    8000288a:	4108                	lw	a0,0(a0)
    8000288c:	00000097          	auipc	ra,0x0
    80002890:	ea0080e7          	jalr	-352(ra) # 8000272c <balloc>
    80002894:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002898:	06090563          	beqz	s2,80002902 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    8000289c:	0524a823          	sw	s2,80(s1)
    800028a0:	a08d                	j	80002902 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800028a2:	ff45849b          	addiw	s1,a1,-12
    800028a6:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800028aa:	0ff00793          	li	a5,255
    800028ae:	08e7e563          	bltu	a5,a4,80002938 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800028b2:	08052903          	lw	s2,128(a0)
    800028b6:	00091d63          	bnez	s2,800028d0 <bmap+0x72>
      addr = balloc(ip->dev);
    800028ba:	4108                	lw	a0,0(a0)
    800028bc:	00000097          	auipc	ra,0x0
    800028c0:	e70080e7          	jalr	-400(ra) # 8000272c <balloc>
    800028c4:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800028c8:	02090d63          	beqz	s2,80002902 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800028cc:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800028d0:	85ca                	mv	a1,s2
    800028d2:	0009a503          	lw	a0,0(s3)
    800028d6:	00000097          	auipc	ra,0x0
    800028da:	b94080e7          	jalr	-1132(ra) # 8000246a <bread>
    800028de:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800028e0:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800028e4:	02049713          	slli	a4,s1,0x20
    800028e8:	01e75593          	srli	a1,a4,0x1e
    800028ec:	00b784b3          	add	s1,a5,a1
    800028f0:	0004a903          	lw	s2,0(s1)
    800028f4:	02090063          	beqz	s2,80002914 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800028f8:	8552                	mv	a0,s4
    800028fa:	00000097          	auipc	ra,0x0
    800028fe:	ca0080e7          	jalr	-864(ra) # 8000259a <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002902:	854a                	mv	a0,s2
    80002904:	70a2                	ld	ra,40(sp)
    80002906:	7402                	ld	s0,32(sp)
    80002908:	64e2                	ld	s1,24(sp)
    8000290a:	6942                	ld	s2,16(sp)
    8000290c:	69a2                	ld	s3,8(sp)
    8000290e:	6a02                	ld	s4,0(sp)
    80002910:	6145                	addi	sp,sp,48
    80002912:	8082                	ret
      addr = balloc(ip->dev);
    80002914:	0009a503          	lw	a0,0(s3)
    80002918:	00000097          	auipc	ra,0x0
    8000291c:	e14080e7          	jalr	-492(ra) # 8000272c <balloc>
    80002920:	0005091b          	sext.w	s2,a0
      if(addr){
    80002924:	fc090ae3          	beqz	s2,800028f8 <bmap+0x9a>
        a[bn] = addr;
    80002928:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000292c:	8552                	mv	a0,s4
    8000292e:	00001097          	auipc	ra,0x1
    80002932:	ef6080e7          	jalr	-266(ra) # 80003824 <log_write>
    80002936:	b7c9                	j	800028f8 <bmap+0x9a>
  panic("bmap: out of range");
    80002938:	00006517          	auipc	a0,0x6
    8000293c:	c1850513          	addi	a0,a0,-1000 # 80008550 <syscalls+0x160>
    80002940:	00003097          	auipc	ra,0x3
    80002944:	41c080e7          	jalr	1052(ra) # 80005d5c <panic>

0000000080002948 <iget>:
{
    80002948:	7179                	addi	sp,sp,-48
    8000294a:	f406                	sd	ra,40(sp)
    8000294c:	f022                	sd	s0,32(sp)
    8000294e:	ec26                	sd	s1,24(sp)
    80002950:	e84a                	sd	s2,16(sp)
    80002952:	e44e                	sd	s3,8(sp)
    80002954:	e052                	sd	s4,0(sp)
    80002956:	1800                	addi	s0,sp,48
    80002958:	89aa                	mv	s3,a0
    8000295a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000295c:	00014517          	auipc	a0,0x14
    80002960:	73c50513          	addi	a0,a0,1852 # 80017098 <itable>
    80002964:	00004097          	auipc	ra,0x4
    80002968:	930080e7          	jalr	-1744(ra) # 80006294 <acquire>
  empty = 0;
    8000296c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000296e:	00014497          	auipc	s1,0x14
    80002972:	74248493          	addi	s1,s1,1858 # 800170b0 <itable+0x18>
    80002976:	00016697          	auipc	a3,0x16
    8000297a:	1ca68693          	addi	a3,a3,458 # 80018b40 <log>
    8000297e:	a039                	j	8000298c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002980:	02090b63          	beqz	s2,800029b6 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002984:	08848493          	addi	s1,s1,136
    80002988:	02d48a63          	beq	s1,a3,800029bc <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000298c:	449c                	lw	a5,8(s1)
    8000298e:	fef059e3          	blez	a5,80002980 <iget+0x38>
    80002992:	4098                	lw	a4,0(s1)
    80002994:	ff3716e3          	bne	a4,s3,80002980 <iget+0x38>
    80002998:	40d8                	lw	a4,4(s1)
    8000299a:	ff4713e3          	bne	a4,s4,80002980 <iget+0x38>
      ip->ref++;
    8000299e:	2785                	addiw	a5,a5,1
    800029a0:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800029a2:	00014517          	auipc	a0,0x14
    800029a6:	6f650513          	addi	a0,a0,1782 # 80017098 <itable>
    800029aa:	00004097          	auipc	ra,0x4
    800029ae:	99e080e7          	jalr	-1634(ra) # 80006348 <release>
      return ip;
    800029b2:	8926                	mv	s2,s1
    800029b4:	a03d                	j	800029e2 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029b6:	f7f9                	bnez	a5,80002984 <iget+0x3c>
    800029b8:	8926                	mv	s2,s1
    800029ba:	b7e9                	j	80002984 <iget+0x3c>
  if(empty == 0)
    800029bc:	02090c63          	beqz	s2,800029f4 <iget+0xac>
  ip->dev = dev;
    800029c0:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800029c4:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800029c8:	4785                	li	a5,1
    800029ca:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800029ce:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800029d2:	00014517          	auipc	a0,0x14
    800029d6:	6c650513          	addi	a0,a0,1734 # 80017098 <itable>
    800029da:	00004097          	auipc	ra,0x4
    800029de:	96e080e7          	jalr	-1682(ra) # 80006348 <release>
}
    800029e2:	854a                	mv	a0,s2
    800029e4:	70a2                	ld	ra,40(sp)
    800029e6:	7402                	ld	s0,32(sp)
    800029e8:	64e2                	ld	s1,24(sp)
    800029ea:	6942                	ld	s2,16(sp)
    800029ec:	69a2                	ld	s3,8(sp)
    800029ee:	6a02                	ld	s4,0(sp)
    800029f0:	6145                	addi	sp,sp,48
    800029f2:	8082                	ret
    panic("iget: no inodes");
    800029f4:	00006517          	auipc	a0,0x6
    800029f8:	b7450513          	addi	a0,a0,-1164 # 80008568 <syscalls+0x178>
    800029fc:	00003097          	auipc	ra,0x3
    80002a00:	360080e7          	jalr	864(ra) # 80005d5c <panic>

0000000080002a04 <fsinit>:
fsinit(int dev) {
    80002a04:	7179                	addi	sp,sp,-48
    80002a06:	f406                	sd	ra,40(sp)
    80002a08:	f022                	sd	s0,32(sp)
    80002a0a:	ec26                	sd	s1,24(sp)
    80002a0c:	e84a                	sd	s2,16(sp)
    80002a0e:	e44e                	sd	s3,8(sp)
    80002a10:	1800                	addi	s0,sp,48
    80002a12:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a14:	4585                	li	a1,1
    80002a16:	00000097          	auipc	ra,0x0
    80002a1a:	a54080e7          	jalr	-1452(ra) # 8000246a <bread>
    80002a1e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a20:	00014997          	auipc	s3,0x14
    80002a24:	65898993          	addi	s3,s3,1624 # 80017078 <sb>
    80002a28:	02000613          	li	a2,32
    80002a2c:	05850593          	addi	a1,a0,88
    80002a30:	854e                	mv	a0,s3
    80002a32:	ffffd097          	auipc	ra,0xffffd
    80002a36:	7a4080e7          	jalr	1956(ra) # 800001d6 <memmove>
  brelse(bp);
    80002a3a:	8526                	mv	a0,s1
    80002a3c:	00000097          	auipc	ra,0x0
    80002a40:	b5e080e7          	jalr	-1186(ra) # 8000259a <brelse>
  if(sb.magic != FSMAGIC)
    80002a44:	0009a703          	lw	a4,0(s3)
    80002a48:	102037b7          	lui	a5,0x10203
    80002a4c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a50:	02f71263          	bne	a4,a5,80002a74 <fsinit+0x70>
  initlog(dev, &sb);
    80002a54:	00014597          	auipc	a1,0x14
    80002a58:	62458593          	addi	a1,a1,1572 # 80017078 <sb>
    80002a5c:	854a                	mv	a0,s2
    80002a5e:	00001097          	auipc	ra,0x1
    80002a62:	b4a080e7          	jalr	-1206(ra) # 800035a8 <initlog>
}
    80002a66:	70a2                	ld	ra,40(sp)
    80002a68:	7402                	ld	s0,32(sp)
    80002a6a:	64e2                	ld	s1,24(sp)
    80002a6c:	6942                	ld	s2,16(sp)
    80002a6e:	69a2                	ld	s3,8(sp)
    80002a70:	6145                	addi	sp,sp,48
    80002a72:	8082                	ret
    panic("invalid file system");
    80002a74:	00006517          	auipc	a0,0x6
    80002a78:	b0450513          	addi	a0,a0,-1276 # 80008578 <syscalls+0x188>
    80002a7c:	00003097          	auipc	ra,0x3
    80002a80:	2e0080e7          	jalr	736(ra) # 80005d5c <panic>

0000000080002a84 <iinit>:
{
    80002a84:	7179                	addi	sp,sp,-48
    80002a86:	f406                	sd	ra,40(sp)
    80002a88:	f022                	sd	s0,32(sp)
    80002a8a:	ec26                	sd	s1,24(sp)
    80002a8c:	e84a                	sd	s2,16(sp)
    80002a8e:	e44e                	sd	s3,8(sp)
    80002a90:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a92:	00006597          	auipc	a1,0x6
    80002a96:	afe58593          	addi	a1,a1,-1282 # 80008590 <syscalls+0x1a0>
    80002a9a:	00014517          	auipc	a0,0x14
    80002a9e:	5fe50513          	addi	a0,a0,1534 # 80017098 <itable>
    80002aa2:	00003097          	auipc	ra,0x3
    80002aa6:	762080e7          	jalr	1890(ra) # 80006204 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002aaa:	00014497          	auipc	s1,0x14
    80002aae:	61648493          	addi	s1,s1,1558 # 800170c0 <itable+0x28>
    80002ab2:	00016997          	auipc	s3,0x16
    80002ab6:	09e98993          	addi	s3,s3,158 # 80018b50 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002aba:	00006917          	auipc	s2,0x6
    80002abe:	ade90913          	addi	s2,s2,-1314 # 80008598 <syscalls+0x1a8>
    80002ac2:	85ca                	mv	a1,s2
    80002ac4:	8526                	mv	a0,s1
    80002ac6:	00001097          	auipc	ra,0x1
    80002aca:	e42080e7          	jalr	-446(ra) # 80003908 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002ace:	08848493          	addi	s1,s1,136
    80002ad2:	ff3498e3          	bne	s1,s3,80002ac2 <iinit+0x3e>
}
    80002ad6:	70a2                	ld	ra,40(sp)
    80002ad8:	7402                	ld	s0,32(sp)
    80002ada:	64e2                	ld	s1,24(sp)
    80002adc:	6942                	ld	s2,16(sp)
    80002ade:	69a2                	ld	s3,8(sp)
    80002ae0:	6145                	addi	sp,sp,48
    80002ae2:	8082                	ret

0000000080002ae4 <ialloc>:
{
    80002ae4:	715d                	addi	sp,sp,-80
    80002ae6:	e486                	sd	ra,72(sp)
    80002ae8:	e0a2                	sd	s0,64(sp)
    80002aea:	fc26                	sd	s1,56(sp)
    80002aec:	f84a                	sd	s2,48(sp)
    80002aee:	f44e                	sd	s3,40(sp)
    80002af0:	f052                	sd	s4,32(sp)
    80002af2:	ec56                	sd	s5,24(sp)
    80002af4:	e85a                	sd	s6,16(sp)
    80002af6:	e45e                	sd	s7,8(sp)
    80002af8:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002afa:	00014717          	auipc	a4,0x14
    80002afe:	58a72703          	lw	a4,1418(a4) # 80017084 <sb+0xc>
    80002b02:	4785                	li	a5,1
    80002b04:	04e7fa63          	bgeu	a5,a4,80002b58 <ialloc+0x74>
    80002b08:	8aaa                	mv	s5,a0
    80002b0a:	8bae                	mv	s7,a1
    80002b0c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b0e:	00014a17          	auipc	s4,0x14
    80002b12:	56aa0a13          	addi	s4,s4,1386 # 80017078 <sb>
    80002b16:	00048b1b          	sext.w	s6,s1
    80002b1a:	0044d593          	srli	a1,s1,0x4
    80002b1e:	018a2783          	lw	a5,24(s4)
    80002b22:	9dbd                	addw	a1,a1,a5
    80002b24:	8556                	mv	a0,s5
    80002b26:	00000097          	auipc	ra,0x0
    80002b2a:	944080e7          	jalr	-1724(ra) # 8000246a <bread>
    80002b2e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b30:	05850993          	addi	s3,a0,88
    80002b34:	00f4f793          	andi	a5,s1,15
    80002b38:	079a                	slli	a5,a5,0x6
    80002b3a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b3c:	00099783          	lh	a5,0(s3)
    80002b40:	c3a1                	beqz	a5,80002b80 <ialloc+0x9c>
    brelse(bp);
    80002b42:	00000097          	auipc	ra,0x0
    80002b46:	a58080e7          	jalr	-1448(ra) # 8000259a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b4a:	0485                	addi	s1,s1,1
    80002b4c:	00ca2703          	lw	a4,12(s4)
    80002b50:	0004879b          	sext.w	a5,s1
    80002b54:	fce7e1e3          	bltu	a5,a4,80002b16 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002b58:	00006517          	auipc	a0,0x6
    80002b5c:	a4850513          	addi	a0,a0,-1464 # 800085a0 <syscalls+0x1b0>
    80002b60:	00003097          	auipc	ra,0x3
    80002b64:	246080e7          	jalr	582(ra) # 80005da6 <printf>
  return 0;
    80002b68:	4501                	li	a0,0
}
    80002b6a:	60a6                	ld	ra,72(sp)
    80002b6c:	6406                	ld	s0,64(sp)
    80002b6e:	74e2                	ld	s1,56(sp)
    80002b70:	7942                	ld	s2,48(sp)
    80002b72:	79a2                	ld	s3,40(sp)
    80002b74:	7a02                	ld	s4,32(sp)
    80002b76:	6ae2                	ld	s5,24(sp)
    80002b78:	6b42                	ld	s6,16(sp)
    80002b7a:	6ba2                	ld	s7,8(sp)
    80002b7c:	6161                	addi	sp,sp,80
    80002b7e:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002b80:	04000613          	li	a2,64
    80002b84:	4581                	li	a1,0
    80002b86:	854e                	mv	a0,s3
    80002b88:	ffffd097          	auipc	ra,0xffffd
    80002b8c:	5f2080e7          	jalr	1522(ra) # 8000017a <memset>
      dip->type = type;
    80002b90:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b94:	854a                	mv	a0,s2
    80002b96:	00001097          	auipc	ra,0x1
    80002b9a:	c8e080e7          	jalr	-882(ra) # 80003824 <log_write>
      brelse(bp);
    80002b9e:	854a                	mv	a0,s2
    80002ba0:	00000097          	auipc	ra,0x0
    80002ba4:	9fa080e7          	jalr	-1542(ra) # 8000259a <brelse>
      return iget(dev, inum);
    80002ba8:	85da                	mv	a1,s6
    80002baa:	8556                	mv	a0,s5
    80002bac:	00000097          	auipc	ra,0x0
    80002bb0:	d9c080e7          	jalr	-612(ra) # 80002948 <iget>
    80002bb4:	bf5d                	j	80002b6a <ialloc+0x86>

0000000080002bb6 <iupdate>:
{
    80002bb6:	1101                	addi	sp,sp,-32
    80002bb8:	ec06                	sd	ra,24(sp)
    80002bba:	e822                	sd	s0,16(sp)
    80002bbc:	e426                	sd	s1,8(sp)
    80002bbe:	e04a                	sd	s2,0(sp)
    80002bc0:	1000                	addi	s0,sp,32
    80002bc2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bc4:	415c                	lw	a5,4(a0)
    80002bc6:	0047d79b          	srliw	a5,a5,0x4
    80002bca:	00014597          	auipc	a1,0x14
    80002bce:	4c65a583          	lw	a1,1222(a1) # 80017090 <sb+0x18>
    80002bd2:	9dbd                	addw	a1,a1,a5
    80002bd4:	4108                	lw	a0,0(a0)
    80002bd6:	00000097          	auipc	ra,0x0
    80002bda:	894080e7          	jalr	-1900(ra) # 8000246a <bread>
    80002bde:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002be0:	05850793          	addi	a5,a0,88
    80002be4:	40d8                	lw	a4,4(s1)
    80002be6:	8b3d                	andi	a4,a4,15
    80002be8:	071a                	slli	a4,a4,0x6
    80002bea:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002bec:	04449703          	lh	a4,68(s1)
    80002bf0:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002bf4:	04649703          	lh	a4,70(s1)
    80002bf8:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002bfc:	04849703          	lh	a4,72(s1)
    80002c00:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002c04:	04a49703          	lh	a4,74(s1)
    80002c08:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002c0c:	44f8                	lw	a4,76(s1)
    80002c0e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c10:	03400613          	li	a2,52
    80002c14:	05048593          	addi	a1,s1,80
    80002c18:	00c78513          	addi	a0,a5,12
    80002c1c:	ffffd097          	auipc	ra,0xffffd
    80002c20:	5ba080e7          	jalr	1466(ra) # 800001d6 <memmove>
  log_write(bp);
    80002c24:	854a                	mv	a0,s2
    80002c26:	00001097          	auipc	ra,0x1
    80002c2a:	bfe080e7          	jalr	-1026(ra) # 80003824 <log_write>
  brelse(bp);
    80002c2e:	854a                	mv	a0,s2
    80002c30:	00000097          	auipc	ra,0x0
    80002c34:	96a080e7          	jalr	-1686(ra) # 8000259a <brelse>
}
    80002c38:	60e2                	ld	ra,24(sp)
    80002c3a:	6442                	ld	s0,16(sp)
    80002c3c:	64a2                	ld	s1,8(sp)
    80002c3e:	6902                	ld	s2,0(sp)
    80002c40:	6105                	addi	sp,sp,32
    80002c42:	8082                	ret

0000000080002c44 <idup>:
{
    80002c44:	1101                	addi	sp,sp,-32
    80002c46:	ec06                	sd	ra,24(sp)
    80002c48:	e822                	sd	s0,16(sp)
    80002c4a:	e426                	sd	s1,8(sp)
    80002c4c:	1000                	addi	s0,sp,32
    80002c4e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c50:	00014517          	auipc	a0,0x14
    80002c54:	44850513          	addi	a0,a0,1096 # 80017098 <itable>
    80002c58:	00003097          	auipc	ra,0x3
    80002c5c:	63c080e7          	jalr	1596(ra) # 80006294 <acquire>
  ip->ref++;
    80002c60:	449c                	lw	a5,8(s1)
    80002c62:	2785                	addiw	a5,a5,1
    80002c64:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c66:	00014517          	auipc	a0,0x14
    80002c6a:	43250513          	addi	a0,a0,1074 # 80017098 <itable>
    80002c6e:	00003097          	auipc	ra,0x3
    80002c72:	6da080e7          	jalr	1754(ra) # 80006348 <release>
}
    80002c76:	8526                	mv	a0,s1
    80002c78:	60e2                	ld	ra,24(sp)
    80002c7a:	6442                	ld	s0,16(sp)
    80002c7c:	64a2                	ld	s1,8(sp)
    80002c7e:	6105                	addi	sp,sp,32
    80002c80:	8082                	ret

0000000080002c82 <ilock>:
{
    80002c82:	1101                	addi	sp,sp,-32
    80002c84:	ec06                	sd	ra,24(sp)
    80002c86:	e822                	sd	s0,16(sp)
    80002c88:	e426                	sd	s1,8(sp)
    80002c8a:	e04a                	sd	s2,0(sp)
    80002c8c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c8e:	c115                	beqz	a0,80002cb2 <ilock+0x30>
    80002c90:	84aa                	mv	s1,a0
    80002c92:	451c                	lw	a5,8(a0)
    80002c94:	00f05f63          	blez	a5,80002cb2 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c98:	0541                	addi	a0,a0,16
    80002c9a:	00001097          	auipc	ra,0x1
    80002c9e:	ca8080e7          	jalr	-856(ra) # 80003942 <acquiresleep>
  if(ip->valid == 0){
    80002ca2:	40bc                	lw	a5,64(s1)
    80002ca4:	cf99                	beqz	a5,80002cc2 <ilock+0x40>
}
    80002ca6:	60e2                	ld	ra,24(sp)
    80002ca8:	6442                	ld	s0,16(sp)
    80002caa:	64a2                	ld	s1,8(sp)
    80002cac:	6902                	ld	s2,0(sp)
    80002cae:	6105                	addi	sp,sp,32
    80002cb0:	8082                	ret
    panic("ilock");
    80002cb2:	00006517          	auipc	a0,0x6
    80002cb6:	90650513          	addi	a0,a0,-1786 # 800085b8 <syscalls+0x1c8>
    80002cba:	00003097          	auipc	ra,0x3
    80002cbe:	0a2080e7          	jalr	162(ra) # 80005d5c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cc2:	40dc                	lw	a5,4(s1)
    80002cc4:	0047d79b          	srliw	a5,a5,0x4
    80002cc8:	00014597          	auipc	a1,0x14
    80002ccc:	3c85a583          	lw	a1,968(a1) # 80017090 <sb+0x18>
    80002cd0:	9dbd                	addw	a1,a1,a5
    80002cd2:	4088                	lw	a0,0(s1)
    80002cd4:	fffff097          	auipc	ra,0xfffff
    80002cd8:	796080e7          	jalr	1942(ra) # 8000246a <bread>
    80002cdc:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cde:	05850593          	addi	a1,a0,88
    80002ce2:	40dc                	lw	a5,4(s1)
    80002ce4:	8bbd                	andi	a5,a5,15
    80002ce6:	079a                	slli	a5,a5,0x6
    80002ce8:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002cea:	00059783          	lh	a5,0(a1)
    80002cee:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002cf2:	00259783          	lh	a5,2(a1)
    80002cf6:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002cfa:	00459783          	lh	a5,4(a1)
    80002cfe:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d02:	00659783          	lh	a5,6(a1)
    80002d06:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d0a:	459c                	lw	a5,8(a1)
    80002d0c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d0e:	03400613          	li	a2,52
    80002d12:	05b1                	addi	a1,a1,12
    80002d14:	05048513          	addi	a0,s1,80
    80002d18:	ffffd097          	auipc	ra,0xffffd
    80002d1c:	4be080e7          	jalr	1214(ra) # 800001d6 <memmove>
    brelse(bp);
    80002d20:	854a                	mv	a0,s2
    80002d22:	00000097          	auipc	ra,0x0
    80002d26:	878080e7          	jalr	-1928(ra) # 8000259a <brelse>
    ip->valid = 1;
    80002d2a:	4785                	li	a5,1
    80002d2c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d2e:	04449783          	lh	a5,68(s1)
    80002d32:	fbb5                	bnez	a5,80002ca6 <ilock+0x24>
      panic("ilock: no type");
    80002d34:	00006517          	auipc	a0,0x6
    80002d38:	88c50513          	addi	a0,a0,-1908 # 800085c0 <syscalls+0x1d0>
    80002d3c:	00003097          	auipc	ra,0x3
    80002d40:	020080e7          	jalr	32(ra) # 80005d5c <panic>

0000000080002d44 <iunlock>:
{
    80002d44:	1101                	addi	sp,sp,-32
    80002d46:	ec06                	sd	ra,24(sp)
    80002d48:	e822                	sd	s0,16(sp)
    80002d4a:	e426                	sd	s1,8(sp)
    80002d4c:	e04a                	sd	s2,0(sp)
    80002d4e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d50:	c905                	beqz	a0,80002d80 <iunlock+0x3c>
    80002d52:	84aa                	mv	s1,a0
    80002d54:	01050913          	addi	s2,a0,16
    80002d58:	854a                	mv	a0,s2
    80002d5a:	00001097          	auipc	ra,0x1
    80002d5e:	c82080e7          	jalr	-894(ra) # 800039dc <holdingsleep>
    80002d62:	cd19                	beqz	a0,80002d80 <iunlock+0x3c>
    80002d64:	449c                	lw	a5,8(s1)
    80002d66:	00f05d63          	blez	a5,80002d80 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d6a:	854a                	mv	a0,s2
    80002d6c:	00001097          	auipc	ra,0x1
    80002d70:	c2c080e7          	jalr	-980(ra) # 80003998 <releasesleep>
}
    80002d74:	60e2                	ld	ra,24(sp)
    80002d76:	6442                	ld	s0,16(sp)
    80002d78:	64a2                	ld	s1,8(sp)
    80002d7a:	6902                	ld	s2,0(sp)
    80002d7c:	6105                	addi	sp,sp,32
    80002d7e:	8082                	ret
    panic("iunlock");
    80002d80:	00006517          	auipc	a0,0x6
    80002d84:	85050513          	addi	a0,a0,-1968 # 800085d0 <syscalls+0x1e0>
    80002d88:	00003097          	auipc	ra,0x3
    80002d8c:	fd4080e7          	jalr	-44(ra) # 80005d5c <panic>

0000000080002d90 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d90:	7179                	addi	sp,sp,-48
    80002d92:	f406                	sd	ra,40(sp)
    80002d94:	f022                	sd	s0,32(sp)
    80002d96:	ec26                	sd	s1,24(sp)
    80002d98:	e84a                	sd	s2,16(sp)
    80002d9a:	e44e                	sd	s3,8(sp)
    80002d9c:	e052                	sd	s4,0(sp)
    80002d9e:	1800                	addi	s0,sp,48
    80002da0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002da2:	05050493          	addi	s1,a0,80
    80002da6:	08050913          	addi	s2,a0,128
    80002daa:	a021                	j	80002db2 <itrunc+0x22>
    80002dac:	0491                	addi	s1,s1,4
    80002dae:	01248d63          	beq	s1,s2,80002dc8 <itrunc+0x38>
    if(ip->addrs[i]){
    80002db2:	408c                	lw	a1,0(s1)
    80002db4:	dde5                	beqz	a1,80002dac <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002db6:	0009a503          	lw	a0,0(s3)
    80002dba:	00000097          	auipc	ra,0x0
    80002dbe:	8f6080e7          	jalr	-1802(ra) # 800026b0 <bfree>
      ip->addrs[i] = 0;
    80002dc2:	0004a023          	sw	zero,0(s1)
    80002dc6:	b7dd                	j	80002dac <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002dc8:	0809a583          	lw	a1,128(s3)
    80002dcc:	e185                	bnez	a1,80002dec <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002dce:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002dd2:	854e                	mv	a0,s3
    80002dd4:	00000097          	auipc	ra,0x0
    80002dd8:	de2080e7          	jalr	-542(ra) # 80002bb6 <iupdate>
}
    80002ddc:	70a2                	ld	ra,40(sp)
    80002dde:	7402                	ld	s0,32(sp)
    80002de0:	64e2                	ld	s1,24(sp)
    80002de2:	6942                	ld	s2,16(sp)
    80002de4:	69a2                	ld	s3,8(sp)
    80002de6:	6a02                	ld	s4,0(sp)
    80002de8:	6145                	addi	sp,sp,48
    80002dea:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002dec:	0009a503          	lw	a0,0(s3)
    80002df0:	fffff097          	auipc	ra,0xfffff
    80002df4:	67a080e7          	jalr	1658(ra) # 8000246a <bread>
    80002df8:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002dfa:	05850493          	addi	s1,a0,88
    80002dfe:	45850913          	addi	s2,a0,1112
    80002e02:	a021                	j	80002e0a <itrunc+0x7a>
    80002e04:	0491                	addi	s1,s1,4
    80002e06:	01248b63          	beq	s1,s2,80002e1c <itrunc+0x8c>
      if(a[j])
    80002e0a:	408c                	lw	a1,0(s1)
    80002e0c:	dde5                	beqz	a1,80002e04 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002e0e:	0009a503          	lw	a0,0(s3)
    80002e12:	00000097          	auipc	ra,0x0
    80002e16:	89e080e7          	jalr	-1890(ra) # 800026b0 <bfree>
    80002e1a:	b7ed                	j	80002e04 <itrunc+0x74>
    brelse(bp);
    80002e1c:	8552                	mv	a0,s4
    80002e1e:	fffff097          	auipc	ra,0xfffff
    80002e22:	77c080e7          	jalr	1916(ra) # 8000259a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e26:	0809a583          	lw	a1,128(s3)
    80002e2a:	0009a503          	lw	a0,0(s3)
    80002e2e:	00000097          	auipc	ra,0x0
    80002e32:	882080e7          	jalr	-1918(ra) # 800026b0 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e36:	0809a023          	sw	zero,128(s3)
    80002e3a:	bf51                	j	80002dce <itrunc+0x3e>

0000000080002e3c <iput>:
{
    80002e3c:	1101                	addi	sp,sp,-32
    80002e3e:	ec06                	sd	ra,24(sp)
    80002e40:	e822                	sd	s0,16(sp)
    80002e42:	e426                	sd	s1,8(sp)
    80002e44:	e04a                	sd	s2,0(sp)
    80002e46:	1000                	addi	s0,sp,32
    80002e48:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e4a:	00014517          	auipc	a0,0x14
    80002e4e:	24e50513          	addi	a0,a0,590 # 80017098 <itable>
    80002e52:	00003097          	auipc	ra,0x3
    80002e56:	442080e7          	jalr	1090(ra) # 80006294 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e5a:	4498                	lw	a4,8(s1)
    80002e5c:	4785                	li	a5,1
    80002e5e:	02f70363          	beq	a4,a5,80002e84 <iput+0x48>
  ip->ref--;
    80002e62:	449c                	lw	a5,8(s1)
    80002e64:	37fd                	addiw	a5,a5,-1
    80002e66:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e68:	00014517          	auipc	a0,0x14
    80002e6c:	23050513          	addi	a0,a0,560 # 80017098 <itable>
    80002e70:	00003097          	auipc	ra,0x3
    80002e74:	4d8080e7          	jalr	1240(ra) # 80006348 <release>
}
    80002e78:	60e2                	ld	ra,24(sp)
    80002e7a:	6442                	ld	s0,16(sp)
    80002e7c:	64a2                	ld	s1,8(sp)
    80002e7e:	6902                	ld	s2,0(sp)
    80002e80:	6105                	addi	sp,sp,32
    80002e82:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e84:	40bc                	lw	a5,64(s1)
    80002e86:	dff1                	beqz	a5,80002e62 <iput+0x26>
    80002e88:	04a49783          	lh	a5,74(s1)
    80002e8c:	fbf9                	bnez	a5,80002e62 <iput+0x26>
    acquiresleep(&ip->lock);
    80002e8e:	01048913          	addi	s2,s1,16
    80002e92:	854a                	mv	a0,s2
    80002e94:	00001097          	auipc	ra,0x1
    80002e98:	aae080e7          	jalr	-1362(ra) # 80003942 <acquiresleep>
    release(&itable.lock);
    80002e9c:	00014517          	auipc	a0,0x14
    80002ea0:	1fc50513          	addi	a0,a0,508 # 80017098 <itable>
    80002ea4:	00003097          	auipc	ra,0x3
    80002ea8:	4a4080e7          	jalr	1188(ra) # 80006348 <release>
    itrunc(ip);
    80002eac:	8526                	mv	a0,s1
    80002eae:	00000097          	auipc	ra,0x0
    80002eb2:	ee2080e7          	jalr	-286(ra) # 80002d90 <itrunc>
    ip->type = 0;
    80002eb6:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002eba:	8526                	mv	a0,s1
    80002ebc:	00000097          	auipc	ra,0x0
    80002ec0:	cfa080e7          	jalr	-774(ra) # 80002bb6 <iupdate>
    ip->valid = 0;
    80002ec4:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002ec8:	854a                	mv	a0,s2
    80002eca:	00001097          	auipc	ra,0x1
    80002ece:	ace080e7          	jalr	-1330(ra) # 80003998 <releasesleep>
    acquire(&itable.lock);
    80002ed2:	00014517          	auipc	a0,0x14
    80002ed6:	1c650513          	addi	a0,a0,454 # 80017098 <itable>
    80002eda:	00003097          	auipc	ra,0x3
    80002ede:	3ba080e7          	jalr	954(ra) # 80006294 <acquire>
    80002ee2:	b741                	j	80002e62 <iput+0x26>

0000000080002ee4 <iunlockput>:
{
    80002ee4:	1101                	addi	sp,sp,-32
    80002ee6:	ec06                	sd	ra,24(sp)
    80002ee8:	e822                	sd	s0,16(sp)
    80002eea:	e426                	sd	s1,8(sp)
    80002eec:	1000                	addi	s0,sp,32
    80002eee:	84aa                	mv	s1,a0
  iunlock(ip);
    80002ef0:	00000097          	auipc	ra,0x0
    80002ef4:	e54080e7          	jalr	-428(ra) # 80002d44 <iunlock>
  iput(ip);
    80002ef8:	8526                	mv	a0,s1
    80002efa:	00000097          	auipc	ra,0x0
    80002efe:	f42080e7          	jalr	-190(ra) # 80002e3c <iput>
}
    80002f02:	60e2                	ld	ra,24(sp)
    80002f04:	6442                	ld	s0,16(sp)
    80002f06:	64a2                	ld	s1,8(sp)
    80002f08:	6105                	addi	sp,sp,32
    80002f0a:	8082                	ret

0000000080002f0c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f0c:	1141                	addi	sp,sp,-16
    80002f0e:	e422                	sd	s0,8(sp)
    80002f10:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f12:	411c                	lw	a5,0(a0)
    80002f14:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f16:	415c                	lw	a5,4(a0)
    80002f18:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f1a:	04451783          	lh	a5,68(a0)
    80002f1e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f22:	04a51783          	lh	a5,74(a0)
    80002f26:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f2a:	04c56783          	lwu	a5,76(a0)
    80002f2e:	e99c                	sd	a5,16(a1)
}
    80002f30:	6422                	ld	s0,8(sp)
    80002f32:	0141                	addi	sp,sp,16
    80002f34:	8082                	ret

0000000080002f36 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f36:	457c                	lw	a5,76(a0)
    80002f38:	0ed7e963          	bltu	a5,a3,8000302a <readi+0xf4>
{
    80002f3c:	7159                	addi	sp,sp,-112
    80002f3e:	f486                	sd	ra,104(sp)
    80002f40:	f0a2                	sd	s0,96(sp)
    80002f42:	eca6                	sd	s1,88(sp)
    80002f44:	e8ca                	sd	s2,80(sp)
    80002f46:	e4ce                	sd	s3,72(sp)
    80002f48:	e0d2                	sd	s4,64(sp)
    80002f4a:	fc56                	sd	s5,56(sp)
    80002f4c:	f85a                	sd	s6,48(sp)
    80002f4e:	f45e                	sd	s7,40(sp)
    80002f50:	f062                	sd	s8,32(sp)
    80002f52:	ec66                	sd	s9,24(sp)
    80002f54:	e86a                	sd	s10,16(sp)
    80002f56:	e46e                	sd	s11,8(sp)
    80002f58:	1880                	addi	s0,sp,112
    80002f5a:	8b2a                	mv	s6,a0
    80002f5c:	8bae                	mv	s7,a1
    80002f5e:	8a32                	mv	s4,a2
    80002f60:	84b6                	mv	s1,a3
    80002f62:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002f64:	9f35                	addw	a4,a4,a3
    return 0;
    80002f66:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f68:	0ad76063          	bltu	a4,a3,80003008 <readi+0xd2>
  if(off + n > ip->size)
    80002f6c:	00e7f463          	bgeu	a5,a4,80002f74 <readi+0x3e>
    n = ip->size - off;
    80002f70:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f74:	0a0a8963          	beqz	s5,80003026 <readi+0xf0>
    80002f78:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f7a:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f7e:	5c7d                	li	s8,-1
    80002f80:	a82d                	j	80002fba <readi+0x84>
    80002f82:	020d1d93          	slli	s11,s10,0x20
    80002f86:	020ddd93          	srli	s11,s11,0x20
    80002f8a:	05890613          	addi	a2,s2,88
    80002f8e:	86ee                	mv	a3,s11
    80002f90:	963a                	add	a2,a2,a4
    80002f92:	85d2                	mv	a1,s4
    80002f94:	855e                	mv	a0,s7
    80002f96:	fffff097          	auipc	ra,0xfffff
    80002f9a:	b0e080e7          	jalr	-1266(ra) # 80001aa4 <either_copyout>
    80002f9e:	05850d63          	beq	a0,s8,80002ff8 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002fa2:	854a                	mv	a0,s2
    80002fa4:	fffff097          	auipc	ra,0xfffff
    80002fa8:	5f6080e7          	jalr	1526(ra) # 8000259a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fac:	013d09bb          	addw	s3,s10,s3
    80002fb0:	009d04bb          	addw	s1,s10,s1
    80002fb4:	9a6e                	add	s4,s4,s11
    80002fb6:	0559f763          	bgeu	s3,s5,80003004 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002fba:	00a4d59b          	srliw	a1,s1,0xa
    80002fbe:	855a                	mv	a0,s6
    80002fc0:	00000097          	auipc	ra,0x0
    80002fc4:	89e080e7          	jalr	-1890(ra) # 8000285e <bmap>
    80002fc8:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002fcc:	cd85                	beqz	a1,80003004 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002fce:	000b2503          	lw	a0,0(s6)
    80002fd2:	fffff097          	auipc	ra,0xfffff
    80002fd6:	498080e7          	jalr	1176(ra) # 8000246a <bread>
    80002fda:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fdc:	3ff4f713          	andi	a4,s1,1023
    80002fe0:	40ec87bb          	subw	a5,s9,a4
    80002fe4:	413a86bb          	subw	a3,s5,s3
    80002fe8:	8d3e                	mv	s10,a5
    80002fea:	2781                	sext.w	a5,a5
    80002fec:	0006861b          	sext.w	a2,a3
    80002ff0:	f8f679e3          	bgeu	a2,a5,80002f82 <readi+0x4c>
    80002ff4:	8d36                	mv	s10,a3
    80002ff6:	b771                	j	80002f82 <readi+0x4c>
      brelse(bp);
    80002ff8:	854a                	mv	a0,s2
    80002ffa:	fffff097          	auipc	ra,0xfffff
    80002ffe:	5a0080e7          	jalr	1440(ra) # 8000259a <brelse>
      tot = -1;
    80003002:	59fd                	li	s3,-1
  }
  return tot;
    80003004:	0009851b          	sext.w	a0,s3
}
    80003008:	70a6                	ld	ra,104(sp)
    8000300a:	7406                	ld	s0,96(sp)
    8000300c:	64e6                	ld	s1,88(sp)
    8000300e:	6946                	ld	s2,80(sp)
    80003010:	69a6                	ld	s3,72(sp)
    80003012:	6a06                	ld	s4,64(sp)
    80003014:	7ae2                	ld	s5,56(sp)
    80003016:	7b42                	ld	s6,48(sp)
    80003018:	7ba2                	ld	s7,40(sp)
    8000301a:	7c02                	ld	s8,32(sp)
    8000301c:	6ce2                	ld	s9,24(sp)
    8000301e:	6d42                	ld	s10,16(sp)
    80003020:	6da2                	ld	s11,8(sp)
    80003022:	6165                	addi	sp,sp,112
    80003024:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003026:	89d6                	mv	s3,s5
    80003028:	bff1                	j	80003004 <readi+0xce>
    return 0;
    8000302a:	4501                	li	a0,0
}
    8000302c:	8082                	ret

000000008000302e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000302e:	457c                	lw	a5,76(a0)
    80003030:	10d7e863          	bltu	a5,a3,80003140 <writei+0x112>
{
    80003034:	7159                	addi	sp,sp,-112
    80003036:	f486                	sd	ra,104(sp)
    80003038:	f0a2                	sd	s0,96(sp)
    8000303a:	eca6                	sd	s1,88(sp)
    8000303c:	e8ca                	sd	s2,80(sp)
    8000303e:	e4ce                	sd	s3,72(sp)
    80003040:	e0d2                	sd	s4,64(sp)
    80003042:	fc56                	sd	s5,56(sp)
    80003044:	f85a                	sd	s6,48(sp)
    80003046:	f45e                	sd	s7,40(sp)
    80003048:	f062                	sd	s8,32(sp)
    8000304a:	ec66                	sd	s9,24(sp)
    8000304c:	e86a                	sd	s10,16(sp)
    8000304e:	e46e                	sd	s11,8(sp)
    80003050:	1880                	addi	s0,sp,112
    80003052:	8aaa                	mv	s5,a0
    80003054:	8bae                	mv	s7,a1
    80003056:	8a32                	mv	s4,a2
    80003058:	8936                	mv	s2,a3
    8000305a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000305c:	00e687bb          	addw	a5,a3,a4
    80003060:	0ed7e263          	bltu	a5,a3,80003144 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003064:	00043737          	lui	a4,0x43
    80003068:	0ef76063          	bltu	a4,a5,80003148 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000306c:	0c0b0863          	beqz	s6,8000313c <writei+0x10e>
    80003070:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003072:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003076:	5c7d                	li	s8,-1
    80003078:	a091                	j	800030bc <writei+0x8e>
    8000307a:	020d1d93          	slli	s11,s10,0x20
    8000307e:	020ddd93          	srli	s11,s11,0x20
    80003082:	05848513          	addi	a0,s1,88
    80003086:	86ee                	mv	a3,s11
    80003088:	8652                	mv	a2,s4
    8000308a:	85de                	mv	a1,s7
    8000308c:	953a                	add	a0,a0,a4
    8000308e:	fffff097          	auipc	ra,0xfffff
    80003092:	a6c080e7          	jalr	-1428(ra) # 80001afa <either_copyin>
    80003096:	07850263          	beq	a0,s8,800030fa <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000309a:	8526                	mv	a0,s1
    8000309c:	00000097          	auipc	ra,0x0
    800030a0:	788080e7          	jalr	1928(ra) # 80003824 <log_write>
    brelse(bp);
    800030a4:	8526                	mv	a0,s1
    800030a6:	fffff097          	auipc	ra,0xfffff
    800030aa:	4f4080e7          	jalr	1268(ra) # 8000259a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030ae:	013d09bb          	addw	s3,s10,s3
    800030b2:	012d093b          	addw	s2,s10,s2
    800030b6:	9a6e                	add	s4,s4,s11
    800030b8:	0569f663          	bgeu	s3,s6,80003104 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800030bc:	00a9559b          	srliw	a1,s2,0xa
    800030c0:	8556                	mv	a0,s5
    800030c2:	fffff097          	auipc	ra,0xfffff
    800030c6:	79c080e7          	jalr	1948(ra) # 8000285e <bmap>
    800030ca:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800030ce:	c99d                	beqz	a1,80003104 <writei+0xd6>
    bp = bread(ip->dev, addr);
    800030d0:	000aa503          	lw	a0,0(s5)
    800030d4:	fffff097          	auipc	ra,0xfffff
    800030d8:	396080e7          	jalr	918(ra) # 8000246a <bread>
    800030dc:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030de:	3ff97713          	andi	a4,s2,1023
    800030e2:	40ec87bb          	subw	a5,s9,a4
    800030e6:	413b06bb          	subw	a3,s6,s3
    800030ea:	8d3e                	mv	s10,a5
    800030ec:	2781                	sext.w	a5,a5
    800030ee:	0006861b          	sext.w	a2,a3
    800030f2:	f8f674e3          	bgeu	a2,a5,8000307a <writei+0x4c>
    800030f6:	8d36                	mv	s10,a3
    800030f8:	b749                	j	8000307a <writei+0x4c>
      brelse(bp);
    800030fa:	8526                	mv	a0,s1
    800030fc:	fffff097          	auipc	ra,0xfffff
    80003100:	49e080e7          	jalr	1182(ra) # 8000259a <brelse>
  }

  if(off > ip->size)
    80003104:	04caa783          	lw	a5,76(s5)
    80003108:	0127f463          	bgeu	a5,s2,80003110 <writei+0xe2>
    ip->size = off;
    8000310c:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003110:	8556                	mv	a0,s5
    80003112:	00000097          	auipc	ra,0x0
    80003116:	aa4080e7          	jalr	-1372(ra) # 80002bb6 <iupdate>

  return tot;
    8000311a:	0009851b          	sext.w	a0,s3
}
    8000311e:	70a6                	ld	ra,104(sp)
    80003120:	7406                	ld	s0,96(sp)
    80003122:	64e6                	ld	s1,88(sp)
    80003124:	6946                	ld	s2,80(sp)
    80003126:	69a6                	ld	s3,72(sp)
    80003128:	6a06                	ld	s4,64(sp)
    8000312a:	7ae2                	ld	s5,56(sp)
    8000312c:	7b42                	ld	s6,48(sp)
    8000312e:	7ba2                	ld	s7,40(sp)
    80003130:	7c02                	ld	s8,32(sp)
    80003132:	6ce2                	ld	s9,24(sp)
    80003134:	6d42                	ld	s10,16(sp)
    80003136:	6da2                	ld	s11,8(sp)
    80003138:	6165                	addi	sp,sp,112
    8000313a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000313c:	89da                	mv	s3,s6
    8000313e:	bfc9                	j	80003110 <writei+0xe2>
    return -1;
    80003140:	557d                	li	a0,-1
}
    80003142:	8082                	ret
    return -1;
    80003144:	557d                	li	a0,-1
    80003146:	bfe1                	j	8000311e <writei+0xf0>
    return -1;
    80003148:	557d                	li	a0,-1
    8000314a:	bfd1                	j	8000311e <writei+0xf0>

000000008000314c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000314c:	1141                	addi	sp,sp,-16
    8000314e:	e406                	sd	ra,8(sp)
    80003150:	e022                	sd	s0,0(sp)
    80003152:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003154:	4639                	li	a2,14
    80003156:	ffffd097          	auipc	ra,0xffffd
    8000315a:	0f4080e7          	jalr	244(ra) # 8000024a <strncmp>
}
    8000315e:	60a2                	ld	ra,8(sp)
    80003160:	6402                	ld	s0,0(sp)
    80003162:	0141                	addi	sp,sp,16
    80003164:	8082                	ret

0000000080003166 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003166:	7139                	addi	sp,sp,-64
    80003168:	fc06                	sd	ra,56(sp)
    8000316a:	f822                	sd	s0,48(sp)
    8000316c:	f426                	sd	s1,40(sp)
    8000316e:	f04a                	sd	s2,32(sp)
    80003170:	ec4e                	sd	s3,24(sp)
    80003172:	e852                	sd	s4,16(sp)
    80003174:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003176:	04451703          	lh	a4,68(a0)
    8000317a:	4785                	li	a5,1
    8000317c:	00f71a63          	bne	a4,a5,80003190 <dirlookup+0x2a>
    80003180:	892a                	mv	s2,a0
    80003182:	89ae                	mv	s3,a1
    80003184:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003186:	457c                	lw	a5,76(a0)
    80003188:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000318a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000318c:	e79d                	bnez	a5,800031ba <dirlookup+0x54>
    8000318e:	a8a5                	j	80003206 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003190:	00005517          	auipc	a0,0x5
    80003194:	44850513          	addi	a0,a0,1096 # 800085d8 <syscalls+0x1e8>
    80003198:	00003097          	auipc	ra,0x3
    8000319c:	bc4080e7          	jalr	-1084(ra) # 80005d5c <panic>
      panic("dirlookup read");
    800031a0:	00005517          	auipc	a0,0x5
    800031a4:	45050513          	addi	a0,a0,1104 # 800085f0 <syscalls+0x200>
    800031a8:	00003097          	auipc	ra,0x3
    800031ac:	bb4080e7          	jalr	-1100(ra) # 80005d5c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031b0:	24c1                	addiw	s1,s1,16
    800031b2:	04c92783          	lw	a5,76(s2)
    800031b6:	04f4f763          	bgeu	s1,a5,80003204 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031ba:	4741                	li	a4,16
    800031bc:	86a6                	mv	a3,s1
    800031be:	fc040613          	addi	a2,s0,-64
    800031c2:	4581                	li	a1,0
    800031c4:	854a                	mv	a0,s2
    800031c6:	00000097          	auipc	ra,0x0
    800031ca:	d70080e7          	jalr	-656(ra) # 80002f36 <readi>
    800031ce:	47c1                	li	a5,16
    800031d0:	fcf518e3          	bne	a0,a5,800031a0 <dirlookup+0x3a>
    if(de.inum == 0)
    800031d4:	fc045783          	lhu	a5,-64(s0)
    800031d8:	dfe1                	beqz	a5,800031b0 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800031da:	fc240593          	addi	a1,s0,-62
    800031de:	854e                	mv	a0,s3
    800031e0:	00000097          	auipc	ra,0x0
    800031e4:	f6c080e7          	jalr	-148(ra) # 8000314c <namecmp>
    800031e8:	f561                	bnez	a0,800031b0 <dirlookup+0x4a>
      if(poff)
    800031ea:	000a0463          	beqz	s4,800031f2 <dirlookup+0x8c>
        *poff = off;
    800031ee:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031f2:	fc045583          	lhu	a1,-64(s0)
    800031f6:	00092503          	lw	a0,0(s2)
    800031fa:	fffff097          	auipc	ra,0xfffff
    800031fe:	74e080e7          	jalr	1870(ra) # 80002948 <iget>
    80003202:	a011                	j	80003206 <dirlookup+0xa0>
  return 0;
    80003204:	4501                	li	a0,0
}
    80003206:	70e2                	ld	ra,56(sp)
    80003208:	7442                	ld	s0,48(sp)
    8000320a:	74a2                	ld	s1,40(sp)
    8000320c:	7902                	ld	s2,32(sp)
    8000320e:	69e2                	ld	s3,24(sp)
    80003210:	6a42                	ld	s4,16(sp)
    80003212:	6121                	addi	sp,sp,64
    80003214:	8082                	ret

0000000080003216 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003216:	711d                	addi	sp,sp,-96
    80003218:	ec86                	sd	ra,88(sp)
    8000321a:	e8a2                	sd	s0,80(sp)
    8000321c:	e4a6                	sd	s1,72(sp)
    8000321e:	e0ca                	sd	s2,64(sp)
    80003220:	fc4e                	sd	s3,56(sp)
    80003222:	f852                	sd	s4,48(sp)
    80003224:	f456                	sd	s5,40(sp)
    80003226:	f05a                	sd	s6,32(sp)
    80003228:	ec5e                	sd	s7,24(sp)
    8000322a:	e862                	sd	s8,16(sp)
    8000322c:	e466                	sd	s9,8(sp)
    8000322e:	e06a                	sd	s10,0(sp)
    80003230:	1080                	addi	s0,sp,96
    80003232:	84aa                	mv	s1,a0
    80003234:	8b2e                	mv	s6,a1
    80003236:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003238:	00054703          	lbu	a4,0(a0)
    8000323c:	02f00793          	li	a5,47
    80003240:	02f70363          	beq	a4,a5,80003266 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003244:	ffffe097          	auipc	ra,0xffffe
    80003248:	cf4080e7          	jalr	-780(ra) # 80000f38 <myproc>
    8000324c:	15053503          	ld	a0,336(a0)
    80003250:	00000097          	auipc	ra,0x0
    80003254:	9f4080e7          	jalr	-1548(ra) # 80002c44 <idup>
    80003258:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000325a:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000325e:	4cb5                	li	s9,13
  len = path - s;
    80003260:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003262:	4c05                	li	s8,1
    80003264:	a87d                	j	80003322 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003266:	4585                	li	a1,1
    80003268:	4505                	li	a0,1
    8000326a:	fffff097          	auipc	ra,0xfffff
    8000326e:	6de080e7          	jalr	1758(ra) # 80002948 <iget>
    80003272:	8a2a                	mv	s4,a0
    80003274:	b7dd                	j	8000325a <namex+0x44>
      iunlockput(ip);
    80003276:	8552                	mv	a0,s4
    80003278:	00000097          	auipc	ra,0x0
    8000327c:	c6c080e7          	jalr	-916(ra) # 80002ee4 <iunlockput>
      return 0;
    80003280:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003282:	8552                	mv	a0,s4
    80003284:	60e6                	ld	ra,88(sp)
    80003286:	6446                	ld	s0,80(sp)
    80003288:	64a6                	ld	s1,72(sp)
    8000328a:	6906                	ld	s2,64(sp)
    8000328c:	79e2                	ld	s3,56(sp)
    8000328e:	7a42                	ld	s4,48(sp)
    80003290:	7aa2                	ld	s5,40(sp)
    80003292:	7b02                	ld	s6,32(sp)
    80003294:	6be2                	ld	s7,24(sp)
    80003296:	6c42                	ld	s8,16(sp)
    80003298:	6ca2                	ld	s9,8(sp)
    8000329a:	6d02                	ld	s10,0(sp)
    8000329c:	6125                	addi	sp,sp,96
    8000329e:	8082                	ret
      iunlock(ip);
    800032a0:	8552                	mv	a0,s4
    800032a2:	00000097          	auipc	ra,0x0
    800032a6:	aa2080e7          	jalr	-1374(ra) # 80002d44 <iunlock>
      return ip;
    800032aa:	bfe1                	j	80003282 <namex+0x6c>
      iunlockput(ip);
    800032ac:	8552                	mv	a0,s4
    800032ae:	00000097          	auipc	ra,0x0
    800032b2:	c36080e7          	jalr	-970(ra) # 80002ee4 <iunlockput>
      return 0;
    800032b6:	8a4e                	mv	s4,s3
    800032b8:	b7e9                	j	80003282 <namex+0x6c>
  len = path - s;
    800032ba:	40998633          	sub	a2,s3,s1
    800032be:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800032c2:	09acd863          	bge	s9,s10,80003352 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800032c6:	4639                	li	a2,14
    800032c8:	85a6                	mv	a1,s1
    800032ca:	8556                	mv	a0,s5
    800032cc:	ffffd097          	auipc	ra,0xffffd
    800032d0:	f0a080e7          	jalr	-246(ra) # 800001d6 <memmove>
    800032d4:	84ce                	mv	s1,s3
  while(*path == '/')
    800032d6:	0004c783          	lbu	a5,0(s1)
    800032da:	01279763          	bne	a5,s2,800032e8 <namex+0xd2>
    path++;
    800032de:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032e0:	0004c783          	lbu	a5,0(s1)
    800032e4:	ff278de3          	beq	a5,s2,800032de <namex+0xc8>
    ilock(ip);
    800032e8:	8552                	mv	a0,s4
    800032ea:	00000097          	auipc	ra,0x0
    800032ee:	998080e7          	jalr	-1640(ra) # 80002c82 <ilock>
    if(ip->type != T_DIR){
    800032f2:	044a1783          	lh	a5,68(s4)
    800032f6:	f98790e3          	bne	a5,s8,80003276 <namex+0x60>
    if(nameiparent && *path == '\0'){
    800032fa:	000b0563          	beqz	s6,80003304 <namex+0xee>
    800032fe:	0004c783          	lbu	a5,0(s1)
    80003302:	dfd9                	beqz	a5,800032a0 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003304:	865e                	mv	a2,s7
    80003306:	85d6                	mv	a1,s5
    80003308:	8552                	mv	a0,s4
    8000330a:	00000097          	auipc	ra,0x0
    8000330e:	e5c080e7          	jalr	-420(ra) # 80003166 <dirlookup>
    80003312:	89aa                	mv	s3,a0
    80003314:	dd41                	beqz	a0,800032ac <namex+0x96>
    iunlockput(ip);
    80003316:	8552                	mv	a0,s4
    80003318:	00000097          	auipc	ra,0x0
    8000331c:	bcc080e7          	jalr	-1076(ra) # 80002ee4 <iunlockput>
    ip = next;
    80003320:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003322:	0004c783          	lbu	a5,0(s1)
    80003326:	01279763          	bne	a5,s2,80003334 <namex+0x11e>
    path++;
    8000332a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000332c:	0004c783          	lbu	a5,0(s1)
    80003330:	ff278de3          	beq	a5,s2,8000332a <namex+0x114>
  if(*path == 0)
    80003334:	cb9d                	beqz	a5,8000336a <namex+0x154>
  while(*path != '/' && *path != 0)
    80003336:	0004c783          	lbu	a5,0(s1)
    8000333a:	89a6                	mv	s3,s1
  len = path - s;
    8000333c:	8d5e                	mv	s10,s7
    8000333e:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003340:	01278963          	beq	a5,s2,80003352 <namex+0x13c>
    80003344:	dbbd                	beqz	a5,800032ba <namex+0xa4>
    path++;
    80003346:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003348:	0009c783          	lbu	a5,0(s3)
    8000334c:	ff279ce3          	bne	a5,s2,80003344 <namex+0x12e>
    80003350:	b7ad                	j	800032ba <namex+0xa4>
    memmove(name, s, len);
    80003352:	2601                	sext.w	a2,a2
    80003354:	85a6                	mv	a1,s1
    80003356:	8556                	mv	a0,s5
    80003358:	ffffd097          	auipc	ra,0xffffd
    8000335c:	e7e080e7          	jalr	-386(ra) # 800001d6 <memmove>
    name[len] = 0;
    80003360:	9d56                	add	s10,s10,s5
    80003362:	000d0023          	sb	zero,0(s10)
    80003366:	84ce                	mv	s1,s3
    80003368:	b7bd                	j	800032d6 <namex+0xc0>
  if(nameiparent){
    8000336a:	f00b0ce3          	beqz	s6,80003282 <namex+0x6c>
    iput(ip);
    8000336e:	8552                	mv	a0,s4
    80003370:	00000097          	auipc	ra,0x0
    80003374:	acc080e7          	jalr	-1332(ra) # 80002e3c <iput>
    return 0;
    80003378:	4a01                	li	s4,0
    8000337a:	b721                	j	80003282 <namex+0x6c>

000000008000337c <dirlink>:
{
    8000337c:	7139                	addi	sp,sp,-64
    8000337e:	fc06                	sd	ra,56(sp)
    80003380:	f822                	sd	s0,48(sp)
    80003382:	f426                	sd	s1,40(sp)
    80003384:	f04a                	sd	s2,32(sp)
    80003386:	ec4e                	sd	s3,24(sp)
    80003388:	e852                	sd	s4,16(sp)
    8000338a:	0080                	addi	s0,sp,64
    8000338c:	892a                	mv	s2,a0
    8000338e:	8a2e                	mv	s4,a1
    80003390:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003392:	4601                	li	a2,0
    80003394:	00000097          	auipc	ra,0x0
    80003398:	dd2080e7          	jalr	-558(ra) # 80003166 <dirlookup>
    8000339c:	e93d                	bnez	a0,80003412 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000339e:	04c92483          	lw	s1,76(s2)
    800033a2:	c49d                	beqz	s1,800033d0 <dirlink+0x54>
    800033a4:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033a6:	4741                	li	a4,16
    800033a8:	86a6                	mv	a3,s1
    800033aa:	fc040613          	addi	a2,s0,-64
    800033ae:	4581                	li	a1,0
    800033b0:	854a                	mv	a0,s2
    800033b2:	00000097          	auipc	ra,0x0
    800033b6:	b84080e7          	jalr	-1148(ra) # 80002f36 <readi>
    800033ba:	47c1                	li	a5,16
    800033bc:	06f51163          	bne	a0,a5,8000341e <dirlink+0xa2>
    if(de.inum == 0)
    800033c0:	fc045783          	lhu	a5,-64(s0)
    800033c4:	c791                	beqz	a5,800033d0 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033c6:	24c1                	addiw	s1,s1,16
    800033c8:	04c92783          	lw	a5,76(s2)
    800033cc:	fcf4ede3          	bltu	s1,a5,800033a6 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800033d0:	4639                	li	a2,14
    800033d2:	85d2                	mv	a1,s4
    800033d4:	fc240513          	addi	a0,s0,-62
    800033d8:	ffffd097          	auipc	ra,0xffffd
    800033dc:	eae080e7          	jalr	-338(ra) # 80000286 <strncpy>
  de.inum = inum;
    800033e0:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033e4:	4741                	li	a4,16
    800033e6:	86a6                	mv	a3,s1
    800033e8:	fc040613          	addi	a2,s0,-64
    800033ec:	4581                	li	a1,0
    800033ee:	854a                	mv	a0,s2
    800033f0:	00000097          	auipc	ra,0x0
    800033f4:	c3e080e7          	jalr	-962(ra) # 8000302e <writei>
    800033f8:	1541                	addi	a0,a0,-16
    800033fa:	00a03533          	snez	a0,a0
    800033fe:	40a00533          	neg	a0,a0
}
    80003402:	70e2                	ld	ra,56(sp)
    80003404:	7442                	ld	s0,48(sp)
    80003406:	74a2                	ld	s1,40(sp)
    80003408:	7902                	ld	s2,32(sp)
    8000340a:	69e2                	ld	s3,24(sp)
    8000340c:	6a42                	ld	s4,16(sp)
    8000340e:	6121                	addi	sp,sp,64
    80003410:	8082                	ret
    iput(ip);
    80003412:	00000097          	auipc	ra,0x0
    80003416:	a2a080e7          	jalr	-1494(ra) # 80002e3c <iput>
    return -1;
    8000341a:	557d                	li	a0,-1
    8000341c:	b7dd                	j	80003402 <dirlink+0x86>
      panic("dirlink read");
    8000341e:	00005517          	auipc	a0,0x5
    80003422:	1e250513          	addi	a0,a0,482 # 80008600 <syscalls+0x210>
    80003426:	00003097          	auipc	ra,0x3
    8000342a:	936080e7          	jalr	-1738(ra) # 80005d5c <panic>

000000008000342e <namei>:

struct inode*
namei(char *path)
{
    8000342e:	1101                	addi	sp,sp,-32
    80003430:	ec06                	sd	ra,24(sp)
    80003432:	e822                	sd	s0,16(sp)
    80003434:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003436:	fe040613          	addi	a2,s0,-32
    8000343a:	4581                	li	a1,0
    8000343c:	00000097          	auipc	ra,0x0
    80003440:	dda080e7          	jalr	-550(ra) # 80003216 <namex>
}
    80003444:	60e2                	ld	ra,24(sp)
    80003446:	6442                	ld	s0,16(sp)
    80003448:	6105                	addi	sp,sp,32
    8000344a:	8082                	ret

000000008000344c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000344c:	1141                	addi	sp,sp,-16
    8000344e:	e406                	sd	ra,8(sp)
    80003450:	e022                	sd	s0,0(sp)
    80003452:	0800                	addi	s0,sp,16
    80003454:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003456:	4585                	li	a1,1
    80003458:	00000097          	auipc	ra,0x0
    8000345c:	dbe080e7          	jalr	-578(ra) # 80003216 <namex>
}
    80003460:	60a2                	ld	ra,8(sp)
    80003462:	6402                	ld	s0,0(sp)
    80003464:	0141                	addi	sp,sp,16
    80003466:	8082                	ret

0000000080003468 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003468:	1101                	addi	sp,sp,-32
    8000346a:	ec06                	sd	ra,24(sp)
    8000346c:	e822                	sd	s0,16(sp)
    8000346e:	e426                	sd	s1,8(sp)
    80003470:	e04a                	sd	s2,0(sp)
    80003472:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003474:	00015917          	auipc	s2,0x15
    80003478:	6cc90913          	addi	s2,s2,1740 # 80018b40 <log>
    8000347c:	01892583          	lw	a1,24(s2)
    80003480:	02892503          	lw	a0,40(s2)
    80003484:	fffff097          	auipc	ra,0xfffff
    80003488:	fe6080e7          	jalr	-26(ra) # 8000246a <bread>
    8000348c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000348e:	02c92683          	lw	a3,44(s2)
    80003492:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003494:	02d05863          	blez	a3,800034c4 <write_head+0x5c>
    80003498:	00015797          	auipc	a5,0x15
    8000349c:	6d878793          	addi	a5,a5,1752 # 80018b70 <log+0x30>
    800034a0:	05c50713          	addi	a4,a0,92
    800034a4:	36fd                	addiw	a3,a3,-1
    800034a6:	02069613          	slli	a2,a3,0x20
    800034aa:	01e65693          	srli	a3,a2,0x1e
    800034ae:	00015617          	auipc	a2,0x15
    800034b2:	6c660613          	addi	a2,a2,1734 # 80018b74 <log+0x34>
    800034b6:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800034b8:	4390                	lw	a2,0(a5)
    800034ba:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034bc:	0791                	addi	a5,a5,4
    800034be:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    800034c0:	fed79ce3          	bne	a5,a3,800034b8 <write_head+0x50>
  }
  bwrite(buf);
    800034c4:	8526                	mv	a0,s1
    800034c6:	fffff097          	auipc	ra,0xfffff
    800034ca:	096080e7          	jalr	150(ra) # 8000255c <bwrite>
  brelse(buf);
    800034ce:	8526                	mv	a0,s1
    800034d0:	fffff097          	auipc	ra,0xfffff
    800034d4:	0ca080e7          	jalr	202(ra) # 8000259a <brelse>
}
    800034d8:	60e2                	ld	ra,24(sp)
    800034da:	6442                	ld	s0,16(sp)
    800034dc:	64a2                	ld	s1,8(sp)
    800034de:	6902                	ld	s2,0(sp)
    800034e0:	6105                	addi	sp,sp,32
    800034e2:	8082                	ret

00000000800034e4 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800034e4:	00015797          	auipc	a5,0x15
    800034e8:	6887a783          	lw	a5,1672(a5) # 80018b6c <log+0x2c>
    800034ec:	0af05d63          	blez	a5,800035a6 <install_trans+0xc2>
{
    800034f0:	7139                	addi	sp,sp,-64
    800034f2:	fc06                	sd	ra,56(sp)
    800034f4:	f822                	sd	s0,48(sp)
    800034f6:	f426                	sd	s1,40(sp)
    800034f8:	f04a                	sd	s2,32(sp)
    800034fa:	ec4e                	sd	s3,24(sp)
    800034fc:	e852                	sd	s4,16(sp)
    800034fe:	e456                	sd	s5,8(sp)
    80003500:	e05a                	sd	s6,0(sp)
    80003502:	0080                	addi	s0,sp,64
    80003504:	8b2a                	mv	s6,a0
    80003506:	00015a97          	auipc	s5,0x15
    8000350a:	66aa8a93          	addi	s5,s5,1642 # 80018b70 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000350e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003510:	00015997          	auipc	s3,0x15
    80003514:	63098993          	addi	s3,s3,1584 # 80018b40 <log>
    80003518:	a00d                	j	8000353a <install_trans+0x56>
    brelse(lbuf);
    8000351a:	854a                	mv	a0,s2
    8000351c:	fffff097          	auipc	ra,0xfffff
    80003520:	07e080e7          	jalr	126(ra) # 8000259a <brelse>
    brelse(dbuf);
    80003524:	8526                	mv	a0,s1
    80003526:	fffff097          	auipc	ra,0xfffff
    8000352a:	074080e7          	jalr	116(ra) # 8000259a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000352e:	2a05                	addiw	s4,s4,1
    80003530:	0a91                	addi	s5,s5,4
    80003532:	02c9a783          	lw	a5,44(s3)
    80003536:	04fa5e63          	bge	s4,a5,80003592 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000353a:	0189a583          	lw	a1,24(s3)
    8000353e:	014585bb          	addw	a1,a1,s4
    80003542:	2585                	addiw	a1,a1,1
    80003544:	0289a503          	lw	a0,40(s3)
    80003548:	fffff097          	auipc	ra,0xfffff
    8000354c:	f22080e7          	jalr	-222(ra) # 8000246a <bread>
    80003550:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003552:	000aa583          	lw	a1,0(s5)
    80003556:	0289a503          	lw	a0,40(s3)
    8000355a:	fffff097          	auipc	ra,0xfffff
    8000355e:	f10080e7          	jalr	-240(ra) # 8000246a <bread>
    80003562:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003564:	40000613          	li	a2,1024
    80003568:	05890593          	addi	a1,s2,88
    8000356c:	05850513          	addi	a0,a0,88
    80003570:	ffffd097          	auipc	ra,0xffffd
    80003574:	c66080e7          	jalr	-922(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003578:	8526                	mv	a0,s1
    8000357a:	fffff097          	auipc	ra,0xfffff
    8000357e:	fe2080e7          	jalr	-30(ra) # 8000255c <bwrite>
    if(recovering == 0)
    80003582:	f80b1ce3          	bnez	s6,8000351a <install_trans+0x36>
      bunpin(dbuf);
    80003586:	8526                	mv	a0,s1
    80003588:	fffff097          	auipc	ra,0xfffff
    8000358c:	0ec080e7          	jalr	236(ra) # 80002674 <bunpin>
    80003590:	b769                	j	8000351a <install_trans+0x36>
}
    80003592:	70e2                	ld	ra,56(sp)
    80003594:	7442                	ld	s0,48(sp)
    80003596:	74a2                	ld	s1,40(sp)
    80003598:	7902                	ld	s2,32(sp)
    8000359a:	69e2                	ld	s3,24(sp)
    8000359c:	6a42                	ld	s4,16(sp)
    8000359e:	6aa2                	ld	s5,8(sp)
    800035a0:	6b02                	ld	s6,0(sp)
    800035a2:	6121                	addi	sp,sp,64
    800035a4:	8082                	ret
    800035a6:	8082                	ret

00000000800035a8 <initlog>:
{
    800035a8:	7179                	addi	sp,sp,-48
    800035aa:	f406                	sd	ra,40(sp)
    800035ac:	f022                	sd	s0,32(sp)
    800035ae:	ec26                	sd	s1,24(sp)
    800035b0:	e84a                	sd	s2,16(sp)
    800035b2:	e44e                	sd	s3,8(sp)
    800035b4:	1800                	addi	s0,sp,48
    800035b6:	892a                	mv	s2,a0
    800035b8:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035ba:	00015497          	auipc	s1,0x15
    800035be:	58648493          	addi	s1,s1,1414 # 80018b40 <log>
    800035c2:	00005597          	auipc	a1,0x5
    800035c6:	04e58593          	addi	a1,a1,78 # 80008610 <syscalls+0x220>
    800035ca:	8526                	mv	a0,s1
    800035cc:	00003097          	auipc	ra,0x3
    800035d0:	c38080e7          	jalr	-968(ra) # 80006204 <initlock>
  log.start = sb->logstart;
    800035d4:	0149a583          	lw	a1,20(s3)
    800035d8:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800035da:	0109a783          	lw	a5,16(s3)
    800035de:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800035e0:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800035e4:	854a                	mv	a0,s2
    800035e6:	fffff097          	auipc	ra,0xfffff
    800035ea:	e84080e7          	jalr	-380(ra) # 8000246a <bread>
  log.lh.n = lh->n;
    800035ee:	4d34                	lw	a3,88(a0)
    800035f0:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800035f2:	02d05663          	blez	a3,8000361e <initlog+0x76>
    800035f6:	05c50793          	addi	a5,a0,92
    800035fa:	00015717          	auipc	a4,0x15
    800035fe:	57670713          	addi	a4,a4,1398 # 80018b70 <log+0x30>
    80003602:	36fd                	addiw	a3,a3,-1
    80003604:	02069613          	slli	a2,a3,0x20
    80003608:	01e65693          	srli	a3,a2,0x1e
    8000360c:	06050613          	addi	a2,a0,96
    80003610:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003612:	4390                	lw	a2,0(a5)
    80003614:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003616:	0791                	addi	a5,a5,4
    80003618:	0711                	addi	a4,a4,4
    8000361a:	fed79ce3          	bne	a5,a3,80003612 <initlog+0x6a>
  brelse(buf);
    8000361e:	fffff097          	auipc	ra,0xfffff
    80003622:	f7c080e7          	jalr	-132(ra) # 8000259a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003626:	4505                	li	a0,1
    80003628:	00000097          	auipc	ra,0x0
    8000362c:	ebc080e7          	jalr	-324(ra) # 800034e4 <install_trans>
  log.lh.n = 0;
    80003630:	00015797          	auipc	a5,0x15
    80003634:	5207ae23          	sw	zero,1340(a5) # 80018b6c <log+0x2c>
  write_head(); // clear the log
    80003638:	00000097          	auipc	ra,0x0
    8000363c:	e30080e7          	jalr	-464(ra) # 80003468 <write_head>
}
    80003640:	70a2                	ld	ra,40(sp)
    80003642:	7402                	ld	s0,32(sp)
    80003644:	64e2                	ld	s1,24(sp)
    80003646:	6942                	ld	s2,16(sp)
    80003648:	69a2                	ld	s3,8(sp)
    8000364a:	6145                	addi	sp,sp,48
    8000364c:	8082                	ret

000000008000364e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000364e:	1101                	addi	sp,sp,-32
    80003650:	ec06                	sd	ra,24(sp)
    80003652:	e822                	sd	s0,16(sp)
    80003654:	e426                	sd	s1,8(sp)
    80003656:	e04a                	sd	s2,0(sp)
    80003658:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000365a:	00015517          	auipc	a0,0x15
    8000365e:	4e650513          	addi	a0,a0,1254 # 80018b40 <log>
    80003662:	00003097          	auipc	ra,0x3
    80003666:	c32080e7          	jalr	-974(ra) # 80006294 <acquire>
  while(1){
    if(log.committing){
    8000366a:	00015497          	auipc	s1,0x15
    8000366e:	4d648493          	addi	s1,s1,1238 # 80018b40 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003672:	4979                	li	s2,30
    80003674:	a039                	j	80003682 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003676:	85a6                	mv	a1,s1
    80003678:	8526                	mv	a0,s1
    8000367a:	ffffe097          	auipc	ra,0xffffe
    8000367e:	022080e7          	jalr	34(ra) # 8000169c <sleep>
    if(log.committing){
    80003682:	50dc                	lw	a5,36(s1)
    80003684:	fbed                	bnez	a5,80003676 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003686:	5098                	lw	a4,32(s1)
    80003688:	2705                	addiw	a4,a4,1
    8000368a:	0007069b          	sext.w	a3,a4
    8000368e:	0027179b          	slliw	a5,a4,0x2
    80003692:	9fb9                	addw	a5,a5,a4
    80003694:	0017979b          	slliw	a5,a5,0x1
    80003698:	54d8                	lw	a4,44(s1)
    8000369a:	9fb9                	addw	a5,a5,a4
    8000369c:	00f95963          	bge	s2,a5,800036ae <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800036a0:	85a6                	mv	a1,s1
    800036a2:	8526                	mv	a0,s1
    800036a4:	ffffe097          	auipc	ra,0xffffe
    800036a8:	ff8080e7          	jalr	-8(ra) # 8000169c <sleep>
    800036ac:	bfd9                	j	80003682 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800036ae:	00015517          	auipc	a0,0x15
    800036b2:	49250513          	addi	a0,a0,1170 # 80018b40 <log>
    800036b6:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800036b8:	00003097          	auipc	ra,0x3
    800036bc:	c90080e7          	jalr	-880(ra) # 80006348 <release>
      break;
    }
  }
}
    800036c0:	60e2                	ld	ra,24(sp)
    800036c2:	6442                	ld	s0,16(sp)
    800036c4:	64a2                	ld	s1,8(sp)
    800036c6:	6902                	ld	s2,0(sp)
    800036c8:	6105                	addi	sp,sp,32
    800036ca:	8082                	ret

00000000800036cc <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036cc:	7139                	addi	sp,sp,-64
    800036ce:	fc06                	sd	ra,56(sp)
    800036d0:	f822                	sd	s0,48(sp)
    800036d2:	f426                	sd	s1,40(sp)
    800036d4:	f04a                	sd	s2,32(sp)
    800036d6:	ec4e                	sd	s3,24(sp)
    800036d8:	e852                	sd	s4,16(sp)
    800036da:	e456                	sd	s5,8(sp)
    800036dc:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800036de:	00015497          	auipc	s1,0x15
    800036e2:	46248493          	addi	s1,s1,1122 # 80018b40 <log>
    800036e6:	8526                	mv	a0,s1
    800036e8:	00003097          	auipc	ra,0x3
    800036ec:	bac080e7          	jalr	-1108(ra) # 80006294 <acquire>
  log.outstanding -= 1;
    800036f0:	509c                	lw	a5,32(s1)
    800036f2:	37fd                	addiw	a5,a5,-1
    800036f4:	0007891b          	sext.w	s2,a5
    800036f8:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800036fa:	50dc                	lw	a5,36(s1)
    800036fc:	e7b9                	bnez	a5,8000374a <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800036fe:	04091e63          	bnez	s2,8000375a <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003702:	00015497          	auipc	s1,0x15
    80003706:	43e48493          	addi	s1,s1,1086 # 80018b40 <log>
    8000370a:	4785                	li	a5,1
    8000370c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000370e:	8526                	mv	a0,s1
    80003710:	00003097          	auipc	ra,0x3
    80003714:	c38080e7          	jalr	-968(ra) # 80006348 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003718:	54dc                	lw	a5,44(s1)
    8000371a:	06f04763          	bgtz	a5,80003788 <end_op+0xbc>
    acquire(&log.lock);
    8000371e:	00015497          	auipc	s1,0x15
    80003722:	42248493          	addi	s1,s1,1058 # 80018b40 <log>
    80003726:	8526                	mv	a0,s1
    80003728:	00003097          	auipc	ra,0x3
    8000372c:	b6c080e7          	jalr	-1172(ra) # 80006294 <acquire>
    log.committing = 0;
    80003730:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003734:	8526                	mv	a0,s1
    80003736:	ffffe097          	auipc	ra,0xffffe
    8000373a:	fca080e7          	jalr	-54(ra) # 80001700 <wakeup>
    release(&log.lock);
    8000373e:	8526                	mv	a0,s1
    80003740:	00003097          	auipc	ra,0x3
    80003744:	c08080e7          	jalr	-1016(ra) # 80006348 <release>
}
    80003748:	a03d                	j	80003776 <end_op+0xaa>
    panic("log.committing");
    8000374a:	00005517          	auipc	a0,0x5
    8000374e:	ece50513          	addi	a0,a0,-306 # 80008618 <syscalls+0x228>
    80003752:	00002097          	auipc	ra,0x2
    80003756:	60a080e7          	jalr	1546(ra) # 80005d5c <panic>
    wakeup(&log);
    8000375a:	00015497          	auipc	s1,0x15
    8000375e:	3e648493          	addi	s1,s1,998 # 80018b40 <log>
    80003762:	8526                	mv	a0,s1
    80003764:	ffffe097          	auipc	ra,0xffffe
    80003768:	f9c080e7          	jalr	-100(ra) # 80001700 <wakeup>
  release(&log.lock);
    8000376c:	8526                	mv	a0,s1
    8000376e:	00003097          	auipc	ra,0x3
    80003772:	bda080e7          	jalr	-1062(ra) # 80006348 <release>
}
    80003776:	70e2                	ld	ra,56(sp)
    80003778:	7442                	ld	s0,48(sp)
    8000377a:	74a2                	ld	s1,40(sp)
    8000377c:	7902                	ld	s2,32(sp)
    8000377e:	69e2                	ld	s3,24(sp)
    80003780:	6a42                	ld	s4,16(sp)
    80003782:	6aa2                	ld	s5,8(sp)
    80003784:	6121                	addi	sp,sp,64
    80003786:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003788:	00015a97          	auipc	s5,0x15
    8000378c:	3e8a8a93          	addi	s5,s5,1000 # 80018b70 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003790:	00015a17          	auipc	s4,0x15
    80003794:	3b0a0a13          	addi	s4,s4,944 # 80018b40 <log>
    80003798:	018a2583          	lw	a1,24(s4)
    8000379c:	012585bb          	addw	a1,a1,s2
    800037a0:	2585                	addiw	a1,a1,1
    800037a2:	028a2503          	lw	a0,40(s4)
    800037a6:	fffff097          	auipc	ra,0xfffff
    800037aa:	cc4080e7          	jalr	-828(ra) # 8000246a <bread>
    800037ae:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800037b0:	000aa583          	lw	a1,0(s5)
    800037b4:	028a2503          	lw	a0,40(s4)
    800037b8:	fffff097          	auipc	ra,0xfffff
    800037bc:	cb2080e7          	jalr	-846(ra) # 8000246a <bread>
    800037c0:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800037c2:	40000613          	li	a2,1024
    800037c6:	05850593          	addi	a1,a0,88
    800037ca:	05848513          	addi	a0,s1,88
    800037ce:	ffffd097          	auipc	ra,0xffffd
    800037d2:	a08080e7          	jalr	-1528(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    800037d6:	8526                	mv	a0,s1
    800037d8:	fffff097          	auipc	ra,0xfffff
    800037dc:	d84080e7          	jalr	-636(ra) # 8000255c <bwrite>
    brelse(from);
    800037e0:	854e                	mv	a0,s3
    800037e2:	fffff097          	auipc	ra,0xfffff
    800037e6:	db8080e7          	jalr	-584(ra) # 8000259a <brelse>
    brelse(to);
    800037ea:	8526                	mv	a0,s1
    800037ec:	fffff097          	auipc	ra,0xfffff
    800037f0:	dae080e7          	jalr	-594(ra) # 8000259a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037f4:	2905                	addiw	s2,s2,1
    800037f6:	0a91                	addi	s5,s5,4
    800037f8:	02ca2783          	lw	a5,44(s4)
    800037fc:	f8f94ee3          	blt	s2,a5,80003798 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003800:	00000097          	auipc	ra,0x0
    80003804:	c68080e7          	jalr	-920(ra) # 80003468 <write_head>
    install_trans(0); // Now install writes to home locations
    80003808:	4501                	li	a0,0
    8000380a:	00000097          	auipc	ra,0x0
    8000380e:	cda080e7          	jalr	-806(ra) # 800034e4 <install_trans>
    log.lh.n = 0;
    80003812:	00015797          	auipc	a5,0x15
    80003816:	3407ad23          	sw	zero,858(a5) # 80018b6c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000381a:	00000097          	auipc	ra,0x0
    8000381e:	c4e080e7          	jalr	-946(ra) # 80003468 <write_head>
    80003822:	bdf5                	j	8000371e <end_op+0x52>

0000000080003824 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003824:	1101                	addi	sp,sp,-32
    80003826:	ec06                	sd	ra,24(sp)
    80003828:	e822                	sd	s0,16(sp)
    8000382a:	e426                	sd	s1,8(sp)
    8000382c:	e04a                	sd	s2,0(sp)
    8000382e:	1000                	addi	s0,sp,32
    80003830:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003832:	00015917          	auipc	s2,0x15
    80003836:	30e90913          	addi	s2,s2,782 # 80018b40 <log>
    8000383a:	854a                	mv	a0,s2
    8000383c:	00003097          	auipc	ra,0x3
    80003840:	a58080e7          	jalr	-1448(ra) # 80006294 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003844:	02c92603          	lw	a2,44(s2)
    80003848:	47f5                	li	a5,29
    8000384a:	06c7c563          	blt	a5,a2,800038b4 <log_write+0x90>
    8000384e:	00015797          	auipc	a5,0x15
    80003852:	30e7a783          	lw	a5,782(a5) # 80018b5c <log+0x1c>
    80003856:	37fd                	addiw	a5,a5,-1
    80003858:	04f65e63          	bge	a2,a5,800038b4 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000385c:	00015797          	auipc	a5,0x15
    80003860:	3047a783          	lw	a5,772(a5) # 80018b60 <log+0x20>
    80003864:	06f05063          	blez	a5,800038c4 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003868:	4781                	li	a5,0
    8000386a:	06c05563          	blez	a2,800038d4 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000386e:	44cc                	lw	a1,12(s1)
    80003870:	00015717          	auipc	a4,0x15
    80003874:	30070713          	addi	a4,a4,768 # 80018b70 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003878:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000387a:	4314                	lw	a3,0(a4)
    8000387c:	04b68c63          	beq	a3,a1,800038d4 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003880:	2785                	addiw	a5,a5,1
    80003882:	0711                	addi	a4,a4,4
    80003884:	fef61be3          	bne	a2,a5,8000387a <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003888:	0621                	addi	a2,a2,8
    8000388a:	060a                	slli	a2,a2,0x2
    8000388c:	00015797          	auipc	a5,0x15
    80003890:	2b478793          	addi	a5,a5,692 # 80018b40 <log>
    80003894:	97b2                	add	a5,a5,a2
    80003896:	44d8                	lw	a4,12(s1)
    80003898:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000389a:	8526                	mv	a0,s1
    8000389c:	fffff097          	auipc	ra,0xfffff
    800038a0:	d9c080e7          	jalr	-612(ra) # 80002638 <bpin>
    log.lh.n++;
    800038a4:	00015717          	auipc	a4,0x15
    800038a8:	29c70713          	addi	a4,a4,668 # 80018b40 <log>
    800038ac:	575c                	lw	a5,44(a4)
    800038ae:	2785                	addiw	a5,a5,1
    800038b0:	d75c                	sw	a5,44(a4)
    800038b2:	a82d                	j	800038ec <log_write+0xc8>
    panic("too big a transaction");
    800038b4:	00005517          	auipc	a0,0x5
    800038b8:	d7450513          	addi	a0,a0,-652 # 80008628 <syscalls+0x238>
    800038bc:	00002097          	auipc	ra,0x2
    800038c0:	4a0080e7          	jalr	1184(ra) # 80005d5c <panic>
    panic("log_write outside of trans");
    800038c4:	00005517          	auipc	a0,0x5
    800038c8:	d7c50513          	addi	a0,a0,-644 # 80008640 <syscalls+0x250>
    800038cc:	00002097          	auipc	ra,0x2
    800038d0:	490080e7          	jalr	1168(ra) # 80005d5c <panic>
  log.lh.block[i] = b->blockno;
    800038d4:	00878693          	addi	a3,a5,8
    800038d8:	068a                	slli	a3,a3,0x2
    800038da:	00015717          	auipc	a4,0x15
    800038de:	26670713          	addi	a4,a4,614 # 80018b40 <log>
    800038e2:	9736                	add	a4,a4,a3
    800038e4:	44d4                	lw	a3,12(s1)
    800038e6:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800038e8:	faf609e3          	beq	a2,a5,8000389a <log_write+0x76>
  }
  release(&log.lock);
    800038ec:	00015517          	auipc	a0,0x15
    800038f0:	25450513          	addi	a0,a0,596 # 80018b40 <log>
    800038f4:	00003097          	auipc	ra,0x3
    800038f8:	a54080e7          	jalr	-1452(ra) # 80006348 <release>
}
    800038fc:	60e2                	ld	ra,24(sp)
    800038fe:	6442                	ld	s0,16(sp)
    80003900:	64a2                	ld	s1,8(sp)
    80003902:	6902                	ld	s2,0(sp)
    80003904:	6105                	addi	sp,sp,32
    80003906:	8082                	ret

0000000080003908 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003908:	1101                	addi	sp,sp,-32
    8000390a:	ec06                	sd	ra,24(sp)
    8000390c:	e822                	sd	s0,16(sp)
    8000390e:	e426                	sd	s1,8(sp)
    80003910:	e04a                	sd	s2,0(sp)
    80003912:	1000                	addi	s0,sp,32
    80003914:	84aa                	mv	s1,a0
    80003916:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003918:	00005597          	auipc	a1,0x5
    8000391c:	d4858593          	addi	a1,a1,-696 # 80008660 <syscalls+0x270>
    80003920:	0521                	addi	a0,a0,8
    80003922:	00003097          	auipc	ra,0x3
    80003926:	8e2080e7          	jalr	-1822(ra) # 80006204 <initlock>
  lk->name = name;
    8000392a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000392e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003932:	0204a423          	sw	zero,40(s1)
}
    80003936:	60e2                	ld	ra,24(sp)
    80003938:	6442                	ld	s0,16(sp)
    8000393a:	64a2                	ld	s1,8(sp)
    8000393c:	6902                	ld	s2,0(sp)
    8000393e:	6105                	addi	sp,sp,32
    80003940:	8082                	ret

0000000080003942 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003942:	1101                	addi	sp,sp,-32
    80003944:	ec06                	sd	ra,24(sp)
    80003946:	e822                	sd	s0,16(sp)
    80003948:	e426                	sd	s1,8(sp)
    8000394a:	e04a                	sd	s2,0(sp)
    8000394c:	1000                	addi	s0,sp,32
    8000394e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003950:	00850913          	addi	s2,a0,8
    80003954:	854a                	mv	a0,s2
    80003956:	00003097          	auipc	ra,0x3
    8000395a:	93e080e7          	jalr	-1730(ra) # 80006294 <acquire>
  while (lk->locked) {
    8000395e:	409c                	lw	a5,0(s1)
    80003960:	cb89                	beqz	a5,80003972 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003962:	85ca                	mv	a1,s2
    80003964:	8526                	mv	a0,s1
    80003966:	ffffe097          	auipc	ra,0xffffe
    8000396a:	d36080e7          	jalr	-714(ra) # 8000169c <sleep>
  while (lk->locked) {
    8000396e:	409c                	lw	a5,0(s1)
    80003970:	fbed                	bnez	a5,80003962 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003972:	4785                	li	a5,1
    80003974:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003976:	ffffd097          	auipc	ra,0xffffd
    8000397a:	5c2080e7          	jalr	1474(ra) # 80000f38 <myproc>
    8000397e:	591c                	lw	a5,48(a0)
    80003980:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003982:	854a                	mv	a0,s2
    80003984:	00003097          	auipc	ra,0x3
    80003988:	9c4080e7          	jalr	-1596(ra) # 80006348 <release>
}
    8000398c:	60e2                	ld	ra,24(sp)
    8000398e:	6442                	ld	s0,16(sp)
    80003990:	64a2                	ld	s1,8(sp)
    80003992:	6902                	ld	s2,0(sp)
    80003994:	6105                	addi	sp,sp,32
    80003996:	8082                	ret

0000000080003998 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003998:	1101                	addi	sp,sp,-32
    8000399a:	ec06                	sd	ra,24(sp)
    8000399c:	e822                	sd	s0,16(sp)
    8000399e:	e426                	sd	s1,8(sp)
    800039a0:	e04a                	sd	s2,0(sp)
    800039a2:	1000                	addi	s0,sp,32
    800039a4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039a6:	00850913          	addi	s2,a0,8
    800039aa:	854a                	mv	a0,s2
    800039ac:	00003097          	auipc	ra,0x3
    800039b0:	8e8080e7          	jalr	-1816(ra) # 80006294 <acquire>
  lk->locked = 0;
    800039b4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039b8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800039bc:	8526                	mv	a0,s1
    800039be:	ffffe097          	auipc	ra,0xffffe
    800039c2:	d42080e7          	jalr	-702(ra) # 80001700 <wakeup>
  release(&lk->lk);
    800039c6:	854a                	mv	a0,s2
    800039c8:	00003097          	auipc	ra,0x3
    800039cc:	980080e7          	jalr	-1664(ra) # 80006348 <release>
}
    800039d0:	60e2                	ld	ra,24(sp)
    800039d2:	6442                	ld	s0,16(sp)
    800039d4:	64a2                	ld	s1,8(sp)
    800039d6:	6902                	ld	s2,0(sp)
    800039d8:	6105                	addi	sp,sp,32
    800039da:	8082                	ret

00000000800039dc <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800039dc:	7179                	addi	sp,sp,-48
    800039de:	f406                	sd	ra,40(sp)
    800039e0:	f022                	sd	s0,32(sp)
    800039e2:	ec26                	sd	s1,24(sp)
    800039e4:	e84a                	sd	s2,16(sp)
    800039e6:	e44e                	sd	s3,8(sp)
    800039e8:	1800                	addi	s0,sp,48
    800039ea:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800039ec:	00850913          	addi	s2,a0,8
    800039f0:	854a                	mv	a0,s2
    800039f2:	00003097          	auipc	ra,0x3
    800039f6:	8a2080e7          	jalr	-1886(ra) # 80006294 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039fa:	409c                	lw	a5,0(s1)
    800039fc:	ef99                	bnez	a5,80003a1a <holdingsleep+0x3e>
    800039fe:	4481                	li	s1,0
  release(&lk->lk);
    80003a00:	854a                	mv	a0,s2
    80003a02:	00003097          	auipc	ra,0x3
    80003a06:	946080e7          	jalr	-1722(ra) # 80006348 <release>
  return r;
}
    80003a0a:	8526                	mv	a0,s1
    80003a0c:	70a2                	ld	ra,40(sp)
    80003a0e:	7402                	ld	s0,32(sp)
    80003a10:	64e2                	ld	s1,24(sp)
    80003a12:	6942                	ld	s2,16(sp)
    80003a14:	69a2                	ld	s3,8(sp)
    80003a16:	6145                	addi	sp,sp,48
    80003a18:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a1a:	0284a983          	lw	s3,40(s1)
    80003a1e:	ffffd097          	auipc	ra,0xffffd
    80003a22:	51a080e7          	jalr	1306(ra) # 80000f38 <myproc>
    80003a26:	5904                	lw	s1,48(a0)
    80003a28:	413484b3          	sub	s1,s1,s3
    80003a2c:	0014b493          	seqz	s1,s1
    80003a30:	bfc1                	j	80003a00 <holdingsleep+0x24>

0000000080003a32 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a32:	1141                	addi	sp,sp,-16
    80003a34:	e406                	sd	ra,8(sp)
    80003a36:	e022                	sd	s0,0(sp)
    80003a38:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a3a:	00005597          	auipc	a1,0x5
    80003a3e:	c3658593          	addi	a1,a1,-970 # 80008670 <syscalls+0x280>
    80003a42:	00015517          	auipc	a0,0x15
    80003a46:	24650513          	addi	a0,a0,582 # 80018c88 <ftable>
    80003a4a:	00002097          	auipc	ra,0x2
    80003a4e:	7ba080e7          	jalr	1978(ra) # 80006204 <initlock>
}
    80003a52:	60a2                	ld	ra,8(sp)
    80003a54:	6402                	ld	s0,0(sp)
    80003a56:	0141                	addi	sp,sp,16
    80003a58:	8082                	ret

0000000080003a5a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a5a:	1101                	addi	sp,sp,-32
    80003a5c:	ec06                	sd	ra,24(sp)
    80003a5e:	e822                	sd	s0,16(sp)
    80003a60:	e426                	sd	s1,8(sp)
    80003a62:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a64:	00015517          	auipc	a0,0x15
    80003a68:	22450513          	addi	a0,a0,548 # 80018c88 <ftable>
    80003a6c:	00003097          	auipc	ra,0x3
    80003a70:	828080e7          	jalr	-2008(ra) # 80006294 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a74:	00015497          	auipc	s1,0x15
    80003a78:	22c48493          	addi	s1,s1,556 # 80018ca0 <ftable+0x18>
    80003a7c:	00016717          	auipc	a4,0x16
    80003a80:	1c470713          	addi	a4,a4,452 # 80019c40 <disk>
    if(f->ref == 0){
    80003a84:	40dc                	lw	a5,4(s1)
    80003a86:	cf99                	beqz	a5,80003aa4 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a88:	02848493          	addi	s1,s1,40
    80003a8c:	fee49ce3          	bne	s1,a4,80003a84 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a90:	00015517          	auipc	a0,0x15
    80003a94:	1f850513          	addi	a0,a0,504 # 80018c88 <ftable>
    80003a98:	00003097          	auipc	ra,0x3
    80003a9c:	8b0080e7          	jalr	-1872(ra) # 80006348 <release>
  return 0;
    80003aa0:	4481                	li	s1,0
    80003aa2:	a819                	j	80003ab8 <filealloc+0x5e>
      f->ref = 1;
    80003aa4:	4785                	li	a5,1
    80003aa6:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003aa8:	00015517          	auipc	a0,0x15
    80003aac:	1e050513          	addi	a0,a0,480 # 80018c88 <ftable>
    80003ab0:	00003097          	auipc	ra,0x3
    80003ab4:	898080e7          	jalr	-1896(ra) # 80006348 <release>
}
    80003ab8:	8526                	mv	a0,s1
    80003aba:	60e2                	ld	ra,24(sp)
    80003abc:	6442                	ld	s0,16(sp)
    80003abe:	64a2                	ld	s1,8(sp)
    80003ac0:	6105                	addi	sp,sp,32
    80003ac2:	8082                	ret

0000000080003ac4 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003ac4:	1101                	addi	sp,sp,-32
    80003ac6:	ec06                	sd	ra,24(sp)
    80003ac8:	e822                	sd	s0,16(sp)
    80003aca:	e426                	sd	s1,8(sp)
    80003acc:	1000                	addi	s0,sp,32
    80003ace:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003ad0:	00015517          	auipc	a0,0x15
    80003ad4:	1b850513          	addi	a0,a0,440 # 80018c88 <ftable>
    80003ad8:	00002097          	auipc	ra,0x2
    80003adc:	7bc080e7          	jalr	1980(ra) # 80006294 <acquire>
  if(f->ref < 1)
    80003ae0:	40dc                	lw	a5,4(s1)
    80003ae2:	02f05263          	blez	a5,80003b06 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003ae6:	2785                	addiw	a5,a5,1
    80003ae8:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003aea:	00015517          	auipc	a0,0x15
    80003aee:	19e50513          	addi	a0,a0,414 # 80018c88 <ftable>
    80003af2:	00003097          	auipc	ra,0x3
    80003af6:	856080e7          	jalr	-1962(ra) # 80006348 <release>
  return f;
}
    80003afa:	8526                	mv	a0,s1
    80003afc:	60e2                	ld	ra,24(sp)
    80003afe:	6442                	ld	s0,16(sp)
    80003b00:	64a2                	ld	s1,8(sp)
    80003b02:	6105                	addi	sp,sp,32
    80003b04:	8082                	ret
    panic("filedup");
    80003b06:	00005517          	auipc	a0,0x5
    80003b0a:	b7250513          	addi	a0,a0,-1166 # 80008678 <syscalls+0x288>
    80003b0e:	00002097          	auipc	ra,0x2
    80003b12:	24e080e7          	jalr	590(ra) # 80005d5c <panic>

0000000080003b16 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b16:	7139                	addi	sp,sp,-64
    80003b18:	fc06                	sd	ra,56(sp)
    80003b1a:	f822                	sd	s0,48(sp)
    80003b1c:	f426                	sd	s1,40(sp)
    80003b1e:	f04a                	sd	s2,32(sp)
    80003b20:	ec4e                	sd	s3,24(sp)
    80003b22:	e852                	sd	s4,16(sp)
    80003b24:	e456                	sd	s5,8(sp)
    80003b26:	0080                	addi	s0,sp,64
    80003b28:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b2a:	00015517          	auipc	a0,0x15
    80003b2e:	15e50513          	addi	a0,a0,350 # 80018c88 <ftable>
    80003b32:	00002097          	auipc	ra,0x2
    80003b36:	762080e7          	jalr	1890(ra) # 80006294 <acquire>
  if(f->ref < 1)
    80003b3a:	40dc                	lw	a5,4(s1)
    80003b3c:	06f05163          	blez	a5,80003b9e <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b40:	37fd                	addiw	a5,a5,-1
    80003b42:	0007871b          	sext.w	a4,a5
    80003b46:	c0dc                	sw	a5,4(s1)
    80003b48:	06e04363          	bgtz	a4,80003bae <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b4c:	0004a903          	lw	s2,0(s1)
    80003b50:	0094ca83          	lbu	s5,9(s1)
    80003b54:	0104ba03          	ld	s4,16(s1)
    80003b58:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b5c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b60:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b64:	00015517          	auipc	a0,0x15
    80003b68:	12450513          	addi	a0,a0,292 # 80018c88 <ftable>
    80003b6c:	00002097          	auipc	ra,0x2
    80003b70:	7dc080e7          	jalr	2012(ra) # 80006348 <release>

  if(ff.type == FD_PIPE){
    80003b74:	4785                	li	a5,1
    80003b76:	04f90d63          	beq	s2,a5,80003bd0 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b7a:	3979                	addiw	s2,s2,-2
    80003b7c:	4785                	li	a5,1
    80003b7e:	0527e063          	bltu	a5,s2,80003bbe <fileclose+0xa8>
    begin_op();
    80003b82:	00000097          	auipc	ra,0x0
    80003b86:	acc080e7          	jalr	-1332(ra) # 8000364e <begin_op>
    iput(ff.ip);
    80003b8a:	854e                	mv	a0,s3
    80003b8c:	fffff097          	auipc	ra,0xfffff
    80003b90:	2b0080e7          	jalr	688(ra) # 80002e3c <iput>
    end_op();
    80003b94:	00000097          	auipc	ra,0x0
    80003b98:	b38080e7          	jalr	-1224(ra) # 800036cc <end_op>
    80003b9c:	a00d                	j	80003bbe <fileclose+0xa8>
    panic("fileclose");
    80003b9e:	00005517          	auipc	a0,0x5
    80003ba2:	ae250513          	addi	a0,a0,-1310 # 80008680 <syscalls+0x290>
    80003ba6:	00002097          	auipc	ra,0x2
    80003baa:	1b6080e7          	jalr	438(ra) # 80005d5c <panic>
    release(&ftable.lock);
    80003bae:	00015517          	auipc	a0,0x15
    80003bb2:	0da50513          	addi	a0,a0,218 # 80018c88 <ftable>
    80003bb6:	00002097          	auipc	ra,0x2
    80003bba:	792080e7          	jalr	1938(ra) # 80006348 <release>
  }
}
    80003bbe:	70e2                	ld	ra,56(sp)
    80003bc0:	7442                	ld	s0,48(sp)
    80003bc2:	74a2                	ld	s1,40(sp)
    80003bc4:	7902                	ld	s2,32(sp)
    80003bc6:	69e2                	ld	s3,24(sp)
    80003bc8:	6a42                	ld	s4,16(sp)
    80003bca:	6aa2                	ld	s5,8(sp)
    80003bcc:	6121                	addi	sp,sp,64
    80003bce:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003bd0:	85d6                	mv	a1,s5
    80003bd2:	8552                	mv	a0,s4
    80003bd4:	00000097          	auipc	ra,0x0
    80003bd8:	34c080e7          	jalr	844(ra) # 80003f20 <pipeclose>
    80003bdc:	b7cd                	j	80003bbe <fileclose+0xa8>

0000000080003bde <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003bde:	715d                	addi	sp,sp,-80
    80003be0:	e486                	sd	ra,72(sp)
    80003be2:	e0a2                	sd	s0,64(sp)
    80003be4:	fc26                	sd	s1,56(sp)
    80003be6:	f84a                	sd	s2,48(sp)
    80003be8:	f44e                	sd	s3,40(sp)
    80003bea:	0880                	addi	s0,sp,80
    80003bec:	84aa                	mv	s1,a0
    80003bee:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003bf0:	ffffd097          	auipc	ra,0xffffd
    80003bf4:	348080e7          	jalr	840(ra) # 80000f38 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003bf8:	409c                	lw	a5,0(s1)
    80003bfa:	37f9                	addiw	a5,a5,-2
    80003bfc:	4705                	li	a4,1
    80003bfe:	04f76763          	bltu	a4,a5,80003c4c <filestat+0x6e>
    80003c02:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c04:	6c88                	ld	a0,24(s1)
    80003c06:	fffff097          	auipc	ra,0xfffff
    80003c0a:	07c080e7          	jalr	124(ra) # 80002c82 <ilock>
    stati(f->ip, &st);
    80003c0e:	fb840593          	addi	a1,s0,-72
    80003c12:	6c88                	ld	a0,24(s1)
    80003c14:	fffff097          	auipc	ra,0xfffff
    80003c18:	2f8080e7          	jalr	760(ra) # 80002f0c <stati>
    iunlock(f->ip);
    80003c1c:	6c88                	ld	a0,24(s1)
    80003c1e:	fffff097          	auipc	ra,0xfffff
    80003c22:	126080e7          	jalr	294(ra) # 80002d44 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c26:	46e1                	li	a3,24
    80003c28:	fb840613          	addi	a2,s0,-72
    80003c2c:	85ce                	mv	a1,s3
    80003c2e:	05093503          	ld	a0,80(s2)
    80003c32:	ffffd097          	auipc	ra,0xffffd
    80003c36:	ee2080e7          	jalr	-286(ra) # 80000b14 <copyout>
    80003c3a:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c3e:	60a6                	ld	ra,72(sp)
    80003c40:	6406                	ld	s0,64(sp)
    80003c42:	74e2                	ld	s1,56(sp)
    80003c44:	7942                	ld	s2,48(sp)
    80003c46:	79a2                	ld	s3,40(sp)
    80003c48:	6161                	addi	sp,sp,80
    80003c4a:	8082                	ret
  return -1;
    80003c4c:	557d                	li	a0,-1
    80003c4e:	bfc5                	j	80003c3e <filestat+0x60>

0000000080003c50 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c50:	7179                	addi	sp,sp,-48
    80003c52:	f406                	sd	ra,40(sp)
    80003c54:	f022                	sd	s0,32(sp)
    80003c56:	ec26                	sd	s1,24(sp)
    80003c58:	e84a                	sd	s2,16(sp)
    80003c5a:	e44e                	sd	s3,8(sp)
    80003c5c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c5e:	00854783          	lbu	a5,8(a0)
    80003c62:	c3d5                	beqz	a5,80003d06 <fileread+0xb6>
    80003c64:	84aa                	mv	s1,a0
    80003c66:	89ae                	mv	s3,a1
    80003c68:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c6a:	411c                	lw	a5,0(a0)
    80003c6c:	4705                	li	a4,1
    80003c6e:	04e78963          	beq	a5,a4,80003cc0 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c72:	470d                	li	a4,3
    80003c74:	04e78d63          	beq	a5,a4,80003cce <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c78:	4709                	li	a4,2
    80003c7a:	06e79e63          	bne	a5,a4,80003cf6 <fileread+0xa6>
    ilock(f->ip);
    80003c7e:	6d08                	ld	a0,24(a0)
    80003c80:	fffff097          	auipc	ra,0xfffff
    80003c84:	002080e7          	jalr	2(ra) # 80002c82 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c88:	874a                	mv	a4,s2
    80003c8a:	5094                	lw	a3,32(s1)
    80003c8c:	864e                	mv	a2,s3
    80003c8e:	4585                	li	a1,1
    80003c90:	6c88                	ld	a0,24(s1)
    80003c92:	fffff097          	auipc	ra,0xfffff
    80003c96:	2a4080e7          	jalr	676(ra) # 80002f36 <readi>
    80003c9a:	892a                	mv	s2,a0
    80003c9c:	00a05563          	blez	a0,80003ca6 <fileread+0x56>
      f->off += r;
    80003ca0:	509c                	lw	a5,32(s1)
    80003ca2:	9fa9                	addw	a5,a5,a0
    80003ca4:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003ca6:	6c88                	ld	a0,24(s1)
    80003ca8:	fffff097          	auipc	ra,0xfffff
    80003cac:	09c080e7          	jalr	156(ra) # 80002d44 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003cb0:	854a                	mv	a0,s2
    80003cb2:	70a2                	ld	ra,40(sp)
    80003cb4:	7402                	ld	s0,32(sp)
    80003cb6:	64e2                	ld	s1,24(sp)
    80003cb8:	6942                	ld	s2,16(sp)
    80003cba:	69a2                	ld	s3,8(sp)
    80003cbc:	6145                	addi	sp,sp,48
    80003cbe:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003cc0:	6908                	ld	a0,16(a0)
    80003cc2:	00000097          	auipc	ra,0x0
    80003cc6:	3c6080e7          	jalr	966(ra) # 80004088 <piperead>
    80003cca:	892a                	mv	s2,a0
    80003ccc:	b7d5                	j	80003cb0 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003cce:	02451783          	lh	a5,36(a0)
    80003cd2:	03079693          	slli	a3,a5,0x30
    80003cd6:	92c1                	srli	a3,a3,0x30
    80003cd8:	4725                	li	a4,9
    80003cda:	02d76863          	bltu	a4,a3,80003d0a <fileread+0xba>
    80003cde:	0792                	slli	a5,a5,0x4
    80003ce0:	00015717          	auipc	a4,0x15
    80003ce4:	f0870713          	addi	a4,a4,-248 # 80018be8 <devsw>
    80003ce8:	97ba                	add	a5,a5,a4
    80003cea:	639c                	ld	a5,0(a5)
    80003cec:	c38d                	beqz	a5,80003d0e <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003cee:	4505                	li	a0,1
    80003cf0:	9782                	jalr	a5
    80003cf2:	892a                	mv	s2,a0
    80003cf4:	bf75                	j	80003cb0 <fileread+0x60>
    panic("fileread");
    80003cf6:	00005517          	auipc	a0,0x5
    80003cfa:	99a50513          	addi	a0,a0,-1638 # 80008690 <syscalls+0x2a0>
    80003cfe:	00002097          	auipc	ra,0x2
    80003d02:	05e080e7          	jalr	94(ra) # 80005d5c <panic>
    return -1;
    80003d06:	597d                	li	s2,-1
    80003d08:	b765                	j	80003cb0 <fileread+0x60>
      return -1;
    80003d0a:	597d                	li	s2,-1
    80003d0c:	b755                	j	80003cb0 <fileread+0x60>
    80003d0e:	597d                	li	s2,-1
    80003d10:	b745                	j	80003cb0 <fileread+0x60>

0000000080003d12 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d12:	715d                	addi	sp,sp,-80
    80003d14:	e486                	sd	ra,72(sp)
    80003d16:	e0a2                	sd	s0,64(sp)
    80003d18:	fc26                	sd	s1,56(sp)
    80003d1a:	f84a                	sd	s2,48(sp)
    80003d1c:	f44e                	sd	s3,40(sp)
    80003d1e:	f052                	sd	s4,32(sp)
    80003d20:	ec56                	sd	s5,24(sp)
    80003d22:	e85a                	sd	s6,16(sp)
    80003d24:	e45e                	sd	s7,8(sp)
    80003d26:	e062                	sd	s8,0(sp)
    80003d28:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d2a:	00954783          	lbu	a5,9(a0)
    80003d2e:	10078663          	beqz	a5,80003e3a <filewrite+0x128>
    80003d32:	892a                	mv	s2,a0
    80003d34:	8b2e                	mv	s6,a1
    80003d36:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d38:	411c                	lw	a5,0(a0)
    80003d3a:	4705                	li	a4,1
    80003d3c:	02e78263          	beq	a5,a4,80003d60 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d40:	470d                	li	a4,3
    80003d42:	02e78663          	beq	a5,a4,80003d6e <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d46:	4709                	li	a4,2
    80003d48:	0ee79163          	bne	a5,a4,80003e2a <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d4c:	0ac05d63          	blez	a2,80003e06 <filewrite+0xf4>
    int i = 0;
    80003d50:	4981                	li	s3,0
    80003d52:	6b85                	lui	s7,0x1
    80003d54:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003d58:	6c05                	lui	s8,0x1
    80003d5a:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003d5e:	a861                	j	80003df6 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d60:	6908                	ld	a0,16(a0)
    80003d62:	00000097          	auipc	ra,0x0
    80003d66:	22e080e7          	jalr	558(ra) # 80003f90 <pipewrite>
    80003d6a:	8a2a                	mv	s4,a0
    80003d6c:	a045                	j	80003e0c <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d6e:	02451783          	lh	a5,36(a0)
    80003d72:	03079693          	slli	a3,a5,0x30
    80003d76:	92c1                	srli	a3,a3,0x30
    80003d78:	4725                	li	a4,9
    80003d7a:	0cd76263          	bltu	a4,a3,80003e3e <filewrite+0x12c>
    80003d7e:	0792                	slli	a5,a5,0x4
    80003d80:	00015717          	auipc	a4,0x15
    80003d84:	e6870713          	addi	a4,a4,-408 # 80018be8 <devsw>
    80003d88:	97ba                	add	a5,a5,a4
    80003d8a:	679c                	ld	a5,8(a5)
    80003d8c:	cbdd                	beqz	a5,80003e42 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d8e:	4505                	li	a0,1
    80003d90:	9782                	jalr	a5
    80003d92:	8a2a                	mv	s4,a0
    80003d94:	a8a5                	j	80003e0c <filewrite+0xfa>
    80003d96:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d9a:	00000097          	auipc	ra,0x0
    80003d9e:	8b4080e7          	jalr	-1868(ra) # 8000364e <begin_op>
      ilock(f->ip);
    80003da2:	01893503          	ld	a0,24(s2)
    80003da6:	fffff097          	auipc	ra,0xfffff
    80003daa:	edc080e7          	jalr	-292(ra) # 80002c82 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003dae:	8756                	mv	a4,s5
    80003db0:	02092683          	lw	a3,32(s2)
    80003db4:	01698633          	add	a2,s3,s6
    80003db8:	4585                	li	a1,1
    80003dba:	01893503          	ld	a0,24(s2)
    80003dbe:	fffff097          	auipc	ra,0xfffff
    80003dc2:	270080e7          	jalr	624(ra) # 8000302e <writei>
    80003dc6:	84aa                	mv	s1,a0
    80003dc8:	00a05763          	blez	a0,80003dd6 <filewrite+0xc4>
        f->off += r;
    80003dcc:	02092783          	lw	a5,32(s2)
    80003dd0:	9fa9                	addw	a5,a5,a0
    80003dd2:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003dd6:	01893503          	ld	a0,24(s2)
    80003dda:	fffff097          	auipc	ra,0xfffff
    80003dde:	f6a080e7          	jalr	-150(ra) # 80002d44 <iunlock>
      end_op();
    80003de2:	00000097          	auipc	ra,0x0
    80003de6:	8ea080e7          	jalr	-1814(ra) # 800036cc <end_op>

      if(r != n1){
    80003dea:	009a9f63          	bne	s5,s1,80003e08 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003dee:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003df2:	0149db63          	bge	s3,s4,80003e08 <filewrite+0xf6>
      int n1 = n - i;
    80003df6:	413a04bb          	subw	s1,s4,s3
    80003dfa:	0004879b          	sext.w	a5,s1
    80003dfe:	f8fbdce3          	bge	s7,a5,80003d96 <filewrite+0x84>
    80003e02:	84e2                	mv	s1,s8
    80003e04:	bf49                	j	80003d96 <filewrite+0x84>
    int i = 0;
    80003e06:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e08:	013a1f63          	bne	s4,s3,80003e26 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e0c:	8552                	mv	a0,s4
    80003e0e:	60a6                	ld	ra,72(sp)
    80003e10:	6406                	ld	s0,64(sp)
    80003e12:	74e2                	ld	s1,56(sp)
    80003e14:	7942                	ld	s2,48(sp)
    80003e16:	79a2                	ld	s3,40(sp)
    80003e18:	7a02                	ld	s4,32(sp)
    80003e1a:	6ae2                	ld	s5,24(sp)
    80003e1c:	6b42                	ld	s6,16(sp)
    80003e1e:	6ba2                	ld	s7,8(sp)
    80003e20:	6c02                	ld	s8,0(sp)
    80003e22:	6161                	addi	sp,sp,80
    80003e24:	8082                	ret
    ret = (i == n ? n : -1);
    80003e26:	5a7d                	li	s4,-1
    80003e28:	b7d5                	j	80003e0c <filewrite+0xfa>
    panic("filewrite");
    80003e2a:	00005517          	auipc	a0,0x5
    80003e2e:	87650513          	addi	a0,a0,-1930 # 800086a0 <syscalls+0x2b0>
    80003e32:	00002097          	auipc	ra,0x2
    80003e36:	f2a080e7          	jalr	-214(ra) # 80005d5c <panic>
    return -1;
    80003e3a:	5a7d                	li	s4,-1
    80003e3c:	bfc1                	j	80003e0c <filewrite+0xfa>
      return -1;
    80003e3e:	5a7d                	li	s4,-1
    80003e40:	b7f1                	j	80003e0c <filewrite+0xfa>
    80003e42:	5a7d                	li	s4,-1
    80003e44:	b7e1                	j	80003e0c <filewrite+0xfa>

0000000080003e46 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e46:	7179                	addi	sp,sp,-48
    80003e48:	f406                	sd	ra,40(sp)
    80003e4a:	f022                	sd	s0,32(sp)
    80003e4c:	ec26                	sd	s1,24(sp)
    80003e4e:	e84a                	sd	s2,16(sp)
    80003e50:	e44e                	sd	s3,8(sp)
    80003e52:	e052                	sd	s4,0(sp)
    80003e54:	1800                	addi	s0,sp,48
    80003e56:	84aa                	mv	s1,a0
    80003e58:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e5a:	0005b023          	sd	zero,0(a1)
    80003e5e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e62:	00000097          	auipc	ra,0x0
    80003e66:	bf8080e7          	jalr	-1032(ra) # 80003a5a <filealloc>
    80003e6a:	e088                	sd	a0,0(s1)
    80003e6c:	c551                	beqz	a0,80003ef8 <pipealloc+0xb2>
    80003e6e:	00000097          	auipc	ra,0x0
    80003e72:	bec080e7          	jalr	-1044(ra) # 80003a5a <filealloc>
    80003e76:	00aa3023          	sd	a0,0(s4)
    80003e7a:	c92d                	beqz	a0,80003eec <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e7c:	ffffc097          	auipc	ra,0xffffc
    80003e80:	29e080e7          	jalr	670(ra) # 8000011a <kalloc>
    80003e84:	892a                	mv	s2,a0
    80003e86:	c125                	beqz	a0,80003ee6 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e88:	4985                	li	s3,1
    80003e8a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e8e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e92:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e96:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e9a:	00005597          	auipc	a1,0x5
    80003e9e:	81658593          	addi	a1,a1,-2026 # 800086b0 <syscalls+0x2c0>
    80003ea2:	00002097          	auipc	ra,0x2
    80003ea6:	362080e7          	jalr	866(ra) # 80006204 <initlock>
  (*f0)->type = FD_PIPE;
    80003eaa:	609c                	ld	a5,0(s1)
    80003eac:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003eb0:	609c                	ld	a5,0(s1)
    80003eb2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003eb6:	609c                	ld	a5,0(s1)
    80003eb8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003ebc:	609c                	ld	a5,0(s1)
    80003ebe:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003ec2:	000a3783          	ld	a5,0(s4)
    80003ec6:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003eca:	000a3783          	ld	a5,0(s4)
    80003ece:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003ed2:	000a3783          	ld	a5,0(s4)
    80003ed6:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003eda:	000a3783          	ld	a5,0(s4)
    80003ede:	0127b823          	sd	s2,16(a5)
  return 0;
    80003ee2:	4501                	li	a0,0
    80003ee4:	a025                	j	80003f0c <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ee6:	6088                	ld	a0,0(s1)
    80003ee8:	e501                	bnez	a0,80003ef0 <pipealloc+0xaa>
    80003eea:	a039                	j	80003ef8 <pipealloc+0xb2>
    80003eec:	6088                	ld	a0,0(s1)
    80003eee:	c51d                	beqz	a0,80003f1c <pipealloc+0xd6>
    fileclose(*f0);
    80003ef0:	00000097          	auipc	ra,0x0
    80003ef4:	c26080e7          	jalr	-986(ra) # 80003b16 <fileclose>
  if(*f1)
    80003ef8:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003efc:	557d                	li	a0,-1
  if(*f1)
    80003efe:	c799                	beqz	a5,80003f0c <pipealloc+0xc6>
    fileclose(*f1);
    80003f00:	853e                	mv	a0,a5
    80003f02:	00000097          	auipc	ra,0x0
    80003f06:	c14080e7          	jalr	-1004(ra) # 80003b16 <fileclose>
  return -1;
    80003f0a:	557d                	li	a0,-1
}
    80003f0c:	70a2                	ld	ra,40(sp)
    80003f0e:	7402                	ld	s0,32(sp)
    80003f10:	64e2                	ld	s1,24(sp)
    80003f12:	6942                	ld	s2,16(sp)
    80003f14:	69a2                	ld	s3,8(sp)
    80003f16:	6a02                	ld	s4,0(sp)
    80003f18:	6145                	addi	sp,sp,48
    80003f1a:	8082                	ret
  return -1;
    80003f1c:	557d                	li	a0,-1
    80003f1e:	b7fd                	j	80003f0c <pipealloc+0xc6>

0000000080003f20 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f20:	1101                	addi	sp,sp,-32
    80003f22:	ec06                	sd	ra,24(sp)
    80003f24:	e822                	sd	s0,16(sp)
    80003f26:	e426                	sd	s1,8(sp)
    80003f28:	e04a                	sd	s2,0(sp)
    80003f2a:	1000                	addi	s0,sp,32
    80003f2c:	84aa                	mv	s1,a0
    80003f2e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f30:	00002097          	auipc	ra,0x2
    80003f34:	364080e7          	jalr	868(ra) # 80006294 <acquire>
  if(writable){
    80003f38:	02090d63          	beqz	s2,80003f72 <pipeclose+0x52>
    pi->writeopen = 0;
    80003f3c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f40:	21848513          	addi	a0,s1,536
    80003f44:	ffffd097          	auipc	ra,0xffffd
    80003f48:	7bc080e7          	jalr	1980(ra) # 80001700 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f4c:	2204b783          	ld	a5,544(s1)
    80003f50:	eb95                	bnez	a5,80003f84 <pipeclose+0x64>
    release(&pi->lock);
    80003f52:	8526                	mv	a0,s1
    80003f54:	00002097          	auipc	ra,0x2
    80003f58:	3f4080e7          	jalr	1012(ra) # 80006348 <release>
    kfree((char*)pi);
    80003f5c:	8526                	mv	a0,s1
    80003f5e:	ffffc097          	auipc	ra,0xffffc
    80003f62:	0be080e7          	jalr	190(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f66:	60e2                	ld	ra,24(sp)
    80003f68:	6442                	ld	s0,16(sp)
    80003f6a:	64a2                	ld	s1,8(sp)
    80003f6c:	6902                	ld	s2,0(sp)
    80003f6e:	6105                	addi	sp,sp,32
    80003f70:	8082                	ret
    pi->readopen = 0;
    80003f72:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f76:	21c48513          	addi	a0,s1,540
    80003f7a:	ffffd097          	auipc	ra,0xffffd
    80003f7e:	786080e7          	jalr	1926(ra) # 80001700 <wakeup>
    80003f82:	b7e9                	j	80003f4c <pipeclose+0x2c>
    release(&pi->lock);
    80003f84:	8526                	mv	a0,s1
    80003f86:	00002097          	auipc	ra,0x2
    80003f8a:	3c2080e7          	jalr	962(ra) # 80006348 <release>
}
    80003f8e:	bfe1                	j	80003f66 <pipeclose+0x46>

0000000080003f90 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f90:	711d                	addi	sp,sp,-96
    80003f92:	ec86                	sd	ra,88(sp)
    80003f94:	e8a2                	sd	s0,80(sp)
    80003f96:	e4a6                	sd	s1,72(sp)
    80003f98:	e0ca                	sd	s2,64(sp)
    80003f9a:	fc4e                	sd	s3,56(sp)
    80003f9c:	f852                	sd	s4,48(sp)
    80003f9e:	f456                	sd	s5,40(sp)
    80003fa0:	f05a                	sd	s6,32(sp)
    80003fa2:	ec5e                	sd	s7,24(sp)
    80003fa4:	e862                	sd	s8,16(sp)
    80003fa6:	1080                	addi	s0,sp,96
    80003fa8:	84aa                	mv	s1,a0
    80003faa:	8aae                	mv	s5,a1
    80003fac:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003fae:	ffffd097          	auipc	ra,0xffffd
    80003fb2:	f8a080e7          	jalr	-118(ra) # 80000f38 <myproc>
    80003fb6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003fb8:	8526                	mv	a0,s1
    80003fba:	00002097          	auipc	ra,0x2
    80003fbe:	2da080e7          	jalr	730(ra) # 80006294 <acquire>
  while(i < n){
    80003fc2:	0b405663          	blez	s4,8000406e <pipewrite+0xde>
  int i = 0;
    80003fc6:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fc8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003fca:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003fce:	21c48b93          	addi	s7,s1,540
    80003fd2:	a089                	j	80004014 <pipewrite+0x84>
      release(&pi->lock);
    80003fd4:	8526                	mv	a0,s1
    80003fd6:	00002097          	auipc	ra,0x2
    80003fda:	372080e7          	jalr	882(ra) # 80006348 <release>
      return -1;
    80003fde:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fe0:	854a                	mv	a0,s2
    80003fe2:	60e6                	ld	ra,88(sp)
    80003fe4:	6446                	ld	s0,80(sp)
    80003fe6:	64a6                	ld	s1,72(sp)
    80003fe8:	6906                	ld	s2,64(sp)
    80003fea:	79e2                	ld	s3,56(sp)
    80003fec:	7a42                	ld	s4,48(sp)
    80003fee:	7aa2                	ld	s5,40(sp)
    80003ff0:	7b02                	ld	s6,32(sp)
    80003ff2:	6be2                	ld	s7,24(sp)
    80003ff4:	6c42                	ld	s8,16(sp)
    80003ff6:	6125                	addi	sp,sp,96
    80003ff8:	8082                	ret
      wakeup(&pi->nread);
    80003ffa:	8562                	mv	a0,s8
    80003ffc:	ffffd097          	auipc	ra,0xffffd
    80004000:	704080e7          	jalr	1796(ra) # 80001700 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004004:	85a6                	mv	a1,s1
    80004006:	855e                	mv	a0,s7
    80004008:	ffffd097          	auipc	ra,0xffffd
    8000400c:	694080e7          	jalr	1684(ra) # 8000169c <sleep>
  while(i < n){
    80004010:	07495063          	bge	s2,s4,80004070 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004014:	2204a783          	lw	a5,544(s1)
    80004018:	dfd5                	beqz	a5,80003fd4 <pipewrite+0x44>
    8000401a:	854e                	mv	a0,s3
    8000401c:	ffffe097          	auipc	ra,0xffffe
    80004020:	928080e7          	jalr	-1752(ra) # 80001944 <killed>
    80004024:	f945                	bnez	a0,80003fd4 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004026:	2184a783          	lw	a5,536(s1)
    8000402a:	21c4a703          	lw	a4,540(s1)
    8000402e:	2007879b          	addiw	a5,a5,512
    80004032:	fcf704e3          	beq	a4,a5,80003ffa <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004036:	4685                	li	a3,1
    80004038:	01590633          	add	a2,s2,s5
    8000403c:	faf40593          	addi	a1,s0,-81
    80004040:	0509b503          	ld	a0,80(s3)
    80004044:	ffffd097          	auipc	ra,0xffffd
    80004048:	b5c080e7          	jalr	-1188(ra) # 80000ba0 <copyin>
    8000404c:	03650263          	beq	a0,s6,80004070 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004050:	21c4a783          	lw	a5,540(s1)
    80004054:	0017871b          	addiw	a4,a5,1
    80004058:	20e4ae23          	sw	a4,540(s1)
    8000405c:	1ff7f793          	andi	a5,a5,511
    80004060:	97a6                	add	a5,a5,s1
    80004062:	faf44703          	lbu	a4,-81(s0)
    80004066:	00e78c23          	sb	a4,24(a5)
      i++;
    8000406a:	2905                	addiw	s2,s2,1
    8000406c:	b755                	j	80004010 <pipewrite+0x80>
  int i = 0;
    8000406e:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004070:	21848513          	addi	a0,s1,536
    80004074:	ffffd097          	auipc	ra,0xffffd
    80004078:	68c080e7          	jalr	1676(ra) # 80001700 <wakeup>
  release(&pi->lock);
    8000407c:	8526                	mv	a0,s1
    8000407e:	00002097          	auipc	ra,0x2
    80004082:	2ca080e7          	jalr	714(ra) # 80006348 <release>
  return i;
    80004086:	bfa9                	j	80003fe0 <pipewrite+0x50>

0000000080004088 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004088:	715d                	addi	sp,sp,-80
    8000408a:	e486                	sd	ra,72(sp)
    8000408c:	e0a2                	sd	s0,64(sp)
    8000408e:	fc26                	sd	s1,56(sp)
    80004090:	f84a                	sd	s2,48(sp)
    80004092:	f44e                	sd	s3,40(sp)
    80004094:	f052                	sd	s4,32(sp)
    80004096:	ec56                	sd	s5,24(sp)
    80004098:	e85a                	sd	s6,16(sp)
    8000409a:	0880                	addi	s0,sp,80
    8000409c:	84aa                	mv	s1,a0
    8000409e:	892e                	mv	s2,a1
    800040a0:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800040a2:	ffffd097          	auipc	ra,0xffffd
    800040a6:	e96080e7          	jalr	-362(ra) # 80000f38 <myproc>
    800040aa:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040ac:	8526                	mv	a0,s1
    800040ae:	00002097          	auipc	ra,0x2
    800040b2:	1e6080e7          	jalr	486(ra) # 80006294 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040b6:	2184a703          	lw	a4,536(s1)
    800040ba:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040be:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040c2:	02f71763          	bne	a4,a5,800040f0 <piperead+0x68>
    800040c6:	2244a783          	lw	a5,548(s1)
    800040ca:	c39d                	beqz	a5,800040f0 <piperead+0x68>
    if(killed(pr)){
    800040cc:	8552                	mv	a0,s4
    800040ce:	ffffe097          	auipc	ra,0xffffe
    800040d2:	876080e7          	jalr	-1930(ra) # 80001944 <killed>
    800040d6:	e949                	bnez	a0,80004168 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040d8:	85a6                	mv	a1,s1
    800040da:	854e                	mv	a0,s3
    800040dc:	ffffd097          	auipc	ra,0xffffd
    800040e0:	5c0080e7          	jalr	1472(ra) # 8000169c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040e4:	2184a703          	lw	a4,536(s1)
    800040e8:	21c4a783          	lw	a5,540(s1)
    800040ec:	fcf70de3          	beq	a4,a5,800040c6 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040f0:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040f2:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040f4:	05505463          	blez	s5,8000413c <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    800040f8:	2184a783          	lw	a5,536(s1)
    800040fc:	21c4a703          	lw	a4,540(s1)
    80004100:	02f70e63          	beq	a4,a5,8000413c <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004104:	0017871b          	addiw	a4,a5,1
    80004108:	20e4ac23          	sw	a4,536(s1)
    8000410c:	1ff7f793          	andi	a5,a5,511
    80004110:	97a6                	add	a5,a5,s1
    80004112:	0187c783          	lbu	a5,24(a5)
    80004116:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000411a:	4685                	li	a3,1
    8000411c:	fbf40613          	addi	a2,s0,-65
    80004120:	85ca                	mv	a1,s2
    80004122:	050a3503          	ld	a0,80(s4)
    80004126:	ffffd097          	auipc	ra,0xffffd
    8000412a:	9ee080e7          	jalr	-1554(ra) # 80000b14 <copyout>
    8000412e:	01650763          	beq	a0,s6,8000413c <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004132:	2985                	addiw	s3,s3,1
    80004134:	0905                	addi	s2,s2,1
    80004136:	fd3a91e3          	bne	s5,s3,800040f8 <piperead+0x70>
    8000413a:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000413c:	21c48513          	addi	a0,s1,540
    80004140:	ffffd097          	auipc	ra,0xffffd
    80004144:	5c0080e7          	jalr	1472(ra) # 80001700 <wakeup>
  release(&pi->lock);
    80004148:	8526                	mv	a0,s1
    8000414a:	00002097          	auipc	ra,0x2
    8000414e:	1fe080e7          	jalr	510(ra) # 80006348 <release>
  return i;
}
    80004152:	854e                	mv	a0,s3
    80004154:	60a6                	ld	ra,72(sp)
    80004156:	6406                	ld	s0,64(sp)
    80004158:	74e2                	ld	s1,56(sp)
    8000415a:	7942                	ld	s2,48(sp)
    8000415c:	79a2                	ld	s3,40(sp)
    8000415e:	7a02                	ld	s4,32(sp)
    80004160:	6ae2                	ld	s5,24(sp)
    80004162:	6b42                	ld	s6,16(sp)
    80004164:	6161                	addi	sp,sp,80
    80004166:	8082                	ret
      release(&pi->lock);
    80004168:	8526                	mv	a0,s1
    8000416a:	00002097          	auipc	ra,0x2
    8000416e:	1de080e7          	jalr	478(ra) # 80006348 <release>
      return -1;
    80004172:	59fd                	li	s3,-1
    80004174:	bff9                	j	80004152 <piperead+0xca>

0000000080004176 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004176:	1141                	addi	sp,sp,-16
    80004178:	e422                	sd	s0,8(sp)
    8000417a:	0800                	addi	s0,sp,16
    8000417c:	87aa                	mv	a5,a0
    int perm = 0;
    if (flags & 0x1)
    8000417e:	8905                	andi	a0,a0,1
    80004180:	050e                	slli	a0,a0,0x3
        perm = PTE_X;
    if (flags & 0x2)
    80004182:	8b89                	andi	a5,a5,2
    80004184:	c399                	beqz	a5,8000418a <flags2perm+0x14>
        perm |= PTE_W;
    80004186:	00456513          	ori	a0,a0,4
    return perm;
}
    8000418a:	6422                	ld	s0,8(sp)
    8000418c:	0141                	addi	sp,sp,16
    8000418e:	8082                	ret

0000000080004190 <exec>:

int exec(char *path, char **argv)
{
    80004190:	de010113          	addi	sp,sp,-544
    80004194:	20113c23          	sd	ra,536(sp)
    80004198:	20813823          	sd	s0,528(sp)
    8000419c:	20913423          	sd	s1,520(sp)
    800041a0:	21213023          	sd	s2,512(sp)
    800041a4:	ffce                	sd	s3,504(sp)
    800041a6:	fbd2                	sd	s4,496(sp)
    800041a8:	f7d6                	sd	s5,488(sp)
    800041aa:	f3da                	sd	s6,480(sp)
    800041ac:	efde                	sd	s7,472(sp)
    800041ae:	ebe2                	sd	s8,464(sp)
    800041b0:	e7e6                	sd	s9,456(sp)
    800041b2:	e3ea                	sd	s10,448(sp)
    800041b4:	ff6e                	sd	s11,440(sp)
    800041b6:	1400                	addi	s0,sp,544
    800041b8:	892a                	mv	s2,a0
    800041ba:	dea43423          	sd	a0,-536(s0)
    800041be:	deb43823          	sd	a1,-528(s0)
    uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    struct elfhdr elf;
    struct inode *ip;
    struct proghdr ph;
    pagetable_t pagetable = 0, oldpagetable;
    struct proc *p = myproc();
    800041c2:	ffffd097          	auipc	ra,0xffffd
    800041c6:	d76080e7          	jalr	-650(ra) # 80000f38 <myproc>
    800041ca:	84aa                	mv	s1,a0

    begin_op();
    800041cc:	fffff097          	auipc	ra,0xfffff
    800041d0:	482080e7          	jalr	1154(ra) # 8000364e <begin_op>

    if ((ip = namei(path)) == 0) {
    800041d4:	854a                	mv	a0,s2
    800041d6:	fffff097          	auipc	ra,0xfffff
    800041da:	258080e7          	jalr	600(ra) # 8000342e <namei>
    800041de:	c93d                	beqz	a0,80004254 <exec+0xc4>
    800041e0:	8aaa                	mv	s5,a0
        end_op();
        return -1;
    }
    ilock(ip);
    800041e2:	fffff097          	auipc	ra,0xfffff
    800041e6:	aa0080e7          	jalr	-1376(ra) # 80002c82 <ilock>

    // Check ELF header
    if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041ea:	04000713          	li	a4,64
    800041ee:	4681                	li	a3,0
    800041f0:	e5040613          	addi	a2,s0,-432
    800041f4:	4581                	li	a1,0
    800041f6:	8556                	mv	a0,s5
    800041f8:	fffff097          	auipc	ra,0xfffff
    800041fc:	d3e080e7          	jalr	-706(ra) # 80002f36 <readi>
    80004200:	04000793          	li	a5,64
    80004204:	00f51a63          	bne	a0,a5,80004218 <exec+0x88>
        goto bad;

    if (elf.magic != ELF_MAGIC)
    80004208:	e5042703          	lw	a4,-432(s0)
    8000420c:	464c47b7          	lui	a5,0x464c4
    80004210:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004214:	04f70663          	beq	a4,a5,80004260 <exec+0xd0>

bad:
    if (pagetable)
        proc_freepagetable(pagetable, sz);
    if (ip) {
        iunlockput(ip);
    80004218:	8556                	mv	a0,s5
    8000421a:	fffff097          	auipc	ra,0xfffff
    8000421e:	cca080e7          	jalr	-822(ra) # 80002ee4 <iunlockput>
        end_op();
    80004222:	fffff097          	auipc	ra,0xfffff
    80004226:	4aa080e7          	jalr	1194(ra) # 800036cc <end_op>
    }
    return -1;
    8000422a:	557d                	li	a0,-1
}
    8000422c:	21813083          	ld	ra,536(sp)
    80004230:	21013403          	ld	s0,528(sp)
    80004234:	20813483          	ld	s1,520(sp)
    80004238:	20013903          	ld	s2,512(sp)
    8000423c:	79fe                	ld	s3,504(sp)
    8000423e:	7a5e                	ld	s4,496(sp)
    80004240:	7abe                	ld	s5,488(sp)
    80004242:	7b1e                	ld	s6,480(sp)
    80004244:	6bfe                	ld	s7,472(sp)
    80004246:	6c5e                	ld	s8,464(sp)
    80004248:	6cbe                	ld	s9,456(sp)
    8000424a:	6d1e                	ld	s10,448(sp)
    8000424c:	7dfa                	ld	s11,440(sp)
    8000424e:	22010113          	addi	sp,sp,544
    80004252:	8082                	ret
        end_op();
    80004254:	fffff097          	auipc	ra,0xfffff
    80004258:	478080e7          	jalr	1144(ra) # 800036cc <end_op>
        return -1;
    8000425c:	557d                	li	a0,-1
    8000425e:	b7f9                	j	8000422c <exec+0x9c>
    if ((pagetable = proc_pagetable(p)) == 0)
    80004260:	8526                	mv	a0,s1
    80004262:	ffffd097          	auipc	ra,0xffffd
    80004266:	d9a080e7          	jalr	-614(ra) # 80000ffc <proc_pagetable>
    8000426a:	8b2a                	mv	s6,a0
    8000426c:	d555                	beqz	a0,80004218 <exec+0x88>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    8000426e:	e7042783          	lw	a5,-400(s0)
    80004272:	e8845703          	lhu	a4,-376(s0)
    80004276:	c735                	beqz	a4,800042e2 <exec+0x152>
    uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004278:	4901                	li	s2,0
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    8000427a:	e0043423          	sd	zero,-504(s0)
        if (ph.vaddr % PGSIZE != 0)
    8000427e:	6a05                	lui	s4,0x1
    80004280:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004284:	dee43023          	sd	a4,-544(s0)
static int loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
    uint i, n;
    uint64 pa;

    for (i = 0; i < sz; i += PGSIZE) {
    80004288:	6d85                	lui	s11,0x1
    8000428a:	7d7d                	lui	s10,0xfffff
    8000428c:	a4b5                	j	800044f8 <exec+0x368>
        pa = walkaddr(pagetable, va + i);
        if (pa == 0)
            panic("loadseg: address should exist");
    8000428e:	00004517          	auipc	a0,0x4
    80004292:	42a50513          	addi	a0,a0,1066 # 800086b8 <syscalls+0x2c8>
    80004296:	00002097          	auipc	ra,0x2
    8000429a:	ac6080e7          	jalr	-1338(ra) # 80005d5c <panic>
        if (sz - i < PGSIZE)
            n = sz - i;
        else
            n = PGSIZE;
        if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    8000429e:	874a                	mv	a4,s2
    800042a0:	009c86bb          	addw	a3,s9,s1
    800042a4:	4581                	li	a1,0
    800042a6:	8556                	mv	a0,s5
    800042a8:	fffff097          	auipc	ra,0xfffff
    800042ac:	c8e080e7          	jalr	-882(ra) # 80002f36 <readi>
    800042b0:	2501                	sext.w	a0,a0
    800042b2:	1ea91063          	bne	s2,a0,80004492 <exec+0x302>
    for (i = 0; i < sz; i += PGSIZE) {
    800042b6:	009d84bb          	addw	s1,s11,s1
    800042ba:	013d09bb          	addw	s3,s10,s3
    800042be:	2174fd63          	bgeu	s1,s7,800044d8 <exec+0x348>
        pa = walkaddr(pagetable, va + i);
    800042c2:	02049593          	slli	a1,s1,0x20
    800042c6:	9181                	srli	a1,a1,0x20
    800042c8:	95e2                	add	a1,a1,s8
    800042ca:	855a                	mv	a0,s6
    800042cc:	ffffc097          	auipc	ra,0xffffc
    800042d0:	238080e7          	jalr	568(ra) # 80000504 <walkaddr>
    800042d4:	862a                	mv	a2,a0
        if (pa == 0)
    800042d6:	dd45                	beqz	a0,8000428e <exec+0xfe>
            n = PGSIZE;
    800042d8:	8952                	mv	s2,s4
        if (sz - i < PGSIZE)
    800042da:	fd49f2e3          	bgeu	s3,s4,8000429e <exec+0x10e>
            n = sz - i;
    800042de:	894e                	mv	s2,s3
    800042e0:	bf7d                	j	8000429e <exec+0x10e>
    uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042e2:	4901                	li	s2,0
    iunlockput(ip);
    800042e4:	8556                	mv	a0,s5
    800042e6:	fffff097          	auipc	ra,0xfffff
    800042ea:	bfe080e7          	jalr	-1026(ra) # 80002ee4 <iunlockput>
    end_op();
    800042ee:	fffff097          	auipc	ra,0xfffff
    800042f2:	3de080e7          	jalr	990(ra) # 800036cc <end_op>
    p = myproc();
    800042f6:	ffffd097          	auipc	ra,0xffffd
    800042fa:	c42080e7          	jalr	-958(ra) # 80000f38 <myproc>
    800042fe:	8baa                	mv	s7,a0
    uint64 oldsz = p->sz;
    80004300:	04853d03          	ld	s10,72(a0)
    sz = PGROUNDUP(sz);
    80004304:	6785                	lui	a5,0x1
    80004306:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004308:	97ca                	add	a5,a5,s2
    8000430a:	777d                	lui	a4,0xfffff
    8000430c:	8ff9                	and	a5,a5,a4
    8000430e:	def43c23          	sd	a5,-520(s0)
    if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE, PTE_W)) == 0)
    80004312:	4691                	li	a3,4
    80004314:	6609                	lui	a2,0x2
    80004316:	963e                	add	a2,a2,a5
    80004318:	85be                	mv	a1,a5
    8000431a:	855a                	mv	a0,s6
    8000431c:	ffffc097          	auipc	ra,0xffffc
    80004320:	59c080e7          	jalr	1436(ra) # 800008b8 <uvmalloc>
    80004324:	8c2a                	mv	s8,a0
    ip = 0;
    80004326:	4a81                	li	s5,0
    if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE, PTE_W)) == 0)
    80004328:	16050563          	beqz	a0,80004492 <exec+0x302>
    uvmclear(pagetable, sz - 2 * PGSIZE);
    8000432c:	75f9                	lui	a1,0xffffe
    8000432e:	95aa                	add	a1,a1,a0
    80004330:	855a                	mv	a0,s6
    80004332:	ffffc097          	auipc	ra,0xffffc
    80004336:	7b0080e7          	jalr	1968(ra) # 80000ae2 <uvmclear>
    stackbase = sp - PGSIZE;
    8000433a:	7afd                	lui	s5,0xfffff
    8000433c:	9ae2                	add	s5,s5,s8
    for (argc = 0; argv[argc]; argc++) {
    8000433e:	df043783          	ld	a5,-528(s0)
    80004342:	6388                	ld	a0,0(a5)
    80004344:	c925                	beqz	a0,800043b4 <exec+0x224>
    80004346:	e9040993          	addi	s3,s0,-368
    8000434a:	f9040c93          	addi	s9,s0,-112
    sp = sz;
    8000434e:	8962                	mv	s2,s8
    for (argc = 0; argv[argc]; argc++) {
    80004350:	4481                	li	s1,0
        sp -= strlen(argv[argc]) + 1;
    80004352:	ffffc097          	auipc	ra,0xffffc
    80004356:	fa4080e7          	jalr	-92(ra) # 800002f6 <strlen>
    8000435a:	0015079b          	addiw	a5,a0,1
    8000435e:	40f907b3          	sub	a5,s2,a5
        sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004362:	ff07f913          	andi	s2,a5,-16
        if (sp < stackbase)
    80004366:	15596d63          	bltu	s2,s5,800044c0 <exec+0x330>
        if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000436a:	df043d83          	ld	s11,-528(s0)
    8000436e:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004372:	8552                	mv	a0,s4
    80004374:	ffffc097          	auipc	ra,0xffffc
    80004378:	f82080e7          	jalr	-126(ra) # 800002f6 <strlen>
    8000437c:	0015069b          	addiw	a3,a0,1
    80004380:	8652                	mv	a2,s4
    80004382:	85ca                	mv	a1,s2
    80004384:	855a                	mv	a0,s6
    80004386:	ffffc097          	auipc	ra,0xffffc
    8000438a:	78e080e7          	jalr	1934(ra) # 80000b14 <copyout>
    8000438e:	12054d63          	bltz	a0,800044c8 <exec+0x338>
        ustack[argc] = sp;
    80004392:	0129b023          	sd	s2,0(s3)
    for (argc = 0; argv[argc]; argc++) {
    80004396:	0485                	addi	s1,s1,1
    80004398:	008d8793          	addi	a5,s11,8
    8000439c:	def43823          	sd	a5,-528(s0)
    800043a0:	008db503          	ld	a0,8(s11)
    800043a4:	c911                	beqz	a0,800043b8 <exec+0x228>
        if (argc >= MAXARG)
    800043a6:	09a1                	addi	s3,s3,8
    800043a8:	fb3c95e3          	bne	s9,s3,80004352 <exec+0x1c2>
    sz = sz1;
    800043ac:	df843c23          	sd	s8,-520(s0)
    ip = 0;
    800043b0:	4a81                	li	s5,0
    800043b2:	a0c5                	j	80004492 <exec+0x302>
    sp = sz;
    800043b4:	8962                	mv	s2,s8
    for (argc = 0; argv[argc]; argc++) {
    800043b6:	4481                	li	s1,0
    ustack[argc] = 0;
    800043b8:	00349793          	slli	a5,s1,0x3
    800043bc:	f9078793          	addi	a5,a5,-112
    800043c0:	97a2                	add	a5,a5,s0
    800043c2:	f007b023          	sd	zero,-256(a5)
    sp -= (argc + 1) * sizeof(uint64);
    800043c6:	00148693          	addi	a3,s1,1
    800043ca:	068e                	slli	a3,a3,0x3
    800043cc:	40d90933          	sub	s2,s2,a3
    sp -= sp % 16;
    800043d0:	ff097913          	andi	s2,s2,-16
    if (sp < stackbase)
    800043d4:	01597663          	bgeu	s2,s5,800043e0 <exec+0x250>
    sz = sz1;
    800043d8:	df843c23          	sd	s8,-520(s0)
    ip = 0;
    800043dc:	4a81                	li	s5,0
    800043de:	a855                	j	80004492 <exec+0x302>
    if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    800043e0:	e9040613          	addi	a2,s0,-368
    800043e4:	85ca                	mv	a1,s2
    800043e6:	855a                	mv	a0,s6
    800043e8:	ffffc097          	auipc	ra,0xffffc
    800043ec:	72c080e7          	jalr	1836(ra) # 80000b14 <copyout>
    800043f0:	0e054063          	bltz	a0,800044d0 <exec+0x340>
    p->trapframe->a1 = sp;
    800043f4:	058bb783          	ld	a5,88(s7)
    800043f8:	0727bc23          	sd	s2,120(a5)
    for (last = s = path; *s; s++)
    800043fc:	de843783          	ld	a5,-536(s0)
    80004400:	0007c703          	lbu	a4,0(a5)
    80004404:	cf11                	beqz	a4,80004420 <exec+0x290>
    80004406:	0785                	addi	a5,a5,1
        if (*s == '/')
    80004408:	02f00693          	li	a3,47
    8000440c:	a039                	j	8000441a <exec+0x28a>
            last = s + 1;
    8000440e:	def43423          	sd	a5,-536(s0)
    for (last = s = path; *s; s++)
    80004412:	0785                	addi	a5,a5,1
    80004414:	fff7c703          	lbu	a4,-1(a5)
    80004418:	c701                	beqz	a4,80004420 <exec+0x290>
        if (*s == '/')
    8000441a:	fed71ce3          	bne	a4,a3,80004412 <exec+0x282>
    8000441e:	bfc5                	j	8000440e <exec+0x27e>
    safestrcpy(p->name, last, sizeof(p->name));
    80004420:	4641                	li	a2,16
    80004422:	de843583          	ld	a1,-536(s0)
    80004426:	158b8513          	addi	a0,s7,344
    8000442a:	ffffc097          	auipc	ra,0xffffc
    8000442e:	e9a080e7          	jalr	-358(ra) # 800002c4 <safestrcpy>
    oldpagetable = p->pagetable;
    80004432:	050bb503          	ld	a0,80(s7)
    p->pagetable = pagetable;
    80004436:	056bb823          	sd	s6,80(s7)
    p->sz = sz;
    8000443a:	058bb423          	sd	s8,72(s7)
    p->trapframe->epc = elf.entry; // initial program counter = main
    8000443e:	058bb783          	ld	a5,88(s7)
    80004442:	e6843703          	ld	a4,-408(s0)
    80004446:	ef98                	sd	a4,24(a5)
    p->trapframe->sp = sp;         // initial stack pointer
    80004448:	058bb783          	ld	a5,88(s7)
    8000444c:	0327b823          	sd	s2,48(a5)
    proc_freepagetable(oldpagetable, oldsz);
    80004450:	85ea                	mv	a1,s10
    80004452:	ffffd097          	auipc	ra,0xffffd
    80004456:	ca0080e7          	jalr	-864(ra) # 800010f2 <proc_freepagetable>
    if (p->pid == 1) {
    8000445a:	030ba703          	lw	a4,48(s7)
    8000445e:	4785                	li	a5,1
    80004460:	00f70563          	beq	a4,a5,8000446a <exec+0x2da>
    return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004464:	0004851b          	sext.w	a0,s1
    80004468:	b3d1                	j	8000422c <exec+0x9c>
        printf("page table %p\n", p->pagetable);
    8000446a:	050bb583          	ld	a1,80(s7)
    8000446e:	00004517          	auipc	a0,0x4
    80004472:	26a50513          	addi	a0,a0,618 # 800086d8 <syscalls+0x2e8>
    80004476:	00002097          	auipc	ra,0x2
    8000447a:	930080e7          	jalr	-1744(ra) # 80005da6 <printf>
        vmprint(p->pagetable, 1);
    8000447e:	4585                	li	a1,1
    80004480:	050bb503          	ld	a0,80(s7)
    80004484:	ffffd097          	auipc	ra,0xffffd
    80004488:	85a080e7          	jalr	-1958(ra) # 80000cde <vmprint>
    8000448c:	bfe1                	j	80004464 <exec+0x2d4>
    8000448e:	df243c23          	sd	s2,-520(s0)
        proc_freepagetable(pagetable, sz);
    80004492:	df843583          	ld	a1,-520(s0)
    80004496:	855a                	mv	a0,s6
    80004498:	ffffd097          	auipc	ra,0xffffd
    8000449c:	c5a080e7          	jalr	-934(ra) # 800010f2 <proc_freepagetable>
    if (ip) {
    800044a0:	d60a9ce3          	bnez	s5,80004218 <exec+0x88>
    return -1;
    800044a4:	557d                	li	a0,-1
    800044a6:	b359                	j	8000422c <exec+0x9c>
    800044a8:	df243c23          	sd	s2,-520(s0)
    800044ac:	b7dd                	j	80004492 <exec+0x302>
    800044ae:	df243c23          	sd	s2,-520(s0)
    800044b2:	b7c5                	j	80004492 <exec+0x302>
    800044b4:	df243c23          	sd	s2,-520(s0)
    800044b8:	bfe9                	j	80004492 <exec+0x302>
    800044ba:	df243c23          	sd	s2,-520(s0)
    800044be:	bfd1                	j	80004492 <exec+0x302>
    sz = sz1;
    800044c0:	df843c23          	sd	s8,-520(s0)
    ip = 0;
    800044c4:	4a81                	li	s5,0
    800044c6:	b7f1                	j	80004492 <exec+0x302>
    sz = sz1;
    800044c8:	df843c23          	sd	s8,-520(s0)
    ip = 0;
    800044cc:	4a81                	li	s5,0
    800044ce:	b7d1                	j	80004492 <exec+0x302>
    sz = sz1;
    800044d0:	df843c23          	sd	s8,-520(s0)
    ip = 0;
    800044d4:	4a81                	li	s5,0
    800044d6:	bf75                	j	80004492 <exec+0x302>
        if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044d8:	df843903          	ld	s2,-520(s0)
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800044dc:	e0843783          	ld	a5,-504(s0)
    800044e0:	0017869b          	addiw	a3,a5,1
    800044e4:	e0d43423          	sd	a3,-504(s0)
    800044e8:	e0043783          	ld	a5,-512(s0)
    800044ec:	0387879b          	addiw	a5,a5,56
    800044f0:	e8845703          	lhu	a4,-376(s0)
    800044f4:	dee6d8e3          	bge	a3,a4,800042e4 <exec+0x154>
        if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044f8:	2781                	sext.w	a5,a5
    800044fa:	e0f43023          	sd	a5,-512(s0)
    800044fe:	03800713          	li	a4,56
    80004502:	86be                	mv	a3,a5
    80004504:	e1840613          	addi	a2,s0,-488
    80004508:	4581                	li	a1,0
    8000450a:	8556                	mv	a0,s5
    8000450c:	fffff097          	auipc	ra,0xfffff
    80004510:	a2a080e7          	jalr	-1494(ra) # 80002f36 <readi>
    80004514:	03800793          	li	a5,56
    80004518:	f6f51be3          	bne	a0,a5,8000448e <exec+0x2fe>
        if (ph.type != ELF_PROG_LOAD)
    8000451c:	e1842783          	lw	a5,-488(s0)
    80004520:	4705                	li	a4,1
    80004522:	fae79de3          	bne	a5,a4,800044dc <exec+0x34c>
        if (ph.memsz < ph.filesz)
    80004526:	e4043483          	ld	s1,-448(s0)
    8000452a:	e3843783          	ld	a5,-456(s0)
    8000452e:	f6f4ede3          	bltu	s1,a5,800044a8 <exec+0x318>
        if (ph.vaddr + ph.memsz < ph.vaddr)
    80004532:	e2843783          	ld	a5,-472(s0)
    80004536:	94be                	add	s1,s1,a5
    80004538:	f6f4ebe3          	bltu	s1,a5,800044ae <exec+0x31e>
        if (ph.vaddr % PGSIZE != 0)
    8000453c:	de043703          	ld	a4,-544(s0)
    80004540:	8ff9                	and	a5,a5,a4
    80004542:	fbad                	bnez	a5,800044b4 <exec+0x324>
        if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004544:	e1c42503          	lw	a0,-484(s0)
    80004548:	00000097          	auipc	ra,0x0
    8000454c:	c2e080e7          	jalr	-978(ra) # 80004176 <flags2perm>
    80004550:	86aa                	mv	a3,a0
    80004552:	8626                	mv	a2,s1
    80004554:	85ca                	mv	a1,s2
    80004556:	855a                	mv	a0,s6
    80004558:	ffffc097          	auipc	ra,0xffffc
    8000455c:	360080e7          	jalr	864(ra) # 800008b8 <uvmalloc>
    80004560:	dea43c23          	sd	a0,-520(s0)
    80004564:	d939                	beqz	a0,800044ba <exec+0x32a>
        if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004566:	e2843c03          	ld	s8,-472(s0)
    8000456a:	e2042c83          	lw	s9,-480(s0)
    8000456e:	e3842b83          	lw	s7,-456(s0)
    for (i = 0; i < sz; i += PGSIZE) {
    80004572:	f60b83e3          	beqz	s7,800044d8 <exec+0x348>
    80004576:	89de                	mv	s3,s7
    80004578:	4481                	li	s1,0
    8000457a:	b3a1                	j	800042c2 <exec+0x132>

000000008000457c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000457c:	7179                	addi	sp,sp,-48
    8000457e:	f406                	sd	ra,40(sp)
    80004580:	f022                	sd	s0,32(sp)
    80004582:	ec26                	sd	s1,24(sp)
    80004584:	e84a                	sd	s2,16(sp)
    80004586:	1800                	addi	s0,sp,48
    80004588:	892e                	mv	s2,a1
    8000458a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000458c:	fdc40593          	addi	a1,s0,-36
    80004590:	ffffe097          	auipc	ra,0xffffe
    80004594:	b7a080e7          	jalr	-1158(ra) # 8000210a <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004598:	fdc42703          	lw	a4,-36(s0)
    8000459c:	47bd                	li	a5,15
    8000459e:	02e7eb63          	bltu	a5,a4,800045d4 <argfd+0x58>
    800045a2:	ffffd097          	auipc	ra,0xffffd
    800045a6:	996080e7          	jalr	-1642(ra) # 80000f38 <myproc>
    800045aa:	fdc42703          	lw	a4,-36(s0)
    800045ae:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffdd05a>
    800045b2:	078e                	slli	a5,a5,0x3
    800045b4:	953e                	add	a0,a0,a5
    800045b6:	611c                	ld	a5,0(a0)
    800045b8:	c385                	beqz	a5,800045d8 <argfd+0x5c>
    return -1;
  if(pfd)
    800045ba:	00090463          	beqz	s2,800045c2 <argfd+0x46>
    *pfd = fd;
    800045be:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800045c2:	4501                	li	a0,0
  if(pf)
    800045c4:	c091                	beqz	s1,800045c8 <argfd+0x4c>
    *pf = f;
    800045c6:	e09c                	sd	a5,0(s1)
}
    800045c8:	70a2                	ld	ra,40(sp)
    800045ca:	7402                	ld	s0,32(sp)
    800045cc:	64e2                	ld	s1,24(sp)
    800045ce:	6942                	ld	s2,16(sp)
    800045d0:	6145                	addi	sp,sp,48
    800045d2:	8082                	ret
    return -1;
    800045d4:	557d                	li	a0,-1
    800045d6:	bfcd                	j	800045c8 <argfd+0x4c>
    800045d8:	557d                	li	a0,-1
    800045da:	b7fd                	j	800045c8 <argfd+0x4c>

00000000800045dc <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800045dc:	1101                	addi	sp,sp,-32
    800045de:	ec06                	sd	ra,24(sp)
    800045e0:	e822                	sd	s0,16(sp)
    800045e2:	e426                	sd	s1,8(sp)
    800045e4:	1000                	addi	s0,sp,32
    800045e6:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800045e8:	ffffd097          	auipc	ra,0xffffd
    800045ec:	950080e7          	jalr	-1712(ra) # 80000f38 <myproc>
    800045f0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800045f2:	0d050793          	addi	a5,a0,208
    800045f6:	4501                	li	a0,0
    800045f8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800045fa:	6398                	ld	a4,0(a5)
    800045fc:	cb19                	beqz	a4,80004612 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800045fe:	2505                	addiw	a0,a0,1
    80004600:	07a1                	addi	a5,a5,8
    80004602:	fed51ce3          	bne	a0,a3,800045fa <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004606:	557d                	li	a0,-1
}
    80004608:	60e2                	ld	ra,24(sp)
    8000460a:	6442                	ld	s0,16(sp)
    8000460c:	64a2                	ld	s1,8(sp)
    8000460e:	6105                	addi	sp,sp,32
    80004610:	8082                	ret
      p->ofile[fd] = f;
    80004612:	01a50793          	addi	a5,a0,26
    80004616:	078e                	slli	a5,a5,0x3
    80004618:	963e                	add	a2,a2,a5
    8000461a:	e204                	sd	s1,0(a2)
      return fd;
    8000461c:	b7f5                	j	80004608 <fdalloc+0x2c>

000000008000461e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000461e:	715d                	addi	sp,sp,-80
    80004620:	e486                	sd	ra,72(sp)
    80004622:	e0a2                	sd	s0,64(sp)
    80004624:	fc26                	sd	s1,56(sp)
    80004626:	f84a                	sd	s2,48(sp)
    80004628:	f44e                	sd	s3,40(sp)
    8000462a:	f052                	sd	s4,32(sp)
    8000462c:	ec56                	sd	s5,24(sp)
    8000462e:	e85a                	sd	s6,16(sp)
    80004630:	0880                	addi	s0,sp,80
    80004632:	8b2e                	mv	s6,a1
    80004634:	89b2                	mv	s3,a2
    80004636:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004638:	fb040593          	addi	a1,s0,-80
    8000463c:	fffff097          	auipc	ra,0xfffff
    80004640:	e10080e7          	jalr	-496(ra) # 8000344c <nameiparent>
    80004644:	84aa                	mv	s1,a0
    80004646:	14050f63          	beqz	a0,800047a4 <create+0x186>
    return 0;

  ilock(dp);
    8000464a:	ffffe097          	auipc	ra,0xffffe
    8000464e:	638080e7          	jalr	1592(ra) # 80002c82 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004652:	4601                	li	a2,0
    80004654:	fb040593          	addi	a1,s0,-80
    80004658:	8526                	mv	a0,s1
    8000465a:	fffff097          	auipc	ra,0xfffff
    8000465e:	b0c080e7          	jalr	-1268(ra) # 80003166 <dirlookup>
    80004662:	8aaa                	mv	s5,a0
    80004664:	c931                	beqz	a0,800046b8 <create+0x9a>
    iunlockput(dp);
    80004666:	8526                	mv	a0,s1
    80004668:	fffff097          	auipc	ra,0xfffff
    8000466c:	87c080e7          	jalr	-1924(ra) # 80002ee4 <iunlockput>
    ilock(ip);
    80004670:	8556                	mv	a0,s5
    80004672:	ffffe097          	auipc	ra,0xffffe
    80004676:	610080e7          	jalr	1552(ra) # 80002c82 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000467a:	000b059b          	sext.w	a1,s6
    8000467e:	4789                	li	a5,2
    80004680:	02f59563          	bne	a1,a5,800046aa <create+0x8c>
    80004684:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdd084>
    80004688:	37f9                	addiw	a5,a5,-2
    8000468a:	17c2                	slli	a5,a5,0x30
    8000468c:	93c1                	srli	a5,a5,0x30
    8000468e:	4705                	li	a4,1
    80004690:	00f76d63          	bltu	a4,a5,800046aa <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004694:	8556                	mv	a0,s5
    80004696:	60a6                	ld	ra,72(sp)
    80004698:	6406                	ld	s0,64(sp)
    8000469a:	74e2                	ld	s1,56(sp)
    8000469c:	7942                	ld	s2,48(sp)
    8000469e:	79a2                	ld	s3,40(sp)
    800046a0:	7a02                	ld	s4,32(sp)
    800046a2:	6ae2                	ld	s5,24(sp)
    800046a4:	6b42                	ld	s6,16(sp)
    800046a6:	6161                	addi	sp,sp,80
    800046a8:	8082                	ret
    iunlockput(ip);
    800046aa:	8556                	mv	a0,s5
    800046ac:	fffff097          	auipc	ra,0xfffff
    800046b0:	838080e7          	jalr	-1992(ra) # 80002ee4 <iunlockput>
    return 0;
    800046b4:	4a81                	li	s5,0
    800046b6:	bff9                	j	80004694 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800046b8:	85da                	mv	a1,s6
    800046ba:	4088                	lw	a0,0(s1)
    800046bc:	ffffe097          	auipc	ra,0xffffe
    800046c0:	428080e7          	jalr	1064(ra) # 80002ae4 <ialloc>
    800046c4:	8a2a                	mv	s4,a0
    800046c6:	c539                	beqz	a0,80004714 <create+0xf6>
  ilock(ip);
    800046c8:	ffffe097          	auipc	ra,0xffffe
    800046cc:	5ba080e7          	jalr	1466(ra) # 80002c82 <ilock>
  ip->major = major;
    800046d0:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800046d4:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800046d8:	4905                	li	s2,1
    800046da:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800046de:	8552                	mv	a0,s4
    800046e0:	ffffe097          	auipc	ra,0xffffe
    800046e4:	4d6080e7          	jalr	1238(ra) # 80002bb6 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800046e8:	000b059b          	sext.w	a1,s6
    800046ec:	03258b63          	beq	a1,s2,80004722 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    800046f0:	004a2603          	lw	a2,4(s4)
    800046f4:	fb040593          	addi	a1,s0,-80
    800046f8:	8526                	mv	a0,s1
    800046fa:	fffff097          	auipc	ra,0xfffff
    800046fe:	c82080e7          	jalr	-894(ra) # 8000337c <dirlink>
    80004702:	06054f63          	bltz	a0,80004780 <create+0x162>
  iunlockput(dp);
    80004706:	8526                	mv	a0,s1
    80004708:	ffffe097          	auipc	ra,0xffffe
    8000470c:	7dc080e7          	jalr	2012(ra) # 80002ee4 <iunlockput>
  return ip;
    80004710:	8ad2                	mv	s5,s4
    80004712:	b749                	j	80004694 <create+0x76>
    iunlockput(dp);
    80004714:	8526                	mv	a0,s1
    80004716:	ffffe097          	auipc	ra,0xffffe
    8000471a:	7ce080e7          	jalr	1998(ra) # 80002ee4 <iunlockput>
    return 0;
    8000471e:	8ad2                	mv	s5,s4
    80004720:	bf95                	j	80004694 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004722:	004a2603          	lw	a2,4(s4)
    80004726:	00004597          	auipc	a1,0x4
    8000472a:	fc258593          	addi	a1,a1,-62 # 800086e8 <syscalls+0x2f8>
    8000472e:	8552                	mv	a0,s4
    80004730:	fffff097          	auipc	ra,0xfffff
    80004734:	c4c080e7          	jalr	-948(ra) # 8000337c <dirlink>
    80004738:	04054463          	bltz	a0,80004780 <create+0x162>
    8000473c:	40d0                	lw	a2,4(s1)
    8000473e:	00004597          	auipc	a1,0x4
    80004742:	a1a58593          	addi	a1,a1,-1510 # 80008158 <etext+0x158>
    80004746:	8552                	mv	a0,s4
    80004748:	fffff097          	auipc	ra,0xfffff
    8000474c:	c34080e7          	jalr	-972(ra) # 8000337c <dirlink>
    80004750:	02054863          	bltz	a0,80004780 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    80004754:	004a2603          	lw	a2,4(s4)
    80004758:	fb040593          	addi	a1,s0,-80
    8000475c:	8526                	mv	a0,s1
    8000475e:	fffff097          	auipc	ra,0xfffff
    80004762:	c1e080e7          	jalr	-994(ra) # 8000337c <dirlink>
    80004766:	00054d63          	bltz	a0,80004780 <create+0x162>
    dp->nlink++;  // for ".."
    8000476a:	04a4d783          	lhu	a5,74(s1)
    8000476e:	2785                	addiw	a5,a5,1
    80004770:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004774:	8526                	mv	a0,s1
    80004776:	ffffe097          	auipc	ra,0xffffe
    8000477a:	440080e7          	jalr	1088(ra) # 80002bb6 <iupdate>
    8000477e:	b761                	j	80004706 <create+0xe8>
  ip->nlink = 0;
    80004780:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004784:	8552                	mv	a0,s4
    80004786:	ffffe097          	auipc	ra,0xffffe
    8000478a:	430080e7          	jalr	1072(ra) # 80002bb6 <iupdate>
  iunlockput(ip);
    8000478e:	8552                	mv	a0,s4
    80004790:	ffffe097          	auipc	ra,0xffffe
    80004794:	754080e7          	jalr	1876(ra) # 80002ee4 <iunlockput>
  iunlockput(dp);
    80004798:	8526                	mv	a0,s1
    8000479a:	ffffe097          	auipc	ra,0xffffe
    8000479e:	74a080e7          	jalr	1866(ra) # 80002ee4 <iunlockput>
  return 0;
    800047a2:	bdcd                	j	80004694 <create+0x76>
    return 0;
    800047a4:	8aaa                	mv	s5,a0
    800047a6:	b5fd                	j	80004694 <create+0x76>

00000000800047a8 <sys_dup>:
{
    800047a8:	7179                	addi	sp,sp,-48
    800047aa:	f406                	sd	ra,40(sp)
    800047ac:	f022                	sd	s0,32(sp)
    800047ae:	ec26                	sd	s1,24(sp)
    800047b0:	e84a                	sd	s2,16(sp)
    800047b2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800047b4:	fd840613          	addi	a2,s0,-40
    800047b8:	4581                	li	a1,0
    800047ba:	4501                	li	a0,0
    800047bc:	00000097          	auipc	ra,0x0
    800047c0:	dc0080e7          	jalr	-576(ra) # 8000457c <argfd>
    return -1;
    800047c4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800047c6:	02054363          	bltz	a0,800047ec <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800047ca:	fd843903          	ld	s2,-40(s0)
    800047ce:	854a                	mv	a0,s2
    800047d0:	00000097          	auipc	ra,0x0
    800047d4:	e0c080e7          	jalr	-500(ra) # 800045dc <fdalloc>
    800047d8:	84aa                	mv	s1,a0
    return -1;
    800047da:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800047dc:	00054863          	bltz	a0,800047ec <sys_dup+0x44>
  filedup(f);
    800047e0:	854a                	mv	a0,s2
    800047e2:	fffff097          	auipc	ra,0xfffff
    800047e6:	2e2080e7          	jalr	738(ra) # 80003ac4 <filedup>
  return fd;
    800047ea:	87a6                	mv	a5,s1
}
    800047ec:	853e                	mv	a0,a5
    800047ee:	70a2                	ld	ra,40(sp)
    800047f0:	7402                	ld	s0,32(sp)
    800047f2:	64e2                	ld	s1,24(sp)
    800047f4:	6942                	ld	s2,16(sp)
    800047f6:	6145                	addi	sp,sp,48
    800047f8:	8082                	ret

00000000800047fa <sys_read>:
{
    800047fa:	7179                	addi	sp,sp,-48
    800047fc:	f406                	sd	ra,40(sp)
    800047fe:	f022                	sd	s0,32(sp)
    80004800:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004802:	fd840593          	addi	a1,s0,-40
    80004806:	4505                	li	a0,1
    80004808:	ffffe097          	auipc	ra,0xffffe
    8000480c:	922080e7          	jalr	-1758(ra) # 8000212a <argaddr>
  argint(2, &n);
    80004810:	fe440593          	addi	a1,s0,-28
    80004814:	4509                	li	a0,2
    80004816:	ffffe097          	auipc	ra,0xffffe
    8000481a:	8f4080e7          	jalr	-1804(ra) # 8000210a <argint>
  if(argfd(0, 0, &f) < 0)
    8000481e:	fe840613          	addi	a2,s0,-24
    80004822:	4581                	li	a1,0
    80004824:	4501                	li	a0,0
    80004826:	00000097          	auipc	ra,0x0
    8000482a:	d56080e7          	jalr	-682(ra) # 8000457c <argfd>
    8000482e:	87aa                	mv	a5,a0
    return -1;
    80004830:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004832:	0007cc63          	bltz	a5,8000484a <sys_read+0x50>
  return fileread(f, p, n);
    80004836:	fe442603          	lw	a2,-28(s0)
    8000483a:	fd843583          	ld	a1,-40(s0)
    8000483e:	fe843503          	ld	a0,-24(s0)
    80004842:	fffff097          	auipc	ra,0xfffff
    80004846:	40e080e7          	jalr	1038(ra) # 80003c50 <fileread>
}
    8000484a:	70a2                	ld	ra,40(sp)
    8000484c:	7402                	ld	s0,32(sp)
    8000484e:	6145                	addi	sp,sp,48
    80004850:	8082                	ret

0000000080004852 <sys_write>:
{
    80004852:	7179                	addi	sp,sp,-48
    80004854:	f406                	sd	ra,40(sp)
    80004856:	f022                	sd	s0,32(sp)
    80004858:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000485a:	fd840593          	addi	a1,s0,-40
    8000485e:	4505                	li	a0,1
    80004860:	ffffe097          	auipc	ra,0xffffe
    80004864:	8ca080e7          	jalr	-1846(ra) # 8000212a <argaddr>
  argint(2, &n);
    80004868:	fe440593          	addi	a1,s0,-28
    8000486c:	4509                	li	a0,2
    8000486e:	ffffe097          	auipc	ra,0xffffe
    80004872:	89c080e7          	jalr	-1892(ra) # 8000210a <argint>
  if(argfd(0, 0, &f) < 0)
    80004876:	fe840613          	addi	a2,s0,-24
    8000487a:	4581                	li	a1,0
    8000487c:	4501                	li	a0,0
    8000487e:	00000097          	auipc	ra,0x0
    80004882:	cfe080e7          	jalr	-770(ra) # 8000457c <argfd>
    80004886:	87aa                	mv	a5,a0
    return -1;
    80004888:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000488a:	0007cc63          	bltz	a5,800048a2 <sys_write+0x50>
  return filewrite(f, p, n);
    8000488e:	fe442603          	lw	a2,-28(s0)
    80004892:	fd843583          	ld	a1,-40(s0)
    80004896:	fe843503          	ld	a0,-24(s0)
    8000489a:	fffff097          	auipc	ra,0xfffff
    8000489e:	478080e7          	jalr	1144(ra) # 80003d12 <filewrite>
}
    800048a2:	70a2                	ld	ra,40(sp)
    800048a4:	7402                	ld	s0,32(sp)
    800048a6:	6145                	addi	sp,sp,48
    800048a8:	8082                	ret

00000000800048aa <sys_close>:
{
    800048aa:	1101                	addi	sp,sp,-32
    800048ac:	ec06                	sd	ra,24(sp)
    800048ae:	e822                	sd	s0,16(sp)
    800048b0:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800048b2:	fe040613          	addi	a2,s0,-32
    800048b6:	fec40593          	addi	a1,s0,-20
    800048ba:	4501                	li	a0,0
    800048bc:	00000097          	auipc	ra,0x0
    800048c0:	cc0080e7          	jalr	-832(ra) # 8000457c <argfd>
    return -1;
    800048c4:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800048c6:	02054463          	bltz	a0,800048ee <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800048ca:	ffffc097          	auipc	ra,0xffffc
    800048ce:	66e080e7          	jalr	1646(ra) # 80000f38 <myproc>
    800048d2:	fec42783          	lw	a5,-20(s0)
    800048d6:	07e9                	addi	a5,a5,26
    800048d8:	078e                	slli	a5,a5,0x3
    800048da:	953e                	add	a0,a0,a5
    800048dc:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800048e0:	fe043503          	ld	a0,-32(s0)
    800048e4:	fffff097          	auipc	ra,0xfffff
    800048e8:	232080e7          	jalr	562(ra) # 80003b16 <fileclose>
  return 0;
    800048ec:	4781                	li	a5,0
}
    800048ee:	853e                	mv	a0,a5
    800048f0:	60e2                	ld	ra,24(sp)
    800048f2:	6442                	ld	s0,16(sp)
    800048f4:	6105                	addi	sp,sp,32
    800048f6:	8082                	ret

00000000800048f8 <sys_fstat>:
{
    800048f8:	1101                	addi	sp,sp,-32
    800048fa:	ec06                	sd	ra,24(sp)
    800048fc:	e822                	sd	s0,16(sp)
    800048fe:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004900:	fe040593          	addi	a1,s0,-32
    80004904:	4505                	li	a0,1
    80004906:	ffffe097          	auipc	ra,0xffffe
    8000490a:	824080e7          	jalr	-2012(ra) # 8000212a <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000490e:	fe840613          	addi	a2,s0,-24
    80004912:	4581                	li	a1,0
    80004914:	4501                	li	a0,0
    80004916:	00000097          	auipc	ra,0x0
    8000491a:	c66080e7          	jalr	-922(ra) # 8000457c <argfd>
    8000491e:	87aa                	mv	a5,a0
    return -1;
    80004920:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004922:	0007ca63          	bltz	a5,80004936 <sys_fstat+0x3e>
  return filestat(f, st);
    80004926:	fe043583          	ld	a1,-32(s0)
    8000492a:	fe843503          	ld	a0,-24(s0)
    8000492e:	fffff097          	auipc	ra,0xfffff
    80004932:	2b0080e7          	jalr	688(ra) # 80003bde <filestat>
}
    80004936:	60e2                	ld	ra,24(sp)
    80004938:	6442                	ld	s0,16(sp)
    8000493a:	6105                	addi	sp,sp,32
    8000493c:	8082                	ret

000000008000493e <sys_link>:
{
    8000493e:	7169                	addi	sp,sp,-304
    80004940:	f606                	sd	ra,296(sp)
    80004942:	f222                	sd	s0,288(sp)
    80004944:	ee26                	sd	s1,280(sp)
    80004946:	ea4a                	sd	s2,272(sp)
    80004948:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000494a:	08000613          	li	a2,128
    8000494e:	ed040593          	addi	a1,s0,-304
    80004952:	4501                	li	a0,0
    80004954:	ffffd097          	auipc	ra,0xffffd
    80004958:	7f6080e7          	jalr	2038(ra) # 8000214a <argstr>
    return -1;
    8000495c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000495e:	10054e63          	bltz	a0,80004a7a <sys_link+0x13c>
    80004962:	08000613          	li	a2,128
    80004966:	f5040593          	addi	a1,s0,-176
    8000496a:	4505                	li	a0,1
    8000496c:	ffffd097          	auipc	ra,0xffffd
    80004970:	7de080e7          	jalr	2014(ra) # 8000214a <argstr>
    return -1;
    80004974:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004976:	10054263          	bltz	a0,80004a7a <sys_link+0x13c>
  begin_op();
    8000497a:	fffff097          	auipc	ra,0xfffff
    8000497e:	cd4080e7          	jalr	-812(ra) # 8000364e <begin_op>
  if((ip = namei(old)) == 0){
    80004982:	ed040513          	addi	a0,s0,-304
    80004986:	fffff097          	auipc	ra,0xfffff
    8000498a:	aa8080e7          	jalr	-1368(ra) # 8000342e <namei>
    8000498e:	84aa                	mv	s1,a0
    80004990:	c551                	beqz	a0,80004a1c <sys_link+0xde>
  ilock(ip);
    80004992:	ffffe097          	auipc	ra,0xffffe
    80004996:	2f0080e7          	jalr	752(ra) # 80002c82 <ilock>
  if(ip->type == T_DIR){
    8000499a:	04449703          	lh	a4,68(s1)
    8000499e:	4785                	li	a5,1
    800049a0:	08f70463          	beq	a4,a5,80004a28 <sys_link+0xea>
  ip->nlink++;
    800049a4:	04a4d783          	lhu	a5,74(s1)
    800049a8:	2785                	addiw	a5,a5,1
    800049aa:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049ae:	8526                	mv	a0,s1
    800049b0:	ffffe097          	auipc	ra,0xffffe
    800049b4:	206080e7          	jalr	518(ra) # 80002bb6 <iupdate>
  iunlock(ip);
    800049b8:	8526                	mv	a0,s1
    800049ba:	ffffe097          	auipc	ra,0xffffe
    800049be:	38a080e7          	jalr	906(ra) # 80002d44 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800049c2:	fd040593          	addi	a1,s0,-48
    800049c6:	f5040513          	addi	a0,s0,-176
    800049ca:	fffff097          	auipc	ra,0xfffff
    800049ce:	a82080e7          	jalr	-1406(ra) # 8000344c <nameiparent>
    800049d2:	892a                	mv	s2,a0
    800049d4:	c935                	beqz	a0,80004a48 <sys_link+0x10a>
  ilock(dp);
    800049d6:	ffffe097          	auipc	ra,0xffffe
    800049da:	2ac080e7          	jalr	684(ra) # 80002c82 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800049de:	00092703          	lw	a4,0(s2)
    800049e2:	409c                	lw	a5,0(s1)
    800049e4:	04f71d63          	bne	a4,a5,80004a3e <sys_link+0x100>
    800049e8:	40d0                	lw	a2,4(s1)
    800049ea:	fd040593          	addi	a1,s0,-48
    800049ee:	854a                	mv	a0,s2
    800049f0:	fffff097          	auipc	ra,0xfffff
    800049f4:	98c080e7          	jalr	-1652(ra) # 8000337c <dirlink>
    800049f8:	04054363          	bltz	a0,80004a3e <sys_link+0x100>
  iunlockput(dp);
    800049fc:	854a                	mv	a0,s2
    800049fe:	ffffe097          	auipc	ra,0xffffe
    80004a02:	4e6080e7          	jalr	1254(ra) # 80002ee4 <iunlockput>
  iput(ip);
    80004a06:	8526                	mv	a0,s1
    80004a08:	ffffe097          	auipc	ra,0xffffe
    80004a0c:	434080e7          	jalr	1076(ra) # 80002e3c <iput>
  end_op();
    80004a10:	fffff097          	auipc	ra,0xfffff
    80004a14:	cbc080e7          	jalr	-836(ra) # 800036cc <end_op>
  return 0;
    80004a18:	4781                	li	a5,0
    80004a1a:	a085                	j	80004a7a <sys_link+0x13c>
    end_op();
    80004a1c:	fffff097          	auipc	ra,0xfffff
    80004a20:	cb0080e7          	jalr	-848(ra) # 800036cc <end_op>
    return -1;
    80004a24:	57fd                	li	a5,-1
    80004a26:	a891                	j	80004a7a <sys_link+0x13c>
    iunlockput(ip);
    80004a28:	8526                	mv	a0,s1
    80004a2a:	ffffe097          	auipc	ra,0xffffe
    80004a2e:	4ba080e7          	jalr	1210(ra) # 80002ee4 <iunlockput>
    end_op();
    80004a32:	fffff097          	auipc	ra,0xfffff
    80004a36:	c9a080e7          	jalr	-870(ra) # 800036cc <end_op>
    return -1;
    80004a3a:	57fd                	li	a5,-1
    80004a3c:	a83d                	j	80004a7a <sys_link+0x13c>
    iunlockput(dp);
    80004a3e:	854a                	mv	a0,s2
    80004a40:	ffffe097          	auipc	ra,0xffffe
    80004a44:	4a4080e7          	jalr	1188(ra) # 80002ee4 <iunlockput>
  ilock(ip);
    80004a48:	8526                	mv	a0,s1
    80004a4a:	ffffe097          	auipc	ra,0xffffe
    80004a4e:	238080e7          	jalr	568(ra) # 80002c82 <ilock>
  ip->nlink--;
    80004a52:	04a4d783          	lhu	a5,74(s1)
    80004a56:	37fd                	addiw	a5,a5,-1
    80004a58:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a5c:	8526                	mv	a0,s1
    80004a5e:	ffffe097          	auipc	ra,0xffffe
    80004a62:	158080e7          	jalr	344(ra) # 80002bb6 <iupdate>
  iunlockput(ip);
    80004a66:	8526                	mv	a0,s1
    80004a68:	ffffe097          	auipc	ra,0xffffe
    80004a6c:	47c080e7          	jalr	1148(ra) # 80002ee4 <iunlockput>
  end_op();
    80004a70:	fffff097          	auipc	ra,0xfffff
    80004a74:	c5c080e7          	jalr	-932(ra) # 800036cc <end_op>
  return -1;
    80004a78:	57fd                	li	a5,-1
}
    80004a7a:	853e                	mv	a0,a5
    80004a7c:	70b2                	ld	ra,296(sp)
    80004a7e:	7412                	ld	s0,288(sp)
    80004a80:	64f2                	ld	s1,280(sp)
    80004a82:	6952                	ld	s2,272(sp)
    80004a84:	6155                	addi	sp,sp,304
    80004a86:	8082                	ret

0000000080004a88 <sys_unlink>:
{
    80004a88:	7151                	addi	sp,sp,-240
    80004a8a:	f586                	sd	ra,232(sp)
    80004a8c:	f1a2                	sd	s0,224(sp)
    80004a8e:	eda6                	sd	s1,216(sp)
    80004a90:	e9ca                	sd	s2,208(sp)
    80004a92:	e5ce                	sd	s3,200(sp)
    80004a94:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a96:	08000613          	li	a2,128
    80004a9a:	f3040593          	addi	a1,s0,-208
    80004a9e:	4501                	li	a0,0
    80004aa0:	ffffd097          	auipc	ra,0xffffd
    80004aa4:	6aa080e7          	jalr	1706(ra) # 8000214a <argstr>
    80004aa8:	18054163          	bltz	a0,80004c2a <sys_unlink+0x1a2>
  begin_op();
    80004aac:	fffff097          	auipc	ra,0xfffff
    80004ab0:	ba2080e7          	jalr	-1118(ra) # 8000364e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004ab4:	fb040593          	addi	a1,s0,-80
    80004ab8:	f3040513          	addi	a0,s0,-208
    80004abc:	fffff097          	auipc	ra,0xfffff
    80004ac0:	990080e7          	jalr	-1648(ra) # 8000344c <nameiparent>
    80004ac4:	84aa                	mv	s1,a0
    80004ac6:	c979                	beqz	a0,80004b9c <sys_unlink+0x114>
  ilock(dp);
    80004ac8:	ffffe097          	auipc	ra,0xffffe
    80004acc:	1ba080e7          	jalr	442(ra) # 80002c82 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004ad0:	00004597          	auipc	a1,0x4
    80004ad4:	c1858593          	addi	a1,a1,-1000 # 800086e8 <syscalls+0x2f8>
    80004ad8:	fb040513          	addi	a0,s0,-80
    80004adc:	ffffe097          	auipc	ra,0xffffe
    80004ae0:	670080e7          	jalr	1648(ra) # 8000314c <namecmp>
    80004ae4:	14050a63          	beqz	a0,80004c38 <sys_unlink+0x1b0>
    80004ae8:	00003597          	auipc	a1,0x3
    80004aec:	67058593          	addi	a1,a1,1648 # 80008158 <etext+0x158>
    80004af0:	fb040513          	addi	a0,s0,-80
    80004af4:	ffffe097          	auipc	ra,0xffffe
    80004af8:	658080e7          	jalr	1624(ra) # 8000314c <namecmp>
    80004afc:	12050e63          	beqz	a0,80004c38 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b00:	f2c40613          	addi	a2,s0,-212
    80004b04:	fb040593          	addi	a1,s0,-80
    80004b08:	8526                	mv	a0,s1
    80004b0a:	ffffe097          	auipc	ra,0xffffe
    80004b0e:	65c080e7          	jalr	1628(ra) # 80003166 <dirlookup>
    80004b12:	892a                	mv	s2,a0
    80004b14:	12050263          	beqz	a0,80004c38 <sys_unlink+0x1b0>
  ilock(ip);
    80004b18:	ffffe097          	auipc	ra,0xffffe
    80004b1c:	16a080e7          	jalr	362(ra) # 80002c82 <ilock>
  if(ip->nlink < 1)
    80004b20:	04a91783          	lh	a5,74(s2)
    80004b24:	08f05263          	blez	a5,80004ba8 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b28:	04491703          	lh	a4,68(s2)
    80004b2c:	4785                	li	a5,1
    80004b2e:	08f70563          	beq	a4,a5,80004bb8 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b32:	4641                	li	a2,16
    80004b34:	4581                	li	a1,0
    80004b36:	fc040513          	addi	a0,s0,-64
    80004b3a:	ffffb097          	auipc	ra,0xffffb
    80004b3e:	640080e7          	jalr	1600(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b42:	4741                	li	a4,16
    80004b44:	f2c42683          	lw	a3,-212(s0)
    80004b48:	fc040613          	addi	a2,s0,-64
    80004b4c:	4581                	li	a1,0
    80004b4e:	8526                	mv	a0,s1
    80004b50:	ffffe097          	auipc	ra,0xffffe
    80004b54:	4de080e7          	jalr	1246(ra) # 8000302e <writei>
    80004b58:	47c1                	li	a5,16
    80004b5a:	0af51563          	bne	a0,a5,80004c04 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b5e:	04491703          	lh	a4,68(s2)
    80004b62:	4785                	li	a5,1
    80004b64:	0af70863          	beq	a4,a5,80004c14 <sys_unlink+0x18c>
  iunlockput(dp);
    80004b68:	8526                	mv	a0,s1
    80004b6a:	ffffe097          	auipc	ra,0xffffe
    80004b6e:	37a080e7          	jalr	890(ra) # 80002ee4 <iunlockput>
  ip->nlink--;
    80004b72:	04a95783          	lhu	a5,74(s2)
    80004b76:	37fd                	addiw	a5,a5,-1
    80004b78:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b7c:	854a                	mv	a0,s2
    80004b7e:	ffffe097          	auipc	ra,0xffffe
    80004b82:	038080e7          	jalr	56(ra) # 80002bb6 <iupdate>
  iunlockput(ip);
    80004b86:	854a                	mv	a0,s2
    80004b88:	ffffe097          	auipc	ra,0xffffe
    80004b8c:	35c080e7          	jalr	860(ra) # 80002ee4 <iunlockput>
  end_op();
    80004b90:	fffff097          	auipc	ra,0xfffff
    80004b94:	b3c080e7          	jalr	-1220(ra) # 800036cc <end_op>
  return 0;
    80004b98:	4501                	li	a0,0
    80004b9a:	a84d                	j	80004c4c <sys_unlink+0x1c4>
    end_op();
    80004b9c:	fffff097          	auipc	ra,0xfffff
    80004ba0:	b30080e7          	jalr	-1232(ra) # 800036cc <end_op>
    return -1;
    80004ba4:	557d                	li	a0,-1
    80004ba6:	a05d                	j	80004c4c <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004ba8:	00004517          	auipc	a0,0x4
    80004bac:	b4850513          	addi	a0,a0,-1208 # 800086f0 <syscalls+0x300>
    80004bb0:	00001097          	auipc	ra,0x1
    80004bb4:	1ac080e7          	jalr	428(ra) # 80005d5c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bb8:	04c92703          	lw	a4,76(s2)
    80004bbc:	02000793          	li	a5,32
    80004bc0:	f6e7f9e3          	bgeu	a5,a4,80004b32 <sys_unlink+0xaa>
    80004bc4:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bc8:	4741                	li	a4,16
    80004bca:	86ce                	mv	a3,s3
    80004bcc:	f1840613          	addi	a2,s0,-232
    80004bd0:	4581                	li	a1,0
    80004bd2:	854a                	mv	a0,s2
    80004bd4:	ffffe097          	auipc	ra,0xffffe
    80004bd8:	362080e7          	jalr	866(ra) # 80002f36 <readi>
    80004bdc:	47c1                	li	a5,16
    80004bde:	00f51b63          	bne	a0,a5,80004bf4 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004be2:	f1845783          	lhu	a5,-232(s0)
    80004be6:	e7a1                	bnez	a5,80004c2e <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004be8:	29c1                	addiw	s3,s3,16
    80004bea:	04c92783          	lw	a5,76(s2)
    80004bee:	fcf9ede3          	bltu	s3,a5,80004bc8 <sys_unlink+0x140>
    80004bf2:	b781                	j	80004b32 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004bf4:	00004517          	auipc	a0,0x4
    80004bf8:	b1450513          	addi	a0,a0,-1260 # 80008708 <syscalls+0x318>
    80004bfc:	00001097          	auipc	ra,0x1
    80004c00:	160080e7          	jalr	352(ra) # 80005d5c <panic>
    panic("unlink: writei");
    80004c04:	00004517          	auipc	a0,0x4
    80004c08:	b1c50513          	addi	a0,a0,-1252 # 80008720 <syscalls+0x330>
    80004c0c:	00001097          	auipc	ra,0x1
    80004c10:	150080e7          	jalr	336(ra) # 80005d5c <panic>
    dp->nlink--;
    80004c14:	04a4d783          	lhu	a5,74(s1)
    80004c18:	37fd                	addiw	a5,a5,-1
    80004c1a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c1e:	8526                	mv	a0,s1
    80004c20:	ffffe097          	auipc	ra,0xffffe
    80004c24:	f96080e7          	jalr	-106(ra) # 80002bb6 <iupdate>
    80004c28:	b781                	j	80004b68 <sys_unlink+0xe0>
    return -1;
    80004c2a:	557d                	li	a0,-1
    80004c2c:	a005                	j	80004c4c <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c2e:	854a                	mv	a0,s2
    80004c30:	ffffe097          	auipc	ra,0xffffe
    80004c34:	2b4080e7          	jalr	692(ra) # 80002ee4 <iunlockput>
  iunlockput(dp);
    80004c38:	8526                	mv	a0,s1
    80004c3a:	ffffe097          	auipc	ra,0xffffe
    80004c3e:	2aa080e7          	jalr	682(ra) # 80002ee4 <iunlockput>
  end_op();
    80004c42:	fffff097          	auipc	ra,0xfffff
    80004c46:	a8a080e7          	jalr	-1398(ra) # 800036cc <end_op>
  return -1;
    80004c4a:	557d                	li	a0,-1
}
    80004c4c:	70ae                	ld	ra,232(sp)
    80004c4e:	740e                	ld	s0,224(sp)
    80004c50:	64ee                	ld	s1,216(sp)
    80004c52:	694e                	ld	s2,208(sp)
    80004c54:	69ae                	ld	s3,200(sp)
    80004c56:	616d                	addi	sp,sp,240
    80004c58:	8082                	ret

0000000080004c5a <sys_open>:

uint64
sys_open(void)
{
    80004c5a:	7131                	addi	sp,sp,-192
    80004c5c:	fd06                	sd	ra,184(sp)
    80004c5e:	f922                	sd	s0,176(sp)
    80004c60:	f526                	sd	s1,168(sp)
    80004c62:	f14a                	sd	s2,160(sp)
    80004c64:	ed4e                	sd	s3,152(sp)
    80004c66:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004c68:	f4c40593          	addi	a1,s0,-180
    80004c6c:	4505                	li	a0,1
    80004c6e:	ffffd097          	auipc	ra,0xffffd
    80004c72:	49c080e7          	jalr	1180(ra) # 8000210a <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c76:	08000613          	li	a2,128
    80004c7a:	f5040593          	addi	a1,s0,-176
    80004c7e:	4501                	li	a0,0
    80004c80:	ffffd097          	auipc	ra,0xffffd
    80004c84:	4ca080e7          	jalr	1226(ra) # 8000214a <argstr>
    80004c88:	87aa                	mv	a5,a0
    return -1;
    80004c8a:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c8c:	0a07c963          	bltz	a5,80004d3e <sys_open+0xe4>

  begin_op();
    80004c90:	fffff097          	auipc	ra,0xfffff
    80004c94:	9be080e7          	jalr	-1602(ra) # 8000364e <begin_op>

  if(omode & O_CREATE){
    80004c98:	f4c42783          	lw	a5,-180(s0)
    80004c9c:	2007f793          	andi	a5,a5,512
    80004ca0:	cfc5                	beqz	a5,80004d58 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004ca2:	4681                	li	a3,0
    80004ca4:	4601                	li	a2,0
    80004ca6:	4589                	li	a1,2
    80004ca8:	f5040513          	addi	a0,s0,-176
    80004cac:	00000097          	auipc	ra,0x0
    80004cb0:	972080e7          	jalr	-1678(ra) # 8000461e <create>
    80004cb4:	84aa                	mv	s1,a0
    if(ip == 0){
    80004cb6:	c959                	beqz	a0,80004d4c <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004cb8:	04449703          	lh	a4,68(s1)
    80004cbc:	478d                	li	a5,3
    80004cbe:	00f71763          	bne	a4,a5,80004ccc <sys_open+0x72>
    80004cc2:	0464d703          	lhu	a4,70(s1)
    80004cc6:	47a5                	li	a5,9
    80004cc8:	0ce7ed63          	bltu	a5,a4,80004da2 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004ccc:	fffff097          	auipc	ra,0xfffff
    80004cd0:	d8e080e7          	jalr	-626(ra) # 80003a5a <filealloc>
    80004cd4:	89aa                	mv	s3,a0
    80004cd6:	10050363          	beqz	a0,80004ddc <sys_open+0x182>
    80004cda:	00000097          	auipc	ra,0x0
    80004cde:	902080e7          	jalr	-1790(ra) # 800045dc <fdalloc>
    80004ce2:	892a                	mv	s2,a0
    80004ce4:	0e054763          	bltz	a0,80004dd2 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004ce8:	04449703          	lh	a4,68(s1)
    80004cec:	478d                	li	a5,3
    80004cee:	0cf70563          	beq	a4,a5,80004db8 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004cf2:	4789                	li	a5,2
    80004cf4:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004cf8:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004cfc:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d00:	f4c42783          	lw	a5,-180(s0)
    80004d04:	0017c713          	xori	a4,a5,1
    80004d08:	8b05                	andi	a4,a4,1
    80004d0a:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d0e:	0037f713          	andi	a4,a5,3
    80004d12:	00e03733          	snez	a4,a4
    80004d16:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d1a:	4007f793          	andi	a5,a5,1024
    80004d1e:	c791                	beqz	a5,80004d2a <sys_open+0xd0>
    80004d20:	04449703          	lh	a4,68(s1)
    80004d24:	4789                	li	a5,2
    80004d26:	0af70063          	beq	a4,a5,80004dc6 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d2a:	8526                	mv	a0,s1
    80004d2c:	ffffe097          	auipc	ra,0xffffe
    80004d30:	018080e7          	jalr	24(ra) # 80002d44 <iunlock>
  end_op();
    80004d34:	fffff097          	auipc	ra,0xfffff
    80004d38:	998080e7          	jalr	-1640(ra) # 800036cc <end_op>

  return fd;
    80004d3c:	854a                	mv	a0,s2
}
    80004d3e:	70ea                	ld	ra,184(sp)
    80004d40:	744a                	ld	s0,176(sp)
    80004d42:	74aa                	ld	s1,168(sp)
    80004d44:	790a                	ld	s2,160(sp)
    80004d46:	69ea                	ld	s3,152(sp)
    80004d48:	6129                	addi	sp,sp,192
    80004d4a:	8082                	ret
      end_op();
    80004d4c:	fffff097          	auipc	ra,0xfffff
    80004d50:	980080e7          	jalr	-1664(ra) # 800036cc <end_op>
      return -1;
    80004d54:	557d                	li	a0,-1
    80004d56:	b7e5                	j	80004d3e <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d58:	f5040513          	addi	a0,s0,-176
    80004d5c:	ffffe097          	auipc	ra,0xffffe
    80004d60:	6d2080e7          	jalr	1746(ra) # 8000342e <namei>
    80004d64:	84aa                	mv	s1,a0
    80004d66:	c905                	beqz	a0,80004d96 <sys_open+0x13c>
    ilock(ip);
    80004d68:	ffffe097          	auipc	ra,0xffffe
    80004d6c:	f1a080e7          	jalr	-230(ra) # 80002c82 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d70:	04449703          	lh	a4,68(s1)
    80004d74:	4785                	li	a5,1
    80004d76:	f4f711e3          	bne	a4,a5,80004cb8 <sys_open+0x5e>
    80004d7a:	f4c42783          	lw	a5,-180(s0)
    80004d7e:	d7b9                	beqz	a5,80004ccc <sys_open+0x72>
      iunlockput(ip);
    80004d80:	8526                	mv	a0,s1
    80004d82:	ffffe097          	auipc	ra,0xffffe
    80004d86:	162080e7          	jalr	354(ra) # 80002ee4 <iunlockput>
      end_op();
    80004d8a:	fffff097          	auipc	ra,0xfffff
    80004d8e:	942080e7          	jalr	-1726(ra) # 800036cc <end_op>
      return -1;
    80004d92:	557d                	li	a0,-1
    80004d94:	b76d                	j	80004d3e <sys_open+0xe4>
      end_op();
    80004d96:	fffff097          	auipc	ra,0xfffff
    80004d9a:	936080e7          	jalr	-1738(ra) # 800036cc <end_op>
      return -1;
    80004d9e:	557d                	li	a0,-1
    80004da0:	bf79                	j	80004d3e <sys_open+0xe4>
    iunlockput(ip);
    80004da2:	8526                	mv	a0,s1
    80004da4:	ffffe097          	auipc	ra,0xffffe
    80004da8:	140080e7          	jalr	320(ra) # 80002ee4 <iunlockput>
    end_op();
    80004dac:	fffff097          	auipc	ra,0xfffff
    80004db0:	920080e7          	jalr	-1760(ra) # 800036cc <end_op>
    return -1;
    80004db4:	557d                	li	a0,-1
    80004db6:	b761                	j	80004d3e <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004db8:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004dbc:	04649783          	lh	a5,70(s1)
    80004dc0:	02f99223          	sh	a5,36(s3)
    80004dc4:	bf25                	j	80004cfc <sys_open+0xa2>
    itrunc(ip);
    80004dc6:	8526                	mv	a0,s1
    80004dc8:	ffffe097          	auipc	ra,0xffffe
    80004dcc:	fc8080e7          	jalr	-56(ra) # 80002d90 <itrunc>
    80004dd0:	bfa9                	j	80004d2a <sys_open+0xd0>
      fileclose(f);
    80004dd2:	854e                	mv	a0,s3
    80004dd4:	fffff097          	auipc	ra,0xfffff
    80004dd8:	d42080e7          	jalr	-702(ra) # 80003b16 <fileclose>
    iunlockput(ip);
    80004ddc:	8526                	mv	a0,s1
    80004dde:	ffffe097          	auipc	ra,0xffffe
    80004de2:	106080e7          	jalr	262(ra) # 80002ee4 <iunlockput>
    end_op();
    80004de6:	fffff097          	auipc	ra,0xfffff
    80004dea:	8e6080e7          	jalr	-1818(ra) # 800036cc <end_op>
    return -1;
    80004dee:	557d                	li	a0,-1
    80004df0:	b7b9                	j	80004d3e <sys_open+0xe4>

0000000080004df2 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004df2:	7175                	addi	sp,sp,-144
    80004df4:	e506                	sd	ra,136(sp)
    80004df6:	e122                	sd	s0,128(sp)
    80004df8:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004dfa:	fffff097          	auipc	ra,0xfffff
    80004dfe:	854080e7          	jalr	-1964(ra) # 8000364e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e02:	08000613          	li	a2,128
    80004e06:	f7040593          	addi	a1,s0,-144
    80004e0a:	4501                	li	a0,0
    80004e0c:	ffffd097          	auipc	ra,0xffffd
    80004e10:	33e080e7          	jalr	830(ra) # 8000214a <argstr>
    80004e14:	02054963          	bltz	a0,80004e46 <sys_mkdir+0x54>
    80004e18:	4681                	li	a3,0
    80004e1a:	4601                	li	a2,0
    80004e1c:	4585                	li	a1,1
    80004e1e:	f7040513          	addi	a0,s0,-144
    80004e22:	fffff097          	auipc	ra,0xfffff
    80004e26:	7fc080e7          	jalr	2044(ra) # 8000461e <create>
    80004e2a:	cd11                	beqz	a0,80004e46 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e2c:	ffffe097          	auipc	ra,0xffffe
    80004e30:	0b8080e7          	jalr	184(ra) # 80002ee4 <iunlockput>
  end_op();
    80004e34:	fffff097          	auipc	ra,0xfffff
    80004e38:	898080e7          	jalr	-1896(ra) # 800036cc <end_op>
  return 0;
    80004e3c:	4501                	li	a0,0
}
    80004e3e:	60aa                	ld	ra,136(sp)
    80004e40:	640a                	ld	s0,128(sp)
    80004e42:	6149                	addi	sp,sp,144
    80004e44:	8082                	ret
    end_op();
    80004e46:	fffff097          	auipc	ra,0xfffff
    80004e4a:	886080e7          	jalr	-1914(ra) # 800036cc <end_op>
    return -1;
    80004e4e:	557d                	li	a0,-1
    80004e50:	b7fd                	j	80004e3e <sys_mkdir+0x4c>

0000000080004e52 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e52:	7135                	addi	sp,sp,-160
    80004e54:	ed06                	sd	ra,152(sp)
    80004e56:	e922                	sd	s0,144(sp)
    80004e58:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e5a:	ffffe097          	auipc	ra,0xffffe
    80004e5e:	7f4080e7          	jalr	2036(ra) # 8000364e <begin_op>
  argint(1, &major);
    80004e62:	f6c40593          	addi	a1,s0,-148
    80004e66:	4505                	li	a0,1
    80004e68:	ffffd097          	auipc	ra,0xffffd
    80004e6c:	2a2080e7          	jalr	674(ra) # 8000210a <argint>
  argint(2, &minor);
    80004e70:	f6840593          	addi	a1,s0,-152
    80004e74:	4509                	li	a0,2
    80004e76:	ffffd097          	auipc	ra,0xffffd
    80004e7a:	294080e7          	jalr	660(ra) # 8000210a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e7e:	08000613          	li	a2,128
    80004e82:	f7040593          	addi	a1,s0,-144
    80004e86:	4501                	li	a0,0
    80004e88:	ffffd097          	auipc	ra,0xffffd
    80004e8c:	2c2080e7          	jalr	706(ra) # 8000214a <argstr>
    80004e90:	02054b63          	bltz	a0,80004ec6 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e94:	f6841683          	lh	a3,-152(s0)
    80004e98:	f6c41603          	lh	a2,-148(s0)
    80004e9c:	458d                	li	a1,3
    80004e9e:	f7040513          	addi	a0,s0,-144
    80004ea2:	fffff097          	auipc	ra,0xfffff
    80004ea6:	77c080e7          	jalr	1916(ra) # 8000461e <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004eaa:	cd11                	beqz	a0,80004ec6 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004eac:	ffffe097          	auipc	ra,0xffffe
    80004eb0:	038080e7          	jalr	56(ra) # 80002ee4 <iunlockput>
  end_op();
    80004eb4:	fffff097          	auipc	ra,0xfffff
    80004eb8:	818080e7          	jalr	-2024(ra) # 800036cc <end_op>
  return 0;
    80004ebc:	4501                	li	a0,0
}
    80004ebe:	60ea                	ld	ra,152(sp)
    80004ec0:	644a                	ld	s0,144(sp)
    80004ec2:	610d                	addi	sp,sp,160
    80004ec4:	8082                	ret
    end_op();
    80004ec6:	fffff097          	auipc	ra,0xfffff
    80004eca:	806080e7          	jalr	-2042(ra) # 800036cc <end_op>
    return -1;
    80004ece:	557d                	li	a0,-1
    80004ed0:	b7fd                	j	80004ebe <sys_mknod+0x6c>

0000000080004ed2 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004ed2:	7135                	addi	sp,sp,-160
    80004ed4:	ed06                	sd	ra,152(sp)
    80004ed6:	e922                	sd	s0,144(sp)
    80004ed8:	e526                	sd	s1,136(sp)
    80004eda:	e14a                	sd	s2,128(sp)
    80004edc:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004ede:	ffffc097          	auipc	ra,0xffffc
    80004ee2:	05a080e7          	jalr	90(ra) # 80000f38 <myproc>
    80004ee6:	892a                	mv	s2,a0
  
  begin_op();
    80004ee8:	ffffe097          	auipc	ra,0xffffe
    80004eec:	766080e7          	jalr	1894(ra) # 8000364e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004ef0:	08000613          	li	a2,128
    80004ef4:	f6040593          	addi	a1,s0,-160
    80004ef8:	4501                	li	a0,0
    80004efa:	ffffd097          	auipc	ra,0xffffd
    80004efe:	250080e7          	jalr	592(ra) # 8000214a <argstr>
    80004f02:	04054b63          	bltz	a0,80004f58 <sys_chdir+0x86>
    80004f06:	f6040513          	addi	a0,s0,-160
    80004f0a:	ffffe097          	auipc	ra,0xffffe
    80004f0e:	524080e7          	jalr	1316(ra) # 8000342e <namei>
    80004f12:	84aa                	mv	s1,a0
    80004f14:	c131                	beqz	a0,80004f58 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f16:	ffffe097          	auipc	ra,0xffffe
    80004f1a:	d6c080e7          	jalr	-660(ra) # 80002c82 <ilock>
  if(ip->type != T_DIR){
    80004f1e:	04449703          	lh	a4,68(s1)
    80004f22:	4785                	li	a5,1
    80004f24:	04f71063          	bne	a4,a5,80004f64 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f28:	8526                	mv	a0,s1
    80004f2a:	ffffe097          	auipc	ra,0xffffe
    80004f2e:	e1a080e7          	jalr	-486(ra) # 80002d44 <iunlock>
  iput(p->cwd);
    80004f32:	15093503          	ld	a0,336(s2)
    80004f36:	ffffe097          	auipc	ra,0xffffe
    80004f3a:	f06080e7          	jalr	-250(ra) # 80002e3c <iput>
  end_op();
    80004f3e:	ffffe097          	auipc	ra,0xffffe
    80004f42:	78e080e7          	jalr	1934(ra) # 800036cc <end_op>
  p->cwd = ip;
    80004f46:	14993823          	sd	s1,336(s2)
  return 0;
    80004f4a:	4501                	li	a0,0
}
    80004f4c:	60ea                	ld	ra,152(sp)
    80004f4e:	644a                	ld	s0,144(sp)
    80004f50:	64aa                	ld	s1,136(sp)
    80004f52:	690a                	ld	s2,128(sp)
    80004f54:	610d                	addi	sp,sp,160
    80004f56:	8082                	ret
    end_op();
    80004f58:	ffffe097          	auipc	ra,0xffffe
    80004f5c:	774080e7          	jalr	1908(ra) # 800036cc <end_op>
    return -1;
    80004f60:	557d                	li	a0,-1
    80004f62:	b7ed                	j	80004f4c <sys_chdir+0x7a>
    iunlockput(ip);
    80004f64:	8526                	mv	a0,s1
    80004f66:	ffffe097          	auipc	ra,0xffffe
    80004f6a:	f7e080e7          	jalr	-130(ra) # 80002ee4 <iunlockput>
    end_op();
    80004f6e:	ffffe097          	auipc	ra,0xffffe
    80004f72:	75e080e7          	jalr	1886(ra) # 800036cc <end_op>
    return -1;
    80004f76:	557d                	li	a0,-1
    80004f78:	bfd1                	j	80004f4c <sys_chdir+0x7a>

0000000080004f7a <sys_exec>:

uint64
sys_exec(void)
{
    80004f7a:	7145                	addi	sp,sp,-464
    80004f7c:	e786                	sd	ra,456(sp)
    80004f7e:	e3a2                	sd	s0,448(sp)
    80004f80:	ff26                	sd	s1,440(sp)
    80004f82:	fb4a                	sd	s2,432(sp)
    80004f84:	f74e                	sd	s3,424(sp)
    80004f86:	f352                	sd	s4,416(sp)
    80004f88:	ef56                	sd	s5,408(sp)
    80004f8a:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004f8c:	e3840593          	addi	a1,s0,-456
    80004f90:	4505                	li	a0,1
    80004f92:	ffffd097          	auipc	ra,0xffffd
    80004f96:	198080e7          	jalr	408(ra) # 8000212a <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004f9a:	08000613          	li	a2,128
    80004f9e:	f4040593          	addi	a1,s0,-192
    80004fa2:	4501                	li	a0,0
    80004fa4:	ffffd097          	auipc	ra,0xffffd
    80004fa8:	1a6080e7          	jalr	422(ra) # 8000214a <argstr>
    80004fac:	87aa                	mv	a5,a0
    return -1;
    80004fae:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004fb0:	0c07c363          	bltz	a5,80005076 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004fb4:	10000613          	li	a2,256
    80004fb8:	4581                	li	a1,0
    80004fba:	e4040513          	addi	a0,s0,-448
    80004fbe:	ffffb097          	auipc	ra,0xffffb
    80004fc2:	1bc080e7          	jalr	444(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004fc6:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004fca:	89a6                	mv	s3,s1
    80004fcc:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004fce:	02000a13          	li	s4,32
    80004fd2:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004fd6:	00391513          	slli	a0,s2,0x3
    80004fda:	e3040593          	addi	a1,s0,-464
    80004fde:	e3843783          	ld	a5,-456(s0)
    80004fe2:	953e                	add	a0,a0,a5
    80004fe4:	ffffd097          	auipc	ra,0xffffd
    80004fe8:	088080e7          	jalr	136(ra) # 8000206c <fetchaddr>
    80004fec:	02054a63          	bltz	a0,80005020 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004ff0:	e3043783          	ld	a5,-464(s0)
    80004ff4:	c3b9                	beqz	a5,8000503a <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ff6:	ffffb097          	auipc	ra,0xffffb
    80004ffa:	124080e7          	jalr	292(ra) # 8000011a <kalloc>
    80004ffe:	85aa                	mv	a1,a0
    80005000:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005004:	cd11                	beqz	a0,80005020 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005006:	6605                	lui	a2,0x1
    80005008:	e3043503          	ld	a0,-464(s0)
    8000500c:	ffffd097          	auipc	ra,0xffffd
    80005010:	0b2080e7          	jalr	178(ra) # 800020be <fetchstr>
    80005014:	00054663          	bltz	a0,80005020 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005018:	0905                	addi	s2,s2,1
    8000501a:	09a1                	addi	s3,s3,8
    8000501c:	fb491be3          	bne	s2,s4,80004fd2 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005020:	f4040913          	addi	s2,s0,-192
    80005024:	6088                	ld	a0,0(s1)
    80005026:	c539                	beqz	a0,80005074 <sys_exec+0xfa>
    kfree(argv[i]);
    80005028:	ffffb097          	auipc	ra,0xffffb
    8000502c:	ff4080e7          	jalr	-12(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005030:	04a1                	addi	s1,s1,8
    80005032:	ff2499e3          	bne	s1,s2,80005024 <sys_exec+0xaa>
  return -1;
    80005036:	557d                	li	a0,-1
    80005038:	a83d                	j	80005076 <sys_exec+0xfc>
      argv[i] = 0;
    8000503a:	0a8e                	slli	s5,s5,0x3
    8000503c:	fc0a8793          	addi	a5,s5,-64
    80005040:	00878ab3          	add	s5,a5,s0
    80005044:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005048:	e4040593          	addi	a1,s0,-448
    8000504c:	f4040513          	addi	a0,s0,-192
    80005050:	fffff097          	auipc	ra,0xfffff
    80005054:	140080e7          	jalr	320(ra) # 80004190 <exec>
    80005058:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000505a:	f4040993          	addi	s3,s0,-192
    8000505e:	6088                	ld	a0,0(s1)
    80005060:	c901                	beqz	a0,80005070 <sys_exec+0xf6>
    kfree(argv[i]);
    80005062:	ffffb097          	auipc	ra,0xffffb
    80005066:	fba080e7          	jalr	-70(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000506a:	04a1                	addi	s1,s1,8
    8000506c:	ff3499e3          	bne	s1,s3,8000505e <sys_exec+0xe4>
  return ret;
    80005070:	854a                	mv	a0,s2
    80005072:	a011                	j	80005076 <sys_exec+0xfc>
  return -1;
    80005074:	557d                	li	a0,-1
}
    80005076:	60be                	ld	ra,456(sp)
    80005078:	641e                	ld	s0,448(sp)
    8000507a:	74fa                	ld	s1,440(sp)
    8000507c:	795a                	ld	s2,432(sp)
    8000507e:	79ba                	ld	s3,424(sp)
    80005080:	7a1a                	ld	s4,416(sp)
    80005082:	6afa                	ld	s5,408(sp)
    80005084:	6179                	addi	sp,sp,464
    80005086:	8082                	ret

0000000080005088 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005088:	7139                	addi	sp,sp,-64
    8000508a:	fc06                	sd	ra,56(sp)
    8000508c:	f822                	sd	s0,48(sp)
    8000508e:	f426                	sd	s1,40(sp)
    80005090:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005092:	ffffc097          	auipc	ra,0xffffc
    80005096:	ea6080e7          	jalr	-346(ra) # 80000f38 <myproc>
    8000509a:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000509c:	fd840593          	addi	a1,s0,-40
    800050a0:	4501                	li	a0,0
    800050a2:	ffffd097          	auipc	ra,0xffffd
    800050a6:	088080e7          	jalr	136(ra) # 8000212a <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800050aa:	fc840593          	addi	a1,s0,-56
    800050ae:	fd040513          	addi	a0,s0,-48
    800050b2:	fffff097          	auipc	ra,0xfffff
    800050b6:	d94080e7          	jalr	-620(ra) # 80003e46 <pipealloc>
    return -1;
    800050ba:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050bc:	0c054463          	bltz	a0,80005184 <sys_pipe+0xfc>
  fd0 = -1;
    800050c0:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050c4:	fd043503          	ld	a0,-48(s0)
    800050c8:	fffff097          	auipc	ra,0xfffff
    800050cc:	514080e7          	jalr	1300(ra) # 800045dc <fdalloc>
    800050d0:	fca42223          	sw	a0,-60(s0)
    800050d4:	08054b63          	bltz	a0,8000516a <sys_pipe+0xe2>
    800050d8:	fc843503          	ld	a0,-56(s0)
    800050dc:	fffff097          	auipc	ra,0xfffff
    800050e0:	500080e7          	jalr	1280(ra) # 800045dc <fdalloc>
    800050e4:	fca42023          	sw	a0,-64(s0)
    800050e8:	06054863          	bltz	a0,80005158 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050ec:	4691                	li	a3,4
    800050ee:	fc440613          	addi	a2,s0,-60
    800050f2:	fd843583          	ld	a1,-40(s0)
    800050f6:	68a8                	ld	a0,80(s1)
    800050f8:	ffffc097          	auipc	ra,0xffffc
    800050fc:	a1c080e7          	jalr	-1508(ra) # 80000b14 <copyout>
    80005100:	02054063          	bltz	a0,80005120 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005104:	4691                	li	a3,4
    80005106:	fc040613          	addi	a2,s0,-64
    8000510a:	fd843583          	ld	a1,-40(s0)
    8000510e:	0591                	addi	a1,a1,4
    80005110:	68a8                	ld	a0,80(s1)
    80005112:	ffffc097          	auipc	ra,0xffffc
    80005116:	a02080e7          	jalr	-1534(ra) # 80000b14 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000511a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000511c:	06055463          	bgez	a0,80005184 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005120:	fc442783          	lw	a5,-60(s0)
    80005124:	07e9                	addi	a5,a5,26
    80005126:	078e                	slli	a5,a5,0x3
    80005128:	97a6                	add	a5,a5,s1
    8000512a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000512e:	fc042783          	lw	a5,-64(s0)
    80005132:	07e9                	addi	a5,a5,26
    80005134:	078e                	slli	a5,a5,0x3
    80005136:	94be                	add	s1,s1,a5
    80005138:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000513c:	fd043503          	ld	a0,-48(s0)
    80005140:	fffff097          	auipc	ra,0xfffff
    80005144:	9d6080e7          	jalr	-1578(ra) # 80003b16 <fileclose>
    fileclose(wf);
    80005148:	fc843503          	ld	a0,-56(s0)
    8000514c:	fffff097          	auipc	ra,0xfffff
    80005150:	9ca080e7          	jalr	-1590(ra) # 80003b16 <fileclose>
    return -1;
    80005154:	57fd                	li	a5,-1
    80005156:	a03d                	j	80005184 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005158:	fc442783          	lw	a5,-60(s0)
    8000515c:	0007c763          	bltz	a5,8000516a <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005160:	07e9                	addi	a5,a5,26
    80005162:	078e                	slli	a5,a5,0x3
    80005164:	97a6                	add	a5,a5,s1
    80005166:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000516a:	fd043503          	ld	a0,-48(s0)
    8000516e:	fffff097          	auipc	ra,0xfffff
    80005172:	9a8080e7          	jalr	-1624(ra) # 80003b16 <fileclose>
    fileclose(wf);
    80005176:	fc843503          	ld	a0,-56(s0)
    8000517a:	fffff097          	auipc	ra,0xfffff
    8000517e:	99c080e7          	jalr	-1636(ra) # 80003b16 <fileclose>
    return -1;
    80005182:	57fd                	li	a5,-1
}
    80005184:	853e                	mv	a0,a5
    80005186:	70e2                	ld	ra,56(sp)
    80005188:	7442                	ld	s0,48(sp)
    8000518a:	74a2                	ld	s1,40(sp)
    8000518c:	6121                	addi	sp,sp,64
    8000518e:	8082                	ret

0000000080005190 <kernelvec>:
    80005190:	7111                	addi	sp,sp,-256
    80005192:	e006                	sd	ra,0(sp)
    80005194:	e40a                	sd	sp,8(sp)
    80005196:	e80e                	sd	gp,16(sp)
    80005198:	ec12                	sd	tp,24(sp)
    8000519a:	f016                	sd	t0,32(sp)
    8000519c:	f41a                	sd	t1,40(sp)
    8000519e:	f81e                	sd	t2,48(sp)
    800051a0:	fc22                	sd	s0,56(sp)
    800051a2:	e0a6                	sd	s1,64(sp)
    800051a4:	e4aa                	sd	a0,72(sp)
    800051a6:	e8ae                	sd	a1,80(sp)
    800051a8:	ecb2                	sd	a2,88(sp)
    800051aa:	f0b6                	sd	a3,96(sp)
    800051ac:	f4ba                	sd	a4,104(sp)
    800051ae:	f8be                	sd	a5,112(sp)
    800051b0:	fcc2                	sd	a6,120(sp)
    800051b2:	e146                	sd	a7,128(sp)
    800051b4:	e54a                	sd	s2,136(sp)
    800051b6:	e94e                	sd	s3,144(sp)
    800051b8:	ed52                	sd	s4,152(sp)
    800051ba:	f156                	sd	s5,160(sp)
    800051bc:	f55a                	sd	s6,168(sp)
    800051be:	f95e                	sd	s7,176(sp)
    800051c0:	fd62                	sd	s8,184(sp)
    800051c2:	e1e6                	sd	s9,192(sp)
    800051c4:	e5ea                	sd	s10,200(sp)
    800051c6:	e9ee                	sd	s11,208(sp)
    800051c8:	edf2                	sd	t3,216(sp)
    800051ca:	f1f6                	sd	t4,224(sp)
    800051cc:	f5fa                	sd	t5,232(sp)
    800051ce:	f9fe                	sd	t6,240(sp)
    800051d0:	d69fc0ef          	jal	ra,80001f38 <kerneltrap>
    800051d4:	6082                	ld	ra,0(sp)
    800051d6:	6122                	ld	sp,8(sp)
    800051d8:	61c2                	ld	gp,16(sp)
    800051da:	7282                	ld	t0,32(sp)
    800051dc:	7322                	ld	t1,40(sp)
    800051de:	73c2                	ld	t2,48(sp)
    800051e0:	7462                	ld	s0,56(sp)
    800051e2:	6486                	ld	s1,64(sp)
    800051e4:	6526                	ld	a0,72(sp)
    800051e6:	65c6                	ld	a1,80(sp)
    800051e8:	6666                	ld	a2,88(sp)
    800051ea:	7686                	ld	a3,96(sp)
    800051ec:	7726                	ld	a4,104(sp)
    800051ee:	77c6                	ld	a5,112(sp)
    800051f0:	7866                	ld	a6,120(sp)
    800051f2:	688a                	ld	a7,128(sp)
    800051f4:	692a                	ld	s2,136(sp)
    800051f6:	69ca                	ld	s3,144(sp)
    800051f8:	6a6a                	ld	s4,152(sp)
    800051fa:	7a8a                	ld	s5,160(sp)
    800051fc:	7b2a                	ld	s6,168(sp)
    800051fe:	7bca                	ld	s7,176(sp)
    80005200:	7c6a                	ld	s8,184(sp)
    80005202:	6c8e                	ld	s9,192(sp)
    80005204:	6d2e                	ld	s10,200(sp)
    80005206:	6dce                	ld	s11,208(sp)
    80005208:	6e6e                	ld	t3,216(sp)
    8000520a:	7e8e                	ld	t4,224(sp)
    8000520c:	7f2e                	ld	t5,232(sp)
    8000520e:	7fce                	ld	t6,240(sp)
    80005210:	6111                	addi	sp,sp,256
    80005212:	10200073          	sret
    80005216:	00000013          	nop
    8000521a:	00000013          	nop
    8000521e:	0001                	nop

0000000080005220 <timervec>:
    80005220:	34051573          	csrrw	a0,mscratch,a0
    80005224:	e10c                	sd	a1,0(a0)
    80005226:	e510                	sd	a2,8(a0)
    80005228:	e914                	sd	a3,16(a0)
    8000522a:	6d0c                	ld	a1,24(a0)
    8000522c:	7110                	ld	a2,32(a0)
    8000522e:	6194                	ld	a3,0(a1)
    80005230:	96b2                	add	a3,a3,a2
    80005232:	e194                	sd	a3,0(a1)
    80005234:	4589                	li	a1,2
    80005236:	14459073          	csrw	sip,a1
    8000523a:	6914                	ld	a3,16(a0)
    8000523c:	6510                	ld	a2,8(a0)
    8000523e:	610c                	ld	a1,0(a0)
    80005240:	34051573          	csrrw	a0,mscratch,a0
    80005244:	30200073          	mret
	...

000000008000524a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000524a:	1141                	addi	sp,sp,-16
    8000524c:	e422                	sd	s0,8(sp)
    8000524e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005250:	0c0007b7          	lui	a5,0xc000
    80005254:	4705                	li	a4,1
    80005256:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005258:	c3d8                	sw	a4,4(a5)
}
    8000525a:	6422                	ld	s0,8(sp)
    8000525c:	0141                	addi	sp,sp,16
    8000525e:	8082                	ret

0000000080005260 <plicinithart>:

void
plicinithart(void)
{
    80005260:	1141                	addi	sp,sp,-16
    80005262:	e406                	sd	ra,8(sp)
    80005264:	e022                	sd	s0,0(sp)
    80005266:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005268:	ffffc097          	auipc	ra,0xffffc
    8000526c:	ca4080e7          	jalr	-860(ra) # 80000f0c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005270:	0085171b          	slliw	a4,a0,0x8
    80005274:	0c0027b7          	lui	a5,0xc002
    80005278:	97ba                	add	a5,a5,a4
    8000527a:	40200713          	li	a4,1026
    8000527e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005282:	00d5151b          	slliw	a0,a0,0xd
    80005286:	0c2017b7          	lui	a5,0xc201
    8000528a:	97aa                	add	a5,a5,a0
    8000528c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005290:	60a2                	ld	ra,8(sp)
    80005292:	6402                	ld	s0,0(sp)
    80005294:	0141                	addi	sp,sp,16
    80005296:	8082                	ret

0000000080005298 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005298:	1141                	addi	sp,sp,-16
    8000529a:	e406                	sd	ra,8(sp)
    8000529c:	e022                	sd	s0,0(sp)
    8000529e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052a0:	ffffc097          	auipc	ra,0xffffc
    800052a4:	c6c080e7          	jalr	-916(ra) # 80000f0c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052a8:	00d5151b          	slliw	a0,a0,0xd
    800052ac:	0c2017b7          	lui	a5,0xc201
    800052b0:	97aa                	add	a5,a5,a0
  return irq;
}
    800052b2:	43c8                	lw	a0,4(a5)
    800052b4:	60a2                	ld	ra,8(sp)
    800052b6:	6402                	ld	s0,0(sp)
    800052b8:	0141                	addi	sp,sp,16
    800052ba:	8082                	ret

00000000800052bc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052bc:	1101                	addi	sp,sp,-32
    800052be:	ec06                	sd	ra,24(sp)
    800052c0:	e822                	sd	s0,16(sp)
    800052c2:	e426                	sd	s1,8(sp)
    800052c4:	1000                	addi	s0,sp,32
    800052c6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800052c8:	ffffc097          	auipc	ra,0xffffc
    800052cc:	c44080e7          	jalr	-956(ra) # 80000f0c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052d0:	00d5151b          	slliw	a0,a0,0xd
    800052d4:	0c2017b7          	lui	a5,0xc201
    800052d8:	97aa                	add	a5,a5,a0
    800052da:	c3c4                	sw	s1,4(a5)
}
    800052dc:	60e2                	ld	ra,24(sp)
    800052de:	6442                	ld	s0,16(sp)
    800052e0:	64a2                	ld	s1,8(sp)
    800052e2:	6105                	addi	sp,sp,32
    800052e4:	8082                	ret

00000000800052e6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800052e6:	1141                	addi	sp,sp,-16
    800052e8:	e406                	sd	ra,8(sp)
    800052ea:	e022                	sd	s0,0(sp)
    800052ec:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800052ee:	479d                	li	a5,7
    800052f0:	04a7cc63          	blt	a5,a0,80005348 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800052f4:	00015797          	auipc	a5,0x15
    800052f8:	94c78793          	addi	a5,a5,-1716 # 80019c40 <disk>
    800052fc:	97aa                	add	a5,a5,a0
    800052fe:	0187c783          	lbu	a5,24(a5)
    80005302:	ebb9                	bnez	a5,80005358 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005304:	00451693          	slli	a3,a0,0x4
    80005308:	00015797          	auipc	a5,0x15
    8000530c:	93878793          	addi	a5,a5,-1736 # 80019c40 <disk>
    80005310:	6398                	ld	a4,0(a5)
    80005312:	9736                	add	a4,a4,a3
    80005314:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005318:	6398                	ld	a4,0(a5)
    8000531a:	9736                	add	a4,a4,a3
    8000531c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005320:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005324:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005328:	97aa                	add	a5,a5,a0
    8000532a:	4705                	li	a4,1
    8000532c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005330:	00015517          	auipc	a0,0x15
    80005334:	92850513          	addi	a0,a0,-1752 # 80019c58 <disk+0x18>
    80005338:	ffffc097          	auipc	ra,0xffffc
    8000533c:	3c8080e7          	jalr	968(ra) # 80001700 <wakeup>
}
    80005340:	60a2                	ld	ra,8(sp)
    80005342:	6402                	ld	s0,0(sp)
    80005344:	0141                	addi	sp,sp,16
    80005346:	8082                	ret
    panic("free_desc 1");
    80005348:	00003517          	auipc	a0,0x3
    8000534c:	3e850513          	addi	a0,a0,1000 # 80008730 <syscalls+0x340>
    80005350:	00001097          	auipc	ra,0x1
    80005354:	a0c080e7          	jalr	-1524(ra) # 80005d5c <panic>
    panic("free_desc 2");
    80005358:	00003517          	auipc	a0,0x3
    8000535c:	3e850513          	addi	a0,a0,1000 # 80008740 <syscalls+0x350>
    80005360:	00001097          	auipc	ra,0x1
    80005364:	9fc080e7          	jalr	-1540(ra) # 80005d5c <panic>

0000000080005368 <virtio_disk_init>:
{
    80005368:	1101                	addi	sp,sp,-32
    8000536a:	ec06                	sd	ra,24(sp)
    8000536c:	e822                	sd	s0,16(sp)
    8000536e:	e426                	sd	s1,8(sp)
    80005370:	e04a                	sd	s2,0(sp)
    80005372:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005374:	00003597          	auipc	a1,0x3
    80005378:	3dc58593          	addi	a1,a1,988 # 80008750 <syscalls+0x360>
    8000537c:	00015517          	auipc	a0,0x15
    80005380:	9ec50513          	addi	a0,a0,-1556 # 80019d68 <disk+0x128>
    80005384:	00001097          	auipc	ra,0x1
    80005388:	e80080e7          	jalr	-384(ra) # 80006204 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000538c:	100017b7          	lui	a5,0x10001
    80005390:	4398                	lw	a4,0(a5)
    80005392:	2701                	sext.w	a4,a4
    80005394:	747277b7          	lui	a5,0x74727
    80005398:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000539c:	14f71b63          	bne	a4,a5,800054f2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800053a0:	100017b7          	lui	a5,0x10001
    800053a4:	43dc                	lw	a5,4(a5)
    800053a6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053a8:	4709                	li	a4,2
    800053aa:	14e79463          	bne	a5,a4,800054f2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053ae:	100017b7          	lui	a5,0x10001
    800053b2:	479c                	lw	a5,8(a5)
    800053b4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800053b6:	12e79e63          	bne	a5,a4,800054f2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800053ba:	100017b7          	lui	a5,0x10001
    800053be:	47d8                	lw	a4,12(a5)
    800053c0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053c2:	554d47b7          	lui	a5,0x554d4
    800053c6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800053ca:	12f71463          	bne	a4,a5,800054f2 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053ce:	100017b7          	lui	a5,0x10001
    800053d2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053d6:	4705                	li	a4,1
    800053d8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053da:	470d                	li	a4,3
    800053dc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800053de:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800053e0:	c7ffe6b7          	lui	a3,0xc7ffe
    800053e4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc79f>
    800053e8:	8f75                	and	a4,a4,a3
    800053ea:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053ec:	472d                	li	a4,11
    800053ee:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800053f0:	5bbc                	lw	a5,112(a5)
    800053f2:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800053f6:	8ba1                	andi	a5,a5,8
    800053f8:	10078563          	beqz	a5,80005502 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800053fc:	100017b7          	lui	a5,0x10001
    80005400:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005404:	43fc                	lw	a5,68(a5)
    80005406:	2781                	sext.w	a5,a5
    80005408:	10079563          	bnez	a5,80005512 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000540c:	100017b7          	lui	a5,0x10001
    80005410:	5bdc                	lw	a5,52(a5)
    80005412:	2781                	sext.w	a5,a5
  if(max == 0)
    80005414:	10078763          	beqz	a5,80005522 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005418:	471d                	li	a4,7
    8000541a:	10f77c63          	bgeu	a4,a5,80005532 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000541e:	ffffb097          	auipc	ra,0xffffb
    80005422:	cfc080e7          	jalr	-772(ra) # 8000011a <kalloc>
    80005426:	00015497          	auipc	s1,0x15
    8000542a:	81a48493          	addi	s1,s1,-2022 # 80019c40 <disk>
    8000542e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005430:	ffffb097          	auipc	ra,0xffffb
    80005434:	cea080e7          	jalr	-790(ra) # 8000011a <kalloc>
    80005438:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000543a:	ffffb097          	auipc	ra,0xffffb
    8000543e:	ce0080e7          	jalr	-800(ra) # 8000011a <kalloc>
    80005442:	87aa                	mv	a5,a0
    80005444:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005446:	6088                	ld	a0,0(s1)
    80005448:	cd6d                	beqz	a0,80005542 <virtio_disk_init+0x1da>
    8000544a:	00014717          	auipc	a4,0x14
    8000544e:	7fe73703          	ld	a4,2046(a4) # 80019c48 <disk+0x8>
    80005452:	cb65                	beqz	a4,80005542 <virtio_disk_init+0x1da>
    80005454:	c7fd                	beqz	a5,80005542 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005456:	6605                	lui	a2,0x1
    80005458:	4581                	li	a1,0
    8000545a:	ffffb097          	auipc	ra,0xffffb
    8000545e:	d20080e7          	jalr	-736(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    80005462:	00014497          	auipc	s1,0x14
    80005466:	7de48493          	addi	s1,s1,2014 # 80019c40 <disk>
    8000546a:	6605                	lui	a2,0x1
    8000546c:	4581                	li	a1,0
    8000546e:	6488                	ld	a0,8(s1)
    80005470:	ffffb097          	auipc	ra,0xffffb
    80005474:	d0a080e7          	jalr	-758(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    80005478:	6605                	lui	a2,0x1
    8000547a:	4581                	li	a1,0
    8000547c:	6888                	ld	a0,16(s1)
    8000547e:	ffffb097          	auipc	ra,0xffffb
    80005482:	cfc080e7          	jalr	-772(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005486:	100017b7          	lui	a5,0x10001
    8000548a:	4721                	li	a4,8
    8000548c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000548e:	4098                	lw	a4,0(s1)
    80005490:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005494:	40d8                	lw	a4,4(s1)
    80005496:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000549a:	6498                	ld	a4,8(s1)
    8000549c:	0007069b          	sext.w	a3,a4
    800054a0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800054a4:	9701                	srai	a4,a4,0x20
    800054a6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800054aa:	6898                	ld	a4,16(s1)
    800054ac:	0007069b          	sext.w	a3,a4
    800054b0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800054b4:	9701                	srai	a4,a4,0x20
    800054b6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800054ba:	4705                	li	a4,1
    800054bc:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800054be:	00e48c23          	sb	a4,24(s1)
    800054c2:	00e48ca3          	sb	a4,25(s1)
    800054c6:	00e48d23          	sb	a4,26(s1)
    800054ca:	00e48da3          	sb	a4,27(s1)
    800054ce:	00e48e23          	sb	a4,28(s1)
    800054d2:	00e48ea3          	sb	a4,29(s1)
    800054d6:	00e48f23          	sb	a4,30(s1)
    800054da:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800054de:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800054e2:	0727a823          	sw	s2,112(a5)
}
    800054e6:	60e2                	ld	ra,24(sp)
    800054e8:	6442                	ld	s0,16(sp)
    800054ea:	64a2                	ld	s1,8(sp)
    800054ec:	6902                	ld	s2,0(sp)
    800054ee:	6105                	addi	sp,sp,32
    800054f0:	8082                	ret
    panic("could not find virtio disk");
    800054f2:	00003517          	auipc	a0,0x3
    800054f6:	26e50513          	addi	a0,a0,622 # 80008760 <syscalls+0x370>
    800054fa:	00001097          	auipc	ra,0x1
    800054fe:	862080e7          	jalr	-1950(ra) # 80005d5c <panic>
    panic("virtio disk FEATURES_OK unset");
    80005502:	00003517          	auipc	a0,0x3
    80005506:	27e50513          	addi	a0,a0,638 # 80008780 <syscalls+0x390>
    8000550a:	00001097          	auipc	ra,0x1
    8000550e:	852080e7          	jalr	-1966(ra) # 80005d5c <panic>
    panic("virtio disk should not be ready");
    80005512:	00003517          	auipc	a0,0x3
    80005516:	28e50513          	addi	a0,a0,654 # 800087a0 <syscalls+0x3b0>
    8000551a:	00001097          	auipc	ra,0x1
    8000551e:	842080e7          	jalr	-1982(ra) # 80005d5c <panic>
    panic("virtio disk has no queue 0");
    80005522:	00003517          	auipc	a0,0x3
    80005526:	29e50513          	addi	a0,a0,670 # 800087c0 <syscalls+0x3d0>
    8000552a:	00001097          	auipc	ra,0x1
    8000552e:	832080e7          	jalr	-1998(ra) # 80005d5c <panic>
    panic("virtio disk max queue too short");
    80005532:	00003517          	auipc	a0,0x3
    80005536:	2ae50513          	addi	a0,a0,686 # 800087e0 <syscalls+0x3f0>
    8000553a:	00001097          	auipc	ra,0x1
    8000553e:	822080e7          	jalr	-2014(ra) # 80005d5c <panic>
    panic("virtio disk kalloc");
    80005542:	00003517          	auipc	a0,0x3
    80005546:	2be50513          	addi	a0,a0,702 # 80008800 <syscalls+0x410>
    8000554a:	00001097          	auipc	ra,0x1
    8000554e:	812080e7          	jalr	-2030(ra) # 80005d5c <panic>

0000000080005552 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005552:	7119                	addi	sp,sp,-128
    80005554:	fc86                	sd	ra,120(sp)
    80005556:	f8a2                	sd	s0,112(sp)
    80005558:	f4a6                	sd	s1,104(sp)
    8000555a:	f0ca                	sd	s2,96(sp)
    8000555c:	ecce                	sd	s3,88(sp)
    8000555e:	e8d2                	sd	s4,80(sp)
    80005560:	e4d6                	sd	s5,72(sp)
    80005562:	e0da                	sd	s6,64(sp)
    80005564:	fc5e                	sd	s7,56(sp)
    80005566:	f862                	sd	s8,48(sp)
    80005568:	f466                	sd	s9,40(sp)
    8000556a:	f06a                	sd	s10,32(sp)
    8000556c:	ec6e                	sd	s11,24(sp)
    8000556e:	0100                	addi	s0,sp,128
    80005570:	8aaa                	mv	s5,a0
    80005572:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005574:	00c52d03          	lw	s10,12(a0)
    80005578:	001d1d1b          	slliw	s10,s10,0x1
    8000557c:	1d02                	slli	s10,s10,0x20
    8000557e:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80005582:	00014517          	auipc	a0,0x14
    80005586:	7e650513          	addi	a0,a0,2022 # 80019d68 <disk+0x128>
    8000558a:	00001097          	auipc	ra,0x1
    8000558e:	d0a080e7          	jalr	-758(ra) # 80006294 <acquire>
  for(int i = 0; i < 3; i++){
    80005592:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005594:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005596:	00014b97          	auipc	s7,0x14
    8000559a:	6aab8b93          	addi	s7,s7,1706 # 80019c40 <disk>
  for(int i = 0; i < 3; i++){
    8000559e:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055a0:	00014c97          	auipc	s9,0x14
    800055a4:	7c8c8c93          	addi	s9,s9,1992 # 80019d68 <disk+0x128>
    800055a8:	a08d                	j	8000560a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800055aa:	00fb8733          	add	a4,s7,a5
    800055ae:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800055b2:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800055b4:	0207c563          	bltz	a5,800055de <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800055b8:	2905                	addiw	s2,s2,1
    800055ba:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800055bc:	05690c63          	beq	s2,s6,80005614 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800055c0:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800055c2:	00014717          	auipc	a4,0x14
    800055c6:	67e70713          	addi	a4,a4,1662 # 80019c40 <disk>
    800055ca:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800055cc:	01874683          	lbu	a3,24(a4)
    800055d0:	fee9                	bnez	a3,800055aa <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800055d2:	2785                	addiw	a5,a5,1
    800055d4:	0705                	addi	a4,a4,1
    800055d6:	fe979be3          	bne	a5,s1,800055cc <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800055da:	57fd                	li	a5,-1
    800055dc:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800055de:	01205d63          	blez	s2,800055f8 <virtio_disk_rw+0xa6>
    800055e2:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800055e4:	000a2503          	lw	a0,0(s4)
    800055e8:	00000097          	auipc	ra,0x0
    800055ec:	cfe080e7          	jalr	-770(ra) # 800052e6 <free_desc>
      for(int j = 0; j < i; j++)
    800055f0:	2d85                	addiw	s11,s11,1
    800055f2:	0a11                	addi	s4,s4,4
    800055f4:	ff2d98e3          	bne	s11,s2,800055e4 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055f8:	85e6                	mv	a1,s9
    800055fa:	00014517          	auipc	a0,0x14
    800055fe:	65e50513          	addi	a0,a0,1630 # 80019c58 <disk+0x18>
    80005602:	ffffc097          	auipc	ra,0xffffc
    80005606:	09a080e7          	jalr	154(ra) # 8000169c <sleep>
  for(int i = 0; i < 3; i++){
    8000560a:	f8040a13          	addi	s4,s0,-128
{
    8000560e:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005610:	894e                	mv	s2,s3
    80005612:	b77d                	j	800055c0 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005614:	f8042503          	lw	a0,-128(s0)
    80005618:	00a50713          	addi	a4,a0,10
    8000561c:	0712                	slli	a4,a4,0x4

  if(write)
    8000561e:	00014797          	auipc	a5,0x14
    80005622:	62278793          	addi	a5,a5,1570 # 80019c40 <disk>
    80005626:	00e786b3          	add	a3,a5,a4
    8000562a:	01803633          	snez	a2,s8
    8000562e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005630:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005634:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005638:	f6070613          	addi	a2,a4,-160
    8000563c:	6394                	ld	a3,0(a5)
    8000563e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005640:	00870593          	addi	a1,a4,8
    80005644:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005646:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005648:	0007b803          	ld	a6,0(a5)
    8000564c:	9642                	add	a2,a2,a6
    8000564e:	46c1                	li	a3,16
    80005650:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005652:	4585                	li	a1,1
    80005654:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005658:	f8442683          	lw	a3,-124(s0)
    8000565c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005660:	0692                	slli	a3,a3,0x4
    80005662:	9836                	add	a6,a6,a3
    80005664:	058a8613          	addi	a2,s5,88
    80005668:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000566c:	0007b803          	ld	a6,0(a5)
    80005670:	96c2                	add	a3,a3,a6
    80005672:	40000613          	li	a2,1024
    80005676:	c690                	sw	a2,8(a3)
  if(write)
    80005678:	001c3613          	seqz	a2,s8
    8000567c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005680:	00166613          	ori	a2,a2,1
    80005684:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005688:	f8842603          	lw	a2,-120(s0)
    8000568c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005690:	00250693          	addi	a3,a0,2
    80005694:	0692                	slli	a3,a3,0x4
    80005696:	96be                	add	a3,a3,a5
    80005698:	58fd                	li	a7,-1
    8000569a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000569e:	0612                	slli	a2,a2,0x4
    800056a0:	9832                	add	a6,a6,a2
    800056a2:	f9070713          	addi	a4,a4,-112
    800056a6:	973e                	add	a4,a4,a5
    800056a8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800056ac:	6398                	ld	a4,0(a5)
    800056ae:	9732                	add	a4,a4,a2
    800056b0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800056b2:	4609                	li	a2,2
    800056b4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800056b8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800056bc:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    800056c0:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800056c4:	6794                	ld	a3,8(a5)
    800056c6:	0026d703          	lhu	a4,2(a3)
    800056ca:	8b1d                	andi	a4,a4,7
    800056cc:	0706                	slli	a4,a4,0x1
    800056ce:	96ba                	add	a3,a3,a4
    800056d0:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800056d4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056d8:	6798                	ld	a4,8(a5)
    800056da:	00275783          	lhu	a5,2(a4)
    800056de:	2785                	addiw	a5,a5,1
    800056e0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800056e4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800056e8:	100017b7          	lui	a5,0x10001
    800056ec:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800056f0:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    800056f4:	00014917          	auipc	s2,0x14
    800056f8:	67490913          	addi	s2,s2,1652 # 80019d68 <disk+0x128>
  while(b->disk == 1) {
    800056fc:	4485                	li	s1,1
    800056fe:	00b79c63          	bne	a5,a1,80005716 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005702:	85ca                	mv	a1,s2
    80005704:	8556                	mv	a0,s5
    80005706:	ffffc097          	auipc	ra,0xffffc
    8000570a:	f96080e7          	jalr	-106(ra) # 8000169c <sleep>
  while(b->disk == 1) {
    8000570e:	004aa783          	lw	a5,4(s5)
    80005712:	fe9788e3          	beq	a5,s1,80005702 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005716:	f8042903          	lw	s2,-128(s0)
    8000571a:	00290713          	addi	a4,s2,2
    8000571e:	0712                	slli	a4,a4,0x4
    80005720:	00014797          	auipc	a5,0x14
    80005724:	52078793          	addi	a5,a5,1312 # 80019c40 <disk>
    80005728:	97ba                	add	a5,a5,a4
    8000572a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000572e:	00014997          	auipc	s3,0x14
    80005732:	51298993          	addi	s3,s3,1298 # 80019c40 <disk>
    80005736:	00491713          	slli	a4,s2,0x4
    8000573a:	0009b783          	ld	a5,0(s3)
    8000573e:	97ba                	add	a5,a5,a4
    80005740:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005744:	854a                	mv	a0,s2
    80005746:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000574a:	00000097          	auipc	ra,0x0
    8000574e:	b9c080e7          	jalr	-1124(ra) # 800052e6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005752:	8885                	andi	s1,s1,1
    80005754:	f0ed                	bnez	s1,80005736 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005756:	00014517          	auipc	a0,0x14
    8000575a:	61250513          	addi	a0,a0,1554 # 80019d68 <disk+0x128>
    8000575e:	00001097          	auipc	ra,0x1
    80005762:	bea080e7          	jalr	-1046(ra) # 80006348 <release>
}
    80005766:	70e6                	ld	ra,120(sp)
    80005768:	7446                	ld	s0,112(sp)
    8000576a:	74a6                	ld	s1,104(sp)
    8000576c:	7906                	ld	s2,96(sp)
    8000576e:	69e6                	ld	s3,88(sp)
    80005770:	6a46                	ld	s4,80(sp)
    80005772:	6aa6                	ld	s5,72(sp)
    80005774:	6b06                	ld	s6,64(sp)
    80005776:	7be2                	ld	s7,56(sp)
    80005778:	7c42                	ld	s8,48(sp)
    8000577a:	7ca2                	ld	s9,40(sp)
    8000577c:	7d02                	ld	s10,32(sp)
    8000577e:	6de2                	ld	s11,24(sp)
    80005780:	6109                	addi	sp,sp,128
    80005782:	8082                	ret

0000000080005784 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005784:	1101                	addi	sp,sp,-32
    80005786:	ec06                	sd	ra,24(sp)
    80005788:	e822                	sd	s0,16(sp)
    8000578a:	e426                	sd	s1,8(sp)
    8000578c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000578e:	00014497          	auipc	s1,0x14
    80005792:	4b248493          	addi	s1,s1,1202 # 80019c40 <disk>
    80005796:	00014517          	auipc	a0,0x14
    8000579a:	5d250513          	addi	a0,a0,1490 # 80019d68 <disk+0x128>
    8000579e:	00001097          	auipc	ra,0x1
    800057a2:	af6080e7          	jalr	-1290(ra) # 80006294 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057a6:	10001737          	lui	a4,0x10001
    800057aa:	533c                	lw	a5,96(a4)
    800057ac:	8b8d                	andi	a5,a5,3
    800057ae:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800057b0:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057b4:	689c                	ld	a5,16(s1)
    800057b6:	0204d703          	lhu	a4,32(s1)
    800057ba:	0027d783          	lhu	a5,2(a5)
    800057be:	04f70863          	beq	a4,a5,8000580e <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800057c2:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057c6:	6898                	ld	a4,16(s1)
    800057c8:	0204d783          	lhu	a5,32(s1)
    800057cc:	8b9d                	andi	a5,a5,7
    800057ce:	078e                	slli	a5,a5,0x3
    800057d0:	97ba                	add	a5,a5,a4
    800057d2:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057d4:	00278713          	addi	a4,a5,2
    800057d8:	0712                	slli	a4,a4,0x4
    800057da:	9726                	add	a4,a4,s1
    800057dc:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800057e0:	e721                	bnez	a4,80005828 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057e2:	0789                	addi	a5,a5,2
    800057e4:	0792                	slli	a5,a5,0x4
    800057e6:	97a6                	add	a5,a5,s1
    800057e8:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800057ea:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800057ee:	ffffc097          	auipc	ra,0xffffc
    800057f2:	f12080e7          	jalr	-238(ra) # 80001700 <wakeup>

    disk.used_idx += 1;
    800057f6:	0204d783          	lhu	a5,32(s1)
    800057fa:	2785                	addiw	a5,a5,1
    800057fc:	17c2                	slli	a5,a5,0x30
    800057fe:	93c1                	srli	a5,a5,0x30
    80005800:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005804:	6898                	ld	a4,16(s1)
    80005806:	00275703          	lhu	a4,2(a4)
    8000580a:	faf71ce3          	bne	a4,a5,800057c2 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000580e:	00014517          	auipc	a0,0x14
    80005812:	55a50513          	addi	a0,a0,1370 # 80019d68 <disk+0x128>
    80005816:	00001097          	auipc	ra,0x1
    8000581a:	b32080e7          	jalr	-1230(ra) # 80006348 <release>
}
    8000581e:	60e2                	ld	ra,24(sp)
    80005820:	6442                	ld	s0,16(sp)
    80005822:	64a2                	ld	s1,8(sp)
    80005824:	6105                	addi	sp,sp,32
    80005826:	8082                	ret
      panic("virtio_disk_intr status");
    80005828:	00003517          	auipc	a0,0x3
    8000582c:	ff050513          	addi	a0,a0,-16 # 80008818 <syscalls+0x428>
    80005830:	00000097          	auipc	ra,0x0
    80005834:	52c080e7          	jalr	1324(ra) # 80005d5c <panic>

0000000080005838 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005838:	1141                	addi	sp,sp,-16
    8000583a:	e422                	sd	s0,8(sp)
    8000583c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000583e:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005842:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005846:	0037979b          	slliw	a5,a5,0x3
    8000584a:	02004737          	lui	a4,0x2004
    8000584e:	97ba                	add	a5,a5,a4
    80005850:	0200c737          	lui	a4,0x200c
    80005854:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005858:	000f4637          	lui	a2,0xf4
    8000585c:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005860:	9732                	add	a4,a4,a2
    80005862:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005864:	00259693          	slli	a3,a1,0x2
    80005868:	96ae                	add	a3,a3,a1
    8000586a:	068e                	slli	a3,a3,0x3
    8000586c:	00014717          	auipc	a4,0x14
    80005870:	51470713          	addi	a4,a4,1300 # 80019d80 <timer_scratch>
    80005874:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005876:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005878:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000587a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000587e:	00000797          	auipc	a5,0x0
    80005882:	9a278793          	addi	a5,a5,-1630 # 80005220 <timervec>
    80005886:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000588a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000588e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005892:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005896:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000589a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000589e:	30479073          	csrw	mie,a5
}
    800058a2:	6422                	ld	s0,8(sp)
    800058a4:	0141                	addi	sp,sp,16
    800058a6:	8082                	ret

00000000800058a8 <start>:
{
    800058a8:	1141                	addi	sp,sp,-16
    800058aa:	e406                	sd	ra,8(sp)
    800058ac:	e022                	sd	s0,0(sp)
    800058ae:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058b0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058b4:	7779                	lui	a4,0xffffe
    800058b6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc83f>
    800058ba:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058bc:	6705                	lui	a4,0x1
    800058be:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800058c2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058c4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800058c8:	ffffb797          	auipc	a5,0xffffb
    800058cc:	a5878793          	addi	a5,a5,-1448 # 80000320 <main>
    800058d0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800058d4:	4781                	li	a5,0
    800058d6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800058da:	67c1                	lui	a5,0x10
    800058dc:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800058de:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800058e2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800058e6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800058ea:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800058ee:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800058f2:	57fd                	li	a5,-1
    800058f4:	83a9                	srli	a5,a5,0xa
    800058f6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800058fa:	47bd                	li	a5,15
    800058fc:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005900:	00000097          	auipc	ra,0x0
    80005904:	f38080e7          	jalr	-200(ra) # 80005838 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005908:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000590c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000590e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005910:	30200073          	mret
}
    80005914:	60a2                	ld	ra,8(sp)
    80005916:	6402                	ld	s0,0(sp)
    80005918:	0141                	addi	sp,sp,16
    8000591a:	8082                	ret

000000008000591c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000591c:	715d                	addi	sp,sp,-80
    8000591e:	e486                	sd	ra,72(sp)
    80005920:	e0a2                	sd	s0,64(sp)
    80005922:	fc26                	sd	s1,56(sp)
    80005924:	f84a                	sd	s2,48(sp)
    80005926:	f44e                	sd	s3,40(sp)
    80005928:	f052                	sd	s4,32(sp)
    8000592a:	ec56                	sd	s5,24(sp)
    8000592c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000592e:	04c05763          	blez	a2,8000597c <consolewrite+0x60>
    80005932:	8a2a                	mv	s4,a0
    80005934:	84ae                	mv	s1,a1
    80005936:	89b2                	mv	s3,a2
    80005938:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000593a:	5afd                	li	s5,-1
    8000593c:	4685                	li	a3,1
    8000593e:	8626                	mv	a2,s1
    80005940:	85d2                	mv	a1,s4
    80005942:	fbf40513          	addi	a0,s0,-65
    80005946:	ffffc097          	auipc	ra,0xffffc
    8000594a:	1b4080e7          	jalr	436(ra) # 80001afa <either_copyin>
    8000594e:	01550d63          	beq	a0,s5,80005968 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005952:	fbf44503          	lbu	a0,-65(s0)
    80005956:	00000097          	auipc	ra,0x0
    8000595a:	784080e7          	jalr	1924(ra) # 800060da <uartputc>
  for(i = 0; i < n; i++){
    8000595e:	2905                	addiw	s2,s2,1
    80005960:	0485                	addi	s1,s1,1
    80005962:	fd299de3          	bne	s3,s2,8000593c <consolewrite+0x20>
    80005966:	894e                	mv	s2,s3
  }

  return i;
}
    80005968:	854a                	mv	a0,s2
    8000596a:	60a6                	ld	ra,72(sp)
    8000596c:	6406                	ld	s0,64(sp)
    8000596e:	74e2                	ld	s1,56(sp)
    80005970:	7942                	ld	s2,48(sp)
    80005972:	79a2                	ld	s3,40(sp)
    80005974:	7a02                	ld	s4,32(sp)
    80005976:	6ae2                	ld	s5,24(sp)
    80005978:	6161                	addi	sp,sp,80
    8000597a:	8082                	ret
  for(i = 0; i < n; i++){
    8000597c:	4901                	li	s2,0
    8000597e:	b7ed                	j	80005968 <consolewrite+0x4c>

0000000080005980 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005980:	7159                	addi	sp,sp,-112
    80005982:	f486                	sd	ra,104(sp)
    80005984:	f0a2                	sd	s0,96(sp)
    80005986:	eca6                	sd	s1,88(sp)
    80005988:	e8ca                	sd	s2,80(sp)
    8000598a:	e4ce                	sd	s3,72(sp)
    8000598c:	e0d2                	sd	s4,64(sp)
    8000598e:	fc56                	sd	s5,56(sp)
    80005990:	f85a                	sd	s6,48(sp)
    80005992:	f45e                	sd	s7,40(sp)
    80005994:	f062                	sd	s8,32(sp)
    80005996:	ec66                	sd	s9,24(sp)
    80005998:	e86a                	sd	s10,16(sp)
    8000599a:	1880                	addi	s0,sp,112
    8000599c:	8aaa                	mv	s5,a0
    8000599e:	8a2e                	mv	s4,a1
    800059a0:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800059a2:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800059a6:	0001c517          	auipc	a0,0x1c
    800059aa:	51a50513          	addi	a0,a0,1306 # 80021ec0 <cons>
    800059ae:	00001097          	auipc	ra,0x1
    800059b2:	8e6080e7          	jalr	-1818(ra) # 80006294 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059b6:	0001c497          	auipc	s1,0x1c
    800059ba:	50a48493          	addi	s1,s1,1290 # 80021ec0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059be:	0001c917          	auipc	s2,0x1c
    800059c2:	59a90913          	addi	s2,s2,1434 # 80021f58 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800059c6:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059c8:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800059ca:	4ca9                	li	s9,10
  while(n > 0){
    800059cc:	07305b63          	blez	s3,80005a42 <consoleread+0xc2>
    while(cons.r == cons.w){
    800059d0:	0984a783          	lw	a5,152(s1)
    800059d4:	09c4a703          	lw	a4,156(s1)
    800059d8:	02f71763          	bne	a4,a5,80005a06 <consoleread+0x86>
      if(killed(myproc())){
    800059dc:	ffffb097          	auipc	ra,0xffffb
    800059e0:	55c080e7          	jalr	1372(ra) # 80000f38 <myproc>
    800059e4:	ffffc097          	auipc	ra,0xffffc
    800059e8:	f60080e7          	jalr	-160(ra) # 80001944 <killed>
    800059ec:	e535                	bnez	a0,80005a58 <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    800059ee:	85a6                	mv	a1,s1
    800059f0:	854a                	mv	a0,s2
    800059f2:	ffffc097          	auipc	ra,0xffffc
    800059f6:	caa080e7          	jalr	-854(ra) # 8000169c <sleep>
    while(cons.r == cons.w){
    800059fa:	0984a783          	lw	a5,152(s1)
    800059fe:	09c4a703          	lw	a4,156(s1)
    80005a02:	fcf70de3          	beq	a4,a5,800059dc <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005a06:	0017871b          	addiw	a4,a5,1
    80005a0a:	08e4ac23          	sw	a4,152(s1)
    80005a0e:	07f7f713          	andi	a4,a5,127
    80005a12:	9726                	add	a4,a4,s1
    80005a14:	01874703          	lbu	a4,24(a4)
    80005a18:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005a1c:	077d0563          	beq	s10,s7,80005a86 <consoleread+0x106>
    cbuf = c;
    80005a20:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a24:	4685                	li	a3,1
    80005a26:	f9f40613          	addi	a2,s0,-97
    80005a2a:	85d2                	mv	a1,s4
    80005a2c:	8556                	mv	a0,s5
    80005a2e:	ffffc097          	auipc	ra,0xffffc
    80005a32:	076080e7          	jalr	118(ra) # 80001aa4 <either_copyout>
    80005a36:	01850663          	beq	a0,s8,80005a42 <consoleread+0xc2>
    dst++;
    80005a3a:	0a05                	addi	s4,s4,1
    --n;
    80005a3c:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005a3e:	f99d17e3          	bne	s10,s9,800059cc <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a42:	0001c517          	auipc	a0,0x1c
    80005a46:	47e50513          	addi	a0,a0,1150 # 80021ec0 <cons>
    80005a4a:	00001097          	auipc	ra,0x1
    80005a4e:	8fe080e7          	jalr	-1794(ra) # 80006348 <release>

  return target - n;
    80005a52:	413b053b          	subw	a0,s6,s3
    80005a56:	a811                	j	80005a6a <consoleread+0xea>
        release(&cons.lock);
    80005a58:	0001c517          	auipc	a0,0x1c
    80005a5c:	46850513          	addi	a0,a0,1128 # 80021ec0 <cons>
    80005a60:	00001097          	auipc	ra,0x1
    80005a64:	8e8080e7          	jalr	-1816(ra) # 80006348 <release>
        return -1;
    80005a68:	557d                	li	a0,-1
}
    80005a6a:	70a6                	ld	ra,104(sp)
    80005a6c:	7406                	ld	s0,96(sp)
    80005a6e:	64e6                	ld	s1,88(sp)
    80005a70:	6946                	ld	s2,80(sp)
    80005a72:	69a6                	ld	s3,72(sp)
    80005a74:	6a06                	ld	s4,64(sp)
    80005a76:	7ae2                	ld	s5,56(sp)
    80005a78:	7b42                	ld	s6,48(sp)
    80005a7a:	7ba2                	ld	s7,40(sp)
    80005a7c:	7c02                	ld	s8,32(sp)
    80005a7e:	6ce2                	ld	s9,24(sp)
    80005a80:	6d42                	ld	s10,16(sp)
    80005a82:	6165                	addi	sp,sp,112
    80005a84:	8082                	ret
      if(n < target){
    80005a86:	0009871b          	sext.w	a4,s3
    80005a8a:	fb677ce3          	bgeu	a4,s6,80005a42 <consoleread+0xc2>
        cons.r--;
    80005a8e:	0001c717          	auipc	a4,0x1c
    80005a92:	4cf72523          	sw	a5,1226(a4) # 80021f58 <cons+0x98>
    80005a96:	b775                	j	80005a42 <consoleread+0xc2>

0000000080005a98 <consputc>:
{
    80005a98:	1141                	addi	sp,sp,-16
    80005a9a:	e406                	sd	ra,8(sp)
    80005a9c:	e022                	sd	s0,0(sp)
    80005a9e:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005aa0:	10000793          	li	a5,256
    80005aa4:	00f50a63          	beq	a0,a5,80005ab8 <consputc+0x20>
    uartputc_sync(c);
    80005aa8:	00000097          	auipc	ra,0x0
    80005aac:	560080e7          	jalr	1376(ra) # 80006008 <uartputc_sync>
}
    80005ab0:	60a2                	ld	ra,8(sp)
    80005ab2:	6402                	ld	s0,0(sp)
    80005ab4:	0141                	addi	sp,sp,16
    80005ab6:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ab8:	4521                	li	a0,8
    80005aba:	00000097          	auipc	ra,0x0
    80005abe:	54e080e7          	jalr	1358(ra) # 80006008 <uartputc_sync>
    80005ac2:	02000513          	li	a0,32
    80005ac6:	00000097          	auipc	ra,0x0
    80005aca:	542080e7          	jalr	1346(ra) # 80006008 <uartputc_sync>
    80005ace:	4521                	li	a0,8
    80005ad0:	00000097          	auipc	ra,0x0
    80005ad4:	538080e7          	jalr	1336(ra) # 80006008 <uartputc_sync>
    80005ad8:	bfe1                	j	80005ab0 <consputc+0x18>

0000000080005ada <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005ada:	1101                	addi	sp,sp,-32
    80005adc:	ec06                	sd	ra,24(sp)
    80005ade:	e822                	sd	s0,16(sp)
    80005ae0:	e426                	sd	s1,8(sp)
    80005ae2:	e04a                	sd	s2,0(sp)
    80005ae4:	1000                	addi	s0,sp,32
    80005ae6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005ae8:	0001c517          	auipc	a0,0x1c
    80005aec:	3d850513          	addi	a0,a0,984 # 80021ec0 <cons>
    80005af0:	00000097          	auipc	ra,0x0
    80005af4:	7a4080e7          	jalr	1956(ra) # 80006294 <acquire>

  switch(c){
    80005af8:	47d5                	li	a5,21
    80005afa:	0af48663          	beq	s1,a5,80005ba6 <consoleintr+0xcc>
    80005afe:	0297ca63          	blt	a5,s1,80005b32 <consoleintr+0x58>
    80005b02:	47a1                	li	a5,8
    80005b04:	0ef48763          	beq	s1,a5,80005bf2 <consoleintr+0x118>
    80005b08:	47c1                	li	a5,16
    80005b0a:	10f49a63          	bne	s1,a5,80005c1e <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b0e:	ffffc097          	auipc	ra,0xffffc
    80005b12:	042080e7          	jalr	66(ra) # 80001b50 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b16:	0001c517          	auipc	a0,0x1c
    80005b1a:	3aa50513          	addi	a0,a0,938 # 80021ec0 <cons>
    80005b1e:	00001097          	auipc	ra,0x1
    80005b22:	82a080e7          	jalr	-2006(ra) # 80006348 <release>
}
    80005b26:	60e2                	ld	ra,24(sp)
    80005b28:	6442                	ld	s0,16(sp)
    80005b2a:	64a2                	ld	s1,8(sp)
    80005b2c:	6902                	ld	s2,0(sp)
    80005b2e:	6105                	addi	sp,sp,32
    80005b30:	8082                	ret
  switch(c){
    80005b32:	07f00793          	li	a5,127
    80005b36:	0af48e63          	beq	s1,a5,80005bf2 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b3a:	0001c717          	auipc	a4,0x1c
    80005b3e:	38670713          	addi	a4,a4,902 # 80021ec0 <cons>
    80005b42:	0a072783          	lw	a5,160(a4)
    80005b46:	09872703          	lw	a4,152(a4)
    80005b4a:	9f99                	subw	a5,a5,a4
    80005b4c:	07f00713          	li	a4,127
    80005b50:	fcf763e3          	bltu	a4,a5,80005b16 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b54:	47b5                	li	a5,13
    80005b56:	0cf48763          	beq	s1,a5,80005c24 <consoleintr+0x14a>
      consputc(c);
    80005b5a:	8526                	mv	a0,s1
    80005b5c:	00000097          	auipc	ra,0x0
    80005b60:	f3c080e7          	jalr	-196(ra) # 80005a98 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b64:	0001c797          	auipc	a5,0x1c
    80005b68:	35c78793          	addi	a5,a5,860 # 80021ec0 <cons>
    80005b6c:	0a07a683          	lw	a3,160(a5)
    80005b70:	0016871b          	addiw	a4,a3,1
    80005b74:	0007061b          	sext.w	a2,a4
    80005b78:	0ae7a023          	sw	a4,160(a5)
    80005b7c:	07f6f693          	andi	a3,a3,127
    80005b80:	97b6                	add	a5,a5,a3
    80005b82:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005b86:	47a9                	li	a5,10
    80005b88:	0cf48563          	beq	s1,a5,80005c52 <consoleintr+0x178>
    80005b8c:	4791                	li	a5,4
    80005b8e:	0cf48263          	beq	s1,a5,80005c52 <consoleintr+0x178>
    80005b92:	0001c797          	auipc	a5,0x1c
    80005b96:	3c67a783          	lw	a5,966(a5) # 80021f58 <cons+0x98>
    80005b9a:	9f1d                	subw	a4,a4,a5
    80005b9c:	08000793          	li	a5,128
    80005ba0:	f6f71be3          	bne	a4,a5,80005b16 <consoleintr+0x3c>
    80005ba4:	a07d                	j	80005c52 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005ba6:	0001c717          	auipc	a4,0x1c
    80005baa:	31a70713          	addi	a4,a4,794 # 80021ec0 <cons>
    80005bae:	0a072783          	lw	a5,160(a4)
    80005bb2:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005bb6:	0001c497          	auipc	s1,0x1c
    80005bba:	30a48493          	addi	s1,s1,778 # 80021ec0 <cons>
    while(cons.e != cons.w &&
    80005bbe:	4929                	li	s2,10
    80005bc0:	f4f70be3          	beq	a4,a5,80005b16 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005bc4:	37fd                	addiw	a5,a5,-1
    80005bc6:	07f7f713          	andi	a4,a5,127
    80005bca:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005bcc:	01874703          	lbu	a4,24(a4)
    80005bd0:	f52703e3          	beq	a4,s2,80005b16 <consoleintr+0x3c>
      cons.e--;
    80005bd4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005bd8:	10000513          	li	a0,256
    80005bdc:	00000097          	auipc	ra,0x0
    80005be0:	ebc080e7          	jalr	-324(ra) # 80005a98 <consputc>
    while(cons.e != cons.w &&
    80005be4:	0a04a783          	lw	a5,160(s1)
    80005be8:	09c4a703          	lw	a4,156(s1)
    80005bec:	fcf71ce3          	bne	a4,a5,80005bc4 <consoleintr+0xea>
    80005bf0:	b71d                	j	80005b16 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005bf2:	0001c717          	auipc	a4,0x1c
    80005bf6:	2ce70713          	addi	a4,a4,718 # 80021ec0 <cons>
    80005bfa:	0a072783          	lw	a5,160(a4)
    80005bfe:	09c72703          	lw	a4,156(a4)
    80005c02:	f0f70ae3          	beq	a4,a5,80005b16 <consoleintr+0x3c>
      cons.e--;
    80005c06:	37fd                	addiw	a5,a5,-1
    80005c08:	0001c717          	auipc	a4,0x1c
    80005c0c:	34f72c23          	sw	a5,856(a4) # 80021f60 <cons+0xa0>
      consputc(BACKSPACE);
    80005c10:	10000513          	li	a0,256
    80005c14:	00000097          	auipc	ra,0x0
    80005c18:	e84080e7          	jalr	-380(ra) # 80005a98 <consputc>
    80005c1c:	bded                	j	80005b16 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c1e:	ee048ce3          	beqz	s1,80005b16 <consoleintr+0x3c>
    80005c22:	bf21                	j	80005b3a <consoleintr+0x60>
      consputc(c);
    80005c24:	4529                	li	a0,10
    80005c26:	00000097          	auipc	ra,0x0
    80005c2a:	e72080e7          	jalr	-398(ra) # 80005a98 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c2e:	0001c797          	auipc	a5,0x1c
    80005c32:	29278793          	addi	a5,a5,658 # 80021ec0 <cons>
    80005c36:	0a07a703          	lw	a4,160(a5)
    80005c3a:	0017069b          	addiw	a3,a4,1
    80005c3e:	0006861b          	sext.w	a2,a3
    80005c42:	0ad7a023          	sw	a3,160(a5)
    80005c46:	07f77713          	andi	a4,a4,127
    80005c4a:	97ba                	add	a5,a5,a4
    80005c4c:	4729                	li	a4,10
    80005c4e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c52:	0001c797          	auipc	a5,0x1c
    80005c56:	30c7a523          	sw	a2,778(a5) # 80021f5c <cons+0x9c>
        wakeup(&cons.r);
    80005c5a:	0001c517          	auipc	a0,0x1c
    80005c5e:	2fe50513          	addi	a0,a0,766 # 80021f58 <cons+0x98>
    80005c62:	ffffc097          	auipc	ra,0xffffc
    80005c66:	a9e080e7          	jalr	-1378(ra) # 80001700 <wakeup>
    80005c6a:	b575                	j	80005b16 <consoleintr+0x3c>

0000000080005c6c <consoleinit>:

void
consoleinit(void)
{
    80005c6c:	1141                	addi	sp,sp,-16
    80005c6e:	e406                	sd	ra,8(sp)
    80005c70:	e022                	sd	s0,0(sp)
    80005c72:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c74:	00003597          	auipc	a1,0x3
    80005c78:	bbc58593          	addi	a1,a1,-1092 # 80008830 <syscalls+0x440>
    80005c7c:	0001c517          	auipc	a0,0x1c
    80005c80:	24450513          	addi	a0,a0,580 # 80021ec0 <cons>
    80005c84:	00000097          	auipc	ra,0x0
    80005c88:	580080e7          	jalr	1408(ra) # 80006204 <initlock>

  uartinit();
    80005c8c:	00000097          	auipc	ra,0x0
    80005c90:	32c080e7          	jalr	812(ra) # 80005fb8 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c94:	00013797          	auipc	a5,0x13
    80005c98:	f5478793          	addi	a5,a5,-172 # 80018be8 <devsw>
    80005c9c:	00000717          	auipc	a4,0x0
    80005ca0:	ce470713          	addi	a4,a4,-796 # 80005980 <consoleread>
    80005ca4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005ca6:	00000717          	auipc	a4,0x0
    80005caa:	c7670713          	addi	a4,a4,-906 # 8000591c <consolewrite>
    80005cae:	ef98                	sd	a4,24(a5)
}
    80005cb0:	60a2                	ld	ra,8(sp)
    80005cb2:	6402                	ld	s0,0(sp)
    80005cb4:	0141                	addi	sp,sp,16
    80005cb6:	8082                	ret

0000000080005cb8 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005cb8:	7179                	addi	sp,sp,-48
    80005cba:	f406                	sd	ra,40(sp)
    80005cbc:	f022                	sd	s0,32(sp)
    80005cbe:	ec26                	sd	s1,24(sp)
    80005cc0:	e84a                	sd	s2,16(sp)
    80005cc2:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005cc4:	c219                	beqz	a2,80005cca <printint+0x12>
    80005cc6:	08054763          	bltz	a0,80005d54 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005cca:	2501                	sext.w	a0,a0
    80005ccc:	4881                	li	a7,0
    80005cce:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005cd2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005cd4:	2581                	sext.w	a1,a1
    80005cd6:	00003617          	auipc	a2,0x3
    80005cda:	b8a60613          	addi	a2,a2,-1142 # 80008860 <digits>
    80005cde:	883a                	mv	a6,a4
    80005ce0:	2705                	addiw	a4,a4,1
    80005ce2:	02b577bb          	remuw	a5,a0,a1
    80005ce6:	1782                	slli	a5,a5,0x20
    80005ce8:	9381                	srli	a5,a5,0x20
    80005cea:	97b2                	add	a5,a5,a2
    80005cec:	0007c783          	lbu	a5,0(a5)
    80005cf0:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005cf4:	0005079b          	sext.w	a5,a0
    80005cf8:	02b5553b          	divuw	a0,a0,a1
    80005cfc:	0685                	addi	a3,a3,1
    80005cfe:	feb7f0e3          	bgeu	a5,a1,80005cde <printint+0x26>

  if(sign)
    80005d02:	00088c63          	beqz	a7,80005d1a <printint+0x62>
    buf[i++] = '-';
    80005d06:	fe070793          	addi	a5,a4,-32
    80005d0a:	00878733          	add	a4,a5,s0
    80005d0e:	02d00793          	li	a5,45
    80005d12:	fef70823          	sb	a5,-16(a4)
    80005d16:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d1a:	02e05763          	blez	a4,80005d48 <printint+0x90>
    80005d1e:	fd040793          	addi	a5,s0,-48
    80005d22:	00e784b3          	add	s1,a5,a4
    80005d26:	fff78913          	addi	s2,a5,-1
    80005d2a:	993a                	add	s2,s2,a4
    80005d2c:	377d                	addiw	a4,a4,-1
    80005d2e:	1702                	slli	a4,a4,0x20
    80005d30:	9301                	srli	a4,a4,0x20
    80005d32:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d36:	fff4c503          	lbu	a0,-1(s1)
    80005d3a:	00000097          	auipc	ra,0x0
    80005d3e:	d5e080e7          	jalr	-674(ra) # 80005a98 <consputc>
  while(--i >= 0)
    80005d42:	14fd                	addi	s1,s1,-1
    80005d44:	ff2499e3          	bne	s1,s2,80005d36 <printint+0x7e>
}
    80005d48:	70a2                	ld	ra,40(sp)
    80005d4a:	7402                	ld	s0,32(sp)
    80005d4c:	64e2                	ld	s1,24(sp)
    80005d4e:	6942                	ld	s2,16(sp)
    80005d50:	6145                	addi	sp,sp,48
    80005d52:	8082                	ret
    x = -xx;
    80005d54:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d58:	4885                	li	a7,1
    x = -xx;
    80005d5a:	bf95                	j	80005cce <printint+0x16>

0000000080005d5c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d5c:	1101                	addi	sp,sp,-32
    80005d5e:	ec06                	sd	ra,24(sp)
    80005d60:	e822                	sd	s0,16(sp)
    80005d62:	e426                	sd	s1,8(sp)
    80005d64:	1000                	addi	s0,sp,32
    80005d66:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d68:	0001c797          	auipc	a5,0x1c
    80005d6c:	2007ac23          	sw	zero,536(a5) # 80021f80 <pr+0x18>
  printf("panic: ");
    80005d70:	00003517          	auipc	a0,0x3
    80005d74:	ac850513          	addi	a0,a0,-1336 # 80008838 <syscalls+0x448>
    80005d78:	00000097          	auipc	ra,0x0
    80005d7c:	02e080e7          	jalr	46(ra) # 80005da6 <printf>
  printf(s);
    80005d80:	8526                	mv	a0,s1
    80005d82:	00000097          	auipc	ra,0x0
    80005d86:	024080e7          	jalr	36(ra) # 80005da6 <printf>
  printf("\n");
    80005d8a:	00002517          	auipc	a0,0x2
    80005d8e:	2be50513          	addi	a0,a0,702 # 80008048 <etext+0x48>
    80005d92:	00000097          	auipc	ra,0x0
    80005d96:	014080e7          	jalr	20(ra) # 80005da6 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005d9a:	4785                	li	a5,1
    80005d9c:	00003717          	auipc	a4,0x3
    80005da0:	baf72023          	sw	a5,-1120(a4) # 8000893c <panicked>
  for(;;)
    80005da4:	a001                	j	80005da4 <panic+0x48>

0000000080005da6 <printf>:
{
    80005da6:	7131                	addi	sp,sp,-192
    80005da8:	fc86                	sd	ra,120(sp)
    80005daa:	f8a2                	sd	s0,112(sp)
    80005dac:	f4a6                	sd	s1,104(sp)
    80005dae:	f0ca                	sd	s2,96(sp)
    80005db0:	ecce                	sd	s3,88(sp)
    80005db2:	e8d2                	sd	s4,80(sp)
    80005db4:	e4d6                	sd	s5,72(sp)
    80005db6:	e0da                	sd	s6,64(sp)
    80005db8:	fc5e                	sd	s7,56(sp)
    80005dba:	f862                	sd	s8,48(sp)
    80005dbc:	f466                	sd	s9,40(sp)
    80005dbe:	f06a                	sd	s10,32(sp)
    80005dc0:	ec6e                	sd	s11,24(sp)
    80005dc2:	0100                	addi	s0,sp,128
    80005dc4:	8a2a                	mv	s4,a0
    80005dc6:	e40c                	sd	a1,8(s0)
    80005dc8:	e810                	sd	a2,16(s0)
    80005dca:	ec14                	sd	a3,24(s0)
    80005dcc:	f018                	sd	a4,32(s0)
    80005dce:	f41c                	sd	a5,40(s0)
    80005dd0:	03043823          	sd	a6,48(s0)
    80005dd4:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005dd8:	0001cd97          	auipc	s11,0x1c
    80005ddc:	1a8dad83          	lw	s11,424(s11) # 80021f80 <pr+0x18>
  if(locking)
    80005de0:	020d9b63          	bnez	s11,80005e16 <printf+0x70>
  if (fmt == 0)
    80005de4:	040a0263          	beqz	s4,80005e28 <printf+0x82>
  va_start(ap, fmt);
    80005de8:	00840793          	addi	a5,s0,8
    80005dec:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005df0:	000a4503          	lbu	a0,0(s4)
    80005df4:	14050f63          	beqz	a0,80005f52 <printf+0x1ac>
    80005df8:	4981                	li	s3,0
    if(c != '%'){
    80005dfa:	02500a93          	li	s5,37
    switch(c){
    80005dfe:	07000b93          	li	s7,112
  consputc('x');
    80005e02:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e04:	00003b17          	auipc	s6,0x3
    80005e08:	a5cb0b13          	addi	s6,s6,-1444 # 80008860 <digits>
    switch(c){
    80005e0c:	07300c93          	li	s9,115
    80005e10:	06400c13          	li	s8,100
    80005e14:	a82d                	j	80005e4e <printf+0xa8>
    acquire(&pr.lock);
    80005e16:	0001c517          	auipc	a0,0x1c
    80005e1a:	15250513          	addi	a0,a0,338 # 80021f68 <pr>
    80005e1e:	00000097          	auipc	ra,0x0
    80005e22:	476080e7          	jalr	1142(ra) # 80006294 <acquire>
    80005e26:	bf7d                	j	80005de4 <printf+0x3e>
    panic("null fmt");
    80005e28:	00003517          	auipc	a0,0x3
    80005e2c:	a2050513          	addi	a0,a0,-1504 # 80008848 <syscalls+0x458>
    80005e30:	00000097          	auipc	ra,0x0
    80005e34:	f2c080e7          	jalr	-212(ra) # 80005d5c <panic>
      consputc(c);
    80005e38:	00000097          	auipc	ra,0x0
    80005e3c:	c60080e7          	jalr	-928(ra) # 80005a98 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e40:	2985                	addiw	s3,s3,1
    80005e42:	013a07b3          	add	a5,s4,s3
    80005e46:	0007c503          	lbu	a0,0(a5)
    80005e4a:	10050463          	beqz	a0,80005f52 <printf+0x1ac>
    if(c != '%'){
    80005e4e:	ff5515e3          	bne	a0,s5,80005e38 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e52:	2985                	addiw	s3,s3,1
    80005e54:	013a07b3          	add	a5,s4,s3
    80005e58:	0007c783          	lbu	a5,0(a5)
    80005e5c:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005e60:	cbed                	beqz	a5,80005f52 <printf+0x1ac>
    switch(c){
    80005e62:	05778a63          	beq	a5,s7,80005eb6 <printf+0x110>
    80005e66:	02fbf663          	bgeu	s7,a5,80005e92 <printf+0xec>
    80005e6a:	09978863          	beq	a5,s9,80005efa <printf+0x154>
    80005e6e:	07800713          	li	a4,120
    80005e72:	0ce79563          	bne	a5,a4,80005f3c <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005e76:	f8843783          	ld	a5,-120(s0)
    80005e7a:	00878713          	addi	a4,a5,8
    80005e7e:	f8e43423          	sd	a4,-120(s0)
    80005e82:	4605                	li	a2,1
    80005e84:	85ea                	mv	a1,s10
    80005e86:	4388                	lw	a0,0(a5)
    80005e88:	00000097          	auipc	ra,0x0
    80005e8c:	e30080e7          	jalr	-464(ra) # 80005cb8 <printint>
      break;
    80005e90:	bf45                	j	80005e40 <printf+0x9a>
    switch(c){
    80005e92:	09578f63          	beq	a5,s5,80005f30 <printf+0x18a>
    80005e96:	0b879363          	bne	a5,s8,80005f3c <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005e9a:	f8843783          	ld	a5,-120(s0)
    80005e9e:	00878713          	addi	a4,a5,8
    80005ea2:	f8e43423          	sd	a4,-120(s0)
    80005ea6:	4605                	li	a2,1
    80005ea8:	45a9                	li	a1,10
    80005eaa:	4388                	lw	a0,0(a5)
    80005eac:	00000097          	auipc	ra,0x0
    80005eb0:	e0c080e7          	jalr	-500(ra) # 80005cb8 <printint>
      break;
    80005eb4:	b771                	j	80005e40 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005eb6:	f8843783          	ld	a5,-120(s0)
    80005eba:	00878713          	addi	a4,a5,8
    80005ebe:	f8e43423          	sd	a4,-120(s0)
    80005ec2:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005ec6:	03000513          	li	a0,48
    80005eca:	00000097          	auipc	ra,0x0
    80005ece:	bce080e7          	jalr	-1074(ra) # 80005a98 <consputc>
  consputc('x');
    80005ed2:	07800513          	li	a0,120
    80005ed6:	00000097          	auipc	ra,0x0
    80005eda:	bc2080e7          	jalr	-1086(ra) # 80005a98 <consputc>
    80005ede:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ee0:	03c95793          	srli	a5,s2,0x3c
    80005ee4:	97da                	add	a5,a5,s6
    80005ee6:	0007c503          	lbu	a0,0(a5)
    80005eea:	00000097          	auipc	ra,0x0
    80005eee:	bae080e7          	jalr	-1106(ra) # 80005a98 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005ef2:	0912                	slli	s2,s2,0x4
    80005ef4:	34fd                	addiw	s1,s1,-1
    80005ef6:	f4ed                	bnez	s1,80005ee0 <printf+0x13a>
    80005ef8:	b7a1                	j	80005e40 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005efa:	f8843783          	ld	a5,-120(s0)
    80005efe:	00878713          	addi	a4,a5,8
    80005f02:	f8e43423          	sd	a4,-120(s0)
    80005f06:	6384                	ld	s1,0(a5)
    80005f08:	cc89                	beqz	s1,80005f22 <printf+0x17c>
      for(; *s; s++)
    80005f0a:	0004c503          	lbu	a0,0(s1)
    80005f0e:	d90d                	beqz	a0,80005e40 <printf+0x9a>
        consputc(*s);
    80005f10:	00000097          	auipc	ra,0x0
    80005f14:	b88080e7          	jalr	-1144(ra) # 80005a98 <consputc>
      for(; *s; s++)
    80005f18:	0485                	addi	s1,s1,1
    80005f1a:	0004c503          	lbu	a0,0(s1)
    80005f1e:	f96d                	bnez	a0,80005f10 <printf+0x16a>
    80005f20:	b705                	j	80005e40 <printf+0x9a>
        s = "(null)";
    80005f22:	00003497          	auipc	s1,0x3
    80005f26:	91e48493          	addi	s1,s1,-1762 # 80008840 <syscalls+0x450>
      for(; *s; s++)
    80005f2a:	02800513          	li	a0,40
    80005f2e:	b7cd                	j	80005f10 <printf+0x16a>
      consputc('%');
    80005f30:	8556                	mv	a0,s5
    80005f32:	00000097          	auipc	ra,0x0
    80005f36:	b66080e7          	jalr	-1178(ra) # 80005a98 <consputc>
      break;
    80005f3a:	b719                	j	80005e40 <printf+0x9a>
      consputc('%');
    80005f3c:	8556                	mv	a0,s5
    80005f3e:	00000097          	auipc	ra,0x0
    80005f42:	b5a080e7          	jalr	-1190(ra) # 80005a98 <consputc>
      consputc(c);
    80005f46:	8526                	mv	a0,s1
    80005f48:	00000097          	auipc	ra,0x0
    80005f4c:	b50080e7          	jalr	-1200(ra) # 80005a98 <consputc>
      break;
    80005f50:	bdc5                	j	80005e40 <printf+0x9a>
  if(locking)
    80005f52:	020d9163          	bnez	s11,80005f74 <printf+0x1ce>
}
    80005f56:	70e6                	ld	ra,120(sp)
    80005f58:	7446                	ld	s0,112(sp)
    80005f5a:	74a6                	ld	s1,104(sp)
    80005f5c:	7906                	ld	s2,96(sp)
    80005f5e:	69e6                	ld	s3,88(sp)
    80005f60:	6a46                	ld	s4,80(sp)
    80005f62:	6aa6                	ld	s5,72(sp)
    80005f64:	6b06                	ld	s6,64(sp)
    80005f66:	7be2                	ld	s7,56(sp)
    80005f68:	7c42                	ld	s8,48(sp)
    80005f6a:	7ca2                	ld	s9,40(sp)
    80005f6c:	7d02                	ld	s10,32(sp)
    80005f6e:	6de2                	ld	s11,24(sp)
    80005f70:	6129                	addi	sp,sp,192
    80005f72:	8082                	ret
    release(&pr.lock);
    80005f74:	0001c517          	auipc	a0,0x1c
    80005f78:	ff450513          	addi	a0,a0,-12 # 80021f68 <pr>
    80005f7c:	00000097          	auipc	ra,0x0
    80005f80:	3cc080e7          	jalr	972(ra) # 80006348 <release>
}
    80005f84:	bfc9                	j	80005f56 <printf+0x1b0>

0000000080005f86 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005f86:	1101                	addi	sp,sp,-32
    80005f88:	ec06                	sd	ra,24(sp)
    80005f8a:	e822                	sd	s0,16(sp)
    80005f8c:	e426                	sd	s1,8(sp)
    80005f8e:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005f90:	0001c497          	auipc	s1,0x1c
    80005f94:	fd848493          	addi	s1,s1,-40 # 80021f68 <pr>
    80005f98:	00003597          	auipc	a1,0x3
    80005f9c:	8c058593          	addi	a1,a1,-1856 # 80008858 <syscalls+0x468>
    80005fa0:	8526                	mv	a0,s1
    80005fa2:	00000097          	auipc	ra,0x0
    80005fa6:	262080e7          	jalr	610(ra) # 80006204 <initlock>
  pr.locking = 1;
    80005faa:	4785                	li	a5,1
    80005fac:	cc9c                	sw	a5,24(s1)
}
    80005fae:	60e2                	ld	ra,24(sp)
    80005fb0:	6442                	ld	s0,16(sp)
    80005fb2:	64a2                	ld	s1,8(sp)
    80005fb4:	6105                	addi	sp,sp,32
    80005fb6:	8082                	ret

0000000080005fb8 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005fb8:	1141                	addi	sp,sp,-16
    80005fba:	e406                	sd	ra,8(sp)
    80005fbc:	e022                	sd	s0,0(sp)
    80005fbe:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005fc0:	100007b7          	lui	a5,0x10000
    80005fc4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005fc8:	f8000713          	li	a4,-128
    80005fcc:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005fd0:	470d                	li	a4,3
    80005fd2:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005fd6:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005fda:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005fde:	469d                	li	a3,7
    80005fe0:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005fe4:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005fe8:	00003597          	auipc	a1,0x3
    80005fec:	89058593          	addi	a1,a1,-1904 # 80008878 <digits+0x18>
    80005ff0:	0001c517          	auipc	a0,0x1c
    80005ff4:	f9850513          	addi	a0,a0,-104 # 80021f88 <uart_tx_lock>
    80005ff8:	00000097          	auipc	ra,0x0
    80005ffc:	20c080e7          	jalr	524(ra) # 80006204 <initlock>
}
    80006000:	60a2                	ld	ra,8(sp)
    80006002:	6402                	ld	s0,0(sp)
    80006004:	0141                	addi	sp,sp,16
    80006006:	8082                	ret

0000000080006008 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006008:	1101                	addi	sp,sp,-32
    8000600a:	ec06                	sd	ra,24(sp)
    8000600c:	e822                	sd	s0,16(sp)
    8000600e:	e426                	sd	s1,8(sp)
    80006010:	1000                	addi	s0,sp,32
    80006012:	84aa                	mv	s1,a0
  push_off();
    80006014:	00000097          	auipc	ra,0x0
    80006018:	234080e7          	jalr	564(ra) # 80006248 <push_off>

  if(panicked){
    8000601c:	00003797          	auipc	a5,0x3
    80006020:	9207a783          	lw	a5,-1760(a5) # 8000893c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006024:	10000737          	lui	a4,0x10000
  if(panicked){
    80006028:	c391                	beqz	a5,8000602c <uartputc_sync+0x24>
    for(;;)
    8000602a:	a001                	j	8000602a <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000602c:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006030:	0207f793          	andi	a5,a5,32
    80006034:	dfe5                	beqz	a5,8000602c <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006036:	0ff4f513          	zext.b	a0,s1
    8000603a:	100007b7          	lui	a5,0x10000
    8000603e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006042:	00000097          	auipc	ra,0x0
    80006046:	2a6080e7          	jalr	678(ra) # 800062e8 <pop_off>
}
    8000604a:	60e2                	ld	ra,24(sp)
    8000604c:	6442                	ld	s0,16(sp)
    8000604e:	64a2                	ld	s1,8(sp)
    80006050:	6105                	addi	sp,sp,32
    80006052:	8082                	ret

0000000080006054 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006054:	00003797          	auipc	a5,0x3
    80006058:	8ec7b783          	ld	a5,-1812(a5) # 80008940 <uart_tx_r>
    8000605c:	00003717          	auipc	a4,0x3
    80006060:	8ec73703          	ld	a4,-1812(a4) # 80008948 <uart_tx_w>
    80006064:	06f70a63          	beq	a4,a5,800060d8 <uartstart+0x84>
{
    80006068:	7139                	addi	sp,sp,-64
    8000606a:	fc06                	sd	ra,56(sp)
    8000606c:	f822                	sd	s0,48(sp)
    8000606e:	f426                	sd	s1,40(sp)
    80006070:	f04a                	sd	s2,32(sp)
    80006072:	ec4e                	sd	s3,24(sp)
    80006074:	e852                	sd	s4,16(sp)
    80006076:	e456                	sd	s5,8(sp)
    80006078:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000607a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000607e:	0001ca17          	auipc	s4,0x1c
    80006082:	f0aa0a13          	addi	s4,s4,-246 # 80021f88 <uart_tx_lock>
    uart_tx_r += 1;
    80006086:	00003497          	auipc	s1,0x3
    8000608a:	8ba48493          	addi	s1,s1,-1862 # 80008940 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000608e:	00003997          	auipc	s3,0x3
    80006092:	8ba98993          	addi	s3,s3,-1862 # 80008948 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006096:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000609a:	02077713          	andi	a4,a4,32
    8000609e:	c705                	beqz	a4,800060c6 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060a0:	01f7f713          	andi	a4,a5,31
    800060a4:	9752                	add	a4,a4,s4
    800060a6:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800060aa:	0785                	addi	a5,a5,1
    800060ac:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800060ae:	8526                	mv	a0,s1
    800060b0:	ffffb097          	auipc	ra,0xffffb
    800060b4:	650080e7          	jalr	1616(ra) # 80001700 <wakeup>
    
    WriteReg(THR, c);
    800060b8:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800060bc:	609c                	ld	a5,0(s1)
    800060be:	0009b703          	ld	a4,0(s3)
    800060c2:	fcf71ae3          	bne	a4,a5,80006096 <uartstart+0x42>
  }
}
    800060c6:	70e2                	ld	ra,56(sp)
    800060c8:	7442                	ld	s0,48(sp)
    800060ca:	74a2                	ld	s1,40(sp)
    800060cc:	7902                	ld	s2,32(sp)
    800060ce:	69e2                	ld	s3,24(sp)
    800060d0:	6a42                	ld	s4,16(sp)
    800060d2:	6aa2                	ld	s5,8(sp)
    800060d4:	6121                	addi	sp,sp,64
    800060d6:	8082                	ret
    800060d8:	8082                	ret

00000000800060da <uartputc>:
{
    800060da:	7179                	addi	sp,sp,-48
    800060dc:	f406                	sd	ra,40(sp)
    800060de:	f022                	sd	s0,32(sp)
    800060e0:	ec26                	sd	s1,24(sp)
    800060e2:	e84a                	sd	s2,16(sp)
    800060e4:	e44e                	sd	s3,8(sp)
    800060e6:	e052                	sd	s4,0(sp)
    800060e8:	1800                	addi	s0,sp,48
    800060ea:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800060ec:	0001c517          	auipc	a0,0x1c
    800060f0:	e9c50513          	addi	a0,a0,-356 # 80021f88 <uart_tx_lock>
    800060f4:	00000097          	auipc	ra,0x0
    800060f8:	1a0080e7          	jalr	416(ra) # 80006294 <acquire>
  if(panicked){
    800060fc:	00003797          	auipc	a5,0x3
    80006100:	8407a783          	lw	a5,-1984(a5) # 8000893c <panicked>
    80006104:	e7c9                	bnez	a5,8000618e <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006106:	00003717          	auipc	a4,0x3
    8000610a:	84273703          	ld	a4,-1982(a4) # 80008948 <uart_tx_w>
    8000610e:	00003797          	auipc	a5,0x3
    80006112:	8327b783          	ld	a5,-1998(a5) # 80008940 <uart_tx_r>
    80006116:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000611a:	0001c997          	auipc	s3,0x1c
    8000611e:	e6e98993          	addi	s3,s3,-402 # 80021f88 <uart_tx_lock>
    80006122:	00003497          	auipc	s1,0x3
    80006126:	81e48493          	addi	s1,s1,-2018 # 80008940 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000612a:	00003917          	auipc	s2,0x3
    8000612e:	81e90913          	addi	s2,s2,-2018 # 80008948 <uart_tx_w>
    80006132:	00e79f63          	bne	a5,a4,80006150 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006136:	85ce                	mv	a1,s3
    80006138:	8526                	mv	a0,s1
    8000613a:	ffffb097          	auipc	ra,0xffffb
    8000613e:	562080e7          	jalr	1378(ra) # 8000169c <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006142:	00093703          	ld	a4,0(s2)
    80006146:	609c                	ld	a5,0(s1)
    80006148:	02078793          	addi	a5,a5,32
    8000614c:	fee785e3          	beq	a5,a4,80006136 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006150:	0001c497          	auipc	s1,0x1c
    80006154:	e3848493          	addi	s1,s1,-456 # 80021f88 <uart_tx_lock>
    80006158:	01f77793          	andi	a5,a4,31
    8000615c:	97a6                	add	a5,a5,s1
    8000615e:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006162:	0705                	addi	a4,a4,1
    80006164:	00002797          	auipc	a5,0x2
    80006168:	7ee7b223          	sd	a4,2020(a5) # 80008948 <uart_tx_w>
  uartstart();
    8000616c:	00000097          	auipc	ra,0x0
    80006170:	ee8080e7          	jalr	-280(ra) # 80006054 <uartstart>
  release(&uart_tx_lock);
    80006174:	8526                	mv	a0,s1
    80006176:	00000097          	auipc	ra,0x0
    8000617a:	1d2080e7          	jalr	466(ra) # 80006348 <release>
}
    8000617e:	70a2                	ld	ra,40(sp)
    80006180:	7402                	ld	s0,32(sp)
    80006182:	64e2                	ld	s1,24(sp)
    80006184:	6942                	ld	s2,16(sp)
    80006186:	69a2                	ld	s3,8(sp)
    80006188:	6a02                	ld	s4,0(sp)
    8000618a:	6145                	addi	sp,sp,48
    8000618c:	8082                	ret
    for(;;)
    8000618e:	a001                	j	8000618e <uartputc+0xb4>

0000000080006190 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006190:	1141                	addi	sp,sp,-16
    80006192:	e422                	sd	s0,8(sp)
    80006194:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006196:	100007b7          	lui	a5,0x10000
    8000619a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000619e:	8b85                	andi	a5,a5,1
    800061a0:	cb81                	beqz	a5,800061b0 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800061a2:	100007b7          	lui	a5,0x10000
    800061a6:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800061aa:	6422                	ld	s0,8(sp)
    800061ac:	0141                	addi	sp,sp,16
    800061ae:	8082                	ret
    return -1;
    800061b0:	557d                	li	a0,-1
    800061b2:	bfe5                	j	800061aa <uartgetc+0x1a>

00000000800061b4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800061b4:	1101                	addi	sp,sp,-32
    800061b6:	ec06                	sd	ra,24(sp)
    800061b8:	e822                	sd	s0,16(sp)
    800061ba:	e426                	sd	s1,8(sp)
    800061bc:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800061be:	54fd                	li	s1,-1
    800061c0:	a029                	j	800061ca <uartintr+0x16>
      break;
    consoleintr(c);
    800061c2:	00000097          	auipc	ra,0x0
    800061c6:	918080e7          	jalr	-1768(ra) # 80005ada <consoleintr>
    int c = uartgetc();
    800061ca:	00000097          	auipc	ra,0x0
    800061ce:	fc6080e7          	jalr	-58(ra) # 80006190 <uartgetc>
    if(c == -1)
    800061d2:	fe9518e3          	bne	a0,s1,800061c2 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800061d6:	0001c497          	auipc	s1,0x1c
    800061da:	db248493          	addi	s1,s1,-590 # 80021f88 <uart_tx_lock>
    800061de:	8526                	mv	a0,s1
    800061e0:	00000097          	auipc	ra,0x0
    800061e4:	0b4080e7          	jalr	180(ra) # 80006294 <acquire>
  uartstart();
    800061e8:	00000097          	auipc	ra,0x0
    800061ec:	e6c080e7          	jalr	-404(ra) # 80006054 <uartstart>
  release(&uart_tx_lock);
    800061f0:	8526                	mv	a0,s1
    800061f2:	00000097          	auipc	ra,0x0
    800061f6:	156080e7          	jalr	342(ra) # 80006348 <release>
}
    800061fa:	60e2                	ld	ra,24(sp)
    800061fc:	6442                	ld	s0,16(sp)
    800061fe:	64a2                	ld	s1,8(sp)
    80006200:	6105                	addi	sp,sp,32
    80006202:	8082                	ret

0000000080006204 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006204:	1141                	addi	sp,sp,-16
    80006206:	e422                	sd	s0,8(sp)
    80006208:	0800                	addi	s0,sp,16
  lk->name = name;
    8000620a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000620c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006210:	00053823          	sd	zero,16(a0)
}
    80006214:	6422                	ld	s0,8(sp)
    80006216:	0141                	addi	sp,sp,16
    80006218:	8082                	ret

000000008000621a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000621a:	411c                	lw	a5,0(a0)
    8000621c:	e399                	bnez	a5,80006222 <holding+0x8>
    8000621e:	4501                	li	a0,0
  return r;
}
    80006220:	8082                	ret
{
    80006222:	1101                	addi	sp,sp,-32
    80006224:	ec06                	sd	ra,24(sp)
    80006226:	e822                	sd	s0,16(sp)
    80006228:	e426                	sd	s1,8(sp)
    8000622a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000622c:	6904                	ld	s1,16(a0)
    8000622e:	ffffb097          	auipc	ra,0xffffb
    80006232:	cee080e7          	jalr	-786(ra) # 80000f1c <mycpu>
    80006236:	40a48533          	sub	a0,s1,a0
    8000623a:	00153513          	seqz	a0,a0
}
    8000623e:	60e2                	ld	ra,24(sp)
    80006240:	6442                	ld	s0,16(sp)
    80006242:	64a2                	ld	s1,8(sp)
    80006244:	6105                	addi	sp,sp,32
    80006246:	8082                	ret

0000000080006248 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006248:	1101                	addi	sp,sp,-32
    8000624a:	ec06                	sd	ra,24(sp)
    8000624c:	e822                	sd	s0,16(sp)
    8000624e:	e426                	sd	s1,8(sp)
    80006250:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006252:	100024f3          	csrr	s1,sstatus
    80006256:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000625a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000625c:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006260:	ffffb097          	auipc	ra,0xffffb
    80006264:	cbc080e7          	jalr	-836(ra) # 80000f1c <mycpu>
    80006268:	5d3c                	lw	a5,120(a0)
    8000626a:	cf89                	beqz	a5,80006284 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000626c:	ffffb097          	auipc	ra,0xffffb
    80006270:	cb0080e7          	jalr	-848(ra) # 80000f1c <mycpu>
    80006274:	5d3c                	lw	a5,120(a0)
    80006276:	2785                	addiw	a5,a5,1
    80006278:	dd3c                	sw	a5,120(a0)
}
    8000627a:	60e2                	ld	ra,24(sp)
    8000627c:	6442                	ld	s0,16(sp)
    8000627e:	64a2                	ld	s1,8(sp)
    80006280:	6105                	addi	sp,sp,32
    80006282:	8082                	ret
    mycpu()->intena = old;
    80006284:	ffffb097          	auipc	ra,0xffffb
    80006288:	c98080e7          	jalr	-872(ra) # 80000f1c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000628c:	8085                	srli	s1,s1,0x1
    8000628e:	8885                	andi	s1,s1,1
    80006290:	dd64                	sw	s1,124(a0)
    80006292:	bfe9                	j	8000626c <push_off+0x24>

0000000080006294 <acquire>:
{
    80006294:	1101                	addi	sp,sp,-32
    80006296:	ec06                	sd	ra,24(sp)
    80006298:	e822                	sd	s0,16(sp)
    8000629a:	e426                	sd	s1,8(sp)
    8000629c:	1000                	addi	s0,sp,32
    8000629e:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800062a0:	00000097          	auipc	ra,0x0
    800062a4:	fa8080e7          	jalr	-88(ra) # 80006248 <push_off>
  if(holding(lk))
    800062a8:	8526                	mv	a0,s1
    800062aa:	00000097          	auipc	ra,0x0
    800062ae:	f70080e7          	jalr	-144(ra) # 8000621a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062b2:	4705                	li	a4,1
  if(holding(lk))
    800062b4:	e115                	bnez	a0,800062d8 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062b6:	87ba                	mv	a5,a4
    800062b8:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800062bc:	2781                	sext.w	a5,a5
    800062be:	ffe5                	bnez	a5,800062b6 <acquire+0x22>
  __sync_synchronize();
    800062c0:	0ff0000f          	fence
  lk->cpu = mycpu();
    800062c4:	ffffb097          	auipc	ra,0xffffb
    800062c8:	c58080e7          	jalr	-936(ra) # 80000f1c <mycpu>
    800062cc:	e888                	sd	a0,16(s1)
}
    800062ce:	60e2                	ld	ra,24(sp)
    800062d0:	6442                	ld	s0,16(sp)
    800062d2:	64a2                	ld	s1,8(sp)
    800062d4:	6105                	addi	sp,sp,32
    800062d6:	8082                	ret
    panic("acquire");
    800062d8:	00002517          	auipc	a0,0x2
    800062dc:	5a850513          	addi	a0,a0,1448 # 80008880 <digits+0x20>
    800062e0:	00000097          	auipc	ra,0x0
    800062e4:	a7c080e7          	jalr	-1412(ra) # 80005d5c <panic>

00000000800062e8 <pop_off>:

void
pop_off(void)
{
    800062e8:	1141                	addi	sp,sp,-16
    800062ea:	e406                	sd	ra,8(sp)
    800062ec:	e022                	sd	s0,0(sp)
    800062ee:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800062f0:	ffffb097          	auipc	ra,0xffffb
    800062f4:	c2c080e7          	jalr	-980(ra) # 80000f1c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062f8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800062fc:	8b89                	andi	a5,a5,2
  if(intr_get())
    800062fe:	e78d                	bnez	a5,80006328 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006300:	5d3c                	lw	a5,120(a0)
    80006302:	02f05b63          	blez	a5,80006338 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006306:	37fd                	addiw	a5,a5,-1
    80006308:	0007871b          	sext.w	a4,a5
    8000630c:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000630e:	eb09                	bnez	a4,80006320 <pop_off+0x38>
    80006310:	5d7c                	lw	a5,124(a0)
    80006312:	c799                	beqz	a5,80006320 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006314:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006318:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000631c:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006320:	60a2                	ld	ra,8(sp)
    80006322:	6402                	ld	s0,0(sp)
    80006324:	0141                	addi	sp,sp,16
    80006326:	8082                	ret
    panic("pop_off - interruptible");
    80006328:	00002517          	auipc	a0,0x2
    8000632c:	56050513          	addi	a0,a0,1376 # 80008888 <digits+0x28>
    80006330:	00000097          	auipc	ra,0x0
    80006334:	a2c080e7          	jalr	-1492(ra) # 80005d5c <panic>
    panic("pop_off");
    80006338:	00002517          	auipc	a0,0x2
    8000633c:	56850513          	addi	a0,a0,1384 # 800088a0 <digits+0x40>
    80006340:	00000097          	auipc	ra,0x0
    80006344:	a1c080e7          	jalr	-1508(ra) # 80005d5c <panic>

0000000080006348 <release>:
{
    80006348:	1101                	addi	sp,sp,-32
    8000634a:	ec06                	sd	ra,24(sp)
    8000634c:	e822                	sd	s0,16(sp)
    8000634e:	e426                	sd	s1,8(sp)
    80006350:	1000                	addi	s0,sp,32
    80006352:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006354:	00000097          	auipc	ra,0x0
    80006358:	ec6080e7          	jalr	-314(ra) # 8000621a <holding>
    8000635c:	c115                	beqz	a0,80006380 <release+0x38>
  lk->cpu = 0;
    8000635e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006362:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006366:	0f50000f          	fence	iorw,ow
    8000636a:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000636e:	00000097          	auipc	ra,0x0
    80006372:	f7a080e7          	jalr	-134(ra) # 800062e8 <pop_off>
}
    80006376:	60e2                	ld	ra,24(sp)
    80006378:	6442                	ld	s0,16(sp)
    8000637a:	64a2                	ld	s1,8(sp)
    8000637c:	6105                	addi	sp,sp,32
    8000637e:	8082                	ret
    panic("release");
    80006380:	00002517          	auipc	a0,0x2
    80006384:	52850513          	addi	a0,a0,1320 # 800088a8 <digits+0x48>
    80006388:	00000097          	auipc	ra,0x0
    8000638c:	9d4080e7          	jalr	-1580(ra) # 80005d5c <panic>
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
