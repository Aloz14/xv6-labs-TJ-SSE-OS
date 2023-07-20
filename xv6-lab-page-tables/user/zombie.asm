
user/_zombie：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	00000097          	auipc	ra,0x0
   c:	2b6080e7          	jalr	694(ra) # 2be <fork>
  10:	00a04763          	bgtz	a0,1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  exit(0);
  14:	4501                	li	a0,0
  16:	00000097          	auipc	ra,0x0
  1a:	2b0080e7          	jalr	688(ra) # 2c6 <exit>
    sleep(5);  // Let child exit before parent.
  1e:	4515                	li	a0,5
  20:	00000097          	auipc	ra,0x0
  24:	336080e7          	jalr	822(ra) # 356 <sleep>
  28:	b7f5                	j	14 <main+0x14>

000000000000002a <_main>:

//
// wrapper so that it's OK if main() does not call exit().
//
void _main()
{
  2a:	1141                	addi	sp,sp,-16
  2c:	e406                	sd	ra,8(sp)
  2e:	e022                	sd	s0,0(sp)
  30:	0800                	addi	s0,sp,16
    extern int main();
    main();
  32:	00000097          	auipc	ra,0x0
  36:	fce080e7          	jalr	-50(ra) # 0 <main>
    exit(0);
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	28a080e7          	jalr	650(ra) # 2c6 <exit>

0000000000000044 <strcpy>:
}

char *strcpy(char *s, const char *t)
{
  44:	1141                	addi	sp,sp,-16
  46:	e422                	sd	s0,8(sp)
  48:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
  4a:	87aa                	mv	a5,a0
  4c:	0585                	addi	a1,a1,1
  4e:	0785                	addi	a5,a5,1
  50:	fff5c703          	lbu	a4,-1(a1)
  54:	fee78fa3          	sb	a4,-1(a5)
  58:	fb75                	bnez	a4,4c <strcpy+0x8>
        ;
    return os;
}
  5a:	6422                	ld	s0,8(sp)
  5c:	0141                	addi	sp,sp,16
  5e:	8082                	ret

0000000000000060 <strcmp>:

int strcmp(const char *p, const char *q)
{
  60:	1141                	addi	sp,sp,-16
  62:	e422                	sd	s0,8(sp)
  64:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
  66:	00054783          	lbu	a5,0(a0)
  6a:	cb91                	beqz	a5,7e <strcmp+0x1e>
  6c:	0005c703          	lbu	a4,0(a1)
  70:	00f71763          	bne	a4,a5,7e <strcmp+0x1e>
        p++, q++;
  74:	0505                	addi	a0,a0,1
  76:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
  78:	00054783          	lbu	a5,0(a0)
  7c:	fbe5                	bnez	a5,6c <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
  7e:	0005c503          	lbu	a0,0(a1)
}
  82:	40a7853b          	subw	a0,a5,a0
  86:	6422                	ld	s0,8(sp)
  88:	0141                	addi	sp,sp,16
  8a:	8082                	ret

000000000000008c <strlen>:

uint strlen(const char *s)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e422                	sd	s0,8(sp)
  90:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
  92:	00054783          	lbu	a5,0(a0)
  96:	cf91                	beqz	a5,b2 <strlen+0x26>
  98:	0505                	addi	a0,a0,1
  9a:	87aa                	mv	a5,a0
  9c:	4685                	li	a3,1
  9e:	9e89                	subw	a3,a3,a0
  a0:	00f6853b          	addw	a0,a3,a5
  a4:	0785                	addi	a5,a5,1
  a6:	fff7c703          	lbu	a4,-1(a5)
  aa:	fb7d                	bnez	a4,a0 <strlen+0x14>
        ;
    return n;
}
  ac:	6422                	ld	s0,8(sp)
  ae:	0141                	addi	sp,sp,16
  b0:	8082                	ret
    for (n = 0; s[n]; n++)
  b2:	4501                	li	a0,0
  b4:	bfe5                	j	ac <strlen+0x20>

00000000000000b6 <memset>:

void *memset(void *dst, int c, uint n)
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++) {
  bc:	ca19                	beqz	a2,d2 <memset+0x1c>
  be:	87aa                	mv	a5,a0
  c0:	1602                	slli	a2,a2,0x20
  c2:	9201                	srli	a2,a2,0x20
  c4:	00a60733          	add	a4,a2,a0
        cdst[i] = c;
  c8:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++) {
  cc:	0785                	addi	a5,a5,1
  ce:	fee79de3          	bne	a5,a4,c8 <memset+0x12>
    }
    return dst;
}
  d2:	6422                	ld	s0,8(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret

00000000000000d8 <strchr>:

char *strchr(const char *s, char c)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e422                	sd	s0,8(sp)
  dc:	0800                	addi	s0,sp,16
    for (; *s; s++)
  de:	00054783          	lbu	a5,0(a0)
  e2:	cb99                	beqz	a5,f8 <strchr+0x20>
        if (*s == c)
  e4:	00f58763          	beq	a1,a5,f2 <strchr+0x1a>
    for (; *s; s++)
  e8:	0505                	addi	a0,a0,1
  ea:	00054783          	lbu	a5,0(a0)
  ee:	fbfd                	bnez	a5,e4 <strchr+0xc>
            return (char *)s;
    return 0;
  f0:	4501                	li	a0,0
}
  f2:	6422                	ld	s0,8(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret
    return 0;
  f8:	4501                	li	a0,0
  fa:	bfe5                	j	f2 <strchr+0x1a>

00000000000000fc <gets>:

char *gets(char *buf, int max)
{
  fc:	711d                	addi	sp,sp,-96
  fe:	ec86                	sd	ra,88(sp)
 100:	e8a2                	sd	s0,80(sp)
 102:	e4a6                	sd	s1,72(sp)
 104:	e0ca                	sd	s2,64(sp)
 106:	fc4e                	sd	s3,56(sp)
 108:	f852                	sd	s4,48(sp)
 10a:	f456                	sd	s5,40(sp)
 10c:	f05a                	sd	s6,32(sp)
 10e:	ec5e                	sd	s7,24(sp)
 110:	1080                	addi	s0,sp,96
 112:	8baa                	mv	s7,a0
 114:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;) {
 116:	892a                	mv	s2,a0
 118:	4481                	li	s1,0
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 11a:	4aa9                	li	s5,10
 11c:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;) {
 11e:	89a6                	mv	s3,s1
 120:	2485                	addiw	s1,s1,1
 122:	0344d863          	bge	s1,s4,152 <gets+0x56>
        cc = read(0, &c, 1);
 126:	4605                	li	a2,1
 128:	faf40593          	addi	a1,s0,-81
 12c:	4501                	li	a0,0
 12e:	00000097          	auipc	ra,0x0
 132:	1b0080e7          	jalr	432(ra) # 2de <read>
        if (cc < 1)
 136:	00a05e63          	blez	a0,152 <gets+0x56>
        buf[i++] = c;
 13a:	faf44783          	lbu	a5,-81(s0)
 13e:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 142:	01578763          	beq	a5,s5,150 <gets+0x54>
 146:	0905                	addi	s2,s2,1
 148:	fd679be3          	bne	a5,s6,11e <gets+0x22>
    for (i = 0; i + 1 < max;) {
 14c:	89a6                	mv	s3,s1
 14e:	a011                	j	152 <gets+0x56>
 150:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 152:	99de                	add	s3,s3,s7
 154:	00098023          	sb	zero,0(s3)
    return buf;
}
 158:	855e                	mv	a0,s7
 15a:	60e6                	ld	ra,88(sp)
 15c:	6446                	ld	s0,80(sp)
 15e:	64a6                	ld	s1,72(sp)
 160:	6906                	ld	s2,64(sp)
 162:	79e2                	ld	s3,56(sp)
 164:	7a42                	ld	s4,48(sp)
 166:	7aa2                	ld	s5,40(sp)
 168:	7b02                	ld	s6,32(sp)
 16a:	6be2                	ld	s7,24(sp)
 16c:	6125                	addi	sp,sp,96
 16e:	8082                	ret

0000000000000170 <stat>:

int stat(const char *n, struct stat *st)
{
 170:	1101                	addi	sp,sp,-32
 172:	ec06                	sd	ra,24(sp)
 174:	e822                	sd	s0,16(sp)
 176:	e426                	sd	s1,8(sp)
 178:	e04a                	sd	s2,0(sp)
 17a:	1000                	addi	s0,sp,32
 17c:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 17e:	4581                	li	a1,0
 180:	00000097          	auipc	ra,0x0
 184:	186080e7          	jalr	390(ra) # 306 <open>
    if (fd < 0)
 188:	02054563          	bltz	a0,1b2 <stat+0x42>
 18c:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 18e:	85ca                	mv	a1,s2
 190:	00000097          	auipc	ra,0x0
 194:	18e080e7          	jalr	398(ra) # 31e <fstat>
 198:	892a                	mv	s2,a0
    close(fd);
 19a:	8526                	mv	a0,s1
 19c:	00000097          	auipc	ra,0x0
 1a0:	152080e7          	jalr	338(ra) # 2ee <close>
    return r;
}
 1a4:	854a                	mv	a0,s2
 1a6:	60e2                	ld	ra,24(sp)
 1a8:	6442                	ld	s0,16(sp)
 1aa:	64a2                	ld	s1,8(sp)
 1ac:	6902                	ld	s2,0(sp)
 1ae:	6105                	addi	sp,sp,32
 1b0:	8082                	ret
        return -1;
 1b2:	597d                	li	s2,-1
 1b4:	bfc5                	j	1a4 <stat+0x34>

00000000000001b6 <atoi>:

int atoi(const char *s)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e422                	sd	s0,8(sp)
 1ba:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 1bc:	00054683          	lbu	a3,0(a0)
 1c0:	fd06879b          	addiw	a5,a3,-48
 1c4:	0ff7f793          	zext.b	a5,a5
 1c8:	4625                	li	a2,9
 1ca:	02f66863          	bltu	a2,a5,1fa <atoi+0x44>
 1ce:	872a                	mv	a4,a0
    n = 0;
 1d0:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
 1d2:	0705                	addi	a4,a4,1
 1d4:	0025179b          	slliw	a5,a0,0x2
 1d8:	9fa9                	addw	a5,a5,a0
 1da:	0017979b          	slliw	a5,a5,0x1
 1de:	9fb5                	addw	a5,a5,a3
 1e0:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 1e4:	00074683          	lbu	a3,0(a4)
 1e8:	fd06879b          	addiw	a5,a3,-48
 1ec:	0ff7f793          	zext.b	a5,a5
 1f0:	fef671e3          	bgeu	a2,a5,1d2 <atoi+0x1c>
    return n;
}
 1f4:	6422                	ld	s0,8(sp)
 1f6:	0141                	addi	sp,sp,16
 1f8:	8082                	ret
    n = 0;
 1fa:	4501                	li	a0,0
 1fc:	bfe5                	j	1f4 <atoi+0x3e>

00000000000001fe <memmove>:

void *memmove(void *vdst, const void *vsrc, int n)
{
 1fe:	1141                	addi	sp,sp,-16
 200:	e422                	sd	s0,8(sp)
 202:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst) {
 204:	02b57463          	bgeu	a0,a1,22c <memmove+0x2e>
        while (n-- > 0)
 208:	00c05f63          	blez	a2,226 <memmove+0x28>
 20c:	1602                	slli	a2,a2,0x20
 20e:	9201                	srli	a2,a2,0x20
 210:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 214:	872a                	mv	a4,a0
            *dst++ = *src++;
 216:	0585                	addi	a1,a1,1
 218:	0705                	addi	a4,a4,1
 21a:	fff5c683          	lbu	a3,-1(a1)
 21e:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 222:	fee79ae3          	bne	a5,a4,216 <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 226:	6422                	ld	s0,8(sp)
 228:	0141                	addi	sp,sp,16
 22a:	8082                	ret
        dst += n;
 22c:	00c50733          	add	a4,a0,a2
        src += n;
 230:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 232:	fec05ae3          	blez	a2,226 <memmove+0x28>
 236:	fff6079b          	addiw	a5,a2,-1
 23a:	1782                	slli	a5,a5,0x20
 23c:	9381                	srli	a5,a5,0x20
 23e:	fff7c793          	not	a5,a5
 242:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 244:	15fd                	addi	a1,a1,-1
 246:	177d                	addi	a4,a4,-1
 248:	0005c683          	lbu	a3,0(a1)
 24c:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 250:	fee79ae3          	bne	a5,a4,244 <memmove+0x46>
 254:	bfc9                	j	226 <memmove+0x28>

0000000000000256 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 256:	1141                	addi	sp,sp,-16
 258:	e422                	sd	s0,8(sp)
 25a:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0) {
 25c:	ca05                	beqz	a2,28c <memcmp+0x36>
 25e:	fff6069b          	addiw	a3,a2,-1
 262:	1682                	slli	a3,a3,0x20
 264:	9281                	srli	a3,a3,0x20
 266:	0685                	addi	a3,a3,1
 268:	96aa                	add	a3,a3,a0
        if (*p1 != *p2) {
 26a:	00054783          	lbu	a5,0(a0)
 26e:	0005c703          	lbu	a4,0(a1)
 272:	00e79863          	bne	a5,a4,282 <memcmp+0x2c>
            return *p1 - *p2;
        }
        p1++;
 276:	0505                	addi	a0,a0,1
        p2++;
 278:	0585                	addi	a1,a1,1
    while (n-- > 0) {
 27a:	fed518e3          	bne	a0,a3,26a <memcmp+0x14>
    }
    return 0;
 27e:	4501                	li	a0,0
 280:	a019                	j	286 <memcmp+0x30>
            return *p1 - *p2;
 282:	40e7853b          	subw	a0,a5,a4
}
 286:	6422                	ld	s0,8(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret
    return 0;
 28c:	4501                	li	a0,0
 28e:	bfe5                	j	286 <memcmp+0x30>

0000000000000290 <memcpy>:

void *memcpy(void *dst, const void *src, uint n)
{
 290:	1141                	addi	sp,sp,-16
 292:	e406                	sd	ra,8(sp)
 294:	e022                	sd	s0,0(sp)
 296:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 298:	00000097          	auipc	ra,0x0
 29c:	f66080e7          	jalr	-154(ra) # 1fe <memmove>
}
 2a0:	60a2                	ld	ra,8(sp)
 2a2:	6402                	ld	s0,0(sp)
 2a4:	0141                	addi	sp,sp,16
 2a6:	8082                	ret

00000000000002a8 <ugetpid>:

#ifdef LAB_PGTBL
int ugetpid(void)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e422                	sd	s0,8(sp)
 2ac:	0800                	addi	s0,sp,16
    struct usyscall *u = (struct usyscall *)USYSCALL;
    return u->pid;
 2ae:	040007b7          	lui	a5,0x4000
}
 2b2:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ffefed>
 2b4:	07b2                	slli	a5,a5,0xc
 2b6:	4388                	lw	a0,0(a5)
 2b8:	6422                	ld	s0,8(sp)
 2ba:	0141                	addi	sp,sp,16
 2bc:	8082                	ret

00000000000002be <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2be:	4885                	li	a7,1
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2c6:	4889                	li	a7,2
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ce:	488d                	li	a7,3
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2d6:	4891                	li	a7,4
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <read>:
.global read
read:
 li a7, SYS_read
 2de:	4895                	li	a7,5
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <write>:
.global write
write:
 li a7, SYS_write
 2e6:	48c1                	li	a7,16
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <close>:
.global close
close:
 li a7, SYS_close
 2ee:	48d5                	li	a7,21
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2f6:	4899                	li	a7,6
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <exec>:
.global exec
exec:
 li a7, SYS_exec
 2fe:	489d                	li	a7,7
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <open>:
.global open
open:
 li a7, SYS_open
 306:	48bd                	li	a7,15
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 30e:	48c5                	li	a7,17
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 316:	48c9                	li	a7,18
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 31e:	48a1                	li	a7,8
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <link>:
.global link
link:
 li a7, SYS_link
 326:	48cd                	li	a7,19
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 32e:	48d1                	li	a7,20
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 336:	48a5                	li	a7,9
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <dup>:
.global dup
dup:
 li a7, SYS_dup
 33e:	48a9                	li	a7,10
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 346:	48ad                	li	a7,11
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 34e:	48b1                	li	a7,12
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 356:	48b5                	li	a7,13
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 35e:	48b9                	li	a7,14
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <connect>:
.global connect
connect:
 li a7, SYS_connect
 366:	48f5                	li	a7,29
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 36e:	48f9                	li	a7,30
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 376:	1101                	addi	sp,sp,-32
 378:	ec06                	sd	ra,24(sp)
 37a:	e822                	sd	s0,16(sp)
 37c:	1000                	addi	s0,sp,32
 37e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 382:	4605                	li	a2,1
 384:	fef40593          	addi	a1,s0,-17
 388:	00000097          	auipc	ra,0x0
 38c:	f5e080e7          	jalr	-162(ra) # 2e6 <write>
}
 390:	60e2                	ld	ra,24(sp)
 392:	6442                	ld	s0,16(sp)
 394:	6105                	addi	sp,sp,32
 396:	8082                	ret

