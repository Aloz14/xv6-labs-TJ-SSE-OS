
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	88013103          	ld	sp,-1920(sp) # 80008880 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	2a3050ef          	jal	ra,80005ab8 <start>

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
    80000030:	0002e797          	auipc	a5,0x2e
    80000034:	d1078793          	addi	a5,a5,-752 # 8002dd40 <end>
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
    80000054:	88090913          	addi	s2,s2,-1920 # 800088d0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	44a080e7          	jalr	1098(ra) # 800064a4 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	4ea080e7          	jalr	1258(ra) # 80006558 <release>
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
    8000008e:	ee2080e7          	jalr	-286(ra) # 80005f6c <panic>

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
    800000ee:	00008517          	auipc	a0,0x8
    800000f2:	7e250513          	addi	a0,a0,2018 # 800088d0 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	31e080e7          	jalr	798(ra) # 80006414 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	0002e517          	auipc	a0,0x2e
    80000106:	c3e50513          	addi	a0,a0,-962 # 8002dd40 <end>
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
    80000128:	7ac48493          	addi	s1,s1,1964 # 800088d0 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	376080e7          	jalr	886(ra) # 800064a4 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00008517          	auipc	a0,0x8
    80000140:	79450513          	addi	a0,a0,1940 # 800088d0 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	412080e7          	jalr	1042(ra) # 80006558 <release>

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
    8000016c:	76850513          	addi	a0,a0,1896 # 800088d0 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	3e8080e7          	jalr	1000(ra) # 80006558 <release>
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
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd12c1>
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
    8000032c:	ae6080e7          	jalr	-1306(ra) # 80000e0e <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000330:	00008717          	auipc	a4,0x8
    80000334:	57070713          	addi	a4,a4,1392 # 800088a0 <started>
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
    80000348:	aca080e7          	jalr	-1334(ra) # 80000e0e <cpuid>
    8000034c:	85aa                	mv	a1,a0
    8000034e:	00008517          	auipc	a0,0x8
    80000352:	cea50513          	addi	a0,a0,-790 # 80008038 <etext+0x38>
    80000356:	00006097          	auipc	ra,0x6
    8000035a:	c60080e7          	jalr	-928(ra) # 80005fb6 <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00002097          	auipc	ra,0x2
    8000036a:	810080e7          	jalr	-2032(ra) # 80001b76 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	102080e7          	jalr	258(ra) # 80005470 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	ff4080e7          	jalr	-12(ra) # 8000136a <scheduler>
    consoleinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	afe080e7          	jalr	-1282(ra) # 80005e7c <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	e10080e7          	jalr	-496(ra) # 80006196 <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	c20080e7          	jalr	-992(ra) # 80005fb6 <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	c10080e7          	jalr	-1008(ra) # 80005fb6 <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	c00080e7          	jalr	-1024(ra) # 80005fb6 <printf>
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
    800003da:	984080e7          	jalr	-1660(ra) # 80000d5a <procinit>
    trapinit();      // trap vectors
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	770080e7          	jalr	1904(ra) # 80001b4e <trapinit>
    trapinithart();  // install kernel trap vector
    800003e6:	00001097          	auipc	ra,0x1
    800003ea:	790080e7          	jalr	1936(ra) # 80001b76 <trapinithart>
    plicinit();      // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	06c080e7          	jalr	108(ra) # 8000545a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	07a080e7          	jalr	122(ra) # 80005470 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	fd8080e7          	jalr	-40(ra) # 800023d6 <binit>
    iinit();         // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	678080e7          	jalr	1656(ra) # 80002a7e <iinit>
    fileinit();      // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	61e080e7          	jalr	1566(ra) # 80003a2c <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	162080e7          	jalr	354(ra) # 80005578 <virtio_disk_init>
    userinit();      // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	cf4080e7          	jalr	-780(ra) # 80001112 <userinit>
    __sync_synchronize();
    80000426:	0ff0000f          	fence
    started = 1;
    8000042a:	4785                	li	a5,1
    8000042c:	00008717          	auipc	a4,0x8
    80000430:	46f72a23          	sw	a5,1140(a4) # 800088a0 <started>
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
    80000444:	4687b783          	ld	a5,1128(a5) # 800088a8 <kernel_pagetable>
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
    80000490:	ae0080e7          	jalr	-1312(ra) # 80005f6c <panic>
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
    800004be:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd12b7>
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
    800005b2:	00006097          	auipc	ra,0x6
    800005b6:	9ba080e7          	jalr	-1606(ra) # 80005f6c <panic>
            panic("mappages: remap");
    800005ba:	00008517          	auipc	a0,0x8
    800005be:	aae50513          	addi	a0,a0,-1362 # 80008068 <etext+0x68>
    800005c2:	00006097          	auipc	ra,0x6
    800005c6:	9aa080e7          	jalr	-1622(ra) # 80005f6c <panic>
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
    8000060e:	00006097          	auipc	ra,0x6
    80000612:	95e080e7          	jalr	-1698(ra) # 80005f6c <panic>

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
    800006da:	5ee080e7          	jalr	1518(ra) # 80000cc4 <proc_mapstacks>
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
    80000700:	1aa7b623          	sd	a0,428(a5) # 800088a8 <kernel_pagetable>
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
    8000072c:	8b36                	mv	s6,a3
        panic("uvmunmap: not aligned");

    for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8000072e:	0632                	slli	a2,a2,0xc
    80000730:	00b609b3          	add	s3,a2,a1
        if ((pte = walk(pagetable, a, 0)) == 0)
            panic("uvmunmap: walk");
        if ((*pte & PTE_V) == 0)
            continue;
        if (PTE_FLAGS(*pte) == PTE_V)
    80000734:	4b85                	li	s7,1
    for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80000736:	6a85                	lui	s5,0x1
    80000738:	0535ea63          	bltu	a1,s3,8000078c <uvmunmap+0x80>
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
    8000075a:	00006097          	auipc	ra,0x6
    8000075e:	812080e7          	jalr	-2030(ra) # 80005f6c <panic>
            panic("uvmunmap: walk");
    80000762:	00008517          	auipc	a0,0x8
    80000766:	93650513          	addi	a0,a0,-1738 # 80008098 <etext+0x98>
    8000076a:	00006097          	auipc	ra,0x6
    8000076e:	802080e7          	jalr	-2046(ra) # 80005f6c <panic>
            panic("uvmunmap: not a leaf");
    80000772:	00008517          	auipc	a0,0x8
    80000776:	93650513          	addi	a0,a0,-1738 # 800080a8 <etext+0xa8>
    8000077a:	00005097          	auipc	ra,0x5
    8000077e:	7f2080e7          	jalr	2034(ra) # 80005f6c <panic>
        *pte = 0;
    80000782:	0004b023          	sd	zero,0(s1)
    for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80000786:	9956                	add	s2,s2,s5
    80000788:	fb397ae3          	bgeu	s2,s3,8000073c <uvmunmap+0x30>
        if ((pte = walk(pagetable, a, 0)) == 0)
    8000078c:	4601                	li	a2,0
    8000078e:	85ca                	mv	a1,s2
    80000790:	8552                	mv	a0,s4
    80000792:	00000097          	auipc	ra,0x0
    80000796:	ccc080e7          	jalr	-820(ra) # 8000045e <walk>
    8000079a:	84aa                	mv	s1,a0
    8000079c:	d179                	beqz	a0,80000762 <uvmunmap+0x56>
        if ((*pte & PTE_V) == 0)
    8000079e:	611c                	ld	a5,0(a0)
    800007a0:	0017f713          	andi	a4,a5,1
    800007a4:	d36d                	beqz	a4,80000786 <uvmunmap+0x7a>
        if (PTE_FLAGS(*pte) == PTE_V)
    800007a6:	3ff7f713          	andi	a4,a5,1023
    800007aa:	fd7704e3          	beq	a4,s7,80000772 <uvmunmap+0x66>
        if (do_free) {
    800007ae:	fc0b0ae3          	beqz	s6,80000782 <uvmunmap+0x76>
            uint64 pa = PTE2PA(*pte);
    800007b2:	83a9                	srli	a5,a5,0xa
            kfree((void *)pa);
    800007b4:	00c79513          	slli	a0,a5,0xc
    800007b8:	00000097          	auipc	ra,0x0
    800007bc:	864080e7          	jalr	-1948(ra) # 8000001c <kfree>
    800007c0:	b7c9                	j	80000782 <uvmunmap+0x76>

00000000800007c2 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t uvmcreate()
{
    800007c2:	1101                	addi	sp,sp,-32
    800007c4:	ec06                	sd	ra,24(sp)
    800007c6:	e822                	sd	s0,16(sp)
    800007c8:	e426                	sd	s1,8(sp)
    800007ca:	1000                	addi	s0,sp,32
    pagetable_t pagetable;
    pagetable = (pagetable_t)kalloc();
    800007cc:	00000097          	auipc	ra,0x0
    800007d0:	94e080e7          	jalr	-1714(ra) # 8000011a <kalloc>
    800007d4:	84aa                	mv	s1,a0
    if (pagetable == 0)
    800007d6:	c519                	beqz	a0,800007e4 <uvmcreate+0x22>
        return 0;
    memset(pagetable, 0, PGSIZE);
    800007d8:	6605                	lui	a2,0x1
    800007da:	4581                	li	a1,0
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	99e080e7          	jalr	-1634(ra) # 8000017a <memset>
    return pagetable;
}
    800007e4:	8526                	mv	a0,s1
    800007e6:	60e2                	ld	ra,24(sp)
    800007e8:	6442                	ld	s0,16(sp)
    800007ea:	64a2                	ld	s1,8(sp)
    800007ec:	6105                	addi	sp,sp,32
    800007ee:	8082                	ret

00000000800007f0 <uvmfirst>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800007f0:	7179                	addi	sp,sp,-48
    800007f2:	f406                	sd	ra,40(sp)
    800007f4:	f022                	sd	s0,32(sp)
    800007f6:	ec26                	sd	s1,24(sp)
    800007f8:	e84a                	sd	s2,16(sp)
    800007fa:	e44e                	sd	s3,8(sp)
    800007fc:	e052                	sd	s4,0(sp)
    800007fe:	1800                	addi	s0,sp,48
    char *mem;

    if (sz >= PGSIZE)
    80000800:	6785                	lui	a5,0x1
    80000802:	04f67863          	bgeu	a2,a5,80000852 <uvmfirst+0x62>
    80000806:	8a2a                	mv	s4,a0
    80000808:	89ae                	mv	s3,a1
    8000080a:	84b2                	mv	s1,a2
        panic("uvmfirst: more than a page");
    mem = kalloc();
    8000080c:	00000097          	auipc	ra,0x0
    80000810:	90e080e7          	jalr	-1778(ra) # 8000011a <kalloc>
    80000814:	892a                	mv	s2,a0
    memset(mem, 0, PGSIZE);
    80000816:	6605                	lui	a2,0x1
    80000818:	4581                	li	a1,0
    8000081a:	00000097          	auipc	ra,0x0
    8000081e:	960080e7          	jalr	-1696(ra) # 8000017a <memset>
    mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    80000822:	4779                	li	a4,30
    80000824:	86ca                	mv	a3,s2
    80000826:	6605                	lui	a2,0x1
    80000828:	4581                	li	a1,0
    8000082a:	8552                	mv	a0,s4
    8000082c:	00000097          	auipc	ra,0x0
    80000830:	d1a080e7          	jalr	-742(ra) # 80000546 <mappages>
    memmove(mem, src, sz);
    80000834:	8626                	mv	a2,s1
    80000836:	85ce                	mv	a1,s3
    80000838:	854a                	mv	a0,s2
    8000083a:	00000097          	auipc	ra,0x0
    8000083e:	99c080e7          	jalr	-1636(ra) # 800001d6 <memmove>
}
    80000842:	70a2                	ld	ra,40(sp)
    80000844:	7402                	ld	s0,32(sp)
    80000846:	64e2                	ld	s1,24(sp)
    80000848:	6942                	ld	s2,16(sp)
    8000084a:	69a2                	ld	s3,8(sp)
    8000084c:	6a02                	ld	s4,0(sp)
    8000084e:	6145                	addi	sp,sp,48
    80000850:	8082                	ret
        panic("uvmfirst: more than a page");
    80000852:	00008517          	auipc	a0,0x8
    80000856:	86e50513          	addi	a0,a0,-1938 # 800080c0 <etext+0xc0>
    8000085a:	00005097          	auipc	ra,0x5
    8000085e:	712080e7          	jalr	1810(ra) # 80005f6c <panic>

0000000080000862 <uvmdealloc>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64 uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000862:	1101                	addi	sp,sp,-32
    80000864:	ec06                	sd	ra,24(sp)
    80000866:	e822                	sd	s0,16(sp)
    80000868:	e426                	sd	s1,8(sp)
    8000086a:	1000                	addi	s0,sp,32
    if (newsz >= oldsz)
        return oldsz;
    8000086c:	84ae                	mv	s1,a1
    if (newsz >= oldsz)
    8000086e:	00b67d63          	bgeu	a2,a1,80000888 <uvmdealloc+0x26>
    80000872:	84b2                	mv	s1,a2

    if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    80000874:	6785                	lui	a5,0x1
    80000876:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000878:	00f60733          	add	a4,a2,a5
    8000087c:	76fd                	lui	a3,0xfffff
    8000087e:	8f75                	and	a4,a4,a3
    80000880:	97ae                	add	a5,a5,a1
    80000882:	8ff5                	and	a5,a5,a3
    80000884:	00f76863          	bltu	a4,a5,80000894 <uvmdealloc+0x32>
        int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
        uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    }

    return newsz;
}
    80000888:	8526                	mv	a0,s1
    8000088a:	60e2                	ld	ra,24(sp)
    8000088c:	6442                	ld	s0,16(sp)
    8000088e:	64a2                	ld	s1,8(sp)
    80000890:	6105                	addi	sp,sp,32
    80000892:	8082                	ret
        int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000894:	8f99                	sub	a5,a5,a4
    80000896:	83b1                	srli	a5,a5,0xc
        uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000898:	4685                	li	a3,1
    8000089a:	0007861b          	sext.w	a2,a5
    8000089e:	85ba                	mv	a1,a4
    800008a0:	00000097          	auipc	ra,0x0
    800008a4:	e6c080e7          	jalr	-404(ra) # 8000070c <uvmunmap>
    800008a8:	b7c5                	j	80000888 <uvmdealloc+0x26>

00000000800008aa <uvmalloc>:
    if (newsz < oldsz)
    800008aa:	0ab66563          	bltu	a2,a1,80000954 <uvmalloc+0xaa>
{
    800008ae:	7139                	addi	sp,sp,-64
    800008b0:	fc06                	sd	ra,56(sp)
    800008b2:	f822                	sd	s0,48(sp)
    800008b4:	f426                	sd	s1,40(sp)
    800008b6:	f04a                	sd	s2,32(sp)
    800008b8:	ec4e                	sd	s3,24(sp)
    800008ba:	e852                	sd	s4,16(sp)
    800008bc:	e456                	sd	s5,8(sp)
    800008be:	e05a                	sd	s6,0(sp)
    800008c0:	0080                	addi	s0,sp,64
    800008c2:	8aaa                	mv	s5,a0
    800008c4:	8a32                	mv	s4,a2
    oldsz = PGROUNDUP(oldsz);
    800008c6:	6785                	lui	a5,0x1
    800008c8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008ca:	95be                	add	a1,a1,a5
    800008cc:	77fd                	lui	a5,0xfffff
    800008ce:	00f5f9b3          	and	s3,a1,a5
    for (a = oldsz; a < newsz; a += PGSIZE) {
    800008d2:	08c9f363          	bgeu	s3,a2,80000958 <uvmalloc+0xae>
    800008d6:	894e                	mv	s2,s3
        if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) != 0) {
    800008d8:	0126eb13          	ori	s6,a3,18
        mem = kalloc();
    800008dc:	00000097          	auipc	ra,0x0
    800008e0:	83e080e7          	jalr	-1986(ra) # 8000011a <kalloc>
    800008e4:	84aa                	mv	s1,a0
        if (mem == 0) {
    800008e6:	c51d                	beqz	a0,80000914 <uvmalloc+0x6a>
        memset(mem, 0, PGSIZE);
    800008e8:	6605                	lui	a2,0x1
    800008ea:	4581                	li	a1,0
    800008ec:	00000097          	auipc	ra,0x0
    800008f0:	88e080e7          	jalr	-1906(ra) # 8000017a <memset>
        if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) != 0) {
    800008f4:	875a                	mv	a4,s6
    800008f6:	86a6                	mv	a3,s1
    800008f8:	6605                	lui	a2,0x1
    800008fa:	85ca                	mv	a1,s2
    800008fc:	8556                	mv	a0,s5
    800008fe:	00000097          	auipc	ra,0x0
    80000902:	c48080e7          	jalr	-952(ra) # 80000546 <mappages>
    80000906:	e90d                	bnez	a0,80000938 <uvmalloc+0x8e>
    for (a = oldsz; a < newsz; a += PGSIZE) {
    80000908:	6785                	lui	a5,0x1
    8000090a:	993e                	add	s2,s2,a5
    8000090c:	fd4968e3          	bltu	s2,s4,800008dc <uvmalloc+0x32>
    return newsz;
    80000910:	8552                	mv	a0,s4
    80000912:	a809                	j	80000924 <uvmalloc+0x7a>
            uvmdealloc(pagetable, a, oldsz);
    80000914:	864e                	mv	a2,s3
    80000916:	85ca                	mv	a1,s2
    80000918:	8556                	mv	a0,s5
    8000091a:	00000097          	auipc	ra,0x0
    8000091e:	f48080e7          	jalr	-184(ra) # 80000862 <uvmdealloc>
            return 0;
    80000922:	4501                	li	a0,0
}
    80000924:	70e2                	ld	ra,56(sp)
    80000926:	7442                	ld	s0,48(sp)
    80000928:	74a2                	ld	s1,40(sp)
    8000092a:	7902                	ld	s2,32(sp)
    8000092c:	69e2                	ld	s3,24(sp)
    8000092e:	6a42                	ld	s4,16(sp)
    80000930:	6aa2                	ld	s5,8(sp)
    80000932:	6b02                	ld	s6,0(sp)
    80000934:	6121                	addi	sp,sp,64
    80000936:	8082                	ret
            kfree(mem);
    80000938:	8526                	mv	a0,s1
    8000093a:	fffff097          	auipc	ra,0xfffff
    8000093e:	6e2080e7          	jalr	1762(ra) # 8000001c <kfree>
            uvmdealloc(pagetable, a, oldsz);
    80000942:	864e                	mv	a2,s3
    80000944:	85ca                	mv	a1,s2
    80000946:	8556                	mv	a0,s5
    80000948:	00000097          	auipc	ra,0x0
    8000094c:	f1a080e7          	jalr	-230(ra) # 80000862 <uvmdealloc>
            return 0;
    80000950:	4501                	li	a0,0
    80000952:	bfc9                	j	80000924 <uvmalloc+0x7a>
        return oldsz;
    80000954:	852e                	mv	a0,a1
}
    80000956:	8082                	ret
    return newsz;
    80000958:	8532                	mv	a0,a2
    8000095a:	b7e9                	j	80000924 <uvmalloc+0x7a>

000000008000095c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
    8000095c:	7179                	addi	sp,sp,-48
    8000095e:	f406                	sd	ra,40(sp)
    80000960:	f022                	sd	s0,32(sp)
    80000962:	ec26                	sd	s1,24(sp)
    80000964:	e84a                	sd	s2,16(sp)
    80000966:	e44e                	sd	s3,8(sp)
    80000968:	e052                	sd	s4,0(sp)
    8000096a:	1800                	addi	s0,sp,48
    8000096c:	8a2a                	mv	s4,a0
    // there are 2^9 = 512 PTEs in a page table.
    for (int i = 0; i < 512; i++) {
    8000096e:	84aa                	mv	s1,a0
    80000970:	6905                	lui	s2,0x1
    80000972:	992a                	add	s2,s2,a0
        pte_t pte = pagetable[i];
        if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000974:	4985                	li	s3,1
    80000976:	a829                	j	80000990 <freewalk+0x34>
            // this PTE points to a lower-level page table.
            uint64 child = PTE2PA(pte);
    80000978:	83a9                	srli	a5,a5,0xa
            freewalk((pagetable_t)child);
    8000097a:	00c79513          	slli	a0,a5,0xc
    8000097e:	00000097          	auipc	ra,0x0
    80000982:	fde080e7          	jalr	-34(ra) # 8000095c <freewalk>
            pagetable[i] = 0;
    80000986:	0004b023          	sd	zero,0(s1)
    for (int i = 0; i < 512; i++) {
    8000098a:	04a1                	addi	s1,s1,8
    8000098c:	03248163          	beq	s1,s2,800009ae <freewalk+0x52>
        pte_t pte = pagetable[i];
    80000990:	609c                	ld	a5,0(s1)
        if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000992:	00f7f713          	andi	a4,a5,15
    80000996:	ff3701e3          	beq	a4,s3,80000978 <freewalk+0x1c>
        }
        else if (pte & PTE_V) {
    8000099a:	8b85                	andi	a5,a5,1
    8000099c:	d7fd                	beqz	a5,8000098a <freewalk+0x2e>
            panic("freewalk: leaf");
    8000099e:	00007517          	auipc	a0,0x7
    800009a2:	74250513          	addi	a0,a0,1858 # 800080e0 <etext+0xe0>
    800009a6:	00005097          	auipc	ra,0x5
    800009aa:	5c6080e7          	jalr	1478(ra) # 80005f6c <panic>
        }
    }
    kfree((void *)pagetable);
    800009ae:	8552                	mv	a0,s4
    800009b0:	fffff097          	auipc	ra,0xfffff
    800009b4:	66c080e7          	jalr	1644(ra) # 8000001c <kfree>
}
    800009b8:	70a2                	ld	ra,40(sp)
    800009ba:	7402                	ld	s0,32(sp)
    800009bc:	64e2                	ld	s1,24(sp)
    800009be:	6942                	ld	s2,16(sp)
    800009c0:	69a2                	ld	s3,8(sp)
    800009c2:	6a02                	ld	s4,0(sp)
    800009c4:	6145                	addi	sp,sp,48
    800009c6:	8082                	ret

00000000800009c8 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009c8:	1101                	addi	sp,sp,-32
    800009ca:	ec06                	sd	ra,24(sp)
    800009cc:	e822                	sd	s0,16(sp)
    800009ce:	e426                	sd	s1,8(sp)
    800009d0:	1000                	addi	s0,sp,32
    800009d2:	84aa                	mv	s1,a0
    if (sz > 0)
    800009d4:	e999                	bnez	a1,800009ea <uvmfree+0x22>
        uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    freewalk(pagetable);
    800009d6:	8526                	mv	a0,s1
    800009d8:	00000097          	auipc	ra,0x0
    800009dc:	f84080e7          	jalr	-124(ra) # 8000095c <freewalk>
}
    800009e0:	60e2                	ld	ra,24(sp)
    800009e2:	6442                	ld	s0,16(sp)
    800009e4:	64a2                	ld	s1,8(sp)
    800009e6:	6105                	addi	sp,sp,32
    800009e8:	8082                	ret
        uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    800009ea:	6785                	lui	a5,0x1
    800009ec:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009ee:	95be                	add	a1,a1,a5
    800009f0:	4685                	li	a3,1
    800009f2:	00c5d613          	srli	a2,a1,0xc
    800009f6:	4581                	li	a1,0
    800009f8:	00000097          	auipc	ra,0x0
    800009fc:	d14080e7          	jalr	-748(ra) # 8000070c <uvmunmap>
    80000a00:	bfd9                	j	800009d6 <uvmfree+0xe>

0000000080000a02 <uvmcopy>:
    pte_t *pte;
    uint64 pa, i;
    uint flags;
    char *mem;

    for (i = 0; i < sz; i += PGSIZE) {
    80000a02:	c269                	beqz	a2,80000ac4 <uvmcopy+0xc2>
{
    80000a04:	715d                	addi	sp,sp,-80
    80000a06:	e486                	sd	ra,72(sp)
    80000a08:	e0a2                	sd	s0,64(sp)
    80000a0a:	fc26                	sd	s1,56(sp)
    80000a0c:	f84a                	sd	s2,48(sp)
    80000a0e:	f44e                	sd	s3,40(sp)
    80000a10:	f052                	sd	s4,32(sp)
    80000a12:	ec56                	sd	s5,24(sp)
    80000a14:	e85a                	sd	s6,16(sp)
    80000a16:	e45e                	sd	s7,8(sp)
    80000a18:	0880                	addi	s0,sp,80
    80000a1a:	8aaa                	mv	s5,a0
    80000a1c:	8b2e                	mv	s6,a1
    80000a1e:	8a32                	mv	s4,a2
    for (i = 0; i < sz; i += PGSIZE) {
    80000a20:	4481                	li	s1,0
    80000a22:	a829                	j	80000a3c <uvmcopy+0x3a>
        if ((pte = walk(old, i, 0)) == 0)
            panic("uvmcopy: pte should exist");
    80000a24:	00007517          	auipc	a0,0x7
    80000a28:	6cc50513          	addi	a0,a0,1740 # 800080f0 <etext+0xf0>
    80000a2c:	00005097          	auipc	ra,0x5
    80000a30:	540080e7          	jalr	1344(ra) # 80005f6c <panic>
    for (i = 0; i < sz; i += PGSIZE) {
    80000a34:	6785                	lui	a5,0x1
    80000a36:	94be                	add	s1,s1,a5
    80000a38:	0944f463          	bgeu	s1,s4,80000ac0 <uvmcopy+0xbe>
        if ((pte = walk(old, i, 0)) == 0)
    80000a3c:	4601                	li	a2,0
    80000a3e:	85a6                	mv	a1,s1
    80000a40:	8556                	mv	a0,s5
    80000a42:	00000097          	auipc	ra,0x0
    80000a46:	a1c080e7          	jalr	-1508(ra) # 8000045e <walk>
    80000a4a:	dd69                	beqz	a0,80000a24 <uvmcopy+0x22>
        if ((*pte & PTE_V) == 0)
    80000a4c:	6118                	ld	a4,0(a0)
    80000a4e:	00177793          	andi	a5,a4,1
    80000a52:	d3ed                	beqz	a5,80000a34 <uvmcopy+0x32>
            continue;
        pa = PTE2PA(*pte);
    80000a54:	00a75593          	srli	a1,a4,0xa
    80000a58:	00c59b93          	slli	s7,a1,0xc
        flags = PTE_FLAGS(*pte);
    80000a5c:	3ff77913          	andi	s2,a4,1023
        if ((mem = kalloc()) == 0)
    80000a60:	fffff097          	auipc	ra,0xfffff
    80000a64:	6ba080e7          	jalr	1722(ra) # 8000011a <kalloc>
    80000a68:	89aa                	mv	s3,a0
    80000a6a:	c515                	beqz	a0,80000a96 <uvmcopy+0x94>
            goto err;
        memmove(mem, (char *)pa, PGSIZE);
    80000a6c:	6605                	lui	a2,0x1
    80000a6e:	85de                	mv	a1,s7
    80000a70:	fffff097          	auipc	ra,0xfffff
    80000a74:	766080e7          	jalr	1894(ra) # 800001d6 <memmove>
        if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    80000a78:	874a                	mv	a4,s2
    80000a7a:	86ce                	mv	a3,s3
    80000a7c:	6605                	lui	a2,0x1
    80000a7e:	85a6                	mv	a1,s1
    80000a80:	855a                	mv	a0,s6
    80000a82:	00000097          	auipc	ra,0x0
    80000a86:	ac4080e7          	jalr	-1340(ra) # 80000546 <mappages>
    80000a8a:	d54d                	beqz	a0,80000a34 <uvmcopy+0x32>
            kfree(mem);
    80000a8c:	854e                	mv	a0,s3
    80000a8e:	fffff097          	auipc	ra,0xfffff
    80000a92:	58e080e7          	jalr	1422(ra) # 8000001c <kfree>
        }
    }
    return 0;

err:
    uvmunmap(new, 0, i / PGSIZE, 1);
    80000a96:	4685                	li	a3,1
    80000a98:	00c4d613          	srli	a2,s1,0xc
    80000a9c:	4581                	li	a1,0
    80000a9e:	855a                	mv	a0,s6
    80000aa0:	00000097          	auipc	ra,0x0
    80000aa4:	c6c080e7          	jalr	-916(ra) # 8000070c <uvmunmap>
    return -1;
    80000aa8:	557d                	li	a0,-1
}
    80000aaa:	60a6                	ld	ra,72(sp)
    80000aac:	6406                	ld	s0,64(sp)
    80000aae:	74e2                	ld	s1,56(sp)
    80000ab0:	7942                	ld	s2,48(sp)
    80000ab2:	79a2                	ld	s3,40(sp)
    80000ab4:	7a02                	ld	s4,32(sp)
    80000ab6:	6ae2                	ld	s5,24(sp)
    80000ab8:	6b42                	ld	s6,16(sp)
    80000aba:	6ba2                	ld	s7,8(sp)
    80000abc:	6161                	addi	sp,sp,80
    80000abe:	8082                	ret
    return 0;
    80000ac0:	4501                	li	a0,0
    80000ac2:	b7e5                	j	80000aaa <uvmcopy+0xa8>
    80000ac4:	4501                	li	a0,0
}
    80000ac6:	8082                	ret

0000000080000ac8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ac8:	1141                	addi	sp,sp,-16
    80000aca:	e406                	sd	ra,8(sp)
    80000acc:	e022                	sd	s0,0(sp)
    80000ace:	0800                	addi	s0,sp,16
    pte_t *pte;

    pte = walk(pagetable, va, 0);
    80000ad0:	4601                	li	a2,0
    80000ad2:	00000097          	auipc	ra,0x0
    80000ad6:	98c080e7          	jalr	-1652(ra) # 8000045e <walk>
    if (pte == 0)
    80000ada:	c901                	beqz	a0,80000aea <uvmclear+0x22>
        panic("uvmclear");
    *pte &= ~PTE_U;
    80000adc:	611c                	ld	a5,0(a0)
    80000ade:	9bbd                	andi	a5,a5,-17
    80000ae0:	e11c                	sd	a5,0(a0)
}
    80000ae2:	60a2                	ld	ra,8(sp)
    80000ae4:	6402                	ld	s0,0(sp)
    80000ae6:	0141                	addi	sp,sp,16
    80000ae8:	8082                	ret
        panic("uvmclear");
    80000aea:	00007517          	auipc	a0,0x7
    80000aee:	62650513          	addi	a0,a0,1574 # 80008110 <etext+0x110>
    80000af2:	00005097          	auipc	ra,0x5
    80000af6:	47a080e7          	jalr	1146(ra) # 80005f6c <panic>

0000000080000afa <copyout>:
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
    uint64 n, va0, pa0;

    while (len > 0) {
    80000afa:	c6bd                	beqz	a3,80000b68 <copyout+0x6e>
{
    80000afc:	715d                	addi	sp,sp,-80
    80000afe:	e486                	sd	ra,72(sp)
    80000b00:	e0a2                	sd	s0,64(sp)
    80000b02:	fc26                	sd	s1,56(sp)
    80000b04:	f84a                	sd	s2,48(sp)
    80000b06:	f44e                	sd	s3,40(sp)
    80000b08:	f052                	sd	s4,32(sp)
    80000b0a:	ec56                	sd	s5,24(sp)
    80000b0c:	e85a                	sd	s6,16(sp)
    80000b0e:	e45e                	sd	s7,8(sp)
    80000b10:	e062                	sd	s8,0(sp)
    80000b12:	0880                	addi	s0,sp,80
    80000b14:	8b2a                	mv	s6,a0
    80000b16:	8c2e                	mv	s8,a1
    80000b18:	8a32                	mv	s4,a2
    80000b1a:	89b6                	mv	s3,a3
        va0 = PGROUNDDOWN(dstva);
    80000b1c:	7bfd                	lui	s7,0xfffff
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0)
            return -1;
        n = PGSIZE - (dstva - va0);
    80000b1e:	6a85                	lui	s5,0x1
    80000b20:	a015                	j	80000b44 <copyout+0x4a>
        if (n > len)
            n = len;
        memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b22:	9562                	add	a0,a0,s8
    80000b24:	0004861b          	sext.w	a2,s1
    80000b28:	85d2                	mv	a1,s4
    80000b2a:	41250533          	sub	a0,a0,s2
    80000b2e:	fffff097          	auipc	ra,0xfffff
    80000b32:	6a8080e7          	jalr	1704(ra) # 800001d6 <memmove>

        len -= n;
    80000b36:	409989b3          	sub	s3,s3,s1
        src += n;
    80000b3a:	9a26                	add	s4,s4,s1
        dstva = va0 + PGSIZE;
    80000b3c:	01590c33          	add	s8,s2,s5
    while (len > 0) {
    80000b40:	02098263          	beqz	s3,80000b64 <copyout+0x6a>
        va0 = PGROUNDDOWN(dstva);
    80000b44:	017c7933          	and	s2,s8,s7
        pa0 = walkaddr(pagetable, va0);
    80000b48:	85ca                	mv	a1,s2
    80000b4a:	855a                	mv	a0,s6
    80000b4c:	00000097          	auipc	ra,0x0
    80000b50:	9b8080e7          	jalr	-1608(ra) # 80000504 <walkaddr>
        if (pa0 == 0)
    80000b54:	cd01                	beqz	a0,80000b6c <copyout+0x72>
        n = PGSIZE - (dstva - va0);
    80000b56:	418904b3          	sub	s1,s2,s8
    80000b5a:	94d6                	add	s1,s1,s5
    80000b5c:	fc99f3e3          	bgeu	s3,s1,80000b22 <copyout+0x28>
    80000b60:	84ce                	mv	s1,s3
    80000b62:	b7c1                	j	80000b22 <copyout+0x28>
    }
    return 0;
    80000b64:	4501                	li	a0,0
    80000b66:	a021                	j	80000b6e <copyout+0x74>
    80000b68:	4501                	li	a0,0
}
    80000b6a:	8082                	ret
            return -1;
    80000b6c:	557d                	li	a0,-1
}
    80000b6e:	60a6                	ld	ra,72(sp)
    80000b70:	6406                	ld	s0,64(sp)
    80000b72:	74e2                	ld	s1,56(sp)
    80000b74:	7942                	ld	s2,48(sp)
    80000b76:	79a2                	ld	s3,40(sp)
    80000b78:	7a02                	ld	s4,32(sp)
    80000b7a:	6ae2                	ld	s5,24(sp)
    80000b7c:	6b42                	ld	s6,16(sp)
    80000b7e:	6ba2                	ld	s7,8(sp)
    80000b80:	6c02                	ld	s8,0(sp)
    80000b82:	6161                	addi	sp,sp,80
    80000b84:	8082                	ret

0000000080000b86 <copyin>:
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
    uint64 n, va0, pa0;

    while (len > 0) {
    80000b86:	caa5                	beqz	a3,80000bf6 <copyin+0x70>
{
    80000b88:	715d                	addi	sp,sp,-80
    80000b8a:	e486                	sd	ra,72(sp)
    80000b8c:	e0a2                	sd	s0,64(sp)
    80000b8e:	fc26                	sd	s1,56(sp)
    80000b90:	f84a                	sd	s2,48(sp)
    80000b92:	f44e                	sd	s3,40(sp)
    80000b94:	f052                	sd	s4,32(sp)
    80000b96:	ec56                	sd	s5,24(sp)
    80000b98:	e85a                	sd	s6,16(sp)
    80000b9a:	e45e                	sd	s7,8(sp)
    80000b9c:	e062                	sd	s8,0(sp)
    80000b9e:	0880                	addi	s0,sp,80
    80000ba0:	8b2a                	mv	s6,a0
    80000ba2:	8a2e                	mv	s4,a1
    80000ba4:	8c32                	mv	s8,a2
    80000ba6:	89b6                	mv	s3,a3
        va0 = PGROUNDDOWN(srcva);
    80000ba8:	7bfd                	lui	s7,0xfffff
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0)
            return -1;
        n = PGSIZE - (srcva - va0);
    80000baa:	6a85                	lui	s5,0x1
    80000bac:	a01d                	j	80000bd2 <copyin+0x4c>
        if (n > len)
            n = len;
        memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bae:	018505b3          	add	a1,a0,s8
    80000bb2:	0004861b          	sext.w	a2,s1
    80000bb6:	412585b3          	sub	a1,a1,s2
    80000bba:	8552                	mv	a0,s4
    80000bbc:	fffff097          	auipc	ra,0xfffff
    80000bc0:	61a080e7          	jalr	1562(ra) # 800001d6 <memmove>

        len -= n;
    80000bc4:	409989b3          	sub	s3,s3,s1
        dst += n;
    80000bc8:	9a26                	add	s4,s4,s1
        srcva = va0 + PGSIZE;
    80000bca:	01590c33          	add	s8,s2,s5
    while (len > 0) {
    80000bce:	02098263          	beqz	s3,80000bf2 <copyin+0x6c>
        va0 = PGROUNDDOWN(srcva);
    80000bd2:	017c7933          	and	s2,s8,s7
        pa0 = walkaddr(pagetable, va0);
    80000bd6:	85ca                	mv	a1,s2
    80000bd8:	855a                	mv	a0,s6
    80000bda:	00000097          	auipc	ra,0x0
    80000bde:	92a080e7          	jalr	-1750(ra) # 80000504 <walkaddr>
        if (pa0 == 0)
    80000be2:	cd01                	beqz	a0,80000bfa <copyin+0x74>
        n = PGSIZE - (srcva - va0);
    80000be4:	418904b3          	sub	s1,s2,s8
    80000be8:	94d6                	add	s1,s1,s5
    80000bea:	fc99f2e3          	bgeu	s3,s1,80000bae <copyin+0x28>
    80000bee:	84ce                	mv	s1,s3
    80000bf0:	bf7d                	j	80000bae <copyin+0x28>
    }
    return 0;
    80000bf2:	4501                	li	a0,0
    80000bf4:	a021                	j	80000bfc <copyin+0x76>
    80000bf6:	4501                	li	a0,0
}
    80000bf8:	8082                	ret
            return -1;
    80000bfa:	557d                	li	a0,-1
}
    80000bfc:	60a6                	ld	ra,72(sp)
    80000bfe:	6406                	ld	s0,64(sp)
    80000c00:	74e2                	ld	s1,56(sp)
    80000c02:	7942                	ld	s2,48(sp)
    80000c04:	79a2                	ld	s3,40(sp)
    80000c06:	7a02                	ld	s4,32(sp)
    80000c08:	6ae2                	ld	s5,24(sp)
    80000c0a:	6b42                	ld	s6,16(sp)
    80000c0c:	6ba2                	ld	s7,8(sp)
    80000c0e:	6c02                	ld	s8,0(sp)
    80000c10:	6161                	addi	sp,sp,80
    80000c12:	8082                	ret

0000000080000c14 <copyinstr>:
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    uint64 n, va0, pa0;
    int got_null = 0;

    while (got_null == 0 && max > 0) {
    80000c14:	c2dd                	beqz	a3,80000cba <copyinstr+0xa6>
{
    80000c16:	715d                	addi	sp,sp,-80
    80000c18:	e486                	sd	ra,72(sp)
    80000c1a:	e0a2                	sd	s0,64(sp)
    80000c1c:	fc26                	sd	s1,56(sp)
    80000c1e:	f84a                	sd	s2,48(sp)
    80000c20:	f44e                	sd	s3,40(sp)
    80000c22:	f052                	sd	s4,32(sp)
    80000c24:	ec56                	sd	s5,24(sp)
    80000c26:	e85a                	sd	s6,16(sp)
    80000c28:	e45e                	sd	s7,8(sp)
    80000c2a:	0880                	addi	s0,sp,80
    80000c2c:	8a2a                	mv	s4,a0
    80000c2e:	8b2e                	mv	s6,a1
    80000c30:	8bb2                	mv	s7,a2
    80000c32:	84b6                	mv	s1,a3
        va0 = PGROUNDDOWN(srcva);
    80000c34:	7afd                	lui	s5,0xfffff
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0)
            return -1;
        n = PGSIZE - (srcva - va0);
    80000c36:	6985                	lui	s3,0x1
    80000c38:	a02d                	j	80000c62 <copyinstr+0x4e>
            n = max;

        char *p = (char *)(pa0 + (srcva - va0));
        while (n > 0) {
            if (*p == '\0') {
                *dst = '\0';
    80000c3a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c3e:	4785                	li	a5,1
            dst++;
        }

        srcva = va0 + PGSIZE;
    }
    if (got_null) {
    80000c40:	37fd                	addiw	a5,a5,-1
    80000c42:	0007851b          	sext.w	a0,a5
        return 0;
    }
    else {
        return -1;
    }
}
    80000c46:	60a6                	ld	ra,72(sp)
    80000c48:	6406                	ld	s0,64(sp)
    80000c4a:	74e2                	ld	s1,56(sp)
    80000c4c:	7942                	ld	s2,48(sp)
    80000c4e:	79a2                	ld	s3,40(sp)
    80000c50:	7a02                	ld	s4,32(sp)
    80000c52:	6ae2                	ld	s5,24(sp)
    80000c54:	6b42                	ld	s6,16(sp)
    80000c56:	6ba2                	ld	s7,8(sp)
    80000c58:	6161                	addi	sp,sp,80
    80000c5a:	8082                	ret
        srcva = va0 + PGSIZE;
    80000c5c:	01390bb3          	add	s7,s2,s3
    while (got_null == 0 && max > 0) {
    80000c60:	c8a9                	beqz	s1,80000cb2 <copyinstr+0x9e>
        va0 = PGROUNDDOWN(srcva);
    80000c62:	015bf933          	and	s2,s7,s5
        pa0 = walkaddr(pagetable, va0);
    80000c66:	85ca                	mv	a1,s2
    80000c68:	8552                	mv	a0,s4
    80000c6a:	00000097          	auipc	ra,0x0
    80000c6e:	89a080e7          	jalr	-1894(ra) # 80000504 <walkaddr>
        if (pa0 == 0)
    80000c72:	c131                	beqz	a0,80000cb6 <copyinstr+0xa2>
        n = PGSIZE - (srcva - va0);
    80000c74:	417906b3          	sub	a3,s2,s7
    80000c78:	96ce                	add	a3,a3,s3
    80000c7a:	00d4f363          	bgeu	s1,a3,80000c80 <copyinstr+0x6c>
    80000c7e:	86a6                	mv	a3,s1
        char *p = (char *)(pa0 + (srcva - va0));
    80000c80:	955e                	add	a0,a0,s7
    80000c82:	41250533          	sub	a0,a0,s2
        while (n > 0) {
    80000c86:	daf9                	beqz	a3,80000c5c <copyinstr+0x48>
    80000c88:	87da                	mv	a5,s6
            if (*p == '\0') {
    80000c8a:	41650633          	sub	a2,a0,s6
    80000c8e:	fff48593          	addi	a1,s1,-1
    80000c92:	95da                	add	a1,a1,s6
        while (n > 0) {
    80000c94:	96da                	add	a3,a3,s6
            if (*p == '\0') {
    80000c96:	00f60733          	add	a4,a2,a5
    80000c9a:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd12c0>
    80000c9e:	df51                	beqz	a4,80000c3a <copyinstr+0x26>
                *dst = *p;
    80000ca0:	00e78023          	sb	a4,0(a5)
            --max;
    80000ca4:	40f584b3          	sub	s1,a1,a5
            dst++;
    80000ca8:	0785                	addi	a5,a5,1
        while (n > 0) {
    80000caa:	fed796e3          	bne	a5,a3,80000c96 <copyinstr+0x82>
            dst++;
    80000cae:	8b3e                	mv	s6,a5
    80000cb0:	b775                	j	80000c5c <copyinstr+0x48>
    80000cb2:	4781                	li	a5,0
    80000cb4:	b771                	j	80000c40 <copyinstr+0x2c>
            return -1;
    80000cb6:	557d                	li	a0,-1
    80000cb8:	b779                	j	80000c46 <copyinstr+0x32>
    int got_null = 0;
    80000cba:	4781                	li	a5,0
    if (got_null) {
    80000cbc:	37fd                	addiw	a5,a5,-1
    80000cbe:	0007851b          	sext.w	a0,a5
}
    80000cc2:	8082                	ret

0000000080000cc4 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    80000cc4:	7139                	addi	sp,sp,-64
    80000cc6:	fc06                	sd	ra,56(sp)
    80000cc8:	f822                	sd	s0,48(sp)
    80000cca:	f426                	sd	s1,40(sp)
    80000ccc:	f04a                	sd	s2,32(sp)
    80000cce:	ec4e                	sd	s3,24(sp)
    80000cd0:	e852                	sd	s4,16(sp)
    80000cd2:	e456                	sd	s5,8(sp)
    80000cd4:	e05a                	sd	s6,0(sp)
    80000cd6:	0080                	addi	s0,sp,64
    80000cd8:	89aa                	mv	s3,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++) {
    80000cda:	00008497          	auipc	s1,0x8
    80000cde:	04648493          	addi	s1,s1,70 # 80008d20 <proc>
        char *pa = kalloc();
        if (pa == 0)
            panic("kalloc");
        uint64 va = KSTACK((int)(p - proc));
    80000ce2:	8b26                	mv	s6,s1
    80000ce4:	00007a97          	auipc	s5,0x7
    80000ce8:	31ca8a93          	addi	s5,s5,796 # 80008000 <etext>
    80000cec:	04000937          	lui	s2,0x4000
    80000cf0:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000cf2:	0932                	slli	s2,s2,0xc
    for (p = proc; p < &proc[NPROC]; p++) {
    80000cf4:	0001aa17          	auipc	s4,0x1a
    80000cf8:	a2ca0a13          	addi	s4,s4,-1492 # 8001a720 <tickslock>
        char *pa = kalloc();
    80000cfc:	fffff097          	auipc	ra,0xfffff
    80000d00:	41e080e7          	jalr	1054(ra) # 8000011a <kalloc>
    80000d04:	862a                	mv	a2,a0
        if (pa == 0)
    80000d06:	c131                	beqz	a0,80000d4a <proc_mapstacks+0x86>
        uint64 va = KSTACK((int)(p - proc));
    80000d08:	416485b3          	sub	a1,s1,s6
    80000d0c:	858d                	srai	a1,a1,0x3
    80000d0e:	000ab783          	ld	a5,0(s5)
    80000d12:	02f585b3          	mul	a1,a1,a5
    80000d16:	2585                	addiw	a1,a1,1
    80000d18:	00d5959b          	slliw	a1,a1,0xd
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d1c:	4719                	li	a4,6
    80000d1e:	6685                	lui	a3,0x1
    80000d20:	40b905b3          	sub	a1,s2,a1
    80000d24:	854e                	mv	a0,s3
    80000d26:	00000097          	auipc	ra,0x0
    80000d2a:	8c0080e7          	jalr	-1856(ra) # 800005e6 <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++) {
    80000d2e:	46848493          	addi	s1,s1,1128
    80000d32:	fd4495e3          	bne	s1,s4,80000cfc <proc_mapstacks+0x38>
    }
}
    80000d36:	70e2                	ld	ra,56(sp)
    80000d38:	7442                	ld	s0,48(sp)
    80000d3a:	74a2                	ld	s1,40(sp)
    80000d3c:	7902                	ld	s2,32(sp)
    80000d3e:	69e2                	ld	s3,24(sp)
    80000d40:	6a42                	ld	s4,16(sp)
    80000d42:	6aa2                	ld	s5,8(sp)
    80000d44:	6b02                	ld	s6,0(sp)
    80000d46:	6121                	addi	sp,sp,64
    80000d48:	8082                	ret
            panic("kalloc");
    80000d4a:	00007517          	auipc	a0,0x7
    80000d4e:	3d650513          	addi	a0,a0,982 # 80008120 <etext+0x120>
    80000d52:	00005097          	auipc	ra,0x5
    80000d56:	21a080e7          	jalr	538(ra) # 80005f6c <panic>

0000000080000d5a <procinit>:

// initialize the proc table.
void procinit(void)
{
    80000d5a:	7139                	addi	sp,sp,-64
    80000d5c:	fc06                	sd	ra,56(sp)
    80000d5e:	f822                	sd	s0,48(sp)
    80000d60:	f426                	sd	s1,40(sp)
    80000d62:	f04a                	sd	s2,32(sp)
    80000d64:	ec4e                	sd	s3,24(sp)
    80000d66:	e852                	sd	s4,16(sp)
    80000d68:	e456                	sd	s5,8(sp)
    80000d6a:	e05a                	sd	s6,0(sp)
    80000d6c:	0080                	addi	s0,sp,64
    struct proc *p;

    initlock(&pid_lock, "nextpid");
    80000d6e:	00007597          	auipc	a1,0x7
    80000d72:	3ba58593          	addi	a1,a1,954 # 80008128 <etext+0x128>
    80000d76:	00008517          	auipc	a0,0x8
    80000d7a:	b7a50513          	addi	a0,a0,-1158 # 800088f0 <pid_lock>
    80000d7e:	00005097          	auipc	ra,0x5
    80000d82:	696080e7          	jalr	1686(ra) # 80006414 <initlock>
    initlock(&wait_lock, "wait_lock");
    80000d86:	00007597          	auipc	a1,0x7
    80000d8a:	3aa58593          	addi	a1,a1,938 # 80008130 <etext+0x130>
    80000d8e:	00008517          	auipc	a0,0x8
    80000d92:	b7a50513          	addi	a0,a0,-1158 # 80008908 <wait_lock>
    80000d96:	00005097          	auipc	ra,0x5
    80000d9a:	67e080e7          	jalr	1662(ra) # 80006414 <initlock>
    for (p = proc; p < &proc[NPROC]; p++) {
    80000d9e:	00008497          	auipc	s1,0x8
    80000da2:	f8248493          	addi	s1,s1,-126 # 80008d20 <proc>
        initlock(&p->lock, "proc");
    80000da6:	00007b17          	auipc	s6,0x7
    80000daa:	39ab0b13          	addi	s6,s6,922 # 80008140 <etext+0x140>
        p->state = UNUSED;
        p->kstack = KSTACK((int)(p - proc));
    80000dae:	8aa6                	mv	s5,s1
    80000db0:	00007a17          	auipc	s4,0x7
    80000db4:	250a0a13          	addi	s4,s4,592 # 80008000 <etext>
    80000db8:	04000937          	lui	s2,0x4000
    80000dbc:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000dbe:	0932                	slli	s2,s2,0xc
    for (p = proc; p < &proc[NPROC]; p++) {
    80000dc0:	0001a997          	auipc	s3,0x1a
    80000dc4:	96098993          	addi	s3,s3,-1696 # 8001a720 <tickslock>
        initlock(&p->lock, "proc");
    80000dc8:	85da                	mv	a1,s6
    80000dca:	8526                	mv	a0,s1
    80000dcc:	00005097          	auipc	ra,0x5
    80000dd0:	648080e7          	jalr	1608(ra) # 80006414 <initlock>
        p->state = UNUSED;
    80000dd4:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int)(p - proc));
    80000dd8:	415487b3          	sub	a5,s1,s5
    80000ddc:	878d                	srai	a5,a5,0x3
    80000dde:	000a3703          	ld	a4,0(s4)
    80000de2:	02e787b3          	mul	a5,a5,a4
    80000de6:	2785                	addiw	a5,a5,1
    80000de8:	00d7979b          	slliw	a5,a5,0xd
    80000dec:	40f907b3          	sub	a5,s2,a5
    80000df0:	e0bc                	sd	a5,64(s1)
    for (p = proc; p < &proc[NPROC]; p++) {
    80000df2:	46848493          	addi	s1,s1,1128
    80000df6:	fd3499e3          	bne	s1,s3,80000dc8 <procinit+0x6e>
    }
}
    80000dfa:	70e2                	ld	ra,56(sp)
    80000dfc:	7442                	ld	s0,48(sp)
    80000dfe:	74a2                	ld	s1,40(sp)
    80000e00:	7902                	ld	s2,32(sp)
    80000e02:	69e2                	ld	s3,24(sp)
    80000e04:	6a42                	ld	s4,16(sp)
    80000e06:	6aa2                	ld	s5,8(sp)
    80000e08:	6b02                	ld	s6,0(sp)
    80000e0a:	6121                	addi	sp,sp,64
    80000e0c:	8082                	ret

0000000080000e0e <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80000e0e:	1141                	addi	sp,sp,-16
    80000e10:	e422                	sd	s0,8(sp)
    80000e12:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e14:	8512                	mv	a0,tp
    int id = r_tp();
    return id;
}
    80000e16:	2501                	sext.w	a0,a0
    80000e18:	6422                	ld	s0,8(sp)
    80000e1a:	0141                	addi	sp,sp,16
    80000e1c:	8082                	ret

0000000080000e1e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *mycpu(void)
{
    80000e1e:	1141                	addi	sp,sp,-16
    80000e20:	e422                	sd	s0,8(sp)
    80000e22:	0800                	addi	s0,sp,16
    80000e24:	8792                	mv	a5,tp
    int id = cpuid();
    struct cpu *c = &cpus[id];
    80000e26:	2781                	sext.w	a5,a5
    80000e28:	079e                	slli	a5,a5,0x7
    return c;
}
    80000e2a:	00008517          	auipc	a0,0x8
    80000e2e:	af650513          	addi	a0,a0,-1290 # 80008920 <cpus>
    80000e32:	953e                	add	a0,a0,a5
    80000e34:	6422                	ld	s0,8(sp)
    80000e36:	0141                	addi	sp,sp,16
    80000e38:	8082                	ret

0000000080000e3a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *myproc(void)
{
    80000e3a:	1101                	addi	sp,sp,-32
    80000e3c:	ec06                	sd	ra,24(sp)
    80000e3e:	e822                	sd	s0,16(sp)
    80000e40:	e426                	sd	s1,8(sp)
    80000e42:	1000                	addi	s0,sp,32
    push_off();
    80000e44:	00005097          	auipc	ra,0x5
    80000e48:	614080e7          	jalr	1556(ra) # 80006458 <push_off>
    80000e4c:	8792                	mv	a5,tp
    struct cpu *c = mycpu();
    struct proc *p = c->proc;
    80000e4e:	2781                	sext.w	a5,a5
    80000e50:	079e                	slli	a5,a5,0x7
    80000e52:	00008717          	auipc	a4,0x8
    80000e56:	a9e70713          	addi	a4,a4,-1378 # 800088f0 <pid_lock>
    80000e5a:	97ba                	add	a5,a5,a4
    80000e5c:	7b84                	ld	s1,48(a5)
    pop_off();
    80000e5e:	00005097          	auipc	ra,0x5
    80000e62:	69a080e7          	jalr	1690(ra) # 800064f8 <pop_off>
    return p;
}
    80000e66:	8526                	mv	a0,s1
    80000e68:	60e2                	ld	ra,24(sp)
    80000e6a:	6442                	ld	s0,16(sp)
    80000e6c:	64a2                	ld	s1,8(sp)
    80000e6e:	6105                	addi	sp,sp,32
    80000e70:	8082                	ret

0000000080000e72 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80000e72:	1141                	addi	sp,sp,-16
    80000e74:	e406                	sd	ra,8(sp)
    80000e76:	e022                	sd	s0,0(sp)
    80000e78:	0800                	addi	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80000e7a:	00000097          	auipc	ra,0x0
    80000e7e:	fc0080e7          	jalr	-64(ra) # 80000e3a <myproc>
    80000e82:	00005097          	auipc	ra,0x5
    80000e86:	6d6080e7          	jalr	1750(ra) # 80006558 <release>

    if (first) {
    80000e8a:	00008797          	auipc	a5,0x8
    80000e8e:	9a67a783          	lw	a5,-1626(a5) # 80008830 <first.1>
    80000e92:	eb89                	bnez	a5,80000ea4 <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80000e94:	00001097          	auipc	ra,0x1
    80000e98:	cfa080e7          	jalr	-774(ra) # 80001b8e <usertrapret>
}
    80000e9c:	60a2                	ld	ra,8(sp)
    80000e9e:	6402                	ld	s0,0(sp)
    80000ea0:	0141                	addi	sp,sp,16
    80000ea2:	8082                	ret
        first = 0;
    80000ea4:	00008797          	auipc	a5,0x8
    80000ea8:	9807a623          	sw	zero,-1652(a5) # 80008830 <first.1>
        fsinit(ROOTDEV);
    80000eac:	4505                	li	a0,1
    80000eae:	00002097          	auipc	ra,0x2
    80000eb2:	b50080e7          	jalr	-1200(ra) # 800029fe <fsinit>
    80000eb6:	bff9                	j	80000e94 <forkret+0x22>

0000000080000eb8 <allocpid>:
{
    80000eb8:	1101                	addi	sp,sp,-32
    80000eba:	ec06                	sd	ra,24(sp)
    80000ebc:	e822                	sd	s0,16(sp)
    80000ebe:	e426                	sd	s1,8(sp)
    80000ec0:	e04a                	sd	s2,0(sp)
    80000ec2:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80000ec4:	00008917          	auipc	s2,0x8
    80000ec8:	a2c90913          	addi	s2,s2,-1492 # 800088f0 <pid_lock>
    80000ecc:	854a                	mv	a0,s2
    80000ece:	00005097          	auipc	ra,0x5
    80000ed2:	5d6080e7          	jalr	1494(ra) # 800064a4 <acquire>
    pid = nextpid;
    80000ed6:	00008797          	auipc	a5,0x8
    80000eda:	95e78793          	addi	a5,a5,-1698 # 80008834 <nextpid>
    80000ede:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80000ee0:	0014871b          	addiw	a4,s1,1
    80000ee4:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80000ee6:	854a                	mv	a0,s2
    80000ee8:	00005097          	auipc	ra,0x5
    80000eec:	670080e7          	jalr	1648(ra) # 80006558 <release>
}
    80000ef0:	8526                	mv	a0,s1
    80000ef2:	60e2                	ld	ra,24(sp)
    80000ef4:	6442                	ld	s0,16(sp)
    80000ef6:	64a2                	ld	s1,8(sp)
    80000ef8:	6902                	ld	s2,0(sp)
    80000efa:	6105                	addi	sp,sp,32
    80000efc:	8082                	ret

0000000080000efe <proc_pagetable>:
{
    80000efe:	1101                	addi	sp,sp,-32
    80000f00:	ec06                	sd	ra,24(sp)
    80000f02:	e822                	sd	s0,16(sp)
    80000f04:	e426                	sd	s1,8(sp)
    80000f06:	e04a                	sd	s2,0(sp)
    80000f08:	1000                	addi	s0,sp,32
    80000f0a:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80000f0c:	00000097          	auipc	ra,0x0
    80000f10:	8b6080e7          	jalr	-1866(ra) # 800007c2 <uvmcreate>
    80000f14:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80000f16:	c121                	beqz	a0,80000f56 <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline, PTE_R | PTE_X) < 0) {
    80000f18:	4729                	li	a4,10
    80000f1a:	00006697          	auipc	a3,0x6
    80000f1e:	0e668693          	addi	a3,a3,230 # 80007000 <_trampoline>
    80000f22:	6605                	lui	a2,0x1
    80000f24:	040005b7          	lui	a1,0x4000
    80000f28:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f2a:	05b2                	slli	a1,a1,0xc
    80000f2c:	fffff097          	auipc	ra,0xfffff
    80000f30:	61a080e7          	jalr	1562(ra) # 80000546 <mappages>
    80000f34:	02054863          	bltz	a0,80000f64 <proc_pagetable+0x66>
    if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe), PTE_R | PTE_W) < 0) {
    80000f38:	4719                	li	a4,6
    80000f3a:	05893683          	ld	a3,88(s2)
    80000f3e:	6605                	lui	a2,0x1
    80000f40:	020005b7          	lui	a1,0x2000
    80000f44:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f46:	05b6                	slli	a1,a1,0xd
    80000f48:	8526                	mv	a0,s1
    80000f4a:	fffff097          	auipc	ra,0xfffff
    80000f4e:	5fc080e7          	jalr	1532(ra) # 80000546 <mappages>
    80000f52:	02054163          	bltz	a0,80000f74 <proc_pagetable+0x76>
}
    80000f56:	8526                	mv	a0,s1
    80000f58:	60e2                	ld	ra,24(sp)
    80000f5a:	6442                	ld	s0,16(sp)
    80000f5c:	64a2                	ld	s1,8(sp)
    80000f5e:	6902                	ld	s2,0(sp)
    80000f60:	6105                	addi	sp,sp,32
    80000f62:	8082                	ret
        uvmfree(pagetable, 0);
    80000f64:	4581                	li	a1,0
    80000f66:	8526                	mv	a0,s1
    80000f68:	00000097          	auipc	ra,0x0
    80000f6c:	a60080e7          	jalr	-1440(ra) # 800009c8 <uvmfree>
        return 0;
    80000f70:	4481                	li	s1,0
    80000f72:	b7d5                	j	80000f56 <proc_pagetable+0x58>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f74:	4681                	li	a3,0
    80000f76:	4605                	li	a2,1
    80000f78:	040005b7          	lui	a1,0x4000
    80000f7c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f7e:	05b2                	slli	a1,a1,0xc
    80000f80:	8526                	mv	a0,s1
    80000f82:	fffff097          	auipc	ra,0xfffff
    80000f86:	78a080e7          	jalr	1930(ra) # 8000070c <uvmunmap>
        uvmfree(pagetable, 0);
    80000f8a:	4581                	li	a1,0
    80000f8c:	8526                	mv	a0,s1
    80000f8e:	00000097          	auipc	ra,0x0
    80000f92:	a3a080e7          	jalr	-1478(ra) # 800009c8 <uvmfree>
        return 0;
    80000f96:	4481                	li	s1,0
    80000f98:	bf7d                	j	80000f56 <proc_pagetable+0x58>

0000000080000f9a <proc_freepagetable>:
{
    80000f9a:	1101                	addi	sp,sp,-32
    80000f9c:	ec06                	sd	ra,24(sp)
    80000f9e:	e822                	sd	s0,16(sp)
    80000fa0:	e426                	sd	s1,8(sp)
    80000fa2:	e04a                	sd	s2,0(sp)
    80000fa4:	1000                	addi	s0,sp,32
    80000fa6:	84aa                	mv	s1,a0
    80000fa8:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000faa:	4681                	li	a3,0
    80000fac:	4605                	li	a2,1
    80000fae:	040005b7          	lui	a1,0x4000
    80000fb2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fb4:	05b2                	slli	a1,a1,0xc
    80000fb6:	fffff097          	auipc	ra,0xfffff
    80000fba:	756080e7          	jalr	1878(ra) # 8000070c <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fbe:	4681                	li	a3,0
    80000fc0:	4605                	li	a2,1
    80000fc2:	020005b7          	lui	a1,0x2000
    80000fc6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fc8:	05b6                	slli	a1,a1,0xd
    80000fca:	8526                	mv	a0,s1
    80000fcc:	fffff097          	auipc	ra,0xfffff
    80000fd0:	740080e7          	jalr	1856(ra) # 8000070c <uvmunmap>
    uvmfree(pagetable, sz);
    80000fd4:	85ca                	mv	a1,s2
    80000fd6:	8526                	mv	a0,s1
    80000fd8:	00000097          	auipc	ra,0x0
    80000fdc:	9f0080e7          	jalr	-1552(ra) # 800009c8 <uvmfree>
}
    80000fe0:	60e2                	ld	ra,24(sp)
    80000fe2:	6442                	ld	s0,16(sp)
    80000fe4:	64a2                	ld	s1,8(sp)
    80000fe6:	6902                	ld	s2,0(sp)
    80000fe8:	6105                	addi	sp,sp,32
    80000fea:	8082                	ret

0000000080000fec <freeproc>:
{
    80000fec:	1101                	addi	sp,sp,-32
    80000fee:	ec06                	sd	ra,24(sp)
    80000ff0:	e822                	sd	s0,16(sp)
    80000ff2:	e426                	sd	s1,8(sp)
    80000ff4:	1000                	addi	s0,sp,32
    80000ff6:	84aa                	mv	s1,a0
    if (p->trapframe)
    80000ff8:	6d28                	ld	a0,88(a0)
    80000ffa:	c509                	beqz	a0,80001004 <freeproc+0x18>
        kfree((void *)p->trapframe);
    80000ffc:	fffff097          	auipc	ra,0xfffff
    80001000:	020080e7          	jalr	32(ra) # 8000001c <kfree>
    p->trapframe = 0;
    80001004:	0404bc23          	sd	zero,88(s1)
    if (p->pagetable)
    80001008:	68a8                	ld	a0,80(s1)
    8000100a:	c511                	beqz	a0,80001016 <freeproc+0x2a>
        proc_freepagetable(p->pagetable, p->sz);
    8000100c:	64ac                	ld	a1,72(s1)
    8000100e:	00000097          	auipc	ra,0x0
    80001012:	f8c080e7          	jalr	-116(ra) # 80000f9a <proc_freepagetable>
    p->pagetable = 0;
    80001016:	0404b823          	sd	zero,80(s1)
    p->sz = 0;
    8000101a:	0404b423          	sd	zero,72(s1)
    p->pid = 0;
    8000101e:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    80001022:	0204bc23          	sd	zero,56(s1)
    p->name[0] = 0;
    80001026:	14048c23          	sb	zero,344(s1)
    p->chan = 0;
    8000102a:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    8000102e:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    80001032:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    80001036:	0004ac23          	sw	zero,24(s1)
}
    8000103a:	60e2                	ld	ra,24(sp)
    8000103c:	6442                	ld	s0,16(sp)
    8000103e:	64a2                	ld	s1,8(sp)
    80001040:	6105                	addi	sp,sp,32
    80001042:	8082                	ret

0000000080001044 <allocproc>:
{
    80001044:	1101                	addi	sp,sp,-32
    80001046:	ec06                	sd	ra,24(sp)
    80001048:	e822                	sd	s0,16(sp)
    8000104a:	e426                	sd	s1,8(sp)
    8000104c:	e04a                	sd	s2,0(sp)
    8000104e:	1000                	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++) {
    80001050:	00008497          	auipc	s1,0x8
    80001054:	cd048493          	addi	s1,s1,-816 # 80008d20 <proc>
    80001058:	00019917          	auipc	s2,0x19
    8000105c:	6c890913          	addi	s2,s2,1736 # 8001a720 <tickslock>
        acquire(&p->lock);
    80001060:	8526                	mv	a0,s1
    80001062:	00005097          	auipc	ra,0x5
    80001066:	442080e7          	jalr	1090(ra) # 800064a4 <acquire>
        if (p->state == UNUSED) {
    8000106a:	4c9c                	lw	a5,24(s1)
    8000106c:	cf81                	beqz	a5,80001084 <allocproc+0x40>
            release(&p->lock);
    8000106e:	8526                	mv	a0,s1
    80001070:	00005097          	auipc	ra,0x5
    80001074:	4e8080e7          	jalr	1256(ra) # 80006558 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001078:	46848493          	addi	s1,s1,1128
    8000107c:	ff2492e3          	bne	s1,s2,80001060 <allocproc+0x1c>
    return 0;
    80001080:	4481                	li	s1,0
    80001082:	a889                	j	800010d4 <allocproc+0x90>
    p->pid = allocpid();
    80001084:	00000097          	auipc	ra,0x0
    80001088:	e34080e7          	jalr	-460(ra) # 80000eb8 <allocpid>
    8000108c:	d888                	sw	a0,48(s1)
    p->state = USED;
    8000108e:	4785                	li	a5,1
    80001090:	cc9c                	sw	a5,24(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    80001092:	fffff097          	auipc	ra,0xfffff
    80001096:	088080e7          	jalr	136(ra) # 8000011a <kalloc>
    8000109a:	892a                	mv	s2,a0
    8000109c:	eca8                	sd	a0,88(s1)
    8000109e:	c131                	beqz	a0,800010e2 <allocproc+0x9e>
    p->pagetable = proc_pagetable(p);
    800010a0:	8526                	mv	a0,s1
    800010a2:	00000097          	auipc	ra,0x0
    800010a6:	e5c080e7          	jalr	-420(ra) # 80000efe <proc_pagetable>
    800010aa:	892a                	mv	s2,a0
    800010ac:	e8a8                	sd	a0,80(s1)
    if (p->pagetable == 0) {
    800010ae:	c531                	beqz	a0,800010fa <allocproc+0xb6>
    memset(&p->context, 0, sizeof(p->context));
    800010b0:	07000613          	li	a2,112
    800010b4:	4581                	li	a1,0
    800010b6:	06048513          	addi	a0,s1,96
    800010ba:	fffff097          	auipc	ra,0xfffff
    800010be:	0c0080e7          	jalr	192(ra) # 8000017a <memset>
    p->context.ra = (uint64)forkret;
    800010c2:	00000797          	auipc	a5,0x0
    800010c6:	db078793          	addi	a5,a5,-592 # 80000e72 <forkret>
    800010ca:	f0bc                	sd	a5,96(s1)
    p->context.sp = p->kstack + PGSIZE;
    800010cc:	60bc                	ld	a5,64(s1)
    800010ce:	6705                	lui	a4,0x1
    800010d0:	97ba                	add	a5,a5,a4
    800010d2:	f4bc                	sd	a5,104(s1)
}
    800010d4:	8526                	mv	a0,s1
    800010d6:	60e2                	ld	ra,24(sp)
    800010d8:	6442                	ld	s0,16(sp)
    800010da:	64a2                	ld	s1,8(sp)
    800010dc:	6902                	ld	s2,0(sp)
    800010de:	6105                	addi	sp,sp,32
    800010e0:	8082                	ret
        freeproc(p);
    800010e2:	8526                	mv	a0,s1
    800010e4:	00000097          	auipc	ra,0x0
    800010e8:	f08080e7          	jalr	-248(ra) # 80000fec <freeproc>
        release(&p->lock);
    800010ec:	8526                	mv	a0,s1
    800010ee:	00005097          	auipc	ra,0x5
    800010f2:	46a080e7          	jalr	1130(ra) # 80006558 <release>
        return 0;
    800010f6:	84ca                	mv	s1,s2
    800010f8:	bff1                	j	800010d4 <allocproc+0x90>
        freeproc(p);
    800010fa:	8526                	mv	a0,s1
    800010fc:	00000097          	auipc	ra,0x0
    80001100:	ef0080e7          	jalr	-272(ra) # 80000fec <freeproc>
        release(&p->lock);
    80001104:	8526                	mv	a0,s1
    80001106:	00005097          	auipc	ra,0x5
    8000110a:	452080e7          	jalr	1106(ra) # 80006558 <release>
        return 0;
    8000110e:	84ca                	mv	s1,s2
    80001110:	b7d1                	j	800010d4 <allocproc+0x90>

0000000080001112 <userinit>:
{
    80001112:	1101                	addi	sp,sp,-32
    80001114:	ec06                	sd	ra,24(sp)
    80001116:	e822                	sd	s0,16(sp)
    80001118:	e426                	sd	s1,8(sp)
    8000111a:	1000                	addi	s0,sp,32
    p = allocproc();
    8000111c:	00000097          	auipc	ra,0x0
    80001120:	f28080e7          	jalr	-216(ra) # 80001044 <allocproc>
    80001124:	84aa                	mv	s1,a0
    initproc = p;
    80001126:	00007797          	auipc	a5,0x7
    8000112a:	78a7b523          	sd	a0,1930(a5) # 800088b0 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000112e:	03400613          	li	a2,52
    80001132:	00007597          	auipc	a1,0x7
    80001136:	70e58593          	addi	a1,a1,1806 # 80008840 <initcode>
    8000113a:	6928                	ld	a0,80(a0)
    8000113c:	fffff097          	auipc	ra,0xfffff
    80001140:	6b4080e7          	jalr	1716(ra) # 800007f0 <uvmfirst>
    p->sz = PGSIZE;
    80001144:	6785                	lui	a5,0x1
    80001146:	e4bc                	sd	a5,72(s1)
    p->trapframe->epc = 0;     // user program counter
    80001148:	6cb8                	ld	a4,88(s1)
    8000114a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    8000114e:	6cb8                	ld	a4,88(s1)
    80001150:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    80001152:	4641                	li	a2,16
    80001154:	00007597          	auipc	a1,0x7
    80001158:	ff458593          	addi	a1,a1,-12 # 80008148 <etext+0x148>
    8000115c:	15848513          	addi	a0,s1,344
    80001160:	fffff097          	auipc	ra,0xfffff
    80001164:	164080e7          	jalr	356(ra) # 800002c4 <safestrcpy>
    p->cwd = namei("/");
    80001168:	00007517          	auipc	a0,0x7
    8000116c:	ff050513          	addi	a0,a0,-16 # 80008158 <etext+0x158>
    80001170:	00002097          	auipc	ra,0x2
    80001174:	2b8080e7          	jalr	696(ra) # 80003428 <namei>
    80001178:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    8000117c:	478d                	li	a5,3
    8000117e:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    80001180:	8526                	mv	a0,s1
    80001182:	00005097          	auipc	ra,0x5
    80001186:	3d6080e7          	jalr	982(ra) # 80006558 <release>
}
    8000118a:	60e2                	ld	ra,24(sp)
    8000118c:	6442                	ld	s0,16(sp)
    8000118e:	64a2                	ld	s1,8(sp)
    80001190:	6105                	addi	sp,sp,32
    80001192:	8082                	ret

0000000080001194 <growproc>:
{
    80001194:	1101                	addi	sp,sp,-32
    80001196:	ec06                	sd	ra,24(sp)
    80001198:	e822                	sd	s0,16(sp)
    8000119a:	e426                	sd	s1,8(sp)
    8000119c:	e04a                	sd	s2,0(sp)
    8000119e:	1000                	addi	s0,sp,32
    800011a0:	892a                	mv	s2,a0
    struct proc *p = myproc();
    800011a2:	00000097          	auipc	ra,0x0
    800011a6:	c98080e7          	jalr	-872(ra) # 80000e3a <myproc>
    800011aa:	84aa                	mv	s1,a0
    sz = p->sz;
    800011ac:	652c                	ld	a1,72(a0)
    if (n > 0) {
    800011ae:	01204c63          	bgtz	s2,800011c6 <growproc+0x32>
    else if (n < 0) {
    800011b2:	02094663          	bltz	s2,800011de <growproc+0x4a>
    p->sz = sz;
    800011b6:	e4ac                	sd	a1,72(s1)
    return 0;
    800011b8:	4501                	li	a0,0
}
    800011ba:	60e2                	ld	ra,24(sp)
    800011bc:	6442                	ld	s0,16(sp)
    800011be:	64a2                	ld	s1,8(sp)
    800011c0:	6902                	ld	s2,0(sp)
    800011c2:	6105                	addi	sp,sp,32
    800011c4:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800011c6:	4691                	li	a3,4
    800011c8:	00b90633          	add	a2,s2,a1
    800011cc:	6928                	ld	a0,80(a0)
    800011ce:	fffff097          	auipc	ra,0xfffff
    800011d2:	6dc080e7          	jalr	1756(ra) # 800008aa <uvmalloc>
    800011d6:	85aa                	mv	a1,a0
    800011d8:	fd79                	bnez	a0,800011b6 <growproc+0x22>
            return -1;
    800011da:	557d                	li	a0,-1
    800011dc:	bff9                	j	800011ba <growproc+0x26>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011de:	00b90633          	add	a2,s2,a1
    800011e2:	6928                	ld	a0,80(a0)
    800011e4:	fffff097          	auipc	ra,0xfffff
    800011e8:	67e080e7          	jalr	1662(ra) # 80000862 <uvmdealloc>
    800011ec:	85aa                	mv	a1,a0
    800011ee:	b7e1                	j	800011b6 <growproc+0x22>

00000000800011f0 <fork>:
{
    800011f0:	7139                	addi	sp,sp,-64
    800011f2:	fc06                	sd	ra,56(sp)
    800011f4:	f822                	sd	s0,48(sp)
    800011f6:	f426                	sd	s1,40(sp)
    800011f8:	f04a                	sd	s2,32(sp)
    800011fa:	ec4e                	sd	s3,24(sp)
    800011fc:	e852                	sd	s4,16(sp)
    800011fe:	e456                	sd	s5,8(sp)
    80001200:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    80001202:	00000097          	auipc	ra,0x0
    80001206:	c38080e7          	jalr	-968(ra) # 80000e3a <myproc>
    8000120a:	89aa                	mv	s3,a0
    if ((np = allocproc()) == 0) {
    8000120c:	00000097          	auipc	ra,0x0
    80001210:	e38080e7          	jalr	-456(ra) # 80001044 <allocproc>
    80001214:	14050963          	beqz	a0,80001366 <fork+0x176>
    80001218:	8a2a                	mv	s4,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    8000121a:	0489b603          	ld	a2,72(s3)
    8000121e:	692c                	ld	a1,80(a0)
    80001220:	0509b503          	ld	a0,80(s3)
    80001224:	fffff097          	auipc	ra,0xfffff
    80001228:	7de080e7          	jalr	2014(ra) # 80000a02 <uvmcopy>
    8000122c:	04054863          	bltz	a0,8000127c <fork+0x8c>
    np->sz = p->sz;
    80001230:	0489b783          	ld	a5,72(s3)
    80001234:	04fa3423          	sd	a5,72(s4)
    *(np->trapframe) = *(p->trapframe);
    80001238:	0589b683          	ld	a3,88(s3)
    8000123c:	87b6                	mv	a5,a3
    8000123e:	058a3703          	ld	a4,88(s4)
    80001242:	12068693          	addi	a3,a3,288
    80001246:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000124a:	6788                	ld	a0,8(a5)
    8000124c:	6b8c                	ld	a1,16(a5)
    8000124e:	6f90                	ld	a2,24(a5)
    80001250:	01073023          	sd	a6,0(a4)
    80001254:	e708                	sd	a0,8(a4)
    80001256:	eb0c                	sd	a1,16(a4)
    80001258:	ef10                	sd	a2,24(a4)
    8000125a:	02078793          	addi	a5,a5,32
    8000125e:	02070713          	addi	a4,a4,32
    80001262:	fed792e3          	bne	a5,a3,80001246 <fork+0x56>
    np->trapframe->a0 = 0;
    80001266:	058a3783          	ld	a5,88(s4)
    8000126a:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++)
    8000126e:	0d098493          	addi	s1,s3,208
    80001272:	0d0a0913          	addi	s2,s4,208
    80001276:	15098a93          	addi	s5,s3,336
    8000127a:	a00d                	j	8000129c <fork+0xac>
        freeproc(np);
    8000127c:	8552                	mv	a0,s4
    8000127e:	00000097          	auipc	ra,0x0
    80001282:	d6e080e7          	jalr	-658(ra) # 80000fec <freeproc>
        release(&np->lock);
    80001286:	8552                	mv	a0,s4
    80001288:	00005097          	auipc	ra,0x5
    8000128c:	2d0080e7          	jalr	720(ra) # 80006558 <release>
        return -1;
    80001290:	5afd                	li	s5,-1
    80001292:	a0c1                	j	80001352 <fork+0x162>
    for (i = 0; i < NOFILE; i++)
    80001294:	04a1                	addi	s1,s1,8
    80001296:	0921                	addi	s2,s2,8
    80001298:	01548b63          	beq	s1,s5,800012ae <fork+0xbe>
        if (p->ofile[i])
    8000129c:	6088                	ld	a0,0(s1)
    8000129e:	d97d                	beqz	a0,80001294 <fork+0xa4>
            np->ofile[i] = filedup(p->ofile[i]);
    800012a0:	00003097          	auipc	ra,0x3
    800012a4:	81e080e7          	jalr	-2018(ra) # 80003abe <filedup>
    800012a8:	00a93023          	sd	a0,0(s2)
    800012ac:	b7e5                	j	80001294 <fork+0xa4>
    np->cwd = idup(p->cwd);
    800012ae:	1509b503          	ld	a0,336(s3)
    800012b2:	00002097          	auipc	ra,0x2
    800012b6:	98c080e7          	jalr	-1652(ra) # 80002c3e <idup>
    800012ba:	14aa3823          	sd	a0,336(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    800012be:	4641                	li	a2,16
    800012c0:	15898593          	addi	a1,s3,344
    800012c4:	158a0513          	addi	a0,s4,344
    800012c8:	fffff097          	auipc	ra,0xfffff
    800012cc:	ffc080e7          	jalr	-4(ra) # 800002c4 <safestrcpy>
    pid = np->pid;
    800012d0:	030a2a83          	lw	s5,48(s4)
    release(&np->lock);
    800012d4:	8552                	mv	a0,s4
    800012d6:	00005097          	auipc	ra,0x5
    800012da:	282080e7          	jalr	642(ra) # 80006558 <release>
    acquire(&wait_lock);
    800012de:	00007497          	auipc	s1,0x7
    800012e2:	62a48493          	addi	s1,s1,1578 # 80008908 <wait_lock>
    800012e6:	8526                	mv	a0,s1
    800012e8:	00005097          	auipc	ra,0x5
    800012ec:	1bc080e7          	jalr	444(ra) # 800064a4 <acquire>
    np->parent = p;
    800012f0:	033a3c23          	sd	s3,56(s4)
    release(&wait_lock);
    800012f4:	8526                	mv	a0,s1
    800012f6:	00005097          	auipc	ra,0x5
    800012fa:	262080e7          	jalr	610(ra) # 80006558 <release>
    acquire(&np->lock);
    800012fe:	8552                	mv	a0,s4
    80001300:	00005097          	auipc	ra,0x5
    80001304:	1a4080e7          	jalr	420(ra) # 800064a4 <acquire>
    for (int i = 0; i < VMASIZE; i++) {
    80001308:	16898493          	addi	s1,s3,360
    8000130c:	168a0913          	addi	s2,s4,360
    80001310:	46898993          	addi	s3,s3,1128
    80001314:	a039                	j	80001322 <fork+0x132>
    80001316:	03048493          	addi	s1,s1,48
    8000131a:	03090913          	addi	s2,s2,48
    8000131e:	03348263          	beq	s1,s3,80001342 <fork+0x152>
        if (p->vma[i].used) {
    80001322:	409c                	lw	a5,0(s1)
    80001324:	dbed                	beqz	a5,80001316 <fork+0x126>
            memmove(&(np->vma[i]), &(p->vma[i]), sizeof(p->vma[i]));
    80001326:	03000613          	li	a2,48
    8000132a:	85a6                	mv	a1,s1
    8000132c:	854a                	mv	a0,s2
    8000132e:	fffff097          	auipc	ra,0xfffff
    80001332:	ea8080e7          	jalr	-344(ra) # 800001d6 <memmove>
            filedup(p->vma[i].fp); // refcount++
    80001336:	7488                	ld	a0,40(s1)
    80001338:	00002097          	auipc	ra,0x2
    8000133c:	786080e7          	jalr	1926(ra) # 80003abe <filedup>
    80001340:	bfd9                	j	80001316 <fork+0x126>
    np->state = RUNNABLE;
    80001342:	478d                	li	a5,3
    80001344:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    80001348:	8552                	mv	a0,s4
    8000134a:	00005097          	auipc	ra,0x5
    8000134e:	20e080e7          	jalr	526(ra) # 80006558 <release>
}
    80001352:	8556                	mv	a0,s5
    80001354:	70e2                	ld	ra,56(sp)
    80001356:	7442                	ld	s0,48(sp)
    80001358:	74a2                	ld	s1,40(sp)
    8000135a:	7902                	ld	s2,32(sp)
    8000135c:	69e2                	ld	s3,24(sp)
    8000135e:	6a42                	ld	s4,16(sp)
    80001360:	6aa2                	ld	s5,8(sp)
    80001362:	6121                	addi	sp,sp,64
    80001364:	8082                	ret
        return -1;
    80001366:	5afd                	li	s5,-1
    80001368:	b7ed                	j	80001352 <fork+0x162>

000000008000136a <scheduler>:
{
    8000136a:	7139                	addi	sp,sp,-64
    8000136c:	fc06                	sd	ra,56(sp)
    8000136e:	f822                	sd	s0,48(sp)
    80001370:	f426                	sd	s1,40(sp)
    80001372:	f04a                	sd	s2,32(sp)
    80001374:	ec4e                	sd	s3,24(sp)
    80001376:	e852                	sd	s4,16(sp)
    80001378:	e456                	sd	s5,8(sp)
    8000137a:	e05a                	sd	s6,0(sp)
    8000137c:	0080                	addi	s0,sp,64
    8000137e:	8792                	mv	a5,tp
    int id = r_tp();
    80001380:	2781                	sext.w	a5,a5
    c->proc = 0;
    80001382:	00779a93          	slli	s5,a5,0x7
    80001386:	00007717          	auipc	a4,0x7
    8000138a:	56a70713          	addi	a4,a4,1386 # 800088f0 <pid_lock>
    8000138e:	9756                	add	a4,a4,s5
    80001390:	02073823          	sd	zero,48(a4)
                swtch(&c->context, &p->context);
    80001394:	00007717          	auipc	a4,0x7
    80001398:	59470713          	addi	a4,a4,1428 # 80008928 <cpus+0x8>
    8000139c:	9aba                	add	s5,s5,a4
            if (p->state == RUNNABLE) {
    8000139e:	498d                	li	s3,3
                p->state = RUNNING;
    800013a0:	4b11                	li	s6,4
                c->proc = p;
    800013a2:	079e                	slli	a5,a5,0x7
    800013a4:	00007a17          	auipc	s4,0x7
    800013a8:	54ca0a13          	addi	s4,s4,1356 # 800088f0 <pid_lock>
    800013ac:	9a3e                	add	s4,s4,a5
        for (p = proc; p < &proc[NPROC]; p++) {
    800013ae:	00019917          	auipc	s2,0x19
    800013b2:	37290913          	addi	s2,s2,882 # 8001a720 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013b6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013ba:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013be:	10079073          	csrw	sstatus,a5
    800013c2:	00008497          	auipc	s1,0x8
    800013c6:	95e48493          	addi	s1,s1,-1698 # 80008d20 <proc>
    800013ca:	a811                	j	800013de <scheduler+0x74>
            release(&p->lock);
    800013cc:	8526                	mv	a0,s1
    800013ce:	00005097          	auipc	ra,0x5
    800013d2:	18a080e7          	jalr	394(ra) # 80006558 <release>
        for (p = proc; p < &proc[NPROC]; p++) {
    800013d6:	46848493          	addi	s1,s1,1128
    800013da:	fd248ee3          	beq	s1,s2,800013b6 <scheduler+0x4c>
            acquire(&p->lock);
    800013de:	8526                	mv	a0,s1
    800013e0:	00005097          	auipc	ra,0x5
    800013e4:	0c4080e7          	jalr	196(ra) # 800064a4 <acquire>
            if (p->state == RUNNABLE) {
    800013e8:	4c9c                	lw	a5,24(s1)
    800013ea:	ff3791e3          	bne	a5,s3,800013cc <scheduler+0x62>
                p->state = RUNNING;
    800013ee:	0164ac23          	sw	s6,24(s1)
                c->proc = p;
    800013f2:	029a3823          	sd	s1,48(s4)
                swtch(&c->context, &p->context);
    800013f6:	06048593          	addi	a1,s1,96
    800013fa:	8556                	mv	a0,s5
    800013fc:	00000097          	auipc	ra,0x0
    80001400:	6e8080e7          	jalr	1768(ra) # 80001ae4 <swtch>
                c->proc = 0;
    80001404:	020a3823          	sd	zero,48(s4)
    80001408:	b7d1                	j	800013cc <scheduler+0x62>

000000008000140a <sched>:
{
    8000140a:	7179                	addi	sp,sp,-48
    8000140c:	f406                	sd	ra,40(sp)
    8000140e:	f022                	sd	s0,32(sp)
    80001410:	ec26                	sd	s1,24(sp)
    80001412:	e84a                	sd	s2,16(sp)
    80001414:	e44e                	sd	s3,8(sp)
    80001416:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80001418:	00000097          	auipc	ra,0x0
    8000141c:	a22080e7          	jalr	-1502(ra) # 80000e3a <myproc>
    80001420:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    80001422:	00005097          	auipc	ra,0x5
    80001426:	008080e7          	jalr	8(ra) # 8000642a <holding>
    8000142a:	c93d                	beqz	a0,800014a0 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000142c:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    8000142e:	2781                	sext.w	a5,a5
    80001430:	079e                	slli	a5,a5,0x7
    80001432:	00007717          	auipc	a4,0x7
    80001436:	4be70713          	addi	a4,a4,1214 # 800088f0 <pid_lock>
    8000143a:	97ba                	add	a5,a5,a4
    8000143c:	0a87a703          	lw	a4,168(a5)
    80001440:	4785                	li	a5,1
    80001442:	06f71763          	bne	a4,a5,800014b0 <sched+0xa6>
    if (p->state == RUNNING)
    80001446:	4c98                	lw	a4,24(s1)
    80001448:	4791                	li	a5,4
    8000144a:	06f70b63          	beq	a4,a5,800014c0 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000144e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001452:	8b89                	andi	a5,a5,2
    if (intr_get())
    80001454:	efb5                	bnez	a5,800014d0 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001456:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    80001458:	00007917          	auipc	s2,0x7
    8000145c:	49890913          	addi	s2,s2,1176 # 800088f0 <pid_lock>
    80001460:	2781                	sext.w	a5,a5
    80001462:	079e                	slli	a5,a5,0x7
    80001464:	97ca                	add	a5,a5,s2
    80001466:	0ac7a983          	lw	s3,172(a5)
    8000146a:	8792                	mv	a5,tp
    swtch(&p->context, &mycpu()->context);
    8000146c:	2781                	sext.w	a5,a5
    8000146e:	079e                	slli	a5,a5,0x7
    80001470:	00007597          	auipc	a1,0x7
    80001474:	4b858593          	addi	a1,a1,1208 # 80008928 <cpus+0x8>
    80001478:	95be                	add	a1,a1,a5
    8000147a:	06048513          	addi	a0,s1,96
    8000147e:	00000097          	auipc	ra,0x0
    80001482:	666080e7          	jalr	1638(ra) # 80001ae4 <swtch>
    80001486:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    80001488:	2781                	sext.w	a5,a5
    8000148a:	079e                	slli	a5,a5,0x7
    8000148c:	993e                	add	s2,s2,a5
    8000148e:	0b392623          	sw	s3,172(s2)
}
    80001492:	70a2                	ld	ra,40(sp)
    80001494:	7402                	ld	s0,32(sp)
    80001496:	64e2                	ld	s1,24(sp)
    80001498:	6942                	ld	s2,16(sp)
    8000149a:	69a2                	ld	s3,8(sp)
    8000149c:	6145                	addi	sp,sp,48
    8000149e:	8082                	ret
        panic("sched p->lock");
    800014a0:	00007517          	auipc	a0,0x7
    800014a4:	cc050513          	addi	a0,a0,-832 # 80008160 <etext+0x160>
    800014a8:	00005097          	auipc	ra,0x5
    800014ac:	ac4080e7          	jalr	-1340(ra) # 80005f6c <panic>
        panic("sched locks");
    800014b0:	00007517          	auipc	a0,0x7
    800014b4:	cc050513          	addi	a0,a0,-832 # 80008170 <etext+0x170>
    800014b8:	00005097          	auipc	ra,0x5
    800014bc:	ab4080e7          	jalr	-1356(ra) # 80005f6c <panic>
        panic("sched running");
    800014c0:	00007517          	auipc	a0,0x7
    800014c4:	cc050513          	addi	a0,a0,-832 # 80008180 <etext+0x180>
    800014c8:	00005097          	auipc	ra,0x5
    800014cc:	aa4080e7          	jalr	-1372(ra) # 80005f6c <panic>
        panic("sched interruptible");
    800014d0:	00007517          	auipc	a0,0x7
    800014d4:	cc050513          	addi	a0,a0,-832 # 80008190 <etext+0x190>
    800014d8:	00005097          	auipc	ra,0x5
    800014dc:	a94080e7          	jalr	-1388(ra) # 80005f6c <panic>

00000000800014e0 <yield>:
{
    800014e0:	1101                	addi	sp,sp,-32
    800014e2:	ec06                	sd	ra,24(sp)
    800014e4:	e822                	sd	s0,16(sp)
    800014e6:	e426                	sd	s1,8(sp)
    800014e8:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    800014ea:	00000097          	auipc	ra,0x0
    800014ee:	950080e7          	jalr	-1712(ra) # 80000e3a <myproc>
    800014f2:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800014f4:	00005097          	auipc	ra,0x5
    800014f8:	fb0080e7          	jalr	-80(ra) # 800064a4 <acquire>
    p->state = RUNNABLE;
    800014fc:	478d                	li	a5,3
    800014fe:	cc9c                	sw	a5,24(s1)
    sched();
    80001500:	00000097          	auipc	ra,0x0
    80001504:	f0a080e7          	jalr	-246(ra) # 8000140a <sched>
    release(&p->lock);
    80001508:	8526                	mv	a0,s1
    8000150a:	00005097          	auipc	ra,0x5
    8000150e:	04e080e7          	jalr	78(ra) # 80006558 <release>
}
    80001512:	60e2                	ld	ra,24(sp)
    80001514:	6442                	ld	s0,16(sp)
    80001516:	64a2                	ld	s1,8(sp)
    80001518:	6105                	addi	sp,sp,32
    8000151a:	8082                	ret

000000008000151c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    8000151c:	7179                	addi	sp,sp,-48
    8000151e:	f406                	sd	ra,40(sp)
    80001520:	f022                	sd	s0,32(sp)
    80001522:	ec26                	sd	s1,24(sp)
    80001524:	e84a                	sd	s2,16(sp)
    80001526:	e44e                	sd	s3,8(sp)
    80001528:	1800                	addi	s0,sp,48
    8000152a:	89aa                	mv	s3,a0
    8000152c:	892e                	mv	s2,a1
    struct proc *p = myproc();
    8000152e:	00000097          	auipc	ra,0x0
    80001532:	90c080e7          	jalr	-1780(ra) # 80000e3a <myproc>
    80001536:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    80001538:	00005097          	auipc	ra,0x5
    8000153c:	f6c080e7          	jalr	-148(ra) # 800064a4 <acquire>
    release(lk);
    80001540:	854a                	mv	a0,s2
    80001542:	00005097          	auipc	ra,0x5
    80001546:	016080e7          	jalr	22(ra) # 80006558 <release>

    // Go to sleep.
    p->chan = chan;
    8000154a:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    8000154e:	4789                	li	a5,2
    80001550:	cc9c                	sw	a5,24(s1)

    sched();
    80001552:	00000097          	auipc	ra,0x0
    80001556:	eb8080e7          	jalr	-328(ra) # 8000140a <sched>

    // Tidy up.
    p->chan = 0;
    8000155a:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    8000155e:	8526                	mv	a0,s1
    80001560:	00005097          	auipc	ra,0x5
    80001564:	ff8080e7          	jalr	-8(ra) # 80006558 <release>
    acquire(lk);
    80001568:	854a                	mv	a0,s2
    8000156a:	00005097          	auipc	ra,0x5
    8000156e:	f3a080e7          	jalr	-198(ra) # 800064a4 <acquire>
}
    80001572:	70a2                	ld	ra,40(sp)
    80001574:	7402                	ld	s0,32(sp)
    80001576:	64e2                	ld	s1,24(sp)
    80001578:	6942                	ld	s2,16(sp)
    8000157a:	69a2                	ld	s3,8(sp)
    8000157c:	6145                	addi	sp,sp,48
    8000157e:	8082                	ret

0000000080001580 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    80001580:	7139                	addi	sp,sp,-64
    80001582:	fc06                	sd	ra,56(sp)
    80001584:	f822                	sd	s0,48(sp)
    80001586:	f426                	sd	s1,40(sp)
    80001588:	f04a                	sd	s2,32(sp)
    8000158a:	ec4e                	sd	s3,24(sp)
    8000158c:	e852                	sd	s4,16(sp)
    8000158e:	e456                	sd	s5,8(sp)
    80001590:	0080                	addi	s0,sp,64
    80001592:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++) {
    80001594:	00007497          	auipc	s1,0x7
    80001598:	78c48493          	addi	s1,s1,1932 # 80008d20 <proc>
        if (p != myproc()) {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan) {
    8000159c:	4989                	li	s3,2
                p->state = RUNNABLE;
    8000159e:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++) {
    800015a0:	00019917          	auipc	s2,0x19
    800015a4:	18090913          	addi	s2,s2,384 # 8001a720 <tickslock>
    800015a8:	a811                	j	800015bc <wakeup+0x3c>
            }
            release(&p->lock);
    800015aa:	8526                	mv	a0,s1
    800015ac:	00005097          	auipc	ra,0x5
    800015b0:	fac080e7          	jalr	-84(ra) # 80006558 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    800015b4:	46848493          	addi	s1,s1,1128
    800015b8:	03248663          	beq	s1,s2,800015e4 <wakeup+0x64>
        if (p != myproc()) {
    800015bc:	00000097          	auipc	ra,0x0
    800015c0:	87e080e7          	jalr	-1922(ra) # 80000e3a <myproc>
    800015c4:	fea488e3          	beq	s1,a0,800015b4 <wakeup+0x34>
            acquire(&p->lock);
    800015c8:	8526                	mv	a0,s1
    800015ca:	00005097          	auipc	ra,0x5
    800015ce:	eda080e7          	jalr	-294(ra) # 800064a4 <acquire>
            if (p->state == SLEEPING && p->chan == chan) {
    800015d2:	4c9c                	lw	a5,24(s1)
    800015d4:	fd379be3          	bne	a5,s3,800015aa <wakeup+0x2a>
    800015d8:	709c                	ld	a5,32(s1)
    800015da:	fd4798e3          	bne	a5,s4,800015aa <wakeup+0x2a>
                p->state = RUNNABLE;
    800015de:	0154ac23          	sw	s5,24(s1)
    800015e2:	b7e1                	j	800015aa <wakeup+0x2a>
        }
    }
}
    800015e4:	70e2                	ld	ra,56(sp)
    800015e6:	7442                	ld	s0,48(sp)
    800015e8:	74a2                	ld	s1,40(sp)
    800015ea:	7902                	ld	s2,32(sp)
    800015ec:	69e2                	ld	s3,24(sp)
    800015ee:	6a42                	ld	s4,16(sp)
    800015f0:	6aa2                	ld	s5,8(sp)
    800015f2:	6121                	addi	sp,sp,64
    800015f4:	8082                	ret

00000000800015f6 <reparent>:
{
    800015f6:	7179                	addi	sp,sp,-48
    800015f8:	f406                	sd	ra,40(sp)
    800015fa:	f022                	sd	s0,32(sp)
    800015fc:	ec26                	sd	s1,24(sp)
    800015fe:	e84a                	sd	s2,16(sp)
    80001600:	e44e                	sd	s3,8(sp)
    80001602:	e052                	sd	s4,0(sp)
    80001604:	1800                	addi	s0,sp,48
    80001606:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001608:	00007497          	auipc	s1,0x7
    8000160c:	71848493          	addi	s1,s1,1816 # 80008d20 <proc>
            pp->parent = initproc;
    80001610:	00007a17          	auipc	s4,0x7
    80001614:	2a0a0a13          	addi	s4,s4,672 # 800088b0 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001618:	00019997          	auipc	s3,0x19
    8000161c:	10898993          	addi	s3,s3,264 # 8001a720 <tickslock>
    80001620:	a029                	j	8000162a <reparent+0x34>
    80001622:	46848493          	addi	s1,s1,1128
    80001626:	01348d63          	beq	s1,s3,80001640 <reparent+0x4a>
        if (pp->parent == p) {
    8000162a:	7c9c                	ld	a5,56(s1)
    8000162c:	ff279be3          	bne	a5,s2,80001622 <reparent+0x2c>
            pp->parent = initproc;
    80001630:	000a3503          	ld	a0,0(s4)
    80001634:	fc88                	sd	a0,56(s1)
            wakeup(initproc);
    80001636:	00000097          	auipc	ra,0x0
    8000163a:	f4a080e7          	jalr	-182(ra) # 80001580 <wakeup>
    8000163e:	b7d5                	j	80001622 <reparent+0x2c>
}
    80001640:	70a2                	ld	ra,40(sp)
    80001642:	7402                	ld	s0,32(sp)
    80001644:	64e2                	ld	s1,24(sp)
    80001646:	6942                	ld	s2,16(sp)
    80001648:	69a2                	ld	s3,8(sp)
    8000164a:	6a02                	ld	s4,0(sp)
    8000164c:	6145                	addi	sp,sp,48
    8000164e:	8082                	ret

0000000080001650 <exit>:
{
    80001650:	7139                	addi	sp,sp,-64
    80001652:	fc06                	sd	ra,56(sp)
    80001654:	f822                	sd	s0,48(sp)
    80001656:	f426                	sd	s1,40(sp)
    80001658:	f04a                	sd	s2,32(sp)
    8000165a:	ec4e                	sd	s3,24(sp)
    8000165c:	e852                	sd	s4,16(sp)
    8000165e:	e456                	sd	s5,8(sp)
    80001660:	0080                	addi	s0,sp,64
    80001662:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    80001664:	fffff097          	auipc	ra,0xfffff
    80001668:	7d6080e7          	jalr	2006(ra) # 80000e3a <myproc>
    8000166c:	89aa                	mv	s3,a0
    if (p == initproc)
    8000166e:	00007797          	auipc	a5,0x7
    80001672:	2427b783          	ld	a5,578(a5) # 800088b0 <initproc>
    80001676:	0d050493          	addi	s1,a0,208
    8000167a:	15050913          	addi	s2,a0,336
    8000167e:	02a79363          	bne	a5,a0,800016a4 <exit+0x54>
        panic("init exiting");
    80001682:	00007517          	auipc	a0,0x7
    80001686:	b2650513          	addi	a0,a0,-1242 # 800081a8 <etext+0x1a8>
    8000168a:	00005097          	auipc	ra,0x5
    8000168e:	8e2080e7          	jalr	-1822(ra) # 80005f6c <panic>
            fileclose(f);
    80001692:	00002097          	auipc	ra,0x2
    80001696:	47e080e7          	jalr	1150(ra) # 80003b10 <fileclose>
            p->ofile[fd] = 0;
    8000169a:	0004b023          	sd	zero,0(s1)
    for (int fd = 0; fd < NOFILE; fd++) {
    8000169e:	04a1                	addi	s1,s1,8
    800016a0:	01248563          	beq	s1,s2,800016aa <exit+0x5a>
        if (p->ofile[fd]) {
    800016a4:	6088                	ld	a0,0(s1)
    800016a6:	f575                	bnez	a0,80001692 <exit+0x42>
    800016a8:	bfdd                	j	8000169e <exit+0x4e>
    800016aa:	16898493          	addi	s1,s3,360
    800016ae:	46898a93          	addi	s5,s3,1128
    800016b2:	a83d                	j	800016f0 <exit+0xa0>
            fileclose(p->vma[i].fp);                                              // refcount--
    800016b4:	02893503          	ld	a0,40(s2)
    800016b8:	00002097          	auipc	ra,0x2
    800016bc:	458080e7          	jalr	1112(ra) # 80003b10 <fileclose>
            uvmunmap(p->pagetable, p->vma[i].addr, p->vma[i].length / PGSIZE, 1); // 取消虚拟内存映射
    800016c0:	01092783          	lw	a5,16(s2)
    800016c4:	41f7d61b          	sraiw	a2,a5,0x1f
    800016c8:	0146561b          	srliw	a2,a2,0x14
    800016cc:	9e3d                	addw	a2,a2,a5
    800016ce:	4685                	li	a3,1
    800016d0:	40c6561b          	sraiw	a2,a2,0xc
    800016d4:	00893583          	ld	a1,8(s2)
    800016d8:	0509b503          	ld	a0,80(s3)
    800016dc:	fffff097          	auipc	ra,0xfffff
    800016e0:	030080e7          	jalr	48(ra) # 8000070c <uvmunmap>
            p->vma[i].used = 0;                                                   // 恢复可用状态
    800016e4:	00092023          	sw	zero,0(s2)
    for (int i = 0; i < VMASIZE; i++) {
    800016e8:	03048493          	addi	s1,s1,48
    800016ec:	03548063          	beq	s1,s5,8000170c <exit+0xbc>
        if (p->vma[i].used) {                 // 占用状态下的vma，全部清空
    800016f0:	8926                	mv	s2,s1
    800016f2:	409c                	lw	a5,0(s1)
    800016f4:	dbf5                	beqz	a5,800016e8 <exit+0x98>
            if (p->vma[i].flags & MAP_SHARED) // 该写回的全部写回磁盘文件
    800016f6:	4c9c                	lw	a5,24(s1)
    800016f8:	8b85                	andi	a5,a5,1
    800016fa:	dfcd                	beqz	a5,800016b4 <exit+0x64>
                filewrite(p->vma[i].fp, p->vma[i].addr, p->vma[i].length);
    800016fc:	4890                	lw	a2,16(s1)
    800016fe:	648c                	ld	a1,8(s1)
    80001700:	7488                	ld	a0,40(s1)
    80001702:	00002097          	auipc	ra,0x2
    80001706:	60a080e7          	jalr	1546(ra) # 80003d0c <filewrite>
    8000170a:	b76d                	j	800016b4 <exit+0x64>
    begin_op();
    8000170c:	00002097          	auipc	ra,0x2
    80001710:	f3c080e7          	jalr	-196(ra) # 80003648 <begin_op>
    iput(p->cwd);
    80001714:	1509b503          	ld	a0,336(s3)
    80001718:	00001097          	auipc	ra,0x1
    8000171c:	71e080e7          	jalr	1822(ra) # 80002e36 <iput>
    end_op();
    80001720:	00002097          	auipc	ra,0x2
    80001724:	fa6080e7          	jalr	-90(ra) # 800036c6 <end_op>
    p->cwd = 0;
    80001728:	1409b823          	sd	zero,336(s3)
    acquire(&wait_lock);
    8000172c:	00007497          	auipc	s1,0x7
    80001730:	1dc48493          	addi	s1,s1,476 # 80008908 <wait_lock>
    80001734:	8526                	mv	a0,s1
    80001736:	00005097          	auipc	ra,0x5
    8000173a:	d6e080e7          	jalr	-658(ra) # 800064a4 <acquire>
    reparent(p);
    8000173e:	854e                	mv	a0,s3
    80001740:	00000097          	auipc	ra,0x0
    80001744:	eb6080e7          	jalr	-330(ra) # 800015f6 <reparent>
    wakeup(p->parent);
    80001748:	0389b503          	ld	a0,56(s3)
    8000174c:	00000097          	auipc	ra,0x0
    80001750:	e34080e7          	jalr	-460(ra) # 80001580 <wakeup>
    acquire(&p->lock);
    80001754:	854e                	mv	a0,s3
    80001756:	00005097          	auipc	ra,0x5
    8000175a:	d4e080e7          	jalr	-690(ra) # 800064a4 <acquire>
    p->xstate = status;
    8000175e:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    80001762:	4795                	li	a5,5
    80001764:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    80001768:	8526                	mv	a0,s1
    8000176a:	00005097          	auipc	ra,0x5
    8000176e:	dee080e7          	jalr	-530(ra) # 80006558 <release>
    sched();
    80001772:	00000097          	auipc	ra,0x0
    80001776:	c98080e7          	jalr	-872(ra) # 8000140a <sched>
    panic("zombie exit");
    8000177a:	00007517          	auipc	a0,0x7
    8000177e:	a3e50513          	addi	a0,a0,-1474 # 800081b8 <etext+0x1b8>
    80001782:	00004097          	auipc	ra,0x4
    80001786:	7ea080e7          	jalr	2026(ra) # 80005f6c <panic>

000000008000178a <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    8000178a:	7179                	addi	sp,sp,-48
    8000178c:	f406                	sd	ra,40(sp)
    8000178e:	f022                	sd	s0,32(sp)
    80001790:	ec26                	sd	s1,24(sp)
    80001792:	e84a                	sd	s2,16(sp)
    80001794:	e44e                	sd	s3,8(sp)
    80001796:	1800                	addi	s0,sp,48
    80001798:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++) {
    8000179a:	00007497          	auipc	s1,0x7
    8000179e:	58648493          	addi	s1,s1,1414 # 80008d20 <proc>
    800017a2:	00019997          	auipc	s3,0x19
    800017a6:	f7e98993          	addi	s3,s3,-130 # 8001a720 <tickslock>
        acquire(&p->lock);
    800017aa:	8526                	mv	a0,s1
    800017ac:	00005097          	auipc	ra,0x5
    800017b0:	cf8080e7          	jalr	-776(ra) # 800064a4 <acquire>
        if (p->pid == pid) {
    800017b4:	589c                	lw	a5,48(s1)
    800017b6:	01278d63          	beq	a5,s2,800017d0 <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    800017ba:	8526                	mv	a0,s1
    800017bc:	00005097          	auipc	ra,0x5
    800017c0:	d9c080e7          	jalr	-612(ra) # 80006558 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    800017c4:	46848493          	addi	s1,s1,1128
    800017c8:	ff3491e3          	bne	s1,s3,800017aa <kill+0x20>
    }
    return -1;
    800017cc:	557d                	li	a0,-1
    800017ce:	a829                	j	800017e8 <kill+0x5e>
            p->killed = 1;
    800017d0:	4785                	li	a5,1
    800017d2:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING) {
    800017d4:	4c98                	lw	a4,24(s1)
    800017d6:	4789                	li	a5,2
    800017d8:	00f70f63          	beq	a4,a5,800017f6 <kill+0x6c>
            release(&p->lock);
    800017dc:	8526                	mv	a0,s1
    800017de:	00005097          	auipc	ra,0x5
    800017e2:	d7a080e7          	jalr	-646(ra) # 80006558 <release>
            return 0;
    800017e6:	4501                	li	a0,0
}
    800017e8:	70a2                	ld	ra,40(sp)
    800017ea:	7402                	ld	s0,32(sp)
    800017ec:	64e2                	ld	s1,24(sp)
    800017ee:	6942                	ld	s2,16(sp)
    800017f0:	69a2                	ld	s3,8(sp)
    800017f2:	6145                	addi	sp,sp,48
    800017f4:	8082                	ret
                p->state = RUNNABLE;
    800017f6:	478d                	li	a5,3
    800017f8:	cc9c                	sw	a5,24(s1)
    800017fa:	b7cd                	j	800017dc <kill+0x52>

00000000800017fc <setkilled>:

void setkilled(struct proc *p)
{
    800017fc:	1101                	addi	sp,sp,-32
    800017fe:	ec06                	sd	ra,24(sp)
    80001800:	e822                	sd	s0,16(sp)
    80001802:	e426                	sd	s1,8(sp)
    80001804:	1000                	addi	s0,sp,32
    80001806:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80001808:	00005097          	auipc	ra,0x5
    8000180c:	c9c080e7          	jalr	-868(ra) # 800064a4 <acquire>
    p->killed = 1;
    80001810:	4785                	li	a5,1
    80001812:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    80001814:	8526                	mv	a0,s1
    80001816:	00005097          	auipc	ra,0x5
    8000181a:	d42080e7          	jalr	-702(ra) # 80006558 <release>
}
    8000181e:	60e2                	ld	ra,24(sp)
    80001820:	6442                	ld	s0,16(sp)
    80001822:	64a2                	ld	s1,8(sp)
    80001824:	6105                	addi	sp,sp,32
    80001826:	8082                	ret

0000000080001828 <killed>:

int killed(struct proc *p)
{
    80001828:	1101                	addi	sp,sp,-32
    8000182a:	ec06                	sd	ra,24(sp)
    8000182c:	e822                	sd	s0,16(sp)
    8000182e:	e426                	sd	s1,8(sp)
    80001830:	e04a                	sd	s2,0(sp)
    80001832:	1000                	addi	s0,sp,32
    80001834:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    80001836:	00005097          	auipc	ra,0x5
    8000183a:	c6e080e7          	jalr	-914(ra) # 800064a4 <acquire>
    k = p->killed;
    8000183e:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    80001842:	8526                	mv	a0,s1
    80001844:	00005097          	auipc	ra,0x5
    80001848:	d14080e7          	jalr	-748(ra) # 80006558 <release>
    return k;
}
    8000184c:	854a                	mv	a0,s2
    8000184e:	60e2                	ld	ra,24(sp)
    80001850:	6442                	ld	s0,16(sp)
    80001852:	64a2                	ld	s1,8(sp)
    80001854:	6902                	ld	s2,0(sp)
    80001856:	6105                	addi	sp,sp,32
    80001858:	8082                	ret

000000008000185a <wait>:
{
    8000185a:	715d                	addi	sp,sp,-80
    8000185c:	e486                	sd	ra,72(sp)
    8000185e:	e0a2                	sd	s0,64(sp)
    80001860:	fc26                	sd	s1,56(sp)
    80001862:	f84a                	sd	s2,48(sp)
    80001864:	f44e                	sd	s3,40(sp)
    80001866:	f052                	sd	s4,32(sp)
    80001868:	ec56                	sd	s5,24(sp)
    8000186a:	e85a                	sd	s6,16(sp)
    8000186c:	e45e                	sd	s7,8(sp)
    8000186e:	e062                	sd	s8,0(sp)
    80001870:	0880                	addi	s0,sp,80
    80001872:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    80001874:	fffff097          	auipc	ra,0xfffff
    80001878:	5c6080e7          	jalr	1478(ra) # 80000e3a <myproc>
    8000187c:	892a                	mv	s2,a0
    acquire(&wait_lock);
    8000187e:	00007517          	auipc	a0,0x7
    80001882:	08a50513          	addi	a0,a0,138 # 80008908 <wait_lock>
    80001886:	00005097          	auipc	ra,0x5
    8000188a:	c1e080e7          	jalr	-994(ra) # 800064a4 <acquire>
        havekids = 0;
    8000188e:	4b81                	li	s7,0
                if (pp->state == ZOMBIE) {
    80001890:	4a15                	li	s4,5
                havekids = 1;
    80001892:	4a85                	li	s5,1
        for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001894:	00019997          	auipc	s3,0x19
    80001898:	e8c98993          	addi	s3,s3,-372 # 8001a720 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    8000189c:	00007c17          	auipc	s8,0x7
    800018a0:	06cc0c13          	addi	s8,s8,108 # 80008908 <wait_lock>
        havekids = 0;
    800018a4:	875e                	mv	a4,s7
        for (pp = proc; pp < &proc[NPROC]; pp++) {
    800018a6:	00007497          	auipc	s1,0x7
    800018aa:	47a48493          	addi	s1,s1,1146 # 80008d20 <proc>
    800018ae:	a0bd                	j	8000191c <wait+0xc2>
                    pid = pp->pid;
    800018b0:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate, sizeof(pp->xstate)) < 0) {
    800018b4:	000b0e63          	beqz	s6,800018d0 <wait+0x76>
    800018b8:	4691                	li	a3,4
    800018ba:	02c48613          	addi	a2,s1,44
    800018be:	85da                	mv	a1,s6
    800018c0:	05093503          	ld	a0,80(s2)
    800018c4:	fffff097          	auipc	ra,0xfffff
    800018c8:	236080e7          	jalr	566(ra) # 80000afa <copyout>
    800018cc:	02054563          	bltz	a0,800018f6 <wait+0x9c>
                    freeproc(pp);
    800018d0:	8526                	mv	a0,s1
    800018d2:	fffff097          	auipc	ra,0xfffff
    800018d6:	71a080e7          	jalr	1818(ra) # 80000fec <freeproc>
                    release(&pp->lock);
    800018da:	8526                	mv	a0,s1
    800018dc:	00005097          	auipc	ra,0x5
    800018e0:	c7c080e7          	jalr	-900(ra) # 80006558 <release>
                    release(&wait_lock);
    800018e4:	00007517          	auipc	a0,0x7
    800018e8:	02450513          	addi	a0,a0,36 # 80008908 <wait_lock>
    800018ec:	00005097          	auipc	ra,0x5
    800018f0:	c6c080e7          	jalr	-916(ra) # 80006558 <release>
                    return pid;
    800018f4:	a0b5                	j	80001960 <wait+0x106>
                        release(&pp->lock);
    800018f6:	8526                	mv	a0,s1
    800018f8:	00005097          	auipc	ra,0x5
    800018fc:	c60080e7          	jalr	-928(ra) # 80006558 <release>
                        release(&wait_lock);
    80001900:	00007517          	auipc	a0,0x7
    80001904:	00850513          	addi	a0,a0,8 # 80008908 <wait_lock>
    80001908:	00005097          	auipc	ra,0x5
    8000190c:	c50080e7          	jalr	-944(ra) # 80006558 <release>
                        return -1;
    80001910:	59fd                	li	s3,-1
    80001912:	a0b9                	j	80001960 <wait+0x106>
        for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001914:	46848493          	addi	s1,s1,1128
    80001918:	03348463          	beq	s1,s3,80001940 <wait+0xe6>
            if (pp->parent == p) {
    8000191c:	7c9c                	ld	a5,56(s1)
    8000191e:	ff279be3          	bne	a5,s2,80001914 <wait+0xba>
                acquire(&pp->lock);
    80001922:	8526                	mv	a0,s1
    80001924:	00005097          	auipc	ra,0x5
    80001928:	b80080e7          	jalr	-1152(ra) # 800064a4 <acquire>
                if (pp->state == ZOMBIE) {
    8000192c:	4c9c                	lw	a5,24(s1)
    8000192e:	f94781e3          	beq	a5,s4,800018b0 <wait+0x56>
                release(&pp->lock);
    80001932:	8526                	mv	a0,s1
    80001934:	00005097          	auipc	ra,0x5
    80001938:	c24080e7          	jalr	-988(ra) # 80006558 <release>
                havekids = 1;
    8000193c:	8756                	mv	a4,s5
    8000193e:	bfd9                	j	80001914 <wait+0xba>
        if (!havekids || killed(p)) {
    80001940:	c719                	beqz	a4,8000194e <wait+0xf4>
    80001942:	854a                	mv	a0,s2
    80001944:	00000097          	auipc	ra,0x0
    80001948:	ee4080e7          	jalr	-284(ra) # 80001828 <killed>
    8000194c:	c51d                	beqz	a0,8000197a <wait+0x120>
            release(&wait_lock);
    8000194e:	00007517          	auipc	a0,0x7
    80001952:	fba50513          	addi	a0,a0,-70 # 80008908 <wait_lock>
    80001956:	00005097          	auipc	ra,0x5
    8000195a:	c02080e7          	jalr	-1022(ra) # 80006558 <release>
            return -1;
    8000195e:	59fd                	li	s3,-1
}
    80001960:	854e                	mv	a0,s3
    80001962:	60a6                	ld	ra,72(sp)
    80001964:	6406                	ld	s0,64(sp)
    80001966:	74e2                	ld	s1,56(sp)
    80001968:	7942                	ld	s2,48(sp)
    8000196a:	79a2                	ld	s3,40(sp)
    8000196c:	7a02                	ld	s4,32(sp)
    8000196e:	6ae2                	ld	s5,24(sp)
    80001970:	6b42                	ld	s6,16(sp)
    80001972:	6ba2                	ld	s7,8(sp)
    80001974:	6c02                	ld	s8,0(sp)
    80001976:	6161                	addi	sp,sp,80
    80001978:	8082                	ret
        sleep(p, &wait_lock); // DOC: wait-sleep
    8000197a:	85e2                	mv	a1,s8
    8000197c:	854a                	mv	a0,s2
    8000197e:	00000097          	auipc	ra,0x0
    80001982:	b9e080e7          	jalr	-1122(ra) # 8000151c <sleep>
        havekids = 0;
    80001986:	bf39                	j	800018a4 <wait+0x4a>

0000000080001988 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001988:	7179                	addi	sp,sp,-48
    8000198a:	f406                	sd	ra,40(sp)
    8000198c:	f022                	sd	s0,32(sp)
    8000198e:	ec26                	sd	s1,24(sp)
    80001990:	e84a                	sd	s2,16(sp)
    80001992:	e44e                	sd	s3,8(sp)
    80001994:	e052                	sd	s4,0(sp)
    80001996:	1800                	addi	s0,sp,48
    80001998:	84aa                	mv	s1,a0
    8000199a:	892e                	mv	s2,a1
    8000199c:	89b2                	mv	s3,a2
    8000199e:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    800019a0:	fffff097          	auipc	ra,0xfffff
    800019a4:	49a080e7          	jalr	1178(ra) # 80000e3a <myproc>
    if (user_dst) {
    800019a8:	c08d                	beqz	s1,800019ca <either_copyout+0x42>
        return copyout(p->pagetable, dst, src, len);
    800019aa:	86d2                	mv	a3,s4
    800019ac:	864e                	mv	a2,s3
    800019ae:	85ca                	mv	a1,s2
    800019b0:	6928                	ld	a0,80(a0)
    800019b2:	fffff097          	auipc	ra,0xfffff
    800019b6:	148080e7          	jalr	328(ra) # 80000afa <copyout>
    }
    else {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    800019ba:	70a2                	ld	ra,40(sp)
    800019bc:	7402                	ld	s0,32(sp)
    800019be:	64e2                	ld	s1,24(sp)
    800019c0:	6942                	ld	s2,16(sp)
    800019c2:	69a2                	ld	s3,8(sp)
    800019c4:	6a02                	ld	s4,0(sp)
    800019c6:	6145                	addi	sp,sp,48
    800019c8:	8082                	ret
        memmove((char *)dst, src, len);
    800019ca:	000a061b          	sext.w	a2,s4
    800019ce:	85ce                	mv	a1,s3
    800019d0:	854a                	mv	a0,s2
    800019d2:	fffff097          	auipc	ra,0xfffff
    800019d6:	804080e7          	jalr	-2044(ra) # 800001d6 <memmove>
        return 0;
    800019da:	8526                	mv	a0,s1
    800019dc:	bff9                	j	800019ba <either_copyout+0x32>

00000000800019de <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019de:	7179                	addi	sp,sp,-48
    800019e0:	f406                	sd	ra,40(sp)
    800019e2:	f022                	sd	s0,32(sp)
    800019e4:	ec26                	sd	s1,24(sp)
    800019e6:	e84a                	sd	s2,16(sp)
    800019e8:	e44e                	sd	s3,8(sp)
    800019ea:	e052                	sd	s4,0(sp)
    800019ec:	1800                	addi	s0,sp,48
    800019ee:	892a                	mv	s2,a0
    800019f0:	84ae                	mv	s1,a1
    800019f2:	89b2                	mv	s3,a2
    800019f4:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    800019f6:	fffff097          	auipc	ra,0xfffff
    800019fa:	444080e7          	jalr	1092(ra) # 80000e3a <myproc>
    if (user_src) {
    800019fe:	c08d                	beqz	s1,80001a20 <either_copyin+0x42>
        return copyin(p->pagetable, dst, src, len);
    80001a00:	86d2                	mv	a3,s4
    80001a02:	864e                	mv	a2,s3
    80001a04:	85ca                	mv	a1,s2
    80001a06:	6928                	ld	a0,80(a0)
    80001a08:	fffff097          	auipc	ra,0xfffff
    80001a0c:	17e080e7          	jalr	382(ra) # 80000b86 <copyin>
    }
    else {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    80001a10:	70a2                	ld	ra,40(sp)
    80001a12:	7402                	ld	s0,32(sp)
    80001a14:	64e2                	ld	s1,24(sp)
    80001a16:	6942                	ld	s2,16(sp)
    80001a18:	69a2                	ld	s3,8(sp)
    80001a1a:	6a02                	ld	s4,0(sp)
    80001a1c:	6145                	addi	sp,sp,48
    80001a1e:	8082                	ret
        memmove(dst, (char *)src, len);
    80001a20:	000a061b          	sext.w	a2,s4
    80001a24:	85ce                	mv	a1,s3
    80001a26:	854a                	mv	a0,s2
    80001a28:	ffffe097          	auipc	ra,0xffffe
    80001a2c:	7ae080e7          	jalr	1966(ra) # 800001d6 <memmove>
        return 0;
    80001a30:	8526                	mv	a0,s1
    80001a32:	bff9                	j	80001a10 <either_copyin+0x32>

0000000080001a34 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80001a34:	715d                	addi	sp,sp,-80
    80001a36:	e486                	sd	ra,72(sp)
    80001a38:	e0a2                	sd	s0,64(sp)
    80001a3a:	fc26                	sd	s1,56(sp)
    80001a3c:	f84a                	sd	s2,48(sp)
    80001a3e:	f44e                	sd	s3,40(sp)
    80001a40:	f052                	sd	s4,32(sp)
    80001a42:	ec56                	sd	s5,24(sp)
    80001a44:	e85a                	sd	s6,16(sp)
    80001a46:	e45e                	sd	s7,8(sp)
    80001a48:	0880                	addi	s0,sp,80
    static char *states[] = {[UNUSED] "unused", [USED] "used", [SLEEPING] "sleep ", [RUNNABLE] "runble", [RUNNING] "run   ", [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    80001a4a:	00006517          	auipc	a0,0x6
    80001a4e:	5fe50513          	addi	a0,a0,1534 # 80008048 <etext+0x48>
    80001a52:	00004097          	auipc	ra,0x4
    80001a56:	564080e7          	jalr	1380(ra) # 80005fb6 <printf>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001a5a:	00007497          	auipc	s1,0x7
    80001a5e:	41e48493          	addi	s1,s1,1054 # 80008e78 <proc+0x158>
    80001a62:	00019917          	auipc	s2,0x19
    80001a66:	e1690913          	addi	s2,s2,-490 # 8001a878 <bcache+0x140>
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a6a:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    80001a6c:	00006997          	auipc	s3,0x6
    80001a70:	75c98993          	addi	s3,s3,1884 # 800081c8 <etext+0x1c8>
        printf("%d %s %s", p->pid, state, p->name);
    80001a74:	00006a97          	auipc	s5,0x6
    80001a78:	75ca8a93          	addi	s5,s5,1884 # 800081d0 <etext+0x1d0>
        printf("\n");
    80001a7c:	00006a17          	auipc	s4,0x6
    80001a80:	5cca0a13          	addi	s4,s4,1484 # 80008048 <etext+0x48>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a84:	00006b97          	auipc	s7,0x6
    80001a88:	78cb8b93          	addi	s7,s7,1932 # 80008210 <states.0>
    80001a8c:	a00d                	j	80001aae <procdump+0x7a>
        printf("%d %s %s", p->pid, state, p->name);
    80001a8e:	ed86a583          	lw	a1,-296(a3)
    80001a92:	8556                	mv	a0,s5
    80001a94:	00004097          	auipc	ra,0x4
    80001a98:	522080e7          	jalr	1314(ra) # 80005fb6 <printf>
        printf("\n");
    80001a9c:	8552                	mv	a0,s4
    80001a9e:	00004097          	auipc	ra,0x4
    80001aa2:	518080e7          	jalr	1304(ra) # 80005fb6 <printf>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001aa6:	46848493          	addi	s1,s1,1128
    80001aaa:	03248263          	beq	s1,s2,80001ace <procdump+0x9a>
        if (p->state == UNUSED)
    80001aae:	86a6                	mv	a3,s1
    80001ab0:	ec04a783          	lw	a5,-320(s1)
    80001ab4:	dbed                	beqz	a5,80001aa6 <procdump+0x72>
            state = "???";
    80001ab6:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ab8:	fcfb6be3          	bltu	s6,a5,80001a8e <procdump+0x5a>
    80001abc:	02079713          	slli	a4,a5,0x20
    80001ac0:	01d75793          	srli	a5,a4,0x1d
    80001ac4:	97de                	add	a5,a5,s7
    80001ac6:	6390                	ld	a2,0(a5)
    80001ac8:	f279                	bnez	a2,80001a8e <procdump+0x5a>
            state = "???";
    80001aca:	864e                	mv	a2,s3
    80001acc:	b7c9                	j	80001a8e <procdump+0x5a>
    }
}
    80001ace:	60a6                	ld	ra,72(sp)
    80001ad0:	6406                	ld	s0,64(sp)
    80001ad2:	74e2                	ld	s1,56(sp)
    80001ad4:	7942                	ld	s2,48(sp)
    80001ad6:	79a2                	ld	s3,40(sp)
    80001ad8:	7a02                	ld	s4,32(sp)
    80001ada:	6ae2                	ld	s5,24(sp)
    80001adc:	6b42                	ld	s6,16(sp)
    80001ade:	6ba2                	ld	s7,8(sp)
    80001ae0:	6161                	addi	sp,sp,80
    80001ae2:	8082                	ret

0000000080001ae4 <swtch>:
    80001ae4:	00153023          	sd	ra,0(a0)
    80001ae8:	00253423          	sd	sp,8(a0)
    80001aec:	e900                	sd	s0,16(a0)
    80001aee:	ed04                	sd	s1,24(a0)
    80001af0:	03253023          	sd	s2,32(a0)
    80001af4:	03353423          	sd	s3,40(a0)
    80001af8:	03453823          	sd	s4,48(a0)
    80001afc:	03553c23          	sd	s5,56(a0)
    80001b00:	05653023          	sd	s6,64(a0)
    80001b04:	05753423          	sd	s7,72(a0)
    80001b08:	05853823          	sd	s8,80(a0)
    80001b0c:	05953c23          	sd	s9,88(a0)
    80001b10:	07a53023          	sd	s10,96(a0)
    80001b14:	07b53423          	sd	s11,104(a0)
    80001b18:	0005b083          	ld	ra,0(a1)
    80001b1c:	0085b103          	ld	sp,8(a1)
    80001b20:	6980                	ld	s0,16(a1)
    80001b22:	6d84                	ld	s1,24(a1)
    80001b24:	0205b903          	ld	s2,32(a1)
    80001b28:	0285b983          	ld	s3,40(a1)
    80001b2c:	0305ba03          	ld	s4,48(a1)
    80001b30:	0385ba83          	ld	s5,56(a1)
    80001b34:	0405bb03          	ld	s6,64(a1)
    80001b38:	0485bb83          	ld	s7,72(a1)
    80001b3c:	0505bc03          	ld	s8,80(a1)
    80001b40:	0585bc83          	ld	s9,88(a1)
    80001b44:	0605bd03          	ld	s10,96(a1)
    80001b48:	0685bd83          	ld	s11,104(a1)
    80001b4c:	8082                	ret

0000000080001b4e <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80001b4e:	1141                	addi	sp,sp,-16
    80001b50:	e406                	sd	ra,8(sp)
    80001b52:	e022                	sd	s0,0(sp)
    80001b54:	0800                	addi	s0,sp,16
    initlock(&tickslock, "time");
    80001b56:	00006597          	auipc	a1,0x6
    80001b5a:	6ea58593          	addi	a1,a1,1770 # 80008240 <states.0+0x30>
    80001b5e:	00019517          	auipc	a0,0x19
    80001b62:	bc250513          	addi	a0,a0,-1086 # 8001a720 <tickslock>
    80001b66:	00005097          	auipc	ra,0x5
    80001b6a:	8ae080e7          	jalr	-1874(ra) # 80006414 <initlock>
}
    80001b6e:	60a2                	ld	ra,8(sp)
    80001b70:	6402                	ld	s0,0(sp)
    80001b72:	0141                	addi	sp,sp,16
    80001b74:	8082                	ret

0000000080001b76 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80001b76:	1141                	addi	sp,sp,-16
    80001b78:	e422                	sd	s0,8(sp)
    80001b7a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b7c:	00004797          	auipc	a5,0x4
    80001b80:	82478793          	addi	a5,a5,-2012 # 800053a0 <kernelvec>
    80001b84:	10579073          	csrw	stvec,a5
    w_stvec((uint64)kernelvec);
}
    80001b88:	6422                	ld	s0,8(sp)
    80001b8a:	0141                	addi	sp,sp,16
    80001b8c:	8082                	ret

0000000080001b8e <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80001b8e:	1141                	addi	sp,sp,-16
    80001b90:	e406                	sd	ra,8(sp)
    80001b92:	e022                	sd	s0,0(sp)
    80001b94:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80001b96:	fffff097          	auipc	ra,0xfffff
    80001b9a:	2a4080e7          	jalr	676(ra) # 80000e3a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b9e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ba2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ba4:	10079073          	csrw	sstatus,a5
    // kerneltrap() to usertrap(), so turn off interrupts until
    // we're back in user space, where usertrap() is correct.
    intr_off();

    // send syscalls, interrupts, and exceptions to uservec in trampoline.S
    uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001ba8:	00005697          	auipc	a3,0x5
    80001bac:	45868693          	addi	a3,a3,1112 # 80007000 <_trampoline>
    80001bb0:	00005717          	auipc	a4,0x5
    80001bb4:	45070713          	addi	a4,a4,1104 # 80007000 <_trampoline>
    80001bb8:	8f15                	sub	a4,a4,a3
    80001bba:	040007b7          	lui	a5,0x4000
    80001bbe:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001bc0:	07b2                	slli	a5,a5,0xc
    80001bc2:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bc4:	10571073          	csrw	stvec,a4
    w_stvec(trampoline_uservec);

    // set up trapframe values that uservec will need when
    // the process next traps into the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001bc8:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001bca:	18002673          	csrr	a2,satp
    80001bce:	e310                	sd	a2,0(a4)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001bd0:	6d30                	ld	a2,88(a0)
    80001bd2:	6138                	ld	a4,64(a0)
    80001bd4:	6585                	lui	a1,0x1
    80001bd6:	972e                	add	a4,a4,a1
    80001bd8:	e618                	sd	a4,8(a2)
    p->trapframe->kernel_trap = (uint64)usertrap;
    80001bda:	6d38                	ld	a4,88(a0)
    80001bdc:	00000617          	auipc	a2,0x0
    80001be0:	13060613          	addi	a2,a2,304 # 80001d0c <usertrap>
    80001be4:	eb10                	sd	a2,16(a4)
    p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80001be6:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001be8:	8612                	mv	a2,tp
    80001bea:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bec:	10002773          	csrr	a4,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bf0:	eff77713          	andi	a4,a4,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bf4:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bf8:	10071073          	csrw	sstatus,a4
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
    80001bfc:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bfe:	6f18                	ld	a4,24(a4)
    80001c00:	14171073          	csrw	sepc,a4

    // tell trampoline.S the user page table to switch to.
    uint64 satp = MAKE_SATP(p->pagetable);
    80001c04:	6928                	ld	a0,80(a0)
    80001c06:	8131                	srli	a0,a0,0xc

    // jump to userret in trampoline.S at the top of memory, which
    // switches to the user page table, restores user registers,
    // and switches to user mode with sret.
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001c08:	00005717          	auipc	a4,0x5
    80001c0c:	49470713          	addi	a4,a4,1172 # 8000709c <userret>
    80001c10:	8f15                	sub	a4,a4,a3
    80001c12:	97ba                	add	a5,a5,a4
    ((void (*)(uint64))trampoline_userret)(satp);
    80001c14:	577d                	li	a4,-1
    80001c16:	177e                	slli	a4,a4,0x3f
    80001c18:	8d59                	or	a0,a0,a4
    80001c1a:	9782                	jalr	a5
}
    80001c1c:	60a2                	ld	ra,8(sp)
    80001c1e:	6402                	ld	s0,0(sp)
    80001c20:	0141                	addi	sp,sp,16
    80001c22:	8082                	ret

0000000080001c24 <clockintr>:
    w_sepc(sepc);
    w_sstatus(sstatus);
}

void clockintr()
{
    80001c24:	1101                	addi	sp,sp,-32
    80001c26:	ec06                	sd	ra,24(sp)
    80001c28:	e822                	sd	s0,16(sp)
    80001c2a:	e426                	sd	s1,8(sp)
    80001c2c:	1000                	addi	s0,sp,32
    acquire(&tickslock);
    80001c2e:	00019497          	auipc	s1,0x19
    80001c32:	af248493          	addi	s1,s1,-1294 # 8001a720 <tickslock>
    80001c36:	8526                	mv	a0,s1
    80001c38:	00005097          	auipc	ra,0x5
    80001c3c:	86c080e7          	jalr	-1940(ra) # 800064a4 <acquire>
    ticks++;
    80001c40:	00007517          	auipc	a0,0x7
    80001c44:	c7850513          	addi	a0,a0,-904 # 800088b8 <ticks>
    80001c48:	411c                	lw	a5,0(a0)
    80001c4a:	2785                	addiw	a5,a5,1
    80001c4c:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001c4e:	00000097          	auipc	ra,0x0
    80001c52:	932080e7          	jalr	-1742(ra) # 80001580 <wakeup>
    release(&tickslock);
    80001c56:	8526                	mv	a0,s1
    80001c58:	00005097          	auipc	ra,0x5
    80001c5c:	900080e7          	jalr	-1792(ra) # 80006558 <release>
}
    80001c60:	60e2                	ld	ra,24(sp)
    80001c62:	6442                	ld	s0,16(sp)
    80001c64:	64a2                	ld	s1,8(sp)
    80001c66:	6105                	addi	sp,sp,32
    80001c68:	8082                	ret

0000000080001c6a <devintr>:
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr()
{
    80001c6a:	1101                	addi	sp,sp,-32
    80001c6c:	ec06                	sd	ra,24(sp)
    80001c6e:	e822                	sd	s0,16(sp)
    80001c70:	e426                	sd	s1,8(sp)
    80001c72:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c74:	14202773          	csrr	a4,scause
    uint64 scause = r_scause();

    if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001c78:	00074d63          	bltz	a4,80001c92 <devintr+0x28>
        if (irq)
            plic_complete(irq);

        return 1;
    }
    else if (scause == 0x8000000000000001L) {
    80001c7c:	57fd                	li	a5,-1
    80001c7e:	17fe                	slli	a5,a5,0x3f
    80001c80:	0785                	addi	a5,a5,1
        w_sip(r_sip() & ~2);

        return 2;
    }
    else {
        return 0;
    80001c82:	4501                	li	a0,0
    else if (scause == 0x8000000000000001L) {
    80001c84:	06f70363          	beq	a4,a5,80001cea <devintr+0x80>
    }
}
    80001c88:	60e2                	ld	ra,24(sp)
    80001c8a:	6442                	ld	s0,16(sp)
    80001c8c:	64a2                	ld	s1,8(sp)
    80001c8e:	6105                	addi	sp,sp,32
    80001c90:	8082                	ret
    if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001c92:	0ff77793          	zext.b	a5,a4
    80001c96:	46a5                	li	a3,9
    80001c98:	fed792e3          	bne	a5,a3,80001c7c <devintr+0x12>
        int irq = plic_claim();
    80001c9c:	00004097          	auipc	ra,0x4
    80001ca0:	80c080e7          	jalr	-2036(ra) # 800054a8 <plic_claim>
    80001ca4:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ) {
    80001ca6:	47a9                	li	a5,10
    80001ca8:	02f50763          	beq	a0,a5,80001cd6 <devintr+0x6c>
        else if (irq == VIRTIO0_IRQ) {
    80001cac:	4785                	li	a5,1
    80001cae:	02f50963          	beq	a0,a5,80001ce0 <devintr+0x76>
        return 1;
    80001cb2:	4505                	li	a0,1
        else if (irq) {
    80001cb4:	d8f1                	beqz	s1,80001c88 <devintr+0x1e>
            printf("unexpected interrupt irq=%d\n", irq);
    80001cb6:	85a6                	mv	a1,s1
    80001cb8:	00006517          	auipc	a0,0x6
    80001cbc:	59050513          	addi	a0,a0,1424 # 80008248 <states.0+0x38>
    80001cc0:	00004097          	auipc	ra,0x4
    80001cc4:	2f6080e7          	jalr	758(ra) # 80005fb6 <printf>
            plic_complete(irq);
    80001cc8:	8526                	mv	a0,s1
    80001cca:	00004097          	auipc	ra,0x4
    80001cce:	802080e7          	jalr	-2046(ra) # 800054cc <plic_complete>
        return 1;
    80001cd2:	4505                	li	a0,1
    80001cd4:	bf55                	j	80001c88 <devintr+0x1e>
            uartintr();
    80001cd6:	00004097          	auipc	ra,0x4
    80001cda:	6ee080e7          	jalr	1774(ra) # 800063c4 <uartintr>
    80001cde:	b7ed                	j	80001cc8 <devintr+0x5e>
            virtio_disk_intr();
    80001ce0:	00004097          	auipc	ra,0x4
    80001ce4:	cb4080e7          	jalr	-844(ra) # 80005994 <virtio_disk_intr>
    80001ce8:	b7c5                	j	80001cc8 <devintr+0x5e>
        if (cpuid() == 0) {
    80001cea:	fffff097          	auipc	ra,0xfffff
    80001cee:	124080e7          	jalr	292(ra) # 80000e0e <cpuid>
    80001cf2:	c901                	beqz	a0,80001d02 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cf4:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    80001cf8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cfa:	14479073          	csrw	sip,a5
        return 2;
    80001cfe:	4509                	li	a0,2
    80001d00:	b761                	j	80001c88 <devintr+0x1e>
            clockintr();
    80001d02:	00000097          	auipc	ra,0x0
    80001d06:	f22080e7          	jalr	-222(ra) # 80001c24 <clockintr>
    80001d0a:	b7ed                	j	80001cf4 <devintr+0x8a>

0000000080001d0c <usertrap>:
{
    80001d0c:	7179                	addi	sp,sp,-48
    80001d0e:	f406                	sd	ra,40(sp)
    80001d10:	f022                	sd	s0,32(sp)
    80001d12:	ec26                	sd	s1,24(sp)
    80001d14:	e84a                	sd	s2,16(sp)
    80001d16:	e44e                	sd	s3,8(sp)
    80001d18:	e052                	sd	s4,0(sp)
    80001d1a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d1c:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    80001d20:	1007f793          	andi	a5,a5,256
    80001d24:	e3b5                	bnez	a5,80001d88 <usertrap+0x7c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d26:	00003797          	auipc	a5,0x3
    80001d2a:	67a78793          	addi	a5,a5,1658 # 800053a0 <kernelvec>
    80001d2e:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80001d32:	fffff097          	auipc	ra,0xfffff
    80001d36:	108080e7          	jalr	264(ra) # 80000e3a <myproc>
    80001d3a:	84aa                	mv	s1,a0
    p->trapframe->epc = r_sepc();
    80001d3c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d3e:	14102773          	csrr	a4,sepc
    80001d42:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d44:	14202773          	csrr	a4,scause
    if (r_scause() == 8) {
    80001d48:	47a1                	li	a5,8
    80001d4a:	04f70763          	beq	a4,a5,80001d98 <usertrap+0x8c>
    else if ((which_dev = devintr()) != 0) {
    80001d4e:	00000097          	auipc	ra,0x0
    80001d52:	f1c080e7          	jalr	-228(ra) # 80001c6a <devintr>
    80001d56:	892a                	mv	s2,a0
    80001d58:	1a051863          	bnez	a0,80001f08 <usertrap+0x1fc>
    80001d5c:	14202773          	csrr	a4,scause
    else if (r_scause() == 13 || r_scause() == 15) {
    80001d60:	47b5                	li	a5,13
    80001d62:	00f70763          	beq	a4,a5,80001d70 <usertrap+0x64>
    80001d66:	14202773          	csrr	a4,scause
    80001d6a:	47bd                	li	a5,15
    80001d6c:	16f71163          	bne	a4,a5,80001ece <usertrap+0x1c2>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d70:	14302973          	csrr	s2,stval
        if (va > MAXVA || va >= p->sz) {
    80001d74:	4785                	li	a5,1
    80001d76:	179a                	slli	a5,a5,0x26
    80001d78:	0127e563          	bltu	a5,s2,80001d82 <usertrap+0x76>
    80001d7c:	64bc                	ld	a5,72(s1)
    80001d7e:	06f96963          	bltu	s2,a5,80001df0 <usertrap+0xe4>
            p->killed = 1;
    80001d82:	4785                	li	a5,1
    80001d84:	d49c                	sw	a5,40(s1)
    80001d86:	a825                	j	80001dbe <usertrap+0xb2>
        panic("usertrap: not from user mode");
    80001d88:	00006517          	auipc	a0,0x6
    80001d8c:	4e050513          	addi	a0,a0,1248 # 80008268 <states.0+0x58>
    80001d90:	00004097          	auipc	ra,0x4
    80001d94:	1dc080e7          	jalr	476(ra) # 80005f6c <panic>
        if (killed(p))
    80001d98:	00000097          	auipc	ra,0x0
    80001d9c:	a90080e7          	jalr	-1392(ra) # 80001828 <killed>
    80001da0:	e131                	bnez	a0,80001de4 <usertrap+0xd8>
        p->trapframe->epc += 4;
    80001da2:	6cb8                	ld	a4,88(s1)
    80001da4:	6f1c                	ld	a5,24(a4)
    80001da6:	0791                	addi	a5,a5,4
    80001da8:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001daa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001dae:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001db2:	10079073          	csrw	sstatus,a5
        syscall();
    80001db6:	00000097          	auipc	ra,0x0
    80001dba:	3c6080e7          	jalr	966(ra) # 8000217c <syscall>
    if (killed(p))
    80001dbe:	8526                	mv	a0,s1
    80001dc0:	00000097          	auipc	ra,0x0
    80001dc4:	a68080e7          	jalr	-1432(ra) # 80001828 <killed>
    80001dc8:	14051763          	bnez	a0,80001f16 <usertrap+0x20a>
    usertrapret();
    80001dcc:	00000097          	auipc	ra,0x0
    80001dd0:	dc2080e7          	jalr	-574(ra) # 80001b8e <usertrapret>
}
    80001dd4:	70a2                	ld	ra,40(sp)
    80001dd6:	7402                	ld	s0,32(sp)
    80001dd8:	64e2                	ld	s1,24(sp)
    80001dda:	6942                	ld	s2,16(sp)
    80001ddc:	69a2                	ld	s3,8(sp)
    80001dde:	6a02                	ld	s4,0(sp)
    80001de0:	6145                	addi	sp,sp,48
    80001de2:	8082                	ret
            exit(-1);
    80001de4:	557d                	li	a0,-1
    80001de6:	00000097          	auipc	ra,0x0
    80001dea:	86a080e7          	jalr	-1942(ra) # 80001650 <exit>
    80001dee:	bf55                	j	80001da2 <usertrap+0x96>
    80001df0:	16848793          	addi	a5,s1,360
    80001df4:	46848593          	addi	a1,s1,1128
            struct VMA *pvma = 0;
    80001df8:	4981                	li	s3,0
    80001dfa:	a029                	j	80001e04 <usertrap+0xf8>
            for (int i = 0; i < VMASIZE; i++) {
    80001dfc:	03078793          	addi	a5,a5,48
    80001e00:	00b78d63          	beq	a5,a1,80001e1a <usertrap+0x10e>
                if (p->vma[i].used == 0)
    80001e04:	4398                	lw	a4,0(a5)
    80001e06:	db7d                	beqz	a4,80001dfc <usertrap+0xf0>
                if (va >= p->vma[i].addr && va < p->vma[i].addr + p->vma[i].length) {
    80001e08:	6798                	ld	a4,8(a5)
    80001e0a:	fee969e3          	bltu	s2,a4,80001dfc <usertrap+0xf0>
    80001e0e:	4b90                	lw	a2,16(a5)
    80001e10:	9732                	add	a4,a4,a2
    80001e12:	fee975e3          	bgeu	s2,a4,80001dfc <usertrap+0xf0>
                    pvma = &p->vma[i];
    80001e16:	89be                	mv	s3,a5
    80001e18:	b7d5                	j	80001dfc <usertrap+0xf0>
            if (pvma) {
    80001e1a:	fa0982e3          	beqz	s3,80001dbe <usertrap+0xb2>
                uint64 pa = (uint64)kalloc();
    80001e1e:	ffffe097          	auipc	ra,0xffffe
    80001e22:	2fc080e7          	jalr	764(ra) # 8000011a <kalloc>
    80001e26:	8a2a                	mv	s4,a0
                if (pa == 0) {
    80001e28:	c145                	beqz	a0,80001ec8 <usertrap+0x1bc>
                va = PGROUNDDOWN(va);
    80001e2a:	77fd                	lui	a5,0xfffff
    80001e2c:	00f97933          	and	s2,s2,a5
                    memset((void *)pa, 0, PGSIZE);
    80001e30:	6605                	lui	a2,0x1
    80001e32:	4581                	li	a1,0
    80001e34:	ffffe097          	auipc	ra,0xffffe
    80001e38:	346080e7          	jalr	838(ra) # 8000017a <memset>
                    ilock(pvma->fp->ip);                                           // 加锁
    80001e3c:	0289b783          	ld	a5,40(s3)
    80001e40:	6f88                	ld	a0,24(a5)
    80001e42:	00001097          	auipc	ra,0x1
    80001e46:	e3a080e7          	jalr	-454(ra) # 80002c7c <ilock>
                    readi(pvma->fp->ip, 0, pa, (uint64)(va - pvma->addr), PGSIZE); // 读取文件内容
    80001e4a:	0089b683          	ld	a3,8(s3)
    80001e4e:	0289b783          	ld	a5,40(s3)
    80001e52:	6705                	lui	a4,0x1
    80001e54:	40d906bb          	subw	a3,s2,a3
    80001e58:	8652                	mv	a2,s4
    80001e5a:	4581                	li	a1,0
    80001e5c:	6f88                	ld	a0,24(a5)
    80001e5e:	00001097          	auipc	ra,0x1
    80001e62:	0d2080e7          	jalr	210(ra) # 80002f30 <readi>
                    iunlock(pvma->fp->ip);                                         // 解锁
    80001e66:	0289b783          	ld	a5,40(s3)
    80001e6a:	6f88                	ld	a0,24(a5)
    80001e6c:	00001097          	auipc	ra,0x1
    80001e70:	ed2080e7          	jalr	-302(ra) # 80002d3e <iunlock>
                    if (pvma->prot & PROT_READ)
    80001e74:	0149a783          	lw	a5,20(s3)
    80001e78:	0017f713          	andi	a4,a5,1
                    int PTE_flags = PTE_U;
    80001e7c:	49c1                	li	s3,16
                    if (pvma->prot & PROT_READ)
    80001e7e:	c311                	beqz	a4,80001e82 <usertrap+0x176>
                        PTE_flags |= PTE_R;
    80001e80:	49c9                	li	s3,18
                    if (pvma->prot & PROT_WRITE)
    80001e82:	0027f713          	andi	a4,a5,2
    80001e86:	c319                	beqz	a4,80001e8c <usertrap+0x180>
                        PTE_flags |= PTE_W;
    80001e88:	0049e993          	ori	s3,s3,4
                    if (pvma->prot & PROT_EXEC)
    80001e8c:	8b91                	andi	a5,a5,4
    80001e8e:	c399                	beqz	a5,80001e94 <usertrap+0x188>
                        PTE_flags |= PTE_X;
    80001e90:	0089e993          	ori	s3,s3,8
                    printf("map start\n");
    80001e94:	00006517          	auipc	a0,0x6
    80001e98:	3f450513          	addi	a0,a0,1012 # 80008288 <states.0+0x78>
    80001e9c:	00004097          	auipc	ra,0x4
    80001ea0:	11a080e7          	jalr	282(ra) # 80005fb6 <printf>
                    if (mappages(p->pagetable, va, PGSIZE, pa, PTE_flags) != 0) {
    80001ea4:	874e                	mv	a4,s3
    80001ea6:	86d2                	mv	a3,s4
    80001ea8:	6605                	lui	a2,0x1
    80001eaa:	85ca                	mv	a1,s2
    80001eac:	68a8                	ld	a0,80(s1)
    80001eae:	ffffe097          	auipc	ra,0xffffe
    80001eb2:	698080e7          	jalr	1688(ra) # 80000546 <mappages>
    80001eb6:	d501                	beqz	a0,80001dbe <usertrap+0xb2>
                        kfree((void *)pa);
    80001eb8:	8552                	mv	a0,s4
    80001eba:	ffffe097          	auipc	ra,0xffffe
    80001ebe:	162080e7          	jalr	354(ra) # 8000001c <kfree>
                        p->killed = 1;
    80001ec2:	4785                	li	a5,1
    80001ec4:	d49c                	sw	a5,40(s1)
    80001ec6:	bde5                	j	80001dbe <usertrap+0xb2>
                    p->killed = 1;
    80001ec8:	4785                	li	a5,1
    80001eca:	d49c                	sw	a5,40(s1)
    80001ecc:	bdcd                	j	80001dbe <usertrap+0xb2>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ece:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001ed2:	5890                	lw	a2,48(s1)
    80001ed4:	00006517          	auipc	a0,0x6
    80001ed8:	3c450513          	addi	a0,a0,964 # 80008298 <states.0+0x88>
    80001edc:	00004097          	auipc	ra,0x4
    80001ee0:	0da080e7          	jalr	218(ra) # 80005fb6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ee4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ee8:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001eec:	00006517          	auipc	a0,0x6
    80001ef0:	3dc50513          	addi	a0,a0,988 # 800082c8 <states.0+0xb8>
    80001ef4:	00004097          	auipc	ra,0x4
    80001ef8:	0c2080e7          	jalr	194(ra) # 80005fb6 <printf>
        setkilled(p);
    80001efc:	8526                	mv	a0,s1
    80001efe:	00000097          	auipc	ra,0x0
    80001f02:	8fe080e7          	jalr	-1794(ra) # 800017fc <setkilled>
    80001f06:	bd65                	j	80001dbe <usertrap+0xb2>
    if (killed(p))
    80001f08:	8526                	mv	a0,s1
    80001f0a:	00000097          	auipc	ra,0x0
    80001f0e:	91e080e7          	jalr	-1762(ra) # 80001828 <killed>
    80001f12:	c901                	beqz	a0,80001f22 <usertrap+0x216>
    80001f14:	a011                	j	80001f18 <usertrap+0x20c>
    80001f16:	4901                	li	s2,0
        exit(-1);
    80001f18:	557d                	li	a0,-1
    80001f1a:	fffff097          	auipc	ra,0xfffff
    80001f1e:	736080e7          	jalr	1846(ra) # 80001650 <exit>
    if (which_dev == 2)
    80001f22:	4789                	li	a5,2
    80001f24:	eaf914e3          	bne	s2,a5,80001dcc <usertrap+0xc0>
        yield();
    80001f28:	fffff097          	auipc	ra,0xfffff
    80001f2c:	5b8080e7          	jalr	1464(ra) # 800014e0 <yield>
    80001f30:	bd71                	j	80001dcc <usertrap+0xc0>

0000000080001f32 <kerneltrap>:
{
    80001f32:	7179                	addi	sp,sp,-48
    80001f34:	f406                	sd	ra,40(sp)
    80001f36:	f022                	sd	s0,32(sp)
    80001f38:	ec26                	sd	s1,24(sp)
    80001f3a:	e84a                	sd	s2,16(sp)
    80001f3c:	e44e                	sd	s3,8(sp)
    80001f3e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f40:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f44:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f48:	142029f3          	csrr	s3,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    80001f4c:	1004f793          	andi	a5,s1,256
    80001f50:	cb85                	beqz	a5,80001f80 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f52:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f56:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    80001f58:	ef85                	bnez	a5,80001f90 <kerneltrap+0x5e>
    if ((which_dev = devintr()) == 0) {
    80001f5a:	00000097          	auipc	ra,0x0
    80001f5e:	d10080e7          	jalr	-752(ra) # 80001c6a <devintr>
    80001f62:	cd1d                	beqz	a0,80001fa0 <kerneltrap+0x6e>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f64:	4789                	li	a5,2
    80001f66:	06f50a63          	beq	a0,a5,80001fda <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f6a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f6e:	10049073          	csrw	sstatus,s1
}
    80001f72:	70a2                	ld	ra,40(sp)
    80001f74:	7402                	ld	s0,32(sp)
    80001f76:	64e2                	ld	s1,24(sp)
    80001f78:	6942                	ld	s2,16(sp)
    80001f7a:	69a2                	ld	s3,8(sp)
    80001f7c:	6145                	addi	sp,sp,48
    80001f7e:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80001f80:	00006517          	auipc	a0,0x6
    80001f84:	36850513          	addi	a0,a0,872 # 800082e8 <states.0+0xd8>
    80001f88:	00004097          	auipc	ra,0x4
    80001f8c:	fe4080e7          	jalr	-28(ra) # 80005f6c <panic>
        panic("kerneltrap: interrupts enabled");
    80001f90:	00006517          	auipc	a0,0x6
    80001f94:	38050513          	addi	a0,a0,896 # 80008310 <states.0+0x100>
    80001f98:	00004097          	auipc	ra,0x4
    80001f9c:	fd4080e7          	jalr	-44(ra) # 80005f6c <panic>
        printf("scause %p\n", scause);
    80001fa0:	85ce                	mv	a1,s3
    80001fa2:	00006517          	auipc	a0,0x6
    80001fa6:	38e50513          	addi	a0,a0,910 # 80008330 <states.0+0x120>
    80001faa:	00004097          	auipc	ra,0x4
    80001fae:	00c080e7          	jalr	12(ra) # 80005fb6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fb2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fb6:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fba:	00006517          	auipc	a0,0x6
    80001fbe:	38650513          	addi	a0,a0,902 # 80008340 <states.0+0x130>
    80001fc2:	00004097          	auipc	ra,0x4
    80001fc6:	ff4080e7          	jalr	-12(ra) # 80005fb6 <printf>
        panic("kerneltrap");
    80001fca:	00006517          	auipc	a0,0x6
    80001fce:	38e50513          	addi	a0,a0,910 # 80008358 <states.0+0x148>
    80001fd2:	00004097          	auipc	ra,0x4
    80001fd6:	f9a080e7          	jalr	-102(ra) # 80005f6c <panic>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fda:	fffff097          	auipc	ra,0xfffff
    80001fde:	e60080e7          	jalr	-416(ra) # 80000e3a <myproc>
    80001fe2:	d541                	beqz	a0,80001f6a <kerneltrap+0x38>
    80001fe4:	fffff097          	auipc	ra,0xfffff
    80001fe8:	e56080e7          	jalr	-426(ra) # 80000e3a <myproc>
    80001fec:	4d18                	lw	a4,24(a0)
    80001fee:	4791                	li	a5,4
    80001ff0:	f6f71de3          	bne	a4,a5,80001f6a <kerneltrap+0x38>
        yield();
    80001ff4:	fffff097          	auipc	ra,0xfffff
    80001ff8:	4ec080e7          	jalr	1260(ra) # 800014e0 <yield>
    80001ffc:	b7bd                	j	80001f6a <kerneltrap+0x38>

0000000080001ffe <argraw>:
        return -1;
    return strlen(buf);
}

static uint64 argraw(int n)
{
    80001ffe:	1101                	addi	sp,sp,-32
    80002000:	ec06                	sd	ra,24(sp)
    80002002:	e822                	sd	s0,16(sp)
    80002004:	e426                	sd	s1,8(sp)
    80002006:	1000                	addi	s0,sp,32
    80002008:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    8000200a:	fffff097          	auipc	ra,0xfffff
    8000200e:	e30080e7          	jalr	-464(ra) # 80000e3a <myproc>
    switch (n) {
    80002012:	4795                	li	a5,5
    80002014:	0497e163          	bltu	a5,s1,80002056 <argraw+0x58>
    80002018:	048a                	slli	s1,s1,0x2
    8000201a:	00006717          	auipc	a4,0x6
    8000201e:	37670713          	addi	a4,a4,886 # 80008390 <states.0+0x180>
    80002022:	94ba                	add	s1,s1,a4
    80002024:	409c                	lw	a5,0(s1)
    80002026:	97ba                	add	a5,a5,a4
    80002028:	8782                	jr	a5
    case 0:
        return p->trapframe->a0;
    8000202a:	6d3c                	ld	a5,88(a0)
    8000202c:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    8000202e:	60e2                	ld	ra,24(sp)
    80002030:	6442                	ld	s0,16(sp)
    80002032:	64a2                	ld	s1,8(sp)
    80002034:	6105                	addi	sp,sp,32
    80002036:	8082                	ret
        return p->trapframe->a1;
    80002038:	6d3c                	ld	a5,88(a0)
    8000203a:	7fa8                	ld	a0,120(a5)
    8000203c:	bfcd                	j	8000202e <argraw+0x30>
        return p->trapframe->a2;
    8000203e:	6d3c                	ld	a5,88(a0)
    80002040:	63c8                	ld	a0,128(a5)
    80002042:	b7f5                	j	8000202e <argraw+0x30>
        return p->trapframe->a3;
    80002044:	6d3c                	ld	a5,88(a0)
    80002046:	67c8                	ld	a0,136(a5)
    80002048:	b7dd                	j	8000202e <argraw+0x30>
        return p->trapframe->a4;
    8000204a:	6d3c                	ld	a5,88(a0)
    8000204c:	6bc8                	ld	a0,144(a5)
    8000204e:	b7c5                	j	8000202e <argraw+0x30>
        return p->trapframe->a5;
    80002050:	6d3c                	ld	a5,88(a0)
    80002052:	6fc8                	ld	a0,152(a5)
    80002054:	bfe9                	j	8000202e <argraw+0x30>
    panic("argraw");
    80002056:	00006517          	auipc	a0,0x6
    8000205a:	31250513          	addi	a0,a0,786 # 80008368 <states.0+0x158>
    8000205e:	00004097          	auipc	ra,0x4
    80002062:	f0e080e7          	jalr	-242(ra) # 80005f6c <panic>

0000000080002066 <fetchaddr>:
{
    80002066:	1101                	addi	sp,sp,-32
    80002068:	ec06                	sd	ra,24(sp)
    8000206a:	e822                	sd	s0,16(sp)
    8000206c:	e426                	sd	s1,8(sp)
    8000206e:	e04a                	sd	s2,0(sp)
    80002070:	1000                	addi	s0,sp,32
    80002072:	84aa                	mv	s1,a0
    80002074:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80002076:	fffff097          	auipc	ra,0xfffff
    8000207a:	dc4080e7          	jalr	-572(ra) # 80000e3a <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000207e:	653c                	ld	a5,72(a0)
    80002080:	02f4f863          	bgeu	s1,a5,800020b0 <fetchaddr+0x4a>
    80002084:	00848713          	addi	a4,s1,8
    80002088:	02e7e663          	bltu	a5,a4,800020b4 <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000208c:	46a1                	li	a3,8
    8000208e:	8626                	mv	a2,s1
    80002090:	85ca                	mv	a1,s2
    80002092:	6928                	ld	a0,80(a0)
    80002094:	fffff097          	auipc	ra,0xfffff
    80002098:	af2080e7          	jalr	-1294(ra) # 80000b86 <copyin>
    8000209c:	00a03533          	snez	a0,a0
    800020a0:	40a00533          	neg	a0,a0
}
    800020a4:	60e2                	ld	ra,24(sp)
    800020a6:	6442                	ld	s0,16(sp)
    800020a8:	64a2                	ld	s1,8(sp)
    800020aa:	6902                	ld	s2,0(sp)
    800020ac:	6105                	addi	sp,sp,32
    800020ae:	8082                	ret
        return -1;
    800020b0:	557d                	li	a0,-1
    800020b2:	bfcd                	j	800020a4 <fetchaddr+0x3e>
    800020b4:	557d                	li	a0,-1
    800020b6:	b7fd                	j	800020a4 <fetchaddr+0x3e>

00000000800020b8 <fetchstr>:
{
    800020b8:	7179                	addi	sp,sp,-48
    800020ba:	f406                	sd	ra,40(sp)
    800020bc:	f022                	sd	s0,32(sp)
    800020be:	ec26                	sd	s1,24(sp)
    800020c0:	e84a                	sd	s2,16(sp)
    800020c2:	e44e                	sd	s3,8(sp)
    800020c4:	1800                	addi	s0,sp,48
    800020c6:	892a                	mv	s2,a0
    800020c8:	84ae                	mv	s1,a1
    800020ca:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    800020cc:	fffff097          	auipc	ra,0xfffff
    800020d0:	d6e080e7          	jalr	-658(ra) # 80000e3a <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    800020d4:	86ce                	mv	a3,s3
    800020d6:	864a                	mv	a2,s2
    800020d8:	85a6                	mv	a1,s1
    800020da:	6928                	ld	a0,80(a0)
    800020dc:	fffff097          	auipc	ra,0xfffff
    800020e0:	b38080e7          	jalr	-1224(ra) # 80000c14 <copyinstr>
    800020e4:	00054e63          	bltz	a0,80002100 <fetchstr+0x48>
    return strlen(buf);
    800020e8:	8526                	mv	a0,s1
    800020ea:	ffffe097          	auipc	ra,0xffffe
    800020ee:	20c080e7          	jalr	524(ra) # 800002f6 <strlen>
}
    800020f2:	70a2                	ld	ra,40(sp)
    800020f4:	7402                	ld	s0,32(sp)
    800020f6:	64e2                	ld	s1,24(sp)
    800020f8:	6942                	ld	s2,16(sp)
    800020fa:	69a2                	ld	s3,8(sp)
    800020fc:	6145                	addi	sp,sp,48
    800020fe:	8082                	ret
        return -1;
    80002100:	557d                	li	a0,-1
    80002102:	bfc5                	j	800020f2 <fetchstr+0x3a>

0000000080002104 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    80002104:	1101                	addi	sp,sp,-32
    80002106:	ec06                	sd	ra,24(sp)
    80002108:	e822                	sd	s0,16(sp)
    8000210a:	e426                	sd	s1,8(sp)
    8000210c:	1000                	addi	s0,sp,32
    8000210e:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80002110:	00000097          	auipc	ra,0x0
    80002114:	eee080e7          	jalr	-274(ra) # 80001ffe <argraw>
    80002118:	c088                	sw	a0,0(s1)
}
    8000211a:	60e2                	ld	ra,24(sp)
    8000211c:	6442                	ld	s0,16(sp)
    8000211e:	64a2                	ld	s1,8(sp)
    80002120:	6105                	addi	sp,sp,32
    80002122:	8082                	ret

0000000080002124 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    80002124:	1101                	addi	sp,sp,-32
    80002126:	ec06                	sd	ra,24(sp)
    80002128:	e822                	sd	s0,16(sp)
    8000212a:	e426                	sd	s1,8(sp)
    8000212c:	1000                	addi	s0,sp,32
    8000212e:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80002130:	00000097          	auipc	ra,0x0
    80002134:	ece080e7          	jalr	-306(ra) # 80001ffe <argraw>
    80002138:	e088                	sd	a0,0(s1)
}
    8000213a:	60e2                	ld	ra,24(sp)
    8000213c:	6442                	ld	s0,16(sp)
    8000213e:	64a2                	ld	s1,8(sp)
    80002140:	6105                	addi	sp,sp,32
    80002142:	8082                	ret

0000000080002144 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    80002144:	7179                	addi	sp,sp,-48
    80002146:	f406                	sd	ra,40(sp)
    80002148:	f022                	sd	s0,32(sp)
    8000214a:	ec26                	sd	s1,24(sp)
    8000214c:	e84a                	sd	s2,16(sp)
    8000214e:	1800                	addi	s0,sp,48
    80002150:	84ae                	mv	s1,a1
    80002152:	8932                	mv	s2,a2
    uint64 addr;
    argaddr(n, &addr);
    80002154:	fd840593          	addi	a1,s0,-40
    80002158:	00000097          	auipc	ra,0x0
    8000215c:	fcc080e7          	jalr	-52(ra) # 80002124 <argaddr>
    return fetchstr(addr, buf, max);
    80002160:	864a                	mv	a2,s2
    80002162:	85a6                	mv	a1,s1
    80002164:	fd843503          	ld	a0,-40(s0)
    80002168:	00000097          	auipc	ra,0x0
    8000216c:	f50080e7          	jalr	-176(ra) # 800020b8 <fetchstr>
}
    80002170:	70a2                	ld	ra,40(sp)
    80002172:	7402                	ld	s0,32(sp)
    80002174:	64e2                	ld	s1,24(sp)
    80002176:	6942                	ld	s2,16(sp)
    80002178:	6145                	addi	sp,sp,48
    8000217a:	8082                	ret

000000008000217c <syscall>:
    [SYS_sleep] sys_sleep, [SYS_uptime] sys_uptime, [SYS_open] sys_open,   [SYS_write] sys_write, [SYS_mknod] sys_mknod,   [SYS_unlink] sys_unlink,
    [SYS_link] sys_link,   [SYS_mkdir] sys_mkdir,   [SYS_close] sys_close, [SYS_mmap] sys_mmap,   [SYS_munmap] sys_munmap,
};

void syscall(void)
{
    8000217c:	1101                	addi	sp,sp,-32
    8000217e:	ec06                	sd	ra,24(sp)
    80002180:	e822                	sd	s0,16(sp)
    80002182:	e426                	sd	s1,8(sp)
    80002184:	e04a                	sd	s2,0(sp)
    80002186:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    80002188:	fffff097          	auipc	ra,0xfffff
    8000218c:	cb2080e7          	jalr	-846(ra) # 80000e3a <myproc>
    80002190:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    80002192:	05853903          	ld	s2,88(a0)
    80002196:	0a893783          	ld	a5,168(s2)
    8000219a:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000219e:	37fd                	addiw	a5,a5,-1 # ffffffffffffefff <end+0xffffffff7ffd12bf>
    800021a0:	4759                	li	a4,22
    800021a2:	00f76f63          	bltu	a4,a5,800021c0 <syscall+0x44>
    800021a6:	00369713          	slli	a4,a3,0x3
    800021aa:	00006797          	auipc	a5,0x6
    800021ae:	1fe78793          	addi	a5,a5,510 # 800083a8 <syscalls>
    800021b2:	97ba                	add	a5,a5,a4
    800021b4:	639c                	ld	a5,0(a5)
    800021b6:	c789                	beqz	a5,800021c0 <syscall+0x44>
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    800021b8:	9782                	jalr	a5
    800021ba:	06a93823          	sd	a0,112(s2)
    800021be:	a839                	j	800021dc <syscall+0x60>
    }
    else {
        printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    800021c0:	15848613          	addi	a2,s1,344
    800021c4:	588c                	lw	a1,48(s1)
    800021c6:	00006517          	auipc	a0,0x6
    800021ca:	1aa50513          	addi	a0,a0,426 # 80008370 <states.0+0x160>
    800021ce:	00004097          	auipc	ra,0x4
    800021d2:	de8080e7          	jalr	-536(ra) # 80005fb6 <printf>
        p->trapframe->a0 = -1;
    800021d6:	6cbc                	ld	a5,88(s1)
    800021d8:	577d                	li	a4,-1
    800021da:	fbb8                	sd	a4,112(a5)
    }
}
    800021dc:	60e2                	ld	ra,24(sp)
    800021de:	6442                	ld	s0,16(sp)
    800021e0:	64a2                	ld	s1,8(sp)
    800021e2:	6902                	ld	s2,0(sp)
    800021e4:	6105                	addi	sp,sp,32
    800021e6:	8082                	ret

00000000800021e8 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800021e8:	1101                	addi	sp,sp,-32
    800021ea:	ec06                	sd	ra,24(sp)
    800021ec:	e822                	sd	s0,16(sp)
    800021ee:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800021f0:	fec40593          	addi	a1,s0,-20
    800021f4:	4501                	li	a0,0
    800021f6:	00000097          	auipc	ra,0x0
    800021fa:	f0e080e7          	jalr	-242(ra) # 80002104 <argint>
  exit(n);
    800021fe:	fec42503          	lw	a0,-20(s0)
    80002202:	fffff097          	auipc	ra,0xfffff
    80002206:	44e080e7          	jalr	1102(ra) # 80001650 <exit>
  return 0;  // not reached
}
    8000220a:	4501                	li	a0,0
    8000220c:	60e2                	ld	ra,24(sp)
    8000220e:	6442                	ld	s0,16(sp)
    80002210:	6105                	addi	sp,sp,32
    80002212:	8082                	ret

0000000080002214 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002214:	1141                	addi	sp,sp,-16
    80002216:	e406                	sd	ra,8(sp)
    80002218:	e022                	sd	s0,0(sp)
    8000221a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000221c:	fffff097          	auipc	ra,0xfffff
    80002220:	c1e080e7          	jalr	-994(ra) # 80000e3a <myproc>
}
    80002224:	5908                	lw	a0,48(a0)
    80002226:	60a2                	ld	ra,8(sp)
    80002228:	6402                	ld	s0,0(sp)
    8000222a:	0141                	addi	sp,sp,16
    8000222c:	8082                	ret

000000008000222e <sys_fork>:

uint64
sys_fork(void)
{
    8000222e:	1141                	addi	sp,sp,-16
    80002230:	e406                	sd	ra,8(sp)
    80002232:	e022                	sd	s0,0(sp)
    80002234:	0800                	addi	s0,sp,16
  return fork();
    80002236:	fffff097          	auipc	ra,0xfffff
    8000223a:	fba080e7          	jalr	-70(ra) # 800011f0 <fork>
}
    8000223e:	60a2                	ld	ra,8(sp)
    80002240:	6402                	ld	s0,0(sp)
    80002242:	0141                	addi	sp,sp,16
    80002244:	8082                	ret

0000000080002246 <sys_wait>:

uint64
sys_wait(void)
{
    80002246:	1101                	addi	sp,sp,-32
    80002248:	ec06                	sd	ra,24(sp)
    8000224a:	e822                	sd	s0,16(sp)
    8000224c:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000224e:	fe840593          	addi	a1,s0,-24
    80002252:	4501                	li	a0,0
    80002254:	00000097          	auipc	ra,0x0
    80002258:	ed0080e7          	jalr	-304(ra) # 80002124 <argaddr>
  return wait(p);
    8000225c:	fe843503          	ld	a0,-24(s0)
    80002260:	fffff097          	auipc	ra,0xfffff
    80002264:	5fa080e7          	jalr	1530(ra) # 8000185a <wait>
}
    80002268:	60e2                	ld	ra,24(sp)
    8000226a:	6442                	ld	s0,16(sp)
    8000226c:	6105                	addi	sp,sp,32
    8000226e:	8082                	ret

0000000080002270 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002270:	7179                	addi	sp,sp,-48
    80002272:	f406                	sd	ra,40(sp)
    80002274:	f022                	sd	s0,32(sp)
    80002276:	ec26                	sd	s1,24(sp)
    80002278:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000227a:	fdc40593          	addi	a1,s0,-36
    8000227e:	4501                	li	a0,0
    80002280:	00000097          	auipc	ra,0x0
    80002284:	e84080e7          	jalr	-380(ra) # 80002104 <argint>
  addr = myproc()->sz;
    80002288:	fffff097          	auipc	ra,0xfffff
    8000228c:	bb2080e7          	jalr	-1102(ra) # 80000e3a <myproc>
    80002290:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002292:	fdc42503          	lw	a0,-36(s0)
    80002296:	fffff097          	auipc	ra,0xfffff
    8000229a:	efe080e7          	jalr	-258(ra) # 80001194 <growproc>
    8000229e:	00054863          	bltz	a0,800022ae <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800022a2:	8526                	mv	a0,s1
    800022a4:	70a2                	ld	ra,40(sp)
    800022a6:	7402                	ld	s0,32(sp)
    800022a8:	64e2                	ld	s1,24(sp)
    800022aa:	6145                	addi	sp,sp,48
    800022ac:	8082                	ret
    return -1;
    800022ae:	54fd                	li	s1,-1
    800022b0:	bfcd                	j	800022a2 <sys_sbrk+0x32>

00000000800022b2 <sys_sleep>:

uint64
sys_sleep(void)
{
    800022b2:	7139                	addi	sp,sp,-64
    800022b4:	fc06                	sd	ra,56(sp)
    800022b6:	f822                	sd	s0,48(sp)
    800022b8:	f426                	sd	s1,40(sp)
    800022ba:	f04a                	sd	s2,32(sp)
    800022bc:	ec4e                	sd	s3,24(sp)
    800022be:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800022c0:	fcc40593          	addi	a1,s0,-52
    800022c4:	4501                	li	a0,0
    800022c6:	00000097          	auipc	ra,0x0
    800022ca:	e3e080e7          	jalr	-450(ra) # 80002104 <argint>
  if(n < 0)
    800022ce:	fcc42783          	lw	a5,-52(s0)
    800022d2:	0607cf63          	bltz	a5,80002350 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    800022d6:	00018517          	auipc	a0,0x18
    800022da:	44a50513          	addi	a0,a0,1098 # 8001a720 <tickslock>
    800022de:	00004097          	auipc	ra,0x4
    800022e2:	1c6080e7          	jalr	454(ra) # 800064a4 <acquire>
  ticks0 = ticks;
    800022e6:	00006917          	auipc	s2,0x6
    800022ea:	5d292903          	lw	s2,1490(s2) # 800088b8 <ticks>
  while(ticks - ticks0 < n){
    800022ee:	fcc42783          	lw	a5,-52(s0)
    800022f2:	cf9d                	beqz	a5,80002330 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022f4:	00018997          	auipc	s3,0x18
    800022f8:	42c98993          	addi	s3,s3,1068 # 8001a720 <tickslock>
    800022fc:	00006497          	auipc	s1,0x6
    80002300:	5bc48493          	addi	s1,s1,1468 # 800088b8 <ticks>
    if(killed(myproc())){
    80002304:	fffff097          	auipc	ra,0xfffff
    80002308:	b36080e7          	jalr	-1226(ra) # 80000e3a <myproc>
    8000230c:	fffff097          	auipc	ra,0xfffff
    80002310:	51c080e7          	jalr	1308(ra) # 80001828 <killed>
    80002314:	e129                	bnez	a0,80002356 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002316:	85ce                	mv	a1,s3
    80002318:	8526                	mv	a0,s1
    8000231a:	fffff097          	auipc	ra,0xfffff
    8000231e:	202080e7          	jalr	514(ra) # 8000151c <sleep>
  while(ticks - ticks0 < n){
    80002322:	409c                	lw	a5,0(s1)
    80002324:	412787bb          	subw	a5,a5,s2
    80002328:	fcc42703          	lw	a4,-52(s0)
    8000232c:	fce7ece3          	bltu	a5,a4,80002304 <sys_sleep+0x52>
  }
  release(&tickslock);
    80002330:	00018517          	auipc	a0,0x18
    80002334:	3f050513          	addi	a0,a0,1008 # 8001a720 <tickslock>
    80002338:	00004097          	auipc	ra,0x4
    8000233c:	220080e7          	jalr	544(ra) # 80006558 <release>
  return 0;
    80002340:	4501                	li	a0,0
}
    80002342:	70e2                	ld	ra,56(sp)
    80002344:	7442                	ld	s0,48(sp)
    80002346:	74a2                	ld	s1,40(sp)
    80002348:	7902                	ld	s2,32(sp)
    8000234a:	69e2                	ld	s3,24(sp)
    8000234c:	6121                	addi	sp,sp,64
    8000234e:	8082                	ret
    n = 0;
    80002350:	fc042623          	sw	zero,-52(s0)
    80002354:	b749                	j	800022d6 <sys_sleep+0x24>
      release(&tickslock);
    80002356:	00018517          	auipc	a0,0x18
    8000235a:	3ca50513          	addi	a0,a0,970 # 8001a720 <tickslock>
    8000235e:	00004097          	auipc	ra,0x4
    80002362:	1fa080e7          	jalr	506(ra) # 80006558 <release>
      return -1;
    80002366:	557d                	li	a0,-1
    80002368:	bfe9                	j	80002342 <sys_sleep+0x90>

000000008000236a <sys_kill>:

uint64
sys_kill(void)
{
    8000236a:	1101                	addi	sp,sp,-32
    8000236c:	ec06                	sd	ra,24(sp)
    8000236e:	e822                	sd	s0,16(sp)
    80002370:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002372:	fec40593          	addi	a1,s0,-20
    80002376:	4501                	li	a0,0
    80002378:	00000097          	auipc	ra,0x0
    8000237c:	d8c080e7          	jalr	-628(ra) # 80002104 <argint>
  return kill(pid);
    80002380:	fec42503          	lw	a0,-20(s0)
    80002384:	fffff097          	auipc	ra,0xfffff
    80002388:	406080e7          	jalr	1030(ra) # 8000178a <kill>
}
    8000238c:	60e2                	ld	ra,24(sp)
    8000238e:	6442                	ld	s0,16(sp)
    80002390:	6105                	addi	sp,sp,32
    80002392:	8082                	ret

0000000080002394 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002394:	1101                	addi	sp,sp,-32
    80002396:	ec06                	sd	ra,24(sp)
    80002398:	e822                	sd	s0,16(sp)
    8000239a:	e426                	sd	s1,8(sp)
    8000239c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000239e:	00018517          	auipc	a0,0x18
    800023a2:	38250513          	addi	a0,a0,898 # 8001a720 <tickslock>
    800023a6:	00004097          	auipc	ra,0x4
    800023aa:	0fe080e7          	jalr	254(ra) # 800064a4 <acquire>
  xticks = ticks;
    800023ae:	00006497          	auipc	s1,0x6
    800023b2:	50a4a483          	lw	s1,1290(s1) # 800088b8 <ticks>
  release(&tickslock);
    800023b6:	00018517          	auipc	a0,0x18
    800023ba:	36a50513          	addi	a0,a0,874 # 8001a720 <tickslock>
    800023be:	00004097          	auipc	ra,0x4
    800023c2:	19a080e7          	jalr	410(ra) # 80006558 <release>
  return xticks;
}
    800023c6:	02049513          	slli	a0,s1,0x20
    800023ca:	9101                	srli	a0,a0,0x20
    800023cc:	60e2                	ld	ra,24(sp)
    800023ce:	6442                	ld	s0,16(sp)
    800023d0:	64a2                	ld	s1,8(sp)
    800023d2:	6105                	addi	sp,sp,32
    800023d4:	8082                	ret

00000000800023d6 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800023d6:	7179                	addi	sp,sp,-48
    800023d8:	f406                	sd	ra,40(sp)
    800023da:	f022                	sd	s0,32(sp)
    800023dc:	ec26                	sd	s1,24(sp)
    800023de:	e84a                	sd	s2,16(sp)
    800023e0:	e44e                	sd	s3,8(sp)
    800023e2:	e052                	sd	s4,0(sp)
    800023e4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800023e6:	00006597          	auipc	a1,0x6
    800023ea:	08258593          	addi	a1,a1,130 # 80008468 <syscalls+0xc0>
    800023ee:	00018517          	auipc	a0,0x18
    800023f2:	34a50513          	addi	a0,a0,842 # 8001a738 <bcache>
    800023f6:	00004097          	auipc	ra,0x4
    800023fa:	01e080e7          	jalr	30(ra) # 80006414 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800023fe:	00020797          	auipc	a5,0x20
    80002402:	33a78793          	addi	a5,a5,826 # 80022738 <bcache+0x8000>
    80002406:	00020717          	auipc	a4,0x20
    8000240a:	59a70713          	addi	a4,a4,1434 # 800229a0 <bcache+0x8268>
    8000240e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002412:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002416:	00018497          	auipc	s1,0x18
    8000241a:	33a48493          	addi	s1,s1,826 # 8001a750 <bcache+0x18>
    b->next = bcache.head.next;
    8000241e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002420:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002422:	00006a17          	auipc	s4,0x6
    80002426:	04ea0a13          	addi	s4,s4,78 # 80008470 <syscalls+0xc8>
    b->next = bcache.head.next;
    8000242a:	2b893783          	ld	a5,696(s2)
    8000242e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002430:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002434:	85d2                	mv	a1,s4
    80002436:	01048513          	addi	a0,s1,16
    8000243a:	00001097          	auipc	ra,0x1
    8000243e:	4c8080e7          	jalr	1224(ra) # 80003902 <initsleeplock>
    bcache.head.next->prev = b;
    80002442:	2b893783          	ld	a5,696(s2)
    80002446:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002448:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000244c:	45848493          	addi	s1,s1,1112
    80002450:	fd349de3          	bne	s1,s3,8000242a <binit+0x54>
  }
}
    80002454:	70a2                	ld	ra,40(sp)
    80002456:	7402                	ld	s0,32(sp)
    80002458:	64e2                	ld	s1,24(sp)
    8000245a:	6942                	ld	s2,16(sp)
    8000245c:	69a2                	ld	s3,8(sp)
    8000245e:	6a02                	ld	s4,0(sp)
    80002460:	6145                	addi	sp,sp,48
    80002462:	8082                	ret

0000000080002464 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002464:	7179                	addi	sp,sp,-48
    80002466:	f406                	sd	ra,40(sp)
    80002468:	f022                	sd	s0,32(sp)
    8000246a:	ec26                	sd	s1,24(sp)
    8000246c:	e84a                	sd	s2,16(sp)
    8000246e:	e44e                	sd	s3,8(sp)
    80002470:	1800                	addi	s0,sp,48
    80002472:	892a                	mv	s2,a0
    80002474:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002476:	00018517          	auipc	a0,0x18
    8000247a:	2c250513          	addi	a0,a0,706 # 8001a738 <bcache>
    8000247e:	00004097          	auipc	ra,0x4
    80002482:	026080e7          	jalr	38(ra) # 800064a4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002486:	00020497          	auipc	s1,0x20
    8000248a:	56a4b483          	ld	s1,1386(s1) # 800229f0 <bcache+0x82b8>
    8000248e:	00020797          	auipc	a5,0x20
    80002492:	51278793          	addi	a5,a5,1298 # 800229a0 <bcache+0x8268>
    80002496:	02f48f63          	beq	s1,a5,800024d4 <bread+0x70>
    8000249a:	873e                	mv	a4,a5
    8000249c:	a021                	j	800024a4 <bread+0x40>
    8000249e:	68a4                	ld	s1,80(s1)
    800024a0:	02e48a63          	beq	s1,a4,800024d4 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800024a4:	449c                	lw	a5,8(s1)
    800024a6:	ff279ce3          	bne	a5,s2,8000249e <bread+0x3a>
    800024aa:	44dc                	lw	a5,12(s1)
    800024ac:	ff3799e3          	bne	a5,s3,8000249e <bread+0x3a>
      b->refcnt++;
    800024b0:	40bc                	lw	a5,64(s1)
    800024b2:	2785                	addiw	a5,a5,1
    800024b4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024b6:	00018517          	auipc	a0,0x18
    800024ba:	28250513          	addi	a0,a0,642 # 8001a738 <bcache>
    800024be:	00004097          	auipc	ra,0x4
    800024c2:	09a080e7          	jalr	154(ra) # 80006558 <release>
      acquiresleep(&b->lock);
    800024c6:	01048513          	addi	a0,s1,16
    800024ca:	00001097          	auipc	ra,0x1
    800024ce:	472080e7          	jalr	1138(ra) # 8000393c <acquiresleep>
      return b;
    800024d2:	a8b9                	j	80002530 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024d4:	00020497          	auipc	s1,0x20
    800024d8:	5144b483          	ld	s1,1300(s1) # 800229e8 <bcache+0x82b0>
    800024dc:	00020797          	auipc	a5,0x20
    800024e0:	4c478793          	addi	a5,a5,1220 # 800229a0 <bcache+0x8268>
    800024e4:	00f48863          	beq	s1,a5,800024f4 <bread+0x90>
    800024e8:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800024ea:	40bc                	lw	a5,64(s1)
    800024ec:	cf81                	beqz	a5,80002504 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024ee:	64a4                	ld	s1,72(s1)
    800024f0:	fee49de3          	bne	s1,a4,800024ea <bread+0x86>
  panic("bget: no buffers");
    800024f4:	00006517          	auipc	a0,0x6
    800024f8:	f8450513          	addi	a0,a0,-124 # 80008478 <syscalls+0xd0>
    800024fc:	00004097          	auipc	ra,0x4
    80002500:	a70080e7          	jalr	-1424(ra) # 80005f6c <panic>
      b->dev = dev;
    80002504:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002508:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000250c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002510:	4785                	li	a5,1
    80002512:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002514:	00018517          	auipc	a0,0x18
    80002518:	22450513          	addi	a0,a0,548 # 8001a738 <bcache>
    8000251c:	00004097          	auipc	ra,0x4
    80002520:	03c080e7          	jalr	60(ra) # 80006558 <release>
      acquiresleep(&b->lock);
    80002524:	01048513          	addi	a0,s1,16
    80002528:	00001097          	auipc	ra,0x1
    8000252c:	414080e7          	jalr	1044(ra) # 8000393c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002530:	409c                	lw	a5,0(s1)
    80002532:	cb89                	beqz	a5,80002544 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002534:	8526                	mv	a0,s1
    80002536:	70a2                	ld	ra,40(sp)
    80002538:	7402                	ld	s0,32(sp)
    8000253a:	64e2                	ld	s1,24(sp)
    8000253c:	6942                	ld	s2,16(sp)
    8000253e:	69a2                	ld	s3,8(sp)
    80002540:	6145                	addi	sp,sp,48
    80002542:	8082                	ret
    virtio_disk_rw(b, 0);
    80002544:	4581                	li	a1,0
    80002546:	8526                	mv	a0,s1
    80002548:	00003097          	auipc	ra,0x3
    8000254c:	21a080e7          	jalr	538(ra) # 80005762 <virtio_disk_rw>
    b->valid = 1;
    80002550:	4785                	li	a5,1
    80002552:	c09c                	sw	a5,0(s1)
  return b;
    80002554:	b7c5                	j	80002534 <bread+0xd0>

0000000080002556 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002556:	1101                	addi	sp,sp,-32
    80002558:	ec06                	sd	ra,24(sp)
    8000255a:	e822                	sd	s0,16(sp)
    8000255c:	e426                	sd	s1,8(sp)
    8000255e:	1000                	addi	s0,sp,32
    80002560:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002562:	0541                	addi	a0,a0,16
    80002564:	00001097          	auipc	ra,0x1
    80002568:	472080e7          	jalr	1138(ra) # 800039d6 <holdingsleep>
    8000256c:	cd01                	beqz	a0,80002584 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000256e:	4585                	li	a1,1
    80002570:	8526                	mv	a0,s1
    80002572:	00003097          	auipc	ra,0x3
    80002576:	1f0080e7          	jalr	496(ra) # 80005762 <virtio_disk_rw>
}
    8000257a:	60e2                	ld	ra,24(sp)
    8000257c:	6442                	ld	s0,16(sp)
    8000257e:	64a2                	ld	s1,8(sp)
    80002580:	6105                	addi	sp,sp,32
    80002582:	8082                	ret
    panic("bwrite");
    80002584:	00006517          	auipc	a0,0x6
    80002588:	f0c50513          	addi	a0,a0,-244 # 80008490 <syscalls+0xe8>
    8000258c:	00004097          	auipc	ra,0x4
    80002590:	9e0080e7          	jalr	-1568(ra) # 80005f6c <panic>

0000000080002594 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002594:	1101                	addi	sp,sp,-32
    80002596:	ec06                	sd	ra,24(sp)
    80002598:	e822                	sd	s0,16(sp)
    8000259a:	e426                	sd	s1,8(sp)
    8000259c:	e04a                	sd	s2,0(sp)
    8000259e:	1000                	addi	s0,sp,32
    800025a0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025a2:	01050913          	addi	s2,a0,16
    800025a6:	854a                	mv	a0,s2
    800025a8:	00001097          	auipc	ra,0x1
    800025ac:	42e080e7          	jalr	1070(ra) # 800039d6 <holdingsleep>
    800025b0:	c92d                	beqz	a0,80002622 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800025b2:	854a                	mv	a0,s2
    800025b4:	00001097          	auipc	ra,0x1
    800025b8:	3de080e7          	jalr	990(ra) # 80003992 <releasesleep>

  acquire(&bcache.lock);
    800025bc:	00018517          	auipc	a0,0x18
    800025c0:	17c50513          	addi	a0,a0,380 # 8001a738 <bcache>
    800025c4:	00004097          	auipc	ra,0x4
    800025c8:	ee0080e7          	jalr	-288(ra) # 800064a4 <acquire>
  b->refcnt--;
    800025cc:	40bc                	lw	a5,64(s1)
    800025ce:	37fd                	addiw	a5,a5,-1
    800025d0:	0007871b          	sext.w	a4,a5
    800025d4:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800025d6:	eb05                	bnez	a4,80002606 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800025d8:	68bc                	ld	a5,80(s1)
    800025da:	64b8                	ld	a4,72(s1)
    800025dc:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800025de:	64bc                	ld	a5,72(s1)
    800025e0:	68b8                	ld	a4,80(s1)
    800025e2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800025e4:	00020797          	auipc	a5,0x20
    800025e8:	15478793          	addi	a5,a5,340 # 80022738 <bcache+0x8000>
    800025ec:	2b87b703          	ld	a4,696(a5)
    800025f0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025f2:	00020717          	auipc	a4,0x20
    800025f6:	3ae70713          	addi	a4,a4,942 # 800229a0 <bcache+0x8268>
    800025fa:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800025fc:	2b87b703          	ld	a4,696(a5)
    80002600:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002602:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002606:	00018517          	auipc	a0,0x18
    8000260a:	13250513          	addi	a0,a0,306 # 8001a738 <bcache>
    8000260e:	00004097          	auipc	ra,0x4
    80002612:	f4a080e7          	jalr	-182(ra) # 80006558 <release>
}
    80002616:	60e2                	ld	ra,24(sp)
    80002618:	6442                	ld	s0,16(sp)
    8000261a:	64a2                	ld	s1,8(sp)
    8000261c:	6902                	ld	s2,0(sp)
    8000261e:	6105                	addi	sp,sp,32
    80002620:	8082                	ret
    panic("brelse");
    80002622:	00006517          	auipc	a0,0x6
    80002626:	e7650513          	addi	a0,a0,-394 # 80008498 <syscalls+0xf0>
    8000262a:	00004097          	auipc	ra,0x4
    8000262e:	942080e7          	jalr	-1726(ra) # 80005f6c <panic>

0000000080002632 <bpin>:

void
bpin(struct buf *b) {
    80002632:	1101                	addi	sp,sp,-32
    80002634:	ec06                	sd	ra,24(sp)
    80002636:	e822                	sd	s0,16(sp)
    80002638:	e426                	sd	s1,8(sp)
    8000263a:	1000                	addi	s0,sp,32
    8000263c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000263e:	00018517          	auipc	a0,0x18
    80002642:	0fa50513          	addi	a0,a0,250 # 8001a738 <bcache>
    80002646:	00004097          	auipc	ra,0x4
    8000264a:	e5e080e7          	jalr	-418(ra) # 800064a4 <acquire>
  b->refcnt++;
    8000264e:	40bc                	lw	a5,64(s1)
    80002650:	2785                	addiw	a5,a5,1
    80002652:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002654:	00018517          	auipc	a0,0x18
    80002658:	0e450513          	addi	a0,a0,228 # 8001a738 <bcache>
    8000265c:	00004097          	auipc	ra,0x4
    80002660:	efc080e7          	jalr	-260(ra) # 80006558 <release>
}
    80002664:	60e2                	ld	ra,24(sp)
    80002666:	6442                	ld	s0,16(sp)
    80002668:	64a2                	ld	s1,8(sp)
    8000266a:	6105                	addi	sp,sp,32
    8000266c:	8082                	ret

000000008000266e <bunpin>:

void
bunpin(struct buf *b) {
    8000266e:	1101                	addi	sp,sp,-32
    80002670:	ec06                	sd	ra,24(sp)
    80002672:	e822                	sd	s0,16(sp)
    80002674:	e426                	sd	s1,8(sp)
    80002676:	1000                	addi	s0,sp,32
    80002678:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000267a:	00018517          	auipc	a0,0x18
    8000267e:	0be50513          	addi	a0,a0,190 # 8001a738 <bcache>
    80002682:	00004097          	auipc	ra,0x4
    80002686:	e22080e7          	jalr	-478(ra) # 800064a4 <acquire>
  b->refcnt--;
    8000268a:	40bc                	lw	a5,64(s1)
    8000268c:	37fd                	addiw	a5,a5,-1
    8000268e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002690:	00018517          	auipc	a0,0x18
    80002694:	0a850513          	addi	a0,a0,168 # 8001a738 <bcache>
    80002698:	00004097          	auipc	ra,0x4
    8000269c:	ec0080e7          	jalr	-320(ra) # 80006558 <release>
}
    800026a0:	60e2                	ld	ra,24(sp)
    800026a2:	6442                	ld	s0,16(sp)
    800026a4:	64a2                	ld	s1,8(sp)
    800026a6:	6105                	addi	sp,sp,32
    800026a8:	8082                	ret

00000000800026aa <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800026aa:	1101                	addi	sp,sp,-32
    800026ac:	ec06                	sd	ra,24(sp)
    800026ae:	e822                	sd	s0,16(sp)
    800026b0:	e426                	sd	s1,8(sp)
    800026b2:	e04a                	sd	s2,0(sp)
    800026b4:	1000                	addi	s0,sp,32
    800026b6:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800026b8:	00d5d59b          	srliw	a1,a1,0xd
    800026bc:	00020797          	auipc	a5,0x20
    800026c0:	7587a783          	lw	a5,1880(a5) # 80022e14 <sb+0x1c>
    800026c4:	9dbd                	addw	a1,a1,a5
    800026c6:	00000097          	auipc	ra,0x0
    800026ca:	d9e080e7          	jalr	-610(ra) # 80002464 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800026ce:	0074f713          	andi	a4,s1,7
    800026d2:	4785                	li	a5,1
    800026d4:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800026d8:	14ce                	slli	s1,s1,0x33
    800026da:	90d9                	srli	s1,s1,0x36
    800026dc:	00950733          	add	a4,a0,s1
    800026e0:	05874703          	lbu	a4,88(a4)
    800026e4:	00e7f6b3          	and	a3,a5,a4
    800026e8:	c69d                	beqz	a3,80002716 <bfree+0x6c>
    800026ea:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800026ec:	94aa                	add	s1,s1,a0
    800026ee:	fff7c793          	not	a5,a5
    800026f2:	8f7d                	and	a4,a4,a5
    800026f4:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800026f8:	00001097          	auipc	ra,0x1
    800026fc:	126080e7          	jalr	294(ra) # 8000381e <log_write>
  brelse(bp);
    80002700:	854a                	mv	a0,s2
    80002702:	00000097          	auipc	ra,0x0
    80002706:	e92080e7          	jalr	-366(ra) # 80002594 <brelse>
}
    8000270a:	60e2                	ld	ra,24(sp)
    8000270c:	6442                	ld	s0,16(sp)
    8000270e:	64a2                	ld	s1,8(sp)
    80002710:	6902                	ld	s2,0(sp)
    80002712:	6105                	addi	sp,sp,32
    80002714:	8082                	ret
    panic("freeing free block");
    80002716:	00006517          	auipc	a0,0x6
    8000271a:	d8a50513          	addi	a0,a0,-630 # 800084a0 <syscalls+0xf8>
    8000271e:	00004097          	auipc	ra,0x4
    80002722:	84e080e7          	jalr	-1970(ra) # 80005f6c <panic>

0000000080002726 <balloc>:
{
    80002726:	711d                	addi	sp,sp,-96
    80002728:	ec86                	sd	ra,88(sp)
    8000272a:	e8a2                	sd	s0,80(sp)
    8000272c:	e4a6                	sd	s1,72(sp)
    8000272e:	e0ca                	sd	s2,64(sp)
    80002730:	fc4e                	sd	s3,56(sp)
    80002732:	f852                	sd	s4,48(sp)
    80002734:	f456                	sd	s5,40(sp)
    80002736:	f05a                	sd	s6,32(sp)
    80002738:	ec5e                	sd	s7,24(sp)
    8000273a:	e862                	sd	s8,16(sp)
    8000273c:	e466                	sd	s9,8(sp)
    8000273e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002740:	00020797          	auipc	a5,0x20
    80002744:	6bc7a783          	lw	a5,1724(a5) # 80022dfc <sb+0x4>
    80002748:	cff5                	beqz	a5,80002844 <balloc+0x11e>
    8000274a:	8baa                	mv	s7,a0
    8000274c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000274e:	00020b17          	auipc	s6,0x20
    80002752:	6aab0b13          	addi	s6,s6,1706 # 80022df8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002756:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002758:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000275a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000275c:	6c89                	lui	s9,0x2
    8000275e:	a061                	j	800027e6 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002760:	97ca                	add	a5,a5,s2
    80002762:	8e55                	or	a2,a2,a3
    80002764:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002768:	854a                	mv	a0,s2
    8000276a:	00001097          	auipc	ra,0x1
    8000276e:	0b4080e7          	jalr	180(ra) # 8000381e <log_write>
        brelse(bp);
    80002772:	854a                	mv	a0,s2
    80002774:	00000097          	auipc	ra,0x0
    80002778:	e20080e7          	jalr	-480(ra) # 80002594 <brelse>
  bp = bread(dev, bno);
    8000277c:	85a6                	mv	a1,s1
    8000277e:	855e                	mv	a0,s7
    80002780:	00000097          	auipc	ra,0x0
    80002784:	ce4080e7          	jalr	-796(ra) # 80002464 <bread>
    80002788:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000278a:	40000613          	li	a2,1024
    8000278e:	4581                	li	a1,0
    80002790:	05850513          	addi	a0,a0,88
    80002794:	ffffe097          	auipc	ra,0xffffe
    80002798:	9e6080e7          	jalr	-1562(ra) # 8000017a <memset>
  log_write(bp);
    8000279c:	854a                	mv	a0,s2
    8000279e:	00001097          	auipc	ra,0x1
    800027a2:	080080e7          	jalr	128(ra) # 8000381e <log_write>
  brelse(bp);
    800027a6:	854a                	mv	a0,s2
    800027a8:	00000097          	auipc	ra,0x0
    800027ac:	dec080e7          	jalr	-532(ra) # 80002594 <brelse>
}
    800027b0:	8526                	mv	a0,s1
    800027b2:	60e6                	ld	ra,88(sp)
    800027b4:	6446                	ld	s0,80(sp)
    800027b6:	64a6                	ld	s1,72(sp)
    800027b8:	6906                	ld	s2,64(sp)
    800027ba:	79e2                	ld	s3,56(sp)
    800027bc:	7a42                	ld	s4,48(sp)
    800027be:	7aa2                	ld	s5,40(sp)
    800027c0:	7b02                	ld	s6,32(sp)
    800027c2:	6be2                	ld	s7,24(sp)
    800027c4:	6c42                	ld	s8,16(sp)
    800027c6:	6ca2                	ld	s9,8(sp)
    800027c8:	6125                	addi	sp,sp,96
    800027ca:	8082                	ret
    brelse(bp);
    800027cc:	854a                	mv	a0,s2
    800027ce:	00000097          	auipc	ra,0x0
    800027d2:	dc6080e7          	jalr	-570(ra) # 80002594 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027d6:	015c87bb          	addw	a5,s9,s5
    800027da:	00078a9b          	sext.w	s5,a5
    800027de:	004b2703          	lw	a4,4(s6)
    800027e2:	06eaf163          	bgeu	s5,a4,80002844 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    800027e6:	41fad79b          	sraiw	a5,s5,0x1f
    800027ea:	0137d79b          	srliw	a5,a5,0x13
    800027ee:	015787bb          	addw	a5,a5,s5
    800027f2:	40d7d79b          	sraiw	a5,a5,0xd
    800027f6:	01cb2583          	lw	a1,28(s6)
    800027fa:	9dbd                	addw	a1,a1,a5
    800027fc:	855e                	mv	a0,s7
    800027fe:	00000097          	auipc	ra,0x0
    80002802:	c66080e7          	jalr	-922(ra) # 80002464 <bread>
    80002806:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002808:	004b2503          	lw	a0,4(s6)
    8000280c:	000a849b          	sext.w	s1,s5
    80002810:	8762                	mv	a4,s8
    80002812:	faa4fde3          	bgeu	s1,a0,800027cc <balloc+0xa6>
      m = 1 << (bi % 8);
    80002816:	00777693          	andi	a3,a4,7
    8000281a:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000281e:	41f7579b          	sraiw	a5,a4,0x1f
    80002822:	01d7d79b          	srliw	a5,a5,0x1d
    80002826:	9fb9                	addw	a5,a5,a4
    80002828:	4037d79b          	sraiw	a5,a5,0x3
    8000282c:	00f90633          	add	a2,s2,a5
    80002830:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    80002834:	00c6f5b3          	and	a1,a3,a2
    80002838:	d585                	beqz	a1,80002760 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000283a:	2705                	addiw	a4,a4,1
    8000283c:	2485                	addiw	s1,s1,1
    8000283e:	fd471ae3          	bne	a4,s4,80002812 <balloc+0xec>
    80002842:	b769                	j	800027cc <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80002844:	00006517          	auipc	a0,0x6
    80002848:	c7450513          	addi	a0,a0,-908 # 800084b8 <syscalls+0x110>
    8000284c:	00003097          	auipc	ra,0x3
    80002850:	76a080e7          	jalr	1898(ra) # 80005fb6 <printf>
  return 0;
    80002854:	4481                	li	s1,0
    80002856:	bfa9                	j	800027b0 <balloc+0x8a>

0000000080002858 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002858:	7179                	addi	sp,sp,-48
    8000285a:	f406                	sd	ra,40(sp)
    8000285c:	f022                	sd	s0,32(sp)
    8000285e:	ec26                	sd	s1,24(sp)
    80002860:	e84a                	sd	s2,16(sp)
    80002862:	e44e                	sd	s3,8(sp)
    80002864:	e052                	sd	s4,0(sp)
    80002866:	1800                	addi	s0,sp,48
    80002868:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000286a:	47ad                	li	a5,11
    8000286c:	02b7e863          	bltu	a5,a1,8000289c <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80002870:	02059793          	slli	a5,a1,0x20
    80002874:	01e7d593          	srli	a1,a5,0x1e
    80002878:	00b504b3          	add	s1,a0,a1
    8000287c:	0504a903          	lw	s2,80(s1)
    80002880:	06091e63          	bnez	s2,800028fc <bmap+0xa4>
      addr = balloc(ip->dev);
    80002884:	4108                	lw	a0,0(a0)
    80002886:	00000097          	auipc	ra,0x0
    8000288a:	ea0080e7          	jalr	-352(ra) # 80002726 <balloc>
    8000288e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002892:	06090563          	beqz	s2,800028fc <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    80002896:	0524a823          	sw	s2,80(s1)
    8000289a:	a08d                	j	800028fc <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000289c:	ff45849b          	addiw	s1,a1,-12
    800028a0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800028a4:	0ff00793          	li	a5,255
    800028a8:	08e7e563          	bltu	a5,a4,80002932 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800028ac:	08052903          	lw	s2,128(a0)
    800028b0:	00091d63          	bnez	s2,800028ca <bmap+0x72>
      addr = balloc(ip->dev);
    800028b4:	4108                	lw	a0,0(a0)
    800028b6:	00000097          	auipc	ra,0x0
    800028ba:	e70080e7          	jalr	-400(ra) # 80002726 <balloc>
    800028be:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800028c2:	02090d63          	beqz	s2,800028fc <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800028c6:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800028ca:	85ca                	mv	a1,s2
    800028cc:	0009a503          	lw	a0,0(s3)
    800028d0:	00000097          	auipc	ra,0x0
    800028d4:	b94080e7          	jalr	-1132(ra) # 80002464 <bread>
    800028d8:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800028da:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800028de:	02049713          	slli	a4,s1,0x20
    800028e2:	01e75593          	srli	a1,a4,0x1e
    800028e6:	00b784b3          	add	s1,a5,a1
    800028ea:	0004a903          	lw	s2,0(s1)
    800028ee:	02090063          	beqz	s2,8000290e <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800028f2:	8552                	mv	a0,s4
    800028f4:	00000097          	auipc	ra,0x0
    800028f8:	ca0080e7          	jalr	-864(ra) # 80002594 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800028fc:	854a                	mv	a0,s2
    800028fe:	70a2                	ld	ra,40(sp)
    80002900:	7402                	ld	s0,32(sp)
    80002902:	64e2                	ld	s1,24(sp)
    80002904:	6942                	ld	s2,16(sp)
    80002906:	69a2                	ld	s3,8(sp)
    80002908:	6a02                	ld	s4,0(sp)
    8000290a:	6145                	addi	sp,sp,48
    8000290c:	8082                	ret
      addr = balloc(ip->dev);
    8000290e:	0009a503          	lw	a0,0(s3)
    80002912:	00000097          	auipc	ra,0x0
    80002916:	e14080e7          	jalr	-492(ra) # 80002726 <balloc>
    8000291a:	0005091b          	sext.w	s2,a0
      if(addr){
    8000291e:	fc090ae3          	beqz	s2,800028f2 <bmap+0x9a>
        a[bn] = addr;
    80002922:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002926:	8552                	mv	a0,s4
    80002928:	00001097          	auipc	ra,0x1
    8000292c:	ef6080e7          	jalr	-266(ra) # 8000381e <log_write>
    80002930:	b7c9                	j	800028f2 <bmap+0x9a>
  panic("bmap: out of range");
    80002932:	00006517          	auipc	a0,0x6
    80002936:	b9e50513          	addi	a0,a0,-1122 # 800084d0 <syscalls+0x128>
    8000293a:	00003097          	auipc	ra,0x3
    8000293e:	632080e7          	jalr	1586(ra) # 80005f6c <panic>

0000000080002942 <iget>:
{
    80002942:	7179                	addi	sp,sp,-48
    80002944:	f406                	sd	ra,40(sp)
    80002946:	f022                	sd	s0,32(sp)
    80002948:	ec26                	sd	s1,24(sp)
    8000294a:	e84a                	sd	s2,16(sp)
    8000294c:	e44e                	sd	s3,8(sp)
    8000294e:	e052                	sd	s4,0(sp)
    80002950:	1800                	addi	s0,sp,48
    80002952:	89aa                	mv	s3,a0
    80002954:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002956:	00020517          	auipc	a0,0x20
    8000295a:	4c250513          	addi	a0,a0,1218 # 80022e18 <itable>
    8000295e:	00004097          	auipc	ra,0x4
    80002962:	b46080e7          	jalr	-1210(ra) # 800064a4 <acquire>
  empty = 0;
    80002966:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002968:	00020497          	auipc	s1,0x20
    8000296c:	4c848493          	addi	s1,s1,1224 # 80022e30 <itable+0x18>
    80002970:	00022697          	auipc	a3,0x22
    80002974:	f5068693          	addi	a3,a3,-176 # 800248c0 <log>
    80002978:	a039                	j	80002986 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000297a:	02090b63          	beqz	s2,800029b0 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000297e:	08848493          	addi	s1,s1,136
    80002982:	02d48a63          	beq	s1,a3,800029b6 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002986:	449c                	lw	a5,8(s1)
    80002988:	fef059e3          	blez	a5,8000297a <iget+0x38>
    8000298c:	4098                	lw	a4,0(s1)
    8000298e:	ff3716e3          	bne	a4,s3,8000297a <iget+0x38>
    80002992:	40d8                	lw	a4,4(s1)
    80002994:	ff4713e3          	bne	a4,s4,8000297a <iget+0x38>
      ip->ref++;
    80002998:	2785                	addiw	a5,a5,1
    8000299a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000299c:	00020517          	auipc	a0,0x20
    800029a0:	47c50513          	addi	a0,a0,1148 # 80022e18 <itable>
    800029a4:	00004097          	auipc	ra,0x4
    800029a8:	bb4080e7          	jalr	-1100(ra) # 80006558 <release>
      return ip;
    800029ac:	8926                	mv	s2,s1
    800029ae:	a03d                	j	800029dc <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029b0:	f7f9                	bnez	a5,8000297e <iget+0x3c>
    800029b2:	8926                	mv	s2,s1
    800029b4:	b7e9                	j	8000297e <iget+0x3c>
  if(empty == 0)
    800029b6:	02090c63          	beqz	s2,800029ee <iget+0xac>
  ip->dev = dev;
    800029ba:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800029be:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800029c2:	4785                	li	a5,1
    800029c4:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800029c8:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800029cc:	00020517          	auipc	a0,0x20
    800029d0:	44c50513          	addi	a0,a0,1100 # 80022e18 <itable>
    800029d4:	00004097          	auipc	ra,0x4
    800029d8:	b84080e7          	jalr	-1148(ra) # 80006558 <release>
}
    800029dc:	854a                	mv	a0,s2
    800029de:	70a2                	ld	ra,40(sp)
    800029e0:	7402                	ld	s0,32(sp)
    800029e2:	64e2                	ld	s1,24(sp)
    800029e4:	6942                	ld	s2,16(sp)
    800029e6:	69a2                	ld	s3,8(sp)
    800029e8:	6a02                	ld	s4,0(sp)
    800029ea:	6145                	addi	sp,sp,48
    800029ec:	8082                	ret
    panic("iget: no inodes");
    800029ee:	00006517          	auipc	a0,0x6
    800029f2:	afa50513          	addi	a0,a0,-1286 # 800084e8 <syscalls+0x140>
    800029f6:	00003097          	auipc	ra,0x3
    800029fa:	576080e7          	jalr	1398(ra) # 80005f6c <panic>

00000000800029fe <fsinit>:
fsinit(int dev) {
    800029fe:	7179                	addi	sp,sp,-48
    80002a00:	f406                	sd	ra,40(sp)
    80002a02:	f022                	sd	s0,32(sp)
    80002a04:	ec26                	sd	s1,24(sp)
    80002a06:	e84a                	sd	s2,16(sp)
    80002a08:	e44e                	sd	s3,8(sp)
    80002a0a:	1800                	addi	s0,sp,48
    80002a0c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a0e:	4585                	li	a1,1
    80002a10:	00000097          	auipc	ra,0x0
    80002a14:	a54080e7          	jalr	-1452(ra) # 80002464 <bread>
    80002a18:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a1a:	00020997          	auipc	s3,0x20
    80002a1e:	3de98993          	addi	s3,s3,990 # 80022df8 <sb>
    80002a22:	02000613          	li	a2,32
    80002a26:	05850593          	addi	a1,a0,88
    80002a2a:	854e                	mv	a0,s3
    80002a2c:	ffffd097          	auipc	ra,0xffffd
    80002a30:	7aa080e7          	jalr	1962(ra) # 800001d6 <memmove>
  brelse(bp);
    80002a34:	8526                	mv	a0,s1
    80002a36:	00000097          	auipc	ra,0x0
    80002a3a:	b5e080e7          	jalr	-1186(ra) # 80002594 <brelse>
  if(sb.magic != FSMAGIC)
    80002a3e:	0009a703          	lw	a4,0(s3)
    80002a42:	102037b7          	lui	a5,0x10203
    80002a46:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a4a:	02f71263          	bne	a4,a5,80002a6e <fsinit+0x70>
  initlog(dev, &sb);
    80002a4e:	00020597          	auipc	a1,0x20
    80002a52:	3aa58593          	addi	a1,a1,938 # 80022df8 <sb>
    80002a56:	854a                	mv	a0,s2
    80002a58:	00001097          	auipc	ra,0x1
    80002a5c:	b4a080e7          	jalr	-1206(ra) # 800035a2 <initlog>
}
    80002a60:	70a2                	ld	ra,40(sp)
    80002a62:	7402                	ld	s0,32(sp)
    80002a64:	64e2                	ld	s1,24(sp)
    80002a66:	6942                	ld	s2,16(sp)
    80002a68:	69a2                	ld	s3,8(sp)
    80002a6a:	6145                	addi	sp,sp,48
    80002a6c:	8082                	ret
    panic("invalid file system");
    80002a6e:	00006517          	auipc	a0,0x6
    80002a72:	a8a50513          	addi	a0,a0,-1398 # 800084f8 <syscalls+0x150>
    80002a76:	00003097          	auipc	ra,0x3
    80002a7a:	4f6080e7          	jalr	1270(ra) # 80005f6c <panic>

0000000080002a7e <iinit>:
{
    80002a7e:	7179                	addi	sp,sp,-48
    80002a80:	f406                	sd	ra,40(sp)
    80002a82:	f022                	sd	s0,32(sp)
    80002a84:	ec26                	sd	s1,24(sp)
    80002a86:	e84a                	sd	s2,16(sp)
    80002a88:	e44e                	sd	s3,8(sp)
    80002a8a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a8c:	00006597          	auipc	a1,0x6
    80002a90:	a8458593          	addi	a1,a1,-1404 # 80008510 <syscalls+0x168>
    80002a94:	00020517          	auipc	a0,0x20
    80002a98:	38450513          	addi	a0,a0,900 # 80022e18 <itable>
    80002a9c:	00004097          	auipc	ra,0x4
    80002aa0:	978080e7          	jalr	-1672(ra) # 80006414 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002aa4:	00020497          	auipc	s1,0x20
    80002aa8:	39c48493          	addi	s1,s1,924 # 80022e40 <itable+0x28>
    80002aac:	00022997          	auipc	s3,0x22
    80002ab0:	e2498993          	addi	s3,s3,-476 # 800248d0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002ab4:	00006917          	auipc	s2,0x6
    80002ab8:	a6490913          	addi	s2,s2,-1436 # 80008518 <syscalls+0x170>
    80002abc:	85ca                	mv	a1,s2
    80002abe:	8526                	mv	a0,s1
    80002ac0:	00001097          	auipc	ra,0x1
    80002ac4:	e42080e7          	jalr	-446(ra) # 80003902 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002ac8:	08848493          	addi	s1,s1,136
    80002acc:	ff3498e3          	bne	s1,s3,80002abc <iinit+0x3e>
}
    80002ad0:	70a2                	ld	ra,40(sp)
    80002ad2:	7402                	ld	s0,32(sp)
    80002ad4:	64e2                	ld	s1,24(sp)
    80002ad6:	6942                	ld	s2,16(sp)
    80002ad8:	69a2                	ld	s3,8(sp)
    80002ada:	6145                	addi	sp,sp,48
    80002adc:	8082                	ret

0000000080002ade <ialloc>:
{
    80002ade:	715d                	addi	sp,sp,-80
    80002ae0:	e486                	sd	ra,72(sp)
    80002ae2:	e0a2                	sd	s0,64(sp)
    80002ae4:	fc26                	sd	s1,56(sp)
    80002ae6:	f84a                	sd	s2,48(sp)
    80002ae8:	f44e                	sd	s3,40(sp)
    80002aea:	f052                	sd	s4,32(sp)
    80002aec:	ec56                	sd	s5,24(sp)
    80002aee:	e85a                	sd	s6,16(sp)
    80002af0:	e45e                	sd	s7,8(sp)
    80002af2:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002af4:	00020717          	auipc	a4,0x20
    80002af8:	31072703          	lw	a4,784(a4) # 80022e04 <sb+0xc>
    80002afc:	4785                	li	a5,1
    80002afe:	04e7fa63          	bgeu	a5,a4,80002b52 <ialloc+0x74>
    80002b02:	8aaa                	mv	s5,a0
    80002b04:	8bae                	mv	s7,a1
    80002b06:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b08:	00020a17          	auipc	s4,0x20
    80002b0c:	2f0a0a13          	addi	s4,s4,752 # 80022df8 <sb>
    80002b10:	00048b1b          	sext.w	s6,s1
    80002b14:	0044d593          	srli	a1,s1,0x4
    80002b18:	018a2783          	lw	a5,24(s4)
    80002b1c:	9dbd                	addw	a1,a1,a5
    80002b1e:	8556                	mv	a0,s5
    80002b20:	00000097          	auipc	ra,0x0
    80002b24:	944080e7          	jalr	-1724(ra) # 80002464 <bread>
    80002b28:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b2a:	05850993          	addi	s3,a0,88
    80002b2e:	00f4f793          	andi	a5,s1,15
    80002b32:	079a                	slli	a5,a5,0x6
    80002b34:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b36:	00099783          	lh	a5,0(s3)
    80002b3a:	c3a1                	beqz	a5,80002b7a <ialloc+0x9c>
    brelse(bp);
    80002b3c:	00000097          	auipc	ra,0x0
    80002b40:	a58080e7          	jalr	-1448(ra) # 80002594 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b44:	0485                	addi	s1,s1,1
    80002b46:	00ca2703          	lw	a4,12(s4)
    80002b4a:	0004879b          	sext.w	a5,s1
    80002b4e:	fce7e1e3          	bltu	a5,a4,80002b10 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002b52:	00006517          	auipc	a0,0x6
    80002b56:	9ce50513          	addi	a0,a0,-1586 # 80008520 <syscalls+0x178>
    80002b5a:	00003097          	auipc	ra,0x3
    80002b5e:	45c080e7          	jalr	1116(ra) # 80005fb6 <printf>
  return 0;
    80002b62:	4501                	li	a0,0
}
    80002b64:	60a6                	ld	ra,72(sp)
    80002b66:	6406                	ld	s0,64(sp)
    80002b68:	74e2                	ld	s1,56(sp)
    80002b6a:	7942                	ld	s2,48(sp)
    80002b6c:	79a2                	ld	s3,40(sp)
    80002b6e:	7a02                	ld	s4,32(sp)
    80002b70:	6ae2                	ld	s5,24(sp)
    80002b72:	6b42                	ld	s6,16(sp)
    80002b74:	6ba2                	ld	s7,8(sp)
    80002b76:	6161                	addi	sp,sp,80
    80002b78:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002b7a:	04000613          	li	a2,64
    80002b7e:	4581                	li	a1,0
    80002b80:	854e                	mv	a0,s3
    80002b82:	ffffd097          	auipc	ra,0xffffd
    80002b86:	5f8080e7          	jalr	1528(ra) # 8000017a <memset>
      dip->type = type;
    80002b8a:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b8e:	854a                	mv	a0,s2
    80002b90:	00001097          	auipc	ra,0x1
    80002b94:	c8e080e7          	jalr	-882(ra) # 8000381e <log_write>
      brelse(bp);
    80002b98:	854a                	mv	a0,s2
    80002b9a:	00000097          	auipc	ra,0x0
    80002b9e:	9fa080e7          	jalr	-1542(ra) # 80002594 <brelse>
      return iget(dev, inum);
    80002ba2:	85da                	mv	a1,s6
    80002ba4:	8556                	mv	a0,s5
    80002ba6:	00000097          	auipc	ra,0x0
    80002baa:	d9c080e7          	jalr	-612(ra) # 80002942 <iget>
    80002bae:	bf5d                	j	80002b64 <ialloc+0x86>

0000000080002bb0 <iupdate>:
{
    80002bb0:	1101                	addi	sp,sp,-32
    80002bb2:	ec06                	sd	ra,24(sp)
    80002bb4:	e822                	sd	s0,16(sp)
    80002bb6:	e426                	sd	s1,8(sp)
    80002bb8:	e04a                	sd	s2,0(sp)
    80002bba:	1000                	addi	s0,sp,32
    80002bbc:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bbe:	415c                	lw	a5,4(a0)
    80002bc0:	0047d79b          	srliw	a5,a5,0x4
    80002bc4:	00020597          	auipc	a1,0x20
    80002bc8:	24c5a583          	lw	a1,588(a1) # 80022e10 <sb+0x18>
    80002bcc:	9dbd                	addw	a1,a1,a5
    80002bce:	4108                	lw	a0,0(a0)
    80002bd0:	00000097          	auipc	ra,0x0
    80002bd4:	894080e7          	jalr	-1900(ra) # 80002464 <bread>
    80002bd8:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bda:	05850793          	addi	a5,a0,88
    80002bde:	40d8                	lw	a4,4(s1)
    80002be0:	8b3d                	andi	a4,a4,15
    80002be2:	071a                	slli	a4,a4,0x6
    80002be4:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002be6:	04449703          	lh	a4,68(s1)
    80002bea:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002bee:	04649703          	lh	a4,70(s1)
    80002bf2:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002bf6:	04849703          	lh	a4,72(s1)
    80002bfa:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002bfe:	04a49703          	lh	a4,74(s1)
    80002c02:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002c06:	44f8                	lw	a4,76(s1)
    80002c08:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c0a:	03400613          	li	a2,52
    80002c0e:	05048593          	addi	a1,s1,80
    80002c12:	00c78513          	addi	a0,a5,12
    80002c16:	ffffd097          	auipc	ra,0xffffd
    80002c1a:	5c0080e7          	jalr	1472(ra) # 800001d6 <memmove>
  log_write(bp);
    80002c1e:	854a                	mv	a0,s2
    80002c20:	00001097          	auipc	ra,0x1
    80002c24:	bfe080e7          	jalr	-1026(ra) # 8000381e <log_write>
  brelse(bp);
    80002c28:	854a                	mv	a0,s2
    80002c2a:	00000097          	auipc	ra,0x0
    80002c2e:	96a080e7          	jalr	-1686(ra) # 80002594 <brelse>
}
    80002c32:	60e2                	ld	ra,24(sp)
    80002c34:	6442                	ld	s0,16(sp)
    80002c36:	64a2                	ld	s1,8(sp)
    80002c38:	6902                	ld	s2,0(sp)
    80002c3a:	6105                	addi	sp,sp,32
    80002c3c:	8082                	ret

0000000080002c3e <idup>:
{
    80002c3e:	1101                	addi	sp,sp,-32
    80002c40:	ec06                	sd	ra,24(sp)
    80002c42:	e822                	sd	s0,16(sp)
    80002c44:	e426                	sd	s1,8(sp)
    80002c46:	1000                	addi	s0,sp,32
    80002c48:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c4a:	00020517          	auipc	a0,0x20
    80002c4e:	1ce50513          	addi	a0,a0,462 # 80022e18 <itable>
    80002c52:	00004097          	auipc	ra,0x4
    80002c56:	852080e7          	jalr	-1966(ra) # 800064a4 <acquire>
  ip->ref++;
    80002c5a:	449c                	lw	a5,8(s1)
    80002c5c:	2785                	addiw	a5,a5,1
    80002c5e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c60:	00020517          	auipc	a0,0x20
    80002c64:	1b850513          	addi	a0,a0,440 # 80022e18 <itable>
    80002c68:	00004097          	auipc	ra,0x4
    80002c6c:	8f0080e7          	jalr	-1808(ra) # 80006558 <release>
}
    80002c70:	8526                	mv	a0,s1
    80002c72:	60e2                	ld	ra,24(sp)
    80002c74:	6442                	ld	s0,16(sp)
    80002c76:	64a2                	ld	s1,8(sp)
    80002c78:	6105                	addi	sp,sp,32
    80002c7a:	8082                	ret

0000000080002c7c <ilock>:
{
    80002c7c:	1101                	addi	sp,sp,-32
    80002c7e:	ec06                	sd	ra,24(sp)
    80002c80:	e822                	sd	s0,16(sp)
    80002c82:	e426                	sd	s1,8(sp)
    80002c84:	e04a                	sd	s2,0(sp)
    80002c86:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c88:	c115                	beqz	a0,80002cac <ilock+0x30>
    80002c8a:	84aa                	mv	s1,a0
    80002c8c:	451c                	lw	a5,8(a0)
    80002c8e:	00f05f63          	blez	a5,80002cac <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c92:	0541                	addi	a0,a0,16
    80002c94:	00001097          	auipc	ra,0x1
    80002c98:	ca8080e7          	jalr	-856(ra) # 8000393c <acquiresleep>
  if(ip->valid == 0){
    80002c9c:	40bc                	lw	a5,64(s1)
    80002c9e:	cf99                	beqz	a5,80002cbc <ilock+0x40>
}
    80002ca0:	60e2                	ld	ra,24(sp)
    80002ca2:	6442                	ld	s0,16(sp)
    80002ca4:	64a2                	ld	s1,8(sp)
    80002ca6:	6902                	ld	s2,0(sp)
    80002ca8:	6105                	addi	sp,sp,32
    80002caa:	8082                	ret
    panic("ilock");
    80002cac:	00006517          	auipc	a0,0x6
    80002cb0:	88c50513          	addi	a0,a0,-1908 # 80008538 <syscalls+0x190>
    80002cb4:	00003097          	auipc	ra,0x3
    80002cb8:	2b8080e7          	jalr	696(ra) # 80005f6c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cbc:	40dc                	lw	a5,4(s1)
    80002cbe:	0047d79b          	srliw	a5,a5,0x4
    80002cc2:	00020597          	auipc	a1,0x20
    80002cc6:	14e5a583          	lw	a1,334(a1) # 80022e10 <sb+0x18>
    80002cca:	9dbd                	addw	a1,a1,a5
    80002ccc:	4088                	lw	a0,0(s1)
    80002cce:	fffff097          	auipc	ra,0xfffff
    80002cd2:	796080e7          	jalr	1942(ra) # 80002464 <bread>
    80002cd6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cd8:	05850593          	addi	a1,a0,88
    80002cdc:	40dc                	lw	a5,4(s1)
    80002cde:	8bbd                	andi	a5,a5,15
    80002ce0:	079a                	slli	a5,a5,0x6
    80002ce2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002ce4:	00059783          	lh	a5,0(a1)
    80002ce8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002cec:	00259783          	lh	a5,2(a1)
    80002cf0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002cf4:	00459783          	lh	a5,4(a1)
    80002cf8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002cfc:	00659783          	lh	a5,6(a1)
    80002d00:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d04:	459c                	lw	a5,8(a1)
    80002d06:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d08:	03400613          	li	a2,52
    80002d0c:	05b1                	addi	a1,a1,12
    80002d0e:	05048513          	addi	a0,s1,80
    80002d12:	ffffd097          	auipc	ra,0xffffd
    80002d16:	4c4080e7          	jalr	1220(ra) # 800001d6 <memmove>
    brelse(bp);
    80002d1a:	854a                	mv	a0,s2
    80002d1c:	00000097          	auipc	ra,0x0
    80002d20:	878080e7          	jalr	-1928(ra) # 80002594 <brelse>
    ip->valid = 1;
    80002d24:	4785                	li	a5,1
    80002d26:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d28:	04449783          	lh	a5,68(s1)
    80002d2c:	fbb5                	bnez	a5,80002ca0 <ilock+0x24>
      panic("ilock: no type");
    80002d2e:	00006517          	auipc	a0,0x6
    80002d32:	81250513          	addi	a0,a0,-2030 # 80008540 <syscalls+0x198>
    80002d36:	00003097          	auipc	ra,0x3
    80002d3a:	236080e7          	jalr	566(ra) # 80005f6c <panic>

0000000080002d3e <iunlock>:
{
    80002d3e:	1101                	addi	sp,sp,-32
    80002d40:	ec06                	sd	ra,24(sp)
    80002d42:	e822                	sd	s0,16(sp)
    80002d44:	e426                	sd	s1,8(sp)
    80002d46:	e04a                	sd	s2,0(sp)
    80002d48:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d4a:	c905                	beqz	a0,80002d7a <iunlock+0x3c>
    80002d4c:	84aa                	mv	s1,a0
    80002d4e:	01050913          	addi	s2,a0,16
    80002d52:	854a                	mv	a0,s2
    80002d54:	00001097          	auipc	ra,0x1
    80002d58:	c82080e7          	jalr	-894(ra) # 800039d6 <holdingsleep>
    80002d5c:	cd19                	beqz	a0,80002d7a <iunlock+0x3c>
    80002d5e:	449c                	lw	a5,8(s1)
    80002d60:	00f05d63          	blez	a5,80002d7a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d64:	854a                	mv	a0,s2
    80002d66:	00001097          	auipc	ra,0x1
    80002d6a:	c2c080e7          	jalr	-980(ra) # 80003992 <releasesleep>
}
    80002d6e:	60e2                	ld	ra,24(sp)
    80002d70:	6442                	ld	s0,16(sp)
    80002d72:	64a2                	ld	s1,8(sp)
    80002d74:	6902                	ld	s2,0(sp)
    80002d76:	6105                	addi	sp,sp,32
    80002d78:	8082                	ret
    panic("iunlock");
    80002d7a:	00005517          	auipc	a0,0x5
    80002d7e:	7d650513          	addi	a0,a0,2006 # 80008550 <syscalls+0x1a8>
    80002d82:	00003097          	auipc	ra,0x3
    80002d86:	1ea080e7          	jalr	490(ra) # 80005f6c <panic>

0000000080002d8a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d8a:	7179                	addi	sp,sp,-48
    80002d8c:	f406                	sd	ra,40(sp)
    80002d8e:	f022                	sd	s0,32(sp)
    80002d90:	ec26                	sd	s1,24(sp)
    80002d92:	e84a                	sd	s2,16(sp)
    80002d94:	e44e                	sd	s3,8(sp)
    80002d96:	e052                	sd	s4,0(sp)
    80002d98:	1800                	addi	s0,sp,48
    80002d9a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d9c:	05050493          	addi	s1,a0,80
    80002da0:	08050913          	addi	s2,a0,128
    80002da4:	a021                	j	80002dac <itrunc+0x22>
    80002da6:	0491                	addi	s1,s1,4
    80002da8:	01248d63          	beq	s1,s2,80002dc2 <itrunc+0x38>
    if(ip->addrs[i]){
    80002dac:	408c                	lw	a1,0(s1)
    80002dae:	dde5                	beqz	a1,80002da6 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002db0:	0009a503          	lw	a0,0(s3)
    80002db4:	00000097          	auipc	ra,0x0
    80002db8:	8f6080e7          	jalr	-1802(ra) # 800026aa <bfree>
      ip->addrs[i] = 0;
    80002dbc:	0004a023          	sw	zero,0(s1)
    80002dc0:	b7dd                	j	80002da6 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002dc2:	0809a583          	lw	a1,128(s3)
    80002dc6:	e185                	bnez	a1,80002de6 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002dc8:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002dcc:	854e                	mv	a0,s3
    80002dce:	00000097          	auipc	ra,0x0
    80002dd2:	de2080e7          	jalr	-542(ra) # 80002bb0 <iupdate>
}
    80002dd6:	70a2                	ld	ra,40(sp)
    80002dd8:	7402                	ld	s0,32(sp)
    80002dda:	64e2                	ld	s1,24(sp)
    80002ddc:	6942                	ld	s2,16(sp)
    80002dde:	69a2                	ld	s3,8(sp)
    80002de0:	6a02                	ld	s4,0(sp)
    80002de2:	6145                	addi	sp,sp,48
    80002de4:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002de6:	0009a503          	lw	a0,0(s3)
    80002dea:	fffff097          	auipc	ra,0xfffff
    80002dee:	67a080e7          	jalr	1658(ra) # 80002464 <bread>
    80002df2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002df4:	05850493          	addi	s1,a0,88
    80002df8:	45850913          	addi	s2,a0,1112
    80002dfc:	a021                	j	80002e04 <itrunc+0x7a>
    80002dfe:	0491                	addi	s1,s1,4
    80002e00:	01248b63          	beq	s1,s2,80002e16 <itrunc+0x8c>
      if(a[j])
    80002e04:	408c                	lw	a1,0(s1)
    80002e06:	dde5                	beqz	a1,80002dfe <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002e08:	0009a503          	lw	a0,0(s3)
    80002e0c:	00000097          	auipc	ra,0x0
    80002e10:	89e080e7          	jalr	-1890(ra) # 800026aa <bfree>
    80002e14:	b7ed                	j	80002dfe <itrunc+0x74>
    brelse(bp);
    80002e16:	8552                	mv	a0,s4
    80002e18:	fffff097          	auipc	ra,0xfffff
    80002e1c:	77c080e7          	jalr	1916(ra) # 80002594 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e20:	0809a583          	lw	a1,128(s3)
    80002e24:	0009a503          	lw	a0,0(s3)
    80002e28:	00000097          	auipc	ra,0x0
    80002e2c:	882080e7          	jalr	-1918(ra) # 800026aa <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e30:	0809a023          	sw	zero,128(s3)
    80002e34:	bf51                	j	80002dc8 <itrunc+0x3e>

0000000080002e36 <iput>:
{
    80002e36:	1101                	addi	sp,sp,-32
    80002e38:	ec06                	sd	ra,24(sp)
    80002e3a:	e822                	sd	s0,16(sp)
    80002e3c:	e426                	sd	s1,8(sp)
    80002e3e:	e04a                	sd	s2,0(sp)
    80002e40:	1000                	addi	s0,sp,32
    80002e42:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e44:	00020517          	auipc	a0,0x20
    80002e48:	fd450513          	addi	a0,a0,-44 # 80022e18 <itable>
    80002e4c:	00003097          	auipc	ra,0x3
    80002e50:	658080e7          	jalr	1624(ra) # 800064a4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e54:	4498                	lw	a4,8(s1)
    80002e56:	4785                	li	a5,1
    80002e58:	02f70363          	beq	a4,a5,80002e7e <iput+0x48>
  ip->ref--;
    80002e5c:	449c                	lw	a5,8(s1)
    80002e5e:	37fd                	addiw	a5,a5,-1
    80002e60:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e62:	00020517          	auipc	a0,0x20
    80002e66:	fb650513          	addi	a0,a0,-74 # 80022e18 <itable>
    80002e6a:	00003097          	auipc	ra,0x3
    80002e6e:	6ee080e7          	jalr	1774(ra) # 80006558 <release>
}
    80002e72:	60e2                	ld	ra,24(sp)
    80002e74:	6442                	ld	s0,16(sp)
    80002e76:	64a2                	ld	s1,8(sp)
    80002e78:	6902                	ld	s2,0(sp)
    80002e7a:	6105                	addi	sp,sp,32
    80002e7c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e7e:	40bc                	lw	a5,64(s1)
    80002e80:	dff1                	beqz	a5,80002e5c <iput+0x26>
    80002e82:	04a49783          	lh	a5,74(s1)
    80002e86:	fbf9                	bnez	a5,80002e5c <iput+0x26>
    acquiresleep(&ip->lock);
    80002e88:	01048913          	addi	s2,s1,16
    80002e8c:	854a                	mv	a0,s2
    80002e8e:	00001097          	auipc	ra,0x1
    80002e92:	aae080e7          	jalr	-1362(ra) # 8000393c <acquiresleep>
    release(&itable.lock);
    80002e96:	00020517          	auipc	a0,0x20
    80002e9a:	f8250513          	addi	a0,a0,-126 # 80022e18 <itable>
    80002e9e:	00003097          	auipc	ra,0x3
    80002ea2:	6ba080e7          	jalr	1722(ra) # 80006558 <release>
    itrunc(ip);
    80002ea6:	8526                	mv	a0,s1
    80002ea8:	00000097          	auipc	ra,0x0
    80002eac:	ee2080e7          	jalr	-286(ra) # 80002d8a <itrunc>
    ip->type = 0;
    80002eb0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002eb4:	8526                	mv	a0,s1
    80002eb6:	00000097          	auipc	ra,0x0
    80002eba:	cfa080e7          	jalr	-774(ra) # 80002bb0 <iupdate>
    ip->valid = 0;
    80002ebe:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002ec2:	854a                	mv	a0,s2
    80002ec4:	00001097          	auipc	ra,0x1
    80002ec8:	ace080e7          	jalr	-1330(ra) # 80003992 <releasesleep>
    acquire(&itable.lock);
    80002ecc:	00020517          	auipc	a0,0x20
    80002ed0:	f4c50513          	addi	a0,a0,-180 # 80022e18 <itable>
    80002ed4:	00003097          	auipc	ra,0x3
    80002ed8:	5d0080e7          	jalr	1488(ra) # 800064a4 <acquire>
    80002edc:	b741                	j	80002e5c <iput+0x26>

0000000080002ede <iunlockput>:
{
    80002ede:	1101                	addi	sp,sp,-32
    80002ee0:	ec06                	sd	ra,24(sp)
    80002ee2:	e822                	sd	s0,16(sp)
    80002ee4:	e426                	sd	s1,8(sp)
    80002ee6:	1000                	addi	s0,sp,32
    80002ee8:	84aa                	mv	s1,a0
  iunlock(ip);
    80002eea:	00000097          	auipc	ra,0x0
    80002eee:	e54080e7          	jalr	-428(ra) # 80002d3e <iunlock>
  iput(ip);
    80002ef2:	8526                	mv	a0,s1
    80002ef4:	00000097          	auipc	ra,0x0
    80002ef8:	f42080e7          	jalr	-190(ra) # 80002e36 <iput>
}
    80002efc:	60e2                	ld	ra,24(sp)
    80002efe:	6442                	ld	s0,16(sp)
    80002f00:	64a2                	ld	s1,8(sp)
    80002f02:	6105                	addi	sp,sp,32
    80002f04:	8082                	ret

0000000080002f06 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f06:	1141                	addi	sp,sp,-16
    80002f08:	e422                	sd	s0,8(sp)
    80002f0a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f0c:	411c                	lw	a5,0(a0)
    80002f0e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f10:	415c                	lw	a5,4(a0)
    80002f12:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f14:	04451783          	lh	a5,68(a0)
    80002f18:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f1c:	04a51783          	lh	a5,74(a0)
    80002f20:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f24:	04c56783          	lwu	a5,76(a0)
    80002f28:	e99c                	sd	a5,16(a1)
}
    80002f2a:	6422                	ld	s0,8(sp)
    80002f2c:	0141                	addi	sp,sp,16
    80002f2e:	8082                	ret

0000000080002f30 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f30:	457c                	lw	a5,76(a0)
    80002f32:	0ed7e963          	bltu	a5,a3,80003024 <readi+0xf4>
{
    80002f36:	7159                	addi	sp,sp,-112
    80002f38:	f486                	sd	ra,104(sp)
    80002f3a:	f0a2                	sd	s0,96(sp)
    80002f3c:	eca6                	sd	s1,88(sp)
    80002f3e:	e8ca                	sd	s2,80(sp)
    80002f40:	e4ce                	sd	s3,72(sp)
    80002f42:	e0d2                	sd	s4,64(sp)
    80002f44:	fc56                	sd	s5,56(sp)
    80002f46:	f85a                	sd	s6,48(sp)
    80002f48:	f45e                	sd	s7,40(sp)
    80002f4a:	f062                	sd	s8,32(sp)
    80002f4c:	ec66                	sd	s9,24(sp)
    80002f4e:	e86a                	sd	s10,16(sp)
    80002f50:	e46e                	sd	s11,8(sp)
    80002f52:	1880                	addi	s0,sp,112
    80002f54:	8b2a                	mv	s6,a0
    80002f56:	8bae                	mv	s7,a1
    80002f58:	8a32                	mv	s4,a2
    80002f5a:	84b6                	mv	s1,a3
    80002f5c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002f5e:	9f35                	addw	a4,a4,a3
    return 0;
    80002f60:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f62:	0ad76063          	bltu	a4,a3,80003002 <readi+0xd2>
  if(off + n > ip->size)
    80002f66:	00e7f463          	bgeu	a5,a4,80002f6e <readi+0x3e>
    n = ip->size - off;
    80002f6a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f6e:	0a0a8963          	beqz	s5,80003020 <readi+0xf0>
    80002f72:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f74:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f78:	5c7d                	li	s8,-1
    80002f7a:	a82d                	j	80002fb4 <readi+0x84>
    80002f7c:	020d1d93          	slli	s11,s10,0x20
    80002f80:	020ddd93          	srli	s11,s11,0x20
    80002f84:	05890613          	addi	a2,s2,88
    80002f88:	86ee                	mv	a3,s11
    80002f8a:	963a                	add	a2,a2,a4
    80002f8c:	85d2                	mv	a1,s4
    80002f8e:	855e                	mv	a0,s7
    80002f90:	fffff097          	auipc	ra,0xfffff
    80002f94:	9f8080e7          	jalr	-1544(ra) # 80001988 <either_copyout>
    80002f98:	05850d63          	beq	a0,s8,80002ff2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f9c:	854a                	mv	a0,s2
    80002f9e:	fffff097          	auipc	ra,0xfffff
    80002fa2:	5f6080e7          	jalr	1526(ra) # 80002594 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fa6:	013d09bb          	addw	s3,s10,s3
    80002faa:	009d04bb          	addw	s1,s10,s1
    80002fae:	9a6e                	add	s4,s4,s11
    80002fb0:	0559f763          	bgeu	s3,s5,80002ffe <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002fb4:	00a4d59b          	srliw	a1,s1,0xa
    80002fb8:	855a                	mv	a0,s6
    80002fba:	00000097          	auipc	ra,0x0
    80002fbe:	89e080e7          	jalr	-1890(ra) # 80002858 <bmap>
    80002fc2:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002fc6:	cd85                	beqz	a1,80002ffe <readi+0xce>
    bp = bread(ip->dev, addr);
    80002fc8:	000b2503          	lw	a0,0(s6)
    80002fcc:	fffff097          	auipc	ra,0xfffff
    80002fd0:	498080e7          	jalr	1176(ra) # 80002464 <bread>
    80002fd4:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fd6:	3ff4f713          	andi	a4,s1,1023
    80002fda:	40ec87bb          	subw	a5,s9,a4
    80002fde:	413a86bb          	subw	a3,s5,s3
    80002fe2:	8d3e                	mv	s10,a5
    80002fe4:	2781                	sext.w	a5,a5
    80002fe6:	0006861b          	sext.w	a2,a3
    80002fea:	f8f679e3          	bgeu	a2,a5,80002f7c <readi+0x4c>
    80002fee:	8d36                	mv	s10,a3
    80002ff0:	b771                	j	80002f7c <readi+0x4c>
      brelse(bp);
    80002ff2:	854a                	mv	a0,s2
    80002ff4:	fffff097          	auipc	ra,0xfffff
    80002ff8:	5a0080e7          	jalr	1440(ra) # 80002594 <brelse>
      tot = -1;
    80002ffc:	59fd                	li	s3,-1
  }
  return tot;
    80002ffe:	0009851b          	sext.w	a0,s3
}
    80003002:	70a6                	ld	ra,104(sp)
    80003004:	7406                	ld	s0,96(sp)
    80003006:	64e6                	ld	s1,88(sp)
    80003008:	6946                	ld	s2,80(sp)
    8000300a:	69a6                	ld	s3,72(sp)
    8000300c:	6a06                	ld	s4,64(sp)
    8000300e:	7ae2                	ld	s5,56(sp)
    80003010:	7b42                	ld	s6,48(sp)
    80003012:	7ba2                	ld	s7,40(sp)
    80003014:	7c02                	ld	s8,32(sp)
    80003016:	6ce2                	ld	s9,24(sp)
    80003018:	6d42                	ld	s10,16(sp)
    8000301a:	6da2                	ld	s11,8(sp)
    8000301c:	6165                	addi	sp,sp,112
    8000301e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003020:	89d6                	mv	s3,s5
    80003022:	bff1                	j	80002ffe <readi+0xce>
    return 0;
    80003024:	4501                	li	a0,0
}
    80003026:	8082                	ret

0000000080003028 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003028:	457c                	lw	a5,76(a0)
    8000302a:	10d7e863          	bltu	a5,a3,8000313a <writei+0x112>
{
    8000302e:	7159                	addi	sp,sp,-112
    80003030:	f486                	sd	ra,104(sp)
    80003032:	f0a2                	sd	s0,96(sp)
    80003034:	eca6                	sd	s1,88(sp)
    80003036:	e8ca                	sd	s2,80(sp)
    80003038:	e4ce                	sd	s3,72(sp)
    8000303a:	e0d2                	sd	s4,64(sp)
    8000303c:	fc56                	sd	s5,56(sp)
    8000303e:	f85a                	sd	s6,48(sp)
    80003040:	f45e                	sd	s7,40(sp)
    80003042:	f062                	sd	s8,32(sp)
    80003044:	ec66                	sd	s9,24(sp)
    80003046:	e86a                	sd	s10,16(sp)
    80003048:	e46e                	sd	s11,8(sp)
    8000304a:	1880                	addi	s0,sp,112
    8000304c:	8aaa                	mv	s5,a0
    8000304e:	8bae                	mv	s7,a1
    80003050:	8a32                	mv	s4,a2
    80003052:	8936                	mv	s2,a3
    80003054:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003056:	00e687bb          	addw	a5,a3,a4
    8000305a:	0ed7e263          	bltu	a5,a3,8000313e <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000305e:	00043737          	lui	a4,0x43
    80003062:	0ef76063          	bltu	a4,a5,80003142 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003066:	0c0b0863          	beqz	s6,80003136 <writei+0x10e>
    8000306a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000306c:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003070:	5c7d                	li	s8,-1
    80003072:	a091                	j	800030b6 <writei+0x8e>
    80003074:	020d1d93          	slli	s11,s10,0x20
    80003078:	020ddd93          	srli	s11,s11,0x20
    8000307c:	05848513          	addi	a0,s1,88
    80003080:	86ee                	mv	a3,s11
    80003082:	8652                	mv	a2,s4
    80003084:	85de                	mv	a1,s7
    80003086:	953a                	add	a0,a0,a4
    80003088:	fffff097          	auipc	ra,0xfffff
    8000308c:	956080e7          	jalr	-1706(ra) # 800019de <either_copyin>
    80003090:	07850263          	beq	a0,s8,800030f4 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003094:	8526                	mv	a0,s1
    80003096:	00000097          	auipc	ra,0x0
    8000309a:	788080e7          	jalr	1928(ra) # 8000381e <log_write>
    brelse(bp);
    8000309e:	8526                	mv	a0,s1
    800030a0:	fffff097          	auipc	ra,0xfffff
    800030a4:	4f4080e7          	jalr	1268(ra) # 80002594 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030a8:	013d09bb          	addw	s3,s10,s3
    800030ac:	012d093b          	addw	s2,s10,s2
    800030b0:	9a6e                	add	s4,s4,s11
    800030b2:	0569f663          	bgeu	s3,s6,800030fe <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800030b6:	00a9559b          	srliw	a1,s2,0xa
    800030ba:	8556                	mv	a0,s5
    800030bc:	fffff097          	auipc	ra,0xfffff
    800030c0:	79c080e7          	jalr	1948(ra) # 80002858 <bmap>
    800030c4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800030c8:	c99d                	beqz	a1,800030fe <writei+0xd6>
    bp = bread(ip->dev, addr);
    800030ca:	000aa503          	lw	a0,0(s5)
    800030ce:	fffff097          	auipc	ra,0xfffff
    800030d2:	396080e7          	jalr	918(ra) # 80002464 <bread>
    800030d6:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030d8:	3ff97713          	andi	a4,s2,1023
    800030dc:	40ec87bb          	subw	a5,s9,a4
    800030e0:	413b06bb          	subw	a3,s6,s3
    800030e4:	8d3e                	mv	s10,a5
    800030e6:	2781                	sext.w	a5,a5
    800030e8:	0006861b          	sext.w	a2,a3
    800030ec:	f8f674e3          	bgeu	a2,a5,80003074 <writei+0x4c>
    800030f0:	8d36                	mv	s10,a3
    800030f2:	b749                	j	80003074 <writei+0x4c>
      brelse(bp);
    800030f4:	8526                	mv	a0,s1
    800030f6:	fffff097          	auipc	ra,0xfffff
    800030fa:	49e080e7          	jalr	1182(ra) # 80002594 <brelse>
  }

  if(off > ip->size)
    800030fe:	04caa783          	lw	a5,76(s5)
    80003102:	0127f463          	bgeu	a5,s2,8000310a <writei+0xe2>
    ip->size = off;
    80003106:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000310a:	8556                	mv	a0,s5
    8000310c:	00000097          	auipc	ra,0x0
    80003110:	aa4080e7          	jalr	-1372(ra) # 80002bb0 <iupdate>

  return tot;
    80003114:	0009851b          	sext.w	a0,s3
}
    80003118:	70a6                	ld	ra,104(sp)
    8000311a:	7406                	ld	s0,96(sp)
    8000311c:	64e6                	ld	s1,88(sp)
    8000311e:	6946                	ld	s2,80(sp)
    80003120:	69a6                	ld	s3,72(sp)
    80003122:	6a06                	ld	s4,64(sp)
    80003124:	7ae2                	ld	s5,56(sp)
    80003126:	7b42                	ld	s6,48(sp)
    80003128:	7ba2                	ld	s7,40(sp)
    8000312a:	7c02                	ld	s8,32(sp)
    8000312c:	6ce2                	ld	s9,24(sp)
    8000312e:	6d42                	ld	s10,16(sp)
    80003130:	6da2                	ld	s11,8(sp)
    80003132:	6165                	addi	sp,sp,112
    80003134:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003136:	89da                	mv	s3,s6
    80003138:	bfc9                	j	8000310a <writei+0xe2>
    return -1;
    8000313a:	557d                	li	a0,-1
}
    8000313c:	8082                	ret
    return -1;
    8000313e:	557d                	li	a0,-1
    80003140:	bfe1                	j	80003118 <writei+0xf0>
    return -1;
    80003142:	557d                	li	a0,-1
    80003144:	bfd1                	j	80003118 <writei+0xf0>

0000000080003146 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003146:	1141                	addi	sp,sp,-16
    80003148:	e406                	sd	ra,8(sp)
    8000314a:	e022                	sd	s0,0(sp)
    8000314c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000314e:	4639                	li	a2,14
    80003150:	ffffd097          	auipc	ra,0xffffd
    80003154:	0fa080e7          	jalr	250(ra) # 8000024a <strncmp>
}
    80003158:	60a2                	ld	ra,8(sp)
    8000315a:	6402                	ld	s0,0(sp)
    8000315c:	0141                	addi	sp,sp,16
    8000315e:	8082                	ret

0000000080003160 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003160:	7139                	addi	sp,sp,-64
    80003162:	fc06                	sd	ra,56(sp)
    80003164:	f822                	sd	s0,48(sp)
    80003166:	f426                	sd	s1,40(sp)
    80003168:	f04a                	sd	s2,32(sp)
    8000316a:	ec4e                	sd	s3,24(sp)
    8000316c:	e852                	sd	s4,16(sp)
    8000316e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003170:	04451703          	lh	a4,68(a0)
    80003174:	4785                	li	a5,1
    80003176:	00f71a63          	bne	a4,a5,8000318a <dirlookup+0x2a>
    8000317a:	892a                	mv	s2,a0
    8000317c:	89ae                	mv	s3,a1
    8000317e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003180:	457c                	lw	a5,76(a0)
    80003182:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003184:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003186:	e79d                	bnez	a5,800031b4 <dirlookup+0x54>
    80003188:	a8a5                	j	80003200 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000318a:	00005517          	auipc	a0,0x5
    8000318e:	3ce50513          	addi	a0,a0,974 # 80008558 <syscalls+0x1b0>
    80003192:	00003097          	auipc	ra,0x3
    80003196:	dda080e7          	jalr	-550(ra) # 80005f6c <panic>
      panic("dirlookup read");
    8000319a:	00005517          	auipc	a0,0x5
    8000319e:	3d650513          	addi	a0,a0,982 # 80008570 <syscalls+0x1c8>
    800031a2:	00003097          	auipc	ra,0x3
    800031a6:	dca080e7          	jalr	-566(ra) # 80005f6c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031aa:	24c1                	addiw	s1,s1,16
    800031ac:	04c92783          	lw	a5,76(s2)
    800031b0:	04f4f763          	bgeu	s1,a5,800031fe <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031b4:	4741                	li	a4,16
    800031b6:	86a6                	mv	a3,s1
    800031b8:	fc040613          	addi	a2,s0,-64
    800031bc:	4581                	li	a1,0
    800031be:	854a                	mv	a0,s2
    800031c0:	00000097          	auipc	ra,0x0
    800031c4:	d70080e7          	jalr	-656(ra) # 80002f30 <readi>
    800031c8:	47c1                	li	a5,16
    800031ca:	fcf518e3          	bne	a0,a5,8000319a <dirlookup+0x3a>
    if(de.inum == 0)
    800031ce:	fc045783          	lhu	a5,-64(s0)
    800031d2:	dfe1                	beqz	a5,800031aa <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800031d4:	fc240593          	addi	a1,s0,-62
    800031d8:	854e                	mv	a0,s3
    800031da:	00000097          	auipc	ra,0x0
    800031de:	f6c080e7          	jalr	-148(ra) # 80003146 <namecmp>
    800031e2:	f561                	bnez	a0,800031aa <dirlookup+0x4a>
      if(poff)
    800031e4:	000a0463          	beqz	s4,800031ec <dirlookup+0x8c>
        *poff = off;
    800031e8:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031ec:	fc045583          	lhu	a1,-64(s0)
    800031f0:	00092503          	lw	a0,0(s2)
    800031f4:	fffff097          	auipc	ra,0xfffff
    800031f8:	74e080e7          	jalr	1870(ra) # 80002942 <iget>
    800031fc:	a011                	j	80003200 <dirlookup+0xa0>
  return 0;
    800031fe:	4501                	li	a0,0
}
    80003200:	70e2                	ld	ra,56(sp)
    80003202:	7442                	ld	s0,48(sp)
    80003204:	74a2                	ld	s1,40(sp)
    80003206:	7902                	ld	s2,32(sp)
    80003208:	69e2                	ld	s3,24(sp)
    8000320a:	6a42                	ld	s4,16(sp)
    8000320c:	6121                	addi	sp,sp,64
    8000320e:	8082                	ret

0000000080003210 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003210:	711d                	addi	sp,sp,-96
    80003212:	ec86                	sd	ra,88(sp)
    80003214:	e8a2                	sd	s0,80(sp)
    80003216:	e4a6                	sd	s1,72(sp)
    80003218:	e0ca                	sd	s2,64(sp)
    8000321a:	fc4e                	sd	s3,56(sp)
    8000321c:	f852                	sd	s4,48(sp)
    8000321e:	f456                	sd	s5,40(sp)
    80003220:	f05a                	sd	s6,32(sp)
    80003222:	ec5e                	sd	s7,24(sp)
    80003224:	e862                	sd	s8,16(sp)
    80003226:	e466                	sd	s9,8(sp)
    80003228:	e06a                	sd	s10,0(sp)
    8000322a:	1080                	addi	s0,sp,96
    8000322c:	84aa                	mv	s1,a0
    8000322e:	8b2e                	mv	s6,a1
    80003230:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003232:	00054703          	lbu	a4,0(a0)
    80003236:	02f00793          	li	a5,47
    8000323a:	02f70363          	beq	a4,a5,80003260 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000323e:	ffffe097          	auipc	ra,0xffffe
    80003242:	bfc080e7          	jalr	-1028(ra) # 80000e3a <myproc>
    80003246:	15053503          	ld	a0,336(a0)
    8000324a:	00000097          	auipc	ra,0x0
    8000324e:	9f4080e7          	jalr	-1548(ra) # 80002c3e <idup>
    80003252:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003254:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003258:	4cb5                	li	s9,13
  len = path - s;
    8000325a:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000325c:	4c05                	li	s8,1
    8000325e:	a87d                	j	8000331c <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003260:	4585                	li	a1,1
    80003262:	4505                	li	a0,1
    80003264:	fffff097          	auipc	ra,0xfffff
    80003268:	6de080e7          	jalr	1758(ra) # 80002942 <iget>
    8000326c:	8a2a                	mv	s4,a0
    8000326e:	b7dd                	j	80003254 <namex+0x44>
      iunlockput(ip);
    80003270:	8552                	mv	a0,s4
    80003272:	00000097          	auipc	ra,0x0
    80003276:	c6c080e7          	jalr	-916(ra) # 80002ede <iunlockput>
      return 0;
    8000327a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000327c:	8552                	mv	a0,s4
    8000327e:	60e6                	ld	ra,88(sp)
    80003280:	6446                	ld	s0,80(sp)
    80003282:	64a6                	ld	s1,72(sp)
    80003284:	6906                	ld	s2,64(sp)
    80003286:	79e2                	ld	s3,56(sp)
    80003288:	7a42                	ld	s4,48(sp)
    8000328a:	7aa2                	ld	s5,40(sp)
    8000328c:	7b02                	ld	s6,32(sp)
    8000328e:	6be2                	ld	s7,24(sp)
    80003290:	6c42                	ld	s8,16(sp)
    80003292:	6ca2                	ld	s9,8(sp)
    80003294:	6d02                	ld	s10,0(sp)
    80003296:	6125                	addi	sp,sp,96
    80003298:	8082                	ret
      iunlock(ip);
    8000329a:	8552                	mv	a0,s4
    8000329c:	00000097          	auipc	ra,0x0
    800032a0:	aa2080e7          	jalr	-1374(ra) # 80002d3e <iunlock>
      return ip;
    800032a4:	bfe1                	j	8000327c <namex+0x6c>
      iunlockput(ip);
    800032a6:	8552                	mv	a0,s4
    800032a8:	00000097          	auipc	ra,0x0
    800032ac:	c36080e7          	jalr	-970(ra) # 80002ede <iunlockput>
      return 0;
    800032b0:	8a4e                	mv	s4,s3
    800032b2:	b7e9                	j	8000327c <namex+0x6c>
  len = path - s;
    800032b4:	40998633          	sub	a2,s3,s1
    800032b8:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800032bc:	09acd863          	bge	s9,s10,8000334c <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800032c0:	4639                	li	a2,14
    800032c2:	85a6                	mv	a1,s1
    800032c4:	8556                	mv	a0,s5
    800032c6:	ffffd097          	auipc	ra,0xffffd
    800032ca:	f10080e7          	jalr	-240(ra) # 800001d6 <memmove>
    800032ce:	84ce                	mv	s1,s3
  while(*path == '/')
    800032d0:	0004c783          	lbu	a5,0(s1)
    800032d4:	01279763          	bne	a5,s2,800032e2 <namex+0xd2>
    path++;
    800032d8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032da:	0004c783          	lbu	a5,0(s1)
    800032de:	ff278de3          	beq	a5,s2,800032d8 <namex+0xc8>
    ilock(ip);
    800032e2:	8552                	mv	a0,s4
    800032e4:	00000097          	auipc	ra,0x0
    800032e8:	998080e7          	jalr	-1640(ra) # 80002c7c <ilock>
    if(ip->type != T_DIR){
    800032ec:	044a1783          	lh	a5,68(s4)
    800032f0:	f98790e3          	bne	a5,s8,80003270 <namex+0x60>
    if(nameiparent && *path == '\0'){
    800032f4:	000b0563          	beqz	s6,800032fe <namex+0xee>
    800032f8:	0004c783          	lbu	a5,0(s1)
    800032fc:	dfd9                	beqz	a5,8000329a <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800032fe:	865e                	mv	a2,s7
    80003300:	85d6                	mv	a1,s5
    80003302:	8552                	mv	a0,s4
    80003304:	00000097          	auipc	ra,0x0
    80003308:	e5c080e7          	jalr	-420(ra) # 80003160 <dirlookup>
    8000330c:	89aa                	mv	s3,a0
    8000330e:	dd41                	beqz	a0,800032a6 <namex+0x96>
    iunlockput(ip);
    80003310:	8552                	mv	a0,s4
    80003312:	00000097          	auipc	ra,0x0
    80003316:	bcc080e7          	jalr	-1076(ra) # 80002ede <iunlockput>
    ip = next;
    8000331a:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000331c:	0004c783          	lbu	a5,0(s1)
    80003320:	01279763          	bne	a5,s2,8000332e <namex+0x11e>
    path++;
    80003324:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003326:	0004c783          	lbu	a5,0(s1)
    8000332a:	ff278de3          	beq	a5,s2,80003324 <namex+0x114>
  if(*path == 0)
    8000332e:	cb9d                	beqz	a5,80003364 <namex+0x154>
  while(*path != '/' && *path != 0)
    80003330:	0004c783          	lbu	a5,0(s1)
    80003334:	89a6                	mv	s3,s1
  len = path - s;
    80003336:	8d5e                	mv	s10,s7
    80003338:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000333a:	01278963          	beq	a5,s2,8000334c <namex+0x13c>
    8000333e:	dbbd                	beqz	a5,800032b4 <namex+0xa4>
    path++;
    80003340:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003342:	0009c783          	lbu	a5,0(s3)
    80003346:	ff279ce3          	bne	a5,s2,8000333e <namex+0x12e>
    8000334a:	b7ad                	j	800032b4 <namex+0xa4>
    memmove(name, s, len);
    8000334c:	2601                	sext.w	a2,a2
    8000334e:	85a6                	mv	a1,s1
    80003350:	8556                	mv	a0,s5
    80003352:	ffffd097          	auipc	ra,0xffffd
    80003356:	e84080e7          	jalr	-380(ra) # 800001d6 <memmove>
    name[len] = 0;
    8000335a:	9d56                	add	s10,s10,s5
    8000335c:	000d0023          	sb	zero,0(s10)
    80003360:	84ce                	mv	s1,s3
    80003362:	b7bd                	j	800032d0 <namex+0xc0>
  if(nameiparent){
    80003364:	f00b0ce3          	beqz	s6,8000327c <namex+0x6c>
    iput(ip);
    80003368:	8552                	mv	a0,s4
    8000336a:	00000097          	auipc	ra,0x0
    8000336e:	acc080e7          	jalr	-1332(ra) # 80002e36 <iput>
    return 0;
    80003372:	4a01                	li	s4,0
    80003374:	b721                	j	8000327c <namex+0x6c>

0000000080003376 <dirlink>:
{
    80003376:	7139                	addi	sp,sp,-64
    80003378:	fc06                	sd	ra,56(sp)
    8000337a:	f822                	sd	s0,48(sp)
    8000337c:	f426                	sd	s1,40(sp)
    8000337e:	f04a                	sd	s2,32(sp)
    80003380:	ec4e                	sd	s3,24(sp)
    80003382:	e852                	sd	s4,16(sp)
    80003384:	0080                	addi	s0,sp,64
    80003386:	892a                	mv	s2,a0
    80003388:	8a2e                	mv	s4,a1
    8000338a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000338c:	4601                	li	a2,0
    8000338e:	00000097          	auipc	ra,0x0
    80003392:	dd2080e7          	jalr	-558(ra) # 80003160 <dirlookup>
    80003396:	e93d                	bnez	a0,8000340c <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003398:	04c92483          	lw	s1,76(s2)
    8000339c:	c49d                	beqz	s1,800033ca <dirlink+0x54>
    8000339e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033a0:	4741                	li	a4,16
    800033a2:	86a6                	mv	a3,s1
    800033a4:	fc040613          	addi	a2,s0,-64
    800033a8:	4581                	li	a1,0
    800033aa:	854a                	mv	a0,s2
    800033ac:	00000097          	auipc	ra,0x0
    800033b0:	b84080e7          	jalr	-1148(ra) # 80002f30 <readi>
    800033b4:	47c1                	li	a5,16
    800033b6:	06f51163          	bne	a0,a5,80003418 <dirlink+0xa2>
    if(de.inum == 0)
    800033ba:	fc045783          	lhu	a5,-64(s0)
    800033be:	c791                	beqz	a5,800033ca <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033c0:	24c1                	addiw	s1,s1,16
    800033c2:	04c92783          	lw	a5,76(s2)
    800033c6:	fcf4ede3          	bltu	s1,a5,800033a0 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800033ca:	4639                	li	a2,14
    800033cc:	85d2                	mv	a1,s4
    800033ce:	fc240513          	addi	a0,s0,-62
    800033d2:	ffffd097          	auipc	ra,0xffffd
    800033d6:	eb4080e7          	jalr	-332(ra) # 80000286 <strncpy>
  de.inum = inum;
    800033da:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033de:	4741                	li	a4,16
    800033e0:	86a6                	mv	a3,s1
    800033e2:	fc040613          	addi	a2,s0,-64
    800033e6:	4581                	li	a1,0
    800033e8:	854a                	mv	a0,s2
    800033ea:	00000097          	auipc	ra,0x0
    800033ee:	c3e080e7          	jalr	-962(ra) # 80003028 <writei>
    800033f2:	1541                	addi	a0,a0,-16
    800033f4:	00a03533          	snez	a0,a0
    800033f8:	40a00533          	neg	a0,a0
}
    800033fc:	70e2                	ld	ra,56(sp)
    800033fe:	7442                	ld	s0,48(sp)
    80003400:	74a2                	ld	s1,40(sp)
    80003402:	7902                	ld	s2,32(sp)
    80003404:	69e2                	ld	s3,24(sp)
    80003406:	6a42                	ld	s4,16(sp)
    80003408:	6121                	addi	sp,sp,64
    8000340a:	8082                	ret
    iput(ip);
    8000340c:	00000097          	auipc	ra,0x0
    80003410:	a2a080e7          	jalr	-1494(ra) # 80002e36 <iput>
    return -1;
    80003414:	557d                	li	a0,-1
    80003416:	b7dd                	j	800033fc <dirlink+0x86>
      panic("dirlink read");
    80003418:	00005517          	auipc	a0,0x5
    8000341c:	16850513          	addi	a0,a0,360 # 80008580 <syscalls+0x1d8>
    80003420:	00003097          	auipc	ra,0x3
    80003424:	b4c080e7          	jalr	-1204(ra) # 80005f6c <panic>

0000000080003428 <namei>:

struct inode*
namei(char *path)
{
    80003428:	1101                	addi	sp,sp,-32
    8000342a:	ec06                	sd	ra,24(sp)
    8000342c:	e822                	sd	s0,16(sp)
    8000342e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003430:	fe040613          	addi	a2,s0,-32
    80003434:	4581                	li	a1,0
    80003436:	00000097          	auipc	ra,0x0
    8000343a:	dda080e7          	jalr	-550(ra) # 80003210 <namex>
}
    8000343e:	60e2                	ld	ra,24(sp)
    80003440:	6442                	ld	s0,16(sp)
    80003442:	6105                	addi	sp,sp,32
    80003444:	8082                	ret

0000000080003446 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003446:	1141                	addi	sp,sp,-16
    80003448:	e406                	sd	ra,8(sp)
    8000344a:	e022                	sd	s0,0(sp)
    8000344c:	0800                	addi	s0,sp,16
    8000344e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003450:	4585                	li	a1,1
    80003452:	00000097          	auipc	ra,0x0
    80003456:	dbe080e7          	jalr	-578(ra) # 80003210 <namex>
}
    8000345a:	60a2                	ld	ra,8(sp)
    8000345c:	6402                	ld	s0,0(sp)
    8000345e:	0141                	addi	sp,sp,16
    80003460:	8082                	ret

0000000080003462 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003462:	1101                	addi	sp,sp,-32
    80003464:	ec06                	sd	ra,24(sp)
    80003466:	e822                	sd	s0,16(sp)
    80003468:	e426                	sd	s1,8(sp)
    8000346a:	e04a                	sd	s2,0(sp)
    8000346c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000346e:	00021917          	auipc	s2,0x21
    80003472:	45290913          	addi	s2,s2,1106 # 800248c0 <log>
    80003476:	01892583          	lw	a1,24(s2)
    8000347a:	02892503          	lw	a0,40(s2)
    8000347e:	fffff097          	auipc	ra,0xfffff
    80003482:	fe6080e7          	jalr	-26(ra) # 80002464 <bread>
    80003486:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003488:	02c92683          	lw	a3,44(s2)
    8000348c:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000348e:	02d05863          	blez	a3,800034be <write_head+0x5c>
    80003492:	00021797          	auipc	a5,0x21
    80003496:	45e78793          	addi	a5,a5,1118 # 800248f0 <log+0x30>
    8000349a:	05c50713          	addi	a4,a0,92
    8000349e:	36fd                	addiw	a3,a3,-1
    800034a0:	02069613          	slli	a2,a3,0x20
    800034a4:	01e65693          	srli	a3,a2,0x1e
    800034a8:	00021617          	auipc	a2,0x21
    800034ac:	44c60613          	addi	a2,a2,1100 # 800248f4 <log+0x34>
    800034b0:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800034b2:	4390                	lw	a2,0(a5)
    800034b4:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034b6:	0791                	addi	a5,a5,4
    800034b8:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    800034ba:	fed79ce3          	bne	a5,a3,800034b2 <write_head+0x50>
  }
  bwrite(buf);
    800034be:	8526                	mv	a0,s1
    800034c0:	fffff097          	auipc	ra,0xfffff
    800034c4:	096080e7          	jalr	150(ra) # 80002556 <bwrite>
  brelse(buf);
    800034c8:	8526                	mv	a0,s1
    800034ca:	fffff097          	auipc	ra,0xfffff
    800034ce:	0ca080e7          	jalr	202(ra) # 80002594 <brelse>
}
    800034d2:	60e2                	ld	ra,24(sp)
    800034d4:	6442                	ld	s0,16(sp)
    800034d6:	64a2                	ld	s1,8(sp)
    800034d8:	6902                	ld	s2,0(sp)
    800034da:	6105                	addi	sp,sp,32
    800034dc:	8082                	ret

00000000800034de <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800034de:	00021797          	auipc	a5,0x21
    800034e2:	40e7a783          	lw	a5,1038(a5) # 800248ec <log+0x2c>
    800034e6:	0af05d63          	blez	a5,800035a0 <install_trans+0xc2>
{
    800034ea:	7139                	addi	sp,sp,-64
    800034ec:	fc06                	sd	ra,56(sp)
    800034ee:	f822                	sd	s0,48(sp)
    800034f0:	f426                	sd	s1,40(sp)
    800034f2:	f04a                	sd	s2,32(sp)
    800034f4:	ec4e                	sd	s3,24(sp)
    800034f6:	e852                	sd	s4,16(sp)
    800034f8:	e456                	sd	s5,8(sp)
    800034fa:	e05a                	sd	s6,0(sp)
    800034fc:	0080                	addi	s0,sp,64
    800034fe:	8b2a                	mv	s6,a0
    80003500:	00021a97          	auipc	s5,0x21
    80003504:	3f0a8a93          	addi	s5,s5,1008 # 800248f0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003508:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000350a:	00021997          	auipc	s3,0x21
    8000350e:	3b698993          	addi	s3,s3,950 # 800248c0 <log>
    80003512:	a00d                	j	80003534 <install_trans+0x56>
    brelse(lbuf);
    80003514:	854a                	mv	a0,s2
    80003516:	fffff097          	auipc	ra,0xfffff
    8000351a:	07e080e7          	jalr	126(ra) # 80002594 <brelse>
    brelse(dbuf);
    8000351e:	8526                	mv	a0,s1
    80003520:	fffff097          	auipc	ra,0xfffff
    80003524:	074080e7          	jalr	116(ra) # 80002594 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003528:	2a05                	addiw	s4,s4,1
    8000352a:	0a91                	addi	s5,s5,4
    8000352c:	02c9a783          	lw	a5,44(s3)
    80003530:	04fa5e63          	bge	s4,a5,8000358c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003534:	0189a583          	lw	a1,24(s3)
    80003538:	014585bb          	addw	a1,a1,s4
    8000353c:	2585                	addiw	a1,a1,1
    8000353e:	0289a503          	lw	a0,40(s3)
    80003542:	fffff097          	auipc	ra,0xfffff
    80003546:	f22080e7          	jalr	-222(ra) # 80002464 <bread>
    8000354a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000354c:	000aa583          	lw	a1,0(s5)
    80003550:	0289a503          	lw	a0,40(s3)
    80003554:	fffff097          	auipc	ra,0xfffff
    80003558:	f10080e7          	jalr	-240(ra) # 80002464 <bread>
    8000355c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000355e:	40000613          	li	a2,1024
    80003562:	05890593          	addi	a1,s2,88
    80003566:	05850513          	addi	a0,a0,88
    8000356a:	ffffd097          	auipc	ra,0xffffd
    8000356e:	c6c080e7          	jalr	-916(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003572:	8526                	mv	a0,s1
    80003574:	fffff097          	auipc	ra,0xfffff
    80003578:	fe2080e7          	jalr	-30(ra) # 80002556 <bwrite>
    if(recovering == 0)
    8000357c:	f80b1ce3          	bnez	s6,80003514 <install_trans+0x36>
      bunpin(dbuf);
    80003580:	8526                	mv	a0,s1
    80003582:	fffff097          	auipc	ra,0xfffff
    80003586:	0ec080e7          	jalr	236(ra) # 8000266e <bunpin>
    8000358a:	b769                	j	80003514 <install_trans+0x36>
}
    8000358c:	70e2                	ld	ra,56(sp)
    8000358e:	7442                	ld	s0,48(sp)
    80003590:	74a2                	ld	s1,40(sp)
    80003592:	7902                	ld	s2,32(sp)
    80003594:	69e2                	ld	s3,24(sp)
    80003596:	6a42                	ld	s4,16(sp)
    80003598:	6aa2                	ld	s5,8(sp)
    8000359a:	6b02                	ld	s6,0(sp)
    8000359c:	6121                	addi	sp,sp,64
    8000359e:	8082                	ret
    800035a0:	8082                	ret

00000000800035a2 <initlog>:
{
    800035a2:	7179                	addi	sp,sp,-48
    800035a4:	f406                	sd	ra,40(sp)
    800035a6:	f022                	sd	s0,32(sp)
    800035a8:	ec26                	sd	s1,24(sp)
    800035aa:	e84a                	sd	s2,16(sp)
    800035ac:	e44e                	sd	s3,8(sp)
    800035ae:	1800                	addi	s0,sp,48
    800035b0:	892a                	mv	s2,a0
    800035b2:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035b4:	00021497          	auipc	s1,0x21
    800035b8:	30c48493          	addi	s1,s1,780 # 800248c0 <log>
    800035bc:	00005597          	auipc	a1,0x5
    800035c0:	fd458593          	addi	a1,a1,-44 # 80008590 <syscalls+0x1e8>
    800035c4:	8526                	mv	a0,s1
    800035c6:	00003097          	auipc	ra,0x3
    800035ca:	e4e080e7          	jalr	-434(ra) # 80006414 <initlock>
  log.start = sb->logstart;
    800035ce:	0149a583          	lw	a1,20(s3)
    800035d2:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800035d4:	0109a783          	lw	a5,16(s3)
    800035d8:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800035da:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800035de:	854a                	mv	a0,s2
    800035e0:	fffff097          	auipc	ra,0xfffff
    800035e4:	e84080e7          	jalr	-380(ra) # 80002464 <bread>
  log.lh.n = lh->n;
    800035e8:	4d34                	lw	a3,88(a0)
    800035ea:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800035ec:	02d05663          	blez	a3,80003618 <initlog+0x76>
    800035f0:	05c50793          	addi	a5,a0,92
    800035f4:	00021717          	auipc	a4,0x21
    800035f8:	2fc70713          	addi	a4,a4,764 # 800248f0 <log+0x30>
    800035fc:	36fd                	addiw	a3,a3,-1
    800035fe:	02069613          	slli	a2,a3,0x20
    80003602:	01e65693          	srli	a3,a2,0x1e
    80003606:	06050613          	addi	a2,a0,96
    8000360a:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    8000360c:	4390                	lw	a2,0(a5)
    8000360e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003610:	0791                	addi	a5,a5,4
    80003612:	0711                	addi	a4,a4,4
    80003614:	fed79ce3          	bne	a5,a3,8000360c <initlog+0x6a>
  brelse(buf);
    80003618:	fffff097          	auipc	ra,0xfffff
    8000361c:	f7c080e7          	jalr	-132(ra) # 80002594 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003620:	4505                	li	a0,1
    80003622:	00000097          	auipc	ra,0x0
    80003626:	ebc080e7          	jalr	-324(ra) # 800034de <install_trans>
  log.lh.n = 0;
    8000362a:	00021797          	auipc	a5,0x21
    8000362e:	2c07a123          	sw	zero,706(a5) # 800248ec <log+0x2c>
  write_head(); // clear the log
    80003632:	00000097          	auipc	ra,0x0
    80003636:	e30080e7          	jalr	-464(ra) # 80003462 <write_head>
}
    8000363a:	70a2                	ld	ra,40(sp)
    8000363c:	7402                	ld	s0,32(sp)
    8000363e:	64e2                	ld	s1,24(sp)
    80003640:	6942                	ld	s2,16(sp)
    80003642:	69a2                	ld	s3,8(sp)
    80003644:	6145                	addi	sp,sp,48
    80003646:	8082                	ret

0000000080003648 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003648:	1101                	addi	sp,sp,-32
    8000364a:	ec06                	sd	ra,24(sp)
    8000364c:	e822                	sd	s0,16(sp)
    8000364e:	e426                	sd	s1,8(sp)
    80003650:	e04a                	sd	s2,0(sp)
    80003652:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003654:	00021517          	auipc	a0,0x21
    80003658:	26c50513          	addi	a0,a0,620 # 800248c0 <log>
    8000365c:	00003097          	auipc	ra,0x3
    80003660:	e48080e7          	jalr	-440(ra) # 800064a4 <acquire>
  while(1){
    if(log.committing){
    80003664:	00021497          	auipc	s1,0x21
    80003668:	25c48493          	addi	s1,s1,604 # 800248c0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000366c:	4979                	li	s2,30
    8000366e:	a039                	j	8000367c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003670:	85a6                	mv	a1,s1
    80003672:	8526                	mv	a0,s1
    80003674:	ffffe097          	auipc	ra,0xffffe
    80003678:	ea8080e7          	jalr	-344(ra) # 8000151c <sleep>
    if(log.committing){
    8000367c:	50dc                	lw	a5,36(s1)
    8000367e:	fbed                	bnez	a5,80003670 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003680:	5098                	lw	a4,32(s1)
    80003682:	2705                	addiw	a4,a4,1
    80003684:	0007069b          	sext.w	a3,a4
    80003688:	0027179b          	slliw	a5,a4,0x2
    8000368c:	9fb9                	addw	a5,a5,a4
    8000368e:	0017979b          	slliw	a5,a5,0x1
    80003692:	54d8                	lw	a4,44(s1)
    80003694:	9fb9                	addw	a5,a5,a4
    80003696:	00f95963          	bge	s2,a5,800036a8 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000369a:	85a6                	mv	a1,s1
    8000369c:	8526                	mv	a0,s1
    8000369e:	ffffe097          	auipc	ra,0xffffe
    800036a2:	e7e080e7          	jalr	-386(ra) # 8000151c <sleep>
    800036a6:	bfd9                	j	8000367c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800036a8:	00021517          	auipc	a0,0x21
    800036ac:	21850513          	addi	a0,a0,536 # 800248c0 <log>
    800036b0:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800036b2:	00003097          	auipc	ra,0x3
    800036b6:	ea6080e7          	jalr	-346(ra) # 80006558 <release>
      break;
    }
  }
}
    800036ba:	60e2                	ld	ra,24(sp)
    800036bc:	6442                	ld	s0,16(sp)
    800036be:	64a2                	ld	s1,8(sp)
    800036c0:	6902                	ld	s2,0(sp)
    800036c2:	6105                	addi	sp,sp,32
    800036c4:	8082                	ret

00000000800036c6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036c6:	7139                	addi	sp,sp,-64
    800036c8:	fc06                	sd	ra,56(sp)
    800036ca:	f822                	sd	s0,48(sp)
    800036cc:	f426                	sd	s1,40(sp)
    800036ce:	f04a                	sd	s2,32(sp)
    800036d0:	ec4e                	sd	s3,24(sp)
    800036d2:	e852                	sd	s4,16(sp)
    800036d4:	e456                	sd	s5,8(sp)
    800036d6:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800036d8:	00021497          	auipc	s1,0x21
    800036dc:	1e848493          	addi	s1,s1,488 # 800248c0 <log>
    800036e0:	8526                	mv	a0,s1
    800036e2:	00003097          	auipc	ra,0x3
    800036e6:	dc2080e7          	jalr	-574(ra) # 800064a4 <acquire>
  log.outstanding -= 1;
    800036ea:	509c                	lw	a5,32(s1)
    800036ec:	37fd                	addiw	a5,a5,-1
    800036ee:	0007891b          	sext.w	s2,a5
    800036f2:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800036f4:	50dc                	lw	a5,36(s1)
    800036f6:	e7b9                	bnez	a5,80003744 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800036f8:	04091e63          	bnez	s2,80003754 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800036fc:	00021497          	auipc	s1,0x21
    80003700:	1c448493          	addi	s1,s1,452 # 800248c0 <log>
    80003704:	4785                	li	a5,1
    80003706:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003708:	8526                	mv	a0,s1
    8000370a:	00003097          	auipc	ra,0x3
    8000370e:	e4e080e7          	jalr	-434(ra) # 80006558 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003712:	54dc                	lw	a5,44(s1)
    80003714:	06f04763          	bgtz	a5,80003782 <end_op+0xbc>
    acquire(&log.lock);
    80003718:	00021497          	auipc	s1,0x21
    8000371c:	1a848493          	addi	s1,s1,424 # 800248c0 <log>
    80003720:	8526                	mv	a0,s1
    80003722:	00003097          	auipc	ra,0x3
    80003726:	d82080e7          	jalr	-638(ra) # 800064a4 <acquire>
    log.committing = 0;
    8000372a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000372e:	8526                	mv	a0,s1
    80003730:	ffffe097          	auipc	ra,0xffffe
    80003734:	e50080e7          	jalr	-432(ra) # 80001580 <wakeup>
    release(&log.lock);
    80003738:	8526                	mv	a0,s1
    8000373a:	00003097          	auipc	ra,0x3
    8000373e:	e1e080e7          	jalr	-482(ra) # 80006558 <release>
}
    80003742:	a03d                	j	80003770 <end_op+0xaa>
    panic("log.committing");
    80003744:	00005517          	auipc	a0,0x5
    80003748:	e5450513          	addi	a0,a0,-428 # 80008598 <syscalls+0x1f0>
    8000374c:	00003097          	auipc	ra,0x3
    80003750:	820080e7          	jalr	-2016(ra) # 80005f6c <panic>
    wakeup(&log);
    80003754:	00021497          	auipc	s1,0x21
    80003758:	16c48493          	addi	s1,s1,364 # 800248c0 <log>
    8000375c:	8526                	mv	a0,s1
    8000375e:	ffffe097          	auipc	ra,0xffffe
    80003762:	e22080e7          	jalr	-478(ra) # 80001580 <wakeup>
  release(&log.lock);
    80003766:	8526                	mv	a0,s1
    80003768:	00003097          	auipc	ra,0x3
    8000376c:	df0080e7          	jalr	-528(ra) # 80006558 <release>
}
    80003770:	70e2                	ld	ra,56(sp)
    80003772:	7442                	ld	s0,48(sp)
    80003774:	74a2                	ld	s1,40(sp)
    80003776:	7902                	ld	s2,32(sp)
    80003778:	69e2                	ld	s3,24(sp)
    8000377a:	6a42                	ld	s4,16(sp)
    8000377c:	6aa2                	ld	s5,8(sp)
    8000377e:	6121                	addi	sp,sp,64
    80003780:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003782:	00021a97          	auipc	s5,0x21
    80003786:	16ea8a93          	addi	s5,s5,366 # 800248f0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000378a:	00021a17          	auipc	s4,0x21
    8000378e:	136a0a13          	addi	s4,s4,310 # 800248c0 <log>
    80003792:	018a2583          	lw	a1,24(s4)
    80003796:	012585bb          	addw	a1,a1,s2
    8000379a:	2585                	addiw	a1,a1,1
    8000379c:	028a2503          	lw	a0,40(s4)
    800037a0:	fffff097          	auipc	ra,0xfffff
    800037a4:	cc4080e7          	jalr	-828(ra) # 80002464 <bread>
    800037a8:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800037aa:	000aa583          	lw	a1,0(s5)
    800037ae:	028a2503          	lw	a0,40(s4)
    800037b2:	fffff097          	auipc	ra,0xfffff
    800037b6:	cb2080e7          	jalr	-846(ra) # 80002464 <bread>
    800037ba:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800037bc:	40000613          	li	a2,1024
    800037c0:	05850593          	addi	a1,a0,88
    800037c4:	05848513          	addi	a0,s1,88
    800037c8:	ffffd097          	auipc	ra,0xffffd
    800037cc:	a0e080e7          	jalr	-1522(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    800037d0:	8526                	mv	a0,s1
    800037d2:	fffff097          	auipc	ra,0xfffff
    800037d6:	d84080e7          	jalr	-636(ra) # 80002556 <bwrite>
    brelse(from);
    800037da:	854e                	mv	a0,s3
    800037dc:	fffff097          	auipc	ra,0xfffff
    800037e0:	db8080e7          	jalr	-584(ra) # 80002594 <brelse>
    brelse(to);
    800037e4:	8526                	mv	a0,s1
    800037e6:	fffff097          	auipc	ra,0xfffff
    800037ea:	dae080e7          	jalr	-594(ra) # 80002594 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037ee:	2905                	addiw	s2,s2,1
    800037f0:	0a91                	addi	s5,s5,4
    800037f2:	02ca2783          	lw	a5,44(s4)
    800037f6:	f8f94ee3          	blt	s2,a5,80003792 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037fa:	00000097          	auipc	ra,0x0
    800037fe:	c68080e7          	jalr	-920(ra) # 80003462 <write_head>
    install_trans(0); // Now install writes to home locations
    80003802:	4501                	li	a0,0
    80003804:	00000097          	auipc	ra,0x0
    80003808:	cda080e7          	jalr	-806(ra) # 800034de <install_trans>
    log.lh.n = 0;
    8000380c:	00021797          	auipc	a5,0x21
    80003810:	0e07a023          	sw	zero,224(a5) # 800248ec <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003814:	00000097          	auipc	ra,0x0
    80003818:	c4e080e7          	jalr	-946(ra) # 80003462 <write_head>
    8000381c:	bdf5                	j	80003718 <end_op+0x52>

000000008000381e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000381e:	1101                	addi	sp,sp,-32
    80003820:	ec06                	sd	ra,24(sp)
    80003822:	e822                	sd	s0,16(sp)
    80003824:	e426                	sd	s1,8(sp)
    80003826:	e04a                	sd	s2,0(sp)
    80003828:	1000                	addi	s0,sp,32
    8000382a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000382c:	00021917          	auipc	s2,0x21
    80003830:	09490913          	addi	s2,s2,148 # 800248c0 <log>
    80003834:	854a                	mv	a0,s2
    80003836:	00003097          	auipc	ra,0x3
    8000383a:	c6e080e7          	jalr	-914(ra) # 800064a4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000383e:	02c92603          	lw	a2,44(s2)
    80003842:	47f5                	li	a5,29
    80003844:	06c7c563          	blt	a5,a2,800038ae <log_write+0x90>
    80003848:	00021797          	auipc	a5,0x21
    8000384c:	0947a783          	lw	a5,148(a5) # 800248dc <log+0x1c>
    80003850:	37fd                	addiw	a5,a5,-1
    80003852:	04f65e63          	bge	a2,a5,800038ae <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003856:	00021797          	auipc	a5,0x21
    8000385a:	08a7a783          	lw	a5,138(a5) # 800248e0 <log+0x20>
    8000385e:	06f05063          	blez	a5,800038be <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003862:	4781                	li	a5,0
    80003864:	06c05563          	blez	a2,800038ce <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003868:	44cc                	lw	a1,12(s1)
    8000386a:	00021717          	auipc	a4,0x21
    8000386e:	08670713          	addi	a4,a4,134 # 800248f0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003872:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003874:	4314                	lw	a3,0(a4)
    80003876:	04b68c63          	beq	a3,a1,800038ce <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000387a:	2785                	addiw	a5,a5,1
    8000387c:	0711                	addi	a4,a4,4
    8000387e:	fef61be3          	bne	a2,a5,80003874 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003882:	0621                	addi	a2,a2,8
    80003884:	060a                	slli	a2,a2,0x2
    80003886:	00021797          	auipc	a5,0x21
    8000388a:	03a78793          	addi	a5,a5,58 # 800248c0 <log>
    8000388e:	97b2                	add	a5,a5,a2
    80003890:	44d8                	lw	a4,12(s1)
    80003892:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003894:	8526                	mv	a0,s1
    80003896:	fffff097          	auipc	ra,0xfffff
    8000389a:	d9c080e7          	jalr	-612(ra) # 80002632 <bpin>
    log.lh.n++;
    8000389e:	00021717          	auipc	a4,0x21
    800038a2:	02270713          	addi	a4,a4,34 # 800248c0 <log>
    800038a6:	575c                	lw	a5,44(a4)
    800038a8:	2785                	addiw	a5,a5,1
    800038aa:	d75c                	sw	a5,44(a4)
    800038ac:	a82d                	j	800038e6 <log_write+0xc8>
    panic("too big a transaction");
    800038ae:	00005517          	auipc	a0,0x5
    800038b2:	cfa50513          	addi	a0,a0,-774 # 800085a8 <syscalls+0x200>
    800038b6:	00002097          	auipc	ra,0x2
    800038ba:	6b6080e7          	jalr	1718(ra) # 80005f6c <panic>
    panic("log_write outside of trans");
    800038be:	00005517          	auipc	a0,0x5
    800038c2:	d0250513          	addi	a0,a0,-766 # 800085c0 <syscalls+0x218>
    800038c6:	00002097          	auipc	ra,0x2
    800038ca:	6a6080e7          	jalr	1702(ra) # 80005f6c <panic>
  log.lh.block[i] = b->blockno;
    800038ce:	00878693          	addi	a3,a5,8
    800038d2:	068a                	slli	a3,a3,0x2
    800038d4:	00021717          	auipc	a4,0x21
    800038d8:	fec70713          	addi	a4,a4,-20 # 800248c0 <log>
    800038dc:	9736                	add	a4,a4,a3
    800038de:	44d4                	lw	a3,12(s1)
    800038e0:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800038e2:	faf609e3          	beq	a2,a5,80003894 <log_write+0x76>
  }
  release(&log.lock);
    800038e6:	00021517          	auipc	a0,0x21
    800038ea:	fda50513          	addi	a0,a0,-38 # 800248c0 <log>
    800038ee:	00003097          	auipc	ra,0x3
    800038f2:	c6a080e7          	jalr	-918(ra) # 80006558 <release>
}
    800038f6:	60e2                	ld	ra,24(sp)
    800038f8:	6442                	ld	s0,16(sp)
    800038fa:	64a2                	ld	s1,8(sp)
    800038fc:	6902                	ld	s2,0(sp)
    800038fe:	6105                	addi	sp,sp,32
    80003900:	8082                	ret

0000000080003902 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003902:	1101                	addi	sp,sp,-32
    80003904:	ec06                	sd	ra,24(sp)
    80003906:	e822                	sd	s0,16(sp)
    80003908:	e426                	sd	s1,8(sp)
    8000390a:	e04a                	sd	s2,0(sp)
    8000390c:	1000                	addi	s0,sp,32
    8000390e:	84aa                	mv	s1,a0
    80003910:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003912:	00005597          	auipc	a1,0x5
    80003916:	cce58593          	addi	a1,a1,-818 # 800085e0 <syscalls+0x238>
    8000391a:	0521                	addi	a0,a0,8
    8000391c:	00003097          	auipc	ra,0x3
    80003920:	af8080e7          	jalr	-1288(ra) # 80006414 <initlock>
  lk->name = name;
    80003924:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003928:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000392c:	0204a423          	sw	zero,40(s1)
}
    80003930:	60e2                	ld	ra,24(sp)
    80003932:	6442                	ld	s0,16(sp)
    80003934:	64a2                	ld	s1,8(sp)
    80003936:	6902                	ld	s2,0(sp)
    80003938:	6105                	addi	sp,sp,32
    8000393a:	8082                	ret

000000008000393c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000393c:	1101                	addi	sp,sp,-32
    8000393e:	ec06                	sd	ra,24(sp)
    80003940:	e822                	sd	s0,16(sp)
    80003942:	e426                	sd	s1,8(sp)
    80003944:	e04a                	sd	s2,0(sp)
    80003946:	1000                	addi	s0,sp,32
    80003948:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000394a:	00850913          	addi	s2,a0,8
    8000394e:	854a                	mv	a0,s2
    80003950:	00003097          	auipc	ra,0x3
    80003954:	b54080e7          	jalr	-1196(ra) # 800064a4 <acquire>
  while (lk->locked) {
    80003958:	409c                	lw	a5,0(s1)
    8000395a:	cb89                	beqz	a5,8000396c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000395c:	85ca                	mv	a1,s2
    8000395e:	8526                	mv	a0,s1
    80003960:	ffffe097          	auipc	ra,0xffffe
    80003964:	bbc080e7          	jalr	-1092(ra) # 8000151c <sleep>
  while (lk->locked) {
    80003968:	409c                	lw	a5,0(s1)
    8000396a:	fbed                	bnez	a5,8000395c <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000396c:	4785                	li	a5,1
    8000396e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003970:	ffffd097          	auipc	ra,0xffffd
    80003974:	4ca080e7          	jalr	1226(ra) # 80000e3a <myproc>
    80003978:	591c                	lw	a5,48(a0)
    8000397a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000397c:	854a                	mv	a0,s2
    8000397e:	00003097          	auipc	ra,0x3
    80003982:	bda080e7          	jalr	-1062(ra) # 80006558 <release>
}
    80003986:	60e2                	ld	ra,24(sp)
    80003988:	6442                	ld	s0,16(sp)
    8000398a:	64a2                	ld	s1,8(sp)
    8000398c:	6902                	ld	s2,0(sp)
    8000398e:	6105                	addi	sp,sp,32
    80003990:	8082                	ret

0000000080003992 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003992:	1101                	addi	sp,sp,-32
    80003994:	ec06                	sd	ra,24(sp)
    80003996:	e822                	sd	s0,16(sp)
    80003998:	e426                	sd	s1,8(sp)
    8000399a:	e04a                	sd	s2,0(sp)
    8000399c:	1000                	addi	s0,sp,32
    8000399e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039a0:	00850913          	addi	s2,a0,8
    800039a4:	854a                	mv	a0,s2
    800039a6:	00003097          	auipc	ra,0x3
    800039aa:	afe080e7          	jalr	-1282(ra) # 800064a4 <acquire>
  lk->locked = 0;
    800039ae:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039b2:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800039b6:	8526                	mv	a0,s1
    800039b8:	ffffe097          	auipc	ra,0xffffe
    800039bc:	bc8080e7          	jalr	-1080(ra) # 80001580 <wakeup>
  release(&lk->lk);
    800039c0:	854a                	mv	a0,s2
    800039c2:	00003097          	auipc	ra,0x3
    800039c6:	b96080e7          	jalr	-1130(ra) # 80006558 <release>
}
    800039ca:	60e2                	ld	ra,24(sp)
    800039cc:	6442                	ld	s0,16(sp)
    800039ce:	64a2                	ld	s1,8(sp)
    800039d0:	6902                	ld	s2,0(sp)
    800039d2:	6105                	addi	sp,sp,32
    800039d4:	8082                	ret

00000000800039d6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800039d6:	7179                	addi	sp,sp,-48
    800039d8:	f406                	sd	ra,40(sp)
    800039da:	f022                	sd	s0,32(sp)
    800039dc:	ec26                	sd	s1,24(sp)
    800039de:	e84a                	sd	s2,16(sp)
    800039e0:	e44e                	sd	s3,8(sp)
    800039e2:	1800                	addi	s0,sp,48
    800039e4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800039e6:	00850913          	addi	s2,a0,8
    800039ea:	854a                	mv	a0,s2
    800039ec:	00003097          	auipc	ra,0x3
    800039f0:	ab8080e7          	jalr	-1352(ra) # 800064a4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039f4:	409c                	lw	a5,0(s1)
    800039f6:	ef99                	bnez	a5,80003a14 <holdingsleep+0x3e>
    800039f8:	4481                	li	s1,0
  release(&lk->lk);
    800039fa:	854a                	mv	a0,s2
    800039fc:	00003097          	auipc	ra,0x3
    80003a00:	b5c080e7          	jalr	-1188(ra) # 80006558 <release>
  return r;
}
    80003a04:	8526                	mv	a0,s1
    80003a06:	70a2                	ld	ra,40(sp)
    80003a08:	7402                	ld	s0,32(sp)
    80003a0a:	64e2                	ld	s1,24(sp)
    80003a0c:	6942                	ld	s2,16(sp)
    80003a0e:	69a2                	ld	s3,8(sp)
    80003a10:	6145                	addi	sp,sp,48
    80003a12:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a14:	0284a983          	lw	s3,40(s1)
    80003a18:	ffffd097          	auipc	ra,0xffffd
    80003a1c:	422080e7          	jalr	1058(ra) # 80000e3a <myproc>
    80003a20:	5904                	lw	s1,48(a0)
    80003a22:	413484b3          	sub	s1,s1,s3
    80003a26:	0014b493          	seqz	s1,s1
    80003a2a:	bfc1                	j	800039fa <holdingsleep+0x24>

0000000080003a2c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a2c:	1141                	addi	sp,sp,-16
    80003a2e:	e406                	sd	ra,8(sp)
    80003a30:	e022                	sd	s0,0(sp)
    80003a32:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a34:	00005597          	auipc	a1,0x5
    80003a38:	bbc58593          	addi	a1,a1,-1092 # 800085f0 <syscalls+0x248>
    80003a3c:	00021517          	auipc	a0,0x21
    80003a40:	fcc50513          	addi	a0,a0,-52 # 80024a08 <ftable>
    80003a44:	00003097          	auipc	ra,0x3
    80003a48:	9d0080e7          	jalr	-1584(ra) # 80006414 <initlock>
}
    80003a4c:	60a2                	ld	ra,8(sp)
    80003a4e:	6402                	ld	s0,0(sp)
    80003a50:	0141                	addi	sp,sp,16
    80003a52:	8082                	ret

0000000080003a54 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a54:	1101                	addi	sp,sp,-32
    80003a56:	ec06                	sd	ra,24(sp)
    80003a58:	e822                	sd	s0,16(sp)
    80003a5a:	e426                	sd	s1,8(sp)
    80003a5c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a5e:	00021517          	auipc	a0,0x21
    80003a62:	faa50513          	addi	a0,a0,-86 # 80024a08 <ftable>
    80003a66:	00003097          	auipc	ra,0x3
    80003a6a:	a3e080e7          	jalr	-1474(ra) # 800064a4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a6e:	00021497          	auipc	s1,0x21
    80003a72:	fb248493          	addi	s1,s1,-78 # 80024a20 <ftable+0x18>
    80003a76:	00022717          	auipc	a4,0x22
    80003a7a:	f4a70713          	addi	a4,a4,-182 # 800259c0 <disk>
    if(f->ref == 0){
    80003a7e:	40dc                	lw	a5,4(s1)
    80003a80:	cf99                	beqz	a5,80003a9e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a82:	02848493          	addi	s1,s1,40
    80003a86:	fee49ce3          	bne	s1,a4,80003a7e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a8a:	00021517          	auipc	a0,0x21
    80003a8e:	f7e50513          	addi	a0,a0,-130 # 80024a08 <ftable>
    80003a92:	00003097          	auipc	ra,0x3
    80003a96:	ac6080e7          	jalr	-1338(ra) # 80006558 <release>
  return 0;
    80003a9a:	4481                	li	s1,0
    80003a9c:	a819                	j	80003ab2 <filealloc+0x5e>
      f->ref = 1;
    80003a9e:	4785                	li	a5,1
    80003aa0:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003aa2:	00021517          	auipc	a0,0x21
    80003aa6:	f6650513          	addi	a0,a0,-154 # 80024a08 <ftable>
    80003aaa:	00003097          	auipc	ra,0x3
    80003aae:	aae080e7          	jalr	-1362(ra) # 80006558 <release>
}
    80003ab2:	8526                	mv	a0,s1
    80003ab4:	60e2                	ld	ra,24(sp)
    80003ab6:	6442                	ld	s0,16(sp)
    80003ab8:	64a2                	ld	s1,8(sp)
    80003aba:	6105                	addi	sp,sp,32
    80003abc:	8082                	ret

0000000080003abe <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003abe:	1101                	addi	sp,sp,-32
    80003ac0:	ec06                	sd	ra,24(sp)
    80003ac2:	e822                	sd	s0,16(sp)
    80003ac4:	e426                	sd	s1,8(sp)
    80003ac6:	1000                	addi	s0,sp,32
    80003ac8:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003aca:	00021517          	auipc	a0,0x21
    80003ace:	f3e50513          	addi	a0,a0,-194 # 80024a08 <ftable>
    80003ad2:	00003097          	auipc	ra,0x3
    80003ad6:	9d2080e7          	jalr	-1582(ra) # 800064a4 <acquire>
  if(f->ref < 1)
    80003ada:	40dc                	lw	a5,4(s1)
    80003adc:	02f05263          	blez	a5,80003b00 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003ae0:	2785                	addiw	a5,a5,1
    80003ae2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003ae4:	00021517          	auipc	a0,0x21
    80003ae8:	f2450513          	addi	a0,a0,-220 # 80024a08 <ftable>
    80003aec:	00003097          	auipc	ra,0x3
    80003af0:	a6c080e7          	jalr	-1428(ra) # 80006558 <release>
  return f;
}
    80003af4:	8526                	mv	a0,s1
    80003af6:	60e2                	ld	ra,24(sp)
    80003af8:	6442                	ld	s0,16(sp)
    80003afa:	64a2                	ld	s1,8(sp)
    80003afc:	6105                	addi	sp,sp,32
    80003afe:	8082                	ret
    panic("filedup");
    80003b00:	00005517          	auipc	a0,0x5
    80003b04:	af850513          	addi	a0,a0,-1288 # 800085f8 <syscalls+0x250>
    80003b08:	00002097          	auipc	ra,0x2
    80003b0c:	464080e7          	jalr	1124(ra) # 80005f6c <panic>

0000000080003b10 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b10:	7139                	addi	sp,sp,-64
    80003b12:	fc06                	sd	ra,56(sp)
    80003b14:	f822                	sd	s0,48(sp)
    80003b16:	f426                	sd	s1,40(sp)
    80003b18:	f04a                	sd	s2,32(sp)
    80003b1a:	ec4e                	sd	s3,24(sp)
    80003b1c:	e852                	sd	s4,16(sp)
    80003b1e:	e456                	sd	s5,8(sp)
    80003b20:	0080                	addi	s0,sp,64
    80003b22:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b24:	00021517          	auipc	a0,0x21
    80003b28:	ee450513          	addi	a0,a0,-284 # 80024a08 <ftable>
    80003b2c:	00003097          	auipc	ra,0x3
    80003b30:	978080e7          	jalr	-1672(ra) # 800064a4 <acquire>
  if(f->ref < 1)
    80003b34:	40dc                	lw	a5,4(s1)
    80003b36:	06f05163          	blez	a5,80003b98 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b3a:	37fd                	addiw	a5,a5,-1
    80003b3c:	0007871b          	sext.w	a4,a5
    80003b40:	c0dc                	sw	a5,4(s1)
    80003b42:	06e04363          	bgtz	a4,80003ba8 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b46:	0004a903          	lw	s2,0(s1)
    80003b4a:	0094ca83          	lbu	s5,9(s1)
    80003b4e:	0104ba03          	ld	s4,16(s1)
    80003b52:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b56:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b5a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b5e:	00021517          	auipc	a0,0x21
    80003b62:	eaa50513          	addi	a0,a0,-342 # 80024a08 <ftable>
    80003b66:	00003097          	auipc	ra,0x3
    80003b6a:	9f2080e7          	jalr	-1550(ra) # 80006558 <release>

  if(ff.type == FD_PIPE){
    80003b6e:	4785                	li	a5,1
    80003b70:	04f90d63          	beq	s2,a5,80003bca <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b74:	3979                	addiw	s2,s2,-2
    80003b76:	4785                	li	a5,1
    80003b78:	0527e063          	bltu	a5,s2,80003bb8 <fileclose+0xa8>
    begin_op();
    80003b7c:	00000097          	auipc	ra,0x0
    80003b80:	acc080e7          	jalr	-1332(ra) # 80003648 <begin_op>
    iput(ff.ip);
    80003b84:	854e                	mv	a0,s3
    80003b86:	fffff097          	auipc	ra,0xfffff
    80003b8a:	2b0080e7          	jalr	688(ra) # 80002e36 <iput>
    end_op();
    80003b8e:	00000097          	auipc	ra,0x0
    80003b92:	b38080e7          	jalr	-1224(ra) # 800036c6 <end_op>
    80003b96:	a00d                	j	80003bb8 <fileclose+0xa8>
    panic("fileclose");
    80003b98:	00005517          	auipc	a0,0x5
    80003b9c:	a6850513          	addi	a0,a0,-1432 # 80008600 <syscalls+0x258>
    80003ba0:	00002097          	auipc	ra,0x2
    80003ba4:	3cc080e7          	jalr	972(ra) # 80005f6c <panic>
    release(&ftable.lock);
    80003ba8:	00021517          	auipc	a0,0x21
    80003bac:	e6050513          	addi	a0,a0,-416 # 80024a08 <ftable>
    80003bb0:	00003097          	auipc	ra,0x3
    80003bb4:	9a8080e7          	jalr	-1624(ra) # 80006558 <release>
  }
}
    80003bb8:	70e2                	ld	ra,56(sp)
    80003bba:	7442                	ld	s0,48(sp)
    80003bbc:	74a2                	ld	s1,40(sp)
    80003bbe:	7902                	ld	s2,32(sp)
    80003bc0:	69e2                	ld	s3,24(sp)
    80003bc2:	6a42                	ld	s4,16(sp)
    80003bc4:	6aa2                	ld	s5,8(sp)
    80003bc6:	6121                	addi	sp,sp,64
    80003bc8:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003bca:	85d6                	mv	a1,s5
    80003bcc:	8552                	mv	a0,s4
    80003bce:	00000097          	auipc	ra,0x0
    80003bd2:	34c080e7          	jalr	844(ra) # 80003f1a <pipeclose>
    80003bd6:	b7cd                	j	80003bb8 <fileclose+0xa8>

0000000080003bd8 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003bd8:	715d                	addi	sp,sp,-80
    80003bda:	e486                	sd	ra,72(sp)
    80003bdc:	e0a2                	sd	s0,64(sp)
    80003bde:	fc26                	sd	s1,56(sp)
    80003be0:	f84a                	sd	s2,48(sp)
    80003be2:	f44e                	sd	s3,40(sp)
    80003be4:	0880                	addi	s0,sp,80
    80003be6:	84aa                	mv	s1,a0
    80003be8:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003bea:	ffffd097          	auipc	ra,0xffffd
    80003bee:	250080e7          	jalr	592(ra) # 80000e3a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003bf2:	409c                	lw	a5,0(s1)
    80003bf4:	37f9                	addiw	a5,a5,-2
    80003bf6:	4705                	li	a4,1
    80003bf8:	04f76763          	bltu	a4,a5,80003c46 <filestat+0x6e>
    80003bfc:	892a                	mv	s2,a0
    ilock(f->ip);
    80003bfe:	6c88                	ld	a0,24(s1)
    80003c00:	fffff097          	auipc	ra,0xfffff
    80003c04:	07c080e7          	jalr	124(ra) # 80002c7c <ilock>
    stati(f->ip, &st);
    80003c08:	fb840593          	addi	a1,s0,-72
    80003c0c:	6c88                	ld	a0,24(s1)
    80003c0e:	fffff097          	auipc	ra,0xfffff
    80003c12:	2f8080e7          	jalr	760(ra) # 80002f06 <stati>
    iunlock(f->ip);
    80003c16:	6c88                	ld	a0,24(s1)
    80003c18:	fffff097          	auipc	ra,0xfffff
    80003c1c:	126080e7          	jalr	294(ra) # 80002d3e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c20:	46e1                	li	a3,24
    80003c22:	fb840613          	addi	a2,s0,-72
    80003c26:	85ce                	mv	a1,s3
    80003c28:	05093503          	ld	a0,80(s2)
    80003c2c:	ffffd097          	auipc	ra,0xffffd
    80003c30:	ece080e7          	jalr	-306(ra) # 80000afa <copyout>
    80003c34:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c38:	60a6                	ld	ra,72(sp)
    80003c3a:	6406                	ld	s0,64(sp)
    80003c3c:	74e2                	ld	s1,56(sp)
    80003c3e:	7942                	ld	s2,48(sp)
    80003c40:	79a2                	ld	s3,40(sp)
    80003c42:	6161                	addi	sp,sp,80
    80003c44:	8082                	ret
  return -1;
    80003c46:	557d                	li	a0,-1
    80003c48:	bfc5                	j	80003c38 <filestat+0x60>

0000000080003c4a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c4a:	7179                	addi	sp,sp,-48
    80003c4c:	f406                	sd	ra,40(sp)
    80003c4e:	f022                	sd	s0,32(sp)
    80003c50:	ec26                	sd	s1,24(sp)
    80003c52:	e84a                	sd	s2,16(sp)
    80003c54:	e44e                	sd	s3,8(sp)
    80003c56:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c58:	00854783          	lbu	a5,8(a0)
    80003c5c:	c3d5                	beqz	a5,80003d00 <fileread+0xb6>
    80003c5e:	84aa                	mv	s1,a0
    80003c60:	89ae                	mv	s3,a1
    80003c62:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c64:	411c                	lw	a5,0(a0)
    80003c66:	4705                	li	a4,1
    80003c68:	04e78963          	beq	a5,a4,80003cba <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c6c:	470d                	li	a4,3
    80003c6e:	04e78d63          	beq	a5,a4,80003cc8 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c72:	4709                	li	a4,2
    80003c74:	06e79e63          	bne	a5,a4,80003cf0 <fileread+0xa6>
    ilock(f->ip);
    80003c78:	6d08                	ld	a0,24(a0)
    80003c7a:	fffff097          	auipc	ra,0xfffff
    80003c7e:	002080e7          	jalr	2(ra) # 80002c7c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c82:	874a                	mv	a4,s2
    80003c84:	5094                	lw	a3,32(s1)
    80003c86:	864e                	mv	a2,s3
    80003c88:	4585                	li	a1,1
    80003c8a:	6c88                	ld	a0,24(s1)
    80003c8c:	fffff097          	auipc	ra,0xfffff
    80003c90:	2a4080e7          	jalr	676(ra) # 80002f30 <readi>
    80003c94:	892a                	mv	s2,a0
    80003c96:	00a05563          	blez	a0,80003ca0 <fileread+0x56>
      f->off += r;
    80003c9a:	509c                	lw	a5,32(s1)
    80003c9c:	9fa9                	addw	a5,a5,a0
    80003c9e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003ca0:	6c88                	ld	a0,24(s1)
    80003ca2:	fffff097          	auipc	ra,0xfffff
    80003ca6:	09c080e7          	jalr	156(ra) # 80002d3e <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003caa:	854a                	mv	a0,s2
    80003cac:	70a2                	ld	ra,40(sp)
    80003cae:	7402                	ld	s0,32(sp)
    80003cb0:	64e2                	ld	s1,24(sp)
    80003cb2:	6942                	ld	s2,16(sp)
    80003cb4:	69a2                	ld	s3,8(sp)
    80003cb6:	6145                	addi	sp,sp,48
    80003cb8:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003cba:	6908                	ld	a0,16(a0)
    80003cbc:	00000097          	auipc	ra,0x0
    80003cc0:	3c6080e7          	jalr	966(ra) # 80004082 <piperead>
    80003cc4:	892a                	mv	s2,a0
    80003cc6:	b7d5                	j	80003caa <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003cc8:	02451783          	lh	a5,36(a0)
    80003ccc:	03079693          	slli	a3,a5,0x30
    80003cd0:	92c1                	srli	a3,a3,0x30
    80003cd2:	4725                	li	a4,9
    80003cd4:	02d76863          	bltu	a4,a3,80003d04 <fileread+0xba>
    80003cd8:	0792                	slli	a5,a5,0x4
    80003cda:	00021717          	auipc	a4,0x21
    80003cde:	c8e70713          	addi	a4,a4,-882 # 80024968 <devsw>
    80003ce2:	97ba                	add	a5,a5,a4
    80003ce4:	639c                	ld	a5,0(a5)
    80003ce6:	c38d                	beqz	a5,80003d08 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003ce8:	4505                	li	a0,1
    80003cea:	9782                	jalr	a5
    80003cec:	892a                	mv	s2,a0
    80003cee:	bf75                	j	80003caa <fileread+0x60>
    panic("fileread");
    80003cf0:	00005517          	auipc	a0,0x5
    80003cf4:	92050513          	addi	a0,a0,-1760 # 80008610 <syscalls+0x268>
    80003cf8:	00002097          	auipc	ra,0x2
    80003cfc:	274080e7          	jalr	628(ra) # 80005f6c <panic>
    return -1;
    80003d00:	597d                	li	s2,-1
    80003d02:	b765                	j	80003caa <fileread+0x60>
      return -1;
    80003d04:	597d                	li	s2,-1
    80003d06:	b755                	j	80003caa <fileread+0x60>
    80003d08:	597d                	li	s2,-1
    80003d0a:	b745                	j	80003caa <fileread+0x60>

0000000080003d0c <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d0c:	715d                	addi	sp,sp,-80
    80003d0e:	e486                	sd	ra,72(sp)
    80003d10:	e0a2                	sd	s0,64(sp)
    80003d12:	fc26                	sd	s1,56(sp)
    80003d14:	f84a                	sd	s2,48(sp)
    80003d16:	f44e                	sd	s3,40(sp)
    80003d18:	f052                	sd	s4,32(sp)
    80003d1a:	ec56                	sd	s5,24(sp)
    80003d1c:	e85a                	sd	s6,16(sp)
    80003d1e:	e45e                	sd	s7,8(sp)
    80003d20:	e062                	sd	s8,0(sp)
    80003d22:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d24:	00954783          	lbu	a5,9(a0)
    80003d28:	10078663          	beqz	a5,80003e34 <filewrite+0x128>
    80003d2c:	892a                	mv	s2,a0
    80003d2e:	8b2e                	mv	s6,a1
    80003d30:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d32:	411c                	lw	a5,0(a0)
    80003d34:	4705                	li	a4,1
    80003d36:	02e78263          	beq	a5,a4,80003d5a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d3a:	470d                	li	a4,3
    80003d3c:	02e78663          	beq	a5,a4,80003d68 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d40:	4709                	li	a4,2
    80003d42:	0ee79163          	bne	a5,a4,80003e24 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d46:	0ac05d63          	blez	a2,80003e00 <filewrite+0xf4>
    int i = 0;
    80003d4a:	4981                	li	s3,0
    80003d4c:	6b85                	lui	s7,0x1
    80003d4e:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003d52:	6c05                	lui	s8,0x1
    80003d54:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003d58:	a861                	j	80003df0 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d5a:	6908                	ld	a0,16(a0)
    80003d5c:	00000097          	auipc	ra,0x0
    80003d60:	22e080e7          	jalr	558(ra) # 80003f8a <pipewrite>
    80003d64:	8a2a                	mv	s4,a0
    80003d66:	a045                	j	80003e06 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d68:	02451783          	lh	a5,36(a0)
    80003d6c:	03079693          	slli	a3,a5,0x30
    80003d70:	92c1                	srli	a3,a3,0x30
    80003d72:	4725                	li	a4,9
    80003d74:	0cd76263          	bltu	a4,a3,80003e38 <filewrite+0x12c>
    80003d78:	0792                	slli	a5,a5,0x4
    80003d7a:	00021717          	auipc	a4,0x21
    80003d7e:	bee70713          	addi	a4,a4,-1042 # 80024968 <devsw>
    80003d82:	97ba                	add	a5,a5,a4
    80003d84:	679c                	ld	a5,8(a5)
    80003d86:	cbdd                	beqz	a5,80003e3c <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d88:	4505                	li	a0,1
    80003d8a:	9782                	jalr	a5
    80003d8c:	8a2a                	mv	s4,a0
    80003d8e:	a8a5                	j	80003e06 <filewrite+0xfa>
    80003d90:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d94:	00000097          	auipc	ra,0x0
    80003d98:	8b4080e7          	jalr	-1868(ra) # 80003648 <begin_op>
      ilock(f->ip);
    80003d9c:	01893503          	ld	a0,24(s2)
    80003da0:	fffff097          	auipc	ra,0xfffff
    80003da4:	edc080e7          	jalr	-292(ra) # 80002c7c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003da8:	8756                	mv	a4,s5
    80003daa:	02092683          	lw	a3,32(s2)
    80003dae:	01698633          	add	a2,s3,s6
    80003db2:	4585                	li	a1,1
    80003db4:	01893503          	ld	a0,24(s2)
    80003db8:	fffff097          	auipc	ra,0xfffff
    80003dbc:	270080e7          	jalr	624(ra) # 80003028 <writei>
    80003dc0:	84aa                	mv	s1,a0
    80003dc2:	00a05763          	blez	a0,80003dd0 <filewrite+0xc4>
        f->off += r;
    80003dc6:	02092783          	lw	a5,32(s2)
    80003dca:	9fa9                	addw	a5,a5,a0
    80003dcc:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003dd0:	01893503          	ld	a0,24(s2)
    80003dd4:	fffff097          	auipc	ra,0xfffff
    80003dd8:	f6a080e7          	jalr	-150(ra) # 80002d3e <iunlock>
      end_op();
    80003ddc:	00000097          	auipc	ra,0x0
    80003de0:	8ea080e7          	jalr	-1814(ra) # 800036c6 <end_op>

      if(r != n1){
    80003de4:	009a9f63          	bne	s5,s1,80003e02 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003de8:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003dec:	0149db63          	bge	s3,s4,80003e02 <filewrite+0xf6>
      int n1 = n - i;
    80003df0:	413a04bb          	subw	s1,s4,s3
    80003df4:	0004879b          	sext.w	a5,s1
    80003df8:	f8fbdce3          	bge	s7,a5,80003d90 <filewrite+0x84>
    80003dfc:	84e2                	mv	s1,s8
    80003dfe:	bf49                	j	80003d90 <filewrite+0x84>
    int i = 0;
    80003e00:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e02:	013a1f63          	bne	s4,s3,80003e20 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e06:	8552                	mv	a0,s4
    80003e08:	60a6                	ld	ra,72(sp)
    80003e0a:	6406                	ld	s0,64(sp)
    80003e0c:	74e2                	ld	s1,56(sp)
    80003e0e:	7942                	ld	s2,48(sp)
    80003e10:	79a2                	ld	s3,40(sp)
    80003e12:	7a02                	ld	s4,32(sp)
    80003e14:	6ae2                	ld	s5,24(sp)
    80003e16:	6b42                	ld	s6,16(sp)
    80003e18:	6ba2                	ld	s7,8(sp)
    80003e1a:	6c02                	ld	s8,0(sp)
    80003e1c:	6161                	addi	sp,sp,80
    80003e1e:	8082                	ret
    ret = (i == n ? n : -1);
    80003e20:	5a7d                	li	s4,-1
    80003e22:	b7d5                	j	80003e06 <filewrite+0xfa>
    panic("filewrite");
    80003e24:	00004517          	auipc	a0,0x4
    80003e28:	7fc50513          	addi	a0,a0,2044 # 80008620 <syscalls+0x278>
    80003e2c:	00002097          	auipc	ra,0x2
    80003e30:	140080e7          	jalr	320(ra) # 80005f6c <panic>
    return -1;
    80003e34:	5a7d                	li	s4,-1
    80003e36:	bfc1                	j	80003e06 <filewrite+0xfa>
      return -1;
    80003e38:	5a7d                	li	s4,-1
    80003e3a:	b7f1                	j	80003e06 <filewrite+0xfa>
    80003e3c:	5a7d                	li	s4,-1
    80003e3e:	b7e1                	j	80003e06 <filewrite+0xfa>

0000000080003e40 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e40:	7179                	addi	sp,sp,-48
    80003e42:	f406                	sd	ra,40(sp)
    80003e44:	f022                	sd	s0,32(sp)
    80003e46:	ec26                	sd	s1,24(sp)
    80003e48:	e84a                	sd	s2,16(sp)
    80003e4a:	e44e                	sd	s3,8(sp)
    80003e4c:	e052                	sd	s4,0(sp)
    80003e4e:	1800                	addi	s0,sp,48
    80003e50:	84aa                	mv	s1,a0
    80003e52:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e54:	0005b023          	sd	zero,0(a1)
    80003e58:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e5c:	00000097          	auipc	ra,0x0
    80003e60:	bf8080e7          	jalr	-1032(ra) # 80003a54 <filealloc>
    80003e64:	e088                	sd	a0,0(s1)
    80003e66:	c551                	beqz	a0,80003ef2 <pipealloc+0xb2>
    80003e68:	00000097          	auipc	ra,0x0
    80003e6c:	bec080e7          	jalr	-1044(ra) # 80003a54 <filealloc>
    80003e70:	00aa3023          	sd	a0,0(s4)
    80003e74:	c92d                	beqz	a0,80003ee6 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e76:	ffffc097          	auipc	ra,0xffffc
    80003e7a:	2a4080e7          	jalr	676(ra) # 8000011a <kalloc>
    80003e7e:	892a                	mv	s2,a0
    80003e80:	c125                	beqz	a0,80003ee0 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e82:	4985                	li	s3,1
    80003e84:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e88:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e8c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e90:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e94:	00004597          	auipc	a1,0x4
    80003e98:	79c58593          	addi	a1,a1,1948 # 80008630 <syscalls+0x288>
    80003e9c:	00002097          	auipc	ra,0x2
    80003ea0:	578080e7          	jalr	1400(ra) # 80006414 <initlock>
  (*f0)->type = FD_PIPE;
    80003ea4:	609c                	ld	a5,0(s1)
    80003ea6:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003eaa:	609c                	ld	a5,0(s1)
    80003eac:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003eb0:	609c                	ld	a5,0(s1)
    80003eb2:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003eb6:	609c                	ld	a5,0(s1)
    80003eb8:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003ebc:	000a3783          	ld	a5,0(s4)
    80003ec0:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ec4:	000a3783          	ld	a5,0(s4)
    80003ec8:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003ecc:	000a3783          	ld	a5,0(s4)
    80003ed0:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003ed4:	000a3783          	ld	a5,0(s4)
    80003ed8:	0127b823          	sd	s2,16(a5)
  return 0;
    80003edc:	4501                	li	a0,0
    80003ede:	a025                	j	80003f06 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ee0:	6088                	ld	a0,0(s1)
    80003ee2:	e501                	bnez	a0,80003eea <pipealloc+0xaa>
    80003ee4:	a039                	j	80003ef2 <pipealloc+0xb2>
    80003ee6:	6088                	ld	a0,0(s1)
    80003ee8:	c51d                	beqz	a0,80003f16 <pipealloc+0xd6>
    fileclose(*f0);
    80003eea:	00000097          	auipc	ra,0x0
    80003eee:	c26080e7          	jalr	-986(ra) # 80003b10 <fileclose>
  if(*f1)
    80003ef2:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003ef6:	557d                	li	a0,-1
  if(*f1)
    80003ef8:	c799                	beqz	a5,80003f06 <pipealloc+0xc6>
    fileclose(*f1);
    80003efa:	853e                	mv	a0,a5
    80003efc:	00000097          	auipc	ra,0x0
    80003f00:	c14080e7          	jalr	-1004(ra) # 80003b10 <fileclose>
  return -1;
    80003f04:	557d                	li	a0,-1
}
    80003f06:	70a2                	ld	ra,40(sp)
    80003f08:	7402                	ld	s0,32(sp)
    80003f0a:	64e2                	ld	s1,24(sp)
    80003f0c:	6942                	ld	s2,16(sp)
    80003f0e:	69a2                	ld	s3,8(sp)
    80003f10:	6a02                	ld	s4,0(sp)
    80003f12:	6145                	addi	sp,sp,48
    80003f14:	8082                	ret
  return -1;
    80003f16:	557d                	li	a0,-1
    80003f18:	b7fd                	j	80003f06 <pipealloc+0xc6>

0000000080003f1a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f1a:	1101                	addi	sp,sp,-32
    80003f1c:	ec06                	sd	ra,24(sp)
    80003f1e:	e822                	sd	s0,16(sp)
    80003f20:	e426                	sd	s1,8(sp)
    80003f22:	e04a                	sd	s2,0(sp)
    80003f24:	1000                	addi	s0,sp,32
    80003f26:	84aa                	mv	s1,a0
    80003f28:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f2a:	00002097          	auipc	ra,0x2
    80003f2e:	57a080e7          	jalr	1402(ra) # 800064a4 <acquire>
  if(writable){
    80003f32:	02090d63          	beqz	s2,80003f6c <pipeclose+0x52>
    pi->writeopen = 0;
    80003f36:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f3a:	21848513          	addi	a0,s1,536
    80003f3e:	ffffd097          	auipc	ra,0xffffd
    80003f42:	642080e7          	jalr	1602(ra) # 80001580 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f46:	2204b783          	ld	a5,544(s1)
    80003f4a:	eb95                	bnez	a5,80003f7e <pipeclose+0x64>
    release(&pi->lock);
    80003f4c:	8526                	mv	a0,s1
    80003f4e:	00002097          	auipc	ra,0x2
    80003f52:	60a080e7          	jalr	1546(ra) # 80006558 <release>
    kfree((char*)pi);
    80003f56:	8526                	mv	a0,s1
    80003f58:	ffffc097          	auipc	ra,0xffffc
    80003f5c:	0c4080e7          	jalr	196(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f60:	60e2                	ld	ra,24(sp)
    80003f62:	6442                	ld	s0,16(sp)
    80003f64:	64a2                	ld	s1,8(sp)
    80003f66:	6902                	ld	s2,0(sp)
    80003f68:	6105                	addi	sp,sp,32
    80003f6a:	8082                	ret
    pi->readopen = 0;
    80003f6c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f70:	21c48513          	addi	a0,s1,540
    80003f74:	ffffd097          	auipc	ra,0xffffd
    80003f78:	60c080e7          	jalr	1548(ra) # 80001580 <wakeup>
    80003f7c:	b7e9                	j	80003f46 <pipeclose+0x2c>
    release(&pi->lock);
    80003f7e:	8526                	mv	a0,s1
    80003f80:	00002097          	auipc	ra,0x2
    80003f84:	5d8080e7          	jalr	1496(ra) # 80006558 <release>
}
    80003f88:	bfe1                	j	80003f60 <pipeclose+0x46>

0000000080003f8a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f8a:	711d                	addi	sp,sp,-96
    80003f8c:	ec86                	sd	ra,88(sp)
    80003f8e:	e8a2                	sd	s0,80(sp)
    80003f90:	e4a6                	sd	s1,72(sp)
    80003f92:	e0ca                	sd	s2,64(sp)
    80003f94:	fc4e                	sd	s3,56(sp)
    80003f96:	f852                	sd	s4,48(sp)
    80003f98:	f456                	sd	s5,40(sp)
    80003f9a:	f05a                	sd	s6,32(sp)
    80003f9c:	ec5e                	sd	s7,24(sp)
    80003f9e:	e862                	sd	s8,16(sp)
    80003fa0:	1080                	addi	s0,sp,96
    80003fa2:	84aa                	mv	s1,a0
    80003fa4:	8aae                	mv	s5,a1
    80003fa6:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003fa8:	ffffd097          	auipc	ra,0xffffd
    80003fac:	e92080e7          	jalr	-366(ra) # 80000e3a <myproc>
    80003fb0:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003fb2:	8526                	mv	a0,s1
    80003fb4:	00002097          	auipc	ra,0x2
    80003fb8:	4f0080e7          	jalr	1264(ra) # 800064a4 <acquire>
  while(i < n){
    80003fbc:	0b405663          	blez	s4,80004068 <pipewrite+0xde>
  int i = 0;
    80003fc0:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fc2:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003fc4:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003fc8:	21c48b93          	addi	s7,s1,540
    80003fcc:	a089                	j	8000400e <pipewrite+0x84>
      release(&pi->lock);
    80003fce:	8526                	mv	a0,s1
    80003fd0:	00002097          	auipc	ra,0x2
    80003fd4:	588080e7          	jalr	1416(ra) # 80006558 <release>
      return -1;
    80003fd8:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fda:	854a                	mv	a0,s2
    80003fdc:	60e6                	ld	ra,88(sp)
    80003fde:	6446                	ld	s0,80(sp)
    80003fe0:	64a6                	ld	s1,72(sp)
    80003fe2:	6906                	ld	s2,64(sp)
    80003fe4:	79e2                	ld	s3,56(sp)
    80003fe6:	7a42                	ld	s4,48(sp)
    80003fe8:	7aa2                	ld	s5,40(sp)
    80003fea:	7b02                	ld	s6,32(sp)
    80003fec:	6be2                	ld	s7,24(sp)
    80003fee:	6c42                	ld	s8,16(sp)
    80003ff0:	6125                	addi	sp,sp,96
    80003ff2:	8082                	ret
      wakeup(&pi->nread);
    80003ff4:	8562                	mv	a0,s8
    80003ff6:	ffffd097          	auipc	ra,0xffffd
    80003ffa:	58a080e7          	jalr	1418(ra) # 80001580 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003ffe:	85a6                	mv	a1,s1
    80004000:	855e                	mv	a0,s7
    80004002:	ffffd097          	auipc	ra,0xffffd
    80004006:	51a080e7          	jalr	1306(ra) # 8000151c <sleep>
  while(i < n){
    8000400a:	07495063          	bge	s2,s4,8000406a <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    8000400e:	2204a783          	lw	a5,544(s1)
    80004012:	dfd5                	beqz	a5,80003fce <pipewrite+0x44>
    80004014:	854e                	mv	a0,s3
    80004016:	ffffe097          	auipc	ra,0xffffe
    8000401a:	812080e7          	jalr	-2030(ra) # 80001828 <killed>
    8000401e:	f945                	bnez	a0,80003fce <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004020:	2184a783          	lw	a5,536(s1)
    80004024:	21c4a703          	lw	a4,540(s1)
    80004028:	2007879b          	addiw	a5,a5,512
    8000402c:	fcf704e3          	beq	a4,a5,80003ff4 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004030:	4685                	li	a3,1
    80004032:	01590633          	add	a2,s2,s5
    80004036:	faf40593          	addi	a1,s0,-81
    8000403a:	0509b503          	ld	a0,80(s3)
    8000403e:	ffffd097          	auipc	ra,0xffffd
    80004042:	b48080e7          	jalr	-1208(ra) # 80000b86 <copyin>
    80004046:	03650263          	beq	a0,s6,8000406a <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000404a:	21c4a783          	lw	a5,540(s1)
    8000404e:	0017871b          	addiw	a4,a5,1
    80004052:	20e4ae23          	sw	a4,540(s1)
    80004056:	1ff7f793          	andi	a5,a5,511
    8000405a:	97a6                	add	a5,a5,s1
    8000405c:	faf44703          	lbu	a4,-81(s0)
    80004060:	00e78c23          	sb	a4,24(a5)
      i++;
    80004064:	2905                	addiw	s2,s2,1
    80004066:	b755                	j	8000400a <pipewrite+0x80>
  int i = 0;
    80004068:	4901                	li	s2,0
  wakeup(&pi->nread);
    8000406a:	21848513          	addi	a0,s1,536
    8000406e:	ffffd097          	auipc	ra,0xffffd
    80004072:	512080e7          	jalr	1298(ra) # 80001580 <wakeup>
  release(&pi->lock);
    80004076:	8526                	mv	a0,s1
    80004078:	00002097          	auipc	ra,0x2
    8000407c:	4e0080e7          	jalr	1248(ra) # 80006558 <release>
  return i;
    80004080:	bfa9                	j	80003fda <pipewrite+0x50>

0000000080004082 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004082:	715d                	addi	sp,sp,-80
    80004084:	e486                	sd	ra,72(sp)
    80004086:	e0a2                	sd	s0,64(sp)
    80004088:	fc26                	sd	s1,56(sp)
    8000408a:	f84a                	sd	s2,48(sp)
    8000408c:	f44e                	sd	s3,40(sp)
    8000408e:	f052                	sd	s4,32(sp)
    80004090:	ec56                	sd	s5,24(sp)
    80004092:	e85a                	sd	s6,16(sp)
    80004094:	0880                	addi	s0,sp,80
    80004096:	84aa                	mv	s1,a0
    80004098:	892e                	mv	s2,a1
    8000409a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000409c:	ffffd097          	auipc	ra,0xffffd
    800040a0:	d9e080e7          	jalr	-610(ra) # 80000e3a <myproc>
    800040a4:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040a6:	8526                	mv	a0,s1
    800040a8:	00002097          	auipc	ra,0x2
    800040ac:	3fc080e7          	jalr	1020(ra) # 800064a4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040b0:	2184a703          	lw	a4,536(s1)
    800040b4:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040b8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040bc:	02f71763          	bne	a4,a5,800040ea <piperead+0x68>
    800040c0:	2244a783          	lw	a5,548(s1)
    800040c4:	c39d                	beqz	a5,800040ea <piperead+0x68>
    if(killed(pr)){
    800040c6:	8552                	mv	a0,s4
    800040c8:	ffffd097          	auipc	ra,0xffffd
    800040cc:	760080e7          	jalr	1888(ra) # 80001828 <killed>
    800040d0:	e949                	bnez	a0,80004162 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040d2:	85a6                	mv	a1,s1
    800040d4:	854e                	mv	a0,s3
    800040d6:	ffffd097          	auipc	ra,0xffffd
    800040da:	446080e7          	jalr	1094(ra) # 8000151c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040de:	2184a703          	lw	a4,536(s1)
    800040e2:	21c4a783          	lw	a5,540(s1)
    800040e6:	fcf70de3          	beq	a4,a5,800040c0 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040ea:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040ec:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040ee:	05505463          	blez	s5,80004136 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    800040f2:	2184a783          	lw	a5,536(s1)
    800040f6:	21c4a703          	lw	a4,540(s1)
    800040fa:	02f70e63          	beq	a4,a5,80004136 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040fe:	0017871b          	addiw	a4,a5,1
    80004102:	20e4ac23          	sw	a4,536(s1)
    80004106:	1ff7f793          	andi	a5,a5,511
    8000410a:	97a6                	add	a5,a5,s1
    8000410c:	0187c783          	lbu	a5,24(a5)
    80004110:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004114:	4685                	li	a3,1
    80004116:	fbf40613          	addi	a2,s0,-65
    8000411a:	85ca                	mv	a1,s2
    8000411c:	050a3503          	ld	a0,80(s4)
    80004120:	ffffd097          	auipc	ra,0xffffd
    80004124:	9da080e7          	jalr	-1574(ra) # 80000afa <copyout>
    80004128:	01650763          	beq	a0,s6,80004136 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000412c:	2985                	addiw	s3,s3,1
    8000412e:	0905                	addi	s2,s2,1
    80004130:	fd3a91e3          	bne	s5,s3,800040f2 <piperead+0x70>
    80004134:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004136:	21c48513          	addi	a0,s1,540
    8000413a:	ffffd097          	auipc	ra,0xffffd
    8000413e:	446080e7          	jalr	1094(ra) # 80001580 <wakeup>
  release(&pi->lock);
    80004142:	8526                	mv	a0,s1
    80004144:	00002097          	auipc	ra,0x2
    80004148:	414080e7          	jalr	1044(ra) # 80006558 <release>
  return i;
}
    8000414c:	854e                	mv	a0,s3
    8000414e:	60a6                	ld	ra,72(sp)
    80004150:	6406                	ld	s0,64(sp)
    80004152:	74e2                	ld	s1,56(sp)
    80004154:	7942                	ld	s2,48(sp)
    80004156:	79a2                	ld	s3,40(sp)
    80004158:	7a02                	ld	s4,32(sp)
    8000415a:	6ae2                	ld	s5,24(sp)
    8000415c:	6b42                	ld	s6,16(sp)
    8000415e:	6161                	addi	sp,sp,80
    80004160:	8082                	ret
      release(&pi->lock);
    80004162:	8526                	mv	a0,s1
    80004164:	00002097          	auipc	ra,0x2
    80004168:	3f4080e7          	jalr	1012(ra) # 80006558 <release>
      return -1;
    8000416c:	59fd                	li	s3,-1
    8000416e:	bff9                	j	8000414c <piperead+0xca>

0000000080004170 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004170:	1141                	addi	sp,sp,-16
    80004172:	e422                	sd	s0,8(sp)
    80004174:	0800                	addi	s0,sp,16
    80004176:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004178:	8905                	andi	a0,a0,1
    8000417a:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000417c:	8b89                	andi	a5,a5,2
    8000417e:	c399                	beqz	a5,80004184 <flags2perm+0x14>
      perm |= PTE_W;
    80004180:	00456513          	ori	a0,a0,4
    return perm;
}
    80004184:	6422                	ld	s0,8(sp)
    80004186:	0141                	addi	sp,sp,16
    80004188:	8082                	ret

000000008000418a <exec>:

int
exec(char *path, char **argv)
{
    8000418a:	de010113          	addi	sp,sp,-544
    8000418e:	20113c23          	sd	ra,536(sp)
    80004192:	20813823          	sd	s0,528(sp)
    80004196:	20913423          	sd	s1,520(sp)
    8000419a:	21213023          	sd	s2,512(sp)
    8000419e:	ffce                	sd	s3,504(sp)
    800041a0:	fbd2                	sd	s4,496(sp)
    800041a2:	f7d6                	sd	s5,488(sp)
    800041a4:	f3da                	sd	s6,480(sp)
    800041a6:	efde                	sd	s7,472(sp)
    800041a8:	ebe2                	sd	s8,464(sp)
    800041aa:	e7e6                	sd	s9,456(sp)
    800041ac:	e3ea                	sd	s10,448(sp)
    800041ae:	ff6e                	sd	s11,440(sp)
    800041b0:	1400                	addi	s0,sp,544
    800041b2:	892a                	mv	s2,a0
    800041b4:	dea43423          	sd	a0,-536(s0)
    800041b8:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041bc:	ffffd097          	auipc	ra,0xffffd
    800041c0:	c7e080e7          	jalr	-898(ra) # 80000e3a <myproc>
    800041c4:	84aa                	mv	s1,a0

  begin_op();
    800041c6:	fffff097          	auipc	ra,0xfffff
    800041ca:	482080e7          	jalr	1154(ra) # 80003648 <begin_op>

  if((ip = namei(path)) == 0){
    800041ce:	854a                	mv	a0,s2
    800041d0:	fffff097          	auipc	ra,0xfffff
    800041d4:	258080e7          	jalr	600(ra) # 80003428 <namei>
    800041d8:	c93d                	beqz	a0,8000424e <exec+0xc4>
    800041da:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041dc:	fffff097          	auipc	ra,0xfffff
    800041e0:	aa0080e7          	jalr	-1376(ra) # 80002c7c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041e4:	04000713          	li	a4,64
    800041e8:	4681                	li	a3,0
    800041ea:	e5040613          	addi	a2,s0,-432
    800041ee:	4581                	li	a1,0
    800041f0:	8556                	mv	a0,s5
    800041f2:	fffff097          	auipc	ra,0xfffff
    800041f6:	d3e080e7          	jalr	-706(ra) # 80002f30 <readi>
    800041fa:	04000793          	li	a5,64
    800041fe:	00f51a63          	bne	a0,a5,80004212 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004202:	e5042703          	lw	a4,-432(s0)
    80004206:	464c47b7          	lui	a5,0x464c4
    8000420a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000420e:	04f70663          	beq	a4,a5,8000425a <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004212:	8556                	mv	a0,s5
    80004214:	fffff097          	auipc	ra,0xfffff
    80004218:	cca080e7          	jalr	-822(ra) # 80002ede <iunlockput>
    end_op();
    8000421c:	fffff097          	auipc	ra,0xfffff
    80004220:	4aa080e7          	jalr	1194(ra) # 800036c6 <end_op>
  }
  return -1;
    80004224:	557d                	li	a0,-1
}
    80004226:	21813083          	ld	ra,536(sp)
    8000422a:	21013403          	ld	s0,528(sp)
    8000422e:	20813483          	ld	s1,520(sp)
    80004232:	20013903          	ld	s2,512(sp)
    80004236:	79fe                	ld	s3,504(sp)
    80004238:	7a5e                	ld	s4,496(sp)
    8000423a:	7abe                	ld	s5,488(sp)
    8000423c:	7b1e                	ld	s6,480(sp)
    8000423e:	6bfe                	ld	s7,472(sp)
    80004240:	6c5e                	ld	s8,464(sp)
    80004242:	6cbe                	ld	s9,456(sp)
    80004244:	6d1e                	ld	s10,448(sp)
    80004246:	7dfa                	ld	s11,440(sp)
    80004248:	22010113          	addi	sp,sp,544
    8000424c:	8082                	ret
    end_op();
    8000424e:	fffff097          	auipc	ra,0xfffff
    80004252:	478080e7          	jalr	1144(ra) # 800036c6 <end_op>
    return -1;
    80004256:	557d                	li	a0,-1
    80004258:	b7f9                	j	80004226 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    8000425a:	8526                	mv	a0,s1
    8000425c:	ffffd097          	auipc	ra,0xffffd
    80004260:	ca2080e7          	jalr	-862(ra) # 80000efe <proc_pagetable>
    80004264:	8b2a                	mv	s6,a0
    80004266:	d555                	beqz	a0,80004212 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004268:	e7042783          	lw	a5,-400(s0)
    8000426c:	e8845703          	lhu	a4,-376(s0)
    80004270:	c735                	beqz	a4,800042dc <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004272:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004274:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004278:	6a05                	lui	s4,0x1
    8000427a:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000427e:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004282:	6d85                	lui	s11,0x1
    80004284:	7d7d                	lui	s10,0xfffff
    80004286:	ac3d                	j	800044c4 <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004288:	00004517          	auipc	a0,0x4
    8000428c:	3b050513          	addi	a0,a0,944 # 80008638 <syscalls+0x290>
    80004290:	00002097          	auipc	ra,0x2
    80004294:	cdc080e7          	jalr	-804(ra) # 80005f6c <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004298:	874a                	mv	a4,s2
    8000429a:	009c86bb          	addw	a3,s9,s1
    8000429e:	4581                	li	a1,0
    800042a0:	8556                	mv	a0,s5
    800042a2:	fffff097          	auipc	ra,0xfffff
    800042a6:	c8e080e7          	jalr	-882(ra) # 80002f30 <readi>
    800042aa:	2501                	sext.w	a0,a0
    800042ac:	1aa91963          	bne	s2,a0,8000445e <exec+0x2d4>
  for(i = 0; i < sz; i += PGSIZE){
    800042b0:	009d84bb          	addw	s1,s11,s1
    800042b4:	013d09bb          	addw	s3,s10,s3
    800042b8:	1f74f663          	bgeu	s1,s7,800044a4 <exec+0x31a>
    pa = walkaddr(pagetable, va + i);
    800042bc:	02049593          	slli	a1,s1,0x20
    800042c0:	9181                	srli	a1,a1,0x20
    800042c2:	95e2                	add	a1,a1,s8
    800042c4:	855a                	mv	a0,s6
    800042c6:	ffffc097          	auipc	ra,0xffffc
    800042ca:	23e080e7          	jalr	574(ra) # 80000504 <walkaddr>
    800042ce:	862a                	mv	a2,a0
    if(pa == 0)
    800042d0:	dd45                	beqz	a0,80004288 <exec+0xfe>
      n = PGSIZE;
    800042d2:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800042d4:	fd49f2e3          	bgeu	s3,s4,80004298 <exec+0x10e>
      n = sz - i;
    800042d8:	894e                	mv	s2,s3
    800042da:	bf7d                	j	80004298 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042dc:	4901                	li	s2,0
  iunlockput(ip);
    800042de:	8556                	mv	a0,s5
    800042e0:	fffff097          	auipc	ra,0xfffff
    800042e4:	bfe080e7          	jalr	-1026(ra) # 80002ede <iunlockput>
  end_op();
    800042e8:	fffff097          	auipc	ra,0xfffff
    800042ec:	3de080e7          	jalr	990(ra) # 800036c6 <end_op>
  p = myproc();
    800042f0:	ffffd097          	auipc	ra,0xffffd
    800042f4:	b4a080e7          	jalr	-1206(ra) # 80000e3a <myproc>
    800042f8:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800042fa:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800042fe:	6785                	lui	a5,0x1
    80004300:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004302:	97ca                	add	a5,a5,s2
    80004304:	777d                	lui	a4,0xfffff
    80004306:	8ff9                	and	a5,a5,a4
    80004308:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000430c:	4691                	li	a3,4
    8000430e:	6609                	lui	a2,0x2
    80004310:	963e                	add	a2,a2,a5
    80004312:	85be                	mv	a1,a5
    80004314:	855a                	mv	a0,s6
    80004316:	ffffc097          	auipc	ra,0xffffc
    8000431a:	594080e7          	jalr	1428(ra) # 800008aa <uvmalloc>
    8000431e:	8c2a                	mv	s8,a0
  ip = 0;
    80004320:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004322:	12050e63          	beqz	a0,8000445e <exec+0x2d4>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004326:	75f9                	lui	a1,0xffffe
    80004328:	95aa                	add	a1,a1,a0
    8000432a:	855a                	mv	a0,s6
    8000432c:	ffffc097          	auipc	ra,0xffffc
    80004330:	79c080e7          	jalr	1948(ra) # 80000ac8 <uvmclear>
  stackbase = sp - PGSIZE;
    80004334:	7afd                	lui	s5,0xfffff
    80004336:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004338:	df043783          	ld	a5,-528(s0)
    8000433c:	6388                	ld	a0,0(a5)
    8000433e:	c925                	beqz	a0,800043ae <exec+0x224>
    80004340:	e9040993          	addi	s3,s0,-368
    80004344:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004348:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000434a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000434c:	ffffc097          	auipc	ra,0xffffc
    80004350:	faa080e7          	jalr	-86(ra) # 800002f6 <strlen>
    80004354:	0015079b          	addiw	a5,a0,1
    80004358:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000435c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004360:	13596663          	bltu	s2,s5,8000448c <exec+0x302>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004364:	df043d83          	ld	s11,-528(s0)
    80004368:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    8000436c:	8552                	mv	a0,s4
    8000436e:	ffffc097          	auipc	ra,0xffffc
    80004372:	f88080e7          	jalr	-120(ra) # 800002f6 <strlen>
    80004376:	0015069b          	addiw	a3,a0,1
    8000437a:	8652                	mv	a2,s4
    8000437c:	85ca                	mv	a1,s2
    8000437e:	855a                	mv	a0,s6
    80004380:	ffffc097          	auipc	ra,0xffffc
    80004384:	77a080e7          	jalr	1914(ra) # 80000afa <copyout>
    80004388:	10054663          	bltz	a0,80004494 <exec+0x30a>
    ustack[argc] = sp;
    8000438c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004390:	0485                	addi	s1,s1,1
    80004392:	008d8793          	addi	a5,s11,8
    80004396:	def43823          	sd	a5,-528(s0)
    8000439a:	008db503          	ld	a0,8(s11)
    8000439e:	c911                	beqz	a0,800043b2 <exec+0x228>
    if(argc >= MAXARG)
    800043a0:	09a1                	addi	s3,s3,8
    800043a2:	fb3c95e3          	bne	s9,s3,8000434c <exec+0x1c2>
  sz = sz1;
    800043a6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043aa:	4a81                	li	s5,0
    800043ac:	a84d                	j	8000445e <exec+0x2d4>
  sp = sz;
    800043ae:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800043b0:	4481                	li	s1,0
  ustack[argc] = 0;
    800043b2:	00349793          	slli	a5,s1,0x3
    800043b6:	f9078793          	addi	a5,a5,-112
    800043ba:	97a2                	add	a5,a5,s0
    800043bc:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800043c0:	00148693          	addi	a3,s1,1
    800043c4:	068e                	slli	a3,a3,0x3
    800043c6:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043ca:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800043ce:	01597663          	bgeu	s2,s5,800043da <exec+0x250>
  sz = sz1;
    800043d2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043d6:	4a81                	li	s5,0
    800043d8:	a059                	j	8000445e <exec+0x2d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043da:	e9040613          	addi	a2,s0,-368
    800043de:	85ca                	mv	a1,s2
    800043e0:	855a                	mv	a0,s6
    800043e2:	ffffc097          	auipc	ra,0xffffc
    800043e6:	718080e7          	jalr	1816(ra) # 80000afa <copyout>
    800043ea:	0a054963          	bltz	a0,8000449c <exec+0x312>
  p->trapframe->a1 = sp;
    800043ee:	058bb783          	ld	a5,88(s7)
    800043f2:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043f6:	de843783          	ld	a5,-536(s0)
    800043fa:	0007c703          	lbu	a4,0(a5)
    800043fe:	cf11                	beqz	a4,8000441a <exec+0x290>
    80004400:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004402:	02f00693          	li	a3,47
    80004406:	a039                	j	80004414 <exec+0x28a>
      last = s+1;
    80004408:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    8000440c:	0785                	addi	a5,a5,1
    8000440e:	fff7c703          	lbu	a4,-1(a5)
    80004412:	c701                	beqz	a4,8000441a <exec+0x290>
    if(*s == '/')
    80004414:	fed71ce3          	bne	a4,a3,8000440c <exec+0x282>
    80004418:	bfc5                	j	80004408 <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    8000441a:	4641                	li	a2,16
    8000441c:	de843583          	ld	a1,-536(s0)
    80004420:	158b8513          	addi	a0,s7,344
    80004424:	ffffc097          	auipc	ra,0xffffc
    80004428:	ea0080e7          	jalr	-352(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    8000442c:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004430:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004434:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004438:	058bb783          	ld	a5,88(s7)
    8000443c:	e6843703          	ld	a4,-408(s0)
    80004440:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004442:	058bb783          	ld	a5,88(s7)
    80004446:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000444a:	85ea                	mv	a1,s10
    8000444c:	ffffd097          	auipc	ra,0xffffd
    80004450:	b4e080e7          	jalr	-1202(ra) # 80000f9a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004454:	0004851b          	sext.w	a0,s1
    80004458:	b3f9                	j	80004226 <exec+0x9c>
    8000445a:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000445e:	df843583          	ld	a1,-520(s0)
    80004462:	855a                	mv	a0,s6
    80004464:	ffffd097          	auipc	ra,0xffffd
    80004468:	b36080e7          	jalr	-1226(ra) # 80000f9a <proc_freepagetable>
  if(ip){
    8000446c:	da0a93e3          	bnez	s5,80004212 <exec+0x88>
  return -1;
    80004470:	557d                	li	a0,-1
    80004472:	bb55                	j	80004226 <exec+0x9c>
    80004474:	df243c23          	sd	s2,-520(s0)
    80004478:	b7dd                	j	8000445e <exec+0x2d4>
    8000447a:	df243c23          	sd	s2,-520(s0)
    8000447e:	b7c5                	j	8000445e <exec+0x2d4>
    80004480:	df243c23          	sd	s2,-520(s0)
    80004484:	bfe9                	j	8000445e <exec+0x2d4>
    80004486:	df243c23          	sd	s2,-520(s0)
    8000448a:	bfd1                	j	8000445e <exec+0x2d4>
  sz = sz1;
    8000448c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004490:	4a81                	li	s5,0
    80004492:	b7f1                	j	8000445e <exec+0x2d4>
  sz = sz1;
    80004494:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004498:	4a81                	li	s5,0
    8000449a:	b7d1                	j	8000445e <exec+0x2d4>
  sz = sz1;
    8000449c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800044a0:	4a81                	li	s5,0
    800044a2:	bf75                	j	8000445e <exec+0x2d4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044a4:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044a8:	e0843783          	ld	a5,-504(s0)
    800044ac:	0017869b          	addiw	a3,a5,1
    800044b0:	e0d43423          	sd	a3,-504(s0)
    800044b4:	e0043783          	ld	a5,-512(s0)
    800044b8:	0387879b          	addiw	a5,a5,56
    800044bc:	e8845703          	lhu	a4,-376(s0)
    800044c0:	e0e6dfe3          	bge	a3,a4,800042de <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044c4:	2781                	sext.w	a5,a5
    800044c6:	e0f43023          	sd	a5,-512(s0)
    800044ca:	03800713          	li	a4,56
    800044ce:	86be                	mv	a3,a5
    800044d0:	e1840613          	addi	a2,s0,-488
    800044d4:	4581                	li	a1,0
    800044d6:	8556                	mv	a0,s5
    800044d8:	fffff097          	auipc	ra,0xfffff
    800044dc:	a58080e7          	jalr	-1448(ra) # 80002f30 <readi>
    800044e0:	03800793          	li	a5,56
    800044e4:	f6f51be3          	bne	a0,a5,8000445a <exec+0x2d0>
    if(ph.type != ELF_PROG_LOAD)
    800044e8:	e1842783          	lw	a5,-488(s0)
    800044ec:	4705                	li	a4,1
    800044ee:	fae79de3          	bne	a5,a4,800044a8 <exec+0x31e>
    if(ph.memsz < ph.filesz)
    800044f2:	e4043483          	ld	s1,-448(s0)
    800044f6:	e3843783          	ld	a5,-456(s0)
    800044fa:	f6f4ede3          	bltu	s1,a5,80004474 <exec+0x2ea>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800044fe:	e2843783          	ld	a5,-472(s0)
    80004502:	94be                	add	s1,s1,a5
    80004504:	f6f4ebe3          	bltu	s1,a5,8000447a <exec+0x2f0>
    if(ph.vaddr % PGSIZE != 0)
    80004508:	de043703          	ld	a4,-544(s0)
    8000450c:	8ff9                	and	a5,a5,a4
    8000450e:	fbad                	bnez	a5,80004480 <exec+0x2f6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004510:	e1c42503          	lw	a0,-484(s0)
    80004514:	00000097          	auipc	ra,0x0
    80004518:	c5c080e7          	jalr	-932(ra) # 80004170 <flags2perm>
    8000451c:	86aa                	mv	a3,a0
    8000451e:	8626                	mv	a2,s1
    80004520:	85ca                	mv	a1,s2
    80004522:	855a                	mv	a0,s6
    80004524:	ffffc097          	auipc	ra,0xffffc
    80004528:	386080e7          	jalr	902(ra) # 800008aa <uvmalloc>
    8000452c:	dea43c23          	sd	a0,-520(s0)
    80004530:	d939                	beqz	a0,80004486 <exec+0x2fc>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004532:	e2843c03          	ld	s8,-472(s0)
    80004536:	e2042c83          	lw	s9,-480(s0)
    8000453a:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000453e:	f60b83e3          	beqz	s7,800044a4 <exec+0x31a>
    80004542:	89de                	mv	s3,s7
    80004544:	4481                	li	s1,0
    80004546:	bb9d                	j	800042bc <exec+0x132>

0000000080004548 <argfd>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int argfd(int n, int *pfd, struct file **pf)
{
    80004548:	7179                	addi	sp,sp,-48
    8000454a:	f406                	sd	ra,40(sp)
    8000454c:	f022                	sd	s0,32(sp)
    8000454e:	ec26                	sd	s1,24(sp)
    80004550:	e84a                	sd	s2,16(sp)
    80004552:	1800                	addi	s0,sp,48
    80004554:	892e                	mv	s2,a1
    80004556:	84b2                	mv	s1,a2
    int fd;
    struct file *f;

    argint(n, &fd);
    80004558:	fdc40593          	addi	a1,s0,-36
    8000455c:	ffffe097          	auipc	ra,0xffffe
    80004560:	ba8080e7          	jalr	-1112(ra) # 80002104 <argint>
    if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80004564:	fdc42703          	lw	a4,-36(s0)
    80004568:	47bd                	li	a5,15
    8000456a:	02e7eb63          	bltu	a5,a4,800045a0 <argfd+0x58>
    8000456e:	ffffd097          	auipc	ra,0xffffd
    80004572:	8cc080e7          	jalr	-1844(ra) # 80000e3a <myproc>
    80004576:	fdc42703          	lw	a4,-36(s0)
    8000457a:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffd12da>
    8000457e:	078e                	slli	a5,a5,0x3
    80004580:	953e                	add	a0,a0,a5
    80004582:	611c                	ld	a5,0(a0)
    80004584:	c385                	beqz	a5,800045a4 <argfd+0x5c>
        return -1;
    if (pfd)
    80004586:	00090463          	beqz	s2,8000458e <argfd+0x46>
        *pfd = fd;
    8000458a:	00e92023          	sw	a4,0(s2)
    if (pf)
        *pf = f;
    return 0;
    8000458e:	4501                	li	a0,0
    if (pf)
    80004590:	c091                	beqz	s1,80004594 <argfd+0x4c>
        *pf = f;
    80004592:	e09c                	sd	a5,0(s1)
}
    80004594:	70a2                	ld	ra,40(sp)
    80004596:	7402                	ld	s0,32(sp)
    80004598:	64e2                	ld	s1,24(sp)
    8000459a:	6942                	ld	s2,16(sp)
    8000459c:	6145                	addi	sp,sp,48
    8000459e:	8082                	ret
        return -1;
    800045a0:	557d                	li	a0,-1
    800045a2:	bfcd                	j	80004594 <argfd+0x4c>
    800045a4:	557d                	li	a0,-1
    800045a6:	b7fd                	j	80004594 <argfd+0x4c>

00000000800045a8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int fdalloc(struct file *f)
{
    800045a8:	1101                	addi	sp,sp,-32
    800045aa:	ec06                	sd	ra,24(sp)
    800045ac:	e822                	sd	s0,16(sp)
    800045ae:	e426                	sd	s1,8(sp)
    800045b0:	1000                	addi	s0,sp,32
    800045b2:	84aa                	mv	s1,a0
    int fd;
    struct proc *p = myproc();
    800045b4:	ffffd097          	auipc	ra,0xffffd
    800045b8:	886080e7          	jalr	-1914(ra) # 80000e3a <myproc>
    800045bc:	862a                	mv	a2,a0

    for (fd = 0; fd < NOFILE; fd++) {
    800045be:	0d050793          	addi	a5,a0,208
    800045c2:	4501                	li	a0,0
    800045c4:	46c1                	li	a3,16
        if (p->ofile[fd] == 0) {
    800045c6:	6398                	ld	a4,0(a5)
    800045c8:	cb19                	beqz	a4,800045de <fdalloc+0x36>
    for (fd = 0; fd < NOFILE; fd++) {
    800045ca:	2505                	addiw	a0,a0,1
    800045cc:	07a1                	addi	a5,a5,8
    800045ce:	fed51ce3          	bne	a0,a3,800045c6 <fdalloc+0x1e>
            p->ofile[fd] = f;
            return fd;
        }
    }
    return -1;
    800045d2:	557d                	li	a0,-1
}
    800045d4:	60e2                	ld	ra,24(sp)
    800045d6:	6442                	ld	s0,16(sp)
    800045d8:	64a2                	ld	s1,8(sp)
    800045da:	6105                	addi	sp,sp,32
    800045dc:	8082                	ret
            p->ofile[fd] = f;
    800045de:	01a50793          	addi	a5,a0,26
    800045e2:	078e                	slli	a5,a5,0x3
    800045e4:	963e                	add	a2,a2,a5
    800045e6:	e204                	sd	s1,0(a2)
            return fd;
    800045e8:	b7f5                	j	800045d4 <fdalloc+0x2c>

00000000800045ea <create>:
    end_op();
    return -1;
}

static struct inode *create(char *path, short type, short major, short minor)
{
    800045ea:	715d                	addi	sp,sp,-80
    800045ec:	e486                	sd	ra,72(sp)
    800045ee:	e0a2                	sd	s0,64(sp)
    800045f0:	fc26                	sd	s1,56(sp)
    800045f2:	f84a                	sd	s2,48(sp)
    800045f4:	f44e                	sd	s3,40(sp)
    800045f6:	f052                	sd	s4,32(sp)
    800045f8:	ec56                	sd	s5,24(sp)
    800045fa:	e85a                	sd	s6,16(sp)
    800045fc:	0880                	addi	s0,sp,80
    800045fe:	8b2e                	mv	s6,a1
    80004600:	89b2                	mv	s3,a2
    80004602:	8936                	mv	s2,a3
    struct inode *ip, *dp;
    char name[DIRSIZ];

    if ((dp = nameiparent(path, name)) == 0)
    80004604:	fb040593          	addi	a1,s0,-80
    80004608:	fffff097          	auipc	ra,0xfffff
    8000460c:	e3e080e7          	jalr	-450(ra) # 80003446 <nameiparent>
    80004610:	84aa                	mv	s1,a0
    80004612:	14050f63          	beqz	a0,80004770 <create+0x186>
        return 0;

    ilock(dp);
    80004616:	ffffe097          	auipc	ra,0xffffe
    8000461a:	666080e7          	jalr	1638(ra) # 80002c7c <ilock>

    if ((ip = dirlookup(dp, name, 0)) != 0) {
    8000461e:	4601                	li	a2,0
    80004620:	fb040593          	addi	a1,s0,-80
    80004624:	8526                	mv	a0,s1
    80004626:	fffff097          	auipc	ra,0xfffff
    8000462a:	b3a080e7          	jalr	-1222(ra) # 80003160 <dirlookup>
    8000462e:	8aaa                	mv	s5,a0
    80004630:	c931                	beqz	a0,80004684 <create+0x9a>
        iunlockput(dp);
    80004632:	8526                	mv	a0,s1
    80004634:	fffff097          	auipc	ra,0xfffff
    80004638:	8aa080e7          	jalr	-1878(ra) # 80002ede <iunlockput>
        ilock(ip);
    8000463c:	8556                	mv	a0,s5
    8000463e:	ffffe097          	auipc	ra,0xffffe
    80004642:	63e080e7          	jalr	1598(ra) # 80002c7c <ilock>
        if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004646:	000b059b          	sext.w	a1,s6
    8000464a:	4789                	li	a5,2
    8000464c:	02f59563          	bne	a1,a5,80004676 <create+0x8c>
    80004650:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffd1304>
    80004654:	37f9                	addiw	a5,a5,-2
    80004656:	17c2                	slli	a5,a5,0x30
    80004658:	93c1                	srli	a5,a5,0x30
    8000465a:	4705                	li	a4,1
    8000465c:	00f76d63          	bltu	a4,a5,80004676 <create+0x8c>
    ip->nlink = 0;
    iupdate(ip);
    iunlockput(ip);
    iunlockput(dp);
    return 0;
}
    80004660:	8556                	mv	a0,s5
    80004662:	60a6                	ld	ra,72(sp)
    80004664:	6406                	ld	s0,64(sp)
    80004666:	74e2                	ld	s1,56(sp)
    80004668:	7942                	ld	s2,48(sp)
    8000466a:	79a2                	ld	s3,40(sp)
    8000466c:	7a02                	ld	s4,32(sp)
    8000466e:	6ae2                	ld	s5,24(sp)
    80004670:	6b42                	ld	s6,16(sp)
    80004672:	6161                	addi	sp,sp,80
    80004674:	8082                	ret
        iunlockput(ip);
    80004676:	8556                	mv	a0,s5
    80004678:	fffff097          	auipc	ra,0xfffff
    8000467c:	866080e7          	jalr	-1946(ra) # 80002ede <iunlockput>
        return 0;
    80004680:	4a81                	li	s5,0
    80004682:	bff9                	j	80004660 <create+0x76>
    if ((ip = ialloc(dp->dev, type)) == 0) {
    80004684:	85da                	mv	a1,s6
    80004686:	4088                	lw	a0,0(s1)
    80004688:	ffffe097          	auipc	ra,0xffffe
    8000468c:	456080e7          	jalr	1110(ra) # 80002ade <ialloc>
    80004690:	8a2a                	mv	s4,a0
    80004692:	c539                	beqz	a0,800046e0 <create+0xf6>
    ilock(ip);
    80004694:	ffffe097          	auipc	ra,0xffffe
    80004698:	5e8080e7          	jalr	1512(ra) # 80002c7c <ilock>
    ip->major = major;
    8000469c:	053a1323          	sh	s3,70(s4)
    ip->minor = minor;
    800046a0:	052a1423          	sh	s2,72(s4)
    ip->nlink = 1;
    800046a4:	4905                	li	s2,1
    800046a6:	052a1523          	sh	s2,74(s4)
    iupdate(ip);
    800046aa:	8552                	mv	a0,s4
    800046ac:	ffffe097          	auipc	ra,0xffffe
    800046b0:	504080e7          	jalr	1284(ra) # 80002bb0 <iupdate>
    if (type == T_DIR) { // Create . and .. entries.
    800046b4:	000b059b          	sext.w	a1,s6
    800046b8:	03258b63          	beq	a1,s2,800046ee <create+0x104>
    if (dirlink(dp, name, ip->inum) < 0)
    800046bc:	004a2603          	lw	a2,4(s4)
    800046c0:	fb040593          	addi	a1,s0,-80
    800046c4:	8526                	mv	a0,s1
    800046c6:	fffff097          	auipc	ra,0xfffff
    800046ca:	cb0080e7          	jalr	-848(ra) # 80003376 <dirlink>
    800046ce:	06054f63          	bltz	a0,8000474c <create+0x162>
    iunlockput(dp);
    800046d2:	8526                	mv	a0,s1
    800046d4:	fffff097          	auipc	ra,0xfffff
    800046d8:	80a080e7          	jalr	-2038(ra) # 80002ede <iunlockput>
    return ip;
    800046dc:	8ad2                	mv	s5,s4
    800046de:	b749                	j	80004660 <create+0x76>
        iunlockput(dp);
    800046e0:	8526                	mv	a0,s1
    800046e2:	ffffe097          	auipc	ra,0xffffe
    800046e6:	7fc080e7          	jalr	2044(ra) # 80002ede <iunlockput>
        return 0;
    800046ea:	8ad2                	mv	s5,s4
    800046ec:	bf95                	j	80004660 <create+0x76>
        if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046ee:	004a2603          	lw	a2,4(s4)
    800046f2:	00004597          	auipc	a1,0x4
    800046f6:	f6658593          	addi	a1,a1,-154 # 80008658 <syscalls+0x2b0>
    800046fa:	8552                	mv	a0,s4
    800046fc:	fffff097          	auipc	ra,0xfffff
    80004700:	c7a080e7          	jalr	-902(ra) # 80003376 <dirlink>
    80004704:	04054463          	bltz	a0,8000474c <create+0x162>
    80004708:	40d0                	lw	a2,4(s1)
    8000470a:	00004597          	auipc	a1,0x4
    8000470e:	f5658593          	addi	a1,a1,-170 # 80008660 <syscalls+0x2b8>
    80004712:	8552                	mv	a0,s4
    80004714:	fffff097          	auipc	ra,0xfffff
    80004718:	c62080e7          	jalr	-926(ra) # 80003376 <dirlink>
    8000471c:	02054863          	bltz	a0,8000474c <create+0x162>
    if (dirlink(dp, name, ip->inum) < 0)
    80004720:	004a2603          	lw	a2,4(s4)
    80004724:	fb040593          	addi	a1,s0,-80
    80004728:	8526                	mv	a0,s1
    8000472a:	fffff097          	auipc	ra,0xfffff
    8000472e:	c4c080e7          	jalr	-948(ra) # 80003376 <dirlink>
    80004732:	00054d63          	bltz	a0,8000474c <create+0x162>
        dp->nlink++; // for ".."
    80004736:	04a4d783          	lhu	a5,74(s1)
    8000473a:	2785                	addiw	a5,a5,1
    8000473c:	04f49523          	sh	a5,74(s1)
        iupdate(dp);
    80004740:	8526                	mv	a0,s1
    80004742:	ffffe097          	auipc	ra,0xffffe
    80004746:	46e080e7          	jalr	1134(ra) # 80002bb0 <iupdate>
    8000474a:	b761                	j	800046d2 <create+0xe8>
    ip->nlink = 0;
    8000474c:	040a1523          	sh	zero,74(s4)
    iupdate(ip);
    80004750:	8552                	mv	a0,s4
    80004752:	ffffe097          	auipc	ra,0xffffe
    80004756:	45e080e7          	jalr	1118(ra) # 80002bb0 <iupdate>
    iunlockput(ip);
    8000475a:	8552                	mv	a0,s4
    8000475c:	ffffe097          	auipc	ra,0xffffe
    80004760:	782080e7          	jalr	1922(ra) # 80002ede <iunlockput>
    iunlockput(dp);
    80004764:	8526                	mv	a0,s1
    80004766:	ffffe097          	auipc	ra,0xffffe
    8000476a:	778080e7          	jalr	1912(ra) # 80002ede <iunlockput>
    return 0;
    8000476e:	bdcd                	j	80004660 <create+0x76>
        return 0;
    80004770:	8aaa                	mv	s5,a0
    80004772:	b5fd                	j	80004660 <create+0x76>

0000000080004774 <sys_dup>:
{
    80004774:	7179                	addi	sp,sp,-48
    80004776:	f406                	sd	ra,40(sp)
    80004778:	f022                	sd	s0,32(sp)
    8000477a:	ec26                	sd	s1,24(sp)
    8000477c:	e84a                	sd	s2,16(sp)
    8000477e:	1800                	addi	s0,sp,48
    if (argfd(0, 0, &f) < 0)
    80004780:	fd840613          	addi	a2,s0,-40
    80004784:	4581                	li	a1,0
    80004786:	4501                	li	a0,0
    80004788:	00000097          	auipc	ra,0x0
    8000478c:	dc0080e7          	jalr	-576(ra) # 80004548 <argfd>
        return -1;
    80004790:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0)
    80004792:	02054363          	bltz	a0,800047b8 <sys_dup+0x44>
    if ((fd = fdalloc(f)) < 0)
    80004796:	fd843903          	ld	s2,-40(s0)
    8000479a:	854a                	mv	a0,s2
    8000479c:	00000097          	auipc	ra,0x0
    800047a0:	e0c080e7          	jalr	-500(ra) # 800045a8 <fdalloc>
    800047a4:	84aa                	mv	s1,a0
        return -1;
    800047a6:	57fd                	li	a5,-1
    if ((fd = fdalloc(f)) < 0)
    800047a8:	00054863          	bltz	a0,800047b8 <sys_dup+0x44>
    filedup(f);
    800047ac:	854a                	mv	a0,s2
    800047ae:	fffff097          	auipc	ra,0xfffff
    800047b2:	310080e7          	jalr	784(ra) # 80003abe <filedup>
    return fd;
    800047b6:	87a6                	mv	a5,s1
}
    800047b8:	853e                	mv	a0,a5
    800047ba:	70a2                	ld	ra,40(sp)
    800047bc:	7402                	ld	s0,32(sp)
    800047be:	64e2                	ld	s1,24(sp)
    800047c0:	6942                	ld	s2,16(sp)
    800047c2:	6145                	addi	sp,sp,48
    800047c4:	8082                	ret

00000000800047c6 <sys_read>:
{
    800047c6:	7179                	addi	sp,sp,-48
    800047c8:	f406                	sd	ra,40(sp)
    800047ca:	f022                	sd	s0,32(sp)
    800047cc:	1800                	addi	s0,sp,48
    argaddr(1, &p);
    800047ce:	fd840593          	addi	a1,s0,-40
    800047d2:	4505                	li	a0,1
    800047d4:	ffffe097          	auipc	ra,0xffffe
    800047d8:	950080e7          	jalr	-1712(ra) # 80002124 <argaddr>
    argint(2, &n);
    800047dc:	fe440593          	addi	a1,s0,-28
    800047e0:	4509                	li	a0,2
    800047e2:	ffffe097          	auipc	ra,0xffffe
    800047e6:	922080e7          	jalr	-1758(ra) # 80002104 <argint>
    if (argfd(0, 0, &f) < 0)
    800047ea:	fe840613          	addi	a2,s0,-24
    800047ee:	4581                	li	a1,0
    800047f0:	4501                	li	a0,0
    800047f2:	00000097          	auipc	ra,0x0
    800047f6:	d56080e7          	jalr	-682(ra) # 80004548 <argfd>
    800047fa:	87aa                	mv	a5,a0
        return -1;
    800047fc:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    800047fe:	0007cc63          	bltz	a5,80004816 <sys_read+0x50>
    return fileread(f, p, n);
    80004802:	fe442603          	lw	a2,-28(s0)
    80004806:	fd843583          	ld	a1,-40(s0)
    8000480a:	fe843503          	ld	a0,-24(s0)
    8000480e:	fffff097          	auipc	ra,0xfffff
    80004812:	43c080e7          	jalr	1084(ra) # 80003c4a <fileread>
}
    80004816:	70a2                	ld	ra,40(sp)
    80004818:	7402                	ld	s0,32(sp)
    8000481a:	6145                	addi	sp,sp,48
    8000481c:	8082                	ret

000000008000481e <sys_write>:
{
    8000481e:	7179                	addi	sp,sp,-48
    80004820:	f406                	sd	ra,40(sp)
    80004822:	f022                	sd	s0,32(sp)
    80004824:	1800                	addi	s0,sp,48
    argaddr(1, &p);
    80004826:	fd840593          	addi	a1,s0,-40
    8000482a:	4505                	li	a0,1
    8000482c:	ffffe097          	auipc	ra,0xffffe
    80004830:	8f8080e7          	jalr	-1800(ra) # 80002124 <argaddr>
    argint(2, &n);
    80004834:	fe440593          	addi	a1,s0,-28
    80004838:	4509                	li	a0,2
    8000483a:	ffffe097          	auipc	ra,0xffffe
    8000483e:	8ca080e7          	jalr	-1846(ra) # 80002104 <argint>
    if (argfd(0, 0, &f) < 0)
    80004842:	fe840613          	addi	a2,s0,-24
    80004846:	4581                	li	a1,0
    80004848:	4501                	li	a0,0
    8000484a:	00000097          	auipc	ra,0x0
    8000484e:	cfe080e7          	jalr	-770(ra) # 80004548 <argfd>
    80004852:	87aa                	mv	a5,a0
        return -1;
    80004854:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    80004856:	0007cc63          	bltz	a5,8000486e <sys_write+0x50>
    return filewrite(f, p, n);
    8000485a:	fe442603          	lw	a2,-28(s0)
    8000485e:	fd843583          	ld	a1,-40(s0)
    80004862:	fe843503          	ld	a0,-24(s0)
    80004866:	fffff097          	auipc	ra,0xfffff
    8000486a:	4a6080e7          	jalr	1190(ra) # 80003d0c <filewrite>
}
    8000486e:	70a2                	ld	ra,40(sp)
    80004870:	7402                	ld	s0,32(sp)
    80004872:	6145                	addi	sp,sp,48
    80004874:	8082                	ret

0000000080004876 <sys_close>:
{
    80004876:	1101                	addi	sp,sp,-32
    80004878:	ec06                	sd	ra,24(sp)
    8000487a:	e822                	sd	s0,16(sp)
    8000487c:	1000                	addi	s0,sp,32
    if (argfd(0, &fd, &f) < 0)
    8000487e:	fe040613          	addi	a2,s0,-32
    80004882:	fec40593          	addi	a1,s0,-20
    80004886:	4501                	li	a0,0
    80004888:	00000097          	auipc	ra,0x0
    8000488c:	cc0080e7          	jalr	-832(ra) # 80004548 <argfd>
        return -1;
    80004890:	57fd                	li	a5,-1
    if (argfd(0, &fd, &f) < 0)
    80004892:	02054463          	bltz	a0,800048ba <sys_close+0x44>
    myproc()->ofile[fd] = 0;
    80004896:	ffffc097          	auipc	ra,0xffffc
    8000489a:	5a4080e7          	jalr	1444(ra) # 80000e3a <myproc>
    8000489e:	fec42783          	lw	a5,-20(s0)
    800048a2:	07e9                	addi	a5,a5,26
    800048a4:	078e                	slli	a5,a5,0x3
    800048a6:	953e                	add	a0,a0,a5
    800048a8:	00053023          	sd	zero,0(a0)
    fileclose(f);
    800048ac:	fe043503          	ld	a0,-32(s0)
    800048b0:	fffff097          	auipc	ra,0xfffff
    800048b4:	260080e7          	jalr	608(ra) # 80003b10 <fileclose>
    return 0;
    800048b8:	4781                	li	a5,0
}
    800048ba:	853e                	mv	a0,a5
    800048bc:	60e2                	ld	ra,24(sp)
    800048be:	6442                	ld	s0,16(sp)
    800048c0:	6105                	addi	sp,sp,32
    800048c2:	8082                	ret

00000000800048c4 <sys_fstat>:
{
    800048c4:	1101                	addi	sp,sp,-32
    800048c6:	ec06                	sd	ra,24(sp)
    800048c8:	e822                	sd	s0,16(sp)
    800048ca:	1000                	addi	s0,sp,32
    argaddr(1, &st);
    800048cc:	fe040593          	addi	a1,s0,-32
    800048d0:	4505                	li	a0,1
    800048d2:	ffffe097          	auipc	ra,0xffffe
    800048d6:	852080e7          	jalr	-1966(ra) # 80002124 <argaddr>
    if (argfd(0, 0, &f) < 0)
    800048da:	fe840613          	addi	a2,s0,-24
    800048de:	4581                	li	a1,0
    800048e0:	4501                	li	a0,0
    800048e2:	00000097          	auipc	ra,0x0
    800048e6:	c66080e7          	jalr	-922(ra) # 80004548 <argfd>
    800048ea:	87aa                	mv	a5,a0
        return -1;
    800048ec:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    800048ee:	0007ca63          	bltz	a5,80004902 <sys_fstat+0x3e>
    return filestat(f, st);
    800048f2:	fe043583          	ld	a1,-32(s0)
    800048f6:	fe843503          	ld	a0,-24(s0)
    800048fa:	fffff097          	auipc	ra,0xfffff
    800048fe:	2de080e7          	jalr	734(ra) # 80003bd8 <filestat>
}
    80004902:	60e2                	ld	ra,24(sp)
    80004904:	6442                	ld	s0,16(sp)
    80004906:	6105                	addi	sp,sp,32
    80004908:	8082                	ret

000000008000490a <sys_link>:
{
    8000490a:	7169                	addi	sp,sp,-304
    8000490c:	f606                	sd	ra,296(sp)
    8000490e:	f222                	sd	s0,288(sp)
    80004910:	ee26                	sd	s1,280(sp)
    80004912:	ea4a                	sd	s2,272(sp)
    80004914:	1a00                	addi	s0,sp,304
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004916:	08000613          	li	a2,128
    8000491a:	ed040593          	addi	a1,s0,-304
    8000491e:	4501                	li	a0,0
    80004920:	ffffe097          	auipc	ra,0xffffe
    80004924:	824080e7          	jalr	-2012(ra) # 80002144 <argstr>
        return -1;
    80004928:	57fd                	li	a5,-1
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000492a:	10054e63          	bltz	a0,80004a46 <sys_link+0x13c>
    8000492e:	08000613          	li	a2,128
    80004932:	f5040593          	addi	a1,s0,-176
    80004936:	4505                	li	a0,1
    80004938:	ffffe097          	auipc	ra,0xffffe
    8000493c:	80c080e7          	jalr	-2036(ra) # 80002144 <argstr>
        return -1;
    80004940:	57fd                	li	a5,-1
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004942:	10054263          	bltz	a0,80004a46 <sys_link+0x13c>
    begin_op();
    80004946:	fffff097          	auipc	ra,0xfffff
    8000494a:	d02080e7          	jalr	-766(ra) # 80003648 <begin_op>
    if ((ip = namei(old)) == 0) {
    8000494e:	ed040513          	addi	a0,s0,-304
    80004952:	fffff097          	auipc	ra,0xfffff
    80004956:	ad6080e7          	jalr	-1322(ra) # 80003428 <namei>
    8000495a:	84aa                	mv	s1,a0
    8000495c:	c551                	beqz	a0,800049e8 <sys_link+0xde>
    ilock(ip);
    8000495e:	ffffe097          	auipc	ra,0xffffe
    80004962:	31e080e7          	jalr	798(ra) # 80002c7c <ilock>
    if (ip->type == T_DIR) {
    80004966:	04449703          	lh	a4,68(s1)
    8000496a:	4785                	li	a5,1
    8000496c:	08f70463          	beq	a4,a5,800049f4 <sys_link+0xea>
    ip->nlink++;
    80004970:	04a4d783          	lhu	a5,74(s1)
    80004974:	2785                	addiw	a5,a5,1
    80004976:	04f49523          	sh	a5,74(s1)
    iupdate(ip);
    8000497a:	8526                	mv	a0,s1
    8000497c:	ffffe097          	auipc	ra,0xffffe
    80004980:	234080e7          	jalr	564(ra) # 80002bb0 <iupdate>
    iunlock(ip);
    80004984:	8526                	mv	a0,s1
    80004986:	ffffe097          	auipc	ra,0xffffe
    8000498a:	3b8080e7          	jalr	952(ra) # 80002d3e <iunlock>
    if ((dp = nameiparent(new, name)) == 0)
    8000498e:	fd040593          	addi	a1,s0,-48
    80004992:	f5040513          	addi	a0,s0,-176
    80004996:	fffff097          	auipc	ra,0xfffff
    8000499a:	ab0080e7          	jalr	-1360(ra) # 80003446 <nameiparent>
    8000499e:	892a                	mv	s2,a0
    800049a0:	c935                	beqz	a0,80004a14 <sys_link+0x10a>
    ilock(dp);
    800049a2:	ffffe097          	auipc	ra,0xffffe
    800049a6:	2da080e7          	jalr	730(ra) # 80002c7c <ilock>
    if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    800049aa:	00092703          	lw	a4,0(s2)
    800049ae:	409c                	lw	a5,0(s1)
    800049b0:	04f71d63          	bne	a4,a5,80004a0a <sys_link+0x100>
    800049b4:	40d0                	lw	a2,4(s1)
    800049b6:	fd040593          	addi	a1,s0,-48
    800049ba:	854a                	mv	a0,s2
    800049bc:	fffff097          	auipc	ra,0xfffff
    800049c0:	9ba080e7          	jalr	-1606(ra) # 80003376 <dirlink>
    800049c4:	04054363          	bltz	a0,80004a0a <sys_link+0x100>
    iunlockput(dp);
    800049c8:	854a                	mv	a0,s2
    800049ca:	ffffe097          	auipc	ra,0xffffe
    800049ce:	514080e7          	jalr	1300(ra) # 80002ede <iunlockput>
    iput(ip);
    800049d2:	8526                	mv	a0,s1
    800049d4:	ffffe097          	auipc	ra,0xffffe
    800049d8:	462080e7          	jalr	1122(ra) # 80002e36 <iput>
    end_op();
    800049dc:	fffff097          	auipc	ra,0xfffff
    800049e0:	cea080e7          	jalr	-790(ra) # 800036c6 <end_op>
    return 0;
    800049e4:	4781                	li	a5,0
    800049e6:	a085                	j	80004a46 <sys_link+0x13c>
        end_op();
    800049e8:	fffff097          	auipc	ra,0xfffff
    800049ec:	cde080e7          	jalr	-802(ra) # 800036c6 <end_op>
        return -1;
    800049f0:	57fd                	li	a5,-1
    800049f2:	a891                	j	80004a46 <sys_link+0x13c>
        iunlockput(ip);
    800049f4:	8526                	mv	a0,s1
    800049f6:	ffffe097          	auipc	ra,0xffffe
    800049fa:	4e8080e7          	jalr	1256(ra) # 80002ede <iunlockput>
        end_op();
    800049fe:	fffff097          	auipc	ra,0xfffff
    80004a02:	cc8080e7          	jalr	-824(ra) # 800036c6 <end_op>
        return -1;
    80004a06:	57fd                	li	a5,-1
    80004a08:	a83d                	j	80004a46 <sys_link+0x13c>
        iunlockput(dp);
    80004a0a:	854a                	mv	a0,s2
    80004a0c:	ffffe097          	auipc	ra,0xffffe
    80004a10:	4d2080e7          	jalr	1234(ra) # 80002ede <iunlockput>
    ilock(ip);
    80004a14:	8526                	mv	a0,s1
    80004a16:	ffffe097          	auipc	ra,0xffffe
    80004a1a:	266080e7          	jalr	614(ra) # 80002c7c <ilock>
    ip->nlink--;
    80004a1e:	04a4d783          	lhu	a5,74(s1)
    80004a22:	37fd                	addiw	a5,a5,-1
    80004a24:	04f49523          	sh	a5,74(s1)
    iupdate(ip);
    80004a28:	8526                	mv	a0,s1
    80004a2a:	ffffe097          	auipc	ra,0xffffe
    80004a2e:	186080e7          	jalr	390(ra) # 80002bb0 <iupdate>
    iunlockput(ip);
    80004a32:	8526                	mv	a0,s1
    80004a34:	ffffe097          	auipc	ra,0xffffe
    80004a38:	4aa080e7          	jalr	1194(ra) # 80002ede <iunlockput>
    end_op();
    80004a3c:	fffff097          	auipc	ra,0xfffff
    80004a40:	c8a080e7          	jalr	-886(ra) # 800036c6 <end_op>
    return -1;
    80004a44:	57fd                	li	a5,-1
}
    80004a46:	853e                	mv	a0,a5
    80004a48:	70b2                	ld	ra,296(sp)
    80004a4a:	7412                	ld	s0,288(sp)
    80004a4c:	64f2                	ld	s1,280(sp)
    80004a4e:	6952                	ld	s2,272(sp)
    80004a50:	6155                	addi	sp,sp,304
    80004a52:	8082                	ret

0000000080004a54 <sys_unlink>:
{
    80004a54:	7151                	addi	sp,sp,-240
    80004a56:	f586                	sd	ra,232(sp)
    80004a58:	f1a2                	sd	s0,224(sp)
    80004a5a:	eda6                	sd	s1,216(sp)
    80004a5c:	e9ca                	sd	s2,208(sp)
    80004a5e:	e5ce                	sd	s3,200(sp)
    80004a60:	1980                	addi	s0,sp,240
    if (argstr(0, path, MAXPATH) < 0)
    80004a62:	08000613          	li	a2,128
    80004a66:	f3040593          	addi	a1,s0,-208
    80004a6a:	4501                	li	a0,0
    80004a6c:	ffffd097          	auipc	ra,0xffffd
    80004a70:	6d8080e7          	jalr	1752(ra) # 80002144 <argstr>
    80004a74:	18054163          	bltz	a0,80004bf6 <sys_unlink+0x1a2>
    begin_op();
    80004a78:	fffff097          	auipc	ra,0xfffff
    80004a7c:	bd0080e7          	jalr	-1072(ra) # 80003648 <begin_op>
    if ((dp = nameiparent(path, name)) == 0) {
    80004a80:	fb040593          	addi	a1,s0,-80
    80004a84:	f3040513          	addi	a0,s0,-208
    80004a88:	fffff097          	auipc	ra,0xfffff
    80004a8c:	9be080e7          	jalr	-1602(ra) # 80003446 <nameiparent>
    80004a90:	84aa                	mv	s1,a0
    80004a92:	c979                	beqz	a0,80004b68 <sys_unlink+0x114>
    ilock(dp);
    80004a94:	ffffe097          	auipc	ra,0xffffe
    80004a98:	1e8080e7          	jalr	488(ra) # 80002c7c <ilock>
    if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a9c:	00004597          	auipc	a1,0x4
    80004aa0:	bbc58593          	addi	a1,a1,-1092 # 80008658 <syscalls+0x2b0>
    80004aa4:	fb040513          	addi	a0,s0,-80
    80004aa8:	ffffe097          	auipc	ra,0xffffe
    80004aac:	69e080e7          	jalr	1694(ra) # 80003146 <namecmp>
    80004ab0:	14050a63          	beqz	a0,80004c04 <sys_unlink+0x1b0>
    80004ab4:	00004597          	auipc	a1,0x4
    80004ab8:	bac58593          	addi	a1,a1,-1108 # 80008660 <syscalls+0x2b8>
    80004abc:	fb040513          	addi	a0,s0,-80
    80004ac0:	ffffe097          	auipc	ra,0xffffe
    80004ac4:	686080e7          	jalr	1670(ra) # 80003146 <namecmp>
    80004ac8:	12050e63          	beqz	a0,80004c04 <sys_unlink+0x1b0>
    if ((ip = dirlookup(dp, name, &off)) == 0)
    80004acc:	f2c40613          	addi	a2,s0,-212
    80004ad0:	fb040593          	addi	a1,s0,-80
    80004ad4:	8526                	mv	a0,s1
    80004ad6:	ffffe097          	auipc	ra,0xffffe
    80004ada:	68a080e7          	jalr	1674(ra) # 80003160 <dirlookup>
    80004ade:	892a                	mv	s2,a0
    80004ae0:	12050263          	beqz	a0,80004c04 <sys_unlink+0x1b0>
    ilock(ip);
    80004ae4:	ffffe097          	auipc	ra,0xffffe
    80004ae8:	198080e7          	jalr	408(ra) # 80002c7c <ilock>
    if (ip->nlink < 1)
    80004aec:	04a91783          	lh	a5,74(s2)
    80004af0:	08f05263          	blez	a5,80004b74 <sys_unlink+0x120>
    if (ip->type == T_DIR && !isdirempty(ip)) {
    80004af4:	04491703          	lh	a4,68(s2)
    80004af8:	4785                	li	a5,1
    80004afa:	08f70563          	beq	a4,a5,80004b84 <sys_unlink+0x130>
    memset(&de, 0, sizeof(de));
    80004afe:	4641                	li	a2,16
    80004b00:	4581                	li	a1,0
    80004b02:	fc040513          	addi	a0,s0,-64
    80004b06:	ffffb097          	auipc	ra,0xffffb
    80004b0a:	674080e7          	jalr	1652(ra) # 8000017a <memset>
    if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b0e:	4741                	li	a4,16
    80004b10:	f2c42683          	lw	a3,-212(s0)
    80004b14:	fc040613          	addi	a2,s0,-64
    80004b18:	4581                	li	a1,0
    80004b1a:	8526                	mv	a0,s1
    80004b1c:	ffffe097          	auipc	ra,0xffffe
    80004b20:	50c080e7          	jalr	1292(ra) # 80003028 <writei>
    80004b24:	47c1                	li	a5,16
    80004b26:	0af51563          	bne	a0,a5,80004bd0 <sys_unlink+0x17c>
    if (ip->type == T_DIR) {
    80004b2a:	04491703          	lh	a4,68(s2)
    80004b2e:	4785                	li	a5,1
    80004b30:	0af70863          	beq	a4,a5,80004be0 <sys_unlink+0x18c>
    iunlockput(dp);
    80004b34:	8526                	mv	a0,s1
    80004b36:	ffffe097          	auipc	ra,0xffffe
    80004b3a:	3a8080e7          	jalr	936(ra) # 80002ede <iunlockput>
    ip->nlink--;
    80004b3e:	04a95783          	lhu	a5,74(s2)
    80004b42:	37fd                	addiw	a5,a5,-1
    80004b44:	04f91523          	sh	a5,74(s2)
    iupdate(ip);
    80004b48:	854a                	mv	a0,s2
    80004b4a:	ffffe097          	auipc	ra,0xffffe
    80004b4e:	066080e7          	jalr	102(ra) # 80002bb0 <iupdate>
    iunlockput(ip);
    80004b52:	854a                	mv	a0,s2
    80004b54:	ffffe097          	auipc	ra,0xffffe
    80004b58:	38a080e7          	jalr	906(ra) # 80002ede <iunlockput>
    end_op();
    80004b5c:	fffff097          	auipc	ra,0xfffff
    80004b60:	b6a080e7          	jalr	-1174(ra) # 800036c6 <end_op>
    return 0;
    80004b64:	4501                	li	a0,0
    80004b66:	a84d                	j	80004c18 <sys_unlink+0x1c4>
        end_op();
    80004b68:	fffff097          	auipc	ra,0xfffff
    80004b6c:	b5e080e7          	jalr	-1186(ra) # 800036c6 <end_op>
        return -1;
    80004b70:	557d                	li	a0,-1
    80004b72:	a05d                	j	80004c18 <sys_unlink+0x1c4>
        panic("unlink: nlink < 1");
    80004b74:	00004517          	auipc	a0,0x4
    80004b78:	af450513          	addi	a0,a0,-1292 # 80008668 <syscalls+0x2c0>
    80004b7c:	00001097          	auipc	ra,0x1
    80004b80:	3f0080e7          	jalr	1008(ra) # 80005f6c <panic>
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004b84:	04c92703          	lw	a4,76(s2)
    80004b88:	02000793          	li	a5,32
    80004b8c:	f6e7f9e3          	bgeu	a5,a4,80004afe <sys_unlink+0xaa>
    80004b90:	02000993          	li	s3,32
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b94:	4741                	li	a4,16
    80004b96:	86ce                	mv	a3,s3
    80004b98:	f1840613          	addi	a2,s0,-232
    80004b9c:	4581                	li	a1,0
    80004b9e:	854a                	mv	a0,s2
    80004ba0:	ffffe097          	auipc	ra,0xffffe
    80004ba4:	390080e7          	jalr	912(ra) # 80002f30 <readi>
    80004ba8:	47c1                	li	a5,16
    80004baa:	00f51b63          	bne	a0,a5,80004bc0 <sys_unlink+0x16c>
        if (de.inum != 0)
    80004bae:	f1845783          	lhu	a5,-232(s0)
    80004bb2:	e7a1                	bnez	a5,80004bfa <sys_unlink+0x1a6>
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004bb4:	29c1                	addiw	s3,s3,16
    80004bb6:	04c92783          	lw	a5,76(s2)
    80004bba:	fcf9ede3          	bltu	s3,a5,80004b94 <sys_unlink+0x140>
    80004bbe:	b781                	j	80004afe <sys_unlink+0xaa>
            panic("isdirempty: readi");
    80004bc0:	00004517          	auipc	a0,0x4
    80004bc4:	ac050513          	addi	a0,a0,-1344 # 80008680 <syscalls+0x2d8>
    80004bc8:	00001097          	auipc	ra,0x1
    80004bcc:	3a4080e7          	jalr	932(ra) # 80005f6c <panic>
        panic("unlink: writei");
    80004bd0:	00004517          	auipc	a0,0x4
    80004bd4:	ac850513          	addi	a0,a0,-1336 # 80008698 <syscalls+0x2f0>
    80004bd8:	00001097          	auipc	ra,0x1
    80004bdc:	394080e7          	jalr	916(ra) # 80005f6c <panic>
        dp->nlink--;
    80004be0:	04a4d783          	lhu	a5,74(s1)
    80004be4:	37fd                	addiw	a5,a5,-1
    80004be6:	04f49523          	sh	a5,74(s1)
        iupdate(dp);
    80004bea:	8526                	mv	a0,s1
    80004bec:	ffffe097          	auipc	ra,0xffffe
    80004bf0:	fc4080e7          	jalr	-60(ra) # 80002bb0 <iupdate>
    80004bf4:	b781                	j	80004b34 <sys_unlink+0xe0>
        return -1;
    80004bf6:	557d                	li	a0,-1
    80004bf8:	a005                	j	80004c18 <sys_unlink+0x1c4>
        iunlockput(ip);
    80004bfa:	854a                	mv	a0,s2
    80004bfc:	ffffe097          	auipc	ra,0xffffe
    80004c00:	2e2080e7          	jalr	738(ra) # 80002ede <iunlockput>
    iunlockput(dp);
    80004c04:	8526                	mv	a0,s1
    80004c06:	ffffe097          	auipc	ra,0xffffe
    80004c0a:	2d8080e7          	jalr	728(ra) # 80002ede <iunlockput>
    end_op();
    80004c0e:	fffff097          	auipc	ra,0xfffff
    80004c12:	ab8080e7          	jalr	-1352(ra) # 800036c6 <end_op>
    return -1;
    80004c16:	557d                	li	a0,-1
}
    80004c18:	70ae                	ld	ra,232(sp)
    80004c1a:	740e                	ld	s0,224(sp)
    80004c1c:	64ee                	ld	s1,216(sp)
    80004c1e:	694e                	ld	s2,208(sp)
    80004c20:	69ae                	ld	s3,200(sp)
    80004c22:	616d                	addi	sp,sp,240
    80004c24:	8082                	ret

0000000080004c26 <sys_open>:

uint64 sys_open(void)
{
    80004c26:	7131                	addi	sp,sp,-192
    80004c28:	fd06                	sd	ra,184(sp)
    80004c2a:	f922                	sd	s0,176(sp)
    80004c2c:	f526                	sd	s1,168(sp)
    80004c2e:	f14a                	sd	s2,160(sp)
    80004c30:	ed4e                	sd	s3,152(sp)
    80004c32:	0180                	addi	s0,sp,192
    int fd, omode;
    struct file *f;
    struct inode *ip;
    int n;

    argint(1, &omode);
    80004c34:	f4c40593          	addi	a1,s0,-180
    80004c38:	4505                	li	a0,1
    80004c3a:	ffffd097          	auipc	ra,0xffffd
    80004c3e:	4ca080e7          	jalr	1226(ra) # 80002104 <argint>
    if ((n = argstr(0, path, MAXPATH)) < 0)
    80004c42:	08000613          	li	a2,128
    80004c46:	f5040593          	addi	a1,s0,-176
    80004c4a:	4501                	li	a0,0
    80004c4c:	ffffd097          	auipc	ra,0xffffd
    80004c50:	4f8080e7          	jalr	1272(ra) # 80002144 <argstr>
    80004c54:	87aa                	mv	a5,a0
        return -1;
    80004c56:	557d                	li	a0,-1
    if ((n = argstr(0, path, MAXPATH)) < 0)
    80004c58:	0a07c963          	bltz	a5,80004d0a <sys_open+0xe4>

    begin_op();
    80004c5c:	fffff097          	auipc	ra,0xfffff
    80004c60:	9ec080e7          	jalr	-1556(ra) # 80003648 <begin_op>

    if (omode & O_CREATE) {
    80004c64:	f4c42783          	lw	a5,-180(s0)
    80004c68:	2007f793          	andi	a5,a5,512
    80004c6c:	cfc5                	beqz	a5,80004d24 <sys_open+0xfe>
        ip = create(path, T_FILE, 0, 0);
    80004c6e:	4681                	li	a3,0
    80004c70:	4601                	li	a2,0
    80004c72:	4589                	li	a1,2
    80004c74:	f5040513          	addi	a0,s0,-176
    80004c78:	00000097          	auipc	ra,0x0
    80004c7c:	972080e7          	jalr	-1678(ra) # 800045ea <create>
    80004c80:	84aa                	mv	s1,a0
        if (ip == 0) {
    80004c82:	c959                	beqz	a0,80004d18 <sys_open+0xf2>
            end_op();
            return -1;
        }
    }

    if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    80004c84:	04449703          	lh	a4,68(s1)
    80004c88:	478d                	li	a5,3
    80004c8a:	00f71763          	bne	a4,a5,80004c98 <sys_open+0x72>
    80004c8e:	0464d703          	lhu	a4,70(s1)
    80004c92:	47a5                	li	a5,9
    80004c94:	0ce7ed63          	bltu	a5,a4,80004d6e <sys_open+0x148>
        iunlockput(ip);
        end_op();
        return -1;
    }

    if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80004c98:	fffff097          	auipc	ra,0xfffff
    80004c9c:	dbc080e7          	jalr	-580(ra) # 80003a54 <filealloc>
    80004ca0:	89aa                	mv	s3,a0
    80004ca2:	10050363          	beqz	a0,80004da8 <sys_open+0x182>
    80004ca6:	00000097          	auipc	ra,0x0
    80004caa:	902080e7          	jalr	-1790(ra) # 800045a8 <fdalloc>
    80004cae:	892a                	mv	s2,a0
    80004cb0:	0e054763          	bltz	a0,80004d9e <sys_open+0x178>
        iunlockput(ip);
        end_op();
        return -1;
    }

    if (ip->type == T_DEVICE) {
    80004cb4:	04449703          	lh	a4,68(s1)
    80004cb8:	478d                	li	a5,3
    80004cba:	0cf70563          	beq	a4,a5,80004d84 <sys_open+0x15e>
        f->type = FD_DEVICE;
        f->major = ip->major;
    }
    else {
        f->type = FD_INODE;
    80004cbe:	4789                	li	a5,2
    80004cc0:	00f9a023          	sw	a5,0(s3)
        f->off = 0;
    80004cc4:	0209a023          	sw	zero,32(s3)
    }
    f->ip = ip;
    80004cc8:	0099bc23          	sd	s1,24(s3)
    f->readable = !(omode & O_WRONLY);
    80004ccc:	f4c42783          	lw	a5,-180(s0)
    80004cd0:	0017c713          	xori	a4,a5,1
    80004cd4:	8b05                	andi	a4,a4,1
    80004cd6:	00e98423          	sb	a4,8(s3)
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004cda:	0037f713          	andi	a4,a5,3
    80004cde:	00e03733          	snez	a4,a4
    80004ce2:	00e984a3          	sb	a4,9(s3)

    if ((omode & O_TRUNC) && ip->type == T_FILE) {
    80004ce6:	4007f793          	andi	a5,a5,1024
    80004cea:	c791                	beqz	a5,80004cf6 <sys_open+0xd0>
    80004cec:	04449703          	lh	a4,68(s1)
    80004cf0:	4789                	li	a5,2
    80004cf2:	0af70063          	beq	a4,a5,80004d92 <sys_open+0x16c>
        itrunc(ip);
    }

    iunlock(ip);
    80004cf6:	8526                	mv	a0,s1
    80004cf8:	ffffe097          	auipc	ra,0xffffe
    80004cfc:	046080e7          	jalr	70(ra) # 80002d3e <iunlock>
    end_op();
    80004d00:	fffff097          	auipc	ra,0xfffff
    80004d04:	9c6080e7          	jalr	-1594(ra) # 800036c6 <end_op>

    return fd;
    80004d08:	854a                	mv	a0,s2
}
    80004d0a:	70ea                	ld	ra,184(sp)
    80004d0c:	744a                	ld	s0,176(sp)
    80004d0e:	74aa                	ld	s1,168(sp)
    80004d10:	790a                	ld	s2,160(sp)
    80004d12:	69ea                	ld	s3,152(sp)
    80004d14:	6129                	addi	sp,sp,192
    80004d16:	8082                	ret
            end_op();
    80004d18:	fffff097          	auipc	ra,0xfffff
    80004d1c:	9ae080e7          	jalr	-1618(ra) # 800036c6 <end_op>
            return -1;
    80004d20:	557d                	li	a0,-1
    80004d22:	b7e5                	j	80004d0a <sys_open+0xe4>
        if ((ip = namei(path)) == 0) {
    80004d24:	f5040513          	addi	a0,s0,-176
    80004d28:	ffffe097          	auipc	ra,0xffffe
    80004d2c:	700080e7          	jalr	1792(ra) # 80003428 <namei>
    80004d30:	84aa                	mv	s1,a0
    80004d32:	c905                	beqz	a0,80004d62 <sys_open+0x13c>
        ilock(ip);
    80004d34:	ffffe097          	auipc	ra,0xffffe
    80004d38:	f48080e7          	jalr	-184(ra) # 80002c7c <ilock>
        if (ip->type == T_DIR && omode != O_RDONLY) {
    80004d3c:	04449703          	lh	a4,68(s1)
    80004d40:	4785                	li	a5,1
    80004d42:	f4f711e3          	bne	a4,a5,80004c84 <sys_open+0x5e>
    80004d46:	f4c42783          	lw	a5,-180(s0)
    80004d4a:	d7b9                	beqz	a5,80004c98 <sys_open+0x72>
            iunlockput(ip);
    80004d4c:	8526                	mv	a0,s1
    80004d4e:	ffffe097          	auipc	ra,0xffffe
    80004d52:	190080e7          	jalr	400(ra) # 80002ede <iunlockput>
            end_op();
    80004d56:	fffff097          	auipc	ra,0xfffff
    80004d5a:	970080e7          	jalr	-1680(ra) # 800036c6 <end_op>
            return -1;
    80004d5e:	557d                	li	a0,-1
    80004d60:	b76d                	j	80004d0a <sys_open+0xe4>
            end_op();
    80004d62:	fffff097          	auipc	ra,0xfffff
    80004d66:	964080e7          	jalr	-1692(ra) # 800036c6 <end_op>
            return -1;
    80004d6a:	557d                	li	a0,-1
    80004d6c:	bf79                	j	80004d0a <sys_open+0xe4>
        iunlockput(ip);
    80004d6e:	8526                	mv	a0,s1
    80004d70:	ffffe097          	auipc	ra,0xffffe
    80004d74:	16e080e7          	jalr	366(ra) # 80002ede <iunlockput>
        end_op();
    80004d78:	fffff097          	auipc	ra,0xfffff
    80004d7c:	94e080e7          	jalr	-1714(ra) # 800036c6 <end_op>
        return -1;
    80004d80:	557d                	li	a0,-1
    80004d82:	b761                	j	80004d0a <sys_open+0xe4>
        f->type = FD_DEVICE;
    80004d84:	00f9a023          	sw	a5,0(s3)
        f->major = ip->major;
    80004d88:	04649783          	lh	a5,70(s1)
    80004d8c:	02f99223          	sh	a5,36(s3)
    80004d90:	bf25                	j	80004cc8 <sys_open+0xa2>
        itrunc(ip);
    80004d92:	8526                	mv	a0,s1
    80004d94:	ffffe097          	auipc	ra,0xffffe
    80004d98:	ff6080e7          	jalr	-10(ra) # 80002d8a <itrunc>
    80004d9c:	bfa9                	j	80004cf6 <sys_open+0xd0>
            fileclose(f);
    80004d9e:	854e                	mv	a0,s3
    80004da0:	fffff097          	auipc	ra,0xfffff
    80004da4:	d70080e7          	jalr	-656(ra) # 80003b10 <fileclose>
        iunlockput(ip);
    80004da8:	8526                	mv	a0,s1
    80004daa:	ffffe097          	auipc	ra,0xffffe
    80004dae:	134080e7          	jalr	308(ra) # 80002ede <iunlockput>
        end_op();
    80004db2:	fffff097          	auipc	ra,0xfffff
    80004db6:	914080e7          	jalr	-1772(ra) # 800036c6 <end_op>
        return -1;
    80004dba:	557d                	li	a0,-1
    80004dbc:	b7b9                	j	80004d0a <sys_open+0xe4>

0000000080004dbe <sys_mkdir>:

uint64 sys_mkdir(void)
{
    80004dbe:	7175                	addi	sp,sp,-144
    80004dc0:	e506                	sd	ra,136(sp)
    80004dc2:	e122                	sd	s0,128(sp)
    80004dc4:	0900                	addi	s0,sp,144
    char path[MAXPATH];
    struct inode *ip;

    begin_op();
    80004dc6:	fffff097          	auipc	ra,0xfffff
    80004dca:	882080e7          	jalr	-1918(ra) # 80003648 <begin_op>
    if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    80004dce:	08000613          	li	a2,128
    80004dd2:	f7040593          	addi	a1,s0,-144
    80004dd6:	4501                	li	a0,0
    80004dd8:	ffffd097          	auipc	ra,0xffffd
    80004ddc:	36c080e7          	jalr	876(ra) # 80002144 <argstr>
    80004de0:	02054963          	bltz	a0,80004e12 <sys_mkdir+0x54>
    80004de4:	4681                	li	a3,0
    80004de6:	4601                	li	a2,0
    80004de8:	4585                	li	a1,1
    80004dea:	f7040513          	addi	a0,s0,-144
    80004dee:	fffff097          	auipc	ra,0xfffff
    80004df2:	7fc080e7          	jalr	2044(ra) # 800045ea <create>
    80004df6:	cd11                	beqz	a0,80004e12 <sys_mkdir+0x54>
        end_op();
        return -1;
    }
    iunlockput(ip);
    80004df8:	ffffe097          	auipc	ra,0xffffe
    80004dfc:	0e6080e7          	jalr	230(ra) # 80002ede <iunlockput>
    end_op();
    80004e00:	fffff097          	auipc	ra,0xfffff
    80004e04:	8c6080e7          	jalr	-1850(ra) # 800036c6 <end_op>
    return 0;
    80004e08:	4501                	li	a0,0
}
    80004e0a:	60aa                	ld	ra,136(sp)
    80004e0c:	640a                	ld	s0,128(sp)
    80004e0e:	6149                	addi	sp,sp,144
    80004e10:	8082                	ret
        end_op();
    80004e12:	fffff097          	auipc	ra,0xfffff
    80004e16:	8b4080e7          	jalr	-1868(ra) # 800036c6 <end_op>
        return -1;
    80004e1a:	557d                	li	a0,-1
    80004e1c:	b7fd                	j	80004e0a <sys_mkdir+0x4c>

0000000080004e1e <sys_mknod>:

uint64 sys_mknod(void)
{
    80004e1e:	7135                	addi	sp,sp,-160
    80004e20:	ed06                	sd	ra,152(sp)
    80004e22:	e922                	sd	s0,144(sp)
    80004e24:	1100                	addi	s0,sp,160
    struct inode *ip;
    char path[MAXPATH];
    int major, minor;

    begin_op();
    80004e26:	fffff097          	auipc	ra,0xfffff
    80004e2a:	822080e7          	jalr	-2014(ra) # 80003648 <begin_op>
    argint(1, &major);
    80004e2e:	f6c40593          	addi	a1,s0,-148
    80004e32:	4505                	li	a0,1
    80004e34:	ffffd097          	auipc	ra,0xffffd
    80004e38:	2d0080e7          	jalr	720(ra) # 80002104 <argint>
    argint(2, &minor);
    80004e3c:	f6840593          	addi	a1,s0,-152
    80004e40:	4509                	li	a0,2
    80004e42:	ffffd097          	auipc	ra,0xffffd
    80004e46:	2c2080e7          	jalr	706(ra) # 80002104 <argint>
    if ((argstr(0, path, MAXPATH)) < 0 || (ip = create(path, T_DEVICE, major, minor)) == 0) {
    80004e4a:	08000613          	li	a2,128
    80004e4e:	f7040593          	addi	a1,s0,-144
    80004e52:	4501                	li	a0,0
    80004e54:	ffffd097          	auipc	ra,0xffffd
    80004e58:	2f0080e7          	jalr	752(ra) # 80002144 <argstr>
    80004e5c:	02054b63          	bltz	a0,80004e92 <sys_mknod+0x74>
    80004e60:	f6841683          	lh	a3,-152(s0)
    80004e64:	f6c41603          	lh	a2,-148(s0)
    80004e68:	458d                	li	a1,3
    80004e6a:	f7040513          	addi	a0,s0,-144
    80004e6e:	fffff097          	auipc	ra,0xfffff
    80004e72:	77c080e7          	jalr	1916(ra) # 800045ea <create>
    80004e76:	cd11                	beqz	a0,80004e92 <sys_mknod+0x74>
        end_op();
        return -1;
    }
    iunlockput(ip);
    80004e78:	ffffe097          	auipc	ra,0xffffe
    80004e7c:	066080e7          	jalr	102(ra) # 80002ede <iunlockput>
    end_op();
    80004e80:	fffff097          	auipc	ra,0xfffff
    80004e84:	846080e7          	jalr	-1978(ra) # 800036c6 <end_op>
    return 0;
    80004e88:	4501                	li	a0,0
}
    80004e8a:	60ea                	ld	ra,152(sp)
    80004e8c:	644a                	ld	s0,144(sp)
    80004e8e:	610d                	addi	sp,sp,160
    80004e90:	8082                	ret
        end_op();
    80004e92:	fffff097          	auipc	ra,0xfffff
    80004e96:	834080e7          	jalr	-1996(ra) # 800036c6 <end_op>
        return -1;
    80004e9a:	557d                	li	a0,-1
    80004e9c:	b7fd                	j	80004e8a <sys_mknod+0x6c>

0000000080004e9e <sys_chdir>:

uint64 sys_chdir(void)
{
    80004e9e:	7135                	addi	sp,sp,-160
    80004ea0:	ed06                	sd	ra,152(sp)
    80004ea2:	e922                	sd	s0,144(sp)
    80004ea4:	e526                	sd	s1,136(sp)
    80004ea6:	e14a                	sd	s2,128(sp)
    80004ea8:	1100                	addi	s0,sp,160
    char path[MAXPATH];
    struct inode *ip;
    struct proc *p = myproc();
    80004eaa:	ffffc097          	auipc	ra,0xffffc
    80004eae:	f90080e7          	jalr	-112(ra) # 80000e3a <myproc>
    80004eb2:	892a                	mv	s2,a0

    begin_op();
    80004eb4:	ffffe097          	auipc	ra,0xffffe
    80004eb8:	794080e7          	jalr	1940(ra) # 80003648 <begin_op>
    if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    80004ebc:	08000613          	li	a2,128
    80004ec0:	f6040593          	addi	a1,s0,-160
    80004ec4:	4501                	li	a0,0
    80004ec6:	ffffd097          	auipc	ra,0xffffd
    80004eca:	27e080e7          	jalr	638(ra) # 80002144 <argstr>
    80004ece:	04054b63          	bltz	a0,80004f24 <sys_chdir+0x86>
    80004ed2:	f6040513          	addi	a0,s0,-160
    80004ed6:	ffffe097          	auipc	ra,0xffffe
    80004eda:	552080e7          	jalr	1362(ra) # 80003428 <namei>
    80004ede:	84aa                	mv	s1,a0
    80004ee0:	c131                	beqz	a0,80004f24 <sys_chdir+0x86>
        end_op();
        return -1;
    }
    ilock(ip);
    80004ee2:	ffffe097          	auipc	ra,0xffffe
    80004ee6:	d9a080e7          	jalr	-614(ra) # 80002c7c <ilock>
    if (ip->type != T_DIR) {
    80004eea:	04449703          	lh	a4,68(s1)
    80004eee:	4785                	li	a5,1
    80004ef0:	04f71063          	bne	a4,a5,80004f30 <sys_chdir+0x92>
        iunlockput(ip);
        end_op();
        return -1;
    }
    iunlock(ip);
    80004ef4:	8526                	mv	a0,s1
    80004ef6:	ffffe097          	auipc	ra,0xffffe
    80004efa:	e48080e7          	jalr	-440(ra) # 80002d3e <iunlock>
    iput(p->cwd);
    80004efe:	15093503          	ld	a0,336(s2)
    80004f02:	ffffe097          	auipc	ra,0xffffe
    80004f06:	f34080e7          	jalr	-204(ra) # 80002e36 <iput>
    end_op();
    80004f0a:	ffffe097          	auipc	ra,0xffffe
    80004f0e:	7bc080e7          	jalr	1980(ra) # 800036c6 <end_op>
    p->cwd = ip;
    80004f12:	14993823          	sd	s1,336(s2)
    return 0;
    80004f16:	4501                	li	a0,0
}
    80004f18:	60ea                	ld	ra,152(sp)
    80004f1a:	644a                	ld	s0,144(sp)
    80004f1c:	64aa                	ld	s1,136(sp)
    80004f1e:	690a                	ld	s2,128(sp)
    80004f20:	610d                	addi	sp,sp,160
    80004f22:	8082                	ret
        end_op();
    80004f24:	ffffe097          	auipc	ra,0xffffe
    80004f28:	7a2080e7          	jalr	1954(ra) # 800036c6 <end_op>
        return -1;
    80004f2c:	557d                	li	a0,-1
    80004f2e:	b7ed                	j	80004f18 <sys_chdir+0x7a>
        iunlockput(ip);
    80004f30:	8526                	mv	a0,s1
    80004f32:	ffffe097          	auipc	ra,0xffffe
    80004f36:	fac080e7          	jalr	-84(ra) # 80002ede <iunlockput>
        end_op();
    80004f3a:	ffffe097          	auipc	ra,0xffffe
    80004f3e:	78c080e7          	jalr	1932(ra) # 800036c6 <end_op>
        return -1;
    80004f42:	557d                	li	a0,-1
    80004f44:	bfd1                	j	80004f18 <sys_chdir+0x7a>

0000000080004f46 <sys_exec>:

uint64 sys_exec(void)
{
    80004f46:	7145                	addi	sp,sp,-464
    80004f48:	e786                	sd	ra,456(sp)
    80004f4a:	e3a2                	sd	s0,448(sp)
    80004f4c:	ff26                	sd	s1,440(sp)
    80004f4e:	fb4a                	sd	s2,432(sp)
    80004f50:	f74e                	sd	s3,424(sp)
    80004f52:	f352                	sd	s4,416(sp)
    80004f54:	ef56                	sd	s5,408(sp)
    80004f56:	0b80                	addi	s0,sp,464
    char path[MAXPATH], *argv[MAXARG];
    int i;
    uint64 uargv, uarg;

    argaddr(1, &uargv);
    80004f58:	e3840593          	addi	a1,s0,-456
    80004f5c:	4505                	li	a0,1
    80004f5e:	ffffd097          	auipc	ra,0xffffd
    80004f62:	1c6080e7          	jalr	454(ra) # 80002124 <argaddr>
    if (argstr(0, path, MAXPATH) < 0) {
    80004f66:	08000613          	li	a2,128
    80004f6a:	f4040593          	addi	a1,s0,-192
    80004f6e:	4501                	li	a0,0
    80004f70:	ffffd097          	auipc	ra,0xffffd
    80004f74:	1d4080e7          	jalr	468(ra) # 80002144 <argstr>
    80004f78:	87aa                	mv	a5,a0
        return -1;
    80004f7a:	557d                	li	a0,-1
    if (argstr(0, path, MAXPATH) < 0) {
    80004f7c:	0c07c363          	bltz	a5,80005042 <sys_exec+0xfc>
    }
    memset(argv, 0, sizeof(argv));
    80004f80:	10000613          	li	a2,256
    80004f84:	4581                	li	a1,0
    80004f86:	e4040513          	addi	a0,s0,-448
    80004f8a:	ffffb097          	auipc	ra,0xffffb
    80004f8e:	1f0080e7          	jalr	496(ra) # 8000017a <memset>
    for (i = 0;; i++) {
        if (i >= NELEM(argv)) {
    80004f92:	e4040493          	addi	s1,s0,-448
    memset(argv, 0, sizeof(argv));
    80004f96:	89a6                	mv	s3,s1
    80004f98:	4901                	li	s2,0
        if (i >= NELEM(argv)) {
    80004f9a:	02000a13          	li	s4,32
    80004f9e:	00090a9b          	sext.w	s5,s2
            goto bad;
        }
        if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    80004fa2:	00391513          	slli	a0,s2,0x3
    80004fa6:	e3040593          	addi	a1,s0,-464
    80004faa:	e3843783          	ld	a5,-456(s0)
    80004fae:	953e                	add	a0,a0,a5
    80004fb0:	ffffd097          	auipc	ra,0xffffd
    80004fb4:	0b6080e7          	jalr	182(ra) # 80002066 <fetchaddr>
    80004fb8:	02054a63          	bltz	a0,80004fec <sys_exec+0xa6>
            goto bad;
        }
        if (uarg == 0) {
    80004fbc:	e3043783          	ld	a5,-464(s0)
    80004fc0:	c3b9                	beqz	a5,80005006 <sys_exec+0xc0>
            argv[i] = 0;
            break;
        }
        argv[i] = kalloc();
    80004fc2:	ffffb097          	auipc	ra,0xffffb
    80004fc6:	158080e7          	jalr	344(ra) # 8000011a <kalloc>
    80004fca:	85aa                	mv	a1,a0
    80004fcc:	00a9b023          	sd	a0,0(s3)
        if (argv[i] == 0)
    80004fd0:	cd11                	beqz	a0,80004fec <sys_exec+0xa6>
            goto bad;
        if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004fd2:	6605                	lui	a2,0x1
    80004fd4:	e3043503          	ld	a0,-464(s0)
    80004fd8:	ffffd097          	auipc	ra,0xffffd
    80004fdc:	0e0080e7          	jalr	224(ra) # 800020b8 <fetchstr>
    80004fe0:	00054663          	bltz	a0,80004fec <sys_exec+0xa6>
        if (i >= NELEM(argv)) {
    80004fe4:	0905                	addi	s2,s2,1
    80004fe6:	09a1                	addi	s3,s3,8
    80004fe8:	fb491be3          	bne	s2,s4,80004f9e <sys_exec+0x58>
        kfree(argv[i]);

    return ret;

bad:
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fec:	f4040913          	addi	s2,s0,-192
    80004ff0:	6088                	ld	a0,0(s1)
    80004ff2:	c539                	beqz	a0,80005040 <sys_exec+0xfa>
        kfree(argv[i]);
    80004ff4:	ffffb097          	auipc	ra,0xffffb
    80004ff8:	028080e7          	jalr	40(ra) # 8000001c <kfree>
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ffc:	04a1                	addi	s1,s1,8
    80004ffe:	ff2499e3          	bne	s1,s2,80004ff0 <sys_exec+0xaa>
    return -1;
    80005002:	557d                	li	a0,-1
    80005004:	a83d                	j	80005042 <sys_exec+0xfc>
            argv[i] = 0;
    80005006:	0a8e                	slli	s5,s5,0x3
    80005008:	fc0a8793          	addi	a5,s5,-64
    8000500c:	00878ab3          	add	s5,a5,s0
    80005010:	e80ab023          	sd	zero,-384(s5)
    int ret = exec(path, argv);
    80005014:	e4040593          	addi	a1,s0,-448
    80005018:	f4040513          	addi	a0,s0,-192
    8000501c:	fffff097          	auipc	ra,0xfffff
    80005020:	16e080e7          	jalr	366(ra) # 8000418a <exec>
    80005024:	892a                	mv	s2,a0
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005026:	f4040993          	addi	s3,s0,-192
    8000502a:	6088                	ld	a0,0(s1)
    8000502c:	c901                	beqz	a0,8000503c <sys_exec+0xf6>
        kfree(argv[i]);
    8000502e:	ffffb097          	auipc	ra,0xffffb
    80005032:	fee080e7          	jalr	-18(ra) # 8000001c <kfree>
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005036:	04a1                	addi	s1,s1,8
    80005038:	ff3499e3          	bne	s1,s3,8000502a <sys_exec+0xe4>
    return ret;
    8000503c:	854a                	mv	a0,s2
    8000503e:	a011                	j	80005042 <sys_exec+0xfc>
    return -1;
    80005040:	557d                	li	a0,-1
}
    80005042:	60be                	ld	ra,456(sp)
    80005044:	641e                	ld	s0,448(sp)
    80005046:	74fa                	ld	s1,440(sp)
    80005048:	795a                	ld	s2,432(sp)
    8000504a:	79ba                	ld	s3,424(sp)
    8000504c:	7a1a                	ld	s4,416(sp)
    8000504e:	6afa                	ld	s5,408(sp)
    80005050:	6179                	addi	sp,sp,464
    80005052:	8082                	ret

0000000080005054 <sys_pipe>:

uint64 sys_pipe(void)
{
    80005054:	7139                	addi	sp,sp,-64
    80005056:	fc06                	sd	ra,56(sp)
    80005058:	f822                	sd	s0,48(sp)
    8000505a:	f426                	sd	s1,40(sp)
    8000505c:	0080                	addi	s0,sp,64
    uint64 fdarray; // user pointer to array of two integers
    struct file *rf, *wf;
    int fd0, fd1;
    struct proc *p = myproc();
    8000505e:	ffffc097          	auipc	ra,0xffffc
    80005062:	ddc080e7          	jalr	-548(ra) # 80000e3a <myproc>
    80005066:	84aa                	mv	s1,a0

    argaddr(0, &fdarray);
    80005068:	fd840593          	addi	a1,s0,-40
    8000506c:	4501                	li	a0,0
    8000506e:	ffffd097          	auipc	ra,0xffffd
    80005072:	0b6080e7          	jalr	182(ra) # 80002124 <argaddr>
    if (pipealloc(&rf, &wf) < 0)
    80005076:	fc840593          	addi	a1,s0,-56
    8000507a:	fd040513          	addi	a0,s0,-48
    8000507e:	fffff097          	auipc	ra,0xfffff
    80005082:	dc2080e7          	jalr	-574(ra) # 80003e40 <pipealloc>
        return -1;
    80005086:	57fd                	li	a5,-1
    if (pipealloc(&rf, &wf) < 0)
    80005088:	0c054463          	bltz	a0,80005150 <sys_pipe+0xfc>
    fd0 = -1;
    8000508c:	fcf42223          	sw	a5,-60(s0)
    if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    80005090:	fd043503          	ld	a0,-48(s0)
    80005094:	fffff097          	auipc	ra,0xfffff
    80005098:	514080e7          	jalr	1300(ra) # 800045a8 <fdalloc>
    8000509c:	fca42223          	sw	a0,-60(s0)
    800050a0:	08054b63          	bltz	a0,80005136 <sys_pipe+0xe2>
    800050a4:	fc843503          	ld	a0,-56(s0)
    800050a8:	fffff097          	auipc	ra,0xfffff
    800050ac:	500080e7          	jalr	1280(ra) # 800045a8 <fdalloc>
    800050b0:	fca42023          	sw	a0,-64(s0)
    800050b4:	06054863          	bltz	a0,80005124 <sys_pipe+0xd0>
            p->ofile[fd0] = 0;
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 || copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0) {
    800050b8:	4691                	li	a3,4
    800050ba:	fc440613          	addi	a2,s0,-60
    800050be:	fd843583          	ld	a1,-40(s0)
    800050c2:	68a8                	ld	a0,80(s1)
    800050c4:	ffffc097          	auipc	ra,0xffffc
    800050c8:	a36080e7          	jalr	-1482(ra) # 80000afa <copyout>
    800050cc:	02054063          	bltz	a0,800050ec <sys_pipe+0x98>
    800050d0:	4691                	li	a3,4
    800050d2:	fc040613          	addi	a2,s0,-64
    800050d6:	fd843583          	ld	a1,-40(s0)
    800050da:	0591                	addi	a1,a1,4
    800050dc:	68a8                	ld	a0,80(s1)
    800050de:	ffffc097          	auipc	ra,0xffffc
    800050e2:	a1c080e7          	jalr	-1508(ra) # 80000afa <copyout>
        p->ofile[fd1] = 0;
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    return 0;
    800050e6:	4781                	li	a5,0
    if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 || copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0) {
    800050e8:	06055463          	bgez	a0,80005150 <sys_pipe+0xfc>
        p->ofile[fd0] = 0;
    800050ec:	fc442783          	lw	a5,-60(s0)
    800050f0:	07e9                	addi	a5,a5,26
    800050f2:	078e                	slli	a5,a5,0x3
    800050f4:	97a6                	add	a5,a5,s1
    800050f6:	0007b023          	sd	zero,0(a5)
        p->ofile[fd1] = 0;
    800050fa:	fc042783          	lw	a5,-64(s0)
    800050fe:	07e9                	addi	a5,a5,26
    80005100:	078e                	slli	a5,a5,0x3
    80005102:	94be                	add	s1,s1,a5
    80005104:	0004b023          	sd	zero,0(s1)
        fileclose(rf);
    80005108:	fd043503          	ld	a0,-48(s0)
    8000510c:	fffff097          	auipc	ra,0xfffff
    80005110:	a04080e7          	jalr	-1532(ra) # 80003b10 <fileclose>
        fileclose(wf);
    80005114:	fc843503          	ld	a0,-56(s0)
    80005118:	fffff097          	auipc	ra,0xfffff
    8000511c:	9f8080e7          	jalr	-1544(ra) # 80003b10 <fileclose>
        return -1;
    80005120:	57fd                	li	a5,-1
    80005122:	a03d                	j	80005150 <sys_pipe+0xfc>
        if (fd0 >= 0)
    80005124:	fc442783          	lw	a5,-60(s0)
    80005128:	0007c763          	bltz	a5,80005136 <sys_pipe+0xe2>
            p->ofile[fd0] = 0;
    8000512c:	07e9                	addi	a5,a5,26
    8000512e:	078e                	slli	a5,a5,0x3
    80005130:	97a6                	add	a5,a5,s1
    80005132:	0007b023          	sd	zero,0(a5)
        fileclose(rf);
    80005136:	fd043503          	ld	a0,-48(s0)
    8000513a:	fffff097          	auipc	ra,0xfffff
    8000513e:	9d6080e7          	jalr	-1578(ra) # 80003b10 <fileclose>
        fileclose(wf);
    80005142:	fc843503          	ld	a0,-56(s0)
    80005146:	fffff097          	auipc	ra,0xfffff
    8000514a:	9ca080e7          	jalr	-1590(ra) # 80003b10 <fileclose>
        return -1;
    8000514e:	57fd                	li	a5,-1
}
    80005150:	853e                	mv	a0,a5
    80005152:	70e2                	ld	ra,56(sp)
    80005154:	7442                	ld	s0,48(sp)
    80005156:	74a2                	ld	s1,40(sp)
    80005158:	6121                	addi	sp,sp,64
    8000515a:	8082                	ret

000000008000515c <sys_mmap>:

uint64 sys_mmap(void)
{
    8000515c:	711d                	addi	sp,sp,-96
    8000515e:	ec86                	sd	ra,88(sp)
    80005160:	e8a2                	sd	s0,80(sp)
    80005162:	e4a6                	sd	s1,72(sp)
    80005164:	e0ca                	sd	s2,64(sp)
    80005166:	fc4e                	sd	s3,56(sp)
    80005168:	1080                	addi	s0,sp,96
    int length, prot, flags, fd, offset;
    uint64 addr;
    struct file *fp;

    struct proc *p = myproc();
    8000516a:	ffffc097          	auipc	ra,0xffffc
    8000516e:	cd0080e7          	jalr	-816(ra) # 80000e3a <myproc>
    80005172:	892a                	mv	s2,a0
    // 传入参数处理
    argaddr(0, &addr);
    80005174:	fb040593          	addi	a1,s0,-80
    80005178:	4501                	li	a0,0
    8000517a:	ffffd097          	auipc	ra,0xffffd
    8000517e:	faa080e7          	jalr	-86(ra) # 80002124 <argaddr>
    argint(1, &length);
    80005182:	fcc40593          	addi	a1,s0,-52
    80005186:	4505                	li	a0,1
    80005188:	ffffd097          	auipc	ra,0xffffd
    8000518c:	f7c080e7          	jalr	-132(ra) # 80002104 <argint>
    argint(2, &prot);
    80005190:	fc840593          	addi	a1,s0,-56
    80005194:	4509                	li	a0,2
    80005196:	ffffd097          	auipc	ra,0xffffd
    8000519a:	f6e080e7          	jalr	-146(ra) # 80002104 <argint>
    argint(3, &flags);
    8000519e:	fc440593          	addi	a1,s0,-60
    800051a2:	450d                	li	a0,3
    800051a4:	ffffd097          	auipc	ra,0xffffd
    800051a8:	f60080e7          	jalr	-160(ra) # 80002104 <argint>
    argfd(4, &fd, &fp);
    800051ac:	fa840613          	addi	a2,s0,-88
    800051b0:	fc040593          	addi	a1,s0,-64
    800051b4:	4511                	li	a0,4
    800051b6:	fffff097          	auipc	ra,0xfffff
    800051ba:	392080e7          	jalr	914(ra) # 80004548 <argfd>
    argint(5, &offset);
    800051be:	fbc40593          	addi	a1,s0,-68
    800051c2:	4515                	li	a0,5
    800051c4:	ffffd097          	auipc	ra,0xffffd
    800051c8:	f40080e7          	jalr	-192(ra) # 80002104 <argint>

    // 参数检查
    if (!(fp->writable) && (prot & PROT_WRITE) && (flags == MAP_SHARED)) {
    800051cc:	fa843583          	ld	a1,-88(s0)
    800051d0:	0095c783          	lbu	a5,9(a1)
    800051d4:	eb91                	bnez	a5,800051e8 <sys_mmap+0x8c>
    800051d6:	fc842783          	lw	a5,-56(s0)
    800051da:	8b89                	andi	a5,a5,2
    800051dc:	c791                	beqz	a5,800051e8 <sys_mmap+0x8c>
    800051de:	fc442703          	lw	a4,-60(s0)
    800051e2:	4785                	li	a5,1
    800051e4:	0af70963          	beq	a4,a5,80005296 <sys_mmap+0x13a>
        // 权限冲突，无法写入
        return -1;
    }

    length = PGROUNDUP(length);
    800051e8:	fcc42783          	lw	a5,-52(s0)
    800051ec:	6685                	lui	a3,0x1
    800051ee:	36fd                	addiw	a3,a3,-1 # fff <_entry-0x7ffff001>
    800051f0:	9ebd                	addw	a3,a3,a5
    800051f2:	77fd                	lui	a5,0xfffff
    800051f4:	8efd                	and	a3,a3,a5
    800051f6:	2681                	sext.w	a3,a3
    800051f8:	fcd42623          	sw	a3,-52(s0)
    if (p->sz + length > MAXVA) {
    800051fc:	04893803          	ld	a6,72(s2)
    80005200:	01068733          	add	a4,a3,a6
    80005204:	4785                	li	a5,1
    80005206:	179a                	slli	a5,a5,0x26
        return -1;
    80005208:	557d                	li	a0,-1
    if (p->sz + length > MAXVA) {
    8000520a:	00e7ee63          	bltu	a5,a4,80005226 <sys_mmap+0xca>
    8000520e:	16890793          	addi	a5,s2,360
    }

    for (int i = 0; i < VMASIZE; i++) {
    80005212:	4481                	li	s1,0
    80005214:	4641                	li	a2,16
        if (p->vma[i].used == 0) {
    80005216:	4398                	lw	a4,0(a5)
    80005218:	cf11                	beqz	a4,80005234 <sys_mmap+0xd8>
    for (int i = 0; i < VMASIZE; i++) {
    8000521a:	2485                	addiw	s1,s1,1
    8000521c:	03078793          	addi	a5,a5,48 # fffffffffffff030 <end+0xffffffff7ffd12f0>
    80005220:	fec49be3          	bne	s1,a2,80005216 <sys_mmap+0xba>

            // 返回值应当是映射的虚拟地址
            return p->vma[i].addr;
        }
    }
    return -1;
    80005224:	557d                	li	a0,-1
}
    80005226:	60e6                	ld	ra,88(sp)
    80005228:	6446                	ld	s0,80(sp)
    8000522a:	64a6                	ld	s1,72(sp)
    8000522c:	6906                	ld	s2,64(sp)
    8000522e:	79e2                	ld	s3,56(sp)
    80005230:	6125                	addi	sp,sp,96
    80005232:	8082                	ret
            p->vma[i].used = 1;
    80005234:	00149993          	slli	s3,s1,0x1
    80005238:	009987b3          	add	a5,s3,s1
    8000523c:	0792                	slli	a5,a5,0x4
    8000523e:	97ca                	add	a5,a5,s2
    80005240:	4705                	li	a4,1
    80005242:	16e7a423          	sw	a4,360(a5)
            p->vma[i].addr = p->sz;
    80005246:	1707b823          	sd	a6,368(a5)
            p->vma[i].length = length;
    8000524a:	16d7ac23          	sw	a3,376(a5)
            p->vma[i].prot = prot;
    8000524e:	fc842703          	lw	a4,-56(s0)
    80005252:	16e7ae23          	sw	a4,380(a5)
            p->vma[i].flags = flags;
    80005256:	fc442703          	lw	a4,-60(s0)
    8000525a:	18e7a023          	sw	a4,384(a5)
            p->vma[i].fd = fd;
    8000525e:	fc042703          	lw	a4,-64(s0)
    80005262:	18e7a223          	sw	a4,388(a5)
            p->vma[i].fp = fp;
    80005266:	18b7b823          	sd	a1,400(a5)
            p->vma[i].offset = offset;
    8000526a:	fbc42703          	lw	a4,-68(s0)
    8000526e:	18e7a423          	sw	a4,392(a5)
            filedup(fp);
    80005272:	852e                	mv	a0,a1
    80005274:	fffff097          	auipc	ra,0xfffff
    80005278:	84a080e7          	jalr	-1974(ra) # 80003abe <filedup>
            p->sz += length;
    8000527c:	fcc42703          	lw	a4,-52(s0)
    80005280:	04893783          	ld	a5,72(s2)
    80005284:	97ba                	add	a5,a5,a4
    80005286:	04f93423          	sd	a5,72(s2)
            return p->vma[i].addr;
    8000528a:	99a6                	add	s3,s3,s1
    8000528c:	0992                	slli	s3,s3,0x4
    8000528e:	994e                	add	s2,s2,s3
    80005290:	17093503          	ld	a0,368(s2)
    80005294:	bf49                	j	80005226 <sys_mmap+0xca>
        return -1;
    80005296:	557d                	li	a0,-1
    80005298:	b779                	j	80005226 <sys_mmap+0xca>

000000008000529a <sys_munmap>:

uint64 sys_munmap(void)
{
    8000529a:	7139                	addi	sp,sp,-64
    8000529c:	fc06                	sd	ra,56(sp)
    8000529e:	f822                	sd	s0,48(sp)
    800052a0:	f426                	sd	s1,40(sp)
    800052a2:	f04a                	sd	s2,32(sp)
    800052a4:	ec4e                	sd	s3,24(sp)
    800052a6:	0080                	addi	s0,sp,64
    int length;
    uint64 addr;
    argaddr(0, &addr);
    800052a8:	fc040593          	addi	a1,s0,-64
    800052ac:	4501                	li	a0,0
    800052ae:	ffffd097          	auipc	ra,0xffffd
    800052b2:	e76080e7          	jalr	-394(ra) # 80002124 <argaddr>
    argint(1, &length);
    800052b6:	fcc40593          	addi	a1,s0,-52
    800052ba:	4505                	li	a0,1
    800052bc:	ffffd097          	auipc	ra,0xffffd
    800052c0:	e48080e7          	jalr	-440(ra) # 80002104 <argint>

    struct proc *p = myproc();
    800052c4:	ffffc097          	auipc	ra,0xffffc
    800052c8:	b76080e7          	jalr	-1162(ra) # 80000e3a <myproc>
    800052cc:	892a                	mv	s2,a0
    struct VMA *vma = 0;
    for (int i = 0; i < VMASIZE; i++) {
        // 找到对应的VMA
        if (p->vma[i].used) {
            if (addr == p->vma[i].addr) {
    800052ce:	fc043583          	ld	a1,-64(s0)
    800052d2:	16850793          	addi	a5,a0,360
    for (int i = 0; i < VMASIZE; i++) {
    800052d6:	4481                	li	s1,0
    800052d8:	46c1                	li	a3,16
    800052da:	a031                	j	800052e6 <sys_munmap+0x4c>
    800052dc:	2485                	addiw	s1,s1,1
    800052de:	03078793          	addi	a5,a5,48
    800052e2:	06d48663          	beq	s1,a3,8000534e <sys_munmap+0xb4>
        if (p->vma[i].used) {
    800052e6:	4398                	lw	a4,0(a5)
    800052e8:	db75                	beqz	a4,800052dc <sys_munmap+0x42>
            if (addr == p->vma[i].addr) {
    800052ea:	6798                	ld	a4,8(a5)
    800052ec:	feb718e3          	bne	a4,a1,800052dc <sys_munmap+0x42>

    if (vma == 0) {
        return 0;
    }
    else {
        vma->addr += length;
    800052f0:	fcc42603          	lw	a2,-52(s0)
    800052f4:	00149793          	slli	a5,s1,0x1
    800052f8:	97a6                	add	a5,a5,s1
    800052fa:	0792                	slli	a5,a5,0x4
    800052fc:	97ca                	add	a5,a5,s2
    800052fe:	1707b703          	ld	a4,368(a5)
    80005302:	9732                	add	a4,a4,a2
    80005304:	16e7b823          	sd	a4,368(a5)
        vma->length -= length;
    80005308:	1787a703          	lw	a4,376(a5)
    8000530c:	9f11                	subw	a4,a4,a2
    8000530e:	16e7ac23          	sw	a4,376(a5)
        if (vma->flags & MAP_SHARED)
    80005312:	1807a783          	lw	a5,384(a5)
    80005316:	8b85                	andi	a5,a5,1
    80005318:	e3b9                	bnez	a5,8000535e <sys_munmap+0xc4>
            // 如果是共享映射，需要把文件内容写回
            filewrite(vma->fp, addr, length);

        uvmunmap(p->pagetable, addr, length / PGSIZE, 1);
    8000531a:	fcc42783          	lw	a5,-52(s0)
    8000531e:	41f7d61b          	sraiw	a2,a5,0x1f
    80005322:	0146561b          	srliw	a2,a2,0x14
    80005326:	9e3d                	addw	a2,a2,a5
    80005328:	4685                	li	a3,1
    8000532a:	40c6561b          	sraiw	a2,a2,0xc
    8000532e:	fc043583          	ld	a1,-64(s0)
    80005332:	05093503          	ld	a0,80(s2)
    80005336:	ffffb097          	auipc	ra,0xffffb
    8000533a:	3d6080e7          	jalr	982(ra) # 8000070c <uvmunmap>
        if (vma->length == 0) {
    8000533e:	00149793          	slli	a5,s1,0x1
    80005342:	97a6                	add	a5,a5,s1
    80005344:	0792                	slli	a5,a5,0x4
    80005346:	97ca                	add	a5,a5,s2
    80005348:	1787a783          	lw	a5,376(a5)
    8000534c:	c78d                	beqz	a5,80005376 <sys_munmap+0xdc>
            fileclose(vma->fp);
            vma->used = 0;
        }
        return 0;
    }
}
    8000534e:	4501                	li	a0,0
    80005350:	70e2                	ld	ra,56(sp)
    80005352:	7442                	ld	s0,48(sp)
    80005354:	74a2                	ld	s1,40(sp)
    80005356:	7902                	ld	s2,32(sp)
    80005358:	69e2                	ld	s3,24(sp)
    8000535a:	6121                	addi	sp,sp,64
    8000535c:	8082                	ret
            filewrite(vma->fp, addr, length);
    8000535e:	00149793          	slli	a5,s1,0x1
    80005362:	97a6                	add	a5,a5,s1
    80005364:	0792                	slli	a5,a5,0x4
    80005366:	97ca                	add	a5,a5,s2
    80005368:	1907b503          	ld	a0,400(a5)
    8000536c:	fffff097          	auipc	ra,0xfffff
    80005370:	9a0080e7          	jalr	-1632(ra) # 80003d0c <filewrite>
    80005374:	b75d                	j	8000531a <sys_munmap+0x80>
            fileclose(vma->fp);
    80005376:	00149993          	slli	s3,s1,0x1
    8000537a:	009987b3          	add	a5,s3,s1
    8000537e:	0792                	slli	a5,a5,0x4
    80005380:	97ca                	add	a5,a5,s2
    80005382:	1907b503          	ld	a0,400(a5)
    80005386:	ffffe097          	auipc	ra,0xffffe
    8000538a:	78a080e7          	jalr	1930(ra) # 80003b10 <fileclose>
            vma->used = 0;
    8000538e:	99a6                	add	s3,s3,s1
    80005390:	0992                	slli	s3,s3,0x4
    80005392:	994e                	add	s2,s2,s3
    80005394:	16092423          	sw	zero,360(s2)
    80005398:	bf5d                	j	8000534e <sys_munmap+0xb4>
    8000539a:	0000                	unimp
    8000539c:	0000                	unimp
	...

00000000800053a0 <kernelvec>:
    800053a0:	7111                	addi	sp,sp,-256
    800053a2:	e006                	sd	ra,0(sp)
    800053a4:	e40a                	sd	sp,8(sp)
    800053a6:	e80e                	sd	gp,16(sp)
    800053a8:	ec12                	sd	tp,24(sp)
    800053aa:	f016                	sd	t0,32(sp)
    800053ac:	f41a                	sd	t1,40(sp)
    800053ae:	f81e                	sd	t2,48(sp)
    800053b0:	fc22                	sd	s0,56(sp)
    800053b2:	e0a6                	sd	s1,64(sp)
    800053b4:	e4aa                	sd	a0,72(sp)
    800053b6:	e8ae                	sd	a1,80(sp)
    800053b8:	ecb2                	sd	a2,88(sp)
    800053ba:	f0b6                	sd	a3,96(sp)
    800053bc:	f4ba                	sd	a4,104(sp)
    800053be:	f8be                	sd	a5,112(sp)
    800053c0:	fcc2                	sd	a6,120(sp)
    800053c2:	e146                	sd	a7,128(sp)
    800053c4:	e54a                	sd	s2,136(sp)
    800053c6:	e94e                	sd	s3,144(sp)
    800053c8:	ed52                	sd	s4,152(sp)
    800053ca:	f156                	sd	s5,160(sp)
    800053cc:	f55a                	sd	s6,168(sp)
    800053ce:	f95e                	sd	s7,176(sp)
    800053d0:	fd62                	sd	s8,184(sp)
    800053d2:	e1e6                	sd	s9,192(sp)
    800053d4:	e5ea                	sd	s10,200(sp)
    800053d6:	e9ee                	sd	s11,208(sp)
    800053d8:	edf2                	sd	t3,216(sp)
    800053da:	f1f6                	sd	t4,224(sp)
    800053dc:	f5fa                	sd	t5,232(sp)
    800053de:	f9fe                	sd	t6,240(sp)
    800053e0:	b53fc0ef          	jal	ra,80001f32 <kerneltrap>
    800053e4:	6082                	ld	ra,0(sp)
    800053e6:	6122                	ld	sp,8(sp)
    800053e8:	61c2                	ld	gp,16(sp)
    800053ea:	7282                	ld	t0,32(sp)
    800053ec:	7322                	ld	t1,40(sp)
    800053ee:	73c2                	ld	t2,48(sp)
    800053f0:	7462                	ld	s0,56(sp)
    800053f2:	6486                	ld	s1,64(sp)
    800053f4:	6526                	ld	a0,72(sp)
    800053f6:	65c6                	ld	a1,80(sp)
    800053f8:	6666                	ld	a2,88(sp)
    800053fa:	7686                	ld	a3,96(sp)
    800053fc:	7726                	ld	a4,104(sp)
    800053fe:	77c6                	ld	a5,112(sp)
    80005400:	7866                	ld	a6,120(sp)
    80005402:	688a                	ld	a7,128(sp)
    80005404:	692a                	ld	s2,136(sp)
    80005406:	69ca                	ld	s3,144(sp)
    80005408:	6a6a                	ld	s4,152(sp)
    8000540a:	7a8a                	ld	s5,160(sp)
    8000540c:	7b2a                	ld	s6,168(sp)
    8000540e:	7bca                	ld	s7,176(sp)
    80005410:	7c6a                	ld	s8,184(sp)
    80005412:	6c8e                	ld	s9,192(sp)
    80005414:	6d2e                	ld	s10,200(sp)
    80005416:	6dce                	ld	s11,208(sp)
    80005418:	6e6e                	ld	t3,216(sp)
    8000541a:	7e8e                	ld	t4,224(sp)
    8000541c:	7f2e                	ld	t5,232(sp)
    8000541e:	7fce                	ld	t6,240(sp)
    80005420:	6111                	addi	sp,sp,256
    80005422:	10200073          	sret
    80005426:	00000013          	nop
    8000542a:	00000013          	nop
    8000542e:	0001                	nop

0000000080005430 <timervec>:
    80005430:	34051573          	csrrw	a0,mscratch,a0
    80005434:	e10c                	sd	a1,0(a0)
    80005436:	e510                	sd	a2,8(a0)
    80005438:	e914                	sd	a3,16(a0)
    8000543a:	6d0c                	ld	a1,24(a0)
    8000543c:	7110                	ld	a2,32(a0)
    8000543e:	6194                	ld	a3,0(a1)
    80005440:	96b2                	add	a3,a3,a2
    80005442:	e194                	sd	a3,0(a1)
    80005444:	4589                	li	a1,2
    80005446:	14459073          	csrw	sip,a1
    8000544a:	6914                	ld	a3,16(a0)
    8000544c:	6510                	ld	a2,8(a0)
    8000544e:	610c                	ld	a1,0(a0)
    80005450:	34051573          	csrrw	a0,mscratch,a0
    80005454:	30200073          	mret
	...

000000008000545a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000545a:	1141                	addi	sp,sp,-16
    8000545c:	e422                	sd	s0,8(sp)
    8000545e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005460:	0c0007b7          	lui	a5,0xc000
    80005464:	4705                	li	a4,1
    80005466:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005468:	c3d8                	sw	a4,4(a5)
}
    8000546a:	6422                	ld	s0,8(sp)
    8000546c:	0141                	addi	sp,sp,16
    8000546e:	8082                	ret

0000000080005470 <plicinithart>:

void
plicinithart(void)
{
    80005470:	1141                	addi	sp,sp,-16
    80005472:	e406                	sd	ra,8(sp)
    80005474:	e022                	sd	s0,0(sp)
    80005476:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005478:	ffffc097          	auipc	ra,0xffffc
    8000547c:	996080e7          	jalr	-1642(ra) # 80000e0e <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005480:	0085171b          	slliw	a4,a0,0x8
    80005484:	0c0027b7          	lui	a5,0xc002
    80005488:	97ba                	add	a5,a5,a4
    8000548a:	40200713          	li	a4,1026
    8000548e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005492:	00d5151b          	slliw	a0,a0,0xd
    80005496:	0c2017b7          	lui	a5,0xc201
    8000549a:	97aa                	add	a5,a5,a0
    8000549c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800054a0:	60a2                	ld	ra,8(sp)
    800054a2:	6402                	ld	s0,0(sp)
    800054a4:	0141                	addi	sp,sp,16
    800054a6:	8082                	ret

00000000800054a8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800054a8:	1141                	addi	sp,sp,-16
    800054aa:	e406                	sd	ra,8(sp)
    800054ac:	e022                	sd	s0,0(sp)
    800054ae:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800054b0:	ffffc097          	auipc	ra,0xffffc
    800054b4:	95e080e7          	jalr	-1698(ra) # 80000e0e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800054b8:	00d5151b          	slliw	a0,a0,0xd
    800054bc:	0c2017b7          	lui	a5,0xc201
    800054c0:	97aa                	add	a5,a5,a0
  return irq;
}
    800054c2:	43c8                	lw	a0,4(a5)
    800054c4:	60a2                	ld	ra,8(sp)
    800054c6:	6402                	ld	s0,0(sp)
    800054c8:	0141                	addi	sp,sp,16
    800054ca:	8082                	ret

00000000800054cc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800054cc:	1101                	addi	sp,sp,-32
    800054ce:	ec06                	sd	ra,24(sp)
    800054d0:	e822                	sd	s0,16(sp)
    800054d2:	e426                	sd	s1,8(sp)
    800054d4:	1000                	addi	s0,sp,32
    800054d6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800054d8:	ffffc097          	auipc	ra,0xffffc
    800054dc:	936080e7          	jalr	-1738(ra) # 80000e0e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800054e0:	00d5151b          	slliw	a0,a0,0xd
    800054e4:	0c2017b7          	lui	a5,0xc201
    800054e8:	97aa                	add	a5,a5,a0
    800054ea:	c3c4                	sw	s1,4(a5)
}
    800054ec:	60e2                	ld	ra,24(sp)
    800054ee:	6442                	ld	s0,16(sp)
    800054f0:	64a2                	ld	s1,8(sp)
    800054f2:	6105                	addi	sp,sp,32
    800054f4:	8082                	ret

00000000800054f6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800054f6:	1141                	addi	sp,sp,-16
    800054f8:	e406                	sd	ra,8(sp)
    800054fa:	e022                	sd	s0,0(sp)
    800054fc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800054fe:	479d                	li	a5,7
    80005500:	04a7cc63          	blt	a5,a0,80005558 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005504:	00020797          	auipc	a5,0x20
    80005508:	4bc78793          	addi	a5,a5,1212 # 800259c0 <disk>
    8000550c:	97aa                	add	a5,a5,a0
    8000550e:	0187c783          	lbu	a5,24(a5)
    80005512:	ebb9                	bnez	a5,80005568 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005514:	00451693          	slli	a3,a0,0x4
    80005518:	00020797          	auipc	a5,0x20
    8000551c:	4a878793          	addi	a5,a5,1192 # 800259c0 <disk>
    80005520:	6398                	ld	a4,0(a5)
    80005522:	9736                	add	a4,a4,a3
    80005524:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005528:	6398                	ld	a4,0(a5)
    8000552a:	9736                	add	a4,a4,a3
    8000552c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005530:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005534:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005538:	97aa                	add	a5,a5,a0
    8000553a:	4705                	li	a4,1
    8000553c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005540:	00020517          	auipc	a0,0x20
    80005544:	49850513          	addi	a0,a0,1176 # 800259d8 <disk+0x18>
    80005548:	ffffc097          	auipc	ra,0xffffc
    8000554c:	038080e7          	jalr	56(ra) # 80001580 <wakeup>
}
    80005550:	60a2                	ld	ra,8(sp)
    80005552:	6402                	ld	s0,0(sp)
    80005554:	0141                	addi	sp,sp,16
    80005556:	8082                	ret
    panic("free_desc 1");
    80005558:	00003517          	auipc	a0,0x3
    8000555c:	15050513          	addi	a0,a0,336 # 800086a8 <syscalls+0x300>
    80005560:	00001097          	auipc	ra,0x1
    80005564:	a0c080e7          	jalr	-1524(ra) # 80005f6c <panic>
    panic("free_desc 2");
    80005568:	00003517          	auipc	a0,0x3
    8000556c:	15050513          	addi	a0,a0,336 # 800086b8 <syscalls+0x310>
    80005570:	00001097          	auipc	ra,0x1
    80005574:	9fc080e7          	jalr	-1540(ra) # 80005f6c <panic>

0000000080005578 <virtio_disk_init>:
{
    80005578:	1101                	addi	sp,sp,-32
    8000557a:	ec06                	sd	ra,24(sp)
    8000557c:	e822                	sd	s0,16(sp)
    8000557e:	e426                	sd	s1,8(sp)
    80005580:	e04a                	sd	s2,0(sp)
    80005582:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005584:	00003597          	auipc	a1,0x3
    80005588:	14458593          	addi	a1,a1,324 # 800086c8 <syscalls+0x320>
    8000558c:	00020517          	auipc	a0,0x20
    80005590:	55c50513          	addi	a0,a0,1372 # 80025ae8 <disk+0x128>
    80005594:	00001097          	auipc	ra,0x1
    80005598:	e80080e7          	jalr	-384(ra) # 80006414 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000559c:	100017b7          	lui	a5,0x10001
    800055a0:	4398                	lw	a4,0(a5)
    800055a2:	2701                	sext.w	a4,a4
    800055a4:	747277b7          	lui	a5,0x74727
    800055a8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800055ac:	14f71b63          	bne	a4,a5,80005702 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800055b0:	100017b7          	lui	a5,0x10001
    800055b4:	43dc                	lw	a5,4(a5)
    800055b6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055b8:	4709                	li	a4,2
    800055ba:	14e79463          	bne	a5,a4,80005702 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800055be:	100017b7          	lui	a5,0x10001
    800055c2:	479c                	lw	a5,8(a5)
    800055c4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800055c6:	12e79e63          	bne	a5,a4,80005702 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800055ca:	100017b7          	lui	a5,0x10001
    800055ce:	47d8                	lw	a4,12(a5)
    800055d0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800055d2:	554d47b7          	lui	a5,0x554d4
    800055d6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800055da:	12f71463          	bne	a4,a5,80005702 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800055de:	100017b7          	lui	a5,0x10001
    800055e2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800055e6:	4705                	li	a4,1
    800055e8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055ea:	470d                	li	a4,3
    800055ec:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800055ee:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800055f0:	c7ffe6b7          	lui	a3,0xc7ffe
    800055f4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd0a1f>
    800055f8:	8f75                	and	a4,a4,a3
    800055fa:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055fc:	472d                	li	a4,11
    800055fe:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005600:	5bbc                	lw	a5,112(a5)
    80005602:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005606:	8ba1                	andi	a5,a5,8
    80005608:	10078563          	beqz	a5,80005712 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000560c:	100017b7          	lui	a5,0x10001
    80005610:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005614:	43fc                	lw	a5,68(a5)
    80005616:	2781                	sext.w	a5,a5
    80005618:	10079563          	bnez	a5,80005722 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000561c:	100017b7          	lui	a5,0x10001
    80005620:	5bdc                	lw	a5,52(a5)
    80005622:	2781                	sext.w	a5,a5
  if(max == 0)
    80005624:	10078763          	beqz	a5,80005732 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005628:	471d                	li	a4,7
    8000562a:	10f77c63          	bgeu	a4,a5,80005742 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000562e:	ffffb097          	auipc	ra,0xffffb
    80005632:	aec080e7          	jalr	-1300(ra) # 8000011a <kalloc>
    80005636:	00020497          	auipc	s1,0x20
    8000563a:	38a48493          	addi	s1,s1,906 # 800259c0 <disk>
    8000563e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005640:	ffffb097          	auipc	ra,0xffffb
    80005644:	ada080e7          	jalr	-1318(ra) # 8000011a <kalloc>
    80005648:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000564a:	ffffb097          	auipc	ra,0xffffb
    8000564e:	ad0080e7          	jalr	-1328(ra) # 8000011a <kalloc>
    80005652:	87aa                	mv	a5,a0
    80005654:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005656:	6088                	ld	a0,0(s1)
    80005658:	cd6d                	beqz	a0,80005752 <virtio_disk_init+0x1da>
    8000565a:	00020717          	auipc	a4,0x20
    8000565e:	36e73703          	ld	a4,878(a4) # 800259c8 <disk+0x8>
    80005662:	cb65                	beqz	a4,80005752 <virtio_disk_init+0x1da>
    80005664:	c7fd                	beqz	a5,80005752 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005666:	6605                	lui	a2,0x1
    80005668:	4581                	li	a1,0
    8000566a:	ffffb097          	auipc	ra,0xffffb
    8000566e:	b10080e7          	jalr	-1264(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    80005672:	00020497          	auipc	s1,0x20
    80005676:	34e48493          	addi	s1,s1,846 # 800259c0 <disk>
    8000567a:	6605                	lui	a2,0x1
    8000567c:	4581                	li	a1,0
    8000567e:	6488                	ld	a0,8(s1)
    80005680:	ffffb097          	auipc	ra,0xffffb
    80005684:	afa080e7          	jalr	-1286(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    80005688:	6605                	lui	a2,0x1
    8000568a:	4581                	li	a1,0
    8000568c:	6888                	ld	a0,16(s1)
    8000568e:	ffffb097          	auipc	ra,0xffffb
    80005692:	aec080e7          	jalr	-1300(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005696:	100017b7          	lui	a5,0x10001
    8000569a:	4721                	li	a4,8
    8000569c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000569e:	4098                	lw	a4,0(s1)
    800056a0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800056a4:	40d8                	lw	a4,4(s1)
    800056a6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800056aa:	6498                	ld	a4,8(s1)
    800056ac:	0007069b          	sext.w	a3,a4
    800056b0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800056b4:	9701                	srai	a4,a4,0x20
    800056b6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800056ba:	6898                	ld	a4,16(s1)
    800056bc:	0007069b          	sext.w	a3,a4
    800056c0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800056c4:	9701                	srai	a4,a4,0x20
    800056c6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800056ca:	4705                	li	a4,1
    800056cc:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800056ce:	00e48c23          	sb	a4,24(s1)
    800056d2:	00e48ca3          	sb	a4,25(s1)
    800056d6:	00e48d23          	sb	a4,26(s1)
    800056da:	00e48da3          	sb	a4,27(s1)
    800056de:	00e48e23          	sb	a4,28(s1)
    800056e2:	00e48ea3          	sb	a4,29(s1)
    800056e6:	00e48f23          	sb	a4,30(s1)
    800056ea:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800056ee:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800056f2:	0727a823          	sw	s2,112(a5)
}
    800056f6:	60e2                	ld	ra,24(sp)
    800056f8:	6442                	ld	s0,16(sp)
    800056fa:	64a2                	ld	s1,8(sp)
    800056fc:	6902                	ld	s2,0(sp)
    800056fe:	6105                	addi	sp,sp,32
    80005700:	8082                	ret
    panic("could not find virtio disk");
    80005702:	00003517          	auipc	a0,0x3
    80005706:	fd650513          	addi	a0,a0,-42 # 800086d8 <syscalls+0x330>
    8000570a:	00001097          	auipc	ra,0x1
    8000570e:	862080e7          	jalr	-1950(ra) # 80005f6c <panic>
    panic("virtio disk FEATURES_OK unset");
    80005712:	00003517          	auipc	a0,0x3
    80005716:	fe650513          	addi	a0,a0,-26 # 800086f8 <syscalls+0x350>
    8000571a:	00001097          	auipc	ra,0x1
    8000571e:	852080e7          	jalr	-1966(ra) # 80005f6c <panic>
    panic("virtio disk should not be ready");
    80005722:	00003517          	auipc	a0,0x3
    80005726:	ff650513          	addi	a0,a0,-10 # 80008718 <syscalls+0x370>
    8000572a:	00001097          	auipc	ra,0x1
    8000572e:	842080e7          	jalr	-1982(ra) # 80005f6c <panic>
    panic("virtio disk has no queue 0");
    80005732:	00003517          	auipc	a0,0x3
    80005736:	00650513          	addi	a0,a0,6 # 80008738 <syscalls+0x390>
    8000573a:	00001097          	auipc	ra,0x1
    8000573e:	832080e7          	jalr	-1998(ra) # 80005f6c <panic>
    panic("virtio disk max queue too short");
    80005742:	00003517          	auipc	a0,0x3
    80005746:	01650513          	addi	a0,a0,22 # 80008758 <syscalls+0x3b0>
    8000574a:	00001097          	auipc	ra,0x1
    8000574e:	822080e7          	jalr	-2014(ra) # 80005f6c <panic>
    panic("virtio disk kalloc");
    80005752:	00003517          	auipc	a0,0x3
    80005756:	02650513          	addi	a0,a0,38 # 80008778 <syscalls+0x3d0>
    8000575a:	00001097          	auipc	ra,0x1
    8000575e:	812080e7          	jalr	-2030(ra) # 80005f6c <panic>

0000000080005762 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005762:	7119                	addi	sp,sp,-128
    80005764:	fc86                	sd	ra,120(sp)
    80005766:	f8a2                	sd	s0,112(sp)
    80005768:	f4a6                	sd	s1,104(sp)
    8000576a:	f0ca                	sd	s2,96(sp)
    8000576c:	ecce                	sd	s3,88(sp)
    8000576e:	e8d2                	sd	s4,80(sp)
    80005770:	e4d6                	sd	s5,72(sp)
    80005772:	e0da                	sd	s6,64(sp)
    80005774:	fc5e                	sd	s7,56(sp)
    80005776:	f862                	sd	s8,48(sp)
    80005778:	f466                	sd	s9,40(sp)
    8000577a:	f06a                	sd	s10,32(sp)
    8000577c:	ec6e                	sd	s11,24(sp)
    8000577e:	0100                	addi	s0,sp,128
    80005780:	8aaa                	mv	s5,a0
    80005782:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005784:	00c52d03          	lw	s10,12(a0)
    80005788:	001d1d1b          	slliw	s10,s10,0x1
    8000578c:	1d02                	slli	s10,s10,0x20
    8000578e:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80005792:	00020517          	auipc	a0,0x20
    80005796:	35650513          	addi	a0,a0,854 # 80025ae8 <disk+0x128>
    8000579a:	00001097          	auipc	ra,0x1
    8000579e:	d0a080e7          	jalr	-758(ra) # 800064a4 <acquire>
  for(int i = 0; i < 3; i++){
    800057a2:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800057a4:	44a1                	li	s1,8
      disk.free[i] = 0;
    800057a6:	00020b97          	auipc	s7,0x20
    800057aa:	21ab8b93          	addi	s7,s7,538 # 800259c0 <disk>
  for(int i = 0; i < 3; i++){
    800057ae:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800057b0:	00020c97          	auipc	s9,0x20
    800057b4:	338c8c93          	addi	s9,s9,824 # 80025ae8 <disk+0x128>
    800057b8:	a08d                	j	8000581a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800057ba:	00fb8733          	add	a4,s7,a5
    800057be:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800057c2:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800057c4:	0207c563          	bltz	a5,800057ee <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800057c8:	2905                	addiw	s2,s2,1
    800057ca:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800057cc:	05690c63          	beq	s2,s6,80005824 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800057d0:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800057d2:	00020717          	auipc	a4,0x20
    800057d6:	1ee70713          	addi	a4,a4,494 # 800259c0 <disk>
    800057da:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800057dc:	01874683          	lbu	a3,24(a4)
    800057e0:	fee9                	bnez	a3,800057ba <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800057e2:	2785                	addiw	a5,a5,1
    800057e4:	0705                	addi	a4,a4,1
    800057e6:	fe979be3          	bne	a5,s1,800057dc <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800057ea:	57fd                	li	a5,-1
    800057ec:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800057ee:	01205d63          	blez	s2,80005808 <virtio_disk_rw+0xa6>
    800057f2:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800057f4:	000a2503          	lw	a0,0(s4)
    800057f8:	00000097          	auipc	ra,0x0
    800057fc:	cfe080e7          	jalr	-770(ra) # 800054f6 <free_desc>
      for(int j = 0; j < i; j++)
    80005800:	2d85                	addiw	s11,s11,1
    80005802:	0a11                	addi	s4,s4,4
    80005804:	ff2d98e3          	bne	s11,s2,800057f4 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005808:	85e6                	mv	a1,s9
    8000580a:	00020517          	auipc	a0,0x20
    8000580e:	1ce50513          	addi	a0,a0,462 # 800259d8 <disk+0x18>
    80005812:	ffffc097          	auipc	ra,0xffffc
    80005816:	d0a080e7          	jalr	-758(ra) # 8000151c <sleep>
  for(int i = 0; i < 3; i++){
    8000581a:	f8040a13          	addi	s4,s0,-128
{
    8000581e:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005820:	894e                	mv	s2,s3
    80005822:	b77d                	j	800057d0 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005824:	f8042503          	lw	a0,-128(s0)
    80005828:	00a50713          	addi	a4,a0,10
    8000582c:	0712                	slli	a4,a4,0x4

  if(write)
    8000582e:	00020797          	auipc	a5,0x20
    80005832:	19278793          	addi	a5,a5,402 # 800259c0 <disk>
    80005836:	00e786b3          	add	a3,a5,a4
    8000583a:	01803633          	snez	a2,s8
    8000583e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005840:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005844:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005848:	f6070613          	addi	a2,a4,-160
    8000584c:	6394                	ld	a3,0(a5)
    8000584e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005850:	00870593          	addi	a1,a4,8
    80005854:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005856:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005858:	0007b803          	ld	a6,0(a5)
    8000585c:	9642                	add	a2,a2,a6
    8000585e:	46c1                	li	a3,16
    80005860:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005862:	4585                	li	a1,1
    80005864:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005868:	f8442683          	lw	a3,-124(s0)
    8000586c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005870:	0692                	slli	a3,a3,0x4
    80005872:	9836                	add	a6,a6,a3
    80005874:	058a8613          	addi	a2,s5,88
    80005878:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000587c:	0007b803          	ld	a6,0(a5)
    80005880:	96c2                	add	a3,a3,a6
    80005882:	40000613          	li	a2,1024
    80005886:	c690                	sw	a2,8(a3)
  if(write)
    80005888:	001c3613          	seqz	a2,s8
    8000588c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005890:	00166613          	ori	a2,a2,1
    80005894:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005898:	f8842603          	lw	a2,-120(s0)
    8000589c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800058a0:	00250693          	addi	a3,a0,2
    800058a4:	0692                	slli	a3,a3,0x4
    800058a6:	96be                	add	a3,a3,a5
    800058a8:	58fd                	li	a7,-1
    800058aa:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800058ae:	0612                	slli	a2,a2,0x4
    800058b0:	9832                	add	a6,a6,a2
    800058b2:	f9070713          	addi	a4,a4,-112
    800058b6:	973e                	add	a4,a4,a5
    800058b8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800058bc:	6398                	ld	a4,0(a5)
    800058be:	9732                	add	a4,a4,a2
    800058c0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800058c2:	4609                	li	a2,2
    800058c4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800058c8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800058cc:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    800058d0:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800058d4:	6794                	ld	a3,8(a5)
    800058d6:	0026d703          	lhu	a4,2(a3)
    800058da:	8b1d                	andi	a4,a4,7
    800058dc:	0706                	slli	a4,a4,0x1
    800058de:	96ba                	add	a3,a3,a4
    800058e0:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800058e4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800058e8:	6798                	ld	a4,8(a5)
    800058ea:	00275783          	lhu	a5,2(a4)
    800058ee:	2785                	addiw	a5,a5,1
    800058f0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800058f4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800058f8:	100017b7          	lui	a5,0x10001
    800058fc:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005900:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    80005904:	00020917          	auipc	s2,0x20
    80005908:	1e490913          	addi	s2,s2,484 # 80025ae8 <disk+0x128>
  while(b->disk == 1) {
    8000590c:	4485                	li	s1,1
    8000590e:	00b79c63          	bne	a5,a1,80005926 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005912:	85ca                	mv	a1,s2
    80005914:	8556                	mv	a0,s5
    80005916:	ffffc097          	auipc	ra,0xffffc
    8000591a:	c06080e7          	jalr	-1018(ra) # 8000151c <sleep>
  while(b->disk == 1) {
    8000591e:	004aa783          	lw	a5,4(s5)
    80005922:	fe9788e3          	beq	a5,s1,80005912 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005926:	f8042903          	lw	s2,-128(s0)
    8000592a:	00290713          	addi	a4,s2,2
    8000592e:	0712                	slli	a4,a4,0x4
    80005930:	00020797          	auipc	a5,0x20
    80005934:	09078793          	addi	a5,a5,144 # 800259c0 <disk>
    80005938:	97ba                	add	a5,a5,a4
    8000593a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000593e:	00020997          	auipc	s3,0x20
    80005942:	08298993          	addi	s3,s3,130 # 800259c0 <disk>
    80005946:	00491713          	slli	a4,s2,0x4
    8000594a:	0009b783          	ld	a5,0(s3)
    8000594e:	97ba                	add	a5,a5,a4
    80005950:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005954:	854a                	mv	a0,s2
    80005956:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000595a:	00000097          	auipc	ra,0x0
    8000595e:	b9c080e7          	jalr	-1124(ra) # 800054f6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005962:	8885                	andi	s1,s1,1
    80005964:	f0ed                	bnez	s1,80005946 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005966:	00020517          	auipc	a0,0x20
    8000596a:	18250513          	addi	a0,a0,386 # 80025ae8 <disk+0x128>
    8000596e:	00001097          	auipc	ra,0x1
    80005972:	bea080e7          	jalr	-1046(ra) # 80006558 <release>
}
    80005976:	70e6                	ld	ra,120(sp)
    80005978:	7446                	ld	s0,112(sp)
    8000597a:	74a6                	ld	s1,104(sp)
    8000597c:	7906                	ld	s2,96(sp)
    8000597e:	69e6                	ld	s3,88(sp)
    80005980:	6a46                	ld	s4,80(sp)
    80005982:	6aa6                	ld	s5,72(sp)
    80005984:	6b06                	ld	s6,64(sp)
    80005986:	7be2                	ld	s7,56(sp)
    80005988:	7c42                	ld	s8,48(sp)
    8000598a:	7ca2                	ld	s9,40(sp)
    8000598c:	7d02                	ld	s10,32(sp)
    8000598e:	6de2                	ld	s11,24(sp)
    80005990:	6109                	addi	sp,sp,128
    80005992:	8082                	ret

0000000080005994 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005994:	1101                	addi	sp,sp,-32
    80005996:	ec06                	sd	ra,24(sp)
    80005998:	e822                	sd	s0,16(sp)
    8000599a:	e426                	sd	s1,8(sp)
    8000599c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000599e:	00020497          	auipc	s1,0x20
    800059a2:	02248493          	addi	s1,s1,34 # 800259c0 <disk>
    800059a6:	00020517          	auipc	a0,0x20
    800059aa:	14250513          	addi	a0,a0,322 # 80025ae8 <disk+0x128>
    800059ae:	00001097          	auipc	ra,0x1
    800059b2:	af6080e7          	jalr	-1290(ra) # 800064a4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800059b6:	10001737          	lui	a4,0x10001
    800059ba:	533c                	lw	a5,96(a4)
    800059bc:	8b8d                	andi	a5,a5,3
    800059be:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800059c0:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800059c4:	689c                	ld	a5,16(s1)
    800059c6:	0204d703          	lhu	a4,32(s1)
    800059ca:	0027d783          	lhu	a5,2(a5)
    800059ce:	04f70863          	beq	a4,a5,80005a1e <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800059d2:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800059d6:	6898                	ld	a4,16(s1)
    800059d8:	0204d783          	lhu	a5,32(s1)
    800059dc:	8b9d                	andi	a5,a5,7
    800059de:	078e                	slli	a5,a5,0x3
    800059e0:	97ba                	add	a5,a5,a4
    800059e2:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800059e4:	00278713          	addi	a4,a5,2
    800059e8:	0712                	slli	a4,a4,0x4
    800059ea:	9726                	add	a4,a4,s1
    800059ec:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800059f0:	e721                	bnez	a4,80005a38 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800059f2:	0789                	addi	a5,a5,2
    800059f4:	0792                	slli	a5,a5,0x4
    800059f6:	97a6                	add	a5,a5,s1
    800059f8:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800059fa:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800059fe:	ffffc097          	auipc	ra,0xffffc
    80005a02:	b82080e7          	jalr	-1150(ra) # 80001580 <wakeup>

    disk.used_idx += 1;
    80005a06:	0204d783          	lhu	a5,32(s1)
    80005a0a:	2785                	addiw	a5,a5,1
    80005a0c:	17c2                	slli	a5,a5,0x30
    80005a0e:	93c1                	srli	a5,a5,0x30
    80005a10:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005a14:	6898                	ld	a4,16(s1)
    80005a16:	00275703          	lhu	a4,2(a4)
    80005a1a:	faf71ce3          	bne	a4,a5,800059d2 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005a1e:	00020517          	auipc	a0,0x20
    80005a22:	0ca50513          	addi	a0,a0,202 # 80025ae8 <disk+0x128>
    80005a26:	00001097          	auipc	ra,0x1
    80005a2a:	b32080e7          	jalr	-1230(ra) # 80006558 <release>
}
    80005a2e:	60e2                	ld	ra,24(sp)
    80005a30:	6442                	ld	s0,16(sp)
    80005a32:	64a2                	ld	s1,8(sp)
    80005a34:	6105                	addi	sp,sp,32
    80005a36:	8082                	ret
      panic("virtio_disk_intr status");
    80005a38:	00003517          	auipc	a0,0x3
    80005a3c:	d5850513          	addi	a0,a0,-680 # 80008790 <syscalls+0x3e8>
    80005a40:	00000097          	auipc	ra,0x0
    80005a44:	52c080e7          	jalr	1324(ra) # 80005f6c <panic>

0000000080005a48 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005a48:	1141                	addi	sp,sp,-16
    80005a4a:	e422                	sd	s0,8(sp)
    80005a4c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005a4e:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005a52:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005a56:	0037979b          	slliw	a5,a5,0x3
    80005a5a:	02004737          	lui	a4,0x2004
    80005a5e:	97ba                	add	a5,a5,a4
    80005a60:	0200c737          	lui	a4,0x200c
    80005a64:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005a68:	000f4637          	lui	a2,0xf4
    80005a6c:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005a70:	9732                	add	a4,a4,a2
    80005a72:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005a74:	00259693          	slli	a3,a1,0x2
    80005a78:	96ae                	add	a3,a3,a1
    80005a7a:	068e                	slli	a3,a3,0x3
    80005a7c:	00020717          	auipc	a4,0x20
    80005a80:	08470713          	addi	a4,a4,132 # 80025b00 <timer_scratch>
    80005a84:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005a86:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005a88:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005a8a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005a8e:	00000797          	auipc	a5,0x0
    80005a92:	9a278793          	addi	a5,a5,-1630 # 80005430 <timervec>
    80005a96:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005a9a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005a9e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005aa2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005aa6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005aaa:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005aae:	30479073          	csrw	mie,a5
}
    80005ab2:	6422                	ld	s0,8(sp)
    80005ab4:	0141                	addi	sp,sp,16
    80005ab6:	8082                	ret

0000000080005ab8 <start>:
{
    80005ab8:	1141                	addi	sp,sp,-16
    80005aba:	e406                	sd	ra,8(sp)
    80005abc:	e022                	sd	s0,0(sp)
    80005abe:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005ac0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005ac4:	7779                	lui	a4,0xffffe
    80005ac6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd0abf>
    80005aca:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005acc:	6705                	lui	a4,0x1
    80005ace:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005ad2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005ad4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005ad8:	ffffb797          	auipc	a5,0xffffb
    80005adc:	84878793          	addi	a5,a5,-1976 # 80000320 <main>
    80005ae0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005ae4:	4781                	li	a5,0
    80005ae6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005aea:	67c1                	lui	a5,0x10
    80005aec:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005aee:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005af2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005af6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005afa:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005afe:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005b02:	57fd                	li	a5,-1
    80005b04:	83a9                	srli	a5,a5,0xa
    80005b06:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005b0a:	47bd                	li	a5,15
    80005b0c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005b10:	00000097          	auipc	ra,0x0
    80005b14:	f38080e7          	jalr	-200(ra) # 80005a48 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005b18:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005b1c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005b1e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005b20:	30200073          	mret
}
    80005b24:	60a2                	ld	ra,8(sp)
    80005b26:	6402                	ld	s0,0(sp)
    80005b28:	0141                	addi	sp,sp,16
    80005b2a:	8082                	ret

0000000080005b2c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005b2c:	715d                	addi	sp,sp,-80
    80005b2e:	e486                	sd	ra,72(sp)
    80005b30:	e0a2                	sd	s0,64(sp)
    80005b32:	fc26                	sd	s1,56(sp)
    80005b34:	f84a                	sd	s2,48(sp)
    80005b36:	f44e                	sd	s3,40(sp)
    80005b38:	f052                	sd	s4,32(sp)
    80005b3a:	ec56                	sd	s5,24(sp)
    80005b3c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005b3e:	04c05763          	blez	a2,80005b8c <consolewrite+0x60>
    80005b42:	8a2a                	mv	s4,a0
    80005b44:	84ae                	mv	s1,a1
    80005b46:	89b2                	mv	s3,a2
    80005b48:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005b4a:	5afd                	li	s5,-1
    80005b4c:	4685                	li	a3,1
    80005b4e:	8626                	mv	a2,s1
    80005b50:	85d2                	mv	a1,s4
    80005b52:	fbf40513          	addi	a0,s0,-65
    80005b56:	ffffc097          	auipc	ra,0xffffc
    80005b5a:	e88080e7          	jalr	-376(ra) # 800019de <either_copyin>
    80005b5e:	01550d63          	beq	a0,s5,80005b78 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005b62:	fbf44503          	lbu	a0,-65(s0)
    80005b66:	00000097          	auipc	ra,0x0
    80005b6a:	784080e7          	jalr	1924(ra) # 800062ea <uartputc>
  for(i = 0; i < n; i++){
    80005b6e:	2905                	addiw	s2,s2,1
    80005b70:	0485                	addi	s1,s1,1
    80005b72:	fd299de3          	bne	s3,s2,80005b4c <consolewrite+0x20>
    80005b76:	894e                	mv	s2,s3
  }

  return i;
}
    80005b78:	854a                	mv	a0,s2
    80005b7a:	60a6                	ld	ra,72(sp)
    80005b7c:	6406                	ld	s0,64(sp)
    80005b7e:	74e2                	ld	s1,56(sp)
    80005b80:	7942                	ld	s2,48(sp)
    80005b82:	79a2                	ld	s3,40(sp)
    80005b84:	7a02                	ld	s4,32(sp)
    80005b86:	6ae2                	ld	s5,24(sp)
    80005b88:	6161                	addi	sp,sp,80
    80005b8a:	8082                	ret
  for(i = 0; i < n; i++){
    80005b8c:	4901                	li	s2,0
    80005b8e:	b7ed                	j	80005b78 <consolewrite+0x4c>

0000000080005b90 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005b90:	7159                	addi	sp,sp,-112
    80005b92:	f486                	sd	ra,104(sp)
    80005b94:	f0a2                	sd	s0,96(sp)
    80005b96:	eca6                	sd	s1,88(sp)
    80005b98:	e8ca                	sd	s2,80(sp)
    80005b9a:	e4ce                	sd	s3,72(sp)
    80005b9c:	e0d2                	sd	s4,64(sp)
    80005b9e:	fc56                	sd	s5,56(sp)
    80005ba0:	f85a                	sd	s6,48(sp)
    80005ba2:	f45e                	sd	s7,40(sp)
    80005ba4:	f062                	sd	s8,32(sp)
    80005ba6:	ec66                	sd	s9,24(sp)
    80005ba8:	e86a                	sd	s10,16(sp)
    80005baa:	1880                	addi	s0,sp,112
    80005bac:	8aaa                	mv	s5,a0
    80005bae:	8a2e                	mv	s4,a1
    80005bb0:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005bb2:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005bb6:	00028517          	auipc	a0,0x28
    80005bba:	08a50513          	addi	a0,a0,138 # 8002dc40 <cons>
    80005bbe:	00001097          	auipc	ra,0x1
    80005bc2:	8e6080e7          	jalr	-1818(ra) # 800064a4 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005bc6:	00028497          	auipc	s1,0x28
    80005bca:	07a48493          	addi	s1,s1,122 # 8002dc40 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005bce:	00028917          	auipc	s2,0x28
    80005bd2:	10a90913          	addi	s2,s2,266 # 8002dcd8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005bd6:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005bd8:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005bda:	4ca9                	li	s9,10
  while(n > 0){
    80005bdc:	07305b63          	blez	s3,80005c52 <consoleread+0xc2>
    while(cons.r == cons.w){
    80005be0:	0984a783          	lw	a5,152(s1)
    80005be4:	09c4a703          	lw	a4,156(s1)
    80005be8:	02f71763          	bne	a4,a5,80005c16 <consoleread+0x86>
      if(killed(myproc())){
    80005bec:	ffffb097          	auipc	ra,0xffffb
    80005bf0:	24e080e7          	jalr	590(ra) # 80000e3a <myproc>
    80005bf4:	ffffc097          	auipc	ra,0xffffc
    80005bf8:	c34080e7          	jalr	-972(ra) # 80001828 <killed>
    80005bfc:	e535                	bnez	a0,80005c68 <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    80005bfe:	85a6                	mv	a1,s1
    80005c00:	854a                	mv	a0,s2
    80005c02:	ffffc097          	auipc	ra,0xffffc
    80005c06:	91a080e7          	jalr	-1766(ra) # 8000151c <sleep>
    while(cons.r == cons.w){
    80005c0a:	0984a783          	lw	a5,152(s1)
    80005c0e:	09c4a703          	lw	a4,156(s1)
    80005c12:	fcf70de3          	beq	a4,a5,80005bec <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005c16:	0017871b          	addiw	a4,a5,1
    80005c1a:	08e4ac23          	sw	a4,152(s1)
    80005c1e:	07f7f713          	andi	a4,a5,127
    80005c22:	9726                	add	a4,a4,s1
    80005c24:	01874703          	lbu	a4,24(a4)
    80005c28:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005c2c:	077d0563          	beq	s10,s7,80005c96 <consoleread+0x106>
    cbuf = c;
    80005c30:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005c34:	4685                	li	a3,1
    80005c36:	f9f40613          	addi	a2,s0,-97
    80005c3a:	85d2                	mv	a1,s4
    80005c3c:	8556                	mv	a0,s5
    80005c3e:	ffffc097          	auipc	ra,0xffffc
    80005c42:	d4a080e7          	jalr	-694(ra) # 80001988 <either_copyout>
    80005c46:	01850663          	beq	a0,s8,80005c52 <consoleread+0xc2>
    dst++;
    80005c4a:	0a05                	addi	s4,s4,1
    --n;
    80005c4c:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005c4e:	f99d17e3          	bne	s10,s9,80005bdc <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005c52:	00028517          	auipc	a0,0x28
    80005c56:	fee50513          	addi	a0,a0,-18 # 8002dc40 <cons>
    80005c5a:	00001097          	auipc	ra,0x1
    80005c5e:	8fe080e7          	jalr	-1794(ra) # 80006558 <release>

  return target - n;
    80005c62:	413b053b          	subw	a0,s6,s3
    80005c66:	a811                	j	80005c7a <consoleread+0xea>
        release(&cons.lock);
    80005c68:	00028517          	auipc	a0,0x28
    80005c6c:	fd850513          	addi	a0,a0,-40 # 8002dc40 <cons>
    80005c70:	00001097          	auipc	ra,0x1
    80005c74:	8e8080e7          	jalr	-1816(ra) # 80006558 <release>
        return -1;
    80005c78:	557d                	li	a0,-1
}
    80005c7a:	70a6                	ld	ra,104(sp)
    80005c7c:	7406                	ld	s0,96(sp)
    80005c7e:	64e6                	ld	s1,88(sp)
    80005c80:	6946                	ld	s2,80(sp)
    80005c82:	69a6                	ld	s3,72(sp)
    80005c84:	6a06                	ld	s4,64(sp)
    80005c86:	7ae2                	ld	s5,56(sp)
    80005c88:	7b42                	ld	s6,48(sp)
    80005c8a:	7ba2                	ld	s7,40(sp)
    80005c8c:	7c02                	ld	s8,32(sp)
    80005c8e:	6ce2                	ld	s9,24(sp)
    80005c90:	6d42                	ld	s10,16(sp)
    80005c92:	6165                	addi	sp,sp,112
    80005c94:	8082                	ret
      if(n < target){
    80005c96:	0009871b          	sext.w	a4,s3
    80005c9a:	fb677ce3          	bgeu	a4,s6,80005c52 <consoleread+0xc2>
        cons.r--;
    80005c9e:	00028717          	auipc	a4,0x28
    80005ca2:	02f72d23          	sw	a5,58(a4) # 8002dcd8 <cons+0x98>
    80005ca6:	b775                	j	80005c52 <consoleread+0xc2>

0000000080005ca8 <consputc>:
{
    80005ca8:	1141                	addi	sp,sp,-16
    80005caa:	e406                	sd	ra,8(sp)
    80005cac:	e022                	sd	s0,0(sp)
    80005cae:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005cb0:	10000793          	li	a5,256
    80005cb4:	00f50a63          	beq	a0,a5,80005cc8 <consputc+0x20>
    uartputc_sync(c);
    80005cb8:	00000097          	auipc	ra,0x0
    80005cbc:	560080e7          	jalr	1376(ra) # 80006218 <uartputc_sync>
}
    80005cc0:	60a2                	ld	ra,8(sp)
    80005cc2:	6402                	ld	s0,0(sp)
    80005cc4:	0141                	addi	sp,sp,16
    80005cc6:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005cc8:	4521                	li	a0,8
    80005cca:	00000097          	auipc	ra,0x0
    80005cce:	54e080e7          	jalr	1358(ra) # 80006218 <uartputc_sync>
    80005cd2:	02000513          	li	a0,32
    80005cd6:	00000097          	auipc	ra,0x0
    80005cda:	542080e7          	jalr	1346(ra) # 80006218 <uartputc_sync>
    80005cde:	4521                	li	a0,8
    80005ce0:	00000097          	auipc	ra,0x0
    80005ce4:	538080e7          	jalr	1336(ra) # 80006218 <uartputc_sync>
    80005ce8:	bfe1                	j	80005cc0 <consputc+0x18>

0000000080005cea <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005cea:	1101                	addi	sp,sp,-32
    80005cec:	ec06                	sd	ra,24(sp)
    80005cee:	e822                	sd	s0,16(sp)
    80005cf0:	e426                	sd	s1,8(sp)
    80005cf2:	e04a                	sd	s2,0(sp)
    80005cf4:	1000                	addi	s0,sp,32
    80005cf6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005cf8:	00028517          	auipc	a0,0x28
    80005cfc:	f4850513          	addi	a0,a0,-184 # 8002dc40 <cons>
    80005d00:	00000097          	auipc	ra,0x0
    80005d04:	7a4080e7          	jalr	1956(ra) # 800064a4 <acquire>

  switch(c){
    80005d08:	47d5                	li	a5,21
    80005d0a:	0af48663          	beq	s1,a5,80005db6 <consoleintr+0xcc>
    80005d0e:	0297ca63          	blt	a5,s1,80005d42 <consoleintr+0x58>
    80005d12:	47a1                	li	a5,8
    80005d14:	0ef48763          	beq	s1,a5,80005e02 <consoleintr+0x118>
    80005d18:	47c1                	li	a5,16
    80005d1a:	10f49a63          	bne	s1,a5,80005e2e <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005d1e:	ffffc097          	auipc	ra,0xffffc
    80005d22:	d16080e7          	jalr	-746(ra) # 80001a34 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005d26:	00028517          	auipc	a0,0x28
    80005d2a:	f1a50513          	addi	a0,a0,-230 # 8002dc40 <cons>
    80005d2e:	00001097          	auipc	ra,0x1
    80005d32:	82a080e7          	jalr	-2006(ra) # 80006558 <release>
}
    80005d36:	60e2                	ld	ra,24(sp)
    80005d38:	6442                	ld	s0,16(sp)
    80005d3a:	64a2                	ld	s1,8(sp)
    80005d3c:	6902                	ld	s2,0(sp)
    80005d3e:	6105                	addi	sp,sp,32
    80005d40:	8082                	ret
  switch(c){
    80005d42:	07f00793          	li	a5,127
    80005d46:	0af48e63          	beq	s1,a5,80005e02 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005d4a:	00028717          	auipc	a4,0x28
    80005d4e:	ef670713          	addi	a4,a4,-266 # 8002dc40 <cons>
    80005d52:	0a072783          	lw	a5,160(a4)
    80005d56:	09872703          	lw	a4,152(a4)
    80005d5a:	9f99                	subw	a5,a5,a4
    80005d5c:	07f00713          	li	a4,127
    80005d60:	fcf763e3          	bltu	a4,a5,80005d26 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005d64:	47b5                	li	a5,13
    80005d66:	0cf48763          	beq	s1,a5,80005e34 <consoleintr+0x14a>
      consputc(c);
    80005d6a:	8526                	mv	a0,s1
    80005d6c:	00000097          	auipc	ra,0x0
    80005d70:	f3c080e7          	jalr	-196(ra) # 80005ca8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005d74:	00028797          	auipc	a5,0x28
    80005d78:	ecc78793          	addi	a5,a5,-308 # 8002dc40 <cons>
    80005d7c:	0a07a683          	lw	a3,160(a5)
    80005d80:	0016871b          	addiw	a4,a3,1
    80005d84:	0007061b          	sext.w	a2,a4
    80005d88:	0ae7a023          	sw	a4,160(a5)
    80005d8c:	07f6f693          	andi	a3,a3,127
    80005d90:	97b6                	add	a5,a5,a3
    80005d92:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005d96:	47a9                	li	a5,10
    80005d98:	0cf48563          	beq	s1,a5,80005e62 <consoleintr+0x178>
    80005d9c:	4791                	li	a5,4
    80005d9e:	0cf48263          	beq	s1,a5,80005e62 <consoleintr+0x178>
    80005da2:	00028797          	auipc	a5,0x28
    80005da6:	f367a783          	lw	a5,-202(a5) # 8002dcd8 <cons+0x98>
    80005daa:	9f1d                	subw	a4,a4,a5
    80005dac:	08000793          	li	a5,128
    80005db0:	f6f71be3          	bne	a4,a5,80005d26 <consoleintr+0x3c>
    80005db4:	a07d                	j	80005e62 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005db6:	00028717          	auipc	a4,0x28
    80005dba:	e8a70713          	addi	a4,a4,-374 # 8002dc40 <cons>
    80005dbe:	0a072783          	lw	a5,160(a4)
    80005dc2:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005dc6:	00028497          	auipc	s1,0x28
    80005dca:	e7a48493          	addi	s1,s1,-390 # 8002dc40 <cons>
    while(cons.e != cons.w &&
    80005dce:	4929                	li	s2,10
    80005dd0:	f4f70be3          	beq	a4,a5,80005d26 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005dd4:	37fd                	addiw	a5,a5,-1
    80005dd6:	07f7f713          	andi	a4,a5,127
    80005dda:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005ddc:	01874703          	lbu	a4,24(a4)
    80005de0:	f52703e3          	beq	a4,s2,80005d26 <consoleintr+0x3c>
      cons.e--;
    80005de4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005de8:	10000513          	li	a0,256
    80005dec:	00000097          	auipc	ra,0x0
    80005df0:	ebc080e7          	jalr	-324(ra) # 80005ca8 <consputc>
    while(cons.e != cons.w &&
    80005df4:	0a04a783          	lw	a5,160(s1)
    80005df8:	09c4a703          	lw	a4,156(s1)
    80005dfc:	fcf71ce3          	bne	a4,a5,80005dd4 <consoleintr+0xea>
    80005e00:	b71d                	j	80005d26 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005e02:	00028717          	auipc	a4,0x28
    80005e06:	e3e70713          	addi	a4,a4,-450 # 8002dc40 <cons>
    80005e0a:	0a072783          	lw	a5,160(a4)
    80005e0e:	09c72703          	lw	a4,156(a4)
    80005e12:	f0f70ae3          	beq	a4,a5,80005d26 <consoleintr+0x3c>
      cons.e--;
    80005e16:	37fd                	addiw	a5,a5,-1
    80005e18:	00028717          	auipc	a4,0x28
    80005e1c:	ecf72423          	sw	a5,-312(a4) # 8002dce0 <cons+0xa0>
      consputc(BACKSPACE);
    80005e20:	10000513          	li	a0,256
    80005e24:	00000097          	auipc	ra,0x0
    80005e28:	e84080e7          	jalr	-380(ra) # 80005ca8 <consputc>
    80005e2c:	bded                	j	80005d26 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005e2e:	ee048ce3          	beqz	s1,80005d26 <consoleintr+0x3c>
    80005e32:	bf21                	j	80005d4a <consoleintr+0x60>
      consputc(c);
    80005e34:	4529                	li	a0,10
    80005e36:	00000097          	auipc	ra,0x0
    80005e3a:	e72080e7          	jalr	-398(ra) # 80005ca8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005e3e:	00028797          	auipc	a5,0x28
    80005e42:	e0278793          	addi	a5,a5,-510 # 8002dc40 <cons>
    80005e46:	0a07a703          	lw	a4,160(a5)
    80005e4a:	0017069b          	addiw	a3,a4,1
    80005e4e:	0006861b          	sext.w	a2,a3
    80005e52:	0ad7a023          	sw	a3,160(a5)
    80005e56:	07f77713          	andi	a4,a4,127
    80005e5a:	97ba                	add	a5,a5,a4
    80005e5c:	4729                	li	a4,10
    80005e5e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005e62:	00028797          	auipc	a5,0x28
    80005e66:	e6c7ad23          	sw	a2,-390(a5) # 8002dcdc <cons+0x9c>
        wakeup(&cons.r);
    80005e6a:	00028517          	auipc	a0,0x28
    80005e6e:	e6e50513          	addi	a0,a0,-402 # 8002dcd8 <cons+0x98>
    80005e72:	ffffb097          	auipc	ra,0xffffb
    80005e76:	70e080e7          	jalr	1806(ra) # 80001580 <wakeup>
    80005e7a:	b575                	j	80005d26 <consoleintr+0x3c>

0000000080005e7c <consoleinit>:

void
consoleinit(void)
{
    80005e7c:	1141                	addi	sp,sp,-16
    80005e7e:	e406                	sd	ra,8(sp)
    80005e80:	e022                	sd	s0,0(sp)
    80005e82:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005e84:	00003597          	auipc	a1,0x3
    80005e88:	92458593          	addi	a1,a1,-1756 # 800087a8 <syscalls+0x400>
    80005e8c:	00028517          	auipc	a0,0x28
    80005e90:	db450513          	addi	a0,a0,-588 # 8002dc40 <cons>
    80005e94:	00000097          	auipc	ra,0x0
    80005e98:	580080e7          	jalr	1408(ra) # 80006414 <initlock>

  uartinit();
    80005e9c:	00000097          	auipc	ra,0x0
    80005ea0:	32c080e7          	jalr	812(ra) # 800061c8 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005ea4:	0001f797          	auipc	a5,0x1f
    80005ea8:	ac478793          	addi	a5,a5,-1340 # 80024968 <devsw>
    80005eac:	00000717          	auipc	a4,0x0
    80005eb0:	ce470713          	addi	a4,a4,-796 # 80005b90 <consoleread>
    80005eb4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005eb6:	00000717          	auipc	a4,0x0
    80005eba:	c7670713          	addi	a4,a4,-906 # 80005b2c <consolewrite>
    80005ebe:	ef98                	sd	a4,24(a5)
}
    80005ec0:	60a2                	ld	ra,8(sp)
    80005ec2:	6402                	ld	s0,0(sp)
    80005ec4:	0141                	addi	sp,sp,16
    80005ec6:	8082                	ret

0000000080005ec8 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005ec8:	7179                	addi	sp,sp,-48
    80005eca:	f406                	sd	ra,40(sp)
    80005ecc:	f022                	sd	s0,32(sp)
    80005ece:	ec26                	sd	s1,24(sp)
    80005ed0:	e84a                	sd	s2,16(sp)
    80005ed2:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005ed4:	c219                	beqz	a2,80005eda <printint+0x12>
    80005ed6:	08054763          	bltz	a0,80005f64 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005eda:	2501                	sext.w	a0,a0
    80005edc:	4881                	li	a7,0
    80005ede:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005ee2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005ee4:	2581                	sext.w	a1,a1
    80005ee6:	00003617          	auipc	a2,0x3
    80005eea:	8f260613          	addi	a2,a2,-1806 # 800087d8 <digits>
    80005eee:	883a                	mv	a6,a4
    80005ef0:	2705                	addiw	a4,a4,1
    80005ef2:	02b577bb          	remuw	a5,a0,a1
    80005ef6:	1782                	slli	a5,a5,0x20
    80005ef8:	9381                	srli	a5,a5,0x20
    80005efa:	97b2                	add	a5,a5,a2
    80005efc:	0007c783          	lbu	a5,0(a5)
    80005f00:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005f04:	0005079b          	sext.w	a5,a0
    80005f08:	02b5553b          	divuw	a0,a0,a1
    80005f0c:	0685                	addi	a3,a3,1
    80005f0e:	feb7f0e3          	bgeu	a5,a1,80005eee <printint+0x26>

  if(sign)
    80005f12:	00088c63          	beqz	a7,80005f2a <printint+0x62>
    buf[i++] = '-';
    80005f16:	fe070793          	addi	a5,a4,-32
    80005f1a:	00878733          	add	a4,a5,s0
    80005f1e:	02d00793          	li	a5,45
    80005f22:	fef70823          	sb	a5,-16(a4)
    80005f26:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005f2a:	02e05763          	blez	a4,80005f58 <printint+0x90>
    80005f2e:	fd040793          	addi	a5,s0,-48
    80005f32:	00e784b3          	add	s1,a5,a4
    80005f36:	fff78913          	addi	s2,a5,-1
    80005f3a:	993a                	add	s2,s2,a4
    80005f3c:	377d                	addiw	a4,a4,-1
    80005f3e:	1702                	slli	a4,a4,0x20
    80005f40:	9301                	srli	a4,a4,0x20
    80005f42:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005f46:	fff4c503          	lbu	a0,-1(s1)
    80005f4a:	00000097          	auipc	ra,0x0
    80005f4e:	d5e080e7          	jalr	-674(ra) # 80005ca8 <consputc>
  while(--i >= 0)
    80005f52:	14fd                	addi	s1,s1,-1
    80005f54:	ff2499e3          	bne	s1,s2,80005f46 <printint+0x7e>
}
    80005f58:	70a2                	ld	ra,40(sp)
    80005f5a:	7402                	ld	s0,32(sp)
    80005f5c:	64e2                	ld	s1,24(sp)
    80005f5e:	6942                	ld	s2,16(sp)
    80005f60:	6145                	addi	sp,sp,48
    80005f62:	8082                	ret
    x = -xx;
    80005f64:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005f68:	4885                	li	a7,1
    x = -xx;
    80005f6a:	bf95                	j	80005ede <printint+0x16>

0000000080005f6c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005f6c:	1101                	addi	sp,sp,-32
    80005f6e:	ec06                	sd	ra,24(sp)
    80005f70:	e822                	sd	s0,16(sp)
    80005f72:	e426                	sd	s1,8(sp)
    80005f74:	1000                	addi	s0,sp,32
    80005f76:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005f78:	00028797          	auipc	a5,0x28
    80005f7c:	d807a423          	sw	zero,-632(a5) # 8002dd00 <pr+0x18>
  printf("panic: ");
    80005f80:	00003517          	auipc	a0,0x3
    80005f84:	83050513          	addi	a0,a0,-2000 # 800087b0 <syscalls+0x408>
    80005f88:	00000097          	auipc	ra,0x0
    80005f8c:	02e080e7          	jalr	46(ra) # 80005fb6 <printf>
  printf(s);
    80005f90:	8526                	mv	a0,s1
    80005f92:	00000097          	auipc	ra,0x0
    80005f96:	024080e7          	jalr	36(ra) # 80005fb6 <printf>
  printf("\n");
    80005f9a:	00002517          	auipc	a0,0x2
    80005f9e:	0ae50513          	addi	a0,a0,174 # 80008048 <etext+0x48>
    80005fa2:	00000097          	auipc	ra,0x0
    80005fa6:	014080e7          	jalr	20(ra) # 80005fb6 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005faa:	4785                	li	a5,1
    80005fac:	00003717          	auipc	a4,0x3
    80005fb0:	90f72823          	sw	a5,-1776(a4) # 800088bc <panicked>
  for(;;)
    80005fb4:	a001                	j	80005fb4 <panic+0x48>

0000000080005fb6 <printf>:
{
    80005fb6:	7131                	addi	sp,sp,-192
    80005fb8:	fc86                	sd	ra,120(sp)
    80005fba:	f8a2                	sd	s0,112(sp)
    80005fbc:	f4a6                	sd	s1,104(sp)
    80005fbe:	f0ca                	sd	s2,96(sp)
    80005fc0:	ecce                	sd	s3,88(sp)
    80005fc2:	e8d2                	sd	s4,80(sp)
    80005fc4:	e4d6                	sd	s5,72(sp)
    80005fc6:	e0da                	sd	s6,64(sp)
    80005fc8:	fc5e                	sd	s7,56(sp)
    80005fca:	f862                	sd	s8,48(sp)
    80005fcc:	f466                	sd	s9,40(sp)
    80005fce:	f06a                	sd	s10,32(sp)
    80005fd0:	ec6e                	sd	s11,24(sp)
    80005fd2:	0100                	addi	s0,sp,128
    80005fd4:	8a2a                	mv	s4,a0
    80005fd6:	e40c                	sd	a1,8(s0)
    80005fd8:	e810                	sd	a2,16(s0)
    80005fda:	ec14                	sd	a3,24(s0)
    80005fdc:	f018                	sd	a4,32(s0)
    80005fde:	f41c                	sd	a5,40(s0)
    80005fe0:	03043823          	sd	a6,48(s0)
    80005fe4:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005fe8:	00028d97          	auipc	s11,0x28
    80005fec:	d18dad83          	lw	s11,-744(s11) # 8002dd00 <pr+0x18>
  if(locking)
    80005ff0:	020d9b63          	bnez	s11,80006026 <printf+0x70>
  if (fmt == 0)
    80005ff4:	040a0263          	beqz	s4,80006038 <printf+0x82>
  va_start(ap, fmt);
    80005ff8:	00840793          	addi	a5,s0,8
    80005ffc:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006000:	000a4503          	lbu	a0,0(s4)
    80006004:	14050f63          	beqz	a0,80006162 <printf+0x1ac>
    80006008:	4981                	li	s3,0
    if(c != '%'){
    8000600a:	02500a93          	li	s5,37
    switch(c){
    8000600e:	07000b93          	li	s7,112
  consputc('x');
    80006012:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006014:	00002b17          	auipc	s6,0x2
    80006018:	7c4b0b13          	addi	s6,s6,1988 # 800087d8 <digits>
    switch(c){
    8000601c:	07300c93          	li	s9,115
    80006020:	06400c13          	li	s8,100
    80006024:	a82d                	j	8000605e <printf+0xa8>
    acquire(&pr.lock);
    80006026:	00028517          	auipc	a0,0x28
    8000602a:	cc250513          	addi	a0,a0,-830 # 8002dce8 <pr>
    8000602e:	00000097          	auipc	ra,0x0
    80006032:	476080e7          	jalr	1142(ra) # 800064a4 <acquire>
    80006036:	bf7d                	j	80005ff4 <printf+0x3e>
    panic("null fmt");
    80006038:	00002517          	auipc	a0,0x2
    8000603c:	78850513          	addi	a0,a0,1928 # 800087c0 <syscalls+0x418>
    80006040:	00000097          	auipc	ra,0x0
    80006044:	f2c080e7          	jalr	-212(ra) # 80005f6c <panic>
      consputc(c);
    80006048:	00000097          	auipc	ra,0x0
    8000604c:	c60080e7          	jalr	-928(ra) # 80005ca8 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006050:	2985                	addiw	s3,s3,1
    80006052:	013a07b3          	add	a5,s4,s3
    80006056:	0007c503          	lbu	a0,0(a5)
    8000605a:	10050463          	beqz	a0,80006162 <printf+0x1ac>
    if(c != '%'){
    8000605e:	ff5515e3          	bne	a0,s5,80006048 <printf+0x92>
    c = fmt[++i] & 0xff;
    80006062:	2985                	addiw	s3,s3,1
    80006064:	013a07b3          	add	a5,s4,s3
    80006068:	0007c783          	lbu	a5,0(a5)
    8000606c:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006070:	cbed                	beqz	a5,80006162 <printf+0x1ac>
    switch(c){
    80006072:	05778a63          	beq	a5,s7,800060c6 <printf+0x110>
    80006076:	02fbf663          	bgeu	s7,a5,800060a2 <printf+0xec>
    8000607a:	09978863          	beq	a5,s9,8000610a <printf+0x154>
    8000607e:	07800713          	li	a4,120
    80006082:	0ce79563          	bne	a5,a4,8000614c <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80006086:	f8843783          	ld	a5,-120(s0)
    8000608a:	00878713          	addi	a4,a5,8
    8000608e:	f8e43423          	sd	a4,-120(s0)
    80006092:	4605                	li	a2,1
    80006094:	85ea                	mv	a1,s10
    80006096:	4388                	lw	a0,0(a5)
    80006098:	00000097          	auipc	ra,0x0
    8000609c:	e30080e7          	jalr	-464(ra) # 80005ec8 <printint>
      break;
    800060a0:	bf45                	j	80006050 <printf+0x9a>
    switch(c){
    800060a2:	09578f63          	beq	a5,s5,80006140 <printf+0x18a>
    800060a6:	0b879363          	bne	a5,s8,8000614c <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    800060aa:	f8843783          	ld	a5,-120(s0)
    800060ae:	00878713          	addi	a4,a5,8
    800060b2:	f8e43423          	sd	a4,-120(s0)
    800060b6:	4605                	li	a2,1
    800060b8:	45a9                	li	a1,10
    800060ba:	4388                	lw	a0,0(a5)
    800060bc:	00000097          	auipc	ra,0x0
    800060c0:	e0c080e7          	jalr	-500(ra) # 80005ec8 <printint>
      break;
    800060c4:	b771                	j	80006050 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800060c6:	f8843783          	ld	a5,-120(s0)
    800060ca:	00878713          	addi	a4,a5,8
    800060ce:	f8e43423          	sd	a4,-120(s0)
    800060d2:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800060d6:	03000513          	li	a0,48
    800060da:	00000097          	auipc	ra,0x0
    800060de:	bce080e7          	jalr	-1074(ra) # 80005ca8 <consputc>
  consputc('x');
    800060e2:	07800513          	li	a0,120
    800060e6:	00000097          	auipc	ra,0x0
    800060ea:	bc2080e7          	jalr	-1086(ra) # 80005ca8 <consputc>
    800060ee:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800060f0:	03c95793          	srli	a5,s2,0x3c
    800060f4:	97da                	add	a5,a5,s6
    800060f6:	0007c503          	lbu	a0,0(a5)
    800060fa:	00000097          	auipc	ra,0x0
    800060fe:	bae080e7          	jalr	-1106(ra) # 80005ca8 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006102:	0912                	slli	s2,s2,0x4
    80006104:	34fd                	addiw	s1,s1,-1
    80006106:	f4ed                	bnez	s1,800060f0 <printf+0x13a>
    80006108:	b7a1                	j	80006050 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    8000610a:	f8843783          	ld	a5,-120(s0)
    8000610e:	00878713          	addi	a4,a5,8
    80006112:	f8e43423          	sd	a4,-120(s0)
    80006116:	6384                	ld	s1,0(a5)
    80006118:	cc89                	beqz	s1,80006132 <printf+0x17c>
      for(; *s; s++)
    8000611a:	0004c503          	lbu	a0,0(s1)
    8000611e:	d90d                	beqz	a0,80006050 <printf+0x9a>
        consputc(*s);
    80006120:	00000097          	auipc	ra,0x0
    80006124:	b88080e7          	jalr	-1144(ra) # 80005ca8 <consputc>
      for(; *s; s++)
    80006128:	0485                	addi	s1,s1,1
    8000612a:	0004c503          	lbu	a0,0(s1)
    8000612e:	f96d                	bnez	a0,80006120 <printf+0x16a>
    80006130:	b705                	j	80006050 <printf+0x9a>
        s = "(null)";
    80006132:	00002497          	auipc	s1,0x2
    80006136:	68648493          	addi	s1,s1,1670 # 800087b8 <syscalls+0x410>
      for(; *s; s++)
    8000613a:	02800513          	li	a0,40
    8000613e:	b7cd                	j	80006120 <printf+0x16a>
      consputc('%');
    80006140:	8556                	mv	a0,s5
    80006142:	00000097          	auipc	ra,0x0
    80006146:	b66080e7          	jalr	-1178(ra) # 80005ca8 <consputc>
      break;
    8000614a:	b719                	j	80006050 <printf+0x9a>
      consputc('%');
    8000614c:	8556                	mv	a0,s5
    8000614e:	00000097          	auipc	ra,0x0
    80006152:	b5a080e7          	jalr	-1190(ra) # 80005ca8 <consputc>
      consputc(c);
    80006156:	8526                	mv	a0,s1
    80006158:	00000097          	auipc	ra,0x0
    8000615c:	b50080e7          	jalr	-1200(ra) # 80005ca8 <consputc>
      break;
    80006160:	bdc5                	j	80006050 <printf+0x9a>
  if(locking)
    80006162:	020d9163          	bnez	s11,80006184 <printf+0x1ce>
}
    80006166:	70e6                	ld	ra,120(sp)
    80006168:	7446                	ld	s0,112(sp)
    8000616a:	74a6                	ld	s1,104(sp)
    8000616c:	7906                	ld	s2,96(sp)
    8000616e:	69e6                	ld	s3,88(sp)
    80006170:	6a46                	ld	s4,80(sp)
    80006172:	6aa6                	ld	s5,72(sp)
    80006174:	6b06                	ld	s6,64(sp)
    80006176:	7be2                	ld	s7,56(sp)
    80006178:	7c42                	ld	s8,48(sp)
    8000617a:	7ca2                	ld	s9,40(sp)
    8000617c:	7d02                	ld	s10,32(sp)
    8000617e:	6de2                	ld	s11,24(sp)
    80006180:	6129                	addi	sp,sp,192
    80006182:	8082                	ret
    release(&pr.lock);
    80006184:	00028517          	auipc	a0,0x28
    80006188:	b6450513          	addi	a0,a0,-1180 # 8002dce8 <pr>
    8000618c:	00000097          	auipc	ra,0x0
    80006190:	3cc080e7          	jalr	972(ra) # 80006558 <release>
}
    80006194:	bfc9                	j	80006166 <printf+0x1b0>

0000000080006196 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006196:	1101                	addi	sp,sp,-32
    80006198:	ec06                	sd	ra,24(sp)
    8000619a:	e822                	sd	s0,16(sp)
    8000619c:	e426                	sd	s1,8(sp)
    8000619e:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800061a0:	00028497          	auipc	s1,0x28
    800061a4:	b4848493          	addi	s1,s1,-1208 # 8002dce8 <pr>
    800061a8:	00002597          	auipc	a1,0x2
    800061ac:	62858593          	addi	a1,a1,1576 # 800087d0 <syscalls+0x428>
    800061b0:	8526                	mv	a0,s1
    800061b2:	00000097          	auipc	ra,0x0
    800061b6:	262080e7          	jalr	610(ra) # 80006414 <initlock>
  pr.locking = 1;
    800061ba:	4785                	li	a5,1
    800061bc:	cc9c                	sw	a5,24(s1)
}
    800061be:	60e2                	ld	ra,24(sp)
    800061c0:	6442                	ld	s0,16(sp)
    800061c2:	64a2                	ld	s1,8(sp)
    800061c4:	6105                	addi	sp,sp,32
    800061c6:	8082                	ret

00000000800061c8 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800061c8:	1141                	addi	sp,sp,-16
    800061ca:	e406                	sd	ra,8(sp)
    800061cc:	e022                	sd	s0,0(sp)
    800061ce:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800061d0:	100007b7          	lui	a5,0x10000
    800061d4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800061d8:	f8000713          	li	a4,-128
    800061dc:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800061e0:	470d                	li	a4,3
    800061e2:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800061e6:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800061ea:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800061ee:	469d                	li	a3,7
    800061f0:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800061f4:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800061f8:	00002597          	auipc	a1,0x2
    800061fc:	5f858593          	addi	a1,a1,1528 # 800087f0 <digits+0x18>
    80006200:	00028517          	auipc	a0,0x28
    80006204:	b0850513          	addi	a0,a0,-1272 # 8002dd08 <uart_tx_lock>
    80006208:	00000097          	auipc	ra,0x0
    8000620c:	20c080e7          	jalr	524(ra) # 80006414 <initlock>
}
    80006210:	60a2                	ld	ra,8(sp)
    80006212:	6402                	ld	s0,0(sp)
    80006214:	0141                	addi	sp,sp,16
    80006216:	8082                	ret

0000000080006218 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006218:	1101                	addi	sp,sp,-32
    8000621a:	ec06                	sd	ra,24(sp)
    8000621c:	e822                	sd	s0,16(sp)
    8000621e:	e426                	sd	s1,8(sp)
    80006220:	1000                	addi	s0,sp,32
    80006222:	84aa                	mv	s1,a0
  push_off();
    80006224:	00000097          	auipc	ra,0x0
    80006228:	234080e7          	jalr	564(ra) # 80006458 <push_off>

  if(panicked){
    8000622c:	00002797          	auipc	a5,0x2
    80006230:	6907a783          	lw	a5,1680(a5) # 800088bc <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006234:	10000737          	lui	a4,0x10000
  if(panicked){
    80006238:	c391                	beqz	a5,8000623c <uartputc_sync+0x24>
    for(;;)
    8000623a:	a001                	j	8000623a <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000623c:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006240:	0207f793          	andi	a5,a5,32
    80006244:	dfe5                	beqz	a5,8000623c <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006246:	0ff4f513          	zext.b	a0,s1
    8000624a:	100007b7          	lui	a5,0x10000
    8000624e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006252:	00000097          	auipc	ra,0x0
    80006256:	2a6080e7          	jalr	678(ra) # 800064f8 <pop_off>
}
    8000625a:	60e2                	ld	ra,24(sp)
    8000625c:	6442                	ld	s0,16(sp)
    8000625e:	64a2                	ld	s1,8(sp)
    80006260:	6105                	addi	sp,sp,32
    80006262:	8082                	ret

0000000080006264 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006264:	00002797          	auipc	a5,0x2
    80006268:	65c7b783          	ld	a5,1628(a5) # 800088c0 <uart_tx_r>
    8000626c:	00002717          	auipc	a4,0x2
    80006270:	65c73703          	ld	a4,1628(a4) # 800088c8 <uart_tx_w>
    80006274:	06f70a63          	beq	a4,a5,800062e8 <uartstart+0x84>
{
    80006278:	7139                	addi	sp,sp,-64
    8000627a:	fc06                	sd	ra,56(sp)
    8000627c:	f822                	sd	s0,48(sp)
    8000627e:	f426                	sd	s1,40(sp)
    80006280:	f04a                	sd	s2,32(sp)
    80006282:	ec4e                	sd	s3,24(sp)
    80006284:	e852                	sd	s4,16(sp)
    80006286:	e456                	sd	s5,8(sp)
    80006288:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000628a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000628e:	00028a17          	auipc	s4,0x28
    80006292:	a7aa0a13          	addi	s4,s4,-1414 # 8002dd08 <uart_tx_lock>
    uart_tx_r += 1;
    80006296:	00002497          	auipc	s1,0x2
    8000629a:	62a48493          	addi	s1,s1,1578 # 800088c0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000629e:	00002997          	auipc	s3,0x2
    800062a2:	62a98993          	addi	s3,s3,1578 # 800088c8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800062a6:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800062aa:	02077713          	andi	a4,a4,32
    800062ae:	c705                	beqz	a4,800062d6 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800062b0:	01f7f713          	andi	a4,a5,31
    800062b4:	9752                	add	a4,a4,s4
    800062b6:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800062ba:	0785                	addi	a5,a5,1
    800062bc:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800062be:	8526                	mv	a0,s1
    800062c0:	ffffb097          	auipc	ra,0xffffb
    800062c4:	2c0080e7          	jalr	704(ra) # 80001580 <wakeup>
    
    WriteReg(THR, c);
    800062c8:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800062cc:	609c                	ld	a5,0(s1)
    800062ce:	0009b703          	ld	a4,0(s3)
    800062d2:	fcf71ae3          	bne	a4,a5,800062a6 <uartstart+0x42>
  }
}
    800062d6:	70e2                	ld	ra,56(sp)
    800062d8:	7442                	ld	s0,48(sp)
    800062da:	74a2                	ld	s1,40(sp)
    800062dc:	7902                	ld	s2,32(sp)
    800062de:	69e2                	ld	s3,24(sp)
    800062e0:	6a42                	ld	s4,16(sp)
    800062e2:	6aa2                	ld	s5,8(sp)
    800062e4:	6121                	addi	sp,sp,64
    800062e6:	8082                	ret
    800062e8:	8082                	ret

00000000800062ea <uartputc>:
{
    800062ea:	7179                	addi	sp,sp,-48
    800062ec:	f406                	sd	ra,40(sp)
    800062ee:	f022                	sd	s0,32(sp)
    800062f0:	ec26                	sd	s1,24(sp)
    800062f2:	e84a                	sd	s2,16(sp)
    800062f4:	e44e                	sd	s3,8(sp)
    800062f6:	e052                	sd	s4,0(sp)
    800062f8:	1800                	addi	s0,sp,48
    800062fa:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800062fc:	00028517          	auipc	a0,0x28
    80006300:	a0c50513          	addi	a0,a0,-1524 # 8002dd08 <uart_tx_lock>
    80006304:	00000097          	auipc	ra,0x0
    80006308:	1a0080e7          	jalr	416(ra) # 800064a4 <acquire>
  if(panicked){
    8000630c:	00002797          	auipc	a5,0x2
    80006310:	5b07a783          	lw	a5,1456(a5) # 800088bc <panicked>
    80006314:	e7c9                	bnez	a5,8000639e <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006316:	00002717          	auipc	a4,0x2
    8000631a:	5b273703          	ld	a4,1458(a4) # 800088c8 <uart_tx_w>
    8000631e:	00002797          	auipc	a5,0x2
    80006322:	5a27b783          	ld	a5,1442(a5) # 800088c0 <uart_tx_r>
    80006326:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000632a:	00028997          	auipc	s3,0x28
    8000632e:	9de98993          	addi	s3,s3,-1570 # 8002dd08 <uart_tx_lock>
    80006332:	00002497          	auipc	s1,0x2
    80006336:	58e48493          	addi	s1,s1,1422 # 800088c0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000633a:	00002917          	auipc	s2,0x2
    8000633e:	58e90913          	addi	s2,s2,1422 # 800088c8 <uart_tx_w>
    80006342:	00e79f63          	bne	a5,a4,80006360 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006346:	85ce                	mv	a1,s3
    80006348:	8526                	mv	a0,s1
    8000634a:	ffffb097          	auipc	ra,0xffffb
    8000634e:	1d2080e7          	jalr	466(ra) # 8000151c <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006352:	00093703          	ld	a4,0(s2)
    80006356:	609c                	ld	a5,0(s1)
    80006358:	02078793          	addi	a5,a5,32
    8000635c:	fee785e3          	beq	a5,a4,80006346 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006360:	00028497          	auipc	s1,0x28
    80006364:	9a848493          	addi	s1,s1,-1624 # 8002dd08 <uart_tx_lock>
    80006368:	01f77793          	andi	a5,a4,31
    8000636c:	97a6                	add	a5,a5,s1
    8000636e:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006372:	0705                	addi	a4,a4,1
    80006374:	00002797          	auipc	a5,0x2
    80006378:	54e7ba23          	sd	a4,1364(a5) # 800088c8 <uart_tx_w>
  uartstart();
    8000637c:	00000097          	auipc	ra,0x0
    80006380:	ee8080e7          	jalr	-280(ra) # 80006264 <uartstart>
  release(&uart_tx_lock);
    80006384:	8526                	mv	a0,s1
    80006386:	00000097          	auipc	ra,0x0
    8000638a:	1d2080e7          	jalr	466(ra) # 80006558 <release>
}
    8000638e:	70a2                	ld	ra,40(sp)
    80006390:	7402                	ld	s0,32(sp)
    80006392:	64e2                	ld	s1,24(sp)
    80006394:	6942                	ld	s2,16(sp)
    80006396:	69a2                	ld	s3,8(sp)
    80006398:	6a02                	ld	s4,0(sp)
    8000639a:	6145                	addi	sp,sp,48
    8000639c:	8082                	ret
    for(;;)
    8000639e:	a001                	j	8000639e <uartputc+0xb4>

00000000800063a0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800063a0:	1141                	addi	sp,sp,-16
    800063a2:	e422                	sd	s0,8(sp)
    800063a4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800063a6:	100007b7          	lui	a5,0x10000
    800063aa:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800063ae:	8b85                	andi	a5,a5,1
    800063b0:	cb81                	beqz	a5,800063c0 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800063b2:	100007b7          	lui	a5,0x10000
    800063b6:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800063ba:	6422                	ld	s0,8(sp)
    800063bc:	0141                	addi	sp,sp,16
    800063be:	8082                	ret
    return -1;
    800063c0:	557d                	li	a0,-1
    800063c2:	bfe5                	j	800063ba <uartgetc+0x1a>

00000000800063c4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800063c4:	1101                	addi	sp,sp,-32
    800063c6:	ec06                	sd	ra,24(sp)
    800063c8:	e822                	sd	s0,16(sp)
    800063ca:	e426                	sd	s1,8(sp)
    800063cc:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800063ce:	54fd                	li	s1,-1
    800063d0:	a029                	j	800063da <uartintr+0x16>
      break;
    consoleintr(c);
    800063d2:	00000097          	auipc	ra,0x0
    800063d6:	918080e7          	jalr	-1768(ra) # 80005cea <consoleintr>
    int c = uartgetc();
    800063da:	00000097          	auipc	ra,0x0
    800063de:	fc6080e7          	jalr	-58(ra) # 800063a0 <uartgetc>
    if(c == -1)
    800063e2:	fe9518e3          	bne	a0,s1,800063d2 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800063e6:	00028497          	auipc	s1,0x28
    800063ea:	92248493          	addi	s1,s1,-1758 # 8002dd08 <uart_tx_lock>
    800063ee:	8526                	mv	a0,s1
    800063f0:	00000097          	auipc	ra,0x0
    800063f4:	0b4080e7          	jalr	180(ra) # 800064a4 <acquire>
  uartstart();
    800063f8:	00000097          	auipc	ra,0x0
    800063fc:	e6c080e7          	jalr	-404(ra) # 80006264 <uartstart>
  release(&uart_tx_lock);
    80006400:	8526                	mv	a0,s1
    80006402:	00000097          	auipc	ra,0x0
    80006406:	156080e7          	jalr	342(ra) # 80006558 <release>
}
    8000640a:	60e2                	ld	ra,24(sp)
    8000640c:	6442                	ld	s0,16(sp)
    8000640e:	64a2                	ld	s1,8(sp)
    80006410:	6105                	addi	sp,sp,32
    80006412:	8082                	ret

0000000080006414 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006414:	1141                	addi	sp,sp,-16
    80006416:	e422                	sd	s0,8(sp)
    80006418:	0800                	addi	s0,sp,16
  lk->name = name;
    8000641a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000641c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006420:	00053823          	sd	zero,16(a0)
}
    80006424:	6422                	ld	s0,8(sp)
    80006426:	0141                	addi	sp,sp,16
    80006428:	8082                	ret

000000008000642a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000642a:	411c                	lw	a5,0(a0)
    8000642c:	e399                	bnez	a5,80006432 <holding+0x8>
    8000642e:	4501                	li	a0,0
  return r;
}
    80006430:	8082                	ret
{
    80006432:	1101                	addi	sp,sp,-32
    80006434:	ec06                	sd	ra,24(sp)
    80006436:	e822                	sd	s0,16(sp)
    80006438:	e426                	sd	s1,8(sp)
    8000643a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000643c:	6904                	ld	s1,16(a0)
    8000643e:	ffffb097          	auipc	ra,0xffffb
    80006442:	9e0080e7          	jalr	-1568(ra) # 80000e1e <mycpu>
    80006446:	40a48533          	sub	a0,s1,a0
    8000644a:	00153513          	seqz	a0,a0
}
    8000644e:	60e2                	ld	ra,24(sp)
    80006450:	6442                	ld	s0,16(sp)
    80006452:	64a2                	ld	s1,8(sp)
    80006454:	6105                	addi	sp,sp,32
    80006456:	8082                	ret

0000000080006458 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006458:	1101                	addi	sp,sp,-32
    8000645a:	ec06                	sd	ra,24(sp)
    8000645c:	e822                	sd	s0,16(sp)
    8000645e:	e426                	sd	s1,8(sp)
    80006460:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006462:	100024f3          	csrr	s1,sstatus
    80006466:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000646a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000646c:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006470:	ffffb097          	auipc	ra,0xffffb
    80006474:	9ae080e7          	jalr	-1618(ra) # 80000e1e <mycpu>
    80006478:	5d3c                	lw	a5,120(a0)
    8000647a:	cf89                	beqz	a5,80006494 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000647c:	ffffb097          	auipc	ra,0xffffb
    80006480:	9a2080e7          	jalr	-1630(ra) # 80000e1e <mycpu>
    80006484:	5d3c                	lw	a5,120(a0)
    80006486:	2785                	addiw	a5,a5,1
    80006488:	dd3c                	sw	a5,120(a0)
}
    8000648a:	60e2                	ld	ra,24(sp)
    8000648c:	6442                	ld	s0,16(sp)
    8000648e:	64a2                	ld	s1,8(sp)
    80006490:	6105                	addi	sp,sp,32
    80006492:	8082                	ret
    mycpu()->intena = old;
    80006494:	ffffb097          	auipc	ra,0xffffb
    80006498:	98a080e7          	jalr	-1654(ra) # 80000e1e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000649c:	8085                	srli	s1,s1,0x1
    8000649e:	8885                	andi	s1,s1,1
    800064a0:	dd64                	sw	s1,124(a0)
    800064a2:	bfe9                	j	8000647c <push_off+0x24>

00000000800064a4 <acquire>:
{
    800064a4:	1101                	addi	sp,sp,-32
    800064a6:	ec06                	sd	ra,24(sp)
    800064a8:	e822                	sd	s0,16(sp)
    800064aa:	e426                	sd	s1,8(sp)
    800064ac:	1000                	addi	s0,sp,32
    800064ae:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800064b0:	00000097          	auipc	ra,0x0
    800064b4:	fa8080e7          	jalr	-88(ra) # 80006458 <push_off>
  if(holding(lk))
    800064b8:	8526                	mv	a0,s1
    800064ba:	00000097          	auipc	ra,0x0
    800064be:	f70080e7          	jalr	-144(ra) # 8000642a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800064c2:	4705                	li	a4,1
  if(holding(lk))
    800064c4:	e115                	bnez	a0,800064e8 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800064c6:	87ba                	mv	a5,a4
    800064c8:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800064cc:	2781                	sext.w	a5,a5
    800064ce:	ffe5                	bnez	a5,800064c6 <acquire+0x22>
  __sync_synchronize();
    800064d0:	0ff0000f          	fence
  lk->cpu = mycpu();
    800064d4:	ffffb097          	auipc	ra,0xffffb
    800064d8:	94a080e7          	jalr	-1718(ra) # 80000e1e <mycpu>
    800064dc:	e888                	sd	a0,16(s1)
}
    800064de:	60e2                	ld	ra,24(sp)
    800064e0:	6442                	ld	s0,16(sp)
    800064e2:	64a2                	ld	s1,8(sp)
    800064e4:	6105                	addi	sp,sp,32
    800064e6:	8082                	ret
    panic("acquire");
    800064e8:	00002517          	auipc	a0,0x2
    800064ec:	31050513          	addi	a0,a0,784 # 800087f8 <digits+0x20>
    800064f0:	00000097          	auipc	ra,0x0
    800064f4:	a7c080e7          	jalr	-1412(ra) # 80005f6c <panic>

00000000800064f8 <pop_off>:

void
pop_off(void)
{
    800064f8:	1141                	addi	sp,sp,-16
    800064fa:	e406                	sd	ra,8(sp)
    800064fc:	e022                	sd	s0,0(sp)
    800064fe:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006500:	ffffb097          	auipc	ra,0xffffb
    80006504:	91e080e7          	jalr	-1762(ra) # 80000e1e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006508:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000650c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000650e:	e78d                	bnez	a5,80006538 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006510:	5d3c                	lw	a5,120(a0)
    80006512:	02f05b63          	blez	a5,80006548 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006516:	37fd                	addiw	a5,a5,-1
    80006518:	0007871b          	sext.w	a4,a5
    8000651c:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000651e:	eb09                	bnez	a4,80006530 <pop_off+0x38>
    80006520:	5d7c                	lw	a5,124(a0)
    80006522:	c799                	beqz	a5,80006530 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006524:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006528:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000652c:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006530:	60a2                	ld	ra,8(sp)
    80006532:	6402                	ld	s0,0(sp)
    80006534:	0141                	addi	sp,sp,16
    80006536:	8082                	ret
    panic("pop_off - interruptible");
    80006538:	00002517          	auipc	a0,0x2
    8000653c:	2c850513          	addi	a0,a0,712 # 80008800 <digits+0x28>
    80006540:	00000097          	auipc	ra,0x0
    80006544:	a2c080e7          	jalr	-1492(ra) # 80005f6c <panic>
    panic("pop_off");
    80006548:	00002517          	auipc	a0,0x2
    8000654c:	2d050513          	addi	a0,a0,720 # 80008818 <digits+0x40>
    80006550:	00000097          	auipc	ra,0x0
    80006554:	a1c080e7          	jalr	-1508(ra) # 80005f6c <panic>

0000000080006558 <release>:
{
    80006558:	1101                	addi	sp,sp,-32
    8000655a:	ec06                	sd	ra,24(sp)
    8000655c:	e822                	sd	s0,16(sp)
    8000655e:	e426                	sd	s1,8(sp)
    80006560:	1000                	addi	s0,sp,32
    80006562:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006564:	00000097          	auipc	ra,0x0
    80006568:	ec6080e7          	jalr	-314(ra) # 8000642a <holding>
    8000656c:	c115                	beqz	a0,80006590 <release+0x38>
  lk->cpu = 0;
    8000656e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006572:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006576:	0f50000f          	fence	iorw,ow
    8000657a:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000657e:	00000097          	auipc	ra,0x0
    80006582:	f7a080e7          	jalr	-134(ra) # 800064f8 <pop_off>
}
    80006586:	60e2                	ld	ra,24(sp)
    80006588:	6442                	ld	s0,16(sp)
    8000658a:	64a2                	ld	s1,8(sp)
    8000658c:	6105                	addi	sp,sp,32
    8000658e:	8082                	ret
    panic("release");
    80006590:	00002517          	auipc	a0,0x2
    80006594:	29050513          	addi	a0,a0,656 # 80008820 <digits+0x48>
    80006598:	00000097          	auipc	ra,0x0
    8000659c:	9d4080e7          	jalr	-1580(ra) # 80005f6c <panic>
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
