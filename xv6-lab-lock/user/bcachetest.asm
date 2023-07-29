
user/_bcachetest：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <createfile>:
  exit(0);
}

void
createfile(char *file, int nblock)
{
   0:	bd010113          	addi	sp,sp,-1072
   4:	42113423          	sd	ra,1064(sp)
   8:	42813023          	sd	s0,1056(sp)
   c:	40913c23          	sd	s1,1048(sp)
  10:	41213823          	sd	s2,1040(sp)
  14:	41313423          	sd	s3,1032(sp)
  18:	41413023          	sd	s4,1024(sp)
  1c:	43010413          	addi	s0,sp,1072
  20:	8a2a                	mv	s4,a0
  22:	89ae                	mv	s3,a1
  int fd;
  char buf[BSIZE];
  int i;
  
  fd = open(file, O_CREATE | O_RDWR);
  24:	20200593          	li	a1,514
  28:	00000097          	auipc	ra,0x0
  2c:	7fe080e7          	jalr	2046(ra) # 826 <open>
  if(fd < 0){
  30:	04054a63          	bltz	a0,84 <createfile+0x84>
  34:	892a                	mv	s2,a0
    printf("createfile %s failed\n", file);
    exit(-1);
  }
  for(i = 0; i < nblock; i++) {
  36:	4481                	li	s1,0
  38:	03305263          	blez	s3,5c <createfile+0x5c>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)) {
  3c:	40000613          	li	a2,1024
  40:	bd040593          	addi	a1,s0,-1072
  44:	854a                	mv	a0,s2
  46:	00000097          	auipc	ra,0x0
  4a:	7c0080e7          	jalr	1984(ra) # 806 <write>
  4e:	40000793          	li	a5,1024
  52:	04f51763          	bne	a0,a5,a0 <createfile+0xa0>
  for(i = 0; i < nblock; i++) {
  56:	2485                	addiw	s1,s1,1
  58:	fe9992e3          	bne	s3,s1,3c <createfile+0x3c>
      printf("write %s failed\n", file);
      exit(-1);
    }
  }
  close(fd);
  5c:	854a                	mv	a0,s2
  5e:	00000097          	auipc	ra,0x0
  62:	7b0080e7          	jalr	1968(ra) # 80e <close>
}
  66:	42813083          	ld	ra,1064(sp)
  6a:	42013403          	ld	s0,1056(sp)
  6e:	41813483          	ld	s1,1048(sp)
  72:	41013903          	ld	s2,1040(sp)
  76:	40813983          	ld	s3,1032(sp)
  7a:	40013a03          	ld	s4,1024(sp)
  7e:	43010113          	addi	sp,sp,1072
  82:	8082                	ret
    printf("createfile %s failed\n", file);
  84:	85d2                	mv	a1,s4
  86:	00001517          	auipc	a0,0x1
  8a:	d0a50513          	addi	a0,a0,-758 # d90 <statistics+0x92>
  8e:	00001097          	auipc	ra,0x1
  92:	ad2080e7          	jalr	-1326(ra) # b60 <printf>
    exit(-1);
  96:	557d                	li	a0,-1
  98:	00000097          	auipc	ra,0x0
  9c:	74e080e7          	jalr	1870(ra) # 7e6 <exit>
      printf("write %s failed\n", file);
  a0:	85d2                	mv	a1,s4
  a2:	00001517          	auipc	a0,0x1
  a6:	d0650513          	addi	a0,a0,-762 # da8 <statistics+0xaa>
  aa:	00001097          	auipc	ra,0x1
  ae:	ab6080e7          	jalr	-1354(ra) # b60 <printf>
      exit(-1);
  b2:	557d                	li	a0,-1
  b4:	00000097          	auipc	ra,0x0
  b8:	732080e7          	jalr	1842(ra) # 7e6 <exit>

00000000000000bc <readfile>:

void
readfile(char *file, int nbytes, int inc)
{
  bc:	bc010113          	addi	sp,sp,-1088
  c0:	42113c23          	sd	ra,1080(sp)
  c4:	42813823          	sd	s0,1072(sp)
  c8:	42913423          	sd	s1,1064(sp)
  cc:	43213023          	sd	s2,1056(sp)
  d0:	41313c23          	sd	s3,1048(sp)
  d4:	41413823          	sd	s4,1040(sp)
  d8:	41513423          	sd	s5,1032(sp)
  dc:	44010413          	addi	s0,sp,1088
  char buf[BSIZE];
  int fd;
  int i;

  if(inc > BSIZE) {
  e0:	40000793          	li	a5,1024
  e4:	06c7c463          	blt	a5,a2,14c <readfile+0x90>
  e8:	8aaa                	mv	s5,a0
  ea:	8a2e                	mv	s4,a1
  ec:	84b2                	mv	s1,a2
    printf("readfile: inc too large\n");
    exit(-1);
  }
  if ((fd = open(file, O_RDONLY)) < 0) {
  ee:	4581                	li	a1,0
  f0:	00000097          	auipc	ra,0x0
  f4:	736080e7          	jalr	1846(ra) # 826 <open>
  f8:	89aa                	mv	s3,a0
  fa:	06054663          	bltz	a0,166 <readfile+0xaa>
    printf("readfile open %s failed\n", file);
    exit(-1);
  }
  for (i = 0; i < nbytes; i += inc) {
  fe:	4901                	li	s2,0
 100:	03405063          	blez	s4,120 <readfile+0x64>
    if(read(fd, buf, inc) != inc) {
 104:	8626                	mv	a2,s1
 106:	bc040593          	addi	a1,s0,-1088
 10a:	854e                	mv	a0,s3
 10c:	00000097          	auipc	ra,0x0
 110:	6f2080e7          	jalr	1778(ra) # 7fe <read>
 114:	06951763          	bne	a0,s1,182 <readfile+0xc6>
  for (i = 0; i < nbytes; i += inc) {
 118:	0124893b          	addw	s2,s1,s2
 11c:	ff4944e3          	blt	s2,s4,104 <readfile+0x48>
      printf("read %s failed for block %d (%d)\n", file, i, nbytes);
      exit(-1);
    }
  }
  close(fd);
 120:	854e                	mv	a0,s3
 122:	00000097          	auipc	ra,0x0
 126:	6ec080e7          	jalr	1772(ra) # 80e <close>
}
 12a:	43813083          	ld	ra,1080(sp)
 12e:	43013403          	ld	s0,1072(sp)
 132:	42813483          	ld	s1,1064(sp)
 136:	42013903          	ld	s2,1056(sp)
 13a:	41813983          	ld	s3,1048(sp)
 13e:	41013a03          	ld	s4,1040(sp)
 142:	40813a83          	ld	s5,1032(sp)
 146:	44010113          	addi	sp,sp,1088
 14a:	8082                	ret
    printf("readfile: inc too large\n");
 14c:	00001517          	auipc	a0,0x1
 150:	c7450513          	addi	a0,a0,-908 # dc0 <statistics+0xc2>
 154:	00001097          	auipc	ra,0x1
 158:	a0c080e7          	jalr	-1524(ra) # b60 <printf>
    exit(-1);
 15c:	557d                	li	a0,-1
 15e:	00000097          	auipc	ra,0x0
 162:	688080e7          	jalr	1672(ra) # 7e6 <exit>
    printf("readfile open %s failed\n", file);
 166:	85d6                	mv	a1,s5
 168:	00001517          	auipc	a0,0x1
 16c:	c7850513          	addi	a0,a0,-904 # de0 <statistics+0xe2>
 170:	00001097          	auipc	ra,0x1
 174:	9f0080e7          	jalr	-1552(ra) # b60 <printf>
    exit(-1);
 178:	557d                	li	a0,-1
 17a:	00000097          	auipc	ra,0x0
 17e:	66c080e7          	jalr	1644(ra) # 7e6 <exit>
      printf("read %s failed for block %d (%d)\n", file, i, nbytes);
 182:	86d2                	mv	a3,s4
 184:	864a                	mv	a2,s2
 186:	85d6                	mv	a1,s5
 188:	00001517          	auipc	a0,0x1
 18c:	c7850513          	addi	a0,a0,-904 # e00 <statistics+0x102>
 190:	00001097          	auipc	ra,0x1
 194:	9d0080e7          	jalr	-1584(ra) # b60 <printf>
      exit(-1);
 198:	557d                	li	a0,-1
 19a:	00000097          	auipc	ra,0x0
 19e:	64c080e7          	jalr	1612(ra) # 7e6 <exit>

00000000000001a2 <ntas>:

int ntas(int print)
{
 1a2:	1101                	addi	sp,sp,-32
 1a4:	ec06                	sd	ra,24(sp)
 1a6:	e822                	sd	s0,16(sp)
 1a8:	e426                	sd	s1,8(sp)
 1aa:	e04a                	sd	s2,0(sp)
 1ac:	1000                	addi	s0,sp,32
 1ae:	892a                	mv	s2,a0
  int n;
  char *c;

  if (statistics(buf, SZ) <= 0) {
 1b0:	6585                	lui	a1,0x1
 1b2:	00001517          	auipc	a0,0x1
 1b6:	e5e50513          	addi	a0,a0,-418 # 1010 <buf>
 1ba:	00001097          	auipc	ra,0x1
 1be:	b44080e7          	jalr	-1212(ra) # cfe <statistics>
 1c2:	02a05b63          	blez	a0,1f8 <ntas+0x56>
    fprintf(2, "ntas: no stats\n");
  }
  c = strchr(buf, '=');
 1c6:	03d00593          	li	a1,61
 1ca:	00001517          	auipc	a0,0x1
 1ce:	e4650513          	addi	a0,a0,-442 # 1010 <buf>
 1d2:	00000097          	auipc	ra,0x0
 1d6:	43c080e7          	jalr	1084(ra) # 60e <strchr>
  n = atoi(c+2);
 1da:	0509                	addi	a0,a0,2
 1dc:	00000097          	auipc	ra,0x0
 1e0:	510080e7          	jalr	1296(ra) # 6ec <atoi>
 1e4:	84aa                	mv	s1,a0
  if(print)
 1e6:	02091363          	bnez	s2,20c <ntas+0x6a>
    printf("%s", buf);
  return n;
}
 1ea:	8526                	mv	a0,s1
 1ec:	60e2                	ld	ra,24(sp)
 1ee:	6442                	ld	s0,16(sp)
 1f0:	64a2                	ld	s1,8(sp)
 1f2:	6902                	ld	s2,0(sp)
 1f4:	6105                	addi	sp,sp,32
 1f6:	8082                	ret
    fprintf(2, "ntas: no stats\n");
 1f8:	00001597          	auipc	a1,0x1
 1fc:	c3058593          	addi	a1,a1,-976 # e28 <statistics+0x12a>
 200:	4509                	li	a0,2
 202:	00001097          	auipc	ra,0x1
 206:	930080e7          	jalr	-1744(ra) # b32 <fprintf>
 20a:	bf75                	j	1c6 <ntas+0x24>
    printf("%s", buf);
 20c:	00001597          	auipc	a1,0x1
 210:	e0458593          	addi	a1,a1,-508 # 1010 <buf>
 214:	00001517          	auipc	a0,0x1
 218:	c2450513          	addi	a0,a0,-988 # e38 <statistics+0x13a>
 21c:	00001097          	auipc	ra,0x1
 220:	944080e7          	jalr	-1724(ra) # b60 <printf>
 224:	b7d9                	j	1ea <ntas+0x48>

0000000000000226 <test0>:

// Test reading small files concurrently
void
test0()
{
 226:	7139                	addi	sp,sp,-64
 228:	fc06                	sd	ra,56(sp)
 22a:	f822                	sd	s0,48(sp)
 22c:	f426                	sd	s1,40(sp)
 22e:	f04a                	sd	s2,32(sp)
 230:	ec4e                	sd	s3,24(sp)
 232:	0080                	addi	s0,sp,64
  char file[2];
  char dir[2];
  enum { N = 10, NCHILD = 3 };
  int m, n;

  dir[0] = '0';
 234:	03000793          	li	a5,48
 238:	fcf40023          	sb	a5,-64(s0)
  dir[1] = '\0';
 23c:	fc0400a3          	sb	zero,-63(s0)
  file[0] = 'F';
 240:	04600793          	li	a5,70
 244:	fcf40423          	sb	a5,-56(s0)
  file[1] = '\0';
 248:	fc0404a3          	sb	zero,-55(s0)

  printf("start test0\n");
 24c:	00001517          	auipc	a0,0x1
 250:	bf450513          	addi	a0,a0,-1036 # e40 <statistics+0x142>
 254:	00001097          	auipc	ra,0x1
 258:	90c080e7          	jalr	-1780(ra) # b60 <printf>
 25c:	03000493          	li	s1,48
      printf("chdir failed\n");
      exit(1);
    }
    unlink(file);
    createfile(file, N);
    if (chdir("..") < 0) {
 260:	00001997          	auipc	s3,0x1
 264:	c0098993          	addi	s3,s3,-1024 # e60 <statistics+0x162>
  for(int i = 0; i < NCHILD; i++){
 268:	03300913          	li	s2,51
    dir[0] = '0' + i;
 26c:	fc940023          	sb	s1,-64(s0)
    mkdir(dir);
 270:	fc040513          	addi	a0,s0,-64
 274:	00000097          	auipc	ra,0x0
 278:	5da080e7          	jalr	1498(ra) # 84e <mkdir>
    if (chdir(dir) < 0) {
 27c:	fc040513          	addi	a0,s0,-64
 280:	00000097          	auipc	ra,0x0
 284:	5d6080e7          	jalr	1494(ra) # 856 <chdir>
 288:	0c054463          	bltz	a0,350 <test0+0x12a>
    unlink(file);
 28c:	fc840513          	addi	a0,s0,-56
 290:	00000097          	auipc	ra,0x0
 294:	5a6080e7          	jalr	1446(ra) # 836 <unlink>
    createfile(file, N);
 298:	45a9                	li	a1,10
 29a:	fc840513          	addi	a0,s0,-56
 29e:	00000097          	auipc	ra,0x0
 2a2:	d62080e7          	jalr	-670(ra) # 0 <createfile>
    if (chdir("..") < 0) {
 2a6:	854e                	mv	a0,s3
 2a8:	00000097          	auipc	ra,0x0
 2ac:	5ae080e7          	jalr	1454(ra) # 856 <chdir>
 2b0:	0a054d63          	bltz	a0,36a <test0+0x144>
  for(int i = 0; i < NCHILD; i++){
 2b4:	2485                	addiw	s1,s1,1
 2b6:	0ff4f493          	zext.b	s1,s1
 2ba:	fb2499e3          	bne	s1,s2,26c <test0+0x46>
      printf("chdir failed\n");
      exit(1);
    }
  }
  m = ntas(0);
 2be:	4501                	li	a0,0
 2c0:	00000097          	auipc	ra,0x0
 2c4:	ee2080e7          	jalr	-286(ra) # 1a2 <ntas>
 2c8:	892a                	mv	s2,a0
 2ca:	03000493          	li	s1,48
  for(int i = 0; i < NCHILD; i++){
 2ce:	03300993          	li	s3,51
    dir[0] = '0' + i;
 2d2:	fc940023          	sb	s1,-64(s0)
    int pid = fork();
 2d6:	00000097          	auipc	ra,0x0
 2da:	508080e7          	jalr	1288(ra) # 7de <fork>
    if(pid < 0){
 2de:	0a054363          	bltz	a0,384 <test0+0x15e>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
 2e2:	cd55                	beqz	a0,39e <test0+0x178>
  for(int i = 0; i < NCHILD; i++){
 2e4:	2485                	addiw	s1,s1,1
 2e6:	0ff4f493          	zext.b	s1,s1
 2ea:	ff3494e3          	bne	s1,s3,2d2 <test0+0xac>
      exit(0);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
 2ee:	4501                	li	a0,0
 2f0:	00000097          	auipc	ra,0x0
 2f4:	4fe080e7          	jalr	1278(ra) # 7ee <wait>
 2f8:	4501                	li	a0,0
 2fa:	00000097          	auipc	ra,0x0
 2fe:	4f4080e7          	jalr	1268(ra) # 7ee <wait>
 302:	4501                	li	a0,0
 304:	00000097          	auipc	ra,0x0
 308:	4ea080e7          	jalr	1258(ra) # 7ee <wait>
  }
  printf("test0 results:\n");
 30c:	00001517          	auipc	a0,0x1
 310:	b6c50513          	addi	a0,a0,-1172 # e78 <statistics+0x17a>
 314:	00001097          	auipc	ra,0x1
 318:	84c080e7          	jalr	-1972(ra) # b60 <printf>
  n = ntas(1);
 31c:	4505                	li	a0,1
 31e:	00000097          	auipc	ra,0x0
 322:	e84080e7          	jalr	-380(ra) # 1a2 <ntas>
  if (n-m < 500)
 326:	4125053b          	subw	a0,a0,s2
 32a:	1f300793          	li	a5,499
 32e:	0aa7cc63          	blt	a5,a0,3e6 <test0+0x1c0>
    printf("test0: OK\n");
 332:	00001517          	auipc	a0,0x1
 336:	b5650513          	addi	a0,a0,-1194 # e88 <statistics+0x18a>
 33a:	00001097          	auipc	ra,0x1
 33e:	826080e7          	jalr	-2010(ra) # b60 <printf>
  else
    printf("test0: FAIL\n");
}
 342:	70e2                	ld	ra,56(sp)
 344:	7442                	ld	s0,48(sp)
 346:	74a2                	ld	s1,40(sp)
 348:	7902                	ld	s2,32(sp)
 34a:	69e2                	ld	s3,24(sp)
 34c:	6121                	addi	sp,sp,64
 34e:	8082                	ret
      printf("chdir failed\n");
 350:	00001517          	auipc	a0,0x1
 354:	b0050513          	addi	a0,a0,-1280 # e50 <statistics+0x152>
 358:	00001097          	auipc	ra,0x1
 35c:	808080e7          	jalr	-2040(ra) # b60 <printf>
      exit(1);
 360:	4505                	li	a0,1
 362:	00000097          	auipc	ra,0x0
 366:	484080e7          	jalr	1156(ra) # 7e6 <exit>
      printf("chdir failed\n");
 36a:	00001517          	auipc	a0,0x1
 36e:	ae650513          	addi	a0,a0,-1306 # e50 <statistics+0x152>
 372:	00000097          	auipc	ra,0x0
 376:	7ee080e7          	jalr	2030(ra) # b60 <printf>
      exit(1);
 37a:	4505                	li	a0,1
 37c:	00000097          	auipc	ra,0x0
 380:	46a080e7          	jalr	1130(ra) # 7e6 <exit>
      printf("fork failed");
 384:	00001517          	auipc	a0,0x1
 388:	ae450513          	addi	a0,a0,-1308 # e68 <statistics+0x16a>
 38c:	00000097          	auipc	ra,0x0
 390:	7d4080e7          	jalr	2004(ra) # b60 <printf>
      exit(-1);
 394:	557d                	li	a0,-1
 396:	00000097          	auipc	ra,0x0
 39a:	450080e7          	jalr	1104(ra) # 7e6 <exit>
      if (chdir(dir) < 0) {
 39e:	fc040513          	addi	a0,s0,-64
 3a2:	00000097          	auipc	ra,0x0
 3a6:	4b4080e7          	jalr	1204(ra) # 856 <chdir>
 3aa:	02054163          	bltz	a0,3cc <test0+0x1a6>
      readfile(file, N*BSIZE, 1);
 3ae:	4605                	li	a2,1
 3b0:	658d                	lui	a1,0x3
 3b2:	80058593          	addi	a1,a1,-2048 # 2800 <base+0x7f0>
 3b6:	fc840513          	addi	a0,s0,-56
 3ba:	00000097          	auipc	ra,0x0
 3be:	d02080e7          	jalr	-766(ra) # bc <readfile>
      exit(0);
 3c2:	4501                	li	a0,0
 3c4:	00000097          	auipc	ra,0x0
 3c8:	422080e7          	jalr	1058(ra) # 7e6 <exit>
        printf("chdir failed\n");
 3cc:	00001517          	auipc	a0,0x1
 3d0:	a8450513          	addi	a0,a0,-1404 # e50 <statistics+0x152>
 3d4:	00000097          	auipc	ra,0x0
 3d8:	78c080e7          	jalr	1932(ra) # b60 <printf>
        exit(1);
 3dc:	4505                	li	a0,1
 3de:	00000097          	auipc	ra,0x0
 3e2:	408080e7          	jalr	1032(ra) # 7e6 <exit>
    printf("test0: FAIL\n");
 3e6:	00001517          	auipc	a0,0x1
 3ea:	ab250513          	addi	a0,a0,-1358 # e98 <statistics+0x19a>
 3ee:	00000097          	auipc	ra,0x0
 3f2:	772080e7          	jalr	1906(ra) # b60 <printf>
}
 3f6:	b7b1                	j	342 <test0+0x11c>

00000000000003f8 <test1>:

// Test bcache evictions by reading a large file concurrently
void test1()
{
 3f8:	7179                	addi	sp,sp,-48
 3fa:	f406                	sd	ra,40(sp)
 3fc:	f022                	sd	s0,32(sp)
 3fe:	ec26                	sd	s1,24(sp)
 400:	e84a                	sd	s2,16(sp)
 402:	1800                	addi	s0,sp,48
  char file[3];
  enum { N = 200, BIG=100, NCHILD=2 };
  
  printf("start test1\n");
 404:	00001517          	auipc	a0,0x1
 408:	aa450513          	addi	a0,a0,-1372 # ea8 <statistics+0x1aa>
 40c:	00000097          	auipc	ra,0x0
 410:	754080e7          	jalr	1876(ra) # b60 <printf>
  file[0] = 'B';
 414:	04200793          	li	a5,66
 418:	fcf40c23          	sb	a5,-40(s0)
  file[2] = '\0';
 41c:	fc040d23          	sb	zero,-38(s0)
 420:	4485                	li	s1,1
  for(int i = 0; i < NCHILD; i++){
    file[1] = '0' + i;
    unlink(file);
    if (i == 0) {
 422:	4905                	li	s2,1
 424:	a811                	j	438 <test1+0x40>
      createfile(file, BIG);
 426:	06400593          	li	a1,100
 42a:	fd840513          	addi	a0,s0,-40
 42e:	00000097          	auipc	ra,0x0
 432:	bd2080e7          	jalr	-1070(ra) # 0 <createfile>
  for(int i = 0; i < NCHILD; i++){
 436:	2485                	addiw	s1,s1,1
    file[1] = '0' + i;
 438:	02f4879b          	addiw	a5,s1,47
 43c:	fcf40ca3          	sb	a5,-39(s0)
    unlink(file);
 440:	fd840513          	addi	a0,s0,-40
 444:	00000097          	auipc	ra,0x0
 448:	3f2080e7          	jalr	1010(ra) # 836 <unlink>
    if (i == 0) {
 44c:	fd248de3          	beq	s1,s2,426 <test1+0x2e>
    } else {
      createfile(file, 1);
 450:	85ca                	mv	a1,s2
 452:	fd840513          	addi	a0,s0,-40
 456:	00000097          	auipc	ra,0x0
 45a:	baa080e7          	jalr	-1110(ra) # 0 <createfile>
  for(int i = 0; i < NCHILD; i++){
 45e:	0004879b          	sext.w	a5,s1
 462:	fcf95ae3          	bge	s2,a5,436 <test1+0x3e>
    }
  }
  for(int i = 0; i < NCHILD; i++){
    file[1] = '0' + i;
 466:	03000793          	li	a5,48
 46a:	fcf40ca3          	sb	a5,-39(s0)
    int pid = fork();
 46e:	00000097          	auipc	ra,0x0
 472:	370080e7          	jalr	880(ra) # 7de <fork>
    if(pid < 0){
 476:	04054663          	bltz	a0,4c2 <test1+0xca>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
 47a:	c12d                	beqz	a0,4dc <test1+0xe4>
    file[1] = '0' + i;
 47c:	03100793          	li	a5,49
 480:	fcf40ca3          	sb	a5,-39(s0)
    int pid = fork();
 484:	00000097          	auipc	ra,0x0
 488:	35a080e7          	jalr	858(ra) # 7de <fork>
    if(pid < 0){
 48c:	02054b63          	bltz	a0,4c2 <test1+0xca>
    if(pid == 0){
 490:	cd35                	beqz	a0,50c <test1+0x114>
      exit(0);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
 492:	4501                	li	a0,0
 494:	00000097          	auipc	ra,0x0
 498:	35a080e7          	jalr	858(ra) # 7ee <wait>
 49c:	4501                	li	a0,0
 49e:	00000097          	auipc	ra,0x0
 4a2:	350080e7          	jalr	848(ra) # 7ee <wait>
  }
  printf("test1 OK\n");
 4a6:	00001517          	auipc	a0,0x1
 4aa:	a1250513          	addi	a0,a0,-1518 # eb8 <statistics+0x1ba>
 4ae:	00000097          	auipc	ra,0x0
 4b2:	6b2080e7          	jalr	1714(ra) # b60 <printf>
}
 4b6:	70a2                	ld	ra,40(sp)
 4b8:	7402                	ld	s0,32(sp)
 4ba:	64e2                	ld	s1,24(sp)
 4bc:	6942                	ld	s2,16(sp)
 4be:	6145                	addi	sp,sp,48
 4c0:	8082                	ret
      printf("fork failed");
 4c2:	00001517          	auipc	a0,0x1
 4c6:	9a650513          	addi	a0,a0,-1626 # e68 <statistics+0x16a>
 4ca:	00000097          	auipc	ra,0x0
 4ce:	696080e7          	jalr	1686(ra) # b60 <printf>
      exit(-1);
 4d2:	557d                	li	a0,-1
 4d4:	00000097          	auipc	ra,0x0
 4d8:	312080e7          	jalr	786(ra) # 7e6 <exit>
    if(pid == 0){
 4dc:	0c800493          	li	s1,200
          readfile(file, BIG*BSIZE, BSIZE);
 4e0:	40000613          	li	a2,1024
 4e4:	65e5                	lui	a1,0x19
 4e6:	fd840513          	addi	a0,s0,-40
 4ea:	00000097          	auipc	ra,0x0
 4ee:	bd2080e7          	jalr	-1070(ra) # bc <readfile>
        for (i = 0; i < N; i++) {
 4f2:	34fd                	addiw	s1,s1,-1
 4f4:	f4f5                	bnez	s1,4e0 <test1+0xe8>
        unlink(file);
 4f6:	fd840513          	addi	a0,s0,-40
 4fa:	00000097          	auipc	ra,0x0
 4fe:	33c080e7          	jalr	828(ra) # 836 <unlink>
        exit(0);
 502:	4501                	li	a0,0
 504:	00000097          	auipc	ra,0x0
 508:	2e2080e7          	jalr	738(ra) # 7e6 <exit>
 50c:	6485                	lui	s1,0x1
 50e:	fa048493          	addi	s1,s1,-96 # fa0 <digits+0x78>
          readfile(file, 1, BSIZE);
 512:	40000613          	li	a2,1024
 516:	4585                	li	a1,1
 518:	fd840513          	addi	a0,s0,-40
 51c:	00000097          	auipc	ra,0x0
 520:	ba0080e7          	jalr	-1120(ra) # bc <readfile>
        for (i = 0; i < N*20; i++) {
 524:	34fd                	addiw	s1,s1,-1
 526:	f4f5                	bnez	s1,512 <test1+0x11a>
        unlink(file);
 528:	fd840513          	addi	a0,s0,-40
 52c:	00000097          	auipc	ra,0x0
 530:	30a080e7          	jalr	778(ra) # 836 <unlink>
      exit(0);
 534:	4501                	li	a0,0
 536:	00000097          	auipc	ra,0x0
 53a:	2b0080e7          	jalr	688(ra) # 7e6 <exit>

000000000000053e <main>:
{
 53e:	1141                	addi	sp,sp,-16
 540:	e406                	sd	ra,8(sp)
 542:	e022                	sd	s0,0(sp)
 544:	0800                	addi	s0,sp,16
  test0();
 546:	00000097          	auipc	ra,0x0
 54a:	ce0080e7          	jalr	-800(ra) # 226 <test0>
  test1();
 54e:	00000097          	auipc	ra,0x0
 552:	eaa080e7          	jalr	-342(ra) # 3f8 <test1>
  exit(0);
 556:	4501                	li	a0,0
 558:	00000097          	auipc	ra,0x0
 55c:	28e080e7          	jalr	654(ra) # 7e6 <exit>

0000000000000560 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 560:	1141                	addi	sp,sp,-16
 562:	e406                	sd	ra,8(sp)
 564:	e022                	sd	s0,0(sp)
 566:	0800                	addi	s0,sp,16
  extern int main();
  main();
 568:	00000097          	auipc	ra,0x0
 56c:	fd6080e7          	jalr	-42(ra) # 53e <main>
  exit(0);
 570:	4501                	li	a0,0
 572:	00000097          	auipc	ra,0x0
 576:	274080e7          	jalr	628(ra) # 7e6 <exit>

000000000000057a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 57a:	1141                	addi	sp,sp,-16
 57c:	e422                	sd	s0,8(sp)
 57e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 580:	87aa                	mv	a5,a0
 582:	0585                	addi	a1,a1,1 # 19001 <base+0x16ff1>
 584:	0785                	addi	a5,a5,1
 586:	fff5c703          	lbu	a4,-1(a1)
 58a:	fee78fa3          	sb	a4,-1(a5)
 58e:	fb75                	bnez	a4,582 <strcpy+0x8>
    ;
  return os;
}
 590:	6422                	ld	s0,8(sp)
 592:	0141                	addi	sp,sp,16
 594:	8082                	ret

0000000000000596 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 596:	1141                	addi	sp,sp,-16
 598:	e422                	sd	s0,8(sp)
 59a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 59c:	00054783          	lbu	a5,0(a0)
 5a0:	cb91                	beqz	a5,5b4 <strcmp+0x1e>
 5a2:	0005c703          	lbu	a4,0(a1)
 5a6:	00f71763          	bne	a4,a5,5b4 <strcmp+0x1e>
    p++, q++;
 5aa:	0505                	addi	a0,a0,1
 5ac:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 5ae:	00054783          	lbu	a5,0(a0)
 5b2:	fbe5                	bnez	a5,5a2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 5b4:	0005c503          	lbu	a0,0(a1)
}
 5b8:	40a7853b          	subw	a0,a5,a0
 5bc:	6422                	ld	s0,8(sp)
 5be:	0141                	addi	sp,sp,16
 5c0:	8082                	ret

00000000000005c2 <strlen>:

uint
strlen(const char *s)
{
 5c2:	1141                	addi	sp,sp,-16
 5c4:	e422                	sd	s0,8(sp)
 5c6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 5c8:	00054783          	lbu	a5,0(a0)
 5cc:	cf91                	beqz	a5,5e8 <strlen+0x26>
 5ce:	0505                	addi	a0,a0,1
 5d0:	87aa                	mv	a5,a0
 5d2:	4685                	li	a3,1
 5d4:	9e89                	subw	a3,a3,a0
 5d6:	00f6853b          	addw	a0,a3,a5
 5da:	0785                	addi	a5,a5,1
 5dc:	fff7c703          	lbu	a4,-1(a5)
 5e0:	fb7d                	bnez	a4,5d6 <strlen+0x14>
    ;
  return n;
}
 5e2:	6422                	ld	s0,8(sp)
 5e4:	0141                	addi	sp,sp,16
 5e6:	8082                	ret
  for(n = 0; s[n]; n++)
 5e8:	4501                	li	a0,0
 5ea:	bfe5                	j	5e2 <strlen+0x20>

00000000000005ec <memset>:

void*
memset(void *dst, int c, uint n)
{
 5ec:	1141                	addi	sp,sp,-16
 5ee:	e422                	sd	s0,8(sp)
 5f0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 5f2:	ca19                	beqz	a2,608 <memset+0x1c>
 5f4:	87aa                	mv	a5,a0
 5f6:	1602                	slli	a2,a2,0x20
 5f8:	9201                	srli	a2,a2,0x20
 5fa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 5fe:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 602:	0785                	addi	a5,a5,1
 604:	fee79de3          	bne	a5,a4,5fe <memset+0x12>
  }
  return dst;
}
 608:	6422                	ld	s0,8(sp)
 60a:	0141                	addi	sp,sp,16
 60c:	8082                	ret

000000000000060e <strchr>:

char*
strchr(const char *s, char c)
{
 60e:	1141                	addi	sp,sp,-16
 610:	e422                	sd	s0,8(sp)
 612:	0800                	addi	s0,sp,16
  for(; *s; s++)
 614:	00054783          	lbu	a5,0(a0)
 618:	cb99                	beqz	a5,62e <strchr+0x20>
    if(*s == c)
 61a:	00f58763          	beq	a1,a5,628 <strchr+0x1a>
  for(; *s; s++)
 61e:	0505                	addi	a0,a0,1
 620:	00054783          	lbu	a5,0(a0)
 624:	fbfd                	bnez	a5,61a <strchr+0xc>
      return (char*)s;
  return 0;
 626:	4501                	li	a0,0
}
 628:	6422                	ld	s0,8(sp)
 62a:	0141                	addi	sp,sp,16
 62c:	8082                	ret
  return 0;
 62e:	4501                	li	a0,0
 630:	bfe5                	j	628 <strchr+0x1a>

0000000000000632 <gets>:

char*
gets(char *buf, int max)
{
 632:	711d                	addi	sp,sp,-96
 634:	ec86                	sd	ra,88(sp)
 636:	e8a2                	sd	s0,80(sp)
 638:	e4a6                	sd	s1,72(sp)
 63a:	e0ca                	sd	s2,64(sp)
 63c:	fc4e                	sd	s3,56(sp)
 63e:	f852                	sd	s4,48(sp)
 640:	f456                	sd	s5,40(sp)
 642:	f05a                	sd	s6,32(sp)
 644:	ec5e                	sd	s7,24(sp)
 646:	1080                	addi	s0,sp,96
 648:	8baa                	mv	s7,a0
 64a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 64c:	892a                	mv	s2,a0
 64e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 650:	4aa9                	li	s5,10
 652:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 654:	89a6                	mv	s3,s1
 656:	2485                	addiw	s1,s1,1
 658:	0344d863          	bge	s1,s4,688 <gets+0x56>
    cc = read(0, &c, 1);
 65c:	4605                	li	a2,1
 65e:	faf40593          	addi	a1,s0,-81
 662:	4501                	li	a0,0
 664:	00000097          	auipc	ra,0x0
 668:	19a080e7          	jalr	410(ra) # 7fe <read>
    if(cc < 1)
 66c:	00a05e63          	blez	a0,688 <gets+0x56>
    buf[i++] = c;
 670:	faf44783          	lbu	a5,-81(s0)
 674:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 678:	01578763          	beq	a5,s5,686 <gets+0x54>
 67c:	0905                	addi	s2,s2,1
 67e:	fd679be3          	bne	a5,s6,654 <gets+0x22>
  for(i=0; i+1 < max; ){
 682:	89a6                	mv	s3,s1
 684:	a011                	j	688 <gets+0x56>
 686:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 688:	99de                	add	s3,s3,s7
 68a:	00098023          	sb	zero,0(s3)
  return buf;
}
 68e:	855e                	mv	a0,s7
 690:	60e6                	ld	ra,88(sp)
 692:	6446                	ld	s0,80(sp)
 694:	64a6                	ld	s1,72(sp)
 696:	6906                	ld	s2,64(sp)
 698:	79e2                	ld	s3,56(sp)
 69a:	7a42                	ld	s4,48(sp)
 69c:	7aa2                	ld	s5,40(sp)
 69e:	7b02                	ld	s6,32(sp)
 6a0:	6be2                	ld	s7,24(sp)
 6a2:	6125                	addi	sp,sp,96
 6a4:	8082                	ret

00000000000006a6 <stat>:

int
stat(const char *n, struct stat *st)
{
 6a6:	1101                	addi	sp,sp,-32
 6a8:	ec06                	sd	ra,24(sp)
 6aa:	e822                	sd	s0,16(sp)
 6ac:	e426                	sd	s1,8(sp)
 6ae:	e04a                	sd	s2,0(sp)
 6b0:	1000                	addi	s0,sp,32
 6b2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 6b4:	4581                	li	a1,0
 6b6:	00000097          	auipc	ra,0x0
 6ba:	170080e7          	jalr	368(ra) # 826 <open>
  if(fd < 0)
 6be:	02054563          	bltz	a0,6e8 <stat+0x42>
 6c2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 6c4:	85ca                	mv	a1,s2
 6c6:	00000097          	auipc	ra,0x0
 6ca:	178080e7          	jalr	376(ra) # 83e <fstat>
 6ce:	892a                	mv	s2,a0
  close(fd);
 6d0:	8526                	mv	a0,s1
 6d2:	00000097          	auipc	ra,0x0
 6d6:	13c080e7          	jalr	316(ra) # 80e <close>
  return r;
}
 6da:	854a                	mv	a0,s2
 6dc:	60e2                	ld	ra,24(sp)
 6de:	6442                	ld	s0,16(sp)
 6e0:	64a2                	ld	s1,8(sp)
 6e2:	6902                	ld	s2,0(sp)
 6e4:	6105                	addi	sp,sp,32
 6e6:	8082                	ret
    return -1;
 6e8:	597d                	li	s2,-1
 6ea:	bfc5                	j	6da <stat+0x34>

00000000000006ec <atoi>:

int
atoi(const char *s)
{
 6ec:	1141                	addi	sp,sp,-16
 6ee:	e422                	sd	s0,8(sp)
 6f0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6f2:	00054683          	lbu	a3,0(a0)
 6f6:	fd06879b          	addiw	a5,a3,-48
 6fa:	0ff7f793          	zext.b	a5,a5
 6fe:	4625                	li	a2,9
 700:	02f66863          	bltu	a2,a5,730 <atoi+0x44>
 704:	872a                	mv	a4,a0
  n = 0;
 706:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 708:	0705                	addi	a4,a4,1
 70a:	0025179b          	slliw	a5,a0,0x2
 70e:	9fa9                	addw	a5,a5,a0
 710:	0017979b          	slliw	a5,a5,0x1
 714:	9fb5                	addw	a5,a5,a3
 716:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 71a:	00074683          	lbu	a3,0(a4)
 71e:	fd06879b          	addiw	a5,a3,-48
 722:	0ff7f793          	zext.b	a5,a5
 726:	fef671e3          	bgeu	a2,a5,708 <atoi+0x1c>
  return n;
}
 72a:	6422                	ld	s0,8(sp)
 72c:	0141                	addi	sp,sp,16
 72e:	8082                	ret
  n = 0;
 730:	4501                	li	a0,0
 732:	bfe5                	j	72a <atoi+0x3e>

0000000000000734 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 734:	1141                	addi	sp,sp,-16
 736:	e422                	sd	s0,8(sp)
 738:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 73a:	02b57463          	bgeu	a0,a1,762 <memmove+0x2e>
    while(n-- > 0)
 73e:	00c05f63          	blez	a2,75c <memmove+0x28>
 742:	1602                	slli	a2,a2,0x20
 744:	9201                	srli	a2,a2,0x20
 746:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 74a:	872a                	mv	a4,a0
      *dst++ = *src++;
 74c:	0585                	addi	a1,a1,1
 74e:	0705                	addi	a4,a4,1
 750:	fff5c683          	lbu	a3,-1(a1)
 754:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 758:	fee79ae3          	bne	a5,a4,74c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 75c:	6422                	ld	s0,8(sp)
 75e:	0141                	addi	sp,sp,16
 760:	8082                	ret
    dst += n;
 762:	00c50733          	add	a4,a0,a2
    src += n;
 766:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 768:	fec05ae3          	blez	a2,75c <memmove+0x28>
 76c:	fff6079b          	addiw	a5,a2,-1
 770:	1782                	slli	a5,a5,0x20
 772:	9381                	srli	a5,a5,0x20
 774:	fff7c793          	not	a5,a5
 778:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 77a:	15fd                	addi	a1,a1,-1
 77c:	177d                	addi	a4,a4,-1
 77e:	0005c683          	lbu	a3,0(a1)
 782:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 786:	fee79ae3          	bne	a5,a4,77a <memmove+0x46>
 78a:	bfc9                	j	75c <memmove+0x28>

000000000000078c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 78c:	1141                	addi	sp,sp,-16
 78e:	e422                	sd	s0,8(sp)
 790:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 792:	ca05                	beqz	a2,7c2 <memcmp+0x36>
 794:	fff6069b          	addiw	a3,a2,-1
 798:	1682                	slli	a3,a3,0x20
 79a:	9281                	srli	a3,a3,0x20
 79c:	0685                	addi	a3,a3,1
 79e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 7a0:	00054783          	lbu	a5,0(a0)
 7a4:	0005c703          	lbu	a4,0(a1)
 7a8:	00e79863          	bne	a5,a4,7b8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 7ac:	0505                	addi	a0,a0,1
    p2++;
 7ae:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 7b0:	fed518e3          	bne	a0,a3,7a0 <memcmp+0x14>
  }
  return 0;
 7b4:	4501                	li	a0,0
 7b6:	a019                	j	7bc <memcmp+0x30>
      return *p1 - *p2;
 7b8:	40e7853b          	subw	a0,a5,a4
}
 7bc:	6422                	ld	s0,8(sp)
 7be:	0141                	addi	sp,sp,16
 7c0:	8082                	ret
  return 0;
 7c2:	4501                	li	a0,0
 7c4:	bfe5                	j	7bc <memcmp+0x30>

00000000000007c6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 7c6:	1141                	addi	sp,sp,-16
 7c8:	e406                	sd	ra,8(sp)
 7ca:	e022                	sd	s0,0(sp)
 7cc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 7ce:	00000097          	auipc	ra,0x0
 7d2:	f66080e7          	jalr	-154(ra) # 734 <memmove>
}
 7d6:	60a2                	ld	ra,8(sp)
 7d8:	6402                	ld	s0,0(sp)
 7da:	0141                	addi	sp,sp,16
 7dc:	8082                	ret

00000000000007de <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 7de:	4885                	li	a7,1
 ecall
 7e0:	00000073          	ecall
 ret
 7e4:	8082                	ret

00000000000007e6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 7e6:	4889                	li	a7,2
 ecall
 7e8:	00000073          	ecall
 ret
 7ec:	8082                	ret

00000000000007ee <wait>:
.global wait
wait:
 li a7, SYS_wait
 7ee:	488d                	li	a7,3
 ecall
 7f0:	00000073          	ecall
 ret
 7f4:	8082                	ret

00000000000007f6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 7f6:	4891                	li	a7,4
 ecall
 7f8:	00000073          	ecall
 ret
 7fc:	8082                	ret

00000000000007fe <read>:
.global read
read:
 li a7, SYS_read
 7fe:	4895                	li	a7,5
 ecall
 800:	00000073          	ecall
 ret
 804:	8082                	ret

0000000000000806 <write>:
.global write
write:
 li a7, SYS_write
 806:	48c1                	li	a7,16
 ecall
 808:	00000073          	ecall
 ret
 80c:	8082                	ret

000000000000080e <close>:
.global close
close:
 li a7, SYS_close
 80e:	48d5                	li	a7,21
 ecall
 810:	00000073          	ecall
 ret
 814:	8082                	ret

0000000000000816 <kill>:
.global kill
kill:
 li a7, SYS_kill
 816:	4899                	li	a7,6
 ecall
 818:	00000073          	ecall
 ret
 81c:	8082                	ret

000000000000081e <exec>:
.global exec
exec:
 li a7, SYS_exec
 81e:	489d                	li	a7,7
 ecall
 820:	00000073          	ecall
 ret
 824:	8082                	ret

0000000000000826 <open>:
.global open
open:
 li a7, SYS_open
 826:	48bd                	li	a7,15
 ecall
 828:	00000073          	ecall
 ret
 82c:	8082                	ret

000000000000082e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 82e:	48c5                	li	a7,17
 ecall
 830:	00000073          	ecall
 ret
 834:	8082                	ret

0000000000000836 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 836:	48c9                	li	a7,18
 ecall
 838:	00000073          	ecall
 ret
 83c:	8082                	ret

000000000000083e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 83e:	48a1                	li	a7,8
 ecall
 840:	00000073          	ecall
 ret
 844:	8082                	ret

0000000000000846 <link>:
.global link
link:
 li a7, SYS_link
 846:	48cd                	li	a7,19
 ecall
 848:	00000073          	ecall
 ret
 84c:	8082                	ret

000000000000084e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 84e:	48d1                	li	a7,20
 ecall
 850:	00000073          	ecall
 ret
 854:	8082                	ret

0000000000000856 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 856:	48a5                	li	a7,9
 ecall
 858:	00000073          	ecall
 ret
 85c:	8082                	ret

000000000000085e <dup>:
.global dup
dup:
 li a7, SYS_dup
 85e:	48a9                	li	a7,10
 ecall
 860:	00000073          	ecall
 ret
 864:	8082                	ret

0000000000000866 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 866:	48ad                	li	a7,11
 ecall
 868:	00000073          	ecall
 ret
 86c:	8082                	ret

000000000000086e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 86e:	48b1                	li	a7,12
 ecall
 870:	00000073          	ecall
 ret
 874:	8082                	ret

0000000000000876 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 876:	48b5                	li	a7,13
 ecall
 878:	00000073          	ecall
 ret
 87c:	8082                	ret

000000000000087e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 87e:	48b9                	li	a7,14
 ecall
 880:	00000073          	ecall
 ret
 884:	8082                	ret

0000000000000886 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 886:	1101                	addi	sp,sp,-32
 888:	ec06                	sd	ra,24(sp)
 88a:	e822                	sd	s0,16(sp)
 88c:	1000                	addi	s0,sp,32
 88e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 892:	4605                	li	a2,1
 894:	fef40593          	addi	a1,s0,-17
 898:	00000097          	auipc	ra,0x0
 89c:	f6e080e7          	jalr	-146(ra) # 806 <write>
}
 8a0:	60e2                	ld	ra,24(sp)
 8a2:	6442                	ld	s0,16(sp)
 8a4:	6105                	addi	sp,sp,32
 8a6:	8082                	ret

00000000000008a8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 8a8:	7139                	addi	sp,sp,-64
 8aa:	fc06                	sd	ra,56(sp)
 8ac:	f822                	sd	s0,48(sp)
 8ae:	f426                	sd	s1,40(sp)
 8b0:	f04a                	sd	s2,32(sp)
 8b2:	ec4e                	sd	s3,24(sp)
 8b4:	0080                	addi	s0,sp,64
 8b6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 8b8:	c299                	beqz	a3,8be <printint+0x16>
 8ba:	0805c963          	bltz	a1,94c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 8be:	2581                	sext.w	a1,a1
  neg = 0;
 8c0:	4881                	li	a7,0
 8c2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 8c6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 8c8:	2601                	sext.w	a2,a2
 8ca:	00000517          	auipc	a0,0x0
 8ce:	65e50513          	addi	a0,a0,1630 # f28 <digits>
 8d2:	883a                	mv	a6,a4
 8d4:	2705                	addiw	a4,a4,1
 8d6:	02c5f7bb          	remuw	a5,a1,a2
 8da:	1782                	slli	a5,a5,0x20
 8dc:	9381                	srli	a5,a5,0x20
 8de:	97aa                	add	a5,a5,a0
 8e0:	0007c783          	lbu	a5,0(a5)
 8e4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 8e8:	0005879b          	sext.w	a5,a1
 8ec:	02c5d5bb          	divuw	a1,a1,a2
 8f0:	0685                	addi	a3,a3,1
 8f2:	fec7f0e3          	bgeu	a5,a2,8d2 <printint+0x2a>
  if(neg)
 8f6:	00088c63          	beqz	a7,90e <printint+0x66>
    buf[i++] = '-';
 8fa:	fd070793          	addi	a5,a4,-48
 8fe:	00878733          	add	a4,a5,s0
 902:	02d00793          	li	a5,45
 906:	fef70823          	sb	a5,-16(a4)
 90a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 90e:	02e05863          	blez	a4,93e <printint+0x96>
 912:	fc040793          	addi	a5,s0,-64
 916:	00e78933          	add	s2,a5,a4
 91a:	fff78993          	addi	s3,a5,-1
 91e:	99ba                	add	s3,s3,a4
 920:	377d                	addiw	a4,a4,-1
 922:	1702                	slli	a4,a4,0x20
 924:	9301                	srli	a4,a4,0x20
 926:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 92a:	fff94583          	lbu	a1,-1(s2)
 92e:	8526                	mv	a0,s1
 930:	00000097          	auipc	ra,0x0
 934:	f56080e7          	jalr	-170(ra) # 886 <putc>
  while(--i >= 0)
 938:	197d                	addi	s2,s2,-1
 93a:	ff3918e3          	bne	s2,s3,92a <printint+0x82>
}
 93e:	70e2                	ld	ra,56(sp)
 940:	7442                	ld	s0,48(sp)
 942:	74a2                	ld	s1,40(sp)
 944:	7902                	ld	s2,32(sp)
 946:	69e2                	ld	s3,24(sp)
 948:	6121                	addi	sp,sp,64
 94a:	8082                	ret
    x = -xx;
 94c:	40b005bb          	negw	a1,a1
    neg = 1;
 950:	4885                	li	a7,1
    x = -xx;
 952:	bf85                	j	8c2 <printint+0x1a>

0000000000000954 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 954:	7119                	addi	sp,sp,-128
 956:	fc86                	sd	ra,120(sp)
 958:	f8a2                	sd	s0,112(sp)
 95a:	f4a6                	sd	s1,104(sp)
 95c:	f0ca                	sd	s2,96(sp)
 95e:	ecce                	sd	s3,88(sp)
 960:	e8d2                	sd	s4,80(sp)
 962:	e4d6                	sd	s5,72(sp)
 964:	e0da                	sd	s6,64(sp)
 966:	fc5e                	sd	s7,56(sp)
 968:	f862                	sd	s8,48(sp)
 96a:	f466                	sd	s9,40(sp)
 96c:	f06a                	sd	s10,32(sp)
 96e:	ec6e                	sd	s11,24(sp)
 970:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 972:	0005c903          	lbu	s2,0(a1)
 976:	18090f63          	beqz	s2,b14 <vprintf+0x1c0>
 97a:	8aaa                	mv	s5,a0
 97c:	8b32                	mv	s6,a2
 97e:	00158493          	addi	s1,a1,1
  state = 0;
 982:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 984:	02500a13          	li	s4,37
 988:	4c55                	li	s8,21
 98a:	00000c97          	auipc	s9,0x0
 98e:	546c8c93          	addi	s9,s9,1350 # ed0 <statistics+0x1d2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 992:	02800d93          	li	s11,40
  putc(fd, 'x');
 996:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 998:	00000b97          	auipc	s7,0x0
 99c:	590b8b93          	addi	s7,s7,1424 # f28 <digits>
 9a0:	a839                	j	9be <vprintf+0x6a>
        putc(fd, c);
 9a2:	85ca                	mv	a1,s2
 9a4:	8556                	mv	a0,s5
 9a6:	00000097          	auipc	ra,0x0
 9aa:	ee0080e7          	jalr	-288(ra) # 886 <putc>
 9ae:	a019                	j	9b4 <vprintf+0x60>
    } else if(state == '%'){
 9b0:	01498d63          	beq	s3,s4,9ca <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 9b4:	0485                	addi	s1,s1,1
 9b6:	fff4c903          	lbu	s2,-1(s1)
 9ba:	14090d63          	beqz	s2,b14 <vprintf+0x1c0>
    if(state == 0){
 9be:	fe0999e3          	bnez	s3,9b0 <vprintf+0x5c>
      if(c == '%'){
 9c2:	ff4910e3          	bne	s2,s4,9a2 <vprintf+0x4e>
        state = '%';
 9c6:	89d2                	mv	s3,s4
 9c8:	b7f5                	j	9b4 <vprintf+0x60>
      if(c == 'd'){
 9ca:	11490c63          	beq	s2,s4,ae2 <vprintf+0x18e>
 9ce:	f9d9079b          	addiw	a5,s2,-99
 9d2:	0ff7f793          	zext.b	a5,a5
 9d6:	10fc6e63          	bltu	s8,a5,af2 <vprintf+0x19e>
 9da:	f9d9079b          	addiw	a5,s2,-99
 9de:	0ff7f713          	zext.b	a4,a5
 9e2:	10ec6863          	bltu	s8,a4,af2 <vprintf+0x19e>
 9e6:	00271793          	slli	a5,a4,0x2
 9ea:	97e6                	add	a5,a5,s9
 9ec:	439c                	lw	a5,0(a5)
 9ee:	97e6                	add	a5,a5,s9
 9f0:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 9f2:	008b0913          	addi	s2,s6,8
 9f6:	4685                	li	a3,1
 9f8:	4629                	li	a2,10
 9fa:	000b2583          	lw	a1,0(s6)
 9fe:	8556                	mv	a0,s5
 a00:	00000097          	auipc	ra,0x0
 a04:	ea8080e7          	jalr	-344(ra) # 8a8 <printint>
 a08:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 a0a:	4981                	li	s3,0
 a0c:	b765                	j	9b4 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a0e:	008b0913          	addi	s2,s6,8
 a12:	4681                	li	a3,0
 a14:	4629                	li	a2,10
 a16:	000b2583          	lw	a1,0(s6)
 a1a:	8556                	mv	a0,s5
 a1c:	00000097          	auipc	ra,0x0
 a20:	e8c080e7          	jalr	-372(ra) # 8a8 <printint>
 a24:	8b4a                	mv	s6,s2
      state = 0;
 a26:	4981                	li	s3,0
 a28:	b771                	j	9b4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 a2a:	008b0913          	addi	s2,s6,8
 a2e:	4681                	li	a3,0
 a30:	866a                	mv	a2,s10
 a32:	000b2583          	lw	a1,0(s6)
 a36:	8556                	mv	a0,s5
 a38:	00000097          	auipc	ra,0x0
 a3c:	e70080e7          	jalr	-400(ra) # 8a8 <printint>
 a40:	8b4a                	mv	s6,s2
      state = 0;
 a42:	4981                	li	s3,0
 a44:	bf85                	j	9b4 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 a46:	008b0793          	addi	a5,s6,8
 a4a:	f8f43423          	sd	a5,-120(s0)
 a4e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 a52:	03000593          	li	a1,48
 a56:	8556                	mv	a0,s5
 a58:	00000097          	auipc	ra,0x0
 a5c:	e2e080e7          	jalr	-466(ra) # 886 <putc>
  putc(fd, 'x');
 a60:	07800593          	li	a1,120
 a64:	8556                	mv	a0,s5
 a66:	00000097          	auipc	ra,0x0
 a6a:	e20080e7          	jalr	-480(ra) # 886 <putc>
 a6e:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a70:	03c9d793          	srli	a5,s3,0x3c
 a74:	97de                	add	a5,a5,s7
 a76:	0007c583          	lbu	a1,0(a5)
 a7a:	8556                	mv	a0,s5
 a7c:	00000097          	auipc	ra,0x0
 a80:	e0a080e7          	jalr	-502(ra) # 886 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a84:	0992                	slli	s3,s3,0x4
 a86:	397d                	addiw	s2,s2,-1
 a88:	fe0914e3          	bnez	s2,a70 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 a8c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 a90:	4981                	li	s3,0
 a92:	b70d                	j	9b4 <vprintf+0x60>
        s = va_arg(ap, char*);
 a94:	008b0913          	addi	s2,s6,8
 a98:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 a9c:	02098163          	beqz	s3,abe <vprintf+0x16a>
        while(*s != 0){
 aa0:	0009c583          	lbu	a1,0(s3)
 aa4:	c5ad                	beqz	a1,b0e <vprintf+0x1ba>
          putc(fd, *s);
 aa6:	8556                	mv	a0,s5
 aa8:	00000097          	auipc	ra,0x0
 aac:	dde080e7          	jalr	-546(ra) # 886 <putc>
          s++;
 ab0:	0985                	addi	s3,s3,1
        while(*s != 0){
 ab2:	0009c583          	lbu	a1,0(s3)
 ab6:	f9e5                	bnez	a1,aa6 <vprintf+0x152>
        s = va_arg(ap, char*);
 ab8:	8b4a                	mv	s6,s2
      state = 0;
 aba:	4981                	li	s3,0
 abc:	bde5                	j	9b4 <vprintf+0x60>
          s = "(null)";
 abe:	00000997          	auipc	s3,0x0
 ac2:	40a98993          	addi	s3,s3,1034 # ec8 <statistics+0x1ca>
        while(*s != 0){
 ac6:	85ee                	mv	a1,s11
 ac8:	bff9                	j	aa6 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 aca:	008b0913          	addi	s2,s6,8
 ace:	000b4583          	lbu	a1,0(s6)
 ad2:	8556                	mv	a0,s5
 ad4:	00000097          	auipc	ra,0x0
 ad8:	db2080e7          	jalr	-590(ra) # 886 <putc>
 adc:	8b4a                	mv	s6,s2
      state = 0;
 ade:	4981                	li	s3,0
 ae0:	bdd1                	j	9b4 <vprintf+0x60>
        putc(fd, c);
 ae2:	85d2                	mv	a1,s4
 ae4:	8556                	mv	a0,s5
 ae6:	00000097          	auipc	ra,0x0
 aea:	da0080e7          	jalr	-608(ra) # 886 <putc>
      state = 0;
 aee:	4981                	li	s3,0
 af0:	b5d1                	j	9b4 <vprintf+0x60>
        putc(fd, '%');
 af2:	85d2                	mv	a1,s4
 af4:	8556                	mv	a0,s5
 af6:	00000097          	auipc	ra,0x0
 afa:	d90080e7          	jalr	-624(ra) # 886 <putc>
        putc(fd, c);
 afe:	85ca                	mv	a1,s2
 b00:	8556                	mv	a0,s5
 b02:	00000097          	auipc	ra,0x0
 b06:	d84080e7          	jalr	-636(ra) # 886 <putc>
      state = 0;
 b0a:	4981                	li	s3,0
 b0c:	b565                	j	9b4 <vprintf+0x60>
        s = va_arg(ap, char*);
 b0e:	8b4a                	mv	s6,s2
      state = 0;
 b10:	4981                	li	s3,0
 b12:	b54d                	j	9b4 <vprintf+0x60>
    }
  }
}
 b14:	70e6                	ld	ra,120(sp)
 b16:	7446                	ld	s0,112(sp)
 b18:	74a6                	ld	s1,104(sp)
 b1a:	7906                	ld	s2,96(sp)
 b1c:	69e6                	ld	s3,88(sp)
 b1e:	6a46                	ld	s4,80(sp)
 b20:	6aa6                	ld	s5,72(sp)
 b22:	6b06                	ld	s6,64(sp)
 b24:	7be2                	ld	s7,56(sp)
 b26:	7c42                	ld	s8,48(sp)
 b28:	7ca2                	ld	s9,40(sp)
 b2a:	7d02                	ld	s10,32(sp)
 b2c:	6de2                	ld	s11,24(sp)
 b2e:	6109                	addi	sp,sp,128
 b30:	8082                	ret

0000000000000b32 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b32:	715d                	addi	sp,sp,-80
 b34:	ec06                	sd	ra,24(sp)
 b36:	e822                	sd	s0,16(sp)
 b38:	1000                	addi	s0,sp,32
 b3a:	e010                	sd	a2,0(s0)
 b3c:	e414                	sd	a3,8(s0)
 b3e:	e818                	sd	a4,16(s0)
 b40:	ec1c                	sd	a5,24(s0)
 b42:	03043023          	sd	a6,32(s0)
 b46:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b4a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b4e:	8622                	mv	a2,s0
 b50:	00000097          	auipc	ra,0x0
 b54:	e04080e7          	jalr	-508(ra) # 954 <vprintf>
}
 b58:	60e2                	ld	ra,24(sp)
 b5a:	6442                	ld	s0,16(sp)
 b5c:	6161                	addi	sp,sp,80
 b5e:	8082                	ret

0000000000000b60 <printf>:

void
printf(const char *fmt, ...)
{
 b60:	711d                	addi	sp,sp,-96
 b62:	ec06                	sd	ra,24(sp)
 b64:	e822                	sd	s0,16(sp)
 b66:	1000                	addi	s0,sp,32
 b68:	e40c                	sd	a1,8(s0)
 b6a:	e810                	sd	a2,16(s0)
 b6c:	ec14                	sd	a3,24(s0)
 b6e:	f018                	sd	a4,32(s0)
 b70:	f41c                	sd	a5,40(s0)
 b72:	03043823          	sd	a6,48(s0)
 b76:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b7a:	00840613          	addi	a2,s0,8
 b7e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b82:	85aa                	mv	a1,a0
 b84:	4505                	li	a0,1
 b86:	00000097          	auipc	ra,0x0
 b8a:	dce080e7          	jalr	-562(ra) # 954 <vprintf>
}
 b8e:	60e2                	ld	ra,24(sp)
 b90:	6442                	ld	s0,16(sp)
 b92:	6125                	addi	sp,sp,96
 b94:	8082                	ret

0000000000000b96 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b96:	1141                	addi	sp,sp,-16
 b98:	e422                	sd	s0,8(sp)
 b9a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b9c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ba0:	00000797          	auipc	a5,0x0
 ba4:	4607b783          	ld	a5,1120(a5) # 1000 <freep>
 ba8:	a02d                	j	bd2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 baa:	4618                	lw	a4,8(a2)
 bac:	9f2d                	addw	a4,a4,a1
 bae:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 bb2:	6398                	ld	a4,0(a5)
 bb4:	6310                	ld	a2,0(a4)
 bb6:	a83d                	j	bf4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 bb8:	ff852703          	lw	a4,-8(a0)
 bbc:	9f31                	addw	a4,a4,a2
 bbe:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 bc0:	ff053683          	ld	a3,-16(a0)
 bc4:	a091                	j	c08 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bc6:	6398                	ld	a4,0(a5)
 bc8:	00e7e463          	bltu	a5,a4,bd0 <free+0x3a>
 bcc:	00e6ea63          	bltu	a3,a4,be0 <free+0x4a>
{
 bd0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bd2:	fed7fae3          	bgeu	a5,a3,bc6 <free+0x30>
 bd6:	6398                	ld	a4,0(a5)
 bd8:	00e6e463          	bltu	a3,a4,be0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bdc:	fee7eae3          	bltu	a5,a4,bd0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 be0:	ff852583          	lw	a1,-8(a0)
 be4:	6390                	ld	a2,0(a5)
 be6:	02059813          	slli	a6,a1,0x20
 bea:	01c85713          	srli	a4,a6,0x1c
 bee:	9736                	add	a4,a4,a3
 bf0:	fae60de3          	beq	a2,a4,baa <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 bf4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 bf8:	4790                	lw	a2,8(a5)
 bfa:	02061593          	slli	a1,a2,0x20
 bfe:	01c5d713          	srli	a4,a1,0x1c
 c02:	973e                	add	a4,a4,a5
 c04:	fae68ae3          	beq	a3,a4,bb8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 c08:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 c0a:	00000717          	auipc	a4,0x0
 c0e:	3ef73b23          	sd	a5,1014(a4) # 1000 <freep>
}
 c12:	6422                	ld	s0,8(sp)
 c14:	0141                	addi	sp,sp,16
 c16:	8082                	ret

0000000000000c18 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c18:	7139                	addi	sp,sp,-64
 c1a:	fc06                	sd	ra,56(sp)
 c1c:	f822                	sd	s0,48(sp)
 c1e:	f426                	sd	s1,40(sp)
 c20:	f04a                	sd	s2,32(sp)
 c22:	ec4e                	sd	s3,24(sp)
 c24:	e852                	sd	s4,16(sp)
 c26:	e456                	sd	s5,8(sp)
 c28:	e05a                	sd	s6,0(sp)
 c2a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c2c:	02051493          	slli	s1,a0,0x20
 c30:	9081                	srli	s1,s1,0x20
 c32:	04bd                	addi	s1,s1,15
 c34:	8091                	srli	s1,s1,0x4
 c36:	0014899b          	addiw	s3,s1,1
 c3a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 c3c:	00000517          	auipc	a0,0x0
 c40:	3c453503          	ld	a0,964(a0) # 1000 <freep>
 c44:	c515                	beqz	a0,c70 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c46:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c48:	4798                	lw	a4,8(a5)
 c4a:	02977f63          	bgeu	a4,s1,c88 <malloc+0x70>
 c4e:	8a4e                	mv	s4,s3
 c50:	0009871b          	sext.w	a4,s3
 c54:	6685                	lui	a3,0x1
 c56:	00d77363          	bgeu	a4,a3,c5c <malloc+0x44>
 c5a:	6a05                	lui	s4,0x1
 c5c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c60:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c64:	00000917          	auipc	s2,0x0
 c68:	39c90913          	addi	s2,s2,924 # 1000 <freep>
  if(p == (char*)-1)
 c6c:	5afd                	li	s5,-1
 c6e:	a895                	j	ce2 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 c70:	00001797          	auipc	a5,0x1
 c74:	3a078793          	addi	a5,a5,928 # 2010 <base>
 c78:	00000717          	auipc	a4,0x0
 c7c:	38f73423          	sd	a5,904(a4) # 1000 <freep>
 c80:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c82:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c86:	b7e1                	j	c4e <malloc+0x36>
      if(p->s.size == nunits)
 c88:	02e48c63          	beq	s1,a4,cc0 <malloc+0xa8>
        p->s.size -= nunits;
 c8c:	4137073b          	subw	a4,a4,s3
 c90:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c92:	02071693          	slli	a3,a4,0x20
 c96:	01c6d713          	srli	a4,a3,0x1c
 c9a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c9c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ca0:	00000717          	auipc	a4,0x0
 ca4:	36a73023          	sd	a0,864(a4) # 1000 <freep>
      return (void*)(p + 1);
 ca8:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 cac:	70e2                	ld	ra,56(sp)
 cae:	7442                	ld	s0,48(sp)
 cb0:	74a2                	ld	s1,40(sp)
 cb2:	7902                	ld	s2,32(sp)
 cb4:	69e2                	ld	s3,24(sp)
 cb6:	6a42                	ld	s4,16(sp)
 cb8:	6aa2                	ld	s5,8(sp)
 cba:	6b02                	ld	s6,0(sp)
 cbc:	6121                	addi	sp,sp,64
 cbe:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 cc0:	6398                	ld	a4,0(a5)
 cc2:	e118                	sd	a4,0(a0)
 cc4:	bff1                	j	ca0 <malloc+0x88>
  hp->s.size = nu;
 cc6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 cca:	0541                	addi	a0,a0,16
 ccc:	00000097          	auipc	ra,0x0
 cd0:	eca080e7          	jalr	-310(ra) # b96 <free>
  return freep;
 cd4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 cd8:	d971                	beqz	a0,cac <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cda:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 cdc:	4798                	lw	a4,8(a5)
 cde:	fa9775e3          	bgeu	a4,s1,c88 <malloc+0x70>
    if(p == freep)
 ce2:	00093703          	ld	a4,0(s2)
 ce6:	853e                	mv	a0,a5
 ce8:	fef719e3          	bne	a4,a5,cda <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 cec:	8552                	mv	a0,s4
 cee:	00000097          	auipc	ra,0x0
 cf2:	b80080e7          	jalr	-1152(ra) # 86e <sbrk>
  if(p == (char*)-1)
 cf6:	fd5518e3          	bne	a0,s5,cc6 <malloc+0xae>
        return 0;
 cfa:	4501                	li	a0,0
 cfc:	bf45                	j	cac <malloc+0x94>

0000000000000cfe <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
 cfe:	7179                	addi	sp,sp,-48
 d00:	f406                	sd	ra,40(sp)
 d02:	f022                	sd	s0,32(sp)
 d04:	ec26                	sd	s1,24(sp)
 d06:	e84a                	sd	s2,16(sp)
 d08:	e44e                	sd	s3,8(sp)
 d0a:	e052                	sd	s4,0(sp)
 d0c:	1800                	addi	s0,sp,48
 d0e:	8a2a                	mv	s4,a0
 d10:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
 d12:	4581                	li	a1,0
 d14:	00000517          	auipc	a0,0x0
 d18:	22c50513          	addi	a0,a0,556 # f40 <digits+0x18>
 d1c:	00000097          	auipc	ra,0x0
 d20:	b0a080e7          	jalr	-1270(ra) # 826 <open>
  if(fd < 0) {
 d24:	04054263          	bltz	a0,d68 <statistics+0x6a>
 d28:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
 d2a:	4481                	li	s1,0
 d2c:	03205063          	blez	s2,d4c <statistics+0x4e>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
 d30:	4099063b          	subw	a2,s2,s1
 d34:	009a05b3          	add	a1,s4,s1
 d38:	854e                	mv	a0,s3
 d3a:	00000097          	auipc	ra,0x0
 d3e:	ac4080e7          	jalr	-1340(ra) # 7fe <read>
 d42:	00054563          	bltz	a0,d4c <statistics+0x4e>
      break;
    }
    i += n;
 d46:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
 d48:	ff24c4e3          	blt	s1,s2,d30 <statistics+0x32>
  }
  close(fd);
 d4c:	854e                	mv	a0,s3
 d4e:	00000097          	auipc	ra,0x0
 d52:	ac0080e7          	jalr	-1344(ra) # 80e <close>
  return i;
}
 d56:	8526                	mv	a0,s1
 d58:	70a2                	ld	ra,40(sp)
 d5a:	7402                	ld	s0,32(sp)
 d5c:	64e2                	ld	s1,24(sp)
 d5e:	6942                	ld	s2,16(sp)
 d60:	69a2                	ld	s3,8(sp)
 d62:	6a02                	ld	s4,0(sp)
 d64:	6145                	addi	sp,sp,48
 d66:	8082                	ret
      fprintf(2, "stats: open failed\n");
 d68:	00000597          	auipc	a1,0x0
 d6c:	1e858593          	addi	a1,a1,488 # f50 <digits+0x28>
 d70:	4509                	li	a0,2
 d72:	00000097          	auipc	ra,0x0
 d76:	dc0080e7          	jalr	-576(ra) # b32 <fprintf>
      exit(1);
 d7a:	4505                	li	a0,1
 d7c:	00000097          	auipc	ra,0x0
 d80:	a6a080e7          	jalr	-1430(ra) # 7e6 <exit>
