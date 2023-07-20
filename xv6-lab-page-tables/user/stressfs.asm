
user/_stressfs：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	addi	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  16:	00001797          	auipc	a5,0x1
  1a:	8ea78793          	addi	a5,a5,-1814 # 900 <malloc+0x116>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
  30:	8a450513          	addi	a0,a0,-1884 # 8d0 <malloc+0xe6>
  34:	00000097          	auipc	ra,0x0
  38:	6fe080e7          	jalr	1790(ra) # 732 <printf>
  memset(data, 'a', sizeof(data));
  3c:	20000613          	li	a2,512
  40:	06100593          	li	a1,97
  44:	dd040513          	addi	a0,s0,-560
  48:	00000097          	auipc	ra,0x0
  4c:	150080e7          	jalr	336(ra) # 198 <memset>

  for(i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if(fork() > 0)
  54:	00000097          	auipc	ra,0x0
  58:	34c080e7          	jalr	844(ra) # 3a0 <fork>
  5c:	00a04563          	bgtz	a0,66 <main+0x66>
  for(i = 0; i < 4; i++)
  60:	2485                	addiw	s1,s1,1
  62:	ff2499e3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  66:	85a6                	mv	a1,s1
  68:	00001517          	auipc	a0,0x1
  6c:	88050513          	addi	a0,a0,-1920 # 8e8 <malloc+0xfe>
  70:	00000097          	auipc	ra,0x0
  74:	6c2080e7          	jalr	1730(ra) # 732 <printf>

  path[8] += i;
  78:	fd844783          	lbu	a5,-40(s0)
  7c:	9fa5                	addw	a5,a5,s1
  7e:	fcf40c23          	sb	a5,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  82:	20200593          	li	a1,514
  86:	fd040513          	addi	a0,s0,-48
  8a:	00000097          	auipc	ra,0x0
  8e:	35e080e7          	jalr	862(ra) # 3e8 <open>
  92:	892a                	mv	s2,a0
  94:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  96:	20000613          	li	a2,512
  9a:	dd040593          	addi	a1,s0,-560
  9e:	854a                	mv	a0,s2
  a0:	00000097          	auipc	ra,0x0
  a4:	328080e7          	jalr	808(ra) # 3c8 <write>
  for(i = 0; i < 20; i++)
  a8:	34fd                	addiw	s1,s1,-1
  aa:	f4f5                	bnez	s1,96 <main+0x96>
  close(fd);
  ac:	854a                	mv	a0,s2
  ae:	00000097          	auipc	ra,0x0
  b2:	322080e7          	jalr	802(ra) # 3d0 <close>

  printf("read\n");
  b6:	00001517          	auipc	a0,0x1
  ba:	84250513          	addi	a0,a0,-1982 # 8f8 <malloc+0x10e>
  be:	00000097          	auipc	ra,0x0
  c2:	674080e7          	jalr	1652(ra) # 732 <printf>

  fd = open(path, O_RDONLY);
  c6:	4581                	li	a1,0
  c8:	fd040513          	addi	a0,s0,-48
  cc:	00000097          	auipc	ra,0x0
  d0:	31c080e7          	jalr	796(ra) # 3e8 <open>
  d4:	892a                	mv	s2,a0
  d6:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  d8:	20000613          	li	a2,512
  dc:	dd040593          	addi	a1,s0,-560
  e0:	854a                	mv	a0,s2
  e2:	00000097          	auipc	ra,0x0
  e6:	2de080e7          	jalr	734(ra) # 3c0 <read>
  for (i = 0; i < 20; i++)
  ea:	34fd                	addiw	s1,s1,-1
  ec:	f4f5                	bnez	s1,d8 <main+0xd8>
  close(fd);
  ee:	854a                	mv	a0,s2
  f0:	00000097          	auipc	ra,0x0
  f4:	2e0080e7          	jalr	736(ra) # 3d0 <close>

  wait(0);
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	2b6080e7          	jalr	694(ra) # 3b0 <wait>

  exit(0);
 102:	4501                	li	a0,0
 104:	00000097          	auipc	ra,0x0
 108:	2a4080e7          	jalr	676(ra) # 3a8 <exit>

000000000000010c <_main>:

//
// wrapper so that it's OK if main() does not call exit().
//
void _main()
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e406                	sd	ra,8(sp)
 110:	e022                	sd	s0,0(sp)
 112:	0800                	addi	s0,sp,16
    extern int main();
    main();
 114:	00000097          	auipc	ra,0x0
 118:	eec080e7          	jalr	-276(ra) # 0 <main>
    exit(0);
 11c:	4501                	li	a0,0
 11e:	00000097          	auipc	ra,0x0
 122:	28a080e7          	jalr	650(ra) # 3a8 <exit>

0000000000000126 <strcpy>:
}

