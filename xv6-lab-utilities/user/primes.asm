
user/_primes：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <recursive_com>:
#define FDS_WRITE 1
#define FDS_READ 0
#define INT_NUM 35

void recursive_com(int left_pipe[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	0080                	addi	s0,sp,64
   c:	84aa                	mv	s1,a0
    int prime;
    int is_read = read(left_pipe[FDS_READ], &prime, sizeof(prime));
   e:	4611                	li	a2,4
  10:	fdc40593          	addi	a1,s0,-36
  14:	4108                	lw	a0,0(a0)
  16:	00000097          	auipc	ra,0x0
  1a:	510080e7          	jalr	1296(ra) # 526 <read>
    if (is_read == 0) {
  1e:	c949                	beqz	a0,b0 <recursive_com+0xb0>
        close(left_pipe[FDS_READ]);
        exit(1);
    }
    else if (is_read == -1) {
  20:	57fd                	li	a5,-1
  22:	0af50163          	beq	a0,a5,c4 <recursive_com+0xc4>
        printf("read failed\n");
        exit(1);
    }
    else {
        printf("prime %d\n", prime);
  26:	fdc42583          	lw	a1,-36(s0)
  2a:	00001517          	auipc	a0,0x1
  2e:	a1650513          	addi	a0,a0,-1514 # a40 <malloc+0x100>
  32:	00001097          	auipc	ra,0x1
  36:	856080e7          	jalr	-1962(ra) # 888 <printf>
    }

    int p2c[2];
    if (pipe(p2c) < 0) {
  3a:	fd040513          	addi	a0,s0,-48
  3e:	00000097          	auipc	ra,0x0
  42:	4e0080e7          	jalr	1248(ra) # 51e <pipe>
  46:	08054c63          	bltz	a0,de <recursive_com+0xde>
        printf("pipe create failed\n");
        exit(1);
    }

    int pid;
    pid = fork();
  4a:	00000097          	auipc	ra,0x0
  4e:	4bc080e7          	jalr	1212(ra) # 506 <fork>

    if (pid < 0) {
  52:	0a054363          	bltz	a0,f8 <recursive_com+0xf8>
        printf("fork failed\n");
        exit(1);
    }

    if (pid == 0) {
  56:	cd55                	beqz	a0,112 <recursive_com+0x112>
        // 父进程
        int tmp;
        while (read(left_pipe[FDS_READ], &tmp, sizeof(tmp)) > 0) {
            if (tmp % prime != 0) {
                int flag = write(p2c[FDS_WRITE], &tmp, sizeof(tmp));
                if (flag == -1) {
  58:	597d                	li	s2,-1
        while (read(left_pipe[FDS_READ], &tmp, sizeof(tmp)) > 0) {
  5a:	4611                	li	a2,4
  5c:	fcc40593          	addi	a1,s0,-52
  60:	4088                	lw	a0,0(s1)
  62:	00000097          	auipc	ra,0x0
  66:	4c4080e7          	jalr	1220(ra) # 526 <read>
  6a:	0ca05563          	blez	a0,134 <recursive_com+0x134>
            if (tmp % prime != 0) {
  6e:	fcc42783          	lw	a5,-52(s0)
  72:	fdc42703          	lw	a4,-36(s0)
  76:	02e7e7bb          	remw	a5,a5,a4
  7a:	d3e5                	beqz	a5,5a <recursive_com+0x5a>
                int flag = write(p2c[FDS_WRITE], &tmp, sizeof(tmp));
  7c:	4611                	li	a2,4
  7e:	fcc40593          	addi	a1,s0,-52
  82:	fd442503          	lw	a0,-44(s0)
  86:	00000097          	auipc	ra,0x0
  8a:	4a8080e7          	jalr	1192(ra) # 52e <write>
                if (flag == -1) {
  8e:	fd2516e3          	bne	a0,s2,5a <recursive_com+0x5a>
                    printf("write %d failed\n", tmp);
  92:	fcc42583          	lw	a1,-52(s0)
  96:	00001517          	auipc	a0,0x1
  9a:	9e250513          	addi	a0,a0,-1566 # a78 <malloc+0x138>
  9e:	00000097          	auipc	ra,0x0
  a2:	7ea080e7          	jalr	2026(ra) # 888 <printf>
                    exit(1);
  a6:	4505                	li	a0,1
  a8:	00000097          	auipc	ra,0x0
  ac:	466080e7          	jalr	1126(ra) # 50e <exit>
        close(left_pipe[FDS_READ]);
  b0:	4088                	lw	a0,0(s1)
  b2:	00000097          	auipc	ra,0x0
  b6:	484080e7          	jalr	1156(ra) # 536 <close>
        exit(1);
  ba:	4505                	li	a0,1
  bc:	00000097          	auipc	ra,0x0
  c0:	452080e7          	jalr	1106(ra) # 50e <exit>
        printf("read failed\n");
  c4:	00001517          	auipc	a0,0x1
  c8:	96c50513          	addi	a0,a0,-1684 # a30 <malloc+0xf0>
  cc:	00000097          	auipc	ra,0x0
  d0:	7bc080e7          	jalr	1980(ra) # 888 <printf>
        exit(1);
  d4:	4505                	li	a0,1
  d6:	00000097          	auipc	ra,0x0
  da:	438080e7          	jalr	1080(ra) # 50e <exit>
        printf("pipe create failed\n");
  de:	00001517          	auipc	a0,0x1
  e2:	97250513          	addi	a0,a0,-1678 # a50 <malloc+0x110>
  e6:	00000097          	auipc	ra,0x0
  ea:	7a2080e7          	jalr	1954(ra) # 888 <printf>
        exit(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	41e080e7          	jalr	1054(ra) # 50e <exit>
        printf("fork failed\n");
  f8:	00001517          	auipc	a0,0x1
  fc:	97050513          	addi	a0,a0,-1680 # a68 <malloc+0x128>
 100:	00000097          	auipc	ra,0x0
 104:	788080e7          	jalr	1928(ra) # 888 <printf>
        exit(1);
 108:	4505                	li	a0,1
 10a:	00000097          	auipc	ra,0x0
 10e:	404080e7          	jalr	1028(ra) # 50e <exit>
        close(p2c[FDS_WRITE]);
 112:	fd442503          	lw	a0,-44(s0)
 116:	00000097          	auipc	ra,0x0
 11a:	420080e7          	jalr	1056(ra) # 536 <close>
        close(left_pipe[FDS_READ]);
 11e:	4088                	lw	a0,0(s1)
 120:	00000097          	auipc	ra,0x0
 124:	416080e7          	jalr	1046(ra) # 536 <close>
        recursive_com(p2c);
 128:	fd040513          	addi	a0,s0,-48
 12c:	00000097          	auipc	ra,0x0
 130:	ed4080e7          	jalr	-300(ra) # 0 <recursive_com>
                }
            }
        }
        close(left_pipe[FDS_READ]);
 134:	4088                	lw	a0,0(s1)
 136:	00000097          	auipc	ra,0x0
 13a:	400080e7          	jalr	1024(ra) # 536 <close>
        close(p2c[FDS_WRITE]);
 13e:	fd442503          	lw	a0,-44(s0)
 142:	00000097          	auipc	ra,0x0
 146:	3f4080e7          	jalr	1012(ra) # 536 <close>
        wait(0);
 14a:	4501                	li	a0,0
 14c:	00000097          	auipc	ra,0x0
 150:	3ca080e7          	jalr	970(ra) # 516 <wait>
    }

    exit(0);
 154:	4501                	li	a0,0
 156:	00000097          	auipc	ra,0x0
 15a:	3b8080e7          	jalr	952(ra) # 50e <exit>

000000000000015e <main>:
}

int main(int argc, char *argv[])
{
 15e:	7155                	addi	sp,sp,-208
 160:	e586                	sd	ra,200(sp)
 162:	e1a2                	sd	s0,192(sp)
 164:	fd26                	sd	s1,184(sp)
 166:	f94a                	sd	s2,176(sp)
 168:	f54e                	sd	s3,168(sp)
 16a:	f152                	sd	s4,160(sp)
 16c:	0980                	addi	s0,sp,208
    if (argc > 1) {
 16e:	4785                	li	a5,1
 170:	04a7c863          	blt	a5,a0,1c0 <main+0x62>
 174:	f4040493          	addi	s1,s0,-192
 178:	8726                	mv	a4,s1
        exit(1);
    }

    int nums[INT_NUM + 2];

    for (int i = 2; i <= INT_NUM; i++) {
 17a:	4789                	li	a5,2
 17c:	02400693          	li	a3,36
        nums[i] = i;
 180:	c31c                	sw	a5,0(a4)
    for (int i = 2; i <= INT_NUM; i++) {
 182:	2785                	addiw	a5,a5,1
 184:	0711                	addi	a4,a4,4
 186:	fed79de3          	bne	a5,a3,180 <main+0x22>
    }

    int p2c[2];
    if (pipe(p2c) < 0) {
 18a:	f3040513          	addi	a0,s0,-208
 18e:	00000097          	auipc	ra,0x0
 192:	390080e7          	jalr	912(ra) # 51e <pipe>
 196:	04054363          	bltz	a0,1dc <main+0x7e>
        printf("pipe create failed\n");
        exit(1);
    }

    int pid;
    pid = fork();
 19a:	00000097          	auipc	ra,0x0
 19e:	36c080e7          	jalr	876(ra) # 506 <fork>
    if (pid < 0) {
 1a2:	04054a63          	bltz	a0,1f6 <main+0x98>
        printf("fork failed\n");
        exit(1);
    }
    if (pid == 0) {
 1a6:	e52d                	bnez	a0,210 <main+0xb2>
        // 子进程
        close(p2c[FDS_WRITE]);
 1a8:	f3442503          	lw	a0,-204(s0)
 1ac:	00000097          	auipc	ra,0x0
 1b0:	38a080e7          	jalr	906(ra) # 536 <close>
        recursive_com(p2c);
 1b4:	f3040513          	addi	a0,s0,-208
 1b8:	00000097          	auipc	ra,0x0
 1bc:	e48080e7          	jalr	-440(ra) # 0 <recursive_com>
        fprintf(2, "No argument is needed!\n");
 1c0:	00001597          	auipc	a1,0x1
 1c4:	8d058593          	addi	a1,a1,-1840 # a90 <malloc+0x150>
 1c8:	4509                	li	a0,2
 1ca:	00000097          	auipc	ra,0x0
 1ce:	690080e7          	jalr	1680(ra) # 85a <fprintf>
        exit(1);
 1d2:	4505                	li	a0,1
 1d4:	00000097          	auipc	ra,0x0
 1d8:	33a080e7          	jalr	826(ra) # 50e <exit>
        printf("pipe create failed\n");
 1dc:	00001517          	auipc	a0,0x1
 1e0:	87450513          	addi	a0,a0,-1932 # a50 <malloc+0x110>
 1e4:	00000097          	auipc	ra,0x0
 1e8:	6a4080e7          	jalr	1700(ra) # 888 <printf>
        exit(1);
 1ec:	4505                	li	a0,1
 1ee:	00000097          	auipc	ra,0x0
 1f2:	320080e7          	jalr	800(ra) # 50e <exit>
        printf("fork failed\n");
 1f6:	00001517          	auipc	a0,0x1
 1fa:	87250513          	addi	a0,a0,-1934 # a68 <malloc+0x128>
 1fe:	00000097          	auipc	ra,0x0
 202:	68a080e7          	jalr	1674(ra) # 888 <printf>
        exit(1);
 206:	4505                	li	a0,1
 208:	00000097          	auipc	ra,0x0
 20c:	306080e7          	jalr	774(ra) # 50e <exit>
    }
    else {
        // 父进程
        close(p2c[FDS_READ]);
 210:	f3042503          	lw	a0,-208(s0)
 214:	00000097          	auipc	ra,0x0
 218:	322080e7          	jalr	802(ra) # 536 <close>
        for (int i = 2; i <= INT_NUM; i++) {
 21c:	4909                	li	s2,2
            if (write(p2c[FDS_WRITE], &nums[i], sizeof(nums[i])) == -1) {
 21e:	59fd                	li	s3,-1
        for (int i = 2; i <= INT_NUM; i++) {
 220:	02400a13          	li	s4,36
            if (write(p2c[FDS_WRITE], &nums[i], sizeof(nums[i])) == -1) {
 224:	4611                	li	a2,4
 226:	85a6                	mv	a1,s1
 228:	f3442503          	lw	a0,-204(s0)
 22c:	00000097          	auipc	ra,0x0
 230:	302080e7          	jalr	770(ra) # 52e <write>
 234:	03350663          	beq	a0,s3,260 <main+0x102>
        for (int i = 2; i <= INT_NUM; i++) {
 238:	2905                	addiw	s2,s2,1
 23a:	0491                	addi	s1,s1,4
 23c:	ff4914e3          	bne	s2,s4,224 <main+0xc6>
                printf("write %d failed\n", nums[i]);
                exit(1);
            }
        }
        close(p2c[FDS_WRITE]);
 240:	f3442503          	lw	a0,-204(s0)
 244:	00000097          	auipc	ra,0x0
 248:	2f2080e7          	jalr	754(ra) # 536 <close>

        wait(0);
 24c:	4501                	li	a0,0
 24e:	00000097          	auipc	ra,0x0
 252:	2c8080e7          	jalr	712(ra) # 516 <wait>
    }
    exit(0);
 256:	4501                	li	a0,0
 258:	00000097          	auipc	ra,0x0
 25c:	2b6080e7          	jalr	694(ra) # 50e <exit>
                printf("write %d failed\n", nums[i]);
 260:	00291793          	slli	a5,s2,0x2
 264:	fd078793          	addi	a5,a5,-48
 268:	97a2                	add	a5,a5,s0
 26a:	f687a583          	lw	a1,-152(a5)
 26e:	00001517          	auipc	a0,0x1
 272:	80a50513          	addi	a0,a0,-2038 # a78 <malloc+0x138>
 276:	00000097          	auipc	ra,0x0
 27a:	612080e7          	jalr	1554(ra) # 888 <printf>
                exit(1);
 27e:	4505                	li	a0,1
 280:	00000097          	auipc	ra,0x0
 284:	28e080e7          	jalr	654(ra) # 50e <exit>

0000000000000288 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 288:	1141                	addi	sp,sp,-16
 28a:	e406                	sd	ra,8(sp)
 28c:	e022                	sd	s0,0(sp)
 28e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 290:	00000097          	auipc	ra,0x0
 294:	ece080e7          	jalr	-306(ra) # 15e <main>
  exit(0);
 298:	4501                	li	a0,0
 29a:	00000097          	auipc	ra,0x0
 29e:	274080e7          	jalr	628(ra) # 50e <exit>

00000000000002a2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e422                	sd	s0,8(sp)
 2a6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2a8:	87aa                	mv	a5,a0
 2aa:	0585                	addi	a1,a1,1
 2ac:	0785                	addi	a5,a5,1
 2ae:	fff5c703          	lbu	a4,-1(a1)
 2b2:	fee78fa3          	sb	a4,-1(a5)
 2b6:	fb75                	bnez	a4,2aa <strcpy+0x8>
    ;
  return os;
}
 2b8:	6422                	ld	s0,8(sp)
 2ba:	0141                	addi	sp,sp,16
 2bc:	8082                	ret

00000000000002be <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2be:	1141                	addi	sp,sp,-16
 2c0:	e422                	sd	s0,8(sp)
 2c2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	cb91                	beqz	a5,2dc <strcmp+0x1e>
 2ca:	0005c703          	lbu	a4,0(a1)
 2ce:	00f71763          	bne	a4,a5,2dc <strcmp+0x1e>
    p++, q++;
 2d2:	0505                	addi	a0,a0,1
 2d4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2d6:	00054783          	lbu	a5,0(a0)
 2da:	fbe5                	bnez	a5,2ca <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2dc:	0005c503          	lbu	a0,0(a1)
}
 2e0:	40a7853b          	subw	a0,a5,a0
 2e4:	6422                	ld	s0,8(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret

00000000000002ea <strlen>:

uint
strlen(const char *s)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e422                	sd	s0,8(sp)
 2ee:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2f0:	00054783          	lbu	a5,0(a0)
 2f4:	cf91                	beqz	a5,310 <strlen+0x26>
 2f6:	0505                	addi	a0,a0,1
 2f8:	87aa                	mv	a5,a0
 2fa:	4685                	li	a3,1
 2fc:	9e89                	subw	a3,a3,a0
 2fe:	00f6853b          	addw	a0,a3,a5
 302:	0785                	addi	a5,a5,1
 304:	fff7c703          	lbu	a4,-1(a5)
 308:	fb7d                	bnez	a4,2fe <strlen+0x14>
    ;
  return n;
}
 30a:	6422                	ld	s0,8(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret
  for(n = 0; s[n]; n++)
 310:	4501                	li	a0,0
 312:	bfe5                	j	30a <strlen+0x20>

0000000000000314 <memset>:

void*
memset(void *dst, int c, uint n)
{
 314:	1141                	addi	sp,sp,-16
 316:	e422                	sd	s0,8(sp)
 318:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 31a:	ca19                	beqz	a2,330 <memset+0x1c>
 31c:	87aa                	mv	a5,a0
 31e:	1602                	slli	a2,a2,0x20
 320:	9201                	srli	a2,a2,0x20
 322:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 326:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 32a:	0785                	addi	a5,a5,1
 32c:	fee79de3          	bne	a5,a4,326 <memset+0x12>
  }
  return dst;
}
 330:	6422                	ld	s0,8(sp)
 332:	0141                	addi	sp,sp,16
 334:	8082                	ret

0000000000000336 <strchr>:

char*
strchr(const char *s, char c)
{
 336:	1141                	addi	sp,sp,-16
 338:	e422                	sd	s0,8(sp)
 33a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 33c:	00054783          	lbu	a5,0(a0)
 340:	cb99                	beqz	a5,356 <strchr+0x20>
    if(*s == c)
 342:	00f58763          	beq	a1,a5,350 <strchr+0x1a>
  for(; *s; s++)
 346:	0505                	addi	a0,a0,1
 348:	00054783          	lbu	a5,0(a0)
 34c:	fbfd                	bnez	a5,342 <strchr+0xc>
      return (char*)s;
  return 0;
 34e:	4501                	li	a0,0
}
 350:	6422                	ld	s0,8(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret
  return 0;
 356:	4501                	li	a0,0
 358:	bfe5                	j	350 <strchr+0x1a>

000000000000035a <gets>:

char*
gets(char *buf, int max)
{
 35a:	711d                	addi	sp,sp,-96
 35c:	ec86                	sd	ra,88(sp)
 35e:	e8a2                	sd	s0,80(sp)
 360:	e4a6                	sd	s1,72(sp)
 362:	e0ca                	sd	s2,64(sp)
 364:	fc4e                	sd	s3,56(sp)
 366:	f852                	sd	s4,48(sp)
 368:	f456                	sd	s5,40(sp)
 36a:	f05a                	sd	s6,32(sp)
 36c:	ec5e                	sd	s7,24(sp)
 36e:	1080                	addi	s0,sp,96
 370:	8baa                	mv	s7,a0
 372:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 374:	892a                	mv	s2,a0
 376:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 378:	4aa9                	li	s5,10
 37a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 37c:	89a6                	mv	s3,s1
 37e:	2485                	addiw	s1,s1,1
 380:	0344d863          	bge	s1,s4,3b0 <gets+0x56>
    cc = read(0, &c, 1);
 384:	4605                	li	a2,1
 386:	faf40593          	addi	a1,s0,-81
 38a:	4501                	li	a0,0
 38c:	00000097          	auipc	ra,0x0
 390:	19a080e7          	jalr	410(ra) # 526 <read>
    if(cc < 1)
 394:	00a05e63          	blez	a0,3b0 <gets+0x56>
    buf[i++] = c;
 398:	faf44783          	lbu	a5,-81(s0)
 39c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3a0:	01578763          	beq	a5,s5,3ae <gets+0x54>
 3a4:	0905                	addi	s2,s2,1
 3a6:	fd679be3          	bne	a5,s6,37c <gets+0x22>
  for(i=0; i+1 < max; ){
 3aa:	89a6                	mv	s3,s1
 3ac:	a011                	j	3b0 <gets+0x56>
 3ae:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3b0:	99de                	add	s3,s3,s7
 3b2:	00098023          	sb	zero,0(s3)
  return buf;
}
 3b6:	855e                	mv	a0,s7
 3b8:	60e6                	ld	ra,88(sp)
 3ba:	6446                	ld	s0,80(sp)
 3bc:	64a6                	ld	s1,72(sp)
 3be:	6906                	ld	s2,64(sp)
 3c0:	79e2                	ld	s3,56(sp)
 3c2:	7a42                	ld	s4,48(sp)
 3c4:	7aa2                	ld	s5,40(sp)
 3c6:	7b02                	ld	s6,32(sp)
 3c8:	6be2                	ld	s7,24(sp)
 3ca:	6125                	addi	sp,sp,96
 3cc:	8082                	ret

00000000000003ce <stat>:

int
stat(const char *n, struct stat *st)
{
 3ce:	1101                	addi	sp,sp,-32
 3d0:	ec06                	sd	ra,24(sp)
 3d2:	e822                	sd	s0,16(sp)
 3d4:	e426                	sd	s1,8(sp)
 3d6:	e04a                	sd	s2,0(sp)
 3d8:	1000                	addi	s0,sp,32
 3da:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3dc:	4581                	li	a1,0
 3de:	00000097          	auipc	ra,0x0
 3e2:	170080e7          	jalr	368(ra) # 54e <open>
  if(fd < 0)
 3e6:	02054563          	bltz	a0,410 <stat+0x42>
 3ea:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3ec:	85ca                	mv	a1,s2
 3ee:	00000097          	auipc	ra,0x0
 3f2:	178080e7          	jalr	376(ra) # 566 <fstat>
 3f6:	892a                	mv	s2,a0
  close(fd);
 3f8:	8526                	mv	a0,s1
 3fa:	00000097          	auipc	ra,0x0
 3fe:	13c080e7          	jalr	316(ra) # 536 <close>
  return r;
}
 402:	854a                	mv	a0,s2
 404:	60e2                	ld	ra,24(sp)
 406:	6442                	ld	s0,16(sp)
 408:	64a2                	ld	s1,8(sp)
 40a:	6902                	ld	s2,0(sp)
 40c:	6105                	addi	sp,sp,32
 40e:	8082                	ret
    return -1;
 410:	597d                	li	s2,-1
 412:	bfc5                	j	402 <stat+0x34>

0000000000000414 <atoi>:

int
atoi(const char *s)
{
 414:	1141                	addi	sp,sp,-16
 416:	e422                	sd	s0,8(sp)
 418:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 41a:	00054683          	lbu	a3,0(a0)
 41e:	fd06879b          	addiw	a5,a3,-48
 422:	0ff7f793          	zext.b	a5,a5
 426:	4625                	li	a2,9
 428:	02f66863          	bltu	a2,a5,458 <atoi+0x44>
 42c:	872a                	mv	a4,a0
  n = 0;
 42e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 430:	0705                	addi	a4,a4,1
 432:	0025179b          	slliw	a5,a0,0x2
 436:	9fa9                	addw	a5,a5,a0
 438:	0017979b          	slliw	a5,a5,0x1
 43c:	9fb5                	addw	a5,a5,a3
 43e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 442:	00074683          	lbu	a3,0(a4)
 446:	fd06879b          	addiw	a5,a3,-48
 44a:	0ff7f793          	zext.b	a5,a5
 44e:	fef671e3          	bgeu	a2,a5,430 <atoi+0x1c>
  return n;
}
 452:	6422                	ld	s0,8(sp)
 454:	0141                	addi	sp,sp,16
 456:	8082                	ret
  n = 0;
 458:	4501                	li	a0,0
 45a:	bfe5                	j	452 <atoi+0x3e>

000000000000045c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 45c:	1141                	addi	sp,sp,-16
 45e:	e422                	sd	s0,8(sp)
 460:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 462:	02b57463          	bgeu	a0,a1,48a <memmove+0x2e>
    while(n-- > 0)
 466:	00c05f63          	blez	a2,484 <memmove+0x28>
 46a:	1602                	slli	a2,a2,0x20
 46c:	9201                	srli	a2,a2,0x20
 46e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 472:	872a                	mv	a4,a0
      *dst++ = *src++;
 474:	0585                	addi	a1,a1,1
 476:	0705                	addi	a4,a4,1
 478:	fff5c683          	lbu	a3,-1(a1)
 47c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 480:	fee79ae3          	bne	a5,a4,474 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 484:	6422                	ld	s0,8(sp)
 486:	0141                	addi	sp,sp,16
 488:	8082                	ret
    dst += n;
 48a:	00c50733          	add	a4,a0,a2
    src += n;
 48e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 490:	fec05ae3          	blez	a2,484 <memmove+0x28>
 494:	fff6079b          	addiw	a5,a2,-1
 498:	1782                	slli	a5,a5,0x20
 49a:	9381                	srli	a5,a5,0x20
 49c:	fff7c793          	not	a5,a5
 4a0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4a2:	15fd                	addi	a1,a1,-1
 4a4:	177d                	addi	a4,a4,-1
 4a6:	0005c683          	lbu	a3,0(a1)
 4aa:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4ae:	fee79ae3          	bne	a5,a4,4a2 <memmove+0x46>
 4b2:	bfc9                	j	484 <memmove+0x28>

00000000000004b4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4b4:	1141                	addi	sp,sp,-16
 4b6:	e422                	sd	s0,8(sp)
 4b8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4ba:	ca05                	beqz	a2,4ea <memcmp+0x36>
 4bc:	fff6069b          	addiw	a3,a2,-1
 4c0:	1682                	slli	a3,a3,0x20
 4c2:	9281                	srli	a3,a3,0x20
 4c4:	0685                	addi	a3,a3,1
 4c6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4c8:	00054783          	lbu	a5,0(a0)
 4cc:	0005c703          	lbu	a4,0(a1)
 4d0:	00e79863          	bne	a5,a4,4e0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4d4:	0505                	addi	a0,a0,1
    p2++;
 4d6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4d8:	fed518e3          	bne	a0,a3,4c8 <memcmp+0x14>
  }
  return 0;
 4dc:	4501                	li	a0,0
 4de:	a019                	j	4e4 <memcmp+0x30>
      return *p1 - *p2;
 4e0:	40e7853b          	subw	a0,a5,a4
}
 4e4:	6422                	ld	s0,8(sp)
 4e6:	0141                	addi	sp,sp,16
 4e8:	8082                	ret
  return 0;
 4ea:	4501                	li	a0,0
 4ec:	bfe5                	j	4e4 <memcmp+0x30>

00000000000004ee <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4ee:	1141                	addi	sp,sp,-16
 4f0:	e406                	sd	ra,8(sp)
 4f2:	e022                	sd	s0,0(sp)
 4f4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4f6:	00000097          	auipc	ra,0x0
 4fa:	f66080e7          	jalr	-154(ra) # 45c <memmove>
}
 4fe:	60a2                	ld	ra,8(sp)
 500:	6402                	ld	s0,0(sp)
 502:	0141                	addi	sp,sp,16
 504:	8082                	ret

0000000000000506 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 506:	4885                	li	a7,1
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <exit>:
.global exit
exit:
 li a7, SYS_exit
 50e:	4889                	li	a7,2
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <wait>:
.global wait
wait:
 li a7, SYS_wait
 516:	488d                	li	a7,3
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 51e:	4891                	li	a7,4
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <read>:
.global read
read:
 li a7, SYS_read
 526:	4895                	li	a7,5
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <write>:
.global write
write:
 li a7, SYS_write
 52e:	48c1                	li	a7,16
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <close>:
.global close
close:
 li a7, SYS_close
 536:	48d5                	li	a7,21
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <kill>:
.global kill
kill:
 li a7, SYS_kill
 53e:	4899                	li	a7,6
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <exec>:
.global exec
exec:
 li a7, SYS_exec
 546:	489d                	li	a7,7
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <open>:
.global open
open:
 li a7, SYS_open
 54e:	48bd                	li	a7,15
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 556:	48c5                	li	a7,17
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 55e:	48c9                	li	a7,18
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 566:	48a1                	li	a7,8
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <link>:
.global link
link:
 li a7, SYS_link
 56e:	48cd                	li	a7,19
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 576:	48d1                	li	a7,20
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 57e:	48a5                	li	a7,9
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <dup>:
.global dup
dup:
 li a7, SYS_dup
 586:	48a9                	li	a7,10
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 58e:	48ad                	li	a7,11
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 596:	48b1                	li	a7,12
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 59e:	48b5                	li	a7,13
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5a6:	48b9                	li	a7,14
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5ae:	1101                	addi	sp,sp,-32
 5b0:	ec06                	sd	ra,24(sp)
 5b2:	e822                	sd	s0,16(sp)
 5b4:	1000                	addi	s0,sp,32
 5b6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5ba:	4605                	li	a2,1
 5bc:	fef40593          	addi	a1,s0,-17
 5c0:	00000097          	auipc	ra,0x0
 5c4:	f6e080e7          	jalr	-146(ra) # 52e <write>
}
 5c8:	60e2                	ld	ra,24(sp)
 5ca:	6442                	ld	s0,16(sp)
 5cc:	6105                	addi	sp,sp,32
 5ce:	8082                	ret

00000000000005d0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5d0:	7139                	addi	sp,sp,-64
 5d2:	fc06                	sd	ra,56(sp)
 5d4:	f822                	sd	s0,48(sp)
 5d6:	f426                	sd	s1,40(sp)
 5d8:	f04a                	sd	s2,32(sp)
 5da:	ec4e                	sd	s3,24(sp)
 5dc:	0080                	addi	s0,sp,64
 5de:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5e0:	c299                	beqz	a3,5e6 <printint+0x16>
 5e2:	0805c963          	bltz	a1,674 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5e6:	2581                	sext.w	a1,a1
  neg = 0;
 5e8:	4881                	li	a7,0
 5ea:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5ee:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5f0:	2601                	sext.w	a2,a2
 5f2:	00000517          	auipc	a0,0x0
 5f6:	51650513          	addi	a0,a0,1302 # b08 <digits>
 5fa:	883a                	mv	a6,a4
 5fc:	2705                	addiw	a4,a4,1
 5fe:	02c5f7bb          	remuw	a5,a1,a2
 602:	1782                	slli	a5,a5,0x20
 604:	9381                	srli	a5,a5,0x20
 606:	97aa                	add	a5,a5,a0
 608:	0007c783          	lbu	a5,0(a5)
 60c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 610:	0005879b          	sext.w	a5,a1
 614:	02c5d5bb          	divuw	a1,a1,a2
 618:	0685                	addi	a3,a3,1
 61a:	fec7f0e3          	bgeu	a5,a2,5fa <printint+0x2a>
  if(neg)
 61e:	00088c63          	beqz	a7,636 <printint+0x66>
    buf[i++] = '-';
 622:	fd070793          	addi	a5,a4,-48
 626:	00878733          	add	a4,a5,s0
 62a:	02d00793          	li	a5,45
 62e:	fef70823          	sb	a5,-16(a4)
 632:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 636:	02e05863          	blez	a4,666 <printint+0x96>
 63a:	fc040793          	addi	a5,s0,-64
 63e:	00e78933          	add	s2,a5,a4
 642:	fff78993          	addi	s3,a5,-1
 646:	99ba                	add	s3,s3,a4
 648:	377d                	addiw	a4,a4,-1
 64a:	1702                	slli	a4,a4,0x20
 64c:	9301                	srli	a4,a4,0x20
 64e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 652:	fff94583          	lbu	a1,-1(s2)
 656:	8526                	mv	a0,s1
 658:	00000097          	auipc	ra,0x0
 65c:	f56080e7          	jalr	-170(ra) # 5ae <putc>
  while(--i >= 0)
 660:	197d                	addi	s2,s2,-1
 662:	ff3918e3          	bne	s2,s3,652 <printint+0x82>
}
 666:	70e2                	ld	ra,56(sp)
 668:	7442                	ld	s0,48(sp)
 66a:	74a2                	ld	s1,40(sp)
 66c:	7902                	ld	s2,32(sp)
 66e:	69e2                	ld	s3,24(sp)
 670:	6121                	addi	sp,sp,64
 672:	8082                	ret
    x = -xx;
 674:	40b005bb          	negw	a1,a1
    neg = 1;
 678:	4885                	li	a7,1
    x = -xx;
 67a:	bf85                	j	5ea <printint+0x1a>

000000000000067c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 67c:	7119                	addi	sp,sp,-128
 67e:	fc86                	sd	ra,120(sp)
 680:	f8a2                	sd	s0,112(sp)
 682:	f4a6                	sd	s1,104(sp)
 684:	f0ca                	sd	s2,96(sp)
 686:	ecce                	sd	s3,88(sp)
 688:	e8d2                	sd	s4,80(sp)
 68a:	e4d6                	sd	s5,72(sp)
 68c:	e0da                	sd	s6,64(sp)
 68e:	fc5e                	sd	s7,56(sp)
 690:	f862                	sd	s8,48(sp)
 692:	f466                	sd	s9,40(sp)
 694:	f06a                	sd	s10,32(sp)
 696:	ec6e                	sd	s11,24(sp)
 698:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 69a:	0005c903          	lbu	s2,0(a1)
 69e:	18090f63          	beqz	s2,83c <vprintf+0x1c0>
 6a2:	8aaa                	mv	s5,a0
 6a4:	8b32                	mv	s6,a2
 6a6:	00158493          	addi	s1,a1,1
  state = 0;
 6aa:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6ac:	02500a13          	li	s4,37
 6b0:	4c55                	li	s8,21
 6b2:	00000c97          	auipc	s9,0x0
 6b6:	3fec8c93          	addi	s9,s9,1022 # ab0 <malloc+0x170>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6ba:	02800d93          	li	s11,40
  putc(fd, 'x');
 6be:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c0:	00000b97          	auipc	s7,0x0
 6c4:	448b8b93          	addi	s7,s7,1096 # b08 <digits>
 6c8:	a839                	j	6e6 <vprintf+0x6a>
        putc(fd, c);
 6ca:	85ca                	mv	a1,s2
 6cc:	8556                	mv	a0,s5
 6ce:	00000097          	auipc	ra,0x0
 6d2:	ee0080e7          	jalr	-288(ra) # 5ae <putc>
 6d6:	a019                	j	6dc <vprintf+0x60>
    } else if(state == '%'){
 6d8:	01498d63          	beq	s3,s4,6f2 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 6dc:	0485                	addi	s1,s1,1
 6de:	fff4c903          	lbu	s2,-1(s1)
 6e2:	14090d63          	beqz	s2,83c <vprintf+0x1c0>
    if(state == 0){
 6e6:	fe0999e3          	bnez	s3,6d8 <vprintf+0x5c>
      if(c == '%'){
 6ea:	ff4910e3          	bne	s2,s4,6ca <vprintf+0x4e>
        state = '%';
 6ee:	89d2                	mv	s3,s4
 6f0:	b7f5                	j	6dc <vprintf+0x60>
      if(c == 'd'){
 6f2:	11490c63          	beq	s2,s4,80a <vprintf+0x18e>
 6f6:	f9d9079b          	addiw	a5,s2,-99
 6fa:	0ff7f793          	zext.b	a5,a5
 6fe:	10fc6e63          	bltu	s8,a5,81a <vprintf+0x19e>
 702:	f9d9079b          	addiw	a5,s2,-99
 706:	0ff7f713          	zext.b	a4,a5
 70a:	10ec6863          	bltu	s8,a4,81a <vprintf+0x19e>
 70e:	00271793          	slli	a5,a4,0x2
 712:	97e6                	add	a5,a5,s9
 714:	439c                	lw	a5,0(a5)
 716:	97e6                	add	a5,a5,s9
 718:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 71a:	008b0913          	addi	s2,s6,8
 71e:	4685                	li	a3,1
 720:	4629                	li	a2,10
 722:	000b2583          	lw	a1,0(s6)
 726:	8556                	mv	a0,s5
 728:	00000097          	auipc	ra,0x0
 72c:	ea8080e7          	jalr	-344(ra) # 5d0 <printint>
 730:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 732:	4981                	li	s3,0
 734:	b765                	j	6dc <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 736:	008b0913          	addi	s2,s6,8
 73a:	4681                	li	a3,0
 73c:	4629                	li	a2,10
 73e:	000b2583          	lw	a1,0(s6)
 742:	8556                	mv	a0,s5
 744:	00000097          	auipc	ra,0x0
 748:	e8c080e7          	jalr	-372(ra) # 5d0 <printint>
 74c:	8b4a                	mv	s6,s2
      state = 0;
 74e:	4981                	li	s3,0
 750:	b771                	j	6dc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 752:	008b0913          	addi	s2,s6,8
 756:	4681                	li	a3,0
 758:	866a                	mv	a2,s10
 75a:	000b2583          	lw	a1,0(s6)
 75e:	8556                	mv	a0,s5
 760:	00000097          	auipc	ra,0x0
 764:	e70080e7          	jalr	-400(ra) # 5d0 <printint>
 768:	8b4a                	mv	s6,s2
      state = 0;
 76a:	4981                	li	s3,0
 76c:	bf85                	j	6dc <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 76e:	008b0793          	addi	a5,s6,8
 772:	f8f43423          	sd	a5,-120(s0)
 776:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 77a:	03000593          	li	a1,48
 77e:	8556                	mv	a0,s5
 780:	00000097          	auipc	ra,0x0
 784:	e2e080e7          	jalr	-466(ra) # 5ae <putc>
  putc(fd, 'x');
 788:	07800593          	li	a1,120
 78c:	8556                	mv	a0,s5
 78e:	00000097          	auipc	ra,0x0
 792:	e20080e7          	jalr	-480(ra) # 5ae <putc>
 796:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 798:	03c9d793          	srli	a5,s3,0x3c
 79c:	97de                	add	a5,a5,s7
 79e:	0007c583          	lbu	a1,0(a5)
 7a2:	8556                	mv	a0,s5
 7a4:	00000097          	auipc	ra,0x0
 7a8:	e0a080e7          	jalr	-502(ra) # 5ae <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7ac:	0992                	slli	s3,s3,0x4
 7ae:	397d                	addiw	s2,s2,-1
 7b0:	fe0914e3          	bnez	s2,798 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 7b4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7b8:	4981                	li	s3,0
 7ba:	b70d                	j	6dc <vprintf+0x60>
        s = va_arg(ap, char*);
 7bc:	008b0913          	addi	s2,s6,8
 7c0:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 7c4:	02098163          	beqz	s3,7e6 <vprintf+0x16a>
        while(*s != 0){
 7c8:	0009c583          	lbu	a1,0(s3)
 7cc:	c5ad                	beqz	a1,836 <vprintf+0x1ba>
          putc(fd, *s);
 7ce:	8556                	mv	a0,s5
 7d0:	00000097          	auipc	ra,0x0
 7d4:	dde080e7          	jalr	-546(ra) # 5ae <putc>
          s++;
 7d8:	0985                	addi	s3,s3,1
        while(*s != 0){
 7da:	0009c583          	lbu	a1,0(s3)
 7de:	f9e5                	bnez	a1,7ce <vprintf+0x152>
        s = va_arg(ap, char*);
 7e0:	8b4a                	mv	s6,s2
      state = 0;
 7e2:	4981                	li	s3,0
 7e4:	bde5                	j	6dc <vprintf+0x60>
          s = "(null)";
 7e6:	00000997          	auipc	s3,0x0
 7ea:	2c298993          	addi	s3,s3,706 # aa8 <malloc+0x168>
        while(*s != 0){
 7ee:	85ee                	mv	a1,s11
 7f0:	bff9                	j	7ce <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 7f2:	008b0913          	addi	s2,s6,8
 7f6:	000b4583          	lbu	a1,0(s6)
 7fa:	8556                	mv	a0,s5
 7fc:	00000097          	auipc	ra,0x0
 800:	db2080e7          	jalr	-590(ra) # 5ae <putc>
 804:	8b4a                	mv	s6,s2
      state = 0;
 806:	4981                	li	s3,0
 808:	bdd1                	j	6dc <vprintf+0x60>
        putc(fd, c);
 80a:	85d2                	mv	a1,s4
 80c:	8556                	mv	a0,s5
 80e:	00000097          	auipc	ra,0x0
 812:	da0080e7          	jalr	-608(ra) # 5ae <putc>
      state = 0;
 816:	4981                	li	s3,0
 818:	b5d1                	j	6dc <vprintf+0x60>
        putc(fd, '%');
 81a:	85d2                	mv	a1,s4
 81c:	8556                	mv	a0,s5
 81e:	00000097          	auipc	ra,0x0
 822:	d90080e7          	jalr	-624(ra) # 5ae <putc>
        putc(fd, c);
 826:	85ca                	mv	a1,s2
 828:	8556                	mv	a0,s5
 82a:	00000097          	auipc	ra,0x0
 82e:	d84080e7          	jalr	-636(ra) # 5ae <putc>
      state = 0;
 832:	4981                	li	s3,0
 834:	b565                	j	6dc <vprintf+0x60>
        s = va_arg(ap, char*);
 836:	8b4a                	mv	s6,s2
      state = 0;
 838:	4981                	li	s3,0
 83a:	b54d                	j	6dc <vprintf+0x60>
    }
  }
}
 83c:	70e6                	ld	ra,120(sp)
 83e:	7446                	ld	s0,112(sp)
 840:	74a6                	ld	s1,104(sp)
 842:	7906                	ld	s2,96(sp)
 844:	69e6                	ld	s3,88(sp)
 846:	6a46                	ld	s4,80(sp)
 848:	6aa6                	ld	s5,72(sp)
 84a:	6b06                	ld	s6,64(sp)
 84c:	7be2                	ld	s7,56(sp)
 84e:	7c42                	ld	s8,48(sp)
 850:	7ca2                	ld	s9,40(sp)
 852:	7d02                	ld	s10,32(sp)
 854:	6de2                	ld	s11,24(sp)
 856:	6109                	addi	sp,sp,128
 858:	8082                	ret

000000000000085a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 85a:	715d                	addi	sp,sp,-80
 85c:	ec06                	sd	ra,24(sp)
 85e:	e822                	sd	s0,16(sp)
 860:	1000                	addi	s0,sp,32
 862:	e010                	sd	a2,0(s0)
 864:	e414                	sd	a3,8(s0)
 866:	e818                	sd	a4,16(s0)
 868:	ec1c                	sd	a5,24(s0)
 86a:	03043023          	sd	a6,32(s0)
 86e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 872:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 876:	8622                	mv	a2,s0
 878:	00000097          	auipc	ra,0x0
 87c:	e04080e7          	jalr	-508(ra) # 67c <vprintf>
}
 880:	60e2                	ld	ra,24(sp)
 882:	6442                	ld	s0,16(sp)
 884:	6161                	addi	sp,sp,80
 886:	8082                	ret

0000000000000888 <printf>:

void
printf(const char *fmt, ...)
{
 888:	711d                	addi	sp,sp,-96
 88a:	ec06                	sd	ra,24(sp)
 88c:	e822                	sd	s0,16(sp)
 88e:	1000                	addi	s0,sp,32
 890:	e40c                	sd	a1,8(s0)
 892:	e810                	sd	a2,16(s0)
 894:	ec14                	sd	a3,24(s0)
 896:	f018                	sd	a4,32(s0)
 898:	f41c                	sd	a5,40(s0)
 89a:	03043823          	sd	a6,48(s0)
 89e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8a2:	00840613          	addi	a2,s0,8
 8a6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8aa:	85aa                	mv	a1,a0
 8ac:	4505                	li	a0,1
 8ae:	00000097          	auipc	ra,0x0
 8b2:	dce080e7          	jalr	-562(ra) # 67c <vprintf>
}
 8b6:	60e2                	ld	ra,24(sp)
 8b8:	6442                	ld	s0,16(sp)
 8ba:	6125                	addi	sp,sp,96
 8bc:	8082                	ret

00000000000008be <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8be:	1141                	addi	sp,sp,-16
 8c0:	e422                	sd	s0,8(sp)
 8c2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8c4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c8:	00000797          	auipc	a5,0x0
 8cc:	7387b783          	ld	a5,1848(a5) # 1000 <freep>
 8d0:	a02d                	j	8fa <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8d2:	4618                	lw	a4,8(a2)
 8d4:	9f2d                	addw	a4,a4,a1
 8d6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8da:	6398                	ld	a4,0(a5)
 8dc:	6310                	ld	a2,0(a4)
 8de:	a83d                	j	91c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8e0:	ff852703          	lw	a4,-8(a0)
 8e4:	9f31                	addw	a4,a4,a2
 8e6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8e8:	ff053683          	ld	a3,-16(a0)
 8ec:	a091                	j	930 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ee:	6398                	ld	a4,0(a5)
 8f0:	00e7e463          	bltu	a5,a4,8f8 <free+0x3a>
 8f4:	00e6ea63          	bltu	a3,a4,908 <free+0x4a>
{
 8f8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8fa:	fed7fae3          	bgeu	a5,a3,8ee <free+0x30>
 8fe:	6398                	ld	a4,0(a5)
 900:	00e6e463          	bltu	a3,a4,908 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 904:	fee7eae3          	bltu	a5,a4,8f8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 908:	ff852583          	lw	a1,-8(a0)
 90c:	6390                	ld	a2,0(a5)
 90e:	02059813          	slli	a6,a1,0x20
 912:	01c85713          	srli	a4,a6,0x1c
 916:	9736                	add	a4,a4,a3
 918:	fae60de3          	beq	a2,a4,8d2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 91c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 920:	4790                	lw	a2,8(a5)
 922:	02061593          	slli	a1,a2,0x20
 926:	01c5d713          	srli	a4,a1,0x1c
 92a:	973e                	add	a4,a4,a5
 92c:	fae68ae3          	beq	a3,a4,8e0 <free+0x22>
    p->s.ptr = bp->s.ptr;
 930:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 932:	00000717          	auipc	a4,0x0
 936:	6cf73723          	sd	a5,1742(a4) # 1000 <freep>
}
 93a:	6422                	ld	s0,8(sp)
 93c:	0141                	addi	sp,sp,16
 93e:	8082                	ret

0000000000000940 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 940:	7139                	addi	sp,sp,-64
 942:	fc06                	sd	ra,56(sp)
 944:	f822                	sd	s0,48(sp)
 946:	f426                	sd	s1,40(sp)
 948:	f04a                	sd	s2,32(sp)
 94a:	ec4e                	sd	s3,24(sp)
 94c:	e852                	sd	s4,16(sp)
 94e:	e456                	sd	s5,8(sp)
 950:	e05a                	sd	s6,0(sp)
 952:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 954:	02051493          	slli	s1,a0,0x20
 958:	9081                	srli	s1,s1,0x20
 95a:	04bd                	addi	s1,s1,15
 95c:	8091                	srli	s1,s1,0x4
 95e:	0014899b          	addiw	s3,s1,1
 962:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 964:	00000517          	auipc	a0,0x0
 968:	69c53503          	ld	a0,1692(a0) # 1000 <freep>
 96c:	c515                	beqz	a0,998 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 96e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 970:	4798                	lw	a4,8(a5)
 972:	02977f63          	bgeu	a4,s1,9b0 <malloc+0x70>
 976:	8a4e                	mv	s4,s3
 978:	0009871b          	sext.w	a4,s3
 97c:	6685                	lui	a3,0x1
 97e:	00d77363          	bgeu	a4,a3,984 <malloc+0x44>
 982:	6a05                	lui	s4,0x1
 984:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 988:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 98c:	00000917          	auipc	s2,0x0
 990:	67490913          	addi	s2,s2,1652 # 1000 <freep>
  if(p == (char*)-1)
 994:	5afd                	li	s5,-1
 996:	a895                	j	a0a <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 998:	00000797          	auipc	a5,0x0
 99c:	67878793          	addi	a5,a5,1656 # 1010 <base>
 9a0:	00000717          	auipc	a4,0x0
 9a4:	66f73023          	sd	a5,1632(a4) # 1000 <freep>
 9a8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9aa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9ae:	b7e1                	j	976 <malloc+0x36>
      if(p->s.size == nunits)
 9b0:	02e48c63          	beq	s1,a4,9e8 <malloc+0xa8>
        p->s.size -= nunits;
 9b4:	4137073b          	subw	a4,a4,s3
 9b8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9ba:	02071693          	slli	a3,a4,0x20
 9be:	01c6d713          	srli	a4,a3,0x1c
 9c2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9c4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9c8:	00000717          	auipc	a4,0x0
 9cc:	62a73c23          	sd	a0,1592(a4) # 1000 <freep>
      return (void*)(p + 1);
 9d0:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9d4:	70e2                	ld	ra,56(sp)
 9d6:	7442                	ld	s0,48(sp)
 9d8:	74a2                	ld	s1,40(sp)
 9da:	7902                	ld	s2,32(sp)
 9dc:	69e2                	ld	s3,24(sp)
 9de:	6a42                	ld	s4,16(sp)
 9e0:	6aa2                	ld	s5,8(sp)
 9e2:	6b02                	ld	s6,0(sp)
 9e4:	6121                	addi	sp,sp,64
 9e6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9e8:	6398                	ld	a4,0(a5)
 9ea:	e118                	sd	a4,0(a0)
 9ec:	bff1                	j	9c8 <malloc+0x88>
  hp->s.size = nu;
 9ee:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9f2:	0541                	addi	a0,a0,16
 9f4:	00000097          	auipc	ra,0x0
 9f8:	eca080e7          	jalr	-310(ra) # 8be <free>
  return freep;
 9fc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a00:	d971                	beqz	a0,9d4 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a02:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a04:	4798                	lw	a4,8(a5)
 a06:	fa9775e3          	bgeu	a4,s1,9b0 <malloc+0x70>
    if(p == freep)
 a0a:	00093703          	ld	a4,0(s2)
 a0e:	853e                	mv	a0,a5
 a10:	fef719e3          	bne	a4,a5,a02 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a14:	8552                	mv	a0,s4
 a16:	00000097          	auipc	ra,0x0
 a1a:	b80080e7          	jalr	-1152(ra) # 596 <sbrk>
  if(p == (char*)-1)
 a1e:	fd5518e3          	bne	a0,s5,9ee <malloc+0xae>
        return 0;
 a22:	4501                	li	a0,0
 a24:	bf45                	j	9d4 <malloc+0x94>
