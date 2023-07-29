
user/_kalloctest：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <ntas>:
  test3();
  exit(0);
}

int ntas(int print)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	892a                	mv	s2,a0
  int n;
  char *c;

  if (statistics(buf, SZ) <= 0) {
   e:	6585                	lui	a1,0x1
  10:	00001517          	auipc	a0,0x1
  14:	00050513          	mv	a0,a0
  18:	00001097          	auipc	ra,0x1
  1c:	bc8080e7          	jalr	-1080(ra) # be0 <statistics>
  20:	02a05b63          	blez	a0,56 <ntas+0x56>
    fprintf(2, "ntas: no stats\n");
  }
  c = strchr(buf, '=');
  24:	03d00593          	li	a1,61
  28:	00001517          	auipc	a0,0x1
  2c:	fe850513          	addi	a0,a0,-24 # 1010 <buf>
  30:	00000097          	auipc	ra,0x0
  34:	4c0080e7          	jalr	1216(ra) # 4f0 <strchr>
  n = atoi(c+2);
  38:	0509                	addi	a0,a0,2
  3a:	00000097          	auipc	ra,0x0
  3e:	594080e7          	jalr	1428(ra) # 5ce <atoi>
  42:	84aa                	mv	s1,a0
  if(print)
  44:	02091363          	bnez	s2,6a <ntas+0x6a>
    printf("%s", buf);
  return n;
}
  48:	8526                	mv	a0,s1
  4a:	60e2                	ld	ra,24(sp)
  4c:	6442                	ld	s0,16(sp)
  4e:	64a2                	ld	s1,8(sp)
  50:	6902                	ld	s2,0(sp)
  52:	6105                	addi	sp,sp,32
  54:	8082                	ret
    fprintf(2, "ntas: no stats\n");
  56:	00001597          	auipc	a1,0x1
  5a:	c1a58593          	addi	a1,a1,-998 # c70 <statistics+0x90>
  5e:	4509                	li	a0,2
  60:	00001097          	auipc	ra,0x1
  64:	9b4080e7          	jalr	-1612(ra) # a14 <fprintf>
  68:	bf75                	j	24 <ntas+0x24>
    printf("%s", buf);
  6a:	00001597          	auipc	a1,0x1
  6e:	fa658593          	addi	a1,a1,-90 # 1010 <buf>
  72:	00001517          	auipc	a0,0x1
  76:	c0e50513          	addi	a0,a0,-1010 # c80 <statistics+0xa0>
  7a:	00001097          	auipc	ra,0x1
  7e:	9c8080e7          	jalr	-1592(ra) # a42 <printf>
  82:	b7d9                	j	48 <ntas+0x48>

0000000000000084 <test1>:

// Test concurrent kallocs and kfrees
void test1(void)
{
  84:	7179                	addi	sp,sp,-48
  86:	f406                	sd	ra,40(sp)
  88:	f022                	sd	s0,32(sp)
  8a:	ec26                	sd	s1,24(sp)
  8c:	e84a                	sd	s2,16(sp)
  8e:	e44e                	sd	s3,8(sp)
  90:	1800                	addi	s0,sp,48
  void *a, *a1;
  int n, m;
  printf("start test1\n");  
  92:	00001517          	auipc	a0,0x1
  96:	bf650513          	addi	a0,a0,-1034 # c88 <statistics+0xa8>
  9a:	00001097          	auipc	ra,0x1
  9e:	9a8080e7          	jalr	-1624(ra) # a42 <printf>
  m = ntas(0);
  a2:	4501                	li	a0,0
  a4:	00000097          	auipc	ra,0x0
  a8:	f5c080e7          	jalr	-164(ra) # 0 <ntas>
  ac:	84aa                	mv	s1,a0
  for(int i = 0; i < NCHILD; i++){
    int pid = fork();
  ae:	00000097          	auipc	ra,0x0
  b2:	612080e7          	jalr	1554(ra) # 6c0 <fork>
    if(pid < 0){
  b6:	06054463          	bltz	a0,11e <test1+0x9a>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
  ba:	cd3d                	beqz	a0,138 <test1+0xb4>
    int pid = fork();
  bc:	00000097          	auipc	ra,0x0
  c0:	604080e7          	jalr	1540(ra) # 6c0 <fork>
    if(pid < 0){
  c4:	04054d63          	bltz	a0,11e <test1+0x9a>
    if(pid == 0){
  c8:	c925                	beqz	a0,138 <test1+0xb4>
      exit(-1);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
  ca:	4501                	li	a0,0
  cc:	00000097          	auipc	ra,0x0
  d0:	604080e7          	jalr	1540(ra) # 6d0 <wait>
  d4:	4501                	li	a0,0
  d6:	00000097          	auipc	ra,0x0
  da:	5fa080e7          	jalr	1530(ra) # 6d0 <wait>
  }
  printf("test1 results:\n");
  de:	00001517          	auipc	a0,0x1
  e2:	bda50513          	addi	a0,a0,-1062 # cb8 <statistics+0xd8>
  e6:	00001097          	auipc	ra,0x1
  ea:	95c080e7          	jalr	-1700(ra) # a42 <printf>
  n = ntas(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	f10080e7          	jalr	-240(ra) # 0 <ntas>
  if(n-m < 10) 
  f8:	9d05                	subw	a0,a0,s1
  fa:	47a5                	li	a5,9
  fc:	08a7c863          	blt	a5,a0,18c <test1+0x108>
    printf("test1 OK\n");
 100:	00001517          	auipc	a0,0x1
 104:	bc850513          	addi	a0,a0,-1080 # cc8 <statistics+0xe8>
 108:	00001097          	auipc	ra,0x1
 10c:	93a080e7          	jalr	-1734(ra) # a42 <printf>
  else
    printf("test1 FAIL\n");
}
 110:	70a2                	ld	ra,40(sp)
 112:	7402                	ld	s0,32(sp)
 114:	64e2                	ld	s1,24(sp)
 116:	6942                	ld	s2,16(sp)
 118:	69a2                	ld	s3,8(sp)
 11a:	6145                	addi	sp,sp,48
 11c:	8082                	ret
      printf("fork failed");
 11e:	00001517          	auipc	a0,0x1
 122:	b7a50513          	addi	a0,a0,-1158 # c98 <statistics+0xb8>
 126:	00001097          	auipc	ra,0x1
 12a:	91c080e7          	jalr	-1764(ra) # a42 <printf>
      exit(-1);
 12e:	557d                	li	a0,-1
 130:	00000097          	auipc	ra,0x0
 134:	598080e7          	jalr	1432(ra) # 6c8 <exit>
{
 138:	6961                	lui	s2,0x18
 13a:	6a090913          	addi	s2,s2,1696 # 186a0 <base+0x16690>
        *(int *)(a+4) = 1;
 13e:	4985                	li	s3,1
        a = sbrk(4096);
 140:	6505                	lui	a0,0x1
 142:	00000097          	auipc	ra,0x0
 146:	60e080e7          	jalr	1550(ra) # 750 <sbrk>
 14a:	84aa                	mv	s1,a0
        *(int *)(a+4) = 1;
 14c:	01352223          	sw	s3,4(a0) # 1004 <freep+0x4>
        a1 = sbrk(-4096);
 150:	757d                	lui	a0,0xfffff
 152:	00000097          	auipc	ra,0x0
 156:	5fe080e7          	jalr	1534(ra) # 750 <sbrk>
        if (a1 != a + 4096) {
 15a:	6785                	lui	a5,0x1
 15c:	94be                	add	s1,s1,a5
 15e:	00951a63          	bne	a0,s1,172 <test1+0xee>
      for(i = 0; i < N; i++) {
 162:	397d                	addiw	s2,s2,-1
 164:	fc091ee3          	bnez	s2,140 <test1+0xbc>
      exit(-1);
 168:	557d                	li	a0,-1
 16a:	00000097          	auipc	ra,0x0
 16e:	55e080e7          	jalr	1374(ra) # 6c8 <exit>
          printf("wrong sbrk\n");
 172:	00001517          	auipc	a0,0x1
 176:	b3650513          	addi	a0,a0,-1226 # ca8 <statistics+0xc8>
 17a:	00001097          	auipc	ra,0x1
 17e:	8c8080e7          	jalr	-1848(ra) # a42 <printf>
          exit(-1);
 182:	557d                	li	a0,-1
 184:	00000097          	auipc	ra,0x0
 188:	544080e7          	jalr	1348(ra) # 6c8 <exit>
    printf("test1 FAIL\n");
 18c:	00001517          	auipc	a0,0x1
 190:	b4c50513          	addi	a0,a0,-1204 # cd8 <statistics+0xf8>
 194:	00001097          	auipc	ra,0x1
 198:	8ae080e7          	jalr	-1874(ra) # a42 <printf>
}
 19c:	bf95                	j	110 <test1+0x8c>

000000000000019e <countfree>:
//
// countfree() from usertests.c
//
int
countfree()
{
 19e:	7179                	addi	sp,sp,-48
 1a0:	f406                	sd	ra,40(sp)
 1a2:	f022                	sd	s0,32(sp)
 1a4:	ec26                	sd	s1,24(sp)
 1a6:	e84a                	sd	s2,16(sp)
 1a8:	e44e                	sd	s3,8(sp)
 1aa:	e052                	sd	s4,0(sp)
 1ac:	1800                	addi	s0,sp,48
  uint64 sz0 = (uint64)sbrk(0);
 1ae:	4501                	li	a0,0
 1b0:	00000097          	auipc	ra,0x0
 1b4:	5a0080e7          	jalr	1440(ra) # 750 <sbrk>
 1b8:	8a2a                	mv	s4,a0
  int n = 0;
 1ba:	4481                	li	s1,0

  while(1){
    uint64 a = (uint64) sbrk(4096);
    if(a == 0xffffffffffffffff){
 1bc:	597d                	li	s2,-1
      break;
    }
    // modify the memory to make sure it's really allocated.
    *(char *)(a + 4096 - 1) = 1;
 1be:	4985                	li	s3,1
 1c0:	a031                	j	1cc <countfree+0x2e>
 1c2:	6785                	lui	a5,0x1
 1c4:	97aa                	add	a5,a5,a0
 1c6:	ff378fa3          	sb	s3,-1(a5) # fff <digits+0x1df>
    n += 1;
 1ca:	2485                	addiw	s1,s1,1
    uint64 a = (uint64) sbrk(4096);
 1cc:	6505                	lui	a0,0x1
 1ce:	00000097          	auipc	ra,0x0
 1d2:	582080e7          	jalr	1410(ra) # 750 <sbrk>
    if(a == 0xffffffffffffffff){
 1d6:	ff2516e3          	bne	a0,s2,1c2 <countfree+0x24>
  }
  sbrk(-((uint64)sbrk(0) - sz0));
 1da:	4501                	li	a0,0
 1dc:	00000097          	auipc	ra,0x0
 1e0:	574080e7          	jalr	1396(ra) # 750 <sbrk>
 1e4:	40aa053b          	subw	a0,s4,a0
 1e8:	00000097          	auipc	ra,0x0
 1ec:	568080e7          	jalr	1384(ra) # 750 <sbrk>
  return n;
}
 1f0:	8526                	mv	a0,s1
 1f2:	70a2                	ld	ra,40(sp)
 1f4:	7402                	ld	s0,32(sp)
 1f6:	64e2                	ld	s1,24(sp)
 1f8:	6942                	ld	s2,16(sp)
 1fa:	69a2                	ld	s3,8(sp)
 1fc:	6a02                	ld	s4,0(sp)
 1fe:	6145                	addi	sp,sp,48
 200:	8082                	ret

0000000000000202 <test2>:

// Test stealing
void test2() {
 202:	715d                	addi	sp,sp,-80
 204:	e486                	sd	ra,72(sp)
 206:	e0a2                	sd	s0,64(sp)
 208:	fc26                	sd	s1,56(sp)
 20a:	f84a                	sd	s2,48(sp)
 20c:	f44e                	sd	s3,40(sp)
 20e:	f052                	sd	s4,32(sp)
 210:	ec56                	sd	s5,24(sp)
 212:	e85a                	sd	s6,16(sp)
 214:	e45e                	sd	s7,8(sp)
 216:	e062                	sd	s8,0(sp)
 218:	0880                	addi	s0,sp,80
  int free0 = countfree();
 21a:	00000097          	auipc	ra,0x0
 21e:	f84080e7          	jalr	-124(ra) # 19e <countfree>
 222:	8a2a                	mv	s4,a0
  int free1;
  int n = (PHYSTOP-KERNBASE)/PGSIZE;
  printf("start test2\n");  
 224:	00001517          	auipc	a0,0x1
 228:	ac450513          	addi	a0,a0,-1340 # ce8 <statistics+0x108>
 22c:	00001097          	auipc	ra,0x1
 230:	816080e7          	jalr	-2026(ra) # a42 <printf>
  printf("total free number of pages: %d (out of %d)\n", free0, n);
 234:	6621                	lui	a2,0x8
 236:	85d2                	mv	a1,s4
 238:	00001517          	auipc	a0,0x1
 23c:	ac050513          	addi	a0,a0,-1344 # cf8 <statistics+0x118>
 240:	00001097          	auipc	ra,0x1
 244:	802080e7          	jalr	-2046(ra) # a42 <printf>
  if(n - free0 > 1000) {
 248:	67a1                	lui	a5,0x8
 24a:	414787bb          	subw	a5,a5,s4
 24e:	3e800713          	li	a4,1000
 252:	02f74163          	blt	a4,a5,274 <test2+0x72>
    printf("test2 FAILED: cannot allocate enough memory");
    exit(-1);
  }
  for (int i = 0; i < 50; i++) {
    free1 = countfree();
 256:	00000097          	auipc	ra,0x0
 25a:	f48080e7          	jalr	-184(ra) # 19e <countfree>
 25e:	892a                	mv	s2,a0
  for (int i = 0; i < 50; i++) {
 260:	4981                	li	s3,0
 262:	03200a93          	li	s5,50
    if(i % 10 == 9)
 266:	4ba9                	li	s7,10
 268:	4b25                	li	s6,9
      printf(".");
 26a:	00001c17          	auipc	s8,0x1
 26e:	aeec0c13          	addi	s8,s8,-1298 # d58 <statistics+0x178>
 272:	a01d                	j	298 <test2+0x96>
    printf("test2 FAILED: cannot allocate enough memory");
 274:	00001517          	auipc	a0,0x1
 278:	ab450513          	addi	a0,a0,-1356 # d28 <statistics+0x148>
 27c:	00000097          	auipc	ra,0x0
 280:	7c6080e7          	jalr	1990(ra) # a42 <printf>
    exit(-1);
 284:	557d                	li	a0,-1
 286:	00000097          	auipc	ra,0x0
 28a:	442080e7          	jalr	1090(ra) # 6c8 <exit>
      printf(".");
 28e:	8562                	mv	a0,s8
 290:	00000097          	auipc	ra,0x0
 294:	7b2080e7          	jalr	1970(ra) # a42 <printf>
    if(free1 != free0) {
 298:	032a1263          	bne	s4,s2,2bc <test2+0xba>
  for (int i = 0; i < 50; i++) {
 29c:	0019849b          	addiw	s1,s3,1
 2a0:	0004899b          	sext.w	s3,s1
 2a4:	03598963          	beq	s3,s5,2d6 <test2+0xd4>
    free1 = countfree();
 2a8:	00000097          	auipc	ra,0x0
 2ac:	ef6080e7          	jalr	-266(ra) # 19e <countfree>
 2b0:	892a                	mv	s2,a0
    if(i % 10 == 9)
 2b2:	0374e4bb          	remw	s1,s1,s7
 2b6:	ff6491e3          	bne	s1,s6,298 <test2+0x96>
 2ba:	bfd1                	j	28e <test2+0x8c>
      printf("test2 FAIL: losing pages\n");
 2bc:	00001517          	auipc	a0,0x1
 2c0:	aa450513          	addi	a0,a0,-1372 # d60 <statistics+0x180>
 2c4:	00000097          	auipc	ra,0x0
 2c8:	77e080e7          	jalr	1918(ra) # a42 <printf>
      exit(-1);
 2cc:	557d                	li	a0,-1
 2ce:	00000097          	auipc	ra,0x0
 2d2:	3fa080e7          	jalr	1018(ra) # 6c8 <exit>
    }
  }
  printf("\ntest2 OK\n");  
 2d6:	00001517          	auipc	a0,0x1
 2da:	aaa50513          	addi	a0,a0,-1366 # d80 <statistics+0x1a0>
 2de:	00000097          	auipc	ra,0x0
 2e2:	764080e7          	jalr	1892(ra) # a42 <printf>
}
 2e6:	60a6                	ld	ra,72(sp)
 2e8:	6406                	ld	s0,64(sp)
 2ea:	74e2                	ld	s1,56(sp)
 2ec:	7942                	ld	s2,48(sp)
 2ee:	79a2                	ld	s3,40(sp)
 2f0:	7a02                	ld	s4,32(sp)
 2f2:	6ae2                	ld	s5,24(sp)
 2f4:	6b42                	ld	s6,16(sp)
 2f6:	6ba2                	ld	s7,8(sp)
 2f8:	6c02                	ld	s8,0(sp)
 2fa:	6161                	addi	sp,sp,80
 2fc:	8082                	ret

00000000000002fe <test3>:

// Test concurrent kalloc/kfree and stealing
void test3(void)
{
 2fe:	7179                	addi	sp,sp,-48
 300:	f406                	sd	ra,40(sp)
 302:	f022                	sd	s0,32(sp)
 304:	ec26                	sd	s1,24(sp)
 306:	e84a                	sd	s2,16(sp)
 308:	e44e                	sd	s3,8(sp)
 30a:	e052                	sd	s4,0(sp)
 30c:	1800                	addi	s0,sp,48
  void *a, *a1;
  printf("start test3\n");  
 30e:	00001517          	auipc	a0,0x1
 312:	a8250513          	addi	a0,a0,-1406 # d90 <statistics+0x1b0>
 316:	00000097          	auipc	ra,0x0
 31a:	72c080e7          	jalr	1836(ra) # a42 <printf>
  for(int i = 0; i < NCHILD; i++){
    int pid = fork();
 31e:	00000097          	auipc	ra,0x0
 322:	3a2080e7          	jalr	930(ra) # 6c0 <fork>
    if(pid < 0){
 326:	04054963          	bltz	a0,378 <test3+0x7a>
 32a:	892a                	mv	s2,a0
    }
    if(pid == 0){
      if (i == 0) {
        for(i = 0; i < N; i++) {
          a = sbrk(4096);
          *(int *)(a+4) = 1;
 32c:	4a05                	li	s4,1
        for(i = 0; i < N; i++) {
 32e:	69e1                	lui	s3,0x18
 330:	6a098993          	addi	s3,s3,1696 # 186a0 <base+0x16690>
    if(pid == 0){
 334:	cd39                	beqz	a0,392 <test3+0x94>
    int pid = fork();
 336:	00000097          	auipc	ra,0x0
 33a:	38a080e7          	jalr	906(ra) # 6c0 <fork>
    if(pid < 0){
 33e:	02054d63          	bltz	a0,378 <test3+0x7a>
    if(pid == 0){
 342:	c94d                	beqz	a0,3f4 <test3+0xf6>
      }
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
 344:	4501                	li	a0,0
 346:	00000097          	auipc	ra,0x0
 34a:	38a080e7          	jalr	906(ra) # 6d0 <wait>
 34e:	4501                	li	a0,0
 350:	00000097          	auipc	ra,0x0
 354:	380080e7          	jalr	896(ra) # 6d0 <wait>
  }
  printf("test3 OK\n");
 358:	00001517          	auipc	a0,0x1
 35c:	a5850513          	addi	a0,a0,-1448 # db0 <statistics+0x1d0>
 360:	00000097          	auipc	ra,0x0
 364:	6e2080e7          	jalr	1762(ra) # a42 <printf>
}
 368:	70a2                	ld	ra,40(sp)
 36a:	7402                	ld	s0,32(sp)
 36c:	64e2                	ld	s1,24(sp)
 36e:	6942                	ld	s2,16(sp)
 370:	69a2                	ld	s3,8(sp)
 372:	6a02                	ld	s4,0(sp)
 374:	6145                	addi	sp,sp,48
 376:	8082                	ret
      printf("fork failed");
 378:	00001517          	auipc	a0,0x1
 37c:	92050513          	addi	a0,a0,-1760 # c98 <statistics+0xb8>
 380:	00000097          	auipc	ra,0x0
 384:	6c2080e7          	jalr	1730(ra) # a42 <printf>
      exit(-1);
 388:	557d                	li	a0,-1
 38a:	00000097          	auipc	ra,0x0
 38e:	33e080e7          	jalr	830(ra) # 6c8 <exit>
          a = sbrk(4096);
 392:	6505                	lui	a0,0x1
 394:	00000097          	auipc	ra,0x0
 398:	3bc080e7          	jalr	956(ra) # 750 <sbrk>
 39c:	84aa                	mv	s1,a0
          *(int *)(a+4) = 1;
 39e:	01452223          	sw	s4,4(a0) # 1004 <freep+0x4>
          a1 = sbrk(-4096);
 3a2:	757d                	lui	a0,0xfffff
 3a4:	00000097          	auipc	ra,0x0
 3a8:	3ac080e7          	jalr	940(ra) # 750 <sbrk>
          if (a1 != a + 4096) {
 3ac:	6785                	lui	a5,0x1
 3ae:	94be                	add	s1,s1,a5
 3b0:	02951563          	bne	a0,s1,3da <test3+0xdc>
        for(i = 0; i < N; i++) {
 3b4:	2905                	addiw	s2,s2,1
 3b6:	fd391ee3          	bne	s2,s3,392 <test3+0x94>
        printf("child done %d\n", i);
 3ba:	65e1                	lui	a1,0x18
 3bc:	6a058593          	addi	a1,a1,1696 # 186a0 <base+0x16690>
 3c0:	00001517          	auipc	a0,0x1
 3c4:	9e050513          	addi	a0,a0,-1568 # da0 <statistics+0x1c0>
 3c8:	00000097          	auipc	ra,0x0
 3cc:	67a080e7          	jalr	1658(ra) # a42 <printf>
        exit(0);
 3d0:	4501                	li	a0,0
 3d2:	00000097          	auipc	ra,0x0
 3d6:	2f6080e7          	jalr	758(ra) # 6c8 <exit>
            printf("wrong sbrk\n");
 3da:	00001517          	auipc	a0,0x1
 3de:	8ce50513          	addi	a0,a0,-1842 # ca8 <statistics+0xc8>
 3e2:	00000097          	auipc	ra,0x0
 3e6:	660080e7          	jalr	1632(ra) # a42 <printf>
            exit(-1);
 3ea:	557d                	li	a0,-1
 3ec:	00000097          	auipc	ra,0x0
 3f0:	2dc080e7          	jalr	732(ra) # 6c8 <exit>
        countfree();
 3f4:	00000097          	auipc	ra,0x0
 3f8:	daa080e7          	jalr	-598(ra) # 19e <countfree>
        printf("child done %d\n", i);
 3fc:	4585                	li	a1,1
 3fe:	00001517          	auipc	a0,0x1
 402:	9a250513          	addi	a0,a0,-1630 # da0 <statistics+0x1c0>
 406:	00000097          	auipc	ra,0x0
 40a:	63c080e7          	jalr	1596(ra) # a42 <printf>
        exit(0);
 40e:	4501                	li	a0,0
 410:	00000097          	auipc	ra,0x0
 414:	2b8080e7          	jalr	696(ra) # 6c8 <exit>

0000000000000418 <main>:
{
 418:	1141                	addi	sp,sp,-16
 41a:	e406                	sd	ra,8(sp)
 41c:	e022                	sd	s0,0(sp)
 41e:	0800                	addi	s0,sp,16
  test1();
 420:	00000097          	auipc	ra,0x0
 424:	c64080e7          	jalr	-924(ra) # 84 <test1>
  test2();
 428:	00000097          	auipc	ra,0x0
 42c:	dda080e7          	jalr	-550(ra) # 202 <test2>
  test3();
 430:	00000097          	auipc	ra,0x0
 434:	ece080e7          	jalr	-306(ra) # 2fe <test3>
  exit(0);
 438:	4501                	li	a0,0
 43a:	00000097          	auipc	ra,0x0
 43e:	28e080e7          	jalr	654(ra) # 6c8 <exit>

0000000000000442 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 442:	1141                	addi	sp,sp,-16
 444:	e406                	sd	ra,8(sp)
 446:	e022                	sd	s0,0(sp)
 448:	0800                	addi	s0,sp,16
  extern int main();
  main();
 44a:	00000097          	auipc	ra,0x0
 44e:	fce080e7          	jalr	-50(ra) # 418 <main>
  exit(0);
 452:	4501                	li	a0,0
 454:	00000097          	auipc	ra,0x0
 458:	274080e7          	jalr	628(ra) # 6c8 <exit>

000000000000045c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 45c:	1141                	addi	sp,sp,-16
 45e:	e422                	sd	s0,8(sp)
 460:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 462:	87aa                	mv	a5,a0
 464:	0585                	addi	a1,a1,1
 466:	0785                	addi	a5,a5,1 # 1001 <freep+0x1>
 468:	fff5c703          	lbu	a4,-1(a1)
 46c:	fee78fa3          	sb	a4,-1(a5)
 470:	fb75                	bnez	a4,464 <strcpy+0x8>
    ;
  return os;
}
 472:	6422                	ld	s0,8(sp)
 474:	0141                	addi	sp,sp,16
 476:	8082                	ret

0000000000000478 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 478:	1141                	addi	sp,sp,-16
 47a:	e422                	sd	s0,8(sp)
 47c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 47e:	00054783          	lbu	a5,0(a0)
 482:	cb91                	beqz	a5,496 <strcmp+0x1e>
 484:	0005c703          	lbu	a4,0(a1)
 488:	00f71763          	bne	a4,a5,496 <strcmp+0x1e>
    p++, q++;
 48c:	0505                	addi	a0,a0,1
 48e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 490:	00054783          	lbu	a5,0(a0)
 494:	fbe5                	bnez	a5,484 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 496:	0005c503          	lbu	a0,0(a1)
}
 49a:	40a7853b          	subw	a0,a5,a0
 49e:	6422                	ld	s0,8(sp)
 4a0:	0141                	addi	sp,sp,16
 4a2:	8082                	ret

00000000000004a4 <strlen>:

uint
strlen(const char *s)
{
 4a4:	1141                	addi	sp,sp,-16
 4a6:	e422                	sd	s0,8(sp)
 4a8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 4aa:	00054783          	lbu	a5,0(a0)
 4ae:	cf91                	beqz	a5,4ca <strlen+0x26>
 4b0:	0505                	addi	a0,a0,1
 4b2:	87aa                	mv	a5,a0
 4b4:	4685                	li	a3,1
 4b6:	9e89                	subw	a3,a3,a0
 4b8:	00f6853b          	addw	a0,a3,a5
 4bc:	0785                	addi	a5,a5,1
 4be:	fff7c703          	lbu	a4,-1(a5)
 4c2:	fb7d                	bnez	a4,4b8 <strlen+0x14>
    ;
  return n;
}
 4c4:	6422                	ld	s0,8(sp)
 4c6:	0141                	addi	sp,sp,16
 4c8:	8082                	ret
  for(n = 0; s[n]; n++)
 4ca:	4501                	li	a0,0
 4cc:	bfe5                	j	4c4 <strlen+0x20>

00000000000004ce <memset>:

void*
memset(void *dst, int c, uint n)
{
 4ce:	1141                	addi	sp,sp,-16
 4d0:	e422                	sd	s0,8(sp)
 4d2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 4d4:	ca19                	beqz	a2,4ea <memset+0x1c>
 4d6:	87aa                	mv	a5,a0
 4d8:	1602                	slli	a2,a2,0x20
 4da:	9201                	srli	a2,a2,0x20
 4dc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 4e0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 4e4:	0785                	addi	a5,a5,1
 4e6:	fee79de3          	bne	a5,a4,4e0 <memset+0x12>
  }
  return dst;
}
 4ea:	6422                	ld	s0,8(sp)
 4ec:	0141                	addi	sp,sp,16
 4ee:	8082                	ret

00000000000004f0 <strchr>:

char*
strchr(const char *s, char c)
{
 4f0:	1141                	addi	sp,sp,-16
 4f2:	e422                	sd	s0,8(sp)
 4f4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 4f6:	00054783          	lbu	a5,0(a0)
 4fa:	cb99                	beqz	a5,510 <strchr+0x20>
    if(*s == c)
 4fc:	00f58763          	beq	a1,a5,50a <strchr+0x1a>
  for(; *s; s++)
 500:	0505                	addi	a0,a0,1
 502:	00054783          	lbu	a5,0(a0)
 506:	fbfd                	bnez	a5,4fc <strchr+0xc>
      return (char*)s;
  return 0;
 508:	4501                	li	a0,0
}
 50a:	6422                	ld	s0,8(sp)
 50c:	0141                	addi	sp,sp,16
 50e:	8082                	ret
  return 0;
 510:	4501                	li	a0,0
 512:	bfe5                	j	50a <strchr+0x1a>

0000000000000514 <gets>:

char*
gets(char *buf, int max)
{
 514:	711d                	addi	sp,sp,-96
 516:	ec86                	sd	ra,88(sp)
 518:	e8a2                	sd	s0,80(sp)
 51a:	e4a6                	sd	s1,72(sp)
 51c:	e0ca                	sd	s2,64(sp)
 51e:	fc4e                	sd	s3,56(sp)
 520:	f852                	sd	s4,48(sp)
 522:	f456                	sd	s5,40(sp)
 524:	f05a                	sd	s6,32(sp)
 526:	ec5e                	sd	s7,24(sp)
 528:	1080                	addi	s0,sp,96
 52a:	8baa                	mv	s7,a0
 52c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 52e:	892a                	mv	s2,a0
 530:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 532:	4aa9                	li	s5,10
 534:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 536:	89a6                	mv	s3,s1
 538:	2485                	addiw	s1,s1,1
 53a:	0344d863          	bge	s1,s4,56a <gets+0x56>
    cc = read(0, &c, 1);
 53e:	4605                	li	a2,1
 540:	faf40593          	addi	a1,s0,-81
 544:	4501                	li	a0,0
 546:	00000097          	auipc	ra,0x0
 54a:	19a080e7          	jalr	410(ra) # 6e0 <read>
    if(cc < 1)
 54e:	00a05e63          	blez	a0,56a <gets+0x56>
    buf[i++] = c;
 552:	faf44783          	lbu	a5,-81(s0)
 556:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 55a:	01578763          	beq	a5,s5,568 <gets+0x54>
 55e:	0905                	addi	s2,s2,1
 560:	fd679be3          	bne	a5,s6,536 <gets+0x22>
  for(i=0; i+1 < max; ){
 564:	89a6                	mv	s3,s1
 566:	a011                	j	56a <gets+0x56>
 568:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 56a:	99de                	add	s3,s3,s7
 56c:	00098023          	sb	zero,0(s3)
  return buf;
}
 570:	855e                	mv	a0,s7
 572:	60e6                	ld	ra,88(sp)
 574:	6446                	ld	s0,80(sp)
 576:	64a6                	ld	s1,72(sp)
 578:	6906                	ld	s2,64(sp)
 57a:	79e2                	ld	s3,56(sp)
 57c:	7a42                	ld	s4,48(sp)
 57e:	7aa2                	ld	s5,40(sp)
 580:	7b02                	ld	s6,32(sp)
 582:	6be2                	ld	s7,24(sp)
 584:	6125                	addi	sp,sp,96
 586:	8082                	ret

0000000000000588 <stat>:

int
stat(const char *n, struct stat *st)
{
 588:	1101                	addi	sp,sp,-32
 58a:	ec06                	sd	ra,24(sp)
 58c:	e822                	sd	s0,16(sp)
 58e:	e426                	sd	s1,8(sp)
 590:	e04a                	sd	s2,0(sp)
 592:	1000                	addi	s0,sp,32
 594:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 596:	4581                	li	a1,0
 598:	00000097          	auipc	ra,0x0
 59c:	170080e7          	jalr	368(ra) # 708 <open>
  if(fd < 0)
 5a0:	02054563          	bltz	a0,5ca <stat+0x42>
 5a4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5a6:	85ca                	mv	a1,s2
 5a8:	00000097          	auipc	ra,0x0
 5ac:	178080e7          	jalr	376(ra) # 720 <fstat>
 5b0:	892a                	mv	s2,a0
  close(fd);
 5b2:	8526                	mv	a0,s1
 5b4:	00000097          	auipc	ra,0x0
 5b8:	13c080e7          	jalr	316(ra) # 6f0 <close>
  return r;
}
 5bc:	854a                	mv	a0,s2
 5be:	60e2                	ld	ra,24(sp)
 5c0:	6442                	ld	s0,16(sp)
 5c2:	64a2                	ld	s1,8(sp)
 5c4:	6902                	ld	s2,0(sp)
 5c6:	6105                	addi	sp,sp,32
 5c8:	8082                	ret
    return -1;
 5ca:	597d                	li	s2,-1
 5cc:	bfc5                	j	5bc <stat+0x34>

00000000000005ce <atoi>:

int
atoi(const char *s)
{
 5ce:	1141                	addi	sp,sp,-16
 5d0:	e422                	sd	s0,8(sp)
 5d2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5d4:	00054683          	lbu	a3,0(a0)
 5d8:	fd06879b          	addiw	a5,a3,-48
 5dc:	0ff7f793          	zext.b	a5,a5
 5e0:	4625                	li	a2,9
 5e2:	02f66863          	bltu	a2,a5,612 <atoi+0x44>
 5e6:	872a                	mv	a4,a0
  n = 0;
 5e8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 5ea:	0705                	addi	a4,a4,1
 5ec:	0025179b          	slliw	a5,a0,0x2
 5f0:	9fa9                	addw	a5,a5,a0
 5f2:	0017979b          	slliw	a5,a5,0x1
 5f6:	9fb5                	addw	a5,a5,a3
 5f8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 5fc:	00074683          	lbu	a3,0(a4)
 600:	fd06879b          	addiw	a5,a3,-48
 604:	0ff7f793          	zext.b	a5,a5
 608:	fef671e3          	bgeu	a2,a5,5ea <atoi+0x1c>
  return n;
}
 60c:	6422                	ld	s0,8(sp)
 60e:	0141                	addi	sp,sp,16
 610:	8082                	ret
  n = 0;
 612:	4501                	li	a0,0
 614:	bfe5                	j	60c <atoi+0x3e>

0000000000000616 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 616:	1141                	addi	sp,sp,-16
 618:	e422                	sd	s0,8(sp)
 61a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 61c:	02b57463          	bgeu	a0,a1,644 <memmove+0x2e>
    while(n-- > 0)
 620:	00c05f63          	blez	a2,63e <memmove+0x28>
 624:	1602                	slli	a2,a2,0x20
 626:	9201                	srli	a2,a2,0x20
 628:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 62c:	872a                	mv	a4,a0
      *dst++ = *src++;
 62e:	0585                	addi	a1,a1,1
 630:	0705                	addi	a4,a4,1
 632:	fff5c683          	lbu	a3,-1(a1)
 636:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 63a:	fee79ae3          	bne	a5,a4,62e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 63e:	6422                	ld	s0,8(sp)
 640:	0141                	addi	sp,sp,16
 642:	8082                	ret
    dst += n;
 644:	00c50733          	add	a4,a0,a2
    src += n;
 648:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 64a:	fec05ae3          	blez	a2,63e <memmove+0x28>
 64e:	fff6079b          	addiw	a5,a2,-1 # 7fff <base+0x5fef>
 652:	1782                	slli	a5,a5,0x20
 654:	9381                	srli	a5,a5,0x20
 656:	fff7c793          	not	a5,a5
 65a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 65c:	15fd                	addi	a1,a1,-1
 65e:	177d                	addi	a4,a4,-1
 660:	0005c683          	lbu	a3,0(a1)
 664:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 668:	fee79ae3          	bne	a5,a4,65c <memmove+0x46>
 66c:	bfc9                	j	63e <memmove+0x28>

000000000000066e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 66e:	1141                	addi	sp,sp,-16
 670:	e422                	sd	s0,8(sp)
 672:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 674:	ca05                	beqz	a2,6a4 <memcmp+0x36>
 676:	fff6069b          	addiw	a3,a2,-1
 67a:	1682                	slli	a3,a3,0x20
 67c:	9281                	srli	a3,a3,0x20
 67e:	0685                	addi	a3,a3,1
 680:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 682:	00054783          	lbu	a5,0(a0)
 686:	0005c703          	lbu	a4,0(a1)
 68a:	00e79863          	bne	a5,a4,69a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 68e:	0505                	addi	a0,a0,1
    p2++;
 690:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 692:	fed518e3          	bne	a0,a3,682 <memcmp+0x14>
  }
  return 0;
 696:	4501                	li	a0,0
 698:	a019                	j	69e <memcmp+0x30>
      return *p1 - *p2;
 69a:	40e7853b          	subw	a0,a5,a4
}
 69e:	6422                	ld	s0,8(sp)
 6a0:	0141                	addi	sp,sp,16
 6a2:	8082                	ret
  return 0;
 6a4:	4501                	li	a0,0
 6a6:	bfe5                	j	69e <memcmp+0x30>

00000000000006a8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6a8:	1141                	addi	sp,sp,-16
 6aa:	e406                	sd	ra,8(sp)
 6ac:	e022                	sd	s0,0(sp)
 6ae:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 6b0:	00000097          	auipc	ra,0x0
 6b4:	f66080e7          	jalr	-154(ra) # 616 <memmove>
}
 6b8:	60a2                	ld	ra,8(sp)
 6ba:	6402                	ld	s0,0(sp)
 6bc:	0141                	addi	sp,sp,16
 6be:	8082                	ret

00000000000006c0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6c0:	4885                	li	a7,1
 ecall
 6c2:	00000073          	ecall
 ret
 6c6:	8082                	ret

00000000000006c8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 6c8:	4889                	li	a7,2
 ecall
 6ca:	00000073          	ecall
 ret
 6ce:	8082                	ret

00000000000006d0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 6d0:	488d                	li	a7,3
 ecall
 6d2:	00000073          	ecall
 ret
 6d6:	8082                	ret

00000000000006d8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6d8:	4891                	li	a7,4
 ecall
 6da:	00000073          	ecall
 ret
 6de:	8082                	ret

00000000000006e0 <read>:
.global read
read:
 li a7, SYS_read
 6e0:	4895                	li	a7,5
 ecall
 6e2:	00000073          	ecall
 ret
 6e6:	8082                	ret

00000000000006e8 <write>:
.global write
write:
 li a7, SYS_write
 6e8:	48c1                	li	a7,16
 ecall
 6ea:	00000073          	ecall
 ret
 6ee:	8082                	ret

00000000000006f0 <close>:
.global close
close:
 li a7, SYS_close
 6f0:	48d5                	li	a7,21
 ecall
 6f2:	00000073          	ecall
 ret
 6f6:	8082                	ret

00000000000006f8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 6f8:	4899                	li	a7,6
 ecall
 6fa:	00000073          	ecall
 ret
 6fe:	8082                	ret

0000000000000700 <exec>:
.global exec
exec:
 li a7, SYS_exec
 700:	489d                	li	a7,7
 ecall
 702:	00000073          	ecall
 ret
 706:	8082                	ret

0000000000000708 <open>:
.global open
open:
 li a7, SYS_open
 708:	48bd                	li	a7,15
 ecall
 70a:	00000073          	ecall
 ret
 70e:	8082                	ret

0000000000000710 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 710:	48c5                	li	a7,17
 ecall
 712:	00000073          	ecall
 ret
 716:	8082                	ret

0000000000000718 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 718:	48c9                	li	a7,18
 ecall
 71a:	00000073          	ecall
 ret
 71e:	8082                	ret

0000000000000720 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 720:	48a1                	li	a7,8
 ecall
 722:	00000073          	ecall
 ret
 726:	8082                	ret

0000000000000728 <link>:
.global link
link:
 li a7, SYS_link
 728:	48cd                	li	a7,19
 ecall
 72a:	00000073          	ecall
 ret
 72e:	8082                	ret

0000000000000730 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 730:	48d1                	li	a7,20
 ecall
 732:	00000073          	ecall
 ret
 736:	8082                	ret

0000000000000738 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 738:	48a5                	li	a7,9
 ecall
 73a:	00000073          	ecall
 ret
 73e:	8082                	ret

0000000000000740 <dup>:
.global dup
dup:
 li a7, SYS_dup
 740:	48a9                	li	a7,10
 ecall
 742:	00000073          	ecall
 ret
 746:	8082                	ret

0000000000000748 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 748:	48ad                	li	a7,11
 ecall
 74a:	00000073          	ecall
 ret
 74e:	8082                	ret

0000000000000750 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 750:	48b1                	li	a7,12
 ecall
 752:	00000073          	ecall
 ret
 756:	8082                	ret

0000000000000758 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 758:	48b5                	li	a7,13
 ecall
 75a:	00000073          	ecall
 ret
 75e:	8082                	ret

0000000000000760 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 760:	48b9                	li	a7,14
 ecall
 762:	00000073          	ecall
 ret
 766:	8082                	ret

0000000000000768 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 768:	1101                	addi	sp,sp,-32
 76a:	ec06                	sd	ra,24(sp)
 76c:	e822                	sd	s0,16(sp)
 76e:	1000                	addi	s0,sp,32
 770:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 774:	4605                	li	a2,1
 776:	fef40593          	addi	a1,s0,-17
 77a:	00000097          	auipc	ra,0x0
 77e:	f6e080e7          	jalr	-146(ra) # 6e8 <write>
}
 782:	60e2                	ld	ra,24(sp)
 784:	6442                	ld	s0,16(sp)
 786:	6105                	addi	sp,sp,32
 788:	8082                	ret

000000000000078a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 78a:	7139                	addi	sp,sp,-64
 78c:	fc06                	sd	ra,56(sp)
 78e:	f822                	sd	s0,48(sp)
 790:	f426                	sd	s1,40(sp)
 792:	f04a                	sd	s2,32(sp)
 794:	ec4e                	sd	s3,24(sp)
 796:	0080                	addi	s0,sp,64
 798:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 79a:	c299                	beqz	a3,7a0 <printint+0x16>
 79c:	0805c963          	bltz	a1,82e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7a0:	2581                	sext.w	a1,a1
  neg = 0;
 7a2:	4881                	li	a7,0
 7a4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 7a8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7aa:	2601                	sext.w	a2,a2
 7ac:	00000517          	auipc	a0,0x0
 7b0:	67450513          	addi	a0,a0,1652 # e20 <digits>
 7b4:	883a                	mv	a6,a4
 7b6:	2705                	addiw	a4,a4,1
 7b8:	02c5f7bb          	remuw	a5,a1,a2
 7bc:	1782                	slli	a5,a5,0x20
 7be:	9381                	srli	a5,a5,0x20
 7c0:	97aa                	add	a5,a5,a0
 7c2:	0007c783          	lbu	a5,0(a5)
 7c6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 7ca:	0005879b          	sext.w	a5,a1
 7ce:	02c5d5bb          	divuw	a1,a1,a2
 7d2:	0685                	addi	a3,a3,1
 7d4:	fec7f0e3          	bgeu	a5,a2,7b4 <printint+0x2a>
  if(neg)
 7d8:	00088c63          	beqz	a7,7f0 <printint+0x66>
    buf[i++] = '-';
 7dc:	fd070793          	addi	a5,a4,-48
 7e0:	00878733          	add	a4,a5,s0
 7e4:	02d00793          	li	a5,45
 7e8:	fef70823          	sb	a5,-16(a4)
 7ec:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 7f0:	02e05863          	blez	a4,820 <printint+0x96>
 7f4:	fc040793          	addi	a5,s0,-64
 7f8:	00e78933          	add	s2,a5,a4
 7fc:	fff78993          	addi	s3,a5,-1
 800:	99ba                	add	s3,s3,a4
 802:	377d                	addiw	a4,a4,-1
 804:	1702                	slli	a4,a4,0x20
 806:	9301                	srli	a4,a4,0x20
 808:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 80c:	fff94583          	lbu	a1,-1(s2)
 810:	8526                	mv	a0,s1
 812:	00000097          	auipc	ra,0x0
 816:	f56080e7          	jalr	-170(ra) # 768 <putc>
  while(--i >= 0)
 81a:	197d                	addi	s2,s2,-1
 81c:	ff3918e3          	bne	s2,s3,80c <printint+0x82>
}
 820:	70e2                	ld	ra,56(sp)
 822:	7442                	ld	s0,48(sp)
 824:	74a2                	ld	s1,40(sp)
 826:	7902                	ld	s2,32(sp)
 828:	69e2                	ld	s3,24(sp)
 82a:	6121                	addi	sp,sp,64
 82c:	8082                	ret
    x = -xx;
 82e:	40b005bb          	negw	a1,a1
    neg = 1;
 832:	4885                	li	a7,1
    x = -xx;
 834:	bf85                	j	7a4 <printint+0x1a>

0000000000000836 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 836:	7119                	addi	sp,sp,-128
 838:	fc86                	sd	ra,120(sp)
 83a:	f8a2                	sd	s0,112(sp)
 83c:	f4a6                	sd	s1,104(sp)
 83e:	f0ca                	sd	s2,96(sp)
 840:	ecce                	sd	s3,88(sp)
 842:	e8d2                	sd	s4,80(sp)
 844:	e4d6                	sd	s5,72(sp)
 846:	e0da                	sd	s6,64(sp)
 848:	fc5e                	sd	s7,56(sp)
 84a:	f862                	sd	s8,48(sp)
 84c:	f466                	sd	s9,40(sp)
 84e:	f06a                	sd	s10,32(sp)
 850:	ec6e                	sd	s11,24(sp)
 852:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 854:	0005c903          	lbu	s2,0(a1)
 858:	18090f63          	beqz	s2,9f6 <vprintf+0x1c0>
 85c:	8aaa                	mv	s5,a0
 85e:	8b32                	mv	s6,a2
 860:	00158493          	addi	s1,a1,1
  state = 0;
 864:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 866:	02500a13          	li	s4,37
 86a:	4c55                	li	s8,21
 86c:	00000c97          	auipc	s9,0x0
 870:	55cc8c93          	addi	s9,s9,1372 # dc8 <statistics+0x1e8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 874:	02800d93          	li	s11,40
  putc(fd, 'x');
 878:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 87a:	00000b97          	auipc	s7,0x0
 87e:	5a6b8b93          	addi	s7,s7,1446 # e20 <digits>
 882:	a839                	j	8a0 <vprintf+0x6a>
        putc(fd, c);
 884:	85ca                	mv	a1,s2
 886:	8556                	mv	a0,s5
 888:	00000097          	auipc	ra,0x0
 88c:	ee0080e7          	jalr	-288(ra) # 768 <putc>
 890:	a019                	j	896 <vprintf+0x60>
    } else if(state == '%'){
 892:	01498d63          	beq	s3,s4,8ac <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 896:	0485                	addi	s1,s1,1
 898:	fff4c903          	lbu	s2,-1(s1)
 89c:	14090d63          	beqz	s2,9f6 <vprintf+0x1c0>
    if(state == 0){
 8a0:	fe0999e3          	bnez	s3,892 <vprintf+0x5c>
      if(c == '%'){
 8a4:	ff4910e3          	bne	s2,s4,884 <vprintf+0x4e>
        state = '%';
 8a8:	89d2                	mv	s3,s4
 8aa:	b7f5                	j	896 <vprintf+0x60>
      if(c == 'd'){
 8ac:	11490c63          	beq	s2,s4,9c4 <vprintf+0x18e>
 8b0:	f9d9079b          	addiw	a5,s2,-99
 8b4:	0ff7f793          	zext.b	a5,a5
 8b8:	10fc6e63          	bltu	s8,a5,9d4 <vprintf+0x19e>
 8bc:	f9d9079b          	addiw	a5,s2,-99
 8c0:	0ff7f713          	zext.b	a4,a5
 8c4:	10ec6863          	bltu	s8,a4,9d4 <vprintf+0x19e>
 8c8:	00271793          	slli	a5,a4,0x2
 8cc:	97e6                	add	a5,a5,s9
 8ce:	439c                	lw	a5,0(a5)
 8d0:	97e6                	add	a5,a5,s9
 8d2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 8d4:	008b0913          	addi	s2,s6,8
 8d8:	4685                	li	a3,1
 8da:	4629                	li	a2,10
 8dc:	000b2583          	lw	a1,0(s6)
 8e0:	8556                	mv	a0,s5
 8e2:	00000097          	auipc	ra,0x0
 8e6:	ea8080e7          	jalr	-344(ra) # 78a <printint>
 8ea:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 8ec:	4981                	li	s3,0
 8ee:	b765                	j	896 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8f0:	008b0913          	addi	s2,s6,8
 8f4:	4681                	li	a3,0
 8f6:	4629                	li	a2,10
 8f8:	000b2583          	lw	a1,0(s6)
 8fc:	8556                	mv	a0,s5
 8fe:	00000097          	auipc	ra,0x0
 902:	e8c080e7          	jalr	-372(ra) # 78a <printint>
 906:	8b4a                	mv	s6,s2
      state = 0;
 908:	4981                	li	s3,0
 90a:	b771                	j	896 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 90c:	008b0913          	addi	s2,s6,8
 910:	4681                	li	a3,0
 912:	866a                	mv	a2,s10
 914:	000b2583          	lw	a1,0(s6)
 918:	8556                	mv	a0,s5
 91a:	00000097          	auipc	ra,0x0
 91e:	e70080e7          	jalr	-400(ra) # 78a <printint>
 922:	8b4a                	mv	s6,s2
      state = 0;
 924:	4981                	li	s3,0
 926:	bf85                	j	896 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 928:	008b0793          	addi	a5,s6,8
 92c:	f8f43423          	sd	a5,-120(s0)
 930:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 934:	03000593          	li	a1,48
 938:	8556                	mv	a0,s5
 93a:	00000097          	auipc	ra,0x0
 93e:	e2e080e7          	jalr	-466(ra) # 768 <putc>
  putc(fd, 'x');
 942:	07800593          	li	a1,120
 946:	8556                	mv	a0,s5
 948:	00000097          	auipc	ra,0x0
 94c:	e20080e7          	jalr	-480(ra) # 768 <putc>
 950:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 952:	03c9d793          	srli	a5,s3,0x3c
 956:	97de                	add	a5,a5,s7
 958:	0007c583          	lbu	a1,0(a5)
 95c:	8556                	mv	a0,s5
 95e:	00000097          	auipc	ra,0x0
 962:	e0a080e7          	jalr	-502(ra) # 768 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 966:	0992                	slli	s3,s3,0x4
 968:	397d                	addiw	s2,s2,-1
 96a:	fe0914e3          	bnez	s2,952 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 96e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 972:	4981                	li	s3,0
 974:	b70d                	j	896 <vprintf+0x60>
        s = va_arg(ap, char*);
 976:	008b0913          	addi	s2,s6,8
 97a:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 97e:	02098163          	beqz	s3,9a0 <vprintf+0x16a>
        while(*s != 0){
 982:	0009c583          	lbu	a1,0(s3)
 986:	c5ad                	beqz	a1,9f0 <vprintf+0x1ba>
          putc(fd, *s);
 988:	8556                	mv	a0,s5
 98a:	00000097          	auipc	ra,0x0
 98e:	dde080e7          	jalr	-546(ra) # 768 <putc>
          s++;
 992:	0985                	addi	s3,s3,1
        while(*s != 0){
 994:	0009c583          	lbu	a1,0(s3)
 998:	f9e5                	bnez	a1,988 <vprintf+0x152>
        s = va_arg(ap, char*);
 99a:	8b4a                	mv	s6,s2
      state = 0;
 99c:	4981                	li	s3,0
 99e:	bde5                	j	896 <vprintf+0x60>
          s = "(null)";
 9a0:	00000997          	auipc	s3,0x0
 9a4:	42098993          	addi	s3,s3,1056 # dc0 <statistics+0x1e0>
        while(*s != 0){
 9a8:	85ee                	mv	a1,s11
 9aa:	bff9                	j	988 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 9ac:	008b0913          	addi	s2,s6,8
 9b0:	000b4583          	lbu	a1,0(s6)
 9b4:	8556                	mv	a0,s5
 9b6:	00000097          	auipc	ra,0x0
 9ba:	db2080e7          	jalr	-590(ra) # 768 <putc>
 9be:	8b4a                	mv	s6,s2
      state = 0;
 9c0:	4981                	li	s3,0
 9c2:	bdd1                	j	896 <vprintf+0x60>
        putc(fd, c);
 9c4:	85d2                	mv	a1,s4
 9c6:	8556                	mv	a0,s5
 9c8:	00000097          	auipc	ra,0x0
 9cc:	da0080e7          	jalr	-608(ra) # 768 <putc>
      state = 0;
 9d0:	4981                	li	s3,0
 9d2:	b5d1                	j	896 <vprintf+0x60>
        putc(fd, '%');
 9d4:	85d2                	mv	a1,s4
 9d6:	8556                	mv	a0,s5
 9d8:	00000097          	auipc	ra,0x0
 9dc:	d90080e7          	jalr	-624(ra) # 768 <putc>
        putc(fd, c);
 9e0:	85ca                	mv	a1,s2
 9e2:	8556                	mv	a0,s5
 9e4:	00000097          	auipc	ra,0x0
 9e8:	d84080e7          	jalr	-636(ra) # 768 <putc>
      state = 0;
 9ec:	4981                	li	s3,0
 9ee:	b565                	j	896 <vprintf+0x60>
        s = va_arg(ap, char*);
 9f0:	8b4a                	mv	s6,s2
      state = 0;
 9f2:	4981                	li	s3,0
 9f4:	b54d                	j	896 <vprintf+0x60>
    }
  }
}
 9f6:	70e6                	ld	ra,120(sp)
 9f8:	7446                	ld	s0,112(sp)
 9fa:	74a6                	ld	s1,104(sp)
 9fc:	7906                	ld	s2,96(sp)
 9fe:	69e6                	ld	s3,88(sp)
 a00:	6a46                	ld	s4,80(sp)
 a02:	6aa6                	ld	s5,72(sp)
 a04:	6b06                	ld	s6,64(sp)
 a06:	7be2                	ld	s7,56(sp)
 a08:	7c42                	ld	s8,48(sp)
 a0a:	7ca2                	ld	s9,40(sp)
 a0c:	7d02                	ld	s10,32(sp)
 a0e:	6de2                	ld	s11,24(sp)
 a10:	6109                	addi	sp,sp,128
 a12:	8082                	ret

0000000000000a14 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a14:	715d                	addi	sp,sp,-80
 a16:	ec06                	sd	ra,24(sp)
 a18:	e822                	sd	s0,16(sp)
 a1a:	1000                	addi	s0,sp,32
 a1c:	e010                	sd	a2,0(s0)
 a1e:	e414                	sd	a3,8(s0)
 a20:	e818                	sd	a4,16(s0)
 a22:	ec1c                	sd	a5,24(s0)
 a24:	03043023          	sd	a6,32(s0)
 a28:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a2c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a30:	8622                	mv	a2,s0
 a32:	00000097          	auipc	ra,0x0
 a36:	e04080e7          	jalr	-508(ra) # 836 <vprintf>
}
 a3a:	60e2                	ld	ra,24(sp)
 a3c:	6442                	ld	s0,16(sp)
 a3e:	6161                	addi	sp,sp,80
 a40:	8082                	ret

0000000000000a42 <printf>:

void
printf(const char *fmt, ...)
{
 a42:	711d                	addi	sp,sp,-96
 a44:	ec06                	sd	ra,24(sp)
 a46:	e822                	sd	s0,16(sp)
 a48:	1000                	addi	s0,sp,32
 a4a:	e40c                	sd	a1,8(s0)
 a4c:	e810                	sd	a2,16(s0)
 a4e:	ec14                	sd	a3,24(s0)
 a50:	f018                	sd	a4,32(s0)
 a52:	f41c                	sd	a5,40(s0)
 a54:	03043823          	sd	a6,48(s0)
 a58:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a5c:	00840613          	addi	a2,s0,8
 a60:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a64:	85aa                	mv	a1,a0
 a66:	4505                	li	a0,1
 a68:	00000097          	auipc	ra,0x0
 a6c:	dce080e7          	jalr	-562(ra) # 836 <vprintf>
}
 a70:	60e2                	ld	ra,24(sp)
 a72:	6442                	ld	s0,16(sp)
 a74:	6125                	addi	sp,sp,96
 a76:	8082                	ret

0000000000000a78 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a78:	1141                	addi	sp,sp,-16
 a7a:	e422                	sd	s0,8(sp)
 a7c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a7e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a82:	00000797          	auipc	a5,0x0
 a86:	57e7b783          	ld	a5,1406(a5) # 1000 <freep>
 a8a:	a02d                	j	ab4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a8c:	4618                	lw	a4,8(a2)
 a8e:	9f2d                	addw	a4,a4,a1
 a90:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a94:	6398                	ld	a4,0(a5)
 a96:	6310                	ld	a2,0(a4)
 a98:	a83d                	j	ad6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a9a:	ff852703          	lw	a4,-8(a0)
 a9e:	9f31                	addw	a4,a4,a2
 aa0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 aa2:	ff053683          	ld	a3,-16(a0)
 aa6:	a091                	j	aea <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aa8:	6398                	ld	a4,0(a5)
 aaa:	00e7e463          	bltu	a5,a4,ab2 <free+0x3a>
 aae:	00e6ea63          	bltu	a3,a4,ac2 <free+0x4a>
{
 ab2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ab4:	fed7fae3          	bgeu	a5,a3,aa8 <free+0x30>
 ab8:	6398                	ld	a4,0(a5)
 aba:	00e6e463          	bltu	a3,a4,ac2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 abe:	fee7eae3          	bltu	a5,a4,ab2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 ac2:	ff852583          	lw	a1,-8(a0)
 ac6:	6390                	ld	a2,0(a5)
 ac8:	02059813          	slli	a6,a1,0x20
 acc:	01c85713          	srli	a4,a6,0x1c
 ad0:	9736                	add	a4,a4,a3
 ad2:	fae60de3          	beq	a2,a4,a8c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 ad6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 ada:	4790                	lw	a2,8(a5)
 adc:	02061593          	slli	a1,a2,0x20
 ae0:	01c5d713          	srli	a4,a1,0x1c
 ae4:	973e                	add	a4,a4,a5
 ae6:	fae68ae3          	beq	a3,a4,a9a <free+0x22>
    p->s.ptr = bp->s.ptr;
 aea:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 aec:	00000717          	auipc	a4,0x0
 af0:	50f73a23          	sd	a5,1300(a4) # 1000 <freep>
}
 af4:	6422                	ld	s0,8(sp)
 af6:	0141                	addi	sp,sp,16
 af8:	8082                	ret

0000000000000afa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 afa:	7139                	addi	sp,sp,-64
 afc:	fc06                	sd	ra,56(sp)
 afe:	f822                	sd	s0,48(sp)
 b00:	f426                	sd	s1,40(sp)
 b02:	f04a                	sd	s2,32(sp)
 b04:	ec4e                	sd	s3,24(sp)
 b06:	e852                	sd	s4,16(sp)
 b08:	e456                	sd	s5,8(sp)
 b0a:	e05a                	sd	s6,0(sp)
 b0c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b0e:	02051493          	slli	s1,a0,0x20
 b12:	9081                	srli	s1,s1,0x20
 b14:	04bd                	addi	s1,s1,15
 b16:	8091                	srli	s1,s1,0x4
 b18:	0014899b          	addiw	s3,s1,1
 b1c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b1e:	00000517          	auipc	a0,0x0
 b22:	4e253503          	ld	a0,1250(a0) # 1000 <freep>
 b26:	c515                	beqz	a0,b52 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b28:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b2a:	4798                	lw	a4,8(a5)
 b2c:	02977f63          	bgeu	a4,s1,b6a <malloc+0x70>
 b30:	8a4e                	mv	s4,s3
 b32:	0009871b          	sext.w	a4,s3
 b36:	6685                	lui	a3,0x1
 b38:	00d77363          	bgeu	a4,a3,b3e <malloc+0x44>
 b3c:	6a05                	lui	s4,0x1
 b3e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b42:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b46:	00000917          	auipc	s2,0x0
 b4a:	4ba90913          	addi	s2,s2,1210 # 1000 <freep>
  if(p == (char*)-1)
 b4e:	5afd                	li	s5,-1
 b50:	a895                	j	bc4 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 b52:	00001797          	auipc	a5,0x1
 b56:	4be78793          	addi	a5,a5,1214 # 2010 <base>
 b5a:	00000717          	auipc	a4,0x0
 b5e:	4af73323          	sd	a5,1190(a4) # 1000 <freep>
 b62:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b64:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b68:	b7e1                	j	b30 <malloc+0x36>
      if(p->s.size == nunits)
 b6a:	02e48c63          	beq	s1,a4,ba2 <malloc+0xa8>
        p->s.size -= nunits;
 b6e:	4137073b          	subw	a4,a4,s3
 b72:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b74:	02071693          	slli	a3,a4,0x20
 b78:	01c6d713          	srli	a4,a3,0x1c
 b7c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b7e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b82:	00000717          	auipc	a4,0x0
 b86:	46a73f23          	sd	a0,1150(a4) # 1000 <freep>
      return (void*)(p + 1);
 b8a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b8e:	70e2                	ld	ra,56(sp)
 b90:	7442                	ld	s0,48(sp)
 b92:	74a2                	ld	s1,40(sp)
 b94:	7902                	ld	s2,32(sp)
 b96:	69e2                	ld	s3,24(sp)
 b98:	6a42                	ld	s4,16(sp)
 b9a:	6aa2                	ld	s5,8(sp)
 b9c:	6b02                	ld	s6,0(sp)
 b9e:	6121                	addi	sp,sp,64
 ba0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 ba2:	6398                	ld	a4,0(a5)
 ba4:	e118                	sd	a4,0(a0)
 ba6:	bff1                	j	b82 <malloc+0x88>
  hp->s.size = nu;
 ba8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bac:	0541                	addi	a0,a0,16
 bae:	00000097          	auipc	ra,0x0
 bb2:	eca080e7          	jalr	-310(ra) # a78 <free>
  return freep;
 bb6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 bba:	d971                	beqz	a0,b8e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bbc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bbe:	4798                	lw	a4,8(a5)
 bc0:	fa9775e3          	bgeu	a4,s1,b6a <malloc+0x70>
    if(p == freep)
 bc4:	00093703          	ld	a4,0(s2)
 bc8:	853e                	mv	a0,a5
 bca:	fef719e3          	bne	a4,a5,bbc <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 bce:	8552                	mv	a0,s4
 bd0:	00000097          	auipc	ra,0x0
 bd4:	b80080e7          	jalr	-1152(ra) # 750 <sbrk>
  if(p == (char*)-1)
 bd8:	fd5518e3          	bne	a0,s5,ba8 <malloc+0xae>
        return 0;
 bdc:	4501                	li	a0,0
 bde:	bf45                	j	b8e <malloc+0x94>

0000000000000be0 <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
 be0:	7179                	addi	sp,sp,-48
 be2:	f406                	sd	ra,40(sp)
 be4:	f022                	sd	s0,32(sp)
 be6:	ec26                	sd	s1,24(sp)
 be8:	e84a                	sd	s2,16(sp)
 bea:	e44e                	sd	s3,8(sp)
 bec:	e052                	sd	s4,0(sp)
 bee:	1800                	addi	s0,sp,48
 bf0:	8a2a                	mv	s4,a0
 bf2:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
 bf4:	4581                	li	a1,0
 bf6:	00000517          	auipc	a0,0x0
 bfa:	24250513          	addi	a0,a0,578 # e38 <digits+0x18>
 bfe:	00000097          	auipc	ra,0x0
 c02:	b0a080e7          	jalr	-1270(ra) # 708 <open>
  if(fd < 0) {
 c06:	04054263          	bltz	a0,c4a <statistics+0x6a>
 c0a:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
 c0c:	4481                	li	s1,0
 c0e:	03205063          	blez	s2,c2e <statistics+0x4e>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
 c12:	4099063b          	subw	a2,s2,s1
 c16:	009a05b3          	add	a1,s4,s1
 c1a:	854e                	mv	a0,s3
 c1c:	00000097          	auipc	ra,0x0
 c20:	ac4080e7          	jalr	-1340(ra) # 6e0 <read>
 c24:	00054563          	bltz	a0,c2e <statistics+0x4e>
      break;
    }
    i += n;
 c28:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
 c2a:	ff24c4e3          	blt	s1,s2,c12 <statistics+0x32>
  }
  close(fd);
 c2e:	854e                	mv	a0,s3
 c30:	00000097          	auipc	ra,0x0
 c34:	ac0080e7          	jalr	-1344(ra) # 6f0 <close>
  return i;
}
 c38:	8526                	mv	a0,s1
 c3a:	70a2                	ld	ra,40(sp)
 c3c:	7402                	ld	s0,32(sp)
 c3e:	64e2                	ld	s1,24(sp)
 c40:	6942                	ld	s2,16(sp)
 c42:	69a2                	ld	s3,8(sp)
 c44:	6a02                	ld	s4,0(sp)
 c46:	6145                	addi	sp,sp,48
 c48:	8082                	ret
      fprintf(2, "stats: open failed\n");
 c4a:	00000597          	auipc	a1,0x0
 c4e:	1fe58593          	addi	a1,a1,510 # e48 <digits+0x28>
 c52:	4509                	li	a0,2
 c54:	00000097          	auipc	ra,0x0
 c58:	dc0080e7          	jalr	-576(ra) # a14 <fprintf>
      exit(1);
 c5c:	4505                	li	a0,1
 c5e:	00000097          	auipc	ra,0x0
 c62:	a6a080e7          	jalr	-1430(ra) # 6c8 <exit>
