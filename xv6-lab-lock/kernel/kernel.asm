
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	97013103          	ld	sp,-1680(sp) # 80008970 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	5c7050ef          	jal	ra,80005ddc <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    8000001c:	7139                	addi	sp,sp,-64
    8000001e:	fc06                	sd	ra,56(sp)
    80000020:	f822                	sd	s0,48(sp)
    80000022:	f426                	sd	s1,40(sp)
    80000024:	f04a                	sd	s2,32(sp)
    80000026:	ec4e                	sd	s3,24(sp)
    80000028:	e852                	sd	s4,16(sp)
    8000002a:	e456                	sd	s5,8(sp)
    8000002c:	0080                	addi	s0,sp,64
    struct run *r;

    if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    8000002e:	03451793          	slli	a5,a0,0x34
    80000032:	e3c1                	bnez	a5,800000b2 <kfree+0x96>
    80000034:	84aa                	mv	s1,a0
    80000036:	00028797          	auipc	a5,0x28
    8000003a:	b6278793          	addi	a5,a5,-1182 # 80027b98 <end>
    8000003e:	06f56a63          	bltu	a0,a5,800000b2 <kfree+0x96>
    80000042:	47c5                	li	a5,17
    80000044:	07ee                	slli	a5,a5,0x1b
    80000046:	06f57663          	bgeu	a0,a5,800000b2 <kfree+0x96>
        panic("kfree");

    // Fill with junk to catch dangling refs.
    memset(pa, 1, PGSIZE);
    8000004a:	6605                	lui	a2,0x1
    8000004c:	4585                	li	a1,1
    8000004e:	00000097          	auipc	ra,0x0
    80000052:	238080e7          	jalr	568(ra) # 80000286 <memset>

    r = (struct run *)pa;

    // 当CPU获取任何锁时，xv6总是禁用该CPU上的中断。
    push_off();
    80000056:	00006097          	auipc	ra,0x6
    8000005a:	710080e7          	jalr	1808(ra) # 80006766 <push_off>

    int CPUID = cpuid();
    8000005e:	00001097          	auipc	ra,0x1
    80000062:	ee6080e7          	jalr	-282(ra) # 80000f44 <cpuid>
    acquire(&kmem[CPUID].lock);
    80000066:	00009a97          	auipc	s5,0x9
    8000006a:	95aa8a93          	addi	s5,s5,-1702 # 800089c0 <kmem>
    8000006e:	00251993          	slli	s3,a0,0x2
    80000072:	00a98933          	add	s2,s3,a0
    80000076:	090e                	slli	s2,s2,0x3
    80000078:	9956                	add	s2,s2,s5
    8000007a:	854a                	mv	a0,s2
    8000007c:	00006097          	auipc	ra,0x6
    80000080:	736080e7          	jalr	1846(ra) # 800067b2 <acquire>
    // 从链表头插入空闲页
    r->next = kmem[CPUID].freelist;
    80000084:	02093783          	ld	a5,32(s2)
    80000088:	e09c                	sd	a5,0(s1)
    kmem[CPUID].freelist = r;
    8000008a:	02993023          	sd	s1,32(s2)
    release(&kmem[CPUID].lock);
    8000008e:	854a                	mv	a0,s2
    80000090:	00006097          	auipc	ra,0x6
    80000094:	7f2080e7          	jalr	2034(ra) # 80006882 <release>

    // 当CPU未持有自旋锁时，xv6重新启用中断
    pop_off();
    80000098:	00006097          	auipc	ra,0x6
    8000009c:	78a080e7          	jalr	1930(ra) # 80006822 <pop_off>
}
    800000a0:	70e2                	ld	ra,56(sp)
    800000a2:	7442                	ld	s0,48(sp)
    800000a4:	74a2                	ld	s1,40(sp)
    800000a6:	7902                	ld	s2,32(sp)
    800000a8:	69e2                	ld	s3,24(sp)
    800000aa:	6a42                	ld	s4,16(sp)
    800000ac:	6aa2                	ld	s5,8(sp)
    800000ae:	6121                	addi	sp,sp,64
    800000b0:	8082                	ret
        panic("kfree");
    800000b2:	00008517          	auipc	a0,0x8
    800000b6:	f5e50513          	addi	a0,a0,-162 # 80008010 <etext+0x10>
    800000ba:	00006097          	auipc	ra,0x6
    800000be:	1d6080e7          	jalr	470(ra) # 80006290 <panic>

00000000800000c2 <freerange>:
{
    800000c2:	7179                	addi	sp,sp,-48
    800000c4:	f406                	sd	ra,40(sp)
    800000c6:	f022                	sd	s0,32(sp)
    800000c8:	ec26                	sd	s1,24(sp)
    800000ca:	e84a                	sd	s2,16(sp)
    800000cc:	e44e                	sd	s3,8(sp)
    800000ce:	e052                	sd	s4,0(sp)
    800000d0:	1800                	addi	s0,sp,48
    p = (char *)PGROUNDUP((uint64)pa_start);
    800000d2:	6785                	lui	a5,0x1
    800000d4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000d8:	00e504b3          	add	s1,a0,a4
    800000dc:	777d                	lui	a4,0xfffff
    800000de:	8cf9                	and	s1,s1,a4
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    800000e0:	94be                	add	s1,s1,a5
    800000e2:	0095ee63          	bltu	a1,s1,800000fe <freerange+0x3c>
    800000e6:	892e                	mv	s2,a1
        kfree(p);
    800000e8:	7a7d                	lui	s4,0xfffff
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    800000ea:	6985                	lui	s3,0x1
        kfree(p);
    800000ec:	01448533          	add	a0,s1,s4
    800000f0:	00000097          	auipc	ra,0x0
    800000f4:	f2c080e7          	jalr	-212(ra) # 8000001c <kfree>
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    800000f8:	94ce                	add	s1,s1,s3
    800000fa:	fe9979e3          	bgeu	s2,s1,800000ec <freerange+0x2a>
}
    800000fe:	70a2                	ld	ra,40(sp)
    80000100:	7402                	ld	s0,32(sp)
    80000102:	64e2                	ld	s1,24(sp)
    80000104:	6942                	ld	s2,16(sp)
    80000106:	69a2                	ld	s3,8(sp)
    80000108:	6a02                	ld	s4,0(sp)
    8000010a:	6145                	addi	sp,sp,48
    8000010c:	8082                	ret

000000008000010e <kinit>:
{
    8000010e:	715d                	addi	sp,sp,-80
    80000110:	e486                	sd	ra,72(sp)
    80000112:	e0a2                	sd	s0,64(sp)
    80000114:	fc26                	sd	s1,56(sp)
    80000116:	f84a                	sd	s2,48(sp)
    80000118:	f44e                	sd	s3,40(sp)
    8000011a:	f052                	sd	s4,32(sp)
    8000011c:	0880                	addi	s0,sp,80
    for (int i = 0; i < NCPU; i++) {
    8000011e:	00009917          	auipc	s2,0x9
    80000122:	8a290913          	addi	s2,s2,-1886 # 800089c0 <kmem>
    80000126:	4481                	li	s1,0
        snprintf(kmem_name, 32, "kmem_%d", i);
    80000128:	00008a17          	auipc	s4,0x8
    8000012c:	ef0a0a13          	addi	s4,s4,-272 # 80008018 <etext+0x18>
    for (int i = 0; i < NCPU; i++) {
    80000130:	49a1                	li	s3,8
        snprintf(kmem_name, 32, "kmem_%d", i);
    80000132:	86a6                	mv	a3,s1
    80000134:	8652                	mv	a2,s4
    80000136:	02000593          	li	a1,32
    8000013a:	fb040513          	addi	a0,s0,-80
    8000013e:	00006097          	auipc	ra,0x6
    80000142:	ab8080e7          	jalr	-1352(ra) # 80005bf6 <snprintf>
        initlock(&kmem[i].lock, kmem_name);
    80000146:	fb040593          	addi	a1,s0,-80
    8000014a:	854a                	mv	a0,s2
    8000014c:	00006097          	auipc	ra,0x6
    80000150:	7e2080e7          	jalr	2018(ra) # 8000692e <initlock>
    for (int i = 0; i < NCPU; i++) {
    80000154:	2485                	addiw	s1,s1,1
    80000156:	02890913          	addi	s2,s2,40
    8000015a:	fd349ce3          	bne	s1,s3,80000132 <kinit+0x24>
    freerange(end, (void *)PHYSTOP);
    8000015e:	45c5                	li	a1,17
    80000160:	05ee                	slli	a1,a1,0x1b
    80000162:	00028517          	auipc	a0,0x28
    80000166:	a3650513          	addi	a0,a0,-1482 # 80027b98 <end>
    8000016a:	00000097          	auipc	ra,0x0
    8000016e:	f58080e7          	jalr	-168(ra) # 800000c2 <freerange>
}
    80000172:	60a6                	ld	ra,72(sp)
    80000174:	6406                	ld	s0,64(sp)
    80000176:	74e2                	ld	s1,56(sp)
    80000178:	7942                	ld	s2,48(sp)
    8000017a:	79a2                	ld	s3,40(sp)
    8000017c:	7a02                	ld	s4,32(sp)
    8000017e:	6161                	addi	sp,sp,80
    80000180:	8082                	ret

0000000080000182 <kalloc>:

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc(void)
{
    80000182:	715d                	addi	sp,sp,-80
    80000184:	e486                	sd	ra,72(sp)
    80000186:	e0a2                	sd	s0,64(sp)
    80000188:	fc26                	sd	s1,56(sp)
    8000018a:	f84a                	sd	s2,48(sp)
    8000018c:	f44e                	sd	s3,40(sp)
    8000018e:	f052                	sd	s4,32(sp)
    80000190:	ec56                	sd	s5,24(sp)
    80000192:	e85a                	sd	s6,16(sp)
    80000194:	e45e                	sd	s7,8(sp)
    80000196:	e062                	sd	s8,0(sp)
    80000198:	0880                	addi	s0,sp,80
    struct run *r;

    push_off();
    8000019a:	00006097          	auipc	ra,0x6
    8000019e:	5cc080e7          	jalr	1484(ra) # 80006766 <push_off>
    int CPUID = cpuid();
    800001a2:	00001097          	auipc	ra,0x1
    800001a6:	da2080e7          	jalr	-606(ra) # 80000f44 <cpuid>
    800001aa:	892a                	mv	s2,a0
    acquire(&kmem[CPUID].lock);
    800001ac:	00251793          	slli	a5,a0,0x2
    800001b0:	97aa                	add	a5,a5,a0
    800001b2:	078e                	slli	a5,a5,0x3
    800001b4:	00009a97          	auipc	s5,0x9
    800001b8:	80ca8a93          	addi	s5,s5,-2036 # 800089c0 <kmem>
    800001bc:	9abe                	add	s5,s5,a5
    800001be:	8556                	mv	a0,s5
    800001c0:	00006097          	auipc	ra,0x6
    800001c4:	5f2080e7          	jalr	1522(ra) # 800067b2 <acquire>

    r = kmem[CPUID].freelist;
    800001c8:	020abb03          	ld	s6,32(s5)

    // 在当前CPU上查找空闲页
    if (r)
    800001cc:	000b0863          	beqz	s6,800001dc <kalloc+0x5a>
        kmem[CPUID].freelist = r->next;
    800001d0:	000b3683          	ld	a3,0(s6)
    800001d4:	02dab023          	sd	a3,32(s5)
    r = kmem[CPUID].freelist;
    800001d8:	8a5a                	mv	s4,s6
    800001da:	a88d                	j	8000024c <kalloc+0xca>
    800001dc:	00008997          	auipc	s3,0x8
    800001e0:	7e498993          	addi	s3,s3,2020 # 800089c0 <kmem>

    if (r == 0) { // 若当前CPU上没有空闲页
        // 在其他CPU上查找空闲页
        for (int i = 0; i < NCPU; i++) {
    800001e4:	4481                	li	s1,0
    800001e6:	4c21                	li	s8,8
    800001e8:	a035                	j	80000214 <kalloc+0x92>
            if (r) // 已找到，脱出循环
                break;
        }
    }

    release(&kmem[CPUID].lock);
    800001ea:	8556                	mv	a0,s5
    800001ec:	00006097          	auipc	ra,0x6
    800001f0:	696080e7          	jalr	1686(ra) # 80006882 <release>
    pop_off();
    800001f4:	00006097          	auipc	ra,0x6
    800001f8:	62e080e7          	jalr	1582(ra) # 80006822 <pop_off>

    if (r)
    800001fc:	8a5a                	mv	s4,s6
        memset((char *)r, 5, PGSIZE); // fill with junk
    return (void *)r;
    800001fe:	a0bd                	j	8000026c <kalloc+0xea>
            release(&kmem[i].lock);
    80000200:	854e                	mv	a0,s3
    80000202:	00006097          	auipc	ra,0x6
    80000206:	680080e7          	jalr	1664(ra) # 80006882 <release>
        for (int i = 0; i < NCPU; i++) {
    8000020a:	2485                	addiw	s1,s1,1
    8000020c:	02898993          	addi	s3,s3,40
    80000210:	fd848de3          	beq	s1,s8,800001ea <kalloc+0x68>
            if (i == CPUID)
    80000214:	fe990be3          	beq	s2,s1,8000020a <kalloc+0x88>
            acquire(&kmem[i].lock);
    80000218:	854e                	mv	a0,s3
    8000021a:	00006097          	auipc	ra,0x6
    8000021e:	598080e7          	jalr	1432(ra) # 800067b2 <acquire>
            r = kmem[i].freelist;
    80000222:	0209ba03          	ld	s4,32(s3)
            if (r)
    80000226:	fc0a0de3          	beqz	s4,80000200 <kalloc+0x7e>
                kmem[i].freelist = r->next;
    8000022a:	000a3683          	ld	a3,0(s4)
    8000022e:	00249793          	slli	a5,s1,0x2
    80000232:	97a6                	add	a5,a5,s1
    80000234:	078e                	slli	a5,a5,0x3
    80000236:	00008717          	auipc	a4,0x8
    8000023a:	78a70713          	addi	a4,a4,1930 # 800089c0 <kmem>
    8000023e:	97ba                	add	a5,a5,a4
    80000240:	f394                	sd	a3,32(a5)
            release(&kmem[i].lock);
    80000242:	854e                	mv	a0,s3
    80000244:	00006097          	auipc	ra,0x6
    80000248:	63e080e7          	jalr	1598(ra) # 80006882 <release>
    release(&kmem[CPUID].lock);
    8000024c:	8556                	mv	a0,s5
    8000024e:	00006097          	auipc	ra,0x6
    80000252:	634080e7          	jalr	1588(ra) # 80006882 <release>
    pop_off();
    80000256:	00006097          	auipc	ra,0x6
    8000025a:	5cc080e7          	jalr	1484(ra) # 80006822 <pop_off>
        memset((char *)r, 5, PGSIZE); // fill with junk
    8000025e:	6605                	lui	a2,0x1
    80000260:	4595                	li	a1,5
    80000262:	8552                	mv	a0,s4
    80000264:	00000097          	auipc	ra,0x0
    80000268:	022080e7          	jalr	34(ra) # 80000286 <memset>
}
    8000026c:	8552                	mv	a0,s4
    8000026e:	60a6                	ld	ra,72(sp)
    80000270:	6406                	ld	s0,64(sp)
    80000272:	74e2                	ld	s1,56(sp)
    80000274:	7942                	ld	s2,48(sp)
    80000276:	79a2                	ld	s3,40(sp)
    80000278:	7a02                	ld	s4,32(sp)
    8000027a:	6ae2                	ld	s5,24(sp)
    8000027c:	6b42                	ld	s6,16(sp)
    8000027e:	6ba2                	ld	s7,8(sp)
    80000280:	6c02                	ld	s8,0(sp)
    80000282:	6161                	addi	sp,sp,80
    80000284:	8082                	ret

0000000080000286 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000028c:	ca19                	beqz	a2,800002a2 <memset+0x1c>
    8000028e:	87aa                	mv	a5,a0
    80000290:	1602                	slli	a2,a2,0x20
    80000292:	9201                	srli	a2,a2,0x20
    80000294:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000298:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000029c:	0785                	addi	a5,a5,1
    8000029e:	fee79de3          	bne	a5,a4,80000298 <memset+0x12>
  }
  return dst;
}
    800002a2:	6422                	ld	s0,8(sp)
    800002a4:	0141                	addi	sp,sp,16
    800002a6:	8082                	ret

00000000800002a8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800002a8:	1141                	addi	sp,sp,-16
    800002aa:	e422                	sd	s0,8(sp)
    800002ac:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800002ae:	ca05                	beqz	a2,800002de <memcmp+0x36>
    800002b0:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800002b4:	1682                	slli	a3,a3,0x20
    800002b6:	9281                	srli	a3,a3,0x20
    800002b8:	0685                	addi	a3,a3,1
    800002ba:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800002bc:	00054783          	lbu	a5,0(a0)
    800002c0:	0005c703          	lbu	a4,0(a1)
    800002c4:	00e79863          	bne	a5,a4,800002d4 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800002c8:	0505                	addi	a0,a0,1
    800002ca:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800002cc:	fed518e3          	bne	a0,a3,800002bc <memcmp+0x14>
  }

  return 0;
    800002d0:	4501                	li	a0,0
    800002d2:	a019                	j	800002d8 <memcmp+0x30>
      return *s1 - *s2;
    800002d4:	40e7853b          	subw	a0,a5,a4
}
    800002d8:	6422                	ld	s0,8(sp)
    800002da:	0141                	addi	sp,sp,16
    800002dc:	8082                	ret
  return 0;
    800002de:	4501                	li	a0,0
    800002e0:	bfe5                	j	800002d8 <memcmp+0x30>

00000000800002e2 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800002e2:	1141                	addi	sp,sp,-16
    800002e4:	e422                	sd	s0,8(sp)
    800002e6:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800002e8:	c205                	beqz	a2,80000308 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800002ea:	02a5e263          	bltu	a1,a0,8000030e <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800002ee:	1602                	slli	a2,a2,0x20
    800002f0:	9201                	srli	a2,a2,0x20
    800002f2:	00c587b3          	add	a5,a1,a2
{
    800002f6:	872a                	mv	a4,a0
      *d++ = *s++;
    800002f8:	0585                	addi	a1,a1,1
    800002fa:	0705                	addi	a4,a4,1
    800002fc:	fff5c683          	lbu	a3,-1(a1)
    80000300:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000304:	fef59ae3          	bne	a1,a5,800002f8 <memmove+0x16>

  return dst;
}
    80000308:	6422                	ld	s0,8(sp)
    8000030a:	0141                	addi	sp,sp,16
    8000030c:	8082                	ret
  if(s < d && s + n > d){
    8000030e:	02061693          	slli	a3,a2,0x20
    80000312:	9281                	srli	a3,a3,0x20
    80000314:	00d58733          	add	a4,a1,a3
    80000318:	fce57be3          	bgeu	a0,a4,800002ee <memmove+0xc>
    d += n;
    8000031c:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000031e:	fff6079b          	addiw	a5,a2,-1
    80000322:	1782                	slli	a5,a5,0x20
    80000324:	9381                	srli	a5,a5,0x20
    80000326:	fff7c793          	not	a5,a5
    8000032a:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000032c:	177d                	addi	a4,a4,-1
    8000032e:	16fd                	addi	a3,a3,-1
    80000330:	00074603          	lbu	a2,0(a4)
    80000334:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000338:	fee79ae3          	bne	a5,a4,8000032c <memmove+0x4a>
    8000033c:	b7f1                	j	80000308 <memmove+0x26>

000000008000033e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000033e:	1141                	addi	sp,sp,-16
    80000340:	e406                	sd	ra,8(sp)
    80000342:	e022                	sd	s0,0(sp)
    80000344:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000346:	00000097          	auipc	ra,0x0
    8000034a:	f9c080e7          	jalr	-100(ra) # 800002e2 <memmove>
}
    8000034e:	60a2                	ld	ra,8(sp)
    80000350:	6402                	ld	s0,0(sp)
    80000352:	0141                	addi	sp,sp,16
    80000354:	8082                	ret

0000000080000356 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000356:	1141                	addi	sp,sp,-16
    80000358:	e422                	sd	s0,8(sp)
    8000035a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000035c:	ce11                	beqz	a2,80000378 <strncmp+0x22>
    8000035e:	00054783          	lbu	a5,0(a0)
    80000362:	cf89                	beqz	a5,8000037c <strncmp+0x26>
    80000364:	0005c703          	lbu	a4,0(a1)
    80000368:	00f71a63          	bne	a4,a5,8000037c <strncmp+0x26>
    n--, p++, q++;
    8000036c:	367d                	addiw	a2,a2,-1
    8000036e:	0505                	addi	a0,a0,1
    80000370:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000372:	f675                	bnez	a2,8000035e <strncmp+0x8>
  if(n == 0)
    return 0;
    80000374:	4501                	li	a0,0
    80000376:	a809                	j	80000388 <strncmp+0x32>
    80000378:	4501                	li	a0,0
    8000037a:	a039                	j	80000388 <strncmp+0x32>
  if(n == 0)
    8000037c:	ca09                	beqz	a2,8000038e <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    8000037e:	00054503          	lbu	a0,0(a0)
    80000382:	0005c783          	lbu	a5,0(a1)
    80000386:	9d1d                	subw	a0,a0,a5
}
    80000388:	6422                	ld	s0,8(sp)
    8000038a:	0141                	addi	sp,sp,16
    8000038c:	8082                	ret
    return 0;
    8000038e:	4501                	li	a0,0
    80000390:	bfe5                	j	80000388 <strncmp+0x32>

0000000080000392 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000392:	1141                	addi	sp,sp,-16
    80000394:	e422                	sd	s0,8(sp)
    80000396:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000398:	872a                	mv	a4,a0
    8000039a:	8832                	mv	a6,a2
    8000039c:	367d                	addiw	a2,a2,-1
    8000039e:	01005963          	blez	a6,800003b0 <strncpy+0x1e>
    800003a2:	0705                	addi	a4,a4,1
    800003a4:	0005c783          	lbu	a5,0(a1)
    800003a8:	fef70fa3          	sb	a5,-1(a4)
    800003ac:	0585                	addi	a1,a1,1
    800003ae:	f7f5                	bnez	a5,8000039a <strncpy+0x8>
    ;
  while(n-- > 0)
    800003b0:	86ba                	mv	a3,a4
    800003b2:	00c05c63          	blez	a2,800003ca <strncpy+0x38>
    *s++ = 0;
    800003b6:	0685                	addi	a3,a3,1
    800003b8:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800003bc:	40d707bb          	subw	a5,a4,a3
    800003c0:	37fd                	addiw	a5,a5,-1
    800003c2:	010787bb          	addw	a5,a5,a6
    800003c6:	fef048e3          	bgtz	a5,800003b6 <strncpy+0x24>
  return os;
}
    800003ca:	6422                	ld	s0,8(sp)
    800003cc:	0141                	addi	sp,sp,16
    800003ce:	8082                	ret

00000000800003d0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800003d0:	1141                	addi	sp,sp,-16
    800003d2:	e422                	sd	s0,8(sp)
    800003d4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800003d6:	02c05363          	blez	a2,800003fc <safestrcpy+0x2c>
    800003da:	fff6069b          	addiw	a3,a2,-1
    800003de:	1682                	slli	a3,a3,0x20
    800003e0:	9281                	srli	a3,a3,0x20
    800003e2:	96ae                	add	a3,a3,a1
    800003e4:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800003e6:	00d58963          	beq	a1,a3,800003f8 <safestrcpy+0x28>
    800003ea:	0585                	addi	a1,a1,1
    800003ec:	0785                	addi	a5,a5,1
    800003ee:	fff5c703          	lbu	a4,-1(a1)
    800003f2:	fee78fa3          	sb	a4,-1(a5)
    800003f6:	fb65                	bnez	a4,800003e6 <safestrcpy+0x16>
    ;
  *s = 0;
    800003f8:	00078023          	sb	zero,0(a5)
  return os;
}
    800003fc:	6422                	ld	s0,8(sp)
    800003fe:	0141                	addi	sp,sp,16
    80000400:	8082                	ret

0000000080000402 <strlen>:

int
strlen(const char *s)
{
    80000402:	1141                	addi	sp,sp,-16
    80000404:	e422                	sd	s0,8(sp)
    80000406:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000408:	00054783          	lbu	a5,0(a0)
    8000040c:	cf91                	beqz	a5,80000428 <strlen+0x26>
    8000040e:	0505                	addi	a0,a0,1
    80000410:	87aa                	mv	a5,a0
    80000412:	4685                	li	a3,1
    80000414:	9e89                	subw	a3,a3,a0
    80000416:	00f6853b          	addw	a0,a3,a5
    8000041a:	0785                	addi	a5,a5,1
    8000041c:	fff7c703          	lbu	a4,-1(a5)
    80000420:	fb7d                	bnez	a4,80000416 <strlen+0x14>
    ;
  return n;
}
    80000422:	6422                	ld	s0,8(sp)
    80000424:	0141                	addi	sp,sp,16
    80000426:	8082                	ret
  for(n = 0; s[n]; n++)
    80000428:	4501                	li	a0,0
    8000042a:	bfe5                	j	80000422 <strlen+0x20>

000000008000042c <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000042c:	1101                	addi	sp,sp,-32
    8000042e:	ec06                	sd	ra,24(sp)
    80000430:	e822                	sd	s0,16(sp)
    80000432:	e426                	sd	s1,8(sp)
    80000434:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80000436:	00001097          	auipc	ra,0x1
    8000043a:	b0e080e7          	jalr	-1266(ra) # 80000f44 <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(atomic_read4((int *) &started) == 0)
    8000043e:	00008497          	auipc	s1,0x8
    80000442:	55248493          	addi	s1,s1,1362 # 80008990 <started>
  if(cpuid() == 0){
    80000446:	c531                	beqz	a0,80000492 <main+0x66>
    while(atomic_read4((int *) &started) == 0)
    80000448:	8526                	mv	a0,s1
    8000044a:	00006097          	auipc	ra,0x6
    8000044e:	564080e7          	jalr	1380(ra) # 800069ae <atomic_read4>
    80000452:	d97d                	beqz	a0,80000448 <main+0x1c>
      ;
    __sync_synchronize();
    80000454:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000458:	00001097          	auipc	ra,0x1
    8000045c:	aec080e7          	jalr	-1300(ra) # 80000f44 <cpuid>
    80000460:	85aa                	mv	a1,a0
    80000462:	00008517          	auipc	a0,0x8
    80000466:	bd650513          	addi	a0,a0,-1066 # 80008038 <etext+0x38>
    8000046a:	00006097          	auipc	ra,0x6
    8000046e:	e70080e7          	jalr	-400(ra) # 800062da <printf>
    kvminithart();    // turn on paging
    80000472:	00000097          	auipc	ra,0x0
    80000476:	0e0080e7          	jalr	224(ra) # 80000552 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000047a:	00001097          	auipc	ra,0x1
    8000047e:	794080e7          	jalr	1940(ra) # 80001c0e <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000482:	00005097          	auipc	ra,0x5
    80000486:	fde080e7          	jalr	-34(ra) # 80005460 <plicinithart>
  }

  scheduler();        
    8000048a:	00001097          	auipc	ra,0x1
    8000048e:	fdc080e7          	jalr	-36(ra) # 80001466 <scheduler>
    consoleinit();
    80000492:	00006097          	auipc	ra,0x6
    80000496:	d0e080e7          	jalr	-754(ra) # 800061a0 <consoleinit>
    statsinit();
    8000049a:	00005097          	auipc	ra,0x5
    8000049e:	67e080e7          	jalr	1662(ra) # 80005b18 <statsinit>
    printfinit();
    800004a2:	00006097          	auipc	ra,0x6
    800004a6:	018080e7          	jalr	24(ra) # 800064ba <printfinit>
    printf("\n");
    800004aa:	00008517          	auipc	a0,0x8
    800004ae:	40650513          	addi	a0,a0,1030 # 800088b0 <digits+0x88>
    800004b2:	00006097          	auipc	ra,0x6
    800004b6:	e28080e7          	jalr	-472(ra) # 800062da <printf>
    printf("xv6 kernel is booting\n");
    800004ba:	00008517          	auipc	a0,0x8
    800004be:	b6650513          	addi	a0,a0,-1178 # 80008020 <etext+0x20>
    800004c2:	00006097          	auipc	ra,0x6
    800004c6:	e18080e7          	jalr	-488(ra) # 800062da <printf>
    printf("\n");
    800004ca:	00008517          	auipc	a0,0x8
    800004ce:	3e650513          	addi	a0,a0,998 # 800088b0 <digits+0x88>
    800004d2:	00006097          	auipc	ra,0x6
    800004d6:	e08080e7          	jalr	-504(ra) # 800062da <printf>
    kinit();         // physical page allocator
    800004da:	00000097          	auipc	ra,0x0
    800004de:	c34080e7          	jalr	-972(ra) # 8000010e <kinit>
    kvminit();       // create kernel page table
    800004e2:	00000097          	auipc	ra,0x0
    800004e6:	326080e7          	jalr	806(ra) # 80000808 <kvminit>
    kvminithart();   // turn on paging
    800004ea:	00000097          	auipc	ra,0x0
    800004ee:	068080e7          	jalr	104(ra) # 80000552 <kvminithart>
    procinit();      // process table
    800004f2:	00001097          	auipc	ra,0x1
    800004f6:	99e080e7          	jalr	-1634(ra) # 80000e90 <procinit>
    trapinit();      // trap vectors
    800004fa:	00001097          	auipc	ra,0x1
    800004fe:	6ec080e7          	jalr	1772(ra) # 80001be6 <trapinit>
    trapinithart();  // install kernel trap vector
    80000502:	00001097          	auipc	ra,0x1
    80000506:	70c080e7          	jalr	1804(ra) # 80001c0e <trapinithart>
    plicinit();      // set up interrupt controller
    8000050a:	00005097          	auipc	ra,0x5
    8000050e:	f40080e7          	jalr	-192(ra) # 8000544a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000512:	00005097          	auipc	ra,0x5
    80000516:	f4e080e7          	jalr	-178(ra) # 80005460 <plicinithart>
    binit();         // buffer cache
    8000051a:	00002097          	auipc	ra,0x2
    8000051e:	e50080e7          	jalr	-432(ra) # 8000236a <binit>
    iinit();         // inode table
    80000522:	00002097          	auipc	ra,0x2
    80000526:	768080e7          	jalr	1896(ra) # 80002c8a <iinit>
    fileinit();      // file table
    8000052a:	00003097          	auipc	ra,0x3
    8000052e:	722080e7          	jalr	1826(ra) # 80003c4c <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000532:	00005097          	auipc	ra,0x5
    80000536:	036080e7          	jalr	54(ra) # 80005568 <virtio_disk_init>
    userinit();      // first user process
    8000053a:	00001097          	auipc	ra,0x1
    8000053e:	d0e080e7          	jalr	-754(ra) # 80001248 <userinit>
    __sync_synchronize();
    80000542:	0ff0000f          	fence
    started = 1;
    80000546:	4785                	li	a5,1
    80000548:	00008717          	auipc	a4,0x8
    8000054c:	44f72423          	sw	a5,1096(a4) # 80008990 <started>
    80000550:	bf2d                	j	8000048a <main+0x5e>

0000000080000552 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000552:	1141                	addi	sp,sp,-16
    80000554:	e422                	sd	s0,8(sp)
    80000556:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000558:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000055c:	00008797          	auipc	a5,0x8
    80000560:	43c7b783          	ld	a5,1084(a5) # 80008998 <kernel_pagetable>
    80000564:	83b1                	srli	a5,a5,0xc
    80000566:	577d                	li	a4,-1
    80000568:	177e                	slli	a4,a4,0x3f
    8000056a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000056c:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000570:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000574:	6422                	ld	s0,8(sp)
    80000576:	0141                	addi	sp,sp,16
    80000578:	8082                	ret

000000008000057a <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000057a:	7139                	addi	sp,sp,-64
    8000057c:	fc06                	sd	ra,56(sp)
    8000057e:	f822                	sd	s0,48(sp)
    80000580:	f426                	sd	s1,40(sp)
    80000582:	f04a                	sd	s2,32(sp)
    80000584:	ec4e                	sd	s3,24(sp)
    80000586:	e852                	sd	s4,16(sp)
    80000588:	e456                	sd	s5,8(sp)
    8000058a:	e05a                	sd	s6,0(sp)
    8000058c:	0080                	addi	s0,sp,64
    8000058e:	84aa                	mv	s1,a0
    80000590:	89ae                	mv	s3,a1
    80000592:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000594:	57fd                	li	a5,-1
    80000596:	83e9                	srli	a5,a5,0x1a
    80000598:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000059a:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000059c:	04b7f263          	bgeu	a5,a1,800005e0 <walk+0x66>
    panic("walk");
    800005a0:	00008517          	auipc	a0,0x8
    800005a4:	ab050513          	addi	a0,a0,-1360 # 80008050 <etext+0x50>
    800005a8:	00006097          	auipc	ra,0x6
    800005ac:	ce8080e7          	jalr	-792(ra) # 80006290 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800005b0:	060a8663          	beqz	s5,8000061c <walk+0xa2>
    800005b4:	00000097          	auipc	ra,0x0
    800005b8:	bce080e7          	jalr	-1074(ra) # 80000182 <kalloc>
    800005bc:	84aa                	mv	s1,a0
    800005be:	c529                	beqz	a0,80000608 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800005c0:	6605                	lui	a2,0x1
    800005c2:	4581                	li	a1,0
    800005c4:	00000097          	auipc	ra,0x0
    800005c8:	cc2080e7          	jalr	-830(ra) # 80000286 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800005cc:	00c4d793          	srli	a5,s1,0xc
    800005d0:	07aa                	slli	a5,a5,0xa
    800005d2:	0017e793          	ori	a5,a5,1
    800005d6:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800005da:	3a5d                	addiw	s4,s4,-9
    800005dc:	036a0063          	beq	s4,s6,800005fc <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800005e0:	0149d933          	srl	s2,s3,s4
    800005e4:	1ff97913          	andi	s2,s2,511
    800005e8:	090e                	slli	s2,s2,0x3
    800005ea:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800005ec:	00093483          	ld	s1,0(s2)
    800005f0:	0014f793          	andi	a5,s1,1
    800005f4:	dfd5                	beqz	a5,800005b0 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800005f6:	80a9                	srli	s1,s1,0xa
    800005f8:	04b2                	slli	s1,s1,0xc
    800005fa:	b7c5                	j	800005da <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800005fc:	00c9d513          	srli	a0,s3,0xc
    80000600:	1ff57513          	andi	a0,a0,511
    80000604:	050e                	slli	a0,a0,0x3
    80000606:	9526                	add	a0,a0,s1
}
    80000608:	70e2                	ld	ra,56(sp)
    8000060a:	7442                	ld	s0,48(sp)
    8000060c:	74a2                	ld	s1,40(sp)
    8000060e:	7902                	ld	s2,32(sp)
    80000610:	69e2                	ld	s3,24(sp)
    80000612:	6a42                	ld	s4,16(sp)
    80000614:	6aa2                	ld	s5,8(sp)
    80000616:	6b02                	ld	s6,0(sp)
    80000618:	6121                	addi	sp,sp,64
    8000061a:	8082                	ret
        return 0;
    8000061c:	4501                	li	a0,0
    8000061e:	b7ed                	j	80000608 <walk+0x8e>

0000000080000620 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000620:	57fd                	li	a5,-1
    80000622:	83e9                	srli	a5,a5,0x1a
    80000624:	00b7f463          	bgeu	a5,a1,8000062c <walkaddr+0xc>
    return 0;
    80000628:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000062a:	8082                	ret
{
    8000062c:	1141                	addi	sp,sp,-16
    8000062e:	e406                	sd	ra,8(sp)
    80000630:	e022                	sd	s0,0(sp)
    80000632:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000634:	4601                	li	a2,0
    80000636:	00000097          	auipc	ra,0x0
    8000063a:	f44080e7          	jalr	-188(ra) # 8000057a <walk>
  if(pte == 0)
    8000063e:	c105                	beqz	a0,8000065e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000640:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000642:	0117f693          	andi	a3,a5,17
    80000646:	4745                	li	a4,17
    return 0;
    80000648:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000064a:	00e68663          	beq	a3,a4,80000656 <walkaddr+0x36>
}
    8000064e:	60a2                	ld	ra,8(sp)
    80000650:	6402                	ld	s0,0(sp)
    80000652:	0141                	addi	sp,sp,16
    80000654:	8082                	ret
  pa = PTE2PA(*pte);
    80000656:	83a9                	srli	a5,a5,0xa
    80000658:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000065c:	bfcd                	j	8000064e <walkaddr+0x2e>
    return 0;
    8000065e:	4501                	li	a0,0
    80000660:	b7fd                	j	8000064e <walkaddr+0x2e>

0000000080000662 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000662:	715d                	addi	sp,sp,-80
    80000664:	e486                	sd	ra,72(sp)
    80000666:	e0a2                	sd	s0,64(sp)
    80000668:	fc26                	sd	s1,56(sp)
    8000066a:	f84a                	sd	s2,48(sp)
    8000066c:	f44e                	sd	s3,40(sp)
    8000066e:	f052                	sd	s4,32(sp)
    80000670:	ec56                	sd	s5,24(sp)
    80000672:	e85a                	sd	s6,16(sp)
    80000674:	e45e                	sd	s7,8(sp)
    80000676:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000678:	c639                	beqz	a2,800006c6 <mappages+0x64>
    8000067a:	8aaa                	mv	s5,a0
    8000067c:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000067e:	777d                	lui	a4,0xfffff
    80000680:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000684:	fff58993          	addi	s3,a1,-1
    80000688:	99b2                	add	s3,s3,a2
    8000068a:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000068e:	893e                	mv	s2,a5
    80000690:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000694:	6b85                	lui	s7,0x1
    80000696:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000069a:	4605                	li	a2,1
    8000069c:	85ca                	mv	a1,s2
    8000069e:	8556                	mv	a0,s5
    800006a0:	00000097          	auipc	ra,0x0
    800006a4:	eda080e7          	jalr	-294(ra) # 8000057a <walk>
    800006a8:	cd1d                	beqz	a0,800006e6 <mappages+0x84>
    if(*pte & PTE_V)
    800006aa:	611c                	ld	a5,0(a0)
    800006ac:	8b85                	andi	a5,a5,1
    800006ae:	e785                	bnez	a5,800006d6 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800006b0:	80b1                	srli	s1,s1,0xc
    800006b2:	04aa                	slli	s1,s1,0xa
    800006b4:	0164e4b3          	or	s1,s1,s6
    800006b8:	0014e493          	ori	s1,s1,1
    800006bc:	e104                	sd	s1,0(a0)
    if(a == last)
    800006be:	05390063          	beq	s2,s3,800006fe <mappages+0x9c>
    a += PGSIZE;
    800006c2:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800006c4:	bfc9                	j	80000696 <mappages+0x34>
    panic("mappages: size");
    800006c6:	00008517          	auipc	a0,0x8
    800006ca:	99250513          	addi	a0,a0,-1646 # 80008058 <etext+0x58>
    800006ce:	00006097          	auipc	ra,0x6
    800006d2:	bc2080e7          	jalr	-1086(ra) # 80006290 <panic>
      panic("mappages: remap");
    800006d6:	00008517          	auipc	a0,0x8
    800006da:	99250513          	addi	a0,a0,-1646 # 80008068 <etext+0x68>
    800006de:	00006097          	auipc	ra,0x6
    800006e2:	bb2080e7          	jalr	-1102(ra) # 80006290 <panic>
      return -1;
    800006e6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800006e8:	60a6                	ld	ra,72(sp)
    800006ea:	6406                	ld	s0,64(sp)
    800006ec:	74e2                	ld	s1,56(sp)
    800006ee:	7942                	ld	s2,48(sp)
    800006f0:	79a2                	ld	s3,40(sp)
    800006f2:	7a02                	ld	s4,32(sp)
    800006f4:	6ae2                	ld	s5,24(sp)
    800006f6:	6b42                	ld	s6,16(sp)
    800006f8:	6ba2                	ld	s7,8(sp)
    800006fa:	6161                	addi	sp,sp,80
    800006fc:	8082                	ret
  return 0;
    800006fe:	4501                	li	a0,0
    80000700:	b7e5                	j	800006e8 <mappages+0x86>

0000000080000702 <kvmmap>:
{
    80000702:	1141                	addi	sp,sp,-16
    80000704:	e406                	sd	ra,8(sp)
    80000706:	e022                	sd	s0,0(sp)
    80000708:	0800                	addi	s0,sp,16
    8000070a:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000070c:	86b2                	mv	a3,a2
    8000070e:	863e                	mv	a2,a5
    80000710:	00000097          	auipc	ra,0x0
    80000714:	f52080e7          	jalr	-174(ra) # 80000662 <mappages>
    80000718:	e509                	bnez	a0,80000722 <kvmmap+0x20>
}
    8000071a:	60a2                	ld	ra,8(sp)
    8000071c:	6402                	ld	s0,0(sp)
    8000071e:	0141                	addi	sp,sp,16
    80000720:	8082                	ret
    panic("kvmmap");
    80000722:	00008517          	auipc	a0,0x8
    80000726:	95650513          	addi	a0,a0,-1706 # 80008078 <etext+0x78>
    8000072a:	00006097          	auipc	ra,0x6
    8000072e:	b66080e7          	jalr	-1178(ra) # 80006290 <panic>

0000000080000732 <kvmmake>:
{
    80000732:	1101                	addi	sp,sp,-32
    80000734:	ec06                	sd	ra,24(sp)
    80000736:	e822                	sd	s0,16(sp)
    80000738:	e426                	sd	s1,8(sp)
    8000073a:	e04a                	sd	s2,0(sp)
    8000073c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000073e:	00000097          	auipc	ra,0x0
    80000742:	a44080e7          	jalr	-1468(ra) # 80000182 <kalloc>
    80000746:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000748:	6605                	lui	a2,0x1
    8000074a:	4581                	li	a1,0
    8000074c:	00000097          	auipc	ra,0x0
    80000750:	b3a080e7          	jalr	-1222(ra) # 80000286 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000754:	4719                	li	a4,6
    80000756:	6685                	lui	a3,0x1
    80000758:	10000637          	lui	a2,0x10000
    8000075c:	100005b7          	lui	a1,0x10000
    80000760:	8526                	mv	a0,s1
    80000762:	00000097          	auipc	ra,0x0
    80000766:	fa0080e7          	jalr	-96(ra) # 80000702 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000076a:	4719                	li	a4,6
    8000076c:	6685                	lui	a3,0x1
    8000076e:	10001637          	lui	a2,0x10001
    80000772:	100015b7          	lui	a1,0x10001
    80000776:	8526                	mv	a0,s1
    80000778:	00000097          	auipc	ra,0x0
    8000077c:	f8a080e7          	jalr	-118(ra) # 80000702 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000780:	4719                	li	a4,6
    80000782:	004006b7          	lui	a3,0x400
    80000786:	0c000637          	lui	a2,0xc000
    8000078a:	0c0005b7          	lui	a1,0xc000
    8000078e:	8526                	mv	a0,s1
    80000790:	00000097          	auipc	ra,0x0
    80000794:	f72080e7          	jalr	-142(ra) # 80000702 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000798:	00008917          	auipc	s2,0x8
    8000079c:	86890913          	addi	s2,s2,-1944 # 80008000 <etext>
    800007a0:	4729                	li	a4,10
    800007a2:	80008697          	auipc	a3,0x80008
    800007a6:	85e68693          	addi	a3,a3,-1954 # 8000 <_entry-0x7fff8000>
    800007aa:	4605                	li	a2,1
    800007ac:	067e                	slli	a2,a2,0x1f
    800007ae:	85b2                	mv	a1,a2
    800007b0:	8526                	mv	a0,s1
    800007b2:	00000097          	auipc	ra,0x0
    800007b6:	f50080e7          	jalr	-176(ra) # 80000702 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800007ba:	4719                	li	a4,6
    800007bc:	46c5                	li	a3,17
    800007be:	06ee                	slli	a3,a3,0x1b
    800007c0:	412686b3          	sub	a3,a3,s2
    800007c4:	864a                	mv	a2,s2
    800007c6:	85ca                	mv	a1,s2
    800007c8:	8526                	mv	a0,s1
    800007ca:	00000097          	auipc	ra,0x0
    800007ce:	f38080e7          	jalr	-200(ra) # 80000702 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800007d2:	4729                	li	a4,10
    800007d4:	6685                	lui	a3,0x1
    800007d6:	00007617          	auipc	a2,0x7
    800007da:	82a60613          	addi	a2,a2,-2006 # 80007000 <_trampoline>
    800007de:	040005b7          	lui	a1,0x4000
    800007e2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800007e4:	05b2                	slli	a1,a1,0xc
    800007e6:	8526                	mv	a0,s1
    800007e8:	00000097          	auipc	ra,0x0
    800007ec:	f1a080e7          	jalr	-230(ra) # 80000702 <kvmmap>
  proc_mapstacks(kpgtbl);
    800007f0:	8526                	mv	a0,s1
    800007f2:	00000097          	auipc	ra,0x0
    800007f6:	608080e7          	jalr	1544(ra) # 80000dfa <proc_mapstacks>
}
    800007fa:	8526                	mv	a0,s1
    800007fc:	60e2                	ld	ra,24(sp)
    800007fe:	6442                	ld	s0,16(sp)
    80000800:	64a2                	ld	s1,8(sp)
    80000802:	6902                	ld	s2,0(sp)
    80000804:	6105                	addi	sp,sp,32
    80000806:	8082                	ret

0000000080000808 <kvminit>:
{
    80000808:	1141                	addi	sp,sp,-16
    8000080a:	e406                	sd	ra,8(sp)
    8000080c:	e022                	sd	s0,0(sp)
    8000080e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000810:	00000097          	auipc	ra,0x0
    80000814:	f22080e7          	jalr	-222(ra) # 80000732 <kvmmake>
    80000818:	00008797          	auipc	a5,0x8
    8000081c:	18a7b023          	sd	a0,384(a5) # 80008998 <kernel_pagetable>
}
    80000820:	60a2                	ld	ra,8(sp)
    80000822:	6402                	ld	s0,0(sp)
    80000824:	0141                	addi	sp,sp,16
    80000826:	8082                	ret

0000000080000828 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000828:	715d                	addi	sp,sp,-80
    8000082a:	e486                	sd	ra,72(sp)
    8000082c:	e0a2                	sd	s0,64(sp)
    8000082e:	fc26                	sd	s1,56(sp)
    80000830:	f84a                	sd	s2,48(sp)
    80000832:	f44e                	sd	s3,40(sp)
    80000834:	f052                	sd	s4,32(sp)
    80000836:	ec56                	sd	s5,24(sp)
    80000838:	e85a                	sd	s6,16(sp)
    8000083a:	e45e                	sd	s7,8(sp)
    8000083c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000083e:	03459793          	slli	a5,a1,0x34
    80000842:	e795                	bnez	a5,8000086e <uvmunmap+0x46>
    80000844:	8a2a                	mv	s4,a0
    80000846:	892e                	mv	s2,a1
    80000848:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000084a:	0632                	slli	a2,a2,0xc
    8000084c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000850:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000852:	6b05                	lui	s6,0x1
    80000854:	0735e263          	bltu	a1,s3,800008b8 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000858:	60a6                	ld	ra,72(sp)
    8000085a:	6406                	ld	s0,64(sp)
    8000085c:	74e2                	ld	s1,56(sp)
    8000085e:	7942                	ld	s2,48(sp)
    80000860:	79a2                	ld	s3,40(sp)
    80000862:	7a02                	ld	s4,32(sp)
    80000864:	6ae2                	ld	s5,24(sp)
    80000866:	6b42                	ld	s6,16(sp)
    80000868:	6ba2                	ld	s7,8(sp)
    8000086a:	6161                	addi	sp,sp,80
    8000086c:	8082                	ret
    panic("uvmunmap: not aligned");
    8000086e:	00008517          	auipc	a0,0x8
    80000872:	81250513          	addi	a0,a0,-2030 # 80008080 <etext+0x80>
    80000876:	00006097          	auipc	ra,0x6
    8000087a:	a1a080e7          	jalr	-1510(ra) # 80006290 <panic>
      panic("uvmunmap: walk");
    8000087e:	00008517          	auipc	a0,0x8
    80000882:	81a50513          	addi	a0,a0,-2022 # 80008098 <etext+0x98>
    80000886:	00006097          	auipc	ra,0x6
    8000088a:	a0a080e7          	jalr	-1526(ra) # 80006290 <panic>
      panic("uvmunmap: not mapped");
    8000088e:	00008517          	auipc	a0,0x8
    80000892:	81a50513          	addi	a0,a0,-2022 # 800080a8 <etext+0xa8>
    80000896:	00006097          	auipc	ra,0x6
    8000089a:	9fa080e7          	jalr	-1542(ra) # 80006290 <panic>
      panic("uvmunmap: not a leaf");
    8000089e:	00008517          	auipc	a0,0x8
    800008a2:	82250513          	addi	a0,a0,-2014 # 800080c0 <etext+0xc0>
    800008a6:	00006097          	auipc	ra,0x6
    800008aa:	9ea080e7          	jalr	-1558(ra) # 80006290 <panic>
    *pte = 0;
    800008ae:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800008b2:	995a                	add	s2,s2,s6
    800008b4:	fb3972e3          	bgeu	s2,s3,80000858 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800008b8:	4601                	li	a2,0
    800008ba:	85ca                	mv	a1,s2
    800008bc:	8552                	mv	a0,s4
    800008be:	00000097          	auipc	ra,0x0
    800008c2:	cbc080e7          	jalr	-836(ra) # 8000057a <walk>
    800008c6:	84aa                	mv	s1,a0
    800008c8:	d95d                	beqz	a0,8000087e <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800008ca:	6108                	ld	a0,0(a0)
    800008cc:	00157793          	andi	a5,a0,1
    800008d0:	dfdd                	beqz	a5,8000088e <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800008d2:	3ff57793          	andi	a5,a0,1023
    800008d6:	fd7784e3          	beq	a5,s7,8000089e <uvmunmap+0x76>
    if(do_free){
    800008da:	fc0a8ae3          	beqz	s5,800008ae <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800008de:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800008e0:	0532                	slli	a0,a0,0xc
    800008e2:	fffff097          	auipc	ra,0xfffff
    800008e6:	73a080e7          	jalr	1850(ra) # 8000001c <kfree>
    800008ea:	b7d1                	j	800008ae <uvmunmap+0x86>

00000000800008ec <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800008ec:	1101                	addi	sp,sp,-32
    800008ee:	ec06                	sd	ra,24(sp)
    800008f0:	e822                	sd	s0,16(sp)
    800008f2:	e426                	sd	s1,8(sp)
    800008f4:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800008f6:	00000097          	auipc	ra,0x0
    800008fa:	88c080e7          	jalr	-1908(ra) # 80000182 <kalloc>
    800008fe:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000900:	c519                	beqz	a0,8000090e <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000902:	6605                	lui	a2,0x1
    80000904:	4581                	li	a1,0
    80000906:	00000097          	auipc	ra,0x0
    8000090a:	980080e7          	jalr	-1664(ra) # 80000286 <memset>
  return pagetable;
}
    8000090e:	8526                	mv	a0,s1
    80000910:	60e2                	ld	ra,24(sp)
    80000912:	6442                	ld	s0,16(sp)
    80000914:	64a2                	ld	s1,8(sp)
    80000916:	6105                	addi	sp,sp,32
    80000918:	8082                	ret

000000008000091a <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000091a:	7179                	addi	sp,sp,-48
    8000091c:	f406                	sd	ra,40(sp)
    8000091e:	f022                	sd	s0,32(sp)
    80000920:	ec26                	sd	s1,24(sp)
    80000922:	e84a                	sd	s2,16(sp)
    80000924:	e44e                	sd	s3,8(sp)
    80000926:	e052                	sd	s4,0(sp)
    80000928:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000092a:	6785                	lui	a5,0x1
    8000092c:	04f67863          	bgeu	a2,a5,8000097c <uvmfirst+0x62>
    80000930:	8a2a                	mv	s4,a0
    80000932:	89ae                	mv	s3,a1
    80000934:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000936:	00000097          	auipc	ra,0x0
    8000093a:	84c080e7          	jalr	-1972(ra) # 80000182 <kalloc>
    8000093e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000940:	6605                	lui	a2,0x1
    80000942:	4581                	li	a1,0
    80000944:	00000097          	auipc	ra,0x0
    80000948:	942080e7          	jalr	-1726(ra) # 80000286 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000094c:	4779                	li	a4,30
    8000094e:	86ca                	mv	a3,s2
    80000950:	6605                	lui	a2,0x1
    80000952:	4581                	li	a1,0
    80000954:	8552                	mv	a0,s4
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	d0c080e7          	jalr	-756(ra) # 80000662 <mappages>
  memmove(mem, src, sz);
    8000095e:	8626                	mv	a2,s1
    80000960:	85ce                	mv	a1,s3
    80000962:	854a                	mv	a0,s2
    80000964:	00000097          	auipc	ra,0x0
    80000968:	97e080e7          	jalr	-1666(ra) # 800002e2 <memmove>
}
    8000096c:	70a2                	ld	ra,40(sp)
    8000096e:	7402                	ld	s0,32(sp)
    80000970:	64e2                	ld	s1,24(sp)
    80000972:	6942                	ld	s2,16(sp)
    80000974:	69a2                	ld	s3,8(sp)
    80000976:	6a02                	ld	s4,0(sp)
    80000978:	6145                	addi	sp,sp,48
    8000097a:	8082                	ret
    panic("uvmfirst: more than a page");
    8000097c:	00007517          	auipc	a0,0x7
    80000980:	75c50513          	addi	a0,a0,1884 # 800080d8 <etext+0xd8>
    80000984:	00006097          	auipc	ra,0x6
    80000988:	90c080e7          	jalr	-1780(ra) # 80006290 <panic>

000000008000098c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000098c:	1101                	addi	sp,sp,-32
    8000098e:	ec06                	sd	ra,24(sp)
    80000990:	e822                	sd	s0,16(sp)
    80000992:	e426                	sd	s1,8(sp)
    80000994:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000996:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000998:	00b67d63          	bgeu	a2,a1,800009b2 <uvmdealloc+0x26>
    8000099c:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000099e:	6785                	lui	a5,0x1
    800009a0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009a2:	00f60733          	add	a4,a2,a5
    800009a6:	76fd                	lui	a3,0xfffff
    800009a8:	8f75                	and	a4,a4,a3
    800009aa:	97ae                	add	a5,a5,a1
    800009ac:	8ff5                	and	a5,a5,a3
    800009ae:	00f76863          	bltu	a4,a5,800009be <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800009b2:	8526                	mv	a0,s1
    800009b4:	60e2                	ld	ra,24(sp)
    800009b6:	6442                	ld	s0,16(sp)
    800009b8:	64a2                	ld	s1,8(sp)
    800009ba:	6105                	addi	sp,sp,32
    800009bc:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800009be:	8f99                	sub	a5,a5,a4
    800009c0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800009c2:	4685                	li	a3,1
    800009c4:	0007861b          	sext.w	a2,a5
    800009c8:	85ba                	mv	a1,a4
    800009ca:	00000097          	auipc	ra,0x0
    800009ce:	e5e080e7          	jalr	-418(ra) # 80000828 <uvmunmap>
    800009d2:	b7c5                	j	800009b2 <uvmdealloc+0x26>

00000000800009d4 <uvmalloc>:
  if(newsz < oldsz)
    800009d4:	0ab66563          	bltu	a2,a1,80000a7e <uvmalloc+0xaa>
{
    800009d8:	7139                	addi	sp,sp,-64
    800009da:	fc06                	sd	ra,56(sp)
    800009dc:	f822                	sd	s0,48(sp)
    800009de:	f426                	sd	s1,40(sp)
    800009e0:	f04a                	sd	s2,32(sp)
    800009e2:	ec4e                	sd	s3,24(sp)
    800009e4:	e852                	sd	s4,16(sp)
    800009e6:	e456                	sd	s5,8(sp)
    800009e8:	e05a                	sd	s6,0(sp)
    800009ea:	0080                	addi	s0,sp,64
    800009ec:	8aaa                	mv	s5,a0
    800009ee:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800009f0:	6785                	lui	a5,0x1
    800009f2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009f4:	95be                	add	a1,a1,a5
    800009f6:	77fd                	lui	a5,0xfffff
    800009f8:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800009fc:	08c9f363          	bgeu	s3,a2,80000a82 <uvmalloc+0xae>
    80000a00:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000a02:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000a06:	fffff097          	auipc	ra,0xfffff
    80000a0a:	77c080e7          	jalr	1916(ra) # 80000182 <kalloc>
    80000a0e:	84aa                	mv	s1,a0
    if(mem == 0){
    80000a10:	c51d                	beqz	a0,80000a3e <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80000a12:	6605                	lui	a2,0x1
    80000a14:	4581                	li	a1,0
    80000a16:	00000097          	auipc	ra,0x0
    80000a1a:	870080e7          	jalr	-1936(ra) # 80000286 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000a1e:	875a                	mv	a4,s6
    80000a20:	86a6                	mv	a3,s1
    80000a22:	6605                	lui	a2,0x1
    80000a24:	85ca                	mv	a1,s2
    80000a26:	8556                	mv	a0,s5
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	c3a080e7          	jalr	-966(ra) # 80000662 <mappages>
    80000a30:	e90d                	bnez	a0,80000a62 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a32:	6785                	lui	a5,0x1
    80000a34:	993e                	add	s2,s2,a5
    80000a36:	fd4968e3          	bltu	s2,s4,80000a06 <uvmalloc+0x32>
  return newsz;
    80000a3a:	8552                	mv	a0,s4
    80000a3c:	a809                	j	80000a4e <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000a3e:	864e                	mv	a2,s3
    80000a40:	85ca                	mv	a1,s2
    80000a42:	8556                	mv	a0,s5
    80000a44:	00000097          	auipc	ra,0x0
    80000a48:	f48080e7          	jalr	-184(ra) # 8000098c <uvmdealloc>
      return 0;
    80000a4c:	4501                	li	a0,0
}
    80000a4e:	70e2                	ld	ra,56(sp)
    80000a50:	7442                	ld	s0,48(sp)
    80000a52:	74a2                	ld	s1,40(sp)
    80000a54:	7902                	ld	s2,32(sp)
    80000a56:	69e2                	ld	s3,24(sp)
    80000a58:	6a42                	ld	s4,16(sp)
    80000a5a:	6aa2                	ld	s5,8(sp)
    80000a5c:	6b02                	ld	s6,0(sp)
    80000a5e:	6121                	addi	sp,sp,64
    80000a60:	8082                	ret
      kfree(mem);
    80000a62:	8526                	mv	a0,s1
    80000a64:	fffff097          	auipc	ra,0xfffff
    80000a68:	5b8080e7          	jalr	1464(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a6c:	864e                	mv	a2,s3
    80000a6e:	85ca                	mv	a1,s2
    80000a70:	8556                	mv	a0,s5
    80000a72:	00000097          	auipc	ra,0x0
    80000a76:	f1a080e7          	jalr	-230(ra) # 8000098c <uvmdealloc>
      return 0;
    80000a7a:	4501                	li	a0,0
    80000a7c:	bfc9                	j	80000a4e <uvmalloc+0x7a>
    return oldsz;
    80000a7e:	852e                	mv	a0,a1
}
    80000a80:	8082                	ret
  return newsz;
    80000a82:	8532                	mv	a0,a2
    80000a84:	b7e9                	j	80000a4e <uvmalloc+0x7a>

0000000080000a86 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000a86:	7179                	addi	sp,sp,-48
    80000a88:	f406                	sd	ra,40(sp)
    80000a8a:	f022                	sd	s0,32(sp)
    80000a8c:	ec26                	sd	s1,24(sp)
    80000a8e:	e84a                	sd	s2,16(sp)
    80000a90:	e44e                	sd	s3,8(sp)
    80000a92:	e052                	sd	s4,0(sp)
    80000a94:	1800                	addi	s0,sp,48
    80000a96:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000a98:	84aa                	mv	s1,a0
    80000a9a:	6905                	lui	s2,0x1
    80000a9c:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a9e:	4985                	li	s3,1
    80000aa0:	a829                	j	80000aba <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000aa2:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000aa4:	00c79513          	slli	a0,a5,0xc
    80000aa8:	00000097          	auipc	ra,0x0
    80000aac:	fde080e7          	jalr	-34(ra) # 80000a86 <freewalk>
      pagetable[i] = 0;
    80000ab0:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000ab4:	04a1                	addi	s1,s1,8
    80000ab6:	03248163          	beq	s1,s2,80000ad8 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000aba:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000abc:	00f7f713          	andi	a4,a5,15
    80000ac0:	ff3701e3          	beq	a4,s3,80000aa2 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000ac4:	8b85                	andi	a5,a5,1
    80000ac6:	d7fd                	beqz	a5,80000ab4 <freewalk+0x2e>
      panic("freewalk: leaf");
    80000ac8:	00007517          	auipc	a0,0x7
    80000acc:	63050513          	addi	a0,a0,1584 # 800080f8 <etext+0xf8>
    80000ad0:	00005097          	auipc	ra,0x5
    80000ad4:	7c0080e7          	jalr	1984(ra) # 80006290 <panic>
    }
  }
  kfree((void*)pagetable);
    80000ad8:	8552                	mv	a0,s4
    80000ada:	fffff097          	auipc	ra,0xfffff
    80000ade:	542080e7          	jalr	1346(ra) # 8000001c <kfree>
}
    80000ae2:	70a2                	ld	ra,40(sp)
    80000ae4:	7402                	ld	s0,32(sp)
    80000ae6:	64e2                	ld	s1,24(sp)
    80000ae8:	6942                	ld	s2,16(sp)
    80000aea:	69a2                	ld	s3,8(sp)
    80000aec:	6a02                	ld	s4,0(sp)
    80000aee:	6145                	addi	sp,sp,48
    80000af0:	8082                	ret

0000000080000af2 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000af2:	1101                	addi	sp,sp,-32
    80000af4:	ec06                	sd	ra,24(sp)
    80000af6:	e822                	sd	s0,16(sp)
    80000af8:	e426                	sd	s1,8(sp)
    80000afa:	1000                	addi	s0,sp,32
    80000afc:	84aa                	mv	s1,a0
  if(sz > 0)
    80000afe:	e999                	bnez	a1,80000b14 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000b00:	8526                	mv	a0,s1
    80000b02:	00000097          	auipc	ra,0x0
    80000b06:	f84080e7          	jalr	-124(ra) # 80000a86 <freewalk>
}
    80000b0a:	60e2                	ld	ra,24(sp)
    80000b0c:	6442                	ld	s0,16(sp)
    80000b0e:	64a2                	ld	s1,8(sp)
    80000b10:	6105                	addi	sp,sp,32
    80000b12:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000b14:	6785                	lui	a5,0x1
    80000b16:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000b18:	95be                	add	a1,a1,a5
    80000b1a:	4685                	li	a3,1
    80000b1c:	00c5d613          	srli	a2,a1,0xc
    80000b20:	4581                	li	a1,0
    80000b22:	00000097          	auipc	ra,0x0
    80000b26:	d06080e7          	jalr	-762(ra) # 80000828 <uvmunmap>
    80000b2a:	bfd9                	j	80000b00 <uvmfree+0xe>

0000000080000b2c <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000b2c:	c679                	beqz	a2,80000bfa <uvmcopy+0xce>
{
    80000b2e:	715d                	addi	sp,sp,-80
    80000b30:	e486                	sd	ra,72(sp)
    80000b32:	e0a2                	sd	s0,64(sp)
    80000b34:	fc26                	sd	s1,56(sp)
    80000b36:	f84a                	sd	s2,48(sp)
    80000b38:	f44e                	sd	s3,40(sp)
    80000b3a:	f052                	sd	s4,32(sp)
    80000b3c:	ec56                	sd	s5,24(sp)
    80000b3e:	e85a                	sd	s6,16(sp)
    80000b40:	e45e                	sd	s7,8(sp)
    80000b42:	0880                	addi	s0,sp,80
    80000b44:	8b2a                	mv	s6,a0
    80000b46:	8aae                	mv	s5,a1
    80000b48:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000b4a:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000b4c:	4601                	li	a2,0
    80000b4e:	85ce                	mv	a1,s3
    80000b50:	855a                	mv	a0,s6
    80000b52:	00000097          	auipc	ra,0x0
    80000b56:	a28080e7          	jalr	-1496(ra) # 8000057a <walk>
    80000b5a:	c531                	beqz	a0,80000ba6 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000b5c:	6118                	ld	a4,0(a0)
    80000b5e:	00177793          	andi	a5,a4,1
    80000b62:	cbb1                	beqz	a5,80000bb6 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000b64:	00a75593          	srli	a1,a4,0xa
    80000b68:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000b6c:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000b70:	fffff097          	auipc	ra,0xfffff
    80000b74:	612080e7          	jalr	1554(ra) # 80000182 <kalloc>
    80000b78:	892a                	mv	s2,a0
    80000b7a:	c939                	beqz	a0,80000bd0 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000b7c:	6605                	lui	a2,0x1
    80000b7e:	85de                	mv	a1,s7
    80000b80:	fffff097          	auipc	ra,0xfffff
    80000b84:	762080e7          	jalr	1890(ra) # 800002e2 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000b88:	8726                	mv	a4,s1
    80000b8a:	86ca                	mv	a3,s2
    80000b8c:	6605                	lui	a2,0x1
    80000b8e:	85ce                	mv	a1,s3
    80000b90:	8556                	mv	a0,s5
    80000b92:	00000097          	auipc	ra,0x0
    80000b96:	ad0080e7          	jalr	-1328(ra) # 80000662 <mappages>
    80000b9a:	e515                	bnez	a0,80000bc6 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000b9c:	6785                	lui	a5,0x1
    80000b9e:	99be                	add	s3,s3,a5
    80000ba0:	fb49e6e3          	bltu	s3,s4,80000b4c <uvmcopy+0x20>
    80000ba4:	a081                	j	80000be4 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ba6:	00007517          	auipc	a0,0x7
    80000baa:	56250513          	addi	a0,a0,1378 # 80008108 <etext+0x108>
    80000bae:	00005097          	auipc	ra,0x5
    80000bb2:	6e2080e7          	jalr	1762(ra) # 80006290 <panic>
      panic("uvmcopy: page not present");
    80000bb6:	00007517          	auipc	a0,0x7
    80000bba:	57250513          	addi	a0,a0,1394 # 80008128 <etext+0x128>
    80000bbe:	00005097          	auipc	ra,0x5
    80000bc2:	6d2080e7          	jalr	1746(ra) # 80006290 <panic>
      kfree(mem);
    80000bc6:	854a                	mv	a0,s2
    80000bc8:	fffff097          	auipc	ra,0xfffff
    80000bcc:	454080e7          	jalr	1108(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000bd0:	4685                	li	a3,1
    80000bd2:	00c9d613          	srli	a2,s3,0xc
    80000bd6:	4581                	li	a1,0
    80000bd8:	8556                	mv	a0,s5
    80000bda:	00000097          	auipc	ra,0x0
    80000bde:	c4e080e7          	jalr	-946(ra) # 80000828 <uvmunmap>
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
    80000bf6:	6161                	addi	sp,sp,80
    80000bf8:	8082                	ret
  return 0;
    80000bfa:	4501                	li	a0,0
}
    80000bfc:	8082                	ret

0000000080000bfe <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000bfe:	1141                	addi	sp,sp,-16
    80000c00:	e406                	sd	ra,8(sp)
    80000c02:	e022                	sd	s0,0(sp)
    80000c04:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000c06:	4601                	li	a2,0
    80000c08:	00000097          	auipc	ra,0x0
    80000c0c:	972080e7          	jalr	-1678(ra) # 8000057a <walk>
  if(pte == 0)
    80000c10:	c901                	beqz	a0,80000c20 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000c12:	611c                	ld	a5,0(a0)
    80000c14:	9bbd                	andi	a5,a5,-17
    80000c16:	e11c                	sd	a5,0(a0)
}
    80000c18:	60a2                	ld	ra,8(sp)
    80000c1a:	6402                	ld	s0,0(sp)
    80000c1c:	0141                	addi	sp,sp,16
    80000c1e:	8082                	ret
    panic("uvmclear");
    80000c20:	00007517          	auipc	a0,0x7
    80000c24:	52850513          	addi	a0,a0,1320 # 80008148 <etext+0x148>
    80000c28:	00005097          	auipc	ra,0x5
    80000c2c:	668080e7          	jalr	1640(ra) # 80006290 <panic>

0000000080000c30 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c30:	c6bd                	beqz	a3,80000c9e <copyout+0x6e>
{
    80000c32:	715d                	addi	sp,sp,-80
    80000c34:	e486                	sd	ra,72(sp)
    80000c36:	e0a2                	sd	s0,64(sp)
    80000c38:	fc26                	sd	s1,56(sp)
    80000c3a:	f84a                	sd	s2,48(sp)
    80000c3c:	f44e                	sd	s3,40(sp)
    80000c3e:	f052                	sd	s4,32(sp)
    80000c40:	ec56                	sd	s5,24(sp)
    80000c42:	e85a                	sd	s6,16(sp)
    80000c44:	e45e                	sd	s7,8(sp)
    80000c46:	e062                	sd	s8,0(sp)
    80000c48:	0880                	addi	s0,sp,80
    80000c4a:	8b2a                	mv	s6,a0
    80000c4c:	8c2e                	mv	s8,a1
    80000c4e:	8a32                	mv	s4,a2
    80000c50:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000c52:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000c54:	6a85                	lui	s5,0x1
    80000c56:	a015                	j	80000c7a <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c58:	9562                	add	a0,a0,s8
    80000c5a:	0004861b          	sext.w	a2,s1
    80000c5e:	85d2                	mv	a1,s4
    80000c60:	41250533          	sub	a0,a0,s2
    80000c64:	fffff097          	auipc	ra,0xfffff
    80000c68:	67e080e7          	jalr	1662(ra) # 800002e2 <memmove>

    len -= n;
    80000c6c:	409989b3          	sub	s3,s3,s1
    src += n;
    80000c70:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000c72:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c76:	02098263          	beqz	s3,80000c9a <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000c7a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c7e:	85ca                	mv	a1,s2
    80000c80:	855a                	mv	a0,s6
    80000c82:	00000097          	auipc	ra,0x0
    80000c86:	99e080e7          	jalr	-1634(ra) # 80000620 <walkaddr>
    if(pa0 == 0)
    80000c8a:	cd01                	beqz	a0,80000ca2 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000c8c:	418904b3          	sub	s1,s2,s8
    80000c90:	94d6                	add	s1,s1,s5
    80000c92:	fc99f3e3          	bgeu	s3,s1,80000c58 <copyout+0x28>
    80000c96:	84ce                	mv	s1,s3
    80000c98:	b7c1                	j	80000c58 <copyout+0x28>
  }
  return 0;
    80000c9a:	4501                	li	a0,0
    80000c9c:	a021                	j	80000ca4 <copyout+0x74>
    80000c9e:	4501                	li	a0,0
}
    80000ca0:	8082                	ret
      return -1;
    80000ca2:	557d                	li	a0,-1
}
    80000ca4:	60a6                	ld	ra,72(sp)
    80000ca6:	6406                	ld	s0,64(sp)
    80000ca8:	74e2                	ld	s1,56(sp)
    80000caa:	7942                	ld	s2,48(sp)
    80000cac:	79a2                	ld	s3,40(sp)
    80000cae:	7a02                	ld	s4,32(sp)
    80000cb0:	6ae2                	ld	s5,24(sp)
    80000cb2:	6b42                	ld	s6,16(sp)
    80000cb4:	6ba2                	ld	s7,8(sp)
    80000cb6:	6c02                	ld	s8,0(sp)
    80000cb8:	6161                	addi	sp,sp,80
    80000cba:	8082                	ret

0000000080000cbc <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000cbc:	caa5                	beqz	a3,80000d2c <copyin+0x70>
{
    80000cbe:	715d                	addi	sp,sp,-80
    80000cc0:	e486                	sd	ra,72(sp)
    80000cc2:	e0a2                	sd	s0,64(sp)
    80000cc4:	fc26                	sd	s1,56(sp)
    80000cc6:	f84a                	sd	s2,48(sp)
    80000cc8:	f44e                	sd	s3,40(sp)
    80000cca:	f052                	sd	s4,32(sp)
    80000ccc:	ec56                	sd	s5,24(sp)
    80000cce:	e85a                	sd	s6,16(sp)
    80000cd0:	e45e                	sd	s7,8(sp)
    80000cd2:	e062                	sd	s8,0(sp)
    80000cd4:	0880                	addi	s0,sp,80
    80000cd6:	8b2a                	mv	s6,a0
    80000cd8:	8a2e                	mv	s4,a1
    80000cda:	8c32                	mv	s8,a2
    80000cdc:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000cde:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ce0:	6a85                	lui	s5,0x1
    80000ce2:	a01d                	j	80000d08 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000ce4:	018505b3          	add	a1,a0,s8
    80000ce8:	0004861b          	sext.w	a2,s1
    80000cec:	412585b3          	sub	a1,a1,s2
    80000cf0:	8552                	mv	a0,s4
    80000cf2:	fffff097          	auipc	ra,0xfffff
    80000cf6:	5f0080e7          	jalr	1520(ra) # 800002e2 <memmove>

    len -= n;
    80000cfa:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000cfe:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000d00:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000d04:	02098263          	beqz	s3,80000d28 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000d08:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000d0c:	85ca                	mv	a1,s2
    80000d0e:	855a                	mv	a0,s6
    80000d10:	00000097          	auipc	ra,0x0
    80000d14:	910080e7          	jalr	-1776(ra) # 80000620 <walkaddr>
    if(pa0 == 0)
    80000d18:	cd01                	beqz	a0,80000d30 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000d1a:	418904b3          	sub	s1,s2,s8
    80000d1e:	94d6                	add	s1,s1,s5
    80000d20:	fc99f2e3          	bgeu	s3,s1,80000ce4 <copyin+0x28>
    80000d24:	84ce                	mv	s1,s3
    80000d26:	bf7d                	j	80000ce4 <copyin+0x28>
  }
  return 0;
    80000d28:	4501                	li	a0,0
    80000d2a:	a021                	j	80000d32 <copyin+0x76>
    80000d2c:	4501                	li	a0,0
}
    80000d2e:	8082                	ret
      return -1;
    80000d30:	557d                	li	a0,-1
}
    80000d32:	60a6                	ld	ra,72(sp)
    80000d34:	6406                	ld	s0,64(sp)
    80000d36:	74e2                	ld	s1,56(sp)
    80000d38:	7942                	ld	s2,48(sp)
    80000d3a:	79a2                	ld	s3,40(sp)
    80000d3c:	7a02                	ld	s4,32(sp)
    80000d3e:	6ae2                	ld	s5,24(sp)
    80000d40:	6b42                	ld	s6,16(sp)
    80000d42:	6ba2                	ld	s7,8(sp)
    80000d44:	6c02                	ld	s8,0(sp)
    80000d46:	6161                	addi	sp,sp,80
    80000d48:	8082                	ret

0000000080000d4a <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000d4a:	c2dd                	beqz	a3,80000df0 <copyinstr+0xa6>
{
    80000d4c:	715d                	addi	sp,sp,-80
    80000d4e:	e486                	sd	ra,72(sp)
    80000d50:	e0a2                	sd	s0,64(sp)
    80000d52:	fc26                	sd	s1,56(sp)
    80000d54:	f84a                	sd	s2,48(sp)
    80000d56:	f44e                	sd	s3,40(sp)
    80000d58:	f052                	sd	s4,32(sp)
    80000d5a:	ec56                	sd	s5,24(sp)
    80000d5c:	e85a                	sd	s6,16(sp)
    80000d5e:	e45e                	sd	s7,8(sp)
    80000d60:	0880                	addi	s0,sp,80
    80000d62:	8a2a                	mv	s4,a0
    80000d64:	8b2e                	mv	s6,a1
    80000d66:	8bb2                	mv	s7,a2
    80000d68:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000d6a:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d6c:	6985                	lui	s3,0x1
    80000d6e:	a02d                	j	80000d98 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000d70:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000d74:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000d76:	37fd                	addiw	a5,a5,-1
    80000d78:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000d7c:	60a6                	ld	ra,72(sp)
    80000d7e:	6406                	ld	s0,64(sp)
    80000d80:	74e2                	ld	s1,56(sp)
    80000d82:	7942                	ld	s2,48(sp)
    80000d84:	79a2                	ld	s3,40(sp)
    80000d86:	7a02                	ld	s4,32(sp)
    80000d88:	6ae2                	ld	s5,24(sp)
    80000d8a:	6b42                	ld	s6,16(sp)
    80000d8c:	6ba2                	ld	s7,8(sp)
    80000d8e:	6161                	addi	sp,sp,80
    80000d90:	8082                	ret
    srcva = va0 + PGSIZE;
    80000d92:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000d96:	c8a9                	beqz	s1,80000de8 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000d98:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d9c:	85ca                	mv	a1,s2
    80000d9e:	8552                	mv	a0,s4
    80000da0:	00000097          	auipc	ra,0x0
    80000da4:	880080e7          	jalr	-1920(ra) # 80000620 <walkaddr>
    if(pa0 == 0)
    80000da8:	c131                	beqz	a0,80000dec <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000daa:	417906b3          	sub	a3,s2,s7
    80000dae:	96ce                	add	a3,a3,s3
    80000db0:	00d4f363          	bgeu	s1,a3,80000db6 <copyinstr+0x6c>
    80000db4:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000db6:	955e                	add	a0,a0,s7
    80000db8:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000dbc:	daf9                	beqz	a3,80000d92 <copyinstr+0x48>
    80000dbe:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000dc0:	41650633          	sub	a2,a0,s6
    80000dc4:	fff48593          	addi	a1,s1,-1
    80000dc8:	95da                	add	a1,a1,s6
    while(n > 0){
    80000dca:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000dcc:	00f60733          	add	a4,a2,a5
    80000dd0:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd7468>
    80000dd4:	df51                	beqz	a4,80000d70 <copyinstr+0x26>
        *dst = *p;
    80000dd6:	00e78023          	sb	a4,0(a5)
      --max;
    80000dda:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000dde:	0785                	addi	a5,a5,1
    while(n > 0){
    80000de0:	fed796e3          	bne	a5,a3,80000dcc <copyinstr+0x82>
      dst++;
    80000de4:	8b3e                	mv	s6,a5
    80000de6:	b775                	j	80000d92 <copyinstr+0x48>
    80000de8:	4781                	li	a5,0
    80000dea:	b771                	j	80000d76 <copyinstr+0x2c>
      return -1;
    80000dec:	557d                	li	a0,-1
    80000dee:	b779                	j	80000d7c <copyinstr+0x32>
  int got_null = 0;
    80000df0:	4781                	li	a5,0
  if(got_null){
    80000df2:	37fd                	addiw	a5,a5,-1
    80000df4:	0007851b          	sext.w	a0,a5
}
    80000df8:	8082                	ret

0000000080000dfa <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000dfa:	7139                	addi	sp,sp,-64
    80000dfc:	fc06                	sd	ra,56(sp)
    80000dfe:	f822                	sd	s0,48(sp)
    80000e00:	f426                	sd	s1,40(sp)
    80000e02:	f04a                	sd	s2,32(sp)
    80000e04:	ec4e                	sd	s3,24(sp)
    80000e06:	e852                	sd	s4,16(sp)
    80000e08:	e456                	sd	s5,8(sp)
    80000e0a:	e05a                	sd	s6,0(sp)
    80000e0c:	0080                	addi	s0,sp,64
    80000e0e:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e10:	00008497          	auipc	s1,0x8
    80000e14:	13048493          	addi	s1,s1,304 # 80008f40 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e18:	8b26                	mv	s6,s1
    80000e1a:	00007a97          	auipc	s5,0x7
    80000e1e:	1e6a8a93          	addi	s5,s5,486 # 80008000 <etext>
    80000e22:	04000937          	lui	s2,0x4000
    80000e26:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000e28:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e2a:	0000ea17          	auipc	s4,0xe
    80000e2e:	d16a0a13          	addi	s4,s4,-746 # 8000eb40 <tickslock>
    char *pa = kalloc();
    80000e32:	fffff097          	auipc	ra,0xfffff
    80000e36:	350080e7          	jalr	848(ra) # 80000182 <kalloc>
    80000e3a:	862a                	mv	a2,a0
    if(pa == 0)
    80000e3c:	c131                	beqz	a0,80000e80 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000e3e:	416485b3          	sub	a1,s1,s6
    80000e42:	8591                	srai	a1,a1,0x4
    80000e44:	000ab783          	ld	a5,0(s5)
    80000e48:	02f585b3          	mul	a1,a1,a5
    80000e4c:	2585                	addiw	a1,a1,1
    80000e4e:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e52:	4719                	li	a4,6
    80000e54:	6685                	lui	a3,0x1
    80000e56:	40b905b3          	sub	a1,s2,a1
    80000e5a:	854e                	mv	a0,s3
    80000e5c:	00000097          	auipc	ra,0x0
    80000e60:	8a6080e7          	jalr	-1882(ra) # 80000702 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e64:	17048493          	addi	s1,s1,368
    80000e68:	fd4495e3          	bne	s1,s4,80000e32 <proc_mapstacks+0x38>
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
      panic("kalloc");
    80000e80:	00007517          	auipc	a0,0x7
    80000e84:	2d850513          	addi	a0,a0,728 # 80008158 <etext+0x158>
    80000e88:	00005097          	auipc	ra,0x5
    80000e8c:	408080e7          	jalr	1032(ra) # 80006290 <panic>

0000000080000e90 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000e90:	7139                	addi	sp,sp,-64
    80000e92:	fc06                	sd	ra,56(sp)
    80000e94:	f822                	sd	s0,48(sp)
    80000e96:	f426                	sd	s1,40(sp)
    80000e98:	f04a                	sd	s2,32(sp)
    80000e9a:	ec4e                	sd	s3,24(sp)
    80000e9c:	e852                	sd	s4,16(sp)
    80000e9e:	e456                	sd	s5,8(sp)
    80000ea0:	e05a                	sd	s6,0(sp)
    80000ea2:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000ea4:	00007597          	auipc	a1,0x7
    80000ea8:	2bc58593          	addi	a1,a1,700 # 80008160 <etext+0x160>
    80000eac:	00008517          	auipc	a0,0x8
    80000eb0:	c5450513          	addi	a0,a0,-940 # 80008b00 <pid_lock>
    80000eb4:	00006097          	auipc	ra,0x6
    80000eb8:	a7a080e7          	jalr	-1414(ra) # 8000692e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ebc:	00007597          	auipc	a1,0x7
    80000ec0:	2ac58593          	addi	a1,a1,684 # 80008168 <etext+0x168>
    80000ec4:	00008517          	auipc	a0,0x8
    80000ec8:	c5c50513          	addi	a0,a0,-932 # 80008b20 <wait_lock>
    80000ecc:	00006097          	auipc	ra,0x6
    80000ed0:	a62080e7          	jalr	-1438(ra) # 8000692e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ed4:	00008497          	auipc	s1,0x8
    80000ed8:	06c48493          	addi	s1,s1,108 # 80008f40 <proc>
      initlock(&p->lock, "proc");
    80000edc:	00007b17          	auipc	s6,0x7
    80000ee0:	29cb0b13          	addi	s6,s6,668 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000ee4:	8aa6                	mv	s5,s1
    80000ee6:	00007a17          	auipc	s4,0x7
    80000eea:	11aa0a13          	addi	s4,s4,282 # 80008000 <etext>
    80000eee:	04000937          	lui	s2,0x4000
    80000ef2:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000ef4:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ef6:	0000e997          	auipc	s3,0xe
    80000efa:	c4a98993          	addi	s3,s3,-950 # 8000eb40 <tickslock>
      initlock(&p->lock, "proc");
    80000efe:	85da                	mv	a1,s6
    80000f00:	8526                	mv	a0,s1
    80000f02:	00006097          	auipc	ra,0x6
    80000f06:	a2c080e7          	jalr	-1492(ra) # 8000692e <initlock>
      p->state = UNUSED;
    80000f0a:	0204a023          	sw	zero,32(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000f0e:	415487b3          	sub	a5,s1,s5
    80000f12:	8791                	srai	a5,a5,0x4
    80000f14:	000a3703          	ld	a4,0(s4)
    80000f18:	02e787b3          	mul	a5,a5,a4
    80000f1c:	2785                	addiw	a5,a5,1
    80000f1e:	00d7979b          	slliw	a5,a5,0xd
    80000f22:	40f907b3          	sub	a5,s2,a5
    80000f26:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f28:	17048493          	addi	s1,s1,368
    80000f2c:	fd3499e3          	bne	s1,s3,80000efe <procinit+0x6e>
  }
}
    80000f30:	70e2                	ld	ra,56(sp)
    80000f32:	7442                	ld	s0,48(sp)
    80000f34:	74a2                	ld	s1,40(sp)
    80000f36:	7902                	ld	s2,32(sp)
    80000f38:	69e2                	ld	s3,24(sp)
    80000f3a:	6a42                	ld	s4,16(sp)
    80000f3c:	6aa2                	ld	s5,8(sp)
    80000f3e:	6b02                	ld	s6,0(sp)
    80000f40:	6121                	addi	sp,sp,64
    80000f42:	8082                	ret

0000000080000f44 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f44:	1141                	addi	sp,sp,-16
    80000f46:	e422                	sd	s0,8(sp)
    80000f48:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f4a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f4c:	2501                	sext.w	a0,a0
    80000f4e:	6422                	ld	s0,8(sp)
    80000f50:	0141                	addi	sp,sp,16
    80000f52:	8082                	ret

0000000080000f54 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000f54:	1141                	addi	sp,sp,-16
    80000f56:	e422                	sd	s0,8(sp)
    80000f58:	0800                	addi	s0,sp,16
    80000f5a:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f5c:	2781                	sext.w	a5,a5
    80000f5e:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f60:	00008517          	auipc	a0,0x8
    80000f64:	be050513          	addi	a0,a0,-1056 # 80008b40 <cpus>
    80000f68:	953e                	add	a0,a0,a5
    80000f6a:	6422                	ld	s0,8(sp)
    80000f6c:	0141                	addi	sp,sp,16
    80000f6e:	8082                	ret

0000000080000f70 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000f70:	1101                	addi	sp,sp,-32
    80000f72:	ec06                	sd	ra,24(sp)
    80000f74:	e822                	sd	s0,16(sp)
    80000f76:	e426                	sd	s1,8(sp)
    80000f78:	1000                	addi	s0,sp,32
  push_off();
    80000f7a:	00005097          	auipc	ra,0x5
    80000f7e:	7ec080e7          	jalr	2028(ra) # 80006766 <push_off>
    80000f82:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f84:	2781                	sext.w	a5,a5
    80000f86:	079e                	slli	a5,a5,0x7
    80000f88:	00008717          	auipc	a4,0x8
    80000f8c:	b7870713          	addi	a4,a4,-1160 # 80008b00 <pid_lock>
    80000f90:	97ba                	add	a5,a5,a4
    80000f92:	63a4                	ld	s1,64(a5)
  pop_off();
    80000f94:	00006097          	auipc	ra,0x6
    80000f98:	88e080e7          	jalr	-1906(ra) # 80006822 <pop_off>
  return p;
}
    80000f9c:	8526                	mv	a0,s1
    80000f9e:	60e2                	ld	ra,24(sp)
    80000fa0:	6442                	ld	s0,16(sp)
    80000fa2:	64a2                	ld	s1,8(sp)
    80000fa4:	6105                	addi	sp,sp,32
    80000fa6:	8082                	ret

0000000080000fa8 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000fa8:	1141                	addi	sp,sp,-16
    80000faa:	e406                	sd	ra,8(sp)
    80000fac:	e022                	sd	s0,0(sp)
    80000fae:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000fb0:	00000097          	auipc	ra,0x0
    80000fb4:	fc0080e7          	jalr	-64(ra) # 80000f70 <myproc>
    80000fb8:	00006097          	auipc	ra,0x6
    80000fbc:	8ca080e7          	jalr	-1846(ra) # 80006882 <release>

  if (first) {
    80000fc0:	00008797          	auipc	a5,0x8
    80000fc4:	9607a783          	lw	a5,-1696(a5) # 80008920 <first.1>
    80000fc8:	eb89                	bnez	a5,80000fda <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000fca:	00001097          	auipc	ra,0x1
    80000fce:	c5c080e7          	jalr	-932(ra) # 80001c26 <usertrapret>
}
    80000fd2:	60a2                	ld	ra,8(sp)
    80000fd4:	6402                	ld	s0,0(sp)
    80000fd6:	0141                	addi	sp,sp,16
    80000fd8:	8082                	ret
    first = 0;
    80000fda:	00008797          	auipc	a5,0x8
    80000fde:	9407a323          	sw	zero,-1722(a5) # 80008920 <first.1>
    fsinit(ROOTDEV);
    80000fe2:	4505                	li	a0,1
    80000fe4:	00002097          	auipc	ra,0x2
    80000fe8:	c26080e7          	jalr	-986(ra) # 80002c0a <fsinit>
    80000fec:	bff9                	j	80000fca <forkret+0x22>

0000000080000fee <allocpid>:
{
    80000fee:	1101                	addi	sp,sp,-32
    80000ff0:	ec06                	sd	ra,24(sp)
    80000ff2:	e822                	sd	s0,16(sp)
    80000ff4:	e426                	sd	s1,8(sp)
    80000ff6:	e04a                	sd	s2,0(sp)
    80000ff8:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ffa:	00008917          	auipc	s2,0x8
    80000ffe:	b0690913          	addi	s2,s2,-1274 # 80008b00 <pid_lock>
    80001002:	854a                	mv	a0,s2
    80001004:	00005097          	auipc	ra,0x5
    80001008:	7ae080e7          	jalr	1966(ra) # 800067b2 <acquire>
  pid = nextpid;
    8000100c:	00008797          	auipc	a5,0x8
    80001010:	91878793          	addi	a5,a5,-1768 # 80008924 <nextpid>
    80001014:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001016:	0014871b          	addiw	a4,s1,1
    8000101a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000101c:	854a                	mv	a0,s2
    8000101e:	00006097          	auipc	ra,0x6
    80001022:	864080e7          	jalr	-1948(ra) # 80006882 <release>
}
    80001026:	8526                	mv	a0,s1
    80001028:	60e2                	ld	ra,24(sp)
    8000102a:	6442                	ld	s0,16(sp)
    8000102c:	64a2                	ld	s1,8(sp)
    8000102e:	6902                	ld	s2,0(sp)
    80001030:	6105                	addi	sp,sp,32
    80001032:	8082                	ret

0000000080001034 <proc_pagetable>:
{
    80001034:	1101                	addi	sp,sp,-32
    80001036:	ec06                	sd	ra,24(sp)
    80001038:	e822                	sd	s0,16(sp)
    8000103a:	e426                	sd	s1,8(sp)
    8000103c:	e04a                	sd	s2,0(sp)
    8000103e:	1000                	addi	s0,sp,32
    80001040:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001042:	00000097          	auipc	ra,0x0
    80001046:	8aa080e7          	jalr	-1878(ra) # 800008ec <uvmcreate>
    8000104a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000104c:	c121                	beqz	a0,8000108c <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000104e:	4729                	li	a4,10
    80001050:	00006697          	auipc	a3,0x6
    80001054:	fb068693          	addi	a3,a3,-80 # 80007000 <_trampoline>
    80001058:	6605                	lui	a2,0x1
    8000105a:	040005b7          	lui	a1,0x4000
    8000105e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001060:	05b2                	slli	a1,a1,0xc
    80001062:	fffff097          	auipc	ra,0xfffff
    80001066:	600080e7          	jalr	1536(ra) # 80000662 <mappages>
    8000106a:	02054863          	bltz	a0,8000109a <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000106e:	4719                	li	a4,6
    80001070:	06093683          	ld	a3,96(s2)
    80001074:	6605                	lui	a2,0x1
    80001076:	020005b7          	lui	a1,0x2000
    8000107a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000107c:	05b6                	slli	a1,a1,0xd
    8000107e:	8526                	mv	a0,s1
    80001080:	fffff097          	auipc	ra,0xfffff
    80001084:	5e2080e7          	jalr	1506(ra) # 80000662 <mappages>
    80001088:	02054163          	bltz	a0,800010aa <proc_pagetable+0x76>
}
    8000108c:	8526                	mv	a0,s1
    8000108e:	60e2                	ld	ra,24(sp)
    80001090:	6442                	ld	s0,16(sp)
    80001092:	64a2                	ld	s1,8(sp)
    80001094:	6902                	ld	s2,0(sp)
    80001096:	6105                	addi	sp,sp,32
    80001098:	8082                	ret
    uvmfree(pagetable, 0);
    8000109a:	4581                	li	a1,0
    8000109c:	8526                	mv	a0,s1
    8000109e:	00000097          	auipc	ra,0x0
    800010a2:	a54080e7          	jalr	-1452(ra) # 80000af2 <uvmfree>
    return 0;
    800010a6:	4481                	li	s1,0
    800010a8:	b7d5                	j	8000108c <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010aa:	4681                	li	a3,0
    800010ac:	4605                	li	a2,1
    800010ae:	040005b7          	lui	a1,0x4000
    800010b2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010b4:	05b2                	slli	a1,a1,0xc
    800010b6:	8526                	mv	a0,s1
    800010b8:	fffff097          	auipc	ra,0xfffff
    800010bc:	770080e7          	jalr	1904(ra) # 80000828 <uvmunmap>
    uvmfree(pagetable, 0);
    800010c0:	4581                	li	a1,0
    800010c2:	8526                	mv	a0,s1
    800010c4:	00000097          	auipc	ra,0x0
    800010c8:	a2e080e7          	jalr	-1490(ra) # 80000af2 <uvmfree>
    return 0;
    800010cc:	4481                	li	s1,0
    800010ce:	bf7d                	j	8000108c <proc_pagetable+0x58>

00000000800010d0 <proc_freepagetable>:
{
    800010d0:	1101                	addi	sp,sp,-32
    800010d2:	ec06                	sd	ra,24(sp)
    800010d4:	e822                	sd	s0,16(sp)
    800010d6:	e426                	sd	s1,8(sp)
    800010d8:	e04a                	sd	s2,0(sp)
    800010da:	1000                	addi	s0,sp,32
    800010dc:	84aa                	mv	s1,a0
    800010de:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010e0:	4681                	li	a3,0
    800010e2:	4605                	li	a2,1
    800010e4:	040005b7          	lui	a1,0x4000
    800010e8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010ea:	05b2                	slli	a1,a1,0xc
    800010ec:	fffff097          	auipc	ra,0xfffff
    800010f0:	73c080e7          	jalr	1852(ra) # 80000828 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010f4:	4681                	li	a3,0
    800010f6:	4605                	li	a2,1
    800010f8:	020005b7          	lui	a1,0x2000
    800010fc:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800010fe:	05b6                	slli	a1,a1,0xd
    80001100:	8526                	mv	a0,s1
    80001102:	fffff097          	auipc	ra,0xfffff
    80001106:	726080e7          	jalr	1830(ra) # 80000828 <uvmunmap>
  uvmfree(pagetable, sz);
    8000110a:	85ca                	mv	a1,s2
    8000110c:	8526                	mv	a0,s1
    8000110e:	00000097          	auipc	ra,0x0
    80001112:	9e4080e7          	jalr	-1564(ra) # 80000af2 <uvmfree>
}
    80001116:	60e2                	ld	ra,24(sp)
    80001118:	6442                	ld	s0,16(sp)
    8000111a:	64a2                	ld	s1,8(sp)
    8000111c:	6902                	ld	s2,0(sp)
    8000111e:	6105                	addi	sp,sp,32
    80001120:	8082                	ret

0000000080001122 <freeproc>:
{
    80001122:	1101                	addi	sp,sp,-32
    80001124:	ec06                	sd	ra,24(sp)
    80001126:	e822                	sd	s0,16(sp)
    80001128:	e426                	sd	s1,8(sp)
    8000112a:	1000                	addi	s0,sp,32
    8000112c:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000112e:	7128                	ld	a0,96(a0)
    80001130:	c509                	beqz	a0,8000113a <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001132:	fffff097          	auipc	ra,0xfffff
    80001136:	eea080e7          	jalr	-278(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000113a:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    8000113e:	6ca8                	ld	a0,88(s1)
    80001140:	c511                	beqz	a0,8000114c <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001142:	68ac                	ld	a1,80(s1)
    80001144:	00000097          	auipc	ra,0x0
    80001148:	f8c080e7          	jalr	-116(ra) # 800010d0 <proc_freepagetable>
  p->pagetable = 0;
    8000114c:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001150:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    80001154:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001158:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    8000115c:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001160:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001164:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001168:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    8000116c:	0204a023          	sw	zero,32(s1)
}
    80001170:	60e2                	ld	ra,24(sp)
    80001172:	6442                	ld	s0,16(sp)
    80001174:	64a2                	ld	s1,8(sp)
    80001176:	6105                	addi	sp,sp,32
    80001178:	8082                	ret

000000008000117a <allocproc>:
{
    8000117a:	1101                	addi	sp,sp,-32
    8000117c:	ec06                	sd	ra,24(sp)
    8000117e:	e822                	sd	s0,16(sp)
    80001180:	e426                	sd	s1,8(sp)
    80001182:	e04a                	sd	s2,0(sp)
    80001184:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001186:	00008497          	auipc	s1,0x8
    8000118a:	dba48493          	addi	s1,s1,-582 # 80008f40 <proc>
    8000118e:	0000e917          	auipc	s2,0xe
    80001192:	9b290913          	addi	s2,s2,-1614 # 8000eb40 <tickslock>
    acquire(&p->lock);
    80001196:	8526                	mv	a0,s1
    80001198:	00005097          	auipc	ra,0x5
    8000119c:	61a080e7          	jalr	1562(ra) # 800067b2 <acquire>
    if(p->state == UNUSED) {
    800011a0:	509c                	lw	a5,32(s1)
    800011a2:	cf81                	beqz	a5,800011ba <allocproc+0x40>
      release(&p->lock);
    800011a4:	8526                	mv	a0,s1
    800011a6:	00005097          	auipc	ra,0x5
    800011aa:	6dc080e7          	jalr	1756(ra) # 80006882 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800011ae:	17048493          	addi	s1,s1,368
    800011b2:	ff2492e3          	bne	s1,s2,80001196 <allocproc+0x1c>
  return 0;
    800011b6:	4481                	li	s1,0
    800011b8:	a889                	j	8000120a <allocproc+0x90>
  p->pid = allocpid();
    800011ba:	00000097          	auipc	ra,0x0
    800011be:	e34080e7          	jalr	-460(ra) # 80000fee <allocpid>
    800011c2:	dc88                	sw	a0,56(s1)
  p->state = USED;
    800011c4:	4785                	li	a5,1
    800011c6:	d09c                	sw	a5,32(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800011c8:	fffff097          	auipc	ra,0xfffff
    800011cc:	fba080e7          	jalr	-70(ra) # 80000182 <kalloc>
    800011d0:	892a                	mv	s2,a0
    800011d2:	f0a8                	sd	a0,96(s1)
    800011d4:	c131                	beqz	a0,80001218 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800011d6:	8526                	mv	a0,s1
    800011d8:	00000097          	auipc	ra,0x0
    800011dc:	e5c080e7          	jalr	-420(ra) # 80001034 <proc_pagetable>
    800011e0:	892a                	mv	s2,a0
    800011e2:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    800011e4:	c531                	beqz	a0,80001230 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800011e6:	07000613          	li	a2,112
    800011ea:	4581                	li	a1,0
    800011ec:	06848513          	addi	a0,s1,104
    800011f0:	fffff097          	auipc	ra,0xfffff
    800011f4:	096080e7          	jalr	150(ra) # 80000286 <memset>
  p->context.ra = (uint64)forkret;
    800011f8:	00000797          	auipc	a5,0x0
    800011fc:	db078793          	addi	a5,a5,-592 # 80000fa8 <forkret>
    80001200:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001202:	64bc                	ld	a5,72(s1)
    80001204:	6705                	lui	a4,0x1
    80001206:	97ba                	add	a5,a5,a4
    80001208:	f8bc                	sd	a5,112(s1)
}
    8000120a:	8526                	mv	a0,s1
    8000120c:	60e2                	ld	ra,24(sp)
    8000120e:	6442                	ld	s0,16(sp)
    80001210:	64a2                	ld	s1,8(sp)
    80001212:	6902                	ld	s2,0(sp)
    80001214:	6105                	addi	sp,sp,32
    80001216:	8082                	ret
    freeproc(p);
    80001218:	8526                	mv	a0,s1
    8000121a:	00000097          	auipc	ra,0x0
    8000121e:	f08080e7          	jalr	-248(ra) # 80001122 <freeproc>
    release(&p->lock);
    80001222:	8526                	mv	a0,s1
    80001224:	00005097          	auipc	ra,0x5
    80001228:	65e080e7          	jalr	1630(ra) # 80006882 <release>
    return 0;
    8000122c:	84ca                	mv	s1,s2
    8000122e:	bff1                	j	8000120a <allocproc+0x90>
    freeproc(p);
    80001230:	8526                	mv	a0,s1
    80001232:	00000097          	auipc	ra,0x0
    80001236:	ef0080e7          	jalr	-272(ra) # 80001122 <freeproc>
    release(&p->lock);
    8000123a:	8526                	mv	a0,s1
    8000123c:	00005097          	auipc	ra,0x5
    80001240:	646080e7          	jalr	1606(ra) # 80006882 <release>
    return 0;
    80001244:	84ca                	mv	s1,s2
    80001246:	b7d1                	j	8000120a <allocproc+0x90>

0000000080001248 <userinit>:
{
    80001248:	1101                	addi	sp,sp,-32
    8000124a:	ec06                	sd	ra,24(sp)
    8000124c:	e822                	sd	s0,16(sp)
    8000124e:	e426                	sd	s1,8(sp)
    80001250:	1000                	addi	s0,sp,32
  p = allocproc();
    80001252:	00000097          	auipc	ra,0x0
    80001256:	f28080e7          	jalr	-216(ra) # 8000117a <allocproc>
    8000125a:	84aa                	mv	s1,a0
  initproc = p;
    8000125c:	00007797          	auipc	a5,0x7
    80001260:	74a7b223          	sd	a0,1860(a5) # 800089a0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001264:	03400613          	li	a2,52
    80001268:	00007597          	auipc	a1,0x7
    8000126c:	6c858593          	addi	a1,a1,1736 # 80008930 <initcode>
    80001270:	6d28                	ld	a0,88(a0)
    80001272:	fffff097          	auipc	ra,0xfffff
    80001276:	6a8080e7          	jalr	1704(ra) # 8000091a <uvmfirst>
  p->sz = PGSIZE;
    8000127a:	6785                	lui	a5,0x1
    8000127c:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    8000127e:	70b8                	ld	a4,96(s1)
    80001280:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001284:	70b8                	ld	a4,96(s1)
    80001286:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001288:	4641                	li	a2,16
    8000128a:	00007597          	auipc	a1,0x7
    8000128e:	ef658593          	addi	a1,a1,-266 # 80008180 <etext+0x180>
    80001292:	16048513          	addi	a0,s1,352
    80001296:	fffff097          	auipc	ra,0xfffff
    8000129a:	13a080e7          	jalr	314(ra) # 800003d0 <safestrcpy>
  p->cwd = namei("/");
    8000129e:	00007517          	auipc	a0,0x7
    800012a2:	ef250513          	addi	a0,a0,-270 # 80008190 <etext+0x190>
    800012a6:	00002097          	auipc	ra,0x2
    800012aa:	3a2080e7          	jalr	930(ra) # 80003648 <namei>
    800012ae:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    800012b2:	478d                	li	a5,3
    800012b4:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    800012b6:	8526                	mv	a0,s1
    800012b8:	00005097          	auipc	ra,0x5
    800012bc:	5ca080e7          	jalr	1482(ra) # 80006882 <release>
}
    800012c0:	60e2                	ld	ra,24(sp)
    800012c2:	6442                	ld	s0,16(sp)
    800012c4:	64a2                	ld	s1,8(sp)
    800012c6:	6105                	addi	sp,sp,32
    800012c8:	8082                	ret

00000000800012ca <growproc>:
{
    800012ca:	1101                	addi	sp,sp,-32
    800012cc:	ec06                	sd	ra,24(sp)
    800012ce:	e822                	sd	s0,16(sp)
    800012d0:	e426                	sd	s1,8(sp)
    800012d2:	e04a                	sd	s2,0(sp)
    800012d4:	1000                	addi	s0,sp,32
    800012d6:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800012d8:	00000097          	auipc	ra,0x0
    800012dc:	c98080e7          	jalr	-872(ra) # 80000f70 <myproc>
    800012e0:	84aa                	mv	s1,a0
  sz = p->sz;
    800012e2:	692c                	ld	a1,80(a0)
  if(n > 0){
    800012e4:	01204c63          	bgtz	s2,800012fc <growproc+0x32>
  } else if(n < 0){
    800012e8:	02094663          	bltz	s2,80001314 <growproc+0x4a>
  p->sz = sz;
    800012ec:	e8ac                	sd	a1,80(s1)
  return 0;
    800012ee:	4501                	li	a0,0
}
    800012f0:	60e2                	ld	ra,24(sp)
    800012f2:	6442                	ld	s0,16(sp)
    800012f4:	64a2                	ld	s1,8(sp)
    800012f6:	6902                	ld	s2,0(sp)
    800012f8:	6105                	addi	sp,sp,32
    800012fa:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800012fc:	4691                	li	a3,4
    800012fe:	00b90633          	add	a2,s2,a1
    80001302:	6d28                	ld	a0,88(a0)
    80001304:	fffff097          	auipc	ra,0xfffff
    80001308:	6d0080e7          	jalr	1744(ra) # 800009d4 <uvmalloc>
    8000130c:	85aa                	mv	a1,a0
    8000130e:	fd79                	bnez	a0,800012ec <growproc+0x22>
      return -1;
    80001310:	557d                	li	a0,-1
    80001312:	bff9                	j	800012f0 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001314:	00b90633          	add	a2,s2,a1
    80001318:	6d28                	ld	a0,88(a0)
    8000131a:	fffff097          	auipc	ra,0xfffff
    8000131e:	672080e7          	jalr	1650(ra) # 8000098c <uvmdealloc>
    80001322:	85aa                	mv	a1,a0
    80001324:	b7e1                	j	800012ec <growproc+0x22>

0000000080001326 <fork>:
{
    80001326:	7139                	addi	sp,sp,-64
    80001328:	fc06                	sd	ra,56(sp)
    8000132a:	f822                	sd	s0,48(sp)
    8000132c:	f426                	sd	s1,40(sp)
    8000132e:	f04a                	sd	s2,32(sp)
    80001330:	ec4e                	sd	s3,24(sp)
    80001332:	e852                	sd	s4,16(sp)
    80001334:	e456                	sd	s5,8(sp)
    80001336:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001338:	00000097          	auipc	ra,0x0
    8000133c:	c38080e7          	jalr	-968(ra) # 80000f70 <myproc>
    80001340:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001342:	00000097          	auipc	ra,0x0
    80001346:	e38080e7          	jalr	-456(ra) # 8000117a <allocproc>
    8000134a:	10050c63          	beqz	a0,80001462 <fork+0x13c>
    8000134e:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001350:	050ab603          	ld	a2,80(s5)
    80001354:	6d2c                	ld	a1,88(a0)
    80001356:	058ab503          	ld	a0,88(s5)
    8000135a:	fffff097          	auipc	ra,0xfffff
    8000135e:	7d2080e7          	jalr	2002(ra) # 80000b2c <uvmcopy>
    80001362:	04054863          	bltz	a0,800013b2 <fork+0x8c>
  np->sz = p->sz;
    80001366:	050ab783          	ld	a5,80(s5)
    8000136a:	04fa3823          	sd	a5,80(s4)
  *(np->trapframe) = *(p->trapframe);
    8000136e:	060ab683          	ld	a3,96(s5)
    80001372:	87b6                	mv	a5,a3
    80001374:	060a3703          	ld	a4,96(s4)
    80001378:	12068693          	addi	a3,a3,288
    8000137c:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001380:	6788                	ld	a0,8(a5)
    80001382:	6b8c                	ld	a1,16(a5)
    80001384:	6f90                	ld	a2,24(a5)
    80001386:	01073023          	sd	a6,0(a4)
    8000138a:	e708                	sd	a0,8(a4)
    8000138c:	eb0c                	sd	a1,16(a4)
    8000138e:	ef10                	sd	a2,24(a4)
    80001390:	02078793          	addi	a5,a5,32
    80001394:	02070713          	addi	a4,a4,32
    80001398:	fed792e3          	bne	a5,a3,8000137c <fork+0x56>
  np->trapframe->a0 = 0;
    8000139c:	060a3783          	ld	a5,96(s4)
    800013a0:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800013a4:	0d8a8493          	addi	s1,s5,216
    800013a8:	0d8a0913          	addi	s2,s4,216
    800013ac:	158a8993          	addi	s3,s5,344
    800013b0:	a00d                	j	800013d2 <fork+0xac>
    freeproc(np);
    800013b2:	8552                	mv	a0,s4
    800013b4:	00000097          	auipc	ra,0x0
    800013b8:	d6e080e7          	jalr	-658(ra) # 80001122 <freeproc>
    release(&np->lock);
    800013bc:	8552                	mv	a0,s4
    800013be:	00005097          	auipc	ra,0x5
    800013c2:	4c4080e7          	jalr	1220(ra) # 80006882 <release>
    return -1;
    800013c6:	597d                	li	s2,-1
    800013c8:	a059                	j	8000144e <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    800013ca:	04a1                	addi	s1,s1,8
    800013cc:	0921                	addi	s2,s2,8
    800013ce:	01348b63          	beq	s1,s3,800013e4 <fork+0xbe>
    if(p->ofile[i])
    800013d2:	6088                	ld	a0,0(s1)
    800013d4:	d97d                	beqz	a0,800013ca <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800013d6:	00003097          	auipc	ra,0x3
    800013da:	908080e7          	jalr	-1784(ra) # 80003cde <filedup>
    800013de:	00a93023          	sd	a0,0(s2)
    800013e2:	b7e5                	j	800013ca <fork+0xa4>
  np->cwd = idup(p->cwd);
    800013e4:	158ab503          	ld	a0,344(s5)
    800013e8:	00002097          	auipc	ra,0x2
    800013ec:	a62080e7          	jalr	-1438(ra) # 80002e4a <idup>
    800013f0:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800013f4:	4641                	li	a2,16
    800013f6:	160a8593          	addi	a1,s5,352
    800013fa:	160a0513          	addi	a0,s4,352
    800013fe:	fffff097          	auipc	ra,0xfffff
    80001402:	fd2080e7          	jalr	-46(ra) # 800003d0 <safestrcpy>
  pid = np->pid;
    80001406:	038a2903          	lw	s2,56(s4)
  release(&np->lock);
    8000140a:	8552                	mv	a0,s4
    8000140c:	00005097          	auipc	ra,0x5
    80001410:	476080e7          	jalr	1142(ra) # 80006882 <release>
  acquire(&wait_lock);
    80001414:	00007497          	auipc	s1,0x7
    80001418:	70c48493          	addi	s1,s1,1804 # 80008b20 <wait_lock>
    8000141c:	8526                	mv	a0,s1
    8000141e:	00005097          	auipc	ra,0x5
    80001422:	394080e7          	jalr	916(ra) # 800067b2 <acquire>
  np->parent = p;
    80001426:	055a3023          	sd	s5,64(s4)
  release(&wait_lock);
    8000142a:	8526                	mv	a0,s1
    8000142c:	00005097          	auipc	ra,0x5
    80001430:	456080e7          	jalr	1110(ra) # 80006882 <release>
  acquire(&np->lock);
    80001434:	8552                	mv	a0,s4
    80001436:	00005097          	auipc	ra,0x5
    8000143a:	37c080e7          	jalr	892(ra) # 800067b2 <acquire>
  np->state = RUNNABLE;
    8000143e:	478d                	li	a5,3
    80001440:	02fa2023          	sw	a5,32(s4)
  release(&np->lock);
    80001444:	8552                	mv	a0,s4
    80001446:	00005097          	auipc	ra,0x5
    8000144a:	43c080e7          	jalr	1084(ra) # 80006882 <release>
}
    8000144e:	854a                	mv	a0,s2
    80001450:	70e2                	ld	ra,56(sp)
    80001452:	7442                	ld	s0,48(sp)
    80001454:	74a2                	ld	s1,40(sp)
    80001456:	7902                	ld	s2,32(sp)
    80001458:	69e2                	ld	s3,24(sp)
    8000145a:	6a42                	ld	s4,16(sp)
    8000145c:	6aa2                	ld	s5,8(sp)
    8000145e:	6121                	addi	sp,sp,64
    80001460:	8082                	ret
    return -1;
    80001462:	597d                	li	s2,-1
    80001464:	b7ed                	j	8000144e <fork+0x128>

0000000080001466 <scheduler>:
{
    80001466:	7139                	addi	sp,sp,-64
    80001468:	fc06                	sd	ra,56(sp)
    8000146a:	f822                	sd	s0,48(sp)
    8000146c:	f426                	sd	s1,40(sp)
    8000146e:	f04a                	sd	s2,32(sp)
    80001470:	ec4e                	sd	s3,24(sp)
    80001472:	e852                	sd	s4,16(sp)
    80001474:	e456                	sd	s5,8(sp)
    80001476:	e05a                	sd	s6,0(sp)
    80001478:	0080                	addi	s0,sp,64
    8000147a:	8792                	mv	a5,tp
  int id = r_tp();
    8000147c:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000147e:	00779a93          	slli	s5,a5,0x7
    80001482:	00007717          	auipc	a4,0x7
    80001486:	67e70713          	addi	a4,a4,1662 # 80008b00 <pid_lock>
    8000148a:	9756                	add	a4,a4,s5
    8000148c:	04073023          	sd	zero,64(a4)
        swtch(&c->context, &p->context);
    80001490:	00007717          	auipc	a4,0x7
    80001494:	6b870713          	addi	a4,a4,1720 # 80008b48 <cpus+0x8>
    80001498:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000149a:	498d                	li	s3,3
        p->state = RUNNING;
    8000149c:	4b11                	li	s6,4
        c->proc = p;
    8000149e:	079e                	slli	a5,a5,0x7
    800014a0:	00007a17          	auipc	s4,0x7
    800014a4:	660a0a13          	addi	s4,s4,1632 # 80008b00 <pid_lock>
    800014a8:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800014aa:	0000d917          	auipc	s2,0xd
    800014ae:	69690913          	addi	s2,s2,1686 # 8000eb40 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014b2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800014b6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800014ba:	10079073          	csrw	sstatus,a5
    800014be:	00008497          	auipc	s1,0x8
    800014c2:	a8248493          	addi	s1,s1,-1406 # 80008f40 <proc>
    800014c6:	a811                	j	800014da <scheduler+0x74>
      release(&p->lock);
    800014c8:	8526                	mv	a0,s1
    800014ca:	00005097          	auipc	ra,0x5
    800014ce:	3b8080e7          	jalr	952(ra) # 80006882 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800014d2:	17048493          	addi	s1,s1,368
    800014d6:	fd248ee3          	beq	s1,s2,800014b2 <scheduler+0x4c>
      acquire(&p->lock);
    800014da:	8526                	mv	a0,s1
    800014dc:	00005097          	auipc	ra,0x5
    800014e0:	2d6080e7          	jalr	726(ra) # 800067b2 <acquire>
      if(p->state == RUNNABLE) {
    800014e4:	509c                	lw	a5,32(s1)
    800014e6:	ff3791e3          	bne	a5,s3,800014c8 <scheduler+0x62>
        p->state = RUNNING;
    800014ea:	0364a023          	sw	s6,32(s1)
        c->proc = p;
    800014ee:	049a3023          	sd	s1,64(s4)
        swtch(&c->context, &p->context);
    800014f2:	06848593          	addi	a1,s1,104
    800014f6:	8556                	mv	a0,s5
    800014f8:	00000097          	auipc	ra,0x0
    800014fc:	684080e7          	jalr	1668(ra) # 80001b7c <swtch>
        c->proc = 0;
    80001500:	040a3023          	sd	zero,64(s4)
    80001504:	b7d1                	j	800014c8 <scheduler+0x62>

0000000080001506 <sched>:
{
    80001506:	7179                	addi	sp,sp,-48
    80001508:	f406                	sd	ra,40(sp)
    8000150a:	f022                	sd	s0,32(sp)
    8000150c:	ec26                	sd	s1,24(sp)
    8000150e:	e84a                	sd	s2,16(sp)
    80001510:	e44e                	sd	s3,8(sp)
    80001512:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001514:	00000097          	auipc	ra,0x0
    80001518:	a5c080e7          	jalr	-1444(ra) # 80000f70 <myproc>
    8000151c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000151e:	00005097          	auipc	ra,0x5
    80001522:	21a080e7          	jalr	538(ra) # 80006738 <holding>
    80001526:	c93d                	beqz	a0,8000159c <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001528:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000152a:	2781                	sext.w	a5,a5
    8000152c:	079e                	slli	a5,a5,0x7
    8000152e:	00007717          	auipc	a4,0x7
    80001532:	5d270713          	addi	a4,a4,1490 # 80008b00 <pid_lock>
    80001536:	97ba                	add	a5,a5,a4
    80001538:	0b87a703          	lw	a4,184(a5)
    8000153c:	4785                	li	a5,1
    8000153e:	06f71763          	bne	a4,a5,800015ac <sched+0xa6>
  if(p->state == RUNNING)
    80001542:	5098                	lw	a4,32(s1)
    80001544:	4791                	li	a5,4
    80001546:	06f70b63          	beq	a4,a5,800015bc <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000154a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000154e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001550:	efb5                	bnez	a5,800015cc <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001552:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001554:	00007917          	auipc	s2,0x7
    80001558:	5ac90913          	addi	s2,s2,1452 # 80008b00 <pid_lock>
    8000155c:	2781                	sext.w	a5,a5
    8000155e:	079e                	slli	a5,a5,0x7
    80001560:	97ca                	add	a5,a5,s2
    80001562:	0bc7a983          	lw	s3,188(a5)
    80001566:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001568:	2781                	sext.w	a5,a5
    8000156a:	079e                	slli	a5,a5,0x7
    8000156c:	00007597          	auipc	a1,0x7
    80001570:	5dc58593          	addi	a1,a1,1500 # 80008b48 <cpus+0x8>
    80001574:	95be                	add	a1,a1,a5
    80001576:	06848513          	addi	a0,s1,104
    8000157a:	00000097          	auipc	ra,0x0
    8000157e:	602080e7          	jalr	1538(ra) # 80001b7c <swtch>
    80001582:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001584:	2781                	sext.w	a5,a5
    80001586:	079e                	slli	a5,a5,0x7
    80001588:	993e                	add	s2,s2,a5
    8000158a:	0b392e23          	sw	s3,188(s2)
}
    8000158e:	70a2                	ld	ra,40(sp)
    80001590:	7402                	ld	s0,32(sp)
    80001592:	64e2                	ld	s1,24(sp)
    80001594:	6942                	ld	s2,16(sp)
    80001596:	69a2                	ld	s3,8(sp)
    80001598:	6145                	addi	sp,sp,48
    8000159a:	8082                	ret
    panic("sched p->lock");
    8000159c:	00007517          	auipc	a0,0x7
    800015a0:	bfc50513          	addi	a0,a0,-1028 # 80008198 <etext+0x198>
    800015a4:	00005097          	auipc	ra,0x5
    800015a8:	cec080e7          	jalr	-788(ra) # 80006290 <panic>
    panic("sched locks");
    800015ac:	00007517          	auipc	a0,0x7
    800015b0:	bfc50513          	addi	a0,a0,-1028 # 800081a8 <etext+0x1a8>
    800015b4:	00005097          	auipc	ra,0x5
    800015b8:	cdc080e7          	jalr	-804(ra) # 80006290 <panic>
    panic("sched running");
    800015bc:	00007517          	auipc	a0,0x7
    800015c0:	bfc50513          	addi	a0,a0,-1028 # 800081b8 <etext+0x1b8>
    800015c4:	00005097          	auipc	ra,0x5
    800015c8:	ccc080e7          	jalr	-820(ra) # 80006290 <panic>
    panic("sched interruptible");
    800015cc:	00007517          	auipc	a0,0x7
    800015d0:	bfc50513          	addi	a0,a0,-1028 # 800081c8 <etext+0x1c8>
    800015d4:	00005097          	auipc	ra,0x5
    800015d8:	cbc080e7          	jalr	-836(ra) # 80006290 <panic>

00000000800015dc <yield>:
{
    800015dc:	1101                	addi	sp,sp,-32
    800015de:	ec06                	sd	ra,24(sp)
    800015e0:	e822                	sd	s0,16(sp)
    800015e2:	e426                	sd	s1,8(sp)
    800015e4:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800015e6:	00000097          	auipc	ra,0x0
    800015ea:	98a080e7          	jalr	-1654(ra) # 80000f70 <myproc>
    800015ee:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800015f0:	00005097          	auipc	ra,0x5
    800015f4:	1c2080e7          	jalr	450(ra) # 800067b2 <acquire>
  p->state = RUNNABLE;
    800015f8:	478d                	li	a5,3
    800015fa:	d09c                	sw	a5,32(s1)
  sched();
    800015fc:	00000097          	auipc	ra,0x0
    80001600:	f0a080e7          	jalr	-246(ra) # 80001506 <sched>
  release(&p->lock);
    80001604:	8526                	mv	a0,s1
    80001606:	00005097          	auipc	ra,0x5
    8000160a:	27c080e7          	jalr	636(ra) # 80006882 <release>
}
    8000160e:	60e2                	ld	ra,24(sp)
    80001610:	6442                	ld	s0,16(sp)
    80001612:	64a2                	ld	s1,8(sp)
    80001614:	6105                	addi	sp,sp,32
    80001616:	8082                	ret

0000000080001618 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001618:	7179                	addi	sp,sp,-48
    8000161a:	f406                	sd	ra,40(sp)
    8000161c:	f022                	sd	s0,32(sp)
    8000161e:	ec26                	sd	s1,24(sp)
    80001620:	e84a                	sd	s2,16(sp)
    80001622:	e44e                	sd	s3,8(sp)
    80001624:	1800                	addi	s0,sp,48
    80001626:	89aa                	mv	s3,a0
    80001628:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000162a:	00000097          	auipc	ra,0x0
    8000162e:	946080e7          	jalr	-1722(ra) # 80000f70 <myproc>
    80001632:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001634:	00005097          	auipc	ra,0x5
    80001638:	17e080e7          	jalr	382(ra) # 800067b2 <acquire>
  release(lk);
    8000163c:	854a                	mv	a0,s2
    8000163e:	00005097          	auipc	ra,0x5
    80001642:	244080e7          	jalr	580(ra) # 80006882 <release>

  // Go to sleep.
  p->chan = chan;
    80001646:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    8000164a:	4789                	li	a5,2
    8000164c:	d09c                	sw	a5,32(s1)

  sched();
    8000164e:	00000097          	auipc	ra,0x0
    80001652:	eb8080e7          	jalr	-328(ra) # 80001506 <sched>

  // Tidy up.
  p->chan = 0;
    80001656:	0204b423          	sd	zero,40(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000165a:	8526                	mv	a0,s1
    8000165c:	00005097          	auipc	ra,0x5
    80001660:	226080e7          	jalr	550(ra) # 80006882 <release>
  acquire(lk);
    80001664:	854a                	mv	a0,s2
    80001666:	00005097          	auipc	ra,0x5
    8000166a:	14c080e7          	jalr	332(ra) # 800067b2 <acquire>
}
    8000166e:	70a2                	ld	ra,40(sp)
    80001670:	7402                	ld	s0,32(sp)
    80001672:	64e2                	ld	s1,24(sp)
    80001674:	6942                	ld	s2,16(sp)
    80001676:	69a2                	ld	s3,8(sp)
    80001678:	6145                	addi	sp,sp,48
    8000167a:	8082                	ret

000000008000167c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000167c:	7139                	addi	sp,sp,-64
    8000167e:	fc06                	sd	ra,56(sp)
    80001680:	f822                	sd	s0,48(sp)
    80001682:	f426                	sd	s1,40(sp)
    80001684:	f04a                	sd	s2,32(sp)
    80001686:	ec4e                	sd	s3,24(sp)
    80001688:	e852                	sd	s4,16(sp)
    8000168a:	e456                	sd	s5,8(sp)
    8000168c:	0080                	addi	s0,sp,64
    8000168e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001690:	00008497          	auipc	s1,0x8
    80001694:	8b048493          	addi	s1,s1,-1872 # 80008f40 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001698:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000169a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000169c:	0000d917          	auipc	s2,0xd
    800016a0:	4a490913          	addi	s2,s2,1188 # 8000eb40 <tickslock>
    800016a4:	a811                	j	800016b8 <wakeup+0x3c>
      }
      release(&p->lock);
    800016a6:	8526                	mv	a0,s1
    800016a8:	00005097          	auipc	ra,0x5
    800016ac:	1da080e7          	jalr	474(ra) # 80006882 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016b0:	17048493          	addi	s1,s1,368
    800016b4:	03248663          	beq	s1,s2,800016e0 <wakeup+0x64>
    if(p != myproc()){
    800016b8:	00000097          	auipc	ra,0x0
    800016bc:	8b8080e7          	jalr	-1864(ra) # 80000f70 <myproc>
    800016c0:	fea488e3          	beq	s1,a0,800016b0 <wakeup+0x34>
      acquire(&p->lock);
    800016c4:	8526                	mv	a0,s1
    800016c6:	00005097          	auipc	ra,0x5
    800016ca:	0ec080e7          	jalr	236(ra) # 800067b2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800016ce:	509c                	lw	a5,32(s1)
    800016d0:	fd379be3          	bne	a5,s3,800016a6 <wakeup+0x2a>
    800016d4:	749c                	ld	a5,40(s1)
    800016d6:	fd4798e3          	bne	a5,s4,800016a6 <wakeup+0x2a>
        p->state = RUNNABLE;
    800016da:	0354a023          	sw	s5,32(s1)
    800016de:	b7e1                	j	800016a6 <wakeup+0x2a>
    }
  }
}
    800016e0:	70e2                	ld	ra,56(sp)
    800016e2:	7442                	ld	s0,48(sp)
    800016e4:	74a2                	ld	s1,40(sp)
    800016e6:	7902                	ld	s2,32(sp)
    800016e8:	69e2                	ld	s3,24(sp)
    800016ea:	6a42                	ld	s4,16(sp)
    800016ec:	6aa2                	ld	s5,8(sp)
    800016ee:	6121                	addi	sp,sp,64
    800016f0:	8082                	ret

00000000800016f2 <reparent>:
{
    800016f2:	7179                	addi	sp,sp,-48
    800016f4:	f406                	sd	ra,40(sp)
    800016f6:	f022                	sd	s0,32(sp)
    800016f8:	ec26                	sd	s1,24(sp)
    800016fa:	e84a                	sd	s2,16(sp)
    800016fc:	e44e                	sd	s3,8(sp)
    800016fe:	e052                	sd	s4,0(sp)
    80001700:	1800                	addi	s0,sp,48
    80001702:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001704:	00008497          	auipc	s1,0x8
    80001708:	83c48493          	addi	s1,s1,-1988 # 80008f40 <proc>
      pp->parent = initproc;
    8000170c:	00007a17          	auipc	s4,0x7
    80001710:	294a0a13          	addi	s4,s4,660 # 800089a0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001714:	0000d997          	auipc	s3,0xd
    80001718:	42c98993          	addi	s3,s3,1068 # 8000eb40 <tickslock>
    8000171c:	a029                	j	80001726 <reparent+0x34>
    8000171e:	17048493          	addi	s1,s1,368
    80001722:	01348d63          	beq	s1,s3,8000173c <reparent+0x4a>
    if(pp->parent == p){
    80001726:	60bc                	ld	a5,64(s1)
    80001728:	ff279be3          	bne	a5,s2,8000171e <reparent+0x2c>
      pp->parent = initproc;
    8000172c:	000a3503          	ld	a0,0(s4)
    80001730:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    80001732:	00000097          	auipc	ra,0x0
    80001736:	f4a080e7          	jalr	-182(ra) # 8000167c <wakeup>
    8000173a:	b7d5                	j	8000171e <reparent+0x2c>
}
    8000173c:	70a2                	ld	ra,40(sp)
    8000173e:	7402                	ld	s0,32(sp)
    80001740:	64e2                	ld	s1,24(sp)
    80001742:	6942                	ld	s2,16(sp)
    80001744:	69a2                	ld	s3,8(sp)
    80001746:	6a02                	ld	s4,0(sp)
    80001748:	6145                	addi	sp,sp,48
    8000174a:	8082                	ret

000000008000174c <exit>:
{
    8000174c:	7179                	addi	sp,sp,-48
    8000174e:	f406                	sd	ra,40(sp)
    80001750:	f022                	sd	s0,32(sp)
    80001752:	ec26                	sd	s1,24(sp)
    80001754:	e84a                	sd	s2,16(sp)
    80001756:	e44e                	sd	s3,8(sp)
    80001758:	e052                	sd	s4,0(sp)
    8000175a:	1800                	addi	s0,sp,48
    8000175c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000175e:	00000097          	auipc	ra,0x0
    80001762:	812080e7          	jalr	-2030(ra) # 80000f70 <myproc>
    80001766:	89aa                	mv	s3,a0
  if(p == initproc)
    80001768:	00007797          	auipc	a5,0x7
    8000176c:	2387b783          	ld	a5,568(a5) # 800089a0 <initproc>
    80001770:	0d850493          	addi	s1,a0,216
    80001774:	15850913          	addi	s2,a0,344
    80001778:	02a79363          	bne	a5,a0,8000179e <exit+0x52>
    panic("init exiting");
    8000177c:	00007517          	auipc	a0,0x7
    80001780:	a6450513          	addi	a0,a0,-1436 # 800081e0 <etext+0x1e0>
    80001784:	00005097          	auipc	ra,0x5
    80001788:	b0c080e7          	jalr	-1268(ra) # 80006290 <panic>
      fileclose(f);
    8000178c:	00002097          	auipc	ra,0x2
    80001790:	5a4080e7          	jalr	1444(ra) # 80003d30 <fileclose>
      p->ofile[fd] = 0;
    80001794:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001798:	04a1                	addi	s1,s1,8
    8000179a:	01248563          	beq	s1,s2,800017a4 <exit+0x58>
    if(p->ofile[fd]){
    8000179e:	6088                	ld	a0,0(s1)
    800017a0:	f575                	bnez	a0,8000178c <exit+0x40>
    800017a2:	bfdd                	j	80001798 <exit+0x4c>
  begin_op();
    800017a4:	00002097          	auipc	ra,0x2
    800017a8:	0c4080e7          	jalr	196(ra) # 80003868 <begin_op>
  iput(p->cwd);
    800017ac:	1589b503          	ld	a0,344(s3)
    800017b0:	00002097          	auipc	ra,0x2
    800017b4:	8a6080e7          	jalr	-1882(ra) # 80003056 <iput>
  end_op();
    800017b8:	00002097          	auipc	ra,0x2
    800017bc:	12e080e7          	jalr	302(ra) # 800038e6 <end_op>
  p->cwd = 0;
    800017c0:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    800017c4:	00007497          	auipc	s1,0x7
    800017c8:	35c48493          	addi	s1,s1,860 # 80008b20 <wait_lock>
    800017cc:	8526                	mv	a0,s1
    800017ce:	00005097          	auipc	ra,0x5
    800017d2:	fe4080e7          	jalr	-28(ra) # 800067b2 <acquire>
  reparent(p);
    800017d6:	854e                	mv	a0,s3
    800017d8:	00000097          	auipc	ra,0x0
    800017dc:	f1a080e7          	jalr	-230(ra) # 800016f2 <reparent>
  wakeup(p->parent);
    800017e0:	0409b503          	ld	a0,64(s3)
    800017e4:	00000097          	auipc	ra,0x0
    800017e8:	e98080e7          	jalr	-360(ra) # 8000167c <wakeup>
  acquire(&p->lock);
    800017ec:	854e                	mv	a0,s3
    800017ee:	00005097          	auipc	ra,0x5
    800017f2:	fc4080e7          	jalr	-60(ra) # 800067b2 <acquire>
  p->xstate = status;
    800017f6:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    800017fa:	4795                	li	a5,5
    800017fc:	02f9a023          	sw	a5,32(s3)
  release(&wait_lock);
    80001800:	8526                	mv	a0,s1
    80001802:	00005097          	auipc	ra,0x5
    80001806:	080080e7          	jalr	128(ra) # 80006882 <release>
  sched();
    8000180a:	00000097          	auipc	ra,0x0
    8000180e:	cfc080e7          	jalr	-772(ra) # 80001506 <sched>
  panic("zombie exit");
    80001812:	00007517          	auipc	a0,0x7
    80001816:	9de50513          	addi	a0,a0,-1570 # 800081f0 <etext+0x1f0>
    8000181a:	00005097          	auipc	ra,0x5
    8000181e:	a76080e7          	jalr	-1418(ra) # 80006290 <panic>

0000000080001822 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001822:	7179                	addi	sp,sp,-48
    80001824:	f406                	sd	ra,40(sp)
    80001826:	f022                	sd	s0,32(sp)
    80001828:	ec26                	sd	s1,24(sp)
    8000182a:	e84a                	sd	s2,16(sp)
    8000182c:	e44e                	sd	s3,8(sp)
    8000182e:	1800                	addi	s0,sp,48
    80001830:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001832:	00007497          	auipc	s1,0x7
    80001836:	70e48493          	addi	s1,s1,1806 # 80008f40 <proc>
    8000183a:	0000d997          	auipc	s3,0xd
    8000183e:	30698993          	addi	s3,s3,774 # 8000eb40 <tickslock>
    acquire(&p->lock);
    80001842:	8526                	mv	a0,s1
    80001844:	00005097          	auipc	ra,0x5
    80001848:	f6e080e7          	jalr	-146(ra) # 800067b2 <acquire>
    if(p->pid == pid){
    8000184c:	5c9c                	lw	a5,56(s1)
    8000184e:	01278d63          	beq	a5,s2,80001868 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001852:	8526                	mv	a0,s1
    80001854:	00005097          	auipc	ra,0x5
    80001858:	02e080e7          	jalr	46(ra) # 80006882 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000185c:	17048493          	addi	s1,s1,368
    80001860:	ff3491e3          	bne	s1,s3,80001842 <kill+0x20>
  }
  return -1;
    80001864:	557d                	li	a0,-1
    80001866:	a829                	j	80001880 <kill+0x5e>
      p->killed = 1;
    80001868:	4785                	li	a5,1
    8000186a:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    8000186c:	5098                	lw	a4,32(s1)
    8000186e:	4789                	li	a5,2
    80001870:	00f70f63          	beq	a4,a5,8000188e <kill+0x6c>
      release(&p->lock);
    80001874:	8526                	mv	a0,s1
    80001876:	00005097          	auipc	ra,0x5
    8000187a:	00c080e7          	jalr	12(ra) # 80006882 <release>
      return 0;
    8000187e:	4501                	li	a0,0
}
    80001880:	70a2                	ld	ra,40(sp)
    80001882:	7402                	ld	s0,32(sp)
    80001884:	64e2                	ld	s1,24(sp)
    80001886:	6942                	ld	s2,16(sp)
    80001888:	69a2                	ld	s3,8(sp)
    8000188a:	6145                	addi	sp,sp,48
    8000188c:	8082                	ret
        p->state = RUNNABLE;
    8000188e:	478d                	li	a5,3
    80001890:	d09c                	sw	a5,32(s1)
    80001892:	b7cd                	j	80001874 <kill+0x52>

0000000080001894 <setkilled>:

void
setkilled(struct proc *p)
{
    80001894:	1101                	addi	sp,sp,-32
    80001896:	ec06                	sd	ra,24(sp)
    80001898:	e822                	sd	s0,16(sp)
    8000189a:	e426                	sd	s1,8(sp)
    8000189c:	1000                	addi	s0,sp,32
    8000189e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800018a0:	00005097          	auipc	ra,0x5
    800018a4:	f12080e7          	jalr	-238(ra) # 800067b2 <acquire>
  p->killed = 1;
    800018a8:	4785                	li	a5,1
    800018aa:	d89c                	sw	a5,48(s1)
  release(&p->lock);
    800018ac:	8526                	mv	a0,s1
    800018ae:	00005097          	auipc	ra,0x5
    800018b2:	fd4080e7          	jalr	-44(ra) # 80006882 <release>
}
    800018b6:	60e2                	ld	ra,24(sp)
    800018b8:	6442                	ld	s0,16(sp)
    800018ba:	64a2                	ld	s1,8(sp)
    800018bc:	6105                	addi	sp,sp,32
    800018be:	8082                	ret

00000000800018c0 <killed>:

int
killed(struct proc *p)
{
    800018c0:	1101                	addi	sp,sp,-32
    800018c2:	ec06                	sd	ra,24(sp)
    800018c4:	e822                	sd	s0,16(sp)
    800018c6:	e426                	sd	s1,8(sp)
    800018c8:	e04a                	sd	s2,0(sp)
    800018ca:	1000                	addi	s0,sp,32
    800018cc:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800018ce:	00005097          	auipc	ra,0x5
    800018d2:	ee4080e7          	jalr	-284(ra) # 800067b2 <acquire>
  k = p->killed;
    800018d6:	0304a903          	lw	s2,48(s1)
  release(&p->lock);
    800018da:	8526                	mv	a0,s1
    800018dc:	00005097          	auipc	ra,0x5
    800018e0:	fa6080e7          	jalr	-90(ra) # 80006882 <release>
  return k;
}
    800018e4:	854a                	mv	a0,s2
    800018e6:	60e2                	ld	ra,24(sp)
    800018e8:	6442                	ld	s0,16(sp)
    800018ea:	64a2                	ld	s1,8(sp)
    800018ec:	6902                	ld	s2,0(sp)
    800018ee:	6105                	addi	sp,sp,32
    800018f0:	8082                	ret

00000000800018f2 <wait>:
{
    800018f2:	715d                	addi	sp,sp,-80
    800018f4:	e486                	sd	ra,72(sp)
    800018f6:	e0a2                	sd	s0,64(sp)
    800018f8:	fc26                	sd	s1,56(sp)
    800018fa:	f84a                	sd	s2,48(sp)
    800018fc:	f44e                	sd	s3,40(sp)
    800018fe:	f052                	sd	s4,32(sp)
    80001900:	ec56                	sd	s5,24(sp)
    80001902:	e85a                	sd	s6,16(sp)
    80001904:	e45e                	sd	s7,8(sp)
    80001906:	e062                	sd	s8,0(sp)
    80001908:	0880                	addi	s0,sp,80
    8000190a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000190c:	fffff097          	auipc	ra,0xfffff
    80001910:	664080e7          	jalr	1636(ra) # 80000f70 <myproc>
    80001914:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001916:	00007517          	auipc	a0,0x7
    8000191a:	20a50513          	addi	a0,a0,522 # 80008b20 <wait_lock>
    8000191e:	00005097          	auipc	ra,0x5
    80001922:	e94080e7          	jalr	-364(ra) # 800067b2 <acquire>
    havekids = 0;
    80001926:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001928:	4a15                	li	s4,5
        havekids = 1;
    8000192a:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000192c:	0000d997          	auipc	s3,0xd
    80001930:	21498993          	addi	s3,s3,532 # 8000eb40 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001934:	00007c17          	auipc	s8,0x7
    80001938:	1ecc0c13          	addi	s8,s8,492 # 80008b20 <wait_lock>
    havekids = 0;
    8000193c:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000193e:	00007497          	auipc	s1,0x7
    80001942:	60248493          	addi	s1,s1,1538 # 80008f40 <proc>
    80001946:	a0bd                	j	800019b4 <wait+0xc2>
          pid = pp->pid;
    80001948:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000194c:	000b0e63          	beqz	s6,80001968 <wait+0x76>
    80001950:	4691                	li	a3,4
    80001952:	03448613          	addi	a2,s1,52
    80001956:	85da                	mv	a1,s6
    80001958:	05893503          	ld	a0,88(s2)
    8000195c:	fffff097          	auipc	ra,0xfffff
    80001960:	2d4080e7          	jalr	724(ra) # 80000c30 <copyout>
    80001964:	02054563          	bltz	a0,8000198e <wait+0x9c>
          freeproc(pp);
    80001968:	8526                	mv	a0,s1
    8000196a:	fffff097          	auipc	ra,0xfffff
    8000196e:	7b8080e7          	jalr	1976(ra) # 80001122 <freeproc>
          release(&pp->lock);
    80001972:	8526                	mv	a0,s1
    80001974:	00005097          	auipc	ra,0x5
    80001978:	f0e080e7          	jalr	-242(ra) # 80006882 <release>
          release(&wait_lock);
    8000197c:	00007517          	auipc	a0,0x7
    80001980:	1a450513          	addi	a0,a0,420 # 80008b20 <wait_lock>
    80001984:	00005097          	auipc	ra,0x5
    80001988:	efe080e7          	jalr	-258(ra) # 80006882 <release>
          return pid;
    8000198c:	a0b5                	j	800019f8 <wait+0x106>
            release(&pp->lock);
    8000198e:	8526                	mv	a0,s1
    80001990:	00005097          	auipc	ra,0x5
    80001994:	ef2080e7          	jalr	-270(ra) # 80006882 <release>
            release(&wait_lock);
    80001998:	00007517          	auipc	a0,0x7
    8000199c:	18850513          	addi	a0,a0,392 # 80008b20 <wait_lock>
    800019a0:	00005097          	auipc	ra,0x5
    800019a4:	ee2080e7          	jalr	-286(ra) # 80006882 <release>
            return -1;
    800019a8:	59fd                	li	s3,-1
    800019aa:	a0b9                	j	800019f8 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019ac:	17048493          	addi	s1,s1,368
    800019b0:	03348463          	beq	s1,s3,800019d8 <wait+0xe6>
      if(pp->parent == p){
    800019b4:	60bc                	ld	a5,64(s1)
    800019b6:	ff279be3          	bne	a5,s2,800019ac <wait+0xba>
        acquire(&pp->lock);
    800019ba:	8526                	mv	a0,s1
    800019bc:	00005097          	auipc	ra,0x5
    800019c0:	df6080e7          	jalr	-522(ra) # 800067b2 <acquire>
        if(pp->state == ZOMBIE){
    800019c4:	509c                	lw	a5,32(s1)
    800019c6:	f94781e3          	beq	a5,s4,80001948 <wait+0x56>
        release(&pp->lock);
    800019ca:	8526                	mv	a0,s1
    800019cc:	00005097          	auipc	ra,0x5
    800019d0:	eb6080e7          	jalr	-330(ra) # 80006882 <release>
        havekids = 1;
    800019d4:	8756                	mv	a4,s5
    800019d6:	bfd9                	j	800019ac <wait+0xba>
    if(!havekids || killed(p)){
    800019d8:	c719                	beqz	a4,800019e6 <wait+0xf4>
    800019da:	854a                	mv	a0,s2
    800019dc:	00000097          	auipc	ra,0x0
    800019e0:	ee4080e7          	jalr	-284(ra) # 800018c0 <killed>
    800019e4:	c51d                	beqz	a0,80001a12 <wait+0x120>
      release(&wait_lock);
    800019e6:	00007517          	auipc	a0,0x7
    800019ea:	13a50513          	addi	a0,a0,314 # 80008b20 <wait_lock>
    800019ee:	00005097          	auipc	ra,0x5
    800019f2:	e94080e7          	jalr	-364(ra) # 80006882 <release>
      return -1;
    800019f6:	59fd                	li	s3,-1
}
    800019f8:	854e                	mv	a0,s3
    800019fa:	60a6                	ld	ra,72(sp)
    800019fc:	6406                	ld	s0,64(sp)
    800019fe:	74e2                	ld	s1,56(sp)
    80001a00:	7942                	ld	s2,48(sp)
    80001a02:	79a2                	ld	s3,40(sp)
    80001a04:	7a02                	ld	s4,32(sp)
    80001a06:	6ae2                	ld	s5,24(sp)
    80001a08:	6b42                	ld	s6,16(sp)
    80001a0a:	6ba2                	ld	s7,8(sp)
    80001a0c:	6c02                	ld	s8,0(sp)
    80001a0e:	6161                	addi	sp,sp,80
    80001a10:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001a12:	85e2                	mv	a1,s8
    80001a14:	854a                	mv	a0,s2
    80001a16:	00000097          	auipc	ra,0x0
    80001a1a:	c02080e7          	jalr	-1022(ra) # 80001618 <sleep>
    havekids = 0;
    80001a1e:	bf39                	j	8000193c <wait+0x4a>

0000000080001a20 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a20:	7179                	addi	sp,sp,-48
    80001a22:	f406                	sd	ra,40(sp)
    80001a24:	f022                	sd	s0,32(sp)
    80001a26:	ec26                	sd	s1,24(sp)
    80001a28:	e84a                	sd	s2,16(sp)
    80001a2a:	e44e                	sd	s3,8(sp)
    80001a2c:	e052                	sd	s4,0(sp)
    80001a2e:	1800                	addi	s0,sp,48
    80001a30:	84aa                	mv	s1,a0
    80001a32:	892e                	mv	s2,a1
    80001a34:	89b2                	mv	s3,a2
    80001a36:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a38:	fffff097          	auipc	ra,0xfffff
    80001a3c:	538080e7          	jalr	1336(ra) # 80000f70 <myproc>
  if(user_dst){
    80001a40:	c08d                	beqz	s1,80001a62 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a42:	86d2                	mv	a3,s4
    80001a44:	864e                	mv	a2,s3
    80001a46:	85ca                	mv	a1,s2
    80001a48:	6d28                	ld	a0,88(a0)
    80001a4a:	fffff097          	auipc	ra,0xfffff
    80001a4e:	1e6080e7          	jalr	486(ra) # 80000c30 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a52:	70a2                	ld	ra,40(sp)
    80001a54:	7402                	ld	s0,32(sp)
    80001a56:	64e2                	ld	s1,24(sp)
    80001a58:	6942                	ld	s2,16(sp)
    80001a5a:	69a2                	ld	s3,8(sp)
    80001a5c:	6a02                	ld	s4,0(sp)
    80001a5e:	6145                	addi	sp,sp,48
    80001a60:	8082                	ret
    memmove((char *)dst, src, len);
    80001a62:	000a061b          	sext.w	a2,s4
    80001a66:	85ce                	mv	a1,s3
    80001a68:	854a                	mv	a0,s2
    80001a6a:	fffff097          	auipc	ra,0xfffff
    80001a6e:	878080e7          	jalr	-1928(ra) # 800002e2 <memmove>
    return 0;
    80001a72:	8526                	mv	a0,s1
    80001a74:	bff9                	j	80001a52 <either_copyout+0x32>

0000000080001a76 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a76:	7179                	addi	sp,sp,-48
    80001a78:	f406                	sd	ra,40(sp)
    80001a7a:	f022                	sd	s0,32(sp)
    80001a7c:	ec26                	sd	s1,24(sp)
    80001a7e:	e84a                	sd	s2,16(sp)
    80001a80:	e44e                	sd	s3,8(sp)
    80001a82:	e052                	sd	s4,0(sp)
    80001a84:	1800                	addi	s0,sp,48
    80001a86:	892a                	mv	s2,a0
    80001a88:	84ae                	mv	s1,a1
    80001a8a:	89b2                	mv	s3,a2
    80001a8c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a8e:	fffff097          	auipc	ra,0xfffff
    80001a92:	4e2080e7          	jalr	1250(ra) # 80000f70 <myproc>
  if(user_src){
    80001a96:	c08d                	beqz	s1,80001ab8 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a98:	86d2                	mv	a3,s4
    80001a9a:	864e                	mv	a2,s3
    80001a9c:	85ca                	mv	a1,s2
    80001a9e:	6d28                	ld	a0,88(a0)
    80001aa0:	fffff097          	auipc	ra,0xfffff
    80001aa4:	21c080e7          	jalr	540(ra) # 80000cbc <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001aa8:	70a2                	ld	ra,40(sp)
    80001aaa:	7402                	ld	s0,32(sp)
    80001aac:	64e2                	ld	s1,24(sp)
    80001aae:	6942                	ld	s2,16(sp)
    80001ab0:	69a2                	ld	s3,8(sp)
    80001ab2:	6a02                	ld	s4,0(sp)
    80001ab4:	6145                	addi	sp,sp,48
    80001ab6:	8082                	ret
    memmove(dst, (char*)src, len);
    80001ab8:	000a061b          	sext.w	a2,s4
    80001abc:	85ce                	mv	a1,s3
    80001abe:	854a                	mv	a0,s2
    80001ac0:	fffff097          	auipc	ra,0xfffff
    80001ac4:	822080e7          	jalr	-2014(ra) # 800002e2 <memmove>
    return 0;
    80001ac8:	8526                	mv	a0,s1
    80001aca:	bff9                	j	80001aa8 <either_copyin+0x32>

0000000080001acc <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001acc:	715d                	addi	sp,sp,-80
    80001ace:	e486                	sd	ra,72(sp)
    80001ad0:	e0a2                	sd	s0,64(sp)
    80001ad2:	fc26                	sd	s1,56(sp)
    80001ad4:	f84a                	sd	s2,48(sp)
    80001ad6:	f44e                	sd	s3,40(sp)
    80001ad8:	f052                	sd	s4,32(sp)
    80001ada:	ec56                	sd	s5,24(sp)
    80001adc:	e85a                	sd	s6,16(sp)
    80001ade:	e45e                	sd	s7,8(sp)
    80001ae0:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001ae2:	00007517          	auipc	a0,0x7
    80001ae6:	dce50513          	addi	a0,a0,-562 # 800088b0 <digits+0x88>
    80001aea:	00004097          	auipc	ra,0x4
    80001aee:	7f0080e7          	jalr	2032(ra) # 800062da <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001af2:	00007497          	auipc	s1,0x7
    80001af6:	5ae48493          	addi	s1,s1,1454 # 800090a0 <proc+0x160>
    80001afa:	0000d917          	auipc	s2,0xd
    80001afe:	1a690913          	addi	s2,s2,422 # 8000eca0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b02:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b04:	00006997          	auipc	s3,0x6
    80001b08:	6fc98993          	addi	s3,s3,1788 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001b0c:	00006a97          	auipc	s5,0x6
    80001b10:	6fca8a93          	addi	s5,s5,1788 # 80008208 <etext+0x208>
    printf("\n");
    80001b14:	00007a17          	auipc	s4,0x7
    80001b18:	d9ca0a13          	addi	s4,s4,-612 # 800088b0 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b1c:	00006b97          	auipc	s7,0x6
    80001b20:	72cb8b93          	addi	s7,s7,1836 # 80008248 <states.0>
    80001b24:	a00d                	j	80001b46 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b26:	ed86a583          	lw	a1,-296(a3)
    80001b2a:	8556                	mv	a0,s5
    80001b2c:	00004097          	auipc	ra,0x4
    80001b30:	7ae080e7          	jalr	1966(ra) # 800062da <printf>
    printf("\n");
    80001b34:	8552                	mv	a0,s4
    80001b36:	00004097          	auipc	ra,0x4
    80001b3a:	7a4080e7          	jalr	1956(ra) # 800062da <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b3e:	17048493          	addi	s1,s1,368
    80001b42:	03248263          	beq	s1,s2,80001b66 <procdump+0x9a>
    if(p->state == UNUSED)
    80001b46:	86a6                	mv	a3,s1
    80001b48:	ec04a783          	lw	a5,-320(s1)
    80001b4c:	dbed                	beqz	a5,80001b3e <procdump+0x72>
      state = "???";
    80001b4e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b50:	fcfb6be3          	bltu	s6,a5,80001b26 <procdump+0x5a>
    80001b54:	02079713          	slli	a4,a5,0x20
    80001b58:	01d75793          	srli	a5,a4,0x1d
    80001b5c:	97de                	add	a5,a5,s7
    80001b5e:	6390                	ld	a2,0(a5)
    80001b60:	f279                	bnez	a2,80001b26 <procdump+0x5a>
      state = "???";
    80001b62:	864e                	mv	a2,s3
    80001b64:	b7c9                	j	80001b26 <procdump+0x5a>
  }
}
    80001b66:	60a6                	ld	ra,72(sp)
    80001b68:	6406                	ld	s0,64(sp)
    80001b6a:	74e2                	ld	s1,56(sp)
    80001b6c:	7942                	ld	s2,48(sp)
    80001b6e:	79a2                	ld	s3,40(sp)
    80001b70:	7a02                	ld	s4,32(sp)
    80001b72:	6ae2                	ld	s5,24(sp)
    80001b74:	6b42                	ld	s6,16(sp)
    80001b76:	6ba2                	ld	s7,8(sp)
    80001b78:	6161                	addi	sp,sp,80
    80001b7a:	8082                	ret

0000000080001b7c <swtch>:
    80001b7c:	00153023          	sd	ra,0(a0)
    80001b80:	00253423          	sd	sp,8(a0)
    80001b84:	e900                	sd	s0,16(a0)
    80001b86:	ed04                	sd	s1,24(a0)
    80001b88:	03253023          	sd	s2,32(a0)
    80001b8c:	03353423          	sd	s3,40(a0)
    80001b90:	03453823          	sd	s4,48(a0)
    80001b94:	03553c23          	sd	s5,56(a0)
    80001b98:	05653023          	sd	s6,64(a0)
    80001b9c:	05753423          	sd	s7,72(a0)
    80001ba0:	05853823          	sd	s8,80(a0)
    80001ba4:	05953c23          	sd	s9,88(a0)
    80001ba8:	07a53023          	sd	s10,96(a0)
    80001bac:	07b53423          	sd	s11,104(a0)
    80001bb0:	0005b083          	ld	ra,0(a1)
    80001bb4:	0085b103          	ld	sp,8(a1)
    80001bb8:	6980                	ld	s0,16(a1)
    80001bba:	6d84                	ld	s1,24(a1)
    80001bbc:	0205b903          	ld	s2,32(a1)
    80001bc0:	0285b983          	ld	s3,40(a1)
    80001bc4:	0305ba03          	ld	s4,48(a1)
    80001bc8:	0385ba83          	ld	s5,56(a1)
    80001bcc:	0405bb03          	ld	s6,64(a1)
    80001bd0:	0485bb83          	ld	s7,72(a1)
    80001bd4:	0505bc03          	ld	s8,80(a1)
    80001bd8:	0585bc83          	ld	s9,88(a1)
    80001bdc:	0605bd03          	ld	s10,96(a1)
    80001be0:	0685bd83          	ld	s11,104(a1)
    80001be4:	8082                	ret

0000000080001be6 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001be6:	1141                	addi	sp,sp,-16
    80001be8:	e406                	sd	ra,8(sp)
    80001bea:	e022                	sd	s0,0(sp)
    80001bec:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001bee:	00006597          	auipc	a1,0x6
    80001bf2:	68a58593          	addi	a1,a1,1674 # 80008278 <states.0+0x30>
    80001bf6:	0000d517          	auipc	a0,0xd
    80001bfa:	f4a50513          	addi	a0,a0,-182 # 8000eb40 <tickslock>
    80001bfe:	00005097          	auipc	ra,0x5
    80001c02:	d30080e7          	jalr	-720(ra) # 8000692e <initlock>
}
    80001c06:	60a2                	ld	ra,8(sp)
    80001c08:	6402                	ld	s0,0(sp)
    80001c0a:	0141                	addi	sp,sp,16
    80001c0c:	8082                	ret

0000000080001c0e <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c0e:	1141                	addi	sp,sp,-16
    80001c10:	e422                	sd	s0,8(sp)
    80001c12:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c14:	00003797          	auipc	a5,0x3
    80001c18:	77c78793          	addi	a5,a5,1916 # 80005390 <kernelvec>
    80001c1c:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c20:	6422                	ld	s0,8(sp)
    80001c22:	0141                	addi	sp,sp,16
    80001c24:	8082                	ret

0000000080001c26 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c26:	1141                	addi	sp,sp,-16
    80001c28:	e406                	sd	ra,8(sp)
    80001c2a:	e022                	sd	s0,0(sp)
    80001c2c:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c2e:	fffff097          	auipc	ra,0xfffff
    80001c32:	342080e7          	jalr	834(ra) # 80000f70 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c36:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c3a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c3c:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001c40:	00005697          	auipc	a3,0x5
    80001c44:	3c068693          	addi	a3,a3,960 # 80007000 <_trampoline>
    80001c48:	00005717          	auipc	a4,0x5
    80001c4c:	3b870713          	addi	a4,a4,952 # 80007000 <_trampoline>
    80001c50:	8f15                	sub	a4,a4,a3
    80001c52:	040007b7          	lui	a5,0x4000
    80001c56:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001c58:	07b2                	slli	a5,a5,0xc
    80001c5a:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c5c:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c60:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c62:	18002673          	csrr	a2,satp
    80001c66:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c68:	7130                	ld	a2,96(a0)
    80001c6a:	6538                	ld	a4,72(a0)
    80001c6c:	6585                	lui	a1,0x1
    80001c6e:	972e                	add	a4,a4,a1
    80001c70:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c72:	7138                	ld	a4,96(a0)
    80001c74:	00000617          	auipc	a2,0x0
    80001c78:	13060613          	addi	a2,a2,304 # 80001da4 <usertrap>
    80001c7c:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c7e:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c80:	8612                	mv	a2,tp
    80001c82:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c84:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c88:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c8c:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c90:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c94:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c96:	6f18                	ld	a4,24(a4)
    80001c98:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c9c:	6d28                	ld	a0,88(a0)
    80001c9e:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001ca0:	00005717          	auipc	a4,0x5
    80001ca4:	3fc70713          	addi	a4,a4,1020 # 8000709c <userret>
    80001ca8:	8f15                	sub	a4,a4,a3
    80001caa:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001cac:	577d                	li	a4,-1
    80001cae:	177e                	slli	a4,a4,0x3f
    80001cb0:	8d59                	or	a0,a0,a4
    80001cb2:	9782                	jalr	a5
}
    80001cb4:	60a2                	ld	ra,8(sp)
    80001cb6:	6402                	ld	s0,0(sp)
    80001cb8:	0141                	addi	sp,sp,16
    80001cba:	8082                	ret

0000000080001cbc <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001cbc:	1101                	addi	sp,sp,-32
    80001cbe:	ec06                	sd	ra,24(sp)
    80001cc0:	e822                	sd	s0,16(sp)
    80001cc2:	e426                	sd	s1,8(sp)
    80001cc4:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001cc6:	0000d497          	auipc	s1,0xd
    80001cca:	e7a48493          	addi	s1,s1,-390 # 8000eb40 <tickslock>
    80001cce:	8526                	mv	a0,s1
    80001cd0:	00005097          	auipc	ra,0x5
    80001cd4:	ae2080e7          	jalr	-1310(ra) # 800067b2 <acquire>
  ticks++;
    80001cd8:	00007517          	auipc	a0,0x7
    80001cdc:	cd050513          	addi	a0,a0,-816 # 800089a8 <ticks>
    80001ce0:	411c                	lw	a5,0(a0)
    80001ce2:	2785                	addiw	a5,a5,1
    80001ce4:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001ce6:	00000097          	auipc	ra,0x0
    80001cea:	996080e7          	jalr	-1642(ra) # 8000167c <wakeup>
  release(&tickslock);
    80001cee:	8526                	mv	a0,s1
    80001cf0:	00005097          	auipc	ra,0x5
    80001cf4:	b92080e7          	jalr	-1134(ra) # 80006882 <release>
}
    80001cf8:	60e2                	ld	ra,24(sp)
    80001cfa:	6442                	ld	s0,16(sp)
    80001cfc:	64a2                	ld	s1,8(sp)
    80001cfe:	6105                	addi	sp,sp,32
    80001d00:	8082                	ret

0000000080001d02 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d02:	1101                	addi	sp,sp,-32
    80001d04:	ec06                	sd	ra,24(sp)
    80001d06:	e822                	sd	s0,16(sp)
    80001d08:	e426                	sd	s1,8(sp)
    80001d0a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d0c:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d10:	00074d63          	bltz	a4,80001d2a <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d14:	57fd                	li	a5,-1
    80001d16:	17fe                	slli	a5,a5,0x3f
    80001d18:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d1a:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d1c:	06f70363          	beq	a4,a5,80001d82 <devintr+0x80>
  }
}
    80001d20:	60e2                	ld	ra,24(sp)
    80001d22:	6442                	ld	s0,16(sp)
    80001d24:	64a2                	ld	s1,8(sp)
    80001d26:	6105                	addi	sp,sp,32
    80001d28:	8082                	ret
     (scause & 0xff) == 9){
    80001d2a:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001d2e:	46a5                	li	a3,9
    80001d30:	fed792e3          	bne	a5,a3,80001d14 <devintr+0x12>
    int irq = plic_claim();
    80001d34:	00003097          	auipc	ra,0x3
    80001d38:	764080e7          	jalr	1892(ra) # 80005498 <plic_claim>
    80001d3c:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d3e:	47a9                	li	a5,10
    80001d40:	02f50763          	beq	a0,a5,80001d6e <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001d44:	4785                	li	a5,1
    80001d46:	02f50963          	beq	a0,a5,80001d78 <devintr+0x76>
    return 1;
    80001d4a:	4505                	li	a0,1
    } else if(irq){
    80001d4c:	d8f1                	beqz	s1,80001d20 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d4e:	85a6                	mv	a1,s1
    80001d50:	00006517          	auipc	a0,0x6
    80001d54:	53050513          	addi	a0,a0,1328 # 80008280 <states.0+0x38>
    80001d58:	00004097          	auipc	ra,0x4
    80001d5c:	582080e7          	jalr	1410(ra) # 800062da <printf>
      plic_complete(irq);
    80001d60:	8526                	mv	a0,s1
    80001d62:	00003097          	auipc	ra,0x3
    80001d66:	75a080e7          	jalr	1882(ra) # 800054bc <plic_complete>
    return 1;
    80001d6a:	4505                	li	a0,1
    80001d6c:	bf55                	j	80001d20 <devintr+0x1e>
      uartintr();
    80001d6e:	00005097          	auipc	ra,0x5
    80001d72:	97a080e7          	jalr	-1670(ra) # 800066e8 <uartintr>
    80001d76:	b7ed                	j	80001d60 <devintr+0x5e>
      virtio_disk_intr();
    80001d78:	00004097          	auipc	ra,0x4
    80001d7c:	c0c080e7          	jalr	-1012(ra) # 80005984 <virtio_disk_intr>
    80001d80:	b7c5                	j	80001d60 <devintr+0x5e>
    if(cpuid() == 0){
    80001d82:	fffff097          	auipc	ra,0xfffff
    80001d86:	1c2080e7          	jalr	450(ra) # 80000f44 <cpuid>
    80001d8a:	c901                	beqz	a0,80001d9a <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d8c:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d90:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d92:	14479073          	csrw	sip,a5
    return 2;
    80001d96:	4509                	li	a0,2
    80001d98:	b761                	j	80001d20 <devintr+0x1e>
      clockintr();
    80001d9a:	00000097          	auipc	ra,0x0
    80001d9e:	f22080e7          	jalr	-222(ra) # 80001cbc <clockintr>
    80001da2:	b7ed                	j	80001d8c <devintr+0x8a>

0000000080001da4 <usertrap>:
{
    80001da4:	1101                	addi	sp,sp,-32
    80001da6:	ec06                	sd	ra,24(sp)
    80001da8:	e822                	sd	s0,16(sp)
    80001daa:	e426                	sd	s1,8(sp)
    80001dac:	e04a                	sd	s2,0(sp)
    80001dae:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001db0:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001db4:	1007f793          	andi	a5,a5,256
    80001db8:	e3b1                	bnez	a5,80001dfc <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001dba:	00003797          	auipc	a5,0x3
    80001dbe:	5d678793          	addi	a5,a5,1494 # 80005390 <kernelvec>
    80001dc2:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001dc6:	fffff097          	auipc	ra,0xfffff
    80001dca:	1aa080e7          	jalr	426(ra) # 80000f70 <myproc>
    80001dce:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001dd0:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dd2:	14102773          	csrr	a4,sepc
    80001dd6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dd8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001ddc:	47a1                	li	a5,8
    80001dde:	02f70763          	beq	a4,a5,80001e0c <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001de2:	00000097          	auipc	ra,0x0
    80001de6:	f20080e7          	jalr	-224(ra) # 80001d02 <devintr>
    80001dea:	892a                	mv	s2,a0
    80001dec:	c151                	beqz	a0,80001e70 <usertrap+0xcc>
  if(killed(p))
    80001dee:	8526                	mv	a0,s1
    80001df0:	00000097          	auipc	ra,0x0
    80001df4:	ad0080e7          	jalr	-1328(ra) # 800018c0 <killed>
    80001df8:	c929                	beqz	a0,80001e4a <usertrap+0xa6>
    80001dfa:	a099                	j	80001e40 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001dfc:	00006517          	auipc	a0,0x6
    80001e00:	4a450513          	addi	a0,a0,1188 # 800082a0 <states.0+0x58>
    80001e04:	00004097          	auipc	ra,0x4
    80001e08:	48c080e7          	jalr	1164(ra) # 80006290 <panic>
    if(killed(p))
    80001e0c:	00000097          	auipc	ra,0x0
    80001e10:	ab4080e7          	jalr	-1356(ra) # 800018c0 <killed>
    80001e14:	e921                	bnez	a0,80001e64 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001e16:	70b8                	ld	a4,96(s1)
    80001e18:	6f1c                	ld	a5,24(a4)
    80001e1a:	0791                	addi	a5,a5,4
    80001e1c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e1e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e22:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e26:	10079073          	csrw	sstatus,a5
    syscall();
    80001e2a:	00000097          	auipc	ra,0x0
    80001e2e:	2d4080e7          	jalr	724(ra) # 800020fe <syscall>
  if(killed(p))
    80001e32:	8526                	mv	a0,s1
    80001e34:	00000097          	auipc	ra,0x0
    80001e38:	a8c080e7          	jalr	-1396(ra) # 800018c0 <killed>
    80001e3c:	c911                	beqz	a0,80001e50 <usertrap+0xac>
    80001e3e:	4901                	li	s2,0
    exit(-1);
    80001e40:	557d                	li	a0,-1
    80001e42:	00000097          	auipc	ra,0x0
    80001e46:	90a080e7          	jalr	-1782(ra) # 8000174c <exit>
  if(which_dev == 2)
    80001e4a:	4789                	li	a5,2
    80001e4c:	04f90f63          	beq	s2,a5,80001eaa <usertrap+0x106>
  usertrapret();
    80001e50:	00000097          	auipc	ra,0x0
    80001e54:	dd6080e7          	jalr	-554(ra) # 80001c26 <usertrapret>
}
    80001e58:	60e2                	ld	ra,24(sp)
    80001e5a:	6442                	ld	s0,16(sp)
    80001e5c:	64a2                	ld	s1,8(sp)
    80001e5e:	6902                	ld	s2,0(sp)
    80001e60:	6105                	addi	sp,sp,32
    80001e62:	8082                	ret
      exit(-1);
    80001e64:	557d                	li	a0,-1
    80001e66:	00000097          	auipc	ra,0x0
    80001e6a:	8e6080e7          	jalr	-1818(ra) # 8000174c <exit>
    80001e6e:	b765                	j	80001e16 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e70:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e74:	5c90                	lw	a2,56(s1)
    80001e76:	00006517          	auipc	a0,0x6
    80001e7a:	44a50513          	addi	a0,a0,1098 # 800082c0 <states.0+0x78>
    80001e7e:	00004097          	auipc	ra,0x4
    80001e82:	45c080e7          	jalr	1116(ra) # 800062da <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e86:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e8a:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e8e:	00006517          	auipc	a0,0x6
    80001e92:	46250513          	addi	a0,a0,1122 # 800082f0 <states.0+0xa8>
    80001e96:	00004097          	auipc	ra,0x4
    80001e9a:	444080e7          	jalr	1092(ra) # 800062da <printf>
    setkilled(p);
    80001e9e:	8526                	mv	a0,s1
    80001ea0:	00000097          	auipc	ra,0x0
    80001ea4:	9f4080e7          	jalr	-1548(ra) # 80001894 <setkilled>
    80001ea8:	b769                	j	80001e32 <usertrap+0x8e>
    yield();
    80001eaa:	fffff097          	auipc	ra,0xfffff
    80001eae:	732080e7          	jalr	1842(ra) # 800015dc <yield>
    80001eb2:	bf79                	j	80001e50 <usertrap+0xac>

0000000080001eb4 <kerneltrap>:
{
    80001eb4:	7179                	addi	sp,sp,-48
    80001eb6:	f406                	sd	ra,40(sp)
    80001eb8:	f022                	sd	s0,32(sp)
    80001eba:	ec26                	sd	s1,24(sp)
    80001ebc:	e84a                	sd	s2,16(sp)
    80001ebe:	e44e                	sd	s3,8(sp)
    80001ec0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ec2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ec6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001eca:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001ece:	1004f793          	andi	a5,s1,256
    80001ed2:	cb85                	beqz	a5,80001f02 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ed4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ed8:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001eda:	ef85                	bnez	a5,80001f12 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001edc:	00000097          	auipc	ra,0x0
    80001ee0:	e26080e7          	jalr	-474(ra) # 80001d02 <devintr>
    80001ee4:	cd1d                	beqz	a0,80001f22 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ee6:	4789                	li	a5,2
    80001ee8:	06f50a63          	beq	a0,a5,80001f5c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001eec:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ef0:	10049073          	csrw	sstatus,s1
}
    80001ef4:	70a2                	ld	ra,40(sp)
    80001ef6:	7402                	ld	s0,32(sp)
    80001ef8:	64e2                	ld	s1,24(sp)
    80001efa:	6942                	ld	s2,16(sp)
    80001efc:	69a2                	ld	s3,8(sp)
    80001efe:	6145                	addi	sp,sp,48
    80001f00:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f02:	00006517          	auipc	a0,0x6
    80001f06:	40e50513          	addi	a0,a0,1038 # 80008310 <states.0+0xc8>
    80001f0a:	00004097          	auipc	ra,0x4
    80001f0e:	386080e7          	jalr	902(ra) # 80006290 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f12:	00006517          	auipc	a0,0x6
    80001f16:	42650513          	addi	a0,a0,1062 # 80008338 <states.0+0xf0>
    80001f1a:	00004097          	auipc	ra,0x4
    80001f1e:	376080e7          	jalr	886(ra) # 80006290 <panic>
    printf("scause %p\n", scause);
    80001f22:	85ce                	mv	a1,s3
    80001f24:	00006517          	auipc	a0,0x6
    80001f28:	43450513          	addi	a0,a0,1076 # 80008358 <states.0+0x110>
    80001f2c:	00004097          	auipc	ra,0x4
    80001f30:	3ae080e7          	jalr	942(ra) # 800062da <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f34:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f38:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f3c:	00006517          	auipc	a0,0x6
    80001f40:	42c50513          	addi	a0,a0,1068 # 80008368 <states.0+0x120>
    80001f44:	00004097          	auipc	ra,0x4
    80001f48:	396080e7          	jalr	918(ra) # 800062da <printf>
    panic("kerneltrap");
    80001f4c:	00006517          	auipc	a0,0x6
    80001f50:	43450513          	addi	a0,a0,1076 # 80008380 <states.0+0x138>
    80001f54:	00004097          	auipc	ra,0x4
    80001f58:	33c080e7          	jalr	828(ra) # 80006290 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f5c:	fffff097          	auipc	ra,0xfffff
    80001f60:	014080e7          	jalr	20(ra) # 80000f70 <myproc>
    80001f64:	d541                	beqz	a0,80001eec <kerneltrap+0x38>
    80001f66:	fffff097          	auipc	ra,0xfffff
    80001f6a:	00a080e7          	jalr	10(ra) # 80000f70 <myproc>
    80001f6e:	5118                	lw	a4,32(a0)
    80001f70:	4791                	li	a5,4
    80001f72:	f6f71de3          	bne	a4,a5,80001eec <kerneltrap+0x38>
    yield();
    80001f76:	fffff097          	auipc	ra,0xfffff
    80001f7a:	666080e7          	jalr	1638(ra) # 800015dc <yield>
    80001f7e:	b7bd                	j	80001eec <kerneltrap+0x38>

0000000080001f80 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f80:	1101                	addi	sp,sp,-32
    80001f82:	ec06                	sd	ra,24(sp)
    80001f84:	e822                	sd	s0,16(sp)
    80001f86:	e426                	sd	s1,8(sp)
    80001f88:	1000                	addi	s0,sp,32
    80001f8a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f8c:	fffff097          	auipc	ra,0xfffff
    80001f90:	fe4080e7          	jalr	-28(ra) # 80000f70 <myproc>
  switch (n) {
    80001f94:	4795                	li	a5,5
    80001f96:	0497e163          	bltu	a5,s1,80001fd8 <argraw+0x58>
    80001f9a:	048a                	slli	s1,s1,0x2
    80001f9c:	00006717          	auipc	a4,0x6
    80001fa0:	41c70713          	addi	a4,a4,1052 # 800083b8 <states.0+0x170>
    80001fa4:	94ba                	add	s1,s1,a4
    80001fa6:	409c                	lw	a5,0(s1)
    80001fa8:	97ba                	add	a5,a5,a4
    80001faa:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001fac:	713c                	ld	a5,96(a0)
    80001fae:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001fb0:	60e2                	ld	ra,24(sp)
    80001fb2:	6442                	ld	s0,16(sp)
    80001fb4:	64a2                	ld	s1,8(sp)
    80001fb6:	6105                	addi	sp,sp,32
    80001fb8:	8082                	ret
    return p->trapframe->a1;
    80001fba:	713c                	ld	a5,96(a0)
    80001fbc:	7fa8                	ld	a0,120(a5)
    80001fbe:	bfcd                	j	80001fb0 <argraw+0x30>
    return p->trapframe->a2;
    80001fc0:	713c                	ld	a5,96(a0)
    80001fc2:	63c8                	ld	a0,128(a5)
    80001fc4:	b7f5                	j	80001fb0 <argraw+0x30>
    return p->trapframe->a3;
    80001fc6:	713c                	ld	a5,96(a0)
    80001fc8:	67c8                	ld	a0,136(a5)
    80001fca:	b7dd                	j	80001fb0 <argraw+0x30>
    return p->trapframe->a4;
    80001fcc:	713c                	ld	a5,96(a0)
    80001fce:	6bc8                	ld	a0,144(a5)
    80001fd0:	b7c5                	j	80001fb0 <argraw+0x30>
    return p->trapframe->a5;
    80001fd2:	713c                	ld	a5,96(a0)
    80001fd4:	6fc8                	ld	a0,152(a5)
    80001fd6:	bfe9                	j	80001fb0 <argraw+0x30>
  panic("argraw");
    80001fd8:	00006517          	auipc	a0,0x6
    80001fdc:	3b850513          	addi	a0,a0,952 # 80008390 <states.0+0x148>
    80001fe0:	00004097          	auipc	ra,0x4
    80001fe4:	2b0080e7          	jalr	688(ra) # 80006290 <panic>

0000000080001fe8 <fetchaddr>:
{
    80001fe8:	1101                	addi	sp,sp,-32
    80001fea:	ec06                	sd	ra,24(sp)
    80001fec:	e822                	sd	s0,16(sp)
    80001fee:	e426                	sd	s1,8(sp)
    80001ff0:	e04a                	sd	s2,0(sp)
    80001ff2:	1000                	addi	s0,sp,32
    80001ff4:	84aa                	mv	s1,a0
    80001ff6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ff8:	fffff097          	auipc	ra,0xfffff
    80001ffc:	f78080e7          	jalr	-136(ra) # 80000f70 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002000:	693c                	ld	a5,80(a0)
    80002002:	02f4f863          	bgeu	s1,a5,80002032 <fetchaddr+0x4a>
    80002006:	00848713          	addi	a4,s1,8
    8000200a:	02e7e663          	bltu	a5,a4,80002036 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000200e:	46a1                	li	a3,8
    80002010:	8626                	mv	a2,s1
    80002012:	85ca                	mv	a1,s2
    80002014:	6d28                	ld	a0,88(a0)
    80002016:	fffff097          	auipc	ra,0xfffff
    8000201a:	ca6080e7          	jalr	-858(ra) # 80000cbc <copyin>
    8000201e:	00a03533          	snez	a0,a0
    80002022:	40a00533          	neg	a0,a0
}
    80002026:	60e2                	ld	ra,24(sp)
    80002028:	6442                	ld	s0,16(sp)
    8000202a:	64a2                	ld	s1,8(sp)
    8000202c:	6902                	ld	s2,0(sp)
    8000202e:	6105                	addi	sp,sp,32
    80002030:	8082                	ret
    return -1;
    80002032:	557d                	li	a0,-1
    80002034:	bfcd                	j	80002026 <fetchaddr+0x3e>
    80002036:	557d                	li	a0,-1
    80002038:	b7fd                	j	80002026 <fetchaddr+0x3e>

000000008000203a <fetchstr>:
{
    8000203a:	7179                	addi	sp,sp,-48
    8000203c:	f406                	sd	ra,40(sp)
    8000203e:	f022                	sd	s0,32(sp)
    80002040:	ec26                	sd	s1,24(sp)
    80002042:	e84a                	sd	s2,16(sp)
    80002044:	e44e                	sd	s3,8(sp)
    80002046:	1800                	addi	s0,sp,48
    80002048:	892a                	mv	s2,a0
    8000204a:	84ae                	mv	s1,a1
    8000204c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000204e:	fffff097          	auipc	ra,0xfffff
    80002052:	f22080e7          	jalr	-222(ra) # 80000f70 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002056:	86ce                	mv	a3,s3
    80002058:	864a                	mv	a2,s2
    8000205a:	85a6                	mv	a1,s1
    8000205c:	6d28                	ld	a0,88(a0)
    8000205e:	fffff097          	auipc	ra,0xfffff
    80002062:	cec080e7          	jalr	-788(ra) # 80000d4a <copyinstr>
    80002066:	00054e63          	bltz	a0,80002082 <fetchstr+0x48>
  return strlen(buf);
    8000206a:	8526                	mv	a0,s1
    8000206c:	ffffe097          	auipc	ra,0xffffe
    80002070:	396080e7          	jalr	918(ra) # 80000402 <strlen>
}
    80002074:	70a2                	ld	ra,40(sp)
    80002076:	7402                	ld	s0,32(sp)
    80002078:	64e2                	ld	s1,24(sp)
    8000207a:	6942                	ld	s2,16(sp)
    8000207c:	69a2                	ld	s3,8(sp)
    8000207e:	6145                	addi	sp,sp,48
    80002080:	8082                	ret
    return -1;
    80002082:	557d                	li	a0,-1
    80002084:	bfc5                	j	80002074 <fetchstr+0x3a>

0000000080002086 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002086:	1101                	addi	sp,sp,-32
    80002088:	ec06                	sd	ra,24(sp)
    8000208a:	e822                	sd	s0,16(sp)
    8000208c:	e426                	sd	s1,8(sp)
    8000208e:	1000                	addi	s0,sp,32
    80002090:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002092:	00000097          	auipc	ra,0x0
    80002096:	eee080e7          	jalr	-274(ra) # 80001f80 <argraw>
    8000209a:	c088                	sw	a0,0(s1)
}
    8000209c:	60e2                	ld	ra,24(sp)
    8000209e:	6442                	ld	s0,16(sp)
    800020a0:	64a2                	ld	s1,8(sp)
    800020a2:	6105                	addi	sp,sp,32
    800020a4:	8082                	ret

00000000800020a6 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800020a6:	1101                	addi	sp,sp,-32
    800020a8:	ec06                	sd	ra,24(sp)
    800020aa:	e822                	sd	s0,16(sp)
    800020ac:	e426                	sd	s1,8(sp)
    800020ae:	1000                	addi	s0,sp,32
    800020b0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020b2:	00000097          	auipc	ra,0x0
    800020b6:	ece080e7          	jalr	-306(ra) # 80001f80 <argraw>
    800020ba:	e088                	sd	a0,0(s1)
}
    800020bc:	60e2                	ld	ra,24(sp)
    800020be:	6442                	ld	s0,16(sp)
    800020c0:	64a2                	ld	s1,8(sp)
    800020c2:	6105                	addi	sp,sp,32
    800020c4:	8082                	ret

00000000800020c6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800020c6:	7179                	addi	sp,sp,-48
    800020c8:	f406                	sd	ra,40(sp)
    800020ca:	f022                	sd	s0,32(sp)
    800020cc:	ec26                	sd	s1,24(sp)
    800020ce:	e84a                	sd	s2,16(sp)
    800020d0:	1800                	addi	s0,sp,48
    800020d2:	84ae                	mv	s1,a1
    800020d4:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800020d6:	fd840593          	addi	a1,s0,-40
    800020da:	00000097          	auipc	ra,0x0
    800020de:	fcc080e7          	jalr	-52(ra) # 800020a6 <argaddr>
  return fetchstr(addr, buf, max);
    800020e2:	864a                	mv	a2,s2
    800020e4:	85a6                	mv	a1,s1
    800020e6:	fd843503          	ld	a0,-40(s0)
    800020ea:	00000097          	auipc	ra,0x0
    800020ee:	f50080e7          	jalr	-176(ra) # 8000203a <fetchstr>
}
    800020f2:	70a2                	ld	ra,40(sp)
    800020f4:	7402                	ld	s0,32(sp)
    800020f6:	64e2                	ld	s1,24(sp)
    800020f8:	6942                	ld	s2,16(sp)
    800020fa:	6145                	addi	sp,sp,48
    800020fc:	8082                	ret

00000000800020fe <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    800020fe:	1101                	addi	sp,sp,-32
    80002100:	ec06                	sd	ra,24(sp)
    80002102:	e822                	sd	s0,16(sp)
    80002104:	e426                	sd	s1,8(sp)
    80002106:	e04a                	sd	s2,0(sp)
    80002108:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000210a:	fffff097          	auipc	ra,0xfffff
    8000210e:	e66080e7          	jalr	-410(ra) # 80000f70 <myproc>
    80002112:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002114:	06053903          	ld	s2,96(a0)
    80002118:	0a893783          	ld	a5,168(s2)
    8000211c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002120:	37fd                	addiw	a5,a5,-1
    80002122:	4751                	li	a4,20
    80002124:	00f76f63          	bltu	a4,a5,80002142 <syscall+0x44>
    80002128:	00369713          	slli	a4,a3,0x3
    8000212c:	00006797          	auipc	a5,0x6
    80002130:	2a478793          	addi	a5,a5,676 # 800083d0 <syscalls>
    80002134:	97ba                	add	a5,a5,a4
    80002136:	639c                	ld	a5,0(a5)
    80002138:	c789                	beqz	a5,80002142 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000213a:	9782                	jalr	a5
    8000213c:	06a93823          	sd	a0,112(s2)
    80002140:	a839                	j	8000215e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002142:	16048613          	addi	a2,s1,352
    80002146:	5c8c                	lw	a1,56(s1)
    80002148:	00006517          	auipc	a0,0x6
    8000214c:	25050513          	addi	a0,a0,592 # 80008398 <states.0+0x150>
    80002150:	00004097          	auipc	ra,0x4
    80002154:	18a080e7          	jalr	394(ra) # 800062da <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002158:	70bc                	ld	a5,96(s1)
    8000215a:	577d                	li	a4,-1
    8000215c:	fbb8                	sd	a4,112(a5)
  }
}
    8000215e:	60e2                	ld	ra,24(sp)
    80002160:	6442                	ld	s0,16(sp)
    80002162:	64a2                	ld	s1,8(sp)
    80002164:	6902                	ld	s2,0(sp)
    80002166:	6105                	addi	sp,sp,32
    80002168:	8082                	ret

000000008000216a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000216a:	1101                	addi	sp,sp,-32
    8000216c:	ec06                	sd	ra,24(sp)
    8000216e:	e822                	sd	s0,16(sp)
    80002170:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002172:	fec40593          	addi	a1,s0,-20
    80002176:	4501                	li	a0,0
    80002178:	00000097          	auipc	ra,0x0
    8000217c:	f0e080e7          	jalr	-242(ra) # 80002086 <argint>
  exit(n);
    80002180:	fec42503          	lw	a0,-20(s0)
    80002184:	fffff097          	auipc	ra,0xfffff
    80002188:	5c8080e7          	jalr	1480(ra) # 8000174c <exit>
  return 0;  // not reached
}
    8000218c:	4501                	li	a0,0
    8000218e:	60e2                	ld	ra,24(sp)
    80002190:	6442                	ld	s0,16(sp)
    80002192:	6105                	addi	sp,sp,32
    80002194:	8082                	ret

0000000080002196 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002196:	1141                	addi	sp,sp,-16
    80002198:	e406                	sd	ra,8(sp)
    8000219a:	e022                	sd	s0,0(sp)
    8000219c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000219e:	fffff097          	auipc	ra,0xfffff
    800021a2:	dd2080e7          	jalr	-558(ra) # 80000f70 <myproc>
}
    800021a6:	5d08                	lw	a0,56(a0)
    800021a8:	60a2                	ld	ra,8(sp)
    800021aa:	6402                	ld	s0,0(sp)
    800021ac:	0141                	addi	sp,sp,16
    800021ae:	8082                	ret

00000000800021b0 <sys_fork>:

uint64
sys_fork(void)
{
    800021b0:	1141                	addi	sp,sp,-16
    800021b2:	e406                	sd	ra,8(sp)
    800021b4:	e022                	sd	s0,0(sp)
    800021b6:	0800                	addi	s0,sp,16
  return fork();
    800021b8:	fffff097          	auipc	ra,0xfffff
    800021bc:	16e080e7          	jalr	366(ra) # 80001326 <fork>
}
    800021c0:	60a2                	ld	ra,8(sp)
    800021c2:	6402                	ld	s0,0(sp)
    800021c4:	0141                	addi	sp,sp,16
    800021c6:	8082                	ret

00000000800021c8 <sys_wait>:

uint64
sys_wait(void)
{
    800021c8:	1101                	addi	sp,sp,-32
    800021ca:	ec06                	sd	ra,24(sp)
    800021cc:	e822                	sd	s0,16(sp)
    800021ce:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800021d0:	fe840593          	addi	a1,s0,-24
    800021d4:	4501                	li	a0,0
    800021d6:	00000097          	auipc	ra,0x0
    800021da:	ed0080e7          	jalr	-304(ra) # 800020a6 <argaddr>
  return wait(p);
    800021de:	fe843503          	ld	a0,-24(s0)
    800021e2:	fffff097          	auipc	ra,0xfffff
    800021e6:	710080e7          	jalr	1808(ra) # 800018f2 <wait>
}
    800021ea:	60e2                	ld	ra,24(sp)
    800021ec:	6442                	ld	s0,16(sp)
    800021ee:	6105                	addi	sp,sp,32
    800021f0:	8082                	ret

00000000800021f2 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800021f2:	7179                	addi	sp,sp,-48
    800021f4:	f406                	sd	ra,40(sp)
    800021f6:	f022                	sd	s0,32(sp)
    800021f8:	ec26                	sd	s1,24(sp)
    800021fa:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800021fc:	fdc40593          	addi	a1,s0,-36
    80002200:	4501                	li	a0,0
    80002202:	00000097          	auipc	ra,0x0
    80002206:	e84080e7          	jalr	-380(ra) # 80002086 <argint>
  addr = myproc()->sz;
    8000220a:	fffff097          	auipc	ra,0xfffff
    8000220e:	d66080e7          	jalr	-666(ra) # 80000f70 <myproc>
    80002212:	6924                	ld	s1,80(a0)
  if(growproc(n) < 0)
    80002214:	fdc42503          	lw	a0,-36(s0)
    80002218:	fffff097          	auipc	ra,0xfffff
    8000221c:	0b2080e7          	jalr	178(ra) # 800012ca <growproc>
    80002220:	00054863          	bltz	a0,80002230 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002224:	8526                	mv	a0,s1
    80002226:	70a2                	ld	ra,40(sp)
    80002228:	7402                	ld	s0,32(sp)
    8000222a:	64e2                	ld	s1,24(sp)
    8000222c:	6145                	addi	sp,sp,48
    8000222e:	8082                	ret
    return -1;
    80002230:	54fd                	li	s1,-1
    80002232:	bfcd                	j	80002224 <sys_sbrk+0x32>

0000000080002234 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002234:	7139                	addi	sp,sp,-64
    80002236:	fc06                	sd	ra,56(sp)
    80002238:	f822                	sd	s0,48(sp)
    8000223a:	f426                	sd	s1,40(sp)
    8000223c:	f04a                	sd	s2,32(sp)
    8000223e:	ec4e                	sd	s3,24(sp)
    80002240:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002242:	fcc40593          	addi	a1,s0,-52
    80002246:	4501                	li	a0,0
    80002248:	00000097          	auipc	ra,0x0
    8000224c:	e3e080e7          	jalr	-450(ra) # 80002086 <argint>
  if(n < 0)
    80002250:	fcc42783          	lw	a5,-52(s0)
    80002254:	0607cf63          	bltz	a5,800022d2 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80002258:	0000d517          	auipc	a0,0xd
    8000225c:	8e850513          	addi	a0,a0,-1816 # 8000eb40 <tickslock>
    80002260:	00004097          	auipc	ra,0x4
    80002264:	552080e7          	jalr	1362(ra) # 800067b2 <acquire>
  ticks0 = ticks;
    80002268:	00006917          	auipc	s2,0x6
    8000226c:	74092903          	lw	s2,1856(s2) # 800089a8 <ticks>
  while(ticks - ticks0 < n){
    80002270:	fcc42783          	lw	a5,-52(s0)
    80002274:	cf9d                	beqz	a5,800022b2 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002276:	0000d997          	auipc	s3,0xd
    8000227a:	8ca98993          	addi	s3,s3,-1846 # 8000eb40 <tickslock>
    8000227e:	00006497          	auipc	s1,0x6
    80002282:	72a48493          	addi	s1,s1,1834 # 800089a8 <ticks>
    if(killed(myproc())){
    80002286:	fffff097          	auipc	ra,0xfffff
    8000228a:	cea080e7          	jalr	-790(ra) # 80000f70 <myproc>
    8000228e:	fffff097          	auipc	ra,0xfffff
    80002292:	632080e7          	jalr	1586(ra) # 800018c0 <killed>
    80002296:	e129                	bnez	a0,800022d8 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002298:	85ce                	mv	a1,s3
    8000229a:	8526                	mv	a0,s1
    8000229c:	fffff097          	auipc	ra,0xfffff
    800022a0:	37c080e7          	jalr	892(ra) # 80001618 <sleep>
  while(ticks - ticks0 < n){
    800022a4:	409c                	lw	a5,0(s1)
    800022a6:	412787bb          	subw	a5,a5,s2
    800022aa:	fcc42703          	lw	a4,-52(s0)
    800022ae:	fce7ece3          	bltu	a5,a4,80002286 <sys_sleep+0x52>
  }
  release(&tickslock);
    800022b2:	0000d517          	auipc	a0,0xd
    800022b6:	88e50513          	addi	a0,a0,-1906 # 8000eb40 <tickslock>
    800022ba:	00004097          	auipc	ra,0x4
    800022be:	5c8080e7          	jalr	1480(ra) # 80006882 <release>
  return 0;
    800022c2:	4501                	li	a0,0
}
    800022c4:	70e2                	ld	ra,56(sp)
    800022c6:	7442                	ld	s0,48(sp)
    800022c8:	74a2                	ld	s1,40(sp)
    800022ca:	7902                	ld	s2,32(sp)
    800022cc:	69e2                	ld	s3,24(sp)
    800022ce:	6121                	addi	sp,sp,64
    800022d0:	8082                	ret
    n = 0;
    800022d2:	fc042623          	sw	zero,-52(s0)
    800022d6:	b749                	j	80002258 <sys_sleep+0x24>
      release(&tickslock);
    800022d8:	0000d517          	auipc	a0,0xd
    800022dc:	86850513          	addi	a0,a0,-1944 # 8000eb40 <tickslock>
    800022e0:	00004097          	auipc	ra,0x4
    800022e4:	5a2080e7          	jalr	1442(ra) # 80006882 <release>
      return -1;
    800022e8:	557d                	li	a0,-1
    800022ea:	bfe9                	j	800022c4 <sys_sleep+0x90>

00000000800022ec <sys_kill>:

uint64
sys_kill(void)
{
    800022ec:	1101                	addi	sp,sp,-32
    800022ee:	ec06                	sd	ra,24(sp)
    800022f0:	e822                	sd	s0,16(sp)
    800022f2:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800022f4:	fec40593          	addi	a1,s0,-20
    800022f8:	4501                	li	a0,0
    800022fa:	00000097          	auipc	ra,0x0
    800022fe:	d8c080e7          	jalr	-628(ra) # 80002086 <argint>
  return kill(pid);
    80002302:	fec42503          	lw	a0,-20(s0)
    80002306:	fffff097          	auipc	ra,0xfffff
    8000230a:	51c080e7          	jalr	1308(ra) # 80001822 <kill>
}
    8000230e:	60e2                	ld	ra,24(sp)
    80002310:	6442                	ld	s0,16(sp)
    80002312:	6105                	addi	sp,sp,32
    80002314:	8082                	ret

0000000080002316 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002316:	1101                	addi	sp,sp,-32
    80002318:	ec06                	sd	ra,24(sp)
    8000231a:	e822                	sd	s0,16(sp)
    8000231c:	e426                	sd	s1,8(sp)
    8000231e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002320:	0000d517          	auipc	a0,0xd
    80002324:	82050513          	addi	a0,a0,-2016 # 8000eb40 <tickslock>
    80002328:	00004097          	auipc	ra,0x4
    8000232c:	48a080e7          	jalr	1162(ra) # 800067b2 <acquire>
  xticks = ticks;
    80002330:	00006497          	auipc	s1,0x6
    80002334:	6784a483          	lw	s1,1656(s1) # 800089a8 <ticks>
  release(&tickslock);
    80002338:	0000d517          	auipc	a0,0xd
    8000233c:	80850513          	addi	a0,a0,-2040 # 8000eb40 <tickslock>
    80002340:	00004097          	auipc	ra,0x4
    80002344:	542080e7          	jalr	1346(ra) # 80006882 <release>
  return xticks;
}
    80002348:	02049513          	slli	a0,s1,0x20
    8000234c:	9101                	srli	a0,a0,0x20
    8000234e:	60e2                	ld	ra,24(sp)
    80002350:	6442                	ld	s0,16(sp)
    80002352:	64a2                	ld	s1,8(sp)
    80002354:	6105                	addi	sp,sp,32
    80002356:	8082                	ret

0000000080002358 <hash>:
#define NBUCKET 13 // 哈希桶上限，按理来说只有需要二次哈希时才考虑素数个桶
#define INTMAX 0x7fffffff

// 哈希函数
int hash(uint dev, uint blockno)
{
    80002358:	1141                	addi	sp,sp,-16
    8000235a:	e422                	sd	s0,8(sp)
    8000235c:	0800                	addi	s0,sp,16
    return ((blockno) % NBUCKET);
}
    8000235e:	4535                	li	a0,13
    80002360:	02a5f53b          	remuw	a0,a1,a0
    80002364:	6422                	ld	s0,8(sp)
    80002366:	0141                	addi	sp,sp,16
    80002368:	8082                	ret

000000008000236a <binit>:
    struct buf bucket[NBUCKET];
    struct spinlock bucket_locks[NBUCKET];
} bcache;

void binit(void)
{
    8000236a:	711d                	addi	sp,sp,-96
    8000236c:	ec86                	sd	ra,88(sp)
    8000236e:	e8a2                	sd	s0,80(sp)
    80002370:	e4a6                	sd	s1,72(sp)
    80002372:	e0ca                	sd	s2,64(sp)
    80002374:	fc4e                	sd	s3,56(sp)
    80002376:	f852                	sd	s4,48(sp)
    80002378:	f456                	sd	s5,40(sp)
    8000237a:	1080                	addi	s0,sp,96
    initlock(&bcache.lock, "bcache_lock");
    8000237c:	00006597          	auipc	a1,0x6
    80002380:	10458593          	addi	a1,a1,260 # 80008480 <syscalls+0xb0>
    80002384:	0000c517          	auipc	a0,0xc
    80002388:	7dc50513          	addi	a0,a0,2012 # 8000eb60 <bcache>
    8000238c:	00004097          	auipc	ra,0x4
    80002390:	5a2080e7          	jalr	1442(ra) # 8000692e <initlock>

    // 初始化bucket
    char name[32];
    for (int i = 0; i < NBUCKET; i++) {
    80002394:	00018997          	auipc	s3,0x18
    80002398:	56498993          	addi	s3,s3,1380 # 8001a8f8 <bcache+0xbd98>
    8000239c:	00015917          	auipc	s2,0x15
    800023a0:	c6c90913          	addi	s2,s2,-916 # 80017008 <bcache+0x84a8>
    800023a4:	4481                	li	s1,0
        snprintf(name, 32, "bucket_lock_%d", i);
    800023a6:	00006a97          	auipc	s5,0x6
    800023aa:	0eaa8a93          	addi	s5,s5,234 # 80008490 <syscalls+0xc0>
    for (int i = 0; i < NBUCKET; i++) {
    800023ae:	4a35                	li	s4,13
        snprintf(name, 32, "bucket_lock_%d", i);
    800023b0:	86a6                	mv	a3,s1
    800023b2:	8656                	mv	a2,s5
    800023b4:	02000593          	li	a1,32
    800023b8:	fa040513          	addi	a0,s0,-96
    800023bc:	00004097          	auipc	ra,0x4
    800023c0:	83a080e7          	jalr	-1990(ra) # 80005bf6 <snprintf>
        initlock(&bcache.bucket_locks[i], name);
    800023c4:	fa040593          	addi	a1,s0,-96
    800023c8:	854e                	mv	a0,s3
    800023ca:	00004097          	auipc	ra,0x4
    800023ce:	564080e7          	jalr	1380(ra) # 8000692e <initlock>
        bcache.bucket[i].next = 0;
    800023d2:	00093023          	sd	zero,0(s2)
    for (int i = 0; i < NBUCKET; i++) {
    800023d6:	2485                	addiw	s1,s1,1
    800023d8:	02098993          	addi	s3,s3,32
    800023dc:	46890913          	addi	s2,s2,1128
    800023e0:	fd4498e3          	bne	s1,s4,800023b0 <binit+0x46>
    800023e4:	0000c497          	auipc	s1,0xc
    800023e8:	7ac48493          	addi	s1,s1,1964 # 8000eb90 <bcache+0x30>
    800023ec:	00015a17          	auipc	s4,0x15
    800023f0:	bd4a0a13          	addi	s4,s4,-1068 # 80016fc0 <bcache+0x8460>
    }

    // 初始化buffer
    for (int i = 0; i < NBUF; i++) {
        struct buf *b = &bcache.buf[i]; // 链表头指针
        initsleeplock(&b->lock, "buffer");
    800023f4:	00006997          	auipc	s3,0x6
    800023f8:	0ac98993          	addi	s3,s3,172 # 800084a0 <syscalls+0xd0>
        b->LUtime = 0;
        b->refcnt = 0;
        b->curBucket = 0;

        // 将buffer加入到bucket[0]中
        b->next = bcache.bucket[0].next;
    800023fc:	00014917          	auipc	s2,0x14
    80002400:	76490913          	addi	s2,s2,1892 # 80016b60 <bcache+0x8000>
        initsleeplock(&b->lock, "buffer");
    80002404:	85ce                	mv	a1,s3
    80002406:	8526                	mv	a0,s1
    80002408:	00001097          	auipc	ra,0x1
    8000240c:	71a080e7          	jalr	1818(ra) # 80003b22 <initsleeplock>
        b->LUtime = 0;
    80002410:	4404a823          	sw	zero,1104(s1)
        b->refcnt = 0;
    80002414:	0204ac23          	sw	zero,56(s1)
        b->curBucket = 0;
    80002418:	4404aa23          	sw	zero,1108(s1)
        b->next = bcache.bucket[0].next;
    8000241c:	4a893783          	ld	a5,1192(s2)
    80002420:	e4bc                	sd	a5,72(s1)
        bcache.bucket[0].next = b;
    80002422:	ff048793          	addi	a5,s1,-16
    80002426:	4af93423          	sd	a5,1192(s2)
    for (int i = 0; i < NBUF; i++) {
    8000242a:	46848493          	addi	s1,s1,1128
    8000242e:	fd449be3          	bne	s1,s4,80002404 <binit+0x9a>
    }
}
    80002432:	60e6                	ld	ra,88(sp)
    80002434:	6446                	ld	s0,80(sp)
    80002436:	64a6                	ld	s1,72(sp)
    80002438:	6906                	ld	s2,64(sp)
    8000243a:	79e2                	ld	s3,56(sp)
    8000243c:	7a42                	ld	s4,48(sp)
    8000243e:	7aa2                	ld	s5,40(sp)
    80002440:	6125                	addi	sp,sp,96
    80002442:	8082                	ret

0000000080002444 <bread>:
    }
}

// Return a locked buf with the contents of the indicated block.
struct buf *bread(uint dev, uint blockno)
{
    80002444:	7135                	addi	sp,sp,-160
    80002446:	ed06                	sd	ra,152(sp)
    80002448:	e922                	sd	s0,144(sp)
    8000244a:	e526                	sd	s1,136(sp)
    8000244c:	e14a                	sd	s2,128(sp)
    8000244e:	fcce                	sd	s3,120(sp)
    80002450:	f8d2                	sd	s4,112(sp)
    80002452:	f4d6                	sd	s5,104(sp)
    80002454:	f0da                	sd	s6,96(sp)
    80002456:	ecde                	sd	s7,88(sp)
    80002458:	e8e2                	sd	s8,80(sp)
    8000245a:	e4e6                	sd	s9,72(sp)
    8000245c:	e0ea                	sd	s10,64(sp)
    8000245e:	fc6e                	sd	s11,56(sp)
    80002460:	1100                	addi	s0,sp,160
    80002462:	8b2a                	mv	s6,a0
    80002464:	8c2e                	mv	s8,a1
    return ((blockno) % NBUCKET);
    80002466:	47b5                	li	a5,13
    80002468:	02f5f7bb          	remuw	a5,a1,a5
    8000246c:	f6f42a23          	sw	a5,-140(s0)
    80002470:	0007871b          	sext.w	a4,a5
    80002474:	f6e43423          	sd	a4,-152(s0)
    acquire(&bcache.bucket_locks[index]);
    80002478:	02079913          	slli	s2,a5,0x20
    8000247c:	02095913          	srli	s2,s2,0x20
    80002480:	00591793          	slli	a5,s2,0x5
    80002484:	6731                	lui	a4,0xc
    80002486:	d9870713          	addi	a4,a4,-616 # bd98 <_entry-0x7fff4268>
    8000248a:	97ba                	add	a5,a5,a4
    8000248c:	0000c497          	auipc	s1,0xc
    80002490:	6d448493          	addi	s1,s1,1748 # 8000eb60 <bcache>
    80002494:	97a6                	add	a5,a5,s1
    80002496:	f6f43c23          	sd	a5,-136(s0)
    8000249a:	853e                	mv	a0,a5
    8000249c:	00004097          	auipc	ra,0x4
    800024a0:	316080e7          	jalr	790(ra) # 800067b2 <acquire>
    struct buf *b = bcache.bucket[index].next;
    800024a4:	46800793          	li	a5,1128
    800024a8:	02f90933          	mul	s2,s2,a5
    800024ac:	94ca                	add	s1,s1,s2
    800024ae:	67a1                	lui	a5,0x8
    800024b0:	97a6                	add	a5,a5,s1
    800024b2:	4a87b903          	ld	s2,1192(a5) # 84a8 <_entry-0x7fff7b58>
    while (b) {
    800024b6:	06091d63          	bnez	s2,80002530 <bread+0xec>
    release(&bcache.bucket_locks[index]);
    800024ba:	f7843503          	ld	a0,-136(s0)
    800024be:	00004097          	auipc	ra,0x4
    800024c2:	3c4080e7          	jalr	964(ra) # 80006882 <release>
    acquire(&bcache.lock);
    800024c6:	0000c517          	auipc	a0,0xc
    800024ca:	69a50513          	addi	a0,a0,1690 # 8000eb60 <bcache>
    800024ce:	00004097          	auipc	ra,0x4
    800024d2:	2e4080e7          	jalr	740(ra) # 800067b2 <acquire>
    b = bcache.bucket[index].next;
    800024d6:	f7446783          	lwu	a5,-140(s0)
    800024da:	46800713          	li	a4,1128
    800024de:	02e787b3          	mul	a5,a5,a4
    800024e2:	0000c717          	auipc	a4,0xc
    800024e6:	67e70713          	addi	a4,a4,1662 # 8000eb60 <bcache>
    800024ea:	973e                	add	a4,a4,a5
    800024ec:	67a1                	lui	a5,0x8
    800024ee:	97ba                	add	a5,a5,a4
    800024f0:	4a87b903          	ld	s2,1192(a5) # 84a8 <_entry-0x7fff7b58>
    while (b) {
    800024f4:	06091c63          	bnez	s2,8000256c <bread+0x128>
    800024f8:	00018a17          	auipc	s4,0x18
    800024fc:	400a0a13          	addi	s4,s4,1024 # 8001a8f8 <bcache+0xbd98>
    80002500:	00015997          	auipc	s3,0x15
    80002504:	ab098993          	addi	s3,s3,-1360 # 80016fb0 <bcache+0x8450>
{
    80002508:	80000937          	lui	s2,0x80000
    8000250c:	fff94913          	not	s2,s2
    80002510:	4481                	li	s1,0
    80002512:	5bfd                	li	s7,-1
    80002514:	4a81                	li	s5,0
                found = 1;
    80002516:	4c85                	li	s9,1
            if (curBucket != -1) {
    80002518:	5dfd                	li	s11,-1
                release(&bcache.bucket_locks[curBucket]);
    8000251a:	67b1                	lui	a5,0xc
    8000251c:	d9878793          	addi	a5,a5,-616 # bd98 <_entry-0x7fff4268>
    80002520:	f8f43023          	sd	a5,-128(s0)
    for (int i = 0; i < NBUCKET; i++) {
    80002524:	4d35                	li	s10,13
    80002526:	a8d1                	j	800025fa <bread+0x1b6>
        b = b->next;
    80002528:	05893903          	ld	s2,88(s2) # ffffffff80000058 <end+0xfffffffefffd84c0>
    while (b) {
    8000252c:	f80907e3          	beqz	s2,800024ba <bread+0x76>
        if (b->dev == dev && b->blockno == blockno) {
    80002530:	00892783          	lw	a5,8(s2)
    80002534:	ff679ae3          	bne	a5,s6,80002528 <bread+0xe4>
    80002538:	00c92783          	lw	a5,12(s2)
    8000253c:	ff8796e3          	bne	a5,s8,80002528 <bread+0xe4>
            b->refcnt++;
    80002540:	04892783          	lw	a5,72(s2)
    80002544:	2785                	addiw	a5,a5,1
    80002546:	04f92423          	sw	a5,72(s2)
            release(&bcache.bucket_locks[index]);
    8000254a:	f7843503          	ld	a0,-136(s0)
    8000254e:	00004097          	auipc	ra,0x4
    80002552:	334080e7          	jalr	820(ra) # 80006882 <release>
            acquiresleep(&b->lock);
    80002556:	01090513          	addi	a0,s2,16
    8000255a:	00001097          	auipc	ra,0x1
    8000255e:	602080e7          	jalr	1538(ra) # 80003b5c <acquiresleep>
            return b;
    80002562:	aa0d                	j	80002694 <bread+0x250>
        b = b->next;
    80002564:	05893903          	ld	s2,88(s2)
    while (b) {
    80002568:	f80908e3          	beqz	s2,800024f8 <bread+0xb4>
        if (b->dev == dev && b->blockno == blockno) {
    8000256c:	00892783          	lw	a5,8(s2)
    80002570:	ff679ae3          	bne	a5,s6,80002564 <bread+0x120>
    80002574:	00c92783          	lw	a5,12(s2)
    80002578:	ff8796e3          	bne	a5,s8,80002564 <bread+0x120>
            acquire(&bcache.bucket_locks[index]);
    8000257c:	f7843483          	ld	s1,-136(s0)
    80002580:	8526                	mv	a0,s1
    80002582:	00004097          	auipc	ra,0x4
    80002586:	230080e7          	jalr	560(ra) # 800067b2 <acquire>
            b->refcnt++;
    8000258a:	04892783          	lw	a5,72(s2)
    8000258e:	2785                	addiw	a5,a5,1
    80002590:	04f92423          	sw	a5,72(s2)
            release(&bcache.bucket_locks[index]);
    80002594:	8526                	mv	a0,s1
    80002596:	00004097          	auipc	ra,0x4
    8000259a:	2ec080e7          	jalr	748(ra) # 80006882 <release>
            release(&bcache.lock); // 释放bcache锁
    8000259e:	0000c517          	auipc	a0,0xc
    800025a2:	5c250513          	addi	a0,a0,1474 # 8000eb60 <bcache>
    800025a6:	00004097          	auipc	ra,0x4
    800025aa:	2dc080e7          	jalr	732(ra) # 80006882 <release>
            acquiresleep(&b->lock);
    800025ae:	01090513          	addi	a0,s2,16
    800025b2:	00001097          	auipc	ra,0x1
    800025b6:	5aa080e7          	jalr	1450(ra) # 80003b5c <acquiresleep>
            return b;
    800025ba:	a8e9                	j	80002694 <bread+0x250>
                LUtime = b->next->LUtime;
    800025bc:	4607a903          	lw	s2,1120(a5)
                found = 1;
    800025c0:	84b6                	mv	s1,a3
    800025c2:	8666                	mv	a2,s9
        while (b->next) {
    800025c4:	6fb8                	ld	a4,88(a5)
    800025c6:	86be                	mv	a3,a5
    800025c8:	cf09                	beqz	a4,800025e2 <bread+0x19e>
    800025ca:	87ba                	mv	a5,a4
            if (b->next->refcnt == 0 && LRUb == 0) {
    800025cc:	47b8                	lw	a4,72(a5)
    800025ce:	fb7d                	bnez	a4,800025c4 <bread+0x180>
    800025d0:	d4f5                	beqz	s1,800025bc <bread+0x178>
            else if (b->next->refcnt == 0 && b->next->LUtime < LUtime) {
    800025d2:	4607a703          	lw	a4,1120(a5)
    800025d6:	ff2777e3          	bgeu	a4,s2,800025c4 <bread+0x180>
                LUtime = b->next->LUtime;
    800025da:	893a                	mv	s2,a4
            else if (b->next->refcnt == 0 && b->next->LUtime < LUtime) {
    800025dc:	84b6                	mv	s1,a3
                found = 1;
    800025de:	8666                	mv	a2,s9
    800025e0:	b7d5                	j	800025c4 <bread+0x180>
        if (found) {
    800025e2:	ca31                	beqz	a2,80002636 <bread+0x1f2>
            if (curBucket != -1) {
    800025e4:	03bb9863          	bne	s7,s11,80002614 <bread+0x1d0>
            curBucket = i;
    800025e8:	000a8b9b          	sext.w	s7,s5
    for (int i = 0; i < NBUCKET; i++) {
    800025ec:	2a85                	addiw	s5,s5,1
    800025ee:	020a0a13          	addi	s4,s4,32
    800025f2:	46898993          	addi	s3,s3,1128
    800025f6:	05aa8763          	beq	s5,s10,80002644 <bread+0x200>
        acquire(&bcache.bucket_locks[i]);
    800025fa:	f9443423          	sd	s4,-120(s0)
    800025fe:	8552                	mv	a0,s4
    80002600:	00004097          	auipc	ra,0x4
    80002604:	1b2080e7          	jalr	434(ra) # 800067b2 <acquire>
        b = &bcache.bucket[i];
    80002608:	86ce                	mv	a3,s3
        while (b->next) {
    8000260a:	0589b783          	ld	a5,88(s3)
    8000260e:	c785                	beqz	a5,80002636 <bread+0x1f2>
        int found = 0;
    80002610:	4601                	li	a2,0
    80002612:	bf6d                	j	800025cc <bread+0x188>
                release(&bcache.bucket_locks[curBucket]);
    80002614:	020b9793          	slli	a5,s7,0x20
    80002618:	01b7d513          	srli	a0,a5,0x1b
    8000261c:	f8043783          	ld	a5,-128(s0)
    80002620:	953e                	add	a0,a0,a5
    80002622:	0000c797          	auipc	a5,0xc
    80002626:	53e78793          	addi	a5,a5,1342 # 8000eb60 <bcache>
    8000262a:	953e                	add	a0,a0,a5
    8000262c:	00004097          	auipc	ra,0x4
    80002630:	256080e7          	jalr	598(ra) # 80006882 <release>
    80002634:	bf55                	j	800025e8 <bread+0x1a4>
            release(&bcache.bucket_locks[i]);
    80002636:	f8843503          	ld	a0,-120(s0)
    8000263a:	00004097          	auipc	ra,0x4
    8000263e:	248080e7          	jalr	584(ra) # 80006882 <release>
    80002642:	b76d                	j	800025ec <bread+0x1a8>
    if (LRUb == 0) { // 最终都没有找到一个buffer
    80002644:	c8bd                	beqz	s1,800026ba <bread+0x276>
        struct buf *p = LRUb->next;
    80002646:	0584b903          	ld	s2,88(s1)
        if (curBucket != index) {
    8000264a:	f6843783          	ld	a5,-152(s0)
    8000264e:	06fb9e63          	bne	s7,a5,800026ca <bread+0x286>
        p->dev = dev;
    80002652:	01692423          	sw	s6,8(s2)
        p->blockno = blockno;
    80002656:	01892623          	sw	s8,12(s2)
        p->refcnt = 1;
    8000265a:	4785                	li	a5,1
    8000265c:	04f92423          	sw	a5,72(s2)
        p->valid = 0;
    80002660:	00092023          	sw	zero,0(s2)
        p->curBucket = index;
    80002664:	f7442783          	lw	a5,-140(s0)
    80002668:	46f92223          	sw	a5,1124(s2)
        release(&bcache.bucket_locks[index]); // 释放bucket[index]锁
    8000266c:	f7843503          	ld	a0,-136(s0)
    80002670:	00004097          	auipc	ra,0x4
    80002674:	212080e7          	jalr	530(ra) # 80006882 <release>
        release(&bcache.lock);                // 释放bcache锁
    80002678:	0000c517          	auipc	a0,0xc
    8000267c:	4e850513          	addi	a0,a0,1256 # 8000eb60 <bcache>
    80002680:	00004097          	auipc	ra,0x4
    80002684:	202080e7          	jalr	514(ra) # 80006882 <release>
        acquiresleep(&p->lock);               // 获取LRUb的锁
    80002688:	01090513          	addi	a0,s2,16
    8000268c:	00001097          	auipc	ra,0x1
    80002690:	4d0080e7          	jalr	1232(ra) # 80003b5c <acquiresleep>
    struct buf *b;

    b = bget(dev, blockno);
    if (!b->valid) {
    80002694:	00092783          	lw	a5,0(s2)
    80002698:	c3d9                	beqz	a5,8000271e <bread+0x2da>
        virtio_disk_rw(b, 0);
        b->valid = 1;
    }
    return b;
}
    8000269a:	854a                	mv	a0,s2
    8000269c:	60ea                	ld	ra,152(sp)
    8000269e:	644a                	ld	s0,144(sp)
    800026a0:	64aa                	ld	s1,136(sp)
    800026a2:	690a                	ld	s2,128(sp)
    800026a4:	79e6                	ld	s3,120(sp)
    800026a6:	7a46                	ld	s4,112(sp)
    800026a8:	7aa6                	ld	s5,104(sp)
    800026aa:	7b06                	ld	s6,96(sp)
    800026ac:	6be6                	ld	s7,88(sp)
    800026ae:	6c46                	ld	s8,80(sp)
    800026b0:	6ca6                	ld	s9,72(sp)
    800026b2:	6d06                	ld	s10,64(sp)
    800026b4:	7de2                	ld	s11,56(sp)
    800026b6:	610d                	addi	sp,sp,160
    800026b8:	8082                	ret
        panic("bget: No buffer.");
    800026ba:	00006517          	auipc	a0,0x6
    800026be:	dee50513          	addi	a0,a0,-530 # 800084a8 <syscalls+0xd8>
    800026c2:	00004097          	auipc	ra,0x4
    800026c6:	bce080e7          	jalr	-1074(ra) # 80006290 <panic>
            LRUb->next = p->next;
    800026ca:	05893783          	ld	a5,88(s2)
    800026ce:	ecbc                	sd	a5,88(s1)
            release(&bcache.bucket_locks[curBucket]);
    800026d0:	020b9793          	slli	a5,s7,0x20
    800026d4:	01b7d513          	srli	a0,a5,0x1b
    800026d8:	67b1                	lui	a5,0xc
    800026da:	d9878793          	addi	a5,a5,-616 # bd98 <_entry-0x7fff4268>
    800026de:	953e                	add	a0,a0,a5
    800026e0:	0000c497          	auipc	s1,0xc
    800026e4:	48048493          	addi	s1,s1,1152 # 8000eb60 <bcache>
    800026e8:	9526                	add	a0,a0,s1
    800026ea:	00004097          	auipc	ra,0x4
    800026ee:	198080e7          	jalr	408(ra) # 80006882 <release>
            acquire(&bcache.bucket_locks[index]);
    800026f2:	f7843503          	ld	a0,-136(s0)
    800026f6:	00004097          	auipc	ra,0x4
    800026fa:	0bc080e7          	jalr	188(ra) # 800067b2 <acquire>
            p->next = bcache.bucket[index].next;
    800026fe:	f7446783          	lwu	a5,-140(s0)
    80002702:	46800713          	li	a4,1128
    80002706:	02e787b3          	mul	a5,a5,a4
    8000270a:	94be                	add	s1,s1,a5
    8000270c:	67a1                	lui	a5,0x8
    8000270e:	97a6                	add	a5,a5,s1
    80002710:	4a87b703          	ld	a4,1192(a5) # 84a8 <_entry-0x7fff7b58>
    80002714:	04e93c23          	sd	a4,88(s2)
            bcache.bucket[index].next = p;
    80002718:	4b27b423          	sd	s2,1192(a5)
    8000271c:	bf1d                	j	80002652 <bread+0x20e>
        virtio_disk_rw(b, 0);
    8000271e:	4581                	li	a1,0
    80002720:	854a                	mv	a0,s2
    80002722:	00003097          	auipc	ra,0x3
    80002726:	030080e7          	jalr	48(ra) # 80005752 <virtio_disk_rw>
        b->valid = 1;
    8000272a:	4785                	li	a5,1
    8000272c:	00f92023          	sw	a5,0(s2)
    return b;
    80002730:	b7ad                	j	8000269a <bread+0x256>

0000000080002732 <bwrite>:

// Write b's contents to disk.  Must be locked.
void bwrite(struct buf *b)
{
    80002732:	1101                	addi	sp,sp,-32
    80002734:	ec06                	sd	ra,24(sp)
    80002736:	e822                	sd	s0,16(sp)
    80002738:	e426                	sd	s1,8(sp)
    8000273a:	1000                	addi	s0,sp,32
    8000273c:	84aa                	mv	s1,a0
    if (!holdingsleep(&b->lock))
    8000273e:	0541                	addi	a0,a0,16
    80002740:	00001097          	auipc	ra,0x1
    80002744:	4b6080e7          	jalr	1206(ra) # 80003bf6 <holdingsleep>
    80002748:	cd01                	beqz	a0,80002760 <bwrite+0x2e>
        panic("bwrite");
    virtio_disk_rw(b, 1);
    8000274a:	4585                	li	a1,1
    8000274c:	8526                	mv	a0,s1
    8000274e:	00003097          	auipc	ra,0x3
    80002752:	004080e7          	jalr	4(ra) # 80005752 <virtio_disk_rw>
}
    80002756:	60e2                	ld	ra,24(sp)
    80002758:	6442                	ld	s0,16(sp)
    8000275a:	64a2                	ld	s1,8(sp)
    8000275c:	6105                	addi	sp,sp,32
    8000275e:	8082                	ret
        panic("bwrite");
    80002760:	00006517          	auipc	a0,0x6
    80002764:	d6050513          	addi	a0,a0,-672 # 800084c0 <syscalls+0xf0>
    80002768:	00004097          	auipc	ra,0x4
    8000276c:	b28080e7          	jalr	-1240(ra) # 80006290 <panic>

0000000080002770 <brelse>:

// Release a locked buffer.
void brelse(struct buf *b)
{
    80002770:	1101                	addi	sp,sp,-32
    80002772:	ec06                	sd	ra,24(sp)
    80002774:	e822                	sd	s0,16(sp)
    80002776:	e426                	sd	s1,8(sp)
    80002778:	e04a                	sd	s2,0(sp)
    8000277a:	1000                	addi	s0,sp,32
    8000277c:	892a                	mv	s2,a0
    // 【必须持有大锁lock】
    if (!holdingsleep(&b->lock))
    8000277e:	01050493          	addi	s1,a0,16
    80002782:	8526                	mv	a0,s1
    80002784:	00001097          	auipc	ra,0x1
    80002788:	472080e7          	jalr	1138(ra) # 80003bf6 <holdingsleep>
    8000278c:	c52d                	beqz	a0,800027f6 <brelse+0x86>
        panic("brelse");
    // 唤醒 buffer lock
    releasesleep(&b->lock);
    8000278e:	8526                	mv	a0,s1
    80002790:	00001097          	auipc	ra,0x1
    80002794:	422080e7          	jalr	1058(ra) # 80003bb2 <releasesleep>
    return ((blockno) % NBUCKET);
    80002798:	00c92483          	lw	s1,12(s2)
    8000279c:	47b5                	li	a5,13
    8000279e:	02f4f4bb          	remuw	s1,s1,a5

    uint index = hash(b->dev, b->blockno); // 计算哈希桶下标
    acquire(&bcache.bucket_locks[index]);
    800027a2:	1482                	slli	s1,s1,0x20
    800027a4:	9081                	srli	s1,s1,0x20
    800027a6:	0496                	slli	s1,s1,0x5
    800027a8:	67b1                	lui	a5,0xc
    800027aa:	d9878793          	addi	a5,a5,-616 # bd98 <_entry-0x7fff4268>
    800027ae:	94be                	add	s1,s1,a5
    800027b0:	0000c797          	auipc	a5,0xc
    800027b4:	3b078793          	addi	a5,a5,944 # 8000eb60 <bcache>
    800027b8:	94be                	add	s1,s1,a5
    800027ba:	8526                	mv	a0,s1
    800027bc:	00004097          	auipc	ra,0x4
    800027c0:	ff6080e7          	jalr	-10(ra) # 800067b2 <acquire>
    b->refcnt--;
    800027c4:	04892783          	lw	a5,72(s2)
    800027c8:	37fd                	addiw	a5,a5,-1
    800027ca:	0007871b          	sext.w	a4,a5
    800027ce:	04f92423          	sw	a5,72(s2)
    if (b->refcnt == 0) {
    800027d2:	e719                	bnez	a4,800027e0 <brelse+0x70>
        //没有进程引用这块buffer, 则为空闲状态释放，记录最近使用时间
        b->LUtime = ticks;
    800027d4:	00006797          	auipc	a5,0x6
    800027d8:	1d47a783          	lw	a5,468(a5) # 800089a8 <ticks>
    800027dc:	46f92023          	sw	a5,1120(s2)
    }
    release(&bcache.bucket_locks[index]);
    800027e0:	8526                	mv	a0,s1
    800027e2:	00004097          	auipc	ra,0x4
    800027e6:	0a0080e7          	jalr	160(ra) # 80006882 <release>
}
    800027ea:	60e2                	ld	ra,24(sp)
    800027ec:	6442                	ld	s0,16(sp)
    800027ee:	64a2                	ld	s1,8(sp)
    800027f0:	6902                	ld	s2,0(sp)
    800027f2:	6105                	addi	sp,sp,32
    800027f4:	8082                	ret
        panic("brelse");
    800027f6:	00006517          	auipc	a0,0x6
    800027fa:	cd250513          	addi	a0,a0,-814 # 800084c8 <syscalls+0xf8>
    800027fe:	00004097          	auipc	ra,0x4
    80002802:	a92080e7          	jalr	-1390(ra) # 80006290 <panic>

0000000080002806 <bpin>:

void bpin(struct buf *b)
{
    80002806:	1101                	addi	sp,sp,-32
    80002808:	ec06                	sd	ra,24(sp)
    8000280a:	e822                	sd	s0,16(sp)
    8000280c:	e426                	sd	s1,8(sp)
    8000280e:	e04a                	sd	s2,0(sp)
    80002810:	1000                	addi	s0,sp,32
    80002812:	892a                	mv	s2,a0
    return ((blockno) % NBUCKET);
    80002814:	4544                	lw	s1,12(a0)
    80002816:	47b5                	li	a5,13
    80002818:	02f4f4bb          	remuw	s1,s1,a5

    uint index = hash(b->dev, b->blockno);
    acquire(&bcache.bucket_locks[index]);
    8000281c:	1482                	slli	s1,s1,0x20
    8000281e:	9081                	srli	s1,s1,0x20
    80002820:	0496                	slli	s1,s1,0x5
    80002822:	67b1                	lui	a5,0xc
    80002824:	d9878793          	addi	a5,a5,-616 # bd98 <_entry-0x7fff4268>
    80002828:	94be                	add	s1,s1,a5
    8000282a:	0000c797          	auipc	a5,0xc
    8000282e:	33678793          	addi	a5,a5,822 # 8000eb60 <bcache>
    80002832:	94be                	add	s1,s1,a5
    80002834:	8526                	mv	a0,s1
    80002836:	00004097          	auipc	ra,0x4
    8000283a:	f7c080e7          	jalr	-132(ra) # 800067b2 <acquire>
    b->refcnt++;
    8000283e:	04892783          	lw	a5,72(s2)
    80002842:	2785                	addiw	a5,a5,1
    80002844:	04f92423          	sw	a5,72(s2)
    release(&bcache.bucket_locks[index]);
    80002848:	8526                	mv	a0,s1
    8000284a:	00004097          	auipc	ra,0x4
    8000284e:	038080e7          	jalr	56(ra) # 80006882 <release>
}
    80002852:	60e2                	ld	ra,24(sp)
    80002854:	6442                	ld	s0,16(sp)
    80002856:	64a2                	ld	s1,8(sp)
    80002858:	6902                	ld	s2,0(sp)
    8000285a:	6105                	addi	sp,sp,32
    8000285c:	8082                	ret

000000008000285e <bunpin>:

void bunpin(struct buf *b)
{
    8000285e:	1101                	addi	sp,sp,-32
    80002860:	ec06                	sd	ra,24(sp)
    80002862:	e822                	sd	s0,16(sp)
    80002864:	e426                	sd	s1,8(sp)
    80002866:	e04a                	sd	s2,0(sp)
    80002868:	1000                	addi	s0,sp,32
    8000286a:	892a                	mv	s2,a0
    return ((blockno) % NBUCKET);
    8000286c:	4544                	lw	s1,12(a0)
    8000286e:	47b5                	li	a5,13
    80002870:	02f4f4bb          	remuw	s1,s1,a5

    uint index = hash(b->dev, b->blockno);
    acquire(&bcache.bucket_locks[index]);
    80002874:	1482                	slli	s1,s1,0x20
    80002876:	9081                	srli	s1,s1,0x20
    80002878:	0496                	slli	s1,s1,0x5
    8000287a:	67b1                	lui	a5,0xc
    8000287c:	d9878793          	addi	a5,a5,-616 # bd98 <_entry-0x7fff4268>
    80002880:	94be                	add	s1,s1,a5
    80002882:	0000c797          	auipc	a5,0xc
    80002886:	2de78793          	addi	a5,a5,734 # 8000eb60 <bcache>
    8000288a:	94be                	add	s1,s1,a5
    8000288c:	8526                	mv	a0,s1
    8000288e:	00004097          	auipc	ra,0x4
    80002892:	f24080e7          	jalr	-220(ra) # 800067b2 <acquire>
    b->refcnt--;
    80002896:	04892783          	lw	a5,72(s2)
    8000289a:	37fd                	addiw	a5,a5,-1
    8000289c:	04f92423          	sw	a5,72(s2)
    release(&bcache.bucket_locks[index]);
    800028a0:	8526                	mv	a0,s1
    800028a2:	00004097          	auipc	ra,0x4
    800028a6:	fe0080e7          	jalr	-32(ra) # 80006882 <release>
    800028aa:	60e2                	ld	ra,24(sp)
    800028ac:	6442                	ld	s0,16(sp)
    800028ae:	64a2                	ld	s1,8(sp)
    800028b0:	6902                	ld	s2,0(sp)
    800028b2:	6105                	addi	sp,sp,32
    800028b4:	8082                	ret

00000000800028b6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800028b6:	1101                	addi	sp,sp,-32
    800028b8:	ec06                	sd	ra,24(sp)
    800028ba:	e822                	sd	s0,16(sp)
    800028bc:	e426                	sd	s1,8(sp)
    800028be:	e04a                	sd	s2,0(sp)
    800028c0:	1000                	addi	s0,sp,32
    800028c2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800028c4:	00d5d59b          	srliw	a1,a1,0xd
    800028c8:	00018797          	auipc	a5,0x18
    800028cc:	1ec7a783          	lw	a5,492(a5) # 8001aab4 <sb+0x1c>
    800028d0:	9dbd                	addw	a1,a1,a5
    800028d2:	00000097          	auipc	ra,0x0
    800028d6:	b72080e7          	jalr	-1166(ra) # 80002444 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800028da:	0074f713          	andi	a4,s1,7
    800028de:	4785                	li	a5,1
    800028e0:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800028e4:	14ce                	slli	s1,s1,0x33
    800028e6:	90d9                	srli	s1,s1,0x36
    800028e8:	00950733          	add	a4,a0,s1
    800028ec:	06074703          	lbu	a4,96(a4)
    800028f0:	00e7f6b3          	and	a3,a5,a4
    800028f4:	c69d                	beqz	a3,80002922 <bfree+0x6c>
    800028f6:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800028f8:	94aa                	add	s1,s1,a0
    800028fa:	fff7c793          	not	a5,a5
    800028fe:	8f7d                	and	a4,a4,a5
    80002900:	06e48023          	sb	a4,96(s1)
  log_write(bp);
    80002904:	00001097          	auipc	ra,0x1
    80002908:	13a080e7          	jalr	314(ra) # 80003a3e <log_write>
  brelse(bp);
    8000290c:	854a                	mv	a0,s2
    8000290e:	00000097          	auipc	ra,0x0
    80002912:	e62080e7          	jalr	-414(ra) # 80002770 <brelse>
}
    80002916:	60e2                	ld	ra,24(sp)
    80002918:	6442                	ld	s0,16(sp)
    8000291a:	64a2                	ld	s1,8(sp)
    8000291c:	6902                	ld	s2,0(sp)
    8000291e:	6105                	addi	sp,sp,32
    80002920:	8082                	ret
    panic("freeing free block");
    80002922:	00006517          	auipc	a0,0x6
    80002926:	bae50513          	addi	a0,a0,-1106 # 800084d0 <syscalls+0x100>
    8000292a:	00004097          	auipc	ra,0x4
    8000292e:	966080e7          	jalr	-1690(ra) # 80006290 <panic>

0000000080002932 <balloc>:
{
    80002932:	711d                	addi	sp,sp,-96
    80002934:	ec86                	sd	ra,88(sp)
    80002936:	e8a2                	sd	s0,80(sp)
    80002938:	e4a6                	sd	s1,72(sp)
    8000293a:	e0ca                	sd	s2,64(sp)
    8000293c:	fc4e                	sd	s3,56(sp)
    8000293e:	f852                	sd	s4,48(sp)
    80002940:	f456                	sd	s5,40(sp)
    80002942:	f05a                	sd	s6,32(sp)
    80002944:	ec5e                	sd	s7,24(sp)
    80002946:	e862                	sd	s8,16(sp)
    80002948:	e466                	sd	s9,8(sp)
    8000294a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000294c:	00018797          	auipc	a5,0x18
    80002950:	1507a783          	lw	a5,336(a5) # 8001aa9c <sb+0x4>
    80002954:	cff5                	beqz	a5,80002a50 <balloc+0x11e>
    80002956:	8baa                	mv	s7,a0
    80002958:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000295a:	00018b17          	auipc	s6,0x18
    8000295e:	13eb0b13          	addi	s6,s6,318 # 8001aa98 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002962:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002964:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002966:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002968:	6c89                	lui	s9,0x2
    8000296a:	a061                	j	800029f2 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000296c:	97ca                	add	a5,a5,s2
    8000296e:	8e55                	or	a2,a2,a3
    80002970:	06c78023          	sb	a2,96(a5)
        log_write(bp);
    80002974:	854a                	mv	a0,s2
    80002976:	00001097          	auipc	ra,0x1
    8000297a:	0c8080e7          	jalr	200(ra) # 80003a3e <log_write>
        brelse(bp);
    8000297e:	854a                	mv	a0,s2
    80002980:	00000097          	auipc	ra,0x0
    80002984:	df0080e7          	jalr	-528(ra) # 80002770 <brelse>
  bp = bread(dev, bno);
    80002988:	85a6                	mv	a1,s1
    8000298a:	855e                	mv	a0,s7
    8000298c:	00000097          	auipc	ra,0x0
    80002990:	ab8080e7          	jalr	-1352(ra) # 80002444 <bread>
    80002994:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002996:	40000613          	li	a2,1024
    8000299a:	4581                	li	a1,0
    8000299c:	06050513          	addi	a0,a0,96
    800029a0:	ffffe097          	auipc	ra,0xffffe
    800029a4:	8e6080e7          	jalr	-1818(ra) # 80000286 <memset>
  log_write(bp);
    800029a8:	854a                	mv	a0,s2
    800029aa:	00001097          	auipc	ra,0x1
    800029ae:	094080e7          	jalr	148(ra) # 80003a3e <log_write>
  brelse(bp);
    800029b2:	854a                	mv	a0,s2
    800029b4:	00000097          	auipc	ra,0x0
    800029b8:	dbc080e7          	jalr	-580(ra) # 80002770 <brelse>
}
    800029bc:	8526                	mv	a0,s1
    800029be:	60e6                	ld	ra,88(sp)
    800029c0:	6446                	ld	s0,80(sp)
    800029c2:	64a6                	ld	s1,72(sp)
    800029c4:	6906                	ld	s2,64(sp)
    800029c6:	79e2                	ld	s3,56(sp)
    800029c8:	7a42                	ld	s4,48(sp)
    800029ca:	7aa2                	ld	s5,40(sp)
    800029cc:	7b02                	ld	s6,32(sp)
    800029ce:	6be2                	ld	s7,24(sp)
    800029d0:	6c42                	ld	s8,16(sp)
    800029d2:	6ca2                	ld	s9,8(sp)
    800029d4:	6125                	addi	sp,sp,96
    800029d6:	8082                	ret
    brelse(bp);
    800029d8:	854a                	mv	a0,s2
    800029da:	00000097          	auipc	ra,0x0
    800029de:	d96080e7          	jalr	-618(ra) # 80002770 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800029e2:	015c87bb          	addw	a5,s9,s5
    800029e6:	00078a9b          	sext.w	s5,a5
    800029ea:	004b2703          	lw	a4,4(s6)
    800029ee:	06eaf163          	bgeu	s5,a4,80002a50 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    800029f2:	41fad79b          	sraiw	a5,s5,0x1f
    800029f6:	0137d79b          	srliw	a5,a5,0x13
    800029fa:	015787bb          	addw	a5,a5,s5
    800029fe:	40d7d79b          	sraiw	a5,a5,0xd
    80002a02:	01cb2583          	lw	a1,28(s6)
    80002a06:	9dbd                	addw	a1,a1,a5
    80002a08:	855e                	mv	a0,s7
    80002a0a:	00000097          	auipc	ra,0x0
    80002a0e:	a3a080e7          	jalr	-1478(ra) # 80002444 <bread>
    80002a12:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002a14:	004b2503          	lw	a0,4(s6)
    80002a18:	000a849b          	sext.w	s1,s5
    80002a1c:	8762                	mv	a4,s8
    80002a1e:	faa4fde3          	bgeu	s1,a0,800029d8 <balloc+0xa6>
      m = 1 << (bi % 8);
    80002a22:	00777693          	andi	a3,a4,7
    80002a26:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002a2a:	41f7579b          	sraiw	a5,a4,0x1f
    80002a2e:	01d7d79b          	srliw	a5,a5,0x1d
    80002a32:	9fb9                	addw	a5,a5,a4
    80002a34:	4037d79b          	sraiw	a5,a5,0x3
    80002a38:	00f90633          	add	a2,s2,a5
    80002a3c:	06064603          	lbu	a2,96(a2)
    80002a40:	00c6f5b3          	and	a1,a3,a2
    80002a44:	d585                	beqz	a1,8000296c <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002a46:	2705                	addiw	a4,a4,1
    80002a48:	2485                	addiw	s1,s1,1
    80002a4a:	fd471ae3          	bne	a4,s4,80002a1e <balloc+0xec>
    80002a4e:	b769                	j	800029d8 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80002a50:	00006517          	auipc	a0,0x6
    80002a54:	a9850513          	addi	a0,a0,-1384 # 800084e8 <syscalls+0x118>
    80002a58:	00004097          	auipc	ra,0x4
    80002a5c:	882080e7          	jalr	-1918(ra) # 800062da <printf>
  return 0;
    80002a60:	4481                	li	s1,0
    80002a62:	bfa9                	j	800029bc <balloc+0x8a>

0000000080002a64 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002a64:	7179                	addi	sp,sp,-48
    80002a66:	f406                	sd	ra,40(sp)
    80002a68:	f022                	sd	s0,32(sp)
    80002a6a:	ec26                	sd	s1,24(sp)
    80002a6c:	e84a                	sd	s2,16(sp)
    80002a6e:	e44e                	sd	s3,8(sp)
    80002a70:	e052                	sd	s4,0(sp)
    80002a72:	1800                	addi	s0,sp,48
    80002a74:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002a76:	47ad                	li	a5,11
    80002a78:	02b7e863          	bltu	a5,a1,80002aa8 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80002a7c:	02059793          	slli	a5,a1,0x20
    80002a80:	01e7d593          	srli	a1,a5,0x1e
    80002a84:	00b504b3          	add	s1,a0,a1
    80002a88:	0584a903          	lw	s2,88(s1)
    80002a8c:	06091e63          	bnez	s2,80002b08 <bmap+0xa4>
      addr = balloc(ip->dev);
    80002a90:	4108                	lw	a0,0(a0)
    80002a92:	00000097          	auipc	ra,0x0
    80002a96:	ea0080e7          	jalr	-352(ra) # 80002932 <balloc>
    80002a9a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002a9e:	06090563          	beqz	s2,80002b08 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    80002aa2:	0524ac23          	sw	s2,88(s1)
    80002aa6:	a08d                	j	80002b08 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002aa8:	ff45849b          	addiw	s1,a1,-12
    80002aac:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002ab0:	0ff00793          	li	a5,255
    80002ab4:	08e7e563          	bltu	a5,a4,80002b3e <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002ab8:	08852903          	lw	s2,136(a0)
    80002abc:	00091d63          	bnez	s2,80002ad6 <bmap+0x72>
      addr = balloc(ip->dev);
    80002ac0:	4108                	lw	a0,0(a0)
    80002ac2:	00000097          	auipc	ra,0x0
    80002ac6:	e70080e7          	jalr	-400(ra) # 80002932 <balloc>
    80002aca:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002ace:	02090d63          	beqz	s2,80002b08 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002ad2:	0929a423          	sw	s2,136(s3)
    }
    bp = bread(ip->dev, addr);
    80002ad6:	85ca                	mv	a1,s2
    80002ad8:	0009a503          	lw	a0,0(s3)
    80002adc:	00000097          	auipc	ra,0x0
    80002ae0:	968080e7          	jalr	-1688(ra) # 80002444 <bread>
    80002ae4:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002ae6:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    80002aea:	02049713          	slli	a4,s1,0x20
    80002aee:	01e75593          	srli	a1,a4,0x1e
    80002af2:	00b784b3          	add	s1,a5,a1
    80002af6:	0004a903          	lw	s2,0(s1)
    80002afa:	02090063          	beqz	s2,80002b1a <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002afe:	8552                	mv	a0,s4
    80002b00:	00000097          	auipc	ra,0x0
    80002b04:	c70080e7          	jalr	-912(ra) # 80002770 <brelse>
    return addr;
  }
  panic("bmap: out of range");
}
    80002b08:	854a                	mv	a0,s2
    80002b0a:	70a2                	ld	ra,40(sp)
    80002b0c:	7402                	ld	s0,32(sp)
    80002b0e:	64e2                	ld	s1,24(sp)
    80002b10:	6942                	ld	s2,16(sp)
    80002b12:	69a2                	ld	s3,8(sp)
    80002b14:	6a02                	ld	s4,0(sp)
    80002b16:	6145                	addi	sp,sp,48
    80002b18:	8082                	ret
      addr = balloc(ip->dev);
    80002b1a:	0009a503          	lw	a0,0(s3)
    80002b1e:	00000097          	auipc	ra,0x0
    80002b22:	e14080e7          	jalr	-492(ra) # 80002932 <balloc>
    80002b26:	0005091b          	sext.w	s2,a0
      if(addr){
    80002b2a:	fc090ae3          	beqz	s2,80002afe <bmap+0x9a>
        a[bn] = addr;
    80002b2e:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002b32:	8552                	mv	a0,s4
    80002b34:	00001097          	auipc	ra,0x1
    80002b38:	f0a080e7          	jalr	-246(ra) # 80003a3e <log_write>
    80002b3c:	b7c9                	j	80002afe <bmap+0x9a>
  panic("bmap: out of range");
    80002b3e:	00006517          	auipc	a0,0x6
    80002b42:	9c250513          	addi	a0,a0,-1598 # 80008500 <syscalls+0x130>
    80002b46:	00003097          	auipc	ra,0x3
    80002b4a:	74a080e7          	jalr	1866(ra) # 80006290 <panic>

0000000080002b4e <iget>:
{
    80002b4e:	7179                	addi	sp,sp,-48
    80002b50:	f406                	sd	ra,40(sp)
    80002b52:	f022                	sd	s0,32(sp)
    80002b54:	ec26                	sd	s1,24(sp)
    80002b56:	e84a                	sd	s2,16(sp)
    80002b58:	e44e                	sd	s3,8(sp)
    80002b5a:	e052                	sd	s4,0(sp)
    80002b5c:	1800                	addi	s0,sp,48
    80002b5e:	89aa                	mv	s3,a0
    80002b60:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002b62:	00018517          	auipc	a0,0x18
    80002b66:	f5650513          	addi	a0,a0,-170 # 8001aab8 <itable>
    80002b6a:	00004097          	auipc	ra,0x4
    80002b6e:	c48080e7          	jalr	-952(ra) # 800067b2 <acquire>
  empty = 0;
    80002b72:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b74:	00018497          	auipc	s1,0x18
    80002b78:	f6448493          	addi	s1,s1,-156 # 8001aad8 <itable+0x20>
    80002b7c:	0001a697          	auipc	a3,0x1a
    80002b80:	b7c68693          	addi	a3,a3,-1156 # 8001c6f8 <log>
    80002b84:	a039                	j	80002b92 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b86:	02090b63          	beqz	s2,80002bbc <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b8a:	09048493          	addi	s1,s1,144
    80002b8e:	02d48a63          	beq	s1,a3,80002bc2 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002b92:	449c                	lw	a5,8(s1)
    80002b94:	fef059e3          	blez	a5,80002b86 <iget+0x38>
    80002b98:	4098                	lw	a4,0(s1)
    80002b9a:	ff3716e3          	bne	a4,s3,80002b86 <iget+0x38>
    80002b9e:	40d8                	lw	a4,4(s1)
    80002ba0:	ff4713e3          	bne	a4,s4,80002b86 <iget+0x38>
      ip->ref++;
    80002ba4:	2785                	addiw	a5,a5,1
    80002ba6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002ba8:	00018517          	auipc	a0,0x18
    80002bac:	f1050513          	addi	a0,a0,-240 # 8001aab8 <itable>
    80002bb0:	00004097          	auipc	ra,0x4
    80002bb4:	cd2080e7          	jalr	-814(ra) # 80006882 <release>
      return ip;
    80002bb8:	8926                	mv	s2,s1
    80002bba:	a03d                	j	80002be8 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002bbc:	f7f9                	bnez	a5,80002b8a <iget+0x3c>
    80002bbe:	8926                	mv	s2,s1
    80002bc0:	b7e9                	j	80002b8a <iget+0x3c>
  if(empty == 0)
    80002bc2:	02090c63          	beqz	s2,80002bfa <iget+0xac>
  ip->dev = dev;
    80002bc6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002bca:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002bce:	4785                	li	a5,1
    80002bd0:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002bd4:	04092423          	sw	zero,72(s2)
  release(&itable.lock);
    80002bd8:	00018517          	auipc	a0,0x18
    80002bdc:	ee050513          	addi	a0,a0,-288 # 8001aab8 <itable>
    80002be0:	00004097          	auipc	ra,0x4
    80002be4:	ca2080e7          	jalr	-862(ra) # 80006882 <release>
}
    80002be8:	854a                	mv	a0,s2
    80002bea:	70a2                	ld	ra,40(sp)
    80002bec:	7402                	ld	s0,32(sp)
    80002bee:	64e2                	ld	s1,24(sp)
    80002bf0:	6942                	ld	s2,16(sp)
    80002bf2:	69a2                	ld	s3,8(sp)
    80002bf4:	6a02                	ld	s4,0(sp)
    80002bf6:	6145                	addi	sp,sp,48
    80002bf8:	8082                	ret
    panic("iget: no inodes");
    80002bfa:	00006517          	auipc	a0,0x6
    80002bfe:	91e50513          	addi	a0,a0,-1762 # 80008518 <syscalls+0x148>
    80002c02:	00003097          	auipc	ra,0x3
    80002c06:	68e080e7          	jalr	1678(ra) # 80006290 <panic>

0000000080002c0a <fsinit>:
fsinit(int dev) {
    80002c0a:	7179                	addi	sp,sp,-48
    80002c0c:	f406                	sd	ra,40(sp)
    80002c0e:	f022                	sd	s0,32(sp)
    80002c10:	ec26                	sd	s1,24(sp)
    80002c12:	e84a                	sd	s2,16(sp)
    80002c14:	e44e                	sd	s3,8(sp)
    80002c16:	1800                	addi	s0,sp,48
    80002c18:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002c1a:	4585                	li	a1,1
    80002c1c:	00000097          	auipc	ra,0x0
    80002c20:	828080e7          	jalr	-2008(ra) # 80002444 <bread>
    80002c24:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002c26:	00018997          	auipc	s3,0x18
    80002c2a:	e7298993          	addi	s3,s3,-398 # 8001aa98 <sb>
    80002c2e:	02000613          	li	a2,32
    80002c32:	06050593          	addi	a1,a0,96
    80002c36:	854e                	mv	a0,s3
    80002c38:	ffffd097          	auipc	ra,0xffffd
    80002c3c:	6aa080e7          	jalr	1706(ra) # 800002e2 <memmove>
  brelse(bp);
    80002c40:	8526                	mv	a0,s1
    80002c42:	00000097          	auipc	ra,0x0
    80002c46:	b2e080e7          	jalr	-1234(ra) # 80002770 <brelse>
  if(sb.magic != FSMAGIC)
    80002c4a:	0009a703          	lw	a4,0(s3)
    80002c4e:	102037b7          	lui	a5,0x10203
    80002c52:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002c56:	02f71263          	bne	a4,a5,80002c7a <fsinit+0x70>
  initlog(dev, &sb);
    80002c5a:	00018597          	auipc	a1,0x18
    80002c5e:	e3e58593          	addi	a1,a1,-450 # 8001aa98 <sb>
    80002c62:	854a                	mv	a0,s2
    80002c64:	00001097          	auipc	ra,0x1
    80002c68:	b5e080e7          	jalr	-1186(ra) # 800037c2 <initlog>
}
    80002c6c:	70a2                	ld	ra,40(sp)
    80002c6e:	7402                	ld	s0,32(sp)
    80002c70:	64e2                	ld	s1,24(sp)
    80002c72:	6942                	ld	s2,16(sp)
    80002c74:	69a2                	ld	s3,8(sp)
    80002c76:	6145                	addi	sp,sp,48
    80002c78:	8082                	ret
    panic("invalid file system");
    80002c7a:	00006517          	auipc	a0,0x6
    80002c7e:	8ae50513          	addi	a0,a0,-1874 # 80008528 <syscalls+0x158>
    80002c82:	00003097          	auipc	ra,0x3
    80002c86:	60e080e7          	jalr	1550(ra) # 80006290 <panic>

0000000080002c8a <iinit>:
{
    80002c8a:	7179                	addi	sp,sp,-48
    80002c8c:	f406                	sd	ra,40(sp)
    80002c8e:	f022                	sd	s0,32(sp)
    80002c90:	ec26                	sd	s1,24(sp)
    80002c92:	e84a                	sd	s2,16(sp)
    80002c94:	e44e                	sd	s3,8(sp)
    80002c96:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002c98:	00006597          	auipc	a1,0x6
    80002c9c:	8a858593          	addi	a1,a1,-1880 # 80008540 <syscalls+0x170>
    80002ca0:	00018517          	auipc	a0,0x18
    80002ca4:	e1850513          	addi	a0,a0,-488 # 8001aab8 <itable>
    80002ca8:	00004097          	auipc	ra,0x4
    80002cac:	c86080e7          	jalr	-890(ra) # 8000692e <initlock>
  for(i = 0; i < NINODE; i++) {
    80002cb0:	00018497          	auipc	s1,0x18
    80002cb4:	e3848493          	addi	s1,s1,-456 # 8001aae8 <itable+0x30>
    80002cb8:	0001a997          	auipc	s3,0x1a
    80002cbc:	a5098993          	addi	s3,s3,-1456 # 8001c708 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002cc0:	00006917          	auipc	s2,0x6
    80002cc4:	88890913          	addi	s2,s2,-1912 # 80008548 <syscalls+0x178>
    80002cc8:	85ca                	mv	a1,s2
    80002cca:	8526                	mv	a0,s1
    80002ccc:	00001097          	auipc	ra,0x1
    80002cd0:	e56080e7          	jalr	-426(ra) # 80003b22 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002cd4:	09048493          	addi	s1,s1,144
    80002cd8:	ff3498e3          	bne	s1,s3,80002cc8 <iinit+0x3e>
}
    80002cdc:	70a2                	ld	ra,40(sp)
    80002cde:	7402                	ld	s0,32(sp)
    80002ce0:	64e2                	ld	s1,24(sp)
    80002ce2:	6942                	ld	s2,16(sp)
    80002ce4:	69a2                	ld	s3,8(sp)
    80002ce6:	6145                	addi	sp,sp,48
    80002ce8:	8082                	ret

0000000080002cea <ialloc>:
{
    80002cea:	715d                	addi	sp,sp,-80
    80002cec:	e486                	sd	ra,72(sp)
    80002cee:	e0a2                	sd	s0,64(sp)
    80002cf0:	fc26                	sd	s1,56(sp)
    80002cf2:	f84a                	sd	s2,48(sp)
    80002cf4:	f44e                	sd	s3,40(sp)
    80002cf6:	f052                	sd	s4,32(sp)
    80002cf8:	ec56                	sd	s5,24(sp)
    80002cfa:	e85a                	sd	s6,16(sp)
    80002cfc:	e45e                	sd	s7,8(sp)
    80002cfe:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002d00:	00018717          	auipc	a4,0x18
    80002d04:	da472703          	lw	a4,-604(a4) # 8001aaa4 <sb+0xc>
    80002d08:	4785                	li	a5,1
    80002d0a:	04e7fa63          	bgeu	a5,a4,80002d5e <ialloc+0x74>
    80002d0e:	8aaa                	mv	s5,a0
    80002d10:	8bae                	mv	s7,a1
    80002d12:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002d14:	00018a17          	auipc	s4,0x18
    80002d18:	d84a0a13          	addi	s4,s4,-636 # 8001aa98 <sb>
    80002d1c:	00048b1b          	sext.w	s6,s1
    80002d20:	0044d593          	srli	a1,s1,0x4
    80002d24:	018a2783          	lw	a5,24(s4)
    80002d28:	9dbd                	addw	a1,a1,a5
    80002d2a:	8556                	mv	a0,s5
    80002d2c:	fffff097          	auipc	ra,0xfffff
    80002d30:	718080e7          	jalr	1816(ra) # 80002444 <bread>
    80002d34:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002d36:	06050993          	addi	s3,a0,96
    80002d3a:	00f4f793          	andi	a5,s1,15
    80002d3e:	079a                	slli	a5,a5,0x6
    80002d40:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002d42:	00099783          	lh	a5,0(s3)
    80002d46:	c3a1                	beqz	a5,80002d86 <ialloc+0x9c>
    brelse(bp);
    80002d48:	00000097          	auipc	ra,0x0
    80002d4c:	a28080e7          	jalr	-1496(ra) # 80002770 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002d50:	0485                	addi	s1,s1,1
    80002d52:	00ca2703          	lw	a4,12(s4)
    80002d56:	0004879b          	sext.w	a5,s1
    80002d5a:	fce7e1e3          	bltu	a5,a4,80002d1c <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002d5e:	00005517          	auipc	a0,0x5
    80002d62:	7f250513          	addi	a0,a0,2034 # 80008550 <syscalls+0x180>
    80002d66:	00003097          	auipc	ra,0x3
    80002d6a:	574080e7          	jalr	1396(ra) # 800062da <printf>
  return 0;
    80002d6e:	4501                	li	a0,0
}
    80002d70:	60a6                	ld	ra,72(sp)
    80002d72:	6406                	ld	s0,64(sp)
    80002d74:	74e2                	ld	s1,56(sp)
    80002d76:	7942                	ld	s2,48(sp)
    80002d78:	79a2                	ld	s3,40(sp)
    80002d7a:	7a02                	ld	s4,32(sp)
    80002d7c:	6ae2                	ld	s5,24(sp)
    80002d7e:	6b42                	ld	s6,16(sp)
    80002d80:	6ba2                	ld	s7,8(sp)
    80002d82:	6161                	addi	sp,sp,80
    80002d84:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002d86:	04000613          	li	a2,64
    80002d8a:	4581                	li	a1,0
    80002d8c:	854e                	mv	a0,s3
    80002d8e:	ffffd097          	auipc	ra,0xffffd
    80002d92:	4f8080e7          	jalr	1272(ra) # 80000286 <memset>
      dip->type = type;
    80002d96:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002d9a:	854a                	mv	a0,s2
    80002d9c:	00001097          	auipc	ra,0x1
    80002da0:	ca2080e7          	jalr	-862(ra) # 80003a3e <log_write>
      brelse(bp);
    80002da4:	854a                	mv	a0,s2
    80002da6:	00000097          	auipc	ra,0x0
    80002daa:	9ca080e7          	jalr	-1590(ra) # 80002770 <brelse>
      return iget(dev, inum);
    80002dae:	85da                	mv	a1,s6
    80002db0:	8556                	mv	a0,s5
    80002db2:	00000097          	auipc	ra,0x0
    80002db6:	d9c080e7          	jalr	-612(ra) # 80002b4e <iget>
    80002dba:	bf5d                	j	80002d70 <ialloc+0x86>

0000000080002dbc <iupdate>:
{
    80002dbc:	1101                	addi	sp,sp,-32
    80002dbe:	ec06                	sd	ra,24(sp)
    80002dc0:	e822                	sd	s0,16(sp)
    80002dc2:	e426                	sd	s1,8(sp)
    80002dc4:	e04a                	sd	s2,0(sp)
    80002dc6:	1000                	addi	s0,sp,32
    80002dc8:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002dca:	415c                	lw	a5,4(a0)
    80002dcc:	0047d79b          	srliw	a5,a5,0x4
    80002dd0:	00018597          	auipc	a1,0x18
    80002dd4:	ce05a583          	lw	a1,-800(a1) # 8001aab0 <sb+0x18>
    80002dd8:	9dbd                	addw	a1,a1,a5
    80002dda:	4108                	lw	a0,0(a0)
    80002ddc:	fffff097          	auipc	ra,0xfffff
    80002de0:	668080e7          	jalr	1640(ra) # 80002444 <bread>
    80002de4:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002de6:	06050793          	addi	a5,a0,96
    80002dea:	40d8                	lw	a4,4(s1)
    80002dec:	8b3d                	andi	a4,a4,15
    80002dee:	071a                	slli	a4,a4,0x6
    80002df0:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002df2:	04c49703          	lh	a4,76(s1)
    80002df6:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002dfa:	04e49703          	lh	a4,78(s1)
    80002dfe:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002e02:	05049703          	lh	a4,80(s1)
    80002e06:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002e0a:	05249703          	lh	a4,82(s1)
    80002e0e:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002e12:	48f8                	lw	a4,84(s1)
    80002e14:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002e16:	03400613          	li	a2,52
    80002e1a:	05848593          	addi	a1,s1,88
    80002e1e:	00c78513          	addi	a0,a5,12
    80002e22:	ffffd097          	auipc	ra,0xffffd
    80002e26:	4c0080e7          	jalr	1216(ra) # 800002e2 <memmove>
  log_write(bp);
    80002e2a:	854a                	mv	a0,s2
    80002e2c:	00001097          	auipc	ra,0x1
    80002e30:	c12080e7          	jalr	-1006(ra) # 80003a3e <log_write>
  brelse(bp);
    80002e34:	854a                	mv	a0,s2
    80002e36:	00000097          	auipc	ra,0x0
    80002e3a:	93a080e7          	jalr	-1734(ra) # 80002770 <brelse>
}
    80002e3e:	60e2                	ld	ra,24(sp)
    80002e40:	6442                	ld	s0,16(sp)
    80002e42:	64a2                	ld	s1,8(sp)
    80002e44:	6902                	ld	s2,0(sp)
    80002e46:	6105                	addi	sp,sp,32
    80002e48:	8082                	ret

0000000080002e4a <idup>:
{
    80002e4a:	1101                	addi	sp,sp,-32
    80002e4c:	ec06                	sd	ra,24(sp)
    80002e4e:	e822                	sd	s0,16(sp)
    80002e50:	e426                	sd	s1,8(sp)
    80002e52:	1000                	addi	s0,sp,32
    80002e54:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e56:	00018517          	auipc	a0,0x18
    80002e5a:	c6250513          	addi	a0,a0,-926 # 8001aab8 <itable>
    80002e5e:	00004097          	auipc	ra,0x4
    80002e62:	954080e7          	jalr	-1708(ra) # 800067b2 <acquire>
  ip->ref++;
    80002e66:	449c                	lw	a5,8(s1)
    80002e68:	2785                	addiw	a5,a5,1
    80002e6a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e6c:	00018517          	auipc	a0,0x18
    80002e70:	c4c50513          	addi	a0,a0,-948 # 8001aab8 <itable>
    80002e74:	00004097          	auipc	ra,0x4
    80002e78:	a0e080e7          	jalr	-1522(ra) # 80006882 <release>
}
    80002e7c:	8526                	mv	a0,s1
    80002e7e:	60e2                	ld	ra,24(sp)
    80002e80:	6442                	ld	s0,16(sp)
    80002e82:	64a2                	ld	s1,8(sp)
    80002e84:	6105                	addi	sp,sp,32
    80002e86:	8082                	ret

0000000080002e88 <ilock>:
{
    80002e88:	1101                	addi	sp,sp,-32
    80002e8a:	ec06                	sd	ra,24(sp)
    80002e8c:	e822                	sd	s0,16(sp)
    80002e8e:	e426                	sd	s1,8(sp)
    80002e90:	e04a                	sd	s2,0(sp)
    80002e92:	1000                	addi	s0,sp,32
  if(ip == 0 || atomic_read4(&ip->ref) < 1)
    80002e94:	c51d                	beqz	a0,80002ec2 <ilock+0x3a>
    80002e96:	84aa                	mv	s1,a0
    80002e98:	0521                	addi	a0,a0,8
    80002e9a:	00004097          	auipc	ra,0x4
    80002e9e:	b14080e7          	jalr	-1260(ra) # 800069ae <atomic_read4>
    80002ea2:	02a05063          	blez	a0,80002ec2 <ilock+0x3a>
  acquiresleep(&ip->lock);
    80002ea6:	01048513          	addi	a0,s1,16
    80002eaa:	00001097          	auipc	ra,0x1
    80002eae:	cb2080e7          	jalr	-846(ra) # 80003b5c <acquiresleep>
  if(ip->valid == 0){
    80002eb2:	44bc                	lw	a5,72(s1)
    80002eb4:	cf99                	beqz	a5,80002ed2 <ilock+0x4a>
}
    80002eb6:	60e2                	ld	ra,24(sp)
    80002eb8:	6442                	ld	s0,16(sp)
    80002eba:	64a2                	ld	s1,8(sp)
    80002ebc:	6902                	ld	s2,0(sp)
    80002ebe:	6105                	addi	sp,sp,32
    80002ec0:	8082                	ret
    panic("ilock");
    80002ec2:	00005517          	auipc	a0,0x5
    80002ec6:	6a650513          	addi	a0,a0,1702 # 80008568 <syscalls+0x198>
    80002eca:	00003097          	auipc	ra,0x3
    80002ece:	3c6080e7          	jalr	966(ra) # 80006290 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ed2:	40dc                	lw	a5,4(s1)
    80002ed4:	0047d79b          	srliw	a5,a5,0x4
    80002ed8:	00018597          	auipc	a1,0x18
    80002edc:	bd85a583          	lw	a1,-1064(a1) # 8001aab0 <sb+0x18>
    80002ee0:	9dbd                	addw	a1,a1,a5
    80002ee2:	4088                	lw	a0,0(s1)
    80002ee4:	fffff097          	auipc	ra,0xfffff
    80002ee8:	560080e7          	jalr	1376(ra) # 80002444 <bread>
    80002eec:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002eee:	06050593          	addi	a1,a0,96
    80002ef2:	40dc                	lw	a5,4(s1)
    80002ef4:	8bbd                	andi	a5,a5,15
    80002ef6:	079a                	slli	a5,a5,0x6
    80002ef8:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002efa:	00059783          	lh	a5,0(a1)
    80002efe:	04f49623          	sh	a5,76(s1)
    ip->major = dip->major;
    80002f02:	00259783          	lh	a5,2(a1)
    80002f06:	04f49723          	sh	a5,78(s1)
    ip->minor = dip->minor;
    80002f0a:	00459783          	lh	a5,4(a1)
    80002f0e:	04f49823          	sh	a5,80(s1)
    ip->nlink = dip->nlink;
    80002f12:	00659783          	lh	a5,6(a1)
    80002f16:	04f49923          	sh	a5,82(s1)
    ip->size = dip->size;
    80002f1a:	459c                	lw	a5,8(a1)
    80002f1c:	c8fc                	sw	a5,84(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002f1e:	03400613          	li	a2,52
    80002f22:	05b1                	addi	a1,a1,12
    80002f24:	05848513          	addi	a0,s1,88
    80002f28:	ffffd097          	auipc	ra,0xffffd
    80002f2c:	3ba080e7          	jalr	954(ra) # 800002e2 <memmove>
    brelse(bp);
    80002f30:	854a                	mv	a0,s2
    80002f32:	00000097          	auipc	ra,0x0
    80002f36:	83e080e7          	jalr	-1986(ra) # 80002770 <brelse>
    ip->valid = 1;
    80002f3a:	4785                	li	a5,1
    80002f3c:	c4bc                	sw	a5,72(s1)
    if(ip->type == 0)
    80002f3e:	04c49783          	lh	a5,76(s1)
    80002f42:	fbb5                	bnez	a5,80002eb6 <ilock+0x2e>
      panic("ilock: no type");
    80002f44:	00005517          	auipc	a0,0x5
    80002f48:	62c50513          	addi	a0,a0,1580 # 80008570 <syscalls+0x1a0>
    80002f4c:	00003097          	auipc	ra,0x3
    80002f50:	344080e7          	jalr	836(ra) # 80006290 <panic>

0000000080002f54 <iunlock>:
{
    80002f54:	1101                	addi	sp,sp,-32
    80002f56:	ec06                	sd	ra,24(sp)
    80002f58:	e822                	sd	s0,16(sp)
    80002f5a:	e426                	sd	s1,8(sp)
    80002f5c:	e04a                	sd	s2,0(sp)
    80002f5e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || atomic_read4(&ip->ref) < 1)
    80002f60:	cd0d                	beqz	a0,80002f9a <iunlock+0x46>
    80002f62:	84aa                	mv	s1,a0
    80002f64:	01050913          	addi	s2,a0,16
    80002f68:	854a                	mv	a0,s2
    80002f6a:	00001097          	auipc	ra,0x1
    80002f6e:	c8c080e7          	jalr	-884(ra) # 80003bf6 <holdingsleep>
    80002f72:	c505                	beqz	a0,80002f9a <iunlock+0x46>
    80002f74:	00848513          	addi	a0,s1,8
    80002f78:	00004097          	auipc	ra,0x4
    80002f7c:	a36080e7          	jalr	-1482(ra) # 800069ae <atomic_read4>
    80002f80:	00a05d63          	blez	a0,80002f9a <iunlock+0x46>
  releasesleep(&ip->lock);
    80002f84:	854a                	mv	a0,s2
    80002f86:	00001097          	auipc	ra,0x1
    80002f8a:	c2c080e7          	jalr	-980(ra) # 80003bb2 <releasesleep>
}
    80002f8e:	60e2                	ld	ra,24(sp)
    80002f90:	6442                	ld	s0,16(sp)
    80002f92:	64a2                	ld	s1,8(sp)
    80002f94:	6902                	ld	s2,0(sp)
    80002f96:	6105                	addi	sp,sp,32
    80002f98:	8082                	ret
    panic("iunlock");
    80002f9a:	00005517          	auipc	a0,0x5
    80002f9e:	5e650513          	addi	a0,a0,1510 # 80008580 <syscalls+0x1b0>
    80002fa2:	00003097          	auipc	ra,0x3
    80002fa6:	2ee080e7          	jalr	750(ra) # 80006290 <panic>

0000000080002faa <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002faa:	7179                	addi	sp,sp,-48
    80002fac:	f406                	sd	ra,40(sp)
    80002fae:	f022                	sd	s0,32(sp)
    80002fb0:	ec26                	sd	s1,24(sp)
    80002fb2:	e84a                	sd	s2,16(sp)
    80002fb4:	e44e                	sd	s3,8(sp)
    80002fb6:	e052                	sd	s4,0(sp)
    80002fb8:	1800                	addi	s0,sp,48
    80002fba:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002fbc:	05850493          	addi	s1,a0,88
    80002fc0:	08850913          	addi	s2,a0,136
    80002fc4:	a021                	j	80002fcc <itrunc+0x22>
    80002fc6:	0491                	addi	s1,s1,4
    80002fc8:	01248d63          	beq	s1,s2,80002fe2 <itrunc+0x38>
    if(ip->addrs[i]){
    80002fcc:	408c                	lw	a1,0(s1)
    80002fce:	dde5                	beqz	a1,80002fc6 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002fd0:	0009a503          	lw	a0,0(s3)
    80002fd4:	00000097          	auipc	ra,0x0
    80002fd8:	8e2080e7          	jalr	-1822(ra) # 800028b6 <bfree>
      ip->addrs[i] = 0;
    80002fdc:	0004a023          	sw	zero,0(s1)
    80002fe0:	b7dd                	j	80002fc6 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002fe2:	0889a583          	lw	a1,136(s3)
    80002fe6:	e185                	bnez	a1,80003006 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }
  
  ip->size = 0;
    80002fe8:	0409aa23          	sw	zero,84(s3)
  iupdate(ip);
    80002fec:	854e                	mv	a0,s3
    80002fee:	00000097          	auipc	ra,0x0
    80002ff2:	dce080e7          	jalr	-562(ra) # 80002dbc <iupdate>
}
    80002ff6:	70a2                	ld	ra,40(sp)
    80002ff8:	7402                	ld	s0,32(sp)
    80002ffa:	64e2                	ld	s1,24(sp)
    80002ffc:	6942                	ld	s2,16(sp)
    80002ffe:	69a2                	ld	s3,8(sp)
    80003000:	6a02                	ld	s4,0(sp)
    80003002:	6145                	addi	sp,sp,48
    80003004:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003006:	0009a503          	lw	a0,0(s3)
    8000300a:	fffff097          	auipc	ra,0xfffff
    8000300e:	43a080e7          	jalr	1082(ra) # 80002444 <bread>
    80003012:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003014:	06050493          	addi	s1,a0,96
    80003018:	46050913          	addi	s2,a0,1120
    8000301c:	a021                	j	80003024 <itrunc+0x7a>
    8000301e:	0491                	addi	s1,s1,4
    80003020:	01248b63          	beq	s1,s2,80003036 <itrunc+0x8c>
      if(a[j])
    80003024:	408c                	lw	a1,0(s1)
    80003026:	dde5                	beqz	a1,8000301e <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003028:	0009a503          	lw	a0,0(s3)
    8000302c:	00000097          	auipc	ra,0x0
    80003030:	88a080e7          	jalr	-1910(ra) # 800028b6 <bfree>
    80003034:	b7ed                	j	8000301e <itrunc+0x74>
    brelse(bp);
    80003036:	8552                	mv	a0,s4
    80003038:	fffff097          	auipc	ra,0xfffff
    8000303c:	738080e7          	jalr	1848(ra) # 80002770 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003040:	0889a583          	lw	a1,136(s3)
    80003044:	0009a503          	lw	a0,0(s3)
    80003048:	00000097          	auipc	ra,0x0
    8000304c:	86e080e7          	jalr	-1938(ra) # 800028b6 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003050:	0809a423          	sw	zero,136(s3)
    80003054:	bf51                	j	80002fe8 <itrunc+0x3e>

0000000080003056 <iput>:
{
    80003056:	1101                	addi	sp,sp,-32
    80003058:	ec06                	sd	ra,24(sp)
    8000305a:	e822                	sd	s0,16(sp)
    8000305c:	e426                	sd	s1,8(sp)
    8000305e:	e04a                	sd	s2,0(sp)
    80003060:	1000                	addi	s0,sp,32
    80003062:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003064:	00018517          	auipc	a0,0x18
    80003068:	a5450513          	addi	a0,a0,-1452 # 8001aab8 <itable>
    8000306c:	00003097          	auipc	ra,0x3
    80003070:	746080e7          	jalr	1862(ra) # 800067b2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003074:	4498                	lw	a4,8(s1)
    80003076:	4785                	li	a5,1
    80003078:	02f70363          	beq	a4,a5,8000309e <iput+0x48>
  ip->ref--;
    8000307c:	449c                	lw	a5,8(s1)
    8000307e:	37fd                	addiw	a5,a5,-1
    80003080:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003082:	00018517          	auipc	a0,0x18
    80003086:	a3650513          	addi	a0,a0,-1482 # 8001aab8 <itable>
    8000308a:	00003097          	auipc	ra,0x3
    8000308e:	7f8080e7          	jalr	2040(ra) # 80006882 <release>
}
    80003092:	60e2                	ld	ra,24(sp)
    80003094:	6442                	ld	s0,16(sp)
    80003096:	64a2                	ld	s1,8(sp)
    80003098:	6902                	ld	s2,0(sp)
    8000309a:	6105                	addi	sp,sp,32
    8000309c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000309e:	44bc                	lw	a5,72(s1)
    800030a0:	dff1                	beqz	a5,8000307c <iput+0x26>
    800030a2:	05249783          	lh	a5,82(s1)
    800030a6:	fbf9                	bnez	a5,8000307c <iput+0x26>
    acquiresleep(&ip->lock);
    800030a8:	01048913          	addi	s2,s1,16
    800030ac:	854a                	mv	a0,s2
    800030ae:	00001097          	auipc	ra,0x1
    800030b2:	aae080e7          	jalr	-1362(ra) # 80003b5c <acquiresleep>
    release(&itable.lock);
    800030b6:	00018517          	auipc	a0,0x18
    800030ba:	a0250513          	addi	a0,a0,-1534 # 8001aab8 <itable>
    800030be:	00003097          	auipc	ra,0x3
    800030c2:	7c4080e7          	jalr	1988(ra) # 80006882 <release>
    itrunc(ip);
    800030c6:	8526                	mv	a0,s1
    800030c8:	00000097          	auipc	ra,0x0
    800030cc:	ee2080e7          	jalr	-286(ra) # 80002faa <itrunc>
    ip->type = 0;
    800030d0:	04049623          	sh	zero,76(s1)
    iupdate(ip);
    800030d4:	8526                	mv	a0,s1
    800030d6:	00000097          	auipc	ra,0x0
    800030da:	ce6080e7          	jalr	-794(ra) # 80002dbc <iupdate>
    ip->valid = 0;
    800030de:	0404a423          	sw	zero,72(s1)
    releasesleep(&ip->lock);
    800030e2:	854a                	mv	a0,s2
    800030e4:	00001097          	auipc	ra,0x1
    800030e8:	ace080e7          	jalr	-1330(ra) # 80003bb2 <releasesleep>
    acquire(&itable.lock);
    800030ec:	00018517          	auipc	a0,0x18
    800030f0:	9cc50513          	addi	a0,a0,-1588 # 8001aab8 <itable>
    800030f4:	00003097          	auipc	ra,0x3
    800030f8:	6be080e7          	jalr	1726(ra) # 800067b2 <acquire>
    800030fc:	b741                	j	8000307c <iput+0x26>

00000000800030fe <iunlockput>:
{
    800030fe:	1101                	addi	sp,sp,-32
    80003100:	ec06                	sd	ra,24(sp)
    80003102:	e822                	sd	s0,16(sp)
    80003104:	e426                	sd	s1,8(sp)
    80003106:	1000                	addi	s0,sp,32
    80003108:	84aa                	mv	s1,a0
  iunlock(ip);
    8000310a:	00000097          	auipc	ra,0x0
    8000310e:	e4a080e7          	jalr	-438(ra) # 80002f54 <iunlock>
  iput(ip);
    80003112:	8526                	mv	a0,s1
    80003114:	00000097          	auipc	ra,0x0
    80003118:	f42080e7          	jalr	-190(ra) # 80003056 <iput>
}
    8000311c:	60e2                	ld	ra,24(sp)
    8000311e:	6442                	ld	s0,16(sp)
    80003120:	64a2                	ld	s1,8(sp)
    80003122:	6105                	addi	sp,sp,32
    80003124:	8082                	ret

0000000080003126 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003126:	1141                	addi	sp,sp,-16
    80003128:	e422                	sd	s0,8(sp)
    8000312a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000312c:	411c                	lw	a5,0(a0)
    8000312e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003130:	415c                	lw	a5,4(a0)
    80003132:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003134:	04c51783          	lh	a5,76(a0)
    80003138:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000313c:	05251783          	lh	a5,82(a0)
    80003140:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003144:	05456783          	lwu	a5,84(a0)
    80003148:	e99c                	sd	a5,16(a1)
}
    8000314a:	6422                	ld	s0,8(sp)
    8000314c:	0141                	addi	sp,sp,16
    8000314e:	8082                	ret

0000000080003150 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003150:	497c                	lw	a5,84(a0)
    80003152:	0ed7e963          	bltu	a5,a3,80003244 <readi+0xf4>
{
    80003156:	7159                	addi	sp,sp,-112
    80003158:	f486                	sd	ra,104(sp)
    8000315a:	f0a2                	sd	s0,96(sp)
    8000315c:	eca6                	sd	s1,88(sp)
    8000315e:	e8ca                	sd	s2,80(sp)
    80003160:	e4ce                	sd	s3,72(sp)
    80003162:	e0d2                	sd	s4,64(sp)
    80003164:	fc56                	sd	s5,56(sp)
    80003166:	f85a                	sd	s6,48(sp)
    80003168:	f45e                	sd	s7,40(sp)
    8000316a:	f062                	sd	s8,32(sp)
    8000316c:	ec66                	sd	s9,24(sp)
    8000316e:	e86a                	sd	s10,16(sp)
    80003170:	e46e                	sd	s11,8(sp)
    80003172:	1880                	addi	s0,sp,112
    80003174:	8b2a                	mv	s6,a0
    80003176:	8bae                	mv	s7,a1
    80003178:	8a32                	mv	s4,a2
    8000317a:	84b6                	mv	s1,a3
    8000317c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000317e:	9f35                	addw	a4,a4,a3
    return 0;
    80003180:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003182:	0ad76063          	bltu	a4,a3,80003222 <readi+0xd2>
  if(off + n > ip->size)
    80003186:	00e7f463          	bgeu	a5,a4,8000318e <readi+0x3e>
    n = ip->size - off;
    8000318a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000318e:	0a0a8963          	beqz	s5,80003240 <readi+0xf0>
    80003192:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003194:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003198:	5c7d                	li	s8,-1
    8000319a:	a82d                	j	800031d4 <readi+0x84>
    8000319c:	020d1d93          	slli	s11,s10,0x20
    800031a0:	020ddd93          	srli	s11,s11,0x20
    800031a4:	06090613          	addi	a2,s2,96
    800031a8:	86ee                	mv	a3,s11
    800031aa:	963a                	add	a2,a2,a4
    800031ac:	85d2                	mv	a1,s4
    800031ae:	855e                	mv	a0,s7
    800031b0:	fffff097          	auipc	ra,0xfffff
    800031b4:	870080e7          	jalr	-1936(ra) # 80001a20 <either_copyout>
    800031b8:	05850d63          	beq	a0,s8,80003212 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800031bc:	854a                	mv	a0,s2
    800031be:	fffff097          	auipc	ra,0xfffff
    800031c2:	5b2080e7          	jalr	1458(ra) # 80002770 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800031c6:	013d09bb          	addw	s3,s10,s3
    800031ca:	009d04bb          	addw	s1,s10,s1
    800031ce:	9a6e                	add	s4,s4,s11
    800031d0:	0559f763          	bgeu	s3,s5,8000321e <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    800031d4:	00a4d59b          	srliw	a1,s1,0xa
    800031d8:	855a                	mv	a0,s6
    800031da:	00000097          	auipc	ra,0x0
    800031de:	88a080e7          	jalr	-1910(ra) # 80002a64 <bmap>
    800031e2:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800031e6:	cd85                	beqz	a1,8000321e <readi+0xce>
    bp = bread(ip->dev, addr);
    800031e8:	000b2503          	lw	a0,0(s6)
    800031ec:	fffff097          	auipc	ra,0xfffff
    800031f0:	258080e7          	jalr	600(ra) # 80002444 <bread>
    800031f4:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031f6:	3ff4f713          	andi	a4,s1,1023
    800031fa:	40ec87bb          	subw	a5,s9,a4
    800031fe:	413a86bb          	subw	a3,s5,s3
    80003202:	8d3e                	mv	s10,a5
    80003204:	2781                	sext.w	a5,a5
    80003206:	0006861b          	sext.w	a2,a3
    8000320a:	f8f679e3          	bgeu	a2,a5,8000319c <readi+0x4c>
    8000320e:	8d36                	mv	s10,a3
    80003210:	b771                	j	8000319c <readi+0x4c>
      brelse(bp);
    80003212:	854a                	mv	a0,s2
    80003214:	fffff097          	auipc	ra,0xfffff
    80003218:	55c080e7          	jalr	1372(ra) # 80002770 <brelse>
      tot = -1;
    8000321c:	59fd                	li	s3,-1
  }
  return tot;
    8000321e:	0009851b          	sext.w	a0,s3
}
    80003222:	70a6                	ld	ra,104(sp)
    80003224:	7406                	ld	s0,96(sp)
    80003226:	64e6                	ld	s1,88(sp)
    80003228:	6946                	ld	s2,80(sp)
    8000322a:	69a6                	ld	s3,72(sp)
    8000322c:	6a06                	ld	s4,64(sp)
    8000322e:	7ae2                	ld	s5,56(sp)
    80003230:	7b42                	ld	s6,48(sp)
    80003232:	7ba2                	ld	s7,40(sp)
    80003234:	7c02                	ld	s8,32(sp)
    80003236:	6ce2                	ld	s9,24(sp)
    80003238:	6d42                	ld	s10,16(sp)
    8000323a:	6da2                	ld	s11,8(sp)
    8000323c:	6165                	addi	sp,sp,112
    8000323e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003240:	89d6                	mv	s3,s5
    80003242:	bff1                	j	8000321e <readi+0xce>
    return 0;
    80003244:	4501                	li	a0,0
}
    80003246:	8082                	ret

0000000080003248 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003248:	497c                	lw	a5,84(a0)
    8000324a:	10d7e863          	bltu	a5,a3,8000335a <writei+0x112>
{
    8000324e:	7159                	addi	sp,sp,-112
    80003250:	f486                	sd	ra,104(sp)
    80003252:	f0a2                	sd	s0,96(sp)
    80003254:	eca6                	sd	s1,88(sp)
    80003256:	e8ca                	sd	s2,80(sp)
    80003258:	e4ce                	sd	s3,72(sp)
    8000325a:	e0d2                	sd	s4,64(sp)
    8000325c:	fc56                	sd	s5,56(sp)
    8000325e:	f85a                	sd	s6,48(sp)
    80003260:	f45e                	sd	s7,40(sp)
    80003262:	f062                	sd	s8,32(sp)
    80003264:	ec66                	sd	s9,24(sp)
    80003266:	e86a                	sd	s10,16(sp)
    80003268:	e46e                	sd	s11,8(sp)
    8000326a:	1880                	addi	s0,sp,112
    8000326c:	8aaa                	mv	s5,a0
    8000326e:	8bae                	mv	s7,a1
    80003270:	8a32                	mv	s4,a2
    80003272:	8936                	mv	s2,a3
    80003274:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003276:	00e687bb          	addw	a5,a3,a4
    8000327a:	0ed7e263          	bltu	a5,a3,8000335e <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000327e:	00043737          	lui	a4,0x43
    80003282:	0ef76063          	bltu	a4,a5,80003362 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003286:	0c0b0863          	beqz	s6,80003356 <writei+0x10e>
    8000328a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000328c:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003290:	5c7d                	li	s8,-1
    80003292:	a091                	j	800032d6 <writei+0x8e>
    80003294:	020d1d93          	slli	s11,s10,0x20
    80003298:	020ddd93          	srli	s11,s11,0x20
    8000329c:	06048513          	addi	a0,s1,96
    800032a0:	86ee                	mv	a3,s11
    800032a2:	8652                	mv	a2,s4
    800032a4:	85de                	mv	a1,s7
    800032a6:	953a                	add	a0,a0,a4
    800032a8:	ffffe097          	auipc	ra,0xffffe
    800032ac:	7ce080e7          	jalr	1998(ra) # 80001a76 <either_copyin>
    800032b0:	07850263          	beq	a0,s8,80003314 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800032b4:	8526                	mv	a0,s1
    800032b6:	00000097          	auipc	ra,0x0
    800032ba:	788080e7          	jalr	1928(ra) # 80003a3e <log_write>
    brelse(bp);
    800032be:	8526                	mv	a0,s1
    800032c0:	fffff097          	auipc	ra,0xfffff
    800032c4:	4b0080e7          	jalr	1200(ra) # 80002770 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800032c8:	013d09bb          	addw	s3,s10,s3
    800032cc:	012d093b          	addw	s2,s10,s2
    800032d0:	9a6e                	add	s4,s4,s11
    800032d2:	0569f663          	bgeu	s3,s6,8000331e <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800032d6:	00a9559b          	srliw	a1,s2,0xa
    800032da:	8556                	mv	a0,s5
    800032dc:	fffff097          	auipc	ra,0xfffff
    800032e0:	788080e7          	jalr	1928(ra) # 80002a64 <bmap>
    800032e4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800032e8:	c99d                	beqz	a1,8000331e <writei+0xd6>
    bp = bread(ip->dev, addr);
    800032ea:	000aa503          	lw	a0,0(s5)
    800032ee:	fffff097          	auipc	ra,0xfffff
    800032f2:	156080e7          	jalr	342(ra) # 80002444 <bread>
    800032f6:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800032f8:	3ff97713          	andi	a4,s2,1023
    800032fc:	40ec87bb          	subw	a5,s9,a4
    80003300:	413b06bb          	subw	a3,s6,s3
    80003304:	8d3e                	mv	s10,a5
    80003306:	2781                	sext.w	a5,a5
    80003308:	0006861b          	sext.w	a2,a3
    8000330c:	f8f674e3          	bgeu	a2,a5,80003294 <writei+0x4c>
    80003310:	8d36                	mv	s10,a3
    80003312:	b749                	j	80003294 <writei+0x4c>
      brelse(bp);
    80003314:	8526                	mv	a0,s1
    80003316:	fffff097          	auipc	ra,0xfffff
    8000331a:	45a080e7          	jalr	1114(ra) # 80002770 <brelse>
  }

  if(off > ip->size)
    8000331e:	054aa783          	lw	a5,84(s5)
    80003322:	0127f463          	bgeu	a5,s2,8000332a <writei+0xe2>
    ip->size = off;
    80003326:	052aaa23          	sw	s2,84(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000332a:	8556                	mv	a0,s5
    8000332c:	00000097          	auipc	ra,0x0
    80003330:	a90080e7          	jalr	-1392(ra) # 80002dbc <iupdate>

  return tot;
    80003334:	0009851b          	sext.w	a0,s3
}
    80003338:	70a6                	ld	ra,104(sp)
    8000333a:	7406                	ld	s0,96(sp)
    8000333c:	64e6                	ld	s1,88(sp)
    8000333e:	6946                	ld	s2,80(sp)
    80003340:	69a6                	ld	s3,72(sp)
    80003342:	6a06                	ld	s4,64(sp)
    80003344:	7ae2                	ld	s5,56(sp)
    80003346:	7b42                	ld	s6,48(sp)
    80003348:	7ba2                	ld	s7,40(sp)
    8000334a:	7c02                	ld	s8,32(sp)
    8000334c:	6ce2                	ld	s9,24(sp)
    8000334e:	6d42                	ld	s10,16(sp)
    80003350:	6da2                	ld	s11,8(sp)
    80003352:	6165                	addi	sp,sp,112
    80003354:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003356:	89da                	mv	s3,s6
    80003358:	bfc9                	j	8000332a <writei+0xe2>
    return -1;
    8000335a:	557d                	li	a0,-1
}
    8000335c:	8082                	ret
    return -1;
    8000335e:	557d                	li	a0,-1
    80003360:	bfe1                	j	80003338 <writei+0xf0>
    return -1;
    80003362:	557d                	li	a0,-1
    80003364:	bfd1                	j	80003338 <writei+0xf0>

0000000080003366 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003366:	1141                	addi	sp,sp,-16
    80003368:	e406                	sd	ra,8(sp)
    8000336a:	e022                	sd	s0,0(sp)
    8000336c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000336e:	4639                	li	a2,14
    80003370:	ffffd097          	auipc	ra,0xffffd
    80003374:	fe6080e7          	jalr	-26(ra) # 80000356 <strncmp>
}
    80003378:	60a2                	ld	ra,8(sp)
    8000337a:	6402                	ld	s0,0(sp)
    8000337c:	0141                	addi	sp,sp,16
    8000337e:	8082                	ret

0000000080003380 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003380:	7139                	addi	sp,sp,-64
    80003382:	fc06                	sd	ra,56(sp)
    80003384:	f822                	sd	s0,48(sp)
    80003386:	f426                	sd	s1,40(sp)
    80003388:	f04a                	sd	s2,32(sp)
    8000338a:	ec4e                	sd	s3,24(sp)
    8000338c:	e852                	sd	s4,16(sp)
    8000338e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003390:	04c51703          	lh	a4,76(a0)
    80003394:	4785                	li	a5,1
    80003396:	00f71a63          	bne	a4,a5,800033aa <dirlookup+0x2a>
    8000339a:	892a                	mv	s2,a0
    8000339c:	89ae                	mv	s3,a1
    8000339e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800033a0:	497c                	lw	a5,84(a0)
    800033a2:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800033a4:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033a6:	e79d                	bnez	a5,800033d4 <dirlookup+0x54>
    800033a8:	a8a5                	j	80003420 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800033aa:	00005517          	auipc	a0,0x5
    800033ae:	1de50513          	addi	a0,a0,478 # 80008588 <syscalls+0x1b8>
    800033b2:	00003097          	auipc	ra,0x3
    800033b6:	ede080e7          	jalr	-290(ra) # 80006290 <panic>
      panic("dirlookup read");
    800033ba:	00005517          	auipc	a0,0x5
    800033be:	1e650513          	addi	a0,a0,486 # 800085a0 <syscalls+0x1d0>
    800033c2:	00003097          	auipc	ra,0x3
    800033c6:	ece080e7          	jalr	-306(ra) # 80006290 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033ca:	24c1                	addiw	s1,s1,16
    800033cc:	05492783          	lw	a5,84(s2)
    800033d0:	04f4f763          	bgeu	s1,a5,8000341e <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033d4:	4741                	li	a4,16
    800033d6:	86a6                	mv	a3,s1
    800033d8:	fc040613          	addi	a2,s0,-64
    800033dc:	4581                	li	a1,0
    800033de:	854a                	mv	a0,s2
    800033e0:	00000097          	auipc	ra,0x0
    800033e4:	d70080e7          	jalr	-656(ra) # 80003150 <readi>
    800033e8:	47c1                	li	a5,16
    800033ea:	fcf518e3          	bne	a0,a5,800033ba <dirlookup+0x3a>
    if(de.inum == 0)
    800033ee:	fc045783          	lhu	a5,-64(s0)
    800033f2:	dfe1                	beqz	a5,800033ca <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800033f4:	fc240593          	addi	a1,s0,-62
    800033f8:	854e                	mv	a0,s3
    800033fa:	00000097          	auipc	ra,0x0
    800033fe:	f6c080e7          	jalr	-148(ra) # 80003366 <namecmp>
    80003402:	f561                	bnez	a0,800033ca <dirlookup+0x4a>
      if(poff)
    80003404:	000a0463          	beqz	s4,8000340c <dirlookup+0x8c>
        *poff = off;
    80003408:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000340c:	fc045583          	lhu	a1,-64(s0)
    80003410:	00092503          	lw	a0,0(s2)
    80003414:	fffff097          	auipc	ra,0xfffff
    80003418:	73a080e7          	jalr	1850(ra) # 80002b4e <iget>
    8000341c:	a011                	j	80003420 <dirlookup+0xa0>
  return 0;
    8000341e:	4501                	li	a0,0
}
    80003420:	70e2                	ld	ra,56(sp)
    80003422:	7442                	ld	s0,48(sp)
    80003424:	74a2                	ld	s1,40(sp)
    80003426:	7902                	ld	s2,32(sp)
    80003428:	69e2                	ld	s3,24(sp)
    8000342a:	6a42                	ld	s4,16(sp)
    8000342c:	6121                	addi	sp,sp,64
    8000342e:	8082                	ret

0000000080003430 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003430:	711d                	addi	sp,sp,-96
    80003432:	ec86                	sd	ra,88(sp)
    80003434:	e8a2                	sd	s0,80(sp)
    80003436:	e4a6                	sd	s1,72(sp)
    80003438:	e0ca                	sd	s2,64(sp)
    8000343a:	fc4e                	sd	s3,56(sp)
    8000343c:	f852                	sd	s4,48(sp)
    8000343e:	f456                	sd	s5,40(sp)
    80003440:	f05a                	sd	s6,32(sp)
    80003442:	ec5e                	sd	s7,24(sp)
    80003444:	e862                	sd	s8,16(sp)
    80003446:	e466                	sd	s9,8(sp)
    80003448:	e06a                	sd	s10,0(sp)
    8000344a:	1080                	addi	s0,sp,96
    8000344c:	84aa                	mv	s1,a0
    8000344e:	8b2e                	mv	s6,a1
    80003450:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003452:	00054703          	lbu	a4,0(a0)
    80003456:	02f00793          	li	a5,47
    8000345a:	02f70363          	beq	a4,a5,80003480 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000345e:	ffffe097          	auipc	ra,0xffffe
    80003462:	b12080e7          	jalr	-1262(ra) # 80000f70 <myproc>
    80003466:	15853503          	ld	a0,344(a0)
    8000346a:	00000097          	auipc	ra,0x0
    8000346e:	9e0080e7          	jalr	-1568(ra) # 80002e4a <idup>
    80003472:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003474:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003478:	4cb5                	li	s9,13
  len = path - s;
    8000347a:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000347c:	4c05                	li	s8,1
    8000347e:	a87d                	j	8000353c <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003480:	4585                	li	a1,1
    80003482:	4505                	li	a0,1
    80003484:	fffff097          	auipc	ra,0xfffff
    80003488:	6ca080e7          	jalr	1738(ra) # 80002b4e <iget>
    8000348c:	8a2a                	mv	s4,a0
    8000348e:	b7dd                	j	80003474 <namex+0x44>
      iunlockput(ip);
    80003490:	8552                	mv	a0,s4
    80003492:	00000097          	auipc	ra,0x0
    80003496:	c6c080e7          	jalr	-916(ra) # 800030fe <iunlockput>
      return 0;
    8000349a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000349c:	8552                	mv	a0,s4
    8000349e:	60e6                	ld	ra,88(sp)
    800034a0:	6446                	ld	s0,80(sp)
    800034a2:	64a6                	ld	s1,72(sp)
    800034a4:	6906                	ld	s2,64(sp)
    800034a6:	79e2                	ld	s3,56(sp)
    800034a8:	7a42                	ld	s4,48(sp)
    800034aa:	7aa2                	ld	s5,40(sp)
    800034ac:	7b02                	ld	s6,32(sp)
    800034ae:	6be2                	ld	s7,24(sp)
    800034b0:	6c42                	ld	s8,16(sp)
    800034b2:	6ca2                	ld	s9,8(sp)
    800034b4:	6d02                	ld	s10,0(sp)
    800034b6:	6125                	addi	sp,sp,96
    800034b8:	8082                	ret
      iunlock(ip);
    800034ba:	8552                	mv	a0,s4
    800034bc:	00000097          	auipc	ra,0x0
    800034c0:	a98080e7          	jalr	-1384(ra) # 80002f54 <iunlock>
      return ip;
    800034c4:	bfe1                	j	8000349c <namex+0x6c>
      iunlockput(ip);
    800034c6:	8552                	mv	a0,s4
    800034c8:	00000097          	auipc	ra,0x0
    800034cc:	c36080e7          	jalr	-970(ra) # 800030fe <iunlockput>
      return 0;
    800034d0:	8a4e                	mv	s4,s3
    800034d2:	b7e9                	j	8000349c <namex+0x6c>
  len = path - s;
    800034d4:	40998633          	sub	a2,s3,s1
    800034d8:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800034dc:	09acd863          	bge	s9,s10,8000356c <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800034e0:	4639                	li	a2,14
    800034e2:	85a6                	mv	a1,s1
    800034e4:	8556                	mv	a0,s5
    800034e6:	ffffd097          	auipc	ra,0xffffd
    800034ea:	dfc080e7          	jalr	-516(ra) # 800002e2 <memmove>
    800034ee:	84ce                	mv	s1,s3
  while(*path == '/')
    800034f0:	0004c783          	lbu	a5,0(s1)
    800034f4:	01279763          	bne	a5,s2,80003502 <namex+0xd2>
    path++;
    800034f8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800034fa:	0004c783          	lbu	a5,0(s1)
    800034fe:	ff278de3          	beq	a5,s2,800034f8 <namex+0xc8>
    ilock(ip);
    80003502:	8552                	mv	a0,s4
    80003504:	00000097          	auipc	ra,0x0
    80003508:	984080e7          	jalr	-1660(ra) # 80002e88 <ilock>
    if(ip->type != T_DIR){
    8000350c:	04ca1783          	lh	a5,76(s4)
    80003510:	f98790e3          	bne	a5,s8,80003490 <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003514:	000b0563          	beqz	s6,8000351e <namex+0xee>
    80003518:	0004c783          	lbu	a5,0(s1)
    8000351c:	dfd9                	beqz	a5,800034ba <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000351e:	865e                	mv	a2,s7
    80003520:	85d6                	mv	a1,s5
    80003522:	8552                	mv	a0,s4
    80003524:	00000097          	auipc	ra,0x0
    80003528:	e5c080e7          	jalr	-420(ra) # 80003380 <dirlookup>
    8000352c:	89aa                	mv	s3,a0
    8000352e:	dd41                	beqz	a0,800034c6 <namex+0x96>
    iunlockput(ip);
    80003530:	8552                	mv	a0,s4
    80003532:	00000097          	auipc	ra,0x0
    80003536:	bcc080e7          	jalr	-1076(ra) # 800030fe <iunlockput>
    ip = next;
    8000353a:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000353c:	0004c783          	lbu	a5,0(s1)
    80003540:	01279763          	bne	a5,s2,8000354e <namex+0x11e>
    path++;
    80003544:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003546:	0004c783          	lbu	a5,0(s1)
    8000354a:	ff278de3          	beq	a5,s2,80003544 <namex+0x114>
  if(*path == 0)
    8000354e:	cb9d                	beqz	a5,80003584 <namex+0x154>
  while(*path != '/' && *path != 0)
    80003550:	0004c783          	lbu	a5,0(s1)
    80003554:	89a6                	mv	s3,s1
  len = path - s;
    80003556:	8d5e                	mv	s10,s7
    80003558:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000355a:	01278963          	beq	a5,s2,8000356c <namex+0x13c>
    8000355e:	dbbd                	beqz	a5,800034d4 <namex+0xa4>
    path++;
    80003560:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003562:	0009c783          	lbu	a5,0(s3)
    80003566:	ff279ce3          	bne	a5,s2,8000355e <namex+0x12e>
    8000356a:	b7ad                	j	800034d4 <namex+0xa4>
    memmove(name, s, len);
    8000356c:	2601                	sext.w	a2,a2
    8000356e:	85a6                	mv	a1,s1
    80003570:	8556                	mv	a0,s5
    80003572:	ffffd097          	auipc	ra,0xffffd
    80003576:	d70080e7          	jalr	-656(ra) # 800002e2 <memmove>
    name[len] = 0;
    8000357a:	9d56                	add	s10,s10,s5
    8000357c:	000d0023          	sb	zero,0(s10)
    80003580:	84ce                	mv	s1,s3
    80003582:	b7bd                	j	800034f0 <namex+0xc0>
  if(nameiparent){
    80003584:	f00b0ce3          	beqz	s6,8000349c <namex+0x6c>
    iput(ip);
    80003588:	8552                	mv	a0,s4
    8000358a:	00000097          	auipc	ra,0x0
    8000358e:	acc080e7          	jalr	-1332(ra) # 80003056 <iput>
    return 0;
    80003592:	4a01                	li	s4,0
    80003594:	b721                	j	8000349c <namex+0x6c>

0000000080003596 <dirlink>:
{
    80003596:	7139                	addi	sp,sp,-64
    80003598:	fc06                	sd	ra,56(sp)
    8000359a:	f822                	sd	s0,48(sp)
    8000359c:	f426                	sd	s1,40(sp)
    8000359e:	f04a                	sd	s2,32(sp)
    800035a0:	ec4e                	sd	s3,24(sp)
    800035a2:	e852                	sd	s4,16(sp)
    800035a4:	0080                	addi	s0,sp,64
    800035a6:	892a                	mv	s2,a0
    800035a8:	8a2e                	mv	s4,a1
    800035aa:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800035ac:	4601                	li	a2,0
    800035ae:	00000097          	auipc	ra,0x0
    800035b2:	dd2080e7          	jalr	-558(ra) # 80003380 <dirlookup>
    800035b6:	e93d                	bnez	a0,8000362c <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800035b8:	05492483          	lw	s1,84(s2)
    800035bc:	c49d                	beqz	s1,800035ea <dirlink+0x54>
    800035be:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800035c0:	4741                	li	a4,16
    800035c2:	86a6                	mv	a3,s1
    800035c4:	fc040613          	addi	a2,s0,-64
    800035c8:	4581                	li	a1,0
    800035ca:	854a                	mv	a0,s2
    800035cc:	00000097          	auipc	ra,0x0
    800035d0:	b84080e7          	jalr	-1148(ra) # 80003150 <readi>
    800035d4:	47c1                	li	a5,16
    800035d6:	06f51163          	bne	a0,a5,80003638 <dirlink+0xa2>
    if(de.inum == 0)
    800035da:	fc045783          	lhu	a5,-64(s0)
    800035de:	c791                	beqz	a5,800035ea <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800035e0:	24c1                	addiw	s1,s1,16
    800035e2:	05492783          	lw	a5,84(s2)
    800035e6:	fcf4ede3          	bltu	s1,a5,800035c0 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800035ea:	4639                	li	a2,14
    800035ec:	85d2                	mv	a1,s4
    800035ee:	fc240513          	addi	a0,s0,-62
    800035f2:	ffffd097          	auipc	ra,0xffffd
    800035f6:	da0080e7          	jalr	-608(ra) # 80000392 <strncpy>
  de.inum = inum;
    800035fa:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800035fe:	4741                	li	a4,16
    80003600:	86a6                	mv	a3,s1
    80003602:	fc040613          	addi	a2,s0,-64
    80003606:	4581                	li	a1,0
    80003608:	854a                	mv	a0,s2
    8000360a:	00000097          	auipc	ra,0x0
    8000360e:	c3e080e7          	jalr	-962(ra) # 80003248 <writei>
    80003612:	1541                	addi	a0,a0,-16
    80003614:	00a03533          	snez	a0,a0
    80003618:	40a00533          	neg	a0,a0
}
    8000361c:	70e2                	ld	ra,56(sp)
    8000361e:	7442                	ld	s0,48(sp)
    80003620:	74a2                	ld	s1,40(sp)
    80003622:	7902                	ld	s2,32(sp)
    80003624:	69e2                	ld	s3,24(sp)
    80003626:	6a42                	ld	s4,16(sp)
    80003628:	6121                	addi	sp,sp,64
    8000362a:	8082                	ret
    iput(ip);
    8000362c:	00000097          	auipc	ra,0x0
    80003630:	a2a080e7          	jalr	-1494(ra) # 80003056 <iput>
    return -1;
    80003634:	557d                	li	a0,-1
    80003636:	b7dd                	j	8000361c <dirlink+0x86>
      panic("dirlink read");
    80003638:	00005517          	auipc	a0,0x5
    8000363c:	f7850513          	addi	a0,a0,-136 # 800085b0 <syscalls+0x1e0>
    80003640:	00003097          	auipc	ra,0x3
    80003644:	c50080e7          	jalr	-944(ra) # 80006290 <panic>

0000000080003648 <namei>:

struct inode*
namei(char *path)
{
    80003648:	1101                	addi	sp,sp,-32
    8000364a:	ec06                	sd	ra,24(sp)
    8000364c:	e822                	sd	s0,16(sp)
    8000364e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003650:	fe040613          	addi	a2,s0,-32
    80003654:	4581                	li	a1,0
    80003656:	00000097          	auipc	ra,0x0
    8000365a:	dda080e7          	jalr	-550(ra) # 80003430 <namex>
}
    8000365e:	60e2                	ld	ra,24(sp)
    80003660:	6442                	ld	s0,16(sp)
    80003662:	6105                	addi	sp,sp,32
    80003664:	8082                	ret

0000000080003666 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003666:	1141                	addi	sp,sp,-16
    80003668:	e406                	sd	ra,8(sp)
    8000366a:	e022                	sd	s0,0(sp)
    8000366c:	0800                	addi	s0,sp,16
    8000366e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003670:	4585                	li	a1,1
    80003672:	00000097          	auipc	ra,0x0
    80003676:	dbe080e7          	jalr	-578(ra) # 80003430 <namex>
}
    8000367a:	60a2                	ld	ra,8(sp)
    8000367c:	6402                	ld	s0,0(sp)
    8000367e:	0141                	addi	sp,sp,16
    80003680:	8082                	ret

0000000080003682 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003682:	1101                	addi	sp,sp,-32
    80003684:	ec06                	sd	ra,24(sp)
    80003686:	e822                	sd	s0,16(sp)
    80003688:	e426                	sd	s1,8(sp)
    8000368a:	e04a                	sd	s2,0(sp)
    8000368c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000368e:	00019917          	auipc	s2,0x19
    80003692:	06a90913          	addi	s2,s2,106 # 8001c6f8 <log>
    80003696:	02092583          	lw	a1,32(s2)
    8000369a:	03092503          	lw	a0,48(s2)
    8000369e:	fffff097          	auipc	ra,0xfffff
    800036a2:	da6080e7          	jalr	-602(ra) # 80002444 <bread>
    800036a6:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800036a8:	03492683          	lw	a3,52(s2)
    800036ac:	d134                	sw	a3,96(a0)
  for (i = 0; i < log.lh.n; i++) {
    800036ae:	02d05863          	blez	a3,800036de <write_head+0x5c>
    800036b2:	00019797          	auipc	a5,0x19
    800036b6:	07e78793          	addi	a5,a5,126 # 8001c730 <log+0x38>
    800036ba:	06450713          	addi	a4,a0,100
    800036be:	36fd                	addiw	a3,a3,-1
    800036c0:	02069613          	slli	a2,a3,0x20
    800036c4:	01e65693          	srli	a3,a2,0x1e
    800036c8:	00019617          	auipc	a2,0x19
    800036cc:	06c60613          	addi	a2,a2,108 # 8001c734 <log+0x3c>
    800036d0:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800036d2:	4390                	lw	a2,0(a5)
    800036d4:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800036d6:	0791                	addi	a5,a5,4
    800036d8:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    800036da:	fed79ce3          	bne	a5,a3,800036d2 <write_head+0x50>
  }
  bwrite(buf);
    800036de:	8526                	mv	a0,s1
    800036e0:	fffff097          	auipc	ra,0xfffff
    800036e4:	052080e7          	jalr	82(ra) # 80002732 <bwrite>
  brelse(buf);
    800036e8:	8526                	mv	a0,s1
    800036ea:	fffff097          	auipc	ra,0xfffff
    800036ee:	086080e7          	jalr	134(ra) # 80002770 <brelse>
}
    800036f2:	60e2                	ld	ra,24(sp)
    800036f4:	6442                	ld	s0,16(sp)
    800036f6:	64a2                	ld	s1,8(sp)
    800036f8:	6902                	ld	s2,0(sp)
    800036fa:	6105                	addi	sp,sp,32
    800036fc:	8082                	ret

00000000800036fe <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800036fe:	00019797          	auipc	a5,0x19
    80003702:	02e7a783          	lw	a5,46(a5) # 8001c72c <log+0x34>
    80003706:	0af05d63          	blez	a5,800037c0 <install_trans+0xc2>
{
    8000370a:	7139                	addi	sp,sp,-64
    8000370c:	fc06                	sd	ra,56(sp)
    8000370e:	f822                	sd	s0,48(sp)
    80003710:	f426                	sd	s1,40(sp)
    80003712:	f04a                	sd	s2,32(sp)
    80003714:	ec4e                	sd	s3,24(sp)
    80003716:	e852                	sd	s4,16(sp)
    80003718:	e456                	sd	s5,8(sp)
    8000371a:	e05a                	sd	s6,0(sp)
    8000371c:	0080                	addi	s0,sp,64
    8000371e:	8b2a                	mv	s6,a0
    80003720:	00019a97          	auipc	s5,0x19
    80003724:	010a8a93          	addi	s5,s5,16 # 8001c730 <log+0x38>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003728:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000372a:	00019997          	auipc	s3,0x19
    8000372e:	fce98993          	addi	s3,s3,-50 # 8001c6f8 <log>
    80003732:	a00d                	j	80003754 <install_trans+0x56>
    brelse(lbuf);
    80003734:	854a                	mv	a0,s2
    80003736:	fffff097          	auipc	ra,0xfffff
    8000373a:	03a080e7          	jalr	58(ra) # 80002770 <brelse>
    brelse(dbuf);
    8000373e:	8526                	mv	a0,s1
    80003740:	fffff097          	auipc	ra,0xfffff
    80003744:	030080e7          	jalr	48(ra) # 80002770 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003748:	2a05                	addiw	s4,s4,1
    8000374a:	0a91                	addi	s5,s5,4
    8000374c:	0349a783          	lw	a5,52(s3)
    80003750:	04fa5e63          	bge	s4,a5,800037ac <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003754:	0209a583          	lw	a1,32(s3)
    80003758:	014585bb          	addw	a1,a1,s4
    8000375c:	2585                	addiw	a1,a1,1
    8000375e:	0309a503          	lw	a0,48(s3)
    80003762:	fffff097          	auipc	ra,0xfffff
    80003766:	ce2080e7          	jalr	-798(ra) # 80002444 <bread>
    8000376a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000376c:	000aa583          	lw	a1,0(s5)
    80003770:	0309a503          	lw	a0,48(s3)
    80003774:	fffff097          	auipc	ra,0xfffff
    80003778:	cd0080e7          	jalr	-816(ra) # 80002444 <bread>
    8000377c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000377e:	40000613          	li	a2,1024
    80003782:	06090593          	addi	a1,s2,96
    80003786:	06050513          	addi	a0,a0,96
    8000378a:	ffffd097          	auipc	ra,0xffffd
    8000378e:	b58080e7          	jalr	-1192(ra) # 800002e2 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003792:	8526                	mv	a0,s1
    80003794:	fffff097          	auipc	ra,0xfffff
    80003798:	f9e080e7          	jalr	-98(ra) # 80002732 <bwrite>
    if(recovering == 0)
    8000379c:	f80b1ce3          	bnez	s6,80003734 <install_trans+0x36>
      bunpin(dbuf);
    800037a0:	8526                	mv	a0,s1
    800037a2:	fffff097          	auipc	ra,0xfffff
    800037a6:	0bc080e7          	jalr	188(ra) # 8000285e <bunpin>
    800037aa:	b769                	j	80003734 <install_trans+0x36>
}
    800037ac:	70e2                	ld	ra,56(sp)
    800037ae:	7442                	ld	s0,48(sp)
    800037b0:	74a2                	ld	s1,40(sp)
    800037b2:	7902                	ld	s2,32(sp)
    800037b4:	69e2                	ld	s3,24(sp)
    800037b6:	6a42                	ld	s4,16(sp)
    800037b8:	6aa2                	ld	s5,8(sp)
    800037ba:	6b02                	ld	s6,0(sp)
    800037bc:	6121                	addi	sp,sp,64
    800037be:	8082                	ret
    800037c0:	8082                	ret

00000000800037c2 <initlog>:
{
    800037c2:	7179                	addi	sp,sp,-48
    800037c4:	f406                	sd	ra,40(sp)
    800037c6:	f022                	sd	s0,32(sp)
    800037c8:	ec26                	sd	s1,24(sp)
    800037ca:	e84a                	sd	s2,16(sp)
    800037cc:	e44e                	sd	s3,8(sp)
    800037ce:	1800                	addi	s0,sp,48
    800037d0:	892a                	mv	s2,a0
    800037d2:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800037d4:	00019497          	auipc	s1,0x19
    800037d8:	f2448493          	addi	s1,s1,-220 # 8001c6f8 <log>
    800037dc:	00005597          	auipc	a1,0x5
    800037e0:	de458593          	addi	a1,a1,-540 # 800085c0 <syscalls+0x1f0>
    800037e4:	8526                	mv	a0,s1
    800037e6:	00003097          	auipc	ra,0x3
    800037ea:	148080e7          	jalr	328(ra) # 8000692e <initlock>
  log.start = sb->logstart;
    800037ee:	0149a583          	lw	a1,20(s3)
    800037f2:	d08c                	sw	a1,32(s1)
  log.size = sb->nlog;
    800037f4:	0109a783          	lw	a5,16(s3)
    800037f8:	d0dc                	sw	a5,36(s1)
  log.dev = dev;
    800037fa:	0324a823          	sw	s2,48(s1)
  struct buf *buf = bread(log.dev, log.start);
    800037fe:	854a                	mv	a0,s2
    80003800:	fffff097          	auipc	ra,0xfffff
    80003804:	c44080e7          	jalr	-956(ra) # 80002444 <bread>
  log.lh.n = lh->n;
    80003808:	5134                	lw	a3,96(a0)
    8000380a:	d8d4                	sw	a3,52(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000380c:	02d05663          	blez	a3,80003838 <initlog+0x76>
    80003810:	06450793          	addi	a5,a0,100
    80003814:	00019717          	auipc	a4,0x19
    80003818:	f1c70713          	addi	a4,a4,-228 # 8001c730 <log+0x38>
    8000381c:	36fd                	addiw	a3,a3,-1
    8000381e:	02069613          	slli	a2,a3,0x20
    80003822:	01e65693          	srli	a3,a2,0x1e
    80003826:	06850613          	addi	a2,a0,104
    8000382a:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    8000382c:	4390                	lw	a2,0(a5)
    8000382e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003830:	0791                	addi	a5,a5,4
    80003832:	0711                	addi	a4,a4,4
    80003834:	fed79ce3          	bne	a5,a3,8000382c <initlog+0x6a>
  brelse(buf);
    80003838:	fffff097          	auipc	ra,0xfffff
    8000383c:	f38080e7          	jalr	-200(ra) # 80002770 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003840:	4505                	li	a0,1
    80003842:	00000097          	auipc	ra,0x0
    80003846:	ebc080e7          	jalr	-324(ra) # 800036fe <install_trans>
  log.lh.n = 0;
    8000384a:	00019797          	auipc	a5,0x19
    8000384e:	ee07a123          	sw	zero,-286(a5) # 8001c72c <log+0x34>
  write_head(); // clear the log
    80003852:	00000097          	auipc	ra,0x0
    80003856:	e30080e7          	jalr	-464(ra) # 80003682 <write_head>
}
    8000385a:	70a2                	ld	ra,40(sp)
    8000385c:	7402                	ld	s0,32(sp)
    8000385e:	64e2                	ld	s1,24(sp)
    80003860:	6942                	ld	s2,16(sp)
    80003862:	69a2                	ld	s3,8(sp)
    80003864:	6145                	addi	sp,sp,48
    80003866:	8082                	ret

0000000080003868 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003868:	1101                	addi	sp,sp,-32
    8000386a:	ec06                	sd	ra,24(sp)
    8000386c:	e822                	sd	s0,16(sp)
    8000386e:	e426                	sd	s1,8(sp)
    80003870:	e04a                	sd	s2,0(sp)
    80003872:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003874:	00019517          	auipc	a0,0x19
    80003878:	e8450513          	addi	a0,a0,-380 # 8001c6f8 <log>
    8000387c:	00003097          	auipc	ra,0x3
    80003880:	f36080e7          	jalr	-202(ra) # 800067b2 <acquire>
  while(1){
    if(log.committing){
    80003884:	00019497          	auipc	s1,0x19
    80003888:	e7448493          	addi	s1,s1,-396 # 8001c6f8 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000388c:	4979                	li	s2,30
    8000388e:	a039                	j	8000389c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003890:	85a6                	mv	a1,s1
    80003892:	8526                	mv	a0,s1
    80003894:	ffffe097          	auipc	ra,0xffffe
    80003898:	d84080e7          	jalr	-636(ra) # 80001618 <sleep>
    if(log.committing){
    8000389c:	54dc                	lw	a5,44(s1)
    8000389e:	fbed                	bnez	a5,80003890 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800038a0:	5498                	lw	a4,40(s1)
    800038a2:	2705                	addiw	a4,a4,1
    800038a4:	0007069b          	sext.w	a3,a4
    800038a8:	0027179b          	slliw	a5,a4,0x2
    800038ac:	9fb9                	addw	a5,a5,a4
    800038ae:	0017979b          	slliw	a5,a5,0x1
    800038b2:	58d8                	lw	a4,52(s1)
    800038b4:	9fb9                	addw	a5,a5,a4
    800038b6:	00f95963          	bge	s2,a5,800038c8 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800038ba:	85a6                	mv	a1,s1
    800038bc:	8526                	mv	a0,s1
    800038be:	ffffe097          	auipc	ra,0xffffe
    800038c2:	d5a080e7          	jalr	-678(ra) # 80001618 <sleep>
    800038c6:	bfd9                	j	8000389c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800038c8:	00019517          	auipc	a0,0x19
    800038cc:	e3050513          	addi	a0,a0,-464 # 8001c6f8 <log>
    800038d0:	d514                	sw	a3,40(a0)
      release(&log.lock);
    800038d2:	00003097          	auipc	ra,0x3
    800038d6:	fb0080e7          	jalr	-80(ra) # 80006882 <release>
      break;
    }
  }
}
    800038da:	60e2                	ld	ra,24(sp)
    800038dc:	6442                	ld	s0,16(sp)
    800038de:	64a2                	ld	s1,8(sp)
    800038e0:	6902                	ld	s2,0(sp)
    800038e2:	6105                	addi	sp,sp,32
    800038e4:	8082                	ret

00000000800038e6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800038e6:	7139                	addi	sp,sp,-64
    800038e8:	fc06                	sd	ra,56(sp)
    800038ea:	f822                	sd	s0,48(sp)
    800038ec:	f426                	sd	s1,40(sp)
    800038ee:	f04a                	sd	s2,32(sp)
    800038f0:	ec4e                	sd	s3,24(sp)
    800038f2:	e852                	sd	s4,16(sp)
    800038f4:	e456                	sd	s5,8(sp)
    800038f6:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800038f8:	00019497          	auipc	s1,0x19
    800038fc:	e0048493          	addi	s1,s1,-512 # 8001c6f8 <log>
    80003900:	8526                	mv	a0,s1
    80003902:	00003097          	auipc	ra,0x3
    80003906:	eb0080e7          	jalr	-336(ra) # 800067b2 <acquire>
  log.outstanding -= 1;
    8000390a:	549c                	lw	a5,40(s1)
    8000390c:	37fd                	addiw	a5,a5,-1
    8000390e:	0007891b          	sext.w	s2,a5
    80003912:	d49c                	sw	a5,40(s1)
  if(log.committing)
    80003914:	54dc                	lw	a5,44(s1)
    80003916:	e7b9                	bnez	a5,80003964 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003918:	04091e63          	bnez	s2,80003974 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000391c:	00019497          	auipc	s1,0x19
    80003920:	ddc48493          	addi	s1,s1,-548 # 8001c6f8 <log>
    80003924:	4785                	li	a5,1
    80003926:	d4dc                	sw	a5,44(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003928:	8526                	mv	a0,s1
    8000392a:	00003097          	auipc	ra,0x3
    8000392e:	f58080e7          	jalr	-168(ra) # 80006882 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003932:	58dc                	lw	a5,52(s1)
    80003934:	06f04763          	bgtz	a5,800039a2 <end_op+0xbc>
    acquire(&log.lock);
    80003938:	00019497          	auipc	s1,0x19
    8000393c:	dc048493          	addi	s1,s1,-576 # 8001c6f8 <log>
    80003940:	8526                	mv	a0,s1
    80003942:	00003097          	auipc	ra,0x3
    80003946:	e70080e7          	jalr	-400(ra) # 800067b2 <acquire>
    log.committing = 0;
    8000394a:	0204a623          	sw	zero,44(s1)
    wakeup(&log);
    8000394e:	8526                	mv	a0,s1
    80003950:	ffffe097          	auipc	ra,0xffffe
    80003954:	d2c080e7          	jalr	-724(ra) # 8000167c <wakeup>
    release(&log.lock);
    80003958:	8526                	mv	a0,s1
    8000395a:	00003097          	auipc	ra,0x3
    8000395e:	f28080e7          	jalr	-216(ra) # 80006882 <release>
}
    80003962:	a03d                	j	80003990 <end_op+0xaa>
    panic("log.committing");
    80003964:	00005517          	auipc	a0,0x5
    80003968:	c6450513          	addi	a0,a0,-924 # 800085c8 <syscalls+0x1f8>
    8000396c:	00003097          	auipc	ra,0x3
    80003970:	924080e7          	jalr	-1756(ra) # 80006290 <panic>
    wakeup(&log);
    80003974:	00019497          	auipc	s1,0x19
    80003978:	d8448493          	addi	s1,s1,-636 # 8001c6f8 <log>
    8000397c:	8526                	mv	a0,s1
    8000397e:	ffffe097          	auipc	ra,0xffffe
    80003982:	cfe080e7          	jalr	-770(ra) # 8000167c <wakeup>
  release(&log.lock);
    80003986:	8526                	mv	a0,s1
    80003988:	00003097          	auipc	ra,0x3
    8000398c:	efa080e7          	jalr	-262(ra) # 80006882 <release>
}
    80003990:	70e2                	ld	ra,56(sp)
    80003992:	7442                	ld	s0,48(sp)
    80003994:	74a2                	ld	s1,40(sp)
    80003996:	7902                	ld	s2,32(sp)
    80003998:	69e2                	ld	s3,24(sp)
    8000399a:	6a42                	ld	s4,16(sp)
    8000399c:	6aa2                	ld	s5,8(sp)
    8000399e:	6121                	addi	sp,sp,64
    800039a0:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800039a2:	00019a97          	auipc	s5,0x19
    800039a6:	d8ea8a93          	addi	s5,s5,-626 # 8001c730 <log+0x38>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800039aa:	00019a17          	auipc	s4,0x19
    800039ae:	d4ea0a13          	addi	s4,s4,-690 # 8001c6f8 <log>
    800039b2:	020a2583          	lw	a1,32(s4)
    800039b6:	012585bb          	addw	a1,a1,s2
    800039ba:	2585                	addiw	a1,a1,1
    800039bc:	030a2503          	lw	a0,48(s4)
    800039c0:	fffff097          	auipc	ra,0xfffff
    800039c4:	a84080e7          	jalr	-1404(ra) # 80002444 <bread>
    800039c8:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800039ca:	000aa583          	lw	a1,0(s5)
    800039ce:	030a2503          	lw	a0,48(s4)
    800039d2:	fffff097          	auipc	ra,0xfffff
    800039d6:	a72080e7          	jalr	-1422(ra) # 80002444 <bread>
    800039da:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800039dc:	40000613          	li	a2,1024
    800039e0:	06050593          	addi	a1,a0,96
    800039e4:	06048513          	addi	a0,s1,96
    800039e8:	ffffd097          	auipc	ra,0xffffd
    800039ec:	8fa080e7          	jalr	-1798(ra) # 800002e2 <memmove>
    bwrite(to);  // write the log
    800039f0:	8526                	mv	a0,s1
    800039f2:	fffff097          	auipc	ra,0xfffff
    800039f6:	d40080e7          	jalr	-704(ra) # 80002732 <bwrite>
    brelse(from);
    800039fa:	854e                	mv	a0,s3
    800039fc:	fffff097          	auipc	ra,0xfffff
    80003a00:	d74080e7          	jalr	-652(ra) # 80002770 <brelse>
    brelse(to);
    80003a04:	8526                	mv	a0,s1
    80003a06:	fffff097          	auipc	ra,0xfffff
    80003a0a:	d6a080e7          	jalr	-662(ra) # 80002770 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a0e:	2905                	addiw	s2,s2,1
    80003a10:	0a91                	addi	s5,s5,4
    80003a12:	034a2783          	lw	a5,52(s4)
    80003a16:	f8f94ee3          	blt	s2,a5,800039b2 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003a1a:	00000097          	auipc	ra,0x0
    80003a1e:	c68080e7          	jalr	-920(ra) # 80003682 <write_head>
    install_trans(0); // Now install writes to home locations
    80003a22:	4501                	li	a0,0
    80003a24:	00000097          	auipc	ra,0x0
    80003a28:	cda080e7          	jalr	-806(ra) # 800036fe <install_trans>
    log.lh.n = 0;
    80003a2c:	00019797          	auipc	a5,0x19
    80003a30:	d007a023          	sw	zero,-768(a5) # 8001c72c <log+0x34>
    write_head();    // Erase the transaction from the log
    80003a34:	00000097          	auipc	ra,0x0
    80003a38:	c4e080e7          	jalr	-946(ra) # 80003682 <write_head>
    80003a3c:	bdf5                	j	80003938 <end_op+0x52>

0000000080003a3e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003a3e:	1101                	addi	sp,sp,-32
    80003a40:	ec06                	sd	ra,24(sp)
    80003a42:	e822                	sd	s0,16(sp)
    80003a44:	e426                	sd	s1,8(sp)
    80003a46:	e04a                	sd	s2,0(sp)
    80003a48:	1000                	addi	s0,sp,32
    80003a4a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003a4c:	00019917          	auipc	s2,0x19
    80003a50:	cac90913          	addi	s2,s2,-852 # 8001c6f8 <log>
    80003a54:	854a                	mv	a0,s2
    80003a56:	00003097          	auipc	ra,0x3
    80003a5a:	d5c080e7          	jalr	-676(ra) # 800067b2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003a5e:	03492603          	lw	a2,52(s2)
    80003a62:	47f5                	li	a5,29
    80003a64:	06c7c563          	blt	a5,a2,80003ace <log_write+0x90>
    80003a68:	00019797          	auipc	a5,0x19
    80003a6c:	cb47a783          	lw	a5,-844(a5) # 8001c71c <log+0x24>
    80003a70:	37fd                	addiw	a5,a5,-1
    80003a72:	04f65e63          	bge	a2,a5,80003ace <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003a76:	00019797          	auipc	a5,0x19
    80003a7a:	caa7a783          	lw	a5,-854(a5) # 8001c720 <log+0x28>
    80003a7e:	06f05063          	blez	a5,80003ade <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003a82:	4781                	li	a5,0
    80003a84:	06c05563          	blez	a2,80003aee <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003a88:	44cc                	lw	a1,12(s1)
    80003a8a:	00019717          	auipc	a4,0x19
    80003a8e:	ca670713          	addi	a4,a4,-858 # 8001c730 <log+0x38>
  for (i = 0; i < log.lh.n; i++) {
    80003a92:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003a94:	4314                	lw	a3,0(a4)
    80003a96:	04b68c63          	beq	a3,a1,80003aee <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003a9a:	2785                	addiw	a5,a5,1
    80003a9c:	0711                	addi	a4,a4,4
    80003a9e:	fef61be3          	bne	a2,a5,80003a94 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003aa2:	0631                	addi	a2,a2,12
    80003aa4:	060a                	slli	a2,a2,0x2
    80003aa6:	00019797          	auipc	a5,0x19
    80003aaa:	c5278793          	addi	a5,a5,-942 # 8001c6f8 <log>
    80003aae:	97b2                	add	a5,a5,a2
    80003ab0:	44d8                	lw	a4,12(s1)
    80003ab2:	c798                	sw	a4,8(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003ab4:	8526                	mv	a0,s1
    80003ab6:	fffff097          	auipc	ra,0xfffff
    80003aba:	d50080e7          	jalr	-688(ra) # 80002806 <bpin>
    log.lh.n++;
    80003abe:	00019717          	auipc	a4,0x19
    80003ac2:	c3a70713          	addi	a4,a4,-966 # 8001c6f8 <log>
    80003ac6:	5b5c                	lw	a5,52(a4)
    80003ac8:	2785                	addiw	a5,a5,1
    80003aca:	db5c                	sw	a5,52(a4)
    80003acc:	a82d                	j	80003b06 <log_write+0xc8>
    panic("too big a transaction");
    80003ace:	00005517          	auipc	a0,0x5
    80003ad2:	b0a50513          	addi	a0,a0,-1270 # 800085d8 <syscalls+0x208>
    80003ad6:	00002097          	auipc	ra,0x2
    80003ada:	7ba080e7          	jalr	1978(ra) # 80006290 <panic>
    panic("log_write outside of trans");
    80003ade:	00005517          	auipc	a0,0x5
    80003ae2:	b1250513          	addi	a0,a0,-1262 # 800085f0 <syscalls+0x220>
    80003ae6:	00002097          	auipc	ra,0x2
    80003aea:	7aa080e7          	jalr	1962(ra) # 80006290 <panic>
  log.lh.block[i] = b->blockno;
    80003aee:	00c78693          	addi	a3,a5,12
    80003af2:	068a                	slli	a3,a3,0x2
    80003af4:	00019717          	auipc	a4,0x19
    80003af8:	c0470713          	addi	a4,a4,-1020 # 8001c6f8 <log>
    80003afc:	9736                	add	a4,a4,a3
    80003afe:	44d4                	lw	a3,12(s1)
    80003b00:	c714                	sw	a3,8(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003b02:	faf609e3          	beq	a2,a5,80003ab4 <log_write+0x76>
  }
  release(&log.lock);
    80003b06:	00019517          	auipc	a0,0x19
    80003b0a:	bf250513          	addi	a0,a0,-1038 # 8001c6f8 <log>
    80003b0e:	00003097          	auipc	ra,0x3
    80003b12:	d74080e7          	jalr	-652(ra) # 80006882 <release>
}
    80003b16:	60e2                	ld	ra,24(sp)
    80003b18:	6442                	ld	s0,16(sp)
    80003b1a:	64a2                	ld	s1,8(sp)
    80003b1c:	6902                	ld	s2,0(sp)
    80003b1e:	6105                	addi	sp,sp,32
    80003b20:	8082                	ret

0000000080003b22 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003b22:	1101                	addi	sp,sp,-32
    80003b24:	ec06                	sd	ra,24(sp)
    80003b26:	e822                	sd	s0,16(sp)
    80003b28:	e426                	sd	s1,8(sp)
    80003b2a:	e04a                	sd	s2,0(sp)
    80003b2c:	1000                	addi	s0,sp,32
    80003b2e:	84aa                	mv	s1,a0
    80003b30:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003b32:	00005597          	auipc	a1,0x5
    80003b36:	ade58593          	addi	a1,a1,-1314 # 80008610 <syscalls+0x240>
    80003b3a:	0521                	addi	a0,a0,8
    80003b3c:	00003097          	auipc	ra,0x3
    80003b40:	df2080e7          	jalr	-526(ra) # 8000692e <initlock>
  lk->name = name;
    80003b44:	0324b423          	sd	s2,40(s1)
  lk->locked = 0;
    80003b48:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b4c:	0204a823          	sw	zero,48(s1)
}
    80003b50:	60e2                	ld	ra,24(sp)
    80003b52:	6442                	ld	s0,16(sp)
    80003b54:	64a2                	ld	s1,8(sp)
    80003b56:	6902                	ld	s2,0(sp)
    80003b58:	6105                	addi	sp,sp,32
    80003b5a:	8082                	ret

0000000080003b5c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003b5c:	1101                	addi	sp,sp,-32
    80003b5e:	ec06                	sd	ra,24(sp)
    80003b60:	e822                	sd	s0,16(sp)
    80003b62:	e426                	sd	s1,8(sp)
    80003b64:	e04a                	sd	s2,0(sp)
    80003b66:	1000                	addi	s0,sp,32
    80003b68:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b6a:	00850913          	addi	s2,a0,8
    80003b6e:	854a                	mv	a0,s2
    80003b70:	00003097          	auipc	ra,0x3
    80003b74:	c42080e7          	jalr	-958(ra) # 800067b2 <acquire>
  while (lk->locked) {
    80003b78:	409c                	lw	a5,0(s1)
    80003b7a:	cb89                	beqz	a5,80003b8c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003b7c:	85ca                	mv	a1,s2
    80003b7e:	8526                	mv	a0,s1
    80003b80:	ffffe097          	auipc	ra,0xffffe
    80003b84:	a98080e7          	jalr	-1384(ra) # 80001618 <sleep>
  while (lk->locked) {
    80003b88:	409c                	lw	a5,0(s1)
    80003b8a:	fbed                	bnez	a5,80003b7c <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003b8c:	4785                	li	a5,1
    80003b8e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003b90:	ffffd097          	auipc	ra,0xffffd
    80003b94:	3e0080e7          	jalr	992(ra) # 80000f70 <myproc>
    80003b98:	5d1c                	lw	a5,56(a0)
    80003b9a:	d89c                	sw	a5,48(s1)
  release(&lk->lk);
    80003b9c:	854a                	mv	a0,s2
    80003b9e:	00003097          	auipc	ra,0x3
    80003ba2:	ce4080e7          	jalr	-796(ra) # 80006882 <release>
}
    80003ba6:	60e2                	ld	ra,24(sp)
    80003ba8:	6442                	ld	s0,16(sp)
    80003baa:	64a2                	ld	s1,8(sp)
    80003bac:	6902                	ld	s2,0(sp)
    80003bae:	6105                	addi	sp,sp,32
    80003bb0:	8082                	ret

0000000080003bb2 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003bb2:	1101                	addi	sp,sp,-32
    80003bb4:	ec06                	sd	ra,24(sp)
    80003bb6:	e822                	sd	s0,16(sp)
    80003bb8:	e426                	sd	s1,8(sp)
    80003bba:	e04a                	sd	s2,0(sp)
    80003bbc:	1000                	addi	s0,sp,32
    80003bbe:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003bc0:	00850913          	addi	s2,a0,8
    80003bc4:	854a                	mv	a0,s2
    80003bc6:	00003097          	auipc	ra,0x3
    80003bca:	bec080e7          	jalr	-1044(ra) # 800067b2 <acquire>
  lk->locked = 0;
    80003bce:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003bd2:	0204a823          	sw	zero,48(s1)
  wakeup(lk);
    80003bd6:	8526                	mv	a0,s1
    80003bd8:	ffffe097          	auipc	ra,0xffffe
    80003bdc:	aa4080e7          	jalr	-1372(ra) # 8000167c <wakeup>
  release(&lk->lk);
    80003be0:	854a                	mv	a0,s2
    80003be2:	00003097          	auipc	ra,0x3
    80003be6:	ca0080e7          	jalr	-864(ra) # 80006882 <release>
}
    80003bea:	60e2                	ld	ra,24(sp)
    80003bec:	6442                	ld	s0,16(sp)
    80003bee:	64a2                	ld	s1,8(sp)
    80003bf0:	6902                	ld	s2,0(sp)
    80003bf2:	6105                	addi	sp,sp,32
    80003bf4:	8082                	ret

0000000080003bf6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003bf6:	7179                	addi	sp,sp,-48
    80003bf8:	f406                	sd	ra,40(sp)
    80003bfa:	f022                	sd	s0,32(sp)
    80003bfc:	ec26                	sd	s1,24(sp)
    80003bfe:	e84a                	sd	s2,16(sp)
    80003c00:	e44e                	sd	s3,8(sp)
    80003c02:	1800                	addi	s0,sp,48
    80003c04:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003c06:	00850913          	addi	s2,a0,8
    80003c0a:	854a                	mv	a0,s2
    80003c0c:	00003097          	auipc	ra,0x3
    80003c10:	ba6080e7          	jalr	-1114(ra) # 800067b2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003c14:	409c                	lw	a5,0(s1)
    80003c16:	ef99                	bnez	a5,80003c34 <holdingsleep+0x3e>
    80003c18:	4481                	li	s1,0
  release(&lk->lk);
    80003c1a:	854a                	mv	a0,s2
    80003c1c:	00003097          	auipc	ra,0x3
    80003c20:	c66080e7          	jalr	-922(ra) # 80006882 <release>
  return r;
}
    80003c24:	8526                	mv	a0,s1
    80003c26:	70a2                	ld	ra,40(sp)
    80003c28:	7402                	ld	s0,32(sp)
    80003c2a:	64e2                	ld	s1,24(sp)
    80003c2c:	6942                	ld	s2,16(sp)
    80003c2e:	69a2                	ld	s3,8(sp)
    80003c30:	6145                	addi	sp,sp,48
    80003c32:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003c34:	0304a983          	lw	s3,48(s1)
    80003c38:	ffffd097          	auipc	ra,0xffffd
    80003c3c:	338080e7          	jalr	824(ra) # 80000f70 <myproc>
    80003c40:	5d04                	lw	s1,56(a0)
    80003c42:	413484b3          	sub	s1,s1,s3
    80003c46:	0014b493          	seqz	s1,s1
    80003c4a:	bfc1                	j	80003c1a <holdingsleep+0x24>

0000000080003c4c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003c4c:	1141                	addi	sp,sp,-16
    80003c4e:	e406                	sd	ra,8(sp)
    80003c50:	e022                	sd	s0,0(sp)
    80003c52:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003c54:	00005597          	auipc	a1,0x5
    80003c58:	9cc58593          	addi	a1,a1,-1588 # 80008620 <syscalls+0x250>
    80003c5c:	00019517          	auipc	a0,0x19
    80003c60:	bec50513          	addi	a0,a0,-1044 # 8001c848 <ftable>
    80003c64:	00003097          	auipc	ra,0x3
    80003c68:	cca080e7          	jalr	-822(ra) # 8000692e <initlock>
}
    80003c6c:	60a2                	ld	ra,8(sp)
    80003c6e:	6402                	ld	s0,0(sp)
    80003c70:	0141                	addi	sp,sp,16
    80003c72:	8082                	ret

0000000080003c74 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003c74:	1101                	addi	sp,sp,-32
    80003c76:	ec06                	sd	ra,24(sp)
    80003c78:	e822                	sd	s0,16(sp)
    80003c7a:	e426                	sd	s1,8(sp)
    80003c7c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003c7e:	00019517          	auipc	a0,0x19
    80003c82:	bca50513          	addi	a0,a0,-1078 # 8001c848 <ftable>
    80003c86:	00003097          	auipc	ra,0x3
    80003c8a:	b2c080e7          	jalr	-1236(ra) # 800067b2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003c8e:	00019497          	auipc	s1,0x19
    80003c92:	bda48493          	addi	s1,s1,-1062 # 8001c868 <ftable+0x20>
    80003c96:	0001a717          	auipc	a4,0x1a
    80003c9a:	b7270713          	addi	a4,a4,-1166 # 8001d808 <disk>
    if(f->ref == 0){
    80003c9e:	40dc                	lw	a5,4(s1)
    80003ca0:	cf99                	beqz	a5,80003cbe <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ca2:	02848493          	addi	s1,s1,40
    80003ca6:	fee49ce3          	bne	s1,a4,80003c9e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003caa:	00019517          	auipc	a0,0x19
    80003cae:	b9e50513          	addi	a0,a0,-1122 # 8001c848 <ftable>
    80003cb2:	00003097          	auipc	ra,0x3
    80003cb6:	bd0080e7          	jalr	-1072(ra) # 80006882 <release>
  return 0;
    80003cba:	4481                	li	s1,0
    80003cbc:	a819                	j	80003cd2 <filealloc+0x5e>
      f->ref = 1;
    80003cbe:	4785                	li	a5,1
    80003cc0:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003cc2:	00019517          	auipc	a0,0x19
    80003cc6:	b8650513          	addi	a0,a0,-1146 # 8001c848 <ftable>
    80003cca:	00003097          	auipc	ra,0x3
    80003cce:	bb8080e7          	jalr	-1096(ra) # 80006882 <release>
}
    80003cd2:	8526                	mv	a0,s1
    80003cd4:	60e2                	ld	ra,24(sp)
    80003cd6:	6442                	ld	s0,16(sp)
    80003cd8:	64a2                	ld	s1,8(sp)
    80003cda:	6105                	addi	sp,sp,32
    80003cdc:	8082                	ret

0000000080003cde <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003cde:	1101                	addi	sp,sp,-32
    80003ce0:	ec06                	sd	ra,24(sp)
    80003ce2:	e822                	sd	s0,16(sp)
    80003ce4:	e426                	sd	s1,8(sp)
    80003ce6:	1000                	addi	s0,sp,32
    80003ce8:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003cea:	00019517          	auipc	a0,0x19
    80003cee:	b5e50513          	addi	a0,a0,-1186 # 8001c848 <ftable>
    80003cf2:	00003097          	auipc	ra,0x3
    80003cf6:	ac0080e7          	jalr	-1344(ra) # 800067b2 <acquire>
  if(f->ref < 1)
    80003cfa:	40dc                	lw	a5,4(s1)
    80003cfc:	02f05263          	blez	a5,80003d20 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003d00:	2785                	addiw	a5,a5,1
    80003d02:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003d04:	00019517          	auipc	a0,0x19
    80003d08:	b4450513          	addi	a0,a0,-1212 # 8001c848 <ftable>
    80003d0c:	00003097          	auipc	ra,0x3
    80003d10:	b76080e7          	jalr	-1162(ra) # 80006882 <release>
  return f;
}
    80003d14:	8526                	mv	a0,s1
    80003d16:	60e2                	ld	ra,24(sp)
    80003d18:	6442                	ld	s0,16(sp)
    80003d1a:	64a2                	ld	s1,8(sp)
    80003d1c:	6105                	addi	sp,sp,32
    80003d1e:	8082                	ret
    panic("filedup");
    80003d20:	00005517          	auipc	a0,0x5
    80003d24:	90850513          	addi	a0,a0,-1784 # 80008628 <syscalls+0x258>
    80003d28:	00002097          	auipc	ra,0x2
    80003d2c:	568080e7          	jalr	1384(ra) # 80006290 <panic>

0000000080003d30 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003d30:	7139                	addi	sp,sp,-64
    80003d32:	fc06                	sd	ra,56(sp)
    80003d34:	f822                	sd	s0,48(sp)
    80003d36:	f426                	sd	s1,40(sp)
    80003d38:	f04a                	sd	s2,32(sp)
    80003d3a:	ec4e                	sd	s3,24(sp)
    80003d3c:	e852                	sd	s4,16(sp)
    80003d3e:	e456                	sd	s5,8(sp)
    80003d40:	0080                	addi	s0,sp,64
    80003d42:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003d44:	00019517          	auipc	a0,0x19
    80003d48:	b0450513          	addi	a0,a0,-1276 # 8001c848 <ftable>
    80003d4c:	00003097          	auipc	ra,0x3
    80003d50:	a66080e7          	jalr	-1434(ra) # 800067b2 <acquire>
  if(f->ref < 1)
    80003d54:	40dc                	lw	a5,4(s1)
    80003d56:	06f05163          	blez	a5,80003db8 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003d5a:	37fd                	addiw	a5,a5,-1
    80003d5c:	0007871b          	sext.w	a4,a5
    80003d60:	c0dc                	sw	a5,4(s1)
    80003d62:	06e04363          	bgtz	a4,80003dc8 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003d66:	0004a903          	lw	s2,0(s1)
    80003d6a:	0094ca83          	lbu	s5,9(s1)
    80003d6e:	0104ba03          	ld	s4,16(s1)
    80003d72:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003d76:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003d7a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003d7e:	00019517          	auipc	a0,0x19
    80003d82:	aca50513          	addi	a0,a0,-1334 # 8001c848 <ftable>
    80003d86:	00003097          	auipc	ra,0x3
    80003d8a:	afc080e7          	jalr	-1284(ra) # 80006882 <release>

  if(ff.type == FD_PIPE){
    80003d8e:	4785                	li	a5,1
    80003d90:	04f90d63          	beq	s2,a5,80003dea <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003d94:	3979                	addiw	s2,s2,-2
    80003d96:	4785                	li	a5,1
    80003d98:	0527e063          	bltu	a5,s2,80003dd8 <fileclose+0xa8>
    begin_op();
    80003d9c:	00000097          	auipc	ra,0x0
    80003da0:	acc080e7          	jalr	-1332(ra) # 80003868 <begin_op>
    iput(ff.ip);
    80003da4:	854e                	mv	a0,s3
    80003da6:	fffff097          	auipc	ra,0xfffff
    80003daa:	2b0080e7          	jalr	688(ra) # 80003056 <iput>
    end_op();
    80003dae:	00000097          	auipc	ra,0x0
    80003db2:	b38080e7          	jalr	-1224(ra) # 800038e6 <end_op>
    80003db6:	a00d                	j	80003dd8 <fileclose+0xa8>
    panic("fileclose");
    80003db8:	00005517          	auipc	a0,0x5
    80003dbc:	87850513          	addi	a0,a0,-1928 # 80008630 <syscalls+0x260>
    80003dc0:	00002097          	auipc	ra,0x2
    80003dc4:	4d0080e7          	jalr	1232(ra) # 80006290 <panic>
    release(&ftable.lock);
    80003dc8:	00019517          	auipc	a0,0x19
    80003dcc:	a8050513          	addi	a0,a0,-1408 # 8001c848 <ftable>
    80003dd0:	00003097          	auipc	ra,0x3
    80003dd4:	ab2080e7          	jalr	-1358(ra) # 80006882 <release>
  }
}
    80003dd8:	70e2                	ld	ra,56(sp)
    80003dda:	7442                	ld	s0,48(sp)
    80003ddc:	74a2                	ld	s1,40(sp)
    80003dde:	7902                	ld	s2,32(sp)
    80003de0:	69e2                	ld	s3,24(sp)
    80003de2:	6a42                	ld	s4,16(sp)
    80003de4:	6aa2                	ld	s5,8(sp)
    80003de6:	6121                	addi	sp,sp,64
    80003de8:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003dea:	85d6                	mv	a1,s5
    80003dec:	8552                	mv	a0,s4
    80003dee:	00000097          	auipc	ra,0x0
    80003df2:	34c080e7          	jalr	844(ra) # 8000413a <pipeclose>
    80003df6:	b7cd                	j	80003dd8 <fileclose+0xa8>

0000000080003df8 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003df8:	715d                	addi	sp,sp,-80
    80003dfa:	e486                	sd	ra,72(sp)
    80003dfc:	e0a2                	sd	s0,64(sp)
    80003dfe:	fc26                	sd	s1,56(sp)
    80003e00:	f84a                	sd	s2,48(sp)
    80003e02:	f44e                	sd	s3,40(sp)
    80003e04:	0880                	addi	s0,sp,80
    80003e06:	84aa                	mv	s1,a0
    80003e08:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003e0a:	ffffd097          	auipc	ra,0xffffd
    80003e0e:	166080e7          	jalr	358(ra) # 80000f70 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003e12:	409c                	lw	a5,0(s1)
    80003e14:	37f9                	addiw	a5,a5,-2
    80003e16:	4705                	li	a4,1
    80003e18:	04f76763          	bltu	a4,a5,80003e66 <filestat+0x6e>
    80003e1c:	892a                	mv	s2,a0
    ilock(f->ip);
    80003e1e:	6c88                	ld	a0,24(s1)
    80003e20:	fffff097          	auipc	ra,0xfffff
    80003e24:	068080e7          	jalr	104(ra) # 80002e88 <ilock>
    stati(f->ip, &st);
    80003e28:	fb840593          	addi	a1,s0,-72
    80003e2c:	6c88                	ld	a0,24(s1)
    80003e2e:	fffff097          	auipc	ra,0xfffff
    80003e32:	2f8080e7          	jalr	760(ra) # 80003126 <stati>
    iunlock(f->ip);
    80003e36:	6c88                	ld	a0,24(s1)
    80003e38:	fffff097          	auipc	ra,0xfffff
    80003e3c:	11c080e7          	jalr	284(ra) # 80002f54 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003e40:	46e1                	li	a3,24
    80003e42:	fb840613          	addi	a2,s0,-72
    80003e46:	85ce                	mv	a1,s3
    80003e48:	05893503          	ld	a0,88(s2)
    80003e4c:	ffffd097          	auipc	ra,0xffffd
    80003e50:	de4080e7          	jalr	-540(ra) # 80000c30 <copyout>
    80003e54:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003e58:	60a6                	ld	ra,72(sp)
    80003e5a:	6406                	ld	s0,64(sp)
    80003e5c:	74e2                	ld	s1,56(sp)
    80003e5e:	7942                	ld	s2,48(sp)
    80003e60:	79a2                	ld	s3,40(sp)
    80003e62:	6161                	addi	sp,sp,80
    80003e64:	8082                	ret
  return -1;
    80003e66:	557d                	li	a0,-1
    80003e68:	bfc5                	j	80003e58 <filestat+0x60>

0000000080003e6a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003e6a:	7179                	addi	sp,sp,-48
    80003e6c:	f406                	sd	ra,40(sp)
    80003e6e:	f022                	sd	s0,32(sp)
    80003e70:	ec26                	sd	s1,24(sp)
    80003e72:	e84a                	sd	s2,16(sp)
    80003e74:	e44e                	sd	s3,8(sp)
    80003e76:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003e78:	00854783          	lbu	a5,8(a0)
    80003e7c:	c3d5                	beqz	a5,80003f20 <fileread+0xb6>
    80003e7e:	84aa                	mv	s1,a0
    80003e80:	89ae                	mv	s3,a1
    80003e82:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e84:	411c                	lw	a5,0(a0)
    80003e86:	4705                	li	a4,1
    80003e88:	04e78963          	beq	a5,a4,80003eda <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e8c:	470d                	li	a4,3
    80003e8e:	04e78d63          	beq	a5,a4,80003ee8 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e92:	4709                	li	a4,2
    80003e94:	06e79e63          	bne	a5,a4,80003f10 <fileread+0xa6>
    ilock(f->ip);
    80003e98:	6d08                	ld	a0,24(a0)
    80003e9a:	fffff097          	auipc	ra,0xfffff
    80003e9e:	fee080e7          	jalr	-18(ra) # 80002e88 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003ea2:	874a                	mv	a4,s2
    80003ea4:	5094                	lw	a3,32(s1)
    80003ea6:	864e                	mv	a2,s3
    80003ea8:	4585                	li	a1,1
    80003eaa:	6c88                	ld	a0,24(s1)
    80003eac:	fffff097          	auipc	ra,0xfffff
    80003eb0:	2a4080e7          	jalr	676(ra) # 80003150 <readi>
    80003eb4:	892a                	mv	s2,a0
    80003eb6:	00a05563          	blez	a0,80003ec0 <fileread+0x56>
      f->off += r;
    80003eba:	509c                	lw	a5,32(s1)
    80003ebc:	9fa9                	addw	a5,a5,a0
    80003ebe:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003ec0:	6c88                	ld	a0,24(s1)
    80003ec2:	fffff097          	auipc	ra,0xfffff
    80003ec6:	092080e7          	jalr	146(ra) # 80002f54 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003eca:	854a                	mv	a0,s2
    80003ecc:	70a2                	ld	ra,40(sp)
    80003ece:	7402                	ld	s0,32(sp)
    80003ed0:	64e2                	ld	s1,24(sp)
    80003ed2:	6942                	ld	s2,16(sp)
    80003ed4:	69a2                	ld	s3,8(sp)
    80003ed6:	6145                	addi	sp,sp,48
    80003ed8:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003eda:	6908                	ld	a0,16(a0)
    80003edc:	00000097          	auipc	ra,0x0
    80003ee0:	3d0080e7          	jalr	976(ra) # 800042ac <piperead>
    80003ee4:	892a                	mv	s2,a0
    80003ee6:	b7d5                	j	80003eca <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003ee8:	02451783          	lh	a5,36(a0)
    80003eec:	03079693          	slli	a3,a5,0x30
    80003ef0:	92c1                	srli	a3,a3,0x30
    80003ef2:	4725                	li	a4,9
    80003ef4:	02d76863          	bltu	a4,a3,80003f24 <fileread+0xba>
    80003ef8:	0792                	slli	a5,a5,0x4
    80003efa:	00019717          	auipc	a4,0x19
    80003efe:	8ae70713          	addi	a4,a4,-1874 # 8001c7a8 <devsw>
    80003f02:	97ba                	add	a5,a5,a4
    80003f04:	639c                	ld	a5,0(a5)
    80003f06:	c38d                	beqz	a5,80003f28 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003f08:	4505                	li	a0,1
    80003f0a:	9782                	jalr	a5
    80003f0c:	892a                	mv	s2,a0
    80003f0e:	bf75                	j	80003eca <fileread+0x60>
    panic("fileread");
    80003f10:	00004517          	auipc	a0,0x4
    80003f14:	73050513          	addi	a0,a0,1840 # 80008640 <syscalls+0x270>
    80003f18:	00002097          	auipc	ra,0x2
    80003f1c:	378080e7          	jalr	888(ra) # 80006290 <panic>
    return -1;
    80003f20:	597d                	li	s2,-1
    80003f22:	b765                	j	80003eca <fileread+0x60>
      return -1;
    80003f24:	597d                	li	s2,-1
    80003f26:	b755                	j	80003eca <fileread+0x60>
    80003f28:	597d                	li	s2,-1
    80003f2a:	b745                	j	80003eca <fileread+0x60>

0000000080003f2c <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003f2c:	715d                	addi	sp,sp,-80
    80003f2e:	e486                	sd	ra,72(sp)
    80003f30:	e0a2                	sd	s0,64(sp)
    80003f32:	fc26                	sd	s1,56(sp)
    80003f34:	f84a                	sd	s2,48(sp)
    80003f36:	f44e                	sd	s3,40(sp)
    80003f38:	f052                	sd	s4,32(sp)
    80003f3a:	ec56                	sd	s5,24(sp)
    80003f3c:	e85a                	sd	s6,16(sp)
    80003f3e:	e45e                	sd	s7,8(sp)
    80003f40:	e062                	sd	s8,0(sp)
    80003f42:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003f44:	00954783          	lbu	a5,9(a0)
    80003f48:	10078663          	beqz	a5,80004054 <filewrite+0x128>
    80003f4c:	892a                	mv	s2,a0
    80003f4e:	8b2e                	mv	s6,a1
    80003f50:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003f52:	411c                	lw	a5,0(a0)
    80003f54:	4705                	li	a4,1
    80003f56:	02e78263          	beq	a5,a4,80003f7a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003f5a:	470d                	li	a4,3
    80003f5c:	02e78663          	beq	a5,a4,80003f88 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003f60:	4709                	li	a4,2
    80003f62:	0ee79163          	bne	a5,a4,80004044 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003f66:	0ac05d63          	blez	a2,80004020 <filewrite+0xf4>
    int i = 0;
    80003f6a:	4981                	li	s3,0
    80003f6c:	6b85                	lui	s7,0x1
    80003f6e:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003f72:	6c05                	lui	s8,0x1
    80003f74:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003f78:	a861                	j	80004010 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003f7a:	6908                	ld	a0,16(a0)
    80003f7c:	00000097          	auipc	ra,0x0
    80003f80:	238080e7          	jalr	568(ra) # 800041b4 <pipewrite>
    80003f84:	8a2a                	mv	s4,a0
    80003f86:	a045                	j	80004026 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003f88:	02451783          	lh	a5,36(a0)
    80003f8c:	03079693          	slli	a3,a5,0x30
    80003f90:	92c1                	srli	a3,a3,0x30
    80003f92:	4725                	li	a4,9
    80003f94:	0cd76263          	bltu	a4,a3,80004058 <filewrite+0x12c>
    80003f98:	0792                	slli	a5,a5,0x4
    80003f9a:	00019717          	auipc	a4,0x19
    80003f9e:	80e70713          	addi	a4,a4,-2034 # 8001c7a8 <devsw>
    80003fa2:	97ba                	add	a5,a5,a4
    80003fa4:	679c                	ld	a5,8(a5)
    80003fa6:	cbdd                	beqz	a5,8000405c <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003fa8:	4505                	li	a0,1
    80003faa:	9782                	jalr	a5
    80003fac:	8a2a                	mv	s4,a0
    80003fae:	a8a5                	j	80004026 <filewrite+0xfa>
    80003fb0:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003fb4:	00000097          	auipc	ra,0x0
    80003fb8:	8b4080e7          	jalr	-1868(ra) # 80003868 <begin_op>
      ilock(f->ip);
    80003fbc:	01893503          	ld	a0,24(s2)
    80003fc0:	fffff097          	auipc	ra,0xfffff
    80003fc4:	ec8080e7          	jalr	-312(ra) # 80002e88 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003fc8:	8756                	mv	a4,s5
    80003fca:	02092683          	lw	a3,32(s2)
    80003fce:	01698633          	add	a2,s3,s6
    80003fd2:	4585                	li	a1,1
    80003fd4:	01893503          	ld	a0,24(s2)
    80003fd8:	fffff097          	auipc	ra,0xfffff
    80003fdc:	270080e7          	jalr	624(ra) # 80003248 <writei>
    80003fe0:	84aa                	mv	s1,a0
    80003fe2:	00a05763          	blez	a0,80003ff0 <filewrite+0xc4>
        f->off += r;
    80003fe6:	02092783          	lw	a5,32(s2)
    80003fea:	9fa9                	addw	a5,a5,a0
    80003fec:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003ff0:	01893503          	ld	a0,24(s2)
    80003ff4:	fffff097          	auipc	ra,0xfffff
    80003ff8:	f60080e7          	jalr	-160(ra) # 80002f54 <iunlock>
      end_op();
    80003ffc:	00000097          	auipc	ra,0x0
    80004000:	8ea080e7          	jalr	-1814(ra) # 800038e6 <end_op>

      if(r != n1){
    80004004:	009a9f63          	bne	s5,s1,80004022 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80004008:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000400c:	0149db63          	bge	s3,s4,80004022 <filewrite+0xf6>
      int n1 = n - i;
    80004010:	413a04bb          	subw	s1,s4,s3
    80004014:	0004879b          	sext.w	a5,s1
    80004018:	f8fbdce3          	bge	s7,a5,80003fb0 <filewrite+0x84>
    8000401c:	84e2                	mv	s1,s8
    8000401e:	bf49                	j	80003fb0 <filewrite+0x84>
    int i = 0;
    80004020:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004022:	013a1f63          	bne	s4,s3,80004040 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004026:	8552                	mv	a0,s4
    80004028:	60a6                	ld	ra,72(sp)
    8000402a:	6406                	ld	s0,64(sp)
    8000402c:	74e2                	ld	s1,56(sp)
    8000402e:	7942                	ld	s2,48(sp)
    80004030:	79a2                	ld	s3,40(sp)
    80004032:	7a02                	ld	s4,32(sp)
    80004034:	6ae2                	ld	s5,24(sp)
    80004036:	6b42                	ld	s6,16(sp)
    80004038:	6ba2                	ld	s7,8(sp)
    8000403a:	6c02                	ld	s8,0(sp)
    8000403c:	6161                	addi	sp,sp,80
    8000403e:	8082                	ret
    ret = (i == n ? n : -1);
    80004040:	5a7d                	li	s4,-1
    80004042:	b7d5                	j	80004026 <filewrite+0xfa>
    panic("filewrite");
    80004044:	00004517          	auipc	a0,0x4
    80004048:	60c50513          	addi	a0,a0,1548 # 80008650 <syscalls+0x280>
    8000404c:	00002097          	auipc	ra,0x2
    80004050:	244080e7          	jalr	580(ra) # 80006290 <panic>
    return -1;
    80004054:	5a7d                	li	s4,-1
    80004056:	bfc1                	j	80004026 <filewrite+0xfa>
      return -1;
    80004058:	5a7d                	li	s4,-1
    8000405a:	b7f1                	j	80004026 <filewrite+0xfa>
    8000405c:	5a7d                	li	s4,-1
    8000405e:	b7e1                	j	80004026 <filewrite+0xfa>

0000000080004060 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004060:	7179                	addi	sp,sp,-48
    80004062:	f406                	sd	ra,40(sp)
    80004064:	f022                	sd	s0,32(sp)
    80004066:	ec26                	sd	s1,24(sp)
    80004068:	e84a                	sd	s2,16(sp)
    8000406a:	e44e                	sd	s3,8(sp)
    8000406c:	e052                	sd	s4,0(sp)
    8000406e:	1800                	addi	s0,sp,48
    80004070:	84aa                	mv	s1,a0
    80004072:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004074:	0005b023          	sd	zero,0(a1)
    80004078:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000407c:	00000097          	auipc	ra,0x0
    80004080:	bf8080e7          	jalr	-1032(ra) # 80003c74 <filealloc>
    80004084:	e088                	sd	a0,0(s1)
    80004086:	c551                	beqz	a0,80004112 <pipealloc+0xb2>
    80004088:	00000097          	auipc	ra,0x0
    8000408c:	bec080e7          	jalr	-1044(ra) # 80003c74 <filealloc>
    80004090:	00aa3023          	sd	a0,0(s4)
    80004094:	c92d                	beqz	a0,80004106 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004096:	ffffc097          	auipc	ra,0xffffc
    8000409a:	0ec080e7          	jalr	236(ra) # 80000182 <kalloc>
    8000409e:	892a                	mv	s2,a0
    800040a0:	c125                	beqz	a0,80004100 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    800040a2:	4985                	li	s3,1
    800040a4:	23352423          	sw	s3,552(a0)
  pi->writeopen = 1;
    800040a8:	23352623          	sw	s3,556(a0)
  pi->nwrite = 0;
    800040ac:	22052223          	sw	zero,548(a0)
  pi->nread = 0;
    800040b0:	22052023          	sw	zero,544(a0)
  initlock(&pi->lock, "pipe");
    800040b4:	00004597          	auipc	a1,0x4
    800040b8:	5ac58593          	addi	a1,a1,1452 # 80008660 <syscalls+0x290>
    800040bc:	00003097          	auipc	ra,0x3
    800040c0:	872080e7          	jalr	-1934(ra) # 8000692e <initlock>
  (*f0)->type = FD_PIPE;
    800040c4:	609c                	ld	a5,0(s1)
    800040c6:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800040ca:	609c                	ld	a5,0(s1)
    800040cc:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800040d0:	609c                	ld	a5,0(s1)
    800040d2:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800040d6:	609c                	ld	a5,0(s1)
    800040d8:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800040dc:	000a3783          	ld	a5,0(s4)
    800040e0:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800040e4:	000a3783          	ld	a5,0(s4)
    800040e8:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800040ec:	000a3783          	ld	a5,0(s4)
    800040f0:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800040f4:	000a3783          	ld	a5,0(s4)
    800040f8:	0127b823          	sd	s2,16(a5)
  return 0;
    800040fc:	4501                	li	a0,0
    800040fe:	a025                	j	80004126 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004100:	6088                	ld	a0,0(s1)
    80004102:	e501                	bnez	a0,8000410a <pipealloc+0xaa>
    80004104:	a039                	j	80004112 <pipealloc+0xb2>
    80004106:	6088                	ld	a0,0(s1)
    80004108:	c51d                	beqz	a0,80004136 <pipealloc+0xd6>
    fileclose(*f0);
    8000410a:	00000097          	auipc	ra,0x0
    8000410e:	c26080e7          	jalr	-986(ra) # 80003d30 <fileclose>
  if(*f1)
    80004112:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004116:	557d                	li	a0,-1
  if(*f1)
    80004118:	c799                	beqz	a5,80004126 <pipealloc+0xc6>
    fileclose(*f1);
    8000411a:	853e                	mv	a0,a5
    8000411c:	00000097          	auipc	ra,0x0
    80004120:	c14080e7          	jalr	-1004(ra) # 80003d30 <fileclose>
  return -1;
    80004124:	557d                	li	a0,-1
}
    80004126:	70a2                	ld	ra,40(sp)
    80004128:	7402                	ld	s0,32(sp)
    8000412a:	64e2                	ld	s1,24(sp)
    8000412c:	6942                	ld	s2,16(sp)
    8000412e:	69a2                	ld	s3,8(sp)
    80004130:	6a02                	ld	s4,0(sp)
    80004132:	6145                	addi	sp,sp,48
    80004134:	8082                	ret
  return -1;
    80004136:	557d                	li	a0,-1
    80004138:	b7fd                	j	80004126 <pipealloc+0xc6>

000000008000413a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000413a:	1101                	addi	sp,sp,-32
    8000413c:	ec06                	sd	ra,24(sp)
    8000413e:	e822                	sd	s0,16(sp)
    80004140:	e426                	sd	s1,8(sp)
    80004142:	e04a                	sd	s2,0(sp)
    80004144:	1000                	addi	s0,sp,32
    80004146:	84aa                	mv	s1,a0
    80004148:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000414a:	00002097          	auipc	ra,0x2
    8000414e:	668080e7          	jalr	1640(ra) # 800067b2 <acquire>
  if(writable){
    80004152:	04090263          	beqz	s2,80004196 <pipeclose+0x5c>
    pi->writeopen = 0;
    80004156:	2204a623          	sw	zero,556(s1)
    wakeup(&pi->nread);
    8000415a:	22048513          	addi	a0,s1,544
    8000415e:	ffffd097          	auipc	ra,0xffffd
    80004162:	51e080e7          	jalr	1310(ra) # 8000167c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004166:	2284b783          	ld	a5,552(s1)
    8000416a:	ef9d                	bnez	a5,800041a8 <pipeclose+0x6e>
    release(&pi->lock);
    8000416c:	8526                	mv	a0,s1
    8000416e:	00002097          	auipc	ra,0x2
    80004172:	714080e7          	jalr	1812(ra) # 80006882 <release>
#ifdef LAB_LOCK
    freelock(&pi->lock);
    80004176:	8526                	mv	a0,s1
    80004178:	00002097          	auipc	ra,0x2
    8000417c:	752080e7          	jalr	1874(ra) # 800068ca <freelock>
#endif    
    kfree((char*)pi);
    80004180:	8526                	mv	a0,s1
    80004182:	ffffc097          	auipc	ra,0xffffc
    80004186:	e9a080e7          	jalr	-358(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    8000418a:	60e2                	ld	ra,24(sp)
    8000418c:	6442                	ld	s0,16(sp)
    8000418e:	64a2                	ld	s1,8(sp)
    80004190:	6902                	ld	s2,0(sp)
    80004192:	6105                	addi	sp,sp,32
    80004194:	8082                	ret
    pi->readopen = 0;
    80004196:	2204a423          	sw	zero,552(s1)
    wakeup(&pi->nwrite);
    8000419a:	22448513          	addi	a0,s1,548
    8000419e:	ffffd097          	auipc	ra,0xffffd
    800041a2:	4de080e7          	jalr	1246(ra) # 8000167c <wakeup>
    800041a6:	b7c1                	j	80004166 <pipeclose+0x2c>
    release(&pi->lock);
    800041a8:	8526                	mv	a0,s1
    800041aa:	00002097          	auipc	ra,0x2
    800041ae:	6d8080e7          	jalr	1752(ra) # 80006882 <release>
}
    800041b2:	bfe1                	j	8000418a <pipeclose+0x50>

00000000800041b4 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800041b4:	711d                	addi	sp,sp,-96
    800041b6:	ec86                	sd	ra,88(sp)
    800041b8:	e8a2                	sd	s0,80(sp)
    800041ba:	e4a6                	sd	s1,72(sp)
    800041bc:	e0ca                	sd	s2,64(sp)
    800041be:	fc4e                	sd	s3,56(sp)
    800041c0:	f852                	sd	s4,48(sp)
    800041c2:	f456                	sd	s5,40(sp)
    800041c4:	f05a                	sd	s6,32(sp)
    800041c6:	ec5e                	sd	s7,24(sp)
    800041c8:	e862                	sd	s8,16(sp)
    800041ca:	1080                	addi	s0,sp,96
    800041cc:	84aa                	mv	s1,a0
    800041ce:	8aae                	mv	s5,a1
    800041d0:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800041d2:	ffffd097          	auipc	ra,0xffffd
    800041d6:	d9e080e7          	jalr	-610(ra) # 80000f70 <myproc>
    800041da:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800041dc:	8526                	mv	a0,s1
    800041de:	00002097          	auipc	ra,0x2
    800041e2:	5d4080e7          	jalr	1492(ra) # 800067b2 <acquire>
  while(i < n){
    800041e6:	0b405663          	blez	s4,80004292 <pipewrite+0xde>
  int i = 0;
    800041ea:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800041ec:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800041ee:	22048c13          	addi	s8,s1,544
      sleep(&pi->nwrite, &pi->lock);
    800041f2:	22448b93          	addi	s7,s1,548
    800041f6:	a089                	j	80004238 <pipewrite+0x84>
      release(&pi->lock);
    800041f8:	8526                	mv	a0,s1
    800041fa:	00002097          	auipc	ra,0x2
    800041fe:	688080e7          	jalr	1672(ra) # 80006882 <release>
      return -1;
    80004202:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004204:	854a                	mv	a0,s2
    80004206:	60e6                	ld	ra,88(sp)
    80004208:	6446                	ld	s0,80(sp)
    8000420a:	64a6                	ld	s1,72(sp)
    8000420c:	6906                	ld	s2,64(sp)
    8000420e:	79e2                	ld	s3,56(sp)
    80004210:	7a42                	ld	s4,48(sp)
    80004212:	7aa2                	ld	s5,40(sp)
    80004214:	7b02                	ld	s6,32(sp)
    80004216:	6be2                	ld	s7,24(sp)
    80004218:	6c42                	ld	s8,16(sp)
    8000421a:	6125                	addi	sp,sp,96
    8000421c:	8082                	ret
      wakeup(&pi->nread);
    8000421e:	8562                	mv	a0,s8
    80004220:	ffffd097          	auipc	ra,0xffffd
    80004224:	45c080e7          	jalr	1116(ra) # 8000167c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004228:	85a6                	mv	a1,s1
    8000422a:	855e                	mv	a0,s7
    8000422c:	ffffd097          	auipc	ra,0xffffd
    80004230:	3ec080e7          	jalr	1004(ra) # 80001618 <sleep>
  while(i < n){
    80004234:	07495063          	bge	s2,s4,80004294 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004238:	2284a783          	lw	a5,552(s1)
    8000423c:	dfd5                	beqz	a5,800041f8 <pipewrite+0x44>
    8000423e:	854e                	mv	a0,s3
    80004240:	ffffd097          	auipc	ra,0xffffd
    80004244:	680080e7          	jalr	1664(ra) # 800018c0 <killed>
    80004248:	f945                	bnez	a0,800041f8 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000424a:	2204a783          	lw	a5,544(s1)
    8000424e:	2244a703          	lw	a4,548(s1)
    80004252:	2007879b          	addiw	a5,a5,512
    80004256:	fcf704e3          	beq	a4,a5,8000421e <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000425a:	4685                	li	a3,1
    8000425c:	01590633          	add	a2,s2,s5
    80004260:	faf40593          	addi	a1,s0,-81
    80004264:	0589b503          	ld	a0,88(s3)
    80004268:	ffffd097          	auipc	ra,0xffffd
    8000426c:	a54080e7          	jalr	-1452(ra) # 80000cbc <copyin>
    80004270:	03650263          	beq	a0,s6,80004294 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004274:	2244a783          	lw	a5,548(s1)
    80004278:	0017871b          	addiw	a4,a5,1
    8000427c:	22e4a223          	sw	a4,548(s1)
    80004280:	1ff7f793          	andi	a5,a5,511
    80004284:	97a6                	add	a5,a5,s1
    80004286:	faf44703          	lbu	a4,-81(s0)
    8000428a:	02e78023          	sb	a4,32(a5)
      i++;
    8000428e:	2905                	addiw	s2,s2,1
    80004290:	b755                	j	80004234 <pipewrite+0x80>
  int i = 0;
    80004292:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004294:	22048513          	addi	a0,s1,544
    80004298:	ffffd097          	auipc	ra,0xffffd
    8000429c:	3e4080e7          	jalr	996(ra) # 8000167c <wakeup>
  release(&pi->lock);
    800042a0:	8526                	mv	a0,s1
    800042a2:	00002097          	auipc	ra,0x2
    800042a6:	5e0080e7          	jalr	1504(ra) # 80006882 <release>
  return i;
    800042aa:	bfa9                	j	80004204 <pipewrite+0x50>

00000000800042ac <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800042ac:	715d                	addi	sp,sp,-80
    800042ae:	e486                	sd	ra,72(sp)
    800042b0:	e0a2                	sd	s0,64(sp)
    800042b2:	fc26                	sd	s1,56(sp)
    800042b4:	f84a                	sd	s2,48(sp)
    800042b6:	f44e                	sd	s3,40(sp)
    800042b8:	f052                	sd	s4,32(sp)
    800042ba:	ec56                	sd	s5,24(sp)
    800042bc:	e85a                	sd	s6,16(sp)
    800042be:	0880                	addi	s0,sp,80
    800042c0:	84aa                	mv	s1,a0
    800042c2:	892e                	mv	s2,a1
    800042c4:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800042c6:	ffffd097          	auipc	ra,0xffffd
    800042ca:	caa080e7          	jalr	-854(ra) # 80000f70 <myproc>
    800042ce:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800042d0:	8526                	mv	a0,s1
    800042d2:	00002097          	auipc	ra,0x2
    800042d6:	4e0080e7          	jalr	1248(ra) # 800067b2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042da:	2204a703          	lw	a4,544(s1)
    800042de:	2244a783          	lw	a5,548(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800042e2:	22048993          	addi	s3,s1,544
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042e6:	02f71763          	bne	a4,a5,80004314 <piperead+0x68>
    800042ea:	22c4a783          	lw	a5,556(s1)
    800042ee:	c39d                	beqz	a5,80004314 <piperead+0x68>
    if(killed(pr)){
    800042f0:	8552                	mv	a0,s4
    800042f2:	ffffd097          	auipc	ra,0xffffd
    800042f6:	5ce080e7          	jalr	1486(ra) # 800018c0 <killed>
    800042fa:	e949                	bnez	a0,8000438c <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800042fc:	85a6                	mv	a1,s1
    800042fe:	854e                	mv	a0,s3
    80004300:	ffffd097          	auipc	ra,0xffffd
    80004304:	318080e7          	jalr	792(ra) # 80001618 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004308:	2204a703          	lw	a4,544(s1)
    8000430c:	2244a783          	lw	a5,548(s1)
    80004310:	fcf70de3          	beq	a4,a5,800042ea <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004314:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004316:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004318:	05505463          	blez	s5,80004360 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    8000431c:	2204a783          	lw	a5,544(s1)
    80004320:	2244a703          	lw	a4,548(s1)
    80004324:	02f70e63          	beq	a4,a5,80004360 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004328:	0017871b          	addiw	a4,a5,1
    8000432c:	22e4a023          	sw	a4,544(s1)
    80004330:	1ff7f793          	andi	a5,a5,511
    80004334:	97a6                	add	a5,a5,s1
    80004336:	0207c783          	lbu	a5,32(a5)
    8000433a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000433e:	4685                	li	a3,1
    80004340:	fbf40613          	addi	a2,s0,-65
    80004344:	85ca                	mv	a1,s2
    80004346:	058a3503          	ld	a0,88(s4)
    8000434a:	ffffd097          	auipc	ra,0xffffd
    8000434e:	8e6080e7          	jalr	-1818(ra) # 80000c30 <copyout>
    80004352:	01650763          	beq	a0,s6,80004360 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004356:	2985                	addiw	s3,s3,1
    80004358:	0905                	addi	s2,s2,1
    8000435a:	fd3a91e3          	bne	s5,s3,8000431c <piperead+0x70>
    8000435e:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004360:	22448513          	addi	a0,s1,548
    80004364:	ffffd097          	auipc	ra,0xffffd
    80004368:	318080e7          	jalr	792(ra) # 8000167c <wakeup>
  release(&pi->lock);
    8000436c:	8526                	mv	a0,s1
    8000436e:	00002097          	auipc	ra,0x2
    80004372:	514080e7          	jalr	1300(ra) # 80006882 <release>
  return i;
}
    80004376:	854e                	mv	a0,s3
    80004378:	60a6                	ld	ra,72(sp)
    8000437a:	6406                	ld	s0,64(sp)
    8000437c:	74e2                	ld	s1,56(sp)
    8000437e:	7942                	ld	s2,48(sp)
    80004380:	79a2                	ld	s3,40(sp)
    80004382:	7a02                	ld	s4,32(sp)
    80004384:	6ae2                	ld	s5,24(sp)
    80004386:	6b42                	ld	s6,16(sp)
    80004388:	6161                	addi	sp,sp,80
    8000438a:	8082                	ret
      release(&pi->lock);
    8000438c:	8526                	mv	a0,s1
    8000438e:	00002097          	auipc	ra,0x2
    80004392:	4f4080e7          	jalr	1268(ra) # 80006882 <release>
      return -1;
    80004396:	59fd                	li	s3,-1
    80004398:	bff9                	j	80004376 <piperead+0xca>

000000008000439a <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000439a:	1141                	addi	sp,sp,-16
    8000439c:	e422                	sd	s0,8(sp)
    8000439e:	0800                	addi	s0,sp,16
    800043a0:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800043a2:	8905                	andi	a0,a0,1
    800043a4:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800043a6:	8b89                	andi	a5,a5,2
    800043a8:	c399                	beqz	a5,800043ae <flags2perm+0x14>
      perm |= PTE_W;
    800043aa:	00456513          	ori	a0,a0,4
    return perm;
}
    800043ae:	6422                	ld	s0,8(sp)
    800043b0:	0141                	addi	sp,sp,16
    800043b2:	8082                	ret

00000000800043b4 <exec>:

int
exec(char *path, char **argv)
{
    800043b4:	de010113          	addi	sp,sp,-544
    800043b8:	20113c23          	sd	ra,536(sp)
    800043bc:	20813823          	sd	s0,528(sp)
    800043c0:	20913423          	sd	s1,520(sp)
    800043c4:	21213023          	sd	s2,512(sp)
    800043c8:	ffce                	sd	s3,504(sp)
    800043ca:	fbd2                	sd	s4,496(sp)
    800043cc:	f7d6                	sd	s5,488(sp)
    800043ce:	f3da                	sd	s6,480(sp)
    800043d0:	efde                	sd	s7,472(sp)
    800043d2:	ebe2                	sd	s8,464(sp)
    800043d4:	e7e6                	sd	s9,456(sp)
    800043d6:	e3ea                	sd	s10,448(sp)
    800043d8:	ff6e                	sd	s11,440(sp)
    800043da:	1400                	addi	s0,sp,544
    800043dc:	892a                	mv	s2,a0
    800043de:	dea43423          	sd	a0,-536(s0)
    800043e2:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800043e6:	ffffd097          	auipc	ra,0xffffd
    800043ea:	b8a080e7          	jalr	-1142(ra) # 80000f70 <myproc>
    800043ee:	84aa                	mv	s1,a0

  begin_op();
    800043f0:	fffff097          	auipc	ra,0xfffff
    800043f4:	478080e7          	jalr	1144(ra) # 80003868 <begin_op>

  if((ip = namei(path)) == 0){
    800043f8:	854a                	mv	a0,s2
    800043fa:	fffff097          	auipc	ra,0xfffff
    800043fe:	24e080e7          	jalr	590(ra) # 80003648 <namei>
    80004402:	c93d                	beqz	a0,80004478 <exec+0xc4>
    80004404:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004406:	fffff097          	auipc	ra,0xfffff
    8000440a:	a82080e7          	jalr	-1406(ra) # 80002e88 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000440e:	04000713          	li	a4,64
    80004412:	4681                	li	a3,0
    80004414:	e5040613          	addi	a2,s0,-432
    80004418:	4581                	li	a1,0
    8000441a:	8556                	mv	a0,s5
    8000441c:	fffff097          	auipc	ra,0xfffff
    80004420:	d34080e7          	jalr	-716(ra) # 80003150 <readi>
    80004424:	04000793          	li	a5,64
    80004428:	00f51a63          	bne	a0,a5,8000443c <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000442c:	e5042703          	lw	a4,-432(s0)
    80004430:	464c47b7          	lui	a5,0x464c4
    80004434:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004438:	04f70663          	beq	a4,a5,80004484 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000443c:	8556                	mv	a0,s5
    8000443e:	fffff097          	auipc	ra,0xfffff
    80004442:	cc0080e7          	jalr	-832(ra) # 800030fe <iunlockput>
    end_op();
    80004446:	fffff097          	auipc	ra,0xfffff
    8000444a:	4a0080e7          	jalr	1184(ra) # 800038e6 <end_op>
  }
  return -1;
    8000444e:	557d                	li	a0,-1
}
    80004450:	21813083          	ld	ra,536(sp)
    80004454:	21013403          	ld	s0,528(sp)
    80004458:	20813483          	ld	s1,520(sp)
    8000445c:	20013903          	ld	s2,512(sp)
    80004460:	79fe                	ld	s3,504(sp)
    80004462:	7a5e                	ld	s4,496(sp)
    80004464:	7abe                	ld	s5,488(sp)
    80004466:	7b1e                	ld	s6,480(sp)
    80004468:	6bfe                	ld	s7,472(sp)
    8000446a:	6c5e                	ld	s8,464(sp)
    8000446c:	6cbe                	ld	s9,456(sp)
    8000446e:	6d1e                	ld	s10,448(sp)
    80004470:	7dfa                	ld	s11,440(sp)
    80004472:	22010113          	addi	sp,sp,544
    80004476:	8082                	ret
    end_op();
    80004478:	fffff097          	auipc	ra,0xfffff
    8000447c:	46e080e7          	jalr	1134(ra) # 800038e6 <end_op>
    return -1;
    80004480:	557d                	li	a0,-1
    80004482:	b7f9                	j	80004450 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004484:	8526                	mv	a0,s1
    80004486:	ffffd097          	auipc	ra,0xffffd
    8000448a:	bae080e7          	jalr	-1106(ra) # 80001034 <proc_pagetable>
    8000448e:	8b2a                	mv	s6,a0
    80004490:	d555                	beqz	a0,8000443c <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004492:	e7042783          	lw	a5,-400(s0)
    80004496:	e8845703          	lhu	a4,-376(s0)
    8000449a:	c735                	beqz	a4,80004506 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000449c:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000449e:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    800044a2:	6a05                	lui	s4,0x1
    800044a4:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800044a8:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800044ac:	6d85                	lui	s11,0x1
    800044ae:	7d7d                	lui	s10,0xfffff
    800044b0:	ac3d                	j	800046ee <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800044b2:	00004517          	auipc	a0,0x4
    800044b6:	1b650513          	addi	a0,a0,438 # 80008668 <syscalls+0x298>
    800044ba:	00002097          	auipc	ra,0x2
    800044be:	dd6080e7          	jalr	-554(ra) # 80006290 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800044c2:	874a                	mv	a4,s2
    800044c4:	009c86bb          	addw	a3,s9,s1
    800044c8:	4581                	li	a1,0
    800044ca:	8556                	mv	a0,s5
    800044cc:	fffff097          	auipc	ra,0xfffff
    800044d0:	c84080e7          	jalr	-892(ra) # 80003150 <readi>
    800044d4:	2501                	sext.w	a0,a0
    800044d6:	1aa91963          	bne	s2,a0,80004688 <exec+0x2d4>
  for(i = 0; i < sz; i += PGSIZE){
    800044da:	009d84bb          	addw	s1,s11,s1
    800044de:	013d09bb          	addw	s3,s10,s3
    800044e2:	1f74f663          	bgeu	s1,s7,800046ce <exec+0x31a>
    pa = walkaddr(pagetable, va + i);
    800044e6:	02049593          	slli	a1,s1,0x20
    800044ea:	9181                	srli	a1,a1,0x20
    800044ec:	95e2                	add	a1,a1,s8
    800044ee:	855a                	mv	a0,s6
    800044f0:	ffffc097          	auipc	ra,0xffffc
    800044f4:	130080e7          	jalr	304(ra) # 80000620 <walkaddr>
    800044f8:	862a                	mv	a2,a0
    if(pa == 0)
    800044fa:	dd45                	beqz	a0,800044b2 <exec+0xfe>
      n = PGSIZE;
    800044fc:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800044fe:	fd49f2e3          	bgeu	s3,s4,800044c2 <exec+0x10e>
      n = sz - i;
    80004502:	894e                	mv	s2,s3
    80004504:	bf7d                	j	800044c2 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004506:	4901                	li	s2,0
  iunlockput(ip);
    80004508:	8556                	mv	a0,s5
    8000450a:	fffff097          	auipc	ra,0xfffff
    8000450e:	bf4080e7          	jalr	-1036(ra) # 800030fe <iunlockput>
  end_op();
    80004512:	fffff097          	auipc	ra,0xfffff
    80004516:	3d4080e7          	jalr	980(ra) # 800038e6 <end_op>
  p = myproc();
    8000451a:	ffffd097          	auipc	ra,0xffffd
    8000451e:	a56080e7          	jalr	-1450(ra) # 80000f70 <myproc>
    80004522:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004524:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    80004528:	6785                	lui	a5,0x1
    8000452a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000452c:	97ca                	add	a5,a5,s2
    8000452e:	777d                	lui	a4,0xfffff
    80004530:	8ff9                	and	a5,a5,a4
    80004532:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004536:	4691                	li	a3,4
    80004538:	6609                	lui	a2,0x2
    8000453a:	963e                	add	a2,a2,a5
    8000453c:	85be                	mv	a1,a5
    8000453e:	855a                	mv	a0,s6
    80004540:	ffffc097          	auipc	ra,0xffffc
    80004544:	494080e7          	jalr	1172(ra) # 800009d4 <uvmalloc>
    80004548:	8c2a                	mv	s8,a0
  ip = 0;
    8000454a:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000454c:	12050e63          	beqz	a0,80004688 <exec+0x2d4>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004550:	75f9                	lui	a1,0xffffe
    80004552:	95aa                	add	a1,a1,a0
    80004554:	855a                	mv	a0,s6
    80004556:	ffffc097          	auipc	ra,0xffffc
    8000455a:	6a8080e7          	jalr	1704(ra) # 80000bfe <uvmclear>
  stackbase = sp - PGSIZE;
    8000455e:	7afd                	lui	s5,0xfffff
    80004560:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004562:	df043783          	ld	a5,-528(s0)
    80004566:	6388                	ld	a0,0(a5)
    80004568:	c925                	beqz	a0,800045d8 <exec+0x224>
    8000456a:	e9040993          	addi	s3,s0,-368
    8000456e:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004572:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004574:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004576:	ffffc097          	auipc	ra,0xffffc
    8000457a:	e8c080e7          	jalr	-372(ra) # 80000402 <strlen>
    8000457e:	0015079b          	addiw	a5,a0,1
    80004582:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004586:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000458a:	13596663          	bltu	s2,s5,800046b6 <exec+0x302>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000458e:	df043d83          	ld	s11,-528(s0)
    80004592:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004596:	8552                	mv	a0,s4
    80004598:	ffffc097          	auipc	ra,0xffffc
    8000459c:	e6a080e7          	jalr	-406(ra) # 80000402 <strlen>
    800045a0:	0015069b          	addiw	a3,a0,1
    800045a4:	8652                	mv	a2,s4
    800045a6:	85ca                	mv	a1,s2
    800045a8:	855a                	mv	a0,s6
    800045aa:	ffffc097          	auipc	ra,0xffffc
    800045ae:	686080e7          	jalr	1670(ra) # 80000c30 <copyout>
    800045b2:	10054663          	bltz	a0,800046be <exec+0x30a>
    ustack[argc] = sp;
    800045b6:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800045ba:	0485                	addi	s1,s1,1
    800045bc:	008d8793          	addi	a5,s11,8
    800045c0:	def43823          	sd	a5,-528(s0)
    800045c4:	008db503          	ld	a0,8(s11)
    800045c8:	c911                	beqz	a0,800045dc <exec+0x228>
    if(argc >= MAXARG)
    800045ca:	09a1                	addi	s3,s3,8
    800045cc:	fb3c95e3          	bne	s9,s3,80004576 <exec+0x1c2>
  sz = sz1;
    800045d0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800045d4:	4a81                	li	s5,0
    800045d6:	a84d                	j	80004688 <exec+0x2d4>
  sp = sz;
    800045d8:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800045da:	4481                	li	s1,0
  ustack[argc] = 0;
    800045dc:	00349793          	slli	a5,s1,0x3
    800045e0:	f9078793          	addi	a5,a5,-112
    800045e4:	97a2                	add	a5,a5,s0
    800045e6:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800045ea:	00148693          	addi	a3,s1,1
    800045ee:	068e                	slli	a3,a3,0x3
    800045f0:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800045f4:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800045f8:	01597663          	bgeu	s2,s5,80004604 <exec+0x250>
  sz = sz1;
    800045fc:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004600:	4a81                	li	s5,0
    80004602:	a059                	j	80004688 <exec+0x2d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004604:	e9040613          	addi	a2,s0,-368
    80004608:	85ca                	mv	a1,s2
    8000460a:	855a                	mv	a0,s6
    8000460c:	ffffc097          	auipc	ra,0xffffc
    80004610:	624080e7          	jalr	1572(ra) # 80000c30 <copyout>
    80004614:	0a054963          	bltz	a0,800046c6 <exec+0x312>
  p->trapframe->a1 = sp;
    80004618:	060bb783          	ld	a5,96(s7)
    8000461c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004620:	de843783          	ld	a5,-536(s0)
    80004624:	0007c703          	lbu	a4,0(a5)
    80004628:	cf11                	beqz	a4,80004644 <exec+0x290>
    8000462a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000462c:	02f00693          	li	a3,47
    80004630:	a039                	j	8000463e <exec+0x28a>
      last = s+1;
    80004632:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004636:	0785                	addi	a5,a5,1
    80004638:	fff7c703          	lbu	a4,-1(a5)
    8000463c:	c701                	beqz	a4,80004644 <exec+0x290>
    if(*s == '/')
    8000463e:	fed71ce3          	bne	a4,a3,80004636 <exec+0x282>
    80004642:	bfc5                	j	80004632 <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    80004644:	4641                	li	a2,16
    80004646:	de843583          	ld	a1,-536(s0)
    8000464a:	160b8513          	addi	a0,s7,352
    8000464e:	ffffc097          	auipc	ra,0xffffc
    80004652:	d82080e7          	jalr	-638(ra) # 800003d0 <safestrcpy>
  oldpagetable = p->pagetable;
    80004656:	058bb503          	ld	a0,88(s7)
  p->pagetable = pagetable;
    8000465a:	056bbc23          	sd	s6,88(s7)
  p->sz = sz;
    8000465e:	058bb823          	sd	s8,80(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004662:	060bb783          	ld	a5,96(s7)
    80004666:	e6843703          	ld	a4,-408(s0)
    8000466a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000466c:	060bb783          	ld	a5,96(s7)
    80004670:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004674:	85ea                	mv	a1,s10
    80004676:	ffffd097          	auipc	ra,0xffffd
    8000467a:	a5a080e7          	jalr	-1446(ra) # 800010d0 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000467e:	0004851b          	sext.w	a0,s1
    80004682:	b3f9                	j	80004450 <exec+0x9c>
    80004684:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004688:	df843583          	ld	a1,-520(s0)
    8000468c:	855a                	mv	a0,s6
    8000468e:	ffffd097          	auipc	ra,0xffffd
    80004692:	a42080e7          	jalr	-1470(ra) # 800010d0 <proc_freepagetable>
  if(ip){
    80004696:	da0a93e3          	bnez	s5,8000443c <exec+0x88>
  return -1;
    8000469a:	557d                	li	a0,-1
    8000469c:	bb55                	j	80004450 <exec+0x9c>
    8000469e:	df243c23          	sd	s2,-520(s0)
    800046a2:	b7dd                	j	80004688 <exec+0x2d4>
    800046a4:	df243c23          	sd	s2,-520(s0)
    800046a8:	b7c5                	j	80004688 <exec+0x2d4>
    800046aa:	df243c23          	sd	s2,-520(s0)
    800046ae:	bfe9                	j	80004688 <exec+0x2d4>
    800046b0:	df243c23          	sd	s2,-520(s0)
    800046b4:	bfd1                	j	80004688 <exec+0x2d4>
  sz = sz1;
    800046b6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800046ba:	4a81                	li	s5,0
    800046bc:	b7f1                	j	80004688 <exec+0x2d4>
  sz = sz1;
    800046be:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800046c2:	4a81                	li	s5,0
    800046c4:	b7d1                	j	80004688 <exec+0x2d4>
  sz = sz1;
    800046c6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800046ca:	4a81                	li	s5,0
    800046cc:	bf75                	j	80004688 <exec+0x2d4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800046ce:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800046d2:	e0843783          	ld	a5,-504(s0)
    800046d6:	0017869b          	addiw	a3,a5,1
    800046da:	e0d43423          	sd	a3,-504(s0)
    800046de:	e0043783          	ld	a5,-512(s0)
    800046e2:	0387879b          	addiw	a5,a5,56
    800046e6:	e8845703          	lhu	a4,-376(s0)
    800046ea:	e0e6dfe3          	bge	a3,a4,80004508 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800046ee:	2781                	sext.w	a5,a5
    800046f0:	e0f43023          	sd	a5,-512(s0)
    800046f4:	03800713          	li	a4,56
    800046f8:	86be                	mv	a3,a5
    800046fa:	e1840613          	addi	a2,s0,-488
    800046fe:	4581                	li	a1,0
    80004700:	8556                	mv	a0,s5
    80004702:	fffff097          	auipc	ra,0xfffff
    80004706:	a4e080e7          	jalr	-1458(ra) # 80003150 <readi>
    8000470a:	03800793          	li	a5,56
    8000470e:	f6f51be3          	bne	a0,a5,80004684 <exec+0x2d0>
    if(ph.type != ELF_PROG_LOAD)
    80004712:	e1842783          	lw	a5,-488(s0)
    80004716:	4705                	li	a4,1
    80004718:	fae79de3          	bne	a5,a4,800046d2 <exec+0x31e>
    if(ph.memsz < ph.filesz)
    8000471c:	e4043483          	ld	s1,-448(s0)
    80004720:	e3843783          	ld	a5,-456(s0)
    80004724:	f6f4ede3          	bltu	s1,a5,8000469e <exec+0x2ea>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004728:	e2843783          	ld	a5,-472(s0)
    8000472c:	94be                	add	s1,s1,a5
    8000472e:	f6f4ebe3          	bltu	s1,a5,800046a4 <exec+0x2f0>
    if(ph.vaddr % PGSIZE != 0)
    80004732:	de043703          	ld	a4,-544(s0)
    80004736:	8ff9                	and	a5,a5,a4
    80004738:	fbad                	bnez	a5,800046aa <exec+0x2f6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000473a:	e1c42503          	lw	a0,-484(s0)
    8000473e:	00000097          	auipc	ra,0x0
    80004742:	c5c080e7          	jalr	-932(ra) # 8000439a <flags2perm>
    80004746:	86aa                	mv	a3,a0
    80004748:	8626                	mv	a2,s1
    8000474a:	85ca                	mv	a1,s2
    8000474c:	855a                	mv	a0,s6
    8000474e:	ffffc097          	auipc	ra,0xffffc
    80004752:	286080e7          	jalr	646(ra) # 800009d4 <uvmalloc>
    80004756:	dea43c23          	sd	a0,-520(s0)
    8000475a:	d939                	beqz	a0,800046b0 <exec+0x2fc>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000475c:	e2843c03          	ld	s8,-472(s0)
    80004760:	e2042c83          	lw	s9,-480(s0)
    80004764:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004768:	f60b83e3          	beqz	s7,800046ce <exec+0x31a>
    8000476c:	89de                	mv	s3,s7
    8000476e:	4481                	li	s1,0
    80004770:	bb9d                	j	800044e6 <exec+0x132>

0000000080004772 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004772:	7179                	addi	sp,sp,-48
    80004774:	f406                	sd	ra,40(sp)
    80004776:	f022                	sd	s0,32(sp)
    80004778:	ec26                	sd	s1,24(sp)
    8000477a:	e84a                	sd	s2,16(sp)
    8000477c:	1800                	addi	s0,sp,48
    8000477e:	892e                	mv	s2,a1
    80004780:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004782:	fdc40593          	addi	a1,s0,-36
    80004786:	ffffe097          	auipc	ra,0xffffe
    8000478a:	900080e7          	jalr	-1792(ra) # 80002086 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000478e:	fdc42703          	lw	a4,-36(s0)
    80004792:	47bd                	li	a5,15
    80004794:	02e7eb63          	bltu	a5,a4,800047ca <argfd+0x58>
    80004798:	ffffc097          	auipc	ra,0xffffc
    8000479c:	7d8080e7          	jalr	2008(ra) # 80000f70 <myproc>
    800047a0:	fdc42703          	lw	a4,-36(s0)
    800047a4:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffd7482>
    800047a8:	078e                	slli	a5,a5,0x3
    800047aa:	953e                	add	a0,a0,a5
    800047ac:	651c                	ld	a5,8(a0)
    800047ae:	c385                	beqz	a5,800047ce <argfd+0x5c>
    return -1;
  if(pfd)
    800047b0:	00090463          	beqz	s2,800047b8 <argfd+0x46>
    *pfd = fd;
    800047b4:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800047b8:	4501                	li	a0,0
  if(pf)
    800047ba:	c091                	beqz	s1,800047be <argfd+0x4c>
    *pf = f;
    800047bc:	e09c                	sd	a5,0(s1)
}
    800047be:	70a2                	ld	ra,40(sp)
    800047c0:	7402                	ld	s0,32(sp)
    800047c2:	64e2                	ld	s1,24(sp)
    800047c4:	6942                	ld	s2,16(sp)
    800047c6:	6145                	addi	sp,sp,48
    800047c8:	8082                	ret
    return -1;
    800047ca:	557d                	li	a0,-1
    800047cc:	bfcd                	j	800047be <argfd+0x4c>
    800047ce:	557d                	li	a0,-1
    800047d0:	b7fd                	j	800047be <argfd+0x4c>

00000000800047d2 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800047d2:	1101                	addi	sp,sp,-32
    800047d4:	ec06                	sd	ra,24(sp)
    800047d6:	e822                	sd	s0,16(sp)
    800047d8:	e426                	sd	s1,8(sp)
    800047da:	1000                	addi	s0,sp,32
    800047dc:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800047de:	ffffc097          	auipc	ra,0xffffc
    800047e2:	792080e7          	jalr	1938(ra) # 80000f70 <myproc>
    800047e6:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800047e8:	0d850793          	addi	a5,a0,216
    800047ec:	4501                	li	a0,0
    800047ee:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800047f0:	6398                	ld	a4,0(a5)
    800047f2:	cb19                	beqz	a4,80004808 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800047f4:	2505                	addiw	a0,a0,1
    800047f6:	07a1                	addi	a5,a5,8
    800047f8:	fed51ce3          	bne	a0,a3,800047f0 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800047fc:	557d                	li	a0,-1
}
    800047fe:	60e2                	ld	ra,24(sp)
    80004800:	6442                	ld	s0,16(sp)
    80004802:	64a2                	ld	s1,8(sp)
    80004804:	6105                	addi	sp,sp,32
    80004806:	8082                	ret
      p->ofile[fd] = f;
    80004808:	01a50793          	addi	a5,a0,26
    8000480c:	078e                	slli	a5,a5,0x3
    8000480e:	963e                	add	a2,a2,a5
    80004810:	e604                	sd	s1,8(a2)
      return fd;
    80004812:	b7f5                	j	800047fe <fdalloc+0x2c>

0000000080004814 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004814:	715d                	addi	sp,sp,-80
    80004816:	e486                	sd	ra,72(sp)
    80004818:	e0a2                	sd	s0,64(sp)
    8000481a:	fc26                	sd	s1,56(sp)
    8000481c:	f84a                	sd	s2,48(sp)
    8000481e:	f44e                	sd	s3,40(sp)
    80004820:	f052                	sd	s4,32(sp)
    80004822:	ec56                	sd	s5,24(sp)
    80004824:	e85a                	sd	s6,16(sp)
    80004826:	0880                	addi	s0,sp,80
    80004828:	8b2e                	mv	s6,a1
    8000482a:	89b2                	mv	s3,a2
    8000482c:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000482e:	fb040593          	addi	a1,s0,-80
    80004832:	fffff097          	auipc	ra,0xfffff
    80004836:	e34080e7          	jalr	-460(ra) # 80003666 <nameiparent>
    8000483a:	84aa                	mv	s1,a0
    8000483c:	14050f63          	beqz	a0,8000499a <create+0x186>
    return 0;

  ilock(dp);
    80004840:	ffffe097          	auipc	ra,0xffffe
    80004844:	648080e7          	jalr	1608(ra) # 80002e88 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004848:	4601                	li	a2,0
    8000484a:	fb040593          	addi	a1,s0,-80
    8000484e:	8526                	mv	a0,s1
    80004850:	fffff097          	auipc	ra,0xfffff
    80004854:	b30080e7          	jalr	-1232(ra) # 80003380 <dirlookup>
    80004858:	8aaa                	mv	s5,a0
    8000485a:	c931                	beqz	a0,800048ae <create+0x9a>
    iunlockput(dp);
    8000485c:	8526                	mv	a0,s1
    8000485e:	fffff097          	auipc	ra,0xfffff
    80004862:	8a0080e7          	jalr	-1888(ra) # 800030fe <iunlockput>
    ilock(ip);
    80004866:	8556                	mv	a0,s5
    80004868:	ffffe097          	auipc	ra,0xffffe
    8000486c:	620080e7          	jalr	1568(ra) # 80002e88 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004870:	000b059b          	sext.w	a1,s6
    80004874:	4789                	li	a5,2
    80004876:	02f59563          	bne	a1,a5,800048a0 <create+0x8c>
    8000487a:	04cad783          	lhu	a5,76(s5) # fffffffffffff04c <end+0xffffffff7ffd74b4>
    8000487e:	37f9                	addiw	a5,a5,-2
    80004880:	17c2                	slli	a5,a5,0x30
    80004882:	93c1                	srli	a5,a5,0x30
    80004884:	4705                	li	a4,1
    80004886:	00f76d63          	bltu	a4,a5,800048a0 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000488a:	8556                	mv	a0,s5
    8000488c:	60a6                	ld	ra,72(sp)
    8000488e:	6406                	ld	s0,64(sp)
    80004890:	74e2                	ld	s1,56(sp)
    80004892:	7942                	ld	s2,48(sp)
    80004894:	79a2                	ld	s3,40(sp)
    80004896:	7a02                	ld	s4,32(sp)
    80004898:	6ae2                	ld	s5,24(sp)
    8000489a:	6b42                	ld	s6,16(sp)
    8000489c:	6161                	addi	sp,sp,80
    8000489e:	8082                	ret
    iunlockput(ip);
    800048a0:	8556                	mv	a0,s5
    800048a2:	fffff097          	auipc	ra,0xfffff
    800048a6:	85c080e7          	jalr	-1956(ra) # 800030fe <iunlockput>
    return 0;
    800048aa:	4a81                	li	s5,0
    800048ac:	bff9                	j	8000488a <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800048ae:	85da                	mv	a1,s6
    800048b0:	4088                	lw	a0,0(s1)
    800048b2:	ffffe097          	auipc	ra,0xffffe
    800048b6:	438080e7          	jalr	1080(ra) # 80002cea <ialloc>
    800048ba:	8a2a                	mv	s4,a0
    800048bc:	c539                	beqz	a0,8000490a <create+0xf6>
  ilock(ip);
    800048be:	ffffe097          	auipc	ra,0xffffe
    800048c2:	5ca080e7          	jalr	1482(ra) # 80002e88 <ilock>
  ip->major = major;
    800048c6:	053a1723          	sh	s3,78(s4)
  ip->minor = minor;
    800048ca:	052a1823          	sh	s2,80(s4)
  ip->nlink = 1;
    800048ce:	4905                	li	s2,1
    800048d0:	052a1923          	sh	s2,82(s4)
  iupdate(ip);
    800048d4:	8552                	mv	a0,s4
    800048d6:	ffffe097          	auipc	ra,0xffffe
    800048da:	4e6080e7          	jalr	1254(ra) # 80002dbc <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800048de:	000b059b          	sext.w	a1,s6
    800048e2:	03258b63          	beq	a1,s2,80004918 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    800048e6:	004a2603          	lw	a2,4(s4)
    800048ea:	fb040593          	addi	a1,s0,-80
    800048ee:	8526                	mv	a0,s1
    800048f0:	fffff097          	auipc	ra,0xfffff
    800048f4:	ca6080e7          	jalr	-858(ra) # 80003596 <dirlink>
    800048f8:	06054f63          	bltz	a0,80004976 <create+0x162>
  iunlockput(dp);
    800048fc:	8526                	mv	a0,s1
    800048fe:	fffff097          	auipc	ra,0xfffff
    80004902:	800080e7          	jalr	-2048(ra) # 800030fe <iunlockput>
  return ip;
    80004906:	8ad2                	mv	s5,s4
    80004908:	b749                	j	8000488a <create+0x76>
    iunlockput(dp);
    8000490a:	8526                	mv	a0,s1
    8000490c:	ffffe097          	auipc	ra,0xffffe
    80004910:	7f2080e7          	jalr	2034(ra) # 800030fe <iunlockput>
    return 0;
    80004914:	8ad2                	mv	s5,s4
    80004916:	bf95                	j	8000488a <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004918:	004a2603          	lw	a2,4(s4)
    8000491c:	00004597          	auipc	a1,0x4
    80004920:	d6c58593          	addi	a1,a1,-660 # 80008688 <syscalls+0x2b8>
    80004924:	8552                	mv	a0,s4
    80004926:	fffff097          	auipc	ra,0xfffff
    8000492a:	c70080e7          	jalr	-912(ra) # 80003596 <dirlink>
    8000492e:	04054463          	bltz	a0,80004976 <create+0x162>
    80004932:	40d0                	lw	a2,4(s1)
    80004934:	00004597          	auipc	a1,0x4
    80004938:	d5c58593          	addi	a1,a1,-676 # 80008690 <syscalls+0x2c0>
    8000493c:	8552                	mv	a0,s4
    8000493e:	fffff097          	auipc	ra,0xfffff
    80004942:	c58080e7          	jalr	-936(ra) # 80003596 <dirlink>
    80004946:	02054863          	bltz	a0,80004976 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    8000494a:	004a2603          	lw	a2,4(s4)
    8000494e:	fb040593          	addi	a1,s0,-80
    80004952:	8526                	mv	a0,s1
    80004954:	fffff097          	auipc	ra,0xfffff
    80004958:	c42080e7          	jalr	-958(ra) # 80003596 <dirlink>
    8000495c:	00054d63          	bltz	a0,80004976 <create+0x162>
    dp->nlink++;  // for ".."
    80004960:	0524d783          	lhu	a5,82(s1)
    80004964:	2785                	addiw	a5,a5,1
    80004966:	04f49923          	sh	a5,82(s1)
    iupdate(dp);
    8000496a:	8526                	mv	a0,s1
    8000496c:	ffffe097          	auipc	ra,0xffffe
    80004970:	450080e7          	jalr	1104(ra) # 80002dbc <iupdate>
    80004974:	b761                	j	800048fc <create+0xe8>
  ip->nlink = 0;
    80004976:	040a1923          	sh	zero,82(s4)
  iupdate(ip);
    8000497a:	8552                	mv	a0,s4
    8000497c:	ffffe097          	auipc	ra,0xffffe
    80004980:	440080e7          	jalr	1088(ra) # 80002dbc <iupdate>
  iunlockput(ip);
    80004984:	8552                	mv	a0,s4
    80004986:	ffffe097          	auipc	ra,0xffffe
    8000498a:	778080e7          	jalr	1912(ra) # 800030fe <iunlockput>
  iunlockput(dp);
    8000498e:	8526                	mv	a0,s1
    80004990:	ffffe097          	auipc	ra,0xffffe
    80004994:	76e080e7          	jalr	1902(ra) # 800030fe <iunlockput>
  return 0;
    80004998:	bdcd                	j	8000488a <create+0x76>
    return 0;
    8000499a:	8aaa                	mv	s5,a0
    8000499c:	b5fd                	j	8000488a <create+0x76>

000000008000499e <sys_dup>:
{
    8000499e:	7179                	addi	sp,sp,-48
    800049a0:	f406                	sd	ra,40(sp)
    800049a2:	f022                	sd	s0,32(sp)
    800049a4:	ec26                	sd	s1,24(sp)
    800049a6:	e84a                	sd	s2,16(sp)
    800049a8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800049aa:	fd840613          	addi	a2,s0,-40
    800049ae:	4581                	li	a1,0
    800049b0:	4501                	li	a0,0
    800049b2:	00000097          	auipc	ra,0x0
    800049b6:	dc0080e7          	jalr	-576(ra) # 80004772 <argfd>
    return -1;
    800049ba:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800049bc:	02054363          	bltz	a0,800049e2 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800049c0:	fd843903          	ld	s2,-40(s0)
    800049c4:	854a                	mv	a0,s2
    800049c6:	00000097          	auipc	ra,0x0
    800049ca:	e0c080e7          	jalr	-500(ra) # 800047d2 <fdalloc>
    800049ce:	84aa                	mv	s1,a0
    return -1;
    800049d0:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800049d2:	00054863          	bltz	a0,800049e2 <sys_dup+0x44>
  filedup(f);
    800049d6:	854a                	mv	a0,s2
    800049d8:	fffff097          	auipc	ra,0xfffff
    800049dc:	306080e7          	jalr	774(ra) # 80003cde <filedup>
  return fd;
    800049e0:	87a6                	mv	a5,s1
}
    800049e2:	853e                	mv	a0,a5
    800049e4:	70a2                	ld	ra,40(sp)
    800049e6:	7402                	ld	s0,32(sp)
    800049e8:	64e2                	ld	s1,24(sp)
    800049ea:	6942                	ld	s2,16(sp)
    800049ec:	6145                	addi	sp,sp,48
    800049ee:	8082                	ret

00000000800049f0 <sys_read>:
{
    800049f0:	7179                	addi	sp,sp,-48
    800049f2:	f406                	sd	ra,40(sp)
    800049f4:	f022                	sd	s0,32(sp)
    800049f6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800049f8:	fd840593          	addi	a1,s0,-40
    800049fc:	4505                	li	a0,1
    800049fe:	ffffd097          	auipc	ra,0xffffd
    80004a02:	6a8080e7          	jalr	1704(ra) # 800020a6 <argaddr>
  argint(2, &n);
    80004a06:	fe440593          	addi	a1,s0,-28
    80004a0a:	4509                	li	a0,2
    80004a0c:	ffffd097          	auipc	ra,0xffffd
    80004a10:	67a080e7          	jalr	1658(ra) # 80002086 <argint>
  if(argfd(0, 0, &f) < 0)
    80004a14:	fe840613          	addi	a2,s0,-24
    80004a18:	4581                	li	a1,0
    80004a1a:	4501                	li	a0,0
    80004a1c:	00000097          	auipc	ra,0x0
    80004a20:	d56080e7          	jalr	-682(ra) # 80004772 <argfd>
    80004a24:	87aa                	mv	a5,a0
    return -1;
    80004a26:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a28:	0007cc63          	bltz	a5,80004a40 <sys_read+0x50>
  return fileread(f, p, n);
    80004a2c:	fe442603          	lw	a2,-28(s0)
    80004a30:	fd843583          	ld	a1,-40(s0)
    80004a34:	fe843503          	ld	a0,-24(s0)
    80004a38:	fffff097          	auipc	ra,0xfffff
    80004a3c:	432080e7          	jalr	1074(ra) # 80003e6a <fileread>
}
    80004a40:	70a2                	ld	ra,40(sp)
    80004a42:	7402                	ld	s0,32(sp)
    80004a44:	6145                	addi	sp,sp,48
    80004a46:	8082                	ret

0000000080004a48 <sys_write>:
{
    80004a48:	7179                	addi	sp,sp,-48
    80004a4a:	f406                	sd	ra,40(sp)
    80004a4c:	f022                	sd	s0,32(sp)
    80004a4e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004a50:	fd840593          	addi	a1,s0,-40
    80004a54:	4505                	li	a0,1
    80004a56:	ffffd097          	auipc	ra,0xffffd
    80004a5a:	650080e7          	jalr	1616(ra) # 800020a6 <argaddr>
  argint(2, &n);
    80004a5e:	fe440593          	addi	a1,s0,-28
    80004a62:	4509                	li	a0,2
    80004a64:	ffffd097          	auipc	ra,0xffffd
    80004a68:	622080e7          	jalr	1570(ra) # 80002086 <argint>
  if(argfd(0, 0, &f) < 0)
    80004a6c:	fe840613          	addi	a2,s0,-24
    80004a70:	4581                	li	a1,0
    80004a72:	4501                	li	a0,0
    80004a74:	00000097          	auipc	ra,0x0
    80004a78:	cfe080e7          	jalr	-770(ra) # 80004772 <argfd>
    80004a7c:	87aa                	mv	a5,a0
    return -1;
    80004a7e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a80:	0007cc63          	bltz	a5,80004a98 <sys_write+0x50>
  return filewrite(f, p, n);
    80004a84:	fe442603          	lw	a2,-28(s0)
    80004a88:	fd843583          	ld	a1,-40(s0)
    80004a8c:	fe843503          	ld	a0,-24(s0)
    80004a90:	fffff097          	auipc	ra,0xfffff
    80004a94:	49c080e7          	jalr	1180(ra) # 80003f2c <filewrite>
}
    80004a98:	70a2                	ld	ra,40(sp)
    80004a9a:	7402                	ld	s0,32(sp)
    80004a9c:	6145                	addi	sp,sp,48
    80004a9e:	8082                	ret

0000000080004aa0 <sys_close>:
{
    80004aa0:	1101                	addi	sp,sp,-32
    80004aa2:	ec06                	sd	ra,24(sp)
    80004aa4:	e822                	sd	s0,16(sp)
    80004aa6:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004aa8:	fe040613          	addi	a2,s0,-32
    80004aac:	fec40593          	addi	a1,s0,-20
    80004ab0:	4501                	li	a0,0
    80004ab2:	00000097          	auipc	ra,0x0
    80004ab6:	cc0080e7          	jalr	-832(ra) # 80004772 <argfd>
    return -1;
    80004aba:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004abc:	02054463          	bltz	a0,80004ae4 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004ac0:	ffffc097          	auipc	ra,0xffffc
    80004ac4:	4b0080e7          	jalr	1200(ra) # 80000f70 <myproc>
    80004ac8:	fec42783          	lw	a5,-20(s0)
    80004acc:	07e9                	addi	a5,a5,26
    80004ace:	078e                	slli	a5,a5,0x3
    80004ad0:	953e                	add	a0,a0,a5
    80004ad2:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80004ad6:	fe043503          	ld	a0,-32(s0)
    80004ada:	fffff097          	auipc	ra,0xfffff
    80004ade:	256080e7          	jalr	598(ra) # 80003d30 <fileclose>
  return 0;
    80004ae2:	4781                	li	a5,0
}
    80004ae4:	853e                	mv	a0,a5
    80004ae6:	60e2                	ld	ra,24(sp)
    80004ae8:	6442                	ld	s0,16(sp)
    80004aea:	6105                	addi	sp,sp,32
    80004aec:	8082                	ret

0000000080004aee <sys_fstat>:
{
    80004aee:	1101                	addi	sp,sp,-32
    80004af0:	ec06                	sd	ra,24(sp)
    80004af2:	e822                	sd	s0,16(sp)
    80004af4:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004af6:	fe040593          	addi	a1,s0,-32
    80004afa:	4505                	li	a0,1
    80004afc:	ffffd097          	auipc	ra,0xffffd
    80004b00:	5aa080e7          	jalr	1450(ra) # 800020a6 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004b04:	fe840613          	addi	a2,s0,-24
    80004b08:	4581                	li	a1,0
    80004b0a:	4501                	li	a0,0
    80004b0c:	00000097          	auipc	ra,0x0
    80004b10:	c66080e7          	jalr	-922(ra) # 80004772 <argfd>
    80004b14:	87aa                	mv	a5,a0
    return -1;
    80004b16:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004b18:	0007ca63          	bltz	a5,80004b2c <sys_fstat+0x3e>
  return filestat(f, st);
    80004b1c:	fe043583          	ld	a1,-32(s0)
    80004b20:	fe843503          	ld	a0,-24(s0)
    80004b24:	fffff097          	auipc	ra,0xfffff
    80004b28:	2d4080e7          	jalr	724(ra) # 80003df8 <filestat>
}
    80004b2c:	60e2                	ld	ra,24(sp)
    80004b2e:	6442                	ld	s0,16(sp)
    80004b30:	6105                	addi	sp,sp,32
    80004b32:	8082                	ret

0000000080004b34 <sys_link>:
{
    80004b34:	7169                	addi	sp,sp,-304
    80004b36:	f606                	sd	ra,296(sp)
    80004b38:	f222                	sd	s0,288(sp)
    80004b3a:	ee26                	sd	s1,280(sp)
    80004b3c:	ea4a                	sd	s2,272(sp)
    80004b3e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b40:	08000613          	li	a2,128
    80004b44:	ed040593          	addi	a1,s0,-304
    80004b48:	4501                	li	a0,0
    80004b4a:	ffffd097          	auipc	ra,0xffffd
    80004b4e:	57c080e7          	jalr	1404(ra) # 800020c6 <argstr>
    return -1;
    80004b52:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b54:	10054e63          	bltz	a0,80004c70 <sys_link+0x13c>
    80004b58:	08000613          	li	a2,128
    80004b5c:	f5040593          	addi	a1,s0,-176
    80004b60:	4505                	li	a0,1
    80004b62:	ffffd097          	auipc	ra,0xffffd
    80004b66:	564080e7          	jalr	1380(ra) # 800020c6 <argstr>
    return -1;
    80004b6a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b6c:	10054263          	bltz	a0,80004c70 <sys_link+0x13c>
  begin_op();
    80004b70:	fffff097          	auipc	ra,0xfffff
    80004b74:	cf8080e7          	jalr	-776(ra) # 80003868 <begin_op>
  if((ip = namei(old)) == 0){
    80004b78:	ed040513          	addi	a0,s0,-304
    80004b7c:	fffff097          	auipc	ra,0xfffff
    80004b80:	acc080e7          	jalr	-1332(ra) # 80003648 <namei>
    80004b84:	84aa                	mv	s1,a0
    80004b86:	c551                	beqz	a0,80004c12 <sys_link+0xde>
  ilock(ip);
    80004b88:	ffffe097          	auipc	ra,0xffffe
    80004b8c:	300080e7          	jalr	768(ra) # 80002e88 <ilock>
  if(ip->type == T_DIR){
    80004b90:	04c49703          	lh	a4,76(s1)
    80004b94:	4785                	li	a5,1
    80004b96:	08f70463          	beq	a4,a5,80004c1e <sys_link+0xea>
  ip->nlink++;
    80004b9a:	0524d783          	lhu	a5,82(s1)
    80004b9e:	2785                	addiw	a5,a5,1
    80004ba0:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004ba4:	8526                	mv	a0,s1
    80004ba6:	ffffe097          	auipc	ra,0xffffe
    80004baa:	216080e7          	jalr	534(ra) # 80002dbc <iupdate>
  iunlock(ip);
    80004bae:	8526                	mv	a0,s1
    80004bb0:	ffffe097          	auipc	ra,0xffffe
    80004bb4:	3a4080e7          	jalr	932(ra) # 80002f54 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004bb8:	fd040593          	addi	a1,s0,-48
    80004bbc:	f5040513          	addi	a0,s0,-176
    80004bc0:	fffff097          	auipc	ra,0xfffff
    80004bc4:	aa6080e7          	jalr	-1370(ra) # 80003666 <nameiparent>
    80004bc8:	892a                	mv	s2,a0
    80004bca:	c935                	beqz	a0,80004c3e <sys_link+0x10a>
  ilock(dp);
    80004bcc:	ffffe097          	auipc	ra,0xffffe
    80004bd0:	2bc080e7          	jalr	700(ra) # 80002e88 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004bd4:	00092703          	lw	a4,0(s2)
    80004bd8:	409c                	lw	a5,0(s1)
    80004bda:	04f71d63          	bne	a4,a5,80004c34 <sys_link+0x100>
    80004bde:	40d0                	lw	a2,4(s1)
    80004be0:	fd040593          	addi	a1,s0,-48
    80004be4:	854a                	mv	a0,s2
    80004be6:	fffff097          	auipc	ra,0xfffff
    80004bea:	9b0080e7          	jalr	-1616(ra) # 80003596 <dirlink>
    80004bee:	04054363          	bltz	a0,80004c34 <sys_link+0x100>
  iunlockput(dp);
    80004bf2:	854a                	mv	a0,s2
    80004bf4:	ffffe097          	auipc	ra,0xffffe
    80004bf8:	50a080e7          	jalr	1290(ra) # 800030fe <iunlockput>
  iput(ip);
    80004bfc:	8526                	mv	a0,s1
    80004bfe:	ffffe097          	auipc	ra,0xffffe
    80004c02:	458080e7          	jalr	1112(ra) # 80003056 <iput>
  end_op();
    80004c06:	fffff097          	auipc	ra,0xfffff
    80004c0a:	ce0080e7          	jalr	-800(ra) # 800038e6 <end_op>
  return 0;
    80004c0e:	4781                	li	a5,0
    80004c10:	a085                	j	80004c70 <sys_link+0x13c>
    end_op();
    80004c12:	fffff097          	auipc	ra,0xfffff
    80004c16:	cd4080e7          	jalr	-812(ra) # 800038e6 <end_op>
    return -1;
    80004c1a:	57fd                	li	a5,-1
    80004c1c:	a891                	j	80004c70 <sys_link+0x13c>
    iunlockput(ip);
    80004c1e:	8526                	mv	a0,s1
    80004c20:	ffffe097          	auipc	ra,0xffffe
    80004c24:	4de080e7          	jalr	1246(ra) # 800030fe <iunlockput>
    end_op();
    80004c28:	fffff097          	auipc	ra,0xfffff
    80004c2c:	cbe080e7          	jalr	-834(ra) # 800038e6 <end_op>
    return -1;
    80004c30:	57fd                	li	a5,-1
    80004c32:	a83d                	j	80004c70 <sys_link+0x13c>
    iunlockput(dp);
    80004c34:	854a                	mv	a0,s2
    80004c36:	ffffe097          	auipc	ra,0xffffe
    80004c3a:	4c8080e7          	jalr	1224(ra) # 800030fe <iunlockput>
  ilock(ip);
    80004c3e:	8526                	mv	a0,s1
    80004c40:	ffffe097          	auipc	ra,0xffffe
    80004c44:	248080e7          	jalr	584(ra) # 80002e88 <ilock>
  ip->nlink--;
    80004c48:	0524d783          	lhu	a5,82(s1)
    80004c4c:	37fd                	addiw	a5,a5,-1
    80004c4e:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004c52:	8526                	mv	a0,s1
    80004c54:	ffffe097          	auipc	ra,0xffffe
    80004c58:	168080e7          	jalr	360(ra) # 80002dbc <iupdate>
  iunlockput(ip);
    80004c5c:	8526                	mv	a0,s1
    80004c5e:	ffffe097          	auipc	ra,0xffffe
    80004c62:	4a0080e7          	jalr	1184(ra) # 800030fe <iunlockput>
  end_op();
    80004c66:	fffff097          	auipc	ra,0xfffff
    80004c6a:	c80080e7          	jalr	-896(ra) # 800038e6 <end_op>
  return -1;
    80004c6e:	57fd                	li	a5,-1
}
    80004c70:	853e                	mv	a0,a5
    80004c72:	70b2                	ld	ra,296(sp)
    80004c74:	7412                	ld	s0,288(sp)
    80004c76:	64f2                	ld	s1,280(sp)
    80004c78:	6952                	ld	s2,272(sp)
    80004c7a:	6155                	addi	sp,sp,304
    80004c7c:	8082                	ret

0000000080004c7e <sys_unlink>:
{
    80004c7e:	7151                	addi	sp,sp,-240
    80004c80:	f586                	sd	ra,232(sp)
    80004c82:	f1a2                	sd	s0,224(sp)
    80004c84:	eda6                	sd	s1,216(sp)
    80004c86:	e9ca                	sd	s2,208(sp)
    80004c88:	e5ce                	sd	s3,200(sp)
    80004c8a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004c8c:	08000613          	li	a2,128
    80004c90:	f3040593          	addi	a1,s0,-208
    80004c94:	4501                	li	a0,0
    80004c96:	ffffd097          	auipc	ra,0xffffd
    80004c9a:	430080e7          	jalr	1072(ra) # 800020c6 <argstr>
    80004c9e:	18054163          	bltz	a0,80004e20 <sys_unlink+0x1a2>
  begin_op();
    80004ca2:	fffff097          	auipc	ra,0xfffff
    80004ca6:	bc6080e7          	jalr	-1082(ra) # 80003868 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004caa:	fb040593          	addi	a1,s0,-80
    80004cae:	f3040513          	addi	a0,s0,-208
    80004cb2:	fffff097          	auipc	ra,0xfffff
    80004cb6:	9b4080e7          	jalr	-1612(ra) # 80003666 <nameiparent>
    80004cba:	84aa                	mv	s1,a0
    80004cbc:	c979                	beqz	a0,80004d92 <sys_unlink+0x114>
  ilock(dp);
    80004cbe:	ffffe097          	auipc	ra,0xffffe
    80004cc2:	1ca080e7          	jalr	458(ra) # 80002e88 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004cc6:	00004597          	auipc	a1,0x4
    80004cca:	9c258593          	addi	a1,a1,-1598 # 80008688 <syscalls+0x2b8>
    80004cce:	fb040513          	addi	a0,s0,-80
    80004cd2:	ffffe097          	auipc	ra,0xffffe
    80004cd6:	694080e7          	jalr	1684(ra) # 80003366 <namecmp>
    80004cda:	14050a63          	beqz	a0,80004e2e <sys_unlink+0x1b0>
    80004cde:	00004597          	auipc	a1,0x4
    80004ce2:	9b258593          	addi	a1,a1,-1614 # 80008690 <syscalls+0x2c0>
    80004ce6:	fb040513          	addi	a0,s0,-80
    80004cea:	ffffe097          	auipc	ra,0xffffe
    80004cee:	67c080e7          	jalr	1660(ra) # 80003366 <namecmp>
    80004cf2:	12050e63          	beqz	a0,80004e2e <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004cf6:	f2c40613          	addi	a2,s0,-212
    80004cfa:	fb040593          	addi	a1,s0,-80
    80004cfe:	8526                	mv	a0,s1
    80004d00:	ffffe097          	auipc	ra,0xffffe
    80004d04:	680080e7          	jalr	1664(ra) # 80003380 <dirlookup>
    80004d08:	892a                	mv	s2,a0
    80004d0a:	12050263          	beqz	a0,80004e2e <sys_unlink+0x1b0>
  ilock(ip);
    80004d0e:	ffffe097          	auipc	ra,0xffffe
    80004d12:	17a080e7          	jalr	378(ra) # 80002e88 <ilock>
  if(ip->nlink < 1)
    80004d16:	05291783          	lh	a5,82(s2)
    80004d1a:	08f05263          	blez	a5,80004d9e <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004d1e:	04c91703          	lh	a4,76(s2)
    80004d22:	4785                	li	a5,1
    80004d24:	08f70563          	beq	a4,a5,80004dae <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004d28:	4641                	li	a2,16
    80004d2a:	4581                	li	a1,0
    80004d2c:	fc040513          	addi	a0,s0,-64
    80004d30:	ffffb097          	auipc	ra,0xffffb
    80004d34:	556080e7          	jalr	1366(ra) # 80000286 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d38:	4741                	li	a4,16
    80004d3a:	f2c42683          	lw	a3,-212(s0)
    80004d3e:	fc040613          	addi	a2,s0,-64
    80004d42:	4581                	li	a1,0
    80004d44:	8526                	mv	a0,s1
    80004d46:	ffffe097          	auipc	ra,0xffffe
    80004d4a:	502080e7          	jalr	1282(ra) # 80003248 <writei>
    80004d4e:	47c1                	li	a5,16
    80004d50:	0af51563          	bne	a0,a5,80004dfa <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004d54:	04c91703          	lh	a4,76(s2)
    80004d58:	4785                	li	a5,1
    80004d5a:	0af70863          	beq	a4,a5,80004e0a <sys_unlink+0x18c>
  iunlockput(dp);
    80004d5e:	8526                	mv	a0,s1
    80004d60:	ffffe097          	auipc	ra,0xffffe
    80004d64:	39e080e7          	jalr	926(ra) # 800030fe <iunlockput>
  ip->nlink--;
    80004d68:	05295783          	lhu	a5,82(s2)
    80004d6c:	37fd                	addiw	a5,a5,-1
    80004d6e:	04f91923          	sh	a5,82(s2)
  iupdate(ip);
    80004d72:	854a                	mv	a0,s2
    80004d74:	ffffe097          	auipc	ra,0xffffe
    80004d78:	048080e7          	jalr	72(ra) # 80002dbc <iupdate>
  iunlockput(ip);
    80004d7c:	854a                	mv	a0,s2
    80004d7e:	ffffe097          	auipc	ra,0xffffe
    80004d82:	380080e7          	jalr	896(ra) # 800030fe <iunlockput>
  end_op();
    80004d86:	fffff097          	auipc	ra,0xfffff
    80004d8a:	b60080e7          	jalr	-1184(ra) # 800038e6 <end_op>
  return 0;
    80004d8e:	4501                	li	a0,0
    80004d90:	a84d                	j	80004e42 <sys_unlink+0x1c4>
    end_op();
    80004d92:	fffff097          	auipc	ra,0xfffff
    80004d96:	b54080e7          	jalr	-1196(ra) # 800038e6 <end_op>
    return -1;
    80004d9a:	557d                	li	a0,-1
    80004d9c:	a05d                	j	80004e42 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004d9e:	00004517          	auipc	a0,0x4
    80004da2:	8fa50513          	addi	a0,a0,-1798 # 80008698 <syscalls+0x2c8>
    80004da6:	00001097          	auipc	ra,0x1
    80004daa:	4ea080e7          	jalr	1258(ra) # 80006290 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004dae:	05492703          	lw	a4,84(s2)
    80004db2:	02000793          	li	a5,32
    80004db6:	f6e7f9e3          	bgeu	a5,a4,80004d28 <sys_unlink+0xaa>
    80004dba:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004dbe:	4741                	li	a4,16
    80004dc0:	86ce                	mv	a3,s3
    80004dc2:	f1840613          	addi	a2,s0,-232
    80004dc6:	4581                	li	a1,0
    80004dc8:	854a                	mv	a0,s2
    80004dca:	ffffe097          	auipc	ra,0xffffe
    80004dce:	386080e7          	jalr	902(ra) # 80003150 <readi>
    80004dd2:	47c1                	li	a5,16
    80004dd4:	00f51b63          	bne	a0,a5,80004dea <sys_unlink+0x16c>
    if(de.inum != 0)
    80004dd8:	f1845783          	lhu	a5,-232(s0)
    80004ddc:	e7a1                	bnez	a5,80004e24 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004dde:	29c1                	addiw	s3,s3,16
    80004de0:	05492783          	lw	a5,84(s2)
    80004de4:	fcf9ede3          	bltu	s3,a5,80004dbe <sys_unlink+0x140>
    80004de8:	b781                	j	80004d28 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004dea:	00004517          	auipc	a0,0x4
    80004dee:	8c650513          	addi	a0,a0,-1850 # 800086b0 <syscalls+0x2e0>
    80004df2:	00001097          	auipc	ra,0x1
    80004df6:	49e080e7          	jalr	1182(ra) # 80006290 <panic>
    panic("unlink: writei");
    80004dfa:	00004517          	auipc	a0,0x4
    80004dfe:	8ce50513          	addi	a0,a0,-1842 # 800086c8 <syscalls+0x2f8>
    80004e02:	00001097          	auipc	ra,0x1
    80004e06:	48e080e7          	jalr	1166(ra) # 80006290 <panic>
    dp->nlink--;
    80004e0a:	0524d783          	lhu	a5,82(s1)
    80004e0e:	37fd                	addiw	a5,a5,-1
    80004e10:	04f49923          	sh	a5,82(s1)
    iupdate(dp);
    80004e14:	8526                	mv	a0,s1
    80004e16:	ffffe097          	auipc	ra,0xffffe
    80004e1a:	fa6080e7          	jalr	-90(ra) # 80002dbc <iupdate>
    80004e1e:	b781                	j	80004d5e <sys_unlink+0xe0>
    return -1;
    80004e20:	557d                	li	a0,-1
    80004e22:	a005                	j	80004e42 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004e24:	854a                	mv	a0,s2
    80004e26:	ffffe097          	auipc	ra,0xffffe
    80004e2a:	2d8080e7          	jalr	728(ra) # 800030fe <iunlockput>
  iunlockput(dp);
    80004e2e:	8526                	mv	a0,s1
    80004e30:	ffffe097          	auipc	ra,0xffffe
    80004e34:	2ce080e7          	jalr	718(ra) # 800030fe <iunlockput>
  end_op();
    80004e38:	fffff097          	auipc	ra,0xfffff
    80004e3c:	aae080e7          	jalr	-1362(ra) # 800038e6 <end_op>
  return -1;
    80004e40:	557d                	li	a0,-1
}
    80004e42:	70ae                	ld	ra,232(sp)
    80004e44:	740e                	ld	s0,224(sp)
    80004e46:	64ee                	ld	s1,216(sp)
    80004e48:	694e                	ld	s2,208(sp)
    80004e4a:	69ae                	ld	s3,200(sp)
    80004e4c:	616d                	addi	sp,sp,240
    80004e4e:	8082                	ret

0000000080004e50 <sys_open>:

uint64
sys_open(void)
{
    80004e50:	7131                	addi	sp,sp,-192
    80004e52:	fd06                	sd	ra,184(sp)
    80004e54:	f922                	sd	s0,176(sp)
    80004e56:	f526                	sd	s1,168(sp)
    80004e58:	f14a                	sd	s2,160(sp)
    80004e5a:	ed4e                	sd	s3,152(sp)
    80004e5c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004e5e:	f4c40593          	addi	a1,s0,-180
    80004e62:	4505                	li	a0,1
    80004e64:	ffffd097          	auipc	ra,0xffffd
    80004e68:	222080e7          	jalr	546(ra) # 80002086 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004e6c:	08000613          	li	a2,128
    80004e70:	f5040593          	addi	a1,s0,-176
    80004e74:	4501                	li	a0,0
    80004e76:	ffffd097          	auipc	ra,0xffffd
    80004e7a:	250080e7          	jalr	592(ra) # 800020c6 <argstr>
    80004e7e:	87aa                	mv	a5,a0
    return -1;
    80004e80:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004e82:	0a07c963          	bltz	a5,80004f34 <sys_open+0xe4>

  begin_op();
    80004e86:	fffff097          	auipc	ra,0xfffff
    80004e8a:	9e2080e7          	jalr	-1566(ra) # 80003868 <begin_op>

  if(omode & O_CREATE){
    80004e8e:	f4c42783          	lw	a5,-180(s0)
    80004e92:	2007f793          	andi	a5,a5,512
    80004e96:	cfc5                	beqz	a5,80004f4e <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004e98:	4681                	li	a3,0
    80004e9a:	4601                	li	a2,0
    80004e9c:	4589                	li	a1,2
    80004e9e:	f5040513          	addi	a0,s0,-176
    80004ea2:	00000097          	auipc	ra,0x0
    80004ea6:	972080e7          	jalr	-1678(ra) # 80004814 <create>
    80004eaa:	84aa                	mv	s1,a0
    if(ip == 0){
    80004eac:	c959                	beqz	a0,80004f42 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004eae:	04c49703          	lh	a4,76(s1)
    80004eb2:	478d                	li	a5,3
    80004eb4:	00f71763          	bne	a4,a5,80004ec2 <sys_open+0x72>
    80004eb8:	04e4d703          	lhu	a4,78(s1)
    80004ebc:	47a5                	li	a5,9
    80004ebe:	0ce7ed63          	bltu	a5,a4,80004f98 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004ec2:	fffff097          	auipc	ra,0xfffff
    80004ec6:	db2080e7          	jalr	-590(ra) # 80003c74 <filealloc>
    80004eca:	89aa                	mv	s3,a0
    80004ecc:	10050363          	beqz	a0,80004fd2 <sys_open+0x182>
    80004ed0:	00000097          	auipc	ra,0x0
    80004ed4:	902080e7          	jalr	-1790(ra) # 800047d2 <fdalloc>
    80004ed8:	892a                	mv	s2,a0
    80004eda:	0e054763          	bltz	a0,80004fc8 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004ede:	04c49703          	lh	a4,76(s1)
    80004ee2:	478d                	li	a5,3
    80004ee4:	0cf70563          	beq	a4,a5,80004fae <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004ee8:	4789                	li	a5,2
    80004eea:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004eee:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004ef2:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004ef6:	f4c42783          	lw	a5,-180(s0)
    80004efa:	0017c713          	xori	a4,a5,1
    80004efe:	8b05                	andi	a4,a4,1
    80004f00:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004f04:	0037f713          	andi	a4,a5,3
    80004f08:	00e03733          	snez	a4,a4
    80004f0c:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004f10:	4007f793          	andi	a5,a5,1024
    80004f14:	c791                	beqz	a5,80004f20 <sys_open+0xd0>
    80004f16:	04c49703          	lh	a4,76(s1)
    80004f1a:	4789                	li	a5,2
    80004f1c:	0af70063          	beq	a4,a5,80004fbc <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004f20:	8526                	mv	a0,s1
    80004f22:	ffffe097          	auipc	ra,0xffffe
    80004f26:	032080e7          	jalr	50(ra) # 80002f54 <iunlock>
  end_op();
    80004f2a:	fffff097          	auipc	ra,0xfffff
    80004f2e:	9bc080e7          	jalr	-1604(ra) # 800038e6 <end_op>

  return fd;
    80004f32:	854a                	mv	a0,s2
}
    80004f34:	70ea                	ld	ra,184(sp)
    80004f36:	744a                	ld	s0,176(sp)
    80004f38:	74aa                	ld	s1,168(sp)
    80004f3a:	790a                	ld	s2,160(sp)
    80004f3c:	69ea                	ld	s3,152(sp)
    80004f3e:	6129                	addi	sp,sp,192
    80004f40:	8082                	ret
      end_op();
    80004f42:	fffff097          	auipc	ra,0xfffff
    80004f46:	9a4080e7          	jalr	-1628(ra) # 800038e6 <end_op>
      return -1;
    80004f4a:	557d                	li	a0,-1
    80004f4c:	b7e5                	j	80004f34 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004f4e:	f5040513          	addi	a0,s0,-176
    80004f52:	ffffe097          	auipc	ra,0xffffe
    80004f56:	6f6080e7          	jalr	1782(ra) # 80003648 <namei>
    80004f5a:	84aa                	mv	s1,a0
    80004f5c:	c905                	beqz	a0,80004f8c <sys_open+0x13c>
    ilock(ip);
    80004f5e:	ffffe097          	auipc	ra,0xffffe
    80004f62:	f2a080e7          	jalr	-214(ra) # 80002e88 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004f66:	04c49703          	lh	a4,76(s1)
    80004f6a:	4785                	li	a5,1
    80004f6c:	f4f711e3          	bne	a4,a5,80004eae <sys_open+0x5e>
    80004f70:	f4c42783          	lw	a5,-180(s0)
    80004f74:	d7b9                	beqz	a5,80004ec2 <sys_open+0x72>
      iunlockput(ip);
    80004f76:	8526                	mv	a0,s1
    80004f78:	ffffe097          	auipc	ra,0xffffe
    80004f7c:	186080e7          	jalr	390(ra) # 800030fe <iunlockput>
      end_op();
    80004f80:	fffff097          	auipc	ra,0xfffff
    80004f84:	966080e7          	jalr	-1690(ra) # 800038e6 <end_op>
      return -1;
    80004f88:	557d                	li	a0,-1
    80004f8a:	b76d                	j	80004f34 <sys_open+0xe4>
      end_op();
    80004f8c:	fffff097          	auipc	ra,0xfffff
    80004f90:	95a080e7          	jalr	-1702(ra) # 800038e6 <end_op>
      return -1;
    80004f94:	557d                	li	a0,-1
    80004f96:	bf79                	j	80004f34 <sys_open+0xe4>
    iunlockput(ip);
    80004f98:	8526                	mv	a0,s1
    80004f9a:	ffffe097          	auipc	ra,0xffffe
    80004f9e:	164080e7          	jalr	356(ra) # 800030fe <iunlockput>
    end_op();
    80004fa2:	fffff097          	auipc	ra,0xfffff
    80004fa6:	944080e7          	jalr	-1724(ra) # 800038e6 <end_op>
    return -1;
    80004faa:	557d                	li	a0,-1
    80004fac:	b761                	j	80004f34 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004fae:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004fb2:	04e49783          	lh	a5,78(s1)
    80004fb6:	02f99223          	sh	a5,36(s3)
    80004fba:	bf25                	j	80004ef2 <sys_open+0xa2>
    itrunc(ip);
    80004fbc:	8526                	mv	a0,s1
    80004fbe:	ffffe097          	auipc	ra,0xffffe
    80004fc2:	fec080e7          	jalr	-20(ra) # 80002faa <itrunc>
    80004fc6:	bfa9                	j	80004f20 <sys_open+0xd0>
      fileclose(f);
    80004fc8:	854e                	mv	a0,s3
    80004fca:	fffff097          	auipc	ra,0xfffff
    80004fce:	d66080e7          	jalr	-666(ra) # 80003d30 <fileclose>
    iunlockput(ip);
    80004fd2:	8526                	mv	a0,s1
    80004fd4:	ffffe097          	auipc	ra,0xffffe
    80004fd8:	12a080e7          	jalr	298(ra) # 800030fe <iunlockput>
    end_op();
    80004fdc:	fffff097          	auipc	ra,0xfffff
    80004fe0:	90a080e7          	jalr	-1782(ra) # 800038e6 <end_op>
    return -1;
    80004fe4:	557d                	li	a0,-1
    80004fe6:	b7b9                	j	80004f34 <sys_open+0xe4>

0000000080004fe8 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004fe8:	7175                	addi	sp,sp,-144
    80004fea:	e506                	sd	ra,136(sp)
    80004fec:	e122                	sd	s0,128(sp)
    80004fee:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004ff0:	fffff097          	auipc	ra,0xfffff
    80004ff4:	878080e7          	jalr	-1928(ra) # 80003868 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004ff8:	08000613          	li	a2,128
    80004ffc:	f7040593          	addi	a1,s0,-144
    80005000:	4501                	li	a0,0
    80005002:	ffffd097          	auipc	ra,0xffffd
    80005006:	0c4080e7          	jalr	196(ra) # 800020c6 <argstr>
    8000500a:	02054963          	bltz	a0,8000503c <sys_mkdir+0x54>
    8000500e:	4681                	li	a3,0
    80005010:	4601                	li	a2,0
    80005012:	4585                	li	a1,1
    80005014:	f7040513          	addi	a0,s0,-144
    80005018:	fffff097          	auipc	ra,0xfffff
    8000501c:	7fc080e7          	jalr	2044(ra) # 80004814 <create>
    80005020:	cd11                	beqz	a0,8000503c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005022:	ffffe097          	auipc	ra,0xffffe
    80005026:	0dc080e7          	jalr	220(ra) # 800030fe <iunlockput>
  end_op();
    8000502a:	fffff097          	auipc	ra,0xfffff
    8000502e:	8bc080e7          	jalr	-1860(ra) # 800038e6 <end_op>
  return 0;
    80005032:	4501                	li	a0,0
}
    80005034:	60aa                	ld	ra,136(sp)
    80005036:	640a                	ld	s0,128(sp)
    80005038:	6149                	addi	sp,sp,144
    8000503a:	8082                	ret
    end_op();
    8000503c:	fffff097          	auipc	ra,0xfffff
    80005040:	8aa080e7          	jalr	-1878(ra) # 800038e6 <end_op>
    return -1;
    80005044:	557d                	li	a0,-1
    80005046:	b7fd                	j	80005034 <sys_mkdir+0x4c>

0000000080005048 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005048:	7135                	addi	sp,sp,-160
    8000504a:	ed06                	sd	ra,152(sp)
    8000504c:	e922                	sd	s0,144(sp)
    8000504e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005050:	fffff097          	auipc	ra,0xfffff
    80005054:	818080e7          	jalr	-2024(ra) # 80003868 <begin_op>
  argint(1, &major);
    80005058:	f6c40593          	addi	a1,s0,-148
    8000505c:	4505                	li	a0,1
    8000505e:	ffffd097          	auipc	ra,0xffffd
    80005062:	028080e7          	jalr	40(ra) # 80002086 <argint>
  argint(2, &minor);
    80005066:	f6840593          	addi	a1,s0,-152
    8000506a:	4509                	li	a0,2
    8000506c:	ffffd097          	auipc	ra,0xffffd
    80005070:	01a080e7          	jalr	26(ra) # 80002086 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005074:	08000613          	li	a2,128
    80005078:	f7040593          	addi	a1,s0,-144
    8000507c:	4501                	li	a0,0
    8000507e:	ffffd097          	auipc	ra,0xffffd
    80005082:	048080e7          	jalr	72(ra) # 800020c6 <argstr>
    80005086:	02054b63          	bltz	a0,800050bc <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000508a:	f6841683          	lh	a3,-152(s0)
    8000508e:	f6c41603          	lh	a2,-148(s0)
    80005092:	458d                	li	a1,3
    80005094:	f7040513          	addi	a0,s0,-144
    80005098:	fffff097          	auipc	ra,0xfffff
    8000509c:	77c080e7          	jalr	1916(ra) # 80004814 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800050a0:	cd11                	beqz	a0,800050bc <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800050a2:	ffffe097          	auipc	ra,0xffffe
    800050a6:	05c080e7          	jalr	92(ra) # 800030fe <iunlockput>
  end_op();
    800050aa:	fffff097          	auipc	ra,0xfffff
    800050ae:	83c080e7          	jalr	-1988(ra) # 800038e6 <end_op>
  return 0;
    800050b2:	4501                	li	a0,0
}
    800050b4:	60ea                	ld	ra,152(sp)
    800050b6:	644a                	ld	s0,144(sp)
    800050b8:	610d                	addi	sp,sp,160
    800050ba:	8082                	ret
    end_op();
    800050bc:	fffff097          	auipc	ra,0xfffff
    800050c0:	82a080e7          	jalr	-2006(ra) # 800038e6 <end_op>
    return -1;
    800050c4:	557d                	li	a0,-1
    800050c6:	b7fd                	j	800050b4 <sys_mknod+0x6c>

00000000800050c8 <sys_chdir>:

uint64
sys_chdir(void)
{
    800050c8:	7135                	addi	sp,sp,-160
    800050ca:	ed06                	sd	ra,152(sp)
    800050cc:	e922                	sd	s0,144(sp)
    800050ce:	e526                	sd	s1,136(sp)
    800050d0:	e14a                	sd	s2,128(sp)
    800050d2:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800050d4:	ffffc097          	auipc	ra,0xffffc
    800050d8:	e9c080e7          	jalr	-356(ra) # 80000f70 <myproc>
    800050dc:	892a                	mv	s2,a0
  
  begin_op();
    800050de:	ffffe097          	auipc	ra,0xffffe
    800050e2:	78a080e7          	jalr	1930(ra) # 80003868 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800050e6:	08000613          	li	a2,128
    800050ea:	f6040593          	addi	a1,s0,-160
    800050ee:	4501                	li	a0,0
    800050f0:	ffffd097          	auipc	ra,0xffffd
    800050f4:	fd6080e7          	jalr	-42(ra) # 800020c6 <argstr>
    800050f8:	04054b63          	bltz	a0,8000514e <sys_chdir+0x86>
    800050fc:	f6040513          	addi	a0,s0,-160
    80005100:	ffffe097          	auipc	ra,0xffffe
    80005104:	548080e7          	jalr	1352(ra) # 80003648 <namei>
    80005108:	84aa                	mv	s1,a0
    8000510a:	c131                	beqz	a0,8000514e <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    8000510c:	ffffe097          	auipc	ra,0xffffe
    80005110:	d7c080e7          	jalr	-644(ra) # 80002e88 <ilock>
  if(ip->type != T_DIR){
    80005114:	04c49703          	lh	a4,76(s1)
    80005118:	4785                	li	a5,1
    8000511a:	04f71063          	bne	a4,a5,8000515a <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000511e:	8526                	mv	a0,s1
    80005120:	ffffe097          	auipc	ra,0xffffe
    80005124:	e34080e7          	jalr	-460(ra) # 80002f54 <iunlock>
  iput(p->cwd);
    80005128:	15893503          	ld	a0,344(s2)
    8000512c:	ffffe097          	auipc	ra,0xffffe
    80005130:	f2a080e7          	jalr	-214(ra) # 80003056 <iput>
  end_op();
    80005134:	ffffe097          	auipc	ra,0xffffe
    80005138:	7b2080e7          	jalr	1970(ra) # 800038e6 <end_op>
  p->cwd = ip;
    8000513c:	14993c23          	sd	s1,344(s2)
  return 0;
    80005140:	4501                	li	a0,0
}
    80005142:	60ea                	ld	ra,152(sp)
    80005144:	644a                	ld	s0,144(sp)
    80005146:	64aa                	ld	s1,136(sp)
    80005148:	690a                	ld	s2,128(sp)
    8000514a:	610d                	addi	sp,sp,160
    8000514c:	8082                	ret
    end_op();
    8000514e:	ffffe097          	auipc	ra,0xffffe
    80005152:	798080e7          	jalr	1944(ra) # 800038e6 <end_op>
    return -1;
    80005156:	557d                	li	a0,-1
    80005158:	b7ed                	j	80005142 <sys_chdir+0x7a>
    iunlockput(ip);
    8000515a:	8526                	mv	a0,s1
    8000515c:	ffffe097          	auipc	ra,0xffffe
    80005160:	fa2080e7          	jalr	-94(ra) # 800030fe <iunlockput>
    end_op();
    80005164:	ffffe097          	auipc	ra,0xffffe
    80005168:	782080e7          	jalr	1922(ra) # 800038e6 <end_op>
    return -1;
    8000516c:	557d                	li	a0,-1
    8000516e:	bfd1                	j	80005142 <sys_chdir+0x7a>

0000000080005170 <sys_exec>:

uint64
sys_exec(void)
{
    80005170:	7145                	addi	sp,sp,-464
    80005172:	e786                	sd	ra,456(sp)
    80005174:	e3a2                	sd	s0,448(sp)
    80005176:	ff26                	sd	s1,440(sp)
    80005178:	fb4a                	sd	s2,432(sp)
    8000517a:	f74e                	sd	s3,424(sp)
    8000517c:	f352                	sd	s4,416(sp)
    8000517e:	ef56                	sd	s5,408(sp)
    80005180:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005182:	e3840593          	addi	a1,s0,-456
    80005186:	4505                	li	a0,1
    80005188:	ffffd097          	auipc	ra,0xffffd
    8000518c:	f1e080e7          	jalr	-226(ra) # 800020a6 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005190:	08000613          	li	a2,128
    80005194:	f4040593          	addi	a1,s0,-192
    80005198:	4501                	li	a0,0
    8000519a:	ffffd097          	auipc	ra,0xffffd
    8000519e:	f2c080e7          	jalr	-212(ra) # 800020c6 <argstr>
    800051a2:	87aa                	mv	a5,a0
    return -1;
    800051a4:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800051a6:	0c07c363          	bltz	a5,8000526c <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    800051aa:	10000613          	li	a2,256
    800051ae:	4581                	li	a1,0
    800051b0:	e4040513          	addi	a0,s0,-448
    800051b4:	ffffb097          	auipc	ra,0xffffb
    800051b8:	0d2080e7          	jalr	210(ra) # 80000286 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800051bc:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    800051c0:	89a6                	mv	s3,s1
    800051c2:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800051c4:	02000a13          	li	s4,32
    800051c8:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800051cc:	00391513          	slli	a0,s2,0x3
    800051d0:	e3040593          	addi	a1,s0,-464
    800051d4:	e3843783          	ld	a5,-456(s0)
    800051d8:	953e                	add	a0,a0,a5
    800051da:	ffffd097          	auipc	ra,0xffffd
    800051de:	e0e080e7          	jalr	-498(ra) # 80001fe8 <fetchaddr>
    800051e2:	02054a63          	bltz	a0,80005216 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    800051e6:	e3043783          	ld	a5,-464(s0)
    800051ea:	c3b9                	beqz	a5,80005230 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800051ec:	ffffb097          	auipc	ra,0xffffb
    800051f0:	f96080e7          	jalr	-106(ra) # 80000182 <kalloc>
    800051f4:	85aa                	mv	a1,a0
    800051f6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800051fa:	cd11                	beqz	a0,80005216 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800051fc:	6605                	lui	a2,0x1
    800051fe:	e3043503          	ld	a0,-464(s0)
    80005202:	ffffd097          	auipc	ra,0xffffd
    80005206:	e38080e7          	jalr	-456(ra) # 8000203a <fetchstr>
    8000520a:	00054663          	bltz	a0,80005216 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    8000520e:	0905                	addi	s2,s2,1
    80005210:	09a1                	addi	s3,s3,8
    80005212:	fb491be3          	bne	s2,s4,800051c8 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005216:	f4040913          	addi	s2,s0,-192
    8000521a:	6088                	ld	a0,0(s1)
    8000521c:	c539                	beqz	a0,8000526a <sys_exec+0xfa>
    kfree(argv[i]);
    8000521e:	ffffb097          	auipc	ra,0xffffb
    80005222:	dfe080e7          	jalr	-514(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005226:	04a1                	addi	s1,s1,8
    80005228:	ff2499e3          	bne	s1,s2,8000521a <sys_exec+0xaa>
  return -1;
    8000522c:	557d                	li	a0,-1
    8000522e:	a83d                	j	8000526c <sys_exec+0xfc>
      argv[i] = 0;
    80005230:	0a8e                	slli	s5,s5,0x3
    80005232:	fc0a8793          	addi	a5,s5,-64
    80005236:	00878ab3          	add	s5,a5,s0
    8000523a:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000523e:	e4040593          	addi	a1,s0,-448
    80005242:	f4040513          	addi	a0,s0,-192
    80005246:	fffff097          	auipc	ra,0xfffff
    8000524a:	16e080e7          	jalr	366(ra) # 800043b4 <exec>
    8000524e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005250:	f4040993          	addi	s3,s0,-192
    80005254:	6088                	ld	a0,0(s1)
    80005256:	c901                	beqz	a0,80005266 <sys_exec+0xf6>
    kfree(argv[i]);
    80005258:	ffffb097          	auipc	ra,0xffffb
    8000525c:	dc4080e7          	jalr	-572(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005260:	04a1                	addi	s1,s1,8
    80005262:	ff3499e3          	bne	s1,s3,80005254 <sys_exec+0xe4>
  return ret;
    80005266:	854a                	mv	a0,s2
    80005268:	a011                	j	8000526c <sys_exec+0xfc>
  return -1;
    8000526a:	557d                	li	a0,-1
}
    8000526c:	60be                	ld	ra,456(sp)
    8000526e:	641e                	ld	s0,448(sp)
    80005270:	74fa                	ld	s1,440(sp)
    80005272:	795a                	ld	s2,432(sp)
    80005274:	79ba                	ld	s3,424(sp)
    80005276:	7a1a                	ld	s4,416(sp)
    80005278:	6afa                	ld	s5,408(sp)
    8000527a:	6179                	addi	sp,sp,464
    8000527c:	8082                	ret

000000008000527e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000527e:	7139                	addi	sp,sp,-64
    80005280:	fc06                	sd	ra,56(sp)
    80005282:	f822                	sd	s0,48(sp)
    80005284:	f426                	sd	s1,40(sp)
    80005286:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005288:	ffffc097          	auipc	ra,0xffffc
    8000528c:	ce8080e7          	jalr	-792(ra) # 80000f70 <myproc>
    80005290:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005292:	fd840593          	addi	a1,s0,-40
    80005296:	4501                	li	a0,0
    80005298:	ffffd097          	auipc	ra,0xffffd
    8000529c:	e0e080e7          	jalr	-498(ra) # 800020a6 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800052a0:	fc840593          	addi	a1,s0,-56
    800052a4:	fd040513          	addi	a0,s0,-48
    800052a8:	fffff097          	auipc	ra,0xfffff
    800052ac:	db8080e7          	jalr	-584(ra) # 80004060 <pipealloc>
    return -1;
    800052b0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800052b2:	0c054463          	bltz	a0,8000537a <sys_pipe+0xfc>
  fd0 = -1;
    800052b6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800052ba:	fd043503          	ld	a0,-48(s0)
    800052be:	fffff097          	auipc	ra,0xfffff
    800052c2:	514080e7          	jalr	1300(ra) # 800047d2 <fdalloc>
    800052c6:	fca42223          	sw	a0,-60(s0)
    800052ca:	08054b63          	bltz	a0,80005360 <sys_pipe+0xe2>
    800052ce:	fc843503          	ld	a0,-56(s0)
    800052d2:	fffff097          	auipc	ra,0xfffff
    800052d6:	500080e7          	jalr	1280(ra) # 800047d2 <fdalloc>
    800052da:	fca42023          	sw	a0,-64(s0)
    800052de:	06054863          	bltz	a0,8000534e <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800052e2:	4691                	li	a3,4
    800052e4:	fc440613          	addi	a2,s0,-60
    800052e8:	fd843583          	ld	a1,-40(s0)
    800052ec:	6ca8                	ld	a0,88(s1)
    800052ee:	ffffc097          	auipc	ra,0xffffc
    800052f2:	942080e7          	jalr	-1726(ra) # 80000c30 <copyout>
    800052f6:	02054063          	bltz	a0,80005316 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800052fa:	4691                	li	a3,4
    800052fc:	fc040613          	addi	a2,s0,-64
    80005300:	fd843583          	ld	a1,-40(s0)
    80005304:	0591                	addi	a1,a1,4
    80005306:	6ca8                	ld	a0,88(s1)
    80005308:	ffffc097          	auipc	ra,0xffffc
    8000530c:	928080e7          	jalr	-1752(ra) # 80000c30 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005310:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005312:	06055463          	bgez	a0,8000537a <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005316:	fc442783          	lw	a5,-60(s0)
    8000531a:	07e9                	addi	a5,a5,26
    8000531c:	078e                	slli	a5,a5,0x3
    8000531e:	97a6                	add	a5,a5,s1
    80005320:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005324:	fc042783          	lw	a5,-64(s0)
    80005328:	07e9                	addi	a5,a5,26
    8000532a:	078e                	slli	a5,a5,0x3
    8000532c:	94be                	add	s1,s1,a5
    8000532e:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80005332:	fd043503          	ld	a0,-48(s0)
    80005336:	fffff097          	auipc	ra,0xfffff
    8000533a:	9fa080e7          	jalr	-1542(ra) # 80003d30 <fileclose>
    fileclose(wf);
    8000533e:	fc843503          	ld	a0,-56(s0)
    80005342:	fffff097          	auipc	ra,0xfffff
    80005346:	9ee080e7          	jalr	-1554(ra) # 80003d30 <fileclose>
    return -1;
    8000534a:	57fd                	li	a5,-1
    8000534c:	a03d                	j	8000537a <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000534e:	fc442783          	lw	a5,-60(s0)
    80005352:	0007c763          	bltz	a5,80005360 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005356:	07e9                	addi	a5,a5,26
    80005358:	078e                	slli	a5,a5,0x3
    8000535a:	97a6                	add	a5,a5,s1
    8000535c:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80005360:	fd043503          	ld	a0,-48(s0)
    80005364:	fffff097          	auipc	ra,0xfffff
    80005368:	9cc080e7          	jalr	-1588(ra) # 80003d30 <fileclose>
    fileclose(wf);
    8000536c:	fc843503          	ld	a0,-56(s0)
    80005370:	fffff097          	auipc	ra,0xfffff
    80005374:	9c0080e7          	jalr	-1600(ra) # 80003d30 <fileclose>
    return -1;
    80005378:	57fd                	li	a5,-1
}
    8000537a:	853e                	mv	a0,a5
    8000537c:	70e2                	ld	ra,56(sp)
    8000537e:	7442                	ld	s0,48(sp)
    80005380:	74a2                	ld	s1,40(sp)
    80005382:	6121                	addi	sp,sp,64
    80005384:	8082                	ret
	...

0000000080005390 <kernelvec>:
    80005390:	7111                	addi	sp,sp,-256
    80005392:	e006                	sd	ra,0(sp)
    80005394:	e40a                	sd	sp,8(sp)
    80005396:	e80e                	sd	gp,16(sp)
    80005398:	ec12                	sd	tp,24(sp)
    8000539a:	f016                	sd	t0,32(sp)
    8000539c:	f41a                	sd	t1,40(sp)
    8000539e:	f81e                	sd	t2,48(sp)
    800053a0:	fc22                	sd	s0,56(sp)
    800053a2:	e0a6                	sd	s1,64(sp)
    800053a4:	e4aa                	sd	a0,72(sp)
    800053a6:	e8ae                	sd	a1,80(sp)
    800053a8:	ecb2                	sd	a2,88(sp)
    800053aa:	f0b6                	sd	a3,96(sp)
    800053ac:	f4ba                	sd	a4,104(sp)
    800053ae:	f8be                	sd	a5,112(sp)
    800053b0:	fcc2                	sd	a6,120(sp)
    800053b2:	e146                	sd	a7,128(sp)
    800053b4:	e54a                	sd	s2,136(sp)
    800053b6:	e94e                	sd	s3,144(sp)
    800053b8:	ed52                	sd	s4,152(sp)
    800053ba:	f156                	sd	s5,160(sp)
    800053bc:	f55a                	sd	s6,168(sp)
    800053be:	f95e                	sd	s7,176(sp)
    800053c0:	fd62                	sd	s8,184(sp)
    800053c2:	e1e6                	sd	s9,192(sp)
    800053c4:	e5ea                	sd	s10,200(sp)
    800053c6:	e9ee                	sd	s11,208(sp)
    800053c8:	edf2                	sd	t3,216(sp)
    800053ca:	f1f6                	sd	t4,224(sp)
    800053cc:	f5fa                	sd	t5,232(sp)
    800053ce:	f9fe                	sd	t6,240(sp)
    800053d0:	ae5fc0ef          	jal	ra,80001eb4 <kerneltrap>
    800053d4:	6082                	ld	ra,0(sp)
    800053d6:	6122                	ld	sp,8(sp)
    800053d8:	61c2                	ld	gp,16(sp)
    800053da:	7282                	ld	t0,32(sp)
    800053dc:	7322                	ld	t1,40(sp)
    800053de:	73c2                	ld	t2,48(sp)
    800053e0:	7462                	ld	s0,56(sp)
    800053e2:	6486                	ld	s1,64(sp)
    800053e4:	6526                	ld	a0,72(sp)
    800053e6:	65c6                	ld	a1,80(sp)
    800053e8:	6666                	ld	a2,88(sp)
    800053ea:	7686                	ld	a3,96(sp)
    800053ec:	7726                	ld	a4,104(sp)
    800053ee:	77c6                	ld	a5,112(sp)
    800053f0:	7866                	ld	a6,120(sp)
    800053f2:	688a                	ld	a7,128(sp)
    800053f4:	692a                	ld	s2,136(sp)
    800053f6:	69ca                	ld	s3,144(sp)
    800053f8:	6a6a                	ld	s4,152(sp)
    800053fa:	7a8a                	ld	s5,160(sp)
    800053fc:	7b2a                	ld	s6,168(sp)
    800053fe:	7bca                	ld	s7,176(sp)
    80005400:	7c6a                	ld	s8,184(sp)
    80005402:	6c8e                	ld	s9,192(sp)
    80005404:	6d2e                	ld	s10,200(sp)
    80005406:	6dce                	ld	s11,208(sp)
    80005408:	6e6e                	ld	t3,216(sp)
    8000540a:	7e8e                	ld	t4,224(sp)
    8000540c:	7f2e                	ld	t5,232(sp)
    8000540e:	7fce                	ld	t6,240(sp)
    80005410:	6111                	addi	sp,sp,256
    80005412:	10200073          	sret
    80005416:	00000013          	nop
    8000541a:	00000013          	nop
    8000541e:	0001                	nop

0000000080005420 <timervec>:
    80005420:	34051573          	csrrw	a0,mscratch,a0
    80005424:	e10c                	sd	a1,0(a0)
    80005426:	e510                	sd	a2,8(a0)
    80005428:	e914                	sd	a3,16(a0)
    8000542a:	6d0c                	ld	a1,24(a0)
    8000542c:	7110                	ld	a2,32(a0)
    8000542e:	6194                	ld	a3,0(a1)
    80005430:	96b2                	add	a3,a3,a2
    80005432:	e194                	sd	a3,0(a1)
    80005434:	4589                	li	a1,2
    80005436:	14459073          	csrw	sip,a1
    8000543a:	6914                	ld	a3,16(a0)
    8000543c:	6510                	ld	a2,8(a0)
    8000543e:	610c                	ld	a1,0(a0)
    80005440:	34051573          	csrrw	a0,mscratch,a0
    80005444:	30200073          	mret
	...

000000008000544a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000544a:	1141                	addi	sp,sp,-16
    8000544c:	e422                	sd	s0,8(sp)
    8000544e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005450:	0c0007b7          	lui	a5,0xc000
    80005454:	4705                	li	a4,1
    80005456:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005458:	c3d8                	sw	a4,4(a5)
}
    8000545a:	6422                	ld	s0,8(sp)
    8000545c:	0141                	addi	sp,sp,16
    8000545e:	8082                	ret

0000000080005460 <plicinithart>:

void
plicinithart(void)
{
    80005460:	1141                	addi	sp,sp,-16
    80005462:	e406                	sd	ra,8(sp)
    80005464:	e022                	sd	s0,0(sp)
    80005466:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005468:	ffffc097          	auipc	ra,0xffffc
    8000546c:	adc080e7          	jalr	-1316(ra) # 80000f44 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005470:	0085171b          	slliw	a4,a0,0x8
    80005474:	0c0027b7          	lui	a5,0xc002
    80005478:	97ba                	add	a5,a5,a4
    8000547a:	40200713          	li	a4,1026
    8000547e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005482:	00d5151b          	slliw	a0,a0,0xd
    80005486:	0c2017b7          	lui	a5,0xc201
    8000548a:	97aa                	add	a5,a5,a0
    8000548c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005490:	60a2                	ld	ra,8(sp)
    80005492:	6402                	ld	s0,0(sp)
    80005494:	0141                	addi	sp,sp,16
    80005496:	8082                	ret

0000000080005498 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005498:	1141                	addi	sp,sp,-16
    8000549a:	e406                	sd	ra,8(sp)
    8000549c:	e022                	sd	s0,0(sp)
    8000549e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800054a0:	ffffc097          	auipc	ra,0xffffc
    800054a4:	aa4080e7          	jalr	-1372(ra) # 80000f44 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800054a8:	00d5151b          	slliw	a0,a0,0xd
    800054ac:	0c2017b7          	lui	a5,0xc201
    800054b0:	97aa                	add	a5,a5,a0
  return irq;
}
    800054b2:	43c8                	lw	a0,4(a5)
    800054b4:	60a2                	ld	ra,8(sp)
    800054b6:	6402                	ld	s0,0(sp)
    800054b8:	0141                	addi	sp,sp,16
    800054ba:	8082                	ret

00000000800054bc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800054bc:	1101                	addi	sp,sp,-32
    800054be:	ec06                	sd	ra,24(sp)
    800054c0:	e822                	sd	s0,16(sp)
    800054c2:	e426                	sd	s1,8(sp)
    800054c4:	1000                	addi	s0,sp,32
    800054c6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800054c8:	ffffc097          	auipc	ra,0xffffc
    800054cc:	a7c080e7          	jalr	-1412(ra) # 80000f44 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800054d0:	00d5151b          	slliw	a0,a0,0xd
    800054d4:	0c2017b7          	lui	a5,0xc201
    800054d8:	97aa                	add	a5,a5,a0
    800054da:	c3c4                	sw	s1,4(a5)
}
    800054dc:	60e2                	ld	ra,24(sp)
    800054de:	6442                	ld	s0,16(sp)
    800054e0:	64a2                	ld	s1,8(sp)
    800054e2:	6105                	addi	sp,sp,32
    800054e4:	8082                	ret

00000000800054e6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800054e6:	1141                	addi	sp,sp,-16
    800054e8:	e406                	sd	ra,8(sp)
    800054ea:	e022                	sd	s0,0(sp)
    800054ec:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800054ee:	479d                	li	a5,7
    800054f0:	04a7cc63          	blt	a5,a0,80005548 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800054f4:	00018797          	auipc	a5,0x18
    800054f8:	31478793          	addi	a5,a5,788 # 8001d808 <disk>
    800054fc:	97aa                	add	a5,a5,a0
    800054fe:	0187c783          	lbu	a5,24(a5)
    80005502:	ebb9                	bnez	a5,80005558 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005504:	00451693          	slli	a3,a0,0x4
    80005508:	00018797          	auipc	a5,0x18
    8000550c:	30078793          	addi	a5,a5,768 # 8001d808 <disk>
    80005510:	6398                	ld	a4,0(a5)
    80005512:	9736                	add	a4,a4,a3
    80005514:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005518:	6398                	ld	a4,0(a5)
    8000551a:	9736                	add	a4,a4,a3
    8000551c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005520:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005524:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005528:	97aa                	add	a5,a5,a0
    8000552a:	4705                	li	a4,1
    8000552c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005530:	00018517          	auipc	a0,0x18
    80005534:	2f050513          	addi	a0,a0,752 # 8001d820 <disk+0x18>
    80005538:	ffffc097          	auipc	ra,0xffffc
    8000553c:	144080e7          	jalr	324(ra) # 8000167c <wakeup>
}
    80005540:	60a2                	ld	ra,8(sp)
    80005542:	6402                	ld	s0,0(sp)
    80005544:	0141                	addi	sp,sp,16
    80005546:	8082                	ret
    panic("free_desc 1");
    80005548:	00003517          	auipc	a0,0x3
    8000554c:	19050513          	addi	a0,a0,400 # 800086d8 <syscalls+0x308>
    80005550:	00001097          	auipc	ra,0x1
    80005554:	d40080e7          	jalr	-704(ra) # 80006290 <panic>
    panic("free_desc 2");
    80005558:	00003517          	auipc	a0,0x3
    8000555c:	19050513          	addi	a0,a0,400 # 800086e8 <syscalls+0x318>
    80005560:	00001097          	auipc	ra,0x1
    80005564:	d30080e7          	jalr	-720(ra) # 80006290 <panic>

0000000080005568 <virtio_disk_init>:
{
    80005568:	1101                	addi	sp,sp,-32
    8000556a:	ec06                	sd	ra,24(sp)
    8000556c:	e822                	sd	s0,16(sp)
    8000556e:	e426                	sd	s1,8(sp)
    80005570:	e04a                	sd	s2,0(sp)
    80005572:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005574:	00003597          	auipc	a1,0x3
    80005578:	18458593          	addi	a1,a1,388 # 800086f8 <syscalls+0x328>
    8000557c:	00018517          	auipc	a0,0x18
    80005580:	3b450513          	addi	a0,a0,948 # 8001d930 <disk+0x128>
    80005584:	00001097          	auipc	ra,0x1
    80005588:	3aa080e7          	jalr	938(ra) # 8000692e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000558c:	100017b7          	lui	a5,0x10001
    80005590:	4398                	lw	a4,0(a5)
    80005592:	2701                	sext.w	a4,a4
    80005594:	747277b7          	lui	a5,0x74727
    80005598:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000559c:	14f71b63          	bne	a4,a5,800056f2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800055a0:	100017b7          	lui	a5,0x10001
    800055a4:	43dc                	lw	a5,4(a5)
    800055a6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055a8:	4709                	li	a4,2
    800055aa:	14e79463          	bne	a5,a4,800056f2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800055ae:	100017b7          	lui	a5,0x10001
    800055b2:	479c                	lw	a5,8(a5)
    800055b4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800055b6:	12e79e63          	bne	a5,a4,800056f2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800055ba:	100017b7          	lui	a5,0x10001
    800055be:	47d8                	lw	a4,12(a5)
    800055c0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800055c2:	554d47b7          	lui	a5,0x554d4
    800055c6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800055ca:	12f71463          	bne	a4,a5,800056f2 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800055ce:	100017b7          	lui	a5,0x10001
    800055d2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800055d6:	4705                	li	a4,1
    800055d8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055da:	470d                	li	a4,3
    800055dc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800055de:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800055e0:	c7ffe6b7          	lui	a3,0xc7ffe
    800055e4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd6bc7>
    800055e8:	8f75                	and	a4,a4,a3
    800055ea:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055ec:	472d                	li	a4,11
    800055ee:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800055f0:	5bbc                	lw	a5,112(a5)
    800055f2:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800055f6:	8ba1                	andi	a5,a5,8
    800055f8:	10078563          	beqz	a5,80005702 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800055fc:	100017b7          	lui	a5,0x10001
    80005600:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005604:	43fc                	lw	a5,68(a5)
    80005606:	2781                	sext.w	a5,a5
    80005608:	10079563          	bnez	a5,80005712 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000560c:	100017b7          	lui	a5,0x10001
    80005610:	5bdc                	lw	a5,52(a5)
    80005612:	2781                	sext.w	a5,a5
  if(max == 0)
    80005614:	10078763          	beqz	a5,80005722 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005618:	471d                	li	a4,7
    8000561a:	10f77c63          	bgeu	a4,a5,80005732 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000561e:	ffffb097          	auipc	ra,0xffffb
    80005622:	b64080e7          	jalr	-1180(ra) # 80000182 <kalloc>
    80005626:	00018497          	auipc	s1,0x18
    8000562a:	1e248493          	addi	s1,s1,482 # 8001d808 <disk>
    8000562e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005630:	ffffb097          	auipc	ra,0xffffb
    80005634:	b52080e7          	jalr	-1198(ra) # 80000182 <kalloc>
    80005638:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000563a:	ffffb097          	auipc	ra,0xffffb
    8000563e:	b48080e7          	jalr	-1208(ra) # 80000182 <kalloc>
    80005642:	87aa                	mv	a5,a0
    80005644:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005646:	6088                	ld	a0,0(s1)
    80005648:	cd6d                	beqz	a0,80005742 <virtio_disk_init+0x1da>
    8000564a:	00018717          	auipc	a4,0x18
    8000564e:	1c673703          	ld	a4,454(a4) # 8001d810 <disk+0x8>
    80005652:	cb65                	beqz	a4,80005742 <virtio_disk_init+0x1da>
    80005654:	c7fd                	beqz	a5,80005742 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005656:	6605                	lui	a2,0x1
    80005658:	4581                	li	a1,0
    8000565a:	ffffb097          	auipc	ra,0xffffb
    8000565e:	c2c080e7          	jalr	-980(ra) # 80000286 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005662:	00018497          	auipc	s1,0x18
    80005666:	1a648493          	addi	s1,s1,422 # 8001d808 <disk>
    8000566a:	6605                	lui	a2,0x1
    8000566c:	4581                	li	a1,0
    8000566e:	6488                	ld	a0,8(s1)
    80005670:	ffffb097          	auipc	ra,0xffffb
    80005674:	c16080e7          	jalr	-1002(ra) # 80000286 <memset>
  memset(disk.used, 0, PGSIZE);
    80005678:	6605                	lui	a2,0x1
    8000567a:	4581                	li	a1,0
    8000567c:	6888                	ld	a0,16(s1)
    8000567e:	ffffb097          	auipc	ra,0xffffb
    80005682:	c08080e7          	jalr	-1016(ra) # 80000286 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005686:	100017b7          	lui	a5,0x10001
    8000568a:	4721                	li	a4,8
    8000568c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000568e:	4098                	lw	a4,0(s1)
    80005690:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005694:	40d8                	lw	a4,4(s1)
    80005696:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000569a:	6498                	ld	a4,8(s1)
    8000569c:	0007069b          	sext.w	a3,a4
    800056a0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800056a4:	9701                	srai	a4,a4,0x20
    800056a6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800056aa:	6898                	ld	a4,16(s1)
    800056ac:	0007069b          	sext.w	a3,a4
    800056b0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800056b4:	9701                	srai	a4,a4,0x20
    800056b6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800056ba:	4705                	li	a4,1
    800056bc:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800056be:	00e48c23          	sb	a4,24(s1)
    800056c2:	00e48ca3          	sb	a4,25(s1)
    800056c6:	00e48d23          	sb	a4,26(s1)
    800056ca:	00e48da3          	sb	a4,27(s1)
    800056ce:	00e48e23          	sb	a4,28(s1)
    800056d2:	00e48ea3          	sb	a4,29(s1)
    800056d6:	00e48f23          	sb	a4,30(s1)
    800056da:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800056de:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800056e2:	0727a823          	sw	s2,112(a5)
}
    800056e6:	60e2                	ld	ra,24(sp)
    800056e8:	6442                	ld	s0,16(sp)
    800056ea:	64a2                	ld	s1,8(sp)
    800056ec:	6902                	ld	s2,0(sp)
    800056ee:	6105                	addi	sp,sp,32
    800056f0:	8082                	ret
    panic("could not find virtio disk");
    800056f2:	00003517          	auipc	a0,0x3
    800056f6:	01650513          	addi	a0,a0,22 # 80008708 <syscalls+0x338>
    800056fa:	00001097          	auipc	ra,0x1
    800056fe:	b96080e7          	jalr	-1130(ra) # 80006290 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005702:	00003517          	auipc	a0,0x3
    80005706:	02650513          	addi	a0,a0,38 # 80008728 <syscalls+0x358>
    8000570a:	00001097          	auipc	ra,0x1
    8000570e:	b86080e7          	jalr	-1146(ra) # 80006290 <panic>
    panic("virtio disk should not be ready");
    80005712:	00003517          	auipc	a0,0x3
    80005716:	03650513          	addi	a0,a0,54 # 80008748 <syscalls+0x378>
    8000571a:	00001097          	auipc	ra,0x1
    8000571e:	b76080e7          	jalr	-1162(ra) # 80006290 <panic>
    panic("virtio disk has no queue 0");
    80005722:	00003517          	auipc	a0,0x3
    80005726:	04650513          	addi	a0,a0,70 # 80008768 <syscalls+0x398>
    8000572a:	00001097          	auipc	ra,0x1
    8000572e:	b66080e7          	jalr	-1178(ra) # 80006290 <panic>
    panic("virtio disk max queue too short");
    80005732:	00003517          	auipc	a0,0x3
    80005736:	05650513          	addi	a0,a0,86 # 80008788 <syscalls+0x3b8>
    8000573a:	00001097          	auipc	ra,0x1
    8000573e:	b56080e7          	jalr	-1194(ra) # 80006290 <panic>
    panic("virtio disk kalloc");
    80005742:	00003517          	auipc	a0,0x3
    80005746:	06650513          	addi	a0,a0,102 # 800087a8 <syscalls+0x3d8>
    8000574a:	00001097          	auipc	ra,0x1
    8000574e:	b46080e7          	jalr	-1210(ra) # 80006290 <panic>

0000000080005752 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005752:	7119                	addi	sp,sp,-128
    80005754:	fc86                	sd	ra,120(sp)
    80005756:	f8a2                	sd	s0,112(sp)
    80005758:	f4a6                	sd	s1,104(sp)
    8000575a:	f0ca                	sd	s2,96(sp)
    8000575c:	ecce                	sd	s3,88(sp)
    8000575e:	e8d2                	sd	s4,80(sp)
    80005760:	e4d6                	sd	s5,72(sp)
    80005762:	e0da                	sd	s6,64(sp)
    80005764:	fc5e                	sd	s7,56(sp)
    80005766:	f862                	sd	s8,48(sp)
    80005768:	f466                	sd	s9,40(sp)
    8000576a:	f06a                	sd	s10,32(sp)
    8000576c:	ec6e                	sd	s11,24(sp)
    8000576e:	0100                	addi	s0,sp,128
    80005770:	8aaa                	mv	s5,a0
    80005772:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005774:	00c52d03          	lw	s10,12(a0)
    80005778:	001d1d1b          	slliw	s10,s10,0x1
    8000577c:	1d02                	slli	s10,s10,0x20
    8000577e:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80005782:	00018517          	auipc	a0,0x18
    80005786:	1ae50513          	addi	a0,a0,430 # 8001d930 <disk+0x128>
    8000578a:	00001097          	auipc	ra,0x1
    8000578e:	028080e7          	jalr	40(ra) # 800067b2 <acquire>
  for(int i = 0; i < 3; i++){
    80005792:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005794:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005796:	00018b97          	auipc	s7,0x18
    8000579a:	072b8b93          	addi	s7,s7,114 # 8001d808 <disk>
  for(int i = 0; i < 3; i++){
    8000579e:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800057a0:	00018c97          	auipc	s9,0x18
    800057a4:	190c8c93          	addi	s9,s9,400 # 8001d930 <disk+0x128>
    800057a8:	a08d                	j	8000580a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800057aa:	00fb8733          	add	a4,s7,a5
    800057ae:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800057b2:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800057b4:	0207c563          	bltz	a5,800057de <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800057b8:	2905                	addiw	s2,s2,1
    800057ba:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800057bc:	05690c63          	beq	s2,s6,80005814 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800057c0:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800057c2:	00018717          	auipc	a4,0x18
    800057c6:	04670713          	addi	a4,a4,70 # 8001d808 <disk>
    800057ca:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800057cc:	01874683          	lbu	a3,24(a4)
    800057d0:	fee9                	bnez	a3,800057aa <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800057d2:	2785                	addiw	a5,a5,1
    800057d4:	0705                	addi	a4,a4,1
    800057d6:	fe979be3          	bne	a5,s1,800057cc <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800057da:	57fd                	li	a5,-1
    800057dc:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800057de:	01205d63          	blez	s2,800057f8 <virtio_disk_rw+0xa6>
    800057e2:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800057e4:	000a2503          	lw	a0,0(s4)
    800057e8:	00000097          	auipc	ra,0x0
    800057ec:	cfe080e7          	jalr	-770(ra) # 800054e6 <free_desc>
      for(int j = 0; j < i; j++)
    800057f0:	2d85                	addiw	s11,s11,1
    800057f2:	0a11                	addi	s4,s4,4
    800057f4:	ff2d98e3          	bne	s11,s2,800057e4 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800057f8:	85e6                	mv	a1,s9
    800057fa:	00018517          	auipc	a0,0x18
    800057fe:	02650513          	addi	a0,a0,38 # 8001d820 <disk+0x18>
    80005802:	ffffc097          	auipc	ra,0xffffc
    80005806:	e16080e7          	jalr	-490(ra) # 80001618 <sleep>
  for(int i = 0; i < 3; i++){
    8000580a:	f8040a13          	addi	s4,s0,-128
{
    8000580e:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005810:	894e                	mv	s2,s3
    80005812:	b77d                	j	800057c0 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005814:	f8042503          	lw	a0,-128(s0)
    80005818:	00a50713          	addi	a4,a0,10
    8000581c:	0712                	slli	a4,a4,0x4

  if(write)
    8000581e:	00018797          	auipc	a5,0x18
    80005822:	fea78793          	addi	a5,a5,-22 # 8001d808 <disk>
    80005826:	00e786b3          	add	a3,a5,a4
    8000582a:	01803633          	snez	a2,s8
    8000582e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005830:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005834:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005838:	f6070613          	addi	a2,a4,-160
    8000583c:	6394                	ld	a3,0(a5)
    8000583e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005840:	00870593          	addi	a1,a4,8
    80005844:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005846:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005848:	0007b803          	ld	a6,0(a5)
    8000584c:	9642                	add	a2,a2,a6
    8000584e:	46c1                	li	a3,16
    80005850:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005852:	4585                	li	a1,1
    80005854:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005858:	f8442683          	lw	a3,-124(s0)
    8000585c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005860:	0692                	slli	a3,a3,0x4
    80005862:	9836                	add	a6,a6,a3
    80005864:	060a8613          	addi	a2,s5,96
    80005868:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000586c:	0007b803          	ld	a6,0(a5)
    80005870:	96c2                	add	a3,a3,a6
    80005872:	40000613          	li	a2,1024
    80005876:	c690                	sw	a2,8(a3)
  if(write)
    80005878:	001c3613          	seqz	a2,s8
    8000587c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005880:	00166613          	ori	a2,a2,1
    80005884:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005888:	f8842603          	lw	a2,-120(s0)
    8000588c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005890:	00250693          	addi	a3,a0,2
    80005894:	0692                	slli	a3,a3,0x4
    80005896:	96be                	add	a3,a3,a5
    80005898:	58fd                	li	a7,-1
    8000589a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000589e:	0612                	slli	a2,a2,0x4
    800058a0:	9832                	add	a6,a6,a2
    800058a2:	f9070713          	addi	a4,a4,-112
    800058a6:	973e                	add	a4,a4,a5
    800058a8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800058ac:	6398                	ld	a4,0(a5)
    800058ae:	9732                	add	a4,a4,a2
    800058b0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800058b2:	4609                	li	a2,2
    800058b4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800058b8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800058bc:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    800058c0:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800058c4:	6794                	ld	a3,8(a5)
    800058c6:	0026d703          	lhu	a4,2(a3)
    800058ca:	8b1d                	andi	a4,a4,7
    800058cc:	0706                	slli	a4,a4,0x1
    800058ce:	96ba                	add	a3,a3,a4
    800058d0:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800058d4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800058d8:	6798                	ld	a4,8(a5)
    800058da:	00275783          	lhu	a5,2(a4)
    800058de:	2785                	addiw	a5,a5,1
    800058e0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800058e4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800058e8:	100017b7          	lui	a5,0x10001
    800058ec:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800058f0:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    800058f4:	00018917          	auipc	s2,0x18
    800058f8:	03c90913          	addi	s2,s2,60 # 8001d930 <disk+0x128>
  while(b->disk == 1) {
    800058fc:	4485                	li	s1,1
    800058fe:	00b79c63          	bne	a5,a1,80005916 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005902:	85ca                	mv	a1,s2
    80005904:	8556                	mv	a0,s5
    80005906:	ffffc097          	auipc	ra,0xffffc
    8000590a:	d12080e7          	jalr	-750(ra) # 80001618 <sleep>
  while(b->disk == 1) {
    8000590e:	004aa783          	lw	a5,4(s5)
    80005912:	fe9788e3          	beq	a5,s1,80005902 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005916:	f8042903          	lw	s2,-128(s0)
    8000591a:	00290713          	addi	a4,s2,2
    8000591e:	0712                	slli	a4,a4,0x4
    80005920:	00018797          	auipc	a5,0x18
    80005924:	ee878793          	addi	a5,a5,-280 # 8001d808 <disk>
    80005928:	97ba                	add	a5,a5,a4
    8000592a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000592e:	00018997          	auipc	s3,0x18
    80005932:	eda98993          	addi	s3,s3,-294 # 8001d808 <disk>
    80005936:	00491713          	slli	a4,s2,0x4
    8000593a:	0009b783          	ld	a5,0(s3)
    8000593e:	97ba                	add	a5,a5,a4
    80005940:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005944:	854a                	mv	a0,s2
    80005946:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000594a:	00000097          	auipc	ra,0x0
    8000594e:	b9c080e7          	jalr	-1124(ra) # 800054e6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005952:	8885                	andi	s1,s1,1
    80005954:	f0ed                	bnez	s1,80005936 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005956:	00018517          	auipc	a0,0x18
    8000595a:	fda50513          	addi	a0,a0,-38 # 8001d930 <disk+0x128>
    8000595e:	00001097          	auipc	ra,0x1
    80005962:	f24080e7          	jalr	-220(ra) # 80006882 <release>
}
    80005966:	70e6                	ld	ra,120(sp)
    80005968:	7446                	ld	s0,112(sp)
    8000596a:	74a6                	ld	s1,104(sp)
    8000596c:	7906                	ld	s2,96(sp)
    8000596e:	69e6                	ld	s3,88(sp)
    80005970:	6a46                	ld	s4,80(sp)
    80005972:	6aa6                	ld	s5,72(sp)
    80005974:	6b06                	ld	s6,64(sp)
    80005976:	7be2                	ld	s7,56(sp)
    80005978:	7c42                	ld	s8,48(sp)
    8000597a:	7ca2                	ld	s9,40(sp)
    8000597c:	7d02                	ld	s10,32(sp)
    8000597e:	6de2                	ld	s11,24(sp)
    80005980:	6109                	addi	sp,sp,128
    80005982:	8082                	ret

0000000080005984 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005984:	1101                	addi	sp,sp,-32
    80005986:	ec06                	sd	ra,24(sp)
    80005988:	e822                	sd	s0,16(sp)
    8000598a:	e426                	sd	s1,8(sp)
    8000598c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000598e:	00018497          	auipc	s1,0x18
    80005992:	e7a48493          	addi	s1,s1,-390 # 8001d808 <disk>
    80005996:	00018517          	auipc	a0,0x18
    8000599a:	f9a50513          	addi	a0,a0,-102 # 8001d930 <disk+0x128>
    8000599e:	00001097          	auipc	ra,0x1
    800059a2:	e14080e7          	jalr	-492(ra) # 800067b2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800059a6:	10001737          	lui	a4,0x10001
    800059aa:	533c                	lw	a5,96(a4)
    800059ac:	8b8d                	andi	a5,a5,3
    800059ae:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800059b0:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800059b4:	689c                	ld	a5,16(s1)
    800059b6:	0204d703          	lhu	a4,32(s1)
    800059ba:	0027d783          	lhu	a5,2(a5)
    800059be:	04f70863          	beq	a4,a5,80005a0e <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800059c2:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800059c6:	6898                	ld	a4,16(s1)
    800059c8:	0204d783          	lhu	a5,32(s1)
    800059cc:	8b9d                	andi	a5,a5,7
    800059ce:	078e                	slli	a5,a5,0x3
    800059d0:	97ba                	add	a5,a5,a4
    800059d2:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800059d4:	00278713          	addi	a4,a5,2
    800059d8:	0712                	slli	a4,a4,0x4
    800059da:	9726                	add	a4,a4,s1
    800059dc:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800059e0:	e721                	bnez	a4,80005a28 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800059e2:	0789                	addi	a5,a5,2
    800059e4:	0792                	slli	a5,a5,0x4
    800059e6:	97a6                	add	a5,a5,s1
    800059e8:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800059ea:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800059ee:	ffffc097          	auipc	ra,0xffffc
    800059f2:	c8e080e7          	jalr	-882(ra) # 8000167c <wakeup>

    disk.used_idx += 1;
    800059f6:	0204d783          	lhu	a5,32(s1)
    800059fa:	2785                	addiw	a5,a5,1
    800059fc:	17c2                	slli	a5,a5,0x30
    800059fe:	93c1                	srli	a5,a5,0x30
    80005a00:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005a04:	6898                	ld	a4,16(s1)
    80005a06:	00275703          	lhu	a4,2(a4)
    80005a0a:	faf71ce3          	bne	a4,a5,800059c2 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005a0e:	00018517          	auipc	a0,0x18
    80005a12:	f2250513          	addi	a0,a0,-222 # 8001d930 <disk+0x128>
    80005a16:	00001097          	auipc	ra,0x1
    80005a1a:	e6c080e7          	jalr	-404(ra) # 80006882 <release>
}
    80005a1e:	60e2                	ld	ra,24(sp)
    80005a20:	6442                	ld	s0,16(sp)
    80005a22:	64a2                	ld	s1,8(sp)
    80005a24:	6105                	addi	sp,sp,32
    80005a26:	8082                	ret
      panic("virtio_disk_intr status");
    80005a28:	00003517          	auipc	a0,0x3
    80005a2c:	d9850513          	addi	a0,a0,-616 # 800087c0 <syscalls+0x3f0>
    80005a30:	00001097          	auipc	ra,0x1
    80005a34:	860080e7          	jalr	-1952(ra) # 80006290 <panic>

0000000080005a38 <statswrite>:
int statscopyin(char*, int);
int statslock(char*, int);
  
int
statswrite(int user_src, uint64 src, int n)
{
    80005a38:	1141                	addi	sp,sp,-16
    80005a3a:	e422                	sd	s0,8(sp)
    80005a3c:	0800                	addi	s0,sp,16
  return -1;
}
    80005a3e:	557d                	li	a0,-1
    80005a40:	6422                	ld	s0,8(sp)
    80005a42:	0141                	addi	sp,sp,16
    80005a44:	8082                	ret

0000000080005a46 <statsread>:

int
statsread(int user_dst, uint64 dst, int n)
{
    80005a46:	7179                	addi	sp,sp,-48
    80005a48:	f406                	sd	ra,40(sp)
    80005a4a:	f022                	sd	s0,32(sp)
    80005a4c:	ec26                	sd	s1,24(sp)
    80005a4e:	e84a                	sd	s2,16(sp)
    80005a50:	e44e                	sd	s3,8(sp)
    80005a52:	e052                	sd	s4,0(sp)
    80005a54:	1800                	addi	s0,sp,48
    80005a56:	892a                	mv	s2,a0
    80005a58:	89ae                	mv	s3,a1
    80005a5a:	84b2                	mv	s1,a2
  int m;

  acquire(&stats.lock);
    80005a5c:	00018517          	auipc	a0,0x18
    80005a60:	ef450513          	addi	a0,a0,-268 # 8001d950 <stats>
    80005a64:	00001097          	auipc	ra,0x1
    80005a68:	d4e080e7          	jalr	-690(ra) # 800067b2 <acquire>

  if(stats.sz == 0) {
    80005a6c:	00019797          	auipc	a5,0x19
    80005a70:	f047a783          	lw	a5,-252(a5) # 8001e970 <stats+0x1020>
    80005a74:	cbb5                	beqz	a5,80005ae8 <statsread+0xa2>
#endif
#ifdef LAB_LOCK
    stats.sz = statslock(stats.buf, BUFSZ);
#endif
  }
  m = stats.sz - stats.off;
    80005a76:	00019797          	auipc	a5,0x19
    80005a7a:	eda78793          	addi	a5,a5,-294 # 8001e950 <stats+0x1000>
    80005a7e:	53d8                	lw	a4,36(a5)
    80005a80:	539c                	lw	a5,32(a5)
    80005a82:	9f99                	subw	a5,a5,a4
    80005a84:	0007869b          	sext.w	a3,a5

  if (m > 0) {
    80005a88:	06d05e63          	blez	a3,80005b04 <statsread+0xbe>
    if(m > n)
    80005a8c:	8a3e                	mv	s4,a5
    80005a8e:	00d4d363          	bge	s1,a3,80005a94 <statsread+0x4e>
    80005a92:	8a26                	mv	s4,s1
    80005a94:	000a049b          	sext.w	s1,s4
      m  = n;
    if(either_copyout(user_dst, dst, stats.buf+stats.off, m) != -1) {
    80005a98:	86a6                	mv	a3,s1
    80005a9a:	00018617          	auipc	a2,0x18
    80005a9e:	ed660613          	addi	a2,a2,-298 # 8001d970 <stats+0x20>
    80005aa2:	963a                	add	a2,a2,a4
    80005aa4:	85ce                	mv	a1,s3
    80005aa6:	854a                	mv	a0,s2
    80005aa8:	ffffc097          	auipc	ra,0xffffc
    80005aac:	f78080e7          	jalr	-136(ra) # 80001a20 <either_copyout>
    80005ab0:	57fd                	li	a5,-1
    80005ab2:	00f50a63          	beq	a0,a5,80005ac6 <statsread+0x80>
      stats.off += m;
    80005ab6:	00019717          	auipc	a4,0x19
    80005aba:	e9a70713          	addi	a4,a4,-358 # 8001e950 <stats+0x1000>
    80005abe:	535c                	lw	a5,36(a4)
    80005ac0:	00fa07bb          	addw	a5,s4,a5
    80005ac4:	d35c                	sw	a5,36(a4)
  } else {
    m = -1;
    stats.sz = 0;
    stats.off = 0;
  }
  release(&stats.lock);
    80005ac6:	00018517          	auipc	a0,0x18
    80005aca:	e8a50513          	addi	a0,a0,-374 # 8001d950 <stats>
    80005ace:	00001097          	auipc	ra,0x1
    80005ad2:	db4080e7          	jalr	-588(ra) # 80006882 <release>
  return m;
}
    80005ad6:	8526                	mv	a0,s1
    80005ad8:	70a2                	ld	ra,40(sp)
    80005ada:	7402                	ld	s0,32(sp)
    80005adc:	64e2                	ld	s1,24(sp)
    80005ade:	6942                	ld	s2,16(sp)
    80005ae0:	69a2                	ld	s3,8(sp)
    80005ae2:	6a02                	ld	s4,0(sp)
    80005ae4:	6145                	addi	sp,sp,48
    80005ae6:	8082                	ret
    stats.sz = statslock(stats.buf, BUFSZ);
    80005ae8:	6585                	lui	a1,0x1
    80005aea:	00018517          	auipc	a0,0x18
    80005aee:	e8650513          	addi	a0,a0,-378 # 8001d970 <stats+0x20>
    80005af2:	00001097          	auipc	ra,0x1
    80005af6:	f00080e7          	jalr	-256(ra) # 800069f2 <statslock>
    80005afa:	00019797          	auipc	a5,0x19
    80005afe:	e6a7ab23          	sw	a0,-394(a5) # 8001e970 <stats+0x1020>
    80005b02:	bf95                	j	80005a76 <statsread+0x30>
    stats.sz = 0;
    80005b04:	00019797          	auipc	a5,0x19
    80005b08:	e4c78793          	addi	a5,a5,-436 # 8001e950 <stats+0x1000>
    80005b0c:	0207a023          	sw	zero,32(a5)
    stats.off = 0;
    80005b10:	0207a223          	sw	zero,36(a5)
    m = -1;
    80005b14:	54fd                	li	s1,-1
    80005b16:	bf45                	j	80005ac6 <statsread+0x80>

0000000080005b18 <statsinit>:

void
statsinit(void)
{
    80005b18:	1141                	addi	sp,sp,-16
    80005b1a:	e406                	sd	ra,8(sp)
    80005b1c:	e022                	sd	s0,0(sp)
    80005b1e:	0800                	addi	s0,sp,16
  initlock(&stats.lock, "stats");
    80005b20:	00003597          	auipc	a1,0x3
    80005b24:	cb858593          	addi	a1,a1,-840 # 800087d8 <syscalls+0x408>
    80005b28:	00018517          	auipc	a0,0x18
    80005b2c:	e2850513          	addi	a0,a0,-472 # 8001d950 <stats>
    80005b30:	00001097          	auipc	ra,0x1
    80005b34:	dfe080e7          	jalr	-514(ra) # 8000692e <initlock>

  devsw[STATS].read = statsread;
    80005b38:	00017797          	auipc	a5,0x17
    80005b3c:	c7078793          	addi	a5,a5,-912 # 8001c7a8 <devsw>
    80005b40:	00000717          	auipc	a4,0x0
    80005b44:	f0670713          	addi	a4,a4,-250 # 80005a46 <statsread>
    80005b48:	f398                	sd	a4,32(a5)
  devsw[STATS].write = statswrite;
    80005b4a:	00000717          	auipc	a4,0x0
    80005b4e:	eee70713          	addi	a4,a4,-274 # 80005a38 <statswrite>
    80005b52:	f798                	sd	a4,40(a5)
}
    80005b54:	60a2                	ld	ra,8(sp)
    80005b56:	6402                	ld	s0,0(sp)
    80005b58:	0141                	addi	sp,sp,16
    80005b5a:	8082                	ret

0000000080005b5c <sprintint>:
  return 1;
}

static int
sprintint(char *s, int xx, int base, int sign)
{
    80005b5c:	1101                	addi	sp,sp,-32
    80005b5e:	ec22                	sd	s0,24(sp)
    80005b60:	1000                	addi	s0,sp,32
    80005b62:	882a                	mv	a6,a0
  char buf[16];
  int i, n;
  uint x;

  if(sign && (sign = xx < 0))
    80005b64:	c299                	beqz	a3,80005b6a <sprintint+0xe>
    80005b66:	0805c263          	bltz	a1,80005bea <sprintint+0x8e>
    x = -xx;
  else
    x = xx;
    80005b6a:	2581                	sext.w	a1,a1
    80005b6c:	4301                	li	t1,0

  i = 0;
    80005b6e:	fe040713          	addi	a4,s0,-32
    80005b72:	4501                	li	a0,0
  do {
    buf[i++] = digits[x % base];
    80005b74:	2601                	sext.w	a2,a2
    80005b76:	00003697          	auipc	a3,0x3
    80005b7a:	c8268693          	addi	a3,a3,-894 # 800087f8 <digits>
    80005b7e:	88aa                	mv	a7,a0
    80005b80:	2505                	addiw	a0,a0,1
    80005b82:	02c5f7bb          	remuw	a5,a1,a2
    80005b86:	1782                	slli	a5,a5,0x20
    80005b88:	9381                	srli	a5,a5,0x20
    80005b8a:	97b6                	add	a5,a5,a3
    80005b8c:	0007c783          	lbu	a5,0(a5)
    80005b90:	00f70023          	sb	a5,0(a4)
  } while((x /= base) != 0);
    80005b94:	0005879b          	sext.w	a5,a1
    80005b98:	02c5d5bb          	divuw	a1,a1,a2
    80005b9c:	0705                	addi	a4,a4,1
    80005b9e:	fec7f0e3          	bgeu	a5,a2,80005b7e <sprintint+0x22>

  if(sign)
    80005ba2:	00030b63          	beqz	t1,80005bb8 <sprintint+0x5c>
    buf[i++] = '-';
    80005ba6:	ff050793          	addi	a5,a0,-16
    80005baa:	97a2                	add	a5,a5,s0
    80005bac:	02d00713          	li	a4,45
    80005bb0:	fee78823          	sb	a4,-16(a5)
    80005bb4:	0028851b          	addiw	a0,a7,2

  n = 0;
  while(--i >= 0)
    80005bb8:	02a05d63          	blez	a0,80005bf2 <sprintint+0x96>
    80005bbc:	fe040793          	addi	a5,s0,-32
    80005bc0:	00a78733          	add	a4,a5,a0
    80005bc4:	87c2                	mv	a5,a6
    80005bc6:	00180613          	addi	a2,a6,1
    80005bca:	fff5069b          	addiw	a3,a0,-1
    80005bce:	1682                	slli	a3,a3,0x20
    80005bd0:	9281                	srli	a3,a3,0x20
    80005bd2:	9636                	add	a2,a2,a3
  *s = c;
    80005bd4:	fff74683          	lbu	a3,-1(a4)
    80005bd8:	00d78023          	sb	a3,0(a5)
  while(--i >= 0)
    80005bdc:	177d                	addi	a4,a4,-1
    80005bde:	0785                	addi	a5,a5,1
    80005be0:	fec79ae3          	bne	a5,a2,80005bd4 <sprintint+0x78>
    n += sputc(s+n, buf[i]);
  return n;
}
    80005be4:	6462                	ld	s0,24(sp)
    80005be6:	6105                	addi	sp,sp,32
    80005be8:	8082                	ret
    x = -xx;
    80005bea:	40b005bb          	negw	a1,a1
  if(sign && (sign = xx < 0))
    80005bee:	4305                	li	t1,1
    x = -xx;
    80005bf0:	bfbd                	j	80005b6e <sprintint+0x12>
  while(--i >= 0)
    80005bf2:	4501                	li	a0,0
    80005bf4:	bfc5                	j	80005be4 <sprintint+0x88>

0000000080005bf6 <snprintf>:

int
snprintf(char *buf, int sz, char *fmt, ...)
{
    80005bf6:	7135                	addi	sp,sp,-160
    80005bf8:	f486                	sd	ra,104(sp)
    80005bfa:	f0a2                	sd	s0,96(sp)
    80005bfc:	eca6                	sd	s1,88(sp)
    80005bfe:	e8ca                	sd	s2,80(sp)
    80005c00:	e4ce                	sd	s3,72(sp)
    80005c02:	e0d2                	sd	s4,64(sp)
    80005c04:	fc56                	sd	s5,56(sp)
    80005c06:	f85a                	sd	s6,48(sp)
    80005c08:	f45e                	sd	s7,40(sp)
    80005c0a:	f062                	sd	s8,32(sp)
    80005c0c:	ec66                	sd	s9,24(sp)
    80005c0e:	e86a                	sd	s10,16(sp)
    80005c10:	1880                	addi	s0,sp,112
    80005c12:	e414                	sd	a3,8(s0)
    80005c14:	e818                	sd	a4,16(s0)
    80005c16:	ec1c                	sd	a5,24(s0)
    80005c18:	03043023          	sd	a6,32(s0)
    80005c1c:	03143423          	sd	a7,40(s0)
  va_list ap;
  int i, c;
  int off = 0;
  char *s;

  if (fmt == 0)
    80005c20:	c61d                	beqz	a2,80005c4e <snprintf+0x58>
    80005c22:	8baa                	mv	s7,a0
    80005c24:	89ae                	mv	s3,a1
    80005c26:	8a32                	mv	s4,a2
    panic("null fmt");

  va_start(ap, fmt);
    80005c28:	00840793          	addi	a5,s0,8
    80005c2c:	f8f43c23          	sd	a5,-104(s0)
  int off = 0;
    80005c30:	4481                	li	s1,0
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005c32:	4901                	li	s2,0
    80005c34:	02b05563          	blez	a1,80005c5e <snprintf+0x68>
    if(c != '%'){
    80005c38:	02500a93          	li	s5,37
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    80005c3c:	07300b13          	li	s6,115
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
      break;
    case 's':
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s && off < sz; s++)
    80005c40:	02800d13          	li	s10,40
    switch(c){
    80005c44:	07800c93          	li	s9,120
    80005c48:	06400c13          	li	s8,100
    80005c4c:	a01d                	j	80005c72 <snprintf+0x7c>
    panic("null fmt");
    80005c4e:	00003517          	auipc	a0,0x3
    80005c52:	b9a50513          	addi	a0,a0,-1126 # 800087e8 <syscalls+0x418>
    80005c56:	00000097          	auipc	ra,0x0
    80005c5a:	63a080e7          	jalr	1594(ra) # 80006290 <panic>
  int off = 0;
    80005c5e:	4481                	li	s1,0
    80005c60:	a875                	j	80005d1c <snprintf+0x126>
  *s = c;
    80005c62:	009b8733          	add	a4,s7,s1
    80005c66:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005c6a:	2485                	addiw	s1,s1,1
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005c6c:	2905                	addiw	s2,s2,1
    80005c6e:	0b34d763          	bge	s1,s3,80005d1c <snprintf+0x126>
    80005c72:	012a07b3          	add	a5,s4,s2
    80005c76:	0007c783          	lbu	a5,0(a5)
    80005c7a:	0007871b          	sext.w	a4,a5
    80005c7e:	cfd9                	beqz	a5,80005d1c <snprintf+0x126>
    if(c != '%'){
    80005c80:	ff5711e3          	bne	a4,s5,80005c62 <snprintf+0x6c>
    c = fmt[++i] & 0xff;
    80005c84:	2905                	addiw	s2,s2,1
    80005c86:	012a07b3          	add	a5,s4,s2
    80005c8a:	0007c783          	lbu	a5,0(a5)
    if(c == 0)
    80005c8e:	c7d9                	beqz	a5,80005d1c <snprintf+0x126>
    switch(c){
    80005c90:	05678c63          	beq	a5,s6,80005ce8 <snprintf+0xf2>
    80005c94:	02fb6763          	bltu	s6,a5,80005cc2 <snprintf+0xcc>
    80005c98:	0b578763          	beq	a5,s5,80005d46 <snprintf+0x150>
    80005c9c:	0b879b63          	bne	a5,s8,80005d52 <snprintf+0x15c>
      off += sprintint(buf+off, va_arg(ap, int), 10, 1);
    80005ca0:	f9843783          	ld	a5,-104(s0)
    80005ca4:	00878713          	addi	a4,a5,8
    80005ca8:	f8e43c23          	sd	a4,-104(s0)
    80005cac:	4685                	li	a3,1
    80005cae:	4629                	li	a2,10
    80005cb0:	438c                	lw	a1,0(a5)
    80005cb2:	009b8533          	add	a0,s7,s1
    80005cb6:	00000097          	auipc	ra,0x0
    80005cba:	ea6080e7          	jalr	-346(ra) # 80005b5c <sprintint>
    80005cbe:	9ca9                	addw	s1,s1,a0
      break;
    80005cc0:	b775                	j	80005c6c <snprintf+0x76>
    switch(c){
    80005cc2:	09979863          	bne	a5,s9,80005d52 <snprintf+0x15c>
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
    80005cc6:	f9843783          	ld	a5,-104(s0)
    80005cca:	00878713          	addi	a4,a5,8
    80005cce:	f8e43c23          	sd	a4,-104(s0)
    80005cd2:	4685                	li	a3,1
    80005cd4:	4641                	li	a2,16
    80005cd6:	438c                	lw	a1,0(a5)
    80005cd8:	009b8533          	add	a0,s7,s1
    80005cdc:	00000097          	auipc	ra,0x0
    80005ce0:	e80080e7          	jalr	-384(ra) # 80005b5c <sprintint>
    80005ce4:	9ca9                	addw	s1,s1,a0
      break;
    80005ce6:	b759                	j	80005c6c <snprintf+0x76>
      if((s = va_arg(ap, char*)) == 0)
    80005ce8:	f9843783          	ld	a5,-104(s0)
    80005cec:	00878713          	addi	a4,a5,8
    80005cf0:	f8e43c23          	sd	a4,-104(s0)
    80005cf4:	639c                	ld	a5,0(a5)
    80005cf6:	c3b1                	beqz	a5,80005d3a <snprintf+0x144>
      for(; *s && off < sz; s++)
    80005cf8:	0007c703          	lbu	a4,0(a5)
    80005cfc:	db25                	beqz	a4,80005c6c <snprintf+0x76>
    80005cfe:	0734d563          	bge	s1,s3,80005d68 <snprintf+0x172>
    80005d02:	009b86b3          	add	a3,s7,s1
  *s = c;
    80005d06:	00e68023          	sb	a4,0(a3)
        off += sputc(buf+off, *s);
    80005d0a:	2485                	addiw	s1,s1,1
      for(; *s && off < sz; s++)
    80005d0c:	0785                	addi	a5,a5,1
    80005d0e:	0007c703          	lbu	a4,0(a5)
    80005d12:	df29                	beqz	a4,80005c6c <snprintf+0x76>
    80005d14:	0685                	addi	a3,a3,1
    80005d16:	fe9998e3          	bne	s3,s1,80005d06 <snprintf+0x110>
  int off = 0;
    80005d1a:	84ce                	mv	s1,s3
      off += sputc(buf+off, c);
      break;
    }
  }
  return off;
}
    80005d1c:	8526                	mv	a0,s1
    80005d1e:	70a6                	ld	ra,104(sp)
    80005d20:	7406                	ld	s0,96(sp)
    80005d22:	64e6                	ld	s1,88(sp)
    80005d24:	6946                	ld	s2,80(sp)
    80005d26:	69a6                	ld	s3,72(sp)
    80005d28:	6a06                	ld	s4,64(sp)
    80005d2a:	7ae2                	ld	s5,56(sp)
    80005d2c:	7b42                	ld	s6,48(sp)
    80005d2e:	7ba2                	ld	s7,40(sp)
    80005d30:	7c02                	ld	s8,32(sp)
    80005d32:	6ce2                	ld	s9,24(sp)
    80005d34:	6d42                	ld	s10,16(sp)
    80005d36:	610d                	addi	sp,sp,160
    80005d38:	8082                	ret
        s = "(null)";
    80005d3a:	00003797          	auipc	a5,0x3
    80005d3e:	aa678793          	addi	a5,a5,-1370 # 800087e0 <syscalls+0x410>
      for(; *s && off < sz; s++)
    80005d42:	876a                	mv	a4,s10
    80005d44:	bf6d                	j	80005cfe <snprintf+0x108>
  *s = c;
    80005d46:	009b87b3          	add	a5,s7,s1
    80005d4a:	01578023          	sb	s5,0(a5)
      off += sputc(buf+off, '%');
    80005d4e:	2485                	addiw	s1,s1,1
      break;
    80005d50:	bf31                	j	80005c6c <snprintf+0x76>
  *s = c;
    80005d52:	009b8733          	add	a4,s7,s1
    80005d56:	01570023          	sb	s5,0(a4)
      off += sputc(buf+off, c);
    80005d5a:	0014871b          	addiw	a4,s1,1
  *s = c;
    80005d5e:	975e                	add	a4,a4,s7
    80005d60:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005d64:	2489                	addiw	s1,s1,2
      break;
    80005d66:	b719                	j	80005c6c <snprintf+0x76>
      for(; *s && off < sz; s++)
    80005d68:	89a6                	mv	s3,s1
    80005d6a:	bf45                	j	80005d1a <snprintf+0x124>

0000000080005d6c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005d6c:	1141                	addi	sp,sp,-16
    80005d6e:	e422                	sd	s0,8(sp)
    80005d70:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005d72:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005d76:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005d7a:	0037979b          	slliw	a5,a5,0x3
    80005d7e:	02004737          	lui	a4,0x2004
    80005d82:	97ba                	add	a5,a5,a4
    80005d84:	0200c737          	lui	a4,0x200c
    80005d88:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005d8c:	000f4637          	lui	a2,0xf4
    80005d90:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005d94:	9732                	add	a4,a4,a2
    80005d96:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005d98:	00259693          	slli	a3,a1,0x2
    80005d9c:	96ae                	add	a3,a3,a1
    80005d9e:	068e                	slli	a3,a3,0x3
    80005da0:	00019717          	auipc	a4,0x19
    80005da4:	be070713          	addi	a4,a4,-1056 # 8001e980 <timer_scratch>
    80005da8:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005daa:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005dac:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005dae:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005db2:	fffff797          	auipc	a5,0xfffff
    80005db6:	66e78793          	addi	a5,a5,1646 # 80005420 <timervec>
    80005dba:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005dbe:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005dc2:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005dc6:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005dca:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005dce:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005dd2:	30479073          	csrw	mie,a5
}
    80005dd6:	6422                	ld	s0,8(sp)
    80005dd8:	0141                	addi	sp,sp,16
    80005dda:	8082                	ret

0000000080005ddc <start>:
{
    80005ddc:	1141                	addi	sp,sp,-16
    80005dde:	e406                	sd	ra,8(sp)
    80005de0:	e022                	sd	s0,0(sp)
    80005de2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005de4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005de8:	7779                	lui	a4,0xffffe
    80005dea:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd6c67>
    80005dee:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005df0:	6705                	lui	a4,0x1
    80005df2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005df6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005df8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005dfc:	ffffa797          	auipc	a5,0xffffa
    80005e00:	63078793          	addi	a5,a5,1584 # 8000042c <main>
    80005e04:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005e08:	4781                	li	a5,0
    80005e0a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005e0e:	67c1                	lui	a5,0x10
    80005e10:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005e12:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005e16:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005e1a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005e1e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005e22:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005e26:	57fd                	li	a5,-1
    80005e28:	83a9                	srli	a5,a5,0xa
    80005e2a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005e2e:	47bd                	li	a5,15
    80005e30:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005e34:	00000097          	auipc	ra,0x0
    80005e38:	f38080e7          	jalr	-200(ra) # 80005d6c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005e3c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005e40:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005e42:	823e                	mv	tp,a5
  asm volatile("mret");
    80005e44:	30200073          	mret
}
    80005e48:	60a2                	ld	ra,8(sp)
    80005e4a:	6402                	ld	s0,0(sp)
    80005e4c:	0141                	addi	sp,sp,16
    80005e4e:	8082                	ret

0000000080005e50 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005e50:	715d                	addi	sp,sp,-80
    80005e52:	e486                	sd	ra,72(sp)
    80005e54:	e0a2                	sd	s0,64(sp)
    80005e56:	fc26                	sd	s1,56(sp)
    80005e58:	f84a                	sd	s2,48(sp)
    80005e5a:	f44e                	sd	s3,40(sp)
    80005e5c:	f052                	sd	s4,32(sp)
    80005e5e:	ec56                	sd	s5,24(sp)
    80005e60:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005e62:	04c05763          	blez	a2,80005eb0 <consolewrite+0x60>
    80005e66:	8a2a                	mv	s4,a0
    80005e68:	84ae                	mv	s1,a1
    80005e6a:	89b2                	mv	s3,a2
    80005e6c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005e6e:	5afd                	li	s5,-1
    80005e70:	4685                	li	a3,1
    80005e72:	8626                	mv	a2,s1
    80005e74:	85d2                	mv	a1,s4
    80005e76:	fbf40513          	addi	a0,s0,-65
    80005e7a:	ffffc097          	auipc	ra,0xffffc
    80005e7e:	bfc080e7          	jalr	-1028(ra) # 80001a76 <either_copyin>
    80005e82:	01550d63          	beq	a0,s5,80005e9c <consolewrite+0x4c>
      break;
    uartputc(c);
    80005e86:	fbf44503          	lbu	a0,-65(s0)
    80005e8a:	00000097          	auipc	ra,0x0
    80005e8e:	784080e7          	jalr	1924(ra) # 8000660e <uartputc>
  for(i = 0; i < n; i++){
    80005e92:	2905                	addiw	s2,s2,1
    80005e94:	0485                	addi	s1,s1,1
    80005e96:	fd299de3          	bne	s3,s2,80005e70 <consolewrite+0x20>
    80005e9a:	894e                	mv	s2,s3
  }

  return i;
}
    80005e9c:	854a                	mv	a0,s2
    80005e9e:	60a6                	ld	ra,72(sp)
    80005ea0:	6406                	ld	s0,64(sp)
    80005ea2:	74e2                	ld	s1,56(sp)
    80005ea4:	7942                	ld	s2,48(sp)
    80005ea6:	79a2                	ld	s3,40(sp)
    80005ea8:	7a02                	ld	s4,32(sp)
    80005eaa:	6ae2                	ld	s5,24(sp)
    80005eac:	6161                	addi	sp,sp,80
    80005eae:	8082                	ret
  for(i = 0; i < n; i++){
    80005eb0:	4901                	li	s2,0
    80005eb2:	b7ed                	j	80005e9c <consolewrite+0x4c>

0000000080005eb4 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005eb4:	7159                	addi	sp,sp,-112
    80005eb6:	f486                	sd	ra,104(sp)
    80005eb8:	f0a2                	sd	s0,96(sp)
    80005eba:	eca6                	sd	s1,88(sp)
    80005ebc:	e8ca                	sd	s2,80(sp)
    80005ebe:	e4ce                	sd	s3,72(sp)
    80005ec0:	e0d2                	sd	s4,64(sp)
    80005ec2:	fc56                	sd	s5,56(sp)
    80005ec4:	f85a                	sd	s6,48(sp)
    80005ec6:	f45e                	sd	s7,40(sp)
    80005ec8:	f062                	sd	s8,32(sp)
    80005eca:	ec66                	sd	s9,24(sp)
    80005ecc:	e86a                	sd	s10,16(sp)
    80005ece:	1880                	addi	s0,sp,112
    80005ed0:	8aaa                	mv	s5,a0
    80005ed2:	8a2e                	mv	s4,a1
    80005ed4:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005ed6:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005eda:	00021517          	auipc	a0,0x21
    80005ede:	be650513          	addi	a0,a0,-1050 # 80026ac0 <cons>
    80005ee2:	00001097          	auipc	ra,0x1
    80005ee6:	8d0080e7          	jalr	-1840(ra) # 800067b2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005eea:	00021497          	auipc	s1,0x21
    80005eee:	bd648493          	addi	s1,s1,-1066 # 80026ac0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005ef2:	00021917          	auipc	s2,0x21
    80005ef6:	c6e90913          	addi	s2,s2,-914 # 80026b60 <cons+0xa0>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005efa:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005efc:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005efe:	4ca9                	li	s9,10
  while(n > 0){
    80005f00:	07305b63          	blez	s3,80005f76 <consoleread+0xc2>
    while(cons.r == cons.w){
    80005f04:	0a04a783          	lw	a5,160(s1)
    80005f08:	0a44a703          	lw	a4,164(s1)
    80005f0c:	02f71763          	bne	a4,a5,80005f3a <consoleread+0x86>
      if(killed(myproc())){
    80005f10:	ffffb097          	auipc	ra,0xffffb
    80005f14:	060080e7          	jalr	96(ra) # 80000f70 <myproc>
    80005f18:	ffffc097          	auipc	ra,0xffffc
    80005f1c:	9a8080e7          	jalr	-1624(ra) # 800018c0 <killed>
    80005f20:	e535                	bnez	a0,80005f8c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    80005f22:	85a6                	mv	a1,s1
    80005f24:	854a                	mv	a0,s2
    80005f26:	ffffb097          	auipc	ra,0xffffb
    80005f2a:	6f2080e7          	jalr	1778(ra) # 80001618 <sleep>
    while(cons.r == cons.w){
    80005f2e:	0a04a783          	lw	a5,160(s1)
    80005f32:	0a44a703          	lw	a4,164(s1)
    80005f36:	fcf70de3          	beq	a4,a5,80005f10 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005f3a:	0017871b          	addiw	a4,a5,1
    80005f3e:	0ae4a023          	sw	a4,160(s1)
    80005f42:	07f7f713          	andi	a4,a5,127
    80005f46:	9726                	add	a4,a4,s1
    80005f48:	02074703          	lbu	a4,32(a4)
    80005f4c:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005f50:	077d0563          	beq	s10,s7,80005fba <consoleread+0x106>
    cbuf = c;
    80005f54:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005f58:	4685                	li	a3,1
    80005f5a:	f9f40613          	addi	a2,s0,-97
    80005f5e:	85d2                	mv	a1,s4
    80005f60:	8556                	mv	a0,s5
    80005f62:	ffffc097          	auipc	ra,0xffffc
    80005f66:	abe080e7          	jalr	-1346(ra) # 80001a20 <either_copyout>
    80005f6a:	01850663          	beq	a0,s8,80005f76 <consoleread+0xc2>
    dst++;
    80005f6e:	0a05                	addi	s4,s4,1
    --n;
    80005f70:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005f72:	f99d17e3          	bne	s10,s9,80005f00 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005f76:	00021517          	auipc	a0,0x21
    80005f7a:	b4a50513          	addi	a0,a0,-1206 # 80026ac0 <cons>
    80005f7e:	00001097          	auipc	ra,0x1
    80005f82:	904080e7          	jalr	-1788(ra) # 80006882 <release>

  return target - n;
    80005f86:	413b053b          	subw	a0,s6,s3
    80005f8a:	a811                	j	80005f9e <consoleread+0xea>
        release(&cons.lock);
    80005f8c:	00021517          	auipc	a0,0x21
    80005f90:	b3450513          	addi	a0,a0,-1228 # 80026ac0 <cons>
    80005f94:	00001097          	auipc	ra,0x1
    80005f98:	8ee080e7          	jalr	-1810(ra) # 80006882 <release>
        return -1;
    80005f9c:	557d                	li	a0,-1
}
    80005f9e:	70a6                	ld	ra,104(sp)
    80005fa0:	7406                	ld	s0,96(sp)
    80005fa2:	64e6                	ld	s1,88(sp)
    80005fa4:	6946                	ld	s2,80(sp)
    80005fa6:	69a6                	ld	s3,72(sp)
    80005fa8:	6a06                	ld	s4,64(sp)
    80005faa:	7ae2                	ld	s5,56(sp)
    80005fac:	7b42                	ld	s6,48(sp)
    80005fae:	7ba2                	ld	s7,40(sp)
    80005fb0:	7c02                	ld	s8,32(sp)
    80005fb2:	6ce2                	ld	s9,24(sp)
    80005fb4:	6d42                	ld	s10,16(sp)
    80005fb6:	6165                	addi	sp,sp,112
    80005fb8:	8082                	ret
      if(n < target){
    80005fba:	0009871b          	sext.w	a4,s3
    80005fbe:	fb677ce3          	bgeu	a4,s6,80005f76 <consoleread+0xc2>
        cons.r--;
    80005fc2:	00021717          	auipc	a4,0x21
    80005fc6:	b8f72f23          	sw	a5,-1122(a4) # 80026b60 <cons+0xa0>
    80005fca:	b775                	j	80005f76 <consoleread+0xc2>

0000000080005fcc <consputc>:
{
    80005fcc:	1141                	addi	sp,sp,-16
    80005fce:	e406                	sd	ra,8(sp)
    80005fd0:	e022                	sd	s0,0(sp)
    80005fd2:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005fd4:	10000793          	li	a5,256
    80005fd8:	00f50a63          	beq	a0,a5,80005fec <consputc+0x20>
    uartputc_sync(c);
    80005fdc:	00000097          	auipc	ra,0x0
    80005fe0:	560080e7          	jalr	1376(ra) # 8000653c <uartputc_sync>
}
    80005fe4:	60a2                	ld	ra,8(sp)
    80005fe6:	6402                	ld	s0,0(sp)
    80005fe8:	0141                	addi	sp,sp,16
    80005fea:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005fec:	4521                	li	a0,8
    80005fee:	00000097          	auipc	ra,0x0
    80005ff2:	54e080e7          	jalr	1358(ra) # 8000653c <uartputc_sync>
    80005ff6:	02000513          	li	a0,32
    80005ffa:	00000097          	auipc	ra,0x0
    80005ffe:	542080e7          	jalr	1346(ra) # 8000653c <uartputc_sync>
    80006002:	4521                	li	a0,8
    80006004:	00000097          	auipc	ra,0x0
    80006008:	538080e7          	jalr	1336(ra) # 8000653c <uartputc_sync>
    8000600c:	bfe1                	j	80005fe4 <consputc+0x18>

000000008000600e <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    8000600e:	1101                	addi	sp,sp,-32
    80006010:	ec06                	sd	ra,24(sp)
    80006012:	e822                	sd	s0,16(sp)
    80006014:	e426                	sd	s1,8(sp)
    80006016:	e04a                	sd	s2,0(sp)
    80006018:	1000                	addi	s0,sp,32
    8000601a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000601c:	00021517          	auipc	a0,0x21
    80006020:	aa450513          	addi	a0,a0,-1372 # 80026ac0 <cons>
    80006024:	00000097          	auipc	ra,0x0
    80006028:	78e080e7          	jalr	1934(ra) # 800067b2 <acquire>

  switch(c){
    8000602c:	47d5                	li	a5,21
    8000602e:	0af48663          	beq	s1,a5,800060da <consoleintr+0xcc>
    80006032:	0297ca63          	blt	a5,s1,80006066 <consoleintr+0x58>
    80006036:	47a1                	li	a5,8
    80006038:	0ef48763          	beq	s1,a5,80006126 <consoleintr+0x118>
    8000603c:	47c1                	li	a5,16
    8000603e:	10f49a63          	bne	s1,a5,80006152 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80006042:	ffffc097          	auipc	ra,0xffffc
    80006046:	a8a080e7          	jalr	-1398(ra) # 80001acc <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000604a:	00021517          	auipc	a0,0x21
    8000604e:	a7650513          	addi	a0,a0,-1418 # 80026ac0 <cons>
    80006052:	00001097          	auipc	ra,0x1
    80006056:	830080e7          	jalr	-2000(ra) # 80006882 <release>
}
    8000605a:	60e2                	ld	ra,24(sp)
    8000605c:	6442                	ld	s0,16(sp)
    8000605e:	64a2                	ld	s1,8(sp)
    80006060:	6902                	ld	s2,0(sp)
    80006062:	6105                	addi	sp,sp,32
    80006064:	8082                	ret
  switch(c){
    80006066:	07f00793          	li	a5,127
    8000606a:	0af48e63          	beq	s1,a5,80006126 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000606e:	00021717          	auipc	a4,0x21
    80006072:	a5270713          	addi	a4,a4,-1454 # 80026ac0 <cons>
    80006076:	0a872783          	lw	a5,168(a4)
    8000607a:	0a072703          	lw	a4,160(a4)
    8000607e:	9f99                	subw	a5,a5,a4
    80006080:	07f00713          	li	a4,127
    80006084:	fcf763e3          	bltu	a4,a5,8000604a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80006088:	47b5                	li	a5,13
    8000608a:	0cf48763          	beq	s1,a5,80006158 <consoleintr+0x14a>
      consputc(c);
    8000608e:	8526                	mv	a0,s1
    80006090:	00000097          	auipc	ra,0x0
    80006094:	f3c080e7          	jalr	-196(ra) # 80005fcc <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80006098:	00021797          	auipc	a5,0x21
    8000609c:	a2878793          	addi	a5,a5,-1496 # 80026ac0 <cons>
    800060a0:	0a87a683          	lw	a3,168(a5)
    800060a4:	0016871b          	addiw	a4,a3,1
    800060a8:	0007061b          	sext.w	a2,a4
    800060ac:	0ae7a423          	sw	a4,168(a5)
    800060b0:	07f6f693          	andi	a3,a3,127
    800060b4:	97b6                	add	a5,a5,a3
    800060b6:	02978023          	sb	s1,32(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800060ba:	47a9                	li	a5,10
    800060bc:	0cf48563          	beq	s1,a5,80006186 <consoleintr+0x178>
    800060c0:	4791                	li	a5,4
    800060c2:	0cf48263          	beq	s1,a5,80006186 <consoleintr+0x178>
    800060c6:	00021797          	auipc	a5,0x21
    800060ca:	a9a7a783          	lw	a5,-1382(a5) # 80026b60 <cons+0xa0>
    800060ce:	9f1d                	subw	a4,a4,a5
    800060d0:	08000793          	li	a5,128
    800060d4:	f6f71be3          	bne	a4,a5,8000604a <consoleintr+0x3c>
    800060d8:	a07d                	j	80006186 <consoleintr+0x178>
    while(cons.e != cons.w &&
    800060da:	00021717          	auipc	a4,0x21
    800060de:	9e670713          	addi	a4,a4,-1562 # 80026ac0 <cons>
    800060e2:	0a872783          	lw	a5,168(a4)
    800060e6:	0a472703          	lw	a4,164(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800060ea:	00021497          	auipc	s1,0x21
    800060ee:	9d648493          	addi	s1,s1,-1578 # 80026ac0 <cons>
    while(cons.e != cons.w &&
    800060f2:	4929                	li	s2,10
    800060f4:	f4f70be3          	beq	a4,a5,8000604a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800060f8:	37fd                	addiw	a5,a5,-1
    800060fa:	07f7f713          	andi	a4,a5,127
    800060fe:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80006100:	02074703          	lbu	a4,32(a4)
    80006104:	f52703e3          	beq	a4,s2,8000604a <consoleintr+0x3c>
      cons.e--;
    80006108:	0af4a423          	sw	a5,168(s1)
      consputc(BACKSPACE);
    8000610c:	10000513          	li	a0,256
    80006110:	00000097          	auipc	ra,0x0
    80006114:	ebc080e7          	jalr	-324(ra) # 80005fcc <consputc>
    while(cons.e != cons.w &&
    80006118:	0a84a783          	lw	a5,168(s1)
    8000611c:	0a44a703          	lw	a4,164(s1)
    80006120:	fcf71ce3          	bne	a4,a5,800060f8 <consoleintr+0xea>
    80006124:	b71d                	j	8000604a <consoleintr+0x3c>
    if(cons.e != cons.w){
    80006126:	00021717          	auipc	a4,0x21
    8000612a:	99a70713          	addi	a4,a4,-1638 # 80026ac0 <cons>
    8000612e:	0a872783          	lw	a5,168(a4)
    80006132:	0a472703          	lw	a4,164(a4)
    80006136:	f0f70ae3          	beq	a4,a5,8000604a <consoleintr+0x3c>
      cons.e--;
    8000613a:	37fd                	addiw	a5,a5,-1
    8000613c:	00021717          	auipc	a4,0x21
    80006140:	a2f72623          	sw	a5,-1492(a4) # 80026b68 <cons+0xa8>
      consputc(BACKSPACE);
    80006144:	10000513          	li	a0,256
    80006148:	00000097          	auipc	ra,0x0
    8000614c:	e84080e7          	jalr	-380(ra) # 80005fcc <consputc>
    80006150:	bded                	j	8000604a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80006152:	ee048ce3          	beqz	s1,8000604a <consoleintr+0x3c>
    80006156:	bf21                	j	8000606e <consoleintr+0x60>
      consputc(c);
    80006158:	4529                	li	a0,10
    8000615a:	00000097          	auipc	ra,0x0
    8000615e:	e72080e7          	jalr	-398(ra) # 80005fcc <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80006162:	00021797          	auipc	a5,0x21
    80006166:	95e78793          	addi	a5,a5,-1698 # 80026ac0 <cons>
    8000616a:	0a87a703          	lw	a4,168(a5)
    8000616e:	0017069b          	addiw	a3,a4,1
    80006172:	0006861b          	sext.w	a2,a3
    80006176:	0ad7a423          	sw	a3,168(a5)
    8000617a:	07f77713          	andi	a4,a4,127
    8000617e:	97ba                	add	a5,a5,a4
    80006180:	4729                	li	a4,10
    80006182:	02e78023          	sb	a4,32(a5)
        cons.w = cons.e;
    80006186:	00021797          	auipc	a5,0x21
    8000618a:	9cc7af23          	sw	a2,-1570(a5) # 80026b64 <cons+0xa4>
        wakeup(&cons.r);
    8000618e:	00021517          	auipc	a0,0x21
    80006192:	9d250513          	addi	a0,a0,-1582 # 80026b60 <cons+0xa0>
    80006196:	ffffb097          	auipc	ra,0xffffb
    8000619a:	4e6080e7          	jalr	1254(ra) # 8000167c <wakeup>
    8000619e:	b575                	j	8000604a <consoleintr+0x3c>

00000000800061a0 <consoleinit>:

void
consoleinit(void)
{
    800061a0:	1141                	addi	sp,sp,-16
    800061a2:	e406                	sd	ra,8(sp)
    800061a4:	e022                	sd	s0,0(sp)
    800061a6:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800061a8:	00002597          	auipc	a1,0x2
    800061ac:	66858593          	addi	a1,a1,1640 # 80008810 <digits+0x18>
    800061b0:	00021517          	auipc	a0,0x21
    800061b4:	91050513          	addi	a0,a0,-1776 # 80026ac0 <cons>
    800061b8:	00000097          	auipc	ra,0x0
    800061bc:	776080e7          	jalr	1910(ra) # 8000692e <initlock>

  uartinit();
    800061c0:	00000097          	auipc	ra,0x0
    800061c4:	32c080e7          	jalr	812(ra) # 800064ec <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800061c8:	00016797          	auipc	a5,0x16
    800061cc:	5e078793          	addi	a5,a5,1504 # 8001c7a8 <devsw>
    800061d0:	00000717          	auipc	a4,0x0
    800061d4:	ce470713          	addi	a4,a4,-796 # 80005eb4 <consoleread>
    800061d8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800061da:	00000717          	auipc	a4,0x0
    800061de:	c7670713          	addi	a4,a4,-906 # 80005e50 <consolewrite>
    800061e2:	ef98                	sd	a4,24(a5)
}
    800061e4:	60a2                	ld	ra,8(sp)
    800061e6:	6402                	ld	s0,0(sp)
    800061e8:	0141                	addi	sp,sp,16
    800061ea:	8082                	ret

00000000800061ec <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800061ec:	7179                	addi	sp,sp,-48
    800061ee:	f406                	sd	ra,40(sp)
    800061f0:	f022                	sd	s0,32(sp)
    800061f2:	ec26                	sd	s1,24(sp)
    800061f4:	e84a                	sd	s2,16(sp)
    800061f6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800061f8:	c219                	beqz	a2,800061fe <printint+0x12>
    800061fa:	08054763          	bltz	a0,80006288 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800061fe:	2501                	sext.w	a0,a0
    80006200:	4881                	li	a7,0
    80006202:	fd040693          	addi	a3,s0,-48

  i = 0;
    80006206:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80006208:	2581                	sext.w	a1,a1
    8000620a:	00002617          	auipc	a2,0x2
    8000620e:	61e60613          	addi	a2,a2,1566 # 80008828 <digits>
    80006212:	883a                	mv	a6,a4
    80006214:	2705                	addiw	a4,a4,1
    80006216:	02b577bb          	remuw	a5,a0,a1
    8000621a:	1782                	slli	a5,a5,0x20
    8000621c:	9381                	srli	a5,a5,0x20
    8000621e:	97b2                	add	a5,a5,a2
    80006220:	0007c783          	lbu	a5,0(a5)
    80006224:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80006228:	0005079b          	sext.w	a5,a0
    8000622c:	02b5553b          	divuw	a0,a0,a1
    80006230:	0685                	addi	a3,a3,1
    80006232:	feb7f0e3          	bgeu	a5,a1,80006212 <printint+0x26>

  if(sign)
    80006236:	00088c63          	beqz	a7,8000624e <printint+0x62>
    buf[i++] = '-';
    8000623a:	fe070793          	addi	a5,a4,-32
    8000623e:	00878733          	add	a4,a5,s0
    80006242:	02d00793          	li	a5,45
    80006246:	fef70823          	sb	a5,-16(a4)
    8000624a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    8000624e:	02e05763          	blez	a4,8000627c <printint+0x90>
    80006252:	fd040793          	addi	a5,s0,-48
    80006256:	00e784b3          	add	s1,a5,a4
    8000625a:	fff78913          	addi	s2,a5,-1
    8000625e:	993a                	add	s2,s2,a4
    80006260:	377d                	addiw	a4,a4,-1
    80006262:	1702                	slli	a4,a4,0x20
    80006264:	9301                	srli	a4,a4,0x20
    80006266:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000626a:	fff4c503          	lbu	a0,-1(s1)
    8000626e:	00000097          	auipc	ra,0x0
    80006272:	d5e080e7          	jalr	-674(ra) # 80005fcc <consputc>
  while(--i >= 0)
    80006276:	14fd                	addi	s1,s1,-1
    80006278:	ff2499e3          	bne	s1,s2,8000626a <printint+0x7e>
}
    8000627c:	70a2                	ld	ra,40(sp)
    8000627e:	7402                	ld	s0,32(sp)
    80006280:	64e2                	ld	s1,24(sp)
    80006282:	6942                	ld	s2,16(sp)
    80006284:	6145                	addi	sp,sp,48
    80006286:	8082                	ret
    x = -xx;
    80006288:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000628c:	4885                	li	a7,1
    x = -xx;
    8000628e:	bf95                	j	80006202 <printint+0x16>

0000000080006290 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006290:	1101                	addi	sp,sp,-32
    80006292:	ec06                	sd	ra,24(sp)
    80006294:	e822                	sd	s0,16(sp)
    80006296:	e426                	sd	s1,8(sp)
    80006298:	1000                	addi	s0,sp,32
    8000629a:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000629c:	00021797          	auipc	a5,0x21
    800062a0:	8e07aa23          	sw	zero,-1804(a5) # 80026b90 <pr+0x20>
  printf("panic: ");
    800062a4:	00002517          	auipc	a0,0x2
    800062a8:	57450513          	addi	a0,a0,1396 # 80008818 <digits+0x20>
    800062ac:	00000097          	auipc	ra,0x0
    800062b0:	02e080e7          	jalr	46(ra) # 800062da <printf>
  printf(s);
    800062b4:	8526                	mv	a0,s1
    800062b6:	00000097          	auipc	ra,0x0
    800062ba:	024080e7          	jalr	36(ra) # 800062da <printf>
  printf("\n");
    800062be:	00002517          	auipc	a0,0x2
    800062c2:	5f250513          	addi	a0,a0,1522 # 800088b0 <digits+0x88>
    800062c6:	00000097          	auipc	ra,0x0
    800062ca:	014080e7          	jalr	20(ra) # 800062da <printf>
  panicked = 1; // freeze uart output from other CPUs
    800062ce:	4785                	li	a5,1
    800062d0:	00002717          	auipc	a4,0x2
    800062d4:	6cf72e23          	sw	a5,1756(a4) # 800089ac <panicked>
  for(;;)
    800062d8:	a001                	j	800062d8 <panic+0x48>

00000000800062da <printf>:
{
    800062da:	7131                	addi	sp,sp,-192
    800062dc:	fc86                	sd	ra,120(sp)
    800062de:	f8a2                	sd	s0,112(sp)
    800062e0:	f4a6                	sd	s1,104(sp)
    800062e2:	f0ca                	sd	s2,96(sp)
    800062e4:	ecce                	sd	s3,88(sp)
    800062e6:	e8d2                	sd	s4,80(sp)
    800062e8:	e4d6                	sd	s5,72(sp)
    800062ea:	e0da                	sd	s6,64(sp)
    800062ec:	fc5e                	sd	s7,56(sp)
    800062ee:	f862                	sd	s8,48(sp)
    800062f0:	f466                	sd	s9,40(sp)
    800062f2:	f06a                	sd	s10,32(sp)
    800062f4:	ec6e                	sd	s11,24(sp)
    800062f6:	0100                	addi	s0,sp,128
    800062f8:	8a2a                	mv	s4,a0
    800062fa:	e40c                	sd	a1,8(s0)
    800062fc:	e810                	sd	a2,16(s0)
    800062fe:	ec14                	sd	a3,24(s0)
    80006300:	f018                	sd	a4,32(s0)
    80006302:	f41c                	sd	a5,40(s0)
    80006304:	03043823          	sd	a6,48(s0)
    80006308:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    8000630c:	00021d97          	auipc	s11,0x21
    80006310:	884dad83          	lw	s11,-1916(s11) # 80026b90 <pr+0x20>
  if(locking)
    80006314:	020d9b63          	bnez	s11,8000634a <printf+0x70>
  if (fmt == 0)
    80006318:	040a0263          	beqz	s4,8000635c <printf+0x82>
  va_start(ap, fmt);
    8000631c:	00840793          	addi	a5,s0,8
    80006320:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006324:	000a4503          	lbu	a0,0(s4)
    80006328:	14050f63          	beqz	a0,80006486 <printf+0x1ac>
    8000632c:	4981                	li	s3,0
    if(c != '%'){
    8000632e:	02500a93          	li	s5,37
    switch(c){
    80006332:	07000b93          	li	s7,112
  consputc('x');
    80006336:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006338:	00002b17          	auipc	s6,0x2
    8000633c:	4f0b0b13          	addi	s6,s6,1264 # 80008828 <digits>
    switch(c){
    80006340:	07300c93          	li	s9,115
    80006344:	06400c13          	li	s8,100
    80006348:	a82d                	j	80006382 <printf+0xa8>
    acquire(&pr.lock);
    8000634a:	00021517          	auipc	a0,0x21
    8000634e:	82650513          	addi	a0,a0,-2010 # 80026b70 <pr>
    80006352:	00000097          	auipc	ra,0x0
    80006356:	460080e7          	jalr	1120(ra) # 800067b2 <acquire>
    8000635a:	bf7d                	j	80006318 <printf+0x3e>
    panic("null fmt");
    8000635c:	00002517          	auipc	a0,0x2
    80006360:	48c50513          	addi	a0,a0,1164 # 800087e8 <syscalls+0x418>
    80006364:	00000097          	auipc	ra,0x0
    80006368:	f2c080e7          	jalr	-212(ra) # 80006290 <panic>
      consputc(c);
    8000636c:	00000097          	auipc	ra,0x0
    80006370:	c60080e7          	jalr	-928(ra) # 80005fcc <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006374:	2985                	addiw	s3,s3,1
    80006376:	013a07b3          	add	a5,s4,s3
    8000637a:	0007c503          	lbu	a0,0(a5)
    8000637e:	10050463          	beqz	a0,80006486 <printf+0x1ac>
    if(c != '%'){
    80006382:	ff5515e3          	bne	a0,s5,8000636c <printf+0x92>
    c = fmt[++i] & 0xff;
    80006386:	2985                	addiw	s3,s3,1
    80006388:	013a07b3          	add	a5,s4,s3
    8000638c:	0007c783          	lbu	a5,0(a5)
    80006390:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006394:	cbed                	beqz	a5,80006486 <printf+0x1ac>
    switch(c){
    80006396:	05778a63          	beq	a5,s7,800063ea <printf+0x110>
    8000639a:	02fbf663          	bgeu	s7,a5,800063c6 <printf+0xec>
    8000639e:	09978863          	beq	a5,s9,8000642e <printf+0x154>
    800063a2:	07800713          	li	a4,120
    800063a6:	0ce79563          	bne	a5,a4,80006470 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    800063aa:	f8843783          	ld	a5,-120(s0)
    800063ae:	00878713          	addi	a4,a5,8
    800063b2:	f8e43423          	sd	a4,-120(s0)
    800063b6:	4605                	li	a2,1
    800063b8:	85ea                	mv	a1,s10
    800063ba:	4388                	lw	a0,0(a5)
    800063bc:	00000097          	auipc	ra,0x0
    800063c0:	e30080e7          	jalr	-464(ra) # 800061ec <printint>
      break;
    800063c4:	bf45                	j	80006374 <printf+0x9a>
    switch(c){
    800063c6:	09578f63          	beq	a5,s5,80006464 <printf+0x18a>
    800063ca:	0b879363          	bne	a5,s8,80006470 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    800063ce:	f8843783          	ld	a5,-120(s0)
    800063d2:	00878713          	addi	a4,a5,8
    800063d6:	f8e43423          	sd	a4,-120(s0)
    800063da:	4605                	li	a2,1
    800063dc:	45a9                	li	a1,10
    800063de:	4388                	lw	a0,0(a5)
    800063e0:	00000097          	auipc	ra,0x0
    800063e4:	e0c080e7          	jalr	-500(ra) # 800061ec <printint>
      break;
    800063e8:	b771                	j	80006374 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800063ea:	f8843783          	ld	a5,-120(s0)
    800063ee:	00878713          	addi	a4,a5,8
    800063f2:	f8e43423          	sd	a4,-120(s0)
    800063f6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800063fa:	03000513          	li	a0,48
    800063fe:	00000097          	auipc	ra,0x0
    80006402:	bce080e7          	jalr	-1074(ra) # 80005fcc <consputc>
  consputc('x');
    80006406:	07800513          	li	a0,120
    8000640a:	00000097          	auipc	ra,0x0
    8000640e:	bc2080e7          	jalr	-1086(ra) # 80005fcc <consputc>
    80006412:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006414:	03c95793          	srli	a5,s2,0x3c
    80006418:	97da                	add	a5,a5,s6
    8000641a:	0007c503          	lbu	a0,0(a5)
    8000641e:	00000097          	auipc	ra,0x0
    80006422:	bae080e7          	jalr	-1106(ra) # 80005fcc <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006426:	0912                	slli	s2,s2,0x4
    80006428:	34fd                	addiw	s1,s1,-1
    8000642a:	f4ed                	bnez	s1,80006414 <printf+0x13a>
    8000642c:	b7a1                	j	80006374 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    8000642e:	f8843783          	ld	a5,-120(s0)
    80006432:	00878713          	addi	a4,a5,8
    80006436:	f8e43423          	sd	a4,-120(s0)
    8000643a:	6384                	ld	s1,0(a5)
    8000643c:	cc89                	beqz	s1,80006456 <printf+0x17c>
      for(; *s; s++)
    8000643e:	0004c503          	lbu	a0,0(s1)
    80006442:	d90d                	beqz	a0,80006374 <printf+0x9a>
        consputc(*s);
    80006444:	00000097          	auipc	ra,0x0
    80006448:	b88080e7          	jalr	-1144(ra) # 80005fcc <consputc>
      for(; *s; s++)
    8000644c:	0485                	addi	s1,s1,1
    8000644e:	0004c503          	lbu	a0,0(s1)
    80006452:	f96d                	bnez	a0,80006444 <printf+0x16a>
    80006454:	b705                	j	80006374 <printf+0x9a>
        s = "(null)";
    80006456:	00002497          	auipc	s1,0x2
    8000645a:	38a48493          	addi	s1,s1,906 # 800087e0 <syscalls+0x410>
      for(; *s; s++)
    8000645e:	02800513          	li	a0,40
    80006462:	b7cd                	j	80006444 <printf+0x16a>
      consputc('%');
    80006464:	8556                	mv	a0,s5
    80006466:	00000097          	auipc	ra,0x0
    8000646a:	b66080e7          	jalr	-1178(ra) # 80005fcc <consputc>
      break;
    8000646e:	b719                	j	80006374 <printf+0x9a>
      consputc('%');
    80006470:	8556                	mv	a0,s5
    80006472:	00000097          	auipc	ra,0x0
    80006476:	b5a080e7          	jalr	-1190(ra) # 80005fcc <consputc>
      consputc(c);
    8000647a:	8526                	mv	a0,s1
    8000647c:	00000097          	auipc	ra,0x0
    80006480:	b50080e7          	jalr	-1200(ra) # 80005fcc <consputc>
      break;
    80006484:	bdc5                	j	80006374 <printf+0x9a>
  if(locking)
    80006486:	020d9163          	bnez	s11,800064a8 <printf+0x1ce>
}
    8000648a:	70e6                	ld	ra,120(sp)
    8000648c:	7446                	ld	s0,112(sp)
    8000648e:	74a6                	ld	s1,104(sp)
    80006490:	7906                	ld	s2,96(sp)
    80006492:	69e6                	ld	s3,88(sp)
    80006494:	6a46                	ld	s4,80(sp)
    80006496:	6aa6                	ld	s5,72(sp)
    80006498:	6b06                	ld	s6,64(sp)
    8000649a:	7be2                	ld	s7,56(sp)
    8000649c:	7c42                	ld	s8,48(sp)
    8000649e:	7ca2                	ld	s9,40(sp)
    800064a0:	7d02                	ld	s10,32(sp)
    800064a2:	6de2                	ld	s11,24(sp)
    800064a4:	6129                	addi	sp,sp,192
    800064a6:	8082                	ret
    release(&pr.lock);
    800064a8:	00020517          	auipc	a0,0x20
    800064ac:	6c850513          	addi	a0,a0,1736 # 80026b70 <pr>
    800064b0:	00000097          	auipc	ra,0x0
    800064b4:	3d2080e7          	jalr	978(ra) # 80006882 <release>
}
    800064b8:	bfc9                	j	8000648a <printf+0x1b0>

00000000800064ba <printfinit>:
    ;
}

void
printfinit(void)
{
    800064ba:	1101                	addi	sp,sp,-32
    800064bc:	ec06                	sd	ra,24(sp)
    800064be:	e822                	sd	s0,16(sp)
    800064c0:	e426                	sd	s1,8(sp)
    800064c2:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800064c4:	00020497          	auipc	s1,0x20
    800064c8:	6ac48493          	addi	s1,s1,1708 # 80026b70 <pr>
    800064cc:	00002597          	auipc	a1,0x2
    800064d0:	35458593          	addi	a1,a1,852 # 80008820 <digits+0x28>
    800064d4:	8526                	mv	a0,s1
    800064d6:	00000097          	auipc	ra,0x0
    800064da:	458080e7          	jalr	1112(ra) # 8000692e <initlock>
  pr.locking = 1;
    800064de:	4785                	li	a5,1
    800064e0:	d09c                	sw	a5,32(s1)
}
    800064e2:	60e2                	ld	ra,24(sp)
    800064e4:	6442                	ld	s0,16(sp)
    800064e6:	64a2                	ld	s1,8(sp)
    800064e8:	6105                	addi	sp,sp,32
    800064ea:	8082                	ret

00000000800064ec <uartinit>:

void uartstart();

void
uartinit(void)
{
    800064ec:	1141                	addi	sp,sp,-16
    800064ee:	e406                	sd	ra,8(sp)
    800064f0:	e022                	sd	s0,0(sp)
    800064f2:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800064f4:	100007b7          	lui	a5,0x10000
    800064f8:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800064fc:	f8000713          	li	a4,-128
    80006500:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006504:	470d                	li	a4,3
    80006506:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000650a:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000650e:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006512:	469d                	li	a3,7
    80006514:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006518:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000651c:	00002597          	auipc	a1,0x2
    80006520:	32458593          	addi	a1,a1,804 # 80008840 <digits+0x18>
    80006524:	00020517          	auipc	a0,0x20
    80006528:	67450513          	addi	a0,a0,1652 # 80026b98 <uart_tx_lock>
    8000652c:	00000097          	auipc	ra,0x0
    80006530:	402080e7          	jalr	1026(ra) # 8000692e <initlock>
}
    80006534:	60a2                	ld	ra,8(sp)
    80006536:	6402                	ld	s0,0(sp)
    80006538:	0141                	addi	sp,sp,16
    8000653a:	8082                	ret

000000008000653c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000653c:	1101                	addi	sp,sp,-32
    8000653e:	ec06                	sd	ra,24(sp)
    80006540:	e822                	sd	s0,16(sp)
    80006542:	e426                	sd	s1,8(sp)
    80006544:	1000                	addi	s0,sp,32
    80006546:	84aa                	mv	s1,a0
  push_off();
    80006548:	00000097          	auipc	ra,0x0
    8000654c:	21e080e7          	jalr	542(ra) # 80006766 <push_off>

  if(panicked){
    80006550:	00002797          	auipc	a5,0x2
    80006554:	45c7a783          	lw	a5,1116(a5) # 800089ac <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006558:	10000737          	lui	a4,0x10000
  if(panicked){
    8000655c:	c391                	beqz	a5,80006560 <uartputc_sync+0x24>
    for(;;)
    8000655e:	a001                	j	8000655e <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006560:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006564:	0207f793          	andi	a5,a5,32
    80006568:	dfe5                	beqz	a5,80006560 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000656a:	0ff4f513          	zext.b	a0,s1
    8000656e:	100007b7          	lui	a5,0x10000
    80006572:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006576:	00000097          	auipc	ra,0x0
    8000657a:	2ac080e7          	jalr	684(ra) # 80006822 <pop_off>
}
    8000657e:	60e2                	ld	ra,24(sp)
    80006580:	6442                	ld	s0,16(sp)
    80006582:	64a2                	ld	s1,8(sp)
    80006584:	6105                	addi	sp,sp,32
    80006586:	8082                	ret

0000000080006588 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006588:	00002797          	auipc	a5,0x2
    8000658c:	4287b783          	ld	a5,1064(a5) # 800089b0 <uart_tx_r>
    80006590:	00002717          	auipc	a4,0x2
    80006594:	42873703          	ld	a4,1064(a4) # 800089b8 <uart_tx_w>
    80006598:	06f70a63          	beq	a4,a5,8000660c <uartstart+0x84>
{
    8000659c:	7139                	addi	sp,sp,-64
    8000659e:	fc06                	sd	ra,56(sp)
    800065a0:	f822                	sd	s0,48(sp)
    800065a2:	f426                	sd	s1,40(sp)
    800065a4:	f04a                	sd	s2,32(sp)
    800065a6:	ec4e                	sd	s3,24(sp)
    800065a8:	e852                	sd	s4,16(sp)
    800065aa:	e456                	sd	s5,8(sp)
    800065ac:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800065ae:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800065b2:	00020a17          	auipc	s4,0x20
    800065b6:	5e6a0a13          	addi	s4,s4,1510 # 80026b98 <uart_tx_lock>
    uart_tx_r += 1;
    800065ba:	00002497          	auipc	s1,0x2
    800065be:	3f648493          	addi	s1,s1,1014 # 800089b0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800065c2:	00002997          	auipc	s3,0x2
    800065c6:	3f698993          	addi	s3,s3,1014 # 800089b8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800065ca:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800065ce:	02077713          	andi	a4,a4,32
    800065d2:	c705                	beqz	a4,800065fa <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800065d4:	01f7f713          	andi	a4,a5,31
    800065d8:	9752                	add	a4,a4,s4
    800065da:	02074a83          	lbu	s5,32(a4)
    uart_tx_r += 1;
    800065de:	0785                	addi	a5,a5,1
    800065e0:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800065e2:	8526                	mv	a0,s1
    800065e4:	ffffb097          	auipc	ra,0xffffb
    800065e8:	098080e7          	jalr	152(ra) # 8000167c <wakeup>
    
    WriteReg(THR, c);
    800065ec:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800065f0:	609c                	ld	a5,0(s1)
    800065f2:	0009b703          	ld	a4,0(s3)
    800065f6:	fcf71ae3          	bne	a4,a5,800065ca <uartstart+0x42>
  }
}
    800065fa:	70e2                	ld	ra,56(sp)
    800065fc:	7442                	ld	s0,48(sp)
    800065fe:	74a2                	ld	s1,40(sp)
    80006600:	7902                	ld	s2,32(sp)
    80006602:	69e2                	ld	s3,24(sp)
    80006604:	6a42                	ld	s4,16(sp)
    80006606:	6aa2                	ld	s5,8(sp)
    80006608:	6121                	addi	sp,sp,64
    8000660a:	8082                	ret
    8000660c:	8082                	ret

000000008000660e <uartputc>:
{
    8000660e:	7179                	addi	sp,sp,-48
    80006610:	f406                	sd	ra,40(sp)
    80006612:	f022                	sd	s0,32(sp)
    80006614:	ec26                	sd	s1,24(sp)
    80006616:	e84a                	sd	s2,16(sp)
    80006618:	e44e                	sd	s3,8(sp)
    8000661a:	e052                	sd	s4,0(sp)
    8000661c:	1800                	addi	s0,sp,48
    8000661e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006620:	00020517          	auipc	a0,0x20
    80006624:	57850513          	addi	a0,a0,1400 # 80026b98 <uart_tx_lock>
    80006628:	00000097          	auipc	ra,0x0
    8000662c:	18a080e7          	jalr	394(ra) # 800067b2 <acquire>
  if(panicked){
    80006630:	00002797          	auipc	a5,0x2
    80006634:	37c7a783          	lw	a5,892(a5) # 800089ac <panicked>
    80006638:	e7c9                	bnez	a5,800066c2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000663a:	00002717          	auipc	a4,0x2
    8000663e:	37e73703          	ld	a4,894(a4) # 800089b8 <uart_tx_w>
    80006642:	00002797          	auipc	a5,0x2
    80006646:	36e7b783          	ld	a5,878(a5) # 800089b0 <uart_tx_r>
    8000664a:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000664e:	00020997          	auipc	s3,0x20
    80006652:	54a98993          	addi	s3,s3,1354 # 80026b98 <uart_tx_lock>
    80006656:	00002497          	auipc	s1,0x2
    8000665a:	35a48493          	addi	s1,s1,858 # 800089b0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000665e:	00002917          	auipc	s2,0x2
    80006662:	35a90913          	addi	s2,s2,858 # 800089b8 <uart_tx_w>
    80006666:	00e79f63          	bne	a5,a4,80006684 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000666a:	85ce                	mv	a1,s3
    8000666c:	8526                	mv	a0,s1
    8000666e:	ffffb097          	auipc	ra,0xffffb
    80006672:	faa080e7          	jalr	-86(ra) # 80001618 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006676:	00093703          	ld	a4,0(s2)
    8000667a:	609c                	ld	a5,0(s1)
    8000667c:	02078793          	addi	a5,a5,32
    80006680:	fee785e3          	beq	a5,a4,8000666a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006684:	00020497          	auipc	s1,0x20
    80006688:	51448493          	addi	s1,s1,1300 # 80026b98 <uart_tx_lock>
    8000668c:	01f77793          	andi	a5,a4,31
    80006690:	97a6                	add	a5,a5,s1
    80006692:	03478023          	sb	s4,32(a5)
  uart_tx_w += 1;
    80006696:	0705                	addi	a4,a4,1
    80006698:	00002797          	auipc	a5,0x2
    8000669c:	32e7b023          	sd	a4,800(a5) # 800089b8 <uart_tx_w>
  uartstart();
    800066a0:	00000097          	auipc	ra,0x0
    800066a4:	ee8080e7          	jalr	-280(ra) # 80006588 <uartstart>
  release(&uart_tx_lock);
    800066a8:	8526                	mv	a0,s1
    800066aa:	00000097          	auipc	ra,0x0
    800066ae:	1d8080e7          	jalr	472(ra) # 80006882 <release>
}
    800066b2:	70a2                	ld	ra,40(sp)
    800066b4:	7402                	ld	s0,32(sp)
    800066b6:	64e2                	ld	s1,24(sp)
    800066b8:	6942                	ld	s2,16(sp)
    800066ba:	69a2                	ld	s3,8(sp)
    800066bc:	6a02                	ld	s4,0(sp)
    800066be:	6145                	addi	sp,sp,48
    800066c0:	8082                	ret
    for(;;)
    800066c2:	a001                	j	800066c2 <uartputc+0xb4>

00000000800066c4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800066c4:	1141                	addi	sp,sp,-16
    800066c6:	e422                	sd	s0,8(sp)
    800066c8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800066ca:	100007b7          	lui	a5,0x10000
    800066ce:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800066d2:	8b85                	andi	a5,a5,1
    800066d4:	cb81                	beqz	a5,800066e4 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800066d6:	100007b7          	lui	a5,0x10000
    800066da:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800066de:	6422                	ld	s0,8(sp)
    800066e0:	0141                	addi	sp,sp,16
    800066e2:	8082                	ret
    return -1;
    800066e4:	557d                	li	a0,-1
    800066e6:	bfe5                	j	800066de <uartgetc+0x1a>

00000000800066e8 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800066e8:	1101                	addi	sp,sp,-32
    800066ea:	ec06                	sd	ra,24(sp)
    800066ec:	e822                	sd	s0,16(sp)
    800066ee:	e426                	sd	s1,8(sp)
    800066f0:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800066f2:	54fd                	li	s1,-1
    800066f4:	a029                	j	800066fe <uartintr+0x16>
      break;
    consoleintr(c);
    800066f6:	00000097          	auipc	ra,0x0
    800066fa:	918080e7          	jalr	-1768(ra) # 8000600e <consoleintr>
    int c = uartgetc();
    800066fe:	00000097          	auipc	ra,0x0
    80006702:	fc6080e7          	jalr	-58(ra) # 800066c4 <uartgetc>
    if(c == -1)
    80006706:	fe9518e3          	bne	a0,s1,800066f6 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000670a:	00020497          	auipc	s1,0x20
    8000670e:	48e48493          	addi	s1,s1,1166 # 80026b98 <uart_tx_lock>
    80006712:	8526                	mv	a0,s1
    80006714:	00000097          	auipc	ra,0x0
    80006718:	09e080e7          	jalr	158(ra) # 800067b2 <acquire>
  uartstart();
    8000671c:	00000097          	auipc	ra,0x0
    80006720:	e6c080e7          	jalr	-404(ra) # 80006588 <uartstart>
  release(&uart_tx_lock);
    80006724:	8526                	mv	a0,s1
    80006726:	00000097          	auipc	ra,0x0
    8000672a:	15c080e7          	jalr	348(ra) # 80006882 <release>
}
    8000672e:	60e2                	ld	ra,24(sp)
    80006730:	6442                	ld	s0,16(sp)
    80006732:	64a2                	ld	s1,8(sp)
    80006734:	6105                	addi	sp,sp,32
    80006736:	8082                	ret

0000000080006738 <holding>:
// Check whether this cpu is holding the lock.
// Interrupts must be off.
int holding(struct spinlock *lk)
{
    int r;
    r = (lk->locked && lk->cpu == mycpu());
    80006738:	411c                	lw	a5,0(a0)
    8000673a:	e399                	bnez	a5,80006740 <holding+0x8>
    8000673c:	4501                	li	a0,0
    return r;
}
    8000673e:	8082                	ret
{
    80006740:	1101                	addi	sp,sp,-32
    80006742:	ec06                	sd	ra,24(sp)
    80006744:	e822                	sd	s0,16(sp)
    80006746:	e426                	sd	s1,8(sp)
    80006748:	1000                	addi	s0,sp,32
    r = (lk->locked && lk->cpu == mycpu());
    8000674a:	6904                	ld	s1,16(a0)
    8000674c:	ffffb097          	auipc	ra,0xffffb
    80006750:	808080e7          	jalr	-2040(ra) # 80000f54 <mycpu>
    80006754:	40a48533          	sub	a0,s1,a0
    80006758:	00153513          	seqz	a0,a0
}
    8000675c:	60e2                	ld	ra,24(sp)
    8000675e:	6442                	ld	s0,16(sp)
    80006760:	64a2                	ld	s1,8(sp)
    80006762:	6105                	addi	sp,sp,32
    80006764:	8082                	ret

0000000080006766 <push_off>:
// push_off/pop_off are like intr_off()/intr_on() except that they are matched:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void push_off(void)
{
    80006766:	1101                	addi	sp,sp,-32
    80006768:	ec06                	sd	ra,24(sp)
    8000676a:	e822                	sd	s0,16(sp)
    8000676c:	e426                	sd	s1,8(sp)
    8000676e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006770:	100024f3          	csrr	s1,sstatus
    80006774:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006778:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000677a:	10079073          	csrw	sstatus,a5
    int old = intr_get();

    intr_off();
    if (mycpu()->noff == 0)
    8000677e:	ffffa097          	auipc	ra,0xffffa
    80006782:	7d6080e7          	jalr	2006(ra) # 80000f54 <mycpu>
    80006786:	5d3c                	lw	a5,120(a0)
    80006788:	cf89                	beqz	a5,800067a2 <push_off+0x3c>
        mycpu()->intena = old;
    mycpu()->noff += 1;
    8000678a:	ffffa097          	auipc	ra,0xffffa
    8000678e:	7ca080e7          	jalr	1994(ra) # 80000f54 <mycpu>
    80006792:	5d3c                	lw	a5,120(a0)
    80006794:	2785                	addiw	a5,a5,1
    80006796:	dd3c                	sw	a5,120(a0)
}
    80006798:	60e2                	ld	ra,24(sp)
    8000679a:	6442                	ld	s0,16(sp)
    8000679c:	64a2                	ld	s1,8(sp)
    8000679e:	6105                	addi	sp,sp,32
    800067a0:	8082                	ret
        mycpu()->intena = old;
    800067a2:	ffffa097          	auipc	ra,0xffffa
    800067a6:	7b2080e7          	jalr	1970(ra) # 80000f54 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800067aa:	8085                	srli	s1,s1,0x1
    800067ac:	8885                	andi	s1,s1,1
    800067ae:	dd64                	sw	s1,124(a0)
    800067b0:	bfe9                	j	8000678a <push_off+0x24>

00000000800067b2 <acquire>:
{
    800067b2:	1101                	addi	sp,sp,-32
    800067b4:	ec06                	sd	ra,24(sp)
    800067b6:	e822                	sd	s0,16(sp)
    800067b8:	e426                	sd	s1,8(sp)
    800067ba:	1000                	addi	s0,sp,32
    800067bc:	84aa                	mv	s1,a0
    push_off(); // disable interrupts to avoid deadlock.
    800067be:	00000097          	auipc	ra,0x0
    800067c2:	fa8080e7          	jalr	-88(ra) # 80006766 <push_off>
    if (holding(lk))
    800067c6:	8526                	mv	a0,s1
    800067c8:	00000097          	auipc	ra,0x0
    800067cc:	f70080e7          	jalr	-144(ra) # 80006738 <holding>
    800067d0:	e911                	bnez	a0,800067e4 <acquire+0x32>
    __sync_fetch_and_add(&(lk->n), 1);
    800067d2:	4785                	li	a5,1
    800067d4:	01c48713          	addi	a4,s1,28
    800067d8:	0f50000f          	fence	iorw,ow
    800067dc:	04f7202f          	amoadd.w.aq	zero,a5,(a4)
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    800067e0:	4705                	li	a4,1
    800067e2:	a839                	j	80006800 <acquire+0x4e>
        panic("acquire");
    800067e4:	00002517          	auipc	a0,0x2
    800067e8:	06450513          	addi	a0,a0,100 # 80008848 <digits+0x20>
    800067ec:	00000097          	auipc	ra,0x0
    800067f0:	aa4080e7          	jalr	-1372(ra) # 80006290 <panic>
        __sync_fetch_and_add(&(lk->nts), 1);
    800067f4:	01848793          	addi	a5,s1,24
    800067f8:	0f50000f          	fence	iorw,ow
    800067fc:	04e7a02f          	amoadd.w.aq	zero,a4,(a5)
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80006800:	87ba                	mv	a5,a4
    80006802:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006806:	2781                	sext.w	a5,a5
    80006808:	f7f5                	bnez	a5,800067f4 <acquire+0x42>
    __sync_synchronize();
    8000680a:	0ff0000f          	fence
    lk->cpu = mycpu();
    8000680e:	ffffa097          	auipc	ra,0xffffa
    80006812:	746080e7          	jalr	1862(ra) # 80000f54 <mycpu>
    80006816:	e888                	sd	a0,16(s1)
}
    80006818:	60e2                	ld	ra,24(sp)
    8000681a:	6442                	ld	s0,16(sp)
    8000681c:	64a2                	ld	s1,8(sp)
    8000681e:	6105                	addi	sp,sp,32
    80006820:	8082                	ret

0000000080006822 <pop_off>:

void pop_off(void)
{
    80006822:	1141                	addi	sp,sp,-16
    80006824:	e406                	sd	ra,8(sp)
    80006826:	e022                	sd	s0,0(sp)
    80006828:	0800                	addi	s0,sp,16
    struct cpu *c = mycpu();
    8000682a:	ffffa097          	auipc	ra,0xffffa
    8000682e:	72a080e7          	jalr	1834(ra) # 80000f54 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006832:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006836:	8b89                	andi	a5,a5,2
    if (intr_get())
    80006838:	e78d                	bnez	a5,80006862 <pop_off+0x40>
        panic("pop_off - interruptible");
    if (c->noff < 1)
    8000683a:	5d3c                	lw	a5,120(a0)
    8000683c:	02f05b63          	blez	a5,80006872 <pop_off+0x50>
        panic("pop_off");
    c->noff -= 1;
    80006840:	37fd                	addiw	a5,a5,-1
    80006842:	0007871b          	sext.w	a4,a5
    80006846:	dd3c                	sw	a5,120(a0)
    if (c->noff == 0 && c->intena)
    80006848:	eb09                	bnez	a4,8000685a <pop_off+0x38>
    8000684a:	5d7c                	lw	a5,124(a0)
    8000684c:	c799                	beqz	a5,8000685a <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000684e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006852:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006856:	10079073          	csrw	sstatus,a5
        intr_on();
}
    8000685a:	60a2                	ld	ra,8(sp)
    8000685c:	6402                	ld	s0,0(sp)
    8000685e:	0141                	addi	sp,sp,16
    80006860:	8082                	ret
        panic("pop_off - interruptible");
    80006862:	00002517          	auipc	a0,0x2
    80006866:	fee50513          	addi	a0,a0,-18 # 80008850 <digits+0x28>
    8000686a:	00000097          	auipc	ra,0x0
    8000686e:	a26080e7          	jalr	-1498(ra) # 80006290 <panic>
        panic("pop_off");
    80006872:	00002517          	auipc	a0,0x2
    80006876:	ff650513          	addi	a0,a0,-10 # 80008868 <digits+0x40>
    8000687a:	00000097          	auipc	ra,0x0
    8000687e:	a16080e7          	jalr	-1514(ra) # 80006290 <panic>

0000000080006882 <release>:
{
    80006882:	1101                	addi	sp,sp,-32
    80006884:	ec06                	sd	ra,24(sp)
    80006886:	e822                	sd	s0,16(sp)
    80006888:	e426                	sd	s1,8(sp)
    8000688a:	1000                	addi	s0,sp,32
    8000688c:	84aa                	mv	s1,a0
    if (!holding(lk))
    8000688e:	00000097          	auipc	ra,0x0
    80006892:	eaa080e7          	jalr	-342(ra) # 80006738 <holding>
    80006896:	c115                	beqz	a0,800068ba <release+0x38>
    lk->cpu = 0;
    80006898:	0004b823          	sd	zero,16(s1)
    __sync_synchronize();
    8000689c:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
    800068a0:	0f50000f          	fence	iorw,ow
    800068a4:	0804a02f          	amoswap.w	zero,zero,(s1)
    pop_off();
    800068a8:	00000097          	auipc	ra,0x0
    800068ac:	f7a080e7          	jalr	-134(ra) # 80006822 <pop_off>
}
    800068b0:	60e2                	ld	ra,24(sp)
    800068b2:	6442                	ld	s0,16(sp)
    800068b4:	64a2                	ld	s1,8(sp)
    800068b6:	6105                	addi	sp,sp,32
    800068b8:	8082                	ret
        panic("release");
    800068ba:	00002517          	auipc	a0,0x2
    800068be:	fb650513          	addi	a0,a0,-74 # 80008870 <digits+0x48>
    800068c2:	00000097          	auipc	ra,0x0
    800068c6:	9ce080e7          	jalr	-1586(ra) # 80006290 <panic>

00000000800068ca <freelock>:
{
    800068ca:	1101                	addi	sp,sp,-32
    800068cc:	ec06                	sd	ra,24(sp)
    800068ce:	e822                	sd	s0,16(sp)
    800068d0:	e426                	sd	s1,8(sp)
    800068d2:	1000                	addi	s0,sp,32
    800068d4:	84aa                	mv	s1,a0
    acquire(&lock_locks);
    800068d6:	00020517          	auipc	a0,0x20
    800068da:	30250513          	addi	a0,a0,770 # 80026bd8 <lock_locks>
    800068de:	00000097          	auipc	ra,0x0
    800068e2:	ed4080e7          	jalr	-300(ra) # 800067b2 <acquire>
    for (i = 0; i < NLOCK; i++) {
    800068e6:	00020717          	auipc	a4,0x20
    800068ea:	31270713          	addi	a4,a4,786 # 80026bf8 <locks>
    800068ee:	4781                	li	a5,0
    800068f0:	1f400613          	li	a2,500
        if (locks[i] == lk) {
    800068f4:	6314                	ld	a3,0(a4)
    800068f6:	00968763          	beq	a3,s1,80006904 <freelock+0x3a>
    for (i = 0; i < NLOCK; i++) {
    800068fa:	2785                	addiw	a5,a5,1
    800068fc:	0721                	addi	a4,a4,8
    800068fe:	fec79be3          	bne	a5,a2,800068f4 <freelock+0x2a>
    80006902:	a809                	j	80006914 <freelock+0x4a>
            locks[i] = 0;
    80006904:	078e                	slli	a5,a5,0x3
    80006906:	00020717          	auipc	a4,0x20
    8000690a:	2f270713          	addi	a4,a4,754 # 80026bf8 <locks>
    8000690e:	97ba                	add	a5,a5,a4
    80006910:	0007b023          	sd	zero,0(a5)
    release(&lock_locks);
    80006914:	00020517          	auipc	a0,0x20
    80006918:	2c450513          	addi	a0,a0,708 # 80026bd8 <lock_locks>
    8000691c:	00000097          	auipc	ra,0x0
    80006920:	f66080e7          	jalr	-154(ra) # 80006882 <release>
}
    80006924:	60e2                	ld	ra,24(sp)
    80006926:	6442                	ld	s0,16(sp)
    80006928:	64a2                	ld	s1,8(sp)
    8000692a:	6105                	addi	sp,sp,32
    8000692c:	8082                	ret

000000008000692e <initlock>:
{
    8000692e:	1101                	addi	sp,sp,-32
    80006930:	ec06                	sd	ra,24(sp)
    80006932:	e822                	sd	s0,16(sp)
    80006934:	e426                	sd	s1,8(sp)
    80006936:	1000                	addi	s0,sp,32
    80006938:	84aa                	mv	s1,a0
    lk->name = name;
    8000693a:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
    8000693c:	00052023          	sw	zero,0(a0)
    lk->cpu = 0;
    80006940:	00053823          	sd	zero,16(a0)
    lk->nts = 0;
    80006944:	00052c23          	sw	zero,24(a0)
    lk->n = 0;
    80006948:	00052e23          	sw	zero,28(a0)
    acquire(&lock_locks);
    8000694c:	00020517          	auipc	a0,0x20
    80006950:	28c50513          	addi	a0,a0,652 # 80026bd8 <lock_locks>
    80006954:	00000097          	auipc	ra,0x0
    80006958:	e5e080e7          	jalr	-418(ra) # 800067b2 <acquire>
    for (i = 0; i < NLOCK; i++) {
    8000695c:	00020717          	auipc	a4,0x20
    80006960:	29c70713          	addi	a4,a4,668 # 80026bf8 <locks>
    80006964:	4781                	li	a5,0
    80006966:	1f400613          	li	a2,500
        if (locks[i] == 0) {
    8000696a:	6314                	ld	a3,0(a4)
    8000696c:	ce89                	beqz	a3,80006986 <initlock+0x58>
    for (i = 0; i < NLOCK; i++) {
    8000696e:	2785                	addiw	a5,a5,1
    80006970:	0721                	addi	a4,a4,8
    80006972:	fec79ce3          	bne	a5,a2,8000696a <initlock+0x3c>
    panic("findslot");
    80006976:	00002517          	auipc	a0,0x2
    8000697a:	f0250513          	addi	a0,a0,-254 # 80008878 <digits+0x50>
    8000697e:	00000097          	auipc	ra,0x0
    80006982:	912080e7          	jalr	-1774(ra) # 80006290 <panic>
            locks[i] = lk;
    80006986:	078e                	slli	a5,a5,0x3
    80006988:	00020717          	auipc	a4,0x20
    8000698c:	27070713          	addi	a4,a4,624 # 80026bf8 <locks>
    80006990:	97ba                	add	a5,a5,a4
    80006992:	e384                	sd	s1,0(a5)
            release(&lock_locks);
    80006994:	00020517          	auipc	a0,0x20
    80006998:	24450513          	addi	a0,a0,580 # 80026bd8 <lock_locks>
    8000699c:	00000097          	auipc	ra,0x0
    800069a0:	ee6080e7          	jalr	-282(ra) # 80006882 <release>
}
    800069a4:	60e2                	ld	ra,24(sp)
    800069a6:	6442                	ld	s0,16(sp)
    800069a8:	64a2                	ld	s1,8(sp)
    800069aa:	6105                	addi	sp,sp,32
    800069ac:	8082                	ret

00000000800069ae <atomic_read4>:

// Read a shared 32-bit value without holding a lock
int atomic_read4(int *addr)
{
    800069ae:	1141                	addi	sp,sp,-16
    800069b0:	e422                	sd	s0,8(sp)
    800069b2:	0800                	addi	s0,sp,16
    uint32 val;
    __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    800069b4:	0ff0000f          	fence
    800069b8:	4108                	lw	a0,0(a0)
    800069ba:	0ff0000f          	fence
    return val;
}
    800069be:	6422                	ld	s0,8(sp)
    800069c0:	0141                	addi	sp,sp,16
    800069c2:	8082                	ret

00000000800069c4 <snprint_lock>:

#ifdef LAB_LOCK
int snprint_lock(char *buf, int sz, struct spinlock *lk)
{
    int n = 0;
    if (lk->n > 0) {
    800069c4:	4e5c                	lw	a5,28(a2)
    800069c6:	00f04463          	bgtz	a5,800069ce <snprint_lock+0xa>
    int n = 0;
    800069ca:	4501                	li	a0,0
        n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n", lk->name, lk->nts, lk->n);
    }
    return n;
}
    800069cc:	8082                	ret
{
    800069ce:	1141                	addi	sp,sp,-16
    800069d0:	e406                	sd	ra,8(sp)
    800069d2:	e022                	sd	s0,0(sp)
    800069d4:	0800                	addi	s0,sp,16
        n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n", lk->name, lk->nts, lk->n);
    800069d6:	4e18                	lw	a4,24(a2)
    800069d8:	6614                	ld	a3,8(a2)
    800069da:	00002617          	auipc	a2,0x2
    800069de:	eae60613          	addi	a2,a2,-338 # 80008888 <digits+0x60>
    800069e2:	fffff097          	auipc	ra,0xfffff
    800069e6:	214080e7          	jalr	532(ra) # 80005bf6 <snprintf>
}
    800069ea:	60a2                	ld	ra,8(sp)
    800069ec:	6402                	ld	s0,0(sp)
    800069ee:	0141                	addi	sp,sp,16
    800069f0:	8082                	ret

00000000800069f2 <statslock>:

int statslock(char *buf, int sz)
{
    800069f2:	7159                	addi	sp,sp,-112
    800069f4:	f486                	sd	ra,104(sp)
    800069f6:	f0a2                	sd	s0,96(sp)
    800069f8:	eca6                	sd	s1,88(sp)
    800069fa:	e8ca                	sd	s2,80(sp)
    800069fc:	e4ce                	sd	s3,72(sp)
    800069fe:	e0d2                	sd	s4,64(sp)
    80006a00:	fc56                	sd	s5,56(sp)
    80006a02:	f85a                	sd	s6,48(sp)
    80006a04:	f45e                	sd	s7,40(sp)
    80006a06:	f062                	sd	s8,32(sp)
    80006a08:	ec66                	sd	s9,24(sp)
    80006a0a:	e86a                	sd	s10,16(sp)
    80006a0c:	e46e                	sd	s11,8(sp)
    80006a0e:	1880                	addi	s0,sp,112
    80006a10:	8aaa                	mv	s5,a0
    80006a12:	8b2e                	mv	s6,a1
    int n;
    int tot = 0;

    acquire(&lock_locks);
    80006a14:	00020517          	auipc	a0,0x20
    80006a18:	1c450513          	addi	a0,a0,452 # 80026bd8 <lock_locks>
    80006a1c:	00000097          	auipc	ra,0x0
    80006a20:	d96080e7          	jalr	-618(ra) # 800067b2 <acquire>
    n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    80006a24:	00002617          	auipc	a2,0x2
    80006a28:	e9460613          	addi	a2,a2,-364 # 800088b8 <digits+0x90>
    80006a2c:	85da                	mv	a1,s6
    80006a2e:	8556                	mv	a0,s5
    80006a30:	fffff097          	auipc	ra,0xfffff
    80006a34:	1c6080e7          	jalr	454(ra) # 80005bf6 <snprintf>
    80006a38:	892a                	mv	s2,a0
    for (int i = 0; i < NLOCK; i++) {
    80006a3a:	00020c97          	auipc	s9,0x20
    80006a3e:	1bec8c93          	addi	s9,s9,446 # 80026bf8 <locks>
    80006a42:	00021c17          	auipc	s8,0x21
    80006a46:	156c0c13          	addi	s8,s8,342 # 80027b98 <end>
    n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    80006a4a:	84e6                	mv	s1,s9
    int tot = 0;
    80006a4c:	4a01                	li	s4,0
        if (locks[i] == 0)
            break;
        if (strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 || strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80006a4e:	00002b97          	auipc	s7,0x2
    80006a52:	e8ab8b93          	addi	s7,s7,-374 # 800088d8 <digits+0xb0>
    80006a56:	00002d17          	auipc	s10,0x2
    80006a5a:	e8ad0d13          	addi	s10,s10,-374 # 800088e0 <digits+0xb8>
    80006a5e:	a01d                	j	80006a84 <statslock+0x92>
            tot += locks[i]->nts;
    80006a60:	0009b603          	ld	a2,0(s3)
    80006a64:	4e1c                	lw	a5,24(a2)
    80006a66:	01478a3b          	addw	s4,a5,s4
            n += snprint_lock(buf + n, sz - n, locks[i]);
    80006a6a:	412b05bb          	subw	a1,s6,s2
    80006a6e:	012a8533          	add	a0,s5,s2
    80006a72:	00000097          	auipc	ra,0x0
    80006a76:	f52080e7          	jalr	-174(ra) # 800069c4 <snprint_lock>
    80006a7a:	0125093b          	addw	s2,a0,s2
    for (int i = 0; i < NLOCK; i++) {
    80006a7e:	04a1                	addi	s1,s1,8
    80006a80:	05848763          	beq	s1,s8,80006ace <statslock+0xdc>
        if (locks[i] == 0)
    80006a84:	89a6                	mv	s3,s1
    80006a86:	609c                	ld	a5,0(s1)
    80006a88:	c3b9                	beqz	a5,80006ace <statslock+0xdc>
        if (strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 || strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80006a8a:	0087bd83          	ld	s11,8(a5)
    80006a8e:	855e                	mv	a0,s7
    80006a90:	ffffa097          	auipc	ra,0xffffa
    80006a94:	972080e7          	jalr	-1678(ra) # 80000402 <strlen>
    80006a98:	0005061b          	sext.w	a2,a0
    80006a9c:	85de                	mv	a1,s7
    80006a9e:	856e                	mv	a0,s11
    80006aa0:	ffffa097          	auipc	ra,0xffffa
    80006aa4:	8b6080e7          	jalr	-1866(ra) # 80000356 <strncmp>
    80006aa8:	dd45                	beqz	a0,80006a60 <statslock+0x6e>
    80006aaa:	609c                	ld	a5,0(s1)
    80006aac:	0087bd83          	ld	s11,8(a5)
    80006ab0:	856a                	mv	a0,s10
    80006ab2:	ffffa097          	auipc	ra,0xffffa
    80006ab6:	950080e7          	jalr	-1712(ra) # 80000402 <strlen>
    80006aba:	0005061b          	sext.w	a2,a0
    80006abe:	85ea                	mv	a1,s10
    80006ac0:	856e                	mv	a0,s11
    80006ac2:	ffffa097          	auipc	ra,0xffffa
    80006ac6:	894080e7          	jalr	-1900(ra) # 80000356 <strncmp>
    80006aca:	f955                	bnez	a0,80006a7e <statslock+0x8c>
    80006acc:	bf51                	j	80006a60 <statslock+0x6e>
        }
    }

    n += snprintf(buf + n, sz - n, "--- top 5 contended locks:\n");
    80006ace:	00002617          	auipc	a2,0x2
    80006ad2:	e1a60613          	addi	a2,a2,-486 # 800088e8 <digits+0xc0>
    80006ad6:	412b05bb          	subw	a1,s6,s2
    80006ada:	012a8533          	add	a0,s5,s2
    80006ade:	fffff097          	auipc	ra,0xfffff
    80006ae2:	118080e7          	jalr	280(ra) # 80005bf6 <snprintf>
    80006ae6:	012509bb          	addw	s3,a0,s2
    80006aea:	4b95                	li	s7,5
    int last = 100000000;
    80006aec:	05f5e537          	lui	a0,0x5f5e
    80006af0:	10050513          	addi	a0,a0,256 # 5f5e100 <_entry-0x7a0a1f00>
    // stupid way to compute top 5 contended locks
    for (int t = 0; t < 5; t++) {
        int top = 0;
        for (int i = 0; i < NLOCK; i++) {
    80006af4:	4c01                	li	s8,0
            if (locks[i] == 0)
                break;
            if (locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80006af6:	00020497          	auipc	s1,0x20
    80006afa:	10248493          	addi	s1,s1,258 # 80026bf8 <locks>
        for (int i = 0; i < NLOCK; i++) {
    80006afe:	1f400913          	li	s2,500
    80006b02:	a881                	j	80006b52 <statslock+0x160>
    80006b04:	2705                	addiw	a4,a4,1
    80006b06:	06a1                	addi	a3,a3,8
    80006b08:	03270063          	beq	a4,s2,80006b28 <statslock+0x136>
            if (locks[i] == 0)
    80006b0c:	629c                	ld	a5,0(a3)
    80006b0e:	cf89                	beqz	a5,80006b28 <statslock+0x136>
            if (locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80006b10:	4f90                	lw	a2,24(a5)
    80006b12:	00359793          	slli	a5,a1,0x3
    80006b16:	97a6                	add	a5,a5,s1
    80006b18:	639c                	ld	a5,0(a5)
    80006b1a:	4f9c                	lw	a5,24(a5)
    80006b1c:	fec7d4e3          	bge	a5,a2,80006b04 <statslock+0x112>
    80006b20:	fea652e3          	bge	a2,a0,80006b04 <statslock+0x112>
    80006b24:	85ba                	mv	a1,a4
    80006b26:	bff9                	j	80006b04 <statslock+0x112>
                top = i;
            }
        }
        n += snprint_lock(buf + n, sz - n, locks[top]);
    80006b28:	058e                	slli	a1,a1,0x3
    80006b2a:	00b48d33          	add	s10,s1,a1
    80006b2e:	000d3603          	ld	a2,0(s10)
    80006b32:	413b05bb          	subw	a1,s6,s3
    80006b36:	013a8533          	add	a0,s5,s3
    80006b3a:	00000097          	auipc	ra,0x0
    80006b3e:	e8a080e7          	jalr	-374(ra) # 800069c4 <snprint_lock>
    80006b42:	013509bb          	addw	s3,a0,s3
        last = locks[top]->nts;
    80006b46:	000d3783          	ld	a5,0(s10)
    80006b4a:	4f88                	lw	a0,24(a5)
    for (int t = 0; t < 5; t++) {
    80006b4c:	3bfd                	addiw	s7,s7,-1
    80006b4e:	000b8663          	beqz	s7,80006b5a <statslock+0x168>
    int tot = 0;
    80006b52:	86e6                	mv	a3,s9
        for (int i = 0; i < NLOCK; i++) {
    80006b54:	8762                	mv	a4,s8
        int top = 0;
    80006b56:	85e2                	mv	a1,s8
    80006b58:	bf55                	j	80006b0c <statslock+0x11a>
    }
    n += snprintf(buf + n, sz - n, "tot= %d\n", tot);
    80006b5a:	86d2                	mv	a3,s4
    80006b5c:	00002617          	auipc	a2,0x2
    80006b60:	dac60613          	addi	a2,a2,-596 # 80008908 <digits+0xe0>
    80006b64:	413b05bb          	subw	a1,s6,s3
    80006b68:	013a8533          	add	a0,s5,s3
    80006b6c:	fffff097          	auipc	ra,0xfffff
    80006b70:	08a080e7          	jalr	138(ra) # 80005bf6 <snprintf>
    80006b74:	013509bb          	addw	s3,a0,s3
    release(&lock_locks);
    80006b78:	00020517          	auipc	a0,0x20
    80006b7c:	06050513          	addi	a0,a0,96 # 80026bd8 <lock_locks>
    80006b80:	00000097          	auipc	ra,0x0
    80006b84:	d02080e7          	jalr	-766(ra) # 80006882 <release>
    return n;
}
    80006b88:	854e                	mv	a0,s3
    80006b8a:	70a6                	ld	ra,104(sp)
    80006b8c:	7406                	ld	s0,96(sp)
    80006b8e:	64e6                	ld	s1,88(sp)
    80006b90:	6946                	ld	s2,80(sp)
    80006b92:	69a6                	ld	s3,72(sp)
    80006b94:	6a06                	ld	s4,64(sp)
    80006b96:	7ae2                	ld	s5,56(sp)
    80006b98:	7b42                	ld	s6,48(sp)
    80006b9a:	7ba2                	ld	s7,40(sp)
    80006b9c:	7c02                	ld	s8,32(sp)
    80006b9e:	6ce2                	ld	s9,24(sp)
    80006ba0:	6d42                	ld	s10,16(sp)
    80006ba2:	6da2                	ld	s11,8(sp)
    80006ba4:	6165                	addi	sp,sp,112
    80006ba6:	8082                	ret
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
