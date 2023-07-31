
user/_symlinktest：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <stat_slink>:
}

// stat a symbolic link using O_NOFOLLOW
static int
stat_slink(char *pn, struct stat *st)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84ae                	mv	s1,a1
  int fd = open(pn, O_RDONLY | O_NOFOLLOW);
   c:	6585                	lui	a1,0x1
   e:	80058593          	addi	a1,a1,-2048 # 800 <gets+0x5a>
  12:	00001097          	auipc	ra,0x1
  16:	988080e7          	jalr	-1656(ra) # 99a <open>
  if(fd < 0)
  1a:	02054063          	bltz	a0,3a <stat_slink+0x3a>
    return -1;
  if(fstat(fd, st) != 0)
  1e:	85a6                	mv	a1,s1
  20:	00001097          	auipc	ra,0x1
  24:	992080e7          	jalr	-1646(ra) # 9b2 <fstat>
  28:	00a03533          	snez	a0,a0
  2c:	40a00533          	neg	a0,a0
    return -1;
  return 0;
}
  30:	60e2                	ld	ra,24(sp)
  32:	6442                	ld	s0,16(sp)
  34:	64a2                	ld	s1,8(sp)
  36:	6105                	addi	sp,sp,32
  38:	8082                	ret
    return -1;
  3a:	557d                	li	a0,-1
  3c:	bfd5                	j	30 <stat_slink+0x30>