0000000000000398 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 398:	7139                	addi	sp,sp,-64
 39a:	fc06                	sd	ra,56(sp)
 39c:	f822                	sd	s0,48(sp)
 39e:	f426                	sd	s1,40(sp)
 3a0:	f04a                	sd	s2,32(sp)
 3a2:	ec4e                	sd	s3,24(sp)
 3a4:	0080                	addi	s0,sp,64
 3a6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a8:	c299                	beqz	a3,3ae <printint+0x16>
 3aa:	0805c963          	bltz	a1,43c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3ae:	2581                	sext.w	a1,a1
  neg = 0;
 3b0:	4881                	li	a7,0
 3b2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3b6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3b8:	2601                	sext.w	a2,a2
 3ba:	00000517          	auipc	a0,0x0
 3be:	49650513          	addi	a0,a0,1174 # 850 <digits>
 3c2:	883a                	mv	a6,a4
 3c4:	2705                	addiw	a4,a4,1
 3c6:	02c5f7bb          	remuw	a5,a1,a2
 3ca:	1782                	slli	a5,a5,0x20
 3cc:	9381                	srli	a5,a5,0x20
 3ce:	97aa                	add	a5,a5,a0
 3d0:	0007c783          	lbu	a5,0(a5)
 3d4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3d8:	0005879b          	sext.w	a5,a1
 3dc:	02c5d5bb          	divuw	a1,a1,a2
 3e0:	0685                	addi	a3,a3,1
 3e2:	fec7f0e3          	bgeu	a5,a2,3c2 <printint+0x2a>
  if(neg)
 3e6:	00088c63          	beqz	a7,3fe <printint+0x66>
    buf[i++] = '-';
 3ea:	fd070793          	addi	a5,a4,-48
 3ee:	00878733          	add	a4,a5,s0
 3f2:	02d00793          	li	a5,45
 3f6:	fef70823          	sb	a5,-16(a4)
 3fa:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3fe:	02e05863          	blez	a4,42e <printint+0x96>
 402:	fc040793          	addi	a5,s0,-64
 406:	00e78933          	add	s2,a5,a4
 40a:	fff78993          	addi	s3,a5,-1
 40e:	99ba                	add	s3,s3,a4
 410:	377d                	addiw	a4,a4,-1
 412:	1702                	slli	a4,a4,0x20
 414:	9301                	srli	a4,a4,0x20
 416:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 41a:	fff94583          	lbu	a1,-1(s2)
 41e:	8526                	mv	a0,s1
 420:	00000097          	auipc	ra,0x0
 424:	f56080e7          	jalr	-170(ra) # 376 <putc>
  while(--i >= 0)
 428:	197d                	addi	s2,s2,-1
 42a:	ff3918e3          	bne	s2,s3,41a <printint+0x82>
}
 42e:	70e2                	ld	ra,56(sp)
 430:	7442                	ld	s0,48(sp)
 432:	74a2                	ld	s1,40(sp)
 434:	7902                	ld	s2,32(sp)
 436:	69e2                	ld	s3,24(sp)
 438:	6121                	addi	sp,sp,64
 43a:	8082                	ret
    x = -xx;
 43c:	40b005bb          	negw	a1,a1
    neg = 1;
 440:	4885                	li	a7,1
    x = -xx;
 442:	bf85                	j	3b2 <printint+0x1a>

