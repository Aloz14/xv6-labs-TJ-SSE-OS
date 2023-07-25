
user/_usertests：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
    }
}

// what if you pass ridiculous string pointers to system calls?
void copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
    uint64 addrs[] = {0x80000000LL, 0xffffffffffffffff};

    for (int ai = 0; ai < 2; ai++) {
        uint64 addr = addrs[ai];

        int fd = open((char *)addr, O_CREATE | O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	be2080e7          	jalr	-1054(ra) # 5bf2 <open>
        if (fd >= 0) {
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
        int fd = open((char *)addr, O_CREATE | O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	bd0080e7          	jalr	-1072(ra) # 5bf2 <open>
        uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
        if (fd >= 0) {
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
            printf("open(%p) returned %d, not -1\n", addr, fd);
            exit(1);
        }
    }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
        uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
            printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	09250513          	addi	a0,a0,146 # 60d0 <malloc+0xec>
      46:	00006097          	auipc	ra,0x6
      4a:	ee6080e7          	jalr	-282(ra) # 5f2c <printf>
            exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	b62080e7          	jalr	-1182(ra) # 5bb2 <exit>

0000000000000058 <bsstest>:
char uninit[10000];
void bsstest(char *s)
{
    int i;

    for (i = 0; i < sizeof(uninit); i++) {
      58:	0000a797          	auipc	a5,0xa
      5c:	51078793          	addi	a5,a5,1296 # a568 <uninit>
      60:	0000d697          	auipc	a3,0xd
      64:	c1868693          	addi	a3,a3,-1000 # cc78 <buf>
        if (uninit[i] != '\0') {
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
    for (i = 0; i < sizeof(uninit); i++) {
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
            printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	07050513          	addi	a0,a0,112 # 60f0 <malloc+0x10c>
      88:	00006097          	auipc	ra,0x6
      8c:	ea4080e7          	jalr	-348(ra) # 5f2c <printf>
            exit(1);
      90:	4505                	li	a0,1
      92:	00006097          	auipc	ra,0x6
      96:	b20080e7          	jalr	-1248(ra) # 5bb2 <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
    fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	06050513          	addi	a0,a0,96 # 6108 <malloc+0x124>
      b0:	00006097          	auipc	ra,0x6
      b4:	b42080e7          	jalr	-1214(ra) # 5bf2 <open>
    if (fd < 0) {
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
    close(fd);
      bc:	00006097          	auipc	ra,0x6
      c0:	b1e080e7          	jalr	-1250(ra) # 5bda <close>
    fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	06250513          	addi	a0,a0,98 # 6128 <malloc+0x144>
      ce:	00006097          	auipc	ra,0x6
      d2:	b24080e7          	jalr	-1244(ra) # 5bf2 <open>
    if (fd >= 0) {
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
        printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	02a50513          	addi	a0,a0,42 # 6110 <malloc+0x12c>
      ee:	00006097          	auipc	ra,0x6
      f2:	e3e080e7          	jalr	-450(ra) # 5f2c <printf>
        exit(1);
      f6:	4505                	li	a0,1
      f8:	00006097          	auipc	ra,0x6
      fc:	aba080e7          	jalr	-1350(ra) # 5bb2 <exit>
        printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	03650513          	addi	a0,a0,54 # 6138 <malloc+0x154>
     10a:	00006097          	auipc	ra,0x6
     10e:	e22080e7          	jalr	-478(ra) # 5f2c <printf>
        exit(1);
     112:	4505                	li	a0,1
     114:	00006097          	auipc	ra,0x6
     118:	a9e080e7          	jalr	-1378(ra) # 5bb2 <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
    unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	03450513          	addi	a0,a0,52 # 6160 <malloc+0x17c>
     134:	00006097          	auipc	ra,0x6
     138:	ace080e7          	jalr	-1330(ra) # 5c02 <unlink>
    int fd1 = open("truncfile", O_CREATE | O_TRUNC | O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	02050513          	addi	a0,a0,32 # 6160 <malloc+0x17c>
     148:	00006097          	auipc	ra,0x6
     14c:	aaa080e7          	jalr	-1366(ra) # 5bf2 <open>
     150:	84aa                	mv	s1,a0
    write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	01c58593          	addi	a1,a1,28 # 6170 <malloc+0x18c>
     15c:	00006097          	auipc	ra,0x6
     160:	a76080e7          	jalr	-1418(ra) # 5bd2 <write>
    int fd2 = open("truncfile", O_TRUNC | O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	ff850513          	addi	a0,a0,-8 # 6160 <malloc+0x17c>
     170:	00006097          	auipc	ra,0x6
     174:	a82080e7          	jalr	-1406(ra) # 5bf2 <open>
     178:	892a                	mv	s2,a0
    int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	ffc58593          	addi	a1,a1,-4 # 6178 <malloc+0x194>
     184:	8526                	mv	a0,s1
     186:	00006097          	auipc	ra,0x6
     18a:	a4c080e7          	jalr	-1460(ra) # 5bd2 <write>
    if (n != -1) {
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
    unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	fcc50513          	addi	a0,a0,-52 # 6160 <malloc+0x17c>
     19c:	00006097          	auipc	ra,0x6
     1a0:	a66080e7          	jalr	-1434(ra) # 5c02 <unlink>
    close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00006097          	auipc	ra,0x6
     1aa:	a34080e7          	jalr	-1484(ra) # 5bda <close>
    close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00006097          	auipc	ra,0x6
     1b4:	a2a080e7          	jalr	-1494(ra) # 5bda <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
        printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	fb650513          	addi	a0,a0,-74 # 6180 <malloc+0x19c>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	d5a080e7          	jalr	-678(ra) # 5f2c <printf>
        exit(1);
     1da:	4505                	li	a0,1
     1dc:	00006097          	auipc	ra,0x6
     1e0:	9d6080e7          	jalr	-1578(ra) # 5bb2 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
    name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
    name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
    for (i = 0; i < N; i++) {
     200:	06400913          	li	s2,100
        name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
        fd = open(name, O_CREATE | O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00006097          	auipc	ra,0x6
     214:	9e2080e7          	jalr	-1566(ra) # 5bf2 <open>
        close(fd);
     218:	00006097          	auipc	ra,0x6
     21c:	9c2080e7          	jalr	-1598(ra) # 5bda <close>
    for (i = 0; i < N; i++) {
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	zext.b	s1,s1
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
    name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
    name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
    for (i = 0; i < N; i++) {
     23a:	06400913          	li	s2,100
        name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
        unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00006097          	auipc	ra,0x6
     24a:	9bc080e7          	jalr	-1604(ra) # 5c02 <unlink>
    for (i = 0; i < N; i++) {
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	zext.b	s1,s1
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
    unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	f2c50513          	addi	a0,a0,-212 # 61a8 <malloc+0x1c4>
     284:	00006097          	auipc	ra,0x6
     288:	97e080e7          	jalr	-1666(ra) # 5c02 <unlink>
    for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     28c:	1f300493          	li	s1,499
        fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	f18a8a93          	addi	s5,s5,-232 # 61a8 <malloc+0x1c4>
            int cc = write(fd, buf, sz);
     298:	0000da17          	auipc	s4,0xd
     29c:	9e0a0a13          	addi	s4,s4,-1568 # cc78 <buf>
    for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <diskfull+0x15>
        fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00006097          	auipc	ra,0x6
     2b0:	946080e7          	jalr	-1722(ra) # 5bf2 <open>
     2b4:	892a                	mv	s2,a0
        if (fd < 0) {
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
            int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00006097          	auipc	ra,0x6
     2c2:	914080e7          	jalr	-1772(ra) # 5bd2 <write>
     2c6:	89aa                	mv	s3,a0
            if (cc != sz) {
     2c8:	06a49263          	bne	s1,a0,32c <bigwrite+0xc8>
            int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00006097          	auipc	ra,0x6
     2d6:	900080e7          	jalr	-1792(ra) # 5bd2 <write>
            if (cc != sz) {
     2da:	04951a63          	bne	a0,s1,32e <bigwrite+0xca>
        close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00006097          	auipc	ra,0x6
     2e4:	8fa080e7          	jalr	-1798(ra) # 5bda <close>
        unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00006097          	auipc	ra,0x6
     2ee:	918080e7          	jalr	-1768(ra) # 5c02 <unlink>
    for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
            printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	ea650513          	addi	a0,a0,-346 # 61b8 <malloc+0x1d4>
     31a:	00006097          	auipc	ra,0x6
     31e:	c12080e7          	jalr	-1006(ra) # 5f2c <printf>
            exit(1);
     322:	4505                	li	a0,1
     324:	00006097          	auipc	ra,0x6
     328:	88e080e7          	jalr	-1906(ra) # 5bb2 <exit>
            if (cc != sz) {
     32c:	89a6                	mv	s3,s1
                printf("%s: write(%d) ret %d\n", s, sz, cc);
     32e:	86aa                	mv	a3,a0
     330:	864e                	mv	a2,s3
     332:	85de                	mv	a1,s7
     334:	00006517          	auipc	a0,0x6
     338:	ea450513          	addi	a0,a0,-348 # 61d8 <malloc+0x1f4>
     33c:	00006097          	auipc	ra,0x6
     340:	bf0080e7          	jalr	-1040(ra) # 5f2c <printf>
                exit(1);
     344:	4505                	li	a0,1
     346:	00006097          	auipc	ra,0x6
     34a:	86c080e7          	jalr	-1940(ra) # 5bb2 <exit>

000000000000034e <badwrite>:
// a block to be allocated for a file that is then not freed when the
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void badwrite(char *s)
{
     34e:	7179                	addi	sp,sp,-48
     350:	f406                	sd	ra,40(sp)
     352:	f022                	sd	s0,32(sp)
     354:	ec26                	sd	s1,24(sp)
     356:	e84a                	sd	s2,16(sp)
     358:	e44e                	sd	s3,8(sp)
     35a:	e052                	sd	s4,0(sp)
     35c:	1800                	addi	s0,sp,48
    int assumed_free = 600;

    unlink("junk");
     35e:	00006517          	auipc	a0,0x6
     362:	e9250513          	addi	a0,a0,-366 # 61f0 <malloc+0x20c>
     366:	00006097          	auipc	ra,0x6
     36a:	89c080e7          	jalr	-1892(ra) # 5c02 <unlink>
     36e:	25800913          	li	s2,600
    for (int i = 0; i < assumed_free; i++) {
        int fd = open("junk", O_CREATE | O_WRONLY);
     372:	00006997          	auipc	s3,0x6
     376:	e7e98993          	addi	s3,s3,-386 # 61f0 <malloc+0x20c>
        if (fd < 0) {
            printf("open junk failed\n");
            exit(1);
        }
        write(fd, (char *)0xffffffffffL, 1);
     37a:	5a7d                	li	s4,-1
     37c:	018a5a13          	srli	s4,s4,0x18
        int fd = open("junk", O_CREATE | O_WRONLY);
     380:	20100593          	li	a1,513
     384:	854e                	mv	a0,s3
     386:	00006097          	auipc	ra,0x6
     38a:	86c080e7          	jalr	-1940(ra) # 5bf2 <open>
     38e:	84aa                	mv	s1,a0
        if (fd < 0) {
     390:	06054b63          	bltz	a0,406 <badwrite+0xb8>
        write(fd, (char *)0xffffffffffL, 1);
     394:	4605                	li	a2,1
     396:	85d2                	mv	a1,s4
     398:	00006097          	auipc	ra,0x6
     39c:	83a080e7          	jalr	-1990(ra) # 5bd2 <write>
        close(fd);
     3a0:	8526                	mv	a0,s1
     3a2:	00006097          	auipc	ra,0x6
     3a6:	838080e7          	jalr	-1992(ra) # 5bda <close>
        unlink("junk");
     3aa:	854e                	mv	a0,s3
     3ac:	00006097          	auipc	ra,0x6
     3b0:	856080e7          	jalr	-1962(ra) # 5c02 <unlink>
    for (int i = 0; i < assumed_free; i++) {
     3b4:	397d                	addiw	s2,s2,-1
     3b6:	fc0915e3          	bnez	s2,380 <badwrite+0x32>
    }

    int fd = open("junk", O_CREATE | O_WRONLY);
     3ba:	20100593          	li	a1,513
     3be:	00006517          	auipc	a0,0x6
     3c2:	e3250513          	addi	a0,a0,-462 # 61f0 <malloc+0x20c>
     3c6:	00006097          	auipc	ra,0x6
     3ca:	82c080e7          	jalr	-2004(ra) # 5bf2 <open>
     3ce:	84aa                	mv	s1,a0
    if (fd < 0) {
     3d0:	04054863          	bltz	a0,420 <badwrite+0xd2>
        printf("open junk failed\n");
        exit(1);
    }
    if (write(fd, "x", 1) != 1) {
     3d4:	4605                	li	a2,1
     3d6:	00006597          	auipc	a1,0x6
     3da:	da258593          	addi	a1,a1,-606 # 6178 <malloc+0x194>
     3de:	00005097          	auipc	ra,0x5
     3e2:	7f4080e7          	jalr	2036(ra) # 5bd2 <write>
     3e6:	4785                	li	a5,1
     3e8:	04f50963          	beq	a0,a5,43a <badwrite+0xec>
        printf("write failed\n");
     3ec:	00006517          	auipc	a0,0x6
     3f0:	e2450513          	addi	a0,a0,-476 # 6210 <malloc+0x22c>
     3f4:	00006097          	auipc	ra,0x6
     3f8:	b38080e7          	jalr	-1224(ra) # 5f2c <printf>
        exit(1);
     3fc:	4505                	li	a0,1
     3fe:	00005097          	auipc	ra,0x5
     402:	7b4080e7          	jalr	1972(ra) # 5bb2 <exit>
            printf("open junk failed\n");
     406:	00006517          	auipc	a0,0x6
     40a:	df250513          	addi	a0,a0,-526 # 61f8 <malloc+0x214>
     40e:	00006097          	auipc	ra,0x6
     412:	b1e080e7          	jalr	-1250(ra) # 5f2c <printf>
            exit(1);
     416:	4505                	li	a0,1
     418:	00005097          	auipc	ra,0x5
     41c:	79a080e7          	jalr	1946(ra) # 5bb2 <exit>
        printf("open junk failed\n");
     420:	00006517          	auipc	a0,0x6
     424:	dd850513          	addi	a0,a0,-552 # 61f8 <malloc+0x214>
     428:	00006097          	auipc	ra,0x6
     42c:	b04080e7          	jalr	-1276(ra) # 5f2c <printf>
        exit(1);
     430:	4505                	li	a0,1
     432:	00005097          	auipc	ra,0x5
     436:	780080e7          	jalr	1920(ra) # 5bb2 <exit>
    }
    close(fd);
     43a:	8526                	mv	a0,s1
     43c:	00005097          	auipc	ra,0x5
     440:	79e080e7          	jalr	1950(ra) # 5bda <close>
    unlink("junk");
     444:	00006517          	auipc	a0,0x6
     448:	dac50513          	addi	a0,a0,-596 # 61f0 <malloc+0x20c>
     44c:	00005097          	auipc	ra,0x5
     450:	7b6080e7          	jalr	1974(ra) # 5c02 <unlink>

    exit(0);
     454:	4501                	li	a0,0
     456:	00005097          	auipc	ra,0x5
     45a:	75c080e7          	jalr	1884(ra) # 5bb2 <exit>

000000000000045e <outofinodes>:
        unlink(name);
    }
}

void outofinodes(char *s)
{
     45e:	715d                	addi	sp,sp,-80
     460:	e486                	sd	ra,72(sp)
     462:	e0a2                	sd	s0,64(sp)
     464:	fc26                	sd	s1,56(sp)
     466:	f84a                	sd	s2,48(sp)
     468:	f44e                	sd	s3,40(sp)
     46a:	0880                	addi	s0,sp,80
    int nzz = 32 * 32;
    for (int i = 0; i < nzz; i++) {
     46c:	4481                	li	s1,0
        char name[32];
        name[0] = 'z';
     46e:	07a00913          	li	s2,122
    for (int i = 0; i < nzz; i++) {
     472:	40000993          	li	s3,1024
        name[0] = 'z';
     476:	fb240823          	sb	s2,-80(s0)
        name[1] = 'z';
     47a:	fb2408a3          	sb	s2,-79(s0)
        name[2] = '0' + (i / 32);
     47e:	41f4d71b          	sraiw	a4,s1,0x1f
     482:	01b7571b          	srliw	a4,a4,0x1b
     486:	009707bb          	addw	a5,a4,s1
     48a:	4057d69b          	sraiw	a3,a5,0x5
     48e:	0306869b          	addiw	a3,a3,48
     492:	fad40923          	sb	a3,-78(s0)
        name[3] = '0' + (i % 32);
     496:	8bfd                	andi	a5,a5,31
     498:	9f99                	subw	a5,a5,a4
     49a:	0307879b          	addiw	a5,a5,48
     49e:	faf409a3          	sb	a5,-77(s0)
        name[4] = '\0';
     4a2:	fa040a23          	sb	zero,-76(s0)
        unlink(name);
     4a6:	fb040513          	addi	a0,s0,-80
     4aa:	00005097          	auipc	ra,0x5
     4ae:	758080e7          	jalr	1880(ra) # 5c02 <unlink>
        int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
     4b2:	60200593          	li	a1,1538
     4b6:	fb040513          	addi	a0,s0,-80
     4ba:	00005097          	auipc	ra,0x5
     4be:	738080e7          	jalr	1848(ra) # 5bf2 <open>
        if (fd < 0) {
     4c2:	00054963          	bltz	a0,4d4 <outofinodes+0x76>
            // failure is eventually expected.
            break;
        }
        close(fd);
     4c6:	00005097          	auipc	ra,0x5
     4ca:	714080e7          	jalr	1812(ra) # 5bda <close>
    for (int i = 0; i < nzz; i++) {
     4ce:	2485                	addiw	s1,s1,1
     4d0:	fb3493e3          	bne	s1,s3,476 <outofinodes+0x18>
     4d4:	4481                	li	s1,0
    }

    for (int i = 0; i < nzz; i++) {
        char name[32];
        name[0] = 'z';
     4d6:	07a00913          	li	s2,122
    for (int i = 0; i < nzz; i++) {
     4da:	40000993          	li	s3,1024
        name[0] = 'z';
     4de:	fb240823          	sb	s2,-80(s0)
        name[1] = 'z';
     4e2:	fb2408a3          	sb	s2,-79(s0)
        name[2] = '0' + (i / 32);
     4e6:	41f4d71b          	sraiw	a4,s1,0x1f
     4ea:	01b7571b          	srliw	a4,a4,0x1b
     4ee:	009707bb          	addw	a5,a4,s1
     4f2:	4057d69b          	sraiw	a3,a5,0x5
     4f6:	0306869b          	addiw	a3,a3,48
     4fa:	fad40923          	sb	a3,-78(s0)
        name[3] = '0' + (i % 32);
     4fe:	8bfd                	andi	a5,a5,31
     500:	9f99                	subw	a5,a5,a4
     502:	0307879b          	addiw	a5,a5,48
     506:	faf409a3          	sb	a5,-77(s0)
        name[4] = '\0';
     50a:	fa040a23          	sb	zero,-76(s0)
        unlink(name);
     50e:	fb040513          	addi	a0,s0,-80
     512:	00005097          	auipc	ra,0x5
     516:	6f0080e7          	jalr	1776(ra) # 5c02 <unlink>
    for (int i = 0; i < nzz; i++) {
     51a:	2485                	addiw	s1,s1,1
     51c:	fd3491e3          	bne	s1,s3,4de <outofinodes+0x80>
    }
}
     520:	60a6                	ld	ra,72(sp)
     522:	6406                	ld	s0,64(sp)
     524:	74e2                	ld	s1,56(sp)
     526:	7942                	ld	s2,48(sp)
     528:	79a2                	ld	s3,40(sp)
     52a:	6161                	addi	sp,sp,80
     52c:	8082                	ret

000000000000052e <copyin>:
{
     52e:	715d                	addi	sp,sp,-80
     530:	e486                	sd	ra,72(sp)
     532:	e0a2                	sd	s0,64(sp)
     534:	fc26                	sd	s1,56(sp)
     536:	f84a                	sd	s2,48(sp)
     538:	f44e                	sd	s3,40(sp)
     53a:	f052                	sd	s4,32(sp)
     53c:	0880                	addi	s0,sp,80
    uint64 addrs[] = {0x80000000LL, 0xffffffffffffffff};
     53e:	4785                	li	a5,1
     540:	07fe                	slli	a5,a5,0x1f
     542:	fcf43023          	sd	a5,-64(s0)
     546:	57fd                	li	a5,-1
     548:	fcf43423          	sd	a5,-56(s0)
    for (int ai = 0; ai < 2; ai++) {
     54c:	fc040913          	addi	s2,s0,-64
        int fd = open("copyin1", O_CREATE | O_WRONLY);
     550:	00006a17          	auipc	s4,0x6
     554:	cd0a0a13          	addi	s4,s4,-816 # 6220 <malloc+0x23c>
        uint64 addr = addrs[ai];
     558:	00093983          	ld	s3,0(s2)
        int fd = open("copyin1", O_CREATE | O_WRONLY);
     55c:	20100593          	li	a1,513
     560:	8552                	mv	a0,s4
     562:	00005097          	auipc	ra,0x5
     566:	690080e7          	jalr	1680(ra) # 5bf2 <open>
     56a:	84aa                	mv	s1,a0
        if (fd < 0) {
     56c:	08054863          	bltz	a0,5fc <copyin+0xce>
        int n = write(fd, (void *)addr, 8192);
     570:	6609                	lui	a2,0x2
     572:	85ce                	mv	a1,s3
     574:	00005097          	auipc	ra,0x5
     578:	65e080e7          	jalr	1630(ra) # 5bd2 <write>
        if (n >= 0) {
     57c:	08055d63          	bgez	a0,616 <copyin+0xe8>
        close(fd);
     580:	8526                	mv	a0,s1
     582:	00005097          	auipc	ra,0x5
     586:	658080e7          	jalr	1624(ra) # 5bda <close>
        unlink("copyin1");
     58a:	8552                	mv	a0,s4
     58c:	00005097          	auipc	ra,0x5
     590:	676080e7          	jalr	1654(ra) # 5c02 <unlink>
        n = write(1, (char *)addr, 8192);
     594:	6609                	lui	a2,0x2
     596:	85ce                	mv	a1,s3
     598:	4505                	li	a0,1
     59a:	00005097          	auipc	ra,0x5
     59e:	638080e7          	jalr	1592(ra) # 5bd2 <write>
        if (n > 0) {
     5a2:	08a04963          	bgtz	a0,634 <copyin+0x106>
        if (pipe(fds) < 0) {
     5a6:	fb840513          	addi	a0,s0,-72
     5aa:	00005097          	auipc	ra,0x5
     5ae:	618080e7          	jalr	1560(ra) # 5bc2 <pipe>
     5b2:	0a054063          	bltz	a0,652 <copyin+0x124>
        n = write(fds[1], (char *)addr, 8192);
     5b6:	6609                	lui	a2,0x2
     5b8:	85ce                	mv	a1,s3
     5ba:	fbc42503          	lw	a0,-68(s0)
     5be:	00005097          	auipc	ra,0x5
     5c2:	614080e7          	jalr	1556(ra) # 5bd2 <write>
        if (n > 0) {
     5c6:	0aa04363          	bgtz	a0,66c <copyin+0x13e>
        close(fds[0]);
     5ca:	fb842503          	lw	a0,-72(s0)
     5ce:	00005097          	auipc	ra,0x5
     5d2:	60c080e7          	jalr	1548(ra) # 5bda <close>
        close(fds[1]);
     5d6:	fbc42503          	lw	a0,-68(s0)
     5da:	00005097          	auipc	ra,0x5
     5de:	600080e7          	jalr	1536(ra) # 5bda <close>
    for (int ai = 0; ai < 2; ai++) {
     5e2:	0921                	addi	s2,s2,8
     5e4:	fd040793          	addi	a5,s0,-48
     5e8:	f6f918e3          	bne	s2,a5,558 <copyin+0x2a>
}
     5ec:	60a6                	ld	ra,72(sp)
     5ee:	6406                	ld	s0,64(sp)
     5f0:	74e2                	ld	s1,56(sp)
     5f2:	7942                	ld	s2,48(sp)
     5f4:	79a2                	ld	s3,40(sp)
     5f6:	7a02                	ld	s4,32(sp)
     5f8:	6161                	addi	sp,sp,80
     5fa:	8082                	ret
            printf("open(copyin1) failed\n");
     5fc:	00006517          	auipc	a0,0x6
     600:	c2c50513          	addi	a0,a0,-980 # 6228 <malloc+0x244>
     604:	00006097          	auipc	ra,0x6
     608:	928080e7          	jalr	-1752(ra) # 5f2c <printf>
            exit(1);
     60c:	4505                	li	a0,1
     60e:	00005097          	auipc	ra,0x5
     612:	5a4080e7          	jalr	1444(ra) # 5bb2 <exit>
            printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     616:	862a                	mv	a2,a0
     618:	85ce                	mv	a1,s3
     61a:	00006517          	auipc	a0,0x6
     61e:	c2650513          	addi	a0,a0,-986 # 6240 <malloc+0x25c>
     622:	00006097          	auipc	ra,0x6
     626:	90a080e7          	jalr	-1782(ra) # 5f2c <printf>
            exit(1);
     62a:	4505                	li	a0,1
     62c:	00005097          	auipc	ra,0x5
     630:	586080e7          	jalr	1414(ra) # 5bb2 <exit>
            printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     634:	862a                	mv	a2,a0
     636:	85ce                	mv	a1,s3
     638:	00006517          	auipc	a0,0x6
     63c:	c3850513          	addi	a0,a0,-968 # 6270 <malloc+0x28c>
     640:	00006097          	auipc	ra,0x6
     644:	8ec080e7          	jalr	-1812(ra) # 5f2c <printf>
            exit(1);
     648:	4505                	li	a0,1
     64a:	00005097          	auipc	ra,0x5
     64e:	568080e7          	jalr	1384(ra) # 5bb2 <exit>
            printf("pipe() failed\n");
     652:	00006517          	auipc	a0,0x6
     656:	c4e50513          	addi	a0,a0,-946 # 62a0 <malloc+0x2bc>
     65a:	00006097          	auipc	ra,0x6
     65e:	8d2080e7          	jalr	-1838(ra) # 5f2c <printf>
            exit(1);
     662:	4505                	li	a0,1
     664:	00005097          	auipc	ra,0x5
     668:	54e080e7          	jalr	1358(ra) # 5bb2 <exit>
            printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     66c:	862a                	mv	a2,a0
     66e:	85ce                	mv	a1,s3
     670:	00006517          	auipc	a0,0x6
     674:	c4050513          	addi	a0,a0,-960 # 62b0 <malloc+0x2cc>
     678:	00006097          	auipc	ra,0x6
     67c:	8b4080e7          	jalr	-1868(ra) # 5f2c <printf>
            exit(1);
     680:	4505                	li	a0,1
     682:	00005097          	auipc	ra,0x5
     686:	530080e7          	jalr	1328(ra) # 5bb2 <exit>

000000000000068a <copyout>:
{
     68a:	711d                	addi	sp,sp,-96
     68c:	ec86                	sd	ra,88(sp)
     68e:	e8a2                	sd	s0,80(sp)
     690:	e4a6                	sd	s1,72(sp)
     692:	e0ca                	sd	s2,64(sp)
     694:	fc4e                	sd	s3,56(sp)
     696:	f852                	sd	s4,48(sp)
     698:	f456                	sd	s5,40(sp)
     69a:	1080                	addi	s0,sp,96
    uint64 addrs[] = {0x80000000LL, 0xffffffffffffffff};
     69c:	4785                	li	a5,1
     69e:	07fe                	slli	a5,a5,0x1f
     6a0:	faf43823          	sd	a5,-80(s0)
     6a4:	57fd                	li	a5,-1
     6a6:	faf43c23          	sd	a5,-72(s0)
    for (int ai = 0; ai < 2; ai++) {
     6aa:	fb040913          	addi	s2,s0,-80
        int fd = open("README", 0);
     6ae:	00006a17          	auipc	s4,0x6
     6b2:	c32a0a13          	addi	s4,s4,-974 # 62e0 <malloc+0x2fc>
        n = write(fds[1], "x", 1);
     6b6:	00006a97          	auipc	s5,0x6
     6ba:	ac2a8a93          	addi	s5,s5,-1342 # 6178 <malloc+0x194>
        uint64 addr = addrs[ai];
     6be:	00093983          	ld	s3,0(s2)
        int fd = open("README", 0);
     6c2:	4581                	li	a1,0
     6c4:	8552                	mv	a0,s4
     6c6:	00005097          	auipc	ra,0x5
     6ca:	52c080e7          	jalr	1324(ra) # 5bf2 <open>
     6ce:	84aa                	mv	s1,a0
        if (fd < 0) {
     6d0:	08054663          	bltz	a0,75c <copyout+0xd2>
        int n = read(fd, (void *)addr, 8192);
     6d4:	6609                	lui	a2,0x2
     6d6:	85ce                	mv	a1,s3
     6d8:	00005097          	auipc	ra,0x5
     6dc:	4f2080e7          	jalr	1266(ra) # 5bca <read>
        if (n > 0) {
     6e0:	08a04b63          	bgtz	a0,776 <copyout+0xec>
        close(fd);
     6e4:	8526                	mv	a0,s1
     6e6:	00005097          	auipc	ra,0x5
     6ea:	4f4080e7          	jalr	1268(ra) # 5bda <close>
        if (pipe(fds) < 0) {
     6ee:	fa840513          	addi	a0,s0,-88
     6f2:	00005097          	auipc	ra,0x5
     6f6:	4d0080e7          	jalr	1232(ra) # 5bc2 <pipe>
     6fa:	08054d63          	bltz	a0,794 <copyout+0x10a>
        n = write(fds[1], "x", 1);
     6fe:	4605                	li	a2,1
     700:	85d6                	mv	a1,s5
     702:	fac42503          	lw	a0,-84(s0)
     706:	00005097          	auipc	ra,0x5
     70a:	4cc080e7          	jalr	1228(ra) # 5bd2 <write>
        if (n != 1) {
     70e:	4785                	li	a5,1
     710:	08f51f63          	bne	a0,a5,7ae <copyout+0x124>
        n = read(fds[0], (void *)addr, 8192);
     714:	6609                	lui	a2,0x2
     716:	85ce                	mv	a1,s3
     718:	fa842503          	lw	a0,-88(s0)
     71c:	00005097          	auipc	ra,0x5
     720:	4ae080e7          	jalr	1198(ra) # 5bca <read>
        if (n > 0) {
     724:	0aa04263          	bgtz	a0,7c8 <copyout+0x13e>
        close(fds[0]);
     728:	fa842503          	lw	a0,-88(s0)
     72c:	00005097          	auipc	ra,0x5
     730:	4ae080e7          	jalr	1198(ra) # 5bda <close>
        close(fds[1]);
     734:	fac42503          	lw	a0,-84(s0)
     738:	00005097          	auipc	ra,0x5
     73c:	4a2080e7          	jalr	1186(ra) # 5bda <close>
    for (int ai = 0; ai < 2; ai++) {
     740:	0921                	addi	s2,s2,8
     742:	fc040793          	addi	a5,s0,-64
     746:	f6f91ce3          	bne	s2,a5,6be <copyout+0x34>
}
     74a:	60e6                	ld	ra,88(sp)
     74c:	6446                	ld	s0,80(sp)
     74e:	64a6                	ld	s1,72(sp)
     750:	6906                	ld	s2,64(sp)
     752:	79e2                	ld	s3,56(sp)
     754:	7a42                	ld	s4,48(sp)
     756:	7aa2                	ld	s5,40(sp)
     758:	6125                	addi	sp,sp,96
     75a:	8082                	ret
            printf("open(README) failed\n");
     75c:	00006517          	auipc	a0,0x6
     760:	b8c50513          	addi	a0,a0,-1140 # 62e8 <malloc+0x304>
     764:	00005097          	auipc	ra,0x5
     768:	7c8080e7          	jalr	1992(ra) # 5f2c <printf>
            exit(1);
     76c:	4505                	li	a0,1
     76e:	00005097          	auipc	ra,0x5
     772:	444080e7          	jalr	1092(ra) # 5bb2 <exit>
            printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     776:	862a                	mv	a2,a0
     778:	85ce                	mv	a1,s3
     77a:	00006517          	auipc	a0,0x6
     77e:	b8650513          	addi	a0,a0,-1146 # 6300 <malloc+0x31c>
     782:	00005097          	auipc	ra,0x5
     786:	7aa080e7          	jalr	1962(ra) # 5f2c <printf>
            exit(1);
     78a:	4505                	li	a0,1
     78c:	00005097          	auipc	ra,0x5
     790:	426080e7          	jalr	1062(ra) # 5bb2 <exit>
            printf("pipe() failed\n");
     794:	00006517          	auipc	a0,0x6
     798:	b0c50513          	addi	a0,a0,-1268 # 62a0 <malloc+0x2bc>
     79c:	00005097          	auipc	ra,0x5
     7a0:	790080e7          	jalr	1936(ra) # 5f2c <printf>
            exit(1);
     7a4:	4505                	li	a0,1
     7a6:	00005097          	auipc	ra,0x5
     7aa:	40c080e7          	jalr	1036(ra) # 5bb2 <exit>
            printf("pipe write failed\n");
     7ae:	00006517          	auipc	a0,0x6
     7b2:	b8250513          	addi	a0,a0,-1150 # 6330 <malloc+0x34c>
     7b6:	00005097          	auipc	ra,0x5
     7ba:	776080e7          	jalr	1910(ra) # 5f2c <printf>
            exit(1);
     7be:	4505                	li	a0,1
     7c0:	00005097          	auipc	ra,0x5
     7c4:	3f2080e7          	jalr	1010(ra) # 5bb2 <exit>
            printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7c8:	862a                	mv	a2,a0
     7ca:	85ce                	mv	a1,s3
     7cc:	00006517          	auipc	a0,0x6
     7d0:	b7c50513          	addi	a0,a0,-1156 # 6348 <malloc+0x364>
     7d4:	00005097          	auipc	ra,0x5
     7d8:	758080e7          	jalr	1880(ra) # 5f2c <printf>
            exit(1);
     7dc:	4505                	li	a0,1
     7de:	00005097          	auipc	ra,0x5
     7e2:	3d4080e7          	jalr	980(ra) # 5bb2 <exit>

00000000000007e6 <truncate1>:
{
     7e6:	711d                	addi	sp,sp,-96
     7e8:	ec86                	sd	ra,88(sp)
     7ea:	e8a2                	sd	s0,80(sp)
     7ec:	e4a6                	sd	s1,72(sp)
     7ee:	e0ca                	sd	s2,64(sp)
     7f0:	fc4e                	sd	s3,56(sp)
     7f2:	f852                	sd	s4,48(sp)
     7f4:	f456                	sd	s5,40(sp)
     7f6:	1080                	addi	s0,sp,96
     7f8:	8aaa                	mv	s5,a0
    unlink("truncfile");
     7fa:	00006517          	auipc	a0,0x6
     7fe:	96650513          	addi	a0,a0,-1690 # 6160 <malloc+0x17c>
     802:	00005097          	auipc	ra,0x5
     806:	400080e7          	jalr	1024(ra) # 5c02 <unlink>
    int fd1 = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
     80a:	60100593          	li	a1,1537
     80e:	00006517          	auipc	a0,0x6
     812:	95250513          	addi	a0,a0,-1710 # 6160 <malloc+0x17c>
     816:	00005097          	auipc	ra,0x5
     81a:	3dc080e7          	jalr	988(ra) # 5bf2 <open>
     81e:	84aa                	mv	s1,a0
    write(fd1, "abcd", 4);
     820:	4611                	li	a2,4
     822:	00006597          	auipc	a1,0x6
     826:	94e58593          	addi	a1,a1,-1714 # 6170 <malloc+0x18c>
     82a:	00005097          	auipc	ra,0x5
     82e:	3a8080e7          	jalr	936(ra) # 5bd2 <write>
    close(fd1);
     832:	8526                	mv	a0,s1
     834:	00005097          	auipc	ra,0x5
     838:	3a6080e7          	jalr	934(ra) # 5bda <close>
    int fd2 = open("truncfile", O_RDONLY);
     83c:	4581                	li	a1,0
     83e:	00006517          	auipc	a0,0x6
     842:	92250513          	addi	a0,a0,-1758 # 6160 <malloc+0x17c>
     846:	00005097          	auipc	ra,0x5
     84a:	3ac080e7          	jalr	940(ra) # 5bf2 <open>
     84e:	84aa                	mv	s1,a0
    int n = read(fd2, buf, sizeof(buf));
     850:	02000613          	li	a2,32
     854:	fa040593          	addi	a1,s0,-96
     858:	00005097          	auipc	ra,0x5
     85c:	372080e7          	jalr	882(ra) # 5bca <read>
    if (n != 4) {
     860:	4791                	li	a5,4
     862:	0cf51e63          	bne	a0,a5,93e <truncate1+0x158>
    fd1 = open("truncfile", O_WRONLY | O_TRUNC);
     866:	40100593          	li	a1,1025
     86a:	00006517          	auipc	a0,0x6
     86e:	8f650513          	addi	a0,a0,-1802 # 6160 <malloc+0x17c>
     872:	00005097          	auipc	ra,0x5
     876:	380080e7          	jalr	896(ra) # 5bf2 <open>
     87a:	89aa                	mv	s3,a0
    int fd3 = open("truncfile", O_RDONLY);
     87c:	4581                	li	a1,0
     87e:	00006517          	auipc	a0,0x6
     882:	8e250513          	addi	a0,a0,-1822 # 6160 <malloc+0x17c>
     886:	00005097          	auipc	ra,0x5
     88a:	36c080e7          	jalr	876(ra) # 5bf2 <open>
     88e:	892a                	mv	s2,a0
    n = read(fd3, buf, sizeof(buf));
     890:	02000613          	li	a2,32
     894:	fa040593          	addi	a1,s0,-96
     898:	00005097          	auipc	ra,0x5
     89c:	332080e7          	jalr	818(ra) # 5bca <read>
     8a0:	8a2a                	mv	s4,a0
    if (n != 0) {
     8a2:	ed4d                	bnez	a0,95c <truncate1+0x176>
    n = read(fd2, buf, sizeof(buf));
     8a4:	02000613          	li	a2,32
     8a8:	fa040593          	addi	a1,s0,-96
     8ac:	8526                	mv	a0,s1
     8ae:	00005097          	auipc	ra,0x5
     8b2:	31c080e7          	jalr	796(ra) # 5bca <read>
     8b6:	8a2a                	mv	s4,a0
    if (n != 0) {
     8b8:	e971                	bnez	a0,98c <truncate1+0x1a6>
    write(fd1, "abcdef", 6);
     8ba:	4619                	li	a2,6
     8bc:	00006597          	auipc	a1,0x6
     8c0:	b1c58593          	addi	a1,a1,-1252 # 63d8 <malloc+0x3f4>
     8c4:	854e                	mv	a0,s3
     8c6:	00005097          	auipc	ra,0x5
     8ca:	30c080e7          	jalr	780(ra) # 5bd2 <write>
    n = read(fd3, buf, sizeof(buf));
     8ce:	02000613          	li	a2,32
     8d2:	fa040593          	addi	a1,s0,-96
     8d6:	854a                	mv	a0,s2
     8d8:	00005097          	auipc	ra,0x5
     8dc:	2f2080e7          	jalr	754(ra) # 5bca <read>
    if (n != 6) {
     8e0:	4799                	li	a5,6
     8e2:	0cf51d63          	bne	a0,a5,9bc <truncate1+0x1d6>
    n = read(fd2, buf, sizeof(buf));
     8e6:	02000613          	li	a2,32
     8ea:	fa040593          	addi	a1,s0,-96
     8ee:	8526                	mv	a0,s1
     8f0:	00005097          	auipc	ra,0x5
     8f4:	2da080e7          	jalr	730(ra) # 5bca <read>
    if (n != 2) {
     8f8:	4789                	li	a5,2
     8fa:	0ef51063          	bne	a0,a5,9da <truncate1+0x1f4>
    unlink("truncfile");
     8fe:	00006517          	auipc	a0,0x6
     902:	86250513          	addi	a0,a0,-1950 # 6160 <malloc+0x17c>
     906:	00005097          	auipc	ra,0x5
     90a:	2fc080e7          	jalr	764(ra) # 5c02 <unlink>
    close(fd1);
     90e:	854e                	mv	a0,s3
     910:	00005097          	auipc	ra,0x5
     914:	2ca080e7          	jalr	714(ra) # 5bda <close>
    close(fd2);
     918:	8526                	mv	a0,s1
     91a:	00005097          	auipc	ra,0x5
     91e:	2c0080e7          	jalr	704(ra) # 5bda <close>
    close(fd3);
     922:	854a                	mv	a0,s2
     924:	00005097          	auipc	ra,0x5
     928:	2b6080e7          	jalr	694(ra) # 5bda <close>
}
     92c:	60e6                	ld	ra,88(sp)
     92e:	6446                	ld	s0,80(sp)
     930:	64a6                	ld	s1,72(sp)
     932:	6906                	ld	s2,64(sp)
     934:	79e2                	ld	s3,56(sp)
     936:	7a42                	ld	s4,48(sp)
     938:	7aa2                	ld	s5,40(sp)
     93a:	6125                	addi	sp,sp,96
     93c:	8082                	ret
        printf("%s: read %d bytes, wanted 4\n", s, n);
     93e:	862a                	mv	a2,a0
     940:	85d6                	mv	a1,s5
     942:	00006517          	auipc	a0,0x6
     946:	a3650513          	addi	a0,a0,-1482 # 6378 <malloc+0x394>
     94a:	00005097          	auipc	ra,0x5
     94e:	5e2080e7          	jalr	1506(ra) # 5f2c <printf>
        exit(1);
     952:	4505                	li	a0,1
     954:	00005097          	auipc	ra,0x5
     958:	25e080e7          	jalr	606(ra) # 5bb2 <exit>
        printf("aaa fd3=%d\n", fd3);
     95c:	85ca                	mv	a1,s2
     95e:	00006517          	auipc	a0,0x6
     962:	a3a50513          	addi	a0,a0,-1478 # 6398 <malloc+0x3b4>
     966:	00005097          	auipc	ra,0x5
     96a:	5c6080e7          	jalr	1478(ra) # 5f2c <printf>
        printf("%s: read %d bytes, wanted 0\n", s, n);
     96e:	8652                	mv	a2,s4
     970:	85d6                	mv	a1,s5
     972:	00006517          	auipc	a0,0x6
     976:	a3650513          	addi	a0,a0,-1482 # 63a8 <malloc+0x3c4>
     97a:	00005097          	auipc	ra,0x5
     97e:	5b2080e7          	jalr	1458(ra) # 5f2c <printf>
        exit(1);
     982:	4505                	li	a0,1
     984:	00005097          	auipc	ra,0x5
     988:	22e080e7          	jalr	558(ra) # 5bb2 <exit>
        printf("bbb fd2=%d\n", fd2);
     98c:	85a6                	mv	a1,s1
     98e:	00006517          	auipc	a0,0x6
     992:	a3a50513          	addi	a0,a0,-1478 # 63c8 <malloc+0x3e4>
     996:	00005097          	auipc	ra,0x5
     99a:	596080e7          	jalr	1430(ra) # 5f2c <printf>
        printf("%s: read %d bytes, wanted 0\n", s, n);
     99e:	8652                	mv	a2,s4
     9a0:	85d6                	mv	a1,s5
     9a2:	00006517          	auipc	a0,0x6
     9a6:	a0650513          	addi	a0,a0,-1530 # 63a8 <malloc+0x3c4>
     9aa:	00005097          	auipc	ra,0x5
     9ae:	582080e7          	jalr	1410(ra) # 5f2c <printf>
        exit(1);
     9b2:	4505                	li	a0,1
     9b4:	00005097          	auipc	ra,0x5
     9b8:	1fe080e7          	jalr	510(ra) # 5bb2 <exit>
        printf("%s: read %d bytes, wanted 6\n", s, n);
     9bc:	862a                	mv	a2,a0
     9be:	85d6                	mv	a1,s5
     9c0:	00006517          	auipc	a0,0x6
     9c4:	a2050513          	addi	a0,a0,-1504 # 63e0 <malloc+0x3fc>
     9c8:	00005097          	auipc	ra,0x5
     9cc:	564080e7          	jalr	1380(ra) # 5f2c <printf>
        exit(1);
     9d0:	4505                	li	a0,1
     9d2:	00005097          	auipc	ra,0x5
     9d6:	1e0080e7          	jalr	480(ra) # 5bb2 <exit>
        printf("%s: read %d bytes, wanted 2\n", s, n);
     9da:	862a                	mv	a2,a0
     9dc:	85d6                	mv	a1,s5
     9de:	00006517          	auipc	a0,0x6
     9e2:	a2250513          	addi	a0,a0,-1502 # 6400 <malloc+0x41c>
     9e6:	00005097          	auipc	ra,0x5
     9ea:	546080e7          	jalr	1350(ra) # 5f2c <printf>
        exit(1);
     9ee:	4505                	li	a0,1
     9f0:	00005097          	auipc	ra,0x5
     9f4:	1c2080e7          	jalr	450(ra) # 5bb2 <exit>

00000000000009f8 <writetest>:
{
     9f8:	7139                	addi	sp,sp,-64
     9fa:	fc06                	sd	ra,56(sp)
     9fc:	f822                	sd	s0,48(sp)
     9fe:	f426                	sd	s1,40(sp)
     a00:	f04a                	sd	s2,32(sp)
     a02:	ec4e                	sd	s3,24(sp)
     a04:	e852                	sd	s4,16(sp)
     a06:	e456                	sd	s5,8(sp)
     a08:	e05a                	sd	s6,0(sp)
     a0a:	0080                	addi	s0,sp,64
     a0c:	8b2a                	mv	s6,a0
    fd = open("small", O_CREATE | O_RDWR);
     a0e:	20200593          	li	a1,514
     a12:	00006517          	auipc	a0,0x6
     a16:	a0e50513          	addi	a0,a0,-1522 # 6420 <malloc+0x43c>
     a1a:	00005097          	auipc	ra,0x5
     a1e:	1d8080e7          	jalr	472(ra) # 5bf2 <open>
    if (fd < 0) {
     a22:	0a054d63          	bltz	a0,adc <writetest+0xe4>
     a26:	892a                	mv	s2,a0
     a28:	4481                	li	s1,0
        if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     a2a:	00006997          	auipc	s3,0x6
     a2e:	a1e98993          	addi	s3,s3,-1506 # 6448 <malloc+0x464>
        if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     a32:	00006a97          	auipc	s5,0x6
     a36:	a4ea8a93          	addi	s5,s5,-1458 # 6480 <malloc+0x49c>
    for (i = 0; i < N; i++) {
     a3a:	06400a13          	li	s4,100
        if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     a3e:	4629                	li	a2,10
     a40:	85ce                	mv	a1,s3
     a42:	854a                	mv	a0,s2
     a44:	00005097          	auipc	ra,0x5
     a48:	18e080e7          	jalr	398(ra) # 5bd2 <write>
     a4c:	47a9                	li	a5,10
     a4e:	0af51563          	bne	a0,a5,af8 <writetest+0x100>
        if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     a52:	4629                	li	a2,10
     a54:	85d6                	mv	a1,s5
     a56:	854a                	mv	a0,s2
     a58:	00005097          	auipc	ra,0x5
     a5c:	17a080e7          	jalr	378(ra) # 5bd2 <write>
     a60:	47a9                	li	a5,10
     a62:	0af51a63          	bne	a0,a5,b16 <writetest+0x11e>
    for (i = 0; i < N; i++) {
     a66:	2485                	addiw	s1,s1,1
     a68:	fd449be3          	bne	s1,s4,a3e <writetest+0x46>
    close(fd);
     a6c:	854a                	mv	a0,s2
     a6e:	00005097          	auipc	ra,0x5
     a72:	16c080e7          	jalr	364(ra) # 5bda <close>
    fd = open("small", O_RDONLY);
     a76:	4581                	li	a1,0
     a78:	00006517          	auipc	a0,0x6
     a7c:	9a850513          	addi	a0,a0,-1624 # 6420 <malloc+0x43c>
     a80:	00005097          	auipc	ra,0x5
     a84:	172080e7          	jalr	370(ra) # 5bf2 <open>
     a88:	84aa                	mv	s1,a0
    if (fd < 0) {
     a8a:	0a054563          	bltz	a0,b34 <writetest+0x13c>
    i = read(fd, buf, N * SZ * 2);
     a8e:	7d000613          	li	a2,2000
     a92:	0000c597          	auipc	a1,0xc
     a96:	1e658593          	addi	a1,a1,486 # cc78 <buf>
     a9a:	00005097          	auipc	ra,0x5
     a9e:	130080e7          	jalr	304(ra) # 5bca <read>
    if (i != N * SZ * 2) {
     aa2:	7d000793          	li	a5,2000
     aa6:	0af51563          	bne	a0,a5,b50 <writetest+0x158>
    close(fd);
     aaa:	8526                	mv	a0,s1
     aac:	00005097          	auipc	ra,0x5
     ab0:	12e080e7          	jalr	302(ra) # 5bda <close>
    if (unlink("small") < 0) {
     ab4:	00006517          	auipc	a0,0x6
     ab8:	96c50513          	addi	a0,a0,-1684 # 6420 <malloc+0x43c>
     abc:	00005097          	auipc	ra,0x5
     ac0:	146080e7          	jalr	326(ra) # 5c02 <unlink>
     ac4:	0a054463          	bltz	a0,b6c <writetest+0x174>
}
     ac8:	70e2                	ld	ra,56(sp)
     aca:	7442                	ld	s0,48(sp)
     acc:	74a2                	ld	s1,40(sp)
     ace:	7902                	ld	s2,32(sp)
     ad0:	69e2                	ld	s3,24(sp)
     ad2:	6a42                	ld	s4,16(sp)
     ad4:	6aa2                	ld	s5,8(sp)
     ad6:	6b02                	ld	s6,0(sp)
     ad8:	6121                	addi	sp,sp,64
     ada:	8082                	ret
        printf("%s: error: creat small failed!\n", s);
     adc:	85da                	mv	a1,s6
     ade:	00006517          	auipc	a0,0x6
     ae2:	94a50513          	addi	a0,a0,-1718 # 6428 <malloc+0x444>
     ae6:	00005097          	auipc	ra,0x5
     aea:	446080e7          	jalr	1094(ra) # 5f2c <printf>
        exit(1);
     aee:	4505                	li	a0,1
     af0:	00005097          	auipc	ra,0x5
     af4:	0c2080e7          	jalr	194(ra) # 5bb2 <exit>
            printf("%s: error: write aa %d new file failed\n", s, i);
     af8:	8626                	mv	a2,s1
     afa:	85da                	mv	a1,s6
     afc:	00006517          	auipc	a0,0x6
     b00:	95c50513          	addi	a0,a0,-1700 # 6458 <malloc+0x474>
     b04:	00005097          	auipc	ra,0x5
     b08:	428080e7          	jalr	1064(ra) # 5f2c <printf>
            exit(1);
     b0c:	4505                	li	a0,1
     b0e:	00005097          	auipc	ra,0x5
     b12:	0a4080e7          	jalr	164(ra) # 5bb2 <exit>
            printf("%s: error: write bb %d new file failed\n", s, i);
     b16:	8626                	mv	a2,s1
     b18:	85da                	mv	a1,s6
     b1a:	00006517          	auipc	a0,0x6
     b1e:	97650513          	addi	a0,a0,-1674 # 6490 <malloc+0x4ac>
     b22:	00005097          	auipc	ra,0x5
     b26:	40a080e7          	jalr	1034(ra) # 5f2c <printf>
            exit(1);
     b2a:	4505                	li	a0,1
     b2c:	00005097          	auipc	ra,0x5
     b30:	086080e7          	jalr	134(ra) # 5bb2 <exit>
        printf("%s: error: open small failed!\n", s);
     b34:	85da                	mv	a1,s6
     b36:	00006517          	auipc	a0,0x6
     b3a:	98250513          	addi	a0,a0,-1662 # 64b8 <malloc+0x4d4>
     b3e:	00005097          	auipc	ra,0x5
     b42:	3ee080e7          	jalr	1006(ra) # 5f2c <printf>
        exit(1);
     b46:	4505                	li	a0,1
     b48:	00005097          	auipc	ra,0x5
     b4c:	06a080e7          	jalr	106(ra) # 5bb2 <exit>
        printf("%s: read failed\n", s);
     b50:	85da                	mv	a1,s6
     b52:	00006517          	auipc	a0,0x6
     b56:	98650513          	addi	a0,a0,-1658 # 64d8 <malloc+0x4f4>
     b5a:	00005097          	auipc	ra,0x5
     b5e:	3d2080e7          	jalr	978(ra) # 5f2c <printf>
        exit(1);
     b62:	4505                	li	a0,1
     b64:	00005097          	auipc	ra,0x5
     b68:	04e080e7          	jalr	78(ra) # 5bb2 <exit>
        printf("%s: unlink small failed\n", s);
     b6c:	85da                	mv	a1,s6
     b6e:	00006517          	auipc	a0,0x6
     b72:	98250513          	addi	a0,a0,-1662 # 64f0 <malloc+0x50c>
     b76:	00005097          	auipc	ra,0x5
     b7a:	3b6080e7          	jalr	950(ra) # 5f2c <printf>
        exit(1);
     b7e:	4505                	li	a0,1
     b80:	00005097          	auipc	ra,0x5
     b84:	032080e7          	jalr	50(ra) # 5bb2 <exit>

0000000000000b88 <writebig>:
{
     b88:	7139                	addi	sp,sp,-64
     b8a:	fc06                	sd	ra,56(sp)
     b8c:	f822                	sd	s0,48(sp)
     b8e:	f426                	sd	s1,40(sp)
     b90:	f04a                	sd	s2,32(sp)
     b92:	ec4e                	sd	s3,24(sp)
     b94:	e852                	sd	s4,16(sp)
     b96:	e456                	sd	s5,8(sp)
     b98:	0080                	addi	s0,sp,64
     b9a:	8aaa                	mv	s5,a0
    fd = open("big", O_CREATE | O_RDWR);
     b9c:	20200593          	li	a1,514
     ba0:	00006517          	auipc	a0,0x6
     ba4:	97050513          	addi	a0,a0,-1680 # 6510 <malloc+0x52c>
     ba8:	00005097          	auipc	ra,0x5
     bac:	04a080e7          	jalr	74(ra) # 5bf2 <open>
     bb0:	89aa                	mv	s3,a0
    for (i = 0; i < MAXFILE; i++) {
     bb2:	4481                	li	s1,0
        ((int *)buf)[0] = i;
     bb4:	0000c917          	auipc	s2,0xc
     bb8:	0c490913          	addi	s2,s2,196 # cc78 <buf>
    for (i = 0; i < MAXFILE; i++) {
     bbc:	10c00a13          	li	s4,268
    if (fd < 0) {
     bc0:	06054c63          	bltz	a0,c38 <writebig+0xb0>
        ((int *)buf)[0] = i;
     bc4:	00992023          	sw	s1,0(s2)
        if (write(fd, buf, BSIZE) != BSIZE) {
     bc8:	40000613          	li	a2,1024
     bcc:	85ca                	mv	a1,s2
     bce:	854e                	mv	a0,s3
     bd0:	00005097          	auipc	ra,0x5
     bd4:	002080e7          	jalr	2(ra) # 5bd2 <write>
     bd8:	40000793          	li	a5,1024
     bdc:	06f51c63          	bne	a0,a5,c54 <writebig+0xcc>
    for (i = 0; i < MAXFILE; i++) {
     be0:	2485                	addiw	s1,s1,1
     be2:	ff4491e3          	bne	s1,s4,bc4 <writebig+0x3c>
    close(fd);
     be6:	854e                	mv	a0,s3
     be8:	00005097          	auipc	ra,0x5
     bec:	ff2080e7          	jalr	-14(ra) # 5bda <close>
    fd = open("big", O_RDONLY);
     bf0:	4581                	li	a1,0
     bf2:	00006517          	auipc	a0,0x6
     bf6:	91e50513          	addi	a0,a0,-1762 # 6510 <malloc+0x52c>
     bfa:	00005097          	auipc	ra,0x5
     bfe:	ff8080e7          	jalr	-8(ra) # 5bf2 <open>
     c02:	89aa                	mv	s3,a0
    n = 0;
     c04:	4481                	li	s1,0
        i = read(fd, buf, BSIZE);
     c06:	0000c917          	auipc	s2,0xc
     c0a:	07290913          	addi	s2,s2,114 # cc78 <buf>
    if (fd < 0) {
     c0e:	06054263          	bltz	a0,c72 <writebig+0xea>
        i = read(fd, buf, BSIZE);
     c12:	40000613          	li	a2,1024
     c16:	85ca                	mv	a1,s2
     c18:	854e                	mv	a0,s3
     c1a:	00005097          	auipc	ra,0x5
     c1e:	fb0080e7          	jalr	-80(ra) # 5bca <read>
        if (i == 0) {
     c22:	c535                	beqz	a0,c8e <writebig+0x106>
        else if (i != BSIZE) {
     c24:	40000793          	li	a5,1024
     c28:	0af51f63          	bne	a0,a5,ce6 <writebig+0x15e>
        if (((int *)buf)[0] != n) {
     c2c:	00092683          	lw	a3,0(s2)
     c30:	0c969a63          	bne	a3,s1,d04 <writebig+0x17c>
        n++;
     c34:	2485                	addiw	s1,s1,1
        i = read(fd, buf, BSIZE);
     c36:	bff1                	j	c12 <writebig+0x8a>
        printf("%s: error: creat big failed!\n", s);
     c38:	85d6                	mv	a1,s5
     c3a:	00006517          	auipc	a0,0x6
     c3e:	8de50513          	addi	a0,a0,-1826 # 6518 <malloc+0x534>
     c42:	00005097          	auipc	ra,0x5
     c46:	2ea080e7          	jalr	746(ra) # 5f2c <printf>
        exit(1);
     c4a:	4505                	li	a0,1
     c4c:	00005097          	auipc	ra,0x5
     c50:	f66080e7          	jalr	-154(ra) # 5bb2 <exit>
            printf("%s: error: write big file failed\n", s, i);
     c54:	8626                	mv	a2,s1
     c56:	85d6                	mv	a1,s5
     c58:	00006517          	auipc	a0,0x6
     c5c:	8e050513          	addi	a0,a0,-1824 # 6538 <malloc+0x554>
     c60:	00005097          	auipc	ra,0x5
     c64:	2cc080e7          	jalr	716(ra) # 5f2c <printf>
            exit(1);
     c68:	4505                	li	a0,1
     c6a:	00005097          	auipc	ra,0x5
     c6e:	f48080e7          	jalr	-184(ra) # 5bb2 <exit>
        printf("%s: error: open big failed!\n", s);
     c72:	85d6                	mv	a1,s5
     c74:	00006517          	auipc	a0,0x6
     c78:	8ec50513          	addi	a0,a0,-1812 # 6560 <malloc+0x57c>
     c7c:	00005097          	auipc	ra,0x5
     c80:	2b0080e7          	jalr	688(ra) # 5f2c <printf>
        exit(1);
     c84:	4505                	li	a0,1
     c86:	00005097          	auipc	ra,0x5
     c8a:	f2c080e7          	jalr	-212(ra) # 5bb2 <exit>
            if (n == MAXFILE - 1) {
     c8e:	10b00793          	li	a5,267
     c92:	02f48a63          	beq	s1,a5,cc6 <writebig+0x13e>
    close(fd);
     c96:	854e                	mv	a0,s3
     c98:	00005097          	auipc	ra,0x5
     c9c:	f42080e7          	jalr	-190(ra) # 5bda <close>
    if (unlink("big") < 0) {
     ca0:	00006517          	auipc	a0,0x6
     ca4:	87050513          	addi	a0,a0,-1936 # 6510 <malloc+0x52c>
     ca8:	00005097          	auipc	ra,0x5
     cac:	f5a080e7          	jalr	-166(ra) # 5c02 <unlink>
     cb0:	06054963          	bltz	a0,d22 <writebig+0x19a>
}
     cb4:	70e2                	ld	ra,56(sp)
     cb6:	7442                	ld	s0,48(sp)
     cb8:	74a2                	ld	s1,40(sp)
     cba:	7902                	ld	s2,32(sp)
     cbc:	69e2                	ld	s3,24(sp)
     cbe:	6a42                	ld	s4,16(sp)
     cc0:	6aa2                	ld	s5,8(sp)
     cc2:	6121                	addi	sp,sp,64
     cc4:	8082                	ret
                printf("%s: read only %d blocks from big", s, n);
     cc6:	10b00613          	li	a2,267
     cca:	85d6                	mv	a1,s5
     ccc:	00006517          	auipc	a0,0x6
     cd0:	8b450513          	addi	a0,a0,-1868 # 6580 <malloc+0x59c>
     cd4:	00005097          	auipc	ra,0x5
     cd8:	258080e7          	jalr	600(ra) # 5f2c <printf>
                exit(1);
     cdc:	4505                	li	a0,1
     cde:	00005097          	auipc	ra,0x5
     ce2:	ed4080e7          	jalr	-300(ra) # 5bb2 <exit>
            printf("%s: read failed %d\n", s, i);
     ce6:	862a                	mv	a2,a0
     ce8:	85d6                	mv	a1,s5
     cea:	00006517          	auipc	a0,0x6
     cee:	8be50513          	addi	a0,a0,-1858 # 65a8 <malloc+0x5c4>
     cf2:	00005097          	auipc	ra,0x5
     cf6:	23a080e7          	jalr	570(ra) # 5f2c <printf>
            exit(1);
     cfa:	4505                	li	a0,1
     cfc:	00005097          	auipc	ra,0x5
     d00:	eb6080e7          	jalr	-330(ra) # 5bb2 <exit>
            printf("%s: read content of block %d is %d\n", s, n, ((int *)buf)[0]);
     d04:	8626                	mv	a2,s1
     d06:	85d6                	mv	a1,s5
     d08:	00006517          	auipc	a0,0x6
     d0c:	8b850513          	addi	a0,a0,-1864 # 65c0 <malloc+0x5dc>
     d10:	00005097          	auipc	ra,0x5
     d14:	21c080e7          	jalr	540(ra) # 5f2c <printf>
            exit(1);
     d18:	4505                	li	a0,1
     d1a:	00005097          	auipc	ra,0x5
     d1e:	e98080e7          	jalr	-360(ra) # 5bb2 <exit>
        printf("%s: unlink big failed\n", s);
     d22:	85d6                	mv	a1,s5
     d24:	00006517          	auipc	a0,0x6
     d28:	8c450513          	addi	a0,a0,-1852 # 65e8 <malloc+0x604>
     d2c:	00005097          	auipc	ra,0x5
     d30:	200080e7          	jalr	512(ra) # 5f2c <printf>
        exit(1);
     d34:	4505                	li	a0,1
     d36:	00005097          	auipc	ra,0x5
     d3a:	e7c080e7          	jalr	-388(ra) # 5bb2 <exit>

0000000000000d3e <unlinkread>:
{
     d3e:	7179                	addi	sp,sp,-48
     d40:	f406                	sd	ra,40(sp)
     d42:	f022                	sd	s0,32(sp)
     d44:	ec26                	sd	s1,24(sp)
     d46:	e84a                	sd	s2,16(sp)
     d48:	e44e                	sd	s3,8(sp)
     d4a:	1800                	addi	s0,sp,48
     d4c:	89aa                	mv	s3,a0
    fd = open("unlinkread", O_CREATE | O_RDWR);
     d4e:	20200593          	li	a1,514
     d52:	00006517          	auipc	a0,0x6
     d56:	8ae50513          	addi	a0,a0,-1874 # 6600 <malloc+0x61c>
     d5a:	00005097          	auipc	ra,0x5
     d5e:	e98080e7          	jalr	-360(ra) # 5bf2 <open>
    if (fd < 0) {
     d62:	0e054563          	bltz	a0,e4c <unlinkread+0x10e>
     d66:	84aa                	mv	s1,a0
    write(fd, "hello", SZ);
     d68:	4615                	li	a2,5
     d6a:	00006597          	auipc	a1,0x6
     d6e:	8c658593          	addi	a1,a1,-1850 # 6630 <malloc+0x64c>
     d72:	00005097          	auipc	ra,0x5
     d76:	e60080e7          	jalr	-416(ra) # 5bd2 <write>
    close(fd);
     d7a:	8526                	mv	a0,s1
     d7c:	00005097          	auipc	ra,0x5
     d80:	e5e080e7          	jalr	-418(ra) # 5bda <close>
    fd = open("unlinkread", O_RDWR);
     d84:	4589                	li	a1,2
     d86:	00006517          	auipc	a0,0x6
     d8a:	87a50513          	addi	a0,a0,-1926 # 6600 <malloc+0x61c>
     d8e:	00005097          	auipc	ra,0x5
     d92:	e64080e7          	jalr	-412(ra) # 5bf2 <open>
     d96:	84aa                	mv	s1,a0
    if (fd < 0) {
     d98:	0c054863          	bltz	a0,e68 <unlinkread+0x12a>
    if (unlink("unlinkread") != 0) {
     d9c:	00006517          	auipc	a0,0x6
     da0:	86450513          	addi	a0,a0,-1948 # 6600 <malloc+0x61c>
     da4:	00005097          	auipc	ra,0x5
     da8:	e5e080e7          	jalr	-418(ra) # 5c02 <unlink>
     dac:	ed61                	bnez	a0,e84 <unlinkread+0x146>
    fd1 = open("unlinkread", O_CREATE | O_RDWR);
     dae:	20200593          	li	a1,514
     db2:	00006517          	auipc	a0,0x6
     db6:	84e50513          	addi	a0,a0,-1970 # 6600 <malloc+0x61c>
     dba:	00005097          	auipc	ra,0x5
     dbe:	e38080e7          	jalr	-456(ra) # 5bf2 <open>
     dc2:	892a                	mv	s2,a0
    write(fd1, "yyy", 3);
     dc4:	460d                	li	a2,3
     dc6:	00006597          	auipc	a1,0x6
     dca:	8b258593          	addi	a1,a1,-1870 # 6678 <malloc+0x694>
     dce:	00005097          	auipc	ra,0x5
     dd2:	e04080e7          	jalr	-508(ra) # 5bd2 <write>
    close(fd1);
     dd6:	854a                	mv	a0,s2
     dd8:	00005097          	auipc	ra,0x5
     ddc:	e02080e7          	jalr	-510(ra) # 5bda <close>
    if (read(fd, buf, sizeof(buf)) != SZ) {
     de0:	660d                	lui	a2,0x3
     de2:	0000c597          	auipc	a1,0xc
     de6:	e9658593          	addi	a1,a1,-362 # cc78 <buf>
     dea:	8526                	mv	a0,s1
     dec:	00005097          	auipc	ra,0x5
     df0:	dde080e7          	jalr	-546(ra) # 5bca <read>
     df4:	4795                	li	a5,5
     df6:	0af51563          	bne	a0,a5,ea0 <unlinkread+0x162>
    if (buf[0] != 'h') {
     dfa:	0000c717          	auipc	a4,0xc
     dfe:	e7e74703          	lbu	a4,-386(a4) # cc78 <buf>
     e02:	06800793          	li	a5,104
     e06:	0af71b63          	bne	a4,a5,ebc <unlinkread+0x17e>
    if (write(fd, buf, 10) != 10) {
     e0a:	4629                	li	a2,10
     e0c:	0000c597          	auipc	a1,0xc
     e10:	e6c58593          	addi	a1,a1,-404 # cc78 <buf>
     e14:	8526                	mv	a0,s1
     e16:	00005097          	auipc	ra,0x5
     e1a:	dbc080e7          	jalr	-580(ra) # 5bd2 <write>
     e1e:	47a9                	li	a5,10
     e20:	0af51c63          	bne	a0,a5,ed8 <unlinkread+0x19a>
    close(fd);
     e24:	8526                	mv	a0,s1
     e26:	00005097          	auipc	ra,0x5
     e2a:	db4080e7          	jalr	-588(ra) # 5bda <close>
    unlink("unlinkread");
     e2e:	00005517          	auipc	a0,0x5
     e32:	7d250513          	addi	a0,a0,2002 # 6600 <malloc+0x61c>
     e36:	00005097          	auipc	ra,0x5
     e3a:	dcc080e7          	jalr	-564(ra) # 5c02 <unlink>
}
     e3e:	70a2                	ld	ra,40(sp)
     e40:	7402                	ld	s0,32(sp)
     e42:	64e2                	ld	s1,24(sp)
     e44:	6942                	ld	s2,16(sp)
     e46:	69a2                	ld	s3,8(sp)
     e48:	6145                	addi	sp,sp,48
     e4a:	8082                	ret
        printf("%s: create unlinkread failed\n", s);
     e4c:	85ce                	mv	a1,s3
     e4e:	00005517          	auipc	a0,0x5
     e52:	7c250513          	addi	a0,a0,1986 # 6610 <malloc+0x62c>
     e56:	00005097          	auipc	ra,0x5
     e5a:	0d6080e7          	jalr	214(ra) # 5f2c <printf>
        exit(1);
     e5e:	4505                	li	a0,1
     e60:	00005097          	auipc	ra,0x5
     e64:	d52080e7          	jalr	-686(ra) # 5bb2 <exit>
        printf("%s: open unlinkread failed\n", s);
     e68:	85ce                	mv	a1,s3
     e6a:	00005517          	auipc	a0,0x5
     e6e:	7ce50513          	addi	a0,a0,1998 # 6638 <malloc+0x654>
     e72:	00005097          	auipc	ra,0x5
     e76:	0ba080e7          	jalr	186(ra) # 5f2c <printf>
        exit(1);
     e7a:	4505                	li	a0,1
     e7c:	00005097          	auipc	ra,0x5
     e80:	d36080e7          	jalr	-714(ra) # 5bb2 <exit>
        printf("%s: unlink unlinkread failed\n", s);
     e84:	85ce                	mv	a1,s3
     e86:	00005517          	auipc	a0,0x5
     e8a:	7d250513          	addi	a0,a0,2002 # 6658 <malloc+0x674>
     e8e:	00005097          	auipc	ra,0x5
     e92:	09e080e7          	jalr	158(ra) # 5f2c <printf>
        exit(1);
     e96:	4505                	li	a0,1
     e98:	00005097          	auipc	ra,0x5
     e9c:	d1a080e7          	jalr	-742(ra) # 5bb2 <exit>
        printf("%s: unlinkread read failed", s);
     ea0:	85ce                	mv	a1,s3
     ea2:	00005517          	auipc	a0,0x5
     ea6:	7de50513          	addi	a0,a0,2014 # 6680 <malloc+0x69c>
     eaa:	00005097          	auipc	ra,0x5
     eae:	082080e7          	jalr	130(ra) # 5f2c <printf>
        exit(1);
     eb2:	4505                	li	a0,1
     eb4:	00005097          	auipc	ra,0x5
     eb8:	cfe080e7          	jalr	-770(ra) # 5bb2 <exit>
        printf("%s: unlinkread wrong data\n", s);
     ebc:	85ce                	mv	a1,s3
     ebe:	00005517          	auipc	a0,0x5
     ec2:	7e250513          	addi	a0,a0,2018 # 66a0 <malloc+0x6bc>
     ec6:	00005097          	auipc	ra,0x5
     eca:	066080e7          	jalr	102(ra) # 5f2c <printf>
        exit(1);
     ece:	4505                	li	a0,1
     ed0:	00005097          	auipc	ra,0x5
     ed4:	ce2080e7          	jalr	-798(ra) # 5bb2 <exit>
        printf("%s: unlinkread write failed\n", s);
     ed8:	85ce                	mv	a1,s3
     eda:	00005517          	auipc	a0,0x5
     ede:	7e650513          	addi	a0,a0,2022 # 66c0 <malloc+0x6dc>
     ee2:	00005097          	auipc	ra,0x5
     ee6:	04a080e7          	jalr	74(ra) # 5f2c <printf>
        exit(1);
     eea:	4505                	li	a0,1
     eec:	00005097          	auipc	ra,0x5
     ef0:	cc6080e7          	jalr	-826(ra) # 5bb2 <exit>

0000000000000ef4 <linktest>:
{
     ef4:	1101                	addi	sp,sp,-32
     ef6:	ec06                	sd	ra,24(sp)
     ef8:	e822                	sd	s0,16(sp)
     efa:	e426                	sd	s1,8(sp)
     efc:	e04a                	sd	s2,0(sp)
     efe:	1000                	addi	s0,sp,32
     f00:	892a                	mv	s2,a0
    unlink("lf1");
     f02:	00005517          	auipc	a0,0x5
     f06:	7de50513          	addi	a0,a0,2014 # 66e0 <malloc+0x6fc>
     f0a:	00005097          	auipc	ra,0x5
     f0e:	cf8080e7          	jalr	-776(ra) # 5c02 <unlink>
    unlink("lf2");
     f12:	00005517          	auipc	a0,0x5
     f16:	7d650513          	addi	a0,a0,2006 # 66e8 <malloc+0x704>
     f1a:	00005097          	auipc	ra,0x5
     f1e:	ce8080e7          	jalr	-792(ra) # 5c02 <unlink>
    fd = open("lf1", O_CREATE | O_RDWR);
     f22:	20200593          	li	a1,514
     f26:	00005517          	auipc	a0,0x5
     f2a:	7ba50513          	addi	a0,a0,1978 # 66e0 <malloc+0x6fc>
     f2e:	00005097          	auipc	ra,0x5
     f32:	cc4080e7          	jalr	-828(ra) # 5bf2 <open>
    if (fd < 0) {
     f36:	10054763          	bltz	a0,1044 <linktest+0x150>
     f3a:	84aa                	mv	s1,a0
    if (write(fd, "hello", SZ) != SZ) {
     f3c:	4615                	li	a2,5
     f3e:	00005597          	auipc	a1,0x5
     f42:	6f258593          	addi	a1,a1,1778 # 6630 <malloc+0x64c>
     f46:	00005097          	auipc	ra,0x5
     f4a:	c8c080e7          	jalr	-884(ra) # 5bd2 <write>
     f4e:	4795                	li	a5,5
     f50:	10f51863          	bne	a0,a5,1060 <linktest+0x16c>
    close(fd);
     f54:	8526                	mv	a0,s1
     f56:	00005097          	auipc	ra,0x5
     f5a:	c84080e7          	jalr	-892(ra) # 5bda <close>
    if (link("lf1", "lf2") < 0) {
     f5e:	00005597          	auipc	a1,0x5
     f62:	78a58593          	addi	a1,a1,1930 # 66e8 <malloc+0x704>
     f66:	00005517          	auipc	a0,0x5
     f6a:	77a50513          	addi	a0,a0,1914 # 66e0 <malloc+0x6fc>
     f6e:	00005097          	auipc	ra,0x5
     f72:	ca4080e7          	jalr	-860(ra) # 5c12 <link>
     f76:	10054363          	bltz	a0,107c <linktest+0x188>
    unlink("lf1");
     f7a:	00005517          	auipc	a0,0x5
     f7e:	76650513          	addi	a0,a0,1894 # 66e0 <malloc+0x6fc>
     f82:	00005097          	auipc	ra,0x5
     f86:	c80080e7          	jalr	-896(ra) # 5c02 <unlink>
    if (open("lf1", 0) >= 0) {
     f8a:	4581                	li	a1,0
     f8c:	00005517          	auipc	a0,0x5
     f90:	75450513          	addi	a0,a0,1876 # 66e0 <malloc+0x6fc>
     f94:	00005097          	auipc	ra,0x5
     f98:	c5e080e7          	jalr	-930(ra) # 5bf2 <open>
     f9c:	0e055e63          	bgez	a0,1098 <linktest+0x1a4>
    fd = open("lf2", 0);
     fa0:	4581                	li	a1,0
     fa2:	00005517          	auipc	a0,0x5
     fa6:	74650513          	addi	a0,a0,1862 # 66e8 <malloc+0x704>
     faa:	00005097          	auipc	ra,0x5
     fae:	c48080e7          	jalr	-952(ra) # 5bf2 <open>
     fb2:	84aa                	mv	s1,a0
    if (fd < 0) {
     fb4:	10054063          	bltz	a0,10b4 <linktest+0x1c0>
    if (read(fd, buf, sizeof(buf)) != SZ) {
     fb8:	660d                	lui	a2,0x3
     fba:	0000c597          	auipc	a1,0xc
     fbe:	cbe58593          	addi	a1,a1,-834 # cc78 <buf>
     fc2:	00005097          	auipc	ra,0x5
     fc6:	c08080e7          	jalr	-1016(ra) # 5bca <read>
     fca:	4795                	li	a5,5
     fcc:	10f51263          	bne	a0,a5,10d0 <linktest+0x1dc>
    close(fd);
     fd0:	8526                	mv	a0,s1
     fd2:	00005097          	auipc	ra,0x5
     fd6:	c08080e7          	jalr	-1016(ra) # 5bda <close>
    if (link("lf2", "lf2") >= 0) {
     fda:	00005597          	auipc	a1,0x5
     fde:	70e58593          	addi	a1,a1,1806 # 66e8 <malloc+0x704>
     fe2:	852e                	mv	a0,a1
     fe4:	00005097          	auipc	ra,0x5
     fe8:	c2e080e7          	jalr	-978(ra) # 5c12 <link>
     fec:	10055063          	bgez	a0,10ec <linktest+0x1f8>
    unlink("lf2");
     ff0:	00005517          	auipc	a0,0x5
     ff4:	6f850513          	addi	a0,a0,1784 # 66e8 <malloc+0x704>
     ff8:	00005097          	auipc	ra,0x5
     ffc:	c0a080e7          	jalr	-1014(ra) # 5c02 <unlink>
    if (link("lf2", "lf1") >= 0) {
    1000:	00005597          	auipc	a1,0x5
    1004:	6e058593          	addi	a1,a1,1760 # 66e0 <malloc+0x6fc>
    1008:	00005517          	auipc	a0,0x5
    100c:	6e050513          	addi	a0,a0,1760 # 66e8 <malloc+0x704>
    1010:	00005097          	auipc	ra,0x5
    1014:	c02080e7          	jalr	-1022(ra) # 5c12 <link>
    1018:	0e055863          	bgez	a0,1108 <linktest+0x214>
    if (link(".", "lf1") >= 0) {
    101c:	00005597          	auipc	a1,0x5
    1020:	6c458593          	addi	a1,a1,1732 # 66e0 <malloc+0x6fc>
    1024:	00005517          	auipc	a0,0x5
    1028:	7cc50513          	addi	a0,a0,1996 # 67f0 <malloc+0x80c>
    102c:	00005097          	auipc	ra,0x5
    1030:	be6080e7          	jalr	-1050(ra) # 5c12 <link>
    1034:	0e055863          	bgez	a0,1124 <linktest+0x230>
}
    1038:	60e2                	ld	ra,24(sp)
    103a:	6442                	ld	s0,16(sp)
    103c:	64a2                	ld	s1,8(sp)
    103e:	6902                	ld	s2,0(sp)
    1040:	6105                	addi	sp,sp,32
    1042:	8082                	ret
        printf("%s: create lf1 failed\n", s);
    1044:	85ca                	mv	a1,s2
    1046:	00005517          	auipc	a0,0x5
    104a:	6aa50513          	addi	a0,a0,1706 # 66f0 <malloc+0x70c>
    104e:	00005097          	auipc	ra,0x5
    1052:	ede080e7          	jalr	-290(ra) # 5f2c <printf>
        exit(1);
    1056:	4505                	li	a0,1
    1058:	00005097          	auipc	ra,0x5
    105c:	b5a080e7          	jalr	-1190(ra) # 5bb2 <exit>
        printf("%s: write lf1 failed\n", s);
    1060:	85ca                	mv	a1,s2
    1062:	00005517          	auipc	a0,0x5
    1066:	6a650513          	addi	a0,a0,1702 # 6708 <malloc+0x724>
    106a:	00005097          	auipc	ra,0x5
    106e:	ec2080e7          	jalr	-318(ra) # 5f2c <printf>
        exit(1);
    1072:	4505                	li	a0,1
    1074:	00005097          	auipc	ra,0x5
    1078:	b3e080e7          	jalr	-1218(ra) # 5bb2 <exit>
        printf("%s: link lf1 lf2 failed\n", s);
    107c:	85ca                	mv	a1,s2
    107e:	00005517          	auipc	a0,0x5
    1082:	6a250513          	addi	a0,a0,1698 # 6720 <malloc+0x73c>
    1086:	00005097          	auipc	ra,0x5
    108a:	ea6080e7          	jalr	-346(ra) # 5f2c <printf>
        exit(1);
    108e:	4505                	li	a0,1
    1090:	00005097          	auipc	ra,0x5
    1094:	b22080e7          	jalr	-1246(ra) # 5bb2 <exit>
        printf("%s: unlinked lf1 but it is still there!\n", s);
    1098:	85ca                	mv	a1,s2
    109a:	00005517          	auipc	a0,0x5
    109e:	6a650513          	addi	a0,a0,1702 # 6740 <malloc+0x75c>
    10a2:	00005097          	auipc	ra,0x5
    10a6:	e8a080e7          	jalr	-374(ra) # 5f2c <printf>
        exit(1);
    10aa:	4505                	li	a0,1
    10ac:	00005097          	auipc	ra,0x5
    10b0:	b06080e7          	jalr	-1274(ra) # 5bb2 <exit>
        printf("%s: open lf2 failed\n", s);
    10b4:	85ca                	mv	a1,s2
    10b6:	00005517          	auipc	a0,0x5
    10ba:	6ba50513          	addi	a0,a0,1722 # 6770 <malloc+0x78c>
    10be:	00005097          	auipc	ra,0x5
    10c2:	e6e080e7          	jalr	-402(ra) # 5f2c <printf>
        exit(1);
    10c6:	4505                	li	a0,1
    10c8:	00005097          	auipc	ra,0x5
    10cc:	aea080e7          	jalr	-1302(ra) # 5bb2 <exit>
        printf("%s: read lf2 failed\n", s);
    10d0:	85ca                	mv	a1,s2
    10d2:	00005517          	auipc	a0,0x5
    10d6:	6b650513          	addi	a0,a0,1718 # 6788 <malloc+0x7a4>
    10da:	00005097          	auipc	ra,0x5
    10de:	e52080e7          	jalr	-430(ra) # 5f2c <printf>
        exit(1);
    10e2:	4505                	li	a0,1
    10e4:	00005097          	auipc	ra,0x5
    10e8:	ace080e7          	jalr	-1330(ra) # 5bb2 <exit>
        printf("%s: link lf2 lf2 succeeded! oops\n", s);
    10ec:	85ca                	mv	a1,s2
    10ee:	00005517          	auipc	a0,0x5
    10f2:	6b250513          	addi	a0,a0,1714 # 67a0 <malloc+0x7bc>
    10f6:	00005097          	auipc	ra,0x5
    10fa:	e36080e7          	jalr	-458(ra) # 5f2c <printf>
        exit(1);
    10fe:	4505                	li	a0,1
    1100:	00005097          	auipc	ra,0x5
    1104:	ab2080e7          	jalr	-1358(ra) # 5bb2 <exit>
        printf("%s: link non-existent succeeded! oops\n", s);
    1108:	85ca                	mv	a1,s2
    110a:	00005517          	auipc	a0,0x5
    110e:	6be50513          	addi	a0,a0,1726 # 67c8 <malloc+0x7e4>
    1112:	00005097          	auipc	ra,0x5
    1116:	e1a080e7          	jalr	-486(ra) # 5f2c <printf>
        exit(1);
    111a:	4505                	li	a0,1
    111c:	00005097          	auipc	ra,0x5
    1120:	a96080e7          	jalr	-1386(ra) # 5bb2 <exit>
        printf("%s: link . lf1 succeeded! oops\n", s);
    1124:	85ca                	mv	a1,s2
    1126:	00005517          	auipc	a0,0x5
    112a:	6d250513          	addi	a0,a0,1746 # 67f8 <malloc+0x814>
    112e:	00005097          	auipc	ra,0x5
    1132:	dfe080e7          	jalr	-514(ra) # 5f2c <printf>
        exit(1);
    1136:	4505                	li	a0,1
    1138:	00005097          	auipc	ra,0x5
    113c:	a7a080e7          	jalr	-1414(ra) # 5bb2 <exit>

0000000000001140 <validatetest>:
{
    1140:	7139                	addi	sp,sp,-64
    1142:	fc06                	sd	ra,56(sp)
    1144:	f822                	sd	s0,48(sp)
    1146:	f426                	sd	s1,40(sp)
    1148:	f04a                	sd	s2,32(sp)
    114a:	ec4e                	sd	s3,24(sp)
    114c:	e852                	sd	s4,16(sp)
    114e:	e456                	sd	s5,8(sp)
    1150:	e05a                	sd	s6,0(sp)
    1152:	0080                	addi	s0,sp,64
    1154:	8b2a                	mv	s6,a0
    for (p = 0; p <= (uint)hi; p += PGSIZE) {
    1156:	4481                	li	s1,0
        if (link("nosuchfile", (char *)p) != -1) {
    1158:	00005997          	auipc	s3,0x5
    115c:	6c098993          	addi	s3,s3,1728 # 6818 <malloc+0x834>
    1160:	597d                	li	s2,-1
    for (p = 0; p <= (uint)hi; p += PGSIZE) {
    1162:	6a85                	lui	s5,0x1
    1164:	00114a37          	lui	s4,0x114
        if (link("nosuchfile", (char *)p) != -1) {
    1168:	85a6                	mv	a1,s1
    116a:	854e                	mv	a0,s3
    116c:	00005097          	auipc	ra,0x5
    1170:	aa6080e7          	jalr	-1370(ra) # 5c12 <link>
    1174:	01251f63          	bne	a0,s2,1192 <validatetest+0x52>
    for (p = 0; p <= (uint)hi; p += PGSIZE) {
    1178:	94d6                	add	s1,s1,s5
    117a:	ff4497e3          	bne	s1,s4,1168 <validatetest+0x28>
}
    117e:	70e2                	ld	ra,56(sp)
    1180:	7442                	ld	s0,48(sp)
    1182:	74a2                	ld	s1,40(sp)
    1184:	7902                	ld	s2,32(sp)
    1186:	69e2                	ld	s3,24(sp)
    1188:	6a42                	ld	s4,16(sp)
    118a:	6aa2                	ld	s5,8(sp)
    118c:	6b02                	ld	s6,0(sp)
    118e:	6121                	addi	sp,sp,64
    1190:	8082                	ret
            printf("%s: link should not succeed\n", s);
    1192:	85da                	mv	a1,s6
    1194:	00005517          	auipc	a0,0x5
    1198:	69450513          	addi	a0,a0,1684 # 6828 <malloc+0x844>
    119c:	00005097          	auipc	ra,0x5
    11a0:	d90080e7          	jalr	-624(ra) # 5f2c <printf>
            exit(1);
    11a4:	4505                	li	a0,1
    11a6:	00005097          	auipc	ra,0x5
    11aa:	a0c080e7          	jalr	-1524(ra) # 5bb2 <exit>

00000000000011ae <bigdir>:
{
    11ae:	715d                	addi	sp,sp,-80
    11b0:	e486                	sd	ra,72(sp)
    11b2:	e0a2                	sd	s0,64(sp)
    11b4:	fc26                	sd	s1,56(sp)
    11b6:	f84a                	sd	s2,48(sp)
    11b8:	f44e                	sd	s3,40(sp)
    11ba:	f052                	sd	s4,32(sp)
    11bc:	ec56                	sd	s5,24(sp)
    11be:	e85a                	sd	s6,16(sp)
    11c0:	0880                	addi	s0,sp,80
    11c2:	89aa                	mv	s3,a0
    unlink("bd");
    11c4:	00005517          	auipc	a0,0x5
    11c8:	68450513          	addi	a0,a0,1668 # 6848 <malloc+0x864>
    11cc:	00005097          	auipc	ra,0x5
    11d0:	a36080e7          	jalr	-1482(ra) # 5c02 <unlink>
    fd = open("bd", O_CREATE);
    11d4:	20000593          	li	a1,512
    11d8:	00005517          	auipc	a0,0x5
    11dc:	67050513          	addi	a0,a0,1648 # 6848 <malloc+0x864>
    11e0:	00005097          	auipc	ra,0x5
    11e4:	a12080e7          	jalr	-1518(ra) # 5bf2 <open>
    if (fd < 0) {
    11e8:	0c054963          	bltz	a0,12ba <bigdir+0x10c>
    close(fd);
    11ec:	00005097          	auipc	ra,0x5
    11f0:	9ee080e7          	jalr	-1554(ra) # 5bda <close>
    for (i = 0; i < N; i++) {
    11f4:	4901                	li	s2,0
        name[0] = 'x';
    11f6:	07800a93          	li	s5,120
        if (link("bd", name) != 0) {
    11fa:	00005a17          	auipc	s4,0x5
    11fe:	64ea0a13          	addi	s4,s4,1614 # 6848 <malloc+0x864>
    for (i = 0; i < N; i++) {
    1202:	1f400b13          	li	s6,500
        name[0] = 'x';
    1206:	fb540823          	sb	s5,-80(s0)
        name[1] = '0' + (i / 64);
    120a:	41f9571b          	sraiw	a4,s2,0x1f
    120e:	01a7571b          	srliw	a4,a4,0x1a
    1212:	012707bb          	addw	a5,a4,s2
    1216:	4067d69b          	sraiw	a3,a5,0x6
    121a:	0306869b          	addiw	a3,a3,48
    121e:	fad408a3          	sb	a3,-79(s0)
        name[2] = '0' + (i % 64);
    1222:	03f7f793          	andi	a5,a5,63
    1226:	9f99                	subw	a5,a5,a4
    1228:	0307879b          	addiw	a5,a5,48
    122c:	faf40923          	sb	a5,-78(s0)
        name[3] = '\0';
    1230:	fa0409a3          	sb	zero,-77(s0)
        if (link("bd", name) != 0) {
    1234:	fb040593          	addi	a1,s0,-80
    1238:	8552                	mv	a0,s4
    123a:	00005097          	auipc	ra,0x5
    123e:	9d8080e7          	jalr	-1576(ra) # 5c12 <link>
    1242:	84aa                	mv	s1,a0
    1244:	e949                	bnez	a0,12d6 <bigdir+0x128>
    for (i = 0; i < N; i++) {
    1246:	2905                	addiw	s2,s2,1
    1248:	fb691fe3          	bne	s2,s6,1206 <bigdir+0x58>
    unlink("bd");
    124c:	00005517          	auipc	a0,0x5
    1250:	5fc50513          	addi	a0,a0,1532 # 6848 <malloc+0x864>
    1254:	00005097          	auipc	ra,0x5
    1258:	9ae080e7          	jalr	-1618(ra) # 5c02 <unlink>
        name[0] = 'x';
    125c:	07800913          	li	s2,120
    for (i = 0; i < N; i++) {
    1260:	1f400a13          	li	s4,500
        name[0] = 'x';
    1264:	fb240823          	sb	s2,-80(s0)
        name[1] = '0' + (i / 64);
    1268:	41f4d71b          	sraiw	a4,s1,0x1f
    126c:	01a7571b          	srliw	a4,a4,0x1a
    1270:	009707bb          	addw	a5,a4,s1
    1274:	4067d69b          	sraiw	a3,a5,0x6
    1278:	0306869b          	addiw	a3,a3,48
    127c:	fad408a3          	sb	a3,-79(s0)
        name[2] = '0' + (i % 64);
    1280:	03f7f793          	andi	a5,a5,63
    1284:	9f99                	subw	a5,a5,a4
    1286:	0307879b          	addiw	a5,a5,48
    128a:	faf40923          	sb	a5,-78(s0)
        name[3] = '\0';
    128e:	fa0409a3          	sb	zero,-77(s0)
        if (unlink(name) != 0) {
    1292:	fb040513          	addi	a0,s0,-80
    1296:	00005097          	auipc	ra,0x5
    129a:	96c080e7          	jalr	-1684(ra) # 5c02 <unlink>
    129e:	ed21                	bnez	a0,12f6 <bigdir+0x148>
    for (i = 0; i < N; i++) {
    12a0:	2485                	addiw	s1,s1,1
    12a2:	fd4491e3          	bne	s1,s4,1264 <bigdir+0xb6>
}
    12a6:	60a6                	ld	ra,72(sp)
    12a8:	6406                	ld	s0,64(sp)
    12aa:	74e2                	ld	s1,56(sp)
    12ac:	7942                	ld	s2,48(sp)
    12ae:	79a2                	ld	s3,40(sp)
    12b0:	7a02                	ld	s4,32(sp)
    12b2:	6ae2                	ld	s5,24(sp)
    12b4:	6b42                	ld	s6,16(sp)
    12b6:	6161                	addi	sp,sp,80
    12b8:	8082                	ret
        printf("%s: bigdir create failed\n", s);
    12ba:	85ce                	mv	a1,s3
    12bc:	00005517          	auipc	a0,0x5
    12c0:	59450513          	addi	a0,a0,1428 # 6850 <malloc+0x86c>
    12c4:	00005097          	auipc	ra,0x5
    12c8:	c68080e7          	jalr	-920(ra) # 5f2c <printf>
        exit(1);
    12cc:	4505                	li	a0,1
    12ce:	00005097          	auipc	ra,0x5
    12d2:	8e4080e7          	jalr	-1820(ra) # 5bb2 <exit>
            printf("%s: bigdir link(bd, %s) failed\n", s, name);
    12d6:	fb040613          	addi	a2,s0,-80
    12da:	85ce                	mv	a1,s3
    12dc:	00005517          	auipc	a0,0x5
    12e0:	59450513          	addi	a0,a0,1428 # 6870 <malloc+0x88c>
    12e4:	00005097          	auipc	ra,0x5
    12e8:	c48080e7          	jalr	-952(ra) # 5f2c <printf>
            exit(1);
    12ec:	4505                	li	a0,1
    12ee:	00005097          	auipc	ra,0x5
    12f2:	8c4080e7          	jalr	-1852(ra) # 5bb2 <exit>
            printf("%s: bigdir unlink failed", s);
    12f6:	85ce                	mv	a1,s3
    12f8:	00005517          	auipc	a0,0x5
    12fc:	59850513          	addi	a0,a0,1432 # 6890 <malloc+0x8ac>
    1300:	00005097          	auipc	ra,0x5
    1304:	c2c080e7          	jalr	-980(ra) # 5f2c <printf>
            exit(1);
    1308:	4505                	li	a0,1
    130a:	00005097          	auipc	ra,0x5
    130e:	8a8080e7          	jalr	-1880(ra) # 5bb2 <exit>

0000000000001312 <pgbug>:
{
    1312:	7179                	addi	sp,sp,-48
    1314:	f406                	sd	ra,40(sp)
    1316:	f022                	sd	s0,32(sp)
    1318:	ec26                	sd	s1,24(sp)
    131a:	1800                	addi	s0,sp,48
    argv[0] = 0;
    131c:	fc043c23          	sd	zero,-40(s0)
    exec(big, argv);
    1320:	00008497          	auipc	s1,0x8
    1324:	ce048493          	addi	s1,s1,-800 # 9000 <big>
    1328:	fd840593          	addi	a1,s0,-40
    132c:	6088                	ld	a0,0(s1)
    132e:	00005097          	auipc	ra,0x5
    1332:	8bc080e7          	jalr	-1860(ra) # 5bea <exec>
    pipe(big);
    1336:	6088                	ld	a0,0(s1)
    1338:	00005097          	auipc	ra,0x5
    133c:	88a080e7          	jalr	-1910(ra) # 5bc2 <pipe>
    exit(0);
    1340:	4501                	li	a0,0
    1342:	00005097          	auipc	ra,0x5
    1346:	870080e7          	jalr	-1936(ra) # 5bb2 <exit>

000000000000134a <badarg>:
{
    134a:	7139                	addi	sp,sp,-64
    134c:	fc06                	sd	ra,56(sp)
    134e:	f822                	sd	s0,48(sp)
    1350:	f426                	sd	s1,40(sp)
    1352:	f04a                	sd	s2,32(sp)
    1354:	ec4e                	sd	s3,24(sp)
    1356:	0080                	addi	s0,sp,64
    1358:	64b1                	lui	s1,0xc
    135a:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1de8>
        argv[0] = (char *)0xffffffff;
    135e:	597d                	li	s2,-1
    1360:	02095913          	srli	s2,s2,0x20
        exec("echo", argv);
    1364:	00005997          	auipc	s3,0x5
    1368:	da498993          	addi	s3,s3,-604 # 6108 <malloc+0x124>
        argv[0] = (char *)0xffffffff;
    136c:	fd243023          	sd	s2,-64(s0)
        argv[1] = 0;
    1370:	fc043423          	sd	zero,-56(s0)
        exec("echo", argv);
    1374:	fc040593          	addi	a1,s0,-64
    1378:	854e                	mv	a0,s3
    137a:	00005097          	auipc	ra,0x5
    137e:	870080e7          	jalr	-1936(ra) # 5bea <exec>
    for (int i = 0; i < 50000; i++) {
    1382:	34fd                	addiw	s1,s1,-1
    1384:	f4e5                	bnez	s1,136c <badarg+0x22>
    exit(0);
    1386:	4501                	li	a0,0
    1388:	00005097          	auipc	ra,0x5
    138c:	82a080e7          	jalr	-2006(ra) # 5bb2 <exit>

0000000000001390 <copyinstr2>:
{
    1390:	7155                	addi	sp,sp,-208
    1392:	e586                	sd	ra,200(sp)
    1394:	e1a2                	sd	s0,192(sp)
    1396:	0980                	addi	s0,sp,208
    for (int i = 0; i < MAXPATH; i++)
    1398:	f6840793          	addi	a5,s0,-152
    139c:	fe840693          	addi	a3,s0,-24
        b[i] = 'x';
    13a0:	07800713          	li	a4,120
    13a4:	00e78023          	sb	a4,0(a5)
    for (int i = 0; i < MAXPATH; i++)
    13a8:	0785                	addi	a5,a5,1
    13aa:	fed79de3          	bne	a5,a3,13a4 <copyinstr2+0x14>
    b[MAXPATH] = '\0';
    13ae:	fe040423          	sb	zero,-24(s0)
    int ret = unlink(b);
    13b2:	f6840513          	addi	a0,s0,-152
    13b6:	00005097          	auipc	ra,0x5
    13ba:	84c080e7          	jalr	-1972(ra) # 5c02 <unlink>
    if (ret != -1) {
    13be:	57fd                	li	a5,-1
    13c0:	0ef51063          	bne	a0,a5,14a0 <copyinstr2+0x110>
    int fd = open(b, O_CREATE | O_WRONLY);
    13c4:	20100593          	li	a1,513
    13c8:	f6840513          	addi	a0,s0,-152
    13cc:	00005097          	auipc	ra,0x5
    13d0:	826080e7          	jalr	-2010(ra) # 5bf2 <open>
    if (fd != -1) {
    13d4:	57fd                	li	a5,-1
    13d6:	0ef51563          	bne	a0,a5,14c0 <copyinstr2+0x130>
    ret = link(b, b);
    13da:	f6840593          	addi	a1,s0,-152
    13de:	852e                	mv	a0,a1
    13e0:	00005097          	auipc	ra,0x5
    13e4:	832080e7          	jalr	-1998(ra) # 5c12 <link>
    if (ret != -1) {
    13e8:	57fd                	li	a5,-1
    13ea:	0ef51b63          	bne	a0,a5,14e0 <copyinstr2+0x150>
    char *args[] = {"xx", 0};
    13ee:	00006797          	auipc	a5,0x6
    13f2:	6fa78793          	addi	a5,a5,1786 # 7ae8 <malloc+0x1b04>
    13f6:	f4f43c23          	sd	a5,-168(s0)
    13fa:	f6043023          	sd	zero,-160(s0)
    ret = exec(b, args);
    13fe:	f5840593          	addi	a1,s0,-168
    1402:	f6840513          	addi	a0,s0,-152
    1406:	00004097          	auipc	ra,0x4
    140a:	7e4080e7          	jalr	2020(ra) # 5bea <exec>
    if (ret != -1) {
    140e:	57fd                	li	a5,-1
    1410:	0ef51963          	bne	a0,a5,1502 <copyinstr2+0x172>
    int pid = fork();
    1414:	00004097          	auipc	ra,0x4
    1418:	796080e7          	jalr	1942(ra) # 5baa <fork>
    if (pid < 0) {
    141c:	10054363          	bltz	a0,1522 <copyinstr2+0x192>
    if (pid == 0) {
    1420:	12051463          	bnez	a0,1548 <copyinstr2+0x1b8>
    1424:	00008797          	auipc	a5,0x8
    1428:	13c78793          	addi	a5,a5,316 # 9560 <big.0>
    142c:	00009697          	auipc	a3,0x9
    1430:	13468693          	addi	a3,a3,308 # a560 <big.0+0x1000>
            big[i] = 'x';
    1434:	07800713          	li	a4,120
    1438:	00e78023          	sb	a4,0(a5)
        for (int i = 0; i < PGSIZE; i++)
    143c:	0785                	addi	a5,a5,1
    143e:	fed79de3          	bne	a5,a3,1438 <copyinstr2+0xa8>
        big[PGSIZE] = '\0';
    1442:	00009797          	auipc	a5,0x9
    1446:	10078f23          	sb	zero,286(a5) # a560 <big.0+0x1000>
        char *args2[] = {big, big, big, 0};
    144a:	00007797          	auipc	a5,0x7
    144e:	0de78793          	addi	a5,a5,222 # 8528 <malloc+0x2544>
    1452:	6390                	ld	a2,0(a5)
    1454:	6794                	ld	a3,8(a5)
    1456:	6b98                	ld	a4,16(a5)
    1458:	6f9c                	ld	a5,24(a5)
    145a:	f2c43823          	sd	a2,-208(s0)
    145e:	f2d43c23          	sd	a3,-200(s0)
    1462:	f4e43023          	sd	a4,-192(s0)
    1466:	f4f43423          	sd	a5,-184(s0)
        ret = exec("echo", args2);
    146a:	f3040593          	addi	a1,s0,-208
    146e:	00005517          	auipc	a0,0x5
    1472:	c9a50513          	addi	a0,a0,-870 # 6108 <malloc+0x124>
    1476:	00004097          	auipc	ra,0x4
    147a:	774080e7          	jalr	1908(ra) # 5bea <exec>
        if (ret != -1) {
    147e:	57fd                	li	a5,-1
    1480:	0af50e63          	beq	a0,a5,153c <copyinstr2+0x1ac>
            printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1484:	55fd                	li	a1,-1
    1486:	00005517          	auipc	a0,0x5
    148a:	4b250513          	addi	a0,a0,1202 # 6938 <malloc+0x954>
    148e:	00005097          	auipc	ra,0x5
    1492:	a9e080e7          	jalr	-1378(ra) # 5f2c <printf>
            exit(1);
    1496:	4505                	li	a0,1
    1498:	00004097          	auipc	ra,0x4
    149c:	71a080e7          	jalr	1818(ra) # 5bb2 <exit>
        printf("unlink(%s) returned %d, not -1\n", b, ret);
    14a0:	862a                	mv	a2,a0
    14a2:	f6840593          	addi	a1,s0,-152
    14a6:	00005517          	auipc	a0,0x5
    14aa:	40a50513          	addi	a0,a0,1034 # 68b0 <malloc+0x8cc>
    14ae:	00005097          	auipc	ra,0x5
    14b2:	a7e080e7          	jalr	-1410(ra) # 5f2c <printf>
        exit(1);
    14b6:	4505                	li	a0,1
    14b8:	00004097          	auipc	ra,0x4
    14bc:	6fa080e7          	jalr	1786(ra) # 5bb2 <exit>
        printf("open(%s) returned %d, not -1\n", b, fd);
    14c0:	862a                	mv	a2,a0
    14c2:	f6840593          	addi	a1,s0,-152
    14c6:	00005517          	auipc	a0,0x5
    14ca:	40a50513          	addi	a0,a0,1034 # 68d0 <malloc+0x8ec>
    14ce:	00005097          	auipc	ra,0x5
    14d2:	a5e080e7          	jalr	-1442(ra) # 5f2c <printf>
        exit(1);
    14d6:	4505                	li	a0,1
    14d8:	00004097          	auipc	ra,0x4
    14dc:	6da080e7          	jalr	1754(ra) # 5bb2 <exit>
        printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    14e0:	86aa                	mv	a3,a0
    14e2:	f6840613          	addi	a2,s0,-152
    14e6:	85b2                	mv	a1,a2
    14e8:	00005517          	auipc	a0,0x5
    14ec:	40850513          	addi	a0,a0,1032 # 68f0 <malloc+0x90c>
    14f0:	00005097          	auipc	ra,0x5
    14f4:	a3c080e7          	jalr	-1476(ra) # 5f2c <printf>
        exit(1);
    14f8:	4505                	li	a0,1
    14fa:	00004097          	auipc	ra,0x4
    14fe:	6b8080e7          	jalr	1720(ra) # 5bb2 <exit>
        printf("exec(%s) returned %d, not -1\n", b, fd);
    1502:	567d                	li	a2,-1
    1504:	f6840593          	addi	a1,s0,-152
    1508:	00005517          	auipc	a0,0x5
    150c:	41050513          	addi	a0,a0,1040 # 6918 <malloc+0x934>
    1510:	00005097          	auipc	ra,0x5
    1514:	a1c080e7          	jalr	-1508(ra) # 5f2c <printf>
        exit(1);
    1518:	4505                	li	a0,1
    151a:	00004097          	auipc	ra,0x4
    151e:	698080e7          	jalr	1688(ra) # 5bb2 <exit>
        printf("fork failed\n");
    1522:	00006517          	auipc	a0,0x6
    1526:	87650513          	addi	a0,a0,-1930 # 6d98 <malloc+0xdb4>
    152a:	00005097          	auipc	ra,0x5
    152e:	a02080e7          	jalr	-1534(ra) # 5f2c <printf>
        exit(1);
    1532:	4505                	li	a0,1
    1534:	00004097          	auipc	ra,0x4
    1538:	67e080e7          	jalr	1662(ra) # 5bb2 <exit>
        exit(747); // OK
    153c:	2eb00513          	li	a0,747
    1540:	00004097          	auipc	ra,0x4
    1544:	672080e7          	jalr	1650(ra) # 5bb2 <exit>
    int st = 0;
    1548:	f4042a23          	sw	zero,-172(s0)
    wait(&st);
    154c:	f5440513          	addi	a0,s0,-172
    1550:	00004097          	auipc	ra,0x4
    1554:	66a080e7          	jalr	1642(ra) # 5bba <wait>
    if (st != 747) {
    1558:	f5442703          	lw	a4,-172(s0)
    155c:	2eb00793          	li	a5,747
    1560:	00f71663          	bne	a4,a5,156c <copyinstr2+0x1dc>
}
    1564:	60ae                	ld	ra,200(sp)
    1566:	640e                	ld	s0,192(sp)
    1568:	6169                	addi	sp,sp,208
    156a:	8082                	ret
        printf("exec(echo, BIG) succeeded, should have failed\n");
    156c:	00005517          	auipc	a0,0x5
    1570:	3f450513          	addi	a0,a0,1012 # 6960 <malloc+0x97c>
    1574:	00005097          	auipc	ra,0x5
    1578:	9b8080e7          	jalr	-1608(ra) # 5f2c <printf>
        exit(1);
    157c:	4505                	li	a0,1
    157e:	00004097          	auipc	ra,0x4
    1582:	634080e7          	jalr	1588(ra) # 5bb2 <exit>

0000000000001586 <truncate3>:
{
    1586:	7159                	addi	sp,sp,-112
    1588:	f486                	sd	ra,104(sp)
    158a:	f0a2                	sd	s0,96(sp)
    158c:	eca6                	sd	s1,88(sp)
    158e:	e8ca                	sd	s2,80(sp)
    1590:	e4ce                	sd	s3,72(sp)
    1592:	e0d2                	sd	s4,64(sp)
    1594:	fc56                	sd	s5,56(sp)
    1596:	1880                	addi	s0,sp,112
    1598:	892a                	mv	s2,a0
    close(open("truncfile", O_CREATE | O_TRUNC | O_WRONLY));
    159a:	60100593          	li	a1,1537
    159e:	00005517          	auipc	a0,0x5
    15a2:	bc250513          	addi	a0,a0,-1086 # 6160 <malloc+0x17c>
    15a6:	00004097          	auipc	ra,0x4
    15aa:	64c080e7          	jalr	1612(ra) # 5bf2 <open>
    15ae:	00004097          	auipc	ra,0x4
    15b2:	62c080e7          	jalr	1580(ra) # 5bda <close>
    pid = fork();
    15b6:	00004097          	auipc	ra,0x4
    15ba:	5f4080e7          	jalr	1524(ra) # 5baa <fork>
    if (pid < 0) {
    15be:	08054063          	bltz	a0,163e <truncate3+0xb8>
    if (pid == 0) {
    15c2:	e969                	bnez	a0,1694 <truncate3+0x10e>
    15c4:	06400993          	li	s3,100
            int fd = open("truncfile", O_WRONLY);
    15c8:	00005a17          	auipc	s4,0x5
    15cc:	b98a0a13          	addi	s4,s4,-1128 # 6160 <malloc+0x17c>
            int n = write(fd, "1234567890", 10);
    15d0:	00005a97          	auipc	s5,0x5
    15d4:	3f0a8a93          	addi	s5,s5,1008 # 69c0 <malloc+0x9dc>
            int fd = open("truncfile", O_WRONLY);
    15d8:	4585                	li	a1,1
    15da:	8552                	mv	a0,s4
    15dc:	00004097          	auipc	ra,0x4
    15e0:	616080e7          	jalr	1558(ra) # 5bf2 <open>
    15e4:	84aa                	mv	s1,a0
            if (fd < 0) {
    15e6:	06054a63          	bltz	a0,165a <truncate3+0xd4>
            int n = write(fd, "1234567890", 10);
    15ea:	4629                	li	a2,10
    15ec:	85d6                	mv	a1,s5
    15ee:	00004097          	auipc	ra,0x4
    15f2:	5e4080e7          	jalr	1508(ra) # 5bd2 <write>
            if (n != 10) {
    15f6:	47a9                	li	a5,10
    15f8:	06f51f63          	bne	a0,a5,1676 <truncate3+0xf0>
            close(fd);
    15fc:	8526                	mv	a0,s1
    15fe:	00004097          	auipc	ra,0x4
    1602:	5dc080e7          	jalr	1500(ra) # 5bda <close>
            fd = open("truncfile", O_RDONLY);
    1606:	4581                	li	a1,0
    1608:	8552                	mv	a0,s4
    160a:	00004097          	auipc	ra,0x4
    160e:	5e8080e7          	jalr	1512(ra) # 5bf2 <open>
    1612:	84aa                	mv	s1,a0
            read(fd, buf, sizeof(buf));
    1614:	02000613          	li	a2,32
    1618:	f9840593          	addi	a1,s0,-104
    161c:	00004097          	auipc	ra,0x4
    1620:	5ae080e7          	jalr	1454(ra) # 5bca <read>
            close(fd);
    1624:	8526                	mv	a0,s1
    1626:	00004097          	auipc	ra,0x4
    162a:	5b4080e7          	jalr	1460(ra) # 5bda <close>
        for (int i = 0; i < 100; i++) {
    162e:	39fd                	addiw	s3,s3,-1
    1630:	fa0994e3          	bnez	s3,15d8 <truncate3+0x52>
        exit(0);
    1634:	4501                	li	a0,0
    1636:	00004097          	auipc	ra,0x4
    163a:	57c080e7          	jalr	1404(ra) # 5bb2 <exit>
        printf("%s: fork failed\n", s);
    163e:	85ca                	mv	a1,s2
    1640:	00005517          	auipc	a0,0x5
    1644:	35050513          	addi	a0,a0,848 # 6990 <malloc+0x9ac>
    1648:	00005097          	auipc	ra,0x5
    164c:	8e4080e7          	jalr	-1820(ra) # 5f2c <printf>
        exit(1);
    1650:	4505                	li	a0,1
    1652:	00004097          	auipc	ra,0x4
    1656:	560080e7          	jalr	1376(ra) # 5bb2 <exit>
                printf("%s: open failed\n", s);
    165a:	85ca                	mv	a1,s2
    165c:	00005517          	auipc	a0,0x5
    1660:	34c50513          	addi	a0,a0,844 # 69a8 <malloc+0x9c4>
    1664:	00005097          	auipc	ra,0x5
    1668:	8c8080e7          	jalr	-1848(ra) # 5f2c <printf>
                exit(1);
    166c:	4505                	li	a0,1
    166e:	00004097          	auipc	ra,0x4
    1672:	544080e7          	jalr	1348(ra) # 5bb2 <exit>
                printf("%s: write got %d, expected 10\n", s, n);
    1676:	862a                	mv	a2,a0
    1678:	85ca                	mv	a1,s2
    167a:	00005517          	auipc	a0,0x5
    167e:	35650513          	addi	a0,a0,854 # 69d0 <malloc+0x9ec>
    1682:	00005097          	auipc	ra,0x5
    1686:	8aa080e7          	jalr	-1878(ra) # 5f2c <printf>
                exit(1);
    168a:	4505                	li	a0,1
    168c:	00004097          	auipc	ra,0x4
    1690:	526080e7          	jalr	1318(ra) # 5bb2 <exit>
    1694:	09600993          	li	s3,150
        int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    1698:	00005a17          	auipc	s4,0x5
    169c:	ac8a0a13          	addi	s4,s4,-1336 # 6160 <malloc+0x17c>
        int n = write(fd, "xxx", 3);
    16a0:	00005a97          	auipc	s5,0x5
    16a4:	350a8a93          	addi	s5,s5,848 # 69f0 <malloc+0xa0c>
        int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    16a8:	60100593          	li	a1,1537
    16ac:	8552                	mv	a0,s4
    16ae:	00004097          	auipc	ra,0x4
    16b2:	544080e7          	jalr	1348(ra) # 5bf2 <open>
    16b6:	84aa                	mv	s1,a0
        if (fd < 0) {
    16b8:	04054763          	bltz	a0,1706 <truncate3+0x180>
        int n = write(fd, "xxx", 3);
    16bc:	460d                	li	a2,3
    16be:	85d6                	mv	a1,s5
    16c0:	00004097          	auipc	ra,0x4
    16c4:	512080e7          	jalr	1298(ra) # 5bd2 <write>
        if (n != 3) {
    16c8:	478d                	li	a5,3
    16ca:	04f51c63          	bne	a0,a5,1722 <truncate3+0x19c>
        close(fd);
    16ce:	8526                	mv	a0,s1
    16d0:	00004097          	auipc	ra,0x4
    16d4:	50a080e7          	jalr	1290(ra) # 5bda <close>
    for (int i = 0; i < 150; i++) {
    16d8:	39fd                	addiw	s3,s3,-1
    16da:	fc0997e3          	bnez	s3,16a8 <truncate3+0x122>
    wait(&xstatus);
    16de:	fbc40513          	addi	a0,s0,-68
    16e2:	00004097          	auipc	ra,0x4
    16e6:	4d8080e7          	jalr	1240(ra) # 5bba <wait>
    unlink("truncfile");
    16ea:	00005517          	auipc	a0,0x5
    16ee:	a7650513          	addi	a0,a0,-1418 # 6160 <malloc+0x17c>
    16f2:	00004097          	auipc	ra,0x4
    16f6:	510080e7          	jalr	1296(ra) # 5c02 <unlink>
    exit(xstatus);
    16fa:	fbc42503          	lw	a0,-68(s0)
    16fe:	00004097          	auipc	ra,0x4
    1702:	4b4080e7          	jalr	1204(ra) # 5bb2 <exit>
            printf("%s: open failed\n", s);
    1706:	85ca                	mv	a1,s2
    1708:	00005517          	auipc	a0,0x5
    170c:	2a050513          	addi	a0,a0,672 # 69a8 <malloc+0x9c4>
    1710:	00005097          	auipc	ra,0x5
    1714:	81c080e7          	jalr	-2020(ra) # 5f2c <printf>
            exit(1);
    1718:	4505                	li	a0,1
    171a:	00004097          	auipc	ra,0x4
    171e:	498080e7          	jalr	1176(ra) # 5bb2 <exit>
            printf("%s: write got %d, expected 3\n", s, n);
    1722:	862a                	mv	a2,a0
    1724:	85ca                	mv	a1,s2
    1726:	00005517          	auipc	a0,0x5
    172a:	2d250513          	addi	a0,a0,722 # 69f8 <malloc+0xa14>
    172e:	00004097          	auipc	ra,0x4
    1732:	7fe080e7          	jalr	2046(ra) # 5f2c <printf>
            exit(1);
    1736:	4505                	li	a0,1
    1738:	00004097          	auipc	ra,0x4
    173c:	47a080e7          	jalr	1146(ra) # 5bb2 <exit>

0000000000001740 <exectest>:
{
    1740:	715d                	addi	sp,sp,-80
    1742:	e486                	sd	ra,72(sp)
    1744:	e0a2                	sd	s0,64(sp)
    1746:	fc26                	sd	s1,56(sp)
    1748:	f84a                	sd	s2,48(sp)
    174a:	0880                	addi	s0,sp,80
    174c:	892a                	mv	s2,a0
    char *echoargv[] = {"echo", "OK", 0};
    174e:	00005797          	auipc	a5,0x5
    1752:	9ba78793          	addi	a5,a5,-1606 # 6108 <malloc+0x124>
    1756:	fcf43023          	sd	a5,-64(s0)
    175a:	00005797          	auipc	a5,0x5
    175e:	2be78793          	addi	a5,a5,702 # 6a18 <malloc+0xa34>
    1762:	fcf43423          	sd	a5,-56(s0)
    1766:	fc043823          	sd	zero,-48(s0)
    unlink("echo-ok");
    176a:	00005517          	auipc	a0,0x5
    176e:	2b650513          	addi	a0,a0,694 # 6a20 <malloc+0xa3c>
    1772:	00004097          	auipc	ra,0x4
    1776:	490080e7          	jalr	1168(ra) # 5c02 <unlink>
    pid = fork();
    177a:	00004097          	auipc	ra,0x4
    177e:	430080e7          	jalr	1072(ra) # 5baa <fork>
    if (pid < 0) {
    1782:	04054663          	bltz	a0,17ce <exectest+0x8e>
    1786:	84aa                	mv	s1,a0
    if (pid == 0) {
    1788:	e959                	bnez	a0,181e <exectest+0xde>
        close(1);
    178a:	4505                	li	a0,1
    178c:	00004097          	auipc	ra,0x4
    1790:	44e080e7          	jalr	1102(ra) # 5bda <close>
        fd = open("echo-ok", O_CREATE | O_WRONLY);
    1794:	20100593          	li	a1,513
    1798:	00005517          	auipc	a0,0x5
    179c:	28850513          	addi	a0,a0,648 # 6a20 <malloc+0xa3c>
    17a0:	00004097          	auipc	ra,0x4
    17a4:	452080e7          	jalr	1106(ra) # 5bf2 <open>
        if (fd < 0) {
    17a8:	04054163          	bltz	a0,17ea <exectest+0xaa>
        if (fd != 1) {
    17ac:	4785                	li	a5,1
    17ae:	04f50c63          	beq	a0,a5,1806 <exectest+0xc6>
            printf("%s: wrong fd\n", s);
    17b2:	85ca                	mv	a1,s2
    17b4:	00005517          	auipc	a0,0x5
    17b8:	28c50513          	addi	a0,a0,652 # 6a40 <malloc+0xa5c>
    17bc:	00004097          	auipc	ra,0x4
    17c0:	770080e7          	jalr	1904(ra) # 5f2c <printf>
            exit(1);
    17c4:	4505                	li	a0,1
    17c6:	00004097          	auipc	ra,0x4
    17ca:	3ec080e7          	jalr	1004(ra) # 5bb2 <exit>
        printf("%s: fork failed\n", s);
    17ce:	85ca                	mv	a1,s2
    17d0:	00005517          	auipc	a0,0x5
    17d4:	1c050513          	addi	a0,a0,448 # 6990 <malloc+0x9ac>
    17d8:	00004097          	auipc	ra,0x4
    17dc:	754080e7          	jalr	1876(ra) # 5f2c <printf>
        exit(1);
    17e0:	4505                	li	a0,1
    17e2:	00004097          	auipc	ra,0x4
    17e6:	3d0080e7          	jalr	976(ra) # 5bb2 <exit>
            printf("%s: create failed\n", s);
    17ea:	85ca                	mv	a1,s2
    17ec:	00005517          	auipc	a0,0x5
    17f0:	23c50513          	addi	a0,a0,572 # 6a28 <malloc+0xa44>
    17f4:	00004097          	auipc	ra,0x4
    17f8:	738080e7          	jalr	1848(ra) # 5f2c <printf>
            exit(1);
    17fc:	4505                	li	a0,1
    17fe:	00004097          	auipc	ra,0x4
    1802:	3b4080e7          	jalr	948(ra) # 5bb2 <exit>
        if (exec("echo", echoargv) < 0) {
    1806:	fc040593          	addi	a1,s0,-64
    180a:	00005517          	auipc	a0,0x5
    180e:	8fe50513          	addi	a0,a0,-1794 # 6108 <malloc+0x124>
    1812:	00004097          	auipc	ra,0x4
    1816:	3d8080e7          	jalr	984(ra) # 5bea <exec>
    181a:	02054163          	bltz	a0,183c <exectest+0xfc>
    if (wait(&xstatus) != pid) {
    181e:	fdc40513          	addi	a0,s0,-36
    1822:	00004097          	auipc	ra,0x4
    1826:	398080e7          	jalr	920(ra) # 5bba <wait>
    182a:	02951763          	bne	a0,s1,1858 <exectest+0x118>
    if (xstatus != 0)
    182e:	fdc42503          	lw	a0,-36(s0)
    1832:	cd0d                	beqz	a0,186c <exectest+0x12c>
        exit(xstatus);
    1834:	00004097          	auipc	ra,0x4
    1838:	37e080e7          	jalr	894(ra) # 5bb2 <exit>
            printf("%s: exec echo failed\n", s);
    183c:	85ca                	mv	a1,s2
    183e:	00005517          	auipc	a0,0x5
    1842:	21250513          	addi	a0,a0,530 # 6a50 <malloc+0xa6c>
    1846:	00004097          	auipc	ra,0x4
    184a:	6e6080e7          	jalr	1766(ra) # 5f2c <printf>
            exit(1);
    184e:	4505                	li	a0,1
    1850:	00004097          	auipc	ra,0x4
    1854:	362080e7          	jalr	866(ra) # 5bb2 <exit>
        printf("%s: wait failed!\n", s);
    1858:	85ca                	mv	a1,s2
    185a:	00005517          	auipc	a0,0x5
    185e:	20e50513          	addi	a0,a0,526 # 6a68 <malloc+0xa84>
    1862:	00004097          	auipc	ra,0x4
    1866:	6ca080e7          	jalr	1738(ra) # 5f2c <printf>
    186a:	b7d1                	j	182e <exectest+0xee>
    fd = open("echo-ok", O_RDONLY);
    186c:	4581                	li	a1,0
    186e:	00005517          	auipc	a0,0x5
    1872:	1b250513          	addi	a0,a0,434 # 6a20 <malloc+0xa3c>
    1876:	00004097          	auipc	ra,0x4
    187a:	37c080e7          	jalr	892(ra) # 5bf2 <open>
    if (fd < 0) {
    187e:	02054a63          	bltz	a0,18b2 <exectest+0x172>
    if (read(fd, buf, 2) != 2) {
    1882:	4609                	li	a2,2
    1884:	fb840593          	addi	a1,s0,-72
    1888:	00004097          	auipc	ra,0x4
    188c:	342080e7          	jalr	834(ra) # 5bca <read>
    1890:	4789                	li	a5,2
    1892:	02f50e63          	beq	a0,a5,18ce <exectest+0x18e>
        printf("%s: read failed\n", s);
    1896:	85ca                	mv	a1,s2
    1898:	00005517          	auipc	a0,0x5
    189c:	c4050513          	addi	a0,a0,-960 # 64d8 <malloc+0x4f4>
    18a0:	00004097          	auipc	ra,0x4
    18a4:	68c080e7          	jalr	1676(ra) # 5f2c <printf>
        exit(1);
    18a8:	4505                	li	a0,1
    18aa:	00004097          	auipc	ra,0x4
    18ae:	308080e7          	jalr	776(ra) # 5bb2 <exit>
        printf("%s: open failed\n", s);
    18b2:	85ca                	mv	a1,s2
    18b4:	00005517          	auipc	a0,0x5
    18b8:	0f450513          	addi	a0,a0,244 # 69a8 <malloc+0x9c4>
    18bc:	00004097          	auipc	ra,0x4
    18c0:	670080e7          	jalr	1648(ra) # 5f2c <printf>
        exit(1);
    18c4:	4505                	li	a0,1
    18c6:	00004097          	auipc	ra,0x4
    18ca:	2ec080e7          	jalr	748(ra) # 5bb2 <exit>
    unlink("echo-ok");
    18ce:	00005517          	auipc	a0,0x5
    18d2:	15250513          	addi	a0,a0,338 # 6a20 <malloc+0xa3c>
    18d6:	00004097          	auipc	ra,0x4
    18da:	32c080e7          	jalr	812(ra) # 5c02 <unlink>
    if (buf[0] == 'O' && buf[1] == 'K')
    18de:	fb844703          	lbu	a4,-72(s0)
    18e2:	04f00793          	li	a5,79
    18e6:	00f71863          	bne	a4,a5,18f6 <exectest+0x1b6>
    18ea:	fb944703          	lbu	a4,-71(s0)
    18ee:	04b00793          	li	a5,75
    18f2:	02f70063          	beq	a4,a5,1912 <exectest+0x1d2>
        printf("%s: wrong output\n", s);
    18f6:	85ca                	mv	a1,s2
    18f8:	00005517          	auipc	a0,0x5
    18fc:	18850513          	addi	a0,a0,392 # 6a80 <malloc+0xa9c>
    1900:	00004097          	auipc	ra,0x4
    1904:	62c080e7          	jalr	1580(ra) # 5f2c <printf>
        exit(1);
    1908:	4505                	li	a0,1
    190a:	00004097          	auipc	ra,0x4
    190e:	2a8080e7          	jalr	680(ra) # 5bb2 <exit>
        exit(0);
    1912:	4501                	li	a0,0
    1914:	00004097          	auipc	ra,0x4
    1918:	29e080e7          	jalr	670(ra) # 5bb2 <exit>

000000000000191c <pipe1>:
{
    191c:	711d                	addi	sp,sp,-96
    191e:	ec86                	sd	ra,88(sp)
    1920:	e8a2                	sd	s0,80(sp)
    1922:	e4a6                	sd	s1,72(sp)
    1924:	e0ca                	sd	s2,64(sp)
    1926:	fc4e                	sd	s3,56(sp)
    1928:	f852                	sd	s4,48(sp)
    192a:	f456                	sd	s5,40(sp)
    192c:	f05a                	sd	s6,32(sp)
    192e:	ec5e                	sd	s7,24(sp)
    1930:	1080                	addi	s0,sp,96
    1932:	892a                	mv	s2,a0
    if (pipe(fds) != 0) {
    1934:	fa840513          	addi	a0,s0,-88
    1938:	00004097          	auipc	ra,0x4
    193c:	28a080e7          	jalr	650(ra) # 5bc2 <pipe>
    1940:	e93d                	bnez	a0,19b6 <pipe1+0x9a>
    1942:	84aa                	mv	s1,a0
    pid = fork();
    1944:	00004097          	auipc	ra,0x4
    1948:	266080e7          	jalr	614(ra) # 5baa <fork>
    194c:	8a2a                	mv	s4,a0
    if (pid == 0) {
    194e:	c151                	beqz	a0,19d2 <pipe1+0xb6>
    else if (pid > 0) {
    1950:	16a05d63          	blez	a0,1aca <pipe1+0x1ae>
        close(fds[1]);
    1954:	fac42503          	lw	a0,-84(s0)
    1958:	00004097          	auipc	ra,0x4
    195c:	282080e7          	jalr	642(ra) # 5bda <close>
        total = 0;
    1960:	8a26                	mv	s4,s1
        cc = 1;
    1962:	4985                	li	s3,1
        while ((n = read(fds[0], buf, cc)) > 0) {
    1964:	0000ba97          	auipc	s5,0xb
    1968:	314a8a93          	addi	s5,s5,788 # cc78 <buf>
            if (cc > sizeof(buf))
    196c:	6b0d                	lui	s6,0x3
        while ((n = read(fds[0], buf, cc)) > 0) {
    196e:	864e                	mv	a2,s3
    1970:	85d6                	mv	a1,s5
    1972:	fa842503          	lw	a0,-88(s0)
    1976:	00004097          	auipc	ra,0x4
    197a:	254080e7          	jalr	596(ra) # 5bca <read>
    197e:	10a05163          	blez	a0,1a80 <pipe1+0x164>
            for (i = 0; i < n; i++) {
    1982:	0000b717          	auipc	a4,0xb
    1986:	2f670713          	addi	a4,a4,758 # cc78 <buf>
    198a:	00a4863b          	addw	a2,s1,a0
                if ((buf[i] & 0xff) != (seq++ & 0xff)) {
    198e:	00074683          	lbu	a3,0(a4)
    1992:	0ff4f793          	zext.b	a5,s1
    1996:	2485                	addiw	s1,s1,1
    1998:	0cf69063          	bne	a3,a5,1a58 <pipe1+0x13c>
            for (i = 0; i < n; i++) {
    199c:	0705                	addi	a4,a4,1
    199e:	fec498e3          	bne	s1,a2,198e <pipe1+0x72>
            total += n;
    19a2:	00aa0a3b          	addw	s4,s4,a0
            cc = cc * 2;
    19a6:	0019979b          	slliw	a5,s3,0x1
    19aa:	0007899b          	sext.w	s3,a5
            if (cc > sizeof(buf))
    19ae:	fd3b70e3          	bgeu	s6,s3,196e <pipe1+0x52>
                cc = sizeof(buf);
    19b2:	89da                	mv	s3,s6
    19b4:	bf6d                	j	196e <pipe1+0x52>
        printf("%s: pipe() failed\n", s);
    19b6:	85ca                	mv	a1,s2
    19b8:	00005517          	auipc	a0,0x5
    19bc:	0e050513          	addi	a0,a0,224 # 6a98 <malloc+0xab4>
    19c0:	00004097          	auipc	ra,0x4
    19c4:	56c080e7          	jalr	1388(ra) # 5f2c <printf>
        exit(1);
    19c8:	4505                	li	a0,1
    19ca:	00004097          	auipc	ra,0x4
    19ce:	1e8080e7          	jalr	488(ra) # 5bb2 <exit>
        close(fds[0]);
    19d2:	fa842503          	lw	a0,-88(s0)
    19d6:	00004097          	auipc	ra,0x4
    19da:	204080e7          	jalr	516(ra) # 5bda <close>
        for (n = 0; n < N; n++) {
    19de:	0000bb17          	auipc	s6,0xb
    19e2:	29ab0b13          	addi	s6,s6,666 # cc78 <buf>
    19e6:	416004bb          	negw	s1,s6
    19ea:	0ff4f493          	zext.b	s1,s1
    19ee:	409b0993          	addi	s3,s6,1033
            if (write(fds[1], buf, SZ) != SZ) {
    19f2:	8bda                	mv	s7,s6
        for (n = 0; n < N; n++) {
    19f4:	6a85                	lui	s5,0x1
    19f6:	42da8a93          	addi	s5,s5,1069 # 142d <copyinstr2+0x9d>
{
    19fa:	87da                	mv	a5,s6
                buf[i] = seq++;
    19fc:	0097873b          	addw	a4,a5,s1
    1a00:	00e78023          	sb	a4,0(a5)
            for (i = 0; i < SZ; i++)
    1a04:	0785                	addi	a5,a5,1
    1a06:	fef99be3          	bne	s3,a5,19fc <pipe1+0xe0>
                buf[i] = seq++;
    1a0a:	409a0a1b          	addiw	s4,s4,1033
            if (write(fds[1], buf, SZ) != SZ) {
    1a0e:	40900613          	li	a2,1033
    1a12:	85de                	mv	a1,s7
    1a14:	fac42503          	lw	a0,-84(s0)
    1a18:	00004097          	auipc	ra,0x4
    1a1c:	1ba080e7          	jalr	442(ra) # 5bd2 <write>
    1a20:	40900793          	li	a5,1033
    1a24:	00f51c63          	bne	a0,a5,1a3c <pipe1+0x120>
        for (n = 0; n < N; n++) {
    1a28:	24a5                	addiw	s1,s1,9
    1a2a:	0ff4f493          	zext.b	s1,s1
    1a2e:	fd5a16e3          	bne	s4,s5,19fa <pipe1+0xde>
        exit(0);
    1a32:	4501                	li	a0,0
    1a34:	00004097          	auipc	ra,0x4
    1a38:	17e080e7          	jalr	382(ra) # 5bb2 <exit>
                printf("%s: pipe1 oops 1\n", s);
    1a3c:	85ca                	mv	a1,s2
    1a3e:	00005517          	auipc	a0,0x5
    1a42:	07250513          	addi	a0,a0,114 # 6ab0 <malloc+0xacc>
    1a46:	00004097          	auipc	ra,0x4
    1a4a:	4e6080e7          	jalr	1254(ra) # 5f2c <printf>
                exit(1);
    1a4e:	4505                	li	a0,1
    1a50:	00004097          	auipc	ra,0x4
    1a54:	162080e7          	jalr	354(ra) # 5bb2 <exit>
                    printf("%s: pipe1 oops 2\n", s);
    1a58:	85ca                	mv	a1,s2
    1a5a:	00005517          	auipc	a0,0x5
    1a5e:	06e50513          	addi	a0,a0,110 # 6ac8 <malloc+0xae4>
    1a62:	00004097          	auipc	ra,0x4
    1a66:	4ca080e7          	jalr	1226(ra) # 5f2c <printf>
}
    1a6a:	60e6                	ld	ra,88(sp)
    1a6c:	6446                	ld	s0,80(sp)
    1a6e:	64a6                	ld	s1,72(sp)
    1a70:	6906                	ld	s2,64(sp)
    1a72:	79e2                	ld	s3,56(sp)
    1a74:	7a42                	ld	s4,48(sp)
    1a76:	7aa2                	ld	s5,40(sp)
    1a78:	7b02                	ld	s6,32(sp)
    1a7a:	6be2                	ld	s7,24(sp)
    1a7c:	6125                	addi	sp,sp,96
    1a7e:	8082                	ret
        if (total != N * SZ) {
    1a80:	6785                	lui	a5,0x1
    1a82:	42d78793          	addi	a5,a5,1069 # 142d <copyinstr2+0x9d>
    1a86:	02fa0063          	beq	s4,a5,1aa6 <pipe1+0x18a>
            printf("%s: pipe1 oops 3 total %d\n", total);
    1a8a:	85d2                	mv	a1,s4
    1a8c:	00005517          	auipc	a0,0x5
    1a90:	05450513          	addi	a0,a0,84 # 6ae0 <malloc+0xafc>
    1a94:	00004097          	auipc	ra,0x4
    1a98:	498080e7          	jalr	1176(ra) # 5f2c <printf>
            exit(1);
    1a9c:	4505                	li	a0,1
    1a9e:	00004097          	auipc	ra,0x4
    1aa2:	114080e7          	jalr	276(ra) # 5bb2 <exit>
        close(fds[0]);
    1aa6:	fa842503          	lw	a0,-88(s0)
    1aaa:	00004097          	auipc	ra,0x4
    1aae:	130080e7          	jalr	304(ra) # 5bda <close>
        wait(&xstatus);
    1ab2:	fa440513          	addi	a0,s0,-92
    1ab6:	00004097          	auipc	ra,0x4
    1aba:	104080e7          	jalr	260(ra) # 5bba <wait>
        exit(xstatus);
    1abe:	fa442503          	lw	a0,-92(s0)
    1ac2:	00004097          	auipc	ra,0x4
    1ac6:	0f0080e7          	jalr	240(ra) # 5bb2 <exit>
        printf("%s: fork() failed\n", s);
    1aca:	85ca                	mv	a1,s2
    1acc:	00005517          	auipc	a0,0x5
    1ad0:	03450513          	addi	a0,a0,52 # 6b00 <malloc+0xb1c>
    1ad4:	00004097          	auipc	ra,0x4
    1ad8:	458080e7          	jalr	1112(ra) # 5f2c <printf>
        exit(1);
    1adc:	4505                	li	a0,1
    1ade:	00004097          	auipc	ra,0x4
    1ae2:	0d4080e7          	jalr	212(ra) # 5bb2 <exit>

0000000000001ae6 <exitwait>:
{
    1ae6:	7139                	addi	sp,sp,-64
    1ae8:	fc06                	sd	ra,56(sp)
    1aea:	f822                	sd	s0,48(sp)
    1aec:	f426                	sd	s1,40(sp)
    1aee:	f04a                	sd	s2,32(sp)
    1af0:	ec4e                	sd	s3,24(sp)
    1af2:	e852                	sd	s4,16(sp)
    1af4:	0080                	addi	s0,sp,64
    1af6:	8a2a                	mv	s4,a0
    for (i = 0; i < 100; i++) {
    1af8:	4901                	li	s2,0
    1afa:	06400993          	li	s3,100
        pid = fork();
    1afe:	00004097          	auipc	ra,0x4
    1b02:	0ac080e7          	jalr	172(ra) # 5baa <fork>
    1b06:	84aa                	mv	s1,a0
        if (pid < 0) {
    1b08:	02054a63          	bltz	a0,1b3c <exitwait+0x56>
        if (pid) {
    1b0c:	c151                	beqz	a0,1b90 <exitwait+0xaa>
            if (wait(&xstate) != pid) {
    1b0e:	fcc40513          	addi	a0,s0,-52
    1b12:	00004097          	auipc	ra,0x4
    1b16:	0a8080e7          	jalr	168(ra) # 5bba <wait>
    1b1a:	02951f63          	bne	a0,s1,1b58 <exitwait+0x72>
            if (i != xstate) {
    1b1e:	fcc42783          	lw	a5,-52(s0)
    1b22:	05279963          	bne	a5,s2,1b74 <exitwait+0x8e>
    for (i = 0; i < 100; i++) {
    1b26:	2905                	addiw	s2,s2,1
    1b28:	fd391be3          	bne	s2,s3,1afe <exitwait+0x18>
}
    1b2c:	70e2                	ld	ra,56(sp)
    1b2e:	7442                	ld	s0,48(sp)
    1b30:	74a2                	ld	s1,40(sp)
    1b32:	7902                	ld	s2,32(sp)
    1b34:	69e2                	ld	s3,24(sp)
    1b36:	6a42                	ld	s4,16(sp)
    1b38:	6121                	addi	sp,sp,64
    1b3a:	8082                	ret
            printf("%s: fork failed\n", s);
    1b3c:	85d2                	mv	a1,s4
    1b3e:	00005517          	auipc	a0,0x5
    1b42:	e5250513          	addi	a0,a0,-430 # 6990 <malloc+0x9ac>
    1b46:	00004097          	auipc	ra,0x4
    1b4a:	3e6080e7          	jalr	998(ra) # 5f2c <printf>
            exit(1);
    1b4e:	4505                	li	a0,1
    1b50:	00004097          	auipc	ra,0x4
    1b54:	062080e7          	jalr	98(ra) # 5bb2 <exit>
                printf("%s: wait wrong pid\n", s);
    1b58:	85d2                	mv	a1,s4
    1b5a:	00005517          	auipc	a0,0x5
    1b5e:	fbe50513          	addi	a0,a0,-66 # 6b18 <malloc+0xb34>
    1b62:	00004097          	auipc	ra,0x4
    1b66:	3ca080e7          	jalr	970(ra) # 5f2c <printf>
                exit(1);
    1b6a:	4505                	li	a0,1
    1b6c:	00004097          	auipc	ra,0x4
    1b70:	046080e7          	jalr	70(ra) # 5bb2 <exit>
                printf("%s: wait wrong exit status\n", s);
    1b74:	85d2                	mv	a1,s4
    1b76:	00005517          	auipc	a0,0x5
    1b7a:	fba50513          	addi	a0,a0,-70 # 6b30 <malloc+0xb4c>
    1b7e:	00004097          	auipc	ra,0x4
    1b82:	3ae080e7          	jalr	942(ra) # 5f2c <printf>
                exit(1);
    1b86:	4505                	li	a0,1
    1b88:	00004097          	auipc	ra,0x4
    1b8c:	02a080e7          	jalr	42(ra) # 5bb2 <exit>
            exit(i);
    1b90:	854a                	mv	a0,s2
    1b92:	00004097          	auipc	ra,0x4
    1b96:	020080e7          	jalr	32(ra) # 5bb2 <exit>

0000000000001b9a <twochildren>:
{
    1b9a:	1101                	addi	sp,sp,-32
    1b9c:	ec06                	sd	ra,24(sp)
    1b9e:	e822                	sd	s0,16(sp)
    1ba0:	e426                	sd	s1,8(sp)
    1ba2:	e04a                	sd	s2,0(sp)
    1ba4:	1000                	addi	s0,sp,32
    1ba6:	892a                	mv	s2,a0
    1ba8:	3e800493          	li	s1,1000
        int pid1 = fork();
    1bac:	00004097          	auipc	ra,0x4
    1bb0:	ffe080e7          	jalr	-2(ra) # 5baa <fork>
        if (pid1 < 0) {
    1bb4:	02054c63          	bltz	a0,1bec <twochildren+0x52>
        if (pid1 == 0) {
    1bb8:	c921                	beqz	a0,1c08 <twochildren+0x6e>
            int pid2 = fork();
    1bba:	00004097          	auipc	ra,0x4
    1bbe:	ff0080e7          	jalr	-16(ra) # 5baa <fork>
            if (pid2 < 0) {
    1bc2:	04054763          	bltz	a0,1c10 <twochildren+0x76>
            if (pid2 == 0) {
    1bc6:	c13d                	beqz	a0,1c2c <twochildren+0x92>
                wait(0);
    1bc8:	4501                	li	a0,0
    1bca:	00004097          	auipc	ra,0x4
    1bce:	ff0080e7          	jalr	-16(ra) # 5bba <wait>
                wait(0);
    1bd2:	4501                	li	a0,0
    1bd4:	00004097          	auipc	ra,0x4
    1bd8:	fe6080e7          	jalr	-26(ra) # 5bba <wait>
    for (int i = 0; i < 1000; i++) {
    1bdc:	34fd                	addiw	s1,s1,-1
    1bde:	f4f9                	bnez	s1,1bac <twochildren+0x12>
}
    1be0:	60e2                	ld	ra,24(sp)
    1be2:	6442                	ld	s0,16(sp)
    1be4:	64a2                	ld	s1,8(sp)
    1be6:	6902                	ld	s2,0(sp)
    1be8:	6105                	addi	sp,sp,32
    1bea:	8082                	ret
            printf("%s: fork failed\n", s);
    1bec:	85ca                	mv	a1,s2
    1bee:	00005517          	auipc	a0,0x5
    1bf2:	da250513          	addi	a0,a0,-606 # 6990 <malloc+0x9ac>
    1bf6:	00004097          	auipc	ra,0x4
    1bfa:	336080e7          	jalr	822(ra) # 5f2c <printf>
            exit(1);
    1bfe:	4505                	li	a0,1
    1c00:	00004097          	auipc	ra,0x4
    1c04:	fb2080e7          	jalr	-78(ra) # 5bb2 <exit>
            exit(0);
    1c08:	00004097          	auipc	ra,0x4
    1c0c:	faa080e7          	jalr	-86(ra) # 5bb2 <exit>
                printf("%s: fork failed\n", s);
    1c10:	85ca                	mv	a1,s2
    1c12:	00005517          	auipc	a0,0x5
    1c16:	d7e50513          	addi	a0,a0,-642 # 6990 <malloc+0x9ac>
    1c1a:	00004097          	auipc	ra,0x4
    1c1e:	312080e7          	jalr	786(ra) # 5f2c <printf>
                exit(1);
    1c22:	4505                	li	a0,1
    1c24:	00004097          	auipc	ra,0x4
    1c28:	f8e080e7          	jalr	-114(ra) # 5bb2 <exit>
                exit(0);
    1c2c:	00004097          	auipc	ra,0x4
    1c30:	f86080e7          	jalr	-122(ra) # 5bb2 <exit>

0000000000001c34 <forkfork>:
{
    1c34:	7179                	addi	sp,sp,-48
    1c36:	f406                	sd	ra,40(sp)
    1c38:	f022                	sd	s0,32(sp)
    1c3a:	ec26                	sd	s1,24(sp)
    1c3c:	1800                	addi	s0,sp,48
    1c3e:	84aa                	mv	s1,a0
        int pid = fork();
    1c40:	00004097          	auipc	ra,0x4
    1c44:	f6a080e7          	jalr	-150(ra) # 5baa <fork>
        if (pid < 0) {
    1c48:	04054163          	bltz	a0,1c8a <forkfork+0x56>
        if (pid == 0) {
    1c4c:	cd29                	beqz	a0,1ca6 <forkfork+0x72>
        int pid = fork();
    1c4e:	00004097          	auipc	ra,0x4
    1c52:	f5c080e7          	jalr	-164(ra) # 5baa <fork>
        if (pid < 0) {
    1c56:	02054a63          	bltz	a0,1c8a <forkfork+0x56>
        if (pid == 0) {
    1c5a:	c531                	beqz	a0,1ca6 <forkfork+0x72>
        wait(&xstatus);
    1c5c:	fdc40513          	addi	a0,s0,-36
    1c60:	00004097          	auipc	ra,0x4
    1c64:	f5a080e7          	jalr	-166(ra) # 5bba <wait>
        if (xstatus != 0) {
    1c68:	fdc42783          	lw	a5,-36(s0)
    1c6c:	ebbd                	bnez	a5,1ce2 <forkfork+0xae>
        wait(&xstatus);
    1c6e:	fdc40513          	addi	a0,s0,-36
    1c72:	00004097          	auipc	ra,0x4
    1c76:	f48080e7          	jalr	-184(ra) # 5bba <wait>
        if (xstatus != 0) {
    1c7a:	fdc42783          	lw	a5,-36(s0)
    1c7e:	e3b5                	bnez	a5,1ce2 <forkfork+0xae>
}
    1c80:	70a2                	ld	ra,40(sp)
    1c82:	7402                	ld	s0,32(sp)
    1c84:	64e2                	ld	s1,24(sp)
    1c86:	6145                	addi	sp,sp,48
    1c88:	8082                	ret
            printf("%s: fork failed", s);
    1c8a:	85a6                	mv	a1,s1
    1c8c:	00005517          	auipc	a0,0x5
    1c90:	ec450513          	addi	a0,a0,-316 # 6b50 <malloc+0xb6c>
    1c94:	00004097          	auipc	ra,0x4
    1c98:	298080e7          	jalr	664(ra) # 5f2c <printf>
            exit(1);
    1c9c:	4505                	li	a0,1
    1c9e:	00004097          	auipc	ra,0x4
    1ca2:	f14080e7          	jalr	-236(ra) # 5bb2 <exit>
{
    1ca6:	0c800493          	li	s1,200
                int pid1 = fork();
    1caa:	00004097          	auipc	ra,0x4
    1cae:	f00080e7          	jalr	-256(ra) # 5baa <fork>
                if (pid1 < 0) {
    1cb2:	00054f63          	bltz	a0,1cd0 <forkfork+0x9c>
                if (pid1 == 0) {
    1cb6:	c115                	beqz	a0,1cda <forkfork+0xa6>
                wait(0);
    1cb8:	4501                	li	a0,0
    1cba:	00004097          	auipc	ra,0x4
    1cbe:	f00080e7          	jalr	-256(ra) # 5bba <wait>
            for (int j = 0; j < 200; j++) {
    1cc2:	34fd                	addiw	s1,s1,-1
    1cc4:	f0fd                	bnez	s1,1caa <forkfork+0x76>
            exit(0);
    1cc6:	4501                	li	a0,0
    1cc8:	00004097          	auipc	ra,0x4
    1ccc:	eea080e7          	jalr	-278(ra) # 5bb2 <exit>
                    exit(1);
    1cd0:	4505                	li	a0,1
    1cd2:	00004097          	auipc	ra,0x4
    1cd6:	ee0080e7          	jalr	-288(ra) # 5bb2 <exit>
                    exit(0);
    1cda:	00004097          	auipc	ra,0x4
    1cde:	ed8080e7          	jalr	-296(ra) # 5bb2 <exit>
            printf("%s: fork in child failed", s);
    1ce2:	85a6                	mv	a1,s1
    1ce4:	00005517          	auipc	a0,0x5
    1ce8:	e7c50513          	addi	a0,a0,-388 # 6b60 <malloc+0xb7c>
    1cec:	00004097          	auipc	ra,0x4
    1cf0:	240080e7          	jalr	576(ra) # 5f2c <printf>
            exit(1);
    1cf4:	4505                	li	a0,1
    1cf6:	00004097          	auipc	ra,0x4
    1cfa:	ebc080e7          	jalr	-324(ra) # 5bb2 <exit>

0000000000001cfe <reparent2>:
{
    1cfe:	1101                	addi	sp,sp,-32
    1d00:	ec06                	sd	ra,24(sp)
    1d02:	e822                	sd	s0,16(sp)
    1d04:	e426                	sd	s1,8(sp)
    1d06:	1000                	addi	s0,sp,32
    1d08:	32000493          	li	s1,800
        int pid1 = fork();
    1d0c:	00004097          	auipc	ra,0x4
    1d10:	e9e080e7          	jalr	-354(ra) # 5baa <fork>
        if (pid1 < 0) {
    1d14:	00054f63          	bltz	a0,1d32 <reparent2+0x34>
        if (pid1 == 0) {
    1d18:	c915                	beqz	a0,1d4c <reparent2+0x4e>
        wait(0);
    1d1a:	4501                	li	a0,0
    1d1c:	00004097          	auipc	ra,0x4
    1d20:	e9e080e7          	jalr	-354(ra) # 5bba <wait>
    for (int i = 0; i < 800; i++) {
    1d24:	34fd                	addiw	s1,s1,-1
    1d26:	f0fd                	bnez	s1,1d0c <reparent2+0xe>
    exit(0);
    1d28:	4501                	li	a0,0
    1d2a:	00004097          	auipc	ra,0x4
    1d2e:	e88080e7          	jalr	-376(ra) # 5bb2 <exit>
            printf("fork failed\n");
    1d32:	00005517          	auipc	a0,0x5
    1d36:	06650513          	addi	a0,a0,102 # 6d98 <malloc+0xdb4>
    1d3a:	00004097          	auipc	ra,0x4
    1d3e:	1f2080e7          	jalr	498(ra) # 5f2c <printf>
            exit(1);
    1d42:	4505                	li	a0,1
    1d44:	00004097          	auipc	ra,0x4
    1d48:	e6e080e7          	jalr	-402(ra) # 5bb2 <exit>
            fork();
    1d4c:	00004097          	auipc	ra,0x4
    1d50:	e5e080e7          	jalr	-418(ra) # 5baa <fork>
            fork();
    1d54:	00004097          	auipc	ra,0x4
    1d58:	e56080e7          	jalr	-426(ra) # 5baa <fork>
            exit(0);
    1d5c:	4501                	li	a0,0
    1d5e:	00004097          	auipc	ra,0x4
    1d62:	e54080e7          	jalr	-428(ra) # 5bb2 <exit>

0000000000001d66 <createdelete>:
{
    1d66:	7175                	addi	sp,sp,-144
    1d68:	e506                	sd	ra,136(sp)
    1d6a:	e122                	sd	s0,128(sp)
    1d6c:	fca6                	sd	s1,120(sp)
    1d6e:	f8ca                	sd	s2,112(sp)
    1d70:	f4ce                	sd	s3,104(sp)
    1d72:	f0d2                	sd	s4,96(sp)
    1d74:	ecd6                	sd	s5,88(sp)
    1d76:	e8da                	sd	s6,80(sp)
    1d78:	e4de                	sd	s7,72(sp)
    1d7a:	e0e2                	sd	s8,64(sp)
    1d7c:	fc66                	sd	s9,56(sp)
    1d7e:	0900                	addi	s0,sp,144
    1d80:	8caa                	mv	s9,a0
    for (pi = 0; pi < NCHILD; pi++) {
    1d82:	4901                	li	s2,0
    1d84:	4991                	li	s3,4
        pid = fork();
    1d86:	00004097          	auipc	ra,0x4
    1d8a:	e24080e7          	jalr	-476(ra) # 5baa <fork>
    1d8e:	84aa                	mv	s1,a0
        if (pid < 0) {
    1d90:	02054f63          	bltz	a0,1dce <createdelete+0x68>
        if (pid == 0) {
    1d94:	c939                	beqz	a0,1dea <createdelete+0x84>
    for (pi = 0; pi < NCHILD; pi++) {
    1d96:	2905                	addiw	s2,s2,1
    1d98:	ff3917e3          	bne	s2,s3,1d86 <createdelete+0x20>
    1d9c:	4491                	li	s1,4
        wait(&xstatus);
    1d9e:	f7c40513          	addi	a0,s0,-132
    1da2:	00004097          	auipc	ra,0x4
    1da6:	e18080e7          	jalr	-488(ra) # 5bba <wait>
        if (xstatus != 0)
    1daa:	f7c42903          	lw	s2,-132(s0)
    1dae:	0e091263          	bnez	s2,1e92 <createdelete+0x12c>
    for (pi = 0; pi < NCHILD; pi++) {
    1db2:	34fd                	addiw	s1,s1,-1
    1db4:	f4ed                	bnez	s1,1d9e <createdelete+0x38>
    name[0] = name[1] = name[2] = 0;
    1db6:	f8040123          	sb	zero,-126(s0)
    1dba:	03000993          	li	s3,48
    1dbe:	5a7d                	li	s4,-1
    1dc0:	07000c13          	li	s8,112
            else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1dc4:	4b21                	li	s6,8
            if ((i == 0 || i >= N / 2) && fd < 0) {
    1dc6:	4ba5                	li	s7,9
        for (pi = 0; pi < NCHILD; pi++) {
    1dc8:	07400a93          	li	s5,116
    1dcc:	a29d                	j	1f32 <createdelete+0x1cc>
            printf("fork failed\n", s);
    1dce:	85e6                	mv	a1,s9
    1dd0:	00005517          	auipc	a0,0x5
    1dd4:	fc850513          	addi	a0,a0,-56 # 6d98 <malloc+0xdb4>
    1dd8:	00004097          	auipc	ra,0x4
    1ddc:	154080e7          	jalr	340(ra) # 5f2c <printf>
            exit(1);
    1de0:	4505                	li	a0,1
    1de2:	00004097          	auipc	ra,0x4
    1de6:	dd0080e7          	jalr	-560(ra) # 5bb2 <exit>
            name[0] = 'p' + pi;
    1dea:	0709091b          	addiw	s2,s2,112
    1dee:	f9240023          	sb	s2,-128(s0)
            name[2] = '\0';
    1df2:	f8040123          	sb	zero,-126(s0)
            for (i = 0; i < N; i++) {
    1df6:	4951                	li	s2,20
    1df8:	a015                	j	1e1c <createdelete+0xb6>
                    printf("%s: create failed\n", s);
    1dfa:	85e6                	mv	a1,s9
    1dfc:	00005517          	auipc	a0,0x5
    1e00:	c2c50513          	addi	a0,a0,-980 # 6a28 <malloc+0xa44>
    1e04:	00004097          	auipc	ra,0x4
    1e08:	128080e7          	jalr	296(ra) # 5f2c <printf>
                    exit(1);
    1e0c:	4505                	li	a0,1
    1e0e:	00004097          	auipc	ra,0x4
    1e12:	da4080e7          	jalr	-604(ra) # 5bb2 <exit>
            for (i = 0; i < N; i++) {
    1e16:	2485                	addiw	s1,s1,1
    1e18:	07248863          	beq	s1,s2,1e88 <createdelete+0x122>
                name[1] = '0' + i;
    1e1c:	0304879b          	addiw	a5,s1,48
    1e20:	f8f400a3          	sb	a5,-127(s0)
                fd = open(name, O_CREATE | O_RDWR);
    1e24:	20200593          	li	a1,514
    1e28:	f8040513          	addi	a0,s0,-128
    1e2c:	00004097          	auipc	ra,0x4
    1e30:	dc6080e7          	jalr	-570(ra) # 5bf2 <open>
                if (fd < 0) {
    1e34:	fc0543e3          	bltz	a0,1dfa <createdelete+0x94>
                close(fd);
    1e38:	00004097          	auipc	ra,0x4
    1e3c:	da2080e7          	jalr	-606(ra) # 5bda <close>
                if (i > 0 && (i % 2) == 0) {
    1e40:	fc905be3          	blez	s1,1e16 <createdelete+0xb0>
    1e44:	0014f793          	andi	a5,s1,1
    1e48:	f7f9                	bnez	a5,1e16 <createdelete+0xb0>
                    name[1] = '0' + (i / 2);
    1e4a:	01f4d79b          	srliw	a5,s1,0x1f
    1e4e:	9fa5                	addw	a5,a5,s1
    1e50:	4017d79b          	sraiw	a5,a5,0x1
    1e54:	0307879b          	addiw	a5,a5,48
    1e58:	f8f400a3          	sb	a5,-127(s0)
                    if (unlink(name) < 0) {
    1e5c:	f8040513          	addi	a0,s0,-128
    1e60:	00004097          	auipc	ra,0x4
    1e64:	da2080e7          	jalr	-606(ra) # 5c02 <unlink>
    1e68:	fa0557e3          	bgez	a0,1e16 <createdelete+0xb0>
                        printf("%s: unlink failed\n", s);
    1e6c:	85e6                	mv	a1,s9
    1e6e:	00005517          	auipc	a0,0x5
    1e72:	d1250513          	addi	a0,a0,-750 # 6b80 <malloc+0xb9c>
    1e76:	00004097          	auipc	ra,0x4
    1e7a:	0b6080e7          	jalr	182(ra) # 5f2c <printf>
                        exit(1);
    1e7e:	4505                	li	a0,1
    1e80:	00004097          	auipc	ra,0x4
    1e84:	d32080e7          	jalr	-718(ra) # 5bb2 <exit>
            exit(0);
    1e88:	4501                	li	a0,0
    1e8a:	00004097          	auipc	ra,0x4
    1e8e:	d28080e7          	jalr	-728(ra) # 5bb2 <exit>
            exit(1);
    1e92:	4505                	li	a0,1
    1e94:	00004097          	auipc	ra,0x4
    1e98:	d1e080e7          	jalr	-738(ra) # 5bb2 <exit>
                printf("%s: oops createdelete %s didn't exist\n", s, name);
    1e9c:	f8040613          	addi	a2,s0,-128
    1ea0:	85e6                	mv	a1,s9
    1ea2:	00005517          	auipc	a0,0x5
    1ea6:	cf650513          	addi	a0,a0,-778 # 6b98 <malloc+0xbb4>
    1eaa:	00004097          	auipc	ra,0x4
    1eae:	082080e7          	jalr	130(ra) # 5f2c <printf>
                exit(1);
    1eb2:	4505                	li	a0,1
    1eb4:	00004097          	auipc	ra,0x4
    1eb8:	cfe080e7          	jalr	-770(ra) # 5bb2 <exit>
            else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1ebc:	054b7163          	bgeu	s6,s4,1efe <createdelete+0x198>
            if (fd >= 0)
    1ec0:	02055a63          	bgez	a0,1ef4 <createdelete+0x18e>
        for (pi = 0; pi < NCHILD; pi++) {
    1ec4:	2485                	addiw	s1,s1,1
    1ec6:	0ff4f493          	zext.b	s1,s1
    1eca:	05548c63          	beq	s1,s5,1f22 <createdelete+0x1bc>
            name[0] = 'p' + pi;
    1ece:	f8940023          	sb	s1,-128(s0)
            name[1] = '0' + i;
    1ed2:	f93400a3          	sb	s3,-127(s0)
            fd = open(name, 0);
    1ed6:	4581                	li	a1,0
    1ed8:	f8040513          	addi	a0,s0,-128
    1edc:	00004097          	auipc	ra,0x4
    1ee0:	d16080e7          	jalr	-746(ra) # 5bf2 <open>
            if ((i == 0 || i >= N / 2) && fd < 0) {
    1ee4:	00090463          	beqz	s2,1eec <createdelete+0x186>
    1ee8:	fd2bdae3          	bge	s7,s2,1ebc <createdelete+0x156>
    1eec:	fa0548e3          	bltz	a0,1e9c <createdelete+0x136>
            else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1ef0:	014b7963          	bgeu	s6,s4,1f02 <createdelete+0x19c>
                close(fd);
    1ef4:	00004097          	auipc	ra,0x4
    1ef8:	ce6080e7          	jalr	-794(ra) # 5bda <close>
    1efc:	b7e1                	j	1ec4 <createdelete+0x15e>
            else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1efe:	fc0543e3          	bltz	a0,1ec4 <createdelete+0x15e>
                printf("%s: oops createdelete %s did exist\n", s, name);
    1f02:	f8040613          	addi	a2,s0,-128
    1f06:	85e6                	mv	a1,s9
    1f08:	00005517          	auipc	a0,0x5
    1f0c:	cb850513          	addi	a0,a0,-840 # 6bc0 <malloc+0xbdc>
    1f10:	00004097          	auipc	ra,0x4
    1f14:	01c080e7          	jalr	28(ra) # 5f2c <printf>
                exit(1);
    1f18:	4505                	li	a0,1
    1f1a:	00004097          	auipc	ra,0x4
    1f1e:	c98080e7          	jalr	-872(ra) # 5bb2 <exit>
    for (i = 0; i < N; i++) {
    1f22:	2905                	addiw	s2,s2,1
    1f24:	2a05                	addiw	s4,s4,1
    1f26:	2985                	addiw	s3,s3,1
    1f28:	0ff9f993          	zext.b	s3,s3
    1f2c:	47d1                	li	a5,20
    1f2e:	02f90a63          	beq	s2,a5,1f62 <createdelete+0x1fc>
        for (pi = 0; pi < NCHILD; pi++) {
    1f32:	84e2                	mv	s1,s8
    1f34:	bf69                	j	1ece <createdelete+0x168>
    for (i = 0; i < N; i++) {
    1f36:	2905                	addiw	s2,s2,1
    1f38:	0ff97913          	zext.b	s2,s2
    1f3c:	2985                	addiw	s3,s3,1
    1f3e:	0ff9f993          	zext.b	s3,s3
    1f42:	03490863          	beq	s2,s4,1f72 <createdelete+0x20c>
    name[0] = name[1] = name[2] = 0;
    1f46:	84d6                	mv	s1,s5
            name[0] = 'p' + i;
    1f48:	f9240023          	sb	s2,-128(s0)
            name[1] = '0' + i;
    1f4c:	f93400a3          	sb	s3,-127(s0)
            unlink(name);
    1f50:	f8040513          	addi	a0,s0,-128
    1f54:	00004097          	auipc	ra,0x4
    1f58:	cae080e7          	jalr	-850(ra) # 5c02 <unlink>
        for (pi = 0; pi < NCHILD; pi++) {
    1f5c:	34fd                	addiw	s1,s1,-1
    1f5e:	f4ed                	bnez	s1,1f48 <createdelete+0x1e2>
    1f60:	bfd9                	j	1f36 <createdelete+0x1d0>
    1f62:	03000993          	li	s3,48
    1f66:	07000913          	li	s2,112
    name[0] = name[1] = name[2] = 0;
    1f6a:	4a91                	li	s5,4
    for (i = 0; i < N; i++) {
    1f6c:	08400a13          	li	s4,132
    1f70:	bfd9                	j	1f46 <createdelete+0x1e0>
}
    1f72:	60aa                	ld	ra,136(sp)
    1f74:	640a                	ld	s0,128(sp)
    1f76:	74e6                	ld	s1,120(sp)
    1f78:	7946                	ld	s2,112(sp)
    1f7a:	79a6                	ld	s3,104(sp)
    1f7c:	7a06                	ld	s4,96(sp)
    1f7e:	6ae6                	ld	s5,88(sp)
    1f80:	6b46                	ld	s6,80(sp)
    1f82:	6ba6                	ld	s7,72(sp)
    1f84:	6c06                	ld	s8,64(sp)
    1f86:	7ce2                	ld	s9,56(sp)
    1f88:	6149                	addi	sp,sp,144
    1f8a:	8082                	ret

0000000000001f8c <linkunlink>:
{
    1f8c:	711d                	addi	sp,sp,-96
    1f8e:	ec86                	sd	ra,88(sp)
    1f90:	e8a2                	sd	s0,80(sp)
    1f92:	e4a6                	sd	s1,72(sp)
    1f94:	e0ca                	sd	s2,64(sp)
    1f96:	fc4e                	sd	s3,56(sp)
    1f98:	f852                	sd	s4,48(sp)
    1f9a:	f456                	sd	s5,40(sp)
    1f9c:	f05a                	sd	s6,32(sp)
    1f9e:	ec5e                	sd	s7,24(sp)
    1fa0:	e862                	sd	s8,16(sp)
    1fa2:	e466                	sd	s9,8(sp)
    1fa4:	1080                	addi	s0,sp,96
    1fa6:	84aa                	mv	s1,a0
    unlink("x");
    1fa8:	00004517          	auipc	a0,0x4
    1fac:	1d050513          	addi	a0,a0,464 # 6178 <malloc+0x194>
    1fb0:	00004097          	auipc	ra,0x4
    1fb4:	c52080e7          	jalr	-942(ra) # 5c02 <unlink>
    pid = fork();
    1fb8:	00004097          	auipc	ra,0x4
    1fbc:	bf2080e7          	jalr	-1038(ra) # 5baa <fork>
    if (pid < 0) {
    1fc0:	02054b63          	bltz	a0,1ff6 <linkunlink+0x6a>
    1fc4:	8c2a                	mv	s8,a0
    unsigned int x = (pid ? 1 : 97);
    1fc6:	4c85                	li	s9,1
    1fc8:	e119                	bnez	a0,1fce <linkunlink+0x42>
    1fca:	06100c93          	li	s9,97
    1fce:	06400493          	li	s1,100
        x = x * 1103515245 + 12345;
    1fd2:	41c659b7          	lui	s3,0x41c65
    1fd6:	e6d9899b          	addiw	s3,s3,-403 # 41c64e6d <base+0x41c551f5>
    1fda:	690d                	lui	s2,0x3
    1fdc:	0399091b          	addiw	s2,s2,57 # 3039 <fourteen+0x29>
        if ((x % 3) == 0) {
    1fe0:	4a0d                	li	s4,3
        else if ((x % 3) == 1) {
    1fe2:	4b05                	li	s6,1
            unlink("x");
    1fe4:	00004a97          	auipc	s5,0x4
    1fe8:	194a8a93          	addi	s5,s5,404 # 6178 <malloc+0x194>
            link("cat", "x");
    1fec:	00005b97          	auipc	s7,0x5
    1ff0:	bfcb8b93          	addi	s7,s7,-1028 # 6be8 <malloc+0xc04>
    1ff4:	a825                	j	202c <linkunlink+0xa0>
        printf("%s: fork failed\n", s);
    1ff6:	85a6                	mv	a1,s1
    1ff8:	00005517          	auipc	a0,0x5
    1ffc:	99850513          	addi	a0,a0,-1640 # 6990 <malloc+0x9ac>
    2000:	00004097          	auipc	ra,0x4
    2004:	f2c080e7          	jalr	-212(ra) # 5f2c <printf>
        exit(1);
    2008:	4505                	li	a0,1
    200a:	00004097          	auipc	ra,0x4
    200e:	ba8080e7          	jalr	-1112(ra) # 5bb2 <exit>
            close(open("x", O_RDWR | O_CREATE));
    2012:	20200593          	li	a1,514
    2016:	8556                	mv	a0,s5
    2018:	00004097          	auipc	ra,0x4
    201c:	bda080e7          	jalr	-1062(ra) # 5bf2 <open>
    2020:	00004097          	auipc	ra,0x4
    2024:	bba080e7          	jalr	-1094(ra) # 5bda <close>
    for (i = 0; i < 100; i++) {
    2028:	34fd                	addiw	s1,s1,-1
    202a:	c88d                	beqz	s1,205c <linkunlink+0xd0>
        x = x * 1103515245 + 12345;
    202c:	033c87bb          	mulw	a5,s9,s3
    2030:	012787bb          	addw	a5,a5,s2
    2034:	00078c9b          	sext.w	s9,a5
        if ((x % 3) == 0) {
    2038:	0347f7bb          	remuw	a5,a5,s4
    203c:	dbf9                	beqz	a5,2012 <linkunlink+0x86>
        else if ((x % 3) == 1) {
    203e:	01678863          	beq	a5,s6,204e <linkunlink+0xc2>
            unlink("x");
    2042:	8556                	mv	a0,s5
    2044:	00004097          	auipc	ra,0x4
    2048:	bbe080e7          	jalr	-1090(ra) # 5c02 <unlink>
    204c:	bff1                	j	2028 <linkunlink+0x9c>
            link("cat", "x");
    204e:	85d6                	mv	a1,s5
    2050:	855e                	mv	a0,s7
    2052:	00004097          	auipc	ra,0x4
    2056:	bc0080e7          	jalr	-1088(ra) # 5c12 <link>
    205a:	b7f9                	j	2028 <linkunlink+0x9c>
    if (pid)
    205c:	020c0463          	beqz	s8,2084 <linkunlink+0xf8>
        wait(0);
    2060:	4501                	li	a0,0
    2062:	00004097          	auipc	ra,0x4
    2066:	b58080e7          	jalr	-1192(ra) # 5bba <wait>
}
    206a:	60e6                	ld	ra,88(sp)
    206c:	6446                	ld	s0,80(sp)
    206e:	64a6                	ld	s1,72(sp)
    2070:	6906                	ld	s2,64(sp)
    2072:	79e2                	ld	s3,56(sp)
    2074:	7a42                	ld	s4,48(sp)
    2076:	7aa2                	ld	s5,40(sp)
    2078:	7b02                	ld	s6,32(sp)
    207a:	6be2                	ld	s7,24(sp)
    207c:	6c42                	ld	s8,16(sp)
    207e:	6ca2                	ld	s9,8(sp)
    2080:	6125                	addi	sp,sp,96
    2082:	8082                	ret
        exit(0);
    2084:	4501                	li	a0,0
    2086:	00004097          	auipc	ra,0x4
    208a:	b2c080e7          	jalr	-1236(ra) # 5bb2 <exit>

000000000000208e <forktest>:
{
    208e:	7179                	addi	sp,sp,-48
    2090:	f406                	sd	ra,40(sp)
    2092:	f022                	sd	s0,32(sp)
    2094:	ec26                	sd	s1,24(sp)
    2096:	e84a                	sd	s2,16(sp)
    2098:	e44e                	sd	s3,8(sp)
    209a:	1800                	addi	s0,sp,48
    209c:	89aa                	mv	s3,a0
    for (n = 0; n < N; n++) {
    209e:	4481                	li	s1,0
    20a0:	3e800913          	li	s2,1000
        pid = fork();
    20a4:	00004097          	auipc	ra,0x4
    20a8:	b06080e7          	jalr	-1274(ra) # 5baa <fork>
        if (pid < 0)
    20ac:	02054863          	bltz	a0,20dc <forktest+0x4e>
        if (pid == 0)
    20b0:	c115                	beqz	a0,20d4 <forktest+0x46>
    for (n = 0; n < N; n++) {
    20b2:	2485                	addiw	s1,s1,1
    20b4:	ff2498e3          	bne	s1,s2,20a4 <forktest+0x16>
        printf("%s: fork claimed to work 1000 times!\n", s);
    20b8:	85ce                	mv	a1,s3
    20ba:	00005517          	auipc	a0,0x5
    20be:	b4e50513          	addi	a0,a0,-1202 # 6c08 <malloc+0xc24>
    20c2:	00004097          	auipc	ra,0x4
    20c6:	e6a080e7          	jalr	-406(ra) # 5f2c <printf>
        exit(1);
    20ca:	4505                	li	a0,1
    20cc:	00004097          	auipc	ra,0x4
    20d0:	ae6080e7          	jalr	-1306(ra) # 5bb2 <exit>
            exit(0);
    20d4:	00004097          	auipc	ra,0x4
    20d8:	ade080e7          	jalr	-1314(ra) # 5bb2 <exit>
    if (n == 0) {
    20dc:	cc9d                	beqz	s1,211a <forktest+0x8c>
    if (n == N) {
    20de:	3e800793          	li	a5,1000
    20e2:	fcf48be3          	beq	s1,a5,20b8 <forktest+0x2a>
    for (; n > 0; n--) {
    20e6:	00905b63          	blez	s1,20fc <forktest+0x6e>
        if (wait(0) < 0) {
    20ea:	4501                	li	a0,0
    20ec:	00004097          	auipc	ra,0x4
    20f0:	ace080e7          	jalr	-1330(ra) # 5bba <wait>
    20f4:	04054163          	bltz	a0,2136 <forktest+0xa8>
    for (; n > 0; n--) {
    20f8:	34fd                	addiw	s1,s1,-1
    20fa:	f8e5                	bnez	s1,20ea <forktest+0x5c>
    if (wait(0) != -1) {
    20fc:	4501                	li	a0,0
    20fe:	00004097          	auipc	ra,0x4
    2102:	abc080e7          	jalr	-1348(ra) # 5bba <wait>
    2106:	57fd                	li	a5,-1
    2108:	04f51563          	bne	a0,a5,2152 <forktest+0xc4>
}
    210c:	70a2                	ld	ra,40(sp)
    210e:	7402                	ld	s0,32(sp)
    2110:	64e2                	ld	s1,24(sp)
    2112:	6942                	ld	s2,16(sp)
    2114:	69a2                	ld	s3,8(sp)
    2116:	6145                	addi	sp,sp,48
    2118:	8082                	ret
        printf("%s: no fork at all!\n", s);
    211a:	85ce                	mv	a1,s3
    211c:	00005517          	auipc	a0,0x5
    2120:	ad450513          	addi	a0,a0,-1324 # 6bf0 <malloc+0xc0c>
    2124:	00004097          	auipc	ra,0x4
    2128:	e08080e7          	jalr	-504(ra) # 5f2c <printf>
        exit(1);
    212c:	4505                	li	a0,1
    212e:	00004097          	auipc	ra,0x4
    2132:	a84080e7          	jalr	-1404(ra) # 5bb2 <exit>
            printf("%s: wait stopped early\n", s);
    2136:	85ce                	mv	a1,s3
    2138:	00005517          	auipc	a0,0x5
    213c:	af850513          	addi	a0,a0,-1288 # 6c30 <malloc+0xc4c>
    2140:	00004097          	auipc	ra,0x4
    2144:	dec080e7          	jalr	-532(ra) # 5f2c <printf>
            exit(1);
    2148:	4505                	li	a0,1
    214a:	00004097          	auipc	ra,0x4
    214e:	a68080e7          	jalr	-1432(ra) # 5bb2 <exit>
        printf("%s: wait got too many\n", s);
    2152:	85ce                	mv	a1,s3
    2154:	00005517          	auipc	a0,0x5
    2158:	af450513          	addi	a0,a0,-1292 # 6c48 <malloc+0xc64>
    215c:	00004097          	auipc	ra,0x4
    2160:	dd0080e7          	jalr	-560(ra) # 5f2c <printf>
        exit(1);
    2164:	4505                	li	a0,1
    2166:	00004097          	auipc	ra,0x4
    216a:	a4c080e7          	jalr	-1460(ra) # 5bb2 <exit>

000000000000216e <kernmem>:
{
    216e:	715d                	addi	sp,sp,-80
    2170:	e486                	sd	ra,72(sp)
    2172:	e0a2                	sd	s0,64(sp)
    2174:	fc26                	sd	s1,56(sp)
    2176:	f84a                	sd	s2,48(sp)
    2178:	f44e                	sd	s3,40(sp)
    217a:	f052                	sd	s4,32(sp)
    217c:	ec56                	sd	s5,24(sp)
    217e:	0880                	addi	s0,sp,80
    2180:	8a2a                	mv	s4,a0
    for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    2182:	4485                	li	s1,1
    2184:	04fe                	slli	s1,s1,0x1f
        if (xstatus != -1) // did kernel kill child?
    2186:	5afd                	li	s5,-1
    for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    2188:	69b1                	lui	s3,0xc
    218a:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1de8>
    218e:	1003d937          	lui	s2,0x1003d
    2192:	090e                	slli	s2,s2,0x3
    2194:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d808>
        pid = fork();
    2198:	00004097          	auipc	ra,0x4
    219c:	a12080e7          	jalr	-1518(ra) # 5baa <fork>
        if (pid < 0) {
    21a0:	02054963          	bltz	a0,21d2 <kernmem+0x64>
        if (pid == 0) {
    21a4:	c529                	beqz	a0,21ee <kernmem+0x80>
        wait(&xstatus);
    21a6:	fbc40513          	addi	a0,s0,-68
    21aa:	00004097          	auipc	ra,0x4
    21ae:	a10080e7          	jalr	-1520(ra) # 5bba <wait>
        if (xstatus != -1) // did kernel kill child?
    21b2:	fbc42783          	lw	a5,-68(s0)
    21b6:	05579d63          	bne	a5,s5,2210 <kernmem+0xa2>
    for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    21ba:	94ce                	add	s1,s1,s3
    21bc:	fd249ee3          	bne	s1,s2,2198 <kernmem+0x2a>
}
    21c0:	60a6                	ld	ra,72(sp)
    21c2:	6406                	ld	s0,64(sp)
    21c4:	74e2                	ld	s1,56(sp)
    21c6:	7942                	ld	s2,48(sp)
    21c8:	79a2                	ld	s3,40(sp)
    21ca:	7a02                	ld	s4,32(sp)
    21cc:	6ae2                	ld	s5,24(sp)
    21ce:	6161                	addi	sp,sp,80
    21d0:	8082                	ret
            printf("%s: fork failed\n", s);
    21d2:	85d2                	mv	a1,s4
    21d4:	00004517          	auipc	a0,0x4
    21d8:	7bc50513          	addi	a0,a0,1980 # 6990 <malloc+0x9ac>
    21dc:	00004097          	auipc	ra,0x4
    21e0:	d50080e7          	jalr	-688(ra) # 5f2c <printf>
            exit(1);
    21e4:	4505                	li	a0,1
    21e6:	00004097          	auipc	ra,0x4
    21ea:	9cc080e7          	jalr	-1588(ra) # 5bb2 <exit>
            printf("%s: oops could read %x = %x\n", s, a, *a);
    21ee:	0004c683          	lbu	a3,0(s1)
    21f2:	8626                	mv	a2,s1
    21f4:	85d2                	mv	a1,s4
    21f6:	00005517          	auipc	a0,0x5
    21fa:	a6a50513          	addi	a0,a0,-1430 # 6c60 <malloc+0xc7c>
    21fe:	00004097          	auipc	ra,0x4
    2202:	d2e080e7          	jalr	-722(ra) # 5f2c <printf>
            exit(1);
    2206:	4505                	li	a0,1
    2208:	00004097          	auipc	ra,0x4
    220c:	9aa080e7          	jalr	-1622(ra) # 5bb2 <exit>
            exit(1);
    2210:	4505                	li	a0,1
    2212:	00004097          	auipc	ra,0x4
    2216:	9a0080e7          	jalr	-1632(ra) # 5bb2 <exit>

000000000000221a <MAXVAplus>:
{
    221a:	7179                	addi	sp,sp,-48
    221c:	f406                	sd	ra,40(sp)
    221e:	f022                	sd	s0,32(sp)
    2220:	ec26                	sd	s1,24(sp)
    2222:	e84a                	sd	s2,16(sp)
    2224:	1800                	addi	s0,sp,48
    volatile uint64 a = MAXVA;
    2226:	4785                	li	a5,1
    2228:	179a                	slli	a5,a5,0x26
    222a:	fcf43c23          	sd	a5,-40(s0)
    for (; a != 0; a <<= 1) {
    222e:	fd843783          	ld	a5,-40(s0)
    2232:	cf85                	beqz	a5,226a <MAXVAplus+0x50>
    2234:	892a                	mv	s2,a0
        if (xstatus != -1) // did kernel kill child?
    2236:	54fd                	li	s1,-1
        pid = fork();
    2238:	00004097          	auipc	ra,0x4
    223c:	972080e7          	jalr	-1678(ra) # 5baa <fork>
        if (pid < 0) {
    2240:	02054b63          	bltz	a0,2276 <MAXVAplus+0x5c>
        if (pid == 0) {
    2244:	c539                	beqz	a0,2292 <MAXVAplus+0x78>
        wait(&xstatus);
    2246:	fd440513          	addi	a0,s0,-44
    224a:	00004097          	auipc	ra,0x4
    224e:	970080e7          	jalr	-1680(ra) # 5bba <wait>
        if (xstatus != -1) // did kernel kill child?
    2252:	fd442783          	lw	a5,-44(s0)
    2256:	06979463          	bne	a5,s1,22be <MAXVAplus+0xa4>
    for (; a != 0; a <<= 1) {
    225a:	fd843783          	ld	a5,-40(s0)
    225e:	0786                	slli	a5,a5,0x1
    2260:	fcf43c23          	sd	a5,-40(s0)
    2264:	fd843783          	ld	a5,-40(s0)
    2268:	fbe1                	bnez	a5,2238 <MAXVAplus+0x1e>
}
    226a:	70a2                	ld	ra,40(sp)
    226c:	7402                	ld	s0,32(sp)
    226e:	64e2                	ld	s1,24(sp)
    2270:	6942                	ld	s2,16(sp)
    2272:	6145                	addi	sp,sp,48
    2274:	8082                	ret
            printf("%s: fork failed\n", s);
    2276:	85ca                	mv	a1,s2
    2278:	00004517          	auipc	a0,0x4
    227c:	71850513          	addi	a0,a0,1816 # 6990 <malloc+0x9ac>
    2280:	00004097          	auipc	ra,0x4
    2284:	cac080e7          	jalr	-852(ra) # 5f2c <printf>
            exit(1);
    2288:	4505                	li	a0,1
    228a:	00004097          	auipc	ra,0x4
    228e:	928080e7          	jalr	-1752(ra) # 5bb2 <exit>
            *(char *)a = 99;
    2292:	fd843783          	ld	a5,-40(s0)
    2296:	06300713          	li	a4,99
    229a:	00e78023          	sb	a4,0(a5)
            printf("%s: oops wrote %x\n", s, a);
    229e:	fd843603          	ld	a2,-40(s0)
    22a2:	85ca                	mv	a1,s2
    22a4:	00005517          	auipc	a0,0x5
    22a8:	9dc50513          	addi	a0,a0,-1572 # 6c80 <malloc+0xc9c>
    22ac:	00004097          	auipc	ra,0x4
    22b0:	c80080e7          	jalr	-896(ra) # 5f2c <printf>
            exit(1);
    22b4:	4505                	li	a0,1
    22b6:	00004097          	auipc	ra,0x4
    22ba:	8fc080e7          	jalr	-1796(ra) # 5bb2 <exit>
            exit(1);
    22be:	4505                	li	a0,1
    22c0:	00004097          	auipc	ra,0x4
    22c4:	8f2080e7          	jalr	-1806(ra) # 5bb2 <exit>

00000000000022c8 <bigargtest>:
{
    22c8:	7179                	addi	sp,sp,-48
    22ca:	f406                	sd	ra,40(sp)
    22cc:	f022                	sd	s0,32(sp)
    22ce:	ec26                	sd	s1,24(sp)
    22d0:	1800                	addi	s0,sp,48
    22d2:	84aa                	mv	s1,a0
    unlink("bigarg-ok");
    22d4:	00005517          	auipc	a0,0x5
    22d8:	9c450513          	addi	a0,a0,-1596 # 6c98 <malloc+0xcb4>
    22dc:	00004097          	auipc	ra,0x4
    22e0:	926080e7          	jalr	-1754(ra) # 5c02 <unlink>
    pid = fork();
    22e4:	00004097          	auipc	ra,0x4
    22e8:	8c6080e7          	jalr	-1850(ra) # 5baa <fork>
    if (pid == 0) {
    22ec:	c121                	beqz	a0,232c <bigargtest+0x64>
    else if (pid < 0) {
    22ee:	0a054063          	bltz	a0,238e <bigargtest+0xc6>
    wait(&xstatus);
    22f2:	fdc40513          	addi	a0,s0,-36
    22f6:	00004097          	auipc	ra,0x4
    22fa:	8c4080e7          	jalr	-1852(ra) # 5bba <wait>
    if (xstatus != 0)
    22fe:	fdc42503          	lw	a0,-36(s0)
    2302:	e545                	bnez	a0,23aa <bigargtest+0xe2>
    fd = open("bigarg-ok", 0);
    2304:	4581                	li	a1,0
    2306:	00005517          	auipc	a0,0x5
    230a:	99250513          	addi	a0,a0,-1646 # 6c98 <malloc+0xcb4>
    230e:	00004097          	auipc	ra,0x4
    2312:	8e4080e7          	jalr	-1820(ra) # 5bf2 <open>
    if (fd < 0) {
    2316:	08054e63          	bltz	a0,23b2 <bigargtest+0xea>
    close(fd);
    231a:	00004097          	auipc	ra,0x4
    231e:	8c0080e7          	jalr	-1856(ra) # 5bda <close>
}
    2322:	70a2                	ld	ra,40(sp)
    2324:	7402                	ld	s0,32(sp)
    2326:	64e2                	ld	s1,24(sp)
    2328:	6145                	addi	sp,sp,48
    232a:	8082                	ret
    232c:	00007797          	auipc	a5,0x7
    2330:	13478793          	addi	a5,a5,308 # 9460 <args.1>
    2334:	00007697          	auipc	a3,0x7
    2338:	22468693          	addi	a3,a3,548 # 9558 <args.1+0xf8>
            args[i] = "bigargs test: failed\n                                                                                                                  "
    233c:	00005717          	auipc	a4,0x5
    2340:	96c70713          	addi	a4,a4,-1684 # 6ca8 <malloc+0xcc4>
    2344:	e398                	sd	a4,0(a5)
        for (i = 0; i < MAXARG - 1; i++)
    2346:	07a1                	addi	a5,a5,8
    2348:	fed79ee3          	bne	a5,a3,2344 <bigargtest+0x7c>
        args[MAXARG - 1] = 0;
    234c:	00007597          	auipc	a1,0x7
    2350:	11458593          	addi	a1,a1,276 # 9460 <args.1>
    2354:	0e05bc23          	sd	zero,248(a1)
        exec("echo", args);
    2358:	00004517          	auipc	a0,0x4
    235c:	db050513          	addi	a0,a0,-592 # 6108 <malloc+0x124>
    2360:	00004097          	auipc	ra,0x4
    2364:	88a080e7          	jalr	-1910(ra) # 5bea <exec>
        fd = open("bigarg-ok", O_CREATE);
    2368:	20000593          	li	a1,512
    236c:	00005517          	auipc	a0,0x5
    2370:	92c50513          	addi	a0,a0,-1748 # 6c98 <malloc+0xcb4>
    2374:	00004097          	auipc	ra,0x4
    2378:	87e080e7          	jalr	-1922(ra) # 5bf2 <open>
        close(fd);
    237c:	00004097          	auipc	ra,0x4
    2380:	85e080e7          	jalr	-1954(ra) # 5bda <close>
        exit(0);
    2384:	4501                	li	a0,0
    2386:	00004097          	auipc	ra,0x4
    238a:	82c080e7          	jalr	-2004(ra) # 5bb2 <exit>
        printf("%s: bigargtest: fork failed\n", s);
    238e:	85a6                	mv	a1,s1
    2390:	00005517          	auipc	a0,0x5
    2394:	9f850513          	addi	a0,a0,-1544 # 6d88 <malloc+0xda4>
    2398:	00004097          	auipc	ra,0x4
    239c:	b94080e7          	jalr	-1132(ra) # 5f2c <printf>
        exit(1);
    23a0:	4505                	li	a0,1
    23a2:	00004097          	auipc	ra,0x4
    23a6:	810080e7          	jalr	-2032(ra) # 5bb2 <exit>
        exit(xstatus);
    23aa:	00004097          	auipc	ra,0x4
    23ae:	808080e7          	jalr	-2040(ra) # 5bb2 <exit>
        printf("%s: bigarg test failed!\n", s);
    23b2:	85a6                	mv	a1,s1
    23b4:	00005517          	auipc	a0,0x5
    23b8:	9f450513          	addi	a0,a0,-1548 # 6da8 <malloc+0xdc4>
    23bc:	00004097          	auipc	ra,0x4
    23c0:	b70080e7          	jalr	-1168(ra) # 5f2c <printf>
        exit(1);
    23c4:	4505                	li	a0,1
    23c6:	00003097          	auipc	ra,0x3
    23ca:	7ec080e7          	jalr	2028(ra) # 5bb2 <exit>

00000000000023ce <stacktest>:
{
    23ce:	7179                	addi	sp,sp,-48
    23d0:	f406                	sd	ra,40(sp)
    23d2:	f022                	sd	s0,32(sp)
    23d4:	ec26                	sd	s1,24(sp)
    23d6:	1800                	addi	s0,sp,48
    23d8:	84aa                	mv	s1,a0
    pid = fork();
    23da:	00003097          	auipc	ra,0x3
    23de:	7d0080e7          	jalr	2000(ra) # 5baa <fork>
    if (pid == 0) {
    23e2:	c115                	beqz	a0,2406 <stacktest+0x38>
    else if (pid < 0) {
    23e4:	04054463          	bltz	a0,242c <stacktest+0x5e>
    wait(&xstatus);
    23e8:	fdc40513          	addi	a0,s0,-36
    23ec:	00003097          	auipc	ra,0x3
    23f0:	7ce080e7          	jalr	1998(ra) # 5bba <wait>
    if (xstatus == -1) // kernel killed child?
    23f4:	fdc42503          	lw	a0,-36(s0)
    23f8:	57fd                	li	a5,-1
    23fa:	04f50763          	beq	a0,a5,2448 <stacktest+0x7a>
        exit(xstatus);
    23fe:	00003097          	auipc	ra,0x3
    2402:	7b4080e7          	jalr	1972(ra) # 5bb2 <exit>
}

static inline uint64 r_sp()
{
    uint64 x;
    asm volatile("mv %0, sp" : "=r"(x));
    2406:	870a                	mv	a4,sp
        printf("%s: stacktest: read below stack %p\n", s, *sp);
    2408:	77fd                	lui	a5,0xfffff
    240a:	97ba                	add	a5,a5,a4
    240c:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef388>
    2410:	85a6                	mv	a1,s1
    2412:	00005517          	auipc	a0,0x5
    2416:	9b650513          	addi	a0,a0,-1610 # 6dc8 <malloc+0xde4>
    241a:	00004097          	auipc	ra,0x4
    241e:	b12080e7          	jalr	-1262(ra) # 5f2c <printf>
        exit(1);
    2422:	4505                	li	a0,1
    2424:	00003097          	auipc	ra,0x3
    2428:	78e080e7          	jalr	1934(ra) # 5bb2 <exit>
        printf("%s: fork failed\n", s);
    242c:	85a6                	mv	a1,s1
    242e:	00004517          	auipc	a0,0x4
    2432:	56250513          	addi	a0,a0,1378 # 6990 <malloc+0x9ac>
    2436:	00004097          	auipc	ra,0x4
    243a:	af6080e7          	jalr	-1290(ra) # 5f2c <printf>
        exit(1);
    243e:	4505                	li	a0,1
    2440:	00003097          	auipc	ra,0x3
    2444:	772080e7          	jalr	1906(ra) # 5bb2 <exit>
        exit(0);
    2448:	4501                	li	a0,0
    244a:	00003097          	auipc	ra,0x3
    244e:	768080e7          	jalr	1896(ra) # 5bb2 <exit>

0000000000002452 <textwrite>:
{
    2452:	7179                	addi	sp,sp,-48
    2454:	f406                	sd	ra,40(sp)
    2456:	f022                	sd	s0,32(sp)
    2458:	ec26                	sd	s1,24(sp)
    245a:	1800                	addi	s0,sp,48
    245c:	84aa                	mv	s1,a0
    pid = fork();
    245e:	00003097          	auipc	ra,0x3
    2462:	74c080e7          	jalr	1868(ra) # 5baa <fork>
    if (pid == 0) {
    2466:	c105                	beqz	a0,2486 <textwrite+0x34>
    else if (pid < 0) {
    2468:	02054763          	bltz	a0,2496 <textwrite+0x44>
    wait(&xstatus);
    246c:	fdc40513          	addi	a0,s0,-36
    2470:	00003097          	auipc	ra,0x3
    2474:	74a080e7          	jalr	1866(ra) # 5bba <wait>
    xstatus = 0;
    2478:	fc042e23          	sw	zero,-36(s0)
    exit(xstatus);
    247c:	4501                	li	a0,0
    247e:	00003097          	auipc	ra,0x3
    2482:	734080e7          	jalr	1844(ra) # 5bb2 <exit>
        *addr = 10;
    2486:	47a9                	li	a5,10
    2488:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
        exit(1);
    248c:	4505                	li	a0,1
    248e:	00003097          	auipc	ra,0x3
    2492:	724080e7          	jalr	1828(ra) # 5bb2 <exit>
        printf("%s: fork failed\n", s);
    2496:	85a6                	mv	a1,s1
    2498:	00004517          	auipc	a0,0x4
    249c:	4f850513          	addi	a0,a0,1272 # 6990 <malloc+0x9ac>
    24a0:	00004097          	auipc	ra,0x4
    24a4:	a8c080e7          	jalr	-1396(ra) # 5f2c <printf>
        exit(1);
    24a8:	4505                	li	a0,1
    24aa:	00003097          	auipc	ra,0x3
    24ae:	708080e7          	jalr	1800(ra) # 5bb2 <exit>

00000000000024b2 <manywrites>:
{
    24b2:	711d                	addi	sp,sp,-96
    24b4:	ec86                	sd	ra,88(sp)
    24b6:	e8a2                	sd	s0,80(sp)
    24b8:	e4a6                	sd	s1,72(sp)
    24ba:	e0ca                	sd	s2,64(sp)
    24bc:	fc4e                	sd	s3,56(sp)
    24be:	f852                	sd	s4,48(sp)
    24c0:	f456                	sd	s5,40(sp)
    24c2:	f05a                	sd	s6,32(sp)
    24c4:	ec5e                	sd	s7,24(sp)
    24c6:	1080                	addi	s0,sp,96
    24c8:	8aaa                	mv	s5,a0
    for (int ci = 0; ci < nchildren; ci++) {
    24ca:	4981                	li	s3,0
    24cc:	4911                	li	s2,4
        int pid = fork();
    24ce:	00003097          	auipc	ra,0x3
    24d2:	6dc080e7          	jalr	1756(ra) # 5baa <fork>
    24d6:	84aa                	mv	s1,a0
        if (pid < 0) {
    24d8:	02054963          	bltz	a0,250a <manywrites+0x58>
        if (pid == 0) {
    24dc:	c521                	beqz	a0,2524 <manywrites+0x72>
    for (int ci = 0; ci < nchildren; ci++) {
    24de:	2985                	addiw	s3,s3,1
    24e0:	ff2997e3          	bne	s3,s2,24ce <manywrites+0x1c>
    24e4:	4491                	li	s1,4
        int st = 0;
    24e6:	fa042423          	sw	zero,-88(s0)
        wait(&st);
    24ea:	fa840513          	addi	a0,s0,-88
    24ee:	00003097          	auipc	ra,0x3
    24f2:	6cc080e7          	jalr	1740(ra) # 5bba <wait>
        if (st != 0)
    24f6:	fa842503          	lw	a0,-88(s0)
    24fa:	ed6d                	bnez	a0,25f4 <manywrites+0x142>
    for (int ci = 0; ci < nchildren; ci++) {
    24fc:	34fd                	addiw	s1,s1,-1
    24fe:	f4e5                	bnez	s1,24e6 <manywrites+0x34>
    exit(0);
    2500:	4501                	li	a0,0
    2502:	00003097          	auipc	ra,0x3
    2506:	6b0080e7          	jalr	1712(ra) # 5bb2 <exit>
            printf("fork failed\n");
    250a:	00005517          	auipc	a0,0x5
    250e:	88e50513          	addi	a0,a0,-1906 # 6d98 <malloc+0xdb4>
    2512:	00004097          	auipc	ra,0x4
    2516:	a1a080e7          	jalr	-1510(ra) # 5f2c <printf>
            exit(1);
    251a:	4505                	li	a0,1
    251c:	00003097          	auipc	ra,0x3
    2520:	696080e7          	jalr	1686(ra) # 5bb2 <exit>
            name[0] = 'b';
    2524:	06200793          	li	a5,98
    2528:	faf40423          	sb	a5,-88(s0)
            name[1] = 'a' + ci;
    252c:	0619879b          	addiw	a5,s3,97
    2530:	faf404a3          	sb	a5,-87(s0)
            name[2] = '\0';
    2534:	fa040523          	sb	zero,-86(s0)
            unlink(name);
    2538:	fa840513          	addi	a0,s0,-88
    253c:	00003097          	auipc	ra,0x3
    2540:	6c6080e7          	jalr	1734(ra) # 5c02 <unlink>
    2544:	4bf9                	li	s7,30
                    int cc = write(fd, buf, sz);
    2546:	0000ab17          	auipc	s6,0xa
    254a:	732b0b13          	addi	s6,s6,1842 # cc78 <buf>
                for (int i = 0; i < ci + 1; i++) {
    254e:	8a26                	mv	s4,s1
    2550:	0209ce63          	bltz	s3,258c <manywrites+0xda>
                    int fd = open(name, O_CREATE | O_RDWR);
    2554:	20200593          	li	a1,514
    2558:	fa840513          	addi	a0,s0,-88
    255c:	00003097          	auipc	ra,0x3
    2560:	696080e7          	jalr	1686(ra) # 5bf2 <open>
    2564:	892a                	mv	s2,a0
                    if (fd < 0) {
    2566:	04054763          	bltz	a0,25b4 <manywrites+0x102>
                    int cc = write(fd, buf, sz);
    256a:	660d                	lui	a2,0x3
    256c:	85da                	mv	a1,s6
    256e:	00003097          	auipc	ra,0x3
    2572:	664080e7          	jalr	1636(ra) # 5bd2 <write>
                    if (cc != sz) {
    2576:	678d                	lui	a5,0x3
    2578:	04f51e63          	bne	a0,a5,25d4 <manywrites+0x122>
                    close(fd);
    257c:	854a                	mv	a0,s2
    257e:	00003097          	auipc	ra,0x3
    2582:	65c080e7          	jalr	1628(ra) # 5bda <close>
                for (int i = 0; i < ci + 1; i++) {
    2586:	2a05                	addiw	s4,s4,1
    2588:	fd49d6e3          	bge	s3,s4,2554 <manywrites+0xa2>
                unlink(name);
    258c:	fa840513          	addi	a0,s0,-88
    2590:	00003097          	auipc	ra,0x3
    2594:	672080e7          	jalr	1650(ra) # 5c02 <unlink>
            for (int iters = 0; iters < howmany; iters++) {
    2598:	3bfd                	addiw	s7,s7,-1
    259a:	fa0b9ae3          	bnez	s7,254e <manywrites+0x9c>
            unlink(name);
    259e:	fa840513          	addi	a0,s0,-88
    25a2:	00003097          	auipc	ra,0x3
    25a6:	660080e7          	jalr	1632(ra) # 5c02 <unlink>
            exit(0);
    25aa:	4501                	li	a0,0
    25ac:	00003097          	auipc	ra,0x3
    25b0:	606080e7          	jalr	1542(ra) # 5bb2 <exit>
                        printf("%s: cannot create %s\n", s, name);
    25b4:	fa840613          	addi	a2,s0,-88
    25b8:	85d6                	mv	a1,s5
    25ba:	00005517          	auipc	a0,0x5
    25be:	83650513          	addi	a0,a0,-1994 # 6df0 <malloc+0xe0c>
    25c2:	00004097          	auipc	ra,0x4
    25c6:	96a080e7          	jalr	-1686(ra) # 5f2c <printf>
                        exit(1);
    25ca:	4505                	li	a0,1
    25cc:	00003097          	auipc	ra,0x3
    25d0:	5e6080e7          	jalr	1510(ra) # 5bb2 <exit>
                        printf("%s: write(%d) ret %d\n", s, sz, cc);
    25d4:	86aa                	mv	a3,a0
    25d6:	660d                	lui	a2,0x3
    25d8:	85d6                	mv	a1,s5
    25da:	00004517          	auipc	a0,0x4
    25de:	bfe50513          	addi	a0,a0,-1026 # 61d8 <malloc+0x1f4>
    25e2:	00004097          	auipc	ra,0x4
    25e6:	94a080e7          	jalr	-1718(ra) # 5f2c <printf>
                        exit(1);
    25ea:	4505                	li	a0,1
    25ec:	00003097          	auipc	ra,0x3
    25f0:	5c6080e7          	jalr	1478(ra) # 5bb2 <exit>
            exit(st);
    25f4:	00003097          	auipc	ra,0x3
    25f8:	5be080e7          	jalr	1470(ra) # 5bb2 <exit>

00000000000025fc <copyinstr3>:
{
    25fc:	7179                	addi	sp,sp,-48
    25fe:	f406                	sd	ra,40(sp)
    2600:	f022                	sd	s0,32(sp)
    2602:	ec26                	sd	s1,24(sp)
    2604:	1800                	addi	s0,sp,48
    sbrk(8192);
    2606:	6509                	lui	a0,0x2
    2608:	00003097          	auipc	ra,0x3
    260c:	632080e7          	jalr	1586(ra) # 5c3a <sbrk>
    uint64 top = (uint64)sbrk(0);
    2610:	4501                	li	a0,0
    2612:	00003097          	auipc	ra,0x3
    2616:	628080e7          	jalr	1576(ra) # 5c3a <sbrk>
    if ((top % PGSIZE) != 0) {
    261a:	03451793          	slli	a5,a0,0x34
    261e:	e3c9                	bnez	a5,26a0 <copyinstr3+0xa4>
    top = (uint64)sbrk(0);
    2620:	4501                	li	a0,0
    2622:	00003097          	auipc	ra,0x3
    2626:	618080e7          	jalr	1560(ra) # 5c3a <sbrk>
    if (top % PGSIZE) {
    262a:	03451793          	slli	a5,a0,0x34
    262e:	e3d9                	bnez	a5,26b4 <copyinstr3+0xb8>
    char *b = (char *)(top - 1);
    2630:	fff50493          	addi	s1,a0,-1 # 1fff <linkunlink+0x73>
    *b = 'x';
    2634:	07800793          	li	a5,120
    2638:	fef50fa3          	sb	a5,-1(a0)
    int ret = unlink(b);
    263c:	8526                	mv	a0,s1
    263e:	00003097          	auipc	ra,0x3
    2642:	5c4080e7          	jalr	1476(ra) # 5c02 <unlink>
    if (ret != -1) {
    2646:	57fd                	li	a5,-1
    2648:	08f51363          	bne	a0,a5,26ce <copyinstr3+0xd2>
    int fd = open(b, O_CREATE | O_WRONLY);
    264c:	20100593          	li	a1,513
    2650:	8526                	mv	a0,s1
    2652:	00003097          	auipc	ra,0x3
    2656:	5a0080e7          	jalr	1440(ra) # 5bf2 <open>
    if (fd != -1) {
    265a:	57fd                	li	a5,-1
    265c:	08f51863          	bne	a0,a5,26ec <copyinstr3+0xf0>
    ret = link(b, b);
    2660:	85a6                	mv	a1,s1
    2662:	8526                	mv	a0,s1
    2664:	00003097          	auipc	ra,0x3
    2668:	5ae080e7          	jalr	1454(ra) # 5c12 <link>
    if (ret != -1) {
    266c:	57fd                	li	a5,-1
    266e:	08f51e63          	bne	a0,a5,270a <copyinstr3+0x10e>
    char *args[] = {"xx", 0};
    2672:	00005797          	auipc	a5,0x5
    2676:	47678793          	addi	a5,a5,1142 # 7ae8 <malloc+0x1b04>
    267a:	fcf43823          	sd	a5,-48(s0)
    267e:	fc043c23          	sd	zero,-40(s0)
    ret = exec(b, args);
    2682:	fd040593          	addi	a1,s0,-48
    2686:	8526                	mv	a0,s1
    2688:	00003097          	auipc	ra,0x3
    268c:	562080e7          	jalr	1378(ra) # 5bea <exec>
    if (ret != -1) {
    2690:	57fd                	li	a5,-1
    2692:	08f51c63          	bne	a0,a5,272a <copyinstr3+0x12e>
}
    2696:	70a2                	ld	ra,40(sp)
    2698:	7402                	ld	s0,32(sp)
    269a:	64e2                	ld	s1,24(sp)
    269c:	6145                	addi	sp,sp,48
    269e:	8082                	ret
        sbrk(PGSIZE - (top % PGSIZE));
    26a0:	0347d513          	srli	a0,a5,0x34
    26a4:	6785                	lui	a5,0x1
    26a6:	40a7853b          	subw	a0,a5,a0
    26aa:	00003097          	auipc	ra,0x3
    26ae:	590080e7          	jalr	1424(ra) # 5c3a <sbrk>
    26b2:	b7bd                	j	2620 <copyinstr3+0x24>
        printf("oops\n");
    26b4:	00004517          	auipc	a0,0x4
    26b8:	75450513          	addi	a0,a0,1876 # 6e08 <malloc+0xe24>
    26bc:	00004097          	auipc	ra,0x4
    26c0:	870080e7          	jalr	-1936(ra) # 5f2c <printf>
        exit(1);
    26c4:	4505                	li	a0,1
    26c6:	00003097          	auipc	ra,0x3
    26ca:	4ec080e7          	jalr	1260(ra) # 5bb2 <exit>
        printf("unlink(%s) returned %d, not -1\n", b, ret);
    26ce:	862a                	mv	a2,a0
    26d0:	85a6                	mv	a1,s1
    26d2:	00004517          	auipc	a0,0x4
    26d6:	1de50513          	addi	a0,a0,478 # 68b0 <malloc+0x8cc>
    26da:	00004097          	auipc	ra,0x4
    26de:	852080e7          	jalr	-1966(ra) # 5f2c <printf>
        exit(1);
    26e2:	4505                	li	a0,1
    26e4:	00003097          	auipc	ra,0x3
    26e8:	4ce080e7          	jalr	1230(ra) # 5bb2 <exit>
        printf("open(%s) returned %d, not -1\n", b, fd);
    26ec:	862a                	mv	a2,a0
    26ee:	85a6                	mv	a1,s1
    26f0:	00004517          	auipc	a0,0x4
    26f4:	1e050513          	addi	a0,a0,480 # 68d0 <malloc+0x8ec>
    26f8:	00004097          	auipc	ra,0x4
    26fc:	834080e7          	jalr	-1996(ra) # 5f2c <printf>
        exit(1);
    2700:	4505                	li	a0,1
    2702:	00003097          	auipc	ra,0x3
    2706:	4b0080e7          	jalr	1200(ra) # 5bb2 <exit>
        printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    270a:	86aa                	mv	a3,a0
    270c:	8626                	mv	a2,s1
    270e:	85a6                	mv	a1,s1
    2710:	00004517          	auipc	a0,0x4
    2714:	1e050513          	addi	a0,a0,480 # 68f0 <malloc+0x90c>
    2718:	00004097          	auipc	ra,0x4
    271c:	814080e7          	jalr	-2028(ra) # 5f2c <printf>
        exit(1);
    2720:	4505                	li	a0,1
    2722:	00003097          	auipc	ra,0x3
    2726:	490080e7          	jalr	1168(ra) # 5bb2 <exit>
        printf("exec(%s) returned %d, not -1\n", b, fd);
    272a:	567d                	li	a2,-1
    272c:	85a6                	mv	a1,s1
    272e:	00004517          	auipc	a0,0x4
    2732:	1ea50513          	addi	a0,a0,490 # 6918 <malloc+0x934>
    2736:	00003097          	auipc	ra,0x3
    273a:	7f6080e7          	jalr	2038(ra) # 5f2c <printf>
        exit(1);
    273e:	4505                	li	a0,1
    2740:	00003097          	auipc	ra,0x3
    2744:	472080e7          	jalr	1138(ra) # 5bb2 <exit>

0000000000002748 <rwsbrk>:
{
    2748:	1101                	addi	sp,sp,-32
    274a:	ec06                	sd	ra,24(sp)
    274c:	e822                	sd	s0,16(sp)
    274e:	e426                	sd	s1,8(sp)
    2750:	e04a                	sd	s2,0(sp)
    2752:	1000                	addi	s0,sp,32
    uint64 a = (uint64)sbrk(8192);
    2754:	6509                	lui	a0,0x2
    2756:	00003097          	auipc	ra,0x3
    275a:	4e4080e7          	jalr	1252(ra) # 5c3a <sbrk>
    if (a == 0xffffffffffffffffLL) {
    275e:	57fd                	li	a5,-1
    2760:	06f50263          	beq	a0,a5,27c4 <rwsbrk+0x7c>
    2764:	84aa                	mv	s1,a0
    if ((uint64)sbrk(-8192) == 0xffffffffffffffffLL) {
    2766:	7579                	lui	a0,0xffffe
    2768:	00003097          	auipc	ra,0x3
    276c:	4d2080e7          	jalr	1234(ra) # 5c3a <sbrk>
    2770:	57fd                	li	a5,-1
    2772:	06f50663          	beq	a0,a5,27de <rwsbrk+0x96>
    fd = open("rwsbrk", O_CREATE | O_WRONLY);
    2776:	20100593          	li	a1,513
    277a:	00004517          	auipc	a0,0x4
    277e:	6ce50513          	addi	a0,a0,1742 # 6e48 <malloc+0xe64>
    2782:	00003097          	auipc	ra,0x3
    2786:	470080e7          	jalr	1136(ra) # 5bf2 <open>
    278a:	892a                	mv	s2,a0
    if (fd < 0) {
    278c:	06054663          	bltz	a0,27f8 <rwsbrk+0xb0>
    n = write(fd, (void *)(a + 4096), 1024);
    2790:	6785                	lui	a5,0x1
    2792:	94be                	add	s1,s1,a5
    2794:	40000613          	li	a2,1024
    2798:	85a6                	mv	a1,s1
    279a:	00003097          	auipc	ra,0x3
    279e:	438080e7          	jalr	1080(ra) # 5bd2 <write>
    27a2:	862a                	mv	a2,a0
    if (n >= 0) {
    27a4:	06054763          	bltz	a0,2812 <rwsbrk+0xca>
        printf("write(fd, %p, 1024) returned %d, not -1\n", a + 4096, n);
    27a8:	85a6                	mv	a1,s1
    27aa:	00004517          	auipc	a0,0x4
    27ae:	6be50513          	addi	a0,a0,1726 # 6e68 <malloc+0xe84>
    27b2:	00003097          	auipc	ra,0x3
    27b6:	77a080e7          	jalr	1914(ra) # 5f2c <printf>
        exit(1);
    27ba:	4505                	li	a0,1
    27bc:	00003097          	auipc	ra,0x3
    27c0:	3f6080e7          	jalr	1014(ra) # 5bb2 <exit>
        printf("sbrk(rwsbrk) failed\n");
    27c4:	00004517          	auipc	a0,0x4
    27c8:	64c50513          	addi	a0,a0,1612 # 6e10 <malloc+0xe2c>
    27cc:	00003097          	auipc	ra,0x3
    27d0:	760080e7          	jalr	1888(ra) # 5f2c <printf>
        exit(1);
    27d4:	4505                	li	a0,1
    27d6:	00003097          	auipc	ra,0x3
    27da:	3dc080e7          	jalr	988(ra) # 5bb2 <exit>
        printf("sbrk(rwsbrk) shrink failed\n");
    27de:	00004517          	auipc	a0,0x4
    27e2:	64a50513          	addi	a0,a0,1610 # 6e28 <malloc+0xe44>
    27e6:	00003097          	auipc	ra,0x3
    27ea:	746080e7          	jalr	1862(ra) # 5f2c <printf>
        exit(1);
    27ee:	4505                	li	a0,1
    27f0:	00003097          	auipc	ra,0x3
    27f4:	3c2080e7          	jalr	962(ra) # 5bb2 <exit>
        printf("open(rwsbrk) failed\n");
    27f8:	00004517          	auipc	a0,0x4
    27fc:	65850513          	addi	a0,a0,1624 # 6e50 <malloc+0xe6c>
    2800:	00003097          	auipc	ra,0x3
    2804:	72c080e7          	jalr	1836(ra) # 5f2c <printf>
        exit(1);
    2808:	4505                	li	a0,1
    280a:	00003097          	auipc	ra,0x3
    280e:	3a8080e7          	jalr	936(ra) # 5bb2 <exit>
    close(fd);
    2812:	854a                	mv	a0,s2
    2814:	00003097          	auipc	ra,0x3
    2818:	3c6080e7          	jalr	966(ra) # 5bda <close>
    unlink("rwsbrk");
    281c:	00004517          	auipc	a0,0x4
    2820:	62c50513          	addi	a0,a0,1580 # 6e48 <malloc+0xe64>
    2824:	00003097          	auipc	ra,0x3
    2828:	3de080e7          	jalr	990(ra) # 5c02 <unlink>
    fd = open("README", O_RDONLY);
    282c:	4581                	li	a1,0
    282e:	00004517          	auipc	a0,0x4
    2832:	ab250513          	addi	a0,a0,-1358 # 62e0 <malloc+0x2fc>
    2836:	00003097          	auipc	ra,0x3
    283a:	3bc080e7          	jalr	956(ra) # 5bf2 <open>
    283e:	892a                	mv	s2,a0
    if (fd < 0) {
    2840:	02054963          	bltz	a0,2872 <rwsbrk+0x12a>
    n = read(fd, (void *)(a + 4096), 10);
    2844:	4629                	li	a2,10
    2846:	85a6                	mv	a1,s1
    2848:	00003097          	auipc	ra,0x3
    284c:	382080e7          	jalr	898(ra) # 5bca <read>
    2850:	862a                	mv	a2,a0
    if (n >= 0) {
    2852:	02054d63          	bltz	a0,288c <rwsbrk+0x144>
        printf("read(fd, %p, 10) returned %d, not -1\n", a + 4096, n);
    2856:	85a6                	mv	a1,s1
    2858:	00004517          	auipc	a0,0x4
    285c:	64050513          	addi	a0,a0,1600 # 6e98 <malloc+0xeb4>
    2860:	00003097          	auipc	ra,0x3
    2864:	6cc080e7          	jalr	1740(ra) # 5f2c <printf>
        exit(1);
    2868:	4505                	li	a0,1
    286a:	00003097          	auipc	ra,0x3
    286e:	348080e7          	jalr	840(ra) # 5bb2 <exit>
        printf("open(rwsbrk) failed\n");
    2872:	00004517          	auipc	a0,0x4
    2876:	5de50513          	addi	a0,a0,1502 # 6e50 <malloc+0xe6c>
    287a:	00003097          	auipc	ra,0x3
    287e:	6b2080e7          	jalr	1714(ra) # 5f2c <printf>
        exit(1);
    2882:	4505                	li	a0,1
    2884:	00003097          	auipc	ra,0x3
    2888:	32e080e7          	jalr	814(ra) # 5bb2 <exit>
    close(fd);
    288c:	854a                	mv	a0,s2
    288e:	00003097          	auipc	ra,0x3
    2892:	34c080e7          	jalr	844(ra) # 5bda <close>
    exit(0);
    2896:	4501                	li	a0,0
    2898:	00003097          	auipc	ra,0x3
    289c:	31a080e7          	jalr	794(ra) # 5bb2 <exit>

00000000000028a0 <sbrkbasic>:
{
    28a0:	7139                	addi	sp,sp,-64
    28a2:	fc06                	sd	ra,56(sp)
    28a4:	f822                	sd	s0,48(sp)
    28a6:	f426                	sd	s1,40(sp)
    28a8:	f04a                	sd	s2,32(sp)
    28aa:	ec4e                	sd	s3,24(sp)
    28ac:	e852                	sd	s4,16(sp)
    28ae:	0080                	addi	s0,sp,64
    28b0:	8a2a                	mv	s4,a0
    pid = fork();
    28b2:	00003097          	auipc	ra,0x3
    28b6:	2f8080e7          	jalr	760(ra) # 5baa <fork>
    if (pid < 0) {
    28ba:	02054c63          	bltz	a0,28f2 <sbrkbasic+0x52>
    if (pid == 0) {
    28be:	ed21                	bnez	a0,2916 <sbrkbasic+0x76>
        a = sbrk(TOOMUCH);
    28c0:	40000537          	lui	a0,0x40000
    28c4:	00003097          	auipc	ra,0x3
    28c8:	376080e7          	jalr	886(ra) # 5c3a <sbrk>
        if (a == (char *)0xffffffffffffffffL) {
    28cc:	57fd                	li	a5,-1
    28ce:	02f50f63          	beq	a0,a5,290c <sbrkbasic+0x6c>
        for (b = a; b < a + TOOMUCH; b += 4096) {
    28d2:	400007b7          	lui	a5,0x40000
    28d6:	97aa                	add	a5,a5,a0
            *b = 99;
    28d8:	06300693          	li	a3,99
        for (b = a; b < a + TOOMUCH; b += 4096) {
    28dc:	6705                	lui	a4,0x1
            *b = 99;
    28de:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0388>
        for (b = a; b < a + TOOMUCH; b += 4096) {
    28e2:	953a                	add	a0,a0,a4
    28e4:	fef51de3          	bne	a0,a5,28de <sbrkbasic+0x3e>
        exit(1);
    28e8:	4505                	li	a0,1
    28ea:	00003097          	auipc	ra,0x3
    28ee:	2c8080e7          	jalr	712(ra) # 5bb2 <exit>
        printf("fork failed in sbrkbasic\n");
    28f2:	00004517          	auipc	a0,0x4
    28f6:	5ce50513          	addi	a0,a0,1486 # 6ec0 <malloc+0xedc>
    28fa:	00003097          	auipc	ra,0x3
    28fe:	632080e7          	jalr	1586(ra) # 5f2c <printf>
        exit(1);
    2902:	4505                	li	a0,1
    2904:	00003097          	auipc	ra,0x3
    2908:	2ae080e7          	jalr	686(ra) # 5bb2 <exit>
            exit(0);
    290c:	4501                	li	a0,0
    290e:	00003097          	auipc	ra,0x3
    2912:	2a4080e7          	jalr	676(ra) # 5bb2 <exit>
    wait(&xstatus);
    2916:	fcc40513          	addi	a0,s0,-52
    291a:	00003097          	auipc	ra,0x3
    291e:	2a0080e7          	jalr	672(ra) # 5bba <wait>
    if (xstatus == 1) {
    2922:	fcc42703          	lw	a4,-52(s0)
    2926:	4785                	li	a5,1
    2928:	00f70d63          	beq	a4,a5,2942 <sbrkbasic+0xa2>
    a = sbrk(0);
    292c:	4501                	li	a0,0
    292e:	00003097          	auipc	ra,0x3
    2932:	30c080e7          	jalr	780(ra) # 5c3a <sbrk>
    2936:	84aa                	mv	s1,a0
    for (i = 0; i < 5000; i++) {
    2938:	4901                	li	s2,0
    293a:	6985                	lui	s3,0x1
    293c:	38898993          	addi	s3,s3,904 # 1388 <badarg+0x3e>
    2940:	a005                	j	2960 <sbrkbasic+0xc0>
        printf("%s: too much memory allocated!\n", s);
    2942:	85d2                	mv	a1,s4
    2944:	00004517          	auipc	a0,0x4
    2948:	59c50513          	addi	a0,a0,1436 # 6ee0 <malloc+0xefc>
    294c:	00003097          	auipc	ra,0x3
    2950:	5e0080e7          	jalr	1504(ra) # 5f2c <printf>
        exit(1);
    2954:	4505                	li	a0,1
    2956:	00003097          	auipc	ra,0x3
    295a:	25c080e7          	jalr	604(ra) # 5bb2 <exit>
        a = b + 1;
    295e:	84be                	mv	s1,a5
        b = sbrk(1);
    2960:	4505                	li	a0,1
    2962:	00003097          	auipc	ra,0x3
    2966:	2d8080e7          	jalr	728(ra) # 5c3a <sbrk>
        if (b != a) {
    296a:	04951c63          	bne	a0,s1,29c2 <sbrkbasic+0x122>
        *b = 1;
    296e:	4785                	li	a5,1
    2970:	00f48023          	sb	a5,0(s1)
        a = b + 1;
    2974:	00148793          	addi	a5,s1,1
    for (i = 0; i < 5000; i++) {
    2978:	2905                	addiw	s2,s2,1
    297a:	ff3912e3          	bne	s2,s3,295e <sbrkbasic+0xbe>
    pid = fork();
    297e:	00003097          	auipc	ra,0x3
    2982:	22c080e7          	jalr	556(ra) # 5baa <fork>
    2986:	892a                	mv	s2,a0
    if (pid < 0) {
    2988:	04054e63          	bltz	a0,29e4 <sbrkbasic+0x144>
    c = sbrk(1);
    298c:	4505                	li	a0,1
    298e:	00003097          	auipc	ra,0x3
    2992:	2ac080e7          	jalr	684(ra) # 5c3a <sbrk>
    c = sbrk(1);
    2996:	4505                	li	a0,1
    2998:	00003097          	auipc	ra,0x3
    299c:	2a2080e7          	jalr	674(ra) # 5c3a <sbrk>
    if (c != a + 1) {
    29a0:	0489                	addi	s1,s1,2
    29a2:	04a48f63          	beq	s1,a0,2a00 <sbrkbasic+0x160>
        printf("%s: sbrk test failed post-fork\n", s);
    29a6:	85d2                	mv	a1,s4
    29a8:	00004517          	auipc	a0,0x4
    29ac:	59850513          	addi	a0,a0,1432 # 6f40 <malloc+0xf5c>
    29b0:	00003097          	auipc	ra,0x3
    29b4:	57c080e7          	jalr	1404(ra) # 5f2c <printf>
        exit(1);
    29b8:	4505                	li	a0,1
    29ba:	00003097          	auipc	ra,0x3
    29be:	1f8080e7          	jalr	504(ra) # 5bb2 <exit>
            printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    29c2:	872a                	mv	a4,a0
    29c4:	86a6                	mv	a3,s1
    29c6:	864a                	mv	a2,s2
    29c8:	85d2                	mv	a1,s4
    29ca:	00004517          	auipc	a0,0x4
    29ce:	53650513          	addi	a0,a0,1334 # 6f00 <malloc+0xf1c>
    29d2:	00003097          	auipc	ra,0x3
    29d6:	55a080e7          	jalr	1370(ra) # 5f2c <printf>
            exit(1);
    29da:	4505                	li	a0,1
    29dc:	00003097          	auipc	ra,0x3
    29e0:	1d6080e7          	jalr	470(ra) # 5bb2 <exit>
        printf("%s: sbrk test fork failed\n", s);
    29e4:	85d2                	mv	a1,s4
    29e6:	00004517          	auipc	a0,0x4
    29ea:	53a50513          	addi	a0,a0,1338 # 6f20 <malloc+0xf3c>
    29ee:	00003097          	auipc	ra,0x3
    29f2:	53e080e7          	jalr	1342(ra) # 5f2c <printf>
        exit(1);
    29f6:	4505                	li	a0,1
    29f8:	00003097          	auipc	ra,0x3
    29fc:	1ba080e7          	jalr	442(ra) # 5bb2 <exit>
    if (pid == 0)
    2a00:	00091763          	bnez	s2,2a0e <sbrkbasic+0x16e>
        exit(0);
    2a04:	4501                	li	a0,0
    2a06:	00003097          	auipc	ra,0x3
    2a0a:	1ac080e7          	jalr	428(ra) # 5bb2 <exit>
    wait(&xstatus);
    2a0e:	fcc40513          	addi	a0,s0,-52
    2a12:	00003097          	auipc	ra,0x3
    2a16:	1a8080e7          	jalr	424(ra) # 5bba <wait>
    exit(xstatus);
    2a1a:	fcc42503          	lw	a0,-52(s0)
    2a1e:	00003097          	auipc	ra,0x3
    2a22:	194080e7          	jalr	404(ra) # 5bb2 <exit>

0000000000002a26 <sbrkmuch>:
{
    2a26:	7179                	addi	sp,sp,-48
    2a28:	f406                	sd	ra,40(sp)
    2a2a:	f022                	sd	s0,32(sp)
    2a2c:	ec26                	sd	s1,24(sp)
    2a2e:	e84a                	sd	s2,16(sp)
    2a30:	e44e                	sd	s3,8(sp)
    2a32:	e052                	sd	s4,0(sp)
    2a34:	1800                	addi	s0,sp,48
    2a36:	89aa                	mv	s3,a0
    oldbrk = sbrk(0);
    2a38:	4501                	li	a0,0
    2a3a:	00003097          	auipc	ra,0x3
    2a3e:	200080e7          	jalr	512(ra) # 5c3a <sbrk>
    2a42:	892a                	mv	s2,a0
    a = sbrk(0);
    2a44:	4501                	li	a0,0
    2a46:	00003097          	auipc	ra,0x3
    2a4a:	1f4080e7          	jalr	500(ra) # 5c3a <sbrk>
    2a4e:	84aa                	mv	s1,a0
    p = sbrk(amt);
    2a50:	06400537          	lui	a0,0x6400
    2a54:	9d05                	subw	a0,a0,s1
    2a56:	00003097          	auipc	ra,0x3
    2a5a:	1e4080e7          	jalr	484(ra) # 5c3a <sbrk>
    if (p != a) {
    2a5e:	0ca49863          	bne	s1,a0,2b2e <sbrkmuch+0x108>
    char *eee = sbrk(0);
    2a62:	4501                	li	a0,0
    2a64:	00003097          	auipc	ra,0x3
    2a68:	1d6080e7          	jalr	470(ra) # 5c3a <sbrk>
    2a6c:	87aa                	mv	a5,a0
    for (char *pp = a; pp < eee; pp += 4096)
    2a6e:	00a4f963          	bgeu	s1,a0,2a80 <sbrkmuch+0x5a>
        *pp = 1;
    2a72:	4685                	li	a3,1
    for (char *pp = a; pp < eee; pp += 4096)
    2a74:	6705                	lui	a4,0x1
        *pp = 1;
    2a76:	00d48023          	sb	a3,0(s1)
    for (char *pp = a; pp < eee; pp += 4096)
    2a7a:	94ba                	add	s1,s1,a4
    2a7c:	fef4ede3          	bltu	s1,a5,2a76 <sbrkmuch+0x50>
    *lastaddr = 99;
    2a80:	064007b7          	lui	a5,0x6400
    2a84:	06300713          	li	a4,99
    2a88:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0387>
    a = sbrk(0);
    2a8c:	4501                	li	a0,0
    2a8e:	00003097          	auipc	ra,0x3
    2a92:	1ac080e7          	jalr	428(ra) # 5c3a <sbrk>
    2a96:	84aa                	mv	s1,a0
    c = sbrk(-PGSIZE);
    2a98:	757d                	lui	a0,0xfffff
    2a9a:	00003097          	auipc	ra,0x3
    2a9e:	1a0080e7          	jalr	416(ra) # 5c3a <sbrk>
    if (c == (char *)0xffffffffffffffffL) {
    2aa2:	57fd                	li	a5,-1
    2aa4:	0af50363          	beq	a0,a5,2b4a <sbrkmuch+0x124>
    c = sbrk(0);
    2aa8:	4501                	li	a0,0
    2aaa:	00003097          	auipc	ra,0x3
    2aae:	190080e7          	jalr	400(ra) # 5c3a <sbrk>
    if (c != a - PGSIZE) {
    2ab2:	77fd                	lui	a5,0xfffff
    2ab4:	97a6                	add	a5,a5,s1
    2ab6:	0af51863          	bne	a0,a5,2b66 <sbrkmuch+0x140>
    a = sbrk(0);
    2aba:	4501                	li	a0,0
    2abc:	00003097          	auipc	ra,0x3
    2ac0:	17e080e7          	jalr	382(ra) # 5c3a <sbrk>
    2ac4:	84aa                	mv	s1,a0
    c = sbrk(PGSIZE);
    2ac6:	6505                	lui	a0,0x1
    2ac8:	00003097          	auipc	ra,0x3
    2acc:	172080e7          	jalr	370(ra) # 5c3a <sbrk>
    2ad0:	8a2a                	mv	s4,a0
    if (c != a || sbrk(0) != a + PGSIZE) {
    2ad2:	0aa49a63          	bne	s1,a0,2b86 <sbrkmuch+0x160>
    2ad6:	4501                	li	a0,0
    2ad8:	00003097          	auipc	ra,0x3
    2adc:	162080e7          	jalr	354(ra) # 5c3a <sbrk>
    2ae0:	6785                	lui	a5,0x1
    2ae2:	97a6                	add	a5,a5,s1
    2ae4:	0af51163          	bne	a0,a5,2b86 <sbrkmuch+0x160>
    if (*lastaddr == 99) {
    2ae8:	064007b7          	lui	a5,0x6400
    2aec:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0387>
    2af0:	06300793          	li	a5,99
    2af4:	0af70963          	beq	a4,a5,2ba6 <sbrkmuch+0x180>
    a = sbrk(0);
    2af8:	4501                	li	a0,0
    2afa:	00003097          	auipc	ra,0x3
    2afe:	140080e7          	jalr	320(ra) # 5c3a <sbrk>
    2b02:	84aa                	mv	s1,a0
    c = sbrk(-(sbrk(0) - oldbrk));
    2b04:	4501                	li	a0,0
    2b06:	00003097          	auipc	ra,0x3
    2b0a:	134080e7          	jalr	308(ra) # 5c3a <sbrk>
    2b0e:	40a9053b          	subw	a0,s2,a0
    2b12:	00003097          	auipc	ra,0x3
    2b16:	128080e7          	jalr	296(ra) # 5c3a <sbrk>
    if (c != a) {
    2b1a:	0aa49463          	bne	s1,a0,2bc2 <sbrkmuch+0x19c>
}
    2b1e:	70a2                	ld	ra,40(sp)
    2b20:	7402                	ld	s0,32(sp)
    2b22:	64e2                	ld	s1,24(sp)
    2b24:	6942                	ld	s2,16(sp)
    2b26:	69a2                	ld	s3,8(sp)
    2b28:	6a02                	ld	s4,0(sp)
    2b2a:	6145                	addi	sp,sp,48
    2b2c:	8082                	ret
        printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2b2e:	85ce                	mv	a1,s3
    2b30:	00004517          	auipc	a0,0x4
    2b34:	43050513          	addi	a0,a0,1072 # 6f60 <malloc+0xf7c>
    2b38:	00003097          	auipc	ra,0x3
    2b3c:	3f4080e7          	jalr	1012(ra) # 5f2c <printf>
        exit(1);
    2b40:	4505                	li	a0,1
    2b42:	00003097          	auipc	ra,0x3
    2b46:	070080e7          	jalr	112(ra) # 5bb2 <exit>
        printf("%s: sbrk could not deallocate\n", s);
    2b4a:	85ce                	mv	a1,s3
    2b4c:	00004517          	auipc	a0,0x4
    2b50:	45c50513          	addi	a0,a0,1116 # 6fa8 <malloc+0xfc4>
    2b54:	00003097          	auipc	ra,0x3
    2b58:	3d8080e7          	jalr	984(ra) # 5f2c <printf>
        exit(1);
    2b5c:	4505                	li	a0,1
    2b5e:	00003097          	auipc	ra,0x3
    2b62:	054080e7          	jalr	84(ra) # 5bb2 <exit>
        printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2b66:	86aa                	mv	a3,a0
    2b68:	8626                	mv	a2,s1
    2b6a:	85ce                	mv	a1,s3
    2b6c:	00004517          	auipc	a0,0x4
    2b70:	45c50513          	addi	a0,a0,1116 # 6fc8 <malloc+0xfe4>
    2b74:	00003097          	auipc	ra,0x3
    2b78:	3b8080e7          	jalr	952(ra) # 5f2c <printf>
        exit(1);
    2b7c:	4505                	li	a0,1
    2b7e:	00003097          	auipc	ra,0x3
    2b82:	034080e7          	jalr	52(ra) # 5bb2 <exit>
        printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2b86:	86d2                	mv	a3,s4
    2b88:	8626                	mv	a2,s1
    2b8a:	85ce                	mv	a1,s3
    2b8c:	00004517          	auipc	a0,0x4
    2b90:	47c50513          	addi	a0,a0,1148 # 7008 <malloc+0x1024>
    2b94:	00003097          	auipc	ra,0x3
    2b98:	398080e7          	jalr	920(ra) # 5f2c <printf>
        exit(1);
    2b9c:	4505                	li	a0,1
    2b9e:	00003097          	auipc	ra,0x3
    2ba2:	014080e7          	jalr	20(ra) # 5bb2 <exit>
        printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2ba6:	85ce                	mv	a1,s3
    2ba8:	00004517          	auipc	a0,0x4
    2bac:	49050513          	addi	a0,a0,1168 # 7038 <malloc+0x1054>
    2bb0:	00003097          	auipc	ra,0x3
    2bb4:	37c080e7          	jalr	892(ra) # 5f2c <printf>
        exit(1);
    2bb8:	4505                	li	a0,1
    2bba:	00003097          	auipc	ra,0x3
    2bbe:	ff8080e7          	jalr	-8(ra) # 5bb2 <exit>
        printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2bc2:	86aa                	mv	a3,a0
    2bc4:	8626                	mv	a2,s1
    2bc6:	85ce                	mv	a1,s3
    2bc8:	00004517          	auipc	a0,0x4
    2bcc:	4a850513          	addi	a0,a0,1192 # 7070 <malloc+0x108c>
    2bd0:	00003097          	auipc	ra,0x3
    2bd4:	35c080e7          	jalr	860(ra) # 5f2c <printf>
        exit(1);
    2bd8:	4505                	li	a0,1
    2bda:	00003097          	auipc	ra,0x3
    2bde:	fd8080e7          	jalr	-40(ra) # 5bb2 <exit>

0000000000002be2 <sbrkarg>:
{
    2be2:	7179                	addi	sp,sp,-48
    2be4:	f406                	sd	ra,40(sp)
    2be6:	f022                	sd	s0,32(sp)
    2be8:	ec26                	sd	s1,24(sp)
    2bea:	e84a                	sd	s2,16(sp)
    2bec:	e44e                	sd	s3,8(sp)
    2bee:	1800                	addi	s0,sp,48
    2bf0:	89aa                	mv	s3,a0
    a = sbrk(PGSIZE);
    2bf2:	6505                	lui	a0,0x1
    2bf4:	00003097          	auipc	ra,0x3
    2bf8:	046080e7          	jalr	70(ra) # 5c3a <sbrk>
    2bfc:	892a                	mv	s2,a0
    fd = open("sbrk", O_CREATE | O_WRONLY);
    2bfe:	20100593          	li	a1,513
    2c02:	00004517          	auipc	a0,0x4
    2c06:	49650513          	addi	a0,a0,1174 # 7098 <malloc+0x10b4>
    2c0a:	00003097          	auipc	ra,0x3
    2c0e:	fe8080e7          	jalr	-24(ra) # 5bf2 <open>
    2c12:	84aa                	mv	s1,a0
    unlink("sbrk");
    2c14:	00004517          	auipc	a0,0x4
    2c18:	48450513          	addi	a0,a0,1156 # 7098 <malloc+0x10b4>
    2c1c:	00003097          	auipc	ra,0x3
    2c20:	fe6080e7          	jalr	-26(ra) # 5c02 <unlink>
    if (fd < 0) {
    2c24:	0404c163          	bltz	s1,2c66 <sbrkarg+0x84>
    if ((n = write(fd, a, PGSIZE)) < 0) {
    2c28:	6605                	lui	a2,0x1
    2c2a:	85ca                	mv	a1,s2
    2c2c:	8526                	mv	a0,s1
    2c2e:	00003097          	auipc	ra,0x3
    2c32:	fa4080e7          	jalr	-92(ra) # 5bd2 <write>
    2c36:	04054663          	bltz	a0,2c82 <sbrkarg+0xa0>
    close(fd);
    2c3a:	8526                	mv	a0,s1
    2c3c:	00003097          	auipc	ra,0x3
    2c40:	f9e080e7          	jalr	-98(ra) # 5bda <close>
    a = sbrk(PGSIZE);
    2c44:	6505                	lui	a0,0x1
    2c46:	00003097          	auipc	ra,0x3
    2c4a:	ff4080e7          	jalr	-12(ra) # 5c3a <sbrk>
    if (pipe((int *)a) != 0) {
    2c4e:	00003097          	auipc	ra,0x3
    2c52:	f74080e7          	jalr	-140(ra) # 5bc2 <pipe>
    2c56:	e521                	bnez	a0,2c9e <sbrkarg+0xbc>
}
    2c58:	70a2                	ld	ra,40(sp)
    2c5a:	7402                	ld	s0,32(sp)
    2c5c:	64e2                	ld	s1,24(sp)
    2c5e:	6942                	ld	s2,16(sp)
    2c60:	69a2                	ld	s3,8(sp)
    2c62:	6145                	addi	sp,sp,48
    2c64:	8082                	ret
        printf("%s: open sbrk failed\n", s);
    2c66:	85ce                	mv	a1,s3
    2c68:	00004517          	auipc	a0,0x4
    2c6c:	43850513          	addi	a0,a0,1080 # 70a0 <malloc+0x10bc>
    2c70:	00003097          	auipc	ra,0x3
    2c74:	2bc080e7          	jalr	700(ra) # 5f2c <printf>
        exit(1);
    2c78:	4505                	li	a0,1
    2c7a:	00003097          	auipc	ra,0x3
    2c7e:	f38080e7          	jalr	-200(ra) # 5bb2 <exit>
        printf("%s: write sbrk failed\n", s);
    2c82:	85ce                	mv	a1,s3
    2c84:	00004517          	auipc	a0,0x4
    2c88:	43450513          	addi	a0,a0,1076 # 70b8 <malloc+0x10d4>
    2c8c:	00003097          	auipc	ra,0x3
    2c90:	2a0080e7          	jalr	672(ra) # 5f2c <printf>
        exit(1);
    2c94:	4505                	li	a0,1
    2c96:	00003097          	auipc	ra,0x3
    2c9a:	f1c080e7          	jalr	-228(ra) # 5bb2 <exit>
        printf("%s: pipe() failed\n", s);
    2c9e:	85ce                	mv	a1,s3
    2ca0:	00004517          	auipc	a0,0x4
    2ca4:	df850513          	addi	a0,a0,-520 # 6a98 <malloc+0xab4>
    2ca8:	00003097          	auipc	ra,0x3
    2cac:	284080e7          	jalr	644(ra) # 5f2c <printf>
        exit(1);
    2cb0:	4505                	li	a0,1
    2cb2:	00003097          	auipc	ra,0x3
    2cb6:	f00080e7          	jalr	-256(ra) # 5bb2 <exit>

0000000000002cba <argptest>:
{
    2cba:	1101                	addi	sp,sp,-32
    2cbc:	ec06                	sd	ra,24(sp)
    2cbe:	e822                	sd	s0,16(sp)
    2cc0:	e426                	sd	s1,8(sp)
    2cc2:	e04a                	sd	s2,0(sp)
    2cc4:	1000                	addi	s0,sp,32
    2cc6:	892a                	mv	s2,a0
    fd = open("init", O_RDONLY);
    2cc8:	4581                	li	a1,0
    2cca:	00004517          	auipc	a0,0x4
    2cce:	40650513          	addi	a0,a0,1030 # 70d0 <malloc+0x10ec>
    2cd2:	00003097          	auipc	ra,0x3
    2cd6:	f20080e7          	jalr	-224(ra) # 5bf2 <open>
    if (fd < 0) {
    2cda:	02054b63          	bltz	a0,2d10 <argptest+0x56>
    2cde:	84aa                	mv	s1,a0
    read(fd, sbrk(0) - 1, -1);
    2ce0:	4501                	li	a0,0
    2ce2:	00003097          	auipc	ra,0x3
    2ce6:	f58080e7          	jalr	-168(ra) # 5c3a <sbrk>
    2cea:	567d                	li	a2,-1
    2cec:	fff50593          	addi	a1,a0,-1
    2cf0:	8526                	mv	a0,s1
    2cf2:	00003097          	auipc	ra,0x3
    2cf6:	ed8080e7          	jalr	-296(ra) # 5bca <read>
    close(fd);
    2cfa:	8526                	mv	a0,s1
    2cfc:	00003097          	auipc	ra,0x3
    2d00:	ede080e7          	jalr	-290(ra) # 5bda <close>
}
    2d04:	60e2                	ld	ra,24(sp)
    2d06:	6442                	ld	s0,16(sp)
    2d08:	64a2                	ld	s1,8(sp)
    2d0a:	6902                	ld	s2,0(sp)
    2d0c:	6105                	addi	sp,sp,32
    2d0e:	8082                	ret
        printf("%s: open failed\n", s);
    2d10:	85ca                	mv	a1,s2
    2d12:	00004517          	auipc	a0,0x4
    2d16:	c9650513          	addi	a0,a0,-874 # 69a8 <malloc+0x9c4>
    2d1a:	00003097          	auipc	ra,0x3
    2d1e:	212080e7          	jalr	530(ra) # 5f2c <printf>
        exit(1);
    2d22:	4505                	li	a0,1
    2d24:	00003097          	auipc	ra,0x3
    2d28:	e8e080e7          	jalr	-370(ra) # 5bb2 <exit>

0000000000002d2c <sbrkbugs>:
{
    2d2c:	1141                	addi	sp,sp,-16
    2d2e:	e406                	sd	ra,8(sp)
    2d30:	e022                	sd	s0,0(sp)
    2d32:	0800                	addi	s0,sp,16
    int pid = fork();
    2d34:	00003097          	auipc	ra,0x3
    2d38:	e76080e7          	jalr	-394(ra) # 5baa <fork>
    if (pid < 0) {
    2d3c:	02054263          	bltz	a0,2d60 <sbrkbugs+0x34>
    if (pid == 0) {
    2d40:	ed0d                	bnez	a0,2d7a <sbrkbugs+0x4e>
        int sz = (uint64)sbrk(0);
    2d42:	00003097          	auipc	ra,0x3
    2d46:	ef8080e7          	jalr	-264(ra) # 5c3a <sbrk>
        sbrk(-sz);
    2d4a:	40a0053b          	negw	a0,a0
    2d4e:	00003097          	auipc	ra,0x3
    2d52:	eec080e7          	jalr	-276(ra) # 5c3a <sbrk>
        exit(0);
    2d56:	4501                	li	a0,0
    2d58:	00003097          	auipc	ra,0x3
    2d5c:	e5a080e7          	jalr	-422(ra) # 5bb2 <exit>
        printf("fork failed\n");
    2d60:	00004517          	auipc	a0,0x4
    2d64:	03850513          	addi	a0,a0,56 # 6d98 <malloc+0xdb4>
    2d68:	00003097          	auipc	ra,0x3
    2d6c:	1c4080e7          	jalr	452(ra) # 5f2c <printf>
        exit(1);
    2d70:	4505                	li	a0,1
    2d72:	00003097          	auipc	ra,0x3
    2d76:	e40080e7          	jalr	-448(ra) # 5bb2 <exit>
    wait(0);
    2d7a:	4501                	li	a0,0
    2d7c:	00003097          	auipc	ra,0x3
    2d80:	e3e080e7          	jalr	-450(ra) # 5bba <wait>
    pid = fork();
    2d84:	00003097          	auipc	ra,0x3
    2d88:	e26080e7          	jalr	-474(ra) # 5baa <fork>
    if (pid < 0) {
    2d8c:	02054563          	bltz	a0,2db6 <sbrkbugs+0x8a>
    if (pid == 0) {
    2d90:	e121                	bnez	a0,2dd0 <sbrkbugs+0xa4>
        int sz = (uint64)sbrk(0);
    2d92:	00003097          	auipc	ra,0x3
    2d96:	ea8080e7          	jalr	-344(ra) # 5c3a <sbrk>
        sbrk(-(sz - 3500));
    2d9a:	6785                	lui	a5,0x1
    2d9c:	dac7879b          	addiw	a5,a5,-596 # dac <unlinkread+0x6e>
    2da0:	40a7853b          	subw	a0,a5,a0
    2da4:	00003097          	auipc	ra,0x3
    2da8:	e96080e7          	jalr	-362(ra) # 5c3a <sbrk>
        exit(0);
    2dac:	4501                	li	a0,0
    2dae:	00003097          	auipc	ra,0x3
    2db2:	e04080e7          	jalr	-508(ra) # 5bb2 <exit>
        printf("fork failed\n");
    2db6:	00004517          	auipc	a0,0x4
    2dba:	fe250513          	addi	a0,a0,-30 # 6d98 <malloc+0xdb4>
    2dbe:	00003097          	auipc	ra,0x3
    2dc2:	16e080e7          	jalr	366(ra) # 5f2c <printf>
        exit(1);
    2dc6:	4505                	li	a0,1
    2dc8:	00003097          	auipc	ra,0x3
    2dcc:	dea080e7          	jalr	-534(ra) # 5bb2 <exit>
    wait(0);
    2dd0:	4501                	li	a0,0
    2dd2:	00003097          	auipc	ra,0x3
    2dd6:	de8080e7          	jalr	-536(ra) # 5bba <wait>
    pid = fork();
    2dda:	00003097          	auipc	ra,0x3
    2dde:	dd0080e7          	jalr	-560(ra) # 5baa <fork>
    if (pid < 0) {
    2de2:	02054a63          	bltz	a0,2e16 <sbrkbugs+0xea>
    if (pid == 0) {
    2de6:	e529                	bnez	a0,2e30 <sbrkbugs+0x104>
        sbrk((10 * 4096 + 2048) - (uint64)sbrk(0));
    2de8:	00003097          	auipc	ra,0x3
    2dec:	e52080e7          	jalr	-430(ra) # 5c3a <sbrk>
    2df0:	67ad                	lui	a5,0xb
    2df2:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x298>
    2df6:	40a7853b          	subw	a0,a5,a0
    2dfa:	00003097          	auipc	ra,0x3
    2dfe:	e40080e7          	jalr	-448(ra) # 5c3a <sbrk>
        sbrk(-10);
    2e02:	5559                	li	a0,-10
    2e04:	00003097          	auipc	ra,0x3
    2e08:	e36080e7          	jalr	-458(ra) # 5c3a <sbrk>
        exit(0);
    2e0c:	4501                	li	a0,0
    2e0e:	00003097          	auipc	ra,0x3
    2e12:	da4080e7          	jalr	-604(ra) # 5bb2 <exit>
        printf("fork failed\n");
    2e16:	00004517          	auipc	a0,0x4
    2e1a:	f8250513          	addi	a0,a0,-126 # 6d98 <malloc+0xdb4>
    2e1e:	00003097          	auipc	ra,0x3
    2e22:	10e080e7          	jalr	270(ra) # 5f2c <printf>
        exit(1);
    2e26:	4505                	li	a0,1
    2e28:	00003097          	auipc	ra,0x3
    2e2c:	d8a080e7          	jalr	-630(ra) # 5bb2 <exit>
    wait(0);
    2e30:	4501                	li	a0,0
    2e32:	00003097          	auipc	ra,0x3
    2e36:	d88080e7          	jalr	-632(ra) # 5bba <wait>
    exit(0);
    2e3a:	4501                	li	a0,0
    2e3c:	00003097          	auipc	ra,0x3
    2e40:	d76080e7          	jalr	-650(ra) # 5bb2 <exit>

0000000000002e44 <sbrklast>:
{
    2e44:	7179                	addi	sp,sp,-48
    2e46:	f406                	sd	ra,40(sp)
    2e48:	f022                	sd	s0,32(sp)
    2e4a:	ec26                	sd	s1,24(sp)
    2e4c:	e84a                	sd	s2,16(sp)
    2e4e:	e44e                	sd	s3,8(sp)
    2e50:	e052                	sd	s4,0(sp)
    2e52:	1800                	addi	s0,sp,48
    uint64 top = (uint64)sbrk(0);
    2e54:	4501                	li	a0,0
    2e56:	00003097          	auipc	ra,0x3
    2e5a:	de4080e7          	jalr	-540(ra) # 5c3a <sbrk>
    if ((top % 4096) != 0)
    2e5e:	03451793          	slli	a5,a0,0x34
    2e62:	ebd9                	bnez	a5,2ef8 <sbrklast+0xb4>
    sbrk(4096);
    2e64:	6505                	lui	a0,0x1
    2e66:	00003097          	auipc	ra,0x3
    2e6a:	dd4080e7          	jalr	-556(ra) # 5c3a <sbrk>
    sbrk(10);
    2e6e:	4529                	li	a0,10
    2e70:	00003097          	auipc	ra,0x3
    2e74:	dca080e7          	jalr	-566(ra) # 5c3a <sbrk>
    sbrk(-20);
    2e78:	5531                	li	a0,-20
    2e7a:	00003097          	auipc	ra,0x3
    2e7e:	dc0080e7          	jalr	-576(ra) # 5c3a <sbrk>
    top = (uint64)sbrk(0);
    2e82:	4501                	li	a0,0
    2e84:	00003097          	auipc	ra,0x3
    2e88:	db6080e7          	jalr	-586(ra) # 5c3a <sbrk>
    2e8c:	84aa                	mv	s1,a0
    char *p = (char *)(top - 64);
    2e8e:	fc050913          	addi	s2,a0,-64 # fc0 <linktest+0xcc>
    p[0] = 'x';
    2e92:	07800a13          	li	s4,120
    2e96:	fd450023          	sb	s4,-64(a0)
    p[1] = '\0';
    2e9a:	fc0500a3          	sb	zero,-63(a0)
    int fd = open(p, O_RDWR | O_CREATE);
    2e9e:	20200593          	li	a1,514
    2ea2:	854a                	mv	a0,s2
    2ea4:	00003097          	auipc	ra,0x3
    2ea8:	d4e080e7          	jalr	-690(ra) # 5bf2 <open>
    2eac:	89aa                	mv	s3,a0
    write(fd, p, 1);
    2eae:	4605                	li	a2,1
    2eb0:	85ca                	mv	a1,s2
    2eb2:	00003097          	auipc	ra,0x3
    2eb6:	d20080e7          	jalr	-736(ra) # 5bd2 <write>
    close(fd);
    2eba:	854e                	mv	a0,s3
    2ebc:	00003097          	auipc	ra,0x3
    2ec0:	d1e080e7          	jalr	-738(ra) # 5bda <close>
    fd = open(p, O_RDWR);
    2ec4:	4589                	li	a1,2
    2ec6:	854a                	mv	a0,s2
    2ec8:	00003097          	auipc	ra,0x3
    2ecc:	d2a080e7          	jalr	-726(ra) # 5bf2 <open>
    p[0] = '\0';
    2ed0:	fc048023          	sb	zero,-64(s1)
    read(fd, p, 1);
    2ed4:	4605                	li	a2,1
    2ed6:	85ca                	mv	a1,s2
    2ed8:	00003097          	auipc	ra,0x3
    2edc:	cf2080e7          	jalr	-782(ra) # 5bca <read>
    if (p[0] != 'x')
    2ee0:	fc04c783          	lbu	a5,-64(s1)
    2ee4:	03479463          	bne	a5,s4,2f0c <sbrklast+0xc8>
}
    2ee8:	70a2                	ld	ra,40(sp)
    2eea:	7402                	ld	s0,32(sp)
    2eec:	64e2                	ld	s1,24(sp)
    2eee:	6942                	ld	s2,16(sp)
    2ef0:	69a2                	ld	s3,8(sp)
    2ef2:	6a02                	ld	s4,0(sp)
    2ef4:	6145                	addi	sp,sp,48
    2ef6:	8082                	ret
        sbrk(4096 - (top % 4096));
    2ef8:	0347d513          	srli	a0,a5,0x34
    2efc:	6785                	lui	a5,0x1
    2efe:	40a7853b          	subw	a0,a5,a0
    2f02:	00003097          	auipc	ra,0x3
    2f06:	d38080e7          	jalr	-712(ra) # 5c3a <sbrk>
    2f0a:	bfa9                	j	2e64 <sbrklast+0x20>
        exit(1);
    2f0c:	4505                	li	a0,1
    2f0e:	00003097          	auipc	ra,0x3
    2f12:	ca4080e7          	jalr	-860(ra) # 5bb2 <exit>

0000000000002f16 <sbrk8000>:
{
    2f16:	1141                	addi	sp,sp,-16
    2f18:	e406                	sd	ra,8(sp)
    2f1a:	e022                	sd	s0,0(sp)
    2f1c:	0800                	addi	s0,sp,16
    sbrk(0x80000004);
    2f1e:	80000537          	lui	a0,0x80000
    2f22:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff038c>
    2f24:	00003097          	auipc	ra,0x3
    2f28:	d16080e7          	jalr	-746(ra) # 5c3a <sbrk>
    volatile char *top = sbrk(0);
    2f2c:	4501                	li	a0,0
    2f2e:	00003097          	auipc	ra,0x3
    2f32:	d0c080e7          	jalr	-756(ra) # 5c3a <sbrk>
    *(top - 1) = *(top - 1) + 1;
    2f36:	fff54783          	lbu	a5,-1(a0)
    2f3a:	2785                	addiw	a5,a5,1 # 1001 <linktest+0x10d>
    2f3c:	0ff7f793          	zext.b	a5,a5
    2f40:	fef50fa3          	sb	a5,-1(a0)
}
    2f44:	60a2                	ld	ra,8(sp)
    2f46:	6402                	ld	s0,0(sp)
    2f48:	0141                	addi	sp,sp,16
    2f4a:	8082                	ret

0000000000002f4c <execout>:
{
    2f4c:	715d                	addi	sp,sp,-80
    2f4e:	e486                	sd	ra,72(sp)
    2f50:	e0a2                	sd	s0,64(sp)
    2f52:	fc26                	sd	s1,56(sp)
    2f54:	f84a                	sd	s2,48(sp)
    2f56:	f44e                	sd	s3,40(sp)
    2f58:	f052                	sd	s4,32(sp)
    2f5a:	0880                	addi	s0,sp,80
    for (int avail = 0; avail < 15; avail++) {
    2f5c:	4901                	li	s2,0
    2f5e:	49bd                	li	s3,15
        int pid = fork();
    2f60:	00003097          	auipc	ra,0x3
    2f64:	c4a080e7          	jalr	-950(ra) # 5baa <fork>
    2f68:	84aa                	mv	s1,a0
        if (pid < 0) {
    2f6a:	02054063          	bltz	a0,2f8a <execout+0x3e>
        else if (pid == 0) {
    2f6e:	c91d                	beqz	a0,2fa4 <execout+0x58>
            wait((int *)0);
    2f70:	4501                	li	a0,0
    2f72:	00003097          	auipc	ra,0x3
    2f76:	c48080e7          	jalr	-952(ra) # 5bba <wait>
    for (int avail = 0; avail < 15; avail++) {
    2f7a:	2905                	addiw	s2,s2,1
    2f7c:	ff3912e3          	bne	s2,s3,2f60 <execout+0x14>
    exit(0);
    2f80:	4501                	li	a0,0
    2f82:	00003097          	auipc	ra,0x3
    2f86:	c30080e7          	jalr	-976(ra) # 5bb2 <exit>
            printf("fork failed\n");
    2f8a:	00004517          	auipc	a0,0x4
    2f8e:	e0e50513          	addi	a0,a0,-498 # 6d98 <malloc+0xdb4>
    2f92:	00003097          	auipc	ra,0x3
    2f96:	f9a080e7          	jalr	-102(ra) # 5f2c <printf>
            exit(1);
    2f9a:	4505                	li	a0,1
    2f9c:	00003097          	auipc	ra,0x3
    2fa0:	c16080e7          	jalr	-1002(ra) # 5bb2 <exit>
                if (a == 0xffffffffffffffffLL)
    2fa4:	59fd                	li	s3,-1
                *(char *)(a + 4096 - 1) = 1;
    2fa6:	4a05                	li	s4,1
                uint64 a = (uint64)sbrk(4096);
    2fa8:	6505                	lui	a0,0x1
    2faa:	00003097          	auipc	ra,0x3
    2fae:	c90080e7          	jalr	-880(ra) # 5c3a <sbrk>
                if (a == 0xffffffffffffffffLL)
    2fb2:	01350763          	beq	a0,s3,2fc0 <execout+0x74>
                *(char *)(a + 4096 - 1) = 1;
    2fb6:	6785                	lui	a5,0x1
    2fb8:	97aa                	add	a5,a5,a0
    2fba:	ff478fa3          	sb	s4,-1(a5) # fff <linktest+0x10b>
            while (1) {
    2fbe:	b7ed                	j	2fa8 <execout+0x5c>
            for (int i = 0; i < avail; i++)
    2fc0:	01205a63          	blez	s2,2fd4 <execout+0x88>
                sbrk(-4096);
    2fc4:	757d                	lui	a0,0xfffff
    2fc6:	00003097          	auipc	ra,0x3
    2fca:	c74080e7          	jalr	-908(ra) # 5c3a <sbrk>
            for (int i = 0; i < avail; i++)
    2fce:	2485                	addiw	s1,s1,1
    2fd0:	ff249ae3          	bne	s1,s2,2fc4 <execout+0x78>
            close(1);
    2fd4:	4505                	li	a0,1
    2fd6:	00003097          	auipc	ra,0x3
    2fda:	c04080e7          	jalr	-1020(ra) # 5bda <close>
            char *args[] = {"echo", "x", 0};
    2fde:	00003517          	auipc	a0,0x3
    2fe2:	12a50513          	addi	a0,a0,298 # 6108 <malloc+0x124>
    2fe6:	faa43c23          	sd	a0,-72(s0)
    2fea:	00003797          	auipc	a5,0x3
    2fee:	18e78793          	addi	a5,a5,398 # 6178 <malloc+0x194>
    2ff2:	fcf43023          	sd	a5,-64(s0)
    2ff6:	fc043423          	sd	zero,-56(s0)
            exec("echo", args);
    2ffa:	fb840593          	addi	a1,s0,-72
    2ffe:	00003097          	auipc	ra,0x3
    3002:	bec080e7          	jalr	-1044(ra) # 5bea <exec>
            exit(0);
    3006:	4501                	li	a0,0
    3008:	00003097          	auipc	ra,0x3
    300c:	baa080e7          	jalr	-1110(ra) # 5bb2 <exit>

0000000000003010 <fourteen>:
{
    3010:	1101                	addi	sp,sp,-32
    3012:	ec06                	sd	ra,24(sp)
    3014:	e822                	sd	s0,16(sp)
    3016:	e426                	sd	s1,8(sp)
    3018:	1000                	addi	s0,sp,32
    301a:	84aa                	mv	s1,a0
    if (mkdir("12345678901234") != 0) {
    301c:	00004517          	auipc	a0,0x4
    3020:	28c50513          	addi	a0,a0,652 # 72a8 <malloc+0x12c4>
    3024:	00003097          	auipc	ra,0x3
    3028:	bf6080e7          	jalr	-1034(ra) # 5c1a <mkdir>
    302c:	e165                	bnez	a0,310c <fourteen+0xfc>
    if (mkdir("12345678901234/123456789012345") != 0) {
    302e:	00004517          	auipc	a0,0x4
    3032:	0d250513          	addi	a0,a0,210 # 7100 <malloc+0x111c>
    3036:	00003097          	auipc	ra,0x3
    303a:	be4080e7          	jalr	-1052(ra) # 5c1a <mkdir>
    303e:	e56d                	bnez	a0,3128 <fourteen+0x118>
    fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    3040:	20000593          	li	a1,512
    3044:	00004517          	auipc	a0,0x4
    3048:	11450513          	addi	a0,a0,276 # 7158 <malloc+0x1174>
    304c:	00003097          	auipc	ra,0x3
    3050:	ba6080e7          	jalr	-1114(ra) # 5bf2 <open>
    if (fd < 0) {
    3054:	0e054863          	bltz	a0,3144 <fourteen+0x134>
    close(fd);
    3058:	00003097          	auipc	ra,0x3
    305c:	b82080e7          	jalr	-1150(ra) # 5bda <close>
    fd = open("12345678901234/12345678901234/12345678901234", 0);
    3060:	4581                	li	a1,0
    3062:	00004517          	auipc	a0,0x4
    3066:	16e50513          	addi	a0,a0,366 # 71d0 <malloc+0x11ec>
    306a:	00003097          	auipc	ra,0x3
    306e:	b88080e7          	jalr	-1144(ra) # 5bf2 <open>
    if (fd < 0) {
    3072:	0e054763          	bltz	a0,3160 <fourteen+0x150>
    close(fd);
    3076:	00003097          	auipc	ra,0x3
    307a:	b64080e7          	jalr	-1180(ra) # 5bda <close>
    if (mkdir("12345678901234/12345678901234") == 0) {
    307e:	00004517          	auipc	a0,0x4
    3082:	1c250513          	addi	a0,a0,450 # 7240 <malloc+0x125c>
    3086:	00003097          	auipc	ra,0x3
    308a:	b94080e7          	jalr	-1132(ra) # 5c1a <mkdir>
    308e:	c57d                	beqz	a0,317c <fourteen+0x16c>
    if (mkdir("123456789012345/12345678901234") == 0) {
    3090:	00004517          	auipc	a0,0x4
    3094:	20850513          	addi	a0,a0,520 # 7298 <malloc+0x12b4>
    3098:	00003097          	auipc	ra,0x3
    309c:	b82080e7          	jalr	-1150(ra) # 5c1a <mkdir>
    30a0:	cd65                	beqz	a0,3198 <fourteen+0x188>
    unlink("123456789012345/12345678901234");
    30a2:	00004517          	auipc	a0,0x4
    30a6:	1f650513          	addi	a0,a0,502 # 7298 <malloc+0x12b4>
    30aa:	00003097          	auipc	ra,0x3
    30ae:	b58080e7          	jalr	-1192(ra) # 5c02 <unlink>
    unlink("12345678901234/12345678901234");
    30b2:	00004517          	auipc	a0,0x4
    30b6:	18e50513          	addi	a0,a0,398 # 7240 <malloc+0x125c>
    30ba:	00003097          	auipc	ra,0x3
    30be:	b48080e7          	jalr	-1208(ra) # 5c02 <unlink>
    unlink("12345678901234/12345678901234/12345678901234");
    30c2:	00004517          	auipc	a0,0x4
    30c6:	10e50513          	addi	a0,a0,270 # 71d0 <malloc+0x11ec>
    30ca:	00003097          	auipc	ra,0x3
    30ce:	b38080e7          	jalr	-1224(ra) # 5c02 <unlink>
    unlink("123456789012345/123456789012345/123456789012345");
    30d2:	00004517          	auipc	a0,0x4
    30d6:	08650513          	addi	a0,a0,134 # 7158 <malloc+0x1174>
    30da:	00003097          	auipc	ra,0x3
    30de:	b28080e7          	jalr	-1240(ra) # 5c02 <unlink>
    unlink("12345678901234/123456789012345");
    30e2:	00004517          	auipc	a0,0x4
    30e6:	01e50513          	addi	a0,a0,30 # 7100 <malloc+0x111c>
    30ea:	00003097          	auipc	ra,0x3
    30ee:	b18080e7          	jalr	-1256(ra) # 5c02 <unlink>
    unlink("12345678901234");
    30f2:	00004517          	auipc	a0,0x4
    30f6:	1b650513          	addi	a0,a0,438 # 72a8 <malloc+0x12c4>
    30fa:	00003097          	auipc	ra,0x3
    30fe:	b08080e7          	jalr	-1272(ra) # 5c02 <unlink>
}
    3102:	60e2                	ld	ra,24(sp)
    3104:	6442                	ld	s0,16(sp)
    3106:	64a2                	ld	s1,8(sp)
    3108:	6105                	addi	sp,sp,32
    310a:	8082                	ret
        printf("%s: mkdir 12345678901234 failed\n", s);
    310c:	85a6                	mv	a1,s1
    310e:	00004517          	auipc	a0,0x4
    3112:	fca50513          	addi	a0,a0,-54 # 70d8 <malloc+0x10f4>
    3116:	00003097          	auipc	ra,0x3
    311a:	e16080e7          	jalr	-490(ra) # 5f2c <printf>
        exit(1);
    311e:	4505                	li	a0,1
    3120:	00003097          	auipc	ra,0x3
    3124:	a92080e7          	jalr	-1390(ra) # 5bb2 <exit>
        printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    3128:	85a6                	mv	a1,s1
    312a:	00004517          	auipc	a0,0x4
    312e:	ff650513          	addi	a0,a0,-10 # 7120 <malloc+0x113c>
    3132:	00003097          	auipc	ra,0x3
    3136:	dfa080e7          	jalr	-518(ra) # 5f2c <printf>
        exit(1);
    313a:	4505                	li	a0,1
    313c:	00003097          	auipc	ra,0x3
    3140:	a76080e7          	jalr	-1418(ra) # 5bb2 <exit>
        printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    3144:	85a6                	mv	a1,s1
    3146:	00004517          	auipc	a0,0x4
    314a:	04250513          	addi	a0,a0,66 # 7188 <malloc+0x11a4>
    314e:	00003097          	auipc	ra,0x3
    3152:	dde080e7          	jalr	-546(ra) # 5f2c <printf>
        exit(1);
    3156:	4505                	li	a0,1
    3158:	00003097          	auipc	ra,0x3
    315c:	a5a080e7          	jalr	-1446(ra) # 5bb2 <exit>
        printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    3160:	85a6                	mv	a1,s1
    3162:	00004517          	auipc	a0,0x4
    3166:	09e50513          	addi	a0,a0,158 # 7200 <malloc+0x121c>
    316a:	00003097          	auipc	ra,0x3
    316e:	dc2080e7          	jalr	-574(ra) # 5f2c <printf>
        exit(1);
    3172:	4505                	li	a0,1
    3174:	00003097          	auipc	ra,0x3
    3178:	a3e080e7          	jalr	-1474(ra) # 5bb2 <exit>
        printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    317c:	85a6                	mv	a1,s1
    317e:	00004517          	auipc	a0,0x4
    3182:	0e250513          	addi	a0,a0,226 # 7260 <malloc+0x127c>
    3186:	00003097          	auipc	ra,0x3
    318a:	da6080e7          	jalr	-602(ra) # 5f2c <printf>
        exit(1);
    318e:	4505                	li	a0,1
    3190:	00003097          	auipc	ra,0x3
    3194:	a22080e7          	jalr	-1502(ra) # 5bb2 <exit>
        printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    3198:	85a6                	mv	a1,s1
    319a:	00004517          	auipc	a0,0x4
    319e:	11e50513          	addi	a0,a0,286 # 72b8 <malloc+0x12d4>
    31a2:	00003097          	auipc	ra,0x3
    31a6:	d8a080e7          	jalr	-630(ra) # 5f2c <printf>
        exit(1);
    31aa:	4505                	li	a0,1
    31ac:	00003097          	auipc	ra,0x3
    31b0:	a06080e7          	jalr	-1530(ra) # 5bb2 <exit>

00000000000031b4 <diskfull>:
{
    31b4:	b9010113          	addi	sp,sp,-1136
    31b8:	46113423          	sd	ra,1128(sp)
    31bc:	46813023          	sd	s0,1120(sp)
    31c0:	44913c23          	sd	s1,1112(sp)
    31c4:	45213823          	sd	s2,1104(sp)
    31c8:	45313423          	sd	s3,1096(sp)
    31cc:	45413023          	sd	s4,1088(sp)
    31d0:	43513c23          	sd	s5,1080(sp)
    31d4:	43613823          	sd	s6,1072(sp)
    31d8:	43713423          	sd	s7,1064(sp)
    31dc:	43813023          	sd	s8,1056(sp)
    31e0:	47010413          	addi	s0,sp,1136
    31e4:	8c2a                	mv	s8,a0
    unlink("diskfulldir");
    31e6:	00004517          	auipc	a0,0x4
    31ea:	10a50513          	addi	a0,a0,266 # 72f0 <malloc+0x130c>
    31ee:	00003097          	auipc	ra,0x3
    31f2:	a14080e7          	jalr	-1516(ra) # 5c02 <unlink>
    for (fi = 0; done == 0; fi++) {
    31f6:	4a01                	li	s4,0
        name[0] = 'b';
    31f8:	06200b13          	li	s6,98
        name[1] = 'i';
    31fc:	06900a93          	li	s5,105
        name[2] = 'g';
    3200:	06700993          	li	s3,103
    3204:	10c00b93          	li	s7,268
    3208:	aabd                	j	3386 <diskfull+0x1d2>
            printf("%s: could not create file %s\n", s, name);
    320a:	b9040613          	addi	a2,s0,-1136
    320e:	85e2                	mv	a1,s8
    3210:	00004517          	auipc	a0,0x4
    3214:	0f050513          	addi	a0,a0,240 # 7300 <malloc+0x131c>
    3218:	00003097          	auipc	ra,0x3
    321c:	d14080e7          	jalr	-748(ra) # 5f2c <printf>
            break;
    3220:	a821                	j	3238 <diskfull+0x84>
                close(fd);
    3222:	854a                	mv	a0,s2
    3224:	00003097          	auipc	ra,0x3
    3228:	9b6080e7          	jalr	-1610(ra) # 5bda <close>
        close(fd);
    322c:	854a                	mv	a0,s2
    322e:	00003097          	auipc	ra,0x3
    3232:	9ac080e7          	jalr	-1620(ra) # 5bda <close>
    for (fi = 0; done == 0; fi++) {
    3236:	2a05                	addiw	s4,s4,1
    for (int i = 0; i < nzz; i++) {
    3238:	4481                	li	s1,0
        name[0] = 'z';
    323a:	07a00913          	li	s2,122
    for (int i = 0; i < nzz; i++) {
    323e:	08000993          	li	s3,128
        name[0] = 'z';
    3242:	bb240823          	sb	s2,-1104(s0)
        name[1] = 'z';
    3246:	bb2408a3          	sb	s2,-1103(s0)
        name[2] = '0' + (i / 32);
    324a:	41f4d71b          	sraiw	a4,s1,0x1f
    324e:	01b7571b          	srliw	a4,a4,0x1b
    3252:	009707bb          	addw	a5,a4,s1
    3256:	4057d69b          	sraiw	a3,a5,0x5
    325a:	0306869b          	addiw	a3,a3,48
    325e:	bad40923          	sb	a3,-1102(s0)
        name[3] = '0' + (i % 32);
    3262:	8bfd                	andi	a5,a5,31
    3264:	9f99                	subw	a5,a5,a4
    3266:	0307879b          	addiw	a5,a5,48
    326a:	baf409a3          	sb	a5,-1101(s0)
        name[4] = '\0';
    326e:	ba040a23          	sb	zero,-1100(s0)
        unlink(name);
    3272:	bb040513          	addi	a0,s0,-1104
    3276:	00003097          	auipc	ra,0x3
    327a:	98c080e7          	jalr	-1652(ra) # 5c02 <unlink>
        int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    327e:	60200593          	li	a1,1538
    3282:	bb040513          	addi	a0,s0,-1104
    3286:	00003097          	auipc	ra,0x3
    328a:	96c080e7          	jalr	-1684(ra) # 5bf2 <open>
        if (fd < 0)
    328e:	00054963          	bltz	a0,32a0 <diskfull+0xec>
        close(fd);
    3292:	00003097          	auipc	ra,0x3
    3296:	948080e7          	jalr	-1720(ra) # 5bda <close>
    for (int i = 0; i < nzz; i++) {
    329a:	2485                	addiw	s1,s1,1
    329c:	fb3493e3          	bne	s1,s3,3242 <diskfull+0x8e>
    if (mkdir("diskfulldir") == 0)
    32a0:	00004517          	auipc	a0,0x4
    32a4:	05050513          	addi	a0,a0,80 # 72f0 <malloc+0x130c>
    32a8:	00003097          	auipc	ra,0x3
    32ac:	972080e7          	jalr	-1678(ra) # 5c1a <mkdir>
    32b0:	12050963          	beqz	a0,33e2 <diskfull+0x22e>
    unlink("diskfulldir");
    32b4:	00004517          	auipc	a0,0x4
    32b8:	03c50513          	addi	a0,a0,60 # 72f0 <malloc+0x130c>
    32bc:	00003097          	auipc	ra,0x3
    32c0:	946080e7          	jalr	-1722(ra) # 5c02 <unlink>
    for (int i = 0; i < nzz; i++) {
    32c4:	4481                	li	s1,0
        name[0] = 'z';
    32c6:	07a00913          	li	s2,122
    for (int i = 0; i < nzz; i++) {
    32ca:	08000993          	li	s3,128
        name[0] = 'z';
    32ce:	bb240823          	sb	s2,-1104(s0)
        name[1] = 'z';
    32d2:	bb2408a3          	sb	s2,-1103(s0)
        name[2] = '0' + (i / 32);
    32d6:	41f4d71b          	sraiw	a4,s1,0x1f
    32da:	01b7571b          	srliw	a4,a4,0x1b
    32de:	009707bb          	addw	a5,a4,s1
    32e2:	4057d69b          	sraiw	a3,a5,0x5
    32e6:	0306869b          	addiw	a3,a3,48
    32ea:	bad40923          	sb	a3,-1102(s0)
        name[3] = '0' + (i % 32);
    32ee:	8bfd                	andi	a5,a5,31
    32f0:	9f99                	subw	a5,a5,a4
    32f2:	0307879b          	addiw	a5,a5,48
    32f6:	baf409a3          	sb	a5,-1101(s0)
        name[4] = '\0';
    32fa:	ba040a23          	sb	zero,-1100(s0)
        unlink(name);
    32fe:	bb040513          	addi	a0,s0,-1104
    3302:	00003097          	auipc	ra,0x3
    3306:	900080e7          	jalr	-1792(ra) # 5c02 <unlink>
    for (int i = 0; i < nzz; i++) {
    330a:	2485                	addiw	s1,s1,1
    330c:	fd3491e3          	bne	s1,s3,32ce <diskfull+0x11a>
    for (int i = 0; i < fi; i++) {
    3310:	03405e63          	blez	s4,334c <diskfull+0x198>
    3314:	4481                	li	s1,0
        name[0] = 'b';
    3316:	06200a93          	li	s5,98
        name[1] = 'i';
    331a:	06900993          	li	s3,105
        name[2] = 'g';
    331e:	06700913          	li	s2,103
        name[0] = 'b';
    3322:	bb540823          	sb	s5,-1104(s0)
        name[1] = 'i';
    3326:	bb3408a3          	sb	s3,-1103(s0)
        name[2] = 'g';
    332a:	bb240923          	sb	s2,-1102(s0)
        name[3] = '0' + i;
    332e:	0304879b          	addiw	a5,s1,48
    3332:	baf409a3          	sb	a5,-1101(s0)
        name[4] = '\0';
    3336:	ba040a23          	sb	zero,-1100(s0)
        unlink(name);
    333a:	bb040513          	addi	a0,s0,-1104
    333e:	00003097          	auipc	ra,0x3
    3342:	8c4080e7          	jalr	-1852(ra) # 5c02 <unlink>
    for (int i = 0; i < fi; i++) {
    3346:	2485                	addiw	s1,s1,1
    3348:	fd449de3          	bne	s1,s4,3322 <diskfull+0x16e>
}
    334c:	46813083          	ld	ra,1128(sp)
    3350:	46013403          	ld	s0,1120(sp)
    3354:	45813483          	ld	s1,1112(sp)
    3358:	45013903          	ld	s2,1104(sp)
    335c:	44813983          	ld	s3,1096(sp)
    3360:	44013a03          	ld	s4,1088(sp)
    3364:	43813a83          	ld	s5,1080(sp)
    3368:	43013b03          	ld	s6,1072(sp)
    336c:	42813b83          	ld	s7,1064(sp)
    3370:	42013c03          	ld	s8,1056(sp)
    3374:	47010113          	addi	sp,sp,1136
    3378:	8082                	ret
        close(fd);
    337a:	854a                	mv	a0,s2
    337c:	00003097          	auipc	ra,0x3
    3380:	85e080e7          	jalr	-1954(ra) # 5bda <close>
    for (fi = 0; done == 0; fi++) {
    3384:	2a05                	addiw	s4,s4,1
        name[0] = 'b';
    3386:	b9640823          	sb	s6,-1136(s0)
        name[1] = 'i';
    338a:	b95408a3          	sb	s5,-1135(s0)
        name[2] = 'g';
    338e:	b9340923          	sb	s3,-1134(s0)
        name[3] = '0' + fi;
    3392:	030a079b          	addiw	a5,s4,48
    3396:	b8f409a3          	sb	a5,-1133(s0)
        name[4] = '\0';
    339a:	b8040a23          	sb	zero,-1132(s0)
        unlink(name);
    339e:	b9040513          	addi	a0,s0,-1136
    33a2:	00003097          	auipc	ra,0x3
    33a6:	860080e7          	jalr	-1952(ra) # 5c02 <unlink>
        int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    33aa:	60200593          	li	a1,1538
    33ae:	b9040513          	addi	a0,s0,-1136
    33b2:	00003097          	auipc	ra,0x3
    33b6:	840080e7          	jalr	-1984(ra) # 5bf2 <open>
    33ba:	892a                	mv	s2,a0
        if (fd < 0) {
    33bc:	e40547e3          	bltz	a0,320a <diskfull+0x56>
    33c0:	84de                	mv	s1,s7
            if (write(fd, buf, BSIZE) != BSIZE) {
    33c2:	40000613          	li	a2,1024
    33c6:	bb040593          	addi	a1,s0,-1104
    33ca:	854a                	mv	a0,s2
    33cc:	00003097          	auipc	ra,0x3
    33d0:	806080e7          	jalr	-2042(ra) # 5bd2 <write>
    33d4:	40000793          	li	a5,1024
    33d8:	e4f515e3          	bne	a0,a5,3222 <diskfull+0x6e>
        for (int i = 0; i < MAXFILE; i++) {
    33dc:	34fd                	addiw	s1,s1,-1
    33de:	f0f5                	bnez	s1,33c2 <diskfull+0x20e>
    33e0:	bf69                	j	337a <diskfull+0x1c6>
        printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    33e2:	00004517          	auipc	a0,0x4
    33e6:	f3e50513          	addi	a0,a0,-194 # 7320 <malloc+0x133c>
    33ea:	00003097          	auipc	ra,0x3
    33ee:	b42080e7          	jalr	-1214(ra) # 5f2c <printf>
    33f2:	b5c9                	j	32b4 <diskfull+0x100>

00000000000033f4 <iputtest>:
{
    33f4:	1101                	addi	sp,sp,-32
    33f6:	ec06                	sd	ra,24(sp)
    33f8:	e822                	sd	s0,16(sp)
    33fa:	e426                	sd	s1,8(sp)
    33fc:	1000                	addi	s0,sp,32
    33fe:	84aa                	mv	s1,a0
    if (mkdir("iputdir") < 0) {
    3400:	00004517          	auipc	a0,0x4
    3404:	f5050513          	addi	a0,a0,-176 # 7350 <malloc+0x136c>
    3408:	00003097          	auipc	ra,0x3
    340c:	812080e7          	jalr	-2030(ra) # 5c1a <mkdir>
    3410:	04054563          	bltz	a0,345a <iputtest+0x66>
    if (chdir("iputdir") < 0) {
    3414:	00004517          	auipc	a0,0x4
    3418:	f3c50513          	addi	a0,a0,-196 # 7350 <malloc+0x136c>
    341c:	00003097          	auipc	ra,0x3
    3420:	806080e7          	jalr	-2042(ra) # 5c22 <chdir>
    3424:	04054963          	bltz	a0,3476 <iputtest+0x82>
    if (unlink("../iputdir") < 0) {
    3428:	00004517          	auipc	a0,0x4
    342c:	f6850513          	addi	a0,a0,-152 # 7390 <malloc+0x13ac>
    3430:	00002097          	auipc	ra,0x2
    3434:	7d2080e7          	jalr	2002(ra) # 5c02 <unlink>
    3438:	04054d63          	bltz	a0,3492 <iputtest+0x9e>
    if (chdir("/") < 0) {
    343c:	00004517          	auipc	a0,0x4
    3440:	f8450513          	addi	a0,a0,-124 # 73c0 <malloc+0x13dc>
    3444:	00002097          	auipc	ra,0x2
    3448:	7de080e7          	jalr	2014(ra) # 5c22 <chdir>
    344c:	06054163          	bltz	a0,34ae <iputtest+0xba>
}
    3450:	60e2                	ld	ra,24(sp)
    3452:	6442                	ld	s0,16(sp)
    3454:	64a2                	ld	s1,8(sp)
    3456:	6105                	addi	sp,sp,32
    3458:	8082                	ret
        printf("%s: mkdir failed\n", s);
    345a:	85a6                	mv	a1,s1
    345c:	00004517          	auipc	a0,0x4
    3460:	efc50513          	addi	a0,a0,-260 # 7358 <malloc+0x1374>
    3464:	00003097          	auipc	ra,0x3
    3468:	ac8080e7          	jalr	-1336(ra) # 5f2c <printf>
        exit(1);
    346c:	4505                	li	a0,1
    346e:	00002097          	auipc	ra,0x2
    3472:	744080e7          	jalr	1860(ra) # 5bb2 <exit>
        printf("%s: chdir iputdir failed\n", s);
    3476:	85a6                	mv	a1,s1
    3478:	00004517          	auipc	a0,0x4
    347c:	ef850513          	addi	a0,a0,-264 # 7370 <malloc+0x138c>
    3480:	00003097          	auipc	ra,0x3
    3484:	aac080e7          	jalr	-1364(ra) # 5f2c <printf>
        exit(1);
    3488:	4505                	li	a0,1
    348a:	00002097          	auipc	ra,0x2
    348e:	728080e7          	jalr	1832(ra) # 5bb2 <exit>
        printf("%s: unlink ../iputdir failed\n", s);
    3492:	85a6                	mv	a1,s1
    3494:	00004517          	auipc	a0,0x4
    3498:	f0c50513          	addi	a0,a0,-244 # 73a0 <malloc+0x13bc>
    349c:	00003097          	auipc	ra,0x3
    34a0:	a90080e7          	jalr	-1392(ra) # 5f2c <printf>
        exit(1);
    34a4:	4505                	li	a0,1
    34a6:	00002097          	auipc	ra,0x2
    34aa:	70c080e7          	jalr	1804(ra) # 5bb2 <exit>
        printf("%s: chdir / failed\n", s);
    34ae:	85a6                	mv	a1,s1
    34b0:	00004517          	auipc	a0,0x4
    34b4:	f1850513          	addi	a0,a0,-232 # 73c8 <malloc+0x13e4>
    34b8:	00003097          	auipc	ra,0x3
    34bc:	a74080e7          	jalr	-1420(ra) # 5f2c <printf>
        exit(1);
    34c0:	4505                	li	a0,1
    34c2:	00002097          	auipc	ra,0x2
    34c6:	6f0080e7          	jalr	1776(ra) # 5bb2 <exit>

00000000000034ca <exitiputtest>:
{
    34ca:	7179                	addi	sp,sp,-48
    34cc:	f406                	sd	ra,40(sp)
    34ce:	f022                	sd	s0,32(sp)
    34d0:	ec26                	sd	s1,24(sp)
    34d2:	1800                	addi	s0,sp,48
    34d4:	84aa                	mv	s1,a0
    pid = fork();
    34d6:	00002097          	auipc	ra,0x2
    34da:	6d4080e7          	jalr	1748(ra) # 5baa <fork>
    if (pid < 0) {
    34de:	04054663          	bltz	a0,352a <exitiputtest+0x60>
    if (pid == 0) {
    34e2:	ed45                	bnez	a0,359a <exitiputtest+0xd0>
        if (mkdir("iputdir") < 0) {
    34e4:	00004517          	auipc	a0,0x4
    34e8:	e6c50513          	addi	a0,a0,-404 # 7350 <malloc+0x136c>
    34ec:	00002097          	auipc	ra,0x2
    34f0:	72e080e7          	jalr	1838(ra) # 5c1a <mkdir>
    34f4:	04054963          	bltz	a0,3546 <exitiputtest+0x7c>
        if (chdir("iputdir") < 0) {
    34f8:	00004517          	auipc	a0,0x4
    34fc:	e5850513          	addi	a0,a0,-424 # 7350 <malloc+0x136c>
    3500:	00002097          	auipc	ra,0x2
    3504:	722080e7          	jalr	1826(ra) # 5c22 <chdir>
    3508:	04054d63          	bltz	a0,3562 <exitiputtest+0x98>
        if (unlink("../iputdir") < 0) {
    350c:	00004517          	auipc	a0,0x4
    3510:	e8450513          	addi	a0,a0,-380 # 7390 <malloc+0x13ac>
    3514:	00002097          	auipc	ra,0x2
    3518:	6ee080e7          	jalr	1774(ra) # 5c02 <unlink>
    351c:	06054163          	bltz	a0,357e <exitiputtest+0xb4>
        exit(0);
    3520:	4501                	li	a0,0
    3522:	00002097          	auipc	ra,0x2
    3526:	690080e7          	jalr	1680(ra) # 5bb2 <exit>
        printf("%s: fork failed\n", s);
    352a:	85a6                	mv	a1,s1
    352c:	00003517          	auipc	a0,0x3
    3530:	46450513          	addi	a0,a0,1124 # 6990 <malloc+0x9ac>
    3534:	00003097          	auipc	ra,0x3
    3538:	9f8080e7          	jalr	-1544(ra) # 5f2c <printf>
        exit(1);
    353c:	4505                	li	a0,1
    353e:	00002097          	auipc	ra,0x2
    3542:	674080e7          	jalr	1652(ra) # 5bb2 <exit>
            printf("%s: mkdir failed\n", s);
    3546:	85a6                	mv	a1,s1
    3548:	00004517          	auipc	a0,0x4
    354c:	e1050513          	addi	a0,a0,-496 # 7358 <malloc+0x1374>
    3550:	00003097          	auipc	ra,0x3
    3554:	9dc080e7          	jalr	-1572(ra) # 5f2c <printf>
            exit(1);
    3558:	4505                	li	a0,1
    355a:	00002097          	auipc	ra,0x2
    355e:	658080e7          	jalr	1624(ra) # 5bb2 <exit>
            printf("%s: child chdir failed\n", s);
    3562:	85a6                	mv	a1,s1
    3564:	00004517          	auipc	a0,0x4
    3568:	e7c50513          	addi	a0,a0,-388 # 73e0 <malloc+0x13fc>
    356c:	00003097          	auipc	ra,0x3
    3570:	9c0080e7          	jalr	-1600(ra) # 5f2c <printf>
            exit(1);
    3574:	4505                	li	a0,1
    3576:	00002097          	auipc	ra,0x2
    357a:	63c080e7          	jalr	1596(ra) # 5bb2 <exit>
            printf("%s: unlink ../iputdir failed\n", s);
    357e:	85a6                	mv	a1,s1
    3580:	00004517          	auipc	a0,0x4
    3584:	e2050513          	addi	a0,a0,-480 # 73a0 <malloc+0x13bc>
    3588:	00003097          	auipc	ra,0x3
    358c:	9a4080e7          	jalr	-1628(ra) # 5f2c <printf>
            exit(1);
    3590:	4505                	li	a0,1
    3592:	00002097          	auipc	ra,0x2
    3596:	620080e7          	jalr	1568(ra) # 5bb2 <exit>
    wait(&xstatus);
    359a:	fdc40513          	addi	a0,s0,-36
    359e:	00002097          	auipc	ra,0x2
    35a2:	61c080e7          	jalr	1564(ra) # 5bba <wait>
    exit(xstatus);
    35a6:	fdc42503          	lw	a0,-36(s0)
    35aa:	00002097          	auipc	ra,0x2
    35ae:	608080e7          	jalr	1544(ra) # 5bb2 <exit>

00000000000035b2 <dirtest>:
{
    35b2:	1101                	addi	sp,sp,-32
    35b4:	ec06                	sd	ra,24(sp)
    35b6:	e822                	sd	s0,16(sp)
    35b8:	e426                	sd	s1,8(sp)
    35ba:	1000                	addi	s0,sp,32
    35bc:	84aa                	mv	s1,a0
    if (mkdir("dir0") < 0) {
    35be:	00004517          	auipc	a0,0x4
    35c2:	e3a50513          	addi	a0,a0,-454 # 73f8 <malloc+0x1414>
    35c6:	00002097          	auipc	ra,0x2
    35ca:	654080e7          	jalr	1620(ra) # 5c1a <mkdir>
    35ce:	04054563          	bltz	a0,3618 <dirtest+0x66>
    if (chdir("dir0") < 0) {
    35d2:	00004517          	auipc	a0,0x4
    35d6:	e2650513          	addi	a0,a0,-474 # 73f8 <malloc+0x1414>
    35da:	00002097          	auipc	ra,0x2
    35de:	648080e7          	jalr	1608(ra) # 5c22 <chdir>
    35e2:	04054963          	bltz	a0,3634 <dirtest+0x82>
    if (chdir("..") < 0) {
    35e6:	00004517          	auipc	a0,0x4
    35ea:	e3250513          	addi	a0,a0,-462 # 7418 <malloc+0x1434>
    35ee:	00002097          	auipc	ra,0x2
    35f2:	634080e7          	jalr	1588(ra) # 5c22 <chdir>
    35f6:	04054d63          	bltz	a0,3650 <dirtest+0x9e>
    if (unlink("dir0") < 0) {
    35fa:	00004517          	auipc	a0,0x4
    35fe:	dfe50513          	addi	a0,a0,-514 # 73f8 <malloc+0x1414>
    3602:	00002097          	auipc	ra,0x2
    3606:	600080e7          	jalr	1536(ra) # 5c02 <unlink>
    360a:	06054163          	bltz	a0,366c <dirtest+0xba>
}
    360e:	60e2                	ld	ra,24(sp)
    3610:	6442                	ld	s0,16(sp)
    3612:	64a2                	ld	s1,8(sp)
    3614:	6105                	addi	sp,sp,32
    3616:	8082                	ret
        printf("%s: mkdir failed\n", s);
    3618:	85a6                	mv	a1,s1
    361a:	00004517          	auipc	a0,0x4
    361e:	d3e50513          	addi	a0,a0,-706 # 7358 <malloc+0x1374>
    3622:	00003097          	auipc	ra,0x3
    3626:	90a080e7          	jalr	-1782(ra) # 5f2c <printf>
        exit(1);
    362a:	4505                	li	a0,1
    362c:	00002097          	auipc	ra,0x2
    3630:	586080e7          	jalr	1414(ra) # 5bb2 <exit>
        printf("%s: chdir dir0 failed\n", s);
    3634:	85a6                	mv	a1,s1
    3636:	00004517          	auipc	a0,0x4
    363a:	dca50513          	addi	a0,a0,-566 # 7400 <malloc+0x141c>
    363e:	00003097          	auipc	ra,0x3
    3642:	8ee080e7          	jalr	-1810(ra) # 5f2c <printf>
        exit(1);
    3646:	4505                	li	a0,1
    3648:	00002097          	auipc	ra,0x2
    364c:	56a080e7          	jalr	1386(ra) # 5bb2 <exit>
        printf("%s: chdir .. failed\n", s);
    3650:	85a6                	mv	a1,s1
    3652:	00004517          	auipc	a0,0x4
    3656:	dce50513          	addi	a0,a0,-562 # 7420 <malloc+0x143c>
    365a:	00003097          	auipc	ra,0x3
    365e:	8d2080e7          	jalr	-1838(ra) # 5f2c <printf>
        exit(1);
    3662:	4505                	li	a0,1
    3664:	00002097          	auipc	ra,0x2
    3668:	54e080e7          	jalr	1358(ra) # 5bb2 <exit>
        printf("%s: unlink dir0 failed\n", s);
    366c:	85a6                	mv	a1,s1
    366e:	00004517          	auipc	a0,0x4
    3672:	dca50513          	addi	a0,a0,-566 # 7438 <malloc+0x1454>
    3676:	00003097          	auipc	ra,0x3
    367a:	8b6080e7          	jalr	-1866(ra) # 5f2c <printf>
        exit(1);
    367e:	4505                	li	a0,1
    3680:	00002097          	auipc	ra,0x2
    3684:	532080e7          	jalr	1330(ra) # 5bb2 <exit>

0000000000003688 <subdir>:
{
    3688:	1101                	addi	sp,sp,-32
    368a:	ec06                	sd	ra,24(sp)
    368c:	e822                	sd	s0,16(sp)
    368e:	e426                	sd	s1,8(sp)
    3690:	e04a                	sd	s2,0(sp)
    3692:	1000                	addi	s0,sp,32
    3694:	892a                	mv	s2,a0
    unlink("ff");
    3696:	00004517          	auipc	a0,0x4
    369a:	eea50513          	addi	a0,a0,-278 # 7580 <malloc+0x159c>
    369e:	00002097          	auipc	ra,0x2
    36a2:	564080e7          	jalr	1380(ra) # 5c02 <unlink>
    if (mkdir("dd") != 0) {
    36a6:	00004517          	auipc	a0,0x4
    36aa:	daa50513          	addi	a0,a0,-598 # 7450 <malloc+0x146c>
    36ae:	00002097          	auipc	ra,0x2
    36b2:	56c080e7          	jalr	1388(ra) # 5c1a <mkdir>
    36b6:	38051663          	bnez	a0,3a42 <subdir+0x3ba>
    fd = open("dd/ff", O_CREATE | O_RDWR);
    36ba:	20200593          	li	a1,514
    36be:	00004517          	auipc	a0,0x4
    36c2:	db250513          	addi	a0,a0,-590 # 7470 <malloc+0x148c>
    36c6:	00002097          	auipc	ra,0x2
    36ca:	52c080e7          	jalr	1324(ra) # 5bf2 <open>
    36ce:	84aa                	mv	s1,a0
    if (fd < 0) {
    36d0:	38054763          	bltz	a0,3a5e <subdir+0x3d6>
    write(fd, "ff", 2);
    36d4:	4609                	li	a2,2
    36d6:	00004597          	auipc	a1,0x4
    36da:	eaa58593          	addi	a1,a1,-342 # 7580 <malloc+0x159c>
    36de:	00002097          	auipc	ra,0x2
    36e2:	4f4080e7          	jalr	1268(ra) # 5bd2 <write>
    close(fd);
    36e6:	8526                	mv	a0,s1
    36e8:	00002097          	auipc	ra,0x2
    36ec:	4f2080e7          	jalr	1266(ra) # 5bda <close>
    if (unlink("dd") >= 0) {
    36f0:	00004517          	auipc	a0,0x4
    36f4:	d6050513          	addi	a0,a0,-672 # 7450 <malloc+0x146c>
    36f8:	00002097          	auipc	ra,0x2
    36fc:	50a080e7          	jalr	1290(ra) # 5c02 <unlink>
    3700:	36055d63          	bgez	a0,3a7a <subdir+0x3f2>
    if (mkdir("/dd/dd") != 0) {
    3704:	00004517          	auipc	a0,0x4
    3708:	dc450513          	addi	a0,a0,-572 # 74c8 <malloc+0x14e4>
    370c:	00002097          	auipc	ra,0x2
    3710:	50e080e7          	jalr	1294(ra) # 5c1a <mkdir>
    3714:	38051163          	bnez	a0,3a96 <subdir+0x40e>
    fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3718:	20200593          	li	a1,514
    371c:	00004517          	auipc	a0,0x4
    3720:	dd450513          	addi	a0,a0,-556 # 74f0 <malloc+0x150c>
    3724:	00002097          	auipc	ra,0x2
    3728:	4ce080e7          	jalr	1230(ra) # 5bf2 <open>
    372c:	84aa                	mv	s1,a0
    if (fd < 0) {
    372e:	38054263          	bltz	a0,3ab2 <subdir+0x42a>
    write(fd, "FF", 2);
    3732:	4609                	li	a2,2
    3734:	00004597          	auipc	a1,0x4
    3738:	dec58593          	addi	a1,a1,-532 # 7520 <malloc+0x153c>
    373c:	00002097          	auipc	ra,0x2
    3740:	496080e7          	jalr	1174(ra) # 5bd2 <write>
    close(fd);
    3744:	8526                	mv	a0,s1
    3746:	00002097          	auipc	ra,0x2
    374a:	494080e7          	jalr	1172(ra) # 5bda <close>
    fd = open("dd/dd/../ff", 0);
    374e:	4581                	li	a1,0
    3750:	00004517          	auipc	a0,0x4
    3754:	dd850513          	addi	a0,a0,-552 # 7528 <malloc+0x1544>
    3758:	00002097          	auipc	ra,0x2
    375c:	49a080e7          	jalr	1178(ra) # 5bf2 <open>
    3760:	84aa                	mv	s1,a0
    if (fd < 0) {
    3762:	36054663          	bltz	a0,3ace <subdir+0x446>
    cc = read(fd, buf, sizeof(buf));
    3766:	660d                	lui	a2,0x3
    3768:	00009597          	auipc	a1,0x9
    376c:	51058593          	addi	a1,a1,1296 # cc78 <buf>
    3770:	00002097          	auipc	ra,0x2
    3774:	45a080e7          	jalr	1114(ra) # 5bca <read>
    if (cc != 2 || buf[0] != 'f') {
    3778:	4789                	li	a5,2
    377a:	36f51863          	bne	a0,a5,3aea <subdir+0x462>
    377e:	00009717          	auipc	a4,0x9
    3782:	4fa74703          	lbu	a4,1274(a4) # cc78 <buf>
    3786:	06600793          	li	a5,102
    378a:	36f71063          	bne	a4,a5,3aea <subdir+0x462>
    close(fd);
    378e:	8526                	mv	a0,s1
    3790:	00002097          	auipc	ra,0x2
    3794:	44a080e7          	jalr	1098(ra) # 5bda <close>
    if (link("dd/dd/ff", "dd/dd/ffff") != 0) {
    3798:	00004597          	auipc	a1,0x4
    379c:	de058593          	addi	a1,a1,-544 # 7578 <malloc+0x1594>
    37a0:	00004517          	auipc	a0,0x4
    37a4:	d5050513          	addi	a0,a0,-688 # 74f0 <malloc+0x150c>
    37a8:	00002097          	auipc	ra,0x2
    37ac:	46a080e7          	jalr	1130(ra) # 5c12 <link>
    37b0:	34051b63          	bnez	a0,3b06 <subdir+0x47e>
    if (unlink("dd/dd/ff") != 0) {
    37b4:	00004517          	auipc	a0,0x4
    37b8:	d3c50513          	addi	a0,a0,-708 # 74f0 <malloc+0x150c>
    37bc:	00002097          	auipc	ra,0x2
    37c0:	446080e7          	jalr	1094(ra) # 5c02 <unlink>
    37c4:	34051f63          	bnez	a0,3b22 <subdir+0x49a>
    if (open("dd/dd/ff", O_RDONLY) >= 0) {
    37c8:	4581                	li	a1,0
    37ca:	00004517          	auipc	a0,0x4
    37ce:	d2650513          	addi	a0,a0,-730 # 74f0 <malloc+0x150c>
    37d2:	00002097          	auipc	ra,0x2
    37d6:	420080e7          	jalr	1056(ra) # 5bf2 <open>
    37da:	36055263          	bgez	a0,3b3e <subdir+0x4b6>
    if (chdir("dd") != 0) {
    37de:	00004517          	auipc	a0,0x4
    37e2:	c7250513          	addi	a0,a0,-910 # 7450 <malloc+0x146c>
    37e6:	00002097          	auipc	ra,0x2
    37ea:	43c080e7          	jalr	1084(ra) # 5c22 <chdir>
    37ee:	36051663          	bnez	a0,3b5a <subdir+0x4d2>
    if (chdir("dd/../../dd") != 0) {
    37f2:	00004517          	auipc	a0,0x4
    37f6:	e1e50513          	addi	a0,a0,-482 # 7610 <malloc+0x162c>
    37fa:	00002097          	auipc	ra,0x2
    37fe:	428080e7          	jalr	1064(ra) # 5c22 <chdir>
    3802:	36051a63          	bnez	a0,3b76 <subdir+0x4ee>
    if (chdir("dd/../../../dd") != 0) {
    3806:	00004517          	auipc	a0,0x4
    380a:	e3a50513          	addi	a0,a0,-454 # 7640 <malloc+0x165c>
    380e:	00002097          	auipc	ra,0x2
    3812:	414080e7          	jalr	1044(ra) # 5c22 <chdir>
    3816:	36051e63          	bnez	a0,3b92 <subdir+0x50a>
    if (chdir("./..") != 0) {
    381a:	00004517          	auipc	a0,0x4
    381e:	e5650513          	addi	a0,a0,-426 # 7670 <malloc+0x168c>
    3822:	00002097          	auipc	ra,0x2
    3826:	400080e7          	jalr	1024(ra) # 5c22 <chdir>
    382a:	38051263          	bnez	a0,3bae <subdir+0x526>
    fd = open("dd/dd/ffff", 0);
    382e:	4581                	li	a1,0
    3830:	00004517          	auipc	a0,0x4
    3834:	d4850513          	addi	a0,a0,-696 # 7578 <malloc+0x1594>
    3838:	00002097          	auipc	ra,0x2
    383c:	3ba080e7          	jalr	954(ra) # 5bf2 <open>
    3840:	84aa                	mv	s1,a0
    if (fd < 0) {
    3842:	38054463          	bltz	a0,3bca <subdir+0x542>
    if (read(fd, buf, sizeof(buf)) != 2) {
    3846:	660d                	lui	a2,0x3
    3848:	00009597          	auipc	a1,0x9
    384c:	43058593          	addi	a1,a1,1072 # cc78 <buf>
    3850:	00002097          	auipc	ra,0x2
    3854:	37a080e7          	jalr	890(ra) # 5bca <read>
    3858:	4789                	li	a5,2
    385a:	38f51663          	bne	a0,a5,3be6 <subdir+0x55e>
    close(fd);
    385e:	8526                	mv	a0,s1
    3860:	00002097          	auipc	ra,0x2
    3864:	37a080e7          	jalr	890(ra) # 5bda <close>
    if (open("dd/dd/ff", O_RDONLY) >= 0) {
    3868:	4581                	li	a1,0
    386a:	00004517          	auipc	a0,0x4
    386e:	c8650513          	addi	a0,a0,-890 # 74f0 <malloc+0x150c>
    3872:	00002097          	auipc	ra,0x2
    3876:	380080e7          	jalr	896(ra) # 5bf2 <open>
    387a:	38055463          	bgez	a0,3c02 <subdir+0x57a>
    if (open("dd/ff/ff", O_CREATE | O_RDWR) >= 0) {
    387e:	20200593          	li	a1,514
    3882:	00004517          	auipc	a0,0x4
    3886:	e7e50513          	addi	a0,a0,-386 # 7700 <malloc+0x171c>
    388a:	00002097          	auipc	ra,0x2
    388e:	368080e7          	jalr	872(ra) # 5bf2 <open>
    3892:	38055663          	bgez	a0,3c1e <subdir+0x596>
    if (open("dd/xx/ff", O_CREATE | O_RDWR) >= 0) {
    3896:	20200593          	li	a1,514
    389a:	00004517          	auipc	a0,0x4
    389e:	e9650513          	addi	a0,a0,-362 # 7730 <malloc+0x174c>
    38a2:	00002097          	auipc	ra,0x2
    38a6:	350080e7          	jalr	848(ra) # 5bf2 <open>
    38aa:	38055863          	bgez	a0,3c3a <subdir+0x5b2>
    if (open("dd", O_CREATE) >= 0) {
    38ae:	20000593          	li	a1,512
    38b2:	00004517          	auipc	a0,0x4
    38b6:	b9e50513          	addi	a0,a0,-1122 # 7450 <malloc+0x146c>
    38ba:	00002097          	auipc	ra,0x2
    38be:	338080e7          	jalr	824(ra) # 5bf2 <open>
    38c2:	38055a63          	bgez	a0,3c56 <subdir+0x5ce>
    if (open("dd", O_RDWR) >= 0) {
    38c6:	4589                	li	a1,2
    38c8:	00004517          	auipc	a0,0x4
    38cc:	b8850513          	addi	a0,a0,-1144 # 7450 <malloc+0x146c>
    38d0:	00002097          	auipc	ra,0x2
    38d4:	322080e7          	jalr	802(ra) # 5bf2 <open>
    38d8:	38055d63          	bgez	a0,3c72 <subdir+0x5ea>
    if (open("dd", O_WRONLY) >= 0) {
    38dc:	4585                	li	a1,1
    38de:	00004517          	auipc	a0,0x4
    38e2:	b7250513          	addi	a0,a0,-1166 # 7450 <malloc+0x146c>
    38e6:	00002097          	auipc	ra,0x2
    38ea:	30c080e7          	jalr	780(ra) # 5bf2 <open>
    38ee:	3a055063          	bgez	a0,3c8e <subdir+0x606>
    if (link("dd/ff/ff", "dd/dd/xx") == 0) {
    38f2:	00004597          	auipc	a1,0x4
    38f6:	ece58593          	addi	a1,a1,-306 # 77c0 <malloc+0x17dc>
    38fa:	00004517          	auipc	a0,0x4
    38fe:	e0650513          	addi	a0,a0,-506 # 7700 <malloc+0x171c>
    3902:	00002097          	auipc	ra,0x2
    3906:	310080e7          	jalr	784(ra) # 5c12 <link>
    390a:	3a050063          	beqz	a0,3caa <subdir+0x622>
    if (link("dd/xx/ff", "dd/dd/xx") == 0) {
    390e:	00004597          	auipc	a1,0x4
    3912:	eb258593          	addi	a1,a1,-334 # 77c0 <malloc+0x17dc>
    3916:	00004517          	auipc	a0,0x4
    391a:	e1a50513          	addi	a0,a0,-486 # 7730 <malloc+0x174c>
    391e:	00002097          	auipc	ra,0x2
    3922:	2f4080e7          	jalr	756(ra) # 5c12 <link>
    3926:	3a050063          	beqz	a0,3cc6 <subdir+0x63e>
    if (link("dd/ff", "dd/dd/ffff") == 0) {
    392a:	00004597          	auipc	a1,0x4
    392e:	c4e58593          	addi	a1,a1,-946 # 7578 <malloc+0x1594>
    3932:	00004517          	auipc	a0,0x4
    3936:	b3e50513          	addi	a0,a0,-1218 # 7470 <malloc+0x148c>
    393a:	00002097          	auipc	ra,0x2
    393e:	2d8080e7          	jalr	728(ra) # 5c12 <link>
    3942:	3a050063          	beqz	a0,3ce2 <subdir+0x65a>
    if (mkdir("dd/ff/ff") == 0) {
    3946:	00004517          	auipc	a0,0x4
    394a:	dba50513          	addi	a0,a0,-582 # 7700 <malloc+0x171c>
    394e:	00002097          	auipc	ra,0x2
    3952:	2cc080e7          	jalr	716(ra) # 5c1a <mkdir>
    3956:	3a050463          	beqz	a0,3cfe <subdir+0x676>
    if (mkdir("dd/xx/ff") == 0) {
    395a:	00004517          	auipc	a0,0x4
    395e:	dd650513          	addi	a0,a0,-554 # 7730 <malloc+0x174c>
    3962:	00002097          	auipc	ra,0x2
    3966:	2b8080e7          	jalr	696(ra) # 5c1a <mkdir>
    396a:	3a050863          	beqz	a0,3d1a <subdir+0x692>
    if (mkdir("dd/dd/ffff") == 0) {
    396e:	00004517          	auipc	a0,0x4
    3972:	c0a50513          	addi	a0,a0,-1014 # 7578 <malloc+0x1594>
    3976:	00002097          	auipc	ra,0x2
    397a:	2a4080e7          	jalr	676(ra) # 5c1a <mkdir>
    397e:	3a050c63          	beqz	a0,3d36 <subdir+0x6ae>
    if (unlink("dd/xx/ff") == 0) {
    3982:	00004517          	auipc	a0,0x4
    3986:	dae50513          	addi	a0,a0,-594 # 7730 <malloc+0x174c>
    398a:	00002097          	auipc	ra,0x2
    398e:	278080e7          	jalr	632(ra) # 5c02 <unlink>
    3992:	3c050063          	beqz	a0,3d52 <subdir+0x6ca>
    if (unlink("dd/ff/ff") == 0) {
    3996:	00004517          	auipc	a0,0x4
    399a:	d6a50513          	addi	a0,a0,-662 # 7700 <malloc+0x171c>
    399e:	00002097          	auipc	ra,0x2
    39a2:	264080e7          	jalr	612(ra) # 5c02 <unlink>
    39a6:	3c050463          	beqz	a0,3d6e <subdir+0x6e6>
    if (chdir("dd/ff") == 0) {
    39aa:	00004517          	auipc	a0,0x4
    39ae:	ac650513          	addi	a0,a0,-1338 # 7470 <malloc+0x148c>
    39b2:	00002097          	auipc	ra,0x2
    39b6:	270080e7          	jalr	624(ra) # 5c22 <chdir>
    39ba:	3c050863          	beqz	a0,3d8a <subdir+0x702>
    if (chdir("dd/xx") == 0) {
    39be:	00004517          	auipc	a0,0x4
    39c2:	f5250513          	addi	a0,a0,-174 # 7910 <malloc+0x192c>
    39c6:	00002097          	auipc	ra,0x2
    39ca:	25c080e7          	jalr	604(ra) # 5c22 <chdir>
    39ce:	3c050c63          	beqz	a0,3da6 <subdir+0x71e>
    if (unlink("dd/dd/ffff") != 0) {
    39d2:	00004517          	auipc	a0,0x4
    39d6:	ba650513          	addi	a0,a0,-1114 # 7578 <malloc+0x1594>
    39da:	00002097          	auipc	ra,0x2
    39de:	228080e7          	jalr	552(ra) # 5c02 <unlink>
    39e2:	3e051063          	bnez	a0,3dc2 <subdir+0x73a>
    if (unlink("dd/ff") != 0) {
    39e6:	00004517          	auipc	a0,0x4
    39ea:	a8a50513          	addi	a0,a0,-1398 # 7470 <malloc+0x148c>
    39ee:	00002097          	auipc	ra,0x2
    39f2:	214080e7          	jalr	532(ra) # 5c02 <unlink>
    39f6:	3e051463          	bnez	a0,3dde <subdir+0x756>
    if (unlink("dd") == 0) {
    39fa:	00004517          	auipc	a0,0x4
    39fe:	a5650513          	addi	a0,a0,-1450 # 7450 <malloc+0x146c>
    3a02:	00002097          	auipc	ra,0x2
    3a06:	200080e7          	jalr	512(ra) # 5c02 <unlink>
    3a0a:	3e050863          	beqz	a0,3dfa <subdir+0x772>
    if (unlink("dd/dd") < 0) {
    3a0e:	00004517          	auipc	a0,0x4
    3a12:	f7250513          	addi	a0,a0,-142 # 7980 <malloc+0x199c>
    3a16:	00002097          	auipc	ra,0x2
    3a1a:	1ec080e7          	jalr	492(ra) # 5c02 <unlink>
    3a1e:	3e054c63          	bltz	a0,3e16 <subdir+0x78e>
    if (unlink("dd") < 0) {
    3a22:	00004517          	auipc	a0,0x4
    3a26:	a2e50513          	addi	a0,a0,-1490 # 7450 <malloc+0x146c>
    3a2a:	00002097          	auipc	ra,0x2
    3a2e:	1d8080e7          	jalr	472(ra) # 5c02 <unlink>
    3a32:	40054063          	bltz	a0,3e32 <subdir+0x7aa>
}
    3a36:	60e2                	ld	ra,24(sp)
    3a38:	6442                	ld	s0,16(sp)
    3a3a:	64a2                	ld	s1,8(sp)
    3a3c:	6902                	ld	s2,0(sp)
    3a3e:	6105                	addi	sp,sp,32
    3a40:	8082                	ret
        printf("%s: mkdir dd failed\n", s);
    3a42:	85ca                	mv	a1,s2
    3a44:	00004517          	auipc	a0,0x4
    3a48:	a1450513          	addi	a0,a0,-1516 # 7458 <malloc+0x1474>
    3a4c:	00002097          	auipc	ra,0x2
    3a50:	4e0080e7          	jalr	1248(ra) # 5f2c <printf>
        exit(1);
    3a54:	4505                	li	a0,1
    3a56:	00002097          	auipc	ra,0x2
    3a5a:	15c080e7          	jalr	348(ra) # 5bb2 <exit>
        printf("%s: create dd/ff failed\n", s);
    3a5e:	85ca                	mv	a1,s2
    3a60:	00004517          	auipc	a0,0x4
    3a64:	a1850513          	addi	a0,a0,-1512 # 7478 <malloc+0x1494>
    3a68:	00002097          	auipc	ra,0x2
    3a6c:	4c4080e7          	jalr	1220(ra) # 5f2c <printf>
        exit(1);
    3a70:	4505                	li	a0,1
    3a72:	00002097          	auipc	ra,0x2
    3a76:	140080e7          	jalr	320(ra) # 5bb2 <exit>
        printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3a7a:	85ca                	mv	a1,s2
    3a7c:	00004517          	auipc	a0,0x4
    3a80:	a1c50513          	addi	a0,a0,-1508 # 7498 <malloc+0x14b4>
    3a84:	00002097          	auipc	ra,0x2
    3a88:	4a8080e7          	jalr	1192(ra) # 5f2c <printf>
        exit(1);
    3a8c:	4505                	li	a0,1
    3a8e:	00002097          	auipc	ra,0x2
    3a92:	124080e7          	jalr	292(ra) # 5bb2 <exit>
        printf("subdir mkdir dd/dd failed\n", s);
    3a96:	85ca                	mv	a1,s2
    3a98:	00004517          	auipc	a0,0x4
    3a9c:	a3850513          	addi	a0,a0,-1480 # 74d0 <malloc+0x14ec>
    3aa0:	00002097          	auipc	ra,0x2
    3aa4:	48c080e7          	jalr	1164(ra) # 5f2c <printf>
        exit(1);
    3aa8:	4505                	li	a0,1
    3aaa:	00002097          	auipc	ra,0x2
    3aae:	108080e7          	jalr	264(ra) # 5bb2 <exit>
        printf("%s: create dd/dd/ff failed\n", s);
    3ab2:	85ca                	mv	a1,s2
    3ab4:	00004517          	auipc	a0,0x4
    3ab8:	a4c50513          	addi	a0,a0,-1460 # 7500 <malloc+0x151c>
    3abc:	00002097          	auipc	ra,0x2
    3ac0:	470080e7          	jalr	1136(ra) # 5f2c <printf>
        exit(1);
    3ac4:	4505                	li	a0,1
    3ac6:	00002097          	auipc	ra,0x2
    3aca:	0ec080e7          	jalr	236(ra) # 5bb2 <exit>
        printf("%s: open dd/dd/../ff failed\n", s);
    3ace:	85ca                	mv	a1,s2
    3ad0:	00004517          	auipc	a0,0x4
    3ad4:	a6850513          	addi	a0,a0,-1432 # 7538 <malloc+0x1554>
    3ad8:	00002097          	auipc	ra,0x2
    3adc:	454080e7          	jalr	1108(ra) # 5f2c <printf>
        exit(1);
    3ae0:	4505                	li	a0,1
    3ae2:	00002097          	auipc	ra,0x2
    3ae6:	0d0080e7          	jalr	208(ra) # 5bb2 <exit>
        printf("%s: dd/dd/../ff wrong content\n", s);
    3aea:	85ca                	mv	a1,s2
    3aec:	00004517          	auipc	a0,0x4
    3af0:	a6c50513          	addi	a0,a0,-1428 # 7558 <malloc+0x1574>
    3af4:	00002097          	auipc	ra,0x2
    3af8:	438080e7          	jalr	1080(ra) # 5f2c <printf>
        exit(1);
    3afc:	4505                	li	a0,1
    3afe:	00002097          	auipc	ra,0x2
    3b02:	0b4080e7          	jalr	180(ra) # 5bb2 <exit>
        printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3b06:	85ca                	mv	a1,s2
    3b08:	00004517          	auipc	a0,0x4
    3b0c:	a8050513          	addi	a0,a0,-1408 # 7588 <malloc+0x15a4>
    3b10:	00002097          	auipc	ra,0x2
    3b14:	41c080e7          	jalr	1052(ra) # 5f2c <printf>
        exit(1);
    3b18:	4505                	li	a0,1
    3b1a:	00002097          	auipc	ra,0x2
    3b1e:	098080e7          	jalr	152(ra) # 5bb2 <exit>
        printf("%s: unlink dd/dd/ff failed\n", s);
    3b22:	85ca                	mv	a1,s2
    3b24:	00004517          	auipc	a0,0x4
    3b28:	a8c50513          	addi	a0,a0,-1396 # 75b0 <malloc+0x15cc>
    3b2c:	00002097          	auipc	ra,0x2
    3b30:	400080e7          	jalr	1024(ra) # 5f2c <printf>
        exit(1);
    3b34:	4505                	li	a0,1
    3b36:	00002097          	auipc	ra,0x2
    3b3a:	07c080e7          	jalr	124(ra) # 5bb2 <exit>
        printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3b3e:	85ca                	mv	a1,s2
    3b40:	00004517          	auipc	a0,0x4
    3b44:	a9050513          	addi	a0,a0,-1392 # 75d0 <malloc+0x15ec>
    3b48:	00002097          	auipc	ra,0x2
    3b4c:	3e4080e7          	jalr	996(ra) # 5f2c <printf>
        exit(1);
    3b50:	4505                	li	a0,1
    3b52:	00002097          	auipc	ra,0x2
    3b56:	060080e7          	jalr	96(ra) # 5bb2 <exit>
        printf("%s: chdir dd failed\n", s);
    3b5a:	85ca                	mv	a1,s2
    3b5c:	00004517          	auipc	a0,0x4
    3b60:	a9c50513          	addi	a0,a0,-1380 # 75f8 <malloc+0x1614>
    3b64:	00002097          	auipc	ra,0x2
    3b68:	3c8080e7          	jalr	968(ra) # 5f2c <printf>
        exit(1);
    3b6c:	4505                	li	a0,1
    3b6e:	00002097          	auipc	ra,0x2
    3b72:	044080e7          	jalr	68(ra) # 5bb2 <exit>
        printf("%s: chdir dd/../../dd failed\n", s);
    3b76:	85ca                	mv	a1,s2
    3b78:	00004517          	auipc	a0,0x4
    3b7c:	aa850513          	addi	a0,a0,-1368 # 7620 <malloc+0x163c>
    3b80:	00002097          	auipc	ra,0x2
    3b84:	3ac080e7          	jalr	940(ra) # 5f2c <printf>
        exit(1);
    3b88:	4505                	li	a0,1
    3b8a:	00002097          	auipc	ra,0x2
    3b8e:	028080e7          	jalr	40(ra) # 5bb2 <exit>
        printf("chdir dd/../../dd failed\n", s);
    3b92:	85ca                	mv	a1,s2
    3b94:	00004517          	auipc	a0,0x4
    3b98:	abc50513          	addi	a0,a0,-1348 # 7650 <malloc+0x166c>
    3b9c:	00002097          	auipc	ra,0x2
    3ba0:	390080e7          	jalr	912(ra) # 5f2c <printf>
        exit(1);
    3ba4:	4505                	li	a0,1
    3ba6:	00002097          	auipc	ra,0x2
    3baa:	00c080e7          	jalr	12(ra) # 5bb2 <exit>
        printf("%s: chdir ./.. failed\n", s);
    3bae:	85ca                	mv	a1,s2
    3bb0:	00004517          	auipc	a0,0x4
    3bb4:	ac850513          	addi	a0,a0,-1336 # 7678 <malloc+0x1694>
    3bb8:	00002097          	auipc	ra,0x2
    3bbc:	374080e7          	jalr	884(ra) # 5f2c <printf>
        exit(1);
    3bc0:	4505                	li	a0,1
    3bc2:	00002097          	auipc	ra,0x2
    3bc6:	ff0080e7          	jalr	-16(ra) # 5bb2 <exit>
        printf("%s: open dd/dd/ffff failed\n", s);
    3bca:	85ca                	mv	a1,s2
    3bcc:	00004517          	auipc	a0,0x4
    3bd0:	ac450513          	addi	a0,a0,-1340 # 7690 <malloc+0x16ac>
    3bd4:	00002097          	auipc	ra,0x2
    3bd8:	358080e7          	jalr	856(ra) # 5f2c <printf>
        exit(1);
    3bdc:	4505                	li	a0,1
    3bde:	00002097          	auipc	ra,0x2
    3be2:	fd4080e7          	jalr	-44(ra) # 5bb2 <exit>
        printf("%s: read dd/dd/ffff wrong len\n", s);
    3be6:	85ca                	mv	a1,s2
    3be8:	00004517          	auipc	a0,0x4
    3bec:	ac850513          	addi	a0,a0,-1336 # 76b0 <malloc+0x16cc>
    3bf0:	00002097          	auipc	ra,0x2
    3bf4:	33c080e7          	jalr	828(ra) # 5f2c <printf>
        exit(1);
    3bf8:	4505                	li	a0,1
    3bfa:	00002097          	auipc	ra,0x2
    3bfe:	fb8080e7          	jalr	-72(ra) # 5bb2 <exit>
        printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3c02:	85ca                	mv	a1,s2
    3c04:	00004517          	auipc	a0,0x4
    3c08:	acc50513          	addi	a0,a0,-1332 # 76d0 <malloc+0x16ec>
    3c0c:	00002097          	auipc	ra,0x2
    3c10:	320080e7          	jalr	800(ra) # 5f2c <printf>
        exit(1);
    3c14:	4505                	li	a0,1
    3c16:	00002097          	auipc	ra,0x2
    3c1a:	f9c080e7          	jalr	-100(ra) # 5bb2 <exit>
        printf("%s: create dd/ff/ff succeeded!\n", s);
    3c1e:	85ca                	mv	a1,s2
    3c20:	00004517          	auipc	a0,0x4
    3c24:	af050513          	addi	a0,a0,-1296 # 7710 <malloc+0x172c>
    3c28:	00002097          	auipc	ra,0x2
    3c2c:	304080e7          	jalr	772(ra) # 5f2c <printf>
        exit(1);
    3c30:	4505                	li	a0,1
    3c32:	00002097          	auipc	ra,0x2
    3c36:	f80080e7          	jalr	-128(ra) # 5bb2 <exit>
        printf("%s: create dd/xx/ff succeeded!\n", s);
    3c3a:	85ca                	mv	a1,s2
    3c3c:	00004517          	auipc	a0,0x4
    3c40:	b0450513          	addi	a0,a0,-1276 # 7740 <malloc+0x175c>
    3c44:	00002097          	auipc	ra,0x2
    3c48:	2e8080e7          	jalr	744(ra) # 5f2c <printf>
        exit(1);
    3c4c:	4505                	li	a0,1
    3c4e:	00002097          	auipc	ra,0x2
    3c52:	f64080e7          	jalr	-156(ra) # 5bb2 <exit>
        printf("%s: create dd succeeded!\n", s);
    3c56:	85ca                	mv	a1,s2
    3c58:	00004517          	auipc	a0,0x4
    3c5c:	b0850513          	addi	a0,a0,-1272 # 7760 <malloc+0x177c>
    3c60:	00002097          	auipc	ra,0x2
    3c64:	2cc080e7          	jalr	716(ra) # 5f2c <printf>
        exit(1);
    3c68:	4505                	li	a0,1
    3c6a:	00002097          	auipc	ra,0x2
    3c6e:	f48080e7          	jalr	-184(ra) # 5bb2 <exit>
        printf("%s: open dd rdwr succeeded!\n", s);
    3c72:	85ca                	mv	a1,s2
    3c74:	00004517          	auipc	a0,0x4
    3c78:	b0c50513          	addi	a0,a0,-1268 # 7780 <malloc+0x179c>
    3c7c:	00002097          	auipc	ra,0x2
    3c80:	2b0080e7          	jalr	688(ra) # 5f2c <printf>
        exit(1);
    3c84:	4505                	li	a0,1
    3c86:	00002097          	auipc	ra,0x2
    3c8a:	f2c080e7          	jalr	-212(ra) # 5bb2 <exit>
        printf("%s: open dd wronly succeeded!\n", s);
    3c8e:	85ca                	mv	a1,s2
    3c90:	00004517          	auipc	a0,0x4
    3c94:	b1050513          	addi	a0,a0,-1264 # 77a0 <malloc+0x17bc>
    3c98:	00002097          	auipc	ra,0x2
    3c9c:	294080e7          	jalr	660(ra) # 5f2c <printf>
        exit(1);
    3ca0:	4505                	li	a0,1
    3ca2:	00002097          	auipc	ra,0x2
    3ca6:	f10080e7          	jalr	-240(ra) # 5bb2 <exit>
        printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3caa:	85ca                	mv	a1,s2
    3cac:	00004517          	auipc	a0,0x4
    3cb0:	b2450513          	addi	a0,a0,-1244 # 77d0 <malloc+0x17ec>
    3cb4:	00002097          	auipc	ra,0x2
    3cb8:	278080e7          	jalr	632(ra) # 5f2c <printf>
        exit(1);
    3cbc:	4505                	li	a0,1
    3cbe:	00002097          	auipc	ra,0x2
    3cc2:	ef4080e7          	jalr	-268(ra) # 5bb2 <exit>
        printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3cc6:	85ca                	mv	a1,s2
    3cc8:	00004517          	auipc	a0,0x4
    3ccc:	b3050513          	addi	a0,a0,-1232 # 77f8 <malloc+0x1814>
    3cd0:	00002097          	auipc	ra,0x2
    3cd4:	25c080e7          	jalr	604(ra) # 5f2c <printf>
        exit(1);
    3cd8:	4505                	li	a0,1
    3cda:	00002097          	auipc	ra,0x2
    3cde:	ed8080e7          	jalr	-296(ra) # 5bb2 <exit>
        printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3ce2:	85ca                	mv	a1,s2
    3ce4:	00004517          	auipc	a0,0x4
    3ce8:	b3c50513          	addi	a0,a0,-1220 # 7820 <malloc+0x183c>
    3cec:	00002097          	auipc	ra,0x2
    3cf0:	240080e7          	jalr	576(ra) # 5f2c <printf>
        exit(1);
    3cf4:	4505                	li	a0,1
    3cf6:	00002097          	auipc	ra,0x2
    3cfa:	ebc080e7          	jalr	-324(ra) # 5bb2 <exit>
        printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3cfe:	85ca                	mv	a1,s2
    3d00:	00004517          	auipc	a0,0x4
    3d04:	b4850513          	addi	a0,a0,-1208 # 7848 <malloc+0x1864>
    3d08:	00002097          	auipc	ra,0x2
    3d0c:	224080e7          	jalr	548(ra) # 5f2c <printf>
        exit(1);
    3d10:	4505                	li	a0,1
    3d12:	00002097          	auipc	ra,0x2
    3d16:	ea0080e7          	jalr	-352(ra) # 5bb2 <exit>
        printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3d1a:	85ca                	mv	a1,s2
    3d1c:	00004517          	auipc	a0,0x4
    3d20:	b4c50513          	addi	a0,a0,-1204 # 7868 <malloc+0x1884>
    3d24:	00002097          	auipc	ra,0x2
    3d28:	208080e7          	jalr	520(ra) # 5f2c <printf>
        exit(1);
    3d2c:	4505                	li	a0,1
    3d2e:	00002097          	auipc	ra,0x2
    3d32:	e84080e7          	jalr	-380(ra) # 5bb2 <exit>
        printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3d36:	85ca                	mv	a1,s2
    3d38:	00004517          	auipc	a0,0x4
    3d3c:	b5050513          	addi	a0,a0,-1200 # 7888 <malloc+0x18a4>
    3d40:	00002097          	auipc	ra,0x2
    3d44:	1ec080e7          	jalr	492(ra) # 5f2c <printf>
        exit(1);
    3d48:	4505                	li	a0,1
    3d4a:	00002097          	auipc	ra,0x2
    3d4e:	e68080e7          	jalr	-408(ra) # 5bb2 <exit>
        printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3d52:	85ca                	mv	a1,s2
    3d54:	00004517          	auipc	a0,0x4
    3d58:	b5c50513          	addi	a0,a0,-1188 # 78b0 <malloc+0x18cc>
    3d5c:	00002097          	auipc	ra,0x2
    3d60:	1d0080e7          	jalr	464(ra) # 5f2c <printf>
        exit(1);
    3d64:	4505                	li	a0,1
    3d66:	00002097          	auipc	ra,0x2
    3d6a:	e4c080e7          	jalr	-436(ra) # 5bb2 <exit>
        printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3d6e:	85ca                	mv	a1,s2
    3d70:	00004517          	auipc	a0,0x4
    3d74:	b6050513          	addi	a0,a0,-1184 # 78d0 <malloc+0x18ec>
    3d78:	00002097          	auipc	ra,0x2
    3d7c:	1b4080e7          	jalr	436(ra) # 5f2c <printf>
        exit(1);
    3d80:	4505                	li	a0,1
    3d82:	00002097          	auipc	ra,0x2
    3d86:	e30080e7          	jalr	-464(ra) # 5bb2 <exit>
        printf("%s: chdir dd/ff succeeded!\n", s);
    3d8a:	85ca                	mv	a1,s2
    3d8c:	00004517          	auipc	a0,0x4
    3d90:	b6450513          	addi	a0,a0,-1180 # 78f0 <malloc+0x190c>
    3d94:	00002097          	auipc	ra,0x2
    3d98:	198080e7          	jalr	408(ra) # 5f2c <printf>
        exit(1);
    3d9c:	4505                	li	a0,1
    3d9e:	00002097          	auipc	ra,0x2
    3da2:	e14080e7          	jalr	-492(ra) # 5bb2 <exit>
        printf("%s: chdir dd/xx succeeded!\n", s);
    3da6:	85ca                	mv	a1,s2
    3da8:	00004517          	auipc	a0,0x4
    3dac:	b7050513          	addi	a0,a0,-1168 # 7918 <malloc+0x1934>
    3db0:	00002097          	auipc	ra,0x2
    3db4:	17c080e7          	jalr	380(ra) # 5f2c <printf>
        exit(1);
    3db8:	4505                	li	a0,1
    3dba:	00002097          	auipc	ra,0x2
    3dbe:	df8080e7          	jalr	-520(ra) # 5bb2 <exit>
        printf("%s: unlink dd/dd/ff failed\n", s);
    3dc2:	85ca                	mv	a1,s2
    3dc4:	00003517          	auipc	a0,0x3
    3dc8:	7ec50513          	addi	a0,a0,2028 # 75b0 <malloc+0x15cc>
    3dcc:	00002097          	auipc	ra,0x2
    3dd0:	160080e7          	jalr	352(ra) # 5f2c <printf>
        exit(1);
    3dd4:	4505                	li	a0,1
    3dd6:	00002097          	auipc	ra,0x2
    3dda:	ddc080e7          	jalr	-548(ra) # 5bb2 <exit>
        printf("%s: unlink dd/ff failed\n", s);
    3dde:	85ca                	mv	a1,s2
    3de0:	00004517          	auipc	a0,0x4
    3de4:	b5850513          	addi	a0,a0,-1192 # 7938 <malloc+0x1954>
    3de8:	00002097          	auipc	ra,0x2
    3dec:	144080e7          	jalr	324(ra) # 5f2c <printf>
        exit(1);
    3df0:	4505                	li	a0,1
    3df2:	00002097          	auipc	ra,0x2
    3df6:	dc0080e7          	jalr	-576(ra) # 5bb2 <exit>
        printf("%s: unlink non-empty dd succeeded!\n", s);
    3dfa:	85ca                	mv	a1,s2
    3dfc:	00004517          	auipc	a0,0x4
    3e00:	b5c50513          	addi	a0,a0,-1188 # 7958 <malloc+0x1974>
    3e04:	00002097          	auipc	ra,0x2
    3e08:	128080e7          	jalr	296(ra) # 5f2c <printf>
        exit(1);
    3e0c:	4505                	li	a0,1
    3e0e:	00002097          	auipc	ra,0x2
    3e12:	da4080e7          	jalr	-604(ra) # 5bb2 <exit>
        printf("%s: unlink dd/dd failed\n", s);
    3e16:	85ca                	mv	a1,s2
    3e18:	00004517          	auipc	a0,0x4
    3e1c:	b7050513          	addi	a0,a0,-1168 # 7988 <malloc+0x19a4>
    3e20:	00002097          	auipc	ra,0x2
    3e24:	10c080e7          	jalr	268(ra) # 5f2c <printf>
        exit(1);
    3e28:	4505                	li	a0,1
    3e2a:	00002097          	auipc	ra,0x2
    3e2e:	d88080e7          	jalr	-632(ra) # 5bb2 <exit>
        printf("%s: unlink dd failed\n", s);
    3e32:	85ca                	mv	a1,s2
    3e34:	00004517          	auipc	a0,0x4
    3e38:	b7450513          	addi	a0,a0,-1164 # 79a8 <malloc+0x19c4>
    3e3c:	00002097          	auipc	ra,0x2
    3e40:	0f0080e7          	jalr	240(ra) # 5f2c <printf>
        exit(1);
    3e44:	4505                	li	a0,1
    3e46:	00002097          	auipc	ra,0x2
    3e4a:	d6c080e7          	jalr	-660(ra) # 5bb2 <exit>

0000000000003e4e <rmdot>:
{
    3e4e:	1101                	addi	sp,sp,-32
    3e50:	ec06                	sd	ra,24(sp)
    3e52:	e822                	sd	s0,16(sp)
    3e54:	e426                	sd	s1,8(sp)
    3e56:	1000                	addi	s0,sp,32
    3e58:	84aa                	mv	s1,a0
    if (mkdir("dots") != 0) {
    3e5a:	00004517          	auipc	a0,0x4
    3e5e:	b6650513          	addi	a0,a0,-1178 # 79c0 <malloc+0x19dc>
    3e62:	00002097          	auipc	ra,0x2
    3e66:	db8080e7          	jalr	-584(ra) # 5c1a <mkdir>
    3e6a:	e549                	bnez	a0,3ef4 <rmdot+0xa6>
    if (chdir("dots") != 0) {
    3e6c:	00004517          	auipc	a0,0x4
    3e70:	b5450513          	addi	a0,a0,-1196 # 79c0 <malloc+0x19dc>
    3e74:	00002097          	auipc	ra,0x2
    3e78:	dae080e7          	jalr	-594(ra) # 5c22 <chdir>
    3e7c:	e951                	bnez	a0,3f10 <rmdot+0xc2>
    if (unlink(".") == 0) {
    3e7e:	00003517          	auipc	a0,0x3
    3e82:	97250513          	addi	a0,a0,-1678 # 67f0 <malloc+0x80c>
    3e86:	00002097          	auipc	ra,0x2
    3e8a:	d7c080e7          	jalr	-644(ra) # 5c02 <unlink>
    3e8e:	cd59                	beqz	a0,3f2c <rmdot+0xde>
    if (unlink("..") == 0) {
    3e90:	00003517          	auipc	a0,0x3
    3e94:	58850513          	addi	a0,a0,1416 # 7418 <malloc+0x1434>
    3e98:	00002097          	auipc	ra,0x2
    3e9c:	d6a080e7          	jalr	-662(ra) # 5c02 <unlink>
    3ea0:	c545                	beqz	a0,3f48 <rmdot+0xfa>
    if (chdir("/") != 0) {
    3ea2:	00003517          	auipc	a0,0x3
    3ea6:	51e50513          	addi	a0,a0,1310 # 73c0 <malloc+0x13dc>
    3eaa:	00002097          	auipc	ra,0x2
    3eae:	d78080e7          	jalr	-648(ra) # 5c22 <chdir>
    3eb2:	e94d                	bnez	a0,3f64 <rmdot+0x116>
    if (unlink("dots/.") == 0) {
    3eb4:	00004517          	auipc	a0,0x4
    3eb8:	b7450513          	addi	a0,a0,-1164 # 7a28 <malloc+0x1a44>
    3ebc:	00002097          	auipc	ra,0x2
    3ec0:	d46080e7          	jalr	-698(ra) # 5c02 <unlink>
    3ec4:	cd55                	beqz	a0,3f80 <rmdot+0x132>
    if (unlink("dots/..") == 0) {
    3ec6:	00004517          	auipc	a0,0x4
    3eca:	b8a50513          	addi	a0,a0,-1142 # 7a50 <malloc+0x1a6c>
    3ece:	00002097          	auipc	ra,0x2
    3ed2:	d34080e7          	jalr	-716(ra) # 5c02 <unlink>
    3ed6:	c179                	beqz	a0,3f9c <rmdot+0x14e>
    if (unlink("dots") != 0) {
    3ed8:	00004517          	auipc	a0,0x4
    3edc:	ae850513          	addi	a0,a0,-1304 # 79c0 <malloc+0x19dc>
    3ee0:	00002097          	auipc	ra,0x2
    3ee4:	d22080e7          	jalr	-734(ra) # 5c02 <unlink>
    3ee8:	e961                	bnez	a0,3fb8 <rmdot+0x16a>
}
    3eea:	60e2                	ld	ra,24(sp)
    3eec:	6442                	ld	s0,16(sp)
    3eee:	64a2                	ld	s1,8(sp)
    3ef0:	6105                	addi	sp,sp,32
    3ef2:	8082                	ret
        printf("%s: mkdir dots failed\n", s);
    3ef4:	85a6                	mv	a1,s1
    3ef6:	00004517          	auipc	a0,0x4
    3efa:	ad250513          	addi	a0,a0,-1326 # 79c8 <malloc+0x19e4>
    3efe:	00002097          	auipc	ra,0x2
    3f02:	02e080e7          	jalr	46(ra) # 5f2c <printf>
        exit(1);
    3f06:	4505                	li	a0,1
    3f08:	00002097          	auipc	ra,0x2
    3f0c:	caa080e7          	jalr	-854(ra) # 5bb2 <exit>
        printf("%s: chdir dots failed\n", s);
    3f10:	85a6                	mv	a1,s1
    3f12:	00004517          	auipc	a0,0x4
    3f16:	ace50513          	addi	a0,a0,-1330 # 79e0 <malloc+0x19fc>
    3f1a:	00002097          	auipc	ra,0x2
    3f1e:	012080e7          	jalr	18(ra) # 5f2c <printf>
        exit(1);
    3f22:	4505                	li	a0,1
    3f24:	00002097          	auipc	ra,0x2
    3f28:	c8e080e7          	jalr	-882(ra) # 5bb2 <exit>
        printf("%s: rm . worked!\n", s);
    3f2c:	85a6                	mv	a1,s1
    3f2e:	00004517          	auipc	a0,0x4
    3f32:	aca50513          	addi	a0,a0,-1334 # 79f8 <malloc+0x1a14>
    3f36:	00002097          	auipc	ra,0x2
    3f3a:	ff6080e7          	jalr	-10(ra) # 5f2c <printf>
        exit(1);
    3f3e:	4505                	li	a0,1
    3f40:	00002097          	auipc	ra,0x2
    3f44:	c72080e7          	jalr	-910(ra) # 5bb2 <exit>
        printf("%s: rm .. worked!\n", s);
    3f48:	85a6                	mv	a1,s1
    3f4a:	00004517          	auipc	a0,0x4
    3f4e:	ac650513          	addi	a0,a0,-1338 # 7a10 <malloc+0x1a2c>
    3f52:	00002097          	auipc	ra,0x2
    3f56:	fda080e7          	jalr	-38(ra) # 5f2c <printf>
        exit(1);
    3f5a:	4505                	li	a0,1
    3f5c:	00002097          	auipc	ra,0x2
    3f60:	c56080e7          	jalr	-938(ra) # 5bb2 <exit>
        printf("%s: chdir / failed\n", s);
    3f64:	85a6                	mv	a1,s1
    3f66:	00003517          	auipc	a0,0x3
    3f6a:	46250513          	addi	a0,a0,1122 # 73c8 <malloc+0x13e4>
    3f6e:	00002097          	auipc	ra,0x2
    3f72:	fbe080e7          	jalr	-66(ra) # 5f2c <printf>
        exit(1);
    3f76:	4505                	li	a0,1
    3f78:	00002097          	auipc	ra,0x2
    3f7c:	c3a080e7          	jalr	-966(ra) # 5bb2 <exit>
        printf("%s: unlink dots/. worked!\n", s);
    3f80:	85a6                	mv	a1,s1
    3f82:	00004517          	auipc	a0,0x4
    3f86:	aae50513          	addi	a0,a0,-1362 # 7a30 <malloc+0x1a4c>
    3f8a:	00002097          	auipc	ra,0x2
    3f8e:	fa2080e7          	jalr	-94(ra) # 5f2c <printf>
        exit(1);
    3f92:	4505                	li	a0,1
    3f94:	00002097          	auipc	ra,0x2
    3f98:	c1e080e7          	jalr	-994(ra) # 5bb2 <exit>
        printf("%s: unlink dots/.. worked!\n", s);
    3f9c:	85a6                	mv	a1,s1
    3f9e:	00004517          	auipc	a0,0x4
    3fa2:	aba50513          	addi	a0,a0,-1350 # 7a58 <malloc+0x1a74>
    3fa6:	00002097          	auipc	ra,0x2
    3faa:	f86080e7          	jalr	-122(ra) # 5f2c <printf>
        exit(1);
    3fae:	4505                	li	a0,1
    3fb0:	00002097          	auipc	ra,0x2
    3fb4:	c02080e7          	jalr	-1022(ra) # 5bb2 <exit>
        printf("%s: unlink dots failed!\n", s);
    3fb8:	85a6                	mv	a1,s1
    3fba:	00004517          	auipc	a0,0x4
    3fbe:	abe50513          	addi	a0,a0,-1346 # 7a78 <malloc+0x1a94>
    3fc2:	00002097          	auipc	ra,0x2
    3fc6:	f6a080e7          	jalr	-150(ra) # 5f2c <printf>
        exit(1);
    3fca:	4505                	li	a0,1
    3fcc:	00002097          	auipc	ra,0x2
    3fd0:	be6080e7          	jalr	-1050(ra) # 5bb2 <exit>

0000000000003fd4 <dirfile>:
{
    3fd4:	1101                	addi	sp,sp,-32
    3fd6:	ec06                	sd	ra,24(sp)
    3fd8:	e822                	sd	s0,16(sp)
    3fda:	e426                	sd	s1,8(sp)
    3fdc:	e04a                	sd	s2,0(sp)
    3fde:	1000                	addi	s0,sp,32
    3fe0:	892a                	mv	s2,a0
    fd = open("dirfile", O_CREATE);
    3fe2:	20000593          	li	a1,512
    3fe6:	00004517          	auipc	a0,0x4
    3fea:	ab250513          	addi	a0,a0,-1358 # 7a98 <malloc+0x1ab4>
    3fee:	00002097          	auipc	ra,0x2
    3ff2:	c04080e7          	jalr	-1020(ra) # 5bf2 <open>
    if (fd < 0) {
    3ff6:	0e054d63          	bltz	a0,40f0 <dirfile+0x11c>
    close(fd);
    3ffa:	00002097          	auipc	ra,0x2
    3ffe:	be0080e7          	jalr	-1056(ra) # 5bda <close>
    if (chdir("dirfile") == 0) {
    4002:	00004517          	auipc	a0,0x4
    4006:	a9650513          	addi	a0,a0,-1386 # 7a98 <malloc+0x1ab4>
    400a:	00002097          	auipc	ra,0x2
    400e:	c18080e7          	jalr	-1000(ra) # 5c22 <chdir>
    4012:	cd6d                	beqz	a0,410c <dirfile+0x138>
    fd = open("dirfile/xx", 0);
    4014:	4581                	li	a1,0
    4016:	00004517          	auipc	a0,0x4
    401a:	aca50513          	addi	a0,a0,-1334 # 7ae0 <malloc+0x1afc>
    401e:	00002097          	auipc	ra,0x2
    4022:	bd4080e7          	jalr	-1068(ra) # 5bf2 <open>
    if (fd >= 0) {
    4026:	10055163          	bgez	a0,4128 <dirfile+0x154>
    fd = open("dirfile/xx", O_CREATE);
    402a:	20000593          	li	a1,512
    402e:	00004517          	auipc	a0,0x4
    4032:	ab250513          	addi	a0,a0,-1358 # 7ae0 <malloc+0x1afc>
    4036:	00002097          	auipc	ra,0x2
    403a:	bbc080e7          	jalr	-1092(ra) # 5bf2 <open>
    if (fd >= 0) {
    403e:	10055363          	bgez	a0,4144 <dirfile+0x170>
    if (mkdir("dirfile/xx") == 0) {
    4042:	00004517          	auipc	a0,0x4
    4046:	a9e50513          	addi	a0,a0,-1378 # 7ae0 <malloc+0x1afc>
    404a:	00002097          	auipc	ra,0x2
    404e:	bd0080e7          	jalr	-1072(ra) # 5c1a <mkdir>
    4052:	10050763          	beqz	a0,4160 <dirfile+0x18c>
    if (unlink("dirfile/xx") == 0) {
    4056:	00004517          	auipc	a0,0x4
    405a:	a8a50513          	addi	a0,a0,-1398 # 7ae0 <malloc+0x1afc>
    405e:	00002097          	auipc	ra,0x2
    4062:	ba4080e7          	jalr	-1116(ra) # 5c02 <unlink>
    4066:	10050b63          	beqz	a0,417c <dirfile+0x1a8>
    if (link("README", "dirfile/xx") == 0) {
    406a:	00004597          	auipc	a1,0x4
    406e:	a7658593          	addi	a1,a1,-1418 # 7ae0 <malloc+0x1afc>
    4072:	00002517          	auipc	a0,0x2
    4076:	26e50513          	addi	a0,a0,622 # 62e0 <malloc+0x2fc>
    407a:	00002097          	auipc	ra,0x2
    407e:	b98080e7          	jalr	-1128(ra) # 5c12 <link>
    4082:	10050b63          	beqz	a0,4198 <dirfile+0x1c4>
    if (unlink("dirfile") != 0) {
    4086:	00004517          	auipc	a0,0x4
    408a:	a1250513          	addi	a0,a0,-1518 # 7a98 <malloc+0x1ab4>
    408e:	00002097          	auipc	ra,0x2
    4092:	b74080e7          	jalr	-1164(ra) # 5c02 <unlink>
    4096:	10051f63          	bnez	a0,41b4 <dirfile+0x1e0>
    fd = open(".", O_RDWR);
    409a:	4589                	li	a1,2
    409c:	00002517          	auipc	a0,0x2
    40a0:	75450513          	addi	a0,a0,1876 # 67f0 <malloc+0x80c>
    40a4:	00002097          	auipc	ra,0x2
    40a8:	b4e080e7          	jalr	-1202(ra) # 5bf2 <open>
    if (fd >= 0) {
    40ac:	12055263          	bgez	a0,41d0 <dirfile+0x1fc>
    fd = open(".", 0);
    40b0:	4581                	li	a1,0
    40b2:	00002517          	auipc	a0,0x2
    40b6:	73e50513          	addi	a0,a0,1854 # 67f0 <malloc+0x80c>
    40ba:	00002097          	auipc	ra,0x2
    40be:	b38080e7          	jalr	-1224(ra) # 5bf2 <open>
    40c2:	84aa                	mv	s1,a0
    if (write(fd, "x", 1) > 0) {
    40c4:	4605                	li	a2,1
    40c6:	00002597          	auipc	a1,0x2
    40ca:	0b258593          	addi	a1,a1,178 # 6178 <malloc+0x194>
    40ce:	00002097          	auipc	ra,0x2
    40d2:	b04080e7          	jalr	-1276(ra) # 5bd2 <write>
    40d6:	10a04b63          	bgtz	a0,41ec <dirfile+0x218>
    close(fd);
    40da:	8526                	mv	a0,s1
    40dc:	00002097          	auipc	ra,0x2
    40e0:	afe080e7          	jalr	-1282(ra) # 5bda <close>
}
    40e4:	60e2                	ld	ra,24(sp)
    40e6:	6442                	ld	s0,16(sp)
    40e8:	64a2                	ld	s1,8(sp)
    40ea:	6902                	ld	s2,0(sp)
    40ec:	6105                	addi	sp,sp,32
    40ee:	8082                	ret
        printf("%s: create dirfile failed\n", s);
    40f0:	85ca                	mv	a1,s2
    40f2:	00004517          	auipc	a0,0x4
    40f6:	9ae50513          	addi	a0,a0,-1618 # 7aa0 <malloc+0x1abc>
    40fa:	00002097          	auipc	ra,0x2
    40fe:	e32080e7          	jalr	-462(ra) # 5f2c <printf>
        exit(1);
    4102:	4505                	li	a0,1
    4104:	00002097          	auipc	ra,0x2
    4108:	aae080e7          	jalr	-1362(ra) # 5bb2 <exit>
        printf("%s: chdir dirfile succeeded!\n", s);
    410c:	85ca                	mv	a1,s2
    410e:	00004517          	auipc	a0,0x4
    4112:	9b250513          	addi	a0,a0,-1614 # 7ac0 <malloc+0x1adc>
    4116:	00002097          	auipc	ra,0x2
    411a:	e16080e7          	jalr	-490(ra) # 5f2c <printf>
        exit(1);
    411e:	4505                	li	a0,1
    4120:	00002097          	auipc	ra,0x2
    4124:	a92080e7          	jalr	-1390(ra) # 5bb2 <exit>
        printf("%s: create dirfile/xx succeeded!\n", s);
    4128:	85ca                	mv	a1,s2
    412a:	00004517          	auipc	a0,0x4
    412e:	9c650513          	addi	a0,a0,-1594 # 7af0 <malloc+0x1b0c>
    4132:	00002097          	auipc	ra,0x2
    4136:	dfa080e7          	jalr	-518(ra) # 5f2c <printf>
        exit(1);
    413a:	4505                	li	a0,1
    413c:	00002097          	auipc	ra,0x2
    4140:	a76080e7          	jalr	-1418(ra) # 5bb2 <exit>
        printf("%s: create dirfile/xx succeeded!\n", s);
    4144:	85ca                	mv	a1,s2
    4146:	00004517          	auipc	a0,0x4
    414a:	9aa50513          	addi	a0,a0,-1622 # 7af0 <malloc+0x1b0c>
    414e:	00002097          	auipc	ra,0x2
    4152:	dde080e7          	jalr	-546(ra) # 5f2c <printf>
        exit(1);
    4156:	4505                	li	a0,1
    4158:	00002097          	auipc	ra,0x2
    415c:	a5a080e7          	jalr	-1446(ra) # 5bb2 <exit>
        printf("%s: mkdir dirfile/xx succeeded!\n", s);
    4160:	85ca                	mv	a1,s2
    4162:	00004517          	auipc	a0,0x4
    4166:	9b650513          	addi	a0,a0,-1610 # 7b18 <malloc+0x1b34>
    416a:	00002097          	auipc	ra,0x2
    416e:	dc2080e7          	jalr	-574(ra) # 5f2c <printf>
        exit(1);
    4172:	4505                	li	a0,1
    4174:	00002097          	auipc	ra,0x2
    4178:	a3e080e7          	jalr	-1474(ra) # 5bb2 <exit>
        printf("%s: unlink dirfile/xx succeeded!\n", s);
    417c:	85ca                	mv	a1,s2
    417e:	00004517          	auipc	a0,0x4
    4182:	9c250513          	addi	a0,a0,-1598 # 7b40 <malloc+0x1b5c>
    4186:	00002097          	auipc	ra,0x2
    418a:	da6080e7          	jalr	-602(ra) # 5f2c <printf>
        exit(1);
    418e:	4505                	li	a0,1
    4190:	00002097          	auipc	ra,0x2
    4194:	a22080e7          	jalr	-1502(ra) # 5bb2 <exit>
        printf("%s: link to dirfile/xx succeeded!\n", s);
    4198:	85ca                	mv	a1,s2
    419a:	00004517          	auipc	a0,0x4
    419e:	9ce50513          	addi	a0,a0,-1586 # 7b68 <malloc+0x1b84>
    41a2:	00002097          	auipc	ra,0x2
    41a6:	d8a080e7          	jalr	-630(ra) # 5f2c <printf>
        exit(1);
    41aa:	4505                	li	a0,1
    41ac:	00002097          	auipc	ra,0x2
    41b0:	a06080e7          	jalr	-1530(ra) # 5bb2 <exit>
        printf("%s: unlink dirfile failed!\n", s);
    41b4:	85ca                	mv	a1,s2
    41b6:	00004517          	auipc	a0,0x4
    41ba:	9da50513          	addi	a0,a0,-1574 # 7b90 <malloc+0x1bac>
    41be:	00002097          	auipc	ra,0x2
    41c2:	d6e080e7          	jalr	-658(ra) # 5f2c <printf>
        exit(1);
    41c6:	4505                	li	a0,1
    41c8:	00002097          	auipc	ra,0x2
    41cc:	9ea080e7          	jalr	-1558(ra) # 5bb2 <exit>
        printf("%s: open . for writing succeeded!\n", s);
    41d0:	85ca                	mv	a1,s2
    41d2:	00004517          	auipc	a0,0x4
    41d6:	9de50513          	addi	a0,a0,-1570 # 7bb0 <malloc+0x1bcc>
    41da:	00002097          	auipc	ra,0x2
    41de:	d52080e7          	jalr	-686(ra) # 5f2c <printf>
        exit(1);
    41e2:	4505                	li	a0,1
    41e4:	00002097          	auipc	ra,0x2
    41e8:	9ce080e7          	jalr	-1586(ra) # 5bb2 <exit>
        printf("%s: write . succeeded!\n", s);
    41ec:	85ca                	mv	a1,s2
    41ee:	00004517          	auipc	a0,0x4
    41f2:	9ea50513          	addi	a0,a0,-1558 # 7bd8 <malloc+0x1bf4>
    41f6:	00002097          	auipc	ra,0x2
    41fa:	d36080e7          	jalr	-714(ra) # 5f2c <printf>
        exit(1);
    41fe:	4505                	li	a0,1
    4200:	00002097          	auipc	ra,0x2
    4204:	9b2080e7          	jalr	-1614(ra) # 5bb2 <exit>

0000000000004208 <iref>:
{
    4208:	7139                	addi	sp,sp,-64
    420a:	fc06                	sd	ra,56(sp)
    420c:	f822                	sd	s0,48(sp)
    420e:	f426                	sd	s1,40(sp)
    4210:	f04a                	sd	s2,32(sp)
    4212:	ec4e                	sd	s3,24(sp)
    4214:	e852                	sd	s4,16(sp)
    4216:	e456                	sd	s5,8(sp)
    4218:	e05a                	sd	s6,0(sp)
    421a:	0080                	addi	s0,sp,64
    421c:	8b2a                	mv	s6,a0
    421e:	03300913          	li	s2,51
        if (mkdir("irefd") != 0) {
    4222:	00004a17          	auipc	s4,0x4
    4226:	9cea0a13          	addi	s4,s4,-1586 # 7bf0 <malloc+0x1c0c>
        mkdir("");
    422a:	00003497          	auipc	s1,0x3
    422e:	4ce48493          	addi	s1,s1,1230 # 76f8 <malloc+0x1714>
        link("README", "");
    4232:	00002a97          	auipc	s5,0x2
    4236:	0aea8a93          	addi	s5,s5,174 # 62e0 <malloc+0x2fc>
        fd = open("xx", O_CREATE);
    423a:	00004997          	auipc	s3,0x4
    423e:	8ae98993          	addi	s3,s3,-1874 # 7ae8 <malloc+0x1b04>
    4242:	a891                	j	4296 <iref+0x8e>
            printf("%s: mkdir irefd failed\n", s);
    4244:	85da                	mv	a1,s6
    4246:	00004517          	auipc	a0,0x4
    424a:	9b250513          	addi	a0,a0,-1614 # 7bf8 <malloc+0x1c14>
    424e:	00002097          	auipc	ra,0x2
    4252:	cde080e7          	jalr	-802(ra) # 5f2c <printf>
            exit(1);
    4256:	4505                	li	a0,1
    4258:	00002097          	auipc	ra,0x2
    425c:	95a080e7          	jalr	-1702(ra) # 5bb2 <exit>
            printf("%s: chdir irefd failed\n", s);
    4260:	85da                	mv	a1,s6
    4262:	00004517          	auipc	a0,0x4
    4266:	9ae50513          	addi	a0,a0,-1618 # 7c10 <malloc+0x1c2c>
    426a:	00002097          	auipc	ra,0x2
    426e:	cc2080e7          	jalr	-830(ra) # 5f2c <printf>
            exit(1);
    4272:	4505                	li	a0,1
    4274:	00002097          	auipc	ra,0x2
    4278:	93e080e7          	jalr	-1730(ra) # 5bb2 <exit>
            close(fd);
    427c:	00002097          	auipc	ra,0x2
    4280:	95e080e7          	jalr	-1698(ra) # 5bda <close>
    4284:	a889                	j	42d6 <iref+0xce>
        unlink("xx");
    4286:	854e                	mv	a0,s3
    4288:	00002097          	auipc	ra,0x2
    428c:	97a080e7          	jalr	-1670(ra) # 5c02 <unlink>
    for (i = 0; i < NINODE + 1; i++) {
    4290:	397d                	addiw	s2,s2,-1
    4292:	06090063          	beqz	s2,42f2 <iref+0xea>
        if (mkdir("irefd") != 0) {
    4296:	8552                	mv	a0,s4
    4298:	00002097          	auipc	ra,0x2
    429c:	982080e7          	jalr	-1662(ra) # 5c1a <mkdir>
    42a0:	f155                	bnez	a0,4244 <iref+0x3c>
        if (chdir("irefd") != 0) {
    42a2:	8552                	mv	a0,s4
    42a4:	00002097          	auipc	ra,0x2
    42a8:	97e080e7          	jalr	-1666(ra) # 5c22 <chdir>
    42ac:	f955                	bnez	a0,4260 <iref+0x58>
        mkdir("");
    42ae:	8526                	mv	a0,s1
    42b0:	00002097          	auipc	ra,0x2
    42b4:	96a080e7          	jalr	-1686(ra) # 5c1a <mkdir>
        link("README", "");
    42b8:	85a6                	mv	a1,s1
    42ba:	8556                	mv	a0,s5
    42bc:	00002097          	auipc	ra,0x2
    42c0:	956080e7          	jalr	-1706(ra) # 5c12 <link>
        fd = open("", O_CREATE);
    42c4:	20000593          	li	a1,512
    42c8:	8526                	mv	a0,s1
    42ca:	00002097          	auipc	ra,0x2
    42ce:	928080e7          	jalr	-1752(ra) # 5bf2 <open>
        if (fd >= 0)
    42d2:	fa0555e3          	bgez	a0,427c <iref+0x74>
        fd = open("xx", O_CREATE);
    42d6:	20000593          	li	a1,512
    42da:	854e                	mv	a0,s3
    42dc:	00002097          	auipc	ra,0x2
    42e0:	916080e7          	jalr	-1770(ra) # 5bf2 <open>
        if (fd >= 0)
    42e4:	fa0541e3          	bltz	a0,4286 <iref+0x7e>
            close(fd);
    42e8:	00002097          	auipc	ra,0x2
    42ec:	8f2080e7          	jalr	-1806(ra) # 5bda <close>
    42f0:	bf59                	j	4286 <iref+0x7e>
    42f2:	03300493          	li	s1,51
        chdir("..");
    42f6:	00003997          	auipc	s3,0x3
    42fa:	12298993          	addi	s3,s3,290 # 7418 <malloc+0x1434>
        unlink("irefd");
    42fe:	00004917          	auipc	s2,0x4
    4302:	8f290913          	addi	s2,s2,-1806 # 7bf0 <malloc+0x1c0c>
        chdir("..");
    4306:	854e                	mv	a0,s3
    4308:	00002097          	auipc	ra,0x2
    430c:	91a080e7          	jalr	-1766(ra) # 5c22 <chdir>
        unlink("irefd");
    4310:	854a                	mv	a0,s2
    4312:	00002097          	auipc	ra,0x2
    4316:	8f0080e7          	jalr	-1808(ra) # 5c02 <unlink>
    for (i = 0; i < NINODE + 1; i++) {
    431a:	34fd                	addiw	s1,s1,-1
    431c:	f4ed                	bnez	s1,4306 <iref+0xfe>
    chdir("/");
    431e:	00003517          	auipc	a0,0x3
    4322:	0a250513          	addi	a0,a0,162 # 73c0 <malloc+0x13dc>
    4326:	00002097          	auipc	ra,0x2
    432a:	8fc080e7          	jalr	-1796(ra) # 5c22 <chdir>
}
    432e:	70e2                	ld	ra,56(sp)
    4330:	7442                	ld	s0,48(sp)
    4332:	74a2                	ld	s1,40(sp)
    4334:	7902                	ld	s2,32(sp)
    4336:	69e2                	ld	s3,24(sp)
    4338:	6a42                	ld	s4,16(sp)
    433a:	6aa2                	ld	s5,8(sp)
    433c:	6b02                	ld	s6,0(sp)
    433e:	6121                	addi	sp,sp,64
    4340:	8082                	ret

0000000000004342 <openiputtest>:
{
    4342:	7179                	addi	sp,sp,-48
    4344:	f406                	sd	ra,40(sp)
    4346:	f022                	sd	s0,32(sp)
    4348:	ec26                	sd	s1,24(sp)
    434a:	1800                	addi	s0,sp,48
    434c:	84aa                	mv	s1,a0
    if (mkdir("oidir") < 0) {
    434e:	00004517          	auipc	a0,0x4
    4352:	8da50513          	addi	a0,a0,-1830 # 7c28 <malloc+0x1c44>
    4356:	00002097          	auipc	ra,0x2
    435a:	8c4080e7          	jalr	-1852(ra) # 5c1a <mkdir>
    435e:	04054263          	bltz	a0,43a2 <openiputtest+0x60>
    pid = fork();
    4362:	00002097          	auipc	ra,0x2
    4366:	848080e7          	jalr	-1976(ra) # 5baa <fork>
    if (pid < 0) {
    436a:	04054a63          	bltz	a0,43be <openiputtest+0x7c>
    if (pid == 0) {
    436e:	e93d                	bnez	a0,43e4 <openiputtest+0xa2>
        int fd = open("oidir", O_RDWR);
    4370:	4589                	li	a1,2
    4372:	00004517          	auipc	a0,0x4
    4376:	8b650513          	addi	a0,a0,-1866 # 7c28 <malloc+0x1c44>
    437a:	00002097          	auipc	ra,0x2
    437e:	878080e7          	jalr	-1928(ra) # 5bf2 <open>
        if (fd >= 0) {
    4382:	04054c63          	bltz	a0,43da <openiputtest+0x98>
            printf("%s: open directory for write succeeded\n", s);
    4386:	85a6                	mv	a1,s1
    4388:	00004517          	auipc	a0,0x4
    438c:	8c050513          	addi	a0,a0,-1856 # 7c48 <malloc+0x1c64>
    4390:	00002097          	auipc	ra,0x2
    4394:	b9c080e7          	jalr	-1124(ra) # 5f2c <printf>
            exit(1);
    4398:	4505                	li	a0,1
    439a:	00002097          	auipc	ra,0x2
    439e:	818080e7          	jalr	-2024(ra) # 5bb2 <exit>
        printf("%s: mkdir oidir failed\n", s);
    43a2:	85a6                	mv	a1,s1
    43a4:	00004517          	auipc	a0,0x4
    43a8:	88c50513          	addi	a0,a0,-1908 # 7c30 <malloc+0x1c4c>
    43ac:	00002097          	auipc	ra,0x2
    43b0:	b80080e7          	jalr	-1152(ra) # 5f2c <printf>
        exit(1);
    43b4:	4505                	li	a0,1
    43b6:	00001097          	auipc	ra,0x1
    43ba:	7fc080e7          	jalr	2044(ra) # 5bb2 <exit>
        printf("%s: fork failed\n", s);
    43be:	85a6                	mv	a1,s1
    43c0:	00002517          	auipc	a0,0x2
    43c4:	5d050513          	addi	a0,a0,1488 # 6990 <malloc+0x9ac>
    43c8:	00002097          	auipc	ra,0x2
    43cc:	b64080e7          	jalr	-1180(ra) # 5f2c <printf>
        exit(1);
    43d0:	4505                	li	a0,1
    43d2:	00001097          	auipc	ra,0x1
    43d6:	7e0080e7          	jalr	2016(ra) # 5bb2 <exit>
        exit(0);
    43da:	4501                	li	a0,0
    43dc:	00001097          	auipc	ra,0x1
    43e0:	7d6080e7          	jalr	2006(ra) # 5bb2 <exit>
    sleep(1);
    43e4:	4505                	li	a0,1
    43e6:	00002097          	auipc	ra,0x2
    43ea:	85c080e7          	jalr	-1956(ra) # 5c42 <sleep>
    if (unlink("oidir") != 0) {
    43ee:	00004517          	auipc	a0,0x4
    43f2:	83a50513          	addi	a0,a0,-1990 # 7c28 <malloc+0x1c44>
    43f6:	00002097          	auipc	ra,0x2
    43fa:	80c080e7          	jalr	-2036(ra) # 5c02 <unlink>
    43fe:	cd19                	beqz	a0,441c <openiputtest+0xda>
        printf("%s: unlink failed\n", s);
    4400:	85a6                	mv	a1,s1
    4402:	00002517          	auipc	a0,0x2
    4406:	77e50513          	addi	a0,a0,1918 # 6b80 <malloc+0xb9c>
    440a:	00002097          	auipc	ra,0x2
    440e:	b22080e7          	jalr	-1246(ra) # 5f2c <printf>
        exit(1);
    4412:	4505                	li	a0,1
    4414:	00001097          	auipc	ra,0x1
    4418:	79e080e7          	jalr	1950(ra) # 5bb2 <exit>
    wait(&xstatus);
    441c:	fdc40513          	addi	a0,s0,-36
    4420:	00001097          	auipc	ra,0x1
    4424:	79a080e7          	jalr	1946(ra) # 5bba <wait>
    exit(xstatus);
    4428:	fdc42503          	lw	a0,-36(s0)
    442c:	00001097          	auipc	ra,0x1
    4430:	786080e7          	jalr	1926(ra) # 5bb2 <exit>

0000000000004434 <forkforkfork>:
{
    4434:	1101                	addi	sp,sp,-32
    4436:	ec06                	sd	ra,24(sp)
    4438:	e822                	sd	s0,16(sp)
    443a:	e426                	sd	s1,8(sp)
    443c:	1000                	addi	s0,sp,32
    443e:	84aa                	mv	s1,a0
    unlink("stopforking");
    4440:	00004517          	auipc	a0,0x4
    4444:	83050513          	addi	a0,a0,-2000 # 7c70 <malloc+0x1c8c>
    4448:	00001097          	auipc	ra,0x1
    444c:	7ba080e7          	jalr	1978(ra) # 5c02 <unlink>
    int pid = fork();
    4450:	00001097          	auipc	ra,0x1
    4454:	75a080e7          	jalr	1882(ra) # 5baa <fork>
    if (pid < 0) {
    4458:	04054563          	bltz	a0,44a2 <forkforkfork+0x6e>
    if (pid == 0) {
    445c:	c12d                	beqz	a0,44be <forkforkfork+0x8a>
    sleep(20); // two seconds
    445e:	4551                	li	a0,20
    4460:	00001097          	auipc	ra,0x1
    4464:	7e2080e7          	jalr	2018(ra) # 5c42 <sleep>
    close(open("stopforking", O_CREATE | O_RDWR));
    4468:	20200593          	li	a1,514
    446c:	00004517          	auipc	a0,0x4
    4470:	80450513          	addi	a0,a0,-2044 # 7c70 <malloc+0x1c8c>
    4474:	00001097          	auipc	ra,0x1
    4478:	77e080e7          	jalr	1918(ra) # 5bf2 <open>
    447c:	00001097          	auipc	ra,0x1
    4480:	75e080e7          	jalr	1886(ra) # 5bda <close>
    wait(0);
    4484:	4501                	li	a0,0
    4486:	00001097          	auipc	ra,0x1
    448a:	734080e7          	jalr	1844(ra) # 5bba <wait>
    sleep(10); // one second
    448e:	4529                	li	a0,10
    4490:	00001097          	auipc	ra,0x1
    4494:	7b2080e7          	jalr	1970(ra) # 5c42 <sleep>
}
    4498:	60e2                	ld	ra,24(sp)
    449a:	6442                	ld	s0,16(sp)
    449c:	64a2                	ld	s1,8(sp)
    449e:	6105                	addi	sp,sp,32
    44a0:	8082                	ret
        printf("%s: fork failed", s);
    44a2:	85a6                	mv	a1,s1
    44a4:	00002517          	auipc	a0,0x2
    44a8:	6ac50513          	addi	a0,a0,1708 # 6b50 <malloc+0xb6c>
    44ac:	00002097          	auipc	ra,0x2
    44b0:	a80080e7          	jalr	-1408(ra) # 5f2c <printf>
        exit(1);
    44b4:	4505                	li	a0,1
    44b6:	00001097          	auipc	ra,0x1
    44ba:	6fc080e7          	jalr	1788(ra) # 5bb2 <exit>
            int fd = open("stopforking", 0);
    44be:	00003497          	auipc	s1,0x3
    44c2:	7b248493          	addi	s1,s1,1970 # 7c70 <malloc+0x1c8c>
    44c6:	4581                	li	a1,0
    44c8:	8526                	mv	a0,s1
    44ca:	00001097          	auipc	ra,0x1
    44ce:	728080e7          	jalr	1832(ra) # 5bf2 <open>
            if (fd >= 0) {
    44d2:	02055463          	bgez	a0,44fa <forkforkfork+0xc6>
            if (fork() < 0) {
    44d6:	00001097          	auipc	ra,0x1
    44da:	6d4080e7          	jalr	1748(ra) # 5baa <fork>
    44de:	fe0554e3          	bgez	a0,44c6 <forkforkfork+0x92>
                close(open("stopforking", O_CREATE | O_RDWR));
    44e2:	20200593          	li	a1,514
    44e6:	8526                	mv	a0,s1
    44e8:	00001097          	auipc	ra,0x1
    44ec:	70a080e7          	jalr	1802(ra) # 5bf2 <open>
    44f0:	00001097          	auipc	ra,0x1
    44f4:	6ea080e7          	jalr	1770(ra) # 5bda <close>
    44f8:	b7f9                	j	44c6 <forkforkfork+0x92>
                exit(0);
    44fa:	4501                	li	a0,0
    44fc:	00001097          	auipc	ra,0x1
    4500:	6b6080e7          	jalr	1718(ra) # 5bb2 <exit>

0000000000004504 <killstatus>:
{
    4504:	7139                	addi	sp,sp,-64
    4506:	fc06                	sd	ra,56(sp)
    4508:	f822                	sd	s0,48(sp)
    450a:	f426                	sd	s1,40(sp)
    450c:	f04a                	sd	s2,32(sp)
    450e:	ec4e                	sd	s3,24(sp)
    4510:	e852                	sd	s4,16(sp)
    4512:	0080                	addi	s0,sp,64
    4514:	8a2a                	mv	s4,a0
    4516:	06400913          	li	s2,100
        if (xst != -1) {
    451a:	59fd                	li	s3,-1
        int pid1 = fork();
    451c:	00001097          	auipc	ra,0x1
    4520:	68e080e7          	jalr	1678(ra) # 5baa <fork>
    4524:	84aa                	mv	s1,a0
        if (pid1 < 0) {
    4526:	02054f63          	bltz	a0,4564 <killstatus+0x60>
        if (pid1 == 0) {
    452a:	c939                	beqz	a0,4580 <killstatus+0x7c>
        sleep(1);
    452c:	4505                	li	a0,1
    452e:	00001097          	auipc	ra,0x1
    4532:	714080e7          	jalr	1812(ra) # 5c42 <sleep>
        kill(pid1);
    4536:	8526                	mv	a0,s1
    4538:	00001097          	auipc	ra,0x1
    453c:	6aa080e7          	jalr	1706(ra) # 5be2 <kill>
        wait(&xst);
    4540:	fcc40513          	addi	a0,s0,-52
    4544:	00001097          	auipc	ra,0x1
    4548:	676080e7          	jalr	1654(ra) # 5bba <wait>
        if (xst != -1) {
    454c:	fcc42783          	lw	a5,-52(s0)
    4550:	03379d63          	bne	a5,s3,458a <killstatus+0x86>
    for (int i = 0; i < 100; i++) {
    4554:	397d                	addiw	s2,s2,-1
    4556:	fc0913e3          	bnez	s2,451c <killstatus+0x18>
    exit(0);
    455a:	4501                	li	a0,0
    455c:	00001097          	auipc	ra,0x1
    4560:	656080e7          	jalr	1622(ra) # 5bb2 <exit>
            printf("%s: fork failed\n", s);
    4564:	85d2                	mv	a1,s4
    4566:	00002517          	auipc	a0,0x2
    456a:	42a50513          	addi	a0,a0,1066 # 6990 <malloc+0x9ac>
    456e:	00002097          	auipc	ra,0x2
    4572:	9be080e7          	jalr	-1602(ra) # 5f2c <printf>
            exit(1);
    4576:	4505                	li	a0,1
    4578:	00001097          	auipc	ra,0x1
    457c:	63a080e7          	jalr	1594(ra) # 5bb2 <exit>
                getpid();
    4580:	00001097          	auipc	ra,0x1
    4584:	6b2080e7          	jalr	1714(ra) # 5c32 <getpid>
            while (1) {
    4588:	bfe5                	j	4580 <killstatus+0x7c>
            printf("%s: status should be -1\n", s);
    458a:	85d2                	mv	a1,s4
    458c:	00003517          	auipc	a0,0x3
    4590:	6f450513          	addi	a0,a0,1780 # 7c80 <malloc+0x1c9c>
    4594:	00002097          	auipc	ra,0x2
    4598:	998080e7          	jalr	-1640(ra) # 5f2c <printf>
            exit(1);
    459c:	4505                	li	a0,1
    459e:	00001097          	auipc	ra,0x1
    45a2:	614080e7          	jalr	1556(ra) # 5bb2 <exit>

00000000000045a6 <preempt>:
{
    45a6:	7139                	addi	sp,sp,-64
    45a8:	fc06                	sd	ra,56(sp)
    45aa:	f822                	sd	s0,48(sp)
    45ac:	f426                	sd	s1,40(sp)
    45ae:	f04a                	sd	s2,32(sp)
    45b0:	ec4e                	sd	s3,24(sp)
    45b2:	e852                	sd	s4,16(sp)
    45b4:	0080                	addi	s0,sp,64
    45b6:	892a                	mv	s2,a0
    pid1 = fork();
    45b8:	00001097          	auipc	ra,0x1
    45bc:	5f2080e7          	jalr	1522(ra) # 5baa <fork>
    if (pid1 < 0) {
    45c0:	00054563          	bltz	a0,45ca <preempt+0x24>
    45c4:	84aa                	mv	s1,a0
    if (pid1 == 0)
    45c6:	e105                	bnez	a0,45e6 <preempt+0x40>
        for (;;)
    45c8:	a001                	j	45c8 <preempt+0x22>
        printf("%s: fork failed", s);
    45ca:	85ca                	mv	a1,s2
    45cc:	00002517          	auipc	a0,0x2
    45d0:	58450513          	addi	a0,a0,1412 # 6b50 <malloc+0xb6c>
    45d4:	00002097          	auipc	ra,0x2
    45d8:	958080e7          	jalr	-1704(ra) # 5f2c <printf>
        exit(1);
    45dc:	4505                	li	a0,1
    45de:	00001097          	auipc	ra,0x1
    45e2:	5d4080e7          	jalr	1492(ra) # 5bb2 <exit>
    pid2 = fork();
    45e6:	00001097          	auipc	ra,0x1
    45ea:	5c4080e7          	jalr	1476(ra) # 5baa <fork>
    45ee:	89aa                	mv	s3,a0
    if (pid2 < 0) {
    45f0:	00054463          	bltz	a0,45f8 <preempt+0x52>
    if (pid2 == 0)
    45f4:	e105                	bnez	a0,4614 <preempt+0x6e>
        for (;;)
    45f6:	a001                	j	45f6 <preempt+0x50>
        printf("%s: fork failed\n", s);
    45f8:	85ca                	mv	a1,s2
    45fa:	00002517          	auipc	a0,0x2
    45fe:	39650513          	addi	a0,a0,918 # 6990 <malloc+0x9ac>
    4602:	00002097          	auipc	ra,0x2
    4606:	92a080e7          	jalr	-1750(ra) # 5f2c <printf>
        exit(1);
    460a:	4505                	li	a0,1
    460c:	00001097          	auipc	ra,0x1
    4610:	5a6080e7          	jalr	1446(ra) # 5bb2 <exit>
    pipe(pfds);
    4614:	fc840513          	addi	a0,s0,-56
    4618:	00001097          	auipc	ra,0x1
    461c:	5aa080e7          	jalr	1450(ra) # 5bc2 <pipe>
    pid3 = fork();
    4620:	00001097          	auipc	ra,0x1
    4624:	58a080e7          	jalr	1418(ra) # 5baa <fork>
    4628:	8a2a                	mv	s4,a0
    if (pid3 < 0) {
    462a:	02054e63          	bltz	a0,4666 <preempt+0xc0>
    if (pid3 == 0) {
    462e:	e525                	bnez	a0,4696 <preempt+0xf0>
        close(pfds[0]);
    4630:	fc842503          	lw	a0,-56(s0)
    4634:	00001097          	auipc	ra,0x1
    4638:	5a6080e7          	jalr	1446(ra) # 5bda <close>
        if (write(pfds[1], "x", 1) != 1)
    463c:	4605                	li	a2,1
    463e:	00002597          	auipc	a1,0x2
    4642:	b3a58593          	addi	a1,a1,-1222 # 6178 <malloc+0x194>
    4646:	fcc42503          	lw	a0,-52(s0)
    464a:	00001097          	auipc	ra,0x1
    464e:	588080e7          	jalr	1416(ra) # 5bd2 <write>
    4652:	4785                	li	a5,1
    4654:	02f51763          	bne	a0,a5,4682 <preempt+0xdc>
        close(pfds[1]);
    4658:	fcc42503          	lw	a0,-52(s0)
    465c:	00001097          	auipc	ra,0x1
    4660:	57e080e7          	jalr	1406(ra) # 5bda <close>
        for (;;)
    4664:	a001                	j	4664 <preempt+0xbe>
        printf("%s: fork failed\n", s);
    4666:	85ca                	mv	a1,s2
    4668:	00002517          	auipc	a0,0x2
    466c:	32850513          	addi	a0,a0,808 # 6990 <malloc+0x9ac>
    4670:	00002097          	auipc	ra,0x2
    4674:	8bc080e7          	jalr	-1860(ra) # 5f2c <printf>
        exit(1);
    4678:	4505                	li	a0,1
    467a:	00001097          	auipc	ra,0x1
    467e:	538080e7          	jalr	1336(ra) # 5bb2 <exit>
            printf("%s: preempt write error", s);
    4682:	85ca                	mv	a1,s2
    4684:	00003517          	auipc	a0,0x3
    4688:	61c50513          	addi	a0,a0,1564 # 7ca0 <malloc+0x1cbc>
    468c:	00002097          	auipc	ra,0x2
    4690:	8a0080e7          	jalr	-1888(ra) # 5f2c <printf>
    4694:	b7d1                	j	4658 <preempt+0xb2>
    close(pfds[1]);
    4696:	fcc42503          	lw	a0,-52(s0)
    469a:	00001097          	auipc	ra,0x1
    469e:	540080e7          	jalr	1344(ra) # 5bda <close>
    if (read(pfds[0], buf, sizeof(buf)) != 1) {
    46a2:	660d                	lui	a2,0x3
    46a4:	00008597          	auipc	a1,0x8
    46a8:	5d458593          	addi	a1,a1,1492 # cc78 <buf>
    46ac:	fc842503          	lw	a0,-56(s0)
    46b0:	00001097          	auipc	ra,0x1
    46b4:	51a080e7          	jalr	1306(ra) # 5bca <read>
    46b8:	4785                	li	a5,1
    46ba:	02f50363          	beq	a0,a5,46e0 <preempt+0x13a>
        printf("%s: preempt read error", s);
    46be:	85ca                	mv	a1,s2
    46c0:	00003517          	auipc	a0,0x3
    46c4:	5f850513          	addi	a0,a0,1528 # 7cb8 <malloc+0x1cd4>
    46c8:	00002097          	auipc	ra,0x2
    46cc:	864080e7          	jalr	-1948(ra) # 5f2c <printf>
}
    46d0:	70e2                	ld	ra,56(sp)
    46d2:	7442                	ld	s0,48(sp)
    46d4:	74a2                	ld	s1,40(sp)
    46d6:	7902                	ld	s2,32(sp)
    46d8:	69e2                	ld	s3,24(sp)
    46da:	6a42                	ld	s4,16(sp)
    46dc:	6121                	addi	sp,sp,64
    46de:	8082                	ret
    close(pfds[0]);
    46e0:	fc842503          	lw	a0,-56(s0)
    46e4:	00001097          	auipc	ra,0x1
    46e8:	4f6080e7          	jalr	1270(ra) # 5bda <close>
    printf("kill... ");
    46ec:	00003517          	auipc	a0,0x3
    46f0:	5e450513          	addi	a0,a0,1508 # 7cd0 <malloc+0x1cec>
    46f4:	00002097          	auipc	ra,0x2
    46f8:	838080e7          	jalr	-1992(ra) # 5f2c <printf>
    kill(pid1);
    46fc:	8526                	mv	a0,s1
    46fe:	00001097          	auipc	ra,0x1
    4702:	4e4080e7          	jalr	1252(ra) # 5be2 <kill>
    kill(pid2);
    4706:	854e                	mv	a0,s3
    4708:	00001097          	auipc	ra,0x1
    470c:	4da080e7          	jalr	1242(ra) # 5be2 <kill>
    kill(pid3);
    4710:	8552                	mv	a0,s4
    4712:	00001097          	auipc	ra,0x1
    4716:	4d0080e7          	jalr	1232(ra) # 5be2 <kill>
    printf("wait... ");
    471a:	00003517          	auipc	a0,0x3
    471e:	5c650513          	addi	a0,a0,1478 # 7ce0 <malloc+0x1cfc>
    4722:	00002097          	auipc	ra,0x2
    4726:	80a080e7          	jalr	-2038(ra) # 5f2c <printf>
    wait(0);
    472a:	4501                	li	a0,0
    472c:	00001097          	auipc	ra,0x1
    4730:	48e080e7          	jalr	1166(ra) # 5bba <wait>
    wait(0);
    4734:	4501                	li	a0,0
    4736:	00001097          	auipc	ra,0x1
    473a:	484080e7          	jalr	1156(ra) # 5bba <wait>
    wait(0);
    473e:	4501                	li	a0,0
    4740:	00001097          	auipc	ra,0x1
    4744:	47a080e7          	jalr	1146(ra) # 5bba <wait>
    4748:	b761                	j	46d0 <preempt+0x12a>

000000000000474a <reparent>:
{
    474a:	7179                	addi	sp,sp,-48
    474c:	f406                	sd	ra,40(sp)
    474e:	f022                	sd	s0,32(sp)
    4750:	ec26                	sd	s1,24(sp)
    4752:	e84a                	sd	s2,16(sp)
    4754:	e44e                	sd	s3,8(sp)
    4756:	e052                	sd	s4,0(sp)
    4758:	1800                	addi	s0,sp,48
    475a:	89aa                	mv	s3,a0
    int master_pid = getpid();
    475c:	00001097          	auipc	ra,0x1
    4760:	4d6080e7          	jalr	1238(ra) # 5c32 <getpid>
    4764:	8a2a                	mv	s4,a0
    4766:	0c800913          	li	s2,200
        int pid = fork();
    476a:	00001097          	auipc	ra,0x1
    476e:	440080e7          	jalr	1088(ra) # 5baa <fork>
    4772:	84aa                	mv	s1,a0
        if (pid < 0) {
    4774:	02054263          	bltz	a0,4798 <reparent+0x4e>
        if (pid) {
    4778:	cd21                	beqz	a0,47d0 <reparent+0x86>
            if (wait(0) != pid) {
    477a:	4501                	li	a0,0
    477c:	00001097          	auipc	ra,0x1
    4780:	43e080e7          	jalr	1086(ra) # 5bba <wait>
    4784:	02951863          	bne	a0,s1,47b4 <reparent+0x6a>
    for (int i = 0; i < 200; i++) {
    4788:	397d                	addiw	s2,s2,-1
    478a:	fe0910e3          	bnez	s2,476a <reparent+0x20>
    exit(0);
    478e:	4501                	li	a0,0
    4790:	00001097          	auipc	ra,0x1
    4794:	422080e7          	jalr	1058(ra) # 5bb2 <exit>
            printf("%s: fork failed\n", s);
    4798:	85ce                	mv	a1,s3
    479a:	00002517          	auipc	a0,0x2
    479e:	1f650513          	addi	a0,a0,502 # 6990 <malloc+0x9ac>
    47a2:	00001097          	auipc	ra,0x1
    47a6:	78a080e7          	jalr	1930(ra) # 5f2c <printf>
            exit(1);
    47aa:	4505                	li	a0,1
    47ac:	00001097          	auipc	ra,0x1
    47b0:	406080e7          	jalr	1030(ra) # 5bb2 <exit>
                printf("%s: wait wrong pid\n", s);
    47b4:	85ce                	mv	a1,s3
    47b6:	00002517          	auipc	a0,0x2
    47ba:	36250513          	addi	a0,a0,866 # 6b18 <malloc+0xb34>
    47be:	00001097          	auipc	ra,0x1
    47c2:	76e080e7          	jalr	1902(ra) # 5f2c <printf>
                exit(1);
    47c6:	4505                	li	a0,1
    47c8:	00001097          	auipc	ra,0x1
    47cc:	3ea080e7          	jalr	1002(ra) # 5bb2 <exit>
            int pid2 = fork();
    47d0:	00001097          	auipc	ra,0x1
    47d4:	3da080e7          	jalr	986(ra) # 5baa <fork>
            if (pid2 < 0) {
    47d8:	00054763          	bltz	a0,47e6 <reparent+0x9c>
            exit(0);
    47dc:	4501                	li	a0,0
    47de:	00001097          	auipc	ra,0x1
    47e2:	3d4080e7          	jalr	980(ra) # 5bb2 <exit>
                kill(master_pid);
    47e6:	8552                	mv	a0,s4
    47e8:	00001097          	auipc	ra,0x1
    47ec:	3fa080e7          	jalr	1018(ra) # 5be2 <kill>
                exit(1);
    47f0:	4505                	li	a0,1
    47f2:	00001097          	auipc	ra,0x1
    47f6:	3c0080e7          	jalr	960(ra) # 5bb2 <exit>

00000000000047fa <sbrkfail>:
{
    47fa:	7119                	addi	sp,sp,-128
    47fc:	fc86                	sd	ra,120(sp)
    47fe:	f8a2                	sd	s0,112(sp)
    4800:	f4a6                	sd	s1,104(sp)
    4802:	f0ca                	sd	s2,96(sp)
    4804:	ecce                	sd	s3,88(sp)
    4806:	e8d2                	sd	s4,80(sp)
    4808:	e4d6                	sd	s5,72(sp)
    480a:	0100                	addi	s0,sp,128
    480c:	8aaa                	mv	s5,a0
    if (pipe(fds) != 0) {
    480e:	fb040513          	addi	a0,s0,-80
    4812:	00001097          	auipc	ra,0x1
    4816:	3b0080e7          	jalr	944(ra) # 5bc2 <pipe>
    481a:	e901                	bnez	a0,482a <sbrkfail+0x30>
    481c:	f8040493          	addi	s1,s0,-128
    4820:	fa840993          	addi	s3,s0,-88
    4824:	8926                	mv	s2,s1
        if (pids[i] != -1)
    4826:	5a7d                	li	s4,-1
    4828:	a085                	j	4888 <sbrkfail+0x8e>
        printf("%s: pipe() failed\n", s);
    482a:	85d6                	mv	a1,s5
    482c:	00002517          	auipc	a0,0x2
    4830:	26c50513          	addi	a0,a0,620 # 6a98 <malloc+0xab4>
    4834:	00001097          	auipc	ra,0x1
    4838:	6f8080e7          	jalr	1784(ra) # 5f2c <printf>
        exit(1);
    483c:	4505                	li	a0,1
    483e:	00001097          	auipc	ra,0x1
    4842:	374080e7          	jalr	884(ra) # 5bb2 <exit>
            sbrk(BIG - (uint64)sbrk(0));
    4846:	00001097          	auipc	ra,0x1
    484a:	3f4080e7          	jalr	1012(ra) # 5c3a <sbrk>
    484e:	064007b7          	lui	a5,0x6400
    4852:	40a7853b          	subw	a0,a5,a0
    4856:	00001097          	auipc	ra,0x1
    485a:	3e4080e7          	jalr	996(ra) # 5c3a <sbrk>
            write(fds[1], "x", 1);
    485e:	4605                	li	a2,1
    4860:	00002597          	auipc	a1,0x2
    4864:	91858593          	addi	a1,a1,-1768 # 6178 <malloc+0x194>
    4868:	fb442503          	lw	a0,-76(s0)
    486c:	00001097          	auipc	ra,0x1
    4870:	366080e7          	jalr	870(ra) # 5bd2 <write>
                sleep(1000);
    4874:	3e800513          	li	a0,1000
    4878:	00001097          	auipc	ra,0x1
    487c:	3ca080e7          	jalr	970(ra) # 5c42 <sleep>
            for (;;)
    4880:	bfd5                	j	4874 <sbrkfail+0x7a>
    for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    4882:	0911                	addi	s2,s2,4
    4884:	03390563          	beq	s2,s3,48ae <sbrkfail+0xb4>
        if ((pids[i] = fork()) == 0) {
    4888:	00001097          	auipc	ra,0x1
    488c:	322080e7          	jalr	802(ra) # 5baa <fork>
    4890:	00a92023          	sw	a0,0(s2)
    4894:	d94d                	beqz	a0,4846 <sbrkfail+0x4c>
        if (pids[i] != -1)
    4896:	ff4506e3          	beq	a0,s4,4882 <sbrkfail+0x88>
            read(fds[0], &scratch, 1);
    489a:	4605                	li	a2,1
    489c:	faf40593          	addi	a1,s0,-81
    48a0:	fb042503          	lw	a0,-80(s0)
    48a4:	00001097          	auipc	ra,0x1
    48a8:	326080e7          	jalr	806(ra) # 5bca <read>
    48ac:	bfd9                	j	4882 <sbrkfail+0x88>
    c = sbrk(PGSIZE);
    48ae:	6505                	lui	a0,0x1
    48b0:	00001097          	auipc	ra,0x1
    48b4:	38a080e7          	jalr	906(ra) # 5c3a <sbrk>
    48b8:	8a2a                	mv	s4,a0
        if (pids[i] == -1)
    48ba:	597d                	li	s2,-1
    48bc:	a021                	j	48c4 <sbrkfail+0xca>
    for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    48be:	0491                	addi	s1,s1,4
    48c0:	01348f63          	beq	s1,s3,48de <sbrkfail+0xe4>
        if (pids[i] == -1)
    48c4:	4088                	lw	a0,0(s1)
    48c6:	ff250ce3          	beq	a0,s2,48be <sbrkfail+0xc4>
        kill(pids[i]);
    48ca:	00001097          	auipc	ra,0x1
    48ce:	318080e7          	jalr	792(ra) # 5be2 <kill>
        wait(0);
    48d2:	4501                	li	a0,0
    48d4:	00001097          	auipc	ra,0x1
    48d8:	2e6080e7          	jalr	742(ra) # 5bba <wait>
    48dc:	b7cd                	j	48be <sbrkfail+0xc4>
    if (c == (char *)0xffffffffffffffffL) {
    48de:	57fd                	li	a5,-1
    48e0:	04fa0163          	beq	s4,a5,4922 <sbrkfail+0x128>
    pid = fork();
    48e4:	00001097          	auipc	ra,0x1
    48e8:	2c6080e7          	jalr	710(ra) # 5baa <fork>
    48ec:	84aa                	mv	s1,a0
    if (pid < 0) {
    48ee:	04054863          	bltz	a0,493e <sbrkfail+0x144>
    if (pid == 0) {
    48f2:	c525                	beqz	a0,495a <sbrkfail+0x160>
    wait(&xstatus);
    48f4:	fbc40513          	addi	a0,s0,-68
    48f8:	00001097          	auipc	ra,0x1
    48fc:	2c2080e7          	jalr	706(ra) # 5bba <wait>
    if (xstatus != -1 && xstatus != 2)
    4900:	fbc42783          	lw	a5,-68(s0)
    4904:	577d                	li	a4,-1
    4906:	00e78563          	beq	a5,a4,4910 <sbrkfail+0x116>
    490a:	4709                	li	a4,2
    490c:	08e79d63          	bne	a5,a4,49a6 <sbrkfail+0x1ac>
}
    4910:	70e6                	ld	ra,120(sp)
    4912:	7446                	ld	s0,112(sp)
    4914:	74a6                	ld	s1,104(sp)
    4916:	7906                	ld	s2,96(sp)
    4918:	69e6                	ld	s3,88(sp)
    491a:	6a46                	ld	s4,80(sp)
    491c:	6aa6                	ld	s5,72(sp)
    491e:	6109                	addi	sp,sp,128
    4920:	8082                	ret
        printf("%s: failed sbrk leaked memory\n", s);
    4922:	85d6                	mv	a1,s5
    4924:	00003517          	auipc	a0,0x3
    4928:	3cc50513          	addi	a0,a0,972 # 7cf0 <malloc+0x1d0c>
    492c:	00001097          	auipc	ra,0x1
    4930:	600080e7          	jalr	1536(ra) # 5f2c <printf>
        exit(1);
    4934:	4505                	li	a0,1
    4936:	00001097          	auipc	ra,0x1
    493a:	27c080e7          	jalr	636(ra) # 5bb2 <exit>
        printf("%s: fork failed\n", s);
    493e:	85d6                	mv	a1,s5
    4940:	00002517          	auipc	a0,0x2
    4944:	05050513          	addi	a0,a0,80 # 6990 <malloc+0x9ac>
    4948:	00001097          	auipc	ra,0x1
    494c:	5e4080e7          	jalr	1508(ra) # 5f2c <printf>
        exit(1);
    4950:	4505                	li	a0,1
    4952:	00001097          	auipc	ra,0x1
    4956:	260080e7          	jalr	608(ra) # 5bb2 <exit>
        a = sbrk(0);
    495a:	4501                	li	a0,0
    495c:	00001097          	auipc	ra,0x1
    4960:	2de080e7          	jalr	734(ra) # 5c3a <sbrk>
    4964:	892a                	mv	s2,a0
        sbrk(10 * BIG);
    4966:	3e800537          	lui	a0,0x3e800
    496a:	00001097          	auipc	ra,0x1
    496e:	2d0080e7          	jalr	720(ra) # 5c3a <sbrk>
        for (i = 0; i < 10 * BIG; i += PGSIZE) {
    4972:	87ca                	mv	a5,s2
    4974:	3e800737          	lui	a4,0x3e800
    4978:	993a                	add	s2,s2,a4
    497a:	6705                	lui	a4,0x1
            n += *(a + i);
    497c:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63f0388>
    4980:	9cb5                	addw	s1,s1,a3
        for (i = 0; i < 10 * BIG; i += PGSIZE) {
    4982:	97ba                	add	a5,a5,a4
    4984:	ff279ce3          	bne	a5,s2,497c <sbrkfail+0x182>
        printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4988:	8626                	mv	a2,s1
    498a:	85d6                	mv	a1,s5
    498c:	00003517          	auipc	a0,0x3
    4990:	38450513          	addi	a0,a0,900 # 7d10 <malloc+0x1d2c>
    4994:	00001097          	auipc	ra,0x1
    4998:	598080e7          	jalr	1432(ra) # 5f2c <printf>
        exit(1);
    499c:	4505                	li	a0,1
    499e:	00001097          	auipc	ra,0x1
    49a2:	214080e7          	jalr	532(ra) # 5bb2 <exit>
        exit(1);
    49a6:	4505                	li	a0,1
    49a8:	00001097          	auipc	ra,0x1
    49ac:	20a080e7          	jalr	522(ra) # 5bb2 <exit>

00000000000049b0 <mem>:
{
    49b0:	7139                	addi	sp,sp,-64
    49b2:	fc06                	sd	ra,56(sp)
    49b4:	f822                	sd	s0,48(sp)
    49b6:	f426                	sd	s1,40(sp)
    49b8:	f04a                	sd	s2,32(sp)
    49ba:	ec4e                	sd	s3,24(sp)
    49bc:	0080                	addi	s0,sp,64
    49be:	89aa                	mv	s3,a0
    if ((pid = fork()) == 0) {
    49c0:	00001097          	auipc	ra,0x1
    49c4:	1ea080e7          	jalr	490(ra) # 5baa <fork>
        m1 = 0;
    49c8:	4481                	li	s1,0
        while ((m2 = malloc(10001)) != 0) {
    49ca:	6909                	lui	s2,0x2
    49cc:	71190913          	addi	s2,s2,1809 # 2711 <copyinstr3+0x115>
    if ((pid = fork()) == 0) {
    49d0:	c115                	beqz	a0,49f4 <mem+0x44>
        wait(&xstatus);
    49d2:	fcc40513          	addi	a0,s0,-52
    49d6:	00001097          	auipc	ra,0x1
    49da:	1e4080e7          	jalr	484(ra) # 5bba <wait>
        if (xstatus == -1) {
    49de:	fcc42503          	lw	a0,-52(s0)
    49e2:	57fd                	li	a5,-1
    49e4:	06f50363          	beq	a0,a5,4a4a <mem+0x9a>
        exit(xstatus);
    49e8:	00001097          	auipc	ra,0x1
    49ec:	1ca080e7          	jalr	458(ra) # 5bb2 <exit>
            *(char **)m2 = m1;
    49f0:	e104                	sd	s1,0(a0)
            m1 = m2;
    49f2:	84aa                	mv	s1,a0
        while ((m2 = malloc(10001)) != 0) {
    49f4:	854a                	mv	a0,s2
    49f6:	00001097          	auipc	ra,0x1
    49fa:	5ee080e7          	jalr	1518(ra) # 5fe4 <malloc>
    49fe:	f96d                	bnez	a0,49f0 <mem+0x40>
        while (m1) {
    4a00:	c881                	beqz	s1,4a10 <mem+0x60>
            m2 = *(char **)m1;
    4a02:	8526                	mv	a0,s1
    4a04:	6084                	ld	s1,0(s1)
            free(m1);
    4a06:	00001097          	auipc	ra,0x1
    4a0a:	55c080e7          	jalr	1372(ra) # 5f62 <free>
        while (m1) {
    4a0e:	f8f5                	bnez	s1,4a02 <mem+0x52>
        m1 = malloc(1024 * 20);
    4a10:	6515                	lui	a0,0x5
    4a12:	00001097          	auipc	ra,0x1
    4a16:	5d2080e7          	jalr	1490(ra) # 5fe4 <malloc>
        if (m1 == 0) {
    4a1a:	c911                	beqz	a0,4a2e <mem+0x7e>
        free(m1);
    4a1c:	00001097          	auipc	ra,0x1
    4a20:	546080e7          	jalr	1350(ra) # 5f62 <free>
        exit(0);
    4a24:	4501                	li	a0,0
    4a26:	00001097          	auipc	ra,0x1
    4a2a:	18c080e7          	jalr	396(ra) # 5bb2 <exit>
            printf("couldn't allocate mem?!!\n", s);
    4a2e:	85ce                	mv	a1,s3
    4a30:	00003517          	auipc	a0,0x3
    4a34:	31050513          	addi	a0,a0,784 # 7d40 <malloc+0x1d5c>
    4a38:	00001097          	auipc	ra,0x1
    4a3c:	4f4080e7          	jalr	1268(ra) # 5f2c <printf>
            exit(1);
    4a40:	4505                	li	a0,1
    4a42:	00001097          	auipc	ra,0x1
    4a46:	170080e7          	jalr	368(ra) # 5bb2 <exit>
            exit(0);
    4a4a:	4501                	li	a0,0
    4a4c:	00001097          	auipc	ra,0x1
    4a50:	166080e7          	jalr	358(ra) # 5bb2 <exit>

0000000000004a54 <sharedfd>:
{
    4a54:	7159                	addi	sp,sp,-112
    4a56:	f486                	sd	ra,104(sp)
    4a58:	f0a2                	sd	s0,96(sp)
    4a5a:	eca6                	sd	s1,88(sp)
    4a5c:	e8ca                	sd	s2,80(sp)
    4a5e:	e4ce                	sd	s3,72(sp)
    4a60:	e0d2                	sd	s4,64(sp)
    4a62:	fc56                	sd	s5,56(sp)
    4a64:	f85a                	sd	s6,48(sp)
    4a66:	f45e                	sd	s7,40(sp)
    4a68:	1880                	addi	s0,sp,112
    4a6a:	8a2a                	mv	s4,a0
    unlink("sharedfd");
    4a6c:	00003517          	auipc	a0,0x3
    4a70:	2f450513          	addi	a0,a0,756 # 7d60 <malloc+0x1d7c>
    4a74:	00001097          	auipc	ra,0x1
    4a78:	18e080e7          	jalr	398(ra) # 5c02 <unlink>
    fd = open("sharedfd", O_CREATE | O_RDWR);
    4a7c:	20200593          	li	a1,514
    4a80:	00003517          	auipc	a0,0x3
    4a84:	2e050513          	addi	a0,a0,736 # 7d60 <malloc+0x1d7c>
    4a88:	00001097          	auipc	ra,0x1
    4a8c:	16a080e7          	jalr	362(ra) # 5bf2 <open>
    if (fd < 0) {
    4a90:	04054a63          	bltz	a0,4ae4 <sharedfd+0x90>
    4a94:	892a                	mv	s2,a0
    pid = fork();
    4a96:	00001097          	auipc	ra,0x1
    4a9a:	114080e7          	jalr	276(ra) # 5baa <fork>
    4a9e:	89aa                	mv	s3,a0
    memset(buf, pid == 0 ? 'c' : 'p', sizeof(buf));
    4aa0:	06300593          	li	a1,99
    4aa4:	c119                	beqz	a0,4aaa <sharedfd+0x56>
    4aa6:	07000593          	li	a1,112
    4aaa:	4629                	li	a2,10
    4aac:	fa040513          	addi	a0,s0,-96
    4ab0:	00001097          	auipc	ra,0x1
    4ab4:	f08080e7          	jalr	-248(ra) # 59b8 <memset>
    4ab8:	3e800493          	li	s1,1000
        if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
    4abc:	4629                	li	a2,10
    4abe:	fa040593          	addi	a1,s0,-96
    4ac2:	854a                	mv	a0,s2
    4ac4:	00001097          	auipc	ra,0x1
    4ac8:	10e080e7          	jalr	270(ra) # 5bd2 <write>
    4acc:	47a9                	li	a5,10
    4ace:	02f51963          	bne	a0,a5,4b00 <sharedfd+0xac>
    for (i = 0; i < N; i++) {
    4ad2:	34fd                	addiw	s1,s1,-1
    4ad4:	f4e5                	bnez	s1,4abc <sharedfd+0x68>
    if (pid == 0) {
    4ad6:	04099363          	bnez	s3,4b1c <sharedfd+0xc8>
        exit(0);
    4ada:	4501                	li	a0,0
    4adc:	00001097          	auipc	ra,0x1
    4ae0:	0d6080e7          	jalr	214(ra) # 5bb2 <exit>
        printf("%s: cannot open sharedfd for writing", s);
    4ae4:	85d2                	mv	a1,s4
    4ae6:	00003517          	auipc	a0,0x3
    4aea:	28a50513          	addi	a0,a0,650 # 7d70 <malloc+0x1d8c>
    4aee:	00001097          	auipc	ra,0x1
    4af2:	43e080e7          	jalr	1086(ra) # 5f2c <printf>
        exit(1);
    4af6:	4505                	li	a0,1
    4af8:	00001097          	auipc	ra,0x1
    4afc:	0ba080e7          	jalr	186(ra) # 5bb2 <exit>
            printf("%s: write sharedfd failed\n", s);
    4b00:	85d2                	mv	a1,s4
    4b02:	00003517          	auipc	a0,0x3
    4b06:	29650513          	addi	a0,a0,662 # 7d98 <malloc+0x1db4>
    4b0a:	00001097          	auipc	ra,0x1
    4b0e:	422080e7          	jalr	1058(ra) # 5f2c <printf>
            exit(1);
    4b12:	4505                	li	a0,1
    4b14:	00001097          	auipc	ra,0x1
    4b18:	09e080e7          	jalr	158(ra) # 5bb2 <exit>
        wait(&xstatus);
    4b1c:	f9c40513          	addi	a0,s0,-100
    4b20:	00001097          	auipc	ra,0x1
    4b24:	09a080e7          	jalr	154(ra) # 5bba <wait>
        if (xstatus != 0)
    4b28:	f9c42983          	lw	s3,-100(s0)
    4b2c:	00098763          	beqz	s3,4b3a <sharedfd+0xe6>
            exit(xstatus);
    4b30:	854e                	mv	a0,s3
    4b32:	00001097          	auipc	ra,0x1
    4b36:	080080e7          	jalr	128(ra) # 5bb2 <exit>
    close(fd);
    4b3a:	854a                	mv	a0,s2
    4b3c:	00001097          	auipc	ra,0x1
    4b40:	09e080e7          	jalr	158(ra) # 5bda <close>
    fd = open("sharedfd", 0);
    4b44:	4581                	li	a1,0
    4b46:	00003517          	auipc	a0,0x3
    4b4a:	21a50513          	addi	a0,a0,538 # 7d60 <malloc+0x1d7c>
    4b4e:	00001097          	auipc	ra,0x1
    4b52:	0a4080e7          	jalr	164(ra) # 5bf2 <open>
    4b56:	8baa                	mv	s7,a0
    nc = np = 0;
    4b58:	8ace                	mv	s5,s3
    if (fd < 0) {
    4b5a:	02054563          	bltz	a0,4b84 <sharedfd+0x130>
    4b5e:	faa40913          	addi	s2,s0,-86
            if (buf[i] == 'c')
    4b62:	06300493          	li	s1,99
            if (buf[i] == 'p')
    4b66:	07000b13          	li	s6,112
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    4b6a:	4629                	li	a2,10
    4b6c:	fa040593          	addi	a1,s0,-96
    4b70:	855e                	mv	a0,s7
    4b72:	00001097          	auipc	ra,0x1
    4b76:	058080e7          	jalr	88(ra) # 5bca <read>
    4b7a:	02a05f63          	blez	a0,4bb8 <sharedfd+0x164>
    4b7e:	fa040793          	addi	a5,s0,-96
    4b82:	a01d                	j	4ba8 <sharedfd+0x154>
        printf("%s: cannot open sharedfd for reading\n", s);
    4b84:	85d2                	mv	a1,s4
    4b86:	00003517          	auipc	a0,0x3
    4b8a:	23250513          	addi	a0,a0,562 # 7db8 <malloc+0x1dd4>
    4b8e:	00001097          	auipc	ra,0x1
    4b92:	39e080e7          	jalr	926(ra) # 5f2c <printf>
        exit(1);
    4b96:	4505                	li	a0,1
    4b98:	00001097          	auipc	ra,0x1
    4b9c:	01a080e7          	jalr	26(ra) # 5bb2 <exit>
                nc++;
    4ba0:	2985                	addiw	s3,s3,1
        for (i = 0; i < sizeof(buf); i++) {
    4ba2:	0785                	addi	a5,a5,1
    4ba4:	fd2783e3          	beq	a5,s2,4b6a <sharedfd+0x116>
            if (buf[i] == 'c')
    4ba8:	0007c703          	lbu	a4,0(a5)
    4bac:	fe970ae3          	beq	a4,s1,4ba0 <sharedfd+0x14c>
            if (buf[i] == 'p')
    4bb0:	ff6719e3          	bne	a4,s6,4ba2 <sharedfd+0x14e>
                np++;
    4bb4:	2a85                	addiw	s5,s5,1
    4bb6:	b7f5                	j	4ba2 <sharedfd+0x14e>
    close(fd);
    4bb8:	855e                	mv	a0,s7
    4bba:	00001097          	auipc	ra,0x1
    4bbe:	020080e7          	jalr	32(ra) # 5bda <close>
    unlink("sharedfd");
    4bc2:	00003517          	auipc	a0,0x3
    4bc6:	19e50513          	addi	a0,a0,414 # 7d60 <malloc+0x1d7c>
    4bca:	00001097          	auipc	ra,0x1
    4bce:	038080e7          	jalr	56(ra) # 5c02 <unlink>
    if (nc == N * SZ && np == N * SZ) {
    4bd2:	6789                	lui	a5,0x2
    4bd4:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0x114>
    4bd8:	00f99763          	bne	s3,a5,4be6 <sharedfd+0x192>
    4bdc:	6789                	lui	a5,0x2
    4bde:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0x114>
    4be2:	02fa8063          	beq	s5,a5,4c02 <sharedfd+0x1ae>
        printf("%s: nc/np test fails\n", s);
    4be6:	85d2                	mv	a1,s4
    4be8:	00003517          	auipc	a0,0x3
    4bec:	1f850513          	addi	a0,a0,504 # 7de0 <malloc+0x1dfc>
    4bf0:	00001097          	auipc	ra,0x1
    4bf4:	33c080e7          	jalr	828(ra) # 5f2c <printf>
        exit(1);
    4bf8:	4505                	li	a0,1
    4bfa:	00001097          	auipc	ra,0x1
    4bfe:	fb8080e7          	jalr	-72(ra) # 5bb2 <exit>
        exit(0);
    4c02:	4501                	li	a0,0
    4c04:	00001097          	auipc	ra,0x1
    4c08:	fae080e7          	jalr	-82(ra) # 5bb2 <exit>

0000000000004c0c <fourfiles>:
{
    4c0c:	7171                	addi	sp,sp,-176
    4c0e:	f506                	sd	ra,168(sp)
    4c10:	f122                	sd	s0,160(sp)
    4c12:	ed26                	sd	s1,152(sp)
    4c14:	e94a                	sd	s2,144(sp)
    4c16:	e54e                	sd	s3,136(sp)
    4c18:	e152                	sd	s4,128(sp)
    4c1a:	fcd6                	sd	s5,120(sp)
    4c1c:	f8da                	sd	s6,112(sp)
    4c1e:	f4de                	sd	s7,104(sp)
    4c20:	f0e2                	sd	s8,96(sp)
    4c22:	ece6                	sd	s9,88(sp)
    4c24:	e8ea                	sd	s10,80(sp)
    4c26:	e4ee                	sd	s11,72(sp)
    4c28:	1900                	addi	s0,sp,176
    4c2a:	f4a43c23          	sd	a0,-168(s0)
    char *names[] = {"f0", "f1", "f2", "f3"};
    4c2e:	00003797          	auipc	a5,0x3
    4c32:	1ca78793          	addi	a5,a5,458 # 7df8 <malloc+0x1e14>
    4c36:	f6f43823          	sd	a5,-144(s0)
    4c3a:	00003797          	auipc	a5,0x3
    4c3e:	1c678793          	addi	a5,a5,454 # 7e00 <malloc+0x1e1c>
    4c42:	f6f43c23          	sd	a5,-136(s0)
    4c46:	00003797          	auipc	a5,0x3
    4c4a:	1c278793          	addi	a5,a5,450 # 7e08 <malloc+0x1e24>
    4c4e:	f8f43023          	sd	a5,-128(s0)
    4c52:	00003797          	auipc	a5,0x3
    4c56:	1be78793          	addi	a5,a5,446 # 7e10 <malloc+0x1e2c>
    4c5a:	f8f43423          	sd	a5,-120(s0)
    for (pi = 0; pi < NCHILD; pi++) {
    4c5e:	f7040c13          	addi	s8,s0,-144
    char *names[] = {"f0", "f1", "f2", "f3"};
    4c62:	8962                	mv	s2,s8
    for (pi = 0; pi < NCHILD; pi++) {
    4c64:	4481                	li	s1,0
    4c66:	4a11                	li	s4,4
        fname = names[pi];
    4c68:	00093983          	ld	s3,0(s2)
        unlink(fname);
    4c6c:	854e                	mv	a0,s3
    4c6e:	00001097          	auipc	ra,0x1
    4c72:	f94080e7          	jalr	-108(ra) # 5c02 <unlink>
        pid = fork();
    4c76:	00001097          	auipc	ra,0x1
    4c7a:	f34080e7          	jalr	-204(ra) # 5baa <fork>
        if (pid < 0) {
    4c7e:	04054463          	bltz	a0,4cc6 <fourfiles+0xba>
        if (pid == 0) {
    4c82:	c12d                	beqz	a0,4ce4 <fourfiles+0xd8>
    for (pi = 0; pi < NCHILD; pi++) {
    4c84:	2485                	addiw	s1,s1,1
    4c86:	0921                	addi	s2,s2,8
    4c88:	ff4490e3          	bne	s1,s4,4c68 <fourfiles+0x5c>
    4c8c:	4491                	li	s1,4
        wait(&xstatus);
    4c8e:	f6c40513          	addi	a0,s0,-148
    4c92:	00001097          	auipc	ra,0x1
    4c96:	f28080e7          	jalr	-216(ra) # 5bba <wait>
        if (xstatus != 0)
    4c9a:	f6c42b03          	lw	s6,-148(s0)
    4c9e:	0c0b1e63          	bnez	s6,4d7a <fourfiles+0x16e>
    for (pi = 0; pi < NCHILD; pi++) {
    4ca2:	34fd                	addiw	s1,s1,-1
    4ca4:	f4ed                	bnez	s1,4c8e <fourfiles+0x82>
    4ca6:	03000b93          	li	s7,48
        while ((n = read(fd, buf, sizeof(buf))) > 0) {
    4caa:	00008a17          	auipc	s4,0x8
    4cae:	fcea0a13          	addi	s4,s4,-50 # cc78 <buf>
    4cb2:	00008a97          	auipc	s5,0x8
    4cb6:	fc7a8a93          	addi	s5,s5,-57 # cc79 <buf+0x1>
        if (total != N * SZ) {
    4cba:	6d85                	lui	s11,0x1
    4cbc:	770d8d93          	addi	s11,s11,1904 # 1770 <exectest+0x30>
    for (i = 0; i < NCHILD; i++) {
    4cc0:	03400d13          	li	s10,52
    4cc4:	aa1d                	j	4dfa <fourfiles+0x1ee>
            printf("fork failed\n", s);
    4cc6:	f5843583          	ld	a1,-168(s0)
    4cca:	00002517          	auipc	a0,0x2
    4cce:	0ce50513          	addi	a0,a0,206 # 6d98 <malloc+0xdb4>
    4cd2:	00001097          	auipc	ra,0x1
    4cd6:	25a080e7          	jalr	602(ra) # 5f2c <printf>
            exit(1);
    4cda:	4505                	li	a0,1
    4cdc:	00001097          	auipc	ra,0x1
    4ce0:	ed6080e7          	jalr	-298(ra) # 5bb2 <exit>
            fd = open(fname, O_CREATE | O_RDWR);
    4ce4:	20200593          	li	a1,514
    4ce8:	854e                	mv	a0,s3
    4cea:	00001097          	auipc	ra,0x1
    4cee:	f08080e7          	jalr	-248(ra) # 5bf2 <open>
    4cf2:	892a                	mv	s2,a0
            if (fd < 0) {
    4cf4:	04054763          	bltz	a0,4d42 <fourfiles+0x136>
            memset(buf, '0' + pi, SZ);
    4cf8:	1f400613          	li	a2,500
    4cfc:	0304859b          	addiw	a1,s1,48
    4d00:	00008517          	auipc	a0,0x8
    4d04:	f7850513          	addi	a0,a0,-136 # cc78 <buf>
    4d08:	00001097          	auipc	ra,0x1
    4d0c:	cb0080e7          	jalr	-848(ra) # 59b8 <memset>
    4d10:	44b1                	li	s1,12
                if ((n = write(fd, buf, SZ)) != SZ) {
    4d12:	00008997          	auipc	s3,0x8
    4d16:	f6698993          	addi	s3,s3,-154 # cc78 <buf>
    4d1a:	1f400613          	li	a2,500
    4d1e:	85ce                	mv	a1,s3
    4d20:	854a                	mv	a0,s2
    4d22:	00001097          	auipc	ra,0x1
    4d26:	eb0080e7          	jalr	-336(ra) # 5bd2 <write>
    4d2a:	85aa                	mv	a1,a0
    4d2c:	1f400793          	li	a5,500
    4d30:	02f51863          	bne	a0,a5,4d60 <fourfiles+0x154>
            for (i = 0; i < N; i++) {
    4d34:	34fd                	addiw	s1,s1,-1
    4d36:	f0f5                	bnez	s1,4d1a <fourfiles+0x10e>
            exit(0);
    4d38:	4501                	li	a0,0
    4d3a:	00001097          	auipc	ra,0x1
    4d3e:	e78080e7          	jalr	-392(ra) # 5bb2 <exit>
                printf("create failed\n", s);
    4d42:	f5843583          	ld	a1,-168(s0)
    4d46:	00003517          	auipc	a0,0x3
    4d4a:	0d250513          	addi	a0,a0,210 # 7e18 <malloc+0x1e34>
    4d4e:	00001097          	auipc	ra,0x1
    4d52:	1de080e7          	jalr	478(ra) # 5f2c <printf>
                exit(1);
    4d56:	4505                	li	a0,1
    4d58:	00001097          	auipc	ra,0x1
    4d5c:	e5a080e7          	jalr	-422(ra) # 5bb2 <exit>
                    printf("write failed %d\n", n);
    4d60:	00003517          	auipc	a0,0x3
    4d64:	0c850513          	addi	a0,a0,200 # 7e28 <malloc+0x1e44>
    4d68:	00001097          	auipc	ra,0x1
    4d6c:	1c4080e7          	jalr	452(ra) # 5f2c <printf>
                    exit(1);
    4d70:	4505                	li	a0,1
    4d72:	00001097          	auipc	ra,0x1
    4d76:	e40080e7          	jalr	-448(ra) # 5bb2 <exit>
            exit(xstatus);
    4d7a:	855a                	mv	a0,s6
    4d7c:	00001097          	auipc	ra,0x1
    4d80:	e36080e7          	jalr	-458(ra) # 5bb2 <exit>
                    printf("wrong char\n", s);
    4d84:	f5843583          	ld	a1,-168(s0)
    4d88:	00003517          	auipc	a0,0x3
    4d8c:	0b850513          	addi	a0,a0,184 # 7e40 <malloc+0x1e5c>
    4d90:	00001097          	auipc	ra,0x1
    4d94:	19c080e7          	jalr	412(ra) # 5f2c <printf>
                    exit(1);
    4d98:	4505                	li	a0,1
    4d9a:	00001097          	auipc	ra,0x1
    4d9e:	e18080e7          	jalr	-488(ra) # 5bb2 <exit>
            total += n;
    4da2:	00a9093b          	addw	s2,s2,a0
        while ((n = read(fd, buf, sizeof(buf))) > 0) {
    4da6:	660d                	lui	a2,0x3
    4da8:	85d2                	mv	a1,s4
    4daa:	854e                	mv	a0,s3
    4dac:	00001097          	auipc	ra,0x1
    4db0:	e1e080e7          	jalr	-482(ra) # 5bca <read>
    4db4:	02a05363          	blez	a0,4dda <fourfiles+0x1ce>
    4db8:	00008797          	auipc	a5,0x8
    4dbc:	ec078793          	addi	a5,a5,-320 # cc78 <buf>
    4dc0:	fff5069b          	addiw	a3,a0,-1
    4dc4:	1682                	slli	a3,a3,0x20
    4dc6:	9281                	srli	a3,a3,0x20
    4dc8:	96d6                	add	a3,a3,s5
                if (buf[j] != '0' + i) {
    4dca:	0007c703          	lbu	a4,0(a5)
    4dce:	fa971be3          	bne	a4,s1,4d84 <fourfiles+0x178>
            for (j = 0; j < n; j++) {
    4dd2:	0785                	addi	a5,a5,1
    4dd4:	fed79be3          	bne	a5,a3,4dca <fourfiles+0x1be>
    4dd8:	b7e9                	j	4da2 <fourfiles+0x196>
        close(fd);
    4dda:	854e                	mv	a0,s3
    4ddc:	00001097          	auipc	ra,0x1
    4de0:	dfe080e7          	jalr	-514(ra) # 5bda <close>
        if (total != N * SZ) {
    4de4:	03b91863          	bne	s2,s11,4e14 <fourfiles+0x208>
        unlink(fname);
    4de8:	8566                	mv	a0,s9
    4dea:	00001097          	auipc	ra,0x1
    4dee:	e18080e7          	jalr	-488(ra) # 5c02 <unlink>
    for (i = 0; i < NCHILD; i++) {
    4df2:	0c21                	addi	s8,s8,8
    4df4:	2b85                	addiw	s7,s7,1
    4df6:	03ab8d63          	beq	s7,s10,4e30 <fourfiles+0x224>
        fname = names[i];
    4dfa:	000c3c83          	ld	s9,0(s8)
        fd = open(fname, 0);
    4dfe:	4581                	li	a1,0
    4e00:	8566                	mv	a0,s9
    4e02:	00001097          	auipc	ra,0x1
    4e06:	df0080e7          	jalr	-528(ra) # 5bf2 <open>
    4e0a:	89aa                	mv	s3,a0
        total = 0;
    4e0c:	895a                	mv	s2,s6
                if (buf[j] != '0' + i) {
    4e0e:	000b849b          	sext.w	s1,s7
        while ((n = read(fd, buf, sizeof(buf))) > 0) {
    4e12:	bf51                	j	4da6 <fourfiles+0x19a>
            printf("wrong length %d\n", total);
    4e14:	85ca                	mv	a1,s2
    4e16:	00003517          	auipc	a0,0x3
    4e1a:	03a50513          	addi	a0,a0,58 # 7e50 <malloc+0x1e6c>
    4e1e:	00001097          	auipc	ra,0x1
    4e22:	10e080e7          	jalr	270(ra) # 5f2c <printf>
            exit(1);
    4e26:	4505                	li	a0,1
    4e28:	00001097          	auipc	ra,0x1
    4e2c:	d8a080e7          	jalr	-630(ra) # 5bb2 <exit>
}
    4e30:	70aa                	ld	ra,168(sp)
    4e32:	740a                	ld	s0,160(sp)
    4e34:	64ea                	ld	s1,152(sp)
    4e36:	694a                	ld	s2,144(sp)
    4e38:	69aa                	ld	s3,136(sp)
    4e3a:	6a0a                	ld	s4,128(sp)
    4e3c:	7ae6                	ld	s5,120(sp)
    4e3e:	7b46                	ld	s6,112(sp)
    4e40:	7ba6                	ld	s7,104(sp)
    4e42:	7c06                	ld	s8,96(sp)
    4e44:	6ce6                	ld	s9,88(sp)
    4e46:	6d46                	ld	s10,80(sp)
    4e48:	6da6                	ld	s11,72(sp)
    4e4a:	614d                	addi	sp,sp,176
    4e4c:	8082                	ret

0000000000004e4e <concreate>:
{
    4e4e:	7135                	addi	sp,sp,-160
    4e50:	ed06                	sd	ra,152(sp)
    4e52:	e922                	sd	s0,144(sp)
    4e54:	e526                	sd	s1,136(sp)
    4e56:	e14a                	sd	s2,128(sp)
    4e58:	fcce                	sd	s3,120(sp)
    4e5a:	f8d2                	sd	s4,112(sp)
    4e5c:	f4d6                	sd	s5,104(sp)
    4e5e:	f0da                	sd	s6,96(sp)
    4e60:	ecde                	sd	s7,88(sp)
    4e62:	1100                	addi	s0,sp,160
    4e64:	89aa                	mv	s3,a0
    file[0] = 'C';
    4e66:	04300793          	li	a5,67
    4e6a:	faf40423          	sb	a5,-88(s0)
    file[2] = '\0';
    4e6e:	fa040523          	sb	zero,-86(s0)
    for (i = 0; i < N; i++) {
    4e72:	4901                	li	s2,0
        if (pid && (i % 3) == 1) {
    4e74:	4b0d                	li	s6,3
    4e76:	4a85                	li	s5,1
            link("C0", file);
    4e78:	00003b97          	auipc	s7,0x3
    4e7c:	ff0b8b93          	addi	s7,s7,-16 # 7e68 <malloc+0x1e84>
    for (i = 0; i < N; i++) {
    4e80:	02800a13          	li	s4,40
    4e84:	acc9                	j	5156 <concreate+0x308>
            link("C0", file);
    4e86:	fa840593          	addi	a1,s0,-88
    4e8a:	855e                	mv	a0,s7
    4e8c:	00001097          	auipc	ra,0x1
    4e90:	d86080e7          	jalr	-634(ra) # 5c12 <link>
        if (pid == 0) {
    4e94:	a465                	j	513c <concreate+0x2ee>
        else if (pid == 0 && (i % 5) == 1) {
    4e96:	4795                	li	a5,5
    4e98:	02f9693b          	remw	s2,s2,a5
    4e9c:	4785                	li	a5,1
    4e9e:	02f90b63          	beq	s2,a5,4ed4 <concreate+0x86>
            fd = open(file, O_CREATE | O_RDWR);
    4ea2:	20200593          	li	a1,514
    4ea6:	fa840513          	addi	a0,s0,-88
    4eaa:	00001097          	auipc	ra,0x1
    4eae:	d48080e7          	jalr	-696(ra) # 5bf2 <open>
            if (fd < 0) {
    4eb2:	26055c63          	bgez	a0,512a <concreate+0x2dc>
                printf("concreate create %s failed\n", file);
    4eb6:	fa840593          	addi	a1,s0,-88
    4eba:	00003517          	auipc	a0,0x3
    4ebe:	fb650513          	addi	a0,a0,-74 # 7e70 <malloc+0x1e8c>
    4ec2:	00001097          	auipc	ra,0x1
    4ec6:	06a080e7          	jalr	106(ra) # 5f2c <printf>
                exit(1);
    4eca:	4505                	li	a0,1
    4ecc:	00001097          	auipc	ra,0x1
    4ed0:	ce6080e7          	jalr	-794(ra) # 5bb2 <exit>
            link("C0", file);
    4ed4:	fa840593          	addi	a1,s0,-88
    4ed8:	00003517          	auipc	a0,0x3
    4edc:	f9050513          	addi	a0,a0,-112 # 7e68 <malloc+0x1e84>
    4ee0:	00001097          	auipc	ra,0x1
    4ee4:	d32080e7          	jalr	-718(ra) # 5c12 <link>
            exit(0);
    4ee8:	4501                	li	a0,0
    4eea:	00001097          	auipc	ra,0x1
    4eee:	cc8080e7          	jalr	-824(ra) # 5bb2 <exit>
                exit(1);
    4ef2:	4505                	li	a0,1
    4ef4:	00001097          	auipc	ra,0x1
    4ef8:	cbe080e7          	jalr	-834(ra) # 5bb2 <exit>
    memset(fa, 0, sizeof(fa));
    4efc:	02800613          	li	a2,40
    4f00:	4581                	li	a1,0
    4f02:	f8040513          	addi	a0,s0,-128
    4f06:	00001097          	auipc	ra,0x1
    4f0a:	ab2080e7          	jalr	-1358(ra) # 59b8 <memset>
    fd = open(".", 0);
    4f0e:	4581                	li	a1,0
    4f10:	00002517          	auipc	a0,0x2
    4f14:	8e050513          	addi	a0,a0,-1824 # 67f0 <malloc+0x80c>
    4f18:	00001097          	auipc	ra,0x1
    4f1c:	cda080e7          	jalr	-806(ra) # 5bf2 <open>
    4f20:	892a                	mv	s2,a0
    n = 0;
    4f22:	8aa6                	mv	s5,s1
        if (de.name[0] == 'C' && de.name[2] == '\0') {
    4f24:	04300a13          	li	s4,67
            if (i < 0 || i >= sizeof(fa)) {
    4f28:	02700b13          	li	s6,39
            fa[i] = 1;
    4f2c:	4b85                	li	s7,1
    while (read(fd, &de, sizeof(de)) > 0) {
    4f2e:	4641                	li	a2,16
    4f30:	f7040593          	addi	a1,s0,-144
    4f34:	854a                	mv	a0,s2
    4f36:	00001097          	auipc	ra,0x1
    4f3a:	c94080e7          	jalr	-876(ra) # 5bca <read>
    4f3e:	08a05263          	blez	a0,4fc2 <concreate+0x174>
        if (de.inum == 0)
    4f42:	f7045783          	lhu	a5,-144(s0)
    4f46:	d7e5                	beqz	a5,4f2e <concreate+0xe0>
        if (de.name[0] == 'C' && de.name[2] == '\0') {
    4f48:	f7244783          	lbu	a5,-142(s0)
    4f4c:	ff4791e3          	bne	a5,s4,4f2e <concreate+0xe0>
    4f50:	f7444783          	lbu	a5,-140(s0)
    4f54:	ffe9                	bnez	a5,4f2e <concreate+0xe0>
            i = de.name[1] - '0';
    4f56:	f7344783          	lbu	a5,-141(s0)
    4f5a:	fd07879b          	addiw	a5,a5,-48
    4f5e:	0007871b          	sext.w	a4,a5
            if (i < 0 || i >= sizeof(fa)) {
    4f62:	02eb6063          	bltu	s6,a4,4f82 <concreate+0x134>
            if (fa[i]) {
    4f66:	fb070793          	addi	a5,a4,-80 # fb0 <linktest+0xbc>
    4f6a:	97a2                	add	a5,a5,s0
    4f6c:	fd07c783          	lbu	a5,-48(a5)
    4f70:	eb8d                	bnez	a5,4fa2 <concreate+0x154>
            fa[i] = 1;
    4f72:	fb070793          	addi	a5,a4,-80
    4f76:	00878733          	add	a4,a5,s0
    4f7a:	fd770823          	sb	s7,-48(a4)
            n++;
    4f7e:	2a85                	addiw	s5,s5,1
    4f80:	b77d                	j	4f2e <concreate+0xe0>
                printf("%s: concreate weird file %s\n", s, de.name);
    4f82:	f7240613          	addi	a2,s0,-142
    4f86:	85ce                	mv	a1,s3
    4f88:	00003517          	auipc	a0,0x3
    4f8c:	f0850513          	addi	a0,a0,-248 # 7e90 <malloc+0x1eac>
    4f90:	00001097          	auipc	ra,0x1
    4f94:	f9c080e7          	jalr	-100(ra) # 5f2c <printf>
                exit(1);
    4f98:	4505                	li	a0,1
    4f9a:	00001097          	auipc	ra,0x1
    4f9e:	c18080e7          	jalr	-1000(ra) # 5bb2 <exit>
                printf("%s: concreate duplicate file %s\n", s, de.name);
    4fa2:	f7240613          	addi	a2,s0,-142
    4fa6:	85ce                	mv	a1,s3
    4fa8:	00003517          	auipc	a0,0x3
    4fac:	f0850513          	addi	a0,a0,-248 # 7eb0 <malloc+0x1ecc>
    4fb0:	00001097          	auipc	ra,0x1
    4fb4:	f7c080e7          	jalr	-132(ra) # 5f2c <printf>
                exit(1);
    4fb8:	4505                	li	a0,1
    4fba:	00001097          	auipc	ra,0x1
    4fbe:	bf8080e7          	jalr	-1032(ra) # 5bb2 <exit>
    close(fd);
    4fc2:	854a                	mv	a0,s2
    4fc4:	00001097          	auipc	ra,0x1
    4fc8:	c16080e7          	jalr	-1002(ra) # 5bda <close>
    if (n != N) {
    4fcc:	02800793          	li	a5,40
    4fd0:	00fa9763          	bne	s5,a5,4fde <concreate+0x190>
        if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    4fd4:	4a8d                	li	s5,3
    4fd6:	4b05                	li	s6,1
    for (i = 0; i < N; i++) {
    4fd8:	02800a13          	li	s4,40
    4fdc:	a8c9                	j	50ae <concreate+0x260>
        printf("%s: concreate not enough files in directory listing\n", s);
    4fde:	85ce                	mv	a1,s3
    4fe0:	00003517          	auipc	a0,0x3
    4fe4:	ef850513          	addi	a0,a0,-264 # 7ed8 <malloc+0x1ef4>
    4fe8:	00001097          	auipc	ra,0x1
    4fec:	f44080e7          	jalr	-188(ra) # 5f2c <printf>
        exit(1);
    4ff0:	4505                	li	a0,1
    4ff2:	00001097          	auipc	ra,0x1
    4ff6:	bc0080e7          	jalr	-1088(ra) # 5bb2 <exit>
            printf("%s: fork failed\n", s);
    4ffa:	85ce                	mv	a1,s3
    4ffc:	00002517          	auipc	a0,0x2
    5000:	99450513          	addi	a0,a0,-1644 # 6990 <malloc+0x9ac>
    5004:	00001097          	auipc	ra,0x1
    5008:	f28080e7          	jalr	-216(ra) # 5f2c <printf>
            exit(1);
    500c:	4505                	li	a0,1
    500e:	00001097          	auipc	ra,0x1
    5012:	ba4080e7          	jalr	-1116(ra) # 5bb2 <exit>
            close(open(file, 0));
    5016:	4581                	li	a1,0
    5018:	fa840513          	addi	a0,s0,-88
    501c:	00001097          	auipc	ra,0x1
    5020:	bd6080e7          	jalr	-1066(ra) # 5bf2 <open>
    5024:	00001097          	auipc	ra,0x1
    5028:	bb6080e7          	jalr	-1098(ra) # 5bda <close>
            close(open(file, 0));
    502c:	4581                	li	a1,0
    502e:	fa840513          	addi	a0,s0,-88
    5032:	00001097          	auipc	ra,0x1
    5036:	bc0080e7          	jalr	-1088(ra) # 5bf2 <open>
    503a:	00001097          	auipc	ra,0x1
    503e:	ba0080e7          	jalr	-1120(ra) # 5bda <close>
            close(open(file, 0));
    5042:	4581                	li	a1,0
    5044:	fa840513          	addi	a0,s0,-88
    5048:	00001097          	auipc	ra,0x1
    504c:	baa080e7          	jalr	-1110(ra) # 5bf2 <open>
    5050:	00001097          	auipc	ra,0x1
    5054:	b8a080e7          	jalr	-1142(ra) # 5bda <close>
            close(open(file, 0));
    5058:	4581                	li	a1,0
    505a:	fa840513          	addi	a0,s0,-88
    505e:	00001097          	auipc	ra,0x1
    5062:	b94080e7          	jalr	-1132(ra) # 5bf2 <open>
    5066:	00001097          	auipc	ra,0x1
    506a:	b74080e7          	jalr	-1164(ra) # 5bda <close>
            close(open(file, 0));
    506e:	4581                	li	a1,0
    5070:	fa840513          	addi	a0,s0,-88
    5074:	00001097          	auipc	ra,0x1
    5078:	b7e080e7          	jalr	-1154(ra) # 5bf2 <open>
    507c:	00001097          	auipc	ra,0x1
    5080:	b5e080e7          	jalr	-1186(ra) # 5bda <close>
            close(open(file, 0));
    5084:	4581                	li	a1,0
    5086:	fa840513          	addi	a0,s0,-88
    508a:	00001097          	auipc	ra,0x1
    508e:	b68080e7          	jalr	-1176(ra) # 5bf2 <open>
    5092:	00001097          	auipc	ra,0x1
    5096:	b48080e7          	jalr	-1208(ra) # 5bda <close>
        if (pid == 0)
    509a:	08090363          	beqz	s2,5120 <concreate+0x2d2>
            wait(0);
    509e:	4501                	li	a0,0
    50a0:	00001097          	auipc	ra,0x1
    50a4:	b1a080e7          	jalr	-1254(ra) # 5bba <wait>
    for (i = 0; i < N; i++) {
    50a8:	2485                	addiw	s1,s1,1
    50aa:	0f448563          	beq	s1,s4,5194 <concreate+0x346>
        file[1] = '0' + i;
    50ae:	0304879b          	addiw	a5,s1,48
    50b2:	faf404a3          	sb	a5,-87(s0)
        pid = fork();
    50b6:	00001097          	auipc	ra,0x1
    50ba:	af4080e7          	jalr	-1292(ra) # 5baa <fork>
    50be:	892a                	mv	s2,a0
        if (pid < 0) {
    50c0:	f2054de3          	bltz	a0,4ffa <concreate+0x1ac>
        if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    50c4:	0354e73b          	remw	a4,s1,s5
    50c8:	00a767b3          	or	a5,a4,a0
    50cc:	2781                	sext.w	a5,a5
    50ce:	d7a1                	beqz	a5,5016 <concreate+0x1c8>
    50d0:	01671363          	bne	a4,s6,50d6 <concreate+0x288>
    50d4:	f129                	bnez	a0,5016 <concreate+0x1c8>
            unlink(file);
    50d6:	fa840513          	addi	a0,s0,-88
    50da:	00001097          	auipc	ra,0x1
    50de:	b28080e7          	jalr	-1240(ra) # 5c02 <unlink>
            unlink(file);
    50e2:	fa840513          	addi	a0,s0,-88
    50e6:	00001097          	auipc	ra,0x1
    50ea:	b1c080e7          	jalr	-1252(ra) # 5c02 <unlink>
            unlink(file);
    50ee:	fa840513          	addi	a0,s0,-88
    50f2:	00001097          	auipc	ra,0x1
    50f6:	b10080e7          	jalr	-1264(ra) # 5c02 <unlink>
            unlink(file);
    50fa:	fa840513          	addi	a0,s0,-88
    50fe:	00001097          	auipc	ra,0x1
    5102:	b04080e7          	jalr	-1276(ra) # 5c02 <unlink>
            unlink(file);
    5106:	fa840513          	addi	a0,s0,-88
    510a:	00001097          	auipc	ra,0x1
    510e:	af8080e7          	jalr	-1288(ra) # 5c02 <unlink>
            unlink(file);
    5112:	fa840513          	addi	a0,s0,-88
    5116:	00001097          	auipc	ra,0x1
    511a:	aec080e7          	jalr	-1300(ra) # 5c02 <unlink>
    511e:	bfb5                	j	509a <concreate+0x24c>
            exit(0);
    5120:	4501                	li	a0,0
    5122:	00001097          	auipc	ra,0x1
    5126:	a90080e7          	jalr	-1392(ra) # 5bb2 <exit>
            close(fd);
    512a:	00001097          	auipc	ra,0x1
    512e:	ab0080e7          	jalr	-1360(ra) # 5bda <close>
        if (pid == 0) {
    5132:	bb5d                	j	4ee8 <concreate+0x9a>
            close(fd);
    5134:	00001097          	auipc	ra,0x1
    5138:	aa6080e7          	jalr	-1370(ra) # 5bda <close>
            wait(&xstatus);
    513c:	f6c40513          	addi	a0,s0,-148
    5140:	00001097          	auipc	ra,0x1
    5144:	a7a080e7          	jalr	-1414(ra) # 5bba <wait>
            if (xstatus != 0)
    5148:	f6c42483          	lw	s1,-148(s0)
    514c:	da0493e3          	bnez	s1,4ef2 <concreate+0xa4>
    for (i = 0; i < N; i++) {
    5150:	2905                	addiw	s2,s2,1
    5152:	db4905e3          	beq	s2,s4,4efc <concreate+0xae>
        file[1] = '0' + i;
    5156:	0309079b          	addiw	a5,s2,48
    515a:	faf404a3          	sb	a5,-87(s0)
        unlink(file);
    515e:	fa840513          	addi	a0,s0,-88
    5162:	00001097          	auipc	ra,0x1
    5166:	aa0080e7          	jalr	-1376(ra) # 5c02 <unlink>
        pid = fork();
    516a:	00001097          	auipc	ra,0x1
    516e:	a40080e7          	jalr	-1472(ra) # 5baa <fork>
        if (pid && (i % 3) == 1) {
    5172:	d20502e3          	beqz	a0,4e96 <concreate+0x48>
    5176:	036967bb          	remw	a5,s2,s6
    517a:	d15786e3          	beq	a5,s5,4e86 <concreate+0x38>
            fd = open(file, O_CREATE | O_RDWR);
    517e:	20200593          	li	a1,514
    5182:	fa840513          	addi	a0,s0,-88
    5186:	00001097          	auipc	ra,0x1
    518a:	a6c080e7          	jalr	-1428(ra) # 5bf2 <open>
            if (fd < 0) {
    518e:	fa0553e3          	bgez	a0,5134 <concreate+0x2e6>
    5192:	b315                	j	4eb6 <concreate+0x68>
}
    5194:	60ea                	ld	ra,152(sp)
    5196:	644a                	ld	s0,144(sp)
    5198:	64aa                	ld	s1,136(sp)
    519a:	690a                	ld	s2,128(sp)
    519c:	79e6                	ld	s3,120(sp)
    519e:	7a46                	ld	s4,112(sp)
    51a0:	7aa6                	ld	s5,104(sp)
    51a2:	7b06                	ld	s6,96(sp)
    51a4:	6be6                	ld	s7,88(sp)
    51a6:	610d                	addi	sp,sp,160
    51a8:	8082                	ret

00000000000051aa <bigfile>:
{
    51aa:	7139                	addi	sp,sp,-64
    51ac:	fc06                	sd	ra,56(sp)
    51ae:	f822                	sd	s0,48(sp)
    51b0:	f426                	sd	s1,40(sp)
    51b2:	f04a                	sd	s2,32(sp)
    51b4:	ec4e                	sd	s3,24(sp)
    51b6:	e852                	sd	s4,16(sp)
    51b8:	e456                	sd	s5,8(sp)
    51ba:	0080                	addi	s0,sp,64
    51bc:	8aaa                	mv	s5,a0
    unlink("bigfile.dat");
    51be:	00003517          	auipc	a0,0x3
    51c2:	d5250513          	addi	a0,a0,-686 # 7f10 <malloc+0x1f2c>
    51c6:	00001097          	auipc	ra,0x1
    51ca:	a3c080e7          	jalr	-1476(ra) # 5c02 <unlink>
    fd = open("bigfile.dat", O_CREATE | O_RDWR);
    51ce:	20200593          	li	a1,514
    51d2:	00003517          	auipc	a0,0x3
    51d6:	d3e50513          	addi	a0,a0,-706 # 7f10 <malloc+0x1f2c>
    51da:	00001097          	auipc	ra,0x1
    51de:	a18080e7          	jalr	-1512(ra) # 5bf2 <open>
    51e2:	89aa                	mv	s3,a0
    for (i = 0; i < N; i++) {
    51e4:	4481                	li	s1,0
        memset(buf, i, SZ);
    51e6:	00008917          	auipc	s2,0x8
    51ea:	a9290913          	addi	s2,s2,-1390 # cc78 <buf>
    for (i = 0; i < N; i++) {
    51ee:	4a51                	li	s4,20
    if (fd < 0) {
    51f0:	0a054063          	bltz	a0,5290 <bigfile+0xe6>
        memset(buf, i, SZ);
    51f4:	25800613          	li	a2,600
    51f8:	85a6                	mv	a1,s1
    51fa:	854a                	mv	a0,s2
    51fc:	00000097          	auipc	ra,0x0
    5200:	7bc080e7          	jalr	1980(ra) # 59b8 <memset>
        if (write(fd, buf, SZ) != SZ) {
    5204:	25800613          	li	a2,600
    5208:	85ca                	mv	a1,s2
    520a:	854e                	mv	a0,s3
    520c:	00001097          	auipc	ra,0x1
    5210:	9c6080e7          	jalr	-1594(ra) # 5bd2 <write>
    5214:	25800793          	li	a5,600
    5218:	08f51a63          	bne	a0,a5,52ac <bigfile+0x102>
    for (i = 0; i < N; i++) {
    521c:	2485                	addiw	s1,s1,1
    521e:	fd449be3          	bne	s1,s4,51f4 <bigfile+0x4a>
    close(fd);
    5222:	854e                	mv	a0,s3
    5224:	00001097          	auipc	ra,0x1
    5228:	9b6080e7          	jalr	-1610(ra) # 5bda <close>
    fd = open("bigfile.dat", 0);
    522c:	4581                	li	a1,0
    522e:	00003517          	auipc	a0,0x3
    5232:	ce250513          	addi	a0,a0,-798 # 7f10 <malloc+0x1f2c>
    5236:	00001097          	auipc	ra,0x1
    523a:	9bc080e7          	jalr	-1604(ra) # 5bf2 <open>
    523e:	8a2a                	mv	s4,a0
    total = 0;
    5240:	4981                	li	s3,0
    for (i = 0;; i++) {
    5242:	4481                	li	s1,0
        cc = read(fd, buf, SZ / 2);
    5244:	00008917          	auipc	s2,0x8
    5248:	a3490913          	addi	s2,s2,-1484 # cc78 <buf>
    if (fd < 0) {
    524c:	06054e63          	bltz	a0,52c8 <bigfile+0x11e>
        cc = read(fd, buf, SZ / 2);
    5250:	12c00613          	li	a2,300
    5254:	85ca                	mv	a1,s2
    5256:	8552                	mv	a0,s4
    5258:	00001097          	auipc	ra,0x1
    525c:	972080e7          	jalr	-1678(ra) # 5bca <read>
        if (cc < 0) {
    5260:	08054263          	bltz	a0,52e4 <bigfile+0x13a>
        if (cc == 0)
    5264:	c971                	beqz	a0,5338 <bigfile+0x18e>
        if (cc != SZ / 2) {
    5266:	12c00793          	li	a5,300
    526a:	08f51b63          	bne	a0,a5,5300 <bigfile+0x156>
        if (buf[0] != i / 2 || buf[SZ / 2 - 1] != i / 2) {
    526e:	01f4d79b          	srliw	a5,s1,0x1f
    5272:	9fa5                	addw	a5,a5,s1
    5274:	4017d79b          	sraiw	a5,a5,0x1
    5278:	00094703          	lbu	a4,0(s2)
    527c:	0af71063          	bne	a4,a5,531c <bigfile+0x172>
    5280:	12b94703          	lbu	a4,299(s2)
    5284:	08f71c63          	bne	a4,a5,531c <bigfile+0x172>
        total += cc;
    5288:	12c9899b          	addiw	s3,s3,300
    for (i = 0;; i++) {
    528c:	2485                	addiw	s1,s1,1
        cc = read(fd, buf, SZ / 2);
    528e:	b7c9                	j	5250 <bigfile+0xa6>
        printf("%s: cannot create bigfile", s);
    5290:	85d6                	mv	a1,s5
    5292:	00003517          	auipc	a0,0x3
    5296:	c8e50513          	addi	a0,a0,-882 # 7f20 <malloc+0x1f3c>
    529a:	00001097          	auipc	ra,0x1
    529e:	c92080e7          	jalr	-878(ra) # 5f2c <printf>
        exit(1);
    52a2:	4505                	li	a0,1
    52a4:	00001097          	auipc	ra,0x1
    52a8:	90e080e7          	jalr	-1778(ra) # 5bb2 <exit>
            printf("%s: write bigfile failed\n", s);
    52ac:	85d6                	mv	a1,s5
    52ae:	00003517          	auipc	a0,0x3
    52b2:	c9250513          	addi	a0,a0,-878 # 7f40 <malloc+0x1f5c>
    52b6:	00001097          	auipc	ra,0x1
    52ba:	c76080e7          	jalr	-906(ra) # 5f2c <printf>
            exit(1);
    52be:	4505                	li	a0,1
    52c0:	00001097          	auipc	ra,0x1
    52c4:	8f2080e7          	jalr	-1806(ra) # 5bb2 <exit>
        printf("%s: cannot open bigfile\n", s);
    52c8:	85d6                	mv	a1,s5
    52ca:	00003517          	auipc	a0,0x3
    52ce:	c9650513          	addi	a0,a0,-874 # 7f60 <malloc+0x1f7c>
    52d2:	00001097          	auipc	ra,0x1
    52d6:	c5a080e7          	jalr	-934(ra) # 5f2c <printf>
        exit(1);
    52da:	4505                	li	a0,1
    52dc:	00001097          	auipc	ra,0x1
    52e0:	8d6080e7          	jalr	-1834(ra) # 5bb2 <exit>
            printf("%s: read bigfile failed\n", s);
    52e4:	85d6                	mv	a1,s5
    52e6:	00003517          	auipc	a0,0x3
    52ea:	c9a50513          	addi	a0,a0,-870 # 7f80 <malloc+0x1f9c>
    52ee:	00001097          	auipc	ra,0x1
    52f2:	c3e080e7          	jalr	-962(ra) # 5f2c <printf>
            exit(1);
    52f6:	4505                	li	a0,1
    52f8:	00001097          	auipc	ra,0x1
    52fc:	8ba080e7          	jalr	-1862(ra) # 5bb2 <exit>
            printf("%s: short read bigfile\n", s);
    5300:	85d6                	mv	a1,s5
    5302:	00003517          	auipc	a0,0x3
    5306:	c9e50513          	addi	a0,a0,-866 # 7fa0 <malloc+0x1fbc>
    530a:	00001097          	auipc	ra,0x1
    530e:	c22080e7          	jalr	-990(ra) # 5f2c <printf>
            exit(1);
    5312:	4505                	li	a0,1
    5314:	00001097          	auipc	ra,0x1
    5318:	89e080e7          	jalr	-1890(ra) # 5bb2 <exit>
            printf("%s: read bigfile wrong data\n", s);
    531c:	85d6                	mv	a1,s5
    531e:	00003517          	auipc	a0,0x3
    5322:	c9a50513          	addi	a0,a0,-870 # 7fb8 <malloc+0x1fd4>
    5326:	00001097          	auipc	ra,0x1
    532a:	c06080e7          	jalr	-1018(ra) # 5f2c <printf>
            exit(1);
    532e:	4505                	li	a0,1
    5330:	00001097          	auipc	ra,0x1
    5334:	882080e7          	jalr	-1918(ra) # 5bb2 <exit>
    close(fd);
    5338:	8552                	mv	a0,s4
    533a:	00001097          	auipc	ra,0x1
    533e:	8a0080e7          	jalr	-1888(ra) # 5bda <close>
    if (total != N * SZ) {
    5342:	678d                	lui	a5,0x3
    5344:	ee078793          	addi	a5,a5,-288 # 2ee0 <sbrklast+0x9c>
    5348:	02f99363          	bne	s3,a5,536e <bigfile+0x1c4>
    unlink("bigfile.dat");
    534c:	00003517          	auipc	a0,0x3
    5350:	bc450513          	addi	a0,a0,-1084 # 7f10 <malloc+0x1f2c>
    5354:	00001097          	auipc	ra,0x1
    5358:	8ae080e7          	jalr	-1874(ra) # 5c02 <unlink>
}
    535c:	70e2                	ld	ra,56(sp)
    535e:	7442                	ld	s0,48(sp)
    5360:	74a2                	ld	s1,40(sp)
    5362:	7902                	ld	s2,32(sp)
    5364:	69e2                	ld	s3,24(sp)
    5366:	6a42                	ld	s4,16(sp)
    5368:	6aa2                	ld	s5,8(sp)
    536a:	6121                	addi	sp,sp,64
    536c:	8082                	ret
        printf("%s: read bigfile wrong total\n", s);
    536e:	85d6                	mv	a1,s5
    5370:	00003517          	auipc	a0,0x3
    5374:	c6850513          	addi	a0,a0,-920 # 7fd8 <malloc+0x1ff4>
    5378:	00001097          	auipc	ra,0x1
    537c:	bb4080e7          	jalr	-1100(ra) # 5f2c <printf>
        exit(1);
    5380:	4505                	li	a0,1
    5382:	00001097          	auipc	ra,0x1
    5386:	830080e7          	jalr	-2000(ra) # 5bb2 <exit>

000000000000538a <fsfull>:
{
    538a:	7171                	addi	sp,sp,-176
    538c:	f506                	sd	ra,168(sp)
    538e:	f122                	sd	s0,160(sp)
    5390:	ed26                	sd	s1,152(sp)
    5392:	e94a                	sd	s2,144(sp)
    5394:	e54e                	sd	s3,136(sp)
    5396:	e152                	sd	s4,128(sp)
    5398:	fcd6                	sd	s5,120(sp)
    539a:	f8da                	sd	s6,112(sp)
    539c:	f4de                	sd	s7,104(sp)
    539e:	f0e2                	sd	s8,96(sp)
    53a0:	ece6                	sd	s9,88(sp)
    53a2:	e8ea                	sd	s10,80(sp)
    53a4:	e4ee                	sd	s11,72(sp)
    53a6:	1900                	addi	s0,sp,176
    printf("fsfull test\n");
    53a8:	00003517          	auipc	a0,0x3
    53ac:	c5050513          	addi	a0,a0,-944 # 7ff8 <malloc+0x2014>
    53b0:	00001097          	auipc	ra,0x1
    53b4:	b7c080e7          	jalr	-1156(ra) # 5f2c <printf>
    for (nfiles = 0;; nfiles++) {
    53b8:	4481                	li	s1,0
        name[0] = 'f';
    53ba:	06600d13          	li	s10,102
        name[1] = '0' + nfiles / 1000;
    53be:	3e800c13          	li	s8,1000
        name[2] = '0' + (nfiles % 1000) / 100;
    53c2:	06400b93          	li	s7,100
        name[3] = '0' + (nfiles % 100) / 10;
    53c6:	4b29                	li	s6,10
        printf("writing %s\n", name);
    53c8:	00003c97          	auipc	s9,0x3
    53cc:	c40c8c93          	addi	s9,s9,-960 # 8008 <malloc+0x2024>
        int total = 0;
    53d0:	4d81                	li	s11,0
            int cc = write(fd, buf, BSIZE);
    53d2:	00008a17          	auipc	s4,0x8
    53d6:	8a6a0a13          	addi	s4,s4,-1882 # cc78 <buf>
        name[0] = 'f';
    53da:	f5a40823          	sb	s10,-176(s0)
        name[1] = '0' + nfiles / 1000;
    53de:	0384c7bb          	divw	a5,s1,s8
    53e2:	0307879b          	addiw	a5,a5,48
    53e6:	f4f408a3          	sb	a5,-175(s0)
        name[2] = '0' + (nfiles % 1000) / 100;
    53ea:	0384e7bb          	remw	a5,s1,s8
    53ee:	0377c7bb          	divw	a5,a5,s7
    53f2:	0307879b          	addiw	a5,a5,48
    53f6:	f4f40923          	sb	a5,-174(s0)
        name[3] = '0' + (nfiles % 100) / 10;
    53fa:	0374e7bb          	remw	a5,s1,s7
    53fe:	0367c7bb          	divw	a5,a5,s6
    5402:	0307879b          	addiw	a5,a5,48
    5406:	f4f409a3          	sb	a5,-173(s0)
        name[4] = '0' + (nfiles % 10);
    540a:	0364e7bb          	remw	a5,s1,s6
    540e:	0307879b          	addiw	a5,a5,48
    5412:	f4f40a23          	sb	a5,-172(s0)
        name[5] = '\0';
    5416:	f4040aa3          	sb	zero,-171(s0)
        printf("writing %s\n", name);
    541a:	f5040593          	addi	a1,s0,-176
    541e:	8566                	mv	a0,s9
    5420:	00001097          	auipc	ra,0x1
    5424:	b0c080e7          	jalr	-1268(ra) # 5f2c <printf>
        int fd = open(name, O_CREATE | O_RDWR);
    5428:	20200593          	li	a1,514
    542c:	f5040513          	addi	a0,s0,-176
    5430:	00000097          	auipc	ra,0x0
    5434:	7c2080e7          	jalr	1986(ra) # 5bf2 <open>
    5438:	892a                	mv	s2,a0
        if (fd < 0) {
    543a:	0a055663          	bgez	a0,54e6 <fsfull+0x15c>
            printf("open %s failed\n", name);
    543e:	f5040593          	addi	a1,s0,-176
    5442:	00003517          	auipc	a0,0x3
    5446:	bd650513          	addi	a0,a0,-1066 # 8018 <malloc+0x2034>
    544a:	00001097          	auipc	ra,0x1
    544e:	ae2080e7          	jalr	-1310(ra) # 5f2c <printf>
    while (nfiles >= 0) {
    5452:	0604c363          	bltz	s1,54b8 <fsfull+0x12e>
        name[0] = 'f';
    5456:	06600b13          	li	s6,102
        name[1] = '0' + nfiles / 1000;
    545a:	3e800a13          	li	s4,1000
        name[2] = '0' + (nfiles % 1000) / 100;
    545e:	06400993          	li	s3,100
        name[3] = '0' + (nfiles % 100) / 10;
    5462:	4929                	li	s2,10
    while (nfiles >= 0) {
    5464:	5afd                	li	s5,-1
        name[0] = 'f';
    5466:	f5640823          	sb	s6,-176(s0)
        name[1] = '0' + nfiles / 1000;
    546a:	0344c7bb          	divw	a5,s1,s4
    546e:	0307879b          	addiw	a5,a5,48
    5472:	f4f408a3          	sb	a5,-175(s0)
        name[2] = '0' + (nfiles % 1000) / 100;
    5476:	0344e7bb          	remw	a5,s1,s4
    547a:	0337c7bb          	divw	a5,a5,s3
    547e:	0307879b          	addiw	a5,a5,48
    5482:	f4f40923          	sb	a5,-174(s0)
        name[3] = '0' + (nfiles % 100) / 10;
    5486:	0334e7bb          	remw	a5,s1,s3
    548a:	0327c7bb          	divw	a5,a5,s2
    548e:	0307879b          	addiw	a5,a5,48
    5492:	f4f409a3          	sb	a5,-173(s0)
        name[4] = '0' + (nfiles % 10);
    5496:	0324e7bb          	remw	a5,s1,s2
    549a:	0307879b          	addiw	a5,a5,48
    549e:	f4f40a23          	sb	a5,-172(s0)
        name[5] = '\0';
    54a2:	f4040aa3          	sb	zero,-171(s0)
        unlink(name);
    54a6:	f5040513          	addi	a0,s0,-176
    54aa:	00000097          	auipc	ra,0x0
    54ae:	758080e7          	jalr	1880(ra) # 5c02 <unlink>
        nfiles--;
    54b2:	34fd                	addiw	s1,s1,-1
    while (nfiles >= 0) {
    54b4:	fb5499e3          	bne	s1,s5,5466 <fsfull+0xdc>
    printf("fsfull test finished\n");
    54b8:	00003517          	auipc	a0,0x3
    54bc:	b8050513          	addi	a0,a0,-1152 # 8038 <malloc+0x2054>
    54c0:	00001097          	auipc	ra,0x1
    54c4:	a6c080e7          	jalr	-1428(ra) # 5f2c <printf>
}
    54c8:	70aa                	ld	ra,168(sp)
    54ca:	740a                	ld	s0,160(sp)
    54cc:	64ea                	ld	s1,152(sp)
    54ce:	694a                	ld	s2,144(sp)
    54d0:	69aa                	ld	s3,136(sp)
    54d2:	6a0a                	ld	s4,128(sp)
    54d4:	7ae6                	ld	s5,120(sp)
    54d6:	7b46                	ld	s6,112(sp)
    54d8:	7ba6                	ld	s7,104(sp)
    54da:	7c06                	ld	s8,96(sp)
    54dc:	6ce6                	ld	s9,88(sp)
    54de:	6d46                	ld	s10,80(sp)
    54e0:	6da6                	ld	s11,72(sp)
    54e2:	614d                	addi	sp,sp,176
    54e4:	8082                	ret
        int total = 0;
    54e6:	89ee                	mv	s3,s11
            if (cc < BSIZE)
    54e8:	3ff00a93          	li	s5,1023
            int cc = write(fd, buf, BSIZE);
    54ec:	40000613          	li	a2,1024
    54f0:	85d2                	mv	a1,s4
    54f2:	854a                	mv	a0,s2
    54f4:	00000097          	auipc	ra,0x0
    54f8:	6de080e7          	jalr	1758(ra) # 5bd2 <write>
            if (cc < BSIZE)
    54fc:	00aad563          	bge	s5,a0,5506 <fsfull+0x17c>
            total += cc;
    5500:	00a989bb          	addw	s3,s3,a0
        while (1) {
    5504:	b7e5                	j	54ec <fsfull+0x162>
        printf("wrote %d bytes\n", total);
    5506:	85ce                	mv	a1,s3
    5508:	00003517          	auipc	a0,0x3
    550c:	b2050513          	addi	a0,a0,-1248 # 8028 <malloc+0x2044>
    5510:	00001097          	auipc	ra,0x1
    5514:	a1c080e7          	jalr	-1508(ra) # 5f2c <printf>
        close(fd);
    5518:	854a                	mv	a0,s2
    551a:	00000097          	auipc	ra,0x0
    551e:	6c0080e7          	jalr	1728(ra) # 5bda <close>
        if (total == 0)
    5522:	f20988e3          	beqz	s3,5452 <fsfull+0xc8>
    for (nfiles = 0;; nfiles++) {
    5526:	2485                	addiw	s1,s1,1
    5528:	bd4d                	j	53da <fsfull+0x50>

000000000000552a <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int run(void f(char *), char *s)
{
    552a:	7179                	addi	sp,sp,-48
    552c:	f406                	sd	ra,40(sp)
    552e:	f022                	sd	s0,32(sp)
    5530:	ec26                	sd	s1,24(sp)
    5532:	e84a                	sd	s2,16(sp)
    5534:	1800                	addi	s0,sp,48
    5536:	84aa                	mv	s1,a0
    5538:	892e                	mv	s2,a1
    int pid;
    int xstatus;

    printf("test %s: ", s);
    553a:	00003517          	auipc	a0,0x3
    553e:	b1650513          	addi	a0,a0,-1258 # 8050 <malloc+0x206c>
    5542:	00001097          	auipc	ra,0x1
    5546:	9ea080e7          	jalr	-1558(ra) # 5f2c <printf>
    if ((pid = fork()) < 0) {
    554a:	00000097          	auipc	ra,0x0
    554e:	660080e7          	jalr	1632(ra) # 5baa <fork>
    5552:	02054e63          	bltz	a0,558e <run+0x64>
        printf("runtest: fork error\n");
        exit(1);
    }
    if (pid == 0) {
    5556:	c929                	beqz	a0,55a8 <run+0x7e>
        f(s);
        exit(0);
    }
    else {
        wait(&xstatus);
    5558:	fdc40513          	addi	a0,s0,-36
    555c:	00000097          	auipc	ra,0x0
    5560:	65e080e7          	jalr	1630(ra) # 5bba <wait>
        if (xstatus != 0)
    5564:	fdc42783          	lw	a5,-36(s0)
    5568:	c7b9                	beqz	a5,55b6 <run+0x8c>
            printf("FAILED\n");
    556a:	00003517          	auipc	a0,0x3
    556e:	b0e50513          	addi	a0,a0,-1266 # 8078 <malloc+0x2094>
    5572:	00001097          	auipc	ra,0x1
    5576:	9ba080e7          	jalr	-1606(ra) # 5f2c <printf>
        else
            printf("OK\n");
        return xstatus == 0;
    557a:	fdc42503          	lw	a0,-36(s0)
    }
}
    557e:	00153513          	seqz	a0,a0
    5582:	70a2                	ld	ra,40(sp)
    5584:	7402                	ld	s0,32(sp)
    5586:	64e2                	ld	s1,24(sp)
    5588:	6942                	ld	s2,16(sp)
    558a:	6145                	addi	sp,sp,48
    558c:	8082                	ret
        printf("runtest: fork error\n");
    558e:	00003517          	auipc	a0,0x3
    5592:	ad250513          	addi	a0,a0,-1326 # 8060 <malloc+0x207c>
    5596:	00001097          	auipc	ra,0x1
    559a:	996080e7          	jalr	-1642(ra) # 5f2c <printf>
        exit(1);
    559e:	4505                	li	a0,1
    55a0:	00000097          	auipc	ra,0x0
    55a4:	612080e7          	jalr	1554(ra) # 5bb2 <exit>
        f(s);
    55a8:	854a                	mv	a0,s2
    55aa:	9482                	jalr	s1
        exit(0);
    55ac:	4501                	li	a0,0
    55ae:	00000097          	auipc	ra,0x0
    55b2:	604080e7          	jalr	1540(ra) # 5bb2 <exit>
            printf("OK\n");
    55b6:	00003517          	auipc	a0,0x3
    55ba:	aca50513          	addi	a0,a0,-1334 # 8080 <malloc+0x209c>
    55be:	00001097          	auipc	ra,0x1
    55c2:	96e080e7          	jalr	-1682(ra) # 5f2c <printf>
    55c6:	bf55                	j	557a <run+0x50>

00000000000055c8 <runtests>:

int runtests(struct test *tests, char *justone)
{
    55c8:	1101                	addi	sp,sp,-32
    55ca:	ec06                	sd	ra,24(sp)
    55cc:	e822                	sd	s0,16(sp)
    55ce:	e426                	sd	s1,8(sp)
    55d0:	e04a                	sd	s2,0(sp)
    55d2:	1000                	addi	s0,sp,32
    55d4:	84aa                	mv	s1,a0
    55d6:	892e                	mv	s2,a1
    for (struct test *t = tests; t->s != 0; t++) {
    55d8:	6508                	ld	a0,8(a0)
    55da:	ed09                	bnez	a0,55f4 <runtests+0x2c>
                printf("SOME TESTS FAILED\n");
                return 1;
            }
        }
    }
    return 0;
    55dc:	4501                	li	a0,0
    55de:	a82d                	j	5618 <runtests+0x50>
            if (!run(t->f, t->s)) {
    55e0:	648c                	ld	a1,8(s1)
    55e2:	6088                	ld	a0,0(s1)
    55e4:	00000097          	auipc	ra,0x0
    55e8:	f46080e7          	jalr	-186(ra) # 552a <run>
    55ec:	cd09                	beqz	a0,5606 <runtests+0x3e>
    for (struct test *t = tests; t->s != 0; t++) {
    55ee:	04c1                	addi	s1,s1,16
    55f0:	6488                	ld	a0,8(s1)
    55f2:	c11d                	beqz	a0,5618 <runtests+0x50>
        if ((justone == 0) || strcmp(t->s, justone) == 0) {
    55f4:	fe0906e3          	beqz	s2,55e0 <runtests+0x18>
    55f8:	85ca                	mv	a1,s2
    55fa:	00000097          	auipc	ra,0x0
    55fe:	368080e7          	jalr	872(ra) # 5962 <strcmp>
    5602:	f575                	bnez	a0,55ee <runtests+0x26>
    5604:	bff1                	j	55e0 <runtests+0x18>
                printf("SOME TESTS FAILED\n");
    5606:	00003517          	auipc	a0,0x3
    560a:	a8250513          	addi	a0,a0,-1406 # 8088 <malloc+0x20a4>
    560e:	00001097          	auipc	ra,0x1
    5612:	91e080e7          	jalr	-1762(ra) # 5f2c <printf>
                return 1;
    5616:	4505                	li	a0,1
}
    5618:	60e2                	ld	ra,24(sp)
    561a:	6442                	ld	s0,16(sp)
    561c:	64a2                	ld	s1,8(sp)
    561e:	6902                	ld	s2,0(sp)
    5620:	6105                	addi	sp,sp,32
    5622:	8082                	ret

0000000000005624 <countfree>:
// touches the pages to force allocation.
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int countfree()
{
    5624:	7139                	addi	sp,sp,-64
    5626:	fc06                	sd	ra,56(sp)
    5628:	f822                	sd	s0,48(sp)
    562a:	f426                	sd	s1,40(sp)
    562c:	f04a                	sd	s2,32(sp)
    562e:	ec4e                	sd	s3,24(sp)
    5630:	0080                	addi	s0,sp,64
    int fds[2];

    if (pipe(fds) < 0) {
    5632:	fc840513          	addi	a0,s0,-56
    5636:	00000097          	auipc	ra,0x0
    563a:	58c080e7          	jalr	1420(ra) # 5bc2 <pipe>
    563e:	06054763          	bltz	a0,56ac <countfree+0x88>
        printf("pipe() failed in countfree()\n");
        exit(1);
    }

    int pid = fork();
    5642:	00000097          	auipc	ra,0x0
    5646:	568080e7          	jalr	1384(ra) # 5baa <fork>

    if (pid < 0) {
    564a:	06054e63          	bltz	a0,56c6 <countfree+0xa2>
        printf("fork failed in countfree()\n");
        exit(1);
    }

    if (pid == 0) {
    564e:	ed51                	bnez	a0,56ea <countfree+0xc6>
        close(fds[0]);
    5650:	fc842503          	lw	a0,-56(s0)
    5654:	00000097          	auipc	ra,0x0
    5658:	586080e7          	jalr	1414(ra) # 5bda <close>

        while (1) {
            uint64 a = (uint64)sbrk(4096);
            if (a == 0xffffffffffffffff) {
    565c:	597d                	li	s2,-1
                break;
            }

            // modify the memory to make sure it's really allocated.
            *(char *)(a + 4096 - 1) = 1;
    565e:	4485                	li	s1,1

            // report back one more page.
            if (write(fds[1], "x", 1) != 1) {
    5660:	00001997          	auipc	s3,0x1
    5664:	b1898993          	addi	s3,s3,-1256 # 6178 <malloc+0x194>
            uint64 a = (uint64)sbrk(4096);
    5668:	6505                	lui	a0,0x1
    566a:	00000097          	auipc	ra,0x0
    566e:	5d0080e7          	jalr	1488(ra) # 5c3a <sbrk>
            if (a == 0xffffffffffffffff) {
    5672:	07250763          	beq	a0,s2,56e0 <countfree+0xbc>
            *(char *)(a + 4096 - 1) = 1;
    5676:	6785                	lui	a5,0x1
    5678:	97aa                	add	a5,a5,a0
    567a:	fe978fa3          	sb	s1,-1(a5) # fff <linktest+0x10b>
            if (write(fds[1], "x", 1) != 1) {
    567e:	8626                	mv	a2,s1
    5680:	85ce                	mv	a1,s3
    5682:	fcc42503          	lw	a0,-52(s0)
    5686:	00000097          	auipc	ra,0x0
    568a:	54c080e7          	jalr	1356(ra) # 5bd2 <write>
    568e:	fc950de3          	beq	a0,s1,5668 <countfree+0x44>
                printf("write() failed in countfree()\n");
    5692:	00003517          	auipc	a0,0x3
    5696:	a4e50513          	addi	a0,a0,-1458 # 80e0 <malloc+0x20fc>
    569a:	00001097          	auipc	ra,0x1
    569e:	892080e7          	jalr	-1902(ra) # 5f2c <printf>
                exit(1);
    56a2:	4505                	li	a0,1
    56a4:	00000097          	auipc	ra,0x0
    56a8:	50e080e7          	jalr	1294(ra) # 5bb2 <exit>
        printf("pipe() failed in countfree()\n");
    56ac:	00003517          	auipc	a0,0x3
    56b0:	9f450513          	addi	a0,a0,-1548 # 80a0 <malloc+0x20bc>
    56b4:	00001097          	auipc	ra,0x1
    56b8:	878080e7          	jalr	-1928(ra) # 5f2c <printf>
        exit(1);
    56bc:	4505                	li	a0,1
    56be:	00000097          	auipc	ra,0x0
    56c2:	4f4080e7          	jalr	1268(ra) # 5bb2 <exit>
        printf("fork failed in countfree()\n");
    56c6:	00003517          	auipc	a0,0x3
    56ca:	9fa50513          	addi	a0,a0,-1542 # 80c0 <malloc+0x20dc>
    56ce:	00001097          	auipc	ra,0x1
    56d2:	85e080e7          	jalr	-1954(ra) # 5f2c <printf>
        exit(1);
    56d6:	4505                	li	a0,1
    56d8:	00000097          	auipc	ra,0x0
    56dc:	4da080e7          	jalr	1242(ra) # 5bb2 <exit>
            }
        }

        exit(0);
    56e0:	4501                	li	a0,0
    56e2:	00000097          	auipc	ra,0x0
    56e6:	4d0080e7          	jalr	1232(ra) # 5bb2 <exit>
    }

    close(fds[1]);
    56ea:	fcc42503          	lw	a0,-52(s0)
    56ee:	00000097          	auipc	ra,0x0
    56f2:	4ec080e7          	jalr	1260(ra) # 5bda <close>

    int n = 0;
    56f6:	4481                	li	s1,0
    while (1) {
        char c;
        int cc = read(fds[0], &c, 1);
    56f8:	4605                	li	a2,1
    56fa:	fc740593          	addi	a1,s0,-57
    56fe:	fc842503          	lw	a0,-56(s0)
    5702:	00000097          	auipc	ra,0x0
    5706:	4c8080e7          	jalr	1224(ra) # 5bca <read>
        if (cc < 0) {
    570a:	00054563          	bltz	a0,5714 <countfree+0xf0>
            printf("read() failed in countfree()\n");
            exit(1);
        }
        if (cc == 0)
    570e:	c105                	beqz	a0,572e <countfree+0x10a>
            break;
        n += 1;
    5710:	2485                	addiw	s1,s1,1
    while (1) {
    5712:	b7dd                	j	56f8 <countfree+0xd4>
            printf("read() failed in countfree()\n");
    5714:	00003517          	auipc	a0,0x3
    5718:	9ec50513          	addi	a0,a0,-1556 # 8100 <malloc+0x211c>
    571c:	00001097          	auipc	ra,0x1
    5720:	810080e7          	jalr	-2032(ra) # 5f2c <printf>
            exit(1);
    5724:	4505                	li	a0,1
    5726:	00000097          	auipc	ra,0x0
    572a:	48c080e7          	jalr	1164(ra) # 5bb2 <exit>
    }

    close(fds[0]);
    572e:	fc842503          	lw	a0,-56(s0)
    5732:	00000097          	auipc	ra,0x0
    5736:	4a8080e7          	jalr	1192(ra) # 5bda <close>
    wait((int *)0);
    573a:	4501                	li	a0,0
    573c:	00000097          	auipc	ra,0x0
    5740:	47e080e7          	jalr	1150(ra) # 5bba <wait>

    return n;
}
    5744:	8526                	mv	a0,s1
    5746:	70e2                	ld	ra,56(sp)
    5748:	7442                	ld	s0,48(sp)
    574a:	74a2                	ld	s1,40(sp)
    574c:	7902                	ld	s2,32(sp)
    574e:	69e2                	ld	s3,24(sp)
    5750:	6121                	addi	sp,sp,64
    5752:	8082                	ret

0000000000005754 <drivetests>:

int drivetests(int quick, int continuous, char *justone)
{
    5754:	711d                	addi	sp,sp,-96
    5756:	ec86                	sd	ra,88(sp)
    5758:	e8a2                	sd	s0,80(sp)
    575a:	e4a6                	sd	s1,72(sp)
    575c:	e0ca                	sd	s2,64(sp)
    575e:	fc4e                	sd	s3,56(sp)
    5760:	f852                	sd	s4,48(sp)
    5762:	f456                	sd	s5,40(sp)
    5764:	f05a                	sd	s6,32(sp)
    5766:	ec5e                	sd	s7,24(sp)
    5768:	e862                	sd	s8,16(sp)
    576a:	e466                	sd	s9,8(sp)
    576c:	e06a                	sd	s10,0(sp)
    576e:	1080                	addi	s0,sp,96
    5770:	8a2a                	mv	s4,a0
    5772:	89ae                	mv	s3,a1
    5774:	8932                	mv	s2,a2
    do {
        printf("usertests starting\n");
    5776:	00003b97          	auipc	s7,0x3
    577a:	9aab8b93          	addi	s7,s7,-1622 # 8120 <malloc+0x213c>
        int free0 = countfree();
        int free1 = 0;
        if (runtests(quicktests, justone)) {
    577e:	00004b17          	auipc	s6,0x4
    5782:	892b0b13          	addi	s6,s6,-1902 # 9010 <quicktests>
            if (continuous != 2) {
    5786:	4a89                	li	s5,2
                    return 1;
                }
            }
        }
        if ((free1 = countfree()) < free0) {
            printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5788:	00003c97          	auipc	s9,0x3
    578c:	9d0c8c93          	addi	s9,s9,-1584 # 8158 <malloc+0x2174>
            if (runtests(slowtests, justone)) {
    5790:	00004c17          	auipc	s8,0x4
    5794:	c50c0c13          	addi	s8,s8,-944 # 93e0 <slowtests>
                printf("usertests slow tests starting\n");
    5798:	00003d17          	auipc	s10,0x3
    579c:	9a0d0d13          	addi	s10,s10,-1632 # 8138 <malloc+0x2154>
    57a0:	a839                	j	57be <drivetests+0x6a>
    57a2:	856a                	mv	a0,s10
    57a4:	00000097          	auipc	ra,0x0
    57a8:	788080e7          	jalr	1928(ra) # 5f2c <printf>
    57ac:	a081                	j	57ec <drivetests+0x98>
        if ((free1 = countfree()) < free0) {
    57ae:	00000097          	auipc	ra,0x0
    57b2:	e76080e7          	jalr	-394(ra) # 5624 <countfree>
    57b6:	06954263          	blt	a0,s1,581a <drivetests+0xc6>
            if (continuous != 2) {
                return 1;
            }
        }
    } while (continuous);
    57ba:	06098f63          	beqz	s3,5838 <drivetests+0xe4>
        printf("usertests starting\n");
    57be:	855e                	mv	a0,s7
    57c0:	00000097          	auipc	ra,0x0
    57c4:	76c080e7          	jalr	1900(ra) # 5f2c <printf>
        int free0 = countfree();
    57c8:	00000097          	auipc	ra,0x0
    57cc:	e5c080e7          	jalr	-420(ra) # 5624 <countfree>
    57d0:	84aa                	mv	s1,a0
        if (runtests(quicktests, justone)) {
    57d2:	85ca                	mv	a1,s2
    57d4:	855a                	mv	a0,s6
    57d6:	00000097          	auipc	ra,0x0
    57da:	df2080e7          	jalr	-526(ra) # 55c8 <runtests>
    57de:	c119                	beqz	a0,57e4 <drivetests+0x90>
            if (continuous != 2) {
    57e0:	05599863          	bne	s3,s5,5830 <drivetests+0xdc>
        if (!quick) {
    57e4:	fc0a15e3          	bnez	s4,57ae <drivetests+0x5a>
            if (justone == 0)
    57e8:	fa090de3          	beqz	s2,57a2 <drivetests+0x4e>
            if (runtests(slowtests, justone)) {
    57ec:	85ca                	mv	a1,s2
    57ee:	8562                	mv	a0,s8
    57f0:	00000097          	auipc	ra,0x0
    57f4:	dd8080e7          	jalr	-552(ra) # 55c8 <runtests>
    57f8:	d95d                	beqz	a0,57ae <drivetests+0x5a>
                if (continuous != 2) {
    57fa:	03599d63          	bne	s3,s5,5834 <drivetests+0xe0>
        if ((free1 = countfree()) < free0) {
    57fe:	00000097          	auipc	ra,0x0
    5802:	e26080e7          	jalr	-474(ra) # 5624 <countfree>
    5806:	fa955ae3          	bge	a0,s1,57ba <drivetests+0x66>
            printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    580a:	8626                	mv	a2,s1
    580c:	85aa                	mv	a1,a0
    580e:	8566                	mv	a0,s9
    5810:	00000097          	auipc	ra,0x0
    5814:	71c080e7          	jalr	1820(ra) # 5f2c <printf>
            if (continuous != 2) {
    5818:	b75d                	j	57be <drivetests+0x6a>
            printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    581a:	8626                	mv	a2,s1
    581c:	85aa                	mv	a1,a0
    581e:	8566                	mv	a0,s9
    5820:	00000097          	auipc	ra,0x0
    5824:	70c080e7          	jalr	1804(ra) # 5f2c <printf>
            if (continuous != 2) {
    5828:	f9598be3          	beq	s3,s5,57be <drivetests+0x6a>
                return 1;
    582c:	4505                	li	a0,1
    582e:	a031                	j	583a <drivetests+0xe6>
                return 1;
    5830:	4505                	li	a0,1
    5832:	a021                	j	583a <drivetests+0xe6>
                    return 1;
    5834:	4505                	li	a0,1
    5836:	a011                	j	583a <drivetests+0xe6>
    return 0;
    5838:	854e                	mv	a0,s3
}
    583a:	60e6                	ld	ra,88(sp)
    583c:	6446                	ld	s0,80(sp)
    583e:	64a6                	ld	s1,72(sp)
    5840:	6906                	ld	s2,64(sp)
    5842:	79e2                	ld	s3,56(sp)
    5844:	7a42                	ld	s4,48(sp)
    5846:	7aa2                	ld	s5,40(sp)
    5848:	7b02                	ld	s6,32(sp)
    584a:	6be2                	ld	s7,24(sp)
    584c:	6c42                	ld	s8,16(sp)
    584e:	6ca2                	ld	s9,8(sp)
    5850:	6d02                	ld	s10,0(sp)
    5852:	6125                	addi	sp,sp,96
    5854:	8082                	ret

0000000000005856 <main>:

int main(int argc, char *argv[])
{
    5856:	1101                	addi	sp,sp,-32
    5858:	ec06                	sd	ra,24(sp)
    585a:	e822                	sd	s0,16(sp)
    585c:	e426                	sd	s1,8(sp)
    585e:	e04a                	sd	s2,0(sp)
    5860:	1000                	addi	s0,sp,32
    5862:	84aa                	mv	s1,a0
    int continuous = 0;
    int quick = 0;
    char *justone = 0;

    if (argc == 2 && strcmp(argv[1], "-q") == 0) {
    5864:	4789                	li	a5,2
    5866:	02f50263          	beq	a0,a5,588a <main+0x34>
        continuous = 2;
    }
    else if (argc == 2 && argv[1][0] != '-') {
        justone = argv[1];
    }
    else if (argc > 1) {
    586a:	4785                	li	a5,1
    586c:	06a7cd63          	blt	a5,a0,58e6 <main+0x90>
    char *justone = 0;
    5870:	4601                	li	a2,0
    int quick = 0;
    5872:	4501                	li	a0,0
    int continuous = 0;
    5874:	4581                	li	a1,0
        printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
        exit(1);
    }
    if (drivetests(quick, continuous, justone)) {
    5876:	00000097          	auipc	ra,0x0
    587a:	ede080e7          	jalr	-290(ra) # 5754 <drivetests>
    587e:	c951                	beqz	a0,5912 <main+0xbc>
        exit(1);
    5880:	4505                	li	a0,1
    5882:	00000097          	auipc	ra,0x0
    5886:	330080e7          	jalr	816(ra) # 5bb2 <exit>
    588a:	892e                	mv	s2,a1
    if (argc == 2 && strcmp(argv[1], "-q") == 0) {
    588c:	00003597          	auipc	a1,0x3
    5890:	8fc58593          	addi	a1,a1,-1796 # 8188 <malloc+0x21a4>
    5894:	00893503          	ld	a0,8(s2)
    5898:	00000097          	auipc	ra,0x0
    589c:	0ca080e7          	jalr	202(ra) # 5962 <strcmp>
    58a0:	85aa                	mv	a1,a0
    58a2:	cd39                	beqz	a0,5900 <main+0xaa>
    else if (argc == 2 && strcmp(argv[1], "-c") == 0) {
    58a4:	00003597          	auipc	a1,0x3
    58a8:	93c58593          	addi	a1,a1,-1732 # 81e0 <malloc+0x21fc>
    58ac:	00893503          	ld	a0,8(s2)
    58b0:	00000097          	auipc	ra,0x0
    58b4:	0b2080e7          	jalr	178(ra) # 5962 <strcmp>
    58b8:	c931                	beqz	a0,590c <main+0xb6>
    else if (argc == 2 && strcmp(argv[1], "-C") == 0) {
    58ba:	00003597          	auipc	a1,0x3
    58be:	91e58593          	addi	a1,a1,-1762 # 81d8 <malloc+0x21f4>
    58c2:	00893503          	ld	a0,8(s2)
    58c6:	00000097          	auipc	ra,0x0
    58ca:	09c080e7          	jalr	156(ra) # 5962 <strcmp>
    58ce:	cd05                	beqz	a0,5906 <main+0xb0>
    else if (argc == 2 && argv[1][0] != '-') {
    58d0:	00893603          	ld	a2,8(s2)
    58d4:	00064703          	lbu	a4,0(a2) # 3000 <execout+0xb4>
    58d8:	02d00793          	li	a5,45
    58dc:	00f70563          	beq	a4,a5,58e6 <main+0x90>
    int quick = 0;
    58e0:	4501                	li	a0,0
    int continuous = 0;
    58e2:	4581                	li	a1,0
    58e4:	bf49                	j	5876 <main+0x20>
        printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    58e6:	00003517          	auipc	a0,0x3
    58ea:	8aa50513          	addi	a0,a0,-1878 # 8190 <malloc+0x21ac>
    58ee:	00000097          	auipc	ra,0x0
    58f2:	63e080e7          	jalr	1598(ra) # 5f2c <printf>
        exit(1);
    58f6:	4505                	li	a0,1
    58f8:	00000097          	auipc	ra,0x0
    58fc:	2ba080e7          	jalr	698(ra) # 5bb2 <exit>
    char *justone = 0;
    5900:	4601                	li	a2,0
        quick = 1;
    5902:	4505                	li	a0,1
    5904:	bf8d                	j	5876 <main+0x20>
        continuous = 2;
    5906:	85a6                	mv	a1,s1
    char *justone = 0;
    5908:	4601                	li	a2,0
    590a:	b7b5                	j	5876 <main+0x20>
    590c:	4601                	li	a2,0
        continuous = 1;
    590e:	4585                	li	a1,1
    5910:	b79d                	j	5876 <main+0x20>
    }
    printf("ALL TESTS PASSED\n");
    5912:	00003517          	auipc	a0,0x3
    5916:	8ae50513          	addi	a0,a0,-1874 # 81c0 <malloc+0x21dc>
    591a:	00000097          	auipc	ra,0x0
    591e:	612080e7          	jalr	1554(ra) # 5f2c <printf>
    exit(0);
    5922:	4501                	li	a0,0
    5924:	00000097          	auipc	ra,0x0
    5928:	28e080e7          	jalr	654(ra) # 5bb2 <exit>

000000000000592c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    592c:	1141                	addi	sp,sp,-16
    592e:	e406                	sd	ra,8(sp)
    5930:	e022                	sd	s0,0(sp)
    5932:	0800                	addi	s0,sp,16
  extern int main();
  main();
    5934:	00000097          	auipc	ra,0x0
    5938:	f22080e7          	jalr	-222(ra) # 5856 <main>
  exit(0);
    593c:	4501                	li	a0,0
    593e:	00000097          	auipc	ra,0x0
    5942:	274080e7          	jalr	628(ra) # 5bb2 <exit>

0000000000005946 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    5946:	1141                	addi	sp,sp,-16
    5948:	e422                	sd	s0,8(sp)
    594a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    594c:	87aa                	mv	a5,a0
    594e:	0585                	addi	a1,a1,1
    5950:	0785                	addi	a5,a5,1
    5952:	fff5c703          	lbu	a4,-1(a1)
    5956:	fee78fa3          	sb	a4,-1(a5)
    595a:	fb75                	bnez	a4,594e <strcpy+0x8>
    ;
  return os;
}
    595c:	6422                	ld	s0,8(sp)
    595e:	0141                	addi	sp,sp,16
    5960:	8082                	ret

0000000000005962 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5962:	1141                	addi	sp,sp,-16
    5964:	e422                	sd	s0,8(sp)
    5966:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5968:	00054783          	lbu	a5,0(a0)
    596c:	cb91                	beqz	a5,5980 <strcmp+0x1e>
    596e:	0005c703          	lbu	a4,0(a1)
    5972:	00f71763          	bne	a4,a5,5980 <strcmp+0x1e>
    p++, q++;
    5976:	0505                	addi	a0,a0,1
    5978:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    597a:	00054783          	lbu	a5,0(a0)
    597e:	fbe5                	bnez	a5,596e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    5980:	0005c503          	lbu	a0,0(a1)
}
    5984:	40a7853b          	subw	a0,a5,a0
    5988:	6422                	ld	s0,8(sp)
    598a:	0141                	addi	sp,sp,16
    598c:	8082                	ret

000000000000598e <strlen>:

uint
strlen(const char *s)
{
    598e:	1141                	addi	sp,sp,-16
    5990:	e422                	sd	s0,8(sp)
    5992:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    5994:	00054783          	lbu	a5,0(a0)
    5998:	cf91                	beqz	a5,59b4 <strlen+0x26>
    599a:	0505                	addi	a0,a0,1
    599c:	87aa                	mv	a5,a0
    599e:	4685                	li	a3,1
    59a0:	9e89                	subw	a3,a3,a0
    59a2:	00f6853b          	addw	a0,a3,a5
    59a6:	0785                	addi	a5,a5,1
    59a8:	fff7c703          	lbu	a4,-1(a5)
    59ac:	fb7d                	bnez	a4,59a2 <strlen+0x14>
    ;
  return n;
}
    59ae:	6422                	ld	s0,8(sp)
    59b0:	0141                	addi	sp,sp,16
    59b2:	8082                	ret
  for(n = 0; s[n]; n++)
    59b4:	4501                	li	a0,0
    59b6:	bfe5                	j	59ae <strlen+0x20>

00000000000059b8 <memset>:

void*
memset(void *dst, int c, uint n)
{
    59b8:	1141                	addi	sp,sp,-16
    59ba:	e422                	sd	s0,8(sp)
    59bc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    59be:	ca19                	beqz	a2,59d4 <memset+0x1c>
    59c0:	87aa                	mv	a5,a0
    59c2:	1602                	slli	a2,a2,0x20
    59c4:	9201                	srli	a2,a2,0x20
    59c6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    59ca:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    59ce:	0785                	addi	a5,a5,1
    59d0:	fee79de3          	bne	a5,a4,59ca <memset+0x12>
  }
  return dst;
}
    59d4:	6422                	ld	s0,8(sp)
    59d6:	0141                	addi	sp,sp,16
    59d8:	8082                	ret

00000000000059da <strchr>:

char*
strchr(const char *s, char c)
{
    59da:	1141                	addi	sp,sp,-16
    59dc:	e422                	sd	s0,8(sp)
    59de:	0800                	addi	s0,sp,16
  for(; *s; s++)
    59e0:	00054783          	lbu	a5,0(a0)
    59e4:	cb99                	beqz	a5,59fa <strchr+0x20>
    if(*s == c)
    59e6:	00f58763          	beq	a1,a5,59f4 <strchr+0x1a>
  for(; *s; s++)
    59ea:	0505                	addi	a0,a0,1
    59ec:	00054783          	lbu	a5,0(a0)
    59f0:	fbfd                	bnez	a5,59e6 <strchr+0xc>
      return (char*)s;
  return 0;
    59f2:	4501                	li	a0,0
}
    59f4:	6422                	ld	s0,8(sp)
    59f6:	0141                	addi	sp,sp,16
    59f8:	8082                	ret
  return 0;
    59fa:	4501                	li	a0,0
    59fc:	bfe5                	j	59f4 <strchr+0x1a>

00000000000059fe <gets>:

char*
gets(char *buf, int max)
{
    59fe:	711d                	addi	sp,sp,-96
    5a00:	ec86                	sd	ra,88(sp)
    5a02:	e8a2                	sd	s0,80(sp)
    5a04:	e4a6                	sd	s1,72(sp)
    5a06:	e0ca                	sd	s2,64(sp)
    5a08:	fc4e                	sd	s3,56(sp)
    5a0a:	f852                	sd	s4,48(sp)
    5a0c:	f456                	sd	s5,40(sp)
    5a0e:	f05a                	sd	s6,32(sp)
    5a10:	ec5e                	sd	s7,24(sp)
    5a12:	1080                	addi	s0,sp,96
    5a14:	8baa                	mv	s7,a0
    5a16:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5a18:	892a                	mv	s2,a0
    5a1a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5a1c:	4aa9                	li	s5,10
    5a1e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5a20:	89a6                	mv	s3,s1
    5a22:	2485                	addiw	s1,s1,1
    5a24:	0344d863          	bge	s1,s4,5a54 <gets+0x56>
    cc = read(0, &c, 1);
    5a28:	4605                	li	a2,1
    5a2a:	faf40593          	addi	a1,s0,-81
    5a2e:	4501                	li	a0,0
    5a30:	00000097          	auipc	ra,0x0
    5a34:	19a080e7          	jalr	410(ra) # 5bca <read>
    if(cc < 1)
    5a38:	00a05e63          	blez	a0,5a54 <gets+0x56>
    buf[i++] = c;
    5a3c:	faf44783          	lbu	a5,-81(s0)
    5a40:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5a44:	01578763          	beq	a5,s5,5a52 <gets+0x54>
    5a48:	0905                	addi	s2,s2,1
    5a4a:	fd679be3          	bne	a5,s6,5a20 <gets+0x22>
  for(i=0; i+1 < max; ){
    5a4e:	89a6                	mv	s3,s1
    5a50:	a011                	j	5a54 <gets+0x56>
    5a52:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5a54:	99de                	add	s3,s3,s7
    5a56:	00098023          	sb	zero,0(s3)
  return buf;
}
    5a5a:	855e                	mv	a0,s7
    5a5c:	60e6                	ld	ra,88(sp)
    5a5e:	6446                	ld	s0,80(sp)
    5a60:	64a6                	ld	s1,72(sp)
    5a62:	6906                	ld	s2,64(sp)
    5a64:	79e2                	ld	s3,56(sp)
    5a66:	7a42                	ld	s4,48(sp)
    5a68:	7aa2                	ld	s5,40(sp)
    5a6a:	7b02                	ld	s6,32(sp)
    5a6c:	6be2                	ld	s7,24(sp)
    5a6e:	6125                	addi	sp,sp,96
    5a70:	8082                	ret

0000000000005a72 <stat>:

int
stat(const char *n, struct stat *st)
{
    5a72:	1101                	addi	sp,sp,-32
    5a74:	ec06                	sd	ra,24(sp)
    5a76:	e822                	sd	s0,16(sp)
    5a78:	e426                	sd	s1,8(sp)
    5a7a:	e04a                	sd	s2,0(sp)
    5a7c:	1000                	addi	s0,sp,32
    5a7e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5a80:	4581                	li	a1,0
    5a82:	00000097          	auipc	ra,0x0
    5a86:	170080e7          	jalr	368(ra) # 5bf2 <open>
  if(fd < 0)
    5a8a:	02054563          	bltz	a0,5ab4 <stat+0x42>
    5a8e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5a90:	85ca                	mv	a1,s2
    5a92:	00000097          	auipc	ra,0x0
    5a96:	178080e7          	jalr	376(ra) # 5c0a <fstat>
    5a9a:	892a                	mv	s2,a0
  close(fd);
    5a9c:	8526                	mv	a0,s1
    5a9e:	00000097          	auipc	ra,0x0
    5aa2:	13c080e7          	jalr	316(ra) # 5bda <close>
  return r;
}
    5aa6:	854a                	mv	a0,s2
    5aa8:	60e2                	ld	ra,24(sp)
    5aaa:	6442                	ld	s0,16(sp)
    5aac:	64a2                	ld	s1,8(sp)
    5aae:	6902                	ld	s2,0(sp)
    5ab0:	6105                	addi	sp,sp,32
    5ab2:	8082                	ret
    return -1;
    5ab4:	597d                	li	s2,-1
    5ab6:	bfc5                	j	5aa6 <stat+0x34>

0000000000005ab8 <atoi>:

int
atoi(const char *s)
{
    5ab8:	1141                	addi	sp,sp,-16
    5aba:	e422                	sd	s0,8(sp)
    5abc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5abe:	00054683          	lbu	a3,0(a0)
    5ac2:	fd06879b          	addiw	a5,a3,-48
    5ac6:	0ff7f793          	zext.b	a5,a5
    5aca:	4625                	li	a2,9
    5acc:	02f66863          	bltu	a2,a5,5afc <atoi+0x44>
    5ad0:	872a                	mv	a4,a0
  n = 0;
    5ad2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    5ad4:	0705                	addi	a4,a4,1
    5ad6:	0025179b          	slliw	a5,a0,0x2
    5ada:	9fa9                	addw	a5,a5,a0
    5adc:	0017979b          	slliw	a5,a5,0x1
    5ae0:	9fb5                	addw	a5,a5,a3
    5ae2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5ae6:	00074683          	lbu	a3,0(a4)
    5aea:	fd06879b          	addiw	a5,a3,-48
    5aee:	0ff7f793          	zext.b	a5,a5
    5af2:	fef671e3          	bgeu	a2,a5,5ad4 <atoi+0x1c>
  return n;
}
    5af6:	6422                	ld	s0,8(sp)
    5af8:	0141                	addi	sp,sp,16
    5afa:	8082                	ret
  n = 0;
    5afc:	4501                	li	a0,0
    5afe:	bfe5                	j	5af6 <atoi+0x3e>

0000000000005b00 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5b00:	1141                	addi	sp,sp,-16
    5b02:	e422                	sd	s0,8(sp)
    5b04:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5b06:	02b57463          	bgeu	a0,a1,5b2e <memmove+0x2e>
    while(n-- > 0)
    5b0a:	00c05f63          	blez	a2,5b28 <memmove+0x28>
    5b0e:	1602                	slli	a2,a2,0x20
    5b10:	9201                	srli	a2,a2,0x20
    5b12:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5b16:	872a                	mv	a4,a0
      *dst++ = *src++;
    5b18:	0585                	addi	a1,a1,1
    5b1a:	0705                	addi	a4,a4,1
    5b1c:	fff5c683          	lbu	a3,-1(a1)
    5b20:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5b24:	fee79ae3          	bne	a5,a4,5b18 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5b28:	6422                	ld	s0,8(sp)
    5b2a:	0141                	addi	sp,sp,16
    5b2c:	8082                	ret
    dst += n;
    5b2e:	00c50733          	add	a4,a0,a2
    src += n;
    5b32:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5b34:	fec05ae3          	blez	a2,5b28 <memmove+0x28>
    5b38:	fff6079b          	addiw	a5,a2,-1
    5b3c:	1782                	slli	a5,a5,0x20
    5b3e:	9381                	srli	a5,a5,0x20
    5b40:	fff7c793          	not	a5,a5
    5b44:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5b46:	15fd                	addi	a1,a1,-1
    5b48:	177d                	addi	a4,a4,-1
    5b4a:	0005c683          	lbu	a3,0(a1)
    5b4e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5b52:	fee79ae3          	bne	a5,a4,5b46 <memmove+0x46>
    5b56:	bfc9                	j	5b28 <memmove+0x28>

0000000000005b58 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5b58:	1141                	addi	sp,sp,-16
    5b5a:	e422                	sd	s0,8(sp)
    5b5c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5b5e:	ca05                	beqz	a2,5b8e <memcmp+0x36>
    5b60:	fff6069b          	addiw	a3,a2,-1
    5b64:	1682                	slli	a3,a3,0x20
    5b66:	9281                	srli	a3,a3,0x20
    5b68:	0685                	addi	a3,a3,1
    5b6a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5b6c:	00054783          	lbu	a5,0(a0)
    5b70:	0005c703          	lbu	a4,0(a1)
    5b74:	00e79863          	bne	a5,a4,5b84 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5b78:	0505                	addi	a0,a0,1
    p2++;
    5b7a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5b7c:	fed518e3          	bne	a0,a3,5b6c <memcmp+0x14>
  }
  return 0;
    5b80:	4501                	li	a0,0
    5b82:	a019                	j	5b88 <memcmp+0x30>
      return *p1 - *p2;
    5b84:	40e7853b          	subw	a0,a5,a4
}
    5b88:	6422                	ld	s0,8(sp)
    5b8a:	0141                	addi	sp,sp,16
    5b8c:	8082                	ret
  return 0;
    5b8e:	4501                	li	a0,0
    5b90:	bfe5                	j	5b88 <memcmp+0x30>

0000000000005b92 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5b92:	1141                	addi	sp,sp,-16
    5b94:	e406                	sd	ra,8(sp)
    5b96:	e022                	sd	s0,0(sp)
    5b98:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5b9a:	00000097          	auipc	ra,0x0
    5b9e:	f66080e7          	jalr	-154(ra) # 5b00 <memmove>
}
    5ba2:	60a2                	ld	ra,8(sp)
    5ba4:	6402                	ld	s0,0(sp)
    5ba6:	0141                	addi	sp,sp,16
    5ba8:	8082                	ret

0000000000005baa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5baa:	4885                	li	a7,1
 ecall
    5bac:	00000073          	ecall
 ret
    5bb0:	8082                	ret

0000000000005bb2 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5bb2:	4889                	li	a7,2
 ecall
    5bb4:	00000073          	ecall
 ret
    5bb8:	8082                	ret

0000000000005bba <wait>:
.global wait
wait:
 li a7, SYS_wait
    5bba:	488d                	li	a7,3
 ecall
    5bbc:	00000073          	ecall
 ret
    5bc0:	8082                	ret

0000000000005bc2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5bc2:	4891                	li	a7,4
 ecall
    5bc4:	00000073          	ecall
 ret
    5bc8:	8082                	ret

0000000000005bca <read>:
.global read
read:
 li a7, SYS_read
    5bca:	4895                	li	a7,5
 ecall
    5bcc:	00000073          	ecall
 ret
    5bd0:	8082                	ret

0000000000005bd2 <write>:
.global write
write:
 li a7, SYS_write
    5bd2:	48c1                	li	a7,16
 ecall
    5bd4:	00000073          	ecall
 ret
    5bd8:	8082                	ret

0000000000005bda <close>:
.global close
close:
 li a7, SYS_close
    5bda:	48d5                	li	a7,21
 ecall
    5bdc:	00000073          	ecall
 ret
    5be0:	8082                	ret

0000000000005be2 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5be2:	4899                	li	a7,6
 ecall
    5be4:	00000073          	ecall
 ret
    5be8:	8082                	ret

0000000000005bea <exec>:
.global exec
exec:
 li a7, SYS_exec
    5bea:	489d                	li	a7,7
 ecall
    5bec:	00000073          	ecall
 ret
    5bf0:	8082                	ret

0000000000005bf2 <open>:
.global open
open:
 li a7, SYS_open
    5bf2:	48bd                	li	a7,15
 ecall
    5bf4:	00000073          	ecall
 ret
    5bf8:	8082                	ret

0000000000005bfa <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5bfa:	48c5                	li	a7,17
 ecall
    5bfc:	00000073          	ecall
 ret
    5c00:	8082                	ret

0000000000005c02 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5c02:	48c9                	li	a7,18
 ecall
    5c04:	00000073          	ecall
 ret
    5c08:	8082                	ret

0000000000005c0a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5c0a:	48a1                	li	a7,8
 ecall
    5c0c:	00000073          	ecall
 ret
    5c10:	8082                	ret

0000000000005c12 <link>:
.global link
link:
 li a7, SYS_link
    5c12:	48cd                	li	a7,19
 ecall
    5c14:	00000073          	ecall
 ret
    5c18:	8082                	ret

0000000000005c1a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5c1a:	48d1                	li	a7,20
 ecall
    5c1c:	00000073          	ecall
 ret
    5c20:	8082                	ret

0000000000005c22 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5c22:	48a5                	li	a7,9
 ecall
    5c24:	00000073          	ecall
 ret
    5c28:	8082                	ret

0000000000005c2a <dup>:
.global dup
dup:
 li a7, SYS_dup
    5c2a:	48a9                	li	a7,10
 ecall
    5c2c:	00000073          	ecall
 ret
    5c30:	8082                	ret

0000000000005c32 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5c32:	48ad                	li	a7,11
 ecall
    5c34:	00000073          	ecall
 ret
    5c38:	8082                	ret

0000000000005c3a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5c3a:	48b1                	li	a7,12
 ecall
    5c3c:	00000073          	ecall
 ret
    5c40:	8082                	ret

0000000000005c42 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5c42:	48b5                	li	a7,13
 ecall
    5c44:	00000073          	ecall
 ret
    5c48:	8082                	ret

0000000000005c4a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5c4a:	48b9                	li	a7,14
 ecall
    5c4c:	00000073          	ecall
 ret
    5c50:	8082                	ret

0000000000005c52 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5c52:	1101                	addi	sp,sp,-32
    5c54:	ec06                	sd	ra,24(sp)
    5c56:	e822                	sd	s0,16(sp)
    5c58:	1000                	addi	s0,sp,32
    5c5a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5c5e:	4605                	li	a2,1
    5c60:	fef40593          	addi	a1,s0,-17
    5c64:	00000097          	auipc	ra,0x0
    5c68:	f6e080e7          	jalr	-146(ra) # 5bd2 <write>
}
    5c6c:	60e2                	ld	ra,24(sp)
    5c6e:	6442                	ld	s0,16(sp)
    5c70:	6105                	addi	sp,sp,32
    5c72:	8082                	ret

0000000000005c74 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5c74:	7139                	addi	sp,sp,-64
    5c76:	fc06                	sd	ra,56(sp)
    5c78:	f822                	sd	s0,48(sp)
    5c7a:	f426                	sd	s1,40(sp)
    5c7c:	f04a                	sd	s2,32(sp)
    5c7e:	ec4e                	sd	s3,24(sp)
    5c80:	0080                	addi	s0,sp,64
    5c82:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5c84:	c299                	beqz	a3,5c8a <printint+0x16>
    5c86:	0805c963          	bltz	a1,5d18 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5c8a:	2581                	sext.w	a1,a1
  neg = 0;
    5c8c:	4881                	li	a7,0
    5c8e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5c92:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5c94:	2601                	sext.w	a2,a2
    5c96:	00003517          	auipc	a0,0x3
    5c9a:	91250513          	addi	a0,a0,-1774 # 85a8 <digits>
    5c9e:	883a                	mv	a6,a4
    5ca0:	2705                	addiw	a4,a4,1
    5ca2:	02c5f7bb          	remuw	a5,a1,a2
    5ca6:	1782                	slli	a5,a5,0x20
    5ca8:	9381                	srli	a5,a5,0x20
    5caa:	97aa                	add	a5,a5,a0
    5cac:	0007c783          	lbu	a5,0(a5)
    5cb0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5cb4:	0005879b          	sext.w	a5,a1
    5cb8:	02c5d5bb          	divuw	a1,a1,a2
    5cbc:	0685                	addi	a3,a3,1
    5cbe:	fec7f0e3          	bgeu	a5,a2,5c9e <printint+0x2a>
  if(neg)
    5cc2:	00088c63          	beqz	a7,5cda <printint+0x66>
    buf[i++] = '-';
    5cc6:	fd070793          	addi	a5,a4,-48
    5cca:	00878733          	add	a4,a5,s0
    5cce:	02d00793          	li	a5,45
    5cd2:	fef70823          	sb	a5,-16(a4)
    5cd6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5cda:	02e05863          	blez	a4,5d0a <printint+0x96>
    5cde:	fc040793          	addi	a5,s0,-64
    5ce2:	00e78933          	add	s2,a5,a4
    5ce6:	fff78993          	addi	s3,a5,-1
    5cea:	99ba                	add	s3,s3,a4
    5cec:	377d                	addiw	a4,a4,-1
    5cee:	1702                	slli	a4,a4,0x20
    5cf0:	9301                	srli	a4,a4,0x20
    5cf2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5cf6:	fff94583          	lbu	a1,-1(s2)
    5cfa:	8526                	mv	a0,s1
    5cfc:	00000097          	auipc	ra,0x0
    5d00:	f56080e7          	jalr	-170(ra) # 5c52 <putc>
  while(--i >= 0)
    5d04:	197d                	addi	s2,s2,-1
    5d06:	ff3918e3          	bne	s2,s3,5cf6 <printint+0x82>
}
    5d0a:	70e2                	ld	ra,56(sp)
    5d0c:	7442                	ld	s0,48(sp)
    5d0e:	74a2                	ld	s1,40(sp)
    5d10:	7902                	ld	s2,32(sp)
    5d12:	69e2                	ld	s3,24(sp)
    5d14:	6121                	addi	sp,sp,64
    5d16:	8082                	ret
    x = -xx;
    5d18:	40b005bb          	negw	a1,a1
    neg = 1;
    5d1c:	4885                	li	a7,1
    x = -xx;
    5d1e:	bf85                	j	5c8e <printint+0x1a>

0000000000005d20 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5d20:	7119                	addi	sp,sp,-128
    5d22:	fc86                	sd	ra,120(sp)
    5d24:	f8a2                	sd	s0,112(sp)
    5d26:	f4a6                	sd	s1,104(sp)
    5d28:	f0ca                	sd	s2,96(sp)
    5d2a:	ecce                	sd	s3,88(sp)
    5d2c:	e8d2                	sd	s4,80(sp)
    5d2e:	e4d6                	sd	s5,72(sp)
    5d30:	e0da                	sd	s6,64(sp)
    5d32:	fc5e                	sd	s7,56(sp)
    5d34:	f862                	sd	s8,48(sp)
    5d36:	f466                	sd	s9,40(sp)
    5d38:	f06a                	sd	s10,32(sp)
    5d3a:	ec6e                	sd	s11,24(sp)
    5d3c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5d3e:	0005c903          	lbu	s2,0(a1)
    5d42:	18090f63          	beqz	s2,5ee0 <vprintf+0x1c0>
    5d46:	8aaa                	mv	s5,a0
    5d48:	8b32                	mv	s6,a2
    5d4a:	00158493          	addi	s1,a1,1
  state = 0;
    5d4e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5d50:	02500a13          	li	s4,37
    5d54:	4c55                	li	s8,21
    5d56:	00002c97          	auipc	s9,0x2
    5d5a:	7fac8c93          	addi	s9,s9,2042 # 8550 <malloc+0x256c>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    5d5e:	02800d93          	li	s11,40
  putc(fd, 'x');
    5d62:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5d64:	00003b97          	auipc	s7,0x3
    5d68:	844b8b93          	addi	s7,s7,-1980 # 85a8 <digits>
    5d6c:	a839                	j	5d8a <vprintf+0x6a>
        putc(fd, c);
    5d6e:	85ca                	mv	a1,s2
    5d70:	8556                	mv	a0,s5
    5d72:	00000097          	auipc	ra,0x0
    5d76:	ee0080e7          	jalr	-288(ra) # 5c52 <putc>
    5d7a:	a019                	j	5d80 <vprintf+0x60>
    } else if(state == '%'){
    5d7c:	01498d63          	beq	s3,s4,5d96 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
    5d80:	0485                	addi	s1,s1,1
    5d82:	fff4c903          	lbu	s2,-1(s1)
    5d86:	14090d63          	beqz	s2,5ee0 <vprintf+0x1c0>
    if(state == 0){
    5d8a:	fe0999e3          	bnez	s3,5d7c <vprintf+0x5c>
      if(c == '%'){
    5d8e:	ff4910e3          	bne	s2,s4,5d6e <vprintf+0x4e>
        state = '%';
    5d92:	89d2                	mv	s3,s4
    5d94:	b7f5                	j	5d80 <vprintf+0x60>
      if(c == 'd'){
    5d96:	11490c63          	beq	s2,s4,5eae <vprintf+0x18e>
    5d9a:	f9d9079b          	addiw	a5,s2,-99
    5d9e:	0ff7f793          	zext.b	a5,a5
    5da2:	10fc6e63          	bltu	s8,a5,5ebe <vprintf+0x19e>
    5da6:	f9d9079b          	addiw	a5,s2,-99
    5daa:	0ff7f713          	zext.b	a4,a5
    5dae:	10ec6863          	bltu	s8,a4,5ebe <vprintf+0x19e>
    5db2:	00271793          	slli	a5,a4,0x2
    5db6:	97e6                	add	a5,a5,s9
    5db8:	439c                	lw	a5,0(a5)
    5dba:	97e6                	add	a5,a5,s9
    5dbc:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    5dbe:	008b0913          	addi	s2,s6,8
    5dc2:	4685                	li	a3,1
    5dc4:	4629                	li	a2,10
    5dc6:	000b2583          	lw	a1,0(s6)
    5dca:	8556                	mv	a0,s5
    5dcc:	00000097          	auipc	ra,0x0
    5dd0:	ea8080e7          	jalr	-344(ra) # 5c74 <printint>
    5dd4:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    5dd6:	4981                	li	s3,0
    5dd8:	b765                	j	5d80 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5dda:	008b0913          	addi	s2,s6,8
    5dde:	4681                	li	a3,0
    5de0:	4629                	li	a2,10
    5de2:	000b2583          	lw	a1,0(s6)
    5de6:	8556                	mv	a0,s5
    5de8:	00000097          	auipc	ra,0x0
    5dec:	e8c080e7          	jalr	-372(ra) # 5c74 <printint>
    5df0:	8b4a                	mv	s6,s2
      state = 0;
    5df2:	4981                	li	s3,0
    5df4:	b771                	j	5d80 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5df6:	008b0913          	addi	s2,s6,8
    5dfa:	4681                	li	a3,0
    5dfc:	866a                	mv	a2,s10
    5dfe:	000b2583          	lw	a1,0(s6)
    5e02:	8556                	mv	a0,s5
    5e04:	00000097          	auipc	ra,0x0
    5e08:	e70080e7          	jalr	-400(ra) # 5c74 <printint>
    5e0c:	8b4a                	mv	s6,s2
      state = 0;
    5e0e:	4981                	li	s3,0
    5e10:	bf85                	j	5d80 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5e12:	008b0793          	addi	a5,s6,8
    5e16:	f8f43423          	sd	a5,-120(s0)
    5e1a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5e1e:	03000593          	li	a1,48
    5e22:	8556                	mv	a0,s5
    5e24:	00000097          	auipc	ra,0x0
    5e28:	e2e080e7          	jalr	-466(ra) # 5c52 <putc>
  putc(fd, 'x');
    5e2c:	07800593          	li	a1,120
    5e30:	8556                	mv	a0,s5
    5e32:	00000097          	auipc	ra,0x0
    5e36:	e20080e7          	jalr	-480(ra) # 5c52 <putc>
    5e3a:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5e3c:	03c9d793          	srli	a5,s3,0x3c
    5e40:	97de                	add	a5,a5,s7
    5e42:	0007c583          	lbu	a1,0(a5)
    5e46:	8556                	mv	a0,s5
    5e48:	00000097          	auipc	ra,0x0
    5e4c:	e0a080e7          	jalr	-502(ra) # 5c52 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5e50:	0992                	slli	s3,s3,0x4
    5e52:	397d                	addiw	s2,s2,-1
    5e54:	fe0914e3          	bnez	s2,5e3c <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
    5e58:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5e5c:	4981                	li	s3,0
    5e5e:	b70d                	j	5d80 <vprintf+0x60>
        s = va_arg(ap, char*);
    5e60:	008b0913          	addi	s2,s6,8
    5e64:	000b3983          	ld	s3,0(s6)
        if(s == 0)
    5e68:	02098163          	beqz	s3,5e8a <vprintf+0x16a>
        while(*s != 0){
    5e6c:	0009c583          	lbu	a1,0(s3)
    5e70:	c5ad                	beqz	a1,5eda <vprintf+0x1ba>
          putc(fd, *s);
    5e72:	8556                	mv	a0,s5
    5e74:	00000097          	auipc	ra,0x0
    5e78:	dde080e7          	jalr	-546(ra) # 5c52 <putc>
          s++;
    5e7c:	0985                	addi	s3,s3,1
        while(*s != 0){
    5e7e:	0009c583          	lbu	a1,0(s3)
    5e82:	f9e5                	bnez	a1,5e72 <vprintf+0x152>
        s = va_arg(ap, char*);
    5e84:	8b4a                	mv	s6,s2
      state = 0;
    5e86:	4981                	li	s3,0
    5e88:	bde5                	j	5d80 <vprintf+0x60>
          s = "(null)";
    5e8a:	00002997          	auipc	s3,0x2
    5e8e:	6be98993          	addi	s3,s3,1726 # 8548 <malloc+0x2564>
        while(*s != 0){
    5e92:	85ee                	mv	a1,s11
    5e94:	bff9                	j	5e72 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
    5e96:	008b0913          	addi	s2,s6,8
    5e9a:	000b4583          	lbu	a1,0(s6)
    5e9e:	8556                	mv	a0,s5
    5ea0:	00000097          	auipc	ra,0x0
    5ea4:	db2080e7          	jalr	-590(ra) # 5c52 <putc>
    5ea8:	8b4a                	mv	s6,s2
      state = 0;
    5eaa:	4981                	li	s3,0
    5eac:	bdd1                	j	5d80 <vprintf+0x60>
        putc(fd, c);
    5eae:	85d2                	mv	a1,s4
    5eb0:	8556                	mv	a0,s5
    5eb2:	00000097          	auipc	ra,0x0
    5eb6:	da0080e7          	jalr	-608(ra) # 5c52 <putc>
      state = 0;
    5eba:	4981                	li	s3,0
    5ebc:	b5d1                	j	5d80 <vprintf+0x60>
        putc(fd, '%');
    5ebe:	85d2                	mv	a1,s4
    5ec0:	8556                	mv	a0,s5
    5ec2:	00000097          	auipc	ra,0x0
    5ec6:	d90080e7          	jalr	-624(ra) # 5c52 <putc>
        putc(fd, c);
    5eca:	85ca                	mv	a1,s2
    5ecc:	8556                	mv	a0,s5
    5ece:	00000097          	auipc	ra,0x0
    5ed2:	d84080e7          	jalr	-636(ra) # 5c52 <putc>
      state = 0;
    5ed6:	4981                	li	s3,0
    5ed8:	b565                	j	5d80 <vprintf+0x60>
        s = va_arg(ap, char*);
    5eda:	8b4a                	mv	s6,s2
      state = 0;
    5edc:	4981                	li	s3,0
    5ede:	b54d                	j	5d80 <vprintf+0x60>
    }
  }
}
    5ee0:	70e6                	ld	ra,120(sp)
    5ee2:	7446                	ld	s0,112(sp)
    5ee4:	74a6                	ld	s1,104(sp)
    5ee6:	7906                	ld	s2,96(sp)
    5ee8:	69e6                	ld	s3,88(sp)
    5eea:	6a46                	ld	s4,80(sp)
    5eec:	6aa6                	ld	s5,72(sp)
    5eee:	6b06                	ld	s6,64(sp)
    5ef0:	7be2                	ld	s7,56(sp)
    5ef2:	7c42                	ld	s8,48(sp)
    5ef4:	7ca2                	ld	s9,40(sp)
    5ef6:	7d02                	ld	s10,32(sp)
    5ef8:	6de2                	ld	s11,24(sp)
    5efa:	6109                	addi	sp,sp,128
    5efc:	8082                	ret

0000000000005efe <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5efe:	715d                	addi	sp,sp,-80
    5f00:	ec06                	sd	ra,24(sp)
    5f02:	e822                	sd	s0,16(sp)
    5f04:	1000                	addi	s0,sp,32
    5f06:	e010                	sd	a2,0(s0)
    5f08:	e414                	sd	a3,8(s0)
    5f0a:	e818                	sd	a4,16(s0)
    5f0c:	ec1c                	sd	a5,24(s0)
    5f0e:	03043023          	sd	a6,32(s0)
    5f12:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5f16:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5f1a:	8622                	mv	a2,s0
    5f1c:	00000097          	auipc	ra,0x0
    5f20:	e04080e7          	jalr	-508(ra) # 5d20 <vprintf>
}
    5f24:	60e2                	ld	ra,24(sp)
    5f26:	6442                	ld	s0,16(sp)
    5f28:	6161                	addi	sp,sp,80
    5f2a:	8082                	ret

0000000000005f2c <printf>:

void
printf(const char *fmt, ...)
{
    5f2c:	711d                	addi	sp,sp,-96
    5f2e:	ec06                	sd	ra,24(sp)
    5f30:	e822                	sd	s0,16(sp)
    5f32:	1000                	addi	s0,sp,32
    5f34:	e40c                	sd	a1,8(s0)
    5f36:	e810                	sd	a2,16(s0)
    5f38:	ec14                	sd	a3,24(s0)
    5f3a:	f018                	sd	a4,32(s0)
    5f3c:	f41c                	sd	a5,40(s0)
    5f3e:	03043823          	sd	a6,48(s0)
    5f42:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5f46:	00840613          	addi	a2,s0,8
    5f4a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5f4e:	85aa                	mv	a1,a0
    5f50:	4505                	li	a0,1
    5f52:	00000097          	auipc	ra,0x0
    5f56:	dce080e7          	jalr	-562(ra) # 5d20 <vprintf>
}
    5f5a:	60e2                	ld	ra,24(sp)
    5f5c:	6442                	ld	s0,16(sp)
    5f5e:	6125                	addi	sp,sp,96
    5f60:	8082                	ret

0000000000005f62 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5f62:	1141                	addi	sp,sp,-16
    5f64:	e422                	sd	s0,8(sp)
    5f66:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5f68:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5f6c:	00003797          	auipc	a5,0x3
    5f70:	4e47b783          	ld	a5,1252(a5) # 9450 <freep>
    5f74:	a02d                	j	5f9e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5f76:	4618                	lw	a4,8(a2)
    5f78:	9f2d                	addw	a4,a4,a1
    5f7a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5f7e:	6398                	ld	a4,0(a5)
    5f80:	6310                	ld	a2,0(a4)
    5f82:	a83d                	j	5fc0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5f84:	ff852703          	lw	a4,-8(a0)
    5f88:	9f31                	addw	a4,a4,a2
    5f8a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5f8c:	ff053683          	ld	a3,-16(a0)
    5f90:	a091                	j	5fd4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5f92:	6398                	ld	a4,0(a5)
    5f94:	00e7e463          	bltu	a5,a4,5f9c <free+0x3a>
    5f98:	00e6ea63          	bltu	a3,a4,5fac <free+0x4a>
{
    5f9c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5f9e:	fed7fae3          	bgeu	a5,a3,5f92 <free+0x30>
    5fa2:	6398                	ld	a4,0(a5)
    5fa4:	00e6e463          	bltu	a3,a4,5fac <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5fa8:	fee7eae3          	bltu	a5,a4,5f9c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    5fac:	ff852583          	lw	a1,-8(a0)
    5fb0:	6390                	ld	a2,0(a5)
    5fb2:	02059813          	slli	a6,a1,0x20
    5fb6:	01c85713          	srli	a4,a6,0x1c
    5fba:	9736                	add	a4,a4,a3
    5fbc:	fae60de3          	beq	a2,a4,5f76 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    5fc0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5fc4:	4790                	lw	a2,8(a5)
    5fc6:	02061593          	slli	a1,a2,0x20
    5fca:	01c5d713          	srli	a4,a1,0x1c
    5fce:	973e                	add	a4,a4,a5
    5fd0:	fae68ae3          	beq	a3,a4,5f84 <free+0x22>
    p->s.ptr = bp->s.ptr;
    5fd4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5fd6:	00003717          	auipc	a4,0x3
    5fda:	46f73d23          	sd	a5,1146(a4) # 9450 <freep>
}
    5fde:	6422                	ld	s0,8(sp)
    5fe0:	0141                	addi	sp,sp,16
    5fe2:	8082                	ret

0000000000005fe4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5fe4:	7139                	addi	sp,sp,-64
    5fe6:	fc06                	sd	ra,56(sp)
    5fe8:	f822                	sd	s0,48(sp)
    5fea:	f426                	sd	s1,40(sp)
    5fec:	f04a                	sd	s2,32(sp)
    5fee:	ec4e                	sd	s3,24(sp)
    5ff0:	e852                	sd	s4,16(sp)
    5ff2:	e456                	sd	s5,8(sp)
    5ff4:	e05a                	sd	s6,0(sp)
    5ff6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5ff8:	02051493          	slli	s1,a0,0x20
    5ffc:	9081                	srli	s1,s1,0x20
    5ffe:	04bd                	addi	s1,s1,15
    6000:	8091                	srli	s1,s1,0x4
    6002:	0014899b          	addiw	s3,s1,1
    6006:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    6008:	00003517          	auipc	a0,0x3
    600c:	44853503          	ld	a0,1096(a0) # 9450 <freep>
    6010:	c515                	beqz	a0,603c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    6012:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    6014:	4798                	lw	a4,8(a5)
    6016:	02977f63          	bgeu	a4,s1,6054 <malloc+0x70>
    601a:	8a4e                	mv	s4,s3
    601c:	0009871b          	sext.w	a4,s3
    6020:	6685                	lui	a3,0x1
    6022:	00d77363          	bgeu	a4,a3,6028 <malloc+0x44>
    6026:	6a05                	lui	s4,0x1
    6028:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    602c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    6030:	00003917          	auipc	s2,0x3
    6034:	42090913          	addi	s2,s2,1056 # 9450 <freep>
  if(p == (char*)-1)
    6038:	5afd                	li	s5,-1
    603a:	a895                	j	60ae <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    603c:	0000a797          	auipc	a5,0xa
    6040:	c3c78793          	addi	a5,a5,-964 # fc78 <base>
    6044:	00003717          	auipc	a4,0x3
    6048:	40f73623          	sd	a5,1036(a4) # 9450 <freep>
    604c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    604e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    6052:	b7e1                	j	601a <malloc+0x36>
      if(p->s.size == nunits)
    6054:	02e48c63          	beq	s1,a4,608c <malloc+0xa8>
        p->s.size -= nunits;
    6058:	4137073b          	subw	a4,a4,s3
    605c:	c798                	sw	a4,8(a5)
        p += p->s.size;
    605e:	02071693          	slli	a3,a4,0x20
    6062:	01c6d713          	srli	a4,a3,0x1c
    6066:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    6068:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    606c:	00003717          	auipc	a4,0x3
    6070:	3ea73223          	sd	a0,996(a4) # 9450 <freep>
      return (void*)(p + 1);
    6074:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    6078:	70e2                	ld	ra,56(sp)
    607a:	7442                	ld	s0,48(sp)
    607c:	74a2                	ld	s1,40(sp)
    607e:	7902                	ld	s2,32(sp)
    6080:	69e2                	ld	s3,24(sp)
    6082:	6a42                	ld	s4,16(sp)
    6084:	6aa2                	ld	s5,8(sp)
    6086:	6b02                	ld	s6,0(sp)
    6088:	6121                	addi	sp,sp,64
    608a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    608c:	6398                	ld	a4,0(a5)
    608e:	e118                	sd	a4,0(a0)
    6090:	bff1                	j	606c <malloc+0x88>
  hp->s.size = nu;
    6092:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    6096:	0541                	addi	a0,a0,16
    6098:	00000097          	auipc	ra,0x0
    609c:	eca080e7          	jalr	-310(ra) # 5f62 <free>
  return freep;
    60a0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    60a4:	d971                	beqz	a0,6078 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    60a6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    60a8:	4798                	lw	a4,8(a5)
    60aa:	fa9775e3          	bgeu	a4,s1,6054 <malloc+0x70>
    if(p == freep)
    60ae:	00093703          	ld	a4,0(s2)
    60b2:	853e                	mv	a0,a5
    60b4:	fef719e3          	bne	a4,a5,60a6 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    60b8:	8552                	mv	a0,s4
    60ba:	00000097          	auipc	ra,0x0
    60be:	b80080e7          	jalr	-1152(ra) # 5c3a <sbrk>
  if(p == (char*)-1)
    60c2:	fd5518e3          	bne	a0,s5,6092 <malloc+0xae>
        return 0;
    60c6:	4501                	li	a0,0
    60c8:	bf45                	j	6078 <malloc+0x94>
