
user/_pingpong：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48

    if (argc > 1) {
   8:	4785                	li	a5,1
   a:	02a7d063          	bge	a5,a0,2a <main+0x2a>
        fprintf(2, "No 1 argument is needed!\n");
   e:	00001597          	auipc	a1,0x1
  12:	9e258593          	addi	a1,a1,-1566 # 9f0 <malloc+0xe6>
  16:	4509                	li	a0,2
  18:	00001097          	auipc	ra,0x1
  1c:	80c080e7          	jalr	-2036(ra) # 824 <fprintf>
        exit(1);
  20:	4505                	li	a0,1
  22:	00000097          	auipc	ra,0x0
  26:	4b6080e7          	jalr	1206(ra) # 4d8 <exit>
    }

    int p_to_c[2], c_to_p[2];
    char buf[10];

    if (pipe(p_to_c) < 0) {
  2a:	fe840513          	addi	a0,s0,-24
  2e:	00000097          	auipc	ra,0x0
  32:	4ba080e7          	jalr	1210(ra) # 4e8 <pipe>
  36:	0c054063          	bltz	a0,f6 <main+0xf6>
        printf("pipe create failed\n");
        exit(1);
    }

    if (pipe(c_to_p) < 0) {
  3a:	fe040513          	addi	a0,s0,-32
  3e:	00000097          	auipc	ra,0x0
  42:	4aa080e7          	jalr	1194(ra) # 4e8 <pipe>
  46:	0c054563          	bltz	a0,110 <main+0x110>
        printf("pipe create failed\n");
        exit(1);
    }

    int pid;
    pid = fork();
  4a:	00000097          	auipc	ra,0x0
  4e:	486080e7          	jalr	1158(ra) # 4d0 <fork>

    if (pid < 0) {
  52:	0c054c63          	bltz	a0,12a <main+0x12a>
        printf("fork failed\n");
        exit(1);
    }

    if (pid == 0) {
  56:	12051163          	bnez	a0,178 <main+0x178>
        // 子进程
        close(c_to_p[0]);
  5a:	fe042503          	lw	a0,-32(s0)
  5e:	00000097          	auipc	ra,0x0
  62:	4a2080e7          	jalr	1186(ra) # 500 <close>
        close(p_to_c[1]);
  66:	fec42503          	lw	a0,-20(s0)
  6a:	00000097          	auipc	ra,0x0
  6e:	496080e7          	jalr	1174(ra) # 500 <close>
        // 从管道读取字节
        if (read(p_to_c[0], buf, 4) == -1) {
  72:	4611                	li	a2,4
  74:	fd040593          	addi	a1,s0,-48
  78:	fe842503          	lw	a0,-24(s0)
  7c:	00000097          	auipc	ra,0x0
  80:	474080e7          	jalr	1140(ra) # 4f0 <read>
  84:	57fd                	li	a5,-1
  86:	0af50f63          	beq	a0,a5,144 <main+0x144>
            printf("child process read failed\n");
            exit(1);
        }
        close(p_to_c[0]);
  8a:	fe842503          	lw	a0,-24(s0)
  8e:	00000097          	auipc	ra,0x0
  92:	472080e7          	jalr	1138(ra) # 500 <close>

        printf("%d: received %s\n", getpid(), buf);
  96:	00000097          	auipc	ra,0x0
  9a:	4c2080e7          	jalr	1218(ra) # 558 <getpid>
  9e:	85aa                	mv	a1,a0
  a0:	fd040613          	addi	a2,s0,-48
  a4:	00001517          	auipc	a0,0x1
  a8:	9b450513          	addi	a0,a0,-1612 # a58 <malloc+0x14e>
  ac:	00000097          	auipc	ra,0x0
  b0:	7a6080e7          	jalr	1958(ra) # 852 <printf>

        strcpy(buf, "pong");
  b4:	00001597          	auipc	a1,0x1
  b8:	9bc58593          	addi	a1,a1,-1604 # a70 <malloc+0x166>
  bc:	fd040513          	addi	a0,s0,-48
  c0:	00000097          	auipc	ra,0x0
  c4:	1ac080e7          	jalr	428(ra) # 26c <strcpy>
        // 向管道发送字节
        if (write(c_to_p[1], buf, 4) == -1) {
  c8:	4611                	li	a2,4
  ca:	fd040593          	addi	a1,s0,-48
  ce:	fe442503          	lw	a0,-28(s0)
  d2:	00000097          	auipc	ra,0x0
  d6:	426080e7          	jalr	1062(ra) # 4f8 <write>
  da:	57fd                	li	a5,-1
  dc:	08f50163          	beq	a0,a5,15e <main+0x15e>
            printf("child process write failed\n");
            exit(1);
        }
        close(c_to_p[1]);
  e0:	fe442503          	lw	a0,-28(s0)
  e4:	00000097          	auipc	ra,0x0
  e8:	41c080e7          	jalr	1052(ra) # 500 <close>
        exit(0);
  ec:	4501                	li	a0,0
  ee:	00000097          	auipc	ra,0x0
  f2:	3ea080e7          	jalr	1002(ra) # 4d8 <exit>
        printf("pipe create failed\n");
  f6:	00001517          	auipc	a0,0x1
  fa:	91a50513          	addi	a0,a0,-1766 # a10 <malloc+0x106>
  fe:	00000097          	auipc	ra,0x0
 102:	754080e7          	jalr	1876(ra) # 852 <printf>
        exit(1);
 106:	4505                	li	a0,1
 108:	00000097          	auipc	ra,0x0
 10c:	3d0080e7          	jalr	976(ra) # 4d8 <exit>
        printf("pipe create failed\n");
 110:	00001517          	auipc	a0,0x1
 114:	90050513          	addi	a0,a0,-1792 # a10 <malloc+0x106>
 118:	00000097          	auipc	ra,0x0
 11c:	73a080e7          	jalr	1850(ra) # 852 <printf>
        exit(1);
 120:	4505                	li	a0,1
 122:	00000097          	auipc	ra,0x0
 126:	3b6080e7          	jalr	950(ra) # 4d8 <exit>
        printf("fork failed\n");
 12a:	00001517          	auipc	a0,0x1
 12e:	8fe50513          	addi	a0,a0,-1794 # a28 <malloc+0x11e>
 132:	00000097          	auipc	ra,0x0
 136:	720080e7          	jalr	1824(ra) # 852 <printf>
        exit(1);
 13a:	4505                	li	a0,1
 13c:	00000097          	auipc	ra,0x0
 140:	39c080e7          	jalr	924(ra) # 4d8 <exit>
            printf("child process read failed\n");
 144:	00001517          	auipc	a0,0x1
 148:	8f450513          	addi	a0,a0,-1804 # a38 <malloc+0x12e>
 14c:	00000097          	auipc	ra,0x0
 150:	706080e7          	jalr	1798(ra) # 852 <printf>
            exit(1);
 154:	4505                	li	a0,1
 156:	00000097          	auipc	ra,0x0
 15a:	382080e7          	jalr	898(ra) # 4d8 <exit>
            printf("child process write failed\n");
 15e:	00001517          	auipc	a0,0x1
 162:	91a50513          	addi	a0,a0,-1766 # a78 <malloc+0x16e>
 166:	00000097          	auipc	ra,0x0
 16a:	6ec080e7          	jalr	1772(ra) # 852 <printf>
            exit(1);
 16e:	4505                	li	a0,1
 170:	00000097          	auipc	ra,0x0
 174:	368080e7          	jalr	872(ra) # 4d8 <exit>
    }
    else {
        strcpy(buf, "ping");
 178:	00001597          	auipc	a1,0x1
 17c:	92058593          	addi	a1,a1,-1760 # a98 <malloc+0x18e>
 180:	fd040513          	addi	a0,s0,-48
 184:	00000097          	auipc	ra,0x0
 188:	0e8080e7          	jalr	232(ra) # 26c <strcpy>
        // 父进程
        close(c_to_p[1]);
 18c:	fe442503          	lw	a0,-28(s0)
 190:	00000097          	auipc	ra,0x0
 194:	370080e7          	jalr	880(ra) # 500 <close>
        close(p_to_c[0]);
 198:	fe842503          	lw	a0,-24(s0)
 19c:	00000097          	auipc	ra,0x0
 1a0:	364080e7          	jalr	868(ra) # 500 <close>
        // 向管道发送字节
        if (write(p_to_c[1], buf, 4) == -1) {
 1a4:	4611                	li	a2,4
 1a6:	fd040593          	addi	a1,s0,-48
 1aa:	fec42503          	lw	a0,-20(s0)
 1ae:	00000097          	auipc	ra,0x0
 1b2:	34a080e7          	jalr	842(ra) # 4f8 <write>
 1b6:	57fd                	li	a5,-1
 1b8:	06f50363          	beq	a0,a5,21e <main+0x21e>
            printf("parent process write failed\n");
            exit(1);
        }

        // 等待子进程结束
        wait(0);
 1bc:	4501                	li	a0,0
 1be:	00000097          	auipc	ra,0x0
 1c2:	322080e7          	jalr	802(ra) # 4e0 <wait>

        close(p_to_c[1]);
 1c6:	fec42503          	lw	a0,-20(s0)
 1ca:	00000097          	auipc	ra,0x0
 1ce:	336080e7          	jalr	822(ra) # 500 <close>
        // 从管道读取字节
        if (read(c_to_p[0], buf, 4) == -1) {
 1d2:	4611                	li	a2,4
 1d4:	fd040593          	addi	a1,s0,-48
 1d8:	fe042503          	lw	a0,-32(s0)
 1dc:	00000097          	auipc	ra,0x0
 1e0:	314080e7          	jalr	788(ra) # 4f0 <read>
 1e4:	57fd                	li	a5,-1
 1e6:	04f50963          	beq	a0,a5,238 <main+0x238>
            printf("parent process read failed\n");
            exit(1);
        }

        close(c_to_p[0]);
 1ea:	fe042503          	lw	a0,-32(s0)
 1ee:	00000097          	auipc	ra,0x0
 1f2:	312080e7          	jalr	786(ra) # 500 <close>
        printf("%d: received %s\n", getpid(), buf);
 1f6:	00000097          	auipc	ra,0x0
 1fa:	362080e7          	jalr	866(ra) # 558 <getpid>
 1fe:	85aa                	mv	a1,a0
 200:	fd040613          	addi	a2,s0,-48
 204:	00001517          	auipc	a0,0x1
 208:	85450513          	addi	a0,a0,-1964 # a58 <malloc+0x14e>
 20c:	00000097          	auipc	ra,0x0
 210:	646080e7          	jalr	1606(ra) # 852 <printf>

        exit(0);
 214:	4501                	li	a0,0
 216:	00000097          	auipc	ra,0x0
 21a:	2c2080e7          	jalr	706(ra) # 4d8 <exit>
            printf("parent process write failed\n");
 21e:	00001517          	auipc	a0,0x1
 222:	88250513          	addi	a0,a0,-1918 # aa0 <malloc+0x196>
 226:	00000097          	auipc	ra,0x0
 22a:	62c080e7          	jalr	1580(ra) # 852 <printf>
            exit(1);
 22e:	4505                	li	a0,1
 230:	00000097          	auipc	ra,0x0
 234:	2a8080e7          	jalr	680(ra) # 4d8 <exit>
            printf("parent process read failed\n");
 238:	00001517          	auipc	a0,0x1
 23c:	88850513          	addi	a0,a0,-1912 # ac0 <malloc+0x1b6>
 240:	00000097          	auipc	ra,0x0
 244:	612080e7          	jalr	1554(ra) # 852 <printf>
            exit(1);
 248:	4505                	li	a0,1
 24a:	00000097          	auipc	ra,0x0
 24e:	28e080e7          	jalr	654(ra) # 4d8 <exit>

0000000000000252 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 252:	1141                	addi	sp,sp,-16
 254:	e406                	sd	ra,8(sp)
 256:	e022                	sd	s0,0(sp)
 258:	0800                	addi	s0,sp,16
  extern int main();
  main();
 25a:	00000097          	auipc	ra,0x0
 25e:	da6080e7          	jalr	-602(ra) # 0 <main>
  exit(0);
 262:	4501                	li	a0,0
 264:	00000097          	auipc	ra,0x0
 268:	274080e7          	jalr	628(ra) # 4d8 <exit>

000000000000026c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e422                	sd	s0,8(sp)
 270:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 272:	87aa                	mv	a5,a0
 274:	0585                	addi	a1,a1,1
 276:	0785                	addi	a5,a5,1
 278:	fff5c703          	lbu	a4,-1(a1)
 27c:	fee78fa3          	sb	a4,-1(a5)
 280:	fb75                	bnez	a4,274 <strcpy+0x8>
    ;
  return os;
}
 282:	6422                	ld	s0,8(sp)
 284:	0141                	addi	sp,sp,16
 286:	8082                	ret

