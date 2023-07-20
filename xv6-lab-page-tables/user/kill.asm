
user/_kill：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   c:	4785                	li	a5,1
   e:	02a7dd63          	bge	a5,a0,48 <main+0x48>
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	1c8080e7          	jalr	456(ra) # 1f0 <atoi>
  30:	00000097          	auipc	ra,0x0
  34:	300080e7          	jalr	768(ra) # 330 <kill>
  for(i=1; i<argc; i++)
  38:	04a1                	addi	s1,s1,8
  3a:	ff2496e3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	2c0080e7          	jalr	704(ra) # 300 <exit>
    fprintf(2, "usage: kill pid...\n");
  48:	00000597          	auipc	a1,0x0
  4c:	7e858593          	addi	a1,a1,2024 # 830 <malloc+0xee>
  50:	4509                	li	a0,2
  52:	00000097          	auipc	ra,0x0
  56:	60a080e7          	jalr	1546(ra) # 65c <fprintf>
    exit(1);
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	2a4080e7          	jalr	676(ra) # 300 <exit>

0000000000000064 <_main>:

//
// wrapper so that it's OK if main() does not call exit().
//
void _main()
{
  64:	1141                	addi	sp,sp,-16
  66:	e406                	sd	ra,8(sp)
  68:	e022                	sd	s0,0(sp)
  6a:	0800                	addi	s0,sp,16
    extern int main();
    main();
  6c:	00000097          	auipc	ra,0x0
  70:	f94080e7          	jalr	-108(ra) # 0 <main>
    exit(0);
  74:	4501                	li	a0,0
  76:	00000097          	auipc	ra,0x0
  7a:	28a080e7          	jalr	650(ra) # 300 <exit>

000000000000007e <strcpy>:
}

char *strcpy(char *s, const char *t)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e422                	sd	s0,8(sp)
  82:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
  84:	87aa                	mv	a5,a0
  86:	0585                	addi	a1,a1,1
  88:	0785                	addi	a5,a5,1
  8a:	fff5c703          	lbu	a4,-1(a1)
  8e:	fee78fa3          	sb	a4,-1(a5)
  92:	fb75                	bnez	a4,86 <strcpy+0x8>
        ;
    return os;
}
  94:	6422                	ld	s0,8(sp)
  96:	0141                	addi	sp,sp,16
  98:	8082                	ret

000000000000009a <strcmp>:

int strcmp(const char *p, const char *q)
{
  9a:	1141                	addi	sp,sp,-16
  9c:	e422                	sd	s0,8(sp)
  9e:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
  a0:	00054783          	lbu	a5,0(a0)
  a4:	cb91                	beqz	a5,b8 <strcmp+0x1e>
  a6:	0005c703          	lbu	a4,0(a1)
  aa:	00f71763          	bne	a4,a5,b8 <strcmp+0x1e>
        p++, q++;
  ae:	0505                	addi	a0,a0,1
  b0:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
  b2:	00054783          	lbu	a5,0(a0)
  b6:	fbe5                	bnez	a5,a6 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
  b8:	0005c503          	lbu	a0,0(a1)
}
  bc:	40a7853b          	subw	a0,a5,a0
  c0:	6422                	ld	s0,8(sp)
  c2:	0141                	addi	sp,sp,16
  c4:	8082                	ret

00000000000000c6 <strlen>:

uint strlen(const char *s)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e422                	sd	s0,8(sp)
  ca:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
  cc:	00054783          	lbu	a5,0(a0)
  d0:	cf91                	beqz	a5,ec <strlen+0x26>
  d2:	0505                	addi	a0,a0,1
  d4:	87aa                	mv	a5,a0
  d6:	4685                	li	a3,1
  d8:	9e89                	subw	a3,a3,a0
  da:	00f6853b          	addw	a0,a3,a5
  de:	0785                	addi	a5,a5,1
  e0:	fff7c703          	lbu	a4,-1(a5)
  e4:	fb7d                	bnez	a4,da <strlen+0x14>
        ;
    return n;
}
  e6:	6422                	ld	s0,8(sp)
  e8:	0141                	addi	sp,sp,16
  ea:	8082                	ret
    for (n = 0; s[n]; n++)
  ec:	4501                	li	a0,0
  ee:	bfe5                	j	e6 <strlen+0x20>

00000000000000f0 <memset>:

void *memset(void *dst, int c, uint n)
{
  f0:	1141                	addi	sp,sp,-16
  f2:	e422                	sd	s0,8(sp)
  f4:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++) {
  f6:	ca19                	beqz	a2,10c <memset+0x1c>
  f8:	87aa                	mv	a5,a0
  fa:	1602                	slli	a2,a2,0x20
  fc:	9201                	srli	a2,a2,0x20
  fe:	00a60733          	add	a4,a2,a0
        cdst[i] = c;
 102:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++) {
 106:	0785                	addi	a5,a5,1
 108:	fee79de3          	bne	a5,a4,102 <memset+0x12>
    }
    return dst;
}
 10c:	6422                	ld	s0,8(sp)
 10e:	0141                	addi	sp,sp,16
 110:	8082                	ret

