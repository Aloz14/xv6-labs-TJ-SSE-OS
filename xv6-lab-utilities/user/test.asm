
user/_test：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

#define FDS_WRITE 1
#define FDS_READ 0

int main()
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
    char *argv[3];
    argv[0] = "echo";
   8:	00000517          	auipc	a0,0x0
   c:	7d850513          	addi	a0,a0,2008 # 7e0 <malloc+0xee>
  10:	fca43c23          	sd	a0,-40(s0)
    argv[1] = "hello";
  14:	00000797          	auipc	a5,0x0
  18:	7d478793          	addi	a5,a5,2004 # 7e8 <malloc+0xf6>
  1c:	fef43023          	sd	a5,-32(s0)
    argv[2] = 0;
  20:	fe043423          	sd	zero,-24(s0)
    exec("echo", argv);
  24:	fd840593          	addi	a1,s0,-40
  28:	00000097          	auipc	ra,0x0
  2c:	2d0080e7          	jalr	720(ra) # 2f8 <exec>
    exit(0);
  30:	4501                	li	a0,0
  32:	00000097          	auipc	ra,0x0
  36:	28e080e7          	jalr	654(ra) # 2c0 <exit>

000000000000003a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  3a:	1141                	addi	sp,sp,-16
  3c:	e406                	sd	ra,8(sp)
  3e:	e022                	sd	s0,0(sp)
  40:	0800                	addi	s0,sp,16
  extern int main();
  main();
  42:	00000097          	auipc	ra,0x0
  46:	fbe080e7          	jalr	-66(ra) # 0 <main>
  exit(0);
  4a:	4501                	li	a0,0
  4c:	00000097          	auipc	ra,0x0
  50:	274080e7          	jalr	628(ra) # 2c0 <exit>

0000000000000054 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  54:	1141                	addi	sp,sp,-16
  56:	e422                	sd	s0,8(sp)
  58:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  5a:	87aa                	mv	a5,a0
  5c:	0585                	addi	a1,a1,1
  5e:	0785                	addi	a5,a5,1
  60:	fff5c703          	lbu	a4,-1(a1)
  64:	fee78fa3          	sb	a4,-1(a5)
  68:	fb75                	bnez	a4,5c <strcpy+0x8>
    ;
  return os;
}
  6a:	6422                	ld	s0,8(sp)
  6c:	0141                	addi	sp,sp,16
  6e:	8082                	ret

0000000000000070 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  70:	1141                	addi	sp,sp,-16
  72:	e422                	sd	s0,8(sp)
  74:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  76:	00054783          	lbu	a5,0(a0)
  7a:	cb91                	beqz	a5,8e <strcmp+0x1e>
  7c:	0005c703          	lbu	a4,0(a1)
  80:	00f71763          	bne	a4,a5,8e <strcmp+0x1e>
    p++, q++;
  84:	0505                	addi	a0,a0,1
  86:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  88:	00054783          	lbu	a5,0(a0)
  8c:	fbe5                	bnez	a5,7c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  8e:	0005c503          	lbu	a0,0(a1)
}
  92:	40a7853b          	subw	a0,a5,a0
  96:	6422                	ld	s0,8(sp)
  98:	0141                	addi	sp,sp,16
  9a:	8082                	ret

000000000000009c <strlen>:

uint
strlen(const char *s)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e422                	sd	s0,8(sp)
  a0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  a2:	00054783          	lbu	a5,0(a0)
  a6:	cf91                	beqz	a5,c2 <strlen+0x26>
  a8:	0505                	addi	a0,a0,1
  aa:	87aa                	mv	a5,a0
  ac:	4685                	li	a3,1
  ae:	9e89                	subw	a3,a3,a0
  b0:	00f6853b          	addw	a0,a3,a5
  b4:	0785                	addi	a5,a5,1
  b6:	fff7c703          	lbu	a4,-1(a5)
  ba:	fb7d                	bnez	a4,b0 <strlen+0x14>
    ;
  return n;
}
  bc:	6422                	ld	s0,8(sp)
  be:	0141                	addi	sp,sp,16
  c0:	8082                	ret
  for(n = 0; s[n]; n++)
  c2:	4501                	li	a0,0
  c4:	bfe5                	j	bc <strlen+0x20>

00000000000000c6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e422                	sd	s0,8(sp)
  ca:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  cc:	ca19                	beqz	a2,e2 <memset+0x1c>
  ce:	87aa                	mv	a5,a0
  d0:	1602                	slli	a2,a2,0x20
  d2:	9201                	srli	a2,a2,0x20
  d4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  d8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  dc:	0785                	addi	a5,a5,1
  de:	fee79de3          	bne	a5,a4,d8 <memset+0x12>
  }
  return dst;
}
  e2:	6422                	ld	s0,8(sp)
  e4:	0141                	addi	sp,sp,16
  e6:	8082                	ret

