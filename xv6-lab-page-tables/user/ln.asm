
user/_ln：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
  if(argc != 3){
   a:	478d                	li	a5,3
   c:	02f50063          	beq	a0,a5,2c <main+0x2c>
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	82058593          	addi	a1,a1,-2016 # 830 <malloc+0xf2>
  18:	4509                	li	a0,2
  1a:	00000097          	auipc	ra,0x0
  1e:	63e080e7          	jalr	1598(ra) # 658 <fprintf>
    exit(1);
  22:	4505                	li	a0,1
  24:	00000097          	auipc	ra,0x0
  28:	2d8080e7          	jalr	728(ra) # 2fc <exit>
  2c:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  2e:	698c                	ld	a1,16(a1)
  30:	6488                	ld	a0,8(s1)
  32:	00000097          	auipc	ra,0x0
  36:	32a080e7          	jalr	810(ra) # 35c <link>
  3a:	00054763          	bltz	a0,48 <main+0x48>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	2bc080e7          	jalr	700(ra) # 2fc <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  48:	6894                	ld	a3,16(s1)
  4a:	6490                	ld	a2,8(s1)
  4c:	00000597          	auipc	a1,0x0
  50:	7fc58593          	addi	a1,a1,2044 # 848 <malloc+0x10a>
  54:	4509                	li	a0,2
  56:	00000097          	auipc	ra,0x0
  5a:	602080e7          	jalr	1538(ra) # 658 <fprintf>
  5e:	b7c5                	j	3e <main+0x3e>

0000000000000060 <_main>:

//
// wrapper so that it's OK if main() does not call exit().
//
void _main()
{
  60:	1141                	addi	sp,sp,-16
  62:	e406                	sd	ra,8(sp)
  64:	e022                	sd	s0,0(sp)
  66:	0800                	addi	s0,sp,16
    extern int main();
    main();
  68:	00000097          	auipc	ra,0x0
  6c:	f98080e7          	jalr	-104(ra) # 0 <main>
    exit(0);
  70:	4501                	li	a0,0
  72:	00000097          	auipc	ra,0x0
  76:	28a080e7          	jalr	650(ra) # 2fc <exit>

000000000000007a <strcpy>:
}

char *strcpy(char *s, const char *t)
{
  7a:	1141                	addi	sp,sp,-16
  7c:	e422                	sd	s0,8(sp)
  7e:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
  80:	87aa                	mv	a5,a0
  82:	0585                	addi	a1,a1,1
  84:	0785                	addi	a5,a5,1
  86:	fff5c703          	lbu	a4,-1(a1)
  8a:	fee78fa3          	sb	a4,-1(a5)
  8e:	fb75                	bnez	a4,82 <strcpy+0x8>
        ;
    return os;
}
  90:	6422                	ld	s0,8(sp)
  92:	0141                	addi	sp,sp,16
  94:	8082                	ret

0000000000000096 <strcmp>:

int strcmp(const char *p, const char *q)
{
  96:	1141                	addi	sp,sp,-16
  98:	e422                	sd	s0,8(sp)
  9a:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
  9c:	00054783          	lbu	a5,0(a0)
  a0:	cb91                	beqz	a5,b4 <strcmp+0x1e>
  a2:	0005c703          	lbu	a4,0(a1)
  a6:	00f71763          	bne	a4,a5,b4 <strcmp+0x1e>
        p++, q++;
  aa:	0505                	addi	a0,a0,1
  ac:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
  ae:	00054783          	lbu	a5,0(a0)
  b2:	fbe5                	bnez	a5,a2 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
  b4:	0005c503          	lbu	a0,0(a1)
}
  b8:	40a7853b          	subw	a0,a5,a0
  bc:	6422                	ld	s0,8(sp)
  be:	0141                	addi	sp,sp,16
  c0:	8082                	ret

00000000000000c2 <strlen>:

uint strlen(const char *s)
{
  c2:	1141                	addi	sp,sp,-16
  c4:	e422                	sd	s0,8(sp)
  c6:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
  c8:	00054783          	lbu	a5,0(a0)
  cc:	cf91                	beqz	a5,e8 <strlen+0x26>
  ce:	0505                	addi	a0,a0,1
  d0:	87aa                	mv	a5,a0
  d2:	4685                	li	a3,1
  d4:	9e89                	subw	a3,a3,a0
  d6:	00f6853b          	addw	a0,a3,a5
  da:	0785                	addi	a5,a5,1
  dc:	fff7c703          	lbu	a4,-1(a5)
  e0:	fb7d                	bnez	a4,d6 <strlen+0x14>
        ;
    return n;
}
  e2:	6422                	ld	s0,8(sp)
  e4:	0141                	addi	sp,sp,16
  e6:	8082                	ret
    for (n = 0; s[n]; n++)
  e8:	4501                	li	a0,0
  ea:	bfe5                	j	e2 <strlen+0x20>

00000000000000ec <memset>:

void *memset(void *dst, int c, uint n)
{
  ec:	1141                	addi	sp,sp,-16
  ee:	e422                	sd	s0,8(sp)
  f0:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++) {
  f2:	ca19                	beqz	a2,108 <memset+0x1c>
  f4:	87aa                	mv	a5,a0
  f6:	1602                	slli	a2,a2,0x20
  f8:	9201                	srli	a2,a2,0x20
  fa:	00a60733          	add	a4,a2,a0
        cdst[i] = c;
  fe:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++) {
 102:	0785                	addi	a5,a5,1
 104:	fee79de3          	bne	a5,a4,fe <memset+0x12>
    }
    return dst;
}
 108:	6422                	ld	s0,8(sp)
 10a:	0141                	addi	sp,sp,16
 10c:	8082                	ret

