
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	89013103          	ld	sp,-1904(sp) # 80008890 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	6c2050ef          	jal	ra,800056d8 <start>

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
    80000034:	d2078793          	addi	a5,a5,-736 # 80021d50 <end>
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
    80000054:	89090913          	addi	s2,s2,-1904 # 800088e0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	06a080e7          	jalr	106(ra) # 800060c4 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	10a080e7          	jalr	266(ra) # 80006178 <release>
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
    8000008e:	b02080e7          	jalr	-1278(ra) # 80005b8c <panic>

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
    800000f2:	7f250513          	addi	a0,a0,2034 # 800088e0 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	f3e080e7          	jalr	-194(ra) # 80006034 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00022517          	auipc	a0,0x22
    80000106:	c4e50513          	addi	a0,a0,-946 # 80021d50 <end>
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
    80000128:	7bc48493          	addi	s1,s1,1980 # 800088e0 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	f96080e7          	jalr	-106(ra) # 800060c4 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00008517          	auipc	a0,0x8
    80000140:	7a450513          	addi	a0,a0,1956 # 800088e0 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	032080e7          	jalr	50(ra) # 80006178 <release>

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
    8000016c:	77850513          	addi	a0,a0,1912 # 800088e0 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	008080e7          	jalr	8(ra) # 80006178 <release>
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
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdd2b1>
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
    80000334:	58070713          	addi	a4,a4,1408 # 800088b0 <started>
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
    8000035a:	880080e7          	jalr	-1920(ra) # 80005bd6 <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00001097          	auipc	ra,0x1
    8000036a:	78c080e7          	jalr	1932(ra) # 80001af2 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	d22080e7          	jalr	-734(ra) # 80005090 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	fd4080e7          	jalr	-44(ra) # 8000134a <scheduler>
    consoleinit();
    8000037e:	00005097          	auipc	ra,0x5
    80000382:	71e080e7          	jalr	1822(ra) # 80005a9c <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	a30080e7          	jalr	-1488(ra) # 80005db6 <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	840080e7          	jalr	-1984(ra) # 80005bd6 <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	830080e7          	jalr	-2000(ra) # 80005bd6 <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	820080e7          	jalr	-2016(ra) # 80005bd6 <printf>
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
    800003f2:	c8c080e7          	jalr	-884(ra) # 8000507a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	c9a080e7          	jalr	-870(ra) # 80005090 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	e30080e7          	jalr	-464(ra) # 8000222e <binit>
    iinit();         // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	4d0080e7          	jalr	1232(ra) # 800028d6 <iinit>
    fileinit();      // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	476080e7          	jalr	1142(ra) # 80003884 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	d82080e7          	jalr	-638(ra) # 80005198 <virtio_disk_init>
    userinit();      // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	d0e080e7          	jalr	-754(ra) # 8000112c <userinit>
    __sync_synchronize();
    80000426:	0ff0000f          	fence
    started = 1;
    8000042a:	4785                	li	a5,1
    8000042c:	00008717          	auipc	a4,0x8
    80000430:	48f72223          	sw	a5,1156(a4) # 800088b0 <started>
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
    80000444:	4787b783          	ld	a5,1144(a5) # 800088b8 <kernel_pagetable>
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
    8000048c:	00005097          	auipc	ra,0x5
    80000490:	700080e7          	jalr	1792(ra) # 80005b8c <panic>
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
    800004be:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdd2a7>
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
    800005b6:	5da080e7          	jalr	1498(ra) # 80005b8c <panic>
      panic("mappages: remap");
    800005ba:	00008517          	auipc	a0,0x8
    800005be:	aae50513          	addi	a0,a0,-1362 # 80008068 <etext+0x68>
    800005c2:	00005097          	auipc	ra,0x5
    800005c6:	5ca080e7          	jalr	1482(ra) # 80005b8c <panic>
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
    80000612:	57e080e7          	jalr	1406(ra) # 80005b8c <panic>

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
    80000700:	1aa7be23          	sd	a0,444(a5) # 800088b8 <kernel_pagetable>
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
    8000075e:	432080e7          	jalr	1074(ra) # 80005b8c <panic>
      panic("uvmunmap: walk");
    80000762:	00008517          	auipc	a0,0x8
    80000766:	93650513          	addi	a0,a0,-1738 # 80008098 <etext+0x98>
    8000076a:	00005097          	auipc	ra,0x5
    8000076e:	422080e7          	jalr	1058(ra) # 80005b8c <panic>
      panic("uvmunmap: not mapped");
    80000772:	00008517          	auipc	a0,0x8
    80000776:	93650513          	addi	a0,a0,-1738 # 800080a8 <etext+0xa8>
    8000077a:	00005097          	auipc	ra,0x5
    8000077e:	412080e7          	jalr	1042(ra) # 80005b8c <panic>
      panic("uvmunmap: not a leaf");
    80000782:	00008517          	auipc	a0,0x8
    80000786:	93e50513          	addi	a0,a0,-1730 # 800080c0 <etext+0xc0>
    8000078a:	00005097          	auipc	ra,0x5
    8000078e:	402080e7          	jalr	1026(ra) # 80005b8c <panic>
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
    8000086c:	324080e7          	jalr	804(ra) # 80005b8c <panic>

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
    800009b8:	1d8080e7          	jalr	472(ra) # 80005b8c <panic>
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
    80000a96:	0fa080e7          	jalr	250(ra) # 80005b8c <panic>
      panic("uvmcopy: page not present");
    80000a9a:	00007517          	auipc	a0,0x7
    80000a9e:	68e50513          	addi	a0,a0,1678 # 80008128 <etext+0x128>
    80000aa2:	00005097          	auipc	ra,0x5
    80000aa6:	0ea080e7          	jalr	234(ra) # 80005b8c <panic>
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
    80000b10:	080080e7          	jalr	128(ra) # 80005b8c <panic>

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
    80000cb4:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdd2b0>
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
    80000cf8:	03c48493          	addi	s1,s1,60 # 80008d30 <proc>
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
    80000d0e:	0000ea17          	auipc	s4,0xe
    80000d12:	a22a0a13          	addi	s4,s4,-1502 # 8000e730 <tickslock>
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
    80000d70:	e20080e7          	jalr	-480(ra) # 80005b8c <panic>

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
    80000d94:	b7050513          	addi	a0,a0,-1168 # 80008900 <pid_lock>
    80000d98:	00005097          	auipc	ra,0x5
    80000d9c:	29c080e7          	jalr	668(ra) # 80006034 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000da0:	00007597          	auipc	a1,0x7
    80000da4:	3c858593          	addi	a1,a1,968 # 80008168 <etext+0x168>
    80000da8:	00008517          	auipc	a0,0x8
    80000dac:	b7050513          	addi	a0,a0,-1168 # 80008918 <wait_lock>
    80000db0:	00005097          	auipc	ra,0x5
    80000db4:	284080e7          	jalr	644(ra) # 80006034 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db8:	00008497          	auipc	s1,0x8
    80000dbc:	f7848493          	addi	s1,s1,-136 # 80008d30 <proc>
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
    80000dda:	0000e997          	auipc	s3,0xe
    80000dde:	95698993          	addi	s3,s3,-1706 # 8000e730 <tickslock>
      initlock(&p->lock, "proc");
    80000de2:	85da                	mv	a1,s6
    80000de4:	8526                	mv	a0,s1
    80000de6:	00005097          	auipc	ra,0x5
    80000dea:	24e080e7          	jalr	590(ra) # 80006034 <initlock>
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
    80000e48:	aec50513          	addi	a0,a0,-1300 # 80008930 <cpus>
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
    80000e62:	21a080e7          	jalr	538(ra) # 80006078 <push_off>
    80000e66:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e68:	2781                	sext.w	a5,a5
    80000e6a:	079e                	slli	a5,a5,0x7
    80000e6c:	00008717          	auipc	a4,0x8
    80000e70:	a9470713          	addi	a4,a4,-1388 # 80008900 <pid_lock>
    80000e74:	97ba                	add	a5,a5,a4
    80000e76:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e78:	00005097          	auipc	ra,0x5
    80000e7c:	2a0080e7          	jalr	672(ra) # 80006118 <pop_off>
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
    80000ea0:	2dc080e7          	jalr	732(ra) # 80006178 <release>

  if (first) {
    80000ea4:	00008797          	auipc	a5,0x8
    80000ea8:	99c7a783          	lw	a5,-1636(a5) # 80008840 <first.1>
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
    80000ec2:	9807a123          	sw	zero,-1662(a5) # 80008840 <first.1>
    fsinit(ROOTDEV);
    80000ec6:	4505                	li	a0,1
    80000ec8:	00002097          	auipc	ra,0x2
    80000ecc:	98e080e7          	jalr	-1650(ra) # 80002856 <fsinit>
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
    80000ee2:	a2290913          	addi	s2,s2,-1502 # 80008900 <pid_lock>
    80000ee6:	854a                	mv	a0,s2
    80000ee8:	00005097          	auipc	ra,0x5
    80000eec:	1dc080e7          	jalr	476(ra) # 800060c4 <acquire>
  pid = nextpid;
    80000ef0:	00008797          	auipc	a5,0x8
    80000ef4:	95478793          	addi	a5,a5,-1708 # 80008844 <nextpid>
    80000ef8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000efa:	0014871b          	addiw	a4,s1,1
    80000efe:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f00:	854a                	mv	a0,s2
    80000f02:	00005097          	auipc	ra,0x5
    80000f06:	276080e7          	jalr	630(ra) # 80006178 <release>
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
    8000106e:	cc648493          	addi	s1,s1,-826 # 80008d30 <proc>
    80001072:	0000d917          	auipc	s2,0xd
    80001076:	6be90913          	addi	s2,s2,1726 # 8000e730 <tickslock>
    acquire(&p->lock);
    8000107a:	8526                	mv	a0,s1
    8000107c:	00005097          	auipc	ra,0x5
    80001080:	048080e7          	jalr	72(ra) # 800060c4 <acquire>
    if(p->state == UNUSED) {
    80001084:	4c9c                	lw	a5,24(s1)
    80001086:	cf81                	beqz	a5,8000109e <allocproc+0x40>
      release(&p->lock);
    80001088:	8526                	mv	a0,s1
    8000108a:	00005097          	auipc	ra,0x5
    8000108e:	0ee080e7          	jalr	238(ra) # 80006178 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001092:	16848493          	addi	s1,s1,360
    80001096:	ff2492e3          	bne	s1,s2,8000107a <allocproc+0x1c>
  return 0;
    8000109a:	4481                	li	s1,0
    8000109c:	a889                	j	800010ee <allocproc+0x90>
  p->pid = allocpid();
    8000109e:	00000097          	auipc	ra,0x0
    800010a2:	e34080e7          	jalr	-460(ra) # 80000ed2 <allocpid>
    800010a6:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010a8:	4785                	li	a5,1
    800010aa:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010ac:	fffff097          	auipc	ra,0xfffff
    800010b0:	06e080e7          	jalr	110(ra) # 8000011a <kalloc>
    800010b4:	892a                	mv	s2,a0
    800010b6:	eca8                	sd	a0,88(s1)
    800010b8:	c131                	beqz	a0,800010fc <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010ba:	8526                	mv	a0,s1
    800010bc:	00000097          	auipc	ra,0x0
    800010c0:	e5c080e7          	jalr	-420(ra) # 80000f18 <proc_pagetable>
    800010c4:	892a                	mv	s2,a0
    800010c6:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010c8:	c531                	beqz	a0,80001114 <allocproc+0xb6>
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
}
    800010ee:	8526                	mv	a0,s1
    800010f0:	60e2                	ld	ra,24(sp)
    800010f2:	6442                	ld	s0,16(sp)
    800010f4:	64a2                	ld	s1,8(sp)
    800010f6:	6902                	ld	s2,0(sp)
    800010f8:	6105                	addi	sp,sp,32
    800010fa:	8082                	ret
    freeproc(p);
    800010fc:	8526                	mv	a0,s1
    800010fe:	00000097          	auipc	ra,0x0
    80001102:	f08080e7          	jalr	-248(ra) # 80001006 <freeproc>
    release(&p->lock);
    80001106:	8526                	mv	a0,s1
    80001108:	00005097          	auipc	ra,0x5
    8000110c:	070080e7          	jalr	112(ra) # 80006178 <release>
    return 0;
    80001110:	84ca                	mv	s1,s2
    80001112:	bff1                	j	800010ee <allocproc+0x90>
    freeproc(p);
    80001114:	8526                	mv	a0,s1
    80001116:	00000097          	auipc	ra,0x0
    8000111a:	ef0080e7          	jalr	-272(ra) # 80001006 <freeproc>
    release(&p->lock);
    8000111e:	8526                	mv	a0,s1
    80001120:	00005097          	auipc	ra,0x5
    80001124:	058080e7          	jalr	88(ra) # 80006178 <release>
    return 0;
    80001128:	84ca                	mv	s1,s2
    8000112a:	b7d1                	j	800010ee <allocproc+0x90>

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
    80001144:	78a7b023          	sd	a0,1920(a5) # 800088c0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001148:	03400613          	li	a2,52
    8000114c:	00007597          	auipc	a1,0x7
    80001150:	70458593          	addi	a1,a1,1796 # 80008850 <initcode>
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
    8000118e:	0f6080e7          	jalr	246(ra) # 80003280 <namei>
    80001192:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001196:	478d                	li	a5,3
    80001198:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000119a:	8526                	mv	a0,s1
    8000119c:	00005097          	auipc	ra,0x5
    800011a0:	fdc080e7          	jalr	-36(ra) # 80006178 <release>
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
    800012a6:	ed6080e7          	jalr	-298(ra) # 80006178 <release>
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
    800012be:	65c080e7          	jalr	1628(ra) # 80003916 <filedup>
    800012c2:	00a93023          	sd	a0,0(s2)
    800012c6:	b7e5                	j	800012ae <fork+0xa4>
  np->cwd = idup(p->cwd);
    800012c8:	150ab503          	ld	a0,336(s5)
    800012cc:	00001097          	auipc	ra,0x1
    800012d0:	7ca080e7          	jalr	1994(ra) # 80002a96 <idup>
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
    800012f4:	e88080e7          	jalr	-376(ra) # 80006178 <release>
  acquire(&wait_lock);
    800012f8:	00007497          	auipc	s1,0x7
    800012fc:	62048493          	addi	s1,s1,1568 # 80008918 <wait_lock>
    80001300:	8526                	mv	a0,s1
    80001302:	00005097          	auipc	ra,0x5
    80001306:	dc2080e7          	jalr	-574(ra) # 800060c4 <acquire>
  np->parent = p;
    8000130a:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000130e:	8526                	mv	a0,s1
    80001310:	00005097          	auipc	ra,0x5
    80001314:	e68080e7          	jalr	-408(ra) # 80006178 <release>
  acquire(&np->lock);
    80001318:	8552                	mv	a0,s4
    8000131a:	00005097          	auipc	ra,0x5
    8000131e:	daa080e7          	jalr	-598(ra) # 800060c4 <acquire>
  np->state = RUNNABLE;
    80001322:	478d                	li	a5,3
    80001324:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001328:	8552                	mv	a0,s4
    8000132a:	00005097          	auipc	ra,0x5
    8000132e:	e4e080e7          	jalr	-434(ra) # 80006178 <release>
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
    8000136a:	59a70713          	addi	a4,a4,1434 # 80008900 <pid_lock>
    8000136e:	9756                	add	a4,a4,s5
    80001370:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001374:	00007717          	auipc	a4,0x7
    80001378:	5c470713          	addi	a4,a4,1476 # 80008938 <cpus+0x8>
    8000137c:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000137e:	498d                	li	s3,3
        p->state = RUNNING;
    80001380:	4b11                	li	s6,4
        c->proc = p;
    80001382:	079e                	slli	a5,a5,0x7
    80001384:	00007a17          	auipc	s4,0x7
    80001388:	57ca0a13          	addi	s4,s4,1404 # 80008900 <pid_lock>
    8000138c:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000138e:	0000d917          	auipc	s2,0xd
    80001392:	3a290913          	addi	s2,s2,930 # 8000e730 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001396:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000139a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000139e:	10079073          	csrw	sstatus,a5
    800013a2:	00008497          	auipc	s1,0x8
    800013a6:	98e48493          	addi	s1,s1,-1650 # 80008d30 <proc>
    800013aa:	a811                	j	800013be <scheduler+0x74>
      release(&p->lock);
    800013ac:	8526                	mv	a0,s1
    800013ae:	00005097          	auipc	ra,0x5
    800013b2:	dca080e7          	jalr	-566(ra) # 80006178 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013b6:	16848493          	addi	s1,s1,360
    800013ba:	fd248ee3          	beq	s1,s2,80001396 <scheduler+0x4c>
      acquire(&p->lock);
    800013be:	8526                	mv	a0,s1
    800013c0:	00005097          	auipc	ra,0x5
    800013c4:	d04080e7          	jalr	-764(ra) # 800060c4 <acquire>
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
    80001406:	c48080e7          	jalr	-952(ra) # 8000604a <holding>
    8000140a:	c93d                	beqz	a0,80001480 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000140c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000140e:	2781                	sext.w	a5,a5
    80001410:	079e                	slli	a5,a5,0x7
    80001412:	00007717          	auipc	a4,0x7
    80001416:	4ee70713          	addi	a4,a4,1262 # 80008900 <pid_lock>
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
    8000143c:	4c890913          	addi	s2,s2,1224 # 80008900 <pid_lock>
    80001440:	2781                	sext.w	a5,a5
    80001442:	079e                	slli	a5,a5,0x7
    80001444:	97ca                	add	a5,a5,s2
    80001446:	0ac7a983          	lw	s3,172(a5)
    8000144a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000144c:	2781                	sext.w	a5,a5
    8000144e:	079e                	slli	a5,a5,0x7
    80001450:	00007597          	auipc	a1,0x7
    80001454:	4e858593          	addi	a1,a1,1256 # 80008938 <cpus+0x8>
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
    80001488:	00004097          	auipc	ra,0x4
    8000148c:	704080e7          	jalr	1796(ra) # 80005b8c <panic>
    panic("sched locks");
    80001490:	00007517          	auipc	a0,0x7
    80001494:	d1850513          	addi	a0,a0,-744 # 800081a8 <etext+0x1a8>
    80001498:	00004097          	auipc	ra,0x4
    8000149c:	6f4080e7          	jalr	1780(ra) # 80005b8c <panic>
    panic("sched running");
    800014a0:	00007517          	auipc	a0,0x7
    800014a4:	d1850513          	addi	a0,a0,-744 # 800081b8 <etext+0x1b8>
    800014a8:	00004097          	auipc	ra,0x4
    800014ac:	6e4080e7          	jalr	1764(ra) # 80005b8c <panic>
    panic("sched interruptible");
    800014b0:	00007517          	auipc	a0,0x7
    800014b4:	d1850513          	addi	a0,a0,-744 # 800081c8 <etext+0x1c8>
    800014b8:	00004097          	auipc	ra,0x4
    800014bc:	6d4080e7          	jalr	1748(ra) # 80005b8c <panic>

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
    800014d8:	bf0080e7          	jalr	-1040(ra) # 800060c4 <acquire>
  p->state = RUNNABLE;
    800014dc:	478d                	li	a5,3
    800014de:	cc9c                	sw	a5,24(s1)
  sched();
    800014e0:	00000097          	auipc	ra,0x0
    800014e4:	f0a080e7          	jalr	-246(ra) # 800013ea <sched>
  release(&p->lock);
    800014e8:	8526                	mv	a0,s1
    800014ea:	00005097          	auipc	ra,0x5
    800014ee:	c8e080e7          	jalr	-882(ra) # 80006178 <release>
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
    8000151c:	bac080e7          	jalr	-1108(ra) # 800060c4 <acquire>
  release(lk);
    80001520:	854a                	mv	a0,s2
    80001522:	00005097          	auipc	ra,0x5
    80001526:	c56080e7          	jalr	-938(ra) # 80006178 <release>

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
    80001544:	c38080e7          	jalr	-968(ra) # 80006178 <release>
  acquire(lk);
    80001548:	854a                	mv	a0,s2
    8000154a:	00005097          	auipc	ra,0x5
    8000154e:	b7a080e7          	jalr	-1158(ra) # 800060c4 <acquire>
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
    80001578:	7bc48493          	addi	s1,s1,1980 # 80008d30 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000157c:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000157e:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001580:	0000d917          	auipc	s2,0xd
    80001584:	1b090913          	addi	s2,s2,432 # 8000e730 <tickslock>
    80001588:	a811                	j	8000159c <wakeup+0x3c>
      }
      release(&p->lock);
    8000158a:	8526                	mv	a0,s1
    8000158c:	00005097          	auipc	ra,0x5
    80001590:	bec080e7          	jalr	-1044(ra) # 80006178 <release>
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
    800015ae:	b1a080e7          	jalr	-1254(ra) # 800060c4 <acquire>
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
    800015ec:	74848493          	addi	s1,s1,1864 # 80008d30 <proc>
      pp->parent = initproc;
    800015f0:	00007a17          	auipc	s4,0x7
    800015f4:	2d0a0a13          	addi	s4,s4,720 # 800088c0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015f8:	0000d997          	auipc	s3,0xd
    800015fc:	13898993          	addi	s3,s3,312 # 8000e730 <tickslock>
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
    80001650:	2747b783          	ld	a5,628(a5) # 800088c0 <initproc>
    80001654:	0d050493          	addi	s1,a0,208
    80001658:	15050913          	addi	s2,a0,336
    8000165c:	02a79363          	bne	a5,a0,80001682 <exit+0x52>
    panic("init exiting");
    80001660:	00007517          	auipc	a0,0x7
    80001664:	b8050513          	addi	a0,a0,-1152 # 800081e0 <etext+0x1e0>
    80001668:	00004097          	auipc	ra,0x4
    8000166c:	524080e7          	jalr	1316(ra) # 80005b8c <panic>
      fileclose(f);
    80001670:	00002097          	auipc	ra,0x2
    80001674:	2f8080e7          	jalr	760(ra) # 80003968 <fileclose>
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
    8000168c:	e18080e7          	jalr	-488(ra) # 800034a0 <begin_op>
  iput(p->cwd);
    80001690:	1509b503          	ld	a0,336(s3)
    80001694:	00001097          	auipc	ra,0x1
    80001698:	5fa080e7          	jalr	1530(ra) # 80002c8e <iput>
  end_op();
    8000169c:	00002097          	auipc	ra,0x2
    800016a0:	e82080e7          	jalr	-382(ra) # 8000351e <end_op>
  p->cwd = 0;
    800016a4:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800016a8:	00007497          	auipc	s1,0x7
    800016ac:	27048493          	addi	s1,s1,624 # 80008918 <wait_lock>
    800016b0:	8526                	mv	a0,s1
    800016b2:	00005097          	auipc	ra,0x5
    800016b6:	a12080e7          	jalr	-1518(ra) # 800060c4 <acquire>
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
    800016d6:	9f2080e7          	jalr	-1550(ra) # 800060c4 <acquire>
  p->xstate = status;
    800016da:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800016de:	4795                	li	a5,5
    800016e0:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800016e4:	8526                	mv	a0,s1
    800016e6:	00005097          	auipc	ra,0x5
    800016ea:	a92080e7          	jalr	-1390(ra) # 80006178 <release>
  sched();
    800016ee:	00000097          	auipc	ra,0x0
    800016f2:	cfc080e7          	jalr	-772(ra) # 800013ea <sched>
  panic("zombie exit");
    800016f6:	00007517          	auipc	a0,0x7
    800016fa:	afa50513          	addi	a0,a0,-1286 # 800081f0 <etext+0x1f0>
    800016fe:	00004097          	auipc	ra,0x4
    80001702:	48e080e7          	jalr	1166(ra) # 80005b8c <panic>

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
    8000171a:	61a48493          	addi	s1,s1,1562 # 80008d30 <proc>
    8000171e:	0000d997          	auipc	s3,0xd
    80001722:	01298993          	addi	s3,s3,18 # 8000e730 <tickslock>
    acquire(&p->lock);
    80001726:	8526                	mv	a0,s1
    80001728:	00005097          	auipc	ra,0x5
    8000172c:	99c080e7          	jalr	-1636(ra) # 800060c4 <acquire>
    if(p->pid == pid){
    80001730:	589c                	lw	a5,48(s1)
    80001732:	01278d63          	beq	a5,s2,8000174c <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001736:	8526                	mv	a0,s1
    80001738:	00005097          	auipc	ra,0x5
    8000173c:	a40080e7          	jalr	-1472(ra) # 80006178 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001740:	16848493          	addi	s1,s1,360
    80001744:	ff3491e3          	bne	s1,s3,80001726 <kill+0x20>
  }
  return -1;
    80001748:	557d                	li	a0,-1
    8000174a:	a829                	j	80001764 <kill+0x5e>
      p->killed = 1;
    8000174c:	4785                	li	a5,1
    8000174e:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001750:	4c98                	lw	a4,24(s1)
    80001752:	4789                	li	a5,2
    80001754:	00f70f63          	beq	a4,a5,80001772 <kill+0x6c>
      release(&p->lock);
    80001758:	8526                	mv	a0,s1
    8000175a:	00005097          	auipc	ra,0x5
    8000175e:	a1e080e7          	jalr	-1506(ra) # 80006178 <release>
      return 0;
    80001762:	4501                	li	a0,0
}
    80001764:	70a2                	ld	ra,40(sp)
    80001766:	7402                	ld	s0,32(sp)
    80001768:	64e2                	ld	s1,24(sp)
    8000176a:	6942                	ld	s2,16(sp)
    8000176c:	69a2                	ld	s3,8(sp)
    8000176e:	6145                	addi	sp,sp,48
    80001770:	8082                	ret
        p->state = RUNNABLE;
    80001772:	478d                	li	a5,3
    80001774:	cc9c                	sw	a5,24(s1)
    80001776:	b7cd                	j	80001758 <kill+0x52>

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
    80001788:	940080e7          	jalr	-1728(ra) # 800060c4 <acquire>
  p->killed = 1;
    8000178c:	4785                	li	a5,1
    8000178e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001790:	8526                	mv	a0,s1
    80001792:	00005097          	auipc	ra,0x5
    80001796:	9e6080e7          	jalr	-1562(ra) # 80006178 <release>
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
    800017b6:	912080e7          	jalr	-1774(ra) # 800060c4 <acquire>
  k = p->killed;
    800017ba:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017be:	8526                	mv	a0,s1
    800017c0:	00005097          	auipc	ra,0x5
    800017c4:	9b8080e7          	jalr	-1608(ra) # 80006178 <release>
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
    800017ee:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800017f0:	fffff097          	auipc	ra,0xfffff
    800017f4:	664080e7          	jalr	1636(ra) # 80000e54 <myproc>
    800017f8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800017fa:	00007517          	auipc	a0,0x7
    800017fe:	11e50513          	addi	a0,a0,286 # 80008918 <wait_lock>
    80001802:	00005097          	auipc	ra,0x5
    80001806:	8c2080e7          	jalr	-1854(ra) # 800060c4 <acquire>
    havekids = 0;
    8000180a:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000180c:	4a15                	li	s4,5
        havekids = 1;
    8000180e:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001810:	0000d997          	auipc	s3,0xd
    80001814:	f2098993          	addi	s3,s3,-224 # 8000e730 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001818:	00007c17          	auipc	s8,0x7
    8000181c:	100c0c13          	addi	s8,s8,256 # 80008918 <wait_lock>
    havekids = 0;
    80001820:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001822:	00007497          	auipc	s1,0x7
    80001826:	50e48493          	addi	s1,s1,1294 # 80008d30 <proc>
    8000182a:	a0bd                	j	80001898 <wait+0xc2>
          pid = pp->pid;
    8000182c:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001830:	000b0e63          	beqz	s6,8000184c <wait+0x76>
    80001834:	4691                	li	a3,4
    80001836:	02c48613          	addi	a2,s1,44
    8000183a:	85da                	mv	a1,s6
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
    8000185c:	920080e7          	jalr	-1760(ra) # 80006178 <release>
          release(&wait_lock);
    80001860:	00007517          	auipc	a0,0x7
    80001864:	0b850513          	addi	a0,a0,184 # 80008918 <wait_lock>
    80001868:	00005097          	auipc	ra,0x5
    8000186c:	910080e7          	jalr	-1776(ra) # 80006178 <release>
          return pid;
    80001870:	a0b5                	j	800018dc <wait+0x106>
            release(&pp->lock);
    80001872:	8526                	mv	a0,s1
    80001874:	00005097          	auipc	ra,0x5
    80001878:	904080e7          	jalr	-1788(ra) # 80006178 <release>
            release(&wait_lock);
    8000187c:	00007517          	auipc	a0,0x7
    80001880:	09c50513          	addi	a0,a0,156 # 80008918 <wait_lock>
    80001884:	00005097          	auipc	ra,0x5
    80001888:	8f4080e7          	jalr	-1804(ra) # 80006178 <release>
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
    800018a4:	824080e7          	jalr	-2012(ra) # 800060c4 <acquire>
        if(pp->state == ZOMBIE){
    800018a8:	4c9c                	lw	a5,24(s1)
    800018aa:	f94781e3          	beq	a5,s4,8000182c <wait+0x56>
        release(&pp->lock);
    800018ae:	8526                	mv	a0,s1
    800018b0:	00005097          	auipc	ra,0x5
    800018b4:	8c8080e7          	jalr	-1848(ra) # 80006178 <release>
        havekids = 1;
    800018b8:	8756                	mv	a4,s5
    800018ba:	bfd9                	j	80001890 <wait+0xba>
    if(!havekids || killed(p)){
    800018bc:	c719                	beqz	a4,800018ca <wait+0xf4>
    800018be:	854a                	mv	a0,s2
    800018c0:	00000097          	auipc	ra,0x0
    800018c4:	ee4080e7          	jalr	-284(ra) # 800017a4 <killed>
    800018c8:	c51d                	beqz	a0,800018f6 <wait+0x120>
      release(&wait_lock);
    800018ca:	00007517          	auipc	a0,0x7
    800018ce:	04e50513          	addi	a0,a0,78 # 80008918 <wait_lock>
    800018d2:	00005097          	auipc	ra,0x5
    800018d6:	8a6080e7          	jalr	-1882(ra) # 80006178 <release>
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
    800019d2:	208080e7          	jalr	520(ra) # 80005bd6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019d6:	00007497          	auipc	s1,0x7
    800019da:	4b248493          	addi	s1,s1,1202 # 80008e88 <proc+0x158>
    800019de:	0000d917          	auipc	s2,0xd
    800019e2:	eaa90913          	addi	s2,s2,-342 # 8000e888 <bcache+0x140>
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
    80001a14:	1c6080e7          	jalr	454(ra) # 80005bd6 <printf>
    printf("\n");
    80001a18:	8552                	mv	a0,s4
    80001a1a:	00004097          	auipc	ra,0x4
    80001a1e:	1bc080e7          	jalr	444(ra) # 80005bd6 <printf>
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
    80001ada:	0000d517          	auipc	a0,0xd
    80001ade:	c5650513          	addi	a0,a0,-938 # 8000e730 <tickslock>
    80001ae2:	00004097          	auipc	ra,0x4
    80001ae6:	552080e7          	jalr	1362(ra) # 80006034 <initlock>
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
    80001afc:	4c878793          	addi	a5,a5,1224 # 80004fc0 <kernelvec>
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
    80001baa:	0000d497          	auipc	s1,0xd
    80001bae:	b8648493          	addi	s1,s1,-1146 # 8000e730 <tickslock>
    80001bb2:	8526                	mv	a0,s1
    80001bb4:	00004097          	auipc	ra,0x4
    80001bb8:	510080e7          	jalr	1296(ra) # 800060c4 <acquire>
  ticks++;
    80001bbc:	00007517          	auipc	a0,0x7
    80001bc0:	d0c50513          	addi	a0,a0,-756 # 800088c8 <ticks>
    80001bc4:	411c                	lw	a5,0(a0)
    80001bc6:	2785                	addiw	a5,a5,1
    80001bc8:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bca:	00000097          	auipc	ra,0x0
    80001bce:	996080e7          	jalr	-1642(ra) # 80001560 <wakeup>
  release(&tickslock);
    80001bd2:	8526                	mv	a0,s1
    80001bd4:	00004097          	auipc	ra,0x4
    80001bd8:	5a4080e7          	jalr	1444(ra) # 80006178 <release>
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
    80001c1c:	4b0080e7          	jalr	1200(ra) # 800050c8 <plic_claim>
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
    80001c40:	f9a080e7          	jalr	-102(ra) # 80005bd6 <printf>
      plic_complete(irq);
    80001c44:	8526                	mv	a0,s1
    80001c46:	00003097          	auipc	ra,0x3
    80001c4a:	4a6080e7          	jalr	1190(ra) # 800050ec <plic_complete>
    return 1;
    80001c4e:	4505                	li	a0,1
    80001c50:	bf55                	j	80001c04 <devintr+0x1e>
      uartintr();
    80001c52:	00004097          	auipc	ra,0x4
    80001c56:	392080e7          	jalr	914(ra) # 80005fe4 <uartintr>
    80001c5a:	b7ed                	j	80001c44 <devintr+0x5e>
      virtio_disk_intr();
    80001c5c:	00004097          	auipc	ra,0x4
    80001c60:	958080e7          	jalr	-1704(ra) # 800055b4 <virtio_disk_intr>
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
    80001ca2:	32278793          	addi	a5,a5,802 # 80004fc0 <kernelvec>
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
    80001cec:	ea4080e7          	jalr	-348(ra) # 80005b8c <panic>
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
    80001d66:	e74080e7          	jalr	-396(ra) # 80005bd6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d6a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d6e:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d72:	00006517          	auipc	a0,0x6
    80001d76:	57e50513          	addi	a0,a0,1406 # 800082f0 <states.0+0xa8>
    80001d7a:	00004097          	auipc	ra,0x4
    80001d7e:	e5c080e7          	jalr	-420(ra) # 80005bd6 <printf>
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
    80001df2:	d9e080e7          	jalr	-610(ra) # 80005b8c <panic>
    panic("kerneltrap: interrupts enabled");
    80001df6:	00006517          	auipc	a0,0x6
    80001dfa:	54250513          	addi	a0,a0,1346 # 80008338 <states.0+0xf0>
    80001dfe:	00004097          	auipc	ra,0x4
    80001e02:	d8e080e7          	jalr	-626(ra) # 80005b8c <panic>
    printf("scause %p\n", scause);
    80001e06:	85ce                	mv	a1,s3
    80001e08:	00006517          	auipc	a0,0x6
    80001e0c:	55050513          	addi	a0,a0,1360 # 80008358 <states.0+0x110>
    80001e10:	00004097          	auipc	ra,0x4
    80001e14:	dc6080e7          	jalr	-570(ra) # 80005bd6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e18:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e1c:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e20:	00006517          	auipc	a0,0x6
    80001e24:	54850513          	addi	a0,a0,1352 # 80008368 <states.0+0x120>
    80001e28:	00004097          	auipc	ra,0x4
    80001e2c:	dae080e7          	jalr	-594(ra) # 80005bd6 <printf>
    panic("kerneltrap");
    80001e30:	00006517          	auipc	a0,0x6
    80001e34:	55050513          	addi	a0,a0,1360 # 80008380 <states.0+0x138>
    80001e38:	00004097          	auipc	ra,0x4
    80001e3c:	d54080e7          	jalr	-684(ra) # 80005b8c <panic>
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
  return strlen(buf);
}

static uint64
argraw(int n)
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
    80001ec8:	cc8080e7          	jalr	-824(ra) # 80005b8c <panic>

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
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001ee4:	653c                	ld	a5,72(a0)
    80001ee6:	02f4f863          	bgeu	s1,a5,80001f16 <fetchaddr+0x4a>
    80001eea:	00848713          	addi	a4,s1,8
    80001eee:	02e7e663          	bltu	a5,a4,80001f1a <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
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
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
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
void
argint(int n, int *ip)
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
void
argaddr(int n, uint64 *ip)
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
int
argstr(int n, char *buf, int max)
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
[SYS_close]   sys_close,
};

void
syscall(void)
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
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002004:	37fd                	addiw	a5,a5,-1
    80002006:	4751                	li	a4,20
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
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002026:	15848613          	addi	a2,s1,344
    8000202a:	588c                	lw	a1,48(s1)
    8000202c:	00006517          	auipc	a0,0x6
    80002030:	36c50513          	addi	a0,a0,876 # 80008398 <states.0+0x150>
    80002034:	00004097          	auipc	ra,0x4
    80002038:	ba2080e7          	jalr	-1118(ra) # 80005bd6 <printf>
            p->pid, p->name, num);
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
  acquire(&tickslock);
    80002134:	0000c517          	auipc	a0,0xc
    80002138:	5fc50513          	addi	a0,a0,1532 # 8000e730 <tickslock>
    8000213c:	00004097          	auipc	ra,0x4
    80002140:	f88080e7          	jalr	-120(ra) # 800060c4 <acquire>
  ticks0 = ticks;
    80002144:	00006917          	auipc	s2,0x6
    80002148:	78492903          	lw	s2,1924(s2) # 800088c8 <ticks>
  while(ticks - ticks0 < n){
    8000214c:	fcc42783          	lw	a5,-52(s0)
    80002150:	cf9d                	beqz	a5,8000218e <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002152:	0000c997          	auipc	s3,0xc
    80002156:	5de98993          	addi	s3,s3,1502 # 8000e730 <tickslock>
    8000215a:	00006497          	auipc	s1,0x6
    8000215e:	76e48493          	addi	s1,s1,1902 # 800088c8 <ticks>
    if(killed(myproc())){
    80002162:	fffff097          	auipc	ra,0xfffff
    80002166:	cf2080e7          	jalr	-782(ra) # 80000e54 <myproc>
    8000216a:	fffff097          	auipc	ra,0xfffff
    8000216e:	63a080e7          	jalr	1594(ra) # 800017a4 <killed>
    80002172:	ed15                	bnez	a0,800021ae <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80002174:	85ce                	mv	a1,s3
    80002176:	8526                	mv	a0,s1
    80002178:	fffff097          	auipc	ra,0xfffff
    8000217c:	384080e7          	jalr	900(ra) # 800014fc <sleep>
  while(ticks - ticks0 < n){
    80002180:	409c                	lw	a5,0(s1)
    80002182:	412787bb          	subw	a5,a5,s2
    80002186:	fcc42703          	lw	a4,-52(s0)
    8000218a:	fce7ece3          	bltu	a5,a4,80002162 <sys_sleep+0x4a>
  }
  release(&tickslock);
    8000218e:	0000c517          	auipc	a0,0xc
    80002192:	5a250513          	addi	a0,a0,1442 # 8000e730 <tickslock>
    80002196:	00004097          	auipc	ra,0x4
    8000219a:	fe2080e7          	jalr	-30(ra) # 80006178 <release>
  return 0;
    8000219e:	4501                	li	a0,0
}
    800021a0:	70e2                	ld	ra,56(sp)
    800021a2:	7442                	ld	s0,48(sp)
    800021a4:	74a2                	ld	s1,40(sp)
    800021a6:	7902                	ld	s2,32(sp)
    800021a8:	69e2                	ld	s3,24(sp)
    800021aa:	6121                	addi	sp,sp,64
    800021ac:	8082                	ret
      release(&tickslock);
    800021ae:	0000c517          	auipc	a0,0xc
    800021b2:	58250513          	addi	a0,a0,1410 # 8000e730 <tickslock>
    800021b6:	00004097          	auipc	ra,0x4
    800021ba:	fc2080e7          	jalr	-62(ra) # 80006178 <release>
      return -1;
    800021be:	557d                	li	a0,-1
    800021c0:	b7c5                	j	800021a0 <sys_sleep+0x88>

00000000800021c2 <sys_kill>:

uint64
sys_kill(void)
{
    800021c2:	1101                	addi	sp,sp,-32
    800021c4:	ec06                	sd	ra,24(sp)
    800021c6:	e822                	sd	s0,16(sp)
    800021c8:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800021ca:	fec40593          	addi	a1,s0,-20
    800021ce:	4501                	li	a0,0
    800021d0:	00000097          	auipc	ra,0x0
    800021d4:	d9a080e7          	jalr	-614(ra) # 80001f6a <argint>
  return kill(pid);
    800021d8:	fec42503          	lw	a0,-20(s0)
    800021dc:	fffff097          	auipc	ra,0xfffff
    800021e0:	52a080e7          	jalr	1322(ra) # 80001706 <kill>
}
    800021e4:	60e2                	ld	ra,24(sp)
    800021e6:	6442                	ld	s0,16(sp)
    800021e8:	6105                	addi	sp,sp,32
    800021ea:	8082                	ret

00000000800021ec <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800021ec:	1101                	addi	sp,sp,-32
    800021ee:	ec06                	sd	ra,24(sp)
    800021f0:	e822                	sd	s0,16(sp)
    800021f2:	e426                	sd	s1,8(sp)
    800021f4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800021f6:	0000c517          	auipc	a0,0xc
    800021fa:	53a50513          	addi	a0,a0,1338 # 8000e730 <tickslock>
    800021fe:	00004097          	auipc	ra,0x4
    80002202:	ec6080e7          	jalr	-314(ra) # 800060c4 <acquire>
  xticks = ticks;
    80002206:	00006497          	auipc	s1,0x6
    8000220a:	6c24a483          	lw	s1,1730(s1) # 800088c8 <ticks>
  release(&tickslock);
    8000220e:	0000c517          	auipc	a0,0xc
    80002212:	52250513          	addi	a0,a0,1314 # 8000e730 <tickslock>
    80002216:	00004097          	auipc	ra,0x4
    8000221a:	f62080e7          	jalr	-158(ra) # 80006178 <release>
  return xticks;
}
    8000221e:	02049513          	slli	a0,s1,0x20
    80002222:	9101                	srli	a0,a0,0x20
    80002224:	60e2                	ld	ra,24(sp)
    80002226:	6442                	ld	s0,16(sp)
    80002228:	64a2                	ld	s1,8(sp)
    8000222a:	6105                	addi	sp,sp,32
    8000222c:	8082                	ret

000000008000222e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000222e:	7179                	addi	sp,sp,-48
    80002230:	f406                	sd	ra,40(sp)
    80002232:	f022                	sd	s0,32(sp)
    80002234:	ec26                	sd	s1,24(sp)
    80002236:	e84a                	sd	s2,16(sp)
    80002238:	e44e                	sd	s3,8(sp)
    8000223a:	e052                	sd	s4,0(sp)
    8000223c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000223e:	00006597          	auipc	a1,0x6
    80002242:	24258593          	addi	a1,a1,578 # 80008480 <syscalls+0xb0>
    80002246:	0000c517          	auipc	a0,0xc
    8000224a:	50250513          	addi	a0,a0,1282 # 8000e748 <bcache>
    8000224e:	00004097          	auipc	ra,0x4
    80002252:	de6080e7          	jalr	-538(ra) # 80006034 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002256:	00014797          	auipc	a5,0x14
    8000225a:	4f278793          	addi	a5,a5,1266 # 80016748 <bcache+0x8000>
    8000225e:	00014717          	auipc	a4,0x14
    80002262:	75270713          	addi	a4,a4,1874 # 800169b0 <bcache+0x8268>
    80002266:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000226a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000226e:	0000c497          	auipc	s1,0xc
    80002272:	4f248493          	addi	s1,s1,1266 # 8000e760 <bcache+0x18>
    b->next = bcache.head.next;
    80002276:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002278:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000227a:	00006a17          	auipc	s4,0x6
    8000227e:	20ea0a13          	addi	s4,s4,526 # 80008488 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002282:	2b893783          	ld	a5,696(s2)
    80002286:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002288:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000228c:	85d2                	mv	a1,s4
    8000228e:	01048513          	addi	a0,s1,16
    80002292:	00001097          	auipc	ra,0x1
    80002296:	4c8080e7          	jalr	1224(ra) # 8000375a <initsleeplock>
    bcache.head.next->prev = b;
    8000229a:	2b893783          	ld	a5,696(s2)
    8000229e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800022a0:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022a4:	45848493          	addi	s1,s1,1112
    800022a8:	fd349de3          	bne	s1,s3,80002282 <binit+0x54>
  }
}
    800022ac:	70a2                	ld	ra,40(sp)
    800022ae:	7402                	ld	s0,32(sp)
    800022b0:	64e2                	ld	s1,24(sp)
    800022b2:	6942                	ld	s2,16(sp)
    800022b4:	69a2                	ld	s3,8(sp)
    800022b6:	6a02                	ld	s4,0(sp)
    800022b8:	6145                	addi	sp,sp,48
    800022ba:	8082                	ret

00000000800022bc <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022bc:	7179                	addi	sp,sp,-48
    800022be:	f406                	sd	ra,40(sp)
    800022c0:	f022                	sd	s0,32(sp)
    800022c2:	ec26                	sd	s1,24(sp)
    800022c4:	e84a                	sd	s2,16(sp)
    800022c6:	e44e                	sd	s3,8(sp)
    800022c8:	1800                	addi	s0,sp,48
    800022ca:	892a                	mv	s2,a0
    800022cc:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800022ce:	0000c517          	auipc	a0,0xc
    800022d2:	47a50513          	addi	a0,a0,1146 # 8000e748 <bcache>
    800022d6:	00004097          	auipc	ra,0x4
    800022da:	dee080e7          	jalr	-530(ra) # 800060c4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022de:	00014497          	auipc	s1,0x14
    800022e2:	7224b483          	ld	s1,1826(s1) # 80016a00 <bcache+0x82b8>
    800022e6:	00014797          	auipc	a5,0x14
    800022ea:	6ca78793          	addi	a5,a5,1738 # 800169b0 <bcache+0x8268>
    800022ee:	02f48f63          	beq	s1,a5,8000232c <bread+0x70>
    800022f2:	873e                	mv	a4,a5
    800022f4:	a021                	j	800022fc <bread+0x40>
    800022f6:	68a4                	ld	s1,80(s1)
    800022f8:	02e48a63          	beq	s1,a4,8000232c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800022fc:	449c                	lw	a5,8(s1)
    800022fe:	ff279ce3          	bne	a5,s2,800022f6 <bread+0x3a>
    80002302:	44dc                	lw	a5,12(s1)
    80002304:	ff3799e3          	bne	a5,s3,800022f6 <bread+0x3a>
      b->refcnt++;
    80002308:	40bc                	lw	a5,64(s1)
    8000230a:	2785                	addiw	a5,a5,1
    8000230c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000230e:	0000c517          	auipc	a0,0xc
    80002312:	43a50513          	addi	a0,a0,1082 # 8000e748 <bcache>
    80002316:	00004097          	auipc	ra,0x4
    8000231a:	e62080e7          	jalr	-414(ra) # 80006178 <release>
      acquiresleep(&b->lock);
    8000231e:	01048513          	addi	a0,s1,16
    80002322:	00001097          	auipc	ra,0x1
    80002326:	472080e7          	jalr	1138(ra) # 80003794 <acquiresleep>
      return b;
    8000232a:	a8b9                	j	80002388 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000232c:	00014497          	auipc	s1,0x14
    80002330:	6cc4b483          	ld	s1,1740(s1) # 800169f8 <bcache+0x82b0>
    80002334:	00014797          	auipc	a5,0x14
    80002338:	67c78793          	addi	a5,a5,1660 # 800169b0 <bcache+0x8268>
    8000233c:	00f48863          	beq	s1,a5,8000234c <bread+0x90>
    80002340:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002342:	40bc                	lw	a5,64(s1)
    80002344:	cf81                	beqz	a5,8000235c <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002346:	64a4                	ld	s1,72(s1)
    80002348:	fee49de3          	bne	s1,a4,80002342 <bread+0x86>
  panic("bget: no buffers");
    8000234c:	00006517          	auipc	a0,0x6
    80002350:	14450513          	addi	a0,a0,324 # 80008490 <syscalls+0xc0>
    80002354:	00004097          	auipc	ra,0x4
    80002358:	838080e7          	jalr	-1992(ra) # 80005b8c <panic>
      b->dev = dev;
    8000235c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002360:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002364:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002368:	4785                	li	a5,1
    8000236a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000236c:	0000c517          	auipc	a0,0xc
    80002370:	3dc50513          	addi	a0,a0,988 # 8000e748 <bcache>
    80002374:	00004097          	auipc	ra,0x4
    80002378:	e04080e7          	jalr	-508(ra) # 80006178 <release>
      acquiresleep(&b->lock);
    8000237c:	01048513          	addi	a0,s1,16
    80002380:	00001097          	auipc	ra,0x1
    80002384:	414080e7          	jalr	1044(ra) # 80003794 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002388:	409c                	lw	a5,0(s1)
    8000238a:	cb89                	beqz	a5,8000239c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000238c:	8526                	mv	a0,s1
    8000238e:	70a2                	ld	ra,40(sp)
    80002390:	7402                	ld	s0,32(sp)
    80002392:	64e2                	ld	s1,24(sp)
    80002394:	6942                	ld	s2,16(sp)
    80002396:	69a2                	ld	s3,8(sp)
    80002398:	6145                	addi	sp,sp,48
    8000239a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000239c:	4581                	li	a1,0
    8000239e:	8526                	mv	a0,s1
    800023a0:	00003097          	auipc	ra,0x3
    800023a4:	fe2080e7          	jalr	-30(ra) # 80005382 <virtio_disk_rw>
    b->valid = 1;
    800023a8:	4785                	li	a5,1
    800023aa:	c09c                	sw	a5,0(s1)
  return b;
    800023ac:	b7c5                	j	8000238c <bread+0xd0>

00000000800023ae <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800023ae:	1101                	addi	sp,sp,-32
    800023b0:	ec06                	sd	ra,24(sp)
    800023b2:	e822                	sd	s0,16(sp)
    800023b4:	e426                	sd	s1,8(sp)
    800023b6:	1000                	addi	s0,sp,32
    800023b8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023ba:	0541                	addi	a0,a0,16
    800023bc:	00001097          	auipc	ra,0x1
    800023c0:	472080e7          	jalr	1138(ra) # 8000382e <holdingsleep>
    800023c4:	cd01                	beqz	a0,800023dc <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023c6:	4585                	li	a1,1
    800023c8:	8526                	mv	a0,s1
    800023ca:	00003097          	auipc	ra,0x3
    800023ce:	fb8080e7          	jalr	-72(ra) # 80005382 <virtio_disk_rw>
}
    800023d2:	60e2                	ld	ra,24(sp)
    800023d4:	6442                	ld	s0,16(sp)
    800023d6:	64a2                	ld	s1,8(sp)
    800023d8:	6105                	addi	sp,sp,32
    800023da:	8082                	ret
    panic("bwrite");
    800023dc:	00006517          	auipc	a0,0x6
    800023e0:	0cc50513          	addi	a0,a0,204 # 800084a8 <syscalls+0xd8>
    800023e4:	00003097          	auipc	ra,0x3
    800023e8:	7a8080e7          	jalr	1960(ra) # 80005b8c <panic>

00000000800023ec <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800023ec:	1101                	addi	sp,sp,-32
    800023ee:	ec06                	sd	ra,24(sp)
    800023f0:	e822                	sd	s0,16(sp)
    800023f2:	e426                	sd	s1,8(sp)
    800023f4:	e04a                	sd	s2,0(sp)
    800023f6:	1000                	addi	s0,sp,32
    800023f8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023fa:	01050913          	addi	s2,a0,16
    800023fe:	854a                	mv	a0,s2
    80002400:	00001097          	auipc	ra,0x1
    80002404:	42e080e7          	jalr	1070(ra) # 8000382e <holdingsleep>
    80002408:	c92d                	beqz	a0,8000247a <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000240a:	854a                	mv	a0,s2
    8000240c:	00001097          	auipc	ra,0x1
    80002410:	3de080e7          	jalr	990(ra) # 800037ea <releasesleep>

  acquire(&bcache.lock);
    80002414:	0000c517          	auipc	a0,0xc
    80002418:	33450513          	addi	a0,a0,820 # 8000e748 <bcache>
    8000241c:	00004097          	auipc	ra,0x4
    80002420:	ca8080e7          	jalr	-856(ra) # 800060c4 <acquire>
  b->refcnt--;
    80002424:	40bc                	lw	a5,64(s1)
    80002426:	37fd                	addiw	a5,a5,-1
    80002428:	0007871b          	sext.w	a4,a5
    8000242c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000242e:	eb05                	bnez	a4,8000245e <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002430:	68bc                	ld	a5,80(s1)
    80002432:	64b8                	ld	a4,72(s1)
    80002434:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002436:	64bc                	ld	a5,72(s1)
    80002438:	68b8                	ld	a4,80(s1)
    8000243a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000243c:	00014797          	auipc	a5,0x14
    80002440:	30c78793          	addi	a5,a5,780 # 80016748 <bcache+0x8000>
    80002444:	2b87b703          	ld	a4,696(a5)
    80002448:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000244a:	00014717          	auipc	a4,0x14
    8000244e:	56670713          	addi	a4,a4,1382 # 800169b0 <bcache+0x8268>
    80002452:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002454:	2b87b703          	ld	a4,696(a5)
    80002458:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000245a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000245e:	0000c517          	auipc	a0,0xc
    80002462:	2ea50513          	addi	a0,a0,746 # 8000e748 <bcache>
    80002466:	00004097          	auipc	ra,0x4
    8000246a:	d12080e7          	jalr	-750(ra) # 80006178 <release>
}
    8000246e:	60e2                	ld	ra,24(sp)
    80002470:	6442                	ld	s0,16(sp)
    80002472:	64a2                	ld	s1,8(sp)
    80002474:	6902                	ld	s2,0(sp)
    80002476:	6105                	addi	sp,sp,32
    80002478:	8082                	ret
    panic("brelse");
    8000247a:	00006517          	auipc	a0,0x6
    8000247e:	03650513          	addi	a0,a0,54 # 800084b0 <syscalls+0xe0>
    80002482:	00003097          	auipc	ra,0x3
    80002486:	70a080e7          	jalr	1802(ra) # 80005b8c <panic>

000000008000248a <bpin>:

void
bpin(struct buf *b) {
    8000248a:	1101                	addi	sp,sp,-32
    8000248c:	ec06                	sd	ra,24(sp)
    8000248e:	e822                	sd	s0,16(sp)
    80002490:	e426                	sd	s1,8(sp)
    80002492:	1000                	addi	s0,sp,32
    80002494:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002496:	0000c517          	auipc	a0,0xc
    8000249a:	2b250513          	addi	a0,a0,690 # 8000e748 <bcache>
    8000249e:	00004097          	auipc	ra,0x4
    800024a2:	c26080e7          	jalr	-986(ra) # 800060c4 <acquire>
  b->refcnt++;
    800024a6:	40bc                	lw	a5,64(s1)
    800024a8:	2785                	addiw	a5,a5,1
    800024aa:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024ac:	0000c517          	auipc	a0,0xc
    800024b0:	29c50513          	addi	a0,a0,668 # 8000e748 <bcache>
    800024b4:	00004097          	auipc	ra,0x4
    800024b8:	cc4080e7          	jalr	-828(ra) # 80006178 <release>
}
    800024bc:	60e2                	ld	ra,24(sp)
    800024be:	6442                	ld	s0,16(sp)
    800024c0:	64a2                	ld	s1,8(sp)
    800024c2:	6105                	addi	sp,sp,32
    800024c4:	8082                	ret

00000000800024c6 <bunpin>:

void
bunpin(struct buf *b) {
    800024c6:	1101                	addi	sp,sp,-32
    800024c8:	ec06                	sd	ra,24(sp)
    800024ca:	e822                	sd	s0,16(sp)
    800024cc:	e426                	sd	s1,8(sp)
    800024ce:	1000                	addi	s0,sp,32
    800024d0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024d2:	0000c517          	auipc	a0,0xc
    800024d6:	27650513          	addi	a0,a0,630 # 8000e748 <bcache>
    800024da:	00004097          	auipc	ra,0x4
    800024de:	bea080e7          	jalr	-1046(ra) # 800060c4 <acquire>
  b->refcnt--;
    800024e2:	40bc                	lw	a5,64(s1)
    800024e4:	37fd                	addiw	a5,a5,-1
    800024e6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024e8:	0000c517          	auipc	a0,0xc
    800024ec:	26050513          	addi	a0,a0,608 # 8000e748 <bcache>
    800024f0:	00004097          	auipc	ra,0x4
    800024f4:	c88080e7          	jalr	-888(ra) # 80006178 <release>
}
    800024f8:	60e2                	ld	ra,24(sp)
    800024fa:	6442                	ld	s0,16(sp)
    800024fc:	64a2                	ld	s1,8(sp)
    800024fe:	6105                	addi	sp,sp,32
    80002500:	8082                	ret

0000000080002502 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002502:	1101                	addi	sp,sp,-32
    80002504:	ec06                	sd	ra,24(sp)
    80002506:	e822                	sd	s0,16(sp)
    80002508:	e426                	sd	s1,8(sp)
    8000250a:	e04a                	sd	s2,0(sp)
    8000250c:	1000                	addi	s0,sp,32
    8000250e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002510:	00d5d59b          	srliw	a1,a1,0xd
    80002514:	00015797          	auipc	a5,0x15
    80002518:	9107a783          	lw	a5,-1776(a5) # 80016e24 <sb+0x1c>
    8000251c:	9dbd                	addw	a1,a1,a5
    8000251e:	00000097          	auipc	ra,0x0
    80002522:	d9e080e7          	jalr	-610(ra) # 800022bc <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002526:	0074f713          	andi	a4,s1,7
    8000252a:	4785                	li	a5,1
    8000252c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002530:	14ce                	slli	s1,s1,0x33
    80002532:	90d9                	srli	s1,s1,0x36
    80002534:	00950733          	add	a4,a0,s1
    80002538:	05874703          	lbu	a4,88(a4)
    8000253c:	00e7f6b3          	and	a3,a5,a4
    80002540:	c69d                	beqz	a3,8000256e <bfree+0x6c>
    80002542:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002544:	94aa                	add	s1,s1,a0
    80002546:	fff7c793          	not	a5,a5
    8000254a:	8f7d                	and	a4,a4,a5
    8000254c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002550:	00001097          	auipc	ra,0x1
    80002554:	126080e7          	jalr	294(ra) # 80003676 <log_write>
  brelse(bp);
    80002558:	854a                	mv	a0,s2
    8000255a:	00000097          	auipc	ra,0x0
    8000255e:	e92080e7          	jalr	-366(ra) # 800023ec <brelse>
}
    80002562:	60e2                	ld	ra,24(sp)
    80002564:	6442                	ld	s0,16(sp)
    80002566:	64a2                	ld	s1,8(sp)
    80002568:	6902                	ld	s2,0(sp)
    8000256a:	6105                	addi	sp,sp,32
    8000256c:	8082                	ret
    panic("freeing free block");
    8000256e:	00006517          	auipc	a0,0x6
    80002572:	f4a50513          	addi	a0,a0,-182 # 800084b8 <syscalls+0xe8>
    80002576:	00003097          	auipc	ra,0x3
    8000257a:	616080e7          	jalr	1558(ra) # 80005b8c <panic>

000000008000257e <balloc>:
{
    8000257e:	711d                	addi	sp,sp,-96
    80002580:	ec86                	sd	ra,88(sp)
    80002582:	e8a2                	sd	s0,80(sp)
    80002584:	e4a6                	sd	s1,72(sp)
    80002586:	e0ca                	sd	s2,64(sp)
    80002588:	fc4e                	sd	s3,56(sp)
    8000258a:	f852                	sd	s4,48(sp)
    8000258c:	f456                	sd	s5,40(sp)
    8000258e:	f05a                	sd	s6,32(sp)
    80002590:	ec5e                	sd	s7,24(sp)
    80002592:	e862                	sd	s8,16(sp)
    80002594:	e466                	sd	s9,8(sp)
    80002596:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002598:	00015797          	auipc	a5,0x15
    8000259c:	8747a783          	lw	a5,-1932(a5) # 80016e0c <sb+0x4>
    800025a0:	cff5                	beqz	a5,8000269c <balloc+0x11e>
    800025a2:	8baa                	mv	s7,a0
    800025a4:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800025a6:	00015b17          	auipc	s6,0x15
    800025aa:	862b0b13          	addi	s6,s6,-1950 # 80016e08 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025ae:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800025b0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025b2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800025b4:	6c89                	lui	s9,0x2
    800025b6:	a061                	j	8000263e <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    800025b8:	97ca                	add	a5,a5,s2
    800025ba:	8e55                	or	a2,a2,a3
    800025bc:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800025c0:	854a                	mv	a0,s2
    800025c2:	00001097          	auipc	ra,0x1
    800025c6:	0b4080e7          	jalr	180(ra) # 80003676 <log_write>
        brelse(bp);
    800025ca:	854a                	mv	a0,s2
    800025cc:	00000097          	auipc	ra,0x0
    800025d0:	e20080e7          	jalr	-480(ra) # 800023ec <brelse>
  bp = bread(dev, bno);
    800025d4:	85a6                	mv	a1,s1
    800025d6:	855e                	mv	a0,s7
    800025d8:	00000097          	auipc	ra,0x0
    800025dc:	ce4080e7          	jalr	-796(ra) # 800022bc <bread>
    800025e0:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800025e2:	40000613          	li	a2,1024
    800025e6:	4581                	li	a1,0
    800025e8:	05850513          	addi	a0,a0,88
    800025ec:	ffffe097          	auipc	ra,0xffffe
    800025f0:	b8e080e7          	jalr	-1138(ra) # 8000017a <memset>
  log_write(bp);
    800025f4:	854a                	mv	a0,s2
    800025f6:	00001097          	auipc	ra,0x1
    800025fa:	080080e7          	jalr	128(ra) # 80003676 <log_write>
  brelse(bp);
    800025fe:	854a                	mv	a0,s2
    80002600:	00000097          	auipc	ra,0x0
    80002604:	dec080e7          	jalr	-532(ra) # 800023ec <brelse>
}
    80002608:	8526                	mv	a0,s1
    8000260a:	60e6                	ld	ra,88(sp)
    8000260c:	6446                	ld	s0,80(sp)
    8000260e:	64a6                	ld	s1,72(sp)
    80002610:	6906                	ld	s2,64(sp)
    80002612:	79e2                	ld	s3,56(sp)
    80002614:	7a42                	ld	s4,48(sp)
    80002616:	7aa2                	ld	s5,40(sp)
    80002618:	7b02                	ld	s6,32(sp)
    8000261a:	6be2                	ld	s7,24(sp)
    8000261c:	6c42                	ld	s8,16(sp)
    8000261e:	6ca2                	ld	s9,8(sp)
    80002620:	6125                	addi	sp,sp,96
    80002622:	8082                	ret
    brelse(bp);
    80002624:	854a                	mv	a0,s2
    80002626:	00000097          	auipc	ra,0x0
    8000262a:	dc6080e7          	jalr	-570(ra) # 800023ec <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000262e:	015c87bb          	addw	a5,s9,s5
    80002632:	00078a9b          	sext.w	s5,a5
    80002636:	004b2703          	lw	a4,4(s6)
    8000263a:	06eaf163          	bgeu	s5,a4,8000269c <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    8000263e:	41fad79b          	sraiw	a5,s5,0x1f
    80002642:	0137d79b          	srliw	a5,a5,0x13
    80002646:	015787bb          	addw	a5,a5,s5
    8000264a:	40d7d79b          	sraiw	a5,a5,0xd
    8000264e:	01cb2583          	lw	a1,28(s6)
    80002652:	9dbd                	addw	a1,a1,a5
    80002654:	855e                	mv	a0,s7
    80002656:	00000097          	auipc	ra,0x0
    8000265a:	c66080e7          	jalr	-922(ra) # 800022bc <bread>
    8000265e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002660:	004b2503          	lw	a0,4(s6)
    80002664:	000a849b          	sext.w	s1,s5
    80002668:	8762                	mv	a4,s8
    8000266a:	faa4fde3          	bgeu	s1,a0,80002624 <balloc+0xa6>
      m = 1 << (bi % 8);
    8000266e:	00777693          	andi	a3,a4,7
    80002672:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002676:	41f7579b          	sraiw	a5,a4,0x1f
    8000267a:	01d7d79b          	srliw	a5,a5,0x1d
    8000267e:	9fb9                	addw	a5,a5,a4
    80002680:	4037d79b          	sraiw	a5,a5,0x3
    80002684:	00f90633          	add	a2,s2,a5
    80002688:	05864603          	lbu	a2,88(a2)
    8000268c:	00c6f5b3          	and	a1,a3,a2
    80002690:	d585                	beqz	a1,800025b8 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002692:	2705                	addiw	a4,a4,1
    80002694:	2485                	addiw	s1,s1,1
    80002696:	fd471ae3          	bne	a4,s4,8000266a <balloc+0xec>
    8000269a:	b769                	j	80002624 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    8000269c:	00006517          	auipc	a0,0x6
    800026a0:	e3450513          	addi	a0,a0,-460 # 800084d0 <syscalls+0x100>
    800026a4:	00003097          	auipc	ra,0x3
    800026a8:	532080e7          	jalr	1330(ra) # 80005bd6 <printf>
  return 0;
    800026ac:	4481                	li	s1,0
    800026ae:	bfa9                	j	80002608 <balloc+0x8a>

00000000800026b0 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800026b0:	7179                	addi	sp,sp,-48
    800026b2:	f406                	sd	ra,40(sp)
    800026b4:	f022                	sd	s0,32(sp)
    800026b6:	ec26                	sd	s1,24(sp)
    800026b8:	e84a                	sd	s2,16(sp)
    800026ba:	e44e                	sd	s3,8(sp)
    800026bc:	e052                	sd	s4,0(sp)
    800026be:	1800                	addi	s0,sp,48
    800026c0:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800026c2:	47ad                	li	a5,11
    800026c4:	02b7e863          	bltu	a5,a1,800026f4 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    800026c8:	02059793          	slli	a5,a1,0x20
    800026cc:	01e7d593          	srli	a1,a5,0x1e
    800026d0:	00b504b3          	add	s1,a0,a1
    800026d4:	0504a903          	lw	s2,80(s1)
    800026d8:	06091e63          	bnez	s2,80002754 <bmap+0xa4>
      addr = balloc(ip->dev);
    800026dc:	4108                	lw	a0,0(a0)
    800026de:	00000097          	auipc	ra,0x0
    800026e2:	ea0080e7          	jalr	-352(ra) # 8000257e <balloc>
    800026e6:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800026ea:	06090563          	beqz	s2,80002754 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    800026ee:	0524a823          	sw	s2,80(s1)
    800026f2:	a08d                	j	80002754 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800026f4:	ff45849b          	addiw	s1,a1,-12
    800026f8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800026fc:	0ff00793          	li	a5,255
    80002700:	08e7e563          	bltu	a5,a4,8000278a <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002704:	08052903          	lw	s2,128(a0)
    80002708:	00091d63          	bnez	s2,80002722 <bmap+0x72>
      addr = balloc(ip->dev);
    8000270c:	4108                	lw	a0,0(a0)
    8000270e:	00000097          	auipc	ra,0x0
    80002712:	e70080e7          	jalr	-400(ra) # 8000257e <balloc>
    80002716:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000271a:	02090d63          	beqz	s2,80002754 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000271e:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002722:	85ca                	mv	a1,s2
    80002724:	0009a503          	lw	a0,0(s3)
    80002728:	00000097          	auipc	ra,0x0
    8000272c:	b94080e7          	jalr	-1132(ra) # 800022bc <bread>
    80002730:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002732:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002736:	02049713          	slli	a4,s1,0x20
    8000273a:	01e75593          	srli	a1,a4,0x1e
    8000273e:	00b784b3          	add	s1,a5,a1
    80002742:	0004a903          	lw	s2,0(s1)
    80002746:	02090063          	beqz	s2,80002766 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000274a:	8552                	mv	a0,s4
    8000274c:	00000097          	auipc	ra,0x0
    80002750:	ca0080e7          	jalr	-864(ra) # 800023ec <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002754:	854a                	mv	a0,s2
    80002756:	70a2                	ld	ra,40(sp)
    80002758:	7402                	ld	s0,32(sp)
    8000275a:	64e2                	ld	s1,24(sp)
    8000275c:	6942                	ld	s2,16(sp)
    8000275e:	69a2                	ld	s3,8(sp)
    80002760:	6a02                	ld	s4,0(sp)
    80002762:	6145                	addi	sp,sp,48
    80002764:	8082                	ret
      addr = balloc(ip->dev);
    80002766:	0009a503          	lw	a0,0(s3)
    8000276a:	00000097          	auipc	ra,0x0
    8000276e:	e14080e7          	jalr	-492(ra) # 8000257e <balloc>
    80002772:	0005091b          	sext.w	s2,a0
      if(addr){
    80002776:	fc090ae3          	beqz	s2,8000274a <bmap+0x9a>
        a[bn] = addr;
    8000277a:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000277e:	8552                	mv	a0,s4
    80002780:	00001097          	auipc	ra,0x1
    80002784:	ef6080e7          	jalr	-266(ra) # 80003676 <log_write>
    80002788:	b7c9                	j	8000274a <bmap+0x9a>
  panic("bmap: out of range");
    8000278a:	00006517          	auipc	a0,0x6
    8000278e:	d5e50513          	addi	a0,a0,-674 # 800084e8 <syscalls+0x118>
    80002792:	00003097          	auipc	ra,0x3
    80002796:	3fa080e7          	jalr	1018(ra) # 80005b8c <panic>

000000008000279a <iget>:
{
    8000279a:	7179                	addi	sp,sp,-48
    8000279c:	f406                	sd	ra,40(sp)
    8000279e:	f022                	sd	s0,32(sp)
    800027a0:	ec26                	sd	s1,24(sp)
    800027a2:	e84a                	sd	s2,16(sp)
    800027a4:	e44e                	sd	s3,8(sp)
    800027a6:	e052                	sd	s4,0(sp)
    800027a8:	1800                	addi	s0,sp,48
    800027aa:	89aa                	mv	s3,a0
    800027ac:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800027ae:	00014517          	auipc	a0,0x14
    800027b2:	67a50513          	addi	a0,a0,1658 # 80016e28 <itable>
    800027b6:	00004097          	auipc	ra,0x4
    800027ba:	90e080e7          	jalr	-1778(ra) # 800060c4 <acquire>
  empty = 0;
    800027be:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027c0:	00014497          	auipc	s1,0x14
    800027c4:	68048493          	addi	s1,s1,1664 # 80016e40 <itable+0x18>
    800027c8:	00016697          	auipc	a3,0x16
    800027cc:	10868693          	addi	a3,a3,264 # 800188d0 <log>
    800027d0:	a039                	j	800027de <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027d2:	02090b63          	beqz	s2,80002808 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027d6:	08848493          	addi	s1,s1,136
    800027da:	02d48a63          	beq	s1,a3,8000280e <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800027de:	449c                	lw	a5,8(s1)
    800027e0:	fef059e3          	blez	a5,800027d2 <iget+0x38>
    800027e4:	4098                	lw	a4,0(s1)
    800027e6:	ff3716e3          	bne	a4,s3,800027d2 <iget+0x38>
    800027ea:	40d8                	lw	a4,4(s1)
    800027ec:	ff4713e3          	bne	a4,s4,800027d2 <iget+0x38>
      ip->ref++;
    800027f0:	2785                	addiw	a5,a5,1
    800027f2:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800027f4:	00014517          	auipc	a0,0x14
    800027f8:	63450513          	addi	a0,a0,1588 # 80016e28 <itable>
    800027fc:	00004097          	auipc	ra,0x4
    80002800:	97c080e7          	jalr	-1668(ra) # 80006178 <release>
      return ip;
    80002804:	8926                	mv	s2,s1
    80002806:	a03d                	j	80002834 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002808:	f7f9                	bnez	a5,800027d6 <iget+0x3c>
    8000280a:	8926                	mv	s2,s1
    8000280c:	b7e9                	j	800027d6 <iget+0x3c>
  if(empty == 0)
    8000280e:	02090c63          	beqz	s2,80002846 <iget+0xac>
  ip->dev = dev;
    80002812:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002816:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000281a:	4785                	li	a5,1
    8000281c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002820:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002824:	00014517          	auipc	a0,0x14
    80002828:	60450513          	addi	a0,a0,1540 # 80016e28 <itable>
    8000282c:	00004097          	auipc	ra,0x4
    80002830:	94c080e7          	jalr	-1716(ra) # 80006178 <release>
}
    80002834:	854a                	mv	a0,s2
    80002836:	70a2                	ld	ra,40(sp)
    80002838:	7402                	ld	s0,32(sp)
    8000283a:	64e2                	ld	s1,24(sp)
    8000283c:	6942                	ld	s2,16(sp)
    8000283e:	69a2                	ld	s3,8(sp)
    80002840:	6a02                	ld	s4,0(sp)
    80002842:	6145                	addi	sp,sp,48
    80002844:	8082                	ret
    panic("iget: no inodes");
    80002846:	00006517          	auipc	a0,0x6
    8000284a:	cba50513          	addi	a0,a0,-838 # 80008500 <syscalls+0x130>
    8000284e:	00003097          	auipc	ra,0x3
    80002852:	33e080e7          	jalr	830(ra) # 80005b8c <panic>

0000000080002856 <fsinit>:
fsinit(int dev) {
    80002856:	7179                	addi	sp,sp,-48
    80002858:	f406                	sd	ra,40(sp)
    8000285a:	f022                	sd	s0,32(sp)
    8000285c:	ec26                	sd	s1,24(sp)
    8000285e:	e84a                	sd	s2,16(sp)
    80002860:	e44e                	sd	s3,8(sp)
    80002862:	1800                	addi	s0,sp,48
    80002864:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002866:	4585                	li	a1,1
    80002868:	00000097          	auipc	ra,0x0
    8000286c:	a54080e7          	jalr	-1452(ra) # 800022bc <bread>
    80002870:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002872:	00014997          	auipc	s3,0x14
    80002876:	59698993          	addi	s3,s3,1430 # 80016e08 <sb>
    8000287a:	02000613          	li	a2,32
    8000287e:	05850593          	addi	a1,a0,88
    80002882:	854e                	mv	a0,s3
    80002884:	ffffe097          	auipc	ra,0xffffe
    80002888:	952080e7          	jalr	-1710(ra) # 800001d6 <memmove>
  brelse(bp);
    8000288c:	8526                	mv	a0,s1
    8000288e:	00000097          	auipc	ra,0x0
    80002892:	b5e080e7          	jalr	-1186(ra) # 800023ec <brelse>
  if(sb.magic != FSMAGIC)
    80002896:	0009a703          	lw	a4,0(s3)
    8000289a:	102037b7          	lui	a5,0x10203
    8000289e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800028a2:	02f71263          	bne	a4,a5,800028c6 <fsinit+0x70>
  initlog(dev, &sb);
    800028a6:	00014597          	auipc	a1,0x14
    800028aa:	56258593          	addi	a1,a1,1378 # 80016e08 <sb>
    800028ae:	854a                	mv	a0,s2
    800028b0:	00001097          	auipc	ra,0x1
    800028b4:	b4a080e7          	jalr	-1206(ra) # 800033fa <initlog>
}
    800028b8:	70a2                	ld	ra,40(sp)
    800028ba:	7402                	ld	s0,32(sp)
    800028bc:	64e2                	ld	s1,24(sp)
    800028be:	6942                	ld	s2,16(sp)
    800028c0:	69a2                	ld	s3,8(sp)
    800028c2:	6145                	addi	sp,sp,48
    800028c4:	8082                	ret
    panic("invalid file system");
    800028c6:	00006517          	auipc	a0,0x6
    800028ca:	c4a50513          	addi	a0,a0,-950 # 80008510 <syscalls+0x140>
    800028ce:	00003097          	auipc	ra,0x3
    800028d2:	2be080e7          	jalr	702(ra) # 80005b8c <panic>

00000000800028d6 <iinit>:
{
    800028d6:	7179                	addi	sp,sp,-48
    800028d8:	f406                	sd	ra,40(sp)
    800028da:	f022                	sd	s0,32(sp)
    800028dc:	ec26                	sd	s1,24(sp)
    800028de:	e84a                	sd	s2,16(sp)
    800028e0:	e44e                	sd	s3,8(sp)
    800028e2:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800028e4:	00006597          	auipc	a1,0x6
    800028e8:	c4458593          	addi	a1,a1,-956 # 80008528 <syscalls+0x158>
    800028ec:	00014517          	auipc	a0,0x14
    800028f0:	53c50513          	addi	a0,a0,1340 # 80016e28 <itable>
    800028f4:	00003097          	auipc	ra,0x3
    800028f8:	740080e7          	jalr	1856(ra) # 80006034 <initlock>
  for(i = 0; i < NINODE; i++) {
    800028fc:	00014497          	auipc	s1,0x14
    80002900:	55448493          	addi	s1,s1,1364 # 80016e50 <itable+0x28>
    80002904:	00016997          	auipc	s3,0x16
    80002908:	fdc98993          	addi	s3,s3,-36 # 800188e0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000290c:	00006917          	auipc	s2,0x6
    80002910:	c2490913          	addi	s2,s2,-988 # 80008530 <syscalls+0x160>
    80002914:	85ca                	mv	a1,s2
    80002916:	8526                	mv	a0,s1
    80002918:	00001097          	auipc	ra,0x1
    8000291c:	e42080e7          	jalr	-446(ra) # 8000375a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002920:	08848493          	addi	s1,s1,136
    80002924:	ff3498e3          	bne	s1,s3,80002914 <iinit+0x3e>
}
    80002928:	70a2                	ld	ra,40(sp)
    8000292a:	7402                	ld	s0,32(sp)
    8000292c:	64e2                	ld	s1,24(sp)
    8000292e:	6942                	ld	s2,16(sp)
    80002930:	69a2                	ld	s3,8(sp)
    80002932:	6145                	addi	sp,sp,48
    80002934:	8082                	ret

0000000080002936 <ialloc>:
{
    80002936:	715d                	addi	sp,sp,-80
    80002938:	e486                	sd	ra,72(sp)
    8000293a:	e0a2                	sd	s0,64(sp)
    8000293c:	fc26                	sd	s1,56(sp)
    8000293e:	f84a                	sd	s2,48(sp)
    80002940:	f44e                	sd	s3,40(sp)
    80002942:	f052                	sd	s4,32(sp)
    80002944:	ec56                	sd	s5,24(sp)
    80002946:	e85a                	sd	s6,16(sp)
    80002948:	e45e                	sd	s7,8(sp)
    8000294a:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    8000294c:	00014717          	auipc	a4,0x14
    80002950:	4c872703          	lw	a4,1224(a4) # 80016e14 <sb+0xc>
    80002954:	4785                	li	a5,1
    80002956:	04e7fa63          	bgeu	a5,a4,800029aa <ialloc+0x74>
    8000295a:	8aaa                	mv	s5,a0
    8000295c:	8bae                	mv	s7,a1
    8000295e:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002960:	00014a17          	auipc	s4,0x14
    80002964:	4a8a0a13          	addi	s4,s4,1192 # 80016e08 <sb>
    80002968:	00048b1b          	sext.w	s6,s1
    8000296c:	0044d593          	srli	a1,s1,0x4
    80002970:	018a2783          	lw	a5,24(s4)
    80002974:	9dbd                	addw	a1,a1,a5
    80002976:	8556                	mv	a0,s5
    80002978:	00000097          	auipc	ra,0x0
    8000297c:	944080e7          	jalr	-1724(ra) # 800022bc <bread>
    80002980:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002982:	05850993          	addi	s3,a0,88
    80002986:	00f4f793          	andi	a5,s1,15
    8000298a:	079a                	slli	a5,a5,0x6
    8000298c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000298e:	00099783          	lh	a5,0(s3)
    80002992:	c3a1                	beqz	a5,800029d2 <ialloc+0x9c>
    brelse(bp);
    80002994:	00000097          	auipc	ra,0x0
    80002998:	a58080e7          	jalr	-1448(ra) # 800023ec <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000299c:	0485                	addi	s1,s1,1
    8000299e:	00ca2703          	lw	a4,12(s4)
    800029a2:	0004879b          	sext.w	a5,s1
    800029a6:	fce7e1e3          	bltu	a5,a4,80002968 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    800029aa:	00006517          	auipc	a0,0x6
    800029ae:	b8e50513          	addi	a0,a0,-1138 # 80008538 <syscalls+0x168>
    800029b2:	00003097          	auipc	ra,0x3
    800029b6:	224080e7          	jalr	548(ra) # 80005bd6 <printf>
  return 0;
    800029ba:	4501                	li	a0,0
}
    800029bc:	60a6                	ld	ra,72(sp)
    800029be:	6406                	ld	s0,64(sp)
    800029c0:	74e2                	ld	s1,56(sp)
    800029c2:	7942                	ld	s2,48(sp)
    800029c4:	79a2                	ld	s3,40(sp)
    800029c6:	7a02                	ld	s4,32(sp)
    800029c8:	6ae2                	ld	s5,24(sp)
    800029ca:	6b42                	ld	s6,16(sp)
    800029cc:	6ba2                	ld	s7,8(sp)
    800029ce:	6161                	addi	sp,sp,80
    800029d0:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800029d2:	04000613          	li	a2,64
    800029d6:	4581                	li	a1,0
    800029d8:	854e                	mv	a0,s3
    800029da:	ffffd097          	auipc	ra,0xffffd
    800029de:	7a0080e7          	jalr	1952(ra) # 8000017a <memset>
      dip->type = type;
    800029e2:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800029e6:	854a                	mv	a0,s2
    800029e8:	00001097          	auipc	ra,0x1
    800029ec:	c8e080e7          	jalr	-882(ra) # 80003676 <log_write>
      brelse(bp);
    800029f0:	854a                	mv	a0,s2
    800029f2:	00000097          	auipc	ra,0x0
    800029f6:	9fa080e7          	jalr	-1542(ra) # 800023ec <brelse>
      return iget(dev, inum);
    800029fa:	85da                	mv	a1,s6
    800029fc:	8556                	mv	a0,s5
    800029fe:	00000097          	auipc	ra,0x0
    80002a02:	d9c080e7          	jalr	-612(ra) # 8000279a <iget>
    80002a06:	bf5d                	j	800029bc <ialloc+0x86>

0000000080002a08 <iupdate>:
{
    80002a08:	1101                	addi	sp,sp,-32
    80002a0a:	ec06                	sd	ra,24(sp)
    80002a0c:	e822                	sd	s0,16(sp)
    80002a0e:	e426                	sd	s1,8(sp)
    80002a10:	e04a                	sd	s2,0(sp)
    80002a12:	1000                	addi	s0,sp,32
    80002a14:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a16:	415c                	lw	a5,4(a0)
    80002a18:	0047d79b          	srliw	a5,a5,0x4
    80002a1c:	00014597          	auipc	a1,0x14
    80002a20:	4045a583          	lw	a1,1028(a1) # 80016e20 <sb+0x18>
    80002a24:	9dbd                	addw	a1,a1,a5
    80002a26:	4108                	lw	a0,0(a0)
    80002a28:	00000097          	auipc	ra,0x0
    80002a2c:	894080e7          	jalr	-1900(ra) # 800022bc <bread>
    80002a30:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a32:	05850793          	addi	a5,a0,88
    80002a36:	40d8                	lw	a4,4(s1)
    80002a38:	8b3d                	andi	a4,a4,15
    80002a3a:	071a                	slli	a4,a4,0x6
    80002a3c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002a3e:	04449703          	lh	a4,68(s1)
    80002a42:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002a46:	04649703          	lh	a4,70(s1)
    80002a4a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002a4e:	04849703          	lh	a4,72(s1)
    80002a52:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002a56:	04a49703          	lh	a4,74(s1)
    80002a5a:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002a5e:	44f8                	lw	a4,76(s1)
    80002a60:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002a62:	03400613          	li	a2,52
    80002a66:	05048593          	addi	a1,s1,80
    80002a6a:	00c78513          	addi	a0,a5,12
    80002a6e:	ffffd097          	auipc	ra,0xffffd
    80002a72:	768080e7          	jalr	1896(ra) # 800001d6 <memmove>
  log_write(bp);
    80002a76:	854a                	mv	a0,s2
    80002a78:	00001097          	auipc	ra,0x1
    80002a7c:	bfe080e7          	jalr	-1026(ra) # 80003676 <log_write>
  brelse(bp);
    80002a80:	854a                	mv	a0,s2
    80002a82:	00000097          	auipc	ra,0x0
    80002a86:	96a080e7          	jalr	-1686(ra) # 800023ec <brelse>
}
    80002a8a:	60e2                	ld	ra,24(sp)
    80002a8c:	6442                	ld	s0,16(sp)
    80002a8e:	64a2                	ld	s1,8(sp)
    80002a90:	6902                	ld	s2,0(sp)
    80002a92:	6105                	addi	sp,sp,32
    80002a94:	8082                	ret

0000000080002a96 <idup>:
{
    80002a96:	1101                	addi	sp,sp,-32
    80002a98:	ec06                	sd	ra,24(sp)
    80002a9a:	e822                	sd	s0,16(sp)
    80002a9c:	e426                	sd	s1,8(sp)
    80002a9e:	1000                	addi	s0,sp,32
    80002aa0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002aa2:	00014517          	auipc	a0,0x14
    80002aa6:	38650513          	addi	a0,a0,902 # 80016e28 <itable>
    80002aaa:	00003097          	auipc	ra,0x3
    80002aae:	61a080e7          	jalr	1562(ra) # 800060c4 <acquire>
  ip->ref++;
    80002ab2:	449c                	lw	a5,8(s1)
    80002ab4:	2785                	addiw	a5,a5,1
    80002ab6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ab8:	00014517          	auipc	a0,0x14
    80002abc:	37050513          	addi	a0,a0,880 # 80016e28 <itable>
    80002ac0:	00003097          	auipc	ra,0x3
    80002ac4:	6b8080e7          	jalr	1720(ra) # 80006178 <release>
}
    80002ac8:	8526                	mv	a0,s1
    80002aca:	60e2                	ld	ra,24(sp)
    80002acc:	6442                	ld	s0,16(sp)
    80002ace:	64a2                	ld	s1,8(sp)
    80002ad0:	6105                	addi	sp,sp,32
    80002ad2:	8082                	ret

0000000080002ad4 <ilock>:
{
    80002ad4:	1101                	addi	sp,sp,-32
    80002ad6:	ec06                	sd	ra,24(sp)
    80002ad8:	e822                	sd	s0,16(sp)
    80002ada:	e426                	sd	s1,8(sp)
    80002adc:	e04a                	sd	s2,0(sp)
    80002ade:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002ae0:	c115                	beqz	a0,80002b04 <ilock+0x30>
    80002ae2:	84aa                	mv	s1,a0
    80002ae4:	451c                	lw	a5,8(a0)
    80002ae6:	00f05f63          	blez	a5,80002b04 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002aea:	0541                	addi	a0,a0,16
    80002aec:	00001097          	auipc	ra,0x1
    80002af0:	ca8080e7          	jalr	-856(ra) # 80003794 <acquiresleep>
  if(ip->valid == 0){
    80002af4:	40bc                	lw	a5,64(s1)
    80002af6:	cf99                	beqz	a5,80002b14 <ilock+0x40>
}
    80002af8:	60e2                	ld	ra,24(sp)
    80002afa:	6442                	ld	s0,16(sp)
    80002afc:	64a2                	ld	s1,8(sp)
    80002afe:	6902                	ld	s2,0(sp)
    80002b00:	6105                	addi	sp,sp,32
    80002b02:	8082                	ret
    panic("ilock");
    80002b04:	00006517          	auipc	a0,0x6
    80002b08:	a4c50513          	addi	a0,a0,-1460 # 80008550 <syscalls+0x180>
    80002b0c:	00003097          	auipc	ra,0x3
    80002b10:	080080e7          	jalr	128(ra) # 80005b8c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b14:	40dc                	lw	a5,4(s1)
    80002b16:	0047d79b          	srliw	a5,a5,0x4
    80002b1a:	00014597          	auipc	a1,0x14
    80002b1e:	3065a583          	lw	a1,774(a1) # 80016e20 <sb+0x18>
    80002b22:	9dbd                	addw	a1,a1,a5
    80002b24:	4088                	lw	a0,0(s1)
    80002b26:	fffff097          	auipc	ra,0xfffff
    80002b2a:	796080e7          	jalr	1942(ra) # 800022bc <bread>
    80002b2e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b30:	05850593          	addi	a1,a0,88
    80002b34:	40dc                	lw	a5,4(s1)
    80002b36:	8bbd                	andi	a5,a5,15
    80002b38:	079a                	slli	a5,a5,0x6
    80002b3a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b3c:	00059783          	lh	a5,0(a1)
    80002b40:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b44:	00259783          	lh	a5,2(a1)
    80002b48:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b4c:	00459783          	lh	a5,4(a1)
    80002b50:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002b54:	00659783          	lh	a5,6(a1)
    80002b58:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002b5c:	459c                	lw	a5,8(a1)
    80002b5e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002b60:	03400613          	li	a2,52
    80002b64:	05b1                	addi	a1,a1,12
    80002b66:	05048513          	addi	a0,s1,80
    80002b6a:	ffffd097          	auipc	ra,0xffffd
    80002b6e:	66c080e7          	jalr	1644(ra) # 800001d6 <memmove>
    brelse(bp);
    80002b72:	854a                	mv	a0,s2
    80002b74:	00000097          	auipc	ra,0x0
    80002b78:	878080e7          	jalr	-1928(ra) # 800023ec <brelse>
    ip->valid = 1;
    80002b7c:	4785                	li	a5,1
    80002b7e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002b80:	04449783          	lh	a5,68(s1)
    80002b84:	fbb5                	bnez	a5,80002af8 <ilock+0x24>
      panic("ilock: no type");
    80002b86:	00006517          	auipc	a0,0x6
    80002b8a:	9d250513          	addi	a0,a0,-1582 # 80008558 <syscalls+0x188>
    80002b8e:	00003097          	auipc	ra,0x3
    80002b92:	ffe080e7          	jalr	-2(ra) # 80005b8c <panic>

0000000080002b96 <iunlock>:
{
    80002b96:	1101                	addi	sp,sp,-32
    80002b98:	ec06                	sd	ra,24(sp)
    80002b9a:	e822                	sd	s0,16(sp)
    80002b9c:	e426                	sd	s1,8(sp)
    80002b9e:	e04a                	sd	s2,0(sp)
    80002ba0:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002ba2:	c905                	beqz	a0,80002bd2 <iunlock+0x3c>
    80002ba4:	84aa                	mv	s1,a0
    80002ba6:	01050913          	addi	s2,a0,16
    80002baa:	854a                	mv	a0,s2
    80002bac:	00001097          	auipc	ra,0x1
    80002bb0:	c82080e7          	jalr	-894(ra) # 8000382e <holdingsleep>
    80002bb4:	cd19                	beqz	a0,80002bd2 <iunlock+0x3c>
    80002bb6:	449c                	lw	a5,8(s1)
    80002bb8:	00f05d63          	blez	a5,80002bd2 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002bbc:	854a                	mv	a0,s2
    80002bbe:	00001097          	auipc	ra,0x1
    80002bc2:	c2c080e7          	jalr	-980(ra) # 800037ea <releasesleep>
}
    80002bc6:	60e2                	ld	ra,24(sp)
    80002bc8:	6442                	ld	s0,16(sp)
    80002bca:	64a2                	ld	s1,8(sp)
    80002bcc:	6902                	ld	s2,0(sp)
    80002bce:	6105                	addi	sp,sp,32
    80002bd0:	8082                	ret
    panic("iunlock");
    80002bd2:	00006517          	auipc	a0,0x6
    80002bd6:	99650513          	addi	a0,a0,-1642 # 80008568 <syscalls+0x198>
    80002bda:	00003097          	auipc	ra,0x3
    80002bde:	fb2080e7          	jalr	-78(ra) # 80005b8c <panic>

0000000080002be2 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002be2:	7179                	addi	sp,sp,-48
    80002be4:	f406                	sd	ra,40(sp)
    80002be6:	f022                	sd	s0,32(sp)
    80002be8:	ec26                	sd	s1,24(sp)
    80002bea:	e84a                	sd	s2,16(sp)
    80002bec:	e44e                	sd	s3,8(sp)
    80002bee:	e052                	sd	s4,0(sp)
    80002bf0:	1800                	addi	s0,sp,48
    80002bf2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002bf4:	05050493          	addi	s1,a0,80
    80002bf8:	08050913          	addi	s2,a0,128
    80002bfc:	a021                	j	80002c04 <itrunc+0x22>
    80002bfe:	0491                	addi	s1,s1,4
    80002c00:	01248d63          	beq	s1,s2,80002c1a <itrunc+0x38>
    if(ip->addrs[i]){
    80002c04:	408c                	lw	a1,0(s1)
    80002c06:	dde5                	beqz	a1,80002bfe <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c08:	0009a503          	lw	a0,0(s3)
    80002c0c:	00000097          	auipc	ra,0x0
    80002c10:	8f6080e7          	jalr	-1802(ra) # 80002502 <bfree>
      ip->addrs[i] = 0;
    80002c14:	0004a023          	sw	zero,0(s1)
    80002c18:	b7dd                	j	80002bfe <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c1a:	0809a583          	lw	a1,128(s3)
    80002c1e:	e185                	bnez	a1,80002c3e <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c20:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c24:	854e                	mv	a0,s3
    80002c26:	00000097          	auipc	ra,0x0
    80002c2a:	de2080e7          	jalr	-542(ra) # 80002a08 <iupdate>
}
    80002c2e:	70a2                	ld	ra,40(sp)
    80002c30:	7402                	ld	s0,32(sp)
    80002c32:	64e2                	ld	s1,24(sp)
    80002c34:	6942                	ld	s2,16(sp)
    80002c36:	69a2                	ld	s3,8(sp)
    80002c38:	6a02                	ld	s4,0(sp)
    80002c3a:	6145                	addi	sp,sp,48
    80002c3c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002c3e:	0009a503          	lw	a0,0(s3)
    80002c42:	fffff097          	auipc	ra,0xfffff
    80002c46:	67a080e7          	jalr	1658(ra) # 800022bc <bread>
    80002c4a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002c4c:	05850493          	addi	s1,a0,88
    80002c50:	45850913          	addi	s2,a0,1112
    80002c54:	a021                	j	80002c5c <itrunc+0x7a>
    80002c56:	0491                	addi	s1,s1,4
    80002c58:	01248b63          	beq	s1,s2,80002c6e <itrunc+0x8c>
      if(a[j])
    80002c5c:	408c                	lw	a1,0(s1)
    80002c5e:	dde5                	beqz	a1,80002c56 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002c60:	0009a503          	lw	a0,0(s3)
    80002c64:	00000097          	auipc	ra,0x0
    80002c68:	89e080e7          	jalr	-1890(ra) # 80002502 <bfree>
    80002c6c:	b7ed                	j	80002c56 <itrunc+0x74>
    brelse(bp);
    80002c6e:	8552                	mv	a0,s4
    80002c70:	fffff097          	auipc	ra,0xfffff
    80002c74:	77c080e7          	jalr	1916(ra) # 800023ec <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c78:	0809a583          	lw	a1,128(s3)
    80002c7c:	0009a503          	lw	a0,0(s3)
    80002c80:	00000097          	auipc	ra,0x0
    80002c84:	882080e7          	jalr	-1918(ra) # 80002502 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002c88:	0809a023          	sw	zero,128(s3)
    80002c8c:	bf51                	j	80002c20 <itrunc+0x3e>

0000000080002c8e <iput>:
{
    80002c8e:	1101                	addi	sp,sp,-32
    80002c90:	ec06                	sd	ra,24(sp)
    80002c92:	e822                	sd	s0,16(sp)
    80002c94:	e426                	sd	s1,8(sp)
    80002c96:	e04a                	sd	s2,0(sp)
    80002c98:	1000                	addi	s0,sp,32
    80002c9a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c9c:	00014517          	auipc	a0,0x14
    80002ca0:	18c50513          	addi	a0,a0,396 # 80016e28 <itable>
    80002ca4:	00003097          	auipc	ra,0x3
    80002ca8:	420080e7          	jalr	1056(ra) # 800060c4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cac:	4498                	lw	a4,8(s1)
    80002cae:	4785                	li	a5,1
    80002cb0:	02f70363          	beq	a4,a5,80002cd6 <iput+0x48>
  ip->ref--;
    80002cb4:	449c                	lw	a5,8(s1)
    80002cb6:	37fd                	addiw	a5,a5,-1
    80002cb8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cba:	00014517          	auipc	a0,0x14
    80002cbe:	16e50513          	addi	a0,a0,366 # 80016e28 <itable>
    80002cc2:	00003097          	auipc	ra,0x3
    80002cc6:	4b6080e7          	jalr	1206(ra) # 80006178 <release>
}
    80002cca:	60e2                	ld	ra,24(sp)
    80002ccc:	6442                	ld	s0,16(sp)
    80002cce:	64a2                	ld	s1,8(sp)
    80002cd0:	6902                	ld	s2,0(sp)
    80002cd2:	6105                	addi	sp,sp,32
    80002cd4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cd6:	40bc                	lw	a5,64(s1)
    80002cd8:	dff1                	beqz	a5,80002cb4 <iput+0x26>
    80002cda:	04a49783          	lh	a5,74(s1)
    80002cde:	fbf9                	bnez	a5,80002cb4 <iput+0x26>
    acquiresleep(&ip->lock);
    80002ce0:	01048913          	addi	s2,s1,16
    80002ce4:	854a                	mv	a0,s2
    80002ce6:	00001097          	auipc	ra,0x1
    80002cea:	aae080e7          	jalr	-1362(ra) # 80003794 <acquiresleep>
    release(&itable.lock);
    80002cee:	00014517          	auipc	a0,0x14
    80002cf2:	13a50513          	addi	a0,a0,314 # 80016e28 <itable>
    80002cf6:	00003097          	auipc	ra,0x3
    80002cfa:	482080e7          	jalr	1154(ra) # 80006178 <release>
    itrunc(ip);
    80002cfe:	8526                	mv	a0,s1
    80002d00:	00000097          	auipc	ra,0x0
    80002d04:	ee2080e7          	jalr	-286(ra) # 80002be2 <itrunc>
    ip->type = 0;
    80002d08:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d0c:	8526                	mv	a0,s1
    80002d0e:	00000097          	auipc	ra,0x0
    80002d12:	cfa080e7          	jalr	-774(ra) # 80002a08 <iupdate>
    ip->valid = 0;
    80002d16:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d1a:	854a                	mv	a0,s2
    80002d1c:	00001097          	auipc	ra,0x1
    80002d20:	ace080e7          	jalr	-1330(ra) # 800037ea <releasesleep>
    acquire(&itable.lock);
    80002d24:	00014517          	auipc	a0,0x14
    80002d28:	10450513          	addi	a0,a0,260 # 80016e28 <itable>
    80002d2c:	00003097          	auipc	ra,0x3
    80002d30:	398080e7          	jalr	920(ra) # 800060c4 <acquire>
    80002d34:	b741                	j	80002cb4 <iput+0x26>

0000000080002d36 <iunlockput>:
{
    80002d36:	1101                	addi	sp,sp,-32
    80002d38:	ec06                	sd	ra,24(sp)
    80002d3a:	e822                	sd	s0,16(sp)
    80002d3c:	e426                	sd	s1,8(sp)
    80002d3e:	1000                	addi	s0,sp,32
    80002d40:	84aa                	mv	s1,a0
  iunlock(ip);
    80002d42:	00000097          	auipc	ra,0x0
    80002d46:	e54080e7          	jalr	-428(ra) # 80002b96 <iunlock>
  iput(ip);
    80002d4a:	8526                	mv	a0,s1
    80002d4c:	00000097          	auipc	ra,0x0
    80002d50:	f42080e7          	jalr	-190(ra) # 80002c8e <iput>
}
    80002d54:	60e2                	ld	ra,24(sp)
    80002d56:	6442                	ld	s0,16(sp)
    80002d58:	64a2                	ld	s1,8(sp)
    80002d5a:	6105                	addi	sp,sp,32
    80002d5c:	8082                	ret

0000000080002d5e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002d5e:	1141                	addi	sp,sp,-16
    80002d60:	e422                	sd	s0,8(sp)
    80002d62:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002d64:	411c                	lw	a5,0(a0)
    80002d66:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002d68:	415c                	lw	a5,4(a0)
    80002d6a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002d6c:	04451783          	lh	a5,68(a0)
    80002d70:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002d74:	04a51783          	lh	a5,74(a0)
    80002d78:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002d7c:	04c56783          	lwu	a5,76(a0)
    80002d80:	e99c                	sd	a5,16(a1)
}
    80002d82:	6422                	ld	s0,8(sp)
    80002d84:	0141                	addi	sp,sp,16
    80002d86:	8082                	ret

0000000080002d88 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002d88:	457c                	lw	a5,76(a0)
    80002d8a:	0ed7e963          	bltu	a5,a3,80002e7c <readi+0xf4>
{
    80002d8e:	7159                	addi	sp,sp,-112
    80002d90:	f486                	sd	ra,104(sp)
    80002d92:	f0a2                	sd	s0,96(sp)
    80002d94:	eca6                	sd	s1,88(sp)
    80002d96:	e8ca                	sd	s2,80(sp)
    80002d98:	e4ce                	sd	s3,72(sp)
    80002d9a:	e0d2                	sd	s4,64(sp)
    80002d9c:	fc56                	sd	s5,56(sp)
    80002d9e:	f85a                	sd	s6,48(sp)
    80002da0:	f45e                	sd	s7,40(sp)
    80002da2:	f062                	sd	s8,32(sp)
    80002da4:	ec66                	sd	s9,24(sp)
    80002da6:	e86a                	sd	s10,16(sp)
    80002da8:	e46e                	sd	s11,8(sp)
    80002daa:	1880                	addi	s0,sp,112
    80002dac:	8b2a                	mv	s6,a0
    80002dae:	8bae                	mv	s7,a1
    80002db0:	8a32                	mv	s4,a2
    80002db2:	84b6                	mv	s1,a3
    80002db4:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002db6:	9f35                	addw	a4,a4,a3
    return 0;
    80002db8:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002dba:	0ad76063          	bltu	a4,a3,80002e5a <readi+0xd2>
  if(off + n > ip->size)
    80002dbe:	00e7f463          	bgeu	a5,a4,80002dc6 <readi+0x3e>
    n = ip->size - off;
    80002dc2:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002dc6:	0a0a8963          	beqz	s5,80002e78 <readi+0xf0>
    80002dca:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002dcc:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002dd0:	5c7d                	li	s8,-1
    80002dd2:	a82d                	j	80002e0c <readi+0x84>
    80002dd4:	020d1d93          	slli	s11,s10,0x20
    80002dd8:	020ddd93          	srli	s11,s11,0x20
    80002ddc:	05890613          	addi	a2,s2,88
    80002de0:	86ee                	mv	a3,s11
    80002de2:	963a                	add	a2,a2,a4
    80002de4:	85d2                	mv	a1,s4
    80002de6:	855e                	mv	a0,s7
    80002de8:	fffff097          	auipc	ra,0xfffff
    80002dec:	b1c080e7          	jalr	-1252(ra) # 80001904 <either_copyout>
    80002df0:	05850d63          	beq	a0,s8,80002e4a <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002df4:	854a                	mv	a0,s2
    80002df6:	fffff097          	auipc	ra,0xfffff
    80002dfa:	5f6080e7          	jalr	1526(ra) # 800023ec <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002dfe:	013d09bb          	addw	s3,s10,s3
    80002e02:	009d04bb          	addw	s1,s10,s1
    80002e06:	9a6e                	add	s4,s4,s11
    80002e08:	0559f763          	bgeu	s3,s5,80002e56 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002e0c:	00a4d59b          	srliw	a1,s1,0xa
    80002e10:	855a                	mv	a0,s6
    80002e12:	00000097          	auipc	ra,0x0
    80002e16:	89e080e7          	jalr	-1890(ra) # 800026b0 <bmap>
    80002e1a:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002e1e:	cd85                	beqz	a1,80002e56 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002e20:	000b2503          	lw	a0,0(s6)
    80002e24:	fffff097          	auipc	ra,0xfffff
    80002e28:	498080e7          	jalr	1176(ra) # 800022bc <bread>
    80002e2c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e2e:	3ff4f713          	andi	a4,s1,1023
    80002e32:	40ec87bb          	subw	a5,s9,a4
    80002e36:	413a86bb          	subw	a3,s5,s3
    80002e3a:	8d3e                	mv	s10,a5
    80002e3c:	2781                	sext.w	a5,a5
    80002e3e:	0006861b          	sext.w	a2,a3
    80002e42:	f8f679e3          	bgeu	a2,a5,80002dd4 <readi+0x4c>
    80002e46:	8d36                	mv	s10,a3
    80002e48:	b771                	j	80002dd4 <readi+0x4c>
      brelse(bp);
    80002e4a:	854a                	mv	a0,s2
    80002e4c:	fffff097          	auipc	ra,0xfffff
    80002e50:	5a0080e7          	jalr	1440(ra) # 800023ec <brelse>
      tot = -1;
    80002e54:	59fd                	li	s3,-1
  }
  return tot;
    80002e56:	0009851b          	sext.w	a0,s3
}
    80002e5a:	70a6                	ld	ra,104(sp)
    80002e5c:	7406                	ld	s0,96(sp)
    80002e5e:	64e6                	ld	s1,88(sp)
    80002e60:	6946                	ld	s2,80(sp)
    80002e62:	69a6                	ld	s3,72(sp)
    80002e64:	6a06                	ld	s4,64(sp)
    80002e66:	7ae2                	ld	s5,56(sp)
    80002e68:	7b42                	ld	s6,48(sp)
    80002e6a:	7ba2                	ld	s7,40(sp)
    80002e6c:	7c02                	ld	s8,32(sp)
    80002e6e:	6ce2                	ld	s9,24(sp)
    80002e70:	6d42                	ld	s10,16(sp)
    80002e72:	6da2                	ld	s11,8(sp)
    80002e74:	6165                	addi	sp,sp,112
    80002e76:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e78:	89d6                	mv	s3,s5
    80002e7a:	bff1                	j	80002e56 <readi+0xce>
    return 0;
    80002e7c:	4501                	li	a0,0
}
    80002e7e:	8082                	ret

0000000080002e80 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e80:	457c                	lw	a5,76(a0)
    80002e82:	10d7e863          	bltu	a5,a3,80002f92 <writei+0x112>
{
    80002e86:	7159                	addi	sp,sp,-112
    80002e88:	f486                	sd	ra,104(sp)
    80002e8a:	f0a2                	sd	s0,96(sp)
    80002e8c:	eca6                	sd	s1,88(sp)
    80002e8e:	e8ca                	sd	s2,80(sp)
    80002e90:	e4ce                	sd	s3,72(sp)
    80002e92:	e0d2                	sd	s4,64(sp)
    80002e94:	fc56                	sd	s5,56(sp)
    80002e96:	f85a                	sd	s6,48(sp)
    80002e98:	f45e                	sd	s7,40(sp)
    80002e9a:	f062                	sd	s8,32(sp)
    80002e9c:	ec66                	sd	s9,24(sp)
    80002e9e:	e86a                	sd	s10,16(sp)
    80002ea0:	e46e                	sd	s11,8(sp)
    80002ea2:	1880                	addi	s0,sp,112
    80002ea4:	8aaa                	mv	s5,a0
    80002ea6:	8bae                	mv	s7,a1
    80002ea8:	8a32                	mv	s4,a2
    80002eaa:	8936                	mv	s2,a3
    80002eac:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002eae:	00e687bb          	addw	a5,a3,a4
    80002eb2:	0ed7e263          	bltu	a5,a3,80002f96 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002eb6:	00043737          	lui	a4,0x43
    80002eba:	0ef76063          	bltu	a4,a5,80002f9a <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ebe:	0c0b0863          	beqz	s6,80002f8e <writei+0x10e>
    80002ec2:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ec4:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ec8:	5c7d                	li	s8,-1
    80002eca:	a091                	j	80002f0e <writei+0x8e>
    80002ecc:	020d1d93          	slli	s11,s10,0x20
    80002ed0:	020ddd93          	srli	s11,s11,0x20
    80002ed4:	05848513          	addi	a0,s1,88
    80002ed8:	86ee                	mv	a3,s11
    80002eda:	8652                	mv	a2,s4
    80002edc:	85de                	mv	a1,s7
    80002ede:	953a                	add	a0,a0,a4
    80002ee0:	fffff097          	auipc	ra,0xfffff
    80002ee4:	a7a080e7          	jalr	-1414(ra) # 8000195a <either_copyin>
    80002ee8:	07850263          	beq	a0,s8,80002f4c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002eec:	8526                	mv	a0,s1
    80002eee:	00000097          	auipc	ra,0x0
    80002ef2:	788080e7          	jalr	1928(ra) # 80003676 <log_write>
    brelse(bp);
    80002ef6:	8526                	mv	a0,s1
    80002ef8:	fffff097          	auipc	ra,0xfffff
    80002efc:	4f4080e7          	jalr	1268(ra) # 800023ec <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f00:	013d09bb          	addw	s3,s10,s3
    80002f04:	012d093b          	addw	s2,s10,s2
    80002f08:	9a6e                	add	s4,s4,s11
    80002f0a:	0569f663          	bgeu	s3,s6,80002f56 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80002f0e:	00a9559b          	srliw	a1,s2,0xa
    80002f12:	8556                	mv	a0,s5
    80002f14:	fffff097          	auipc	ra,0xfffff
    80002f18:	79c080e7          	jalr	1948(ra) # 800026b0 <bmap>
    80002f1c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f20:	c99d                	beqz	a1,80002f56 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80002f22:	000aa503          	lw	a0,0(s5)
    80002f26:	fffff097          	auipc	ra,0xfffff
    80002f2a:	396080e7          	jalr	918(ra) # 800022bc <bread>
    80002f2e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f30:	3ff97713          	andi	a4,s2,1023
    80002f34:	40ec87bb          	subw	a5,s9,a4
    80002f38:	413b06bb          	subw	a3,s6,s3
    80002f3c:	8d3e                	mv	s10,a5
    80002f3e:	2781                	sext.w	a5,a5
    80002f40:	0006861b          	sext.w	a2,a3
    80002f44:	f8f674e3          	bgeu	a2,a5,80002ecc <writei+0x4c>
    80002f48:	8d36                	mv	s10,a3
    80002f4a:	b749                	j	80002ecc <writei+0x4c>
      brelse(bp);
    80002f4c:	8526                	mv	a0,s1
    80002f4e:	fffff097          	auipc	ra,0xfffff
    80002f52:	49e080e7          	jalr	1182(ra) # 800023ec <brelse>
  }

  if(off > ip->size)
    80002f56:	04caa783          	lw	a5,76(s5)
    80002f5a:	0127f463          	bgeu	a5,s2,80002f62 <writei+0xe2>
    ip->size = off;
    80002f5e:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002f62:	8556                	mv	a0,s5
    80002f64:	00000097          	auipc	ra,0x0
    80002f68:	aa4080e7          	jalr	-1372(ra) # 80002a08 <iupdate>

  return tot;
    80002f6c:	0009851b          	sext.w	a0,s3
}
    80002f70:	70a6                	ld	ra,104(sp)
    80002f72:	7406                	ld	s0,96(sp)
    80002f74:	64e6                	ld	s1,88(sp)
    80002f76:	6946                	ld	s2,80(sp)
    80002f78:	69a6                	ld	s3,72(sp)
    80002f7a:	6a06                	ld	s4,64(sp)
    80002f7c:	7ae2                	ld	s5,56(sp)
    80002f7e:	7b42                	ld	s6,48(sp)
    80002f80:	7ba2                	ld	s7,40(sp)
    80002f82:	7c02                	ld	s8,32(sp)
    80002f84:	6ce2                	ld	s9,24(sp)
    80002f86:	6d42                	ld	s10,16(sp)
    80002f88:	6da2                	ld	s11,8(sp)
    80002f8a:	6165                	addi	sp,sp,112
    80002f8c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f8e:	89da                	mv	s3,s6
    80002f90:	bfc9                	j	80002f62 <writei+0xe2>
    return -1;
    80002f92:	557d                	li	a0,-1
}
    80002f94:	8082                	ret
    return -1;
    80002f96:	557d                	li	a0,-1
    80002f98:	bfe1                	j	80002f70 <writei+0xf0>
    return -1;
    80002f9a:	557d                	li	a0,-1
    80002f9c:	bfd1                	j	80002f70 <writei+0xf0>

0000000080002f9e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002f9e:	1141                	addi	sp,sp,-16
    80002fa0:	e406                	sd	ra,8(sp)
    80002fa2:	e022                	sd	s0,0(sp)
    80002fa4:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002fa6:	4639                	li	a2,14
    80002fa8:	ffffd097          	auipc	ra,0xffffd
    80002fac:	2a2080e7          	jalr	674(ra) # 8000024a <strncmp>
}
    80002fb0:	60a2                	ld	ra,8(sp)
    80002fb2:	6402                	ld	s0,0(sp)
    80002fb4:	0141                	addi	sp,sp,16
    80002fb6:	8082                	ret

0000000080002fb8 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002fb8:	7139                	addi	sp,sp,-64
    80002fba:	fc06                	sd	ra,56(sp)
    80002fbc:	f822                	sd	s0,48(sp)
    80002fbe:	f426                	sd	s1,40(sp)
    80002fc0:	f04a                	sd	s2,32(sp)
    80002fc2:	ec4e                	sd	s3,24(sp)
    80002fc4:	e852                	sd	s4,16(sp)
    80002fc6:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002fc8:	04451703          	lh	a4,68(a0)
    80002fcc:	4785                	li	a5,1
    80002fce:	00f71a63          	bne	a4,a5,80002fe2 <dirlookup+0x2a>
    80002fd2:	892a                	mv	s2,a0
    80002fd4:	89ae                	mv	s3,a1
    80002fd6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fd8:	457c                	lw	a5,76(a0)
    80002fda:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002fdc:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fde:	e79d                	bnez	a5,8000300c <dirlookup+0x54>
    80002fe0:	a8a5                	j	80003058 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80002fe2:	00005517          	auipc	a0,0x5
    80002fe6:	58e50513          	addi	a0,a0,1422 # 80008570 <syscalls+0x1a0>
    80002fea:	00003097          	auipc	ra,0x3
    80002fee:	ba2080e7          	jalr	-1118(ra) # 80005b8c <panic>
      panic("dirlookup read");
    80002ff2:	00005517          	auipc	a0,0x5
    80002ff6:	59650513          	addi	a0,a0,1430 # 80008588 <syscalls+0x1b8>
    80002ffa:	00003097          	auipc	ra,0x3
    80002ffe:	b92080e7          	jalr	-1134(ra) # 80005b8c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003002:	24c1                	addiw	s1,s1,16
    80003004:	04c92783          	lw	a5,76(s2)
    80003008:	04f4f763          	bgeu	s1,a5,80003056 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000300c:	4741                	li	a4,16
    8000300e:	86a6                	mv	a3,s1
    80003010:	fc040613          	addi	a2,s0,-64
    80003014:	4581                	li	a1,0
    80003016:	854a                	mv	a0,s2
    80003018:	00000097          	auipc	ra,0x0
    8000301c:	d70080e7          	jalr	-656(ra) # 80002d88 <readi>
    80003020:	47c1                	li	a5,16
    80003022:	fcf518e3          	bne	a0,a5,80002ff2 <dirlookup+0x3a>
    if(de.inum == 0)
    80003026:	fc045783          	lhu	a5,-64(s0)
    8000302a:	dfe1                	beqz	a5,80003002 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000302c:	fc240593          	addi	a1,s0,-62
    80003030:	854e                	mv	a0,s3
    80003032:	00000097          	auipc	ra,0x0
    80003036:	f6c080e7          	jalr	-148(ra) # 80002f9e <namecmp>
    8000303a:	f561                	bnez	a0,80003002 <dirlookup+0x4a>
      if(poff)
    8000303c:	000a0463          	beqz	s4,80003044 <dirlookup+0x8c>
        *poff = off;
    80003040:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003044:	fc045583          	lhu	a1,-64(s0)
    80003048:	00092503          	lw	a0,0(s2)
    8000304c:	fffff097          	auipc	ra,0xfffff
    80003050:	74e080e7          	jalr	1870(ra) # 8000279a <iget>
    80003054:	a011                	j	80003058 <dirlookup+0xa0>
  return 0;
    80003056:	4501                	li	a0,0
}
    80003058:	70e2                	ld	ra,56(sp)
    8000305a:	7442                	ld	s0,48(sp)
    8000305c:	74a2                	ld	s1,40(sp)
    8000305e:	7902                	ld	s2,32(sp)
    80003060:	69e2                	ld	s3,24(sp)
    80003062:	6a42                	ld	s4,16(sp)
    80003064:	6121                	addi	sp,sp,64
    80003066:	8082                	ret

0000000080003068 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003068:	711d                	addi	sp,sp,-96
    8000306a:	ec86                	sd	ra,88(sp)
    8000306c:	e8a2                	sd	s0,80(sp)
    8000306e:	e4a6                	sd	s1,72(sp)
    80003070:	e0ca                	sd	s2,64(sp)
    80003072:	fc4e                	sd	s3,56(sp)
    80003074:	f852                	sd	s4,48(sp)
    80003076:	f456                	sd	s5,40(sp)
    80003078:	f05a                	sd	s6,32(sp)
    8000307a:	ec5e                	sd	s7,24(sp)
    8000307c:	e862                	sd	s8,16(sp)
    8000307e:	e466                	sd	s9,8(sp)
    80003080:	e06a                	sd	s10,0(sp)
    80003082:	1080                	addi	s0,sp,96
    80003084:	84aa                	mv	s1,a0
    80003086:	8b2e                	mv	s6,a1
    80003088:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000308a:	00054703          	lbu	a4,0(a0)
    8000308e:	02f00793          	li	a5,47
    80003092:	02f70363          	beq	a4,a5,800030b8 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003096:	ffffe097          	auipc	ra,0xffffe
    8000309a:	dbe080e7          	jalr	-578(ra) # 80000e54 <myproc>
    8000309e:	15053503          	ld	a0,336(a0)
    800030a2:	00000097          	auipc	ra,0x0
    800030a6:	9f4080e7          	jalr	-1548(ra) # 80002a96 <idup>
    800030aa:	8a2a                	mv	s4,a0
  while(*path == '/')
    800030ac:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800030b0:	4cb5                	li	s9,13
  len = path - s;
    800030b2:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800030b4:	4c05                	li	s8,1
    800030b6:	a87d                	j	80003174 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800030b8:	4585                	li	a1,1
    800030ba:	4505                	li	a0,1
    800030bc:	fffff097          	auipc	ra,0xfffff
    800030c0:	6de080e7          	jalr	1758(ra) # 8000279a <iget>
    800030c4:	8a2a                	mv	s4,a0
    800030c6:	b7dd                	j	800030ac <namex+0x44>
      iunlockput(ip);
    800030c8:	8552                	mv	a0,s4
    800030ca:	00000097          	auipc	ra,0x0
    800030ce:	c6c080e7          	jalr	-916(ra) # 80002d36 <iunlockput>
      return 0;
    800030d2:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800030d4:	8552                	mv	a0,s4
    800030d6:	60e6                	ld	ra,88(sp)
    800030d8:	6446                	ld	s0,80(sp)
    800030da:	64a6                	ld	s1,72(sp)
    800030dc:	6906                	ld	s2,64(sp)
    800030de:	79e2                	ld	s3,56(sp)
    800030e0:	7a42                	ld	s4,48(sp)
    800030e2:	7aa2                	ld	s5,40(sp)
    800030e4:	7b02                	ld	s6,32(sp)
    800030e6:	6be2                	ld	s7,24(sp)
    800030e8:	6c42                	ld	s8,16(sp)
    800030ea:	6ca2                	ld	s9,8(sp)
    800030ec:	6d02                	ld	s10,0(sp)
    800030ee:	6125                	addi	sp,sp,96
    800030f0:	8082                	ret
      iunlock(ip);
    800030f2:	8552                	mv	a0,s4
    800030f4:	00000097          	auipc	ra,0x0
    800030f8:	aa2080e7          	jalr	-1374(ra) # 80002b96 <iunlock>
      return ip;
    800030fc:	bfe1                	j	800030d4 <namex+0x6c>
      iunlockput(ip);
    800030fe:	8552                	mv	a0,s4
    80003100:	00000097          	auipc	ra,0x0
    80003104:	c36080e7          	jalr	-970(ra) # 80002d36 <iunlockput>
      return 0;
    80003108:	8a4e                	mv	s4,s3
    8000310a:	b7e9                	j	800030d4 <namex+0x6c>
  len = path - s;
    8000310c:	40998633          	sub	a2,s3,s1
    80003110:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003114:	09acd863          	bge	s9,s10,800031a4 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003118:	4639                	li	a2,14
    8000311a:	85a6                	mv	a1,s1
    8000311c:	8556                	mv	a0,s5
    8000311e:	ffffd097          	auipc	ra,0xffffd
    80003122:	0b8080e7          	jalr	184(ra) # 800001d6 <memmove>
    80003126:	84ce                	mv	s1,s3
  while(*path == '/')
    80003128:	0004c783          	lbu	a5,0(s1)
    8000312c:	01279763          	bne	a5,s2,8000313a <namex+0xd2>
    path++;
    80003130:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003132:	0004c783          	lbu	a5,0(s1)
    80003136:	ff278de3          	beq	a5,s2,80003130 <namex+0xc8>
    ilock(ip);
    8000313a:	8552                	mv	a0,s4
    8000313c:	00000097          	auipc	ra,0x0
    80003140:	998080e7          	jalr	-1640(ra) # 80002ad4 <ilock>
    if(ip->type != T_DIR){
    80003144:	044a1783          	lh	a5,68(s4)
    80003148:	f98790e3          	bne	a5,s8,800030c8 <namex+0x60>
    if(nameiparent && *path == '\0'){
    8000314c:	000b0563          	beqz	s6,80003156 <namex+0xee>
    80003150:	0004c783          	lbu	a5,0(s1)
    80003154:	dfd9                	beqz	a5,800030f2 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003156:	865e                	mv	a2,s7
    80003158:	85d6                	mv	a1,s5
    8000315a:	8552                	mv	a0,s4
    8000315c:	00000097          	auipc	ra,0x0
    80003160:	e5c080e7          	jalr	-420(ra) # 80002fb8 <dirlookup>
    80003164:	89aa                	mv	s3,a0
    80003166:	dd41                	beqz	a0,800030fe <namex+0x96>
    iunlockput(ip);
    80003168:	8552                	mv	a0,s4
    8000316a:	00000097          	auipc	ra,0x0
    8000316e:	bcc080e7          	jalr	-1076(ra) # 80002d36 <iunlockput>
    ip = next;
    80003172:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003174:	0004c783          	lbu	a5,0(s1)
    80003178:	01279763          	bne	a5,s2,80003186 <namex+0x11e>
    path++;
    8000317c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000317e:	0004c783          	lbu	a5,0(s1)
    80003182:	ff278de3          	beq	a5,s2,8000317c <namex+0x114>
  if(*path == 0)
    80003186:	cb9d                	beqz	a5,800031bc <namex+0x154>
  while(*path != '/' && *path != 0)
    80003188:	0004c783          	lbu	a5,0(s1)
    8000318c:	89a6                	mv	s3,s1
  len = path - s;
    8000318e:	8d5e                	mv	s10,s7
    80003190:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003192:	01278963          	beq	a5,s2,800031a4 <namex+0x13c>
    80003196:	dbbd                	beqz	a5,8000310c <namex+0xa4>
    path++;
    80003198:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000319a:	0009c783          	lbu	a5,0(s3)
    8000319e:	ff279ce3          	bne	a5,s2,80003196 <namex+0x12e>
    800031a2:	b7ad                	j	8000310c <namex+0xa4>
    memmove(name, s, len);
    800031a4:	2601                	sext.w	a2,a2
    800031a6:	85a6                	mv	a1,s1
    800031a8:	8556                	mv	a0,s5
    800031aa:	ffffd097          	auipc	ra,0xffffd
    800031ae:	02c080e7          	jalr	44(ra) # 800001d6 <memmove>
    name[len] = 0;
    800031b2:	9d56                	add	s10,s10,s5
    800031b4:	000d0023          	sb	zero,0(s10)
    800031b8:	84ce                	mv	s1,s3
    800031ba:	b7bd                	j	80003128 <namex+0xc0>
  if(nameiparent){
    800031bc:	f00b0ce3          	beqz	s6,800030d4 <namex+0x6c>
    iput(ip);
    800031c0:	8552                	mv	a0,s4
    800031c2:	00000097          	auipc	ra,0x0
    800031c6:	acc080e7          	jalr	-1332(ra) # 80002c8e <iput>
    return 0;
    800031ca:	4a01                	li	s4,0
    800031cc:	b721                	j	800030d4 <namex+0x6c>

00000000800031ce <dirlink>:
{
    800031ce:	7139                	addi	sp,sp,-64
    800031d0:	fc06                	sd	ra,56(sp)
    800031d2:	f822                	sd	s0,48(sp)
    800031d4:	f426                	sd	s1,40(sp)
    800031d6:	f04a                	sd	s2,32(sp)
    800031d8:	ec4e                	sd	s3,24(sp)
    800031da:	e852                	sd	s4,16(sp)
    800031dc:	0080                	addi	s0,sp,64
    800031de:	892a                	mv	s2,a0
    800031e0:	8a2e                	mv	s4,a1
    800031e2:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800031e4:	4601                	li	a2,0
    800031e6:	00000097          	auipc	ra,0x0
    800031ea:	dd2080e7          	jalr	-558(ra) # 80002fb8 <dirlookup>
    800031ee:	e93d                	bnez	a0,80003264 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031f0:	04c92483          	lw	s1,76(s2)
    800031f4:	c49d                	beqz	s1,80003222 <dirlink+0x54>
    800031f6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031f8:	4741                	li	a4,16
    800031fa:	86a6                	mv	a3,s1
    800031fc:	fc040613          	addi	a2,s0,-64
    80003200:	4581                	li	a1,0
    80003202:	854a                	mv	a0,s2
    80003204:	00000097          	auipc	ra,0x0
    80003208:	b84080e7          	jalr	-1148(ra) # 80002d88 <readi>
    8000320c:	47c1                	li	a5,16
    8000320e:	06f51163          	bne	a0,a5,80003270 <dirlink+0xa2>
    if(de.inum == 0)
    80003212:	fc045783          	lhu	a5,-64(s0)
    80003216:	c791                	beqz	a5,80003222 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003218:	24c1                	addiw	s1,s1,16
    8000321a:	04c92783          	lw	a5,76(s2)
    8000321e:	fcf4ede3          	bltu	s1,a5,800031f8 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003222:	4639                	li	a2,14
    80003224:	85d2                	mv	a1,s4
    80003226:	fc240513          	addi	a0,s0,-62
    8000322a:	ffffd097          	auipc	ra,0xffffd
    8000322e:	05c080e7          	jalr	92(ra) # 80000286 <strncpy>
  de.inum = inum;
    80003232:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003236:	4741                	li	a4,16
    80003238:	86a6                	mv	a3,s1
    8000323a:	fc040613          	addi	a2,s0,-64
    8000323e:	4581                	li	a1,0
    80003240:	854a                	mv	a0,s2
    80003242:	00000097          	auipc	ra,0x0
    80003246:	c3e080e7          	jalr	-962(ra) # 80002e80 <writei>
    8000324a:	1541                	addi	a0,a0,-16
    8000324c:	00a03533          	snez	a0,a0
    80003250:	40a00533          	neg	a0,a0
}
    80003254:	70e2                	ld	ra,56(sp)
    80003256:	7442                	ld	s0,48(sp)
    80003258:	74a2                	ld	s1,40(sp)
    8000325a:	7902                	ld	s2,32(sp)
    8000325c:	69e2                	ld	s3,24(sp)
    8000325e:	6a42                	ld	s4,16(sp)
    80003260:	6121                	addi	sp,sp,64
    80003262:	8082                	ret
    iput(ip);
    80003264:	00000097          	auipc	ra,0x0
    80003268:	a2a080e7          	jalr	-1494(ra) # 80002c8e <iput>
    return -1;
    8000326c:	557d                	li	a0,-1
    8000326e:	b7dd                	j	80003254 <dirlink+0x86>
      panic("dirlink read");
    80003270:	00005517          	auipc	a0,0x5
    80003274:	32850513          	addi	a0,a0,808 # 80008598 <syscalls+0x1c8>
    80003278:	00003097          	auipc	ra,0x3
    8000327c:	914080e7          	jalr	-1772(ra) # 80005b8c <panic>

0000000080003280 <namei>:

struct inode*
namei(char *path)
{
    80003280:	1101                	addi	sp,sp,-32
    80003282:	ec06                	sd	ra,24(sp)
    80003284:	e822                	sd	s0,16(sp)
    80003286:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003288:	fe040613          	addi	a2,s0,-32
    8000328c:	4581                	li	a1,0
    8000328e:	00000097          	auipc	ra,0x0
    80003292:	dda080e7          	jalr	-550(ra) # 80003068 <namex>
}
    80003296:	60e2                	ld	ra,24(sp)
    80003298:	6442                	ld	s0,16(sp)
    8000329a:	6105                	addi	sp,sp,32
    8000329c:	8082                	ret

000000008000329e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000329e:	1141                	addi	sp,sp,-16
    800032a0:	e406                	sd	ra,8(sp)
    800032a2:	e022                	sd	s0,0(sp)
    800032a4:	0800                	addi	s0,sp,16
    800032a6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800032a8:	4585                	li	a1,1
    800032aa:	00000097          	auipc	ra,0x0
    800032ae:	dbe080e7          	jalr	-578(ra) # 80003068 <namex>
}
    800032b2:	60a2                	ld	ra,8(sp)
    800032b4:	6402                	ld	s0,0(sp)
    800032b6:	0141                	addi	sp,sp,16
    800032b8:	8082                	ret

00000000800032ba <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800032ba:	1101                	addi	sp,sp,-32
    800032bc:	ec06                	sd	ra,24(sp)
    800032be:	e822                	sd	s0,16(sp)
    800032c0:	e426                	sd	s1,8(sp)
    800032c2:	e04a                	sd	s2,0(sp)
    800032c4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800032c6:	00015917          	auipc	s2,0x15
    800032ca:	60a90913          	addi	s2,s2,1546 # 800188d0 <log>
    800032ce:	01892583          	lw	a1,24(s2)
    800032d2:	02892503          	lw	a0,40(s2)
    800032d6:	fffff097          	auipc	ra,0xfffff
    800032da:	fe6080e7          	jalr	-26(ra) # 800022bc <bread>
    800032de:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800032e0:	02c92683          	lw	a3,44(s2)
    800032e4:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800032e6:	02d05863          	blez	a3,80003316 <write_head+0x5c>
    800032ea:	00015797          	auipc	a5,0x15
    800032ee:	61678793          	addi	a5,a5,1558 # 80018900 <log+0x30>
    800032f2:	05c50713          	addi	a4,a0,92
    800032f6:	36fd                	addiw	a3,a3,-1
    800032f8:	02069613          	slli	a2,a3,0x20
    800032fc:	01e65693          	srli	a3,a2,0x1e
    80003300:	00015617          	auipc	a2,0x15
    80003304:	60460613          	addi	a2,a2,1540 # 80018904 <log+0x34>
    80003308:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000330a:	4390                	lw	a2,0(a5)
    8000330c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000330e:	0791                	addi	a5,a5,4
    80003310:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    80003312:	fed79ce3          	bne	a5,a3,8000330a <write_head+0x50>
  }
  bwrite(buf);
    80003316:	8526                	mv	a0,s1
    80003318:	fffff097          	auipc	ra,0xfffff
    8000331c:	096080e7          	jalr	150(ra) # 800023ae <bwrite>
  brelse(buf);
    80003320:	8526                	mv	a0,s1
    80003322:	fffff097          	auipc	ra,0xfffff
    80003326:	0ca080e7          	jalr	202(ra) # 800023ec <brelse>
}
    8000332a:	60e2                	ld	ra,24(sp)
    8000332c:	6442                	ld	s0,16(sp)
    8000332e:	64a2                	ld	s1,8(sp)
    80003330:	6902                	ld	s2,0(sp)
    80003332:	6105                	addi	sp,sp,32
    80003334:	8082                	ret

0000000080003336 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003336:	00015797          	auipc	a5,0x15
    8000333a:	5c67a783          	lw	a5,1478(a5) # 800188fc <log+0x2c>
    8000333e:	0af05d63          	blez	a5,800033f8 <install_trans+0xc2>
{
    80003342:	7139                	addi	sp,sp,-64
    80003344:	fc06                	sd	ra,56(sp)
    80003346:	f822                	sd	s0,48(sp)
    80003348:	f426                	sd	s1,40(sp)
    8000334a:	f04a                	sd	s2,32(sp)
    8000334c:	ec4e                	sd	s3,24(sp)
    8000334e:	e852                	sd	s4,16(sp)
    80003350:	e456                	sd	s5,8(sp)
    80003352:	e05a                	sd	s6,0(sp)
    80003354:	0080                	addi	s0,sp,64
    80003356:	8b2a                	mv	s6,a0
    80003358:	00015a97          	auipc	s5,0x15
    8000335c:	5a8a8a93          	addi	s5,s5,1448 # 80018900 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003360:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003362:	00015997          	auipc	s3,0x15
    80003366:	56e98993          	addi	s3,s3,1390 # 800188d0 <log>
    8000336a:	a00d                	j	8000338c <install_trans+0x56>
    brelse(lbuf);
    8000336c:	854a                	mv	a0,s2
    8000336e:	fffff097          	auipc	ra,0xfffff
    80003372:	07e080e7          	jalr	126(ra) # 800023ec <brelse>
    brelse(dbuf);
    80003376:	8526                	mv	a0,s1
    80003378:	fffff097          	auipc	ra,0xfffff
    8000337c:	074080e7          	jalr	116(ra) # 800023ec <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003380:	2a05                	addiw	s4,s4,1
    80003382:	0a91                	addi	s5,s5,4
    80003384:	02c9a783          	lw	a5,44(s3)
    80003388:	04fa5e63          	bge	s4,a5,800033e4 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000338c:	0189a583          	lw	a1,24(s3)
    80003390:	014585bb          	addw	a1,a1,s4
    80003394:	2585                	addiw	a1,a1,1
    80003396:	0289a503          	lw	a0,40(s3)
    8000339a:	fffff097          	auipc	ra,0xfffff
    8000339e:	f22080e7          	jalr	-222(ra) # 800022bc <bread>
    800033a2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800033a4:	000aa583          	lw	a1,0(s5)
    800033a8:	0289a503          	lw	a0,40(s3)
    800033ac:	fffff097          	auipc	ra,0xfffff
    800033b0:	f10080e7          	jalr	-240(ra) # 800022bc <bread>
    800033b4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800033b6:	40000613          	li	a2,1024
    800033ba:	05890593          	addi	a1,s2,88
    800033be:	05850513          	addi	a0,a0,88
    800033c2:	ffffd097          	auipc	ra,0xffffd
    800033c6:	e14080e7          	jalr	-492(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800033ca:	8526                	mv	a0,s1
    800033cc:	fffff097          	auipc	ra,0xfffff
    800033d0:	fe2080e7          	jalr	-30(ra) # 800023ae <bwrite>
    if(recovering == 0)
    800033d4:	f80b1ce3          	bnez	s6,8000336c <install_trans+0x36>
      bunpin(dbuf);
    800033d8:	8526                	mv	a0,s1
    800033da:	fffff097          	auipc	ra,0xfffff
    800033de:	0ec080e7          	jalr	236(ra) # 800024c6 <bunpin>
    800033e2:	b769                	j	8000336c <install_trans+0x36>
}
    800033e4:	70e2                	ld	ra,56(sp)
    800033e6:	7442                	ld	s0,48(sp)
    800033e8:	74a2                	ld	s1,40(sp)
    800033ea:	7902                	ld	s2,32(sp)
    800033ec:	69e2                	ld	s3,24(sp)
    800033ee:	6a42                	ld	s4,16(sp)
    800033f0:	6aa2                	ld	s5,8(sp)
    800033f2:	6b02                	ld	s6,0(sp)
    800033f4:	6121                	addi	sp,sp,64
    800033f6:	8082                	ret
    800033f8:	8082                	ret

00000000800033fa <initlog>:
{
    800033fa:	7179                	addi	sp,sp,-48
    800033fc:	f406                	sd	ra,40(sp)
    800033fe:	f022                	sd	s0,32(sp)
    80003400:	ec26                	sd	s1,24(sp)
    80003402:	e84a                	sd	s2,16(sp)
    80003404:	e44e                	sd	s3,8(sp)
    80003406:	1800                	addi	s0,sp,48
    80003408:	892a                	mv	s2,a0
    8000340a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000340c:	00015497          	auipc	s1,0x15
    80003410:	4c448493          	addi	s1,s1,1220 # 800188d0 <log>
    80003414:	00005597          	auipc	a1,0x5
    80003418:	19458593          	addi	a1,a1,404 # 800085a8 <syscalls+0x1d8>
    8000341c:	8526                	mv	a0,s1
    8000341e:	00003097          	auipc	ra,0x3
    80003422:	c16080e7          	jalr	-1002(ra) # 80006034 <initlock>
  log.start = sb->logstart;
    80003426:	0149a583          	lw	a1,20(s3)
    8000342a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000342c:	0109a783          	lw	a5,16(s3)
    80003430:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003432:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003436:	854a                	mv	a0,s2
    80003438:	fffff097          	auipc	ra,0xfffff
    8000343c:	e84080e7          	jalr	-380(ra) # 800022bc <bread>
  log.lh.n = lh->n;
    80003440:	4d34                	lw	a3,88(a0)
    80003442:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003444:	02d05663          	blez	a3,80003470 <initlog+0x76>
    80003448:	05c50793          	addi	a5,a0,92
    8000344c:	00015717          	auipc	a4,0x15
    80003450:	4b470713          	addi	a4,a4,1204 # 80018900 <log+0x30>
    80003454:	36fd                	addiw	a3,a3,-1
    80003456:	02069613          	slli	a2,a3,0x20
    8000345a:	01e65693          	srli	a3,a2,0x1e
    8000345e:	06050613          	addi	a2,a0,96
    80003462:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003464:	4390                	lw	a2,0(a5)
    80003466:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003468:	0791                	addi	a5,a5,4
    8000346a:	0711                	addi	a4,a4,4
    8000346c:	fed79ce3          	bne	a5,a3,80003464 <initlog+0x6a>
  brelse(buf);
    80003470:	fffff097          	auipc	ra,0xfffff
    80003474:	f7c080e7          	jalr	-132(ra) # 800023ec <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003478:	4505                	li	a0,1
    8000347a:	00000097          	auipc	ra,0x0
    8000347e:	ebc080e7          	jalr	-324(ra) # 80003336 <install_trans>
  log.lh.n = 0;
    80003482:	00015797          	auipc	a5,0x15
    80003486:	4607ad23          	sw	zero,1146(a5) # 800188fc <log+0x2c>
  write_head(); // clear the log
    8000348a:	00000097          	auipc	ra,0x0
    8000348e:	e30080e7          	jalr	-464(ra) # 800032ba <write_head>
}
    80003492:	70a2                	ld	ra,40(sp)
    80003494:	7402                	ld	s0,32(sp)
    80003496:	64e2                	ld	s1,24(sp)
    80003498:	6942                	ld	s2,16(sp)
    8000349a:	69a2                	ld	s3,8(sp)
    8000349c:	6145                	addi	sp,sp,48
    8000349e:	8082                	ret

00000000800034a0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800034a0:	1101                	addi	sp,sp,-32
    800034a2:	ec06                	sd	ra,24(sp)
    800034a4:	e822                	sd	s0,16(sp)
    800034a6:	e426                	sd	s1,8(sp)
    800034a8:	e04a                	sd	s2,0(sp)
    800034aa:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800034ac:	00015517          	auipc	a0,0x15
    800034b0:	42450513          	addi	a0,a0,1060 # 800188d0 <log>
    800034b4:	00003097          	auipc	ra,0x3
    800034b8:	c10080e7          	jalr	-1008(ra) # 800060c4 <acquire>
  while(1){
    if(log.committing){
    800034bc:	00015497          	auipc	s1,0x15
    800034c0:	41448493          	addi	s1,s1,1044 # 800188d0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034c4:	4979                	li	s2,30
    800034c6:	a039                	j	800034d4 <begin_op+0x34>
      sleep(&log, &log.lock);
    800034c8:	85a6                	mv	a1,s1
    800034ca:	8526                	mv	a0,s1
    800034cc:	ffffe097          	auipc	ra,0xffffe
    800034d0:	030080e7          	jalr	48(ra) # 800014fc <sleep>
    if(log.committing){
    800034d4:	50dc                	lw	a5,36(s1)
    800034d6:	fbed                	bnez	a5,800034c8 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034d8:	5098                	lw	a4,32(s1)
    800034da:	2705                	addiw	a4,a4,1
    800034dc:	0007069b          	sext.w	a3,a4
    800034e0:	0027179b          	slliw	a5,a4,0x2
    800034e4:	9fb9                	addw	a5,a5,a4
    800034e6:	0017979b          	slliw	a5,a5,0x1
    800034ea:	54d8                	lw	a4,44(s1)
    800034ec:	9fb9                	addw	a5,a5,a4
    800034ee:	00f95963          	bge	s2,a5,80003500 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800034f2:	85a6                	mv	a1,s1
    800034f4:	8526                	mv	a0,s1
    800034f6:	ffffe097          	auipc	ra,0xffffe
    800034fa:	006080e7          	jalr	6(ra) # 800014fc <sleep>
    800034fe:	bfd9                	j	800034d4 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003500:	00015517          	auipc	a0,0x15
    80003504:	3d050513          	addi	a0,a0,976 # 800188d0 <log>
    80003508:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000350a:	00003097          	auipc	ra,0x3
    8000350e:	c6e080e7          	jalr	-914(ra) # 80006178 <release>
      break;
    }
  }
}
    80003512:	60e2                	ld	ra,24(sp)
    80003514:	6442                	ld	s0,16(sp)
    80003516:	64a2                	ld	s1,8(sp)
    80003518:	6902                	ld	s2,0(sp)
    8000351a:	6105                	addi	sp,sp,32
    8000351c:	8082                	ret

000000008000351e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000351e:	7139                	addi	sp,sp,-64
    80003520:	fc06                	sd	ra,56(sp)
    80003522:	f822                	sd	s0,48(sp)
    80003524:	f426                	sd	s1,40(sp)
    80003526:	f04a                	sd	s2,32(sp)
    80003528:	ec4e                	sd	s3,24(sp)
    8000352a:	e852                	sd	s4,16(sp)
    8000352c:	e456                	sd	s5,8(sp)
    8000352e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003530:	00015497          	auipc	s1,0x15
    80003534:	3a048493          	addi	s1,s1,928 # 800188d0 <log>
    80003538:	8526                	mv	a0,s1
    8000353a:	00003097          	auipc	ra,0x3
    8000353e:	b8a080e7          	jalr	-1142(ra) # 800060c4 <acquire>
  log.outstanding -= 1;
    80003542:	509c                	lw	a5,32(s1)
    80003544:	37fd                	addiw	a5,a5,-1
    80003546:	0007891b          	sext.w	s2,a5
    8000354a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000354c:	50dc                	lw	a5,36(s1)
    8000354e:	e7b9                	bnez	a5,8000359c <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003550:	04091e63          	bnez	s2,800035ac <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003554:	00015497          	auipc	s1,0x15
    80003558:	37c48493          	addi	s1,s1,892 # 800188d0 <log>
    8000355c:	4785                	li	a5,1
    8000355e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003560:	8526                	mv	a0,s1
    80003562:	00003097          	auipc	ra,0x3
    80003566:	c16080e7          	jalr	-1002(ra) # 80006178 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000356a:	54dc                	lw	a5,44(s1)
    8000356c:	06f04763          	bgtz	a5,800035da <end_op+0xbc>
    acquire(&log.lock);
    80003570:	00015497          	auipc	s1,0x15
    80003574:	36048493          	addi	s1,s1,864 # 800188d0 <log>
    80003578:	8526                	mv	a0,s1
    8000357a:	00003097          	auipc	ra,0x3
    8000357e:	b4a080e7          	jalr	-1206(ra) # 800060c4 <acquire>
    log.committing = 0;
    80003582:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003586:	8526                	mv	a0,s1
    80003588:	ffffe097          	auipc	ra,0xffffe
    8000358c:	fd8080e7          	jalr	-40(ra) # 80001560 <wakeup>
    release(&log.lock);
    80003590:	8526                	mv	a0,s1
    80003592:	00003097          	auipc	ra,0x3
    80003596:	be6080e7          	jalr	-1050(ra) # 80006178 <release>
}
    8000359a:	a03d                	j	800035c8 <end_op+0xaa>
    panic("log.committing");
    8000359c:	00005517          	auipc	a0,0x5
    800035a0:	01450513          	addi	a0,a0,20 # 800085b0 <syscalls+0x1e0>
    800035a4:	00002097          	auipc	ra,0x2
    800035a8:	5e8080e7          	jalr	1512(ra) # 80005b8c <panic>
    wakeup(&log);
    800035ac:	00015497          	auipc	s1,0x15
    800035b0:	32448493          	addi	s1,s1,804 # 800188d0 <log>
    800035b4:	8526                	mv	a0,s1
    800035b6:	ffffe097          	auipc	ra,0xffffe
    800035ba:	faa080e7          	jalr	-86(ra) # 80001560 <wakeup>
  release(&log.lock);
    800035be:	8526                	mv	a0,s1
    800035c0:	00003097          	auipc	ra,0x3
    800035c4:	bb8080e7          	jalr	-1096(ra) # 80006178 <release>
}
    800035c8:	70e2                	ld	ra,56(sp)
    800035ca:	7442                	ld	s0,48(sp)
    800035cc:	74a2                	ld	s1,40(sp)
    800035ce:	7902                	ld	s2,32(sp)
    800035d0:	69e2                	ld	s3,24(sp)
    800035d2:	6a42                	ld	s4,16(sp)
    800035d4:	6aa2                	ld	s5,8(sp)
    800035d6:	6121                	addi	sp,sp,64
    800035d8:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800035da:	00015a97          	auipc	s5,0x15
    800035de:	326a8a93          	addi	s5,s5,806 # 80018900 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800035e2:	00015a17          	auipc	s4,0x15
    800035e6:	2eea0a13          	addi	s4,s4,750 # 800188d0 <log>
    800035ea:	018a2583          	lw	a1,24(s4)
    800035ee:	012585bb          	addw	a1,a1,s2
    800035f2:	2585                	addiw	a1,a1,1
    800035f4:	028a2503          	lw	a0,40(s4)
    800035f8:	fffff097          	auipc	ra,0xfffff
    800035fc:	cc4080e7          	jalr	-828(ra) # 800022bc <bread>
    80003600:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003602:	000aa583          	lw	a1,0(s5)
    80003606:	028a2503          	lw	a0,40(s4)
    8000360a:	fffff097          	auipc	ra,0xfffff
    8000360e:	cb2080e7          	jalr	-846(ra) # 800022bc <bread>
    80003612:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003614:	40000613          	li	a2,1024
    80003618:	05850593          	addi	a1,a0,88
    8000361c:	05848513          	addi	a0,s1,88
    80003620:	ffffd097          	auipc	ra,0xffffd
    80003624:	bb6080e7          	jalr	-1098(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003628:	8526                	mv	a0,s1
    8000362a:	fffff097          	auipc	ra,0xfffff
    8000362e:	d84080e7          	jalr	-636(ra) # 800023ae <bwrite>
    brelse(from);
    80003632:	854e                	mv	a0,s3
    80003634:	fffff097          	auipc	ra,0xfffff
    80003638:	db8080e7          	jalr	-584(ra) # 800023ec <brelse>
    brelse(to);
    8000363c:	8526                	mv	a0,s1
    8000363e:	fffff097          	auipc	ra,0xfffff
    80003642:	dae080e7          	jalr	-594(ra) # 800023ec <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003646:	2905                	addiw	s2,s2,1
    80003648:	0a91                	addi	s5,s5,4
    8000364a:	02ca2783          	lw	a5,44(s4)
    8000364e:	f8f94ee3          	blt	s2,a5,800035ea <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003652:	00000097          	auipc	ra,0x0
    80003656:	c68080e7          	jalr	-920(ra) # 800032ba <write_head>
    install_trans(0); // Now install writes to home locations
    8000365a:	4501                	li	a0,0
    8000365c:	00000097          	auipc	ra,0x0
    80003660:	cda080e7          	jalr	-806(ra) # 80003336 <install_trans>
    log.lh.n = 0;
    80003664:	00015797          	auipc	a5,0x15
    80003668:	2807ac23          	sw	zero,664(a5) # 800188fc <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000366c:	00000097          	auipc	ra,0x0
    80003670:	c4e080e7          	jalr	-946(ra) # 800032ba <write_head>
    80003674:	bdf5                	j	80003570 <end_op+0x52>

0000000080003676 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003676:	1101                	addi	sp,sp,-32
    80003678:	ec06                	sd	ra,24(sp)
    8000367a:	e822                	sd	s0,16(sp)
    8000367c:	e426                	sd	s1,8(sp)
    8000367e:	e04a                	sd	s2,0(sp)
    80003680:	1000                	addi	s0,sp,32
    80003682:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003684:	00015917          	auipc	s2,0x15
    80003688:	24c90913          	addi	s2,s2,588 # 800188d0 <log>
    8000368c:	854a                	mv	a0,s2
    8000368e:	00003097          	auipc	ra,0x3
    80003692:	a36080e7          	jalr	-1482(ra) # 800060c4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003696:	02c92603          	lw	a2,44(s2)
    8000369a:	47f5                	li	a5,29
    8000369c:	06c7c563          	blt	a5,a2,80003706 <log_write+0x90>
    800036a0:	00015797          	auipc	a5,0x15
    800036a4:	24c7a783          	lw	a5,588(a5) # 800188ec <log+0x1c>
    800036a8:	37fd                	addiw	a5,a5,-1
    800036aa:	04f65e63          	bge	a2,a5,80003706 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800036ae:	00015797          	auipc	a5,0x15
    800036b2:	2427a783          	lw	a5,578(a5) # 800188f0 <log+0x20>
    800036b6:	06f05063          	blez	a5,80003716 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800036ba:	4781                	li	a5,0
    800036bc:	06c05563          	blez	a2,80003726 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036c0:	44cc                	lw	a1,12(s1)
    800036c2:	00015717          	auipc	a4,0x15
    800036c6:	23e70713          	addi	a4,a4,574 # 80018900 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800036ca:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036cc:	4314                	lw	a3,0(a4)
    800036ce:	04b68c63          	beq	a3,a1,80003726 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800036d2:	2785                	addiw	a5,a5,1
    800036d4:	0711                	addi	a4,a4,4
    800036d6:	fef61be3          	bne	a2,a5,800036cc <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800036da:	0621                	addi	a2,a2,8
    800036dc:	060a                	slli	a2,a2,0x2
    800036de:	00015797          	auipc	a5,0x15
    800036e2:	1f278793          	addi	a5,a5,498 # 800188d0 <log>
    800036e6:	97b2                	add	a5,a5,a2
    800036e8:	44d8                	lw	a4,12(s1)
    800036ea:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800036ec:	8526                	mv	a0,s1
    800036ee:	fffff097          	auipc	ra,0xfffff
    800036f2:	d9c080e7          	jalr	-612(ra) # 8000248a <bpin>
    log.lh.n++;
    800036f6:	00015717          	auipc	a4,0x15
    800036fa:	1da70713          	addi	a4,a4,474 # 800188d0 <log>
    800036fe:	575c                	lw	a5,44(a4)
    80003700:	2785                	addiw	a5,a5,1
    80003702:	d75c                	sw	a5,44(a4)
    80003704:	a82d                	j	8000373e <log_write+0xc8>
    panic("too big a transaction");
    80003706:	00005517          	auipc	a0,0x5
    8000370a:	eba50513          	addi	a0,a0,-326 # 800085c0 <syscalls+0x1f0>
    8000370e:	00002097          	auipc	ra,0x2
    80003712:	47e080e7          	jalr	1150(ra) # 80005b8c <panic>
    panic("log_write outside of trans");
    80003716:	00005517          	auipc	a0,0x5
    8000371a:	ec250513          	addi	a0,a0,-318 # 800085d8 <syscalls+0x208>
    8000371e:	00002097          	auipc	ra,0x2
    80003722:	46e080e7          	jalr	1134(ra) # 80005b8c <panic>
  log.lh.block[i] = b->blockno;
    80003726:	00878693          	addi	a3,a5,8
    8000372a:	068a                	slli	a3,a3,0x2
    8000372c:	00015717          	auipc	a4,0x15
    80003730:	1a470713          	addi	a4,a4,420 # 800188d0 <log>
    80003734:	9736                	add	a4,a4,a3
    80003736:	44d4                	lw	a3,12(s1)
    80003738:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000373a:	faf609e3          	beq	a2,a5,800036ec <log_write+0x76>
  }
  release(&log.lock);
    8000373e:	00015517          	auipc	a0,0x15
    80003742:	19250513          	addi	a0,a0,402 # 800188d0 <log>
    80003746:	00003097          	auipc	ra,0x3
    8000374a:	a32080e7          	jalr	-1486(ra) # 80006178 <release>
}
    8000374e:	60e2                	ld	ra,24(sp)
    80003750:	6442                	ld	s0,16(sp)
    80003752:	64a2                	ld	s1,8(sp)
    80003754:	6902                	ld	s2,0(sp)
    80003756:	6105                	addi	sp,sp,32
    80003758:	8082                	ret

000000008000375a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000375a:	1101                	addi	sp,sp,-32
    8000375c:	ec06                	sd	ra,24(sp)
    8000375e:	e822                	sd	s0,16(sp)
    80003760:	e426                	sd	s1,8(sp)
    80003762:	e04a                	sd	s2,0(sp)
    80003764:	1000                	addi	s0,sp,32
    80003766:	84aa                	mv	s1,a0
    80003768:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000376a:	00005597          	auipc	a1,0x5
    8000376e:	e8e58593          	addi	a1,a1,-370 # 800085f8 <syscalls+0x228>
    80003772:	0521                	addi	a0,a0,8
    80003774:	00003097          	auipc	ra,0x3
    80003778:	8c0080e7          	jalr	-1856(ra) # 80006034 <initlock>
  lk->name = name;
    8000377c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003780:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003784:	0204a423          	sw	zero,40(s1)
}
    80003788:	60e2                	ld	ra,24(sp)
    8000378a:	6442                	ld	s0,16(sp)
    8000378c:	64a2                	ld	s1,8(sp)
    8000378e:	6902                	ld	s2,0(sp)
    80003790:	6105                	addi	sp,sp,32
    80003792:	8082                	ret

0000000080003794 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003794:	1101                	addi	sp,sp,-32
    80003796:	ec06                	sd	ra,24(sp)
    80003798:	e822                	sd	s0,16(sp)
    8000379a:	e426                	sd	s1,8(sp)
    8000379c:	e04a                	sd	s2,0(sp)
    8000379e:	1000                	addi	s0,sp,32
    800037a0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037a2:	00850913          	addi	s2,a0,8
    800037a6:	854a                	mv	a0,s2
    800037a8:	00003097          	auipc	ra,0x3
    800037ac:	91c080e7          	jalr	-1764(ra) # 800060c4 <acquire>
  while (lk->locked) {
    800037b0:	409c                	lw	a5,0(s1)
    800037b2:	cb89                	beqz	a5,800037c4 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800037b4:	85ca                	mv	a1,s2
    800037b6:	8526                	mv	a0,s1
    800037b8:	ffffe097          	auipc	ra,0xffffe
    800037bc:	d44080e7          	jalr	-700(ra) # 800014fc <sleep>
  while (lk->locked) {
    800037c0:	409c                	lw	a5,0(s1)
    800037c2:	fbed                	bnez	a5,800037b4 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800037c4:	4785                	li	a5,1
    800037c6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800037c8:	ffffd097          	auipc	ra,0xffffd
    800037cc:	68c080e7          	jalr	1676(ra) # 80000e54 <myproc>
    800037d0:	591c                	lw	a5,48(a0)
    800037d2:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800037d4:	854a                	mv	a0,s2
    800037d6:	00003097          	auipc	ra,0x3
    800037da:	9a2080e7          	jalr	-1630(ra) # 80006178 <release>
}
    800037de:	60e2                	ld	ra,24(sp)
    800037e0:	6442                	ld	s0,16(sp)
    800037e2:	64a2                	ld	s1,8(sp)
    800037e4:	6902                	ld	s2,0(sp)
    800037e6:	6105                	addi	sp,sp,32
    800037e8:	8082                	ret

00000000800037ea <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800037ea:	1101                	addi	sp,sp,-32
    800037ec:	ec06                	sd	ra,24(sp)
    800037ee:	e822                	sd	s0,16(sp)
    800037f0:	e426                	sd	s1,8(sp)
    800037f2:	e04a                	sd	s2,0(sp)
    800037f4:	1000                	addi	s0,sp,32
    800037f6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037f8:	00850913          	addi	s2,a0,8
    800037fc:	854a                	mv	a0,s2
    800037fe:	00003097          	auipc	ra,0x3
    80003802:	8c6080e7          	jalr	-1850(ra) # 800060c4 <acquire>
  lk->locked = 0;
    80003806:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000380a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000380e:	8526                	mv	a0,s1
    80003810:	ffffe097          	auipc	ra,0xffffe
    80003814:	d50080e7          	jalr	-688(ra) # 80001560 <wakeup>
  release(&lk->lk);
    80003818:	854a                	mv	a0,s2
    8000381a:	00003097          	auipc	ra,0x3
    8000381e:	95e080e7          	jalr	-1698(ra) # 80006178 <release>
}
    80003822:	60e2                	ld	ra,24(sp)
    80003824:	6442                	ld	s0,16(sp)
    80003826:	64a2                	ld	s1,8(sp)
    80003828:	6902                	ld	s2,0(sp)
    8000382a:	6105                	addi	sp,sp,32
    8000382c:	8082                	ret

000000008000382e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000382e:	7179                	addi	sp,sp,-48
    80003830:	f406                	sd	ra,40(sp)
    80003832:	f022                	sd	s0,32(sp)
    80003834:	ec26                	sd	s1,24(sp)
    80003836:	e84a                	sd	s2,16(sp)
    80003838:	e44e                	sd	s3,8(sp)
    8000383a:	1800                	addi	s0,sp,48
    8000383c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000383e:	00850913          	addi	s2,a0,8
    80003842:	854a                	mv	a0,s2
    80003844:	00003097          	auipc	ra,0x3
    80003848:	880080e7          	jalr	-1920(ra) # 800060c4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000384c:	409c                	lw	a5,0(s1)
    8000384e:	ef99                	bnez	a5,8000386c <holdingsleep+0x3e>
    80003850:	4481                	li	s1,0
  release(&lk->lk);
    80003852:	854a                	mv	a0,s2
    80003854:	00003097          	auipc	ra,0x3
    80003858:	924080e7          	jalr	-1756(ra) # 80006178 <release>
  return r;
}
    8000385c:	8526                	mv	a0,s1
    8000385e:	70a2                	ld	ra,40(sp)
    80003860:	7402                	ld	s0,32(sp)
    80003862:	64e2                	ld	s1,24(sp)
    80003864:	6942                	ld	s2,16(sp)
    80003866:	69a2                	ld	s3,8(sp)
    80003868:	6145                	addi	sp,sp,48
    8000386a:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000386c:	0284a983          	lw	s3,40(s1)
    80003870:	ffffd097          	auipc	ra,0xffffd
    80003874:	5e4080e7          	jalr	1508(ra) # 80000e54 <myproc>
    80003878:	5904                	lw	s1,48(a0)
    8000387a:	413484b3          	sub	s1,s1,s3
    8000387e:	0014b493          	seqz	s1,s1
    80003882:	bfc1                	j	80003852 <holdingsleep+0x24>

0000000080003884 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003884:	1141                	addi	sp,sp,-16
    80003886:	e406                	sd	ra,8(sp)
    80003888:	e022                	sd	s0,0(sp)
    8000388a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000388c:	00005597          	auipc	a1,0x5
    80003890:	d7c58593          	addi	a1,a1,-644 # 80008608 <syscalls+0x238>
    80003894:	00015517          	auipc	a0,0x15
    80003898:	18450513          	addi	a0,a0,388 # 80018a18 <ftable>
    8000389c:	00002097          	auipc	ra,0x2
    800038a0:	798080e7          	jalr	1944(ra) # 80006034 <initlock>
}
    800038a4:	60a2                	ld	ra,8(sp)
    800038a6:	6402                	ld	s0,0(sp)
    800038a8:	0141                	addi	sp,sp,16
    800038aa:	8082                	ret

00000000800038ac <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800038ac:	1101                	addi	sp,sp,-32
    800038ae:	ec06                	sd	ra,24(sp)
    800038b0:	e822                	sd	s0,16(sp)
    800038b2:	e426                	sd	s1,8(sp)
    800038b4:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800038b6:	00015517          	auipc	a0,0x15
    800038ba:	16250513          	addi	a0,a0,354 # 80018a18 <ftable>
    800038be:	00003097          	auipc	ra,0x3
    800038c2:	806080e7          	jalr	-2042(ra) # 800060c4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038c6:	00015497          	auipc	s1,0x15
    800038ca:	16a48493          	addi	s1,s1,362 # 80018a30 <ftable+0x18>
    800038ce:	00016717          	auipc	a4,0x16
    800038d2:	10270713          	addi	a4,a4,258 # 800199d0 <disk>
    if(f->ref == 0){
    800038d6:	40dc                	lw	a5,4(s1)
    800038d8:	cf99                	beqz	a5,800038f6 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038da:	02848493          	addi	s1,s1,40
    800038de:	fee49ce3          	bne	s1,a4,800038d6 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800038e2:	00015517          	auipc	a0,0x15
    800038e6:	13650513          	addi	a0,a0,310 # 80018a18 <ftable>
    800038ea:	00003097          	auipc	ra,0x3
    800038ee:	88e080e7          	jalr	-1906(ra) # 80006178 <release>
  return 0;
    800038f2:	4481                	li	s1,0
    800038f4:	a819                	j	8000390a <filealloc+0x5e>
      f->ref = 1;
    800038f6:	4785                	li	a5,1
    800038f8:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800038fa:	00015517          	auipc	a0,0x15
    800038fe:	11e50513          	addi	a0,a0,286 # 80018a18 <ftable>
    80003902:	00003097          	auipc	ra,0x3
    80003906:	876080e7          	jalr	-1930(ra) # 80006178 <release>
}
    8000390a:	8526                	mv	a0,s1
    8000390c:	60e2                	ld	ra,24(sp)
    8000390e:	6442                	ld	s0,16(sp)
    80003910:	64a2                	ld	s1,8(sp)
    80003912:	6105                	addi	sp,sp,32
    80003914:	8082                	ret

0000000080003916 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003916:	1101                	addi	sp,sp,-32
    80003918:	ec06                	sd	ra,24(sp)
    8000391a:	e822                	sd	s0,16(sp)
    8000391c:	e426                	sd	s1,8(sp)
    8000391e:	1000                	addi	s0,sp,32
    80003920:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003922:	00015517          	auipc	a0,0x15
    80003926:	0f650513          	addi	a0,a0,246 # 80018a18 <ftable>
    8000392a:	00002097          	auipc	ra,0x2
    8000392e:	79a080e7          	jalr	1946(ra) # 800060c4 <acquire>
  if(f->ref < 1)
    80003932:	40dc                	lw	a5,4(s1)
    80003934:	02f05263          	blez	a5,80003958 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003938:	2785                	addiw	a5,a5,1
    8000393a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000393c:	00015517          	auipc	a0,0x15
    80003940:	0dc50513          	addi	a0,a0,220 # 80018a18 <ftable>
    80003944:	00003097          	auipc	ra,0x3
    80003948:	834080e7          	jalr	-1996(ra) # 80006178 <release>
  return f;
}
    8000394c:	8526                	mv	a0,s1
    8000394e:	60e2                	ld	ra,24(sp)
    80003950:	6442                	ld	s0,16(sp)
    80003952:	64a2                	ld	s1,8(sp)
    80003954:	6105                	addi	sp,sp,32
    80003956:	8082                	ret
    panic("filedup");
    80003958:	00005517          	auipc	a0,0x5
    8000395c:	cb850513          	addi	a0,a0,-840 # 80008610 <syscalls+0x240>
    80003960:	00002097          	auipc	ra,0x2
    80003964:	22c080e7          	jalr	556(ra) # 80005b8c <panic>

0000000080003968 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003968:	7139                	addi	sp,sp,-64
    8000396a:	fc06                	sd	ra,56(sp)
    8000396c:	f822                	sd	s0,48(sp)
    8000396e:	f426                	sd	s1,40(sp)
    80003970:	f04a                	sd	s2,32(sp)
    80003972:	ec4e                	sd	s3,24(sp)
    80003974:	e852                	sd	s4,16(sp)
    80003976:	e456                	sd	s5,8(sp)
    80003978:	0080                	addi	s0,sp,64
    8000397a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000397c:	00015517          	auipc	a0,0x15
    80003980:	09c50513          	addi	a0,a0,156 # 80018a18 <ftable>
    80003984:	00002097          	auipc	ra,0x2
    80003988:	740080e7          	jalr	1856(ra) # 800060c4 <acquire>
  if(f->ref < 1)
    8000398c:	40dc                	lw	a5,4(s1)
    8000398e:	06f05163          	blez	a5,800039f0 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003992:	37fd                	addiw	a5,a5,-1
    80003994:	0007871b          	sext.w	a4,a5
    80003998:	c0dc                	sw	a5,4(s1)
    8000399a:	06e04363          	bgtz	a4,80003a00 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000399e:	0004a903          	lw	s2,0(s1)
    800039a2:	0094ca83          	lbu	s5,9(s1)
    800039a6:	0104ba03          	ld	s4,16(s1)
    800039aa:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800039ae:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800039b2:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800039b6:	00015517          	auipc	a0,0x15
    800039ba:	06250513          	addi	a0,a0,98 # 80018a18 <ftable>
    800039be:	00002097          	auipc	ra,0x2
    800039c2:	7ba080e7          	jalr	1978(ra) # 80006178 <release>

  if(ff.type == FD_PIPE){
    800039c6:	4785                	li	a5,1
    800039c8:	04f90d63          	beq	s2,a5,80003a22 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800039cc:	3979                	addiw	s2,s2,-2
    800039ce:	4785                	li	a5,1
    800039d0:	0527e063          	bltu	a5,s2,80003a10 <fileclose+0xa8>
    begin_op();
    800039d4:	00000097          	auipc	ra,0x0
    800039d8:	acc080e7          	jalr	-1332(ra) # 800034a0 <begin_op>
    iput(ff.ip);
    800039dc:	854e                	mv	a0,s3
    800039de:	fffff097          	auipc	ra,0xfffff
    800039e2:	2b0080e7          	jalr	688(ra) # 80002c8e <iput>
    end_op();
    800039e6:	00000097          	auipc	ra,0x0
    800039ea:	b38080e7          	jalr	-1224(ra) # 8000351e <end_op>
    800039ee:	a00d                	j	80003a10 <fileclose+0xa8>
    panic("fileclose");
    800039f0:	00005517          	auipc	a0,0x5
    800039f4:	c2850513          	addi	a0,a0,-984 # 80008618 <syscalls+0x248>
    800039f8:	00002097          	auipc	ra,0x2
    800039fc:	194080e7          	jalr	404(ra) # 80005b8c <panic>
    release(&ftable.lock);
    80003a00:	00015517          	auipc	a0,0x15
    80003a04:	01850513          	addi	a0,a0,24 # 80018a18 <ftable>
    80003a08:	00002097          	auipc	ra,0x2
    80003a0c:	770080e7          	jalr	1904(ra) # 80006178 <release>
  }
}
    80003a10:	70e2                	ld	ra,56(sp)
    80003a12:	7442                	ld	s0,48(sp)
    80003a14:	74a2                	ld	s1,40(sp)
    80003a16:	7902                	ld	s2,32(sp)
    80003a18:	69e2                	ld	s3,24(sp)
    80003a1a:	6a42                	ld	s4,16(sp)
    80003a1c:	6aa2                	ld	s5,8(sp)
    80003a1e:	6121                	addi	sp,sp,64
    80003a20:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a22:	85d6                	mv	a1,s5
    80003a24:	8552                	mv	a0,s4
    80003a26:	00000097          	auipc	ra,0x0
    80003a2a:	34c080e7          	jalr	844(ra) # 80003d72 <pipeclose>
    80003a2e:	b7cd                	j	80003a10 <fileclose+0xa8>

0000000080003a30 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a30:	715d                	addi	sp,sp,-80
    80003a32:	e486                	sd	ra,72(sp)
    80003a34:	e0a2                	sd	s0,64(sp)
    80003a36:	fc26                	sd	s1,56(sp)
    80003a38:	f84a                	sd	s2,48(sp)
    80003a3a:	f44e                	sd	s3,40(sp)
    80003a3c:	0880                	addi	s0,sp,80
    80003a3e:	84aa                	mv	s1,a0
    80003a40:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003a42:	ffffd097          	auipc	ra,0xffffd
    80003a46:	412080e7          	jalr	1042(ra) # 80000e54 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003a4a:	409c                	lw	a5,0(s1)
    80003a4c:	37f9                	addiw	a5,a5,-2
    80003a4e:	4705                	li	a4,1
    80003a50:	04f76763          	bltu	a4,a5,80003a9e <filestat+0x6e>
    80003a54:	892a                	mv	s2,a0
    ilock(f->ip);
    80003a56:	6c88                	ld	a0,24(s1)
    80003a58:	fffff097          	auipc	ra,0xfffff
    80003a5c:	07c080e7          	jalr	124(ra) # 80002ad4 <ilock>
    stati(f->ip, &st);
    80003a60:	fb840593          	addi	a1,s0,-72
    80003a64:	6c88                	ld	a0,24(s1)
    80003a66:	fffff097          	auipc	ra,0xfffff
    80003a6a:	2f8080e7          	jalr	760(ra) # 80002d5e <stati>
    iunlock(f->ip);
    80003a6e:	6c88                	ld	a0,24(s1)
    80003a70:	fffff097          	auipc	ra,0xfffff
    80003a74:	126080e7          	jalr	294(ra) # 80002b96 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003a78:	46e1                	li	a3,24
    80003a7a:	fb840613          	addi	a2,s0,-72
    80003a7e:	85ce                	mv	a1,s3
    80003a80:	05093503          	ld	a0,80(s2)
    80003a84:	ffffd097          	auipc	ra,0xffffd
    80003a88:	090080e7          	jalr	144(ra) # 80000b14 <copyout>
    80003a8c:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003a90:	60a6                	ld	ra,72(sp)
    80003a92:	6406                	ld	s0,64(sp)
    80003a94:	74e2                	ld	s1,56(sp)
    80003a96:	7942                	ld	s2,48(sp)
    80003a98:	79a2                	ld	s3,40(sp)
    80003a9a:	6161                	addi	sp,sp,80
    80003a9c:	8082                	ret
  return -1;
    80003a9e:	557d                	li	a0,-1
    80003aa0:	bfc5                	j	80003a90 <filestat+0x60>

0000000080003aa2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003aa2:	7179                	addi	sp,sp,-48
    80003aa4:	f406                	sd	ra,40(sp)
    80003aa6:	f022                	sd	s0,32(sp)
    80003aa8:	ec26                	sd	s1,24(sp)
    80003aaa:	e84a                	sd	s2,16(sp)
    80003aac:	e44e                	sd	s3,8(sp)
    80003aae:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003ab0:	00854783          	lbu	a5,8(a0)
    80003ab4:	c3d5                	beqz	a5,80003b58 <fileread+0xb6>
    80003ab6:	84aa                	mv	s1,a0
    80003ab8:	89ae                	mv	s3,a1
    80003aba:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003abc:	411c                	lw	a5,0(a0)
    80003abe:	4705                	li	a4,1
    80003ac0:	04e78963          	beq	a5,a4,80003b12 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ac4:	470d                	li	a4,3
    80003ac6:	04e78d63          	beq	a5,a4,80003b20 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003aca:	4709                	li	a4,2
    80003acc:	06e79e63          	bne	a5,a4,80003b48 <fileread+0xa6>
    ilock(f->ip);
    80003ad0:	6d08                	ld	a0,24(a0)
    80003ad2:	fffff097          	auipc	ra,0xfffff
    80003ad6:	002080e7          	jalr	2(ra) # 80002ad4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003ada:	874a                	mv	a4,s2
    80003adc:	5094                	lw	a3,32(s1)
    80003ade:	864e                	mv	a2,s3
    80003ae0:	4585                	li	a1,1
    80003ae2:	6c88                	ld	a0,24(s1)
    80003ae4:	fffff097          	auipc	ra,0xfffff
    80003ae8:	2a4080e7          	jalr	676(ra) # 80002d88 <readi>
    80003aec:	892a                	mv	s2,a0
    80003aee:	00a05563          	blez	a0,80003af8 <fileread+0x56>
      f->off += r;
    80003af2:	509c                	lw	a5,32(s1)
    80003af4:	9fa9                	addw	a5,a5,a0
    80003af6:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003af8:	6c88                	ld	a0,24(s1)
    80003afa:	fffff097          	auipc	ra,0xfffff
    80003afe:	09c080e7          	jalr	156(ra) # 80002b96 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003b02:	854a                	mv	a0,s2
    80003b04:	70a2                	ld	ra,40(sp)
    80003b06:	7402                	ld	s0,32(sp)
    80003b08:	64e2                	ld	s1,24(sp)
    80003b0a:	6942                	ld	s2,16(sp)
    80003b0c:	69a2                	ld	s3,8(sp)
    80003b0e:	6145                	addi	sp,sp,48
    80003b10:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b12:	6908                	ld	a0,16(a0)
    80003b14:	00000097          	auipc	ra,0x0
    80003b18:	3c6080e7          	jalr	966(ra) # 80003eda <piperead>
    80003b1c:	892a                	mv	s2,a0
    80003b1e:	b7d5                	j	80003b02 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b20:	02451783          	lh	a5,36(a0)
    80003b24:	03079693          	slli	a3,a5,0x30
    80003b28:	92c1                	srli	a3,a3,0x30
    80003b2a:	4725                	li	a4,9
    80003b2c:	02d76863          	bltu	a4,a3,80003b5c <fileread+0xba>
    80003b30:	0792                	slli	a5,a5,0x4
    80003b32:	00015717          	auipc	a4,0x15
    80003b36:	e4670713          	addi	a4,a4,-442 # 80018978 <devsw>
    80003b3a:	97ba                	add	a5,a5,a4
    80003b3c:	639c                	ld	a5,0(a5)
    80003b3e:	c38d                	beqz	a5,80003b60 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003b40:	4505                	li	a0,1
    80003b42:	9782                	jalr	a5
    80003b44:	892a                	mv	s2,a0
    80003b46:	bf75                	j	80003b02 <fileread+0x60>
    panic("fileread");
    80003b48:	00005517          	auipc	a0,0x5
    80003b4c:	ae050513          	addi	a0,a0,-1312 # 80008628 <syscalls+0x258>
    80003b50:	00002097          	auipc	ra,0x2
    80003b54:	03c080e7          	jalr	60(ra) # 80005b8c <panic>
    return -1;
    80003b58:	597d                	li	s2,-1
    80003b5a:	b765                	j	80003b02 <fileread+0x60>
      return -1;
    80003b5c:	597d                	li	s2,-1
    80003b5e:	b755                	j	80003b02 <fileread+0x60>
    80003b60:	597d                	li	s2,-1
    80003b62:	b745                	j	80003b02 <fileread+0x60>

0000000080003b64 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003b64:	715d                	addi	sp,sp,-80
    80003b66:	e486                	sd	ra,72(sp)
    80003b68:	e0a2                	sd	s0,64(sp)
    80003b6a:	fc26                	sd	s1,56(sp)
    80003b6c:	f84a                	sd	s2,48(sp)
    80003b6e:	f44e                	sd	s3,40(sp)
    80003b70:	f052                	sd	s4,32(sp)
    80003b72:	ec56                	sd	s5,24(sp)
    80003b74:	e85a                	sd	s6,16(sp)
    80003b76:	e45e                	sd	s7,8(sp)
    80003b78:	e062                	sd	s8,0(sp)
    80003b7a:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003b7c:	00954783          	lbu	a5,9(a0)
    80003b80:	10078663          	beqz	a5,80003c8c <filewrite+0x128>
    80003b84:	892a                	mv	s2,a0
    80003b86:	8b2e                	mv	s6,a1
    80003b88:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b8a:	411c                	lw	a5,0(a0)
    80003b8c:	4705                	li	a4,1
    80003b8e:	02e78263          	beq	a5,a4,80003bb2 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b92:	470d                	li	a4,3
    80003b94:	02e78663          	beq	a5,a4,80003bc0 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b98:	4709                	li	a4,2
    80003b9a:	0ee79163          	bne	a5,a4,80003c7c <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003b9e:	0ac05d63          	blez	a2,80003c58 <filewrite+0xf4>
    int i = 0;
    80003ba2:	4981                	li	s3,0
    80003ba4:	6b85                	lui	s7,0x1
    80003ba6:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003baa:	6c05                	lui	s8,0x1
    80003bac:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003bb0:	a861                	j	80003c48 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003bb2:	6908                	ld	a0,16(a0)
    80003bb4:	00000097          	auipc	ra,0x0
    80003bb8:	22e080e7          	jalr	558(ra) # 80003de2 <pipewrite>
    80003bbc:	8a2a                	mv	s4,a0
    80003bbe:	a045                	j	80003c5e <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003bc0:	02451783          	lh	a5,36(a0)
    80003bc4:	03079693          	slli	a3,a5,0x30
    80003bc8:	92c1                	srli	a3,a3,0x30
    80003bca:	4725                	li	a4,9
    80003bcc:	0cd76263          	bltu	a4,a3,80003c90 <filewrite+0x12c>
    80003bd0:	0792                	slli	a5,a5,0x4
    80003bd2:	00015717          	auipc	a4,0x15
    80003bd6:	da670713          	addi	a4,a4,-602 # 80018978 <devsw>
    80003bda:	97ba                	add	a5,a5,a4
    80003bdc:	679c                	ld	a5,8(a5)
    80003bde:	cbdd                	beqz	a5,80003c94 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003be0:	4505                	li	a0,1
    80003be2:	9782                	jalr	a5
    80003be4:	8a2a                	mv	s4,a0
    80003be6:	a8a5                	j	80003c5e <filewrite+0xfa>
    80003be8:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003bec:	00000097          	auipc	ra,0x0
    80003bf0:	8b4080e7          	jalr	-1868(ra) # 800034a0 <begin_op>
      ilock(f->ip);
    80003bf4:	01893503          	ld	a0,24(s2)
    80003bf8:	fffff097          	auipc	ra,0xfffff
    80003bfc:	edc080e7          	jalr	-292(ra) # 80002ad4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c00:	8756                	mv	a4,s5
    80003c02:	02092683          	lw	a3,32(s2)
    80003c06:	01698633          	add	a2,s3,s6
    80003c0a:	4585                	li	a1,1
    80003c0c:	01893503          	ld	a0,24(s2)
    80003c10:	fffff097          	auipc	ra,0xfffff
    80003c14:	270080e7          	jalr	624(ra) # 80002e80 <writei>
    80003c18:	84aa                	mv	s1,a0
    80003c1a:	00a05763          	blez	a0,80003c28 <filewrite+0xc4>
        f->off += r;
    80003c1e:	02092783          	lw	a5,32(s2)
    80003c22:	9fa9                	addw	a5,a5,a0
    80003c24:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003c28:	01893503          	ld	a0,24(s2)
    80003c2c:	fffff097          	auipc	ra,0xfffff
    80003c30:	f6a080e7          	jalr	-150(ra) # 80002b96 <iunlock>
      end_op();
    80003c34:	00000097          	auipc	ra,0x0
    80003c38:	8ea080e7          	jalr	-1814(ra) # 8000351e <end_op>

      if(r != n1){
    80003c3c:	009a9f63          	bne	s5,s1,80003c5a <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003c40:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003c44:	0149db63          	bge	s3,s4,80003c5a <filewrite+0xf6>
      int n1 = n - i;
    80003c48:	413a04bb          	subw	s1,s4,s3
    80003c4c:	0004879b          	sext.w	a5,s1
    80003c50:	f8fbdce3          	bge	s7,a5,80003be8 <filewrite+0x84>
    80003c54:	84e2                	mv	s1,s8
    80003c56:	bf49                	j	80003be8 <filewrite+0x84>
    int i = 0;
    80003c58:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003c5a:	013a1f63          	bne	s4,s3,80003c78 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003c5e:	8552                	mv	a0,s4
    80003c60:	60a6                	ld	ra,72(sp)
    80003c62:	6406                	ld	s0,64(sp)
    80003c64:	74e2                	ld	s1,56(sp)
    80003c66:	7942                	ld	s2,48(sp)
    80003c68:	79a2                	ld	s3,40(sp)
    80003c6a:	7a02                	ld	s4,32(sp)
    80003c6c:	6ae2                	ld	s5,24(sp)
    80003c6e:	6b42                	ld	s6,16(sp)
    80003c70:	6ba2                	ld	s7,8(sp)
    80003c72:	6c02                	ld	s8,0(sp)
    80003c74:	6161                	addi	sp,sp,80
    80003c76:	8082                	ret
    ret = (i == n ? n : -1);
    80003c78:	5a7d                	li	s4,-1
    80003c7a:	b7d5                	j	80003c5e <filewrite+0xfa>
    panic("filewrite");
    80003c7c:	00005517          	auipc	a0,0x5
    80003c80:	9bc50513          	addi	a0,a0,-1604 # 80008638 <syscalls+0x268>
    80003c84:	00002097          	auipc	ra,0x2
    80003c88:	f08080e7          	jalr	-248(ra) # 80005b8c <panic>
    return -1;
    80003c8c:	5a7d                	li	s4,-1
    80003c8e:	bfc1                	j	80003c5e <filewrite+0xfa>
      return -1;
    80003c90:	5a7d                	li	s4,-1
    80003c92:	b7f1                	j	80003c5e <filewrite+0xfa>
    80003c94:	5a7d                	li	s4,-1
    80003c96:	b7e1                	j	80003c5e <filewrite+0xfa>

0000000080003c98 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003c98:	7179                	addi	sp,sp,-48
    80003c9a:	f406                	sd	ra,40(sp)
    80003c9c:	f022                	sd	s0,32(sp)
    80003c9e:	ec26                	sd	s1,24(sp)
    80003ca0:	e84a                	sd	s2,16(sp)
    80003ca2:	e44e                	sd	s3,8(sp)
    80003ca4:	e052                	sd	s4,0(sp)
    80003ca6:	1800                	addi	s0,sp,48
    80003ca8:	84aa                	mv	s1,a0
    80003caa:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003cac:	0005b023          	sd	zero,0(a1)
    80003cb0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003cb4:	00000097          	auipc	ra,0x0
    80003cb8:	bf8080e7          	jalr	-1032(ra) # 800038ac <filealloc>
    80003cbc:	e088                	sd	a0,0(s1)
    80003cbe:	c551                	beqz	a0,80003d4a <pipealloc+0xb2>
    80003cc0:	00000097          	auipc	ra,0x0
    80003cc4:	bec080e7          	jalr	-1044(ra) # 800038ac <filealloc>
    80003cc8:	00aa3023          	sd	a0,0(s4)
    80003ccc:	c92d                	beqz	a0,80003d3e <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003cce:	ffffc097          	auipc	ra,0xffffc
    80003cd2:	44c080e7          	jalr	1100(ra) # 8000011a <kalloc>
    80003cd6:	892a                	mv	s2,a0
    80003cd8:	c125                	beqz	a0,80003d38 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003cda:	4985                	li	s3,1
    80003cdc:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003ce0:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003ce4:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003ce8:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003cec:	00005597          	auipc	a1,0x5
    80003cf0:	95c58593          	addi	a1,a1,-1700 # 80008648 <syscalls+0x278>
    80003cf4:	00002097          	auipc	ra,0x2
    80003cf8:	340080e7          	jalr	832(ra) # 80006034 <initlock>
  (*f0)->type = FD_PIPE;
    80003cfc:	609c                	ld	a5,0(s1)
    80003cfe:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d02:	609c                	ld	a5,0(s1)
    80003d04:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d08:	609c                	ld	a5,0(s1)
    80003d0a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d0e:	609c                	ld	a5,0(s1)
    80003d10:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d14:	000a3783          	ld	a5,0(s4)
    80003d18:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d1c:	000a3783          	ld	a5,0(s4)
    80003d20:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d24:	000a3783          	ld	a5,0(s4)
    80003d28:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003d2c:	000a3783          	ld	a5,0(s4)
    80003d30:	0127b823          	sd	s2,16(a5)
  return 0;
    80003d34:	4501                	li	a0,0
    80003d36:	a025                	j	80003d5e <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003d38:	6088                	ld	a0,0(s1)
    80003d3a:	e501                	bnez	a0,80003d42 <pipealloc+0xaa>
    80003d3c:	a039                	j	80003d4a <pipealloc+0xb2>
    80003d3e:	6088                	ld	a0,0(s1)
    80003d40:	c51d                	beqz	a0,80003d6e <pipealloc+0xd6>
    fileclose(*f0);
    80003d42:	00000097          	auipc	ra,0x0
    80003d46:	c26080e7          	jalr	-986(ra) # 80003968 <fileclose>
  if(*f1)
    80003d4a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003d4e:	557d                	li	a0,-1
  if(*f1)
    80003d50:	c799                	beqz	a5,80003d5e <pipealloc+0xc6>
    fileclose(*f1);
    80003d52:	853e                	mv	a0,a5
    80003d54:	00000097          	auipc	ra,0x0
    80003d58:	c14080e7          	jalr	-1004(ra) # 80003968 <fileclose>
  return -1;
    80003d5c:	557d                	li	a0,-1
}
    80003d5e:	70a2                	ld	ra,40(sp)
    80003d60:	7402                	ld	s0,32(sp)
    80003d62:	64e2                	ld	s1,24(sp)
    80003d64:	6942                	ld	s2,16(sp)
    80003d66:	69a2                	ld	s3,8(sp)
    80003d68:	6a02                	ld	s4,0(sp)
    80003d6a:	6145                	addi	sp,sp,48
    80003d6c:	8082                	ret
  return -1;
    80003d6e:	557d                	li	a0,-1
    80003d70:	b7fd                	j	80003d5e <pipealloc+0xc6>

0000000080003d72 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003d72:	1101                	addi	sp,sp,-32
    80003d74:	ec06                	sd	ra,24(sp)
    80003d76:	e822                	sd	s0,16(sp)
    80003d78:	e426                	sd	s1,8(sp)
    80003d7a:	e04a                	sd	s2,0(sp)
    80003d7c:	1000                	addi	s0,sp,32
    80003d7e:	84aa                	mv	s1,a0
    80003d80:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003d82:	00002097          	auipc	ra,0x2
    80003d86:	342080e7          	jalr	834(ra) # 800060c4 <acquire>
  if(writable){
    80003d8a:	02090d63          	beqz	s2,80003dc4 <pipeclose+0x52>
    pi->writeopen = 0;
    80003d8e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003d92:	21848513          	addi	a0,s1,536
    80003d96:	ffffd097          	auipc	ra,0xffffd
    80003d9a:	7ca080e7          	jalr	1994(ra) # 80001560 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003d9e:	2204b783          	ld	a5,544(s1)
    80003da2:	eb95                	bnez	a5,80003dd6 <pipeclose+0x64>
    release(&pi->lock);
    80003da4:	8526                	mv	a0,s1
    80003da6:	00002097          	auipc	ra,0x2
    80003daa:	3d2080e7          	jalr	978(ra) # 80006178 <release>
    kfree((char*)pi);
    80003dae:	8526                	mv	a0,s1
    80003db0:	ffffc097          	auipc	ra,0xffffc
    80003db4:	26c080e7          	jalr	620(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003db8:	60e2                	ld	ra,24(sp)
    80003dba:	6442                	ld	s0,16(sp)
    80003dbc:	64a2                	ld	s1,8(sp)
    80003dbe:	6902                	ld	s2,0(sp)
    80003dc0:	6105                	addi	sp,sp,32
    80003dc2:	8082                	ret
    pi->readopen = 0;
    80003dc4:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003dc8:	21c48513          	addi	a0,s1,540
    80003dcc:	ffffd097          	auipc	ra,0xffffd
    80003dd0:	794080e7          	jalr	1940(ra) # 80001560 <wakeup>
    80003dd4:	b7e9                	j	80003d9e <pipeclose+0x2c>
    release(&pi->lock);
    80003dd6:	8526                	mv	a0,s1
    80003dd8:	00002097          	auipc	ra,0x2
    80003ddc:	3a0080e7          	jalr	928(ra) # 80006178 <release>
}
    80003de0:	bfe1                	j	80003db8 <pipeclose+0x46>

0000000080003de2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003de2:	711d                	addi	sp,sp,-96
    80003de4:	ec86                	sd	ra,88(sp)
    80003de6:	e8a2                	sd	s0,80(sp)
    80003de8:	e4a6                	sd	s1,72(sp)
    80003dea:	e0ca                	sd	s2,64(sp)
    80003dec:	fc4e                	sd	s3,56(sp)
    80003dee:	f852                	sd	s4,48(sp)
    80003df0:	f456                	sd	s5,40(sp)
    80003df2:	f05a                	sd	s6,32(sp)
    80003df4:	ec5e                	sd	s7,24(sp)
    80003df6:	e862                	sd	s8,16(sp)
    80003df8:	1080                	addi	s0,sp,96
    80003dfa:	84aa                	mv	s1,a0
    80003dfc:	8aae                	mv	s5,a1
    80003dfe:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e00:	ffffd097          	auipc	ra,0xffffd
    80003e04:	054080e7          	jalr	84(ra) # 80000e54 <myproc>
    80003e08:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e0a:	8526                	mv	a0,s1
    80003e0c:	00002097          	auipc	ra,0x2
    80003e10:	2b8080e7          	jalr	696(ra) # 800060c4 <acquire>
  while(i < n){
    80003e14:	0b405663          	blez	s4,80003ec0 <pipewrite+0xde>
  int i = 0;
    80003e18:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e1a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e1c:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e20:	21c48b93          	addi	s7,s1,540
    80003e24:	a089                	j	80003e66 <pipewrite+0x84>
      release(&pi->lock);
    80003e26:	8526                	mv	a0,s1
    80003e28:	00002097          	auipc	ra,0x2
    80003e2c:	350080e7          	jalr	848(ra) # 80006178 <release>
      return -1;
    80003e30:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003e32:	854a                	mv	a0,s2
    80003e34:	60e6                	ld	ra,88(sp)
    80003e36:	6446                	ld	s0,80(sp)
    80003e38:	64a6                	ld	s1,72(sp)
    80003e3a:	6906                	ld	s2,64(sp)
    80003e3c:	79e2                	ld	s3,56(sp)
    80003e3e:	7a42                	ld	s4,48(sp)
    80003e40:	7aa2                	ld	s5,40(sp)
    80003e42:	7b02                	ld	s6,32(sp)
    80003e44:	6be2                	ld	s7,24(sp)
    80003e46:	6c42                	ld	s8,16(sp)
    80003e48:	6125                	addi	sp,sp,96
    80003e4a:	8082                	ret
      wakeup(&pi->nread);
    80003e4c:	8562                	mv	a0,s8
    80003e4e:	ffffd097          	auipc	ra,0xffffd
    80003e52:	712080e7          	jalr	1810(ra) # 80001560 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003e56:	85a6                	mv	a1,s1
    80003e58:	855e                	mv	a0,s7
    80003e5a:	ffffd097          	auipc	ra,0xffffd
    80003e5e:	6a2080e7          	jalr	1698(ra) # 800014fc <sleep>
  while(i < n){
    80003e62:	07495063          	bge	s2,s4,80003ec2 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003e66:	2204a783          	lw	a5,544(s1)
    80003e6a:	dfd5                	beqz	a5,80003e26 <pipewrite+0x44>
    80003e6c:	854e                	mv	a0,s3
    80003e6e:	ffffe097          	auipc	ra,0xffffe
    80003e72:	936080e7          	jalr	-1738(ra) # 800017a4 <killed>
    80003e76:	f945                	bnez	a0,80003e26 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003e78:	2184a783          	lw	a5,536(s1)
    80003e7c:	21c4a703          	lw	a4,540(s1)
    80003e80:	2007879b          	addiw	a5,a5,512
    80003e84:	fcf704e3          	beq	a4,a5,80003e4c <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e88:	4685                	li	a3,1
    80003e8a:	01590633          	add	a2,s2,s5
    80003e8e:	faf40593          	addi	a1,s0,-81
    80003e92:	0509b503          	ld	a0,80(s3)
    80003e96:	ffffd097          	auipc	ra,0xffffd
    80003e9a:	d0a080e7          	jalr	-758(ra) # 80000ba0 <copyin>
    80003e9e:	03650263          	beq	a0,s6,80003ec2 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003ea2:	21c4a783          	lw	a5,540(s1)
    80003ea6:	0017871b          	addiw	a4,a5,1
    80003eaa:	20e4ae23          	sw	a4,540(s1)
    80003eae:	1ff7f793          	andi	a5,a5,511
    80003eb2:	97a6                	add	a5,a5,s1
    80003eb4:	faf44703          	lbu	a4,-81(s0)
    80003eb8:	00e78c23          	sb	a4,24(a5)
      i++;
    80003ebc:	2905                	addiw	s2,s2,1
    80003ebe:	b755                	j	80003e62 <pipewrite+0x80>
  int i = 0;
    80003ec0:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003ec2:	21848513          	addi	a0,s1,536
    80003ec6:	ffffd097          	auipc	ra,0xffffd
    80003eca:	69a080e7          	jalr	1690(ra) # 80001560 <wakeup>
  release(&pi->lock);
    80003ece:	8526                	mv	a0,s1
    80003ed0:	00002097          	auipc	ra,0x2
    80003ed4:	2a8080e7          	jalr	680(ra) # 80006178 <release>
  return i;
    80003ed8:	bfa9                	j	80003e32 <pipewrite+0x50>

0000000080003eda <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003eda:	715d                	addi	sp,sp,-80
    80003edc:	e486                	sd	ra,72(sp)
    80003ede:	e0a2                	sd	s0,64(sp)
    80003ee0:	fc26                	sd	s1,56(sp)
    80003ee2:	f84a                	sd	s2,48(sp)
    80003ee4:	f44e                	sd	s3,40(sp)
    80003ee6:	f052                	sd	s4,32(sp)
    80003ee8:	ec56                	sd	s5,24(sp)
    80003eea:	e85a                	sd	s6,16(sp)
    80003eec:	0880                	addi	s0,sp,80
    80003eee:	84aa                	mv	s1,a0
    80003ef0:	892e                	mv	s2,a1
    80003ef2:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003ef4:	ffffd097          	auipc	ra,0xffffd
    80003ef8:	f60080e7          	jalr	-160(ra) # 80000e54 <myproc>
    80003efc:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003efe:	8526                	mv	a0,s1
    80003f00:	00002097          	auipc	ra,0x2
    80003f04:	1c4080e7          	jalr	452(ra) # 800060c4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f08:	2184a703          	lw	a4,536(s1)
    80003f0c:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f10:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f14:	02f71763          	bne	a4,a5,80003f42 <piperead+0x68>
    80003f18:	2244a783          	lw	a5,548(s1)
    80003f1c:	c39d                	beqz	a5,80003f42 <piperead+0x68>
    if(killed(pr)){
    80003f1e:	8552                	mv	a0,s4
    80003f20:	ffffe097          	auipc	ra,0xffffe
    80003f24:	884080e7          	jalr	-1916(ra) # 800017a4 <killed>
    80003f28:	e949                	bnez	a0,80003fba <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f2a:	85a6                	mv	a1,s1
    80003f2c:	854e                	mv	a0,s3
    80003f2e:	ffffd097          	auipc	ra,0xffffd
    80003f32:	5ce080e7          	jalr	1486(ra) # 800014fc <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f36:	2184a703          	lw	a4,536(s1)
    80003f3a:	21c4a783          	lw	a5,540(s1)
    80003f3e:	fcf70de3          	beq	a4,a5,80003f18 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f42:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f44:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f46:	05505463          	blez	s5,80003f8e <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80003f4a:	2184a783          	lw	a5,536(s1)
    80003f4e:	21c4a703          	lw	a4,540(s1)
    80003f52:	02f70e63          	beq	a4,a5,80003f8e <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003f56:	0017871b          	addiw	a4,a5,1
    80003f5a:	20e4ac23          	sw	a4,536(s1)
    80003f5e:	1ff7f793          	andi	a5,a5,511
    80003f62:	97a6                	add	a5,a5,s1
    80003f64:	0187c783          	lbu	a5,24(a5)
    80003f68:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f6c:	4685                	li	a3,1
    80003f6e:	fbf40613          	addi	a2,s0,-65
    80003f72:	85ca                	mv	a1,s2
    80003f74:	050a3503          	ld	a0,80(s4)
    80003f78:	ffffd097          	auipc	ra,0xffffd
    80003f7c:	b9c080e7          	jalr	-1124(ra) # 80000b14 <copyout>
    80003f80:	01650763          	beq	a0,s6,80003f8e <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f84:	2985                	addiw	s3,s3,1
    80003f86:	0905                	addi	s2,s2,1
    80003f88:	fd3a91e3          	bne	s5,s3,80003f4a <piperead+0x70>
    80003f8c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003f8e:	21c48513          	addi	a0,s1,540
    80003f92:	ffffd097          	auipc	ra,0xffffd
    80003f96:	5ce080e7          	jalr	1486(ra) # 80001560 <wakeup>
  release(&pi->lock);
    80003f9a:	8526                	mv	a0,s1
    80003f9c:	00002097          	auipc	ra,0x2
    80003fa0:	1dc080e7          	jalr	476(ra) # 80006178 <release>
  return i;
}
    80003fa4:	854e                	mv	a0,s3
    80003fa6:	60a6                	ld	ra,72(sp)
    80003fa8:	6406                	ld	s0,64(sp)
    80003faa:	74e2                	ld	s1,56(sp)
    80003fac:	7942                	ld	s2,48(sp)
    80003fae:	79a2                	ld	s3,40(sp)
    80003fb0:	7a02                	ld	s4,32(sp)
    80003fb2:	6ae2                	ld	s5,24(sp)
    80003fb4:	6b42                	ld	s6,16(sp)
    80003fb6:	6161                	addi	sp,sp,80
    80003fb8:	8082                	ret
      release(&pi->lock);
    80003fba:	8526                	mv	a0,s1
    80003fbc:	00002097          	auipc	ra,0x2
    80003fc0:	1bc080e7          	jalr	444(ra) # 80006178 <release>
      return -1;
    80003fc4:	59fd                	li	s3,-1
    80003fc6:	bff9                	j	80003fa4 <piperead+0xca>

0000000080003fc8 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003fc8:	1141                	addi	sp,sp,-16
    80003fca:	e422                	sd	s0,8(sp)
    80003fcc:	0800                	addi	s0,sp,16
    80003fce:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003fd0:	8905                	andi	a0,a0,1
    80003fd2:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003fd4:	8b89                	andi	a5,a5,2
    80003fd6:	c399                	beqz	a5,80003fdc <flags2perm+0x14>
      perm |= PTE_W;
    80003fd8:	00456513          	ori	a0,a0,4
    return perm;
}
    80003fdc:	6422                	ld	s0,8(sp)
    80003fde:	0141                	addi	sp,sp,16
    80003fe0:	8082                	ret

0000000080003fe2 <exec>:

int
exec(char *path, char **argv)
{
    80003fe2:	de010113          	addi	sp,sp,-544
    80003fe6:	20113c23          	sd	ra,536(sp)
    80003fea:	20813823          	sd	s0,528(sp)
    80003fee:	20913423          	sd	s1,520(sp)
    80003ff2:	21213023          	sd	s2,512(sp)
    80003ff6:	ffce                	sd	s3,504(sp)
    80003ff8:	fbd2                	sd	s4,496(sp)
    80003ffa:	f7d6                	sd	s5,488(sp)
    80003ffc:	f3da                	sd	s6,480(sp)
    80003ffe:	efde                	sd	s7,472(sp)
    80004000:	ebe2                	sd	s8,464(sp)
    80004002:	e7e6                	sd	s9,456(sp)
    80004004:	e3ea                	sd	s10,448(sp)
    80004006:	ff6e                	sd	s11,440(sp)
    80004008:	1400                	addi	s0,sp,544
    8000400a:	892a                	mv	s2,a0
    8000400c:	dea43423          	sd	a0,-536(s0)
    80004010:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004014:	ffffd097          	auipc	ra,0xffffd
    80004018:	e40080e7          	jalr	-448(ra) # 80000e54 <myproc>
    8000401c:	84aa                	mv	s1,a0

  begin_op();
    8000401e:	fffff097          	auipc	ra,0xfffff
    80004022:	482080e7          	jalr	1154(ra) # 800034a0 <begin_op>

  if((ip = namei(path)) == 0){
    80004026:	854a                	mv	a0,s2
    80004028:	fffff097          	auipc	ra,0xfffff
    8000402c:	258080e7          	jalr	600(ra) # 80003280 <namei>
    80004030:	c93d                	beqz	a0,800040a6 <exec+0xc4>
    80004032:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004034:	fffff097          	auipc	ra,0xfffff
    80004038:	aa0080e7          	jalr	-1376(ra) # 80002ad4 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000403c:	04000713          	li	a4,64
    80004040:	4681                	li	a3,0
    80004042:	e5040613          	addi	a2,s0,-432
    80004046:	4581                	li	a1,0
    80004048:	8556                	mv	a0,s5
    8000404a:	fffff097          	auipc	ra,0xfffff
    8000404e:	d3e080e7          	jalr	-706(ra) # 80002d88 <readi>
    80004052:	04000793          	li	a5,64
    80004056:	00f51a63          	bne	a0,a5,8000406a <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000405a:	e5042703          	lw	a4,-432(s0)
    8000405e:	464c47b7          	lui	a5,0x464c4
    80004062:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004066:	04f70663          	beq	a4,a5,800040b2 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000406a:	8556                	mv	a0,s5
    8000406c:	fffff097          	auipc	ra,0xfffff
    80004070:	cca080e7          	jalr	-822(ra) # 80002d36 <iunlockput>
    end_op();
    80004074:	fffff097          	auipc	ra,0xfffff
    80004078:	4aa080e7          	jalr	1194(ra) # 8000351e <end_op>
  }
  return -1;
    8000407c:	557d                	li	a0,-1
}
    8000407e:	21813083          	ld	ra,536(sp)
    80004082:	21013403          	ld	s0,528(sp)
    80004086:	20813483          	ld	s1,520(sp)
    8000408a:	20013903          	ld	s2,512(sp)
    8000408e:	79fe                	ld	s3,504(sp)
    80004090:	7a5e                	ld	s4,496(sp)
    80004092:	7abe                	ld	s5,488(sp)
    80004094:	7b1e                	ld	s6,480(sp)
    80004096:	6bfe                	ld	s7,472(sp)
    80004098:	6c5e                	ld	s8,464(sp)
    8000409a:	6cbe                	ld	s9,456(sp)
    8000409c:	6d1e                	ld	s10,448(sp)
    8000409e:	7dfa                	ld	s11,440(sp)
    800040a0:	22010113          	addi	sp,sp,544
    800040a4:	8082                	ret
    end_op();
    800040a6:	fffff097          	auipc	ra,0xfffff
    800040aa:	478080e7          	jalr	1144(ra) # 8000351e <end_op>
    return -1;
    800040ae:	557d                	li	a0,-1
    800040b0:	b7f9                	j	8000407e <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800040b2:	8526                	mv	a0,s1
    800040b4:	ffffd097          	auipc	ra,0xffffd
    800040b8:	e64080e7          	jalr	-412(ra) # 80000f18 <proc_pagetable>
    800040bc:	8b2a                	mv	s6,a0
    800040be:	d555                	beqz	a0,8000406a <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040c0:	e7042783          	lw	a5,-400(s0)
    800040c4:	e8845703          	lhu	a4,-376(s0)
    800040c8:	c735                	beqz	a4,80004134 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800040ca:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040cc:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    800040d0:	6a05                	lui	s4,0x1
    800040d2:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800040d6:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800040da:	6d85                	lui	s11,0x1
    800040dc:	7d7d                	lui	s10,0xfffff
    800040de:	ac3d                	j	8000431c <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800040e0:	00004517          	auipc	a0,0x4
    800040e4:	57050513          	addi	a0,a0,1392 # 80008650 <syscalls+0x280>
    800040e8:	00002097          	auipc	ra,0x2
    800040ec:	aa4080e7          	jalr	-1372(ra) # 80005b8c <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800040f0:	874a                	mv	a4,s2
    800040f2:	009c86bb          	addw	a3,s9,s1
    800040f6:	4581                	li	a1,0
    800040f8:	8556                	mv	a0,s5
    800040fa:	fffff097          	auipc	ra,0xfffff
    800040fe:	c8e080e7          	jalr	-882(ra) # 80002d88 <readi>
    80004102:	2501                	sext.w	a0,a0
    80004104:	1aa91963          	bne	s2,a0,800042b6 <exec+0x2d4>
  for(i = 0; i < sz; i += PGSIZE){
    80004108:	009d84bb          	addw	s1,s11,s1
    8000410c:	013d09bb          	addw	s3,s10,s3
    80004110:	1f74f663          	bgeu	s1,s7,800042fc <exec+0x31a>
    pa = walkaddr(pagetable, va + i);
    80004114:	02049593          	slli	a1,s1,0x20
    80004118:	9181                	srli	a1,a1,0x20
    8000411a:	95e2                	add	a1,a1,s8
    8000411c:	855a                	mv	a0,s6
    8000411e:	ffffc097          	auipc	ra,0xffffc
    80004122:	3e6080e7          	jalr	998(ra) # 80000504 <walkaddr>
    80004126:	862a                	mv	a2,a0
    if(pa == 0)
    80004128:	dd45                	beqz	a0,800040e0 <exec+0xfe>
      n = PGSIZE;
    8000412a:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000412c:	fd49f2e3          	bgeu	s3,s4,800040f0 <exec+0x10e>
      n = sz - i;
    80004130:	894e                	mv	s2,s3
    80004132:	bf7d                	j	800040f0 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004134:	4901                	li	s2,0
  iunlockput(ip);
    80004136:	8556                	mv	a0,s5
    80004138:	fffff097          	auipc	ra,0xfffff
    8000413c:	bfe080e7          	jalr	-1026(ra) # 80002d36 <iunlockput>
  end_op();
    80004140:	fffff097          	auipc	ra,0xfffff
    80004144:	3de080e7          	jalr	990(ra) # 8000351e <end_op>
  p = myproc();
    80004148:	ffffd097          	auipc	ra,0xffffd
    8000414c:	d0c080e7          	jalr	-756(ra) # 80000e54 <myproc>
    80004150:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004152:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004156:	6785                	lui	a5,0x1
    80004158:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000415a:	97ca                	add	a5,a5,s2
    8000415c:	777d                	lui	a4,0xfffff
    8000415e:	8ff9                	and	a5,a5,a4
    80004160:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004164:	4691                	li	a3,4
    80004166:	6609                	lui	a2,0x2
    80004168:	963e                	add	a2,a2,a5
    8000416a:	85be                	mv	a1,a5
    8000416c:	855a                	mv	a0,s6
    8000416e:	ffffc097          	auipc	ra,0xffffc
    80004172:	74a080e7          	jalr	1866(ra) # 800008b8 <uvmalloc>
    80004176:	8c2a                	mv	s8,a0
  ip = 0;
    80004178:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000417a:	12050e63          	beqz	a0,800042b6 <exec+0x2d4>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000417e:	75f9                	lui	a1,0xffffe
    80004180:	95aa                	add	a1,a1,a0
    80004182:	855a                	mv	a0,s6
    80004184:	ffffd097          	auipc	ra,0xffffd
    80004188:	95e080e7          	jalr	-1698(ra) # 80000ae2 <uvmclear>
  stackbase = sp - PGSIZE;
    8000418c:	7afd                	lui	s5,0xfffff
    8000418e:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004190:	df043783          	ld	a5,-528(s0)
    80004194:	6388                	ld	a0,0(a5)
    80004196:	c925                	beqz	a0,80004206 <exec+0x224>
    80004198:	e9040993          	addi	s3,s0,-368
    8000419c:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800041a0:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800041a2:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800041a4:	ffffc097          	auipc	ra,0xffffc
    800041a8:	152080e7          	jalr	338(ra) # 800002f6 <strlen>
    800041ac:	0015079b          	addiw	a5,a0,1
    800041b0:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800041b4:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800041b8:	13596663          	bltu	s2,s5,800042e4 <exec+0x302>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800041bc:	df043d83          	ld	s11,-528(s0)
    800041c0:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800041c4:	8552                	mv	a0,s4
    800041c6:	ffffc097          	auipc	ra,0xffffc
    800041ca:	130080e7          	jalr	304(ra) # 800002f6 <strlen>
    800041ce:	0015069b          	addiw	a3,a0,1
    800041d2:	8652                	mv	a2,s4
    800041d4:	85ca                	mv	a1,s2
    800041d6:	855a                	mv	a0,s6
    800041d8:	ffffd097          	auipc	ra,0xffffd
    800041dc:	93c080e7          	jalr	-1732(ra) # 80000b14 <copyout>
    800041e0:	10054663          	bltz	a0,800042ec <exec+0x30a>
    ustack[argc] = sp;
    800041e4:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800041e8:	0485                	addi	s1,s1,1
    800041ea:	008d8793          	addi	a5,s11,8
    800041ee:	def43823          	sd	a5,-528(s0)
    800041f2:	008db503          	ld	a0,8(s11)
    800041f6:	c911                	beqz	a0,8000420a <exec+0x228>
    if(argc >= MAXARG)
    800041f8:	09a1                	addi	s3,s3,8
    800041fa:	fb3c95e3          	bne	s9,s3,800041a4 <exec+0x1c2>
  sz = sz1;
    800041fe:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004202:	4a81                	li	s5,0
    80004204:	a84d                	j	800042b6 <exec+0x2d4>
  sp = sz;
    80004206:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004208:	4481                	li	s1,0
  ustack[argc] = 0;
    8000420a:	00349793          	slli	a5,s1,0x3
    8000420e:	f9078793          	addi	a5,a5,-112
    80004212:	97a2                	add	a5,a5,s0
    80004214:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004218:	00148693          	addi	a3,s1,1
    8000421c:	068e                	slli	a3,a3,0x3
    8000421e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004222:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004226:	01597663          	bgeu	s2,s5,80004232 <exec+0x250>
  sz = sz1;
    8000422a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000422e:	4a81                	li	s5,0
    80004230:	a059                	j	800042b6 <exec+0x2d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004232:	e9040613          	addi	a2,s0,-368
    80004236:	85ca                	mv	a1,s2
    80004238:	855a                	mv	a0,s6
    8000423a:	ffffd097          	auipc	ra,0xffffd
    8000423e:	8da080e7          	jalr	-1830(ra) # 80000b14 <copyout>
    80004242:	0a054963          	bltz	a0,800042f4 <exec+0x312>
  p->trapframe->a1 = sp;
    80004246:	058bb783          	ld	a5,88(s7)
    8000424a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000424e:	de843783          	ld	a5,-536(s0)
    80004252:	0007c703          	lbu	a4,0(a5)
    80004256:	cf11                	beqz	a4,80004272 <exec+0x290>
    80004258:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000425a:	02f00693          	li	a3,47
    8000425e:	a039                	j	8000426c <exec+0x28a>
      last = s+1;
    80004260:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004264:	0785                	addi	a5,a5,1
    80004266:	fff7c703          	lbu	a4,-1(a5)
    8000426a:	c701                	beqz	a4,80004272 <exec+0x290>
    if(*s == '/')
    8000426c:	fed71ce3          	bne	a4,a3,80004264 <exec+0x282>
    80004270:	bfc5                	j	80004260 <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    80004272:	4641                	li	a2,16
    80004274:	de843583          	ld	a1,-536(s0)
    80004278:	158b8513          	addi	a0,s7,344
    8000427c:	ffffc097          	auipc	ra,0xffffc
    80004280:	048080e7          	jalr	72(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    80004284:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004288:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    8000428c:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004290:	058bb783          	ld	a5,88(s7)
    80004294:	e6843703          	ld	a4,-408(s0)
    80004298:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000429a:	058bb783          	ld	a5,88(s7)
    8000429e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800042a2:	85ea                	mv	a1,s10
    800042a4:	ffffd097          	auipc	ra,0xffffd
    800042a8:	d10080e7          	jalr	-752(ra) # 80000fb4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800042ac:	0004851b          	sext.w	a0,s1
    800042b0:	b3f9                	j	8000407e <exec+0x9c>
    800042b2:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    800042b6:	df843583          	ld	a1,-520(s0)
    800042ba:	855a                	mv	a0,s6
    800042bc:	ffffd097          	auipc	ra,0xffffd
    800042c0:	cf8080e7          	jalr	-776(ra) # 80000fb4 <proc_freepagetable>
  if(ip){
    800042c4:	da0a93e3          	bnez	s5,8000406a <exec+0x88>
  return -1;
    800042c8:	557d                	li	a0,-1
    800042ca:	bb55                	j	8000407e <exec+0x9c>
    800042cc:	df243c23          	sd	s2,-520(s0)
    800042d0:	b7dd                	j	800042b6 <exec+0x2d4>
    800042d2:	df243c23          	sd	s2,-520(s0)
    800042d6:	b7c5                	j	800042b6 <exec+0x2d4>
    800042d8:	df243c23          	sd	s2,-520(s0)
    800042dc:	bfe9                	j	800042b6 <exec+0x2d4>
    800042de:	df243c23          	sd	s2,-520(s0)
    800042e2:	bfd1                	j	800042b6 <exec+0x2d4>
  sz = sz1;
    800042e4:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042e8:	4a81                	li	s5,0
    800042ea:	b7f1                	j	800042b6 <exec+0x2d4>
  sz = sz1;
    800042ec:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042f0:	4a81                	li	s5,0
    800042f2:	b7d1                	j	800042b6 <exec+0x2d4>
  sz = sz1;
    800042f4:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042f8:	4a81                	li	s5,0
    800042fa:	bf75                	j	800042b6 <exec+0x2d4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800042fc:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004300:	e0843783          	ld	a5,-504(s0)
    80004304:	0017869b          	addiw	a3,a5,1
    80004308:	e0d43423          	sd	a3,-504(s0)
    8000430c:	e0043783          	ld	a5,-512(s0)
    80004310:	0387879b          	addiw	a5,a5,56
    80004314:	e8845703          	lhu	a4,-376(s0)
    80004318:	e0e6dfe3          	bge	a3,a4,80004136 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000431c:	2781                	sext.w	a5,a5
    8000431e:	e0f43023          	sd	a5,-512(s0)
    80004322:	03800713          	li	a4,56
    80004326:	86be                	mv	a3,a5
    80004328:	e1840613          	addi	a2,s0,-488
    8000432c:	4581                	li	a1,0
    8000432e:	8556                	mv	a0,s5
    80004330:	fffff097          	auipc	ra,0xfffff
    80004334:	a58080e7          	jalr	-1448(ra) # 80002d88 <readi>
    80004338:	03800793          	li	a5,56
    8000433c:	f6f51be3          	bne	a0,a5,800042b2 <exec+0x2d0>
    if(ph.type != ELF_PROG_LOAD)
    80004340:	e1842783          	lw	a5,-488(s0)
    80004344:	4705                	li	a4,1
    80004346:	fae79de3          	bne	a5,a4,80004300 <exec+0x31e>
    if(ph.memsz < ph.filesz)
    8000434a:	e4043483          	ld	s1,-448(s0)
    8000434e:	e3843783          	ld	a5,-456(s0)
    80004352:	f6f4ede3          	bltu	s1,a5,800042cc <exec+0x2ea>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004356:	e2843783          	ld	a5,-472(s0)
    8000435a:	94be                	add	s1,s1,a5
    8000435c:	f6f4ebe3          	bltu	s1,a5,800042d2 <exec+0x2f0>
    if(ph.vaddr % PGSIZE != 0)
    80004360:	de043703          	ld	a4,-544(s0)
    80004364:	8ff9                	and	a5,a5,a4
    80004366:	fbad                	bnez	a5,800042d8 <exec+0x2f6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004368:	e1c42503          	lw	a0,-484(s0)
    8000436c:	00000097          	auipc	ra,0x0
    80004370:	c5c080e7          	jalr	-932(ra) # 80003fc8 <flags2perm>
    80004374:	86aa                	mv	a3,a0
    80004376:	8626                	mv	a2,s1
    80004378:	85ca                	mv	a1,s2
    8000437a:	855a                	mv	a0,s6
    8000437c:	ffffc097          	auipc	ra,0xffffc
    80004380:	53c080e7          	jalr	1340(ra) # 800008b8 <uvmalloc>
    80004384:	dea43c23          	sd	a0,-520(s0)
    80004388:	d939                	beqz	a0,800042de <exec+0x2fc>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000438a:	e2843c03          	ld	s8,-472(s0)
    8000438e:	e2042c83          	lw	s9,-480(s0)
    80004392:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004396:	f60b83e3          	beqz	s7,800042fc <exec+0x31a>
    8000439a:	89de                	mv	s3,s7
    8000439c:	4481                	li	s1,0
    8000439e:	bb9d                	j	80004114 <exec+0x132>

00000000800043a0 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800043a0:	7179                	addi	sp,sp,-48
    800043a2:	f406                	sd	ra,40(sp)
    800043a4:	f022                	sd	s0,32(sp)
    800043a6:	ec26                	sd	s1,24(sp)
    800043a8:	e84a                	sd	s2,16(sp)
    800043aa:	1800                	addi	s0,sp,48
    800043ac:	892e                	mv	s2,a1
    800043ae:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800043b0:	fdc40593          	addi	a1,s0,-36
    800043b4:	ffffe097          	auipc	ra,0xffffe
    800043b8:	bb6080e7          	jalr	-1098(ra) # 80001f6a <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800043bc:	fdc42703          	lw	a4,-36(s0)
    800043c0:	47bd                	li	a5,15
    800043c2:	02e7eb63          	bltu	a5,a4,800043f8 <argfd+0x58>
    800043c6:	ffffd097          	auipc	ra,0xffffd
    800043ca:	a8e080e7          	jalr	-1394(ra) # 80000e54 <myproc>
    800043ce:	fdc42703          	lw	a4,-36(s0)
    800043d2:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffdd2ca>
    800043d6:	078e                	slli	a5,a5,0x3
    800043d8:	953e                	add	a0,a0,a5
    800043da:	611c                	ld	a5,0(a0)
    800043dc:	c385                	beqz	a5,800043fc <argfd+0x5c>
    return -1;
  if(pfd)
    800043de:	00090463          	beqz	s2,800043e6 <argfd+0x46>
    *pfd = fd;
    800043e2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800043e6:	4501                	li	a0,0
  if(pf)
    800043e8:	c091                	beqz	s1,800043ec <argfd+0x4c>
    *pf = f;
    800043ea:	e09c                	sd	a5,0(s1)
}
    800043ec:	70a2                	ld	ra,40(sp)
    800043ee:	7402                	ld	s0,32(sp)
    800043f0:	64e2                	ld	s1,24(sp)
    800043f2:	6942                	ld	s2,16(sp)
    800043f4:	6145                	addi	sp,sp,48
    800043f6:	8082                	ret
    return -1;
    800043f8:	557d                	li	a0,-1
    800043fa:	bfcd                	j	800043ec <argfd+0x4c>
    800043fc:	557d                	li	a0,-1
    800043fe:	b7fd                	j	800043ec <argfd+0x4c>

0000000080004400 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004400:	1101                	addi	sp,sp,-32
    80004402:	ec06                	sd	ra,24(sp)
    80004404:	e822                	sd	s0,16(sp)
    80004406:	e426                	sd	s1,8(sp)
    80004408:	1000                	addi	s0,sp,32
    8000440a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000440c:	ffffd097          	auipc	ra,0xffffd
    80004410:	a48080e7          	jalr	-1464(ra) # 80000e54 <myproc>
    80004414:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004416:	0d050793          	addi	a5,a0,208
    8000441a:	4501                	li	a0,0
    8000441c:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000441e:	6398                	ld	a4,0(a5)
    80004420:	cb19                	beqz	a4,80004436 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004422:	2505                	addiw	a0,a0,1
    80004424:	07a1                	addi	a5,a5,8
    80004426:	fed51ce3          	bne	a0,a3,8000441e <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000442a:	557d                	li	a0,-1
}
    8000442c:	60e2                	ld	ra,24(sp)
    8000442e:	6442                	ld	s0,16(sp)
    80004430:	64a2                	ld	s1,8(sp)
    80004432:	6105                	addi	sp,sp,32
    80004434:	8082                	ret
      p->ofile[fd] = f;
    80004436:	01a50793          	addi	a5,a0,26
    8000443a:	078e                	slli	a5,a5,0x3
    8000443c:	963e                	add	a2,a2,a5
    8000443e:	e204                	sd	s1,0(a2)
      return fd;
    80004440:	b7f5                	j	8000442c <fdalloc+0x2c>

0000000080004442 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004442:	715d                	addi	sp,sp,-80
    80004444:	e486                	sd	ra,72(sp)
    80004446:	e0a2                	sd	s0,64(sp)
    80004448:	fc26                	sd	s1,56(sp)
    8000444a:	f84a                	sd	s2,48(sp)
    8000444c:	f44e                	sd	s3,40(sp)
    8000444e:	f052                	sd	s4,32(sp)
    80004450:	ec56                	sd	s5,24(sp)
    80004452:	e85a                	sd	s6,16(sp)
    80004454:	0880                	addi	s0,sp,80
    80004456:	8b2e                	mv	s6,a1
    80004458:	89b2                	mv	s3,a2
    8000445a:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000445c:	fb040593          	addi	a1,s0,-80
    80004460:	fffff097          	auipc	ra,0xfffff
    80004464:	e3e080e7          	jalr	-450(ra) # 8000329e <nameiparent>
    80004468:	84aa                	mv	s1,a0
    8000446a:	14050f63          	beqz	a0,800045c8 <create+0x186>
    return 0;

  ilock(dp);
    8000446e:	ffffe097          	auipc	ra,0xffffe
    80004472:	666080e7          	jalr	1638(ra) # 80002ad4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004476:	4601                	li	a2,0
    80004478:	fb040593          	addi	a1,s0,-80
    8000447c:	8526                	mv	a0,s1
    8000447e:	fffff097          	auipc	ra,0xfffff
    80004482:	b3a080e7          	jalr	-1222(ra) # 80002fb8 <dirlookup>
    80004486:	8aaa                	mv	s5,a0
    80004488:	c931                	beqz	a0,800044dc <create+0x9a>
    iunlockput(dp);
    8000448a:	8526                	mv	a0,s1
    8000448c:	fffff097          	auipc	ra,0xfffff
    80004490:	8aa080e7          	jalr	-1878(ra) # 80002d36 <iunlockput>
    ilock(ip);
    80004494:	8556                	mv	a0,s5
    80004496:	ffffe097          	auipc	ra,0xffffe
    8000449a:	63e080e7          	jalr	1598(ra) # 80002ad4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000449e:	000b059b          	sext.w	a1,s6
    800044a2:	4789                	li	a5,2
    800044a4:	02f59563          	bne	a1,a5,800044ce <create+0x8c>
    800044a8:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdd2f4>
    800044ac:	37f9                	addiw	a5,a5,-2
    800044ae:	17c2                	slli	a5,a5,0x30
    800044b0:	93c1                	srli	a5,a5,0x30
    800044b2:	4705                	li	a4,1
    800044b4:	00f76d63          	bltu	a4,a5,800044ce <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800044b8:	8556                	mv	a0,s5
    800044ba:	60a6                	ld	ra,72(sp)
    800044bc:	6406                	ld	s0,64(sp)
    800044be:	74e2                	ld	s1,56(sp)
    800044c0:	7942                	ld	s2,48(sp)
    800044c2:	79a2                	ld	s3,40(sp)
    800044c4:	7a02                	ld	s4,32(sp)
    800044c6:	6ae2                	ld	s5,24(sp)
    800044c8:	6b42                	ld	s6,16(sp)
    800044ca:	6161                	addi	sp,sp,80
    800044cc:	8082                	ret
    iunlockput(ip);
    800044ce:	8556                	mv	a0,s5
    800044d0:	fffff097          	auipc	ra,0xfffff
    800044d4:	866080e7          	jalr	-1946(ra) # 80002d36 <iunlockput>
    return 0;
    800044d8:	4a81                	li	s5,0
    800044da:	bff9                	j	800044b8 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800044dc:	85da                	mv	a1,s6
    800044de:	4088                	lw	a0,0(s1)
    800044e0:	ffffe097          	auipc	ra,0xffffe
    800044e4:	456080e7          	jalr	1110(ra) # 80002936 <ialloc>
    800044e8:	8a2a                	mv	s4,a0
    800044ea:	c539                	beqz	a0,80004538 <create+0xf6>
  ilock(ip);
    800044ec:	ffffe097          	auipc	ra,0xffffe
    800044f0:	5e8080e7          	jalr	1512(ra) # 80002ad4 <ilock>
  ip->major = major;
    800044f4:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800044f8:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800044fc:	4905                	li	s2,1
    800044fe:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004502:	8552                	mv	a0,s4
    80004504:	ffffe097          	auipc	ra,0xffffe
    80004508:	504080e7          	jalr	1284(ra) # 80002a08 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000450c:	000b059b          	sext.w	a1,s6
    80004510:	03258b63          	beq	a1,s2,80004546 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    80004514:	004a2603          	lw	a2,4(s4)
    80004518:	fb040593          	addi	a1,s0,-80
    8000451c:	8526                	mv	a0,s1
    8000451e:	fffff097          	auipc	ra,0xfffff
    80004522:	cb0080e7          	jalr	-848(ra) # 800031ce <dirlink>
    80004526:	06054f63          	bltz	a0,800045a4 <create+0x162>
  iunlockput(dp);
    8000452a:	8526                	mv	a0,s1
    8000452c:	fffff097          	auipc	ra,0xfffff
    80004530:	80a080e7          	jalr	-2038(ra) # 80002d36 <iunlockput>
  return ip;
    80004534:	8ad2                	mv	s5,s4
    80004536:	b749                	j	800044b8 <create+0x76>
    iunlockput(dp);
    80004538:	8526                	mv	a0,s1
    8000453a:	ffffe097          	auipc	ra,0xffffe
    8000453e:	7fc080e7          	jalr	2044(ra) # 80002d36 <iunlockput>
    return 0;
    80004542:	8ad2                	mv	s5,s4
    80004544:	bf95                	j	800044b8 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004546:	004a2603          	lw	a2,4(s4)
    8000454a:	00004597          	auipc	a1,0x4
    8000454e:	12658593          	addi	a1,a1,294 # 80008670 <syscalls+0x2a0>
    80004552:	8552                	mv	a0,s4
    80004554:	fffff097          	auipc	ra,0xfffff
    80004558:	c7a080e7          	jalr	-902(ra) # 800031ce <dirlink>
    8000455c:	04054463          	bltz	a0,800045a4 <create+0x162>
    80004560:	40d0                	lw	a2,4(s1)
    80004562:	00004597          	auipc	a1,0x4
    80004566:	11658593          	addi	a1,a1,278 # 80008678 <syscalls+0x2a8>
    8000456a:	8552                	mv	a0,s4
    8000456c:	fffff097          	auipc	ra,0xfffff
    80004570:	c62080e7          	jalr	-926(ra) # 800031ce <dirlink>
    80004574:	02054863          	bltz	a0,800045a4 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    80004578:	004a2603          	lw	a2,4(s4)
    8000457c:	fb040593          	addi	a1,s0,-80
    80004580:	8526                	mv	a0,s1
    80004582:	fffff097          	auipc	ra,0xfffff
    80004586:	c4c080e7          	jalr	-948(ra) # 800031ce <dirlink>
    8000458a:	00054d63          	bltz	a0,800045a4 <create+0x162>
    dp->nlink++;  // for ".."
    8000458e:	04a4d783          	lhu	a5,74(s1)
    80004592:	2785                	addiw	a5,a5,1
    80004594:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004598:	8526                	mv	a0,s1
    8000459a:	ffffe097          	auipc	ra,0xffffe
    8000459e:	46e080e7          	jalr	1134(ra) # 80002a08 <iupdate>
    800045a2:	b761                	j	8000452a <create+0xe8>
  ip->nlink = 0;
    800045a4:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800045a8:	8552                	mv	a0,s4
    800045aa:	ffffe097          	auipc	ra,0xffffe
    800045ae:	45e080e7          	jalr	1118(ra) # 80002a08 <iupdate>
  iunlockput(ip);
    800045b2:	8552                	mv	a0,s4
    800045b4:	ffffe097          	auipc	ra,0xffffe
    800045b8:	782080e7          	jalr	1922(ra) # 80002d36 <iunlockput>
  iunlockput(dp);
    800045bc:	8526                	mv	a0,s1
    800045be:	ffffe097          	auipc	ra,0xffffe
    800045c2:	778080e7          	jalr	1912(ra) # 80002d36 <iunlockput>
  return 0;
    800045c6:	bdcd                	j	800044b8 <create+0x76>
    return 0;
    800045c8:	8aaa                	mv	s5,a0
    800045ca:	b5fd                	j	800044b8 <create+0x76>

00000000800045cc <sys_dup>:
{
    800045cc:	7179                	addi	sp,sp,-48
    800045ce:	f406                	sd	ra,40(sp)
    800045d0:	f022                	sd	s0,32(sp)
    800045d2:	ec26                	sd	s1,24(sp)
    800045d4:	e84a                	sd	s2,16(sp)
    800045d6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800045d8:	fd840613          	addi	a2,s0,-40
    800045dc:	4581                	li	a1,0
    800045de:	4501                	li	a0,0
    800045e0:	00000097          	auipc	ra,0x0
    800045e4:	dc0080e7          	jalr	-576(ra) # 800043a0 <argfd>
    return -1;
    800045e8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800045ea:	02054363          	bltz	a0,80004610 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800045ee:	fd843903          	ld	s2,-40(s0)
    800045f2:	854a                	mv	a0,s2
    800045f4:	00000097          	auipc	ra,0x0
    800045f8:	e0c080e7          	jalr	-500(ra) # 80004400 <fdalloc>
    800045fc:	84aa                	mv	s1,a0
    return -1;
    800045fe:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004600:	00054863          	bltz	a0,80004610 <sys_dup+0x44>
  filedup(f);
    80004604:	854a                	mv	a0,s2
    80004606:	fffff097          	auipc	ra,0xfffff
    8000460a:	310080e7          	jalr	784(ra) # 80003916 <filedup>
  return fd;
    8000460e:	87a6                	mv	a5,s1
}
    80004610:	853e                	mv	a0,a5
    80004612:	70a2                	ld	ra,40(sp)
    80004614:	7402                	ld	s0,32(sp)
    80004616:	64e2                	ld	s1,24(sp)
    80004618:	6942                	ld	s2,16(sp)
    8000461a:	6145                	addi	sp,sp,48
    8000461c:	8082                	ret

000000008000461e <sys_read>:
{
    8000461e:	7179                	addi	sp,sp,-48
    80004620:	f406                	sd	ra,40(sp)
    80004622:	f022                	sd	s0,32(sp)
    80004624:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004626:	fd840593          	addi	a1,s0,-40
    8000462a:	4505                	li	a0,1
    8000462c:	ffffe097          	auipc	ra,0xffffe
    80004630:	95e080e7          	jalr	-1698(ra) # 80001f8a <argaddr>
  argint(2, &n);
    80004634:	fe440593          	addi	a1,s0,-28
    80004638:	4509                	li	a0,2
    8000463a:	ffffe097          	auipc	ra,0xffffe
    8000463e:	930080e7          	jalr	-1744(ra) # 80001f6a <argint>
  if(argfd(0, 0, &f) < 0)
    80004642:	fe840613          	addi	a2,s0,-24
    80004646:	4581                	li	a1,0
    80004648:	4501                	li	a0,0
    8000464a:	00000097          	auipc	ra,0x0
    8000464e:	d56080e7          	jalr	-682(ra) # 800043a0 <argfd>
    80004652:	87aa                	mv	a5,a0
    return -1;
    80004654:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004656:	0007cc63          	bltz	a5,8000466e <sys_read+0x50>
  return fileread(f, p, n);
    8000465a:	fe442603          	lw	a2,-28(s0)
    8000465e:	fd843583          	ld	a1,-40(s0)
    80004662:	fe843503          	ld	a0,-24(s0)
    80004666:	fffff097          	auipc	ra,0xfffff
    8000466a:	43c080e7          	jalr	1084(ra) # 80003aa2 <fileread>
}
    8000466e:	70a2                	ld	ra,40(sp)
    80004670:	7402                	ld	s0,32(sp)
    80004672:	6145                	addi	sp,sp,48
    80004674:	8082                	ret

0000000080004676 <sys_write>:
{
    80004676:	7179                	addi	sp,sp,-48
    80004678:	f406                	sd	ra,40(sp)
    8000467a:	f022                	sd	s0,32(sp)
    8000467c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000467e:	fd840593          	addi	a1,s0,-40
    80004682:	4505                	li	a0,1
    80004684:	ffffe097          	auipc	ra,0xffffe
    80004688:	906080e7          	jalr	-1786(ra) # 80001f8a <argaddr>
  argint(2, &n);
    8000468c:	fe440593          	addi	a1,s0,-28
    80004690:	4509                	li	a0,2
    80004692:	ffffe097          	auipc	ra,0xffffe
    80004696:	8d8080e7          	jalr	-1832(ra) # 80001f6a <argint>
  if(argfd(0, 0, &f) < 0)
    8000469a:	fe840613          	addi	a2,s0,-24
    8000469e:	4581                	li	a1,0
    800046a0:	4501                	li	a0,0
    800046a2:	00000097          	auipc	ra,0x0
    800046a6:	cfe080e7          	jalr	-770(ra) # 800043a0 <argfd>
    800046aa:	87aa                	mv	a5,a0
    return -1;
    800046ac:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800046ae:	0007cc63          	bltz	a5,800046c6 <sys_write+0x50>
  return filewrite(f, p, n);
    800046b2:	fe442603          	lw	a2,-28(s0)
    800046b6:	fd843583          	ld	a1,-40(s0)
    800046ba:	fe843503          	ld	a0,-24(s0)
    800046be:	fffff097          	auipc	ra,0xfffff
    800046c2:	4a6080e7          	jalr	1190(ra) # 80003b64 <filewrite>
}
    800046c6:	70a2                	ld	ra,40(sp)
    800046c8:	7402                	ld	s0,32(sp)
    800046ca:	6145                	addi	sp,sp,48
    800046cc:	8082                	ret

00000000800046ce <sys_close>:
{
    800046ce:	1101                	addi	sp,sp,-32
    800046d0:	ec06                	sd	ra,24(sp)
    800046d2:	e822                	sd	s0,16(sp)
    800046d4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800046d6:	fe040613          	addi	a2,s0,-32
    800046da:	fec40593          	addi	a1,s0,-20
    800046de:	4501                	li	a0,0
    800046e0:	00000097          	auipc	ra,0x0
    800046e4:	cc0080e7          	jalr	-832(ra) # 800043a0 <argfd>
    return -1;
    800046e8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800046ea:	02054463          	bltz	a0,80004712 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800046ee:	ffffc097          	auipc	ra,0xffffc
    800046f2:	766080e7          	jalr	1894(ra) # 80000e54 <myproc>
    800046f6:	fec42783          	lw	a5,-20(s0)
    800046fa:	07e9                	addi	a5,a5,26
    800046fc:	078e                	slli	a5,a5,0x3
    800046fe:	953e                	add	a0,a0,a5
    80004700:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004704:	fe043503          	ld	a0,-32(s0)
    80004708:	fffff097          	auipc	ra,0xfffff
    8000470c:	260080e7          	jalr	608(ra) # 80003968 <fileclose>
  return 0;
    80004710:	4781                	li	a5,0
}
    80004712:	853e                	mv	a0,a5
    80004714:	60e2                	ld	ra,24(sp)
    80004716:	6442                	ld	s0,16(sp)
    80004718:	6105                	addi	sp,sp,32
    8000471a:	8082                	ret

000000008000471c <sys_fstat>:
{
    8000471c:	1101                	addi	sp,sp,-32
    8000471e:	ec06                	sd	ra,24(sp)
    80004720:	e822                	sd	s0,16(sp)
    80004722:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004724:	fe040593          	addi	a1,s0,-32
    80004728:	4505                	li	a0,1
    8000472a:	ffffe097          	auipc	ra,0xffffe
    8000472e:	860080e7          	jalr	-1952(ra) # 80001f8a <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004732:	fe840613          	addi	a2,s0,-24
    80004736:	4581                	li	a1,0
    80004738:	4501                	li	a0,0
    8000473a:	00000097          	auipc	ra,0x0
    8000473e:	c66080e7          	jalr	-922(ra) # 800043a0 <argfd>
    80004742:	87aa                	mv	a5,a0
    return -1;
    80004744:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004746:	0007ca63          	bltz	a5,8000475a <sys_fstat+0x3e>
  return filestat(f, st);
    8000474a:	fe043583          	ld	a1,-32(s0)
    8000474e:	fe843503          	ld	a0,-24(s0)
    80004752:	fffff097          	auipc	ra,0xfffff
    80004756:	2de080e7          	jalr	734(ra) # 80003a30 <filestat>
}
    8000475a:	60e2                	ld	ra,24(sp)
    8000475c:	6442                	ld	s0,16(sp)
    8000475e:	6105                	addi	sp,sp,32
    80004760:	8082                	ret

0000000080004762 <sys_link>:
{
    80004762:	7169                	addi	sp,sp,-304
    80004764:	f606                	sd	ra,296(sp)
    80004766:	f222                	sd	s0,288(sp)
    80004768:	ee26                	sd	s1,280(sp)
    8000476a:	ea4a                	sd	s2,272(sp)
    8000476c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000476e:	08000613          	li	a2,128
    80004772:	ed040593          	addi	a1,s0,-304
    80004776:	4501                	li	a0,0
    80004778:	ffffe097          	auipc	ra,0xffffe
    8000477c:	832080e7          	jalr	-1998(ra) # 80001faa <argstr>
    return -1;
    80004780:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004782:	10054e63          	bltz	a0,8000489e <sys_link+0x13c>
    80004786:	08000613          	li	a2,128
    8000478a:	f5040593          	addi	a1,s0,-176
    8000478e:	4505                	li	a0,1
    80004790:	ffffe097          	auipc	ra,0xffffe
    80004794:	81a080e7          	jalr	-2022(ra) # 80001faa <argstr>
    return -1;
    80004798:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000479a:	10054263          	bltz	a0,8000489e <sys_link+0x13c>
  begin_op();
    8000479e:	fffff097          	auipc	ra,0xfffff
    800047a2:	d02080e7          	jalr	-766(ra) # 800034a0 <begin_op>
  if((ip = namei(old)) == 0){
    800047a6:	ed040513          	addi	a0,s0,-304
    800047aa:	fffff097          	auipc	ra,0xfffff
    800047ae:	ad6080e7          	jalr	-1322(ra) # 80003280 <namei>
    800047b2:	84aa                	mv	s1,a0
    800047b4:	c551                	beqz	a0,80004840 <sys_link+0xde>
  ilock(ip);
    800047b6:	ffffe097          	auipc	ra,0xffffe
    800047ba:	31e080e7          	jalr	798(ra) # 80002ad4 <ilock>
  if(ip->type == T_DIR){
    800047be:	04449703          	lh	a4,68(s1)
    800047c2:	4785                	li	a5,1
    800047c4:	08f70463          	beq	a4,a5,8000484c <sys_link+0xea>
  ip->nlink++;
    800047c8:	04a4d783          	lhu	a5,74(s1)
    800047cc:	2785                	addiw	a5,a5,1
    800047ce:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800047d2:	8526                	mv	a0,s1
    800047d4:	ffffe097          	auipc	ra,0xffffe
    800047d8:	234080e7          	jalr	564(ra) # 80002a08 <iupdate>
  iunlock(ip);
    800047dc:	8526                	mv	a0,s1
    800047de:	ffffe097          	auipc	ra,0xffffe
    800047e2:	3b8080e7          	jalr	952(ra) # 80002b96 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800047e6:	fd040593          	addi	a1,s0,-48
    800047ea:	f5040513          	addi	a0,s0,-176
    800047ee:	fffff097          	auipc	ra,0xfffff
    800047f2:	ab0080e7          	jalr	-1360(ra) # 8000329e <nameiparent>
    800047f6:	892a                	mv	s2,a0
    800047f8:	c935                	beqz	a0,8000486c <sys_link+0x10a>
  ilock(dp);
    800047fa:	ffffe097          	auipc	ra,0xffffe
    800047fe:	2da080e7          	jalr	730(ra) # 80002ad4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004802:	00092703          	lw	a4,0(s2)
    80004806:	409c                	lw	a5,0(s1)
    80004808:	04f71d63          	bne	a4,a5,80004862 <sys_link+0x100>
    8000480c:	40d0                	lw	a2,4(s1)
    8000480e:	fd040593          	addi	a1,s0,-48
    80004812:	854a                	mv	a0,s2
    80004814:	fffff097          	auipc	ra,0xfffff
    80004818:	9ba080e7          	jalr	-1606(ra) # 800031ce <dirlink>
    8000481c:	04054363          	bltz	a0,80004862 <sys_link+0x100>
  iunlockput(dp);
    80004820:	854a                	mv	a0,s2
    80004822:	ffffe097          	auipc	ra,0xffffe
    80004826:	514080e7          	jalr	1300(ra) # 80002d36 <iunlockput>
  iput(ip);
    8000482a:	8526                	mv	a0,s1
    8000482c:	ffffe097          	auipc	ra,0xffffe
    80004830:	462080e7          	jalr	1122(ra) # 80002c8e <iput>
  end_op();
    80004834:	fffff097          	auipc	ra,0xfffff
    80004838:	cea080e7          	jalr	-790(ra) # 8000351e <end_op>
  return 0;
    8000483c:	4781                	li	a5,0
    8000483e:	a085                	j	8000489e <sys_link+0x13c>
    end_op();
    80004840:	fffff097          	auipc	ra,0xfffff
    80004844:	cde080e7          	jalr	-802(ra) # 8000351e <end_op>
    return -1;
    80004848:	57fd                	li	a5,-1
    8000484a:	a891                	j	8000489e <sys_link+0x13c>
    iunlockput(ip);
    8000484c:	8526                	mv	a0,s1
    8000484e:	ffffe097          	auipc	ra,0xffffe
    80004852:	4e8080e7          	jalr	1256(ra) # 80002d36 <iunlockput>
    end_op();
    80004856:	fffff097          	auipc	ra,0xfffff
    8000485a:	cc8080e7          	jalr	-824(ra) # 8000351e <end_op>
    return -1;
    8000485e:	57fd                	li	a5,-1
    80004860:	a83d                	j	8000489e <sys_link+0x13c>
    iunlockput(dp);
    80004862:	854a                	mv	a0,s2
    80004864:	ffffe097          	auipc	ra,0xffffe
    80004868:	4d2080e7          	jalr	1234(ra) # 80002d36 <iunlockput>
  ilock(ip);
    8000486c:	8526                	mv	a0,s1
    8000486e:	ffffe097          	auipc	ra,0xffffe
    80004872:	266080e7          	jalr	614(ra) # 80002ad4 <ilock>
  ip->nlink--;
    80004876:	04a4d783          	lhu	a5,74(s1)
    8000487a:	37fd                	addiw	a5,a5,-1
    8000487c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004880:	8526                	mv	a0,s1
    80004882:	ffffe097          	auipc	ra,0xffffe
    80004886:	186080e7          	jalr	390(ra) # 80002a08 <iupdate>
  iunlockput(ip);
    8000488a:	8526                	mv	a0,s1
    8000488c:	ffffe097          	auipc	ra,0xffffe
    80004890:	4aa080e7          	jalr	1194(ra) # 80002d36 <iunlockput>
  end_op();
    80004894:	fffff097          	auipc	ra,0xfffff
    80004898:	c8a080e7          	jalr	-886(ra) # 8000351e <end_op>
  return -1;
    8000489c:	57fd                	li	a5,-1
}
    8000489e:	853e                	mv	a0,a5
    800048a0:	70b2                	ld	ra,296(sp)
    800048a2:	7412                	ld	s0,288(sp)
    800048a4:	64f2                	ld	s1,280(sp)
    800048a6:	6952                	ld	s2,272(sp)
    800048a8:	6155                	addi	sp,sp,304
    800048aa:	8082                	ret

00000000800048ac <sys_unlink>:
{
    800048ac:	7151                	addi	sp,sp,-240
    800048ae:	f586                	sd	ra,232(sp)
    800048b0:	f1a2                	sd	s0,224(sp)
    800048b2:	eda6                	sd	s1,216(sp)
    800048b4:	e9ca                	sd	s2,208(sp)
    800048b6:	e5ce                	sd	s3,200(sp)
    800048b8:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800048ba:	08000613          	li	a2,128
    800048be:	f3040593          	addi	a1,s0,-208
    800048c2:	4501                	li	a0,0
    800048c4:	ffffd097          	auipc	ra,0xffffd
    800048c8:	6e6080e7          	jalr	1766(ra) # 80001faa <argstr>
    800048cc:	18054163          	bltz	a0,80004a4e <sys_unlink+0x1a2>
  begin_op();
    800048d0:	fffff097          	auipc	ra,0xfffff
    800048d4:	bd0080e7          	jalr	-1072(ra) # 800034a0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800048d8:	fb040593          	addi	a1,s0,-80
    800048dc:	f3040513          	addi	a0,s0,-208
    800048e0:	fffff097          	auipc	ra,0xfffff
    800048e4:	9be080e7          	jalr	-1602(ra) # 8000329e <nameiparent>
    800048e8:	84aa                	mv	s1,a0
    800048ea:	c979                	beqz	a0,800049c0 <sys_unlink+0x114>
  ilock(dp);
    800048ec:	ffffe097          	auipc	ra,0xffffe
    800048f0:	1e8080e7          	jalr	488(ra) # 80002ad4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800048f4:	00004597          	auipc	a1,0x4
    800048f8:	d7c58593          	addi	a1,a1,-644 # 80008670 <syscalls+0x2a0>
    800048fc:	fb040513          	addi	a0,s0,-80
    80004900:	ffffe097          	auipc	ra,0xffffe
    80004904:	69e080e7          	jalr	1694(ra) # 80002f9e <namecmp>
    80004908:	14050a63          	beqz	a0,80004a5c <sys_unlink+0x1b0>
    8000490c:	00004597          	auipc	a1,0x4
    80004910:	d6c58593          	addi	a1,a1,-660 # 80008678 <syscalls+0x2a8>
    80004914:	fb040513          	addi	a0,s0,-80
    80004918:	ffffe097          	auipc	ra,0xffffe
    8000491c:	686080e7          	jalr	1670(ra) # 80002f9e <namecmp>
    80004920:	12050e63          	beqz	a0,80004a5c <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004924:	f2c40613          	addi	a2,s0,-212
    80004928:	fb040593          	addi	a1,s0,-80
    8000492c:	8526                	mv	a0,s1
    8000492e:	ffffe097          	auipc	ra,0xffffe
    80004932:	68a080e7          	jalr	1674(ra) # 80002fb8 <dirlookup>
    80004936:	892a                	mv	s2,a0
    80004938:	12050263          	beqz	a0,80004a5c <sys_unlink+0x1b0>
  ilock(ip);
    8000493c:	ffffe097          	auipc	ra,0xffffe
    80004940:	198080e7          	jalr	408(ra) # 80002ad4 <ilock>
  if(ip->nlink < 1)
    80004944:	04a91783          	lh	a5,74(s2)
    80004948:	08f05263          	blez	a5,800049cc <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000494c:	04491703          	lh	a4,68(s2)
    80004950:	4785                	li	a5,1
    80004952:	08f70563          	beq	a4,a5,800049dc <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004956:	4641                	li	a2,16
    80004958:	4581                	li	a1,0
    8000495a:	fc040513          	addi	a0,s0,-64
    8000495e:	ffffc097          	auipc	ra,0xffffc
    80004962:	81c080e7          	jalr	-2020(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004966:	4741                	li	a4,16
    80004968:	f2c42683          	lw	a3,-212(s0)
    8000496c:	fc040613          	addi	a2,s0,-64
    80004970:	4581                	li	a1,0
    80004972:	8526                	mv	a0,s1
    80004974:	ffffe097          	auipc	ra,0xffffe
    80004978:	50c080e7          	jalr	1292(ra) # 80002e80 <writei>
    8000497c:	47c1                	li	a5,16
    8000497e:	0af51563          	bne	a0,a5,80004a28 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004982:	04491703          	lh	a4,68(s2)
    80004986:	4785                	li	a5,1
    80004988:	0af70863          	beq	a4,a5,80004a38 <sys_unlink+0x18c>
  iunlockput(dp);
    8000498c:	8526                	mv	a0,s1
    8000498e:	ffffe097          	auipc	ra,0xffffe
    80004992:	3a8080e7          	jalr	936(ra) # 80002d36 <iunlockput>
  ip->nlink--;
    80004996:	04a95783          	lhu	a5,74(s2)
    8000499a:	37fd                	addiw	a5,a5,-1
    8000499c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800049a0:	854a                	mv	a0,s2
    800049a2:	ffffe097          	auipc	ra,0xffffe
    800049a6:	066080e7          	jalr	102(ra) # 80002a08 <iupdate>
  iunlockput(ip);
    800049aa:	854a                	mv	a0,s2
    800049ac:	ffffe097          	auipc	ra,0xffffe
    800049b0:	38a080e7          	jalr	906(ra) # 80002d36 <iunlockput>
  end_op();
    800049b4:	fffff097          	auipc	ra,0xfffff
    800049b8:	b6a080e7          	jalr	-1174(ra) # 8000351e <end_op>
  return 0;
    800049bc:	4501                	li	a0,0
    800049be:	a84d                	j	80004a70 <sys_unlink+0x1c4>
    end_op();
    800049c0:	fffff097          	auipc	ra,0xfffff
    800049c4:	b5e080e7          	jalr	-1186(ra) # 8000351e <end_op>
    return -1;
    800049c8:	557d                	li	a0,-1
    800049ca:	a05d                	j	80004a70 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800049cc:	00004517          	auipc	a0,0x4
    800049d0:	cb450513          	addi	a0,a0,-844 # 80008680 <syscalls+0x2b0>
    800049d4:	00001097          	auipc	ra,0x1
    800049d8:	1b8080e7          	jalr	440(ra) # 80005b8c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800049dc:	04c92703          	lw	a4,76(s2)
    800049e0:	02000793          	li	a5,32
    800049e4:	f6e7f9e3          	bgeu	a5,a4,80004956 <sys_unlink+0xaa>
    800049e8:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049ec:	4741                	li	a4,16
    800049ee:	86ce                	mv	a3,s3
    800049f0:	f1840613          	addi	a2,s0,-232
    800049f4:	4581                	li	a1,0
    800049f6:	854a                	mv	a0,s2
    800049f8:	ffffe097          	auipc	ra,0xffffe
    800049fc:	390080e7          	jalr	912(ra) # 80002d88 <readi>
    80004a00:	47c1                	li	a5,16
    80004a02:	00f51b63          	bne	a0,a5,80004a18 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004a06:	f1845783          	lhu	a5,-232(s0)
    80004a0a:	e7a1                	bnez	a5,80004a52 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a0c:	29c1                	addiw	s3,s3,16
    80004a0e:	04c92783          	lw	a5,76(s2)
    80004a12:	fcf9ede3          	bltu	s3,a5,800049ec <sys_unlink+0x140>
    80004a16:	b781                	j	80004956 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a18:	00004517          	auipc	a0,0x4
    80004a1c:	c8050513          	addi	a0,a0,-896 # 80008698 <syscalls+0x2c8>
    80004a20:	00001097          	auipc	ra,0x1
    80004a24:	16c080e7          	jalr	364(ra) # 80005b8c <panic>
    panic("unlink: writei");
    80004a28:	00004517          	auipc	a0,0x4
    80004a2c:	c8850513          	addi	a0,a0,-888 # 800086b0 <syscalls+0x2e0>
    80004a30:	00001097          	auipc	ra,0x1
    80004a34:	15c080e7          	jalr	348(ra) # 80005b8c <panic>
    dp->nlink--;
    80004a38:	04a4d783          	lhu	a5,74(s1)
    80004a3c:	37fd                	addiw	a5,a5,-1
    80004a3e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a42:	8526                	mv	a0,s1
    80004a44:	ffffe097          	auipc	ra,0xffffe
    80004a48:	fc4080e7          	jalr	-60(ra) # 80002a08 <iupdate>
    80004a4c:	b781                	j	8000498c <sys_unlink+0xe0>
    return -1;
    80004a4e:	557d                	li	a0,-1
    80004a50:	a005                	j	80004a70 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004a52:	854a                	mv	a0,s2
    80004a54:	ffffe097          	auipc	ra,0xffffe
    80004a58:	2e2080e7          	jalr	738(ra) # 80002d36 <iunlockput>
  iunlockput(dp);
    80004a5c:	8526                	mv	a0,s1
    80004a5e:	ffffe097          	auipc	ra,0xffffe
    80004a62:	2d8080e7          	jalr	728(ra) # 80002d36 <iunlockput>
  end_op();
    80004a66:	fffff097          	auipc	ra,0xfffff
    80004a6a:	ab8080e7          	jalr	-1352(ra) # 8000351e <end_op>
  return -1;
    80004a6e:	557d                	li	a0,-1
}
    80004a70:	70ae                	ld	ra,232(sp)
    80004a72:	740e                	ld	s0,224(sp)
    80004a74:	64ee                	ld	s1,216(sp)
    80004a76:	694e                	ld	s2,208(sp)
    80004a78:	69ae                	ld	s3,200(sp)
    80004a7a:	616d                	addi	sp,sp,240
    80004a7c:	8082                	ret

0000000080004a7e <sys_open>:

uint64
sys_open(void)
{
    80004a7e:	7131                	addi	sp,sp,-192
    80004a80:	fd06                	sd	ra,184(sp)
    80004a82:	f922                	sd	s0,176(sp)
    80004a84:	f526                	sd	s1,168(sp)
    80004a86:	f14a                	sd	s2,160(sp)
    80004a88:	ed4e                	sd	s3,152(sp)
    80004a8a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004a8c:	f4c40593          	addi	a1,s0,-180
    80004a90:	4505                	li	a0,1
    80004a92:	ffffd097          	auipc	ra,0xffffd
    80004a96:	4d8080e7          	jalr	1240(ra) # 80001f6a <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004a9a:	08000613          	li	a2,128
    80004a9e:	f5040593          	addi	a1,s0,-176
    80004aa2:	4501                	li	a0,0
    80004aa4:	ffffd097          	auipc	ra,0xffffd
    80004aa8:	506080e7          	jalr	1286(ra) # 80001faa <argstr>
    80004aac:	87aa                	mv	a5,a0
    return -1;
    80004aae:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004ab0:	0a07c963          	bltz	a5,80004b62 <sys_open+0xe4>

  begin_op();
    80004ab4:	fffff097          	auipc	ra,0xfffff
    80004ab8:	9ec080e7          	jalr	-1556(ra) # 800034a0 <begin_op>

  if(omode & O_CREATE){
    80004abc:	f4c42783          	lw	a5,-180(s0)
    80004ac0:	2007f793          	andi	a5,a5,512
    80004ac4:	cfc5                	beqz	a5,80004b7c <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004ac6:	4681                	li	a3,0
    80004ac8:	4601                	li	a2,0
    80004aca:	4589                	li	a1,2
    80004acc:	f5040513          	addi	a0,s0,-176
    80004ad0:	00000097          	auipc	ra,0x0
    80004ad4:	972080e7          	jalr	-1678(ra) # 80004442 <create>
    80004ad8:	84aa                	mv	s1,a0
    if(ip == 0){
    80004ada:	c959                	beqz	a0,80004b70 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004adc:	04449703          	lh	a4,68(s1)
    80004ae0:	478d                	li	a5,3
    80004ae2:	00f71763          	bne	a4,a5,80004af0 <sys_open+0x72>
    80004ae6:	0464d703          	lhu	a4,70(s1)
    80004aea:	47a5                	li	a5,9
    80004aec:	0ce7ed63          	bltu	a5,a4,80004bc6 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004af0:	fffff097          	auipc	ra,0xfffff
    80004af4:	dbc080e7          	jalr	-580(ra) # 800038ac <filealloc>
    80004af8:	89aa                	mv	s3,a0
    80004afa:	10050363          	beqz	a0,80004c00 <sys_open+0x182>
    80004afe:	00000097          	auipc	ra,0x0
    80004b02:	902080e7          	jalr	-1790(ra) # 80004400 <fdalloc>
    80004b06:	892a                	mv	s2,a0
    80004b08:	0e054763          	bltz	a0,80004bf6 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b0c:	04449703          	lh	a4,68(s1)
    80004b10:	478d                	li	a5,3
    80004b12:	0cf70563          	beq	a4,a5,80004bdc <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b16:	4789                	li	a5,2
    80004b18:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004b1c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004b20:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004b24:	f4c42783          	lw	a5,-180(s0)
    80004b28:	0017c713          	xori	a4,a5,1
    80004b2c:	8b05                	andi	a4,a4,1
    80004b2e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b32:	0037f713          	andi	a4,a5,3
    80004b36:	00e03733          	snez	a4,a4
    80004b3a:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004b3e:	4007f793          	andi	a5,a5,1024
    80004b42:	c791                	beqz	a5,80004b4e <sys_open+0xd0>
    80004b44:	04449703          	lh	a4,68(s1)
    80004b48:	4789                	li	a5,2
    80004b4a:	0af70063          	beq	a4,a5,80004bea <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004b4e:	8526                	mv	a0,s1
    80004b50:	ffffe097          	auipc	ra,0xffffe
    80004b54:	046080e7          	jalr	70(ra) # 80002b96 <iunlock>
  end_op();
    80004b58:	fffff097          	auipc	ra,0xfffff
    80004b5c:	9c6080e7          	jalr	-1594(ra) # 8000351e <end_op>

  return fd;
    80004b60:	854a                	mv	a0,s2
}
    80004b62:	70ea                	ld	ra,184(sp)
    80004b64:	744a                	ld	s0,176(sp)
    80004b66:	74aa                	ld	s1,168(sp)
    80004b68:	790a                	ld	s2,160(sp)
    80004b6a:	69ea                	ld	s3,152(sp)
    80004b6c:	6129                	addi	sp,sp,192
    80004b6e:	8082                	ret
      end_op();
    80004b70:	fffff097          	auipc	ra,0xfffff
    80004b74:	9ae080e7          	jalr	-1618(ra) # 8000351e <end_op>
      return -1;
    80004b78:	557d                	li	a0,-1
    80004b7a:	b7e5                	j	80004b62 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004b7c:	f5040513          	addi	a0,s0,-176
    80004b80:	ffffe097          	auipc	ra,0xffffe
    80004b84:	700080e7          	jalr	1792(ra) # 80003280 <namei>
    80004b88:	84aa                	mv	s1,a0
    80004b8a:	c905                	beqz	a0,80004bba <sys_open+0x13c>
    ilock(ip);
    80004b8c:	ffffe097          	auipc	ra,0xffffe
    80004b90:	f48080e7          	jalr	-184(ra) # 80002ad4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004b94:	04449703          	lh	a4,68(s1)
    80004b98:	4785                	li	a5,1
    80004b9a:	f4f711e3          	bne	a4,a5,80004adc <sys_open+0x5e>
    80004b9e:	f4c42783          	lw	a5,-180(s0)
    80004ba2:	d7b9                	beqz	a5,80004af0 <sys_open+0x72>
      iunlockput(ip);
    80004ba4:	8526                	mv	a0,s1
    80004ba6:	ffffe097          	auipc	ra,0xffffe
    80004baa:	190080e7          	jalr	400(ra) # 80002d36 <iunlockput>
      end_op();
    80004bae:	fffff097          	auipc	ra,0xfffff
    80004bb2:	970080e7          	jalr	-1680(ra) # 8000351e <end_op>
      return -1;
    80004bb6:	557d                	li	a0,-1
    80004bb8:	b76d                	j	80004b62 <sys_open+0xe4>
      end_op();
    80004bba:	fffff097          	auipc	ra,0xfffff
    80004bbe:	964080e7          	jalr	-1692(ra) # 8000351e <end_op>
      return -1;
    80004bc2:	557d                	li	a0,-1
    80004bc4:	bf79                	j	80004b62 <sys_open+0xe4>
    iunlockput(ip);
    80004bc6:	8526                	mv	a0,s1
    80004bc8:	ffffe097          	auipc	ra,0xffffe
    80004bcc:	16e080e7          	jalr	366(ra) # 80002d36 <iunlockput>
    end_op();
    80004bd0:	fffff097          	auipc	ra,0xfffff
    80004bd4:	94e080e7          	jalr	-1714(ra) # 8000351e <end_op>
    return -1;
    80004bd8:	557d                	li	a0,-1
    80004bda:	b761                	j	80004b62 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004bdc:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004be0:	04649783          	lh	a5,70(s1)
    80004be4:	02f99223          	sh	a5,36(s3)
    80004be8:	bf25                	j	80004b20 <sys_open+0xa2>
    itrunc(ip);
    80004bea:	8526                	mv	a0,s1
    80004bec:	ffffe097          	auipc	ra,0xffffe
    80004bf0:	ff6080e7          	jalr	-10(ra) # 80002be2 <itrunc>
    80004bf4:	bfa9                	j	80004b4e <sys_open+0xd0>
      fileclose(f);
    80004bf6:	854e                	mv	a0,s3
    80004bf8:	fffff097          	auipc	ra,0xfffff
    80004bfc:	d70080e7          	jalr	-656(ra) # 80003968 <fileclose>
    iunlockput(ip);
    80004c00:	8526                	mv	a0,s1
    80004c02:	ffffe097          	auipc	ra,0xffffe
    80004c06:	134080e7          	jalr	308(ra) # 80002d36 <iunlockput>
    end_op();
    80004c0a:	fffff097          	auipc	ra,0xfffff
    80004c0e:	914080e7          	jalr	-1772(ra) # 8000351e <end_op>
    return -1;
    80004c12:	557d                	li	a0,-1
    80004c14:	b7b9                	j	80004b62 <sys_open+0xe4>

0000000080004c16 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c16:	7175                	addi	sp,sp,-144
    80004c18:	e506                	sd	ra,136(sp)
    80004c1a:	e122                	sd	s0,128(sp)
    80004c1c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c1e:	fffff097          	auipc	ra,0xfffff
    80004c22:	882080e7          	jalr	-1918(ra) # 800034a0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004c26:	08000613          	li	a2,128
    80004c2a:	f7040593          	addi	a1,s0,-144
    80004c2e:	4501                	li	a0,0
    80004c30:	ffffd097          	auipc	ra,0xffffd
    80004c34:	37a080e7          	jalr	890(ra) # 80001faa <argstr>
    80004c38:	02054963          	bltz	a0,80004c6a <sys_mkdir+0x54>
    80004c3c:	4681                	li	a3,0
    80004c3e:	4601                	li	a2,0
    80004c40:	4585                	li	a1,1
    80004c42:	f7040513          	addi	a0,s0,-144
    80004c46:	fffff097          	auipc	ra,0xfffff
    80004c4a:	7fc080e7          	jalr	2044(ra) # 80004442 <create>
    80004c4e:	cd11                	beqz	a0,80004c6a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c50:	ffffe097          	auipc	ra,0xffffe
    80004c54:	0e6080e7          	jalr	230(ra) # 80002d36 <iunlockput>
  end_op();
    80004c58:	fffff097          	auipc	ra,0xfffff
    80004c5c:	8c6080e7          	jalr	-1850(ra) # 8000351e <end_op>
  return 0;
    80004c60:	4501                	li	a0,0
}
    80004c62:	60aa                	ld	ra,136(sp)
    80004c64:	640a                	ld	s0,128(sp)
    80004c66:	6149                	addi	sp,sp,144
    80004c68:	8082                	ret
    end_op();
    80004c6a:	fffff097          	auipc	ra,0xfffff
    80004c6e:	8b4080e7          	jalr	-1868(ra) # 8000351e <end_op>
    return -1;
    80004c72:	557d                	li	a0,-1
    80004c74:	b7fd                	j	80004c62 <sys_mkdir+0x4c>

0000000080004c76 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004c76:	7135                	addi	sp,sp,-160
    80004c78:	ed06                	sd	ra,152(sp)
    80004c7a:	e922                	sd	s0,144(sp)
    80004c7c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004c7e:	fffff097          	auipc	ra,0xfffff
    80004c82:	822080e7          	jalr	-2014(ra) # 800034a0 <begin_op>
  argint(1, &major);
    80004c86:	f6c40593          	addi	a1,s0,-148
    80004c8a:	4505                	li	a0,1
    80004c8c:	ffffd097          	auipc	ra,0xffffd
    80004c90:	2de080e7          	jalr	734(ra) # 80001f6a <argint>
  argint(2, &minor);
    80004c94:	f6840593          	addi	a1,s0,-152
    80004c98:	4509                	li	a0,2
    80004c9a:	ffffd097          	auipc	ra,0xffffd
    80004c9e:	2d0080e7          	jalr	720(ra) # 80001f6a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ca2:	08000613          	li	a2,128
    80004ca6:	f7040593          	addi	a1,s0,-144
    80004caa:	4501                	li	a0,0
    80004cac:	ffffd097          	auipc	ra,0xffffd
    80004cb0:	2fe080e7          	jalr	766(ra) # 80001faa <argstr>
    80004cb4:	02054b63          	bltz	a0,80004cea <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004cb8:	f6841683          	lh	a3,-152(s0)
    80004cbc:	f6c41603          	lh	a2,-148(s0)
    80004cc0:	458d                	li	a1,3
    80004cc2:	f7040513          	addi	a0,s0,-144
    80004cc6:	fffff097          	auipc	ra,0xfffff
    80004cca:	77c080e7          	jalr	1916(ra) # 80004442 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cce:	cd11                	beqz	a0,80004cea <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cd0:	ffffe097          	auipc	ra,0xffffe
    80004cd4:	066080e7          	jalr	102(ra) # 80002d36 <iunlockput>
  end_op();
    80004cd8:	fffff097          	auipc	ra,0xfffff
    80004cdc:	846080e7          	jalr	-1978(ra) # 8000351e <end_op>
  return 0;
    80004ce0:	4501                	li	a0,0
}
    80004ce2:	60ea                	ld	ra,152(sp)
    80004ce4:	644a                	ld	s0,144(sp)
    80004ce6:	610d                	addi	sp,sp,160
    80004ce8:	8082                	ret
    end_op();
    80004cea:	fffff097          	auipc	ra,0xfffff
    80004cee:	834080e7          	jalr	-1996(ra) # 8000351e <end_op>
    return -1;
    80004cf2:	557d                	li	a0,-1
    80004cf4:	b7fd                	j	80004ce2 <sys_mknod+0x6c>

0000000080004cf6 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004cf6:	7135                	addi	sp,sp,-160
    80004cf8:	ed06                	sd	ra,152(sp)
    80004cfa:	e922                	sd	s0,144(sp)
    80004cfc:	e526                	sd	s1,136(sp)
    80004cfe:	e14a                	sd	s2,128(sp)
    80004d00:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d02:	ffffc097          	auipc	ra,0xffffc
    80004d06:	152080e7          	jalr	338(ra) # 80000e54 <myproc>
    80004d0a:	892a                	mv	s2,a0
  
  begin_op();
    80004d0c:	ffffe097          	auipc	ra,0xffffe
    80004d10:	794080e7          	jalr	1940(ra) # 800034a0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d14:	08000613          	li	a2,128
    80004d18:	f6040593          	addi	a1,s0,-160
    80004d1c:	4501                	li	a0,0
    80004d1e:	ffffd097          	auipc	ra,0xffffd
    80004d22:	28c080e7          	jalr	652(ra) # 80001faa <argstr>
    80004d26:	04054b63          	bltz	a0,80004d7c <sys_chdir+0x86>
    80004d2a:	f6040513          	addi	a0,s0,-160
    80004d2e:	ffffe097          	auipc	ra,0xffffe
    80004d32:	552080e7          	jalr	1362(ra) # 80003280 <namei>
    80004d36:	84aa                	mv	s1,a0
    80004d38:	c131                	beqz	a0,80004d7c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004d3a:	ffffe097          	auipc	ra,0xffffe
    80004d3e:	d9a080e7          	jalr	-614(ra) # 80002ad4 <ilock>
  if(ip->type != T_DIR){
    80004d42:	04449703          	lh	a4,68(s1)
    80004d46:	4785                	li	a5,1
    80004d48:	04f71063          	bne	a4,a5,80004d88 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004d4c:	8526                	mv	a0,s1
    80004d4e:	ffffe097          	auipc	ra,0xffffe
    80004d52:	e48080e7          	jalr	-440(ra) # 80002b96 <iunlock>
  iput(p->cwd);
    80004d56:	15093503          	ld	a0,336(s2)
    80004d5a:	ffffe097          	auipc	ra,0xffffe
    80004d5e:	f34080e7          	jalr	-204(ra) # 80002c8e <iput>
  end_op();
    80004d62:	ffffe097          	auipc	ra,0xffffe
    80004d66:	7bc080e7          	jalr	1980(ra) # 8000351e <end_op>
  p->cwd = ip;
    80004d6a:	14993823          	sd	s1,336(s2)
  return 0;
    80004d6e:	4501                	li	a0,0
}
    80004d70:	60ea                	ld	ra,152(sp)
    80004d72:	644a                	ld	s0,144(sp)
    80004d74:	64aa                	ld	s1,136(sp)
    80004d76:	690a                	ld	s2,128(sp)
    80004d78:	610d                	addi	sp,sp,160
    80004d7a:	8082                	ret
    end_op();
    80004d7c:	ffffe097          	auipc	ra,0xffffe
    80004d80:	7a2080e7          	jalr	1954(ra) # 8000351e <end_op>
    return -1;
    80004d84:	557d                	li	a0,-1
    80004d86:	b7ed                	j	80004d70 <sys_chdir+0x7a>
    iunlockput(ip);
    80004d88:	8526                	mv	a0,s1
    80004d8a:	ffffe097          	auipc	ra,0xffffe
    80004d8e:	fac080e7          	jalr	-84(ra) # 80002d36 <iunlockput>
    end_op();
    80004d92:	ffffe097          	auipc	ra,0xffffe
    80004d96:	78c080e7          	jalr	1932(ra) # 8000351e <end_op>
    return -1;
    80004d9a:	557d                	li	a0,-1
    80004d9c:	bfd1                	j	80004d70 <sys_chdir+0x7a>

0000000080004d9e <sys_exec>:

uint64
sys_exec(void)
{
    80004d9e:	7145                	addi	sp,sp,-464
    80004da0:	e786                	sd	ra,456(sp)
    80004da2:	e3a2                	sd	s0,448(sp)
    80004da4:	ff26                	sd	s1,440(sp)
    80004da6:	fb4a                	sd	s2,432(sp)
    80004da8:	f74e                	sd	s3,424(sp)
    80004daa:	f352                	sd	s4,416(sp)
    80004dac:	ef56                	sd	s5,408(sp)
    80004dae:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004db0:	e3840593          	addi	a1,s0,-456
    80004db4:	4505                	li	a0,1
    80004db6:	ffffd097          	auipc	ra,0xffffd
    80004dba:	1d4080e7          	jalr	468(ra) # 80001f8a <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004dbe:	08000613          	li	a2,128
    80004dc2:	f4040593          	addi	a1,s0,-192
    80004dc6:	4501                	li	a0,0
    80004dc8:	ffffd097          	auipc	ra,0xffffd
    80004dcc:	1e2080e7          	jalr	482(ra) # 80001faa <argstr>
    80004dd0:	87aa                	mv	a5,a0
    return -1;
    80004dd2:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004dd4:	0c07c363          	bltz	a5,80004e9a <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004dd8:	10000613          	li	a2,256
    80004ddc:	4581                	li	a1,0
    80004dde:	e4040513          	addi	a0,s0,-448
    80004de2:	ffffb097          	auipc	ra,0xffffb
    80004de6:	398080e7          	jalr	920(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004dea:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004dee:	89a6                	mv	s3,s1
    80004df0:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004df2:	02000a13          	li	s4,32
    80004df6:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004dfa:	00391513          	slli	a0,s2,0x3
    80004dfe:	e3040593          	addi	a1,s0,-464
    80004e02:	e3843783          	ld	a5,-456(s0)
    80004e06:	953e                	add	a0,a0,a5
    80004e08:	ffffd097          	auipc	ra,0xffffd
    80004e0c:	0c4080e7          	jalr	196(ra) # 80001ecc <fetchaddr>
    80004e10:	02054a63          	bltz	a0,80004e44 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004e14:	e3043783          	ld	a5,-464(s0)
    80004e18:	c3b9                	beqz	a5,80004e5e <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e1a:	ffffb097          	auipc	ra,0xffffb
    80004e1e:	300080e7          	jalr	768(ra) # 8000011a <kalloc>
    80004e22:	85aa                	mv	a1,a0
    80004e24:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004e28:	cd11                	beqz	a0,80004e44 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004e2a:	6605                	lui	a2,0x1
    80004e2c:	e3043503          	ld	a0,-464(s0)
    80004e30:	ffffd097          	auipc	ra,0xffffd
    80004e34:	0ee080e7          	jalr	238(ra) # 80001f1e <fetchstr>
    80004e38:	00054663          	bltz	a0,80004e44 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004e3c:	0905                	addi	s2,s2,1
    80004e3e:	09a1                	addi	s3,s3,8
    80004e40:	fb491be3          	bne	s2,s4,80004df6 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e44:	f4040913          	addi	s2,s0,-192
    80004e48:	6088                	ld	a0,0(s1)
    80004e4a:	c539                	beqz	a0,80004e98 <sys_exec+0xfa>
    kfree(argv[i]);
    80004e4c:	ffffb097          	auipc	ra,0xffffb
    80004e50:	1d0080e7          	jalr	464(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e54:	04a1                	addi	s1,s1,8
    80004e56:	ff2499e3          	bne	s1,s2,80004e48 <sys_exec+0xaa>
  return -1;
    80004e5a:	557d                	li	a0,-1
    80004e5c:	a83d                	j	80004e9a <sys_exec+0xfc>
      argv[i] = 0;
    80004e5e:	0a8e                	slli	s5,s5,0x3
    80004e60:	fc0a8793          	addi	a5,s5,-64
    80004e64:	00878ab3          	add	s5,a5,s0
    80004e68:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004e6c:	e4040593          	addi	a1,s0,-448
    80004e70:	f4040513          	addi	a0,s0,-192
    80004e74:	fffff097          	auipc	ra,0xfffff
    80004e78:	16e080e7          	jalr	366(ra) # 80003fe2 <exec>
    80004e7c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e7e:	f4040993          	addi	s3,s0,-192
    80004e82:	6088                	ld	a0,0(s1)
    80004e84:	c901                	beqz	a0,80004e94 <sys_exec+0xf6>
    kfree(argv[i]);
    80004e86:	ffffb097          	auipc	ra,0xffffb
    80004e8a:	196080e7          	jalr	406(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e8e:	04a1                	addi	s1,s1,8
    80004e90:	ff3499e3          	bne	s1,s3,80004e82 <sys_exec+0xe4>
  return ret;
    80004e94:	854a                	mv	a0,s2
    80004e96:	a011                	j	80004e9a <sys_exec+0xfc>
  return -1;
    80004e98:	557d                	li	a0,-1
}
    80004e9a:	60be                	ld	ra,456(sp)
    80004e9c:	641e                	ld	s0,448(sp)
    80004e9e:	74fa                	ld	s1,440(sp)
    80004ea0:	795a                	ld	s2,432(sp)
    80004ea2:	79ba                	ld	s3,424(sp)
    80004ea4:	7a1a                	ld	s4,416(sp)
    80004ea6:	6afa                	ld	s5,408(sp)
    80004ea8:	6179                	addi	sp,sp,464
    80004eaa:	8082                	ret

0000000080004eac <sys_pipe>:

uint64
sys_pipe(void)
{
    80004eac:	7139                	addi	sp,sp,-64
    80004eae:	fc06                	sd	ra,56(sp)
    80004eb0:	f822                	sd	s0,48(sp)
    80004eb2:	f426                	sd	s1,40(sp)
    80004eb4:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004eb6:	ffffc097          	auipc	ra,0xffffc
    80004eba:	f9e080e7          	jalr	-98(ra) # 80000e54 <myproc>
    80004ebe:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004ec0:	fd840593          	addi	a1,s0,-40
    80004ec4:	4501                	li	a0,0
    80004ec6:	ffffd097          	auipc	ra,0xffffd
    80004eca:	0c4080e7          	jalr	196(ra) # 80001f8a <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004ece:	fc840593          	addi	a1,s0,-56
    80004ed2:	fd040513          	addi	a0,s0,-48
    80004ed6:	fffff097          	auipc	ra,0xfffff
    80004eda:	dc2080e7          	jalr	-574(ra) # 80003c98 <pipealloc>
    return -1;
    80004ede:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004ee0:	0c054463          	bltz	a0,80004fa8 <sys_pipe+0xfc>
  fd0 = -1;
    80004ee4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004ee8:	fd043503          	ld	a0,-48(s0)
    80004eec:	fffff097          	auipc	ra,0xfffff
    80004ef0:	514080e7          	jalr	1300(ra) # 80004400 <fdalloc>
    80004ef4:	fca42223          	sw	a0,-60(s0)
    80004ef8:	08054b63          	bltz	a0,80004f8e <sys_pipe+0xe2>
    80004efc:	fc843503          	ld	a0,-56(s0)
    80004f00:	fffff097          	auipc	ra,0xfffff
    80004f04:	500080e7          	jalr	1280(ra) # 80004400 <fdalloc>
    80004f08:	fca42023          	sw	a0,-64(s0)
    80004f0c:	06054863          	bltz	a0,80004f7c <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f10:	4691                	li	a3,4
    80004f12:	fc440613          	addi	a2,s0,-60
    80004f16:	fd843583          	ld	a1,-40(s0)
    80004f1a:	68a8                	ld	a0,80(s1)
    80004f1c:	ffffc097          	auipc	ra,0xffffc
    80004f20:	bf8080e7          	jalr	-1032(ra) # 80000b14 <copyout>
    80004f24:	02054063          	bltz	a0,80004f44 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004f28:	4691                	li	a3,4
    80004f2a:	fc040613          	addi	a2,s0,-64
    80004f2e:	fd843583          	ld	a1,-40(s0)
    80004f32:	0591                	addi	a1,a1,4
    80004f34:	68a8                	ld	a0,80(s1)
    80004f36:	ffffc097          	auipc	ra,0xffffc
    80004f3a:	bde080e7          	jalr	-1058(ra) # 80000b14 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004f3e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f40:	06055463          	bgez	a0,80004fa8 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80004f44:	fc442783          	lw	a5,-60(s0)
    80004f48:	07e9                	addi	a5,a5,26
    80004f4a:	078e                	slli	a5,a5,0x3
    80004f4c:	97a6                	add	a5,a5,s1
    80004f4e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004f52:	fc042783          	lw	a5,-64(s0)
    80004f56:	07e9                	addi	a5,a5,26
    80004f58:	078e                	slli	a5,a5,0x3
    80004f5a:	94be                	add	s1,s1,a5
    80004f5c:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004f60:	fd043503          	ld	a0,-48(s0)
    80004f64:	fffff097          	auipc	ra,0xfffff
    80004f68:	a04080e7          	jalr	-1532(ra) # 80003968 <fileclose>
    fileclose(wf);
    80004f6c:	fc843503          	ld	a0,-56(s0)
    80004f70:	fffff097          	auipc	ra,0xfffff
    80004f74:	9f8080e7          	jalr	-1544(ra) # 80003968 <fileclose>
    return -1;
    80004f78:	57fd                	li	a5,-1
    80004f7a:	a03d                	j	80004fa8 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80004f7c:	fc442783          	lw	a5,-60(s0)
    80004f80:	0007c763          	bltz	a5,80004f8e <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80004f84:	07e9                	addi	a5,a5,26
    80004f86:	078e                	slli	a5,a5,0x3
    80004f88:	97a6                	add	a5,a5,s1
    80004f8a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004f8e:	fd043503          	ld	a0,-48(s0)
    80004f92:	fffff097          	auipc	ra,0xfffff
    80004f96:	9d6080e7          	jalr	-1578(ra) # 80003968 <fileclose>
    fileclose(wf);
    80004f9a:	fc843503          	ld	a0,-56(s0)
    80004f9e:	fffff097          	auipc	ra,0xfffff
    80004fa2:	9ca080e7          	jalr	-1590(ra) # 80003968 <fileclose>
    return -1;
    80004fa6:	57fd                	li	a5,-1
}
    80004fa8:	853e                	mv	a0,a5
    80004faa:	70e2                	ld	ra,56(sp)
    80004fac:	7442                	ld	s0,48(sp)
    80004fae:	74a2                	ld	s1,40(sp)
    80004fb0:	6121                	addi	sp,sp,64
    80004fb2:	8082                	ret
	...

0000000080004fc0 <kernelvec>:
    80004fc0:	7111                	addi	sp,sp,-256
    80004fc2:	e006                	sd	ra,0(sp)
    80004fc4:	e40a                	sd	sp,8(sp)
    80004fc6:	e80e                	sd	gp,16(sp)
    80004fc8:	ec12                	sd	tp,24(sp)
    80004fca:	f016                	sd	t0,32(sp)
    80004fcc:	f41a                	sd	t1,40(sp)
    80004fce:	f81e                	sd	t2,48(sp)
    80004fd0:	fc22                	sd	s0,56(sp)
    80004fd2:	e0a6                	sd	s1,64(sp)
    80004fd4:	e4aa                	sd	a0,72(sp)
    80004fd6:	e8ae                	sd	a1,80(sp)
    80004fd8:	ecb2                	sd	a2,88(sp)
    80004fda:	f0b6                	sd	a3,96(sp)
    80004fdc:	f4ba                	sd	a4,104(sp)
    80004fde:	f8be                	sd	a5,112(sp)
    80004fe0:	fcc2                	sd	a6,120(sp)
    80004fe2:	e146                	sd	a7,128(sp)
    80004fe4:	e54a                	sd	s2,136(sp)
    80004fe6:	e94e                	sd	s3,144(sp)
    80004fe8:	ed52                	sd	s4,152(sp)
    80004fea:	f156                	sd	s5,160(sp)
    80004fec:	f55a                	sd	s6,168(sp)
    80004fee:	f95e                	sd	s7,176(sp)
    80004ff0:	fd62                	sd	s8,184(sp)
    80004ff2:	e1e6                	sd	s9,192(sp)
    80004ff4:	e5ea                	sd	s10,200(sp)
    80004ff6:	e9ee                	sd	s11,208(sp)
    80004ff8:	edf2                	sd	t3,216(sp)
    80004ffa:	f1f6                	sd	t4,224(sp)
    80004ffc:	f5fa                	sd	t5,232(sp)
    80004ffe:	f9fe                	sd	t6,240(sp)
    80005000:	d99fc0ef          	jal	ra,80001d98 <kerneltrap>
    80005004:	6082                	ld	ra,0(sp)
    80005006:	6122                	ld	sp,8(sp)
    80005008:	61c2                	ld	gp,16(sp)
    8000500a:	7282                	ld	t0,32(sp)
    8000500c:	7322                	ld	t1,40(sp)
    8000500e:	73c2                	ld	t2,48(sp)
    80005010:	7462                	ld	s0,56(sp)
    80005012:	6486                	ld	s1,64(sp)
    80005014:	6526                	ld	a0,72(sp)
    80005016:	65c6                	ld	a1,80(sp)
    80005018:	6666                	ld	a2,88(sp)
    8000501a:	7686                	ld	a3,96(sp)
    8000501c:	7726                	ld	a4,104(sp)
    8000501e:	77c6                	ld	a5,112(sp)
    80005020:	7866                	ld	a6,120(sp)
    80005022:	688a                	ld	a7,128(sp)
    80005024:	692a                	ld	s2,136(sp)
    80005026:	69ca                	ld	s3,144(sp)
    80005028:	6a6a                	ld	s4,152(sp)
    8000502a:	7a8a                	ld	s5,160(sp)
    8000502c:	7b2a                	ld	s6,168(sp)
    8000502e:	7bca                	ld	s7,176(sp)
    80005030:	7c6a                	ld	s8,184(sp)
    80005032:	6c8e                	ld	s9,192(sp)
    80005034:	6d2e                	ld	s10,200(sp)
    80005036:	6dce                	ld	s11,208(sp)
    80005038:	6e6e                	ld	t3,216(sp)
    8000503a:	7e8e                	ld	t4,224(sp)
    8000503c:	7f2e                	ld	t5,232(sp)
    8000503e:	7fce                	ld	t6,240(sp)
    80005040:	6111                	addi	sp,sp,256
    80005042:	10200073          	sret
    80005046:	00000013          	nop
    8000504a:	00000013          	nop
    8000504e:	0001                	nop

0000000080005050 <timervec>:
    80005050:	34051573          	csrrw	a0,mscratch,a0
    80005054:	e10c                	sd	a1,0(a0)
    80005056:	e510                	sd	a2,8(a0)
    80005058:	e914                	sd	a3,16(a0)
    8000505a:	6d0c                	ld	a1,24(a0)
    8000505c:	7110                	ld	a2,32(a0)
    8000505e:	6194                	ld	a3,0(a1)
    80005060:	96b2                	add	a3,a3,a2
    80005062:	e194                	sd	a3,0(a1)
    80005064:	4589                	li	a1,2
    80005066:	14459073          	csrw	sip,a1
    8000506a:	6914                	ld	a3,16(a0)
    8000506c:	6510                	ld	a2,8(a0)
    8000506e:	610c                	ld	a1,0(a0)
    80005070:	34051573          	csrrw	a0,mscratch,a0
    80005074:	30200073          	mret
	...

000000008000507a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000507a:	1141                	addi	sp,sp,-16
    8000507c:	e422                	sd	s0,8(sp)
    8000507e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005080:	0c0007b7          	lui	a5,0xc000
    80005084:	4705                	li	a4,1
    80005086:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005088:	c3d8                	sw	a4,4(a5)
}
    8000508a:	6422                	ld	s0,8(sp)
    8000508c:	0141                	addi	sp,sp,16
    8000508e:	8082                	ret

0000000080005090 <plicinithart>:

void
plicinithart(void)
{
    80005090:	1141                	addi	sp,sp,-16
    80005092:	e406                	sd	ra,8(sp)
    80005094:	e022                	sd	s0,0(sp)
    80005096:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005098:	ffffc097          	auipc	ra,0xffffc
    8000509c:	d90080e7          	jalr	-624(ra) # 80000e28 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800050a0:	0085171b          	slliw	a4,a0,0x8
    800050a4:	0c0027b7          	lui	a5,0xc002
    800050a8:	97ba                	add	a5,a5,a4
    800050aa:	40200713          	li	a4,1026
    800050ae:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800050b2:	00d5151b          	slliw	a0,a0,0xd
    800050b6:	0c2017b7          	lui	a5,0xc201
    800050ba:	97aa                	add	a5,a5,a0
    800050bc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800050c0:	60a2                	ld	ra,8(sp)
    800050c2:	6402                	ld	s0,0(sp)
    800050c4:	0141                	addi	sp,sp,16
    800050c6:	8082                	ret

00000000800050c8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800050c8:	1141                	addi	sp,sp,-16
    800050ca:	e406                	sd	ra,8(sp)
    800050cc:	e022                	sd	s0,0(sp)
    800050ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800050d0:	ffffc097          	auipc	ra,0xffffc
    800050d4:	d58080e7          	jalr	-680(ra) # 80000e28 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800050d8:	00d5151b          	slliw	a0,a0,0xd
    800050dc:	0c2017b7          	lui	a5,0xc201
    800050e0:	97aa                	add	a5,a5,a0
  return irq;
}
    800050e2:	43c8                	lw	a0,4(a5)
    800050e4:	60a2                	ld	ra,8(sp)
    800050e6:	6402                	ld	s0,0(sp)
    800050e8:	0141                	addi	sp,sp,16
    800050ea:	8082                	ret

00000000800050ec <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800050ec:	1101                	addi	sp,sp,-32
    800050ee:	ec06                	sd	ra,24(sp)
    800050f0:	e822                	sd	s0,16(sp)
    800050f2:	e426                	sd	s1,8(sp)
    800050f4:	1000                	addi	s0,sp,32
    800050f6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800050f8:	ffffc097          	auipc	ra,0xffffc
    800050fc:	d30080e7          	jalr	-720(ra) # 80000e28 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005100:	00d5151b          	slliw	a0,a0,0xd
    80005104:	0c2017b7          	lui	a5,0xc201
    80005108:	97aa                	add	a5,a5,a0
    8000510a:	c3c4                	sw	s1,4(a5)
}
    8000510c:	60e2                	ld	ra,24(sp)
    8000510e:	6442                	ld	s0,16(sp)
    80005110:	64a2                	ld	s1,8(sp)
    80005112:	6105                	addi	sp,sp,32
    80005114:	8082                	ret

0000000080005116 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005116:	1141                	addi	sp,sp,-16
    80005118:	e406                	sd	ra,8(sp)
    8000511a:	e022                	sd	s0,0(sp)
    8000511c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000511e:	479d                	li	a5,7
    80005120:	04a7cc63          	blt	a5,a0,80005178 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005124:	00015797          	auipc	a5,0x15
    80005128:	8ac78793          	addi	a5,a5,-1876 # 800199d0 <disk>
    8000512c:	97aa                	add	a5,a5,a0
    8000512e:	0187c783          	lbu	a5,24(a5)
    80005132:	ebb9                	bnez	a5,80005188 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005134:	00451693          	slli	a3,a0,0x4
    80005138:	00015797          	auipc	a5,0x15
    8000513c:	89878793          	addi	a5,a5,-1896 # 800199d0 <disk>
    80005140:	6398                	ld	a4,0(a5)
    80005142:	9736                	add	a4,a4,a3
    80005144:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005148:	6398                	ld	a4,0(a5)
    8000514a:	9736                	add	a4,a4,a3
    8000514c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005150:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005154:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005158:	97aa                	add	a5,a5,a0
    8000515a:	4705                	li	a4,1
    8000515c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005160:	00015517          	auipc	a0,0x15
    80005164:	88850513          	addi	a0,a0,-1912 # 800199e8 <disk+0x18>
    80005168:	ffffc097          	auipc	ra,0xffffc
    8000516c:	3f8080e7          	jalr	1016(ra) # 80001560 <wakeup>
}
    80005170:	60a2                	ld	ra,8(sp)
    80005172:	6402                	ld	s0,0(sp)
    80005174:	0141                	addi	sp,sp,16
    80005176:	8082                	ret
    panic("free_desc 1");
    80005178:	00003517          	auipc	a0,0x3
    8000517c:	54850513          	addi	a0,a0,1352 # 800086c0 <syscalls+0x2f0>
    80005180:	00001097          	auipc	ra,0x1
    80005184:	a0c080e7          	jalr	-1524(ra) # 80005b8c <panic>
    panic("free_desc 2");
    80005188:	00003517          	auipc	a0,0x3
    8000518c:	54850513          	addi	a0,a0,1352 # 800086d0 <syscalls+0x300>
    80005190:	00001097          	auipc	ra,0x1
    80005194:	9fc080e7          	jalr	-1540(ra) # 80005b8c <panic>

0000000080005198 <virtio_disk_init>:
{
    80005198:	1101                	addi	sp,sp,-32
    8000519a:	ec06                	sd	ra,24(sp)
    8000519c:	e822                	sd	s0,16(sp)
    8000519e:	e426                	sd	s1,8(sp)
    800051a0:	e04a                	sd	s2,0(sp)
    800051a2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800051a4:	00003597          	auipc	a1,0x3
    800051a8:	53c58593          	addi	a1,a1,1340 # 800086e0 <syscalls+0x310>
    800051ac:	00015517          	auipc	a0,0x15
    800051b0:	94c50513          	addi	a0,a0,-1716 # 80019af8 <disk+0x128>
    800051b4:	00001097          	auipc	ra,0x1
    800051b8:	e80080e7          	jalr	-384(ra) # 80006034 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051bc:	100017b7          	lui	a5,0x10001
    800051c0:	4398                	lw	a4,0(a5)
    800051c2:	2701                	sext.w	a4,a4
    800051c4:	747277b7          	lui	a5,0x74727
    800051c8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800051cc:	14f71b63          	bne	a4,a5,80005322 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800051d0:	100017b7          	lui	a5,0x10001
    800051d4:	43dc                	lw	a5,4(a5)
    800051d6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051d8:	4709                	li	a4,2
    800051da:	14e79463          	bne	a5,a4,80005322 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800051de:	100017b7          	lui	a5,0x10001
    800051e2:	479c                	lw	a5,8(a5)
    800051e4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800051e6:	12e79e63          	bne	a5,a4,80005322 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800051ea:	100017b7          	lui	a5,0x10001
    800051ee:	47d8                	lw	a4,12(a5)
    800051f0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800051f2:	554d47b7          	lui	a5,0x554d4
    800051f6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800051fa:	12f71463          	bne	a4,a5,80005322 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800051fe:	100017b7          	lui	a5,0x10001
    80005202:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005206:	4705                	li	a4,1
    80005208:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000520a:	470d                	li	a4,3
    8000520c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000520e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005210:	c7ffe6b7          	lui	a3,0xc7ffe
    80005214:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdca0f>
    80005218:	8f75                	and	a4,a4,a3
    8000521a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000521c:	472d                	li	a4,11
    8000521e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005220:	5bbc                	lw	a5,112(a5)
    80005222:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005226:	8ba1                	andi	a5,a5,8
    80005228:	10078563          	beqz	a5,80005332 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000522c:	100017b7          	lui	a5,0x10001
    80005230:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005234:	43fc                	lw	a5,68(a5)
    80005236:	2781                	sext.w	a5,a5
    80005238:	10079563          	bnez	a5,80005342 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000523c:	100017b7          	lui	a5,0x10001
    80005240:	5bdc                	lw	a5,52(a5)
    80005242:	2781                	sext.w	a5,a5
  if(max == 0)
    80005244:	10078763          	beqz	a5,80005352 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005248:	471d                	li	a4,7
    8000524a:	10f77c63          	bgeu	a4,a5,80005362 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000524e:	ffffb097          	auipc	ra,0xffffb
    80005252:	ecc080e7          	jalr	-308(ra) # 8000011a <kalloc>
    80005256:	00014497          	auipc	s1,0x14
    8000525a:	77a48493          	addi	s1,s1,1914 # 800199d0 <disk>
    8000525e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005260:	ffffb097          	auipc	ra,0xffffb
    80005264:	eba080e7          	jalr	-326(ra) # 8000011a <kalloc>
    80005268:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000526a:	ffffb097          	auipc	ra,0xffffb
    8000526e:	eb0080e7          	jalr	-336(ra) # 8000011a <kalloc>
    80005272:	87aa                	mv	a5,a0
    80005274:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005276:	6088                	ld	a0,0(s1)
    80005278:	cd6d                	beqz	a0,80005372 <virtio_disk_init+0x1da>
    8000527a:	00014717          	auipc	a4,0x14
    8000527e:	75e73703          	ld	a4,1886(a4) # 800199d8 <disk+0x8>
    80005282:	cb65                	beqz	a4,80005372 <virtio_disk_init+0x1da>
    80005284:	c7fd                	beqz	a5,80005372 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005286:	6605                	lui	a2,0x1
    80005288:	4581                	li	a1,0
    8000528a:	ffffb097          	auipc	ra,0xffffb
    8000528e:	ef0080e7          	jalr	-272(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    80005292:	00014497          	auipc	s1,0x14
    80005296:	73e48493          	addi	s1,s1,1854 # 800199d0 <disk>
    8000529a:	6605                	lui	a2,0x1
    8000529c:	4581                	li	a1,0
    8000529e:	6488                	ld	a0,8(s1)
    800052a0:	ffffb097          	auipc	ra,0xffffb
    800052a4:	eda080e7          	jalr	-294(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    800052a8:	6605                	lui	a2,0x1
    800052aa:	4581                	li	a1,0
    800052ac:	6888                	ld	a0,16(s1)
    800052ae:	ffffb097          	auipc	ra,0xffffb
    800052b2:	ecc080e7          	jalr	-308(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800052b6:	100017b7          	lui	a5,0x10001
    800052ba:	4721                	li	a4,8
    800052bc:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800052be:	4098                	lw	a4,0(s1)
    800052c0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800052c4:	40d8                	lw	a4,4(s1)
    800052c6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800052ca:	6498                	ld	a4,8(s1)
    800052cc:	0007069b          	sext.w	a3,a4
    800052d0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800052d4:	9701                	srai	a4,a4,0x20
    800052d6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800052da:	6898                	ld	a4,16(s1)
    800052dc:	0007069b          	sext.w	a3,a4
    800052e0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800052e4:	9701                	srai	a4,a4,0x20
    800052e6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800052ea:	4705                	li	a4,1
    800052ec:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800052ee:	00e48c23          	sb	a4,24(s1)
    800052f2:	00e48ca3          	sb	a4,25(s1)
    800052f6:	00e48d23          	sb	a4,26(s1)
    800052fa:	00e48da3          	sb	a4,27(s1)
    800052fe:	00e48e23          	sb	a4,28(s1)
    80005302:	00e48ea3          	sb	a4,29(s1)
    80005306:	00e48f23          	sb	a4,30(s1)
    8000530a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000530e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005312:	0727a823          	sw	s2,112(a5)
}
    80005316:	60e2                	ld	ra,24(sp)
    80005318:	6442                	ld	s0,16(sp)
    8000531a:	64a2                	ld	s1,8(sp)
    8000531c:	6902                	ld	s2,0(sp)
    8000531e:	6105                	addi	sp,sp,32
    80005320:	8082                	ret
    panic("could not find virtio disk");
    80005322:	00003517          	auipc	a0,0x3
    80005326:	3ce50513          	addi	a0,a0,974 # 800086f0 <syscalls+0x320>
    8000532a:	00001097          	auipc	ra,0x1
    8000532e:	862080e7          	jalr	-1950(ra) # 80005b8c <panic>
    panic("virtio disk FEATURES_OK unset");
    80005332:	00003517          	auipc	a0,0x3
    80005336:	3de50513          	addi	a0,a0,990 # 80008710 <syscalls+0x340>
    8000533a:	00001097          	auipc	ra,0x1
    8000533e:	852080e7          	jalr	-1966(ra) # 80005b8c <panic>
    panic("virtio disk should not be ready");
    80005342:	00003517          	auipc	a0,0x3
    80005346:	3ee50513          	addi	a0,a0,1006 # 80008730 <syscalls+0x360>
    8000534a:	00001097          	auipc	ra,0x1
    8000534e:	842080e7          	jalr	-1982(ra) # 80005b8c <panic>
    panic("virtio disk has no queue 0");
    80005352:	00003517          	auipc	a0,0x3
    80005356:	3fe50513          	addi	a0,a0,1022 # 80008750 <syscalls+0x380>
    8000535a:	00001097          	auipc	ra,0x1
    8000535e:	832080e7          	jalr	-1998(ra) # 80005b8c <panic>
    panic("virtio disk max queue too short");
    80005362:	00003517          	auipc	a0,0x3
    80005366:	40e50513          	addi	a0,a0,1038 # 80008770 <syscalls+0x3a0>
    8000536a:	00001097          	auipc	ra,0x1
    8000536e:	822080e7          	jalr	-2014(ra) # 80005b8c <panic>
    panic("virtio disk kalloc");
    80005372:	00003517          	auipc	a0,0x3
    80005376:	41e50513          	addi	a0,a0,1054 # 80008790 <syscalls+0x3c0>
    8000537a:	00001097          	auipc	ra,0x1
    8000537e:	812080e7          	jalr	-2030(ra) # 80005b8c <panic>

0000000080005382 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005382:	7119                	addi	sp,sp,-128
    80005384:	fc86                	sd	ra,120(sp)
    80005386:	f8a2                	sd	s0,112(sp)
    80005388:	f4a6                	sd	s1,104(sp)
    8000538a:	f0ca                	sd	s2,96(sp)
    8000538c:	ecce                	sd	s3,88(sp)
    8000538e:	e8d2                	sd	s4,80(sp)
    80005390:	e4d6                	sd	s5,72(sp)
    80005392:	e0da                	sd	s6,64(sp)
    80005394:	fc5e                	sd	s7,56(sp)
    80005396:	f862                	sd	s8,48(sp)
    80005398:	f466                	sd	s9,40(sp)
    8000539a:	f06a                	sd	s10,32(sp)
    8000539c:	ec6e                	sd	s11,24(sp)
    8000539e:	0100                	addi	s0,sp,128
    800053a0:	8aaa                	mv	s5,a0
    800053a2:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053a4:	00c52d03          	lw	s10,12(a0)
    800053a8:	001d1d1b          	slliw	s10,s10,0x1
    800053ac:	1d02                	slli	s10,s10,0x20
    800053ae:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    800053b2:	00014517          	auipc	a0,0x14
    800053b6:	74650513          	addi	a0,a0,1862 # 80019af8 <disk+0x128>
    800053ba:	00001097          	auipc	ra,0x1
    800053be:	d0a080e7          	jalr	-758(ra) # 800060c4 <acquire>
  for(int i = 0; i < 3; i++){
    800053c2:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800053c4:	44a1                	li	s1,8
      disk.free[i] = 0;
    800053c6:	00014b97          	auipc	s7,0x14
    800053ca:	60ab8b93          	addi	s7,s7,1546 # 800199d0 <disk>
  for(int i = 0; i < 3; i++){
    800053ce:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800053d0:	00014c97          	auipc	s9,0x14
    800053d4:	728c8c93          	addi	s9,s9,1832 # 80019af8 <disk+0x128>
    800053d8:	a08d                	j	8000543a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800053da:	00fb8733          	add	a4,s7,a5
    800053de:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800053e2:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800053e4:	0207c563          	bltz	a5,8000540e <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800053e8:	2905                	addiw	s2,s2,1
    800053ea:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800053ec:	05690c63          	beq	s2,s6,80005444 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800053f0:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800053f2:	00014717          	auipc	a4,0x14
    800053f6:	5de70713          	addi	a4,a4,1502 # 800199d0 <disk>
    800053fa:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800053fc:	01874683          	lbu	a3,24(a4)
    80005400:	fee9                	bnez	a3,800053da <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005402:	2785                	addiw	a5,a5,1
    80005404:	0705                	addi	a4,a4,1
    80005406:	fe979be3          	bne	a5,s1,800053fc <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000540a:	57fd                	li	a5,-1
    8000540c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000540e:	01205d63          	blez	s2,80005428 <virtio_disk_rw+0xa6>
    80005412:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005414:	000a2503          	lw	a0,0(s4)
    80005418:	00000097          	auipc	ra,0x0
    8000541c:	cfe080e7          	jalr	-770(ra) # 80005116 <free_desc>
      for(int j = 0; j < i; j++)
    80005420:	2d85                	addiw	s11,s11,1
    80005422:	0a11                	addi	s4,s4,4
    80005424:	ff2d98e3          	bne	s11,s2,80005414 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005428:	85e6                	mv	a1,s9
    8000542a:	00014517          	auipc	a0,0x14
    8000542e:	5be50513          	addi	a0,a0,1470 # 800199e8 <disk+0x18>
    80005432:	ffffc097          	auipc	ra,0xffffc
    80005436:	0ca080e7          	jalr	202(ra) # 800014fc <sleep>
  for(int i = 0; i < 3; i++){
    8000543a:	f8040a13          	addi	s4,s0,-128
{
    8000543e:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005440:	894e                	mv	s2,s3
    80005442:	b77d                	j	800053f0 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005444:	f8042503          	lw	a0,-128(s0)
    80005448:	00a50713          	addi	a4,a0,10
    8000544c:	0712                	slli	a4,a4,0x4

  if(write)
    8000544e:	00014797          	auipc	a5,0x14
    80005452:	58278793          	addi	a5,a5,1410 # 800199d0 <disk>
    80005456:	00e786b3          	add	a3,a5,a4
    8000545a:	01803633          	snez	a2,s8
    8000545e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005460:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005464:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005468:	f6070613          	addi	a2,a4,-160
    8000546c:	6394                	ld	a3,0(a5)
    8000546e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005470:	00870593          	addi	a1,a4,8
    80005474:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005476:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005478:	0007b803          	ld	a6,0(a5)
    8000547c:	9642                	add	a2,a2,a6
    8000547e:	46c1                	li	a3,16
    80005480:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005482:	4585                	li	a1,1
    80005484:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005488:	f8442683          	lw	a3,-124(s0)
    8000548c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005490:	0692                	slli	a3,a3,0x4
    80005492:	9836                	add	a6,a6,a3
    80005494:	058a8613          	addi	a2,s5,88
    80005498:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000549c:	0007b803          	ld	a6,0(a5)
    800054a0:	96c2                	add	a3,a3,a6
    800054a2:	40000613          	li	a2,1024
    800054a6:	c690                	sw	a2,8(a3)
  if(write)
    800054a8:	001c3613          	seqz	a2,s8
    800054ac:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800054b0:	00166613          	ori	a2,a2,1
    800054b4:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800054b8:	f8842603          	lw	a2,-120(s0)
    800054bc:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800054c0:	00250693          	addi	a3,a0,2
    800054c4:	0692                	slli	a3,a3,0x4
    800054c6:	96be                	add	a3,a3,a5
    800054c8:	58fd                	li	a7,-1
    800054ca:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054ce:	0612                	slli	a2,a2,0x4
    800054d0:	9832                	add	a6,a6,a2
    800054d2:	f9070713          	addi	a4,a4,-112
    800054d6:	973e                	add	a4,a4,a5
    800054d8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800054dc:	6398                	ld	a4,0(a5)
    800054de:	9732                	add	a4,a4,a2
    800054e0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800054e2:	4609                	li	a2,2
    800054e4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800054e8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800054ec:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    800054f0:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800054f4:	6794                	ld	a3,8(a5)
    800054f6:	0026d703          	lhu	a4,2(a3)
    800054fa:	8b1d                	andi	a4,a4,7
    800054fc:	0706                	slli	a4,a4,0x1
    800054fe:	96ba                	add	a3,a3,a4
    80005500:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005504:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005508:	6798                	ld	a4,8(a5)
    8000550a:	00275783          	lhu	a5,2(a4)
    8000550e:	2785                	addiw	a5,a5,1
    80005510:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005514:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005518:	100017b7          	lui	a5,0x10001
    8000551c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005520:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    80005524:	00014917          	auipc	s2,0x14
    80005528:	5d490913          	addi	s2,s2,1492 # 80019af8 <disk+0x128>
  while(b->disk == 1) {
    8000552c:	4485                	li	s1,1
    8000552e:	00b79c63          	bne	a5,a1,80005546 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005532:	85ca                	mv	a1,s2
    80005534:	8556                	mv	a0,s5
    80005536:	ffffc097          	auipc	ra,0xffffc
    8000553a:	fc6080e7          	jalr	-58(ra) # 800014fc <sleep>
  while(b->disk == 1) {
    8000553e:	004aa783          	lw	a5,4(s5)
    80005542:	fe9788e3          	beq	a5,s1,80005532 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005546:	f8042903          	lw	s2,-128(s0)
    8000554a:	00290713          	addi	a4,s2,2
    8000554e:	0712                	slli	a4,a4,0x4
    80005550:	00014797          	auipc	a5,0x14
    80005554:	48078793          	addi	a5,a5,1152 # 800199d0 <disk>
    80005558:	97ba                	add	a5,a5,a4
    8000555a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000555e:	00014997          	auipc	s3,0x14
    80005562:	47298993          	addi	s3,s3,1138 # 800199d0 <disk>
    80005566:	00491713          	slli	a4,s2,0x4
    8000556a:	0009b783          	ld	a5,0(s3)
    8000556e:	97ba                	add	a5,a5,a4
    80005570:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005574:	854a                	mv	a0,s2
    80005576:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000557a:	00000097          	auipc	ra,0x0
    8000557e:	b9c080e7          	jalr	-1124(ra) # 80005116 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005582:	8885                	andi	s1,s1,1
    80005584:	f0ed                	bnez	s1,80005566 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005586:	00014517          	auipc	a0,0x14
    8000558a:	57250513          	addi	a0,a0,1394 # 80019af8 <disk+0x128>
    8000558e:	00001097          	auipc	ra,0x1
    80005592:	bea080e7          	jalr	-1046(ra) # 80006178 <release>
}
    80005596:	70e6                	ld	ra,120(sp)
    80005598:	7446                	ld	s0,112(sp)
    8000559a:	74a6                	ld	s1,104(sp)
    8000559c:	7906                	ld	s2,96(sp)
    8000559e:	69e6                	ld	s3,88(sp)
    800055a0:	6a46                	ld	s4,80(sp)
    800055a2:	6aa6                	ld	s5,72(sp)
    800055a4:	6b06                	ld	s6,64(sp)
    800055a6:	7be2                	ld	s7,56(sp)
    800055a8:	7c42                	ld	s8,48(sp)
    800055aa:	7ca2                	ld	s9,40(sp)
    800055ac:	7d02                	ld	s10,32(sp)
    800055ae:	6de2                	ld	s11,24(sp)
    800055b0:	6109                	addi	sp,sp,128
    800055b2:	8082                	ret

00000000800055b4 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800055b4:	1101                	addi	sp,sp,-32
    800055b6:	ec06                	sd	ra,24(sp)
    800055b8:	e822                	sd	s0,16(sp)
    800055ba:	e426                	sd	s1,8(sp)
    800055bc:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800055be:	00014497          	auipc	s1,0x14
    800055c2:	41248493          	addi	s1,s1,1042 # 800199d0 <disk>
    800055c6:	00014517          	auipc	a0,0x14
    800055ca:	53250513          	addi	a0,a0,1330 # 80019af8 <disk+0x128>
    800055ce:	00001097          	auipc	ra,0x1
    800055d2:	af6080e7          	jalr	-1290(ra) # 800060c4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800055d6:	10001737          	lui	a4,0x10001
    800055da:	533c                	lw	a5,96(a4)
    800055dc:	8b8d                	andi	a5,a5,3
    800055de:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800055e0:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800055e4:	689c                	ld	a5,16(s1)
    800055e6:	0204d703          	lhu	a4,32(s1)
    800055ea:	0027d783          	lhu	a5,2(a5)
    800055ee:	04f70863          	beq	a4,a5,8000563e <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800055f2:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800055f6:	6898                	ld	a4,16(s1)
    800055f8:	0204d783          	lhu	a5,32(s1)
    800055fc:	8b9d                	andi	a5,a5,7
    800055fe:	078e                	slli	a5,a5,0x3
    80005600:	97ba                	add	a5,a5,a4
    80005602:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005604:	00278713          	addi	a4,a5,2
    80005608:	0712                	slli	a4,a4,0x4
    8000560a:	9726                	add	a4,a4,s1
    8000560c:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005610:	e721                	bnez	a4,80005658 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005612:	0789                	addi	a5,a5,2
    80005614:	0792                	slli	a5,a5,0x4
    80005616:	97a6                	add	a5,a5,s1
    80005618:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000561a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000561e:	ffffc097          	auipc	ra,0xffffc
    80005622:	f42080e7          	jalr	-190(ra) # 80001560 <wakeup>

    disk.used_idx += 1;
    80005626:	0204d783          	lhu	a5,32(s1)
    8000562a:	2785                	addiw	a5,a5,1
    8000562c:	17c2                	slli	a5,a5,0x30
    8000562e:	93c1                	srli	a5,a5,0x30
    80005630:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005634:	6898                	ld	a4,16(s1)
    80005636:	00275703          	lhu	a4,2(a4)
    8000563a:	faf71ce3          	bne	a4,a5,800055f2 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000563e:	00014517          	auipc	a0,0x14
    80005642:	4ba50513          	addi	a0,a0,1210 # 80019af8 <disk+0x128>
    80005646:	00001097          	auipc	ra,0x1
    8000564a:	b32080e7          	jalr	-1230(ra) # 80006178 <release>
}
    8000564e:	60e2                	ld	ra,24(sp)
    80005650:	6442                	ld	s0,16(sp)
    80005652:	64a2                	ld	s1,8(sp)
    80005654:	6105                	addi	sp,sp,32
    80005656:	8082                	ret
      panic("virtio_disk_intr status");
    80005658:	00003517          	auipc	a0,0x3
    8000565c:	15050513          	addi	a0,a0,336 # 800087a8 <syscalls+0x3d8>
    80005660:	00000097          	auipc	ra,0x0
    80005664:	52c080e7          	jalr	1324(ra) # 80005b8c <panic>

0000000080005668 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005668:	1141                	addi	sp,sp,-16
    8000566a:	e422                	sd	s0,8(sp)
    8000566c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000566e:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005672:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005676:	0037979b          	slliw	a5,a5,0x3
    8000567a:	02004737          	lui	a4,0x2004
    8000567e:	97ba                	add	a5,a5,a4
    80005680:	0200c737          	lui	a4,0x200c
    80005684:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005688:	000f4637          	lui	a2,0xf4
    8000568c:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005690:	9732                	add	a4,a4,a2
    80005692:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005694:	00259693          	slli	a3,a1,0x2
    80005698:	96ae                	add	a3,a3,a1
    8000569a:	068e                	slli	a3,a3,0x3
    8000569c:	00014717          	auipc	a4,0x14
    800056a0:	47470713          	addi	a4,a4,1140 # 80019b10 <timer_scratch>
    800056a4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800056a6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800056a8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800056aa:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800056ae:	00000797          	auipc	a5,0x0
    800056b2:	9a278793          	addi	a5,a5,-1630 # 80005050 <timervec>
    800056b6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800056ba:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800056be:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800056c2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800056c6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800056ca:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800056ce:	30479073          	csrw	mie,a5
}
    800056d2:	6422                	ld	s0,8(sp)
    800056d4:	0141                	addi	sp,sp,16
    800056d6:	8082                	ret

00000000800056d8 <start>:
{
    800056d8:	1141                	addi	sp,sp,-16
    800056da:	e406                	sd	ra,8(sp)
    800056dc:	e022                	sd	s0,0(sp)
    800056de:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800056e0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800056e4:	7779                	lui	a4,0xffffe
    800056e6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdcaaf>
    800056ea:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800056ec:	6705                	lui	a4,0x1
    800056ee:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800056f2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800056f4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800056f8:	ffffb797          	auipc	a5,0xffffb
    800056fc:	c2878793          	addi	a5,a5,-984 # 80000320 <main>
    80005700:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005704:	4781                	li	a5,0
    80005706:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000570a:	67c1                	lui	a5,0x10
    8000570c:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000570e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005712:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005716:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000571a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000571e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005722:	57fd                	li	a5,-1
    80005724:	83a9                	srli	a5,a5,0xa
    80005726:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000572a:	47bd                	li	a5,15
    8000572c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005730:	00000097          	auipc	ra,0x0
    80005734:	f38080e7          	jalr	-200(ra) # 80005668 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005738:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000573c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000573e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005740:	30200073          	mret
}
    80005744:	60a2                	ld	ra,8(sp)
    80005746:	6402                	ld	s0,0(sp)
    80005748:	0141                	addi	sp,sp,16
    8000574a:	8082                	ret

000000008000574c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000574c:	715d                	addi	sp,sp,-80
    8000574e:	e486                	sd	ra,72(sp)
    80005750:	e0a2                	sd	s0,64(sp)
    80005752:	fc26                	sd	s1,56(sp)
    80005754:	f84a                	sd	s2,48(sp)
    80005756:	f44e                	sd	s3,40(sp)
    80005758:	f052                	sd	s4,32(sp)
    8000575a:	ec56                	sd	s5,24(sp)
    8000575c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000575e:	04c05763          	blez	a2,800057ac <consolewrite+0x60>
    80005762:	8a2a                	mv	s4,a0
    80005764:	84ae                	mv	s1,a1
    80005766:	89b2                	mv	s3,a2
    80005768:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000576a:	5afd                	li	s5,-1
    8000576c:	4685                	li	a3,1
    8000576e:	8626                	mv	a2,s1
    80005770:	85d2                	mv	a1,s4
    80005772:	fbf40513          	addi	a0,s0,-65
    80005776:	ffffc097          	auipc	ra,0xffffc
    8000577a:	1e4080e7          	jalr	484(ra) # 8000195a <either_copyin>
    8000577e:	01550d63          	beq	a0,s5,80005798 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005782:	fbf44503          	lbu	a0,-65(s0)
    80005786:	00000097          	auipc	ra,0x0
    8000578a:	784080e7          	jalr	1924(ra) # 80005f0a <uartputc>
  for(i = 0; i < n; i++){
    8000578e:	2905                	addiw	s2,s2,1
    80005790:	0485                	addi	s1,s1,1
    80005792:	fd299de3          	bne	s3,s2,8000576c <consolewrite+0x20>
    80005796:	894e                	mv	s2,s3
  }

  return i;
}
    80005798:	854a                	mv	a0,s2
    8000579a:	60a6                	ld	ra,72(sp)
    8000579c:	6406                	ld	s0,64(sp)
    8000579e:	74e2                	ld	s1,56(sp)
    800057a0:	7942                	ld	s2,48(sp)
    800057a2:	79a2                	ld	s3,40(sp)
    800057a4:	7a02                	ld	s4,32(sp)
    800057a6:	6ae2                	ld	s5,24(sp)
    800057a8:	6161                	addi	sp,sp,80
    800057aa:	8082                	ret
  for(i = 0; i < n; i++){
    800057ac:	4901                	li	s2,0
    800057ae:	b7ed                	j	80005798 <consolewrite+0x4c>

00000000800057b0 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800057b0:	7159                	addi	sp,sp,-112
    800057b2:	f486                	sd	ra,104(sp)
    800057b4:	f0a2                	sd	s0,96(sp)
    800057b6:	eca6                	sd	s1,88(sp)
    800057b8:	e8ca                	sd	s2,80(sp)
    800057ba:	e4ce                	sd	s3,72(sp)
    800057bc:	e0d2                	sd	s4,64(sp)
    800057be:	fc56                	sd	s5,56(sp)
    800057c0:	f85a                	sd	s6,48(sp)
    800057c2:	f45e                	sd	s7,40(sp)
    800057c4:	f062                	sd	s8,32(sp)
    800057c6:	ec66                	sd	s9,24(sp)
    800057c8:	e86a                	sd	s10,16(sp)
    800057ca:	1880                	addi	s0,sp,112
    800057cc:	8aaa                	mv	s5,a0
    800057ce:	8a2e                	mv	s4,a1
    800057d0:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800057d2:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800057d6:	0001c517          	auipc	a0,0x1c
    800057da:	47a50513          	addi	a0,a0,1146 # 80021c50 <cons>
    800057de:	00001097          	auipc	ra,0x1
    800057e2:	8e6080e7          	jalr	-1818(ra) # 800060c4 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800057e6:	0001c497          	auipc	s1,0x1c
    800057ea:	46a48493          	addi	s1,s1,1130 # 80021c50 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800057ee:	0001c917          	auipc	s2,0x1c
    800057f2:	4fa90913          	addi	s2,s2,1274 # 80021ce8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800057f6:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800057f8:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800057fa:	4ca9                	li	s9,10
  while(n > 0){
    800057fc:	07305b63          	blez	s3,80005872 <consoleread+0xc2>
    while(cons.r == cons.w){
    80005800:	0984a783          	lw	a5,152(s1)
    80005804:	09c4a703          	lw	a4,156(s1)
    80005808:	02f71763          	bne	a4,a5,80005836 <consoleread+0x86>
      if(killed(myproc())){
    8000580c:	ffffb097          	auipc	ra,0xffffb
    80005810:	648080e7          	jalr	1608(ra) # 80000e54 <myproc>
    80005814:	ffffc097          	auipc	ra,0xffffc
    80005818:	f90080e7          	jalr	-112(ra) # 800017a4 <killed>
    8000581c:	e535                	bnez	a0,80005888 <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    8000581e:	85a6                	mv	a1,s1
    80005820:	854a                	mv	a0,s2
    80005822:	ffffc097          	auipc	ra,0xffffc
    80005826:	cda080e7          	jalr	-806(ra) # 800014fc <sleep>
    while(cons.r == cons.w){
    8000582a:	0984a783          	lw	a5,152(s1)
    8000582e:	09c4a703          	lw	a4,156(s1)
    80005832:	fcf70de3          	beq	a4,a5,8000580c <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005836:	0017871b          	addiw	a4,a5,1
    8000583a:	08e4ac23          	sw	a4,152(s1)
    8000583e:	07f7f713          	andi	a4,a5,127
    80005842:	9726                	add	a4,a4,s1
    80005844:	01874703          	lbu	a4,24(a4)
    80005848:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    8000584c:	077d0563          	beq	s10,s7,800058b6 <consoleread+0x106>
    cbuf = c;
    80005850:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005854:	4685                	li	a3,1
    80005856:	f9f40613          	addi	a2,s0,-97
    8000585a:	85d2                	mv	a1,s4
    8000585c:	8556                	mv	a0,s5
    8000585e:	ffffc097          	auipc	ra,0xffffc
    80005862:	0a6080e7          	jalr	166(ra) # 80001904 <either_copyout>
    80005866:	01850663          	beq	a0,s8,80005872 <consoleread+0xc2>
    dst++;
    8000586a:	0a05                	addi	s4,s4,1
    --n;
    8000586c:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    8000586e:	f99d17e3          	bne	s10,s9,800057fc <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005872:	0001c517          	auipc	a0,0x1c
    80005876:	3de50513          	addi	a0,a0,990 # 80021c50 <cons>
    8000587a:	00001097          	auipc	ra,0x1
    8000587e:	8fe080e7          	jalr	-1794(ra) # 80006178 <release>

  return target - n;
    80005882:	413b053b          	subw	a0,s6,s3
    80005886:	a811                	j	8000589a <consoleread+0xea>
        release(&cons.lock);
    80005888:	0001c517          	auipc	a0,0x1c
    8000588c:	3c850513          	addi	a0,a0,968 # 80021c50 <cons>
    80005890:	00001097          	auipc	ra,0x1
    80005894:	8e8080e7          	jalr	-1816(ra) # 80006178 <release>
        return -1;
    80005898:	557d                	li	a0,-1
}
    8000589a:	70a6                	ld	ra,104(sp)
    8000589c:	7406                	ld	s0,96(sp)
    8000589e:	64e6                	ld	s1,88(sp)
    800058a0:	6946                	ld	s2,80(sp)
    800058a2:	69a6                	ld	s3,72(sp)
    800058a4:	6a06                	ld	s4,64(sp)
    800058a6:	7ae2                	ld	s5,56(sp)
    800058a8:	7b42                	ld	s6,48(sp)
    800058aa:	7ba2                	ld	s7,40(sp)
    800058ac:	7c02                	ld	s8,32(sp)
    800058ae:	6ce2                	ld	s9,24(sp)
    800058b0:	6d42                	ld	s10,16(sp)
    800058b2:	6165                	addi	sp,sp,112
    800058b4:	8082                	ret
      if(n < target){
    800058b6:	0009871b          	sext.w	a4,s3
    800058ba:	fb677ce3          	bgeu	a4,s6,80005872 <consoleread+0xc2>
        cons.r--;
    800058be:	0001c717          	auipc	a4,0x1c
    800058c2:	42f72523          	sw	a5,1066(a4) # 80021ce8 <cons+0x98>
    800058c6:	b775                	j	80005872 <consoleread+0xc2>

00000000800058c8 <consputc>:
{
    800058c8:	1141                	addi	sp,sp,-16
    800058ca:	e406                	sd	ra,8(sp)
    800058cc:	e022                	sd	s0,0(sp)
    800058ce:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800058d0:	10000793          	li	a5,256
    800058d4:	00f50a63          	beq	a0,a5,800058e8 <consputc+0x20>
    uartputc_sync(c);
    800058d8:	00000097          	auipc	ra,0x0
    800058dc:	560080e7          	jalr	1376(ra) # 80005e38 <uartputc_sync>
}
    800058e0:	60a2                	ld	ra,8(sp)
    800058e2:	6402                	ld	s0,0(sp)
    800058e4:	0141                	addi	sp,sp,16
    800058e6:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800058e8:	4521                	li	a0,8
    800058ea:	00000097          	auipc	ra,0x0
    800058ee:	54e080e7          	jalr	1358(ra) # 80005e38 <uartputc_sync>
    800058f2:	02000513          	li	a0,32
    800058f6:	00000097          	auipc	ra,0x0
    800058fa:	542080e7          	jalr	1346(ra) # 80005e38 <uartputc_sync>
    800058fe:	4521                	li	a0,8
    80005900:	00000097          	auipc	ra,0x0
    80005904:	538080e7          	jalr	1336(ra) # 80005e38 <uartputc_sync>
    80005908:	bfe1                	j	800058e0 <consputc+0x18>

000000008000590a <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    8000590a:	1101                	addi	sp,sp,-32
    8000590c:	ec06                	sd	ra,24(sp)
    8000590e:	e822                	sd	s0,16(sp)
    80005910:	e426                	sd	s1,8(sp)
    80005912:	e04a                	sd	s2,0(sp)
    80005914:	1000                	addi	s0,sp,32
    80005916:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005918:	0001c517          	auipc	a0,0x1c
    8000591c:	33850513          	addi	a0,a0,824 # 80021c50 <cons>
    80005920:	00000097          	auipc	ra,0x0
    80005924:	7a4080e7          	jalr	1956(ra) # 800060c4 <acquire>

  switch(c){
    80005928:	47d5                	li	a5,21
    8000592a:	0af48663          	beq	s1,a5,800059d6 <consoleintr+0xcc>
    8000592e:	0297ca63          	blt	a5,s1,80005962 <consoleintr+0x58>
    80005932:	47a1                	li	a5,8
    80005934:	0ef48763          	beq	s1,a5,80005a22 <consoleintr+0x118>
    80005938:	47c1                	li	a5,16
    8000593a:	10f49a63          	bne	s1,a5,80005a4e <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    8000593e:	ffffc097          	auipc	ra,0xffffc
    80005942:	072080e7          	jalr	114(ra) # 800019b0 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005946:	0001c517          	auipc	a0,0x1c
    8000594a:	30a50513          	addi	a0,a0,778 # 80021c50 <cons>
    8000594e:	00001097          	auipc	ra,0x1
    80005952:	82a080e7          	jalr	-2006(ra) # 80006178 <release>
}
    80005956:	60e2                	ld	ra,24(sp)
    80005958:	6442                	ld	s0,16(sp)
    8000595a:	64a2                	ld	s1,8(sp)
    8000595c:	6902                	ld	s2,0(sp)
    8000595e:	6105                	addi	sp,sp,32
    80005960:	8082                	ret
  switch(c){
    80005962:	07f00793          	li	a5,127
    80005966:	0af48e63          	beq	s1,a5,80005a22 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000596a:	0001c717          	auipc	a4,0x1c
    8000596e:	2e670713          	addi	a4,a4,742 # 80021c50 <cons>
    80005972:	0a072783          	lw	a5,160(a4)
    80005976:	09872703          	lw	a4,152(a4)
    8000597a:	9f99                	subw	a5,a5,a4
    8000597c:	07f00713          	li	a4,127
    80005980:	fcf763e3          	bltu	a4,a5,80005946 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005984:	47b5                	li	a5,13
    80005986:	0cf48763          	beq	s1,a5,80005a54 <consoleintr+0x14a>
      consputc(c);
    8000598a:	8526                	mv	a0,s1
    8000598c:	00000097          	auipc	ra,0x0
    80005990:	f3c080e7          	jalr	-196(ra) # 800058c8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005994:	0001c797          	auipc	a5,0x1c
    80005998:	2bc78793          	addi	a5,a5,700 # 80021c50 <cons>
    8000599c:	0a07a683          	lw	a3,160(a5)
    800059a0:	0016871b          	addiw	a4,a3,1
    800059a4:	0007061b          	sext.w	a2,a4
    800059a8:	0ae7a023          	sw	a4,160(a5)
    800059ac:	07f6f693          	andi	a3,a3,127
    800059b0:	97b6                	add	a5,a5,a3
    800059b2:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800059b6:	47a9                	li	a5,10
    800059b8:	0cf48563          	beq	s1,a5,80005a82 <consoleintr+0x178>
    800059bc:	4791                	li	a5,4
    800059be:	0cf48263          	beq	s1,a5,80005a82 <consoleintr+0x178>
    800059c2:	0001c797          	auipc	a5,0x1c
    800059c6:	3267a783          	lw	a5,806(a5) # 80021ce8 <cons+0x98>
    800059ca:	9f1d                	subw	a4,a4,a5
    800059cc:	08000793          	li	a5,128
    800059d0:	f6f71be3          	bne	a4,a5,80005946 <consoleintr+0x3c>
    800059d4:	a07d                	j	80005a82 <consoleintr+0x178>
    while(cons.e != cons.w &&
    800059d6:	0001c717          	auipc	a4,0x1c
    800059da:	27a70713          	addi	a4,a4,634 # 80021c50 <cons>
    800059de:	0a072783          	lw	a5,160(a4)
    800059e2:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800059e6:	0001c497          	auipc	s1,0x1c
    800059ea:	26a48493          	addi	s1,s1,618 # 80021c50 <cons>
    while(cons.e != cons.w &&
    800059ee:	4929                	li	s2,10
    800059f0:	f4f70be3          	beq	a4,a5,80005946 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800059f4:	37fd                	addiw	a5,a5,-1
    800059f6:	07f7f713          	andi	a4,a5,127
    800059fa:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800059fc:	01874703          	lbu	a4,24(a4)
    80005a00:	f52703e3          	beq	a4,s2,80005946 <consoleintr+0x3c>
      cons.e--;
    80005a04:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005a08:	10000513          	li	a0,256
    80005a0c:	00000097          	auipc	ra,0x0
    80005a10:	ebc080e7          	jalr	-324(ra) # 800058c8 <consputc>
    while(cons.e != cons.w &&
    80005a14:	0a04a783          	lw	a5,160(s1)
    80005a18:	09c4a703          	lw	a4,156(s1)
    80005a1c:	fcf71ce3          	bne	a4,a5,800059f4 <consoleintr+0xea>
    80005a20:	b71d                	j	80005946 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005a22:	0001c717          	auipc	a4,0x1c
    80005a26:	22e70713          	addi	a4,a4,558 # 80021c50 <cons>
    80005a2a:	0a072783          	lw	a5,160(a4)
    80005a2e:	09c72703          	lw	a4,156(a4)
    80005a32:	f0f70ae3          	beq	a4,a5,80005946 <consoleintr+0x3c>
      cons.e--;
    80005a36:	37fd                	addiw	a5,a5,-1
    80005a38:	0001c717          	auipc	a4,0x1c
    80005a3c:	2af72c23          	sw	a5,696(a4) # 80021cf0 <cons+0xa0>
      consputc(BACKSPACE);
    80005a40:	10000513          	li	a0,256
    80005a44:	00000097          	auipc	ra,0x0
    80005a48:	e84080e7          	jalr	-380(ra) # 800058c8 <consputc>
    80005a4c:	bded                	j	80005946 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005a4e:	ee048ce3          	beqz	s1,80005946 <consoleintr+0x3c>
    80005a52:	bf21                	j	8000596a <consoleintr+0x60>
      consputc(c);
    80005a54:	4529                	li	a0,10
    80005a56:	00000097          	auipc	ra,0x0
    80005a5a:	e72080e7          	jalr	-398(ra) # 800058c8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005a5e:	0001c797          	auipc	a5,0x1c
    80005a62:	1f278793          	addi	a5,a5,498 # 80021c50 <cons>
    80005a66:	0a07a703          	lw	a4,160(a5)
    80005a6a:	0017069b          	addiw	a3,a4,1
    80005a6e:	0006861b          	sext.w	a2,a3
    80005a72:	0ad7a023          	sw	a3,160(a5)
    80005a76:	07f77713          	andi	a4,a4,127
    80005a7a:	97ba                	add	a5,a5,a4
    80005a7c:	4729                	li	a4,10
    80005a7e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005a82:	0001c797          	auipc	a5,0x1c
    80005a86:	26c7a523          	sw	a2,618(a5) # 80021cec <cons+0x9c>
        wakeup(&cons.r);
    80005a8a:	0001c517          	auipc	a0,0x1c
    80005a8e:	25e50513          	addi	a0,a0,606 # 80021ce8 <cons+0x98>
    80005a92:	ffffc097          	auipc	ra,0xffffc
    80005a96:	ace080e7          	jalr	-1330(ra) # 80001560 <wakeup>
    80005a9a:	b575                	j	80005946 <consoleintr+0x3c>

0000000080005a9c <consoleinit>:

void
consoleinit(void)
{
    80005a9c:	1141                	addi	sp,sp,-16
    80005a9e:	e406                	sd	ra,8(sp)
    80005aa0:	e022                	sd	s0,0(sp)
    80005aa2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005aa4:	00003597          	auipc	a1,0x3
    80005aa8:	d1c58593          	addi	a1,a1,-740 # 800087c0 <syscalls+0x3f0>
    80005aac:	0001c517          	auipc	a0,0x1c
    80005ab0:	1a450513          	addi	a0,a0,420 # 80021c50 <cons>
    80005ab4:	00000097          	auipc	ra,0x0
    80005ab8:	580080e7          	jalr	1408(ra) # 80006034 <initlock>

  uartinit();
    80005abc:	00000097          	auipc	ra,0x0
    80005ac0:	32c080e7          	jalr	812(ra) # 80005de8 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005ac4:	00013797          	auipc	a5,0x13
    80005ac8:	eb478793          	addi	a5,a5,-332 # 80018978 <devsw>
    80005acc:	00000717          	auipc	a4,0x0
    80005ad0:	ce470713          	addi	a4,a4,-796 # 800057b0 <consoleread>
    80005ad4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005ad6:	00000717          	auipc	a4,0x0
    80005ada:	c7670713          	addi	a4,a4,-906 # 8000574c <consolewrite>
    80005ade:	ef98                	sd	a4,24(a5)
}
    80005ae0:	60a2                	ld	ra,8(sp)
    80005ae2:	6402                	ld	s0,0(sp)
    80005ae4:	0141                	addi	sp,sp,16
    80005ae6:	8082                	ret

0000000080005ae8 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005ae8:	7179                	addi	sp,sp,-48
    80005aea:	f406                	sd	ra,40(sp)
    80005aec:	f022                	sd	s0,32(sp)
    80005aee:	ec26                	sd	s1,24(sp)
    80005af0:	e84a                	sd	s2,16(sp)
    80005af2:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005af4:	c219                	beqz	a2,80005afa <printint+0x12>
    80005af6:	08054763          	bltz	a0,80005b84 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005afa:	2501                	sext.w	a0,a0
    80005afc:	4881                	li	a7,0
    80005afe:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005b02:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005b04:	2581                	sext.w	a1,a1
    80005b06:	00003617          	auipc	a2,0x3
    80005b0a:	cea60613          	addi	a2,a2,-790 # 800087f0 <digits>
    80005b0e:	883a                	mv	a6,a4
    80005b10:	2705                	addiw	a4,a4,1
    80005b12:	02b577bb          	remuw	a5,a0,a1
    80005b16:	1782                	slli	a5,a5,0x20
    80005b18:	9381                	srli	a5,a5,0x20
    80005b1a:	97b2                	add	a5,a5,a2
    80005b1c:	0007c783          	lbu	a5,0(a5)
    80005b20:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005b24:	0005079b          	sext.w	a5,a0
    80005b28:	02b5553b          	divuw	a0,a0,a1
    80005b2c:	0685                	addi	a3,a3,1
    80005b2e:	feb7f0e3          	bgeu	a5,a1,80005b0e <printint+0x26>

  if(sign)
    80005b32:	00088c63          	beqz	a7,80005b4a <printint+0x62>
    buf[i++] = '-';
    80005b36:	fe070793          	addi	a5,a4,-32
    80005b3a:	00878733          	add	a4,a5,s0
    80005b3e:	02d00793          	li	a5,45
    80005b42:	fef70823          	sb	a5,-16(a4)
    80005b46:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005b4a:	02e05763          	blez	a4,80005b78 <printint+0x90>
    80005b4e:	fd040793          	addi	a5,s0,-48
    80005b52:	00e784b3          	add	s1,a5,a4
    80005b56:	fff78913          	addi	s2,a5,-1
    80005b5a:	993a                	add	s2,s2,a4
    80005b5c:	377d                	addiw	a4,a4,-1
    80005b5e:	1702                	slli	a4,a4,0x20
    80005b60:	9301                	srli	a4,a4,0x20
    80005b62:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005b66:	fff4c503          	lbu	a0,-1(s1)
    80005b6a:	00000097          	auipc	ra,0x0
    80005b6e:	d5e080e7          	jalr	-674(ra) # 800058c8 <consputc>
  while(--i >= 0)
    80005b72:	14fd                	addi	s1,s1,-1
    80005b74:	ff2499e3          	bne	s1,s2,80005b66 <printint+0x7e>
}
    80005b78:	70a2                	ld	ra,40(sp)
    80005b7a:	7402                	ld	s0,32(sp)
    80005b7c:	64e2                	ld	s1,24(sp)
    80005b7e:	6942                	ld	s2,16(sp)
    80005b80:	6145                	addi	sp,sp,48
    80005b82:	8082                	ret
    x = -xx;
    80005b84:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005b88:	4885                	li	a7,1
    x = -xx;
    80005b8a:	bf95                	j	80005afe <printint+0x16>

0000000080005b8c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005b8c:	1101                	addi	sp,sp,-32
    80005b8e:	ec06                	sd	ra,24(sp)
    80005b90:	e822                	sd	s0,16(sp)
    80005b92:	e426                	sd	s1,8(sp)
    80005b94:	1000                	addi	s0,sp,32
    80005b96:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005b98:	0001c797          	auipc	a5,0x1c
    80005b9c:	1607ac23          	sw	zero,376(a5) # 80021d10 <pr+0x18>
  printf("panic: ");
    80005ba0:	00003517          	auipc	a0,0x3
    80005ba4:	c2850513          	addi	a0,a0,-984 # 800087c8 <syscalls+0x3f8>
    80005ba8:	00000097          	auipc	ra,0x0
    80005bac:	02e080e7          	jalr	46(ra) # 80005bd6 <printf>
  printf(s);
    80005bb0:	8526                	mv	a0,s1
    80005bb2:	00000097          	auipc	ra,0x0
    80005bb6:	024080e7          	jalr	36(ra) # 80005bd6 <printf>
  printf("\n");
    80005bba:	00002517          	auipc	a0,0x2
    80005bbe:	48e50513          	addi	a0,a0,1166 # 80008048 <etext+0x48>
    80005bc2:	00000097          	auipc	ra,0x0
    80005bc6:	014080e7          	jalr	20(ra) # 80005bd6 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005bca:	4785                	li	a5,1
    80005bcc:	00003717          	auipc	a4,0x3
    80005bd0:	d0f72023          	sw	a5,-768(a4) # 800088cc <panicked>
  for(;;)
    80005bd4:	a001                	j	80005bd4 <panic+0x48>

0000000080005bd6 <printf>:
{
    80005bd6:	7131                	addi	sp,sp,-192
    80005bd8:	fc86                	sd	ra,120(sp)
    80005bda:	f8a2                	sd	s0,112(sp)
    80005bdc:	f4a6                	sd	s1,104(sp)
    80005bde:	f0ca                	sd	s2,96(sp)
    80005be0:	ecce                	sd	s3,88(sp)
    80005be2:	e8d2                	sd	s4,80(sp)
    80005be4:	e4d6                	sd	s5,72(sp)
    80005be6:	e0da                	sd	s6,64(sp)
    80005be8:	fc5e                	sd	s7,56(sp)
    80005bea:	f862                	sd	s8,48(sp)
    80005bec:	f466                	sd	s9,40(sp)
    80005bee:	f06a                	sd	s10,32(sp)
    80005bf0:	ec6e                	sd	s11,24(sp)
    80005bf2:	0100                	addi	s0,sp,128
    80005bf4:	8a2a                	mv	s4,a0
    80005bf6:	e40c                	sd	a1,8(s0)
    80005bf8:	e810                	sd	a2,16(s0)
    80005bfa:	ec14                	sd	a3,24(s0)
    80005bfc:	f018                	sd	a4,32(s0)
    80005bfe:	f41c                	sd	a5,40(s0)
    80005c00:	03043823          	sd	a6,48(s0)
    80005c04:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005c08:	0001cd97          	auipc	s11,0x1c
    80005c0c:	108dad83          	lw	s11,264(s11) # 80021d10 <pr+0x18>
  if(locking)
    80005c10:	020d9b63          	bnez	s11,80005c46 <printf+0x70>
  if (fmt == 0)
    80005c14:	040a0263          	beqz	s4,80005c58 <printf+0x82>
  va_start(ap, fmt);
    80005c18:	00840793          	addi	a5,s0,8
    80005c1c:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c20:	000a4503          	lbu	a0,0(s4)
    80005c24:	14050f63          	beqz	a0,80005d82 <printf+0x1ac>
    80005c28:	4981                	li	s3,0
    if(c != '%'){
    80005c2a:	02500a93          	li	s5,37
    switch(c){
    80005c2e:	07000b93          	li	s7,112
  consputc('x');
    80005c32:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005c34:	00003b17          	auipc	s6,0x3
    80005c38:	bbcb0b13          	addi	s6,s6,-1092 # 800087f0 <digits>
    switch(c){
    80005c3c:	07300c93          	li	s9,115
    80005c40:	06400c13          	li	s8,100
    80005c44:	a82d                	j	80005c7e <printf+0xa8>
    acquire(&pr.lock);
    80005c46:	0001c517          	auipc	a0,0x1c
    80005c4a:	0b250513          	addi	a0,a0,178 # 80021cf8 <pr>
    80005c4e:	00000097          	auipc	ra,0x0
    80005c52:	476080e7          	jalr	1142(ra) # 800060c4 <acquire>
    80005c56:	bf7d                	j	80005c14 <printf+0x3e>
    panic("null fmt");
    80005c58:	00003517          	auipc	a0,0x3
    80005c5c:	b8050513          	addi	a0,a0,-1152 # 800087d8 <syscalls+0x408>
    80005c60:	00000097          	auipc	ra,0x0
    80005c64:	f2c080e7          	jalr	-212(ra) # 80005b8c <panic>
      consputc(c);
    80005c68:	00000097          	auipc	ra,0x0
    80005c6c:	c60080e7          	jalr	-928(ra) # 800058c8 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c70:	2985                	addiw	s3,s3,1
    80005c72:	013a07b3          	add	a5,s4,s3
    80005c76:	0007c503          	lbu	a0,0(a5)
    80005c7a:	10050463          	beqz	a0,80005d82 <printf+0x1ac>
    if(c != '%'){
    80005c7e:	ff5515e3          	bne	a0,s5,80005c68 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005c82:	2985                	addiw	s3,s3,1
    80005c84:	013a07b3          	add	a5,s4,s3
    80005c88:	0007c783          	lbu	a5,0(a5)
    80005c8c:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005c90:	cbed                	beqz	a5,80005d82 <printf+0x1ac>
    switch(c){
    80005c92:	05778a63          	beq	a5,s7,80005ce6 <printf+0x110>
    80005c96:	02fbf663          	bgeu	s7,a5,80005cc2 <printf+0xec>
    80005c9a:	09978863          	beq	a5,s9,80005d2a <printf+0x154>
    80005c9e:	07800713          	li	a4,120
    80005ca2:	0ce79563          	bne	a5,a4,80005d6c <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005ca6:	f8843783          	ld	a5,-120(s0)
    80005caa:	00878713          	addi	a4,a5,8
    80005cae:	f8e43423          	sd	a4,-120(s0)
    80005cb2:	4605                	li	a2,1
    80005cb4:	85ea                	mv	a1,s10
    80005cb6:	4388                	lw	a0,0(a5)
    80005cb8:	00000097          	auipc	ra,0x0
    80005cbc:	e30080e7          	jalr	-464(ra) # 80005ae8 <printint>
      break;
    80005cc0:	bf45                	j	80005c70 <printf+0x9a>
    switch(c){
    80005cc2:	09578f63          	beq	a5,s5,80005d60 <printf+0x18a>
    80005cc6:	0b879363          	bne	a5,s8,80005d6c <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005cca:	f8843783          	ld	a5,-120(s0)
    80005cce:	00878713          	addi	a4,a5,8
    80005cd2:	f8e43423          	sd	a4,-120(s0)
    80005cd6:	4605                	li	a2,1
    80005cd8:	45a9                	li	a1,10
    80005cda:	4388                	lw	a0,0(a5)
    80005cdc:	00000097          	auipc	ra,0x0
    80005ce0:	e0c080e7          	jalr	-500(ra) # 80005ae8 <printint>
      break;
    80005ce4:	b771                	j	80005c70 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005ce6:	f8843783          	ld	a5,-120(s0)
    80005cea:	00878713          	addi	a4,a5,8
    80005cee:	f8e43423          	sd	a4,-120(s0)
    80005cf2:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005cf6:	03000513          	li	a0,48
    80005cfa:	00000097          	auipc	ra,0x0
    80005cfe:	bce080e7          	jalr	-1074(ra) # 800058c8 <consputc>
  consputc('x');
    80005d02:	07800513          	li	a0,120
    80005d06:	00000097          	auipc	ra,0x0
    80005d0a:	bc2080e7          	jalr	-1086(ra) # 800058c8 <consputc>
    80005d0e:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d10:	03c95793          	srli	a5,s2,0x3c
    80005d14:	97da                	add	a5,a5,s6
    80005d16:	0007c503          	lbu	a0,0(a5)
    80005d1a:	00000097          	auipc	ra,0x0
    80005d1e:	bae080e7          	jalr	-1106(ra) # 800058c8 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005d22:	0912                	slli	s2,s2,0x4
    80005d24:	34fd                	addiw	s1,s1,-1
    80005d26:	f4ed                	bnez	s1,80005d10 <printf+0x13a>
    80005d28:	b7a1                	j	80005c70 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005d2a:	f8843783          	ld	a5,-120(s0)
    80005d2e:	00878713          	addi	a4,a5,8
    80005d32:	f8e43423          	sd	a4,-120(s0)
    80005d36:	6384                	ld	s1,0(a5)
    80005d38:	cc89                	beqz	s1,80005d52 <printf+0x17c>
      for(; *s; s++)
    80005d3a:	0004c503          	lbu	a0,0(s1)
    80005d3e:	d90d                	beqz	a0,80005c70 <printf+0x9a>
        consputc(*s);
    80005d40:	00000097          	auipc	ra,0x0
    80005d44:	b88080e7          	jalr	-1144(ra) # 800058c8 <consputc>
      for(; *s; s++)
    80005d48:	0485                	addi	s1,s1,1
    80005d4a:	0004c503          	lbu	a0,0(s1)
    80005d4e:	f96d                	bnez	a0,80005d40 <printf+0x16a>
    80005d50:	b705                	j	80005c70 <printf+0x9a>
        s = "(null)";
    80005d52:	00003497          	auipc	s1,0x3
    80005d56:	a7e48493          	addi	s1,s1,-1410 # 800087d0 <syscalls+0x400>
      for(; *s; s++)
    80005d5a:	02800513          	li	a0,40
    80005d5e:	b7cd                	j	80005d40 <printf+0x16a>
      consputc('%');
    80005d60:	8556                	mv	a0,s5
    80005d62:	00000097          	auipc	ra,0x0
    80005d66:	b66080e7          	jalr	-1178(ra) # 800058c8 <consputc>
      break;
    80005d6a:	b719                	j	80005c70 <printf+0x9a>
      consputc('%');
    80005d6c:	8556                	mv	a0,s5
    80005d6e:	00000097          	auipc	ra,0x0
    80005d72:	b5a080e7          	jalr	-1190(ra) # 800058c8 <consputc>
      consputc(c);
    80005d76:	8526                	mv	a0,s1
    80005d78:	00000097          	auipc	ra,0x0
    80005d7c:	b50080e7          	jalr	-1200(ra) # 800058c8 <consputc>
      break;
    80005d80:	bdc5                	j	80005c70 <printf+0x9a>
  if(locking)
    80005d82:	020d9163          	bnez	s11,80005da4 <printf+0x1ce>
}
    80005d86:	70e6                	ld	ra,120(sp)
    80005d88:	7446                	ld	s0,112(sp)
    80005d8a:	74a6                	ld	s1,104(sp)
    80005d8c:	7906                	ld	s2,96(sp)
    80005d8e:	69e6                	ld	s3,88(sp)
    80005d90:	6a46                	ld	s4,80(sp)
    80005d92:	6aa6                	ld	s5,72(sp)
    80005d94:	6b06                	ld	s6,64(sp)
    80005d96:	7be2                	ld	s7,56(sp)
    80005d98:	7c42                	ld	s8,48(sp)
    80005d9a:	7ca2                	ld	s9,40(sp)
    80005d9c:	7d02                	ld	s10,32(sp)
    80005d9e:	6de2                	ld	s11,24(sp)
    80005da0:	6129                	addi	sp,sp,192
    80005da2:	8082                	ret
    release(&pr.lock);
    80005da4:	0001c517          	auipc	a0,0x1c
    80005da8:	f5450513          	addi	a0,a0,-172 # 80021cf8 <pr>
    80005dac:	00000097          	auipc	ra,0x0
    80005db0:	3cc080e7          	jalr	972(ra) # 80006178 <release>
}
    80005db4:	bfc9                	j	80005d86 <printf+0x1b0>

0000000080005db6 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005db6:	1101                	addi	sp,sp,-32
    80005db8:	ec06                	sd	ra,24(sp)
    80005dba:	e822                	sd	s0,16(sp)
    80005dbc:	e426                	sd	s1,8(sp)
    80005dbe:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005dc0:	0001c497          	auipc	s1,0x1c
    80005dc4:	f3848493          	addi	s1,s1,-200 # 80021cf8 <pr>
    80005dc8:	00003597          	auipc	a1,0x3
    80005dcc:	a2058593          	addi	a1,a1,-1504 # 800087e8 <syscalls+0x418>
    80005dd0:	8526                	mv	a0,s1
    80005dd2:	00000097          	auipc	ra,0x0
    80005dd6:	262080e7          	jalr	610(ra) # 80006034 <initlock>
  pr.locking = 1;
    80005dda:	4785                	li	a5,1
    80005ddc:	cc9c                	sw	a5,24(s1)
}
    80005dde:	60e2                	ld	ra,24(sp)
    80005de0:	6442                	ld	s0,16(sp)
    80005de2:	64a2                	ld	s1,8(sp)
    80005de4:	6105                	addi	sp,sp,32
    80005de6:	8082                	ret

0000000080005de8 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005de8:	1141                	addi	sp,sp,-16
    80005dea:	e406                	sd	ra,8(sp)
    80005dec:	e022                	sd	s0,0(sp)
    80005dee:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005df0:	100007b7          	lui	a5,0x10000
    80005df4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005df8:	f8000713          	li	a4,-128
    80005dfc:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005e00:	470d                	li	a4,3
    80005e02:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005e06:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005e0a:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005e0e:	469d                	li	a3,7
    80005e10:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005e14:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005e18:	00003597          	auipc	a1,0x3
    80005e1c:	9f058593          	addi	a1,a1,-1552 # 80008808 <digits+0x18>
    80005e20:	0001c517          	auipc	a0,0x1c
    80005e24:	ef850513          	addi	a0,a0,-264 # 80021d18 <uart_tx_lock>
    80005e28:	00000097          	auipc	ra,0x0
    80005e2c:	20c080e7          	jalr	524(ra) # 80006034 <initlock>
}
    80005e30:	60a2                	ld	ra,8(sp)
    80005e32:	6402                	ld	s0,0(sp)
    80005e34:	0141                	addi	sp,sp,16
    80005e36:	8082                	ret

0000000080005e38 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005e38:	1101                	addi	sp,sp,-32
    80005e3a:	ec06                	sd	ra,24(sp)
    80005e3c:	e822                	sd	s0,16(sp)
    80005e3e:	e426                	sd	s1,8(sp)
    80005e40:	1000                	addi	s0,sp,32
    80005e42:	84aa                	mv	s1,a0
  push_off();
    80005e44:	00000097          	auipc	ra,0x0
    80005e48:	234080e7          	jalr	564(ra) # 80006078 <push_off>

  if(panicked){
    80005e4c:	00003797          	auipc	a5,0x3
    80005e50:	a807a783          	lw	a5,-1408(a5) # 800088cc <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005e54:	10000737          	lui	a4,0x10000
  if(panicked){
    80005e58:	c391                	beqz	a5,80005e5c <uartputc_sync+0x24>
    for(;;)
    80005e5a:	a001                	j	80005e5a <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005e5c:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005e60:	0207f793          	andi	a5,a5,32
    80005e64:	dfe5                	beqz	a5,80005e5c <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005e66:	0ff4f513          	zext.b	a0,s1
    80005e6a:	100007b7          	lui	a5,0x10000
    80005e6e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005e72:	00000097          	auipc	ra,0x0
    80005e76:	2a6080e7          	jalr	678(ra) # 80006118 <pop_off>
}
    80005e7a:	60e2                	ld	ra,24(sp)
    80005e7c:	6442                	ld	s0,16(sp)
    80005e7e:	64a2                	ld	s1,8(sp)
    80005e80:	6105                	addi	sp,sp,32
    80005e82:	8082                	ret

0000000080005e84 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005e84:	00003797          	auipc	a5,0x3
    80005e88:	a4c7b783          	ld	a5,-1460(a5) # 800088d0 <uart_tx_r>
    80005e8c:	00003717          	auipc	a4,0x3
    80005e90:	a4c73703          	ld	a4,-1460(a4) # 800088d8 <uart_tx_w>
    80005e94:	06f70a63          	beq	a4,a5,80005f08 <uartstart+0x84>
{
    80005e98:	7139                	addi	sp,sp,-64
    80005e9a:	fc06                	sd	ra,56(sp)
    80005e9c:	f822                	sd	s0,48(sp)
    80005e9e:	f426                	sd	s1,40(sp)
    80005ea0:	f04a                	sd	s2,32(sp)
    80005ea2:	ec4e                	sd	s3,24(sp)
    80005ea4:	e852                	sd	s4,16(sp)
    80005ea6:	e456                	sd	s5,8(sp)
    80005ea8:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005eaa:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005eae:	0001ca17          	auipc	s4,0x1c
    80005eb2:	e6aa0a13          	addi	s4,s4,-406 # 80021d18 <uart_tx_lock>
    uart_tx_r += 1;
    80005eb6:	00003497          	auipc	s1,0x3
    80005eba:	a1a48493          	addi	s1,s1,-1510 # 800088d0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005ebe:	00003997          	auipc	s3,0x3
    80005ec2:	a1a98993          	addi	s3,s3,-1510 # 800088d8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005ec6:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005eca:	02077713          	andi	a4,a4,32
    80005ece:	c705                	beqz	a4,80005ef6 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005ed0:	01f7f713          	andi	a4,a5,31
    80005ed4:	9752                	add	a4,a4,s4
    80005ed6:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005eda:	0785                	addi	a5,a5,1
    80005edc:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005ede:	8526                	mv	a0,s1
    80005ee0:	ffffb097          	auipc	ra,0xffffb
    80005ee4:	680080e7          	jalr	1664(ra) # 80001560 <wakeup>
    
    WriteReg(THR, c);
    80005ee8:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005eec:	609c                	ld	a5,0(s1)
    80005eee:	0009b703          	ld	a4,0(s3)
    80005ef2:	fcf71ae3          	bne	a4,a5,80005ec6 <uartstart+0x42>
  }
}
    80005ef6:	70e2                	ld	ra,56(sp)
    80005ef8:	7442                	ld	s0,48(sp)
    80005efa:	74a2                	ld	s1,40(sp)
    80005efc:	7902                	ld	s2,32(sp)
    80005efe:	69e2                	ld	s3,24(sp)
    80005f00:	6a42                	ld	s4,16(sp)
    80005f02:	6aa2                	ld	s5,8(sp)
    80005f04:	6121                	addi	sp,sp,64
    80005f06:	8082                	ret
    80005f08:	8082                	ret

0000000080005f0a <uartputc>:
{
    80005f0a:	7179                	addi	sp,sp,-48
    80005f0c:	f406                	sd	ra,40(sp)
    80005f0e:	f022                	sd	s0,32(sp)
    80005f10:	ec26                	sd	s1,24(sp)
    80005f12:	e84a                	sd	s2,16(sp)
    80005f14:	e44e                	sd	s3,8(sp)
    80005f16:	e052                	sd	s4,0(sp)
    80005f18:	1800                	addi	s0,sp,48
    80005f1a:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005f1c:	0001c517          	auipc	a0,0x1c
    80005f20:	dfc50513          	addi	a0,a0,-516 # 80021d18 <uart_tx_lock>
    80005f24:	00000097          	auipc	ra,0x0
    80005f28:	1a0080e7          	jalr	416(ra) # 800060c4 <acquire>
  if(panicked){
    80005f2c:	00003797          	auipc	a5,0x3
    80005f30:	9a07a783          	lw	a5,-1632(a5) # 800088cc <panicked>
    80005f34:	e7c9                	bnez	a5,80005fbe <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f36:	00003717          	auipc	a4,0x3
    80005f3a:	9a273703          	ld	a4,-1630(a4) # 800088d8 <uart_tx_w>
    80005f3e:	00003797          	auipc	a5,0x3
    80005f42:	9927b783          	ld	a5,-1646(a5) # 800088d0 <uart_tx_r>
    80005f46:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005f4a:	0001c997          	auipc	s3,0x1c
    80005f4e:	dce98993          	addi	s3,s3,-562 # 80021d18 <uart_tx_lock>
    80005f52:	00003497          	auipc	s1,0x3
    80005f56:	97e48493          	addi	s1,s1,-1666 # 800088d0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f5a:	00003917          	auipc	s2,0x3
    80005f5e:	97e90913          	addi	s2,s2,-1666 # 800088d8 <uart_tx_w>
    80005f62:	00e79f63          	bne	a5,a4,80005f80 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005f66:	85ce                	mv	a1,s3
    80005f68:	8526                	mv	a0,s1
    80005f6a:	ffffb097          	auipc	ra,0xffffb
    80005f6e:	592080e7          	jalr	1426(ra) # 800014fc <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f72:	00093703          	ld	a4,0(s2)
    80005f76:	609c                	ld	a5,0(s1)
    80005f78:	02078793          	addi	a5,a5,32
    80005f7c:	fee785e3          	beq	a5,a4,80005f66 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005f80:	0001c497          	auipc	s1,0x1c
    80005f84:	d9848493          	addi	s1,s1,-616 # 80021d18 <uart_tx_lock>
    80005f88:	01f77793          	andi	a5,a4,31
    80005f8c:	97a6                	add	a5,a5,s1
    80005f8e:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005f92:	0705                	addi	a4,a4,1
    80005f94:	00003797          	auipc	a5,0x3
    80005f98:	94e7b223          	sd	a4,-1724(a5) # 800088d8 <uart_tx_w>
  uartstart();
    80005f9c:	00000097          	auipc	ra,0x0
    80005fa0:	ee8080e7          	jalr	-280(ra) # 80005e84 <uartstart>
  release(&uart_tx_lock);
    80005fa4:	8526                	mv	a0,s1
    80005fa6:	00000097          	auipc	ra,0x0
    80005faa:	1d2080e7          	jalr	466(ra) # 80006178 <release>
}
    80005fae:	70a2                	ld	ra,40(sp)
    80005fb0:	7402                	ld	s0,32(sp)
    80005fb2:	64e2                	ld	s1,24(sp)
    80005fb4:	6942                	ld	s2,16(sp)
    80005fb6:	69a2                	ld	s3,8(sp)
    80005fb8:	6a02                	ld	s4,0(sp)
    80005fba:	6145                	addi	sp,sp,48
    80005fbc:	8082                	ret
    for(;;)
    80005fbe:	a001                	j	80005fbe <uartputc+0xb4>

0000000080005fc0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005fc0:	1141                	addi	sp,sp,-16
    80005fc2:	e422                	sd	s0,8(sp)
    80005fc4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005fc6:	100007b7          	lui	a5,0x10000
    80005fca:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005fce:	8b85                	andi	a5,a5,1
    80005fd0:	cb81                	beqz	a5,80005fe0 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80005fd2:	100007b7          	lui	a5,0x10000
    80005fd6:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005fda:	6422                	ld	s0,8(sp)
    80005fdc:	0141                	addi	sp,sp,16
    80005fde:	8082                	ret
    return -1;
    80005fe0:	557d                	li	a0,-1
    80005fe2:	bfe5                	j	80005fda <uartgetc+0x1a>

0000000080005fe4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005fe4:	1101                	addi	sp,sp,-32
    80005fe6:	ec06                	sd	ra,24(sp)
    80005fe8:	e822                	sd	s0,16(sp)
    80005fea:	e426                	sd	s1,8(sp)
    80005fec:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005fee:	54fd                	li	s1,-1
    80005ff0:	a029                	j	80005ffa <uartintr+0x16>
      break;
    consoleintr(c);
    80005ff2:	00000097          	auipc	ra,0x0
    80005ff6:	918080e7          	jalr	-1768(ra) # 8000590a <consoleintr>
    int c = uartgetc();
    80005ffa:	00000097          	auipc	ra,0x0
    80005ffe:	fc6080e7          	jalr	-58(ra) # 80005fc0 <uartgetc>
    if(c == -1)
    80006002:	fe9518e3          	bne	a0,s1,80005ff2 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006006:	0001c497          	auipc	s1,0x1c
    8000600a:	d1248493          	addi	s1,s1,-750 # 80021d18 <uart_tx_lock>
    8000600e:	8526                	mv	a0,s1
    80006010:	00000097          	auipc	ra,0x0
    80006014:	0b4080e7          	jalr	180(ra) # 800060c4 <acquire>
  uartstart();
    80006018:	00000097          	auipc	ra,0x0
    8000601c:	e6c080e7          	jalr	-404(ra) # 80005e84 <uartstart>
  release(&uart_tx_lock);
    80006020:	8526                	mv	a0,s1
    80006022:	00000097          	auipc	ra,0x0
    80006026:	156080e7          	jalr	342(ra) # 80006178 <release>
}
    8000602a:	60e2                	ld	ra,24(sp)
    8000602c:	6442                	ld	s0,16(sp)
    8000602e:	64a2                	ld	s1,8(sp)
    80006030:	6105                	addi	sp,sp,32
    80006032:	8082                	ret

0000000080006034 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006034:	1141                	addi	sp,sp,-16
    80006036:	e422                	sd	s0,8(sp)
    80006038:	0800                	addi	s0,sp,16
  lk->name = name;
    8000603a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000603c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006040:	00053823          	sd	zero,16(a0)
}
    80006044:	6422                	ld	s0,8(sp)
    80006046:	0141                	addi	sp,sp,16
    80006048:	8082                	ret

000000008000604a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000604a:	411c                	lw	a5,0(a0)
    8000604c:	e399                	bnez	a5,80006052 <holding+0x8>
    8000604e:	4501                	li	a0,0
  return r;
}
    80006050:	8082                	ret
{
    80006052:	1101                	addi	sp,sp,-32
    80006054:	ec06                	sd	ra,24(sp)
    80006056:	e822                	sd	s0,16(sp)
    80006058:	e426                	sd	s1,8(sp)
    8000605a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000605c:	6904                	ld	s1,16(a0)
    8000605e:	ffffb097          	auipc	ra,0xffffb
    80006062:	dda080e7          	jalr	-550(ra) # 80000e38 <mycpu>
    80006066:	40a48533          	sub	a0,s1,a0
    8000606a:	00153513          	seqz	a0,a0
}
    8000606e:	60e2                	ld	ra,24(sp)
    80006070:	6442                	ld	s0,16(sp)
    80006072:	64a2                	ld	s1,8(sp)
    80006074:	6105                	addi	sp,sp,32
    80006076:	8082                	ret

0000000080006078 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006078:	1101                	addi	sp,sp,-32
    8000607a:	ec06                	sd	ra,24(sp)
    8000607c:	e822                	sd	s0,16(sp)
    8000607e:	e426                	sd	s1,8(sp)
    80006080:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006082:	100024f3          	csrr	s1,sstatus
    80006086:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000608a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000608c:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006090:	ffffb097          	auipc	ra,0xffffb
    80006094:	da8080e7          	jalr	-600(ra) # 80000e38 <mycpu>
    80006098:	5d3c                	lw	a5,120(a0)
    8000609a:	cf89                	beqz	a5,800060b4 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000609c:	ffffb097          	auipc	ra,0xffffb
    800060a0:	d9c080e7          	jalr	-612(ra) # 80000e38 <mycpu>
    800060a4:	5d3c                	lw	a5,120(a0)
    800060a6:	2785                	addiw	a5,a5,1
    800060a8:	dd3c                	sw	a5,120(a0)
}
    800060aa:	60e2                	ld	ra,24(sp)
    800060ac:	6442                	ld	s0,16(sp)
    800060ae:	64a2                	ld	s1,8(sp)
    800060b0:	6105                	addi	sp,sp,32
    800060b2:	8082                	ret
    mycpu()->intena = old;
    800060b4:	ffffb097          	auipc	ra,0xffffb
    800060b8:	d84080e7          	jalr	-636(ra) # 80000e38 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800060bc:	8085                	srli	s1,s1,0x1
    800060be:	8885                	andi	s1,s1,1
    800060c0:	dd64                	sw	s1,124(a0)
    800060c2:	bfe9                	j	8000609c <push_off+0x24>

00000000800060c4 <acquire>:
{
    800060c4:	1101                	addi	sp,sp,-32
    800060c6:	ec06                	sd	ra,24(sp)
    800060c8:	e822                	sd	s0,16(sp)
    800060ca:	e426                	sd	s1,8(sp)
    800060cc:	1000                	addi	s0,sp,32
    800060ce:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800060d0:	00000097          	auipc	ra,0x0
    800060d4:	fa8080e7          	jalr	-88(ra) # 80006078 <push_off>
  if(holding(lk))
    800060d8:	8526                	mv	a0,s1
    800060da:	00000097          	auipc	ra,0x0
    800060de:	f70080e7          	jalr	-144(ra) # 8000604a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800060e2:	4705                	li	a4,1
  if(holding(lk))
    800060e4:	e115                	bnez	a0,80006108 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800060e6:	87ba                	mv	a5,a4
    800060e8:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800060ec:	2781                	sext.w	a5,a5
    800060ee:	ffe5                	bnez	a5,800060e6 <acquire+0x22>
  __sync_synchronize();
    800060f0:	0ff0000f          	fence
  lk->cpu = mycpu();
    800060f4:	ffffb097          	auipc	ra,0xffffb
    800060f8:	d44080e7          	jalr	-700(ra) # 80000e38 <mycpu>
    800060fc:	e888                	sd	a0,16(s1)
}
    800060fe:	60e2                	ld	ra,24(sp)
    80006100:	6442                	ld	s0,16(sp)
    80006102:	64a2                	ld	s1,8(sp)
    80006104:	6105                	addi	sp,sp,32
    80006106:	8082                	ret
    panic("acquire");
    80006108:	00002517          	auipc	a0,0x2
    8000610c:	70850513          	addi	a0,a0,1800 # 80008810 <digits+0x20>
    80006110:	00000097          	auipc	ra,0x0
    80006114:	a7c080e7          	jalr	-1412(ra) # 80005b8c <panic>

0000000080006118 <pop_off>:

void
pop_off(void)
{
    80006118:	1141                	addi	sp,sp,-16
    8000611a:	e406                	sd	ra,8(sp)
    8000611c:	e022                	sd	s0,0(sp)
    8000611e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006120:	ffffb097          	auipc	ra,0xffffb
    80006124:	d18080e7          	jalr	-744(ra) # 80000e38 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006128:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000612c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000612e:	e78d                	bnez	a5,80006158 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006130:	5d3c                	lw	a5,120(a0)
    80006132:	02f05b63          	blez	a5,80006168 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006136:	37fd                	addiw	a5,a5,-1
    80006138:	0007871b          	sext.w	a4,a5
    8000613c:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000613e:	eb09                	bnez	a4,80006150 <pop_off+0x38>
    80006140:	5d7c                	lw	a5,124(a0)
    80006142:	c799                	beqz	a5,80006150 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006144:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006148:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000614c:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006150:	60a2                	ld	ra,8(sp)
    80006152:	6402                	ld	s0,0(sp)
    80006154:	0141                	addi	sp,sp,16
    80006156:	8082                	ret
    panic("pop_off - interruptible");
    80006158:	00002517          	auipc	a0,0x2
    8000615c:	6c050513          	addi	a0,a0,1728 # 80008818 <digits+0x28>
    80006160:	00000097          	auipc	ra,0x0
    80006164:	a2c080e7          	jalr	-1492(ra) # 80005b8c <panic>
    panic("pop_off");
    80006168:	00002517          	auipc	a0,0x2
    8000616c:	6c850513          	addi	a0,a0,1736 # 80008830 <digits+0x40>
    80006170:	00000097          	auipc	ra,0x0
    80006174:	a1c080e7          	jalr	-1508(ra) # 80005b8c <panic>

0000000080006178 <release>:
{
    80006178:	1101                	addi	sp,sp,-32
    8000617a:	ec06                	sd	ra,24(sp)
    8000617c:	e822                	sd	s0,16(sp)
    8000617e:	e426                	sd	s1,8(sp)
    80006180:	1000                	addi	s0,sp,32
    80006182:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006184:	00000097          	auipc	ra,0x0
    80006188:	ec6080e7          	jalr	-314(ra) # 8000604a <holding>
    8000618c:	c115                	beqz	a0,800061b0 <release+0x38>
  lk->cpu = 0;
    8000618e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006192:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006196:	0f50000f          	fence	iorw,ow
    8000619a:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000619e:	00000097          	auipc	ra,0x0
    800061a2:	f7a080e7          	jalr	-134(ra) # 80006118 <pop_off>
}
    800061a6:	60e2                	ld	ra,24(sp)
    800061a8:	6442                	ld	s0,16(sp)
    800061aa:	64a2                	ld	s1,8(sp)
    800061ac:	6105                	addi	sp,sp,32
    800061ae:	8082                	ret
    panic("release");
    800061b0:	00002517          	auipc	a0,0x2
    800061b4:	68850513          	addi	a0,a0,1672 # 80008838 <digits+0x48>
    800061b8:	00000097          	auipc	ra,0x0
    800061bc:	9d4080e7          	jalr	-1580(ra) # 80005b8c <panic>
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