00000000000000e8 <strchr>:

char*
strchr(const char *s, char c)
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e422                	sd	s0,8(sp)
  ec:	0800                	addi	s0,sp,16
  for(; *s; s++)
  ee:	00054783          	lbu	a5,0(a0)
  f2:	cb99                	beqz	a5,108 <strchr+0x20>
    if(*s == c)
  f4:	00f58763          	beq	a1,a5,102 <strchr+0x1a>
  for(; *s; s++)
  f8:	0505                	addi	a0,a0,1
  fa:	00054783          	lbu	a5,0(a0)
  fe:	fbfd                	bnez	a5,f4 <strchr+0xc>
      return (char*)s;
  return 0;
 100:	4501                	li	a0,0
}
 102:	6422                	ld	s0,8(sp)
 104:	0141                	addi	sp,sp,16
 106:	8082                	ret
  return 0;
 108:	4501                	li	a0,0
 10a:	bfe5                	j	102 <strchr+0x1a>

000000000000010c <gets>:

char*
gets(char *buf, int max)
{
 10c:	711d                	addi	sp,sp,-96
 10e:	ec86                	sd	ra,88(sp)
 110:	e8a2                	sd	s0,80(sp)
 112:	e4a6                	sd	s1,72(sp)
 114:	e0ca                	sd	s2,64(sp)
 116:	fc4e                	sd	s3,56(sp)
 118:	f852                	sd	s4,48(sp)
 11a:	f456                	sd	s5,40(sp)
 11c:	f05a                	sd	s6,32(sp)
 11e:	ec5e                	sd	s7,24(sp)
 120:	1080                	addi	s0,sp,96
 122:	8baa                	mv	s7,a0
 124:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 126:	892a                	mv	s2,a0
 128:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 12a:	4aa9                	li	s5,10
 12c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 12e:	89a6                	mv	s3,s1
 130:	2485                	addiw	s1,s1,1
 132:	0344d863          	bge	s1,s4,162 <gets+0x56>
    cc = read(0, &c, 1);
 136:	4605                	li	a2,1
 138:	faf40593          	addi	a1,s0,-81
 13c:	4501                	li	a0,0
 13e:	00000097          	auipc	ra,0x0
 142:	19a080e7          	jalr	410(ra) # 2d8 <read>
    if(cc < 1)
 146:	00a05e63          	blez	a0,162 <gets+0x56>
    buf[i++] = c;
 14a:	faf44783          	lbu	a5,-81(s0)
 14e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 152:	01578763          	beq	a5,s5,160 <gets+0x54>
 156:	0905                	addi	s2,s2,1
 158:	fd679be3          	bne	a5,s6,12e <gets+0x22>
  for(i=0; i+1 < max; ){
 15c:	89a6                	mv	s3,s1
 15e:	a011                	j	162 <gets+0x56>
 160:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 162:	99de                	add	s3,s3,s7
 164:	00098023          	sb	zero,0(s3)
  return buf;
}
 168:	855e                	mv	a0,s7
 16a:	60e6                	ld	ra,88(sp)
 16c:	6446                	ld	s0,80(sp)
 16e:	64a6                	ld	s1,72(sp)
 170:	6906                	ld	s2,64(sp)
 172:	79e2                	ld	s3,56(sp)
 174:	7a42                	ld	s4,48(sp)
 176:	7aa2                	ld	s5,40(sp)
 178:	7b02                	ld	s6,32(sp)
 17a:	6be2                	ld	s7,24(sp)
 17c:	6125                	addi	sp,sp,96
 17e:	8082                	ret

0000000000000180 <stat>:

int
stat(const char *n, struct stat *st)
{
 180:	1101                	addi	sp,sp,-32
 182:	ec06                	sd	ra,24(sp)
 184:	e822                	sd	s0,16(sp)
 186:	e426                	sd	s1,8(sp)
 188:	e04a                	sd	s2,0(sp)
 18a:	1000                	addi	s0,sp,32
 18c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 18e:	4581                	li	a1,0
 190:	00000097          	auipc	ra,0x0
 194:	170080e7          	jalr	368(ra) # 300 <open>
  if(fd < 0)
 198:	02054563          	bltz	a0,1c2 <stat+0x42>
 19c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 19e:	85ca                	mv	a1,s2
 1a0:	00000097          	auipc	ra,0x0
 1a4:	178080e7          	jalr	376(ra) # 318 <fstat>
 1a8:	892a                	mv	s2,a0
  close(fd);
 1aa:	8526                	mv	a0,s1
 1ac:	00000097          	auipc	ra,0x0
 1b0:	13c080e7          	jalr	316(ra) # 2e8 <close>
  return r;
}
 1b4:	854a                	mv	a0,s2
 1b6:	60e2                	ld	ra,24(sp)
 1b8:	6442                	ld	s0,16(sp)
 1ba:	64a2                	ld	s1,8(sp)
 1bc:	6902                	ld	s2,0(sp)
 1be:	6105                	addi	sp,sp,32
 1c0:	8082                	ret
    return -1;
 1c2:	597d                	li	s2,-1
 1c4:	bfc5                	j	1b4 <stat+0x34>

00000000000001c6 <atoi>:

int
atoi(const char *s)
{
 1c6:	1141                	addi	sp,sp,-16
 1c8:	e422                	sd	s0,8(sp)
 1ca:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1cc:	00054683          	lbu	a3,0(a0)
 1d0:	fd06879b          	addiw	a5,a3,-48
 1d4:	0ff7f793          	zext.b	a5,a5
 1d8:	4625                	li	a2,9
 1da:	02f66863          	bltu	a2,a5,20a <atoi+0x44>
 1de:	872a                	mv	a4,a0
  n = 0;
 1e0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1e2:	0705                	addi	a4,a4,1
 1e4:	0025179b          	slliw	a5,a0,0x2
 1e8:	9fa9                	addw	a5,a5,a0
 1ea:	0017979b          	slliw	a5,a5,0x1
 1ee:	9fb5                	addw	a5,a5,a3
 1f0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1f4:	00074683          	lbu	a3,0(a4)
 1f8:	fd06879b          	addiw	a5,a3,-48
 1fc:	0ff7f793          	zext.b	a5,a5
 200:	fef671e3          	bgeu	a2,a5,1e2 <atoi+0x1c>
  return n;
}
 204:	6422                	ld	s0,8(sp)
 206:	0141                	addi	sp,sp,16
 208:	8082                	ret
  n = 0;
 20a:	4501                	li	a0,0
 20c:	bfe5                	j	204 <atoi+0x3e>

000000000000020e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 20e:	1141                	addi	sp,sp,-16
 210:	e422                	sd	s0,8(sp)
 212:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 214:	02b57463          	bgeu	a0,a1,23c <memmove+0x2e>
    while(n-- > 0)
 218:	00c05f63          	blez	a2,236 <memmove+0x28>
 21c:	1602                	slli	a2,a2,0x20
 21e:	9201                	srli	a2,a2,0x20
 220:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 224:	872a                	mv	a4,a0
      *dst++ = *src++;
 226:	0585                	addi	a1,a1,1
 228:	0705                	addi	a4,a4,1
 22a:	fff5c683          	lbu	a3,-1(a1)
 22e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 232:	fee79ae3          	bne	a5,a4,226 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 236:	6422                	ld	s0,8(sp)
 238:	0141                	addi	sp,sp,16
 23a:	8082                	ret
    dst += n;
 23c:	00c50733          	add	a4,a0,a2
    src += n;
 240:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 242:	fec05ae3          	blez	a2,236 <memmove+0x28>
 246:	fff6079b          	addiw	a5,a2,-1
 24a:	1782                	slli	a5,a5,0x20
 24c:	9381                	srli	a5,a5,0x20
 24e:	fff7c793          	not	a5,a5
 252:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 254:	15fd                	addi	a1,a1,-1
 256:	177d                	addi	a4,a4,-1
 258:	0005c683          	lbu	a3,0(a1)
 25c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 260:	fee79ae3          	bne	a5,a4,254 <memmove+0x46>
 264:	bfc9                	j	236 <memmove+0x28>

0000000000000266 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 266:	1141                	addi	sp,sp,-16
 268:	e422                	sd	s0,8(sp)
 26a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 26c:	ca05                	beqz	a2,29c <memcmp+0x36>
 26e:	fff6069b          	addiw	a3,a2,-1
 272:	1682                	slli	a3,a3,0x20
 274:	9281                	srli	a3,a3,0x20
 276:	0685                	addi	a3,a3,1
 278:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 27a:	00054783          	lbu	a5,0(a0)
 27e:	0005c703          	lbu	a4,0(a1)
 282:	00e79863          	bne	a5,a4,292 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 286:	0505                	addi	a0,a0,1
    p2++;
 288:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 28a:	fed518e3          	bne	a0,a3,27a <memcmp+0x14>
  }
  return 0;
 28e:	4501                	li	a0,0
 290:	a019                	j	296 <memcmp+0x30>
      return *p1 - *p2;
 292:	40e7853b          	subw	a0,a5,a4
}
 296:	6422                	ld	s0,8(sp)
 298:	0141                	addi	sp,sp,16
 29a:	8082                	ret
  return 0;
 29c:	4501                	li	a0,0
 29e:	bfe5                	j	296 <memcmp+0x30>

