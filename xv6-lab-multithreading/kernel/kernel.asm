
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
    80000016:	6d2050ef          	jal	ra,800056e8 <start>

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
    8000005e:	07a080e7          	jalr	122(ra) # 800060d4 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	11a080e7          	jalr	282(ra) # 80006188 <release>
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
    8000008e:	b12080e7          	jalr	-1262(ra) # 80005b9c <panic>

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
    800000fa:	f4e080e7          	jalr	-178(ra) # 80006044 <initlock>
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
    80000132:	fa6080e7          	jalr	-90(ra) # 800060d4 <acquire>
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
    8000014a:	042080e7          	jalr	66(ra) # 80006188 <release>

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
    80000174:	018080e7          	jalr	24(ra) # 80006188 <release>
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
    8000035a:	890080e7          	jalr	-1904(ra) # 80005be6 <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00001097          	auipc	ra,0x1
    8000036a:	78c080e7          	jalr	1932(ra) # 80001af2 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	d32080e7          	jalr	-718(ra) # 800050a0 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	fd4080e7          	jalr	-44(ra) # 8000134a <scheduler>
    consoleinit();
    8000037e:	00005097          	auipc	ra,0x5
    80000382:	72e080e7          	jalr	1838(ra) # 80005aac <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	a40080e7          	jalr	-1472(ra) # 80005dc6 <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	850080e7          	jalr	-1968(ra) # 80005be6 <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	840080e7          	jalr	-1984(ra) # 80005be6 <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	830080e7          	jalr	-2000(ra) # 80005be6 <printf>
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
    800003f2:	c9c080e7          	jalr	-868(ra) # 8000508a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	caa080e7          	jalr	-854(ra) # 800050a0 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	e3e080e7          	jalr	-450(ra) # 8000223c <binit>
    iinit();         // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	4de080e7          	jalr	1246(ra) # 800028e4 <iinit>
    fileinit();      // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	484080e7          	jalr	1156(ra) # 80003892 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	d92080e7          	jalr	-622(ra) # 800051a8 <virtio_disk_init>
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
    80000490:	710080e7          	jalr	1808(ra) # 80005b9c <panic>
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
    800005b6:	5ea080e7          	jalr	1514(ra) # 80005b9c <panic>
      panic("mappages: remap");
    800005ba:	00008517          	auipc	a0,0x8
    800005be:	aae50513          	addi	a0,a0,-1362 # 80008068 <etext+0x68>
    800005c2:	00005097          	auipc	ra,0x5
    800005c6:	5da080e7          	jalr	1498(ra) # 80005b9c <panic>
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
    80000612:	58e080e7          	jalr	1422(ra) # 80005b9c <panic>

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
    8000075e:	442080e7          	jalr	1090(ra) # 80005b9c <panic>
      panic("uvmunmap: walk");
    80000762:	00008517          	auipc	a0,0x8
    80000766:	93650513          	addi	a0,a0,-1738 # 80008098 <etext+0x98>
    8000076a:	00005097          	auipc	ra,0x5
    8000076e:	432080e7          	jalr	1074(ra) # 80005b9c <panic>
      panic("uvmunmap: not mapped");
    80000772:	00008517          	auipc	a0,0x8
    80000776:	93650513          	addi	a0,a0,-1738 # 800080a8 <etext+0xa8>
    8000077a:	00005097          	auipc	ra,0x5
    8000077e:	422080e7          	jalr	1058(ra) # 80005b9c <panic>
      panic("uvmunmap: not a leaf");
    80000782:	00008517          	auipc	a0,0x8
    80000786:	93e50513          	addi	a0,a0,-1730 # 800080c0 <etext+0xc0>
    8000078a:	00005097          	auipc	ra,0x5
    8000078e:	412080e7          	jalr	1042(ra) # 80005b9c <panic>
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
    8000086c:	334080e7          	jalr	820(ra) # 80005b9c <panic>

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
    800009b8:	1e8080e7          	jalr	488(ra) # 80005b9c <panic>
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
    80000a96:	10a080e7          	jalr	266(ra) # 80005b9c <panic>
      panic("uvmcopy: page not present");
    80000a9a:	00007517          	auipc	a0,0x7
    80000a9e:	68e50513          	addi	a0,a0,1678 # 80008128 <etext+0x128>
    80000aa2:	00005097          	auipc	ra,0x5
    80000aa6:	0fa080e7          	jalr	250(ra) # 80005b9c <panic>
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
    80000b10:	090080e7          	jalr	144(ra) # 80005b9c <panic>

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
    80000d70:	e30080e7          	jalr	-464(ra) # 80005b9c <panic>

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
    80000d9c:	2ac080e7          	jalr	684(ra) # 80006044 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000da0:	00007597          	auipc	a1,0x7
    80000da4:	3c858593          	addi	a1,a1,968 # 80008168 <etext+0x168>
    80000da8:	00008517          	auipc	a0,0x8
    80000dac:	b7050513          	addi	a0,a0,-1168 # 80008918 <wait_lock>
    80000db0:	00005097          	auipc	ra,0x5
    80000db4:	294080e7          	jalr	660(ra) # 80006044 <initlock>
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
    80000dea:	25e080e7          	jalr	606(ra) # 80006044 <initlock>
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
    80000e62:	22a080e7          	jalr	554(ra) # 80006088 <push_off>
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
    80000e7c:	2b0080e7          	jalr	688(ra) # 80006128 <pop_off>
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
    80000ea0:	2ec080e7          	jalr	748(ra) # 80006188 <release>

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
    80000ecc:	99c080e7          	jalr	-1636(ra) # 80002864 <fsinit>
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
    80000eec:	1ec080e7          	jalr	492(ra) # 800060d4 <acquire>
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
    80000f06:	286080e7          	jalr	646(ra) # 80006188 <release>
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
    80001080:	058080e7          	jalr	88(ra) # 800060d4 <acquire>
    if(p->state == UNUSED) {
    80001084:	4c9c                	lw	a5,24(s1)
    80001086:	cf81                	beqz	a5,8000109e <allocproc+0x40>
      release(&p->lock);
    80001088:	8526                	mv	a0,s1
    8000108a:	00005097          	auipc	ra,0x5
    8000108e:	0fe080e7          	jalr	254(ra) # 80006188 <release>
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
    8000110c:	080080e7          	jalr	128(ra) # 80006188 <release>
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
    80001124:	068080e7          	jalr	104(ra) # 80006188 <release>
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
    8000118e:	104080e7          	jalr	260(ra) # 8000328e <namei>
    80001192:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001196:	478d                	li	a5,3
    80001198:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000119a:	8526                	mv	a0,s1
    8000119c:	00005097          	auipc	ra,0x5
    800011a0:	fec080e7          	jalr	-20(ra) # 80006188 <release>
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
    800012a6:	ee6080e7          	jalr	-282(ra) # 80006188 <release>
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
    800012be:	66a080e7          	jalr	1642(ra) # 80003924 <filedup>
    800012c2:	00a93023          	sd	a0,0(s2)
    800012c6:	b7e5                	j	800012ae <fork+0xa4>
  np->cwd = idup(p->cwd);
    800012c8:	150ab503          	ld	a0,336(s5)
    800012cc:	00001097          	auipc	ra,0x1
    800012d0:	7d8080e7          	jalr	2008(ra) # 80002aa4 <idup>
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
    800012f4:	e98080e7          	jalr	-360(ra) # 80006188 <release>
  acquire(&wait_lock);
    800012f8:	00007497          	auipc	s1,0x7
    800012fc:	62048493          	addi	s1,s1,1568 # 80008918 <wait_lock>
    80001300:	8526                	mv	a0,s1
    80001302:	00005097          	auipc	ra,0x5
    80001306:	dd2080e7          	jalr	-558(ra) # 800060d4 <acquire>
  np->parent = p;
    8000130a:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000130e:	8526                	mv	a0,s1
    80001310:	00005097          	auipc	ra,0x5
    80001314:	e78080e7          	jalr	-392(ra) # 80006188 <release>
  acquire(&np->lock);
    80001318:	8552                	mv	a0,s4
    8000131a:	00005097          	auipc	ra,0x5
    8000131e:	dba080e7          	jalr	-582(ra) # 800060d4 <acquire>
  np->state = RUNNABLE;
    80001322:	478d                	li	a5,3
    80001324:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001328:	8552                	mv	a0,s4
    8000132a:	00005097          	auipc	ra,0x5
    8000132e:	e5e080e7          	jalr	-418(ra) # 80006188 <release>
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
    800013b2:	dda080e7          	jalr	-550(ra) # 80006188 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013b6:	16848493          	addi	s1,s1,360
    800013ba:	fd248ee3          	beq	s1,s2,80001396 <scheduler+0x4c>
      acquire(&p->lock);
    800013be:	8526                	mv	a0,s1
    800013c0:	00005097          	auipc	ra,0x5
    800013c4:	d14080e7          	jalr	-748(ra) # 800060d4 <acquire>
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
    80001406:	c58080e7          	jalr	-936(ra) # 8000605a <holding>
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
    8000148c:	714080e7          	jalr	1812(ra) # 80005b9c <panic>
    panic("sched locks");
    80001490:	00007517          	auipc	a0,0x7
    80001494:	d1850513          	addi	a0,a0,-744 # 800081a8 <etext+0x1a8>
    80001498:	00004097          	auipc	ra,0x4
    8000149c:	704080e7          	jalr	1796(ra) # 80005b9c <panic>
    panic("sched running");
    800014a0:	00007517          	auipc	a0,0x7
    800014a4:	d1850513          	addi	a0,a0,-744 # 800081b8 <etext+0x1b8>
    800014a8:	00004097          	auipc	ra,0x4
    800014ac:	6f4080e7          	jalr	1780(ra) # 80005b9c <panic>
    panic("sched interruptible");
    800014b0:	00007517          	auipc	a0,0x7
    800014b4:	d1850513          	addi	a0,a0,-744 # 800081c8 <etext+0x1c8>
    800014b8:	00004097          	auipc	ra,0x4
    800014bc:	6e4080e7          	jalr	1764(ra) # 80005b9c <panic>

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
    800014d8:	c00080e7          	jalr	-1024(ra) # 800060d4 <acquire>
  p->state = RUNNABLE;
    800014dc:	478d                	li	a5,3
    800014de:	cc9c                	sw	a5,24(s1)
  sched();
    800014e0:	00000097          	auipc	ra,0x0
    800014e4:	f0a080e7          	jalr	-246(ra) # 800013ea <sched>
  release(&p->lock);
    800014e8:	8526                	mv	a0,s1
    800014ea:	00005097          	auipc	ra,0x5
    800014ee:	c9e080e7          	jalr	-866(ra) # 80006188 <release>
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
    8000151c:	bbc080e7          	jalr	-1092(ra) # 800060d4 <acquire>
  release(lk);
    80001520:	854a                	mv	a0,s2
    80001522:	00005097          	auipc	ra,0x5
    80001526:	c66080e7          	jalr	-922(ra) # 80006188 <release>

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
    80001544:	c48080e7          	jalr	-952(ra) # 80006188 <release>
  acquire(lk);
    80001548:	854a                	mv	a0,s2
    8000154a:	00005097          	auipc	ra,0x5
    8000154e:	b8a080e7          	jalr	-1142(ra) # 800060d4 <acquire>
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
    80001590:	bfc080e7          	jalr	-1028(ra) # 80006188 <release>
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
    800015ae:	b2a080e7          	jalr	-1238(ra) # 800060d4 <acquire>
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
    8000166c:	534080e7          	jalr	1332(ra) # 80005b9c <panic>
      fileclose(f);
    80001670:	00002097          	auipc	ra,0x2
    80001674:	306080e7          	jalr	774(ra) # 80003976 <fileclose>
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
    8000168c:	e26080e7          	jalr	-474(ra) # 800034ae <begin_op>
  iput(p->cwd);
    80001690:	1509b503          	ld	a0,336(s3)
    80001694:	00001097          	auipc	ra,0x1
    80001698:	608080e7          	jalr	1544(ra) # 80002c9c <iput>
  end_op();
    8000169c:	00002097          	auipc	ra,0x2
    800016a0:	e90080e7          	jalr	-368(ra) # 8000352c <end_op>
  p->cwd = 0;
    800016a4:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800016a8:	00007497          	auipc	s1,0x7
    800016ac:	27048493          	addi	s1,s1,624 # 80008918 <wait_lock>
    800016b0:	8526                	mv	a0,s1
    800016b2:	00005097          	auipc	ra,0x5
    800016b6:	a22080e7          	jalr	-1502(ra) # 800060d4 <acquire>
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
    800016d6:	a02080e7          	jalr	-1534(ra) # 800060d4 <acquire>
  p->xstate = status;
    800016da:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800016de:	4795                	li	a5,5
    800016e0:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800016e4:	8526                	mv	a0,s1
    800016e6:	00005097          	auipc	ra,0x5
    800016ea:	aa2080e7          	jalr	-1374(ra) # 80006188 <release>
  sched();
    800016ee:	00000097          	auipc	ra,0x0
    800016f2:	cfc080e7          	jalr	-772(ra) # 800013ea <sched>
  panic("zombie exit");
    800016f6:	00007517          	auipc	a0,0x7
    800016fa:	afa50513          	addi	a0,a0,-1286 # 800081f0 <etext+0x1f0>
    800016fe:	00004097          	auipc	ra,0x4
    80001702:	49e080e7          	jalr	1182(ra) # 80005b9c <panic>

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
    8000172c:	9ac080e7          	jalr	-1620(ra) # 800060d4 <acquire>
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
    8000173c:	a50080e7          	jalr	-1456(ra) # 80006188 <release>
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
    8000175e:	a2e080e7          	jalr	-1490(ra) # 80006188 <release>
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
    80001788:	950080e7          	jalr	-1712(ra) # 800060d4 <acquire>
  p->killed = 1;
    8000178c:	4785                	li	a5,1
    8000178e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001790:	8526                	mv	a0,s1
    80001792:	00005097          	auipc	ra,0x5
    80001796:	9f6080e7          	jalr	-1546(ra) # 80006188 <release>
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
    800017b6:	922080e7          	jalr	-1758(ra) # 800060d4 <acquire>
  k = p->killed;
    800017ba:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017be:	8526                	mv	a0,s1
    800017c0:	00005097          	auipc	ra,0x5
    800017c4:	9c8080e7          	jalr	-1592(ra) # 80006188 <release>
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
    80001806:	8d2080e7          	jalr	-1838(ra) # 800060d4 <acquire>
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
    8000185c:	930080e7          	jalr	-1744(ra) # 80006188 <release>
          release(&wait_lock);
    80001860:	00007517          	auipc	a0,0x7
    80001864:	0b850513          	addi	a0,a0,184 # 80008918 <wait_lock>
    80001868:	00005097          	auipc	ra,0x5
    8000186c:	920080e7          	jalr	-1760(ra) # 80006188 <release>
          return pid;
    80001870:	a0b5                	j	800018dc <wait+0x106>
            release(&pp->lock);
    80001872:	8526                	mv	a0,s1
    80001874:	00005097          	auipc	ra,0x5
    80001878:	914080e7          	jalr	-1772(ra) # 80006188 <release>
            release(&wait_lock);
    8000187c:	00007517          	auipc	a0,0x7
    80001880:	09c50513          	addi	a0,a0,156 # 80008918 <wait_lock>
    80001884:	00005097          	auipc	ra,0x5
    80001888:	904080e7          	jalr	-1788(ra) # 80006188 <release>
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
    800018a4:	834080e7          	jalr	-1996(ra) # 800060d4 <acquire>
        if(pp->state == ZOMBIE){
    800018a8:	4c9c                	lw	a5,24(s1)
    800018aa:	f94781e3          	beq	a5,s4,8000182c <wait+0x56>
        release(&pp->lock);
    800018ae:	8526                	mv	a0,s1
    800018b0:	00005097          	auipc	ra,0x5
    800018b4:	8d8080e7          	jalr	-1832(ra) # 80006188 <release>
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
    800018d6:	8b6080e7          	jalr	-1866(ra) # 80006188 <release>
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
    800019d2:	218080e7          	jalr	536(ra) # 80005be6 <printf>
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
    80001a14:	1d6080e7          	jalr	470(ra) # 80005be6 <printf>
    printf("\n");
    80001a18:	8552                	mv	a0,s4
    80001a1a:	00004097          	auipc	ra,0x4
    80001a1e:	1cc080e7          	jalr	460(ra) # 80005be6 <printf>
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
    80001ae6:	562080e7          	jalr	1378(ra) # 80006044 <initlock>
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
    80001afc:	4d878793          	addi	a5,a5,1240 # 80004fd0 <kernelvec>
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
    80001bb8:	520080e7          	jalr	1312(ra) # 800060d4 <acquire>
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
    80001bd8:	5b4080e7          	jalr	1460(ra) # 80006188 <release>
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
    80001c1c:	4c0080e7          	jalr	1216(ra) # 800050d8 <plic_claim>
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
    80001c40:	faa080e7          	jalr	-86(ra) # 80005be6 <printf>
      plic_complete(irq);
    80001c44:	8526                	mv	a0,s1
    80001c46:	00003097          	auipc	ra,0x3
    80001c4a:	4b6080e7          	jalr	1206(ra) # 800050fc <plic_complete>
    return 1;
    80001c4e:	4505                	li	a0,1
    80001c50:	bf55                	j	80001c04 <devintr+0x1e>
      uartintr();
    80001c52:	00004097          	auipc	ra,0x4
    80001c56:	3a2080e7          	jalr	930(ra) # 80005ff4 <uartintr>
    80001c5a:	b7ed                	j	80001c44 <devintr+0x5e>
      virtio_disk_intr();
    80001c5c:	00004097          	auipc	ra,0x4
    80001c60:	968080e7          	jalr	-1688(ra) # 800055c4 <virtio_disk_intr>
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
    80001ca2:	33278793          	addi	a5,a5,818 # 80004fd0 <kernelvec>
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
    80001cec:	eb4080e7          	jalr	-332(ra) # 80005b9c <panic>
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
    80001d66:	e84080e7          	jalr	-380(ra) # 80005be6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d6a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d6e:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d72:	00006517          	auipc	a0,0x6
    80001d76:	57e50513          	addi	a0,a0,1406 # 800082f0 <states.0+0xa8>
    80001d7a:	00004097          	auipc	ra,0x4
    80001d7e:	e6c080e7          	jalr	-404(ra) # 80005be6 <printf>
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
    80001df2:	dae080e7          	jalr	-594(ra) # 80005b9c <panic>
    panic("kerneltrap: interrupts enabled");
    80001df6:	00006517          	auipc	a0,0x6
    80001dfa:	54250513          	addi	a0,a0,1346 # 80008338 <states.0+0xf0>
    80001dfe:	00004097          	auipc	ra,0x4
    80001e02:	d9e080e7          	jalr	-610(ra) # 80005b9c <panic>
    printf("scause %p\n", scause);
    80001e06:	85ce                	mv	a1,s3
    80001e08:	00006517          	auipc	a0,0x6
    80001e0c:	55050513          	addi	a0,a0,1360 # 80008358 <states.0+0x110>
    80001e10:	00004097          	auipc	ra,0x4
    80001e14:	dd6080e7          	jalr	-554(ra) # 80005be6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e18:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e1c:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e20:	00006517          	auipc	a0,0x6
    80001e24:	54850513          	addi	a0,a0,1352 # 80008368 <states.0+0x120>
    80001e28:	00004097          	auipc	ra,0x4
    80001e2c:	dbe080e7          	jalr	-578(ra) # 80005be6 <printf>
    panic("kerneltrap");
    80001e30:	00006517          	auipc	a0,0x6
    80001e34:	55050513          	addi	a0,a0,1360 # 80008380 <states.0+0x138>
    80001e38:	00004097          	auipc	ra,0x4
    80001e3c:	d64080e7          	jalr	-668(ra) # 80005b9c <panic>
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
    80001ec8:	cd8080e7          	jalr	-808(ra) # 80005b9c <panic>

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
    80002038:	bb2080e7          	jalr	-1102(ra) # 80005be6 <printf>
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
  if(n < 0)
    80002134:	fcc42783          	lw	a5,-52(s0)
    80002138:	0607cf63          	bltz	a5,800021b6 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    8000213c:	0000c517          	auipc	a0,0xc
    80002140:	5f450513          	addi	a0,a0,1524 # 8000e730 <tickslock>
    80002144:	00004097          	auipc	ra,0x4
    80002148:	f90080e7          	jalr	-112(ra) # 800060d4 <acquire>
  ticks0 = ticks;
    8000214c:	00006917          	auipc	s2,0x6
    80002150:	77c92903          	lw	s2,1916(s2) # 800088c8 <ticks>
  while(ticks - ticks0 < n){
    80002154:	fcc42783          	lw	a5,-52(s0)
    80002158:	cf9d                	beqz	a5,80002196 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000215a:	0000c997          	auipc	s3,0xc
    8000215e:	5d698993          	addi	s3,s3,1494 # 8000e730 <tickslock>
    80002162:	00006497          	auipc	s1,0x6
    80002166:	76648493          	addi	s1,s1,1894 # 800088c8 <ticks>
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
    80002196:	0000c517          	auipc	a0,0xc
    8000219a:	59a50513          	addi	a0,a0,1434 # 8000e730 <tickslock>
    8000219e:	00004097          	auipc	ra,0x4
    800021a2:	fea080e7          	jalr	-22(ra) # 80006188 <release>
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
    800021bc:	0000c517          	auipc	a0,0xc
    800021c0:	57450513          	addi	a0,a0,1396 # 8000e730 <tickslock>
    800021c4:	00004097          	auipc	ra,0x4
    800021c8:	fc4080e7          	jalr	-60(ra) # 80006188 <release>
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
    80002204:	0000c517          	auipc	a0,0xc
    80002208:	52c50513          	addi	a0,a0,1324 # 8000e730 <tickslock>
    8000220c:	00004097          	auipc	ra,0x4
    80002210:	ec8080e7          	jalr	-312(ra) # 800060d4 <acquire>
  xticks = ticks;
    80002214:	00006497          	auipc	s1,0x6
    80002218:	6b44a483          	lw	s1,1716(s1) # 800088c8 <ticks>
  release(&tickslock);
    8000221c:	0000c517          	auipc	a0,0xc
    80002220:	51450513          	addi	a0,a0,1300 # 8000e730 <tickslock>
    80002224:	00004097          	auipc	ra,0x4
    80002228:	f64080e7          	jalr	-156(ra) # 80006188 <release>
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
    80002250:	23458593          	addi	a1,a1,564 # 80008480 <syscalls+0xb0>
    80002254:	0000c517          	auipc	a0,0xc
    80002258:	4f450513          	addi	a0,a0,1268 # 8000e748 <bcache>
    8000225c:	00004097          	auipc	ra,0x4
    80002260:	de8080e7          	jalr	-536(ra) # 80006044 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002264:	00014797          	auipc	a5,0x14
    80002268:	4e478793          	addi	a5,a5,1252 # 80016748 <bcache+0x8000>
    8000226c:	00014717          	auipc	a4,0x14
    80002270:	74470713          	addi	a4,a4,1860 # 800169b0 <bcache+0x8268>
    80002274:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002278:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000227c:	0000c497          	auipc	s1,0xc
    80002280:	4e448493          	addi	s1,s1,1252 # 8000e760 <bcache+0x18>
    b->next = bcache.head.next;
    80002284:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002286:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002288:	00006a17          	auipc	s4,0x6
    8000228c:	200a0a13          	addi	s4,s4,512 # 80008488 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002290:	2b893783          	ld	a5,696(s2)
    80002294:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002296:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000229a:	85d2                	mv	a1,s4
    8000229c:	01048513          	addi	a0,s1,16
    800022a0:	00001097          	auipc	ra,0x1
    800022a4:	4c8080e7          	jalr	1224(ra) # 80003768 <initsleeplock>
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
    800022dc:	0000c517          	auipc	a0,0xc
    800022e0:	46c50513          	addi	a0,a0,1132 # 8000e748 <bcache>
    800022e4:	00004097          	auipc	ra,0x4
    800022e8:	df0080e7          	jalr	-528(ra) # 800060d4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022ec:	00014497          	auipc	s1,0x14
    800022f0:	7144b483          	ld	s1,1812(s1) # 80016a00 <bcache+0x82b8>
    800022f4:	00014797          	auipc	a5,0x14
    800022f8:	6bc78793          	addi	a5,a5,1724 # 800169b0 <bcache+0x8268>
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
    8000231c:	0000c517          	auipc	a0,0xc
    80002320:	42c50513          	addi	a0,a0,1068 # 8000e748 <bcache>
    80002324:	00004097          	auipc	ra,0x4
    80002328:	e64080e7          	jalr	-412(ra) # 80006188 <release>
      acquiresleep(&b->lock);
    8000232c:	01048513          	addi	a0,s1,16
    80002330:	00001097          	auipc	ra,0x1
    80002334:	472080e7          	jalr	1138(ra) # 800037a2 <acquiresleep>
      return b;
    80002338:	a8b9                	j	80002396 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000233a:	00014497          	auipc	s1,0x14
    8000233e:	6be4b483          	ld	s1,1726(s1) # 800169f8 <bcache+0x82b0>
    80002342:	00014797          	auipc	a5,0x14
    80002346:	66e78793          	addi	a5,a5,1646 # 800169b0 <bcache+0x8268>
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
    8000235e:	13650513          	addi	a0,a0,310 # 80008490 <syscalls+0xc0>
    80002362:	00004097          	auipc	ra,0x4
    80002366:	83a080e7          	jalr	-1990(ra) # 80005b9c <panic>
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
    8000237a:	0000c517          	auipc	a0,0xc
    8000237e:	3ce50513          	addi	a0,a0,974 # 8000e748 <bcache>
    80002382:	00004097          	auipc	ra,0x4
    80002386:	e06080e7          	jalr	-506(ra) # 80006188 <release>
      acquiresleep(&b->lock);
    8000238a:	01048513          	addi	a0,s1,16
    8000238e:	00001097          	auipc	ra,0x1
    80002392:	414080e7          	jalr	1044(ra) # 800037a2 <acquiresleep>
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
    800023b2:	fe4080e7          	jalr	-28(ra) # 80005392 <virtio_disk_rw>
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
    800023ce:	472080e7          	jalr	1138(ra) # 8000383c <holdingsleep>
    800023d2:	cd01                	beqz	a0,800023ea <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023d4:	4585                	li	a1,1
    800023d6:	8526                	mv	a0,s1
    800023d8:	00003097          	auipc	ra,0x3
    800023dc:	fba080e7          	jalr	-70(ra) # 80005392 <virtio_disk_rw>
}
    800023e0:	60e2                	ld	ra,24(sp)
    800023e2:	6442                	ld	s0,16(sp)
    800023e4:	64a2                	ld	s1,8(sp)
    800023e6:	6105                	addi	sp,sp,32
    800023e8:	8082                	ret
    panic("bwrite");
    800023ea:	00006517          	auipc	a0,0x6
    800023ee:	0be50513          	addi	a0,a0,190 # 800084a8 <syscalls+0xd8>
    800023f2:	00003097          	auipc	ra,0x3
    800023f6:	7aa080e7          	jalr	1962(ra) # 80005b9c <panic>

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
    80002412:	42e080e7          	jalr	1070(ra) # 8000383c <holdingsleep>
    80002416:	c92d                	beqz	a0,80002488 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002418:	854a                	mv	a0,s2
    8000241a:	00001097          	auipc	ra,0x1
    8000241e:	3de080e7          	jalr	990(ra) # 800037f8 <releasesleep>

  acquire(&bcache.lock);
    80002422:	0000c517          	auipc	a0,0xc
    80002426:	32650513          	addi	a0,a0,806 # 8000e748 <bcache>
    8000242a:	00004097          	auipc	ra,0x4
    8000242e:	caa080e7          	jalr	-854(ra) # 800060d4 <acquire>
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
    8000244a:	00014797          	auipc	a5,0x14
    8000244e:	2fe78793          	addi	a5,a5,766 # 80016748 <bcache+0x8000>
    80002452:	2b87b703          	ld	a4,696(a5)
    80002456:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002458:	00014717          	auipc	a4,0x14
    8000245c:	55870713          	addi	a4,a4,1368 # 800169b0 <bcache+0x8268>
    80002460:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002462:	2b87b703          	ld	a4,696(a5)
    80002466:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002468:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000246c:	0000c517          	auipc	a0,0xc
    80002470:	2dc50513          	addi	a0,a0,732 # 8000e748 <bcache>
    80002474:	00004097          	auipc	ra,0x4
    80002478:	d14080e7          	jalr	-748(ra) # 80006188 <release>
}
    8000247c:	60e2                	ld	ra,24(sp)
    8000247e:	6442                	ld	s0,16(sp)
    80002480:	64a2                	ld	s1,8(sp)
    80002482:	6902                	ld	s2,0(sp)
    80002484:	6105                	addi	sp,sp,32
    80002486:	8082                	ret
    panic("brelse");
    80002488:	00006517          	auipc	a0,0x6
    8000248c:	02850513          	addi	a0,a0,40 # 800084b0 <syscalls+0xe0>
    80002490:	00003097          	auipc	ra,0x3
    80002494:	70c080e7          	jalr	1804(ra) # 80005b9c <panic>

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
    800024a4:	0000c517          	auipc	a0,0xc
    800024a8:	2a450513          	addi	a0,a0,676 # 8000e748 <bcache>
    800024ac:	00004097          	auipc	ra,0x4
    800024b0:	c28080e7          	jalr	-984(ra) # 800060d4 <acquire>
  b->refcnt++;
    800024b4:	40bc                	lw	a5,64(s1)
    800024b6:	2785                	addiw	a5,a5,1
    800024b8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024ba:	0000c517          	auipc	a0,0xc
    800024be:	28e50513          	addi	a0,a0,654 # 8000e748 <bcache>
    800024c2:	00004097          	auipc	ra,0x4
    800024c6:	cc6080e7          	jalr	-826(ra) # 80006188 <release>
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
    800024e0:	0000c517          	auipc	a0,0xc
    800024e4:	26850513          	addi	a0,a0,616 # 8000e748 <bcache>
    800024e8:	00004097          	auipc	ra,0x4
    800024ec:	bec080e7          	jalr	-1044(ra) # 800060d4 <acquire>
  b->refcnt--;
    800024f0:	40bc                	lw	a5,64(s1)
    800024f2:	37fd                	addiw	a5,a5,-1
    800024f4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024f6:	0000c517          	auipc	a0,0xc
    800024fa:	25250513          	addi	a0,a0,594 # 8000e748 <bcache>
    800024fe:	00004097          	auipc	ra,0x4
    80002502:	c8a080e7          	jalr	-886(ra) # 80006188 <release>
}
    80002506:	60e2                	ld	ra,24(sp)
    80002508:	6442                	ld	s0,16(sp)
    8000250a:	64a2                	ld	s1,8(sp)
    8000250c:	6105                	addi	sp,sp,32
    8000250e:	8082                	ret

0000000080002510 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
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
    80002522:	00015797          	auipc	a5,0x15
    80002526:	9027a783          	lw	a5,-1790(a5) # 80016e24 <sb+0x1c>
    8000252a:	9dbd                	addw	a1,a1,a5
    8000252c:	00000097          	auipc	ra,0x0
    80002530:	d9e080e7          	jalr	-610(ra) # 800022ca <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002534:	0074f713          	andi	a4,s1,7
    80002538:	4785                	li	a5,1
    8000253a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000253e:	14ce                	slli	s1,s1,0x33
    80002540:	90d9                	srli	s1,s1,0x36
    80002542:	00950733          	add	a4,a0,s1
    80002546:	05874703          	lbu	a4,88(a4)
    8000254a:	00e7f6b3          	and	a3,a5,a4
    8000254e:	c69d                	beqz	a3,8000257c <bfree+0x6c>
    80002550:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002552:	94aa                	add	s1,s1,a0
    80002554:	fff7c793          	not	a5,a5
    80002558:	8f7d                	and	a4,a4,a5
    8000255a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000255e:	00001097          	auipc	ra,0x1
    80002562:	126080e7          	jalr	294(ra) # 80003684 <log_write>
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
    80002580:	f3c50513          	addi	a0,a0,-196 # 800084b8 <syscalls+0xe8>
    80002584:	00003097          	auipc	ra,0x3
    80002588:	618080e7          	jalr	1560(ra) # 80005b9c <panic>

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
  for(b = 0; b < sb.size; b += BPB){
    800025a6:	00015797          	auipc	a5,0x15
    800025aa:	8667a783          	lw	a5,-1946(a5) # 80016e0c <sb+0x4>
    800025ae:	cff5                	beqz	a5,800026aa <balloc+0x11e>
    800025b0:	8baa                	mv	s7,a0
    800025b2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800025b4:	00015b17          	auipc	s6,0x15
    800025b8:	854b0b13          	addi	s6,s6,-1964 # 80016e08 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025bc:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800025be:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025c0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800025c2:	6c89                	lui	s9,0x2
    800025c4:	a061                	j	8000264c <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    800025c6:	97ca                	add	a5,a5,s2
    800025c8:	8e55                	or	a2,a2,a3
    800025ca:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800025ce:	854a                	mv	a0,s2
    800025d0:	00001097          	auipc	ra,0x1
    800025d4:	0b4080e7          	jalr	180(ra) # 80003684 <log_write>
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
    80002608:	080080e7          	jalr	128(ra) # 80003684 <log_write>
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
  for(b = 0; b < sb.size; b += BPB){
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
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000266e:	004b2503          	lw	a0,4(s6)
    80002672:	000a849b          	sext.w	s1,s5
    80002676:	8762                	mv	a4,s8
    80002678:	faa4fde3          	bgeu	s1,a0,80002632 <balloc+0xa6>
      m = 1 << (bi % 8);
    8000267c:	00777693          	andi	a3,a4,7
    80002680:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002684:	41f7579b          	sraiw	a5,a4,0x1f
    80002688:	01d7d79b          	srliw	a5,a5,0x1d
    8000268c:	9fb9                	addw	a5,a5,a4
    8000268e:	4037d79b          	sraiw	a5,a5,0x3
    80002692:	00f90633          	add	a2,s2,a5
    80002696:	05864603          	lbu	a2,88(a2)
    8000269a:	00c6f5b3          	and	a1,a3,a2
    8000269e:	d585                	beqz	a1,800025c6 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026a0:	2705                	addiw	a4,a4,1
    800026a2:	2485                	addiw	s1,s1,1
    800026a4:	fd471ae3          	bne	a4,s4,80002678 <balloc+0xec>
    800026a8:	b769                	j	80002632 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    800026aa:	00006517          	auipc	a0,0x6
    800026ae:	e2650513          	addi	a0,a0,-474 # 800084d0 <syscalls+0x100>
    800026b2:	00003097          	auipc	ra,0x3
    800026b6:	534080e7          	jalr	1332(ra) # 80005be6 <printf>
  return 0;
    800026ba:	4481                	li	s1,0
    800026bc:	bfa9                	j	80002616 <balloc+0x8a>

00000000800026be <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800026be:	7179                	addi	sp,sp,-48
    800026c0:	f406                	sd	ra,40(sp)
    800026c2:	f022                	sd	s0,32(sp)
    800026c4:	ec26                	sd	s1,24(sp)
    800026c6:	e84a                	sd	s2,16(sp)
    800026c8:	e44e                	sd	s3,8(sp)
    800026ca:	e052                	sd	s4,0(sp)
    800026cc:	1800                	addi	s0,sp,48
    800026ce:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800026d0:	47ad                	li	a5,11
    800026d2:	02b7e863          	bltu	a5,a1,80002702 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    800026d6:	02059793          	slli	a5,a1,0x20
    800026da:	01e7d593          	srli	a1,a5,0x1e
    800026de:	00b504b3          	add	s1,a0,a1
    800026e2:	0504a903          	lw	s2,80(s1)
    800026e6:	06091e63          	bnez	s2,80002762 <bmap+0xa4>
      addr = balloc(ip->dev);
    800026ea:	4108                	lw	a0,0(a0)
    800026ec:	00000097          	auipc	ra,0x0
    800026f0:	ea0080e7          	jalr	-352(ra) # 8000258c <balloc>
    800026f4:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800026f8:	06090563          	beqz	s2,80002762 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    800026fc:	0524a823          	sw	s2,80(s1)
    80002700:	a08d                	j	80002762 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002702:	ff45849b          	addiw	s1,a1,-12
    80002706:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000270a:	0ff00793          	li	a5,255
    8000270e:	08e7e563          	bltu	a5,a4,80002798 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002712:	08052903          	lw	s2,128(a0)
    80002716:	00091d63          	bnez	s2,80002730 <bmap+0x72>
      addr = balloc(ip->dev);
    8000271a:	4108                	lw	a0,0(a0)
    8000271c:	00000097          	auipc	ra,0x0
    80002720:	e70080e7          	jalr	-400(ra) # 8000258c <balloc>
    80002724:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002728:	02090d63          	beqz	s2,80002762 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000272c:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002730:	85ca                	mv	a1,s2
    80002732:	0009a503          	lw	a0,0(s3)
    80002736:	00000097          	auipc	ra,0x0
    8000273a:	b94080e7          	jalr	-1132(ra) # 800022ca <bread>
    8000273e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002740:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002744:	02049713          	slli	a4,s1,0x20
    80002748:	01e75593          	srli	a1,a4,0x1e
    8000274c:	00b784b3          	add	s1,a5,a1
    80002750:	0004a903          	lw	s2,0(s1)
    80002754:	02090063          	beqz	s2,80002774 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002758:	8552                	mv	a0,s4
    8000275a:	00000097          	auipc	ra,0x0
    8000275e:	ca0080e7          	jalr	-864(ra) # 800023fa <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002762:	854a                	mv	a0,s2
    80002764:	70a2                	ld	ra,40(sp)
    80002766:	7402                	ld	s0,32(sp)
    80002768:	64e2                	ld	s1,24(sp)
    8000276a:	6942                	ld	s2,16(sp)
    8000276c:	69a2                	ld	s3,8(sp)
    8000276e:	6a02                	ld	s4,0(sp)
    80002770:	6145                	addi	sp,sp,48
    80002772:	8082                	ret
      addr = balloc(ip->dev);
    80002774:	0009a503          	lw	a0,0(s3)
    80002778:	00000097          	auipc	ra,0x0
    8000277c:	e14080e7          	jalr	-492(ra) # 8000258c <balloc>
    80002780:	0005091b          	sext.w	s2,a0
      if(addr){
    80002784:	fc090ae3          	beqz	s2,80002758 <bmap+0x9a>
        a[bn] = addr;
    80002788:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000278c:	8552                	mv	a0,s4
    8000278e:	00001097          	auipc	ra,0x1
    80002792:	ef6080e7          	jalr	-266(ra) # 80003684 <log_write>
    80002796:	b7c9                	j	80002758 <bmap+0x9a>
  panic("bmap: out of range");
    80002798:	00006517          	auipc	a0,0x6
    8000279c:	d5050513          	addi	a0,a0,-688 # 800084e8 <syscalls+0x118>
    800027a0:	00003097          	auipc	ra,0x3
    800027a4:	3fc080e7          	jalr	1020(ra) # 80005b9c <panic>

00000000800027a8 <iget>:
{
    800027a8:	7179                	addi	sp,sp,-48
    800027aa:	f406                	sd	ra,40(sp)
    800027ac:	f022                	sd	s0,32(sp)
    800027ae:	ec26                	sd	s1,24(sp)
    800027b0:	e84a                	sd	s2,16(sp)
    800027b2:	e44e                	sd	s3,8(sp)
    800027b4:	e052                	sd	s4,0(sp)
    800027b6:	1800                	addi	s0,sp,48
    800027b8:	89aa                	mv	s3,a0
    800027ba:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800027bc:	00014517          	auipc	a0,0x14
    800027c0:	66c50513          	addi	a0,a0,1644 # 80016e28 <itable>
    800027c4:	00004097          	auipc	ra,0x4
    800027c8:	910080e7          	jalr	-1776(ra) # 800060d4 <acquire>
  empty = 0;
    800027cc:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027ce:	00014497          	auipc	s1,0x14
    800027d2:	67248493          	addi	s1,s1,1650 # 80016e40 <itable+0x18>
    800027d6:	00016697          	auipc	a3,0x16
    800027da:	0fa68693          	addi	a3,a3,250 # 800188d0 <log>
    800027de:	a039                	j	800027ec <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027e0:	02090b63          	beqz	s2,80002816 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027e4:	08848493          	addi	s1,s1,136
    800027e8:	02d48a63          	beq	s1,a3,8000281c <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800027ec:	449c                	lw	a5,8(s1)
    800027ee:	fef059e3          	blez	a5,800027e0 <iget+0x38>
    800027f2:	4098                	lw	a4,0(s1)
    800027f4:	ff3716e3          	bne	a4,s3,800027e0 <iget+0x38>
    800027f8:	40d8                	lw	a4,4(s1)
    800027fa:	ff4713e3          	bne	a4,s4,800027e0 <iget+0x38>
      ip->ref++;
    800027fe:	2785                	addiw	a5,a5,1
    80002800:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002802:	00014517          	auipc	a0,0x14
    80002806:	62650513          	addi	a0,a0,1574 # 80016e28 <itable>
    8000280a:	00004097          	auipc	ra,0x4
    8000280e:	97e080e7          	jalr	-1666(ra) # 80006188 <release>
      return ip;
    80002812:	8926                	mv	s2,s1
    80002814:	a03d                	j	80002842 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002816:	f7f9                	bnez	a5,800027e4 <iget+0x3c>
    80002818:	8926                	mv	s2,s1
    8000281a:	b7e9                	j	800027e4 <iget+0x3c>
  if(empty == 0)
    8000281c:	02090c63          	beqz	s2,80002854 <iget+0xac>
  ip->dev = dev;
    80002820:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002824:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002828:	4785                	li	a5,1
    8000282a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000282e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002832:	00014517          	auipc	a0,0x14
    80002836:	5f650513          	addi	a0,a0,1526 # 80016e28 <itable>
    8000283a:	00004097          	auipc	ra,0x4
    8000283e:	94e080e7          	jalr	-1714(ra) # 80006188 <release>
}
    80002842:	854a                	mv	a0,s2
    80002844:	70a2                	ld	ra,40(sp)
    80002846:	7402                	ld	s0,32(sp)
    80002848:	64e2                	ld	s1,24(sp)
    8000284a:	6942                	ld	s2,16(sp)
    8000284c:	69a2                	ld	s3,8(sp)
    8000284e:	6a02                	ld	s4,0(sp)
    80002850:	6145                	addi	sp,sp,48
    80002852:	8082                	ret
    panic("iget: no inodes");
    80002854:	00006517          	auipc	a0,0x6
    80002858:	cac50513          	addi	a0,a0,-852 # 80008500 <syscalls+0x130>
    8000285c:	00003097          	auipc	ra,0x3
    80002860:	340080e7          	jalr	832(ra) # 80005b9c <panic>

0000000080002864 <fsinit>:
fsinit(int dev) {
    80002864:	7179                	addi	sp,sp,-48
    80002866:	f406                	sd	ra,40(sp)
    80002868:	f022                	sd	s0,32(sp)
    8000286a:	ec26                	sd	s1,24(sp)
    8000286c:	e84a                	sd	s2,16(sp)
    8000286e:	e44e                	sd	s3,8(sp)
    80002870:	1800                	addi	s0,sp,48
    80002872:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002874:	4585                	li	a1,1
    80002876:	00000097          	auipc	ra,0x0
    8000287a:	a54080e7          	jalr	-1452(ra) # 800022ca <bread>
    8000287e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002880:	00014997          	auipc	s3,0x14
    80002884:	58898993          	addi	s3,s3,1416 # 80016e08 <sb>
    80002888:	02000613          	li	a2,32
    8000288c:	05850593          	addi	a1,a0,88
    80002890:	854e                	mv	a0,s3
    80002892:	ffffe097          	auipc	ra,0xffffe
    80002896:	944080e7          	jalr	-1724(ra) # 800001d6 <memmove>
  brelse(bp);
    8000289a:	8526                	mv	a0,s1
    8000289c:	00000097          	auipc	ra,0x0
    800028a0:	b5e080e7          	jalr	-1186(ra) # 800023fa <brelse>
  if(sb.magic != FSMAGIC)
    800028a4:	0009a703          	lw	a4,0(s3)
    800028a8:	102037b7          	lui	a5,0x10203
    800028ac:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800028b0:	02f71263          	bne	a4,a5,800028d4 <fsinit+0x70>
  initlog(dev, &sb);
    800028b4:	00014597          	auipc	a1,0x14
    800028b8:	55458593          	addi	a1,a1,1364 # 80016e08 <sb>
    800028bc:	854a                	mv	a0,s2
    800028be:	00001097          	auipc	ra,0x1
    800028c2:	b4a080e7          	jalr	-1206(ra) # 80003408 <initlog>
}
    800028c6:	70a2                	ld	ra,40(sp)
    800028c8:	7402                	ld	s0,32(sp)
    800028ca:	64e2                	ld	s1,24(sp)
    800028cc:	6942                	ld	s2,16(sp)
    800028ce:	69a2                	ld	s3,8(sp)
    800028d0:	6145                	addi	sp,sp,48
    800028d2:	8082                	ret
    panic("invalid file system");
    800028d4:	00006517          	auipc	a0,0x6
    800028d8:	c3c50513          	addi	a0,a0,-964 # 80008510 <syscalls+0x140>
    800028dc:	00003097          	auipc	ra,0x3
    800028e0:	2c0080e7          	jalr	704(ra) # 80005b9c <panic>

00000000800028e4 <iinit>:
{
    800028e4:	7179                	addi	sp,sp,-48
    800028e6:	f406                	sd	ra,40(sp)
    800028e8:	f022                	sd	s0,32(sp)
    800028ea:	ec26                	sd	s1,24(sp)
    800028ec:	e84a                	sd	s2,16(sp)
    800028ee:	e44e                	sd	s3,8(sp)
    800028f0:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800028f2:	00006597          	auipc	a1,0x6
    800028f6:	c3658593          	addi	a1,a1,-970 # 80008528 <syscalls+0x158>
    800028fa:	00014517          	auipc	a0,0x14
    800028fe:	52e50513          	addi	a0,a0,1326 # 80016e28 <itable>
    80002902:	00003097          	auipc	ra,0x3
    80002906:	742080e7          	jalr	1858(ra) # 80006044 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000290a:	00014497          	auipc	s1,0x14
    8000290e:	54648493          	addi	s1,s1,1350 # 80016e50 <itable+0x28>
    80002912:	00016997          	auipc	s3,0x16
    80002916:	fce98993          	addi	s3,s3,-50 # 800188e0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000291a:	00006917          	auipc	s2,0x6
    8000291e:	c1690913          	addi	s2,s2,-1002 # 80008530 <syscalls+0x160>
    80002922:	85ca                	mv	a1,s2
    80002924:	8526                	mv	a0,s1
    80002926:	00001097          	auipc	ra,0x1
    8000292a:	e42080e7          	jalr	-446(ra) # 80003768 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000292e:	08848493          	addi	s1,s1,136
    80002932:	ff3498e3          	bne	s1,s3,80002922 <iinit+0x3e>
}
    80002936:	70a2                	ld	ra,40(sp)
    80002938:	7402                	ld	s0,32(sp)
    8000293a:	64e2                	ld	s1,24(sp)
    8000293c:	6942                	ld	s2,16(sp)
    8000293e:	69a2                	ld	s3,8(sp)
    80002940:	6145                	addi	sp,sp,48
    80002942:	8082                	ret

0000000080002944 <ialloc>:
{
    80002944:	715d                	addi	sp,sp,-80
    80002946:	e486                	sd	ra,72(sp)
    80002948:	e0a2                	sd	s0,64(sp)
    8000294a:	fc26                	sd	s1,56(sp)
    8000294c:	f84a                	sd	s2,48(sp)
    8000294e:	f44e                	sd	s3,40(sp)
    80002950:	f052                	sd	s4,32(sp)
    80002952:	ec56                	sd	s5,24(sp)
    80002954:	e85a                	sd	s6,16(sp)
    80002956:	e45e                	sd	s7,8(sp)
    80002958:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    8000295a:	00014717          	auipc	a4,0x14
    8000295e:	4ba72703          	lw	a4,1210(a4) # 80016e14 <sb+0xc>
    80002962:	4785                	li	a5,1
    80002964:	04e7fa63          	bgeu	a5,a4,800029b8 <ialloc+0x74>
    80002968:	8aaa                	mv	s5,a0
    8000296a:	8bae                	mv	s7,a1
    8000296c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000296e:	00014a17          	auipc	s4,0x14
    80002972:	49aa0a13          	addi	s4,s4,1178 # 80016e08 <sb>
    80002976:	00048b1b          	sext.w	s6,s1
    8000297a:	0044d593          	srli	a1,s1,0x4
    8000297e:	018a2783          	lw	a5,24(s4)
    80002982:	9dbd                	addw	a1,a1,a5
    80002984:	8556                	mv	a0,s5
    80002986:	00000097          	auipc	ra,0x0
    8000298a:	944080e7          	jalr	-1724(ra) # 800022ca <bread>
    8000298e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002990:	05850993          	addi	s3,a0,88
    80002994:	00f4f793          	andi	a5,s1,15
    80002998:	079a                	slli	a5,a5,0x6
    8000299a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000299c:	00099783          	lh	a5,0(s3)
    800029a0:	c3a1                	beqz	a5,800029e0 <ialloc+0x9c>
    brelse(bp);
    800029a2:	00000097          	auipc	ra,0x0
    800029a6:	a58080e7          	jalr	-1448(ra) # 800023fa <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800029aa:	0485                	addi	s1,s1,1
    800029ac:	00ca2703          	lw	a4,12(s4)
    800029b0:	0004879b          	sext.w	a5,s1
    800029b4:	fce7e1e3          	bltu	a5,a4,80002976 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    800029b8:	00006517          	auipc	a0,0x6
    800029bc:	b8050513          	addi	a0,a0,-1152 # 80008538 <syscalls+0x168>
    800029c0:	00003097          	auipc	ra,0x3
    800029c4:	226080e7          	jalr	550(ra) # 80005be6 <printf>
  return 0;
    800029c8:	4501                	li	a0,0
}
    800029ca:	60a6                	ld	ra,72(sp)
    800029cc:	6406                	ld	s0,64(sp)
    800029ce:	74e2                	ld	s1,56(sp)
    800029d0:	7942                	ld	s2,48(sp)
    800029d2:	79a2                	ld	s3,40(sp)
    800029d4:	7a02                	ld	s4,32(sp)
    800029d6:	6ae2                	ld	s5,24(sp)
    800029d8:	6b42                	ld	s6,16(sp)
    800029da:	6ba2                	ld	s7,8(sp)
    800029dc:	6161                	addi	sp,sp,80
    800029de:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800029e0:	04000613          	li	a2,64
    800029e4:	4581                	li	a1,0
    800029e6:	854e                	mv	a0,s3
    800029e8:	ffffd097          	auipc	ra,0xffffd
    800029ec:	792080e7          	jalr	1938(ra) # 8000017a <memset>
      dip->type = type;
    800029f0:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800029f4:	854a                	mv	a0,s2
    800029f6:	00001097          	auipc	ra,0x1
    800029fa:	c8e080e7          	jalr	-882(ra) # 80003684 <log_write>
      brelse(bp);
    800029fe:	854a                	mv	a0,s2
    80002a00:	00000097          	auipc	ra,0x0
    80002a04:	9fa080e7          	jalr	-1542(ra) # 800023fa <brelse>
      return iget(dev, inum);
    80002a08:	85da                	mv	a1,s6
    80002a0a:	8556                	mv	a0,s5
    80002a0c:	00000097          	auipc	ra,0x0
    80002a10:	d9c080e7          	jalr	-612(ra) # 800027a8 <iget>
    80002a14:	bf5d                	j	800029ca <ialloc+0x86>

0000000080002a16 <iupdate>:
{
    80002a16:	1101                	addi	sp,sp,-32
    80002a18:	ec06                	sd	ra,24(sp)
    80002a1a:	e822                	sd	s0,16(sp)
    80002a1c:	e426                	sd	s1,8(sp)
    80002a1e:	e04a                	sd	s2,0(sp)
    80002a20:	1000                	addi	s0,sp,32
    80002a22:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a24:	415c                	lw	a5,4(a0)
    80002a26:	0047d79b          	srliw	a5,a5,0x4
    80002a2a:	00014597          	auipc	a1,0x14
    80002a2e:	3f65a583          	lw	a1,1014(a1) # 80016e20 <sb+0x18>
    80002a32:	9dbd                	addw	a1,a1,a5
    80002a34:	4108                	lw	a0,0(a0)
    80002a36:	00000097          	auipc	ra,0x0
    80002a3a:	894080e7          	jalr	-1900(ra) # 800022ca <bread>
    80002a3e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a40:	05850793          	addi	a5,a0,88
    80002a44:	40d8                	lw	a4,4(s1)
    80002a46:	8b3d                	andi	a4,a4,15
    80002a48:	071a                	slli	a4,a4,0x6
    80002a4a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002a4c:	04449703          	lh	a4,68(s1)
    80002a50:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002a54:	04649703          	lh	a4,70(s1)
    80002a58:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002a5c:	04849703          	lh	a4,72(s1)
    80002a60:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002a64:	04a49703          	lh	a4,74(s1)
    80002a68:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002a6c:	44f8                	lw	a4,76(s1)
    80002a6e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002a70:	03400613          	li	a2,52
    80002a74:	05048593          	addi	a1,s1,80
    80002a78:	00c78513          	addi	a0,a5,12
    80002a7c:	ffffd097          	auipc	ra,0xffffd
    80002a80:	75a080e7          	jalr	1882(ra) # 800001d6 <memmove>
  log_write(bp);
    80002a84:	854a                	mv	a0,s2
    80002a86:	00001097          	auipc	ra,0x1
    80002a8a:	bfe080e7          	jalr	-1026(ra) # 80003684 <log_write>
  brelse(bp);
    80002a8e:	854a                	mv	a0,s2
    80002a90:	00000097          	auipc	ra,0x0
    80002a94:	96a080e7          	jalr	-1686(ra) # 800023fa <brelse>
}
    80002a98:	60e2                	ld	ra,24(sp)
    80002a9a:	6442                	ld	s0,16(sp)
    80002a9c:	64a2                	ld	s1,8(sp)
    80002a9e:	6902                	ld	s2,0(sp)
    80002aa0:	6105                	addi	sp,sp,32
    80002aa2:	8082                	ret

0000000080002aa4 <idup>:
{
    80002aa4:	1101                	addi	sp,sp,-32
    80002aa6:	ec06                	sd	ra,24(sp)
    80002aa8:	e822                	sd	s0,16(sp)
    80002aaa:	e426                	sd	s1,8(sp)
    80002aac:	1000                	addi	s0,sp,32
    80002aae:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ab0:	00014517          	auipc	a0,0x14
    80002ab4:	37850513          	addi	a0,a0,888 # 80016e28 <itable>
    80002ab8:	00003097          	auipc	ra,0x3
    80002abc:	61c080e7          	jalr	1564(ra) # 800060d4 <acquire>
  ip->ref++;
    80002ac0:	449c                	lw	a5,8(s1)
    80002ac2:	2785                	addiw	a5,a5,1
    80002ac4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ac6:	00014517          	auipc	a0,0x14
    80002aca:	36250513          	addi	a0,a0,866 # 80016e28 <itable>
    80002ace:	00003097          	auipc	ra,0x3
    80002ad2:	6ba080e7          	jalr	1722(ra) # 80006188 <release>
}
    80002ad6:	8526                	mv	a0,s1
    80002ad8:	60e2                	ld	ra,24(sp)
    80002ada:	6442                	ld	s0,16(sp)
    80002adc:	64a2                	ld	s1,8(sp)
    80002ade:	6105                	addi	sp,sp,32
    80002ae0:	8082                	ret

0000000080002ae2 <ilock>:
{
    80002ae2:	1101                	addi	sp,sp,-32
    80002ae4:	ec06                	sd	ra,24(sp)
    80002ae6:	e822                	sd	s0,16(sp)
    80002ae8:	e426                	sd	s1,8(sp)
    80002aea:	e04a                	sd	s2,0(sp)
    80002aec:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002aee:	c115                	beqz	a0,80002b12 <ilock+0x30>
    80002af0:	84aa                	mv	s1,a0
    80002af2:	451c                	lw	a5,8(a0)
    80002af4:	00f05f63          	blez	a5,80002b12 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002af8:	0541                	addi	a0,a0,16
    80002afa:	00001097          	auipc	ra,0x1
    80002afe:	ca8080e7          	jalr	-856(ra) # 800037a2 <acquiresleep>
  if(ip->valid == 0){
    80002b02:	40bc                	lw	a5,64(s1)
    80002b04:	cf99                	beqz	a5,80002b22 <ilock+0x40>
}
    80002b06:	60e2                	ld	ra,24(sp)
    80002b08:	6442                	ld	s0,16(sp)
    80002b0a:	64a2                	ld	s1,8(sp)
    80002b0c:	6902                	ld	s2,0(sp)
    80002b0e:	6105                	addi	sp,sp,32
    80002b10:	8082                	ret
    panic("ilock");
    80002b12:	00006517          	auipc	a0,0x6
    80002b16:	a3e50513          	addi	a0,a0,-1474 # 80008550 <syscalls+0x180>
    80002b1a:	00003097          	auipc	ra,0x3
    80002b1e:	082080e7          	jalr	130(ra) # 80005b9c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b22:	40dc                	lw	a5,4(s1)
    80002b24:	0047d79b          	srliw	a5,a5,0x4
    80002b28:	00014597          	auipc	a1,0x14
    80002b2c:	2f85a583          	lw	a1,760(a1) # 80016e20 <sb+0x18>
    80002b30:	9dbd                	addw	a1,a1,a5
    80002b32:	4088                	lw	a0,0(s1)
    80002b34:	fffff097          	auipc	ra,0xfffff
    80002b38:	796080e7          	jalr	1942(ra) # 800022ca <bread>
    80002b3c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b3e:	05850593          	addi	a1,a0,88
    80002b42:	40dc                	lw	a5,4(s1)
    80002b44:	8bbd                	andi	a5,a5,15
    80002b46:	079a                	slli	a5,a5,0x6
    80002b48:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b4a:	00059783          	lh	a5,0(a1)
    80002b4e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b52:	00259783          	lh	a5,2(a1)
    80002b56:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b5a:	00459783          	lh	a5,4(a1)
    80002b5e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002b62:	00659783          	lh	a5,6(a1)
    80002b66:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002b6a:	459c                	lw	a5,8(a1)
    80002b6c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002b6e:	03400613          	li	a2,52
    80002b72:	05b1                	addi	a1,a1,12
    80002b74:	05048513          	addi	a0,s1,80
    80002b78:	ffffd097          	auipc	ra,0xffffd
    80002b7c:	65e080e7          	jalr	1630(ra) # 800001d6 <memmove>
    brelse(bp);
    80002b80:	854a                	mv	a0,s2
    80002b82:	00000097          	auipc	ra,0x0
    80002b86:	878080e7          	jalr	-1928(ra) # 800023fa <brelse>
    ip->valid = 1;
    80002b8a:	4785                	li	a5,1
    80002b8c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002b8e:	04449783          	lh	a5,68(s1)
    80002b92:	fbb5                	bnez	a5,80002b06 <ilock+0x24>
      panic("ilock: no type");
    80002b94:	00006517          	auipc	a0,0x6
    80002b98:	9c450513          	addi	a0,a0,-1596 # 80008558 <syscalls+0x188>
    80002b9c:	00003097          	auipc	ra,0x3
    80002ba0:	000080e7          	jalr	ra # 80005b9c <panic>

0000000080002ba4 <iunlock>:
{
    80002ba4:	1101                	addi	sp,sp,-32
    80002ba6:	ec06                	sd	ra,24(sp)
    80002ba8:	e822                	sd	s0,16(sp)
    80002baa:	e426                	sd	s1,8(sp)
    80002bac:	e04a                	sd	s2,0(sp)
    80002bae:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002bb0:	c905                	beqz	a0,80002be0 <iunlock+0x3c>
    80002bb2:	84aa                	mv	s1,a0
    80002bb4:	01050913          	addi	s2,a0,16
    80002bb8:	854a                	mv	a0,s2
    80002bba:	00001097          	auipc	ra,0x1
    80002bbe:	c82080e7          	jalr	-894(ra) # 8000383c <holdingsleep>
    80002bc2:	cd19                	beqz	a0,80002be0 <iunlock+0x3c>
    80002bc4:	449c                	lw	a5,8(s1)
    80002bc6:	00f05d63          	blez	a5,80002be0 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002bca:	854a                	mv	a0,s2
    80002bcc:	00001097          	auipc	ra,0x1
    80002bd0:	c2c080e7          	jalr	-980(ra) # 800037f8 <releasesleep>
}
    80002bd4:	60e2                	ld	ra,24(sp)
    80002bd6:	6442                	ld	s0,16(sp)
    80002bd8:	64a2                	ld	s1,8(sp)
    80002bda:	6902                	ld	s2,0(sp)
    80002bdc:	6105                	addi	sp,sp,32
    80002bde:	8082                	ret
    panic("iunlock");
    80002be0:	00006517          	auipc	a0,0x6
    80002be4:	98850513          	addi	a0,a0,-1656 # 80008568 <syscalls+0x198>
    80002be8:	00003097          	auipc	ra,0x3
    80002bec:	fb4080e7          	jalr	-76(ra) # 80005b9c <panic>

0000000080002bf0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002bf0:	7179                	addi	sp,sp,-48
    80002bf2:	f406                	sd	ra,40(sp)
    80002bf4:	f022                	sd	s0,32(sp)
    80002bf6:	ec26                	sd	s1,24(sp)
    80002bf8:	e84a                	sd	s2,16(sp)
    80002bfa:	e44e                	sd	s3,8(sp)
    80002bfc:	e052                	sd	s4,0(sp)
    80002bfe:	1800                	addi	s0,sp,48
    80002c00:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c02:	05050493          	addi	s1,a0,80
    80002c06:	08050913          	addi	s2,a0,128
    80002c0a:	a021                	j	80002c12 <itrunc+0x22>
    80002c0c:	0491                	addi	s1,s1,4
    80002c0e:	01248d63          	beq	s1,s2,80002c28 <itrunc+0x38>
    if(ip->addrs[i]){
    80002c12:	408c                	lw	a1,0(s1)
    80002c14:	dde5                	beqz	a1,80002c0c <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c16:	0009a503          	lw	a0,0(s3)
    80002c1a:	00000097          	auipc	ra,0x0
    80002c1e:	8f6080e7          	jalr	-1802(ra) # 80002510 <bfree>
      ip->addrs[i] = 0;
    80002c22:	0004a023          	sw	zero,0(s1)
    80002c26:	b7dd                	j	80002c0c <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c28:	0809a583          	lw	a1,128(s3)
    80002c2c:	e185                	bnez	a1,80002c4c <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c2e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c32:	854e                	mv	a0,s3
    80002c34:	00000097          	auipc	ra,0x0
    80002c38:	de2080e7          	jalr	-542(ra) # 80002a16 <iupdate>
}
    80002c3c:	70a2                	ld	ra,40(sp)
    80002c3e:	7402                	ld	s0,32(sp)
    80002c40:	64e2                	ld	s1,24(sp)
    80002c42:	6942                	ld	s2,16(sp)
    80002c44:	69a2                	ld	s3,8(sp)
    80002c46:	6a02                	ld	s4,0(sp)
    80002c48:	6145                	addi	sp,sp,48
    80002c4a:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002c4c:	0009a503          	lw	a0,0(s3)
    80002c50:	fffff097          	auipc	ra,0xfffff
    80002c54:	67a080e7          	jalr	1658(ra) # 800022ca <bread>
    80002c58:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002c5a:	05850493          	addi	s1,a0,88
    80002c5e:	45850913          	addi	s2,a0,1112
    80002c62:	a021                	j	80002c6a <itrunc+0x7a>
    80002c64:	0491                	addi	s1,s1,4
    80002c66:	01248b63          	beq	s1,s2,80002c7c <itrunc+0x8c>
      if(a[j])
    80002c6a:	408c                	lw	a1,0(s1)
    80002c6c:	dde5                	beqz	a1,80002c64 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002c6e:	0009a503          	lw	a0,0(s3)
    80002c72:	00000097          	auipc	ra,0x0
    80002c76:	89e080e7          	jalr	-1890(ra) # 80002510 <bfree>
    80002c7a:	b7ed                	j	80002c64 <itrunc+0x74>
    brelse(bp);
    80002c7c:	8552                	mv	a0,s4
    80002c7e:	fffff097          	auipc	ra,0xfffff
    80002c82:	77c080e7          	jalr	1916(ra) # 800023fa <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c86:	0809a583          	lw	a1,128(s3)
    80002c8a:	0009a503          	lw	a0,0(s3)
    80002c8e:	00000097          	auipc	ra,0x0
    80002c92:	882080e7          	jalr	-1918(ra) # 80002510 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002c96:	0809a023          	sw	zero,128(s3)
    80002c9a:	bf51                	j	80002c2e <itrunc+0x3e>

0000000080002c9c <iput>:
{
    80002c9c:	1101                	addi	sp,sp,-32
    80002c9e:	ec06                	sd	ra,24(sp)
    80002ca0:	e822                	sd	s0,16(sp)
    80002ca2:	e426                	sd	s1,8(sp)
    80002ca4:	e04a                	sd	s2,0(sp)
    80002ca6:	1000                	addi	s0,sp,32
    80002ca8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002caa:	00014517          	auipc	a0,0x14
    80002cae:	17e50513          	addi	a0,a0,382 # 80016e28 <itable>
    80002cb2:	00003097          	auipc	ra,0x3
    80002cb6:	422080e7          	jalr	1058(ra) # 800060d4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cba:	4498                	lw	a4,8(s1)
    80002cbc:	4785                	li	a5,1
    80002cbe:	02f70363          	beq	a4,a5,80002ce4 <iput+0x48>
  ip->ref--;
    80002cc2:	449c                	lw	a5,8(s1)
    80002cc4:	37fd                	addiw	a5,a5,-1
    80002cc6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cc8:	00014517          	auipc	a0,0x14
    80002ccc:	16050513          	addi	a0,a0,352 # 80016e28 <itable>
    80002cd0:	00003097          	auipc	ra,0x3
    80002cd4:	4b8080e7          	jalr	1208(ra) # 80006188 <release>
}
    80002cd8:	60e2                	ld	ra,24(sp)
    80002cda:	6442                	ld	s0,16(sp)
    80002cdc:	64a2                	ld	s1,8(sp)
    80002cde:	6902                	ld	s2,0(sp)
    80002ce0:	6105                	addi	sp,sp,32
    80002ce2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ce4:	40bc                	lw	a5,64(s1)
    80002ce6:	dff1                	beqz	a5,80002cc2 <iput+0x26>
    80002ce8:	04a49783          	lh	a5,74(s1)
    80002cec:	fbf9                	bnez	a5,80002cc2 <iput+0x26>
    acquiresleep(&ip->lock);
    80002cee:	01048913          	addi	s2,s1,16
    80002cf2:	854a                	mv	a0,s2
    80002cf4:	00001097          	auipc	ra,0x1
    80002cf8:	aae080e7          	jalr	-1362(ra) # 800037a2 <acquiresleep>
    release(&itable.lock);
    80002cfc:	00014517          	auipc	a0,0x14
    80002d00:	12c50513          	addi	a0,a0,300 # 80016e28 <itable>
    80002d04:	00003097          	auipc	ra,0x3
    80002d08:	484080e7          	jalr	1156(ra) # 80006188 <release>
    itrunc(ip);
    80002d0c:	8526                	mv	a0,s1
    80002d0e:	00000097          	auipc	ra,0x0
    80002d12:	ee2080e7          	jalr	-286(ra) # 80002bf0 <itrunc>
    ip->type = 0;
    80002d16:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d1a:	8526                	mv	a0,s1
    80002d1c:	00000097          	auipc	ra,0x0
    80002d20:	cfa080e7          	jalr	-774(ra) # 80002a16 <iupdate>
    ip->valid = 0;
    80002d24:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d28:	854a                	mv	a0,s2
    80002d2a:	00001097          	auipc	ra,0x1
    80002d2e:	ace080e7          	jalr	-1330(ra) # 800037f8 <releasesleep>
    acquire(&itable.lock);
    80002d32:	00014517          	auipc	a0,0x14
    80002d36:	0f650513          	addi	a0,a0,246 # 80016e28 <itable>
    80002d3a:	00003097          	auipc	ra,0x3
    80002d3e:	39a080e7          	jalr	922(ra) # 800060d4 <acquire>
    80002d42:	b741                	j	80002cc2 <iput+0x26>

0000000080002d44 <iunlockput>:
{
    80002d44:	1101                	addi	sp,sp,-32
    80002d46:	ec06                	sd	ra,24(sp)
    80002d48:	e822                	sd	s0,16(sp)
    80002d4a:	e426                	sd	s1,8(sp)
    80002d4c:	1000                	addi	s0,sp,32
    80002d4e:	84aa                	mv	s1,a0
  iunlock(ip);
    80002d50:	00000097          	auipc	ra,0x0
    80002d54:	e54080e7          	jalr	-428(ra) # 80002ba4 <iunlock>
  iput(ip);
    80002d58:	8526                	mv	a0,s1
    80002d5a:	00000097          	auipc	ra,0x0
    80002d5e:	f42080e7          	jalr	-190(ra) # 80002c9c <iput>
}
    80002d62:	60e2                	ld	ra,24(sp)
    80002d64:	6442                	ld	s0,16(sp)
    80002d66:	64a2                	ld	s1,8(sp)
    80002d68:	6105                	addi	sp,sp,32
    80002d6a:	8082                	ret

0000000080002d6c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002d6c:	1141                	addi	sp,sp,-16
    80002d6e:	e422                	sd	s0,8(sp)
    80002d70:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002d72:	411c                	lw	a5,0(a0)
    80002d74:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002d76:	415c                	lw	a5,4(a0)
    80002d78:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002d7a:	04451783          	lh	a5,68(a0)
    80002d7e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002d82:	04a51783          	lh	a5,74(a0)
    80002d86:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002d8a:	04c56783          	lwu	a5,76(a0)
    80002d8e:	e99c                	sd	a5,16(a1)
}
    80002d90:	6422                	ld	s0,8(sp)
    80002d92:	0141                	addi	sp,sp,16
    80002d94:	8082                	ret

0000000080002d96 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002d96:	457c                	lw	a5,76(a0)
    80002d98:	0ed7e963          	bltu	a5,a3,80002e8a <readi+0xf4>
{
    80002d9c:	7159                	addi	sp,sp,-112
    80002d9e:	f486                	sd	ra,104(sp)
    80002da0:	f0a2                	sd	s0,96(sp)
    80002da2:	eca6                	sd	s1,88(sp)
    80002da4:	e8ca                	sd	s2,80(sp)
    80002da6:	e4ce                	sd	s3,72(sp)
    80002da8:	e0d2                	sd	s4,64(sp)
    80002daa:	fc56                	sd	s5,56(sp)
    80002dac:	f85a                	sd	s6,48(sp)
    80002dae:	f45e                	sd	s7,40(sp)
    80002db0:	f062                	sd	s8,32(sp)
    80002db2:	ec66                	sd	s9,24(sp)
    80002db4:	e86a                	sd	s10,16(sp)
    80002db6:	e46e                	sd	s11,8(sp)
    80002db8:	1880                	addi	s0,sp,112
    80002dba:	8b2a                	mv	s6,a0
    80002dbc:	8bae                	mv	s7,a1
    80002dbe:	8a32                	mv	s4,a2
    80002dc0:	84b6                	mv	s1,a3
    80002dc2:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002dc4:	9f35                	addw	a4,a4,a3
    return 0;
    80002dc6:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002dc8:	0ad76063          	bltu	a4,a3,80002e68 <readi+0xd2>
  if(off + n > ip->size)
    80002dcc:	00e7f463          	bgeu	a5,a4,80002dd4 <readi+0x3e>
    n = ip->size - off;
    80002dd0:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002dd4:	0a0a8963          	beqz	s5,80002e86 <readi+0xf0>
    80002dd8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002dda:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002dde:	5c7d                	li	s8,-1
    80002de0:	a82d                	j	80002e1a <readi+0x84>
    80002de2:	020d1d93          	slli	s11,s10,0x20
    80002de6:	020ddd93          	srli	s11,s11,0x20
    80002dea:	05890613          	addi	a2,s2,88
    80002dee:	86ee                	mv	a3,s11
    80002df0:	963a                	add	a2,a2,a4
    80002df2:	85d2                	mv	a1,s4
    80002df4:	855e                	mv	a0,s7
    80002df6:	fffff097          	auipc	ra,0xfffff
    80002dfa:	b0e080e7          	jalr	-1266(ra) # 80001904 <either_copyout>
    80002dfe:	05850d63          	beq	a0,s8,80002e58 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e02:	854a                	mv	a0,s2
    80002e04:	fffff097          	auipc	ra,0xfffff
    80002e08:	5f6080e7          	jalr	1526(ra) # 800023fa <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e0c:	013d09bb          	addw	s3,s10,s3
    80002e10:	009d04bb          	addw	s1,s10,s1
    80002e14:	9a6e                	add	s4,s4,s11
    80002e16:	0559f763          	bgeu	s3,s5,80002e64 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002e1a:	00a4d59b          	srliw	a1,s1,0xa
    80002e1e:	855a                	mv	a0,s6
    80002e20:	00000097          	auipc	ra,0x0
    80002e24:	89e080e7          	jalr	-1890(ra) # 800026be <bmap>
    80002e28:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002e2c:	cd85                	beqz	a1,80002e64 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002e2e:	000b2503          	lw	a0,0(s6)
    80002e32:	fffff097          	auipc	ra,0xfffff
    80002e36:	498080e7          	jalr	1176(ra) # 800022ca <bread>
    80002e3a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e3c:	3ff4f713          	andi	a4,s1,1023
    80002e40:	40ec87bb          	subw	a5,s9,a4
    80002e44:	413a86bb          	subw	a3,s5,s3
    80002e48:	8d3e                	mv	s10,a5
    80002e4a:	2781                	sext.w	a5,a5
    80002e4c:	0006861b          	sext.w	a2,a3
    80002e50:	f8f679e3          	bgeu	a2,a5,80002de2 <readi+0x4c>
    80002e54:	8d36                	mv	s10,a3
    80002e56:	b771                	j	80002de2 <readi+0x4c>
      brelse(bp);
    80002e58:	854a                	mv	a0,s2
    80002e5a:	fffff097          	auipc	ra,0xfffff
    80002e5e:	5a0080e7          	jalr	1440(ra) # 800023fa <brelse>
      tot = -1;
    80002e62:	59fd                	li	s3,-1
  }
  return tot;
    80002e64:	0009851b          	sext.w	a0,s3
}
    80002e68:	70a6                	ld	ra,104(sp)
    80002e6a:	7406                	ld	s0,96(sp)
    80002e6c:	64e6                	ld	s1,88(sp)
    80002e6e:	6946                	ld	s2,80(sp)
    80002e70:	69a6                	ld	s3,72(sp)
    80002e72:	6a06                	ld	s4,64(sp)
    80002e74:	7ae2                	ld	s5,56(sp)
    80002e76:	7b42                	ld	s6,48(sp)
    80002e78:	7ba2                	ld	s7,40(sp)
    80002e7a:	7c02                	ld	s8,32(sp)
    80002e7c:	6ce2                	ld	s9,24(sp)
    80002e7e:	6d42                	ld	s10,16(sp)
    80002e80:	6da2                	ld	s11,8(sp)
    80002e82:	6165                	addi	sp,sp,112
    80002e84:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e86:	89d6                	mv	s3,s5
    80002e88:	bff1                	j	80002e64 <readi+0xce>
    return 0;
    80002e8a:	4501                	li	a0,0
}
    80002e8c:	8082                	ret

0000000080002e8e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e8e:	457c                	lw	a5,76(a0)
    80002e90:	10d7e863          	bltu	a5,a3,80002fa0 <writei+0x112>
{
    80002e94:	7159                	addi	sp,sp,-112
    80002e96:	f486                	sd	ra,104(sp)
    80002e98:	f0a2                	sd	s0,96(sp)
    80002e9a:	eca6                	sd	s1,88(sp)
    80002e9c:	e8ca                	sd	s2,80(sp)
    80002e9e:	e4ce                	sd	s3,72(sp)
    80002ea0:	e0d2                	sd	s4,64(sp)
    80002ea2:	fc56                	sd	s5,56(sp)
    80002ea4:	f85a                	sd	s6,48(sp)
    80002ea6:	f45e                	sd	s7,40(sp)
    80002ea8:	f062                	sd	s8,32(sp)
    80002eaa:	ec66                	sd	s9,24(sp)
    80002eac:	e86a                	sd	s10,16(sp)
    80002eae:	e46e                	sd	s11,8(sp)
    80002eb0:	1880                	addi	s0,sp,112
    80002eb2:	8aaa                	mv	s5,a0
    80002eb4:	8bae                	mv	s7,a1
    80002eb6:	8a32                	mv	s4,a2
    80002eb8:	8936                	mv	s2,a3
    80002eba:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ebc:	00e687bb          	addw	a5,a3,a4
    80002ec0:	0ed7e263          	bltu	a5,a3,80002fa4 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002ec4:	00043737          	lui	a4,0x43
    80002ec8:	0ef76063          	bltu	a4,a5,80002fa8 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ecc:	0c0b0863          	beqz	s6,80002f9c <writei+0x10e>
    80002ed0:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ed2:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ed6:	5c7d                	li	s8,-1
    80002ed8:	a091                	j	80002f1c <writei+0x8e>
    80002eda:	020d1d93          	slli	s11,s10,0x20
    80002ede:	020ddd93          	srli	s11,s11,0x20
    80002ee2:	05848513          	addi	a0,s1,88
    80002ee6:	86ee                	mv	a3,s11
    80002ee8:	8652                	mv	a2,s4
    80002eea:	85de                	mv	a1,s7
    80002eec:	953a                	add	a0,a0,a4
    80002eee:	fffff097          	auipc	ra,0xfffff
    80002ef2:	a6c080e7          	jalr	-1428(ra) # 8000195a <either_copyin>
    80002ef6:	07850263          	beq	a0,s8,80002f5a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002efa:	8526                	mv	a0,s1
    80002efc:	00000097          	auipc	ra,0x0
    80002f00:	788080e7          	jalr	1928(ra) # 80003684 <log_write>
    brelse(bp);
    80002f04:	8526                	mv	a0,s1
    80002f06:	fffff097          	auipc	ra,0xfffff
    80002f0a:	4f4080e7          	jalr	1268(ra) # 800023fa <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f0e:	013d09bb          	addw	s3,s10,s3
    80002f12:	012d093b          	addw	s2,s10,s2
    80002f16:	9a6e                	add	s4,s4,s11
    80002f18:	0569f663          	bgeu	s3,s6,80002f64 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80002f1c:	00a9559b          	srliw	a1,s2,0xa
    80002f20:	8556                	mv	a0,s5
    80002f22:	fffff097          	auipc	ra,0xfffff
    80002f26:	79c080e7          	jalr	1948(ra) # 800026be <bmap>
    80002f2a:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f2e:	c99d                	beqz	a1,80002f64 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80002f30:	000aa503          	lw	a0,0(s5)
    80002f34:	fffff097          	auipc	ra,0xfffff
    80002f38:	396080e7          	jalr	918(ra) # 800022ca <bread>
    80002f3c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f3e:	3ff97713          	andi	a4,s2,1023
    80002f42:	40ec87bb          	subw	a5,s9,a4
    80002f46:	413b06bb          	subw	a3,s6,s3
    80002f4a:	8d3e                	mv	s10,a5
    80002f4c:	2781                	sext.w	a5,a5
    80002f4e:	0006861b          	sext.w	a2,a3
    80002f52:	f8f674e3          	bgeu	a2,a5,80002eda <writei+0x4c>
    80002f56:	8d36                	mv	s10,a3
    80002f58:	b749                	j	80002eda <writei+0x4c>
      brelse(bp);
    80002f5a:	8526                	mv	a0,s1
    80002f5c:	fffff097          	auipc	ra,0xfffff
    80002f60:	49e080e7          	jalr	1182(ra) # 800023fa <brelse>
  }

  if(off > ip->size)
    80002f64:	04caa783          	lw	a5,76(s5)
    80002f68:	0127f463          	bgeu	a5,s2,80002f70 <writei+0xe2>
    ip->size = off;
    80002f6c:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002f70:	8556                	mv	a0,s5
    80002f72:	00000097          	auipc	ra,0x0
    80002f76:	aa4080e7          	jalr	-1372(ra) # 80002a16 <iupdate>

  return tot;
    80002f7a:	0009851b          	sext.w	a0,s3
}
    80002f7e:	70a6                	ld	ra,104(sp)
    80002f80:	7406                	ld	s0,96(sp)
    80002f82:	64e6                	ld	s1,88(sp)
    80002f84:	6946                	ld	s2,80(sp)
    80002f86:	69a6                	ld	s3,72(sp)
    80002f88:	6a06                	ld	s4,64(sp)
    80002f8a:	7ae2                	ld	s5,56(sp)
    80002f8c:	7b42                	ld	s6,48(sp)
    80002f8e:	7ba2                	ld	s7,40(sp)
    80002f90:	7c02                	ld	s8,32(sp)
    80002f92:	6ce2                	ld	s9,24(sp)
    80002f94:	6d42                	ld	s10,16(sp)
    80002f96:	6da2                	ld	s11,8(sp)
    80002f98:	6165                	addi	sp,sp,112
    80002f9a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f9c:	89da                	mv	s3,s6
    80002f9e:	bfc9                	j	80002f70 <writei+0xe2>
    return -1;
    80002fa0:	557d                	li	a0,-1
}
    80002fa2:	8082                	ret
    return -1;
    80002fa4:	557d                	li	a0,-1
    80002fa6:	bfe1                	j	80002f7e <writei+0xf0>
    return -1;
    80002fa8:	557d                	li	a0,-1
    80002faa:	bfd1                	j	80002f7e <writei+0xf0>

0000000080002fac <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002fac:	1141                	addi	sp,sp,-16
    80002fae:	e406                	sd	ra,8(sp)
    80002fb0:	e022                	sd	s0,0(sp)
    80002fb2:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002fb4:	4639                	li	a2,14
    80002fb6:	ffffd097          	auipc	ra,0xffffd
    80002fba:	294080e7          	jalr	660(ra) # 8000024a <strncmp>
}
    80002fbe:	60a2                	ld	ra,8(sp)
    80002fc0:	6402                	ld	s0,0(sp)
    80002fc2:	0141                	addi	sp,sp,16
    80002fc4:	8082                	ret

0000000080002fc6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002fc6:	7139                	addi	sp,sp,-64
    80002fc8:	fc06                	sd	ra,56(sp)
    80002fca:	f822                	sd	s0,48(sp)
    80002fcc:	f426                	sd	s1,40(sp)
    80002fce:	f04a                	sd	s2,32(sp)
    80002fd0:	ec4e                	sd	s3,24(sp)
    80002fd2:	e852                	sd	s4,16(sp)
    80002fd4:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002fd6:	04451703          	lh	a4,68(a0)
    80002fda:	4785                	li	a5,1
    80002fdc:	00f71a63          	bne	a4,a5,80002ff0 <dirlookup+0x2a>
    80002fe0:	892a                	mv	s2,a0
    80002fe2:	89ae                	mv	s3,a1
    80002fe4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fe6:	457c                	lw	a5,76(a0)
    80002fe8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002fea:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fec:	e79d                	bnez	a5,8000301a <dirlookup+0x54>
    80002fee:	a8a5                	j	80003066 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80002ff0:	00005517          	auipc	a0,0x5
    80002ff4:	58050513          	addi	a0,a0,1408 # 80008570 <syscalls+0x1a0>
    80002ff8:	00003097          	auipc	ra,0x3
    80002ffc:	ba4080e7          	jalr	-1116(ra) # 80005b9c <panic>
      panic("dirlookup read");
    80003000:	00005517          	auipc	a0,0x5
    80003004:	58850513          	addi	a0,a0,1416 # 80008588 <syscalls+0x1b8>
    80003008:	00003097          	auipc	ra,0x3
    8000300c:	b94080e7          	jalr	-1132(ra) # 80005b9c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003010:	24c1                	addiw	s1,s1,16
    80003012:	04c92783          	lw	a5,76(s2)
    80003016:	04f4f763          	bgeu	s1,a5,80003064 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000301a:	4741                	li	a4,16
    8000301c:	86a6                	mv	a3,s1
    8000301e:	fc040613          	addi	a2,s0,-64
    80003022:	4581                	li	a1,0
    80003024:	854a                	mv	a0,s2
    80003026:	00000097          	auipc	ra,0x0
    8000302a:	d70080e7          	jalr	-656(ra) # 80002d96 <readi>
    8000302e:	47c1                	li	a5,16
    80003030:	fcf518e3          	bne	a0,a5,80003000 <dirlookup+0x3a>
    if(de.inum == 0)
    80003034:	fc045783          	lhu	a5,-64(s0)
    80003038:	dfe1                	beqz	a5,80003010 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000303a:	fc240593          	addi	a1,s0,-62
    8000303e:	854e                	mv	a0,s3
    80003040:	00000097          	auipc	ra,0x0
    80003044:	f6c080e7          	jalr	-148(ra) # 80002fac <namecmp>
    80003048:	f561                	bnez	a0,80003010 <dirlookup+0x4a>
      if(poff)
    8000304a:	000a0463          	beqz	s4,80003052 <dirlookup+0x8c>
        *poff = off;
    8000304e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003052:	fc045583          	lhu	a1,-64(s0)
    80003056:	00092503          	lw	a0,0(s2)
    8000305a:	fffff097          	auipc	ra,0xfffff
    8000305e:	74e080e7          	jalr	1870(ra) # 800027a8 <iget>
    80003062:	a011                	j	80003066 <dirlookup+0xa0>
  return 0;
    80003064:	4501                	li	a0,0
}
    80003066:	70e2                	ld	ra,56(sp)
    80003068:	7442                	ld	s0,48(sp)
    8000306a:	74a2                	ld	s1,40(sp)
    8000306c:	7902                	ld	s2,32(sp)
    8000306e:	69e2                	ld	s3,24(sp)
    80003070:	6a42                	ld	s4,16(sp)
    80003072:	6121                	addi	sp,sp,64
    80003074:	8082                	ret

0000000080003076 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003076:	711d                	addi	sp,sp,-96
    80003078:	ec86                	sd	ra,88(sp)
    8000307a:	e8a2                	sd	s0,80(sp)
    8000307c:	e4a6                	sd	s1,72(sp)
    8000307e:	e0ca                	sd	s2,64(sp)
    80003080:	fc4e                	sd	s3,56(sp)
    80003082:	f852                	sd	s4,48(sp)
    80003084:	f456                	sd	s5,40(sp)
    80003086:	f05a                	sd	s6,32(sp)
    80003088:	ec5e                	sd	s7,24(sp)
    8000308a:	e862                	sd	s8,16(sp)
    8000308c:	e466                	sd	s9,8(sp)
    8000308e:	e06a                	sd	s10,0(sp)
    80003090:	1080                	addi	s0,sp,96
    80003092:	84aa                	mv	s1,a0
    80003094:	8b2e                	mv	s6,a1
    80003096:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003098:	00054703          	lbu	a4,0(a0)
    8000309c:	02f00793          	li	a5,47
    800030a0:	02f70363          	beq	a4,a5,800030c6 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800030a4:	ffffe097          	auipc	ra,0xffffe
    800030a8:	db0080e7          	jalr	-592(ra) # 80000e54 <myproc>
    800030ac:	15053503          	ld	a0,336(a0)
    800030b0:	00000097          	auipc	ra,0x0
    800030b4:	9f4080e7          	jalr	-1548(ra) # 80002aa4 <idup>
    800030b8:	8a2a                	mv	s4,a0
  while(*path == '/')
    800030ba:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800030be:	4cb5                	li	s9,13
  len = path - s;
    800030c0:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800030c2:	4c05                	li	s8,1
    800030c4:	a87d                	j	80003182 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800030c6:	4585                	li	a1,1
    800030c8:	4505                	li	a0,1
    800030ca:	fffff097          	auipc	ra,0xfffff
    800030ce:	6de080e7          	jalr	1758(ra) # 800027a8 <iget>
    800030d2:	8a2a                	mv	s4,a0
    800030d4:	b7dd                	j	800030ba <namex+0x44>
      iunlockput(ip);
    800030d6:	8552                	mv	a0,s4
    800030d8:	00000097          	auipc	ra,0x0
    800030dc:	c6c080e7          	jalr	-916(ra) # 80002d44 <iunlockput>
      return 0;
    800030e0:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800030e2:	8552                	mv	a0,s4
    800030e4:	60e6                	ld	ra,88(sp)
    800030e6:	6446                	ld	s0,80(sp)
    800030e8:	64a6                	ld	s1,72(sp)
    800030ea:	6906                	ld	s2,64(sp)
    800030ec:	79e2                	ld	s3,56(sp)
    800030ee:	7a42                	ld	s4,48(sp)
    800030f0:	7aa2                	ld	s5,40(sp)
    800030f2:	7b02                	ld	s6,32(sp)
    800030f4:	6be2                	ld	s7,24(sp)
    800030f6:	6c42                	ld	s8,16(sp)
    800030f8:	6ca2                	ld	s9,8(sp)
    800030fa:	6d02                	ld	s10,0(sp)
    800030fc:	6125                	addi	sp,sp,96
    800030fe:	8082                	ret
      iunlock(ip);
    80003100:	8552                	mv	a0,s4
    80003102:	00000097          	auipc	ra,0x0
    80003106:	aa2080e7          	jalr	-1374(ra) # 80002ba4 <iunlock>
      return ip;
    8000310a:	bfe1                	j	800030e2 <namex+0x6c>
      iunlockput(ip);
    8000310c:	8552                	mv	a0,s4
    8000310e:	00000097          	auipc	ra,0x0
    80003112:	c36080e7          	jalr	-970(ra) # 80002d44 <iunlockput>
      return 0;
    80003116:	8a4e                	mv	s4,s3
    80003118:	b7e9                	j	800030e2 <namex+0x6c>
  len = path - s;
    8000311a:	40998633          	sub	a2,s3,s1
    8000311e:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003122:	09acd863          	bge	s9,s10,800031b2 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003126:	4639                	li	a2,14
    80003128:	85a6                	mv	a1,s1
    8000312a:	8556                	mv	a0,s5
    8000312c:	ffffd097          	auipc	ra,0xffffd
    80003130:	0aa080e7          	jalr	170(ra) # 800001d6 <memmove>
    80003134:	84ce                	mv	s1,s3
  while(*path == '/')
    80003136:	0004c783          	lbu	a5,0(s1)
    8000313a:	01279763          	bne	a5,s2,80003148 <namex+0xd2>
    path++;
    8000313e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003140:	0004c783          	lbu	a5,0(s1)
    80003144:	ff278de3          	beq	a5,s2,8000313e <namex+0xc8>
    ilock(ip);
    80003148:	8552                	mv	a0,s4
    8000314a:	00000097          	auipc	ra,0x0
    8000314e:	998080e7          	jalr	-1640(ra) # 80002ae2 <ilock>
    if(ip->type != T_DIR){
    80003152:	044a1783          	lh	a5,68(s4)
    80003156:	f98790e3          	bne	a5,s8,800030d6 <namex+0x60>
    if(nameiparent && *path == '\0'){
    8000315a:	000b0563          	beqz	s6,80003164 <namex+0xee>
    8000315e:	0004c783          	lbu	a5,0(s1)
    80003162:	dfd9                	beqz	a5,80003100 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003164:	865e                	mv	a2,s7
    80003166:	85d6                	mv	a1,s5
    80003168:	8552                	mv	a0,s4
    8000316a:	00000097          	auipc	ra,0x0
    8000316e:	e5c080e7          	jalr	-420(ra) # 80002fc6 <dirlookup>
    80003172:	89aa                	mv	s3,a0
    80003174:	dd41                	beqz	a0,8000310c <namex+0x96>
    iunlockput(ip);
    80003176:	8552                	mv	a0,s4
    80003178:	00000097          	auipc	ra,0x0
    8000317c:	bcc080e7          	jalr	-1076(ra) # 80002d44 <iunlockput>
    ip = next;
    80003180:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003182:	0004c783          	lbu	a5,0(s1)
    80003186:	01279763          	bne	a5,s2,80003194 <namex+0x11e>
    path++;
    8000318a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000318c:	0004c783          	lbu	a5,0(s1)
    80003190:	ff278de3          	beq	a5,s2,8000318a <namex+0x114>
  if(*path == 0)
    80003194:	cb9d                	beqz	a5,800031ca <namex+0x154>
  while(*path != '/' && *path != 0)
    80003196:	0004c783          	lbu	a5,0(s1)
    8000319a:	89a6                	mv	s3,s1
  len = path - s;
    8000319c:	8d5e                	mv	s10,s7
    8000319e:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800031a0:	01278963          	beq	a5,s2,800031b2 <namex+0x13c>
    800031a4:	dbbd                	beqz	a5,8000311a <namex+0xa4>
    path++;
    800031a6:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800031a8:	0009c783          	lbu	a5,0(s3)
    800031ac:	ff279ce3          	bne	a5,s2,800031a4 <namex+0x12e>
    800031b0:	b7ad                	j	8000311a <namex+0xa4>
    memmove(name, s, len);
    800031b2:	2601                	sext.w	a2,a2
    800031b4:	85a6                	mv	a1,s1
    800031b6:	8556                	mv	a0,s5
    800031b8:	ffffd097          	auipc	ra,0xffffd
    800031bc:	01e080e7          	jalr	30(ra) # 800001d6 <memmove>
    name[len] = 0;
    800031c0:	9d56                	add	s10,s10,s5
    800031c2:	000d0023          	sb	zero,0(s10)
    800031c6:	84ce                	mv	s1,s3
    800031c8:	b7bd                	j	80003136 <namex+0xc0>
  if(nameiparent){
    800031ca:	f00b0ce3          	beqz	s6,800030e2 <namex+0x6c>
    iput(ip);
    800031ce:	8552                	mv	a0,s4
    800031d0:	00000097          	auipc	ra,0x0
    800031d4:	acc080e7          	jalr	-1332(ra) # 80002c9c <iput>
    return 0;
    800031d8:	4a01                	li	s4,0
    800031da:	b721                	j	800030e2 <namex+0x6c>

00000000800031dc <dirlink>:
{
    800031dc:	7139                	addi	sp,sp,-64
    800031de:	fc06                	sd	ra,56(sp)
    800031e0:	f822                	sd	s0,48(sp)
    800031e2:	f426                	sd	s1,40(sp)
    800031e4:	f04a                	sd	s2,32(sp)
    800031e6:	ec4e                	sd	s3,24(sp)
    800031e8:	e852                	sd	s4,16(sp)
    800031ea:	0080                	addi	s0,sp,64
    800031ec:	892a                	mv	s2,a0
    800031ee:	8a2e                	mv	s4,a1
    800031f0:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800031f2:	4601                	li	a2,0
    800031f4:	00000097          	auipc	ra,0x0
    800031f8:	dd2080e7          	jalr	-558(ra) # 80002fc6 <dirlookup>
    800031fc:	e93d                	bnez	a0,80003272 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031fe:	04c92483          	lw	s1,76(s2)
    80003202:	c49d                	beqz	s1,80003230 <dirlink+0x54>
    80003204:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003206:	4741                	li	a4,16
    80003208:	86a6                	mv	a3,s1
    8000320a:	fc040613          	addi	a2,s0,-64
    8000320e:	4581                	li	a1,0
    80003210:	854a                	mv	a0,s2
    80003212:	00000097          	auipc	ra,0x0
    80003216:	b84080e7          	jalr	-1148(ra) # 80002d96 <readi>
    8000321a:	47c1                	li	a5,16
    8000321c:	06f51163          	bne	a0,a5,8000327e <dirlink+0xa2>
    if(de.inum == 0)
    80003220:	fc045783          	lhu	a5,-64(s0)
    80003224:	c791                	beqz	a5,80003230 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003226:	24c1                	addiw	s1,s1,16
    80003228:	04c92783          	lw	a5,76(s2)
    8000322c:	fcf4ede3          	bltu	s1,a5,80003206 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003230:	4639                	li	a2,14
    80003232:	85d2                	mv	a1,s4
    80003234:	fc240513          	addi	a0,s0,-62
    80003238:	ffffd097          	auipc	ra,0xffffd
    8000323c:	04e080e7          	jalr	78(ra) # 80000286 <strncpy>
  de.inum = inum;
    80003240:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003244:	4741                	li	a4,16
    80003246:	86a6                	mv	a3,s1
    80003248:	fc040613          	addi	a2,s0,-64
    8000324c:	4581                	li	a1,0
    8000324e:	854a                	mv	a0,s2
    80003250:	00000097          	auipc	ra,0x0
    80003254:	c3e080e7          	jalr	-962(ra) # 80002e8e <writei>
    80003258:	1541                	addi	a0,a0,-16
    8000325a:	00a03533          	snez	a0,a0
    8000325e:	40a00533          	neg	a0,a0
}
    80003262:	70e2                	ld	ra,56(sp)
    80003264:	7442                	ld	s0,48(sp)
    80003266:	74a2                	ld	s1,40(sp)
    80003268:	7902                	ld	s2,32(sp)
    8000326a:	69e2                	ld	s3,24(sp)
    8000326c:	6a42                	ld	s4,16(sp)
    8000326e:	6121                	addi	sp,sp,64
    80003270:	8082                	ret
    iput(ip);
    80003272:	00000097          	auipc	ra,0x0
    80003276:	a2a080e7          	jalr	-1494(ra) # 80002c9c <iput>
    return -1;
    8000327a:	557d                	li	a0,-1
    8000327c:	b7dd                	j	80003262 <dirlink+0x86>
      panic("dirlink read");
    8000327e:	00005517          	auipc	a0,0x5
    80003282:	31a50513          	addi	a0,a0,794 # 80008598 <syscalls+0x1c8>
    80003286:	00003097          	auipc	ra,0x3
    8000328a:	916080e7          	jalr	-1770(ra) # 80005b9c <panic>

000000008000328e <namei>:

struct inode*
namei(char *path)
{
    8000328e:	1101                	addi	sp,sp,-32
    80003290:	ec06                	sd	ra,24(sp)
    80003292:	e822                	sd	s0,16(sp)
    80003294:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003296:	fe040613          	addi	a2,s0,-32
    8000329a:	4581                	li	a1,0
    8000329c:	00000097          	auipc	ra,0x0
    800032a0:	dda080e7          	jalr	-550(ra) # 80003076 <namex>
}
    800032a4:	60e2                	ld	ra,24(sp)
    800032a6:	6442                	ld	s0,16(sp)
    800032a8:	6105                	addi	sp,sp,32
    800032aa:	8082                	ret

00000000800032ac <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800032ac:	1141                	addi	sp,sp,-16
    800032ae:	e406                	sd	ra,8(sp)
    800032b0:	e022                	sd	s0,0(sp)
    800032b2:	0800                	addi	s0,sp,16
    800032b4:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800032b6:	4585                	li	a1,1
    800032b8:	00000097          	auipc	ra,0x0
    800032bc:	dbe080e7          	jalr	-578(ra) # 80003076 <namex>
}
    800032c0:	60a2                	ld	ra,8(sp)
    800032c2:	6402                	ld	s0,0(sp)
    800032c4:	0141                	addi	sp,sp,16
    800032c6:	8082                	ret

00000000800032c8 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800032c8:	1101                	addi	sp,sp,-32
    800032ca:	ec06                	sd	ra,24(sp)
    800032cc:	e822                	sd	s0,16(sp)
    800032ce:	e426                	sd	s1,8(sp)
    800032d0:	e04a                	sd	s2,0(sp)
    800032d2:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800032d4:	00015917          	auipc	s2,0x15
    800032d8:	5fc90913          	addi	s2,s2,1532 # 800188d0 <log>
    800032dc:	01892583          	lw	a1,24(s2)
    800032e0:	02892503          	lw	a0,40(s2)
    800032e4:	fffff097          	auipc	ra,0xfffff
    800032e8:	fe6080e7          	jalr	-26(ra) # 800022ca <bread>
    800032ec:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800032ee:	02c92683          	lw	a3,44(s2)
    800032f2:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800032f4:	02d05863          	blez	a3,80003324 <write_head+0x5c>
    800032f8:	00015797          	auipc	a5,0x15
    800032fc:	60878793          	addi	a5,a5,1544 # 80018900 <log+0x30>
    80003300:	05c50713          	addi	a4,a0,92
    80003304:	36fd                	addiw	a3,a3,-1
    80003306:	02069613          	slli	a2,a3,0x20
    8000330a:	01e65693          	srli	a3,a2,0x1e
    8000330e:	00015617          	auipc	a2,0x15
    80003312:	5f660613          	addi	a2,a2,1526 # 80018904 <log+0x34>
    80003316:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003318:	4390                	lw	a2,0(a5)
    8000331a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000331c:	0791                	addi	a5,a5,4
    8000331e:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    80003320:	fed79ce3          	bne	a5,a3,80003318 <write_head+0x50>
  }
  bwrite(buf);
    80003324:	8526                	mv	a0,s1
    80003326:	fffff097          	auipc	ra,0xfffff
    8000332a:	096080e7          	jalr	150(ra) # 800023bc <bwrite>
  brelse(buf);
    8000332e:	8526                	mv	a0,s1
    80003330:	fffff097          	auipc	ra,0xfffff
    80003334:	0ca080e7          	jalr	202(ra) # 800023fa <brelse>
}
    80003338:	60e2                	ld	ra,24(sp)
    8000333a:	6442                	ld	s0,16(sp)
    8000333c:	64a2                	ld	s1,8(sp)
    8000333e:	6902                	ld	s2,0(sp)
    80003340:	6105                	addi	sp,sp,32
    80003342:	8082                	ret

0000000080003344 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003344:	00015797          	auipc	a5,0x15
    80003348:	5b87a783          	lw	a5,1464(a5) # 800188fc <log+0x2c>
    8000334c:	0af05d63          	blez	a5,80003406 <install_trans+0xc2>
{
    80003350:	7139                	addi	sp,sp,-64
    80003352:	fc06                	sd	ra,56(sp)
    80003354:	f822                	sd	s0,48(sp)
    80003356:	f426                	sd	s1,40(sp)
    80003358:	f04a                	sd	s2,32(sp)
    8000335a:	ec4e                	sd	s3,24(sp)
    8000335c:	e852                	sd	s4,16(sp)
    8000335e:	e456                	sd	s5,8(sp)
    80003360:	e05a                	sd	s6,0(sp)
    80003362:	0080                	addi	s0,sp,64
    80003364:	8b2a                	mv	s6,a0
    80003366:	00015a97          	auipc	s5,0x15
    8000336a:	59aa8a93          	addi	s5,s5,1434 # 80018900 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000336e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003370:	00015997          	auipc	s3,0x15
    80003374:	56098993          	addi	s3,s3,1376 # 800188d0 <log>
    80003378:	a00d                	j	8000339a <install_trans+0x56>
    brelse(lbuf);
    8000337a:	854a                	mv	a0,s2
    8000337c:	fffff097          	auipc	ra,0xfffff
    80003380:	07e080e7          	jalr	126(ra) # 800023fa <brelse>
    brelse(dbuf);
    80003384:	8526                	mv	a0,s1
    80003386:	fffff097          	auipc	ra,0xfffff
    8000338a:	074080e7          	jalr	116(ra) # 800023fa <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000338e:	2a05                	addiw	s4,s4,1
    80003390:	0a91                	addi	s5,s5,4
    80003392:	02c9a783          	lw	a5,44(s3)
    80003396:	04fa5e63          	bge	s4,a5,800033f2 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000339a:	0189a583          	lw	a1,24(s3)
    8000339e:	014585bb          	addw	a1,a1,s4
    800033a2:	2585                	addiw	a1,a1,1
    800033a4:	0289a503          	lw	a0,40(s3)
    800033a8:	fffff097          	auipc	ra,0xfffff
    800033ac:	f22080e7          	jalr	-222(ra) # 800022ca <bread>
    800033b0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800033b2:	000aa583          	lw	a1,0(s5)
    800033b6:	0289a503          	lw	a0,40(s3)
    800033ba:	fffff097          	auipc	ra,0xfffff
    800033be:	f10080e7          	jalr	-240(ra) # 800022ca <bread>
    800033c2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800033c4:	40000613          	li	a2,1024
    800033c8:	05890593          	addi	a1,s2,88
    800033cc:	05850513          	addi	a0,a0,88
    800033d0:	ffffd097          	auipc	ra,0xffffd
    800033d4:	e06080e7          	jalr	-506(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800033d8:	8526                	mv	a0,s1
    800033da:	fffff097          	auipc	ra,0xfffff
    800033de:	fe2080e7          	jalr	-30(ra) # 800023bc <bwrite>
    if(recovering == 0)
    800033e2:	f80b1ce3          	bnez	s6,8000337a <install_trans+0x36>
      bunpin(dbuf);
    800033e6:	8526                	mv	a0,s1
    800033e8:	fffff097          	auipc	ra,0xfffff
    800033ec:	0ec080e7          	jalr	236(ra) # 800024d4 <bunpin>
    800033f0:	b769                	j	8000337a <install_trans+0x36>
}
    800033f2:	70e2                	ld	ra,56(sp)
    800033f4:	7442                	ld	s0,48(sp)
    800033f6:	74a2                	ld	s1,40(sp)
    800033f8:	7902                	ld	s2,32(sp)
    800033fa:	69e2                	ld	s3,24(sp)
    800033fc:	6a42                	ld	s4,16(sp)
    800033fe:	6aa2                	ld	s5,8(sp)
    80003400:	6b02                	ld	s6,0(sp)
    80003402:	6121                	addi	sp,sp,64
    80003404:	8082                	ret
    80003406:	8082                	ret

0000000080003408 <initlog>:
{
    80003408:	7179                	addi	sp,sp,-48
    8000340a:	f406                	sd	ra,40(sp)
    8000340c:	f022                	sd	s0,32(sp)
    8000340e:	ec26                	sd	s1,24(sp)
    80003410:	e84a                	sd	s2,16(sp)
    80003412:	e44e                	sd	s3,8(sp)
    80003414:	1800                	addi	s0,sp,48
    80003416:	892a                	mv	s2,a0
    80003418:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000341a:	00015497          	auipc	s1,0x15
    8000341e:	4b648493          	addi	s1,s1,1206 # 800188d0 <log>
    80003422:	00005597          	auipc	a1,0x5
    80003426:	18658593          	addi	a1,a1,390 # 800085a8 <syscalls+0x1d8>
    8000342a:	8526                	mv	a0,s1
    8000342c:	00003097          	auipc	ra,0x3
    80003430:	c18080e7          	jalr	-1000(ra) # 80006044 <initlock>
  log.start = sb->logstart;
    80003434:	0149a583          	lw	a1,20(s3)
    80003438:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000343a:	0109a783          	lw	a5,16(s3)
    8000343e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003440:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003444:	854a                	mv	a0,s2
    80003446:	fffff097          	auipc	ra,0xfffff
    8000344a:	e84080e7          	jalr	-380(ra) # 800022ca <bread>
  log.lh.n = lh->n;
    8000344e:	4d34                	lw	a3,88(a0)
    80003450:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003452:	02d05663          	blez	a3,8000347e <initlog+0x76>
    80003456:	05c50793          	addi	a5,a0,92
    8000345a:	00015717          	auipc	a4,0x15
    8000345e:	4a670713          	addi	a4,a4,1190 # 80018900 <log+0x30>
    80003462:	36fd                	addiw	a3,a3,-1
    80003464:	02069613          	slli	a2,a3,0x20
    80003468:	01e65693          	srli	a3,a2,0x1e
    8000346c:	06050613          	addi	a2,a0,96
    80003470:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003472:	4390                	lw	a2,0(a5)
    80003474:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003476:	0791                	addi	a5,a5,4
    80003478:	0711                	addi	a4,a4,4
    8000347a:	fed79ce3          	bne	a5,a3,80003472 <initlog+0x6a>
  brelse(buf);
    8000347e:	fffff097          	auipc	ra,0xfffff
    80003482:	f7c080e7          	jalr	-132(ra) # 800023fa <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003486:	4505                	li	a0,1
    80003488:	00000097          	auipc	ra,0x0
    8000348c:	ebc080e7          	jalr	-324(ra) # 80003344 <install_trans>
  log.lh.n = 0;
    80003490:	00015797          	auipc	a5,0x15
    80003494:	4607a623          	sw	zero,1132(a5) # 800188fc <log+0x2c>
  write_head(); // clear the log
    80003498:	00000097          	auipc	ra,0x0
    8000349c:	e30080e7          	jalr	-464(ra) # 800032c8 <write_head>
}
    800034a0:	70a2                	ld	ra,40(sp)
    800034a2:	7402                	ld	s0,32(sp)
    800034a4:	64e2                	ld	s1,24(sp)
    800034a6:	6942                	ld	s2,16(sp)
    800034a8:	69a2                	ld	s3,8(sp)
    800034aa:	6145                	addi	sp,sp,48
    800034ac:	8082                	ret

00000000800034ae <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800034ae:	1101                	addi	sp,sp,-32
    800034b0:	ec06                	sd	ra,24(sp)
    800034b2:	e822                	sd	s0,16(sp)
    800034b4:	e426                	sd	s1,8(sp)
    800034b6:	e04a                	sd	s2,0(sp)
    800034b8:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800034ba:	00015517          	auipc	a0,0x15
    800034be:	41650513          	addi	a0,a0,1046 # 800188d0 <log>
    800034c2:	00003097          	auipc	ra,0x3
    800034c6:	c12080e7          	jalr	-1006(ra) # 800060d4 <acquire>
  while(1){
    if(log.committing){
    800034ca:	00015497          	auipc	s1,0x15
    800034ce:	40648493          	addi	s1,s1,1030 # 800188d0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034d2:	4979                	li	s2,30
    800034d4:	a039                	j	800034e2 <begin_op+0x34>
      sleep(&log, &log.lock);
    800034d6:	85a6                	mv	a1,s1
    800034d8:	8526                	mv	a0,s1
    800034da:	ffffe097          	auipc	ra,0xffffe
    800034de:	022080e7          	jalr	34(ra) # 800014fc <sleep>
    if(log.committing){
    800034e2:	50dc                	lw	a5,36(s1)
    800034e4:	fbed                	bnez	a5,800034d6 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034e6:	5098                	lw	a4,32(s1)
    800034e8:	2705                	addiw	a4,a4,1
    800034ea:	0007069b          	sext.w	a3,a4
    800034ee:	0027179b          	slliw	a5,a4,0x2
    800034f2:	9fb9                	addw	a5,a5,a4
    800034f4:	0017979b          	slliw	a5,a5,0x1
    800034f8:	54d8                	lw	a4,44(s1)
    800034fa:	9fb9                	addw	a5,a5,a4
    800034fc:	00f95963          	bge	s2,a5,8000350e <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003500:	85a6                	mv	a1,s1
    80003502:	8526                	mv	a0,s1
    80003504:	ffffe097          	auipc	ra,0xffffe
    80003508:	ff8080e7          	jalr	-8(ra) # 800014fc <sleep>
    8000350c:	bfd9                	j	800034e2 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000350e:	00015517          	auipc	a0,0x15
    80003512:	3c250513          	addi	a0,a0,962 # 800188d0 <log>
    80003516:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003518:	00003097          	auipc	ra,0x3
    8000351c:	c70080e7          	jalr	-912(ra) # 80006188 <release>
      break;
    }
  }
}
    80003520:	60e2                	ld	ra,24(sp)
    80003522:	6442                	ld	s0,16(sp)
    80003524:	64a2                	ld	s1,8(sp)
    80003526:	6902                	ld	s2,0(sp)
    80003528:	6105                	addi	sp,sp,32
    8000352a:	8082                	ret

000000008000352c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000352c:	7139                	addi	sp,sp,-64
    8000352e:	fc06                	sd	ra,56(sp)
    80003530:	f822                	sd	s0,48(sp)
    80003532:	f426                	sd	s1,40(sp)
    80003534:	f04a                	sd	s2,32(sp)
    80003536:	ec4e                	sd	s3,24(sp)
    80003538:	e852                	sd	s4,16(sp)
    8000353a:	e456                	sd	s5,8(sp)
    8000353c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000353e:	00015497          	auipc	s1,0x15
    80003542:	39248493          	addi	s1,s1,914 # 800188d0 <log>
    80003546:	8526                	mv	a0,s1
    80003548:	00003097          	auipc	ra,0x3
    8000354c:	b8c080e7          	jalr	-1140(ra) # 800060d4 <acquire>
  log.outstanding -= 1;
    80003550:	509c                	lw	a5,32(s1)
    80003552:	37fd                	addiw	a5,a5,-1
    80003554:	0007891b          	sext.w	s2,a5
    80003558:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000355a:	50dc                	lw	a5,36(s1)
    8000355c:	e7b9                	bnez	a5,800035aa <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000355e:	04091e63          	bnez	s2,800035ba <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003562:	00015497          	auipc	s1,0x15
    80003566:	36e48493          	addi	s1,s1,878 # 800188d0 <log>
    8000356a:	4785                	li	a5,1
    8000356c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000356e:	8526                	mv	a0,s1
    80003570:	00003097          	auipc	ra,0x3
    80003574:	c18080e7          	jalr	-1000(ra) # 80006188 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003578:	54dc                	lw	a5,44(s1)
    8000357a:	06f04763          	bgtz	a5,800035e8 <end_op+0xbc>
    acquire(&log.lock);
    8000357e:	00015497          	auipc	s1,0x15
    80003582:	35248493          	addi	s1,s1,850 # 800188d0 <log>
    80003586:	8526                	mv	a0,s1
    80003588:	00003097          	auipc	ra,0x3
    8000358c:	b4c080e7          	jalr	-1204(ra) # 800060d4 <acquire>
    log.committing = 0;
    80003590:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003594:	8526                	mv	a0,s1
    80003596:	ffffe097          	auipc	ra,0xffffe
    8000359a:	fca080e7          	jalr	-54(ra) # 80001560 <wakeup>
    release(&log.lock);
    8000359e:	8526                	mv	a0,s1
    800035a0:	00003097          	auipc	ra,0x3
    800035a4:	be8080e7          	jalr	-1048(ra) # 80006188 <release>
}
    800035a8:	a03d                	j	800035d6 <end_op+0xaa>
    panic("log.committing");
    800035aa:	00005517          	auipc	a0,0x5
    800035ae:	00650513          	addi	a0,a0,6 # 800085b0 <syscalls+0x1e0>
    800035b2:	00002097          	auipc	ra,0x2
    800035b6:	5ea080e7          	jalr	1514(ra) # 80005b9c <panic>
    wakeup(&log);
    800035ba:	00015497          	auipc	s1,0x15
    800035be:	31648493          	addi	s1,s1,790 # 800188d0 <log>
    800035c2:	8526                	mv	a0,s1
    800035c4:	ffffe097          	auipc	ra,0xffffe
    800035c8:	f9c080e7          	jalr	-100(ra) # 80001560 <wakeup>
  release(&log.lock);
    800035cc:	8526                	mv	a0,s1
    800035ce:	00003097          	auipc	ra,0x3
    800035d2:	bba080e7          	jalr	-1094(ra) # 80006188 <release>
}
    800035d6:	70e2                	ld	ra,56(sp)
    800035d8:	7442                	ld	s0,48(sp)
    800035da:	74a2                	ld	s1,40(sp)
    800035dc:	7902                	ld	s2,32(sp)
    800035de:	69e2                	ld	s3,24(sp)
    800035e0:	6a42                	ld	s4,16(sp)
    800035e2:	6aa2                	ld	s5,8(sp)
    800035e4:	6121                	addi	sp,sp,64
    800035e6:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800035e8:	00015a97          	auipc	s5,0x15
    800035ec:	318a8a93          	addi	s5,s5,792 # 80018900 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800035f0:	00015a17          	auipc	s4,0x15
    800035f4:	2e0a0a13          	addi	s4,s4,736 # 800188d0 <log>
    800035f8:	018a2583          	lw	a1,24(s4)
    800035fc:	012585bb          	addw	a1,a1,s2
    80003600:	2585                	addiw	a1,a1,1
    80003602:	028a2503          	lw	a0,40(s4)
    80003606:	fffff097          	auipc	ra,0xfffff
    8000360a:	cc4080e7          	jalr	-828(ra) # 800022ca <bread>
    8000360e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003610:	000aa583          	lw	a1,0(s5)
    80003614:	028a2503          	lw	a0,40(s4)
    80003618:	fffff097          	auipc	ra,0xfffff
    8000361c:	cb2080e7          	jalr	-846(ra) # 800022ca <bread>
    80003620:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003622:	40000613          	li	a2,1024
    80003626:	05850593          	addi	a1,a0,88
    8000362a:	05848513          	addi	a0,s1,88
    8000362e:	ffffd097          	auipc	ra,0xffffd
    80003632:	ba8080e7          	jalr	-1112(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003636:	8526                	mv	a0,s1
    80003638:	fffff097          	auipc	ra,0xfffff
    8000363c:	d84080e7          	jalr	-636(ra) # 800023bc <bwrite>
    brelse(from);
    80003640:	854e                	mv	a0,s3
    80003642:	fffff097          	auipc	ra,0xfffff
    80003646:	db8080e7          	jalr	-584(ra) # 800023fa <brelse>
    brelse(to);
    8000364a:	8526                	mv	a0,s1
    8000364c:	fffff097          	auipc	ra,0xfffff
    80003650:	dae080e7          	jalr	-594(ra) # 800023fa <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003654:	2905                	addiw	s2,s2,1
    80003656:	0a91                	addi	s5,s5,4
    80003658:	02ca2783          	lw	a5,44(s4)
    8000365c:	f8f94ee3          	blt	s2,a5,800035f8 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003660:	00000097          	auipc	ra,0x0
    80003664:	c68080e7          	jalr	-920(ra) # 800032c8 <write_head>
    install_trans(0); // Now install writes to home locations
    80003668:	4501                	li	a0,0
    8000366a:	00000097          	auipc	ra,0x0
    8000366e:	cda080e7          	jalr	-806(ra) # 80003344 <install_trans>
    log.lh.n = 0;
    80003672:	00015797          	auipc	a5,0x15
    80003676:	2807a523          	sw	zero,650(a5) # 800188fc <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000367a:	00000097          	auipc	ra,0x0
    8000367e:	c4e080e7          	jalr	-946(ra) # 800032c8 <write_head>
    80003682:	bdf5                	j	8000357e <end_op+0x52>

0000000080003684 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003684:	1101                	addi	sp,sp,-32
    80003686:	ec06                	sd	ra,24(sp)
    80003688:	e822                	sd	s0,16(sp)
    8000368a:	e426                	sd	s1,8(sp)
    8000368c:	e04a                	sd	s2,0(sp)
    8000368e:	1000                	addi	s0,sp,32
    80003690:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003692:	00015917          	auipc	s2,0x15
    80003696:	23e90913          	addi	s2,s2,574 # 800188d0 <log>
    8000369a:	854a                	mv	a0,s2
    8000369c:	00003097          	auipc	ra,0x3
    800036a0:	a38080e7          	jalr	-1480(ra) # 800060d4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800036a4:	02c92603          	lw	a2,44(s2)
    800036a8:	47f5                	li	a5,29
    800036aa:	06c7c563          	blt	a5,a2,80003714 <log_write+0x90>
    800036ae:	00015797          	auipc	a5,0x15
    800036b2:	23e7a783          	lw	a5,574(a5) # 800188ec <log+0x1c>
    800036b6:	37fd                	addiw	a5,a5,-1
    800036b8:	04f65e63          	bge	a2,a5,80003714 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800036bc:	00015797          	auipc	a5,0x15
    800036c0:	2347a783          	lw	a5,564(a5) # 800188f0 <log+0x20>
    800036c4:	06f05063          	blez	a5,80003724 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800036c8:	4781                	li	a5,0
    800036ca:	06c05563          	blez	a2,80003734 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036ce:	44cc                	lw	a1,12(s1)
    800036d0:	00015717          	auipc	a4,0x15
    800036d4:	23070713          	addi	a4,a4,560 # 80018900 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800036d8:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036da:	4314                	lw	a3,0(a4)
    800036dc:	04b68c63          	beq	a3,a1,80003734 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800036e0:	2785                	addiw	a5,a5,1
    800036e2:	0711                	addi	a4,a4,4
    800036e4:	fef61be3          	bne	a2,a5,800036da <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800036e8:	0621                	addi	a2,a2,8
    800036ea:	060a                	slli	a2,a2,0x2
    800036ec:	00015797          	auipc	a5,0x15
    800036f0:	1e478793          	addi	a5,a5,484 # 800188d0 <log>
    800036f4:	97b2                	add	a5,a5,a2
    800036f6:	44d8                	lw	a4,12(s1)
    800036f8:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800036fa:	8526                	mv	a0,s1
    800036fc:	fffff097          	auipc	ra,0xfffff
    80003700:	d9c080e7          	jalr	-612(ra) # 80002498 <bpin>
    log.lh.n++;
    80003704:	00015717          	auipc	a4,0x15
    80003708:	1cc70713          	addi	a4,a4,460 # 800188d0 <log>
    8000370c:	575c                	lw	a5,44(a4)
    8000370e:	2785                	addiw	a5,a5,1
    80003710:	d75c                	sw	a5,44(a4)
    80003712:	a82d                	j	8000374c <log_write+0xc8>
    panic("too big a transaction");
    80003714:	00005517          	auipc	a0,0x5
    80003718:	eac50513          	addi	a0,a0,-340 # 800085c0 <syscalls+0x1f0>
    8000371c:	00002097          	auipc	ra,0x2
    80003720:	480080e7          	jalr	1152(ra) # 80005b9c <panic>
    panic("log_write outside of trans");
    80003724:	00005517          	auipc	a0,0x5
    80003728:	eb450513          	addi	a0,a0,-332 # 800085d8 <syscalls+0x208>
    8000372c:	00002097          	auipc	ra,0x2
    80003730:	470080e7          	jalr	1136(ra) # 80005b9c <panic>
  log.lh.block[i] = b->blockno;
    80003734:	00878693          	addi	a3,a5,8
    80003738:	068a                	slli	a3,a3,0x2
    8000373a:	00015717          	auipc	a4,0x15
    8000373e:	19670713          	addi	a4,a4,406 # 800188d0 <log>
    80003742:	9736                	add	a4,a4,a3
    80003744:	44d4                	lw	a3,12(s1)
    80003746:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003748:	faf609e3          	beq	a2,a5,800036fa <log_write+0x76>
  }
  release(&log.lock);
    8000374c:	00015517          	auipc	a0,0x15
    80003750:	18450513          	addi	a0,a0,388 # 800188d0 <log>
    80003754:	00003097          	auipc	ra,0x3
    80003758:	a34080e7          	jalr	-1484(ra) # 80006188 <release>
}
    8000375c:	60e2                	ld	ra,24(sp)
    8000375e:	6442                	ld	s0,16(sp)
    80003760:	64a2                	ld	s1,8(sp)
    80003762:	6902                	ld	s2,0(sp)
    80003764:	6105                	addi	sp,sp,32
    80003766:	8082                	ret

0000000080003768 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003768:	1101                	addi	sp,sp,-32
    8000376a:	ec06                	sd	ra,24(sp)
    8000376c:	e822                	sd	s0,16(sp)
    8000376e:	e426                	sd	s1,8(sp)
    80003770:	e04a                	sd	s2,0(sp)
    80003772:	1000                	addi	s0,sp,32
    80003774:	84aa                	mv	s1,a0
    80003776:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003778:	00005597          	auipc	a1,0x5
    8000377c:	e8058593          	addi	a1,a1,-384 # 800085f8 <syscalls+0x228>
    80003780:	0521                	addi	a0,a0,8
    80003782:	00003097          	auipc	ra,0x3
    80003786:	8c2080e7          	jalr	-1854(ra) # 80006044 <initlock>
  lk->name = name;
    8000378a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000378e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003792:	0204a423          	sw	zero,40(s1)
}
    80003796:	60e2                	ld	ra,24(sp)
    80003798:	6442                	ld	s0,16(sp)
    8000379a:	64a2                	ld	s1,8(sp)
    8000379c:	6902                	ld	s2,0(sp)
    8000379e:	6105                	addi	sp,sp,32
    800037a0:	8082                	ret

00000000800037a2 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800037a2:	1101                	addi	sp,sp,-32
    800037a4:	ec06                	sd	ra,24(sp)
    800037a6:	e822                	sd	s0,16(sp)
    800037a8:	e426                	sd	s1,8(sp)
    800037aa:	e04a                	sd	s2,0(sp)
    800037ac:	1000                	addi	s0,sp,32
    800037ae:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037b0:	00850913          	addi	s2,a0,8
    800037b4:	854a                	mv	a0,s2
    800037b6:	00003097          	auipc	ra,0x3
    800037ba:	91e080e7          	jalr	-1762(ra) # 800060d4 <acquire>
  while (lk->locked) {
    800037be:	409c                	lw	a5,0(s1)
    800037c0:	cb89                	beqz	a5,800037d2 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800037c2:	85ca                	mv	a1,s2
    800037c4:	8526                	mv	a0,s1
    800037c6:	ffffe097          	auipc	ra,0xffffe
    800037ca:	d36080e7          	jalr	-714(ra) # 800014fc <sleep>
  while (lk->locked) {
    800037ce:	409c                	lw	a5,0(s1)
    800037d0:	fbed                	bnez	a5,800037c2 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800037d2:	4785                	li	a5,1
    800037d4:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800037d6:	ffffd097          	auipc	ra,0xffffd
    800037da:	67e080e7          	jalr	1662(ra) # 80000e54 <myproc>
    800037de:	591c                	lw	a5,48(a0)
    800037e0:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800037e2:	854a                	mv	a0,s2
    800037e4:	00003097          	auipc	ra,0x3
    800037e8:	9a4080e7          	jalr	-1628(ra) # 80006188 <release>
}
    800037ec:	60e2                	ld	ra,24(sp)
    800037ee:	6442                	ld	s0,16(sp)
    800037f0:	64a2                	ld	s1,8(sp)
    800037f2:	6902                	ld	s2,0(sp)
    800037f4:	6105                	addi	sp,sp,32
    800037f6:	8082                	ret

00000000800037f8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800037f8:	1101                	addi	sp,sp,-32
    800037fa:	ec06                	sd	ra,24(sp)
    800037fc:	e822                	sd	s0,16(sp)
    800037fe:	e426                	sd	s1,8(sp)
    80003800:	e04a                	sd	s2,0(sp)
    80003802:	1000                	addi	s0,sp,32
    80003804:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003806:	00850913          	addi	s2,a0,8
    8000380a:	854a                	mv	a0,s2
    8000380c:	00003097          	auipc	ra,0x3
    80003810:	8c8080e7          	jalr	-1848(ra) # 800060d4 <acquire>
  lk->locked = 0;
    80003814:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003818:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000381c:	8526                	mv	a0,s1
    8000381e:	ffffe097          	auipc	ra,0xffffe
    80003822:	d42080e7          	jalr	-702(ra) # 80001560 <wakeup>
  release(&lk->lk);
    80003826:	854a                	mv	a0,s2
    80003828:	00003097          	auipc	ra,0x3
    8000382c:	960080e7          	jalr	-1696(ra) # 80006188 <release>
}
    80003830:	60e2                	ld	ra,24(sp)
    80003832:	6442                	ld	s0,16(sp)
    80003834:	64a2                	ld	s1,8(sp)
    80003836:	6902                	ld	s2,0(sp)
    80003838:	6105                	addi	sp,sp,32
    8000383a:	8082                	ret

000000008000383c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000383c:	7179                	addi	sp,sp,-48
    8000383e:	f406                	sd	ra,40(sp)
    80003840:	f022                	sd	s0,32(sp)
    80003842:	ec26                	sd	s1,24(sp)
    80003844:	e84a                	sd	s2,16(sp)
    80003846:	e44e                	sd	s3,8(sp)
    80003848:	1800                	addi	s0,sp,48
    8000384a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000384c:	00850913          	addi	s2,a0,8
    80003850:	854a                	mv	a0,s2
    80003852:	00003097          	auipc	ra,0x3
    80003856:	882080e7          	jalr	-1918(ra) # 800060d4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000385a:	409c                	lw	a5,0(s1)
    8000385c:	ef99                	bnez	a5,8000387a <holdingsleep+0x3e>
    8000385e:	4481                	li	s1,0
  release(&lk->lk);
    80003860:	854a                	mv	a0,s2
    80003862:	00003097          	auipc	ra,0x3
    80003866:	926080e7          	jalr	-1754(ra) # 80006188 <release>
  return r;
}
    8000386a:	8526                	mv	a0,s1
    8000386c:	70a2                	ld	ra,40(sp)
    8000386e:	7402                	ld	s0,32(sp)
    80003870:	64e2                	ld	s1,24(sp)
    80003872:	6942                	ld	s2,16(sp)
    80003874:	69a2                	ld	s3,8(sp)
    80003876:	6145                	addi	sp,sp,48
    80003878:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000387a:	0284a983          	lw	s3,40(s1)
    8000387e:	ffffd097          	auipc	ra,0xffffd
    80003882:	5d6080e7          	jalr	1494(ra) # 80000e54 <myproc>
    80003886:	5904                	lw	s1,48(a0)
    80003888:	413484b3          	sub	s1,s1,s3
    8000388c:	0014b493          	seqz	s1,s1
    80003890:	bfc1                	j	80003860 <holdingsleep+0x24>

0000000080003892 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003892:	1141                	addi	sp,sp,-16
    80003894:	e406                	sd	ra,8(sp)
    80003896:	e022                	sd	s0,0(sp)
    80003898:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000389a:	00005597          	auipc	a1,0x5
    8000389e:	d6e58593          	addi	a1,a1,-658 # 80008608 <syscalls+0x238>
    800038a2:	00015517          	auipc	a0,0x15
    800038a6:	17650513          	addi	a0,a0,374 # 80018a18 <ftable>
    800038aa:	00002097          	auipc	ra,0x2
    800038ae:	79a080e7          	jalr	1946(ra) # 80006044 <initlock>
}
    800038b2:	60a2                	ld	ra,8(sp)
    800038b4:	6402                	ld	s0,0(sp)
    800038b6:	0141                	addi	sp,sp,16
    800038b8:	8082                	ret

00000000800038ba <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800038ba:	1101                	addi	sp,sp,-32
    800038bc:	ec06                	sd	ra,24(sp)
    800038be:	e822                	sd	s0,16(sp)
    800038c0:	e426                	sd	s1,8(sp)
    800038c2:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800038c4:	00015517          	auipc	a0,0x15
    800038c8:	15450513          	addi	a0,a0,340 # 80018a18 <ftable>
    800038cc:	00003097          	auipc	ra,0x3
    800038d0:	808080e7          	jalr	-2040(ra) # 800060d4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038d4:	00015497          	auipc	s1,0x15
    800038d8:	15c48493          	addi	s1,s1,348 # 80018a30 <ftable+0x18>
    800038dc:	00016717          	auipc	a4,0x16
    800038e0:	0f470713          	addi	a4,a4,244 # 800199d0 <disk>
    if(f->ref == 0){
    800038e4:	40dc                	lw	a5,4(s1)
    800038e6:	cf99                	beqz	a5,80003904 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038e8:	02848493          	addi	s1,s1,40
    800038ec:	fee49ce3          	bne	s1,a4,800038e4 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800038f0:	00015517          	auipc	a0,0x15
    800038f4:	12850513          	addi	a0,a0,296 # 80018a18 <ftable>
    800038f8:	00003097          	auipc	ra,0x3
    800038fc:	890080e7          	jalr	-1904(ra) # 80006188 <release>
  return 0;
    80003900:	4481                	li	s1,0
    80003902:	a819                	j	80003918 <filealloc+0x5e>
      f->ref = 1;
    80003904:	4785                	li	a5,1
    80003906:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003908:	00015517          	auipc	a0,0x15
    8000390c:	11050513          	addi	a0,a0,272 # 80018a18 <ftable>
    80003910:	00003097          	auipc	ra,0x3
    80003914:	878080e7          	jalr	-1928(ra) # 80006188 <release>
}
    80003918:	8526                	mv	a0,s1
    8000391a:	60e2                	ld	ra,24(sp)
    8000391c:	6442                	ld	s0,16(sp)
    8000391e:	64a2                	ld	s1,8(sp)
    80003920:	6105                	addi	sp,sp,32
    80003922:	8082                	ret

0000000080003924 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003924:	1101                	addi	sp,sp,-32
    80003926:	ec06                	sd	ra,24(sp)
    80003928:	e822                	sd	s0,16(sp)
    8000392a:	e426                	sd	s1,8(sp)
    8000392c:	1000                	addi	s0,sp,32
    8000392e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003930:	00015517          	auipc	a0,0x15
    80003934:	0e850513          	addi	a0,a0,232 # 80018a18 <ftable>
    80003938:	00002097          	auipc	ra,0x2
    8000393c:	79c080e7          	jalr	1948(ra) # 800060d4 <acquire>
  if(f->ref < 1)
    80003940:	40dc                	lw	a5,4(s1)
    80003942:	02f05263          	blez	a5,80003966 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003946:	2785                	addiw	a5,a5,1
    80003948:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000394a:	00015517          	auipc	a0,0x15
    8000394e:	0ce50513          	addi	a0,a0,206 # 80018a18 <ftable>
    80003952:	00003097          	auipc	ra,0x3
    80003956:	836080e7          	jalr	-1994(ra) # 80006188 <release>
  return f;
}
    8000395a:	8526                	mv	a0,s1
    8000395c:	60e2                	ld	ra,24(sp)
    8000395e:	6442                	ld	s0,16(sp)
    80003960:	64a2                	ld	s1,8(sp)
    80003962:	6105                	addi	sp,sp,32
    80003964:	8082                	ret
    panic("filedup");
    80003966:	00005517          	auipc	a0,0x5
    8000396a:	caa50513          	addi	a0,a0,-854 # 80008610 <syscalls+0x240>
    8000396e:	00002097          	auipc	ra,0x2
    80003972:	22e080e7          	jalr	558(ra) # 80005b9c <panic>

0000000080003976 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003976:	7139                	addi	sp,sp,-64
    80003978:	fc06                	sd	ra,56(sp)
    8000397a:	f822                	sd	s0,48(sp)
    8000397c:	f426                	sd	s1,40(sp)
    8000397e:	f04a                	sd	s2,32(sp)
    80003980:	ec4e                	sd	s3,24(sp)
    80003982:	e852                	sd	s4,16(sp)
    80003984:	e456                	sd	s5,8(sp)
    80003986:	0080                	addi	s0,sp,64
    80003988:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000398a:	00015517          	auipc	a0,0x15
    8000398e:	08e50513          	addi	a0,a0,142 # 80018a18 <ftable>
    80003992:	00002097          	auipc	ra,0x2
    80003996:	742080e7          	jalr	1858(ra) # 800060d4 <acquire>
  if(f->ref < 1)
    8000399a:	40dc                	lw	a5,4(s1)
    8000399c:	06f05163          	blez	a5,800039fe <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800039a0:	37fd                	addiw	a5,a5,-1
    800039a2:	0007871b          	sext.w	a4,a5
    800039a6:	c0dc                	sw	a5,4(s1)
    800039a8:	06e04363          	bgtz	a4,80003a0e <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800039ac:	0004a903          	lw	s2,0(s1)
    800039b0:	0094ca83          	lbu	s5,9(s1)
    800039b4:	0104ba03          	ld	s4,16(s1)
    800039b8:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800039bc:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800039c0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800039c4:	00015517          	auipc	a0,0x15
    800039c8:	05450513          	addi	a0,a0,84 # 80018a18 <ftable>
    800039cc:	00002097          	auipc	ra,0x2
    800039d0:	7bc080e7          	jalr	1980(ra) # 80006188 <release>

  if(ff.type == FD_PIPE){
    800039d4:	4785                	li	a5,1
    800039d6:	04f90d63          	beq	s2,a5,80003a30 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800039da:	3979                	addiw	s2,s2,-2
    800039dc:	4785                	li	a5,1
    800039de:	0527e063          	bltu	a5,s2,80003a1e <fileclose+0xa8>
    begin_op();
    800039e2:	00000097          	auipc	ra,0x0
    800039e6:	acc080e7          	jalr	-1332(ra) # 800034ae <begin_op>
    iput(ff.ip);
    800039ea:	854e                	mv	a0,s3
    800039ec:	fffff097          	auipc	ra,0xfffff
    800039f0:	2b0080e7          	jalr	688(ra) # 80002c9c <iput>
    end_op();
    800039f4:	00000097          	auipc	ra,0x0
    800039f8:	b38080e7          	jalr	-1224(ra) # 8000352c <end_op>
    800039fc:	a00d                	j	80003a1e <fileclose+0xa8>
    panic("fileclose");
    800039fe:	00005517          	auipc	a0,0x5
    80003a02:	c1a50513          	addi	a0,a0,-998 # 80008618 <syscalls+0x248>
    80003a06:	00002097          	auipc	ra,0x2
    80003a0a:	196080e7          	jalr	406(ra) # 80005b9c <panic>
    release(&ftable.lock);
    80003a0e:	00015517          	auipc	a0,0x15
    80003a12:	00a50513          	addi	a0,a0,10 # 80018a18 <ftable>
    80003a16:	00002097          	auipc	ra,0x2
    80003a1a:	772080e7          	jalr	1906(ra) # 80006188 <release>
  }
}
    80003a1e:	70e2                	ld	ra,56(sp)
    80003a20:	7442                	ld	s0,48(sp)
    80003a22:	74a2                	ld	s1,40(sp)
    80003a24:	7902                	ld	s2,32(sp)
    80003a26:	69e2                	ld	s3,24(sp)
    80003a28:	6a42                	ld	s4,16(sp)
    80003a2a:	6aa2                	ld	s5,8(sp)
    80003a2c:	6121                	addi	sp,sp,64
    80003a2e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a30:	85d6                	mv	a1,s5
    80003a32:	8552                	mv	a0,s4
    80003a34:	00000097          	auipc	ra,0x0
    80003a38:	34c080e7          	jalr	844(ra) # 80003d80 <pipeclose>
    80003a3c:	b7cd                	j	80003a1e <fileclose+0xa8>

0000000080003a3e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a3e:	715d                	addi	sp,sp,-80
    80003a40:	e486                	sd	ra,72(sp)
    80003a42:	e0a2                	sd	s0,64(sp)
    80003a44:	fc26                	sd	s1,56(sp)
    80003a46:	f84a                	sd	s2,48(sp)
    80003a48:	f44e                	sd	s3,40(sp)
    80003a4a:	0880                	addi	s0,sp,80
    80003a4c:	84aa                	mv	s1,a0
    80003a4e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003a50:	ffffd097          	auipc	ra,0xffffd
    80003a54:	404080e7          	jalr	1028(ra) # 80000e54 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003a58:	409c                	lw	a5,0(s1)
    80003a5a:	37f9                	addiw	a5,a5,-2
    80003a5c:	4705                	li	a4,1
    80003a5e:	04f76763          	bltu	a4,a5,80003aac <filestat+0x6e>
    80003a62:	892a                	mv	s2,a0
    ilock(f->ip);
    80003a64:	6c88                	ld	a0,24(s1)
    80003a66:	fffff097          	auipc	ra,0xfffff
    80003a6a:	07c080e7          	jalr	124(ra) # 80002ae2 <ilock>
    stati(f->ip, &st);
    80003a6e:	fb840593          	addi	a1,s0,-72
    80003a72:	6c88                	ld	a0,24(s1)
    80003a74:	fffff097          	auipc	ra,0xfffff
    80003a78:	2f8080e7          	jalr	760(ra) # 80002d6c <stati>
    iunlock(f->ip);
    80003a7c:	6c88                	ld	a0,24(s1)
    80003a7e:	fffff097          	auipc	ra,0xfffff
    80003a82:	126080e7          	jalr	294(ra) # 80002ba4 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003a86:	46e1                	li	a3,24
    80003a88:	fb840613          	addi	a2,s0,-72
    80003a8c:	85ce                	mv	a1,s3
    80003a8e:	05093503          	ld	a0,80(s2)
    80003a92:	ffffd097          	auipc	ra,0xffffd
    80003a96:	082080e7          	jalr	130(ra) # 80000b14 <copyout>
    80003a9a:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003a9e:	60a6                	ld	ra,72(sp)
    80003aa0:	6406                	ld	s0,64(sp)
    80003aa2:	74e2                	ld	s1,56(sp)
    80003aa4:	7942                	ld	s2,48(sp)
    80003aa6:	79a2                	ld	s3,40(sp)
    80003aa8:	6161                	addi	sp,sp,80
    80003aaa:	8082                	ret
  return -1;
    80003aac:	557d                	li	a0,-1
    80003aae:	bfc5                	j	80003a9e <filestat+0x60>

0000000080003ab0 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003ab0:	7179                	addi	sp,sp,-48
    80003ab2:	f406                	sd	ra,40(sp)
    80003ab4:	f022                	sd	s0,32(sp)
    80003ab6:	ec26                	sd	s1,24(sp)
    80003ab8:	e84a                	sd	s2,16(sp)
    80003aba:	e44e                	sd	s3,8(sp)
    80003abc:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003abe:	00854783          	lbu	a5,8(a0)
    80003ac2:	c3d5                	beqz	a5,80003b66 <fileread+0xb6>
    80003ac4:	84aa                	mv	s1,a0
    80003ac6:	89ae                	mv	s3,a1
    80003ac8:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003aca:	411c                	lw	a5,0(a0)
    80003acc:	4705                	li	a4,1
    80003ace:	04e78963          	beq	a5,a4,80003b20 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ad2:	470d                	li	a4,3
    80003ad4:	04e78d63          	beq	a5,a4,80003b2e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ad8:	4709                	li	a4,2
    80003ada:	06e79e63          	bne	a5,a4,80003b56 <fileread+0xa6>
    ilock(f->ip);
    80003ade:	6d08                	ld	a0,24(a0)
    80003ae0:	fffff097          	auipc	ra,0xfffff
    80003ae4:	002080e7          	jalr	2(ra) # 80002ae2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003ae8:	874a                	mv	a4,s2
    80003aea:	5094                	lw	a3,32(s1)
    80003aec:	864e                	mv	a2,s3
    80003aee:	4585                	li	a1,1
    80003af0:	6c88                	ld	a0,24(s1)
    80003af2:	fffff097          	auipc	ra,0xfffff
    80003af6:	2a4080e7          	jalr	676(ra) # 80002d96 <readi>
    80003afa:	892a                	mv	s2,a0
    80003afc:	00a05563          	blez	a0,80003b06 <fileread+0x56>
      f->off += r;
    80003b00:	509c                	lw	a5,32(s1)
    80003b02:	9fa9                	addw	a5,a5,a0
    80003b04:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003b06:	6c88                	ld	a0,24(s1)
    80003b08:	fffff097          	auipc	ra,0xfffff
    80003b0c:	09c080e7          	jalr	156(ra) # 80002ba4 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003b10:	854a                	mv	a0,s2
    80003b12:	70a2                	ld	ra,40(sp)
    80003b14:	7402                	ld	s0,32(sp)
    80003b16:	64e2                	ld	s1,24(sp)
    80003b18:	6942                	ld	s2,16(sp)
    80003b1a:	69a2                	ld	s3,8(sp)
    80003b1c:	6145                	addi	sp,sp,48
    80003b1e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b20:	6908                	ld	a0,16(a0)
    80003b22:	00000097          	auipc	ra,0x0
    80003b26:	3c6080e7          	jalr	966(ra) # 80003ee8 <piperead>
    80003b2a:	892a                	mv	s2,a0
    80003b2c:	b7d5                	j	80003b10 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b2e:	02451783          	lh	a5,36(a0)
    80003b32:	03079693          	slli	a3,a5,0x30
    80003b36:	92c1                	srli	a3,a3,0x30
    80003b38:	4725                	li	a4,9
    80003b3a:	02d76863          	bltu	a4,a3,80003b6a <fileread+0xba>
    80003b3e:	0792                	slli	a5,a5,0x4
    80003b40:	00015717          	auipc	a4,0x15
    80003b44:	e3870713          	addi	a4,a4,-456 # 80018978 <devsw>
    80003b48:	97ba                	add	a5,a5,a4
    80003b4a:	639c                	ld	a5,0(a5)
    80003b4c:	c38d                	beqz	a5,80003b6e <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003b4e:	4505                	li	a0,1
    80003b50:	9782                	jalr	a5
    80003b52:	892a                	mv	s2,a0
    80003b54:	bf75                	j	80003b10 <fileread+0x60>
    panic("fileread");
    80003b56:	00005517          	auipc	a0,0x5
    80003b5a:	ad250513          	addi	a0,a0,-1326 # 80008628 <syscalls+0x258>
    80003b5e:	00002097          	auipc	ra,0x2
    80003b62:	03e080e7          	jalr	62(ra) # 80005b9c <panic>
    return -1;
    80003b66:	597d                	li	s2,-1
    80003b68:	b765                	j	80003b10 <fileread+0x60>
      return -1;
    80003b6a:	597d                	li	s2,-1
    80003b6c:	b755                	j	80003b10 <fileread+0x60>
    80003b6e:	597d                	li	s2,-1
    80003b70:	b745                	j	80003b10 <fileread+0x60>

0000000080003b72 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003b72:	715d                	addi	sp,sp,-80
    80003b74:	e486                	sd	ra,72(sp)
    80003b76:	e0a2                	sd	s0,64(sp)
    80003b78:	fc26                	sd	s1,56(sp)
    80003b7a:	f84a                	sd	s2,48(sp)
    80003b7c:	f44e                	sd	s3,40(sp)
    80003b7e:	f052                	sd	s4,32(sp)
    80003b80:	ec56                	sd	s5,24(sp)
    80003b82:	e85a                	sd	s6,16(sp)
    80003b84:	e45e                	sd	s7,8(sp)
    80003b86:	e062                	sd	s8,0(sp)
    80003b88:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003b8a:	00954783          	lbu	a5,9(a0)
    80003b8e:	10078663          	beqz	a5,80003c9a <filewrite+0x128>
    80003b92:	892a                	mv	s2,a0
    80003b94:	8b2e                	mv	s6,a1
    80003b96:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b98:	411c                	lw	a5,0(a0)
    80003b9a:	4705                	li	a4,1
    80003b9c:	02e78263          	beq	a5,a4,80003bc0 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ba0:	470d                	li	a4,3
    80003ba2:	02e78663          	beq	a5,a4,80003bce <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ba6:	4709                	li	a4,2
    80003ba8:	0ee79163          	bne	a5,a4,80003c8a <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003bac:	0ac05d63          	blez	a2,80003c66 <filewrite+0xf4>
    int i = 0;
    80003bb0:	4981                	li	s3,0
    80003bb2:	6b85                	lui	s7,0x1
    80003bb4:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003bb8:	6c05                	lui	s8,0x1
    80003bba:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003bbe:	a861                	j	80003c56 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003bc0:	6908                	ld	a0,16(a0)
    80003bc2:	00000097          	auipc	ra,0x0
    80003bc6:	22e080e7          	jalr	558(ra) # 80003df0 <pipewrite>
    80003bca:	8a2a                	mv	s4,a0
    80003bcc:	a045                	j	80003c6c <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003bce:	02451783          	lh	a5,36(a0)
    80003bd2:	03079693          	slli	a3,a5,0x30
    80003bd6:	92c1                	srli	a3,a3,0x30
    80003bd8:	4725                	li	a4,9
    80003bda:	0cd76263          	bltu	a4,a3,80003c9e <filewrite+0x12c>
    80003bde:	0792                	slli	a5,a5,0x4
    80003be0:	00015717          	auipc	a4,0x15
    80003be4:	d9870713          	addi	a4,a4,-616 # 80018978 <devsw>
    80003be8:	97ba                	add	a5,a5,a4
    80003bea:	679c                	ld	a5,8(a5)
    80003bec:	cbdd                	beqz	a5,80003ca2 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003bee:	4505                	li	a0,1
    80003bf0:	9782                	jalr	a5
    80003bf2:	8a2a                	mv	s4,a0
    80003bf4:	a8a5                	j	80003c6c <filewrite+0xfa>
    80003bf6:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003bfa:	00000097          	auipc	ra,0x0
    80003bfe:	8b4080e7          	jalr	-1868(ra) # 800034ae <begin_op>
      ilock(f->ip);
    80003c02:	01893503          	ld	a0,24(s2)
    80003c06:	fffff097          	auipc	ra,0xfffff
    80003c0a:	edc080e7          	jalr	-292(ra) # 80002ae2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c0e:	8756                	mv	a4,s5
    80003c10:	02092683          	lw	a3,32(s2)
    80003c14:	01698633          	add	a2,s3,s6
    80003c18:	4585                	li	a1,1
    80003c1a:	01893503          	ld	a0,24(s2)
    80003c1e:	fffff097          	auipc	ra,0xfffff
    80003c22:	270080e7          	jalr	624(ra) # 80002e8e <writei>
    80003c26:	84aa                	mv	s1,a0
    80003c28:	00a05763          	blez	a0,80003c36 <filewrite+0xc4>
        f->off += r;
    80003c2c:	02092783          	lw	a5,32(s2)
    80003c30:	9fa9                	addw	a5,a5,a0
    80003c32:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003c36:	01893503          	ld	a0,24(s2)
    80003c3a:	fffff097          	auipc	ra,0xfffff
    80003c3e:	f6a080e7          	jalr	-150(ra) # 80002ba4 <iunlock>
      end_op();
    80003c42:	00000097          	auipc	ra,0x0
    80003c46:	8ea080e7          	jalr	-1814(ra) # 8000352c <end_op>

      if(r != n1){
    80003c4a:	009a9f63          	bne	s5,s1,80003c68 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003c4e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003c52:	0149db63          	bge	s3,s4,80003c68 <filewrite+0xf6>
      int n1 = n - i;
    80003c56:	413a04bb          	subw	s1,s4,s3
    80003c5a:	0004879b          	sext.w	a5,s1
    80003c5e:	f8fbdce3          	bge	s7,a5,80003bf6 <filewrite+0x84>
    80003c62:	84e2                	mv	s1,s8
    80003c64:	bf49                	j	80003bf6 <filewrite+0x84>
    int i = 0;
    80003c66:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003c68:	013a1f63          	bne	s4,s3,80003c86 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003c6c:	8552                	mv	a0,s4
    80003c6e:	60a6                	ld	ra,72(sp)
    80003c70:	6406                	ld	s0,64(sp)
    80003c72:	74e2                	ld	s1,56(sp)
    80003c74:	7942                	ld	s2,48(sp)
    80003c76:	79a2                	ld	s3,40(sp)
    80003c78:	7a02                	ld	s4,32(sp)
    80003c7a:	6ae2                	ld	s5,24(sp)
    80003c7c:	6b42                	ld	s6,16(sp)
    80003c7e:	6ba2                	ld	s7,8(sp)
    80003c80:	6c02                	ld	s8,0(sp)
    80003c82:	6161                	addi	sp,sp,80
    80003c84:	8082                	ret
    ret = (i == n ? n : -1);
    80003c86:	5a7d                	li	s4,-1
    80003c88:	b7d5                	j	80003c6c <filewrite+0xfa>
    panic("filewrite");
    80003c8a:	00005517          	auipc	a0,0x5
    80003c8e:	9ae50513          	addi	a0,a0,-1618 # 80008638 <syscalls+0x268>
    80003c92:	00002097          	auipc	ra,0x2
    80003c96:	f0a080e7          	jalr	-246(ra) # 80005b9c <panic>
    return -1;
    80003c9a:	5a7d                	li	s4,-1
    80003c9c:	bfc1                	j	80003c6c <filewrite+0xfa>
      return -1;
    80003c9e:	5a7d                	li	s4,-1
    80003ca0:	b7f1                	j	80003c6c <filewrite+0xfa>
    80003ca2:	5a7d                	li	s4,-1
    80003ca4:	b7e1                	j	80003c6c <filewrite+0xfa>

0000000080003ca6 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003ca6:	7179                	addi	sp,sp,-48
    80003ca8:	f406                	sd	ra,40(sp)
    80003caa:	f022                	sd	s0,32(sp)
    80003cac:	ec26                	sd	s1,24(sp)
    80003cae:	e84a                	sd	s2,16(sp)
    80003cb0:	e44e                	sd	s3,8(sp)
    80003cb2:	e052                	sd	s4,0(sp)
    80003cb4:	1800                	addi	s0,sp,48
    80003cb6:	84aa                	mv	s1,a0
    80003cb8:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003cba:	0005b023          	sd	zero,0(a1)
    80003cbe:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003cc2:	00000097          	auipc	ra,0x0
    80003cc6:	bf8080e7          	jalr	-1032(ra) # 800038ba <filealloc>
    80003cca:	e088                	sd	a0,0(s1)
    80003ccc:	c551                	beqz	a0,80003d58 <pipealloc+0xb2>
    80003cce:	00000097          	auipc	ra,0x0
    80003cd2:	bec080e7          	jalr	-1044(ra) # 800038ba <filealloc>
    80003cd6:	00aa3023          	sd	a0,0(s4)
    80003cda:	c92d                	beqz	a0,80003d4c <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003cdc:	ffffc097          	auipc	ra,0xffffc
    80003ce0:	43e080e7          	jalr	1086(ra) # 8000011a <kalloc>
    80003ce4:	892a                	mv	s2,a0
    80003ce6:	c125                	beqz	a0,80003d46 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003ce8:	4985                	li	s3,1
    80003cea:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003cee:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003cf2:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003cf6:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003cfa:	00005597          	auipc	a1,0x5
    80003cfe:	94e58593          	addi	a1,a1,-1714 # 80008648 <syscalls+0x278>
    80003d02:	00002097          	auipc	ra,0x2
    80003d06:	342080e7          	jalr	834(ra) # 80006044 <initlock>
  (*f0)->type = FD_PIPE;
    80003d0a:	609c                	ld	a5,0(s1)
    80003d0c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d10:	609c                	ld	a5,0(s1)
    80003d12:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d16:	609c                	ld	a5,0(s1)
    80003d18:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d1c:	609c                	ld	a5,0(s1)
    80003d1e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d22:	000a3783          	ld	a5,0(s4)
    80003d26:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d2a:	000a3783          	ld	a5,0(s4)
    80003d2e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d32:	000a3783          	ld	a5,0(s4)
    80003d36:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003d3a:	000a3783          	ld	a5,0(s4)
    80003d3e:	0127b823          	sd	s2,16(a5)
  return 0;
    80003d42:	4501                	li	a0,0
    80003d44:	a025                	j	80003d6c <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003d46:	6088                	ld	a0,0(s1)
    80003d48:	e501                	bnez	a0,80003d50 <pipealloc+0xaa>
    80003d4a:	a039                	j	80003d58 <pipealloc+0xb2>
    80003d4c:	6088                	ld	a0,0(s1)
    80003d4e:	c51d                	beqz	a0,80003d7c <pipealloc+0xd6>
    fileclose(*f0);
    80003d50:	00000097          	auipc	ra,0x0
    80003d54:	c26080e7          	jalr	-986(ra) # 80003976 <fileclose>
  if(*f1)
    80003d58:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003d5c:	557d                	li	a0,-1
  if(*f1)
    80003d5e:	c799                	beqz	a5,80003d6c <pipealloc+0xc6>
    fileclose(*f1);
    80003d60:	853e                	mv	a0,a5
    80003d62:	00000097          	auipc	ra,0x0
    80003d66:	c14080e7          	jalr	-1004(ra) # 80003976 <fileclose>
  return -1;
    80003d6a:	557d                	li	a0,-1
}
    80003d6c:	70a2                	ld	ra,40(sp)
    80003d6e:	7402                	ld	s0,32(sp)
    80003d70:	64e2                	ld	s1,24(sp)
    80003d72:	6942                	ld	s2,16(sp)
    80003d74:	69a2                	ld	s3,8(sp)
    80003d76:	6a02                	ld	s4,0(sp)
    80003d78:	6145                	addi	sp,sp,48
    80003d7a:	8082                	ret
  return -1;
    80003d7c:	557d                	li	a0,-1
    80003d7e:	b7fd                	j	80003d6c <pipealloc+0xc6>

0000000080003d80 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003d80:	1101                	addi	sp,sp,-32
    80003d82:	ec06                	sd	ra,24(sp)
    80003d84:	e822                	sd	s0,16(sp)
    80003d86:	e426                	sd	s1,8(sp)
    80003d88:	e04a                	sd	s2,0(sp)
    80003d8a:	1000                	addi	s0,sp,32
    80003d8c:	84aa                	mv	s1,a0
    80003d8e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003d90:	00002097          	auipc	ra,0x2
    80003d94:	344080e7          	jalr	836(ra) # 800060d4 <acquire>
  if(writable){
    80003d98:	02090d63          	beqz	s2,80003dd2 <pipeclose+0x52>
    pi->writeopen = 0;
    80003d9c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003da0:	21848513          	addi	a0,s1,536
    80003da4:	ffffd097          	auipc	ra,0xffffd
    80003da8:	7bc080e7          	jalr	1980(ra) # 80001560 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003dac:	2204b783          	ld	a5,544(s1)
    80003db0:	eb95                	bnez	a5,80003de4 <pipeclose+0x64>
    release(&pi->lock);
    80003db2:	8526                	mv	a0,s1
    80003db4:	00002097          	auipc	ra,0x2
    80003db8:	3d4080e7          	jalr	980(ra) # 80006188 <release>
    kfree((char*)pi);
    80003dbc:	8526                	mv	a0,s1
    80003dbe:	ffffc097          	auipc	ra,0xffffc
    80003dc2:	25e080e7          	jalr	606(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003dc6:	60e2                	ld	ra,24(sp)
    80003dc8:	6442                	ld	s0,16(sp)
    80003dca:	64a2                	ld	s1,8(sp)
    80003dcc:	6902                	ld	s2,0(sp)
    80003dce:	6105                	addi	sp,sp,32
    80003dd0:	8082                	ret
    pi->readopen = 0;
    80003dd2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003dd6:	21c48513          	addi	a0,s1,540
    80003dda:	ffffd097          	auipc	ra,0xffffd
    80003dde:	786080e7          	jalr	1926(ra) # 80001560 <wakeup>
    80003de2:	b7e9                	j	80003dac <pipeclose+0x2c>
    release(&pi->lock);
    80003de4:	8526                	mv	a0,s1
    80003de6:	00002097          	auipc	ra,0x2
    80003dea:	3a2080e7          	jalr	930(ra) # 80006188 <release>
}
    80003dee:	bfe1                	j	80003dc6 <pipeclose+0x46>

0000000080003df0 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003df0:	711d                	addi	sp,sp,-96
    80003df2:	ec86                	sd	ra,88(sp)
    80003df4:	e8a2                	sd	s0,80(sp)
    80003df6:	e4a6                	sd	s1,72(sp)
    80003df8:	e0ca                	sd	s2,64(sp)
    80003dfa:	fc4e                	sd	s3,56(sp)
    80003dfc:	f852                	sd	s4,48(sp)
    80003dfe:	f456                	sd	s5,40(sp)
    80003e00:	f05a                	sd	s6,32(sp)
    80003e02:	ec5e                	sd	s7,24(sp)
    80003e04:	e862                	sd	s8,16(sp)
    80003e06:	1080                	addi	s0,sp,96
    80003e08:	84aa                	mv	s1,a0
    80003e0a:	8aae                	mv	s5,a1
    80003e0c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e0e:	ffffd097          	auipc	ra,0xffffd
    80003e12:	046080e7          	jalr	70(ra) # 80000e54 <myproc>
    80003e16:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e18:	8526                	mv	a0,s1
    80003e1a:	00002097          	auipc	ra,0x2
    80003e1e:	2ba080e7          	jalr	698(ra) # 800060d4 <acquire>
  while(i < n){
    80003e22:	0b405663          	blez	s4,80003ece <pipewrite+0xde>
  int i = 0;
    80003e26:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e28:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e2a:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e2e:	21c48b93          	addi	s7,s1,540
    80003e32:	a089                	j	80003e74 <pipewrite+0x84>
      release(&pi->lock);
    80003e34:	8526                	mv	a0,s1
    80003e36:	00002097          	auipc	ra,0x2
    80003e3a:	352080e7          	jalr	850(ra) # 80006188 <release>
      return -1;
    80003e3e:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003e40:	854a                	mv	a0,s2
    80003e42:	60e6                	ld	ra,88(sp)
    80003e44:	6446                	ld	s0,80(sp)
    80003e46:	64a6                	ld	s1,72(sp)
    80003e48:	6906                	ld	s2,64(sp)
    80003e4a:	79e2                	ld	s3,56(sp)
    80003e4c:	7a42                	ld	s4,48(sp)
    80003e4e:	7aa2                	ld	s5,40(sp)
    80003e50:	7b02                	ld	s6,32(sp)
    80003e52:	6be2                	ld	s7,24(sp)
    80003e54:	6c42                	ld	s8,16(sp)
    80003e56:	6125                	addi	sp,sp,96
    80003e58:	8082                	ret
      wakeup(&pi->nread);
    80003e5a:	8562                	mv	a0,s8
    80003e5c:	ffffd097          	auipc	ra,0xffffd
    80003e60:	704080e7          	jalr	1796(ra) # 80001560 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003e64:	85a6                	mv	a1,s1
    80003e66:	855e                	mv	a0,s7
    80003e68:	ffffd097          	auipc	ra,0xffffd
    80003e6c:	694080e7          	jalr	1684(ra) # 800014fc <sleep>
  while(i < n){
    80003e70:	07495063          	bge	s2,s4,80003ed0 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003e74:	2204a783          	lw	a5,544(s1)
    80003e78:	dfd5                	beqz	a5,80003e34 <pipewrite+0x44>
    80003e7a:	854e                	mv	a0,s3
    80003e7c:	ffffe097          	auipc	ra,0xffffe
    80003e80:	928080e7          	jalr	-1752(ra) # 800017a4 <killed>
    80003e84:	f945                	bnez	a0,80003e34 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003e86:	2184a783          	lw	a5,536(s1)
    80003e8a:	21c4a703          	lw	a4,540(s1)
    80003e8e:	2007879b          	addiw	a5,a5,512
    80003e92:	fcf704e3          	beq	a4,a5,80003e5a <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e96:	4685                	li	a3,1
    80003e98:	01590633          	add	a2,s2,s5
    80003e9c:	faf40593          	addi	a1,s0,-81
    80003ea0:	0509b503          	ld	a0,80(s3)
    80003ea4:	ffffd097          	auipc	ra,0xffffd
    80003ea8:	cfc080e7          	jalr	-772(ra) # 80000ba0 <copyin>
    80003eac:	03650263          	beq	a0,s6,80003ed0 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003eb0:	21c4a783          	lw	a5,540(s1)
    80003eb4:	0017871b          	addiw	a4,a5,1
    80003eb8:	20e4ae23          	sw	a4,540(s1)
    80003ebc:	1ff7f793          	andi	a5,a5,511
    80003ec0:	97a6                	add	a5,a5,s1
    80003ec2:	faf44703          	lbu	a4,-81(s0)
    80003ec6:	00e78c23          	sb	a4,24(a5)
      i++;
    80003eca:	2905                	addiw	s2,s2,1
    80003ecc:	b755                	j	80003e70 <pipewrite+0x80>
  int i = 0;
    80003ece:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003ed0:	21848513          	addi	a0,s1,536
    80003ed4:	ffffd097          	auipc	ra,0xffffd
    80003ed8:	68c080e7          	jalr	1676(ra) # 80001560 <wakeup>
  release(&pi->lock);
    80003edc:	8526                	mv	a0,s1
    80003ede:	00002097          	auipc	ra,0x2
    80003ee2:	2aa080e7          	jalr	682(ra) # 80006188 <release>
  return i;
    80003ee6:	bfa9                	j	80003e40 <pipewrite+0x50>

0000000080003ee8 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003ee8:	715d                	addi	sp,sp,-80
    80003eea:	e486                	sd	ra,72(sp)
    80003eec:	e0a2                	sd	s0,64(sp)
    80003eee:	fc26                	sd	s1,56(sp)
    80003ef0:	f84a                	sd	s2,48(sp)
    80003ef2:	f44e                	sd	s3,40(sp)
    80003ef4:	f052                	sd	s4,32(sp)
    80003ef6:	ec56                	sd	s5,24(sp)
    80003ef8:	e85a                	sd	s6,16(sp)
    80003efa:	0880                	addi	s0,sp,80
    80003efc:	84aa                	mv	s1,a0
    80003efe:	892e                	mv	s2,a1
    80003f00:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f02:	ffffd097          	auipc	ra,0xffffd
    80003f06:	f52080e7          	jalr	-174(ra) # 80000e54 <myproc>
    80003f0a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f0c:	8526                	mv	a0,s1
    80003f0e:	00002097          	auipc	ra,0x2
    80003f12:	1c6080e7          	jalr	454(ra) # 800060d4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f16:	2184a703          	lw	a4,536(s1)
    80003f1a:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f1e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f22:	02f71763          	bne	a4,a5,80003f50 <piperead+0x68>
    80003f26:	2244a783          	lw	a5,548(s1)
    80003f2a:	c39d                	beqz	a5,80003f50 <piperead+0x68>
    if(killed(pr)){
    80003f2c:	8552                	mv	a0,s4
    80003f2e:	ffffe097          	auipc	ra,0xffffe
    80003f32:	876080e7          	jalr	-1930(ra) # 800017a4 <killed>
    80003f36:	e949                	bnez	a0,80003fc8 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f38:	85a6                	mv	a1,s1
    80003f3a:	854e                	mv	a0,s3
    80003f3c:	ffffd097          	auipc	ra,0xffffd
    80003f40:	5c0080e7          	jalr	1472(ra) # 800014fc <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f44:	2184a703          	lw	a4,536(s1)
    80003f48:	21c4a783          	lw	a5,540(s1)
    80003f4c:	fcf70de3          	beq	a4,a5,80003f26 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f50:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f52:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f54:	05505463          	blez	s5,80003f9c <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80003f58:	2184a783          	lw	a5,536(s1)
    80003f5c:	21c4a703          	lw	a4,540(s1)
    80003f60:	02f70e63          	beq	a4,a5,80003f9c <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003f64:	0017871b          	addiw	a4,a5,1
    80003f68:	20e4ac23          	sw	a4,536(s1)
    80003f6c:	1ff7f793          	andi	a5,a5,511
    80003f70:	97a6                	add	a5,a5,s1
    80003f72:	0187c783          	lbu	a5,24(a5)
    80003f76:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f7a:	4685                	li	a3,1
    80003f7c:	fbf40613          	addi	a2,s0,-65
    80003f80:	85ca                	mv	a1,s2
    80003f82:	050a3503          	ld	a0,80(s4)
    80003f86:	ffffd097          	auipc	ra,0xffffd
    80003f8a:	b8e080e7          	jalr	-1138(ra) # 80000b14 <copyout>
    80003f8e:	01650763          	beq	a0,s6,80003f9c <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f92:	2985                	addiw	s3,s3,1
    80003f94:	0905                	addi	s2,s2,1
    80003f96:	fd3a91e3          	bne	s5,s3,80003f58 <piperead+0x70>
    80003f9a:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003f9c:	21c48513          	addi	a0,s1,540
    80003fa0:	ffffd097          	auipc	ra,0xffffd
    80003fa4:	5c0080e7          	jalr	1472(ra) # 80001560 <wakeup>
  release(&pi->lock);
    80003fa8:	8526                	mv	a0,s1
    80003faa:	00002097          	auipc	ra,0x2
    80003fae:	1de080e7          	jalr	478(ra) # 80006188 <release>
  return i;
}
    80003fb2:	854e                	mv	a0,s3
    80003fb4:	60a6                	ld	ra,72(sp)
    80003fb6:	6406                	ld	s0,64(sp)
    80003fb8:	74e2                	ld	s1,56(sp)
    80003fba:	7942                	ld	s2,48(sp)
    80003fbc:	79a2                	ld	s3,40(sp)
    80003fbe:	7a02                	ld	s4,32(sp)
    80003fc0:	6ae2                	ld	s5,24(sp)
    80003fc2:	6b42                	ld	s6,16(sp)
    80003fc4:	6161                	addi	sp,sp,80
    80003fc6:	8082                	ret
      release(&pi->lock);
    80003fc8:	8526                	mv	a0,s1
    80003fca:	00002097          	auipc	ra,0x2
    80003fce:	1be080e7          	jalr	446(ra) # 80006188 <release>
      return -1;
    80003fd2:	59fd                	li	s3,-1
    80003fd4:	bff9                	j	80003fb2 <piperead+0xca>

0000000080003fd6 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003fd6:	1141                	addi	sp,sp,-16
    80003fd8:	e422                	sd	s0,8(sp)
    80003fda:	0800                	addi	s0,sp,16
    80003fdc:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003fde:	8905                	andi	a0,a0,1
    80003fe0:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003fe2:	8b89                	andi	a5,a5,2
    80003fe4:	c399                	beqz	a5,80003fea <flags2perm+0x14>
      perm |= PTE_W;
    80003fe6:	00456513          	ori	a0,a0,4
    return perm;
}
    80003fea:	6422                	ld	s0,8(sp)
    80003fec:	0141                	addi	sp,sp,16
    80003fee:	8082                	ret

0000000080003ff0 <exec>:

int
exec(char *path, char **argv)
{
    80003ff0:	de010113          	addi	sp,sp,-544
    80003ff4:	20113c23          	sd	ra,536(sp)
    80003ff8:	20813823          	sd	s0,528(sp)
    80003ffc:	20913423          	sd	s1,520(sp)
    80004000:	21213023          	sd	s2,512(sp)
    80004004:	ffce                	sd	s3,504(sp)
    80004006:	fbd2                	sd	s4,496(sp)
    80004008:	f7d6                	sd	s5,488(sp)
    8000400a:	f3da                	sd	s6,480(sp)
    8000400c:	efde                	sd	s7,472(sp)
    8000400e:	ebe2                	sd	s8,464(sp)
    80004010:	e7e6                	sd	s9,456(sp)
    80004012:	e3ea                	sd	s10,448(sp)
    80004014:	ff6e                	sd	s11,440(sp)
    80004016:	1400                	addi	s0,sp,544
    80004018:	892a                	mv	s2,a0
    8000401a:	dea43423          	sd	a0,-536(s0)
    8000401e:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004022:	ffffd097          	auipc	ra,0xffffd
    80004026:	e32080e7          	jalr	-462(ra) # 80000e54 <myproc>
    8000402a:	84aa                	mv	s1,a0

  begin_op();
    8000402c:	fffff097          	auipc	ra,0xfffff
    80004030:	482080e7          	jalr	1154(ra) # 800034ae <begin_op>

  if((ip = namei(path)) == 0){
    80004034:	854a                	mv	a0,s2
    80004036:	fffff097          	auipc	ra,0xfffff
    8000403a:	258080e7          	jalr	600(ra) # 8000328e <namei>
    8000403e:	c93d                	beqz	a0,800040b4 <exec+0xc4>
    80004040:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004042:	fffff097          	auipc	ra,0xfffff
    80004046:	aa0080e7          	jalr	-1376(ra) # 80002ae2 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000404a:	04000713          	li	a4,64
    8000404e:	4681                	li	a3,0
    80004050:	e5040613          	addi	a2,s0,-432
    80004054:	4581                	li	a1,0
    80004056:	8556                	mv	a0,s5
    80004058:	fffff097          	auipc	ra,0xfffff
    8000405c:	d3e080e7          	jalr	-706(ra) # 80002d96 <readi>
    80004060:	04000793          	li	a5,64
    80004064:	00f51a63          	bne	a0,a5,80004078 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004068:	e5042703          	lw	a4,-432(s0)
    8000406c:	464c47b7          	lui	a5,0x464c4
    80004070:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004074:	04f70663          	beq	a4,a5,800040c0 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004078:	8556                	mv	a0,s5
    8000407a:	fffff097          	auipc	ra,0xfffff
    8000407e:	cca080e7          	jalr	-822(ra) # 80002d44 <iunlockput>
    end_op();
    80004082:	fffff097          	auipc	ra,0xfffff
    80004086:	4aa080e7          	jalr	1194(ra) # 8000352c <end_op>
  }
  return -1;
    8000408a:	557d                	li	a0,-1
}
    8000408c:	21813083          	ld	ra,536(sp)
    80004090:	21013403          	ld	s0,528(sp)
    80004094:	20813483          	ld	s1,520(sp)
    80004098:	20013903          	ld	s2,512(sp)
    8000409c:	79fe                	ld	s3,504(sp)
    8000409e:	7a5e                	ld	s4,496(sp)
    800040a0:	7abe                	ld	s5,488(sp)
    800040a2:	7b1e                	ld	s6,480(sp)
    800040a4:	6bfe                	ld	s7,472(sp)
    800040a6:	6c5e                	ld	s8,464(sp)
    800040a8:	6cbe                	ld	s9,456(sp)
    800040aa:	6d1e                	ld	s10,448(sp)
    800040ac:	7dfa                	ld	s11,440(sp)
    800040ae:	22010113          	addi	sp,sp,544
    800040b2:	8082                	ret
    end_op();
    800040b4:	fffff097          	auipc	ra,0xfffff
    800040b8:	478080e7          	jalr	1144(ra) # 8000352c <end_op>
    return -1;
    800040bc:	557d                	li	a0,-1
    800040be:	b7f9                	j	8000408c <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800040c0:	8526                	mv	a0,s1
    800040c2:	ffffd097          	auipc	ra,0xffffd
    800040c6:	e56080e7          	jalr	-426(ra) # 80000f18 <proc_pagetable>
    800040ca:	8b2a                	mv	s6,a0
    800040cc:	d555                	beqz	a0,80004078 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040ce:	e7042783          	lw	a5,-400(s0)
    800040d2:	e8845703          	lhu	a4,-376(s0)
    800040d6:	c735                	beqz	a4,80004142 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800040d8:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040da:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    800040de:	6a05                	lui	s4,0x1
    800040e0:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800040e4:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800040e8:	6d85                	lui	s11,0x1
    800040ea:	7d7d                	lui	s10,0xfffff
    800040ec:	ac3d                	j	8000432a <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800040ee:	00004517          	auipc	a0,0x4
    800040f2:	56250513          	addi	a0,a0,1378 # 80008650 <syscalls+0x280>
    800040f6:	00002097          	auipc	ra,0x2
    800040fa:	aa6080e7          	jalr	-1370(ra) # 80005b9c <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800040fe:	874a                	mv	a4,s2
    80004100:	009c86bb          	addw	a3,s9,s1
    80004104:	4581                	li	a1,0
    80004106:	8556                	mv	a0,s5
    80004108:	fffff097          	auipc	ra,0xfffff
    8000410c:	c8e080e7          	jalr	-882(ra) # 80002d96 <readi>
    80004110:	2501                	sext.w	a0,a0
    80004112:	1aa91963          	bne	s2,a0,800042c4 <exec+0x2d4>
  for(i = 0; i < sz; i += PGSIZE){
    80004116:	009d84bb          	addw	s1,s11,s1
    8000411a:	013d09bb          	addw	s3,s10,s3
    8000411e:	1f74f663          	bgeu	s1,s7,8000430a <exec+0x31a>
    pa = walkaddr(pagetable, va + i);
    80004122:	02049593          	slli	a1,s1,0x20
    80004126:	9181                	srli	a1,a1,0x20
    80004128:	95e2                	add	a1,a1,s8
    8000412a:	855a                	mv	a0,s6
    8000412c:	ffffc097          	auipc	ra,0xffffc
    80004130:	3d8080e7          	jalr	984(ra) # 80000504 <walkaddr>
    80004134:	862a                	mv	a2,a0
    if(pa == 0)
    80004136:	dd45                	beqz	a0,800040ee <exec+0xfe>
      n = PGSIZE;
    80004138:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000413a:	fd49f2e3          	bgeu	s3,s4,800040fe <exec+0x10e>
      n = sz - i;
    8000413e:	894e                	mv	s2,s3
    80004140:	bf7d                	j	800040fe <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004142:	4901                	li	s2,0
  iunlockput(ip);
    80004144:	8556                	mv	a0,s5
    80004146:	fffff097          	auipc	ra,0xfffff
    8000414a:	bfe080e7          	jalr	-1026(ra) # 80002d44 <iunlockput>
  end_op();
    8000414e:	fffff097          	auipc	ra,0xfffff
    80004152:	3de080e7          	jalr	990(ra) # 8000352c <end_op>
  p = myproc();
    80004156:	ffffd097          	auipc	ra,0xffffd
    8000415a:	cfe080e7          	jalr	-770(ra) # 80000e54 <myproc>
    8000415e:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004160:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004164:	6785                	lui	a5,0x1
    80004166:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004168:	97ca                	add	a5,a5,s2
    8000416a:	777d                	lui	a4,0xfffff
    8000416c:	8ff9                	and	a5,a5,a4
    8000416e:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004172:	4691                	li	a3,4
    80004174:	6609                	lui	a2,0x2
    80004176:	963e                	add	a2,a2,a5
    80004178:	85be                	mv	a1,a5
    8000417a:	855a                	mv	a0,s6
    8000417c:	ffffc097          	auipc	ra,0xffffc
    80004180:	73c080e7          	jalr	1852(ra) # 800008b8 <uvmalloc>
    80004184:	8c2a                	mv	s8,a0
  ip = 0;
    80004186:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004188:	12050e63          	beqz	a0,800042c4 <exec+0x2d4>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000418c:	75f9                	lui	a1,0xffffe
    8000418e:	95aa                	add	a1,a1,a0
    80004190:	855a                	mv	a0,s6
    80004192:	ffffd097          	auipc	ra,0xffffd
    80004196:	950080e7          	jalr	-1712(ra) # 80000ae2 <uvmclear>
  stackbase = sp - PGSIZE;
    8000419a:	7afd                	lui	s5,0xfffff
    8000419c:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    8000419e:	df043783          	ld	a5,-528(s0)
    800041a2:	6388                	ld	a0,0(a5)
    800041a4:	c925                	beqz	a0,80004214 <exec+0x224>
    800041a6:	e9040993          	addi	s3,s0,-368
    800041aa:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800041ae:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800041b0:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800041b2:	ffffc097          	auipc	ra,0xffffc
    800041b6:	144080e7          	jalr	324(ra) # 800002f6 <strlen>
    800041ba:	0015079b          	addiw	a5,a0,1
    800041be:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800041c2:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800041c6:	13596663          	bltu	s2,s5,800042f2 <exec+0x302>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800041ca:	df043d83          	ld	s11,-528(s0)
    800041ce:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800041d2:	8552                	mv	a0,s4
    800041d4:	ffffc097          	auipc	ra,0xffffc
    800041d8:	122080e7          	jalr	290(ra) # 800002f6 <strlen>
    800041dc:	0015069b          	addiw	a3,a0,1
    800041e0:	8652                	mv	a2,s4
    800041e2:	85ca                	mv	a1,s2
    800041e4:	855a                	mv	a0,s6
    800041e6:	ffffd097          	auipc	ra,0xffffd
    800041ea:	92e080e7          	jalr	-1746(ra) # 80000b14 <copyout>
    800041ee:	10054663          	bltz	a0,800042fa <exec+0x30a>
    ustack[argc] = sp;
    800041f2:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800041f6:	0485                	addi	s1,s1,1
    800041f8:	008d8793          	addi	a5,s11,8
    800041fc:	def43823          	sd	a5,-528(s0)
    80004200:	008db503          	ld	a0,8(s11)
    80004204:	c911                	beqz	a0,80004218 <exec+0x228>
    if(argc >= MAXARG)
    80004206:	09a1                	addi	s3,s3,8
    80004208:	fb3c95e3          	bne	s9,s3,800041b2 <exec+0x1c2>
  sz = sz1;
    8000420c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004210:	4a81                	li	s5,0
    80004212:	a84d                	j	800042c4 <exec+0x2d4>
  sp = sz;
    80004214:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004216:	4481                	li	s1,0
  ustack[argc] = 0;
    80004218:	00349793          	slli	a5,s1,0x3
    8000421c:	f9078793          	addi	a5,a5,-112
    80004220:	97a2                	add	a5,a5,s0
    80004222:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004226:	00148693          	addi	a3,s1,1
    8000422a:	068e                	slli	a3,a3,0x3
    8000422c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004230:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004234:	01597663          	bgeu	s2,s5,80004240 <exec+0x250>
  sz = sz1;
    80004238:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000423c:	4a81                	li	s5,0
    8000423e:	a059                	j	800042c4 <exec+0x2d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004240:	e9040613          	addi	a2,s0,-368
    80004244:	85ca                	mv	a1,s2
    80004246:	855a                	mv	a0,s6
    80004248:	ffffd097          	auipc	ra,0xffffd
    8000424c:	8cc080e7          	jalr	-1844(ra) # 80000b14 <copyout>
    80004250:	0a054963          	bltz	a0,80004302 <exec+0x312>
  p->trapframe->a1 = sp;
    80004254:	058bb783          	ld	a5,88(s7)
    80004258:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000425c:	de843783          	ld	a5,-536(s0)
    80004260:	0007c703          	lbu	a4,0(a5)
    80004264:	cf11                	beqz	a4,80004280 <exec+0x290>
    80004266:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004268:	02f00693          	li	a3,47
    8000426c:	a039                	j	8000427a <exec+0x28a>
      last = s+1;
    8000426e:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004272:	0785                	addi	a5,a5,1
    80004274:	fff7c703          	lbu	a4,-1(a5)
    80004278:	c701                	beqz	a4,80004280 <exec+0x290>
    if(*s == '/')
    8000427a:	fed71ce3          	bne	a4,a3,80004272 <exec+0x282>
    8000427e:	bfc5                	j	8000426e <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    80004280:	4641                	li	a2,16
    80004282:	de843583          	ld	a1,-536(s0)
    80004286:	158b8513          	addi	a0,s7,344
    8000428a:	ffffc097          	auipc	ra,0xffffc
    8000428e:	03a080e7          	jalr	58(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    80004292:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004296:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    8000429a:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000429e:	058bb783          	ld	a5,88(s7)
    800042a2:	e6843703          	ld	a4,-408(s0)
    800042a6:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800042a8:	058bb783          	ld	a5,88(s7)
    800042ac:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800042b0:	85ea                	mv	a1,s10
    800042b2:	ffffd097          	auipc	ra,0xffffd
    800042b6:	d02080e7          	jalr	-766(ra) # 80000fb4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800042ba:	0004851b          	sext.w	a0,s1
    800042be:	b3f9                	j	8000408c <exec+0x9c>
    800042c0:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    800042c4:	df843583          	ld	a1,-520(s0)
    800042c8:	855a                	mv	a0,s6
    800042ca:	ffffd097          	auipc	ra,0xffffd
    800042ce:	cea080e7          	jalr	-790(ra) # 80000fb4 <proc_freepagetable>
  if(ip){
    800042d2:	da0a93e3          	bnez	s5,80004078 <exec+0x88>
  return -1;
    800042d6:	557d                	li	a0,-1
    800042d8:	bb55                	j	8000408c <exec+0x9c>
    800042da:	df243c23          	sd	s2,-520(s0)
    800042de:	b7dd                	j	800042c4 <exec+0x2d4>
    800042e0:	df243c23          	sd	s2,-520(s0)
    800042e4:	b7c5                	j	800042c4 <exec+0x2d4>
    800042e6:	df243c23          	sd	s2,-520(s0)
    800042ea:	bfe9                	j	800042c4 <exec+0x2d4>
    800042ec:	df243c23          	sd	s2,-520(s0)
    800042f0:	bfd1                	j	800042c4 <exec+0x2d4>
  sz = sz1;
    800042f2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042f6:	4a81                	li	s5,0
    800042f8:	b7f1                	j	800042c4 <exec+0x2d4>
  sz = sz1;
    800042fa:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042fe:	4a81                	li	s5,0
    80004300:	b7d1                	j	800042c4 <exec+0x2d4>
  sz = sz1;
    80004302:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004306:	4a81                	li	s5,0
    80004308:	bf75                	j	800042c4 <exec+0x2d4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000430a:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000430e:	e0843783          	ld	a5,-504(s0)
    80004312:	0017869b          	addiw	a3,a5,1
    80004316:	e0d43423          	sd	a3,-504(s0)
    8000431a:	e0043783          	ld	a5,-512(s0)
    8000431e:	0387879b          	addiw	a5,a5,56
    80004322:	e8845703          	lhu	a4,-376(s0)
    80004326:	e0e6dfe3          	bge	a3,a4,80004144 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000432a:	2781                	sext.w	a5,a5
    8000432c:	e0f43023          	sd	a5,-512(s0)
    80004330:	03800713          	li	a4,56
    80004334:	86be                	mv	a3,a5
    80004336:	e1840613          	addi	a2,s0,-488
    8000433a:	4581                	li	a1,0
    8000433c:	8556                	mv	a0,s5
    8000433e:	fffff097          	auipc	ra,0xfffff
    80004342:	a58080e7          	jalr	-1448(ra) # 80002d96 <readi>
    80004346:	03800793          	li	a5,56
    8000434a:	f6f51be3          	bne	a0,a5,800042c0 <exec+0x2d0>
    if(ph.type != ELF_PROG_LOAD)
    8000434e:	e1842783          	lw	a5,-488(s0)
    80004352:	4705                	li	a4,1
    80004354:	fae79de3          	bne	a5,a4,8000430e <exec+0x31e>
    if(ph.memsz < ph.filesz)
    80004358:	e4043483          	ld	s1,-448(s0)
    8000435c:	e3843783          	ld	a5,-456(s0)
    80004360:	f6f4ede3          	bltu	s1,a5,800042da <exec+0x2ea>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004364:	e2843783          	ld	a5,-472(s0)
    80004368:	94be                	add	s1,s1,a5
    8000436a:	f6f4ebe3          	bltu	s1,a5,800042e0 <exec+0x2f0>
    if(ph.vaddr % PGSIZE != 0)
    8000436e:	de043703          	ld	a4,-544(s0)
    80004372:	8ff9                	and	a5,a5,a4
    80004374:	fbad                	bnez	a5,800042e6 <exec+0x2f6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004376:	e1c42503          	lw	a0,-484(s0)
    8000437a:	00000097          	auipc	ra,0x0
    8000437e:	c5c080e7          	jalr	-932(ra) # 80003fd6 <flags2perm>
    80004382:	86aa                	mv	a3,a0
    80004384:	8626                	mv	a2,s1
    80004386:	85ca                	mv	a1,s2
    80004388:	855a                	mv	a0,s6
    8000438a:	ffffc097          	auipc	ra,0xffffc
    8000438e:	52e080e7          	jalr	1326(ra) # 800008b8 <uvmalloc>
    80004392:	dea43c23          	sd	a0,-520(s0)
    80004396:	d939                	beqz	a0,800042ec <exec+0x2fc>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004398:	e2843c03          	ld	s8,-472(s0)
    8000439c:	e2042c83          	lw	s9,-480(s0)
    800043a0:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800043a4:	f60b83e3          	beqz	s7,8000430a <exec+0x31a>
    800043a8:	89de                	mv	s3,s7
    800043aa:	4481                	li	s1,0
    800043ac:	bb9d                	j	80004122 <exec+0x132>

00000000800043ae <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800043ae:	7179                	addi	sp,sp,-48
    800043b0:	f406                	sd	ra,40(sp)
    800043b2:	f022                	sd	s0,32(sp)
    800043b4:	ec26                	sd	s1,24(sp)
    800043b6:	e84a                	sd	s2,16(sp)
    800043b8:	1800                	addi	s0,sp,48
    800043ba:	892e                	mv	s2,a1
    800043bc:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800043be:	fdc40593          	addi	a1,s0,-36
    800043c2:	ffffe097          	auipc	ra,0xffffe
    800043c6:	ba8080e7          	jalr	-1112(ra) # 80001f6a <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800043ca:	fdc42703          	lw	a4,-36(s0)
    800043ce:	47bd                	li	a5,15
    800043d0:	02e7eb63          	bltu	a5,a4,80004406 <argfd+0x58>
    800043d4:	ffffd097          	auipc	ra,0xffffd
    800043d8:	a80080e7          	jalr	-1408(ra) # 80000e54 <myproc>
    800043dc:	fdc42703          	lw	a4,-36(s0)
    800043e0:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffdd2ca>
    800043e4:	078e                	slli	a5,a5,0x3
    800043e6:	953e                	add	a0,a0,a5
    800043e8:	611c                	ld	a5,0(a0)
    800043ea:	c385                	beqz	a5,8000440a <argfd+0x5c>
    return -1;
  if(pfd)
    800043ec:	00090463          	beqz	s2,800043f4 <argfd+0x46>
    *pfd = fd;
    800043f0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800043f4:	4501                	li	a0,0
  if(pf)
    800043f6:	c091                	beqz	s1,800043fa <argfd+0x4c>
    *pf = f;
    800043f8:	e09c                	sd	a5,0(s1)
}
    800043fa:	70a2                	ld	ra,40(sp)
    800043fc:	7402                	ld	s0,32(sp)
    800043fe:	64e2                	ld	s1,24(sp)
    80004400:	6942                	ld	s2,16(sp)
    80004402:	6145                	addi	sp,sp,48
    80004404:	8082                	ret
    return -1;
    80004406:	557d                	li	a0,-1
    80004408:	bfcd                	j	800043fa <argfd+0x4c>
    8000440a:	557d                	li	a0,-1
    8000440c:	b7fd                	j	800043fa <argfd+0x4c>

000000008000440e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000440e:	1101                	addi	sp,sp,-32
    80004410:	ec06                	sd	ra,24(sp)
    80004412:	e822                	sd	s0,16(sp)
    80004414:	e426                	sd	s1,8(sp)
    80004416:	1000                	addi	s0,sp,32
    80004418:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000441a:	ffffd097          	auipc	ra,0xffffd
    8000441e:	a3a080e7          	jalr	-1478(ra) # 80000e54 <myproc>
    80004422:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004424:	0d050793          	addi	a5,a0,208
    80004428:	4501                	li	a0,0
    8000442a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000442c:	6398                	ld	a4,0(a5)
    8000442e:	cb19                	beqz	a4,80004444 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004430:	2505                	addiw	a0,a0,1
    80004432:	07a1                	addi	a5,a5,8
    80004434:	fed51ce3          	bne	a0,a3,8000442c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004438:	557d                	li	a0,-1
}
    8000443a:	60e2                	ld	ra,24(sp)
    8000443c:	6442                	ld	s0,16(sp)
    8000443e:	64a2                	ld	s1,8(sp)
    80004440:	6105                	addi	sp,sp,32
    80004442:	8082                	ret
      p->ofile[fd] = f;
    80004444:	01a50793          	addi	a5,a0,26
    80004448:	078e                	slli	a5,a5,0x3
    8000444a:	963e                	add	a2,a2,a5
    8000444c:	e204                	sd	s1,0(a2)
      return fd;
    8000444e:	b7f5                	j	8000443a <fdalloc+0x2c>

0000000080004450 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004450:	715d                	addi	sp,sp,-80
    80004452:	e486                	sd	ra,72(sp)
    80004454:	e0a2                	sd	s0,64(sp)
    80004456:	fc26                	sd	s1,56(sp)
    80004458:	f84a                	sd	s2,48(sp)
    8000445a:	f44e                	sd	s3,40(sp)
    8000445c:	f052                	sd	s4,32(sp)
    8000445e:	ec56                	sd	s5,24(sp)
    80004460:	e85a                	sd	s6,16(sp)
    80004462:	0880                	addi	s0,sp,80
    80004464:	8b2e                	mv	s6,a1
    80004466:	89b2                	mv	s3,a2
    80004468:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000446a:	fb040593          	addi	a1,s0,-80
    8000446e:	fffff097          	auipc	ra,0xfffff
    80004472:	e3e080e7          	jalr	-450(ra) # 800032ac <nameiparent>
    80004476:	84aa                	mv	s1,a0
    80004478:	14050f63          	beqz	a0,800045d6 <create+0x186>
    return 0;

  ilock(dp);
    8000447c:	ffffe097          	auipc	ra,0xffffe
    80004480:	666080e7          	jalr	1638(ra) # 80002ae2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004484:	4601                	li	a2,0
    80004486:	fb040593          	addi	a1,s0,-80
    8000448a:	8526                	mv	a0,s1
    8000448c:	fffff097          	auipc	ra,0xfffff
    80004490:	b3a080e7          	jalr	-1222(ra) # 80002fc6 <dirlookup>
    80004494:	8aaa                	mv	s5,a0
    80004496:	c931                	beqz	a0,800044ea <create+0x9a>
    iunlockput(dp);
    80004498:	8526                	mv	a0,s1
    8000449a:	fffff097          	auipc	ra,0xfffff
    8000449e:	8aa080e7          	jalr	-1878(ra) # 80002d44 <iunlockput>
    ilock(ip);
    800044a2:	8556                	mv	a0,s5
    800044a4:	ffffe097          	auipc	ra,0xffffe
    800044a8:	63e080e7          	jalr	1598(ra) # 80002ae2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800044ac:	000b059b          	sext.w	a1,s6
    800044b0:	4789                	li	a5,2
    800044b2:	02f59563          	bne	a1,a5,800044dc <create+0x8c>
    800044b6:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdd2f4>
    800044ba:	37f9                	addiw	a5,a5,-2
    800044bc:	17c2                	slli	a5,a5,0x30
    800044be:	93c1                	srli	a5,a5,0x30
    800044c0:	4705                	li	a4,1
    800044c2:	00f76d63          	bltu	a4,a5,800044dc <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800044c6:	8556                	mv	a0,s5
    800044c8:	60a6                	ld	ra,72(sp)
    800044ca:	6406                	ld	s0,64(sp)
    800044cc:	74e2                	ld	s1,56(sp)
    800044ce:	7942                	ld	s2,48(sp)
    800044d0:	79a2                	ld	s3,40(sp)
    800044d2:	7a02                	ld	s4,32(sp)
    800044d4:	6ae2                	ld	s5,24(sp)
    800044d6:	6b42                	ld	s6,16(sp)
    800044d8:	6161                	addi	sp,sp,80
    800044da:	8082                	ret
    iunlockput(ip);
    800044dc:	8556                	mv	a0,s5
    800044de:	fffff097          	auipc	ra,0xfffff
    800044e2:	866080e7          	jalr	-1946(ra) # 80002d44 <iunlockput>
    return 0;
    800044e6:	4a81                	li	s5,0
    800044e8:	bff9                	j	800044c6 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800044ea:	85da                	mv	a1,s6
    800044ec:	4088                	lw	a0,0(s1)
    800044ee:	ffffe097          	auipc	ra,0xffffe
    800044f2:	456080e7          	jalr	1110(ra) # 80002944 <ialloc>
    800044f6:	8a2a                	mv	s4,a0
    800044f8:	c539                	beqz	a0,80004546 <create+0xf6>
  ilock(ip);
    800044fa:	ffffe097          	auipc	ra,0xffffe
    800044fe:	5e8080e7          	jalr	1512(ra) # 80002ae2 <ilock>
  ip->major = major;
    80004502:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004506:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000450a:	4905                	li	s2,1
    8000450c:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004510:	8552                	mv	a0,s4
    80004512:	ffffe097          	auipc	ra,0xffffe
    80004516:	504080e7          	jalr	1284(ra) # 80002a16 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000451a:	000b059b          	sext.w	a1,s6
    8000451e:	03258b63          	beq	a1,s2,80004554 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    80004522:	004a2603          	lw	a2,4(s4)
    80004526:	fb040593          	addi	a1,s0,-80
    8000452a:	8526                	mv	a0,s1
    8000452c:	fffff097          	auipc	ra,0xfffff
    80004530:	cb0080e7          	jalr	-848(ra) # 800031dc <dirlink>
    80004534:	06054f63          	bltz	a0,800045b2 <create+0x162>
  iunlockput(dp);
    80004538:	8526                	mv	a0,s1
    8000453a:	fffff097          	auipc	ra,0xfffff
    8000453e:	80a080e7          	jalr	-2038(ra) # 80002d44 <iunlockput>
  return ip;
    80004542:	8ad2                	mv	s5,s4
    80004544:	b749                	j	800044c6 <create+0x76>
    iunlockput(dp);
    80004546:	8526                	mv	a0,s1
    80004548:	ffffe097          	auipc	ra,0xffffe
    8000454c:	7fc080e7          	jalr	2044(ra) # 80002d44 <iunlockput>
    return 0;
    80004550:	8ad2                	mv	s5,s4
    80004552:	bf95                	j	800044c6 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004554:	004a2603          	lw	a2,4(s4)
    80004558:	00004597          	auipc	a1,0x4
    8000455c:	11858593          	addi	a1,a1,280 # 80008670 <syscalls+0x2a0>
    80004560:	8552                	mv	a0,s4
    80004562:	fffff097          	auipc	ra,0xfffff
    80004566:	c7a080e7          	jalr	-902(ra) # 800031dc <dirlink>
    8000456a:	04054463          	bltz	a0,800045b2 <create+0x162>
    8000456e:	40d0                	lw	a2,4(s1)
    80004570:	00004597          	auipc	a1,0x4
    80004574:	10858593          	addi	a1,a1,264 # 80008678 <syscalls+0x2a8>
    80004578:	8552                	mv	a0,s4
    8000457a:	fffff097          	auipc	ra,0xfffff
    8000457e:	c62080e7          	jalr	-926(ra) # 800031dc <dirlink>
    80004582:	02054863          	bltz	a0,800045b2 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    80004586:	004a2603          	lw	a2,4(s4)
    8000458a:	fb040593          	addi	a1,s0,-80
    8000458e:	8526                	mv	a0,s1
    80004590:	fffff097          	auipc	ra,0xfffff
    80004594:	c4c080e7          	jalr	-948(ra) # 800031dc <dirlink>
    80004598:	00054d63          	bltz	a0,800045b2 <create+0x162>
    dp->nlink++;  // for ".."
    8000459c:	04a4d783          	lhu	a5,74(s1)
    800045a0:	2785                	addiw	a5,a5,1
    800045a2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800045a6:	8526                	mv	a0,s1
    800045a8:	ffffe097          	auipc	ra,0xffffe
    800045ac:	46e080e7          	jalr	1134(ra) # 80002a16 <iupdate>
    800045b0:	b761                	j	80004538 <create+0xe8>
  ip->nlink = 0;
    800045b2:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800045b6:	8552                	mv	a0,s4
    800045b8:	ffffe097          	auipc	ra,0xffffe
    800045bc:	45e080e7          	jalr	1118(ra) # 80002a16 <iupdate>
  iunlockput(ip);
    800045c0:	8552                	mv	a0,s4
    800045c2:	ffffe097          	auipc	ra,0xffffe
    800045c6:	782080e7          	jalr	1922(ra) # 80002d44 <iunlockput>
  iunlockput(dp);
    800045ca:	8526                	mv	a0,s1
    800045cc:	ffffe097          	auipc	ra,0xffffe
    800045d0:	778080e7          	jalr	1912(ra) # 80002d44 <iunlockput>
  return 0;
    800045d4:	bdcd                	j	800044c6 <create+0x76>
    return 0;
    800045d6:	8aaa                	mv	s5,a0
    800045d8:	b5fd                	j	800044c6 <create+0x76>

00000000800045da <sys_dup>:
{
    800045da:	7179                	addi	sp,sp,-48
    800045dc:	f406                	sd	ra,40(sp)
    800045de:	f022                	sd	s0,32(sp)
    800045e0:	ec26                	sd	s1,24(sp)
    800045e2:	e84a                	sd	s2,16(sp)
    800045e4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800045e6:	fd840613          	addi	a2,s0,-40
    800045ea:	4581                	li	a1,0
    800045ec:	4501                	li	a0,0
    800045ee:	00000097          	auipc	ra,0x0
    800045f2:	dc0080e7          	jalr	-576(ra) # 800043ae <argfd>
    return -1;
    800045f6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800045f8:	02054363          	bltz	a0,8000461e <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800045fc:	fd843903          	ld	s2,-40(s0)
    80004600:	854a                	mv	a0,s2
    80004602:	00000097          	auipc	ra,0x0
    80004606:	e0c080e7          	jalr	-500(ra) # 8000440e <fdalloc>
    8000460a:	84aa                	mv	s1,a0
    return -1;
    8000460c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000460e:	00054863          	bltz	a0,8000461e <sys_dup+0x44>
  filedup(f);
    80004612:	854a                	mv	a0,s2
    80004614:	fffff097          	auipc	ra,0xfffff
    80004618:	310080e7          	jalr	784(ra) # 80003924 <filedup>
  return fd;
    8000461c:	87a6                	mv	a5,s1
}
    8000461e:	853e                	mv	a0,a5
    80004620:	70a2                	ld	ra,40(sp)
    80004622:	7402                	ld	s0,32(sp)
    80004624:	64e2                	ld	s1,24(sp)
    80004626:	6942                	ld	s2,16(sp)
    80004628:	6145                	addi	sp,sp,48
    8000462a:	8082                	ret

000000008000462c <sys_read>:
{
    8000462c:	7179                	addi	sp,sp,-48
    8000462e:	f406                	sd	ra,40(sp)
    80004630:	f022                	sd	s0,32(sp)
    80004632:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004634:	fd840593          	addi	a1,s0,-40
    80004638:	4505                	li	a0,1
    8000463a:	ffffe097          	auipc	ra,0xffffe
    8000463e:	950080e7          	jalr	-1712(ra) # 80001f8a <argaddr>
  argint(2, &n);
    80004642:	fe440593          	addi	a1,s0,-28
    80004646:	4509                	li	a0,2
    80004648:	ffffe097          	auipc	ra,0xffffe
    8000464c:	922080e7          	jalr	-1758(ra) # 80001f6a <argint>
  if(argfd(0, 0, &f) < 0)
    80004650:	fe840613          	addi	a2,s0,-24
    80004654:	4581                	li	a1,0
    80004656:	4501                	li	a0,0
    80004658:	00000097          	auipc	ra,0x0
    8000465c:	d56080e7          	jalr	-682(ra) # 800043ae <argfd>
    80004660:	87aa                	mv	a5,a0
    return -1;
    80004662:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004664:	0007cc63          	bltz	a5,8000467c <sys_read+0x50>
  return fileread(f, p, n);
    80004668:	fe442603          	lw	a2,-28(s0)
    8000466c:	fd843583          	ld	a1,-40(s0)
    80004670:	fe843503          	ld	a0,-24(s0)
    80004674:	fffff097          	auipc	ra,0xfffff
    80004678:	43c080e7          	jalr	1084(ra) # 80003ab0 <fileread>
}
    8000467c:	70a2                	ld	ra,40(sp)
    8000467e:	7402                	ld	s0,32(sp)
    80004680:	6145                	addi	sp,sp,48
    80004682:	8082                	ret

0000000080004684 <sys_write>:
{
    80004684:	7179                	addi	sp,sp,-48
    80004686:	f406                	sd	ra,40(sp)
    80004688:	f022                	sd	s0,32(sp)
    8000468a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000468c:	fd840593          	addi	a1,s0,-40
    80004690:	4505                	li	a0,1
    80004692:	ffffe097          	auipc	ra,0xffffe
    80004696:	8f8080e7          	jalr	-1800(ra) # 80001f8a <argaddr>
  argint(2, &n);
    8000469a:	fe440593          	addi	a1,s0,-28
    8000469e:	4509                	li	a0,2
    800046a0:	ffffe097          	auipc	ra,0xffffe
    800046a4:	8ca080e7          	jalr	-1846(ra) # 80001f6a <argint>
  if(argfd(0, 0, &f) < 0)
    800046a8:	fe840613          	addi	a2,s0,-24
    800046ac:	4581                	li	a1,0
    800046ae:	4501                	li	a0,0
    800046b0:	00000097          	auipc	ra,0x0
    800046b4:	cfe080e7          	jalr	-770(ra) # 800043ae <argfd>
    800046b8:	87aa                	mv	a5,a0
    return -1;
    800046ba:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800046bc:	0007cc63          	bltz	a5,800046d4 <sys_write+0x50>
  return filewrite(f, p, n);
    800046c0:	fe442603          	lw	a2,-28(s0)
    800046c4:	fd843583          	ld	a1,-40(s0)
    800046c8:	fe843503          	ld	a0,-24(s0)
    800046cc:	fffff097          	auipc	ra,0xfffff
    800046d0:	4a6080e7          	jalr	1190(ra) # 80003b72 <filewrite>
}
    800046d4:	70a2                	ld	ra,40(sp)
    800046d6:	7402                	ld	s0,32(sp)
    800046d8:	6145                	addi	sp,sp,48
    800046da:	8082                	ret

00000000800046dc <sys_close>:
{
    800046dc:	1101                	addi	sp,sp,-32
    800046de:	ec06                	sd	ra,24(sp)
    800046e0:	e822                	sd	s0,16(sp)
    800046e2:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800046e4:	fe040613          	addi	a2,s0,-32
    800046e8:	fec40593          	addi	a1,s0,-20
    800046ec:	4501                	li	a0,0
    800046ee:	00000097          	auipc	ra,0x0
    800046f2:	cc0080e7          	jalr	-832(ra) # 800043ae <argfd>
    return -1;
    800046f6:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800046f8:	02054463          	bltz	a0,80004720 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800046fc:	ffffc097          	auipc	ra,0xffffc
    80004700:	758080e7          	jalr	1880(ra) # 80000e54 <myproc>
    80004704:	fec42783          	lw	a5,-20(s0)
    80004708:	07e9                	addi	a5,a5,26
    8000470a:	078e                	slli	a5,a5,0x3
    8000470c:	953e                	add	a0,a0,a5
    8000470e:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004712:	fe043503          	ld	a0,-32(s0)
    80004716:	fffff097          	auipc	ra,0xfffff
    8000471a:	260080e7          	jalr	608(ra) # 80003976 <fileclose>
  return 0;
    8000471e:	4781                	li	a5,0
}
    80004720:	853e                	mv	a0,a5
    80004722:	60e2                	ld	ra,24(sp)
    80004724:	6442                	ld	s0,16(sp)
    80004726:	6105                	addi	sp,sp,32
    80004728:	8082                	ret

000000008000472a <sys_fstat>:
{
    8000472a:	1101                	addi	sp,sp,-32
    8000472c:	ec06                	sd	ra,24(sp)
    8000472e:	e822                	sd	s0,16(sp)
    80004730:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004732:	fe040593          	addi	a1,s0,-32
    80004736:	4505                	li	a0,1
    80004738:	ffffe097          	auipc	ra,0xffffe
    8000473c:	852080e7          	jalr	-1966(ra) # 80001f8a <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004740:	fe840613          	addi	a2,s0,-24
    80004744:	4581                	li	a1,0
    80004746:	4501                	li	a0,0
    80004748:	00000097          	auipc	ra,0x0
    8000474c:	c66080e7          	jalr	-922(ra) # 800043ae <argfd>
    80004750:	87aa                	mv	a5,a0
    return -1;
    80004752:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004754:	0007ca63          	bltz	a5,80004768 <sys_fstat+0x3e>
  return filestat(f, st);
    80004758:	fe043583          	ld	a1,-32(s0)
    8000475c:	fe843503          	ld	a0,-24(s0)
    80004760:	fffff097          	auipc	ra,0xfffff
    80004764:	2de080e7          	jalr	734(ra) # 80003a3e <filestat>
}
    80004768:	60e2                	ld	ra,24(sp)
    8000476a:	6442                	ld	s0,16(sp)
    8000476c:	6105                	addi	sp,sp,32
    8000476e:	8082                	ret

0000000080004770 <sys_link>:
{
    80004770:	7169                	addi	sp,sp,-304
    80004772:	f606                	sd	ra,296(sp)
    80004774:	f222                	sd	s0,288(sp)
    80004776:	ee26                	sd	s1,280(sp)
    80004778:	ea4a                	sd	s2,272(sp)
    8000477a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000477c:	08000613          	li	a2,128
    80004780:	ed040593          	addi	a1,s0,-304
    80004784:	4501                	li	a0,0
    80004786:	ffffe097          	auipc	ra,0xffffe
    8000478a:	824080e7          	jalr	-2012(ra) # 80001faa <argstr>
    return -1;
    8000478e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004790:	10054e63          	bltz	a0,800048ac <sys_link+0x13c>
    80004794:	08000613          	li	a2,128
    80004798:	f5040593          	addi	a1,s0,-176
    8000479c:	4505                	li	a0,1
    8000479e:	ffffe097          	auipc	ra,0xffffe
    800047a2:	80c080e7          	jalr	-2036(ra) # 80001faa <argstr>
    return -1;
    800047a6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047a8:	10054263          	bltz	a0,800048ac <sys_link+0x13c>
  begin_op();
    800047ac:	fffff097          	auipc	ra,0xfffff
    800047b0:	d02080e7          	jalr	-766(ra) # 800034ae <begin_op>
  if((ip = namei(old)) == 0){
    800047b4:	ed040513          	addi	a0,s0,-304
    800047b8:	fffff097          	auipc	ra,0xfffff
    800047bc:	ad6080e7          	jalr	-1322(ra) # 8000328e <namei>
    800047c0:	84aa                	mv	s1,a0
    800047c2:	c551                	beqz	a0,8000484e <sys_link+0xde>
  ilock(ip);
    800047c4:	ffffe097          	auipc	ra,0xffffe
    800047c8:	31e080e7          	jalr	798(ra) # 80002ae2 <ilock>
  if(ip->type == T_DIR){
    800047cc:	04449703          	lh	a4,68(s1)
    800047d0:	4785                	li	a5,1
    800047d2:	08f70463          	beq	a4,a5,8000485a <sys_link+0xea>
  ip->nlink++;
    800047d6:	04a4d783          	lhu	a5,74(s1)
    800047da:	2785                	addiw	a5,a5,1
    800047dc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800047e0:	8526                	mv	a0,s1
    800047e2:	ffffe097          	auipc	ra,0xffffe
    800047e6:	234080e7          	jalr	564(ra) # 80002a16 <iupdate>
  iunlock(ip);
    800047ea:	8526                	mv	a0,s1
    800047ec:	ffffe097          	auipc	ra,0xffffe
    800047f0:	3b8080e7          	jalr	952(ra) # 80002ba4 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800047f4:	fd040593          	addi	a1,s0,-48
    800047f8:	f5040513          	addi	a0,s0,-176
    800047fc:	fffff097          	auipc	ra,0xfffff
    80004800:	ab0080e7          	jalr	-1360(ra) # 800032ac <nameiparent>
    80004804:	892a                	mv	s2,a0
    80004806:	c935                	beqz	a0,8000487a <sys_link+0x10a>
  ilock(dp);
    80004808:	ffffe097          	auipc	ra,0xffffe
    8000480c:	2da080e7          	jalr	730(ra) # 80002ae2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004810:	00092703          	lw	a4,0(s2)
    80004814:	409c                	lw	a5,0(s1)
    80004816:	04f71d63          	bne	a4,a5,80004870 <sys_link+0x100>
    8000481a:	40d0                	lw	a2,4(s1)
    8000481c:	fd040593          	addi	a1,s0,-48
    80004820:	854a                	mv	a0,s2
    80004822:	fffff097          	auipc	ra,0xfffff
    80004826:	9ba080e7          	jalr	-1606(ra) # 800031dc <dirlink>
    8000482a:	04054363          	bltz	a0,80004870 <sys_link+0x100>
  iunlockput(dp);
    8000482e:	854a                	mv	a0,s2
    80004830:	ffffe097          	auipc	ra,0xffffe
    80004834:	514080e7          	jalr	1300(ra) # 80002d44 <iunlockput>
  iput(ip);
    80004838:	8526                	mv	a0,s1
    8000483a:	ffffe097          	auipc	ra,0xffffe
    8000483e:	462080e7          	jalr	1122(ra) # 80002c9c <iput>
  end_op();
    80004842:	fffff097          	auipc	ra,0xfffff
    80004846:	cea080e7          	jalr	-790(ra) # 8000352c <end_op>
  return 0;
    8000484a:	4781                	li	a5,0
    8000484c:	a085                	j	800048ac <sys_link+0x13c>
    end_op();
    8000484e:	fffff097          	auipc	ra,0xfffff
    80004852:	cde080e7          	jalr	-802(ra) # 8000352c <end_op>
    return -1;
    80004856:	57fd                	li	a5,-1
    80004858:	a891                	j	800048ac <sys_link+0x13c>
    iunlockput(ip);
    8000485a:	8526                	mv	a0,s1
    8000485c:	ffffe097          	auipc	ra,0xffffe
    80004860:	4e8080e7          	jalr	1256(ra) # 80002d44 <iunlockput>
    end_op();
    80004864:	fffff097          	auipc	ra,0xfffff
    80004868:	cc8080e7          	jalr	-824(ra) # 8000352c <end_op>
    return -1;
    8000486c:	57fd                	li	a5,-1
    8000486e:	a83d                	j	800048ac <sys_link+0x13c>
    iunlockput(dp);
    80004870:	854a                	mv	a0,s2
    80004872:	ffffe097          	auipc	ra,0xffffe
    80004876:	4d2080e7          	jalr	1234(ra) # 80002d44 <iunlockput>
  ilock(ip);
    8000487a:	8526                	mv	a0,s1
    8000487c:	ffffe097          	auipc	ra,0xffffe
    80004880:	266080e7          	jalr	614(ra) # 80002ae2 <ilock>
  ip->nlink--;
    80004884:	04a4d783          	lhu	a5,74(s1)
    80004888:	37fd                	addiw	a5,a5,-1
    8000488a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000488e:	8526                	mv	a0,s1
    80004890:	ffffe097          	auipc	ra,0xffffe
    80004894:	186080e7          	jalr	390(ra) # 80002a16 <iupdate>
  iunlockput(ip);
    80004898:	8526                	mv	a0,s1
    8000489a:	ffffe097          	auipc	ra,0xffffe
    8000489e:	4aa080e7          	jalr	1194(ra) # 80002d44 <iunlockput>
  end_op();
    800048a2:	fffff097          	auipc	ra,0xfffff
    800048a6:	c8a080e7          	jalr	-886(ra) # 8000352c <end_op>
  return -1;
    800048aa:	57fd                	li	a5,-1
}
    800048ac:	853e                	mv	a0,a5
    800048ae:	70b2                	ld	ra,296(sp)
    800048b0:	7412                	ld	s0,288(sp)
    800048b2:	64f2                	ld	s1,280(sp)
    800048b4:	6952                	ld	s2,272(sp)
    800048b6:	6155                	addi	sp,sp,304
    800048b8:	8082                	ret

00000000800048ba <sys_unlink>:
{
    800048ba:	7151                	addi	sp,sp,-240
    800048bc:	f586                	sd	ra,232(sp)
    800048be:	f1a2                	sd	s0,224(sp)
    800048c0:	eda6                	sd	s1,216(sp)
    800048c2:	e9ca                	sd	s2,208(sp)
    800048c4:	e5ce                	sd	s3,200(sp)
    800048c6:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800048c8:	08000613          	li	a2,128
    800048cc:	f3040593          	addi	a1,s0,-208
    800048d0:	4501                	li	a0,0
    800048d2:	ffffd097          	auipc	ra,0xffffd
    800048d6:	6d8080e7          	jalr	1752(ra) # 80001faa <argstr>
    800048da:	18054163          	bltz	a0,80004a5c <sys_unlink+0x1a2>
  begin_op();
    800048de:	fffff097          	auipc	ra,0xfffff
    800048e2:	bd0080e7          	jalr	-1072(ra) # 800034ae <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800048e6:	fb040593          	addi	a1,s0,-80
    800048ea:	f3040513          	addi	a0,s0,-208
    800048ee:	fffff097          	auipc	ra,0xfffff
    800048f2:	9be080e7          	jalr	-1602(ra) # 800032ac <nameiparent>
    800048f6:	84aa                	mv	s1,a0
    800048f8:	c979                	beqz	a0,800049ce <sys_unlink+0x114>
  ilock(dp);
    800048fa:	ffffe097          	auipc	ra,0xffffe
    800048fe:	1e8080e7          	jalr	488(ra) # 80002ae2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004902:	00004597          	auipc	a1,0x4
    80004906:	d6e58593          	addi	a1,a1,-658 # 80008670 <syscalls+0x2a0>
    8000490a:	fb040513          	addi	a0,s0,-80
    8000490e:	ffffe097          	auipc	ra,0xffffe
    80004912:	69e080e7          	jalr	1694(ra) # 80002fac <namecmp>
    80004916:	14050a63          	beqz	a0,80004a6a <sys_unlink+0x1b0>
    8000491a:	00004597          	auipc	a1,0x4
    8000491e:	d5e58593          	addi	a1,a1,-674 # 80008678 <syscalls+0x2a8>
    80004922:	fb040513          	addi	a0,s0,-80
    80004926:	ffffe097          	auipc	ra,0xffffe
    8000492a:	686080e7          	jalr	1670(ra) # 80002fac <namecmp>
    8000492e:	12050e63          	beqz	a0,80004a6a <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004932:	f2c40613          	addi	a2,s0,-212
    80004936:	fb040593          	addi	a1,s0,-80
    8000493a:	8526                	mv	a0,s1
    8000493c:	ffffe097          	auipc	ra,0xffffe
    80004940:	68a080e7          	jalr	1674(ra) # 80002fc6 <dirlookup>
    80004944:	892a                	mv	s2,a0
    80004946:	12050263          	beqz	a0,80004a6a <sys_unlink+0x1b0>
  ilock(ip);
    8000494a:	ffffe097          	auipc	ra,0xffffe
    8000494e:	198080e7          	jalr	408(ra) # 80002ae2 <ilock>
  if(ip->nlink < 1)
    80004952:	04a91783          	lh	a5,74(s2)
    80004956:	08f05263          	blez	a5,800049da <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000495a:	04491703          	lh	a4,68(s2)
    8000495e:	4785                	li	a5,1
    80004960:	08f70563          	beq	a4,a5,800049ea <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004964:	4641                	li	a2,16
    80004966:	4581                	li	a1,0
    80004968:	fc040513          	addi	a0,s0,-64
    8000496c:	ffffc097          	auipc	ra,0xffffc
    80004970:	80e080e7          	jalr	-2034(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004974:	4741                	li	a4,16
    80004976:	f2c42683          	lw	a3,-212(s0)
    8000497a:	fc040613          	addi	a2,s0,-64
    8000497e:	4581                	li	a1,0
    80004980:	8526                	mv	a0,s1
    80004982:	ffffe097          	auipc	ra,0xffffe
    80004986:	50c080e7          	jalr	1292(ra) # 80002e8e <writei>
    8000498a:	47c1                	li	a5,16
    8000498c:	0af51563          	bne	a0,a5,80004a36 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004990:	04491703          	lh	a4,68(s2)
    80004994:	4785                	li	a5,1
    80004996:	0af70863          	beq	a4,a5,80004a46 <sys_unlink+0x18c>
  iunlockput(dp);
    8000499a:	8526                	mv	a0,s1
    8000499c:	ffffe097          	auipc	ra,0xffffe
    800049a0:	3a8080e7          	jalr	936(ra) # 80002d44 <iunlockput>
  ip->nlink--;
    800049a4:	04a95783          	lhu	a5,74(s2)
    800049a8:	37fd                	addiw	a5,a5,-1
    800049aa:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800049ae:	854a                	mv	a0,s2
    800049b0:	ffffe097          	auipc	ra,0xffffe
    800049b4:	066080e7          	jalr	102(ra) # 80002a16 <iupdate>
  iunlockput(ip);
    800049b8:	854a                	mv	a0,s2
    800049ba:	ffffe097          	auipc	ra,0xffffe
    800049be:	38a080e7          	jalr	906(ra) # 80002d44 <iunlockput>
  end_op();
    800049c2:	fffff097          	auipc	ra,0xfffff
    800049c6:	b6a080e7          	jalr	-1174(ra) # 8000352c <end_op>
  return 0;
    800049ca:	4501                	li	a0,0
    800049cc:	a84d                	j	80004a7e <sys_unlink+0x1c4>
    end_op();
    800049ce:	fffff097          	auipc	ra,0xfffff
    800049d2:	b5e080e7          	jalr	-1186(ra) # 8000352c <end_op>
    return -1;
    800049d6:	557d                	li	a0,-1
    800049d8:	a05d                	j	80004a7e <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800049da:	00004517          	auipc	a0,0x4
    800049de:	ca650513          	addi	a0,a0,-858 # 80008680 <syscalls+0x2b0>
    800049e2:	00001097          	auipc	ra,0x1
    800049e6:	1ba080e7          	jalr	442(ra) # 80005b9c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800049ea:	04c92703          	lw	a4,76(s2)
    800049ee:	02000793          	li	a5,32
    800049f2:	f6e7f9e3          	bgeu	a5,a4,80004964 <sys_unlink+0xaa>
    800049f6:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049fa:	4741                	li	a4,16
    800049fc:	86ce                	mv	a3,s3
    800049fe:	f1840613          	addi	a2,s0,-232
    80004a02:	4581                	li	a1,0
    80004a04:	854a                	mv	a0,s2
    80004a06:	ffffe097          	auipc	ra,0xffffe
    80004a0a:	390080e7          	jalr	912(ra) # 80002d96 <readi>
    80004a0e:	47c1                	li	a5,16
    80004a10:	00f51b63          	bne	a0,a5,80004a26 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004a14:	f1845783          	lhu	a5,-232(s0)
    80004a18:	e7a1                	bnez	a5,80004a60 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a1a:	29c1                	addiw	s3,s3,16
    80004a1c:	04c92783          	lw	a5,76(s2)
    80004a20:	fcf9ede3          	bltu	s3,a5,800049fa <sys_unlink+0x140>
    80004a24:	b781                	j	80004964 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a26:	00004517          	auipc	a0,0x4
    80004a2a:	c7250513          	addi	a0,a0,-910 # 80008698 <syscalls+0x2c8>
    80004a2e:	00001097          	auipc	ra,0x1
    80004a32:	16e080e7          	jalr	366(ra) # 80005b9c <panic>
    panic("unlink: writei");
    80004a36:	00004517          	auipc	a0,0x4
    80004a3a:	c7a50513          	addi	a0,a0,-902 # 800086b0 <syscalls+0x2e0>
    80004a3e:	00001097          	auipc	ra,0x1
    80004a42:	15e080e7          	jalr	350(ra) # 80005b9c <panic>
    dp->nlink--;
    80004a46:	04a4d783          	lhu	a5,74(s1)
    80004a4a:	37fd                	addiw	a5,a5,-1
    80004a4c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a50:	8526                	mv	a0,s1
    80004a52:	ffffe097          	auipc	ra,0xffffe
    80004a56:	fc4080e7          	jalr	-60(ra) # 80002a16 <iupdate>
    80004a5a:	b781                	j	8000499a <sys_unlink+0xe0>
    return -1;
    80004a5c:	557d                	li	a0,-1
    80004a5e:	a005                	j	80004a7e <sys_unlink+0x1c4>
    iunlockput(ip);
    80004a60:	854a                	mv	a0,s2
    80004a62:	ffffe097          	auipc	ra,0xffffe
    80004a66:	2e2080e7          	jalr	738(ra) # 80002d44 <iunlockput>
  iunlockput(dp);
    80004a6a:	8526                	mv	a0,s1
    80004a6c:	ffffe097          	auipc	ra,0xffffe
    80004a70:	2d8080e7          	jalr	728(ra) # 80002d44 <iunlockput>
  end_op();
    80004a74:	fffff097          	auipc	ra,0xfffff
    80004a78:	ab8080e7          	jalr	-1352(ra) # 8000352c <end_op>
  return -1;
    80004a7c:	557d                	li	a0,-1
}
    80004a7e:	70ae                	ld	ra,232(sp)
    80004a80:	740e                	ld	s0,224(sp)
    80004a82:	64ee                	ld	s1,216(sp)
    80004a84:	694e                	ld	s2,208(sp)
    80004a86:	69ae                	ld	s3,200(sp)
    80004a88:	616d                	addi	sp,sp,240
    80004a8a:	8082                	ret

0000000080004a8c <sys_open>:

uint64
sys_open(void)
{
    80004a8c:	7131                	addi	sp,sp,-192
    80004a8e:	fd06                	sd	ra,184(sp)
    80004a90:	f922                	sd	s0,176(sp)
    80004a92:	f526                	sd	s1,168(sp)
    80004a94:	f14a                	sd	s2,160(sp)
    80004a96:	ed4e                	sd	s3,152(sp)
    80004a98:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004a9a:	f4c40593          	addi	a1,s0,-180
    80004a9e:	4505                	li	a0,1
    80004aa0:	ffffd097          	auipc	ra,0xffffd
    80004aa4:	4ca080e7          	jalr	1226(ra) # 80001f6a <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004aa8:	08000613          	li	a2,128
    80004aac:	f5040593          	addi	a1,s0,-176
    80004ab0:	4501                	li	a0,0
    80004ab2:	ffffd097          	auipc	ra,0xffffd
    80004ab6:	4f8080e7          	jalr	1272(ra) # 80001faa <argstr>
    80004aba:	87aa                	mv	a5,a0
    return -1;
    80004abc:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004abe:	0a07c963          	bltz	a5,80004b70 <sys_open+0xe4>

  begin_op();
    80004ac2:	fffff097          	auipc	ra,0xfffff
    80004ac6:	9ec080e7          	jalr	-1556(ra) # 800034ae <begin_op>

  if(omode & O_CREATE){
    80004aca:	f4c42783          	lw	a5,-180(s0)
    80004ace:	2007f793          	andi	a5,a5,512
    80004ad2:	cfc5                	beqz	a5,80004b8a <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004ad4:	4681                	li	a3,0
    80004ad6:	4601                	li	a2,0
    80004ad8:	4589                	li	a1,2
    80004ada:	f5040513          	addi	a0,s0,-176
    80004ade:	00000097          	auipc	ra,0x0
    80004ae2:	972080e7          	jalr	-1678(ra) # 80004450 <create>
    80004ae6:	84aa                	mv	s1,a0
    if(ip == 0){
    80004ae8:	c959                	beqz	a0,80004b7e <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004aea:	04449703          	lh	a4,68(s1)
    80004aee:	478d                	li	a5,3
    80004af0:	00f71763          	bne	a4,a5,80004afe <sys_open+0x72>
    80004af4:	0464d703          	lhu	a4,70(s1)
    80004af8:	47a5                	li	a5,9
    80004afa:	0ce7ed63          	bltu	a5,a4,80004bd4 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004afe:	fffff097          	auipc	ra,0xfffff
    80004b02:	dbc080e7          	jalr	-580(ra) # 800038ba <filealloc>
    80004b06:	89aa                	mv	s3,a0
    80004b08:	10050363          	beqz	a0,80004c0e <sys_open+0x182>
    80004b0c:	00000097          	auipc	ra,0x0
    80004b10:	902080e7          	jalr	-1790(ra) # 8000440e <fdalloc>
    80004b14:	892a                	mv	s2,a0
    80004b16:	0e054763          	bltz	a0,80004c04 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b1a:	04449703          	lh	a4,68(s1)
    80004b1e:	478d                	li	a5,3
    80004b20:	0cf70563          	beq	a4,a5,80004bea <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b24:	4789                	li	a5,2
    80004b26:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004b2a:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004b2e:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004b32:	f4c42783          	lw	a5,-180(s0)
    80004b36:	0017c713          	xori	a4,a5,1
    80004b3a:	8b05                	andi	a4,a4,1
    80004b3c:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b40:	0037f713          	andi	a4,a5,3
    80004b44:	00e03733          	snez	a4,a4
    80004b48:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004b4c:	4007f793          	andi	a5,a5,1024
    80004b50:	c791                	beqz	a5,80004b5c <sys_open+0xd0>
    80004b52:	04449703          	lh	a4,68(s1)
    80004b56:	4789                	li	a5,2
    80004b58:	0af70063          	beq	a4,a5,80004bf8 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004b5c:	8526                	mv	a0,s1
    80004b5e:	ffffe097          	auipc	ra,0xffffe
    80004b62:	046080e7          	jalr	70(ra) # 80002ba4 <iunlock>
  end_op();
    80004b66:	fffff097          	auipc	ra,0xfffff
    80004b6a:	9c6080e7          	jalr	-1594(ra) # 8000352c <end_op>

  return fd;
    80004b6e:	854a                	mv	a0,s2
}
    80004b70:	70ea                	ld	ra,184(sp)
    80004b72:	744a                	ld	s0,176(sp)
    80004b74:	74aa                	ld	s1,168(sp)
    80004b76:	790a                	ld	s2,160(sp)
    80004b78:	69ea                	ld	s3,152(sp)
    80004b7a:	6129                	addi	sp,sp,192
    80004b7c:	8082                	ret
      end_op();
    80004b7e:	fffff097          	auipc	ra,0xfffff
    80004b82:	9ae080e7          	jalr	-1618(ra) # 8000352c <end_op>
      return -1;
    80004b86:	557d                	li	a0,-1
    80004b88:	b7e5                	j	80004b70 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004b8a:	f5040513          	addi	a0,s0,-176
    80004b8e:	ffffe097          	auipc	ra,0xffffe
    80004b92:	700080e7          	jalr	1792(ra) # 8000328e <namei>
    80004b96:	84aa                	mv	s1,a0
    80004b98:	c905                	beqz	a0,80004bc8 <sys_open+0x13c>
    ilock(ip);
    80004b9a:	ffffe097          	auipc	ra,0xffffe
    80004b9e:	f48080e7          	jalr	-184(ra) # 80002ae2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004ba2:	04449703          	lh	a4,68(s1)
    80004ba6:	4785                	li	a5,1
    80004ba8:	f4f711e3          	bne	a4,a5,80004aea <sys_open+0x5e>
    80004bac:	f4c42783          	lw	a5,-180(s0)
    80004bb0:	d7b9                	beqz	a5,80004afe <sys_open+0x72>
      iunlockput(ip);
    80004bb2:	8526                	mv	a0,s1
    80004bb4:	ffffe097          	auipc	ra,0xffffe
    80004bb8:	190080e7          	jalr	400(ra) # 80002d44 <iunlockput>
      end_op();
    80004bbc:	fffff097          	auipc	ra,0xfffff
    80004bc0:	970080e7          	jalr	-1680(ra) # 8000352c <end_op>
      return -1;
    80004bc4:	557d                	li	a0,-1
    80004bc6:	b76d                	j	80004b70 <sys_open+0xe4>
      end_op();
    80004bc8:	fffff097          	auipc	ra,0xfffff
    80004bcc:	964080e7          	jalr	-1692(ra) # 8000352c <end_op>
      return -1;
    80004bd0:	557d                	li	a0,-1
    80004bd2:	bf79                	j	80004b70 <sys_open+0xe4>
    iunlockput(ip);
    80004bd4:	8526                	mv	a0,s1
    80004bd6:	ffffe097          	auipc	ra,0xffffe
    80004bda:	16e080e7          	jalr	366(ra) # 80002d44 <iunlockput>
    end_op();
    80004bde:	fffff097          	auipc	ra,0xfffff
    80004be2:	94e080e7          	jalr	-1714(ra) # 8000352c <end_op>
    return -1;
    80004be6:	557d                	li	a0,-1
    80004be8:	b761                	j	80004b70 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004bea:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004bee:	04649783          	lh	a5,70(s1)
    80004bf2:	02f99223          	sh	a5,36(s3)
    80004bf6:	bf25                	j	80004b2e <sys_open+0xa2>
    itrunc(ip);
    80004bf8:	8526                	mv	a0,s1
    80004bfa:	ffffe097          	auipc	ra,0xffffe
    80004bfe:	ff6080e7          	jalr	-10(ra) # 80002bf0 <itrunc>
    80004c02:	bfa9                	j	80004b5c <sys_open+0xd0>
      fileclose(f);
    80004c04:	854e                	mv	a0,s3
    80004c06:	fffff097          	auipc	ra,0xfffff
    80004c0a:	d70080e7          	jalr	-656(ra) # 80003976 <fileclose>
    iunlockput(ip);
    80004c0e:	8526                	mv	a0,s1
    80004c10:	ffffe097          	auipc	ra,0xffffe
    80004c14:	134080e7          	jalr	308(ra) # 80002d44 <iunlockput>
    end_op();
    80004c18:	fffff097          	auipc	ra,0xfffff
    80004c1c:	914080e7          	jalr	-1772(ra) # 8000352c <end_op>
    return -1;
    80004c20:	557d                	li	a0,-1
    80004c22:	b7b9                	j	80004b70 <sys_open+0xe4>

0000000080004c24 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c24:	7175                	addi	sp,sp,-144
    80004c26:	e506                	sd	ra,136(sp)
    80004c28:	e122                	sd	s0,128(sp)
    80004c2a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c2c:	fffff097          	auipc	ra,0xfffff
    80004c30:	882080e7          	jalr	-1918(ra) # 800034ae <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004c34:	08000613          	li	a2,128
    80004c38:	f7040593          	addi	a1,s0,-144
    80004c3c:	4501                	li	a0,0
    80004c3e:	ffffd097          	auipc	ra,0xffffd
    80004c42:	36c080e7          	jalr	876(ra) # 80001faa <argstr>
    80004c46:	02054963          	bltz	a0,80004c78 <sys_mkdir+0x54>
    80004c4a:	4681                	li	a3,0
    80004c4c:	4601                	li	a2,0
    80004c4e:	4585                	li	a1,1
    80004c50:	f7040513          	addi	a0,s0,-144
    80004c54:	fffff097          	auipc	ra,0xfffff
    80004c58:	7fc080e7          	jalr	2044(ra) # 80004450 <create>
    80004c5c:	cd11                	beqz	a0,80004c78 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c5e:	ffffe097          	auipc	ra,0xffffe
    80004c62:	0e6080e7          	jalr	230(ra) # 80002d44 <iunlockput>
  end_op();
    80004c66:	fffff097          	auipc	ra,0xfffff
    80004c6a:	8c6080e7          	jalr	-1850(ra) # 8000352c <end_op>
  return 0;
    80004c6e:	4501                	li	a0,0
}
    80004c70:	60aa                	ld	ra,136(sp)
    80004c72:	640a                	ld	s0,128(sp)
    80004c74:	6149                	addi	sp,sp,144
    80004c76:	8082                	ret
    end_op();
    80004c78:	fffff097          	auipc	ra,0xfffff
    80004c7c:	8b4080e7          	jalr	-1868(ra) # 8000352c <end_op>
    return -1;
    80004c80:	557d                	li	a0,-1
    80004c82:	b7fd                	j	80004c70 <sys_mkdir+0x4c>

0000000080004c84 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004c84:	7135                	addi	sp,sp,-160
    80004c86:	ed06                	sd	ra,152(sp)
    80004c88:	e922                	sd	s0,144(sp)
    80004c8a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004c8c:	fffff097          	auipc	ra,0xfffff
    80004c90:	822080e7          	jalr	-2014(ra) # 800034ae <begin_op>
  argint(1, &major);
    80004c94:	f6c40593          	addi	a1,s0,-148
    80004c98:	4505                	li	a0,1
    80004c9a:	ffffd097          	auipc	ra,0xffffd
    80004c9e:	2d0080e7          	jalr	720(ra) # 80001f6a <argint>
  argint(2, &minor);
    80004ca2:	f6840593          	addi	a1,s0,-152
    80004ca6:	4509                	li	a0,2
    80004ca8:	ffffd097          	auipc	ra,0xffffd
    80004cac:	2c2080e7          	jalr	706(ra) # 80001f6a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cb0:	08000613          	li	a2,128
    80004cb4:	f7040593          	addi	a1,s0,-144
    80004cb8:	4501                	li	a0,0
    80004cba:	ffffd097          	auipc	ra,0xffffd
    80004cbe:	2f0080e7          	jalr	752(ra) # 80001faa <argstr>
    80004cc2:	02054b63          	bltz	a0,80004cf8 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004cc6:	f6841683          	lh	a3,-152(s0)
    80004cca:	f6c41603          	lh	a2,-148(s0)
    80004cce:	458d                	li	a1,3
    80004cd0:	f7040513          	addi	a0,s0,-144
    80004cd4:	fffff097          	auipc	ra,0xfffff
    80004cd8:	77c080e7          	jalr	1916(ra) # 80004450 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cdc:	cd11                	beqz	a0,80004cf8 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cde:	ffffe097          	auipc	ra,0xffffe
    80004ce2:	066080e7          	jalr	102(ra) # 80002d44 <iunlockput>
  end_op();
    80004ce6:	fffff097          	auipc	ra,0xfffff
    80004cea:	846080e7          	jalr	-1978(ra) # 8000352c <end_op>
  return 0;
    80004cee:	4501                	li	a0,0
}
    80004cf0:	60ea                	ld	ra,152(sp)
    80004cf2:	644a                	ld	s0,144(sp)
    80004cf4:	610d                	addi	sp,sp,160
    80004cf6:	8082                	ret
    end_op();
    80004cf8:	fffff097          	auipc	ra,0xfffff
    80004cfc:	834080e7          	jalr	-1996(ra) # 8000352c <end_op>
    return -1;
    80004d00:	557d                	li	a0,-1
    80004d02:	b7fd                	j	80004cf0 <sys_mknod+0x6c>

0000000080004d04 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d04:	7135                	addi	sp,sp,-160
    80004d06:	ed06                	sd	ra,152(sp)
    80004d08:	e922                	sd	s0,144(sp)
    80004d0a:	e526                	sd	s1,136(sp)
    80004d0c:	e14a                	sd	s2,128(sp)
    80004d0e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d10:	ffffc097          	auipc	ra,0xffffc
    80004d14:	144080e7          	jalr	324(ra) # 80000e54 <myproc>
    80004d18:	892a                	mv	s2,a0
  
  begin_op();
    80004d1a:	ffffe097          	auipc	ra,0xffffe
    80004d1e:	794080e7          	jalr	1940(ra) # 800034ae <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d22:	08000613          	li	a2,128
    80004d26:	f6040593          	addi	a1,s0,-160
    80004d2a:	4501                	li	a0,0
    80004d2c:	ffffd097          	auipc	ra,0xffffd
    80004d30:	27e080e7          	jalr	638(ra) # 80001faa <argstr>
    80004d34:	04054b63          	bltz	a0,80004d8a <sys_chdir+0x86>
    80004d38:	f6040513          	addi	a0,s0,-160
    80004d3c:	ffffe097          	auipc	ra,0xffffe
    80004d40:	552080e7          	jalr	1362(ra) # 8000328e <namei>
    80004d44:	84aa                	mv	s1,a0
    80004d46:	c131                	beqz	a0,80004d8a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004d48:	ffffe097          	auipc	ra,0xffffe
    80004d4c:	d9a080e7          	jalr	-614(ra) # 80002ae2 <ilock>
  if(ip->type != T_DIR){
    80004d50:	04449703          	lh	a4,68(s1)
    80004d54:	4785                	li	a5,1
    80004d56:	04f71063          	bne	a4,a5,80004d96 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004d5a:	8526                	mv	a0,s1
    80004d5c:	ffffe097          	auipc	ra,0xffffe
    80004d60:	e48080e7          	jalr	-440(ra) # 80002ba4 <iunlock>
  iput(p->cwd);
    80004d64:	15093503          	ld	a0,336(s2)
    80004d68:	ffffe097          	auipc	ra,0xffffe
    80004d6c:	f34080e7          	jalr	-204(ra) # 80002c9c <iput>
  end_op();
    80004d70:	ffffe097          	auipc	ra,0xffffe
    80004d74:	7bc080e7          	jalr	1980(ra) # 8000352c <end_op>
  p->cwd = ip;
    80004d78:	14993823          	sd	s1,336(s2)
  return 0;
    80004d7c:	4501                	li	a0,0
}
    80004d7e:	60ea                	ld	ra,152(sp)
    80004d80:	644a                	ld	s0,144(sp)
    80004d82:	64aa                	ld	s1,136(sp)
    80004d84:	690a                	ld	s2,128(sp)
    80004d86:	610d                	addi	sp,sp,160
    80004d88:	8082                	ret
    end_op();
    80004d8a:	ffffe097          	auipc	ra,0xffffe
    80004d8e:	7a2080e7          	jalr	1954(ra) # 8000352c <end_op>
    return -1;
    80004d92:	557d                	li	a0,-1
    80004d94:	b7ed                	j	80004d7e <sys_chdir+0x7a>
    iunlockput(ip);
    80004d96:	8526                	mv	a0,s1
    80004d98:	ffffe097          	auipc	ra,0xffffe
    80004d9c:	fac080e7          	jalr	-84(ra) # 80002d44 <iunlockput>
    end_op();
    80004da0:	ffffe097          	auipc	ra,0xffffe
    80004da4:	78c080e7          	jalr	1932(ra) # 8000352c <end_op>
    return -1;
    80004da8:	557d                	li	a0,-1
    80004daa:	bfd1                	j	80004d7e <sys_chdir+0x7a>

0000000080004dac <sys_exec>:

uint64
sys_exec(void)
{
    80004dac:	7145                	addi	sp,sp,-464
    80004dae:	e786                	sd	ra,456(sp)
    80004db0:	e3a2                	sd	s0,448(sp)
    80004db2:	ff26                	sd	s1,440(sp)
    80004db4:	fb4a                	sd	s2,432(sp)
    80004db6:	f74e                	sd	s3,424(sp)
    80004db8:	f352                	sd	s4,416(sp)
    80004dba:	ef56                	sd	s5,408(sp)
    80004dbc:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004dbe:	e3840593          	addi	a1,s0,-456
    80004dc2:	4505                	li	a0,1
    80004dc4:	ffffd097          	auipc	ra,0xffffd
    80004dc8:	1c6080e7          	jalr	454(ra) # 80001f8a <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004dcc:	08000613          	li	a2,128
    80004dd0:	f4040593          	addi	a1,s0,-192
    80004dd4:	4501                	li	a0,0
    80004dd6:	ffffd097          	auipc	ra,0xffffd
    80004dda:	1d4080e7          	jalr	468(ra) # 80001faa <argstr>
    80004dde:	87aa                	mv	a5,a0
    return -1;
    80004de0:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004de2:	0c07c363          	bltz	a5,80004ea8 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004de6:	10000613          	li	a2,256
    80004dea:	4581                	li	a1,0
    80004dec:	e4040513          	addi	a0,s0,-448
    80004df0:	ffffb097          	auipc	ra,0xffffb
    80004df4:	38a080e7          	jalr	906(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004df8:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004dfc:	89a6                	mv	s3,s1
    80004dfe:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e00:	02000a13          	li	s4,32
    80004e04:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e08:	00391513          	slli	a0,s2,0x3
    80004e0c:	e3040593          	addi	a1,s0,-464
    80004e10:	e3843783          	ld	a5,-456(s0)
    80004e14:	953e                	add	a0,a0,a5
    80004e16:	ffffd097          	auipc	ra,0xffffd
    80004e1a:	0b6080e7          	jalr	182(ra) # 80001ecc <fetchaddr>
    80004e1e:	02054a63          	bltz	a0,80004e52 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004e22:	e3043783          	ld	a5,-464(s0)
    80004e26:	c3b9                	beqz	a5,80004e6c <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e28:	ffffb097          	auipc	ra,0xffffb
    80004e2c:	2f2080e7          	jalr	754(ra) # 8000011a <kalloc>
    80004e30:	85aa                	mv	a1,a0
    80004e32:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004e36:	cd11                	beqz	a0,80004e52 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004e38:	6605                	lui	a2,0x1
    80004e3a:	e3043503          	ld	a0,-464(s0)
    80004e3e:	ffffd097          	auipc	ra,0xffffd
    80004e42:	0e0080e7          	jalr	224(ra) # 80001f1e <fetchstr>
    80004e46:	00054663          	bltz	a0,80004e52 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004e4a:	0905                	addi	s2,s2,1
    80004e4c:	09a1                	addi	s3,s3,8
    80004e4e:	fb491be3          	bne	s2,s4,80004e04 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e52:	f4040913          	addi	s2,s0,-192
    80004e56:	6088                	ld	a0,0(s1)
    80004e58:	c539                	beqz	a0,80004ea6 <sys_exec+0xfa>
    kfree(argv[i]);
    80004e5a:	ffffb097          	auipc	ra,0xffffb
    80004e5e:	1c2080e7          	jalr	450(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e62:	04a1                	addi	s1,s1,8
    80004e64:	ff2499e3          	bne	s1,s2,80004e56 <sys_exec+0xaa>
  return -1;
    80004e68:	557d                	li	a0,-1
    80004e6a:	a83d                	j	80004ea8 <sys_exec+0xfc>
      argv[i] = 0;
    80004e6c:	0a8e                	slli	s5,s5,0x3
    80004e6e:	fc0a8793          	addi	a5,s5,-64
    80004e72:	00878ab3          	add	s5,a5,s0
    80004e76:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004e7a:	e4040593          	addi	a1,s0,-448
    80004e7e:	f4040513          	addi	a0,s0,-192
    80004e82:	fffff097          	auipc	ra,0xfffff
    80004e86:	16e080e7          	jalr	366(ra) # 80003ff0 <exec>
    80004e8a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e8c:	f4040993          	addi	s3,s0,-192
    80004e90:	6088                	ld	a0,0(s1)
    80004e92:	c901                	beqz	a0,80004ea2 <sys_exec+0xf6>
    kfree(argv[i]);
    80004e94:	ffffb097          	auipc	ra,0xffffb
    80004e98:	188080e7          	jalr	392(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e9c:	04a1                	addi	s1,s1,8
    80004e9e:	ff3499e3          	bne	s1,s3,80004e90 <sys_exec+0xe4>
  return ret;
    80004ea2:	854a                	mv	a0,s2
    80004ea4:	a011                	j	80004ea8 <sys_exec+0xfc>
  return -1;
    80004ea6:	557d                	li	a0,-1
}
    80004ea8:	60be                	ld	ra,456(sp)
    80004eaa:	641e                	ld	s0,448(sp)
    80004eac:	74fa                	ld	s1,440(sp)
    80004eae:	795a                	ld	s2,432(sp)
    80004eb0:	79ba                	ld	s3,424(sp)
    80004eb2:	7a1a                	ld	s4,416(sp)
    80004eb4:	6afa                	ld	s5,408(sp)
    80004eb6:	6179                	addi	sp,sp,464
    80004eb8:	8082                	ret

0000000080004eba <sys_pipe>:

uint64
sys_pipe(void)
{
    80004eba:	7139                	addi	sp,sp,-64
    80004ebc:	fc06                	sd	ra,56(sp)
    80004ebe:	f822                	sd	s0,48(sp)
    80004ec0:	f426                	sd	s1,40(sp)
    80004ec2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004ec4:	ffffc097          	auipc	ra,0xffffc
    80004ec8:	f90080e7          	jalr	-112(ra) # 80000e54 <myproc>
    80004ecc:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004ece:	fd840593          	addi	a1,s0,-40
    80004ed2:	4501                	li	a0,0
    80004ed4:	ffffd097          	auipc	ra,0xffffd
    80004ed8:	0b6080e7          	jalr	182(ra) # 80001f8a <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004edc:	fc840593          	addi	a1,s0,-56
    80004ee0:	fd040513          	addi	a0,s0,-48
    80004ee4:	fffff097          	auipc	ra,0xfffff
    80004ee8:	dc2080e7          	jalr	-574(ra) # 80003ca6 <pipealloc>
    return -1;
    80004eec:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004eee:	0c054463          	bltz	a0,80004fb6 <sys_pipe+0xfc>
  fd0 = -1;
    80004ef2:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004ef6:	fd043503          	ld	a0,-48(s0)
    80004efa:	fffff097          	auipc	ra,0xfffff
    80004efe:	514080e7          	jalr	1300(ra) # 8000440e <fdalloc>
    80004f02:	fca42223          	sw	a0,-60(s0)
    80004f06:	08054b63          	bltz	a0,80004f9c <sys_pipe+0xe2>
    80004f0a:	fc843503          	ld	a0,-56(s0)
    80004f0e:	fffff097          	auipc	ra,0xfffff
    80004f12:	500080e7          	jalr	1280(ra) # 8000440e <fdalloc>
    80004f16:	fca42023          	sw	a0,-64(s0)
    80004f1a:	06054863          	bltz	a0,80004f8a <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f1e:	4691                	li	a3,4
    80004f20:	fc440613          	addi	a2,s0,-60
    80004f24:	fd843583          	ld	a1,-40(s0)
    80004f28:	68a8                	ld	a0,80(s1)
    80004f2a:	ffffc097          	auipc	ra,0xffffc
    80004f2e:	bea080e7          	jalr	-1046(ra) # 80000b14 <copyout>
    80004f32:	02054063          	bltz	a0,80004f52 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004f36:	4691                	li	a3,4
    80004f38:	fc040613          	addi	a2,s0,-64
    80004f3c:	fd843583          	ld	a1,-40(s0)
    80004f40:	0591                	addi	a1,a1,4
    80004f42:	68a8                	ld	a0,80(s1)
    80004f44:	ffffc097          	auipc	ra,0xffffc
    80004f48:	bd0080e7          	jalr	-1072(ra) # 80000b14 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004f4c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f4e:	06055463          	bgez	a0,80004fb6 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80004f52:	fc442783          	lw	a5,-60(s0)
    80004f56:	07e9                	addi	a5,a5,26
    80004f58:	078e                	slli	a5,a5,0x3
    80004f5a:	97a6                	add	a5,a5,s1
    80004f5c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004f60:	fc042783          	lw	a5,-64(s0)
    80004f64:	07e9                	addi	a5,a5,26
    80004f66:	078e                	slli	a5,a5,0x3
    80004f68:	94be                	add	s1,s1,a5
    80004f6a:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004f6e:	fd043503          	ld	a0,-48(s0)
    80004f72:	fffff097          	auipc	ra,0xfffff
    80004f76:	a04080e7          	jalr	-1532(ra) # 80003976 <fileclose>
    fileclose(wf);
    80004f7a:	fc843503          	ld	a0,-56(s0)
    80004f7e:	fffff097          	auipc	ra,0xfffff
    80004f82:	9f8080e7          	jalr	-1544(ra) # 80003976 <fileclose>
    return -1;
    80004f86:	57fd                	li	a5,-1
    80004f88:	a03d                	j	80004fb6 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80004f8a:	fc442783          	lw	a5,-60(s0)
    80004f8e:	0007c763          	bltz	a5,80004f9c <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80004f92:	07e9                	addi	a5,a5,26
    80004f94:	078e                	slli	a5,a5,0x3
    80004f96:	97a6                	add	a5,a5,s1
    80004f98:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004f9c:	fd043503          	ld	a0,-48(s0)
    80004fa0:	fffff097          	auipc	ra,0xfffff
    80004fa4:	9d6080e7          	jalr	-1578(ra) # 80003976 <fileclose>
    fileclose(wf);
    80004fa8:	fc843503          	ld	a0,-56(s0)
    80004fac:	fffff097          	auipc	ra,0xfffff
    80004fb0:	9ca080e7          	jalr	-1590(ra) # 80003976 <fileclose>
    return -1;
    80004fb4:	57fd                	li	a5,-1
}
    80004fb6:	853e                	mv	a0,a5
    80004fb8:	70e2                	ld	ra,56(sp)
    80004fba:	7442                	ld	s0,48(sp)
    80004fbc:	74a2                	ld	s1,40(sp)
    80004fbe:	6121                	addi	sp,sp,64
    80004fc0:	8082                	ret
	...

0000000080004fd0 <kernelvec>:
    80004fd0:	7111                	addi	sp,sp,-256
    80004fd2:	e006                	sd	ra,0(sp)
    80004fd4:	e40a                	sd	sp,8(sp)
    80004fd6:	e80e                	sd	gp,16(sp)
    80004fd8:	ec12                	sd	tp,24(sp)
    80004fda:	f016                	sd	t0,32(sp)
    80004fdc:	f41a                	sd	t1,40(sp)
    80004fde:	f81e                	sd	t2,48(sp)
    80004fe0:	fc22                	sd	s0,56(sp)
    80004fe2:	e0a6                	sd	s1,64(sp)
    80004fe4:	e4aa                	sd	a0,72(sp)
    80004fe6:	e8ae                	sd	a1,80(sp)
    80004fe8:	ecb2                	sd	a2,88(sp)
    80004fea:	f0b6                	sd	a3,96(sp)
    80004fec:	f4ba                	sd	a4,104(sp)
    80004fee:	f8be                	sd	a5,112(sp)
    80004ff0:	fcc2                	sd	a6,120(sp)
    80004ff2:	e146                	sd	a7,128(sp)
    80004ff4:	e54a                	sd	s2,136(sp)
    80004ff6:	e94e                	sd	s3,144(sp)
    80004ff8:	ed52                	sd	s4,152(sp)
    80004ffa:	f156                	sd	s5,160(sp)
    80004ffc:	f55a                	sd	s6,168(sp)
    80004ffe:	f95e                	sd	s7,176(sp)
    80005000:	fd62                	sd	s8,184(sp)
    80005002:	e1e6                	sd	s9,192(sp)
    80005004:	e5ea                	sd	s10,200(sp)
    80005006:	e9ee                	sd	s11,208(sp)
    80005008:	edf2                	sd	t3,216(sp)
    8000500a:	f1f6                	sd	t4,224(sp)
    8000500c:	f5fa                	sd	t5,232(sp)
    8000500e:	f9fe                	sd	t6,240(sp)
    80005010:	d89fc0ef          	jal	ra,80001d98 <kerneltrap>
    80005014:	6082                	ld	ra,0(sp)
    80005016:	6122                	ld	sp,8(sp)
    80005018:	61c2                	ld	gp,16(sp)
    8000501a:	7282                	ld	t0,32(sp)
    8000501c:	7322                	ld	t1,40(sp)
    8000501e:	73c2                	ld	t2,48(sp)
    80005020:	7462                	ld	s0,56(sp)
    80005022:	6486                	ld	s1,64(sp)
    80005024:	6526                	ld	a0,72(sp)
    80005026:	65c6                	ld	a1,80(sp)
    80005028:	6666                	ld	a2,88(sp)
    8000502a:	7686                	ld	a3,96(sp)
    8000502c:	7726                	ld	a4,104(sp)
    8000502e:	77c6                	ld	a5,112(sp)
    80005030:	7866                	ld	a6,120(sp)
    80005032:	688a                	ld	a7,128(sp)
    80005034:	692a                	ld	s2,136(sp)
    80005036:	69ca                	ld	s3,144(sp)
    80005038:	6a6a                	ld	s4,152(sp)
    8000503a:	7a8a                	ld	s5,160(sp)
    8000503c:	7b2a                	ld	s6,168(sp)
    8000503e:	7bca                	ld	s7,176(sp)
    80005040:	7c6a                	ld	s8,184(sp)
    80005042:	6c8e                	ld	s9,192(sp)
    80005044:	6d2e                	ld	s10,200(sp)
    80005046:	6dce                	ld	s11,208(sp)
    80005048:	6e6e                	ld	t3,216(sp)
    8000504a:	7e8e                	ld	t4,224(sp)
    8000504c:	7f2e                	ld	t5,232(sp)
    8000504e:	7fce                	ld	t6,240(sp)
    80005050:	6111                	addi	sp,sp,256
    80005052:	10200073          	sret
    80005056:	00000013          	nop
    8000505a:	00000013          	nop
    8000505e:	0001                	nop

0000000080005060 <timervec>:
    80005060:	34051573          	csrrw	a0,mscratch,a0
    80005064:	e10c                	sd	a1,0(a0)
    80005066:	e510                	sd	a2,8(a0)
    80005068:	e914                	sd	a3,16(a0)
    8000506a:	6d0c                	ld	a1,24(a0)
    8000506c:	7110                	ld	a2,32(a0)
    8000506e:	6194                	ld	a3,0(a1)
    80005070:	96b2                	add	a3,a3,a2
    80005072:	e194                	sd	a3,0(a1)
    80005074:	4589                	li	a1,2
    80005076:	14459073          	csrw	sip,a1
    8000507a:	6914                	ld	a3,16(a0)
    8000507c:	6510                	ld	a2,8(a0)
    8000507e:	610c                	ld	a1,0(a0)
    80005080:	34051573          	csrrw	a0,mscratch,a0
    80005084:	30200073          	mret
	...

000000008000508a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000508a:	1141                	addi	sp,sp,-16
    8000508c:	e422                	sd	s0,8(sp)
    8000508e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005090:	0c0007b7          	lui	a5,0xc000
    80005094:	4705                	li	a4,1
    80005096:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005098:	c3d8                	sw	a4,4(a5)
}
    8000509a:	6422                	ld	s0,8(sp)
    8000509c:	0141                	addi	sp,sp,16
    8000509e:	8082                	ret

00000000800050a0 <plicinithart>:

void
plicinithart(void)
{
    800050a0:	1141                	addi	sp,sp,-16
    800050a2:	e406                	sd	ra,8(sp)
    800050a4:	e022                	sd	s0,0(sp)
    800050a6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800050a8:	ffffc097          	auipc	ra,0xffffc
    800050ac:	d80080e7          	jalr	-640(ra) # 80000e28 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800050b0:	0085171b          	slliw	a4,a0,0x8
    800050b4:	0c0027b7          	lui	a5,0xc002
    800050b8:	97ba                	add	a5,a5,a4
    800050ba:	40200713          	li	a4,1026
    800050be:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800050c2:	00d5151b          	slliw	a0,a0,0xd
    800050c6:	0c2017b7          	lui	a5,0xc201
    800050ca:	97aa                	add	a5,a5,a0
    800050cc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800050d0:	60a2                	ld	ra,8(sp)
    800050d2:	6402                	ld	s0,0(sp)
    800050d4:	0141                	addi	sp,sp,16
    800050d6:	8082                	ret

00000000800050d8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800050d8:	1141                	addi	sp,sp,-16
    800050da:	e406                	sd	ra,8(sp)
    800050dc:	e022                	sd	s0,0(sp)
    800050de:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800050e0:	ffffc097          	auipc	ra,0xffffc
    800050e4:	d48080e7          	jalr	-696(ra) # 80000e28 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800050e8:	00d5151b          	slliw	a0,a0,0xd
    800050ec:	0c2017b7          	lui	a5,0xc201
    800050f0:	97aa                	add	a5,a5,a0
  return irq;
}
    800050f2:	43c8                	lw	a0,4(a5)
    800050f4:	60a2                	ld	ra,8(sp)
    800050f6:	6402                	ld	s0,0(sp)
    800050f8:	0141                	addi	sp,sp,16
    800050fa:	8082                	ret

00000000800050fc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800050fc:	1101                	addi	sp,sp,-32
    800050fe:	ec06                	sd	ra,24(sp)
    80005100:	e822                	sd	s0,16(sp)
    80005102:	e426                	sd	s1,8(sp)
    80005104:	1000                	addi	s0,sp,32
    80005106:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005108:	ffffc097          	auipc	ra,0xffffc
    8000510c:	d20080e7          	jalr	-736(ra) # 80000e28 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005110:	00d5151b          	slliw	a0,a0,0xd
    80005114:	0c2017b7          	lui	a5,0xc201
    80005118:	97aa                	add	a5,a5,a0
    8000511a:	c3c4                	sw	s1,4(a5)
}
    8000511c:	60e2                	ld	ra,24(sp)
    8000511e:	6442                	ld	s0,16(sp)
    80005120:	64a2                	ld	s1,8(sp)
    80005122:	6105                	addi	sp,sp,32
    80005124:	8082                	ret

0000000080005126 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005126:	1141                	addi	sp,sp,-16
    80005128:	e406                	sd	ra,8(sp)
    8000512a:	e022                	sd	s0,0(sp)
    8000512c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000512e:	479d                	li	a5,7
    80005130:	04a7cc63          	blt	a5,a0,80005188 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005134:	00015797          	auipc	a5,0x15
    80005138:	89c78793          	addi	a5,a5,-1892 # 800199d0 <disk>
    8000513c:	97aa                	add	a5,a5,a0
    8000513e:	0187c783          	lbu	a5,24(a5)
    80005142:	ebb9                	bnez	a5,80005198 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005144:	00451693          	slli	a3,a0,0x4
    80005148:	00015797          	auipc	a5,0x15
    8000514c:	88878793          	addi	a5,a5,-1912 # 800199d0 <disk>
    80005150:	6398                	ld	a4,0(a5)
    80005152:	9736                	add	a4,a4,a3
    80005154:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005158:	6398                	ld	a4,0(a5)
    8000515a:	9736                	add	a4,a4,a3
    8000515c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005160:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005164:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005168:	97aa                	add	a5,a5,a0
    8000516a:	4705                	li	a4,1
    8000516c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005170:	00015517          	auipc	a0,0x15
    80005174:	87850513          	addi	a0,a0,-1928 # 800199e8 <disk+0x18>
    80005178:	ffffc097          	auipc	ra,0xffffc
    8000517c:	3e8080e7          	jalr	1000(ra) # 80001560 <wakeup>
}
    80005180:	60a2                	ld	ra,8(sp)
    80005182:	6402                	ld	s0,0(sp)
    80005184:	0141                	addi	sp,sp,16
    80005186:	8082                	ret
    panic("free_desc 1");
    80005188:	00003517          	auipc	a0,0x3
    8000518c:	53850513          	addi	a0,a0,1336 # 800086c0 <syscalls+0x2f0>
    80005190:	00001097          	auipc	ra,0x1
    80005194:	a0c080e7          	jalr	-1524(ra) # 80005b9c <panic>
    panic("free_desc 2");
    80005198:	00003517          	auipc	a0,0x3
    8000519c:	53850513          	addi	a0,a0,1336 # 800086d0 <syscalls+0x300>
    800051a0:	00001097          	auipc	ra,0x1
    800051a4:	9fc080e7          	jalr	-1540(ra) # 80005b9c <panic>

00000000800051a8 <virtio_disk_init>:
{
    800051a8:	1101                	addi	sp,sp,-32
    800051aa:	ec06                	sd	ra,24(sp)
    800051ac:	e822                	sd	s0,16(sp)
    800051ae:	e426                	sd	s1,8(sp)
    800051b0:	e04a                	sd	s2,0(sp)
    800051b2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800051b4:	00003597          	auipc	a1,0x3
    800051b8:	52c58593          	addi	a1,a1,1324 # 800086e0 <syscalls+0x310>
    800051bc:	00015517          	auipc	a0,0x15
    800051c0:	93c50513          	addi	a0,a0,-1732 # 80019af8 <disk+0x128>
    800051c4:	00001097          	auipc	ra,0x1
    800051c8:	e80080e7          	jalr	-384(ra) # 80006044 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051cc:	100017b7          	lui	a5,0x10001
    800051d0:	4398                	lw	a4,0(a5)
    800051d2:	2701                	sext.w	a4,a4
    800051d4:	747277b7          	lui	a5,0x74727
    800051d8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800051dc:	14f71b63          	bne	a4,a5,80005332 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800051e0:	100017b7          	lui	a5,0x10001
    800051e4:	43dc                	lw	a5,4(a5)
    800051e6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051e8:	4709                	li	a4,2
    800051ea:	14e79463          	bne	a5,a4,80005332 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800051ee:	100017b7          	lui	a5,0x10001
    800051f2:	479c                	lw	a5,8(a5)
    800051f4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800051f6:	12e79e63          	bne	a5,a4,80005332 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800051fa:	100017b7          	lui	a5,0x10001
    800051fe:	47d8                	lw	a4,12(a5)
    80005200:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005202:	554d47b7          	lui	a5,0x554d4
    80005206:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000520a:	12f71463          	bne	a4,a5,80005332 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000520e:	100017b7          	lui	a5,0x10001
    80005212:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005216:	4705                	li	a4,1
    80005218:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000521a:	470d                	li	a4,3
    8000521c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000521e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005220:	c7ffe6b7          	lui	a3,0xc7ffe
    80005224:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdca0f>
    80005228:	8f75                	and	a4,a4,a3
    8000522a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000522c:	472d                	li	a4,11
    8000522e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005230:	5bbc                	lw	a5,112(a5)
    80005232:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005236:	8ba1                	andi	a5,a5,8
    80005238:	10078563          	beqz	a5,80005342 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000523c:	100017b7          	lui	a5,0x10001
    80005240:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005244:	43fc                	lw	a5,68(a5)
    80005246:	2781                	sext.w	a5,a5
    80005248:	10079563          	bnez	a5,80005352 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000524c:	100017b7          	lui	a5,0x10001
    80005250:	5bdc                	lw	a5,52(a5)
    80005252:	2781                	sext.w	a5,a5
  if(max == 0)
    80005254:	10078763          	beqz	a5,80005362 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005258:	471d                	li	a4,7
    8000525a:	10f77c63          	bgeu	a4,a5,80005372 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000525e:	ffffb097          	auipc	ra,0xffffb
    80005262:	ebc080e7          	jalr	-324(ra) # 8000011a <kalloc>
    80005266:	00014497          	auipc	s1,0x14
    8000526a:	76a48493          	addi	s1,s1,1898 # 800199d0 <disk>
    8000526e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005270:	ffffb097          	auipc	ra,0xffffb
    80005274:	eaa080e7          	jalr	-342(ra) # 8000011a <kalloc>
    80005278:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000527a:	ffffb097          	auipc	ra,0xffffb
    8000527e:	ea0080e7          	jalr	-352(ra) # 8000011a <kalloc>
    80005282:	87aa                	mv	a5,a0
    80005284:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005286:	6088                	ld	a0,0(s1)
    80005288:	cd6d                	beqz	a0,80005382 <virtio_disk_init+0x1da>
    8000528a:	00014717          	auipc	a4,0x14
    8000528e:	74e73703          	ld	a4,1870(a4) # 800199d8 <disk+0x8>
    80005292:	cb65                	beqz	a4,80005382 <virtio_disk_init+0x1da>
    80005294:	c7fd                	beqz	a5,80005382 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005296:	6605                	lui	a2,0x1
    80005298:	4581                	li	a1,0
    8000529a:	ffffb097          	auipc	ra,0xffffb
    8000529e:	ee0080e7          	jalr	-288(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    800052a2:	00014497          	auipc	s1,0x14
    800052a6:	72e48493          	addi	s1,s1,1838 # 800199d0 <disk>
    800052aa:	6605                	lui	a2,0x1
    800052ac:	4581                	li	a1,0
    800052ae:	6488                	ld	a0,8(s1)
    800052b0:	ffffb097          	auipc	ra,0xffffb
    800052b4:	eca080e7          	jalr	-310(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    800052b8:	6605                	lui	a2,0x1
    800052ba:	4581                	li	a1,0
    800052bc:	6888                	ld	a0,16(s1)
    800052be:	ffffb097          	auipc	ra,0xffffb
    800052c2:	ebc080e7          	jalr	-324(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800052c6:	100017b7          	lui	a5,0x10001
    800052ca:	4721                	li	a4,8
    800052cc:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800052ce:	4098                	lw	a4,0(s1)
    800052d0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800052d4:	40d8                	lw	a4,4(s1)
    800052d6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800052da:	6498                	ld	a4,8(s1)
    800052dc:	0007069b          	sext.w	a3,a4
    800052e0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800052e4:	9701                	srai	a4,a4,0x20
    800052e6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800052ea:	6898                	ld	a4,16(s1)
    800052ec:	0007069b          	sext.w	a3,a4
    800052f0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800052f4:	9701                	srai	a4,a4,0x20
    800052f6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800052fa:	4705                	li	a4,1
    800052fc:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800052fe:	00e48c23          	sb	a4,24(s1)
    80005302:	00e48ca3          	sb	a4,25(s1)
    80005306:	00e48d23          	sb	a4,26(s1)
    8000530a:	00e48da3          	sb	a4,27(s1)
    8000530e:	00e48e23          	sb	a4,28(s1)
    80005312:	00e48ea3          	sb	a4,29(s1)
    80005316:	00e48f23          	sb	a4,30(s1)
    8000531a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000531e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005322:	0727a823          	sw	s2,112(a5)
}
    80005326:	60e2                	ld	ra,24(sp)
    80005328:	6442                	ld	s0,16(sp)
    8000532a:	64a2                	ld	s1,8(sp)
    8000532c:	6902                	ld	s2,0(sp)
    8000532e:	6105                	addi	sp,sp,32
    80005330:	8082                	ret
    panic("could not find virtio disk");
    80005332:	00003517          	auipc	a0,0x3
    80005336:	3be50513          	addi	a0,a0,958 # 800086f0 <syscalls+0x320>
    8000533a:	00001097          	auipc	ra,0x1
    8000533e:	862080e7          	jalr	-1950(ra) # 80005b9c <panic>
    panic("virtio disk FEATURES_OK unset");
    80005342:	00003517          	auipc	a0,0x3
    80005346:	3ce50513          	addi	a0,a0,974 # 80008710 <syscalls+0x340>
    8000534a:	00001097          	auipc	ra,0x1
    8000534e:	852080e7          	jalr	-1966(ra) # 80005b9c <panic>
    panic("virtio disk should not be ready");
    80005352:	00003517          	auipc	a0,0x3
    80005356:	3de50513          	addi	a0,a0,990 # 80008730 <syscalls+0x360>
    8000535a:	00001097          	auipc	ra,0x1
    8000535e:	842080e7          	jalr	-1982(ra) # 80005b9c <panic>
    panic("virtio disk has no queue 0");
    80005362:	00003517          	auipc	a0,0x3
    80005366:	3ee50513          	addi	a0,a0,1006 # 80008750 <syscalls+0x380>
    8000536a:	00001097          	auipc	ra,0x1
    8000536e:	832080e7          	jalr	-1998(ra) # 80005b9c <panic>
    panic("virtio disk max queue too short");
    80005372:	00003517          	auipc	a0,0x3
    80005376:	3fe50513          	addi	a0,a0,1022 # 80008770 <syscalls+0x3a0>
    8000537a:	00001097          	auipc	ra,0x1
    8000537e:	822080e7          	jalr	-2014(ra) # 80005b9c <panic>
    panic("virtio disk kalloc");
    80005382:	00003517          	auipc	a0,0x3
    80005386:	40e50513          	addi	a0,a0,1038 # 80008790 <syscalls+0x3c0>
    8000538a:	00001097          	auipc	ra,0x1
    8000538e:	812080e7          	jalr	-2030(ra) # 80005b9c <panic>

0000000080005392 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005392:	7119                	addi	sp,sp,-128
    80005394:	fc86                	sd	ra,120(sp)
    80005396:	f8a2                	sd	s0,112(sp)
    80005398:	f4a6                	sd	s1,104(sp)
    8000539a:	f0ca                	sd	s2,96(sp)
    8000539c:	ecce                	sd	s3,88(sp)
    8000539e:	e8d2                	sd	s4,80(sp)
    800053a0:	e4d6                	sd	s5,72(sp)
    800053a2:	e0da                	sd	s6,64(sp)
    800053a4:	fc5e                	sd	s7,56(sp)
    800053a6:	f862                	sd	s8,48(sp)
    800053a8:	f466                	sd	s9,40(sp)
    800053aa:	f06a                	sd	s10,32(sp)
    800053ac:	ec6e                	sd	s11,24(sp)
    800053ae:	0100                	addi	s0,sp,128
    800053b0:	8aaa                	mv	s5,a0
    800053b2:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053b4:	00c52d03          	lw	s10,12(a0)
    800053b8:	001d1d1b          	slliw	s10,s10,0x1
    800053bc:	1d02                	slli	s10,s10,0x20
    800053be:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    800053c2:	00014517          	auipc	a0,0x14
    800053c6:	73650513          	addi	a0,a0,1846 # 80019af8 <disk+0x128>
    800053ca:	00001097          	auipc	ra,0x1
    800053ce:	d0a080e7          	jalr	-758(ra) # 800060d4 <acquire>
  for(int i = 0; i < 3; i++){
    800053d2:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800053d4:	44a1                	li	s1,8
      disk.free[i] = 0;
    800053d6:	00014b97          	auipc	s7,0x14
    800053da:	5fab8b93          	addi	s7,s7,1530 # 800199d0 <disk>
  for(int i = 0; i < 3; i++){
    800053de:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800053e0:	00014c97          	auipc	s9,0x14
    800053e4:	718c8c93          	addi	s9,s9,1816 # 80019af8 <disk+0x128>
    800053e8:	a08d                	j	8000544a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800053ea:	00fb8733          	add	a4,s7,a5
    800053ee:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800053f2:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800053f4:	0207c563          	bltz	a5,8000541e <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800053f8:	2905                	addiw	s2,s2,1
    800053fa:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800053fc:	05690c63          	beq	s2,s6,80005454 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80005400:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005402:	00014717          	auipc	a4,0x14
    80005406:	5ce70713          	addi	a4,a4,1486 # 800199d0 <disk>
    8000540a:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000540c:	01874683          	lbu	a3,24(a4)
    80005410:	fee9                	bnez	a3,800053ea <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005412:	2785                	addiw	a5,a5,1
    80005414:	0705                	addi	a4,a4,1
    80005416:	fe979be3          	bne	a5,s1,8000540c <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000541a:	57fd                	li	a5,-1
    8000541c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000541e:	01205d63          	blez	s2,80005438 <virtio_disk_rw+0xa6>
    80005422:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005424:	000a2503          	lw	a0,0(s4)
    80005428:	00000097          	auipc	ra,0x0
    8000542c:	cfe080e7          	jalr	-770(ra) # 80005126 <free_desc>
      for(int j = 0; j < i; j++)
    80005430:	2d85                	addiw	s11,s11,1
    80005432:	0a11                	addi	s4,s4,4
    80005434:	ff2d98e3          	bne	s11,s2,80005424 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005438:	85e6                	mv	a1,s9
    8000543a:	00014517          	auipc	a0,0x14
    8000543e:	5ae50513          	addi	a0,a0,1454 # 800199e8 <disk+0x18>
    80005442:	ffffc097          	auipc	ra,0xffffc
    80005446:	0ba080e7          	jalr	186(ra) # 800014fc <sleep>
  for(int i = 0; i < 3; i++){
    8000544a:	f8040a13          	addi	s4,s0,-128
{
    8000544e:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005450:	894e                	mv	s2,s3
    80005452:	b77d                	j	80005400 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005454:	f8042503          	lw	a0,-128(s0)
    80005458:	00a50713          	addi	a4,a0,10
    8000545c:	0712                	slli	a4,a4,0x4

  if(write)
    8000545e:	00014797          	auipc	a5,0x14
    80005462:	57278793          	addi	a5,a5,1394 # 800199d0 <disk>
    80005466:	00e786b3          	add	a3,a5,a4
    8000546a:	01803633          	snez	a2,s8
    8000546e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005470:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005474:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005478:	f6070613          	addi	a2,a4,-160
    8000547c:	6394                	ld	a3,0(a5)
    8000547e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005480:	00870593          	addi	a1,a4,8
    80005484:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005486:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005488:	0007b803          	ld	a6,0(a5)
    8000548c:	9642                	add	a2,a2,a6
    8000548e:	46c1                	li	a3,16
    80005490:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005492:	4585                	li	a1,1
    80005494:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005498:	f8442683          	lw	a3,-124(s0)
    8000549c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800054a0:	0692                	slli	a3,a3,0x4
    800054a2:	9836                	add	a6,a6,a3
    800054a4:	058a8613          	addi	a2,s5,88
    800054a8:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    800054ac:	0007b803          	ld	a6,0(a5)
    800054b0:	96c2                	add	a3,a3,a6
    800054b2:	40000613          	li	a2,1024
    800054b6:	c690                	sw	a2,8(a3)
  if(write)
    800054b8:	001c3613          	seqz	a2,s8
    800054bc:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800054c0:	00166613          	ori	a2,a2,1
    800054c4:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800054c8:	f8842603          	lw	a2,-120(s0)
    800054cc:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800054d0:	00250693          	addi	a3,a0,2
    800054d4:	0692                	slli	a3,a3,0x4
    800054d6:	96be                	add	a3,a3,a5
    800054d8:	58fd                	li	a7,-1
    800054da:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054de:	0612                	slli	a2,a2,0x4
    800054e0:	9832                	add	a6,a6,a2
    800054e2:	f9070713          	addi	a4,a4,-112
    800054e6:	973e                	add	a4,a4,a5
    800054e8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800054ec:	6398                	ld	a4,0(a5)
    800054ee:	9732                	add	a4,a4,a2
    800054f0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800054f2:	4609                	li	a2,2
    800054f4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800054f8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800054fc:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    80005500:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005504:	6794                	ld	a3,8(a5)
    80005506:	0026d703          	lhu	a4,2(a3)
    8000550a:	8b1d                	andi	a4,a4,7
    8000550c:	0706                	slli	a4,a4,0x1
    8000550e:	96ba                	add	a3,a3,a4
    80005510:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005514:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005518:	6798                	ld	a4,8(a5)
    8000551a:	00275783          	lhu	a5,2(a4)
    8000551e:	2785                	addiw	a5,a5,1
    80005520:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005524:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005528:	100017b7          	lui	a5,0x10001
    8000552c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005530:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    80005534:	00014917          	auipc	s2,0x14
    80005538:	5c490913          	addi	s2,s2,1476 # 80019af8 <disk+0x128>
  while(b->disk == 1) {
    8000553c:	4485                	li	s1,1
    8000553e:	00b79c63          	bne	a5,a1,80005556 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005542:	85ca                	mv	a1,s2
    80005544:	8556                	mv	a0,s5
    80005546:	ffffc097          	auipc	ra,0xffffc
    8000554a:	fb6080e7          	jalr	-74(ra) # 800014fc <sleep>
  while(b->disk == 1) {
    8000554e:	004aa783          	lw	a5,4(s5)
    80005552:	fe9788e3          	beq	a5,s1,80005542 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005556:	f8042903          	lw	s2,-128(s0)
    8000555a:	00290713          	addi	a4,s2,2
    8000555e:	0712                	slli	a4,a4,0x4
    80005560:	00014797          	auipc	a5,0x14
    80005564:	47078793          	addi	a5,a5,1136 # 800199d0 <disk>
    80005568:	97ba                	add	a5,a5,a4
    8000556a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000556e:	00014997          	auipc	s3,0x14
    80005572:	46298993          	addi	s3,s3,1122 # 800199d0 <disk>
    80005576:	00491713          	slli	a4,s2,0x4
    8000557a:	0009b783          	ld	a5,0(s3)
    8000557e:	97ba                	add	a5,a5,a4
    80005580:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005584:	854a                	mv	a0,s2
    80005586:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000558a:	00000097          	auipc	ra,0x0
    8000558e:	b9c080e7          	jalr	-1124(ra) # 80005126 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005592:	8885                	andi	s1,s1,1
    80005594:	f0ed                	bnez	s1,80005576 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005596:	00014517          	auipc	a0,0x14
    8000559a:	56250513          	addi	a0,a0,1378 # 80019af8 <disk+0x128>
    8000559e:	00001097          	auipc	ra,0x1
    800055a2:	bea080e7          	jalr	-1046(ra) # 80006188 <release>
}
    800055a6:	70e6                	ld	ra,120(sp)
    800055a8:	7446                	ld	s0,112(sp)
    800055aa:	74a6                	ld	s1,104(sp)
    800055ac:	7906                	ld	s2,96(sp)
    800055ae:	69e6                	ld	s3,88(sp)
    800055b0:	6a46                	ld	s4,80(sp)
    800055b2:	6aa6                	ld	s5,72(sp)
    800055b4:	6b06                	ld	s6,64(sp)
    800055b6:	7be2                	ld	s7,56(sp)
    800055b8:	7c42                	ld	s8,48(sp)
    800055ba:	7ca2                	ld	s9,40(sp)
    800055bc:	7d02                	ld	s10,32(sp)
    800055be:	6de2                	ld	s11,24(sp)
    800055c0:	6109                	addi	sp,sp,128
    800055c2:	8082                	ret

00000000800055c4 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800055c4:	1101                	addi	sp,sp,-32
    800055c6:	ec06                	sd	ra,24(sp)
    800055c8:	e822                	sd	s0,16(sp)
    800055ca:	e426                	sd	s1,8(sp)
    800055cc:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800055ce:	00014497          	auipc	s1,0x14
    800055d2:	40248493          	addi	s1,s1,1026 # 800199d0 <disk>
    800055d6:	00014517          	auipc	a0,0x14
    800055da:	52250513          	addi	a0,a0,1314 # 80019af8 <disk+0x128>
    800055de:	00001097          	auipc	ra,0x1
    800055e2:	af6080e7          	jalr	-1290(ra) # 800060d4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800055e6:	10001737          	lui	a4,0x10001
    800055ea:	533c                	lw	a5,96(a4)
    800055ec:	8b8d                	andi	a5,a5,3
    800055ee:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800055f0:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800055f4:	689c                	ld	a5,16(s1)
    800055f6:	0204d703          	lhu	a4,32(s1)
    800055fa:	0027d783          	lhu	a5,2(a5)
    800055fe:	04f70863          	beq	a4,a5,8000564e <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005602:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005606:	6898                	ld	a4,16(s1)
    80005608:	0204d783          	lhu	a5,32(s1)
    8000560c:	8b9d                	andi	a5,a5,7
    8000560e:	078e                	slli	a5,a5,0x3
    80005610:	97ba                	add	a5,a5,a4
    80005612:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005614:	00278713          	addi	a4,a5,2
    80005618:	0712                	slli	a4,a4,0x4
    8000561a:	9726                	add	a4,a4,s1
    8000561c:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005620:	e721                	bnez	a4,80005668 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005622:	0789                	addi	a5,a5,2
    80005624:	0792                	slli	a5,a5,0x4
    80005626:	97a6                	add	a5,a5,s1
    80005628:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000562a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000562e:	ffffc097          	auipc	ra,0xffffc
    80005632:	f32080e7          	jalr	-206(ra) # 80001560 <wakeup>

    disk.used_idx += 1;
    80005636:	0204d783          	lhu	a5,32(s1)
    8000563a:	2785                	addiw	a5,a5,1
    8000563c:	17c2                	slli	a5,a5,0x30
    8000563e:	93c1                	srli	a5,a5,0x30
    80005640:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005644:	6898                	ld	a4,16(s1)
    80005646:	00275703          	lhu	a4,2(a4)
    8000564a:	faf71ce3          	bne	a4,a5,80005602 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000564e:	00014517          	auipc	a0,0x14
    80005652:	4aa50513          	addi	a0,a0,1194 # 80019af8 <disk+0x128>
    80005656:	00001097          	auipc	ra,0x1
    8000565a:	b32080e7          	jalr	-1230(ra) # 80006188 <release>
}
    8000565e:	60e2                	ld	ra,24(sp)
    80005660:	6442                	ld	s0,16(sp)
    80005662:	64a2                	ld	s1,8(sp)
    80005664:	6105                	addi	sp,sp,32
    80005666:	8082                	ret
      panic("virtio_disk_intr status");
    80005668:	00003517          	auipc	a0,0x3
    8000566c:	14050513          	addi	a0,a0,320 # 800087a8 <syscalls+0x3d8>
    80005670:	00000097          	auipc	ra,0x0
    80005674:	52c080e7          	jalr	1324(ra) # 80005b9c <panic>

0000000080005678 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005678:	1141                	addi	sp,sp,-16
    8000567a:	e422                	sd	s0,8(sp)
    8000567c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000567e:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005682:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005686:	0037979b          	slliw	a5,a5,0x3
    8000568a:	02004737          	lui	a4,0x2004
    8000568e:	97ba                	add	a5,a5,a4
    80005690:	0200c737          	lui	a4,0x200c
    80005694:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005698:	000f4637          	lui	a2,0xf4
    8000569c:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800056a0:	9732                	add	a4,a4,a2
    800056a2:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800056a4:	00259693          	slli	a3,a1,0x2
    800056a8:	96ae                	add	a3,a3,a1
    800056aa:	068e                	slli	a3,a3,0x3
    800056ac:	00014717          	auipc	a4,0x14
    800056b0:	46470713          	addi	a4,a4,1124 # 80019b10 <timer_scratch>
    800056b4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800056b6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800056b8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800056ba:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800056be:	00000797          	auipc	a5,0x0
    800056c2:	9a278793          	addi	a5,a5,-1630 # 80005060 <timervec>
    800056c6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800056ca:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800056ce:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800056d2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800056d6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800056da:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800056de:	30479073          	csrw	mie,a5
}
    800056e2:	6422                	ld	s0,8(sp)
    800056e4:	0141                	addi	sp,sp,16
    800056e6:	8082                	ret

00000000800056e8 <start>:
{
    800056e8:	1141                	addi	sp,sp,-16
    800056ea:	e406                	sd	ra,8(sp)
    800056ec:	e022                	sd	s0,0(sp)
    800056ee:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800056f0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800056f4:	7779                	lui	a4,0xffffe
    800056f6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdcaaf>
    800056fa:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800056fc:	6705                	lui	a4,0x1
    800056fe:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005702:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005704:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005708:	ffffb797          	auipc	a5,0xffffb
    8000570c:	c1878793          	addi	a5,a5,-1000 # 80000320 <main>
    80005710:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005714:	4781                	li	a5,0
    80005716:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000571a:	67c1                	lui	a5,0x10
    8000571c:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000571e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005722:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005726:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000572a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000572e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005732:	57fd                	li	a5,-1
    80005734:	83a9                	srli	a5,a5,0xa
    80005736:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000573a:	47bd                	li	a5,15
    8000573c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005740:	00000097          	auipc	ra,0x0
    80005744:	f38080e7          	jalr	-200(ra) # 80005678 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005748:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000574c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000574e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005750:	30200073          	mret
}
    80005754:	60a2                	ld	ra,8(sp)
    80005756:	6402                	ld	s0,0(sp)
    80005758:	0141                	addi	sp,sp,16
    8000575a:	8082                	ret

000000008000575c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000575c:	715d                	addi	sp,sp,-80
    8000575e:	e486                	sd	ra,72(sp)
    80005760:	e0a2                	sd	s0,64(sp)
    80005762:	fc26                	sd	s1,56(sp)
    80005764:	f84a                	sd	s2,48(sp)
    80005766:	f44e                	sd	s3,40(sp)
    80005768:	f052                	sd	s4,32(sp)
    8000576a:	ec56                	sd	s5,24(sp)
    8000576c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000576e:	04c05763          	blez	a2,800057bc <consolewrite+0x60>
    80005772:	8a2a                	mv	s4,a0
    80005774:	84ae                	mv	s1,a1
    80005776:	89b2                	mv	s3,a2
    80005778:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000577a:	5afd                	li	s5,-1
    8000577c:	4685                	li	a3,1
    8000577e:	8626                	mv	a2,s1
    80005780:	85d2                	mv	a1,s4
    80005782:	fbf40513          	addi	a0,s0,-65
    80005786:	ffffc097          	auipc	ra,0xffffc
    8000578a:	1d4080e7          	jalr	468(ra) # 8000195a <either_copyin>
    8000578e:	01550d63          	beq	a0,s5,800057a8 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005792:	fbf44503          	lbu	a0,-65(s0)
    80005796:	00000097          	auipc	ra,0x0
    8000579a:	784080e7          	jalr	1924(ra) # 80005f1a <uartputc>
  for(i = 0; i < n; i++){
    8000579e:	2905                	addiw	s2,s2,1
    800057a0:	0485                	addi	s1,s1,1
    800057a2:	fd299de3          	bne	s3,s2,8000577c <consolewrite+0x20>
    800057a6:	894e                	mv	s2,s3
  }

  return i;
}
    800057a8:	854a                	mv	a0,s2
    800057aa:	60a6                	ld	ra,72(sp)
    800057ac:	6406                	ld	s0,64(sp)
    800057ae:	74e2                	ld	s1,56(sp)
    800057b0:	7942                	ld	s2,48(sp)
    800057b2:	79a2                	ld	s3,40(sp)
    800057b4:	7a02                	ld	s4,32(sp)
    800057b6:	6ae2                	ld	s5,24(sp)
    800057b8:	6161                	addi	sp,sp,80
    800057ba:	8082                	ret
  for(i = 0; i < n; i++){
    800057bc:	4901                	li	s2,0
    800057be:	b7ed                	j	800057a8 <consolewrite+0x4c>

00000000800057c0 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800057c0:	7159                	addi	sp,sp,-112
    800057c2:	f486                	sd	ra,104(sp)
    800057c4:	f0a2                	sd	s0,96(sp)
    800057c6:	eca6                	sd	s1,88(sp)
    800057c8:	e8ca                	sd	s2,80(sp)
    800057ca:	e4ce                	sd	s3,72(sp)
    800057cc:	e0d2                	sd	s4,64(sp)
    800057ce:	fc56                	sd	s5,56(sp)
    800057d0:	f85a                	sd	s6,48(sp)
    800057d2:	f45e                	sd	s7,40(sp)
    800057d4:	f062                	sd	s8,32(sp)
    800057d6:	ec66                	sd	s9,24(sp)
    800057d8:	e86a                	sd	s10,16(sp)
    800057da:	1880                	addi	s0,sp,112
    800057dc:	8aaa                	mv	s5,a0
    800057de:	8a2e                	mv	s4,a1
    800057e0:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800057e2:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800057e6:	0001c517          	auipc	a0,0x1c
    800057ea:	46a50513          	addi	a0,a0,1130 # 80021c50 <cons>
    800057ee:	00001097          	auipc	ra,0x1
    800057f2:	8e6080e7          	jalr	-1818(ra) # 800060d4 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800057f6:	0001c497          	auipc	s1,0x1c
    800057fa:	45a48493          	addi	s1,s1,1114 # 80021c50 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800057fe:	0001c917          	auipc	s2,0x1c
    80005802:	4ea90913          	addi	s2,s2,1258 # 80021ce8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005806:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005808:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000580a:	4ca9                	li	s9,10
  while(n > 0){
    8000580c:	07305b63          	blez	s3,80005882 <consoleread+0xc2>
    while(cons.r == cons.w){
    80005810:	0984a783          	lw	a5,152(s1)
    80005814:	09c4a703          	lw	a4,156(s1)
    80005818:	02f71763          	bne	a4,a5,80005846 <consoleread+0x86>
      if(killed(myproc())){
    8000581c:	ffffb097          	auipc	ra,0xffffb
    80005820:	638080e7          	jalr	1592(ra) # 80000e54 <myproc>
    80005824:	ffffc097          	auipc	ra,0xffffc
    80005828:	f80080e7          	jalr	-128(ra) # 800017a4 <killed>
    8000582c:	e535                	bnez	a0,80005898 <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    8000582e:	85a6                	mv	a1,s1
    80005830:	854a                	mv	a0,s2
    80005832:	ffffc097          	auipc	ra,0xffffc
    80005836:	cca080e7          	jalr	-822(ra) # 800014fc <sleep>
    while(cons.r == cons.w){
    8000583a:	0984a783          	lw	a5,152(s1)
    8000583e:	09c4a703          	lw	a4,156(s1)
    80005842:	fcf70de3          	beq	a4,a5,8000581c <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005846:	0017871b          	addiw	a4,a5,1
    8000584a:	08e4ac23          	sw	a4,152(s1)
    8000584e:	07f7f713          	andi	a4,a5,127
    80005852:	9726                	add	a4,a4,s1
    80005854:	01874703          	lbu	a4,24(a4)
    80005858:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    8000585c:	077d0563          	beq	s10,s7,800058c6 <consoleread+0x106>
    cbuf = c;
    80005860:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005864:	4685                	li	a3,1
    80005866:	f9f40613          	addi	a2,s0,-97
    8000586a:	85d2                	mv	a1,s4
    8000586c:	8556                	mv	a0,s5
    8000586e:	ffffc097          	auipc	ra,0xffffc
    80005872:	096080e7          	jalr	150(ra) # 80001904 <either_copyout>
    80005876:	01850663          	beq	a0,s8,80005882 <consoleread+0xc2>
    dst++;
    8000587a:	0a05                	addi	s4,s4,1
    --n;
    8000587c:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    8000587e:	f99d17e3          	bne	s10,s9,8000580c <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005882:	0001c517          	auipc	a0,0x1c
    80005886:	3ce50513          	addi	a0,a0,974 # 80021c50 <cons>
    8000588a:	00001097          	auipc	ra,0x1
    8000588e:	8fe080e7          	jalr	-1794(ra) # 80006188 <release>

  return target - n;
    80005892:	413b053b          	subw	a0,s6,s3
    80005896:	a811                	j	800058aa <consoleread+0xea>
        release(&cons.lock);
    80005898:	0001c517          	auipc	a0,0x1c
    8000589c:	3b850513          	addi	a0,a0,952 # 80021c50 <cons>
    800058a0:	00001097          	auipc	ra,0x1
    800058a4:	8e8080e7          	jalr	-1816(ra) # 80006188 <release>
        return -1;
    800058a8:	557d                	li	a0,-1
}
    800058aa:	70a6                	ld	ra,104(sp)
    800058ac:	7406                	ld	s0,96(sp)
    800058ae:	64e6                	ld	s1,88(sp)
    800058b0:	6946                	ld	s2,80(sp)
    800058b2:	69a6                	ld	s3,72(sp)
    800058b4:	6a06                	ld	s4,64(sp)
    800058b6:	7ae2                	ld	s5,56(sp)
    800058b8:	7b42                	ld	s6,48(sp)
    800058ba:	7ba2                	ld	s7,40(sp)
    800058bc:	7c02                	ld	s8,32(sp)
    800058be:	6ce2                	ld	s9,24(sp)
    800058c0:	6d42                	ld	s10,16(sp)
    800058c2:	6165                	addi	sp,sp,112
    800058c4:	8082                	ret
      if(n < target){
    800058c6:	0009871b          	sext.w	a4,s3
    800058ca:	fb677ce3          	bgeu	a4,s6,80005882 <consoleread+0xc2>
        cons.r--;
    800058ce:	0001c717          	auipc	a4,0x1c
    800058d2:	40f72d23          	sw	a5,1050(a4) # 80021ce8 <cons+0x98>
    800058d6:	b775                	j	80005882 <consoleread+0xc2>

00000000800058d8 <consputc>:
{
    800058d8:	1141                	addi	sp,sp,-16
    800058da:	e406                	sd	ra,8(sp)
    800058dc:	e022                	sd	s0,0(sp)
    800058de:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800058e0:	10000793          	li	a5,256
    800058e4:	00f50a63          	beq	a0,a5,800058f8 <consputc+0x20>
    uartputc_sync(c);
    800058e8:	00000097          	auipc	ra,0x0
    800058ec:	560080e7          	jalr	1376(ra) # 80005e48 <uartputc_sync>
}
    800058f0:	60a2                	ld	ra,8(sp)
    800058f2:	6402                	ld	s0,0(sp)
    800058f4:	0141                	addi	sp,sp,16
    800058f6:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800058f8:	4521                	li	a0,8
    800058fa:	00000097          	auipc	ra,0x0
    800058fe:	54e080e7          	jalr	1358(ra) # 80005e48 <uartputc_sync>
    80005902:	02000513          	li	a0,32
    80005906:	00000097          	auipc	ra,0x0
    8000590a:	542080e7          	jalr	1346(ra) # 80005e48 <uartputc_sync>
    8000590e:	4521                	li	a0,8
    80005910:	00000097          	auipc	ra,0x0
    80005914:	538080e7          	jalr	1336(ra) # 80005e48 <uartputc_sync>
    80005918:	bfe1                	j	800058f0 <consputc+0x18>

000000008000591a <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    8000591a:	1101                	addi	sp,sp,-32
    8000591c:	ec06                	sd	ra,24(sp)
    8000591e:	e822                	sd	s0,16(sp)
    80005920:	e426                	sd	s1,8(sp)
    80005922:	e04a                	sd	s2,0(sp)
    80005924:	1000                	addi	s0,sp,32
    80005926:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005928:	0001c517          	auipc	a0,0x1c
    8000592c:	32850513          	addi	a0,a0,808 # 80021c50 <cons>
    80005930:	00000097          	auipc	ra,0x0
    80005934:	7a4080e7          	jalr	1956(ra) # 800060d4 <acquire>

  switch(c){
    80005938:	47d5                	li	a5,21
    8000593a:	0af48663          	beq	s1,a5,800059e6 <consoleintr+0xcc>
    8000593e:	0297ca63          	blt	a5,s1,80005972 <consoleintr+0x58>
    80005942:	47a1                	li	a5,8
    80005944:	0ef48763          	beq	s1,a5,80005a32 <consoleintr+0x118>
    80005948:	47c1                	li	a5,16
    8000594a:	10f49a63          	bne	s1,a5,80005a5e <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    8000594e:	ffffc097          	auipc	ra,0xffffc
    80005952:	062080e7          	jalr	98(ra) # 800019b0 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005956:	0001c517          	auipc	a0,0x1c
    8000595a:	2fa50513          	addi	a0,a0,762 # 80021c50 <cons>
    8000595e:	00001097          	auipc	ra,0x1
    80005962:	82a080e7          	jalr	-2006(ra) # 80006188 <release>
}
    80005966:	60e2                	ld	ra,24(sp)
    80005968:	6442                	ld	s0,16(sp)
    8000596a:	64a2                	ld	s1,8(sp)
    8000596c:	6902                	ld	s2,0(sp)
    8000596e:	6105                	addi	sp,sp,32
    80005970:	8082                	ret
  switch(c){
    80005972:	07f00793          	li	a5,127
    80005976:	0af48e63          	beq	s1,a5,80005a32 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000597a:	0001c717          	auipc	a4,0x1c
    8000597e:	2d670713          	addi	a4,a4,726 # 80021c50 <cons>
    80005982:	0a072783          	lw	a5,160(a4)
    80005986:	09872703          	lw	a4,152(a4)
    8000598a:	9f99                	subw	a5,a5,a4
    8000598c:	07f00713          	li	a4,127
    80005990:	fcf763e3          	bltu	a4,a5,80005956 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005994:	47b5                	li	a5,13
    80005996:	0cf48763          	beq	s1,a5,80005a64 <consoleintr+0x14a>
      consputc(c);
    8000599a:	8526                	mv	a0,s1
    8000599c:	00000097          	auipc	ra,0x0
    800059a0:	f3c080e7          	jalr	-196(ra) # 800058d8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800059a4:	0001c797          	auipc	a5,0x1c
    800059a8:	2ac78793          	addi	a5,a5,684 # 80021c50 <cons>
    800059ac:	0a07a683          	lw	a3,160(a5)
    800059b0:	0016871b          	addiw	a4,a3,1
    800059b4:	0007061b          	sext.w	a2,a4
    800059b8:	0ae7a023          	sw	a4,160(a5)
    800059bc:	07f6f693          	andi	a3,a3,127
    800059c0:	97b6                	add	a5,a5,a3
    800059c2:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800059c6:	47a9                	li	a5,10
    800059c8:	0cf48563          	beq	s1,a5,80005a92 <consoleintr+0x178>
    800059cc:	4791                	li	a5,4
    800059ce:	0cf48263          	beq	s1,a5,80005a92 <consoleintr+0x178>
    800059d2:	0001c797          	auipc	a5,0x1c
    800059d6:	3167a783          	lw	a5,790(a5) # 80021ce8 <cons+0x98>
    800059da:	9f1d                	subw	a4,a4,a5
    800059dc:	08000793          	li	a5,128
    800059e0:	f6f71be3          	bne	a4,a5,80005956 <consoleintr+0x3c>
    800059e4:	a07d                	j	80005a92 <consoleintr+0x178>
    while(cons.e != cons.w &&
    800059e6:	0001c717          	auipc	a4,0x1c
    800059ea:	26a70713          	addi	a4,a4,618 # 80021c50 <cons>
    800059ee:	0a072783          	lw	a5,160(a4)
    800059f2:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800059f6:	0001c497          	auipc	s1,0x1c
    800059fa:	25a48493          	addi	s1,s1,602 # 80021c50 <cons>
    while(cons.e != cons.w &&
    800059fe:	4929                	li	s2,10
    80005a00:	f4f70be3          	beq	a4,a5,80005956 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005a04:	37fd                	addiw	a5,a5,-1
    80005a06:	07f7f713          	andi	a4,a5,127
    80005a0a:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005a0c:	01874703          	lbu	a4,24(a4)
    80005a10:	f52703e3          	beq	a4,s2,80005956 <consoleintr+0x3c>
      cons.e--;
    80005a14:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005a18:	10000513          	li	a0,256
    80005a1c:	00000097          	auipc	ra,0x0
    80005a20:	ebc080e7          	jalr	-324(ra) # 800058d8 <consputc>
    while(cons.e != cons.w &&
    80005a24:	0a04a783          	lw	a5,160(s1)
    80005a28:	09c4a703          	lw	a4,156(s1)
    80005a2c:	fcf71ce3          	bne	a4,a5,80005a04 <consoleintr+0xea>
    80005a30:	b71d                	j	80005956 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005a32:	0001c717          	auipc	a4,0x1c
    80005a36:	21e70713          	addi	a4,a4,542 # 80021c50 <cons>
    80005a3a:	0a072783          	lw	a5,160(a4)
    80005a3e:	09c72703          	lw	a4,156(a4)
    80005a42:	f0f70ae3          	beq	a4,a5,80005956 <consoleintr+0x3c>
      cons.e--;
    80005a46:	37fd                	addiw	a5,a5,-1
    80005a48:	0001c717          	auipc	a4,0x1c
    80005a4c:	2af72423          	sw	a5,680(a4) # 80021cf0 <cons+0xa0>
      consputc(BACKSPACE);
    80005a50:	10000513          	li	a0,256
    80005a54:	00000097          	auipc	ra,0x0
    80005a58:	e84080e7          	jalr	-380(ra) # 800058d8 <consputc>
    80005a5c:	bded                	j	80005956 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005a5e:	ee048ce3          	beqz	s1,80005956 <consoleintr+0x3c>
    80005a62:	bf21                	j	8000597a <consoleintr+0x60>
      consputc(c);
    80005a64:	4529                	li	a0,10
    80005a66:	00000097          	auipc	ra,0x0
    80005a6a:	e72080e7          	jalr	-398(ra) # 800058d8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005a6e:	0001c797          	auipc	a5,0x1c
    80005a72:	1e278793          	addi	a5,a5,482 # 80021c50 <cons>
    80005a76:	0a07a703          	lw	a4,160(a5)
    80005a7a:	0017069b          	addiw	a3,a4,1
    80005a7e:	0006861b          	sext.w	a2,a3
    80005a82:	0ad7a023          	sw	a3,160(a5)
    80005a86:	07f77713          	andi	a4,a4,127
    80005a8a:	97ba                	add	a5,a5,a4
    80005a8c:	4729                	li	a4,10
    80005a8e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005a92:	0001c797          	auipc	a5,0x1c
    80005a96:	24c7ad23          	sw	a2,602(a5) # 80021cec <cons+0x9c>
        wakeup(&cons.r);
    80005a9a:	0001c517          	auipc	a0,0x1c
    80005a9e:	24e50513          	addi	a0,a0,590 # 80021ce8 <cons+0x98>
    80005aa2:	ffffc097          	auipc	ra,0xffffc
    80005aa6:	abe080e7          	jalr	-1346(ra) # 80001560 <wakeup>
    80005aaa:	b575                	j	80005956 <consoleintr+0x3c>

0000000080005aac <consoleinit>:

void
consoleinit(void)
{
    80005aac:	1141                	addi	sp,sp,-16
    80005aae:	e406                	sd	ra,8(sp)
    80005ab0:	e022                	sd	s0,0(sp)
    80005ab2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005ab4:	00003597          	auipc	a1,0x3
    80005ab8:	d0c58593          	addi	a1,a1,-756 # 800087c0 <syscalls+0x3f0>
    80005abc:	0001c517          	auipc	a0,0x1c
    80005ac0:	19450513          	addi	a0,a0,404 # 80021c50 <cons>
    80005ac4:	00000097          	auipc	ra,0x0
    80005ac8:	580080e7          	jalr	1408(ra) # 80006044 <initlock>

  uartinit();
    80005acc:	00000097          	auipc	ra,0x0
    80005ad0:	32c080e7          	jalr	812(ra) # 80005df8 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005ad4:	00013797          	auipc	a5,0x13
    80005ad8:	ea478793          	addi	a5,a5,-348 # 80018978 <devsw>
    80005adc:	00000717          	auipc	a4,0x0
    80005ae0:	ce470713          	addi	a4,a4,-796 # 800057c0 <consoleread>
    80005ae4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005ae6:	00000717          	auipc	a4,0x0
    80005aea:	c7670713          	addi	a4,a4,-906 # 8000575c <consolewrite>
    80005aee:	ef98                	sd	a4,24(a5)
}
    80005af0:	60a2                	ld	ra,8(sp)
    80005af2:	6402                	ld	s0,0(sp)
    80005af4:	0141                	addi	sp,sp,16
    80005af6:	8082                	ret

0000000080005af8 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005af8:	7179                	addi	sp,sp,-48
    80005afa:	f406                	sd	ra,40(sp)
    80005afc:	f022                	sd	s0,32(sp)
    80005afe:	ec26                	sd	s1,24(sp)
    80005b00:	e84a                	sd	s2,16(sp)
    80005b02:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005b04:	c219                	beqz	a2,80005b0a <printint+0x12>
    80005b06:	08054763          	bltz	a0,80005b94 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005b0a:	2501                	sext.w	a0,a0
    80005b0c:	4881                	li	a7,0
    80005b0e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005b12:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005b14:	2581                	sext.w	a1,a1
    80005b16:	00003617          	auipc	a2,0x3
    80005b1a:	cda60613          	addi	a2,a2,-806 # 800087f0 <digits>
    80005b1e:	883a                	mv	a6,a4
    80005b20:	2705                	addiw	a4,a4,1
    80005b22:	02b577bb          	remuw	a5,a0,a1
    80005b26:	1782                	slli	a5,a5,0x20
    80005b28:	9381                	srli	a5,a5,0x20
    80005b2a:	97b2                	add	a5,a5,a2
    80005b2c:	0007c783          	lbu	a5,0(a5)
    80005b30:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005b34:	0005079b          	sext.w	a5,a0
    80005b38:	02b5553b          	divuw	a0,a0,a1
    80005b3c:	0685                	addi	a3,a3,1
    80005b3e:	feb7f0e3          	bgeu	a5,a1,80005b1e <printint+0x26>

  if(sign)
    80005b42:	00088c63          	beqz	a7,80005b5a <printint+0x62>
    buf[i++] = '-';
    80005b46:	fe070793          	addi	a5,a4,-32
    80005b4a:	00878733          	add	a4,a5,s0
    80005b4e:	02d00793          	li	a5,45
    80005b52:	fef70823          	sb	a5,-16(a4)
    80005b56:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005b5a:	02e05763          	blez	a4,80005b88 <printint+0x90>
    80005b5e:	fd040793          	addi	a5,s0,-48
    80005b62:	00e784b3          	add	s1,a5,a4
    80005b66:	fff78913          	addi	s2,a5,-1
    80005b6a:	993a                	add	s2,s2,a4
    80005b6c:	377d                	addiw	a4,a4,-1
    80005b6e:	1702                	slli	a4,a4,0x20
    80005b70:	9301                	srli	a4,a4,0x20
    80005b72:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005b76:	fff4c503          	lbu	a0,-1(s1)
    80005b7a:	00000097          	auipc	ra,0x0
    80005b7e:	d5e080e7          	jalr	-674(ra) # 800058d8 <consputc>
  while(--i >= 0)
    80005b82:	14fd                	addi	s1,s1,-1
    80005b84:	ff2499e3          	bne	s1,s2,80005b76 <printint+0x7e>
}
    80005b88:	70a2                	ld	ra,40(sp)
    80005b8a:	7402                	ld	s0,32(sp)
    80005b8c:	64e2                	ld	s1,24(sp)
    80005b8e:	6942                	ld	s2,16(sp)
    80005b90:	6145                	addi	sp,sp,48
    80005b92:	8082                	ret
    x = -xx;
    80005b94:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005b98:	4885                	li	a7,1
    x = -xx;
    80005b9a:	bf95                	j	80005b0e <printint+0x16>

0000000080005b9c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005b9c:	1101                	addi	sp,sp,-32
    80005b9e:	ec06                	sd	ra,24(sp)
    80005ba0:	e822                	sd	s0,16(sp)
    80005ba2:	e426                	sd	s1,8(sp)
    80005ba4:	1000                	addi	s0,sp,32
    80005ba6:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005ba8:	0001c797          	auipc	a5,0x1c
    80005bac:	1607a423          	sw	zero,360(a5) # 80021d10 <pr+0x18>
  printf("panic: ");
    80005bb0:	00003517          	auipc	a0,0x3
    80005bb4:	c1850513          	addi	a0,a0,-1000 # 800087c8 <syscalls+0x3f8>
    80005bb8:	00000097          	auipc	ra,0x0
    80005bbc:	02e080e7          	jalr	46(ra) # 80005be6 <printf>
  printf(s);
    80005bc0:	8526                	mv	a0,s1
    80005bc2:	00000097          	auipc	ra,0x0
    80005bc6:	024080e7          	jalr	36(ra) # 80005be6 <printf>
  printf("\n");
    80005bca:	00002517          	auipc	a0,0x2
    80005bce:	47e50513          	addi	a0,a0,1150 # 80008048 <etext+0x48>
    80005bd2:	00000097          	auipc	ra,0x0
    80005bd6:	014080e7          	jalr	20(ra) # 80005be6 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005bda:	4785                	li	a5,1
    80005bdc:	00003717          	auipc	a4,0x3
    80005be0:	cef72823          	sw	a5,-784(a4) # 800088cc <panicked>
  for(;;)
    80005be4:	a001                	j	80005be4 <panic+0x48>

0000000080005be6 <printf>:
{
    80005be6:	7131                	addi	sp,sp,-192
    80005be8:	fc86                	sd	ra,120(sp)
    80005bea:	f8a2                	sd	s0,112(sp)
    80005bec:	f4a6                	sd	s1,104(sp)
    80005bee:	f0ca                	sd	s2,96(sp)
    80005bf0:	ecce                	sd	s3,88(sp)
    80005bf2:	e8d2                	sd	s4,80(sp)
    80005bf4:	e4d6                	sd	s5,72(sp)
    80005bf6:	e0da                	sd	s6,64(sp)
    80005bf8:	fc5e                	sd	s7,56(sp)
    80005bfa:	f862                	sd	s8,48(sp)
    80005bfc:	f466                	sd	s9,40(sp)
    80005bfe:	f06a                	sd	s10,32(sp)
    80005c00:	ec6e                	sd	s11,24(sp)
    80005c02:	0100                	addi	s0,sp,128
    80005c04:	8a2a                	mv	s4,a0
    80005c06:	e40c                	sd	a1,8(s0)
    80005c08:	e810                	sd	a2,16(s0)
    80005c0a:	ec14                	sd	a3,24(s0)
    80005c0c:	f018                	sd	a4,32(s0)
    80005c0e:	f41c                	sd	a5,40(s0)
    80005c10:	03043823          	sd	a6,48(s0)
    80005c14:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005c18:	0001cd97          	auipc	s11,0x1c
    80005c1c:	0f8dad83          	lw	s11,248(s11) # 80021d10 <pr+0x18>
  if(locking)
    80005c20:	020d9b63          	bnez	s11,80005c56 <printf+0x70>
  if (fmt == 0)
    80005c24:	040a0263          	beqz	s4,80005c68 <printf+0x82>
  va_start(ap, fmt);
    80005c28:	00840793          	addi	a5,s0,8
    80005c2c:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c30:	000a4503          	lbu	a0,0(s4)
    80005c34:	14050f63          	beqz	a0,80005d92 <printf+0x1ac>
    80005c38:	4981                	li	s3,0
    if(c != '%'){
    80005c3a:	02500a93          	li	s5,37
    switch(c){
    80005c3e:	07000b93          	li	s7,112
  consputc('x');
    80005c42:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005c44:	00003b17          	auipc	s6,0x3
    80005c48:	bacb0b13          	addi	s6,s6,-1108 # 800087f0 <digits>
    switch(c){
    80005c4c:	07300c93          	li	s9,115
    80005c50:	06400c13          	li	s8,100
    80005c54:	a82d                	j	80005c8e <printf+0xa8>
    acquire(&pr.lock);
    80005c56:	0001c517          	auipc	a0,0x1c
    80005c5a:	0a250513          	addi	a0,a0,162 # 80021cf8 <pr>
    80005c5e:	00000097          	auipc	ra,0x0
    80005c62:	476080e7          	jalr	1142(ra) # 800060d4 <acquire>
    80005c66:	bf7d                	j	80005c24 <printf+0x3e>
    panic("null fmt");
    80005c68:	00003517          	auipc	a0,0x3
    80005c6c:	b7050513          	addi	a0,a0,-1168 # 800087d8 <syscalls+0x408>
    80005c70:	00000097          	auipc	ra,0x0
    80005c74:	f2c080e7          	jalr	-212(ra) # 80005b9c <panic>
      consputc(c);
    80005c78:	00000097          	auipc	ra,0x0
    80005c7c:	c60080e7          	jalr	-928(ra) # 800058d8 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c80:	2985                	addiw	s3,s3,1
    80005c82:	013a07b3          	add	a5,s4,s3
    80005c86:	0007c503          	lbu	a0,0(a5)
    80005c8a:	10050463          	beqz	a0,80005d92 <printf+0x1ac>
    if(c != '%'){
    80005c8e:	ff5515e3          	bne	a0,s5,80005c78 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005c92:	2985                	addiw	s3,s3,1
    80005c94:	013a07b3          	add	a5,s4,s3
    80005c98:	0007c783          	lbu	a5,0(a5)
    80005c9c:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005ca0:	cbed                	beqz	a5,80005d92 <printf+0x1ac>
    switch(c){
    80005ca2:	05778a63          	beq	a5,s7,80005cf6 <printf+0x110>
    80005ca6:	02fbf663          	bgeu	s7,a5,80005cd2 <printf+0xec>
    80005caa:	09978863          	beq	a5,s9,80005d3a <printf+0x154>
    80005cae:	07800713          	li	a4,120
    80005cb2:	0ce79563          	bne	a5,a4,80005d7c <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005cb6:	f8843783          	ld	a5,-120(s0)
    80005cba:	00878713          	addi	a4,a5,8
    80005cbe:	f8e43423          	sd	a4,-120(s0)
    80005cc2:	4605                	li	a2,1
    80005cc4:	85ea                	mv	a1,s10
    80005cc6:	4388                	lw	a0,0(a5)
    80005cc8:	00000097          	auipc	ra,0x0
    80005ccc:	e30080e7          	jalr	-464(ra) # 80005af8 <printint>
      break;
    80005cd0:	bf45                	j	80005c80 <printf+0x9a>
    switch(c){
    80005cd2:	09578f63          	beq	a5,s5,80005d70 <printf+0x18a>
    80005cd6:	0b879363          	bne	a5,s8,80005d7c <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005cda:	f8843783          	ld	a5,-120(s0)
    80005cde:	00878713          	addi	a4,a5,8
    80005ce2:	f8e43423          	sd	a4,-120(s0)
    80005ce6:	4605                	li	a2,1
    80005ce8:	45a9                	li	a1,10
    80005cea:	4388                	lw	a0,0(a5)
    80005cec:	00000097          	auipc	ra,0x0
    80005cf0:	e0c080e7          	jalr	-500(ra) # 80005af8 <printint>
      break;
    80005cf4:	b771                	j	80005c80 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005cf6:	f8843783          	ld	a5,-120(s0)
    80005cfa:	00878713          	addi	a4,a5,8
    80005cfe:	f8e43423          	sd	a4,-120(s0)
    80005d02:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005d06:	03000513          	li	a0,48
    80005d0a:	00000097          	auipc	ra,0x0
    80005d0e:	bce080e7          	jalr	-1074(ra) # 800058d8 <consputc>
  consputc('x');
    80005d12:	07800513          	li	a0,120
    80005d16:	00000097          	auipc	ra,0x0
    80005d1a:	bc2080e7          	jalr	-1086(ra) # 800058d8 <consputc>
    80005d1e:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d20:	03c95793          	srli	a5,s2,0x3c
    80005d24:	97da                	add	a5,a5,s6
    80005d26:	0007c503          	lbu	a0,0(a5)
    80005d2a:	00000097          	auipc	ra,0x0
    80005d2e:	bae080e7          	jalr	-1106(ra) # 800058d8 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005d32:	0912                	slli	s2,s2,0x4
    80005d34:	34fd                	addiw	s1,s1,-1
    80005d36:	f4ed                	bnez	s1,80005d20 <printf+0x13a>
    80005d38:	b7a1                	j	80005c80 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005d3a:	f8843783          	ld	a5,-120(s0)
    80005d3e:	00878713          	addi	a4,a5,8
    80005d42:	f8e43423          	sd	a4,-120(s0)
    80005d46:	6384                	ld	s1,0(a5)
    80005d48:	cc89                	beqz	s1,80005d62 <printf+0x17c>
      for(; *s; s++)
    80005d4a:	0004c503          	lbu	a0,0(s1)
    80005d4e:	d90d                	beqz	a0,80005c80 <printf+0x9a>
        consputc(*s);
    80005d50:	00000097          	auipc	ra,0x0
    80005d54:	b88080e7          	jalr	-1144(ra) # 800058d8 <consputc>
      for(; *s; s++)
    80005d58:	0485                	addi	s1,s1,1
    80005d5a:	0004c503          	lbu	a0,0(s1)
    80005d5e:	f96d                	bnez	a0,80005d50 <printf+0x16a>
    80005d60:	b705                	j	80005c80 <printf+0x9a>
        s = "(null)";
    80005d62:	00003497          	auipc	s1,0x3
    80005d66:	a6e48493          	addi	s1,s1,-1426 # 800087d0 <syscalls+0x400>
      for(; *s; s++)
    80005d6a:	02800513          	li	a0,40
    80005d6e:	b7cd                	j	80005d50 <printf+0x16a>
      consputc('%');
    80005d70:	8556                	mv	a0,s5
    80005d72:	00000097          	auipc	ra,0x0
    80005d76:	b66080e7          	jalr	-1178(ra) # 800058d8 <consputc>
      break;
    80005d7a:	b719                	j	80005c80 <printf+0x9a>
      consputc('%');
    80005d7c:	8556                	mv	a0,s5
    80005d7e:	00000097          	auipc	ra,0x0
    80005d82:	b5a080e7          	jalr	-1190(ra) # 800058d8 <consputc>
      consputc(c);
    80005d86:	8526                	mv	a0,s1
    80005d88:	00000097          	auipc	ra,0x0
    80005d8c:	b50080e7          	jalr	-1200(ra) # 800058d8 <consputc>
      break;
    80005d90:	bdc5                	j	80005c80 <printf+0x9a>
  if(locking)
    80005d92:	020d9163          	bnez	s11,80005db4 <printf+0x1ce>
}
    80005d96:	70e6                	ld	ra,120(sp)
    80005d98:	7446                	ld	s0,112(sp)
    80005d9a:	74a6                	ld	s1,104(sp)
    80005d9c:	7906                	ld	s2,96(sp)
    80005d9e:	69e6                	ld	s3,88(sp)
    80005da0:	6a46                	ld	s4,80(sp)
    80005da2:	6aa6                	ld	s5,72(sp)
    80005da4:	6b06                	ld	s6,64(sp)
    80005da6:	7be2                	ld	s7,56(sp)
    80005da8:	7c42                	ld	s8,48(sp)
    80005daa:	7ca2                	ld	s9,40(sp)
    80005dac:	7d02                	ld	s10,32(sp)
    80005dae:	6de2                	ld	s11,24(sp)
    80005db0:	6129                	addi	sp,sp,192
    80005db2:	8082                	ret
    release(&pr.lock);
    80005db4:	0001c517          	auipc	a0,0x1c
    80005db8:	f4450513          	addi	a0,a0,-188 # 80021cf8 <pr>
    80005dbc:	00000097          	auipc	ra,0x0
    80005dc0:	3cc080e7          	jalr	972(ra) # 80006188 <release>
}
    80005dc4:	bfc9                	j	80005d96 <printf+0x1b0>

0000000080005dc6 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005dc6:	1101                	addi	sp,sp,-32
    80005dc8:	ec06                	sd	ra,24(sp)
    80005dca:	e822                	sd	s0,16(sp)
    80005dcc:	e426                	sd	s1,8(sp)
    80005dce:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005dd0:	0001c497          	auipc	s1,0x1c
    80005dd4:	f2848493          	addi	s1,s1,-216 # 80021cf8 <pr>
    80005dd8:	00003597          	auipc	a1,0x3
    80005ddc:	a1058593          	addi	a1,a1,-1520 # 800087e8 <syscalls+0x418>
    80005de0:	8526                	mv	a0,s1
    80005de2:	00000097          	auipc	ra,0x0
    80005de6:	262080e7          	jalr	610(ra) # 80006044 <initlock>
  pr.locking = 1;
    80005dea:	4785                	li	a5,1
    80005dec:	cc9c                	sw	a5,24(s1)
}
    80005dee:	60e2                	ld	ra,24(sp)
    80005df0:	6442                	ld	s0,16(sp)
    80005df2:	64a2                	ld	s1,8(sp)
    80005df4:	6105                	addi	sp,sp,32
    80005df6:	8082                	ret

0000000080005df8 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005df8:	1141                	addi	sp,sp,-16
    80005dfa:	e406                	sd	ra,8(sp)
    80005dfc:	e022                	sd	s0,0(sp)
    80005dfe:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005e00:	100007b7          	lui	a5,0x10000
    80005e04:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005e08:	f8000713          	li	a4,-128
    80005e0c:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005e10:	470d                	li	a4,3
    80005e12:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005e16:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005e1a:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005e1e:	469d                	li	a3,7
    80005e20:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005e24:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005e28:	00003597          	auipc	a1,0x3
    80005e2c:	9e058593          	addi	a1,a1,-1568 # 80008808 <digits+0x18>
    80005e30:	0001c517          	auipc	a0,0x1c
    80005e34:	ee850513          	addi	a0,a0,-280 # 80021d18 <uart_tx_lock>
    80005e38:	00000097          	auipc	ra,0x0
    80005e3c:	20c080e7          	jalr	524(ra) # 80006044 <initlock>
}
    80005e40:	60a2                	ld	ra,8(sp)
    80005e42:	6402                	ld	s0,0(sp)
    80005e44:	0141                	addi	sp,sp,16
    80005e46:	8082                	ret

0000000080005e48 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005e48:	1101                	addi	sp,sp,-32
    80005e4a:	ec06                	sd	ra,24(sp)
    80005e4c:	e822                	sd	s0,16(sp)
    80005e4e:	e426                	sd	s1,8(sp)
    80005e50:	1000                	addi	s0,sp,32
    80005e52:	84aa                	mv	s1,a0
  push_off();
    80005e54:	00000097          	auipc	ra,0x0
    80005e58:	234080e7          	jalr	564(ra) # 80006088 <push_off>

  if(panicked){
    80005e5c:	00003797          	auipc	a5,0x3
    80005e60:	a707a783          	lw	a5,-1424(a5) # 800088cc <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005e64:	10000737          	lui	a4,0x10000
  if(panicked){
    80005e68:	c391                	beqz	a5,80005e6c <uartputc_sync+0x24>
    for(;;)
    80005e6a:	a001                	j	80005e6a <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005e6c:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005e70:	0207f793          	andi	a5,a5,32
    80005e74:	dfe5                	beqz	a5,80005e6c <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005e76:	0ff4f513          	zext.b	a0,s1
    80005e7a:	100007b7          	lui	a5,0x10000
    80005e7e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005e82:	00000097          	auipc	ra,0x0
    80005e86:	2a6080e7          	jalr	678(ra) # 80006128 <pop_off>
}
    80005e8a:	60e2                	ld	ra,24(sp)
    80005e8c:	6442                	ld	s0,16(sp)
    80005e8e:	64a2                	ld	s1,8(sp)
    80005e90:	6105                	addi	sp,sp,32
    80005e92:	8082                	ret

0000000080005e94 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005e94:	00003797          	auipc	a5,0x3
    80005e98:	a3c7b783          	ld	a5,-1476(a5) # 800088d0 <uart_tx_r>
    80005e9c:	00003717          	auipc	a4,0x3
    80005ea0:	a3c73703          	ld	a4,-1476(a4) # 800088d8 <uart_tx_w>
    80005ea4:	06f70a63          	beq	a4,a5,80005f18 <uartstart+0x84>
{
    80005ea8:	7139                	addi	sp,sp,-64
    80005eaa:	fc06                	sd	ra,56(sp)
    80005eac:	f822                	sd	s0,48(sp)
    80005eae:	f426                	sd	s1,40(sp)
    80005eb0:	f04a                	sd	s2,32(sp)
    80005eb2:	ec4e                	sd	s3,24(sp)
    80005eb4:	e852                	sd	s4,16(sp)
    80005eb6:	e456                	sd	s5,8(sp)
    80005eb8:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005eba:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005ebe:	0001ca17          	auipc	s4,0x1c
    80005ec2:	e5aa0a13          	addi	s4,s4,-422 # 80021d18 <uart_tx_lock>
    uart_tx_r += 1;
    80005ec6:	00003497          	auipc	s1,0x3
    80005eca:	a0a48493          	addi	s1,s1,-1526 # 800088d0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005ece:	00003997          	auipc	s3,0x3
    80005ed2:	a0a98993          	addi	s3,s3,-1526 # 800088d8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005ed6:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005eda:	02077713          	andi	a4,a4,32
    80005ede:	c705                	beqz	a4,80005f06 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005ee0:	01f7f713          	andi	a4,a5,31
    80005ee4:	9752                	add	a4,a4,s4
    80005ee6:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005eea:	0785                	addi	a5,a5,1
    80005eec:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005eee:	8526                	mv	a0,s1
    80005ef0:	ffffb097          	auipc	ra,0xffffb
    80005ef4:	670080e7          	jalr	1648(ra) # 80001560 <wakeup>
    
    WriteReg(THR, c);
    80005ef8:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005efc:	609c                	ld	a5,0(s1)
    80005efe:	0009b703          	ld	a4,0(s3)
    80005f02:	fcf71ae3          	bne	a4,a5,80005ed6 <uartstart+0x42>
  }
}
    80005f06:	70e2                	ld	ra,56(sp)
    80005f08:	7442                	ld	s0,48(sp)
    80005f0a:	74a2                	ld	s1,40(sp)
    80005f0c:	7902                	ld	s2,32(sp)
    80005f0e:	69e2                	ld	s3,24(sp)
    80005f10:	6a42                	ld	s4,16(sp)
    80005f12:	6aa2                	ld	s5,8(sp)
    80005f14:	6121                	addi	sp,sp,64
    80005f16:	8082                	ret
    80005f18:	8082                	ret

0000000080005f1a <uartputc>:
{
    80005f1a:	7179                	addi	sp,sp,-48
    80005f1c:	f406                	sd	ra,40(sp)
    80005f1e:	f022                	sd	s0,32(sp)
    80005f20:	ec26                	sd	s1,24(sp)
    80005f22:	e84a                	sd	s2,16(sp)
    80005f24:	e44e                	sd	s3,8(sp)
    80005f26:	e052                	sd	s4,0(sp)
    80005f28:	1800                	addi	s0,sp,48
    80005f2a:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005f2c:	0001c517          	auipc	a0,0x1c
    80005f30:	dec50513          	addi	a0,a0,-532 # 80021d18 <uart_tx_lock>
    80005f34:	00000097          	auipc	ra,0x0
    80005f38:	1a0080e7          	jalr	416(ra) # 800060d4 <acquire>
  if(panicked){
    80005f3c:	00003797          	auipc	a5,0x3
    80005f40:	9907a783          	lw	a5,-1648(a5) # 800088cc <panicked>
    80005f44:	e7c9                	bnez	a5,80005fce <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f46:	00003717          	auipc	a4,0x3
    80005f4a:	99273703          	ld	a4,-1646(a4) # 800088d8 <uart_tx_w>
    80005f4e:	00003797          	auipc	a5,0x3
    80005f52:	9827b783          	ld	a5,-1662(a5) # 800088d0 <uart_tx_r>
    80005f56:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005f5a:	0001c997          	auipc	s3,0x1c
    80005f5e:	dbe98993          	addi	s3,s3,-578 # 80021d18 <uart_tx_lock>
    80005f62:	00003497          	auipc	s1,0x3
    80005f66:	96e48493          	addi	s1,s1,-1682 # 800088d0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f6a:	00003917          	auipc	s2,0x3
    80005f6e:	96e90913          	addi	s2,s2,-1682 # 800088d8 <uart_tx_w>
    80005f72:	00e79f63          	bne	a5,a4,80005f90 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005f76:	85ce                	mv	a1,s3
    80005f78:	8526                	mv	a0,s1
    80005f7a:	ffffb097          	auipc	ra,0xffffb
    80005f7e:	582080e7          	jalr	1410(ra) # 800014fc <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f82:	00093703          	ld	a4,0(s2)
    80005f86:	609c                	ld	a5,0(s1)
    80005f88:	02078793          	addi	a5,a5,32
    80005f8c:	fee785e3          	beq	a5,a4,80005f76 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005f90:	0001c497          	auipc	s1,0x1c
    80005f94:	d8848493          	addi	s1,s1,-632 # 80021d18 <uart_tx_lock>
    80005f98:	01f77793          	andi	a5,a4,31
    80005f9c:	97a6                	add	a5,a5,s1
    80005f9e:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005fa2:	0705                	addi	a4,a4,1
    80005fa4:	00003797          	auipc	a5,0x3
    80005fa8:	92e7ba23          	sd	a4,-1740(a5) # 800088d8 <uart_tx_w>
  uartstart();
    80005fac:	00000097          	auipc	ra,0x0
    80005fb0:	ee8080e7          	jalr	-280(ra) # 80005e94 <uartstart>
  release(&uart_tx_lock);
    80005fb4:	8526                	mv	a0,s1
    80005fb6:	00000097          	auipc	ra,0x0
    80005fba:	1d2080e7          	jalr	466(ra) # 80006188 <release>
}
    80005fbe:	70a2                	ld	ra,40(sp)
    80005fc0:	7402                	ld	s0,32(sp)
    80005fc2:	64e2                	ld	s1,24(sp)
    80005fc4:	6942                	ld	s2,16(sp)
    80005fc6:	69a2                	ld	s3,8(sp)
    80005fc8:	6a02                	ld	s4,0(sp)
    80005fca:	6145                	addi	sp,sp,48
    80005fcc:	8082                	ret
    for(;;)
    80005fce:	a001                	j	80005fce <uartputc+0xb4>

0000000080005fd0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005fd0:	1141                	addi	sp,sp,-16
    80005fd2:	e422                	sd	s0,8(sp)
    80005fd4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005fd6:	100007b7          	lui	a5,0x10000
    80005fda:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005fde:	8b85                	andi	a5,a5,1
    80005fe0:	cb81                	beqz	a5,80005ff0 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80005fe2:	100007b7          	lui	a5,0x10000
    80005fe6:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005fea:	6422                	ld	s0,8(sp)
    80005fec:	0141                	addi	sp,sp,16
    80005fee:	8082                	ret
    return -1;
    80005ff0:	557d                	li	a0,-1
    80005ff2:	bfe5                	j	80005fea <uartgetc+0x1a>

0000000080005ff4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005ff4:	1101                	addi	sp,sp,-32
    80005ff6:	ec06                	sd	ra,24(sp)
    80005ff8:	e822                	sd	s0,16(sp)
    80005ffa:	e426                	sd	s1,8(sp)
    80005ffc:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005ffe:	54fd                	li	s1,-1
    80006000:	a029                	j	8000600a <uartintr+0x16>
      break;
    consoleintr(c);
    80006002:	00000097          	auipc	ra,0x0
    80006006:	918080e7          	jalr	-1768(ra) # 8000591a <consoleintr>
    int c = uartgetc();
    8000600a:	00000097          	auipc	ra,0x0
    8000600e:	fc6080e7          	jalr	-58(ra) # 80005fd0 <uartgetc>
    if(c == -1)
    80006012:	fe9518e3          	bne	a0,s1,80006002 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006016:	0001c497          	auipc	s1,0x1c
    8000601a:	d0248493          	addi	s1,s1,-766 # 80021d18 <uart_tx_lock>
    8000601e:	8526                	mv	a0,s1
    80006020:	00000097          	auipc	ra,0x0
    80006024:	0b4080e7          	jalr	180(ra) # 800060d4 <acquire>
  uartstart();
    80006028:	00000097          	auipc	ra,0x0
    8000602c:	e6c080e7          	jalr	-404(ra) # 80005e94 <uartstart>
  release(&uart_tx_lock);
    80006030:	8526                	mv	a0,s1
    80006032:	00000097          	auipc	ra,0x0
    80006036:	156080e7          	jalr	342(ra) # 80006188 <release>
}
    8000603a:	60e2                	ld	ra,24(sp)
    8000603c:	6442                	ld	s0,16(sp)
    8000603e:	64a2                	ld	s1,8(sp)
    80006040:	6105                	addi	sp,sp,32
    80006042:	8082                	ret

0000000080006044 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006044:	1141                	addi	sp,sp,-16
    80006046:	e422                	sd	s0,8(sp)
    80006048:	0800                	addi	s0,sp,16
  lk->name = name;
    8000604a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000604c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006050:	00053823          	sd	zero,16(a0)
}
    80006054:	6422                	ld	s0,8(sp)
    80006056:	0141                	addi	sp,sp,16
    80006058:	8082                	ret

000000008000605a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000605a:	411c                	lw	a5,0(a0)
    8000605c:	e399                	bnez	a5,80006062 <holding+0x8>
    8000605e:	4501                	li	a0,0
  return r;
}
    80006060:	8082                	ret
{
    80006062:	1101                	addi	sp,sp,-32
    80006064:	ec06                	sd	ra,24(sp)
    80006066:	e822                	sd	s0,16(sp)
    80006068:	e426                	sd	s1,8(sp)
    8000606a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000606c:	6904                	ld	s1,16(a0)
    8000606e:	ffffb097          	auipc	ra,0xffffb
    80006072:	dca080e7          	jalr	-566(ra) # 80000e38 <mycpu>
    80006076:	40a48533          	sub	a0,s1,a0
    8000607a:	00153513          	seqz	a0,a0
}
    8000607e:	60e2                	ld	ra,24(sp)
    80006080:	6442                	ld	s0,16(sp)
    80006082:	64a2                	ld	s1,8(sp)
    80006084:	6105                	addi	sp,sp,32
    80006086:	8082                	ret

0000000080006088 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006088:	1101                	addi	sp,sp,-32
    8000608a:	ec06                	sd	ra,24(sp)
    8000608c:	e822                	sd	s0,16(sp)
    8000608e:	e426                	sd	s1,8(sp)
    80006090:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006092:	100024f3          	csrr	s1,sstatus
    80006096:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000609a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000609c:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800060a0:	ffffb097          	auipc	ra,0xffffb
    800060a4:	d98080e7          	jalr	-616(ra) # 80000e38 <mycpu>
    800060a8:	5d3c                	lw	a5,120(a0)
    800060aa:	cf89                	beqz	a5,800060c4 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800060ac:	ffffb097          	auipc	ra,0xffffb
    800060b0:	d8c080e7          	jalr	-628(ra) # 80000e38 <mycpu>
    800060b4:	5d3c                	lw	a5,120(a0)
    800060b6:	2785                	addiw	a5,a5,1
    800060b8:	dd3c                	sw	a5,120(a0)
}
    800060ba:	60e2                	ld	ra,24(sp)
    800060bc:	6442                	ld	s0,16(sp)
    800060be:	64a2                	ld	s1,8(sp)
    800060c0:	6105                	addi	sp,sp,32
    800060c2:	8082                	ret
    mycpu()->intena = old;
    800060c4:	ffffb097          	auipc	ra,0xffffb
    800060c8:	d74080e7          	jalr	-652(ra) # 80000e38 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800060cc:	8085                	srli	s1,s1,0x1
    800060ce:	8885                	andi	s1,s1,1
    800060d0:	dd64                	sw	s1,124(a0)
    800060d2:	bfe9                	j	800060ac <push_off+0x24>

00000000800060d4 <acquire>:
{
    800060d4:	1101                	addi	sp,sp,-32
    800060d6:	ec06                	sd	ra,24(sp)
    800060d8:	e822                	sd	s0,16(sp)
    800060da:	e426                	sd	s1,8(sp)
    800060dc:	1000                	addi	s0,sp,32
    800060de:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800060e0:	00000097          	auipc	ra,0x0
    800060e4:	fa8080e7          	jalr	-88(ra) # 80006088 <push_off>
  if(holding(lk))
    800060e8:	8526                	mv	a0,s1
    800060ea:	00000097          	auipc	ra,0x0
    800060ee:	f70080e7          	jalr	-144(ra) # 8000605a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800060f2:	4705                	li	a4,1
  if(holding(lk))
    800060f4:	e115                	bnez	a0,80006118 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800060f6:	87ba                	mv	a5,a4
    800060f8:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800060fc:	2781                	sext.w	a5,a5
    800060fe:	ffe5                	bnez	a5,800060f6 <acquire+0x22>
  __sync_synchronize();
    80006100:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006104:	ffffb097          	auipc	ra,0xffffb
    80006108:	d34080e7          	jalr	-716(ra) # 80000e38 <mycpu>
    8000610c:	e888                	sd	a0,16(s1)
}
    8000610e:	60e2                	ld	ra,24(sp)
    80006110:	6442                	ld	s0,16(sp)
    80006112:	64a2                	ld	s1,8(sp)
    80006114:	6105                	addi	sp,sp,32
    80006116:	8082                	ret
    panic("acquire");
    80006118:	00002517          	auipc	a0,0x2
    8000611c:	6f850513          	addi	a0,a0,1784 # 80008810 <digits+0x20>
    80006120:	00000097          	auipc	ra,0x0
    80006124:	a7c080e7          	jalr	-1412(ra) # 80005b9c <panic>

0000000080006128 <pop_off>:

void
pop_off(void)
{
    80006128:	1141                	addi	sp,sp,-16
    8000612a:	e406                	sd	ra,8(sp)
    8000612c:	e022                	sd	s0,0(sp)
    8000612e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006130:	ffffb097          	auipc	ra,0xffffb
    80006134:	d08080e7          	jalr	-760(ra) # 80000e38 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006138:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000613c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000613e:	e78d                	bnez	a5,80006168 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006140:	5d3c                	lw	a5,120(a0)
    80006142:	02f05b63          	blez	a5,80006178 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006146:	37fd                	addiw	a5,a5,-1
    80006148:	0007871b          	sext.w	a4,a5
    8000614c:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000614e:	eb09                	bnez	a4,80006160 <pop_off+0x38>
    80006150:	5d7c                	lw	a5,124(a0)
    80006152:	c799                	beqz	a5,80006160 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006154:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006158:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000615c:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006160:	60a2                	ld	ra,8(sp)
    80006162:	6402                	ld	s0,0(sp)
    80006164:	0141                	addi	sp,sp,16
    80006166:	8082                	ret
    panic("pop_off - interruptible");
    80006168:	00002517          	auipc	a0,0x2
    8000616c:	6b050513          	addi	a0,a0,1712 # 80008818 <digits+0x28>
    80006170:	00000097          	auipc	ra,0x0
    80006174:	a2c080e7          	jalr	-1492(ra) # 80005b9c <panic>
    panic("pop_off");
    80006178:	00002517          	auipc	a0,0x2
    8000617c:	6b850513          	addi	a0,a0,1720 # 80008830 <digits+0x40>
    80006180:	00000097          	auipc	ra,0x0
    80006184:	a1c080e7          	jalr	-1508(ra) # 80005b9c <panic>

0000000080006188 <release>:
{
    80006188:	1101                	addi	sp,sp,-32
    8000618a:	ec06                	sd	ra,24(sp)
    8000618c:	e822                	sd	s0,16(sp)
    8000618e:	e426                	sd	s1,8(sp)
    80006190:	1000                	addi	s0,sp,32
    80006192:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006194:	00000097          	auipc	ra,0x0
    80006198:	ec6080e7          	jalr	-314(ra) # 8000605a <holding>
    8000619c:	c115                	beqz	a0,800061c0 <release+0x38>
  lk->cpu = 0;
    8000619e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800061a2:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800061a6:	0f50000f          	fence	iorw,ow
    800061aa:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800061ae:	00000097          	auipc	ra,0x0
    800061b2:	f7a080e7          	jalr	-134(ra) # 80006128 <pop_off>
}
    800061b6:	60e2                	ld	ra,24(sp)
    800061b8:	6442                	ld	s0,16(sp)
    800061ba:	64a2                	ld	s1,8(sp)
    800061bc:	6105                	addi	sp,sp,32
    800061be:	8082                	ret
    panic("release");
    800061c0:	00002517          	auipc	a0,0x2
    800061c4:	67850513          	addi	a0,a0,1656 # 80008838 <digits+0x48>
    800061c8:	00000097          	auipc	ra,0x0
    800061cc:	9d4080e7          	jalr	-1580(ra) # 80005b9c <panic>
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