0000000000000288 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 288:	1141                	addi	sp,sp,-16
 28a:	e422                	sd	s0,8(sp)
 28c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 28e:	00054783          	lbu	a5,0(a0)
 292:	cb91                	beqz	a5,2a6 <strcmp+0x1e>
 294:	0005c703          	lbu	a4,0(a1)
 298:	00f71763          	bne	a4,a5,2a6 <strcmp+0x1e>
    p++, q++;
 29c:	0505                	addi	a0,a0,1
 29e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2a0:	00054783          	lbu	a5,0(a0)
 2a4:	fbe5                	bnez	a5,294 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2a6:	0005c503          	lbu	a0,0(a1)
}
 2aa:	40a7853b          	subw	a0,a5,a0
 2ae:	6422                	ld	s0,8(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret

00000000000002b4 <strlen>:

uint
strlen(const char *s)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e422                	sd	s0,8(sp)
 2b8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2ba:	00054783          	lbu	a5,0(a0)
 2be:	cf91                	beqz	a5,2da <strlen+0x26>
 2c0:	0505                	addi	a0,a0,1
 2c2:	87aa                	mv	a5,a0
 2c4:	4685                	li	a3,1
 2c6:	9e89                	subw	a3,a3,a0
 2c8:	00f6853b          	addw	a0,a3,a5
 2cc:	0785                	addi	a5,a5,1
 2ce:	fff7c703          	lbu	a4,-1(a5)
 2d2:	fb7d                	bnez	a4,2c8 <strlen+0x14>
    ;
  return n;
}
 2d4:	6422                	ld	s0,8(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
  for(n = 0; s[n]; n++)
 2da:	4501                	li	a0,0
 2dc:	bfe5                	j	2d4 <strlen+0x20>

00000000000002de <memset>:

void*
memset(void *dst, int c, uint n)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e422                	sd	s0,8(sp)
 2e2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2e4:	ca19                	beqz	a2,2fa <memset+0x1c>
 2e6:	87aa                	mv	a5,a0
 2e8:	1602                	slli	a2,a2,0x20
 2ea:	9201                	srli	a2,a2,0x20
 2ec:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2f0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2f4:	0785                	addi	a5,a5,1
 2f6:	fee79de3          	bne	a5,a4,2f0 <memset+0x12>
  }
  return dst;
}
 2fa:	6422                	ld	s0,8(sp)
 2fc:	0141                	addi	sp,sp,16
 2fe:	8082                	ret