00000000000002a0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e406                	sd	ra,8(sp)
 2a4:	e022                	sd	s0,0(sp)
 2a6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2a8:	00000097          	auipc	ra,0x0
 2ac:	f66080e7          	jalr	-154(ra) # 20e <memmove>
}
 2b0:	60a2                	ld	ra,8(sp)
 2b2:	6402                	ld	s0,0(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret

00000000000002b8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2b8:	4885                	li	a7,1
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2c0:	4889                	li	a7,2
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2c8:	488d                	li	a7,3
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2d0:	4891                	li	a7,4
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <read>:
.global read
read:
 li a7, SYS_read
 2d8:	4895                	li	a7,5
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <write>:
.global write
write:
 li a7, SYS_write
 2e0:	48c1                	li	a7,16
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <close>:
.global close
close:
 li a7, SYS_close
 2e8:	48d5                	li	a7,21
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2f0:	4899                	li	a7,6
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2f8:	489d                	li	a7,7
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <open>:
.global open
open:
 li a7, SYS_open
 300:	48bd                	li	a7,15
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 308:	48c5                	li	a7,17
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 310:	48c9                	li	a7,18
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 318:	48a1                	li	a7,8
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <link>:
.global link
link:
 li a7, SYS_link
 320:	48cd                	li	a7,19
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 328:	48d1                	li	a7,20
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 330:	48a5                	li	a7,9
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <dup>:
.global dup
dup:
 li a7, SYS_dup
 338:	48a9                	li	a7,10
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 340:	48ad                	li	a7,11
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 348:	48b1                	li	a7,12
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 350:	48b5                	li	a7,13
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 358:	48b9                	li	a7,14
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 360:	1101                	addi	sp,sp,-32
 362:	ec06                	sd	ra,24(sp)
 364:	e822                	sd	s0,16(sp)
 366:	1000                	addi	s0,sp,32
 368:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 36c:	4605                	li	a2,1
 36e:	fef40593          	addi	a1,s0,-17
 372:	00000097          	auipc	ra,0x0
 376:	f6e080e7          	jalr	-146(ra) # 2e0 <write>
}
 37a:	60e2                	ld	ra,24(sp)
 37c:	6442                	ld	s0,16(sp)
 37e:	6105                	addi	sp,sp,32
 380:	8082                	ret