000000000000010e <strchr>:

char *strchr(const char *s, char c)
{
 10e:	1141                	addi	sp,sp,-16
 110:	e422                	sd	s0,8(sp)
 112:	0800                	addi	s0,sp,16
    for (; *s; s++)
 114:	00054783          	lbu	a5,0(a0)
 118:	cb99                	beqz	a5,12e <strchr+0x20>
        if (*s == c)
 11a:	00f58763          	beq	a1,a5,128 <strchr+0x1a>
    for (; *s; s++)
 11e:	0505                	addi	a0,a0,1
 120:	00054783          	lbu	a5,0(a0)
 124:	fbfd                	bnez	a5,11a <strchr+0xc>
            return (char *)s;
    return 0;
 126:	4501                	li	a0,0
}
 128:	6422                	ld	s0,8(sp)
 12a:	0141                	addi	sp,sp,16
 12c:	8082                	ret
    return 0;
 12e:	4501                	li	a0,0
 130:	bfe5                	j	128 <strchr+0x1a>

0000000000000132 <gets>:

char *gets(char *buf, int max)
{
 132:	711d                	addi	sp,sp,-96
 134:	ec86                	sd	ra,88(sp)
 136:	e8a2                	sd	s0,80(sp)
 138:	e4a6                	sd	s1,72(sp)
 13a:	e0ca                	sd	s2,64(sp)
 13c:	fc4e                	sd	s3,56(sp)
 13e:	f852                	sd	s4,48(sp)
 140:	f456                	sd	s5,40(sp)
 142:	f05a                	sd	s6,32(sp)
 144:	ec5e                	sd	s7,24(sp)
 146:	1080                	addi	s0,sp,96
 148:	8baa                	mv	s7,a0
 14a:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;) {
 14c:	892a                	mv	s2,a0
 14e:	4481                	li	s1,0
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 150:	4aa9                	li	s5,10
 152:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;) {
 154:	89a6                	mv	s3,s1
 156:	2485                	addiw	s1,s1,1
 158:	0344d863          	bge	s1,s4,188 <gets+0x56>
        cc = read(0, &c, 1);
 15c:	4605                	li	a2,1
 15e:	faf40593          	addi	a1,s0,-81
 162:	4501                	li	a0,0
 164:	00000097          	auipc	ra,0x0
 168:	1b0080e7          	jalr	432(ra) # 314 <read>
        if (cc < 1)
 16c:	00a05e63          	blez	a0,188 <gets+0x56>
        buf[i++] = c;
 170:	faf44783          	lbu	a5,-81(s0)
 174:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 178:	01578763          	beq	a5,s5,186 <gets+0x54>
 17c:	0905                	addi	s2,s2,1
 17e:	fd679be3          	bne	a5,s6,154 <gets+0x22>
    for (i = 0; i + 1 < max;) {
 182:	89a6                	mv	s3,s1
 184:	a011                	j	188 <gets+0x56>
 186:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 188:	99de                	add	s3,s3,s7
 18a:	00098023          	sb	zero,0(s3)
    return buf;
}
 18e:	855e                	mv	a0,s7
 190:	60e6                	ld	ra,88(sp)
 192:	6446                	ld	s0,80(sp)
 194:	64a6                	ld	s1,72(sp)
 196:	6906                	ld	s2,64(sp)
 198:	79e2                	ld	s3,56(sp)
 19a:	7a42                	ld	s4,48(sp)
 19c:	7aa2                	ld	s5,40(sp)
 19e:	7b02                	ld	s6,32(sp)
 1a0:	6be2                	ld	s7,24(sp)
 1a2:	6125                	addi	sp,sp,96
 1a4:	8082                	ret

00000000000001a6 <stat>:

int stat(const char *n, struct stat *st)
{
 1a6:	1101                	addi	sp,sp,-32
 1a8:	ec06                	sd	ra,24(sp)
 1aa:	e822                	sd	s0,16(sp)
 1ac:	e426                	sd	s1,8(sp)
 1ae:	e04a                	sd	s2,0(sp)
 1b0:	1000                	addi	s0,sp,32
 1b2:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 1b4:	4581                	li	a1,0
 1b6:	00000097          	auipc	ra,0x0
 1ba:	186080e7          	jalr	390(ra) # 33c <open>
    if (fd < 0)
 1be:	02054563          	bltz	a0,1e8 <stat+0x42>
 1c2:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 1c4:	85ca                	mv	a1,s2
 1c6:	00000097          	auipc	ra,0x0
 1ca:	18e080e7          	jalr	398(ra) # 354 <fstat>
 1ce:	892a                	mv	s2,a0
    close(fd);
 1d0:	8526                	mv	a0,s1
 1d2:	00000097          	auipc	ra,0x0
 1d6:	152080e7          	jalr	338(ra) # 324 <close>
    return r;
}
 1da:	854a                	mv	a0,s2
 1dc:	60e2                	ld	ra,24(sp)
 1de:	6442                	ld	s0,16(sp)
 1e0:	64a2                	ld	s1,8(sp)
 1e2:	6902                	ld	s2,0(sp)
 1e4:	6105                	addi	sp,sp,32
 1e6:	8082                	ret
        return -1;
 1e8:	597d                	li	s2,-1
 1ea:	bfc5                	j	1da <stat+0x34>

00000000000001ec <atoi>:

int atoi(const char *s)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e422                	sd	s0,8(sp)
 1f0:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 1f2:	00054683          	lbu	a3,0(a0)
 1f6:	fd06879b          	addiw	a5,a3,-48
 1fa:	0ff7f793          	zext.b	a5,a5
 1fe:	4625                	li	a2,9
 200:	02f66863          	bltu	a2,a5,230 <atoi+0x44>
 204:	872a                	mv	a4,a0
    n = 0;
 206:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
 208:	0705                	addi	a4,a4,1
 20a:	0025179b          	slliw	a5,a0,0x2
 20e:	9fa9                	addw	a5,a5,a0
 210:	0017979b          	slliw	a5,a5,0x1
 214:	9fb5                	addw	a5,a5,a3
 216:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 21a:	00074683          	lbu	a3,0(a4)
 21e:	fd06879b          	addiw	a5,a3,-48
 222:	0ff7f793          	zext.b	a5,a5
 226:	fef671e3          	bgeu	a2,a5,208 <atoi+0x1c>
    return n;
}
 22a:	6422                	ld	s0,8(sp)
 22c:	0141                	addi	sp,sp,16
 22e:	8082                	ret
    n = 0;
 230:	4501                	li	a0,0
 232:	bfe5                	j	22a <atoi+0x3e>