000000000000003e <main>:
{
  3e:	7119                	addi	sp,sp,-128
  40:	fc86                	sd	ra,120(sp)
  42:	f8a2                	sd	s0,112(sp)
  44:	f4a6                	sd	s1,104(sp)
  46:	f0ca                	sd	s2,96(sp)
  48:	ecce                	sd	s3,88(sp)
  4a:	e8d2                	sd	s4,80(sp)
  4c:	e4d6                	sd	s5,72(sp)
  4e:	e0da                	sd	s6,64(sp)
  50:	fc5e                	sd	s7,56(sp)
  52:	f862                	sd	s8,48(sp)
  54:	0100                	addi	s0,sp,128
  unlink("/testsymlink/a");
  56:	00001517          	auipc	a0,0x1
  5a:	e2a50513          	addi	a0,a0,-470 # e80 <malloc+0xec>
  5e:	00001097          	auipc	ra,0x1
  62:	94c080e7          	jalr	-1716(ra) # 9aa <unlink>
  unlink("/testsymlink/b");
  66:	00001517          	auipc	a0,0x1
  6a:	e2a50513          	addi	a0,a0,-470 # e90 <malloc+0xfc>
  6e:	00001097          	auipc	ra,0x1
  72:	93c080e7          	jalr	-1732(ra) # 9aa <unlink>
  unlink("/testsymlink/c");
  76:	00001517          	auipc	a0,0x1
  7a:	e2a50513          	addi	a0,a0,-470 # ea0 <malloc+0x10c>
  7e:	00001097          	auipc	ra,0x1
  82:	92c080e7          	jalr	-1748(ra) # 9aa <unlink>
  unlink("/testsymlink/1");
  86:	00001517          	auipc	a0,0x1
  8a:	e2a50513          	addi	a0,a0,-470 # eb0 <malloc+0x11c>
  8e:	00001097          	auipc	ra,0x1
  92:	91c080e7          	jalr	-1764(ra) # 9aa <unlink>
  unlink("/testsymlink/2");
  96:	00001517          	auipc	a0,0x1
  9a:	e2a50513          	addi	a0,a0,-470 # ec0 <malloc+0x12c>
  9e:	00001097          	auipc	ra,0x1
  a2:	90c080e7          	jalr	-1780(ra) # 9aa <unlink>
  unlink("/testsymlink/3");
  a6:	00001517          	auipc	a0,0x1
  aa:	e2a50513          	addi	a0,a0,-470 # ed0 <malloc+0x13c>
  ae:	00001097          	auipc	ra,0x1
  b2:	8fc080e7          	jalr	-1796(ra) # 9aa <unlink>
  unlink("/testsymlink/4");
  b6:	00001517          	auipc	a0,0x1
  ba:	e2a50513          	addi	a0,a0,-470 # ee0 <malloc+0x14c>
  be:	00001097          	auipc	ra,0x1
  c2:	8ec080e7          	jalr	-1812(ra) # 9aa <unlink>
  unlink("/testsymlink/z");
  c6:	00001517          	auipc	a0,0x1
  ca:	e2a50513          	addi	a0,a0,-470 # ef0 <malloc+0x15c>
  ce:	00001097          	auipc	ra,0x1
  d2:	8dc080e7          	jalr	-1828(ra) # 9aa <unlink>
  unlink("/testsymlink/y");
  d6:	00001517          	auipc	a0,0x1
  da:	e2a50513          	addi	a0,a0,-470 # f00 <malloc+0x16c>
  de:	00001097          	auipc	ra,0x1
  e2:	8cc080e7          	jalr	-1844(ra) # 9aa <unlink>
  unlink("/testsymlink");
  e6:	00001517          	auipc	a0,0x1
  ea:	e2a50513          	addi	a0,a0,-470 # f10 <malloc+0x17c>
  ee:	00001097          	auipc	ra,0x1
  f2:	8bc080e7          	jalr	-1860(ra) # 9aa <unlink>

static void
testsymlink(void)
{
  int r, fd1 = -1, fd2 = -1;
  char buf[4] = {'a', 'b', 'c', 'd'};
  f6:	646367b7          	lui	a5,0x64636
  fa:	26178793          	addi	a5,a5,609 # 64636261 <base+0x64634251>
  fe:	f8f42823          	sw	a5,-112(s0)
  char c = 0, c2 = 0;
 102:	f8040723          	sb	zero,-114(s0)
 106:	f80407a3          	sb	zero,-113(s0)
  struct stat st;
    
  printf("Start: test symlinks\n");
 10a:	00001517          	auipc	a0,0x1
 10e:	e1650513          	addi	a0,a0,-490 # f20 <malloc+0x18c>
 112:	00001097          	auipc	ra,0x1
 116:	bca080e7          	jalr	-1078(ra) # cdc <printf>

  mkdir("/testsymlink");
 11a:	00001517          	auipc	a0,0x1
 11e:	df650513          	addi	a0,a0,-522 # f10 <malloc+0x17c>
 122:	00001097          	auipc	ra,0x1
 126:	8a0080e7          	jalr	-1888(ra) # 9c2 <mkdir>

  fd1 = open("/testsymlink/a", O_CREATE | O_RDWR);
 12a:	20200593          	li	a1,514
 12e:	00001517          	auipc	a0,0x1
 132:	d5250513          	addi	a0,a0,-686 # e80 <malloc+0xec>
 136:	00001097          	auipc	ra,0x1
 13a:	864080e7          	jalr	-1948(ra) # 99a <open>
 13e:	84aa                	mv	s1,a0
  if(fd1 < 0) fail("failed to open a");
 140:	0e054f63          	bltz	a0,23e <main+0x200>

  r = symlink("/testsymlink/a", "/testsymlink/b");
 144:	00001597          	auipc	a1,0x1
 148:	d4c58593          	addi	a1,a1,-692 # e90 <malloc+0xfc>
 14c:	00001517          	auipc	a0,0x1
 150:	d3450513          	addi	a0,a0,-716 # e80 <malloc+0xec>
 154:	00001097          	auipc	ra,0x1
 158:	8a6080e7          	jalr	-1882(ra) # 9fa <symlink>
  if(r < 0)
 15c:	10054063          	bltz	a0,25c <main+0x21e>
    fail("symlink b -> a failed");

  if(write(fd1, buf, sizeof(buf)) != 4)
 160:	4611                	li	a2,4
 162:	f9040593          	addi	a1,s0,-112
 166:	8526                	mv	a0,s1
 168:	00001097          	auipc	ra,0x1
 16c:	812080e7          	jalr	-2030(ra) # 97a <write>
 170:	4791                	li	a5,4
 172:	10f50463          	beq	a0,a5,27a <main+0x23c>
    fail("failed to write to a");
 176:	00001517          	auipc	a0,0x1
 17a:	e0250513          	addi	a0,a0,-510 # f78 <malloc+0x1e4>
 17e:	00001097          	auipc	ra,0x1
 182:	b5e080e7          	jalr	-1186(ra) # cdc <printf>
 186:	4785                	li	a5,1
 188:	00002717          	auipc	a4,0x2
 18c:	e6f72c23          	sw	a5,-392(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
 190:	597d                	li	s2,-1
  if(c!=c2)
    fail("Value read from 4 differed from value written to 1\n");

  printf("test symlinks: ok\n");
done:
  close(fd1);
 192:	8526                	mv	a0,s1
 194:	00000097          	auipc	ra,0x0
 198:	7ee080e7          	jalr	2030(ra) # 982 <close>
  close(fd2);
 19c:	854a                	mv	a0,s2
 19e:	00000097          	auipc	ra,0x0
 1a2:	7e4080e7          	jalr	2020(ra) # 982 <close>
  int pid, i;
  int fd;
  struct stat st;
  int nchild = 2;

  printf("Start: test concurrent symlinks\n");
 1a6:	00001517          	auipc	a0,0x1
 1aa:	0b250513          	addi	a0,a0,178 # 1258 <malloc+0x4c4>
 1ae:	00001097          	auipc	ra,0x1
 1b2:	b2e080e7          	jalr	-1234(ra) # cdc <printf>
    
  fd = open("/testsymlink/z", O_CREATE | O_RDWR);
 1b6:	20200593          	li	a1,514
 1ba:	00001517          	auipc	a0,0x1
 1be:	d3650513          	addi	a0,a0,-714 # ef0 <malloc+0x15c>
 1c2:	00000097          	auipc	ra,0x0
 1c6:	7d8080e7          	jalr	2008(ra) # 99a <open>
  if(fd < 0) {
 1ca:	42054263          	bltz	a0,5ee <main+0x5b0>
    printf("FAILED: open failed");
    exit(1);
  }
  close(fd);
 1ce:	00000097          	auipc	ra,0x0
 1d2:	7b4080e7          	jalr	1972(ra) # 982 <close>

  for(int j = 0; j < nchild; j++) {
    pid = fork();
 1d6:	00000097          	auipc	ra,0x0
 1da:	77c080e7          	jalr	1916(ra) # 952 <fork>
    if(pid < 0){
 1de:	42054563          	bltz	a0,608 <main+0x5ca>
      printf("FAILED: fork failed\n");
      exit(1);
    }
    if(pid == 0) {
 1e2:	44050063          	beqz	a0,622 <main+0x5e4>
    pid = fork();
 1e6:	00000097          	auipc	ra,0x0
 1ea:	76c080e7          	jalr	1900(ra) # 952 <fork>
    if(pid < 0){
 1ee:	40054d63          	bltz	a0,608 <main+0x5ca>
    if(pid == 0) {
 1f2:	42050863          	beqz	a0,622 <main+0x5e4>
    }
  }

  int r;
  for(int j = 0; j < nchild; j++) {
    wait(&r);
 1f6:	f9840513          	addi	a0,s0,-104
 1fa:	00000097          	auipc	ra,0x0
 1fe:	768080e7          	jalr	1896(ra) # 962 <wait>
    if(r != 0) {
 202:	f9842783          	lw	a5,-104(s0)
 206:	4a079a63          	bnez	a5,6ba <main+0x67c>
    wait(&r);
 20a:	f9840513          	addi	a0,s0,-104
 20e:	00000097          	auipc	ra,0x0
 212:	754080e7          	jalr	1876(ra) # 962 <wait>
    if(r != 0) {
 216:	f9842783          	lw	a5,-104(s0)
 21a:	4a079063          	bnez	a5,6ba <main+0x67c>
      printf("test concurrent symlinks: failed\n");
      exit(1);
    }
  }
  printf("test concurrent symlinks: ok\n");
 21e:	00001517          	auipc	a0,0x1
 222:	0da50513          	addi	a0,a0,218 # 12f8 <malloc+0x564>
 226:	00001097          	auipc	ra,0x1
 22a:	ab6080e7          	jalr	-1354(ra) # cdc <printf>
  exit(failed);
 22e:	00002517          	auipc	a0,0x2
 232:	dd252503          	lw	a0,-558(a0) # 2000 <failed>
 236:	00000097          	auipc	ra,0x0
 23a:	724080e7          	jalr	1828(ra) # 95a <exit>
  if(fd1 < 0) fail("failed to open a");
 23e:	00001517          	auipc	a0,0x1
 242:	cfa50513          	addi	a0,a0,-774 # f38 <malloc+0x1a4>
 246:	00001097          	auipc	ra,0x1
 24a:	a96080e7          	jalr	-1386(ra) # cdc <printf>
 24e:	4785                	li	a5,1
 250:	00002717          	auipc	a4,0x2
 254:	daf72823          	sw	a5,-592(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
 258:	597d                	li	s2,-1
  if(fd1 < 0) fail("failed to open a");
 25a:	bf25                	j	192 <main+0x154>
    fail("symlink b -> a failed");
 25c:	00001517          	auipc	a0,0x1
 260:	cfc50513          	addi	a0,a0,-772 # f58 <malloc+0x1c4>
 264:	00001097          	auipc	ra,0x1
 268:	a78080e7          	jalr	-1416(ra) # cdc <printf>
 26c:	4785                	li	a5,1
 26e:	00002717          	auipc	a4,0x2
 272:	d8f72923          	sw	a5,-622(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
 276:	597d                	li	s2,-1
    fail("symlink b -> a failed");
 278:	bf29                	j	192 <main+0x154>
  if (stat_slink("/testsymlink/b", &st) != 0)
 27a:	f9840593          	addi	a1,s0,-104
 27e:	00001517          	auipc	a0,0x1
 282:	c1250513          	addi	a0,a0,-1006 # e90 <malloc+0xfc>
 286:	00000097          	auipc	ra,0x0
 28a:	d7a080e7          	jalr	-646(ra) # 0 <stat_slink>
 28e:	e50d                	bnez	a0,2b8 <main+0x27a>
  if(st.type != T_SYMLINK)
 290:	fa041703          	lh	a4,-96(s0)
 294:	4791                	li	a5,4
 296:	04f70063          	beq	a4,a5,2d6 <main+0x298>
    fail("b isn't a symlink");
 29a:	00001517          	auipc	a0,0x1
 29e:	d1e50513          	addi	a0,a0,-738 # fb8 <malloc+0x224>
 2a2:	00001097          	auipc	ra,0x1
 2a6:	a3a080e7          	jalr	-1478(ra) # cdc <printf>
 2aa:	4785                	li	a5,1
 2ac:	00002717          	auipc	a4,0x2
 2b0:	d4f72a23          	sw	a5,-684(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
 2b4:	597d                	li	s2,-1
    fail("b isn't a symlink");
 2b6:	bdf1                	j	192 <main+0x154>
    fail("failed to stat b");
 2b8:	00001517          	auipc	a0,0x1
 2bc:	ce050513          	addi	a0,a0,-800 # f98 <malloc+0x204>
 2c0:	00001097          	auipc	ra,0x1
 2c4:	a1c080e7          	jalr	-1508(ra) # cdc <printf>
 2c8:	4785                	li	a5,1
 2ca:	00002717          	auipc	a4,0x2
 2ce:	d2f72b23          	sw	a5,-714(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
 2d2:	597d                	li	s2,-1
    fail("failed to stat b");
 2d4:	bd7d                	j	192 <main+0x154>
  fd2 = open("/testsymlink/b", O_RDWR);
 2d6:	4589                	li	a1,2
 2d8:	00001517          	auipc	a0,0x1
 2dc:	bb850513          	addi	a0,a0,-1096 # e90 <malloc+0xfc>
 2e0:	00000097          	auipc	ra,0x0
 2e4:	6ba080e7          	jalr	1722(ra) # 99a <open>
 2e8:	892a                	mv	s2,a0
  if(fd2 < 0)
 2ea:	02054d63          	bltz	a0,324 <main+0x2e6>
  read(fd2, &c, 1);
 2ee:	4605                	li	a2,1
 2f0:	f8e40593          	addi	a1,s0,-114
 2f4:	00000097          	auipc	ra,0x0
 2f8:	67e080e7          	jalr	1662(ra) # 972 <read>
  if (c != 'a')
 2fc:	f8e44703          	lbu	a4,-114(s0)
 300:	06100793          	li	a5,97
 304:	02f70e63          	beq	a4,a5,340 <main+0x302>
    fail("failed to read bytes from b");
 308:	00001517          	auipc	a0,0x1
 30c:	cf050513          	addi	a0,a0,-784 # ff8 <malloc+0x264>
 310:	00001097          	auipc	ra,0x1
 314:	9cc080e7          	jalr	-1588(ra) # cdc <printf>
 318:	4785                	li	a5,1
 31a:	00002717          	auipc	a4,0x2
 31e:	cef72323          	sw	a5,-794(a4) # 2000 <failed>
 322:	bd85                	j	192 <main+0x154>
    fail("failed to open b");
 324:	00001517          	auipc	a0,0x1
 328:	cb450513          	addi	a0,a0,-844 # fd8 <malloc+0x244>
 32c:	00001097          	auipc	ra,0x1
 330:	9b0080e7          	jalr	-1616(ra) # cdc <printf>
 334:	4785                	li	a5,1
 336:	00002717          	auipc	a4,0x2
 33a:	ccf72523          	sw	a5,-822(a4) # 2000 <failed>
 33e:	bd91                	j	192 <main+0x154>
  unlink("/testsymlink/a");
 340:	00001517          	auipc	a0,0x1
 344:	b4050513          	addi	a0,a0,-1216 # e80 <malloc+0xec>
 348:	00000097          	auipc	ra,0x0
 34c:	662080e7          	jalr	1634(ra) # 9aa <unlink>
  if(open("/testsymlink/b", O_RDWR) >= 0)
 350:	4589                	li	a1,2
 352:	00001517          	auipc	a0,0x1
 356:	b3e50513          	addi	a0,a0,-1218 # e90 <malloc+0xfc>
 35a:	00000097          	auipc	ra,0x0
 35e:	640080e7          	jalr	1600(ra) # 99a <open>
 362:	12055263          	bgez	a0,486 <main+0x448>
  r = symlink("/testsymlink/b", "/testsymlink/a");
 366:	00001597          	auipc	a1,0x1
 36a:	b1a58593          	addi	a1,a1,-1254 # e80 <malloc+0xec>
 36e:	00001517          	auipc	a0,0x1
 372:	b2250513          	addi	a0,a0,-1246 # e90 <malloc+0xfc>
 376:	00000097          	auipc	ra,0x0
 37a:	684080e7          	jalr	1668(ra) # 9fa <symlink>
  if(r < 0)
 37e:	12054263          	bltz	a0,4a2 <main+0x464>
  r = open("/testsymlink/b", O_RDWR);
 382:	4589                	li	a1,2
 384:	00001517          	auipc	a0,0x1
 388:	b0c50513          	addi	a0,a0,-1268 # e90 <malloc+0xfc>
 38c:	00000097          	auipc	ra,0x0
 390:	60e080e7          	jalr	1550(ra) # 99a <open>
  if(r >= 0)
 394:	12055563          	bgez	a0,4be <main+0x480>
  r = symlink("/testsymlink/nonexistent", "/testsymlink/c");
 398:	00001597          	auipc	a1,0x1
 39c:	b0858593          	addi	a1,a1,-1272 # ea0 <malloc+0x10c>
 3a0:	00001517          	auipc	a0,0x1
 3a4:	d1850513          	addi	a0,a0,-744 # 10b8 <malloc+0x324>
 3a8:	00000097          	auipc	ra,0x0
 3ac:	652080e7          	jalr	1618(ra) # 9fa <symlink>
  if(r != 0)
 3b0:	12051563          	bnez	a0,4da <main+0x49c>
  r = symlink("/testsymlink/2", "/testsymlink/1");
 3b4:	00001597          	auipc	a1,0x1
 3b8:	afc58593          	addi	a1,a1,-1284 # eb0 <malloc+0x11c>
 3bc:	00001517          	auipc	a0,0x1
 3c0:	b0450513          	addi	a0,a0,-1276 # ec0 <malloc+0x12c>
 3c4:	00000097          	auipc	ra,0x0
 3c8:	636080e7          	jalr	1590(ra) # 9fa <symlink>
  if(r) fail("Failed to link 1->2");
 3cc:	12051563          	bnez	a0,4f6 <main+0x4b8>
  r = symlink("/testsymlink/3", "/testsymlink/2");
 3d0:	00001597          	auipc	a1,0x1
 3d4:	af058593          	addi	a1,a1,-1296 # ec0 <malloc+0x12c>
 3d8:	00001517          	auipc	a0,0x1
 3dc:	af850513          	addi	a0,a0,-1288 # ed0 <malloc+0x13c>
 3e0:	00000097          	auipc	ra,0x0
 3e4:	61a080e7          	jalr	1562(ra) # 9fa <symlink>
  if(r) fail("Failed to link 2->3");
 3e8:	12051563          	bnez	a0,512 <main+0x4d4>
  r = symlink("/testsymlink/4", "/testsymlink/3");
 3ec:	00001597          	auipc	a1,0x1
 3f0:	ae458593          	addi	a1,a1,-1308 # ed0 <malloc+0x13c>
 3f4:	00001517          	auipc	a0,0x1
 3f8:	aec50513          	addi	a0,a0,-1300 # ee0 <malloc+0x14c>
 3fc:	00000097          	auipc	ra,0x0
 400:	5fe080e7          	jalr	1534(ra) # 9fa <symlink>
  if(r) fail("Failed to link 3->4");
 404:	12051563          	bnez	a0,52e <main+0x4f0>
  close(fd1);
 408:	8526                	mv	a0,s1
 40a:	00000097          	auipc	ra,0x0
 40e:	578080e7          	jalr	1400(ra) # 982 <close>
  close(fd2);
 412:	854a                	mv	a0,s2
 414:	00000097          	auipc	ra,0x0
 418:	56e080e7          	jalr	1390(ra) # 982 <close>
  fd1 = open("/testsymlink/4", O_CREATE | O_RDWR);
 41c:	20200593          	li	a1,514
 420:	00001517          	auipc	a0,0x1
 424:	ac050513          	addi	a0,a0,-1344 # ee0 <malloc+0x14c>
 428:	00000097          	auipc	ra,0x0
 42c:	572080e7          	jalr	1394(ra) # 99a <open>
 430:	84aa                	mv	s1,a0
  if(fd1<0) fail("Failed to create 4\n");
 432:	10054c63          	bltz	a0,54a <main+0x50c>
  fd2 = open("/testsymlink/1", O_RDWR);
 436:	4589                	li	a1,2
 438:	00001517          	auipc	a0,0x1
 43c:	a7850513          	addi	a0,a0,-1416 # eb0 <malloc+0x11c>
 440:	00000097          	auipc	ra,0x0
 444:	55a080e7          	jalr	1370(ra) # 99a <open>
 448:	892a                	mv	s2,a0
  if(fd2<0) fail("Failed to open 1\n");
 44a:	10054e63          	bltz	a0,566 <main+0x528>
  c = '#';
 44e:	02300793          	li	a5,35
 452:	f8f40723          	sb	a5,-114(s0)
  r = write(fd2, &c, 1);
 456:	4605                	li	a2,1
 458:	f8e40593          	addi	a1,s0,-114
 45c:	00000097          	auipc	ra,0x0
 460:	51e080e7          	jalr	1310(ra) # 97a <write>
  if(r!=1) fail("Failed to write to 1\n");
 464:	4785                	li	a5,1
 466:	10f50e63          	beq	a0,a5,582 <main+0x544>
 46a:	00001517          	auipc	a0,0x1
 46e:	d4e50513          	addi	a0,a0,-690 # 11b8 <malloc+0x424>
 472:	00001097          	auipc	ra,0x1
 476:	86a080e7          	jalr	-1942(ra) # cdc <printf>
 47a:	4785                	li	a5,1
 47c:	00002717          	auipc	a4,0x2
 480:	b8f72223          	sw	a5,-1148(a4) # 2000 <failed>
 484:	b339                	j	192 <main+0x154>
    fail("Should not be able to open b after deleting a");
 486:	00001517          	auipc	a0,0x1
 48a:	b9a50513          	addi	a0,a0,-1126 # 1020 <malloc+0x28c>
 48e:	00001097          	auipc	ra,0x1
 492:	84e080e7          	jalr	-1970(ra) # cdc <printf>
 496:	4785                	li	a5,1
 498:	00002717          	auipc	a4,0x2
 49c:	b6f72423          	sw	a5,-1176(a4) # 2000 <failed>
 4a0:	b9cd                	j	192 <main+0x154>
    fail("symlink a -> b failed");
 4a2:	00001517          	auipc	a0,0x1
 4a6:	bb650513          	addi	a0,a0,-1098 # 1058 <malloc+0x2c4>
 4aa:	00001097          	auipc	ra,0x1
 4ae:	832080e7          	jalr	-1998(ra) # cdc <printf>
 4b2:	4785                	li	a5,1
 4b4:	00002717          	auipc	a4,0x2
 4b8:	b4f72623          	sw	a5,-1204(a4) # 2000 <failed>
 4bc:	b9d9                	j	192 <main+0x154>
    fail("Should not be able to open b (cycle b->a->b->..)\n");
 4be:	00001517          	auipc	a0,0x1
 4c2:	bba50513          	addi	a0,a0,-1094 # 1078 <malloc+0x2e4>
 4c6:	00001097          	auipc	ra,0x1
 4ca:	816080e7          	jalr	-2026(ra) # cdc <printf>
 4ce:	4785                	li	a5,1
 4d0:	00002717          	auipc	a4,0x2
 4d4:	b2f72823          	sw	a5,-1232(a4) # 2000 <failed>
 4d8:	b96d                	j	192 <main+0x154>
    fail("Symlinking to nonexistent file should succeed\n");
 4da:	00001517          	auipc	a0,0x1
 4de:	bfe50513          	addi	a0,a0,-1026 # 10d8 <malloc+0x344>
 4e2:	00000097          	auipc	ra,0x0
 4e6:	7fa080e7          	jalr	2042(ra) # cdc <printf>
 4ea:	4785                	li	a5,1
 4ec:	00002717          	auipc	a4,0x2
 4f0:	b0f72a23          	sw	a5,-1260(a4) # 2000 <failed>
 4f4:	b979                	j	192 <main+0x154>
  if(r) fail("Failed to link 1->2");
 4f6:	00001517          	auipc	a0,0x1
 4fa:	c2250513          	addi	a0,a0,-990 # 1118 <malloc+0x384>
 4fe:	00000097          	auipc	ra,0x0
 502:	7de080e7          	jalr	2014(ra) # cdc <printf>
 506:	4785                	li	a5,1
 508:	00002717          	auipc	a4,0x2
 50c:	aef72c23          	sw	a5,-1288(a4) # 2000 <failed>
 510:	b149                	j	192 <main+0x154>
  if(r) fail("Failed to link 2->3");
 512:	00001517          	auipc	a0,0x1
 516:	c2650513          	addi	a0,a0,-986 # 1138 <malloc+0x3a4>
 51a:	00000097          	auipc	ra,0x0
 51e:	7c2080e7          	jalr	1986(ra) # cdc <printf>
 522:	4785                	li	a5,1
 524:	00002717          	auipc	a4,0x2
 528:	acf72e23          	sw	a5,-1316(a4) # 2000 <failed>
 52c:	b19d                	j	192 <main+0x154>
  if(r) fail("Failed to link 3->4");
 52e:	00001517          	auipc	a0,0x1
 532:	c2a50513          	addi	a0,a0,-982 # 1158 <malloc+0x3c4>
 536:	00000097          	auipc	ra,0x0
 53a:	7a6080e7          	jalr	1958(ra) # cdc <printf>
 53e:	4785                	li	a5,1
 540:	00002717          	auipc	a4,0x2
 544:	acf72023          	sw	a5,-1344(a4) # 2000 <failed>
 548:	b1a9                	j	192 <main+0x154>
  if(fd1<0) fail("Failed to create 4\n");
 54a:	00001517          	auipc	a0,0x1
 54e:	c2e50513          	addi	a0,a0,-978 # 1178 <malloc+0x3e4>
 552:	00000097          	auipc	ra,0x0
 556:	78a080e7          	jalr	1930(ra) # cdc <printf>
 55a:	4785                	li	a5,1
 55c:	00002717          	auipc	a4,0x2
 560:	aaf72223          	sw	a5,-1372(a4) # 2000 <failed>
 564:	b13d                	j	192 <main+0x154>
  if(fd2<0) fail("Failed to open 1\n");
 566:	00001517          	auipc	a0,0x1
 56a:	c3250513          	addi	a0,a0,-974 # 1198 <malloc+0x404>
 56e:	00000097          	auipc	ra,0x0
 572:	76e080e7          	jalr	1902(ra) # cdc <printf>
 576:	4785                	li	a5,1
 578:	00002717          	auipc	a4,0x2
 57c:	a8f72423          	sw	a5,-1400(a4) # 2000 <failed>
 580:	b909                	j	192 <main+0x154>
  r = read(fd1, &c2, 1);
 582:	4605                	li	a2,1
 584:	f8f40593          	addi	a1,s0,-113
 588:	8526                	mv	a0,s1
 58a:	00000097          	auipc	ra,0x0
 58e:	3e8080e7          	jalr	1000(ra) # 972 <read>
  if(r!=1) fail("Failed to read from 4\n");
 592:	4785                	li	a5,1
 594:	02f51663          	bne	a0,a5,5c0 <main+0x582>
  if(c!=c2)
 598:	f8e44703          	lbu	a4,-114(s0)
 59c:	f8f44783          	lbu	a5,-113(s0)
 5a0:	02f70e63          	beq	a4,a5,5dc <main+0x59e>
    fail("Value read from 4 differed from value written to 1\n");
 5a4:	00001517          	auipc	a0,0x1
 5a8:	c5c50513          	addi	a0,a0,-932 # 1200 <malloc+0x46c>
 5ac:	00000097          	auipc	ra,0x0
 5b0:	730080e7          	jalr	1840(ra) # cdc <printf>
 5b4:	4785                	li	a5,1
 5b6:	00002717          	auipc	a4,0x2
 5ba:	a4f72523          	sw	a5,-1462(a4) # 2000 <failed>
 5be:	bed1                	j	192 <main+0x154>
  if(r!=1) fail("Failed to read from 4\n");
 5c0:	00001517          	auipc	a0,0x1
 5c4:	c1850513          	addi	a0,a0,-1000 # 11d8 <malloc+0x444>
 5c8:	00000097          	auipc	ra,0x0
 5cc:	714080e7          	jalr	1812(ra) # cdc <printf>
 5d0:	4785                	li	a5,1
 5d2:	00002717          	auipc	a4,0x2
 5d6:	a2f72723          	sw	a5,-1490(a4) # 2000 <failed>
 5da:	be65                	j	192 <main+0x154>
  printf("test symlinks: ok\n");
 5dc:	00001517          	auipc	a0,0x1
 5e0:	c6450513          	addi	a0,a0,-924 # 1240 <malloc+0x4ac>
 5e4:	00000097          	auipc	ra,0x0
 5e8:	6f8080e7          	jalr	1784(ra) # cdc <printf>
 5ec:	b65d                	j	192 <main+0x154>
    printf("FAILED: open failed");
 5ee:	00001517          	auipc	a0,0x1
 5f2:	c9250513          	addi	a0,a0,-878 # 1280 <malloc+0x4ec>
 5f6:	00000097          	auipc	ra,0x0
 5fa:	6e6080e7          	jalr	1766(ra) # cdc <printf>
    exit(1);
 5fe:	4505                	li	a0,1
 600:	00000097          	auipc	ra,0x0
 604:	35a080e7          	jalr	858(ra) # 95a <exit>
      printf("FAILED: fork failed\n");
 608:	00001517          	auipc	a0,0x1
 60c:	c9050513          	addi	a0,a0,-880 # 1298 <malloc+0x504>
 610:	00000097          	auipc	ra,0x0
 614:	6cc080e7          	jalr	1740(ra) # cdc <printf>
      exit(1);
 618:	4505                	li	a0,1
 61a:	00000097          	auipc	ra,0x0
 61e:	340080e7          	jalr	832(ra) # 95a <exit>
  int r, fd1 = -1, fd2 = -1;
 622:	06400493          	li	s1,100
      unsigned int x = (pid ? 1 : 97);
 626:	06100913          	li	s2,97
        x = x * 1103515245 + 12345;
 62a:	41c65ab7          	lui	s5,0x41c65
 62e:	e6da8a9b          	addiw	s5,s5,-403 # 41c64e6d <base+0x41c62e5d>
 632:	6a0d                	lui	s4,0x3
 634:	039a0a1b          	addiw	s4,s4,57 # 3039 <base+0x1029>
        if((x % 3) == 0) {
 638:	4b0d                	li	s6,3
          unlink("/testsymlink/y");
 63a:	00001997          	auipc	s3,0x1
 63e:	8c698993          	addi	s3,s3,-1850 # f00 <malloc+0x16c>
          symlink("/testsymlink/z", "/testsymlink/y");
 642:	00001b97          	auipc	s7,0x1
 646:	8aeb8b93          	addi	s7,s7,-1874 # ef0 <malloc+0x15c>
            if(st.type != T_SYMLINK) {
 64a:	4c11                	li	s8,4
 64c:	a801                	j	65c <main+0x61e>
          unlink("/testsymlink/y");
 64e:	854e                	mv	a0,s3
 650:	00000097          	auipc	ra,0x0
 654:	35a080e7          	jalr	858(ra) # 9aa <unlink>
      for(i = 0; i < 100; i++){
 658:	34fd                	addiw	s1,s1,-1
 65a:	c8b9                	beqz	s1,6b0 <main+0x672>
        x = x * 1103515245 + 12345;
 65c:	035907bb          	mulw	a5,s2,s5
 660:	014787bb          	addw	a5,a5,s4
 664:	0007891b          	sext.w	s2,a5
        if((x % 3) == 0) {
 668:	0367f7bb          	remuw	a5,a5,s6
 66c:	f3ed                	bnez	a5,64e <main+0x610>
          symlink("/testsymlink/z", "/testsymlink/y");
 66e:	85ce                	mv	a1,s3
 670:	855e                	mv	a0,s7
 672:	00000097          	auipc	ra,0x0
 676:	388080e7          	jalr	904(ra) # 9fa <symlink>
          if (stat_slink("/testsymlink/y", &st) == 0) {
 67a:	f9840593          	addi	a1,s0,-104
 67e:	854e                	mv	a0,s3
 680:	00000097          	auipc	ra,0x0
 684:	980080e7          	jalr	-1664(ra) # 0 <stat_slink>
 688:	f961                	bnez	a0,658 <main+0x61a>
            if(st.type != T_SYMLINK) {
 68a:	fa041583          	lh	a1,-96(s0)
 68e:	0005879b          	sext.w	a5,a1
 692:	fd8783e3          	beq	a5,s8,658 <main+0x61a>
              printf("FAILED: not a symbolic link\n", st.type);
 696:	00001517          	auipc	a0,0x1
 69a:	c1a50513          	addi	a0,a0,-998 # 12b0 <malloc+0x51c>
 69e:	00000097          	auipc	ra,0x0
 6a2:	63e080e7          	jalr	1598(ra) # cdc <printf>
              exit(1);
 6a6:	4505                	li	a0,1
 6a8:	00000097          	auipc	ra,0x0
 6ac:	2b2080e7          	jalr	690(ra) # 95a <exit>
      exit(0);
 6b0:	4501                	li	a0,0
 6b2:	00000097          	auipc	ra,0x0
 6b6:	2a8080e7          	jalr	680(ra) # 95a <exit>
      printf("test concurrent symlinks: failed\n");
 6ba:	00001517          	auipc	a0,0x1
 6be:	c1650513          	addi	a0,a0,-1002 # 12d0 <malloc+0x53c>
 6c2:	00000097          	auipc	ra,0x0
 6c6:	61a080e7          	jalr	1562(ra) # cdc <printf>
      exit(1);
 6ca:	4505                	li	a0,1
 6cc:	00000097          	auipc	ra,0x0
 6d0:	28e080e7          	jalr	654(ra) # 95a <exit>

00000000000006d4 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 6d4:	1141                	addi	sp,sp,-16
 6d6:	e406                	sd	ra,8(sp)
 6d8:	e022                	sd	s0,0(sp)
 6da:	0800                	addi	s0,sp,16
  extern int main();
  main();
 6dc:	00000097          	auipc	ra,0x0
 6e0:	962080e7          	jalr	-1694(ra) # 3e <main>
  exit(0);
 6e4:	4501                	li	a0,0
 6e6:	00000097          	auipc	ra,0x0
 6ea:	274080e7          	jalr	628(ra) # 95a <exit>

00000000000006ee <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 6ee:	1141                	addi	sp,sp,-16
 6f0:	e422                	sd	s0,8(sp)
 6f2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 6f4:	87aa                	mv	a5,a0
 6f6:	0585                	addi	a1,a1,1
 6f8:	0785                	addi	a5,a5,1
 6fa:	fff5c703          	lbu	a4,-1(a1)
 6fe:	fee78fa3          	sb	a4,-1(a5)
 702:	fb75                	bnez	a4,6f6 <strcpy+0x8>
    ;
  return os;
}
 704:	6422                	ld	s0,8(sp)
 706:	0141                	addi	sp,sp,16
 708:	8082                	ret

000000000000070a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 70a:	1141                	addi	sp,sp,-16
 70c:	e422                	sd	s0,8(sp)
 70e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 710:	00054783          	lbu	a5,0(a0)
 714:	cb91                	beqz	a5,728 <strcmp+0x1e>
 716:	0005c703          	lbu	a4,0(a1)
 71a:	00f71763          	bne	a4,a5,728 <strcmp+0x1e>
    p++, q++;
 71e:	0505                	addi	a0,a0,1
 720:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 722:	00054783          	lbu	a5,0(a0)
 726:	fbe5                	bnez	a5,716 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 728:	0005c503          	lbu	a0,0(a1)
}
 72c:	40a7853b          	subw	a0,a5,a0
 730:	6422                	ld	s0,8(sp)
 732:	0141                	addi	sp,sp,16
 734:	8082                	ret

0000000000000736 <strlen>:

uint
strlen(const char *s)
{
 736:	1141                	addi	sp,sp,-16
 738:	e422                	sd	s0,8(sp)
 73a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 73c:	00054783          	lbu	a5,0(a0)
 740:	cf91                	beqz	a5,75c <strlen+0x26>
 742:	0505                	addi	a0,a0,1
 744:	87aa                	mv	a5,a0
 746:	4685                	li	a3,1
 748:	9e89                	subw	a3,a3,a0
 74a:	00f6853b          	addw	a0,a3,a5
 74e:	0785                	addi	a5,a5,1
 750:	fff7c703          	lbu	a4,-1(a5)
 754:	fb7d                	bnez	a4,74a <strlen+0x14>
    ;
  return n;
}
 756:	6422                	ld	s0,8(sp)
 758:	0141                	addi	sp,sp,16
 75a:	8082                	ret
  for(n = 0; s[n]; n++)
 75c:	4501                	li	a0,0
 75e:	bfe5                	j	756 <strlen+0x20>

0000000000000760 <memset>:

void*
memset(void *dst, int c, uint n)
{
 760:	1141                	addi	sp,sp,-16
 762:	e422                	sd	s0,8(sp)
 764:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 766:	ca19                	beqz	a2,77c <memset+0x1c>
 768:	87aa                	mv	a5,a0
 76a:	1602                	slli	a2,a2,0x20
 76c:	9201                	srli	a2,a2,0x20
 76e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 772:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 776:	0785                	addi	a5,a5,1
 778:	fee79de3          	bne	a5,a4,772 <memset+0x12>
  }
  return dst;
}
 77c:	6422                	ld	s0,8(sp)
 77e:	0141                	addi	sp,sp,16
 780:	8082                	ret

0000000000000782 <strchr>:

char*
strchr(const char *s, char c)
{
 782:	1141                	addi	sp,sp,-16
 784:	e422                	sd	s0,8(sp)
 786:	0800                	addi	s0,sp,16
  for(; *s; s++)
 788:	00054783          	lbu	a5,0(a0)
 78c:	cb99                	beqz	a5,7a2 <strchr+0x20>
    if(*s == c)
 78e:	00f58763          	beq	a1,a5,79c <strchr+0x1a>
  for(; *s; s++)
 792:	0505                	addi	a0,a0,1
 794:	00054783          	lbu	a5,0(a0)
 798:	fbfd                	bnez	a5,78e <strchr+0xc>
      return (char*)s;
  return 0;
 79a:	4501                	li	a0,0
}
 79c:	6422                	ld	s0,8(sp)
 79e:	0141                	addi	sp,sp,16
 7a0:	8082                	ret
  return 0;
 7a2:	4501                	li	a0,0
 7a4:	bfe5                	j	79c <strchr+0x1a>

00000000000007a6 <gets>:

char*
gets(char *buf, int max)
{
 7a6:	711d                	addi	sp,sp,-96
 7a8:	ec86                	sd	ra,88(sp)
 7aa:	e8a2                	sd	s0,80(sp)
 7ac:	e4a6                	sd	s1,72(sp)
 7ae:	e0ca                	sd	s2,64(sp)
 7b0:	fc4e                	sd	s3,56(sp)
 7b2:	f852                	sd	s4,48(sp)
 7b4:	f456                	sd	s5,40(sp)
 7b6:	f05a                	sd	s6,32(sp)
 7b8:	ec5e                	sd	s7,24(sp)
 7ba:	1080                	addi	s0,sp,96
 7bc:	8baa                	mv	s7,a0
 7be:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7c0:	892a                	mv	s2,a0
 7c2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 7c4:	4aa9                	li	s5,10
 7c6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 7c8:	89a6                	mv	s3,s1
 7ca:	2485                	addiw	s1,s1,1
 7cc:	0344d863          	bge	s1,s4,7fc <gets+0x56>
    cc = read(0, &c, 1);
 7d0:	4605                	li	a2,1
 7d2:	faf40593          	addi	a1,s0,-81
 7d6:	4501                	li	a0,0
 7d8:	00000097          	auipc	ra,0x0
 7dc:	19a080e7          	jalr	410(ra) # 972 <read>
    if(cc < 1)
 7e0:	00a05e63          	blez	a0,7fc <gets+0x56>
    buf[i++] = c;
 7e4:	faf44783          	lbu	a5,-81(s0)
 7e8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 7ec:	01578763          	beq	a5,s5,7fa <gets+0x54>
 7f0:	0905                	addi	s2,s2,1
 7f2:	fd679be3          	bne	a5,s6,7c8 <gets+0x22>
  for(i=0; i+1 < max; ){
 7f6:	89a6                	mv	s3,s1
 7f8:	a011                	j	7fc <gets+0x56>
 7fa:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 7fc:	99de                	add	s3,s3,s7
 7fe:	00098023          	sb	zero,0(s3)
  return buf;
}
 802:	855e                	mv	a0,s7
 804:	60e6                	ld	ra,88(sp)
 806:	6446                	ld	s0,80(sp)
 808:	64a6                	ld	s1,72(sp)
 80a:	6906                	ld	s2,64(sp)
 80c:	79e2                	ld	s3,56(sp)
 80e:	7a42                	ld	s4,48(sp)
 810:	7aa2                	ld	s5,40(sp)
 812:	7b02                	ld	s6,32(sp)
 814:	6be2                	ld	s7,24(sp)
 816:	6125                	addi	sp,sp,96
 818:	8082                	ret

000000000000081a <stat>:

int
stat(const char *n, struct stat *st)
{
 81a:	1101                	addi	sp,sp,-32
 81c:	ec06                	sd	ra,24(sp)
 81e:	e822                	sd	s0,16(sp)
 820:	e426                	sd	s1,8(sp)
 822:	e04a                	sd	s2,0(sp)
 824:	1000                	addi	s0,sp,32
 826:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 828:	4581                	li	a1,0
 82a:	00000097          	auipc	ra,0x0
 82e:	170080e7          	jalr	368(ra) # 99a <open>
  if(fd < 0)
 832:	02054563          	bltz	a0,85c <stat+0x42>
 836:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 838:	85ca                	mv	a1,s2
 83a:	00000097          	auipc	ra,0x0
 83e:	178080e7          	jalr	376(ra) # 9b2 <fstat>
 842:	892a                	mv	s2,a0
  close(fd);
 844:	8526                	mv	a0,s1
 846:	00000097          	auipc	ra,0x0
 84a:	13c080e7          	jalr	316(ra) # 982 <close>
  return r;
}
 84e:	854a                	mv	a0,s2
 850:	60e2                	ld	ra,24(sp)
 852:	6442                	ld	s0,16(sp)
 854:	64a2                	ld	s1,8(sp)
 856:	6902                	ld	s2,0(sp)
 858:	6105                	addi	sp,sp,32
 85a:	8082                	ret
    return -1;
 85c:	597d                	li	s2,-1
 85e:	bfc5                	j	84e <stat+0x34>

0000000000000860 <atoi>:

int
atoi(const char *s)
{
 860:	1141                	addi	sp,sp,-16
 862:	e422                	sd	s0,8(sp)
 864:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 866:	00054683          	lbu	a3,0(a0)
 86a:	fd06879b          	addiw	a5,a3,-48
 86e:	0ff7f793          	zext.b	a5,a5
 872:	4625                	li	a2,9
 874:	02f66863          	bltu	a2,a5,8a4 <atoi+0x44>
 878:	872a                	mv	a4,a0
  n = 0;
 87a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 87c:	0705                	addi	a4,a4,1
 87e:	0025179b          	slliw	a5,a0,0x2
 882:	9fa9                	addw	a5,a5,a0
 884:	0017979b          	slliw	a5,a5,0x1
 888:	9fb5                	addw	a5,a5,a3
 88a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 88e:	00074683          	lbu	a3,0(a4)
 892:	fd06879b          	addiw	a5,a3,-48
 896:	0ff7f793          	zext.b	a5,a5
 89a:	fef671e3          	bgeu	a2,a5,87c <atoi+0x1c>
  return n;
}
 89e:	6422                	ld	s0,8(sp)
 8a0:	0141                	addi	sp,sp,16
 8a2:	8082                	ret
  n = 0;
 8a4:	4501                	li	a0,0
 8a6:	bfe5                	j	89e <atoi+0x3e>

00000000000008a8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 8a8:	1141                	addi	sp,sp,-16
 8aa:	e422                	sd	s0,8(sp)
 8ac:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 8ae:	02b57463          	bgeu	a0,a1,8d6 <memmove+0x2e>
    while(n-- > 0)
 8b2:	00c05f63          	blez	a2,8d0 <memmove+0x28>
 8b6:	1602                	slli	a2,a2,0x20
 8b8:	9201                	srli	a2,a2,0x20
 8ba:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 8be:	872a                	mv	a4,a0
      *dst++ = *src++;
 8c0:	0585                	addi	a1,a1,1
 8c2:	0705                	addi	a4,a4,1
 8c4:	fff5c683          	lbu	a3,-1(a1)
 8c8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 8cc:	fee79ae3          	bne	a5,a4,8c0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 8d0:	6422                	ld	s0,8(sp)
 8d2:	0141                	addi	sp,sp,16
 8d4:	8082                	ret
    dst += n;
 8d6:	00c50733          	add	a4,a0,a2
    src += n;
 8da:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 8dc:	fec05ae3          	blez	a2,8d0 <memmove+0x28>
 8e0:	fff6079b          	addiw	a5,a2,-1
 8e4:	1782                	slli	a5,a5,0x20
 8e6:	9381                	srli	a5,a5,0x20
 8e8:	fff7c793          	not	a5,a5
 8ec:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 8ee:	15fd                	addi	a1,a1,-1
 8f0:	177d                	addi	a4,a4,-1
 8f2:	0005c683          	lbu	a3,0(a1)
 8f6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 8fa:	fee79ae3          	bne	a5,a4,8ee <memmove+0x46>
 8fe:	bfc9                	j	8d0 <memmove+0x28>

0000000000000900 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 900:	1141                	addi	sp,sp,-16
 902:	e422                	sd	s0,8(sp)
 904:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 906:	ca05                	beqz	a2,936 <memcmp+0x36>
 908:	fff6069b          	addiw	a3,a2,-1
 90c:	1682                	slli	a3,a3,0x20
 90e:	9281                	srli	a3,a3,0x20
 910:	0685                	addi	a3,a3,1
 912:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 914:	00054783          	lbu	a5,0(a0)
 918:	0005c703          	lbu	a4,0(a1)
 91c:	00e79863          	bne	a5,a4,92c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 920:	0505                	addi	a0,a0,1
    p2++;
 922:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 924:	fed518e3          	bne	a0,a3,914 <memcmp+0x14>
  }
  return 0;
 928:	4501                	li	a0,0
 92a:	a019                	j	930 <memcmp+0x30>
      return *p1 - *p2;
 92c:	40e7853b          	subw	a0,a5,a4
}
 930:	6422                	ld	s0,8(sp)
 932:	0141                	addi	sp,sp,16
 934:	8082                	ret
  return 0;
 936:	4501                	li	a0,0
 938:	bfe5                	j	930 <memcmp+0x30>

000000000000093a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 93a:	1141                	addi	sp,sp,-16
 93c:	e406                	sd	ra,8(sp)
 93e:	e022                	sd	s0,0(sp)
 940:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 942:	00000097          	auipc	ra,0x0
 946:	f66080e7          	jalr	-154(ra) # 8a8 <memmove>
}
 94a:	60a2                	ld	ra,8(sp)
 94c:	6402                	ld	s0,0(sp)
 94e:	0141                	addi	sp,sp,16
 950:	8082                	ret

0000000000000952 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 952:	4885                	li	a7,1
 ecall
 954:	00000073          	ecall
 ret
 958:	8082                	ret

000000000000095a <exit>:
.global exit
exit:
 li a7, SYS_exit
 95a:	4889                	li	a7,2
 ecall
 95c:	00000073          	ecall
 ret
 960:	8082                	ret

0000000000000962 <wait>:
.global wait
wait:
 li a7, SYS_wait
 962:	488d                	li	a7,3
 ecall
 964:	00000073          	ecall
 ret
 968:	8082                	ret

000000000000096a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 96a:	4891                	li	a7,4
 ecall
 96c:	00000073          	ecall
 ret
 970:	8082                	ret

0000000000000972 <read>:
.global read
read:
 li a7, SYS_read
 972:	4895                	li	a7,5
 ecall
 974:	00000073          	ecall
 ret
 978:	8082                	ret

000000000000097a <write>:
.global write
write:
 li a7, SYS_write
 97a:	48c1                	li	a7,16
 ecall
 97c:	00000073          	ecall
 ret
 980:	8082                	ret

0000000000000982 <close>:
.global close
close:
 li a7, SYS_close
 982:	48d5                	li	a7,21
 ecall
 984:	00000073          	ecall
 ret
 988:	8082                	ret

000000000000098a <kill>:
.global kill
kill:
 li a7, SYS_kill
 98a:	4899                	li	a7,6
 ecall
 98c:	00000073          	ecall
 ret
 990:	8082                	ret

0000000000000992 <exec>:
.global exec
exec:
 li a7, SYS_exec
 992:	489d                	li	a7,7
 ecall
 994:	00000073          	ecall
 ret
 998:	8082                	ret

000000000000099a <open>:
.global open
open:
 li a7, SYS_open
 99a:	48bd                	li	a7,15
 ecall
 99c:	00000073          	ecall
 ret
 9a0:	8082                	ret

00000000000009a2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 9a2:	48c5                	li	a7,17
 ecall
 9a4:	00000073          	ecall
 ret
 9a8:	8082                	ret

00000000000009aa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 9aa:	48c9                	li	a7,18
 ecall
 9ac:	00000073          	ecall
 ret
 9b0:	8082                	ret

00000000000009b2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 9b2:	48a1                	li	a7,8
 ecall
 9b4:	00000073          	ecall
 ret
 9b8:	8082                	ret

00000000000009ba <link>:
.global link
link:
 li a7, SYS_link
 9ba:	48cd                	li	a7,19
 ecall
 9bc:	00000073          	ecall
 ret
 9c0:	8082                	ret

00000000000009c2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 9c2:	48d1                	li	a7,20
 ecall
 9c4:	00000073          	ecall
 ret
 9c8:	8082                	ret

00000000000009ca <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 9ca:	48a5                	li	a7,9
 ecall
 9cc:	00000073          	ecall
 ret
 9d0:	8082                	ret

00000000000009d2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 9d2:	48a9                	li	a7,10
 ecall
 9d4:	00000073          	ecall
 ret
 9d8:	8082                	ret

00000000000009da <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 9da:	48ad                	li	a7,11
 ecall
 9dc:	00000073          	ecall
 ret
 9e0:	8082                	ret

00000000000009e2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 9e2:	48b1                	li	a7,12
 ecall
 9e4:	00000073          	ecall
 ret
 9e8:	8082                	ret

00000000000009ea <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 9ea:	48b5                	li	a7,13
 ecall
 9ec:	00000073          	ecall
 ret
 9f0:	8082                	ret

00000000000009f2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 9f2:	48b9                	li	a7,14
 ecall
 9f4:	00000073          	ecall
 ret
 9f8:	8082                	ret

00000000000009fa <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 9fa:	48d9                	li	a7,22
 ecall
 9fc:	00000073          	ecall
 ret
 a00:	8082                	ret

0000000000000a02 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 a02:	1101                	addi	sp,sp,-32
 a04:	ec06                	sd	ra,24(sp)
 a06:	e822                	sd	s0,16(sp)
 a08:	1000                	addi	s0,sp,32
 a0a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 a0e:	4605                	li	a2,1
 a10:	fef40593          	addi	a1,s0,-17
 a14:	00000097          	auipc	ra,0x0
 a18:	f66080e7          	jalr	-154(ra) # 97a <write>
}
 a1c:	60e2                	ld	ra,24(sp)
 a1e:	6442                	ld	s0,16(sp)
 a20:	6105                	addi	sp,sp,32
 a22:	8082                	ret

0000000000000a24 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 a24:	7139                	addi	sp,sp,-64
 a26:	fc06                	sd	ra,56(sp)
 a28:	f822                	sd	s0,48(sp)
 a2a:	f426                	sd	s1,40(sp)
 a2c:	f04a                	sd	s2,32(sp)
 a2e:	ec4e                	sd	s3,24(sp)
 a30:	0080                	addi	s0,sp,64
 a32:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 a34:	c299                	beqz	a3,a3a <printint+0x16>
 a36:	0805c963          	bltz	a1,ac8 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 a3a:	2581                	sext.w	a1,a1
  neg = 0;
 a3c:	4881                	li	a7,0
 a3e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 a42:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 a44:	2601                	sext.w	a2,a2
 a46:	00001517          	auipc	a0,0x1
 a4a:	93250513          	addi	a0,a0,-1742 # 1378 <digits>
 a4e:	883a                	mv	a6,a4
 a50:	2705                	addiw	a4,a4,1
 a52:	02c5f7bb          	remuw	a5,a1,a2
 a56:	1782                	slli	a5,a5,0x20
 a58:	9381                	srli	a5,a5,0x20
 a5a:	97aa                	add	a5,a5,a0
 a5c:	0007c783          	lbu	a5,0(a5)
 a60:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 a64:	0005879b          	sext.w	a5,a1
 a68:	02c5d5bb          	divuw	a1,a1,a2
 a6c:	0685                	addi	a3,a3,1
 a6e:	fec7f0e3          	bgeu	a5,a2,a4e <printint+0x2a>
  if(neg)
 a72:	00088c63          	beqz	a7,a8a <printint+0x66>
    buf[i++] = '-';
 a76:	fd070793          	addi	a5,a4,-48
 a7a:	00878733          	add	a4,a5,s0
 a7e:	02d00793          	li	a5,45
 a82:	fef70823          	sb	a5,-16(a4)
 a86:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 a8a:	02e05863          	blez	a4,aba <printint+0x96>
 a8e:	fc040793          	addi	a5,s0,-64
 a92:	00e78933          	add	s2,a5,a4
 a96:	fff78993          	addi	s3,a5,-1
 a9a:	99ba                	add	s3,s3,a4
 a9c:	377d                	addiw	a4,a4,-1
 a9e:	1702                	slli	a4,a4,0x20
 aa0:	9301                	srli	a4,a4,0x20
 aa2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 aa6:	fff94583          	lbu	a1,-1(s2)
 aaa:	8526                	mv	a0,s1
 aac:	00000097          	auipc	ra,0x0
 ab0:	f56080e7          	jalr	-170(ra) # a02 <putc>
  while(--i >= 0)
 ab4:	197d                	addi	s2,s2,-1
 ab6:	ff3918e3          	bne	s2,s3,aa6 <printint+0x82>
}
 aba:	70e2                	ld	ra,56(sp)
 abc:	7442                	ld	s0,48(sp)
 abe:	74a2                	ld	s1,40(sp)
 ac0:	7902                	ld	s2,32(sp)
 ac2:	69e2                	ld	s3,24(sp)
 ac4:	6121                	addi	sp,sp,64
 ac6:	8082                	ret
    x = -xx;
 ac8:	40b005bb          	negw	a1,a1
    neg = 1;
 acc:	4885                	li	a7,1
    x = -xx;
 ace:	bf85                	j	a3e <printint+0x1a>

0000000000000ad0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 ad0:	7119                	addi	sp,sp,-128
 ad2:	fc86                	sd	ra,120(sp)
 ad4:	f8a2                	sd	s0,112(sp)
 ad6:	f4a6                	sd	s1,104(sp)
 ad8:	f0ca                	sd	s2,96(sp)
 ada:	ecce                	sd	s3,88(sp)
 adc:	e8d2                	sd	s4,80(sp)
 ade:	e4d6                	sd	s5,72(sp)
 ae0:	e0da                	sd	s6,64(sp)
 ae2:	fc5e                	sd	s7,56(sp)
 ae4:	f862                	sd	s8,48(sp)
 ae6:	f466                	sd	s9,40(sp)
 ae8:	f06a                	sd	s10,32(sp)
 aea:	ec6e                	sd	s11,24(sp)
 aec:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 aee:	0005c903          	lbu	s2,0(a1)
 af2:	18090f63          	beqz	s2,c90 <vprintf+0x1c0>
 af6:	8aaa                	mv	s5,a0
 af8:	8b32                	mv	s6,a2
 afa:	00158493          	addi	s1,a1,1
  state = 0;
 afe:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 b00:	02500a13          	li	s4,37
 b04:	4c55                	li	s8,21
 b06:	00001c97          	auipc	s9,0x1
 b0a:	81ac8c93          	addi	s9,s9,-2022 # 1320 <malloc+0x58c>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 b0e:	02800d93          	li	s11,40
  putc(fd, 'x');
 b12:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 b14:	00001b97          	auipc	s7,0x1
 b18:	864b8b93          	addi	s7,s7,-1948 # 1378 <digits>
 b1c:	a839                	j	b3a <vprintf+0x6a>
        putc(fd, c);
 b1e:	85ca                	mv	a1,s2
 b20:	8556                	mv	a0,s5
 b22:	00000097          	auipc	ra,0x0
 b26:	ee0080e7          	jalr	-288(ra) # a02 <putc>
 b2a:	a019                	j	b30 <vprintf+0x60>
    } else if(state == '%'){
 b2c:	01498d63          	beq	s3,s4,b46 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 b30:	0485                	addi	s1,s1,1
 b32:	fff4c903          	lbu	s2,-1(s1)
 b36:	14090d63          	beqz	s2,c90 <vprintf+0x1c0>
    if(state == 0){
 b3a:	fe0999e3          	bnez	s3,b2c <vprintf+0x5c>
      if(c == '%'){
 b3e:	ff4910e3          	bne	s2,s4,b1e <vprintf+0x4e>
        state = '%';
 b42:	89d2                	mv	s3,s4
 b44:	b7f5                	j	b30 <vprintf+0x60>
      if(c == 'd'){
 b46:	11490c63          	beq	s2,s4,c5e <vprintf+0x18e>
 b4a:	f9d9079b          	addiw	a5,s2,-99
 b4e:	0ff7f793          	zext.b	a5,a5
 b52:	10fc6e63          	bltu	s8,a5,c6e <vprintf+0x19e>
 b56:	f9d9079b          	addiw	a5,s2,-99
 b5a:	0ff7f713          	zext.b	a4,a5
 b5e:	10ec6863          	bltu	s8,a4,c6e <vprintf+0x19e>
 b62:	00271793          	slli	a5,a4,0x2
 b66:	97e6                	add	a5,a5,s9
 b68:	439c                	lw	a5,0(a5)
 b6a:	97e6                	add	a5,a5,s9
 b6c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 b6e:	008b0913          	addi	s2,s6,8
 b72:	4685                	li	a3,1
 b74:	4629                	li	a2,10
 b76:	000b2583          	lw	a1,0(s6)
 b7a:	8556                	mv	a0,s5
 b7c:	00000097          	auipc	ra,0x0
 b80:	ea8080e7          	jalr	-344(ra) # a24 <printint>
 b84:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 b86:	4981                	li	s3,0
 b88:	b765                	j	b30 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b8a:	008b0913          	addi	s2,s6,8
 b8e:	4681                	li	a3,0
 b90:	4629                	li	a2,10
 b92:	000b2583          	lw	a1,0(s6)
 b96:	8556                	mv	a0,s5
 b98:	00000097          	auipc	ra,0x0
 b9c:	e8c080e7          	jalr	-372(ra) # a24 <printint>
 ba0:	8b4a                	mv	s6,s2
      state = 0;
 ba2:	4981                	li	s3,0
 ba4:	b771                	j	b30 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 ba6:	008b0913          	addi	s2,s6,8
 baa:	4681                	li	a3,0
 bac:	866a                	mv	a2,s10
 bae:	000b2583          	lw	a1,0(s6)
 bb2:	8556                	mv	a0,s5
 bb4:	00000097          	auipc	ra,0x0
 bb8:	e70080e7          	jalr	-400(ra) # a24 <printint>
 bbc:	8b4a                	mv	s6,s2
      state = 0;
 bbe:	4981                	li	s3,0
 bc0:	bf85                	j	b30 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 bc2:	008b0793          	addi	a5,s6,8
 bc6:	f8f43423          	sd	a5,-120(s0)
 bca:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 bce:	03000593          	li	a1,48
 bd2:	8556                	mv	a0,s5
 bd4:	00000097          	auipc	ra,0x0
 bd8:	e2e080e7          	jalr	-466(ra) # a02 <putc>
  putc(fd, 'x');
 bdc:	07800593          	li	a1,120
 be0:	8556                	mv	a0,s5
 be2:	00000097          	auipc	ra,0x0
 be6:	e20080e7          	jalr	-480(ra) # a02 <putc>
 bea:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 bec:	03c9d793          	srli	a5,s3,0x3c
 bf0:	97de                	add	a5,a5,s7
 bf2:	0007c583          	lbu	a1,0(a5)
 bf6:	8556                	mv	a0,s5
 bf8:	00000097          	auipc	ra,0x0
 bfc:	e0a080e7          	jalr	-502(ra) # a02 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 c00:	0992                	slli	s3,s3,0x4
 c02:	397d                	addiw	s2,s2,-1
 c04:	fe0914e3          	bnez	s2,bec <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 c08:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 c0c:	4981                	li	s3,0
 c0e:	b70d                	j	b30 <vprintf+0x60>
        s = va_arg(ap, char*);
 c10:	008b0913          	addi	s2,s6,8
 c14:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 c18:	02098163          	beqz	s3,c3a <vprintf+0x16a>
        while(*s != 0){
 c1c:	0009c583          	lbu	a1,0(s3)
 c20:	c5ad                	beqz	a1,c8a <vprintf+0x1ba>
          putc(fd, *s);
 c22:	8556                	mv	a0,s5
 c24:	00000097          	auipc	ra,0x0
 c28:	dde080e7          	jalr	-546(ra) # a02 <putc>
          s++;
 c2c:	0985                	addi	s3,s3,1
        while(*s != 0){
 c2e:	0009c583          	lbu	a1,0(s3)
 c32:	f9e5                	bnez	a1,c22 <vprintf+0x152>
        s = va_arg(ap, char*);
 c34:	8b4a                	mv	s6,s2
      state = 0;
 c36:	4981                	li	s3,0
 c38:	bde5                	j	b30 <vprintf+0x60>
          s = "(null)";
 c3a:	00000997          	auipc	s3,0x0
 c3e:	6de98993          	addi	s3,s3,1758 # 1318 <malloc+0x584>
        while(*s != 0){
 c42:	85ee                	mv	a1,s11
 c44:	bff9                	j	c22 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 c46:	008b0913          	addi	s2,s6,8
 c4a:	000b4583          	lbu	a1,0(s6)
 c4e:	8556                	mv	a0,s5
 c50:	00000097          	auipc	ra,0x0
 c54:	db2080e7          	jalr	-590(ra) # a02 <putc>
 c58:	8b4a                	mv	s6,s2
      state = 0;
 c5a:	4981                	li	s3,0
 c5c:	bdd1                	j	b30 <vprintf+0x60>
        putc(fd, c);
 c5e:	85d2                	mv	a1,s4
 c60:	8556                	mv	a0,s5
 c62:	00000097          	auipc	ra,0x0
 c66:	da0080e7          	jalr	-608(ra) # a02 <putc>
      state = 0;
 c6a:	4981                	li	s3,0
 c6c:	b5d1                	j	b30 <vprintf+0x60>
        putc(fd, '%');
 c6e:	85d2                	mv	a1,s4
 c70:	8556                	mv	a0,s5
 c72:	00000097          	auipc	ra,0x0
 c76:	d90080e7          	jalr	-624(ra) # a02 <putc>
        putc(fd, c);
 c7a:	85ca                	mv	a1,s2
 c7c:	8556                	mv	a0,s5
 c7e:	00000097          	auipc	ra,0x0
 c82:	d84080e7          	jalr	-636(ra) # a02 <putc>
      state = 0;
 c86:	4981                	li	s3,0
 c88:	b565                	j	b30 <vprintf+0x60>
        s = va_arg(ap, char*);
 c8a:	8b4a                	mv	s6,s2
      state = 0;
 c8c:	4981                	li	s3,0
 c8e:	b54d                	j	b30 <vprintf+0x60>
    }
  }
}
 c90:	70e6                	ld	ra,120(sp)
 c92:	7446                	ld	s0,112(sp)
 c94:	74a6                	ld	s1,104(sp)
 c96:	7906                	ld	s2,96(sp)
 c98:	69e6                	ld	s3,88(sp)
 c9a:	6a46                	ld	s4,80(sp)
 c9c:	6aa6                	ld	s5,72(sp)
 c9e:	6b06                	ld	s6,64(sp)
 ca0:	7be2                	ld	s7,56(sp)
 ca2:	7c42                	ld	s8,48(sp)
 ca4:	7ca2                	ld	s9,40(sp)
 ca6:	7d02                	ld	s10,32(sp)
 ca8:	6de2                	ld	s11,24(sp)
 caa:	6109                	addi	sp,sp,128
 cac:	8082                	ret

0000000000000cae <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 cae:	715d                	addi	sp,sp,-80
 cb0:	ec06                	sd	ra,24(sp)
 cb2:	e822                	sd	s0,16(sp)
 cb4:	1000                	addi	s0,sp,32
 cb6:	e010                	sd	a2,0(s0)
 cb8:	e414                	sd	a3,8(s0)
 cba:	e818                	sd	a4,16(s0)
 cbc:	ec1c                	sd	a5,24(s0)
 cbe:	03043023          	sd	a6,32(s0)
 cc2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 cc6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 cca:	8622                	mv	a2,s0
 ccc:	00000097          	auipc	ra,0x0
 cd0:	e04080e7          	jalr	-508(ra) # ad0 <vprintf>
}
 cd4:	60e2                	ld	ra,24(sp)
 cd6:	6442                	ld	s0,16(sp)
 cd8:	6161                	addi	sp,sp,80
 cda:	8082                	ret

0000000000000cdc <printf>:

void
printf(const char *fmt, ...)
{
 cdc:	711d                	addi	sp,sp,-96
 cde:	ec06                	sd	ra,24(sp)
 ce0:	e822                	sd	s0,16(sp)
 ce2:	1000                	addi	s0,sp,32
 ce4:	e40c                	sd	a1,8(s0)
 ce6:	e810                	sd	a2,16(s0)
 ce8:	ec14                	sd	a3,24(s0)
 cea:	f018                	sd	a4,32(s0)
 cec:	f41c                	sd	a5,40(s0)
 cee:	03043823          	sd	a6,48(s0)
 cf2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 cf6:	00840613          	addi	a2,s0,8
 cfa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 cfe:	85aa                	mv	a1,a0
 d00:	4505                	li	a0,1
 d02:	00000097          	auipc	ra,0x0
 d06:	dce080e7          	jalr	-562(ra) # ad0 <vprintf>
}
 d0a:	60e2                	ld	ra,24(sp)
 d0c:	6442                	ld	s0,16(sp)
 d0e:	6125                	addi	sp,sp,96
 d10:	8082                	ret

0000000000000d12 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 d12:	1141                	addi	sp,sp,-16
 d14:	e422                	sd	s0,8(sp)
 d16:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 d18:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d1c:	00001797          	auipc	a5,0x1
 d20:	2ec7b783          	ld	a5,748(a5) # 2008 <freep>
 d24:	a02d                	j	d4e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 d26:	4618                	lw	a4,8(a2)
 d28:	9f2d                	addw	a4,a4,a1
 d2a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 d2e:	6398                	ld	a4,0(a5)
 d30:	6310                	ld	a2,0(a4)
 d32:	a83d                	j	d70 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 d34:	ff852703          	lw	a4,-8(a0)
 d38:	9f31                	addw	a4,a4,a2
 d3a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 d3c:	ff053683          	ld	a3,-16(a0)
 d40:	a091                	j	d84 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d42:	6398                	ld	a4,0(a5)
 d44:	00e7e463          	bltu	a5,a4,d4c <free+0x3a>
 d48:	00e6ea63          	bltu	a3,a4,d5c <free+0x4a>
{
 d4c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d4e:	fed7fae3          	bgeu	a5,a3,d42 <free+0x30>
 d52:	6398                	ld	a4,0(a5)
 d54:	00e6e463          	bltu	a3,a4,d5c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d58:	fee7eae3          	bltu	a5,a4,d4c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 d5c:	ff852583          	lw	a1,-8(a0)
 d60:	6390                	ld	a2,0(a5)
 d62:	02059813          	slli	a6,a1,0x20
 d66:	01c85713          	srli	a4,a6,0x1c
 d6a:	9736                	add	a4,a4,a3
 d6c:	fae60de3          	beq	a2,a4,d26 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 d70:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 d74:	4790                	lw	a2,8(a5)
 d76:	02061593          	slli	a1,a2,0x20
 d7a:	01c5d713          	srli	a4,a1,0x1c
 d7e:	973e                	add	a4,a4,a5
 d80:	fae68ae3          	beq	a3,a4,d34 <free+0x22>
    p->s.ptr = bp->s.ptr;
 d84:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 d86:	00001717          	auipc	a4,0x1
 d8a:	28f73123          	sd	a5,642(a4) # 2008 <freep>
}
 d8e:	6422                	ld	s0,8(sp)
 d90:	0141                	addi	sp,sp,16
 d92:	8082                	ret

0000000000000d94 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d94:	7139                	addi	sp,sp,-64
 d96:	fc06                	sd	ra,56(sp)
 d98:	f822                	sd	s0,48(sp)
 d9a:	f426                	sd	s1,40(sp)
 d9c:	f04a                	sd	s2,32(sp)
 d9e:	ec4e                	sd	s3,24(sp)
 da0:	e852                	sd	s4,16(sp)
 da2:	e456                	sd	s5,8(sp)
 da4:	e05a                	sd	s6,0(sp)
 da6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 da8:	02051493          	slli	s1,a0,0x20
 dac:	9081                	srli	s1,s1,0x20
 dae:	04bd                	addi	s1,s1,15
 db0:	8091                	srli	s1,s1,0x4
 db2:	0014899b          	addiw	s3,s1,1
 db6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 db8:	00001517          	auipc	a0,0x1
 dbc:	25053503          	ld	a0,592(a0) # 2008 <freep>
 dc0:	c515                	beqz	a0,dec <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dc2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 dc4:	4798                	lw	a4,8(a5)
 dc6:	02977f63          	bgeu	a4,s1,e04 <malloc+0x70>
 dca:	8a4e                	mv	s4,s3
 dcc:	0009871b          	sext.w	a4,s3
 dd0:	6685                	lui	a3,0x1
 dd2:	00d77363          	bgeu	a4,a3,dd8 <malloc+0x44>
 dd6:	6a05                	lui	s4,0x1
 dd8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ddc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 de0:	00001917          	auipc	s2,0x1
 de4:	22890913          	addi	s2,s2,552 # 2008 <freep>
  if(p == (char*)-1)
 de8:	5afd                	li	s5,-1
 dea:	a895                	j	e5e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 dec:	00001797          	auipc	a5,0x1
 df0:	22478793          	addi	a5,a5,548 # 2010 <base>
 df4:	00001717          	auipc	a4,0x1
 df8:	20f73a23          	sd	a5,532(a4) # 2008 <freep>
 dfc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 dfe:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 e02:	b7e1                	j	dca <malloc+0x36>
      if(p->s.size == nunits)
 e04:	02e48c63          	beq	s1,a4,e3c <malloc+0xa8>
        p->s.size -= nunits;
 e08:	4137073b          	subw	a4,a4,s3
 e0c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 e0e:	02071693          	slli	a3,a4,0x20
 e12:	01c6d713          	srli	a4,a3,0x1c
 e16:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 e18:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 e1c:	00001717          	auipc	a4,0x1
 e20:	1ea73623          	sd	a0,492(a4) # 2008 <freep>
      return (void*)(p + 1);
 e24:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 e28:	70e2                	ld	ra,56(sp)
 e2a:	7442                	ld	s0,48(sp)
 e2c:	74a2                	ld	s1,40(sp)
 e2e:	7902                	ld	s2,32(sp)
 e30:	69e2                	ld	s3,24(sp)
 e32:	6a42                	ld	s4,16(sp)
 e34:	6aa2                	ld	s5,8(sp)
 e36:	6b02                	ld	s6,0(sp)
 e38:	6121                	addi	sp,sp,64
 e3a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 e3c:	6398                	ld	a4,0(a5)
 e3e:	e118                	sd	a4,0(a0)
 e40:	bff1                	j	e1c <malloc+0x88>
  hp->s.size = nu;
 e42:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 e46:	0541                	addi	a0,a0,16
 e48:	00000097          	auipc	ra,0x0
 e4c:	eca080e7          	jalr	-310(ra) # d12 <free>
  return freep;
 e50:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 e54:	d971                	beqz	a0,e28 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e56:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 e58:	4798                	lw	a4,8(a5)
 e5a:	fa9775e3          	bgeu	a4,s1,e04 <malloc+0x70>
    if(p == freep)
 e5e:	00093703          	ld	a4,0(s2)
 e62:	853e                	mv	a0,a5
 e64:	fef719e3          	bne	a4,a5,e56 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 e68:	8552                	mv	a0,s4
 e6a:	00000097          	auipc	ra,0x0
 e6e:	b78080e7          	jalr	-1160(ra) # 9e2 <sbrk>
  if(p == (char*)-1)
 e72:	fd5518e3          	bne	a0,s5,e42 <malloc+0xae>
        return 0;
 e76:	4501                	li	a0,0
 e78:	bf45                	j	e28 <malloc+0x94>