0000000000000382 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 382:	7139                	addi	sp,sp,-64
 384:	fc06                	sd	ra,56(sp)
 386:	f822                	sd	s0,48(sp)
 388:	f426                	sd	s1,40(sp)
 38a:	f04a                	sd	s2,32(sp)
 38c:	ec4e                	sd	s3,24(sp)
 38e:	0080                	addi	s0,sp,64
 390:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 392:	c299                	beqz	a3,398 <printint+0x16>
 394:	0805c963          	bltz	a1,426 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 398:	2581                	sext.w	a1,a1
  neg = 0;
 39a:	4881                	li	a7,0
 39c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3a0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3a2:	2601                	sext.w	a2,a2
 3a4:	00000517          	auipc	a0,0x0
 3a8:	4ac50513          	addi	a0,a0,1196 # 850 <digits>
 3ac:	883a                	mv	a6,a4
 3ae:	2705                	addiw	a4,a4,1
 3b0:	02c5f7bb          	remuw	a5,a1,a2
 3b4:	1782                	slli	a5,a5,0x20
 3b6:	9381                	srli	a5,a5,0x20
 3b8:	97aa                	add	a5,a5,a0
 3ba:	0007c783          	lbu	a5,0(a5)
 3be:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3c2:	0005879b          	sext.w	a5,a1
 3c6:	02c5d5bb          	divuw	a1,a1,a2
 3ca:	0685                	addi	a3,a3,1
 3cc:	fec7f0e3          	bgeu	a5,a2,3ac <printint+0x2a>
  if(neg)
 3d0:	00088c63          	beqz	a7,3e8 <printint+0x66>
    buf[i++] = '-';
 3d4:	fd070793          	addi	a5,a4,-48
 3d8:	00878733          	add	a4,a5,s0
 3dc:	02d00793          	li	a5,45
 3e0:	fef70823          	sb	a5,-16(a4)
 3e4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3e8:	02e05863          	blez	a4,418 <printint+0x96>
 3ec:	fc040793          	addi	a5,s0,-64
 3f0:	00e78933          	add	s2,a5,a4
 3f4:	fff78993          	addi	s3,a5,-1
 3f8:	99ba                	add	s3,s3,a4
 3fa:	377d                	addiw	a4,a4,-1
 3fc:	1702                	slli	a4,a4,0x20
 3fe:	9301                	srli	a4,a4,0x20
 400:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 404:	fff94583          	lbu	a1,-1(s2)
 408:	8526                	mv	a0,s1
 40a:	00000097          	auipc	ra,0x0
 40e:	f56080e7          	jalr	-170(ra) # 360 <putc>
  while(--i >= 0)
 412:	197d                	addi	s2,s2,-1
 414:	ff3918e3          	bne	s2,s3,404 <printint+0x82>
}
 418:	70e2                	ld	ra,56(sp)
 41a:	7442                	ld	s0,48(sp)
 41c:	74a2                	ld	s1,40(sp)
 41e:	7902                	ld	s2,32(sp)
 420:	69e2                	ld	s3,24(sp)
 422:	6121                	addi	sp,sp,64
 424:	8082                	ret
    x = -xx;
 426:	40b005bb          	negw	a1,a1
    neg = 1;
 42a:	4885                	li	a7,1
    x = -xx;
 42c:	bf85                	j	39c <printint+0x1a>