0000000000000234 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n)
{
 234:	1141                	addi	sp,sp,-16
 236:	e422                	sd	s0,8(sp)
 238:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst) {
 23a:	02b57463          	bgeu	a0,a1,262 <memmove+0x2e>
        while (n-- > 0)
 23e:	00c05f63          	blez	a2,25c <memmove+0x28>
 242:	1602                	slli	a2,a2,0x20
 244:	9201                	srli	a2,a2,0x20
 246:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 24a:	872a                	mv	a4,a0
            *dst++ = *src++;
 24c:	0585                	addi	a1,a1,1
 24e:	0705                	addi	a4,a4,1
 250:	fff5c683          	lbu	a3,-1(a1)
 254:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 258:	fee79ae3          	bne	a5,a4,24c <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 25c:	6422                	ld	s0,8(sp)
 25e:	0141                	addi	sp,sp,16
 260:	8082                	ret
        dst += n;
 262:	00c50733          	add	a4,a0,a2
        src += n;
 266:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 268:	fec05ae3          	blez	a2,25c <memmove+0x28>
 26c:	fff6079b          	addiw	a5,a2,-1
 270:	1782                	slli	a5,a5,0x20
 272:	9381                	srli	a5,a5,0x20
 274:	fff7c793          	not	a5,a5
 278:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 27a:	15fd                	addi	a1,a1,-1
 27c:	177d                	addi	a4,a4,-1
 27e:	0005c683          	lbu	a3,0(a1)
 282:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 286:	fee79ae3          	bne	a5,a4,27a <memmove+0x46>
 28a:	bfc9                	j	25c <memmove+0x28>

000000000000028c <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e422                	sd	s0,8(sp)
 290:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0) {
 292:	ca05                	beqz	a2,2c2 <memcmp+0x36>
 294:	fff6069b          	addiw	a3,a2,-1
 298:	1682                	slli	a3,a3,0x20
 29a:	9281                	srli	a3,a3,0x20
 29c:	0685                	addi	a3,a3,1
 29e:	96aa                	add	a3,a3,a0
        if (*p1 != *p2) {
 2a0:	00054783          	lbu	a5,0(a0)
 2a4:	0005c703          	lbu	a4,0(a1)
 2a8:	00e79863          	bne	a5,a4,2b8 <memcmp+0x2c>
            return *p1 - *p2;
        }
        p1++;
 2ac:	0505                	addi	a0,a0,1
        p2++;
 2ae:	0585                	addi	a1,a1,1
    while (n-- > 0) {
 2b0:	fed518e3          	bne	a0,a3,2a0 <memcmp+0x14>
    }
    return 0;
 2b4:	4501                	li	a0,0
 2b6:	a019                	j	2bc <memcmp+0x30>
            return *p1 - *p2;
 2b8:	40e7853b          	subw	a0,a5,a4
}
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret
    return 0;
 2c2:	4501                	li	a0,0
 2c4:	bfe5                	j	2bc <memcmp+0x30>