0000000000000112 <strchr>:

char *strchr(const char *s, char c)
{
 112:	1141                	addi	sp,sp,-16
 114:	e422                	sd	s0,8(sp)
 116:	0800                	addi	s0,sp,16
    for (; *s; s++)
 118:	00054783          	lbu	a5,0(a0)
 11c:	cb99                	beqz	a5,132 <strchr+0x20>
        if (*s == c)
 11e:	00f58763          	beq	a1,a5,12c <strchr+0x1a>
    for (; *s; s++)
 122:	0505                	addi	a0,a0,1
 124:	00054783          	lbu	a5,0(a0)
 128:	fbfd                	bnez	a5,11e <strchr+0xc>
            return (char *)s;
    return 0;
 12a:	4501                	li	a0,0
}
 12c:	6422                	ld	s0,8(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret
    return 0;
 132:	4501                	li	a0,0
 134:	bfe5                	j	12c <strchr+0x1a>

0000000000000136 <gets>:

char *gets(char *buf, int max)
{
 136:	711d                	addi	sp,sp,-96
 138:	ec86                	sd	ra,88(sp)
 13a:	e8a2                	sd	s0,80(sp)
 13c:	e4a6                	sd	s1,72(sp)
 13e:	e0ca                	sd	s2,64(sp)
 140:	fc4e                	sd	s3,56(sp)
 142:	f852                	sd	s4,48(sp)
 144:	f456                	sd	s5,40(sp)
 146:	f05a                	sd	s6,32(sp)
 148:	ec5e                	sd	s7,24(sp)
 14a:	1080                	addi	s0,sp,96
 14c:	8baa                	mv	s7,a0
 14e:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;) {
 150:	892a                	mv	s2,a0
 152:	4481                	li	s1,0
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 154:	4aa9                	li	s5,10
 156:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;) {
 158:	89a6                	mv	s3,s1
 15a:	2485                	addiw	s1,s1,1
 15c:	0344d863          	bge	s1,s4,18c <gets+0x56>
        cc = read(0, &c, 1);
 160:	4605                	li	a2,1
 162:	faf40593          	addi	a1,s0,-81
 166:	4501                	li	a0,0
 168:	00000097          	auipc	ra,0x0
 16c:	1b0080e7          	jalr	432(ra) # 318 <read>
        if (cc < 1)
 170:	00a05e63          	blez	a0,18c <gets+0x56>
        buf[i++] = c;
 174:	faf44783          	lbu	a5,-81(s0)
 178:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 17c:	01578763          	beq	a5,s5,18a <gets+0x54>
 180:	0905                	addi	s2,s2,1
 182:	fd679be3          	bne	a5,s6,158 <gets+0x22>
    for (i = 0; i + 1 < max;) {
 186:	89a6                	mv	s3,s1
 188:	a011                	j	18c <gets+0x56>
 18a:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 18c:	99de                	add	s3,s3,s7
 18e:	00098023          	sb	zero,0(s3)
    return buf;
}
 192:	855e                	mv	a0,s7
 194:	60e6                	ld	ra,88(sp)
 196:	6446                	ld	s0,80(sp)
 198:	64a6                	ld	s1,72(sp)
 19a:	6906                	ld	s2,64(sp)
 19c:	79e2                	ld	s3,56(sp)
 19e:	7a42                	ld	s4,48(sp)
 1a0:	7aa2                	ld	s5,40(sp)
 1a2:	7b02                	ld	s6,32(sp)
 1a4:	6be2                	ld	s7,24(sp)
 1a6:	6125                	addi	sp,sp,96
 1a8:	8082                	ret

00000000000001aa <stat>:

int stat(const char *n, struct stat *st)
{
 1aa:	1101                	addi	sp,sp,-32
 1ac:	ec06                	sd	ra,24(sp)
 1ae:	e822                	sd	s0,16(sp)
 1b0:	e426                	sd	s1,8(sp)
 1b2:	e04a                	sd	s2,0(sp)
 1b4:	1000                	addi	s0,sp,32
 1b6:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 1b8:	4581                	li	a1,0
 1ba:	00000097          	auipc	ra,0x0
 1be:	186080e7          	jalr	390(ra) # 340 <open>
    if (fd < 0)
 1c2:	02054563          	bltz	a0,1ec <stat+0x42>
 1c6:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 1c8:	85ca                	mv	a1,s2
 1ca:	00000097          	auipc	ra,0x0
 1ce:	18e080e7          	jalr	398(ra) # 358 <fstat>
 1d2:	892a                	mv	s2,a0
    close(fd);
 1d4:	8526                	mv	a0,s1
 1d6:	00000097          	auipc	ra,0x0
 1da:	152080e7          	jalr	338(ra) # 328 <close>
    return r;
}
 1de:	854a                	mv	a0,s2
 1e0:	60e2                	ld	ra,24(sp)
 1e2:	6442                	ld	s0,16(sp)
 1e4:	64a2                	ld	s1,8(sp)
 1e6:	6902                	ld	s2,0(sp)
 1e8:	6105                	addi	sp,sp,32
 1ea:	8082                	ret
        return -1;
 1ec:	597d                	li	s2,-1
 1ee:	bfc5                	j	1de <stat+0x34>

00000000000001f0 <atoi>:

int atoi(const char *s)
{
 1f0:	1141                	addi	sp,sp,-16
 1f2:	e422                	sd	s0,8(sp)
 1f4:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 1f6:	00054683          	lbu	a3,0(a0)
 1fa:	fd06879b          	addiw	a5,a3,-48
 1fe:	0ff7f793          	zext.b	a5,a5
 202:	4625                	li	a2,9
 204:	02f66863          	bltu	a2,a5,234 <atoi+0x44>
 208:	872a                	mv	a4,a0
    n = 0;
 20a:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
 20c:	0705                	addi	a4,a4,1
 20e:	0025179b          	slliw	a5,a0,0x2
 212:	9fa9                	addw	a5,a5,a0
 214:	0017979b          	slliw	a5,a5,0x1
 218:	9fb5                	addw	a5,a5,a3
 21a:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 21e:	00074683          	lbu	a3,0(a4)
 222:	fd06879b          	addiw	a5,a3,-48
 226:	0ff7f793          	zext.b	a5,a5
 22a:	fef671e3          	bgeu	a2,a5,20c <atoi+0x1c>
    return n;
}
 22e:	6422                	ld	s0,8(sp)
 230:	0141                	addi	sp,sp,16
 232:	8082                	ret
    n = 0;
 234:	4501                	li	a0,0
 236:	bfe5                	j	22e <atoi+0x3e>

0000000000000238 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n)
{
 238:	1141                	addi	sp,sp,-16
 23a:	e422                	sd	s0,8(sp)
 23c:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst) {
 23e:	02b57463          	bgeu	a0,a1,266 <memmove+0x2e>
        while (n-- > 0)
 242:	00c05f63          	blez	a2,260 <memmove+0x28>
 246:	1602                	slli	a2,a2,0x20
 248:	9201                	srli	a2,a2,0x20
 24a:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 24e:	872a                	mv	a4,a0
            *dst++ = *src++;
 250:	0585                	addi	a1,a1,1
 252:	0705                	addi	a4,a4,1
 254:	fff5c683          	lbu	a3,-1(a1)
 258:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 25c:	fee79ae3          	bne	a5,a4,250 <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 260:	6422                	ld	s0,8(sp)
 262:	0141                	addi	sp,sp,16
 264:	8082                	ret
        dst += n;
 266:	00c50733          	add	a4,a0,a2
        src += n;
 26a:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 26c:	fec05ae3          	blez	a2,260 <memmove+0x28>
 270:	fff6079b          	addiw	a5,a2,-1
 274:	1782                	slli	a5,a5,0x20
 276:	9381                	srli	a5,a5,0x20
 278:	fff7c793          	not	a5,a5
 27c:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 27e:	15fd                	addi	a1,a1,-1
 280:	177d                	addi	a4,a4,-1
 282:	0005c683          	lbu	a3,0(a1)
 286:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 28a:	fee79ae3          	bne	a5,a4,27e <memmove+0x46>
 28e:	bfc9                	j	260 <memmove+0x28>

0000000000000290 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0) {
 296:	ca05                	beqz	a2,2c6 <memcmp+0x36>
 298:	fff6069b          	addiw	a3,a2,-1
 29c:	1682                	slli	a3,a3,0x20
 29e:	9281                	srli	a3,a3,0x20
 2a0:	0685                	addi	a3,a3,1
 2a2:	96aa                	add	a3,a3,a0
        if (*p1 != *p2) {
 2a4:	00054783          	lbu	a5,0(a0)
 2a8:	0005c703          	lbu	a4,0(a1)
 2ac:	00e79863          	bne	a5,a4,2bc <memcmp+0x2c>
            return *p1 - *p2;
        }
        p1++;
 2b0:	0505                	addi	a0,a0,1
        p2++;
 2b2:	0585                	addi	a1,a1,1
    while (n-- > 0) {
 2b4:	fed518e3          	bne	a0,a3,2a4 <memcmp+0x14>
    }
    return 0;
 2b8:	4501                	li	a0,0
 2ba:	a019                	j	2c0 <memcmp+0x30>
            return *p1 - *p2;
 2bc:	40e7853b          	subw	a0,a5,a4
}
 2c0:	6422                	ld	s0,8(sp)
 2c2:	0141                	addi	sp,sp,16
 2c4:	8082                	ret
    return 0;
 2c6:	4501                	li	a0,0
 2c8:	bfe5                	j	2c0 <memcmp+0x30>

00000000000002ca <memcpy>:

void *memcpy(void *dst, const void *src, uint n)
{
 2ca:	1141                	addi	sp,sp,-16
 2cc:	e406                	sd	ra,8(sp)
 2ce:	e022                	sd	s0,0(sp)
 2d0:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 2d2:	00000097          	auipc	ra,0x0
 2d6:	f66080e7          	jalr	-154(ra) # 238 <memmove>
}
 2da:	60a2                	ld	ra,8(sp)
 2dc:	6402                	ld	s0,0(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret

00000000000002e2 <ugetpid>:

#ifdef LAB_PGTBL
int ugetpid(void)
{
 2e2:	1141                	addi	sp,sp,-16
 2e4:	e422                	sd	s0,8(sp)
 2e6:	0800                	addi	s0,sp,16
    struct usyscall *u = (struct usyscall *)USYSCALL;
    return u->pid;
 2e8:	040007b7          	lui	a5,0x4000
}
 2ec:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ffefed>
 2ee:	07b2                	slli	a5,a5,0xc
 2f0:	4388                	lw	a0,0(a5)
 2f2:	6422                	ld	s0,8(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret

00000000000002f8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2f8:	4885                	li	a7,1
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <exit>:
.global exit
exit:
 li a7, SYS_exit
 300:	4889                	li	a7,2
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <wait>:
.global wait
wait:
 li a7, SYS_wait
 308:	488d                	li	a7,3
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 310:	4891                	li	a7,4
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <read>:
.global read
read:
 li a7, SYS_read
 318:	4895                	li	a7,5
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <write>:
.global write
write:
 li a7, SYS_write
 320:	48c1                	li	a7,16
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <close>:
.global close
close:
 li a7, SYS_close
 328:	48d5                	li	a7,21
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <kill>:
.global kill
kill:
 li a7, SYS_kill
 330:	4899                	li	a7,6
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <exec>:
.global exec
exec:
 li a7, SYS_exec
 338:	489d                	li	a7,7
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <open>:
.global open
open:
 li a7, SYS_open
 340:	48bd                	li	a7,15
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 348:	48c5                	li	a7,17
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 350:	48c9                	li	a7,18
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 358:	48a1                	li	a7,8
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <link>:
.global link
link:
 li a7, SYS_link
 360:	48cd                	li	a7,19
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 368:	48d1                	li	a7,20
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 370:	48a5                	li	a7,9
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <dup>:
.global dup
dup:
 li a7, SYS_dup
 378:	48a9                	li	a7,10
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 380:	48ad                	li	a7,11
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 388:	48b1                	li	a7,12
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 390:	48b5                	li	a7,13
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 398:	48b9                	li	a7,14
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <connect>:
.global connect
connect:
 li a7, SYS_connect
 3a0:	48f5                	li	a7,29
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 3a8:	48f9                	li	a7,30
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3b0:	1101                	addi	sp,sp,-32
 3b2:	ec06                	sd	ra,24(sp)
 3b4:	e822                	sd	s0,16(sp)
 3b6:	1000                	addi	s0,sp,32
 3b8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3bc:	4605                	li	a2,1
 3be:	fef40593          	addi	a1,s0,-17
 3c2:	00000097          	auipc	ra,0x0
 3c6:	f5e080e7          	jalr	-162(ra) # 320 <write>
}
 3ca:	60e2                	ld	ra,24(sp)
 3cc:	6442                	ld	s0,16(sp)
 3ce:	6105                	addi	sp,sp,32
 3d0:	8082                	ret

00000000000003d2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d2:	7139                	addi	sp,sp,-64
 3d4:	fc06                	sd	ra,56(sp)
 3d6:	f822                	sd	s0,48(sp)
 3d8:	f426                	sd	s1,40(sp)
 3da:	f04a                	sd	s2,32(sp)
 3dc:	ec4e                	sd	s3,24(sp)
 3de:	0080                	addi	s0,sp,64
 3e0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3e2:	c299                	beqz	a3,3e8 <printint+0x16>
 3e4:	0805c963          	bltz	a1,476 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3e8:	2581                	sext.w	a1,a1
  neg = 0;
 3ea:	4881                	li	a7,0
 3ec:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3f0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3f2:	2601                	sext.w	a2,a2
 3f4:	00000517          	auipc	a0,0x0
 3f8:	4b450513          	addi	a0,a0,1204 # 8a8 <digits>
 3fc:	883a                	mv	a6,a4
 3fe:	2705                	addiw	a4,a4,1
 400:	02c5f7bb          	remuw	a5,a1,a2
 404:	1782                	slli	a5,a5,0x20
 406:	9381                	srli	a5,a5,0x20
 408:	97aa                	add	a5,a5,a0
 40a:	0007c783          	lbu	a5,0(a5)
 40e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 412:	0005879b          	sext.w	a5,a1
 416:	02c5d5bb          	divuw	a1,a1,a2
 41a:	0685                	addi	a3,a3,1
 41c:	fec7f0e3          	bgeu	a5,a2,3fc <printint+0x2a>
  if(neg)
 420:	00088c63          	beqz	a7,438 <printint+0x66>
    buf[i++] = '-';
 424:	fd070793          	addi	a5,a4,-48
 428:	00878733          	add	a4,a5,s0
 42c:	02d00793          	li	a5,45
 430:	fef70823          	sb	a5,-16(a4)
 434:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 438:	02e05863          	blez	a4,468 <printint+0x96>
 43c:	fc040793          	addi	a5,s0,-64
 440:	00e78933          	add	s2,a5,a4
 444:	fff78993          	addi	s3,a5,-1
 448:	99ba                	add	s3,s3,a4
 44a:	377d                	addiw	a4,a4,-1
 44c:	1702                	slli	a4,a4,0x20
 44e:	9301                	srli	a4,a4,0x20
 450:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 454:	fff94583          	lbu	a1,-1(s2)
 458:	8526                	mv	a0,s1
 45a:	00000097          	auipc	ra,0x0
 45e:	f56080e7          	jalr	-170(ra) # 3b0 <putc>
  while(--i >= 0)
 462:	197d                	addi	s2,s2,-1
 464:	ff3918e3          	bne	s2,s3,454 <printint+0x82>
}
 468:	70e2                	ld	ra,56(sp)
 46a:	7442                	ld	s0,48(sp)
 46c:	74a2                	ld	s1,40(sp)
 46e:	7902                	ld	s2,32(sp)
 470:	69e2                	ld	s3,24(sp)
 472:	6121                	addi	sp,sp,64
 474:	8082                	ret
    x = -xx;
 476:	40b005bb          	negw	a1,a1
    neg = 1;
 47a:	4885                	li	a7,1
    x = -xx;
 47c:	bf85                	j	3ec <printint+0x1a>

000000000000047e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 47e:	7119                	addi	sp,sp,-128
 480:	fc86                	sd	ra,120(sp)
 482:	f8a2                	sd	s0,112(sp)
 484:	f4a6                	sd	s1,104(sp)
 486:	f0ca                	sd	s2,96(sp)
 488:	ecce                	sd	s3,88(sp)
 48a:	e8d2                	sd	s4,80(sp)
 48c:	e4d6                	sd	s5,72(sp)
 48e:	e0da                	sd	s6,64(sp)
 490:	fc5e                	sd	s7,56(sp)
 492:	f862                	sd	s8,48(sp)
 494:	f466                	sd	s9,40(sp)
 496:	f06a                	sd	s10,32(sp)
 498:	ec6e                	sd	s11,24(sp)
 49a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 49c:	0005c903          	lbu	s2,0(a1)
 4a0:	18090f63          	beqz	s2,63e <vprintf+0x1c0>
 4a4:	8aaa                	mv	s5,a0
 4a6:	8b32                	mv	s6,a2
 4a8:	00158493          	addi	s1,a1,1
  state = 0;
 4ac:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4ae:	02500a13          	li	s4,37
 4b2:	4c55                	li	s8,21
 4b4:	00000c97          	auipc	s9,0x0
 4b8:	39cc8c93          	addi	s9,s9,924 # 850 <malloc+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4bc:	02800d93          	li	s11,40
  putc(fd, 'x');
 4c0:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4c2:	00000b97          	auipc	s7,0x0
 4c6:	3e6b8b93          	addi	s7,s7,998 # 8a8 <digits>
 4ca:	a839                	j	4e8 <vprintf+0x6a>
        putc(fd, c);
 4cc:	85ca                	mv	a1,s2
 4ce:	8556                	mv	a0,s5
 4d0:	00000097          	auipc	ra,0x0
 4d4:	ee0080e7          	jalr	-288(ra) # 3b0 <putc>
 4d8:	a019                	j	4de <vprintf+0x60>
    } else if(state == '%'){
 4da:	01498d63          	beq	s3,s4,4f4 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 4de:	0485                	addi	s1,s1,1
 4e0:	fff4c903          	lbu	s2,-1(s1)
 4e4:	14090d63          	beqz	s2,63e <vprintf+0x1c0>
    if(state == 0){
 4e8:	fe0999e3          	bnez	s3,4da <vprintf+0x5c>
      if(c == '%'){
 4ec:	ff4910e3          	bne	s2,s4,4cc <vprintf+0x4e>
        state = '%';
 4f0:	89d2                	mv	s3,s4
 4f2:	b7f5                	j	4de <vprintf+0x60>
      if(c == 'd'){
 4f4:	11490c63          	beq	s2,s4,60c <vprintf+0x18e>
 4f8:	f9d9079b          	addiw	a5,s2,-99
 4fc:	0ff7f793          	zext.b	a5,a5
 500:	10fc6e63          	bltu	s8,a5,61c <vprintf+0x19e>
 504:	f9d9079b          	addiw	a5,s2,-99
 508:	0ff7f713          	zext.b	a4,a5
 50c:	10ec6863          	bltu	s8,a4,61c <vprintf+0x19e>
 510:	00271793          	slli	a5,a4,0x2
 514:	97e6                	add	a5,a5,s9
 516:	439c                	lw	a5,0(a5)
 518:	97e6                	add	a5,a5,s9
 51a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 51c:	008b0913          	addi	s2,s6,8
 520:	4685                	li	a3,1
 522:	4629                	li	a2,10
 524:	000b2583          	lw	a1,0(s6)
 528:	8556                	mv	a0,s5
 52a:	00000097          	auipc	ra,0x0
 52e:	ea8080e7          	jalr	-344(ra) # 3d2 <printint>
 532:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 534:	4981                	li	s3,0
 536:	b765                	j	4de <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 538:	008b0913          	addi	s2,s6,8
 53c:	4681                	li	a3,0
 53e:	4629                	li	a2,10
 540:	000b2583          	lw	a1,0(s6)
 544:	8556                	mv	a0,s5
 546:	00000097          	auipc	ra,0x0
 54a:	e8c080e7          	jalr	-372(ra) # 3d2 <printint>
 54e:	8b4a                	mv	s6,s2
      state = 0;
 550:	4981                	li	s3,0
 552:	b771                	j	4de <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 554:	008b0913          	addi	s2,s6,8
 558:	4681                	li	a3,0
 55a:	866a                	mv	a2,s10
 55c:	000b2583          	lw	a1,0(s6)
 560:	8556                	mv	a0,s5
 562:	00000097          	auipc	ra,0x0
 566:	e70080e7          	jalr	-400(ra) # 3d2 <printint>
 56a:	8b4a                	mv	s6,s2
      state = 0;
 56c:	4981                	li	s3,0
 56e:	bf85                	j	4de <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 570:	008b0793          	addi	a5,s6,8
 574:	f8f43423          	sd	a5,-120(s0)
 578:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 57c:	03000593          	li	a1,48
 580:	8556                	mv	a0,s5
 582:	00000097          	auipc	ra,0x0
 586:	e2e080e7          	jalr	-466(ra) # 3b0 <putc>
  putc(fd, 'x');
 58a:	07800593          	li	a1,120
 58e:	8556                	mv	a0,s5
 590:	00000097          	auipc	ra,0x0
 594:	e20080e7          	jalr	-480(ra) # 3b0 <putc>
 598:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 59a:	03c9d793          	srli	a5,s3,0x3c
 59e:	97de                	add	a5,a5,s7
 5a0:	0007c583          	lbu	a1,0(a5)
 5a4:	8556                	mv	a0,s5
 5a6:	00000097          	auipc	ra,0x0
 5aa:	e0a080e7          	jalr	-502(ra) # 3b0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5ae:	0992                	slli	s3,s3,0x4
 5b0:	397d                	addiw	s2,s2,-1
 5b2:	fe0914e3          	bnez	s2,59a <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 5b6:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5ba:	4981                	li	s3,0
 5bc:	b70d                	j	4de <vprintf+0x60>
        s = va_arg(ap, char*);
 5be:	008b0913          	addi	s2,s6,8
 5c2:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 5c6:	02098163          	beqz	s3,5e8 <vprintf+0x16a>
        while(*s != 0){
 5ca:	0009c583          	lbu	a1,0(s3)
 5ce:	c5ad                	beqz	a1,638 <vprintf+0x1ba>
          putc(fd, *s);
 5d0:	8556                	mv	a0,s5
 5d2:	00000097          	auipc	ra,0x0
 5d6:	dde080e7          	jalr	-546(ra) # 3b0 <putc>
          s++;
 5da:	0985                	addi	s3,s3,1
        while(*s != 0){
 5dc:	0009c583          	lbu	a1,0(s3)
 5e0:	f9e5                	bnez	a1,5d0 <vprintf+0x152>
        s = va_arg(ap, char*);
 5e2:	8b4a                	mv	s6,s2
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	bde5                	j	4de <vprintf+0x60>
          s = "(null)";
 5e8:	00000997          	auipc	s3,0x0
 5ec:	26098993          	addi	s3,s3,608 # 848 <malloc+0x106>
        while(*s != 0){
 5f0:	85ee                	mv	a1,s11
 5f2:	bff9                	j	5d0 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 5f4:	008b0913          	addi	s2,s6,8
 5f8:	000b4583          	lbu	a1,0(s6)
 5fc:	8556                	mv	a0,s5
 5fe:	00000097          	auipc	ra,0x0
 602:	db2080e7          	jalr	-590(ra) # 3b0 <putc>
 606:	8b4a                	mv	s6,s2
      state = 0;
 608:	4981                	li	s3,0
 60a:	bdd1                	j	4de <vprintf+0x60>
        putc(fd, c);
 60c:	85d2                	mv	a1,s4
 60e:	8556                	mv	a0,s5
 610:	00000097          	auipc	ra,0x0
 614:	da0080e7          	jalr	-608(ra) # 3b0 <putc>
      state = 0;
 618:	4981                	li	s3,0
 61a:	b5d1                	j	4de <vprintf+0x60>
        putc(fd, '%');
 61c:	85d2                	mv	a1,s4
 61e:	8556                	mv	a0,s5
 620:	00000097          	auipc	ra,0x0
 624:	d90080e7          	jalr	-624(ra) # 3b0 <putc>
        putc(fd, c);
 628:	85ca                	mv	a1,s2
 62a:	8556                	mv	a0,s5
 62c:	00000097          	auipc	ra,0x0
 630:	d84080e7          	jalr	-636(ra) # 3b0 <putc>
      state = 0;
 634:	4981                	li	s3,0
 636:	b565                	j	4de <vprintf+0x60>
        s = va_arg(ap, char*);
 638:	8b4a                	mv	s6,s2
      state = 0;
 63a:	4981                	li	s3,0
 63c:	b54d                	j	4de <vprintf+0x60>
    }
  }
}
 63e:	70e6                	ld	ra,120(sp)
 640:	7446                	ld	s0,112(sp)
 642:	74a6                	ld	s1,104(sp)
 644:	7906                	ld	s2,96(sp)
 646:	69e6                	ld	s3,88(sp)
 648:	6a46                	ld	s4,80(sp)
 64a:	6aa6                	ld	s5,72(sp)
 64c:	6b06                	ld	s6,64(sp)
 64e:	7be2                	ld	s7,56(sp)
 650:	7c42                	ld	s8,48(sp)
 652:	7ca2                	ld	s9,40(sp)
 654:	7d02                	ld	s10,32(sp)
 656:	6de2                	ld	s11,24(sp)
 658:	6109                	addi	sp,sp,128
 65a:	8082                	ret

000000000000065c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 65c:	715d                	addi	sp,sp,-80
 65e:	ec06                	sd	ra,24(sp)
 660:	e822                	sd	s0,16(sp)
 662:	1000                	addi	s0,sp,32
 664:	e010                	sd	a2,0(s0)
 666:	e414                	sd	a3,8(s0)
 668:	e818                	sd	a4,16(s0)
 66a:	ec1c                	sd	a5,24(s0)
 66c:	03043023          	sd	a6,32(s0)
 670:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 674:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 678:	8622                	mv	a2,s0
 67a:	00000097          	auipc	ra,0x0
 67e:	e04080e7          	jalr	-508(ra) # 47e <vprintf>
}
 682:	60e2                	ld	ra,24(sp)
 684:	6442                	ld	s0,16(sp)
 686:	6161                	addi	sp,sp,80
 688:	8082                	ret

000000000000068a <printf>:

void
printf(const char *fmt, ...)
{
 68a:	711d                	addi	sp,sp,-96
 68c:	ec06                	sd	ra,24(sp)
 68e:	e822                	sd	s0,16(sp)
 690:	1000                	addi	s0,sp,32
 692:	e40c                	sd	a1,8(s0)
 694:	e810                	sd	a2,16(s0)
 696:	ec14                	sd	a3,24(s0)
 698:	f018                	sd	a4,32(s0)
 69a:	f41c                	sd	a5,40(s0)
 69c:	03043823          	sd	a6,48(s0)
 6a0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6a4:	00840613          	addi	a2,s0,8
 6a8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6ac:	85aa                	mv	a1,a0
 6ae:	4505                	li	a0,1
 6b0:	00000097          	auipc	ra,0x0
 6b4:	dce080e7          	jalr	-562(ra) # 47e <vprintf>
}
 6b8:	60e2                	ld	ra,24(sp)
 6ba:	6442                	ld	s0,16(sp)
 6bc:	6125                	addi	sp,sp,96
 6be:	8082                	ret

00000000000006c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6c0:	1141                	addi	sp,sp,-16
 6c2:	e422                	sd	s0,8(sp)
 6c4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6c6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ca:	00001797          	auipc	a5,0x1
 6ce:	9367b783          	ld	a5,-1738(a5) # 1000 <freep>
 6d2:	a02d                	j	6fc <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6d4:	4618                	lw	a4,8(a2)
 6d6:	9f2d                	addw	a4,a4,a1
 6d8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6dc:	6398                	ld	a4,0(a5)
 6de:	6310                	ld	a2,0(a4)
 6e0:	a83d                	j	71e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6e2:	ff852703          	lw	a4,-8(a0)
 6e6:	9f31                	addw	a4,a4,a2
 6e8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6ea:	ff053683          	ld	a3,-16(a0)
 6ee:	a091                	j	732 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f0:	6398                	ld	a4,0(a5)
 6f2:	00e7e463          	bltu	a5,a4,6fa <free+0x3a>
 6f6:	00e6ea63          	bltu	a3,a4,70a <free+0x4a>
{
 6fa:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fc:	fed7fae3          	bgeu	a5,a3,6f0 <free+0x30>
 700:	6398                	ld	a4,0(a5)
 702:	00e6e463          	bltu	a3,a4,70a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 706:	fee7eae3          	bltu	a5,a4,6fa <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 70a:	ff852583          	lw	a1,-8(a0)
 70e:	6390                	ld	a2,0(a5)
 710:	02059813          	slli	a6,a1,0x20
 714:	01c85713          	srli	a4,a6,0x1c
 718:	9736                	add	a4,a4,a3
 71a:	fae60de3          	beq	a2,a4,6d4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 71e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 722:	4790                	lw	a2,8(a5)
 724:	02061593          	slli	a1,a2,0x20
 728:	01c5d713          	srli	a4,a1,0x1c
 72c:	973e                	add	a4,a4,a5
 72e:	fae68ae3          	beq	a3,a4,6e2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 732:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 734:	00001717          	auipc	a4,0x1
 738:	8cf73623          	sd	a5,-1844(a4) # 1000 <freep>
}
 73c:	6422                	ld	s0,8(sp)
 73e:	0141                	addi	sp,sp,16
 740:	8082                	ret

0000000000000742 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 742:	7139                	addi	sp,sp,-64
 744:	fc06                	sd	ra,56(sp)
 746:	f822                	sd	s0,48(sp)
 748:	f426                	sd	s1,40(sp)
 74a:	f04a                	sd	s2,32(sp)
 74c:	ec4e                	sd	s3,24(sp)
 74e:	e852                	sd	s4,16(sp)
 750:	e456                	sd	s5,8(sp)
 752:	e05a                	sd	s6,0(sp)
 754:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 756:	02051493          	slli	s1,a0,0x20
 75a:	9081                	srli	s1,s1,0x20
 75c:	04bd                	addi	s1,s1,15
 75e:	8091                	srli	s1,s1,0x4
 760:	0014899b          	addiw	s3,s1,1
 764:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 766:	00001517          	auipc	a0,0x1
 76a:	89a53503          	ld	a0,-1894(a0) # 1000 <freep>
 76e:	c515                	beqz	a0,79a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 770:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 772:	4798                	lw	a4,8(a5)
 774:	02977f63          	bgeu	a4,s1,7b2 <malloc+0x70>
 778:	8a4e                	mv	s4,s3
 77a:	0009871b          	sext.w	a4,s3
 77e:	6685                	lui	a3,0x1
 780:	00d77363          	bgeu	a4,a3,786 <malloc+0x44>
 784:	6a05                	lui	s4,0x1
 786:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 78a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 78e:	00001917          	auipc	s2,0x1
 792:	87290913          	addi	s2,s2,-1934 # 1000 <freep>
  if(p == (char*)-1)
 796:	5afd                	li	s5,-1
 798:	a895                	j	80c <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 79a:	00001797          	auipc	a5,0x1
 79e:	87678793          	addi	a5,a5,-1930 # 1010 <base>
 7a2:	00001717          	auipc	a4,0x1
 7a6:	84f73f23          	sd	a5,-1954(a4) # 1000 <freep>
 7aa:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7ac:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7b0:	b7e1                	j	778 <malloc+0x36>
      if(p->s.size == nunits)
 7b2:	02e48c63          	beq	s1,a4,7ea <malloc+0xa8>
        p->s.size -= nunits;
 7b6:	4137073b          	subw	a4,a4,s3
 7ba:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7bc:	02071693          	slli	a3,a4,0x20
 7c0:	01c6d713          	srli	a4,a3,0x1c
 7c4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7c6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7ca:	00001717          	auipc	a4,0x1
 7ce:	82a73b23          	sd	a0,-1994(a4) # 1000 <freep>
      return (void*)(p + 1);
 7d2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7d6:	70e2                	ld	ra,56(sp)
 7d8:	7442                	ld	s0,48(sp)
 7da:	74a2                	ld	s1,40(sp)
 7dc:	7902                	ld	s2,32(sp)
 7de:	69e2                	ld	s3,24(sp)
 7e0:	6a42                	ld	s4,16(sp)
 7e2:	6aa2                	ld	s5,8(sp)
 7e4:	6b02                	ld	s6,0(sp)
 7e6:	6121                	addi	sp,sp,64
 7e8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7ea:	6398                	ld	a4,0(a5)
 7ec:	e118                	sd	a4,0(a0)
 7ee:	bff1                	j	7ca <malloc+0x88>
  hp->s.size = nu;
 7f0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7f4:	0541                	addi	a0,a0,16
 7f6:	00000097          	auipc	ra,0x0
 7fa:	eca080e7          	jalr	-310(ra) # 6c0 <free>
  return freep;
 7fe:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 802:	d971                	beqz	a0,7d6 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 804:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 806:	4798                	lw	a4,8(a5)
 808:	fa9775e3          	bgeu	a4,s1,7b2 <malloc+0x70>
    if(p == freep)
 80c:	00093703          	ld	a4,0(s2)
 810:	853e                	mv	a0,a5
 812:	fef719e3          	bne	a4,a5,804 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 816:	8552                	mv	a0,s4
 818:	00000097          	auipc	ra,0x0
 81c:	b70080e7          	jalr	-1168(ra) # 388 <sbrk>
  if(p == (char*)-1)
 820:	fd5518e3          	bne	a0,s5,7f0 <malloc+0xae>
        return 0;
 824:	4501                	li	a0,0
 826:	bf45                	j	7d6 <malloc+0x94>