000000000000042e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 42e:	7119                	addi	sp,sp,-128
 430:	fc86                	sd	ra,120(sp)
 432:	f8a2                	sd	s0,112(sp)
 434:	f4a6                	sd	s1,104(sp)
 436:	f0ca                	sd	s2,96(sp)
 438:	ecce                	sd	s3,88(sp)
 43a:	e8d2                	sd	s4,80(sp)
 43c:	e4d6                	sd	s5,72(sp)
 43e:	e0da                	sd	s6,64(sp)
 440:	fc5e                	sd	s7,56(sp)
 442:	f862                	sd	s8,48(sp)
 444:	f466                	sd	s9,40(sp)
 446:	f06a                	sd	s10,32(sp)
 448:	ec6e                	sd	s11,24(sp)
 44a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 44c:	0005c903          	lbu	s2,0(a1)
 450:	18090f63          	beqz	s2,5ee <vprintf+0x1c0>
 454:	8aaa                	mv	s5,a0
 456:	8b32                	mv	s6,a2
 458:	00158493          	addi	s1,a1,1
  state = 0;
 45c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 45e:	02500a13          	li	s4,37
 462:	4c55                	li	s8,21
 464:	00000c97          	auipc	s9,0x0
 468:	394c8c93          	addi	s9,s9,916 # 7f8 <malloc+0x106>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 46c:	02800d93          	li	s11,40
  putc(fd, 'x');
 470:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 472:	00000b97          	auipc	s7,0x0
 476:	3deb8b93          	addi	s7,s7,990 # 850 <digits>
 47a:	a839                	j	498 <vprintf+0x6a>
        putc(fd, c);
 47c:	85ca                	mv	a1,s2
 47e:	8556                	mv	a0,s5
 480:	00000097          	auipc	ra,0x0
 484:	ee0080e7          	jalr	-288(ra) # 360 <putc>
 488:	a019                	j	48e <vprintf+0x60>
    } else if(state == '%'){
 48a:	01498d63          	beq	s3,s4,4a4 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 48e:	0485                	addi	s1,s1,1
 490:	fff4c903          	lbu	s2,-1(s1)
 494:	14090d63          	beqz	s2,5ee <vprintf+0x1c0>
    if(state == 0){
 498:	fe0999e3          	bnez	s3,48a <vprintf+0x5c>
      if(c == '%'){
 49c:	ff4910e3          	bne	s2,s4,47c <vprintf+0x4e>
        state = '%';
 4a0:	89d2                	mv	s3,s4
 4a2:	b7f5                	j	48e <vprintf+0x60>
      if(c == 'd'){
 4a4:	11490c63          	beq	s2,s4,5bc <vprintf+0x18e>
 4a8:	f9d9079b          	addiw	a5,s2,-99
 4ac:	0ff7f793          	zext.b	a5,a5
 4b0:	10fc6e63          	bltu	s8,a5,5cc <vprintf+0x19e>
 4b4:	f9d9079b          	addiw	a5,s2,-99
 4b8:	0ff7f713          	zext.b	a4,a5
 4bc:	10ec6863          	bltu	s8,a4,5cc <vprintf+0x19e>
 4c0:	00271793          	slli	a5,a4,0x2
 4c4:	97e6                	add	a5,a5,s9
 4c6:	439c                	lw	a5,0(a5)
 4c8:	97e6                	add	a5,a5,s9
 4ca:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4cc:	008b0913          	addi	s2,s6,8
 4d0:	4685                	li	a3,1
 4d2:	4629                	li	a2,10
 4d4:	000b2583          	lw	a1,0(s6)
 4d8:	8556                	mv	a0,s5
 4da:	00000097          	auipc	ra,0x0
 4de:	ea8080e7          	jalr	-344(ra) # 382 <printint>
 4e2:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4e4:	4981                	li	s3,0
 4e6:	b765                	j	48e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4e8:	008b0913          	addi	s2,s6,8
 4ec:	4681                	li	a3,0
 4ee:	4629                	li	a2,10
 4f0:	000b2583          	lw	a1,0(s6)
 4f4:	8556                	mv	a0,s5
 4f6:	00000097          	auipc	ra,0x0
 4fa:	e8c080e7          	jalr	-372(ra) # 382 <printint>
 4fe:	8b4a                	mv	s6,s2
      state = 0;
 500:	4981                	li	s3,0
 502:	b771                	j	48e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 504:	008b0913          	addi	s2,s6,8
 508:	4681                	li	a3,0
 50a:	866a                	mv	a2,s10
 50c:	000b2583          	lw	a1,0(s6)
 510:	8556                	mv	a0,s5
 512:	00000097          	auipc	ra,0x0
 516:	e70080e7          	jalr	-400(ra) # 382 <printint>
 51a:	8b4a                	mv	s6,s2
      state = 0;
 51c:	4981                	li	s3,0
 51e:	bf85                	j	48e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 520:	008b0793          	addi	a5,s6,8
 524:	f8f43423          	sd	a5,-120(s0)
 528:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 52c:	03000593          	li	a1,48
 530:	8556                	mv	a0,s5
 532:	00000097          	auipc	ra,0x0
 536:	e2e080e7          	jalr	-466(ra) # 360 <putc>
  putc(fd, 'x');
 53a:	07800593          	li	a1,120
 53e:	8556                	mv	a0,s5
 540:	00000097          	auipc	ra,0x0
 544:	e20080e7          	jalr	-480(ra) # 360 <putc>
 548:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 54a:	03c9d793          	srli	a5,s3,0x3c
 54e:	97de                	add	a5,a5,s7
 550:	0007c583          	lbu	a1,0(a5)
 554:	8556                	mv	a0,s5
 556:	00000097          	auipc	ra,0x0
 55a:	e0a080e7          	jalr	-502(ra) # 360 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 55e:	0992                	slli	s3,s3,0x4
 560:	397d                	addiw	s2,s2,-1
 562:	fe0914e3          	bnez	s2,54a <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 566:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 56a:	4981                	li	s3,0
 56c:	b70d                	j	48e <vprintf+0x60>
        s = va_arg(ap, char*);
 56e:	008b0913          	addi	s2,s6,8
 572:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 576:	02098163          	beqz	s3,598 <vprintf+0x16a>
        while(*s != 0){
 57a:	0009c583          	lbu	a1,0(s3)
 57e:	c5ad                	beqz	a1,5e8 <vprintf+0x1ba>
          putc(fd, *s);
 580:	8556                	mv	a0,s5
 582:	00000097          	auipc	ra,0x0
 586:	dde080e7          	jalr	-546(ra) # 360 <putc>
          s++;
 58a:	0985                	addi	s3,s3,1
        while(*s != 0){
 58c:	0009c583          	lbu	a1,0(s3)
 590:	f9e5                	bnez	a1,580 <vprintf+0x152>
        s = va_arg(ap, char*);
 592:	8b4a                	mv	s6,s2
      state = 0;
 594:	4981                	li	s3,0
 596:	bde5                	j	48e <vprintf+0x60>
          s = "(null)";
 598:	00000997          	auipc	s3,0x0
 59c:	25898993          	addi	s3,s3,600 # 7f0 <malloc+0xfe>
        while(*s != 0){
 5a0:	85ee                	mv	a1,s11
 5a2:	bff9                	j	580 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 5a4:	008b0913          	addi	s2,s6,8
 5a8:	000b4583          	lbu	a1,0(s6)
 5ac:	8556                	mv	a0,s5
 5ae:	00000097          	auipc	ra,0x0
 5b2:	db2080e7          	jalr	-590(ra) # 360 <putc>
 5b6:	8b4a                	mv	s6,s2
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	bdd1                	j	48e <vprintf+0x60>
        putc(fd, c);
 5bc:	85d2                	mv	a1,s4
 5be:	8556                	mv	a0,s5
 5c0:	00000097          	auipc	ra,0x0
 5c4:	da0080e7          	jalr	-608(ra) # 360 <putc>
      state = 0;
 5c8:	4981                	li	s3,0
 5ca:	b5d1                	j	48e <vprintf+0x60>
        putc(fd, '%');
 5cc:	85d2                	mv	a1,s4
 5ce:	8556                	mv	a0,s5
 5d0:	00000097          	auipc	ra,0x0
 5d4:	d90080e7          	jalr	-624(ra) # 360 <putc>
        putc(fd, c);
 5d8:	85ca                	mv	a1,s2
 5da:	8556                	mv	a0,s5
 5dc:	00000097          	auipc	ra,0x0
 5e0:	d84080e7          	jalr	-636(ra) # 360 <putc>
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	b565                	j	48e <vprintf+0x60>
        s = va_arg(ap, char*);
 5e8:	8b4a                	mv	s6,s2
      state = 0;
 5ea:	4981                	li	s3,0
 5ec:	b54d                	j	48e <vprintf+0x60>
    }
  }
}
 5ee:	70e6                	ld	ra,120(sp)
 5f0:	7446                	ld	s0,112(sp)
 5f2:	74a6                	ld	s1,104(sp)
 5f4:	7906                	ld	s2,96(sp)
 5f6:	69e6                	ld	s3,88(sp)
 5f8:	6a46                	ld	s4,80(sp)
 5fa:	6aa6                	ld	s5,72(sp)
 5fc:	6b06                	ld	s6,64(sp)
 5fe:	7be2                	ld	s7,56(sp)
 600:	7c42                	ld	s8,48(sp)
 602:	7ca2                	ld	s9,40(sp)
 604:	7d02                	ld	s10,32(sp)
 606:	6de2                	ld	s11,24(sp)
 608:	6109                	addi	sp,sp,128
 60a:	8082                	ret

000000000000060c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 60c:	715d                	addi	sp,sp,-80
 60e:	ec06                	sd	ra,24(sp)
 610:	e822                	sd	s0,16(sp)
 612:	1000                	addi	s0,sp,32
 614:	e010                	sd	a2,0(s0)
 616:	e414                	sd	a3,8(s0)
 618:	e818                	sd	a4,16(s0)
 61a:	ec1c                	sd	a5,24(s0)
 61c:	03043023          	sd	a6,32(s0)
 620:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 624:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 628:	8622                	mv	a2,s0
 62a:	00000097          	auipc	ra,0x0
 62e:	e04080e7          	jalr	-508(ra) # 42e <vprintf>
}
 632:	60e2                	ld	ra,24(sp)
 634:	6442                	ld	s0,16(sp)
 636:	6161                	addi	sp,sp,80
 638:	8082                	ret

000000000000063a <printf>:

void
printf(const char *fmt, ...)
{
 63a:	711d                	addi	sp,sp,-96
 63c:	ec06                	sd	ra,24(sp)
 63e:	e822                	sd	s0,16(sp)
 640:	1000                	addi	s0,sp,32
 642:	e40c                	sd	a1,8(s0)
 644:	e810                	sd	a2,16(s0)
 646:	ec14                	sd	a3,24(s0)
 648:	f018                	sd	a4,32(s0)
 64a:	f41c                	sd	a5,40(s0)
 64c:	03043823          	sd	a6,48(s0)
 650:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 654:	00840613          	addi	a2,s0,8
 658:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 65c:	85aa                	mv	a1,a0
 65e:	4505                	li	a0,1
 660:	00000097          	auipc	ra,0x0
 664:	dce080e7          	jalr	-562(ra) # 42e <vprintf>
}
 668:	60e2                	ld	ra,24(sp)
 66a:	6442                	ld	s0,16(sp)
 66c:	6125                	addi	sp,sp,96
 66e:	8082                	ret

0000000000000670 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 670:	1141                	addi	sp,sp,-16
 672:	e422                	sd	s0,8(sp)
 674:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 676:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 67a:	00001797          	auipc	a5,0x1
 67e:	9867b783          	ld	a5,-1658(a5) # 1000 <freep>
 682:	a02d                	j	6ac <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 684:	4618                	lw	a4,8(a2)
 686:	9f2d                	addw	a4,a4,a1
 688:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 68c:	6398                	ld	a4,0(a5)
 68e:	6310                	ld	a2,0(a4)
 690:	a83d                	j	6ce <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 692:	ff852703          	lw	a4,-8(a0)
 696:	9f31                	addw	a4,a4,a2
 698:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 69a:	ff053683          	ld	a3,-16(a0)
 69e:	a091                	j	6e2 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a0:	6398                	ld	a4,0(a5)
 6a2:	00e7e463          	bltu	a5,a4,6aa <free+0x3a>
 6a6:	00e6ea63          	bltu	a3,a4,6ba <free+0x4a>
{
 6aa:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ac:	fed7fae3          	bgeu	a5,a3,6a0 <free+0x30>
 6b0:	6398                	ld	a4,0(a5)
 6b2:	00e6e463          	bltu	a3,a4,6ba <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b6:	fee7eae3          	bltu	a5,a4,6aa <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6ba:	ff852583          	lw	a1,-8(a0)
 6be:	6390                	ld	a2,0(a5)
 6c0:	02059813          	slli	a6,a1,0x20
 6c4:	01c85713          	srli	a4,a6,0x1c
 6c8:	9736                	add	a4,a4,a3
 6ca:	fae60de3          	beq	a2,a4,684 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6ce:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6d2:	4790                	lw	a2,8(a5)
 6d4:	02061593          	slli	a1,a2,0x20
 6d8:	01c5d713          	srli	a4,a1,0x1c
 6dc:	973e                	add	a4,a4,a5
 6de:	fae68ae3          	beq	a3,a4,692 <free+0x22>
    p->s.ptr = bp->s.ptr;
 6e2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6e4:	00001717          	auipc	a4,0x1
 6e8:	90f73e23          	sd	a5,-1764(a4) # 1000 <freep>
}
 6ec:	6422                	ld	s0,8(sp)
 6ee:	0141                	addi	sp,sp,16
 6f0:	8082                	ret

00000000000006f2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6f2:	7139                	addi	sp,sp,-64
 6f4:	fc06                	sd	ra,56(sp)
 6f6:	f822                	sd	s0,48(sp)
 6f8:	f426                	sd	s1,40(sp)
 6fa:	f04a                	sd	s2,32(sp)
 6fc:	ec4e                	sd	s3,24(sp)
 6fe:	e852                	sd	s4,16(sp)
 700:	e456                	sd	s5,8(sp)
 702:	e05a                	sd	s6,0(sp)
 704:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 706:	02051493          	slli	s1,a0,0x20
 70a:	9081                	srli	s1,s1,0x20
 70c:	04bd                	addi	s1,s1,15
 70e:	8091                	srli	s1,s1,0x4
 710:	0014899b          	addiw	s3,s1,1
 714:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 716:	00001517          	auipc	a0,0x1
 71a:	8ea53503          	ld	a0,-1814(a0) # 1000 <freep>
 71e:	c515                	beqz	a0,74a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 720:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 722:	4798                	lw	a4,8(a5)
 724:	02977f63          	bgeu	a4,s1,762 <malloc+0x70>
 728:	8a4e                	mv	s4,s3
 72a:	0009871b          	sext.w	a4,s3
 72e:	6685                	lui	a3,0x1
 730:	00d77363          	bgeu	a4,a3,736 <malloc+0x44>
 734:	6a05                	lui	s4,0x1
 736:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 73a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 73e:	00001917          	auipc	s2,0x1
 742:	8c290913          	addi	s2,s2,-1854 # 1000 <freep>
  if(p == (char*)-1)
 746:	5afd                	li	s5,-1
 748:	a895                	j	7bc <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 74a:	00001797          	auipc	a5,0x1
 74e:	8c678793          	addi	a5,a5,-1850 # 1010 <base>
 752:	00001717          	auipc	a4,0x1
 756:	8af73723          	sd	a5,-1874(a4) # 1000 <freep>
 75a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 75c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 760:	b7e1                	j	728 <malloc+0x36>
      if(p->s.size == nunits)
 762:	02e48c63          	beq	s1,a4,79a <malloc+0xa8>
        p->s.size -= nunits;
 766:	4137073b          	subw	a4,a4,s3
 76a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 76c:	02071693          	slli	a3,a4,0x20
 770:	01c6d713          	srli	a4,a3,0x1c
 774:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 776:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 77a:	00001717          	auipc	a4,0x1
 77e:	88a73323          	sd	a0,-1914(a4) # 1000 <freep>
      return (void*)(p + 1);
 782:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 786:	70e2                	ld	ra,56(sp)
 788:	7442                	ld	s0,48(sp)
 78a:	74a2                	ld	s1,40(sp)
 78c:	7902                	ld	s2,32(sp)
 78e:	69e2                	ld	s3,24(sp)
 790:	6a42                	ld	s4,16(sp)
 792:	6aa2                	ld	s5,8(sp)
 794:	6b02                	ld	s6,0(sp)
 796:	6121                	addi	sp,sp,64
 798:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 79a:	6398                	ld	a4,0(a5)
 79c:	e118                	sd	a4,0(a0)
 79e:	bff1                	j	77a <malloc+0x88>
  hp->s.size = nu;
 7a0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7a4:	0541                	addi	a0,a0,16
 7a6:	00000097          	auipc	ra,0x0
 7aa:	eca080e7          	jalr	-310(ra) # 670 <free>
  return freep;
 7ae:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7b2:	d971                	beqz	a0,786 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7b6:	4798                	lw	a4,8(a5)
 7b8:	fa9775e3          	bgeu	a4,s1,762 <malloc+0x70>
    if(p == freep)
 7bc:	00093703          	ld	a4,0(s2)
 7c0:	853e                	mv	a0,a5
 7c2:	fef719e3          	bne	a4,a5,7b4 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7c6:	8552                	mv	a0,s4
 7c8:	00000097          	auipc	ra,0x0
 7cc:	b80080e7          	jalr	-1152(ra) # 348 <sbrk>
  if(p == (char*)-1)
 7d0:	fd5518e3          	bne	a0,s5,7a0 <malloc+0xae>
        return 0;
 7d4:	4501                	li	a0,0
 7d6:	bf45                	j	786 <malloc+0x94>