00000000000002c6 <memcpy>:

void *memcpy(void *dst, const void *src, uint n)
{
 2c6:	1141                	addi	sp,sp,-16
 2c8:	e406                	sd	ra,8(sp)
 2ca:	e022                	sd	s0,0(sp)
 2cc:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 2ce:	00000097          	auipc	ra,0x0
 2d2:	f66080e7          	jalr	-154(ra) # 234 <memmove>
}
 2d6:	60a2                	ld	ra,8(sp)
 2d8:	6402                	ld	s0,0(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret

00000000000002de <ugetpid>:

#ifdef LAB_PGTBL
int ugetpid(void)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e422                	sd	s0,8(sp)
 2e2:	0800                	addi	s0,sp,16
    struct usyscall *u = (struct usyscall *)USYSCALL;
    return u->pid;
 2e4:	040007b7          	lui	a5,0x4000
}
 2e8:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ffefed>
 2ea:	07b2                	slli	a5,a5,0xc
 2ec:	4388                	lw	a0,0(a5)
 2ee:	6422                	ld	s0,8(sp)
 2f0:	0141                	addi	sp,sp,16
 2f2:	8082                	ret

00000000000002f4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2f4:	4885                	li	a7,1
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <exit>:
.global exit
exit:
 li a7, SYS_exit
 2fc:	4889                	li	a7,2
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <wait>:
.global wait
wait:
 li a7, SYS_wait
 304:	488d                	li	a7,3
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 30c:	4891                	li	a7,4
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <read>:
.global read
read:
 li a7, SYS_read
 314:	4895                	li	a7,5
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <write>:
.global write
write:
 li a7, SYS_write
 31c:	48c1                	li	a7,16
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <close>:
.global close
close:
 li a7, SYS_close
 324:	48d5                	li	a7,21
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <kill>:
.global kill
kill:
 li a7, SYS_kill
 32c:	4899                	li	a7,6
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <exec>:
.global exec
exec:
 li a7, SYS_exec
 334:	489d                	li	a7,7
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <open>:
.global open
open:
 li a7, SYS_open
 33c:	48bd                	li	a7,15
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 344:	48c5                	li	a7,17
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 34c:	48c9                	li	a7,18
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 354:	48a1                	li	a7,8
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <link>:
.global link
link:
 li a7, SYS_link
 35c:	48cd                	li	a7,19
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 364:	48d1                	li	a7,20
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 36c:	48a5                	li	a7,9
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <dup>:
.global dup
dup:
 li a7, SYS_dup
 374:	48a9                	li	a7,10
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 37c:	48ad                	li	a7,11
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 384:	48b1                	li	a7,12
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 38c:	48b5                	li	a7,13
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 394:	48b9                	li	a7,14
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <connect>:
.global connect
connect:
 li a7, SYS_connect
 39c:	48f5                	li	a7,29
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 3a4:	48f9                	li	a7,30
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ac:	1101                	addi	sp,sp,-32
 3ae:	ec06                	sd	ra,24(sp)
 3b0:	e822                	sd	s0,16(sp)
 3b2:	1000                	addi	s0,sp,32
 3b4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3b8:	4605                	li	a2,1
 3ba:	fef40593          	addi	a1,s0,-17
 3be:	00000097          	auipc	ra,0x0
 3c2:	f5e080e7          	jalr	-162(ra) # 31c <write>
}
 3c6:	60e2                	ld	ra,24(sp)
 3c8:	6442                	ld	s0,16(sp)
 3ca:	6105                	addi	sp,sp,32
 3cc:	8082                	ret

