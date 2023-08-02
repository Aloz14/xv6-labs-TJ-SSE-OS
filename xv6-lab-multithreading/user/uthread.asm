
user/_uthread：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_init>:
struct thread all_thread[MAX_THREAD];
struct thread *current_thread;
extern void thread_switch(uint64, uint64);

void thread_init(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
    // main() is thread 0, which will make the first invocation to
    // thread_schedule().  it needs a stack so that the first thread_switch() can
    // save thread 0's state.  thread_schedule() won't run the main thread ever
    // again, because its state is set to RUNNING, and thread_schedule() selects
    // a RUNNABLE thread.
    current_thread = &all_thread[0];
   6:	00001797          	auipc	a5,0x1
   a:	da278793          	addi	a5,a5,-606 # da8 <all_thread>
   e:	00001717          	auipc	a4,0x1
  12:	d8f73523          	sd	a5,-630(a4) # d98 <current_thread>
    current_thread->state = RUNNING;
  16:	4785                	li	a5,1
  18:	00003717          	auipc	a4,0x3
  1c:	d8f72823          	sw	a5,-624(a4) # 2da8 <__global_pointer$+0x182f>
}
  20:	6422                	ld	s0,8(sp)
  22:	0141                	addi	sp,sp,16
  24:	8082                	ret

0000000000000026 <thread_schedule>:

void thread_schedule(void)
{
  26:	1141                	addi	sp,sp,-16
  28:	e406                	sd	ra,8(sp)
  2a:	e022                	sd	s0,0(sp)
  2c:	0800                	addi	s0,sp,16
    struct thread *t, *next_thread;

    /* Find another runnable thread. */
    next_thread = 0;
    t = current_thread + 1;
  2e:	00001317          	auipc	t1,0x1
  32:	d6a33303          	ld	t1,-662(t1) # d98 <current_thread>
  36:	6589                	lui	a1,0x2
  38:	07858593          	addi	a1,a1,120 # 2078 <__global_pointer$+0xaff>
  3c:	959a                	add	a1,a1,t1
  3e:	4791                	li	a5,4
    for (int i = 0; i < MAX_THREAD; i++) {
        if (t >= all_thread + MAX_THREAD)
  40:	00009817          	auipc	a6,0x9
  44:	f4880813          	addi	a6,a6,-184 # 8f88 <base>
            t = all_thread;
        if (t->state == RUNNABLE) {
  48:	6689                	lui	a3,0x2
  4a:	4609                	li	a2,2
            next_thread = t;
            break;
        }
        t = t + 1;
  4c:	07868893          	addi	a7,a3,120 # 2078 <__global_pointer$+0xaff>
  50:	a809                	j	62 <thread_schedule+0x3c>
        if (t->state == RUNNABLE) {
  52:	00d58733          	add	a4,a1,a3
  56:	4318                	lw	a4,0(a4)
  58:	02c70963          	beq	a4,a2,8a <thread_schedule+0x64>
        t = t + 1;
  5c:	95c6                	add	a1,a1,a7
    for (int i = 0; i < MAX_THREAD; i++) {
  5e:	37fd                	addiw	a5,a5,-1
  60:	cb81                	beqz	a5,70 <thread_schedule+0x4a>
        if (t >= all_thread + MAX_THREAD)
  62:	ff05e8e3          	bltu	a1,a6,52 <thread_schedule+0x2c>
            t = all_thread;
  66:	00001597          	auipc	a1,0x1
  6a:	d4258593          	addi	a1,a1,-702 # da8 <all_thread>
  6e:	b7d5                	j	52 <thread_schedule+0x2c>
    }

    if (next_thread == 0) {
        printf("thread_schedule: no runnable threads\n");
  70:	00001517          	auipc	a0,0x1
  74:	b9850513          	addi	a0,a0,-1128 # c08 <malloc+0xe6>
  78:	00001097          	auipc	ra,0x1
  7c:	9f2080e7          	jalr	-1550(ra) # a6a <printf>
        exit(-1);
  80:	557d                	li	a0,-1
  82:	00000097          	auipc	ra,0x0
  86:	66e080e7          	jalr	1646(ra) # 6f0 <exit>
    }

    if (current_thread != next_thread) { /* switch threads?  */
  8a:	02b30263          	beq	t1,a1,ae <thread_schedule+0x88>
        next_thread->state = RUNNING;
  8e:	6509                	lui	a0,0x2
  90:	00a587b3          	add	a5,a1,a0
  94:	4705                	li	a4,1
  96:	c398                	sw	a4,0(a5)
        t = current_thread;
        current_thread = next_thread;
  98:	00001797          	auipc	a5,0x1
  9c:	d0b7b023          	sd	a1,-768(a5) # d98 <current_thread>
        /* YOUR CODE HERE
         * Invoke thread_switch to switch from t to next_thread:
         * thread_switch(??, ??);
         */
        thread_switch((uint64)&t->context, (uint64)&current_thread->context);
  a0:	0521                	addi	a0,a0,8 # 2008 <__global_pointer$+0xa8f>
  a2:	95aa                	add	a1,a1,a0
  a4:	951a                	add	a0,a0,t1
  a6:	00000097          	auipc	ra,0x0
  aa:	35a080e7          	jalr	858(ra) # 400 <thread_switch>
    }
    else
        next_thread = 0;
}
  ae:	60a2                	ld	ra,8(sp)
  b0:	6402                	ld	s0,0(sp)
  b2:	0141                	addi	sp,sp,16
  b4:	8082                	ret

00000000000000b6 <thread_create>:

void thread_create(void (*func)())
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	addi	s0,sp,16
    struct thread *t;

    for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  bc:	00001797          	auipc	a5,0x1
  c0:	cec78793          	addi	a5,a5,-788 # da8 <all_thread>
        if (t->state == FREE)
  c4:	6689                	lui	a3,0x2
    for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  c6:	07868593          	addi	a1,a3,120 # 2078 <__global_pointer$+0xaff>
  ca:	00009617          	auipc	a2,0x9
  ce:	ebe60613          	addi	a2,a2,-322 # 8f88 <base>
        if (t->state == FREE)
  d2:	00d78733          	add	a4,a5,a3
  d6:	4318                	lw	a4,0(a4)
  d8:	c701                	beqz	a4,e0 <thread_create+0x2a>
    for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  da:	97ae                	add	a5,a5,a1
  dc:	fec79be3          	bne	a5,a2,d2 <thread_create+0x1c>
            break;
    }
    t->state = RUNNABLE;
  e0:	6709                	lui	a4,0x2
  e2:	97ba                	add	a5,a5,a4
  e4:	4709                	li	a4,2
  e6:	c398                	sw	a4,0(a5)
    // YOUR CODE HERE

    t->context.ra = (uint64)func;                    // 执行传入的函数（thread_switch）
  e8:	e788                	sd	a0,8(a5)
    t->context.sp = (uint64)(t->stack + STACK_SIZE); // 复制栈顶的stack pointer
  ea:	eb9c                	sd	a5,16(a5)
}
  ec:	6422                	ld	s0,8(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret

00000000000000f2 <thread_yield>:

void thread_yield(void)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e406                	sd	ra,8(sp)
  f6:	e022                	sd	s0,0(sp)
  f8:	0800                	addi	s0,sp,16
    current_thread->state = RUNNABLE;
  fa:	00001797          	auipc	a5,0x1
  fe:	c9e7b783          	ld	a5,-866(a5) # d98 <current_thread>
 102:	6709                	lui	a4,0x2
 104:	97ba                	add	a5,a5,a4
 106:	4709                	li	a4,2
 108:	c398                	sw	a4,0(a5)
    thread_schedule();
 10a:	00000097          	auipc	ra,0x0
 10e:	f1c080e7          	jalr	-228(ra) # 26 <thread_schedule>
}
 112:	60a2                	ld	ra,8(sp)
 114:	6402                	ld	s0,0(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret

000000000000011a <thread_a>:

volatile int a_started, b_started, c_started;
volatile int a_n, b_n, c_n;

void thread_a(void)
{
 11a:	7179                	addi	sp,sp,-48
 11c:	f406                	sd	ra,40(sp)
 11e:	f022                	sd	s0,32(sp)
 120:	ec26                	sd	s1,24(sp)
 122:	e84a                	sd	s2,16(sp)
 124:	e44e                	sd	s3,8(sp)
 126:	e052                	sd	s4,0(sp)
 128:	1800                	addi	s0,sp,48
    int i;
    printf("thread_a started\n");
 12a:	00001517          	auipc	a0,0x1
 12e:	b0650513          	addi	a0,a0,-1274 # c30 <malloc+0x10e>
 132:	00001097          	auipc	ra,0x1
 136:	938080e7          	jalr	-1736(ra) # a6a <printf>
    a_started = 1;
 13a:	4785                	li	a5,1
 13c:	00001717          	auipc	a4,0x1
 140:	c4f72c23          	sw	a5,-936(a4) # d94 <a_started>
    while (b_started == 0 || c_started == 0)
 144:	00001497          	auipc	s1,0x1
 148:	c4c48493          	addi	s1,s1,-948 # d90 <b_started>
 14c:	00001917          	auipc	s2,0x1
 150:	c4090913          	addi	s2,s2,-960 # d8c <c_started>
 154:	a029                	j	15e <thread_a+0x44>
        thread_yield();
 156:	00000097          	auipc	ra,0x0
 15a:	f9c080e7          	jalr	-100(ra) # f2 <thread_yield>
    while (b_started == 0 || c_started == 0)
 15e:	409c                	lw	a5,0(s1)
 160:	2781                	sext.w	a5,a5
 162:	dbf5                	beqz	a5,156 <thread_a+0x3c>
 164:	00092783          	lw	a5,0(s2)
 168:	2781                	sext.w	a5,a5
 16a:	d7f5                	beqz	a5,156 <thread_a+0x3c>

    for (i = 0; i < 100; i++) {
 16c:	4481                	li	s1,0
        printf("thread_a %d\n", i);
 16e:	00001a17          	auipc	s4,0x1
 172:	adaa0a13          	addi	s4,s4,-1318 # c48 <malloc+0x126>
        a_n += 1;
 176:	00001917          	auipc	s2,0x1
 17a:	c1290913          	addi	s2,s2,-1006 # d88 <a_n>
    for (i = 0; i < 100; i++) {
 17e:	06400993          	li	s3,100
        printf("thread_a %d\n", i);
 182:	85a6                	mv	a1,s1
 184:	8552                	mv	a0,s4
 186:	00001097          	auipc	ra,0x1
 18a:	8e4080e7          	jalr	-1820(ra) # a6a <printf>
        a_n += 1;
 18e:	00092783          	lw	a5,0(s2)
 192:	2785                	addiw	a5,a5,1
 194:	00f92023          	sw	a5,0(s2)
        thread_yield();
 198:	00000097          	auipc	ra,0x0
 19c:	f5a080e7          	jalr	-166(ra) # f2 <thread_yield>
    for (i = 0; i < 100; i++) {
 1a0:	2485                	addiw	s1,s1,1
 1a2:	ff3490e3          	bne	s1,s3,182 <thread_a+0x68>
    }
    printf("thread_a: exit after %d\n", a_n);
 1a6:	00001597          	auipc	a1,0x1
 1aa:	be25a583          	lw	a1,-1054(a1) # d88 <a_n>
 1ae:	00001517          	auipc	a0,0x1
 1b2:	aaa50513          	addi	a0,a0,-1366 # c58 <malloc+0x136>
 1b6:	00001097          	auipc	ra,0x1
 1ba:	8b4080e7          	jalr	-1868(ra) # a6a <printf>

    current_thread->state = FREE;
 1be:	00001797          	auipc	a5,0x1
 1c2:	bda7b783          	ld	a5,-1062(a5) # d98 <current_thread>
 1c6:	6709                	lui	a4,0x2
 1c8:	97ba                	add	a5,a5,a4
 1ca:	0007a023          	sw	zero,0(a5)
    thread_schedule();
 1ce:	00000097          	auipc	ra,0x0
 1d2:	e58080e7          	jalr	-424(ra) # 26 <thread_schedule>
}
 1d6:	70a2                	ld	ra,40(sp)
 1d8:	7402                	ld	s0,32(sp)
 1da:	64e2                	ld	s1,24(sp)
 1dc:	6942                	ld	s2,16(sp)
 1de:	69a2                	ld	s3,8(sp)
 1e0:	6a02                	ld	s4,0(sp)
 1e2:	6145                	addi	sp,sp,48
 1e4:	8082                	ret

00000000000001e6 <thread_b>:

void thread_b(void)
{
 1e6:	7179                	addi	sp,sp,-48
 1e8:	f406                	sd	ra,40(sp)
 1ea:	f022                	sd	s0,32(sp)
 1ec:	ec26                	sd	s1,24(sp)
 1ee:	e84a                	sd	s2,16(sp)
 1f0:	e44e                	sd	s3,8(sp)
 1f2:	e052                	sd	s4,0(sp)
 1f4:	1800                	addi	s0,sp,48
    int i;
    printf("thread_b started\n");
 1f6:	00001517          	auipc	a0,0x1
 1fa:	a8250513          	addi	a0,a0,-1406 # c78 <malloc+0x156>
 1fe:	00001097          	auipc	ra,0x1
 202:	86c080e7          	jalr	-1940(ra) # a6a <printf>
    b_started = 1;
 206:	4785                	li	a5,1
 208:	00001717          	auipc	a4,0x1
 20c:	b8f72423          	sw	a5,-1144(a4) # d90 <b_started>
    while (a_started == 0 || c_started == 0)
 210:	00001497          	auipc	s1,0x1
 214:	b8448493          	addi	s1,s1,-1148 # d94 <a_started>
 218:	00001917          	auipc	s2,0x1
 21c:	b7490913          	addi	s2,s2,-1164 # d8c <c_started>
 220:	a029                	j	22a <thread_b+0x44>
        thread_yield();
 222:	00000097          	auipc	ra,0x0
 226:	ed0080e7          	jalr	-304(ra) # f2 <thread_yield>
    while (a_started == 0 || c_started == 0)
 22a:	409c                	lw	a5,0(s1)
 22c:	2781                	sext.w	a5,a5
 22e:	dbf5                	beqz	a5,222 <thread_b+0x3c>
 230:	00092783          	lw	a5,0(s2)
 234:	2781                	sext.w	a5,a5
 236:	d7f5                	beqz	a5,222 <thread_b+0x3c>

    for (i = 0; i < 100; i++) {
 238:	4481                	li	s1,0
        printf("thread_b %d\n", i);
 23a:	00001a17          	auipc	s4,0x1
 23e:	a56a0a13          	addi	s4,s4,-1450 # c90 <malloc+0x16e>
        b_n += 1;
 242:	00001917          	auipc	s2,0x1
 246:	b4290913          	addi	s2,s2,-1214 # d84 <b_n>
    for (i = 0; i < 100; i++) {
 24a:	06400993          	li	s3,100
        printf("thread_b %d\n", i);
 24e:	85a6                	mv	a1,s1
 250:	8552                	mv	a0,s4
 252:	00001097          	auipc	ra,0x1
 256:	818080e7          	jalr	-2024(ra) # a6a <printf>
        b_n += 1;
 25a:	00092783          	lw	a5,0(s2)
 25e:	2785                	addiw	a5,a5,1
 260:	00f92023          	sw	a5,0(s2)
        thread_yield();
 264:	00000097          	auipc	ra,0x0
 268:	e8e080e7          	jalr	-370(ra) # f2 <thread_yield>
    for (i = 0; i < 100; i++) {
 26c:	2485                	addiw	s1,s1,1
 26e:	ff3490e3          	bne	s1,s3,24e <thread_b+0x68>
    }
    printf("thread_b: exit after %d\n", b_n);
 272:	00001597          	auipc	a1,0x1
 276:	b125a583          	lw	a1,-1262(a1) # d84 <b_n>
 27a:	00001517          	auipc	a0,0x1
 27e:	a2650513          	addi	a0,a0,-1498 # ca0 <malloc+0x17e>
 282:	00000097          	auipc	ra,0x0
 286:	7e8080e7          	jalr	2024(ra) # a6a <printf>

    current_thread->state = FREE;
 28a:	00001797          	auipc	a5,0x1
 28e:	b0e7b783          	ld	a5,-1266(a5) # d98 <current_thread>
 292:	6709                	lui	a4,0x2
 294:	97ba                	add	a5,a5,a4
 296:	0007a023          	sw	zero,0(a5)
    thread_schedule();
 29a:	00000097          	auipc	ra,0x0
 29e:	d8c080e7          	jalr	-628(ra) # 26 <thread_schedule>
}
 2a2:	70a2                	ld	ra,40(sp)
 2a4:	7402                	ld	s0,32(sp)
 2a6:	64e2                	ld	s1,24(sp)
 2a8:	6942                	ld	s2,16(sp)
 2aa:	69a2                	ld	s3,8(sp)
 2ac:	6a02                	ld	s4,0(sp)
 2ae:	6145                	addi	sp,sp,48
 2b0:	8082                	ret

00000000000002b2 <thread_c>:

void thread_c(void)
{
 2b2:	7179                	addi	sp,sp,-48
 2b4:	f406                	sd	ra,40(sp)
 2b6:	f022                	sd	s0,32(sp)
 2b8:	ec26                	sd	s1,24(sp)
 2ba:	e84a                	sd	s2,16(sp)
 2bc:	e44e                	sd	s3,8(sp)
 2be:	e052                	sd	s4,0(sp)
 2c0:	1800                	addi	s0,sp,48
    int i;
    printf("thread_c started\n");
 2c2:	00001517          	auipc	a0,0x1
 2c6:	9fe50513          	addi	a0,a0,-1538 # cc0 <malloc+0x19e>
 2ca:	00000097          	auipc	ra,0x0
 2ce:	7a0080e7          	jalr	1952(ra) # a6a <printf>
    c_started = 1;
 2d2:	4785                	li	a5,1
 2d4:	00001717          	auipc	a4,0x1
 2d8:	aaf72c23          	sw	a5,-1352(a4) # d8c <c_started>
    while (a_started == 0 || b_started == 0)
 2dc:	00001497          	auipc	s1,0x1
 2e0:	ab848493          	addi	s1,s1,-1352 # d94 <a_started>
 2e4:	00001917          	auipc	s2,0x1
 2e8:	aac90913          	addi	s2,s2,-1364 # d90 <b_started>
 2ec:	a029                	j	2f6 <thread_c+0x44>
        thread_yield();
 2ee:	00000097          	auipc	ra,0x0
 2f2:	e04080e7          	jalr	-508(ra) # f2 <thread_yield>
    while (a_started == 0 || b_started == 0)
 2f6:	409c                	lw	a5,0(s1)
 2f8:	2781                	sext.w	a5,a5
 2fa:	dbf5                	beqz	a5,2ee <thread_c+0x3c>
 2fc:	00092783          	lw	a5,0(s2)
 300:	2781                	sext.w	a5,a5
 302:	d7f5                	beqz	a5,2ee <thread_c+0x3c>

    for (i = 0; i < 100; i++) {
 304:	4481                	li	s1,0
        printf("thread_c %d\n", i);
 306:	00001a17          	auipc	s4,0x1
 30a:	9d2a0a13          	addi	s4,s4,-1582 # cd8 <malloc+0x1b6>
        c_n += 1;
 30e:	00001917          	auipc	s2,0x1
 312:	a7290913          	addi	s2,s2,-1422 # d80 <c_n>
    for (i = 0; i < 100; i++) {
 316:	06400993          	li	s3,100
        printf("thread_c %d\n", i);
 31a:	85a6                	mv	a1,s1
 31c:	8552                	mv	a0,s4
 31e:	00000097          	auipc	ra,0x0
 322:	74c080e7          	jalr	1868(ra) # a6a <printf>
        c_n += 1;
 326:	00092783          	lw	a5,0(s2)
 32a:	2785                	addiw	a5,a5,1
 32c:	00f92023          	sw	a5,0(s2)
        thread_yield();
 330:	00000097          	auipc	ra,0x0
 334:	dc2080e7          	jalr	-574(ra) # f2 <thread_yield>
    for (i = 0; i < 100; i++) {
 338:	2485                	addiw	s1,s1,1
 33a:	ff3490e3          	bne	s1,s3,31a <thread_c+0x68>
    }
    printf("thread_c: exit after %d\n", c_n);
 33e:	00001597          	auipc	a1,0x1
 342:	a425a583          	lw	a1,-1470(a1) # d80 <c_n>
 346:	00001517          	auipc	a0,0x1
 34a:	9a250513          	addi	a0,a0,-1630 # ce8 <malloc+0x1c6>
 34e:	00000097          	auipc	ra,0x0
 352:	71c080e7          	jalr	1820(ra) # a6a <printf>

    current_thread->state = FREE;
 356:	00001797          	auipc	a5,0x1
 35a:	a427b783          	ld	a5,-1470(a5) # d98 <current_thread>
 35e:	6709                	lui	a4,0x2
 360:	97ba                	add	a5,a5,a4
 362:	0007a023          	sw	zero,0(a5)
    thread_schedule();
 366:	00000097          	auipc	ra,0x0
 36a:	cc0080e7          	jalr	-832(ra) # 26 <thread_schedule>
}
 36e:	70a2                	ld	ra,40(sp)
 370:	7402                	ld	s0,32(sp)
 372:	64e2                	ld	s1,24(sp)
 374:	6942                	ld	s2,16(sp)
 376:	69a2                	ld	s3,8(sp)
 378:	6a02                	ld	s4,0(sp)
 37a:	6145                	addi	sp,sp,48
 37c:	8082                	ret

000000000000037e <main>:

int main(int argc, char *argv[])
{
 37e:	1141                	addi	sp,sp,-16
 380:	e406                	sd	ra,8(sp)
 382:	e022                	sd	s0,0(sp)
 384:	0800                	addi	s0,sp,16
    a_started = b_started = c_started = 0;
 386:	00001797          	auipc	a5,0x1
 38a:	a007a323          	sw	zero,-1530(a5) # d8c <c_started>
 38e:	00001797          	auipc	a5,0x1
 392:	a007a123          	sw	zero,-1534(a5) # d90 <b_started>
 396:	00001797          	auipc	a5,0x1
 39a:	9e07af23          	sw	zero,-1538(a5) # d94 <a_started>
    a_n = b_n = c_n = 0;
 39e:	00001797          	auipc	a5,0x1
 3a2:	9e07a123          	sw	zero,-1566(a5) # d80 <c_n>
 3a6:	00001797          	auipc	a5,0x1
 3aa:	9c07af23          	sw	zero,-1570(a5) # d84 <b_n>
 3ae:	00001797          	auipc	a5,0x1
 3b2:	9c07ad23          	sw	zero,-1574(a5) # d88 <a_n>
    thread_init();
 3b6:	00000097          	auipc	ra,0x0
 3ba:	c4a080e7          	jalr	-950(ra) # 0 <thread_init>
    thread_create(thread_a);
 3be:	00000517          	auipc	a0,0x0
 3c2:	d5c50513          	addi	a0,a0,-676 # 11a <thread_a>
 3c6:	00000097          	auipc	ra,0x0
 3ca:	cf0080e7          	jalr	-784(ra) # b6 <thread_create>
    thread_create(thread_b);
 3ce:	00000517          	auipc	a0,0x0
 3d2:	e1850513          	addi	a0,a0,-488 # 1e6 <thread_b>
 3d6:	00000097          	auipc	ra,0x0
 3da:	ce0080e7          	jalr	-800(ra) # b6 <thread_create>
    thread_create(thread_c);
 3de:	00000517          	auipc	a0,0x0
 3e2:	ed450513          	addi	a0,a0,-300 # 2b2 <thread_c>
 3e6:	00000097          	auipc	ra,0x0
 3ea:	cd0080e7          	jalr	-816(ra) # b6 <thread_create>
    thread_schedule();
 3ee:	00000097          	auipc	ra,0x0
 3f2:	c38080e7          	jalr	-968(ra) # 26 <thread_schedule>
    exit(0);
 3f6:	4501                	li	a0,0
 3f8:	00000097          	auipc	ra,0x0
 3fc:	2f8080e7          	jalr	760(ra) # 6f0 <exit>

0000000000000400 <thread_switch>:
	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
	/* copy kernel/swtch.S */
swtch:
        sd ra, 0(a0)
 400:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
 404:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
 408:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
 40a:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
 40c:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
 410:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
 414:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
 418:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
 41c:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
 420:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
 424:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
 428:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
 42c:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
 430:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
 434:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
 438:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
 43c:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
 43e:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
 440:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
 444:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
 448:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
 44c:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
 450:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
 454:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
 458:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
 45c:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
 460:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
 464:	0685bd83          	ld	s11,104(a1)
        
        ret /* ret to ra*/
 468:	8082                	ret

000000000000046a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 46a:	1141                	addi	sp,sp,-16
 46c:	e406                	sd	ra,8(sp)
 46e:	e022                	sd	s0,0(sp)
 470:	0800                	addi	s0,sp,16
  extern int main();
  main();
 472:	00000097          	auipc	ra,0x0
 476:	f0c080e7          	jalr	-244(ra) # 37e <main>
  exit(0);
 47a:	4501                	li	a0,0
 47c:	00000097          	auipc	ra,0x0
 480:	274080e7          	jalr	628(ra) # 6f0 <exit>

0000000000000484 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 484:	1141                	addi	sp,sp,-16
 486:	e422                	sd	s0,8(sp)
 488:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 48a:	87aa                	mv	a5,a0
 48c:	0585                	addi	a1,a1,1
 48e:	0785                	addi	a5,a5,1
 490:	fff5c703          	lbu	a4,-1(a1)
 494:	fee78fa3          	sb	a4,-1(a5)
 498:	fb75                	bnez	a4,48c <strcpy+0x8>
    ;
  return os;
}
 49a:	6422                	ld	s0,8(sp)
 49c:	0141                	addi	sp,sp,16
 49e:	8082                	ret

00000000000004a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4a0:	1141                	addi	sp,sp,-16
 4a2:	e422                	sd	s0,8(sp)
 4a4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 4a6:	00054783          	lbu	a5,0(a0)
 4aa:	cb91                	beqz	a5,4be <strcmp+0x1e>
 4ac:	0005c703          	lbu	a4,0(a1)
 4b0:	00f71763          	bne	a4,a5,4be <strcmp+0x1e>
    p++, q++;
 4b4:	0505                	addi	a0,a0,1
 4b6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 4b8:	00054783          	lbu	a5,0(a0)
 4bc:	fbe5                	bnez	a5,4ac <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4be:	0005c503          	lbu	a0,0(a1)
}
 4c2:	40a7853b          	subw	a0,a5,a0
 4c6:	6422                	ld	s0,8(sp)
 4c8:	0141                	addi	sp,sp,16
 4ca:	8082                	ret

00000000000004cc <strlen>:

uint
strlen(const char *s)
{
 4cc:	1141                	addi	sp,sp,-16
 4ce:	e422                	sd	s0,8(sp)
 4d0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 4d2:	00054783          	lbu	a5,0(a0)
 4d6:	cf91                	beqz	a5,4f2 <strlen+0x26>
 4d8:	0505                	addi	a0,a0,1
 4da:	87aa                	mv	a5,a0
 4dc:	4685                	li	a3,1
 4de:	9e89                	subw	a3,a3,a0
 4e0:	00f6853b          	addw	a0,a3,a5
 4e4:	0785                	addi	a5,a5,1
 4e6:	fff7c703          	lbu	a4,-1(a5)
 4ea:	fb7d                	bnez	a4,4e0 <strlen+0x14>
    ;
  return n;
}
 4ec:	6422                	ld	s0,8(sp)
 4ee:	0141                	addi	sp,sp,16
 4f0:	8082                	ret
  for(n = 0; s[n]; n++)
 4f2:	4501                	li	a0,0
 4f4:	bfe5                	j	4ec <strlen+0x20>

00000000000004f6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 4f6:	1141                	addi	sp,sp,-16
 4f8:	e422                	sd	s0,8(sp)
 4fa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 4fc:	ca19                	beqz	a2,512 <memset+0x1c>
 4fe:	87aa                	mv	a5,a0
 500:	1602                	slli	a2,a2,0x20
 502:	9201                	srli	a2,a2,0x20
 504:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 508:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 50c:	0785                	addi	a5,a5,1
 50e:	fee79de3          	bne	a5,a4,508 <memset+0x12>
  }
  return dst;
}
 512:	6422                	ld	s0,8(sp)
 514:	0141                	addi	sp,sp,16
 516:	8082                	ret

0000000000000518 <strchr>:

char*
strchr(const char *s, char c)
{
 518:	1141                	addi	sp,sp,-16
 51a:	e422                	sd	s0,8(sp)
 51c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 51e:	00054783          	lbu	a5,0(a0)
 522:	cb99                	beqz	a5,538 <strchr+0x20>
    if(*s == c)
 524:	00f58763          	beq	a1,a5,532 <strchr+0x1a>
  for(; *s; s++)
 528:	0505                	addi	a0,a0,1
 52a:	00054783          	lbu	a5,0(a0)
 52e:	fbfd                	bnez	a5,524 <strchr+0xc>
      return (char*)s;
  return 0;
 530:	4501                	li	a0,0
}
 532:	6422                	ld	s0,8(sp)
 534:	0141                	addi	sp,sp,16
 536:	8082                	ret
  return 0;
 538:	4501                	li	a0,0
 53a:	bfe5                	j	532 <strchr+0x1a>

000000000000053c <gets>:

char*
gets(char *buf, int max)
{
 53c:	711d                	addi	sp,sp,-96
 53e:	ec86                	sd	ra,88(sp)
 540:	e8a2                	sd	s0,80(sp)
 542:	e4a6                	sd	s1,72(sp)
 544:	e0ca                	sd	s2,64(sp)
 546:	fc4e                	sd	s3,56(sp)
 548:	f852                	sd	s4,48(sp)
 54a:	f456                	sd	s5,40(sp)
 54c:	f05a                	sd	s6,32(sp)
 54e:	ec5e                	sd	s7,24(sp)
 550:	1080                	addi	s0,sp,96
 552:	8baa                	mv	s7,a0
 554:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 556:	892a                	mv	s2,a0
 558:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 55a:	4aa9                	li	s5,10
 55c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 55e:	89a6                	mv	s3,s1
 560:	2485                	addiw	s1,s1,1
 562:	0344d863          	bge	s1,s4,592 <gets+0x56>
    cc = read(0, &c, 1);
 566:	4605                	li	a2,1
 568:	faf40593          	addi	a1,s0,-81
 56c:	4501                	li	a0,0
 56e:	00000097          	auipc	ra,0x0
 572:	19a080e7          	jalr	410(ra) # 708 <read>
    if(cc < 1)
 576:	00a05e63          	blez	a0,592 <gets+0x56>
    buf[i++] = c;
 57a:	faf44783          	lbu	a5,-81(s0)
 57e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 582:	01578763          	beq	a5,s5,590 <gets+0x54>
 586:	0905                	addi	s2,s2,1
 588:	fd679be3          	bne	a5,s6,55e <gets+0x22>
  for(i=0; i+1 < max; ){
 58c:	89a6                	mv	s3,s1
 58e:	a011                	j	592 <gets+0x56>
 590:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 592:	99de                	add	s3,s3,s7
 594:	00098023          	sb	zero,0(s3)
  return buf;
}
 598:	855e                	mv	a0,s7
 59a:	60e6                	ld	ra,88(sp)
 59c:	6446                	ld	s0,80(sp)
 59e:	64a6                	ld	s1,72(sp)
 5a0:	6906                	ld	s2,64(sp)
 5a2:	79e2                	ld	s3,56(sp)
 5a4:	7a42                	ld	s4,48(sp)
 5a6:	7aa2                	ld	s5,40(sp)
 5a8:	7b02                	ld	s6,32(sp)
 5aa:	6be2                	ld	s7,24(sp)
 5ac:	6125                	addi	sp,sp,96
 5ae:	8082                	ret

00000000000005b0 <stat>:

int
stat(const char *n, struct stat *st)
{
 5b0:	1101                	addi	sp,sp,-32
 5b2:	ec06                	sd	ra,24(sp)
 5b4:	e822                	sd	s0,16(sp)
 5b6:	e426                	sd	s1,8(sp)
 5b8:	e04a                	sd	s2,0(sp)
 5ba:	1000                	addi	s0,sp,32
 5bc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5be:	4581                	li	a1,0
 5c0:	00000097          	auipc	ra,0x0
 5c4:	170080e7          	jalr	368(ra) # 730 <open>
  if(fd < 0)
 5c8:	02054563          	bltz	a0,5f2 <stat+0x42>
 5cc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5ce:	85ca                	mv	a1,s2
 5d0:	00000097          	auipc	ra,0x0
 5d4:	178080e7          	jalr	376(ra) # 748 <fstat>
 5d8:	892a                	mv	s2,a0
  close(fd);
 5da:	8526                	mv	a0,s1
 5dc:	00000097          	auipc	ra,0x0
 5e0:	13c080e7          	jalr	316(ra) # 718 <close>
  return r;
}
 5e4:	854a                	mv	a0,s2
 5e6:	60e2                	ld	ra,24(sp)
 5e8:	6442                	ld	s0,16(sp)
 5ea:	64a2                	ld	s1,8(sp)
 5ec:	6902                	ld	s2,0(sp)
 5ee:	6105                	addi	sp,sp,32
 5f0:	8082                	ret
    return -1;
 5f2:	597d                	li	s2,-1
 5f4:	bfc5                	j	5e4 <stat+0x34>

00000000000005f6 <atoi>:

int
atoi(const char *s)
{
 5f6:	1141                	addi	sp,sp,-16
 5f8:	e422                	sd	s0,8(sp)
 5fa:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5fc:	00054683          	lbu	a3,0(a0)
 600:	fd06879b          	addiw	a5,a3,-48
 604:	0ff7f793          	zext.b	a5,a5
 608:	4625                	li	a2,9
 60a:	02f66863          	bltu	a2,a5,63a <atoi+0x44>
 60e:	872a                	mv	a4,a0
  n = 0;
 610:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 612:	0705                	addi	a4,a4,1 # 2001 <__global_pointer$+0xa88>
 614:	0025179b          	slliw	a5,a0,0x2
 618:	9fa9                	addw	a5,a5,a0
 61a:	0017979b          	slliw	a5,a5,0x1
 61e:	9fb5                	addw	a5,a5,a3
 620:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 624:	00074683          	lbu	a3,0(a4)
 628:	fd06879b          	addiw	a5,a3,-48
 62c:	0ff7f793          	zext.b	a5,a5
 630:	fef671e3          	bgeu	a2,a5,612 <atoi+0x1c>
  return n;
}
 634:	6422                	ld	s0,8(sp)
 636:	0141                	addi	sp,sp,16
 638:	8082                	ret
  n = 0;
 63a:	4501                	li	a0,0
 63c:	bfe5                	j	634 <atoi+0x3e>

000000000000063e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 63e:	1141                	addi	sp,sp,-16
 640:	e422                	sd	s0,8(sp)
 642:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 644:	02b57463          	bgeu	a0,a1,66c <memmove+0x2e>
    while(n-- > 0)
 648:	00c05f63          	blez	a2,666 <memmove+0x28>
 64c:	1602                	slli	a2,a2,0x20
 64e:	9201                	srli	a2,a2,0x20
 650:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 654:	872a                	mv	a4,a0
      *dst++ = *src++;
 656:	0585                	addi	a1,a1,1
 658:	0705                	addi	a4,a4,1
 65a:	fff5c683          	lbu	a3,-1(a1)
 65e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 662:	fee79ae3          	bne	a5,a4,656 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 666:	6422                	ld	s0,8(sp)
 668:	0141                	addi	sp,sp,16
 66a:	8082                	ret
    dst += n;
 66c:	00c50733          	add	a4,a0,a2
    src += n;
 670:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 672:	fec05ae3          	blez	a2,666 <memmove+0x28>
 676:	fff6079b          	addiw	a5,a2,-1
 67a:	1782                	slli	a5,a5,0x20
 67c:	9381                	srli	a5,a5,0x20
 67e:	fff7c793          	not	a5,a5
 682:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 684:	15fd                	addi	a1,a1,-1
 686:	177d                	addi	a4,a4,-1
 688:	0005c683          	lbu	a3,0(a1)
 68c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 690:	fee79ae3          	bne	a5,a4,684 <memmove+0x46>
 694:	bfc9                	j	666 <memmove+0x28>

0000000000000696 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 696:	1141                	addi	sp,sp,-16
 698:	e422                	sd	s0,8(sp)
 69a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 69c:	ca05                	beqz	a2,6cc <memcmp+0x36>
 69e:	fff6069b          	addiw	a3,a2,-1
 6a2:	1682                	slli	a3,a3,0x20
 6a4:	9281                	srli	a3,a3,0x20
 6a6:	0685                	addi	a3,a3,1
 6a8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 6aa:	00054783          	lbu	a5,0(a0)
 6ae:	0005c703          	lbu	a4,0(a1)
 6b2:	00e79863          	bne	a5,a4,6c2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 6b6:	0505                	addi	a0,a0,1
    p2++;
 6b8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 6ba:	fed518e3          	bne	a0,a3,6aa <memcmp+0x14>
  }
  return 0;
 6be:	4501                	li	a0,0
 6c0:	a019                	j	6c6 <memcmp+0x30>
      return *p1 - *p2;
 6c2:	40e7853b          	subw	a0,a5,a4
}
 6c6:	6422                	ld	s0,8(sp)
 6c8:	0141                	addi	sp,sp,16
 6ca:	8082                	ret
  return 0;
 6cc:	4501                	li	a0,0
 6ce:	bfe5                	j	6c6 <memcmp+0x30>

00000000000006d0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6d0:	1141                	addi	sp,sp,-16
 6d2:	e406                	sd	ra,8(sp)
 6d4:	e022                	sd	s0,0(sp)
 6d6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 6d8:	00000097          	auipc	ra,0x0
 6dc:	f66080e7          	jalr	-154(ra) # 63e <memmove>
}
 6e0:	60a2                	ld	ra,8(sp)
 6e2:	6402                	ld	s0,0(sp)
 6e4:	0141                	addi	sp,sp,16
 6e6:	8082                	ret

00000000000006e8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6e8:	4885                	li	a7,1
 ecall
 6ea:	00000073          	ecall
 ret
 6ee:	8082                	ret

00000000000006f0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 6f0:	4889                	li	a7,2
 ecall
 6f2:	00000073          	ecall
 ret
 6f6:	8082                	ret

00000000000006f8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 6f8:	488d                	li	a7,3
 ecall
 6fa:	00000073          	ecall
 ret
 6fe:	8082                	ret

0000000000000700 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 700:	4891                	li	a7,4
 ecall
 702:	00000073          	ecall
 ret
 706:	8082                	ret

0000000000000708 <read>:
.global read
read:
 li a7, SYS_read
 708:	4895                	li	a7,5
 ecall
 70a:	00000073          	ecall
 ret
 70e:	8082                	ret

0000000000000710 <write>:
.global write
write:
 li a7, SYS_write
 710:	48c1                	li	a7,16
 ecall
 712:	00000073          	ecall
 ret
 716:	8082                	ret

0000000000000718 <close>:
.global close
close:
 li a7, SYS_close
 718:	48d5                	li	a7,21
 ecall
 71a:	00000073          	ecall
 ret
 71e:	8082                	ret

0000000000000720 <kill>:
.global kill
kill:
 li a7, SYS_kill
 720:	4899                	li	a7,6
 ecall
 722:	00000073          	ecall
 ret
 726:	8082                	ret

0000000000000728 <exec>:
.global exec
exec:
 li a7, SYS_exec
 728:	489d                	li	a7,7
 ecall
 72a:	00000073          	ecall
 ret
 72e:	8082                	ret

0000000000000730 <open>:
.global open
open:
 li a7, SYS_open
 730:	48bd                	li	a7,15
 ecall
 732:	00000073          	ecall
 ret
 736:	8082                	ret

0000000000000738 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 738:	48c5                	li	a7,17
 ecall
 73a:	00000073          	ecall
 ret
 73e:	8082                	ret

0000000000000740 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 740:	48c9                	li	a7,18
 ecall
 742:	00000073          	ecall
 ret
 746:	8082                	ret

0000000000000748 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 748:	48a1                	li	a7,8
 ecall
 74a:	00000073          	ecall
 ret
 74e:	8082                	ret

0000000000000750 <link>:
.global link
link:
 li a7, SYS_link
 750:	48cd                	li	a7,19
 ecall
 752:	00000073          	ecall
 ret
 756:	8082                	ret

0000000000000758 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 758:	48d1                	li	a7,20
 ecall
 75a:	00000073          	ecall
 ret
 75e:	8082                	ret

0000000000000760 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 760:	48a5                	li	a7,9
 ecall
 762:	00000073          	ecall
 ret
 766:	8082                	ret

0000000000000768 <dup>:
.global dup
dup:
 li a7, SYS_dup
 768:	48a9                	li	a7,10
 ecall
 76a:	00000073          	ecall
 ret
 76e:	8082                	ret

0000000000000770 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 770:	48ad                	li	a7,11
 ecall
 772:	00000073          	ecall
 ret
 776:	8082                	ret

0000000000000778 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 778:	48b1                	li	a7,12
 ecall
 77a:	00000073          	ecall
 ret
 77e:	8082                	ret

0000000000000780 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 780:	48b5                	li	a7,13
 ecall
 782:	00000073          	ecall
 ret
 786:	8082                	ret

0000000000000788 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 788:	48b9                	li	a7,14
 ecall
 78a:	00000073          	ecall
 ret
 78e:	8082                	ret

0000000000000790 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 790:	1101                	addi	sp,sp,-32
 792:	ec06                	sd	ra,24(sp)
 794:	e822                	sd	s0,16(sp)
 796:	1000                	addi	s0,sp,32
 798:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 79c:	4605                	li	a2,1
 79e:	fef40593          	addi	a1,s0,-17
 7a2:	00000097          	auipc	ra,0x0
 7a6:	f6e080e7          	jalr	-146(ra) # 710 <write>
}
 7aa:	60e2                	ld	ra,24(sp)
 7ac:	6442                	ld	s0,16(sp)
 7ae:	6105                	addi	sp,sp,32
 7b0:	8082                	ret

00000000000007b2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7b2:	7139                	addi	sp,sp,-64
 7b4:	fc06                	sd	ra,56(sp)
 7b6:	f822                	sd	s0,48(sp)
 7b8:	f426                	sd	s1,40(sp)
 7ba:	f04a                	sd	s2,32(sp)
 7bc:	ec4e                	sd	s3,24(sp)
 7be:	0080                	addi	s0,sp,64
 7c0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7c2:	c299                	beqz	a3,7c8 <printint+0x16>
 7c4:	0805c963          	bltz	a1,856 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7c8:	2581                	sext.w	a1,a1
  neg = 0;
 7ca:	4881                	li	a7,0
 7cc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 7d0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7d2:	2601                	sext.w	a2,a2
 7d4:	00000517          	auipc	a0,0x0
 7d8:	59450513          	addi	a0,a0,1428 # d68 <digits>
 7dc:	883a                	mv	a6,a4
 7de:	2705                	addiw	a4,a4,1
 7e0:	02c5f7bb          	remuw	a5,a1,a2
 7e4:	1782                	slli	a5,a5,0x20
 7e6:	9381                	srli	a5,a5,0x20
 7e8:	97aa                	add	a5,a5,a0
 7ea:	0007c783          	lbu	a5,0(a5)
 7ee:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 7f2:	0005879b          	sext.w	a5,a1
 7f6:	02c5d5bb          	divuw	a1,a1,a2
 7fa:	0685                	addi	a3,a3,1
 7fc:	fec7f0e3          	bgeu	a5,a2,7dc <printint+0x2a>
  if(neg)
 800:	00088c63          	beqz	a7,818 <printint+0x66>
    buf[i++] = '-';
 804:	fd070793          	addi	a5,a4,-48
 808:	00878733          	add	a4,a5,s0
 80c:	02d00793          	li	a5,45
 810:	fef70823          	sb	a5,-16(a4)
 814:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 818:	02e05863          	blez	a4,848 <printint+0x96>
 81c:	fc040793          	addi	a5,s0,-64
 820:	00e78933          	add	s2,a5,a4
 824:	fff78993          	addi	s3,a5,-1
 828:	99ba                	add	s3,s3,a4
 82a:	377d                	addiw	a4,a4,-1
 82c:	1702                	slli	a4,a4,0x20
 82e:	9301                	srli	a4,a4,0x20
 830:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 834:	fff94583          	lbu	a1,-1(s2)
 838:	8526                	mv	a0,s1
 83a:	00000097          	auipc	ra,0x0
 83e:	f56080e7          	jalr	-170(ra) # 790 <putc>
  while(--i >= 0)
 842:	197d                	addi	s2,s2,-1
 844:	ff3918e3          	bne	s2,s3,834 <printint+0x82>
}
 848:	70e2                	ld	ra,56(sp)
 84a:	7442                	ld	s0,48(sp)
 84c:	74a2                	ld	s1,40(sp)
 84e:	7902                	ld	s2,32(sp)
 850:	69e2                	ld	s3,24(sp)
 852:	6121                	addi	sp,sp,64
 854:	8082                	ret
    x = -xx;
 856:	40b005bb          	negw	a1,a1
    neg = 1;
 85a:	4885                	li	a7,1
    x = -xx;
 85c:	bf85                	j	7cc <printint+0x1a>