0000000000000300 <strchr>:

char*
strchr(const char *s, char c)
{
 300:	1141                	addi	sp,sp,-16
 302:	e422                	sd	s0,8(sp)
 304:	0800                	addi	s0,sp,16
  for(; *s; s++)
 306:	00054783          	lbu	a5,0(a0)
 30a:	cb99                	beqz	a5,320 <strchr+0x20>
    if(*s == c)
 30c:	00f58763          	beq	a1,a5,31a <strchr+0x1a>
  for(; *s; s++)
 310:	0505                	addi	a0,a0,1
 312:	00054783          	lbu	a5,0(a0)
 316:	fbfd                	bnez	a5,30c <strchr+0xc>
      return (char*)s;
  return 0;
 318:	4501                	li	a0,0
}
 31a:	6422                	ld	s0,8(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret
  return 0;
 320:	4501                	li	a0,0
 322:	bfe5                	j	31a <strchr+0x1a>

0000000000000324 <gets>:

char*
gets(char *buf, int max)
{
 324:	711d                	addi	sp,sp,-96
 326:	ec86                	sd	ra,88(sp)
 328:	e8a2                	sd	s0,80(sp)
 32a:	e4a6                	sd	s1,72(sp)
 32c:	e0ca                	sd	s2,64(sp)
 32e:	fc4e                	sd	s3,56(sp)
 330:	f852                	sd	s4,48(sp)
 332:	f456                	sd	s5,40(sp)
 334:	f05a                	sd	s6,32(sp)
 336:	ec5e                	sd	s7,24(sp)
 338:	1080                	addi	s0,sp,96
 33a:	8baa                	mv	s7,a0
 33c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 33e:	892a                	mv	s2,a0
 340:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 342:	4aa9                	li	s5,10
 344:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 346:	89a6                	mv	s3,s1
 348:	2485                	addiw	s1,s1,1
 34a:	0344d863          	bge	s1,s4,37a <gets+0x56>
    cc = read(0, &c, 1);
 34e:	4605                	li	a2,1
 350:	faf40593          	addi	a1,s0,-81
 354:	4501                	li	a0,0
 356:	00000097          	auipc	ra,0x0
 35a:	19a080e7          	jalr	410(ra) # 4f0 <read>
    if(cc < 1)
 35e:	00a05e63          	blez	a0,37a <gets+0x56>
    buf[i++] = c;
 362:	faf44783          	lbu	a5,-81(s0)
 366:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 36a:	01578763          	beq	a5,s5,378 <gets+0x54>
 36e:	0905                	addi	s2,s2,1
 370:	fd679be3          	bne	a5,s6,346 <gets+0x22>
  for(i=0; i+1 < max; ){
 374:	89a6                	mv	s3,s1
 376:	a011                	j	37a <gets+0x56>
 378:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 37a:	99de                	add	s3,s3,s7
 37c:	00098023          	sb	zero,0(s3)
  return buf;
}
 380:	855e                	mv	a0,s7
 382:	60e6                	ld	ra,88(sp)
 384:	6446                	ld	s0,80(sp)
 386:	64a6                	ld	s1,72(sp)
 388:	6906                	ld	s2,64(sp)
 38a:	79e2                	ld	s3,56(sp)
 38c:	7a42                	ld	s4,48(sp)
 38e:	7aa2                	ld	s5,40(sp)
 390:	7b02                	ld	s6,32(sp)
 392:	6be2                	ld	s7,24(sp)
 394:	6125                	addi	sp,sp,96
 396:	8082                	ret

0000000000000398 <stat>:

int
stat(const char *n, struct stat *st)
{
 398:	1101                	addi	sp,sp,-32
 39a:	ec06                	sd	ra,24(sp)
 39c:	e822                	sd	s0,16(sp)
 39e:	e426                	sd	s1,8(sp)
 3a0:	e04a                	sd	s2,0(sp)
 3a2:	1000                	addi	s0,sp,32
 3a4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3a6:	4581                	li	a1,0
 3a8:	00000097          	auipc	ra,0x0
 3ac:	170080e7          	jalr	368(ra) # 518 <open>
  if(fd < 0)
 3b0:	02054563          	bltz	a0,3da <stat+0x42>
 3b4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3b6:	85ca                	mv	a1,s2
 3b8:	00000097          	auipc	ra,0x0
 3bc:	178080e7          	jalr	376(ra) # 530 <fstat>
 3c0:	892a                	mv	s2,a0
  close(fd);
 3c2:	8526                	mv	a0,s1
 3c4:	00000097          	auipc	ra,0x0
 3c8:	13c080e7          	jalr	316(ra) # 500 <close>
  return r;
}
 3cc:	854a                	mv	a0,s2
 3ce:	60e2                	ld	ra,24(sp)
 3d0:	6442                	ld	s0,16(sp)
 3d2:	64a2                	ld	s1,8(sp)
 3d4:	6902                	ld	s2,0(sp)
 3d6:	6105                	addi	sp,sp,32
 3d8:	8082                	ret
    return -1;
 3da:	597d                	li	s2,-1
 3dc:	bfc5                	j	3cc <stat+0x34>

00000000000003de <atoi>:

int
atoi(const char *s)
{
 3de:	1141                	addi	sp,sp,-16
 3e0:	e422                	sd	s0,8(sp)
 3e2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3e4:	00054683          	lbu	a3,0(a0)
 3e8:	fd06879b          	addiw	a5,a3,-48
 3ec:	0ff7f793          	zext.b	a5,a5
 3f0:	4625                	li	a2,9
 3f2:	02f66863          	bltu	a2,a5,422 <atoi+0x44>
 3f6:	872a                	mv	a4,a0
  n = 0;
 3f8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3fa:	0705                	addi	a4,a4,1
 3fc:	0025179b          	slliw	a5,a0,0x2
 400:	9fa9                	addw	a5,a5,a0
 402:	0017979b          	slliw	a5,a5,0x1
 406:	9fb5                	addw	a5,a5,a3
 408:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 40c:	00074683          	lbu	a3,0(a4)
 410:	fd06879b          	addiw	a5,a3,-48
 414:	0ff7f793          	zext.b	a5,a5
 418:	fef671e3          	bgeu	a2,a5,3fa <atoi+0x1c>
  return n;
}
 41c:	6422                	ld	s0,8(sp)
 41e:	0141                	addi	sp,sp,16
 420:	8082                	ret
  n = 0;
 422:	4501                	li	a0,0
 424:	bfe5                	j	41c <atoi+0x3e>

0000000000000426 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 426:	1141                	addi	sp,sp,-16
 428:	e422                	sd	s0,8(sp)
 42a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 42c:	02b57463          	bgeu	a0,a1,454 <memmove+0x2e>
    while(n-- > 0)
 430:	00c05f63          	blez	a2,44e <memmove+0x28>
 434:	1602                	slli	a2,a2,0x20
 436:	9201                	srli	a2,a2,0x20
 438:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 43c:	872a                	mv	a4,a0
      *dst++ = *src++;
 43e:	0585                	addi	a1,a1,1
 440:	0705                	addi	a4,a4,1
 442:	fff5c683          	lbu	a3,-1(a1)
 446:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 44a:	fee79ae3          	bne	a5,a4,43e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 44e:	6422                	ld	s0,8(sp)
 450:	0141                	addi	sp,sp,16
 452:	8082                	ret
    dst += n;
 454:	00c50733          	add	a4,a0,a2
    src += n;
 458:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 45a:	fec05ae3          	blez	a2,44e <memmove+0x28>
 45e:	fff6079b          	addiw	a5,a2,-1
 462:	1782                	slli	a5,a5,0x20
 464:	9381                	srli	a5,a5,0x20
 466:	fff7c793          	not	a5,a5
 46a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 46c:	15fd                	addi	a1,a1,-1
 46e:	177d                	addi	a4,a4,-1
 470:	0005c683          	lbu	a3,0(a1)
 474:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 478:	fee79ae3          	bne	a5,a4,46c <memmove+0x46>
 47c:	bfc9                	j	44e <memmove+0x28>

000000000000047e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 47e:	1141                	addi	sp,sp,-16
 480:	e422                	sd	s0,8(sp)
 482:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 484:	ca05                	beqz	a2,4b4 <memcmp+0x36>
 486:	fff6069b          	addiw	a3,a2,-1
 48a:	1682                	slli	a3,a3,0x20
 48c:	9281                	srli	a3,a3,0x20
 48e:	0685                	addi	a3,a3,1
 490:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 492:	00054783          	lbu	a5,0(a0)
 496:	0005c703          	lbu	a4,0(a1)
 49a:	00e79863          	bne	a5,a4,4aa <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 49e:	0505                	addi	a0,a0,1
    p2++;
 4a0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4a2:	fed518e3          	bne	a0,a3,492 <memcmp+0x14>
  }
  return 0;
 4a6:	4501                	li	a0,0
 4a8:	a019                	j	4ae <memcmp+0x30>
      return *p1 - *p2;
 4aa:	40e7853b          	subw	a0,a5,a4
}
 4ae:	6422                	ld	s0,8(sp)
 4b0:	0141                	addi	sp,sp,16
 4b2:	8082                	ret
  return 0;
 4b4:	4501                	li	a0,0
 4b6:	bfe5                	j	4ae <memcmp+0x30>