char *strcpy(char *s, const char *t)
{
 126:	1141                	addi	sp,sp,-16
 128:	e422                	sd	s0,8(sp)
 12a:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 12c:	87aa                	mv	a5,a0
 12e:	0585                	addi	a1,a1,1
 130:	0785                	addi	a5,a5,1
 132:	fff5c703          	lbu	a4,-1(a1)
 136:	fee78fa3          	sb	a4,-1(a5)
 13a:	fb75                	bnez	a4,12e <strcpy+0x8>
        ;
    return os;
}
 13c:	6422                	ld	s0,8(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret

0000000000000142 <strcmp>:

int strcmp(const char *p, const char *q)
{
 142:	1141                	addi	sp,sp,-16
 144:	e422                	sd	s0,8(sp)
 146:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 148:	00054783          	lbu	a5,0(a0)
 14c:	cb91                	beqz	a5,160 <strcmp+0x1e>
 14e:	0005c703          	lbu	a4,0(a1)
 152:	00f71763          	bne	a4,a5,160 <strcmp+0x1e>
        p++, q++;
 156:	0505                	addi	a0,a0,1
 158:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 15a:	00054783          	lbu	a5,0(a0)
 15e:	fbe5                	bnez	a5,14e <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 160:	0005c503          	lbu	a0,0(a1)
}
 164:	40a7853b          	subw	a0,a5,a0
 168:	6422                	ld	s0,8(sp)
 16a:	0141                	addi	sp,sp,16
 16c:	8082                	ret

000000000000016e <strlen>:

uint strlen(const char *s)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e422                	sd	s0,8(sp)
 172:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 174:	00054783          	lbu	a5,0(a0)
 178:	cf91                	beqz	a5,194 <strlen+0x26>
 17a:	0505                	addi	a0,a0,1
 17c:	87aa                	mv	a5,a0
 17e:	4685                	li	a3,1
 180:	9e89                	subw	a3,a3,a0
 182:	00f6853b          	addw	a0,a3,a5
 186:	0785                	addi	a5,a5,1
 188:	fff7c703          	lbu	a4,-1(a5)
 18c:	fb7d                	bnez	a4,182 <strlen+0x14>
        ;
    return n;
}
 18e:	6422                	ld	s0,8(sp)
 190:	0141                	addi	sp,sp,16
 192:	8082                	ret
    for (n = 0; s[n]; n++)
 194:	4501                	li	a0,0
 196:	bfe5                	j	18e <strlen+0x20>

0000000000000198 <memset>:

void *memset(void *dst, int c, uint n)
{
 198:	1141                	addi	sp,sp,-16
 19a:	e422                	sd	s0,8(sp)
 19c:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++) {
 19e:	ca19                	beqz	a2,1b4 <memset+0x1c>
 1a0:	87aa                	mv	a5,a0
 1a2:	1602                	slli	a2,a2,0x20
 1a4:	9201                	srli	a2,a2,0x20
 1a6:	00a60733          	add	a4,a2,a0
        cdst[i] = c;
 1aa:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++) {
 1ae:	0785                	addi	a5,a5,1
 1b0:	fee79de3          	bne	a5,a4,1aa <memset+0x12>
    }
    return dst;
}
 1b4:	6422                	ld	s0,8(sp)
 1b6:	0141                	addi	sp,sp,16
 1b8:	8082                	ret

00000000000001ba <strchr>:

char *strchr(const char *s, char c)
{
 1ba:	1141                	addi	sp,sp,-16
 1bc:	e422                	sd	s0,8(sp)
 1be:	0800                	addi	s0,sp,16
    for (; *s; s++)
 1c0:	00054783          	lbu	a5,0(a0)
 1c4:	cb99                	beqz	a5,1da <strchr+0x20>
        if (*s == c)
 1c6:	00f58763          	beq	a1,a5,1d4 <strchr+0x1a>
    for (; *s; s++)
 1ca:	0505                	addi	a0,a0,1
 1cc:	00054783          	lbu	a5,0(a0)
 1d0:	fbfd                	bnez	a5,1c6 <strchr+0xc>
            return (char *)s;
    return 0;
 1d2:	4501                	li	a0,0
}
 1d4:	6422                	ld	s0,8(sp)
 1d6:	0141                	addi	sp,sp,16
 1d8:	8082                	ret
    return 0;
 1da:	4501                	li	a0,0
 1dc:	bfe5                	j	1d4 <strchr+0x1a>

00000000000001de <gets>:

char *gets(char *buf, int max)
{
 1de:	711d                	addi	sp,sp,-96
 1e0:	ec86                	sd	ra,88(sp)
 1e2:	e8a2                	sd	s0,80(sp)
 1e4:	e4a6                	sd	s1,72(sp)
 1e6:	e0ca                	sd	s2,64(sp)
 1e8:	fc4e                	sd	s3,56(sp)
 1ea:	f852                	sd	s4,48(sp)
 1ec:	f456                	sd	s5,40(sp)
 1ee:	f05a                	sd	s6,32(sp)
 1f0:	ec5e                	sd	s7,24(sp)
 1f2:	1080                	addi	s0,sp,96
 1f4:	8baa                	mv	s7,a0
 1f6:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;) {
 1f8:	892a                	mv	s2,a0
 1fa:	4481                	li	s1,0
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 1fc:	4aa9                	li	s5,10
 1fe:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;) {
 200:	89a6                	mv	s3,s1
 202:	2485                	addiw	s1,s1,1
 204:	0344d863          	bge	s1,s4,234 <gets+0x56>
        cc = read(0, &c, 1);
 208:	4605                	li	a2,1
 20a:	faf40593          	addi	a1,s0,-81
 20e:	4501                	li	a0,0
 210:	00000097          	auipc	ra,0x0
 214:	1b0080e7          	jalr	432(ra) # 3c0 <read>
        if (cc < 1)
 218:	00a05e63          	blez	a0,234 <gets+0x56>
        buf[i++] = c;
 21c:	faf44783          	lbu	a5,-81(s0)
 220:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 224:	01578763          	beq	a5,s5,232 <gets+0x54>
 228:	0905                	addi	s2,s2,1
 22a:	fd679be3          	bne	a5,s6,200 <gets+0x22>
    for (i = 0; i + 1 < max;) {
 22e:	89a6                	mv	s3,s1
 230:	a011                	j	234 <gets+0x56>
 232:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 234:	99de                	add	s3,s3,s7
 236:	00098023          	sb	zero,0(s3)
    return buf;
}
 23a:	855e                	mv	a0,s7
 23c:	60e6                	ld	ra,88(sp)
 23e:	6446                	ld	s0,80(sp)
 240:	64a6                	ld	s1,72(sp)
 242:	6906                	ld	s2,64(sp)
 244:	79e2                	ld	s3,56(sp)
 246:	7a42                	ld	s4,48(sp)
 248:	7aa2                	ld	s5,40(sp)
 24a:	7b02                	ld	s6,32(sp)
 24c:	6be2                	ld	s7,24(sp)
 24e:	6125                	addi	sp,sp,96
 250:	8082                	ret

0000000000000252 <stat>:

int stat(const char *n, struct stat *st)
{
 252:	1101                	addi	sp,sp,-32
 254:	ec06                	sd	ra,24(sp)
 256:	e822                	sd	s0,16(sp)
 258:	e426                	sd	s1,8(sp)
 25a:	e04a                	sd	s2,0(sp)
 25c:	1000                	addi	s0,sp,32
 25e:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 260:	4581                	li	a1,0
 262:	00000097          	auipc	ra,0x0
 266:	186080e7          	jalr	390(ra) # 3e8 <open>
    if (fd < 0)
 26a:	02054563          	bltz	a0,294 <stat+0x42>
 26e:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 270:	85ca                	mv	a1,s2
 272:	00000097          	auipc	ra,0x0
 276:	18e080e7          	jalr	398(ra) # 400 <fstat>
 27a:	892a                	mv	s2,a0
    close(fd);
 27c:	8526                	mv	a0,s1
 27e:	00000097          	auipc	ra,0x0
 282:	152080e7          	jalr	338(ra) # 3d0 <close>
    return r;
}
 286:	854a                	mv	a0,s2
 288:	60e2                	ld	ra,24(sp)
 28a:	6442                	ld	s0,16(sp)
 28c:	64a2                	ld	s1,8(sp)
 28e:	6902                	ld	s2,0(sp)
 290:	6105                	addi	sp,sp,32
 292:	8082                	ret
        return -1;
 294:	597d                	li	s2,-1
 296:	bfc5                	j	286 <stat+0x34>

0000000000000298 <atoi>:

int atoi(const char *s)
{
 298:	1141                	addi	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 29e:	00054683          	lbu	a3,0(a0)
 2a2:	fd06879b          	addiw	a5,a3,-48
 2a6:	0ff7f793          	zext.b	a5,a5
 2aa:	4625                	li	a2,9
 2ac:	02f66863          	bltu	a2,a5,2dc <atoi+0x44>
 2b0:	872a                	mv	a4,a0
    n = 0;
 2b2:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
 2b4:	0705                	addi	a4,a4,1
 2b6:	0025179b          	slliw	a5,a0,0x2
 2ba:	9fa9                	addw	a5,a5,a0
 2bc:	0017979b          	slliw	a5,a5,0x1
 2c0:	9fb5                	addw	a5,a5,a3
 2c2:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 2c6:	00074683          	lbu	a3,0(a4)
 2ca:	fd06879b          	addiw	a5,a3,-48
 2ce:	0ff7f793          	zext.b	a5,a5
 2d2:	fef671e3          	bgeu	a2,a5,2b4 <atoi+0x1c>
    return n;
}
 2d6:	6422                	ld	s0,8(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret
    n = 0;
 2dc:	4501                	li	a0,0
 2de:	bfe5                	j	2d6 <atoi+0x3e>

00000000000002e0 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n)
{
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e422                	sd	s0,8(sp)
 2e4:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst) {
 2e6:	02b57463          	bgeu	a0,a1,30e <memmove+0x2e>
        while (n-- > 0)
 2ea:	00c05f63          	blez	a2,308 <memmove+0x28>
 2ee:	1602                	slli	a2,a2,0x20
 2f0:	9201                	srli	a2,a2,0x20
 2f2:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 2f6:	872a                	mv	a4,a0
            *dst++ = *src++;
 2f8:	0585                	addi	a1,a1,1
 2fa:	0705                	addi	a4,a4,1
 2fc:	fff5c683          	lbu	a3,-1(a1)
 300:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 304:	fee79ae3          	bne	a5,a4,2f8 <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 308:	6422                	ld	s0,8(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret
        dst += n;
 30e:	00c50733          	add	a4,a0,a2
        src += n;
 312:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 314:	fec05ae3          	blez	a2,308 <memmove+0x28>
 318:	fff6079b          	addiw	a5,a2,-1
 31c:	1782                	slli	a5,a5,0x20
 31e:	9381                	srli	a5,a5,0x20
 320:	fff7c793          	not	a5,a5
 324:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 326:	15fd                	addi	a1,a1,-1
 328:	177d                	addi	a4,a4,-1
 32a:	0005c683          	lbu	a3,0(a1)
 32e:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 332:	fee79ae3          	bne	a5,a4,326 <memmove+0x46>
 336:	bfc9                	j	308 <memmove+0x28>

0000000000000338 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 338:	1141                	addi	sp,sp,-16
 33a:	e422                	sd	s0,8(sp)
 33c:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0) {
 33e:	ca05                	beqz	a2,36e <memcmp+0x36>
 340:	fff6069b          	addiw	a3,a2,-1
 344:	1682                	slli	a3,a3,0x20
 346:	9281                	srli	a3,a3,0x20
 348:	0685                	addi	a3,a3,1
 34a:	96aa                	add	a3,a3,a0
        if (*p1 != *p2) {
 34c:	00054783          	lbu	a5,0(a0)
 350:	0005c703          	lbu	a4,0(a1)
 354:	00e79863          	bne	a5,a4,364 <memcmp+0x2c>
            return *p1 - *p2;
        }
        p1++;
 358:	0505                	addi	a0,a0,1
        p2++;
 35a:	0585                	addi	a1,a1,1
    while (n-- > 0) {
 35c:	fed518e3          	bne	a0,a3,34c <memcmp+0x14>
    }
    return 0;
 360:	4501                	li	a0,0
 362:	a019                	j	368 <memcmp+0x30>
            return *p1 - *p2;
 364:	40e7853b          	subw	a0,a5,a4
}
 368:	6422                	ld	s0,8(sp)
 36a:	0141                	addi	sp,sp,16
 36c:	8082                	ret
    return 0;
 36e:	4501                	li	a0,0
 370:	bfe5                	j	368 <memcmp+0x30>

0000000000000372 <memcpy>:

void *memcpy(void *dst, const void *src, uint n)
{
 372:	1141                	addi	sp,sp,-16
 374:	e406                	sd	ra,8(sp)
 376:	e022                	sd	s0,0(sp)
 378:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 37a:	00000097          	auipc	ra,0x0
 37e:	f66080e7          	jalr	-154(ra) # 2e0 <memmove>
}
 382:	60a2                	ld	ra,8(sp)
 384:	6402                	ld	s0,0(sp)
 386:	0141                	addi	sp,sp,16
 388:	8082                	ret

000000000000038a <ugetpid>:

#ifdef LAB_PGTBL
int ugetpid(void)
{
 38a:	1141                	addi	sp,sp,-16
 38c:	e422                	sd	s0,8(sp)
 38e:	0800                	addi	s0,sp,16
    struct usyscall *u = (struct usyscall *)USYSCALL;
    return u->pid;
 390:	040007b7          	lui	a5,0x4000
}
 394:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ffefed>
 396:	07b2                	slli	a5,a5,0xc
 398:	4388                	lw	a0,0(a5)
 39a:	6422                	ld	s0,8(sp)
 39c:	0141                	addi	sp,sp,16
 39e:	8082                	ret

00000000000003a0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a0:	4885                	li	a7,1
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3a8:	4889                	li	a7,2
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b0:	488d                	li	a7,3
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3b8:	4891                	li	a7,4
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <read>:
.global read
read:
 li a7, SYS_read
 3c0:	4895                	li	a7,5
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <write>:
.global write
write:
 li a7, SYS_write
 3c8:	48c1                	li	a7,16
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <close>:
.global close
close:
 li a7, SYS_close
 3d0:	48d5                	li	a7,21
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3d8:	4899                	li	a7,6
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e0:	489d                	li	a7,7
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <open>:
.global open
open:
 li a7, SYS_open
 3e8:	48bd                	li	a7,15
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f0:	48c5                	li	a7,17
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3f8:	48c9                	li	a7,18
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 400:	48a1                	li	a7,8
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <link>:
.global link
link:
 li a7, SYS_link
 408:	48cd                	li	a7,19
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 410:	48d1                	li	a7,20
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 418:	48a5                	li	a7,9
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <dup>:
.global dup
dup:
 li a7, SYS_dup
 420:	48a9                	li	a7,10
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 428:	48ad                	li	a7,11
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 430:	48b1                	li	a7,12
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 438:	48b5                	li	a7,13
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 440:	48b9                	li	a7,14
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <connect>:
.global connect
connect:
 li a7, SYS_connect
 448:	48f5                	li	a7,29
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 450:	48f9                	li	a7,30
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 458:	1101                	addi	sp,sp,-32
 45a:	ec06                	sd	ra,24(sp)
 45c:	e822                	sd	s0,16(sp)
 45e:	1000                	addi	s0,sp,32
 460:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 464:	4605                	li	a2,1
 466:	fef40593          	addi	a1,s0,-17
 46a:	00000097          	auipc	ra,0x0
 46e:	f5e080e7          	jalr	-162(ra) # 3c8 <write>
}
 472:	60e2                	ld	ra,24(sp)
 474:	6442                	ld	s0,16(sp)
 476:	6105                	addi	sp,sp,32
 478:	8082                	ret

000000000000047a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 47a:	7139                	addi	sp,sp,-64
 47c:	fc06                	sd	ra,56(sp)
 47e:	f822                	sd	s0,48(sp)
 480:	f426                	sd	s1,40(sp)
 482:	f04a                	sd	s2,32(sp)
 484:	ec4e                	sd	s3,24(sp)
 486:	0080                	addi	s0,sp,64
 488:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 48a:	c299                	beqz	a3,490 <printint+0x16>
 48c:	0805c963          	bltz	a1,51e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 490:	2581                	sext.w	a1,a1
  neg = 0;
 492:	4881                	li	a7,0
 494:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 498:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 49a:	2601                	sext.w	a2,a2
 49c:	00000517          	auipc	a0,0x0
 4a0:	4d450513          	addi	a0,a0,1236 # 970 <digits>
 4a4:	883a                	mv	a6,a4
 4a6:	2705                	addiw	a4,a4,1
 4a8:	02c5f7bb          	remuw	a5,a1,a2
 4ac:	1782                	slli	a5,a5,0x20
 4ae:	9381                	srli	a5,a5,0x20
 4b0:	97aa                	add	a5,a5,a0
 4b2:	0007c783          	lbu	a5,0(a5)
 4b6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4ba:	0005879b          	sext.w	a5,a1
 4be:	02c5d5bb          	divuw	a1,a1,a2
 4c2:	0685                	addi	a3,a3,1
 4c4:	fec7f0e3          	bgeu	a5,a2,4a4 <printint+0x2a>
  if(neg)
 4c8:	00088c63          	beqz	a7,4e0 <printint+0x66>
    buf[i++] = '-';
 4cc:	fd070793          	addi	a5,a4,-48
 4d0:	00878733          	add	a4,a5,s0
 4d4:	02d00793          	li	a5,45
 4d8:	fef70823          	sb	a5,-16(a4)
 4dc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4e0:	02e05863          	blez	a4,510 <printint+0x96>
 4e4:	fc040793          	addi	a5,s0,-64
 4e8:	00e78933          	add	s2,a5,a4
 4ec:	fff78993          	addi	s3,a5,-1
 4f0:	99ba                	add	s3,s3,a4
 4f2:	377d                	addiw	a4,a4,-1
 4f4:	1702                	slli	a4,a4,0x20
 4f6:	9301                	srli	a4,a4,0x20
 4f8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4fc:	fff94583          	lbu	a1,-1(s2)
 500:	8526                	mv	a0,s1
 502:	00000097          	auipc	ra,0x0
 506:	f56080e7          	jalr	-170(ra) # 458 <putc>
  while(--i >= 0)
 50a:	197d                	addi	s2,s2,-1
 50c:	ff3918e3          	bne	s2,s3,4fc <printint+0x82>
}
 510:	70e2                	ld	ra,56(sp)
 512:	7442                	ld	s0,48(sp)
 514:	74a2                	ld	s1,40(sp)
 516:	7902                	ld	s2,32(sp)
 518:	69e2                	ld	s3,24(sp)
 51a:	6121                	addi	sp,sp,64
 51c:	8082                	ret
    x = -xx;
 51e:	40b005bb          	negw	a1,a1
    neg = 1;
 522:	4885                	li	a7,1
    x = -xx;
 524:	bf85                	j	494 <printint+0x1a>

