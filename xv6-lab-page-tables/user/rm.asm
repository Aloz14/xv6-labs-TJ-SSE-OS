
user/_rm：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  int i;

  if(argc < 2){
   e:	4785                	li	a5,1
  10:	02a7d763          	bge	a5,a0,3e <main+0x3e>
  14:	00858493          	addi	s1,a1,8
  18:	ffe5091b          	addiw	s2,a0,-2
  1c:	02091793          	slli	a5,s2,0x20
  20:	01d7d913          	srli	s2,a5,0x1d
  24:	05c1                	addi	a1,a1,16
  26:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: rm files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
  28:	6088                	ld	a0,0(s1)
  2a:	00000097          	auipc	ra,0x0
  2e:	33a080e7          	jalr	826(ra) # 364 <unlink>
  32:	02054463          	bltz	a0,5a <main+0x5a>
  for(i = 1; i < argc; i++){
  36:	04a1                	addi	s1,s1,8
  38:	ff2498e3          	bne	s1,s2,28 <main+0x28>
  3c:	a80d                	j	6e <main+0x6e>
    fprintf(2, "Usage: rm files...\n");
  3e:	00001597          	auipc	a1,0x1
  42:	80258593          	addi	a1,a1,-2046 # 840 <malloc+0xea>
  46:	4509                	li	a0,2
  48:	00000097          	auipc	ra,0x0
  4c:	628080e7          	jalr	1576(ra) # 670 <fprintf>
    exit(1);
  50:	4505                	li	a0,1
  52:	00000097          	auipc	ra,0x0
  56:	2c2080e7          	jalr	706(ra) # 314 <exit>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
  5a:	6090                	ld	a2,0(s1)
  5c:	00000597          	auipc	a1,0x0
  60:	7fc58593          	addi	a1,a1,2044 # 858 <malloc+0x102>
  64:	4509                	li	a0,2
  66:	00000097          	auipc	ra,0x0
  6a:	60a080e7          	jalr	1546(ra) # 670 <fprintf>
      break;
    }
  }

  exit(0);
  6e:	4501                	li	a0,0
  70:	00000097          	auipc	ra,0x0
  74:	2a4080e7          	jalr	676(ra) # 314 <exit>

0000000000000078 <_main>:

//
// wrapper so that it's OK if main() does not call exit().
//
void _main()
{
  78:	1141                	addi	sp,sp,-16
  7a:	e406                	sd	ra,8(sp)
  7c:	e022                	sd	s0,0(sp)
  7e:	0800                	addi	s0,sp,16
    extern int main();
    main();
  80:	00000097          	auipc	ra,0x0
  84:	f80080e7          	jalr	-128(ra) # 0 <main>
    exit(0);
  88:	4501                	li	a0,0
  8a:	00000097          	auipc	ra,0x0
  8e:	28a080e7          	jalr	650(ra) # 314 <exit>

0000000000000092 <strcpy>:
}

char *strcpy(char *s, const char *t)
{
  92:	1141                	addi	sp,sp,-16
  94:	e422                	sd	s0,8(sp)
  96:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
  98:	87aa                	mv	a5,a0
  9a:	0585                	addi	a1,a1,1
  9c:	0785                	addi	a5,a5,1
  9e:	fff5c703          	lbu	a4,-1(a1)
  a2:	fee78fa3          	sb	a4,-1(a5)
  a6:	fb75                	bnez	a4,9a <strcpy+0x8>
        ;
    return os;
}
  a8:	6422                	ld	s0,8(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strcmp>:

int strcmp(const char *p, const char *q)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e422                	sd	s0,8(sp)
  b2:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
  b4:	00054783          	lbu	a5,0(a0)
  b8:	cb91                	beqz	a5,cc <strcmp+0x1e>
  ba:	0005c703          	lbu	a4,0(a1)
  be:	00f71763          	bne	a4,a5,cc <strcmp+0x1e>
        p++, q++;
  c2:	0505                	addi	a0,a0,1
  c4:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
  c6:	00054783          	lbu	a5,0(a0)
  ca:	fbe5                	bnez	a5,ba <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
  cc:	0005c503          	lbu	a0,0(a1)
}
  d0:	40a7853b          	subw	a0,a5,a0
  d4:	6422                	ld	s0,8(sp)
  d6:	0141                	addi	sp,sp,16
  d8:	8082                	ret

00000000000000da <strlen>:

uint strlen(const char *s)
{
  da:	1141                	addi	sp,sp,-16
  dc:	e422                	sd	s0,8(sp)
  de:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
  e0:	00054783          	lbu	a5,0(a0)
  e4:	cf91                	beqz	a5,100 <strlen+0x26>
  e6:	0505                	addi	a0,a0,1
  e8:	87aa                	mv	a5,a0
  ea:	4685                	li	a3,1
  ec:	9e89                	subw	a3,a3,a0
  ee:	00f6853b          	addw	a0,a3,a5
  f2:	0785                	addi	a5,a5,1
  f4:	fff7c703          	lbu	a4,-1(a5)
  f8:	fb7d                	bnez	a4,ee <strlen+0x14>
        ;
    return n;
}
  fa:	6422                	ld	s0,8(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret
    for (n = 0; s[n]; n++)
 100:	4501                	li	a0,0
 102:	bfe5                	j	fa <strlen+0x20>

0000000000000104 <memset>:

void *memset(void *dst, int c, uint n)
{
 104:	1141                	addi	sp,sp,-16
 106:	e422                	sd	s0,8(sp)
 108:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++) {
 10a:	ca19                	beqz	a2,120 <memset+0x1c>
 10c:	87aa                	mv	a5,a0
 10e:	1602                	slli	a2,a2,0x20
 110:	9201                	srli	a2,a2,0x20
 112:	00a60733          	add	a4,a2,a0
        cdst[i] = c;
 116:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++) {
 11a:	0785                	addi	a5,a5,1
 11c:	fee79de3          	bne	a5,a4,116 <memset+0x12>
    }
    return dst;
}
 120:	6422                	ld	s0,8(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret

0000000000000126 <strchr>:

char *strchr(const char *s, char c)
{
 126:	1141                	addi	sp,sp,-16
 128:	e422                	sd	s0,8(sp)
 12a:	0800                	addi	s0,sp,16
    for (; *s; s++)
 12c:	00054783          	lbu	a5,0(a0)
 130:	cb99                	beqz	a5,146 <strchr+0x20>
        if (*s == c)
 132:	00f58763          	beq	a1,a5,140 <strchr+0x1a>
    for (; *s; s++)
 136:	0505                	addi	a0,a0,1
 138:	00054783          	lbu	a5,0(a0)
 13c:	fbfd                	bnez	a5,132 <strchr+0xc>
            return (char *)s;
    return 0;
 13e:	4501                	li	a0,0
}
 140:	6422                	ld	s0,8(sp)
 142:	0141                	addi	sp,sp,16
 144:	8082                	ret
    return 0;
 146:	4501                	li	a0,0
 148:	bfe5                	j	140 <strchr+0x1a>

000000000000014a <gets>:

char *gets(char *buf, int max)
{
 14a:	711d                	addi	sp,sp,-96
 14c:	ec86                	sd	ra,88(sp)
 14e:	e8a2                	sd	s0,80(sp)
 150:	e4a6                	sd	s1,72(sp)
 152:	e0ca                	sd	s2,64(sp)
 154:	fc4e                	sd	s3,56(sp)
 156:	f852                	sd	s4,48(sp)
 158:	f456                	sd	s5,40(sp)
 15a:	f05a                	sd	s6,32(sp)
 15c:	ec5e                	sd	s7,24(sp)
 15e:	1080                	addi	s0,sp,96
 160:	8baa                	mv	s7,a0
 162:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;) {
 164:	892a                	mv	s2,a0
 166:	4481                	li	s1,0
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 168:	4aa9                	li	s5,10
 16a:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;) {
 16c:	89a6                	mv	s3,s1
 16e:	2485                	addiw	s1,s1,1
 170:	0344d863          	bge	s1,s4,1a0 <gets+0x56>
        cc = read(0, &c, 1);
 174:	4605                	li	a2,1
 176:	faf40593          	addi	a1,s0,-81
 17a:	4501                	li	a0,0
 17c:	00000097          	auipc	ra,0x0
 180:	1b0080e7          	jalr	432(ra) # 32c <read>
        if (cc < 1)
 184:	00a05e63          	blez	a0,1a0 <gets+0x56>
        buf[i++] = c;
 188:	faf44783          	lbu	a5,-81(s0)
 18c:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 190:	01578763          	beq	a5,s5,19e <gets+0x54>
 194:	0905                	addi	s2,s2,1
 196:	fd679be3          	bne	a5,s6,16c <gets+0x22>
    for (i = 0; i + 1 < max;) {
 19a:	89a6                	mv	s3,s1
 19c:	a011                	j	1a0 <gets+0x56>
 19e:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 1a0:	99de                	add	s3,s3,s7
 1a2:	00098023          	sb	zero,0(s3)
    return buf;
}
 1a6:	855e                	mv	a0,s7
 1a8:	60e6                	ld	ra,88(sp)
 1aa:	6446                	ld	s0,80(sp)
 1ac:	64a6                	ld	s1,72(sp)
 1ae:	6906                	ld	s2,64(sp)
 1b0:	79e2                	ld	s3,56(sp)
 1b2:	7a42                	ld	s4,48(sp)
 1b4:	7aa2                	ld	s5,40(sp)
 1b6:	7b02                	ld	s6,32(sp)
 1b8:	6be2                	ld	s7,24(sp)
 1ba:	6125                	addi	sp,sp,96
 1bc:	8082                	ret

00000000000001be <stat>:

int stat(const char *n, struct stat *st)
{
 1be:	1101                	addi	sp,sp,-32
 1c0:	ec06                	sd	ra,24(sp)
 1c2:	e822                	sd	s0,16(sp)
 1c4:	e426                	sd	s1,8(sp)
 1c6:	e04a                	sd	s2,0(sp)
 1c8:	1000                	addi	s0,sp,32
 1ca:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 1cc:	4581                	li	a1,0
 1ce:	00000097          	auipc	ra,0x0
 1d2:	186080e7          	jalr	390(ra) # 354 <open>
    if (fd < 0)
 1d6:	02054563          	bltz	a0,200 <stat+0x42>
 1da:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 1dc:	85ca                	mv	a1,s2
 1de:	00000097          	auipc	ra,0x0
 1e2:	18e080e7          	jalr	398(ra) # 36c <fstat>
 1e6:	892a                	mv	s2,a0
    close(fd);
 1e8:	8526                	mv	a0,s1
 1ea:	00000097          	auipc	ra,0x0
 1ee:	152080e7          	jalr	338(ra) # 33c <close>
    return r;
}
 1f2:	854a                	mv	a0,s2
 1f4:	60e2                	ld	ra,24(sp)
 1f6:	6442                	ld	s0,16(sp)
 1f8:	64a2                	ld	s1,8(sp)
 1fa:	6902                	ld	s2,0(sp)
 1fc:	6105                	addi	sp,sp,32
 1fe:	8082                	ret
        return -1;
 200:	597d                	li	s2,-1
 202:	bfc5                	j	1f2 <stat+0x34>

0000000000000204 <atoi>:

int atoi(const char *s)
{
 204:	1141                	addi	sp,sp,-16
 206:	e422                	sd	s0,8(sp)
 208:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 20a:	00054683          	lbu	a3,0(a0)
 20e:	fd06879b          	addiw	a5,a3,-48
 212:	0ff7f793          	zext.b	a5,a5
 216:	4625                	li	a2,9
 218:	02f66863          	bltu	a2,a5,248 <atoi+0x44>
 21c:	872a                	mv	a4,a0
    n = 0;
 21e:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
 220:	0705                	addi	a4,a4,1
 222:	0025179b          	slliw	a5,a0,0x2
 226:	9fa9                	addw	a5,a5,a0
 228:	0017979b          	slliw	a5,a5,0x1
 22c:	9fb5                	addw	a5,a5,a3
 22e:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 232:	00074683          	lbu	a3,0(a4)
 236:	fd06879b          	addiw	a5,a3,-48
 23a:	0ff7f793          	zext.b	a5,a5
 23e:	fef671e3          	bgeu	a2,a5,220 <atoi+0x1c>
    return n;
}
 242:	6422                	ld	s0,8(sp)
 244:	0141                	addi	sp,sp,16
 246:	8082                	ret
    n = 0;
 248:	4501                	li	a0,0
 24a:	bfe5                	j	242 <atoi+0x3e>

000000000000024c <memmove>:

void *memmove(void *vdst, const void *vsrc, int n)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e422                	sd	s0,8(sp)
 250:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst) {
 252:	02b57463          	bgeu	a0,a1,27a <memmove+0x2e>
        while (n-- > 0)
 256:	00c05f63          	blez	a2,274 <memmove+0x28>
 25a:	1602                	slli	a2,a2,0x20
 25c:	9201                	srli	a2,a2,0x20
 25e:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 262:	872a                	mv	a4,a0
            *dst++ = *src++;
 264:	0585                	addi	a1,a1,1
 266:	0705                	addi	a4,a4,1
 268:	fff5c683          	lbu	a3,-1(a1)
 26c:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 270:	fee79ae3          	bne	a5,a4,264 <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 274:	6422                	ld	s0,8(sp)
 276:	0141                	addi	sp,sp,16
 278:	8082                	ret
        dst += n;
 27a:	00c50733          	add	a4,a0,a2
        src += n;
 27e:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 280:	fec05ae3          	blez	a2,274 <memmove+0x28>
 284:	fff6079b          	addiw	a5,a2,-1
 288:	1782                	slli	a5,a5,0x20
 28a:	9381                	srli	a5,a5,0x20
 28c:	fff7c793          	not	a5,a5
 290:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 292:	15fd                	addi	a1,a1,-1
 294:	177d                	addi	a4,a4,-1
 296:	0005c683          	lbu	a3,0(a1)
 29a:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 29e:	fee79ae3          	bne	a5,a4,292 <memmove+0x46>
 2a2:	bfc9                	j	274 <memmove+0x28>

00000000000002a4 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 2a4:	1141                	addi	sp,sp,-16
 2a6:	e422                	sd	s0,8(sp)
 2a8:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0) {
 2aa:	ca05                	beqz	a2,2da <memcmp+0x36>
 2ac:	fff6069b          	addiw	a3,a2,-1
 2b0:	1682                	slli	a3,a3,0x20
 2b2:	9281                	srli	a3,a3,0x20
 2b4:	0685                	addi	a3,a3,1
 2b6:	96aa                	add	a3,a3,a0
        if (*p1 != *p2) {
 2b8:	00054783          	lbu	a5,0(a0)
 2bc:	0005c703          	lbu	a4,0(a1)
 2c0:	00e79863          	bne	a5,a4,2d0 <memcmp+0x2c>
            return *p1 - *p2;
        }
        p1++;
 2c4:	0505                	addi	a0,a0,1
        p2++;
 2c6:	0585                	addi	a1,a1,1
    while (n-- > 0) {
 2c8:	fed518e3          	bne	a0,a3,2b8 <memcmp+0x14>
    }
    return 0;
 2cc:	4501                	li	a0,0
 2ce:	a019                	j	2d4 <memcmp+0x30>
            return *p1 - *p2;
 2d0:	40e7853b          	subw	a0,a5,a4
}
 2d4:	6422                	ld	s0,8(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
    return 0;
 2da:	4501                	li	a0,0
 2dc:	bfe5                	j	2d4 <memcmp+0x30>

00000000000002de <memcpy>:

void *memcpy(void *dst, const void *src, uint n)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e406                	sd	ra,8(sp)
 2e2:	e022                	sd	s0,0(sp)
 2e4:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 2e6:	00000097          	auipc	ra,0x0
 2ea:	f66080e7          	jalr	-154(ra) # 24c <memmove>
}
 2ee:	60a2                	ld	ra,8(sp)
 2f0:	6402                	ld	s0,0(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret

00000000000002f6 <ugetpid>:

#ifdef LAB_PGTBL
int ugetpid(void)
{
 2f6:	1141                	addi	sp,sp,-16
 2f8:	e422                	sd	s0,8(sp)
 2fa:	0800                	addi	s0,sp,16
    struct usyscall *u = (struct usyscall *)USYSCALL;
    return u->pid;
 2fc:	040007b7          	lui	a5,0x4000
}
 300:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ffefed>
 302:	07b2                	slli	a5,a5,0xc
 304:	4388                	lw	a0,0(a5)
 306:	6422                	ld	s0,8(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret

000000000000030c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 30c:	4885                	li	a7,1
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <exit>:
.global exit
exit:
 li a7, SYS_exit
 314:	4889                	li	a7,2
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <wait>:
.global wait
wait:
 li a7, SYS_wait
 31c:	488d                	li	a7,3
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 324:	4891                	li	a7,4
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <read>:
.global read
read:
 li a7, SYS_read
 32c:	4895                	li	a7,5
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <write>:
.global write
write:
 li a7, SYS_write
 334:	48c1                	li	a7,16
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <close>:
.global close
close:
 li a7, SYS_close
 33c:	48d5                	li	a7,21
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <kill>:
.global kill
kill:
 li a7, SYS_kill
 344:	4899                	li	a7,6
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <exec>:
.global exec
exec:
 li a7, SYS_exec
 34c:	489d                	li	a7,7
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <open>:
.global open
open:
 li a7, SYS_open
 354:	48bd                	li	a7,15
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 35c:	48c5                	li	a7,17
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 364:	48c9                	li	a7,18
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 36c:	48a1                	li	a7,8
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <link>:
.global link
link:
 li a7, SYS_link
 374:	48cd                	li	a7,19
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 37c:	48d1                	li	a7,20
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 384:	48a5                	li	a7,9
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <dup>:
.global dup
dup:
 li a7, SYS_dup
 38c:	48a9                	li	a7,10
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 394:	48ad                	li	a7,11
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 39c:	48b1                	li	a7,12
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3a4:	48b5                	li	a7,13
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ac:	48b9                	li	a7,14
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <connect>:
.global connect
connect:
 li a7, SYS_connect
 3b4:	48f5                	li	a7,29
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 3bc:	48f9                	li	a7,30
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3c4:	1101                	addi	sp,sp,-32
 3c6:	ec06                	sd	ra,24(sp)
 3c8:	e822                	sd	s0,16(sp)
 3ca:	1000                	addi	s0,sp,32
 3cc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3d0:	4605                	li	a2,1
 3d2:	fef40593          	addi	a1,s0,-17
 3d6:	00000097          	auipc	ra,0x0
 3da:	f5e080e7          	jalr	-162(ra) # 334 <write>
}
 3de:	60e2                	ld	ra,24(sp)
 3e0:	6442                	ld	s0,16(sp)
 3e2:	6105                	addi	sp,sp,32
 3e4:	8082                	ret

00000000000003e6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e6:	7139                	addi	sp,sp,-64
 3e8:	fc06                	sd	ra,56(sp)
 3ea:	f822                	sd	s0,48(sp)
 3ec:	f426                	sd	s1,40(sp)
 3ee:	f04a                	sd	s2,32(sp)
 3f0:	ec4e                	sd	s3,24(sp)
 3f2:	0080                	addi	s0,sp,64
 3f4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3f6:	c299                	beqz	a3,3fc <printint+0x16>
 3f8:	0805c963          	bltz	a1,48a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3fc:	2581                	sext.w	a1,a1
  neg = 0;
 3fe:	4881                	li	a7,0
 400:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 404:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 406:	2601                	sext.w	a2,a2
 408:	00000517          	auipc	a0,0x0
 40c:	4d050513          	addi	a0,a0,1232 # 8d8 <digits>
 410:	883a                	mv	a6,a4
 412:	2705                	addiw	a4,a4,1
 414:	02c5f7bb          	remuw	a5,a1,a2
 418:	1782                	slli	a5,a5,0x20
 41a:	9381                	srli	a5,a5,0x20
 41c:	97aa                	add	a5,a5,a0
 41e:	0007c783          	lbu	a5,0(a5)
 422:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 426:	0005879b          	sext.w	a5,a1
 42a:	02c5d5bb          	divuw	a1,a1,a2
 42e:	0685                	addi	a3,a3,1
 430:	fec7f0e3          	bgeu	a5,a2,410 <printint+0x2a>
  if(neg)
 434:	00088c63          	beqz	a7,44c <printint+0x66>
    buf[i++] = '-';
 438:	fd070793          	addi	a5,a4,-48
 43c:	00878733          	add	a4,a5,s0
 440:	02d00793          	li	a5,45
 444:	fef70823          	sb	a5,-16(a4)
 448:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 44c:	02e05863          	blez	a4,47c <printint+0x96>
 450:	fc040793          	addi	a5,s0,-64
 454:	00e78933          	add	s2,a5,a4
 458:	fff78993          	addi	s3,a5,-1
 45c:	99ba                	add	s3,s3,a4
 45e:	377d                	addiw	a4,a4,-1
 460:	1702                	slli	a4,a4,0x20
 462:	9301                	srli	a4,a4,0x20
 464:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 468:	fff94583          	lbu	a1,-1(s2)
 46c:	8526                	mv	a0,s1
 46e:	00000097          	auipc	ra,0x0
 472:	f56080e7          	jalr	-170(ra) # 3c4 <putc>
  while(--i >= 0)
 476:	197d                	addi	s2,s2,-1
 478:	ff3918e3          	bne	s2,s3,468 <printint+0x82>
}
 47c:	70e2                	ld	ra,56(sp)
 47e:	7442                	ld	s0,48(sp)
 480:	74a2                	ld	s1,40(sp)
 482:	7902                	ld	s2,32(sp)
 484:	69e2                	ld	s3,24(sp)
 486:	6121                	addi	sp,sp,64
 488:	8082                	ret
    x = -xx;
 48a:	40b005bb          	negw	a1,a1
    neg = 1;
 48e:	4885                	li	a7,1
    x = -xx;
 490:	bf85                	j	400 <printint+0x1a>

0000000000000492 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 492:	7119                	addi	sp,sp,-128
 494:	fc86                	sd	ra,120(sp)
 496:	f8a2                	sd	s0,112(sp)
 498:	f4a6                	sd	s1,104(sp)
 49a:	f0ca                	sd	s2,96(sp)
 49c:	ecce                	sd	s3,88(sp)
 49e:	e8d2                	sd	s4,80(sp)
 4a0:	e4d6                	sd	s5,72(sp)
 4a2:	e0da                	sd	s6,64(sp)
 4a4:	fc5e                	sd	s7,56(sp)
 4a6:	f862                	sd	s8,48(sp)
 4a8:	f466                	sd	s9,40(sp)
 4aa:	f06a                	sd	s10,32(sp)
 4ac:	ec6e                	sd	s11,24(sp)
 4ae:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4b0:	0005c903          	lbu	s2,0(a1)
 4b4:	18090f63          	beqz	s2,652 <vprintf+0x1c0>
 4b8:	8aaa                	mv	s5,a0
 4ba:	8b32                	mv	s6,a2
 4bc:	00158493          	addi	s1,a1,1
  state = 0;
 4c0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4c2:	02500a13          	li	s4,37
 4c6:	4c55                	li	s8,21
 4c8:	00000c97          	auipc	s9,0x0
 4cc:	3b8c8c93          	addi	s9,s9,952 # 880 <malloc+0x12a>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4d0:	02800d93          	li	s11,40
  putc(fd, 'x');
 4d4:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4d6:	00000b97          	auipc	s7,0x0
 4da:	402b8b93          	addi	s7,s7,1026 # 8d8 <digits>
 4de:	a839                	j	4fc <vprintf+0x6a>
        putc(fd, c);
 4e0:	85ca                	mv	a1,s2
 4e2:	8556                	mv	a0,s5
 4e4:	00000097          	auipc	ra,0x0
 4e8:	ee0080e7          	jalr	-288(ra) # 3c4 <putc>
 4ec:	a019                	j	4f2 <vprintf+0x60>
    } else if(state == '%'){
 4ee:	01498d63          	beq	s3,s4,508 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 4f2:	0485                	addi	s1,s1,1
 4f4:	fff4c903          	lbu	s2,-1(s1)
 4f8:	14090d63          	beqz	s2,652 <vprintf+0x1c0>
    if(state == 0){
 4fc:	fe0999e3          	bnez	s3,4ee <vprintf+0x5c>
      if(c == '%'){
 500:	ff4910e3          	bne	s2,s4,4e0 <vprintf+0x4e>
        state = '%';
 504:	89d2                	mv	s3,s4
 506:	b7f5                	j	4f2 <vprintf+0x60>
      if(c == 'd'){
 508:	11490c63          	beq	s2,s4,620 <vprintf+0x18e>
 50c:	f9d9079b          	addiw	a5,s2,-99
 510:	0ff7f793          	zext.b	a5,a5
 514:	10fc6e63          	bltu	s8,a5,630 <vprintf+0x19e>
 518:	f9d9079b          	addiw	a5,s2,-99
 51c:	0ff7f713          	zext.b	a4,a5
 520:	10ec6863          	bltu	s8,a4,630 <vprintf+0x19e>
 524:	00271793          	slli	a5,a4,0x2
 528:	97e6                	add	a5,a5,s9
 52a:	439c                	lw	a5,0(a5)
 52c:	97e6                	add	a5,a5,s9
 52e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 530:	008b0913          	addi	s2,s6,8
 534:	4685                	li	a3,1
 536:	4629                	li	a2,10
 538:	000b2583          	lw	a1,0(s6)
 53c:	8556                	mv	a0,s5
 53e:	00000097          	auipc	ra,0x0
 542:	ea8080e7          	jalr	-344(ra) # 3e6 <printint>
 546:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 548:	4981                	li	s3,0
 54a:	b765                	j	4f2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 54c:	008b0913          	addi	s2,s6,8
 550:	4681                	li	a3,0
 552:	4629                	li	a2,10
 554:	000b2583          	lw	a1,0(s6)
 558:	8556                	mv	a0,s5
 55a:	00000097          	auipc	ra,0x0
 55e:	e8c080e7          	jalr	-372(ra) # 3e6 <printint>
 562:	8b4a                	mv	s6,s2
      state = 0;
 564:	4981                	li	s3,0
 566:	b771                	j	4f2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 568:	008b0913          	addi	s2,s6,8
 56c:	4681                	li	a3,0
 56e:	866a                	mv	a2,s10
 570:	000b2583          	lw	a1,0(s6)
 574:	8556                	mv	a0,s5
 576:	00000097          	auipc	ra,0x0
 57a:	e70080e7          	jalr	-400(ra) # 3e6 <printint>
 57e:	8b4a                	mv	s6,s2
      state = 0;
 580:	4981                	li	s3,0
 582:	bf85                	j	4f2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 584:	008b0793          	addi	a5,s6,8
 588:	f8f43423          	sd	a5,-120(s0)
 58c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 590:	03000593          	li	a1,48
 594:	8556                	mv	a0,s5
 596:	00000097          	auipc	ra,0x0
 59a:	e2e080e7          	jalr	-466(ra) # 3c4 <putc>
  putc(fd, 'x');
 59e:	07800593          	li	a1,120
 5a2:	8556                	mv	a0,s5
 5a4:	00000097          	auipc	ra,0x0
 5a8:	e20080e7          	jalr	-480(ra) # 3c4 <putc>
 5ac:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ae:	03c9d793          	srli	a5,s3,0x3c
 5b2:	97de                	add	a5,a5,s7
 5b4:	0007c583          	lbu	a1,0(a5)
 5b8:	8556                	mv	a0,s5
 5ba:	00000097          	auipc	ra,0x0
 5be:	e0a080e7          	jalr	-502(ra) # 3c4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5c2:	0992                	slli	s3,s3,0x4
 5c4:	397d                	addiw	s2,s2,-1
 5c6:	fe0914e3          	bnez	s2,5ae <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 5ca:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5ce:	4981                	li	s3,0
 5d0:	b70d                	j	4f2 <vprintf+0x60>
        s = va_arg(ap, char*);
 5d2:	008b0913          	addi	s2,s6,8
 5d6:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 5da:	02098163          	beqz	s3,5fc <vprintf+0x16a>
        while(*s != 0){
 5de:	0009c583          	lbu	a1,0(s3)
 5e2:	c5ad                	beqz	a1,64c <vprintf+0x1ba>
          putc(fd, *s);
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	dde080e7          	jalr	-546(ra) # 3c4 <putc>
          s++;
 5ee:	0985                	addi	s3,s3,1
        while(*s != 0){
 5f0:	0009c583          	lbu	a1,0(s3)
 5f4:	f9e5                	bnez	a1,5e4 <vprintf+0x152>
        s = va_arg(ap, char*);
 5f6:	8b4a                	mv	s6,s2
      state = 0;
 5f8:	4981                	li	s3,0
 5fa:	bde5                	j	4f2 <vprintf+0x60>
          s = "(null)";
 5fc:	00000997          	auipc	s3,0x0
 600:	27c98993          	addi	s3,s3,636 # 878 <malloc+0x122>
        while(*s != 0){
 604:	85ee                	mv	a1,s11
 606:	bff9                	j	5e4 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 608:	008b0913          	addi	s2,s6,8
 60c:	000b4583          	lbu	a1,0(s6)
 610:	8556                	mv	a0,s5
 612:	00000097          	auipc	ra,0x0
 616:	db2080e7          	jalr	-590(ra) # 3c4 <putc>
 61a:	8b4a                	mv	s6,s2
      state = 0;
 61c:	4981                	li	s3,0
 61e:	bdd1                	j	4f2 <vprintf+0x60>
        putc(fd, c);
 620:	85d2                	mv	a1,s4
 622:	8556                	mv	a0,s5
 624:	00000097          	auipc	ra,0x0
 628:	da0080e7          	jalr	-608(ra) # 3c4 <putc>
      state = 0;
 62c:	4981                	li	s3,0
 62e:	b5d1                	j	4f2 <vprintf+0x60>
        putc(fd, '%');
 630:	85d2                	mv	a1,s4
 632:	8556                	mv	a0,s5
 634:	00000097          	auipc	ra,0x0
 638:	d90080e7          	jalr	-624(ra) # 3c4 <putc>
        putc(fd, c);
 63c:	85ca                	mv	a1,s2
 63e:	8556                	mv	a0,s5
 640:	00000097          	auipc	ra,0x0
 644:	d84080e7          	jalr	-636(ra) # 3c4 <putc>
      state = 0;
 648:	4981                	li	s3,0
 64a:	b565                	j	4f2 <vprintf+0x60>
        s = va_arg(ap, char*);
 64c:	8b4a                	mv	s6,s2
      state = 0;
 64e:	4981                	li	s3,0
 650:	b54d                	j	4f2 <vprintf+0x60>
    }
  }
}
 652:	70e6                	ld	ra,120(sp)
 654:	7446                	ld	s0,112(sp)
 656:	74a6                	ld	s1,104(sp)
 658:	7906                	ld	s2,96(sp)
 65a:	69e6                	ld	s3,88(sp)
 65c:	6a46                	ld	s4,80(sp)
 65e:	6aa6                	ld	s5,72(sp)
 660:	6b06                	ld	s6,64(sp)
 662:	7be2                	ld	s7,56(sp)
 664:	7c42                	ld	s8,48(sp)
 666:	7ca2                	ld	s9,40(sp)
 668:	7d02                	ld	s10,32(sp)
 66a:	6de2                	ld	s11,24(sp)
 66c:	6109                	addi	sp,sp,128
 66e:	8082                	ret

0000000000000670 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 670:	715d                	addi	sp,sp,-80
 672:	ec06                	sd	ra,24(sp)
 674:	e822                	sd	s0,16(sp)
 676:	1000                	addi	s0,sp,32
 678:	e010                	sd	a2,0(s0)
 67a:	e414                	sd	a3,8(s0)
 67c:	e818                	sd	a4,16(s0)
 67e:	ec1c                	sd	a5,24(s0)
 680:	03043023          	sd	a6,32(s0)
 684:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 688:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 68c:	8622                	mv	a2,s0
 68e:	00000097          	auipc	ra,0x0
 692:	e04080e7          	jalr	-508(ra) # 492 <vprintf>
}
 696:	60e2                	ld	ra,24(sp)
 698:	6442                	ld	s0,16(sp)
 69a:	6161                	addi	sp,sp,80
 69c:	8082                	ret

000000000000069e <printf>:

void
printf(const char *fmt, ...)
{
 69e:	711d                	addi	sp,sp,-96
 6a0:	ec06                	sd	ra,24(sp)
 6a2:	e822                	sd	s0,16(sp)
 6a4:	1000                	addi	s0,sp,32
 6a6:	e40c                	sd	a1,8(s0)
 6a8:	e810                	sd	a2,16(s0)
 6aa:	ec14                	sd	a3,24(s0)
 6ac:	f018                	sd	a4,32(s0)
 6ae:	f41c                	sd	a5,40(s0)
 6b0:	03043823          	sd	a6,48(s0)
 6b4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6b8:	00840613          	addi	a2,s0,8
 6bc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6c0:	85aa                	mv	a1,a0
 6c2:	4505                	li	a0,1
 6c4:	00000097          	auipc	ra,0x0
 6c8:	dce080e7          	jalr	-562(ra) # 492 <vprintf>
}
 6cc:	60e2                	ld	ra,24(sp)
 6ce:	6442                	ld	s0,16(sp)
 6d0:	6125                	addi	sp,sp,96
 6d2:	8082                	ret

00000000000006d4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d4:	1141                	addi	sp,sp,-16
 6d6:	e422                	sd	s0,8(sp)
 6d8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6da:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6de:	00001797          	auipc	a5,0x1
 6e2:	9227b783          	ld	a5,-1758(a5) # 1000 <freep>
 6e6:	a02d                	j	710 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6e8:	4618                	lw	a4,8(a2)
 6ea:	9f2d                	addw	a4,a4,a1
 6ec:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f0:	6398                	ld	a4,0(a5)
 6f2:	6310                	ld	a2,0(a4)
 6f4:	a83d                	j	732 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6f6:	ff852703          	lw	a4,-8(a0)
 6fa:	9f31                	addw	a4,a4,a2
 6fc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6fe:	ff053683          	ld	a3,-16(a0)
 702:	a091                	j	746 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 704:	6398                	ld	a4,0(a5)
 706:	00e7e463          	bltu	a5,a4,70e <free+0x3a>
 70a:	00e6ea63          	bltu	a3,a4,71e <free+0x4a>
{
 70e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 710:	fed7fae3          	bgeu	a5,a3,704 <free+0x30>
 714:	6398                	ld	a4,0(a5)
 716:	00e6e463          	bltu	a3,a4,71e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71a:	fee7eae3          	bltu	a5,a4,70e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 71e:	ff852583          	lw	a1,-8(a0)
 722:	6390                	ld	a2,0(a5)
 724:	02059813          	slli	a6,a1,0x20
 728:	01c85713          	srli	a4,a6,0x1c
 72c:	9736                	add	a4,a4,a3
 72e:	fae60de3          	beq	a2,a4,6e8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 732:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 736:	4790                	lw	a2,8(a5)
 738:	02061593          	slli	a1,a2,0x20
 73c:	01c5d713          	srli	a4,a1,0x1c
 740:	973e                	add	a4,a4,a5
 742:	fae68ae3          	beq	a3,a4,6f6 <free+0x22>
    p->s.ptr = bp->s.ptr;
 746:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 748:	00001717          	auipc	a4,0x1
 74c:	8af73c23          	sd	a5,-1864(a4) # 1000 <freep>
}
 750:	6422                	ld	s0,8(sp)
 752:	0141                	addi	sp,sp,16
 754:	8082                	ret

0000000000000756 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 756:	7139                	addi	sp,sp,-64
 758:	fc06                	sd	ra,56(sp)
 75a:	f822                	sd	s0,48(sp)
 75c:	f426                	sd	s1,40(sp)
 75e:	f04a                	sd	s2,32(sp)
 760:	ec4e                	sd	s3,24(sp)
 762:	e852                	sd	s4,16(sp)
 764:	e456                	sd	s5,8(sp)
 766:	e05a                	sd	s6,0(sp)
 768:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 76a:	02051493          	slli	s1,a0,0x20
 76e:	9081                	srli	s1,s1,0x20
 770:	04bd                	addi	s1,s1,15
 772:	8091                	srli	s1,s1,0x4
 774:	0014899b          	addiw	s3,s1,1
 778:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 77a:	00001517          	auipc	a0,0x1
 77e:	88653503          	ld	a0,-1914(a0) # 1000 <freep>
 782:	c515                	beqz	a0,7ae <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 784:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 786:	4798                	lw	a4,8(a5)
 788:	02977f63          	bgeu	a4,s1,7c6 <malloc+0x70>
 78c:	8a4e                	mv	s4,s3
 78e:	0009871b          	sext.w	a4,s3
 792:	6685                	lui	a3,0x1
 794:	00d77363          	bgeu	a4,a3,79a <malloc+0x44>
 798:	6a05                	lui	s4,0x1
 79a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 79e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7a2:	00001917          	auipc	s2,0x1
 7a6:	85e90913          	addi	s2,s2,-1954 # 1000 <freep>
  if(p == (char*)-1)
 7aa:	5afd                	li	s5,-1
 7ac:	a895                	j	820 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 7ae:	00001797          	auipc	a5,0x1
 7b2:	86278793          	addi	a5,a5,-1950 # 1010 <base>
 7b6:	00001717          	auipc	a4,0x1
 7ba:	84f73523          	sd	a5,-1974(a4) # 1000 <freep>
 7be:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7c0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7c4:	b7e1                	j	78c <malloc+0x36>
      if(p->s.size == nunits)
 7c6:	02e48c63          	beq	s1,a4,7fe <malloc+0xa8>
        p->s.size -= nunits;
 7ca:	4137073b          	subw	a4,a4,s3
 7ce:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7d0:	02071693          	slli	a3,a4,0x20
 7d4:	01c6d713          	srli	a4,a3,0x1c
 7d8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7da:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7de:	00001717          	auipc	a4,0x1
 7e2:	82a73123          	sd	a0,-2014(a4) # 1000 <freep>
      return (void*)(p + 1);
 7e6:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7ea:	70e2                	ld	ra,56(sp)
 7ec:	7442                	ld	s0,48(sp)
 7ee:	74a2                	ld	s1,40(sp)
 7f0:	7902                	ld	s2,32(sp)
 7f2:	69e2                	ld	s3,24(sp)
 7f4:	6a42                	ld	s4,16(sp)
 7f6:	6aa2                	ld	s5,8(sp)
 7f8:	6b02                	ld	s6,0(sp)
 7fa:	6121                	addi	sp,sp,64
 7fc:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7fe:	6398                	ld	a4,0(a5)
 800:	e118                	sd	a4,0(a0)
 802:	bff1                	j	7de <malloc+0x88>
  hp->s.size = nu;
 804:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 808:	0541                	addi	a0,a0,16
 80a:	00000097          	auipc	ra,0x0
 80e:	eca080e7          	jalr	-310(ra) # 6d4 <free>
  return freep;
 812:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 816:	d971                	beqz	a0,7ea <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 818:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 81a:	4798                	lw	a4,8(a5)
 81c:	fa9775e3          	bgeu	a4,s1,7c6 <malloc+0x70>
    if(p == freep)
 820:	00093703          	ld	a4,0(s2)
 824:	853e                	mv	a0,a5
 826:	fef719e3          	bne	a4,a5,818 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 82a:	8552                	mv	a0,s4
 82c:	00000097          	auipc	ra,0x0
 830:	b70080e7          	jalr	-1168(ra) # 39c <sbrk>
  if(p == (char*)-1)
 834:	fd5518e3          	bne	a0,s5,804 <malloc+0xae>
        return 0;
 838:	4501                	li	a0,0
 83a:	bf45                	j	7ea <malloc+0x94>