00000000000004b8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4b8:	1141                	addi	sp,sp,-16
 4ba:	e406                	sd	ra,8(sp)
 4bc:	e022                	sd	s0,0(sp)
 4be:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4c0:	00000097          	auipc	ra,0x0
 4c4:	f66080e7          	jalr	-154(ra) # 426 <memmove>
}
 4c8:	60a2                	ld	ra,8(sp)
 4ca:	6402                	ld	s0,0(sp)
 4cc:	0141                	addi	sp,sp,16
 4ce:	8082                	ret

00000000000004d0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4d0:	4885                	li	a7,1
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4d8:	4889                	li	a7,2
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4e0:	488d                	li	a7,3
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4e8:	4891                	li	a7,4
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <read>:
.global read
read:
 li a7, SYS_read
 4f0:	4895                	li	a7,5
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <write>:
.global write
write:
 li a7, SYS_write
 4f8:	48c1                	li	a7,16
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <close>:
.global close
close:
 li a7, SYS_close
 500:	48d5                	li	a7,21
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <kill>:
.global kill
kill:
 li a7, SYS_kill
 508:	4899                	li	a7,6
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <exec>:
.global exec
exec:
 li a7, SYS_exec
 510:	489d                	li	a7,7
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <open>:
.global open
open:
 li a7, SYS_open
 518:	48bd                	li	a7,15
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 520:	48c5                	li	a7,17
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 528:	48c9                	li	a7,18
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 530:	48a1                	li	a7,8
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <link>:
.global link
link:
 li a7, SYS_link
 538:	48cd                	li	a7,19
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 540:	48d1                	li	a7,20
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 548:	48a5                	li	a7,9
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <dup>:
.global dup
dup:
 li a7, SYS_dup
 550:	48a9                	li	a7,10
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 558:	48ad                	li	a7,11
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 560:	48b1                	li	a7,12
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 568:	48b5                	li	a7,13
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 570:	48b9                	li	a7,14
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 578:	1101                	addi	sp,sp,-32
 57a:	ec06                	sd	ra,24(sp)
 57c:	e822                	sd	s0,16(sp)
 57e:	1000                	addi	s0,sp,32
 580:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 584:	4605                	li	a2,1
 586:	fef40593          	addi	a1,s0,-17
 58a:	00000097          	auipc	ra,0x0
 58e:	f6e080e7          	jalr	-146(ra) # 4f8 <write>
}
 592:	60e2                	ld	ra,24(sp)
 594:	6442                	ld	s0,16(sp)
 596:	6105                	addi	sp,sp,32
 598:	8082                	ret