00000000000003ce <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ce:	7139                	addi	sp,sp,-64
 3d0:	fc06                	sd	ra,56(sp)
 3d2:	f822                	sd	s0,48(sp)
 3d4:	f426                	sd	s1,40(sp)
 3d6:	f04a                	sd	s2,32(sp)
 3d8:	ec4e                	sd	s3,24(sp)
 3da:	0080                	addi	s0,sp,64
 3dc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3de:	c299                	beqz	a3,3e4 <printint+0x16>
 3e0:	0805c963          	bltz	a1,472 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3e4:	2581                	sext.w	a1,a1
  neg = 0;
 3e6:	4881                	li	a7,0
 3e8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3ec:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ee:	2601                	sext.w	a2,a2
 3f0:	00000517          	auipc	a0,0x0
 3f4:	4d050513          	addi	a0,a0,1232 # 8c0 <digits>
 3f8:	883a                	mv	a6,a4
 3fa:	2705                	addiw	a4,a4,1
 3fc:	02c5f7bb          	remuw	a5,a1,a2
 400:	1782                	slli	a5,a5,0x20
 402:	9381                	srli	a5,a5,0x20
 404:	97aa                	add	a5,a5,a0
 406:	0007c783          	lbu	a5,0(a5)
 40a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 40e:	0005879b          	sext.w	a5,a1
 412:	02c5d5bb          	divuw	a1,a1,a2
 416:	0685                	addi	a3,a3,1
 418:	fec7f0e3          	bgeu	a5,a2,3f8 <printint+0x2a>
  if(neg)
 41c:	00088c63          	beqz	a7,434 <printint+0x66>
    buf[i++] = '-';
 420:	fd070793          	addi	a5,a4,-48
 424:	00878733          	add	a4,a5,s0
 428:	02d00793          	li	a5,45
 42c:	fef70823          	sb	a5,-16(a4)
 430:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 434:	02e05863          	blez	a4,464 <printint+0x96>
 438:	fc040793          	addi	a5,s0,-64
 43c:	00e78933          	add	s2,a5,a4
 440:	fff78993          	addi	s3,a5,-1
 444:	99ba                	add	s3,s3,a4
 446:	377d                	addiw	a4,a4,-1
 448:	1702                	slli	a4,a4,0x20
 44a:	9301                	srli	a4,a4,0x20
 44c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 450:	fff94583          	lbu	a1,-1(s2)
 454:	8526                	mv	a0,s1
 456:	00000097          	auipc	ra,0x0
 45a:	f56080e7          	jalr	-170(ra) # 3ac <putc>
  while(--i >= 0)
 45e:	197d                	addi	s2,s2,-1
 460:	ff3918e3          	bne	s2,s3,450 <printint+0x82>
}
 464:	70e2                	ld	ra,56(sp)
 466:	7442                	ld	s0,48(sp)
 468:	74a2                	ld	s1,40(sp)
 46a:	7902                	ld	s2,32(sp)
 46c:	69e2                	ld	s3,24(sp)
 46e:	6121                	addi	sp,sp,64
 470:	8082                	ret
    x = -xx;
 472:	40b005bb          	negw	a1,a1
    neg = 1;
 476:	4885                	li	a7,1
    x = -xx;
 478:	bf85                	j	3e8 <printint+0x1a>