0000000000000526 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 526:	7119                	addi	sp,sp,-128
 528:	fc86                	sd	ra,120(sp)
 52a:	f8a2                	sd	s0,112(sp)
 52c:	f4a6                	sd	s1,104(sp)
 52e:	f0ca                	sd	s2,96(sp)
 530:	ecce                	sd	s3,88(sp)
 532:	e8d2                	sd	s4,80(sp)
 534:	e4d6                	sd	s5,72(sp)
 536:	e0da                	sd	s6,64(sp)
 538:	fc5e                	sd	s7,56(sp)
 53a:	f862                	sd	s8,48(sp)
 53c:	f466                	sd	s9,40(sp)
 53e:	f06a                	sd	s10,32(sp)
 540:	ec6e                	sd	s11,24(sp)
 542:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 544:	0005c903          	lbu	s2,0(a1)
 548:	18090f63          	beqz	s2,6e6 <vprintf+0x1c0>
 54c:	8aaa                	mv	s5,a0
 54e:	8b32                	mv	s6,a2
 550:	00158493          	addi	s1,a1,1
  state = 0;
 554:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 556:	02500a13          	li	s4,37
 55a:	4c55                	li	s8,21
 55c:	00000c97          	auipc	s9,0x0
 560:	3bcc8c93          	addi	s9,s9,956 # 918 <malloc+0x12e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 564:	02800d93          	li	s11,40
  putc(fd, 'x');
 568:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 56a:	00000b97          	auipc	s7,0x0
 56e:	406b8b93          	addi	s7,s7,1030 # 970 <digits>
 572:	a839                	j	590 <vprintf+0x6a>
        putc(fd, c);
 574:	85ca                	mv	a1,s2
 576:	8556                	mv	a0,s5
 578:	00000097          	auipc	ra,0x0
 57c:	ee0080e7          	jalr	-288(ra) # 458 <putc>
 580:	a019                	j	586 <vprintf+0x60>
    } else if(state == '%'){
 582:	01498d63          	beq	s3,s4,59c <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 586:	0485                	addi	s1,s1,1
 588:	fff4c903          	lbu	s2,-1(s1)
 58c:	14090d63          	beqz	s2,6e6 <vprintf+0x1c0>
    if(state == 0){
 590:	fe0999e3          	bnez	s3,582 <vprintf+0x5c>
      if(c == '%'){
 594:	ff4910e3          	bne	s2,s4,574 <vprintf+0x4e>
        state = '%';
 598:	89d2                	mv	s3,s4
 59a:	b7f5                	j	586 <vprintf+0x60>
      if(c == 'd'){
 59c:	11490c63          	beq	s2,s4,6b4 <vprintf+0x18e>
 5a0:	f9d9079b          	addiw	a5,s2,-99
 5a4:	0ff7f793          	zext.b	a5,a5
 5a8:	10fc6e63          	bltu	s8,a5,6c4 <vprintf+0x19e>
 5ac:	f9d9079b          	addiw	a5,s2,-99
 5b0:	0ff7f713          	zext.b	a4,a5
 5b4:	10ec6863          	bltu	s8,a4,6c4 <vprintf+0x19e>
 5b8:	00271793          	slli	a5,a4,0x2
 5bc:	97e6                	add	a5,a5,s9
 5be:	439c                	lw	a5,0(a5)
 5c0:	97e6                	add	a5,a5,s9
 5c2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5c4:	008b0913          	addi	s2,s6,8
 5c8:	4685                	li	a3,1
 5ca:	4629                	li	a2,10
 5cc:	000b2583          	lw	a1,0(s6)
 5d0:	8556                	mv	a0,s5
 5d2:	00000097          	auipc	ra,0x0
 5d6:	ea8080e7          	jalr	-344(ra) # 47a <printint>
 5da:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	b765                	j	586 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e0:	008b0913          	addi	s2,s6,8
 5e4:	4681                	li	a3,0
 5e6:	4629                	li	a2,10
 5e8:	000b2583          	lw	a1,0(s6)
 5ec:	8556                	mv	a0,s5
 5ee:	00000097          	auipc	ra,0x0
 5f2:	e8c080e7          	jalr	-372(ra) # 47a <printint>
 5f6:	8b4a                	mv	s6,s2
      state = 0;
 5f8:	4981                	li	s3,0
 5fa:	b771                	j	586 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5fc:	008b0913          	addi	s2,s6,8
 600:	4681                	li	a3,0
 602:	866a                	mv	a2,s10
 604:	000b2583          	lw	a1,0(s6)
 608:	8556                	mv	a0,s5
 60a:	00000097          	auipc	ra,0x0
 60e:	e70080e7          	jalr	-400(ra) # 47a <printint>
 612:	8b4a                	mv	s6,s2
      state = 0;
 614:	4981                	li	s3,0
 616:	bf85                	j	586 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 618:	008b0793          	addi	a5,s6,8
 61c:	f8f43423          	sd	a5,-120(s0)
 620:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 624:	03000593          	li	a1,48
 628:	8556                	mv	a0,s5
 62a:	00000097          	auipc	ra,0x0
 62e:	e2e080e7          	jalr	-466(ra) # 458 <putc>
  putc(fd, 'x');
 632:	07800593          	li	a1,120
 636:	8556                	mv	a0,s5
 638:	00000097          	auipc	ra,0x0
 63c:	e20080e7          	jalr	-480(ra) # 458 <putc>
 640:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 642:	03c9d793          	srli	a5,s3,0x3c
 646:	97de                	add	a5,a5,s7
 648:	0007c583          	lbu	a1,0(a5)
 64c:	8556                	mv	a0,s5
 64e:	00000097          	auipc	ra,0x0
 652:	e0a080e7          	jalr	-502(ra) # 458 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 656:	0992                	slli	s3,s3,0x4
 658:	397d                	addiw	s2,s2,-1
 65a:	fe0914e3          	bnez	s2,642 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 65e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 662:	4981                	li	s3,0
 664:	b70d                	j	586 <vprintf+0x60>
        s = va_arg(ap, char*);
 666:	008b0913          	addi	s2,s6,8
 66a:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 66e:	02098163          	beqz	s3,690 <vprintf+0x16a>
        while(*s != 0){
 672:	0009c583          	lbu	a1,0(s3)
 676:	c5ad                	beqz	a1,6e0 <vprintf+0x1ba>
          putc(fd, *s);
 678:	8556                	mv	a0,s5
 67a:	00000097          	auipc	ra,0x0
 67e:	dde080e7          	jalr	-546(ra) # 458 <putc>
          s++;
 682:	0985                	addi	s3,s3,1
        while(*s != 0){
 684:	0009c583          	lbu	a1,0(s3)
 688:	f9e5                	bnez	a1,678 <vprintf+0x152>
        s = va_arg(ap, char*);
 68a:	8b4a                	mv	s6,s2
      state = 0;
 68c:	4981                	li	s3,0
 68e:	bde5                	j	586 <vprintf+0x60>
          s = "(null)";
 690:	00000997          	auipc	s3,0x0
 694:	28098993          	addi	s3,s3,640 # 910 <malloc+0x126>
        while(*s != 0){
 698:	85ee                	mv	a1,s11
 69a:	bff9                	j	678 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 69c:	008b0913          	addi	s2,s6,8
 6a0:	000b4583          	lbu	a1,0(s6)
 6a4:	8556                	mv	a0,s5
 6a6:	00000097          	auipc	ra,0x0
 6aa:	db2080e7          	jalr	-590(ra) # 458 <putc>
 6ae:	8b4a                	mv	s6,s2
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	bdd1                	j	586 <vprintf+0x60>
        putc(fd, c);
 6b4:	85d2                	mv	a1,s4
 6b6:	8556                	mv	a0,s5
 6b8:	00000097          	auipc	ra,0x0
 6bc:	da0080e7          	jalr	-608(ra) # 458 <putc>
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	b5d1                	j	586 <vprintf+0x60>
        putc(fd, '%');
 6c4:	85d2                	mv	a1,s4
 6c6:	8556                	mv	a0,s5
 6c8:	00000097          	auipc	ra,0x0
 6cc:	d90080e7          	jalr	-624(ra) # 458 <putc>
        putc(fd, c);
 6d0:	85ca                	mv	a1,s2
 6d2:	8556                	mv	a0,s5
 6d4:	00000097          	auipc	ra,0x0
 6d8:	d84080e7          	jalr	-636(ra) # 458 <putc>
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	b565                	j	586 <vprintf+0x60>
        s = va_arg(ap, char*);
 6e0:	8b4a                	mv	s6,s2
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	b54d                	j	586 <vprintf+0x60>
    }
  }
}
 6e6:	70e6                	ld	ra,120(sp)
 6e8:	7446                	ld	s0,112(sp)
 6ea:	74a6                	ld	s1,104(sp)
 6ec:	7906                	ld	s2,96(sp)
 6ee:	69e6                	ld	s3,88(sp)
 6f0:	6a46                	ld	s4,80(sp)
 6f2:	6aa6                	ld	s5,72(sp)
 6f4:	6b06                	ld	s6,64(sp)
 6f6:	7be2                	ld	s7,56(sp)
 6f8:	7c42                	ld	s8,48(sp)
 6fa:	7ca2                	ld	s9,40(sp)
 6fc:	7d02                	ld	s10,32(sp)
 6fe:	6de2                	ld	s11,24(sp)
 700:	6109                	addi	sp,sp,128
 702:	8082                	ret

0000000000000704 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 704:	715d                	addi	sp,sp,-80
 706:	ec06                	sd	ra,24(sp)
 708:	e822                	sd	s0,16(sp)
 70a:	1000                	addi	s0,sp,32
 70c:	e010                	sd	a2,0(s0)
 70e:	e414                	sd	a3,8(s0)
 710:	e818                	sd	a4,16(s0)
 712:	ec1c                	sd	a5,24(s0)
 714:	03043023          	sd	a6,32(s0)
 718:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 71c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 720:	8622                	mv	a2,s0
 722:	00000097          	auipc	ra,0x0
 726:	e04080e7          	jalr	-508(ra) # 526 <vprintf>
}
 72a:	60e2                	ld	ra,24(sp)
 72c:	6442                	ld	s0,16(sp)
 72e:	6161                	addi	sp,sp,80
 730:	8082                	ret

0000000000000732 <printf>:

void
printf(const char *fmt, ...)
{
 732:	711d                	addi	sp,sp,-96
 734:	ec06                	sd	ra,24(sp)
 736:	e822                	sd	s0,16(sp)
 738:	1000                	addi	s0,sp,32
 73a:	e40c                	sd	a1,8(s0)
 73c:	e810                	sd	a2,16(s0)
 73e:	ec14                	sd	a3,24(s0)
 740:	f018                	sd	a4,32(s0)
 742:	f41c                	sd	a5,40(s0)
 744:	03043823          	sd	a6,48(s0)
 748:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 74c:	00840613          	addi	a2,s0,8
 750:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 754:	85aa                	mv	a1,a0
 756:	4505                	li	a0,1
 758:	00000097          	auipc	ra,0x0
 75c:	dce080e7          	jalr	-562(ra) # 526 <vprintf>
}
 760:	60e2                	ld	ra,24(sp)
 762:	6442                	ld	s0,16(sp)
 764:	6125                	addi	sp,sp,96
 766:	8082                	ret

0000000000000768 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 768:	1141                	addi	sp,sp,-16
 76a:	e422                	sd	s0,8(sp)
 76c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 76e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 772:	00001797          	auipc	a5,0x1
 776:	88e7b783          	ld	a5,-1906(a5) # 1000 <freep>
 77a:	a02d                	j	7a4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 77c:	4618                	lw	a4,8(a2)
 77e:	9f2d                	addw	a4,a4,a1
 780:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 784:	6398                	ld	a4,0(a5)
 786:	6310                	ld	a2,0(a4)
 788:	a83d                	j	7c6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 78a:	ff852703          	lw	a4,-8(a0)
 78e:	9f31                	addw	a4,a4,a2
 790:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 792:	ff053683          	ld	a3,-16(a0)
 796:	a091                	j	7da <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 798:	6398                	ld	a4,0(a5)
 79a:	00e7e463          	bltu	a5,a4,7a2 <free+0x3a>
 79e:	00e6ea63          	bltu	a3,a4,7b2 <free+0x4a>
{
 7a2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a4:	fed7fae3          	bgeu	a5,a3,798 <free+0x30>
 7a8:	6398                	ld	a4,0(a5)
 7aa:	00e6e463          	bltu	a3,a4,7b2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ae:	fee7eae3          	bltu	a5,a4,7a2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7b2:	ff852583          	lw	a1,-8(a0)
 7b6:	6390                	ld	a2,0(a5)
 7b8:	02059813          	slli	a6,a1,0x20
 7bc:	01c85713          	srli	a4,a6,0x1c
 7c0:	9736                	add	a4,a4,a3
 7c2:	fae60de3          	beq	a2,a4,77c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7c6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7ca:	4790                	lw	a2,8(a5)
 7cc:	02061593          	slli	a1,a2,0x20
 7d0:	01c5d713          	srli	a4,a1,0x1c
 7d4:	973e                	add	a4,a4,a5
 7d6:	fae68ae3          	beq	a3,a4,78a <free+0x22>
    p->s.ptr = bp->s.ptr;
 7da:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7dc:	00001717          	auipc	a4,0x1
 7e0:	82f73223          	sd	a5,-2012(a4) # 1000 <freep>
}
 7e4:	6422                	ld	s0,8(sp)
 7e6:	0141                	addi	sp,sp,16
 7e8:	8082                	ret

00000000000007ea <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7ea:	7139                	addi	sp,sp,-64
 7ec:	fc06                	sd	ra,56(sp)
 7ee:	f822                	sd	s0,48(sp)
 7f0:	f426                	sd	s1,40(sp)
 7f2:	f04a                	sd	s2,32(sp)
 7f4:	ec4e                	sd	s3,24(sp)
 7f6:	e852                	sd	s4,16(sp)
 7f8:	e456                	sd	s5,8(sp)
 7fa:	e05a                	sd	s6,0(sp)
 7fc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7fe:	02051493          	slli	s1,a0,0x20
 802:	9081                	srli	s1,s1,0x20
 804:	04bd                	addi	s1,s1,15
 806:	8091                	srli	s1,s1,0x4
 808:	0014899b          	addiw	s3,s1,1
 80c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 80e:	00000517          	auipc	a0,0x0
 812:	7f253503          	ld	a0,2034(a0) # 1000 <freep>
 816:	c515                	beqz	a0,842 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 818:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 81a:	4798                	lw	a4,8(a5)
 81c:	02977f63          	bgeu	a4,s1,85a <malloc+0x70>
 820:	8a4e                	mv	s4,s3
 822:	0009871b          	sext.w	a4,s3
 826:	6685                	lui	a3,0x1
 828:	00d77363          	bgeu	a4,a3,82e <malloc+0x44>
 82c:	6a05                	lui	s4,0x1
 82e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 832:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 836:	00000917          	auipc	s2,0x0
 83a:	7ca90913          	addi	s2,s2,1994 # 1000 <freep>
  if(p == (char*)-1)
 83e:	5afd                	li	s5,-1
 840:	a895                	j	8b4 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 842:	00000797          	auipc	a5,0x0
 846:	7ce78793          	addi	a5,a5,1998 # 1010 <base>
 84a:	00000717          	auipc	a4,0x0
 84e:	7af73b23          	sd	a5,1974(a4) # 1000 <freep>
 852:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 854:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 858:	b7e1                	j	820 <malloc+0x36>
      if(p->s.size == nunits)
 85a:	02e48c63          	beq	s1,a4,892 <malloc+0xa8>
        p->s.size -= nunits;
 85e:	4137073b          	subw	a4,a4,s3
 862:	c798                	sw	a4,8(a5)
        p += p->s.size;
 864:	02071693          	slli	a3,a4,0x20
 868:	01c6d713          	srli	a4,a3,0x1c
 86c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 86e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 872:	00000717          	auipc	a4,0x0
 876:	78a73723          	sd	a0,1934(a4) # 1000 <freep>
      return (void*)(p + 1);
 87a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 87e:	70e2                	ld	ra,56(sp)
 880:	7442                	ld	s0,48(sp)
 882:	74a2                	ld	s1,40(sp)
 884:	7902                	ld	s2,32(sp)
 886:	69e2                	ld	s3,24(sp)
 888:	6a42                	ld	s4,16(sp)
 88a:	6aa2                	ld	s5,8(sp)
 88c:	6b02                	ld	s6,0(sp)
 88e:	6121                	addi	sp,sp,64
 890:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 892:	6398                	ld	a4,0(a5)
 894:	e118                	sd	a4,0(a0)
 896:	bff1                	j	872 <malloc+0x88>
  hp->s.size = nu;
 898:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 89c:	0541                	addi	a0,a0,16
 89e:	00000097          	auipc	ra,0x0
 8a2:	eca080e7          	jalr	-310(ra) # 768 <free>
  return freep;
 8a6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8aa:	d971                	beqz	a0,87e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ac:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ae:	4798                	lw	a4,8(a5)
 8b0:	fa9775e3          	bgeu	a4,s1,85a <malloc+0x70>
    if(p == freep)
 8b4:	00093703          	ld	a4,0(s2)
 8b8:	853e                	mv	a0,a5
 8ba:	fef719e3          	bne	a4,a5,8ac <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8be:	8552                	mv	a0,s4
 8c0:	00000097          	auipc	ra,0x0
 8c4:	b70080e7          	jalr	-1168(ra) # 430 <sbrk>
  if(p == (char*)-1)
 8c8:	fd5518e3          	bne	a0,s5,898 <malloc+0xae>
        return 0;
 8cc:	4501                	li	a0,0
 8ce:	bf45                	j	87e <malloc+0x94>