000000000000059a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 59a:	7139                	addi	sp,sp,-64
 59c:	fc06                	sd	ra,56(sp)
 59e:	f822                	sd	s0,48(sp)
 5a0:	f426                	sd	s1,40(sp)
 5a2:	f04a                	sd	s2,32(sp)
 5a4:	ec4e                	sd	s3,24(sp)
 5a6:	0080                	addi	s0,sp,64
 5a8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5aa:	c299                	beqz	a3,5b0 <printint+0x16>
 5ac:	0805c963          	bltz	a1,63e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5b0:	2581                	sext.w	a1,a1
  neg = 0;
 5b2:	4881                	li	a7,0
 5b4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5b8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5ba:	2601                	sext.w	a2,a2
 5bc:	00000517          	auipc	a0,0x0
 5c0:	58450513          	addi	a0,a0,1412 # b40 <digits>
 5c4:	883a                	mv	a6,a4
 5c6:	2705                	addiw	a4,a4,1
 5c8:	02c5f7bb          	remuw	a5,a1,a2
 5cc:	1782                	slli	a5,a5,0x20
 5ce:	9381                	srli	a5,a5,0x20
 5d0:	97aa                	add	a5,a5,a0
 5d2:	0007c783          	lbu	a5,0(a5)
 5d6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5da:	0005879b          	sext.w	a5,a1
 5de:	02c5d5bb          	divuw	a1,a1,a2
 5e2:	0685                	addi	a3,a3,1
 5e4:	fec7f0e3          	bgeu	a5,a2,5c4 <printint+0x2a>
  if(neg)
 5e8:	00088c63          	beqz	a7,600 <printint+0x66>
    buf[i++] = '-';
 5ec:	fd070793          	addi	a5,a4,-48
 5f0:	00878733          	add	a4,a5,s0
 5f4:	02d00793          	li	a5,45
 5f8:	fef70823          	sb	a5,-16(a4)
 5fc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 600:	02e05863          	blez	a4,630 <printint+0x96>
 604:	fc040793          	addi	a5,s0,-64
 608:	00e78933          	add	s2,a5,a4
 60c:	fff78993          	addi	s3,a5,-1
 610:	99ba                	add	s3,s3,a4
 612:	377d                	addiw	a4,a4,-1
 614:	1702                	slli	a4,a4,0x20
 616:	9301                	srli	a4,a4,0x20
 618:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 61c:	fff94583          	lbu	a1,-1(s2)
 620:	8526                	mv	a0,s1
 622:	00000097          	auipc	ra,0x0
 626:	f56080e7          	jalr	-170(ra) # 578 <putc>
  while(--i >= 0)
 62a:	197d                	addi	s2,s2,-1
 62c:	ff3918e3          	bne	s2,s3,61c <printint+0x82>
}
 630:	70e2                	ld	ra,56(sp)
 632:	7442                	ld	s0,48(sp)
 634:	74a2                	ld	s1,40(sp)
 636:	7902                	ld	s2,32(sp)
 638:	69e2                	ld	s3,24(sp)
 63a:	6121                	addi	sp,sp,64
 63c:	8082                	ret
    x = -xx;
 63e:	40b005bb          	negw	a1,a1
    neg = 1;
 642:	4885                	li	a7,1
    x = -xx;
 644:	bf85                	j	5b4 <printint+0x1a>