000000000000047a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 47a:	7119                	addi	sp,sp,-128
 47c:	fc86                	sd	ra,120(sp)
 47e:	f8a2                	sd	s0,112(sp)
 480:	f4a6                	sd	s1,104(sp)
 482:	f0ca                	sd	s2,96(sp)
 484:	ecce                	sd	s3,88(sp)
 486:	e8d2                	sd	s4,80(sp)
 488:	e4d6                	sd	s5,72(sp)
 48a:	e0da                	sd	s6,64(sp)
 48c:	fc5e                	sd	s7,56(sp)
 48e:	f862                	sd	s8,48(sp)
 490:	f466                	sd	s9,40(sp)
 492:	f06a                	sd	s10,32(sp)
 494:	ec6e                	sd	s11,24(sp)
 496:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 498:	0005c903          	lbu	s2,0(a1)
 49c:	18090f63          	beqz	s2,63a <vprintf+0x1c0>
 4a0:	8aaa                	mv	s5,a0
 4a2:	8b32                	mv	s6,a2
 4a4:	00158493          	addi	s1,a1,1
  state = 0;
 4a8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4aa:	02500a13          	li	s4,37
 4ae:	4c55                	li	s8,21
 4b0:	00000c97          	auipc	s9,0x0
 4b4:	3b8c8c93          	addi	s9,s9,952 # 868 <malloc+0x12a>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4b8:	02800d93          	li	s11,40
  putc(fd, 'x');
 4bc:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4be:	00000b97          	auipc	s7,0x0
 4c2:	402b8b93          	addi	s7,s7,1026 # 8c0 <digits>
 4c6:	a839                	j	4e4 <vprintf+0x6a>
        putc(fd, c);
 4c8:	85ca                	mv	a1,s2
 4ca:	8556                	mv	a0,s5
 4cc:	00000097          	auipc	ra,0x0
 4d0:	ee0080e7          	jalr	-288(ra) # 3ac <putc>
 4d4:	a019                	j	4da <vprintf+0x60>
    } else if(state == '%'){
 4d6:	01498d63          	beq	s3,s4,4f0 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 4da:	0485                	addi	s1,s1,1
 4dc:	fff4c903          	lbu	s2,-1(s1)
 4e0:	14090d63          	beqz	s2,63a <vprintf+0x1c0>
    if(state == 0){
 4e4:	fe0999e3          	bnez	s3,4d6 <vprintf+0x5c>
      if(c == '%'){
 4e8:	ff4910e3          	bne	s2,s4,4c8 <vprintf+0x4e>
        state = '%';
 4ec:	89d2                	mv	s3,s4
 4ee:	b7f5                	j	4da <vprintf+0x60>
      if(c == 'd'){
 4f0:	11490c63          	beq	s2,s4,608 <vprintf+0x18e>
 4f4:	f9d9079b          	addiw	a5,s2,-99
 4f8:	0ff7f793          	zext.b	a5,a5
 4fc:	10fc6e63          	bltu	s8,a5,618 <vprintf+0x19e>
 500:	f9d9079b          	addiw	a5,s2,-99
 504:	0ff7f713          	zext.b	a4,a5
 508:	10ec6863          	bltu	s8,a4,618 <vprintf+0x19e>
 50c:	00271793          	slli	a5,a4,0x2
 510:	97e6                	add	a5,a5,s9
 512:	439c                	lw	a5,0(a5)
 514:	97e6                	add	a5,a5,s9
 516:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 518:	008b0913          	addi	s2,s6,8
 51c:	4685                	li	a3,1
 51e:	4629                	li	a2,10
 520:	000b2583          	lw	a1,0(s6)
 524:	8556                	mv	a0,s5
 526:	00000097          	auipc	ra,0x0
 52a:	ea8080e7          	jalr	-344(ra) # 3ce <printint>
 52e:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 530:	4981                	li	s3,0
 532:	b765                	j	4da <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 534:	008b0913          	addi	s2,s6,8
 538:	4681                	li	a3,0
 53a:	4629                	li	a2,10
 53c:	000b2583          	lw	a1,0(s6)
 540:	8556                	mv	a0,s5
 542:	00000097          	auipc	ra,0x0
 546:	e8c080e7          	jalr	-372(ra) # 3ce <printint>
 54a:	8b4a                	mv	s6,s2
      state = 0;
 54c:	4981                	li	s3,0
 54e:	b771                	j	4da <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 550:	008b0913          	addi	s2,s6,8
 554:	4681                	li	a3,0
 556:	866a                	mv	a2,s10
 558:	000b2583          	lw	a1,0(s6)
 55c:	8556                	mv	a0,s5
 55e:	00000097          	auipc	ra,0x0
 562:	e70080e7          	jalr	-400(ra) # 3ce <printint>
 566:	8b4a                	mv	s6,s2
      state = 0;
 568:	4981                	li	s3,0
 56a:	bf85                	j	4da <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 56c:	008b0793          	addi	a5,s6,8
 570:	f8f43423          	sd	a5,-120(s0)
 574:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 578:	03000593          	li	a1,48
 57c:	8556                	mv	a0,s5
 57e:	00000097          	auipc	ra,0x0
 582:	e2e080e7          	jalr	-466(ra) # 3ac <putc>
  putc(fd, 'x');
 586:	07800593          	li	a1,120
 58a:	8556                	mv	a0,s5
 58c:	00000097          	auipc	ra,0x0
 590:	e20080e7          	jalr	-480(ra) # 3ac <putc>
 594:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 596:	03c9d793          	srli	a5,s3,0x3c
 59a:	97de                	add	a5,a5,s7
 59c:	0007c583          	lbu	a1,0(a5)
 5a0:	8556                	mv	a0,s5
 5a2:	00000097          	auipc	ra,0x0
 5a6:	e0a080e7          	jalr	-502(ra) # 3ac <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5aa:	0992                	slli	s3,s3,0x4
 5ac:	397d                	addiw	s2,s2,-1
 5ae:	fe0914e3          	bnez	s2,596 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 5b2:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5b6:	4981                	li	s3,0
 5b8:	b70d                	j	4da <vprintf+0x60>
        s = va_arg(ap, char*);
 5ba:	008b0913          	addi	s2,s6,8
 5be:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 5c2:	02098163          	beqz	s3,5e4 <vprintf+0x16a>
        while(*s != 0){
 5c6:	0009c583          	lbu	a1,0(s3)
 5ca:	c5ad                	beqz	a1,634 <vprintf+0x1ba>
          putc(fd, *s);
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	dde080e7          	jalr	-546(ra) # 3ac <putc>
          s++;
 5d6:	0985                	addi	s3,s3,1
        while(*s != 0){
 5d8:	0009c583          	lbu	a1,0(s3)
 5dc:	f9e5                	bnez	a1,5cc <vprintf+0x152>
        s = va_arg(ap, char*);
 5de:	8b4a                	mv	s6,s2
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	bde5                	j	4da <vprintf+0x60>
          s = "(null)";
 5e4:	00000997          	auipc	s3,0x0
 5e8:	27c98993          	addi	s3,s3,636 # 860 <malloc+0x122>
        while(*s != 0){
 5ec:	85ee                	mv	a1,s11
 5ee:	bff9                	j	5cc <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 5f0:	008b0913          	addi	s2,s6,8
 5f4:	000b4583          	lbu	a1,0(s6)
 5f8:	8556                	mv	a0,s5
 5fa:	00000097          	auipc	ra,0x0
 5fe:	db2080e7          	jalr	-590(ra) # 3ac <putc>
 602:	8b4a                	mv	s6,s2
      state = 0;
 604:	4981                	li	s3,0
 606:	bdd1                	j	4da <vprintf+0x60>
        putc(fd, c);
 608:	85d2                	mv	a1,s4
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	da0080e7          	jalr	-608(ra) # 3ac <putc>
      state = 0;
 614:	4981                	li	s3,0
 616:	b5d1                	j	4da <vprintf+0x60>
        putc(fd, '%');
 618:	85d2                	mv	a1,s4
 61a:	8556                	mv	a0,s5
 61c:	00000097          	auipc	ra,0x0
 620:	d90080e7          	jalr	-624(ra) # 3ac <putc>
        putc(fd, c);
 624:	85ca                	mv	a1,s2
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	d84080e7          	jalr	-636(ra) # 3ac <putc>
      state = 0;
 630:	4981                	li	s3,0
 632:	b565                	j	4da <vprintf+0x60>
        s = va_arg(ap, char*);
 634:	8b4a                	mv	s6,s2
      state = 0;
 636:	4981                	li	s3,0
 638:	b54d                	j	4da <vprintf+0x60>
    }
  }
}
 63a:	70e6                	ld	ra,120(sp)
 63c:	7446                	ld	s0,112(sp)
 63e:	74a6                	ld	s1,104(sp)
 640:	7906                	ld	s2,96(sp)
 642:	69e6                	ld	s3,88(sp)
 644:	6a46                	ld	s4,80(sp)
 646:	6aa6                	ld	s5,72(sp)
 648:	6b06                	ld	s6,64(sp)
 64a:	7be2                	ld	s7,56(sp)
 64c:	7c42                	ld	s8,48(sp)
 64e:	7ca2                	ld	s9,40(sp)
 650:	7d02                	ld	s10,32(sp)
 652:	6de2                	ld	s11,24(sp)
 654:	6109                	addi	sp,sp,128
 656:	8082                	ret

0000000000000658 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 658:	715d                	addi	sp,sp,-80
 65a:	ec06                	sd	ra,24(sp)
 65c:	e822                	sd	s0,16(sp)
 65e:	1000                	addi	s0,sp,32
 660:	e010                	sd	a2,0(s0)
 662:	e414                	sd	a3,8(s0)
 664:	e818                	sd	a4,16(s0)
 666:	ec1c                	sd	a5,24(s0)
 668:	03043023          	sd	a6,32(s0)
 66c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 670:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 674:	8622                	mv	a2,s0
 676:	00000097          	auipc	ra,0x0
 67a:	e04080e7          	jalr	-508(ra) # 47a <vprintf>
}
 67e:	60e2                	ld	ra,24(sp)
 680:	6442                	ld	s0,16(sp)
 682:	6161                	addi	sp,sp,80
 684:	8082                	ret

0000000000000686 <printf>:

void
printf(const char *fmt, ...)
{
 686:	711d                	addi	sp,sp,-96
 688:	ec06                	sd	ra,24(sp)
 68a:	e822                	sd	s0,16(sp)
 68c:	1000                	addi	s0,sp,32
 68e:	e40c                	sd	a1,8(s0)
 690:	e810                	sd	a2,16(s0)
 692:	ec14                	sd	a3,24(s0)
 694:	f018                	sd	a4,32(s0)
 696:	f41c                	sd	a5,40(s0)
 698:	03043823          	sd	a6,48(s0)
 69c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6a0:	00840613          	addi	a2,s0,8
 6a4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6a8:	85aa                	mv	a1,a0
 6aa:	4505                	li	a0,1
 6ac:	00000097          	auipc	ra,0x0
 6b0:	dce080e7          	jalr	-562(ra) # 47a <vprintf>
}
 6b4:	60e2                	ld	ra,24(sp)
 6b6:	6442                	ld	s0,16(sp)
 6b8:	6125                	addi	sp,sp,96
 6ba:	8082                	ret

00000000000006bc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6bc:	1141                	addi	sp,sp,-16
 6be:	e422                	sd	s0,8(sp)
 6c0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6c2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c6:	00001797          	auipc	a5,0x1
 6ca:	93a7b783          	ld	a5,-1734(a5) # 1000 <freep>
 6ce:	a02d                	j	6f8 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6d0:	4618                	lw	a4,8(a2)
 6d2:	9f2d                	addw	a4,a4,a1
 6d4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d8:	6398                	ld	a4,0(a5)
 6da:	6310                	ld	a2,0(a4)
 6dc:	a83d                	j	71a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6de:	ff852703          	lw	a4,-8(a0)
 6e2:	9f31                	addw	a4,a4,a2
 6e4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6e6:	ff053683          	ld	a3,-16(a0)
 6ea:	a091                	j	72e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ec:	6398                	ld	a4,0(a5)
 6ee:	00e7e463          	bltu	a5,a4,6f6 <free+0x3a>
 6f2:	00e6ea63          	bltu	a3,a4,706 <free+0x4a>
{
 6f6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f8:	fed7fae3          	bgeu	a5,a3,6ec <free+0x30>
 6fc:	6398                	ld	a4,0(a5)
 6fe:	00e6e463          	bltu	a3,a4,706 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 702:	fee7eae3          	bltu	a5,a4,6f6 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 706:	ff852583          	lw	a1,-8(a0)
 70a:	6390                	ld	a2,0(a5)
 70c:	02059813          	slli	a6,a1,0x20
 710:	01c85713          	srli	a4,a6,0x1c
 714:	9736                	add	a4,a4,a3
 716:	fae60de3          	beq	a2,a4,6d0 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 71a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 71e:	4790                	lw	a2,8(a5)
 720:	02061593          	slli	a1,a2,0x20
 724:	01c5d713          	srli	a4,a1,0x1c
 728:	973e                	add	a4,a4,a5
 72a:	fae68ae3          	beq	a3,a4,6de <free+0x22>
    p->s.ptr = bp->s.ptr;
 72e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 730:	00001717          	auipc	a4,0x1
 734:	8cf73823          	sd	a5,-1840(a4) # 1000 <freep>
}
 738:	6422                	ld	s0,8(sp)
 73a:	0141                	addi	sp,sp,16
 73c:	8082                	ret

000000000000073e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 73e:	7139                	addi	sp,sp,-64
 740:	fc06                	sd	ra,56(sp)
 742:	f822                	sd	s0,48(sp)
 744:	f426                	sd	s1,40(sp)
 746:	f04a                	sd	s2,32(sp)
 748:	ec4e                	sd	s3,24(sp)
 74a:	e852                	sd	s4,16(sp)
 74c:	e456                	sd	s5,8(sp)
 74e:	e05a                	sd	s6,0(sp)
 750:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 752:	02051493          	slli	s1,a0,0x20
 756:	9081                	srli	s1,s1,0x20
 758:	04bd                	addi	s1,s1,15
 75a:	8091                	srli	s1,s1,0x4
 75c:	0014899b          	addiw	s3,s1,1
 760:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 762:	00001517          	auipc	a0,0x1
 766:	89e53503          	ld	a0,-1890(a0) # 1000 <freep>
 76a:	c515                	beqz	a0,796 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 76c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 76e:	4798                	lw	a4,8(a5)
 770:	02977f63          	bgeu	a4,s1,7ae <malloc+0x70>
 774:	8a4e                	mv	s4,s3
 776:	0009871b          	sext.w	a4,s3
 77a:	6685                	lui	a3,0x1
 77c:	00d77363          	bgeu	a4,a3,782 <malloc+0x44>
 780:	6a05                	lui	s4,0x1
 782:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 786:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 78a:	00001917          	auipc	s2,0x1
 78e:	87690913          	addi	s2,s2,-1930 # 1000 <freep>
  if(p == (char*)-1)
 792:	5afd                	li	s5,-1
 794:	a895                	j	808 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 796:	00001797          	auipc	a5,0x1
 79a:	87a78793          	addi	a5,a5,-1926 # 1010 <base>
 79e:	00001717          	auipc	a4,0x1
 7a2:	86f73123          	sd	a5,-1950(a4) # 1000 <freep>
 7a6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7a8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7ac:	b7e1                	j	774 <malloc+0x36>
      if(p->s.size == nunits)
 7ae:	02e48c63          	beq	s1,a4,7e6 <malloc+0xa8>
        p->s.size -= nunits;
 7b2:	4137073b          	subw	a4,a4,s3
 7b6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7b8:	02071693          	slli	a3,a4,0x20
 7bc:	01c6d713          	srli	a4,a3,0x1c
 7c0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7c2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7c6:	00001717          	auipc	a4,0x1
 7ca:	82a73d23          	sd	a0,-1990(a4) # 1000 <freep>
      return (void*)(p + 1);
 7ce:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7d2:	70e2                	ld	ra,56(sp)
 7d4:	7442                	ld	s0,48(sp)
 7d6:	74a2                	ld	s1,40(sp)
 7d8:	7902                	ld	s2,32(sp)
 7da:	69e2                	ld	s3,24(sp)
 7dc:	6a42                	ld	s4,16(sp)
 7de:	6aa2                	ld	s5,8(sp)
 7e0:	6b02                	ld	s6,0(sp)
 7e2:	6121                	addi	sp,sp,64
 7e4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7e6:	6398                	ld	a4,0(a5)
 7e8:	e118                	sd	a4,0(a0)
 7ea:	bff1                	j	7c6 <malloc+0x88>
  hp->s.size = nu;
 7ec:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7f0:	0541                	addi	a0,a0,16
 7f2:	00000097          	auipc	ra,0x0
 7f6:	eca080e7          	jalr	-310(ra) # 6bc <free>
  return freep;
 7fa:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7fe:	d971                	beqz	a0,7d2 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 800:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 802:	4798                	lw	a4,8(a5)
 804:	fa9775e3          	bgeu	a4,s1,7ae <malloc+0x70>
    if(p == freep)
 808:	00093703          	ld	a4,0(s2)
 80c:	853e                	mv	a0,a5
 80e:	fef719e3          	bne	a4,a5,800 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 812:	8552                	mv	a0,s4
 814:	00000097          	auipc	ra,0x0
 818:	b70080e7          	jalr	-1168(ra) # 384 <sbrk>
  if(p == (char*)-1)
 81c:	fd5518e3          	bne	a0,s5,7ec <malloc+0xae>
        return 0;
 820:	4501                	li	a0,0
 822:	bf45                	j	7d2 <malloc+0x94>
