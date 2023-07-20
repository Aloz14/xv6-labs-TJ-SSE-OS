
user/_echo：     文件格式 elf64-littleriscv


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
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  int i;

  for(i = 1; i < argc; i++){
  10:	4785                	li	a5,1
  12:	06a7d463          	bge	a5,a0,7a <main+0x7a>
  16:	00858493          	addi	s1,a1,8
  1a:	ffe5099b          	addiw	s3,a0,-2
  1e:	02099793          	slli	a5,s3,0x20
  22:	01d7d993          	srli	s3,a5,0x1d
  26:	05c1                	addi	a1,a1,16
  28:	99ae                	add	s3,s3,a1
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
  2a:	00001a17          	auipc	s4,0x1
  2e:	826a0a13          	addi	s4,s4,-2010 # 850 <malloc+0xee>
    write(1, argv[i], strlen(argv[i]));
  32:	0004b903          	ld	s2,0(s1)
  36:	854a                	mv	a0,s2
  38:	00000097          	auipc	ra,0x0
  3c:	0ae080e7          	jalr	174(ra) # e6 <strlen>
  40:	0005061b          	sext.w	a2,a0
  44:	85ca                	mv	a1,s2
  46:	4505                	li	a0,1
  48:	00000097          	auipc	ra,0x0
  4c:	2f8080e7          	jalr	760(ra) # 340 <write>
    if(i + 1 < argc){
  50:	04a1                	addi	s1,s1,8
  52:	01348a63          	beq	s1,s3,66 <main+0x66>
      write(1, " ", 1);
  56:	4605                	li	a2,1
  58:	85d2                	mv	a1,s4
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	2e4080e7          	jalr	740(ra) # 340 <write>
  for(i = 1; i < argc; i++){
  64:	b7f9                	j	32 <main+0x32>
    } else {
      write(1, "\n", 1);
  66:	4605                	li	a2,1
  68:	00000597          	auipc	a1,0x0
  6c:	7f058593          	addi	a1,a1,2032 # 858 <malloc+0xf6>
  70:	4505                	li	a0,1
  72:	00000097          	auipc	ra,0x0
  76:	2ce080e7          	jalr	718(ra) # 340 <write>
    }
  }
  exit(0);
  7a:	4501                	li	a0,0
  7c:	00000097          	auipc	ra,0x0
  80:	2a4080e7          	jalr	676(ra) # 320 <exit>

0000000000000084 <_main>:

//
// wrapper so that it's OK if main() does not call exit().
//
void _main()
{
  84:	1141                	addi	sp,sp,-16
  86:	e406                	sd	ra,8(sp)
  88:	e022                	sd	s0,0(sp)
  8a:	0800                	addi	s0,sp,16
    extern int main();
    main();
  8c:	00000097          	auipc	ra,0x0
  90:	f74080e7          	jalr	-140(ra) # 0 <main>
    exit(0);
  94:	4501                	li	a0,0
  96:	00000097          	auipc	ra,0x0
  9a:	28a080e7          	jalr	650(ra) # 320 <exit>

000000000000009e <strcpy>:
}

char *strcpy(char *s, const char *t)
{
  9e:	1141                	addi	sp,sp,-16
  a0:	e422                	sd	s0,8(sp)
  a2:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
  a4:	87aa                	mv	a5,a0
  a6:	0585                	addi	a1,a1,1
  a8:	0785                	addi	a5,a5,1
  aa:	fff5c703          	lbu	a4,-1(a1)
  ae:	fee78fa3          	sb	a4,-1(a5)
  b2:	fb75                	bnez	a4,a6 <strcpy+0x8>
        ;
    return os;
}
  b4:	6422                	ld	s0,8(sp)
  b6:	0141                	addi	sp,sp,16
  b8:	8082                	ret

00000000000000ba <strcmp>:

int strcmp(const char *p, const char *q)
{
  ba:	1141                	addi	sp,sp,-16
  bc:	e422                	sd	s0,8(sp)
  be:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
  c0:	00054783          	lbu	a5,0(a0)
  c4:	cb91                	beqz	a5,d8 <strcmp+0x1e>
  c6:	0005c703          	lbu	a4,0(a1)
  ca:	00f71763          	bne	a4,a5,d8 <strcmp+0x1e>
        p++, q++;
  ce:	0505                	addi	a0,a0,1
  d0:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
  d2:	00054783          	lbu	a5,0(a0)
  d6:	fbe5                	bnez	a5,c6 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
  d8:	0005c503          	lbu	a0,0(a1)
}
  dc:	40a7853b          	subw	a0,a5,a0
  e0:	6422                	ld	s0,8(sp)
  e2:	0141                	addi	sp,sp,16
  e4:	8082                	ret

00000000000000e6 <strlen>:

uint strlen(const char *s)
{
  e6:	1141                	addi	sp,sp,-16
  e8:	e422                	sd	s0,8(sp)
  ea:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
  ec:	00054783          	lbu	a5,0(a0)
  f0:	cf91                	beqz	a5,10c <strlen+0x26>
  f2:	0505                	addi	a0,a0,1
  f4:	87aa                	mv	a5,a0
  f6:	4685                	li	a3,1
  f8:	9e89                	subw	a3,a3,a0
  fa:	00f6853b          	addw	a0,a3,a5
  fe:	0785                	addi	a5,a5,1
 100:	fff7c703          	lbu	a4,-1(a5)
 104:	fb7d                	bnez	a4,fa <strlen+0x14>
        ;
    return n;
}
 106:	6422                	ld	s0,8(sp)
 108:	0141                	addi	sp,sp,16
 10a:	8082                	ret
    for (n = 0; s[n]; n++)
 10c:	4501                	li	a0,0
 10e:	bfe5                	j	106 <strlen+0x20>

0000000000000110 <memset>:

void *memset(void *dst, int c, uint n)
{
 110:	1141                	addi	sp,sp,-16
 112:	e422                	sd	s0,8(sp)
 114:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++) {
 116:	ca19                	beqz	a2,12c <memset+0x1c>
 118:	87aa                	mv	a5,a0
 11a:	1602                	slli	a2,a2,0x20
 11c:	9201                	srli	a2,a2,0x20
 11e:	00a60733          	add	a4,a2,a0
        cdst[i] = c;
 122:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++) {
 126:	0785                	addi	a5,a5,1
 128:	fee79de3          	bne	a5,a4,122 <memset+0x12>
    }
    return dst;
}
 12c:	6422                	ld	s0,8(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret

0000000000000132 <strchr>:

char *strchr(const char *s, char c)
{
 132:	1141                	addi	sp,sp,-16
 134:	e422                	sd	s0,8(sp)
 136:	0800                	addi	s0,sp,16
    for (; *s; s++)
 138:	00054783          	lbu	a5,0(a0)
 13c:	cb99                	beqz	a5,152 <strchr+0x20>
        if (*s == c)
 13e:	00f58763          	beq	a1,a5,14c <strchr+0x1a>
    for (; *s; s++)
 142:	0505                	addi	a0,a0,1
 144:	00054783          	lbu	a5,0(a0)
 148:	fbfd                	bnez	a5,13e <strchr+0xc>
            return (char *)s;
    return 0;
 14a:	4501                	li	a0,0
}
 14c:	6422                	ld	s0,8(sp)
 14e:	0141                	addi	sp,sp,16
 150:	8082                	ret
    return 0;
 152:	4501                	li	a0,0
 154:	bfe5                	j	14c <strchr+0x1a>

0000000000000156 <gets>:

char *gets(char *buf, int max)
{
 156:	711d                	addi	sp,sp,-96
 158:	ec86                	sd	ra,88(sp)
 15a:	e8a2                	sd	s0,80(sp)
 15c:	e4a6                	sd	s1,72(sp)
 15e:	e0ca                	sd	s2,64(sp)
 160:	fc4e                	sd	s3,56(sp)
 162:	f852                	sd	s4,48(sp)
 164:	f456                	sd	s5,40(sp)
 166:	f05a                	sd	s6,32(sp)
 168:	ec5e                	sd	s7,24(sp)
 16a:	1080                	addi	s0,sp,96
 16c:	8baa                	mv	s7,a0
 16e:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;) {
 170:	892a                	mv	s2,a0
 172:	4481                	li	s1,0
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 174:	4aa9                	li	s5,10
 176:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;) {
 178:	89a6                	mv	s3,s1
 17a:	2485                	addiw	s1,s1,1
 17c:	0344d863          	bge	s1,s4,1ac <gets+0x56>
        cc = read(0, &c, 1);
 180:	4605                	li	a2,1
 182:	faf40593          	addi	a1,s0,-81
 186:	4501                	li	a0,0
 188:	00000097          	auipc	ra,0x0
 18c:	1b0080e7          	jalr	432(ra) # 338 <read>
        if (cc < 1)
 190:	00a05e63          	blez	a0,1ac <gets+0x56>
        buf[i++] = c;
 194:	faf44783          	lbu	a5,-81(s0)
 198:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 19c:	01578763          	beq	a5,s5,1aa <gets+0x54>
 1a0:	0905                	addi	s2,s2,1
 1a2:	fd679be3          	bne	a5,s6,178 <gets+0x22>
    for (i = 0; i + 1 < max;) {
 1a6:	89a6                	mv	s3,s1
 1a8:	a011                	j	1ac <gets+0x56>
 1aa:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 1ac:	99de                	add	s3,s3,s7
 1ae:	00098023          	sb	zero,0(s3)
    return buf;
}
 1b2:	855e                	mv	a0,s7
 1b4:	60e6                	ld	ra,88(sp)
 1b6:	6446                	ld	s0,80(sp)
 1b8:	64a6                	ld	s1,72(sp)
 1ba:	6906                	ld	s2,64(sp)
 1bc:	79e2                	ld	s3,56(sp)
 1be:	7a42                	ld	s4,48(sp)
 1c0:	7aa2                	ld	s5,40(sp)
 1c2:	7b02                	ld	s6,32(sp)
 1c4:	6be2                	ld	s7,24(sp)
 1c6:	6125                	addi	sp,sp,96
 1c8:	8082                	ret

00000000000001ca <stat>:

int stat(const char *n, struct stat *st)
{
 1ca:	1101                	addi	sp,sp,-32
 1cc:	ec06                	sd	ra,24(sp)
 1ce:	e822                	sd	s0,16(sp)
 1d0:	e426                	sd	s1,8(sp)
 1d2:	e04a                	sd	s2,0(sp)
 1d4:	1000                	addi	s0,sp,32
 1d6:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 1d8:	4581                	li	a1,0
 1da:	00000097          	auipc	ra,0x0
 1de:	186080e7          	jalr	390(ra) # 360 <open>
    if (fd < 0)
 1e2:	02054563          	bltz	a0,20c <stat+0x42>
 1e6:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 1e8:	85ca                	mv	a1,s2
 1ea:	00000097          	auipc	ra,0x0
 1ee:	18e080e7          	jalr	398(ra) # 378 <fstat>
 1f2:	892a                	mv	s2,a0
    close(fd);
 1f4:	8526                	mv	a0,s1
 1f6:	00000097          	auipc	ra,0x0
 1fa:	152080e7          	jalr	338(ra) # 348 <close>
    return r;
}
 1fe:	854a                	mv	a0,s2
 200:	60e2                	ld	ra,24(sp)
 202:	6442                	ld	s0,16(sp)
 204:	64a2                	ld	s1,8(sp)
 206:	6902                	ld	s2,0(sp)
 208:	6105                	addi	sp,sp,32
 20a:	8082                	ret
        return -1;
 20c:	597d                	li	s2,-1
 20e:	bfc5                	j	1fe <stat+0x34>

0000000000000210 <atoi>:

int atoi(const char *s)
{
 210:	1141                	addi	sp,sp,-16
 212:	e422                	sd	s0,8(sp)
 214:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 216:	00054683          	lbu	a3,0(a0)
 21a:	fd06879b          	addiw	a5,a3,-48
 21e:	0ff7f793          	zext.b	a5,a5
 222:	4625                	li	a2,9
 224:	02f66863          	bltu	a2,a5,254 <atoi+0x44>
 228:	872a                	mv	a4,a0
    n = 0;
 22a:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
 22c:	0705                	addi	a4,a4,1
 22e:	0025179b          	slliw	a5,a0,0x2
 232:	9fa9                	addw	a5,a5,a0
 234:	0017979b          	slliw	a5,a5,0x1
 238:	9fb5                	addw	a5,a5,a3
 23a:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 23e:	00074683          	lbu	a3,0(a4)
 242:	fd06879b          	addiw	a5,a3,-48
 246:	0ff7f793          	zext.b	a5,a5
 24a:	fef671e3          	bgeu	a2,a5,22c <atoi+0x1c>
    return n;
}
 24e:	6422                	ld	s0,8(sp)
 250:	0141                	addi	sp,sp,16
 252:	8082                	ret
    n = 0;
 254:	4501                	li	a0,0
 256:	bfe5                	j	24e <atoi+0x3e>

0000000000000258 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n)
{
 258:	1141                	addi	sp,sp,-16
 25a:	e422                	sd	s0,8(sp)
 25c:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst) {
 25e:	02b57463          	bgeu	a0,a1,286 <memmove+0x2e>
        while (n-- > 0)
 262:	00c05f63          	blez	a2,280 <memmove+0x28>
 266:	1602                	slli	a2,a2,0x20
 268:	9201                	srli	a2,a2,0x20
 26a:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 26e:	872a                	mv	a4,a0
            *dst++ = *src++;
 270:	0585                	addi	a1,a1,1
 272:	0705                	addi	a4,a4,1
 274:	fff5c683          	lbu	a3,-1(a1)
 278:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 27c:	fee79ae3          	bne	a5,a4,270 <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 280:	6422                	ld	s0,8(sp)
 282:	0141                	addi	sp,sp,16
 284:	8082                	ret
        dst += n;
 286:	00c50733          	add	a4,a0,a2
        src += n;
 28a:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 28c:	fec05ae3          	blez	a2,280 <memmove+0x28>
 290:	fff6079b          	addiw	a5,a2,-1
 294:	1782                	slli	a5,a5,0x20
 296:	9381                	srli	a5,a5,0x20
 298:	fff7c793          	not	a5,a5
 29c:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 29e:	15fd                	addi	a1,a1,-1
 2a0:	177d                	addi	a4,a4,-1
 2a2:	0005c683          	lbu	a3,0(a1)
 2a6:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 2aa:	fee79ae3          	bne	a5,a4,29e <memmove+0x46>
 2ae:	bfc9                	j	280 <memmove+0x28>

00000000000002b0 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 2b0:	1141                	addi	sp,sp,-16
 2b2:	e422                	sd	s0,8(sp)
 2b4:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0) {
 2b6:	ca05                	beqz	a2,2e6 <memcmp+0x36>
 2b8:	fff6069b          	addiw	a3,a2,-1
 2bc:	1682                	slli	a3,a3,0x20
 2be:	9281                	srli	a3,a3,0x20
 2c0:	0685                	addi	a3,a3,1
 2c2:	96aa                	add	a3,a3,a0
        if (*p1 != *p2) {
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	0005c703          	lbu	a4,0(a1)
 2cc:	00e79863          	bne	a5,a4,2dc <memcmp+0x2c>
            return *p1 - *p2;
        }
        p1++;
 2d0:	0505                	addi	a0,a0,1
        p2++;
 2d2:	0585                	addi	a1,a1,1
    while (n-- > 0) {
 2d4:	fed518e3          	bne	a0,a3,2c4 <memcmp+0x14>
    }
    return 0;
 2d8:	4501                	li	a0,0
 2da:	a019                	j	2e0 <memcmp+0x30>
            return *p1 - *p2;
 2dc:	40e7853b          	subw	a0,a5,a4
}
 2e0:	6422                	ld	s0,8(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret
    return 0;
 2e6:	4501                	li	a0,0
 2e8:	bfe5                	j	2e0 <memcmp+0x30>

00000000000002ea <memcpy>:

void *memcpy(void *dst, const void *src, uint n)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e406                	sd	ra,8(sp)
 2ee:	e022                	sd	s0,0(sp)
 2f0:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 2f2:	00000097          	auipc	ra,0x0
 2f6:	f66080e7          	jalr	-154(ra) # 258 <memmove>
}
 2fa:	60a2                	ld	ra,8(sp)
 2fc:	6402                	ld	s0,0(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret

0000000000000302 <ugetpid>:

#ifdef LAB_PGTBL
int ugetpid(void)
{
 302:	1141                	addi	sp,sp,-16
 304:	e422                	sd	s0,8(sp)
 306:	0800                	addi	s0,sp,16
    struct usyscall *u = (struct usyscall *)USYSCALL;
    return u->pid;
 308:	040007b7          	lui	a5,0x4000
}
 30c:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ffefed>
 30e:	07b2                	slli	a5,a5,0xc
 310:	4388                	lw	a0,0(a5)
 312:	6422                	ld	s0,8(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret

0000000000000318 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 318:	4885                	li	a7,1
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <exit>:
.global exit
exit:
 li a7, SYS_exit
 320:	4889                	li	a7,2
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <wait>:
.global wait
wait:
 li a7, SYS_wait
 328:	488d                	li	a7,3
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 330:	4891                	li	a7,4
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <read>:
.global read
read:
 li a7, SYS_read
 338:	4895                	li	a7,5
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <write>:
.global write
write:
 li a7, SYS_write
 340:	48c1                	li	a7,16
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <close>:
.global close
close:
 li a7, SYS_close
 348:	48d5                	li	a7,21
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <kill>:
.global kill
kill:
 li a7, SYS_kill
 350:	4899                	li	a7,6
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <exec>:
.global exec
exec:
 li a7, SYS_exec
 358:	489d                	li	a7,7
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <open>:
.global open
open:
 li a7, SYS_open
 360:	48bd                	li	a7,15
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 368:	48c5                	li	a7,17
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 370:	48c9                	li	a7,18
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 378:	48a1                	li	a7,8
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <link>:
.global link
link:
 li a7, SYS_link
 380:	48cd                	li	a7,19
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 388:	48d1                	li	a7,20
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 390:	48a5                	li	a7,9
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <dup>:
.global dup
dup:
 li a7, SYS_dup
 398:	48a9                	li	a7,10
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3a0:	48ad                	li	a7,11
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3a8:	48b1                	li	a7,12
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3b0:	48b5                	li	a7,13
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3b8:	48b9                	li	a7,14
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <connect>:
.global connect
connect:
 li a7, SYS_connect
 3c0:	48f5                	li	a7,29
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 3c8:	48f9                	li	a7,30
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3d0:	1101                	addi	sp,sp,-32
 3d2:	ec06                	sd	ra,24(sp)
 3d4:	e822                	sd	s0,16(sp)
 3d6:	1000                	addi	s0,sp,32
 3d8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3dc:	4605                	li	a2,1
 3de:	fef40593          	addi	a1,s0,-17
 3e2:	00000097          	auipc	ra,0x0
 3e6:	f5e080e7          	jalr	-162(ra) # 340 <write>
}
 3ea:	60e2                	ld	ra,24(sp)
 3ec:	6442                	ld	s0,16(sp)
 3ee:	6105                	addi	sp,sp,32
 3f0:	8082                	ret

00000000000003f2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f2:	7139                	addi	sp,sp,-64
 3f4:	fc06                	sd	ra,56(sp)
 3f6:	f822                	sd	s0,48(sp)
 3f8:	f426                	sd	s1,40(sp)
 3fa:	f04a                	sd	s2,32(sp)
 3fc:	ec4e                	sd	s3,24(sp)
 3fe:	0080                	addi	s0,sp,64
 400:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 402:	c299                	beqz	a3,408 <printint+0x16>
 404:	0805c963          	bltz	a1,496 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 408:	2581                	sext.w	a1,a1
  neg = 0;
 40a:	4881                	li	a7,0
 40c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 410:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 412:	2601                	sext.w	a2,a2
 414:	00000517          	auipc	a0,0x0
 418:	4ac50513          	addi	a0,a0,1196 # 8c0 <digits>
 41c:	883a                	mv	a6,a4
 41e:	2705                	addiw	a4,a4,1
 420:	02c5f7bb          	remuw	a5,a1,a2
 424:	1782                	slli	a5,a5,0x20
 426:	9381                	srli	a5,a5,0x20
 428:	97aa                	add	a5,a5,a0
 42a:	0007c783          	lbu	a5,0(a5)
 42e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 432:	0005879b          	sext.w	a5,a1
 436:	02c5d5bb          	divuw	a1,a1,a2
 43a:	0685                	addi	a3,a3,1
 43c:	fec7f0e3          	bgeu	a5,a2,41c <printint+0x2a>
  if(neg)
 440:	00088c63          	beqz	a7,458 <printint+0x66>
    buf[i++] = '-';
 444:	fd070793          	addi	a5,a4,-48
 448:	00878733          	add	a4,a5,s0
 44c:	02d00793          	li	a5,45
 450:	fef70823          	sb	a5,-16(a4)
 454:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 458:	02e05863          	blez	a4,488 <printint+0x96>
 45c:	fc040793          	addi	a5,s0,-64
 460:	00e78933          	add	s2,a5,a4
 464:	fff78993          	addi	s3,a5,-1
 468:	99ba                	add	s3,s3,a4
 46a:	377d                	addiw	a4,a4,-1
 46c:	1702                	slli	a4,a4,0x20
 46e:	9301                	srli	a4,a4,0x20
 470:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 474:	fff94583          	lbu	a1,-1(s2)
 478:	8526                	mv	a0,s1
 47a:	00000097          	auipc	ra,0x0
 47e:	f56080e7          	jalr	-170(ra) # 3d0 <putc>
  while(--i >= 0)
 482:	197d                	addi	s2,s2,-1
 484:	ff3918e3          	bne	s2,s3,474 <printint+0x82>
}
 488:	70e2                	ld	ra,56(sp)
 48a:	7442                	ld	s0,48(sp)
 48c:	74a2                	ld	s1,40(sp)
 48e:	7902                	ld	s2,32(sp)
 490:	69e2                	ld	s3,24(sp)
 492:	6121                	addi	sp,sp,64
 494:	8082                	ret
    x = -xx;
 496:	40b005bb          	negw	a1,a1
    neg = 1;
 49a:	4885                	li	a7,1
    x = -xx;
 49c:	bf85                	j	40c <printint+0x1a>

000000000000049e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 49e:	7119                	addi	sp,sp,-128
 4a0:	fc86                	sd	ra,120(sp)
 4a2:	f8a2                	sd	s0,112(sp)
 4a4:	f4a6                	sd	s1,104(sp)
 4a6:	f0ca                	sd	s2,96(sp)
 4a8:	ecce                	sd	s3,88(sp)
 4aa:	e8d2                	sd	s4,80(sp)
 4ac:	e4d6                	sd	s5,72(sp)
 4ae:	e0da                	sd	s6,64(sp)
 4b0:	fc5e                	sd	s7,56(sp)
 4b2:	f862                	sd	s8,48(sp)
 4b4:	f466                	sd	s9,40(sp)
 4b6:	f06a                	sd	s10,32(sp)
 4b8:	ec6e                	sd	s11,24(sp)
 4ba:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4bc:	0005c903          	lbu	s2,0(a1)
 4c0:	18090f63          	beqz	s2,65e <vprintf+0x1c0>
 4c4:	8aaa                	mv	s5,a0
 4c6:	8b32                	mv	s6,a2
 4c8:	00158493          	addi	s1,a1,1
  state = 0;
 4cc:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4ce:	02500a13          	li	s4,37
 4d2:	4c55                	li	s8,21
 4d4:	00000c97          	auipc	s9,0x0
 4d8:	394c8c93          	addi	s9,s9,916 # 868 <malloc+0x106>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4dc:	02800d93          	li	s11,40
  putc(fd, 'x');
 4e0:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4e2:	00000b97          	auipc	s7,0x0
 4e6:	3deb8b93          	addi	s7,s7,990 # 8c0 <digits>
 4ea:	a839                	j	508 <vprintf+0x6a>
        putc(fd, c);
 4ec:	85ca                	mv	a1,s2
 4ee:	8556                	mv	a0,s5
 4f0:	00000097          	auipc	ra,0x0
 4f4:	ee0080e7          	jalr	-288(ra) # 3d0 <putc>
 4f8:	a019                	j	4fe <vprintf+0x60>
    } else if(state == '%'){
 4fa:	01498d63          	beq	s3,s4,514 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 4fe:	0485                	addi	s1,s1,1
 500:	fff4c903          	lbu	s2,-1(s1)
 504:	14090d63          	beqz	s2,65e <vprintf+0x1c0>
    if(state == 0){
 508:	fe0999e3          	bnez	s3,4fa <vprintf+0x5c>
      if(c == '%'){
 50c:	ff4910e3          	bne	s2,s4,4ec <vprintf+0x4e>
        state = '%';
 510:	89d2                	mv	s3,s4
 512:	b7f5                	j	4fe <vprintf+0x60>
      if(c == 'd'){
 514:	11490c63          	beq	s2,s4,62c <vprintf+0x18e>
 518:	f9d9079b          	addiw	a5,s2,-99
 51c:	0ff7f793          	zext.b	a5,a5
 520:	10fc6e63          	bltu	s8,a5,63c <vprintf+0x19e>
 524:	f9d9079b          	addiw	a5,s2,-99
 528:	0ff7f713          	zext.b	a4,a5
 52c:	10ec6863          	bltu	s8,a4,63c <vprintf+0x19e>
 530:	00271793          	slli	a5,a4,0x2
 534:	97e6                	add	a5,a5,s9
 536:	439c                	lw	a5,0(a5)
 538:	97e6                	add	a5,a5,s9
 53a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 53c:	008b0913          	addi	s2,s6,8
 540:	4685                	li	a3,1
 542:	4629                	li	a2,10
 544:	000b2583          	lw	a1,0(s6)
 548:	8556                	mv	a0,s5
 54a:	00000097          	auipc	ra,0x0
 54e:	ea8080e7          	jalr	-344(ra) # 3f2 <printint>
 552:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 554:	4981                	li	s3,0
 556:	b765                	j	4fe <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 558:	008b0913          	addi	s2,s6,8
 55c:	4681                	li	a3,0
 55e:	4629                	li	a2,10
 560:	000b2583          	lw	a1,0(s6)
 564:	8556                	mv	a0,s5
 566:	00000097          	auipc	ra,0x0
 56a:	e8c080e7          	jalr	-372(ra) # 3f2 <printint>
 56e:	8b4a                	mv	s6,s2
      state = 0;
 570:	4981                	li	s3,0
 572:	b771                	j	4fe <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 574:	008b0913          	addi	s2,s6,8
 578:	4681                	li	a3,0
 57a:	866a                	mv	a2,s10
 57c:	000b2583          	lw	a1,0(s6)
 580:	8556                	mv	a0,s5
 582:	00000097          	auipc	ra,0x0
 586:	e70080e7          	jalr	-400(ra) # 3f2 <printint>
 58a:	8b4a                	mv	s6,s2
      state = 0;
 58c:	4981                	li	s3,0
 58e:	bf85                	j	4fe <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 590:	008b0793          	addi	a5,s6,8
 594:	f8f43423          	sd	a5,-120(s0)
 598:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 59c:	03000593          	li	a1,48
 5a0:	8556                	mv	a0,s5
 5a2:	00000097          	auipc	ra,0x0
 5a6:	e2e080e7          	jalr	-466(ra) # 3d0 <putc>
  putc(fd, 'x');
 5aa:	07800593          	li	a1,120
 5ae:	8556                	mv	a0,s5
 5b0:	00000097          	auipc	ra,0x0
 5b4:	e20080e7          	jalr	-480(ra) # 3d0 <putc>
 5b8:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ba:	03c9d793          	srli	a5,s3,0x3c
 5be:	97de                	add	a5,a5,s7
 5c0:	0007c583          	lbu	a1,0(a5)
 5c4:	8556                	mv	a0,s5
 5c6:	00000097          	auipc	ra,0x0
 5ca:	e0a080e7          	jalr	-502(ra) # 3d0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5ce:	0992                	slli	s3,s3,0x4
 5d0:	397d                	addiw	s2,s2,-1
 5d2:	fe0914e3          	bnez	s2,5ba <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 5d6:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	b70d                	j	4fe <vprintf+0x60>
        s = va_arg(ap, char*);
 5de:	008b0913          	addi	s2,s6,8
 5e2:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 5e6:	02098163          	beqz	s3,608 <vprintf+0x16a>
        while(*s != 0){
 5ea:	0009c583          	lbu	a1,0(s3)
 5ee:	c5ad                	beqz	a1,658 <vprintf+0x1ba>
          putc(fd, *s);
 5f0:	8556                	mv	a0,s5
 5f2:	00000097          	auipc	ra,0x0
 5f6:	dde080e7          	jalr	-546(ra) # 3d0 <putc>
          s++;
 5fa:	0985                	addi	s3,s3,1
        while(*s != 0){
 5fc:	0009c583          	lbu	a1,0(s3)
 600:	f9e5                	bnez	a1,5f0 <vprintf+0x152>
        s = va_arg(ap, char*);
 602:	8b4a                	mv	s6,s2
      state = 0;
 604:	4981                	li	s3,0
 606:	bde5                	j	4fe <vprintf+0x60>
          s = "(null)";
 608:	00000997          	auipc	s3,0x0
 60c:	25898993          	addi	s3,s3,600 # 860 <malloc+0xfe>
        while(*s != 0){
 610:	85ee                	mv	a1,s11
 612:	bff9                	j	5f0 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 614:	008b0913          	addi	s2,s6,8
 618:	000b4583          	lbu	a1,0(s6)
 61c:	8556                	mv	a0,s5
 61e:	00000097          	auipc	ra,0x0
 622:	db2080e7          	jalr	-590(ra) # 3d0 <putc>
 626:	8b4a                	mv	s6,s2
      state = 0;
 628:	4981                	li	s3,0
 62a:	bdd1                	j	4fe <vprintf+0x60>
        putc(fd, c);
 62c:	85d2                	mv	a1,s4
 62e:	8556                	mv	a0,s5
 630:	00000097          	auipc	ra,0x0
 634:	da0080e7          	jalr	-608(ra) # 3d0 <putc>
      state = 0;
 638:	4981                	li	s3,0
 63a:	b5d1                	j	4fe <vprintf+0x60>
        putc(fd, '%');
 63c:	85d2                	mv	a1,s4
 63e:	8556                	mv	a0,s5
 640:	00000097          	auipc	ra,0x0
 644:	d90080e7          	jalr	-624(ra) # 3d0 <putc>
        putc(fd, c);
 648:	85ca                	mv	a1,s2
 64a:	8556                	mv	a0,s5
 64c:	00000097          	auipc	ra,0x0
 650:	d84080e7          	jalr	-636(ra) # 3d0 <putc>
      state = 0;
 654:	4981                	li	s3,0
 656:	b565                	j	4fe <vprintf+0x60>
        s = va_arg(ap, char*);
 658:	8b4a                	mv	s6,s2
      state = 0;
 65a:	4981                	li	s3,0
 65c:	b54d                	j	4fe <vprintf+0x60>
    }
  }
}
 65e:	70e6                	ld	ra,120(sp)
 660:	7446                	ld	s0,112(sp)
 662:	74a6                	ld	s1,104(sp)
 664:	7906                	ld	s2,96(sp)
 666:	69e6                	ld	s3,88(sp)
 668:	6a46                	ld	s4,80(sp)
 66a:	6aa6                	ld	s5,72(sp)
 66c:	6b06                	ld	s6,64(sp)
 66e:	7be2                	ld	s7,56(sp)
 670:	7c42                	ld	s8,48(sp)
 672:	7ca2                	ld	s9,40(sp)
 674:	7d02                	ld	s10,32(sp)
 676:	6de2                	ld	s11,24(sp)
 678:	6109                	addi	sp,sp,128
 67a:	8082                	ret

000000000000067c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 67c:	715d                	addi	sp,sp,-80
 67e:	ec06                	sd	ra,24(sp)
 680:	e822                	sd	s0,16(sp)
 682:	1000                	addi	s0,sp,32
 684:	e010                	sd	a2,0(s0)
 686:	e414                	sd	a3,8(s0)
 688:	e818                	sd	a4,16(s0)
 68a:	ec1c                	sd	a5,24(s0)
 68c:	03043023          	sd	a6,32(s0)
 690:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 694:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 698:	8622                	mv	a2,s0
 69a:	00000097          	auipc	ra,0x0
 69e:	e04080e7          	jalr	-508(ra) # 49e <vprintf>
}
 6a2:	60e2                	ld	ra,24(sp)
 6a4:	6442                	ld	s0,16(sp)
 6a6:	6161                	addi	sp,sp,80
 6a8:	8082                	ret

00000000000006aa <printf>:

void
printf(const char *fmt, ...)
{
 6aa:	711d                	addi	sp,sp,-96
 6ac:	ec06                	sd	ra,24(sp)
 6ae:	e822                	sd	s0,16(sp)
 6b0:	1000                	addi	s0,sp,32
 6b2:	e40c                	sd	a1,8(s0)
 6b4:	e810                	sd	a2,16(s0)
 6b6:	ec14                	sd	a3,24(s0)
 6b8:	f018                	sd	a4,32(s0)
 6ba:	f41c                	sd	a5,40(s0)
 6bc:	03043823          	sd	a6,48(s0)
 6c0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6c4:	00840613          	addi	a2,s0,8
 6c8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6cc:	85aa                	mv	a1,a0
 6ce:	4505                	li	a0,1
 6d0:	00000097          	auipc	ra,0x0
 6d4:	dce080e7          	jalr	-562(ra) # 49e <vprintf>
}
 6d8:	60e2                	ld	ra,24(sp)
 6da:	6442                	ld	s0,16(sp)
 6dc:	6125                	addi	sp,sp,96
 6de:	8082                	ret

00000000000006e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e0:	1141                	addi	sp,sp,-16
 6e2:	e422                	sd	s0,8(sp)
 6e4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ea:	00001797          	auipc	a5,0x1
 6ee:	9167b783          	ld	a5,-1770(a5) # 1000 <freep>
 6f2:	a02d                	j	71c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6f4:	4618                	lw	a4,8(a2)
 6f6:	9f2d                	addw	a4,a4,a1
 6f8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6fc:	6398                	ld	a4,0(a5)
 6fe:	6310                	ld	a2,0(a4)
 700:	a83d                	j	73e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 702:	ff852703          	lw	a4,-8(a0)
 706:	9f31                	addw	a4,a4,a2
 708:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 70a:	ff053683          	ld	a3,-16(a0)
 70e:	a091                	j	752 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 710:	6398                	ld	a4,0(a5)
 712:	00e7e463          	bltu	a5,a4,71a <free+0x3a>
 716:	00e6ea63          	bltu	a3,a4,72a <free+0x4a>
{
 71a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71c:	fed7fae3          	bgeu	a5,a3,710 <free+0x30>
 720:	6398                	ld	a4,0(a5)
 722:	00e6e463          	bltu	a3,a4,72a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 726:	fee7eae3          	bltu	a5,a4,71a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 72a:	ff852583          	lw	a1,-8(a0)
 72e:	6390                	ld	a2,0(a5)
 730:	02059813          	slli	a6,a1,0x20
 734:	01c85713          	srli	a4,a6,0x1c
 738:	9736                	add	a4,a4,a3
 73a:	fae60de3          	beq	a2,a4,6f4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 73e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 742:	4790                	lw	a2,8(a5)
 744:	02061593          	slli	a1,a2,0x20
 748:	01c5d713          	srli	a4,a1,0x1c
 74c:	973e                	add	a4,a4,a5
 74e:	fae68ae3          	beq	a3,a4,702 <free+0x22>
    p->s.ptr = bp->s.ptr;
 752:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 754:	00001717          	auipc	a4,0x1
 758:	8af73623          	sd	a5,-1876(a4) # 1000 <freep>
}
 75c:	6422                	ld	s0,8(sp)
 75e:	0141                	addi	sp,sp,16
 760:	8082                	ret

0000000000000762 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 762:	7139                	addi	sp,sp,-64
 764:	fc06                	sd	ra,56(sp)
 766:	f822                	sd	s0,48(sp)
 768:	f426                	sd	s1,40(sp)
 76a:	f04a                	sd	s2,32(sp)
 76c:	ec4e                	sd	s3,24(sp)
 76e:	e852                	sd	s4,16(sp)
 770:	e456                	sd	s5,8(sp)
 772:	e05a                	sd	s6,0(sp)
 774:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 776:	02051493          	slli	s1,a0,0x20
 77a:	9081                	srli	s1,s1,0x20
 77c:	04bd                	addi	s1,s1,15
 77e:	8091                	srli	s1,s1,0x4
 780:	0014899b          	addiw	s3,s1,1
 784:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 786:	00001517          	auipc	a0,0x1
 78a:	87a53503          	ld	a0,-1926(a0) # 1000 <freep>
 78e:	c515                	beqz	a0,7ba <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 790:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 792:	4798                	lw	a4,8(a5)
 794:	02977f63          	bgeu	a4,s1,7d2 <malloc+0x70>
 798:	8a4e                	mv	s4,s3
 79a:	0009871b          	sext.w	a4,s3
 79e:	6685                	lui	a3,0x1
 7a0:	00d77363          	bgeu	a4,a3,7a6 <malloc+0x44>
 7a4:	6a05                	lui	s4,0x1
 7a6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7aa:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7ae:	00001917          	auipc	s2,0x1
 7b2:	85290913          	addi	s2,s2,-1966 # 1000 <freep>
  if(p == (char*)-1)
 7b6:	5afd                	li	s5,-1
 7b8:	a895                	j	82c <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 7ba:	00001797          	auipc	a5,0x1
 7be:	85678793          	addi	a5,a5,-1962 # 1010 <base>
 7c2:	00001717          	auipc	a4,0x1
 7c6:	82f73f23          	sd	a5,-1986(a4) # 1000 <freep>
 7ca:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7cc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7d0:	b7e1                	j	798 <malloc+0x36>
      if(p->s.size == nunits)
 7d2:	02e48c63          	beq	s1,a4,80a <malloc+0xa8>
        p->s.size -= nunits;
 7d6:	4137073b          	subw	a4,a4,s3
 7da:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7dc:	02071693          	slli	a3,a4,0x20
 7e0:	01c6d713          	srli	a4,a3,0x1c
 7e4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7e6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7ea:	00001717          	auipc	a4,0x1
 7ee:	80a73b23          	sd	a0,-2026(a4) # 1000 <freep>
      return (void*)(p + 1);
 7f2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7f6:	70e2                	ld	ra,56(sp)
 7f8:	7442                	ld	s0,48(sp)
 7fa:	74a2                	ld	s1,40(sp)
 7fc:	7902                	ld	s2,32(sp)
 7fe:	69e2                	ld	s3,24(sp)
 800:	6a42                	ld	s4,16(sp)
 802:	6aa2                	ld	s5,8(sp)
 804:	6b02                	ld	s6,0(sp)
 806:	6121                	addi	sp,sp,64
 808:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 80a:	6398                	ld	a4,0(a5)
 80c:	e118                	sd	a4,0(a0)
 80e:	bff1                	j	7ea <malloc+0x88>
  hp->s.size = nu;
 810:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 814:	0541                	addi	a0,a0,16
 816:	00000097          	auipc	ra,0x0
 81a:	eca080e7          	jalr	-310(ra) # 6e0 <free>
  return freep;
 81e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 822:	d971                	beqz	a0,7f6 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 824:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 826:	4798                	lw	a4,8(a5)
 828:	fa9775e3          	bgeu	a4,s1,7d2 <malloc+0x70>
    if(p == freep)
 82c:	00093703          	ld	a4,0(s2)
 830:	853e                	mv	a0,a5
 832:	fef719e3          	bne	a4,a5,824 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 836:	8552                	mv	a0,s4
 838:	00000097          	auipc	ra,0x0
 83c:	b70080e7          	jalr	-1168(ra) # 3a8 <sbrk>
  if(p == (char*)-1)
 840:	fd5518e3          	bne	a0,s5,810 <malloc+0xae>
        return 0;
 844:	4501                	li	a0,0
 846:	bf45                	j	7f6 <malloc+0x94>