0000000000000646 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 646:	7119                	addi	sp,sp,-128
 648:	fc86                	sd	ra,120(sp)
 64a:	f8a2                	sd	s0,112(sp)
 64c:	f4a6                	sd	s1,104(sp)
 64e:	f0ca                	sd	s2,96(sp)
 650:	ecce                	sd	s3,88(sp)
 652:	e8d2                	sd	s4,80(sp)
 654:	e4d6                	sd	s5,72(sp)
 656:	e0da                	sd	s6,64(sp)
 658:	fc5e                	sd	s7,56(sp)
 65a:	f862                	sd	s8,48(sp)
 65c:	f466                	sd	s9,40(sp)
 65e:	f06a                	sd	s10,32(sp)
 660:	ec6e                	sd	s11,24(sp)
 662:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 664:	0005c903          	lbu	s2,0(a1)
 668:	18090f63          	beqz	s2,806 <vprintf+0x1c0>
 66c:	8aaa                	mv	s5,a0
 66e:	8b32                	mv	s6,a2
 670:	00158493          	addi	s1,a1,1
  state = 0;
 674:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 676:	02500a13          	li	s4,37
 67a:	4c55                	li	s8,21
 67c:	00000c97          	auipc	s9,0x0
 680:	46cc8c93          	addi	s9,s9,1132 # ae8 <malloc+0x1de>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 684:	02800d93          	li	s11,40
  putc(fd, 'x');
 688:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 68a:	00000b97          	auipc	s7,0x0
 68e:	4b6b8b93          	addi	s7,s7,1206 # b40 <digits>
 692:	a839                	j	6b0 <vprintf+0x6a>
        putc(fd, c);
 694:	85ca                	mv	a1,s2
 696:	8556                	mv	a0,s5
 698:	00000097          	auipc	ra,0x0
 69c:	ee0080e7          	jalr	-288(ra) # 578 <putc>
 6a0:	a019                	j	6a6 <vprintf+0x60>
    } else if(state == '%'){
 6a2:	01498d63          	beq	s3,s4,6bc <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 6a6:	0485                	addi	s1,s1,1
 6a8:	fff4c903          	lbu	s2,-1(s1)
 6ac:	14090d63          	beqz	s2,806 <vprintf+0x1c0>
    if(state == 0){
 6b0:	fe0999e3          	bnez	s3,6a2 <vprintf+0x5c>
      if(c == '%'){
 6b4:	ff4910e3          	bne	s2,s4,694 <vprintf+0x4e>
        state = '%';
 6b8:	89d2                	mv	s3,s4
 6ba:	b7f5                	j	6a6 <vprintf+0x60>
      if(c == 'd'){
 6bc:	11490c63          	beq	s2,s4,7d4 <vprintf+0x18e>
 6c0:	f9d9079b          	addiw	a5,s2,-99
 6c4:	0ff7f793          	zext.b	a5,a5
 6c8:	10fc6e63          	bltu	s8,a5,7e4 <vprintf+0x19e>
 6cc:	f9d9079b          	addiw	a5,s2,-99
 6d0:	0ff7f713          	zext.b	a4,a5
 6d4:	10ec6863          	bltu	s8,a4,7e4 <vprintf+0x19e>
 6d8:	00271793          	slli	a5,a4,0x2
 6dc:	97e6                	add	a5,a5,s9
 6de:	439c                	lw	a5,0(a5)
 6e0:	97e6                	add	a5,a5,s9
 6e2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6e4:	008b0913          	addi	s2,s6,8
 6e8:	4685                	li	a3,1
 6ea:	4629                	li	a2,10
 6ec:	000b2583          	lw	a1,0(s6)
 6f0:	8556                	mv	a0,s5
 6f2:	00000097          	auipc	ra,0x0
 6f6:	ea8080e7          	jalr	-344(ra) # 59a <printint>
 6fa:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	b765                	j	6a6 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 700:	008b0913          	addi	s2,s6,8
 704:	4681                	li	a3,0
 706:	4629                	li	a2,10
 708:	000b2583          	lw	a1,0(s6)
 70c:	8556                	mv	a0,s5
 70e:	00000097          	auipc	ra,0x0
 712:	e8c080e7          	jalr	-372(ra) # 59a <printint>
 716:	8b4a                	mv	s6,s2
      state = 0;
 718:	4981                	li	s3,0
 71a:	b771                	j	6a6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 71c:	008b0913          	addi	s2,s6,8
 720:	4681                	li	a3,0
 722:	866a                	mv	a2,s10
 724:	000b2583          	lw	a1,0(s6)
 728:	8556                	mv	a0,s5
 72a:	00000097          	auipc	ra,0x0
 72e:	e70080e7          	jalr	-400(ra) # 59a <printint>
 732:	8b4a                	mv	s6,s2
      state = 0;
 734:	4981                	li	s3,0
 736:	bf85                	j	6a6 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 738:	008b0793          	addi	a5,s6,8
 73c:	f8f43423          	sd	a5,-120(s0)
 740:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 744:	03000593          	li	a1,48
 748:	8556                	mv	a0,s5
 74a:	00000097          	auipc	ra,0x0
 74e:	e2e080e7          	jalr	-466(ra) # 578 <putc>
  putc(fd, 'x');
 752:	07800593          	li	a1,120
 756:	8556                	mv	a0,s5
 758:	00000097          	auipc	ra,0x0
 75c:	e20080e7          	jalr	-480(ra) # 578 <putc>
 760:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 762:	03c9d793          	srli	a5,s3,0x3c
 766:	97de                	add	a5,a5,s7
 768:	0007c583          	lbu	a1,0(a5)
 76c:	8556                	mv	a0,s5
 76e:	00000097          	auipc	ra,0x0
 772:	e0a080e7          	jalr	-502(ra) # 578 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 776:	0992                	slli	s3,s3,0x4
 778:	397d                	addiw	s2,s2,-1
 77a:	fe0914e3          	bnez	s2,762 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 77e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 782:	4981                	li	s3,0
 784:	b70d                	j	6a6 <vprintf+0x60>
        s = va_arg(ap, char*);
 786:	008b0913          	addi	s2,s6,8
 78a:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 78e:	02098163          	beqz	s3,7b0 <vprintf+0x16a>
        while(*s != 0){
 792:	0009c583          	lbu	a1,0(s3)
 796:	c5ad                	beqz	a1,800 <vprintf+0x1ba>
          putc(fd, *s);
 798:	8556                	mv	a0,s5
 79a:	00000097          	auipc	ra,0x0
 79e:	dde080e7          	jalr	-546(ra) # 578 <putc>
          s++;
 7a2:	0985                	addi	s3,s3,1
        while(*s != 0){
 7a4:	0009c583          	lbu	a1,0(s3)
 7a8:	f9e5                	bnez	a1,798 <vprintf+0x152>
        s = va_arg(ap, char*);
 7aa:	8b4a                	mv	s6,s2
      state = 0;
 7ac:	4981                	li	s3,0
 7ae:	bde5                	j	6a6 <vprintf+0x60>
          s = "(null)";
 7b0:	00000997          	auipc	s3,0x0
 7b4:	33098993          	addi	s3,s3,816 # ae0 <malloc+0x1d6>
        while(*s != 0){
 7b8:	85ee                	mv	a1,s11
 7ba:	bff9                	j	798 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 7bc:	008b0913          	addi	s2,s6,8
 7c0:	000b4583          	lbu	a1,0(s6)
 7c4:	8556                	mv	a0,s5
 7c6:	00000097          	auipc	ra,0x0
 7ca:	db2080e7          	jalr	-590(ra) # 578 <putc>
 7ce:	8b4a                	mv	s6,s2
      state = 0;
 7d0:	4981                	li	s3,0
 7d2:	bdd1                	j	6a6 <vprintf+0x60>
        putc(fd, c);
 7d4:	85d2                	mv	a1,s4
 7d6:	8556                	mv	a0,s5
 7d8:	00000097          	auipc	ra,0x0
 7dc:	da0080e7          	jalr	-608(ra) # 578 <putc>
      state = 0;
 7e0:	4981                	li	s3,0
 7e2:	b5d1                	j	6a6 <vprintf+0x60>
        putc(fd, '%');
 7e4:	85d2                	mv	a1,s4
 7e6:	8556                	mv	a0,s5
 7e8:	00000097          	auipc	ra,0x0
 7ec:	d90080e7          	jalr	-624(ra) # 578 <putc>
        putc(fd, c);
 7f0:	85ca                	mv	a1,s2
 7f2:	8556                	mv	a0,s5
 7f4:	00000097          	auipc	ra,0x0
 7f8:	d84080e7          	jalr	-636(ra) # 578 <putc>
      state = 0;
 7fc:	4981                	li	s3,0
 7fe:	b565                	j	6a6 <vprintf+0x60>
        s = va_arg(ap, char*);
 800:	8b4a                	mv	s6,s2
      state = 0;
 802:	4981                	li	s3,0
 804:	b54d                	j	6a6 <vprintf+0x60>
    }
  }
}
 806:	70e6                	ld	ra,120(sp)
 808:	7446                	ld	s0,112(sp)
 80a:	74a6                	ld	s1,104(sp)
 80c:	7906                	ld	s2,96(sp)
 80e:	69e6                	ld	s3,88(sp)
 810:	6a46                	ld	s4,80(sp)
 812:	6aa6                	ld	s5,72(sp)
 814:	6b06                	ld	s6,64(sp)
 816:	7be2                	ld	s7,56(sp)
 818:	7c42                	ld	s8,48(sp)
 81a:	7ca2                	ld	s9,40(sp)
 81c:	7d02                	ld	s10,32(sp)
 81e:	6de2                	ld	s11,24(sp)
 820:	6109                	addi	sp,sp,128
 822:	8082                	ret

0000000000000824 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 824:	715d                	addi	sp,sp,-80
 826:	ec06                	sd	ra,24(sp)
 828:	e822                	sd	s0,16(sp)
 82a:	1000                	addi	s0,sp,32
 82c:	e010                	sd	a2,0(s0)
 82e:	e414                	sd	a3,8(s0)
 830:	e818                	sd	a4,16(s0)
 832:	ec1c                	sd	a5,24(s0)
 834:	03043023          	sd	a6,32(s0)
 838:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 83c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 840:	8622                	mv	a2,s0
 842:	00000097          	auipc	ra,0x0
 846:	e04080e7          	jalr	-508(ra) # 646 <vprintf>
}
 84a:	60e2                	ld	ra,24(sp)
 84c:	6442                	ld	s0,16(sp)
 84e:	6161                	addi	sp,sp,80
 850:	8082                	ret

0000000000000852 <printf>:

void
printf(const char *fmt, ...)
{
 852:	711d                	addi	sp,sp,-96
 854:	ec06                	sd	ra,24(sp)
 856:	e822                	sd	s0,16(sp)
 858:	1000                	addi	s0,sp,32
 85a:	e40c                	sd	a1,8(s0)
 85c:	e810                	sd	a2,16(s0)
 85e:	ec14                	sd	a3,24(s0)
 860:	f018                	sd	a4,32(s0)
 862:	f41c                	sd	a5,40(s0)
 864:	03043823          	sd	a6,48(s0)
 868:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 86c:	00840613          	addi	a2,s0,8
 870:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 874:	85aa                	mv	a1,a0
 876:	4505                	li	a0,1
 878:	00000097          	auipc	ra,0x0
 87c:	dce080e7          	jalr	-562(ra) # 646 <vprintf>
}
 880:	60e2                	ld	ra,24(sp)
 882:	6442                	ld	s0,16(sp)
 884:	6125                	addi	sp,sp,96
 886:	8082                	ret

0000000000000888 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 888:	1141                	addi	sp,sp,-16
 88a:	e422                	sd	s0,8(sp)
 88c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 88e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 892:	00000797          	auipc	a5,0x0
 896:	76e7b783          	ld	a5,1902(a5) # 1000 <freep>
 89a:	a02d                	j	8c4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 89c:	4618                	lw	a4,8(a2)
 89e:	9f2d                	addw	a4,a4,a1
 8a0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8a4:	6398                	ld	a4,0(a5)
 8a6:	6310                	ld	a2,0(a4)
 8a8:	a83d                	j	8e6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8aa:	ff852703          	lw	a4,-8(a0)
 8ae:	9f31                	addw	a4,a4,a2
 8b0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8b2:	ff053683          	ld	a3,-16(a0)
 8b6:	a091                	j	8fa <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b8:	6398                	ld	a4,0(a5)
 8ba:	00e7e463          	bltu	a5,a4,8c2 <free+0x3a>
 8be:	00e6ea63          	bltu	a3,a4,8d2 <free+0x4a>
{
 8c2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c4:	fed7fae3          	bgeu	a5,a3,8b8 <free+0x30>
 8c8:	6398                	ld	a4,0(a5)
 8ca:	00e6e463          	bltu	a3,a4,8d2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ce:	fee7eae3          	bltu	a5,a4,8c2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8d2:	ff852583          	lw	a1,-8(a0)
 8d6:	6390                	ld	a2,0(a5)
 8d8:	02059813          	slli	a6,a1,0x20
 8dc:	01c85713          	srli	a4,a6,0x1c
 8e0:	9736                	add	a4,a4,a3
 8e2:	fae60de3          	beq	a2,a4,89c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8e6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8ea:	4790                	lw	a2,8(a5)
 8ec:	02061593          	slli	a1,a2,0x20
 8f0:	01c5d713          	srli	a4,a1,0x1c
 8f4:	973e                	add	a4,a4,a5
 8f6:	fae68ae3          	beq	a3,a4,8aa <free+0x22>
    p->s.ptr = bp->s.ptr;
 8fa:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8fc:	00000717          	auipc	a4,0x0
 900:	70f73223          	sd	a5,1796(a4) # 1000 <freep>
}
 904:	6422                	ld	s0,8(sp)
 906:	0141                	addi	sp,sp,16
 908:	8082                	ret

000000000000090a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 90a:	7139                	addi	sp,sp,-64
 90c:	fc06                	sd	ra,56(sp)
 90e:	f822                	sd	s0,48(sp)
 910:	f426                	sd	s1,40(sp)
 912:	f04a                	sd	s2,32(sp)
 914:	ec4e                	sd	s3,24(sp)
 916:	e852                	sd	s4,16(sp)
 918:	e456                	sd	s5,8(sp)
 91a:	e05a                	sd	s6,0(sp)
 91c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 91e:	02051493          	slli	s1,a0,0x20
 922:	9081                	srli	s1,s1,0x20
 924:	04bd                	addi	s1,s1,15
 926:	8091                	srli	s1,s1,0x4
 928:	0014899b          	addiw	s3,s1,1
 92c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 92e:	00000517          	auipc	a0,0x0
 932:	6d253503          	ld	a0,1746(a0) # 1000 <freep>
 936:	c515                	beqz	a0,962 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 938:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 93a:	4798                	lw	a4,8(a5)
 93c:	02977f63          	bgeu	a4,s1,97a <malloc+0x70>
 940:	8a4e                	mv	s4,s3
 942:	0009871b          	sext.w	a4,s3
 946:	6685                	lui	a3,0x1
 948:	00d77363          	bgeu	a4,a3,94e <malloc+0x44>
 94c:	6a05                	lui	s4,0x1
 94e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 952:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 956:	00000917          	auipc	s2,0x0
 95a:	6aa90913          	addi	s2,s2,1706 # 1000 <freep>
  if(p == (char*)-1)
 95e:	5afd                	li	s5,-1
 960:	a895                	j	9d4 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 962:	00000797          	auipc	a5,0x0
 966:	6ae78793          	addi	a5,a5,1710 # 1010 <base>
 96a:	00000717          	auipc	a4,0x0
 96e:	68f73b23          	sd	a5,1686(a4) # 1000 <freep>
 972:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 974:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 978:	b7e1                	j	940 <malloc+0x36>
      if(p->s.size == nunits)
 97a:	02e48c63          	beq	s1,a4,9b2 <malloc+0xa8>
        p->s.size -= nunits;
 97e:	4137073b          	subw	a4,a4,s3
 982:	c798                	sw	a4,8(a5)
        p += p->s.size;
 984:	02071693          	slli	a3,a4,0x20
 988:	01c6d713          	srli	a4,a3,0x1c
 98c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 98e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 992:	00000717          	auipc	a4,0x0
 996:	66a73723          	sd	a0,1646(a4) # 1000 <freep>
      return (void*)(p + 1);
 99a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 99e:	70e2                	ld	ra,56(sp)
 9a0:	7442                	ld	s0,48(sp)
 9a2:	74a2                	ld	s1,40(sp)
 9a4:	7902                	ld	s2,32(sp)
 9a6:	69e2                	ld	s3,24(sp)
 9a8:	6a42                	ld	s4,16(sp)
 9aa:	6aa2                	ld	s5,8(sp)
 9ac:	6b02                	ld	s6,0(sp)
 9ae:	6121                	addi	sp,sp,64
 9b0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9b2:	6398                	ld	a4,0(a5)
 9b4:	e118                	sd	a4,0(a0)
 9b6:	bff1                	j	992 <malloc+0x88>
  hp->s.size = nu;
 9b8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9bc:	0541                	addi	a0,a0,16
 9be:	00000097          	auipc	ra,0x0
 9c2:	eca080e7          	jalr	-310(ra) # 888 <free>
  return freep;
 9c6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9ca:	d971                	beqz	a0,99e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9cc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ce:	4798                	lw	a4,8(a5)
 9d0:	fa9775e3          	bgeu	a4,s1,97a <malloc+0x70>
    if(p == freep)
 9d4:	00093703          	ld	a4,0(s2)
 9d8:	853e                	mv	a0,a5
 9da:	fef719e3          	bne	a4,a5,9cc <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 9de:	8552                	mv	a0,s4
 9e0:	00000097          	auipc	ra,0x0
 9e4:	b80080e7          	jalr	-1152(ra) # 560 <sbrk>
  if(p == (char*)-1)
 9e8:	fd5518e3          	bne	a0,s5,9b8 <malloc+0xae>
        return 0;
 9ec:	4501                	li	a0,0
 9ee:	bf45                	j	99e <malloc+0x94>