0000000000000444 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 444:	7119                	addi	sp,sp,-128
 446:	fc86                	sd	ra,120(sp)
 448:	f8a2                	sd	s0,112(sp)
 44a:	f4a6                	sd	s1,104(sp)
 44c:	f0ca                	sd	s2,96(sp)
 44e:	ecce                	sd	s3,88(sp)
 450:	e8d2                	sd	s4,80(sp)
 452:	e4d6                	sd	s5,72(sp)
 454:	e0da                	sd	s6,64(sp)
 456:	fc5e                	sd	s7,56(sp)
 458:	f862                	sd	s8,48(sp)
 45a:	f466                	sd	s9,40(sp)
 45c:	f06a                	sd	s10,32(sp)
 45e:	ec6e                	sd	s11,24(sp)
 460:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 462:	0005c903          	lbu	s2,0(a1)
 466:	18090f63          	beqz	s2,604 <vprintf+0x1c0>
 46a:	8aaa                	mv	s5,a0
 46c:	8b32                	mv	s6,a2
 46e:	00158493          	addi	s1,a1,1
  state = 0;
 472:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 474:	02500a13          	li	s4,37
 478:	4c55                	li	s8,21
 47a:	00000c97          	auipc	s9,0x0
 47e:	37ec8c93          	addi	s9,s9,894 # 7f8 <malloc+0xf0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 482:	02800d93          	li	s11,40
  putc(fd, 'x');
 486:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 488:	00000b97          	auipc	s7,0x0
 48c:	3c8b8b93          	addi	s7,s7,968 # 850 <digits>
 490:	a839                	j	4ae <vprintf+0x6a>
        putc(fd, c);
 492:	85ca                	mv	a1,s2
 494:	8556                	mv	a0,s5
 496:	00000097          	auipc	ra,0x0
 49a:	ee0080e7          	jalr	-288(ra) # 376 <putc>
 49e:	a019                	j	4a4 <vprintf+0x60>
    } else if(state == '%'){
 4a0:	01498d63          	beq	s3,s4,4ba <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 4a4:	0485                	addi	s1,s1,1
 4a6:	fff4c903          	lbu	s2,-1(s1)
 4aa:	14090d63          	beqz	s2,604 <vprintf+0x1c0>
    if(state == 0){
 4ae:	fe0999e3          	bnez	s3,4a0 <vprintf+0x5c>
      if(c == '%'){
 4b2:	ff4910e3          	bne	s2,s4,492 <vprintf+0x4e>
        state = '%';
 4b6:	89d2                	mv	s3,s4
 4b8:	b7f5                	j	4a4 <vprintf+0x60>
      if(c == 'd'){
 4ba:	11490c63          	beq	s2,s4,5d2 <vprintf+0x18e>
 4be:	f9d9079b          	addiw	a5,s2,-99
 4c2:	0ff7f793          	zext.b	a5,a5
 4c6:	10fc6e63          	bltu	s8,a5,5e2 <vprintf+0x19e>
 4ca:	f9d9079b          	addiw	a5,s2,-99
 4ce:	0ff7f713          	zext.b	a4,a5
 4d2:	10ec6863          	bltu	s8,a4,5e2 <vprintf+0x19e>
 4d6:	00271793          	slli	a5,a4,0x2
 4da:	97e6                	add	a5,a5,s9
 4dc:	439c                	lw	a5,0(a5)
 4de:	97e6                	add	a5,a5,s9
 4e0:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4e2:	008b0913          	addi	s2,s6,8
 4e6:	4685                	li	a3,1
 4e8:	4629                	li	a2,10
 4ea:	000b2583          	lw	a1,0(s6)
 4ee:	8556                	mv	a0,s5
 4f0:	00000097          	auipc	ra,0x0
 4f4:	ea8080e7          	jalr	-344(ra) # 398 <printint>
 4f8:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4fa:	4981                	li	s3,0
 4fc:	b765                	j	4a4 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4fe:	008b0913          	addi	s2,s6,8
 502:	4681                	li	a3,0
 504:	4629                	li	a2,10
 506:	000b2583          	lw	a1,0(s6)
 50a:	8556                	mv	a0,s5
 50c:	00000097          	auipc	ra,0x0
 510:	e8c080e7          	jalr	-372(ra) # 398 <printint>
 514:	8b4a                	mv	s6,s2
      state = 0;
 516:	4981                	li	s3,0
 518:	b771                	j	4a4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 51a:	008b0913          	addi	s2,s6,8
 51e:	4681                	li	a3,0
 520:	866a                	mv	a2,s10
 522:	000b2583          	lw	a1,0(s6)
 526:	8556                	mv	a0,s5
 528:	00000097          	auipc	ra,0x0
 52c:	e70080e7          	jalr	-400(ra) # 398 <printint>
 530:	8b4a                	mv	s6,s2
      state = 0;
 532:	4981                	li	s3,0
 534:	bf85                	j	4a4 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 536:	008b0793          	addi	a5,s6,8
 53a:	f8f43423          	sd	a5,-120(s0)
 53e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 542:	03000593          	li	a1,48
 546:	8556                	mv	a0,s5
 548:	00000097          	auipc	ra,0x0
 54c:	e2e080e7          	jalr	-466(ra) # 376 <putc>
  putc(fd, 'x');
 550:	07800593          	li	a1,120
 554:	8556                	mv	a0,s5
 556:	00000097          	auipc	ra,0x0
 55a:	e20080e7          	jalr	-480(ra) # 376 <putc>
 55e:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 560:	03c9d793          	srli	a5,s3,0x3c
 564:	97de                	add	a5,a5,s7
 566:	0007c583          	lbu	a1,0(a5)
 56a:	8556                	mv	a0,s5
 56c:	00000097          	auipc	ra,0x0
 570:	e0a080e7          	jalr	-502(ra) # 376 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 574:	0992                	slli	s3,s3,0x4
 576:	397d                	addiw	s2,s2,-1
 578:	fe0914e3          	bnez	s2,560 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 57c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 580:	4981                	li	s3,0
 582:	b70d                	j	4a4 <vprintf+0x60>
        s = va_arg(ap, char*);
 584:	008b0913          	addi	s2,s6,8
 588:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 58c:	02098163          	beqz	s3,5ae <vprintf+0x16a>
        while(*s != 0){
 590:	0009c583          	lbu	a1,0(s3)
 594:	c5ad                	beqz	a1,5fe <vprintf+0x1ba>
          putc(fd, *s);
 596:	8556                	mv	a0,s5
 598:	00000097          	auipc	ra,0x0
 59c:	dde080e7          	jalr	-546(ra) # 376 <putc>
          s++;
 5a0:	0985                	addi	s3,s3,1
        while(*s != 0){
 5a2:	0009c583          	lbu	a1,0(s3)
 5a6:	f9e5                	bnez	a1,596 <vprintf+0x152>
        s = va_arg(ap, char*);
 5a8:	8b4a                	mv	s6,s2
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	bde5                	j	4a4 <vprintf+0x60>
          s = "(null)";
 5ae:	00000997          	auipc	s3,0x0
 5b2:	24298993          	addi	s3,s3,578 # 7f0 <malloc+0xe8>
        while(*s != 0){
 5b6:	85ee                	mv	a1,s11
 5b8:	bff9                	j	596 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 5ba:	008b0913          	addi	s2,s6,8
 5be:	000b4583          	lbu	a1,0(s6)
 5c2:	8556                	mv	a0,s5
 5c4:	00000097          	auipc	ra,0x0
 5c8:	db2080e7          	jalr	-590(ra) # 376 <putc>
 5cc:	8b4a                	mv	s6,s2
      state = 0;
 5ce:	4981                	li	s3,0
 5d0:	bdd1                	j	4a4 <vprintf+0x60>
        putc(fd, c);
 5d2:	85d2                	mv	a1,s4
 5d4:	8556                	mv	a0,s5
 5d6:	00000097          	auipc	ra,0x0
 5da:	da0080e7          	jalr	-608(ra) # 376 <putc>
      state = 0;
 5de:	4981                	li	s3,0
 5e0:	b5d1                	j	4a4 <vprintf+0x60>
        putc(fd, '%');
 5e2:	85d2                	mv	a1,s4
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	d90080e7          	jalr	-624(ra) # 376 <putc>
        putc(fd, c);
 5ee:	85ca                	mv	a1,s2
 5f0:	8556                	mv	a0,s5
 5f2:	00000097          	auipc	ra,0x0
 5f6:	d84080e7          	jalr	-636(ra) # 376 <putc>
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	b565                	j	4a4 <vprintf+0x60>
        s = va_arg(ap, char*);
 5fe:	8b4a                	mv	s6,s2
      state = 0;
 600:	4981                	li	s3,0
 602:	b54d                	j	4a4 <vprintf+0x60>
    }
  }
}
 604:	70e6                	ld	ra,120(sp)
 606:	7446                	ld	s0,112(sp)
 608:	74a6                	ld	s1,104(sp)
 60a:	7906                	ld	s2,96(sp)
 60c:	69e6                	ld	s3,88(sp)
 60e:	6a46                	ld	s4,80(sp)
 610:	6aa6                	ld	s5,72(sp)
 612:	6b06                	ld	s6,64(sp)
 614:	7be2                	ld	s7,56(sp)
 616:	7c42                	ld	s8,48(sp)
 618:	7ca2                	ld	s9,40(sp)
 61a:	7d02                	ld	s10,32(sp)
 61c:	6de2                	ld	s11,24(sp)
 61e:	6109                	addi	sp,sp,128
 620:	8082                	ret

0000000000000622 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 622:	715d                	addi	sp,sp,-80
 624:	ec06                	sd	ra,24(sp)
 626:	e822                	sd	s0,16(sp)
 628:	1000                	addi	s0,sp,32
 62a:	e010                	sd	a2,0(s0)
 62c:	e414                	sd	a3,8(s0)
 62e:	e818                	sd	a4,16(s0)
 630:	ec1c                	sd	a5,24(s0)
 632:	03043023          	sd	a6,32(s0)
 636:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 63a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 63e:	8622                	mv	a2,s0
 640:	00000097          	auipc	ra,0x0
 644:	e04080e7          	jalr	-508(ra) # 444 <vprintf>
}
 648:	60e2                	ld	ra,24(sp)
 64a:	6442                	ld	s0,16(sp)
 64c:	6161                	addi	sp,sp,80
 64e:	8082                	ret

0000000000000650 <printf>:

void
printf(const char *fmt, ...)
{
 650:	711d                	addi	sp,sp,-96
 652:	ec06                	sd	ra,24(sp)
 654:	e822                	sd	s0,16(sp)
 656:	1000                	addi	s0,sp,32
 658:	e40c                	sd	a1,8(s0)
 65a:	e810                	sd	a2,16(s0)
 65c:	ec14                	sd	a3,24(s0)
 65e:	f018                	sd	a4,32(s0)
 660:	f41c                	sd	a5,40(s0)
 662:	03043823          	sd	a6,48(s0)
 666:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 66a:	00840613          	addi	a2,s0,8
 66e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 672:	85aa                	mv	a1,a0
 674:	4505                	li	a0,1
 676:	00000097          	auipc	ra,0x0
 67a:	dce080e7          	jalr	-562(ra) # 444 <vprintf>
}
 67e:	60e2                	ld	ra,24(sp)
 680:	6442                	ld	s0,16(sp)
 682:	6125                	addi	sp,sp,96
 684:	8082                	ret

0000000000000686 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 686:	1141                	addi	sp,sp,-16
 688:	e422                	sd	s0,8(sp)
 68a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 68c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 690:	00001797          	auipc	a5,0x1
 694:	9707b783          	ld	a5,-1680(a5) # 1000 <freep>
 698:	a02d                	j	6c2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 69a:	4618                	lw	a4,8(a2)
 69c:	9f2d                	addw	a4,a4,a1
 69e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a2:	6398                	ld	a4,0(a5)
 6a4:	6310                	ld	a2,0(a4)
 6a6:	a83d                	j	6e4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6a8:	ff852703          	lw	a4,-8(a0)
 6ac:	9f31                	addw	a4,a4,a2
 6ae:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6b0:	ff053683          	ld	a3,-16(a0)
 6b4:	a091                	j	6f8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b6:	6398                	ld	a4,0(a5)
 6b8:	00e7e463          	bltu	a5,a4,6c0 <free+0x3a>
 6bc:	00e6ea63          	bltu	a3,a4,6d0 <free+0x4a>
{
 6c0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c2:	fed7fae3          	bgeu	a5,a3,6b6 <free+0x30>
 6c6:	6398                	ld	a4,0(a5)
 6c8:	00e6e463          	bltu	a3,a4,6d0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6cc:	fee7eae3          	bltu	a5,a4,6c0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6d0:	ff852583          	lw	a1,-8(a0)
 6d4:	6390                	ld	a2,0(a5)
 6d6:	02059813          	slli	a6,a1,0x20
 6da:	01c85713          	srli	a4,a6,0x1c
 6de:	9736                	add	a4,a4,a3
 6e0:	fae60de3          	beq	a2,a4,69a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6e4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6e8:	4790                	lw	a2,8(a5)
 6ea:	02061593          	slli	a1,a2,0x20
 6ee:	01c5d713          	srli	a4,a1,0x1c
 6f2:	973e                	add	a4,a4,a5
 6f4:	fae68ae3          	beq	a3,a4,6a8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 6f8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6fa:	00001717          	auipc	a4,0x1
 6fe:	90f73323          	sd	a5,-1786(a4) # 1000 <freep>
}
 702:	6422                	ld	s0,8(sp)
 704:	0141                	addi	sp,sp,16
 706:	8082                	ret

0000000000000708 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 708:	7139                	addi	sp,sp,-64
 70a:	fc06                	sd	ra,56(sp)
 70c:	f822                	sd	s0,48(sp)
 70e:	f426                	sd	s1,40(sp)
 710:	f04a                	sd	s2,32(sp)
 712:	ec4e                	sd	s3,24(sp)
 714:	e852                	sd	s4,16(sp)
 716:	e456                	sd	s5,8(sp)
 718:	e05a                	sd	s6,0(sp)
 71a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 71c:	02051493          	slli	s1,a0,0x20
 720:	9081                	srli	s1,s1,0x20
 722:	04bd                	addi	s1,s1,15
 724:	8091                	srli	s1,s1,0x4
 726:	0014899b          	addiw	s3,s1,1
 72a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 72c:	00001517          	auipc	a0,0x1
 730:	8d453503          	ld	a0,-1836(a0) # 1000 <freep>
 734:	c515                	beqz	a0,760 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 736:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 738:	4798                	lw	a4,8(a5)
 73a:	02977f63          	bgeu	a4,s1,778 <malloc+0x70>
 73e:	8a4e                	mv	s4,s3
 740:	0009871b          	sext.w	a4,s3
 744:	6685                	lui	a3,0x1
 746:	00d77363          	bgeu	a4,a3,74c <malloc+0x44>
 74a:	6a05                	lui	s4,0x1
 74c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 750:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 754:	00001917          	auipc	s2,0x1
 758:	8ac90913          	addi	s2,s2,-1876 # 1000 <freep>
  if(p == (char*)-1)
 75c:	5afd                	li	s5,-1
 75e:	a895                	j	7d2 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 760:	00001797          	auipc	a5,0x1
 764:	8b078793          	addi	a5,a5,-1872 # 1010 <base>
 768:	00001717          	auipc	a4,0x1
 76c:	88f73c23          	sd	a5,-1896(a4) # 1000 <freep>
 770:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 772:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 776:	b7e1                	j	73e <malloc+0x36>
      if(p->s.size == nunits)
 778:	02e48c63          	beq	s1,a4,7b0 <malloc+0xa8>
        p->s.size -= nunits;
 77c:	4137073b          	subw	a4,a4,s3
 780:	c798                	sw	a4,8(a5)
        p += p->s.size;
 782:	02071693          	slli	a3,a4,0x20
 786:	01c6d713          	srli	a4,a3,0x1c
 78a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 78c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 790:	00001717          	auipc	a4,0x1
 794:	86a73823          	sd	a0,-1936(a4) # 1000 <freep>
      return (void*)(p + 1);
 798:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 79c:	70e2                	ld	ra,56(sp)
 79e:	7442                	ld	s0,48(sp)
 7a0:	74a2                	ld	s1,40(sp)
 7a2:	7902                	ld	s2,32(sp)
 7a4:	69e2                	ld	s3,24(sp)
 7a6:	6a42                	ld	s4,16(sp)
 7a8:	6aa2                	ld	s5,8(sp)
 7aa:	6b02                	ld	s6,0(sp)
 7ac:	6121                	addi	sp,sp,64
 7ae:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7b0:	6398                	ld	a4,0(a5)
 7b2:	e118                	sd	a4,0(a0)
 7b4:	bff1                	j	790 <malloc+0x88>
  hp->s.size = nu;
 7b6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7ba:	0541                	addi	a0,a0,16
 7bc:	00000097          	auipc	ra,0x0
 7c0:	eca080e7          	jalr	-310(ra) # 686 <free>
  return freep;
 7c4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7c8:	d971                	beqz	a0,79c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7cc:	4798                	lw	a4,8(a5)
 7ce:	fa9775e3          	bgeu	a4,s1,778 <malloc+0x70>
    if(p == freep)
 7d2:	00093703          	ld	a4,0(s2)
 7d6:	853e                	mv	a0,a5
 7d8:	fef719e3          	bne	a4,a5,7ca <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7dc:	8552                	mv	a0,s4
 7de:	00000097          	auipc	ra,0x0
 7e2:	b70080e7          	jalr	-1168(ra) # 34e <sbrk>
  if(p == (char*)-1)
 7e6:	fd5518e3          	bne	a0,s5,7b6 <malloc+0xae>
        return 0;
 7ea:	4501                	li	a0,0
 7ec:	bf45                	j	79c <malloc+0x94>