000000000000085e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 85e:	7119                	addi	sp,sp,-128
 860:	fc86                	sd	ra,120(sp)
 862:	f8a2                	sd	s0,112(sp)
 864:	f4a6                	sd	s1,104(sp)
 866:	f0ca                	sd	s2,96(sp)
 868:	ecce                	sd	s3,88(sp)
 86a:	e8d2                	sd	s4,80(sp)
 86c:	e4d6                	sd	s5,72(sp)
 86e:	e0da                	sd	s6,64(sp)
 870:	fc5e                	sd	s7,56(sp)
 872:	f862                	sd	s8,48(sp)
 874:	f466                	sd	s9,40(sp)
 876:	f06a                	sd	s10,32(sp)
 878:	ec6e                	sd	s11,24(sp)
 87a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 87c:	0005c903          	lbu	s2,0(a1)
 880:	18090f63          	beqz	s2,a1e <vprintf+0x1c0>
 884:	8aaa                	mv	s5,a0
 886:	8b32                	mv	s6,a2
 888:	00158493          	addi	s1,a1,1
  state = 0;
 88c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 88e:	02500a13          	li	s4,37
 892:	4c55                	li	s8,21
 894:	00000c97          	auipc	s9,0x0
 898:	47cc8c93          	addi	s9,s9,1148 # d10 <malloc+0x1ee>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 89c:	02800d93          	li	s11,40
  putc(fd, 'x');
 8a0:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8a2:	00000b97          	auipc	s7,0x0
 8a6:	4c6b8b93          	addi	s7,s7,1222 # d68 <digits>
 8aa:	a839                	j	8c8 <vprintf+0x6a>
        putc(fd, c);
 8ac:	85ca                	mv	a1,s2
 8ae:	8556                	mv	a0,s5
 8b0:	00000097          	auipc	ra,0x0
 8b4:	ee0080e7          	jalr	-288(ra) # 790 <putc>
 8b8:	a019                	j	8be <vprintf+0x60>
    } else if(state == '%'){
 8ba:	01498d63          	beq	s3,s4,8d4 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 8be:	0485                	addi	s1,s1,1
 8c0:	fff4c903          	lbu	s2,-1(s1)
 8c4:	14090d63          	beqz	s2,a1e <vprintf+0x1c0>
    if(state == 0){
 8c8:	fe0999e3          	bnez	s3,8ba <vprintf+0x5c>
      if(c == '%'){
 8cc:	ff4910e3          	bne	s2,s4,8ac <vprintf+0x4e>
        state = '%';
 8d0:	89d2                	mv	s3,s4
 8d2:	b7f5                	j	8be <vprintf+0x60>
      if(c == 'd'){
 8d4:	11490c63          	beq	s2,s4,9ec <vprintf+0x18e>
 8d8:	f9d9079b          	addiw	a5,s2,-99
 8dc:	0ff7f793          	zext.b	a5,a5
 8e0:	10fc6e63          	bltu	s8,a5,9fc <vprintf+0x19e>
 8e4:	f9d9079b          	addiw	a5,s2,-99
 8e8:	0ff7f713          	zext.b	a4,a5
 8ec:	10ec6863          	bltu	s8,a4,9fc <vprintf+0x19e>
 8f0:	00271793          	slli	a5,a4,0x2
 8f4:	97e6                	add	a5,a5,s9
 8f6:	439c                	lw	a5,0(a5)
 8f8:	97e6                	add	a5,a5,s9
 8fa:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 8fc:	008b0913          	addi	s2,s6,8
 900:	4685                	li	a3,1
 902:	4629                	li	a2,10
 904:	000b2583          	lw	a1,0(s6)
 908:	8556                	mv	a0,s5
 90a:	00000097          	auipc	ra,0x0
 90e:	ea8080e7          	jalr	-344(ra) # 7b2 <printint>
 912:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 914:	4981                	li	s3,0
 916:	b765                	j	8be <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 918:	008b0913          	addi	s2,s6,8
 91c:	4681                	li	a3,0
 91e:	4629                	li	a2,10
 920:	000b2583          	lw	a1,0(s6)
 924:	8556                	mv	a0,s5
 926:	00000097          	auipc	ra,0x0
 92a:	e8c080e7          	jalr	-372(ra) # 7b2 <printint>
 92e:	8b4a                	mv	s6,s2
      state = 0;
 930:	4981                	li	s3,0
 932:	b771                	j	8be <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 934:	008b0913          	addi	s2,s6,8
 938:	4681                	li	a3,0
 93a:	866a                	mv	a2,s10
 93c:	000b2583          	lw	a1,0(s6)
 940:	8556                	mv	a0,s5
 942:	00000097          	auipc	ra,0x0
 946:	e70080e7          	jalr	-400(ra) # 7b2 <printint>
 94a:	8b4a                	mv	s6,s2
      state = 0;
 94c:	4981                	li	s3,0
 94e:	bf85                	j	8be <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 950:	008b0793          	addi	a5,s6,8
 954:	f8f43423          	sd	a5,-120(s0)
 958:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 95c:	03000593          	li	a1,48
 960:	8556                	mv	a0,s5
 962:	00000097          	auipc	ra,0x0
 966:	e2e080e7          	jalr	-466(ra) # 790 <putc>
  putc(fd, 'x');
 96a:	07800593          	li	a1,120
 96e:	8556                	mv	a0,s5
 970:	00000097          	auipc	ra,0x0
 974:	e20080e7          	jalr	-480(ra) # 790 <putc>
 978:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 97a:	03c9d793          	srli	a5,s3,0x3c
 97e:	97de                	add	a5,a5,s7
 980:	0007c583          	lbu	a1,0(a5)
 984:	8556                	mv	a0,s5
 986:	00000097          	auipc	ra,0x0
 98a:	e0a080e7          	jalr	-502(ra) # 790 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 98e:	0992                	slli	s3,s3,0x4
 990:	397d                	addiw	s2,s2,-1
 992:	fe0914e3          	bnez	s2,97a <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 996:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 99a:	4981                	li	s3,0
 99c:	b70d                	j	8be <vprintf+0x60>
        s = va_arg(ap, char*);
 99e:	008b0913          	addi	s2,s6,8
 9a2:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 9a6:	02098163          	beqz	s3,9c8 <vprintf+0x16a>
        while(*s != 0){
 9aa:	0009c583          	lbu	a1,0(s3)
 9ae:	c5ad                	beqz	a1,a18 <vprintf+0x1ba>
          putc(fd, *s);
 9b0:	8556                	mv	a0,s5
 9b2:	00000097          	auipc	ra,0x0
 9b6:	dde080e7          	jalr	-546(ra) # 790 <putc>
          s++;
 9ba:	0985                	addi	s3,s3,1
        while(*s != 0){
 9bc:	0009c583          	lbu	a1,0(s3)
 9c0:	f9e5                	bnez	a1,9b0 <vprintf+0x152>
        s = va_arg(ap, char*);
 9c2:	8b4a                	mv	s6,s2
      state = 0;
 9c4:	4981                	li	s3,0
 9c6:	bde5                	j	8be <vprintf+0x60>
          s = "(null)";
 9c8:	00000997          	auipc	s3,0x0
 9cc:	34098993          	addi	s3,s3,832 # d08 <malloc+0x1e6>
        while(*s != 0){
 9d0:	85ee                	mv	a1,s11
 9d2:	bff9                	j	9b0 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 9d4:	008b0913          	addi	s2,s6,8
 9d8:	000b4583          	lbu	a1,0(s6)
 9dc:	8556                	mv	a0,s5
 9de:	00000097          	auipc	ra,0x0
 9e2:	db2080e7          	jalr	-590(ra) # 790 <putc>
 9e6:	8b4a                	mv	s6,s2
      state = 0;
 9e8:	4981                	li	s3,0
 9ea:	bdd1                	j	8be <vprintf+0x60>
        putc(fd, c);
 9ec:	85d2                	mv	a1,s4
 9ee:	8556                	mv	a0,s5
 9f0:	00000097          	auipc	ra,0x0
 9f4:	da0080e7          	jalr	-608(ra) # 790 <putc>
      state = 0;
 9f8:	4981                	li	s3,0
 9fa:	b5d1                	j	8be <vprintf+0x60>
        putc(fd, '%');
 9fc:	85d2                	mv	a1,s4
 9fe:	8556                	mv	a0,s5
 a00:	00000097          	auipc	ra,0x0
 a04:	d90080e7          	jalr	-624(ra) # 790 <putc>
        putc(fd, c);
 a08:	85ca                	mv	a1,s2
 a0a:	8556                	mv	a0,s5
 a0c:	00000097          	auipc	ra,0x0
 a10:	d84080e7          	jalr	-636(ra) # 790 <putc>
      state = 0;
 a14:	4981                	li	s3,0
 a16:	b565                	j	8be <vprintf+0x60>
        s = va_arg(ap, char*);
 a18:	8b4a                	mv	s6,s2
      state = 0;
 a1a:	4981                	li	s3,0
 a1c:	b54d                	j	8be <vprintf+0x60>
    }
  }
}
 a1e:	70e6                	ld	ra,120(sp)
 a20:	7446                	ld	s0,112(sp)
 a22:	74a6                	ld	s1,104(sp)
 a24:	7906                	ld	s2,96(sp)
 a26:	69e6                	ld	s3,88(sp)
 a28:	6a46                	ld	s4,80(sp)
 a2a:	6aa6                	ld	s5,72(sp)
 a2c:	6b06                	ld	s6,64(sp)
 a2e:	7be2                	ld	s7,56(sp)
 a30:	7c42                	ld	s8,48(sp)
 a32:	7ca2                	ld	s9,40(sp)
 a34:	7d02                	ld	s10,32(sp)
 a36:	6de2                	ld	s11,24(sp)
 a38:	6109                	addi	sp,sp,128
 a3a:	8082                	ret

0000000000000a3c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a3c:	715d                	addi	sp,sp,-80
 a3e:	ec06                	sd	ra,24(sp)
 a40:	e822                	sd	s0,16(sp)
 a42:	1000                	addi	s0,sp,32
 a44:	e010                	sd	a2,0(s0)
 a46:	e414                	sd	a3,8(s0)
 a48:	e818                	sd	a4,16(s0)
 a4a:	ec1c                	sd	a5,24(s0)
 a4c:	03043023          	sd	a6,32(s0)
 a50:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a54:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a58:	8622                	mv	a2,s0
 a5a:	00000097          	auipc	ra,0x0
 a5e:	e04080e7          	jalr	-508(ra) # 85e <vprintf>
}
 a62:	60e2                	ld	ra,24(sp)
 a64:	6442                	ld	s0,16(sp)
 a66:	6161                	addi	sp,sp,80
 a68:	8082                	ret

0000000000000a6a <printf>:

void
printf(const char *fmt, ...)
{
 a6a:	711d                	addi	sp,sp,-96
 a6c:	ec06                	sd	ra,24(sp)
 a6e:	e822                	sd	s0,16(sp)
 a70:	1000                	addi	s0,sp,32
 a72:	e40c                	sd	a1,8(s0)
 a74:	e810                	sd	a2,16(s0)
 a76:	ec14                	sd	a3,24(s0)
 a78:	f018                	sd	a4,32(s0)
 a7a:	f41c                	sd	a5,40(s0)
 a7c:	03043823          	sd	a6,48(s0)
 a80:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a84:	00840613          	addi	a2,s0,8
 a88:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a8c:	85aa                	mv	a1,a0
 a8e:	4505                	li	a0,1
 a90:	00000097          	auipc	ra,0x0
 a94:	dce080e7          	jalr	-562(ra) # 85e <vprintf>
}
 a98:	60e2                	ld	ra,24(sp)
 a9a:	6442                	ld	s0,16(sp)
 a9c:	6125                	addi	sp,sp,96
 a9e:	8082                	ret

0000000000000aa0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 aa0:	1141                	addi	sp,sp,-16
 aa2:	e422                	sd	s0,8(sp)
 aa4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 aa6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aaa:	00000797          	auipc	a5,0x0
 aae:	2f67b783          	ld	a5,758(a5) # da0 <freep>
 ab2:	a02d                	j	adc <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 ab4:	4618                	lw	a4,8(a2)
 ab6:	9f2d                	addw	a4,a4,a1
 ab8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 abc:	6398                	ld	a4,0(a5)
 abe:	6310                	ld	a2,0(a4)
 ac0:	a83d                	j	afe <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ac2:	ff852703          	lw	a4,-8(a0)
 ac6:	9f31                	addw	a4,a4,a2
 ac8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 aca:	ff053683          	ld	a3,-16(a0)
 ace:	a091                	j	b12 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ad0:	6398                	ld	a4,0(a5)
 ad2:	00e7e463          	bltu	a5,a4,ada <free+0x3a>
 ad6:	00e6ea63          	bltu	a3,a4,aea <free+0x4a>
{
 ada:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 adc:	fed7fae3          	bgeu	a5,a3,ad0 <free+0x30>
 ae0:	6398                	ld	a4,0(a5)
 ae2:	00e6e463          	bltu	a3,a4,aea <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ae6:	fee7eae3          	bltu	a5,a4,ada <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 aea:	ff852583          	lw	a1,-8(a0)
 aee:	6390                	ld	a2,0(a5)
 af0:	02059813          	slli	a6,a1,0x20
 af4:	01c85713          	srli	a4,a6,0x1c
 af8:	9736                	add	a4,a4,a3
 afa:	fae60de3          	beq	a2,a4,ab4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 afe:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b02:	4790                	lw	a2,8(a5)
 b04:	02061593          	slli	a1,a2,0x20
 b08:	01c5d713          	srli	a4,a1,0x1c
 b0c:	973e                	add	a4,a4,a5
 b0e:	fae68ae3          	beq	a3,a4,ac2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 b12:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b14:	00000717          	auipc	a4,0x0
 b18:	28f73623          	sd	a5,652(a4) # da0 <freep>
}
 b1c:	6422                	ld	s0,8(sp)
 b1e:	0141                	addi	sp,sp,16
 b20:	8082                	ret

0000000000000b22 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b22:	7139                	addi	sp,sp,-64
 b24:	fc06                	sd	ra,56(sp)
 b26:	f822                	sd	s0,48(sp)
 b28:	f426                	sd	s1,40(sp)
 b2a:	f04a                	sd	s2,32(sp)
 b2c:	ec4e                	sd	s3,24(sp)
 b2e:	e852                	sd	s4,16(sp)
 b30:	e456                	sd	s5,8(sp)
 b32:	e05a                	sd	s6,0(sp)
 b34:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b36:	02051493          	slli	s1,a0,0x20
 b3a:	9081                	srli	s1,s1,0x20
 b3c:	04bd                	addi	s1,s1,15
 b3e:	8091                	srli	s1,s1,0x4
 b40:	0014899b          	addiw	s3,s1,1
 b44:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b46:	00000517          	auipc	a0,0x0
 b4a:	25a53503          	ld	a0,602(a0) # da0 <freep>
 b4e:	c515                	beqz	a0,b7a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b50:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b52:	4798                	lw	a4,8(a5)
 b54:	02977f63          	bgeu	a4,s1,b92 <malloc+0x70>
 b58:	8a4e                	mv	s4,s3
 b5a:	0009871b          	sext.w	a4,s3
 b5e:	6685                	lui	a3,0x1
 b60:	00d77363          	bgeu	a4,a3,b66 <malloc+0x44>
 b64:	6a05                	lui	s4,0x1
 b66:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b6a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b6e:	00000917          	auipc	s2,0x0
 b72:	23290913          	addi	s2,s2,562 # da0 <freep>
  if(p == (char*)-1)
 b76:	5afd                	li	s5,-1
 b78:	a895                	j	bec <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 b7a:	00008797          	auipc	a5,0x8
 b7e:	40e78793          	addi	a5,a5,1038 # 8f88 <base>
 b82:	00000717          	auipc	a4,0x0
 b86:	20f73f23          	sd	a5,542(a4) # da0 <freep>
 b8a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b8c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b90:	b7e1                	j	b58 <malloc+0x36>
      if(p->s.size == nunits)
 b92:	02e48c63          	beq	s1,a4,bca <malloc+0xa8>
        p->s.size -= nunits;
 b96:	4137073b          	subw	a4,a4,s3
 b9a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b9c:	02071693          	slli	a3,a4,0x20
 ba0:	01c6d713          	srli	a4,a3,0x1c
 ba4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ba6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 baa:	00000717          	auipc	a4,0x0
 bae:	1ea73b23          	sd	a0,502(a4) # da0 <freep>
      return (void*)(p + 1);
 bb2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 bb6:	70e2                	ld	ra,56(sp)
 bb8:	7442                	ld	s0,48(sp)
 bba:	74a2                	ld	s1,40(sp)
 bbc:	7902                	ld	s2,32(sp)
 bbe:	69e2                	ld	s3,24(sp)
 bc0:	6a42                	ld	s4,16(sp)
 bc2:	6aa2                	ld	s5,8(sp)
 bc4:	6b02                	ld	s6,0(sp)
 bc6:	6121                	addi	sp,sp,64
 bc8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 bca:	6398                	ld	a4,0(a5)
 bcc:	e118                	sd	a4,0(a0)
 bce:	bff1                	j	baa <malloc+0x88>
  hp->s.size = nu;
 bd0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bd4:	0541                	addi	a0,a0,16
 bd6:	00000097          	auipc	ra,0x0
 bda:	eca080e7          	jalr	-310(ra) # aa0 <free>
  return freep;
 bde:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 be2:	d971                	beqz	a0,bb6 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 be4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 be6:	4798                	lw	a4,8(a5)
 be8:	fa9775e3          	bgeu	a4,s1,b92 <malloc+0x70>
    if(p == freep)
 bec:	00093703          	ld	a4,0(s2)
 bf0:	853e                	mv	a0,a5
 bf2:	fef719e3          	bne	a4,a5,be4 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 bf6:	8552                	mv	a0,s4
 bf8:	00000097          	auipc	ra,0x0
 bfc:	b80080e7          	jalr	-1152(ra) # 778 <sbrk>
  if(p == (char*)-1)
 c00:	fd5518e3          	bne	a0,s5,bd0 <malloc+0xae>
        return 0;
 c04:	4501                	li	a0,0
 c06:	bf45                	j	bb6 <malloc+0x94>
